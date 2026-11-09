#!/usr/bin/env python3
"""Replay the exact algebra accompanying the analytic closure proof."""

import argparse
import json
from itertools import combinations
from math import factorial
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(checks, name, expression):
    residual = sp.factor(sp.cancel(expression))
    require(residual == 0, f"{name}: nonzero exact residual {residual}")
    checks.append({"identity": name, "exact_residual": "0"})


def density_algebra():
    e, g = sp.symbols("eta g", real=True)
    ae, ag, gee, geg, ggg = sp.symbols(
        "Aeta Ag Gamma_eta Gamma_eta_g Gamma_g", real=True
    )

    def diffusion(f):
        return (
            sp.diff(f, e) * ae
            + sp.diff(f, g) * ag
            - sp.diff(f, e, 2) * gee
            - 2 * sp.diff(f, e, g) * geg
            - sp.diff(f, g, 2) * ggg
        )

    def gamma(f, h):
        return (
            sp.diff(f, e) * sp.diff(h, e) * gee
            + (sp.diff(f, e) * sp.diff(h, g)
               + sp.diff(f, g) * sp.diff(h, e)) * geg
            + sp.diff(f, g) * sp.diff(h, g) * ggg
        )

    checks = []
    zero(checks, "A(eta*g), also the graph-norm cutoff product rule",
         diffusion(e * g) - (e * ag + g * ae - 2 * geg))
    zero(checks, "A(eta^4)",
         diffusion(e**4) - (4 * e**3 * ae - 12 * e**2 * gee))
    expansion = (
        e**4 * ag
        + g * (4 * e**3 * ae - 12 * e**2 * gee - e**4)
        - 8 * e**3 * geg
    )
    zero(checks, "(A-1)(eta^4*g), report (4.2)",
         diffusion(e**4 * g) - e**4 * g - expansion)
    zero(checks, "Gamma(eta^2*g,g), localized energy identity",
         gamma(e**2 * g, g) - (e**2 * ggg + 2 * e * g * geg))

    a, b, norm_g, y, z, norm_v = sp.symbols(
        "a B G Y Z Vnorm", nonnegative=True
    )
    r = sp.symbols("r", positive=True)
    combined = norm_g * (a * norm_g + 8 * b * y / r)
    combined += 2 * b * norm_g * y / r
    zero(checks, "coupled cutoff inequalities give coefficient 10",
         combined - (a * norm_g**2 + 10 * b * norm_g * y / r))
    zero(checks, "completed square for Y",
         (y - 5 * b * norm_g / r)**2
         - (a + 25 * b**2 / r**2) * norm_g**2
         - (y**2 - 10 * b * norm_g * y / r - a * norm_g**2))
    zero(checks, "completed square for eigenfunction energy Z",
         (z - b * norm_v / r)**2
         - (1 + b**2 / r**2) * norm_v**2
         - (z**2 - 2 * b * norm_v * z / r - norm_v**2))
    return checks


def variance_algebra():
    checks = []
    t = sp.symbols("t", real=True)
    k = sp.symbols("k", integer=True, nonnegative=True)
    q = 2 * k + 2
    psi = t**q
    zero(checks, "Euler coefficients for every q=2*k+2",
         sp.simplify(t * sp.diff(psi, t) - q * psi))
    zero(checks, "Hessian homogeneity coefficients for every q=2*k+2",
         sp.simplify(t * sp.diff(psi, t, 2) - (q - 1) * sp.diff(psi, t)))

    x0, x1, p0, p1 = sp.symbols("x0 x1 p0 p1", real=True)
    h = sp.symbols("h", positive=True)
    x = sp.Matrix([x0, x1])
    for power in (2, 4, 6, 8):
        slab = ((p0 * x0 + p1 * x1) / h)**power
        gradient = sp.Matrix([sp.diff(slab, xi) for xi in x])
        hessian = sp.hessian(slab, tuple(x))
        zero(checks, f"selected polynomial Euler identity q={power}",
             x.dot(gradient) - power * slab)
        for j in range(2):
            zero(checks, f"selected polynomial Hessian identity q={power}, slot={j}",
                 (hessian * x)[j] - (power - 1) * gradient[j])
        if power == 2:
            expected = 2 * sp.Matrix([p0, p1]) * sp.Matrix([[p0, p1]]) / h**2
            require(hessian == expected, "q=2 Hessian must remain constant at zero")

    a = sp.symbols("a", positive=True)
    d = sp.symbols("d", real=True)
    degree = sp.symbols("q", positive=True)
    zero(checks, "two bounds combine to d^2/a when m=q*a",
         d**2 / (degree * a)
         + (degree - 1) * d**2 / (degree * a) - d**2 / a)
    m = sp.symbols("m", positive=True)
    zero(checks, "second Cauchy-Schwarz normalization",
         sp.cancel((degree - 1)**2 * d**2 / ((degree - 1) * m)
                   - (degree - 1) * d**2 / m))

    ci, cj, ei, ej = sp.symbols("ci cj ei ej", real=True)
    zero(checks, "finite-index Cauchy-Schwarz off-diagonal orbit",
         ci**2 * ej**2 + cj**2 * ei**2 - 2 * ci * ei * cj * ej
         - (ci * ej - cj * ei)**2)

    l1, l2 = sp.symbols("lambda1 lambda2", positive=True)
    divided_difference = (1 / l1 - 1 / l2) / (l1 - l2)
    zero(checks, "log spectral second-variation divided difference",
         divided_difference + 1 / (l1 * l2))
    zero(checks, "log spectral coincident-eigenvalue limit",
         sp.limit(divided_difference, l2, l1) + 1 / l1**2)
    return checks


