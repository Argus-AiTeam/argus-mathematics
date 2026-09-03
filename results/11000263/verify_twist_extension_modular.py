#!/usr/bin/env python3
"""Independent finite-field replay of the zipper twist identities.

This implementation deliberately avoids SymPy and reconstructs all matrix
operations over several prime fields.
"""

from __future__ import annotations

import json
from pathlib import Path


def eye(n: int) -> list[list[int]]:
    return [[int(i == j) for j in range(n)] for i in range(n)]


def zero(n: int) -> list[list[int]]:
    return [[0 for _ in range(n)] for _ in range(n)]


def add(a: list[list[int]], b: list[list[int]], p: int) -> list[list[int]]:
    return [[(x + y) % p for x, y in zip(rx, ry)] for rx, ry in zip(a, b)]


def scale(c: int, a: list[list[int]], p: int) -> list[list[int]]:
    return [[c * x % p for x in row] for row in a]


def mul(a: list[list[int]], b: list[list[int]], p: int) -> list[list[int]]:
    n = len(a)
    return [
        [sum(a[i][k] * b[k][j] for k in range(n)) % p for j in range(n)]
        for i in range(n)
    ]


def power(a: list[list[int]], exponent: int, p: int) -> list[list[int]]:
    result = eye(len(a))
    base = a
    while exponent:
        if exponent & 1:
            result = mul(result, base, p)
        base = mul(base, base, p)
        exponent //= 2
    return result


def burau(n: int, i: int, u: int, p: int, inverse: bool = False) -> list[list[int]]:
    matrix = eye(n)
    if inverse:
        ui = pow(u, -1, p)
        block = [[0, 1], [ui, 1 - ui]]
    else:
        block = [[1 - u, u], [1, 0]]
    for r in range(2):
        for c in range(2):
            matrix[i - 1 + r][i - 1 + c] = block[r][c] % p
    return matrix


def word(n: int, indices: list[int], u: int, p: int) -> list[list[int]]:
    result = eye(n)
    for i in indices:
        result = mul(result, burau(n, i, u, p), p)
    return result


def barred_word(n: int, indices: list[int], u: int, p: int) -> list[list[int]]:
    result = eye(n)
    for i in reversed(indices):
        result = mul(result, burau(n, i, u, p, inverse=True), p)
    return result


def zipper_elements(n: int, q: int, u: int, p: int) -> dict[int, list[list[int]]]:
    identity = eye(n)
    b1 = burau(n, 1, u, p)
    b1i = burau(n, 1, u, p, inverse=True)
    x = {
        2: add(
            add(scale(q, b1i, p), scale(1 - q, identity, p), p),
            scale(-1, b1, p),
            p,
        )
    }
    for k in range(3, n + 1):
        operator = add(
            scale(
                pow(q, k - 1, p),
                barred_word(n, list(range(k - 1, 0, -1)), u, p),
                p,
            ),
            scale(-1, word(n, list(range(1, k)), u, p), p),
            p,
        )
        x[k] = mul(operator, x[k - 1], p)
    return x


def assert_equal(a: list[list[int]], b: list[list[int]]) -> None:
    assert a == b


def verify_case(n: int, q: int, u: int, p: int) -> None:
    x = zipper_elements(n, q, u, p)
    twist2 = mul(burau(n, 1, u, p), x[2], p)
    assert_equal(twist2, scale(-u, x[2], p))
    full3 = power(word(n, [1, 2], u, p), 3, p)
    assert_equal(mul(full3, x[3], p), scale(pow(u, 3, p), x[3], p))
    for k in range(2, n + 1):
        full = power(word(n, list(range(1, k)), u, p), k, p)
        assert_equal(mul(full, x[k], p), scale(pow(u, k, p), x[k], p))

    left = mul(
        add(
            add(
                scale(q, burau(n, 2, u, p, inverse=True), p),
                scale(1 - q, eye(n), p),
                p,
            ),
            scale(-1, burau(n, 2, u, p), p),
            p,
        ),
        x[2],
        p,
    )
    right = mul(
        add(
            scale(q, barred_word(n, [2, 1], u, p), p),
            scale(-1, word(n, [1, 2], u, p), p),
            p,
        ),
        x[2],
        p,
    )
    assert_equal(left, right)

    for k in range(3, n):
        left = mul(
            add(
                scale(
                    pow(q, k - 1, p),
                    barred_word(n, list(range(k, 1, -1)), u, p),
                    p,
                ),
                scale(-1, word(n, list(range(2, k + 1)), u, p), p),
                p,
            ),
            x[k],
            p,
        )
        right = mul(
            add(
                scale(
                    pow(q, k - 1, p),
                    barred_word(n, list(range(k, 0, -1)), u, p),
                    p,
                ),
                scale(-1, word(n, list(range(1, k + 1)), u, p), p),
                p,
            ),
            x[k],
            p,
        )
        assert_equal(left, right)


def main() -> None:
    cases: list[dict[str, int | str]] = []
    for p, q_value, u_value in [(101, 2, 7), (103, 5, 11), (107, 7, 13)]:
        for n in range(4, 9):
            verify_case(n, q_value, u_value, p)
            cases.append({"field": f"F_{p}", "q": q_value, "u": u_value, "n": n})

    special_cases: list[dict[str, int | str]] = []
    for p, q_value in [(101, 2), (103, 5), (107, 7)]:
        u_value = pow(q_value, 3, p)
        for n in range(4, 9):
            verify_case(n, q_value, u_value, p)
            x = zipper_elements(n, q_value, u_value, p)
            assert x[3] != zero(n)
            assert all(x[k] == zero(n) for k in range(4, n + 1))
            special_cases.append(
                {"field": f"F_{p}", "q": q_value, "u": u_value, "n": n}
            )

    payload = {
        "schema": "bigelow-zipper-twist-extension-modular-v1",
        "status": "passed",
        "implementation": "pure Python finite-field matrices; no SymPy",
        "generic_cases": cases,
        "u_equals_q_cubed_cases": special_cases,
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    Path("twist-extension-modular-verification.json").write_text(
        rendered, encoding="utf-8"
    )
    print(rendered, end="")


if __name__ == "__main__":
    main()
