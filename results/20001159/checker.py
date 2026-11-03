#!/usr/bin/env python3
"""Exact finite checker for candidate 20001159 and the K_3,3 witness."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import deque
from pathlib import Path
from typing import Any


def edge(a: int, b: int) -> tuple[int, int]:
    if a == b:
        raise ValueError("loops are not allowed")
    return (a, b) if a < b else (b, a)


def circulant_edges(n: int, lengths: list[int]) -> set[tuple[int, int]]:
    return {edge(v, (v + length) % n) for v in range(n) for length in lengths}


def connected(vertices: list[int], edges: set[tuple[int, int]]) -> bool:
    adjacency = {v: set() for v in vertices}
    for a, b in edges:
        adjacency[a].add(b)
        adjacency[b].add(a)
    seen = {vertices[0]}
    queue = deque([vertices[0]])
    while queue:
        current = queue.popleft()
        for neighbour in adjacency[current] - seen:
            seen.add(neighbour)
            queue.append(neighbour)
    return seen == set(vertices)


def is_induced_cycle(
    subset: tuple[int, ...], edges: set[tuple[int, int]]
) -> bool:
    chosen = set(subset)
    induced = {e for e in edges if e[0] in chosen and e[1] in chosen}
    if len(induced) != len(subset):
        return False
    degrees = {v: 0 for v in subset}
    for a, b in induced:
        degrees[a] += 1
        degrees[b] += 1
    return all(degree == 2 for degree in degrees.values()) and connected(
        list(subset), induced
    )


def verify(witness_path: Path) -> dict[str, Any]:
    data = json.loads(witness_path.read_text(encoding="utf-8"))
    witness = data["primary_witness"]
    n = witness["order"]
    vertices = witness["vertices"]
    declared_edges = {edge(*pair) for pair in witness["edges"]}
    generated_edges = circulant_edges(n, witness["connection_lengths"])

    shift = dict(zip(vertices, witness["cyclic_shift_generator"], strict=True))
    shifted_edges = {edge(shift[a], shift[b]) for a, b in declared_edges}
    orbit = []
    current = vertices[0]
    while current not in orbit:
        orbit.append(current)
        current = shift[current]

    left, right = map(set, witness["bipartition"])
    cross_edges = {edge(a, b) for a in left for b in right}
    bipartition_valid = (
        left.isdisjoint(right)
        and left | right == set(vertices)
        and all((a in left) != (b in left) for a, b in declared_edges)
    )
    complete_bipartite = declared_edges == cross_edges

    holes: list[dict[str, Any]] = []
    for size in range(4, n + 1):
        for subset in itertools.combinations(vertices, size):
            if is_induced_cycle(subset, declared_edges):
                holes.append({"vertices": list(subset), "length": size})

    balanced = bipartition_valid and all(hole["length"] % 4 == 0 for hole in holes)
    possible_gkm_parameters = [
        [k, m]
        for k in range(1, n + 1)
        for m in range(1, n + 1)
        if 4 * k * m == n
    ]

    checks = {
        "edge_list_matches_circulant_definition": declared_edges == generated_edges,
        "non_empty": bool(declared_edges),
        "connected": connected(vertices, declared_edges),
        "shift_is_automorphism": shifted_edges == declared_edges,
        "shift_is_vertex_transitive": len(orbit) == n and set(orbit) == set(vertices),
        "valid_bipartition": bipartition_valid,
        "is_K_3_3": complete_bipartite and len(left) == len(right) == 3,
        "balanced": balanced,
        "all_induced_holes_have_length_divisible_by_4": all(
            hole["length"] % 4 == 0 for hole in holes
        ),
        "not_in_original_G_B_family_by_order": not possible_gkm_parameters,
        "is_corrected_family_member_C2_blowup_K3": complete_bipartite,
    }
    result = {
        "candidate_id": data["candidate_id"],
        "verdict": "CONFIRMED_COUNTEREXAMPLE" if all(checks.values()) else "FAILED",
        "witness": witness["name"],
        "checks": checks,
        "induced_hole_count": len(holes),
        "induced_hole_lengths": sorted({hole["length"] for hole in holes}),
        "induced_holes": holes,
        "possible_positive_G_B_parameters": possible_gkm_parameters,
        "reason_not_G_B": (
            f"The witness has {n} vertices, while every G_B(k,m) has 4*k*m "
            "vertices and hence order divisible by 4."
        ),
    }
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--witness", type=Path, default=Path(__file__).with_name("witness.json")
    )
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    result = verify(args.witness)
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(encoded, encoding="utf-8")
    print(encoded, end="")
    return 0 if result["verdict"] == "CONFIRMED_COUNTEREXAMPLE" else 1


if __name__ == "__main__":
    raise SystemExit(main())
