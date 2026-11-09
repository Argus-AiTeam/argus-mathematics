#!/usr/bin/env python3
"""Replay the exact finite algebra supporting the frequency-test application."""

import argparse
from copy import deepcopy
from fractions import Fraction
from itertools import combinations
import json
from pathlib import Path
import re
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "An-L3-bound-for-the-trilinear-Hilbert-transform-October-5-2026"
    / "build/sections"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def pair_fraction(value):
    return Fraction(*value)


def wire_fraction(value):
    numerator = int(value["num"])
    denominator = int(value["den"])
    require(denominator > 0, "nonpositive wire denominator")
    answer = Fraction(numerator, denominator)
    require(str(answer.numerator) == value["num"], "noncanonical numerator")
    require(str(answer.denominator) == value["den"], "noncanonical denominator")
    return answer


def inverse(first, second):
    determinant = second - first
    require(determinant != 0, "singular role system")
    answer = (
        (Fraction(second, determinant), Fraction(-1, determinant)),
        (Fraction(-first, determinant), Fraction(1, determinant)),
    )
    matrix = ((1, 1), (first, second))
    for left, right in ((matrix, answer), (answer, matrix)):
        for i in range(2):
            for j in range(2):
                require(
                    sum(left[i][k] * right[k][j] for k in range(2)) == (i == j),
                    "incorrect role inverse",
                )
    return answer


def check_roles(certificate):
    roles = certificate["roles"]
    require(roles == [0, 1, 2, 3], "not the manuscript progression roles")
    denominator = certificate["parameters"]["zeta_denominator"]
    determinants = set()
    four_errors = []
    shift_bounds = []
    four_count = 0
    for first, second in combinations(roles, 2):
        rows = inverse(first, second)
        determinants.add(second - first)
        four_count += 1
        for row in rows:
            shifts = [denominator * entry for entry in row]
            require(all(entry.denominator == 1 for entry in shifts),
                    "nonintegral shifted pair inversion")
            shift_bounds.append(2 * sum(map(abs, shifts)))
            four_errors.append(2 * sum(map(abs, row)))

    three_errors = []
    three_shifts = []
    side_errors = []
    side_count = 0
    for side in roles:
        core = [role for role in roles if role != side]
        for unknown in core:
            coefficient = unknown - side
            shift = Fraction(denominator, coefficient)
            require(shift.denominator == 1, "nonintegral three-core inversion")
            three_shifts.append(2 * abs(shift))
            three_errors.append(Fraction(2, abs(coefficient)))
        for fixed in core:
            first, second = [role for role in core if role != fixed]
            rows = inverse(first - side, second - side)
            side_count += 1
            for row in rows:
                shifts = [denominator * entry for entry in row]
                require(all(entry.denominator == 1 for entry in shifts),
                        "nonintegral side-window inversion")
                shift_bounds.append(2 * sum(map(abs, shifts)))
                side_errors.append(4 * abs(row[0]) + 2 * abs(row[1]))

    annulus_shift = []
    sum_coefficients = [1, 1, 1, 1]
    moment_coefficients = [0, 1, 2, 3]
    for excluded in roles:
        coefficients = [
            moment_coefficients[i] - excluded * sum_coefficients[i] for i in roles
        ]
        triple = [role for role in roles if role != excluded]
        expected = [role - excluded if role in triple else 0 for role in roles]
        require(coefficients == expected, "incorrect simultaneous triple identity")
        require(sum(value == 0 for value in coefficients) == 1,
                "wrong excluded role in triple")
        shift_coefficients = [-excluded, 1]
        annulus_shift.append(sum(map(abs, shift_coefficients)))

    computed = {
        "four_core_systems": four_count,
        "three_core_scalar_systems": len(three_errors),
        "side_window_systems": side_count,
        "triple_annuli": len(annulus_shift),
        "determinant_magnitudes": sorted(determinants),
        "max_shift_height_multiple": int(max(shift_bounds)),
        "three_core_shift_height_multiple": int(max(three_shifts)),
        "four_core_error_multiple": int(max(four_errors)),
        "three_core_error_multiple": int(max(three_errors)),
        "side_window_error_multiple": int(max(side_errors)),
        "annulus_shift_height_multiple": max(annulus_shift),
        "annulus_upper_multiple": max(annulus_shift),
    }
    require(computed == certificate["role_checks"], "role coefficient mismatch")
    return computed


