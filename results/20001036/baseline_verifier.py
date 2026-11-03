"""Independently check a state-closure certificate, without running its producer."""

import argparse
import json
from pathlib import Path


def verify(certificate):
    graph = certificate["graph"]
    n, k = graph["n"], graph["k"]
    if type(n) is not int or type(k) is not int or n < 1 or not 1 <= k <= 16:
        raise ValueError("Invalid finite graph bounds")
    edges = {}
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
        edges[u, v] = set(labels)
    rows = certificate["vertices"]
    if len(rows) != n or sorted(row["vertex"] for row in rows) != list(range(n)):
        raise ValueError("Need exactly one certificate row per vertex")
    degrees, reachable, deficits = [], [], []
    for row in sorted(rows, key=lambda item: item["vertex"]):
        start = row["vertex"]
        states = {tuple(state) for state in row["states"]}
        if len(states) != len(row["states"]) or (start, 0) not in states:
            raise ValueError("Repeated state or missing initial state")
        for v, mask in states:
            if type(v) is not int or type(mask) is not int or not 0 <= v < n or not 0 <= mask < 1 << k:
                raise ValueError("State outside its finite domain")
            if not mask and v != start:
                raise ValueError("Spurious empty-path state")
            if mask:
                has_predecessor = any(
                    head == v and mask & (1 << (c - 1))
                    and (tail, mask ^ (1 << (c - 1))) in states
                    for (tail, head), labels in edges.items() for c in labels
                )
                if not has_predecessor:
                    raise ValueError("State has no justified predecessor")
            for (tail, head), labels in edges.items():
                if tail == v:
                    for c in labels:
                        bit = 1 << (c - 1)
                        if not mask & bit and (head, mask | bit) not in states:
                            raise ValueError("Certificate is not closed under rainbow extension")
        endpoints = sorted({v for v, mask in states if mask})
        degree = sum(len(labels) for (u, _), labels in edges.items() if u == start)
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
