#!/usr/bin/env python3
"""Exact replay for the Burau zipper-twist extension.

The script verifies the original displayed zipper relations, the two twist
eigenrelations asked about by Stephen Bigelow, and the specialization u=q^3
that kills X_4 while preserving X_3.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sym


q, u = sym.symbols("q u", nonzero=True)


def burau(order: int, index: int) -> sym.Matrix:
    matrix = sym.eye(order)
    matrix[index - 1 : index + 1, index - 1 : index + 1] = sym.Matrix(
        [[1 - u, u], [1, 0]]
    )
    return matrix


def word(order: int, indices: list[int]) -> sym.Matrix:
    matrix = sym.eye(order)
    for index in indices:
        matrix *= burau(order, index)
    return sym.simplify(matrix)


def barred_word(order: int, indices: list[int]) -> sym.Matrix:
    return sym.simplify(word(order, indices).inv())


def is_zero(matrix: sym.Matrix) -> bool:
    return all(sym.factor(entry) == 0 for entry in matrix)


def rank_one_matrix(order: int, rank: int) -> sym.Matrix:
    matrix = sym.zeros(order)
    matrix[rank - 1, 0] = -(u ** (-(rank - 1)))
    matrix[rank - 1, 1] = u ** (-(rank - 1))
    matrix[rank, 0] = u**-rank
    matrix[rank, 1] = -(u**-rank)
    return matrix


def zipper_elements(order: int) -> dict[int, sym.Matrix]:
    generators = {index: burau(order, index) for index in range(1, order)}
    elements = {
        2: sym.simplify(
            q * generators[1].inv()
            + (1 - q) * sym.eye(order)
            - generators[1]
        )
    }
    for index in range(3, order + 1):
        elements[index] = sym.simplify(
            (
                q ** (index - 1)
                * barred_word(order, list(range(index - 1, 0, -1)))
                - word(order, list(range(1, index)))
            )
            * elements[index - 1]
        )
    return elements


def verify_order(order: int) -> dict[str, object]:
    generators = {index: burau(order, index) for index in range(1, order)}
    elements = zipper_elements(order)

    for index, element in elements.items():
        expected = (
            sym.prod(q**power - u for power in range(1, index))
            * rank_one_matrix(order, index - 1)
        )
        assert is_zero(element - expected)

    exceptional_left = (
        q * generators[2].inv() + (1 - q) * sym.eye(order) - generators[2]
    ) * elements[2]
    exceptional_right = (
        q * barred_word(order, [2, 1]) - word(order, [1, 2])
    ) * elements[2]
    assert is_zero(exceptional_left - exceptional_right)

    for index in range(3, order):
        left = (
            q ** (index - 1)
            * barred_word(order, list(range(index, 1, -1)))
            - word(order, list(range(2, index + 1)))
        ) * elements[index]
        right = (
            q ** (index - 1)
            * barred_word(order, list(range(index, 0, -1)))
            - word(order, list(range(1, index + 1)))
        ) * elements[index]
        assert is_zero(left - right)

    assert is_zero(generators[1] * elements[2] + u * elements[2])

    three_strand_full_twist = word(order, [1, 2]) ** 3
    assert is_zero(
        three_strand_full_twist * elements[3] - u**3 * elements[3]
    )

    for index in range(2, order + 1):
        full_twist = word(order, list(range(1, index))) ** index
        assert is_zero(full_twist * elements[index] - u**index * elements[index])

    specialized = {index: sym.simplify(value.subs(u, q**3)) for index, value in elements.items()}
    assert specialized[3].rank() == 1
    assert not is_zero(specialized[3])
    if order >= 4:
        assert is_zero(specialized[4])
        assert all(is_zero(specialized[index]) for index in range(4, order + 1))
    assert is_zero(
        (generators[1] * elements[2] + q**3 * elements[2]).subs(u, q**3)
    )
    assert is_zero(
        (
            three_strand_full_twist * elements[3]
            - q**9 * elements[3]
        ).subs(u, q**3)
    )

    return {
        "order": order,
        "original_zipper_relations": "passed",
        "generic_x3_rank": int(elements[3].rank()),
        "generic_twist_x2_scalar": "-u",
        "generic_twist_x3_scalar": "u^3",
        "all_k_full_twist_scalar": "u^k",
        "specialization": "u=q^3",
        "specialized_twist_x2_scalar": "-q^3",
        "specialized_twist_x3_scalar": "q^9",
        "specialized_x3_rank": int(specialized[3].rank()),
        "specialized_x4_zero": order < 4 or is_zero(specialized[4]),
        "specialized_all_xk_from_4_zero": order < 4
        or all(is_zero(specialized[index]) for index in range(4, order + 1)),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    records = [verify_order(order) for order in range(4, 9)]
    payload = {
        "schema": "bigelow-zipper-twist-extension-v1",
        "status": "passed",
        "coefficient_field": "Q(q)",
        "generic_field": "Q(q,u)",
        "theorem": {
            "generic_twists": [
                "rho(sigma_1 X_2)=-u rho(X_2)",
                "rho((sigma_1 sigma_2)^3 X_3)=u^3 rho(X_3)",
            ],
            "specialized_relations": [
                "rho_q(sigma_1 X_2)=-q^3 rho_q(X_2)",
                "rho_q((sigma_1 sigma_2)^3 X_3)=q^9 rho_q(X_3)",
                "rho_q(X_4)=0",
                "rho_q(X_3) is nonzero of rank one",
            ],
        },
        "orders_checked": records,
        "scope": (
            "The replay certifies the Burau representation and its finite-dimensional "
            "image. It does not assert that the universal quotient by the three new "
            "relations is itself finite-dimensional."
        ),
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    print(rendered, end="")


if __name__ == "__main__":
    main()