def check_hereditary(certificate):
    data = certificate["hereditary"]
    ratio = pair_fraction(data["minimum_bin_ratio"])
    excluded = pair_fraction(data["excluded_fraction"])
    same = 2 * ratio - 1
    linked = ratio + ratio**2 - 1
    require(ratio == Fraction(10, 11), "incorrect base-1.1 type ratio")
    require(excluded == Fraction(1, 10), "incorrect excluded primary fraction")
    require(same == pair_fraction(data["same_component_overlap"]), "good overlap")
    require(linked == pair_fraction(data["linked_component_overlap"]), "link overlap")
    require(same > excluded and linked > excluded, "no good primary in intersection")
    require(2 * ratio > 1, "same-type predecessors need not intersect")


def check_reserves(certificate):
    p = certificate["parameters"]
    require(p["delta"] == 10 and p["lattice_base"] == 6, "source height parameters")
    require(p["zeta_denominator"] == 6**2, "wrong xi-to-zeta conversion")
    require(p["minimum_D"] == 2, "changed monotonicity endpoint")
    require(p["dimension_power_absorbed"] == 2, "changed dimension reserve")
    require(
        (p["A0_D_power_lower_bound"], p["H_D_power"], p["U_D_power"],
         p["Xi_D_power"], p["C_res_power_of_two"]) == (100, 5, 250, 1000, 40),
        "parameters do not match the proved source reductions",
    )
    require(
        (p["B_H_multiple"], p["annulus_lower_bin_divisor"],
         p["annulus_upper_bin_multiple"], p["nu_upper_U_multiple"]) == (4, 2, 8, 2),
        "annulus or endpoint convention changed",
    )
    require(p["nubar_upper_U_multiple"] == 16, "wrong nubar bound")
    require(p["mubar_inverse_U_multiple"] == 4, "wrong mubar bound")
    require(p["height_bin_factor"] >= 4, "insufficient height-bin factor")
    reserve = 2 ** p["C_res_power_of_two"]
    q_exponent = (
        p["A0_D_power_lower_bound"] * p["delta"]
        - p["H_D_power"] - p["dimension_power_absorbed"]
    )
    sigma_exponent = (
        p["Xi_D_power"] - p["U_D_power"] - p["dimension_power_absorbed"]
    )
    gap_exponent = p["Xi_D_power"] - p["U_D_power"]
    require(min(q_exponent, sigma_exponent, gap_exponent) > 0, "not monotone powers")
    computed = {
        "Q_D_exponent": q_exponent,
        "Q_rhs_power_of_two": p["C_res_power_of_two"] + 3,
        "Q_rhs_power_of_six": p["delta"] - 2,
        "Sigma_D_exponent": sigma_exponent,
        "Sigma_rhs_power_of_two": p["C_res_power_of_two"] + 5,
        "gap_D_exponent": gap_exponent,
        "gap_rhs": 1000 * p["nubar_upper_U_multiple"],
        "window_rhs": 2 * certificate["role_checks"]["side_window_error_multiple"]
                      * p["nu_upper_U_multiple"],
    }
    require(computed == certificate["reserve_reductions"], "reserve reduction mismatch")
    require(2**q_exponent > 2 * reserve * p["B_H_multiple"] * 6**(p["delta"] - 2),
            "insufficient Q reserve")
    require(2**sigma_exponent > 2 * reserve * p["nubar_upper_U_multiple"],
            "insufficient Sigma reserve")
    require(reserve * p["B_H_multiple"]
            > certificate["role_checks"]["max_shift_height_multiple"],
            "pair/window shifts exceed Q")
    require(2**gap_exponent > computed["window_rhs"], "side windows may overlap")
    require(2**gap_exponent > computed["gap_rhs"], "pure shifts meet upper gap")
    require(2**gap_exponent > 1000 * p["mubar_inverse_U_multiple"],
            "pure shifts meet lower gap")
    return computed


