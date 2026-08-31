#!/usr/bin/env python3
import itertools
import json
import sys
from fractions import Fraction


POINTS = (
    (Fraction(2), Fraction(1)),
    (Fraction(0), Fraction(1, 2)),
    (Fraction(-2), Fraction(1)),
    (Fraction(-1), Fraction(0)),
    (Fraction(-2), Fraction(-1)),
    (Fraction(0), Fraction(-1, 2)),
    (Fraction(2), Fraction(-1)),
    (Fraction(1), Fraction(0)),
)
VERTICES = tuple(range(len(POINTS)))


def canonical_edge(a, b):
    return (a, b) if a < b else (b, a)


def vector(a, b):
    return (b[0] - a[0], b[1] - a[1])


def cross_vectors(a, b):
    return a[0] * b[1] - a[1] * b[0]


def cross(a, b, c):
    return cross_vectors(vector(a, b), vector(a, c))


def dot(a, b):
    return a[0] * b[0] + a[1] * b[1]


def squared_length(a, b):
    difference = vector(a, b)
    return dot(difference, difference)


def on_segment(a, b, p):
    return (
        cross(a, b, p) == 0
        and min(a[0], b[0]) <= p[0] <= max(a[0], b[0])
        and min(a[1], b[1]) <= p[1] <= max(a[1], b[1])
    )


def segments_intersect(a, b, c, d):
    ab_c = cross(a, b, c)
    ab_d = cross(a, b, d)
    cd_a = cross(c, d, a)
    cd_b = cross(c, d, b)
    if ab_c == 0 and on_segment(a, b, c):
        return True
    if ab_d == 0 and on_segment(a, b, d):
        return True
    if cd_a == 0 and on_segment(c, d, a):
        return True
    if cd_b == 0 and on_segment(c, d, b):
        return True
    return (ab_c > 0) != (ab_d > 0) and (cd_a > 0) != (cd_b > 0)


def convex_hull_indices():
    indexed = sorted((point, index) for index, point in enumerate(POINTS))

    def build(sequence):
        hull = []
        for item in sequence:
            while (
                len(hull) >= 2
                and cross(hull[-2][0], hull[-1][0], item[0]) <= 0
            ):
                hull.pop()
            hull.append(item)
        return hull

    lower = build(indexed)
    upper = build(reversed(indexed))
    return tuple(item[1] for item in lower[:-1] + upper[:-1])


def rational(value):
    return {"num": value.numerator, "den": value.denominator}


def rational_point(point):
    return {"x": rational(point[0]), "y": rational(point[1])}


def rational_vector(value):
    return [rational(value[0]), rational(value[1])]


