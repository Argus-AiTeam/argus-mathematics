#!/usr/bin/env python3
"""Replay exact algebra used by the analytic cap proof, not a PDE solver."""

import argparse
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def exact_checks():
    checks = []

    def zero(name, expression):
        residual = sp.simplify(sp.expand(expression))
        if residual != 0:
            raise AssertionError(f"{name}: nonzero exact residual {residual}")
        checks.append({"identity": name, "residual": "0"})

    t, s = sp.symbols("t s", real=True)
    u = sp.Function("u")(t, s)
    A, B, C, m, n = [
        sp.Function(name)(t, s) for name in ("A", "B", "C", "m", "n")
    ]
    ut, us = sp.diff(u, t), sp.diff(u, s)
    T = (sp.diff(m, s) - sp.diff(n, t)) / 2 + B * n
    S = -sp.diff(A * m, s) / 2 + sp.diff(A * n, t) / 2 + C * m
    J = -sp.diff(m, t) + B * m - sp.diff(A * n, s) + C * n
    flux_t = m * ut * us + n * ut**2 / 2 - A * n * us**2 / 2
    flux_s = -m * ut**2 / 2 + A * m * us**2 / 2 + A * n * ut * us
    operator = sp.diff(u, t, 2) + A * sp.diff(u, s, 2) + B * ut + C * us
    zero(
        "directed_divergence_identity_including_fluxes",
        operator * (m * us + n * ut)
        - T * ut**2
        - S * us**2
        - J * ut * us
        - sp.diff(flux_t, t)
        - sp.diff(flux_s, s),
    )

    eps, H, Is, mu, r = sp.symbols("eps H Is mu r", real=True)
    W = sp.Function("W")(t, s)
    substitutions = {
        sp.diff(W, t): B * W,
        sp.diff(W, s): (-H + Is) * W,
    }

    def normalize(expression):
        return (
            expression.subs({m: -W, n: eps * t * W})
            .doit()
            .subs(substitutions)
            / W
        )

    Tn = (H - Is - eps + eps * t * B) / 2
    Sn = (
        -(mu - sp.Rational(1, 2)) * sp.diff(A, s)
        + eps * t * sp.diff(A, t) / 2
        - H * A / 2
        + A * ((Is + eps + eps * t * B) / 2 - r)
    )
    Jn = eps * t * ((mu - 1) * sp.diff(A, s) + A * (H - Is + r))
    drift = mu * sp.diff(A, s) + A * r
    zero("normalized_directed_T", normalize(T) - Tn)
    zero("normalized_directed_S", normalize(S).subs(C, drift) - Sn)
    zero("normalized_directed_J", normalize(J).subs(C, drift) - Jn)

    qT, qS, qJ, x, y = sp.symbols("T S J x y", real=True)
    Q = qT * x**2 + qS * y**2 + qJ * x * y
    zero(
        "coercive_square_completion_T_nonzero",
        2 * qT * Q
        - qT**2 * x**2
        - (2 * qT * qS - qJ**2) * y**2
        - (qT * x + qJ * y) ** 2,
    )
    vv, ee, uu, xx = sp.symbols("v e u x", real=True)
    zero(
        "weighted_young_square_identity_v_positive",
        4 * vv * (vv * xx**2 / 4 + ee**2 * uu**2 / vv - uu * ee * xx)
        - (vv * xx - 2 * ee * uu) ** 2,
    )

    px, py, zxy, zyy, K, detg, gxx, gxy, gyy = sp.symbols(
        "px py zxy zyy K detg gxx gxy gyy", real=True
    )
    cxxx, cxxy, cxyx, cxyy, cyyx, cyyy = sp.symbols(
        "cxxx cxxy cxyx cxyy cyyx cyyy", real=True
    )
    Hxy = zxy - cxyx * px - cxyy * py
    Hyy = zyy - cyyx * px - cyyy * py
    E = detg * (1 - gxx * px**2 - 2 * gxy * px * py - gyy * py**2)
    q = Hxy / Hyy
    a = K * E / Hyy**2
    P = cxxx * px + cxxy * py + (Hxy**2 + K * E) / Hyy
    zero("Darboux_P_zxy", sp.diff(P, zxy) - 2 * q)
    zero("Darboux_P_zyy", sp.diff(P, zyy) + q**2 + a)
    for jet, gxxi, gxyi, gyyi, name in (
        (px, cxxx, cxyx, cyyx, "x"),
        (py, cxxy, cxyy, cyyy, "y"),
    ):
        expected = (
            gxxi
            - 2 * q * gxyi
            + q**2 * gyyi
            + K * (sp.diff(E, jet) / Hyy + E * gyyi / Hyy**2)
        )
        zero("Darboux_P_z" + name, sp.diff(P, jet) - expected)

    x0, y0 = sp.symbols("x0 y0", real=True)
    U = sp.Function("U")(x0, y0)
    q0, a0 = [sp.Function(name)(x0, y0) for name in ("q0", "a0")]
    Px, Py, ell = sp.symbols("Px Py ell", real=True)

    def D(expression):
        return sp.diff(expression, x0) - q0 * sp.diff(expression, y0)

    B0 = -Px - 2 * ell * sp.diff(q0, y0)
    delta = D(q0) - Px * q0 - Py + ell * sp.diff(a0, y0)
    original = (
        sp.diff(U, x0, 2)
        - 2 * q0 * sp.diff(U, x0, y0)
        + (q0**2 + a0) * sp.diff(U, y0, 2)
        + B0 * sp.diff(U, x0)
        + (-Py + ell * sp.diff(q0**2 + a0, y0)) * sp.diff(U, y0)
    )
    preflow = (
        D(D(U))
        + a0 * sp.diff(U, y0, 2)
        + B0 * D(U)
        + delta * sp.diff(U, y0)
    )
    zero("original_coordinate_to_preflow_operator", original - preflow)

    Ky, G, Gy, v, vy, r0 = sp.symbols("Ky G Gy v vy r0", real=True)
    transverse = K * G * vy + v * (G * Ky + K * r0 + ell * (Ky * G + K * Gy))
    As = G * v * Ky + K * Gy * v + 2 * K * G * vy
    zero(
        "explicit_transverse_drift_remainder",
        transverse
        - (ell + 1) * As
        - K * (v * r0 - v * Gy - (2 * ell + 1) * G * vy),
    )

    alpha, qp, kp = sp.symbols("alpha qp kp", real=True)
    geometric = -(mu - sp.Rational(1, 2)) * alpha * Ky / v
    geometric += eps * t * alpha * (kp - qp * Ky) / 2
    zero(
        "physical_curvature_escape_decomposition",
        geometric
        - alpha
        * (-((mu - sp.Rational(1, 2)) / v + eps * t * qp / 2) * Ky
           + eps * t * kp / 2),
    )
    order = sp.Symbol("m", integer=True, positive=True)
    zero(
        "all_positive_integer_finite_type_tangential_escape",
        t * sp.diff(t ** (2 * order), t) - 2 * order * t ** (2 * order),
    )

    count = sp.Symbol("n", integer=True, nonnegative=True)
    level = 8 + count
    zero("high_factor_count_margin", 2 * (level - 3) - level - (count + 2))
    zero(
        "x_recovery_factor_count_margin",
        2 * (level - 3) - (level - 1) - (count + 3),
    )
    exponent = sp.Symbol("r", real=True, nonnegative=True)
    p = 4 + exponent
    zero("elliptic_weight_cost_exponent_p_minus_4", p - 4 - exponent)
    zero("elliptic_weight_cost_exponent_p_minus_3", p - 3 - (exponent + 1))
    zero("elliptic_weight_cost_exponent_p_minus_2", p - 2 - (exponent + 2))
    zero("source_complement_weight_exponent", 2 * p - (p - 1) - (p + 1))
    return checks


