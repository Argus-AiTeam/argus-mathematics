#!/usr/bin/env python3
"""Replay the exact core certificate; the prose applicability bridge needs review."""

import argparse
import itertools
import json
import subprocess
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "optimization.linear.rational_general_optimum.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads((ROOT / path).read_text())


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "Noncanonical Jacobian rational",
    )
    return result


def replay_lp(run):
    envelope = read_json(run["output"])
    payload = read_json(run["payload"])
    require(run["adapter_exit"] == 0, "Jacobian adapter did not succeed")
    require(envelope["server"]["version"] == "0.14.0", "Unexpected server version")
    require(envelope["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(envelope["request"]["operation_id"] == OPERATION, "Wrong operation")
    require(envelope["request"]["payload"] == payload, "Payload binding differs")
    require(envelope["result"]["operation_id"] == OPERATION, "Wrong result operation")
    output = envelope["result"]["output"]
    require(output["status"] == "OPTIMAL", "No conclusive exact LP outcome")
    program = payload["program"]
    require(output["program"] == program, "Output uses another LP")
    require(len(program["variables"]) == 1, "Wrong LP dimension")
    require(len(program["constraints"]) == 1, "Wrong LP row count")
    row = program["constraints"][0]
    variable = program["variables"][0]
    coefficient = rational(row["coefficients"][0])
    rhs = rational(row["rhs"])
    point = rational(output["primal_candidate"][0])
    dual = rational(output["constraint_dual"][0])
    lower_dual = rational(output["lower_bound_dual"][0])
    lower = rational(variable["lower_bound"])
    require(variable["upper_bound"] is None, "Unexpected upper bound")
    require(row["relation"] == "GE", "Wrong closure relation")
    require(program["objective"]["sense"] == "MINIMIZE", "Wrong objective")
    objective = rational(program["objective"]["coefficients"][0])
    require(objective == 1 and coefficient == 7 and lower == 2, "Wrong budget LP")
    mark_budget = Fraction(run["mark_budget"])
    require(rhs == 8 * mark_budget + 34, "LP is not the local closure inequality")
    require(point >= lower and coefficient * point >= rhs, "Primal infeasible")
    require(dual >= 0 and lower_dual >= 0, "Wrong dual signs")
    require(coefficient * dual + lower_dual == objective, "Dual stationarity fails")
    require(
        objective * point == rhs * dual + lower * lower_dual,
        "Primal/dual gap is nonzero",
    )
    require(point == Fraction(run["expected_optimum"]), "Wrong exact optimum")
    require(rational(output["primal_objective"]) == point, "Wrong primal value")
    require(rational(output["dual_objective"]) == point, "Wrong dual value")
    require(
        rational(output["constraint_slacks"][0]) == coefficient * point - rhs,
        "Wrong source-row slack",
    )
    require(
        rational(output["lower_bound_slacks"][0]) == point - lower,
        "Wrong lower-bound slack",
    )
    require(all(rational(x) == 0 for x in output["stationarity_residuals"]),
            "Nonzero reported stationarity residual")
    return str(point)


def check_constants(certificate):
    f = lambda key: Fraction(certificate[key])
    require(certificate["marks_per_path"] == 1 + 2 + 3, "Wrong mark count")
    require(certificate["partial_blocks_per_crop"] == 2, "Wrong crop boundary count")
    require(f("uniform_lr_budget") == (12 + Fraction(34, 8)) / Fraction(7, 8),
            "Uniform induction does not close")
    require(f("small_local_coefficient") == 3 * 16 * 4 + 2, "Wrong local charge")
    require(f("small_propagated_coefficient") ==
            f("small_local_coefficient") / Fraction(7, 8), "Wrong geometric charge")
    require(f("small_and_residual_coefficient") ==
            f("small_propagated_coefficient") + f("uniform_lr_budget"),
            "Wrong residual budget")
    require(f("strengthened_bound") ==
            f("small_and_residual_coefficient") + f("other_coefficient"),
            "Wrong final constant")
    require(f("strengthened_bound") < f("original_bound") < 500,
            "The requested estimate does not follow")
    require(certificate["not_certified"], "Analytic prerequisites were concealed")


def check_source_bindings(certificate):
    total = 0
    for path, passages in certificate["source_bindings"].items():
        source = " ".join((ROOT / path).read_text().split())
        for passage in passages:
            require(" ".join(passage.split()) in source,
                    f"Source rule changed or missing: {path}: {passage}")
            total += 1
    require((ROOT / certificate["proof"]).is_file(), "Missing universal prose proof")
    return total


def crop_regressions():
    intervals = [(a, b) for a in range(6) for b in range(a, 6)] + [(1, 0)]
    cases = 0
    for dimension in (1, 2, 3):
        blocks = [list(itertools.product((2 * i, 2 * i + 1), repeat=dimension))
                  for i in range(3)]
        for crop in itertools.product(intervals, repeat=dimension):
            inside = [[all(lo <= point[t] <= hi for t, (lo, hi) in enumerate(crop))
                       for point in block] for block in blocks]
            hits = [i for i, flags in enumerate(inside) if any(flags)]
            edges = [i for i in hits if not all(inside[i])]
            require(len(edges) <= 2, "Coherently ordered crop has three partial hits")
            if hits:
                require(all(all(inside[i]) for i in range(hits[0] + 1, hits[-1])),
                        "A crop misses part of an interior block")
            cases += 1
    return cases


def partitions(n):
    for cuts in itertools.product((False, True), repeat=n - 1):
        start = 0
        result = []
        for i, cut in enumerate(cuts, 1):
            if cut:
                result.append(set(range(start, i)))
                start = i
        yield result + [set(range(start, n))]


def incidence_regressions():
    cases = 0
    for n in range(1, 8):
        families = list(partitions(n))
        for blocks in families:
            for children in families:
                incidences = [sum(bool(block & child) for child in children)
                              for block in blocks]
                require(sum(d for d in incidences if d >= 2) <= 2 * len(children),
                        "Boundary incidence regression failed")
                cases += 1
    return cases


def assignment_regressions():
    labels = list(itertools.product((-1, 0, 1), repeat=4))
    coefficients = (Fraction(1, 5), Fraction(1, 7))
    cases = overlap_cases = 0
    for first in labels:
        for second in labels:
            group_vectors = []
            group_supports = []
            for g, assignment in enumerate((first, second)):
                children = [[Fraction((g + 1) * (i + 1), 32) if assignment[i] == h
                             else Fraction(0) for i in range(4)] for h in range(4)]
                require(all(sum(x * x for x in child) <= 1 for child in children),
                        "Child norm exceeds the unit budget")
                combined = [sum(child[i] for child in children) for i in range(4)]
                require(sum(x * x for x in combined) ==
                        sum(x * x for child in children for x in child),
                        "Disjoint-support power addition failed")
                group_vectors.append(combined)
                group_supports.append({i for i, x in enumerate(combined) if x})
            root = [sum(coefficients[g] * group_vectors[g][i] for g in range(2))
                    for i in range(4)]
            require(sum(x * x for x in root) <= (2 * sum(coefficients)) ** 2,
                    "Overlap-tolerant contraction failed")
            overlap_cases += bool(group_supports[0] & group_supports[1])
            cases += 1
    require(overlap_cases > 0, "Regression accidentally forbids cross-weight overlap")
    return {"cases": cases, "cross_group_overlap_cases": overlap_cases}


def run_checked(command, timeout):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True,
                            timeout=timeout, check=False)
    if result.returncode:
        raise RuntimeError(
            f"Command failed with exit {result.returncode}: {' '.join(command)}\n"
            f"{result.stdout}\n{result.stderr}"
        )
    return result.stdout


def compile_kernel(certificate):
    kernel = certificate["formal_kernel"]
    output = run_checked(
        [ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
         kernel["source"], "--statement-fidelity", kernel["statement_fidelity"],
         "--claim", kernel["claim_id"], "--project-root", str(ROOT), "--timeout", "105"],
        115,
    )
    result = json.loads(output)
    require(result["exit_code"] == 0 and result["status"] == "success",
            "No successful fresh compiler run")
    require(result["proof_holes"] == [], "The formal source has proof holes")
    require(result["kernel"]["recorded"], "Compiler evidence was not attached to its claim")
    validation = {}
    for module in ("math_state", "proof_graph_check"):
        run_checked(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
             "--project-root", str(ROOT)], 30)
        validation[f"{module}_exit"] = 0
    return {
        "exit_code": 0,
        "proof_holes": [],
        "claim_id": kernel["claim_id"],
        "validation": {"project_root": str(ROOT), **validation},
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--regressions-only", action="store_true",
                        help="Skip compilation; this mode is not a certification replay.")
    args = parser.parse_args()
    certificate = read_json("research/ch_exact_pair/exact_certificate.json")
    check_constants(certificate)
    summary = {
        "kind": "regressions_only" if args.regressions_only else "exact_core_replay",
        "bound": certificate["strengthened_bound"],
        "jacobian_optima": [replay_lp(run) for run in certificate["jacobian_runs"]],
        "source_passages_present": check_source_bindings(certificate),
        "finite_regressions": {
            "product_crops": crop_regressions(),
            "boundary_incidences": incidence_regressions(),
            "assignments": assignment_regressions(),
        },
        "full_statement_kernel_verified": False,
        "applicability_proof": certificate["proof"],
        "independent_review": "required_not_performed_by_this_script",
    }
    if not args.regressions_only:
        summary["formal_kernel"] = compile_kernel(certificate)
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
