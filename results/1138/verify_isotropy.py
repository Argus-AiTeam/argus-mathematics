"""Replay the exact Hopf algebra and Cartier-pairing identities."""

import json
from pathlib import Path

import sympy as sp


BASE = Path(__file__).resolve().parent
pi, s, s_prime, t, u = sp.symbols("pi s s_prime t u")
a1, a2, b1, b2, c1, c2 = sp.symbols("a1 a2 b1 b2 c1 c2")
identities = []


def reduced(expression, coordinates):
    # The monic relations give the free Z-basis pi^e prod(x_i^e_i), e,e_i in {0,1}.
    coefficients = {}
    polynomial = sp.Poly(sp.expand(expression), pi, *coordinates, domain=sp.ZZ)
    for exponents, coefficient in polynomial.terms():
        pi_degree = exponents[0] + sum(max(e - 1, 0) for e in exponents[1:])
        key = (pi_degree % 2, *(int(e > 0) for e in exponents[1:]))
        value = int(coefficient) * 2 ** (pi_degree // 2)
        coefficients[key] = coefficients.get(key, 0) + value
    return sp.expand(sum(
        coefficient * pi ** powers[0]
        * sp.prod(x ** e for x, e in zip(coordinates, powers[1:], strict=True))
        for powers, coefficient in coefficients.items()
    ))


def require(name, condition):
    if not condition:
        raise AssertionError(name)
    identities.append(name)


def identity(name, expression, coordinates):
    remainder = reduced(expression, coordinates)
    require(f"{name}: remainder={remainder}", remainder == 0)


def special(expression, coordinates):
    return sp.Poly(
        reduced(expression, coordinates).subs(pi, 0),
        *coordinates,
        modulus=2,
    ).as_expr()


def add(x, y):
    return x + y - pi * x * y


def character(x, y):
    return 1 - x * y


def hyperbolic(x1, x2, y1, y2):
    return character(x1, y2) * character(x2, y1)


identity("pi_square", pi**2 - 2, ())
identity("group_closed", add(s, t)**2 - pi * add(s, t), (s, t))
identity("group_identity", add(s, 0) - s, (s,))
identity("group_commutative", add(s, t) - add(t, s), (s, t))
identity("group_killed_by_two", add(s, s), (s,))
identity("group_associative", add(add(s, t), u) - add(s, add(t, u)), (s, t, u))
identity("character_unit", character(s, t)**2 - 1, (s, t))
require("character_parameter_equation_exact", sp.expand(
    character(add(s, t), u) - character(s, u) * character(t, u)
    + s * t * (u**2 - pi * u)
) == 0)
identity(
    "character_first_variable",
    character(add(s, t), u) - character(s, u) * character(t, u),
    (s, t, u),
)
identity(
    "character_second_variable",
    character(s, add(t, u)) - character(s, t) * character(s, u),
    (s, t, u),
)
identity(
    "dual_group_law",
    character(s, t) * character(s, u) - character(s, add(t, u)),
    (s, t, u),
)
identity("nonidentity_generic_value_minus_one", character(pi, pi) + 1, ())
identity("hyperbolic_alternating", hyperbolic(a1, a2, a1, a2) - 1, (a1, a2))
identity(
    "hyperbolic_skew",
    hyperbolic(a1, a2, b1, b2) * hyperbolic(b1, b2, a1, a2) - 1,
    (a1, a2, b1, b2),
)
identity(
    "hyperbolic_first_variable",
    hyperbolic(add(a1, b1), add(a2, b2), c1, c2)
    - hyperbolic(a1, a2, c1, c2) * hyperbolic(b1, b2, c1, c2),
    (a1, a2, b1, b2, c1, c2),
)
identity(
    "hyperbolic_second_variable",
    hyperbolic(a1, a2, add(b1, c1), add(b2, c2))
    - hyperbolic(a1, a2, b1, b2) * hyperbolic(a1, a2, c1, c2),
    (a1, a2, b1, b2, c1, c2),
)

left_basis = (1, a1, a2, a1 * a2)
right_basis = (1, b1, b2, b1 * b2)
kernel = sp.Poly(hyperbolic(a1, a2, b1, b2), a1, a2, b1, b2, domain=sp.ZZ)
matrix = sp.Matrix([
    [kernel.coeff_monomial(left * right) for right in right_basis]
    for left in left_basis
])
expected = sp.Matrix([[1, 0, 0, 0], [0, 0, -1, 0],
                      [0, -1, 0, 0], [0, 0, 0, 1]])
require("cartier_coefficient_matrix", matrix == expected)
require("cartier_integral_determinant_minus_one", matrix.det() == -1)
require("cartier_integral_inverse", matrix * matrix == sp.eye(4))
require("special_character_nontrivial", special(character(s, t) - 1, (s, t)) == s * t)
require("special_first_coordinate_square_zero", special(a1**2, (a1, a2)) == 0)
require("special_second_coordinate_square_zero", special(a2**2, (a1, a2)) == 0)
require("special_hyperbolic_alternating", special(
    hyperbolic(a1, a2, a1, a2) - 1, (a1, a2)
) == 0)
special_matrix = matrix.applyfunc(lambda entry: int(entry) % 2)
require("special_cartier_determinant_one", int(special_matrix.det()) % 2 == 1)

payload = json.loads((BASE / "jacobian-payload.json").read_text())
typed = json.loads((BASE / "jacobian-output.json").read_text())
contract = json.loads((BASE / "jacobian-contract.json").read_text())
operation = "modular.polynomial_identity.compute"
require("inspected_operation", contract["result"]["operation"]["operation_id"] == operation)
require("jacobian_operation", typed["result"]["operation_id"] == operation)
require("jacobian_exact_request", typed["request"] == {
    "operation_id": operation, "payload": payload
})
require("jacobian_modulus_and_variables", payload["modulus"] == 2 and
        payload["variables"] == ["s", "s_prime", "t"])


def polynomial(terms):
    return sp.expand(sum(
        int(term["coefficient"]) * sp.prod(
            x ** e for x, e in zip((s, s_prime, t), term["exponents"], strict=True)
        )
        for term in terms
    ))


left = polynomial(payload["left"])
right = polynomial(payload["right"])
require("payload_is_special_character_residual", sp.expand(
    left - ((1 + (s + s_prime) * t) - (1 + s * t) * (1 + s_prime * t))
) == 0)
require("payload_right_is_square_relation_multiple", right == s * s_prime * t**2)
require("independent_coefficientwise_identity", sp.Poly(
    left - right, s, s_prime, t, modulus=2
).is_zero)
require("character_residual_vanishes_on_alpha_two", special(left, (s, s_prime, t)) == 0)

output = typed["result"]["output"]
require("jacobian_exact_conclusion", output == {
    "comparison_scope": "FORMAL_COEFFICIENTWISE_IDENTITY",
    "identical": True,
    "modulus": 2,
    "normalized_left": [{"coefficient": 1, "exponents": [1, 1, 2]}],
    "normalized_right": [{"coefficient": 1, "exponents": [1, 1, 2]}],
    "residual": [],
    "variable_order": ["s", "s_prime", "t"],
})

print(json.dumps({
    "result": "passed",
    "exact_checks": len(identities),
    "identities": identities,
    "coefficient_ring": "Z[pi,s_i]/(pi^2-2,s_i^2-pi*s_i), using its free Z-basis",
    "cartier_pairing_matrix": [[int(x) for x in row] for row in matrix.tolist()],
    "cartier_determinant": int(matrix.det()),
    "special_cartier_matrix": [[int(x) for x in row] for row in special_matrix.tolist()],
    "jacobian": {
        "operation_id": operation,
        "server_version": typed["server"]["version"],
        "protocol_version": typed["protocol_version"],
        "runtime_ms": typed["result"]["runtime_ms"],
        "typed_conclusion": "FORMAL_COEFFICIENTWISE_IDENTITY",
        "identical": output["identical"],
    },
    "scope": "Exact Hopf and Cartier algebra only; semistable geometry, the universal theorem and novelty require the prose proof and independent review.",
}, indent=2))
