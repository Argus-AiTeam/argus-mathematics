#!/usr/bin/env python3
"""Exact arithmetic replay supporting REPORT.md and the universal Lean proof."""

import argparse
from fractions import Fraction as F
from itertools import product
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, label):
    residual = sp.simplify(sp.expand_power_base(expression, force=True))
    check(residual == 0, f"{label}: nonzero symbolic residual {residual}")


def symbolic_checks():
    alpha, r, cutoff, B = sp.symbols("alpha r cutoff B", positive=True)
    p = alpha + 2
    tail = sp.integrate(p * r ** (1 - p), (r, cutoff, sp.oo))
    zero(tail - p / (p - 2) * cutoff ** (2 - p), "large-jump second moment")
    bin_energy = sp.integrate(p / r, (r, cutoff, 2 * cutoff))
    zero(bin_energy - p * sp.log(2), "one dyadic energy bin")
    zero(cutoff ** (2 - p) * cutoff ** (p - 2) - 1, "reciprocal dyadic weights")
    zero(
        4 * (4 * B) ** (p - 2)
        - 4 ** (p - 1) * B ** (p - 2),
        "cap constant",
    )
    a = sp.symbols("a", positive=True)
    d = 2 + a**2
    n = sp.Matrix([1, 1, -a])
    P = sp.eye(3) - n * n.T / d
    g = sp.Matrix([[1, 0], [0, 1], [1 / a, 1 / a]])
    for label, matrix in (
        ("sharpness idempotence", P * P - P),
        ("sharpness self-adjointness", P.T - P),
        ("sharpness fixed increments", P * g - g),
    ):
        for entry in matrix:
            zero(entry, label)
    m, m_shift = sp.symbols("m m_shift", real=True)
    u = sp.Matrix([m, 0, m_shift / a])
    for entry in (P - sp.eye(3)) * u + n * (m - m_shift) / d:
        zero(entry, "sharpness projection error vector")
    zero((1 + a / d) - (2 * a + 2) / d - a * (a - 1) / d, "maximum row sum")
    ell = sp.symbols("ell", positive=True)
    sharp = 2 * p * F(4, 3) / d**p * (2 * ell * sp.log(2) / p)
    zero(sharp - 16 * ell * sp.log(2) / (3 * d**p), "sharpness energy constant")
    gradient = sp.symbols("gradient_energy", nonnegative=True)
    filter_energy = 2 * p * F(4, 3) / d**p * (sp.log(2) / p) * gradient
    zero(
        filter_energy - 8 * sp.log(2) / (3 * d**p) * gradient,
        "all-profile sharpness energy constant",
    )
    return {
        "large_jump_second_moment": "p/(p-2)*cutoff^(2-p), p=2+alpha, alpha>0",
        "dyadic_bin_energy": "p*log(2)",
        "reciprocal_dyadic_weight_residual": "0",
        "cap_constant_residual": "0",
        "sharpness_projection_residuals": "all zero as rational functions of a>0",
        "sharpness_error_vector": "-n*(m-m_shift)/(2+a^2)",
        "sharpness_energy": "16*ell*log(2)/(3*(2+2^(2/p))^p)",
        "finite_profile_energy": "8*log(2)/(3*(2+2^(2/p))^p)*sum_j |c_j-c_(j-1)|^p",
        "sharpness_scope": "The all-parameter interval argument is in REPORT.md, Section 5.",
    }


def multiplicity(ell, magnitude):
    return sum(F(2**k) < magnitude <= F(2 ** (k + ell)) for k in range(ell))


def combinatorial_checks():
    for ell in range(1, 65):
        counts = []
        for j in range(2 * ell + 3):
            count = sum(k <= j < k + ell for k in range(ell))
            formula = max(0, min(ell, j + 1) - max(0, j + 1 - ell))
            check(count == formula, f"multiplicity: ell={ell}, j={j}")
            counts.append(count)
        check(
            counts[: 2 * ell - 1] == list(range(1, ell + 1)) + list(range(ell - 1, 0, -1)),
            f"triangular profile: ell={ell}",
        )
        jumps = [counts[j] - (counts[j - 1] if j else 0) for j in range(2 * ell)]
        check(jumps == [1] * ell + [-1] * ell, f"sharpness jumps: ell={ell}")
    return {
        "finite_replay_lengths": [1, 64],
        "multiplicity_formula": "min(ell,j+1) - (j+1-ell), using natural subtraction",
        "universal_formal_declaration": "RampCore.multiplicity_formula",
        "jump_profile": "ell positive jumps followed by ell negative jumps, all of size one",
    }


