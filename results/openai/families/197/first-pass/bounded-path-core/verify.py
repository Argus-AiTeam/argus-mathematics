#!/usr/bin/env python3
"""Replay exact arithmetic, actual-path regressions, and the formal certificate.

The universal analytic theorem is in theorem.md. Finite regressions are not
presented as a proof of that theorem or as a manuscript counterexample.
"""

import argparse
from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from decimal import Decimal, ROUND_FLOOR, localcontext
from fractions import Fraction as F
from functools import cache
import hashlib
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
V = 16513
T = V + 7
P = F(129, V)
LAMBDA = F(71589573988, 72026254783)
TAU = (1 - LAMBDA) / 2
A = 5
C_BIN = 11


@dataclass(frozen=True)
class Edge:
    u: int
    v: int
    label: int


@dataclass
class PathData:
    steps: list[tuple[int, int]]
    closed: bool = True
    root: int | None = None


@dataclass(frozen=True)
class Comparison:
    left: int
    start_left: int
    right: int
    start_right: int
    length: int
    inverse: bool = False


def bar(a):
    assert 0 <= a < T
    if a >= V:
        return a - V
    if a < 7:
        return V + a
    return a + 1 if (a - 7) % 2 == 0 else a - 1


def weight(a, b):
    x = bar(a)
    if x == b:
        return F(0)
    if x < V and b < V:
        return F(1, 129)
    if x >= V and b >= V:
        return F(1, 2)
    return P


@cache
def word_weight(word):
    return math.prod((weight(a, b) for a, b in zip(word, word[1:])),
                     start=F(1))


E_LOWER = sum((F(1, math.factorial(k)) for k in range(31)), F(0))
E_UPPER = E_LOWER + F(1, 30 * math.factorial(30))


@cache
def word_bin(p):
    assert 0 < p <= 1
    with localcontext() as ctx:
        ctx.prec = 100
        x = Decimal(p.denominator).ln() - Decimal(p.numerator).ln()
        d = int(x.to_integral_value(rounding=ROUND_FLOOR))
    # Rational bounds certify the candidate floor, rather than trusting a log.
    assert E_UPPER ** d * p <= 1, "uncertified lower bin boundary"
    assert E_LOWER ** (d + 1) * p > 1, "uncertified upper bin boundary"
    return d


def quotient():
    return [
        [7 * P * P, (V - 7) * P * P, F(3, 2)],
        [F(7, 129 ** 2), F(V - 8, 129 ** 2), 7 * P * P],
        [F(6, 129 ** 2), F(V - 7, 129 ** 2), 7 * P * P],
    ]


