#!/usr/bin/env python3
"""Replay the exact angular-cover certificate; no numerical sampling is a proof."""

import argparse
import itertools
import json
import math
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
R = sp.Rational
EPS = R(1, 2000)
ETA = R(1, 1000)
N = 8_000_000
DELTA = R(2, N)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, label):
    require(sp.cancel(sp.expand(expression)) == 0, label)


def d(q):
    return q**2 * (1 + q**2) / 16


def alpha(a, b):
    return (1 + a * b) / 4


def beta(a, b):
    return (a + b) / 4


def phi(q):
    return (1 - q**2) / 4


def bernstein_certificate(label, expression, variables):
    """Check an exact tensor-Bernstein expansion on the closed unit cube."""
    polynomial = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
    degrees = tuple(polynomial.degree(v) for v in variables)
    coefficients = {}
    for index in itertools.product(*(range(degree + 1) for degree in degrees)):
        value = sp.S.Zero
        for powers, coefficient in polynomial.terms():
            if all(k <= i for k, i in zip(powers, index)):
                value += coefficient * sp.prod(
                    R(math.comb(i, k), math.comb(degree, k))
                    for i, k, degree in zip(index, powers, degrees)
                )
        coefficients[index] = value
    reconstructed = sp.S.Zero
    for index, coefficient in coefficients.items():
        reconstructed += coefficient * sp.prod(
            math.comb(degree, i) * v**i * (1 - v) ** (degree - i)
            for v, degree, i in zip(variables, degrees, index)
        )
    zero(reconstructed - expression, label + ": Bernstein basis identity")
    minimum = min(coefficients.values())
    require(minimum >= 0, label + ": negative Bernstein coefficient")
    return {
        "inequality": label,
        "degrees": list(degrees),
        "coefficient_count": len(coefficients),
        "minimum_coefficient": str(minimum),
    }


