"""Finite identity diagnostics, not a proof of global additive generation."""

import itertools
import json
from datetime import datetime, timezone
from fractions import Fraction
from math import gcd
from pathlib import Path


def fmul(a, b):
    result = 0
    while b:
        if b & 1:
            result ^= a
        b >>= 1
        a <<= 1
        if a & 4:
            a ^= 7
    return result


def conjugate(a):
    return fmul(a, a)


def fsum(values):
    result = 0
    for value in values:
        result ^= value
    return result


def identity(n):
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def add(a, b):
    return tuple(tuple(x ^ y for x, y in zip(ra, rb)) for ra, rb in zip(a, b))


def scale(scalar, matrix):
    return tuple(tuple(fmul(scalar, value) for value in row) for row in matrix)


def multiply(a, b):
    n = len(a)
    return tuple(
        tuple(fsum(fmul(a[i][k], b[k][j]) for k in range(n)) for j in range(n))
        for i in range(n)
    )


def star(matrix):
    n = len(matrix)
    return tuple(tuple(conjugate(matrix[j][i]) for j in range(n)) for i in range(n))


def inverse(matrix):
    n = len(matrix)
    rows = [list(row) + list(unit) for row, unit in zip(matrix, identity(n))]
    for column in range(n):
        pivot = next((i for i in range(column, n) if rows[i][column]), None)
        if pivot is None:
            return None
        rows[column], rows[pivot] = rows[pivot], rows[column]
        rows[column] = [fmul(conjugate(rows[column][column]), x) for x in rows[column]]
        for i in range(n):
            if i != column:
                multiplier = rows[i][column]
                rows[i] = [x ^ fmul(multiplier, y) for x, y in zip(rows[i], rows[column])]
    return tuple(tuple(row[n:]) for row in rows)


def binary_rank(matrix):
    rows = [list(row) for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(rank, len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for i in range(len(rows)):
            if i != rank and rows[i][column]:
                rows[i] = [x ^ y for x, y in zip(rows[i], rows[rank])]
        rank += 1
    return rank


def hermitian_value(v, w):
    return fsum(fmul(conjugate(x), y) for x, y in zip(v, w))


def run():
    n = 3
    unit = identity(n)
    theta, theta_bar = 2, 3
    assert theta ^ theta_bar == 1
    tested = 0
    singular_denominators = 0
    for diagonal in itertools.product((0, 1), repeat=n):
        for upper in itertools.product(range(4), repeat=3):
            rows = [[0] * n for _ in range(n)]
            for i, value in enumerate(diagonal):
                rows[i][i] = value
            for (i, j), value in zip(((0, 1), (0, 2), (1, 2)), upper):
                rows[i][j], rows[j][i] = value, conjugate(value)
            x = tuple(tuple(row) for row in rows)
            assert star(x) == x
            denominator_inverse = inverse(add(x, scale(theta_bar, unit)))
            if denominator_inverse is None:
                singular_denominators += 1
                continue
            u = multiply(add(x, scale(theta, unit)), denominator_inverse)
            assert multiply(star(u), u) == unit
            inverse_u_minus_one = inverse(add(u, unit))
            assert inverse_u_minus_one is not None
            recovered = multiply(
                inverse_u_minus_one, add(scale(theta, unit), scale(theta_bar, u))
            )
            assert recovered == x
            tested += 1
    assert tested > 0
    assert tested + singular_denominators == 512

    vectors = list(itertools.product(range(4), repeat=n))
    isotropic = 0
    polar_checks = 0
    for v in vectors:
        qv = hermitian_value(v, v)
        assert qv in (0, 1)
        if any(v) and qv == 0:
            isotropic += 1
        for w in vectors:
            vw = tuple(x ^ y for x, y in zip(v, w))
            h = hermitian_value(v, w)
            assert hermitian_value(vw, vw) ^ qv ^ hermitian_value(w, w) == h ^ conjugate(h)
            polar_checks += 1
    basis = [
        tuple(value if i == coordinate else 0 for i in range(n))
        for coordinate in range(n)
        for value in (1, theta)
    ]
    polar = [
        [
            hermitian_value(v, w) ^ conjugate(hermitian_value(v, w))
            for w in basis
        ]
        for v in basis
    ]
    assert binary_rank(polar) == 2 * n
    assert isotropic > 0

    laurent_evaluation = tuple((1, value, conjugate(value)) for value in (1, 2, 3))
    assert inverse(laurent_evaluation) is not None

    prime, power = 5, 2
    lattice_vector = (3, -7, 11)
    x = tuple(Fraction(value, prime**power) for value in lattice_vector)
    error = (Fraction(1, 7), Fraction(2, 9), Fraction(-4, 11))
    a = tuple(target + delta for target, delta in zip(x, error))
    denominator = 7 * 9 * 11
    q = denominator * pow(denominator, -1, prime**power)
    assert gcd(q, prime) == 1
    assert (q - 1) % prime**power == 0
    cleared_error = tuple(q * delta for delta in error)
    congruence_error = tuple((q - 1) * target for target in x)
    assert all(value.denominator == 1 for value in cleared_error + congruence_error)
    assert tuple(
        q * value - integral_error - congruence_term
        for value, integral_error, congruence_term in zip(a, cleared_error, congruence_error)
    ) == x

    return {
        "scope": "Finite split-matrix identities and one rational CRT fixture only; "
        "not global division-algebra, approximation, isotropy-bound, or generation certification.",
        "field": "F_4 = F_2[theta]/(theta^2+theta+1)",
        "cayley": {
            "matrix_size": n,
            "hermitian_matrices": tested + singular_denominators,
            "invertible_denominator_cases": tested,
            "excluded_singular_denominators": singular_denominators,
            "unitarity_and_inverse_checks_passed": True,
        },
        "hermitian_quadratic_form": {
            "underlying_F2_dimension": 2 * n,
            "polar_rank": binary_rank(polar),
            "polar_identity_pairs": polar_checks,
            "nonzero_isotropic_vectors": isotropic,
        },
        "laurent_weights": "1, lambda, lambda^-1 have independent evaluations in characteristic two",
        "rational_crt": {"prime": prime, "exponent": power, "q": q, "identity_passed": True},
        "all_diagnostics_passed": True,
        "completed_at": datetime.now(timezone.utc).isoformat(),
    }


if __name__ == "__main__":
    result = run()
    Path(__file__).with_name("identity_checks.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))
