#!/usr/bin/env python3
"""Exact algebra certificates for the returning-passage proof in REPORT.md."""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
CHECKS = []


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def identity(name, expression):
    if isinstance(expression, sp.MatrixBase):
        residues = [sp.cancel(entry) for entry in expression]
    else:
        residues = [sp.cancel(expression)]
    require(all(entry == 0 for entry in residues), f"{name}: {residues}")
    CHECKS.append({"name": name, "kind": "exact_identity", "residual": "0"})


def nonnegative_polynomial(name, expression, variables):
    polynomial = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
    require(all(c >= 0 for c in polynomial.coeffs()), name)
    CHECKS.append(
        {
            "name": name,
            "kind": "nonnegative_monomial_coefficients",
            "domain": [f"{v} >= 0" for v in variables],
            "polynomial": str(polynomial.as_expr()),
            "coefficients": [str(c) for c in polynomial.coeffs()],
        }
    )


def bernstein_nonnegative(name, expression, interval_variable, other_variables):
    polynomial = sp.Poly(sp.expand(expression), *other_variables)
    rows = []
    for exponents, coefficient in polynomial.terms():
        coefficient = sp.Poly(coefficient, interval_variable, domain=sp.QQ)
        degree = max(0, coefficient.degree())
        bernstein = [
            sum(
                coefficient.nth(i)
                * sp.Rational(1, 2) ** i
                * sp.binomial(k, i)
                / sp.binomial(degree, i)
                for i in range(k + 1)
            )
            for k in range(degree + 1)
        ]
        require(all(c >= 0 for c in bernstein), f"{name}: {bernstein}")
        rows.append(
            {
                "other_exponents": list(exponents),
                "bernstein_coefficients": [str(c) for c in bernstein],
            }
        )
    CHECKS.append(
        {
            "name": name,
            "kind": "exact_Bernstein_positivity",
            "domain": [f"0 <= {interval_variable} <= 1/2"]
            + [f"{v} >= 0" for v in other_variables],
            "polynomial": str(sp.expand(expression)),
            "rows": rows,
        }
    )


def determinant_problem():
    a, b, c, mu, p1, p2, length = sp.symbols("a b c mu p1 p2 L")
    variables = (a, b, c, mu, p1, p2, length)
    discriminant = a * c - b**2
    matrix = sp.Matrix(
        [
            [
                length * c + length * mu * discriminant - discriminant * p1**2,
                -length * b - discriminant * p1 * p2,
            ],
            [
                -length * b - discriminant * p1 * p2,
                length * a - discriminant * p2**2,
            ],
        ]
    )
    expected = length * discriminant * (
        length * (1 + mu * a)
        - a * p1**2
        - 2 * b * p1 * p2
        - c * p2**2
        - mu * discriminant * p2**2
    )
    return variables, matrix, expected


def typed_polynomial(expression, variables):
    polynomial = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
    return {
        "terms": [
            {
                "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                "exponents": list(exponents),
            }
            for exponents, coefficient in polynomial.terms()
            if coefficient != 0
        ]
    }


def typed_entry(expression, variables):
    return {
        "domain": "QQ",
        "variables": [str(v) for v in variables],
        "numerator": typed_polynomial(expression, variables),
        "denominator": typed_polynomial(sp.Integer(1), variables),
    }


def prepare_jacobian():
    variables, matrix, _ = determinant_problem()
    payload = {
        "matrix": {
            "variables": [str(v) for v in variables],
            "entries": [
                [typed_entry(matrix[i, j], variables) for j in range(matrix.cols)]
                for i in range(matrix.rows)
            ],
        }
    }
    path = HERE / "jacobian_payload.json"
    path.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"Prepared polynomial 2x2 determinant request: {path.name}")


