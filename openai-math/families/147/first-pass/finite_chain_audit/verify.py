#!/usr/bin/env python3
"""Exact algebraic replay for the local finite-chain isolation report.

The analytic proof is in report.md. Finite chain examples below are not an
exhaustive verification of the arbitrary-length analytic theorem.
"""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
HALF = sp.Rational(1, 2)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(results, name, expression):
    residual = sp.cancel(sp.expand(expression))
    require(residual == 0, f"{name}: nonzero exact residual {residual}")
    results[name] = "0"


def edge_identities(results):
    s, v, r, q, g = sp.symbols("s v r q g", nonzero=True)
    h0, h1, h2 = sp.symbols("h0 h1 h2")
    line = 2 * (h0 + h1 * s / 2 + h2 * s**2 / 8) * (s / 2 - s**3 / 48)
    integral = h0 * s + h1 * s**2 / 2 + h2 * s**3 / 6
    zero(results, "support_cubic", sp.expand(line - integral).coeff(s, 3) + (h0 + h2) / 24)

    def normalized_sqrt_jet(increment):
        return 1 + increment / (2 * g) - increment**2 / (8 * g**2)

    tau = sp.Symbol("tau")
    chord = s * normalized_sqrt_jet((v + r * s / 2 + q * s**2 / 6) ** 2 - v**2)
    arc = sp.integrate(
        normalized_sqrt_jet((v + r * tau + q * tau**2 / 2) ** 2 - v**2),
        (tau, 0, s),
    )
    cubic = sp.expand(chord - arc).coeff(s, 3)
    zero(results, "graph_chord_minus_arc_cubic", (cubic + r**2 / (24 * g**2)).subs(g, 1 + v**2))

    delta, z, u0, x, df0, df1 = sp.symbols("delta z u0 x df0 df1")
    baseline_slope = v + r * delta * (2 * u0 + z) / 2 + q * delta**2
    offset = delta**2 * x * (df0 + delta * df1)
    baseline = delta * z * normalized_sqrt_jet(baseline_slope**2 - v**2)
    perturbed = delta * z * normalized_sqrt_jet(
        (baseline_slope + offset / (delta * z)) ** 2 - v**2
    )
    remainder = sp.expand(perturbed - baseline - v * offset / g).coeff(delta, 3)
    expected = r * (2 * u0 + z) * x * df0 / 2 + x**2 * df0**2 / (2 * z)
    zero(results, "moving_vertical_offset_cubic", (g**2 * remainder - expected).subs(g, 1 + v**2))
    up, ui, un = sp.symbols("u_prev u_i u_next")
    zero(results, "summation_by_parts_vertex", (ui + up) - (un + ui) + (ui - up) + (un - ui))

    z, x, r, fa, fb, R, f = sp.symbols("z x r f_prev f_next R f", nonzero=True)
    line = -R * z**3 / 24 + x * f * z
    point = -r**2 * z**3 / 24 - r * x * (fa + fb) * z / 2 + x**2 * (fb - fa) ** 2 / (2 * z)
    multiplier = sp.diff(point, z)
    zero(results, "line_weighted_homogeneity", z * sp.diff(line, z) + 2 * x * sp.diff(line, x) - 3 * line)
    zero(results, "point_weighted_homogeneity", z * multiplier + 2 * x * sp.diff(point, x) - 3 * point)
    zero(results, "point_plus_square", (r * z / 2 + x * (fb - fa) / z) ** 2 + 2 * multiplier + 2 * r * x * fa)
    zero(results, "point_minus_square", (r * z / 2 - x * (fb - fa) / z) ** 2 + 2 * multiplier + 2 * r * x * fb)

    A, B, lam = sp.symbols("A B lambda")
    z = (A + B) / 2
    sum_rx_f = -2 * lam - r**2 * (A**2 + B**2) / 8
    x_delta_f = r * z * (A - B) / 4
    point_derivative = -r**2 * z**2 / 8 - sum_rx_f / 2 - x_delta_f**2 / (2 * z**2)
    point_value = -r**2 * z**3 / 24 - sum_rx_f * z / 2 + x_delta_f**2 / (2 * z)
    zero(results, "point_line_reduction_stationarity", point_derivative - lam)
    zero(results, "point_line_reduction_edge_value", point_value - lam * z - r**2 * (A**3 + B**3) / 24)
    line_vertex = -r**2 * A**3 / 24 + (lam + r**2 * A**2 / 8) * A
    zero(results, "point_line_reduction_vertex_value", line_vertex - lam * A - r**2 * A**3 / 12)


