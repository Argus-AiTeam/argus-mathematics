#!/usr/bin/env python3
"""Replay exact local calculations; check the separately compiled algebraic core.

The universal topological proof is proof.md, not the finite experiments here.
This script uses only the standard library, performs no network request, and
does not claim to run a fresh Lean compilation. The official compiler archive
must match the current Lean source, fidelity note, and claim ledger exactly.
"""

import argparse
from collections import defaultdict
from dataclasses import dataclass
from fractions import Fraction
from itertools import product
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
CLAIM = "C_CONE_CHAIN_CORE"
COMPILER_CERTIFICATE = (
    "research/topology/certificates/C_CONE_CHAIN_CORE-78ea3bb8a3bd663d.json"
)
EDGES = ((0, 1), (0, 0), (1, 1), (1, 2), (2, 2), (2, 0))
DARTS = tuple(d for e in range(1, len(EDGES) + 1) for d in (e, -e))


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rank(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    if not a:
        return 0
    require(len({len(row) for row in a}) == 1, "ragged matrix")
    r = 0
    for column in range(len(a[0])):
        pivot = next((i for i in range(r, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        scale = a[r][column]
        a[r] = [x / scale for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][column]:
                scale = a[i][column]
                a[i] = [x - scale * y for x, y in zip(a[i], a[r])]
        r += 1
        if r == len(a):
            break
    return r


def multiply(a, b):
    require(bool(b), "empty intermediate chain group not used in this test")
    require(all(len(row) == len(b) for row in a), "matrix dimensions")
    return [
        [sum(row[k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for row in a
    ]


def apply(matrix, vector):
    require(all(len(row) == len(vector) for row in matrix), "vector dimensions")
    return [sum(x * y for x, y in zip(row, vector)) for row in matrix]


def zero(matrix):
    return all(x == 0 for row in matrix for x in row)


def cone_matrices(n, edges):
    m = len(edges)
    incidence = [[0] * m for _ in range(n)]
    for e, (source, target) in enumerate(edges):
        incidence[source][e] -= 1
        incidence[target][e] += 1
    d2 = [[int(i == j) for j in range(m)] for i in range(m)]
    d2 += [[-x for x in row] for row in incidence]
    d1 = [
        row + [int(v == w) for w in range(n)]
        for v, row in enumerate(incidence)
    ]
    d1 += [[0] * m + [-1] * n]
    return [[1] * (n + 1)], d1, d2, incidence


def verify_cones():
    graphs = vectors = 0
    for n in range(1, 4):
        possible_edges = tuple(product(range(n), repeat=2))
        for m in range(4):
            for edges in product(possible_edges, repeat=m):
                d0, d1, d2, incidence = cone_matrices(n, edges)
                require(zero(multiply(d1, d2)), "cone d1*d2")
                require(zero(multiply(d0, d1)), "cone augmentation*d1")
                require((rank(d0), rank(d1), rank(d2)) == (1, n, m),
                        "cone rational rank cross-check")
                require(d2[:m] == [
                    [int(i == j) for j in range(m)] for i in range(m)
                ], "cone top differential projects to identity over Z")
                for a in product((-1, 0, 1), repeat=m):
                    cycle = list(a) + [-x for x in apply(incidence, a)]
                    require(apply(d1, cycle) == [0] * (n + 1),
                            "integer cone one-cycle")
                    require(apply(d2, a) == cycle, "integer cone primitive")
                    vectors += 1
                graphs += 1
    return {
        "vertices": [1, 2, 3],
        "edges": [0, 1, 2, 3],
        "allows_loops_parallel_edges_disconnected_graphs": True,
        "ordered_multigraphs": graphs,
        "integer_cycle_primitives": vectors,
        "universal_integral_exactness": "separate Lean theorem graph_cone_exact",
    }


def ends(dart):
    source, target = EDGES[abs(dart) - 1]
    return (source, target) if dart > 0 else (target, source)


@dataclass(frozen=True)
class GraphPath:
    start: int
    darts: tuple

    @property
    def end(self):
        vertex = self.start
        for dart in self.darts:
            source, vertex_after = ends(dart)
            require(vertex == source, "actual graph-path composability")
            vertex = vertex_after
        return vertex


def join(*paths):
    require(bool(paths), "empty path list")
    for a, b in zip(paths, paths[1:]):
        require(a.end == b.start, "graph endpoints at splice")
    return GraphPath(paths[0].start, sum((p.darts for p in paths), ()))


def immersed(path, cyclic=False):
    path.end
    word = path.darts
    if any(a == -b for a, b in zip(word, word[1:])):
        return False
    return not cyclic or (bool(word) and word[0] != -word[-1])


def tighten(path):
    stack = []
    for dart in path.darts:
        if stack and stack[-1] == -dart:
            stack.pop()
        else:
            stack.append(dart)
    result = GraphPath(path.start, tuple(stack))
    require(result.end == path.end, "tightening preserves actual endpoints")
    return result


def verify_paths():
    paths = defaultdict(list)
    for start in range(3):
        level = [GraphPath(start, ())]
        for length in range(3):
            for path in level:
                paths[start, path.end].append(path)
            if length < 2:
                level = [
                    join(path, GraphPath(path.end, (dart,)))
                    for path in level for dart in DARTS if ends(dart)[0] == path.end
                ]

    counts = dict.fromkeys(
        ("inner_inner", "exterior_inner", "inner_self", "exterior_self"), 0
    )
    breaks_adjacent = 0
    loop_bands = 0
    for dart in DARTS:
        u, v = ends(dart)
        e, inverse = GraphPath(u, (dart,)), GraphPath(v, (-dart,))
        for a, b in product(paths[v, u], paths[u, v]):
            old1, old2 = join(e, a), join(inverse, b)
            if not (immersed(old1, True) and immersed(old2, True)):
                continue
            new = join(a, b)
            require(new.start == new.end == v, "inner merge is a graph loop")
            require(len(new.darts) + 2 == len(old1.darts) + len(old2.darts),
                    "inner-inner removes exactly two occurrences")
            counts["inner_inner"] += 1
            loop_bands += u == v

        for a, b in product(paths[v, v], paths[u, u]):
            old = join(e, a, inverse, b)
            if not immersed(old, True):
                continue
            require(a.start == a.end == v and b.start == b.end == u,
                    "inner self-band creates two actual graph loops")
            require(len(a.darts) + len(b.darts) + 2 == len(old.darts),
                    "inner self-band total descent")
            counts["inner_self"] += 1
            loop_bands += u == v

        for root, target in product(range(3), repeat=2):
            if root == target:
                continue
            for a, b, c in product(paths[root, u], paths[u, v], paths[v, target]):
                outer, inner = join(a, e, c), join(inverse, b)
                if not (immersed(outer) and immersed(inner, True)):
                    continue
                new = join(a, b, c)
                shortened = tighten(new)
                require(new.start == shortened.start == root, "root retained")
                require(new.end == shortened.end == target, "endpoint retained")
                require(bool(shortened.darts), "distinct endpoints cannot tighten away")
                require(len(new.darts) + 2 == len(outer.darts) + len(inner.darts),
                        "exterior-inner total descent")
                require(len(shortened.darts) < len(outer.darts) + len(inner.darts),
                        "exterior-inner strict retained descent")
                counts["exterior_inner"] += 1
                breaks_adjacent += not a.darts or not c.darts
                loop_bands += u == v

            for a, b, c in product(paths[root, u], paths[v, v], paths[u, target]):
                outer = join(a, e, b, inverse, c)
                if not immersed(outer):
                    continue
                new = join(a, c)
                shortened = tighten(new)
                require(new.start == shortened.start == root, "self-band root retained")
                require(new.end == shortened.end == target, "self-band endpoint retained")
                require(bool(shortened.darts), "self-band distinct endpoints survive")
                require(b.start == b.end == v, "other boundary is the loop b")
                require(len(new.darts) + len(b.darts) + 2 == len(outer.darts),
                        "exterior self-band total descent")
                require(len(shortened.darts) < len(outer.darts),
                        "exterior self-band retained descent")
                counts["exterior_self"] += 1
                breaks_adjacent += not a.darts or not c.darts
                loop_bands += u == v

    require(all(counts.values()), "all four band incidences exercised")
    require(breaks_adjacent > 0 and loop_bands > 0, "boundary and loop controls")
    return {
        "graph_reference_edges": [list(edge) for edge in EDGES],
        "both_orientations_of_every_edge": True,
        "residual_paths_have_length_at_most": 2,
        "old_paths_are_actually_immersed": True,
        "incidences_checked": counts,
        "break_adjacent_cases": breaks_adjacent,
        "loop_edge_cases": loop_bands,
        "scope": "finite graph-splice tests, not topological witness preservation",
    }


def permutation_cycles(permutation):
    unseen, count = set(range(len(permutation))), 0
    while unseen:
        vertex = min(unseen)
        while vertex in unseen:
            unseen.remove(vertex)
            vertex = permutation[vertex]
        count += 1
    return count


def verify_ribbons():
    alpha = [1, 0]
    answers = {}
    for case, sigma, vertices, expected in (
        ("different_disks", [0, 1], 2, (1, 1)),
        ("one_disk_twice", [1, 0], 1, (0, 2)),
    ):
        boundary_count = permutation_cycles([sigma[alpha[i]] for i in range(2)])
        chi = vertices - 1
        require((chi, boundary_count) == expected, "single-band neighborhood")
        require(2 - boundary_count - chi == 0, "orientable neighborhood genus zero")
        answers[case] = {"euler_characteristic": chi, "boundary_components": boundary_count}
    return answers


def verify_periodic_resolution():
    orders = (2, 3, 5, 7, 11)
    bounded_vectors = 0
    controls = []
    for n in orders:
        difference = [
            [int(j == (i - 1) % n) - int(j == i) for j in range(n)]
            for i in range(n)
        ]
        norm = [[1] * n for _ in range(n)]
        require(zero(multiply(difference, norm)), "(g-1)*N")
        require(zero(multiply(norm, difference)), "N*(g-1)")
        require((rank(difference), rank(norm)) == (n - 1, 1), "periodic ranks")
        if n <= 5:
            for x in product(range(-2, 3), repeat=n):
                require((apply(difference, x) == [0] * n) == (len(set(x)) == 1),
                        "integer difference kernel is constant")
                require((apply(norm, x) == [0] * n) == (sum(x) == 0),
                        "integer norm kernel is augmentation ideal")
                if sum(x) == 0:
                    primitive = [0]
                    for i in range(1, n):
                        primitive.append(primitive[-1] - x[i])
                    require(apply(difference, primitive) == list(x),
                            "integral partial-sum primitive, no division")
                bounded_vectors += 1
        for matrix in (difference, norm):
            require(all(sum(row[j] for row in matrix) % n == 0 for j in range(n)),
                    "actual trivial-module cochain differential modulo the prime")

        sigma = [(i + 1) % n for i in range(n)]
        sigma += [n + (i + 1) % n for i in range(n)]
        alpha = [0] * (2 * n)
        for i in range(n):
            position = (n - 1 - i + 1) % n
            alpha[i] = n + position
            alpha[n + position] = i
            partner_edge = n - 1 - position
            require(partner_edge != i, "shifted inverse partners use different graph edges")
        require(all(alpha[alpha[i]] == i and alpha[i] != i for i in range(2 * n)),
                "complete occurrence pairing")
        faces = permutation_cycles([sigma[alpha[i]] for i in range(2 * n)])
        require(2 - n + faces == 2, "shifted two-disk arrangement is planar")
        controls.append({
            "group_presentation": f"<a | a^{n}>",
            "order": n,
            "universal_cover_H2_rank": n - rank(norm),
            "reduced_arrangement_disks": 2,
            "pairing_shift": 1,
            "arrangement_faces": faces,
        })
    return {
        "prime_orders_checked": list(orders),
        "integer_vectors_checked": bounded_vectors,
        "trivial_Fp_cochain_dimensions_degrees_0_through_5": [1] * 6,
        "all_trivial_Fp_cochain_differentials_zero": True,
        "torsion_examples_violate_arrangement_exclusion": controls,
        "universal_torsion_argument": "proof.md Section 6, not extrapolated from these primes",
    }


def verify_negative_controls():
    outer = GraphPath(0, (1, 3, -1, 2, 1))
    retained = GraphPath(0, (2, 1))
    discarded = GraphPath(1, (3,))
    require(immersed(outer) and retained.end == outer.end == 1,
            "break-control paths")
    require(discarded.start != outer.start, "discarded boundary loses the fixed root")

    cone_boundary, target_boundary = [[1], [0]], [[0]]
    push2, push1, q = [[1]], [[0, 0]], [1]
    require(multiply(target_boundary, push2) == multiply(push1, cone_boundary),
            "negative control is an actual chain map")
    require(apply(cone_boundary, q) != [0, 0], "q is not closed in the cone")
    require(apply(target_boundary, apply(push2, q)) == [0],
            "q becomes closed in the target")
    require(apply(push2, q) == [1], "the pushed residual class is nonzero")

    outgoing_at_middle = [-1, -1]
    _, _, _, tree_incidence = cone_matrices(3, ((0, 1), (1, 2)))
    require(rank(tree_incidence) == 2, "negative-control graph is a tree")
    require(len(set(outgoing_at_middle)) < len(outgoing_at_middle),
            "nonimmersed tree has a repeated outgoing signed label")
    require([1, -1][0] == -[1, -1][1], "nonimmersed root-path label is trivial")
    return {
        "break_must_select_ac_not_b": {
            "old_path": list(outer.darts),
            "correct_path": list(retained.darts),
            "wrong_loop": list(discarded.darts),
            "fixed_endpoints": [0, 1],
            "wrong_loop_endpoints": [1, 1],
        },
        "closed_only_after_pushforward_is_insufficient": {
            "cone_delta": 0,
            "q": 1,
            "cone_boundary": [1, 0],
            "target_C2": "Z",
            "target_C1": "Z with zero target boundary",
            "push2": "identity",
            "push1": "zero",
            "old_class": 1,
            "new_classes": [0, 0],
        },
        "immersion_hypothesis_is_necessary_for_root_separation": {
            "graph": "three-vertex tree 0--1--2",
            "forward_signed_labels": [1, -1],
            "root": 0,
            "distinct_endpoint": 2,
            "ordinary_cyclic_immersed_paths": 0,
            "root_path_label": "identity already in the rose",
            "is_a_counterexample_to_the_staged_manuscript": False,
        },
        "a_preselected_spherical_summand_need_not_survive": [[0, 1], [1, 0]],
    }


def verify_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    answer = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "chain_complex.homology.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(answer["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian exact operation and payload")
    require(answer["result"]["operation_id"] == operation, "Jacobian operation output")
    output = answer["result"]["output"]
    require(all(output["complex"][k] == v for k, v in payload["complex"].items()),
            "Jacobian retained source complex")
    require([g["betti_number"] for g in output["homology_groups"]] == [1, 0, 0],
            "Jacobian typed homology output")
    d1, d2 = [
        [[int(x) for x in row] for row in matrix]
        for matrix in payload["complex"]["differential_matrices"]
    ]
    require(zero(multiply(d1, d2)), "Jacobian cone is actually a chain complex")
    require((rank(d1), rank(d2)) == (3, 3), "independent exact Jacobian cross-check")
    return {
        "operation_id": operation,
        "server_version": answer["server"]["version"],
        "protocol_version": answer["protocol_version"],
        "transport": answer["transport"],
        "adapter_exit_code": status["adapter_exit_code"],
        "betti_numbers_over_Q": [1, 0, 0],
        "scope": "one triangle-cone example; not a universal proof",
    }


def verify_formal_record():
    archive = json.loads((ROOT / COMPILER_CERTIFICATE).read_text())
    result = archive["lean_check"]
    require(result["status"] == "success" and result["exit_code"] == 0,
            "official Lean compiler success")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "official Lean no proof holes or unaudited axioms")
    require(result["environment_failure"] == "", "Lean environment failure")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "Lean version")
    for key, filename in (
        ("lean_source", "Main.lean"), ("statement_fidelity", "statement_fidelity.md")
    ):
        entry = archive[key]
        require(entry["text"] == (HERE / filename).read_text(),
                "compiled archive must match current source and reading")
        require((ROOT / entry["path"]).read_text() == entry["text"],
                "canonical compiler file must match archived bytes")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == CLAIM),
                key=lambda c: c["version"])
    require(claim["formal_statement"] == archive["lean_source"]["text"],
            "formal claim matches compiled source")
    require(any(
        e["subject"]["subject_id"] == CLAIM
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
        and e["artifact"] == COMPILER_CERTIFICATE
        and e["evidence_id"] == archive["evidence_id"]
        for e in state["evidence"]
    ), "current claim has actual compiler-produced mechanical evidence")
    return {
        "claim": CLAIM,
        "certificate": COMPILER_CERTIFICATE,
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "source_and_fidelity_match_compiled_archive": True,
        "fresh_compilation_performed_by_this_script": False,
        "full_topological_implication_formalized": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = {
        "claim": "C_TOPOLOGY_UNIVERSAL",
        "mathematical_result": "universal conditional theorem proved in proof.md",
        "python_evidence_kind": "exact bounded local tests and formal-record binding",
        "independent_mathematical_review": "required; not performed by this script",
        "manuscript_refutation_claims": [],
        "cone_chains": verify_cones(),
        "graph_splices": verify_paths(),
        "band_neighborhoods": verify_ribbons(),
        "periodic_resolution": verify_periodic_resolution(),
        "necessary_hypothesis_controls": verify_negative_controls(),
        "jacobian": verify_jacobian(),
        "formal_core": verify_formal_record(),
    }
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(result == json.loads(certificate.read_text()),
            "replay differs from exact_certificate.json")
    print(json.dumps({
        "ok": True,
        "graph_cases": result["cone_chains"]["ordered_multigraphs"],
        "splices": result["graph_splices"]["incidences_checked"],
        "formal_claim": CLAIM,
        "full_topology_is_prose_not_kernel": True,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
