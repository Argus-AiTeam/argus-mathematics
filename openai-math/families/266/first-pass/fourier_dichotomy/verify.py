#!/usr/bin/env python3
"""Replay a universal pair-moment identity certificate using exact rationals."""

import argparse
import itertools
import json
from collections import Counter
from fractions import Fraction
from functools import lru_cache
from pathlib import Path


ALPHA = (1, 1, 1, -1, -1, -1)
W = (-3, -2, 0, 1, 2, 2)
AUXILIARY = (
    (-1, -1, 0, 0, 1, 1),
    (-2, 0, 0, 0, 1, 1),
    (-1, -1, 0, 1, 0, 1),
    (-1, -1, 0, 1, 1, 0),
)
Q_CHARGES = ((2, 0, 0, -2, 0, 0), (2, -2, 0, 0, 0, 0))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def transpose(matrix):
    return tuple(tuple(column) for column in zip(*matrix))


def order(row):
    return sum(max(entry, 0) for entry in row)


def balanced(matrix, row_limit=6, column_limit=6):
    require(len(matrix) <= row_limit, "too many physical rows")
    if not matrix:
        return
    columns = len(matrix[0])
    require(0 < columns <= column_limit, "invalid column count")
    require(all(len(row) == columns for row in matrix), "ragged exponent matrix")
    require(
        all(type(entry) is int for row in matrix for entry in row),
        "exponents must be integers",
    )
    require(all(sum(row) == 0 for row in matrix), "unbalanced exponent row")
    require(
        all(sum(column) == 0 for column in transpose(matrix)),
        "unbalanced exponent column",
    )


def trim(matrix):
    rows = tuple(row for row in matrix if any(row))
    if not rows:
        return ()
    keep = tuple(j for j, column in enumerate(transpose(rows)) if any(column))
    return tuple(tuple(row[j] for j in keep) for row in rows)


@lru_cache(maxsize=None)
def canonical(matrix):
    matrix = trim(matrix)
    if not matrix:
        return ()
    candidates = []
    for oriented in (matrix, transpose(matrix)):
        if len(oriented) < len(oriented[0]):
            continue
        for sign in (1, -1):
            signed = tuple(tuple(sign * x for x in row) for row in oriented)
            degrees = tuple(map(order, transpose(signed)))
            groups = [
                tuple(j for j, degree in enumerate(degrees) if degree == value)
                for value in sorted(set(degrees))
            ]
            for block_orders in itertools.product(
                *(itertools.permutations(group) for group in groups)
            ):
                columns = tuple(itertools.chain.from_iterable(block_orders))
                rows = tuple(sorted(tuple(row[j] for j in columns) for row in signed))
                candidates.append((tuple(sorted(degrees)), rows))
    return min(candidates)[1]


def accumulate(target, expression, scalar=Fraction(1)):
    for moment, value in expression.items():
        coefficient = target.get(moment, Fraction(0)) + scalar * value
        if coefficient:
            target[moment] = coefficient
        else:
            target.pop(moment, None)


def merge(matrix, source, destination):
    return tuple(
        tuple(x + y for x, y in zip(row, matrix[source]))
        if index == destination
        else row
        for index, row in enumerate(matrix)
        if index != source
    )


@lru_cache(maxsize=None)
def reduced(matrix):
    balanced(matrix)
    normalized = canonical(matrix)
    if normalized != matrix:
        return reduced(normalized)
    if not normalized:
        return {(): Fraction(1)}
    for oriented in (normalized, transpose(normalized)):
        for source, row in enumerate(oriented):
            if order(row) != 1:
                continue
            result = {}
            for destination in range(len(oriented)):
                if destination != source:
                    accumulate(
                        result,
                        reduced(merge(oriented, source, destination)),
                        -Fraction(1, 7 - len(oriented)),
                    )
            return result
    return {normalized: Fraction(1)}


def boundary_relation(matrix, source=0):
    balanced(matrix, row_limit=7, column_limit=4)
    require(len(matrix) == 7, "boundary equation must have seven formal rows")
    require(len(matrix[0]) >= 2, "boundary equation must have at least two columns")
    require(0 <= source < 7 and order(matrix[source]) == 1, "invalid contracted row")
    require(all(order(row) > 0 for row in matrix), "zero formal boundary row")
    require(
        all(order(column) >= 2 for column in transpose(matrix)),
        "boundary column order below two",
    )
    require(7 <= sum(map(order, matrix)) <= 11, "boundary total order out of range")
    result = {}
    for destination in range(7):
        if source != destination:
            accumulate(result, reduced(merge(matrix, source, destination)))
    return result


@lru_cache(maxsize=None)
def partitions(positions):
    if not positions:
        return ((),)
    first, rest = positions[0], positions[1:]
    result = []
    for count in range(len(rest) + 1):
        for companions in itertools.combinations(rest, count):
            block = (first,) + companions
            remaining = tuple(i for i in rest if i not in companions)
            result.extend((block,) + suffix for suffix in partitions(remaining))
    return tuple(result)


def falling(size, length):
    result = 1
    for offset in range(length):
        result *= size - offset
    return result


