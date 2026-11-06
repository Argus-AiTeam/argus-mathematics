#!/usr/bin/env python3
"""Exact finite algebra for the stated Wall D(2) presentation; no topology oracle.

python3 verify.py exact_certificate.json
python3 verify.py --self-test
python3 verify.py --emit-certificate
python3 verify.py --emit-jacobian-payload
"""

import argparse
import copy
import itertools
import json
import math
import sys
from fractions import Fraction


GENERATORS = ("x1", "a1", "x2", "a2", "s")
RELATORS = (
    (("x1", 1), ("a1", 1), ("x1", -1), ("a1", -4)),
    (("x2", 1), ("a2", 1), ("x2", -1), ("a2", -3)),
    (("x1", 1), ("a2", -13)),
    (("s", 1), ("x2", 1), ("s", -1), ("a1", -5)),
)
ZERO = (Fraction(0), Fraction(0))
ONE = (Fraction(1), Fraction(0))
ZETA = (Fraction(0), Fraction(1))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def q(a, b=0):
    return (Fraction(a), Fraction(b))


def add(x, y):
    return (x[0] + y[0], x[1] + y[1])


def neg(x):
    return (-x[0], -x[1])


def mul(x, y):
    a, b = x
    c, d = y
    return (a * c - b * d, a * d + b * c - b * d)


def norm(x):
    a, b = x
    return a * a - a * b + b * b


def inverse(x):
    n = norm(x)
    require(n != 0, "division by zero in Q(zeta)")
    a, b = x
    return ((a - b) / n, -b / n)


def power(x, exponent):
    if exponent < 0:
        return power(inverse(x), -exponent)
    result = ONE
    while exponent:
        if exponent % 2:
            result = mul(result, x)
        x = mul(x, x)
        exponent //= 2
    return result


CHARACTER = (q(-1), ZETA, power(ZETA, 2), q(-1), ONE)
DISPLAYED_MATRIX = (
    (q(1, -1), q(-2), ZERO, ZERO, ZERO),
    (ZERO, ZERO, q(2), q(-2, -1), ZERO),
    (ONE, ZERO, ZERO, q(-1), ZERO),
    (ZERO, q(-1, -1), ONE, ZERO, q(2, 1)),
)


def word(blocks):
    result = []
    for generator, exponent in blocks:
        index = GENERATORS.index(generator) + 1
        result.extend([index if exponent > 0 else -index] * abs(exponent))
    return tuple(result)


def reduce_word(letters):
    result = []
    for letter in letters:
        if result and result[-1] == -letter:
            result.pop()
        else:
            result.append(letter)
    return tuple(result)


def invert_word(letters):
    return tuple(-letter for letter in reversed(letters))


def commutator(u, v):
    return reduce_word(u + v + invert_word(u) + invert_word(v))


WORDS = tuple(word(relator) for relator in RELATORS)


def fox(letters, character):
    row = [ZERO] * len(GENERATORS)
    prefix = ONE
    for letter in letters:
        index = abs(letter) - 1
        if letter > 0:
            row[index] = add(row[index], prefix)
            prefix = mul(prefix, character[index])
        else:
            prefix = mul(prefix, inverse(character[index]))
            row[index] = add(row[index], neg(prefix))
    return tuple(row), prefix


def determinant(matrix):
    size = len(matrix)
    require(all(len(row) == size for row in matrix), "nonsquare determinant")
    total = ZERO
    for permutation in itertools.permutations(range(size)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(size)
            for j in range(i + 1, size)
        )
        term = q((-1) ** inversions)
        for i, j in enumerate(permutation):
            term = mul(term, matrix[i][j])
        total = add(total, term)
    return total


