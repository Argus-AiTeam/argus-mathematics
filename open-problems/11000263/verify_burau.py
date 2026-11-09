#!/usr/bin/env python3
"""Bounded replay of the Burau witness for both natural repaired readings."""

from __future__ import annotations

import sympy as sym


q, u = sym.symbols("q u", nonzero=True)


def burau(order: int, index: int) -> sym.Matrix:
    matrix = sym.eye(order)
    matrix[index - 1 : index + 1, index - 1 : index + 1] = sym.Matrix(
        [[1 - u, u], [1, 0]]
    )
    return matrix


def positive_word(order: int, indices: list[int]) -> sym.Matrix:
    matrix = sym.eye(order)
    for index in indices:
        matrix *= burau(order, index)
    return sym.simplify(matrix)


def barred_word(order: int, indices: list[int]) -> sym.Matrix:
    """Bigelow's bar means inverse of the complete displayed braid word."""
    return sym.simplify(positive_word(order, indices).inv())


def rank_one_matrix(order: int, rank: int) -> sym.Matrix:
    matrix = sym.zeros(order)
    matrix[rank - 1, 0] = -(u ** (-(rank - 1)))
    matrix[rank - 1, 1] = u ** (-(rank - 1))
    matrix[rank, 0] = u**-rank
    matrix[rank, 1] = -(u**-rank)
    return matrix


def is_zero(matrix: sym.Matrix) -> bool:
    return all(sym.factor(entry) == 0 for entry in matrix)


def verify_order(order: int) -> None:
    generators = {index: burau(order, index) for index in range(1, order)}
    elements = {
        2: sym.simplify(
            q * generators[1].inv()
            + (1 - q) * sym.eye(order)
            - generators[1]
        )
    }
    assert is_zero(elements[2] - (q - u) * rank_one_matrix(order, 1))

    for index in range(3, order + 1):
        descending = list(range(index - 1, 0, -1))
        ascending = list(range(1, index))
        elements[index] = sym.simplify(
            (
                q ** (index - 1) * barred_word(order, descending)
                - positive_word(order, ascending)
            )
            * elements[index - 1]
        )
        expected = (
            sym.prod(q**power - u for power in range(1, index))
            * rank_one_matrix(order, index - 1)
        )
        assert is_zero(elements[index] - expected)

    left = (
        q * generators[2].inv()
        + (1 - q) * sym.eye(order)
        - generators[2]
    ) * elements[2]
    right = (
        q * barred_word(order, [2, 1])
        - positive_word(order, [1, 2])
    ) * elements[2]
    assert is_zero(left - right)
    assert is_zero(left - (q - u) ** 2 * rank_one_matrix(order, 2))

    for index in range(3, order):
        left = (
            q ** (index - 1)
            * barred_word(order, list(range(index, 1, -1)))
            - positive_word(order, list(range(2, index + 1)))
        ) * elements[index]
        right = (
            q ** (index - 1)
            * barred_word(order, list(range(index, 0, -1)))
            - positive_word(order, list(range(1, index + 1)))
        ) * elements[index]
        expected = (
            sym.prod(q**power - u for power in range(1, index))
            * (q ** (index - 1) - u)
            * rank_one_matrix(order, index)
        )
        assert is_zero(left - right)
        assert is_zero(left - expected)

    assert elements[3].rank() == 1
    assert not is_zero(elements[3])


def main() -> None:
    for order in range(3, 9):
        verify_order(order)
        print(
            f"n={order}: X_k closed forms and all admissible repaired relations "
            "passed; rank(X3)=1"
        )
    print("bounded_independent_replay=passed")


if __name__ == "__main__":
    main()
