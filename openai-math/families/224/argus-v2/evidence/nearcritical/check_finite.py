#!/usr/bin/env python3
"""Exact finite checks for the near-critical review; no simulation or dependencies."""

from fractions import Fraction as Q
from itertools import combinations, product
from math import comb, factorial


def history_weights(times):
    lo, hi = min(times), max(times)
    weights = {}
    cuts = sorted({-2, 2, *times})
    for left, right in zip(cuts, cuts[1:]):
        mid = Q(left + right, 2)
        history = tuple(int(mid <= t) for t in times)
        weights[history] = weights.get(history, 0) + right - left
    for bit in (0, 1):
        history = (bit,) * len(times)
        weights[history] = weights.get(history, 0) - 2
    assert sum(weights.values()) == 0
    norm = sum(abs(w) for w in weights.values())
    assert norm == 2 * (max(hi, 0) - min(lo, 0))
    return weights


def check_histories():
    cases = 0
    q = Q(1, 8)
    for n in range(1, 5):
        for times in product((-1, 0, 1), repeat=n):
            weights = history_weights(times)
            cuts = sorted({Q(0), Q(1), *(Q(1, 2) + q * t for t in times)})
            law = {}
            for left, right in zip(cuts, cuts[1:]):
                u = (left + right) / 2
                history = tuple(int(u <= Q(1, 2) + q * t) for t in times)
                law[history] = law.get(history, 0) + right - left
            for history in product((0, 1), repeat=n):
                p0 = Q(1, 2) if len(set(history)) == 1 else Q(0)
                assert law.get(history, 0) == p0 + q * weights.get(history, 0)
            cases += 1
    return cases


def signed_response(f, phi, w, histories):
    return sum(weight * f[histories.index(tuple(phi[b] for b in history))]
               for history, weight in zip(histories, w))


def exchange_identity(f, g, w, phi_a, phi_b, histories):
    da = g[phi_a[1]] - g[phi_a[0]]
    db = g[phi_b[1]] - g[phi_b[0]]
    return (signed_response(f, phi_a, w, histories) * db
            == signed_response(f, phi_b, w, histories) * da)


def check_signed_exchange():
    histories = list(product((0, 1), repeat=2))
    centered = [w for w in product((-1, 0, 1), repeat=4) if sum(w) == 0]
    monotone = ((0, 0), (0, 1), (1, 1))
    cases = 0
    for f, g, w, phi_a, phi_b in product(
            product((-1, 0, 1), repeat=4), product((-1, 0, 1), repeat=2),
            centered, monotone, monotone):
        assert exchange_identity(f, g, w, phi_a, phi_b, histories)
        cases += 1
    noncentered_rejected = any(
        not exchange_identity(f, g, (1, 0, 0, 0), pa, pb, histories)
        for f, g, pa, pb in product(
            product((0, 1), repeat=4), product((0, 1), repeat=2),
            monotone, monotone))
    nonmonotone_rejected = any(
        not exchange_identity(f, g, w, (1, 0), (0, 1), histories)
        for f, g, w in product(
            product((0, 1), repeat=4), product((0, 1), repeat=2), centered))
    assert noncentered_rejected and nonmonotone_rejected
    return cases


def rectangle_paths(width=3, height=3):
    adjacency = {i: [] for i in range(width * height)}
    for x, y in product(range(width), range(height)):
        u = y * width + x
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            xx, yy = x + dx, y + dy
            if 0 <= xx < width and 0 <= yy < height:
                adjacency[u].append(yy * width + xx)
    paths = []

    def visit(path):
        u = path[-1]
        if u // width == height - 1:
            paths.append((path[0], u, sum(1 << v for v in path)))
            return
        for v in adjacency[u]:
            if v not in path and v // width != 0:
                visit(path + [v])

    for start in range(width):
        visit([start])
    return paths


def vertex_disjoint(paths):
    return all(not p[2] & q[2] for p, q in combinations(paths, 2))


def check_color_order():
    paths = rectangle_paths()
    vertical = [
        (x, x + 6, sum(1 << (x + 3 * y) for y in range(3)))
        for x in range(3)
    ]
    intersecting = (0, 8, sum(1 << v for v in (0, 3, 4, 5, 8)))
    assert intersecting in paths and all(path in paths for path in vertical)
    assert not vertex_disjoint((vertical[1], intersecting))
    assert vertex_disjoint((vertical[0], vertical[1]))
    families = {}
    for k in (1, 2, 3):
        families[k] = []
        for candidate in combinations(paths, k):
            candidate = sorted(candidate)
            if not vertex_disjoint(candidate):
                continue
            assert [p[1] for p in candidate] == sorted(p[1] for p in candidate)
            families[k].append(tuple(p[2] for p in candidate))
    counts = {(deleted, k, word): 0
              for deleted in range(1 << 9) for k in (1, 2, 3)
              for word in product((0, 1), repeat=k)}
    cases = 0
    full = (1 << 9) - 1
    # Each vertex is deleted, white, or black: 3^9 exact configurations.
    for state in product((-1, 0, 1), repeat=9):
        deleted = sum(1 << i for i, bit in enumerate(state) if bit == -1)
        black = sum(1 << i for i, bit in enumerate(state) if bit == 1)
        white = full ^ (black | deleted)
        for k in (1, 2, 3):
            for word in product((0, 1), repeat=k):
                if any(all(mask & (black if bit else white) == mask
                           for mask, bit in zip(family, word))
                       for family in families[k]):
                    counts[deleted, k, word] += 1
        cases += 1
    for deleted in range(1 << 9):
        for k in (1, 2, 3):
            assert len({counts[deleted, k, word]
                        for word in product((0, 1), repeat=k)}) == 1
    assert counts[0, 1, (1,)] > 0
    assert counts[0, 3, (1, 1, 1)] == 1
    return cases, {str(k): counts[0, k, (1,) * k] for k in (1, 2, 3)}


def check_forest_arithmetic():
    # The combinatorial binomial bound in (5.14), entirely rational.
    cases = 0
    for k in range(1, 41):
        for roots in range(7):
            n = (k + roots) ** 2
            truncated = sum(Q(comb(n, j), k ** j) for j in range(k + 1))
            assert truncated <= (1 + Q(1, k)) ** n
            # (1+1/k)^k <= 3 gives an explicit exponential in k.
            assert (1 + Q(1, k)) ** n <= 3 ** ((roots + 1) ** 2 * k)
            assert factorial(k) >= Q(k, 3) ** k
            cases += 1
    return cases


def main():
    print("history laws and sharp TV norm:", check_histories())
    print("centered monotone signed exchanges:", check_signed_exchange())
    print("negative controls: noncentered weight and nonmonotone map rejected")
    cases, counts = check_color_order()
    print("rectangle states with arbitrary deletions:", cases)
    print("path filter controls: intersecting pair rejected; disjoint pair accepted")
    print("un-deleted 3x3 crossing-word counts (of 512):", counts)
    print("forest binomial/factorial rational checks:", check_forest_arithmetic())
    print("PASS (finite local checks, not a proof of the scaling limit)")


if __name__ == "__main__":
    main()