def check_power(certificate):
    data = certificate["power_summation"]
    sparse = pair_fraction(data["sparse_exponent"])
    power = pair_fraction(data["p0"])
    epsilon = 1 - power
    require(sparse == Fraction(1, 810), "not the reviewed sparse exponent")
    require(epsilon == sparse / 2, "power does not leave the claimed saving")
    n = data["geometric_denominator"]
    require(epsilon == Fraction(1, n) and n == 1620, "wrong geometric ratio")
    require(2 * (2 * n - 1)**n >= (2 * n)**n, "Bernoulli comparison failed")
    require(data["geometric_factor_upper_bound"] == 4 * n, "wrong series factor")
    require(data["sparse_constant_power_of_two"] == 160, "changed reviewed constant")
    require(data["power_constant_power_of_two"] == 173, "changed power constant")
    require(4 * n < 2 ** (173 - 160), "insufficient final constant")


def check_lp(payload, envelope, expected):
    require(envelope["request"]["payload"] == payload, "Jacobian request binding")
    result = envelope["result"]["output"]
    require(result["program"] == payload["program"], "Jacobian output source binding")
    require(result["status"] == "OPTIMAL", "nonconclusive Jacobian outcome")
    program = payload["program"]
    require(program["constraints"] == [], "residual problem gained constraints")
    require(program["objective"]["sense"] == "MAXIMIZE", "wrong objective sense")
    objective = list(map(wire_fraction, program["objective"]["coefficients"]))
    require(objective == [3, -1], "not the original x=3u-v objective")
    variables = program["variables"]
    lower = [wire_fraction(variable["lower_bound"]) for variable in variables]
    upper = [wire_fraction(variable["upper_bound"]) for variable in variables]
    require(lower == [-4, -2] and upper == [4, 2], "wrong overlap residual rectangle")
    point = list(map(wire_fraction, result["primal_candidate"]))
    require(len(point) == 2, "wrong primal dimension")
    require(all(lo <= x <= hi for lo, x, hi in zip(lower, point, upper)),
            "primal outside residual rectangle")
    lower_dual = list(map(wire_fraction, result["lower_bound_dual"]))
    upper_dual = list(map(wire_fraction, result["upper_bound_dual"]))
    require(len(lower_dual) == len(upper_dual) == 2, "wrong dual dimension")
    require(all(value <= 0 for value in lower_dual), "wrong lower dual sign")
    require(all(value >= 0 for value in upper_dual), "wrong upper dual sign")
    require(all(a + b == c for a, b, c in zip(lower_dual, upper_dual, objective)),
            "dual stationarity failed")
    primal = sum(c * x for c, x in zip(objective, point))
    dual = sum(a * lo + b * hi
               for a, lo, b, hi in zip(lower_dual, lower, upper_dual, upper))
    require(primal == dual == expected, "primal/dual gap")
    require(wire_fraction(result["primal_objective"]) == primal, "primal objective")
    require(wire_fraction(result["dual_objective"]) == dual, "dual objective")
    require(all(value == 0 for value in map(wire_fraction,
                                           result["stationarity_residuals"])),
            "nonzero reported stationarity")
    u, v = point
    x, y = 3 * u - v, -2 * u + v
    require(x + y == u and 2 * x + 3 * y == v, "coordinate change not invertible")
    require(abs(x + y) <= 4 and abs(2 * x + 3 * y) <= 2,
            "point fails original source constraints")
    require(x == expected, "point does not attain source objective")
    return {"optimum": int(primal), "original_point": [int(x), int(y)]}