def matrix_diagnostic():
    lower = sp.Matrix([[2, 0], [1, 1]])
    factor_h = sp.Matrix([[1, 2], [0, 0]])
    tau = lower * lower.T
    hessian = factor_h.T * factor_h
    signed_b = sp.Matrix([[1, -2], [-2, -1]])
    inverse = tau.inv()
    field_x = factor_h * lower
    field_y = factor_h * signed_b * lower.inv().T
    pair = sp.trace(hessian * signed_b)
    mass = sp.trace(tau * hessian)
    energy = sp.trace(inverse * signed_b * hessian * signed_b)
    require(sp.trace(field_x.T * field_y) == pair, "matrix CS pairing")
    require(sp.trace(field_x.T * field_x) == mass, "matrix CS first norm")
    require(sp.trace(field_y.T * field_y) == energy, "matrix CS second norm")
    require(hessian.rank() == 1, "diagnostic must have singular H")
    require(signed_b.det() < 0, "diagnostic must have indefinite B")
    require(tau * hessian != hessian * tau, "diagnostic must be noncommuting")
    require(mass * energy - pair**2 >= 0, "matrix CS exact Gram gap")
    return {
        "classification": "finite_exact_diagnostic_not_the_integrated_proof",
        "dimension": 2,
        "singular_H_rank": 1,
        "indefinite_B_determinant": str(signed_b.det()),
        "noncommuting": True,
        "pairing": str(pair),
        "first_squared_norm": str(mass),
        "second_squared_norm": str(energy),
        "cauchy_schwarz_gap": str(mass * energy - pair**2),
    }


def gaussian_diagnostic(name, epsilon, vectors, widths, coefficients):
    n = len(vectors[0])
    count = len(vectors)
    effective = [sp.Matrix(p) / width for p, width in zip(vectors, widths)]
    precision = epsilon * sp.eye(n)
    for direction in effective:
        precision += 2 * direction * direction.T
    covariance_x = precision.inv()
    x = sp.symbols(f"x0:{n}", real=True)
    t = sp.symbols(f"t0:{n}", real=True)
    quadratic = (sp.Matrix(t).T * covariance_x * sp.Matrix(t))[0] / 2
    mgf_through_degree_four = sp.Poly(
        sp.expand(1 + quadratic + quadratic**2 / 2), *t
    )

    def expectation(polynomial):
        value = sp.Integer(0)
        for exponents, coefficient in sp.Poly(sp.expand(polynomial), *x).terms():
            require(sum(exponents) <= 4, "truncated Gaussian MGF used beyond degree 4")
            monomial = sp.prod(ti**power for ti, power in zip(t, exponents))
            derivative_factor = sp.prod(factorial(power) for power in exponents)
            value += (
                coefficient * derivative_factor
                * mgf_through_degree_four.coeff_monomial(monomial)
            )
        return sp.factor(value)

    slabs = [direction.dot(sp.Matrix(x))**2 for direction in effective]
    means = sp.Matrix([expectation(slab) for slab in slabs])
    gram = sp.Matrix(count, count, lambda i, j:
                     (effective[i].T * covariance_x * effective[j])[0])
    covariance = sp.Matrix(
        count, count,
        lambda i, j: expectation(slabs[i] * slabs[j]) - means[i] * means[j],
    )
    require(means == sp.Matrix([gram[i, i] for i in range(count)]),
            f"{name}: exact Gaussian means")
    require(covariance == 2 * gram.multiply_elementwise(gram),
            f"{name}: fourth moments and covariance")
    gap = sp.diag(*means) - covariance
    minors = []
    for size in range(1, count + 1):
        for indices in combinations(range(count), size):
            determinant = sp.factor(gap.extract(indices, indices).det())
            require(determinant >= 0, f"{name}: negative principal minor {indices}")
            minors.append({"indices": list(indices), "determinant": str(determinant)})
    b = sp.Matrix(coefficients)
    variance = (b.T * covariance * b)[0]
    bound = sum(coefficients[i]**2 * means[i] for i in range(count))
    require(bound - variance >= 0, f"{name}: mixed-sign variance bound")
    return {
        "classification": "finite_exact_gaussian_q2_diagnostic_not_the_general_proof",
        "name": name,
        "dimension": n,
        "vector_rank": sp.Matrix.vstack(*(p.T for p in effective)).rank(),
        "epsilon": str(epsilon),
        "vectors": vectors,
        "widths": [str(width) for width in widths],
        "coefficients": [str(value) for value in coefficients],
        "means": [str(value) for value in means],
        "covariance": [[str(value) for value in covariance.row(i)]
                       for i in range(count)],
        "all_principal_minors_of_covariance_gap": minors,
        "variance": str(variance),
        "variance_bound": str(bound),
        "variance_gap": str(bound - variance),
    }