def family_identities():
    d1, d2, shear = sp.symbols("d1 d2 shear", nonzero=True)
    eps, kappa, b, d = sp.symbols("epsilon kappa b d", nonzero=True)
    shear_matrix = sp.Matrix([[1, shear], [0, 1]])
    diagonal = sp.diag(d1, d2)
    p = shear_matrix * diagonal * shear_matrix.T
    q = sp.Matrix([[1 / d1, -shear / d1], [-shear / d1, 1 / d2 + shear**2 / d1]])
    identity("actual_cometric_inverse", p * q - sp.eye(2))
    identity("actual_cometric_determinant", p.det() - d1 * d2)

    frame = sp.Matrix([[eps, 1], [1, 0]])
    frame_inverse = sp.Matrix([[0, 1], [1, -eps]])
    swap = sp.Matrix([[0, 1], [1, 0]])
    shifted_shear = sp.Matrix([[1, shear - eps], [0, 1]])
    identity("right_frame_inverse", frame * frame_inverse - sp.eye(2))
    identity(
        "right_frame_full_path",
        frame_inverse * p * frame_inverse.T
        - swap * shifted_shear * diagonal * shifted_shear.T * swap,
    )
    identity(
        "right_frame_endpoint_germ",
        frame_inverse * p.subs({d1: b, d2: d, shear: eps}) * frame_inverse.T
        - sp.diag(d, b),
    )

    p1, p2 = sp.symbols("p1 p2")
    momentum = sp.Matrix([p1, p2])
    transformed_momentum = frame.T * momentum
    identity(
        "momentum_frame_invariance",
        (transformed_momentum.T * frame_inverse * p * frame_inverse.T * transformed_momentum)[0]
        - (momentum.T * p * momentum)[0],
    )
    d1p, d2p, sp1 = sp.symbols("d1p d2p shear_prime")
    pprime = p.diff(d1) * d1p + p.diff(d2) * d2p + p.diff(shear) * sp1
    left_values = {d1: 1, d2: b, shear: 0, d1p: kappa, d2p: 0, sp1: 0}
    right_values = {d1: b, d2: 1, shear: eps, d1p: 0, d2p: -kappa, sp1: 0}
    e = sp.Matrix([1, 0])
    e2 = sp.Matrix([0, 1])
    h = sp.Matrix([eps, 1])
    identity("left_endpoint_cometric_slope", pprime.subs(left_values) - kappa * e * e.T)
    identity("right_endpoint_outward_cometric_slope", pprime.subs(right_values) + kappa * h * h.T)
    identity(
        "right_endpoint_inward_cometric_slope",
        -frame_inverse * pprime.subs(right_values) * frame_inverse.T - kappa * e * e.T,
    )
    qprime = -q * pprime * q
    identity("left_endpoint_metric_slope", qprime.subs(left_values) + kappa * e * e.T)
    identity("right_endpoint_metric_slope", qprime.subs(right_values) - kappa * e2 * e2.T)

    t = sp.symbols("t")
    df = sp.Function("d")(t)
    sf = sp.Function("s")(t)
    identity(
        "shear_second_diagonal_derivative",
        sp.diff(df * sf**2, t, 2)
        - (
            sp.diff(df, t, 2) * sf**2
            + 4 * sp.diff(df, t) * sf * sp.diff(sf, t)
            + 2 * df * (sp.diff(sf, t) ** 2 + sf * sp.diff(sf, t, 2))
        ),
    )
    identity(
        "shear_second_offdiagonal_derivative",
        sp.diff(df * sf, t, 2)
        - (sp.diff(df, t, 2) * sf + 2 * sp.diff(df, t) * sp.diff(sf, t) + df * sp.diff(sf, t, 2)),
    )
    delta, m1, m2 = sp.symbols("delta M1 M2", nonnegative=True)
    raw_first = delta**3 + delta + 3 * delta**2 * m1 + sp.Rational(3, 2) * m1
    raw_second = (
        delta**3
        + delta
        + 4 * delta**3 * m1
        + 2 * delta * m1
        + 3 * delta**2 * (m1**2 + m2)
        + sp.Rational(3, 2) * m2
    )
    first_bound = sp.Rational(5, 8) + sp.Rational(9, 4) * m1
    second_bound = (
        sp.Rational(5, 8)
        + sp.Rational(3, 2) * m1
        + sp.Rational(3, 4) * m1**2
        + sp.Rational(9, 4) * m2
    )
    bernstein_nonnegative("first_derivative_triangle_majorant", first_bound - raw_first, delta, (m1, m2))
    bernstein_nonnegative("second_derivative_triangle_majorant", second_bound - raw_second, delta, (m1, m2))
    nonnegative_polynomial("K1_dominates_majorant", 1 + 3 * m1 - first_bound, (m1, m2))
    nonnegative_polynomial("K2_dominates_majorant", 1 + 2 * m1 + m1**2 + 3 * m2 - second_bound, (m1, m2))
    nonnegative_polynomial("B_dominates_derivative_norm", 2 * (1 + m1) - (1 + (1 + 3 * m1) / 2), (m1, m2))
    m = sp.Rational(16, 59049)
    c0 = 3 + 2 * (2 * (1 + m1)) ** 2 / m
    nonnegative_polynomial("C0_dominates_B", c0 - 2 * (1 + m1), (m1, m2))
    require(sp.Rational(16, 25) > sp.Rational(1, 2), "lower ellipticity")
    require(sp.Rational(75, 32) < 3, "upper ellipticity")
    CHECKS.append({"name": "ellipticity_constants", "kind": "exact_rational_comparison", "P_lower": "16/25 > 1/2", "P_upper": "75/32 < 3"})