def exact_word_evidence():
    q = quotient()
    f = [4, 1, 1]
    ratios = [sum((q[i][j] * f[j] for j in range(3)), F(0)) / f[i]
              for i in range(3)]
    assert max(ratios) == LAMBDA
    assert 0 < LAMBDA < 1 and 0 < TAU < F(1, 4)
    assert all(0 <= x for row in q for x in row)
    assert min(F(1, 129), P, F(1, 2)) == F(1, 129)
    exp5_lower = sum((F(5) ** k / math.factorial(k) for k in range(10)),
                     F(0))
    assert exp5_lower > 129 > 1 / P
    assert 4 * T < 2 ** 17 and T < 2 ** 15
    assert E_LOWER > 2
    assert C_BIN >= 1 + F(17, 2) + 2 * TAU
    eps = TAU / (2 * (A - TAU))
    assert eps == F(87336159, 287930346814)
    assert TAU - (A - TAU) * eps == TAU / 2
    assert all(bar(bar(a)) == a and bar(a) != a for a in range(T))
    classes = [range(7), range(7, V), range(V, T)]
    derived = [[sum((weight(a, b) ** 2 for b in group), F(0))
                for group in classes] for a in (0, 7, V)]
    assert derived == q, "quotient does not match the actual turn weights"
    trace = sum((q[i][i] for i in range(3)), F(0))
    minors = sum((q[i][i] * q[j][j] - q[i][j] * q[j][i]
                  for i in range(3) for j in range(i + 1, 3)), F(0))
    det = F(0)
    for perm in itertools.permutations(range(3)):
        inversions = sum(perm[i] > perm[j]
                         for i in range(3) for j in range(i + 1, 3))
        det += (-1) ** inversions * math.prod(
            (q[i][perm[i]] for i in range(3)), start=F(1))
    coeffs = [F(1), -trace, minors, -det]
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    typed = payload["matrix"]["entries"]
    assert [[F(int(x["num"]), int(x["den"])) for x in row]
            for row in typed] == q
    result = json.loads((HERE / "jacobian_result.json").read_text())
    assert result["tool"] == "math.run"
    assert result["request"]["operation_id"] == \
        "matrix.characteristic_polynomial.compute"
    assert result["request"]["payload"] == payload
    assert "error" not in result and "error" not in result["result"]
    out = result["result"]["output"]
    assert out["degree"] == 3 and out["monic"]
    assert out["convention"] == "DET_LAMBDA_I_MINUS_A"
    got = [F(int(x["num"]), int(x["den"]))
           for x in out["coefficients_descending"]]
    assert got == coeffs
    return {
        "alphabet_size": T,
        "class_sizes": [7, V - 7, 7],
        "class_order": ["ordinary_paired_with_extra", "other_ordinary", "extra"],
        "quotient": [[str(x) for x in row] for row in q],
        "positive_vector": f,
        "row_ratios": [str(x) for x in ratios],
        "lambda": str(LAMBDA),
        "tau": str(TAU),
        "A": A,
        "bin_error_c": C_BIN,
        "epsilon": str(eps),
        "epsilon_margin": str(TAU / 2),
        "exp_5_rational_lower_bound": str(exp5_lower),
        "characteristic_polynomial_descending": [str(x) for x in coeffs],
        "jacobian": {
            "operation_id": result["request"]["operation_id"],
            "server_version": result["server"]["version"],
            "protocol_version": result["protocol_version"],
            "adapter_status": "completed",
            "structured_error": None,
            "timeout": False,
            "runtime_ms": result["result"]["runtime_ms"],
        },
    }


RECIPES = [
    {"id": "parallel-repeated-cycles", "kind": "cycles", "length": 512,
     "repeats": [2, 2], "mode": "parallel", "scale": "128", "kappa": "1/8"},
    {"id": "inverse-repeated-cycles", "kind": "cycles", "length": 512,
     "repeats": [2, 2], "mode": "inverse", "scale": "128", "kappa": "1/8"},
    {"id": "translation-self-links", "kind": "cycles", "length": 512,
     "repeats": [4], "mode": "shift", "scale": "128", "kappa": "1/8"},
    {"id": "fractional-grid-self-links", "kind": "cycles", "length": 512,
     "repeats": [4], "mode": "shift", "scale": "255/2", "kappa": "1/8"},
    {"id": "minimum-bin-absent-from-stage", "kind": "cycles", "length": 512,
     "repeats": [3, 1], "mode": "minimum-bin", "scale": "128", "kappa": "1/8"},
    {"id": "theta-positive-last-stage", "kind": "theta", "length": 512,
     "scale": "128", "kappa": "1/8"},
    {"id": "rooted-interval-sharp-incidence", "kind": "interval", "length": 512,
     "scale": "128", "kappa": "1/8"},
]