def geometric_sign(results):
    a, F, v, C, S, theta_a, theta_b = sp.symbols("a F v C S theta_a theta_b")
    p_a = C + v * S + (-a * S + F * C) * theta_a
    p_b = (-a * S + F * C) * theta_b
    mixed = (C + v * S) * theta_b
    zero(results, "point_mixed_area_positive_sign", p_a * theta_b - p_b * theta_a - mixed)
    shear = sp.Matrix([[1, HALF], [0, 1]])
    zero(results, "half_shift_preserves_area", shear.det() - 1)


def determinant_checks(results):
    n = sp.Symbol("n", integer=True, positive=True)
    zero(results, "dirichlet_determinant_induction", (n + 1) - 2 * n + (n - 1))
    rows = []
    for k in range(2, 9):
        D = sp.zeros(k - 1)
        for i in range(k - 1):
            D[i, i] = 2
            if i + 1 < k - 1:
                D[i, i + 1] = D[i + 1, i] = -1
        zero(results, f"dirichlet_k{k}", D.det() - k)

        slopes = [sp.Rational(2 * i + 1, 2 * k) for i in range(k)]
        V = sp.Matrix([[rho**j for rho in slopes] for j in range(k)])
        expected = sp.prod(slopes[j] - slopes[i] for i in range(k) for j in range(i + 1, k))
        line_det = V.det()
        zero(results, f"line_vandermonde_k{k}", line_det - expected)
        require(line_det != 0, f"line k={k}: degenerate limiting directions")

        m = k + 1
        avec = [sp.Rational(k - i, k) for i in range(1, k)]
        bvec = [sp.Rational(i, k) for i in range(1, k)]
        ratios = [b / a for a, b in zip(avec, bvec)]
        M = sp.Matrix([[a ** (m - j) * b**j for a, b in zip(avec, bvec)] for j in range(1, k)])
        expected = sp.prod(a**m * rho for a, rho in zip(avec, ratios))
        expected *= sp.prod(ratios[j] - ratios[i] for i in range(k - 1) for j in range(i + 1, k - 1))
        point_det = M.det()
        zero(results, f"point_mixed_vandermonde_k{k}", point_det - expected)
        require(point_det != 0, f"point k={k}: insufficient mixed components")

        average = sp.zeros(k)
        for i in range(k):
            average[i, i] += HALF
            average[i, (i - 1) % k] += HALF
        average_det = average.det()
        zero(results, f"cyclic_average_determinant_k{k}", average_det - sp.Rational(1 - (-1) ** k, 2**k))
        if k % 2 == 0:
            require(average_det == 0, "Even-chain averaging must not be assumed invertible")
        rows.append({
            "k": k,
            "dirichlet_determinant": str(D.det()),
            "line_vandermonde_determinant": str(line_det),
            "point_mixed_determinant": str(point_det),
            "cyclic_average_determinant": str(average_det),
        })
    return rows


def newton_checks(results):
    for k in range(2, 6):
        variables = sp.symbols(f"f0:{k}")
        elementary = [sp.Integer(1)] + [sp.symmetric_poly(j, *variables) for j in range(1, k + 1)]
        powers = [None] + [sum(f**j for f in variables) for j in range(1, k + 1)]
        for m in range(1, k + 1):
            residual = m * elementary[m] - sum(
                (-1) ** (j - 1) * elementary[m - j] * powers[j]
                for j in range(1, m + 1)
            )
            zero(results, f"newton_k{k}_degree{m}", residual)
    for m in range(1, 9):
        coefficient = sp.binomial(HALF, m)
        require(coefficient != 0, f"Vanishing square-root coefficient at degree {m}")
        zero(results, f"binomial_recurrence_degree{m}", sp.binomial(HALF, m + 1) - coefficient * (HALF - m) / (m + 1))


def decode_polynomial(encoded):
    variables = sp.symbols(" ".join(encoded["variables"]), seq=True)
    expression = 0
    require(encoded["domain"] == "QQ", "Nonrational adapter polynomial")
    for term in encoded["polynomial"]["terms"]:
        require(len(term["exponents"]) == len(variables), "Adapter exponent arity mismatch")
        rational = term["coefficient"]
        coefficient = sp.Rational(int(rational["num"]), int(rational["den"]))
        expression += coefficient * sp.prod(v**e for v, e in zip(variables, term["exponents"]))
    return sp.expand(expression)


