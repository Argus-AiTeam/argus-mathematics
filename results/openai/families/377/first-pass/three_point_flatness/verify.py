#!/usr/bin/env python3
"""Replay the dimension-free algebra; see report.md for the analytical proof."""

import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["claim"] == "C_TP_377", "wrong claim")
    require(
        certificate["proof_kind"]
        == "analytical_verification_with_dimension_free_exact_algebra",
        "wrong evidence classification",
    )
    require(certificate["kernel_formalized"] is False, "not a kernel proof")
    identities = []

    def zero(name, expression):
        require(sp.simplify(expression) == 0, name)
        identities.append(name)

    r, s = sp.symbols("r s", positive=True)
    tau = sp.symbols("tau", real=True)
    B, a, qj, dbj, hj, h2, ej = sp.symbols(
        "B a qj dbj hj h2 ej", real=True
    )

    def f(radius):
        return radius - radius ** sp.Rational(3, 2) / 8

    fp = sp.diff(f(r), r)
    zero("f_prime", fp.subs(r, s**2) - (1 - 3 * s / 16))
    zero(
        "f_second",
        sp.diff(f(r), r, 2).subs(r, s**2) + sp.Rational(3, 32) / s,
    )
    zero("f_ratio", f(s**2) / s**2 - (1 - s / 8))

    radius_x = sp.sqrt(r**2 + 2 * r * ej * tau + tau**2)
    radius_y = sp.sqrt(r**2 - 2 * r * ej * tau + tau**2)
    first_jets = []
    for label, radius, sign in [
        ("p1_component", radius_x, 1),
        ("p2_component", radius_y, -1),
    ]:
        test = (
            qj * tau
            + (B + dbj * tau / 2) * f(radius)
            + (h2 - hj * tau + tau**2 / 4) / radius**2
        )
        derivative = sp.diff(test, tau).subs(tau, 0)
        expected = (
            qj
            + f(r) * dbj / 2
            - hj / r**2
            + sign * (B * fp - 2 * h2 / r**3) * ej
        )
        zero(label, derivative - expected)
        first_jets.append(expected)
    z_test = -2 * qj * tau + B * f(r) + (h2 + 2 * hj * tau + tau**2) / r**2
    p0j = -sp.diff(z_test, tau).subs(tau, 0) / 2
    zero("p0_component", p0j - qj + hj / r**2)
    zero(
        "radial_relative_velocity",
        first_jets[0] - first_jets[1] - 2 * (B * fp - 2 * h2 / r**3) * ej,
    )
    zero(
        "midpoint_relative_velocity",
        p0j - (first_jets[0] + first_jets[1]) / 2 + f(r) * dbj / 2,
    )
    e2 = sp.symbols("e2", real=True)
    zero(
        "radial_second_derivative",
        ((2 * a) ** 2 * e2 - (2 * a * e2) ** 2).subs(e2, 1),
    )

    hd, d2, rd = sp.symbols("hd d2 rd", real=True)
    penalty_line = (h2 + 2 * tau * hd + tau**2 * d2) / (r + rd * tau) ** 2
    zero(
        "penalty_second_derivative",
        sp.diff(penalty_line, tau, 2).subs(tau, 0)
        - (2 * d2 / r**2 - 8 * rd * hd / r**3 + 6 * rd**2 * h2 / r**4),
    )

    HH, Hb, bb, bv, Wv = sp.symbols("HH Hb bb bv Wv", real=True)
    t = 1 - s / 8
    k = 1 - 3 * s / 16
    zero(
        "rescaled_a_definition",
        (B * fp - 2 * h2 / r**3).subs(h2, r**4 * HH).subs(r, s**2)
        - (B * k - 2 * s**2 * HH),
    )
    B_line = B + tau * bv + tau**2 * Wv / 2
    h_square_line = (
        r**4 * HH - tau * r**2 * f(r) * Hb + tau**2 * f(r) ** 2 * bb / 4
    )
    test_line = B_line * f(r + 2 * a * tau) + h_square_line / (r + 2 * a * tau) ** 2
    actual = sp.diff(test_line, tau, 2).subs(tau, 0).subs(r, s**2)
    coefficients = {
        key: sp.Rational(value)
        for key, value in certificate["identity_coefficients"].items()
    }
    contraction = (
        coefficients["negative_curvature"] * B * a**2 / s
        + coefficients["B_cross"] * a * k * bv
        + coefficients["B_hessian"] * s**2 * t * Wv
        + coefficients["penalty_gradient_square"] * t**2 * bb
        + coefficients["penalty_mixed"] * a * t * Hb
        + coefficients["penalty_H_square"] * a**2 * HH
    )
    zero("full_dimension_free_contraction", actual - contraction)

    M0, M1, M2, C, V, b = sp.symbols("M0 M1 M2 C V b", positive=True)
    tt, kk, ff = sp.symbols("tt kk ff", nonnegative=True)
    zero(
        "negative_term_domination",
        B * a**2
        - b**3 / 4
        - ((B - b) * a**2 + b * (a - b / 2) * (a + b / 2)),
    )
    zero(
        "B_cross_upper_bound",
        M0 * M1 * V
        - a * kk * bv
        - (
            (M0 - a) * M1 * V
            + a * (1 - kk) * M1 * V
            + a * kk * (M1 * V - bv)
        ),
    )
    zero(
        "B_hessian_upper_bound",
        M2 * V**2 - ff * Wv - ((1 - ff) * M2 * V**2 + ff * (M2 * V**2 - Wv)),
    )
    zero(
        "penalty_gradient_square_upper_bound",
        M1**2
        - tt**2 * bb
        - ((1 - tt) * (1 + tt) * M1**2 + tt**2 * (M1**2 - bb)),
    )
    zero(
        "penalty_mixed_upper_bound",
        2 * M0 * C * M1
        - a * tt * Hb
        - (
            (M0 - a) * 2 * C * M1
            + a * (1 - tt) * 2 * C * M1
            + a * tt * (2 * C * M1 - Hb)
        ),
    )
    zero(
        "penalty_H_square_upper_bound",
        4 * M0**2 * C**2
        - a**2 * HH
        - ((M0 - a) * (M0 + a) * 4 * C**2 + a**2 * (4 * C**2 - HH)),
    )

    u = sp.symbols("u", real=True)
    P = 10 * u**3 - 15 * u**4 + 6 * u**5
    zero("cutoff_derivative", sp.diff(P, u) - 30 * u**2 * (1 - u) ** 2)
    zero("cutoff_second_derivative", sp.diff(P, u, 2) - 60 * u * (1 - u) * (1 - 2 * u))
    zero("cutoff_interval_square", sp.Rational(1, 4) - u * (1 - u) - (u - sp.Rational(1, 2)) ** 2)
    zero(
        "cutoff_derivative_upper_bound",
        sp.Rational(15, 8)
        - sp.diff(P, u)
        - 30 * (u - sp.Rational(1, 2)) ** 2 * (sp.Rational(1, 4) + u * (1 - u)),
    )
    zero("cutoff_second_bound_factor", 1 - (1 - 2 * u) ** 2 - 4 * u * (1 - u))
    for endpoint in [0, 1]:
        zero(f"cutoff_value_at_{endpoint}", P.subs(u, endpoint) - endpoint)
        zero(f"cutoff_first_at_{endpoint}", sp.diff(P, u).subs(u, endpoint))
        zero(f"cutoff_second_at_{endpoint}", sp.diff(P, u, 2).subs(u, endpoint))

    z, m, lam = sp.symbols("z m lam", real=True)
    zero(
        "eta_chosen_after_maximum",
        z - z * m / (2 * (1 + m)) - z * (2 + m) / (2 * (1 + m)),
    )
    zero("negative_amplitude_homogeneity", (-2) ** 3 * z + 8 * z)
    L, epsilon = sp.symbols("L epsilon", positive=True)
    zero("scale_normalization", L**7 * (epsilon / L) - L**6 * epsilon)

    constants = certificate["constants"]
    require(
        constants
        == {
            "C": 4,
            "Q": 3,
            "B_out": 40,
            "M0": 40,
            "M1": 400,
            "M2": 18000,
            "V": 211,
            "R": 818443600,
            "N": 818443601,
            "nu": "3/4",
        },
        "constant specification changed",
    )
    C, Q, M0, M1, M2, V, R, N = (
        Fraction(constants[key]) for key in ["C", "Q", "M0", "M1", "M2", "V", "R", "N"]
    )
    nu = Fraction(constants["nu"])
    require(nu * M0 - C - Fraction(3, 2) * C**2 == 2, "outer localization")
    require(M1 >= M0 * Fraction(15, 8) * Fraction(16, 3), "cutoff gradient")
    require(
        M2 >= M0 * (15 * Fraction(16, 3) ** 2 + Fraction(15, 8) * Fraction(32, 3)),
        "cutoff Hessian",
    )
    require(V == Q + 2 * C + M1 / 2, "center velocity")
    remainder = (
        M1**2 / 2 + 16 * M0 * C * M1 + 96 * M0**2 * C**2
        + 4 * M0 * M1 * V + M2 * V**2
    )
    require(R == remainder and N == R + 1, "uniform remainder")
    thresholds = certificate["thresholds"]
    require(
        thresholds
        == {
            "sqrt_kappa": "3/(512*N)",
            "kappa": "(3/(512*N))^2",
            "epsilon_gate": "3*kappa/32",
            "separation_power": 6,
            "flatness_power": 7,
            "quantitative_constant": 4096,
        },
        "threshold specification changed",
    )
    sqrt_kappa = Fraction(3, 512 * N)
    kappa = sqrt_kappa**2
    epsilon_gate = 3 * kappa / 32
    require(0 < kappa <= Fraction(1, 2048), "positive small-scale threshold")
    require(Fraction(1, 2) + Fraction(1, 4096) < Fraction(3, 4), "endpoint interior margin")
    require(Fraction(1, 2) + 8 * Fraction(1, 2048) ** 2 < Fraction(3, 4), "third-point interior margin")
    require(Fraction(5, 16) - 128 * Fraction(1, 2048) == Fraction(1, 4), "lower bound a >= delta/4")
    require(3 / (256 * sqrt_kappa) == 2 * N, "negative curvature dominates")
    require(32 * epsilon_gate / 3 == kappa, "affine error forces small r")
    require(0 < epsilon_gate < 1, "nonempty quantitative range")
    require(1 / epsilon_gate <= 4096**7, "explicit one-seventh-power constant")

    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    adapter = certificate["jacobian"]
    require(adapter["exit_code"] == 0 and adapter["error"] is None and adapter["timeout"] is False, "adapter status")
    require(response["protocol_version"] == adapter["protocol_version"], "adapter protocol")
    require(response["server"]["version"] == adapter["server_version"], "adapter server")
    require(response["transport"] == "mcp-stdio" and response["schema_version"] == 1, "adapter envelope")
    require(response["request"]["operation_id"] == adapter["operation_id"], "adapter operation")
    require(response["request"]["payload"] == payload, "adapter request binding")
    require(response["result"]["operation_id"] == adapter["operation_id"], "adapter result operation")
    output = response["result"]["output"]
    for field in ["form", "vector"]:
        require(output[field]["domain"] == "QQ", "adapter rational domain")
        require({key: value for key, value in output[field].items() if key != "domain"} == payload[field], "adapter output binding")

    def rational(value):
        result = Fraction(int(value["num"]), int(value["den"]))
        require(str(result.numerator) == value["num"] and str(result.denominator) == value["den"], "canonical rational")
        return result

    x, y, zz = sp.symbols("x y zz", real=True)
    scalar_test = f(x - y) + (zz - (x + y) / 2) ** 2 / (x - y) ** 2
    matrix = sp.hessian(scalar_test, (x, y, zz)).subs({x: sp.Rational(1, 32), y: -sp.Rational(1, 32), zz: 0})
    for j in range(3):
        require(matrix[j, j] == rational(payload["form"]["diagonal_coefficients"][j]), "diagnostic Hessian diagonal")
    require([(term["left"], term["right"]) for term in payload["form"]["cross_terms"]] == [(0, 1), (0, 2), (1, 2)], "diagnostic cross support")
    for term in payload["form"]["cross_terms"]:
        require(2 * matrix[term["left"], term["right"]] == rational(term["coefficient"]), "diagnostic Hessian cross term")
    velocity = sp.Matrix([fp.subs(r, sp.Rational(1, 16)), -fp.subs(r, sp.Rational(1, 16)), 0])
    require(list(velocity) == [rational(value) for value in payload["vector"]["coordinates"]], "diagnostic velocity")
    value = Fraction((velocity.T * matrix * velocity)[0])
    require(value == rational(output["value"]) == Fraction(-11163, 8192), "Jacobian exact replay")
    require(adapter["typed_value"] == "-11163/8192", "certificate adapter value")

    print(json.dumps({
        "status": "verified_exact",
        "dimension_free_identities": len(identities),
        "uniform_remainder": int(R),
        "quantitative_bound": "min(L,4096*L^(6/7)*epsilon^(1/7))",
        "jacobian_diagnostic": str(value),
        "scope": "general algebra and rational inequalities; analytical theorem-of-sums proof is in report.md",
        "independent_review": "not supplied by this program",
        "kernel_formalized": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
