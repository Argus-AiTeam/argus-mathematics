#!/usr/bin/env python3
"""Exact finite checks of capacity regrouping and sparse-ball exponent budgets."""

from fractions import Fraction as Q
from itertools import combinations, product
from math import ceil, factorial


def capacity(weights, tests):
    support = frozenset(i for i, a in enumerate(weights) if a)
    if not support:
        return Q(0), frozenset()
    if any(denominator < 1 for _, denominator in tests):
        raise ValueError("Every normalized test weight must be at least one")
    if any(not any(i in indices and denominator == 1
                   for indices, denominator in tests) for i in support):
        raise ValueError("Every active coordinate requires a unit-weight test")
    return max(
        ((sum((weights[i] for i in indices & support), Q(0)) / denominator,
          indices & support)
         for indices, denominator in tests),
        key=lambda item: item[0],
    )


def floor_log2(value):
    if value < 1:
        raise ValueError("Logarithmic range must be at least one")
    k = 0
    while 2 ** (k + 1) <= value:
        k += 1
    return k


def check_regrouping(amplitudes, tests):
    weights = [a * a for a in amplitudes]
    original = weights[:]
    support_size = sum(bool(a) for a in amplitudes)
    if not support_size:
        return
    total = sum(weights, Q(0))
    cubic = sum((abs(a) ** 3 for a in amplitudes), Q(0))
    threshold = (cubic / total) ** 2
    effective_size = total ** 3 / cubic ** 2
    assert 1 <= effective_size <= support_size
    groups = {}
    while True:
        value, selected = capacity(weights, tests)
        if value <= threshold:
            break
        level = floor_log2(value / threshold)
        group = groups.setdefault(level, {"weights": [Q(0)] * len(weights),
                                         "first_capacity": value,
                                         "bundles": []})
        bundle_mass = sum((weights[i] for i in selected), Q(0))
        density = max(
            bundle_mass / denominator
            for indices, denominator in tests if indices & frozenset(
                i for i, a in enumerate(weights) if a) == selected
        )
        assert density >= value / 2
        group["bundles"].append((bundle_mass, density))
        for i in selected:
            group["weights"][i] = weights[i]
            weights[i] = Q(0)
    assert len(groups) + bool(any(weights)) <= 2 + floor_log2(effective_size)
    assert sum(weights, Q(0)) ** 2 * capacity(weights, tests)[0] <= cubic ** 2
    recovered = weights[:]
    for level, group in groups.items():
        scale = threshold * 2 ** level
        group_capacity, _ = capacity(group["weights"], tests)
        assert group_capacity <= group["first_capacity"] < 2 * scale
        assert all(density >= scale / 2 for _, density in group["bundles"])
        for i, a in enumerate(group["weights"]):
            recovered[i] += a
    assert recovered == original


def check_exponents():
    # Powers of mu in the bad set, excision, Gram matrix, and sample tail.
    assert 2 * 20 - 2 * 8 == 24
    assert Q(24) * Q(2, 3) == 16 > 1
    assert 50 - 20 == 30 > 0
    assert 40 - 20 == 20 > 0
    assert -2 + 3 - 4 < -2  # delta^2 * N^3 * N^-4
    assert 7 - 3 * 3 == -2
    assert -6 + 6 == 0  # N^6 cancels delta^6
    for tau in (Q(1, 1000000), Q(1, 100), Q(1, 3), Q(1)):
        j = ceil(32 / tau) + 1
        theta = Q(1, 1000000) * tau ** 2
        gamma = Q(25, 2) * theta
        assert j <= 34 / tau
        assert 50 * j * gamma <= Q(17, 800) * tau < tau / 4
        sampling_j = ceil(20 / tau) + 1
        assert sampling_j <= 22 / tau
        assert 50 * sampling_j * gamma < tau / 4
    coefficients = [Q(factorial(k)) * (1, 3, 3, 1)[k] * 2 ** (k + 1)
                    for k in range(4)]
    assert coefficients == [2, 12, 48, 96]
    assert sum(coefficients) == 158
    squared_log_coefficients = [
        Q(factorial(k)) * (1, 2, 1)[k] * 2 ** (k + 1)
        for k in range(3)
    ]
    assert squared_log_coefficients == [2, 8, 16]
    assert sum(squared_log_coefficients) == 26


def check_weight_ordered_coloring(weights, neighbors, order=None):
    if not weights or any(w <= 0 for w in weights):
        raise ValueError("Vertex masses must be positive")
    budget = max(Q(weights[x] + sum(weights[y] for y in neighbors[x]),
                   weights[x]) for x in range(len(weights)))
    colors = {}
    if order is None:
        order = sorted(range(len(weights)), key=lambda x: -weights[x])
    assert sorted(order) == list(range(len(weights)))
    for x in order:
        previous = [y for y in neighbors[x] if y in colors]
        assert len(previous) + 1 <= budget, "Colored-neighbor count exceeds mass budget"
        assert all(weights[y] >= weights[x] for y in previous)
        used = {colors[y] for y in previous}
        color = 0
        while color in used:
            color += 1
        colors[x] = color
    assert len(set(colors.values())) <= budget.numerator // budget.denominator
    assert all(colors[x] != colors[y]
               for x in colors for y in neighbors[x])


def check_graphs():
    checked = 0
    for n, possible_weights in ((4, (1, 2, 7)), (5, (1, 7))):
        edges = list(combinations(range(n), 2))
        for mask in range(2 ** len(edges)):
            neighbors = [set() for _ in range(n)]
            for bit, (x, y) in enumerate(edges):
                if mask & 2 ** bit:
                    neighbors[x].add(y)
                    neighbors[y].add(x)
            for weights in product(possible_weights, repeat=n):
                check_weight_ordered_coloring(weights, neighbors)
                checked += 1
    return checked


def main():
    tests = []
    n = 6
    for mask in range(1, 2 ** n):
        indices = frozenset(i for i in range(n) if mask & 2 ** i)
        tests.append((indices, Q(max(1, len(indices) - 1))))
    checked = 0
    for amplitudes in product((Q(0), Q(1, 10000), Q(1), Q(3)), repeat=n):
        check_regrouping(amplitudes, tests)
        checked += 1
    for weights, broken in (
        ([Q(1)], []),
        ([Q(1)], [(frozenset({0}), Q(0))]),
    ):
        try:
            capacity(weights, broken)
        except ValueError:
            pass
        else:
            raise AssertionError("Invalid capacity model was accepted")
    try:
        floor_log2(Q(1, 2))
    except ValueError:
        pass
    else:
        raise AssertionError("Invalid logarithmic range was accepted")
    assert capacity([Q(1), Q(2)], [(frozenset({0, 1}), Q(1))])[0] == 3
    star = [{1, 2, 3}, {0}, {0}, {0}]
    try:
        check_weight_ordered_coloring((2, 1, 1, 1), star, order=(1, 2, 3, 0))
    except AssertionError as error:
        assert str(error) == "Colored-neighbor count exceeds mass budget"
    else:
        raise AssertionError("Ascending-mass star order was accepted")
    check_exponents()
    graphs_checked = check_graphs()
    print(f"PASS: {checked} rational arrays, four rejection tests, exponent budgets")
    print(f"PASS: {graphs_checked} weighted graphs, descending-mass coloring")
    print("Scope: finite regrouping and algebra only; no analytic/geometry certification.")


if __name__ == "__main__":
    main()
