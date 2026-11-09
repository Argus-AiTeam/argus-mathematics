#!/usr/bin/env python3
"""Replay exact algebra only; the analytic theorem is proved in proof.md."""

import json
import re
from fractions import Fraction
from itertools import product
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, label):
    entries = list(expression) if isinstance(expression, sp.MatrixBase) else [expression]
    require(all(sp.cancel(entry) == 0 for entry in entries), label)


def read_json(relative):
    return json.loads((HERE / relative).read_text(encoding="utf-8"))


def rational_function(value, variables):
    require(value["domain"] == "QQ", "Jacobian coefficient domain")
    require(value["variables"] == [str(v) for v in variables], "Jacobian variable order")

    def polynomial(data):
        answer = sp.Integer(0)
        previous = None
        for term in data["terms"]:
            raw = term["coefficient"]
            require(
                all(re.fullmatch(r"0|-?[1-9][0-9]*", raw[k]) for k in ("num", "den")),
                "Noncanonical integer coefficient",
            )
            fraction = Fraction(int(raw["num"]), int(raw["den"]))
            require(
                fraction.numerator != 0
                and str(fraction.numerator) == raw["num"]
                and str(fraction.denominator) == raw["den"],
                "Noncanonical rational coefficient",
            )
            powers = term["exponents"]
            require(
                len(powers) == len(variables)
                and all(type(power) is int and power >= 0 for power in powers),
                "Invalid monomial exponents",
            )
            current = tuple(powers)
            require(previous is None or previous > current, "Unsorted or duplicate terms")
            previous = current
            monomial = sp.Rational(fraction.numerator, fraction.denominator)
            for variable, power in zip(variables, powers):
                monomial *= variable**power
            answer += monomial
        return answer

    numerator = polynomial(value["numerator"])
    denominator = polynomial(value["denominator"])
    require(denominator != 0, "Zero rational-function denominator")
    return sp.cancel(numerator / denominator)


