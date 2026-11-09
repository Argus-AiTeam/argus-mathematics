#!/usr/bin/env python3
"""Replay exact algebra used in report.md; this is not an analytic proof checker."""

import json
from fractions import Fraction as F
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def multiply(left, right):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            require(len(a) == len(b), "Polynomial dimensions differ")
            exponent = tuple(i + j for i, j in zip(a, b))
            result[exponent] = result.get(exponent, F(0)) + x * y
    return {e: c for e, c in result.items() if c}


def add(left, right):
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, F(0)) + coefficient
    return {e: c for e, c in result.items() if c}


def scale(polynomial, coefficient):
    return {e: coefficient * c for e, c in polynomial.items() if coefficient * c}


def rational(value):
    require(set(value) == {"num", "den"}, "Invalid rational shape")
    require(isinstance(value["num"], str), "Numerator must be a string")
    require(isinstance(value["den"], str), "Denominator must be a string")
    result = F(int(value["num"]), int(value["den"]))
    require(str(result.numerator) == value["num"], "Noncanonical numerator")
    require(str(result.denominator) == value["den"], "Noncanonical denominator")
    return result


def typed_polynomial(value):
    require(value["domain"] == "QQ", "Wrong polynomial coefficient field")
    require(value["variables"] == ["t"], "Wrong Jacobian variable")
    result = {}
    previous = None
    for term in value["polynomial"]["terms"]:
        powers = term["exponents"]
        require(len(powers) == 1, "Expected a univariate polynomial")
        require(type(powers[0]) is int and 0 <= powers[0] <= 5, "Invalid degree")
        exponent = tuple(powers)
        require(previous is None or previous > exponent, "Noncanonical term order")
        require(exponent not in result, "Duplicate monomial")
        coefficient = rational(term["coefficient"])
        require(coefficient != 0, "Zero term in sparse polynomial")
        result[exponent] = coefficient
        previous = exponent
    return result


