#!/usr/bin/env python3
"""Replay universal algebra certificates, not a sampled or formal analytic proof."""

import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
CERT = json.loads((HERE / "exact_certificate.json").read_text())
CHECKS = []


def require(condition, message):
    if not condition:
        raise ValueError(message)


def identity(name, left, right=0):
    require(sp.expand(left - right) == 0, f"{name}: identity failed")
    CHECKS.append(name)


def nonnegative(name, expression, variables):
    polynomial = sp.Poly(sp.cancel(expression), *variables)
    require(
        all(coefficient.is_Rational and coefficient >= 0
            for coefficient in polynomial.coeffs()),
        f"{name}: negative or non-rational coefficient",
    )
    CHECKS.append(name)


def coefficient(name):
    return sp.Rational(CERT["coefficients"][name])


def decode_polynomial(record):
    require(record.get("domain", "QQ") == "QQ", "wrong coefficient ring")
    variables = tuple(sp.Symbol(name) for name in record["variables"])
    require(1 <= len(variables) <= 8, "wrong ring dimension")
    require(len(set(variables)) == len(variables), "repeated ring variable")
    terms = record["polynomial"]["terms"]
    require(len(terms) <= 4096, "polynomial support exceeds inspected contract")
    previous = None
    result = sp.Integer(0)
    for term in terms:
        exponents = tuple(term["exponents"])
        require(len(exponents) == len(variables), "wrong exponent dimension")
        require(all(isinstance(e, int) and e >= 0 for e in exponents),
                "invalid polynomial exponent")
        require(previous is None or previous > exponents,
                "terms not in descending lexicographic order")
        previous = exponents
        rational = term["coefficient"]
        number = sp.Rational(int(rational["num"]), int(rational["den"]))
        require(number != 0, "zero coefficient in sparse support")
        require(str(number.p) == rational["num"] and
                str(number.q) == rational["den"], "noncanonical rational")
        result += number * sp.prod(v**e for v, e in zip(variables, exponents))
    return result, variables


