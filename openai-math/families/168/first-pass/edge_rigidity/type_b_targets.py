#!/usr/bin/env python3
"""Transport singular type-A BMP interval schedules from genuine B3 intervals."""

import argparse
import itertools
import json
from collections import deque
from fractions import Fraction
from pathlib import Path

import networkx as nx

from verify import BMP, check_schedule, interval_graph, length, validate_type_a


def compose(u, v):
    return tuple((1 if a > 0 else -1) * u[abs(a) - 1] for a in v)


def inverse(w):
    answer = [0] * len(w)
    for i, a in enumerate(w, 1):
        answer[abs(a) - 1] = (1 if a > 0 else -1) * i
    return tuple(answer)


class TypeB3:
    def __init__(self):
        self.identity = (1, 2, 3)
        self.simple = [(2, 1, 3), (1, 3, 2), (1, 2, -3)]
        self.length = {self.identity: 0}
        queue = deque([self.identity])
        while queue:
            w = queue.popleft()
            for s in self.simple:
                v = compose(w, s)
                if v not in self.length:
                    self.length[v] = self.length[w] + 1
                    queue.append(v)
        if len(self.length) != 48:
            raise AssertionError("B3 must contain 48 signed permutations")
        for i, j, m in [(0, 1, 3), (1, 2, 4), (0, 2, 2)]:
            w = self.identity
            for k in range(1, m + 1):
                w = compose(w, compose(self.simple[i], self.simple[j]))
                if (w == self.identity) != (k == m):
                    raise AssertionError("Incorrect Coxeter matrix")
        self.roots = {}
        for i in range(3):
            w = list(self.identity)
            w[i] = -w[i]
            self.roots[tuple(w)] = tuple(1 if k == i else 0 for k in range(3))
        for i, j in itertools.combinations(range(3), 2):
            for sign in [1, -1]:
                w = list(self.identity)
                w[i], w[j] = sign * (j + 1), sign * (i + 1)
                self.roots[tuple(w)] = tuple(
                    1 if k == i else -sign if k == j else 0 for k in range(3)
                )
        conjugates = {
            compose(compose(w, s), inverse(w))
            for w in self.length
            for s in self.simple
        }
        if conjugates != set(self.roots):
            raise AssertionError("Root labels do not give all Coxeter reflections")
        self.graph = nx.DiGraph()
        self.graph.add_nodes_from(self.length)
        for x in self.length:
            for t in self.roots:
                y = compose(t, x)
                if self.length[x] < self.length[y]:
                    self.graph.add_edge(x, y)
        self.above = {x: {x} | nx.descendants(self.graph, x) for x in self.length}
        self.intervals = {}
        for u in self.length:
            for b in self.above[u]:
                members = {x for x in self.above[u] if b in self.above[x]}
                graph = nx.DiGraph()
                for x in members:
                    graph.add_node(x, rank=self.length[x] - self.length[u])
                for x, y in self.graph.edges:
                    if x in members and y in members and self.length[y] == self.length[x] + 1:
                        graph.add_edge(x, y)
                if set(nx.transitive_closure_dag(graph).edges) != {
                    (x, y) for x in members for y in members
                    if x != y and y in self.above[x]
                }:
                    raise AssertionError("Hasse graph failed to recover the interval order")
                key = (self.length[b] - self.length[u], len(members), graph.number_of_edges())
                self.intervals.setdefault(key, []).append((u, b, graph))

    def label(self, x, y):
        return self.roots[compose(y, inverse(x))]

    def orders(self):
        h = (3, 2, 1)
        orders = []
        signatures = set()
        for f in itertools.permutations([1, 4, 16]):
            scores = {}
            for root in self.roots.values():
                denominator = sum(a * b for a, b in zip(root, h))
                if denominator <= 0:
                    raise AssertionError("h is not positive on all positive roots")
                scores[root] = Fraction(sum(a * b for a, b in zip(root, f)), denominator)
            if len(set(scores.values())) != len(scores):
                continue
            signature = tuple(sorted(scores, key=scores.get))
            if signature not in signatures:
                signatures.add(signature)
                orders.append((h, f, scores))
        if not orders:
            raise AssertionError("No geometric B3 order was produced")
        return orders


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=Path(__file__).with_name("search.json"))
    parser.add_argument("--output", type=Path, default=Path(__file__).with_name("search_b3.json"))
    args = parser.parse_args()
    target = TypeB3()
    orders = target.orders()
    cases = json.loads(args.source.read_text())["cases"]
    isomorphisms = 0
    schedules = 0
    reports = []
    for case in cases:
        bmp = BMP.from_export(case["bmp"])
        validate_type_a(bmp.n)
        permutations = tuple(itertools.permutations(range(1, bmp.n + 1)))
        for bottom in bmp.vertices:
            if len(bmp.shifts[bottom]) <= 1:
                continue
            source = interval_graph(permutations, bottom, bmp.top)
            key = (length(bmp.top) - length(bottom), len(source), source.number_of_edges())
            for u, b, graph in target.intervals.get(key, []):
                matcher = nx.algorithms.isomorphism.DiGraphMatcher(
                    source, graph, node_match=lambda x, y: x["rank"] == y["rank"]
                )
                for iso in matcher.isomorphisms_iter():
                    isomorphisms += 1
                    for h, f, scores in orders:
                        schedules += 1
                        defect = check_schedule(bmp, bottom, iso, scores, target.label)
                        if defect:
                            args.output.write_text(json.dumps({
                                "result_class": "candidate_exact_counterexample",
                                "source_top": list(bmp.top),
                                "source_bottom": list(bottom),
                                "target_type": "B3",
                                "target_top": list(b),
                                "target_bottom": list(u),
                                "isomorphism": [[list(x), list(iso[x])] for x in sorted(iso)],
                                "target_geometric_order": {"h": h, "f": f},
                                "defect": defect,
                                "bmp": bmp.export(),
                            }, indent=2) + "\n")
                            print(f"DEFECT saved to {args.output}", flush=True)
                            return
        reports.append({"source_top": list(bmp.top), "module_comparisons": len(bmp.tested)})
    args.output.write_text(json.dumps({
        "result_class": "finite_verification",
        "target_type": "B3",
        "target_group_size": len(target.length),
        "target_reflections": len(target.roots),
        "source_file": str(args.source),
        "isomorphisms_tested": isomorphisms,
        "schedules_tested": schedules,
        "orders": [{"h": h, "f": f} for h, f, _ in orders],
        "cases": reports,
        "limitation": "Finite cross-type test only; no uniform image-rigidity conclusion.",
    }, indent=2) + "\n")
    print(f"No defect in {schedules} schedules over {isomorphisms} "
          f"genuine A-to-B3 interval isomorphisms", flush=True)


if __name__ == "__main__":
    main()
