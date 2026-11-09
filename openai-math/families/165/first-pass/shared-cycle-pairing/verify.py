#!/usr/bin/env python3
"""Replay exact orientation tests and check the recorded Lean certificate."""

import argparse
import hashlib
import json
from collections import Counter, deque
from fractions import Fraction as Q
from functools import cmp_to_key
from itertools import combinations, permutations, product
from pathlib import Path


HERE = Path(__file__).resolve().parent
HALF = Q(1, 2)


def point(x, y):
    return Q(x), Q(y)


def sub(a, b):
    return a[0] - b[0], a[1] - b[1]


def det(a, b):
    return a[0] * b[1] - a[1] * b[0]


def orient(a, b, c):
    return det(sub(b, a), sub(c, a))


def sign(x):
    return (x > 0) - (x < 0)


def segment_meeting(a, b, c, d):
    u, v, w = sub(b, a), sub(d, c), sub(c, a)
    denominator = det(u, v)
    if denominator:
        t, s = det(w, v) / denominator, det(w, u) / denominator
        if 0 <= t <= 1 and 0 <= s <= 1:
            p = a[0] + t * u[0], a[1] + t * u[1]
            return p, 0 < t < 1 and 0 < s < 1, sign(denominator)
        return None
    if det(w, u):
        return None
    common = {
        p for p in (a, b, c, d)
        if all(min(x[k], y[k]) <= p[k] <= max(x[k], y[k])
               for x, y in ((a, b), (c, d)) for k in (0, 1))
    }
    if not common:
        return None
    assert len(common) == 1, ("overlapping segments", a, b, c, d)
    return next(iter(common)), False, 0


def intersection(a, b, c, d):
    if {a, b} == {c, d}:
        return 0
    meeting = segment_meeting(a, b, c, d)
    return meeting[2] if meeting and meeting[1] else 0


def order_sign(i, j, cut, size):
    return sign((j - cut) % size - (i - cut) % size)


def circle(t):
    t = Q(t)
    return (1 - t * t) / (1 + t * t), 2 * t / (1 + t * t)


def chord_tests():
    points = [point(1, 0), point(0, 1), point(-1, 0), point(0, -1)]
    cases = 0
    signs = Counter()
    for ranks in permutations(range(4)):
        a, b, c, d = (points[k] for k in ranks)
        actual = intersection(a, b, c, d)
        signs[actual] += 1
        for cut in range(4):
            expected = HALF * (
                order_sign(ranks[0], ranks[2], cut, 4)
                - order_sign(ranks[0], ranks[3], cut, 4)
                - order_sign(ranks[1], ranks[2], cut, 4)
                + order_sign(ranks[1], ranks[3], cut, 4)
            )
            assert actual == expected, (ranks, cut, actual, expected)
            cases += 1
    return {"circular_order_and_cut_cases": cases,
            "oriented_order_types_by_intersection": dict(sorted(signs.items()))}


def shared_spoke_tests():
    cases = 0
    overlaps = Counter()
    for degree in range(2, 5):
        points = [circle(k) for k in range(4 * degree + 1)]
        passages = list(permutations(range(degree), 2))
        for sigma in product((-1, 1), repeat=degree):
            for incoming, outgoing in passages:
                alpha = {incoming: -1, outgoing: 1}
                first = points[4 * incoming + 2], points[4 * outgoing + 2]
                for other_in, other_out in passages:
                    beta = {other_in: -1, other_out: 1}
                    totals = []
                    for shift in (-1, 1):
                        second = (points[4 * other_in + 2 + shift * sigma[other_in]],
                                  points[4 * other_out + 2 + shift * sigma[other_out]])
                        totals.append(intersection(*first, *second))
                    actual = Q(sum(totals), 2)
                    for cut in range(degree):
                        expected = HALF * sum(
                            ae * bf * order_sign(e, f, cut, degree)
                            for e, ae in alpha.items() for f, bf in beta.items()
                        )
                        assert actual == expected, (
                            degree, sigma, incoming, outgoing, other_in, other_out,
                            cut, actual, expected
                        )
                        cases += 1
                        overlaps[len(set(alpha) & set(beta))] += 1
    return {"exact_displacement_cases": cases,
            "cases_by_number_of_shared_spokes": dict(sorted(overlaps.items())),
            "fixed_orientation_assignments": "all, for union degrees 2 through 4"}


def ray_potential(e, p):
    a, b = e
    assert a[0] < b[0]
    if p == a or p == b:
        return HALF
    return Q(a[0] < p[0] < b[0] and orient(a, b, p) < 0)