def certificate():
    density = density_algebra()
    variance = variance_algebra()
    gaussian = [
        gaussian_diagnostic(
            "nonspanning_rank_one_repeated_and_opposite_directions",
            sp.Rational(1, 7),
            [[1, 0, 0], [-2, 0, 0], [1, 0, 0]],
            [sp.Integer(1), sp.Integer(1), sp.Integer(2)],
            [sp.Integer(2), sp.Integer(-3), sp.Rational(1, 4)],
        ),
        gaussian_diagnostic(
            "spanning_nonorthogonal_unequal_widths",
            sp.Rational(5, 3),
            [[1, 0], [1, 1], [-1, 2]],
            [sp.Integer(1), sp.Integer(2), sp.Integer(3)],
            [sp.Integer(-2), sp.Rational(3, 2), sp.Rational(1, 3)],
        ),
    ]
    require(gaussian[0]["vector_rank"] == 1, "nonspanning case was not exercised")
    require(gaussian[1]["vector_rank"] == 2, "spanning case was not exercised")
    return {
        "schema_version": 1,
        "mission": "variance-analytic-closure",
        "claims": ["M_MOMENT", "M_DENSITY", "M_VARIANCE"],
        "result": "Analytic proof of the literal soft-slab variance proposition, "
                  "with exact algebraic replay and separately classified diagnostics.",
        "proof": "research/analytic_closure/report.md",
        "arithmetic": "exact symbolic and rational arithmetic; no floating-point thresholds",
        "reviewed_tensor_dependency": {
            "claim": "C_TENSOR",
            "reviewer": "reviewer:copilot-L2",
            "report": "research/tensor_audit/report.md",
            "certificate": "research/tensor_audit/exact_certificate.json",
            "action": "reused_without_rebuilding_or_recertifying",
        },
        "source_assumptions": {
            "M_MOMENT": ["A_BB_BALL", "A_KL_CAP", "A_EK_REAL", "A_SCHAUDER"],
            "M_DENSITY": ["A_ELLIPTIC"],
            "primary_source_locators": "research/analytic_closure/sources/reading.md",
            "source_reader_lookup": "supports_needed_propositions_with_recorded_qualifications",
            "historical_Dyatlov_version": "not_retrieved_not_refuted",
            "independent_citation_attribution": "required_from_Host_Reviewer",
        },
        "density_symbolic_checks": density,
        "variance_symbolic_checks": variance,
        "matrix_cauchy_schwarz_diagnostic": matrix_diagnostic(),
        "finite_gaussian_diagnostics": gaussian,
        "analytic_proof_not_machine_checked": [
            {"obligation": "uniform truncated source bounds and normalization",
             "report_sections": "2.1-2.2"},
            {"obligation": "local elliptic estimates and smooth diagonal convergence",
             "report_sections": "2.3"},
            {"obligation": "probability, pushforward, and surjectivity",
             "report_sections": "2.4"},
            {"obligation": "compact adjoints and Hessian identity",
             "report_sections": "3"},
            {"obligation": "distributional regularity and Ag in L2",
             "report_sections": "4.1-4.2"},
            {"obligation": "harmonic splitting, graph-norm closure, and affine kernel",
             "report_sections": "4.3"},
            {"obligation": "polynomial adjunction, integrated CS, and L2 duality",
             "report_sections": "5.1-5.3"},
        ],
        "computer_proves_analytic_theorem": False,
        "refuted_manuscript_assertions": [],
        "new_Lean_source": False,
        "new_Jacobian_operation": False,
        "independent_review": "required_from_Host_Reviewer",
        "novelty_status": "not_established",
        "campaign_complete": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    computed = certificate()
    path = ROOT / "exact_certificate.json"
    if arguments.write_certificate:
        path.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    require(path.is_file(), f"Missing certificate: {path}")
    recorded = json.loads(path.read_text())
    require(recorded == computed, "Recorded certificate differs from exact recomputation")
    count = len(computed["density_symbolic_checks"]) + len(computed["variance_symbolic_checks"])
    print(f"PASS: {count} exact symbolic identities, one matrix diagnostic, "
          "and two exact Gaussian diagnostics.")
    print("The infinite-dimensional analytic proof still requires Host independent review.")


if __name__ == "__main__":
    main()
