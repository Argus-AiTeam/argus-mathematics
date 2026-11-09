#!/usr/bin/env python3
"""Replay exact algebra and arithmetic, not the topological proof in proof.tex."""

import argparse
from fractions import Fraction
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OPERATION = "polynomial.box.enclosure.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    number = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(number.numerator) == value["num"]
        and str(number.denominator) == value["den"],
        "Noncanonical rational in archived Jacobian data",
    )
    return number


def multiply_intervals(left, right):
    products = [a * b for a in left for b in right]
    return min(products), max(products)


def power_interval(interval, exponent):
    require(type(exponent) is int and exponent >= 0, "Invalid monomial exponent")
    if exponent == 0:
        return Fraction(1), Fraction(1)
    lower, upper = interval
    ends = lower**exponent, upper**exponent
    if exponent % 2 == 0 and lower <= 0 <= upper:
        return Fraction(0), max(ends)
    return min(ends), max(ends)


def sparse_coefficients(expression, variables):
    return [
        [list(exponents), str(coefficient)]
        for exponents, coefficient in sp.Poly(expression, *variables).terms()
    ]


def exact_calculations():
    r, rp, s, h, g, m, u, v = sp.symbols("r rp s h g m u v")
    f = r**2 * s
    dr_coefficient, ds_coefficient = sp.diff(f, r), sp.diff(f, s)
    require(
        sp.expand(dr_coefficient - 2 * r * s) == 0
        and sp.expand(ds_coefficient - r**2) == 0,
        "The annular differential identity failed",
    )
    end_df = (dr_coefficient * rp + ds_coefficient * h * g).subs(s, h)
    h_df = sp.expand(h * end_df)
    require(
        sp.expand(h_df - h**2 * (2 * r * rp + r**2 * g)) == 0,
        "The end-collar sign factorization failed",
    )

    epsilon = r * m * u / (4 * rp)
    side_bound = sp.expand(r**2 * m**2 - 2 * r * rp * epsilon * m)
    side_remainder = sp.cancel((side_bound - r**2 * m**2 / 2) / (r**2 * m**2))
    require(
        sp.expand(side_remainder - (1 - u) / 2) == 0,
        "The uniform side-band lower bound failed",
    )

    A, B = sp.symbols("A B")
    q = B - A
    sphere_gradient = 4 * ((1 + q) ** 2 * A + (1 - q) ** 2 * B)
    sphere_remainder = sp.expand(sphere_gradient - 4 * (1 - q**2))
    quotient, remainder = sp.div(
        sphere_remainder, A + B - 1, A, B, domain=sp.QQ
    )
    require(remainder == 0, "The sphere-gradient identity failed")
    require(
        sp.expand(quotient - 4 * (1 + q**2)) == 0,
        "The sphere-gradient remainder certificate failed",
    )
    inner_epsilon = sp.Rational(1, 4)
    inner_g = 4 * (1 - inner_epsilon**2)
    side_values = []
    for sign in (-1, 1):
        substitutions = {h: sign * inner_epsilon, r: 1, rp: 1, g: inner_g}
        side_values.append(
            {
                "sign": sign,
                "dt": "1",
                "signed_ds": str((sign * h * g).subs(substitutions)),
                "signed_df": str((sign * end_df).subs(substitutions)),
            }
        )

    z, eta, alpha, beta = sp.symbols("z eta alpha beta")
    cosine = (1 - z**2) / (1 + z**2)
    sine = 2 * z / (1 + z**2)
    lower_v, lower_w = eta * (1 - cosine), eta * (1 - sine)
    require(
        sp.cancel((lower_v - eta) ** 2 + (lower_w - eta) ** 2 - eta**2)
        == 0,
        "The lower rounding profile is not on its declared circle",
    )
    lower_normal = eta - lower_v, eta - lower_w
    upper_v, upper_w = -lower_v, -lower_w
    upper_normal = eta + upper_v, eta + upper_w
    for coordinates, normal in (
        ((lower_v, lower_w), lower_normal),
        ((upper_v, upper_w), upper_normal),
    ):
        tangency = sum(
            normal[i] * sp.diff(coordinates[i], z) for i in range(2)
        )
        require(sp.cancel(tangency) == 0, "A rounding conormal is not normal")
        require(
            sp.cancel(
                (normal[0] * alpha + normal[1] * beta) / eta
                - (alpha * (1 - z**2) + 2 * beta * z) / (1 + z**2)
            )
            == 0,
            "A rounding conormal has the wrong direction",
        )
    rounding_endpoints = {}
    for name, coordinates in (
        ("lower", (lower_v, lower_w)),
        ("upper", (upper_v, upper_w)),
    ):
        rounding_endpoints[name] = [
            [str(sp.cancel(x / eta).subs(z, end)) for x in coordinates]
            for end in (0, 1)
        ]

    x, y, t, mu_prime = sp.symbols("x y t mu_prime")
    mu = sp.Function("mu")
    handle_argument = x**2 + 2 * y**2
    modified = -x**2 + y**2 - mu(handle_argument)
    derivative = sp.diff(mu(t), t).subs(t, handle_argument)
    handle_x = sp.cancel(sp.diff(modified, x) / x).xreplace({derivative: mu_prime})
    handle_y = sp.cancel(sp.diff(modified, y) / y).xreplace({derivative: mu_prime})
    require(
        sp.expand(handle_x + 2 * (1 + mu_prime)) == 0
        and sp.expand(handle_y - 2 * (1 - 2 * mu_prime)) == 0,
        "The relative Morse-handle derivative identity failed",
    )

    corner_sums = []
    for dimension_parity in (0, 1):
        row = []
        for c_end_sign in (-1, 1):
            for j_end_sign in (-1, 1):
                first_order = (
                    c_end_sign * (-1) ** ((dimension_parity - 1) % 2) * j_end_sign
                )
                second_order = (
                    (-1) ** dimension_parity * j_end_sign * c_end_sign
                )
                row.append(int(first_order + second_order))
        require(row == [0, 0, 0, 0], "Product-boundary corner cancellation failed")
        corner_sums.append(row)

    dimensions = []
    base_dimension = 9
    connectivity = base_dimension + 1
    igusa_bound = max(2 * connectivity + 8, 3 * connectivity + 5)
    for k, l in ((20, 20), (20, 30)):
        sigma_dimension = k + l - 2
        inclusion_connectivity = min(k, l) - 1
        stable_extension_connectivity = inclusion_connectivity - 1
        maximal_stabilization_connectivity = min(
            (sigma_dimension - 8) // 2, (sigma_dimension - 5) // 3
        )
        guaranteed_composite_connectivity = min(
            maximal_stabilization_connectivity, stable_extension_connectivity
        )
        require(
            sigma_dimension >= igusa_bound
            and stable_extension_connectivity >= connectivity,
            "The manuscript's connectivity thresholds do not apply",
        )
        dimensions.append(
            {
                "k": k,
                "l": l,
                "base_dimension": base_dimension,
                "Sigma_dimension": sigma_dimension,
                "C_dimension": k + l - 1,
                "Y_dimension": k + l - 1,
                "W_dimension": k + l,
                "requested_connectivity": connectivity,
                "Igusa_bound": igusa_bound,
                "stability_margin": sigma_dimension - igusa_bound,
                "inclusion_connectivity": inclusion_connectivity,
                "stable_extension_connectivity": stable_extension_connectivity,
                "guaranteed_composite_connectivity": guaranteed_composite_connectivity,
                "maximum_base_dimension_from_these_estimates": (
                    guaranteed_composite_connectivity - 1
                ),
            }
        )
    margins = {
        "k20_l20_stability": (20 + u) + (20 + v) - 2 - igusa_bound,
        "k20_extension": 20 + u - 2 - connectivity,
        "l20_extension": 20 + v - 2 - connectivity,
        "actual_unbalanced_stability": (
            (20 + u) + (30 + u + v) - 2 - igusa_bound
        ),
    }
    for expression in margins.values():
        require(
            all(coefficient >= 0 for coefficient in sp.Poly(expression, u, v).coeffs())
            and expression.subs({u: 0, v: 0}) > 0,
            "A claimed universal dimension margin is not positive",
        )

    return {
        "annular_differential_coefficients_dr_ds": [
            str(dr_coefficient),
            str(ds_coefficient),
        ],
        "end_collar_h_df_terms": sparse_coefficients(h_df, (r, rp, h, g)),
        "side_bound_remainder_coefficients_in_u": [
            str(value) for value in sp.Poly(side_remainder, u).all_coeffs()
        ],
        "sphere_gradient_remainder_quotient": sparse_coefficients(quotient, (A, B)),
        "inner_quadratic_side_values": side_values,
        "rounding_axis_endpoints_in_units_of_eta": rounding_endpoints,
        "rounding_normal_numerator_terms": sparse_coefficients(
            alpha * (1 - z**2) + 2 * beta * z, (alpha, beta, z)
        ),
        "morse_derivative_factors_mu_prime_then_constant": [
            [str(value) for value in sp.Poly(expression, mu_prime).all_coeffs()]
            for expression in (handle_x, handle_y)
        ],
        "product_boundary_corner_sums_even_odd": corner_sums,
        "dimension_cases": dimensions,
        "universal_margin_terms_in_nonnegative_u_v": {
            name: sparse_coefficients(expression, (u, v))
            for name, expression in margins.items()
        },
    }


