#!/usr/bin/env python3
"""Exact finite replays for the all-size argument in theorem.md, not its proof."""

import argparse
from collections import Counter
from dataclasses import dataclass
from fractions import Fraction
from functools import cache
from itertools import combinations
import json
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
Q = Fraction


@cache
def dyck(k):
    if k == 0:
        return ("",)
    return tuple(
        "(" + left + ")" + right
        for j in range(k)
        for left in dyck(j)
        for right in dyck(k - 1 - j)
    )


def catalan(k):
    return comb(2 * k, k) // (k + 1)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


@dataclass(frozen=True)
class Map:
    visits: tuple
    dual_visits: tuple
    edges: tuple
    tree: tuple
    horizontal_pairs: tuple
    dual_tree: tuple
    vertex_count: int
    matching: tuple
    rotation: tuple


@dataclass(frozen=True)
class Cut:
    side: int
    times: int
    length: int
    boundary: int


def decode(n, slots, horizontal, vertical):
    hslots = set(slots)
    hp = vp = 0
    primal = [0]
    dual = [0]
    hopen = []
    vopen = []
    edges, tree, pairs, dual_tree = [], [], [], []
    visits, dual_visits = [], []
    matching = [-1] * (2 * n)
    next_primal = next_dual = 1
    for i in range(2 * n):
        visits.append(primal[-1])
        dual_visits.append(dual[-1])
        if i in hslots:
            step = horizontal[hp]
            hp += 1
            if step == "(":
                edge_id = len(edges)
                edges.append((primal[-1], next_primal))
                tree.append(edge_id)
                hopen.append((edge_id, i))
                primal.append(next_primal)
                next_primal += 1
            else:
                edge_id, start = hopen.pop()
                matching[start], matching[i] = i, start
                pairs.append((edge_id, start, i))
                primal.pop()
        else:
            step = vertical[vp]
            vp += 1
            if step == "(":
                dual_tree.append((dual[-1], next_dual))
                dual.append(next_dual)
                next_dual += 1
                vopen.append(i)
            else:
                start = vopen.pop()
                matching[start], matching[i] = i, start
                edges.append((visits[start], visits[i]))
                dual.pop()
    require(primal == dual == [0] and not hopen and not vopen, "open tour")
    require(len(edges) == n, "edge count changed")
    return Map(
        tuple(visits), tuple(dual_visits), tuple(edges), tuple(tree),
        tuple(pairs), tuple(dual_tree), next_primal, tuple(matching),
        tuple((matching[i] + 1) % (2 * n) if i in hslots else
              (i + 1) % (2 * n) for i in range(2 * n)),
    )


def cycles(permutation):
    require(sorted(permutation) == list(range(len(permutation))), "not a permutation")
    remaining = set(range(len(permutation)))
    result = []
    while remaining:
        start = min(remaining)
        orbit = []
        v = start
        while v in remaining:
            remaining.remove(v)
            orbit.append(v)
            v = permutation[v]
        require(v == start, "permutation orbit did not close")
        result.append(tuple(orbit))
    return result


def verify_embedding(m):
    N = len(m.visits)
    require(all(m.matching[m.matching[i]] == i and m.matching[i] != i
                for i in range(N)), "edge matching is not a fixed-point-free involution")
    vertex_cycles = cycles(m.rotation)
    faces = cycles(tuple(m.rotation[m.matching[i]] for i in range(N)))
    require(len(vertex_cycles) == m.vertex_count, "rotation vertex count")
    require(len(vertex_cycles) - len(m.edges) + len(faces) == 2, "nonplanar rotation")
    for orbit in vertex_cycles:
        require(len({m.visits[i] for i in orbit}) == 1, "wrong primal incidence cycle")
    require(len({m.visits[orbit[0]] for orbit in vertex_cycles}) == len(vertex_cycles),
            "different primal cycles identified")
    for orbit in faces:
        require(len({m.dual_visits[i] for i in orbit}) == 1, "wrong dual incidence cycle")
    require(len({m.dual_visits[orbit[0]] for orbit in faces}) == len(faces),
            "different dual cycles identified")