def main():
    certificate = read_json("exact_certificate.json")
    require(certificate["schema_version"] == 1, "Certificate version")
    require(certificate["classification"]["is_manuscript_refutation"] is False, "Scope")
    require(
        certificate["classification"]["analytic_proof_machine_checked"] is False
        and certificate["classification"]["independent_review"] == "pending"
        and certificate["classification"]["campaign_complete"] is False,
        "Certificate must not claim analytic or independent certification",
    )
    source = HERE.parent.parent / certificate["source"]["path"]
    source_text = source.read_text(encoding="utf-8")
    for label in certificate["source"]["required_labels"]:
        require("\\label{" + label + "}" in source_text, "Missing source label: " + label)
    compact_source = re.sub(r"\s+", "", source_text)
    source_fragments = [
        r"\operatorname{curl}(a_1,a_2)=\partial_1a_2-\partial_2a_1",
        r"\nabla^\perp b=(-\partial_2b,\partial_1b)",
        r"\Delta p=\nabla^\perp\operatorname{curl}p.",
        r"v\in W^{1,2}(B_R\setminus H)\quad(R>0)",
        r"h\in W^{1,2}(\mathbb R^2\setminus A)",
        (r"0\leq 2\bigl(I_p(t)-I_p(0)\bigr)"
         r"+2\sigma\bigl(I_q(t)+\langle p,q\rangle_{L^2}\bigr)"
         r"+\sigma^2\|q\|_{L^2}^2."),
        r"I_q(t)=-\langle p,q\rangle_{L^2}",
    ]
    for fragment in source_fragments:
        require(re.sub(r"\s+", "", fragment) in compact_source,
                "The source's hypotheses or defining equations changed: " + fragment)

    checks = {}
    dx, dy, g1, g2, e1, e2 = sp.symbols("dx dy g1 g2 e1 e2")
    gradient = sp.Matrix([dx, dy])
    perpendicular = sp.Matrix([-dy, dx])
    laplacian = (dx**2 + dy**2) * sp.eye(2)
    zero(gradient * gradient.T + perpendicular * perpendicular.T - laplacian,
         "Hodge Laplacian symbol")
    zero((-perpendicular.T) + sp.Matrix([[-dy, dx]]), "Curl adjoint sign")
    checks["hodge_and_adjoint"] = True

    divergence_pair = (dx * g1 + dy * g2) * (dx * e1 + dy * e2)
    curl_pair = (dx * g2 - dy * g1) * (dx * e2 - dy * e1)
    zero(divergence_pair + curl_pair - (dx**2 + dy**2) * (g1 * e1 + g2 * e2),
         "Compact convolution div-curl identity")
    checks["compact_correlation_symbol"] = True

    x, y, tx, ty = sp.symbols("x y tx ty", real=True)
    translation_matrix = sp.Matrix([x - tx, y - ty]).jacobian([tx, ty])
    zero(translation_matrix + sp.eye(2), "Universal first-derivative translation symbol")
    jxx, jxy, jyy = sp.symbols("jxx jxy jyy")
    second_jet = sp.Matrix([[jxx, jxy], [jxy, jyy]])
    zero(sp.trace(translation_matrix.T * second_jet * translation_matrix)
         - sp.trace(second_jet), "Translation Laplacian for arbitrary second jets")
    a, b, c = sp.symbols("a b c")
    polynomial = a * x**3 * y + b * x * y**2 + c * x**2
    translated = polynomial.subs({x: x - tx, y: y - ty})
    zero(sp.diff(translated, tx) + sp.diff(translated, x), "First translation sign")
    zero(sp.diff(translated, ty) + sp.diff(translated, y), "Second translation sign")
    zero(sp.diff(translated, tx, 2) + sp.diff(translated, ty, 2)
         - sp.diff(translated, x, 2) - sp.diff(translated, y, 2),
         "Translation Laplacian")
    reflected = polynomial.subs({x: -x, y: -y}, simultaneous=True)
    zero(sp.diff(reflected, x) + sp.diff(polynomial, x).subs(
        {x: -x, y: -y}, simultaneous=True), "Reflected derivative sign")
    checks["translation_and_reflection_signs"] = True

    p1, p2, pt1, pt2, q1, q2, sigma = sp.symbols("p1 p2 pt1 pt2 q1 q2 sigma")
    G, p, pt, qt = map(sp.Matrix, ([g1, g2], [p1, p2], [pt1, pt2], [q1, q2]))
    density = (G + pt + sigma * qt).dot(G + pt + sigma * qt) - (G + p).dot(G + p)
    expansion = (2 * G.dot(pt - p) + pt.dot(pt) - p.dot(p)
                 + 2 * sigma * (G.dot(qt) + pt.dot(qt)) + sigma**2 * qt.dot(qt))
    zero(density - expansion, "Finite-domain energy polarization")
    zero(2 * p.dot(pt - p + sigma * qt) + (pt - p + sigma * qt).dot(
        pt - p + sigma * qt) - ((pt + sigma * qt).dot(pt + sigma * qt) - p.dot(p)),
        "Localized comparison L2 limit")
    checks["energy_polarization"] = True

    ell, Q = sp.symbols("ell Q", real=True)
    witness = -ell / (1 + Q)
    zero(2 * witness * ell + witness**2 * Q + ell**2 * (Q + 2) / (Q + 1)**2,
         "All-amplitude quadratic witness")
    require(certificate["identities"]["quadratic_witness"] ==
            "-ell**2*(Q+2)/(Q+1)**2", "Quadratic expected expression")
    for qvalue, lvalue in product((0, 1, 4), (-2, -1, 1, 2)):
        value = (2 * witness * ell + witness**2 * Q).subs({Q: qvalue, ell: lvalue})
        require(value < 0, "Nonzero linear coefficient must violate some amplitude")
    checks["quadratic_zero_and_positive_cases"] = 12

    nx, ny, ha, hb = sp.symbols("nx ny ha hb", real=True)
    T = sp.Matrix([[nx, ny], [-ny, nx]])
    H = sp.Matrix([[ha, hb], [hb, -ha]])
    zero(H * sp.Matrix([nx, ny]) - T * sp.Matrix([ha, hb]), "Planar Hessian system")
    zero(T.T * T - (nx**2 + ny**2) * sp.eye(2), "Planar normal invertibility")
    determinant = sp.expand(T.det())
    zero(determinant - nx**2 - ny**2, "Planar determinant")
    require(certificate["identities"]["normal_determinant"] == "nx**2+ny**2",
            "Determinant expected expression")
    normals = 0
    for ix, iy in product(range(-2, 3), repeat=2):
        if (ix, iy) != (0, 0):
            require(determinant.subs({nx: sp.Rational(ix, 5), ny: sp.Rational(iy, 5)}) > 0,
                    "Rational nonzero normal")
            normals += 1
    require(normals == certificate["stress_tests"]["nonzero_rational_normals"], "Normal count")
    checks["planar_rigidity_normals"] = normals

    execution = certificate["jacobian"]
    require(execution["adapter_exit_status"] == 0 and execution["timed_out"] is False
            and execution["error"] is None, "Jacobian adapter did not complete successfully")
    payload = read_json(execution["payload"])
    output = read_json(execution["output"])
    contract = read_json(execution["contract"])
    discovery = read_json(execution["discovery"])
    operation = execution["operation_id"]
    require(output["tool"] == "math.run", "Not a Jacobian execution")
    require(output["request"]["operation_id"] == operation
            and output["result"]["operation_id"] == operation
            and contract["result"]["operation"]["operation_id"] == operation,
            "Jacobian operation binding")
    require(any(item["operation_id"] == operation for item in discovery["result"]["matches"]),
            "Executed operation was not discovered")
    require(output["request"]["payload"] == payload, "Jacobian exact payload binding")
    for record in (output, contract, discovery):
        require(record["server"]["version"] == execution["server_version"]
                and record["protocol_version"] == execution["protocol_version"]
                and record["transport"] == "mcp-stdio", "Jacobian server/protocol binding")
    result = output["result"]
    require(set(result) == {"operation_id", "output", "runtime_ms"},
            "Jacobian error, unknown status, or incomplete result")
    require(type(result["runtime_ms"]) is int and result["runtime_ms"] >= 0,
            "Jacobian runtime metadata")
    require(set(result["output"]) == {"determinant", "method"}, "Jacobian typed output")
    require(result["output"]["method"] == "SYMPY_BAREISS", "Jacobian method")
    variables = [nx, ny]
    require(payload["matrix"]["variables"] == ["nx", "ny"], "Payload variable order")
    decoded = sp.Matrix([
        [rational_function(value, variables) for value in row]
        for row in payload["matrix"]["entries"]
    ])
    zero(decoded - T, "Jacobian matrix must be the proof's rigidity matrix")
    reported = rational_function(result["output"]["determinant"], variables)
    zero(reported - decoded.det(), "Independent Jacobian determinant replay")
    checks["jacobian_exact_replay"] = True

    slope, beta, dbeta, eta, deta, gx, gy, gxx, gxy, gyy = sp.symbols(
        "slope beta dbeta eta deta gx gy gxx gxy gyy"
    )
    density_graph = (dbeta * eta - slope * beta * deta) * gx + beta * deta * gy
    total_derivatives = (dbeta * eta * gx + beta * eta * (gxx + slope * gxy)
                         + beta * deta * (gy - slope * gx)
                         + beta * eta * (gyy - slope * gxy))
    zero(total_derivatives - density_graph - beta * eta * (gxx + gyy),
         "C1 graph divergence identity, without second graph derivatives")
    s, r = sp.symbols("s r", real=True)
    kappa = s**2 / 3
    beta_poly, eta_poly = (1 - s**2)**2, (1 - r)**2
    grad_h = sp.Matrix([
        sp.diff(beta_poly, s) * eta_poly
        - sp.diff(kappa, s) * beta_poly * sp.diff(eta_poly, r),
        beta_poly * sp.diff(eta_poly, r),
    ])
    harmonic_gradient = sp.Matrix([2 * (s + tx), -2 * (kappa + r + ty)])
    area_pairing = sp.integrate(sp.expand(harmonic_gradient.dot(grad_h)),
                                (r, 0, 1), (s, -1, 1))
    boundary_pairing = sp.integrate(
        beta_poly * (sp.diff(kappa, s) * 2 * (s + tx) + 2 * (kappa + ty)),
        (s, -1, 1),
    )
    expected_flux = sp.Rational(32, 105) + sp.Rational(32, 15) * ty
    zero(area_pairing - boundary_pairing, "Exact one-sided boundary orientation")
    zero(area_pairing - expected_flux, "Exact curved-arc stress value")
    zero(sp.diff(area_pairing, tx, 2) + sp.diff(area_pairing, ty, 2),
         "Stress interaction is harmonic")
    require(sp.diff(area_pairing, ty) != 0, "Harmonicity alone must not imply constancy")
    require(certificate["identities"]["curved_strip_flux"] == "32/105+32*ty/15",
            "Flux expected expression")
    checks["one_sided_curved_strip_flux"] = True

    radius = sp.symbols("radius", positive=True)
    n = sp.symbols("n", integer=True, positive=True)
    for mode in (sp.Integer(1), sp.log(radius), radius**n, radius**(-n)):
        angular_eigenvalue = 0 if mode in (sp.Integer(1), sp.log(radius)) else n**2
        zero(sp.diff(mode, radius, 2) + sp.diff(mode, radius) / radius
             - angular_eigenvalue * mode / radius**2, "Exterior radial ODE")
    aa, bb = sp.symbols("aa bb", real=True)
    radial_mode = aa * radius**n + bb * radius**(-n)
    energy_over_pi = sp.expand(radius * sp.diff(radial_mode, radius)**2
                               + n**2 * radial_mode**2 / radius)
    zero(energy_over_pi - 2 * n**2 * (
        aa**2 * radius**(2*n - 1) + bb**2 * radius**(-2*n - 1)),
        "No cancellation of growing and decaying Fourier energies")
    zero(sp.diff(sp.log(radius), radius) - 1 / radius, "Log energy primitive")
    checks["exterior_fourier_identities"] = True

    growth = sp.symbols("growth", real=True)
    half_dimension = sp.Rational(2, 2)
    function_decay = -sp.Integer(1)
    gradient_decay = function_decay - 1
    cutoff_gradient = -sp.Integer(1)
    field_norm_growth = sp.Rational(1, 2)
    gradient_norm = gradient_decay + half_dimension
    function_cutoff_norm = function_decay + cutoff_gradient + half_dimension
    zero(gradient_norm - function_cutoff_norm, "Both cutoff-gradient terms scale alike")
    exponents = {
        "annular_gradient_norm": gradient_norm,
        "annular_cross_term": field_norm_growth + gradient_norm,
        "annular_squared_error": 2 * gradient_norm,
        "absolute_interaction_dyadic": field_norm_growth + gradient_decay + half_dimension,
        "potential_cutoff_pairing": field_norm_growth + function_cutoff_norm,
        "constant_field_energy": 2 * half_dimension,
    }
    zero(growth / 2 - 1 - (growth - 2) / 2, "General subquadratic exponent")
    require(sp.solve_univariate_inequality(growth / 2 - 1 < 0, growth) == (growth < 2),
            "Exact subquadratic threshold")
    require({key: str(value) for key, value in exponents.items()} ==
            certificate["scaling_exponents"], "Source scaling exponents")
    for order in range(5):
        require(field_norm_growth + gradient_decay - order + half_dimension < 0,
                "Summable differentiated tail")
    checks["source_scaling_and_tail_exponents"] = True

    flat_gradient = sp.Matrix([
        sp.diff(beta_poly, s) * eta_poly, beta_poly * sp.diff(eta_poly, r)
    ])
    local_pairing = sp.integrate(flat_gradient[1], (r, 0, 1), (s, -1, 1))
    require(local_pairing == sp.Rational(-16, 15), "Local divergence-free pairing stress")
    require(str(local_pairing) == certificate["stress_tests"]["constant_G_compact_pairing"],
            "Stress pairing expected value")
    z = sp.symbols("z", real=True)
    f3 = y**2 - z**2
    Hessian3 = sp.hessian(f3, (x, y, z))
    zero(sp.trace(Hessian3), "Three-dimensional stress function is harmonic")
    zero(Hessian3 * sp.Matrix([1, 0, 0]), "Three-dimensional directional derivative")
    require(Hessian3 != sp.zeros(3), "Do not extend planar rigidity to dimension three")
    require(gradient * gradient.T - perpendicular * perpendicular.T != laplacian,
            "Sign-reversed Hodge formula must be rejected")
    require(sp.expand(area_pairing + boundary_pairing) != 0,
            "Sign-reversed jump-flux formula must be rejected")
    require((2 * sigma + sigma**2).subs(sigma, -1) < 0,
            "One-sided amplitudes are insufficient")
    checks["invalid_overextensions_and_sign_mutations_rejected"] = True

    require(certificate["identities"] == {
        "hodge": "grad(div a)+grad_perp(curl a)=Delta a",
        "curl_adjoint": "pair(grad_perp T,a)=-pair(T,curl a)",
        "correlation": "Delta sum_i(a_i*b_i)=div(a)*div(b)+curl(a)*curl(b)",
        "normal_determinant": "nx**2+ny**2",
        "quadratic_witness": "-ell**2*(Q+2)/(Q+1)**2",
        "curved_strip_flux": "32/105+32*ty/15",
    }, "Certificate statements must match the identities actually checked")
    require(set(checks) == set(certificate["computational_checks"]), "Check inventory")
    print(json.dumps({
        "status": "exact_algebra_verified",
        "checks": checks,
        "analytic_proof": "proof.md; not machine checked",
        "independent_review": "pending",
        "campaign_complete": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
