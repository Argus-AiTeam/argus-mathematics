"""Independently check a state-closure certificate, without running its producer."""

import argparse
from functools import lru_cache
import json
from pathlib import Path


def verify(certificate):
    graph = certificate["graph"]
    n, k = graph["n"], graph["k"]
    if type(n) is not int or type(k) is not int or n < 1 or not 1 <= k <= 16:
        raise ValueError("Invalid finite graph bounds")
    edges = set()
    outgoing = [[0] * k for _ in range(n)]
    outdegrees = [0] * n
    for arc in graph["arcs"]:
        u, v = arc["tail"], arc["head"]
        labels = arc["labels"]
        if any(type(x) is not int or not 0 <= x < n for x in (u, v)):
            raise ValueError("Invalid endpoint")
        if u == v or (u, v) in edges or not labels:
            raise ValueError("Not a loopless simple set-labelled digraph")
        if any(type(c) is not int or not 1 <= c <= k for c in labels):
            raise ValueError("Invalid label")
        if len(labels) != len(set(labels)):
            raise ValueError("Repeated label")
        edges.add((u, v))
        head_bit = 1 << v
        for c in labels:
            outgoing[u][c - 1] |= head_bit
        outdegrees[u] += len(labels)
    del edges

    @lru_cache(maxsize=1)
    def positive_closure(first_step):
        # Equal actual first-step relations have equal positive-length closures.
        layers = [0] * (1 << k)
        for c, vertices in enumerate(first_step):
            layers[1 << c] = vertices
        for mask, vertices in enumerate(layers):
            while vertices:
                vertex_bit = vertices & -vertices
                vertices -= vertex_bit
                v = vertex_bit.bit_length() - 1
                available = ((1 << k) - 1) ^ mask
                while available:
                    bit = available & -available
                    available -= bit
                    layers[mask | bit] |= outgoing[v][bit.bit_length() - 1]
        return tuple(layers)

    rows = certificate["vertices"]
    if len(rows) != n or sorted(row["vertex"] for row in rows) != list(range(n)):
        raise ValueError("Need exactly one certificate row per vertex")
    degrees, reachable, deficits = [], [], []
    for source_index, row in enumerate(sorted(rows, key=lambda item: item["vertex"])):
        start = row["vertex"]
        states = {tuple(state) for state in row["states"]}
        if len(states) != len(row["states"]) or (start, 0) not in states:
            raise ValueError("Repeated state or missing initial state")
        layers = [0] * (1 << k)
        for v, mask in states:
            if type(v) is not int or type(mask) is not int or not 0 <= v < n or not 0 <= mask < 1 << k:
                raise ValueError("State outside its finite domain")
            if not mask and v != start:
                raise ValueError("Spurious empty-path state")
            layers[mask] |= 1 << v
        expected = positive_closure(tuple(outgoing[source_index]))
        for mask in range(1, 1 << k):
            if layers[mask] & ~expected[mask]:
                raise ValueError("State has no justified predecessor")
            if expected[mask] & ~layers[mask]:
                raise ValueError("Certificate is not closed under rainbow extension")
        endpoints = sorted({v for v, mask in states if mask})
        degree = outdegrees[source_index]
        if row["D"] != degree or row["R"] != endpoints or row["deficit"] != degree - len(endpoints):
            raise ValueError("Incorrect degree, reachable endpoint, or deficit data")
        degrees.append(degree)
        reachable.append(endpoints)
        deficits.append(degree - len(endpoints))
    acyclic = all(v not in reachable[v] for v in range(n))
    qualifies = acyclic and min(deficits) >= 1
    if certificate["no_rainbow_cycle"] != acyclic or certificate["qualifies"] != qualifies:
        raise ValueError("Incorrect mathematical verdict")
    if certificate["minimum_deficit"] != min(deficits) or certificate["positive_length"] is not True:
        raise ValueError("Incorrect reachability convention or minimum deficit")
    return {
        "no_rainbow_cycle": acyclic,
        "D": degrees,
        "R": reachable,
        "deficits": deficits,
        "qualifies": qualifies,
        "status": "VERIFIED_COUNTEREXAMPLE" if qualifies else "NOT_A_COUNTEREXAMPLE",
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    parser.add_argument("--require-counterexample", action="store_true")
    args = parser.parse_args()
    result = verify(json.loads(args.certificate.read_text()))
    print(json.dumps(result, sort_keys=True))
    if args.require_counterexample and not result["qualifies"]:
        raise SystemExit(1)