def filter_checks():
    count = 0
    for length in range(1, 6):
        for profile in product((-2, -1, 0, 1, 2), repeat=length):
            if not any(profile):
                continue
            extended = (0,) + profile + (0,)
            differences = [extended[j + 1] - extended[j] for j in range(length + 1)]
            for p in (3, 4, 8):
                input_energy = sum(abs(value) ** p for value in profile)
                gradient_energy = sum(abs(value) ** p for value in differences)
                check(gradient_energy > 0, "a nonzero finite profile must have nonzero gradient")
                check(input_energy <= length**p * gradient_energy, "finite-profile Poincare bound")
                count += 1
    for ell, p in product(range(1, 33), (3, 4, 8)):
        profile = tuple(range(1, ell + 1)) + tuple(range(ell - 1, 0, -1))
        extended = (0,) + profile + (0,)
        gradient = sum(abs(extended[j + 1] - extended[j]) ** p for j in range(2 * ell))
        check(gradient == 2 * ell, "triangular profile exact gradient energy")
    return {
        "finite_profile_checks": count,
        "profile_lengths": [1, 5],
        "coefficients": [-2, -1, 0, 1, 2],
        "integer_exponents": [3, 4, 8],
        "exact_identity": "error_p = 8*log(2)/(3*(2+2^(2/p))^p)*sum |Delta c|^p",
        "universal_method_barrier": "relative error >= [8/(3*p*(2+2^(2/p))^p)]^(1/p)/N",
        "scope": "The all-real-p, all-finite-profile proof is REPORT.md (18)-(19); these are bounded arithmetic checks, not its proof.",
    }


def projection(normal, sigma):
    dimension = len(normal)
    denominator = sum(normal[e] ** 2 / sigma[e] for e in range(dimension))
    check(denominator > 0, "projection normal must be nonzero")
    return [
        [
            F(e == f) - normal[e] * normal[f] / (sigma[e] * denominator)
            for f in range(dimension)
        ]
        for e in range(dimension)
    ]


def mv(matrix, vector):
    return [sum(entry * value for entry, value in zip(row, vector, strict=True)) for row in matrix]


def add_log(target, coefficient, ratio):
    check(ratio > 0, "log argument must be positive")
    if coefficient == 0 or ratio == 1:
        return
    for integer, sign in ((ratio.numerator, 1), (ratio.denominator, -1)):
        for prime, valuation in sp.factorint(integer).items():
            target[int(prime)] = target.get(int(prime), F(0)) + coefficient * sign * int(valuation)
            if target[int(prime)] == 0:
                del target[int(prime)]


def serialized_log(value):
    return [{"prime": prime, "coefficient": str(value[prime])} for prime in sorted(value)]


def integrate_ramp(P, sigma, columns, angular_powers, p, ell):
    dimension = len(sigma)
    input_energies = [{} for _ in sigma]
    error_energy = {}
    error_upper = F(0)
    interval_count = 0
    for column, angular_power in zip(columns, angular_powers, strict=True):
        endpoints = sorted(
            {
                F(2**k) / abs(value)
                for value in column
                if value
                for k in range(2 * ell)
            }
        )
        if not endpoints:
            check(all(value == 0 for value in column), "only a zero angular copy may have no cuts")
            continue
        for lo, hi in zip(endpoints, endpoints[1:]):
            midpoint = (lo + hi) / 2
            u = [value * multiplicity(ell, abs(midpoint * value)) for value in column]
            projected = mv(P, u)
            error = [projected[e] - u[e] for e in range(dimension)]
            ratio = hi / lo
            for e in range(dimension):
                add_log(input_energies[e], p * angular_power * abs(u[e]) ** p, ratio)
            coefficient = p * angular_power * sum(
                sigma[e] * abs(error[e]) ** p for e in range(dimension)
            )
            add_log(error_energy, coefficient, ratio)
            error_upper += coefficient * (ratio - 1)
            interval_count += 1
    return input_energies, error_energy, error_upper, interval_count


