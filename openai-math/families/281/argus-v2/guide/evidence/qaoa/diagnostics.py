#!/usr/bin/env python3
"""Numerical normalization checks, not certificates of asymptotic theorems."""

import cmath
import json
import math


def edge_correlation(degree_minus_one, gamma, beta):
    d = degree_minus_one
    qubits = 2 * d + 2
    edges = [(0, 1)]
    edges += [(0, j) for j in range(2, d + 2)]
    edges += [(1, j) for j in range(d + 2, qubits)]
    size = 1 << qubits
    state = []
    for bits in range(size):
        energy = sum(
            1 if ((bits >> i) ^ (bits >> j)) & 1 == 0 else -1
            for i, j in edges
        ) / math.sqrt(d)
        state.append(cmath.exp(-1j * gamma * energy) / math.sqrt(size))
    for qubit in range(qubits):
        bit = 1 << qubit
        for index in range(size):
            if index & bit:
                continue
            other = index | bit
            a, b = state[index], state[other]
            state[index] = math.cos(beta) * a - 1j * math.sin(beta) * b
            state[other] = math.cos(beta) * b - 1j * math.sin(beta) * a
    norm = sum(abs(a) ** 2 for a in state)
    if not math.isclose(norm, 1.0, abs_tol=2e-12):
        raise AssertionError(f"state normalization: {norm}")
    return sum(
        abs(a) ** 2 * (1 if (bits ^ (bits >> 1)) & 1 == 0 else -1)
        for bits, a in enumerate(state)
    )


def require_close(actual, expected):
    if not math.isclose(actual, expected, rel_tol=2e-11, abs_tol=2e-12):
        raise AssertionError(f"{actual} != {expected}")


def require_rejection(actual, wrong_expected):
    try:
        require_close(actual, wrong_expected)
    except AssertionError:
        return
    raise AssertionError("negative control was not rejected")


def entropy(m):
    p = (1 - m) / 2
    return -p * math.log(p) - (1 - p) * math.log1p(-p)


def main():
    cases = []
    for d in (1, 2, 3, 4):
        for gamma, beta in ((0.19, 0.27), (-0.41, 0.18), (0.33, -0.31)):
            actual = edge_correlation(d, gamma, beta)
            expected = (
                math.sin(4 * beta)
                * math.sin(2 * gamma / math.sqrt(d))
                * math.cos(2 * gamma / math.sqrt(d)) ** d
            )
            require_close(actual, expected)
            require_rejection(actual, -expected)
            require_rejection(actual, expected / 2)
            require_rejection(actual, expected * 2)
            cases.append({"D": d, "gamma": gamma, "beta": beta,
                          "absolute_error": abs(actual - expected)})
    bounds = []
    for beta in (2, 10, 100):
        bounds.append({
            "inverse_temperature": beta,
            "paper_loss": (0.25 + math.log(2)) / beta,
            "sharper_loss": 0.25 / beta
            + entropy(math.sqrt(1 - 1 / beta)) / beta,
        })
    print(json.dumps({
        "status": "numerical consistency only; not a rigorous certificate",
        "p1_cases": cases,
        "rejected_negative_controls": 3 * len(cases),
        "p1_optimum": 1 / (2 * math.sqrt(math.e)),
        "temperature_loss_comparison": bounds,
    }, indent=2))


if __name__ == "__main__":
    main()
