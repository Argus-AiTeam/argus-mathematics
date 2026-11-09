"""Replay exact algebra used by the dyadic Enriques construction."""

import json
from itertools import combinations
from pathlib import Path
import subprocess

import sympy as sp


BASE = Path(__file__).resolve().parent
pi, s, r, rr, h, x, y, z, w, c = sp.symbols("pi s r rr h x y z w c")
xi, xj, yi, yj = sp.symbols("xi xj yi yj")
identities = []


def reduced(expression, relations, variables):
    basis = sp.groebner(relations, *variables)
    return sp.expand(basis.reduce(sp.expand(expression))[1])


def identity(name, expression, relations, variables):
    remainder = reduced(expression, relations, variables)
    if remainder != 0:
        raise AssertionError(f"{name}: {remainder}")
    identities.append(name)


group_relations = [s**2 - pi*s, pi**2 - 2]
group_variables = [s, pi, xi, xj, yi, yj]
transformed_yi = s*xi + (1 - pi*s)*yi
transformed_yj = s*xj + (1 - pi*s)*yj
identity(
    "invariant_square",
    transformed_yi**2 - pi*xi*transformed_yi - (yi**2 - pi*xi*yi),
    group_relations, group_variables,
)
identity(
    "invariant_cross_with_minus_sign",
    xi*transformed_yj + xj*transformed_yi
    - pi*transformed_yi*transformed_yj - (xi*yj + xj*yi - pi*yi*yj),
    group_relations, group_variables,
)
chart_relations = [r**2 - pi*r - h, pi**2 - 2]
chart_variables = [r, pi, h, x, y, z, w]
d = 1 - pi*r
denominator = 1 + 2*h
identity("chart_denominator", d**2 - denominator,
         chart_relations, chart_variables)
identity(
    "chart_square_j",
    (z - x*r)**2 - pi*x*(z - x*r)*d - (z**2 - pi*x*z - x**2*h),
    chart_relations, chart_variables,
)
identity(
    "chart_square_k",
    (w - y*r)**2 - pi*y*(w - y*r)*d - (w**2 - pi*y*w - y**2*h),
    chart_relations, chart_variables,
)
identity(
    "chart_cross_jk",
    x*(w - y*r)*d + y*(z - x*r)*d
    - pi*(z - x*r)*(w - y*r)
    - (x*w + y*z - pi*z*w + pi*x*y*h),
    chart_relations, chart_variables,
)
identity(
    "torsor_difference_coordinate",
    (rr - r)**2 - pi*(rr - r)*d,
    [rr**2 - pi*rr - h, *chart_relations],
    [rr, r, pi, h],
)
identity(
    "no_homomorphism_polynomial",
    (c*s)**4 + 2*c*s - 2*c*(pi*c**3 + 1)*s,
    group_relations, [s, pi, c],
)

v, t = sp.symbols("v t")
elliptic_input = [v**2 + v + t**3, t*v + 2*t, v**2 + 2*v]
elliptic_basis = [v - t**3, t**4 + 2*t]
f1, f2, f3 = elliptic_input
g1, g2 = elliptic_basis
integral_identities = [
    ("elliptic_g1_over_Z", g1 - (f3 - f1)),
    ("elliptic_g2_over_Z", g2 - (f2 - t*g1)),
    ("elliptic_f1_over_Z", f1 - (v + t**3 + 1)*g1 - t**2*g2),
    ("elliptic_f2_over_Z", f2 - t*g1 - g2),
    ("elliptic_f3_over_Z", f3 - (v + t**3 + 2)*g1 - t**2*g2),
    ("elliptic_inverse_denominator_unit_over_Z", (1 + t**3)**2 - 1 - t**2*g2),
]
for name, polynomial in integral_identities:
    if sp.expand(polynomial) != 0:
        raise AssertionError(f"Integral two-torsion identity failed: {name}")
    identities.append(name)

typed_path = BASE / "jacobian-elliptic-output.json"
typed = json.loads(typed_path.read_text())
if typed["result"]["operation_id"] != "polynomial.ideal.groebner_basis.compute":
    raise AssertionError("Unexpected Jacobian operation")
result = typed["result"]["output"]
if result.get("outcome") != "COMPUTED":
    raise AssertionError(f"Jacobian is not a conclusion: {result.get('outcome')}")
payload = json.loads((BASE / "jacobian-elliptic-payload.json").read_text())
if result["request"] != payload:
    raise AssertionError("Jacobian response does not bind to the exact payload")
