#!/usr/bin/env python3
"""Exact finite checks for the paper's combinatorial and matrix conventions."""

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
from functools import lru_cache
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
PAPER = ROOT / "paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def dihedral_key(i, j, m):
    a = i + j
    require(a % 2 == 1, "a reflection parameter must be odd")
    if m is not None:
        return (0, a % (2 * m))
    return (0 if a > 0 else 1, a)


def dihedral_arrow(i, j):
    return abs(i) < abs(j) and (i - j) % 2 == 1


def dihedral_interval(i, c, vertices):
    return [v for v in vertices if v == i or v == c or abs(i) < abs(v) < abs(c)]


def later_difference(i, j, c, vertices, m, reverse=False):
    interval = dihedral_interval(i, c, vertices)
    edge_key = dihedral_key(i, j, m)

    def count(a):
        return sum(
            dihedral_arrow(a, z)
            and ((dihedral_key(a, z, m) < edge_key) if reverse
                 else (dihedral_key(a, z, m) > edge_key))
            for z in interval
        )

    return count(i) - count(j)


def check_dihedral(max_m, cap):
    cases = 0
    for m in [*range(2, max_m + 1), None]:
        vertices = list(range(-m + 1, m + 1)) if m else list(range(-cap, cap + 1))
        for i, j in itertools.permutations(vertices, 2):
            if not dihedral_arrow(i, j):
                continue
            k = (abs(j) - abs(i) - 1) // 2
            for c in vertices:
                if c != j and abs(c) <= abs(j):
                    continue
                for reverse in [False, True]:
                    require(later_difference(i, j, c, vertices, m, reverse) == k,
                            f"later count failed: {(m, i, j, c, reverse)}")
                    cases += 1
    return cases


def length(w):
    return sum(a > b for i, a in enumerate(w) for b in w[i + 1:])


def leq(x, y):
    return all(
        all(a <= b for a, b in zip(sorted(x[:k]), sorted(y[:k])))
        for k in range(1, len(x) + 1)
    )


def reflect(w, root):
    a, b = root
    return tuple(b if v == a else a if v == b else v for v in w)


def edge_label(x, y, roots):
    matches = [r for r in roots if reflect(x, r) == y]
    require(len(matches) == 1, "edge must be a single left reflection")
    return matches[0]


def reconstruct(interval, comparable, lengths):
    edges = {(a, c) for a, c in comparable
             if a in interval and c in interval and lengths[c] == lengths[a] + 1}
    while True:
        additions = set()
        for a, c in comparable - edges:
            if a not in interval or c not in interval:
                continue
            first = [p for p in interval if (a, p) in edges and (p, c) in comparable]
            for p, q in itertools.combinations(first, 2):
                last = [r for r in interval
                        if (p, r) in edges and (q, r) in edges and (r, c) in edges]
                if len(last) >= 2:
                    additions.add((a, c))
                    break
        if not additions:
            return edges
        edges |= additions


def check_graph(actual, reconstructed):
    require(actual == reconstructed, "six-vertex closure differs from the reflection graph")


def poly_add(a, b):
    c = [0] * max(len(a), len(b))
    for i, v in enumerate(a):
        c[i] += v
    for i, v in enumerate(b):
        c[i] += v
    while c and c[-1] == 0:
        c.pop()
    return tuple(c)


def poly_mul(a, b):
    if not a or not b:
        return ()
    c = [0] * (len(a) + len(b) - 1)
    for i, u in enumerate(a):
        for j, v in enumerate(b):
            c[i + j] += u * v
    return tuple(c)


def poly_eval(a, q):
    return sum((c * q ** i for i, c in enumerate(a)), Fraction(0))


def check_path_polynomials(matrix, decreasing, increasing):
    require(matrix == decreasing == increasing,
            "matrix and path polynomials differ coefficientwise")


def check_r_normalization(paths, r, gap):
    for direction in (1, -1):
        expected = {direction * (2 * i - gap): c for i, c in enumerate(r) if c}
        substituted = {}
        for degree, coefficient in enumerate(paths):
            for j in range(degree + 1):
                power = direction * (degree - 2 * j)
                substituted[power] = substituted.get(power, 0) + (
                    coefficient * (-1) ** j * comb(degree, j)
                )
        substituted = {power: c for power, c in substituted.items() if c}
        require(substituted == expected,
                f"R normalization differs coefficientwise (direction={direction})")


def plane_roots(alpha, beta, roots):
    shared = set(alpha) & set(beta)
    if shared:
        support = set(alpha) | set(beta)
        return tuple(r for r in roots if set(r) <= support)
    return tuple(sorted((alpha, beta)))


def relative_length(w, plane):
    positions = {a: w.index(a) for a in range(1, len(w) + 1)}
    return sum(positions[a] > positions[b] for a, b in plane)