def main():
    require(CERT["schema_version"] == 1, "unsupported certificate schema")
    require(not CERT["full_machine_formalization"],
            "this verifier cannot certify a full formalization")
    require(CERT["independent_review"] == "pending",
            "an engineer replay must not manufacture independent acceptance")
    require(CERT["false_manuscript_assertions_identified"] == [],
            "a refutation needs its own assertion and witness")
    require((HERE / CERT["proof"]).is_file(), "standalone proof missing")

    source = CERT["source"]
    for path_key, anchors_key in (
        ("envelopes", "envelope_anchors"),
        ("framework", "framework_anchors"),
    ):
        text = (ROOT / source[path_key]).read_text()
        for anchor in source[anchors_key]:
            require(anchor in text, f"source anchor missing: {anchor}")
    CHECKS.append("staged_source_anchors")

    q = CERT["quantifiers"]
    require(q["minimum_base_dimension"] == 4, "wrong dimension threshold")
    require(q["parent_favorable_plane_dimension"] == 2, "wrong parent plane")
    require(coefficient("old_norm_factor") == 2, "old Hessian norm factor changed")
    require(coefficient("epsilon_vs_c") == sp.Rational(1, 2),
            "incorrect high-regime epsilon budget")
    require(coefficient("epsilon_vs_b") == sp.Rational(1, 4),
            "incorrect inherited-margin epsilon budget")
    n, d = sp.symbols("n d", nonnegative=True)
    identity("inherited_plane_intersection", 2 + (n - 2) - (n - 1), 1)
    nonnegative("two_new_directions_for_all_dimensions",
                ((n - 2) - 2).subs(n, 4 + d), (d,))

    x, y, z = sp.symbols("x y z", real=True)
    radius = sp.sqrt(x*x + y*y + z*z)
    radial = sp.Symbol("radial", positive=True)
    phi = sp.Function("phi")
    first = sp.diff(phi(radial), radial).subs(radial, radius)
    second = sp.diff(phi(radial), radial, 2).subs(radial, radius)
    coordinates = (x, y, z)
    for i in range(3):
        for j in range(i, 3):
            expected = (
                second * coordinates[i] * coordinates[j] / radius**2
                + first / radius
                * (int(i == j) - coordinates[i] * coordinates[j] / radius**2)
            )
            residual = sp.simplify(sp.diff(phi(radius), coordinates[i],
                                           coordinates[j]) - expected)
            identity(f"radial_hessian_{i}_{j}", residual)

    a, chi, f, u, s, MF = sp.symbols("a chi f u s MF", nonnegative=True)
    fp = sp.Symbol("fp", real=True)
    Q2 = 1 + s*s*(1 + a*a*chi*chi*f*f)
    flat_surplus = (
        u * Q2 + a*a*chi*chi*f*f*fp*s*s - (1 - a*a*MF) * u * Q2
    )
    flat_positive = (
        a*a*MF*u*(1 + s*s*(1-chi*chi) + a*a*chi*chi*f*f*s*s)
        + a*a*chi*chi*s*s*(f*f*fp + MF*u)
    )
    identity("flat_radial_all_slopes_identity", flat_surplus, flat_positive)
    radial_slack, chi_square_complement = sp.symbols(
        "radial_slack chi_square_complement", nonnegative=True)
    nonnegative(
        "flat_radial_all_slopes_positive",
        a*a*MF*u*(1 + s*s*chi_square_complement + a*a*chi*chi*f*f*s*s)
        + a*a*chi*chi*s*s*radial_slack,
        (a, MF, u, s, chi, f, radial_slack, chi_square_complement),
    )
    amplitude_slack = sp.Symbol("amplitude_slack", nonnegative=True)
    amplitude_product = coefficient("amplitude_product_budget") - amplitude_slack
    nonnegative(
        "radius_independent_small_amplitude",
        coefficient("transverse_lower")
        - 2 * coefficient("C0")**2 * amplitude_product
        - coefficient("new_hessian_fraction"),
        (amplitude_slack,),
    )

    NF = sp.Symbol("NF", nonnegative=True)
    identity("gradient_perturbation_bound",
             NF*chi*u - (chi*f)**2,
             chi*(NF*u-f*f) + chi*(1-chi)*f*f)
    nu, sqrtX = sp.symbols("nu sqrtX", nonnegative=True)
    identity("connection_error_square",
             sqrtX*sqrtX + nu*nu - 2*nu*sqrtX, (sqrtX-nu)**2)
    slope = sp.Symbol("slope", nonnegative=True)
    identity("normalized_gradient_unbounded_slope",
             4*(1+slope*slope/4)-slope*slope, 4)

    X, t, tau, bb, B, omega = sp.symbols(
        "X t tau bb B omega", nonnegative=True)
    identity("zero_set_low_clear_denominator",
             omega*(X+t)-t*bb, omega*X+(omega-bb)*t)
    identity("zero_set_high_clear_denominator",
             B*t*(X+t)-bb*t*tau,
             t*(B*(X-tau)+B*t+(B-bb)*tau))
    sx, sB, sw = sp.symbols("sx sB sw", nonnegative=True)
    nonnegative("zero_set_low_positive",
                (omega*(X+t)-t*bb).subs(omega, bb+sw), (bb, sw, X, t))
    nonnegative("zero_set_high_positive",
                (B*t*(X+t)-bb*t*tau).subs({X: tau+sx, B: bb+sB}),
                (bb, sB, t, tau, sx))

    c, T, M, b, eps = sp.symbols("c T M b eps", nonnegative=True)
    target = coefficient("target_margin_fraction")
    high_left = c*X-eps*(X+t)-2*M*t-target*b*t
    high_right = (
        (c/2-eps)*X + (b/4-eps)*t + c/2*(X-T*t)
    )
    threshold_relation = c*T - coefficient("threshold_M")*M - coefficient(
        "threshold_b")*b
    identity("high_regime_threshold_identity",
             4*(high_left-high_right), 2*t*threshold_relation)
    identity("low_regime_surplus", b*t/2+(c-eps)*X-eps*t-target*b*t,
             (c-eps)*X+(b/4-eps)*t)
    cs, bs, excessX = sp.symbols("cs bs excessX", nonnegative=True)
    substitutions = {c: 2*eps+cs, b: 4*eps+bs}
    high = high_left.subs(T, (4*M+b)/c).subs(X, (4*M+b)/c*t+excessX)
    nonnegative("high_regime_universal_positive",
                sp.cancel(4*c*high).subs(substitutions, simultaneous=True),
                (eps, cs, bs, M, t, excessX))
    nonnegative("low_regime_universal_positive",
                ((c-eps)*X+(b/4-eps)*t).subs(substitutions, simultaneous=True),
                (eps, cs, bs, X, t))
    identity("rotation_budget",
             coefficient("rotation_cost_factor")
             * coefficient("rotation_relative_budget"), sp.Rational(1, 2))
    identity("old_margin_conversion",
             coefficient("old_margin_factor") * target, sp.Rational(1, 8))

    K, Cp, alpha_s, nt = sp.symbols("K Cp alpha_s nt", nonnegative=True)
    identity("repeat_preparation_absorption",
             Cp*alpha_s-K-2*Cp*nt,
             (Cp*alpha_s/2-K)+2*Cp*(alpha_s/4-nt))
    eta = sp.Symbol("eta", positive=True)
    require(coefficient("W_minus_one_per_eta") > coefficient("packing_slack"),
            "packing cannot have the required slack")
    require(coefficient("packing_slack")-1 == coefficient("annular_slack"),
            "annulus loss mismatch")
    require(coefficient("annular_slack")-1 == coefficient("inner_slack"),
            "parent cutoff loss mismatch")
    require(coefficient("inner_slack")-1 == coefficient("selected_mass_slack"),
            "closed-child loss mismatch")
    ratio = (1+coefficient("selected_mass_slack")*eta) / (
        1+coefficient("old_mass_slack")*eta)
    zeta = coefficient("zeta_numerator")*eta/(1+eta)
    identity("entire_parent_mass_gain",
             sp.cancel((1+eta)*(ratio-1-zeta)), eta)

    L = sp.Symbol("L", positive=True)
    rho = coefficient("dominance_midpoint")*(1+L)
    dmax = coefficient("dominance_error_fraction")*(L-1)/(L+3)
    identity("selected_gradient_strict_dominance",
             sp.cancel(L-dmax-rho*(1+dmax)), (L-1)/4)
    dominance_slack, Lminus = sp.symbols(
        "dominance_slack Lminus", nonnegative=True)
    nonnegative(
        "selected_gradient_dominance_uniform",
        sp.cancel(L-(dmax-dominance_slack)
                  -rho*(1+dmax-dominance_slack)).subs(L, 1+Lminus),
        (dominance_slack, Lminus),
    )

    j, cut = sp.symbols("j cut", nonnegative=True)
    identity("increment_nu_exponent", 2-cut-2*(j-cut), 2*(1-j)+cut)
    identity("increment_S_exponent", 1-cut-(j-cut), 1-j)
    N, S = sp.symbols("N S", positive=True)
    identity("exact_child_partition", sp.cancel((S/N)/(S/N**3)), N*N)
    A, B0, H0 = sp.symbols("A B0 H0", nonnegative=True)
    Cstar = B0+A+1+H0
    identity("all_order_exponent_surplus",
             Cstar*(j+1)-(B0+(j-1)*A+1),
             B0*j+2*A+j+H0*(j+1))
    nonnegative("all_positive_derivative_orders", B0*j+2*A+j+H0*(j+1),
                (A, B0, H0, j))
    nonnegative("zeroth_derivative_order", Cstar-(B0+1), (A, H0))
    require(coefficient("delta") == sp.Rational(1, 1000000),
            "wrong prescribed envelope delta")
    seed_a, seed_t = sp.symbols("seed_a seed_t", nonnegative=True)
    identity("seed_gradient_bound",
             seed_a**2-4*seed_a**2*seed_t*(1-seed_t),
             seed_a**2*(2*seed_t-1)**2)
    identity("seed_test_margin",
             seed_a/2-2*seed_a**3-seed_a/4,
             2*seed_a*(sp.Rational(1, 8)-seed_a**2))

    jac = CERT["jacobian"]
    payload = json.loads((HERE / jac["payload"]).read_text())
    output = json.loads((HERE / jac["output"]).read_text())
    execution = json.loads((HERE / jac["execution"]).read_text())
    contract = json.loads((HERE / jac["contract"]).read_text())
    require(execution["adapter_exit_code"] == 0, "Jacobian adapter failed")
    require(execution["adapter_error"] is None, "Jacobian adapter error recorded")
    require(execution["timeout_status"] == "not_timed_out",
            "Jacobian timeout is not evidence")
    require((HERE / execution["stderr_file"]).read_text() == "",
            "Jacobian adapter wrote diagnostic output requiring inspection")
    require(execution["operation_id"] == jac["operation_id"], "wrong operation")
    require(output["server"]["version"] == contract["server_version"],
            "Jacobian server version differs from inspected contract")
    require(output["protocol_version"] == contract["protocol_version"],
            "Jacobian protocol mismatch")
    require(output["request"]["operation_id"] == jac["operation_id"],
            "Jacobian output names another operation")
    require(output["request"]["payload"] == payload, "Jacobian input mismatch")
    result = output["result"]
    require(result["operation_id"] == jac["operation_id"], "wrong result type")
    typed = result["output"]
    require(typed["request"] == payload, "typed output is not source-bound")
    require(typed["outcome"] == jac["expected_outcome"] == "COMPUTED",
            "incomplete Jacobian output is not evidence")
    require(typed["detail"] is None, "Jacobian reports a diagnostic")
    require(typed["in_ideal"] is True, "Jacobian did not certify membership")
    require(typed["remainder"]["polynomial"]["terms"] == [],
            "Jacobian remainder is nonzero")
    polynomial, variables = decode_polynomial(payload["polynomial"])
    require(tuple(str(v) for v in variables) == ("c", "T", "M", "b", "t"),
            "wrong Jacobian polynomial ring")
    jc, jT, jM, jb, jt = variables
    identity("jacobian_payload_is_the_proved_identity", polynomial,
             2*jt*(jc*jT-4*jM-jb))
    generators = payload["ideal"]["generators"]
    require(len(generators) == 1, "unexpected ideal presentation")
    generator, generator_variables = decode_polynomial(generators[0])
    require(generator_variables == variables, "ideal ring mismatch")
    identity("jacobian_generator_is_threshold", generator, jc*jT-4*jM-jb)
    quotient, remainder = sp.div(polynomial, generator, *variables)
    identity("independent_jacobian_remainder", remainder)
    identity("independent_jacobian_quotient", quotient, 2*jt)

    print(json.dumps({
        "ok": True,
        "check_count": len(CHECKS),
        "checks": CHECKS,
        "universal_algebra": True,
        "sampling_used": False,
        "jacobian_outcome": typed["outcome"],
        "jacobian_adapter_exit_code": execution["adapter_exit_code"],
        "jacobian_runtime_ms": result["runtime_ms"],
        "analytic_proof": str(HERE / CERT["proof"]),
        "full_machine_formalization": False,
        "independent_review": CERT["independent_review"],
        "novelty_status": CERT["novelty_status"],
        "not_certified": CERT["not_certified"],
    }, indent=2))


if __name__ == "__main__":
    main()
