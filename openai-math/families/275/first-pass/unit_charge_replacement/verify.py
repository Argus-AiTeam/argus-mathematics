#!/usr/bin/env python3
"""Exact algebraic components of the analytic theorem in proof.md."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def multiindices(order):
    return [
        (a, b, order - a - b)
        for a in range(order + 1)
        for b in range(order - a + 1)
    ]


def rational_text(value):
    value = sp.Rational(value)
    return str(value.p) if value.q == 1 else f"{value.p}/{value.q}"


def assert_zero(expression):
    reduced = sp.simplify(expression)
    if reduced != 0:
        raise AssertionError(f"Nonzero exact residual: {reduced}")


def check_moments():
    node = sp.sqrt(3) / 3
    nodes = (-node, node)
    moments = [sp.Rational(1, p + 1) if p % 2 == 0 else 0 for p in range(4)]
    checked = 0
    total_degree_cubic = 0
    for a, b, c in itertools.product(range(4), repeat=3):
        discrete = sum(
            x**a * y**b * z**c for x, y, z in itertools.product(nodes, repeat=3)
        ) / 8
        assert_zero(discrete - moments[a] * moments[b] * moments[c])
        checked += 1
        total_degree_cubic += a + b + c <= 3
    fourth_defect = sp.simplify(sum(x**4 for x in nodes) / 2 - sp.Rational(1, 5))
    assert fourth_defect == -sp.Rational(4, 45)
    assert_zero(node**2 - sp.Rational(1, 3))
    assert sp.Rational(4, 9) - node**2 == sp.Rational(1, 9)
    assert node**2 - sp.Rational(1, 9) == sp.Rational(2, 9)
    return {
        "interval": "normalized Lebesgue measure on [-1,1]",
        "nodes": ["-sqrt(3)/3", "sqrt(3)/3"],
        "weights": ["1/2", "1/2"],
        "tensor_monomials_checked": checked,
        "total_degree_at_most_three": total_degree_cubic,
        "fourth_moment_rule_minus_integral": rational_text(fourth_defect),
        "grid_node_separation_lower_bound": "h/3",
    }


def derivative_bounds(expressions, coordinates, max_order, numerator_extra_degree):
    r2 = sum(x**2 for x in coordinates)
    bounds = {}
    checked = 0
    for order in range(1, max_order + 1):
        maximum = sp.Rational(0)
        for expression in expressions:
            for powers in multiindices(order):
                arguments = list(itertools.chain.from_iterable(zip(coordinates, powers)))
                derivative = sp.diff(expression, *arguments)
                numerator = sp.Poly(
                    sp.simplify(derivative * r2 ** (order + sp.Rational(1, 2))),
                    *coordinates,
                    domain=sp.QQ,
                )
                degree = order + numerator_extra_degree
                assert all(sum(monomial) == degree for monomial, _ in numerator.terms())
                reconstructed = numerator.as_expr() / r2 ** (order + sp.Rational(1, 2))
                assert_zero(derivative - reconstructed)
                coefficient_bound = sum(abs(c) for c in numerator.coeffs())
                maximum = max(maximum, coefficient_bound)
                checked += 1
        bounds[str(order)] = rational_text(maximum)
    return {"partial_derivatives_checked": checked, "coefficient_l1_bounds": bounds}


def check_kernels():
    coordinates = sp.symbols("x y z", real=True)
    r2 = sum(x**2 for x in coordinates)
    kernel = 1 / sp.sqrt(r2)
    primitive = [x / (2 * sp.sqrt(r2)) for x in coordinates]
    assert_zero(sum(sp.diff(v, x) for v, x in zip(primitive, coordinates)) - kernel)
    assert_zero(sum(v**2 for v in primitive) - sp.Rational(1, 4))
    vector_bounds = derivative_bounds(primitive, coordinates, 4, 1)
    scalar_bounds = derivative_bounds([kernel], coordinates, 4, 0)
    radius = sp.symbols("r", positive=True)
    h = sp.symbols("h", positive=True)
    pure_vector_radial_integral = sp.integrate(radius**-2, (radius, h, sp.oo))
    pure_scalar_radial_integral = sp.integrate(radius**-3, (radius, h, sp.oo))
    compressed_radial_integral = sp.integrate(
        radius**2 / (1 + radius) ** 5, (radius, 0, sp.oo)
    )
    assert_zero(pure_vector_radial_integral - 1 / h)
    assert_zero(pure_scalar_radial_integral - 1 / (2 * h**2))
    assert compressed_radial_integral == sp.Rational(1, 12)
    epsilon = sp.symbols("epsilon", positive=True)
    assert sp.limit(epsilon**2, epsilon, 0, dir="+") == 0
    return {
        "divergence": "div(x/(2*|x|))=1/|x| for x!=0",
        "primitive_squared_norm": "1/4",
        "vector_derivatives": vector_bounds,
        "vector_bound_interpretation": "|partial^alpha J_j(x)|<=C_order*|x|^(-order)",
        "scalar_derivatives": scalar_bounds,
        "scalar_bound_interpretation": "|partial^alpha (1/|x|)|<=C_order*|x|^(-1-order)",
        "radial_integrals_without_surface_factor_4pi": [
            "integral_h^infinity r^(-2) dr=1/h",
            "integral_h^infinity r^(-3) dr=1/(2*h^2)",
            "integral_0^infinity r^2/(1+r)^5 dr=1/12",
        ],
        "normalized_inner_flux_bound": "epsilon^2 tends to zero",
        "distributional_interpretation": "proved analytically in proof.md, not inferred from differentiation alone",
    }


def positive_coefficients(expression, variables):
    polynomial = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
    assert all(c >= 0 for c in polynomial.coeffs())
    return len(polynomial.terms())


def check_transport_rounding_and_counts():
    x, y, z = sp.symbols("x y z", real=True)
    t, rho = sp.symbols("t rho", positive=True)
    potential = sp.Function("V")(x, y, z)
    laplacian = sum(sp.diff(potential, a, 2) for a in (x, y, z))
    density = rho + t * laplacian / (4 * sp.pi)
    flux = [-sp.diff(potential, a) / (4 * sp.pi) for a in (x, y, z)]
    assert_zero(sp.diff(density, t) + sum(sp.diff(f, a) for f, a in zip(flux, (x, y, z))))
    H, S, k = sp.symbols("H S k", positive=True)
    node_count = 64 * H**2 * S * k**3
    node_mass = rho / (8 * k**3)
    total_mass = 8 * rho * H**2 * S
    scale = 8 * k**3 / rho
    assert_zero(node_count * node_mass - total_mass)
    assert_zero(node_count - 8 * rho * H**2 * S * scale)
    assert_zero(node_mass - 1 / scale)
    rounding_terms = positive_coefficients(
        (1 + H) ** 3 * (1 + S) ** 2 - H**3 * S**2, (H, S)
    )
    v = sp.symbols("v", nonnegative=True)
    for j in (1, 2, 3):
        positive_coefficients((1 + v) ** 4 - (1 + v) ** j, (v,))
        positive_coefficients((1 + v) ** j - 1, (v,))
    return {
        "transport_continuity_identity": "d_t q_t+div(q_t*V_t)=0 for q_t*V_t=-grad(V)/(4*pi)",
        "cell_count": "8*H^2*S*k^3",
        "node_count": "64*H^2*S*k^3=8*rho*H^2*S*lambda",
        "node_mass": "rho/(8*k^3)=1/lambda",
        "total_mass": "8*rho*H^2*S",
        "rounding_denominator_slack_nonnegative_monomials": rounding_terms,
        "rounding_bound": "M*delta_R<=8*rho/(H*S*lambda^3)<=8*rho*lambda^(-8)",
        "rounding_hypotheses": ["H>=lambda^5", "S>=1", "lambda>=1"],
        "rounding_to_spacing_exponent": "-53/3",
        "ceiling_bounds": "lambda^5<=ceil(lambda^5)<lambda^5+1",
    }


def check_complement_and_scales():
    alpha, c, g, C, m = sp.symbols("alpha c g C m", positive=True)
    beta, a, x, y = sp.symbols("beta a x y", real=True)
    assert_zero(
        alpha * y**2 - 2 * beta * x * y + beta**2 * x**2 / alpha
        - (alpha * y - beta * x) ** 2 / alpha
    )
    assert_zero(
        c * y**2 - 2 * a * x * y - a * x**2
        - (c * y**2 / 2 - (a + 2 * a**2 / c) * x**2)
        - (c * y - 2 * a * x) ** 2 / (2 * c)
    )
    theta = g / (2 * (g + C * m + 1))
    kappa = g / (4 * (g + C * m + 1))
    assert_zero(theta / 2 - kappa)
    assert_zero((1 - theta) * g - theta * C * m - g / 2 - theta)
    assert_zero(g / 2 - kappa - g * (2 * (g + C * m) + 1) / (4 * (g + C * m + 1)))
    residual = sp.Rational(9, 10)
    form = sp.Rational(1)
    compression = sp.Rational(4, 3)
    beta_exponent = min(residual, form, sp.Rational(1))
    complement = 2 * beta_exponent
    amplified_complement = complement - 1
    amplified_compression = compression - 1
    comparison = min(sp.Rational(1, 10), amplified_complement, amplified_compression)
    assert complement == sp.Rational(9, 5)
    assert amplified_complement == sp.Rational(4, 5)
    assert amplified_compression == sp.Rational(1, 3)
    assert comparison == sp.Rational(1, 10)
    assert form >= sp.Rational(2, 3)
    assert complement >= sp.Rational(4, 3)
    assert sp.Rational(3 * 5 + 3) - sp.Rational(1, 3) == sp.Rational(53, 3)
    return {
        "square_completion": "alpha*y^2-2*beta*x*y+beta^2*x^2/alpha=(alpha*y-beta*x)^2/alpha",
        "one_particle_lower_bound": "Lc>=(c/2)*Q-(a+2*a^2/c)*I",
        "kinetic_weight": "g/(2*(g+C*m+1))",
        "coercivity": "kappa=g/(4*(g+C*m+1))",
        "hypotheses": [
            "c>0, C>=0, m>=1, m*(a+2*a^2/c)<=c/4, g=c/4",
            "eta=m*epsilon_f<=kappa/2",
            "d=m*a+m*epsilon_c+lambda^(-1)*R0<=kappa/4",
            "K_P bounds one-particle kinetic energy, L=sqrt(1+m*K_P)",
            "R0=m*(m-1)*sqrt(K_P), beta=m*a+lambda^(-1)*R0+eta*L",
            "upstream continuous control (6) and continuous compressed matrix comparison (M)",
        ],
        "complement_energy_loss": "4*beta^2/kappa",
        "amplified_comparison": "delta0+lambda*m*epsilon_c+4*lambda*beta^2/kappa",
        "decay_exponents": {
            "form": rational_text(form),
            "compression": rational_text(compression),
            "beta": rational_text(beta_exponent),
            "complement": rational_text(complement),
            "amplified_compression": rational_text(amplified_compression),
            "amplified_complement": rational_text(amplified_complement),
            "total_comparison": rational_text(comparison),
        },
    }


def certificate():
    return {
        "claim": "C_UCR",
        "result_class": "improved_bound",
        "evidence_kind": "exact symbolic components of an analytic proof",
        "independent_review": "pending",
        "novelty": "not established by bounded literature search",
        "proof": "proof.md",
        "scope": "Equation (7), strengthened form estimate, and transfer through the complement conditional on upstream (6) and (M).",
        "moments": check_moments(),
        "kernels": check_kernels(),
        "transport_rounding_counts": check_transport_rounding_and_counts(),
        "complement_scales": check_complement_and_scales(),
        "not_machine_checked": [
            "distributional and Sobolev integration-by-parts passages",
            "Taylor remainder and geometric cube-sum estimates",
            "flow regularity and mode-decay application",
            "the upstream spectral control (6) and continuous matrix input (M)",
            "either complete QMA-hardness reduction",
            "publishability and novelty",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="ascii")
    else:
        expected = json.loads(path.read_text(encoding="ascii"))
        if expected != result:
            raise AssertionError("The exact certificate does not match the recomputed result.")
    print(json.dumps({
        "ok": True,
        "tensor_monomials": result["moments"]["tensor_monomials_checked"],
        "vector_derivatives": result["kernels"]["vector_derivatives"]["partial_derivatives_checked"],
        "scalar_derivatives": result["kernels"]["scalar_derivatives"]["partial_derivatives_checked"],
        "decay_exponents": result["complement_scales"]["decay_exponents"],
        "analytic_and_independent_review": "not supplied by this script",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
