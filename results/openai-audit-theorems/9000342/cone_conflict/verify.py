#!/usr/bin/env python3
"""Replay exact algebra and source fidelity; analytic conclusions are in proof.md."""

import argparse
import itertools
import json
import re
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PAIRS = tuple(itertools.combinations(range(4), 2))
TRIPLES = tuple(itertools.combinations(range(4), 3))
f, k = sp.symbols("f k", real=True)
r = sp.Symbol("r", positive=True)
S = 1 + f**2 + k**2


def skew(form):
    matrix = sp.zeros(4)
    for (i, j), value in zip(PAIRS, form, strict=True):
        matrix[i, j], matrix[j, i] = value, -value
    return matrix


def coefficients(matrix):
    return sp.Matrix([matrix[i, j] for i, j in PAIRS])


def star(form):
    a, b, c, d, e, g = form
    return sp.Matrix([g, -e, d, c, -b, a])


def wedge(a, b):
    return a[0]*b[5] - a[1]*b[4] + a[2]*b[3] + a[3]*b[2] - a[4]*b[1] + a[5]*b[0]


def d_two(form, coordinates):
    entries = dict(zip(PAIRS, form, strict=True))
    return sp.Matrix([
        sum((-1)**p * sp.diff(entries[triple[:p] + triple[p+1:]], coordinates[i])
            for p, i in enumerate(triple))
        for triple in TRIPLES
    ])


def d_one(form, coordinates):
    return sp.Matrix([sp.diff(form[j], coordinates[i]) - sp.diff(form[i], coordinates[j])
                      for i, j in PAIRS])


def rational_function(value):
    if value["variables"] != ["f", "k"]:
        raise ValueError("Jacobian variable order differs from the checked matrix")

    def polynomial(data):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * f**term["exponents"][0] * k**term["exponents"][1]
            for term in data["terms"]
        )

    denominator = polynomial(value["denominator"])
    if denominator == 0:
        raise ValueError("Zero denominator in typed Jacobian value")
    return polynomial(value["numerator"]) / denominator