def verify_case(name, normal, sigma, columns, angular_powers, p, ell):
    dimension = len(sigma)
    check(all(weight > 0 for weight in sigma) and sum(sigma) == 1, f"{name}: edge probability")
    check(all(weight > 0 for weight in angular_powers), f"{name}: angular powers")
    check(all(len(column) == dimension for column in columns), f"{name}: angular dimensions")
    P = projection(normal, sigma)
    for e in range(dimension):
        check(
            sum(weight * abs(column[e]) ** p for column, weight in zip(columns, angular_powers, strict=True))
            == 1,
            f"{name}: original marginal normalization at edge {e}",
        )
        for f in range(dimension):
            check(sigma[e] * P[e][f] == sigma[f] * P[f][e], f"{name}: weighted self-adjointness")
            check(
                sum(P[e][j] * P[j][f] for j in range(dimension)) == P[e][f],
                f"{name}: projection idempotence",
            )
    for column in columns:
        check(mv(P, column) == column, f"{name}: Pv=v")
    H = max(sum(abs(entry) for entry in row) for row in P)
    check(H >= 1, f"{name}: H>=1")
    inputs, error, upper, intervals = integrate_ramp(P, sigma, columns, angular_powers, p, ell)
    energy_coefficient = p * (ell**p + 2 * sum(j**p for j in range(1, ell)))
    check(
        all(energy == {2: F(energy_coefficient)} for energy in inputs),
        f"{name}: exact common energy, p={p}, ell={ell}",
    )
    q = F(1, 2 ** (p - 2))
    cap_constant = F(4 ** (p - 1)) / (1 - q)
    error_constant = 2 ** (p - 1) * cap_constant * F(p, p - 2)
    bound = error_constant * H ** (p - 2) * ell
    check(upper <= bound, f"{name}: exact upper certificate, p={p}, ell={ell}")
    return {
        "family": name,
        "p": p,
        "ell": ell,
        "sigma": [str(weight) for weight in sigma],
        "normal": [str(value) for value in normal],
        "H": str(H),
        "error_energy_log_prime_coefficients": serialized_log(error),
        "error_upper_using_log_x_le_x_minus_one": str(upper),
        "proved_theorem_bound": str(bound),
        "common_input_energy_log2_coefficient": energy_coefficient,
        "radial_intervals": intervals,
    }


def exact_experiments():
    cases = []
    eps = F(1, 10**12)
    weights = [
        [F(1, 3)] * 3,
        [F(1, 2), F(1, 3), F(1, 6)],
        [1 - 2 * eps, eps, eps],
    ]
    cyclic = [[F(1), F(-3), F(2)], [F(2), F(1), F(-3)], [F(-3), F(2), F(1)], [F(0)] * 3]
    zero_pattern = [[F(1), F(0), F(-1)], [F(-1), F(1), F(0)], [F(0), F(-1), F(1)], [F(0)] * 3]
    for p, ell, sigma in product((3, 4, 8), (1, 2, 7, 16), weights):
        normalization = 1 + 2**p + 3**p
        cases.append(verify_case(
            "cyclic", [F(1)] * 3, sigma, cyclic, [F(1, normalization)] * 4, p, ell
        ))
    for p, ell, sigma in product((3, 4, 8), (1, 2, 9), (weights[0], weights[2])):
        case = verify_case("zero-pattern", [F(1)] * 3, sigma, zero_pattern, [F(1, 2)] * 4, p, ell)
        check(not case["error_energy_log_prime_coefficients"], "equal active magnitudes must give zero error")
        cases.append(case)
    for p, ell, epsilon in product((3, 4, 8), (1, 2, 9), (F(1, 2), F(1, 16), eps)):
        normal = [epsilon, F(1), F(-1)]
        sigma = [epsilon**2, (1 - epsilon**2) / 2, (1 - epsilon**2) / 2]
        columns = [[F(1), -epsilon / 2, epsilon / 2], [F(0), F(1), F(1)], [F(0)] * 3]
        powers = [F(1), 1 - (epsilon / 2) ** p, F(1)]
        cases.append(verify_case("narrow-triangle", normal, sigma, columns, powers, p, ell))

    p, ell, sigma = 4, 7, weights[1]
    reference = verify_case("orientation-reference", [F(1)] * 3, sigma, cyclic, [F(1, 98)] * 4, p, ell)
    for signs in product((-1, 1), repeat=3):
        oriented = [[signs[e] * column[e] for e in range(3)] for column in cyclic]
        case = verify_case(
            "orientation", [F(sign) for sign in signs], sigma, oriented, [F(1, 98)] * 4, p, ell
        )
        check(
            case["error_energy_log_prime_coefficients"] == reference["error_energy_log_prime_coefficients"],
            "orientation conjugation changed the absolute projection error",
        )
        check(case["H"] == reference["H"], "orientation conjugation changed H")

    selected = [
        case for case in cases
        if (case["family"], case["p"], case["ell"], case["sigma"]) in (
            ("cyclic", 4, 7, [str(weight) for weight in weights[0]]),
            ("zero-pattern", 3, 1, [str(weight) for weight in weights[2]]),
            ("narrow-triangle", 3, 9, [str(eps**2), str((1 - eps**2) / 2), str((1 - eps**2) / 2)]),
        )
    ]
    check(len(selected) == 3, "selected boundary cases must be present")
    return {
        "case_count": len(cases),
        "orientation_checks": 8,
        "integer_exponents": [3, 4, 8],
        "ramp_lengths": [1, 2, 7, 9, 16],
        "minimum_edge_probability": str(min(F(value) for case in cases for value in case["sigma"])),
        "maximum_row_sum": str(max(F(case["H"]) for case in cases)),
        "radial_interval_count": sum(case["radial_intervals"] for case in cases),
        "selected_exact_cases": selected,
        "interpretation": "Finite adversarial checks only; not a proof over all p or all configurations.",
        "construction": "g(t)=angular_power[t]^(1/p)*column[t], with original density p*r^(-p-1)dr.",
    }


