#!/usr/bin/env python3
"""Exhaustively classify small undirected circulants for candidate 20001159."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any, Iterable

import networkx as nx


def circulant(n: int, lengths: Iterable[int]) -> nx.Graph:
    graph = nx.Graph()
    graph.add_nodes_from(range(n))
    for vertex in range(n):
        for length in lengths:
            graph.add_edge(vertex, (vertex + length) % n)
    return graph


def g_b(k: int, m: int) -> nx.Graph:
    n = 4 * k * m
    lengths = [
        length
        for length in range(1, n // 2 + 1)
        if length % (4 * m) in {1, 4 * m - 1}
    ]
    return circulant(n, lengths)


def complete_bipartite(t: int) -> nx.Graph:
    return nx.complete_bipartite_graph(t, t)


def is_balanced(graph: nx.Graph) -> bool:
    if not nx.is_bipartite(graph):
        return False
    return all(len(cycle) % 4 == 0 for cycle in nx.chordless_cycles(graph))


def original_family_templates(n: int) -> list[nx.Graph]:
    if n % 4:
        return []
    quarter = n // 4
    return [g_b(k, quarter // k) for k in range(1, quarter + 1) if quarter % k == 0]


def corrected_connected_templates(n: int) -> list[nx.Graph]:
    templates = []
    if n % 2 == 0:
        templates.append(complete_bipartite(n // 2))
    if n % 4 == 0:
        quarter = n // 4
        templates.extend(
            g_b(k, quarter // k)
            for k in range(1, quarter + 1)
            if quarter % k == 0 and quarter // k >= 2
        )
    return templates


def isomorphic_to_any(graph: nx.Graph, templates: list[nx.Graph]) -> bool:
    return any(nx.is_isomorphic(graph, template) for template in templates)


def full_corrected_classification(graph: nx.Graph) -> bool:
    components = [graph.subgraph(c).copy() for c in nx.connected_components(graph)]
    first = components[0]
    if not all(nx.is_isomorphic(first, component) for component in components[1:]):
        return False
    return isomorphic_to_any(
        first, corrected_connected_templates(first.number_of_nodes())
    )


def graph_record(n: int, lengths: tuple[int, ...], graph: nx.Graph) -> dict[str, Any]:
    return {
        "order": n,
        "connection_lengths": list(lengths),
        "edge_count": graph.number_of_edges(),
        "component_count": nx.number_connected_components(graph),
        "degree": next(iter(dict(graph.degree()).values())),
    }


def search(max_n: int) -> dict[str, Any]:
    rows = []
    first_counterexample = None
    first_counterexample_with_cycle = None
    total_graphs = 0
    total_balanced = 0
    total_unclassified = 0

    for n in range(2, max_n + 1):
        available_lengths = tuple(range(1, n // 2 + 1))
        row = {
            "order": n,
            "nonempty_circulants_checked": (1 << len(available_lengths)) - 1,
            "balanced": 0,
            "connected_balanced": 0,
            "connected_not_original_G_B": 0,
            "not_corrected_full_classification": 0,
        }
        original_templates = original_family_templates(n)

        for mask in range(1, 1 << len(available_lengths)):
            lengths = tuple(
                length
                for index, length in enumerate(available_lengths)
                if mask & (1 << index)
            )
            graph = circulant(n, lengths)
            total_graphs += 1
            if not is_balanced(graph):
                continue

            row["balanced"] += 1
            total_balanced += 1
            is_connected = nx.is_connected(graph)
            if is_connected:
                row["connected_balanced"] += 1
                if not isomorphic_to_any(graph, original_templates):
                    row["connected_not_original_G_B"] += 1
                    record = graph_record(n, lengths, graph)
                    if first_counterexample is None:
                        first_counterexample = record
                    if first_counterexample_with_cycle is None and graph.number_of_edges() >= n:
                        first_counterexample_with_cycle = record

            if not full_corrected_classification(graph):
                row["not_corrected_full_classification"] += 1
                total_unclassified += 1

        rows.append(row)

    result = {
        "method": (
            "Enumerate every nonempty undirected circulant connection-length set; "
            "use exact NetworkX chordless-cycle enumeration and isomorphism tests."
        ),
        "networkx_version": nx.__version__,
        "max_order": max_n,
        "nonempty_circulants_checked": total_graphs,
        "balanced_circulants_found": total_balanced,
        "unclassified_by_corrected_statement": total_unclassified,
        "first_connected_counterexample_to_original": first_counterexample,
        "first_connected_counterexample_with_a_cycle": first_counterexample_with_cycle,
        "primary_K_3_3_found": first_counterexample_with_cycle
        == {
            "order": 6,
            "connection_lengths": [1, 3],
            "edge_count": 9,
            "component_count": 1,
            "degree": 3,
        },
        "per_order": rows,
    }
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-n", type=int, default=32)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if not 2 <= args.max_n <= 36:
        raise SystemExit("max-n must be between 2 and 36")

    result = search(args.max_n)
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(encoded, encoding="utf-8")
    print(encoded, end="")
    return 0 if result["unclassified_by_corrected_statement"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
