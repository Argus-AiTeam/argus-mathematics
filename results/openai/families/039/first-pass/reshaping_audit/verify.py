#!/usr/bin/env python3
"""Replay exact supplementary checks; the universal proof is in report.md."""

import argparse
import itertools
import json
import math
from collections import defaultdict
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent


def scalar(value, prime):
    return value % prime if prime else Q(value)


def inverse(value, prime):
    return pow(value, -1, prime) if prime else 1 / Q(value)


def rank(rows, prime):
    rows = [[scalar(x, prime) for x in row] for row in rows]
    pivot = 0
    for column in range(len(rows[0]) if rows else 0):
        found = next((i for i in range(pivot, len(rows)) if rows[i][column]), None)
        if found is None:
            continue
        rows[pivot], rows[found] = rows[found], rows[pivot]
        unit = inverse(rows[pivot][column], prime)
        rows[pivot] = [scalar(x * unit, prime) for x in rows[pivot]]
        for i in range(pivot + 1, len(rows)):
            if rows[i][column]:
                factor = rows[i][column]
                rows[i] = [
                    scalar(x - factor * y, prime)
                    for x, y in zip(rows[i], rows[pivot])
                ]
        pivot += 1
        if pivot == len(rows):
            break
    return pivot


def least_exponents(vectors, weight, prime):
    basis = {}
    for vector in vectors:
        row = {e: scalar(c, prime) for e, c in vector.items() if scalar(c, prime)}
        while row:
            exponent = min(row, key=lambda e: (sum(a * b for a, b in zip(e, weight)), e[-1], e))
            if exponent not in basis:
                unit = inverse(row[exponent], prime)
                basis[exponent] = {e: scalar(c * unit, prime) for e, c in row.items()}
                break
            factor = row[exponent]
            for e, c in basis[exponent].items():
                value = scalar(row.get(e, 0) - factor * c, prime)
                if value:
                    row[e] = value
                else:
                    row.pop(e, None)
    assert len(basis) == len(vectors), "A finite projection lost row dimension."
    return set(basis)


def convolution(a, b, degree, prime):
    result = [0] * (degree + 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b[: degree - i + 1]):
                if y:
                    result[i + j] += x * y
    if prime:
        result = [c % prime for c in result]
    return result


def formal_inverse(degree, prime):
    # r + 3r^2 + 2r^3 = xi-eta, x=r+r^2, y=eta+x*r.
    r = [0] * (degree + 1)
    for n in range(1, degree + 1):
        quadratic = sum(r[i] * r[n - i] for i in range(1, n))
        cubic = sum(
            r[i] * r[j] * r[n - i - j]
            for i in range(1, n)
            for j in range(1, n - i)
        )
        r[n] = (1 if n == 1 else 0) - 3 * quadratic - 2 * cubic
        if prime:
            r[n] %= prime
    r2 = convolution(r, r, degree, prime)
    x = [r[i] + r2[i] for i in range(degree + 1)]
    if prime:
        x = [c % prime for c in x]
    z = convolution(x, r, degree, prime)
    return x, z


def powers(series, maximum, degree, prime):
    result = [[1] + [0] * degree]
    for _ in range(maximum):
        result.append(convolution(result[-1], series, degree, prime))
    return result


def monomial_expansion(i, j, xpowers, zpowers, degree, prime):
    result = defaultdict(int)
    for ell in range(j + 1):
        coefficients = convolution(xpowers[i], zpowers[j - ell], degree, prime)
        for k, coefficient in enumerate(coefficients[: degree - ell + 1]):
            if coefficient:
                for h in range(k + 1):
                    result[(k - h, h + ell)] += (
                        coefficient * math.comb(j, ell) * math.comb(k, h) * (-1) ** h
                    )
    return {e: scalar(c, prime) for e, c in result.items() if scalar(c, prime)}


def compress(support, axis, prime):
    rows = defaultdict(list)
    for exponent in support:
        label = exponent[:axis] + exponent[axis + 1 :]
        rows[label].append(exponent[axis])
    result = set()
    for label, exponents in rows.items():
        minimum = min(exponents)
        vectors = [
            {(h,): math.comb(a - minimum, h) for h in range(a - minimum + 1)}
            for a in sorted(exponents)
        ]
        for (h,) in least_exponents(vectors, (1,), prime):
            result.add(label[:axis] + (h,) + label[axis:])
    assert len(result) == len(support)
    return result


