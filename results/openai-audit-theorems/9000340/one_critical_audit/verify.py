#!/usr/bin/env python3
"""Exact analytic calculations for proof.tex; no machine-checked topology."""

import argparse
from copy import deepcopy
from fractions import Fraction
from itertools import product
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OPERATION = "polynomial.box.enclosure.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(expression, message):
    require(sp.simplify(expression) == 0, message)


def rational(value):
    number = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(number.numerator) == value["num"]
        and str(number.denominator) == value["den"],
        "Noncanonical rational in Jacobian evidence",
    )
    return number


def exact_calculations():
    x, y = sp.symbols("x y", real=True)
    a, A, L = sp.symbols("a A L", positive=True)
    r = sp.sqrt(x**2 + y**2)
    t, lam, s = sp.symbols("t lam s", real=True)
    chi, remainder = sp.Function("chi"), sp.Function("R")
    q = -x**2 + y**2
    modified = q + (1 - t * chi(r / a)) * remainder(x, y)
    for w in (x, y):
        expected = (
            sp.diff(q, w)
            + (1 - t * chi(r / a)) * sp.diff(remainder(x, y), w)
            - t * remainder(x, y) * sp.diff(chi(r / a), w)
        )
        zero(sp.diff(modified, w) - expected, "Taylor cutoff chain rule")
    zero(sum(sp.diff(r, w) ** 2 for w in (x, y)) - 1, "Radial covector norm")
    C_chi, K0, K1, V = sp.symbols("C_chi K0 K1 V", nonnegative=True)
    rr = sp.symbols("r", positive=True)
    cutoff_error = K1 * rr**2 + C_chi * K0 * rr**3 / a
    taylor_bound = (K1 + 2 * C_chi * K0) * rr**2
    zero(
        taylor_bound - cutoff_error - C_chi * K0 * rr**2 * (2 - rr / a),
        "Taylor cutoff error remainder on r<=2a",
    )
    translation_error = V * C_chi / A
    zero(
        (sp.symbols("c") * A - translation_error) / A
        - (sp.symbols("c") - V * C_chi / A**2),
        "Critical-value cutoff error scale",
    )
    local = {
        "translation_error": str(translation_error),
        "taylor_coefficient": str(sp.expand(K1 + 2 * C_chi * K0)),
        "sufficient_small_radius_numerator": str(4 * a * (K1 + 2 * C_chi * K0)),
        "retained_gradient_fraction": "1/2",
    }

    H, sigma = sp.Function("H"), sp.Function("sigma")
    inserted = H(x, y, lam * sigma(r))
    for index, w in enumerate((x, y)):
        held_coordinate = sp.Dummy("held_coordinate")
        arguments = [x, y, lam * sigma(r)]
        arguments[index] = held_coordinate
        # Keep the substituted radial parameter fixed in this partial derivative.
        fixed_parameter = sp.Subs(
            sp.diff(H(*arguments), held_coordinate), held_coordinate, w
        )
        parameter_error = (
            sp.diff(H(x, y, s), s).subs(s, lam * sigma(r))
            * lam
            * sp.diff(sigma(r), w)
        )
        zero(
            sp.diff(inserted, w) - fixed_parameter - parameter_error,
            "Radial insertion must include its parameter derivative",
        )
    r0 = sp.symbols("r0", positive=True)
    zlog = (sp.log(rr) - sp.log(r0)) / L
    zero(rr * sp.diff(zlog, rr) - 1 / L, "Logarithmic cutoff scale")
    K, epsilon = sp.symbols("K epsilon", nonnegative=True)
    radial = {
        "parameter_error_multiplier": "1",
        "logarithmic_derivative_factor": str(1 / L),
        "gradient_error_per_radius": str(K * epsilon),
        "retained_gradient_fraction": "1/2",
    }

    mu, mup = sp.Function("mu"), sp.symbols("mup")
    handle_argument = x**2 + 2 * y**2
    handle = -x**2 + y**2 - mu(handle_argument)
    derivative = sp.diff(mu(s), s).subs(s, handle_argument)
    hx = sp.cancel(sp.diff(handle, x) / x).xreplace({derivative: mup})
    hy = sp.cancel(sp.diff(handle, y) / y).xreplace({derivative: mup})
    zero(hx + 2 * (1 + mup), "Negative handle derivative")
    zero(hy - 2 * (1 - 2 * mup), "Positive handle derivative")
    mu_interval = (sp.Rational(-3, 4), sp.Rational(0))
    x_margin = min(-hx.subs(mup, endpoint) for endpoint in mu_interval)
    y_margin = min(hy.subs(mup, endpoint) for endpoint in mu_interval)
    require(x_margin > 0 and y_margin > 0, "Degenerate modified handle")
    local_handle = {
        "negative_derivative_multiplier": str(sp.expand(hx)),
        "positive_derivative_multiplier": str(sp.expand(hy)),
        "mu_prime_interval": [str(v) for v in mu_interval],
        "negative_absolute_margin": str(x_margin),
        "positive_margin": str(y_margin),
        "mu_zero_over_delta_lower_bound": str(sp.Rational(3, 4) * sp.Rational(3, 2)),
    }

    b = sp.symbols("b", positive=True)
    R = sp.sqrt(a**2 + b**2)
    ratio = a / R
    ratio_norm_squared = sum(sp.diff(ratio, v) ** 2 for v in (a, b))
    zero(ratio_norm_squared - b**2 / R**4, "Angular ratio derivative")
    zero(
        1 / R**2 - ratio_norm_squared - a**2 / R**4,
        "Angular ratio derivative upper bound",
    )
    H0, H1, K_rho, eta = sp.symbols("H0 H1 K_rho eta", positive=True)
    D0 = sp.simplify(H0 * (2 * eta * rr) ** 2 / (eta**2 * rr**2))
    D1 = sp.simplify(
        (H1 * 2 * eta * rr + H0 * (2 * eta * rr) ** 2 * K_rho / eta / rr)
        / (eta * rr)
    )
    angular = {
        "ratio_gradient_norm_squared": str(sp.factor(ratio_norm_squared)),
        "value_error_coefficient": str(D0),
        "gradient_error_coefficient": str(sp.expand(D1)),
    }

    F, G, alpha = sp.Function("F"), sp.Function("G"), sp.Function("alpha")
    blend = (1 - t * alpha(rr / A)) * F(rr) + t * alpha(rr / A) * G(rr)
    blend_derivative = (
        (1 - t * alpha(rr / A)) * sp.diff(F(rr), rr)
        + t * alpha(rr / A) * sp.diff(G(rr), rr)
        + t * sp.diff(alpha(rr / A), rr) * (G(rr) - F(rr))
    )
    zero(sp.diff(blend, rr) - blend_derivative, "Annular blending chain rule")
    G0 = sp.Function("G0")(rr)
    leading_reference = (1 - t) * G0 + t * G(rr)
    reference_error = (
        (1 - t * alpha(rr / A)) * (F(rr) - G0)
        + t * (alpha(rr / A) - 1) * (G(rr) - G0)
    )
    zero(blend - leading_reference - reference_error, "Controlled homogeneous reference")
    exterior_error = sp.expand(reference_error.subs(alpha(rr / A), 1))
    exterior_coefficient = exterior_error.coeff(F(rr))
    zero(
        exterior_error - exterior_coefficient * (F(rr) - G0),
        "Exterior reference error must remain bounded",
    )
    d0, d1, M0, M1, K_alpha = sp.symbols("D0 D1 M0 M1 K_alpha", nonnegative=True)
    annular_exact = M1 / (A * t) + d1 * eta + K_alpha * M0 / (A**2 * t)
    annular_exact += K_alpha * d0 * eta**2 * t
    annular_terms = [
        M1 / A,
        d1 * eta,
        K_alpha * M0 / A**2,
        2 * K_alpha * d0 * eta**2,
    ]
    nonnegative_remainder = (
        (M1 / A + K_alpha * M0 / A**2) * (t - 1) / t
        + K_alpha * d0 * eta**2 * (2 - t)
    )
    zero(
        sum(annular_terms) - annular_exact - nonnegative_remainder,
        "Transition bound must include both cutoff-error terms",
    )
    transition = {
        "radius_ratio_interval": ["1", "2"],
        "normalized_error_terms": [str(term) for term in annular_terms],
        "critical_radius_bound": "M1/c_star",
        "exterior_reference_error_coefficient": str(
            exterior_coefficient.subs(t, sp.Symbol("tau"))
        ),
    }
    e = sp.symbols("e1:5")
    margin = 1 - sum(e)
    cap = sp.Rational(1, 8)
    endpoint_values = [
        margin.subs(dict(zip(e, corner)))
        for corner in product((sp.Rational(0), cap), repeat=4)
    ]
    require(sp.Poly(margin, *e).total_degree() == 1, "Non-affine error budget")
    margin_interval = min(endpoint_values), max(endpoint_values)
    require(margin_interval[0] > 0, "No positive gradient margin")
    budget = {
        "per_term_cap": str(cap),
        "normalized_gradient_margin": str(margin),
        "range": [str(v) for v in margin_interval],
    }

    w, z, u = sp.symbols("w z u", real=True)
    low_c = sp.expand((2 * t) ** 2 * w**2 + 4 * z**2 - (2 * t) ** 2 * (w**2 + z**2))
    high_c = sp.expand((2 + u) ** 2 * w**2 + 4 * z**2 - 4 * (w**2 + z**2))
    zero(low_c - 4 * (1 - t**2) * z**2, "Block gradient bound for c<=2")
    zero(high_c - u * (u + 4) * w**2, "Block gradient bound for c>=2")
    block = {
        "c_le_2_remainder": str(low_c),
        "c_ge_2_remainder": str(high_c),
        "positive_squares": 10,
        "missing_negative_squares": 10,
        "type_after_positive": ["p", "p + 10"],
        "type_at_diagonal": ["p + 10", "p + 10"],
    }

    z1, z2 = sp.symbols("z1 z2")
    a11, a12, a21, a22 = sp.symbols("a11 a12 a21 a22")
    b1, b2, b3, b4, c1, c2 = sp.symbols("b1 b2 b3 b4 c1 c2")
    normal = [
        a11 * z1 + a12 * z2 + b1 * z1**2 + b2 * z1 * z2 + c1 * z2**3,
        a21 * z1 + a22 * z2 + b3 * z1 * z2 + b4 * z2**2 + c2 * z1**3,
    ]
    scaled = [
        sp.cancel(v.subs({z1: t * z1, z2: t * z2}, simultaneous=True) / t)
        for v in normal
    ]
    limit = [sp.limit(v, t, 0) for v in scaled]
    for original, result in zip(normal, limit):
        zero(
            result - sum(
                sp.diff(original, zj).subs({z1: 0, z2: 0}) * zj
                for zj in (z1, z2)
            ),
            "Normal linearization Taylor-jet limit",
        )
    for degree in (1, 2, 3):
        zero((t * z1) ** degree / t - t ** (degree - 1) * z1**degree,
             "Normal Taylor-jet scaling")
    normal_jet = {
        "degree": 3,
        "limit": [str(v) for v in limit],
        "quadratic_scale": "t",
        "cubic_scale": "t**2",
        "scope": "Polynomial Taylor jet only; smooth bundle extension is a prose proof.",
    }

    u, v = sp.symbols("u v", nonnegative=True)
    k = 20 + u
    ell = k + 10 + v
    m, N, parameter_dimension = k - 1, k + ell - 1, 10
    dimension_margins = {
        "map_nullhomotopy_gap": sp.expand(N - (9 + m)),
        "same_parameter_double_point_gap": sp.expand(N - (parameter_dimension + 2 * m)),
        "vertical_rank_defect_gap": sp.expand((N - m + 1) - (parameter_dimension + m)),
        "full_multijet_equal_parameter_gap": sp.expand(
            parameter_dimension + N - 2 * (parameter_dimension + m)
        ),
        "Grassmannian_pi9_isomorphism_gap": sp.expand(k - 9),
        "zero_band_stability_gap": sp.expand(k + ell - 2 - max(2 * 10 + 8, 3 * 10 + 5)),
        "stable_extension_pi9_isomorphism_gap": sp.expand(k - 2 - 9),
    }
    for name, expression in dimension_margins.items():
        polynomial = sp.Poly(expression, u, v)
        require(all(c >= 0 for c in polynomial.coeffs()), name + ": negative coefficient")
        require(expression.subs({u: 0, v: 0}) > 0, name + ": missing strict margin")
    dimensions = {
        "p_minimum": 20,
        "parameter_dimension_including_time": parameter_dimension,
        "substitution": ["k = 20 + u", "l = k + 10 + v", "u,v >= 0"],
        "strict_margins": {name: str(value) for name, value in dimension_margins.items()},
        "wrong_unrestricted_double_point_gap": str(sp.expand(N - 2 * (parameter_dimension + m))),
    }
    return {
        "local_cutoffs": local,
        "radial_insertion": radial,
        "local_handle": local_handle,
        "angular_smoothing": angular,
        "transition_annulus": transition,
        "error_budget": budget,
        "orthogonal_stabilization": block,
        "normal_linearization_jet": normal_jet,
        "dimension_thresholds": dimensions,
    }


