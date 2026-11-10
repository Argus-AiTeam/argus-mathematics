#!/usr/bin/env python3
"""Exact finite checks for paired queries, exposed collisions and path orders."""

import argparse
import itertools
import json
import math
from collections import Counter
from fractions import Fraction
from functools import lru_cache
from pathlib import Path


def edge(a, b):
    return tuple(sorted((a, b)))


class Graph:
    def __init__(self, vertices, edges):
        self.vertices = tuple(vertices)
        self.edges = frozenset(edge(*e) for e in edges)
        if any(a == b or a not in self.vertices or b not in self.vertices
               for a, b in self.edges):
            raise ValueError("Invalid graph edge")
        self.triangles = tuple(
            (a, b, c)
            for a, b, c in itertools.combinations(self.vertices, 3)
            if {edge(a, b), edge(a, c), edge(b, c)} <= self.edges
        )
        self.triangle_edges = tuple(
            frozenset(itertools.combinations(t, 2)) for t in self.triangles
        )
        self.incident = {
            e: frozenset(i for i, t in enumerate(self.triangle_edges) if e in t)
            for e in self.edges
        }

    def candidates(self, focus, parent):
        return sorted(set().union(*(self.incident[e] for e in focus)) - {parent})


def scan_deletion_times(graph, order):
    deletion = {e: len(order) + 1 for e in graph.edges}
    remaining = set(graph.edges)
    for rank, triangle in enumerate(order, 1):
        edges = graph.triangle_edges[triangle]
        if edges <= remaining:
            for e in edges:
                deletion[e] = rank
            remaining.difference_update(edges)
    return deletion


def check_query_answer(answer, focus, threshold, deletion):
    """The same predicate checks exhaustive outputs and deliberately wrong ones."""
    expected = all(deletion[e] >= threshold for e in focus)
    if answer != expected:
        raise ValueError("Query answer disagrees with the chronological scan")


def finite_queries(graph, order):
    ranks = {triangle: rank for rank, triangle in enumerate(order, 1)}

    @lru_cache(maxsize=None)
    def query(focus, threshold, parent):
        candidates = sorted(graph.candidates(focus, parent), key=ranks.__getitem__)
        for triangle in candidates:
            if ranks[triangle] >= threshold:
                break
            other = tuple(sorted(graph.triangle_edges[triangle] - set(focus)))
            if query(other, ranks[triangle], triangle):
                return False
        return True

    return query, ranks


def exhaustive_queries(max_vertices, max_triangles):
    totals = Counter()
    terminal_leaves = {}
    for n in range(1, max_vertices + 1):
        all_edges = tuple(itertools.combinations(range(n), 2))
        for mask in range(1 << len(all_edges)):
            graph = Graph(range(n), (e for i, e in enumerate(all_edges)
                                     if mask & (1 << i)))
            if len(graph.triangles) > max_triangles:
                totals["graphs_excluded_by_triangle_cap"] += 1
                continue
            totals["graphs"] += 1
            for order in itertools.permutations(range(len(graph.triangles))):
                totals["priority_orders"] += 1
                deletion = scan_deletion_times(graph, order)
                query, ranks = finite_queries(graph, order)
                for e in sorted(graph.edges):
                    for threshold in range(len(order) + 2):
                        check_query_answer(query((e,), threshold, None),
                                           (e,), threshold, deletion)
                        totals["root_answers"] += 1
                for triangle, edges in enumerate(graph.triangle_edges):
                    for focus in itertools.combinations(sorted(edges), 2):
                        check_query_answer(query(focus, ranks[triangle], triangle),
                                           focus, ranks[triangle], deletion)
                        totals["paired_answers"] += 1
                if len(graph.edges) == len(all_edges):
                    leave = sum(time == len(order) + 1 for time in deletion.values())
                    terminal_leaves.setdefault(f"K{n}", Counter())[leave] += 1
    return {
        **dict(totals),
        "complete_graph_terminal_leave_counts": {
            name: dict(sorted(counts.items()))
            for name, counts in sorted(terminal_leaves.items())
        },
    }