def coset(seed, plane):
    found = {seed}
    todo = [seed]
    while todo:
        w = todo.pop()
        for root in plane:
            v = reflect(w, root)
            if v not in found:
                found.add(v)
                todo.append(v)
    return found


def check_transport(vertices, roots, actual, order):
    def inverse(w):
        return tuple(w.index(i) + 1 for i in range(1, len(w) + 1))

    transported_order = {
        e: order[edge_label(inverse(e[0]), inverse(e[1]), roots)] for e in actual
    }
    planes = {plane_roots(a, b, roots) for a, b in itertools.combinations(roots, 2)}
    intervals_checked = counts_checked = 0
    for plane in planes:
        remaining = set(vertices)
        while remaining:
            component = coset(next(iter(remaining)), plane)
            remaining -= component
            lengths = {w: relative_length(w, plane) for w in component}
            for x, c in itertools.permutations(component, 2):
                if lengths[c] - lengths[x] < 2:
                    continue
                interval = {v for v in component
                            if v in (x, c) or lengths[x] < lengths[v] < lengths[c]}
                atoms = [a for a in interval if lengths[a] == lengths[x] + 1]
                require(len(atoms) == 2, "relative interval must have two atoms")
                ix, ic = inverse(x), inverse(c)
                first_labels = [edge_label(ix, inverse(a), roots) for a in atoms]
                target_plane = plane_roots(*first_labels, roots)
                target_coset = coset(ix, target_plane)
                lx = relative_length(ix, target_plane)
                lc = relative_length(ic, target_plane)
                target_interval = {
                    v for v in target_coset if v in (ix, ic)
                    or lx < relative_length(v, target_plane) < lc
                }
                require({inverse(v) for v in interval} == target_interval,
                        "inversion fails full relative interval transport")
                require(all(relative_length(inverse(v), target_plane) - lx
                            == lengths[v] - lengths[x] for v in interval),
                        "inversion changes relative ranks")
                intervals_checked += 1
                for y in interval:
                    if (x, y) not in actual:
                        continue
                    threshold = transported_order[(x, y)]

                    def later(a):
                        return sum((a, z) in actual
                                   and transported_order[(a, z)] > threshold
                                   for z in interval)

                    k = (lengths[y] - lengths[x] - 1) // 2
                    require(later(x) - later(y) == k, "transported later count failed")
                    counts_checked += 1
    return intervals_checked, counts_checked


