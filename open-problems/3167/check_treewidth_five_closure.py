"""Independent full-count replay and closure check for a six-terminal collection."""

import argparse
import itertools
import json
import time
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path

from research.treewidth_five import algebra

from routing_signatures import Routing


def bits(mask):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask -= low


@lru_cache(maxsize=None)
def permutation_map(size, order):
    types, lookup = algebra.catalog(size)
    inverse = {vertex: i for i, vertex in enumerate(order)}
    return tuple(
        lookup[
            Routing(
                tuple(routing.degrees[v] for v in order),
                tuple(
                    sorted(
                        tuple(sorted((inverse[a], inverse[b])))
                        for a, b in routing.pairs
                    )
                ),
                routing.closed,
            )
        ]
        for routing in types
    )


@lru_cache(maxsize=None)
def degree_orders(degrees):
    target = tuple(sorted(degrees))
    return tuple(
        order for order in itertools.permutations(range(len(degrees)))
        if tuple(degrees[v] for v in order) == target
    )


@lru_cache(maxsize=None)
def live_entries(degrees):
    size = len(degrees)
    probe = algebra.Signature(degrees, (), (1,) * len(algebra.catalog(size)[0]))
    return algebra.project(probe).counts


@lru_cache(maxsize=None)
def unary_images(size, operation, parameter=None):
    types = algebra.catalog(size)[0]
    if operation == "introduce":
        lookup = algebra.catalog(size + 1)[1]
        return tuple(
            (lookup[Routing(t.degrees + (0,), t.pairs, t.closed)],)
            for t in types
        )
    if operation == "forget":
        vertex = parameter
        lookup = algebra.catalog(size - 1)[1]
        return tuple(
            (
                lookup[
                    Routing(
                        t.degrees[:vertex] + t.degrees[vertex + 1 :],
                        tuple(
                            (a - (a > vertex), b - (b > vertex))
                            for a, b in t.pairs
                        ),
                        t.closed,
                    )
                ],
            )
            if t.degrees[vertex] == 2
            else ()
            for t in types
        )
    if operation == "edge":
        a, b = parameter
        edge = algebra.catalog(size)[1][
            Routing(tuple(int(v in (a, b)) for v in range(size)), ((a, b),))
        ]
        table = algebra.join_table(size)
        return tuple(
            (q, table[q][edge]) if table[q][edge] >= 0 else (q,)
            for q in range(len(types))
        )
    raise ValueError(f"Unknown unary operation: {operation}")


def unary_parameter(spec):
    return tuple(spec["edge"]) if spec["op"] == "edge" else spec.get("vertex")


@lru_cache(maxsize=8192)
def weighted_entries(counts):
    return tuple((q, count) for q, count in enumerate(counts) if count)


def scalar_unary(value, spec):
    size, operation = value.boundary_size, spec["op"]
    parameter = unary_parameter(spec)
    if operation == "introduce":
        assert size < algebra.BOUNDARY_LIMIT
        degrees, edges = value.degrees + (0,), value.edges
    elif operation == "edge":
        a, b = parameter
        assert 0 <= a < b < size and (a, b) not in value.edges
        assert value.degrees[a] < 4 and value.degrees[b] < 4
        degrees = tuple(g + int(v in (a, b)) for v, g in enumerate(value.degrees))
        edges = tuple(sorted(value.edges + ((a, b),)))
    elif operation == "forget":
        vertex = parameter
        assert 0 <= vertex < size and value.degrees[vertex] == 4
        degrees = value.degrees[:vertex] + value.degrees[vertex + 1 :]
        edges = tuple(
            (a - (a > vertex), b - (b > vertex))
            for a, b in value.edges
            if vertex not in (a, b)
        )
    else:
        raise ValueError(f"Unknown unary operation: {operation}")
    live = live_entries(degrees)
    counts = [0] * len(live)
    images = unary_images(size, operation, parameter)
    for q, count in weighted_entries(value.counts):
        for target in images[q]:
            if live[target] and counts[target] < 2:
                counts[target] = min(2, counts[target] + count)
    return algebra.Signature(degrees, edges, tuple(counts))


def scalar_relabel(value, order):
    order = tuple(order)
    size = value.boundary_size
    assert sorted(order) == list(range(size))
    mapping = permutation_map(size, order)
    inverse = {old: new for new, old in enumerate(order)}
    counts = [0] * len(value.counts)
    for q, count in enumerate(value.counts):
        if count:
            counts[mapping[q]] = count
    return algebra.Signature(
        tuple(value.degrees[v] for v in order),
        tuple(sorted(tuple(sorted((inverse[a], inverse[b]))) for a, b in value.edges)),
        tuple(counts),
    )


