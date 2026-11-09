#!/usr/bin/env python3
"""Replay exact experiments and the universal Lean certificate."""

import argparse
import json
import math
import subprocess
from fractions import Fraction
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def admissible(n, r, m, k, s):
    require(n >= r >= 3 and 1 <= m <= n and k > 0 and s >= 1, "invalid parameters")
    q = k / r
    if Fraction(s ** (r - 1)) > q**r:
        return False
    return m == 1 or q**r <= Fraction(n - 1, 2 * r * (m - 1)) ** (r - 1)


def least_quarter_cutoff(r, s):
    numerator = 4 * r
    while Fraction(numerator, 4 * r) ** r < s ** (r - 1):
        numerator += 1
    return Fraction(numerator, 4)


def check_instance(n, r, m, k, edges):
    support = tuple(frozenset(e) for e in edges)
    require(len(set(support)) == len(support), "repeated support edge")
    require(all(len(e) == r and len(set(e)) == r for e in edges), "nonuniform edge")
    require(all(0 <= u < n for e in edges for u in e), "vertex outside Fin n")
    require(admissible(n, r, m, k, len(edges)), "instance violates literal hypotheses")
    vertices = set().union(*support)
    degrees = {u: sum(u in e for e in support) for u in vertices}
    u = min(vertices, key=lambda x: (degrees[x], x))
    require(sum(degrees.values()) == r * len(support), "incidence identity failed")
    require(len(support) <= len(vertices) ** r, "simple-support power bound failed")
    require(len(vertices) <= r * len(support), "union-cardinality bound failed")
    require(1 <= degrees[u] <= k, "real-cutoff degree witness failed")
    total = good = isolated = containing = paired = 0
    w = next(x for x in range(n) if x != u)
    for block in combinations(range(n), m):
        B = frozenset(block)
        total += 1
        containing += u in B
        paired += u in B and w in B
        retained = sum(bool(e & B) for e in support)
        good += 1 <= retained <= k
        if B & vertices == {u}:
            isolated += 1
            require(retained == degrees[u], "isolation-to-degree identity failed")
    require(total == math.comb(n, m), "wrong fixed-size sample space")
    require(containing == math.comb(n - 1, m - 1), "singleton marginal failed")
    expected_pair = 0 if m == 1 else math.comb(n - 2, m - 2)
    require(paired == expected_pair, "without-replacement pair marginal failed")
    lower = Fraction(m, n) * (1 - Fraction((len(vertices) - 1) * (m - 1), n - 1))
    require(Fraction(isolated, total) >= lower, "Bonferroni isolation bound failed")
    require(Fraction(good, total) >= Fraction(m, 2 * n), "capture conclusion failed")
    return total


def support_families(n, r):
    families = []
    for s in (1, 2, 3, 4, 6):
        if r - 1 + s <= n:
            families.append(tuple(tuple(range(r - 1)) + (r - 1 + j,) for j in range(s)))
        if r * s <= n:
            families.append(tuple(tuple(range(j * r, (j + 1) * r)) for j in range(s)))
    families.append(tuple(combinations(range(r + 1), r)))
    for overlap in range(r):
        if 2 * r - overlap <= n:
            families.append((tuple(range(r)), tuple(range(overlap)) + tuple(range(r, 2 * r - overlap))))
    return sorted(set(tuple(sorted(f)) for f in families))


