#!/usr/bin/env python3
"""Exact arithmetic checks for the example in arithmetic_defect.md."""

import json
from fractions import Fraction
from itertools import combinations, product
from pathlib import Path


def determinant(rows):
    a = [[Fraction(x) for x in row] for row in rows]
    n = len(a)
    assert all(len(row) == n for row in a)
    value = Fraction(1)
    for i in range(n):
        pivot = next((j for j in range(i, n) if a[j][i]), None)
        if pivot is None:
            return 0
        if pivot != i:
            a[i], a[pivot] = a[pivot], a[i]
            value = -value
        value *= a[i][i]
        for j in range(i + 1, n):
            ratio = a[j][i] / a[i][i]
            for k in range(i, n):
                a[j][k] -= ratio * a[i][k]
    assert value.denominator == 1
    return value.numerator


def trim(coefficients):
    result = list(coefficients)
    while len(result) > 1 and result[-1] == 0:
        result.pop()
    return result


def divmod_mod(a, b, p):
    remainder = trim([c % p for c in a])
    divisor = trim([c % p for c in b])
    assert divisor != [0]
    quotient = [0] * max(1, len(remainder) - len(divisor) + 1)
    while remainder != [0] and len(remainder) >= len(divisor):
        shift = len(remainder) - len(divisor)
        coefficient = remainder[-1] * pow(divisor[-1], -1, p) % p
        quotient[shift] = coefficient
        for j, entry in enumerate(divisor):
            remainder[j + shift] = (remainder[j + shift] - coefficient * entry) % p
        remainder = trim(remainder)
    return trim(quotient), remainder


def gcd_mod(a, b, p):
    a, b = trim(a), trim(b)
    while b != [0]:
        a, b = b, divmod_mod(a, b, p)[1]
    inverse = pow(a[-1], -1, p)
    return [(entry * inverse) % p for entry in a]


def derivative(a):
    return [i * a[i] for i in range(1, len(a))]


def evaluate(a, x):
    value = 0
    for coefficient in reversed(a):
        value = value * x + coefficient
    return value


def resultant(a, b):
    m, n = len(a) - 1, len(b) - 1
    rows = []
    for i in range(n):
        rows.append([0] * i + list(reversed(a)) + [0] * (n - 1 - i))
    for i in range(m):
        rows.append([0] * i + list(reversed(b)) + [0] * (m - 1 - i))
    return determinant(rows)


def binary_rank(vectors):
    basis = {}
    for vector in vectors:
        while vector:
            pivot = vector.bit_length() - 1
            if pivot not in basis:
                basis[pivot] = vector
                break
            vector ^= basis[pivot]
    return len(basis)


def rotate_five(vector):
    return ((vector << 1) & 31) | (vector >> 4)