def character_product(charges):
    require(all(len(charge) == 6 and sum(charge) == 0 for charge in charges),
            "each character must carry a balanced six-coordinate charge")
    require(all(sum(charge[i] for charge in charges) == 0 for i in range(6)),
            "product must have zero total charge")
    if not charges:
        return {(): Fraction(1)}
    result = {}
    for pattern in partitions(tuple(range(len(charges)))):
        count = len(pattern)
        if count > 6:
            continue
        exponents = tuple(
            tuple(sum(charges[j][i] for j in block) for block in pattern)
            for i in range(6)
        )
        accumulate(
            result,
            reduced(exponents),
            Fraction(falling(6, count), 6 ** len(charges)),
        )
    return result


def target_identities():
    terms = [(-1, (W,))]
    for coefficient, charge in zip((2, 1, 1, 1), AUXILIARY):
        complement = tuple(x - y for x, y in zip(W, charge))
        terms.append((coefficient, (charge, complement)))
    square = {}
    for left_coefficient, left in terms:
        for right_coefficient, right in terms:
            charges = left + tuple(tuple(-x for x in charge) for charge in right)
            require(len(charges) <= 4, "unexpected number of target factors")
            require(sum(map(order, charges)) == 10, "unexpected target order")
            accumulate(
                square,
                character_product(charges),
                3 * left_coefficient * right_coefficient,
            )
    targets = []
    for charge in Q_CHARGES:
        result = square.copy()
        accumulate(
            result,
            character_product(
                (ALPHA, charge, tuple(-x for x in ALPHA), tuple(-x for x in charge))
            ),
        )
        targets.append(result)
    return targets


def check_sampling_weights():
    counts = []
    for length in range(5):
        observed = Counter()
        for samples in itertools.product(range(6), repeat=length):
            blocks = {}
            for position, sample in enumerate(samples):
                blocks.setdefault(sample, []).append(position)
            pattern = tuple(sorted(tuple(block) for block in blocks.values()))
            observed[pattern] += 1
        patterns = partitions(tuple(range(length)))
        require(len(patterns) == len(set(patterns)), "repeated equality pattern")
        require(set(patterns) == set(observed), "missing equality pattern")
        for pattern in patterns:
            require(observed[pattern] == falling(6, len(pattern)),
                    "incorrect equality-pattern coefficient")
        counts.append(len(patterns))
    return counts


def check_dichotomy_routing():
    pairs_by_charge = {}
    positions = [
        (charge.index(2), charge.index(-2)) for charge in Q_CHARGES
    ]
    for ordering in itertools.permutations(range(6)):
        charge = [0] * 6
        for position, row in enumerate(ordering):
            charge[row] = ALPHA[position]
        pairs = pairs_by_charge.setdefault(tuple(charge), set())
        for positive, negative in positions:
            pairs.add((ordering[positive], ordering[negative]))
    all_pairs = {(i, j) for i in range(6) for j in range(6) if i != j}
    require(len(pairs_by_charge) == 20, "missing alpha sign partition")
    for charge, pairs in pairs_by_charge.items():
        conjugate = tuple(-entry for entry in charge)
        require(pairs | pairs_by_charge[conjugate] == all_pairs,
                "product vanishings do not cover every ordered row pair")
    return {"alpha_sign_partitions": 20, "ordered_row_pairs_per_partition": 30}


def verify(certificate):
    require(certificate["format"] == "pair-boundary-dual-v1", "unknown certificate")
    require(certificate["alpha"] == list(ALPHA), "certificate changes alpha")
    require(certificate["w"] == list(W), "certificate changes w")
    require(certificate["auxiliary"] == [list(a) for a in AUXILIARY],
            "certificate changes auxiliary charges")
    require(certificate["auxiliary_coefficients"] == [2, 1, 1, 1],
            "certificate changes L coefficients")
    require(certificate["q_charges"] == [list(q) for q in Q_CHARGES],
            "certificate changes the two conclusions")
    partition_counts = check_sampling_weights()
    dichotomy_routing = check_dichotomy_routing()
    targets = target_identities()
    combination = [{}, {}]
    witness_count = 0
    for witness in certificate["boundary_witnesses"]:
        matrix = tuple(tuple(row) for row in witness["matrix"])
        coefficients = tuple(Fraction(value) for value in witness["coefficients"])
        require(len(coefficients) == 2, "each witness needs two dual coefficients")
        require(any(coefficients), "unused boundary witness")
        relation = boundary_relation(matrix, witness["contracted_row"])
        require(bool(relation), "zero boundary witness")
        for index, coefficient in enumerate(coefficients):
            accumulate(combination[index], relation, coefficient)
        witness_count += 1
    for index, (target, supplied) in enumerate(zip(targets, combination)):
        difference = target.copy()
        accumulate(difference, supplied, -1)
        require(not difference,
                f"identity {index} has {len(difference)} nonzero residual coefficients")
    return {
        "result": "VERIFIED_UNIVERSAL_PAIR_IDENTITIES",
        "identities": 2,
        "nonzero_residual_coefficients": [0, 0],
        "boundary_witnesses": witness_count,
        "target_coordinates_before_boundary": [len(target) for target in targets],
        "equality_pattern_counts_n_0_through_4": partition_counts,
        "dichotomy_routing": dichotomy_routing,
        "arithmetic": "Python standard-library Fraction; no modular evidence trusted",
        "scope": "Proposition prop:pair-certificate; dichotomy follows by positivity",
        "independent_review": "not performed by this checker",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "certificate",
        nargs="?",
        type=Path,
        default=Path(__file__).with_name("exact_certificate.json"),
    )
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    print(json.dumps(verify(certificate), indent=2))


if __name__ == "__main__":
    main()