def replay_adapter():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "polynomial.ideal.elimination.compute"
    require(response["protocol_version"] == "2025-11-25", "Unexpected preserved adapter protocol")
    require(response["server"]["version"] == "0.14.0", "Unexpected preserved Jacobian server")
    require(response["request"]["operation_id"] == operation, "Wrong adapter operation")
    require(response["request"]["payload"] == payload, "Adapter input does not match preserved payload")
    result = response["result"]
    require(result["operation_id"] == operation, "Wrong result operation")
    output = result["output"]
    require(output["outcome"] == "COMPUTED", f"Adapter outcome is not evidence: {output['outcome']}")
    require(output["detail"] is None, f"Adapter reported a detail/error: {output['detail']}")
    require(output["request"]["ideal"] == payload["ideal"], "Typed output refers to another ideal")
    require(output["eliminated_variables"] == payload["eliminated_variables"], "Elimination variables changed")
    ideal = payload["ideal"]
    require(ideal["variables"] == ["u", "f1", "f2", "f3"], "Wrong source ring")
    generators = [decode_polynomial(p) for p in ideal["generators"]]
    u, f1, f2, f3 = sp.symbols("u f1 f2 f3")
    expected = [f1 + f2 + f3, f1**2 + f2**2 + f3**2, f1**3 + f2**3 + f3**3, u * f1 - 1]
    require(generators == expected, "Payload is not the stated saturated power-sum problem")
    elimination = output["elimination_ideal"]
    require(elimination["variables"] == ["u"], "Wrong remaining ring")
    require([decode_polynomial(p) for p in elimination["generators"]] == [1], "Adapter did not return the unit ideal")
    replay = sp.groebner(generators, u, f1, f2, f3, order="lex")
    require([p.as_expr() for p in replay.polys] == [1], "Independent unit-ideal replay failed")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "outcome": output["outcome"],
        "structured_error": None,
        "adapter_cli_exit": 0,
        "recorded_runtime_ms": result["runtime_ms"],
        "independent_exact_groebner_basis": ["1"],
        "scope": "Three limiting profile coefficients; not an arbitrary-k analytic theorem.",
    }


def sharp_example(k, results):
    x, omega = sp.symbols("x omega")
    phi = sp.cyclotomic_poly(k, omega)

    def trunc(expression, order):
        terms = []
        for (degree,), coefficient in sp.Poly(sp.expand(expression), x).terms():
            if degree <= order:
                terms.append(sp.rem(coefficient, phi, omega) * x**degree)
        return sp.expand(sum(terms))

    def sqrt_one_plus(increment, order):
        total = sp.Integer(1)
        power = sp.Integer(1)
        for degree in range(1, order + 1):
            power = trunc(power * increment, order)
            total += sp.binomial(HALF, degree) * power
        return trunc(total, order)

    def inverse(series, order):
        constant = sp.expand(series).coeff(x, 0)
        require(constant == sp.Rational(1, k), f"k={k}: unexpected stationary step constant")
        increment = trunc((series - constant) / constant, order)
        total = sp.Integer(1)
        power = sp.Integer(1)
        for _ in range(order):
            power = trunc(-power * increment, order)
            total += power
        return trunc(total / constant, order)

    c = 8 * k**2
    v = sp.Integer(1)
    for degree in range(1, k + 1):
        constraint = trunc(sum(
            sqrt_one_plus(v - 1 + c * x * omega**i, degree)
            for i in range(k)
        ) - k, degree)
        correction = -sp.Rational(2, k) * constraint.coeff(x, degree)
        v = trunc(v + correction * x**degree, degree)
    steps = [sqrt_one_plus(v - 1 + c * x * omega**i, k) / k for i in range(k)]
    zero(results, f"sharp_line_sum_k{k}", trunc(sum(steps) - 1, k))
    multiplier = -v / (8 * k**2)
    line_value = 0
    for i, step in enumerate(steps):
        zero(results, f"sharp_line_stationarity_k{k}_edge{i}", trunc(-step**2 / 8 + x * omega**i - multiplier, k))
        line_value += trunc(-step**3 / 24 + x * omega**i * step, k)
    line_value = trunc(line_value, k)
    expected_line = sp.binomial(HALF, k) * c**k / (4 * k**2 * (3 - 2 * k))
    zero(results, f"sharp_line_constant_k{k}", line_value.coeff(x, 0) + sp.Rational(1, 24 * k**2))
    for degree in range(1, k):
        zero(results, f"sharp_line_lower_k{k}_degree{degree}", line_value.coeff(x, degree))
    zero(results, f"sharp_line_leading_k{k}", line_value.coeff(x, k) - expected_line)
    require(expected_line != 0, f"k={k}: line sharpness vanished")

    vertex_steps = [trunc(step.subs(x, -x), k) for step in steps]
    point_steps = [trunc((vertex_steps[(i - 1) % k] + vertex_steps[i % k]) / 2, k) for i in range(1, k + 1)]
    fvalues = [sp.rem(omega**i - 1, phi, omega) for i in range(k + 1)]
    require(fvalues[0] == 0 and fvalues[k] == 0, "Point endpoints were not fixed")
    point_multiplier = trunc(multiplier.subs(x, -x) + x, k)
    point_value = 0
    zero(results, f"sharp_point_sum_k{k}", trunc(sum(point_steps) - 1, k))
    for i, step in enumerate(point_steps, start=1):
        fa, fb = fvalues[i - 1], fvalues[i]
        inv = inverse(step, k)
        derivative = -step**2 / 8 - x * (fa + fb) / 2 - x**2 * (fb - fa) ** 2 * inv**2 / 2
        zero(results, f"sharp_point_stationarity_k{k}_edge{i}", trunc(derivative - point_multiplier, k))
        point_value += trunc(-step**3 / 24 - x * (fa + fb) * step / 2 + x**2 * (fb - fa) ** 2 * inv / 2, k)
    point_value = trunc(point_value, k)
    zero(results, f"sharp_point_line_value_identity_k{k}", point_value - trunc(line_value.subs(x, -x) + x, k))
    expected_point = (-1) ** k * expected_line
    require(expected_point != 0, f"k={k}: point sharpness vanished")
    zero(results, f"sharp_point_linear_k{k}", point_value.coeff(x, 1) - 1)
    for degree in range(2, k):
        zero(results, f"sharp_point_lower_k{k}_degree{degree}", point_value.coeff(x, degree))
    zero(results, f"sharp_point_leading_k{k}", point_value.coeff(x, k) - expected_point)
    powers = [str(sp.rem(sum(omega ** (i * m) for i in range(k)), phi, omega)) for m in range(1, k + 1)]
    require(powers == ["0"] * (k - 1) + [str(k)], f"k={k}: incorrect complex power sums")
    return {
        "k": k,
        "field": f"QQ[omega]/({phi})",
        "curvature": "1",
        "line_profile": "f_i=omega^i, 0<=i<k",
        "point_profile": "f_i=omega^i-1, 0<=i<=k",
        "line_value_coefficients_through_k": [str(line_value.coeff(x, i)) for i in range(k + 1)],
        "point_value_coefficients_through_k": [str(point_value.coeff(x, i)) for i in range(k + 1)],
        "power_sums_degrees_1_through_k": powers,
        "line_first_nonconstant_degree": k,
        "point_first_nonlinear_degree": k,
    }


