"""Bounded regression checks for the separately proved universal bridge."""

import json
import unittest
from itertools import combinations, combinations_with_replacement, product
from math import factorial, prod
from pathlib import Path

from near_equality import ryser_permanent
from torus import determinant, remainder, row_product


def multiply_linear(polynomial: dict[int, int],
                    linear: tuple[int, ...]) -> dict[int, int]:
    result: dict[int, int] = {}
    for mask, coefficient in polynomial.items():
        for i, entry in enumerate(linear):
            bit = 1 << i
            if entry and not mask & bit:
                target = mask | bit
                result[target] = (result.get(target, 0) +
                                  coefficient * entry) % 5
    return {mask: coefficient for mask, coefficient in result.items()
            if coefficient}


def repeated_rank(matrix: list[list[int]], copies: int) -> int:
    n = len(matrix)
    columns = list(zip(*matrix))
    for degree in range(n, -1, -1):
        for selected in combinations_with_replacement(range(n), degree):
            if any(selected.count(j) > copies for j in range(n)):
                continue
            polynomial = {0: 1}
            for j in selected:
                polynomial = multiply_linear(polynomial, columns[j])
            if polynomial:
                return degree
    raise AssertionError("the constant product must be nonzero")


def block_diagonal(blocks: list[list[list[int]]]) -> list[list[int]]:
    n = sum(map(len, blocks))
    result = [[0] * n for _ in range(n)]
    offset = 0
    for block in blocks:
        for i, row in enumerate(block):
            result[offset + i][offset:offset + len(block)] = row
        offset += len(block)
    return result


class PermanentAmplificationTest(unittest.TestCase):
    def test_annihilator_projection_all_homogeneous_polynomials_through_m3(self):
        for n in range(1, 4):
            for degree in range(n + 1):
                masks = [sum(1 << i for i in subset)
                         for subset in combinations(range(n), degree)]
                for values in product(range(5), repeat=len(masks)):
                    polynomial = {mask: value for mask, value in zip(masks, values)
                                  if value}
                    if not polynomial:
                        continue
                    pivot = next(iter(polynomial))
                    annihilators: dict[tuple[int, ...], tuple[int, ...]] = {}
                    for linear in product(range(5), repeat=n):
                        if multiply_linear(polynomial, linear):
                            continue
                        restriction = tuple(linear[i] for i in range(n)
                                            if pivot >> i & 1)
                        self.assertNotIn(restriction, annihilators)
                        annihilators[restriction] = linear
                    self.assertLessEqual(len(annihilators), 5 ** degree)

    def test_recurrence_and_factorials_for_every_two_by_two_matrix(self):
        invertible = 0
        for entries in product(range(5), repeat=4):
            matrix = [list(entries[:2]), list(entries[2:])]
            coefficients = remainder(matrix, truncate=True)
            for alpha in ((2, 0), (1, 1), (0, 2)):
                selected = [j for j, count in enumerate(alpha)
                            for _ in range(count)]
                repeated = [[row[j] for j in selected] for row in matrix]
                code = sum(exponent << (2 * j)
                           for j, exponent in enumerate(alpha))
                factor = prod(factorial(exponent) for exponent in alpha)
                self.assertEqual(ryser_permanent(repeated),
                                 factor * coefficients.get(code, 0) % 5)
            if determinant(matrix):
                invertible += 1
                ranks = [repeated_rank(matrix, copies) for copies in range(4)]
                for k in range(3):
                    self.assertGreaterEqual(2 * ranks[k + 1], 2 + ranks[k])
        self.assertEqual(invertible, 480)

    def test_precise_eight_and_nine_dimensional_thresholds(self):
        for n, initial, second, third in ((8, 5, 7, 8), (9, 6, 8, 9)):
            self.assertEqual((n + initial + 1) // 2, second)
            self.assertEqual((n + second + 1) // 2, third)
            self.assertEqual(third, n)
        self.assertEqual((9 + 5 + 1) // 2, 7)
        self.assertEqual((9 + 7 + 1) // 2, 8)

    def test_block_examples_and_complete_typed_jacobian_response(self):
        source = [[1, 1, 1], [1, 2, 1], [1, 1, 0]]
        pair = [[1, 1], [1, 4]]
        self.assertEqual(repeated_rank(source, 1), 2)
        self.assertEqual(repeated_rank(pair, 1), 1)
        examples = (
            (block_diagonal([source, source, pair]),
             (3, 0, 0, 3, 0, 0, 2, 0), [1] * 6 + [1, 2], 2),
            (block_diagonal([source, source, source]),
             (3, 0, 0, 3, 0, 0, 3, 0, 0), [1] * 9, 1),
        )
        for matrix, alpha, witness, expected in examples:
            self.assertNotEqual(determinant(matrix), 0)
            selected = [j for j, count in enumerate(alpha)
                        for _ in range(count)]
            repeated = [[row[j] for j in selected] for row in matrix]
            self.assertEqual(ryser_permanent(repeated), expected)
            code = sum(exponent << (2 * j)
                       for j, exponent in enumerate(alpha))
            coefficient = remainder(matrix, truncate=True)[code]
            self.assertEqual(coefficient, 1)
            factor = prod(factorial(exponent) for exponent in alpha) % 5
            self.assertNotEqual(factor, 0)
            self.assertEqual(factor * coefficient % 5, expected)
            self.assertEqual(remainder(matrix)[code], coefficient)
            self.assertNotEqual(row_product(matrix, witness), 0)

        root = Path(__file__).parent
        payload = json.loads(
            (root / "jacobian_amplification_permanent_payload.json").read_text())
        response = json.loads(
            (root / "jacobian_amplification_permanent_result.json").read_text())
        self.assertEqual(response["request"]["payload"], payload)
        self.assertEqual(response["request"]["operation_id"],
                         "matrix.permanent.compute")
        self.assertEqual(response["server"]["version"], "0.14.0")
        self.assertEqual(response["protocol_version"], "2025-11-25")
        self.assertEqual(response["result"]["output"]["permanent"],
                         {"num": "216", "den": "1"})
        integer_matrix = [
            [int(entry["num"]) for entry in row]
            for row in payload["matrix"]["entries"]
        ]
        self.assertEqual(integer_matrix, repeated)
        self.assertEqual(ryser_permanent(integer_matrix), 216 % 5)


if __name__ == "__main__":
    unittest.main()
