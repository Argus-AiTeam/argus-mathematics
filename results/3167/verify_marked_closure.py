"""Replay a pointed-support certificate without importing its search program."""

import argparse
import itertools
import json
import time
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path

import full_signatures as algebra
from routing_signatures import Routing


def indices(mask):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask -= low


@lru_cache(maxsize=None)
def permutation_map(size, order):
    types, lookup = algebra.catalog(size)
    inverse = {v: i for i, v in enumerate(order)}
    return tuple(
        lookup[
            Routing(
                tuple(q.degrees[v] for v in order),
                tuple(
                    sorted(
                        tuple(sorted((inverse[a], inverse[b]))) for a, b in q.pairs
                    )
                ),
                q.closed,
            )
        ]
        for q in types
    )


@lru_cache(maxsize=16384)
def matchings(left, right):
    permitted = [
        [
            j
            for j, (h2, k2) in enumerate(right)
            if h1 + h2 <= 2 and k1 + k2 <= 2
        ]
        for h1, k1 in left
    ]
    result = []

    def visit(order, used):
        if len(order) == len(left):
            result.append(tuple(order))
            return
        for j in permitted[len(order)]:
            if not used & (1 << j):
                visit(order + [j], used | (1 << j))

    visit([], 0)
    return tuple(result)


def apply_unary(signature, spec):
    op = spec["op"]
    if op == "introduce":
        answer = algebra.introduce(signature)
    elif op == "edge":
        answer = algebra.add_edge(signature, *spec["edge"])
    elif op == "forget":
        answer = algebra.forget(signature, spec["vertex"])
    else:
        raise ValueError(f"Unknown operation {op}")
    return algebra.project(answer)


def unary_specs(signature):
    size = signature.boundary_size
    if size < 5:
        yield {"op": "introduce"}
    for a, b in itertools.combinations(range(size), 2):
        if (
            (a, b) not in signature.edges
            and signature.degrees[a] < 4
            and signature.degrees[b] < 4
        ):
            yield {"op": "edge", "edge": (a, b)}
    for v, degree in enumerate(signature.degrees):
        if degree == 4:
            yield {"op": "forget", "vertex": v}


def support(signature):
    return sum(1 << i for i, n in enumerate(signature.counts) if n)


def only_marker(signature, marker):
    return algebra.Signature(
        signature.degrees,
        signature.edges,
        tuple(int(i == marker) for i in range(len(signature.counts))),
    )


