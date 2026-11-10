#!/usr/bin/env python3
"""Exactly enumerate the full circuit-component Gram matrix on supplied spheres."""

import argparse
import copy
import json
from collections import defaultdict
from fractions import Fraction
from pathlib import Path


ROOTS = ((1, 0), (0, 1), (-1, -1))


def graph(case):
    n, faces = case["vertices"], case["faces"]
    assert n >= 4
    assert all(len(set(f)) == 3 and all(0 <= v < n for v in f) for f in faces)
    assert len({tuple(sorted(f)) for f in faces}) == len(faces)
    for v in range(n):
        link = defaultdict(set)
        for f in faces:
            if v in f:
                a, b = [u for u in f if u != v]
                link[a].add(b)
                link[b].add(a)
        assert link and all(len(neighbors) == 2 for neighbors in link.values())
        pending, seen = [next(iter(link))], set()
        while pending:
            u = pending.pop()
            if u not in seen:
                seen.add(u)
                pending.extend(link[u])
        assert len(seen) == len(link), "disconnected vertex link"
    incidence = defaultdict(list)
    for t, f in enumerate(faces):
        for j in range(3):
            a, b = f[j], f[(j + 1) % 3]
            incidence[tuple(sorted((a, b)))].append((t, j, a, b))
    assert n - len(incidence) + len(faces) == 2
    adj = [[] for _ in faces]
    for edge, ends in incidence.items():
        assert len(ends) == 2
        t, j, a, b = ends[0]
        u, k, c, d = ends[1]
        assert (a, b) == (d, c), "inconsistent face orientation"
        adj[t].append((u, j, edge))
        adj[u].append((t, k, edge))
    unseen, todo = set(range(len(faces))), [0]
    while todo:
        t = todo.pop()
        if t in unseen:
            unseen.remove(t)
            todo.extend(u for u, _, _ in adj[t])
    assert not unseen, "disconnected dual"
    return faces, adj


def coordinates(adj, spins, omit_isolated=False):
    occupied = {
        t for t, star in enumerate(adj)
        if any(spins[a] != spins[b] for _, _, (a, b) in star)
    }
    labels = []
    while occupied:
        start = min(occupied)
        wall, todo = set(), [start]
        while todo:
            t = todo.pop()
            if t not in wall:
                wall.add(t)
                todo.extend(
                    u for u, _, (a, b) in adj[t]
                    if spins[a] != spins[b]
                )
        occupied -= wall
        components, todo_vertices = {}, set(range(len(adj))) - wall
        while todo_vertices:
            start = min(todo_vertices)
            cid, todo = ("vertex", start), [start]
            while todo:
                t = todo.pop()
                if t in todo_vertices:
                    todo_vertices.remove(t)
                    components[t] = cid
                    todo.extend(u for u, _, _ in adj[t] if u not in wall)
        tags = defaultdict(dict)
        for t in wall:
            missing = [(u, j, edge) for u, j, edge in adj[t]
                       if spins[edge[0]] == spins[edge[1]]]
            assert len(missing) == 1
            u, j, edge = missing[0]
            if u in wall:
                if omit_isolated:
                    continue
                cid = ("open-edge", edge)
            else:
                cid = components[u]
            tags[cid][t] = j
        labels.extend(tags.values())
    return labels


def gram(case, omit_isolated=False, reverse_one=False):
    faces, adj = graph(case)
    result = [[(0, 0) for _ in faces] for _ in faces]
    for bits in range(1 << case["vertices"]):
        spins = [(bits >> v) & 1 for v in range(case["vertices"])]
        for tags in coordinates(adj, spins, omit_isolated):
            for t, j in tags.items():
                for u, k in tags.items():
                    jt = -j if reverse_one and t == 0 else j
                    ku = -k if reverse_one and u == 0 else k
                    a, b = ROOTS[(jt - ku) % 3]
                    x, y = result[t][u]
                    result[t][u] = (x + a, y + b)
    denominator = 1 << case["vertices"]
    return [[(Fraction(a, denominator), Fraction(b, denominator))
             for a, b in row] for row in result]


def check(case, **kwargs):
    matrix = gram(case, **kwargs)
    for t, row in enumerate(matrix):
        for u, entry in enumerate(row):
            expected = (Fraction(3, 4) if t == u else Fraction(0), Fraction(0))
            assert entry == expected, (case["name"], t, u, entry, expected)


def must_reject(label, action):
    try:
        action()
    except AssertionError as error:
        print(f"REJECT {label}: {error}")
    else:
        raise AssertionError(f"negative control accepted: {label}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", type=Path)
    args = parser.parse_args()
    cases = json.loads(args.witness.read_text())
    for case in cases:
        check(case)
        print(f"PASS {case['name']}: {1 << case['vertices']} colorings, "
              f"{len(case['faces'])}x{len(case['faces'])} Gram = (3/4)I in Q(omega)")
    tetra = cases[0]
    must_reject("omitted isolated open edges", lambda: check(tetra, omit_isolated=True))
    must_reject("reversed cyclic order at one star", lambda: check(tetra, reverse_one=True))
    broken = copy.deepcopy(tetra)
    broken["faces"][0] = broken["faces"][1]
    must_reject("duplicate face", lambda: check(broken))
    broken = copy.deepcopy(tetra)
    broken["faces"][0].reverse()
    must_reject("inconsistently oriented face", lambda: check(broken))


if __name__ == "__main__":
    main()