def check_jacobian(certificate):
    metadata = certificate["jacobian"]
    request = json.loads((ROOT / "jacobian_request.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    operation = "polynomial.factor.compute"
    require(metadata["operation_id"] == operation, "Wrong recorded operation")
    require(metadata["adapter_exit_code"] == 0, "Adapter did not succeed")
    require(metadata["adapter_error"] is None, "Recorded adapter error")
    require(metadata["timed_out"] is False, "Recorded adapter timeout")
    require(response["schema_version"] == 1, "Wrong adapter schema")
    require(response["protocol_version"] == metadata["protocol_version"], "Protocol mismatch")
    require(response["server"]["name"] == "jacobian", "Wrong sidecar")
    require(response["server"]["version"] == metadata["server_version"], "Version mismatch")
    require(response["tool"] == "math.run", "Not an execution result")
    require(response["transport"] == "mcp-stdio", "Wrong transport")
    require(response["request"] == {"operation_id": operation, "payload": request},
            "Retained request differs from the executed payload")
    result = response["result"]
    require(result["operation_id"] == operation, "Result operation mismatch")
    output = result["output"]
    require(output["normalization"] == "CONTENT_AND_MONIC_IRREDUCIBLES",
            "Wrong factor normalization")
    require(output["product_reconstruction"] == "EXACT", "Incomplete factorization")
    target = {(5,): F(3), (3,): F(-5), (0,): F(2)}
    require(typed_polynomial(request["polynomial"]) == target, "Wrong input polynomial")
    require(output["polynomial"] == request["polynomial"], "Wrong retained source")
    require(typed_polynomial(output["reconstructed"]) == target, "Wrong reconstruction")
    product = {(0,): rational(output["coefficient"])}
    degree = 0
    for item in output["factors"]:
        multiplicity = item["multiplicity"]
        require(type(multiplicity) is int and 1 <= multiplicity <= 5,
                "Invalid factor multiplicity")
        factor = typed_polynomial(item["factor"])
        require(factor, "Empty factor")
        degree += max(e[0] for e in factor) * multiplicity
        for _ in range(multiplicity):
            product = multiply(product, factor)
    require(degree == 5 and product == target, "Independent product replay failed")


def check_convex_remainder():
    square = {(2, 0): F(1), (1, 1): F(-2), (0, 2): F(1)}
    cubic = {(3, 0): F(3), (2, 1): F(6), (1, 2): F(4), (0, 3): F(2)}
    target = {(5, 0): F(3), (3, 2): F(-5), (0, 5): F(2)}
    require(multiply(square, cubic) == target, "Homogeneous convexity identity failed")
    require(all(c > 0 for c in cubic.values()), "Cubic lacks positive coefficients")
    require(F(2) ** 5 / 4 == 8, "Coercivity split constant failed")
    return {
        "homogeneous_factor_coefficients": ["3", "6", "4", "2"],
        "coercivity_sigma_coefficient": "1/4",
        "coercivity_rho_coefficient": "-8"
    }


def check_kinetic_coefficient():
    packet_cube = F(3) ** 5 / F(10) ** 3
    neumann_cube = F(3, 5) ** 3 * F(1, 2) ** 3 * F(3) ** 2
    tf_cube = F(3, 10) ** 3 * F(3) ** 2
    require(packet_cube == neumann_cube == tf_cube, "Sharp kinetic coefficients differ")
    require(2 * 5 - 2 * 3 == 2 * 3 - 2 == 4, "Pi powers differ")
    return {
        "coefficient_cubed_over_pi_to_fourth": str(tf_cube),
        "pi_power_after_cubing": 4,
        "spin_degeneracy": 2,
        "kinetic_laplacian_factor": "1/2"
    }


def check_normalizations():
    square = {(2, 0): F(1), (1, 1): F(-2), (0, 2): F(1)}
    total_square = multiply({(1, 0): F(1), (0, 1): F(1)},
                            {(1, 0): F(1), (0, 1): F(1)})
    twice_sum = {(2, 0): F(2), (0, 2): F(2)}
    require(add(twice_sum, scale(total_square, F(-1))) == square,
            "Uniform square comparison failed")
    small = {
        "a_m0": F(1) - 3,
        "a_m0_to_two_thirds": F(1) - 3 * F(2, 3),
        "a_m0_to_one_third": F(1) - 3 * F(1, 3)
    }
    require(all(e <= 0 for e in small.values()), "Small-scale normalization failed")
    require(F(1) >= 0, "Large-scale normalization failed")
    return {
        "small_scale_exponents": {name: str(e) for name, e in small.items()},
        "large_scale_exponents": {name: "1" for name in small},
        "energy_max_comparison_constants": ["1", "4"]
    }


def check_trial_ratios():
    # Ordered monomial exponents are (lambda, a, h).
    mass = (F(1), F(1), F(1))
    benefit = (F(1), F(1), F(2))
    kinetic = tuple(F(5, 3) * e for e in mass)
    kinetic = (kinetic[0], kinetic[1] - 2, kinetic[2])
    linear = (mass[0], mass[1] - 2, mass[2])
    direct = (2 * mass[0], 2 * mass[1] - 1, 2 * mass[2])
    ratios = [tuple(a - b for a, b in zip(term, benefit))
              for term in (kinetic, linear, direct)]
    expected = [
        (F(2, 3), F(-4, 3), F(-1, 3)),
        (F(0), F(-2), F(-1)),
        (F(1), F(0), F(0))
    ]
    require(ratios == expected, "Positive-field trial normalization failed")
    return [[str(e) for e in row] for row in ratios]


def check_recursion():
    # Polynomials in (r,j), where r=2^j. These identities prove the induction step.
    loss_c = {(1, 0): F(2), (0, 1): F(-1), (0, 0): F(-2)}
    loss_d = {(1, 0): F(1), (0, 0): F(-1)}
    next_c = {(1, 0): F(4), (0, 1): F(-1), (0, 0): F(-3)}
    next_d = {(1, 0): F(2), (0, 0): F(-1)}
    require(add(scale(loss_c, 2), {(0, 1): F(1), (0, 0): F(1)}) == next_c,
            "Recursion c-loss induction failed")
    require(add(scale(loss_d, 2), {(0, 0): F(1)}) == next_d,
            "Recursion d-loss induction failed")
    require(2 * 1 - 0 - 2 == 0 and 1 - 1 == 0, "Recursion base case failed")
    return {
        "c_loss": "2*r-j-2",
        "d_loss": "r-1",
        "r": "2^j",
        "initial_log_threshold": "2*c+d+M",
        "c": "log(C)",
        "d": "log(4)"
    }


def check_supersolution():
    power = 4
    constant = 6 * power
    radial = 4 * power * (power + 1)
    numerator = [constant, radial - constant]
    require(numerator == [24, 56], "Radial Laplacian numerator failed")
    require(sum(numerator) == 80, "Supersolution upper coefficient failed")
    require((power + 2) == power * F(3, 2) == 6, "Denominator powers differ")
    require(4 * F(3, 2) == 6, "Numerator scale powers differ")
    return {"s_squared_coefficient": 24, "r_squared_coefficient": 56, "upper": 80}


def check_bootstrap():
    # Ordered exponents: (P,a,m,beta). Multiply each energy error by a/(P*m^2).
    multiplier = (F(-1), F(1), F(-2), F(0))
    errors = [
        (F(1, 2), F(-1), F(1), F(-1)),
        (F(2, 3), F(-2), F(4, 3), F(-2)),
        (F(1, 2), F(-2), F(1), F(-2))
    ]
    ratios = [tuple(a + b for a, b in zip(term, multiplier)) for term in errors]
    require(ratios == [
        (F(-1, 2), F(0), F(-1), F(-1)),
        (F(-1, 3), F(-1), F(-2, 3), F(-2)),
        (F(-1, 2), F(-1), F(-1), F(-2))
    ], "Count bootstrap normalization failed")
    threshold_powers = [F(1), F(1), F(2), F(3), F(2)]
    p_decay = [F(1), F(1), F(1, 2), F(1, 3), F(1, 2)]
    require(all(a * b == 1 for a, b in zip(threshold_powers, p_decay)),
            "P0 threshold powers failed")
    bound = F(7, 32)
    require(bound < F(1, 2), "Bootstrap contraction is not strict")
    return {
        "normalized_error_exponents_P_a_m_beta":
            [[str(e) for e in row] for row in ratios],
        "P0_threshold_powers": [str(e) for e in threshold_powers],
        "contracting_ratio": str(bound)
    }


def check_fine_exponents():
    beta, epsilon, m = F(1, 5), F(1, 50), F(-3)
    b, e = 1 + beta, 2 * m - 1
    target = -7 + epsilon
    powers = {
        "delta": target,
        "epsilon_P_e": epsilon + e,
        "sqrt_beta_P_e": beta / 2 + e,
        "nuclear_loss": -F(3, 2) * epsilon + beta / 2 - 7,
        "pair_self_error": -b + m,
        "cube_four_thirds_error": -2 * b + F(4, 3) * m,
        "cube_linear_error": -2 * b + m
    }
    require(all(x >= target for x in powers.values()), "Fine error exponent misses target")
    condition = -2 * beta - (1 + m)
    require(condition == F(8, 5) and condition > 0, "Patch condition scaling failed")
    offset_mass = (target + 1) / 2
    require(offset_mass >= m, "Offset mass is larger than the stated bound")
    require(-2 * b + m >= -7, "Out kinetic error is too large")
    require(-3 * F(5, 2) + F(1, 2) == -7, "Local nuclear power failed")
    require(-3 * F(3, 2) + F(3, 2) == -3, "Interior TF mass power failed")
    return {
        "target": str(target),
        "terms": {name: str(power) for name, power in powers.items()},
        "patch_condition_exponent": str(condition),
        "offset_mass_exponent": str(offset_mass),
        "b_exponent": str(b),
        "local_nuclear_power": "-7",
        "interior_TF_mass_power": "-3"
    }


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["schema_version"] == 1, "Wrong certificate schema")
    require(certificate["claim"] == "C_SCREEN_CORE", "Wrong claim")
    require(certificate["result_class"] == "analytic_verification", "Wrong evidence class")
    require(certificate["analytic_proof_machine_checked"] is False,
            "An algebra replay must not claim to check the analytic proof")
    require(certificate["independent_review"]["required"] is True,
            "Independent review requirement was removed")
    require(certificate["independent_review"]["completed"] is False,
            "This Engineer certificate cannot invent Reviewer acceptance")
    require(set(certificate["manuscript_labels"]) == {
        "m:lem:screen-positive-field", "m:lem:screen-patch",
        "m:lem:screen-count", "m:lem:screen-density"
    }, "Wrong statement scope")
    require((ROOT / certificate["analytic_proof"]).is_file(), "Analytic proof missing")
    check_jacobian(certificate)
    checks = {
        "convex_remainder": check_convex_remainder(),
        "sharp_kinetic_coefficient": check_kinetic_coefficient(),
        "normalizations": check_normalizations(),
        "positive_trial_ratio_exponents_lambda_a_h": check_trial_ratios(),
        "conditional_field_recursion": check_recursion(),
        "interior_supersolution": check_supersolution(),
        "count_bootstrap": check_bootstrap(),
        "fine_exponents": check_fine_exponents()
    }
    require(checks == certificate["exact_checks"], "Certificate differs from exact replay")
    print(json.dumps({
        "claim": certificate["claim"],
        "exact_algebra_checks": "passed",
        "checks": list(checks),
        "jacobian_product_replay": "passed",
        "analytic_proof_machine_checked": False,
        "independent_review_required": True,
        "novelty_claimed": False
    }, indent=2))


if __name__ == "__main__":
    main()
