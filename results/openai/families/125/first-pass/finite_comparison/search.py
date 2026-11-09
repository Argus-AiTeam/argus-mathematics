#!/usr/bin/env python3
"""Bounded directed-instance stress search using exact rational enclosures."""

import json
import random
from fractions import Fraction as Q
from math import factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent


def point(value):
    return (value, value)


def add(a, b):
    return (a[0] + b[0], a[1] + b[1])


def negative(a):
    return (-a[1], -a[0])


def subtract(a, b):
    return add(a, negative(b))


def multiply(a, b):
    products = [x * y for x in a for y in b]
    return (min(products), max(products))


def scale(value, a):
    return multiply(point(value), a)


def positive(a):
    return (max(a[0], 0), max(a[1], 0))


def integrals(x):
    sums = {(power, n): sum((-x)**j / (factorial(j) * (j + power + 1))
                           for j in range(n + 1))
            for power in (0, 1) for n in (18, 19)}
    return ((sums[1, 19], sums[1, 18]),
            (3 - 2 * sums[0, 18], 3 - 2 * sums[0, 19]))


def check_instance(weights, distances, q, s, x, y):
    n = len(weights)
    P, A = integrals(x)
    m = subtract(subtract(A, point(Q(1))), scale(2 * x, P))
    a = add(add(point(Q(1)), m), scale(2 * y, P))
    radii = []
    for i in range(n):
        bounds = [(distances[i] + distances[t]) / (1 - P[0] * q[t][i])
                  for t in range(n) if q[t][i] < 1]
        radii.append(min(bounds) if bounds else Q(100 + i))
        for t in range(n):
            if q[t][i] < 1:
                assert radii[i] * (1 - P[0] * q[t][i]) <= distances[i] + distances[t]
    total = point(Q(0))
    for i in range(n):
        r = sum(weights[t] * q[t][i] for t in range(n))
        C = subtract(point(Q(1)), scale(s[i], P))
        value = scale((1 - r) * radii[i], C)
        value = add(value, scale(r, add(scale(distances[i], m),
                    scale((2 - s[i]) * y * (distances[i] + 1), P))))
        value = subtract(value, scale(distances[i] + 1, C))
        for t in range(n):
            hinge = positive(subtract(point(distances[t]), scale(distances[i], a)))
            value = subtract(value, scale(weights[t] * (1 - q[t][i]), hinge))
        total = add(total, scale(weights[i], value))
    rhs = scale(Q(199, 100) * max(y - x, 0)**2, P)
    return subtract(total, rhs)


def main():
    rng = random.Random(9000125)
    counts = {"samples": 0, "certified_no_violation": 0, "inconclusive_enclosure": 0,
              "certified_counterexamples": 0, "zero_weight_samples": 0,
              "zero_distance_samples": 0, "asymmetric_samples": 0,
              "q_one_samples": 0}
    largest_upper = None
    for n in range(1, 6):
        for example in range(36):
            raw_weights = [1] + [rng.randrange(5) for _ in range(n - 1)]
            weights = [Q(w, sum(raw_weights)) for w in raw_weights]
            raw_distances = [1] + [rng.randrange(7) for _ in range(n - 1)]
            mean = sum(w * d for w, d in zip(weights, raw_distances))
            distances = [Q(d) / mean for d in raw_distances]
            assert sum(weights) == 1 and sum(w * d for w, d in zip(weights, distances)) == 1
            q = [[Q(rng.randrange(5), 4) for _ in range(n)] for _ in range(n)]
            if example % 6 == 0:
                for t in range(n):
                    q[t][0] = Q(1)
            if example % 6 == 1:
                q = [[Q(0) for _ in range(n)] for _ in range(n)]
            s = [rng.choice([Q(0), Q(1, 3), Q(1)]) for _ in range(n)]
            for x in (Q(0), Q(1, 2), Q(1)):
                for y in (Q(1, 1000), Q(1, 3), Q(1, 2), Q(1)):
                    excess = check_instance(weights, distances, q, s, x, y)
                    counts["samples"] += 1
                    counts["zero_weight_samples"] += int(0 in weights)
                    counts["zero_distance_samples"] += int(0 in distances)
                    counts["asymmetric_samples"] += int(any(q[i][t] != q[t][i]
                                                             for i in range(n) for t in range(n)))
                    counts["q_one_samples"] += int(any(1 in row for row in q))
                    largest_upper = excess[1] if largest_upper is None else max(largest_upper, excess[1])
                    if excess[0] > 0:
                        counts["certified_counterexamples"] += 1
                        witness = {"weights": weights, "D": distances, "q": q, "s": s,
                                   "x": x, "y": y, "excess": excess}
                        (HERE / "counterexample_candidate.json").write_text(
                            json.dumps(witness, default=str, indent=2) + "\n")
                        raise AssertionError("Exact directed counterexample; inspect counterexample_candidate.json")
                    if excess[1] <= 0:
                        counts["certified_no_violation"] += 1
                    else:
                        counts["inconclusive_enclosure"] += 1
    result = {"classification": "bounded stress experiment, not a universal proof",
              "arithmetic": "rational alternating Taylor enclosures through orders 18/19",
              "counts": counts, "largest_excess_upper": str(largest_upper)}
    (HERE / "search_results.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