def main():
    f = [-1, -1, 0, 0, 0, 1]
    discriminant = resultant(f, derivative(f))
    assert discriminant == 2869 == 19 * 151
    assert discriminant % (19 * 19) != 0

    f3 = [coefficient % 3 for coefficient in f]
    tested_divisors = 0
    for degree in (1, 2):
        for lower in product(range(3), repeat=degree):
            assert divmod_mod(f3, list(lower) + [1], 3)[1] != [0]
            tested_divisors += 1
    assert tested_divisors == 12

    repeated_root = 13
    linear = [-repeated_root % 19, 1]
    quotient, remainder = divmod_mod(f, linear, 19)
    assert remainder == [0]
    cubic, remainder = divmod_mod(quotient, linear, 19)
    assert remainder == [0] and cubic == [10, 13, 7, 1]
    assert gcd_mod(cubic, derivative(cubic), 19) == [1]
    assert gcd_mod([c % 19 for c in f], derivative(f), 19) == linear
    assert evaluate(cubic, repeated_root) % 19 == 6 == 5 * 5 % 19
    node_value = evaluate(f, repeated_root)
    assert node_value == 371279 == 19 * 19541
    assert (node_value // 19) % 19 == 9
    family_modulus = 3 * 19 * 19
    assert family_modulus == 1083
    assert family_modulus % 3 == family_modulus % (19 * 19) == 0
    assert family_modulus // 19 == 57 and 57 % 19 == 0
    assert 3125 - 256 == discriminant

    minors = []
    for columns in combinations(range(6), 3):
        a, b, c = columns
        minor = determinant([[1, 1, 1], [a, b, c], [a * a, b * b, c * c]])
        assert minor == (b - a) * (c - a) * (c - b)
        assert minor != 0 and minor % 19 != 0
        minors.append({"columns": list(columns), "determinant": minor})
    assert len(minors) == 20
    assert minors[0]["determinant"] == minors[-1]["determinant"] == 2

    orbit_ranks = {}
    for vector in range(1, 32):
        if vector.bit_count() % 2:
            continue
        orbit = []
        current = vector
        for _ in range(5):
            orbit.append(current)
            current = rotate_five(current)
        assert current == vector
        orbit_ranks[vector] = binary_rank(orbit)
        assert orbit_ranks[vector] == 4
    assert len(orbit_ranks) == 15
    columns = [rotate_five((1 << i) | 16) & 15 for i in range(4)]
    matrix = [[(columns[j] >> i) & 1 for j in range(4)] for i in range(4)]
    assert matrix == [[1, 1, 1, 1], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0]]

    directory = Path(__file__).parent / "jacobian"
    payload = json.loads((directory / "f-mod-3.payload.json").read_text())
    response = json.loads((directory / "f-mod-3.output.json").read_text())
    adapter_status = json.loads((directory / "f-mod-3.status.json").read_text())
    operation = "polynomial.galois.factor_mod_p.compute"
    assert payload == {"field_order": 3, "coefficients": f3}
    assert response["request"] == {"operation_id": operation, "payload": payload}
    assert response["result"]["operation_id"] == operation
    output = response["result"]["output"]
    assert output["source_coefficients"] == f3 and output["field_order"] == 3
    assert output["unit"] == 1 and output["is_irreducible"] is True
    assert output["factor_count"] == output["distinct_factor_count"] == 1
    assert output["factors"] == [{"coefficients": f3, "multiplicity": 1}]
    assert adapter_status == {
        "operation_id": operation,
        "adapter_exit_status": 0,
        "timed_out": False,
    }

    certificate = {
        "kind": "exact_arithmetic_certificate_not_a_cohomological_proof",
        "coefficient_order": "ascending",
        "curve_polynomial": f,
        "discriminant": discriminant,
        "irreducible_mod_3": {
            "monic_degree_1_or_2_divisors_tested": tested_divisors,
            "divisors_found": 0,
        },
        "reduction_mod_19": {
            "double_root": repeated_root,
            "remaining_cubic": cubic,
            "cubic_squarefree": True,
            "cubic_at_double_root": 6,
            "square_root_at_node": 5,
            "f_at_13": node_value,
            "f_at_13_divided_by_19_mod_19": 9,
        },
        "diagonal_complete_intersection": {
            "parameters": list(range(6)),
            "three_column_minors": minors,
            "all_minors_nonzero_over_Q_and_F19": True,
            "fixed_plane_determinants": [2, 2],
        },
        "uniform_integer_family": {
            "constant_term": "-1 + 1083*t",
            "modulus": family_modulus,
            "unchanged_mod_3_and_mod_19_squared": True,
            "f_t_at_13_divided_by_19": "19541 + 57*t",
            "f_t_at_13_divided_by_19_mod_19": 9,
            "parameter_quantifier": "all integers t, by divisibility identities",
        },
        "five_cycle_on_even_subspace": {
            "matrix": matrix,
            "nonzero_vectors_checked": 15,
            "orbit_span_ranks": orbit_ranks,
        },
        "jacobian": {
            "server": response["server"],
            "protocol_version": response["protocol_version"],
            "operation_id": operation,
            "adapter_exit_status": 0,
            "exact_factorization_agrees": True,
        },
        "scope": "The manuscript, not this finite computation, proves extension, "
        "specialization, descent of all complex cycles, and the defect formula.",
    }
    print(json.dumps(certificate, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