def down_comparison(u, v):
    if u == v:
        return 0
    if (u[0] > 0) != (v[0] > 0):
        return 1 if u[0] > 0 else -1
    assert det(u, v) != 0
    return sign(det(u, v))


def endpoint_correction(e, f):
    a, b = e
    c, d = f
    result = Q(0)
    for p in set(e) & set(f):
        u, se = (sub(b, a), 1) if p == a else (sub(a, b), -1)
        v, sf = (sub(d, c), 1) if p == c else (sub(c, d), -1)
        result += HALF * se * sf * down_comparison(u, v)
    return result


def sweep_rhs(e, f):
    a, b = e
    c, d = f
    top = HALF * (sign(c[0] - a[0]) - sign(d[0] - a[0])
                  - sign(c[0] - b[0]) + sign(d[0] - b[0]))
    return (ray_potential(e, c) - ray_potential(e, d)
            + ray_potential(f, b) - ray_potential(f, a) - top)


def sweep_tests():
    counts = Counter()
    intersection_signs = Counter()
    for number in (2, 3, 4):
        for heights in product(range(-2, 3), repeat=number):
            vertices = [point(x, y) for x, y in enumerate(heights)]
            if any(orient(*triple) == 0 for triple in combinations(vertices, 3)):
                continue
            edges = list(combinations(vertices, 2))
            for e in edges:
                for f in edges:
                    if len(set(e) | set(f)) != number:
                        continue
                    actual = intersection(*e, *f) + endpoint_correction(e, f)
                    expected = sweep_rhs(e, f)
                    assert actual == expected, (e, f, actual, expected)
                    counts[number] += 1
                    intersection_signs[intersection(*e, *f)] += 1
    return {"cases_by_distinct_endpoint_count": dict(sorted(counts.items())),
            "cases_by_interior_intersection_sign": dict(sorted(intersection_signs.items()))}


def angular_compare(u, v):
    def half(w):
        return 0 if w[1] > 0 or (w[1] == 0 and w[0] > 0) else 1
    hu, hv = half(u), half(v)
    if hu != hv:
        return -1 if hu < hv else 1
    value = det(u, v)
    assert value != 0, ("coincident outward rays", u, v)
    return -sign(value)


def exact_rank(rows):
    matrix = [list(map(Q, row)) for row in rows]
    pivots = []
    for column in range(len(matrix[0])):
        pivot = next((k for k in range(len(pivots), len(matrix)) if matrix[k][column]), None)
        if pivot is None:
            continue
        row = len(pivots)
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        factor = matrix[row][column]
        matrix[row] = [x / factor for x in matrix[row]]
        for k in range(len(matrix)):
            if k != row:
                factor = matrix[k][column]
                matrix[k] = [x - factor * y for x, y in zip(matrix[k], matrix[row])]
        pivots.append(column)
    return len(pivots), pivots


def fixture(name):
    if name == "convex_K4":
        vertices = [point(0, 0), point(3, 0), point(4, 3), point(-1, 4)]
        endpoints = list(combinations(range(4), 2))
        tracks = [[vertices[a], vertices[b]] for a, b in endpoints]
    elif name == "shared_edge_triangles":
        vertices = [point(0, 0), point(4, 0), point(2, 3), point(1, -2)]
        endpoints = [(0, 1), (1, 2), (2, 0), (1, 3), (3, 0)]
        tracks = [[vertices[a], vertices[b]] for a, b in endpoints]
    elif name == "seven_crossings_one_edge_pair":
        vertices = [point(-5, -1), point(5, -1), point(5, 1), point(-5, 1),
                    point(-4, -3), point(4, 0), point(7, 4), point(7, -4)]
        endpoints = [(0, 1), (1, 2), (2, 3), (3, 0),
                     (4, 5), (5, 6), (6, 7), (7, 4)]
        tracks = [[vertices[a], vertices[b]] for a, b in endpoints]
        tracks[4] = [point(-4, -3), point(-3, 0), point(-2, -2), point(-1, 0),
                     point(0, -2), point(1, 0), point(2, -2), point(4, 0)]
    else:
        raise ValueError(name)
    return vertices, endpoints, tracks


