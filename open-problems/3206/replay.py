#!/usr/bin/env python3
import itertools
import json
import sys


MODULUS = 15
CONNECTION_SET = {1, 4, 6, 9, 11, 14}
SOURCE_VERTICES = tuple(range(MODULUS))
TARGET_VERTICES = tuple(range(5))


def pair(a, b):
    return (a, b) if a < b else (b, a)


def cayley_edges():
    return {
        pair(x, (x + step) % MODULUS)
        for x in SOURCE_VERTICES
        for step in CONNECTION_SET
    }


def cycle_edges():
    return {pair(i, (i + 1) % 5) for i in TARGET_VERTICES}


def is_homomorphism(mapping, source_edges, target_edges):
    return all(
        mapping[u] != mapping[v] and pair(mapping[u], mapping[v]) in target_edges
        for u, v in source_edges
    )


def certificate():
    source_edges = cayley_edges()
    target_edges = cycle_edges()
    quotient = {x: x % 5 for x in SOURCE_VERTICES}
    section = {i: (6 * i) % MODULUS for i in TARGET_VERTICES}
    image = set(section.values())
    retraction = {x: section[quotient[x]] for x in SOURCE_VERTICES}

    inverse_closed = all((-step) % MODULUS in CONNECTION_SET for step in CONNECTION_SET)
    identity_excluded = 0 not in CONNECTION_SET
    adjacency_exact = all(
        (pair(x, y) in source_edges) == ((y - x) % MODULUS in CONNECTION_SET)
        for x in SOURCE_VERTICES
        for y in SOURCE_VERTICES
        if x < y
    )
    translation_invariant = all(
        pair((u + shift) % MODULUS, (v + shift) % MODULUS) in source_edges
        for u, v in source_edges
        for shift in SOURCE_VERTICES
    )
    degrees = {
        x: sum(x in edge for edge in source_edges)
        for x in SOURCE_VERTICES
    }

    reached = {0}
    frontier = [0]
    while frontier:
        current = frontier.pop()
        for edge in source_edges:
            if current not in edge:
                continue
            neighbor = edge[0] if edge[1] == current else edge[1]
            if neighbor not in reached:
                reached.add(neighbor)
                frontier.append(neighbor)

    induced_image_edges = {
        edge for edge in source_edges if edge[0] in image and edge[1] in image
    }
    expected_image_edges = {
        pair(section[i], section[(i + 1) % 5])
        for i in TARGET_VERTICES
    }

    quotient_homomorphism = is_homomorphism(
        quotient, source_edges, target_edges
    )
    section_homomorphism = is_homomorphism(
        section, target_edges, source_edges
    )
    retraction_homomorphism = is_homomorphism(
        retraction, source_edges, induced_image_edges
    )
    quotient_section_identity = all(
        quotient[section[i]] == i for i in TARGET_VERTICES
    )
    retraction_fixes_image = all(retraction[x] == x for x in image)

    endomorphisms = []
    for values in itertools.product(TARGET_VERTICES, repeat=5):
        mapping = dict(zip(TARGET_VERTICES, values))
        if is_homomorphism(mapping, target_edges, target_edges):
            endomorphisms.append(values)
    nonautomorphic_endomorphisms = [
        values for values in endomorphisms if set(values) != set(TARGET_VERTICES)
    ]

    checks = {
        "connection_set_inverse_closed": inverse_closed,
        "identity_excluded_no_loops": identity_excluded,
        "cayley_adjacency_equivalence_checked_on_all_105_pairs": adjacency_exact,
        "translation_invariance_checked_on_675_edge_translates": translation_invariant,
        "source_edge_count": len(source_edges),
        "source_is_6_regular": set(degrees.values()) == {6},
        "source_connected_vertices_reached": len(reached),
        "section_image_is_induced_c5": induced_image_edges == expected_image_edges,
        "quotient_homomorphism_edges_checked": (
            len(source_edges) if quotient_homomorphism else 0
        ),
        "section_homomorphism_edges_checked": (
            len(target_edges) if section_homomorphism else 0
        ),
        "quotient_after_section_is_identity": quotient_section_identity,
        "retraction_homomorphism_edges_checked": (
            len(source_edges) if retraction_homomorphism else 0
        ),
        "retraction_fixes_all_image_vertices": retraction_fixes_image,
        "c5_endomorphisms_exhaustively_checked": 5**5,
        "c5_endomorphism_count": len(endomorphisms),
        "c5_nonautomorphic_endomorphism_count": len(nonautomorphic_endomorphisms),
        "power_cardinality_m0": 15**0,
        "power_cardinality_m_ge_1_divisible_by_3": 15 % 3 == 0 and 5 % 3 != 0,
    }
    assert len(source_edges) == 45
    assert all(
        value is True
        for key, value in checks.items()
        if key
        in {
            "connection_set_inverse_closed",
            "identity_excluded_no_loops",
            "cayley_adjacency_equivalence_checked_on_all_105_pairs",
            "translation_invariance_checked_on_675_edge_translates",
            "source_is_6_regular",
            "section_image_is_induced_c5",
            "quotient_after_section_is_identity",
            "retraction_fixes_all_image_vertices",
            "power_cardinality_m_ge_1_divisible_by_3",
        }
    )
    assert len(reached) == MODULUS
    assert quotient_homomorphism
    assert section_homomorphism
    assert retraction_homomorphism
    assert len(endomorphisms) == 10
    assert not nonautomorphic_endomorphisms
    assert 15**0 != 5

    return {
        "schema_version": 1,
        "claim": (
            "Cay(Z_15,{1,4,6,9,11,14}) is connected and has core C5, "
            "which is not a Cayley graph on (Z_15)^m for any m>=0."
        ),
        "witness": {
            "ambient_group": {
                "name": "Z/15Z",
                "power": 1,
                "vertices": list(SOURCE_VERTICES),
            },
            "connection_set": sorted(CONNECTION_SET),
            "adjacency_rule": "x~y iff (y-x) mod 15 is in the connection set",
            "source_edges": [list(edge) for edge in sorted(source_edges)],
            "target_core": {
                "name": "C5",
                "vertices": list(TARGET_VERTICES),
                "edges": [list(edge) for edge in sorted(target_edges)],
            },
            "quotient_map": {
                "formula": "pi(x)=x mod 5",
                "table": [[x, quotient[x]] for x in SOURCE_VERTICES],
            },
            "section": {
                "formula": "sigma(i)=6i mod 15",
                "table": [[i, section[i]] for i in TARGET_VERTICES],
                "ordered_image_cycle": [section[i] for i in TARGET_VERTICES],
            },
            "retraction": {
                "formula": "R(x)=sigma(pi(x))=6x mod 15",
                "table": [[x, retraction[x]] for x in SOURCE_VERTICES],
            },
        },
        "checks": checks,
        "proof_obligations": {
            "c5_is_a_core": (
                "All 5^5 vertex maps were checked; exactly 10 are endomorphisms "
                "and each is a bijective dihedral automorphism."
            ),
            "source_core_is_c5": (
                "The displayed homomorphism and section make the induced C5 a "
                "retract; a graph retracting onto a core has that core."
            ),
            "cardinality_obstruction": (
                "For m=0, 15^m=1. For m>=1, 15^m is divisible by 3, whereas "
                "5 is not; hence 15^m never equals 5."
            ),
        },
        "all_checks_passed": True,
    }


def jacobian_payload():
    source_edges = sorted(cayley_edges())
    target_edges = sorted(cycle_edges())

    def source_label(vertex):
        return f"v{vertex:02d}"

    def target_label(vertex):
        return f"c{vertex}"

    return {
        "vertex_map": {
            "source_graph": {
                "vertices": [source_label(x) for x in SOURCE_VERTICES],
                "edges": [
                    [source_label(u), source_label(v)] for u, v in source_edges
                ],
            },
            "target_graph": {
                "vertices": [target_label(i) for i in TARGET_VERTICES],
                "edges": [
                    [target_label(i), target_label(j)] for i, j in target_edges
                ],
            },
            "rows": [
                {
                    "source_vertex": source_label(x),
                    "target_vertex": target_label(x % 5),
                }
                for x in SOURCE_VERTICES
            ],
        }
    }


if len(sys.argv) != 2 or sys.argv[1] not in {"certificate", "jacobian"}:
    raise SystemExit(f"usage: {sys.argv[0]} certificate|jacobian")

document = certificate() if sys.argv[1] == "certificate" else jacobian_payload()
json.dump(document, sys.stdout, indent=2, sort_keys=True)
sys.stdout.write("\n")