def check_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_result.json").read_text())
    if "error" in response:
        raise AssertionError(f"Jacobian adapter error: {response['error']}")
    if response["request"]["payload"] != payload:
        raise AssertionError("Archived Jacobian request differs from the payload")
    operation = "polynomial.sos.decomposition.check"
    if response["request"]["operation_id"] != operation:
        raise AssertionError("Unexpected Jacobian request operation")
    if response["result"]["operation_id"] != operation:
        raise AssertionError("Unexpected Jacobian result operation")
    output = response["result"]["output"]
    if output["is_valid"] is not True:
        raise AssertionError("Jacobian did not certify the exact identity")
    if output["method"] != "EXACT_COEFFICIENT_IDENTITY":
        raise AssertionError("Unexpected Jacobian verification method")
    if output["polynomial"] != payload["polynomial"]:
        raise AssertionError("Jacobian returned a different polynomial")
    if output["summands"] != payload["summands"]:
        raise AssertionError("Jacobian returned different summands")

    def polynomial(record):
        variables = sp.symbols(" ".join(record["variables"]))
        result = sp.Integer(0)
        for term in record["polynomial"]["terms"]:
            coefficient = term["coefficient"]
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            for variable, power in zip(variables, term["exponents"], strict=True):
                monomial *= variable**power
            result += monomial
        return result

    expected = polynomial(payload["polynomial"])
    computed = sum(polynomial(term)**2 for term in payload["summands"])
    if sp.expand(expected - computed) != 0:
        raise AssertionError("Independent replay rejected the supplied SOS identity")
    if sp.expand(polynomial(output["computed_sum"]) - expected) != 0:
        raise AssertionError("Jacobian computed_sum differs from the exact polynomial")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "exact_identity_replayed": True,
        "pde_verdict": "none",
    }