class Trace:
    def __init__(self, graph, order):
        self.graph = graph
        self.ranks = {triangle: rank for rank, triangle in enumerate(order, 1)}
        self.labels = []
        self.birth = []
        self.edges = set()
        self.calls = []
        self.exposures = []

    def vertex(self, label, call):
        v = len(self.labels)
        self.labels.append(label)
        self.birth.append(call)
        return v

    def root(self, oriented_edge):
        if edge(*oriented_edge) not in self.graph.edges:
            raise ValueError("Root is not an edge")
        call = len(self.calls)
        a, b = (self.vertex(label, call) for label in oriented_edge)
        self.edges.add(edge(a, b))
        return self.evaluate((edge(a, b),), None, Fraction(1), None)

    def evaluate(self, focus, parent, threshold, parent_call):
        call = len(self.calls)
        self.calls.append({"parent": parent_call, "focus": focus})
        labelled_focus = tuple(edge(self.labels[a], self.labels[b])
                               for a, b in focus)
        candidates = []
        for triangle in self.graph.candidates(labelled_focus, parent):
            responsible = [
                e for e in focus
                if edge(self.labels[e[0]], self.labels[e[1]])
                in self.graph.triangle_edges[triangle]
            ]
            if len(responsible) != 1:
                raise ValueError("Candidate does not meet exactly one focus edge")
            serial = len(self.exposures) + 1
            if serial >= 1000:
                raise ValueError("Fixture trace exceeds its priority separation")
            priority = Fraction(1000 * self.ranks[triangle] + serial,
                                1000 * (len(self.ranks) + 1))
            occurrence = {
                "type": triangle, "call": call, "edge": responsible[0],
                "priority": priority, "child": None,
            }
            self.exposures.append(occurrence)
            candidates.append(occurrence)
        for occurrence in sorted(candidates, key=lambda x: x["priority"]):
            if occurrence["priority"] >= threshold:
                break
            triangle = occurrence["type"]
            x, y = occurrence["edge"]
            third, = set(self.graph.triangles[triangle]) - {
                self.labels[x], self.labels[y]
            }
            child = len(self.calls)
            z = self.vertex(third, child)
            child_focus = (edge(x, z), edge(y, z))
            self.edges.update(child_focus)
            occurrence["child"] = child
            if self.evaluate(child_focus, triangle, occurrence["priority"], call):
                return False
        return True


def check_extra_edge_witness(trace, a, b):
    if a == b or not (0 <= a < len(trace.labels) and 0 <= b < len(trace.labels)):
        raise ValueError("Witness endpoints are invalid")
    if edge(a, b) in trace.edges:
        raise ValueError("Witness is already a formal edge")
    if edge(trace.labels[a], trace.labels[b]) not in trace.graph.edges:
        raise ValueError("Witness labels are not adjacent")
    ancestors = set()
    for v in (a, b):
        call = trace.birth[v]
        while call is not None:
            ancestors.add(call)
            call = trace.calls[call]["parent"]
    vertices = [v for v, call in enumerate(trace.birth) if call in ancestors]
    labels = [trace.labels[v] for v in vertices]
    if len(labels) != len(set(labels)):
        raise ValueError("Witness ancestry is not injectively labelled")


def expect_rejection(predicate, *args):
    try:
        predicate(*args)
    except ValueError as error:
        return str(error)
    raise AssertionError("Deliberately invalid input was accepted")


def check_overlapping_roots(case):
    graph = Graph(case["vertices"], case["edges"])
    order = tuple(graph.triangles.index(tuple(t)) for t in case["priority_order"])
    trace = Trace(graph, order)
    answers = [trace.root(root) for root in case["roots"]]
    types = [occurrence["type"] for occurrence in trace.exposures]
    if len(types) == len(set(types)):
        raise AssertionError("Overlapping-root fixture has no collision")
    for pair in itertools.combinations(range(len(trace.labels)), 2):
        expect_rejection(check_extra_edge_witness, trace, *pair)
    return {"answers": answers, "collision": True, "extra_edge_witnesses": 0}


