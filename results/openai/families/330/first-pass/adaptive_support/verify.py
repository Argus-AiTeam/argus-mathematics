#!/usr/bin/env python3
"""Replay exact diagnostics; the universal transfer is proved in Main.lean."""

import argparse
import hashlib
import json
from collections import Counter, deque
from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations, permutations, product
from math import factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
OPERATION = "probability.finite_distribution.raw_moment.compute"


@dataclass(frozen=True)
class Graph:
    size: int
    edges: tuple
    adjacency: tuple


def graph(size, edges):
    adjacency = [[] for _ in range(size)]
    for edge, (left, right) in enumerate(edges):
        adjacency[left].append((2 * edge, right))
        adjacency[right].append((2 * edge + 1, left))
    return Graph(size, tuple(edges), tuple(tuple(row) for row in adjacency))


def permutation_graph(sigmas):
    size = len(sigmas[0])
    assert all(sorted(sigma) == list(range(size)) for sigma in sigmas)
    result = graph(size, [(v, sigma[v]) for sigma in sigmas for v in range(size)])
    assert all(len(row) == 2 * len(sigmas) for row in result.adjacency)
    for vertex, row in enumerate(result.adjacency):
        for dart, target in row:
            assert (dart ^ 1, vertex) in result.adjacency[target]
    return result


def ball_vertices(g, root, radius):
    distances = {root: 0}
    queue = deque([root])
    while queue:
        vertex = queue.popleft()
        if distances[vertex] == radius:
            continue
        for _, target in g.adjacency[vertex]:
            if target not in distances:
                distances[target] = distances[vertex] + 1
                queue.append(target)
    return distances


def rooted_type(g, colors, root, radius):
    vertices = set(ball_vertices(g, root, radius))
    edges = [(v, w) for v, w in g.edges if v in vertices and w in vertices]
    if len(edges) == len(vertices) - 1:
        def branch(vertex, parent):
            return (colors[vertex], tuple(sorted(
                branch(target, vertex) for _, target in g.adjacency[vertex]
                if target in vertices and target != parent
            )))
        return ("tree", branch(root, None))
    others = sorted(vertices - {root})
    encodings = []
    for ordering in permutations(others):
        order = (root,) + ordering
        index = {v: i for i, v in enumerate(order)}
        counts = Counter(tuple(sorted((index[v], index[w]))) for v, w in edges)
        encodings.append((
            tuple(colors[v] for v in order),
            tuple(counts[i, j] for i in range(len(order)) for j in range(i, len(order))),
        ))
    return ("multigraph", min(encodings))


def regular_tree_ball(degree, radius):
    edges = []
    frontier = [(0, None)]
    size = 1
    for _ in range(radius):
        following = []
        for vertex, parent in frontier:
            for _ in range(degree if parent is None else degree - 1):
                edges.append((vertex, size))
                following.append((size, vertex))
                size += 1
        frontier = following
    return graph(size, edges)


def vertex_walks(g, root, length):
    walks = [(root, None, (root,))]
    for _ in range(length):
        walks = [
            (target, dart, vertices + (target,))
            for vertex, previous, vertices in walks
            for dart, target in g.adjacency[vertex]
            if previous is None or dart != (previous ^ 1)
        ]
    return [vertices for _, _, vertices in walks]


def event_roots(g, colors, successors, allowed, length, compatible=None):
    def permits(vertex, state):
        return colors[vertex] in allowed[state] and (
            compatible is None or (vertex, state) in compatible
        )

    roots = set()
    for root in range(g.size):
        active = {(root, None, state) for state in range(len(allowed)) if permits(root, state)}
        for _ in range(length):
            active = {
                (target, dart, following)
                for vertex, previous, state in active
                for dart, target in g.adjacency[vertex]
                if previous is None or dart != (previous ^ 1)
                for following in successors[state]
                if permits(target, following)
            }
        if active:
            roots.add(root)
    return roots


def state_data(colors=2):
    subsets = [frozenset(c for c in range(colors) if mask & (1 << c))
               for mask in range(1 << colors)]
    for size in range(3):
        for relation in range(1 << (size * size)):
            successors = tuple(
                tuple(j for j in range(size) if relation & (1 << (i * size + j)))
                for i in range(size)
            )
            for allowed in product(subsets, repeat=size):
                yield successors, allowed