def algebra_and_uniform_bounds():
    a, b, e, x, y, p, q, al, ar, bl, br, M, U, E, eta, delta = sp.symbols(
        "a b e x y p q al ar bl br M U E eta delta"
    )
    zero(alpha(a, b) - a * beta(a, b) - phi(a), "left shared plane")
    zero(alpha(a, b) - b * beta(a, b) - phi(b), "right shared plane")
    zero(alpha(-b, -a) - alpha(a, b), "reflection of alpha")
    zero(beta(-b, -a) + beta(a, b), "reflection of beta")
    zero(d(-q) - d(q), "reflection of the cap")
    zero(
        d(b) - d(q) - (b**2 - q**2) * (1 + b**2 + q**2) / 16,
        "d is increasing in squared absolute radius",
    )
    residual_sum = a + b + e * x * bl - e * y * br
    residual_q = q * a - y + e * x * al + q / 2
    residual_p = p * b - x - e * y * ar + p / 2
    budget = (
        a * (1 - e * x * q) + b * (1 + e * y * p)
        - e**2 * (x**2 * al + y**2 * ar)
        + e * x * (bl - q / 2) - e * y * (br - p / 2)
    )
    zero(
        budget - (residual_sum - e * x * residual_q + e * y * residual_p),
        "radial budget as an exact combination of intercept equations",
    )
    reference = (p**2 + q**2 + 2 * p**2 * q**2) / 16
    zero(
        d(p) + d(q) - reference - (p**2 - q**2) ** 2 / 16,
        "surplus, including its zero locus",
    )
    energy_residual = (
        (x**2 - p**2 / 4) * al + (y**2 - q**2 / 4) * ar
        + p**2 / 4 * (al - (1 + q**2) / 4)
        + q**2 / 4 * (ar - (1 + p**2) / 4)
    )
    zero(x**2 * al + y**2 * ar - reference - energy_residual,
         "quadratic energy decomposition")
    gap = 2 * eta - e * (R(1, 4) + 2 * eta) - R(3, 2) * e - delta / 4 - delta / (4 * e)
    W = (M + U) * (1 - e) - E - delta / (4 * e)
    positive_decomposition = (
        M + U - d(p) - d(q) - 2 * eta
        + e * (R(1, 4) + 2 * eta - M - U)
        + d(p) + d(q) + R(3, 2) * e + delta / 4 - E
    )
    zero(W - gap - positive_decomposition, "radial contradiction decomposition")
    exact_gap = gap.subs({e: EPS, eta: ETA, delta: DELTA})
    require(exact_gap == R(15983, 16000000) and exact_gap > 0, "positive radial gap")
    require(DELTA == EPS**2 and N == 2 / EPS**2, "exact prescribed mesh")

    u, v = sp.symbols("u v")
    left = -1 + (2 - DELTA) * u
    right = left + DELTA
    slope = left + DELTA * v
    aj, bj = alpha(left, right), beta(left, right)
    expressions = [
        ("q>=-1", slope + 1),
        ("q<=1", 1 - slope),
        ("alpha>=0", aj),
        ("alpha<=1/2", R(1, 2) - aj),
        ("beta>=-1/2", bj + R(1, 2)),
        ("beta<=1/2", R(1, 2) - bj),
        ("beta-q/2<=Delta/4", DELTA / 4 - (bj - slope / 2)),
        ("beta-q/2>=-Delta/4", DELTA / 4 + (bj - slope / 2)),
        ("alpha-(1+q^2)/4<=Delta/2", DELTA / 2 - (aj - (1 + slope**2) / 4)),
        ("alpha-(1+q^2)/4>=-Delta/2", DELTA / 2 + (aj - (1 + slope**2) / 4)),
    ]
    bounds = [bernstein_certificate(label, expr, (u, v)) for label, expr in expressions]
    bounds.append(bernstein_certificate("d(q)<=1/8", R(1, 8) - d(2 * u - 1), (u,)))
    bounds.append(bernstein_certificate("phi(q)>=0", phi(2 * u - 1), (u,)))
    residual = EPS * (2 * v - 1)
    square_difference = ((2 * u - 1) / 2 + residual) ** 2 - (2 * u - 1) ** 2 / 4
    for sign in (-1, 1):
        bounds.append(bernstein_certificate(
            f"square error sign {sign}", R(3, 2) * EPS - sign * square_difference, (u, v)
        ))
    bounds.append(bernstein_certificate(
        "coordinate product<=1", 1 - (2 * u - 1) * (2 * v - 1), (u, v)
    ))
    z = sp.Symbol("z")
    majorant = 1 - z / 2 + 3 * z**2 / 8
    zero(majorant - R(5, 6) - R(3, 8) * (z - R(2, 3)) ** 2,
         "majorant is positive")
    zero(9 * z**2 - 15 * z + 40 - 9 * (z - R(5, 6)) ** 2 - R(135, 4),
         "majorant product residual is positive")
    zero(majorant**2 * (1 + z) - 1 - z**3 * (9 * z**2 - 15 * z + 40) / 64,
         "majorant dominates the reciprocal square root")
    return {
        "identities": "shared planes, reflections, cap monotonicity, intercept combination, energy decomposition, surplus, gap decomposition, radical majorant",
        "universal_interval_certificates": bounds,
        "coverage_gap": str(exact_gap),
        "surplus": "(p^2-q^2)^2/16 >= 0; equality is permitted",
        "gap_argument": "W-gap is the sum of cap-lower slack, eps times cap-upper slack, and energy-upper slack. Strict double cap failure gives W<0.",
    }