def make_fixture(recipe):
    length = recipe["length"]
    edges = []
    paths = []
    comparisons = []
    if recipe["kind"] == "cycles":
        for i, repeat in enumerate(recipe["repeats"]):
            start = len(edges)
            for j in range(length):
                label = 8 if recipe["mode"] == "inverse" and i == 1 else 7
                if recipe["mode"] == "minimum-bin" and i == 1 and j % 128 >= 120:
                    label = [0, V + 1][(j % 128 - 120) % 2]
                edges.append(Edge(i * length + j,
                                  i * length + (j + 1) % length, label))
            paths.append(PathData([(start + j, 1) for j in range(length)] * repeat))
        mode = recipe["mode"]
        if mode in ("parallel", "inverse"):
            comparisons = [Comparison(0, 0, 1, 0, len(paths[0].steps),
                                      inverse=mode == "inverse")]
        elif mode == "shift":
            half = len(paths[0].steps) // 2
            comparisons = [Comparison(0, 0, 0, half + 1, half - 1)]
        elif mode == "minimum-bin":
            comparisons = [Comparison(0, j, 1, j, 120)
                           for j in range(0, length, 128)]
        else:
            raise ValueError(f"unknown comparison mode: {mode}")
    elif recipe["kind"] == "theta":
        half = length // 2
        branches = []
        next_vertex = 2
        for label in (7, 9, 11):
            vertices = [0] + list(range(next_vertex, next_vertex + half - 1)) + [1]
            next_vertex += half - 1
            branch = []
            for u, v in zip(vertices, vertices[1:]):
                branch.append((len(edges), 1))
                edges.append(Edge(u, v, label))
            branches.append(branch)
        rev = lambda steps: [(e, -d) for e, d in reversed(steps)]
        paths = [PathData((branches[0] + rev(branches[1])) * 2),
                 PathData(branches[1] + rev(branches[2]))]
    elif recipe["kind"] == "interval":
        edges = [Edge(j, j + 1, 7) for j in range(length)]
        paths = [PathData([(j, 1) for j in range(length)], closed=False, root=0)]
    else:
        raise ValueError(f"unknown fixture kind: {recipe['kind']}")
    return edges, paths, comparisons


def endpoints(edge, direction):
    assert direction in (-1, 1)
    return (edge.u, edge.v) if direction == 1 else (edge.v, edge.u)


def interval(path, start, length):
    assert 0 <= start < len(path.steps) and 0 <= length <= len(path.steps)
    if not path.closed:
        assert start + length <= len(path.steps), "interval outside path"
    return [(start + i) % len(path.steps) for i in range(length)]


def validate_paths(edges, paths, comparisons):
    adjacency = defaultdict(list)
    outgoing = defaultdict(set)
    for eid, edge in enumerate(edges):
        assert edge.u != edge.v, "loop in fixture"
        for vertex, label in ((edge.u, edge.label), (edge.v, bar(edge.label))):
            assert label not in outgoing[vertex], "nonimmersed graph labelling"
            outgoing[vertex].add(label)
            adjacency[vertex].append(eid)
    used = Counter()
    path_vertices = []
    position_label = {}
    intervals = 0
    endpoint_counts = Counter()
    for pi, path in enumerate(paths):
        assert path.steps, "empty path"
        vertices = []
        for k, (eid, direction) in enumerate(path.steps):
            u, v = endpoints(edges[eid], direction)
            if k:
                assert vertices[-1] == u, "disconnected path"
                assert path.steps[k - 1] != (eid, -direction), "backtracking"
            else:
                vertices.append(u)
            vertices.append(v)
            used[eid] += 1
            position_label[pi, k] = edges[eid].label if direction == 1 \
                else bar(edges[eid].label)
        if path.closed:
            assert vertices[0] == vertices[-1], "unclosed path"
            eid, direction = path.steps[0]
            assert path.steps[-1] != (eid, -direction), "cyclic backtracking"
        else:
            intervals += 1
            assert path.root == vertices[0], "incorrect prescribed root"
            endpoint_counts[vertices[0]] += 1
            endpoint_counts[vertices[-1]] += 1
        path_vertices.append(vertices)
    assert intervals <= 1, "multiple interval paths"
    assert set(used) == set(range(len(edges))), "graph is not the path image"
    paired = set()
    comparison_pairs = []
    for comp in comparisons:
        left = interval(paths[comp.left], comp.start_left, comp.length)
        right = interval(paths[comp.right], comp.start_right, comp.length)
        if comp.inverse:
            right.reverse()
        pairs = []
        for x, y in zip(left, right):
            a, b = (comp.left, x), (comp.right, y)
            assert a != b and a not in paired and b not in paired, \
                "comparison positions are not disjoint"
            paired.update((a, b))
            assert paths[a[0]].steps[a[1]][0] != paths[b[0]].steps[b[1]][0], \
                "comparison pairs the same underlying edge"
            target = bar(position_label[b]) if comp.inverse else position_label[b]
            assert position_label[a] == target, "comparison word constraint fails"
            pairs.append((a, b))
        comparison_pairs.append((comp, pairs))
    return adjacency, used, path_vertices, endpoint_counts, intervals, paired, \
        comparison_pairs