def graph_data(vertices, endpoints, tracks):
    edge_count = len(endpoints)
    intersections = [[Q(0) for _ in endpoints] for _ in endpoints]
    meetings = {}
    pair_counts = Counter()
    for e, track in enumerate(tracks):
        assert track[0] == vertices[endpoints[e][0]]
        assert track[-1] == vertices[endpoints[e][1]]
        for i, (a, b) in enumerate(zip(track, track[1:])):
            assert a != b
            for v, p in enumerate(vertices):
                if p in (track[0], track[-1]):
                    continue
                assert not (orient(a, b, p) == 0 and all(
                    min(a[k], b[k]) <= p[k] <= max(a[k], b[k]) for k in (0, 1)
                )), ("edge interior through vertex", e, v)
            for j in range(i + 1, len(track) - 1):
                found = segment_meeting(a, b, track[j], track[j + 1])
                if j == i + 1:
                    assert found and found[0] == b and not found[1]
                else:
                    assert found is None, ("non-simple edge", e, i, j)
        for f in range(e):
            common_vertices = set(endpoints[e]) & set(endpoints[f])
            for a, b in zip(track, track[1:]):
                for c, d in zip(tracks[f], tracks[f][1:]):
                    found = segment_meeting(a, b, c, d)
                    if found is None:
                        continue
                    p, proper, crossing_sign = found
                    if not proper:
                        assert any(p == vertices[v] for v in common_vertices), (
                            "contact at a corner or nonincident endpoint", e, f, p
                        )
                        continue
                    assert not common_vertices, ("adjacent-edge crossing", e, f)
                    assert p not in meetings, ("triple or duplicated spatial crossing", p)
                    meetings[p] = (e, f)
                    pair_counts[e, f] += 1
                    intersections[e][f] += crossing_sign
                    intersections[f][e] -= crossing_sign
    stars = []
    for v in range(len(vertices)):
        incident = [e for e, (a, b) in enumerate(endpoints) if v in (a, b)]
        directions = {}
        for e in incident:
            track = tracks[e]
            directions[e] = sub(track[1], track[0]) if endpoints[e][0] == v else sub(track[-2], track[-1])
        stars.append(sorted(incident, key=cmp_to_key(
            lambda e, f: angular_compare(directions[e], directions[f])
        )))
    return intersections, stars, len(meetings), max(pair_counts.values(), default=0)


def corrected_matrix(intersections, stars, endpoints, cuts):
    result = [row[:] for row in intersections]
    for v, (star, cut) in enumerate(zip(stars, cuts)):
        rotated = star[cut:] + star[:cut]
        for i, e in enumerate(rotated):
            se = 1 if endpoints[e][0] == v else -1
            for f in rotated[i + 1:]:
                sf = 1 if endpoints[f][0] == v else -1
                result[e][f] += HALF * se * sf
                result[f][e] -= HALF * se * sf
    return result


def cycle_basis(vertex_count, endpoints):
    forest = [[] for _ in range(vertex_count)]
    basis = []
    for e, (start, end) in enumerate(endpoints):
        queue = deque([end])
        previous = {end: None}
        while queue and start not in previous:
            v = queue.popleft()
            for w, edge, direction in forest[v]:
                if w not in previous:
                    previous[w] = v, edge, direction
                    queue.append(w)
        if start not in previous:
            forest[start].append((end, e, 1))
            forest[end].append((start, e, -1))
            continue
        z = [Q(0) for _ in endpoints]
        z[e] = 1
        v = start
        while previous[v] is not None:
            parent, edge, direction = previous[v]
            z[edge] += direction
            v = parent
        basis.append(z)
    for z in basis:
        for v in range(vertex_count):
            assert sum(z[e] * ((b == v) - (a == v))
                       for e, (a, b) in enumerate(endpoints)) == 0
    assert exact_rank(basis)[0] == len(basis)
    incidence = [[Q((b == v) - (a == v)) for a, b in endpoints]
                 for v in range(vertex_count)]
    assert len(basis) == len(endpoints) - exact_rank(incidence)[0]
    return basis


def gram(matrix, basis):
    return [[sum(z[e] * y[f] * matrix[e][f]
                 for e in range(len(matrix)) for f in range(len(matrix)))
             for y in basis] for z in basis]


