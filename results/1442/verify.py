#!/usr/bin/env python3
"""Independent exact verifier for audit item 1442.

Only Python integer bitsets and itertools combinations are used.  A vertex is
dominated by a set D exactly when it belongs to the union of the ordinary
closed neighborhoods N[d], d in D.
"""

from collections import Counter, deque
from hashlib import sha256
from itertools import combinations
import json
from math import comb
from pathlib import Path
import sys


def fail(message):
    raise AssertionError(message)


def canonical(edge):
    u, v = edge
    return (u, v) if u < v else (v, u)


def closed_neighborhoods(vertices, edges):
    closed = [(1 << v) for v in vertices]
    for u, v in edges:
        closed[u] |= 1 << v
        closed[v] |= 1 << u
    return closed


def delete_edges_from_closed(base_closed, deleted):
    closed = base_closed.copy()
    for u, v in deleted:
        closed[u] &= ~(1 << v)
        closed[v] &= ~(1 << u)
    return closed


def covers_all(choice, closed, all_mask):
    covered = 0
    for v in choice:
        covered |= closed[v]
    return covered == all_mask


def dominating_sets(vertices, closed, all_mask, size):
    return [
        choice
        for choice in combinations(vertices, size)
        if covers_all(choice, closed, all_mask)
    ]


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: verify.py candidate-graph.json")
    input_path = Path(sys.argv[1])
    raw = input_path.read_bytes()
    data = json.loads(raw)

    vertices = tuple(data["vertices"])
    listed_edges = [tuple(edge) for edge in data["edges"]]
    edges = tuple(canonical(edge) for edge in listed_edges)
    f5 = tuple(canonical(edge) for edge in data["five_edge_witness"])
    paper_d6 = tuple(data["paper_six_vertex_witness"])

    if vertices != tuple(range(18)):
        fail(f"vertices are not exactly 0..17: {vertices}")
    if len(edges) != 27:
        fail(f"edge count is {len(edges)}, expected 27")
    if any(u == v for u, v in edges):
        fail("a self-loop is present")
    if len(set(edges)) != len(edges):
        fail("a duplicate undirected edge is present")
    if any(u not in vertices or v not in vertices for u, v in edges):
        fail("an edge endpoint lies outside the vertex set")

    adjacency = {v: set() for v in vertices}
    for u, v in edges:
        adjacency[u].add(v)
        adjacency[v].add(u)
    degrees = {v: len(adjacency[v]) for v in vertices}
    if set(degrees.values()) != {3}:
        fail(f"graph is not cubic: {degrees}")
    delta = max(degrees.values())

    seen = {vertices[0]}
    queue = deque([vertices[0]])
    while queue:
        u = queue.popleft()
        for w in adjacency[u]:
            if w not in seen:
                seen.add(w)
                queue.append(w)
    if len(seen) != len(vertices):
        fail(f"graph is disconnected; component from 0 is {sorted(seen)}")

    color = {}
    for start in vertices:
        if start in color:
            continue
        color[start] = 0
        queue = deque([start])
        while queue:
            u = queue.popleft()
            for v in adjacency[u]:
                if v not in color:
                    color[v] = 1 - color[u]
                    queue.append(v)
                elif color[v] == color[u]:
                    fail(f"not bipartite: same-color edge {(u, v)}")
    bipartition = [
        sorted(v for v in vertices if color[v] == side)
        for side in (0, 1)
    ]

    all_mask = (1 << len(vertices)) - 1
    base_closed = closed_neighborhoods(vertices, edges)
    original_counts = []
    original_sets_by_size = {}
    for size in range(7):
        sets = dominating_sets(vertices, base_closed, all_mask, size)
        original_sets_by_size[size] = sets
        original_counts.append(len(sets))
    six_sets = original_sets_by_size[6]
    if any(original_counts[:6]):
        fail(f"a dominating set of size at most five exists: counts={original_counts}")
    if len(six_sets) != 297:
        fail(f"six-set count is {len(six_sets)}, expected 297")
    if not covers_all(paper_d6, base_closed, all_mask):
        fail(f"paper six-vertex witness does not dominate: {paper_d6}")

    edge_set = set(edges)
    if len(f5) != 5 or len(set(f5)) != 5 or not set(f5) <= edge_set:
        fail(f"invalid five-edge witness: {f5}")
    f5_closed = delete_edges_from_closed(base_closed, f5)
    f5_counts = []
    f5_sets_by_size = {}
    for size in range(8):
        sets = dominating_sets(vertices, f5_closed, all_mask, size)
        f5_sets_by_size[size] = sets
        f5_counts.append(len(sets))
    if any(f5_counts[:7]):
        fail(f"G-F5 has a dominating set of size at most six: counts={f5_counts}")
    if not f5_sets_by_size[7]:
        fail("G-F5 has no seven-vertex dominating witness")

    survivor_histogram = Counter()
    survivor_counts_digest = sha256()
    minimum_survivors = len(six_sets)
    minimum_four_edge_set = None
    minimum_surviving_six_set = None
    checked = 0
    for deleted in combinations(edges, 4):
        reduced_closed = delete_edges_from_closed(base_closed, deleted)
        survivors = [
            choice
            for choice in six_sets
            if covers_all(choice, reduced_closed, all_mask)
        ]
        count = len(survivors)
        if count == 0:
            fail(f"four-edge deletion has no surviving six-set: {deleted}")
        survivor_histogram[count] += 1
        survivor_counts_digest.update(count.to_bytes(2, "big"))
        if count < minimum_survivors:
            minimum_survivors = count
            minimum_four_edge_set = deleted
            minimum_surviving_six_set = survivors[0]
        checked += 1
    if checked != comb(27, 4) or checked != 17_550:
        fail(f"checked {checked} four-edge sets, expected 17,550")
    if minimum_survivors != 1:
        fail(f"minimum survivor count is {minimum_survivors}, expected 1")

    result = {
        "verdict": "ALL_CHECKS_PASSED",
        "method": "exact exhaustive enumeration with Python integer bitsets",
        "domination_convention": "ordinary closed neighborhood",
        "input": {
            "path": str(input_path),
            "sha256": sha256(raw).hexdigest(),
        },
        "graph": {
            "vertex_count": len(vertices),
            "edge_count": len(edges),
            "simple": True,
            "connected": True,
            "bipartite": True,
            "bipartition": bipartition,
            "degree_sequence": [degrees[v] for v in vertices],
            "cubic": True,
            "maximum_degree": delta,
        },
        "original_domination": {
            "counts_by_size_0_through_6": original_counts,
            "gamma": 6,
            "six_vertex_dominating_set_count": len(six_sets),
            "paper_witness": list(paper_d6),
            "first_lexicographic_witness": list(six_sets[0]),
        },
        "five_edge_deletion": {
            "deleted_edges": [list(edge) for edge in f5],
            "counts_by_size_0_through_7": f5_counts,
            "gamma": 7,
            "first_lexicographic_seven_vertex_witness": list(f5_sets_by_size[7][0]),
        },
        "all_exact_four_edge_deletions": {
            "expected_count": comb(len(edges), 4),
            "checked_count": checked,
            "minimum_surviving_original_six_sets": minimum_survivors,
            "minimum_example_deleted_edges": [
                list(edge) for edge in minimum_four_edge_set
            ],
            "minimum_example_surviving_six_set": list(minimum_surviving_six_set),
            "survivor_count_histogram": {
                str(k): survivor_histogram[k] for k in sorted(survivor_histogram)
            },
            "survivor_counts_order": "lexicographic combinations of listed edge order",
            "survivor_counts_sha256_u16be": survivor_counts_digest.hexdigest(),
        },
        "deduction": {
            "edge_deletion_monotonicity": (
                "If F is a subset of F', then every dominating set of G-F' "
                "also dominates G-F, so gamma(G-F) <= gamma(G-F'). Every "
                "deletion set of size 0..3 extends to a four-edge set; the "
                "verified surviving six-set for that extension also survives "
                "the smaller deletion. Thus no <=4 deletion raises gamma."
            ),
            "bondage_lower_bound": 5,
            "bondage_upper_bound_from_five_edge_witness": 5,
            "bondage_number": 5,
            "teschner_rhs": "3*Delta/2 = 9/2 = 4.5",
            "strict_counterexample": True,
        },
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