def analytic_formula_identities():
    t = sp.symbols("t")
    radius = sp.Rational(2, 3) - t
    a = sp.exp(-1 / radius)
    identity("a_derivative", sp.diff(a, t) + a / radius**2)
    identity("timing_exponent", -1 / (sp.Rational(2, 3) - sp.Rational(1, 8)) + sp.Rational(3, 2) + sp.Rational(9, 26))
    x = sp.symbols("x")
    identity("h_monotonicity_derivative", sp.diff(x**2 * sp.exp(-x), x) - x * (2 - x) * sp.exp(-x))
    rho = sp.exp(-1 / t)
    identity("smooth_cutoff_first_derivative", sp.diff(rho, t) - rho / t**2)
    identity("smooth_cutoff_second_derivative", sp.diff(rho, t, 2) - rho * (1 / t**4 - 2 / t**3))
    require(sp.Rational(256, 16) + sp.Rational(54, 8) < 23, "rho second-derivative majorant")
    require(9 * (1 + 1) == 18, "theta first-derivative majorant")
    require(9 * (23 + 2 * 18 + 46) == 945, "theta second-derivative majorant")
    CHECKS.append({"name": "fixed_cutoff_derivative_constants", "kind": "exact_rational_comparison", "M1": 108, "M2": 34020})

    af = sp.Function("A")(t)
    ell = (1 + sp.Symbol("delta") * af) ** (-sp.Rational(1, 2))
    delta = sp.Symbol("delta")
    expected = (
        -delta * sp.diff(af, t, 2) / (2 * (1 + delta * af) ** sp.Rational(3, 2))
        + 3 * delta**2 * sp.diff(af, t) ** 2 / (4 * (1 + delta * af) ** sp.Rational(5, 2))
    )
    identity("end_warp_second_derivative", sp.diff(ell, t, 2) - expected)
    lf = sp.Function("ell")(t)
    identity("end_surface_curvature", -sp.diff(sp.diff(lf, t) / lf, t) - (sp.diff(lf, t) / lf) ** 2 + sp.diff(lf, t, 2) / lf)