def check_conditional_completions():
    cases = queries = 0
    for size in range(1, 5):
        full = list(permutations(range(size)))
        for exposed in range(size + 1):
            for domains in combinations(range(size), exposed):
                for images in permutations(range(size), exposed):
                    partial = dict(zip(domains, images))
                    completions = [p for p in full if all(p[v] == w for v, w in partial.items())]
                    assert len(completions) == factorial(size - exposed)
                    cases += 1
                    unused_domains = set(range(size)) - set(domains)
                    unused_images = set(range(size)) - set(images)
                    for vertex in unused_domains:
                        counts = Counter(p[vertex] for p in completions)
                        assert set(counts) == unused_images
                        assert set(counts.values()) == {factorial(size - exposed - 1)}
                        queries += 1
                    for image in unused_images:
                        counts = Counter(p.index(image) for p in completions)
                        assert set(counts) == unused_domains
                        assert set(counts.values()) == {factorial(size - exposed - 1)}
                        queries += 1
    return {"partial_bijections": cases, "fresh_image_or_inverse_queries": queries}


def explore(sigmas, roots, radius):
    size = len(sigmas[0])
    inverses = [tuple(sigma.index(v) for v in range(size)) for sigma in sigmas]
    exposed = [dict() for _ in sigmas]
    ranges = [dict() for _ in sigmas]
    discovered = {root: 0 for root in roots}
    queue = deque(roots)
    collision = False
    queries = fresh_queries = 0
    while queue:
        vertex = queue.popleft()
        if discovered[vertex] > radius:
            continue
        for a in range(len(sigmas)):
            for reverse in (False, True):
                queries += 1
                if not reverse and vertex in exposed[a]:
                    continue
                if reverse and vertex in ranges[a]:
                    continue
                fresh_queries += 1
                target = inverses[a][vertex] if reverse else sigmas[a][vertex]
                domain, image = (target, vertex) if reverse else (vertex, target)
                assert domain not in exposed[a] and image not in ranges[a]
                exposed[a][domain] = image
                ranges[a][image] = domain
                if target in discovered:
                    collision = True
                else:
                    discovered[target] = discovered[vertex] + 1
                    queue.append(target)
    return collision, queries, fresh_queries, len(discovered)


def check_explorations():
    cases = clean = 0
    for count, max_size in ((1, 5), (2, 3)):
        degree = 2 * count
        for size in range(1, max_size + 1):
            for sigmas in product(list(permutations(range(size))), repeat=count):
                g = permutation_graph(sigmas)
                root_sets = [(v,) for v in range(size)] + list(combinations(range(size), 2))
                for radius in (0, 1):
                    U = sum(degree ** i for i in range(radius + 1))
                    c = 2 * (1 + degree * U)
                    for roots in root_sets:
                        collision, queries, fresh, discovered = explore(sigmas, roots, radius)
                        assert fresh <= queries <= len(roots) * degree * U <= c
                        assert discovered <= len(roots) + fresh <= c
                        cases += 1
                        if not collision:
                            clean += 1
                            balls = [set(ball_vertices(g, root, radius)) for root in roots]
                            assert all(not (balls[i] & balls[j])
                                       for i in range(len(balls)) for j in range(i))
                            expected = 1 + degree * sum((degree - 1) ** i for i in range(radius))
                            for root, vertices in zip(roots, balls):
                                assert len(vertices) == expected
                                assert sum(v in vertices and w in vertices for v, w in g.edges) == expected - 1
                                assert rooted_type(g, (0,) * size, root, radius)[0] == "tree"
    triangle = permutation_graph(((1, 2, 0),))
    assert rooted_type(triangle, (0, 0, 0), 0, 1)[0] == "multigraph"
    assert explore(((1, 2, 0),), (0,), 1)[0]
    loop = permutation_graph(((0,),))
    parallel = permutation_graph(((1, 0),))
    assert any(w == (0, 0, 0, 0) for w in vertex_walks(loop, 0, 3))
    assert any(w == (0, 1, 0, 1) for w in vertex_walks(parallel, 0, 3))
    return {"one_or_two_root_explorations": cases, "collision_free_explorations": clean,
            "induced_boundary_triangle_detected": True,
            "repeated_loop_and_parallel_return_preserved": True}


