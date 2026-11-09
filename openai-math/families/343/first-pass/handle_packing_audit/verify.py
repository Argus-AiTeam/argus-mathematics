#!/usr/bin/env python3
"""Replay exact algebra, not the analytic existence proof in construction.md."""

import argparse
import hashlib
import json
import math
import re
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "Symplectic-Ball-Packings-in-Higher-Dimensions-September-23-2026"
    / "build/sections/surface.tex"
)

SOURCE_EQUATIONS = {
    "surf:toric-volume": r"""
        (\omega_V+\dd\Gamma)^{m+1}
        =(m+1)\omega_V^m\wedge\dd_C\Gamma.
    """,
    "surf:annular-normal-form": r"""
        \dd_C\Gamma_1=\kappa_1,\qquad
        \Gamma_1|_A=\gamma+S(s)H_*(p)\beta .
    """,
    "surf:residual-gap": r"R_*(v)\geq g-3\varepsilon>0.",
    "surf:suspension": r"""
        D_\lambda^*\omega_V
        =\omega_V+\dd\bigl((Q_s^\lambda\circ q_s^\lambda)\,\dd s\bigr).
    """,
    "surf:one-covector": r"""
        \bigl(\dd\gamma+\omega_V+\dd(G\beta)\bigr)^{m+1}
        =(m+1)\omega_V^m\wedge
        \bigl(\dd\gamma+\partial_sG\,\dd s\wedge\beta\bigr).
    """,
    "surf:G-final": r"""
        G_{\rm f}(s,v)
        =J(v)+\sum_{i=1}^k\rho_i(s)h_i(p(v))+\rho_*(s)R_*(v).
    """,
    "surf:strip-coordinate": r"x=L+G_{\rm f}-a_i=L+\rho_i h_i .",
    "surf:product-sign": r"""
        \omega_V(v')=\omega_V(v)+\dd a_i\wedge\dd T .
    """,
    "surf:available-strip": r"""
        v'\in\Int(V),\qquad 0<T<1,\qquad 0<x<h_i(p(v')).
    """,
    "surf:thin-planar": r"0<x<w+\delta,\qquad 0<T<1.",
}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def equal(actual, expected, message):
    require(sp.simplify(actual - expected) == 0, message)


def add(*forms):
    result = {}
    for form in forms:
        for indices, coefficient in form.items():
            result[indices] = result.get(indices, 0) + coefficient
    return {
        indices: sp.expand(coefficient)
        for indices, coefficient in result.items()
        if sp.expand(coefficient) != 0
    }


def scale(coefficient, form):
    return add({indices: coefficient * value for indices, value in form.items()})


def wedge(left, right):
    result = {}
    for i, a in left.items():
        for j, b in right.items():
            if set(i).intersection(j):
                continue
            sign = (-1) ** sum(x > y for x in i for y in j)
            indices = tuple(sorted(i + j))
            result[indices] = result.get(indices, 0) + sign * a * b
    return add(result)


def power(form, exponent):
    result = {(): sp.Integer(1)}
    for _ in range(exponent):
        result = wedge(result, form)
    return result


def derivative(form, coordinates):
    result = {}
    for indices, coefficient in form.items():
        for i, coordinate in enumerate(coordinates):
            term = sp.diff(coefficient, coordinate)
            result = add(result, wedge({(i,): term}, {indices: 1}))
    return result


def differential(function, coordinates):
    return derivative({(): sp.sympify(function)}, coordinates)


def pullback(form, image, coordinates):
    substitutions = dict(zip(coordinates, image))
    result = {}
    for indices, coefficient in form.items():
        term = {(): sp.sympify(coefficient).subs(substitutions, simultaneous=True)}
        for i in indices:
            term = wedge(term, differential(image[i], coordinates))
        result = add(result, term)
    return result


def same_form(actual, expected, message):
    difference = add(actual, scale(-1, expected))
    require(
        all(sp.simplify(c) == 0 for c in difference.values()),
        message + ": " + str(difference),
    )


def omega(m):
    return {(2 * j, 2 * j + 1): sp.Integer(1) for j in range(m)}


