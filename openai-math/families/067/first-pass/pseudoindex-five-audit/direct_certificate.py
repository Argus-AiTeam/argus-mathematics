#!/usr/bin/env python3
"""Find a rational implication certificate, retaining exact row operations."""

import argparse
import heapq
import json
from fractions import Fraction
from itertools import combinations_with_replacement
from math import gcd, lcm
from pathlib import Path
from time import monotonic

import sympy as sp

from verify import J, WEIGHTS, build_constraints


ROOT = Path(__file__).resolve().parent


def primitive(row):
    row = {j: value for j, value in row.items() if value}
    divisor = gcd(*row.values()) if row else 1
    return {j: value // divisor for j, value in row.items()}, divisor


def eliminate(rows, nodes, pivot_columns, tag=None):
    active = {}
    incidence = {j: set() for j in pivot_columns}
    heap = []
    finished = []
    pivots = 0
    started = monotonic()

    def insert(position, node, row):
        allowed = pivot_columns.intersection(row)
        if not allowed:
            if tag is not None and row.get(tag, 0):
                return node
            if row:
                finished.append(node)
            return None
        active[position] = (node, row)
        for column in allowed:
            incidence[column].add(position)
        bits = max(abs(value).bit_length() for value in row.values())
        heapq.heappush(heap, (len(row), bits, position, node))
        return None

    def remove(position):
        node, row = active.pop(position)
        for column in pivot_columns.intersection(row):
            incidence[column].remove(position)
        return node, row

    for position, row in enumerate(rows):
        result = insert(position, position, row)
        assert result is None

    while heap:
        _, _, position, old_node = heapq.heappop(heap)
        if position not in active or active[position][0] != old_node:
            continue
        pivot_node, pivot = remove(position)
        pivot_column = min(
            pivot_columns.intersection(pivot),
            key=lambda j: (
                len(incidence[j]), abs(pivot[j]).bit_length(), j
            ),
        )
        affected = sorted(incidence[pivot_column])
        for other in affected:
            node, row = remove(other)
            a, b = row[pivot_column], pivot[pivot_column]
            common = gcd(a, b)
            left, right = b // common, a // common
            updated = {j: left*value for j, value in row.items()}
            for j, value in pivot.items():
                updated[j] = updated.get(j, 0) - right*value
            updated, divisor = primitive(updated)
            new_node = len(nodes)
            nodes.append(["op", node, pivot_node, left, right, divisor])
            result = insert(other, new_node, updated)
            if result is not None:
                print(
                    f"dependence found: pivots={pivots}, nodes={len(nodes)}, "
                    f"elapsed={monotonic()-started:.3f}s",
                    flush=True,
                )
                return result, finished
        pivots += 1
        if pivots % 100 == 0:
            print(
                f"pivots={pivots}, active={len(active)}, nodes={len(nodes)}, "
                f"elapsed={monotonic()-started:.3f}s",
                flush=True,
            )
    return None, finished


def replay_node(nodes, index, leaves, cache):
    if index in cache:
        return cache[index]
    operation = nodes[index]
    if operation[0] != "op":
        answer = leaves(operation)
    else:
        _, a, b, left, right, divisor = operation
        first = replay_node(nodes, a, leaves, cache)
        second = replay_node(nodes, b, leaves, cache)
        answer = {j: left*value for j, value in first.items()}
        for j, value in second.items():
            answer[j] = answer.get(j, 0) - right*value
        answer = {j: value // divisor for j, value in answer.items() if value}
    cache[index] = answer
    return answer


def prune(nodes, roots):
    used = set()
    stack = list(roots)
    while stack:
        index = stack.pop()
        if index in used:
            continue
        used.add(index)
        if nodes[index][0] == "op":
            stack.extend(nodes[index][1:3])
    ordering = sorted(used)
    mapping = {old: new for new, old in enumerate(ordering)}
    answer = []
    for old in ordering:
        operation = list(nodes[old])
        if operation[0] == "op":
            operation[1] = mapping[operation[1]]
            operation[2] = mapping[operation[2]]
        answer.append(operation)
    return answer, [mapping[root] for root in roots]


def select_independent(rows, roots, expected=69):
    prime = 10007
    basis = {}
    selected = []
    order = sorted(
        range(len(rows)),
        key=lambda i: (
            len(rows[i]),
            max(abs(v).bit_length() for v in rows[i].values()),
            roots[i],
        ),
    )
    for i in order:
        row = {j: v % prime for j, v in rows[i].items() if v % prime}
        while row:
            pivot = min(row)
            if pivot not in basis:
                inverse = pow(row[pivot], -1, prime)
                basis[pivot] = {j: v*inverse % prime for j, v in row.items()}
                selected.append(i)
                break
            factor = row[pivot]
            for j, value in basis[pivot].items():
                new = (row.get(j, 0) - factor*value) % prime
                if new:
                    row[j] = new
                else:
                    row.pop(j, None)
        if len(selected) == expected:
            break
    assert len(selected) == expected
    return [rows[i] for i in selected], [roots[i] for i in selected]


def transform_roots(nodes, roots, transformation, divisors):
    zero = len(nodes)
    nodes.append(["op", roots[0], roots[0], 1, 1, 1])
    answer = []
    for i, divisor in enumerate(divisors):
        coefficients = [Fraction(str(value)) for value in transformation.row(i)]
        denominator = lcm(*(value.denominator for value in coefficients))
        root = zero
        for parent, value in zip(roots, coefficients):
            coefficient = int(value*denominator)
            if coefficient:
                nodes.append(["op", root, parent, 1, -coefficient, 1])
                root = len(nodes) - 1
        if denominator*divisor != 1:
            nodes.append(["op", root, zero, 1, 1, denominator*divisor])
            root = len(nodes) - 1
        answer.append(root)
    return answer


def module_certificate(projected, roots, projection_nodes, C1, shape):
    from sympy.polys.distributedmodules import sdm_groebner, sdm_nf_buchberger
    from sympy.polys.domains import QQ

    positions = {j: i for i, j in enumerate(J)}

    def order(monomial):
        return monomial[0], sum(monomial[1:]), monomial[1:]

    generators = []
    for row in projected:
        terms = []
        for column, value in row.items():
            i, j = C1[column]
            powers = [0] * len(J)
            powers[positions[j]] = 1
            terms.append(((i, *powers), QQ(value)))
        generators.append(sorted(terms, key=lambda term: order(term[0]), reverse=True))
    target = []
    for a, b, coefficient in ((3, 0, 32), (2, 1, -20), (1, 2, 3)):
        powers = [0] * len(J)
        powers[0], powers[1] = a, b
        target.append(((0, *powers), QQ(coefficient)))
    target.sort(key=lambda term: order(term[0]), reverse=True)
    started = monotonic()
    calls = 0
    last_test = -1

    class TargetFound(Exception):
        def __init__(self, coefficients):
            self.coefficients = coefficients

    def normal_form(f, G, O, K, phantom=None):
        nonlocal calls, last_test
        calls += 1
        degree = max((sum(m[1:]) for m, _ in f), default=0)
        checkpoint = len(G) // 10
        if checkpoint != last_test or degree > 3:
            last_test = checkpoint
            assert phantom is not None
            remainder, coefficients = sdm_nf_buchberger(
                target, G, O, K, phantom=([], phantom[1])
            )
            if not remainder:
                raise TargetFound(coefficients)
        if degree > 3:
            raise RuntimeError("Degree-three module search ended without a target certificate.")
        if calls % 100 == 0:
            print(
                f"module normal forms={calls}, basis={len(G)}, degree={degree}, "
                f"elapsed={monotonic()-started:.3f}s",
                flush=True,
            )
        return sdm_nf_buchberger(f, G, O, K, phantom=phantom)

    print("searching an exact degree-three module cofactor identity", flush=True)
    try:
        basis, transitions = sdm_groebner(
            generators, normal_form, order, QQ, extended=True
        )
        remainder, coefficients = sdm_nf_buchberger(
            target, basis, order, QQ, phantom=([], transitions)
        )
        assert not remainder, "The module search did not produce the target."
    except TargetFound as found:
        coefficients = found.coefficients
    multipliers = [
        [monomial[0], list(monomial[1:]), str(-value)]
        for monomial, value in coefficients
    ]
    assert multipliers and all(sum(powers) == 2 for _, powers, _ in multipliers)
    used = sorted({i for i, _, _ in multipliers})
    mapping = {old: new for new, old in enumerate(used)}
    for entry in multipliers:
        entry[0] = mapping[entry[0]]
    projection_nodes, roots = prune(
        projection_nodes, [roots[i] for i in used]
    )
    certificate = {
        "result_class": "exact_verification_theorem",
        "statement": (
            "The geometrically justified six row families and the selected "
            "projection-formula products imply 32-20u+3u^2=0 over QQ."
        ),
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "unassessed",
        "independent_review": "pending",
        "source_shape": list(shape),
        "selected_coordinates": len(C1),
        "cubic_coordinates": 6820,
        "projection_nodes": projection_nodes,
        "projection_roots": roots,
        "proof_format": "polynomial_module_identity",
        "eta_indices": list(J),
        "module_multipliers": multipliers,
        "proof_method": "explicit quadratic QQ cofactors; no modular-to-rational inference",
    }
    (ROOT / "module_certificate.json").write_text(
        json.dumps(certificate, separators=(",", ":")) + "\n", encoding="ascii"
    )
    print(
        f"module certificate: {len(roots)} lifted relations, "
        f"{len(multipliers)} cofactor terms, elapsed={monotonic()-started:.3f}s",
        flush=True,
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--reduce-basis", action="store_true")
    group.add_argument("--saturate-basis", action="store_true")
    parser.add_argument("--module-groebner", action="store_true")
    arguments = parser.parse_args()
    A, _, _, M, G, C1, selected = build_constraints()
    source = A.to_sparse().rep.to_sdm()
    rows = []
    projection_nodes = []
    for i in range(A.shape[0]):
        rational = {j: Fraction(str(value)) for j, value in source[i].items()}
        denominator = lcm(*(value.denominator for value in rational.values()))
        integer = {j: int(value*denominator) for j, value in rational.items()}
        integer, divisor = primitive(integer)
        rows.append(integer)
        projection_nodes.append(["A", i, str(Fraction(denominator, divisor))])
    print("projecting source relations", flush=True)
    _, roots = eliminate(
        rows, projection_nodes, set(range(A.shape[1])) - set(selected)
    )

    def source_leaf(operation):
        _, i, scale = operation
        scale = Fraction(scale)
        return {j: int(Fraction(str(v))*scale) for j, v in source[i].items()}

    cache = {i: row for i, row in enumerate(rows)}
    selected_index = {column: i for i, column in enumerate(selected)}
    projected = [
        {
            selected_index[column]: value
            for column, value in replay_node(
                projection_nodes, root, source_leaf, cache
            ).items()
        }
        for root in roots
    ]
    projected, roots = select_independent(projected, roots)
    print(
        f"selected {len(projected)} relations; "
        f"nonzeros={sum(map(len, projected))}; "
        f"maximum bits={max(abs(v).bit_length() for row in projected for v in row.values())}",
        flush=True,
    )
    if arguments.reduce_basis:
        for iteration in range(2):
            started = monotonic()
            dense = sp.Matrix([
                [row.get(j, 0) for j in range(len(C1))] for row in projected
            ])
            reduced, transformation = dense.lll_transform()
            assert reduced == transformation*dense
            new_rows, divisors = [], []
            for i in range(reduced.rows):
                row, divisor = primitive({
                    j: int(reduced[i, j]) for j in range(reduced.cols)
                    if reduced[i, j]
                })
                new_rows.append(row)
                divisors.append(divisor)
            roots = transform_roots(
                projection_nodes, roots, transformation, divisors
            )
            projected = new_rows
            print(
                f"LLL pass {iteration+1}: nonzeros={sum(map(len, projected))}, "
                f"maximum bits={max(abs(v).bit_length() for row in projected for v in row.values())}, "
                f"elapsed={monotonic()-started:.3f}s",
                flush=True,
            )
    if arguments.saturate_basis:
        from flint import fmpz_mat

        started = monotonic()
        linear = json.loads((ROOT / "linear_data.json").read_text())
        P = sp.Matrix([
            [dict(linear["K"][column]).get(j, "0") for j in range(65)]
            for column in selected
        ]).applyfunc(sp.Rational)
        integer = sp.zeros(P.rows, P.cols)
        for j in range(P.cols):
            denominator = lcm(*(int(value.q) for value in P.col(j)))
            for i in range(P.rows):
                integer[i, j] = int(P[i, j]*denominator)
        embedding = sp.eye(P.rows).row_join(10**30*integer)
        reduced_native = fmpz_mat([
            [int(value) for value in embedding.row(i)]
            for i in range(embedding.rows)
        ]).lll()
        reduced = sp.Matrix([
            [int(reduced_native[i, j]) for j in range(embedding.cols)]
            for i in range(embedding.rows)
        ])
        short = [
            [int(reduced[i, j]) for j in range(P.rows)]
            for i in range(reduced.rows)
            if not any(reduced[i, P.rows:])
        ]
        assert len(short) == 69, "Lattice search did not expose a full short basis."
        short = sp.Matrix(short).lll()
        dense = sp.Matrix([
            [row.get(j, 0) for j in range(len(C1))] for row in projected
        ])
        _, pivots = dense.rref()
        assert len(pivots) == 69
        transformation = short[:, pivots] * dense[:, pivots].inv()
        assert transformation*dense == short
        new_rows, divisors = [], []
        for i in range(short.rows):
            row, divisor = primitive({
                j: int(short[i, j]) for j in range(short.cols) if short[i, j]
            })
            new_rows.append(row)
            divisors.append(divisor)
        roots = transform_roots(
            projection_nodes, roots, transformation, divisors
        )
        projected = new_rows
        print(
            f"saturated basis: nonzeros={sum(map(len, projected))}, "
            f"maximum bits={max(abs(v).bit_length() for row in projected for v in row.values())}, "
            f"elapsed={monotonic()-started:.3f}s",
            flush=True,
        )
    if arguments.module_groebner:
        module_certificate(projected, roots, projection_nodes, C1, A.shape)
        return
    c3 = [
        (i, z) for i in range(len(M))
        for z in combinations_with_replacement(J, 3)
        if M[i][0] or any(sum(a*b for a, b in zip(G[j], WEIGHTS)) == 3 for j in z)
    ]
    assert len(c3) == 6820
    lookup = {coordinate: i for i, coordinate in enumerate(c3)}
    cubic_rows = []
    cubic_nodes = []
    for relation, row in enumerate(projected):
        for pair in combinations_with_replacement(J, 2):
            cubic = {}
            for column, value in row.items():
                i, j = C1[column]
                coordinate = lookup[(i, tuple(sorted((j,) + pair)))]
                assert coordinate not in cubic
                cubic[coordinate] = value
            cubic_rows.append(cubic)
            cubic_nodes.append(["L", relation, list(pair)])
    target = {
        lookup[(0, (0, 0, 0))]: 32,
        lookup[(0, (0, 0, 1))]: -20,
        lookup[(0, (0, 1, 1))]: 3,
        len(c3): 1,
    }
    cubic_rows.append(target)
    cubic_nodes.append(["target"])
    print("eliminating cubic relations with an exact target tag", flush=True)
    root, _ = eliminate(
        cubic_rows, cubic_nodes, set(range(len(c3))), tag=len(c3)
    )
    assert root is not None, "No target dependence was obtained."
    cubic_nodes, [root] = prune(cubic_nodes, [root])
    used_relations = sorted({
        operation[1] for operation in cubic_nodes if operation[0] == "L"
    })
    relation_mapping = {old: new for new, old in enumerate(used_relations)}
    projection_nodes, compact_roots = prune(
        projection_nodes, [roots[i] for i in used_relations]
    )
    for operation in cubic_nodes:
        if operation[0] == "L":
            operation[1] = relation_mapping[operation[1]]
    certificate = {
        "result_class": "exact_verification_theorem",
        "statement": (
            "The geometrically justified six row families and the selected "
            "projection-formula products imply 32-20u+3u^2=0 over QQ."
        ),
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "unassessed",
        "independent_review": "pending",
        "source_shape": list(A.shape),
        "selected_coordinates": len(C1),
        "cubic_coordinates": len(c3),
        "projection_nodes": projection_nodes,
        "projection_roots": compact_roots,
        "cubic_nodes": cubic_nodes,
        "cubic_root": root,
        "proof_format": "row_operation_trace",
        "proof_method": "exact rational row identities; no modular-to-rational inference",
    }
    if arguments.saturate_basis:
        output = "saturated_certificate.json"
    elif arguments.reduce_basis:
        output = "reduced_certificate.json"
    else:
        output = "direct_unreduced_certificate.json"
    (ROOT / output).write_text(
        json.dumps(certificate, separators=(",", ":")) + "\n", encoding="ascii"
    )
    print(
        f"certificate: projection nodes={len(projection_nodes)}, "
        f"relations={len(compact_roots)}, cubic nodes={len(cubic_nodes)}",
        flush=True,
    )


if __name__ == "__main__":
    main()
