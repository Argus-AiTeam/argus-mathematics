#!/usr/bin/env python3
"""Replay the new finite algebra, not the topological or originality claims."""

import argparse
import copy
from fractions import Fraction
import json
from pathlib import Path
import sys


GENERATORS = ["x1", "a1", "x2", "a2", "s", "t"]
RELATORS = [
    [1, 2, -1] + [-2] * 4,
    [3, 4, -3] + [-4] * 3,
    [1] + [-4] * 13,
    [5, 3, -5] + [-2] * 5,
    [6, 5, -6, -1, -5],
]
KERNEL_WORDS = [[1, 1], [3, 3, 3]]
MATRICES = [
    [[6, 0], [0, 6]],
    [[2, 0], [0, 2]],
    [[4, 0], [0, 4]],
    [[6, 0], [0, 6]],
    [[2, 0], [0, 5]],
    [[0, 1], [1, 0]],
]
REDUCED_RELATIONS = [
    [1, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 0],
    [0, 3, 0, 0, 0, 0],
    [0, -2, 1, 0, 0, 0],
]
MINOR_COLUMNS = [0, 1, 2, 3, 4, 5, 8, 9, 10, 11]
BS_WORD = [1, 2, -1, -2, -2]
BS_MATRICES = [[[2, 0], [0, 1]], [[1, 1], [0, 1]]]
BS_FOX_ROWS = [[0, -2, 0, -1], [0, 0, 0, -1]]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def identity(size):
    return [[int(i == j) for j in range(size)] for i in range(size)]


def zeros(rows, columns):
    return [[0] * columns for _ in range(rows)]


def reduce(value, prime):
    return value % prime if prime is not None else value


def add(left, right, prime=None):
    require(len(left) == len(right), "matrix row counts disagree")
    require(
        all(len(a) == len(b) for a, b in zip(left, right)),
        "matrix column counts disagree",
    )
    return [
        [reduce(x + y, prime) for x, y in zip(a, b)]
        for a, b in zip(left, right)
    ]


def scale(matrix, scalar, prime=None):
    return [[reduce(scalar * x, prime) for x in row] for row in matrix]


def multiply(left, right, prime=None):
    require(bool(left) and bool(right), "empty matrix product")
    require(all(len(row) == len(right) for row in left), "matrix sizes disagree")
    require(
        all(len(row) == len(right[0]) for row in right),
        "right matrix is not rectangular",
    )
    return [
        [
            reduce(sum(x * right[k][j] for k, x in enumerate(row)), prime)
            for j in range(len(right[0]))
        ]
        for row in left
    ]


def inverse_scalar(value, prime):
    require(value != 0, "noninvertible scalar")
    return pow(value, -1, prime) if prime is not None else Fraction(1) / value


def inverse(matrix, prime=None):
    if len(matrix) == 1 and len(matrix[0]) == 1:
        return [[inverse_scalar(matrix[0][0], prime)]]
    require(
        len(matrix) == 2 and all(len(row) == 2 for row in matrix),
        "only one- and two-dimensional representations are used",
    )
    (a, b), (c, d) = matrix
    determinant = reduce(a * d - b * c, prime)
    return scale([[d, -b], [-c, a]], inverse_scalar(determinant, prime), prime)