def replay():
    checks = []

    def equal(name, left, right=0, trig=False):
        difference = left - right
        values = list(difference) if isinstance(difference, sp.MatrixBase) else [difference]
        for value in values:
            if trig:
                value = sp.trigsimp(value)
            numerator, _ = sp.fraction(sp.cancel(value))
            remainder = sp.rem(numerator, r**2 - S, r)
            if sp.expand(remainder) != 0:
                raise AssertionError(f"{name}: nonzero exact remainder {remainder}")
        checks.append({"id": name, "entries": len(values), "exact_remainder": "0"})

    U = sp.Matrix([1, 0, 0, 0, 0, 1])
    V = sp.Matrix([0, 1, 0, 0, -1, 0])
    W = sp.Matrix([0, 0, 1, 1, 0, 0])
    D1 = sp.Matrix([1, 0, 0, 0, 0, -1])
    D2 = sp.Matrix([0, 1, 0, 0, 1, 0])
    D3 = sp.Matrix([0, 0, 1, -1, 0, 0])
    basis = [U, V, W, D1, D2, D3]
    gram = sp.Matrix(6, 6, lambda i, j: wedge(basis[i], basis[j]))
    equal("constant_basis_intersection", gram, sp.diag(2, 2, 2, -2, -2, -2))
    equal("hodge_star_squared", star(star(sp.Matrix(sp.symbols("a:6")))),
          sp.Matrix(sp.symbols("a:6")))

    A = U + f*V + k*W
    F = A/r
    K = -skew(A)
    J = K/r
    identity = sp.eye(4)
    equal("K_squared_universal", K*K, -S*identity)
    equal("K_skew", K.T, -K)
    equal("J_squared", J*J, -identity)
    equal("J_orthogonal", J.T*J, identity)
    equal("fundamental_form_convention", -J, skew(F))
    equal("F_self_dual", star(F), F)
    equal("F_norm_squared", F.dot(F), 2)
    equal("F_orientation", wedge(F, F), 2)
    equal("J_determinant", J.det(), 1)

    eta = sp.Matrix([1, 2*f, 0, 2*k, 0, 1])
    equal("eta_self_dual_part", (eta + star(eta))/2, A)
    equal("eta_anti_self_dual_part", (eta - star(eta))/2, f*D2 - k*D3)
    equal("eta_invariant", J.T*skew(eta)*J, skew(eta))
    equal("eta_volume", wedge(eta, eta), 2)
    H = skew(eta)*J
    equal("eta_Hermitian_symmetric", H.T, H)
    equal("eta_eigenvalue_identity", (H - r*identity)**2, (f**2+k**2)*identity)
    lam = sp.Symbol("lambda")
    equal("eta_characteristic_polynomial", H.charpoly(lam).as_expr(),
          ((lam-r)**2 - f**2-k**2)**2)
    equal("eta_eigenvalue_product", r**2 - (f**2+k**2), 1)
    equal("uniform_taming_bound_squared", sp.Rational(3, 4)**2/sp.Rational(9, 8),
          sp.Rational(1, 2))
    equal("uniform_eta_bound", sp.sqrt(sp.Rational(9, 8))-sp.sqrt(sp.Rational(1, 8)),
          1/sp.sqrt(2))

    betas = [U+V, U-V]
    for sign, beta in zip([1, -1], betas, strict=True):
        label = "plus" if sign == 1 else "minus"
        factor = (1+sign*f)/r
        equal(f"{label}_invariant_projection",
              (skew(beta)+J.T*skew(beta)*J)/2, factor*skew(F))
        equal(f"{label}_taming_quadratic_form",
              (skew(beta)*J + (skew(beta)*J).T)/2, factor*identity)
        equal(f"{label}_symplectic_orientation", wedge(beta, beta), 4)
        equal(f"eta_{label}_wedge", wedge(eta, beta), 2*(1+sign*f))
    equal("zero_intersection_obstruction", wedge(*betas), 0)

    a, b, c, d = sp.symbols("a b c d", real=True)
    invariant = a*F+b*D1+c*D2+d*D3
    equal("general_invariant_form", J.T*skew(invariant)*J, skew(invariant))
    equal("general_compatible_trace", sp.trace(skew(invariant)*J), 4*a)
    for sign, beta in zip([1, -1], betas, strict=True):
        equal(f"arbitrary_invariant_wedge_{sign}", wedge(invariant, beta),
              (1+sign*f)/r * sp.trace(skew(invariant)*J)/2)

    coords = sp.symbols("x1:5", real=True)
    x, y = coords[:2]
    sx, sy, cx, cy = sp.sin(2*sp.pi*x), sp.sin(2*sp.pi*y), sp.cos(2*sp.pi*x), sp.cos(2*sp.pi*y)
    trigonometric = {f: sx/4, k: sy/4}
    eta_x = eta.subs(trigonometric)
    theta_eta = sp.Matrix([0, 0, -(cx+cy)/(4*sp.pi), 0])
    equal("eta_closed", d_two(eta_x, coords), sp.zeros(4, 1))
    equal("eta_exact_primitive", d_one(theta_eta, coords), eta_x-U)
    for i, beta in enumerate(betas):
        equal(f"constant_tamer_closed_{i}", d_two(beta, coords), sp.zeros(4, 1))

    rho_V = sp.Matrix([64*f, -1+64*f**2-2*cx*cy, 32*f*k, 32*f*k, -1-2*cx*cy, 0])
    rho_W = sp.Matrix([64*k, 32*f*k, 1+2*cx*cy, -1-2*cx*cy+64*k**2, -32*f*k, 0])
    theta_V = sp.Matrix([
        0, -8*cx/sp.pi,
        -sp.sin(4*sp.pi*x)/(2*sp.pi)-sx*cy/sp.pi,
        -cx*sy/sp.pi,
    ])
    theta_W = sp.Matrix([
        8*cy/sp.pi, 0,
        -cx*sy/sp.pi-sp.sin(4*sp.pi*y)/(2*sp.pi),
        sx*cy/sp.pi,
    ])
    for label, rho, theta, base, factor in [
        ("V", rho_V, theta_V, V, 32*f),
        ("W", rho_W, theta_W, W, 32*k),
    ]:
        equal(f"rho_{label}_self_dual_part", (rho+star(rho))/2, factor*A)
        equal(f"rho_{label}_invariant", J.T*skew(rho)*J, skew(rho))
        rho_x = rho.subs(trigonometric)
        equal(f"rho_{label}_closed", d_two(rho_x, coords), sp.zeros(4, 1), trig=True)
        equal(f"rho_{label}_exact_primitive", d_one(theta, coords), rho_x-base, trig=True)
    for i, form in enumerate([D1, D2, D3]):
        equal(f"constant_ASD_invariant_{i}", J.T*skew(form)*J, skew(form))

    variation = sp.Matrix([[1, 0, 0], [1, sp.Rational(1, 4), 0], [1, 0, sp.Rational(1, 4)]])
    equal("anti_invariant_constant_orthogonality", (a*U+b*V+c*W).dot(F),
          2*(a+b*f+c*k)/r)
    equal("independence_determinant", variation.det(), sp.Rational(1, 16))
    equal("variation_points_are_actual_sine_values",
          sp.Matrix([[1, sx.subs(x, xx)/4, sy.subs(y, yy)/4]
                     for xx, yy in [(0, 0), (sp.Rational(1, 4), 0), (0, sp.Rational(1, 4))]]),
          variation)

    P = (1-f)/S*A
    Q = betas[1]-P
    equal("projected_current_self_dual", star(P), P)
    equal("projected_current_invariant", J.T*skew(P)*J, skew(P))
    equal("correction_anti_invariant", J.T*skew(Q)*J, -skew(Q))
    equal("correction_self_dual", star(Q), Q)
    equal("projection_agrees_on_invariant_tests", wedge(P, invariant),
          wedge(betas[1], invariant))
    nonclosed = d_two(P.subs(trigonometric), coords).subs({variable: 0 for variable in coords})
    equal("projected_current_nonclosed_at_origin", nonclosed,
          sp.Matrix([0, -sp.pi, -sp.pi/2, 0]))
    if not nonclosed[1].is_nonzero:
        raise AssertionError("The exact derivative witness is not proved nonzero")
    xi = eta+rho_V
    equal("explicit_class_plus_invariant", J.T*skew(xi)*J, skew(xi))
    equal("explicit_class_plus_primitive", d_one(theta_eta+theta_V, coords),
          xi.subs(trigonometric)-betas[0], trig=True)

    jacobian = json.loads((HERE/"jacobian/result.json").read_text())
    payload = json.loads((HERE/"jacobian/payload.json").read_text())
    status = json.loads((HERE/"jacobian/status.json").read_text())
    operation = "matrix.symbolic.characteristic_polynomial.compute"
    if status["adapter_exit_code"] != 0 or jacobian["result"]["operation_id"] != operation:
        raise AssertionError("Jacobian error, timeout or mismatched operation is not evidence")
    if jacobian["request"]["payload"] != payload:
        raise AssertionError("Archived Jacobian result is not bound to the exact input payload")
    typed_matrix = sp.Matrix([[rational_function(value) for value in row]
                              for row in payload["matrix"]["entries"]])
    equal("jacobian_payload_is_exact_K", typed_matrix, K)
    output = jacobian["result"]["output"]
    if output["degree"] != 4 or output["convention"] != "DET_LAMBDA_I_MINUS_A":
        raise AssertionError("Jacobian output has the wrong degree or convention")
    poly = sum(rational_function(value)*lam**(4-i)
               for i, value in enumerate(output["coefficients_descending"]))
    equal("jacobian_output_replayed", poly, (lam**2+S)**2)
    equal("independent_characteristic_polynomial", K.charpoly(lam).as_expr(), poly)

    source = (HERE/"literature/0708.2520v4.tex").read_text()

    def block(environment, label):
        pattern = rf"\\begin\{{{environment}\}}\s*\\label\{{{label}\}}(.*?)\\end\{{{environment}\}}"
        match = re.search(pattern, source, re.S)
        if match is None:
            raise AssertionError(f"Missing original source block {label}")
        return match.group(1).strip()

    def compact(text):
        return re.sub(r"\s+", "", text)

    expected = {
        "F_EXTERNAL_THM13": ("theorem", "extension", r"""
Suppose $J$ is a $C^{\infty}$ full almost complex structure.
If $\mathcal K_J^c$ is non-empty then
$$\mathcal K_J^t=\mathcal K_J^c+H_J^{(2,0),(0,2)}(M)_{\mathbb R}.$$
"""),
        "F_EXTERNAL_COR14": ("cor", "dlz", r"""
Suppose $(M, J)$ is an almost complex $4-$manifold
with non-empty $\mathcal K_J^c$. Then
$$\mathcal K_J^t=\mathcal K_J^c+H_J^{(2,0),(0,2)}(M)_{\mathbb R}.$$
In particular, if $b^+(M)=1$, then $K_J^t=K_J^c$.
"""),
        "F_EXTERNAL_PROP39": ("prop", "general", r"""
Suppose $(M, J)$ is an almost complex manifold with $J$ almost
K\"ahler, i.e. $\mathcal K_J^c\ne \emptyset$. Then we have
\begin{equation}\label{ct'}
\mathcal K^t_J \cap H_J^{1,1}(M)_{\mathbb R}=\mathcal K^c_J,
\end{equation}
and \begin{equation}\label{sup'}\mathcal K_J^c+
H_J^{(2,0),(0,2)}(M)_{\mathbb R}\subset \mathcal K_J^t.
\end{equation}
"""),
        "F_EXTERNAL_THM37": ("theorem", "generalization", r"""
Suppose $(M, J)$ is an almost complex manifold.
If $\mathcal K_J^c$ is non-empty then
$\mathcal K_J^c\subset H_J^{1,1}(M)_{\mathbb R}$ is the interior
of the dual cone of $H\mathfrak C(J)\subset H^J_{1,1}(M)_{\mathbb R}$.
"""),
    }
    assertions = {}
    for ident, (environment, label, text) in expected.items():
        actual = block(environment, label)
        if compact(actual) != compact(text):
            raise AssertionError(f"Literal version-specific assertion differs: {ident}")
        assertions[ident] = actual
    disjointness = r"""By our choice
of $e$, as subsets of $\mathcal E_{1,1}(M)_{\mathbb R}$, $L$ and
$\mathfrak C(J)\backslash \{0\}$ are disjoint."""
    if compact(disjointness) not in compact(source):
        raise AssertionError("The precise projected-cycle inference is absent from the source")
    assertions["F_EXTERNAL_THM37_DISJOINTNESS"] = disjointness

    return {
        "classification": {
            "staged_example": "exact verification with the analytic proof in proof.md",
            "external_cone_equalities": "explicit counterexample under their stated hypotheses",
            "general_manuscript_existence_and_cone_duality": "not settled by this certificate",
            "independent_review": "pending Host-invoked Reviewer",
            "novelty": "not established",
        },
        "quantifiers": {
            "matrix_and_exterior_identities": "all real f,k; r>0 and r^2=1+f^2+k^2",
            "global_sine_bounds": "-1/4 <= f,k <= 1/4 at every torus point",
            "fullness": "six closed invariant representatives with exact periodic primitives",
            "anti_invariant_vanishing": "all smooth closed anti-invariant forms, via the flat energy argument",
        },
        "coordinates": {"two_forms": ["12", "13", "14", "23", "24", "34"],
                        "three_forms": ["123", "124", "134", "234"]},
        "exact_data": {
            "K": [[str(value) for value in row] for row in K.tolist()],
            "intersection_gram": gram.tolist(),
            "tamer_squares": [4, 4],
            "tamer_intersection": 0,
            "eta_square": 2,
            "minimum_eigenvalue_lower_bound": "1/sqrt(2)",
            "minimum_taming_lower_bound": "1/sqrt(2)",
            "independence_determinant": "1/16",
            "projected_current_derivative_at_origin": [str(value) for value in nonclosed],
            "closed_invariant_class_plus": "xi_plus=eta+rho_V=U+V+d(theta_eta+theta_V)",
        },
        "checks": checks,
        "target_source": {
            "source_id": "arxiv:0708.2520v4",
            "source_path": "literature/0708.2520v4.tex",
            "literal_assertions": assertions,
            "published_source_id": "doi:10.4310/CAG.2009.v17.n4.a4",
        },
        "jacobian": {
            "operation_id": operation,
            "server_version": jacobian["server"]["version"],
            "protocol_version": jacobian["protocol_version"],
            "transport": jacobian["transport"],
            "adapter_exit_code": status["adapter_exit_code"],
            "runtime_ms": jacobian["result"]["runtime_ms"],
            "polynomial": str(sp.factor(poly)),
            "scope": "exact polynomial characteristic polynomial only",
        },
        "analytic_proofs_not_replaced_by_symbolic_checks": [
            "proof.md Sections 1-2: global smoothness, periodic descent and positivity",
            "proof.md Section 3: closed self-dual periodic forms have constant coefficients",
            "proof.md Section 4: periodic primitives and all de Rham classes via translations",
            "proof.md Section 5: strict wedge positivity and Stokes obstruction",
            "proof.md Section 6: positive currents, interior dual-cone premise and kernel witness",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = replay()
    path = HERE/"exact_certificate.json"
    serialized = json.dumps(result, indent=2, default=str) + "\n"
    if args.write_certificate:
        path.write_text(serialized)
    elif json.loads(path.read_text()) != json.loads(serialized):
        raise AssertionError("The persisted exact certificate differs from this replay")
    print(f"PASS: {len(result['checks'])} exact identity groups; literal v4 assertions match; "
          "the projected current has dP|0 = -pi e124 - (pi/2)e134.")


if __name__ == "__main__":
    main()