def girth(edges, adjacency):
    best = None
    for source in adjacency:
        distances = {source: 0}
        parent_edge = {source: None}
        todo = deque([source])
        while todo:
            u = todo.popleft()
            for eid in adjacency[u]:
                edge = edges[eid]
                v = edge.v if edge.u == u else edge.u
                if v not in distances:
                    distances[v] = distances[u] + 1
                    parent_edge[v] = eid
                    todo.append(v)
                elif eid != parent_edge[u] and eid != parent_edge[v]:
                    length = distances[u] + distances[v] + 1
                    best = length if best is None else min(best, length)
    return best


def decompose_chains(edges, paths, adjacency, path_vertices):
    marked = {v for v in adjacency if len(adjacency[v]) != 2}
    for vertices in path_vertices:
        marked.update((vertices[0], vertices[-1]))
    unused = set(range(len(edges)))
    chains = []
    edge_coordinates = {}
    for start in sorted(marked):
        for first in sorted(adjacency[start]):
            if first not in unused:
                continue
            cur, eid = start, first
            chain = []
            ci = len(chains)
            while True:
                edge = edges[eid]
                direction = 1 if edge.u == cur else -1
                edge_coordinates[eid] = (ci, len(chain), direction)
                chain.append((eid, direction))
                unused.remove(eid)
                _, cur = endpoints(edge, direction)
                if cur in marked:
                    break
                choices = [e for e in adjacency[cur] if e != eid]
                assert len(choices) == 1
                eid = choices[0]
            chains.append(chain)
    assert not unused, "unmarked circular component"
    info = {}
    traversals = []
    for pi, path in enumerate(paths):
        k = 0
        ti = 0
        while k < len(path.steps):
            eid, direction = path.steps[k]
            ci, coordinate, chain_direction = edge_coordinates[eid]
            relative = direction * chain_direction
            expected = chains[ci] if relative == 1 else \
                [(e, -d) for e, d in reversed(chains[ci])]
            assert coordinate == (0 if relative == 1 else len(chains[ci]) - 1)
            assert path.steps[k:k + len(expected)] == expected
            traversals.append((pi, ti, ci, k, k + len(expected)))
            for pos in range(k, k + len(expected)):
                peid, _ = path.steps[pos]
                _, coord, _ = edge_coordinates[peid]
                info[pi, pos] = (ci, coord, relative, (pi, ti))
            k += len(expected)
            ti += 1
    return chains, traversals, info


def distance_to_integer(x):
    residue = x - math.floor(x)
    return min(residue, 1 - residue)