def component(count, edges, tree, omitted):
    adjacency = [[] for _ in range(count)]
    for edge_id in tree:
        if edge_id != omitted:
            a, b = edges[edge_id]
            adjacency[a].append(b)
            adjacency[b].append(a)
    seen = {edges[omitted][1]}
    stack = list(seen)
    while stack:
        for v in adjacency[stack.pop()]:
            if v not in seen:
                seen.add(v)
                stack.append(v)
    return frozenset(seen)


def distances(count, edges):
    adjacency = [[] for _ in range(count)]
    for a, b in edges:
        adjacency[a].append(b)
        adjacency[b].append(a)
    result = []
    for start in range(count):
        row = [-1] * count
        row[start] = 0
        queue = [start]
        for v in queue:
            for w in adjacency[v]:
                if row[w] == -1:
                    row[w] = row[v] + 1
                    queue.append(w)
        require(min(row) >= 0, "disconnected tree")
        result.append(row)
    return result


def inspect_map(m):
    N = len(m.visits)
    verify_embedding(m)
    degrees = [0] * m.vertex_count
    for a, b in m.edges:
        degrees[a] += 1
        degrees[b] += 1
    require([m.visits.count(v) for v in range(m.vertex_count)] == degrees,
            "tour degree identity failed, including loop incidences")
    dual_distance = distances(len(m.dual_tree) + 1, m.dual_tree)
    cuts = []
    all_vertices = frozenset(range(m.vertex_count))
    for edge_id, first, second in m.horizontal_pairs:
        side = component(m.vertex_count, m.edges, m.tree, edge_id)
        length = sum(v in side for v in m.visits)
        if 2 * length > N:
            side = all_vertices - side
            length = N - length
        if 2 * length == N:
            require(m.visits[0] not in side, "tie side contains root")
        times = tuple(i for i, v in enumerate(m.visits) if v in side)
        require(0 < length <= N // 2, "invalid smaller-side size")
        require(sum(((i + 1) % N not in times) for i in times) == 1,
                "cut visits do not form one cyclic interval")
        require(sum(degrees[v] for v in side) == length, "cut mass identity")
        boundary = sum((a in side) != (b in side) for a, b in m.edges)
        require(boundary == 1 + dual_distance[m.dual_visits[first]][
            m.dual_visits[second]], "dual cut distance identity")
        cuts.append(Cut(
            sum(1 << v for v in side), sum(1 << i for i in times),
            length, boundary,
        ))
    return tuple(cuts), tuple(degrees)


def solve_grounded(laplacian, q, mu):
    count = len(q)
    if count == 1:
        return [Q(0)]
    rows = [
        [Q(laplacian[i][j]) for j in range(count - 1)] + [q[i]]
        for i in range(count - 1)
    ]
    for j in range(count - 1):
        pivot = next(i for i in range(j, count - 1) if rows[i][j])
        rows[j], rows[pivot] = rows[pivot], rows[j]
        scale = rows[j][j]
        rows[j] = [x / scale for x in rows[j]]
        for i in range(count - 1):
            if i != j:
                scale = rows[i][j]
                rows[i] = [a - scale * b for a, b in zip(rows[i], rows[j])]
    u = [row[-1] for row in rows] + [Q(0)]
    center = sum(a * b for a, b in zip(mu, u))
    return [x - center for x in u]


def spanning_trees(count, edges):
    choices = [i for i, (a, b) in enumerate(edges) if a != b]
    result = []
    for ids in combinations(choices, count - 1):
        components = list(range(count))

        def root(v):
            while components[v] != v:
                v = components[v]
            return v

        valid = True
        for i in ids:
            a, b = map(root, edges[i])
            if a == b:
                valid = False
                break
            components[a] = b
        if valid:
            result.append(ids)
    require(bool(result), "connected map has no spanning tree")
    return result


def verify_forest(m, degrees):
    count = m.vertex_count
    N = len(m.visits)
    mu = [Q(d, N) for d in degrees]
    f = [Q(0)] * count
    if count > 1:
        f[0], f[-1] = mu[-1], -mu[0]
    q = [a * b for a, b in zip(mu, f)]
    require(sum(q) == 0 and max(map(abs, f)) <= 1, "invalid test source")
    H = [[0] * count for _ in range(count)]
    for a, b in m.edges:
        if a != b:
            H[a][a] += 1
            H[b][b] += 1
            H[a][b] -= 1
            H[b][a] -= 1
    u = solve_grounded(H, q, mu)
    require(all(sum(H[i][j] * u[j] for j in range(count)) == q[i]
                for i in range(count)), "Green equation")
    require(sum(a * b for a, b in zip(mu, u)) == 0, "Green centering")
    trees = spanning_trees(count, m.edges)
    rhs = [Q(0)] * count
    for tree in trees:
        for e in tree:
            side = component(count, m.edges, tree, e)
            boundary = sum((a in side) != (b in side) for a, b in m.edges)
            source = sum(q[v] for v in side)
            mass = sum(mu[v] for v in side)
            for x in range(count):
                rhs[x] += source * (int(x in side) - mass) / boundary / len(trees)
    require(u == rhs, "forest denominator or normalization is incorrect")


def finite_maps():
    rows = []
    forest_tests = 0
    for n in range(1, 6):
        N = 2 * n
        scales = []
        M = 1
        while M <= n:
            scales.append(M)
            M *= 2
        seconds = {M: [Q(0)] * N for M in scales}
        total = groups = loops = multiple = 0
        cut_tests = 0
        for k in range(n + 1):
            for slots in combinations(range(N), 2 * k):
                for horizontal in dyck(k):
                    signature = None
                    vertical_count = 0
                    for vertical in dyck(n - k):
                        m = decode(n, slots, horizontal, vertical)
                        cuts, degrees = inspect_map(m)
                        current = (
                            degrees,
                            tuple(sorted((c.side, c.times, c.length) for c in cuts)),
                        )
                        if signature is None:
                            signature = current
                        require(current == signature,
                                "vertical shape changed masses or smaller-side selection")
                        total += 1
                        vertical_count += 1
                        cut_tests += len(cuts)
                        loops += any(a == b for a, b in m.edges)
                        multiple += len({tuple(sorted(e)) for e in m.edges}) < n
                        primal_distance = distances(
                            m.vertex_count, [m.edges[e] for e in m.tree])
                        for M in scales:
                            eligible = [c for c in cuts if M <= c.length < 2 * M]
                            for t in range(N):
                                active = [c for c in eligible if (c.times >> t) & 1]
                                for a, b in combinations(active, 2):
                                    require(a.side & b.side in (a.side, b.side),
                                            "smaller sides through a visit are not nested")
                                radius = 2 * M + 2
                                window = {m.visits[(t + j) % N]
                                          for j in range(-radius, radius + 1)}
                                diameter = max(primal_distance[a][b]
                                               for a in window for b in window)
                                require(len(active) <= diameter,
                                        "horizontal local-diameter bound failed")
                                U = sum((Q(1, c.boundary) for c in active), Q(0))
                                seconds[M][t] += U * U
                        if n <= 4:
                            verify_forest(m, degrees)
                            forest_tests += 1
                    require(vertical_count == catalan(n - k), "conditional Dyck count")
                    groups += 1
        require(total == catalan(n) * catalan(n + 1), "finite pair enumeration")
        rows.append({
            "n": n,
            "pair_count": total,
            "conditional_groups": groups,
            "cut_checks": cut_tests,
            "maps_with_loops": loops,
            "maps_with_repeated_unoriented_endpoints": multiple,
            "one_scale_second_moment_maxima": {
                str(M): str(max(seconds[M]) / total) for M in scales
            },
        })
    return {"sizes": rows, "forest_identity_tests": forest_tests}


def ballot(length, height):
    if height < 0 or height > length or (length + height) % 2:
        return 0
    k = (length + height) // 2
    return comb(length, k) - (comb(length, k + 1) if k < length else 0)


def contour(word):
    stack = [0]
    vertices = [0]
    edges = []
    next_vertex = 1
    for step in word:
        if step == "(":
            edges.append((stack[-1], next_vertex))
            stack.append(next_vertex)
            next_vertex += 1
        else:
            stack.pop()
        vertices.append(stack[-1])
    return vertices, distances(next_vertex, edges)


def finite_dyck():
    max_inverse = Q(0)
    max_fourth = Q(0)
    marginal_checks = 0
    for k in range(1, 8):
        s = 2 * k
        counts = [[Counter() for _ in range(s + 1)] for _ in range(s)]
        for word in dyck(k):
            vertices, distance = contour(word)
            for i in range(s):
                for j in range(s + 1):
                    counts[i][j][distance[vertices[i]][vertices[(i + j) % s]]] += 1
        for i in range(s):
            for j in range(s + 1):
                expected = Counter({
                    a: ballot(j, a) * ballot(s - j, a)
                    for a in range(k + 1) if ballot(j, a) * ballot(s - j, a)
                })
                require(counts[i][j] == expected, "rerooting or ballot density")
                marginal_checks += 1
                d = 1 + min(j, s - j)
                inverse = sum(Q(amount, (a + 1) ** 2)
                              for a, amount in expected.items()) / catalan(k)
                fourth = sum(Q(amount * a ** 4)
                             for a, amount in expected.items()) / catalan(k)
                max_inverse = max(max_inverse, d * inverse)
                max_fourth = max(max_fourth, fourth / d ** 2)
    return {
        "edge_sizes": [1, 7],
        "rerooted_ballot_marginals_checked": marginal_checks,
        "max_d_times_inverse_second_moment": str(max_inverse),
        "max_fourth_moment_over_d_squared": str(max_fourth),
        "interpretation": "finite identities only; universal estimates are proved in theorem.md",
    }


def verify_jacobian():
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "graph.chip_firing.laplacian.compute"
    require(contract["result"]["operation"]["operation_id"] == operation, "wrong contract")
    require(result["request"]["payload"] == payload, "Jacobian source binding")
    require(result["result"]["operation_id"] == operation, "wrong operation")
    require(status["adapter_exit_code"] == 0 and not status["timed_out"],
            "Jacobian did not complete successfully")
    require(result["result"]["output"] == {
        "vertices": ["a", "b", "c"],
        "degrees": [2, 2, 2],
        "laplacian": [[2, -1, -1], [-1, 2, -1], [-1, -1, 2]],
    }, "unexpected exact Laplacian")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "scope": "simple triangle only; the inspected contract does not certify Dyck, multigraph, or Green estimates",
    }