typed_generators = []
for generator in result["basis"]["generators"]:
    if generator["variables"] != ["v", "t"] or generator["domain"] != "QQ":
        raise AssertionError("Unexpected Jacobian coefficient ring")
    polynomial = sp.S.Zero
    for term in generator["polynomial"]["terms"]:
        coefficient = term["coefficient"]
        polynomial += (
            sp.Rational(coefficient["num"], coefficient["den"])
            * v**term["exponents"][0] * t**term["exponents"][1]
        )
    typed_generators.append(sp.expand(polynomial))
if typed_generators != elliptic_basis:
    raise AssertionError(f"Unexpected two-torsion equations: {typed_generators}")

singular = subprocess.run(
    ["Singular", "-q", str(BASE / "verify_special.sing")],
    text=True, capture_output=True, timeout=110, check=True,
)
if singular.stderr.strip() or "?" in singular.stdout or "FAILED_" in singular.stdout:
    raise RuntimeError(singular.stdout + singular.stderr)
for chart in (1, 2, 3):
    if singular.stdout.count(f"CERTIFIED_CHART_{chart}") != 1:
        raise AssertionError(f"Missing exact chart certificate {chart}")
if "ALL_THREE_GEOMETRIC_SINGULAR_SCHEMES_EMPTY" not in singular.stdout:
    raise AssertionError("Incomplete geometric smoothness result")

certificates = {}
chart = None
for line in singular.stdout.splitlines():
    if line.startswith("CERTIFIED_CHART_"):
        chart = int(line.rsplit("_", 1)[1])
        certificates[chart] = {"generator": {}, "coefficient": {}}
    elif line.startswith(("generator_", "coefficient_")):
        key, expression = line.split("=", 1)
        kind, index = key.split("_")
        certificates[chart][kind][int(index)] = sp.sympify(
            expression.replace("^", "**"), locals={"x": x, "y": y, "z": z, "w": w}
        )

x1, x2, x3 = sp.symbols("x1 x2 x3")
coordinates = [x1, x2, x3]
quadrics = [
    x1**2 + x2**2 + x2*x3 + x3**2,
    x1*x2 + x1*x3 + x2**2 + x2*x3,
    x1*x3 + x3**2,
]


def gf2(polynomial):
    return sp.Poly(polynomial, x, y, z, w, modulus=2).as_expr()


for i in range(3):
    j, k = (i + 1) % 3, (i + 2) % 3
    substitution = {coordinates[i]: 1, coordinates[j]: x, coordinates[k]: y}
    qi, qj, qk = [quadrics[index].subs(substitution) for index in (i, j, k)]
    chart_h = x*w + y*z + qi
    equations = [gf2(z**2 + x**2*chart_h + w + qj),
                 gf2(w**2 + y**2*chart_h + z + qk)]
    certificate = certificates[i + 1]
    generators, coefficients = certificate["generator"], certificate["coefficient"]
    if set(generators) != set(range(1, 9)) or set(coefficients) != set(range(1, 9)):
        raise AssertionError(f"Incorrect certificate size on chart {i + 1}")
    if [gf2(generators[n]) for n in (1, 2)] != equations:
        raise AssertionError(f"Certificate does not describe the model on chart {i + 1}")
    identities.append(f"chart_{i + 1}_model_equations_bound")
    jacobian = sp.Matrix(equations).jacobian([x, y, z, w])
    minors = [gf2(jacobian[:, columns].det()) for columns in combinations(range(4), 2)]
    if sorted(map(str, minors)) != sorted(str(gf2(generators[n])) for n in range(3, 9)):
        raise AssertionError(f"Incorrect singular ideal on chart {i + 1}")
    identities.append(f"chart_{i + 1}_all_jacobian_minors_bound")
    if gf2(sum(generators[n]*coefficients[n] for n in range(1, 9)) - 1) != 0:
        raise AssertionError(f"Bezout identity failed on chart {i + 1}")
    identities.append(f"chart_{i + 1}_bezout_replayed_over_F2")

(BASE / "special-smoothness-certificate.txt").write_text(singular.stdout)
print(json.dumps({
    "exact_symbolic_identities": identities,
    "identity_count": len(identities),
    "special_fiber_smooth_charts": [1, 2, 3],
    "bezout_identities": 3,
    "global_quadrics": [str(polynomial) for polynomial in quadrics],
    "special_certificate_independent_polynomial_replay": "SymPy over F_2",
    "geometric_not_rational_point_test": True,
    "jacobian_outcome": result["outcome"],
    "jacobian_payload_binding": "exact",
    "jacobian_basis": [str(polynomial) for polynomial in typed_generators],
    "mathematical_scope": "Exact polynomial certificates; not independent proof review or novelty certification.",
}, indent=2))