def verify_jacobian(payload, envelope, status, certificate):
    require(certificate["jacobian"]["operation_id"] == OPERATION, "Wrong declared operation")
    require(status["exit_code"] == 0, "Jacobian adapter failed")
    require(status["timed_out"] is False, "Jacobian timeout is not evidence")
    require(status["structured_error"] is None, "Jacobian returned a structured error")
    require(envelope.get("error") is None, "Jacobian error envelope")
    require(envelope["tool"] == "math.run", "Not an executed operation")
    require(envelope["protocol_version"] == certificate["jacobian"]["protocol_version"],
            "Protocol version mismatch")
    require(envelope["server"]["version"] == certificate["jacobian"]["server_version"],
            "Server version mismatch")
    request, result = envelope["request"], envelope["result"]
    require(request["operation_id"] == OPERATION == result["operation_id"],
            "Wrong Jacobian operation")
    require(request["payload"] == payload, "Adapter request does not match the retained payload")
    output = result["output"]
    require(output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"],
            "Typed result is not bound to the exact polynomial and box")
    require(payload["polynomial"]["domain"] == payload["box"]["domain"] == "QQ",
            "Not exact rational input")
    variables = payload["polynomial"]["variables"]
    require(variables == payload["box"]["variables"] == ["e1", "e2", "e3", "e4"],
            "Incorrect error-budget variables")
    symbols = sp.symbols("e1:5")
    polynomial = sp.Rational(0)
    previous = None
    intervals = []
    for interval in payload["box"]["intervals"]:
        lower, upper = rational(interval["lower"]), rational(interval["upper"])
        require((lower, upper) == (Fraction(0), Fraction(1, 8)), "Wrong normalized error box")
        intervals.append((lower, upper))
    require(len(intervals) == 4, "Incomplete error box")
    enclosure = [Fraction(0), Fraction(0)]
    for term in payload["polynomial"]["polynomial"]["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == 4 and all(type(e) is int and e >= 0 for e in exponents),
                "Invalid polynomial exponent")
        require(previous is None or tuple(exponents) < previous, "Noncanonical monomial order")
        previous = tuple(exponents)
        coefficient = rational(term["coefficient"])
        require(coefficient != 0, "Zero sparse coefficient")
        polynomial += sp.Rational(coefficient.numerator, coefficient.denominator) * sp.prod(
            variable**exponent for variable, exponent in zip(symbols, exponents)
        )
        term_bounds = [coefficient, coefficient]
        for interval, exponent in zip(intervals, exponents):
            powers = (interval[0] ** exponent, interval[1] ** exponent)
            products = [a * b for a in term_bounds for b in powers]
            term_bounds = [min(products), max(products)]
        enclosure = [enclosure[i] + term_bounds[i] for i in (0, 1)]
    zero(polynomial - (1 - sum(symbols)), "Jacobian polynomial is not the analytic margin")
    returned = [rational(output["enclosure"][side]) for side in ("lower", "upper")]
    require(returned == enclosure == [Fraction(1, 2), Fraction(1)], "Wrong enclosure")
    corner_values = [
        polynomial.subs(dict(zip(symbols, corner)))
        for corner in product((sp.Rational(0), sp.Rational(1, 8)), repeat=4)
    ]
    require(min(corner_values) == sp.Rational(1, 2) and max(corner_values) == 1,
            "Enclosure endpoints are not attained")