def compute_certificate():
    residuals = {}
    edge_identities(residuals)
    geometric_sign(residuals)
    determinants = determinant_checks(residuals)
    newton_checks(residuals)
    adapter = replay_adapter()
    sharpness = [sharp_example(k, residuals) for k in range(2, 6)]
    return {
        "schema_version": 1,
        "claims": ["C147_FC_ISOLATION", "C147_MODEL_REDUCTION", "C147_SHARP_MODEL_OBSTRUCTION"],
        "result_kind": "Mathematical proof with exact symbolic replay",
        "proof_report": "report.md",
        "scope": {
            "analytic_theorem": "Every fixed k>=2; complete prose proof in report.md.",
            "exact_universal_reduction": "Parameter-free one-edge identities plus cyclic summation; no inverse averaging map is used.",
            "finite_replay_lengths": [2, 3, 4, 5],
            "determinant_replay_lengths": [2, 3, 4, 5, 6, 7, 8],
            "finite_replay_is_not_an_exhaustive_analytic_search": True,
            "uniform_endpoint_jet_order_claimed": False,
            "analytic_bridge_machine_checked": False,
            "lean_kernel_certified": False,
            "independent_reviewer_acceptance": False,
            "manuscript_refutation_established": False,
            "verified_new_novelty_claimed": False,
            "campaign_complete": False,
        },
        "arithmetic": "SymPy exact rational polynomial and cyclotomic quotient arithmetic; no floating point",
        "zero_residuals": residuals,
        "determinants": determinants,
        "jacobian": adapter,
        "complex_sharpness_examples": sharpness,
        "review_required": [
            "The exact hypotheses and quantifiers of Theorem 1 and the manuscript corollary",
            "Finite-core elimination and the formal-arc input",
            "Finite-web convergence and constant-coordinate edge extension",
            "Coefficientwise stationary scaling without full epsilon convergence",
            "Injective countable-field evaluation and the isolated-point scalar lemma",
            "Independent citation attribution, significance, and novelty assessment",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true", help="Write the computed exact certificate instead of comparing it.")
    args = parser.parse_args()
    computed = compute_certificate()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    else:
        stored = json.loads(certificate.read_text())
        require(stored == computed, "Persisted certificate differs from the exact replay")
    print(json.dumps({
        "ok": True,
        "zero_residuals": len(computed["zero_residuals"]),
        "complex_replay_lengths": computed["scope"]["finite_replay_lengths"],
        "jacobian_outcome": computed["jacobian"]["outcome"],
        "certificate": str(certificate),
        "independent_review": "required; not performed by this script",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