def check(path):
    data = json.loads(path.read_text())
    assert data["schema"] == "pointed-support-v1"
    assert data["saturated"] and data["witness"] is None
    rows = data["rows"]
    assert data["cursor"]["state"] == len(rows)
    signatures, orders, markers, masks = [], [], [], []
    active = defaultdict(list)
    stats = Counter()
    for i, row in enumerate(rows):
        term = row["construction"]
        op = term["op"]
        if op == "leaf":
            value, order = algebra.leaf(), 0
        elif op == "join":
            a, b = term["left"], term["right"]
            assert 0 <= a < i and 0 <= b < i
            right = algebra.relabel(signatures[b], tuple(term["right_order"]))
            value = algebra.glue(signatures[a], right)
            order = orders[a] + orders[b] - value.boundary_size
        else:
            child = term["child"]
            assert 0 <= child < i
            value = apply_unary(signatures[child], term)
            order = orders[child] + int(op == "introduce")
        value = algebra.project(algebra.relabel(value, tuple(row["canonical_order"])))
        marker, mask = row["marker"], int(row["support"], 16)
        assert value.degrees == tuple(row["degrees"])
        assert value.edges == tuple(tuple(edge) for edge in row["edges"])
        assert value.counts[marker] == 1 and mask == support(value)
        assert order >= value.boundary_size
        q = algebra.catalog(value.boundary_size)[0][marker]
        assert not (value.boundary_size == 0 and q.closed)
        assert not (
            value.degrees == (2, 2)
            and not value.edges
            and q == Routing((1, 1), ((0, 1),))
        )
        signatures.append(value)
        orders.append(order)
        markers.append(marker)
        masks.append(mask)
        if row["active"]:
            active[value.boundary_size].append(i)
        stats["replayed_construction_nodes"] += 1

    buckets = defaultdict(list)
    for ids in active.values():
        for i in ids:
            value = signatures[i]
            buckets[(value.degrees, value.edges, markers[i])].append(masks[i])

    @lru_cache(maxsize=100000)
    def covered(degrees, edges, marker, mask):
        size = len(degrees)
        target_degrees = tuple(sorted(degrees))
        for permutation in itertools.permutations(range(size)):
            if tuple(degrees[v] for v in permutation) != target_degrees:
                continue
            inverse = {old: new for new, old in enumerate(permutation)}
            mapped_edges = tuple(
                sorted(
                    tuple(sorted((inverse[a], inverse[b]))) for a, b in edges
                )
            )
            mapping = permutation_map(size, permutation)
            target_marker = mapping[marker]
            key = target_degrees, mapped_edges, target_marker
            if key not in buckets:
                continue
            mapped_mask = sum(1 << mapping[j] for j in indices(mask))
            if any(candidate & mapped_mask == candidate for candidate in buckets[key]):
                return True
        return False

    for value, marker, mask in zip(signatures, markers, masks):
        assert covered(value.degrees, value.edges, marker, mask)
    leaf = algebra.leaf()
    leaf_marker = next(i for i, n in enumerate(leaf.counts) if n == 1)
    assert covered((), (), leaf_marker, support(leaf))
    stats["leaf_obligations"] = 1

    sparse = [tuple((q, n) for q, n in enumerate(s.counts) if n) for s in signatures]
    colors = []
    for value, marker in zip(signatures, markers):
        h = algebra.catalog(value.boundary_size)[0][marker].degrees
        colors.append(tuple((a, g - a) for g, a in zip(value.degrees, h)))

    for size, ids in sorted(active.items()):
        table = algebra.join_table(size)
        for position, i in enumerate(ids):
            first = signatures[i]
            for spec in unary_specs(first):
                value = apply_unary(first, spec)
                marked_value = apply_unary(only_marker(first, markers[i]), spec)
                for q, n in enumerate(value.counts):
                    if n == 1 and marked_value.counts[q]:
                        assert covered(value.degrees, value.edges, q, support(value)), (
                            "uncovered unary output", i, spec, q
                        )
                        stats["unary_pointed_outputs"] += 1
                stats["unary_operations"] += 1
            for j in ids[: position + 1]:
                if orders[i] == size or orders[j] == size:
                    stats["boundary_only_join_pairs_derived"] += 1
                    continue
                stats["nonboundary_operand_pairs"] += 1
                second = signatures[j]
                for permutation in matchings(colors[i], colors[j]):
                    inverse = {old: new for new, old in enumerate(permutation)}
                    right_edges = {
                        tuple(sorted((inverse[a], inverse[b]))) for a, b in second.edges
                    }
                    if set(first.edges) & right_edges:
                        continue
                    mapping = permutation_map(size, permutation)
                    target = table[markers[i]][mapping[markers[j]]]
                    if target < 0:
                        continue
                    stats["admissible_relative_join_orders"] += 1
                    right_sparse = tuple((mapping[q], n) for q, n in sparse[j])
                    count = 0
                    for a, n in sparse[i]:
                        for b, m in right_sparse:
                            if table[a][b] == target:
                                count += n * m
                                if count > 1:
                                    break
                        if count > 1:
                            break
                    assert count >= 1
                    if count > 1:
                        stats["nonunique_join_markers"] += 1
                        continue
                    right = algebra.relabel(second, permutation)
                    value = algebra.project(algebra.glue(first, right))
                    assert value.counts[target] == 1
                    assert covered(value.degrees, value.edges, target, support(value)), (
                        "uncovered join output", i, j, permutation, target
                    )
                    stats["unique_join_pointed_outputs"] += 1
        print(
            json.dumps(
                {"checked_boundary_size": size, "active_states": len(ids), "counts": stats}
            ),
            flush=True,
        )

    return {
        "classification": "finite_operation_closed_separating_certificate",
        "claim": "C3167-TW4-TWO-POLE-EXCLUSION",
        "certificate": str(path),
        "reconstruction_uses": "Reviewed full counting algebra, not the pointed search program",
        "join_enumeration": "Independent recursive bijections satisfying selected and rejected degree capacities",
        "closed_routings": "Retained in every support and all counting operations",
        "arbitrary_binary_joins": "All admissible relative orders, with boundary-only joins derived from unary closure",
        "boundary_relabeling": "All permutations in coverage; all relative permutations at joins",
        "active_states": sum(map(len, active.values())),
        "active_by_boundary_size": {b: len(ids) for b, ids in sorted(active.items())},
        "counts": dict(stats),
        "all_orders_terminal_exclusion": True,
        "all_orders_quartic_treewidth_four_exclusion": True,
        "host_independent_review": "required_not_yet_performed",
        "novelty_status": "not_verified",
        "significance_status": "not_yet_independently_assessed",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    start = time.monotonic()
    result = check(args.certificate)
    result["elapsed_seconds"] = round(time.monotonic() - start, 6)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result), flush=True)


if __name__ == "__main__":
    main()
