"""Exact pressure-comparison algebra, not a new pressure theorem."""

import json

import sympy as sp


k, E = sp.symbols("k E", positive=True)
alpha = sp.Rational(1, 2)
limits = {}

for sign in (1, -1):
    source = (
        (k**2 + alpha**2)
        / (2 * k**2 * (1 - alpha))
        * (1 - E**2)
        * sp.re(
            (1 - alpha + sp.I * k)
            * (1 + sign * E * sp.exp(-sp.I * (alpha - 2) * sp.pi))
            / (
                (1 + sign * E * sp.exp(sp.I * alpha * sp.pi))
                * (1 - E**2 * sp.exp(-2 * sp.I * (alpha - 1) * sp.pi))
            )
        )
    )
    reduced = (
        (k**2 + sp.Rational(1, 4))
        / k**2
        * (1 - E**2)
        * ((1 - E**2) / 2 + 2 * sign * k * E)
        / (1 + E**2) ** 2
    )
    assert sp.simplify(source - reduced) == 0
    value = sp.limit(reduced.subs(E, sp.exp(-sp.pi * k)), k, 0, dir="+")
    expected = sp.pi * (sp.pi + 2 * sign) / 8
    assert sp.simplify(value - expected) == 0
    limits["plus" if sign == 1 else "minus"] = str(expected)

p, s = sp.symbols("p s", real=True)
gap = p**2 + 2 * p - 8
assert sp.expand(gap.subs(p, 3 + s)) == s**2 + 8 * s + 7
assert gap.subs(p, 3) == 7
assert gap.subs(p, 4) == 16
assert sp.Rational(15, 8) > 1

x = sp.symbols("x1 x2 x3", real=True)
r_squared = sum(coordinate**2 for coordinate in x)
weight = r_squared ** sp.Rational(1, 4)
for coordinate in x:
    assert sp.simplify(
        sp.diff(weight, coordinate)
        - coordinate / (2 * r_squared ** sp.Rational(3, 4))
    ) == 0
assert sp.simplify(
    sum(sp.diff(weight, coordinate, 2) for coordinate in x)
    - 3 / (4 * r_squared ** sp.Rational(3, 4))
) == 0
for weight_power in (0, 1):
    gradient_scaling = 3 + weight_power - 2
    laplacian_scaling = 3 + weight_power - 4
    assert gradient_scaling - laplacian_scaling == 2

print(
    json.dumps(
        {
            "classification": "known_result_specialization",
            "source": "arxiv:0912.3958v2, Theorem 1.4, equation (1.9)",
            "parameters": {"sigma": "pi", "alpha": "1/2", "E": "exp(-pi*k)"},
            "symbol_identities": "both signs verified exactly",
            "limits_as_k_tends_to_zero_from_above": limits,
            "known_planar_coefficient_lower_bound": "pi*(pi+2)/8 > 15/8 > 1",
            "gap_polynomial_on_3_to_4": {
                "polynomial": "p^2+2*p-8",
                "shifted_polynomial": "s^2+8*s+7, s in [0,1]",
                "enclosure": ["7", "16"],
            },
            "weight_conjugation": (
                "grad(r^(1/2))=x/(2*r^(3/2)) and "
                "Delta(r^(1/2))=3/(4*r^(3/2)), exactly for r>0 in dimension 3"
            ),
            "squared_gradient_to_laplacian_scaling": (
                "R^2 for V_R(x)=V(x/R), in both unweighted and r-weighted norms"
            ),
            "scope": (
                "The unrestricted planar no-slip commutator class only. "
                "The elementary analytic facts 3<pi<4 and the source theorem "
                "are explained in radial-pressure-upper-bound.md, section 7. "
                "This is not a three-dimensional obstruction or novelty certificate."
            ),
        },
        indent=2,
    )
)
