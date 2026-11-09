#!/usr/bin/env python3
"""Replay exact diagnostics; require the separately recorded universal Lean proof."""

import argparse
import itertools
import json
from fractions import Fraction as Q
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
RHO = Q(32, 25)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def mass(values, indices):
    return sum((values[i] for i in indices), Q(0))


def budget(a, b):
    value = min(x * y for x, y in zip(a, b))
    require(value > 0, "Mass products must be positive.")
    count = 0
    while value <= 1:
        value *= RHO
        count += 1
    return count


class Solver:
    def __init__(self, owners, edges):
        self.owners = owners
        self.edges = edges
        self.n = len(owners)
        require(self.n > 0 and len(edges) == self.n, "Invalid graph dimension.")
        require(all(edges), "Sinks are not admissible.")
        self.cache = {}
        self.traces = {}
        self.invocations = 0

    def operator(self, z):
        return tuple(
            (max if owner == "max" else min)(w + z[j] for j, w in outgoing)
            for owner, outgoing in zip(self.owners, self.edges)
        )

    def basic(self, A, D):
        p = A
        for _ in range(1 + self.n * D):
            fp = self.operator(p)
            q = tuple(min(A[i] + D, max(A[i], fp[i])) for i in range(self.n))
            if q == p:
                return p
            require(all(x <= y for x, y in zip(p, q)), "Basic is not monotone.")
            p = q
        raise AssertionError("Basic exceeded the stated bound, including stability.")

    def solve(self, A, d, a, b):
        self.invocations += 1
        require(self.invocations <= 200000, "Bounded replay exhausted; no conclusion.")
        key = (A, d, a, b)
        if key in self.cache:
            return self.cache[key]
        D = 2**d
        if all(x * y > 1 for x, y in zip(a, b)):
            labels = tuple(y > 1 for y in b)
        elif D < 4096:
            z = self.basic(A, D)
            labels = tuple(2 * z[i] > 2 * A[i] + D for i in range(self.n))
        else:
            c = tuple(x + D // 2 for x in A)
            M, q, p = D // 8, D // 128, D // 4096
            parent_rank = d + budget(a, b)

            def child(B, e, aa, bb):
                require(e + budget(aa, bb) < parent_rank, "Rank failed to decrease.")
                return self.solve(B, e, aa, bb)

            k = c
            counts = []
            for downward in (True, False):
                calls = 0
                while True:
                    aa = a if downward else tuple(Q(4, 3) * x for x in a)
                    bb = tuple(Q(4, 3) * x for x in b) if downward else b
                    labels = child(tuple(x - q // 2 for x in k), d - 7, aa, bb)
                    calls += 1
                    knew = tuple(
                        max(c[i] - M, k[i] - p) if downward and not labels[i]
                        else min(c[i] + M, k[i] + p) if not downward and labels[i]
                        else k[i]
                        for i in range(self.n)
                    )
                    require(calls <= 1024 * self.n + 1, "Pivot pass exceeded its bound.")
                    if knew == k:
                        break
                    k = knew
                counts.append(calls)
                if downward:
                    kd = k
            kf = k
            l0 = child(tuple(x - D // 4 for x in kf), d - 1, a, b)
            aa = tuple(x * (Q(4, 5) if l0[i] else Q(8, 5)) for i, x in enumerate(a))
            bb = tuple(x * (Q(8, 5) if l0[i] else Q(4, 5)) for i, x in enumerate(b))
            require(all(aa[i] * bb[i] == RHO * a[i] * b[i] for i in range(self.n)),
                    "Reweighting product identity failed.")
            lc = child(A, d, aa, bb)
            im = {i for i in range(self.n) if kd[i] < c[i] - D // 32}
            ip = {i for i in range(self.n) if kf[i] > c[i] + D // 32}
            labels = tuple(False if i in im else True if i in ip else lc[i]
                           for i in range(self.n))
            self.traces[key] = (kd, kf, l0, aa, bb, im, ip, counts)
        self.cache[key] = labels
        return labels

    def witness(self, A, D, m, z, is_max):
        fz = self.operator(z)
        support = {i for i in range(self.n)
                   if z[i] > A[i]} if is_max else {
                       i for i in range(self.n) if z[i] < A[i] + D}
        admissible = mass(m, support) <= 1 and all(
            z[i] <= fz[i] if is_max else z[i] >= fz[i] for i in support
        )
        claims = {
            i for i in range(self.n)
            if (32 * z[i] >= 32 * (A[i] + D) - D if is_max
                else 32 * z[i] <= 32 * A[i] + D)
        }
        return admissible, support, claims

    def replay_witnesses(self, A, d, a, b, labels):
        D = 2**d
        offsets = sorted({0, min(1, D), D // 32, D // 2,
                          (31 * D + 31) // 32, max(0, D - 1), D})
        checked = 0
        for offset in itertools.product(offsets, repeat=self.n):
            z = tuple(A[i] + offset[i] for i in range(self.n))
            for is_max, m in ((True, a), (False, b)):
                admissible, support, claims = self.witness(A, D, m, z, is_max)
                if not admissible:
                    continue
                checked += 1
                require(all(labels[i] == is_max for i in claims),
                        "A sampled admissible parent witness was mislabeled.")
                if not claims or D < 4096:
                    continue
                kd, kf, l0, aa, bb, im, ip, _ = self.traces[(A, d, a, b)]
                require(not claims.intersection(im if is_max else ip),
                        "An override conflicts with an admissible witness.")
                for k in (kd, kf):
                    deviations = tuple(z[i] - k[i] if is_max else k[i] - z[i]
                                       for i in range(self.n))
                    peak = max(deviations)
                    gaps = tuple(peak - x for x in deviations)
                    for r in (D // 128, D // 2):
                        B = tuple(x - r // 2 for x in k)
                        translated = tuple(
                            max(B[i], z[i] - peak + r // 2) if is_max
                            else min(k[i] + r // 2, z[i] + peak - r // 2)
                            for i in range(self.n)
                        )
                        ok, new_support, new_claims = self.witness(
                            B, r, m, translated, is_max)
                        require(ok, "Translated witness is not admissible.")
                        require(new_support == {i for i in range(self.n) if gaps[i] < r},
                                "Translated support does not use a strict gap threshold.")
                        require(new_support <= support, "Translation enlarged support.")
                        require({i for i in range(self.n) if 32 * gaps[i] <= r}
                                <= new_claims, "A translated boundary claim was lost.")
                unsettled = claims - (ip if is_max else im)
                if unsettled:
                    deviations = tuple(z[i] - kf[i] if is_max else kf[i] - z[i]
                                       for i in range(self.n))
                    peak = max(deviations)
                    near = {i for i in range(self.n) if peak - deviations[i] < D // 128}
                    require(mass(m, near) > Q(3, 4), "Stopped-pivot mass is not strict.")
                    require(all(l0[i] == is_max for i in near),
                            "Provisional labels do not favor the heavy support.")
                    require(mass(aa if is_max else bb, support) < 1,
                            "Unsettled witness did not survive reweighting.")
        return checked


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch.")
    require(response["server"]["version"] == "0.14.0", "Unexpected server version.")
    require(response["protocol_version"] == "2025-11-25", "Unexpected protocol.")
    require(response["result"]["operation_id"]
            == "optimization.linear.rational_general_optimum.compute", "Wrong operation.")
    out = response["result"]["output"]
    require(out["status"] == "OPTIMAL", "Jacobian did not conclude OPTIMAL.")

    def rational(value):
        return Q(int(value["num"]), int(value["den"]))

    s, g = map(rational, out["primal_candidate"])
    require(0 <= s <= 1 and Q(3, 4) <= g <= s, "Invalid exact LP point.")
    require(Q(8, 5) * s - Q(4, 5) * g == 1, "Wrong LP optimum.")
    require(rational(out["dual_objective"]) == rational(out["primal_objective"]) == 1,
            "The primal and dual objectives differ.")
    require(all(rational(x) == 0 for x in out["stationarity_residuals"]),
            "Nonzero LP stationarity residual.")
    row = list(map(rational, out["constraint_dual"]))
    lower = list(map(rational, out["lower_bound_dual"]))
    upper = list(map(rational, out["upper_bound_dual"]))
    require(row == [0] and lower == [0, -Q(4, 5)] and upper == [Q(8, 5), 0],
            "Unexpected source-coordinate dual certificate.")
    require(Q(8, 5) - Q(4, 5) * Q(3, 4) == 1, "Threshold identity failed.")
    require(Q(4, 5) * Q(8, 5) == RHO <= Q(4, 3), "Rank multiplier failed.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exact-only", action="store_true",
                        help="Run finite diagnostics only; not universal certification.")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    check_jacobian()
    results = []
    for case in certificate["finite_replay_cases"]:
        n = len(case["owners"])
        original_edges = case["original_edges"]
        edges = tuple(tuple((j, (n + 1) * w + 1) for j, w in outgoing)
                      for outgoing in original_edges)
        solver = Solver(tuple(case["owners"]), edges)
        A, d = tuple(case["A"]), case["d"]
        a, b = tuple(map(Q, case["a"])), tuple(map(Q, case["b"]))
        labels = solver.solve(A, d, a, b)
        require(list(labels) == case["expected_labels"], f"Wrong labels in {case['name']}.")
        count = solver.replay_witnesses(A, d, a, b, labels)
        results.append({"case": case["name"], "sampled_witnesses_checked": count,
                        "child_invocations": solver.invocations})
    if not args.exact_only:
        require(certificate["formal_status"] == "compiler_verified",
                "The universal formal certificate is not yet available.")
        require((ROOT / certificate["source"]).is_file(), "The Lean source is missing.")
        require((HERE / "STATEMENT_FIDELITY.md").read_bytes()
                == (HERE / "statement_fidelity.md").read_bytes(),
                "The requested and compiler-canonical fidelity documents differ.")
        formal = json.loads((HERE / "lean_verify_result.json").read_text())
        require(formal["status"] == "success" and formal["exit_code"] == 0
                and formal["audit_exit_code"] == 0 and formal["proof_holes"] == [],
                "The saved compiler/axiom audit did not certify the formal source.")
        recorded = formal["kernel"]["recorded"]
        require(recorded["subject"]["subject_id"] == certificate["claim_id"]
                and recorded["artifact"] == certificate["compiler_certificate"]
                and recorded["tier"] == "mechanical" and recorded["verdict"] == "supports",
                "The saved mechanical evidence is not for the claimed theorem.")
        completed = subprocess.run(
            [ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence",
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True, check=False,
        )
        require(completed.returncode == 0,
                "Formal evidence check failed:\n" + completed.stdout + completed.stderr)
    print(json.dumps({
        "exact_diagnostics": "passed",
        "scope": "finite_diagnostics_only" if args.exact_only
                 else "finite_diagnostics_and_recorded_universal_Lean_evidence",
        "independent_review": certificate["independent_review"],
        "cases": results,
    }, indent=2))


if __name__ == "__main__":
    main()