def check_jacobian():
    permutations3 = list(permutations(range(3)))
    counts = Counter(Fraction(sum(any(p[v] == v for p in sigmas) for v in range(3)), 3)
                     for sigmas in product(permutations3, repeat=2))
    distribution = {value: Fraction(count, 36) for value, count in counts.items()}
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    rational = lambda x: Fraction(int(x["num"]), int(x["den"]))
    actual = {rational(atom["value"]): rational(atom["probability"]) for atom in payload["atoms"]}
    assert actual == distribution and sum(actual.values()) == 1
    assert payload["order"] == 2
    assert output["request"] == {"operation_id": OPERATION, "payload": payload}
    assert output["result"]["operation_id"] == OPERATION
    typed = output["result"]["output"]
    assert typed["order"] == 2
    moment = sum(value ** 2 * probability for value, probability in distribution.items())
    assert moment == Fraction(23, 54) == rational(typed["moment"])
    assert len(typed["contributions"]) == len(actual)
    for atom in typed["contributions"]:
        value, probability = rational(atom["value"]), rational(atom["probability"])
        assert actual[value] == probability
        assert rational(atom["powered_value"]) == value ** 2
        assert rational(atom["contribution"]) == probability * value ** 2
    assert output["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == "2025-11-25"
    assert status["operation_id"] == OPERATION
    assert status["server_version"] == output["server"]["version"]
    assert status["protocol_version"] == output["protocol_version"]
    assert status["adapter_exit_code"] == 0
    assert status["structured_error"] is None and status["timeout"] is False
    return {"operation_id": OPERATION, "permutation_tuples": 36,
            "loop_frequency_second_moment": "23/54", "adapter_exit_code": 0,
            "structured_error": None, "timeout": False}


def source_corpus(degree):
    count = degree // 2
    max_size = 4 if degree == 2 else 3
    for size in range(1, max_size + 1):
        for sigmas in product(list(permutations(range(size))), repeat=count):
            g = permutation_graph(sigmas)
            for colors in product(range(2), repeat=size):
                yield g, colors
    if degree == 2:
        g = permutation_graph((tuple((v + 1) % 8 for v in range(8)),))
    else:
        right = tuple(5 * (v // 5) + (v + 1) % 5 for v in range(25))
        up = tuple((v + 5) % 25 for v in range(25))
        g = permutation_graph((right, up))
    for colors in (
        (0,) * g.size,
        tuple(v % 2 for v in range(g.size)),
        tuple(int(v == 0) for v in range(g.size)),
        tuple(int((v * v + 3 * v + 1) % 7 < 3) for v in range(g.size)),
    ):
        yield g, colors


def check_transfer():
    data = list(state_data())
    assert len(data) == 265
    tree_checks = transfer_checks = domination_checks = type_checks = path_checks = 0
    nontrivial_discrepancies = zero_factor_cases = 0
    for degree, lengths in ((2, range(4)), (4, (0, 1))):
        corpus = list(source_corpus(degree))
        for length in lengths:
            tree = regular_tree_ball(degree, length)
            walks = vertex_walks(tree, 0, length)
            assert len(walks) <= degree ** length
            assert all(len(set(walk)) == length + 1 for walk in walks)
            path_checks += len(walks)
            colorings = list(product(range(2), repeat=tree.size))
            tree_types = [rooted_type(tree, color, 0, length) for color in colorings]
            tree_counts = Counter(tree_types)
            tree_law = {kind: Fraction(count, len(colorings)) for kind, count in tree_counts.items()}
            prepared = []
            for g, colors in corpus:
                types = [rooted_type(g, colors, v, length) for v in range(g.size)]
                counts = Counter(types)
                empirical = {kind: Fraction(count, g.size) for kind, count in counts.items()}
                discrepancy = sum(abs(empirical.get(kind, 0) - tree_law.get(kind, 0))
                                  for kind in set(empirical) | set(tree_law)) / 2
                assert 0 <= discrepancy <= 1
                nontrivial_discrepancies += 0 < discrepancy < 1
                prepared.append((g, colors, types, discrepancy))
            for successors, allowed in data:
                size = len(allowed)
                Q = max((len(row) for row in successors), default=0)
                H = max((len(row) for row in allowed), default=0)
                state_words = [word for word in product(range(size), repeat=length + 1)
                               if all(word[i + 1] in successors[word[i]] for i in range(length))]
                assert len(state_words) <= size * Q ** length
                bound = size * Fraction(H, 2) * Fraction(degree * Q * H, 2) ** length
                tree_membership = {}
                successes = 0
                for colors, kind in zip(colorings, tree_types):
                    occurs = 0 in event_roots(tree, colors, successors, allowed, length)
                    if kind in tree_membership:
                        assert tree_membership[kind] == occurs
                    tree_membership[kind] = occurs
                    successes += occurs
                tree_probability = Fraction(successes, len(colorings))
                assert tree_probability <= bound
                tree_checks += 1
                if size == 0 or H == 0 or (Q == 0 and length > 0):
                    assert tree_probability == 0
                    zero_factor_cases += 1
                for g, colors, types, discrepancy in prepared:
                    bad = event_roots(g, colors, successors, allowed, length)
                    type_membership = dict(tree_membership)
                    for vertex, kind in enumerate(types):
                        occurs = vertex in bad
                        if kind in type_membership:
                            assert type_membership[kind] == occurs
                        type_membership[kind] = occurs
                        type_checks += 1
                    beta = Fraction(len(bad), g.size)
                    assert beta <= discrepancy + tree_probability <= discrepancy + bound
                    transfer_checks += 1
                    compatible = {(v, j) for v in range(g.size) for j in range(size)
                                  if (v + 2 * j + len(g.edges)) % 3 != 0}
                    strict = event_roots(g, colors, successors, allowed, length, compatible)
                    assert strict <= bad
                    assert Fraction(len(strict), g.size) <= discrepancy + bound
                    domination_checks += 1
    return {
        "state_systems_per_case": len(data),
        "exact_tree_probability_bounds": tree_checks,
        "finite_discrepancy_inequalities": transfer_checks,
        "adaptive_compatibility_dominations": domination_checks,
        "colored_type_invariance_comparisons": type_checks,
        "injective_tree_walks": path_checks,
        "source_laws_with_discrepancy_strictly_between_zero_and_one": nontrivial_discrepancies,
        "empty_or_zero_factor_tree_cases": zero_factor_cases,
        "universal_proof": "Main.lean, not these finite diagnostics",
    }


def check_selection():
    thresholds = []
    for degree, colors, maximum_m in ((2, 1, 2), (4, 2, 2)):
        previous = 0
        for m in range(1, maximum_m + 1):
            type_bounds = []
            for radius in range(m + 1):
                U = sum(degree ** i for i in range(radius + 1))
                type_bounds.append(sum(b * colors ** b * (b * degree + 1) ** (b * degree)
                                       for b in range(1, U + 1)))
            A = sum(type_bounds)
            U = sum(degree ** i for i in range(m + 1))
            c = 2 * (1 + degree * U)
            N = max(previous + 1, 2 * c + 1, 2 * A ** 3 * (m + 1) ** 2 * (1 + 6 * c ** 2) + 1)
            a = Fraction(1, (m + 1) * A)
            assert N > previous and N > 2 * c
            assert A * (Fraction(1, N) + 3 * Fraction(c * c, N - c)) / a ** 2 < Fraction(1, 2)
            for radius, count in enumerate(type_bounds):
                assert count * a / 2 <= Fraction(1, 2 * (m + 1))
                cr = 2 * (1 + degree * sum(degree ** i for i in range(radius + 1)))
                assert Fraction(cr * cr, N - cr) <= Fraction(2 * c * c, N)
            thresholds.append({"degree": degree, "colors": colors, "stage": m,
                               "vertex_count_bit_length": N.bit_length(),
                               "exact_positive_probability_lower_bound": ">1/2"})
            previous = N
    selected = []
    for size, degree, Q, H, k, V in (
        (0, 4, 0, 0, 1, 1),
        (1, 4, 1, 0, 1, 1),
        (3, 4, 0, 1, 1, 2),
        (2, 4, 3, 2, 49, 5),
        (1000, 4, 3, 2, 49, 100),
        (17, 6, 2, 3, 73, 7),
    ):
        assert k > 2 * degree * Q * H
        delta = Fraction(1, 20 * V)
        rho = Fraction(degree * Q * H, k)
        n = 2
        while size * Fraction(H, k) * rho ** n >= delta / 2:
            n += 1
        m = max(n, int(1 / delta) + 1)
        error = Fraction(1, 2 * (m + 1))
        assert error + size * Fraction(H, k) * rho ** n < delta
        selected.append({"states": size, "degree": degree, "Q": Q, "H": H,
                         "colors": k, "V": V, "n": n, "m": m})
    return {"deterministic_threshold_checks": thresholds, "successive_selection_examples": selected}


def check_lean_record():
    check = json.loads((HERE / "lean_check.json").read_text())
    assert check["exit_code"] == check["audit_exit_code"] == 0
    assert check["proof_holes"] == []
    for filename, key in (("Main.lean", "source_sha256"),
                          ("statement_fidelity.md", "statement_fidelity_sha256")):
        assert hashlib.sha256((HERE / filename).read_bytes()).hexdigest() == check[key]
    assert check["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    assert "sorryAx" not in check["stdout"]
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = next(c for c in reversed(ledger["claims"]) if c["claim_id"] == "C_ADAPTIVE_TRANSFER")
    assert current["formal_statement"] == (HERE / "Main.lean").read_text()
    matching = [e for e in ledger["evidence"]
                if e["subject"]["subject_id"] == "C_ADAPTIVE_TRANSFER"
                and e["subject"]["content_hash"] == current["content_hash"]
                and e["tier"] == "mechanical" and e["verdict"] == "supports"]
    assert matching
    return {"compiler": "Lean 4.31.0", "exit_code": 0, "audit_exit_code": 0,
            "proof_holes": [],             "claim": "C_ADAPTIVE_TRANSFER",
            "certificate": matching[-1]["artifact"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--experiments-only", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    diagnostics = {
        "conditional_uniformity": check_conditional_completions(),
        "permutation_exploration": check_explorations(),
        "jacobian": check_jacobian(),
        "finite_transfer": check_transfer(),
        "selection": check_selection(),
    }
    if args.experiments_only:
        print(json.dumps({"ok": True, "diagnostics": diagnostics}, indent=2))
        return
    formal = check_lean_record()
    certificate = {
        "claim": "C_ADAPTIVE_TRANSFER",
        "result_class": "formal_verification",
        "statement": "Universal finite-discrepancy transfer and subsequent length/index selection.",
        "bound": "beta_m(S,n) <= TV(mu_m,n,q_n) + |S|*(H/k)*(d*Q*H/k)^n",
        "quantifiers": "One deterministic sequence first; every finite state system next; n>=2 next; then all sufficiently large m.",
        "local_limit_proof": "report.md, Sections 1-2: complete permutation-exploration and deterministic-selection proof; not formalized in Lean.",
        "local_limit_assumptions": [],
        "diagnostics": diagnostics,
        "formal_verification": formal,
        "independent_review": "Required through the Host Reviewer path; not asserted by this script.",
        "limitations": [
            "Finite diagnostics do not prove an asymptotic or universal statement.",
            "The complete deterministic local-limit proof and the graph/type instantiation require mathematical review.",
            "Block geometry, operator estimates, and the full manuscript theorem are outside this certificate.",
            "Publishable novelty is not established by this component certificate.",
        ],
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        assert json.loads(path.read_text()) == certificate
    print(json.dumps({"ok": True, "certificate": str(path.relative_to(ROOT)),
                      "finite_discrepancy_inequalities": diagnostics["finite_transfer"]["finite_discrepancy_inequalities"],
                      "lean_exit_code": formal["exit_code"], "proof_holes": formal["proof_holes"]}))


if __name__ == "__main__":
    main()