def check_fixtures(payload):
    case = payload["untraversed_collision"]
    graph = Graph(case["vertices"], case["edges"])
    order = tuple(graph.triangles.index(tuple(t)) for t in case["priority_order"])
    trace = Trace(graph, order)
    answer = trace.root(case["root"])
    grouped = {}
    for occurrence in trace.exposures:
        grouped.setdefault(occurrence["type"], []).append(occurrence)
    untraversed = [
        graph.triangles[t] for t, occurrences in grouped.items()
        if sum(o["child"] is None for o in occurrences) >= 2
    ]
    if tuple(case["repeated_untraversed_type"]) not in untraversed:
        raise AssertionError("Fixture did not expose its untraversed collision")
    witness = tuple(case["witness_formal_vertices"])
    check_extra_edge_witness(trace, *witness)
    deletion = scan_deletion_times(graph, order)
    root_focus = (edge(*case["root"]),)
    check_query_answer(answer, root_focus, len(order) + 1, deletion)
    rejected = {
        "flipped_root_answer": expect_rejection(
            check_query_answer, not answer, root_focus, len(order) + 1, deletion
        )
    }
    for name, pair in case["invalid_witnesses"].items():
        rejected[name] = expect_rejection(check_extra_edge_witness, trace, *pair)
    broken = payload["wrong_singleton_instead_of_pair"]
    triangle = graph.triangles.index(tuple(broken["parent"]))
    focus = tuple(edge(*e) for e in broken["focus"])
    threshold = order.index(triangle) + 1
    wrong_answer = any(deletion[e] >= threshold for e in focus)
    rejected["singleton_or_instead_of_pair"] = expect_rejection(
        check_query_answer, wrong_answer, focus, threshold, deletion
    )
    return {
        "root_answer": answer,
        "visited_calls": len(trace.calls),
        "exposed_occurrences": len(trace.exposures),
        "distinct_exposed_types": len(grouped),
        "repeated_types_with_two_untraversed_occurrences": untraversed,
        "witness_formal_vertices": witness,
        "witness_labels": [trace.labels[v] for v in witness],
        "negative_controls": rejected,
        "overlapping_roots": check_overlapping_roots(payload["overlapping_roots"]),
    }


def check_path_orders(max_length):
    cases = 0
    coefficients = []
    for length in range(max_length + 1):
        coefficient = 0
        permutations = tuple(itertools.permutations(range(length)))
        for trunk in range(length + 1):
            for arm1 in range(length - trunk + 1):
                arm2 = length - trunk - arm1
                parents = [(i - 1, i) for i in range(1, trunk)]
                for start, size in ((trunk, arm1), (trunk + arm1, arm2)):
                    parents.extend((i - 1, i) for i in range(start + 1, start + size))
                    if trunk and size:
                        parents.append((trunk - 1, start))
                count = 0
                for permutation in permutations:
                    position = {vertex: i for i, vertex in enumerate(permutation)}
                    count += all(position[a] < position[b] for a, b in parents)
                expected = math.comb(arm1 + arm2, arm1)
                if count != expected:
                    raise AssertionError("Y-path linear-extension count failed")
                cases += 1
                coefficient += count
        check_order_coefficient(coefficient, length)
        coefficients.append(coefficient)
    return {
        "max_length": max_length,
        "length_triples": cases,
        "coefficients": coefficients,
        "negative_control": expect_rejection(
            check_order_coefficient, coefficients[2] + 1, 2
        ),
    }


def check_order_coefficient(coefficient, length):
    if coefficient != 2 ** (length + 1) - 1:
        raise ValueError("Incorrect summed linear-extension coefficient")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-vertices", type=int, default=5)
    parser.add_argument("--max-triangles", type=int, default=7)
    parser.add_argument("--max-path-length", type=int, default=7)
    parser.add_argument("--fixtures", type=Path,
                        default=Path(__file__).with_name("query_fixtures.json"))
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if not (1 <= args.max_vertices <= 6 and 0 <= args.max_triangles <= 10
            and 2 <= args.max_path_length <= 8):
        parser.error("Use vertices 1..6, triangles 0..10 and path length 2..8")
    result = {
        "scope": "Finite checks only; asymptotic coupling requires the paper's hypotheses.",
        "parameters": {
            "max_vertices": args.max_vertices,
            "max_triangles": args.max_triangles,
        },
        "fixtures": check_fixtures(json.loads(args.fixtures.read_text())),
        "queries": exhaustive_queries(args.max_vertices, args.max_triangles),
        "path_orders": check_path_orders(args.max_path_length),
    }
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