def scalar_join(first, second):
    assert first.boundary_size == second.boundary_size
    assert not set(first.edges) & set(second.edges)
    degrees = tuple(a + b for a, b in zip(first.degrees, second.degrees))
    assert all(g <= 4 for g in degrees)
    live = live_entries(degrees)
    remaining = sum(live)
    counts = [0] * len(live)
    table = algebra.join_table(first.boundary_size)
    right = tuple((q, n) for q, n in enumerate(second.counts) if n)
    for a, n in enumerate(first.counts):
        if not n:
            continue
        for b, m in right:
            target = table[a][b]
            if target >= 0 and live[target] and counts[target] < 2:
                counts[target] = min(2, counts[target] + n * m)
                if counts[target] == 2:
                    remaining -= 1
                    if not remaining:
                        break
        if not remaining:
            break
    return algebra.Signature(
        degrees, tuple(sorted(first.edges + second.edges)), tuple(counts)
    )


@lru_cache(maxsize=16384)
def relative_orders(left, right):
    permitted = [
        [
            j
            for j, (selected_right, rejected_right) in enumerate(right)
            if selected_left + selected_right <= 2
            and rejected_left + rejected_right <= 2
        ]
        for selected_left, rejected_left in left
    ]
    result = []

    def visit(order, used):
        if len(order) == len(left):
            result.append(tuple(order))
            return
        for vertex in permitted[len(order)]:
            if vertex not in used:
                visit(order + [vertex], used | {vertex})

    visit([], set())
    return tuple(result)


def sparse_groups(size, entries):
    types = algebra.catalog(size)[0]
    groups = defaultdict(list)
    for q, count in entries:
        groups[types[q].degrees].append((q, count))
    return {
        degrees: tuple(sorted(values, key=lambda entry: -entry[1]))
        for degrees, values in groups.items()
    }


def target_count(first, second_groups, inverse, mapping, target, types, table):
    degrees = types[target].degrees
    count = 0
    for a, n in first:
        wanted = tuple(
            degrees[inverse[v]] - types[a].degrees[inverse[v]]
            for v in range(len(degrees))
        )
        if any(h < 0 for h in wanted):
            continue
        for b, m in second_groups.get(wanted, ()):
            if table[a][mapping[b]] == target:
                count += n * m
                if count > 1:
                    return 2
    return count


def join_pair_blocks(ids, colors, orders, size):
    groups = defaultdict(list)
    for i in ids:
        if orders[i] > size:
            key = (
                sum(h for h, _ in colors[i]),
                sum(f for _, f in colors[i]),
            )
            groups[key].append(i)
    nonboundary = sum(map(len, groups.values()))
    total = nonboundary * (nonboundary + 1) // 2
    excluded = 0
    blocks = []
    items = sorted(groups.items())
    for position, (left, first) in enumerate(items):
        for right, second in items[position:]:
            same = left == right
            count = (
                len(first) * (len(first) + 1) // 2
                if same
                else len(first) * len(second)
            )
            if left[0] + right[0] > 2 * size or left[1] + right[1] > 2 * size:
                excluded += count
            else:
                blocks.append((first, second, same))
    return blocks, total, excluded


def proper_adhesion_pair_blocks(ids, colors, orders, size, zero_degrees):
    groups = defaultdict(list)
    for i in ids:
        if orders[i] > size:
            groups[(
                sum(h for h, _ in colors[i]),
                sum(f for _, f in colors[i]),
                zero_degrees[i],
            )].append(i)
    nonboundary = sum(map(len, groups.values()))
    total = nonboundary * (nonboundary + 1) // 2
    degree_excluded = dense_derived = 0
    blocks = []
    items = sorted(groups.items())
    for position, (left, first) in enumerate(items):
        for right, second in items[position:]:
            same = left == right
            count = (
                len(first) * (len(first) + 1) // 2
                if same else len(first) * len(second)
            )
            if not (left[2] or right[2]):
                dense_derived += count
            elif left[0] + right[0] > 2 * size or left[1] + right[1] > 2 * size:
                degree_excluded += count
            else:
                blocks.append((first, second, same))
    return blocks, total, degree_excluded, dense_derived