def skew_matrix(form, dimension):
    result = sp.zeros(dimension)
    for (i, j), coefficient in form.items():
        result[i, j] = coefficient
        result[j, i] = -coefficient
    return result


def source_checks():
    text = SOURCE.read_text()
    compact = lambda value: re.sub(r"\s+", "", value)
    checked = {}
    for label, expected in SOURCE_EQUATIONS.items():
        match = re.search(
            r"\\begin\{equation\}\s*\\label\{" + re.escape(label)
            + r"\}(.*?)\\end\{equation\}",
            text,
            re.S,
        )
        require(match is not None, "Missing source equation: " + label)
        require(
            compact(match.group(1)) == compact(expected),
            "Source statement changed: " + label,
        )
        checked[label] = compact(match.group(1))
    return checked


def top_power_checks():
    results = []
    for m in range(1, 5):
        n = 2 * m + 2
        a = sp.Symbol("a")
        base = {(2 * m, 2 * m + 1): a}
        eta = sp.symbols(f"eta0:{2*m}")
        one_covector = {(j, 2 * m + 1): eta[j] for j in range(2 * m)}
        actual = power(add(omega(m), base, one_covector), m + 1)
        expected = {tuple(range(n)): math.factorial(m + 1) * a}
        same_form(actual, expected, f"One-covector top power, m={m}")
        aa = sp.symbols(f"A0:{m}")
        bb = sp.symbols(f"B0:{m}")
        mixed = add(
            {(2 * j, 2 * m): aa[j] for j in range(m)},
            {(2 * j, 2 * m + 1): bb[j] for j in range(m)},
        )
        same_form(
            power(add(omega(m), base, mixed), m + 1),
            expected,
            f"Toric top power, m={m}",
        )
        results.append({"m": m, "both_top_coefficients": str(expected[tuple(range(n))])})
    return results


def suspension_checks():
    x, y, s, t, lam = sp.symbols("x y s t lambda")
    coordinates = (x, y, s, t)
    S = 3 * s**2 - 2 * s**3
    cases = [
        ("translation", (x + s, y, s, t), -y),
        ("shear", (x, y + s * x, s, t), x**2 / 2),
        ("reparametrized_shear", (x, y + lam * S * x, s, t),
         lam * sp.diff(S, s) * x**2 / 2),
    ]
    for name, image, generator in cases:
        lhs = pullback(omega(1), image, coordinates)
        generator_pullback = generator.subs(
            dict(zip(coordinates, image)), simultaneous=True
        )
        correction = derivative({(2,): generator_pullback}, coordinates)
        same_form(lhs, add(omega(1), correction), name)
        require(
            any(sp.simplify(c) != 0 for c in add(lhs, scale(-1, add(
                omega(1), scale(-1, correction)
            ))).values()),
            "Wrong suspension sign was not detected: " + name,
        )

    image = cases[-1][1]
    generator = cases[-1][2]
    H = 1 + x**2 + y**2
    G = S * (1 + x**2 + (y - lam * x)**2)
    G_pullback = G.subs(dict(zip(coordinates, image)), simultaneous=True)
    primitive = {(2,): generator, (3,): s + G_pullback}
    path_form = add(omega(1), derivative(primitive, coordinates))
    same_form(
        path_form,
        add({(2, 3): 1}, pullback(
            add(omega(1), derivative({(3,): G}, coordinates)), image, coordinates
        )),
        "First-path primitive is the stated pullback",
    )
    curvature = 1 + sp.diff(S, s) * (
        1 + x**2 + (y + lam * (S - 1) * x)**2
    )
    same_form(
        power(path_form, 2), {(0, 1, 2, 3): 2 * curvature},
        "Angle-dependent first-path top power",
    )
    for endpoint, expected in [(0, 0), (1, H)]:
        equal(G_pullback.subs(s, endpoint), expected, "First-path end gluing")
        equal(generator.subs(s, endpoint), 0, "End suspension vanishes")
    return {
        "local_models": [case[0] for case in cases],
        "wrong_sign_detected_in_each": True,
        "angle_dependent_first_path": "exact",
        "positivity_reason": "1+6*s*(1-s)*(1+x^2+(y+lambda*(S-1)*x)^2)>0 for 0<=s<=1",
        "global_admissible_extension": {
            "construction": "Cut off shear Hamiltonian inside p<1/4, equal to shear on p<1/8, in V={p<=2}; choose H=10, K=p, r=(1/2,1/3), h_i=r_i+1/100.",
            "finite_gap_lower_bound": str(sp.Rational(10) - 2 - sp.Rational(64, 75)),
            "coverage": "The local shear germs are realized for sufficiently small initial p. Smooth cutoff existence and ODE continuation are analytic, not symbolically integrated.",
        },
    }