def cross(a, b, c):
    return (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])


def hull(points):
    points = sorted(set(points))
    lower, upper = [], []
    for chain, ordered in ((lower, points), (upper, reversed(points))):
        for point in ordered:
            while len(chain) >= 2 and cross(chain[-2], chain[-1], point) <= 0:
                chain.pop()
            chain.append(point)
    return lower[:-1] + upper[:-1]


def area(polygon):
    return abs(sum(
        p[0] * q[1] - p[1] * q[0]
        for p, q in zip(polygon, polygon[1:] + polygon[:1])
    )) / 2


def contains(polygon, point):
    return all(
        cross(a, b, point) >= 0
        for a, b in zip(polygon, polygon[1:] + polygon[:1])
    )


def vertical_length(polygon, x):
    values = []
    for p, q in zip(polygon, polygon[1:] + polygon[:1]):
        if p[0] == q[0]:
            if x == p[0]:
                values.extend((p[1], q[1]))
        elif min(p[0], q[0]) <= x <= max(p[0], q[0]):
            values.append(p[1] + (q[1] - p[1]) * (x - p[0]) / (q[0] - p[0]))
    assert values
    return max(values) - min(values)


def direction(H, d, w):
    W, R = d * H, H / w
    T = d * W
    assert H > 0 and d > 0 and w > 0 and T >= 6 and d * w < Q(1, 3)
    a0 = W * T / (1 + T)
    L, U = d * (R - 3 * W), d * (R - 3 * a0)
    assert U - L == 3 * T / (1 + T) > 2
    i = math.floor(L) + 1
    if i % 3 == 0:
        i += 1
    assert L < i < U and math.gcd(i, 3) == 1
    if i % 3 == 1:
        p, q = i // 3, 1
    else:
        p, q = -(i // 3) - 1, -1
    assert i * q - 3 * p == 1
    a, b = (R - Q(i) / d) / 3, W - (R - Q(i) / d) / 3
    t = a / b
    assert a0 < a < W and b > 0 and t > T
    assert a == W * t / (1 + t) and b == W / (1 + t)
    assert -3 * a < 3 * b < Q(i) / d and Q(i) / d + 3 * a == R
    return a, b, t, i, p, q


def geometry_checks():
    cases = 0
    for A, B, ratio in itertools.product(
        (Q(1, 7), Q(1), Q(3), Q(11, 2)),
        (Q(2, 9), Q(2), Q(7, 3)),
        (Q(1, 32), Q(1, 8), Q(1, 4), Q(3, 10), Q(333, 1000)),
    ):
        H, d = A * B, max(3 / A, 2 / B)
        W, c, T = d * H, 1 / d, d * d * H
        assert W == max(2 * A, 3 * B) and T >= 6
        w, R = ratio / d, H / (ratio / d)
        a, b, t, i, p, q = direction(H, d, w)
        assert c / a + c / b == (1 + t) ** 2 / (T * t) > 1
        Qpoly = hull([(Q(0), Q(0)), (a, Q(0)), (c, c), (Q(0), b)])
        sheared = hull([(x - y, y) for x, y in Qpoly])
        P = hull([(-b, Q(0)), (a, Q(0)), (Q(0), c)])
        assert area(Qpoly) == area(P) == H / 2
        for x in (-b, -b / 2, Q(0), a / 3, a):
            expected = c * (1 + x / b) if x <= 0 else c * (1 - x / a)
            assert vertical_length(sheared, x) == expected
            assert vertical_length(P, x) == expected
        changed = hull([(q * x - p * y, -3 * x + i * y) for x, y in P])
        q0, q1, q2 = -3 * a, 3 * b, Q(i) / d
        assert sorted(y for _, y in changed) == [q0, q1, q2]
        tent = hull([(Q(0), q0), (w, q1), (Q(0), q2)])
        assert area(changed) == area(tent) == H / 2
        for h in (Q(0), w / 3, w / 2, w):
            assert vertical_length(tent, h) == R * (1 - h / w)
        cases += 1
    return cases


def simplex_support(N, intercepts):
    ranges = [range(math.floor(N * a) + 1) for a in intercepts]
    return {
        e for e in itertools.product(*ranges)
        if sum(Q(x) / a for x, a in zip(e, intercepts)) <= N
    }


def binomial_integer(a, b):
    product = math.prod(a - j for j in range(b))
    divisor = math.factorial(b)
    assert product % divisor == 0
    return product // divisor


def multiindices(n, m):
    return [e for e in itertools.product(range(m + 1), repeat=n) if sum(e) <= m]


def jet_rank(support, points, orders, prime):
    support = sorted(support)
    rows = []
    for point, order in zip(points, orders):
        for beta in multiindices(len(point), order):
            row = []
            for exponent in support:
                value = scalar(1, prime)
                for a, b, coordinate in zip(exponent, beta, point):
                    factor = (
                        pow(coordinate, a - b, prime)
                        if prime else Q(coordinate) ** (a - b)
                    )
                    value = scalar(value * binomial_integer(a, b) * factor, prime)
                row.append(value)
            rows.append(row)
    return rank(rows, prime)


def graded(family):
    for N, left in family.items():
        for M, right in family.items():
            if N + M in family:
                assert {
                    tuple(a + b for a, b in zip(x, y)) for x in left for y in right
                } <= family[N + M]


def support_checks(prime, dimension, maximum):
    A, B, H, d, w = Q(3), Q(2), Q(6), Q(1), Q(3, 10)
    a, b, t, i, p, q = direction(H, d, w)
    assert t == 8
    intercepts = (A, B) if dimension == 2 else (A, B, Q(2, 3))
    original = {N: simplex_support(N, intercepts) for N in range(1, maximum + 1)}
    families = [original] + [{} for _ in range(5)]
    node_identity_checks = 0
    for N, support in original.items():
        degree = 9 * N + 1
        x, z = formal_inverse(degree, prime)
        xpowers = powers(x, 3 * N, degree, prime)
        zpowers = powers(z, 2 * N, degree, prime)
        expansions = {
            (aa, bb): monomial_expansion(aa, bb, xpowers, zpowers, degree, prime)
            for aa, bb in {(e[0], e[1]) for e in support} | {(3, 0), (1, 1), (0, 2)}
        }
        node = defaultdict(int)
        for pair, sign in (((0, 2), 1), ((1, 1), 1), ((3, 0), -1)):
            for exponent, coefficient in expansions[pair].items():
                node[exponent] += sign * coefficient
        node = {e: scalar(c, prime) for e, c in node.items() if scalar(c, prime)}
        assert node == {(1, 1): scalar(1, prime)}
        node_identity_checks += 1
        rows = defaultdict(list)
        for exponent in sorted(support):
            rows[exponent[2:]].append(expansions[exponent[:2]])
        nodal = set()
        for label, vectors in rows.items():
            values = least_exponents(vectors, (Q(1), t), prime)
            assert all(aa + t * bb < degree + 1 for aa, bb in values)
            nodal.update(pair + label for pair in values)
        families[1][N] = nodal
        sheared = {(e[0] - e[1], e[1]) + e[2:] for e in nodal}
        families[2][N] = compress(sheared, 1, prime)
        families[3][N] = {
            (q * e[0] - p * e[1], -3 * e[0] + i * e[1]) + e[2:]
            for e in families[2][N]
        }
        families[4][N] = compress(families[3][N], 0, prime)
        families[5][N] = compress(families[4][N], 1, prime)
        polygons = [
            hull([(Q(0), Q(0)), (a, Q(0)), (Q(1), Q(1)), (Q(0), b)]),
            hull([(-b, Q(0)), (a, Q(0)), (Q(0), Q(1))]),
        ]
        polygons.append(hull([(q * xx - p * yy, -3 * xx + i * yy) for xx, yy in polygons[1]]))
        polygons.append(hull([(Q(0), -3 * a), (w, 3 * b), (Q(0), Q(i))]))
        polygons.append(hull([(Q(0), Q(0)), (w, Q(0)), (Q(0), H / w)]))
        for stage, polygon in zip(families[1:6], polygons):
            current = stage[N]
            assert len(current) == len(support)
            assert sorted(e[2:] for e in current) == sorted(e[2:] for e in support)
            for exponent in current:
                residual = Q(N) - (Q(exponent[2]) / intercepts[2] if dimension == 3 else 0)
                assert residual >= 0
                if residual == 0:
                    assert exponent[:2] == (0, 0)
                else:
                    assert contains(polygon, (Q(exponent[0]) / residual, Q(exponent[1]) / residual))
        for order in range(4):
            ranks = [
                jet_rank(family[N], [(1,) * dimension], [order], prime)
                for family in families[:6]
            ]
            assert all(x >= y for x, y in zip(ranks, ranks[1:]))
    for family in families:
        graded(family)
    final = families[5]
    mixed = mixed_jet_checks(families, prime) if prime == 5 and dimension == 2 else []
    return {
        "characteristic": prime,
        "dimension": dimension,
        "degrees": list(original),
        "cardinalities": [len(original[N]) for N in original],
        "node_identity_truncations": node_identity_checks,
        "one_point_jet_orders": [0, 1, 2, 3],
        "final_supports": {str(N): sorted(final[N]) for N in final},
        "residual_degree_zero_tested": dimension == 3 and maximum >= 3,
        "mixed_jet_profiles": mixed,
    }


def mixed_jet_checks(families, prime):
    tuples = [
        ((1, 1), point)
        for point in itertools.product(range(1, prime), repeat=2)
        if point != (1, 1)
    ]
    profiles = []
    for N in families[0]:
        for orders in ((0, 1), (1, 2)):
            ranks = [
                max(jet_rank(family[N], points, orders, prime) for points in tuples)
                for family in families
            ]
            assert all(x >= y for x, y in zip(ranks, ranks[1:]))
            profiles.append({
                "degree": N,
                "orders": orders,
                "distinct_normalized_tuples": len(tuples),
                "finite_field_maxima_by_stage": ranks,
            })
    return profiles


def verify_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    assert status["adapter_exit_code"] == 0 and not status["timeout"]
    assert output["request"]["operation_id"] == "prime_field.matrix.rank.compute"
    assert output["request"]["payload"] == payload
    result = output["result"]["output"]
    assert result["source"] == payload
    assert result["rank"] == rank(payload["matrix"]["entries"], payload["matrix"]["prime"]) == 2
    return {"operation_id": output["request"]["operation_id"], "rank": result["rank"], "server": output["server"]["version"], "protocol": output["protocol_version"]}


def certificate():
    cases = geometry_checks()
    supports = [
        support_checks(prime, dimension, maximum)
        for prime, dimension, maximum in ((0, 2, 2), (2, 3, 3), (3, 3, 3), (5, 2, 4))
    ]
    assert compress({(0,), (2,)}, 0, 2) == {(0,), (2,)}
    assert compress({(-3,), (-1,)}, 0, 2) == {(0,), (2,)}
    return {
        "resolved_statement": "Universal two-intercept reshaping for dw<1/3, hence the staged dw<1/16 claim.",
        "mathematical_proof": "report.md",
        "formal_claim": "C_RS_HEIGHT",
        "formal_declaration": "ReshapingAudit.fixed_three_height",
        "formal_replay": "Use the prescribed lean_evidence verify command; this Python script does not invoke Lean.",
        "coverage_boundary": "Finite computations below are supplementary, not the proof of arbitrary reals, every characteristic, every degree, or every jet profile. Those quantifiers are proved in report.md; the universal primitive-height step is additionally formalized in Main.lean.",
        "rational_geometry_cases": cases,
        "support_compositions": supports,
        "frobenius_gap_and_negative_exponents": "verified",
        "jacobian": verify_jacobian(),
        "main_maximality_theorems": "not audited",
        "independent_review": "required; not asserted by this certificate",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = json.loads(json.dumps(certificate()))
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        assert result == expected, "The exact replay differs from exact_certificate.json."
    print(json.dumps({
        "status": "verified",
        "rational_geometry_cases": result["rational_geometry_cases"],
        "support_compositions": len(result["support_compositions"]),
        "formal_proof_replayed_by_python": False,
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