def check(path, reconstruction_only=False, first_unary_gap=False, proper_adhesion=False):
    from research.treewidth_five import edge_preorder

    data = json.loads(path.read_text())
    assert data["schema"] == "six-terminal-pointed-support-v1"
    assert data["boundary_limit"] == 6
    edge_subset = data.get("dominance") == edge_preorder.DOMINANCE
    rows = data["rows"]
    assert 0 <= data["cursor"]["state"] <= len(rows)
    if not reconstruction_only:
        if proper_adhesion:
            assert data["join_schedule"] == "zero_underlying_boundary_degree_relative_joins_v1"
            assert data["sparse_join_saturated"], "An incomplete sparse frontier cannot certify closure"
        else:
            assert data["saturated"], "An incomplete frontier cannot certify closure"
        assert data["cursor"]["state"] == len(rows)
        assert data["witness"] is None
    signatures = []
    orders = []
    markers = []
    masks = []
    active = defaultdict(list)
    stats = Counter()
    accepting = []
    terminal_candidates = []
    for i, row in enumerate(rows):
        term = row["construction"]
        operation = term["op"]
        if operation == "leaf":
            value, graph_order = algebra.leaf(), 0
        elif operation == "join":
            left, right = term["left"], term["right"]
            assert 0 <= left < i and 0 <= right < i
            other = scalar_relabel(signatures[right], term["right_order"])
            value = scalar_join(signatures[left], other)
            graph_order = orders[left] + orders[right] - value.boundary_size
        else:
            child = term["child"]
            assert 0 <= child < i
            value = algebra.apply_unary(signatures[child], term)
            graph_order = orders[child] + int(operation == "introduce")
        value = scalar_relabel(value, row["canonical_order"])
        marker, mask = row["marker"], int(row["support"], 16)
        assert 0 <= value.boundary_size <= 6
        assert value.degrees == tuple(row["degrees"])
        assert value.edges == tuple(tuple(edge) for edge in row["edges"])
        assert 0 <= marker < len(value.counts)
        assert value.counts[marker] == 1 and mask == algebra.support(value)
        assert graph_order >= value.boundary_size
        if graph_order > value.boundary_size:
            empty = next(
                q for q, routing in enumerate(algebra.catalog(value.boundary_size)[0])
                if not routing.closed and not routing.pairs
            )
            assert value.counts[empty] == 0
        routing = algebra.catalog(value.boundary_size)[0][marker]
        if value.boundary_size == 0 and routing.closed:
            accepting.append(i)
        if (
            value.degrees == (2, 2)
            and not value.edges
            and routing == Routing((1, 1), ((0, 1),))
        ):
            terminal_candidates.append(i)
        signatures.append(value)
        orders.append(graph_order)
        markers.append(marker)
        masks.append(mask)
        if row["active"]:
            active[value.boundary_size].append(i)
        stats["replayed_construction_nodes"] += 1
        if (i + 1) % 10000 == 0:
            print(json.dumps({"replayed_construction_rows": i + 1}), flush=True)

    buckets = defaultdict(list)
    edge_buckets = defaultdict(list)
    for ids in active.values():
        for i in ids:
            value = signatures[i]
            buckets[(value.degrees, value.edges, markers[i])].append(masks[i])
            if edge_subset:
                edge_buckets[(value.degrees, markers[i])].append(
                    (edge_preorder.edge_mask(value.edges), masks[i])
                )
    exact = {key: set(values) for key, values in buckets.items()}

    @lru_cache(maxsize=100000)
    def covered(degrees, edges, marker, mask):
        if mask in exact.get((degrees, edges, marker), ()):
            return True
        size = len(degrees)
        target_degrees = tuple(sorted(degrees))
        for permutation in degree_orders(degrees):
            inverse = {old: new for new, old in enumerate(permutation)}
            target_edges = tuple(
                sorted(
                    tuple(sorted((inverse[a], inverse[b]))) for a, b in edges
                )
            )
            mapping = permutation_map(size, permutation)
            if edge_subset:
                present = edge_preorder.edge_mask(target_edges)
                candidates = [
                    mask for required, mask in edge_buckets.get(
                        (target_degrees, mapping[marker]), ()
                    )
                    if required & present == required
                ]
            else:
                candidates = buckets.get(
                    (target_degrees, target_edges, mapping[marker]), ()
                )
            if not candidates:
                continue
            target_mask = sum(1 << mapping[q] for q in bits(mask))
            if any(candidate & target_mask == candidate for candidate in candidates):
                return True
        return False

    for value, marker, mask in zip(signatures, markers, masks):
        assert covered(value.degrees, value.edges, marker, mask)
    leaf = algebra.leaf()
    leaf_marker = next(i for i, count in enumerate(leaf.counts) if count == 1)
    assert covered((), (), leaf_marker, algebra.support(leaf))
    stats["leaf_obligations"] = 1

    gap = None
    if first_unary_gap:
        assert reconstruction_only
        pending = sorted(
            (i for ids in active.values() for i in ids),
            key=lambda i: (i < data["cursor"]["state"], i),
        )
        for i in pending:
            value = signatures[i]
            stats["unary_gap_scan_rows"] += 1
            for spec in algebra.unary_specs(value):
                stats["unary_gap_scan_operations"] += 1
                parent = scalar_unary(value, spec)
                images = unary_images(
                    value.boundary_size, spec["op"], unary_parameter(spec)
                )[markers[i]]
                for target in sorted(set(images)):
                    if parent.counts[target] == 1:
                        stats["unary_gap_scan_pointed_outputs"] += 1
                    if (
                        parent.counts[target] == 1
                        and not covered(
                            parent.degrees, parent.edges, target, algebra.support(parent)
                        )
                    ):
                        gap = {
                            "child_row": i,
                            "operation": spec,
                            "degrees": parent.degrees,
                            "edges": parent.edges,
                            "marker": target,
                            "support": hex(algebra.support(parent)),
                            "distinguished_parent_count": 1,
                            "covered_by_active_collection": False,
                        }
                        break
                if gap is not None:
                    break
                if stats["unary_gap_scan_rows"] % 10000 == 0:
                    print(
                        json.dumps({
                            "checked_unary_rows": stats["unary_gap_scan_rows"],
                            "checked_unary_operations": stats["unary_gap_scan_operations"],
                            "checked_pointed_outputs": stats["unary_gap_scan_pointed_outputs"],
                        }),
                        flush=True,
                    )
            if gap is not None:
                break

    if not reconstruction_only:
        assert not accepting, ("accepting marker present", accepting)
        assert not terminal_candidates, ("terminal candidate present", terminal_candidates)
        sparse = [
            tuple(
                sorted(
                    ((q, count) for q, count in enumerate(value.counts) if count),
                    key=lambda entry: -entry[1],
                )
            )
            for value in signatures
        ]
        colors = []
        for value, marker in zip(signatures, markers):
            selected = algebra.catalog(value.boundary_size)[0][marker].degrees
            colors.append(
                tuple((h, g - h) for g, h in zip(value.degrees, selected))
            )
        grouped = [
            sparse_groups(value.boundary_size, entries)
            for value, entries in zip(signatures, sparse)
        ]
        for size, ids in sorted(active.items()):
            table = algebra.join_table(size)
            types = algebra.catalog(size)[0]
            empty = next(q for q, routing in enumerate(types) if not routing.closed and not routing.pairs)
            for q, routing in enumerate(types):
                if routing.closed:
                    for other in range(len(types)):
                        expected = q if other == empty else -1
                        assert table[q][other] == table[other][q] == expected
                        stats["closed_join_type_identities"] += 1
            for i in ids:
                first = signatures[i]
                for spec in algebra.unary_specs(first):
                    value = scalar_unary(first, spec)
                    images = unary_images(
                        size, spec["op"], unary_parameter(spec)
                    )[markers[i]]
                    for target in sorted(set(images)):
                        if value.counts[target] == 1:
                            assert covered(
                                value.degrees, value.edges, target, algebra.support(value)
                            ), ("uncovered unary output", i, spec, target)
                            stats["unary_pointed_outputs"] += 1
                    stats["unary_operations"] += 1
            nonboundary = sum(orders[i] > size for i in ids)
            all_nonboundary_pairs = nonboundary * (nonboundary + 1) // 2
            open_ids = [i for i in ids if not types[markers[i]].closed]
            dense_derived = 0
            if proper_adhesion:
                blocks, total, excluded, dense_derived = proper_adhesion_pair_blocks(
                    open_ids, colors, orders, size,
                    [0 in value.degrees for value in signatures],
                )
            else:
                blocks, total, excluded = join_pair_blocks(open_ids, colors, orders, size)
            closed_pairs = all_nonboundary_pairs - total
            stats["nonboundary_operand_pairs"] += all_nonboundary_pairs
            stats["closed_nonboundary_operand_pairs_inert"] += closed_pairs
            stats["boundary_only_join_pairs_derived"] += (
                len(ids) * (len(ids) + 1) // 2 - all_nonboundary_pairs
            )
            stats["operand_pairs_excluded_by_degree_sums"] += excluded
            if proper_adhesion:
                stats["dense_operand_pairs_derived_by_normal_form"] += dense_derived
            enumerated = 0
            for first_ids, second_ids, same in blocks:
                for position, i in enumerate(first_ids):
                    first = signatures[i]
                    partners = (
                        itertools.islice(second_ids, position + 1)
                        if same
                        else second_ids
                    )
                    for j in partners:
                        enumerated += 1
                        second = signatures[j]
                        for permutation in relative_orders(colors[i], colors[j]):
                            inverse = {old: new for new, old in enumerate(permutation)}
                            right_edges = {
                                tuple(sorted((inverse[a], inverse[b])))
                                for a, b in second.edges
                            }
                            if set(first.edges) & right_edges:
                                continue
                            mapping = permutation_map(size, permutation)
                            target = table[markers[i]][mapping[markers[j]]]
                            if target < 0:
                                continue
                            stats["admissible_relative_join_orders"] += 1
                            count = target_count(
                                sparse[i], grouped[j], inverse, mapping, target, types, table
                            )
                            assert count >= 1
                            if count > 1:
                                stats["nonunique_join_markers"] += 1
                                continue
                            right = scalar_relabel(second, permutation)
                            value = scalar_join(first, right)
                            assert value.counts[target] == 1
                            assert covered(
                                value.degrees, value.edges, target, algebra.support(value)
                            ), ("uncovered relative join", i, j, permutation, target)
                            stats["unique_join_pointed_outputs"] += 1
            assert enumerated + excluded + closed_pairs + dense_derived == all_nonboundary_pairs
            stats["degree_sum_eligible_operand_pairs"] += enumerated
            print(
                json.dumps(
                    {"checked_boundary_size": size, "active_states": len(ids)}
                ),
                flush=True,
            )

    unary_closed = not reconstruction_only or (first_unary_gap and gap is None)
    pathwidth_exclusion = unary_closed and not accepting
    return {
        "classification": (
            (
                "finite_proper_adhesion_operation_closed_separating_certificate"
                if proper_adhesion else "finite_operation_closed_separating_certificate"
            )
            if not reconstruction_only
            else (
                "finite_unary_operation_closed_separating_certificate"
                if pathwidth_exclusion
                else "exact_reachable_pointed_support_reconstruction"
            )
        ),
        "claim": (
            "C3167-PW5" if reconstruction_only and pathwidth_exclusion
            else "C3167-TW5"
        ),
        "certificate": str(path),
        "boundary_limit": 6,
        "routing_types_at_six_terminals": len(algebra.catalog(6)[0]),
        "dominance": data.get("dominance"),
        "saturated": data["saturated"],
        "active_states": sum(map(len, active.values())),
        "active_by_boundary_size": {
            size: len(ids) for size, ids in sorted(active.items())
        },
        "counts": dict(stats),
        "empty_boundary_accepting_rows": accepting,
        "terminal_candidate_rows": terminal_candidates,
        "first_uncovered_unary_successor": gap,
        "all_unary_operations_checked": unary_closed,
        "closed_routings": "All live closed types retained",
        "arbitrary_join_closure_checked": not reconstruction_only and not proper_adhesion,
        "proper_adhesion_join_closure_checked": not reconstruction_only and proper_adhesion,
        "arbitrary_join_coverage_derived_by_normal_form": (
            not reconstruction_only and proper_adhesion
        ),
        "normal_form_proof": (
            "research/treewidth_five/normal_forms.md" if proper_adhesion else None
        ),
        "all_orders_quartic_pathwidth_five_exclusion": pathwidth_exclusion,
        "all_orders_quartic_treewidth_five_exclusion": not reconstruction_only,
        "independent_host_review": "required_not_performed",
        "novelty_status": "not_verified",
        "significance_status": "not_established",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", type=Path)
    parser.add_argument("--reconstruction-only", action="store_true")
    parser.add_argument("--first-unary-gap", action="store_true")
    parser.add_argument(
        "--proper-adhesion", action="store_true",
        help="Check all zero-underlying-degree joins; arbitrary joins follow from normal_forms.md",
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.first_unary_gap and not args.reconstruction_only:
        parser.error("--first-unary-gap requires --reconstruction-only")
    start = time.monotonic()
    result = check(
        args.certificate, args.reconstruction_only, args.first_unary_gap,
        args.proper_adhesion,
    )
    result["elapsed_seconds"] = round(time.monotonic() - start, 6)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result), flush=True)


if __name__ == "__main__":
    main()
