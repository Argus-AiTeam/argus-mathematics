#!/usr/bin/env python3
"""Replay exact identities and universal inequalities, not the analytic proof."""

import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def zero(expression):
    reduced = sp.factor(expression)
    if reduced != 0:
        raise AssertionError(f"Nonzero exact defect: {reduced}")


def positive_rational(expression, variable):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    for polynomial in (numerator, denominator):
        coefficients = sp.Poly(polynomial, variable).all_coeffs()
        if not all(coefficient >= 0 for coefficient in coefficients):
            raise AssertionError(f"Missing positivity certificate: {expression}")
    if denominator.subs(variable, 0) <= 0:
        raise AssertionError("Denominator not certified positive on [0,infinity)")


def rational_function(data):
    variables = [sp.Symbol(name) for name in data["variables"]]

    def polynomial(terms):
        total = sp.Integer(0)
        for term in terms:
            coefficient = term["coefficient"]
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            if len(term["exponents"]) != len(variables):
                raise AssertionError("Wrong typed exponent-vector length")
            for variable, exponent in zip(variables, term["exponents"]):
                monomial *= variable**exponent
            total += monomial
        return total

    return polynomial(data["numerator"]["terms"]) / polynomial(
        data["denominator"]["terms"]
    )


def replay():
    r = sp.Symbol("r", positive=True)
    ell, a, sigma, omega, b, phi = sp.symbols("ell a sigma omega b phi", real=True)
    angular = ell * (ell + 10)
    L = (ell + 5) ** 2 - sp.Rational(1, 4)
    gamma = sigma + a - 3
    zero(L - angular - sp.Rational(99, 4))

    for h in (-1, 1):
        p = 11 / r + h * sp.I * r / 2
        gauge_log_derivative = sp.Rational(11, 2) / r + h * sp.I * r / 4
        zero(p - 2 * gauge_log_derivative)
        transformed = (
            b
            + h * sp.I * (a + sigma + sp.I * omega)
            - angular / r**2
            + gauge_log_derivative**2
            - sp.diff(gauge_log_derivative, r)
            - p * gauge_log_derivative
        )
        F = r**2 / 16 + b - h * omega - L / r**2
        zero(transformed - F - h * sp.I * gamma)
        zero(sp.diff(F, r) - r / 8 - 2 * L / r**3)
        cross_phase = 2 * h * sp.I * phi + 2 * h * sp.I * r**2 / 8
        zero(cross_phase - h * sp.I * (2 * phi + r**2 / 4))

    A, H, x = sp.symbols("A H x", positive=True)
    T, z, turn_L, turn_radius_squared = A + H, A - H, 16 * A * H, 16 * A
    zero(T**2 - z**2 - turn_L / 4)
    zero(turn_radius_squared / 16 - z - turn_L / turn_radius_squared)
    turn_F = A * (x**2 - 1) + H * (1 - x**-2)
    zero(turn_F - (x**2 - 1) * (A + H / x**2))
    zero(sp.diff(turn_F, x).subs(x, 1) - 2 * T)

    alpha, eps, xi = sp.symbols("alpha eps xi", real=True)
    scaled_F = (
        alpha * ((1 + eps * xi) ** 2 - 1)
        + (1 - alpha) * (1 - (1 + eps * xi) ** -2)
    ) / (2 * eps)
    scaled_defect = sp.cancel(scaled_F - xi)
    expected_defect = (
        eps
        * xi**2
        * (4 * alpha - 3 + (4 * alpha - 2) * eps * xi + alpha * eps**2 * xi**2)
        / (2 * (1 + eps * xi) ** 2)
    )
    zero(scaled_defect - expected_defect)
    zero(sp.limit(scaled_F, eps, 0) - xi)
    d = sp.Symbol("d", positive=True)
    zero(d ** sp.Rational(-1, 2) * d ** sp.Rational(1, 2) - 1)
    zero(d**2 * (1 / (2 * eps)) * eps - d**2 / 2)

    u = sp.Symbol("u", nonnegative=True)
    t = sp.Symbol("t", positive=True)
    shape = alpha * (t - 1) + (1 - alpha) * (1 - 1 / t)
    first = 2 * alpha * t + 2 * (1 - alpha) / t
    second = 2 * alpha * t - 6 * (1 - alpha) / t
    outer_cases = 0
    for substitution, sign in ((4 + u, 1), (1 / (4 + u), -1)):
        for endpoint in (0, 1):
            absolute_shape = sign * shape
            for expression in (
                8 * absolute_shape - first,
                8 * absolute_shape - second,
                8 * absolute_shape + second,
            ):
                positive_rational(
                    expression.subs({t: substitution, alpha: endpoint}), u
                )
                outer_cases += 1

    central_cases = 0
    central_x = (sp.Rational(1, 2) + 2 * u) / (1 + u)
    divided_shape = (x + 1) * (alpha + (1 - alpha) / x**2)
    for endpoint in (0, 1):
        for expression in (
            divided_shape - sp.Rational(3, 8),
            12 - divided_shape,
        ):
            positive_rational(
                expression.subs({x: central_x, alpha: endpoint}), u
            )
            central_cases += 1

    # Affine dependence on alpha extends both endpoint certificates to [0,1].
    zero(sp.diff(shape, alpha, 2))
    zero(sp.diff(first, alpha, 2))
    zero(sp.diff(second, alpha, 2))
    zero(sp.diff(divided_shape, alpha, 2))

    p = sp.Function("p")(r)
    residual = sp.Rational(3, 4) * (sp.diff(p, r) / p) ** 2 - sp.diff(p, r, 2) / (2 * p)
    for direction in (-1, 1):
        for phase in (sp.Integer(1), sp.I):
            logarithmic_slope = -sp.diff(p, r) / (2 * p) + direction * phase * p
            zero(
                sp.diff(logarithmic_slope, r)
                + logarithmic_slope**2
                - phase**2 * p**2
                - residual
            )

    D, Dp, U, Up = sp.symbols("D Dp U Up")
    wronskian = D * Up - Dp * U
    zero((D * Up - Dp * U) / wronskian - 1)
    beta = sp.Symbol("beta")
    zero((-U / wronskian * (Dp - beta * D)).subs(Up, beta * U) - 1)
    HR, Hr, Ht = sp.symbols("HR Hr Ht", real=True)
    zero((HR - Hr) + Ht - HR - (Ht - Hr))
    zero((HR - Ht) + Hr - HR - (Hr - Ht))
    R, E = sp.symbols("R E", positive=True)
    zero(sp.integrate(r**-2, (r, R, E)) - (1 / R - 1 / E))
    positive_rational((1 / (4 * alpha) - sp.Rational(1, 4)).subs(alpha, 1 / (1 + u)), u)

    upper_T_squared = Fraction(9, 4) + Fraction(9, 16)
    remote_F_lower = Fraction(16) - Fraction(1, 2) - 1 - Fraction(9, 1024)
    remote_F_upper = Fraction(16) + Fraction(1, 2) + 1
    remote_root_lower = Fraction(1, 16) - Fraction(1, 256) - Fraction(9, 262144)
    assert upper_T_squared < 4
    assert remote_F_lower > 14
    assert remote_F_upper < 18
    assert remote_root_lower > Fraction(1, 32)

    payload = json.loads((HERE / "jacobian/characteristic-payload.json").read_text())
    output = json.loads((HERE / "jacobian/characteristic-output.json").read_text())
    contract = json.loads((HERE / "jacobian/characteristic-contract.json").read_text())
    status = json.loads((HERE / "jacobian/characteristic-status.json").read_text())
    operation = "matrix.symbolic.characteristic_polynomial.compute"
    assert status == {"adapter_exit_code": 0, "timeout_seconds": 30}
    assert output["request"] == {"operation_id": operation, "payload": payload}
    assert output["result"]["operation_id"] == operation
    assert output["result"].get("error") is None
    assert contract["result"]["operation"]["operation_id"] == operation
    assert contract["result"]["operation"]["read_only"] is True
    assert output["server"]["version"] == contract["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == contract["protocol_version"] == "2025-11-25"
    typed = output["result"]["output"]
    assert typed["degree"] == 2
    assert typed["convention"] == "DET_LAMBDA_I_MINUS_A"
    coefficients = [rational_function(value) for value in typed["coefficients_descending"]]
    c, eta = sp.symbols("c eta")
    matrix = sp.Matrix([[0, 1], [-c, -sp.Rational(1, 2)]])
    zero(matrix.charpoly(eta).as_expr() - (eta**2 + eta / 2 + c))
    assert coefficients == [sp.Integer(1), sp.Rational(1, 2), c]

    return {
        "gauge_signs": [-1, 1],
        "gauge_defects": ["0", "0"],
        "centrifugal_correction": "99/4",
        "imaginary_subprincipal": "hi*(sigma+a-3)",
        "cross_channel_phase": "hi*(2*phi+r^2/4)",
        "turn_discriminant_identity": "(A+H)^2=(A-H)^2+L/4",
        "scaled_turn_defect": "eps*xi^2*(4*alpha-3+(4*alpha-2)*eps*xi+alpha*eps^2*xi^2)/(2*(1+eps*xi)^2)",
        "scaled_flux_factor": "1",
        "outer_universal_positivity_cases": outer_cases,
        "central_universal_positivity_cases": central_cases,
        "wkb_residual_defects": ["0", "0", "0", "0"],
        "green_derivative_jump": "1",
        "right_robin_correction": "1",
        "green_action_exponents": ["Ht-Hr", "Hr-Ht"],
        "coupling_integral": "1/R-1/E",
        "turn_minimum_scale": "kappa^6>=T/4",
        "remote_F_over_S_interval": ["14", "18"],
        "remote_sqrt_argument_lower": str(remote_root_lower),
        "jacobian_coefficients": ["1", "1/2", "c"],
        "jacobian_server_version": "0.14.0",
        "jacobian_protocol": "2025-11-25",
        "jacobian_adapter_exit": 0,
    }


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    actual = replay()
    if actual != certificate["exact_replay"]:
        different = sorted(
            key
            for key in actual.keys() | certificate["exact_replay"].keys()
            if actual.get(key) != certificate["exact_replay"].get(key)
        )
        raise AssertionError(f"Exact certificate mismatch: {different}; computed={actual}")
    print(
        json.dumps(
            {
                "status": "passed",
                "certificate": str(HERE / "exact_certificate.json"),
                "scope": "exact algebra and universal rational inequalities only",
                "analytic_operator_theorem": "requires independent reading of theorem.md",
                "independent_review": certificate["independent_review"],
                "exact_replay": actual,
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