def graph_tests():
    results = {}
    for name in ("convex_K4", "shared_edge_triangles", "seven_crossings_one_edge_pair"):
        vertices, endpoints, tracks = fixture(name)
        interior, stars, crossings, maximum = graph_data(vertices, endpoints, tracks)
        basis = cycle_basis(len(vertices), endpoints)
        cuts_tested = 0
        for cuts in product(*(range(len(star)) for star in stars)):
            matrix = corrected_matrix(interior, stars, endpoints, cuts)
            assert all(value == 0 for row in gram(matrix, basis) for value in row), (name, cuts)
            cuts_tested += 1
        cuts = [0] * len(vertices)
        base = corrected_matrix(interior, stars, endpoints, cuts)
        orientations_tested = 0
        for flips in product((-1, 1), repeat=len(endpoints)):
            other_endpoints = [(a, b) if s == 1 else (b, a)
                               for (a, b), s in zip(endpoints, flips)]
            other_interior = [[interior[e][f] * flips[e] * flips[f]
                               for f in range(len(endpoints))] for e in range(len(endpoints))]
            matrix = corrected_matrix(other_interior, stars, other_endpoints, cuts)
            assert all(matrix[e][f] == base[e][f] * flips[e] * flips[f]
                       for e in range(len(endpoints)) for f in range(len(endpoints)))
            other_basis = [[x * s for x, s in zip(z, flips)] for z in basis]
            assert all(value == 0 for row in gram(matrix, other_basis) for value in row)
            orientations_tested += 1
        if name == "seven_crossings_one_edge_pair":
            assert crossings == 8 and maximum == 7
            assert interior[0][4] == 1 and interior[2][5] == -1
        results[name] = {
            "vertices": len(vertices), "edges": len(endpoints),
            "cycle_basis_dimension": len(basis),
            "spatial_crossings": crossings, "maximum_crossings_per_edge_pair": maximum,
            "all_vertex_cut_choices_tested": cuts_tested,
            "all_edge_orientation_choices_tested": orientations_tested,
            "cycle_basis": [[str(x) for x in z] for z in basis],
            "corrected_cycle_gram": [["0"] * len(basis) for _ in basis],
        }
    return results


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    assert status["exit_code"] == 0
    assert (HERE / "jacobian_stderr.txt").read_text() == ""
    assert response["request"]["operation_id"] == "matrix.rank.compute"
    assert response["request"]["payload"] == payload
    output = response["result"]["output"]
    assert output["matrix"] == payload["matrix"]
    matrix = [[Q(int(x["num"]), int(x["den"])) for x in row]
              for row in payload["matrix"]["entries"]]
    for e, f in product(range(4), repeat=2):
        assert matrix[e][f] == 2 * ((f == 0) - (e == 0))
    rank, pivots = exact_rank(matrix)
    assert (rank, pivots) == (output["rank"], output["pivot_columns"]) == (2, [0, 1])
    return {
        "operation_id": "matrix.rank.compute", "adapter_exit_code": 0,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "rank": rank, "pivot_columns": pivots,
        "payload_file": "jacobian_payload.json", "typed_output_file": "jacobian_output.json",
        "status_file": "jacobian_status.json",
        "scope": "bounded cut-change matrix; not a universal geometric proof",
    }


def lean_replay():
    result = json.loads((HERE / "lean_check.json").read_text())
    assert result["exit_code"] == 0 and result["proof_holes"] == []
    assert result["status"] == "success", result["status"]
    assert result["audit_exit_code"] == 0
    lean = result["tools"]["lean"]
    assert lean["available"] is True
    assert lean["version"].startswith("Lean (version 4.31.0,")
    source = HERE / "Main.lean"
    fidelity = HERE / "STATEMENT_FIDELITY.md"
    assert hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"]
    assert hashlib.sha256(fidelity.read_text().encode()).hexdigest() == result["statement_fidelity_sha256"]
    return {
        "exit_code": 0, "proof_holes": [],
        "audit_exit_code": 0, "lean_version": lean["version"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "result_file": "lean_check.json",
        "scope": "universal real incidence reduction and local sign algebra; geometric bridge proved in REPORT.md, not kernel formalized",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact deterministic certificate")
    args = parser.parse_args()
    certificate = {
        "claim_id": "C_CYCLE_PAIRING",
        "result_class": "known_result",
        "certification_kind": "independent_universal_algebra_with_explicit_geometric_trust_boundary",
        "universal_argument": "REPORT.md",
        "finite_experiments_are_not_universal_proofs": True,
        "chord_orientation": chord_tests(),
        "shared_spoke_averaging": shared_spoke_tests(),
        "sweep_segment_identity": sweep_tests(),
        "normalized_graphs": graph_tests(),
        "jacobian": jacobian_replay(),
        "lean": lean_replay(),
        "manuscript_refutations_established": [],
        "full_crossing_number_formulas_verified": False,
        "independent_reviewer_verdict": "not supplied by this script",
        "publication_novelty": "not established",
    }
    encoded = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    target = HERE / "exact_certificate.json"
    if args.write:
        target.write_text(encoded)
    assert target.read_text() == encoded, "certificate differs from replay"
    print("Exact replay passed: chord signs, shared spokes, sweep identity, graph cycles, Jacobian, and recorded Lean evidence.")


if __name__ == "__main__":
    main()