def arithmetic_checks():
    cases = block_evaluations = exhaustive_supports = 0
    boundary = {"m=1": 0, "n=r": 0, "noninteger k": 0, "L<1": 0}

    def run(n, r, m, k, edges):
        nonlocal cases, block_evaluations
        if admissible(n, r, m, k, len(edges)):
            block_evaluations += check_instance(n, r, m, k, edges)
            cases += 1
            boundary["m=1"] += m == 1
            boundary["n=r"] += n == r
            boundary["noninteger k"] += k.denominator != 1

    for n in range(3, 6):
        for r in range(3, n + 1):
            universe = tuple(combinations(range(n), r))
            for mask in range(1, 1 << len(universe)):
                edges = tuple(e for j, e in enumerate(universe) if mask & (1 << j))
                exhaustive_supports += 1
                k = least_quarter_cutoff(r, len(edges))
                for cutoff in (k, k + Fraction(1, 8)):
                    for m in range(1, n + 1):
                        run(n, r, m, cutoff, edges)
    for n in (7, 10, 13, 19, 25, 41, 67):
        for r in (3, 4, 5):
            for edges in support_families(n, r):
                k = least_quarter_cutoff(r, len(edges))
                for cutoff in (k, k + Fraction(1, 8)):
                    for m in range(1, 4 if n <= 25 else 3):
                        run(n, r, m, cutoff, edges)
    for r in range(3, 11):
        q = Fraction(1, 2)
        require(q**r < 1, "empty-range real-power comparison failed")
        for s in range(1, 33):
            require(s ** (r - 1) > q**r, "nonempty support admitted when L<1")
        boundary["L<1"] += 1
    require(all(boundary.values()), "a required boundary case was not exercised")
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    require(result["request"]["operation_id"] == "hypergraph.vertex_degrees.compute",
            "wrong Jacobian operation")
    require(result["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(result["server"]["version"] == "0.14.0", "unexpected recorded server")
    require(result["protocol_version"] == "2025-11-25", "unexpected recorded protocol")
    require(result["result"]["output"]["degrees"] ==
            [["0", 3], ["1", 3], ["2", 3], ["3", 3], ["4", 0]],
            "typed Jacobian degrees disagree with exact incidence counting")
    return {
        "kind": "finite_adversarial_experiment",
        "admitted_instances": cases,
        "exhaustive_supports_n_at_most_5": exhaustive_supports,
        "fixed_size_blocks_evaluated": block_evaluations,
        "required_boundaries": boundary,
        "counterexamples": 0,
        "universal_conclusion": False,
    }


def compile_certificate(certificate):
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / certificate["source"]),
        "--statement-fidelity", str(HERE / certificate["statement_fidelity"]),
        "--project-root", str(ROOT), "--claim", certificate["claim_id"],
        "--timeout", "180",
    ]
    completed = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    require(completed.returncode == 0,
            f"official Lean verification failed:\n{completed.stdout}\n{completed.stderr}")
    result = json.loads(completed.stdout)
    require(result["exit_code"] == 0 and result["proof_holes"] == [],
            "compiler did not establish a hole-free theorem")
    require(result["status"] == "success", "Lean status is not success")
    require(result["kernel"]["recorded"] is not None, "claim evidence was not recorded")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "wrong Lean version")
    permitted = set(certificate["permitted_axioms"])
    for theorem in (certificate["theorem"], certificate["empty_range_theorem"]):
        prefix = f"'{theorem}' depends on axioms: ["
        lines = [line for line in result["stdout"].splitlines() if line.startswith(prefix)]
        require(len(lines) == 1, f"missing axiom audit for {theorem}")
        axioms = set(lines[0][len(prefix):].removesuffix("]").split(", "))
        require(axioms <= permitted, f"unsupported axioms in {theorem}: {axioms - permitted}")
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        check = subprocess.run(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True, check=False,
        )
        require(check.returncode == 0, f"{module} check failed:\n{check.stdout}\n{check.stderr}")
        checks[module] = {"project_root": str(ROOT), "exit_code": check.returncode}
    return {
        "kind": "universal_formal_verification",
        "claim": certificate["claim_id"],
        "theorem": certificate["theorem"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "kernel": result["kernel"],
        "campaign_local_checks": checks,
        "independent_review": "required_not_started",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--arithmetic-only", action="store_true",
                        help="run finite experiments only; does not certify the universal claim")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "V_HYPERGRAPH_CAPTURE", "wrong claim")
    result = {"arithmetic": arithmetic_checks()}
    if not args.arithmetic_only:
        result["formal"] = compile_certificate(certificate)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