def geometry():
    H = sp.sqrt(2)
    vertices = [sp.Matrix(v) for v in [(1, 0, 0), (-1, 0, 0), (0, 1, H), (0, -1, H)]]
    normals = []
    for opposite in range(4):
        face = [vertices[i] for i in range(4) if i != opposite]
        normal = (face[1] - face[0]).cross(face[2] - face[0]) / 2
        if sp.simplify(normal.dot(vertices[opposite] - face[0])) > 0:
            normal = -normal
        offset = sp.simplify(normal.dot(face[0]))
        for vertex in vertices:
            require(sp.simplify(offset - normal.dot(vertex)) >= 0, "outward face orientation")
        require(sp.simplify(normal.dot(normal)) == 3, "face area is sqrt(3)")
        normals.append(tuple(normal))
    require(set(normals) == {(0, H, -1), (0, -H, -1), (H, 0, 1), (-H, 0, 1)},
            "four exact face area vectors")
    require(sum((sp.Matrix(v) for v in normals), sp.zeros(3, 1)) == sp.zeros(3, 1),
            "sum of outward area vectors")
    U, V, ux, uy, uz = sp.symbols("U V ux uy uz")
    zero((U + V)**2 - ux**2 - uy**2 - uz**2
         - (U**2 - ux**2) - (V**2 - uy**2) - 2 * (U * V - uz**2 / 2),
         "projection minimum sum of nonnegative slacks")
    a, b, T, e, al, bl = sp.symbols("a b T e al bl")
    lower = sp.Matrix([0, a * T, H * T]).cross(sp.Matrix([0, b * T, H * T]))
    upper = sp.Matrix([a * T, 0, -H * T]).cross(sp.Matrix([b * T, 0, -H * T]))
    for component in lower - sp.Matrix([H * (a - b) * T**2, 0, 0]):
        zero(component, "lower triangle cross product")
    for component in upper - sp.Matrix([0, H * (a - b) * T**2, 0]):
        zero(component, "upper triangle cross product")
    for axis, component in [(sp.Matrix([1, e * al, H * e * bl]), 0),
                            (sp.Matrix([-e * al, 1, H * e * bl]), 1)]:
        zero(axis.dot(axis) - 1 - e**2 * (al**2 + 2 * bl**2), "axis norm")
        require(axis[component] == 1, "projection injectivity on intercept plane")
    return {
        "face_area_vectors": [[str(c) for c in v] for v in normals],
        "minimum_projection_area": "sqrt(2)",
        "intercept_triangle_area": "sqrt(2)*Delta*T_j^2/2",
        "perpendicular_projection_factor": "1/sqrt(1+eps^2*(alpha_j^2+2*beta_j^2))",
    }


def area_bound():
    half = N // 2
    r = sp.Symbol("r")
    left, right = r / half, (r + 1) / half
    aj, bj = alpha(left, right), beta(left, right)
    M = ETA + d(right)
    T = R(1, 2) + EPS**2 * M
    A = aj**2 + 2 * bj**2
    polynomial = sp.Poly(sp.expand(T**2 * (1 - EPS**2 * A / 2 + R(3, 8) * EPS**4 * A**2)),
                         r, domain=sp.QQ)
    degree = polynomial.degree()
    require(degree == 16, "degree of the exact rational area majorant")
    sums = []
    for k in range(degree + 1):
        zero((r + 1)**(k + 1) - r**(k + 1)
             - sum(math.comb(k + 1, j) * r**j for j in range(k + 1)),
             f"telescoping polynomial degree {k+1}")
        power_sum = (sp.Integer(half)**(k + 1)
                     - sum(math.comb(k + 1, j) * sums[j] for j in range(k))) / (k + 1)
        require(power_sum.q == 1 and power_sum >= 0, "integer power sum")
        sums.append(power_sum)
    upper = sp.cancel(R(2, half) * sum(
        coefficient * sums[powers[0]] for powers, coefficient in polynomial.terms()
    ))
    saving = R(1, 2) - upper
    require(saving > R(1, 2_000_000_000), "strict certified area saving")
    return {
        "method": "two reflected half-meshes; quadratic radical majorant; telescoping sums of powers, not sector enumeration or Taylor remainder",
        "half_mesh_intervals": half,
        "polynomial_degree": degree,
        "power_sums_used": len(sums),
        "normalized_area_upper_bound": str(upper),
        "normalized_area_saving_lower_bound": str(saving),
        "simpler_normalized_upper_bound": "1/2 - 1/2000000000",
        "strictly_below_one_half": True,
    }


def q_at(i):
    return -1 + DELTA * i


def coefficients(j):
    a, b = q_at(j), q_at(j + 1)
    M = ETA + max(d(a), d(b))
    return a, b, alpha(a, b), beta(a, b), R(1, 2) + EPS**2 * M


def bracket(F, target):
    lo, hi = 0, N
    require(F(lo) <= target <= F(hi), "finite bracket endpoints")
    while hi - lo > 1:
        mid = (lo + hi) // 2
        if target <= F(mid):
            hi = mid
        else:
            lo = mid
    require(F(lo) <= target <= F(hi), "closed adjacent bracket")
    return lo