def rank(matrix, prime=None):
    work = [
        [x % prime if prime is not None else Fraction(x) for x in row]
        for row in matrix
    ]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (i for i in range(pivot_row, len(work)) if work[i][column] != 0),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inv = inverse_scalar(work[pivot_row][column], prime)
        work[pivot_row] = [reduce(x * inv, prime) for x in work[pivot_row]]
        for i in range(len(work)):
            if i != pivot_row:
                coefficient = work[i][column]
                work[i] = [
                    reduce(x - coefficient * y, prime)
                    for x, y in zip(work[i], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivot_row


def determinant(matrix, prime=None):
    require(all(len(row) == len(matrix) for row in matrix), "nonsquare minor")
    work = [
        [x % prime if prime is not None else Fraction(x) for x in row]
        for row in matrix
    ]
    answer = 1
    for column in range(len(work)):
        pivot = next(
            (i for i in range(column, len(work)) if work[i][column] != 0),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        entry = work[column][column]
        answer = reduce(answer * entry, prime)
        inv = inverse_scalar(entry, prime)
        for i in range(column + 1, len(work)):
            coefficient = reduce(work[i][column] * inv, prime)
            work[i] = [
                reduce(x - coefficient * y, prime)
                for x, y in zip(work[i], work[column])
            ]
    return answer


def fox(word, matrices, prime=None):
    size = len(matrices[0])
    prefix = identity(size)
    derivatives = [zeros(size, size) for _ in matrices]
    for letter in word:
        index = abs(letter) - 1
        require(0 <= index < len(matrices), "invalid letter in relator")
        if letter > 0:
            derivatives[index] = add(derivatives[index], prefix, prime)
            prefix = multiply(prefix, matrices[index], prime)
        else:
            prefix = multiply(prefix, inverse(matrices[index], prime), prime)
            derivatives[index] = add(
                derivatives[index], scale(prefix, -1, prime), prime
            )
    rows = [
        [entry for block in derivatives for entry in block[i]]
        for i in range(size)
    ]
    return rows, prefix


def exponent_sums(word):
    row = [0] * len(GENERATORS)
    for letter in word:
        row[abs(letter) - 1] += 1 if letter > 0 else -1
    return row


def finite_image(matrices, prime):
    start = tuple(entry for row in identity(2) for entry in row)
    seen = {start}
    frontier = [start]
    while frontier:
        current = frontier.pop()
        matrix = [list(current[:2]), list(current[2:])]
        for generator in matrices:
            product = multiply(matrix, generator, prime)
            key = tuple(entry for row in product for entry in row)
            if key not in seen:
                seen.add(key)
                frontier.append(key)
    return seen


def verify(certificate):
    require(certificate["field"] == 7, "the witness field must be F7")
    require(certificate["zeta"] == 2, "the specified cube root changed")
    require(certificate["generators"] == GENERATORS, "generator order changed")
    require(certificate["relators"] == RELATORS, "target relators changed")
    require(certificate["kernel_words"] == KERNEL_WORDS, "perfect-kernel words changed")
    require(certificate["representation"] == MATRICES, "specified representation changed")
    require(certificate["minor_columns"] == MINOR_COLUMNS, "minor columns changed")

    boundary = []
    for word in RELATORS:
        rows, value = fox(word, MATRICES, 7)
        require(value == identity(2), "a relator does not evaluate to the identity")
        boundary.extend(rows)
    for word in KERNEL_WORDS:
        require(fox(word, MATRICES, 7)[1] == identity(2), "representation misses the quotient")
    d1 = [
        row
        for matrix in MATRICES
        for row in add(matrix, scale(identity(2), -1), 7)
    ]
    require(multiply(boundary, d1, 7) == zeros(10, 2), "Fox chain identity failed")
    minor = [[row[j] for j in MINOR_COLUMNS] for row in boundary]
    minor_value = determinant(minor, 7)
    require(minor_value == certificate["minor_determinant"] == 2, "minor determinant mismatch")
    require(rank(boundary, 7) == certificate["boundary_rank"] == 10, "boundary rank mismatch")
    require(rank(d1, 7) == certificate["first_boundary_rank"] == 2, "first boundary rank mismatch")
    require(MATRICES[0] != identity(2), "the order-two element was not detected")
    image = finite_image(MATRICES, 7)
    require(len(image) == certificate["image_order"] == 24, "finite image order mismatch")

    relations = [exponent_sums(word) for word in RELATORS + KERNEL_WORDS]
    abelianization = certificate["abelianization"]
    require(
        abelianization["reduced_relations"] == REDUCED_RELATIONS,
        "canonical abelianization relations changed",
    )
    require(
        multiply(abelianization["relations_to_reduced"], relations) == REDUCED_RELATIONS,
        "forward integer relation-lattice witness failed",
    )
    require(
        multiply(abelianization["reduced_to_relations"], REDUCED_RELATIONS) == relations,
        "reverse integer relation-lattice witness failed",
    )

    scalar_cases = 0
    scalar_vanishing = 0
    for u in (1, 2, 4):
        for s in range(1, 7):
            for t in range(1, 7):
                matrices = [[[x]] for x in (1, u, u * u % 7, 1, s, t)]
                scalar_boundary = []
                for word in RELATORS:
                    rows, value = fox(word, matrices, 7)
                    require(value == [[1]], "scalar assignment is not a character")
                    scalar_boundary.extend(rows)
                nullity = 5 - rank(scalar_boundary, 7)
                expected_vanishing = u == 1 and (s, t) != (1, 1)
                require(
                    (nullity == 0) == expected_vanishing,
                    "scalar vanishing-locus check failed over F7",
                )
                scalar_cases += 1
                scalar_vanishing += int(nullity == 0)
    require(
        [scalar_cases, scalar_vanishing] == certificate["scalar_experiment_counts"] == [108, 35],
        "finite scalar experiment counts changed",
    )

    sharpness = certificate["finite_generation_boundary"]
    require(sharpness["relator"] == BS_WORD, "Baumslag-Solitar relator changed")
    require(sharpness["representation"] == BS_MATRICES, "affine representation changed")
    bs_boundary, bs_value = fox(BS_WORD, BS_MATRICES)
    require(bs_value == identity(2), "affine relation failed over Q")
    require(bs_boundary == sharpness["fox_rows"] == BS_FOX_ROWS, "affine Fox boundary mismatch")
    require(rank(bs_boundary) == sharpness["rank"] == 2, "affine boundary is not injective")
    require(
        determinant([[row[1], row[3]] for row in bs_boundary]) == 2,
        "affine nonzero minor failed",
    )
    return {
        "scope": "exact finite algebra only; universal topology and originality require prose review",
        "field": 7,
        "relators_checked": len(RELATORS),
        "kernel_words_checked": len(KERNEL_WORDS),
        "chain_dimensions": [2, 12, 10],
        "boundary_ranks": [2, 10],
        "twisted_betti_numbers": [0, 0, 0],
        "ten_by_ten_minor": minor_value,
        "finite_image_order": len(image),
        "abelianization": "C3 + Z^2, certified by integer relation-lattice equality",
        "scalar_experiment": {"field": 7, "characters": scalar_cases, "H2_zero": scalar_vanishing},
        "affine_Q_boundary_rank": 2,
    }


def corruption_checks(certificate):
    changes = [
        (("field",), 5),
        (("relators", 4, 3), 1),
        (("representation", 4, 1, 1), 2),
        (("minor_columns", 9), 6),
        (("minor_determinant",), 3),
        (("boundary_rank",), 9),
        (("image_order",), 12),
        (("abelianization", "relations_to_reduced", 1, 1), -6),
        (("abelianization", "reduced_to_relations", 6, 2), 1),
        (("scalar_experiment_counts", 1), 36),
        (("finite_generation_boundary", "fox_rows", 0, 1), 2),
    ]
    for path, replacement in changes:
        altered = copy.deepcopy(certificate)
        target = altered
        for key in path[:-1]:
            target = target[key]
        target[path[-1]] = replacement
        try:
            verify(altered)
        except ValueError:
            continue
        raise ValueError(f"corrupted certificate was accepted: {path}")
    return len(changes)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "certificate", nargs="?", type=Path,
        default=Path(__file__).with_name("exact_certificate.json"),
    )
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    try:
        certificate = json.loads(args.certificate.read_text())
        result = verify(certificate)
        if args.self_test:
            result["corruptions_rejected"] = corruption_checks(certificate)
    except (OSError, ValueError, KeyError, TypeError, IndexError) as error:
        print(f"verification failed: {error}", file=sys.stderr)
        return 1
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