def shear_and_strip_checks():
    results = []
    for m in range(1, 4):
        p = sp.symbols(f"p0:{m}")
        theta = sp.symbols(f"theta0:{m}")
        x, T = sp.symbols("x T")
        coordinates = tuple(v for pair in zip(p, theta) for v in pair) + (x, T)
        a = sum(p[j] ** 3 / (j + 1) + p[j] for j in range(m))
        a += sum((j + l + 1) * p[j] * p[l] for j in range(m) for l in range(j))
        image = tuple(
            value
            for j in range(m)
            for value in (p[j], theta[j] + T * sp.diff(a, p[j]))
        ) + (x, T)
        correction = wedge(differential(a, coordinates), {(2 * m + 1,): 1})
        actual = pullback(omega(m), image, coordinates)
        same_form(actual, add(omega(m), correction), f"Toric shear, m={m}")
        require(
            add(actual, scale(-1, add(omega(m), scale(-1, correction)))) != {},
            "Wrong toric shear sign was not detected",
        )
        results.append(m)

    p, theta, s, T = sp.symbols("p theta s T")
    coordinates = (p, theta, s, T)
    L = 2 * s + s**3 / 3 + s * T**2
    rho = 3 * s**2 - 2 * s**3
    h = 2 + p**2
    a = p**3 + p
    x_coordinate = L + rho * h
    lhs = add(omega(1), derivative({(3,): L + a + rho * h}, coordinates))
    rhs = add(
        omega(1),
        wedge(differential(x_coordinate, coordinates), {(3,): 1}),
        wedge(differential(a, coordinates), {(3,): 1}),
    )
    same_form(lhs, rhs, "Strip-coordinate form")
    equal(sp.diff(x_coordinate, s), 2 + s**2 + T**2 + 6*s*(1-s)*h,
          "Strict strip derivative")
    equal(x_coordinate.subs(s, 0), 0, "Lower strip endpoint")
    equal(x_coordinate.subs(s, 1) - h, sp.Rational(7, 3) + T**2,
          "Upper strip slack")
    return {
        "polynomial_shear_dimensions": results,
        "wrong_shear_sign_detected": True,
        "strip_derivative": "2+s^2+T^2+6*s*(1-s)*(2+p^2)",
        "upper_endpoint_minus_h": "7/3+T^2",
    }


def boundary_checks():
    results = []
    cs, ct = sp.symbols("c_s c_t")
    for m in range(1, 4):
        form = add(
            omega(m), {(2*m, 2*m+1): 2},
            {(2*j, 2*m): j+1 for j in range(m)},
            {(2*j, 2*m+1): 2*j+1 for j in range(m)},
        )
        matrix = skew_matrix(form, 2*m+2)
        alpha = sp.Matrix([0] * (2*m) + [cs, ct])
        Y = matrix.T.inv() * (-alpha)
        require(all(Y[2*j] == 0 for j in range(m)), "Moser moment velocity")
        b = sp.symbols(f"b0:{m}")
        X = sp.Matrix([v for j in range(m) for v in (0, b[j])] + [0, 0])
        minus_dmu = sp.Matrix([v for j in range(m) for v in (-b[j], 0)] + [0, 0])
        require(matrix.T * X == minus_dmu, "Standard face Hamiltonian identity")
        equal((alpha.T * X)[0], 0, "Horizontal primitive on face Hamiltonian")
        if m == 2:
            active = sp.Matrix([[1, 0], [0, 1], [1, 1]])
            require(active * sp.Matrix([Y[0], Y[2]]) == sp.zeros(3, 1),
                    "Nonsimple redundant face intersection")
        results.append(m)
    return {
        "toric_local_dimensions": results,
        "redundant_active_faces": [[1, 0], [0, 1], [1, 1]],
        "universal_argument": "construction.md, part 4; the local tests do not establish the general flow theorem",
    }