def check_type_a(n):
    vertices = tuple(itertools.permutations(range(1, n + 1)))
    roots = tuple(itertools.combinations(range(1, n + 1), 2))
    lengths = {w: length(w) for w in vertices}
    comparable = {(x, y) for x in vertices for y in vertices if x != y and leq(x, y)}
    actual = {(x, reflect(x, r)) for x in vertices for r in roots
              if lengths[x] < lengths[reflect(x, r)]}
    intervals = 0
    for u, b in comparable:
        interval = {v for v in vertices if leq(u, v) and leq(v, b)}
        check_graph({e for e in actual if e[0] in interval and e[1] in interval},
                    reconstruct(interval, comparable, lengths))
        intervals += 1

    for x, y in actual:
        alpha = edge_label(x, y, roots)
        planes = {plane_roots(alpha, beta, roots) for beta in roots if beta != alpha}

        total = 0
        for plane in planes:
            gap = relative_length(y, plane) - relative_length(x, plane)
            require(gap > 0 and gap % 2 == 1, "relative edge gap is not positive odd")
            total += (gap - 1) // 2
        require(2 * total == lengths[y] - lengths[x] - 1, "planar sum failed")

    @lru_cache(None)
    def r_poly(x, y):
        if not leq(x, y):
            return ()
        if x == y:
            return (1,)
        simple = next((a, a + 1) for a in range(1, n)
                      if lengths[reflect(y, (a, a + 1))] < lengths[y])
        sx, sy = reflect(x, simple), reflect(y, simple)
        if lengths[sx] < lengths[x]:
            return r_poly(sx, sy)
        return poly_add(poly_mul((-1, 1), r_poly(x, sy)),
                        poly_mul((0, 1), r_poly(sx, sy)))

    @lru_cache(None)
    def p_poly(x, y):
        if not leq(x, y):
            return ()
        if x == y:
            return (1,)
        d = lengths[y] - lengths[x]
        total = ()
        for z in vertices:
            if z != x and leq(x, z) and leq(z, y):
                total = poly_add(total, poly_mul(r_poly(x, z), p_poly(z, y)))
        p = tuple(total[d - i] if d - i < len(total) else 0
                  for i in range((d + 1) // 2))
        reciprocal = [0] * (d + 1)
        for i, c in enumerate(p):
            reciprocal[d - i] = c
        require(poly_add(tuple(reciprocal), tuple(-v for v in p)) == total,
                "KL reciprocity failed")
        return p

    weights = [4 ** i for i in range(n - 1)]
    order = {r: Fraction(sum(weights[r[0] - 1:r[1] - 1]), r[1] - r[0])
             for r in roots}
    require(len(set(order.values())) == len(roots), "geometric reflection order has ties")
    transport_cases, transported_counts = check_transport(vertices, roots, actual, order)
    schedule = sorted(actual, key=lambda e: order[edge_label(*e, roots)])

    def path_polynomial(x, z, decreasing=True):
        @lru_cache(None)
        def visit(v, previous):
            if v == z:
                return (1,)
            answer = ()
            for a, b in actual:
                if a != v or not leq(b, z):
                    continue
                label = order[edge_label(a, b, roots)]
                if previous is None or (label < previous if decreasing else label > previous):
                    answer = poly_add(answer, (0,) + visit(b, label))
            return answer
        return visit(x, None)

    path_cases = 0
    for z in vertices:
        state = {x: (1,) if x == z else () for x in vertices}
        for x, y in schedule:
            state[x] = poly_add(state[x], (0,) + state[y])
        for x in vertices:
            if not leq(x, z):
                require(state[x] == (), "matrix creates a noncomparable entry")
                continue
            d = lengths[z] - lengths[x]
            check_path_polynomials(state[x], path_polynomial(x, z),
                                   path_polynomial(x, z, False))
            check_r_normalization(state[x], r_poly(x, z), d)
            p_poly(x, z)
            path_cases += 1

    identity = tuple(range(1, n + 1))
    examples = {}
    if n == 4:
        for top in [(3, 4, 1, 2), (4, 2, 3, 1)]:
            examples["".join(map(str, top))] = list(p_poly(identity, top))
    return {
        "vertices": len(vertices), "nontrivial_intervals": intervals,
        "reflection_edges_and_planar_sums": len(actual),
        "relative_intervals_transported_by_inversion": transport_cases,
        "transported_schedule_later_count_cases": transported_counts,
        "matrix_path_R_and_KL_reciprocity_pairs": path_cases,
        "coefficientwise_checks": {
            "matrix_and_both_path_orders": "Z[T]",
            "R_normalization_and_q_inversion": "Z[z,z^-1], q=z^2",
            "KL_reciprocity": "Z[q]",
        },
        "P_identity_top_coefficients": examples,
    }, actual


def check_sources():
    entries = json.loads((HERE / "paper-directory.json").read_text())
    checked = {}
    for item in entries:
        if item["type"] != "file" or not item["name"].endswith(".tex"):
            continue
        data = (PAPER / item["name"]).read_bytes()
        digest = hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()
        require(digest == item["sha"], f"upstream blob mismatch: {item['name']}")
        checked[item["name"]] = digest
    require(len(checked) == 7, "expected seven top-level paper TeX files")
    return checked


def rejection_tests(actual):
    rejected = 0

    def rejects(call):
        nonlocal rejected
        try:
            call()
        except ValueError:
            rejected += 1
        else:
            raise AssertionError("negative control was accepted")

    rejects(lambda: dihedral_key(0, 2, 3))
    rejects(lambda: check_graph(actual, actual - {next(iter(actual))}))
    false_edge = ((1, 2, 3, 4), (2, 3, 1, 4))
    rejects(lambda: check_graph(actual, actual | {false_edge}))
    rejects(lambda: edge_label(*false_edge, tuple(itertools.combinations(range(1, 5), 2))))
    vertices = [-2, -1, 0, 1, 2, 3]
    rejects(lambda: require(later_difference(0, 3, 3, vertices, 3) == 0,
                            "off-by-one planar exponent"))
    require(later_difference(0, 3, 3, vertices, 3) == 1, "valid control rejected")
    correct, false = (0, 1), (0, -8, 0, 4)
    require(poly_eval(correct, Fraction(3, 2)) == poly_eval(false, Fraction(3, 2)),
            "polynomial negative control must agree at the former test point")
    rejects(lambda: check_path_polynomials(correct, false, correct))
    rejects(lambda: check_r_normalization(false, (-1, 1), 1))
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-dihedral", type=int, default=8)
    parser.add_argument("--infinite-cap", type=int, default=8)
    args = parser.parse_args()
    require(2 <= args.max_dihedral <= 30, "dihedral bound must be between 2 and 30")
    require(2 <= args.infinite_cap <= 30, "infinite truncation must be between 2 and 30")
    result = {"source_commit": "4eaee87548250b2682affda7d05d947c05554bae"}
    result["paper_git_blobs"] = check_sources()
    result["dihedral_later_count_cases_both_orders"] = check_dihedral(
        args.max_dihedral, args.infinite_cap)
    result["type_A3"], actual = check_type_a(4)
    result["rejected_negative_controls"] = rejection_tests(actual)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