def boundary_regressions():
    vertices = [(R(1), R(0), R(0)), (R(-1), R(0), R(0)),
                (R(0), R(1), R(1)), (R(0), R(-1), R(1))]
    points = {}
    for size in range(1, 5):
        for indices in itertools.combinations(range(4), size):
            points["vertex-average-" + "".join(map(str, indices))] = tuple(
                sum(vertices[i][axis] for i in indices) / size for axis in range(3)
            )
    for t in (EPS / 4, 1 - EPS / 4):
        for sx, sy in itertools.product((-1, 1), repeat=2):
            points[f"tip-edge-{t}-{sx}-{sy}"] = (sx * (1 - t), sy * t, t)
    for j in (0, N // 2 - 1, N // 2, N - 1):
        a, b, _, _, T = coefficients(j)
        for endpoint in (a, b):
            points[f"lower-cap-{j}-{endpoint}"] = (R(0), endpoint * T, T)
            points[f"upper-cap-{j}-{endpoint}"] = (endpoint * T, R(0), 1 - T)
    records = []
    for name, (x, y, t) in points.items():
        require(0 <= t <= 1 and abs(x) <= 1 - t and abs(y) <= t, name + ": in K")
        j = bracket(lambda i: q_at(i) * t + EPS * x * phi(q_at(i)), y)
        k = bracket(lambda i: q_at(i) * (1 - t) - EPS * y * phi(q_at(i)), x)
        a, b, al, bl, T = coefficients(j)
        c, f, ar, br, U = coefficients(k)
        t0, y0 = t - EPS * x * bl, y - EPS * x * al
        s0, x0 = 1 - t + EPS * y * br, x + EPS * y * ar
        require(t0 >= 0 and a * t0 <= y0 <= b * t0, name + ": lower sector")
        require(s0 >= 0 and c * s0 <= x0 <= f * s0, name + ": upper sector")
        lower_covers, upper_covers = bool(t0 <= T), bool(s0 <= U)
        require(lower_covers or upper_covers, name + ": exact closed membership")
        records.append({"case": name, "scaled_point": list(map(str, (x, y, t))),
                        "lower_sector": j, "upper_sector": k,
                        "lower_covers": lower_covers, "upper_covers": upper_covers})
    require(EPS * phi(q_at(N // 2)) > EPS * phi(q_at(N)),
            "nonmonotone endpoint sequence really occurs in K")
    return {
        "purpose": "regression tests only; universal coverage is the finite-bracket and radial-budget proof",
        "case_count": len(records),
        "nonmonotone_sequence_present": True,
        "cases": records,
    }


def jacobian_evidence():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timeout"]
            and status["adapter_error"] is None, "Jacobian execution is conclusive")
    operation = "polynomial.box.enclosure.compute"
    require(envelope["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian exact operation and payload")
    output = envelope["result"]["output"]
    require(envelope["result"]["operation_id"] == operation, "Jacobian operation id")
    require(output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"],
            "Jacobian output retains the actual input")
    lower = output["enclosure"]["lower"]
    upper = output["enclosure"]["upper"]
    require(R(lower["num"], lower["den"]) == R(15983, 16000000)
            and R(upper["num"], upper["den"]) == R(1, 500), "Jacobian exact enclosure")
    require(envelope["server"]["version"] == status["server_version"]
            and envelope["protocol_version"] == status["protocol_version"],
            "Jacobian server and protocol provenance")
    return {**status, "enclosure": output["enclosure"]}


def build_certificate():
    return {
        "claim": "C_ANGULAR_EXACT",
        "result_type": "exact_verification_theorem",
        "scope": "the explicit angular construction, not either companion approximation theorem",
        "parameters": {"eps": str(EPS), "eta": str(ETA), "n": N,
                       "Delta": str(DELTA), "cylinders": 2 * N},
        "coverage": algebra_and_uniform_bounds(),
        "geometry": geometry(),
        "area": area_bound(),
        "adversarial_boundary_regressions": boundary_regressions(),
        "jacobian": jacobian_evidence(),
        "external_mathematical_assumptions": [],
        "independent_review": "pending; neither this script nor the Engineer is the Reviewer",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the recomputed exact certificate")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "stored exact certificate matches replay")
    print(json.dumps({
        "verified": True, "claim": certificate["claim"],
        "cylinders": certificate["parameters"]["cylinders"],
        "coverage_gap": certificate["coverage"]["coverage_gap"],
        "normalized_area_upper_bound": certificate["area"]["simpler_normalized_upper_bound"],
        "independent_review": "pending",
    }))


if __name__ == "__main__":
    main()
