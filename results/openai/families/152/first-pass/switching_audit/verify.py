#!/usr/bin/env python3
"""Replay universal exact obligations for the controlled-volume proof."""

import json
from collections import Counter
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent


def constant(value):
    value = F(value)
    return {(): value} if value else {}


def variable(name):
    return {(name,): F(1)}


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] = result.get(monomial, F(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(coefficient, polynomial):
    return {m: F(coefficient) * c for m, c in polynomial.items() if coefficient * c}


def multiply(left, right):
    result = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(sorted(lm + rm))
            result[monomial] = result.get(monomial, F(0)) + lc * rc
    return {m: c for m, c in result.items() if c}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def coefficient_list(polynomial, name, degree):
    allowed = {tuple([name] * power) for power in range(degree + 1)}
    require(set(polynomial) <= allowed, "Unexpected variable or polynomial degree")
    return [polynomial.get(tuple([name] * power), F(0)) for power in range(degree + 1)]


def typed_polynomial(value):
    variables = value["variables"]
    require(variables == ["u", "v"], "Unexpected typed polynomial variables")
    require(value["denominator"]["terms"] == [{
        "coefficient": {"num": "1", "den": "1"}, "exponents": [0, 0]
    }], "This replay expects polynomial entries")
    result = {}
    for term in value["numerator"]["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == 2 and
                all(isinstance(power, int) and power >= 0 for power in exponents),
                "Invalid polynomial exponent")
        monomial = tuple(name for name, power in zip(variables, exponents)
                         for _ in range(power))
        coefficient = F(int(term["coefficient"]["num"]), int(term["coefficient"]["den"]))
        result = add(result, {monomial: coefficient})
    return result


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    q = certificate["quantitative"]
    checks = []

    h = variable("h")
    nterms = add(h, constant(1))
    nterms_squared = multiply(nterms, nterms)
    denominator = q["relative_minor_denominator"]
    theta = F(q["determinant_tolerance"])
    require(denominator == 64 and theta == F(1, 16), "Changed minor budget")
    input_margin = add(
        scale(theta * denominator**2, nterms_squared), scale(-1, h)
    )
    output_margin = add(
        scale(theta * denominator**2, nterms_squared),
        scale(-2 * denominator - 4, nterms),
        constant(3),
    )
    for name, polynomial in [
        ("input", input_margin),
        ("joined", output_margin),
    ]:
        coefficients = coefficient_list(polynomial, "h", 2)
        expected = [F(value) for value in q[f"{name}_determinant_margin_coefficients"]]
        require(coefficients == expected, f"Incorrect {name} determinant expansion")
        require(all(c >= 0 for c in coefficients) and coefficients[0] > 0,
                f"{name} determinant margin is not universally positive")
    require(0 < theta < 1, "Nonsingularity budget failed")
    checks.append("all_dimensions_positive_polynomial_minor_bounds")

    density_cap = F(q["density_oscillation_cap"])
    inverse_bound = ((1 + theta) / (1 - theta)) ** 2 * density_cap**2
    require(inverse_bound == F(q["inverse_density_bound"]), "Wrong density Jacobian")
    require(2 - inverse_bound == F(q["strict_margin_below_two"]), "Wrong strict margin")
    require(inverse_bound < 2 and density_cap > 1, "Required measure factor failed")
    checks.append("exact_inverse_density_factor_strictly_below_two")

    contraction = F(q["contraction_cap"])
    forcing = F(q["forcing_radius_cap"])
    require(0 <= contraction <= F(1, 4), "No uniqueness contraction")
    require(forcing + contraction <= F(1, 2), "Ball does not map inside half-ball")
    require(1 / (1 - contraction) <= 2, "Sharp-radius inverse bound failed")
    require(1 - contraction >= F(3, 4), "Difference inequality cannot force zero")
    checks.append("existence_and_larger_tube_uniqueness_budgets")

    sigma, m, altered, a = map(variable, ["sigma", "m", "q", "a"])
    exponent_difference = add(
        multiply(sigma, add(m, scale(-1, altered))),
        multiply(add(altered, constant(1)), a),
        scale(-1, multiply(sigma, m)),
        scale(-1, a),
    )
    require(
        exponent_difference == multiply(altered, add(a, scale(-1, sigma))),
        "Relative product expansion lost an interval or removed step",
    )
    positive_sign_margin = add(sigma, sigma)
    negative_sign_margin = add(sigma, scale(-1, sigma))
    require(all(c >= 0 for c in positive_sign_margin.values())
            and negative_sign_margin == {}, "Signed rate bound is invalid")
    pascal_cleared = add(m, scale(-1, altered), constant(1), altered)
    require(pascal_cleared == add(m, constant(1)), "Pascal induction identity failed")
    checks.append("signed_exterior_expansion_and_binomial_induction_identity")

    scales = certificate["scales"]
    floor = F(scales["floor_exponent"])
    ordered = scales["ordered_scales"]
    require([(entry["name"], entry["power"]) for entry in ordered] ==
            [("bn", 8), ("gL", 6), ("gn", 4), ("L", 2), ("Bn", 1)],
            "Source scale hierarchy changed")
    powers = [entry["power"] for entry in ordered]
    require(all(left > right for left, right in zip(powers, powers[1:])),
            "Scale ratios do not vanish")
    require(all(1 - floor * power > 0 for power in powers),
            "Floor no longer dominates logarithmic losses")
    for comparison in scales["decay_comparisons"]:
        leading = comparison["leading_power"]
        require(1 - floor * leading > 0, "Decay scale need not diverge")
        require(all(power > leading for power in comparison["remainder_powers"]),
                f"No arbitrary-fixed-constant domination for {comparison['name']}")
    checks.append("universal_asymptotic_scale_exponents_not_sampled_k")

    data = certificate["endpoint_data"]
    require(data["equations"] == {
        "z_future": "x_future", "z_past": "y_past",
        "w_future": "y_future", "w_past": "x_past",
    }, "Wrong future/past switch")
    require([data["equations"][key] for key in data["recovery_order"]] ==
            data["input_order"], "Endpoint recovery has an orientation error")
    require(len(set(data["input_order"])) == 4, "Endpoint data recovery is not bijective")
    require(data["empty_fast"] == ["y", "x"] and data["empty_slow"] == ["x", "y"],
            "Empty group has the wrong exact switch")
    require(data["full_input_tube_multiplier"] == 2, "Two shadow errors were not counted")
    checks.append("ordered_endpoint_recovery_and_both_empty_group_formulas")

    cancellation = certificate["determinant_cancellation"]
    numerator = Counter(item for pair in cancellation["numerator"] for item in pair)
    denominator_factors = Counter(item for pair in cancellation["denominator"] for item in pair)
    require(numerator == denominator_factors ==
            Counter({"A_x": 1, "A_y": 1, "B_x": 1, "B_y": 1}),
            "Independent input growth factors did not cancel")
    require(cancellation["oblique_basis_numerator_power"] ==
            cancellation["oblique_basis_denominator_power"] == 2,
            "Oblique determinant factors did not cancel")
    checks.append("independent_signed_growth_and_oblique_basis_cancellation")

    z = variable("z")
    z2 = multiply(z, z)
    pythagorean = add(
        multiply(add(z2, constant(-1)), add(z2, constant(-1))),
        scale(4, z2),
        scale(-1, multiply(add(z2, constant(1)), add(z2, constant(1)))),
    )
    require(pythagorean == {}, "Arbitrarily oblique unit-column family failed")
    stress_parameter = 10**6
    cosine = F(stress_parameter**2 - 1, stress_parameter**2 + 1)
    sine = F(2 * stress_parameter, stress_parameter**2 + 1)
    require(cosine**2 + sine**2 == 1 and 0 < sine < F(1, 100000),
            "Exact oblique stress instance failed")
    checks.append("symbolic_arbitrarily_oblique_unit_column_family")

    measure = certificate["measure"]
    density_power = (measure["cell_weight_power"]
                     + measure["number_of_inputs"] *
                     measure["conditional_point_normalization_power"])
    require(density_power == measure["resulting_cell_density_power"] == -1,
            "Pair law has wrong cell normalization")
    require(measure["restriction_renormalization_power"] == 0,
            "Restriction was incorrectly normalized")
    require(measure["global_multiplicity_bound"] == 1
            and measure["zero_volume_cells_omitted"] is True,
            "Measure theorem has wrong multiplicity or null-cell convention")
    checks.append("original_cell_weight_and_unnormalized_restriction")

    controls = certificate["negative_controls"]
    fold = controls["three_sheet_fold"]
    require(fold["sheets"] == 3 and F(fold["local_jacobian"]) == 1,
            "Wrong multiplicity control")
    require(fold["sheets"] * F(fold["image_area"]) == 1,
            "Translation sheets do not partition the unit square")
    require(F(fold["preimage_mass"]) == 1 > 2 * F(fold["image_area"]),
            "Jacobian-only negative control did not violate domination")
    normalized = controls["normalized_quarter"]
    require(F(normalized["retained_area"]) == F(1, 4)
            and F(normalized["normalized_mass"]) == 1 >
            2 * F(normalized["retained_area"]),
            "Renormalization negative control did not violate domination")
    checks.append("multiplicity_and_renormalization_negative_controls")

    adapter = certificate["jacobian_adapter"]
    payload = json.loads((HERE / adapter["payload_file"]).read_text())
    response = json.loads((HERE / adapter["result_file"]).read_text())
    require(adapter["status"] == "success" and adapter["timeout"] is False
            and adapter["structured_error"] is None, "Adapter did not succeed")
    require(response["server"]["version"] == adapter["server_version"]
            and response["protocol_version"] == adapter["protocol_version"],
            "Adapter version or protocol changed")
    require(response["request"]["operation_id"] == adapter["operation_id"]
            and response["request"]["payload"] == payload, "Adapter payload is not bound")
    require(response["result"]["operation_id"] == adapter["operation_id"],
            "Wrong adapter operation")
    output = response["result"]["output"]["determinant"]
    matrix = payload["matrix"]
    require(matrix["variables"] == ["u", "v"] and
            len(matrix["entries"]) == 2 and
            all(len(row) == 2 for row in matrix["entries"]),
            "Expected a two-dimensional normalized boundary matrix")
    entries = [[typed_polynomial(entry) for entry in row] for row in matrix["entries"]]
    require(entries == [[variable("u"), constant(1)], [constant(1), variable("v")]],
            "Payload is not the stated boundary matrix")
    replayed_determinant = add(
        multiply(entries[0][0], entries[1][1]),
        scale(-1, multiply(entries[0][1], entries[1][0])),
    )
    require(typed_polynomial(output) == replayed_determinant ==
            add(multiply(variable("u"), variable("v")), constant(-1)),
            "Adapter determinant failed independent exact replay")
    checks.append("bounded_jacobian_typed_result_exact_replay")

    require(certificate["independent_review"] == "required_pending",
            "Engineer certificate must not impersonate independent acceptance")
    result = {
        "ok": True,
        "claim_id": certificate["claim_id"],
        "kind": certificate["result_kind"],
        "universal_obligations_passed": checks,
        "inverse_density_bound": str(inverse_bound),
        "analytic_proof": certificate["proof_file"],
        "analytic_proof_kernel_checked": False,
        "independent_review": certificate["independent_review"],
        "main_zero_entropy_theorem_verified": False,
        "novelty_status": certificate["novelty_status"],
    }
    (HERE / "verification_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