def analyse_fixture(recipe):
    edges, paths, comparisons = make_fixture(recipe)
    adjacency, used, vertices, endpoint_counts, iota, paired, comp_pairs = \
        validate_paths(edges, paths, comparisons)
    g = girth(edges, adjacency)
    assert g is None or g >= recipe["length"]
    chains, traversals, info = decompose_chains(edges, paths, adjacency, vertices)
    s, kappa = F(recipe["scale"]), F(recipe["kappa"])
    assert s > 4 and 0 < kappa < F(1, 4)
    multiplicities = Counter(ci for _, _, ci, _, _ in traversals)
    for ci, chain in enumerate(chains):
        assert all(used[e] == multiplicities[ci] for e, _ in chain)
    blocks, coordinate_block, words = [], {}, []
    for ci, chain in enumerate(chains):
        for k in range(math.floor(F(len(chain)) / s)):
            coords = [j for j in range(len(chain))
                      if k * s <= F(2 * j + 1, 2) < (k + 1) * s]
            assert s - 1 <= len(coords) <= s + 1
            bid = len(blocks)
            blocks.append((ci, coords))
            for j in coords:
                coordinate_block[ci, j] = bid
            word = tuple(edges[chain[j][0]].label if chain[j][1] == 1
                         else bar(edges[chain[j][0]].label) for j in coords)
            assert word_weight(word) > 0
            words.append(word)
    occurrences = {}
    for pi, ti, ci, start, end in traversals:
        for bid, (bci, _) in enumerate(blocks):
            if bci == ci:
                occurrences[pi, ti, bid] = []
        for pos in range(start, end):
            _, coord, _, _ = info[pi, pos]
            if (ci, coord) in coordinate_block:
                bid = coordinate_block[ci, coord]
                occurrences[pi, ti, bid].append((pi, pos))
    position_occurrence = {pos: occ for occ, positions in occurrences.items()
                           for pos in positions}
    cuts = defaultdict(set)
    for pi, _, _, start, end in traversals:
        cuts[pi].update((start, end))
    segments = []
    for comp, pairs in comp_pairs:
        current = []
        previous_key = None
        for left, right in pairs:
            _, x, dx, tx = info[left]
            _, y, dy, ty = info[right]
            sigma = (-1 if comp.inverse else 1) * dx * dy
            offset = F(2 * y + 1, 2) - sigma * F(2 * x + 1, 2)
            assert offset.denominator == 1
            key = tx, ty, sigma, int(offset)
            if current and key != previous_key:
                segments.append((previous_key, current))
                current = []
            current.append((left, right))
            previous_key = key
        if current:
            segments.append((previous_key, current))
    for _, pairs in segments:
        for side in (0, 1):
            positions = [pair[side][1] for pair in pairs]
            pi = pairs[0][side][0]
            cuts[pi].update((min(positions), max(positions) + 1))
    theta = max((distance_to_integer(F(key[3]) / s) for key, _ in segments),
                default=F(0))
    assert kappa >= 2 * theta + 8 / s, "fixture lacks near-alignment margin"
    mate = {}
    links = []
    translation_forests = 0
    for key, pairs in segments:
        groups = defaultdict(list)
        for left, right in pairs:
            if left in position_occurrence and right in position_occurrence:
                groups[position_occurrence[left], position_occurrence[right]].append(
                    (left, right))
        for (left_occ, right_occ), overlap in groups.items():
            if len(overlap) < (1 - kappa) * s:
                continue
            assert left_occ != right_occ
            assert left_occ not in mate and right_occ not in mate, \
                "overlap construction is not a partial matching"
            mate[left_occ], mate[right_occ] = right_occ, left_occ
            a, b = left_occ[2], right_occ[2]
            links.append((a, b, key[2], key[3], len(overlap)))
            if a == b:
                assert key[2] == 1, "reduced reflection self-link"
                assert key[3] != 0, "zero-step self-link"
                positions = blocks[a][1]
                parent = {j: j for j in positions}

                def find(j):
                    while parent[j] != j:
                        j = parent[j]
                    return j

                for left, right in overlap:
                    x, y = info[left][1], info[right][1]
                    assert y - x == key[3]
                    rx, ry = find(x), find(y)
                    assert rx != ry, "translation equality graph has a cycle"
                    parent[rx] = ry
                free = len({find(j) for j in positions})
                assert free == len(positions) - len(overlap) <= kappa * s + 1
                translation_forests += 1
    unmatched = set(occurrences) - set(mate)
    exceptional = {occ for occ, positions in occurrences.items()
                   if any(min(abs(F(pos) - cut), abs(F(pos + 1) - cut)) <= 3 * s + 4
                          for _, pos in positions for cut in cuts[occ[0]])}
    for occ in unmatched - exceptional:
        assert all(pos not in paired for pos in occurrences[occ]), \
            "nonexceptional unmatched occurrence contains a comparison"
    H = sum(len(path.steps) for path in paths)
    J, M, d = len(chains), max(used.values()), max(1, len(segments))
    Q = 16 * (2 * J * M + 4 * d)
    S, bstar, b0 = len(occurrences), len(unmatched), H - len(paired)
    fragment_positions = H - len(position_occurrence)
    assert len(exceptional) <= Q
    assert fragment_positions <= J * M * (s + 1)
    assert S <= F(H) / (s - 1)
    assert s * S >= H - J * M * (s + 1) - F(H) / (s - 1)
    assert s * bstar <= b0 + F(H) / (s - 1) + s * Q
    for v, incident in adjacency.items():
        assert 2 * max(used[e] for e in incident) <= \
            sum(used[e] for e in incident) + endpoint_counts[v]
    stages = []
    for j in range(1, M + 1):
        active = [e for e in range(len(edges)) if used[e] >= j]
        active_vertices = {v for e in active for v in (edges[e].u, edges[e].v)}
        k = iota if j == 1 else 0
        stages.append({"stage": j, "edges": len(active), "vertices": len(active_vertices),
                       "fixed_roots": k, "n_exponent": len(active_vertices) - len(active) - k})
    assert sum(x["edges"] for x in stages) == H
    assert sum(x["vertices"] for x in stages) <= H + iota
    assert sum(x["n_exponent"] for x in stages) <= 0
    neighbours = {i: set() for i in range(len(blocks))}
    for a, b, _, _, _ in links:
        neighbours[a].add(b)
        neighbours[b].add(a)
    todo = set(neighbours)
    components = []
    bins = [word_bin(word_weight(w)) for w in words]
    for d_i in bins:
        assert TAU * s - C_BIN <= d_i <= A * s
    while todo:
        start = min(todo)
        component = {start}
        stack = [start]
        todo.remove(start)
        while stack:
            for nxt in neighbours[stack.pop()]:
                if nxt not in component:
                    component.add(nxt)
                    todo.remove(nxt)
                    stack.append(nxt)
        self_link = any(a == b and a in component for a, b, _, _, _ in links)
        ms = {i: multiplicities[blocks[i][0]] for i in component}
        cs, z = sum(ms.values()), max(ms.values())
        cb = sum(occ[2] in component for occ in unmatched)
        dmin = min(bins[i] for i in component)
        if not self_link:
            assert 2 * z <= cs + cb
        term = -sum(ms[i] * bins[i] for i in component)
        if not self_link:
            term += z * (2 * dmin - 2 * TAU * s + 2 * C_BIN)
        upper = -TAU * s * cs + (A - TAU) * s * cb + C_BIN * (cs + cb)
        assert term <= upper
        absent = [j for j in range(1, z + 1)
                  if all(ms[i] < j for i in component if bins[i] == dmin)]
        components.append({"blocks": sorted(component), "multiplicities": [ms[i] for i in sorted(component)],
                           "S": cs, "z": z, "unmatched": cb, "self_link": self_link,
                           "bins": [bins[i] for i in sorted(component)],
                           "minimum_bin_absent_stages": absent,
                           "product_bin_contribution": str(term)})
    stage_terms = []
    for j in range(1, M + 1):
        term = -sum(bins[i] for i, (ci, _) in enumerate(blocks)
                    if multiplicities[ci] >= j)
        term += sum(2 * min(comp["bins"]) - 2 * TAU * s + 2 * C_BIN
                    for comp in components if not comp["self_link"] and comp["z"] >= j)
        stage_terms.append(term)
    total_term = sum(stage_terms)
    assert total_term == sum((F(comp["product_bin_contribution"]) for comp in components), F(0))
    assert total_term <= -TAU * s * S + (A - TAU) * s * bstar + 2 * C_BIN * S
    deterministic_error = TAU * J * M * (s + 1) + \
        (A + 2 * C_BIN) * F(H) / (s - 1) + (A - TAU) * s * Q
    assert total_term <= -TAU * H + (A - TAU) * b0 + deterministic_error
    if recipe["kind"] == "theta":
        assert [x["n_exponent"] for x in stages] == [-1, 0, 1]
    if recipe["kind"] == "interval":
        assert sum(x["vertices"] for x in stages) == H + 1
        assert stages[0]["n_exponent"] == 0
    if recipe.get("mode") == "shift":
        assert b0 == 2 and translation_forests > 0
    if recipe.get("mode") == "minimum-bin":
        assert any(comp["minimum_bin_absent_stages"] for comp in components)
    return {
        "recipe": recipe, "edges": len(edges), "girth": g, "H": H,
        "chains": [len(chain) for chain in chains], "J": J, "M": M,
        "affine_subcomparisons": len(segments), "theta": str(theta),
        "full_blocks": len(blocks), "block_lengths": [len(w) for w in words],
        "full_block_occurrences": S, "unmatched_occurrences": bstar,
        "unpaired_positions": b0, "fragment_positions": fragment_positions,
        "translation_self_link_forests": translation_forests,
        "stage_counts": stages, "link_components": components,
        "stage_bin_terms": [str(x) for x in stage_terms],
        "exact_product_bin_term": str(total_term),
        "deterministic_rounding_error_bound": str(deterministic_error),
    }