def check_jacobian(certificate):
    data = certificate["jacobian"]
    contract = json.loads((ROOT / data["reused_contract"]).read_text())
    require(contract["result"]["operation"]["operation_id"] == data["operation_id"],
            "uninspected operation")
    envelope = json.loads((HERE / data["output"]).read_text())
    payload = json.loads((HERE / data["payload"]).read_text())
    status = json.loads((HERE / data["status"]).read_text())
    require(status["adapter_exit_code"] == 0 and not status["timed_out"],
            "adapter failed or timed out")
    require(status["stderr"] == "", "adapter emitted an unreviewed diagnostic")
    require(envelope["server"]["version"] == data["server_version"], "server version")
    require(envelope["protocol_version"] == data["protocol_version"], "protocol version")
    require(envelope["transport"] == data["transport"], "transport")
    require(envelope["request"]["operation_id"] == data["operation_id"],
            "request operation binding")
    require(envelope["result"]["operation_id"] == data["operation_id"], "operation binding")
    require(status["operation_id"] == data["operation_id"], "adapter operation binding")
    answer = check_lp(payload, envelope, pair_fraction(data["expected_optimum"]))

    rejected = json.loads((HERE / data["rejected_output"]).read_text())
    rejected_status = json.loads((HERE / data["rejected_status"]).read_text())
    original = json.loads((HERE / data["rejected_payload"]).read_text())["program"]
    require(rejected["ok"] is False, "lost rejected-encoding evidence")
    require(rejected["error"]["data"]["code"] == "INVALID_REQUEST", "unrecorded failure")
    require(rejected["error"]["data"]["operation_id"] == data["operation_id"],
            "rejected operation binding")
    require(rejected_status["adapter_exit_code"] == 2
            and not rejected_status["timed_out"], "changed rejection status")
    require(len(original["variables"]) == 2
            and all(variable["lower_bound"] is None and variable["upper_bound"] is None
                    for variable in original["variables"]), "source variables are not free")
    require([list(map(wire_fraction, row["coefficients"]))
             for row in original["constraints"]] == [[1, 1], [1, 1], [2, 3], [2, 3]],
            "rejected source-coordinate rows changed")
    require([wire_fraction(row["rhs"]) for row in original["constraints"]]
            == [4, -4, 2, -2], "rejected source-coordinate residual bounds changed")
    require([row["relation"] for row in original["constraints"]]
            == ["LE", "GE", "LE", "GE"], "rejected row orientations changed")
    require(list(map(wire_fraction, original["objective"]["coefficients"])) == [1, 0]
            and original["objective"]["sense"] == "MAXIMIZE",
            "rejected source objective changed")
    require(data["coordinate_change"] == [[1, 1], [2, 3]], "coordinate map changed")
    return answer, payload, envelope


def check_sources(certificate):
    for name, fragments in certificate["source_fragments"].items():
        text = re.sub(r"\s+", "", (SOURCE / name).read_text())
        for fragment in fragments:
            require(re.sub(r"\s+", "", fragment) in text,
                    f"staged source no longer matches {name}: {fragment}")


def expect_rejection(check, description):
    try:
        check()
    except ValueError:
        return description
    raise ValueError(f"corruption control accepted: {description}")


def self_test(certificate, payload, envelope):
    wrong_roles = deepcopy(certificate)
    wrong_roles["role_checks"]["max_shift_height_multiple"] -= 1
    wrong_reserve = deepcopy(certificate)
    wrong_reserve["parameters"]["Xi_D_power"] = 250
    wrong_power = deepcopy(certificate)
    wrong_power["power_summation"]["p0"] = [1618, 1620]
    wrong_point = deepcopy(envelope)
    wrong_point["result"]["output"]["primal_candidate"][0] = {"num": "5", "den": "1"}
    return [
        expect_rejection(lambda: check_roles(wrong_roles), "undersized inversion budget"),
        expect_rejection(lambda: check_reserves(wrong_reserve), "insufficient separation"),
        expect_rejection(lambda: check_power(wrong_power), "incorrect power exponent"),
        expect_rejection(lambda: check_lp(payload, wrong_point, Fraction(14)),
                         "corrupted Jacobian primal point"),
    ]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=HERE / "exact_certificate.json")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    check_sources(certificate)
    roles = check_roles(certificate)
    check_hereditary(certificate)
    reserves = check_reserves(certificate)
    check_power(certificate)
    jacobian, payload, envelope = check_jacobian(certificate)
    controls = self_test(certificate, payload, envelope) if args.self_test else []
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim"],
        "deduced_claim": certificate["deduced_claim"],
        "role_checks": roles,
        "reserve_reductions": reserves,
        "p0": certificate["power_summation"]["p0"],
        "jacobian": jacobian,
        "rejected_encoding": "admission failure; not mathematical evidence",
        "corruption_controls": controls,
        "scope": "exact arithmetic core; full application is proved in proof.md",
    }, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(json.dumps({"ok": False, "error": str(error)}), file=sys.stderr)
        sys.exit(1)
