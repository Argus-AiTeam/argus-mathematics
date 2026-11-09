#!/usr/bin/env python3
"""Replay exact diagnostics and, by default, the universal Lean certificate."""

import argparse
from collections import defaultdict
from fractions import Fraction as Q
from itertools import combinations, product
import json
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
LOG_TERMS = 48


def require(condition, message):
    if not condition:
        raise ValueError(message)


def add_interval(left, right):
    return left[0] + right[0], left[1] + right[1]


def scale_interval(factor, interval):
    values = factor * interval[0], factor * interval[1]
    return min(values), max(values)


def log_series(value):
    require(value >= 1, "The positive log series needs a value at least one.")
    t = (value - 1) / (value + 1)
    partial = sum((2 * t ** (2 * j + 1) / (2 * j + 1) for j in range(LOG_TERMS)), Q(0))
    tail = 2 * t ** (2 * LOG_TERMS + 1) / ((2 * LOG_TERMS + 1) * (1 - t * t))
    return partial, partial + tail


LOG_TWO = log_series(Q(2))


def log_interval(value):
    value = Q(value)
    require(value > 0, "A logarithm needs a positive argument.")
    exponent = 0
    while value < 1:
        value *= 2
        exponent -= 1
    while value >= 2:
        value /= 2
        exponent += 1
    return add_interval(log_series(value), scale_interval(exponent, LOG_TWO))


def entropy_interval(weights):
    result = Q(0), Q(0)
    for weight in weights:
        if weight:
            result = add_interval(result, scale_interval(-weight, log_interval(weight)))
    return result


def band(distance):
    require(distance > 0, "Only nonzero distances have a pair band.")
    lower, index = Q(1), 0
    while distance < lower:
        lower /= 2
        index += 1
    while distance >= 2 * lower:
        lower *= 2
        index -= 1
    require(lower <= distance < 2 * lower, "Incorrect half-open dyadic band.")
    return index


def dyadic(index):
    return Q(2) ** (-index)


def cases():
    epsilon = Q(1, 2 ** 60)
    return [
        {
            "name": "singleton",
            "values": [Q(-7, 3)], "weights": [Q(1)],
            "scales": [Q(1), Q(1, 2 ** 90)], "k": [1, 2, 7],
            "bands": {},
        },
        {
            "name": "arbitrarily_deep_skew_pair",
            "values": [Q(0), Q(1, 2 ** 80)], "weights": [1 - epsilon, epsilon],
            "scales": [Q(1), Q(1, 2 ** 82)], "k": [1, 2, 5],
            "bands": {80: ( {(0, 1): 2 * epsilon}, [Q(0), Q(1)] )},
        },
        {
            "name": "negative_grid_and_dyadic_endpoints",
            "values": [Q(-1, 2), Q(0), Q(1, 2)],
            "weights": [Q(1, 4), Q(1, 2), Q(1, 4)],
            "scales": [Q(1), Q(1, 2)], "k": [1, 2, 3],
            "bands": {
                1: ({(0, 1): Q(1, 2), (1, 2): Q(1, 2)}, [Q(0), Q(1), Q(0)]),
                0: ({(0, 2): Q(1, 2)}, [Q(1), Q(0), Q(0)]),
            },
        },
        {
            "name": "exact_coarse_cell_endpoints",
            "values": [Q(-1), Q(0), Q(1)],
            "weights": [Q(1, 4), Q(1, 2), Q(1, 4)],
            "scales": [Q(1, 2)], "k": [1, 2, 3],
            "bands": {
                0: ({(0, 1): Q(1, 2), (1, 2): Q(1, 2)}, [Q(0), Q(1), Q(0)]),
                -1: ({(0, 2): Q(1, 2)}, [Q(1), Q(0), Q(0)]),
            },
        },
        {
            "name": "fractional_five_cycle",
            "values": [Q(0), Q(1), Q(3, 2), Q(2), Q(3)],
            "weights": [Q(1, 5)] * 5,
            "scales": [Q(1), Q(1, 2), Q(4)], "k": [1, 2, 3],
            "bands": {
                1: ({(1, 2): Q(2, 5)}, [Q(0), Q(0), Q(1), Q(0), Q(0)]),
                0: (
                    {(0, 1): Q(1, 5), (0, 2): Q(1, 5), (1, 3): Q(1, 5),
                     (2, 4): Q(1, 5), (3, 4): Q(1, 5)},
                    [Q(1, 2)] * 5,
                ),
                -1: (
                    {(0, 3): Q(2, 5), (1, 4): Q(2, 5)},
                    [Q(1), Q(1), Q(0), Q(0), Q(0)],
                ),
            },
        },
        {
            "name": "skew_three_atom_law",
            "values": [Q(0), Q(1, 2), Q(1)],
            "weights": [Q(999, 1000), Q(1, 2000), Q(1, 2000)],
            "scales": [Q(1), Q(1, 4)], "k": [1, 2, 3],
            "bands": {
                1: ({(0, 1): Q(1, 1000)}, [Q(0), Q(1), Q(0)]),
                0: ({(0, 2): Q(1, 1000)}, [Q(0), Q(0), Q(1)]),
            },
        },
    ]


