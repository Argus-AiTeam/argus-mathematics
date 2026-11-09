#!/usr/bin/env python3
"""Replay exact algebra used in theorem.md; no angular-frequency truncation."""

import argparse
import json
from pathlib import Path

import sympy as s


ROOT = Path(__file__).resolve().parent


def zero(expression):
    assert s.cancel(s.expand(expression)) == 0, expression


def positive_coefficients(expression, substitutions):
    numerator, denominator = s.fraction(s.factor(expression))
    generators = sorted(
        {symbol for value in substitutions.values() for symbol in value.free_symbols},
        key=str,
    )
    for polynomial in (numerator, denominator):
        shifted = s.Poly(s.expand(polynomial.subs(substitutions)), *generators)
        assert all(coefficient >= 0 for coefficient in shifted.coeffs()), shifted
        assert any(coefficient > 0 for coefficient in shifted.coeffs()), shifted


def norm_identity():
    T, Td, U, Ud, Z, Zd = s.symbols("T Td U Ud Z Zd", commutative=False)
    F, Fd = Td + Z, T + Zd
    commutator = lambda a, b: a * b - b * a
    error = (
        2 * commutator(Td, U)
        + 2 * commutator(Ud, T)
        + commutator(Ud, U)
        - 2 * (U * Z + Zd * Ud)
    )
    zero(
        (2 * Td + Ud) * (2 * T + U)
        - (2 * Fd + U) * (2 * F + Ud)
        - 4 * (Td * T - Fd * F)
        - error
    )


def raising_algebra():
    k, n, beta, c1 = s.symbols("k n beta c1", positive=True)
    X, Y, H, Htrace, V, R = s.symbols("X Y H Htrace V R", real=True)
    theta, zeta = s.symbols("theta zeta", real=True)
    d = k + n / 2 - 1
    q = 2 + 2 / d
    divergence = s.Symbol("divergence", real=True)
    original = (2 * d + 2) * (X + Y - H + R - divergence / d) - 2 * d * Y
    after_first = q * (d * X - divergence - d * H) + 2 * Y
    zero(original - after_first - (2 * d + 2) * R)

    replacement = (
        (1 - theta) * (k * (X + Htrace) - H)
        + theta * ((1 - zeta) * (k + n - 1) * X + zeta * (2 * Y + 8 * k**3 * beta**2 * V))
    )
    combined = s.expand(q * (d * X - replacement - d * H) + 2 * Y)
    expected = (
        q * (d - k - theta * (n - 1) + theta * zeta * (k + n - 1)) * X
        + (2 - 2 * q * theta * zeta) * Y
        - q * ((d - 1 + theta) * H + (1 - theta) * k * Htrace)
        - 8 * q * theta * zeta * k**3 * beta**2 * V
    )
    zero(combined - expected)

    choice = (n - 2) / (8 * (n - 1))
    zero(d - k - choice * (n - 1) - 3 * (n - 2) / 8)
    zero(d - 1 + choice + (1 - choice) * n - k - (11 * n - 14) / 8)
    h, g = s.symbols("h g", nonnegative=True)
    shift = {k: h + 1, n: g + 3}
    positive_coefficients(s.Rational(10, 3) - q, shift)
    positive_coefficients(s.Rational(1, 8) - choice, shift)
    positive_coefficients(choice, shift)
    positive_coefficients(1 - choice, shift)
    positive_coefficients((11 * n - 14) / 8, shift)
    positive_coefficients(q - 2, shift)
    positive_coefficients(4 * k**2 - (k + 1) ** 2, {k: h + 1})
    positive_coefficients(2 * k - (k + 1), {k: h + 1})
    positive_coefficients(8 * k**3 - (k + 1) ** 3, {k: h + 1})
    zero(2 - 2 * s.Rational(10, 3) * s.Rational(1, 8) - s.Rational(7, 6))
    x, y = s.symbols("x y", real=True)
    zero(2 * x**2 + 2 * y**2 - (x - y) ** 2 - (x + y) ** 2)
    return {
        "degree_range": "all integers k>=1, n>=3 (symbolic k,n)",
        "theta": "(n-2)/(8*(n-1))",
        "c1_range": "0<c1<=min(1,c0)",
        "zeta": "c1/beta, beta>=1",
        "unweighted_Dplus_coefficient_lower": "3*(n-2)/4",
        "weighted_Dplus_coefficient_lower": "2*theta*c1*k/beta",
        "Dminus_divergence_coefficient_lower": "7/6",
        "remaining_Hessian_before_curvature_lower": "2*c0*k^3*beta",
        "curvature_absorption": "beta0>=K/c0 leaves c0*k^3*beta",
        "N_comparison": "N_k^2<=4*A+4*B+12*H",
        "raising_constant": "min(3*(n-2)/16,theta*c1/2,c0/12)",
    }