def certificate():
    return {
        "claim": "C_CAP_VERIFY",
        "extended_claim": "C_CAP_GENERAL",
        "result_class": "new_theorem",
        "result_scope": "Complete analytic cap proof and structural extension, pending independent review",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "unverified",
        "independent_review": "required_pending",
        "manuscript_refuted": False,
        "exact_symbolic_identities": exact_checks(),
        "jacobian": check_jacobian(),
        "universal_derivative_counts": {
            "domain": "l=8+n, n a nonnegative integer",
            "two_high_factors_margin": "n+2 > 0",
            "x_recovery_margin": "n+3 > 0",
            "finite_enumeration_used": False,
        },
        "analytic_proof": {
            "file": "research/cap_audit/report.md",
            "linear_estimate": "section 3, including exact boundary fluxes and uniform constant choices",
            "nonlinear_bootstrap": "sections 4-7, under the literal metric and admissibility hypotheses",
            "extensions": "fixed m>=1, fixed mu>1/2, bounded zeroth-order term, fixed p>=4",
            "verified_by_this_script": False,
            "independent_reader_required": True,
        },
        "formal_subclaim": {
            "claim": "C_CAP_ALGEBRA",
            "source": "research/cap_audit/Main.lean",
            "statement_fidelity": "research/cap_audit/statement_fidelity.md",
            "compiler_evidence": "Read the actual claim-linked lean_evidence certificate, not this symbolic checker",
            "analytic_cap_theorem_formalized": False,
        },
        "whole_manuscript": {
            "status": "open",
            "unverified_dependencies": ["C_PROPAGATION", "C_PULSE_MOMENT", "C_CATEGORY", "C_DISK", "C_ASSEMBLY"],
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        stored = json.loads(path.read_text())
        if stored != result:
            raise AssertionError("Stored certificate differs from the exact replay")
    print(
        f"PASS: {len(result['exact_symbolic_identities'])} universal symbolic identities "
        "and the archived Jacobian identity; full analytic proof requires independent review."
    )


if __name__ == "__main__":
    main()
