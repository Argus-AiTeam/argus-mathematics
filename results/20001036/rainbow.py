"""Exact positive-length rainbow reachability for finite set-labelled digraphs."""

import argparse
import json
from pathlib import Path


def validate_graph(graph):
    n, k = graph["n"], graph["k"]
    if type(n) is not int or type(k) is not int or n < 1 or not 1 <= k <= 16:
        raise ValueError("Require n >= 1 and 1 <= k <= 16 for this bounded checker")
    adjacency = [[] for _ in range(n)]
    seen = set()
    for edge in graph["arcs"]:
        u, v, labels = edge["tail"], edge["head"], edge["labels"]
        if type(u) is not int or type(v) is not int or not 0 <= u < n or not 0 <= v < n:
            raise ValueError("Arc endpoint outside V")
        if u == v or (u, v) in seen:
            raise ValueError("Loops and parallel arcs are outside the frozen target")
        if not labels or any(type(c) is not int or not 1 <= c <= k for c in labels):
            raise ValueError("Every present arc must have nonempty labels in 1,...,k")
        if len(set(labels)) != len(labels):
            raise ValueError("Labels are sets, not multisets")
        seen.add((u, v))
        adjacency[u].append((v, sum(1 << (c - 1) for c in labels)))
    return adjacency


def analyze(graph):
    adjacency = validate_graph(graph)
    n, k = graph["n"], graph["k"]
    rows = []
    cycle = None
    for start in range(n):
        states = {(start, 0)}
        todo = [(start, 0)]
        parent = {}
        for u, mask in todo:
            for v, labels in adjacency[u]:
                available = labels & ~mask
                while available:
                    bit = available & -available
                    available -= bit
                    state = (v, mask | bit)
                    if state not in states:
                        states.add(state)
                        todo.append(state)
                        parent[state] = (u, mask, bit.bit_length())
                    if v == start and cycle is None:
                        walk, current = [], state
                        while current != (start, 0):
                            old_u, old_mask, label = parent[current]
                            walk.append([old_u, current[0], label])
                            current = (old_u, old_mask)
                        walk.reverse()
                        cycle = walk
        endpoints = sorted({v for v, mask in states if mask})
        degree = sum(labels.bit_count() for _, labels in adjacency[start])
        rows.append({
            "vertex": start,
            "D": degree,
            "R": endpoints,
            "deficit": degree - len(endpoints),
            "states": [list(state) for state in sorted(states, key=lambda p: (p[1], p[0]))],
        })
    minimum = min(row["deficit"] for row in rows)
    return {
        "graph": graph,
        "positive_length": True,
        "rainbow_closed_walk": cycle,
        "no_rainbow_cycle": cycle is None,
        "minimum_deficit": minimum,
        "qualifies": cycle is None and minimum >= 1,
        "vertices": rows,
    }


def from_masks(matrix, k):
    return {
        "n": len(matrix),
        "k": k,
        "arcs": [
            {"tail": u, "head": v, "labels": [c + 1 for c in range(k) if mask & (1 << c)]}
            for u, row in enumerate(matrix)
            for v, mask in enumerate(row)
            if mask
        ],
    }


def cycle_free_profile(matrix, k):
    n = len(matrix)
    outgoing = [[0] * k for _ in range(n)]
    degrees = [0] * n
    for u, row in enumerate(matrix):
        for v, labels in enumerate(row):
            degrees[u] += labels.bit_count()
            while labels:
                bit = labels & -labels
                labels -= bit
                outgoing[u][bit.bit_length() - 1] |= 1 << v
    endpoints = []
    for start in range(n):
        states = [0] * (1 << k)
        states[0] = 1 << start
        reached = 0
        for mask, vertices in enumerate(states):
            if mask:
                if vertices & (1 << start):
                    return None
                reached |= vertices
            while vertices:
                vertex_bit = vertices & -vertices
                vertices -= vertex_bit
                u = vertex_bit.bit_length() - 1
                available = ((1 << k) - 1) ^ mask
                while available:
                    bit = available & -available
                    available -= bit
                    states[mask | bit] |= outgoing[u][bit.bit_length() - 1]
        endpoints.append(reached)
    return degrees, endpoints


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("graph", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = analyze(json.loads(args.graph.read_text()))
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({key: result[key] for key in (
        "no_rainbow_cycle", "minimum_deficit", "qualifies"
    )}))


if __name__ == "__main__":
    main()