def certificate():
    require((HERE / "theorem.md").is_file(), "missing universal argument")
    return {
        "claim": "C_GREEN_ESTIMATE",
        "candidate_result_class": "new_theorem",
        "result": "Uniform finite-map L^p Green constants for 1<p<3 and rho<1-1/p; critical 2/3 modulus with logarithmic power beta>4/3.",
        "universal_argument": "research/green_estimate/theorem.md",
        "universal_argument_is_not_certified_by_finite_enumeration": True,
        "external_input": "No model-specific unproved input: Section 1 gives the forward and inverse finite encoding. Bernardi arxiv:math/0601684v1 Section 2 is credited for this known bijection, not assumed.",
        "independent_review": "required; not performed by this verifier",
        "novelty": "bounded primary-source search found no matching theorem; not a novelty certification",
        "manuscript_false_claims_identified": [],
        "excluded_conclusions": ["full diffusion theorem", "unit conductivity",
                                "optimality of exponent 2/3", "mated-CRT transfer"],
        "jacobian": verify_jacobian(),
        "finite_map_checks": finite_maps(),
        "finite_dyck_checks": finite_dyck(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(target.read_text()) == result, "certificate replay mismatch")
    pairs = sum(row["pair_count"] for row in result["finite_map_checks"]["sizes"])
    print(f"Exact replay passed: {pairs:,} map/tree pairs (n=1..5), forest identities "
          "(n=1..4), Dyck marginals (1..7 edges), and the typed Jacobian prerequisite.")
    print("Every decoded embedding has the exact primal/dual incidence cycles and Euler characteristic 2.")
    print("Universal theorem and novelty require independent review; enumeration is not their proof.")


if __name__ == "__main__":
    main()
