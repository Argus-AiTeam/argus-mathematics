#!/usr/bin/env python3
"""Replay the exact algebra supporting HIGHDIM_AUDIT.md, not its PDE proofs."""

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as s


HERE = Path(__file__).resolve().parent


def verify():
    checks = {}

    def zero(name, expression):
        residual = s.cancel(expression)
        if residual != 0:
            raise AssertionError(f"{name}: nonzero residual {residual}")
        checks[name] = "exact zero"

    def positive_polynomial(name, expression, variables):
        polynomial = s.Poly(s.expand(expression), *variables)
        if polynomial.is_zero or any(c < 0 for c in polynomial.coeffs()):
            raise AssertionError(f"{name}: not a nonzero nonnegative-coefficient polynomial")
        checks[name] = str(polynomial.as_expr())

    p, q = s.symbols("p q", positive=True)
    r, z, zr, f, fr, ratio = s.symbols("r z zr f fr ratio", positive=True)
    h, hq, j, ell, mu = s.symbols("h hq j ell mu")
    alpha, beta, chi = s.symbols("alpha beta chi")
    eigenvalues = (p * h + q * hq, h + (p - 1) * j + q * mu,
                   hq + (q - 1) * ell + p * mu)
    scalar = eigenvalues[0] + p * eigenvalues[1] + q * eigenvalues[2]
    sectional = {
        h: -z * (r * fr - f + f**2) / r**2 - zr * f / (2 * r),
        hq: -zr / (2 * r),
        j: 1 / (ratio * r)**2 - z * f**2 / r**2,
        ell: (1 - z) / r**2,
        mu: -z * f / r**2,
    }
    scalar_f = (p * (p - 1) / ratio**2 + q * (q - 1) * (1 - z)
                - p * z * ((p + 1) * f**2 + (2 * q - 2) * f + 2 * r * fr)
                - (p * f + q) * r * zr)
    zero("scalar_in_logarithmic_slope", r**2 * scalar.subs(sectional) - scalar_f)
    cone = {p: 2, z: (q - 1) / (q + 1), f: 1, fr: 0, zr: 0,
            ratio: 1 / s.sqrt(q - 1)}
    for index, value in enumerate(eigenvalues):
        zero(f"cone_ricci_eigenvalue_{index}", r**2 * value.subs(sectional).subs(cone))

    weighted_matrix = s.Matrix([
        [0, p * h, q * hq],
        [h, (p - 1) * j, q * mu],
        [hq, p * mu, (q - 1) * ell],
    ])
    vector = s.Matrix([alpha, beta, chi])
    form = (vector.T * s.diag(1, p, q) * weighted_matrix * vector)[0]
    ordered_form = (2 * p * h * alpha * beta + 2 * q * hq * alpha * chi
                    + p * (p - 1) * j * beta**2
                    + q * (q - 1) * ell * chi**2 + 2 * p * q * mu * beta * chi)
    zero("curvature_action_multiplicities", form - ordered_form)

    R, hc, y = s.symbols("R hc y", positive=True)
    zero("moving_drift_cancellation",
         hc * (q - 1) * (1 / (R + hc * y) - 1 / R)
         + (q - 1) * hc**2 * y / ((R + hc * y) * R))
    tau = s.symbols("tau", nonnegative=True)
    center_ratio_squared = 1 + 2 * (q - 1) * tau / q
    zero("moving_center_upper_bound_decomposition",
         9 - center_ratio_squared - (8 / q + 2 * (q - 1) * (4 - tau) / q))
    delta, theta, b, a, L, sigma = s.symbols(
        "delta theta b a L sigma", positive=True)
    u = s.Function("u")(r)
    zz = s.Function("z")(r)
    u_rhs = zz * s.diff(u, r, 2) + (q - 1 + zz) * s.diff(u, r) / r - (p - 1) * s.exp(-2 * u)
    w_rhs = (zz * s.diff(u, r, 3)
             + (s.diff(zz, r) + (q - 1 + zz) / r) * s.diff(u, r, 2)
             + (s.diff(zz, r) / r - (q - 1 + zz) / r**2
                + 2 * (p - 1) * s.exp(-2 * u)) * s.diff(u, r))
    zero("differentiated_u_equation", s.diff(u_rhs, r) - w_rhs)
    vv = s.Function("v")(r)
    ur = s.symbols("ur", real=True)
    potential = (q - 1) * vv * (1 + vv) / r**2
    v_rhs = (vv**2 * s.diff(vv, r, 2) + (q - 1 - vv**2) * s.diff(vv, r) / r
             + (q - 1) * vv * (1 - vv**2) / r**2 - p * vv**3 * ur**2)
    cap_w = (-v_rhs + vv**2 * s.diff(vv, r, 2)
             + (q - 1 - vv**2) * s.diff(vv, r) / r + potential * (1 - vv))
    zero("cap_slope_equation", cap_w - p * vv**3 * ur**2)
    cap_test = r / theta
    cap_test_operator = (-sigma * theta * s.diff(cap_test, theta) / delta
                         - vv**2 * s.diff(cap_test, r, 2)
                         - (q - 1 - vv**2) * s.diff(cap_test, r) / r
                         + potential * cap_test)
    zero("cap_slope_supersolution_operator",
         cap_test_operator - sigma * r / (delta * theta)
         - ((q - 1) * (vv * (1 + vv) - 1) + vv**2) / (r * theta))

    def heat(expression):
        return (-s.diff(expression, delta) - sigma * theta * s.diff(expression, theta) / delta
                - z * s.diff(expression, r, 2) - (q - 1 + z) * s.diff(expression, r) / r)

    D = r**2 + b * theta**2
    H = delta**L * D**(-a / 2)
    exact_H = (-L / delta + a * sigma * b * theta**2 / (delta * D)
               + (a * (q - 1) + 2 * a * z) / D
               - a * (a + 2) * z * r**2 / D**2)
    zero("inner_barrier_operator", s.powsimp(heat(H) / H) - exact_H)
    lower_H = -L / delta + (a * (q - 1) - a**2 * z) / D
    positive_remainder = (a * sigma * b * theta**2 / (delta * D)
                          + a * (a + 2) * z * b * theta**2 / D**2)
    zero("inner_barrier_nonnegative_remainder", exact_H - lower_H - positive_remainder)
    power = s.symbols("power", real=True)
    zero("radial_power_operator",
         heat(r**power) + power * (q - 1 + power * z) * r**(power - 2))
    exterior = 1 - b * delta / r**2
    zero("exterior_operator",
         heat(exterior) - b / r**2 * (1 - (2 * (q - 1) - 4 * z) * delta / r**2))
    C, Cs = s.symbols("C Cs", positive=True)
    margin = (a - 2) * (q - 1) - C - 2 * a**2 - 1
    zero("strict_inner_margin",
         -1 + a * (q - 1) - 2 * a**2 - 2 * (q - 1) - C - b * Cs
         - (margin - b * Cs))

    K, slack = s.symbols("K slack", positive=True)
    E = (6 * K + 16)**2 + 64
    low = 4 + K / 2
    top = q - 1 + 4 + 2 * E
    sharp = 8 + 4 * E
    x, y1, y2, c1, c2 = s.symbols("x y1 y2 c1 c2", real=True)
    young = (2 * (c1**2 + c2**2) * x**2 / q
             + q * (y1**2 + y2**2) / 2 - 2 * x * (c1 * y1 + c2 * y2))
    zero("block_young_sum_of_squares",
         q * young / 2 - (c1 * x - q * y1 / 2)**2 - (c2 * x - q * y2 / 2)**2)
    zero("sharp_reaction_constant", 2 * top - (2 * (q - 1) + sharp))
    positive_polynomial("block_gap_for_all_q_ge_K_plus_10",
                        (top - low - q / 2).subs(q, K + 10 + slack), (K, slack))

    k, d = s.symbols("k d", positive=True)
    aa = s.Rational(5, 2)
    zero("construction_exponent", aa - (k - 1) / (k / d) - (aa - d + d / k))
    zero("construction_scale_relation", (k - d / 2) / d - (k / d - s.Rational(1, 2)))
    zero("annular_lateral_exponent",
         (k - d / 2) - 1 - ((k - 1) - aa / 2) - (aa - d) / 2)
    ds, ks = s.symbols("ds ks", positive=True)
    positive_polynomial("e_below_one_for_k_ge_6_and_d_gt_2",
                        (k * (d - aa + 1) - d).subs({d: 2 + ds, k: 6 + ks}), (ds, ks))
    n = s.symbols("n", positive=True)
    zero("root_above_two_square_gap", (n - 4)**2 - n * (n - 8) - 16)
    zero("root_below_five_halves_test", aa**2 - n * aa + 2 * n - (s.Rational(25, 4) - n / 2))

    eta, nu, w = s.symbols("eta nu w", positive=True)
    sigma_gap = sigma - s.Rational(1, 2)
    gap = nu - sigma - eta * sigma_gap
    general_a = 2 + eta
    general_L = sigma * (general_a - 1) + w
    zero("continuous_parameter_gap",
         nu - 1 + general_a / 2 - sigma * (general_a - 1) - gap)
    zero("continuous_parameter_e", general_a - general_L / sigma - (1 - w / sigma))
    zero("continuous_parameter_lateral",
         nu - 1 - general_L + general_a / 2 - (gap - w))

    inner_fraction = Fraction(49, 256)
    if not (inner_fraction < 1 and Fraction(4, 64) == Fraction(1, 16)):
        raise AssertionError("moving-cylinder rational bounds")
    checks["moving_cylinder_all_q_ge_16"] = {
        "R_over_rc": ["1", "3"],
        "r_over_rc": ["1/2", "7/2"],
        "r_squared_over_delta_c_upper": str(inner_fraction),
        "backward_time_over_delta_c_upper": "1/(16*q)",
    }

    payload_path = HERE / "jacobian/reaction-matrix-payload.json"
    output_path = HERE / "jacobian/reaction-matrix-output.json"
    payload = json.loads(payload_path.read_text())
    output = json.loads(output_path.read_text())
    adapter_status = json.loads((HERE / "jacobian/run-status.json").read_text())
    expected_operation = "matrix.symbolic.characteristic_polynomial.compute"
    if output["request"]["operation_id"] != expected_operation:
        raise AssertionError("wrong Jacobian operation")
    if (adapter_status["exit_code"] != 0 or adapter_status["timed_out"]
            or adapter_status["structured_error"] is not None
            or adapter_status["status"] != "typed_output_received"):
        raise AssertionError(f"Jacobian is not mathematical evidence: {output['result']}")
    if output["request"]["payload"] != payload or output["result"]["operation_id"] != expected_operation:
        raise AssertionError("Jacobian payload/operation mismatch")
    jacobian_result = output["result"]["output"]
    if jacobian_result["convention"] != "DET_LAMBDA_I_MINUS_A":
        raise AssertionError("wrong characteristic-polynomial convention")
    variables = [s.Symbol(v) for v in payload["matrix"]["variables"]]

    def rational_function(value):
        if value["variables"] != payload["matrix"]["variables"]:
            raise AssertionError("Jacobian variable-order mismatch")

        def polynomial(poly):
            return sum(s.Rational(t["coefficient"]["num"], t["coefficient"]["den"])
                       * s.prod(v**e for v, e in zip(variables, t["exponents"], strict=True))
                       for t in poly["terms"])

        return polynomial(value["numerator"]) / polynomial(value["denominator"])

    matrix = s.Matrix([[rational_function(v) for v in row] for row in payload["matrix"]["entries"]])
    va, vb, vc, vJ, vL = variables
    if matrix != s.Matrix([[0, va, vb], [va, vJ, vc], [vb, vc, vL]]):
        raise AssertionError("payload is not the audited reaction-matrix pattern")
    local_coefficients = matrix.charpoly().all_coeffs()
    remote_coefficients = [rational_function(v) for v in jacobian_result["coefficients_descending"]]
    if jacobian_result["degree"] != 3 or len(remote_coefficients) != 4:
        raise AssertionError("incomplete Jacobian output")
    for index, (local, remote) in enumerate(zip(local_coefficients, remote_coefficients, strict=True)):
        zero(f"jacobian_characteristic_coefficient_{index}", local - remote)

    return {
        "claim": "C_HD_SCALAR",
        "extension_claim": "C_HD_SHARP",
        "result_class": "new_theorem_candidate",
        "theorem": "Under the explicit construction and analytic inputs proved or cited in HIGHDIM_AUDIT.md, the selected flows have globally bounded scalar curvature and finite-time full-curvature blowup. The dimension-uniform reaction error improves to O(1).",
        "continuous_comparison_extension": "sigma>1/2 and nu>max(1,sigma) suffice after choosing a>2, then q large enough, under the explicitly stated uniform geometric, cap, and annular hypotheses.",
        "mechanical_scope": "Exact symbolic identities, universal polynomial/positivity reductions, rational cylinder bounds, and replay of one bounded typed Jacobian result. Not a compiler check of the analytic PDE proof.",
        "analytic_argument": "../../HIGHDIM_AUDIT.md",
        "independent_review": "pending Host-invoked Reviewer; no approval claimed",
        "novelty_status": "not established by the literature search",
        "false_manuscript_assertions_identified": [],
        "jacobian": {
            "operation_id": expected_operation,
            "protocol_version": output["protocol_version"],
            "server": output["server"],
            "transport": output["transport"],
            "adapter_status": adapter_status,
            "payload": "jacobian/reaction-matrix-payload.json",
            "typed_output": "jacobian/reaction-matrix-output.json",
        },
        "checks": checks,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    result = verify()
    certificate = HERE / "exact_certificate.json"
    if arguments.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    if json.loads(certificate.read_text()) != result:
        raise AssertionError("stored certificate does not match exact replay")
    print(f"PASS: {len(result['checks'])} exact checks; analytic proof and independent review remain separate.")


if __name__ == "__main__":
    main()