def filtered_commutator(name, left_base_orders, right_base_orders, weight):
    rows = set()
    skipped = set()
    for a in left_base_orders:
        for b in right_base_orders:
            if a == 2 or b == 2:
                skipped.add((a, b))
            else:
                base_order = a + b
                angular_order = 4 - a - b - 1
                assert base_order <= 2
                assert angular_order <= 3 - base_order
                assert weight - base_order <= 1 - base_order
                rows.add((base_order, angular_order, weight - base_order))
            for derivatives in range(1, max(a, b) + 1):
                base_order = a + b - derivatives
                angular_order = 4 - a - b
                assert base_order <= 2
                assert angular_order <= 3 - base_order
                assert weight - base_order <= 1 - base_order
                rows.add((base_order, angular_order, weight - base_order))
    return {
        "family": name,
        "rows_base_angular_beta_power": [list(row) for row in sorted(rows)],
        "zero_hit_scalar_commutations": [list(row) for row in sorted(skipped)],
    }


def order_certificate():
    families = [
        filtered_commutator("[Tdagger,U] and [Udagger,T]", (0, 1), (0, 1, 2), 1),
        filtered_commutator("[Udagger-U,U], real principal coefficient", (0, 1), (0, 1, 2), 0),
    ]
    return {
        "scope": "all base multiindices: enumeration uses their orders, not dimension or modes",
        "families": families,
        "UZ_and_adjoint": [
            {"base_order": j, "angular_order_at_most": 3 - j, "beta_power": 1 - j}
            for j in (0, 1, 2)
        ],
        "permitted_types": [
            "delta*beta^-1*Psi^1*partial_y^2",
            "delta*Psi^2*partial_y",
            "delta*beta*Psi^3",
        ],
        "quadratic_improvement": "C*delta^2/beta0*N^2",
    }


def principal_normality():
    c, cb, b, bd = s.symbols("c cb b bd", commutative=False)
    real_c, conjugate_c = s.symbols("real_c conjugate_c", commutative=True)
    cubic_cross = cb * b + bd * c - c * bd - b * cb
    zero(cubic_cross.subs({c: real_c, cb: conjugate_c}))
    px, py, pbx, pby = s.symbols("px py pbx pby", commutative=True)
    bracket = pbx * py - px * pby
    zero(bracket.subs({pbx: px, pby: py}))
    a, y, xi, S = s.symbols("a y xi S", real=True)
    obstruction = 2 * a * (1 - s.I * y) * xi * s.I * a * S - 2 * a * (1 + s.I * y) * xi * (-s.I) * a * S
    zero(obstruction - 4 * s.I * a**2 * xi * S)
    return {
        "criterion": "{conjugate(c(y,xi)),c(y,xi)}=0 identically",
        "bracket_convention": "sum_j (d_xi_j conjugate(c)*d_y_j c-d_xi_j c*d_y_j conjugate(c))",
        "real_principal_case": "identically zero",
        "complex_example": "c(y,xi)=a*(1+i*y1)*|xi|^2",
        "complex_cubic_symbol": "4*i*a^2*xi1*|xi|^2",
        "oscillatory_real_form_leading_coefficient": "4*a^2*lambda^3*integral(chi^2)",
        "scope_warning": "complex example is NOT an admissible counterexample to either manuscript",
    }