def rejected_path_examples():
    recipe = RECIPES[2]
    edges, paths, _ = make_fixture(recipe)
    bad = [
        ("same-underlying-edge", [Comparison(0, 0, 0, 512, 512)],
         "same underlying edge"),
        ("overlapping-compared-positions", [Comparison(0, 0, 0, 256, 512)],
         "not disjoint"),
    ]
    passed = []
    for name, comparisons, message in bad:
        try:
            validate_paths(edges, paths, comparisons)
        except AssertionError as error:
            assert message in str(error), f"unexpected rejection: {error}"
            passed.append(name)
        else:
            raise AssertionError(f"inadmissible example accepted: {name}")
    try:
        validate_paths([Edge(0, 1, 7)], [PathData([(0, 1), (0, -1)])], [])
    except AssertionError as error:
        assert "backtracking" in str(error)
        passed.append("nonimmersed-backtracking")
    else:
        raise AssertionError("backtracking path accepted")
    return passed


def projection_and_reflection_regressions():
    alphabet = (0, 1, V, V + 1)
    words = [w for w in itertools.product(alphabet, repeat=6)
             if all(b != bar(a) for a, b in zip(w, w[1:]))]
    grouped = defaultdict(list)
    bins = defaultdict(set)
    for w in words:
        grouped[w[:4]].append(w)
        bins[word_bin(word_weight(w))].add(w)
    pairs_by_bins = defaultdict(set)
    for group in grouped.values():
        for left in group:
            for right in group:
                pairs_by_bins[word_bin(word_weight(left)),
                              word_bin(word_weight(right))].add((left, right))
    absent_cases = 0
    for (a, b), pairs in pairs_by_bins.items():
        stage_projection = {left for left, _ in pairs}
        assert len(stage_projection) <= len(bins[min(a, b)]) * len(alphabet) ** 2
        if b < a:
            absent_cases += 1
    assert absent_cases > 0
    reflection_cases = 0
    for h in range(2, 17):
        for start in range(h):
            for length in range(h // 2 + 1, h - start + 1):
                J = set(range(start, start + length))
                for offset in range(2 * h - 1):
                    reflected = {offset - x for x in J}
                    if not reflected <= set(range(h)):
                        continue
                    overlap = J & reflected
                    assert overlap and overlap == {offset - x for x in overlap}
                    if offset % 2 == 0:
                        assert offset // 2 in overlap
                    else:
                        assert offset // 2 in overlap and offset // 2 + 1 in overlap
                    reflection_cases += 1
    return {"reduced_six_letter_words": len(words),
            "bin_pairs_checked": len(pairs_by_bins),
            "absent_minimum_bin_cases": absent_cases,
            "reflection_center_cases": reflection_cases,
            "scope": "finite regression only; universal proof is in theorem.md"}


def integer_root(n, power):
    low, high = 0, 1 << ((n.bit_length() + power - 1) // power)
    while high - low > 1:
        mid = (low + high) // 2
        if mid ** power <= n:
            low = mid
        else:
            high = mid
    assert low ** power <= n < (low + 1) ** power
    return low


def grid_replay():
    data = [(10 ** 8, [1234567]),
            (10 ** 12, [123456789, 98765432101]),
            (10 ** 16, [10 ** 16 // 3, 10 ** 16 // 7, 10 ** 16 // 11])]
    results = []
    for L, offsets in data:
        d = len(offsets)
        N = integer_root(L, 2 * (d + 1))
        R = math.isqrt(N)
        chosen = None
        for u in range(1, N ** d + 1):
            if all(N * min((u * a) % L, L - (u * a) % L) <= L for a in offsets):
                chosen = u
                break
        assert chosen is not None, "Dirichlet witness absent"
        s = F(L, chosen * R)
        theta = max(distance_to_integer(F(a) / s) for a in offsets)
        assert F(L, N ** d * R) <= s <= F(L, R)
        assert theta <= F(R, N)
        kappa = 2 * F(R, N) + 8 / s
        assert s > 4 and kappa < F(1, 4)
        results.append({"L": L, "offsets": offsets, "d": d, "N": N, "R": R,
                        "u": chosen, "s": str(s), "theta": str(theta),
                        "kappa": str(kappa)})
    return results


def formal_replay():
    result = json.loads((HERE / "lean_run.json").read_text())
    assert result["status"] == "success" and result["exit_code"] == 0
    assert result["proof_holes"] == []
    archive_path = result["kernel"]["recorded"]["artifact"]
    archive = json.loads((ROOT / archive_path).read_text())
    check = archive["lean_check"]
    assert check["status"] == "success" and check["exit_code"] == 0
    assert check["proof_holes"] == []
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    assert hashlib.sha256(source).hexdigest() == check["source_sha256"]
    assert hashlib.sha256(fidelity.encode()).hexdigest() == \
        check["statement_fidelity_sha256"]
    assert archive["lean_source"]["text"] == source.decode()
    assert archive["statement_fidelity"]["text"] == fidelity
    assert "4.31.0" in archive["produced_by"]
    return {"claim": "C_BP_MATCH", "certificate": archive_path,
            "compiler": archive["produced_by"], "exit_code": 0, "proof_holes": [],
            "scope": "universal finite cores, not the entire analytic theorem"}


def source_binding():
    base = ROOT / "research/openai_manuscript" / \
        "A-Torsion-Free-Group-Algebra-That-Is-Not-Directly-Finite-October-4-2026" / \
        "build/sections"
    required = {
        "patterns.tex": [r"\label{thm:bounded-patterns}",
                         r"\label{eq:fixed-stage-expectation}",
                         r"\label{eq:stage-label-count}",
                         r"\label{eq:stage-product}",
                         r"\label{eq:distinct-comparison-edges}",
                         r"\varepsilon:=\min\left\{\frac14,"],
        "random.tex": [r"\label{eq:turn-count}", r"\label{lem:prescriptions}",
                       r"\label{lem:word-decay}", r"q=128"],
    }
    for name, snippets in required.items():
        text = (base / name).read_text()
        for snippet in snippets:
            assert snippet in text, f"source assertion missing: {name}: {snippet}"
    return {name: snippets for name, snippets in required.items()}


def compute():
    return {
        "result_class": "general_verification_theorem",
        "universal_proof": "research/bounded-path-core/theorem.md",
        "scope": "Conditional on explicit upstream stochastic inputs; not a manuscript refutation.",
        "independent_review": "pending Host-invoked Reviewer",
        "novelty": "not independently established",
        "source_binding": source_binding(),
        "exact_word_constants": exact_word_evidence(),
        "actual_path_regressions": [analyse_fixture(recipe) for recipe in RECIPES],
        "rejected_inadmissible_paths": rejected_path_examples(),
        "projection_and_reflection_regressions": projection_and_reflection_regressions(),
        "source_grid_witnesses": grid_replay(),
        "formal_core": formal_replay(),
    }


def main():
    if not __debug__:
        raise RuntimeError("Run this verifier without -O: assertions are evidence checks.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true",
                        help="write the deterministically recomputed certificate")
    args = parser.parse_args()
    computed = compute()
    certificate = HERE / "exact_certificate.json"
    if args.write:
        certificate.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(certificate.read_text())
        assert recorded == computed, "certificate differs from exact replay"
    print(json.dumps({"ok": True, "actual_path_fixtures": len(RECIPES),
                      "epsilon": computed["exact_word_constants"]["epsilon"],
                      "lean_exit_code": computed["formal_core"]["exit_code"],
                      "proof_holes": computed["formal_core"]["proof_holes"],
                      "independent_review": computed["independent_review"]},
                     sort_keys=True))


if __name__ == "__main__":
    main()