def jacobian_check():
    discovery = json.loads((ROOT / "jacobian_find.json").read_text())
    contract = json.loads((ROOT / "jacobian_contract.json").read_text())
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    operation = "matrix.symmetric.rational_spectrum_claim.check"
    check(contract["result"]["operation"]["operation_id"] == operation, "Jacobian inspected operation")
    check(output["request"]["operation_id"] == operation, "Jacobian executed operation")
    check(output["request"]["payload"] == payload, "Jacobian exact payload preservation")
    result = output["result"]["output"]
    check(result["outcome"] == "VALID" and result["valid_complete_rational_spectrum"], "Jacobian outcome")
    check(result["established_multiplicity_sum"] == 3, "Jacobian complete spectrum")
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "transport": output["transport"],
        "outcome": result["outcome"],
        "adapter_error": None,
        "timeout": False,
        "scope": "One exact rational test projection, not the universal analytic estimate.",
        "capability_mismatch": "Discovered contracts are finite algebraic operations; none inspected supplies real-exponent measure integration or the universal ramp estimate.",
        "discovery_query": discovery["result"]["query"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact replay certificate")
    args = parser.parse_args()
    certificate = {
        "kind": "exact_symbolic_and_combinatorial_replay",
        "claim": "C_RAMP_ESTIMATES",
        "extension_claims": ["C_TAPER_FILTER", "C_TAPER_SHARPNESS"],
        "universal_proof": {
            "formal_source": "Main.lean",
            "report": "REPORT.md",
            "core_declarations": [
                "RampCore.signed_dyadic_cap",
                "RampCore.signed_dyadic_lintegral",
                "RampCore.ramp_error_energy",
                "RampCore.weighted_quadratic_contraction",
                "RampCore.row_cutoff_cap",
                "RampCore.linear_ramp_identity",
                "RampCore.projection_tail_identity",
                "RampCore.rampError_eq_blocks",
                "RampCore.multiplicity_formula",
            ],
            "constant": "C_p=8^(p-1)*p/((p-2)*(1-2^(2-p)))",
            "scope": "All real p>2; the actual marginal-density reduction and sharpness interval proof are explicit in REPORT.md.",
        },
        "symbolic_checks": symbolic_checks(),
        "combinatorics": combinatorial_checks(),
        "finite_profile_barrier": filter_checks(),
        "experiments": exact_experiments(),
        "jacobian": jacobian_check(),
        "independent_review": "required; this script does not manufacture a Reviewer verdict",
        "novelty": "not established by the finite replay or by a compiler",
    }
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(path.read_text())
        check(recorded == certificate, "exact_certificate.json differs from the rerun")
    experiment = certificate["experiments"]
    print(
        f"PASS: universal symbolic reductions; {experiment['case_count']} exact ramp cases; "
        f"{experiment['orientation_checks']} orientation checks; Jacobian VALID."
    )
    print("Universal validity rests on Main.lean and REPORT.md, not the bounded experiments.")


if __name__ == "__main__":
    main()
