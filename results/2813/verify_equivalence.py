#!/usr/bin/env python3
"""Exact replay of the nearest published affine-formula noncollision."""

from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent

ONE = (1, 0)
MINUS_ONE = (-1, 0)
I = (1, 1)
MINUS_I = (-1, 1)
J = (1, 2)
MINUS_J = (-1, 2)
K = (1, 3)
MINUS_K = (-1, 3)
Q8 = (ONE, MINUS_ONE, I, MINUS_I, J, MINUS_J, K, MINUS_K)
NAMES = {
    ONE: "1",
    MINUS_ONE: "-1",
    I: "i",
    MINUS_I: "-i",
    J: "j",
    MINUS_J: "-j",
    K: "k",
    MINUS_K: "-k",
}
POSITIVE_PRODUCTS = {
    (0, 0): (1, 0),
    (0, 1): (1, 1),
    (0, 2): (1, 2),
    (0, 3): (1, 3),
    (1, 0): (1, 1),
    (1, 1): (-1, 0),
    (1, 2): (1, 3),
    (1, 3): (-1, 2),
    (2, 0): (1, 2),
    (2, 1): (-1, 3),
    (2, 2): (-1, 0),
    (2, 3): (1, 1),
    (3, 0): (1, 3),
    (3, 1): (1, 2),
    (3, 2): (-1, 1),
    (3, 3): (-1, 0),
}


def matmul(left, right):
    return [
        [
            sum(left[r][k] * right[k][c] for k in range(len(right)))
            for c in range(len(right[0]))
        ]
        for r in range(len(left))
    ]


def inverse_2x2(matrix):
    det = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    assert det in (-1, 1)
    return [
        [matrix[1][1] // det, -matrix[0][1] // det],
        [-matrix[1][0] // det, matrix[0][0] // det],
    ]


def trace(matrix):
    return sum(matrix[i][i] for i in range(len(matrix)))


def intertwiner(source, target):
    rows = []
    for row in range(2):
        for column in range(2):
            equation = []
            for ur in range(2):
                for uc in range(2):
                    coefficient = 0
                    if row == ur:
                        coefficient += source[uc][column]
                    if column == uc:
                        coefficient -= target[row][ur]
                    equation.append(coefficient)
            rows.append(equation)
    return rows


def block_diagonal(left, right):
    lw = len(left[0])
    rw = len(right[0])
    return (
        [row + [0] * rw for row in left]
        + [[0] * lw + row for row in right]
    )


def rank(matrix):
    work = [[Fraction(value) for value in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        value = work[pivot_row][column]
        work[pivot_row] = [entry / value for entry in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row or not work[row][column]:
                continue
            factor = work[row][column]
            work[row] = [
                entry - factor * pivot_entry
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def multiply(left, right):
    ls, lb = left
    rs, rb = right
    ps, pb = POSITIVE_PRODUCTS[(lb, rb)]
    return ls * rs * ps, pb


def inverse(element):
    return next(x for x in Q8 if multiply(element, x) == multiply(x, element) == ONE)


def beta_s(element):
    images = (ONE, MINUS_K, J, I)
    sign, basis = element
    image_sign, image_basis = images[basis]
    return sign * image_sign, image_basis


def beta_t(element):
    images = (ONE, I, K, MINUS_J)
    sign, basis = element
    image_sign, image_basis = images[basis]
    return sign * image_sign, image_basis


def beta_h0(element):
    return beta_s(beta_s(beta_t(beta_s(beta_s(beta_t(element))))))


def conjugate(conjugator, element):
    return multiply(multiply(conjugator, element), inverse(conjugator))


def named_action(function):
    return {NAMES[x]: NAMES[function(x)] for x in Q8}


def main() -> None:
    witness = json.loads((ROOT / "certificate.json").read_text())
    expected = json.loads((ROOT / "equivalence-certificate.json").read_text())
    payload = json.loads(
        (ROOT / "equivalence" / "jacobian-nullspace-payload.json").read_text()
    )
    operation = json.loads(
        (ROOT / "equivalence" / "jacobian-nullspace-output.json").read_text()
    )

    assert witness["status"] == "PASS"
    assert witness["homology"]["mapping_torus_b1"] == 3
    assert witness["candidate"]["w_equals_e_f_plus_2a"] == [-2, -2, 2]

    identity = [[1, 0], [0, 1]]
    s = [[1, 0], [1, 1]]
    t = [[1, 1], [0, 1]]
    derivative = identity
    for symbol in "SSTSST":
        derivative = matmul(s if symbol == "S" else t, derivative)
    assert derivative == [[11, 4], [8, 3]]

    s2 = matmul(s, s)
    b = matmul(matmul(s2, derivative), inverse_2x2(s2))
    published = [[-entry for entry in row] for row in b]
    assert b == [[3, 4], [8, 11]]
    assert [trace(b), trace(inverse_2x2(b))] == [14, 14]
    assert [trace(published), trace(inverse_2x2(published))] == [-14, -14]

    system = block_diagonal(
        intertwiner(b, published),
        intertwiner(b, inverse_2x2(published)),
    )
    encoded = [
        [int(entry["num"]) // int(entry["den"]) for entry in row]
        for row in payload["matrix"]["entries"]
    ]
    assert encoded == system
    assert rank(system) == 8
    output = operation["result"]["output"]
    assert output["rank"] == 8
    assert output["nullity"] == 0
    assert output["basis_vectors"] == []

    printed_action = named_action(beta_h0)
    assert all(source == image for source, image in printed_action.items())
    target_deck = beta_s(beta_s(MINUS_I))
    assert target_deck == I
    target_action = named_action(lambda element: conjugate(I, element))
    assert target_action["j"] == "-j"
    assert target_action["k"] == "-k"
    assert target_action != printed_action

    near = expected["matheus_yoccoz_near_match"]
    assert expected["status"] == "PASS"
    assert near["target_derivative"] == derivative
    assert near["target_derivative_after_conjugacy"] == b
    assert near["printed_element_derivative"] == published
    assert near["printed_element_conjugate_or_inverse_conjugate"] is False
    assert near["same_derivative_factor_conjugate_or_inverse_conjugate"] is False
    assert near["q8_action_of_printed_same_derivative_factor"] == printed_action
    assert near["q8_action_of_conjugated_target"] == target_action

    print(json.dumps({
        "status": "PASS",
        "target_trace": 14,
        "published_trace": -14,
        "intertwiner_rank": 8,
        "intertwiner_nullity": 0,
        "target_mapping_torus_b1": 3,
        "published_mapping_torus_b1": 5,
        "q8_actions_distinct": True,
        "scope": "exact affine and deck-action noncollision only",
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