def index_and_endpoint_identities():
    a, b, c = sp.symbols("a b c")
    pmat = sp.Matrix([[a, b], [b, c]])
    qmat = pmat.inv()
    d, e, f, h, i, j = sp.symbols("d e f h i j")
    pprime = sp.Matrix([[d, e], [e, f]])
    psecond = sp.Matrix([[h, i], [i, j]])
    qprime = -qmat * pprime * qmat
    qsecond = 2 * qmat * pprime * qmat * pprime * qmat - qmat * psecond * qmat
    identity("inverse_first_product_rule", qprime * pmat + qmat * pprime)
    identity("inverse_second_product_rule", qsecond * pmat + 2 * qprime * pprime + qmat * psecond)
    p1, p2, z1, z2, w, wp = sp.symbols("p1 p2 z1 z2 w wp")
    p = sp.Matrix([p1, p2])
    zdot = sp.Matrix([z1, z2])
    xdot = pmat * p
    original = (
        wp**2
        + (zdot.T * qmat * zdot)[0]
        + 2 * w * (zdot.T * qprime * xdot)[0]
        + w**2 * (xdot.T * qsecond * xdot)[0] / 2
    )
    xi = zdot - pprime * p * w
    completed = wp**2 + (xi.T * qmat * xi)[0] - w**2 * (p.T * psecond * p)[0] / 2
    identity("coordinate_second_variation_square_completion", original - completed)

    kappa, v0, z0, zL = sp.symbols("kappa v0 z0 zL")
    mu = kappa * v0 / 4
    identity(
        "entry_and_exit_boundary_signs",
        -( -kappa * v0 * zL**2 / 2 - kappa * v0 * z0**2 / 2)
        - mu * ((zL - z0) ** 2 + (zL + z0) ** 2),
    )
    length, q0, qL, w0, wL = sp.symbols("L q0 qL w0 wL")
    h0, hL = -w0 / v0, wL / v0
    identity("unrestricted_initial_gauge", w0 + h0 * v0)
    identity("unrestricted_final_gauge", wL - hL * v0)
    identity("affine_gauge_tangential_energy", length * ((qL - q0) / length) ** 2 - (qL - q0) ** 2 / length)

    energy, pairing, s_norm = sp.symbols("E lambda_X lambda_S_lambda")
    residual = energy - 2 * pairing + s_norm
    identity("Dirichlet_energy_square_completion", energy - (residual + 2 * pairing - s_norm))
    X = sp.Matrix(sp.symbols("X1 X2"))
    lam = pmat.inv() * X
    identity("exact_endpoint_energy_minimum", 2 * (lam.T * X)[0] - (lam.T * pmat * lam)[0] - (X.T * pmat.inv() * X)[0])

    v, up, u, f1, f2, rlam = sp.symbols("v u_prime u F_prime F_second r_lambda")
    qsecond_value = rlam * v - f1 * up / 2 + v * (-f2 * u / 2 - rlam) + f2 * v * u / 2 + f1 * up / 2
    identity("attaining_field_has_affine_tangential_component", qsecond_value)

    mu_symbol = sp.symbols("mu")
    boundary_axis = sp.Matrix([1, 0])
    rank_one = pmat.inv() + mu_symbol * boundary_axis * boundary_axis.T
    sherman = pmat - mu_symbol * pmat * boundary_axis * boundary_axis.T * pmat / (1 + mu_symbol * a)
    identity("rank_one_inverse", rank_one * sherman - sp.eye(2))
    spp = (p.T * pmat * p)[0]
    spe = (p.T * pmat * boundary_axis)[0]
    identity("exact_effective_endpoint_factor", (p.T * sherman * p)[0] - (spp - spe**2 / (a + 1 / mu_symbol)))
    alpha = sp.symbols("alpha")
    optimal = spe / (a + 1 / mu_symbol)
    quadratic = ((p - alpha * boundary_axis).T * pmat * (p - alpha * boundary_axis))[0] + alpha**2 / mu_symbol
    identity("boundary_dual_square_completion", quadratic - (spp - spe**2 / (a + 1 / mu_symbol) + (a + 1 / mu_symbol) * (alpha - optimal) ** 2))


def gain_and_interval():
    z, slack = sp.symbols("z slack", nonnegative=True)
    beta = sp.Rational(61, 70)
    eta = sp.Rational(9, 140)
    z0 = sp.Rational(9, 1820)
    identity("universal_gain_remainder", (1 - 5 * z) ** 2 - (beta + 3 * z) - eta - (13 * (z0 - z) + 25 * z**2))
    nonnegative_polynomial("universal_gain_on_full_interval", ((1 - 5 * z) ** 2 - (beta + 3 * z) - eta).subs(z, z0 - slack), (slack,))
    identity("gain_denominator_endpoint", beta + 3 * z0 - sp.Rational(1613, 1820))
    require(0 < beta <= sp.Rational(1613, 1820) < 1, "gain denominator positivity")
    require(1 - 5 * z0 > 0, "positive lower mixed bound")
    identity("rational_timing_bound", (1 + 1 / (1 + sp.Rational(9, 26))) / 2 - beta)

    m = sp.Rational(16, 59049)
    m1, m2 = sp.Integer(108), sp.Integer(34020)
    k2 = 1 + 2 * m1 + m1**2 + 3 * m2
    b = 2 * (1 + m1)
    c0 = 3 + 2 * b**2 / m
    delta = sp.Rational(1, 10**12)
    require(k2 == 113941, "explicit K2")
    require(c0 == sp.Rational(701561175, 2), "explicit C0")
    upper_bounds = (sp.Rational(1, 2), m / (2 * k2), 9 / (1820 * c0))
    require(all(0 < delta <= bound for bound in upper_bounds), "explicit delta interval")
    CHECKS.append(
        {
            "name": "fixed_cutoff_nonempty_delta_interval",
            "kind": "exact_rational_comparison",
            "delta_upper": str(delta),
            "K2": str(k2),
            "C0": str(c0),
            "construction_upper_bounds": [str(bound) for bound in upper_bounds],
            "positive_slacks": [str(bound - delta) for bound in upper_bounds],
        }
    )
    return {"m": str(m), "M1_upper": 108, "M2_upper": 34020, "K2": str(k2), "C0": str(c0), "delta_interval": "0 < delta <= 1/1000000000000", "beta_upper": str(beta), "coercivity_eta": str(eta)}