def normal_ordered_base_identity():
    x = s.Symbol("x", real=True)
    c, cb, mu = (s.Function(name)(x) for name in ("c", "cb", "mu"))
    b, bs, v, vs = (
        s.Function(name, commutative=False)(x) for name in ("b", "bs", "v", "vs")
    )
    U = {2: c, 1: b, 0: v}
    Ud = {
        2: cb,
        1: 2 * s.diff(mu * cb, x) / mu - bs,
        0: s.diff(mu * cb, x, 2) / mu - s.diff(mu * bs, x) / mu + vs,
    }

    def product(left, right, minimum_order):
        result = {}
        for i, a in left.items():
            for j, coefficient in right.items():
                for hits in range(i + 1):
                    order = i + j - hits
                    if order >= minimum_order:
                        term = s.binomial(i, hits) * a * s.diff(coefficient, x, hits)
                        result[order] = result.get(order, 0) + term
        return result

    forward, backward = product(Ud, U, 3), product(U, Ud, 3)
    zero(forward[4] - backward[4])
    zero(forward[3] - backward[3] - 2 * (cb * s.diff(c, x) - c * s.diff(cb, x)))
    zero((forward[3] - backward[3]).subs(cb, c).doit())
    zero(Ud[2].subs(cb, c) - U[2])
    return {
        "method": "exact normal ordering by the full Leibniz rule, with noncommutative lower coefficients",
        "density": "arbitrary symbolic mu(x)",
        "fourth_base_coefficient": "0",
        "third_base_coefficient": "2*(conjugate(c)*c'-c*conjugate(c)')",
        "real_principal_difference_Udagger_minus_U_base_order": "<=1",
        "dimension_scope": "one free derivative slot; the indexed proof and polarization are in theorem.md",
    }


def young_identity():
    beta = s.Symbol("beta", positive=True)
    x, y = s.symbols("x y", real=True)
    zero(x**2 / beta + beta * y**2 - 2 * x * y - (x / s.sqrt(beta) - s.sqrt(beta) * y) ** 2)


def jacobian_evidence():
    output_path = ROOT / "jacobian_output.json"
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads(output_path.read_text())
    assert output["result"]["operation_id"] == "polynomial.differential_operator.apply.compute"
    assert output["request"]["payload"] == payload
    result = output["result"]["output"]
    assert result["matches_expected"] is True
    assert result["is_zero"] is False
    assert result["polynomial"] == payload["polynomial"]
    assert result["operator"] == payload["operator"]
    return {
        "operation_id": output["result"]["operation_id"],
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "transport": output["transport"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "adapter_status": "completed",
        "structured_error": None,
        "scope": "one exact harmonic-projection normalization check, not an analytic proof",
    }


def certificate():
    norm_identity()
    young_identity()
    return {
        "result_class": "uniform_verification_theorem_with_sharp_structural_extension",
        "mathematical_status": "proved in theorem.md; exact algebra replayed here; independent review pending",
        "formal_kernel_status": "not Lean-verified",
        "manuscript_refutation": False,
        "finite_mode_truncation": False,
        "analytic_scope": "uniform angular error form and conditional scalar coercivity",
        "analytic_dependencies": [
            "scalar classical angular pseudodifferential calculus with uniform finite seminorm bounds",
            "the stated moving-trace expansion, for application to the geometric P0/P",
            "bounded reference geometry and stated profile/coefficient hypotheses",
        ],
        "norm_comparison_identity": "verified in the free noncommutative star algebra",
        "weighted_Young_identity": "verified symbolically",
        "raising": raising_algebra(),
        "filtered_error": order_certificate(),
        "normal_ordered_base_identity": normal_ordered_base_identity(),
        "sharp_extension": principal_normality(),
        "jacobian": jacobian_evidence(),
        "novelty_status": "unverified; bounded lookup found related but not identical results",
        "significance_status": "pending independent Reviewer assessment",
        "main_inverse_theorems": "not certified by this bounded angular-core result",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="generate the exact certificate")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert json.loads(path.read_text()) == result, "certificate differs from replay"
    print(json.dumps({"result": "verified", "certificate": str(path), "finite_mode_truncation": False}))


if __name__ == "__main__":
    main()
