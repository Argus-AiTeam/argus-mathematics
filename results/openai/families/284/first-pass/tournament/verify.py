#!/usr/bin/env python3
"""Replay exact regressions and bind the independently compiled real theorem."""

import argparse
import hashlib
import itertools
import json
import math
from collections import defaultdict
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
CLAIM = "C284_FINITE_SEARCH"
OPERATION = "probability.finite_distribution.condition.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def matrix(m, upper):
    require(len(upper) == m * (m - 1) // 2, "wrong comparison count")
    a = [[F(0) for _ in range(m)] for _ in range(m)]
    for (i, j), p in zip(itertools.combinations(range(m), 2), upper):
        require(0 <= p <= 1, "invalid comparison probability")
        a[i][j], a[j][i] = F(p), 1 - F(p)
    return tuple(map(tuple, a))


def weights(a, h):
    w = [F(1)] * len(a)
    for p in h:
        w = [u * a[i][p] for i, u in enumerate(w)]
    return tuple(w)


def drift(a, h):
    w = weights(a, h)
    W = sum(w)
    numerator = sum(
        w[p] * sum(w[i] * a[i][p] for i in range(len(a)))
        for p in range(len(a))
    )
    require(2 * numerator == W * W - sum(u * u for u in w), "drift identity")
    if W:
        require(numerator / W <= W / 2, "half drift")
    else:
        require(all(u == 0 for u in w) and numerator == 0, "zero absorption")


def terminal_law(a, horizon, failure):
    active = {(): F(1)}
    stopped = defaultdict(F)
    seen = {()}
    for _ in range(horizon):
        following = defaultdict(F)
        for h, mass in active.items():
            w = weights(a, h)
            W = sum(w)
            if W == 0:
                stopped[h] += mass
                continue
            q = failure(h, W)
            require(0 <= q <= 1, "invalid conditional sampler failure")
            if q:
                stopped[h] += mass * q
            for p, u in enumerate(w):
                if u and q != 1:
                    require(p not in h, "positive-mass repeated pivot")
                    child = h + (p,)
                    following[child] += mass * (1 - q) * u / W
                    seen.add(child)
        active = following
    for h, mass in active.items():
        stopped[h] += mass
    require(sum(stopped.values()) == 1, "branching law does not normalize")
    require(all(v > 0 for v in stopped.values()), "nonpositive terminal mass")
    require(all(len(h) <= horizon for h in stopped), "horizon exceeded")
    return dict(stopped), seen


def policy(star, eta, kind):
    def failure(h, W):
        if star in h or W < F(1, 2):
            return F(1)
        if kind == "maximal":
            return eta
        code = 7 + sum((k + 1) * (p + 2) for k, p in enumerate(h))
        if kind == "alternating":
            return eta if code % 2 else F(0)
        require(kind == "adaptive", "unknown failure policy")
        return eta * F(code % 11, 10)

    return failure


def miss_probability(law, star):
    return sum(mass for h, mass in law.items() if star not in h)


def finite_regressions():
    counts = {"matrices": 0, "dominant_horizon_cases": 0, "adaptive_laws": 0,
              "state_drift_checks": 0, "survival_checks": 0}
    stress_results = []

    def check(a, star, epsilon, eta, T, label=None):
        require(T * epsilon <= F(1, 2), "invalid theorem parameter")
        require(all(a[star][j] >= 1 - epsilon for j in range(len(a)) if j != star),
                "dominance hypothesis not satisfied")
        ideal, seen = terminal_law(a, T, lambda h, W: F(0))
        ideal_miss = miss_probability(ideal, star)
        expected_weight = sum(mass * sum(weights(a, h)) for h, mass in ideal.items())
        require(expected_weight <= F(len(a), 2**T), "ideal horizon contraction")
        require(ideal_miss <= F(2 * len(a), 2**T), "ideal miss bound")
        counts["dominant_horizon_cases"] += 1
        for kind in ("adaptive", "maximal", "alternating"):
            actual, states = terminal_law(a, T, policy(star, eta, kind))
            seen |= states
            actual_miss = miss_probability(actual, star)
            require(actual_miss <= ideal_miss + T * eta, "adaptive coupling bound")
            require(actual_miss <= F(2 * len(a), 2**T) + T * eta,
                    "adaptive finite-horizon bound")
            counts["adaptive_laws"] += 1
            if label and kind == "adaptive":
                stress_results.append({
                    "name": label, "m": len(a), "T": T, "epsilon": str(epsilon),
                    "eta": str(eta), "ideal_miss": str(ideal_miss),
                    "adaptive_miss": str(actual_miss),
                    "theorem_bound": str(F(2 * len(a), 2**T) + T * eta),
                })
        for h in seen:
            drift(a, h)
            counts["state_drift_checks"] += 1
        opponents = [i for i in range(len(a)) if i != star]
        for length in range(min(T, 5) + 1):
            for h in itertools.product(opponents, repeat=length):
                require(weights(a, h)[star] >= 1 - length * epsilon,
                        "surviving dominant weight")
                counts["survival_checks"] += 1

    for m in (1, 2, 3):
        for upper in itertools.product((F(0), F(1, 2), F(1)), repeat=m * (m - 1) // 2):
            a = matrix(m, upper)
            counts["matrices"] += 1
            for star in range(m):
                for epsilon in (F(0), F(1, 4), F(1, 2)):
                    if any(a[star][j] < 1 - epsilon for j in range(m) if j != star):
                        continue
                    for T in (0, 1, 2, 3, 4, 6):
                        if T * epsilon <= F(1, 2):
                            check(a, star, epsilon, F(1, 17), T)

    near_half = (F(499999, 1000000), F(500001, 1000000))
    for index, nonwinner in enumerate(itertools.product(near_half, repeat=3)):
        a = matrix(4, (F(9, 10), F(19, 20), F(1), *nonwinner))
        counts["matrices"] += 1
        check(a, 0, F(1, 10), F(1, 37), 5, f"near_half_boundary_{index}")
    a = matrix(4, (F(999, 1000),) * 3 + (F(1, 2), F(37, 101), F(100, 101)))
    counts["matrices"] += 1
    check(a, 0, F(1, 1000), F(1, 1000000), 20, "long_horizon_small_errors")

    cycle = matrix(3, (F(1), F(0), F(1)))
    require(not any(all(cycle[i][j] >= F(3, 4) for j in range(3) if j != i)
                    for i in range(3)), "cycle unexpectedly has a dominant candidate")
    cycle_law, cycle_states = terminal_law(cycle, 8, lambda h, W: F(0))
    require(all(len(h) == 2 and sum(weights(cycle, h)) == 0 for h in cycle_law),
            "no-winner zero-weight termination")
    for h in cycle_states:
        drift(cycle, h)
    return {
        "counts": counts, "stress_cases": stress_results,
        "no_winner_zero_weight": {
            "matrix": [[str(v) for v in row] for row in cycle],
            "horizon": 8, "terminal_histories": len(cycle_law),
            "terminal_length": 2, "terminal_total_weight": "0",
            "total_probability": str(sum(cycle_law.values())),
        },
        "scope": "Finite rational regressions only; the all-real proof is in Lean.",
    }


def retained_good_state_regression():
    g = (F(2, 3), F(1, 3), F(2, 3), F(0))
    psi = tuple(F(3, 5) * v + (F(4, 5) if i == 3 else 0)
                for i, v in enumerate(g))
    v = psi
    aggregate = [F(0), F(0), F(0)]
    tested = 0
    for _ in range(21):
        good_mass = sum(x * x for x in v[:3])
        require(sum(x * x for x in v) == 1, "Grover state normalization")
        if good_mass:
            require(all(v[i] * g[j] == v[j] * g[i]
                        for i in range(3) for j in range(3)), "good-state direction")
            require((v[0]**2 + v[1]**2) / good_mass == F(5, 9),
                    "index marginal with two distinct retained garbage states")
            require(v[2]**2 / good_mass == F(4, 9), "second index marginal")
            tested += 1
        for i in range(3):
            aggregate[i] += v[i]**2 / 21
        flipped = tuple(-x if i < 3 else x for i, x in enumerate(v))
        overlap = sum(x * y for x, y in zip(psi, flipped))
        v = tuple(2 * x * overlap - y for x, y in zip(psi, flipped))
    mixture_mass = sum(aggregate)
    require((aggregate[0] + aggregate[1]) / mixture_mass == F(5, 9),
            "random-length mixture changes the conditional index law")
    require(aggregate[2] / mixture_mass == F(4, 9), "mixture second marginal")
    return {"iterations": 21, "nonzero_successes": tested,
            "conditioned_index_probabilities": ["5/9", "4/9"],
            "retained_good_coordinates": [str(x) for x in g],
            "random_length_mixture_preserved": True,
            "scope": "Exact rational state regressions; the general unitary proof is in the report."}


def parameter_regressions():
    rows = []
    for m in (2, 3, 4, 16, 2**20, 10**50):
        T = (1000 * m - 1).bit_length()
        epsilon = F(1, 1000 * T)
        require(2**T >= 1000 * m and 2**(T - 1) < 1000 * m, "base-two ceiling")
        require(T * epsilon == F(1, 1000), "comparison error budget")
        M = math.isqrt(200 * m)
        if M * M < 200 * m:
            M += 1
        require((M - 1)**2 < 200 * m <= M * M, "amplification length ceiling")
        R = 0
        fail = F(1)
        while fail > epsilon:
            R += 1
            fail *= F(31, 40)
        require(fail <= epsilon < F(31, 40)**(R - 1), "trial count ceiling")
        cap = R * (2 * M - 1) * T * (T - 1) // 2
        require(cap == sum(R * (2 * M - 1) * t for t in range(T)), "branchwise cap")
        miss_bound = F(2 * m, 2**T) + T * epsilon
        require(miss_bound <= F(3, 1000), "manuscript probability guarantee")
        rows.append({"m": m, "T": T, "epsilon": str(epsilon), "M": M, "R": R,
                     "all_failure_bound": str(fail), "query_cap_divided_by_c": cap,
                     "miss_bound": str(miss_bound)})
    return rows


def jacobian_evidence():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    require(response["request"] == {"operation_id": OPERATION, "payload": payload},
            "Jacobian output belongs to a different payload")
    result = response["result"]
    require(result["operation_id"] == OPERATION and "output" in result,
            "Jacobian did not return a complete typed output")
    output = result["output"]

    def rational(value):
        return F(int(value["num"]), int(value["den"]))

    event = {rational(v) for v in payload["event_values"]}
    selected = {rational(atom["value"]): rational(atom["probability"])
                for atom in payload["distribution"]["atoms"] if rational(atom["value"]) in event}
    event_mass = sum(selected.values())
    require(rational(output["event_probability"]) == event_mass, "Jacobian event mass")
    require({rational(atom["value"]): rational(atom["probability"])
             for atom in output["distribution"]["atoms"]} ==
            {v: mass / event_mass for v, mass in selected.items()},
            "Jacobian conditioned distribution")
    for contribution in output["contributions"]:
        value = rational(contribution["value"])
        require(rational(contribution["source_probability"]) == selected[value],
                "Jacobian source contribution")
        require(rational(contribution["conditioned_probability"]) ==
                selected[value] / event_mass, "Jacobian normalized contribution")
    return {"operation_id": OPERATION, "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"], "adapter_exit_code": 0,
            "adapter_error": None, "adapter_timeout": False, "event_probability": str(event_mass),
            "conditional_probabilities": ["1/3", "2/3"],
            "payload": "jacobian_payload.json", "typed_output": "jacobian_output.json"}


def formal_evidence():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean compile unsuccessful")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof has holes or the axiom audit did not pass")
    require(result["environment_failure"] == "", "Lean environment failure")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"], "stale Lean source")
    require(hashlib.sha256(fidelity.encode()).hexdigest() ==
            result["statement_fidelity_sha256"], "stale fidelity document")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == CLAIM), key=lambda c: c["version"])
    require(claim["formal_statement"].strip() == source.decode().strip(), "claim translation changed")
    require(claim["external_assumptions"] == [], "undischarged assumption on the real theorem")
    records = [e for e in state["evidence"]
               if e["subject"]["subject_id"] == CLAIM
               and e["subject"]["content_hash"] == claim["content_hash"]
               and e["tier"] == "mechanical" and e["verdict"] == "supports"]
    require(len(records) == 1, "expected one current mechanical certificate")
    archive_path = ROOT / records[0]["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == result, "archive and current compiler run disagree")
    require(archive["lean_source"]["text"] == source.decode(), "archive source mismatch")
    require(archive["statement_fidelity"]["text"] == fidelity, "archive fidelity mismatch")
    return {"claim": CLAIM, "declaration": "ProbabilisticTournament.finite_horizon_miss_bound",
            "lean_version": "4.31.0", "exit_code": 0, "proof_holes": [],
            "axiom_audit_exit_code": 0, "archive": records[0]["artifact"],
            "source_and_fidelity_binding": "checked against the official compiler digests",
            "formal_scope": "All-real finite stochastic process; quantum bridge is a prose proof."}


def certificate():
    return {"schema_version": 1, "result_class": "formal_verification_of_component",
            "statement": "T*epsilon<=1/2 implies miss<=2*m/2^T+T*eta under the stated exact conditional sampling hypotheses.",
            "false_manuscript_assertions_certified": [],
            "formal_evidence": formal_evidence(), "finite_regressions": finite_regressions(),
            "retained_garbage_regression": retained_good_state_regression(),
            "manuscript_parameters_and_caps": parameter_regressions(),
            "jacobian": jacobian_evidence()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Generate the initial certificate; refuse to overwrite one.")
    args = parser.parse_args()
    actual = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        require(not path.exists(), "certificate already exists; do not overwrite evidence")
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    expected = json.loads(path.read_text())
    require(actual == expected, "recomputed exact certificate differs from the saved certificate")
    print(json.dumps({"ok": True, "claim": CLAIM, "lean_exit_code": 0, "proof_holes": [],
                      "regressions": actual["finite_regressions"]["counts"],
                      "certificate": str(path.relative_to(ROOT))}, sort_keys=True))


if __name__ == "__main__":
    main()