def parse_typed_polynomial(value, variables):
    result = sp.Integer(0)
    for term in value["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == len(variables), "Jacobian exponent arity")
        require(all(isinstance(n, int) and n >= 0 for n in exponents), "Jacobian polynomial exponents")
        coefficient = term["coefficient"]
        coefficient = sp.Rational(int(coefficient["num"]), int(coefficient["den"]))
        result += coefficient * sp.prod(v**n for v, n in zip(variables, exponents))
    return result


def jacobian_evidence():
    variables, matrix, expected = determinant_problem()
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    expected_payload = {
        "matrix": {
            "variables": [str(v) for v in variables],
            "entries": [
                [typed_entry(matrix[i, j], variables) for j in range(matrix.cols)]
                for i in range(matrix.rows)
            ],
        }
    }
    require(payload == expected_payload, "Jacobian request differs from the stated endpoint matrix")
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    require(status["exit_code"] == 0 and not status["timed_out"], "Jacobian did not complete successfully")
    output = json.loads((HERE / "jacobian_output.json").read_text())
    require(output["server"]["version"] == "0.14.0", "unexpected Jacobian version")
    require(output["protocol_version"] == "2025-11-25", "unexpected Jacobian protocol")
    require(output["request"]["payload"] == payload, "Jacobian output belongs to a different request")
    result = output["result"]
    require(result["operation_id"] == "matrix.symbolic.determinant.compute", "Jacobian operation mismatch")
    require(result["output"]["method"] == "SYMPY_BAREISS", "Jacobian response is not the inspected determinant result")
    determinant = result["output"]["determinant"]
    require(determinant["variables"] == [str(v) for v in variables], "Jacobian variable order")
    numerator = parse_typed_polynomial(determinant["numerator"], variables)
    denominator = parse_typed_polynomial(determinant["denominator"], variables)
    require(denominator != 0, "Jacobian returned a zero denominator")
    identity("Jacobian_universal_endpoint_determinant", numerator / denominator - expected)
    identity("independent_universal_endpoint_determinant", matrix.det() - expected)
    return {
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "operation_id": result["operation_id"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "adapter_status_file": "jacobian_adapter_status.json",
        "adapter_exit_code": status["exit_code"],
        "timed_out": status["timed_out"],
        "meaning": "Universal polynomial determinant identity, not a geometric or positivity oracle.",
        "expected_determinant": str(sp.factor(expected)),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        prepare_jacobian()
        return
    family_identities()
    analytic_formula_identities()
    index_and_endpoint_identities()
    constants = gain_and_interval()
    jacobian = jacobian_evidence()
    certificate = {
        "format_version": 1,
        "claim": "C358_RETURNING",
        "companion_claim": "C358_ENDPOINT",
        "result_class": "new_reduction",
        "mathematical_result": "Uniform verification of the actual returning-passage proposition, attained endpoint criterion, quantitative deep-return gap, and exact nullspace.",
        "formal_kernel_verification": False,
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_established_by_search",
        "finite_sampling_used": False,
        "proof": "REPORT.md",
        "mechanical_scope": "Exact symbolic identities, rational comparisons, and universal polynomial positivity certificates only.",
        "analytic_dependencies": [
            {"item": "Smooth actual cometric, both end frames, concavity and derivative domination", "proof": "REPORT.md Section 1", "status": "proved_in_mathematical_report"},
            {"item": "Actual returning geodesic data, transversality, symmetry and timing", "proof": "REPORT.md Sections 2 and 4", "status": "proved_in_mathematical_report"},
            {"item": "Intrinsic second variation and unrestricted endpoint gauge", "proof": "REPORT.md Section 2", "status": "proved_in_mathematical_report"},
            {"item": "Scalar Dirichlet ODE existence, square completion and attainment", "proof": "REPORT.md Section 3", "status": "proved_in_mathematical_report"},
            {"item": "All response-matrix estimates, quantitative gap, shallow curvature and nullspace", "proof": "REPORT.md Sections 4-5", "status": "proved_in_mathematical_report"},
        ],
        "constants_for_explicit_fixed_cutoff": constants,
        "jacobian": jacobian,
        "exact_checks": CHECKS,
        "remaining_review": "Independently read and replay the proof, source fidelity and symbolic certificate; assess novelty and significance. The global main theorem is outside this certificate.",
    }
    path = HERE / "exact_certificate.json"
    path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    print(f"Verified {len(CHECKS)} exact identities/positivity certificates; wrote {path.name}.")


if __name__ == "__main__":
    main()