def certificate():
    n = len(POINTS)
    linkage_edges = {
        canonical_edge(index, (index + 1) % n) for index in VERTICES
    }
    half_turn = {index: (index + 4) % n for index in VERTICES}

    edge_vectors = {
        edge: vector(POINTS[edge[0]], POINTS[edge[1]])
        for edge in sorted(linkage_edges)
    }
    edge_squared_lengths = {
        edge: squared_length(POINTS[edge[0]], POINTS[edge[1]])
        for edge in sorted(linkage_edges)
    }
    turn_determinants = [
        cross(POINTS[index], POINTS[(index + 1) % n], POINTS[(index + 2) % n])
        for index in VERTICES
    ]
    twice_signed_area = sum(
        POINTS[index][0] * POINTS[(index + 1) % n][1]
        - POINTS[index][1] * POINTS[(index + 1) % n][0]
        for index in VERTICES
    )

    nonadjacent_pairs_checked = []
    nonadjacent_intersections = []
    for first, second in itertools.combinations(sorted(linkage_edges), 2):
        if set(first) & set(second):
            continue
        nonadjacent_pairs_checked.append((first, second))
        if segments_intersect(
            POINTS[first[0]],
            POINTS[first[1]],
            POINTS[second[0]],
            POINTS[second[1]],
        ):
            nonadjacent_intersections.append((first, second))

    hull_cycle = convex_hull_indices()
    hull_edges = {
        canonical_edge(hull_cycle[index], hull_cycle[(index + 1) % len(hull_cycle)])
        for index in range(len(hull_cycle))
    }
    hull_orbits = {
        edge: canonical_edge(half_turn[edge[0]], half_turn[edge[1]])
        for edge in sorted(hull_edges)
    }
    half_turn_edge_images = {
        edge: canonical_edge(half_turn[edge[0]], half_turn[edge[1]])
        for edge in sorted(linkage_edges)
    }

    collinear_triples = [
        triple
        for triple in itertools.combinations(VERTICES, 3)
        if cross(*(POINTS[index] for index in triple)) == 0
    ]
    legal_deleted_edges = sorted(hull_edges - linkage_edges)
    deletion_checks = {
        edge: {
            "partner": hull_orbits[edge],
            "partner_is_distinct": hull_orbits[edge] != edge,
            "partner_is_mandatory_hull_edge": hull_orbits[edge] in hull_edges,
            "partner_remains_after_single_deletion": (
                hull_orbits[edge] in hull_edges - {edge}
            ),
        }
        for edge in legal_deleted_edges
    }

    checks = {
        "vertex_count": n,
        "distinct_vertex_count": len(set(POINTS)),
        "all_linkage_edges_nonzero": all(
            length > 0 for length in edge_squared_lengths.values()
        ),
        "all_56_vertex_triples_checked": len(tuple(itertools.combinations(VERTICES, 3))),
        "collinear_vertex_triples": len(collinear_triples),
        "adjacent_turns_all_nonzero": all(value != 0 for value in turn_determinants),
        "turns_have_both_signs_nonconvex": (
            any(value < 0 for value in turn_determinants)
            and any(value > 0 for value in turn_determinants)
        ),
        "twice_signed_area": rational(twice_signed_area),
        "counterclockwise_positive_area": twice_signed_area > 0,
        "nonadjacent_edge_pairs_checked": len(nonadjacent_pairs_checked),
        "nonadjacent_edge_intersections": len(nonadjacent_intersections),
        "simple_polygon": not nonadjacent_intersections,
        "half_turn_coordinates_exact": all(
            POINTS[half_turn[index]] == (-POINTS[index][0], -POINTS[index][1])
            for index in VERTICES
        ),
        "half_turn_preserves_linkage_edges": (
            set(half_turn_edge_images.values()) == linkage_edges
        ),
        "convex_hull_vertex_set": sorted(hull_cycle),
        "convex_hull_edge_count": len(hull_edges),
        "all_hull_edges_are_nonpolygon_edges": not (hull_edges & linkage_edges),
        "legal_deleted_hull_edge_count": len(legal_deleted_edges),
        "all_hull_edge_orbits_have_size_two": all(
            partner != edge for edge, partner in hull_orbits.items()
        ),
        "all_single_deletions_leave_half_turn_partner_bar": all(
            item["partner_remains_after_single_deletion"]
            for item in deletion_checks.values()
        ),
        "pointed_pseudotriangulation_edge_count": 2 * n - 3,
        "mandatory_linkage_and_hull_edge_count": len(linkage_edges | hull_edges),
        "additional_completion_edge_count": (
            (2 * n - 3) - len(linkage_edges | hull_edges)
        ),
    }

    assert checks["distinct_vertex_count"] == n
    assert checks["all_linkage_edges_nonzero"]
    assert checks["all_56_vertex_triples_checked"] == 56
    assert checks["collinear_vertex_triples"] == 0
    assert checks["adjacent_turns_all_nonzero"]
    assert checks["turns_have_both_signs_nonconvex"]
    assert twice_signed_area == 8
    assert checks["nonadjacent_edge_pairs_checked"] == 20
    assert checks["simple_polygon"]
    assert checks["half_turn_coordinates_exact"]
    assert checks["half_turn_preserves_linkage_edges"]
    assert set(hull_cycle) == {0, 2, 4, 6}
    assert checks["convex_hull_edge_count"] == 4
    assert checks["all_hull_edges_are_nonpolygon_edges"]
    assert checks["legal_deleted_hull_edge_count"] == 4
    assert checks["all_hull_edge_orbits_have_size_two"]
    assert checks["all_single_deletions_leave_half_turn_partner_bar"]
    assert checks["pointed_pseudotriangulation_edge_count"] == 13
    assert checks["mandatory_linkage_and_hull_edge_count"] == 12
    assert checks["additional_completion_edge_count"] == 1

    return {
        "schema_version": 1,
        "claim": (
            "For this half-turn-symmetric nonconvex simple octagon, every standard "
            "Streinu first road-map mechanism deletes one nonpolygon hull edge while "
            "retaining its distinct half-turn partner as a bar; a motion preserving "
            "the original half-turn would therefore restore the deleted distance and "
            "make the completed pointed pseudotriangulation rigid."
        ),
        "witness": {
            "vertices_in_cyclic_order": [
                {"id": index, **rational_point(point)}
                for index, point in enumerate(POINTS)
            ],
            "linkage_edges": [list(edge) for edge in sorted(linkage_edges)],
            "edge_vectors": [
                {"edge": list(edge), "vector": rational_vector(edge_vectors[edge])}
                for edge in sorted(edge_vectors)
            ],
            "edge_squared_lengths": [
                {
                    "edge": list(edge),
                    "squared_length": rational(edge_squared_lengths[edge]),
                }
                for edge in sorted(edge_squared_lengths)
            ],
            "turn_determinants": [rational(value) for value in turn_determinants],
            "half_turn_vertex_map": [
                [index, half_turn[index]] for index in VERTICES
            ],
            "convex_hull_cycle": list(hull_cycle),
            "convex_hull_edges": [list(edge) for edge in sorted(hull_edges)],
            "convex_hull_edge_orbits": [
                {"edge": list(edge), "partner": list(hull_orbits[edge])}
                for edge in sorted(hull_orbits)
            ],
            "single_deletion_checks": [
                {
                    "deleted_edge": list(edge),
                    "partner": list(item["partner"]),
                    "partner_is_distinct": item["partner_is_distinct"],
                    "partner_is_mandatory_hull_edge": (
                        item["partner_is_mandatory_hull_edge"]
                    ),
                    "partner_remains_after_single_deletion": (
                        item["partner_remains_after_single_deletion"]
                    ),
                }
                for edge, item in deletion_checks.items()
            ],
        },
        "checks": checks,
        "proof_obligations": {
            "external_algorithm_contract": (
                "Streinu 2005, Theorem 2.3 and Algorithm 6.1: a simple polygon "
                "extends to a 2n-3-edge pointed pseudotriangulation containing its "
                "polygon and hull edges, and the road-map deletes exactly one "
                "nonpolygon convex-hull edge."
            ),
            "external_rigidity_contract": (
                "Streinu 2005, Theorems 4.10 and 4.14: the full pointed "
                "pseudotriangulation is infinitesimally rigid and deleting one hull "
                "edge gives the unique nontrivial one-degree-of-freedom expansive "
                "trajectory used by the algorithm."
            ),
            "symmetry_distance_identity": (
                "If q_(i+4)(t)=2c(t)-q_i(t), then "
                "q_(a+4)(t)-q_(b+4)(t)=-(q_a(t)-q_b(t)); paired edge "
                "distances are equal even when the half-turn center moves."
            ),
            "universal_single_deletion_obstruction": (
                "For every legal deleted hull edge e, its distinct half-turn "
                "partner h(e) remains a fixed-length bar. Symmetry makes the missing "
                "distance |e| equal to the fixed |h(e)| throughout. All edges of the "
                "full pointed pseudotriangulation then retain their lengths, so local "
                "rigidity makes any continuous motion congruent and therefore not an "
                "algorithmic convexification step."
            ),
            "scope_boundary": (
                "The obstruction covers every completion and every single-hull-edge "
                "choice in the standard Streinu road-map. It does not exclude CDR's "
                "different canonical optimization motion or a modified mechanism "
                "that deletes an entire two-edge symmetry orbit."
            ),
        },
        "all_checks_passed": True,
    }


def main():
    if len(sys.argv) not in {2, 3} or sys.argv[1] not in {"certificate", "verify"}:
        raise SystemExit(f"usage: {sys.argv[0]} certificate | verify CERTIFICATE.json")

    document = certificate()
    if sys.argv[1] == "verify":
        if len(sys.argv) != 3:
            raise SystemExit(f"usage: {sys.argv[0]} verify CERTIFICATE.json")
        with open(sys.argv[2], encoding="utf-8") as stream:
            recorded = json.load(stream)
        if recorded != document:
            raise SystemExit("recorded certificate does not match exact replay")
        print("all_checks_passed=true")
        return

    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {sys.argv[0]} certificate")
    json.dump(document, sys.stdout, indent=2, sort_keys=True)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