def verify_certificate(certificate, calculations, payload, output, status):
    require(certificate["kind"] == "exact_calculations_supporting_prose",
            "Certificate must not claim formal topological verification")
    require(certificate["claim"] == "OC-exact-calculations", "Wrong machine-checked claim")
    require(certificate["topology_machine_verified"] is False, "Topology is not machine verified")
    require(certificate["calculations"] == calculations, "Declared calculation differs from exact replay")
    require(
        certificate["outside_machine_claims"] == [
            "Negative sphere bundle fiber homotopy equivalence",
            "Adams J_8 injectivity and finite Grassmannian topology",
            "Accepted zero-band family product theorem",
            "Relative multijet transversality and uniform normal neighborhoods",
            "Smooth bundle linearization and the complete one-critical proposition",
        ],
        "Missing or changed topological evidence boundary",
    )
    verify_jacobian(payload, output, status, certificate)


def mutation_tests(certificate, calculations, payload, output, status):
    mutations = [
        (("calculations", "local_cutoffs", "taylor_coefficient"), "K1"),
        (("calculations", "radial_insertion", "parameter_error_multiplier"), "0"),
        (("calculations", "local_handle", "negative_derivative_multiplier"), "2*mup + 2"),
        (("calculations", "angular_smoothing", "gradient_error_coefficient"), "2*H1"),
        (("calculations", "transition_annulus", "normalized_error_terms"),
         ["M1/A", "D1*eta"]),
        (("calculations", "error_budget", "per_term_cap"), "1/2"),
        (("calculations", "normal_linearization_jet", "cubic_scale"), "t"),
        (("calculations", "dimension_thresholds", "parameter_dimension_including_time"), 9),
        (("calculations", "dimension_thresholds", "strict_margins",
          "same_parameter_double_point_gap"), "v + 2"),
        (("topology_machine_verified",), True),
    ]
    rejected = 0
    for path, replacement in mutations:
        changed = deepcopy(certificate)
        parent = changed
        for key in path[:-1]:
            parent = parent[key]
        parent[path[-1]] = replacement
        try:
            verify_certificate(changed, calculations, payload, output, status)
        except ValueError:
            rejected += 1
        else:
            raise ValueError("Substantive certificate mutation was accepted: " + ".".join(path))
    changed_source = deepcopy(output)
    changed_source["result"]["output"]["polynomial"]["polynomial"]["terms"][0]["coefficient"]["num"] = "1"
    changed_bound = deepcopy(output)
    changed_bound["result"]["output"]["enclosure"]["lower"] = {"num": "3", "den": "4"}
    timed_out = deepcopy(status)
    timed_out["timed_out"] = True
    for changed_output, changed_status in (
        (changed_source, status), (changed_bound, status), (output, timed_out)
    ):
        try:
            verify_certificate(certificate, calculations, payload, changed_output, changed_status)
        except ValueError:
            rejected += 1
        else:
            raise ValueError("Invalid Jacobian evidence was accepted")
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", type=Path, default=HERE / "exact_certificate.json")
    parser.add_argument("--self-test", action="store_true", help="Reject substantive in-memory mutations")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    calculations = exact_calculations()
    verify_certificate(certificate, calculations, payload, output, status)
    rejected = mutation_tests(certificate, calculations, payload, output, status) if args.self_test else 0
    print(json.dumps({
        "result": "PASS",
        "claim": certificate["claim"],
        "exact_check_groups": len(calculations) + 1,
        "substantive_mutations_rejected": rejected,
        "jacobian_enclosure": ["1/2", "1"],
        "topology_machine_verified": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