def replay_jacobian(metadata, expected_terms):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    observed = json.loads((HERE / "jacobian_output.json").read_text())
    require(metadata["operation_id"] == OPERATION, "Unexpected Jacobian operation")
    require(
        metadata["adapter_exit_code"] == 0
        and metadata["structured_error"] is None
        and metadata["timed_out"] is False,
        "A failed or incomplete adapter operation cannot support the certificate",
    )
    require(observed.get("error") is None, "Archived adapter output contains an error")
    result = observed["result"]
    require(result.get("error") is None, "Archived operation contains an error")
    require(
        observed["protocol_version"] == metadata["protocol_version"]
        and observed["server"]["version"] == metadata["server_version"]
        and observed["tool"] == "math.run"
        and observed["request"] == {"operation_id": OPERATION, "payload": payload}
        and result["operation_id"] == OPERATION,
        "Archived operation provenance does not match the retained request",
    )
    output = result["output"]
    require(
        output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"],
        "Jacobian output is bound to a different polynomial or box",
    )
    variables = payload["polynomial"]["variables"]
    require(
        variables == ["r", "rp", "h", "g"] == payload["box"]["variables"],
        "Incorrect sign-polynomial variable order",
    )
    terms = payload["polynomial"]["polynomial"]["terms"]
    retained_terms = [
        [term["exponents"], str(rational(term["coefficient"]))] for term in terms
    ]
    require(retained_terms == expected_terms, "Payload does not encode h*dF(V)")
    box = [
        (rational(axis["lower"]), rational(axis["upper"]))
        for axis in payload["box"]["intervals"]
    ]
    require(
        box
        == [
            (Fraction(1), Fraction(2)),
            (Fraction(1), Fraction(2)),
            (Fraction(-1), Fraction(-1, 4)),
            (Fraction(0), Fraction(4)),
        ],
        "The archived operation uses a different bounded sign domain",
    )
    enclosure = Fraction(0), Fraction(0)
    for term in terms:
        coefficient = rational(term["coefficient"])
        interval = coefficient, coefficient
        require(len(term["exponents"]) == len(box), "Monomial dimension mismatch")
        for axis, exponent in zip(box, term["exponents"]):
            interval = multiply_intervals(interval, power_interval(axis, exponent))
        enclosure = enclosure[0] + interval[0], enclosure[1] + interval[1]
    observed_enclosure = (
        rational(output["enclosure"]["lower"]),
        rational(output["enclosure"]["upper"]),
    )
    require(enclosure == observed_enclosure, "Independent interval replay disagrees")
    witnesses = (
        (Fraction(1), Fraction(1), Fraction(-1, 4), Fraction(0)),
        (Fraction(2), Fraction(2), Fraction(-1), Fraction(4)),
    )
    for witness, endpoint in zip(witnesses, enclosure):
        require(
            all(low <= coordinate <= high for coordinate, (low, high) in zip(witness, box)),
            "An endpoint witness lies outside the retained box",
        )
        r, rp, h, g = witness
        require(
            h**2 * (2 * r * rp + r**2 * g) == endpoint,
            "An enclosure endpoint is not attained at its stated witness",
        )
    require(enclosure[0] > 0, "The bounded sign calculation is not strictly positive")
    require(
        [str(value) for value in enclosure] == metadata["independently_replayed_enclosure"],
        "The certificate records a different interval result",
    )
    return [str(value) for value in enclosure]


def verify(certificate):
    require(certificate["schema_version"] == 1, "Unsupported certificate schema")
    require(
        certificate["machine_scope"] == "exact algebra, signs, dimensions, and one rational box",
        "The certificate must not claim machine verification of topology",
    )
    actual = exact_calculations()
    require(set(actual) == set(certificate["checks"]), "Certificate coverage mismatch")
    for name, value in actual.items():
        require(value == certificate["checks"][name], f"Calculation mismatch: {name}")
    enclosure = replay_jacobian(
        certificate["jacobian"], actual["end_collar_h_df_terms"]
    )
    return {
        "result": "PASS",
        "exact_check_groups": len(actual),
        "jacobian_enclosure": enclosure,
        "topology_machine_verified": False,
        "independent_review": certificate["independent_review"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "certificate",
        nargs="?",
        type=Path,
        default=HERE / "exact_certificate.json",
    )
    args = parser.parse_args()
    print(json.dumps(verify(json.loads(args.certificate.read_text())), indent=2))


if __name__ == "__main__":
    main()