def rank(matrix):
    a = [list(row) for row in matrix]
    pivot_row = 0
    for column in range(len(a[0])):
        pivot = next(
            (i for i in range(pivot_row, len(a)) if a[i][column] != ZERO),
            None,
        )
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        scale = inverse(a[pivot_row][column])
        a[pivot_row] = [mul(x, scale) for x in a[pivot_row]]
        for i in range(pivot_row + 1, len(a)):
            scale = a[i][column]
            a[i] = [
                add(x, neg(mul(scale, y)))
                for x, y in zip(a[i], a[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(a):
            break
    return pivot_row


def rational_determinant(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    result = Fraction(1)
    for column in range(len(a)):
        pivot = next(
            (i for i in range(column, len(a)) if a[i][column] != 0),
            None,
        )
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            a[column], a[pivot] = a[pivot], a[column]
            result = -result
        value = a[column][column]
        result *= value
        for i in range(column + 1, len(a)):
            scale = a[i][column] / value
            for j in range(column + 1, len(a)):
                a[i][j] -= scale * a[column][j]
    return result


def restriction_of_scalars(matrix):
    result = []
    for row in matrix:
        upper = []
        lower = []
        for a, b in row:
            upper.extend((a, -b))
            lower.extend((b, a - b))
        result.extend((upper, lower))
    return result


def expand_relator_product(factors):
    result = ()
    for index, conjugator, sign in factors:
        relator = WORDS[index]
        if sign == -1:
            relator = invert_word(relator)
        require(sign in (-1, 1), "invalid relator sign")
        result = reduce_word(
            result + conjugator + relator + invert_word(conjugator)
        )
    return result


def inverse_relator_product(factors):
    return [(index, conjugator, -sign) for index, conjugator, sign in reversed(factors)]


def conjugation_power_factors(index, x, a, multiplier, exponent):
    # x^m a x^-m a^(-multiplier^m), as a product of conjugates of r.
    factors = []
    for m in range(1, exponent + 1):
        factors = [(i, (x,) + c, sign) for i, c, sign in factors]
        factors += [
            (index, (a,) * (multiplier * j), 1)
            for j in range(multiplier ** (m - 1))
        ]
    return factors


def power_equality_factors(index, u, exponent):
    return [(index, u * j, 1) for j in reversed(range(exponent))]


def group_identity_witnesses():
    t1 = word((("x1", 2),))
    t2 = word((("x2", 3),))
    a1, a2, s = (2,), (4,), (5,)
    st2 = s + t2 + invert_word(s)
    b1 = conjugation_power_factors(0, 1, 2, 4, 2)
    b2 = conjugation_power_factors(1, 3, 4, 3, 3)
    p1 = power_equality_factors(2, (1,), 2)
    p2 = power_equality_factors(3, (5, 3, -5), 3)
    identities = (
        ("[t1,a1]=a1^15", commutator(t1, a1) + (-2,) * 15, b1),
        ("[t2,a2]=a2^26", commutator(t2, a2) + (-4,) * 26, b2),
        ("t1=a2^26", t1 + (-4,) * 26, p1),
        ("s*t2*s^-1=a1^15", st2 + (-2,) * 15, p2),
        (
            "t1=[t2,a2]",
            t1 + invert_word(commutator(t2, a2)),
            p1 + inverse_relator_product(b2),
        ),
        (
            "s*t2*s^-1=[t1,a1]",
            st2 + invert_word(commutator(t1, a1)),
            p2 + inverse_relator_product(b1),
        ),
    )
    result = []
    for name, target, factors in identities:
        target = reduce_word(target)
        require(expand_relator_product(factors) == target, "free-group identity: " + name)
        result.append({
            "identity": name,
            "target_free_word": list(target),
            "relator_conjugates": [
                {"relator": i + 1, "conjugator": list(c), "sign": sign}
                for i, c, sign in factors
            ],
        })
    return result


def serialize(x):
    return [str(x[0]), str(x[1])]


def chain_data(character):
    computed = [fox(w, character) for w in WORDS]
    require(all(value == ONE for _, value in computed), "character violates a relator")
    matrix = tuple(row for row, _ in computed)
    d1 = tuple(add(value, neg(ONE)) for value in character)
    compositions = []
    for row in matrix:
        total = ZERO
        for x, y in zip(row, d1):
            total = add(total, mul(x, y))
        require(total == ZERO, "Fox chain identity failed")
        compositions.append(total)
    return matrix, d1, compositions


def certificate():
    require(add(add(power(ZETA, 2), ZETA), ONE) == ZERO, "cyclotomic relation")
    require(power(ZETA, 3) == ONE and ZETA != ONE, "primitive cube root")
    matrix, d1, compositions = chain_data(CHARACTER)
    require(matrix == DISPLAYED_MATRIX, "word-derived matrix differs from the manuscript")
    require(power(CHARACTER[0], 2) == ONE, "t1 character")
    require(power(CHARACTER[2], 3) == ONE, "t2 character")
    require(CHARACTER[0] != ONE, "order-two detection")
    columns = (0, 1, 2, 4)
    minor = tuple(tuple(row[j] for j in columns) for row in matrix)
    det = determinant(minor)
    require(det == mul(q(-4), add(ONE, neg(power(ZETA, 2)))), "minor sign/value")
    require(det != ZERO and norm(det) == 48, "nonzero minor norm")
    block_det = rational_determinant(restriction_of_scalars(minor))
    require(block_det == norm(det), "independent rational block determinant")
    maximal_minors = [
        {
            "columns": [GENERATORS[j] for j in cols],
            "determinant": serialize(determinant(tuple(
                tuple(row[j] for j in cols) for row in matrix
            ))),
        }
        for cols in itertools.combinations(range(5), 4)
    ]
    require(rank(matrix) == 4, "boundary rank")
    require(4 ** 2 - 1 == 15 and 3 ** 3 - 1 == 26, "annihilator exponents")
    require(7 * 15 - 4 * 26 == 1, "Bezout identity")
    require(math.gcd(15, 26) == 1, "coprimality")
    exponent_sums = [
        [sum((1 if letter > 0 else -1) for letter in w if abs(letter) == i)
         for i in range(1, 6)]
        for w in WORDS
    ]
    require(all(row[4] == 0 for row in exponent_sums), "map to Z respects relators")
    sweep = []
    for a1_exponent, a2_sign, s_value in itertools.product(range(3), (-1, 1), (1, -1, 2)):
        a1_value = power(ZETA, a1_exponent)
        c = (q(a2_sign), a1_value, power(a1_value, 2), q(a2_sign), q(s_value))
        m, _, _ = chain_data(c)
        sweep.append({
            "a1_zeta_exponent": a1_exponent,
            "a2_value": a2_sign,
            "s_value": s_value,
            "boundary_rank": rank(m),
        })
    return {
        "claim": "Finite algebra of the prescribed Wall D(2) presentation; not a mechanical topology proof",
        "field": {"polynomial_ascending": [1, 1, 1], "basis": ["1", "zeta"]},
        "generators": list(GENERATORS),
        "relators": [[list(block) for block in relator] for relator in RELATORS],
        "normal_generators": [[["x1", 2]], [["x2", 3]]],
        "character": [serialize(value) for value in CHARACTER],
        "relator_values": [serialize(fox(w, CHARACTER)[1]) for w in WORDS],
        "normal_generator_values": [serialize(power(CHARACTER[0], 2)), serialize(power(CHARACTER[2], 3))],
        "first_boundary": [serialize(value) for value in d1],
        "fox_boundary_rows": [[serialize(value) for value in row] for row in matrix],
        "chain_composition": [serialize(value) for value in compositions],
        "minor_columns": [GENERATORS[j] for j in columns],
        "minor_determinant": serialize(det),
        "minor_norm": str(norm(det)),
        "rational_block_determinant": str(block_det),
        "maximal_minors": maximal_minors,
        "free_group_identity_witnesses": group_identity_witnesses(),
        "annihilator_arithmetic": {
            "4_squared_minus_1": 15,
            "3_cubed_minus_1": 26,
            "bezout_coefficients_for_15_and_26": [7, -4],
            "bezout_value": 1,
        },
        "relator_exponent_sums": exponent_sums,
        "epimorphism_to_Z_generator_values": [0, 0, 0, 0, 1],
        "cell_counts_B": [1, 5, 4],
        "cell_counts_X": [1, 5, 6, 2],
        "euler_characteristic_B_and_X": [1 - 5 + 4, 1 - 5 + 6 - 2],
        "character_sweep": sweep,
    }


def check_equal(actual, expected, path):
    require(type(actual) is type(expected), "wrong JSON type: " + path)
    if isinstance(expected, dict):
        require(set(actual) == set(expected), "wrong fields: " + path)
        for key, value in expected.items():
            check_equal(actual[key], value, path + "." + key)
    elif isinstance(expected, list):
        require(len(actual) == len(expected), "wrong length: " + path)
        for i, (value, wanted) in enumerate(zip(actual, expected)):
            check_equal(value, wanted, path + "[" + str(i) + "]")
    else:
        require(actual == expected, "corrupted or mismatched witness: " + path)


def verify(data):
    expected = certificate()
    check_equal(data, expected, "certificate")
    return expected


def jacobian_payload():
    polynomials = (
        ((1, -1), (-2,), (0,), (0,)),
        ((0,), (0,), (2,), (0,)),
        ((1,), (0,), (0,), (0,)),
        ((0,), (-1, -1), (1,), (1, 0, -1)),
    )

    def rational_function(coefficients):
        return {
            "domain": "QQ",
            "variables": ["z"],
            "numerator": {"terms": [
                {"coefficient": {"num": str(coefficients[i]), "den": "1"}, "exponents": [i]}
                for i in reversed(range(len(coefficients))) if coefficients[i]
            ]},
            "denominator": {"terms": [
                {"coefficient": {"num": "1", "den": "1"}, "exponents": [0]}
            ]},
        }

    return {"matrix": {
        "variables": ["z"],
        "entries": [[rational_function(p) for p in row] for row in polynomials],
    }}


def self_test():
    data = certificate()
    verify(data)
    mutations = (
        ("relators", lambda d: d["relators"][0][-1].__setitem__(1, -3)),
        ("character", lambda d: d["character"][0].__setitem__(0, "1")),
        ("Fox sign", lambda d: d["fox_boundary_rows"][0][1].__setitem__(0, "2")),
        ("chain composition", lambda d: d["chain_composition"][0].__setitem__(0, "1")),
        ("minor", lambda d: d["minor_determinant"].__setitem__(0, "8")),
        ("relator conjugate", lambda d: d["free_group_identity_witnesses"][0]["relator_conjugates"][0].__setitem__("sign", -1)),
        ("Bezout", lambda d: d["annihilator_arithmetic"]["bezout_coefficients_for_15_and_26"].__setitem__(0, 6)),
        ("quotient epimorphism", lambda d: d["epimorphism_to_Z_generator_values"].__setitem__(4, 0)),
        ("sweep rank", lambda d: d["character_sweep"][0].__setitem__("boundary_rank", 5)),
        ("missing field", lambda d: d.pop("relators")),
        ("boolean instead of integer", lambda d: d["cell_counts_B"].__setitem__(0, True)),
        ("truncated matrix", lambda d: d["fox_boundary_rows"].pop()),
        ("extra field", lambda d: d.__setitem__("topology_is_proved", True)),
    )
    for name, mutate in mutations:
        corrupted = copy.deepcopy(data)
        mutate(corrupted)
        try:
            verify(corrupted)
        except ValueError:
            continue
        raise ValueError("corruption accepted: " + name)
    for a, b in itertools.product(range(-3, 4), repeat=2):
        x = q(a, b)
        if x != ZERO:
            require(mul(x, inverse(x)) == ONE, "field inverse test")
    print(f"PASS: {len(mutations)} corrupted witnesses rejected; 48 field inverses checked; 18 character cases exact.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate_file", nargs="?")
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--self-test", action="store_true")
    modes.add_argument("--emit-certificate", action="store_true")
    modes.add_argument("--emit-jacobian-payload", action="store_true")
    args = parser.parse_args()
    try:
        if args.self_test:
            self_test()
        elif args.emit_certificate:
            print(json.dumps(certificate(), indent=2))
        elif args.emit_jacobian_payload:
            print(json.dumps(jacobian_payload(), indent=2))
        else:
            require(args.certificate_file is not None, "supply exact_certificate.json")
            with open(args.certificate_file, encoding="utf-8") as source:
                verify(json.load(source))
            print("PASS: exact word-level Fox matrix, chain identity, minor -8-4*zeta (norm 48),")
            print("six free-group relator-product identities, coprime annihilators, and 18 character cases.")
            print("Scope: finite algebra only; universal topology and independent review are separate.")
    except (OSError, ValueError, TypeError, KeyError) as error:
        print("FAIL: " + str(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