def gluing_and_margin_checks():
    H, K, tau = sp.symbols("H K tau")
    equal((1-tau)*H + tau*K, H + tau*(K-H), "Upper-end global correction")
    eps = sp.Symbol("epsilon", positive=True)
    ge, ae, be, se = sp.symbols(
        "g_extra area_slack background_slack smoothing_slack", positive=True
    )
    gap_extra = sp.Symbol("gap_extra", nonnegative=True)
    g = 8*eps + ge
    R = (g + gap_extra) + (-eps + ae) - (eps - be) - (eps - se)
    expanded = 5*eps + ge + gap_extra + ae + be + se
    equal(R, expanded, "Exact residual margin")
    require(expanded.is_positive is True, "Residual positivity under named slacks")
    x = sp.Symbol("p")
    equal(sp.integrate(x-sp.Rational(1, 4), (x, 0, 1)), sp.Rational(1, 4),
          "Retired direct-stacking route")
    equal((x-sp.Rational(1, 4)).subs(x, 0), -sp.Rational(1, 4),
          "Direct-stacking obstruction")
    return {
        "upper_gluing": "(1-tau)*H+tau*K=H+tau*(K-H)",
        "residual": "R=5*epsilon+g_extra+gap_extra+area_slack+background_slack+smoothing_slack",
        "residual_strictly_positive": True,
        "ball_margin": "r_i-r_i_prime-delta>0",
        "retired_route": {"mean_P": "1/4", "P_at_zero": "-1/4"},
    }


def negative_control():
    x, y, s, t = sp.symbols("x y s t")
    coordinates = (x, y, s, t)
    Gamma = {(2,): x, (3,): y + s}
    form = add(omega(1), derivative(Gamma, coordinates))
    same_form(power(form, 2), {}, "Nontoric two-covector negative control")
    equal(skew_matrix(form, 4).det(), 0, "Degenerate negative-control determinant")
    return {
        "Gamma": "x ds+(y+s)dt",
        "base_curvature": "ds wedge dt",
        "top_power": "0",
        "is_manuscript_refutation": False,
        "excluded_hypothesis": "This primitive is neither toric nor of the single-vertical-covector form used before pullback.",
    }


def rectangle_checks():
    examples = []
    for A, delta in [(sp.Rational(1), sp.Rational(1, 4)),
                     (sp.Rational(2), sp.Rational(1, 10))]:
        mesh = delta / 8
        count = int(A / mesh) + 1
        epsilon = delta / (32 * (A + delta))
        previous = None
        margins = []
        for j in range(1, count + 1):
            h = j * mesh
            height = 1 - epsilon / (j + 1)
            width = h / height
            left = delta / (32 * (j + 1))
            right = left + width
            require(0 < height < 1 and left > 0, "Rectangle lies in open strip")
            equal(width * height, h, "Exact rectangle area")
            require(right < h + delta/2, "Rectangle radial-area bound")
            if previous is not None:
                old_left, old_right, old_height = previous
                require(left < old_left and right > old_right and height > old_height,
                        "Strict rectangle nesting")
                margins.extend([old_left-left, right-old_right, height-old_height])
            previous = left, right, height
        require(count * mesh > A and mesh < delta/4, "Planar grid covers closed disk")
        examples.append({
            "A": str(A), "delta": str(delta), "grid_count": count,
            "mesh": str(mesh), "minimum_nesting_margin": str(min(margins)),
        })
    return {
        "finite_exact_rectangular_examples": examples,
        "analytic_not_computational": "Superellipse smoothing, area correction, simultaneous Moser disk matching, and arbitrary A,delta are proved in construction.md, part 6.",
    }


def rational_function(value):
    variables = sp.symbols(" ".join(value["variables"]))
    if not isinstance(variables, tuple):
        variables = (variables,)

    def polynomial(data):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * sp.prod(v**e for v, e in zip(variables, term["exponents"]))
            for term in data["terms"]
        )

    return polynomial(value["numerator"]) / polynomial(value["denominator"])