def check_case(case):
    values, weights = case["values"], case["weights"]
    require(len(set(values)) == len(values), "Support values must be distinct.")
    require(all(p > 0 for p in weights) and sum(weights) == 1, "Invalid probability law.")
    edges = defaultdict(list)
    for i, j in combinations(range(len(values)), 2):
        edges[band(abs(values[j] - values[i]))].append((i, j))
    require(set(edges) == set(case["bands"]), f"Uncertified bands for {case['name']}.")
    capacities = {}
    band_records = []
    for index, edge_list in sorted(edges.items()):
        primal, dual = case["bands"][index]
        require(set(primal) <= set(edge_list), "A primal weight uses a pair outside its band.")
        require(all(w >= 0 for w in primal.values()), "Negative pair weight.")
        require(len(dual) == len(values) and all(y >= 0 for y in dual), "Invalid dual.")
        for i, weight in enumerate(weights):
            incident = sum(w for edge, w in primal.items() if i in edge)
            require(incident / 2 <= weight, "Fractional endpoint capacity exceeded.")
        for i, j in edge_list:
            require(dual[i] + dual[j] >= 1, "The dual does not cover a band edge.")
        primal_total = sum(primal.values(), Q(0))
        dual_total = sum((2 * p * y for p, y in zip(weights, dual)), Q(0))
        require(primal_total == dual_total, "Primal and dual values differ.")
        capacities[index] = primal_total
        band_records.append({
            "index": index,
            "distance_interval": [str(dyadic(index)), str(2 * dyadic(index))],
            "upper_endpoint": "excluded",
            "capacity": str(primal_total),
            "primal": [[i, j, str(w)] for (i, j), w in sorted(primal.items())],
            "dual": [str(y) for y in dual],
        })
    entropy = entropy_interval(weights)
    inequalities = []
    for rho in case["scales"]:
        cells = [x // rho for x in values]
        grid_mass = defaultdict(Q)
        for cell, p in zip(cells, weights):
            grid_mass[cell] += p
        grid_entropy = entropy_interval(grid_mass.values())
        capacity_sum = sum((c for ell, c in capacities.items() if dyadic(ell) <= 2 * rho), Q(0))
        coupling = [
            [weights[i] * weights[j] / grid_mass[cells[i]] if cells[i] == cells[j] else Q(0)
             for j in range(len(values))]
            for i in range(len(values))
        ]
        for i, p in enumerate(weights):
            require(sum(coupling[i]) == p, "Incorrect coupling marginal.")
            for j in range(len(values)):
                require(coupling[i][j] == coupling[j][i], "The coupling is not symmetric.")
                if coupling[i][j]:
                    require(abs(values[i] - values[j]) < rho, "A same-cell pair exceeds its cell.")
        for ell, edge_list in edges.items():
            witness = {(i, j): 2 * coupling[i][j] for i, j in edge_list}
            for i, p in enumerate(weights):
                require(sum(w for e, w in witness.items() if i in e) / 2 <= p,
                        "The unordered coupling witness is not feasible.")
            require(sum(witness.values()) <= capacities[ell], "Band mass exceeds the exact optimum.")
        pair_distance = sum(
            (coupling[i][j] * abs(values[i] - values[j])
             for i in range(len(values)) for j in range(len(values))), Q(0))
        charged = sum((2 * dyadic(ell) * c for ell, c in capacities.items()
                       if dyadic(ell) <= rho), Q(0))
        require(pair_distance <= charged, "The distance-to-capacity conversion failed.")
        for k in case["k"]:
            sumset = {sum(points, Q(0)) for points in product(values, repeat=k)}
            lhs = scale_interval(k, add_interval(entropy, scale_interval(-1, grid_entropy)))
            rhs = add_interval(log_interval(len(sumset)),
                               scale_interval(1000 * k ** 4 * capacity_sum, LOG_TWO))
            require(lhs[1] <= rhs[0], f"Entropy inequality failed for {case['name']}, k={k}, rho={rho}.")
            inequalities.append({"k": k, "rho": str(rho), "sumset_size": len(sumset),
                                 "capacity_sum": str(capacity_sum), "certified": True})
    record = {
        "name": case["name"], "support": [str(x) for x in values],
        "probabilities": [str(p) for p in weights],
        "bands": band_records, "entropy_inequalities": inequalities,
    }
    if case["name"] == "fractional_five_cycle":
        integral = Q(0)
        edge_list = edges[0]
        for size in range(len(edge_list) + 1):
            for chosen in combinations(edge_list, size):
                vertices = [v for edge in chosen for v in edge]
                if len(vertices) == len(set(vertices)):
                    integral = max(integral, sum((2 * min(weights[i], weights[j]) for i, j in chosen), Q(0)))
        require(capacities[0] == 1 and integral == Q(4, 5), "The fractional/integral distinction vanished.")
        record["integral_matching_value_in_band_zero"] = str(integral)
    return record


def check_partition_arithmetic():
    intervals = []
    for n in range(2, 9):
        lower, upper = max(Q(2), n - Q(1, 2)), min(Q(8), n + Q(1, 2))
        require(Q(3, 4) <= lower / n <= upper / n <= Q(5, 4), "Incorrect unperturbed child lengths.")
        require(Q(11, 20) <= lower / n - Q(1, 5), "Incorrect lower perturbed child length.")
        require(upper / n + Q(1, 5) <= Q(29, 20), "Incorrect upper perturbed child length.")
        intervals.append({"nearest_integer": n, "parent_ratio_interval": [str(lower), str(upper)]})
    require(20160 * Q(8, 3) == 53760 <= 60000, "Incorrect manuscript final constant.")
    require(352 * Q(8, 3) == Q(2816, 3) < 1000, "Incorrect formalized final constant.")
    for a in [Q(1, 2 ** 100), Q(1, 8), Q(1), Q(2), Q(3)]:
        charge = sum((a * 4 ** h for h in range(120) if a * 4 ** h <= 2), Q(0))
        require(charge <= Q(8, 3), "Geometric charge exceeds 8/3.")
    return {"nearest_integer_intervals": intervals, "manuscript_coefficient": 53760,
            "formal_coefficient_before_rounding": "2816/3", "formal_rounded_coefficient": 1000}


def rational_wire(value):
    return Q(int(value["num"]), int(value["den"]))


def check_jacobian():
    payload = json.loads((HERE / "jacobian-condition-payload.json").read_text())
    output = json.loads((HERE / "jacobian-condition-output.json").read_text())
    operation = "probability.finite_distribution.condition.compute"
    require(output["request"]["operation_id"] == operation, "Wrong conditioning operation.")
    require(output["request"]["payload"] == payload, "Conditioning source payload changed.")
    result = output["result"]["output"]
    require(rational_wire(result["event_probability"]) == Q(1, 2), "Wrong event mass.")
    conditioned = {int(rational_wire(a["value"])): rational_wire(a["probability"])
                   for a in result["distribution"]["atoms"]}
    require(conditioned == {1: Q(1, 2), 2: Q(1, 2)}, "Wrong conditional distribution.")
    require(sum(conditioned.values()) == 1, "The conditional law is not normalized.")
    p00 = conditioned.get(0, Q(0))
    p_first_zero = sum(p for value, p in conditioned.items() if value // 2 == 0)
    p_second_zero = sum(p for value, p in conditioned.items() if value % 2 == 0)
    require(p00 == 0 and p_first_zero * p_second_zero == Q(1, 4),
            "The post-sum conditioning diagnostic is not dependent.")
    lp = json.loads((HERE / "jacobian-lp-output.json").read_text())
    require(lp["ok"] is False and lp["error"]["data"]["code"] == "INVALID_REQUEST",
            "The preserved LP adapter error was misclassified.")
    return {
        "server_version": output["server"]["version"], "protocol": output["protocol_version"],
        "operation_id": operation, "conditional_dependence_certified": True,
        "lp_adapter_status": "validation_error: simplex_basis_bound",
        "lp_mathematical_verdict": None,
    }


def run_lean():
    subprocess.run([PYTHON, str(HERE / "build_support.py"), "--build"], cwd=ROOT, check=True)
    environment = dict(os.environ, LEAN_PATH=str(HERE / "vendor"))
    command = [
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE), "--project-root", str(ROOT), "--claim", "C_PAIR_BOUND",
    ]
    completed = subprocess.run(command, cwd=ROOT, env=environment, capture_output=True, text=True)
    (HERE / "lean-verification-output.json").write_text(completed.stdout)
    if completed.returncode:
        print(completed.stdout)
        print(completed.stderr)
        raise SystemExit(completed.returncode)
    payload = json.loads(completed.stdout)
    require(payload["exit_code"] == 0 and payload["proof_holes"] == [], "Lean did not close the proof.")
    require(payload["status"] == "success", "Unexpected compiler result.")
    axiom_lines = [line for line in payload["stdout"].splitlines() if "depends on axioms:" in line]
    require(len(axiom_lines) == 2, "Both final declarations must report their axioms.")
    permitted = {"propext", "Classical.choice", "Quot.sound"}
    for line in axiom_lines:
        names = set(re.search(r"\[([^]]*)\]", line).group(1).split(", "))
        require(names <= permitted, f"Undeclared theorem assumption: {line}")
    return payload


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exact-only", action="store_true",
                        help="Run arithmetic diagnostics only; do not claim universal verification.")
    args = parser.parse_args()
    diagnostics = {
        "log_enclosure": {"method": "positive artanh series with rational geometric tail",
                          "terms": LOG_TERMS, "floating_point_used": False},
        "partition_and_constants": check_partition_arithmetic(),
        "jacobian": check_jacobian(),
        "finite_laws": [check_case(case) for case in cases()],
    }
    count = sum(len(case["entropy_inequalities"]) for case in diagnostics["finite_laws"])
    if args.exact_only:
        print(json.dumps({"mode": "finite_exact_diagnostics_only", "laws": 6,
                          "entropy_inequalities": count, "universal_certificate_written": False}))
        return
    lean = run_lean()
    certificate = {
        "schema_version": 1, "claim_id": "C_PAIR_BOUND",
        "result_class": "universal_machine_checked_verification",
        "statement": "The finite-law pair bound for every finite real probability law, k>=1, rho>0.",
        "constant_proved": "1000*k^4", "manuscript_constant_implied": "60000*k^4",
        "minimum_separation_hypothesis": False,
        "upstream_pair_bound_imported": False, "lean_evidence": lean,
        "diagnostics": diagnostics, "independent_review": "required; not yet performed",
        "novelty": "not claimed; this certifies the technical core, not the full dimension theorem",
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    for module in ("math_state", "proof_graph_check"):
        subprocess.run(
            [PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check", "--project-root", str(ROOT)],
            cwd=ROOT, check=True,
        )
    print(json.dumps({"claim": "C_PAIR_BOUND", "lean_exit_code": 0, "proof_holes": [],
                      "laws": 6, "exact_entropy_inequalities": count,
                      "project_root": str(ROOT), "certificate": "research/pair-bound/exact_certificate.json",
                      "independent_review": "pending"}))


if __name__ == "__main__":
    main()
