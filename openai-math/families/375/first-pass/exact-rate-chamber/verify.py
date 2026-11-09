#!/usr/bin/env python3
"""Replay exact algebra and uniform-bound constants, not a PDE proof checker."""

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "De-Giorgis-conjecture-in-dimension-eight-September-26-2026"
    / "build/sections/04-interface.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compute_certificate():
    identities = []
    bounds = []

    def equal(name, expression, expected=0):
        residual = sp.cancel(sp.expand(expression - expected))
        require(residual == 0, f"{name}: nonzero residual {residual}")
        identities.append({"name": name, "residual": "0"})

    def positive(name, value):
        value = Fraction(value)
        require(value > 0, f"{name}: nonpositive margin {value}")
        bounds.append({"name": name, "positive_exact_margin": str(value)})

    a = sp.sqrt(2)
    g, b = sp.symbols("g b", real=True)
    G = (1 - g**2) / a
    V = 3 * g**2 - 1
    derivative = lambda expression: sp.diff(expression, g) * G
    equal("quartic_profile", derivative(G), g**3 - g)
    equal("linearized_profile", derivative(derivative(G)), V * G)

    def product_operator(b_prime):
        expression = G * b
        total = lambda f: sp.diff(f, g) * G + sp.diff(f, b) * b_prime
        return -total(total(expression)) + V * expression

    equal("homogeneous_reduction_of_order", product_operator(1 / G**2))
    equal("positive_half_line_barrier", product_operator((1 - g) / G**2), 1)

    J = sp.symbols("J", real=True)
    w = G * b
    total_w = lambda f: (
        sp.diff(f, g) * G
        + sp.diff(f, b) * J / G**2
        - sp.diff(f, J) * G**2
    )
    equal("tangent_ball_correction", -total_w(total_w(w)) + V * w, G)

    Y, Yp, k, kp, q, E, potential = sp.symbols(
        "Y Yp k kp q E potential", nonzero=True
    )
    kpp = -2 * Yp * kp / Y - q
    phi = E * Y * k
    phi_p = E * ((Yp - a * Y) * k + Y * kp)
    phi_pp = E * (
        (potential * Y - 2 * a * Yp + a**2 * Y) * k
        + 2 * (Yp - a * Y) * kp
        + Y * kpp
    )
    equal(
        "shifted_barrier_identity",
        -phi_pp - 2 * a * phi_p + (potential - 2) * phi,
        E * Y * q,
    )
    require(
        sp.cancel(-phi_pp + 2 * a * phi_p + (potential - 2) * phi - E * Y * q)
        != 0,
        "The shifted-operator negative control did not detect a reversed sign",
    )

    normals = sp.symbols("n1:8", real=True)
    f, fp, fpp, Vstar = sp.symbols("f fp fpp Vstar", real=True)
    norm2 = sum(n**2 for n in normals)
    lifted_laplacian = sum(
        a**2 * n**2 * f + (2 * a * n * fp + fpp if i == 6 else 0)
        for i, n in enumerate(normals)
    )
    equal(
        "tilted_euclidean_operator",
        -lifted_laplacian + Vstar * f,
        -fpp - 2 * a * normals[-1] * fp + (Vstar - 2 * norm2) * f,
    )
    equal(
        "unit_normal_tilt_relation",
        sum(n**2 for n in normals[:-1]) + (normals[-1] - 1) ** 2,
        2 * (1 - normals[-1]) + norm2 - 1,
    )
    require(
        sp.expand(
            -lifted_laplacian
            + Vstar * f
            - (-fpp + 2 * a * normals[-1] * fp + (Vstar - 2 * norm2) * f)
        )
        != 0,
        "The tilted-operator negative control did not detect a reversed sign",
    )

    r, faces = sp.symbols("r faces", real=True)
    equal(
        "polytope_single_face",
        (2 - a**2) * r - faces * (2 - 4 * a**2) * r**2,
        6 * faces * r**2,
    )
    radii = sp.symbols("r1:15", real=True)
    equal(
        "fourteen_face_cauchy_identity",
        14 * sum(x**2 for x in radii) - sum(radii) ** 2,
        sum((radii[i] - radii[j]) ** 2 for i in range(14) for j in range(i)),
    )
    z = sp.symbols("z", real=True)
    equal("profile_denominator_interval_factorization", 9 - (1 + z) ** 2, (2 - z) * (4 + z))
    equal(
        "initial_profile_lower_bound",
        2 * a * z / (1 + z) ** 2 - 4 * a / 9,
        2 * a * (2 - z) * (2 * z - 1) / (9 * (1 + z) ** 2),
    )
    equal(
        "profile_uniform_lower_bound",
        2 * a / (1 + z) ** 2 - 2 * a / 9,
        2 * a * (2 - z) * (4 + z) / (9 * (1 + z) ** 2),
    )
    equal(
        "profile_uniform_upper_bound",
        2 * a - 2 * a / (1 + z) ** 2,
        2 * a * z * (z + 2) / (1 + z) ** 2,
    )
    equal(
        "phase_tail_lower_bound",
        2 / (1 + z) - sp.Rational(2, 3),
        2 * (2 - z) / (3 * (1 + z)),
    )
    equal("phase_tail_upper_bound", 2 - 2 / (1 + z), 2 * z / (1 + z))

    dv, dw = sp.symbols("dv dw", real=True)
    equal(
        "difference_potential_expansion",
        (g + dv) ** 2 + (g + dv) * (g + dw) + (g + dw) ** 2 - 3 * g**2,
        3 * g * (dv + dw) + dv**2 + dv * dw + dw**2,
    )
    c, direction, vp, vzero, verr, Vbase = sp.symbols(
        "c direction vp vzero verr Vbase", real=True
    )
    coarse_laplacian = Vbase * vzero - 1 - 2 * c * direction * vp + c**2 * vzero
    equal(
        "coarse_face_operator",
        -coarse_laplacian + (Vbase + verr) * vzero,
        1 + verr * vzero + 2 * c * direction * vp - c**2 * vzero,
    )
    eps, mu, length, s = sp.symbols("eps mu length s", positive=True)
    interval_solution = sp.sinh(mu * s) / sp.sinh(mu * length)
    equal(
        "constant_potential_route_obstruction_ode",
        -sp.diff(interval_solution, s, 2) + mu**2 * interval_solution,
    )
    equal(
        "constant_potential_route_obstruction_slope",
        sp.diff(interval_solution, s).subs(s, 0),
        mu / sp.sinh(mu * length),
    )
    equal("wrong_mass_defect", (2 - eps) - a**2, -eps)

    m = Fraction(1, 72)
    M = 32
    Q = (Fraction(M) / m) ** 2
    gamma = sp.symbols("gamma", positive=True)
    K0 = 1 + 2 * sp.Rational(Q.numerator, Q.denominator) / gamma
    F = M * K0
    D = 1024 * K0 + M * sp.Rational(Q.numerator, Q.denominator)
    tilt_limit = sp.Rational(m.numerator, m.denominator) / (12 * D)
    potential_limit = sp.Rational(m.numerator, m.denominator) / (4 * F)
    equal(
        "uniform_tilt_and_potential_absorption",
        sp.Rational(m.numerator, m.denominator) - 3 * tilt_limit * D - potential_limit * F,
        sp.Rational(m.numerator, 2 * m.denominator),
    )
    equal("Y_lower_constant", (2 * a / 9) / (16 * a), sp.Rational(1, 72))
    equal("v0_lower_constant", (2 * a / 9) / (12 * a), sp.Rational(1, 54))
    positive("sqrt2_above_one_squared_gap", Fraction(2) - 1)
    positive("sqrt2_below_three_halves_squared_gap", Fraction(9, 4) - 2)
    positive("Y_upper_margin", Fraction(32) - Fraction(177, 8))
    positive("v0_upper_margin", Fraction(64) - Fraction(93, 2))
    positive("v0_derivative_margin", Fraction(128) - Fraction(393, 4))
    positive("psi_derivative_margin", Fraction(1024) - (32 + 24 * M))
    positive("divided_maximum_principle_margin", 1 - Fraction(1, 256) * 2 * 64)
    coarse_c = Fraction(1, 2048)
    positive("coarse_face_margin_above_one_quarter", Fraction(1, 2) - 256 * coarse_c - 64 * coarse_c**2 - Fraction(1, 4))
    dimension = 7
    K = 8 * (dimension + 1)
    positive("exterior_ball_supersolution_margin", Fraction(K**2 - 2 * K * (dimension - 1), 3) - 2)

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    adapter = json.loads((HERE / "jacobian_result.json").read_text())
    require(adapter["request"]["operation_id"] == "polynomial.sos.decomposition.check", "Wrong Jacobian operation")
    require(adapter["request"]["payload"] == payload, "Jacobian output is not bound to the saved payload")
    require(adapter["result"]["operation_id"] == adapter["request"]["operation_id"], "Jacobian result operation mismatch")
    output = adapter["result"]["output"]
    require(output["is_valid"] is True, "Jacobian did not validate the polynomial identity")
    require(output["method"] == "EXACT_COEFFICIENT_IDENTITY", "Unexpected Jacobian method")
    require(output["polynomial"] == payload["polynomial"], "Jacobian polynomial mismatch")
    require(output["summands"] == payload["summands"], "Jacobian summand mismatch")
    require(output["computed_sum"] == payload["polynomial"], "Jacobian computed-sum mismatch")
    u = sp.symbols("u", real=True)

    def decode(polynomial):
        require(polynomial["domain"] == "QQ" and polynomial["variables"] == ["u"], "Unexpected coefficient ring or variable")
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"]) * u ** term["exponents"][0]
            for term in polynomial["polynomial"]["terms"]
        )

    equal(
        "jacobian_independent_coefficient_replay",
        decode(payload["polynomial"]),
        sum(decode(qi) ** 2 for qi in payload["summands"]),
    )
    equal(
        "jacobian_interval_parameterization",
        9 * (1 + u**2) ** 2 - (1 + 3 * u**2) ** 2,
        decode(payload["polynomial"]),
    )
    source = SOURCE.read_text()
    bindings = [
        r"\label{eq:L9}",
        r"|\partial_n(v-v^*_+)(0)|",
        r"e^{-\sqrt2\ell}+e^{-cP_0}",
        r"-\phi''-2a_0\phi'+(V_g-2)\phi",
        r"-\phi''-2a_0c'\phi'+(V_*-2)\phi",
    ]
    for token in bindings:
        require(token in source, f"Source statement no longer contains {token!r}")

    return {
        "certificate_version": 1,
        "result_kind": "conditional_uniform_comparison_theorem_with_exact_algebraic_core",
        "claim": "C_EXACT_TRANSFER",
        "manuscript_target": "C_L9",
        "manuscript_application_conditional_on": [
            "UP_GEOMETRY",
            "UP_ARTIFICIAL",
            "UP_MODICA",
        ],
        "full_manuscript_verified": False,
        "literal_manuscript_assertions_refuted": [],
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_assessed",
        "significance_status": "not_assessed",
        "mathematical_hypotheses": [
            "Ordered buffered same-base chamber geometry and small C^2 graph error",
            "Positive bounded artificial solution over the identical graph",
            "Classical global Lipschitz bound for U",
            "The pointwise decaying potential bound is proved analytically in report.md",
            "The exact midpoint boundary bound is proved analytically in report.md",
        ],
        "not_checked_by_this_program": [
            "Existence and geometry of the actual manuscript chamber",
            "Existence and convergence of the actual artificial solution",
            "The analytic compactness, integration, comparison, and limiting arguments in report.md",
            "Novelty, publication-level significance, and independent statement fidelity",
        ],
        "source_bindings": bindings,
        "exact_identities": identities,
        "strict_rational_margins": bounds,
        "negative_controls": {
            "reversed_shifted_drift": "detected",
            "reversed_tilted_cross_term": "detected",
            "constant_potential_loss": "nonzero_mass_defect",
        },
        "uniform_constants": {
            "initial_depth": "-log(2)/sqrt(2) <= a_start <= 0",
            "gamma_range": "0 < gamma < sqrt(2)",
            "psi_lower": str(m),
            "psi_upper": M,
            "Q": str(Q),
            "k_upper": "K0 = 1 + 2*Q/gamma",
            "phi_upper": "F = 32*K0",
            "phi_derivative_factor": "D = 1024*K0 + 32*Q",
            "tilt_limit": "1/(72*12*D)",
            "potential_error_limit": "min(1/256, 1/(72*4*F))",
            "v0_lower": "1/54",
            "v0_upper": 64,
            "v0_derivative_upper": 128,
            "coarse_exponent": str(coarse_c),
            "dimension": dimension,
            "local_boundary_gradient_factor": 2 * K,
        },
        "jacobian": {
            "operation_id": adapter["request"]["operation_id"],
            "server": adapter["server"],
            "protocol_version": adapter["protocol_version"],
            "transport": adapter["transport"],
            "schema_version": adapter["schema_version"],
            "adapter_exit_code": 0,
            "adapter_error": None,
            "adapter_timeout": False,
            "payload_file": "jacobian_payload.json",
            "typed_output_file": "jacobian_result.json",
            "independently_replayed": True,
            "scope": "A denominator inequality used for uniform profile bounds, not PDE certification",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = compute_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "The saved exact certificate differs from this replay")
    print(json.dumps({
        "ok": True,
        "exact_identities": len(certificate["exact_identities"]),
        "strict_uniform_margins": len(certificate["strict_rational_margins"]),
        "full_manuscript_verified": False,
        "independent_review": certificate["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