def jacobian_check():
    payload = json.loads((HERE / "jacobian/payload.json").read_text())
    response = json.loads((HERE / "jacobian/output.json").read_text())
    require(response["request"]["payload"] == payload, "Jacobian exact payload differs")
    require(response["result"]["operation_id"] == "matrix.symbolic.determinant.compute",
            "Unexpected Jacobian operation")
    require("output" in response["result"] and "error" not in response,
            "Jacobian failure is not mathematical evidence")
    output = response["result"]["output"]
    a, b, c = sp.symbols("a b c")
    expected = sp.Matrix([[0, 1, 0, b], [-1, 0, 0, c],
                          [0, 0, 0, a], [-b, -c, -a, 0]])
    actual = sp.Matrix([[rational_function(v) for v in row]
                        for row in payload["matrix"]["entries"]])
    require(actual == expected, "Jacobian matrix does not encode the one-covector form")
    equal(actual.det(), a**2, "Independent determinant replay")
    equal(rational_function(output["determinant"]), a**2, "Typed Jacobian determinant")
    return {
        "operation_id": response["result"]["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "timeout": False,
        "determinant": "a^2",
        "interpretation": "Exact identity for m=1, not a proof for arbitrary m or the analytic construction.",
    }


def lean_check():
    result = json.loads((HERE / "lean/lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "A real successful compiler run is required")
    require(result["proof_holes"] == [], "Lean proof has holes")
    for filename, key in [("Main.lean", "source_sha256"),
                          ("statement_fidelity.md", "statement_fidelity_sha256")]:
        current = hashlib.sha256((HERE / "lean" / filename).read_bytes()).hexdigest()
        require(result[key] == current, "Stale Lean result: " + filename)
    require("4.31.0" in result["tools"]["lean"]["version"], "Lean 4.31.0 required")
    return {
        "claim": "C343_SQUARE_ZERO",
        "status": "success",
        "exit_code": 0,
        "proof_holes": [],
        "coverage": "Universal commutative-ring square-zero binomial and top-power identities only.",
    }


def certificate():
    return {
        "claim": "C343_HANDLE",
        "result_class": "conditional_verification_theorem",
        "theorem_artifact": "research/handle_packing_audit/construction.md",
        "universal_proof": "Finite profile realization theorem and its manuscript specialization; arbitrary m>=1, not finite extrapolation.",
        "source_equations": source_checks(),
        "top_powers": top_power_checks(),
        "suspension": suspension_checks(),
        "shear_and_strip": shear_and_strip_checks(),
        "boundary": boundary_checks(),
        "gluing_and_margins": gluing_and_margin_checks(),
        "negative_control": negative_control(),
        "planar": rectangle_checks(),
        "jacobian": jacobian_check(),
        "lean": lean_check(),
        "assumptions": [
            "Supplied comparison inequality, positive uniform gap, neighborhood isotopy, V preservation and time-uniform face commutation.",
            "Supplied finite models, handle exhaustion, uniform area convergence and auxiliary-simplex separation.",
            "Standard finite-dimensional smooth inverse-function and ODE theorems; construction-specific analytic arguments are in the report.",
        ],
        "not_certified": [
            "Existence of comparison data in cmp:comparison.",
            "The geometric model and transfer assertions or the three global sufficiency cases.",
            "Formal verification of the full analytic theorem.",
            "Verified-new literature novelty or publishable significance.",
            "Independent Reviewer approval.",
        ],
        "literal_manuscript_refutations": [],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    expected = json.loads(path.read_text())
    require(actual == expected, "Replayed calculations differ from exact_certificate.json")
    print(json.dumps({
        "replay": "passed",
        "claim": actual["claim"],
        "source_equations": len(actual["source_equations"]),
        "tested_top_power_dimensions": [item["m"] for item in actual["top_powers"]],
        "universal_square_zero_lean": actual["lean"]["status"],
        "analytic_proof": actual["theorem_artifact"],
        "independent_review": "required",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
