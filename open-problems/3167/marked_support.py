"""Exact pointed-support search; only a verified fixed point certifies closure."""

import argparse
import itertools
import json
import time
from collections import Counter
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

import full_signatures as full
from routing_signatures import Routing


def bits(mask):
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask ^= bit


@lru_cache(maxsize=None)
def live_mask(degrees):
    states, _ = full.catalog(len(degrees))
    return sum(
        1 << i
        for i, state in enumerate(states)
        if all(h <= g and g - h <= 2 for g, h in zip(degrees, state.degrees))
    )


@dataclass(frozen=True)
class Pointed:
    degrees: tuple
    edges: tuple
    marker: int
    support: int

    @property
    def size(self):
        return len(self.degrees)

    @property
    def key(self):
        return self.degrees, self.edges, self.marker

    def encode(self):
        return {
            "degrees": self.degrees,
            "edges": self.edges,
            "marker": self.marker,
            "support": hex(self.support),
        }

    @classmethod
    def decode(cls, row):
        return cls(
            tuple(row["degrees"]),
            tuple(tuple(edge) for edge in row["edges"]),
            row["marker"],
            int(row["support"], 16),
        )


def pointed(signature):
    signature = full.project(signature)
    support = sum(1 << i for i, n in enumerate(signature.counts) if n)
    return [
        Pointed(signature.degrees, signature.edges, i, support)
        for i, n in enumerate(signature.counts)
        if n == 1
    ]


@lru_cache(maxsize=None)
def permutations(size):
    return tuple(itertools.permutations(range(size)))


@lru_cache(maxsize=None)
def routing_permutation(size, order):
    states, indices = full.catalog(size)
    inverse = {old: new for new, old in enumerate(order)}
    return tuple(
        indices[
            Routing(
                tuple(state.degrees[v] for v in order),
                tuple(
                    sorted(
                        tuple(sorted((inverse[u], inverse[v])))
                        for u, v in state.pairs
                    )
                ),
                state.closed,
            )
        ]
        for state in states
    )


def permuted(state, order):
    inverse = {old: new for new, old in enumerate(order)}
    mapping = routing_permutation(state.size, order)
    return Pointed(
        tuple(state.degrees[v] for v in order),
        tuple(
            sorted(tuple(sorted((inverse[u], inverse[v]))) for u, v in state.edges)
        ),
        mapping[state.marker],
        sum(1 << mapping[i] for i in bits(state.support)),
    )


def canonical(state):
    degree_order = tuple(sorted(state.degrees))
    best = None
    best_order = None
    for order in permutations(state.size):
        if tuple(state.degrees[v] for v in order) != degree_order:
            continue
        mapped = permuted(state, order)
        if best is None or (mapped.edges, mapped.marker, mapped.support) < (
            best.edges, best.marker, best.support
        ):
            best, best_order = mapped, order
    return best, best_order


def unary_specs(state):
    if state.size < 5:
        yield {"op": "introduce"}
    for u, v in itertools.combinations(range(state.size), 2):
        if (
            (u, v) not in state.edges
            and state.degrees[u] < 4
            and state.degrees[v] < 4
        ):
            yield {"op": "edge", "edge": [u, v]}
    for v, degree in enumerate(state.degrees):
        if degree == 4:
            yield {"op": "forget", "vertex": v}


@lru_cache(maxsize=None)
def unary_mapping(size, op, parameter):
    states, _ = full.catalog(size)
    if op == "introduce":
        _, indices = full.catalog(size + 1)
        return tuple(
            (indices[Routing(s.degrees + (0,), s.pairs, s.closed)],)
            for s in states
        )
    if op == "edge":
        _, indices = full.catalog(size)
        selected = tuple(int(i in parameter) for i in range(size))
        edge = indices[Routing(selected, (parameter,))]
        table = full.join_table(size)
        return tuple(
            (i, table[i][edge]) if table[i][edge] >= 0 else (i,)
            for i in range(len(states))
        )
    if op == "forget":
        v = parameter[0]
        _, indices = full.catalog(size - 1)
        return tuple(
            (
                indices[
                    Routing(
                        s.degrees[:v] + s.degrees[v + 1 :],
                        tuple((u - (u > v), w - (w > v)) for u, w in s.pairs),
                        s.closed,
                    )
                ],
            )
            if s.degrees[v] == 2
            else ()
            for s in states
        )
    raise ValueError(f"Unknown unary operation: {op}")


def unary(state, spec):
    op = spec["op"]
    if op == "introduce":
        degrees, edges, parameter = state.degrees + (0,), state.edges, ()
    elif op == "edge":
        u, v = spec["edge"]
        assert u < v and (u, v) not in state.edges
        assert state.degrees[u] < 4 and state.degrees[v] < 4
        degrees = tuple(g + int(i in (u, v)) for i, g in enumerate(state.degrees))
        edges, parameter = tuple(sorted(state.edges + ((u, v),))), (u, v)
    elif op == "forget":
        v = spec["vertex"]
        assert state.degrees[v] == 4
        degrees = state.degrees[:v] + state.degrees[v + 1 :]
        edges = tuple(
            (u - (u > v), w - (w > v))
            for u, w in state.edges
            if v not in (u, w)
        )
        parameter = (v,)
    else:
        raise ValueError(f"Unknown unary operation: {op}")
    mapping = unary_mapping(state.size, op, parameter)
    support = multiple = 0
    for i in bits(state.support):
        for target in mapping[i]:
            bit = 1 << target
            multiple |= support & bit
            support |= bit
    support &= live_mask(degrees)
    return [
        Pointed(degrees, edges, q, support)
        for q in mapping[state.marker]
        if support & (1 << q) and not multiple & (1 << q)
    ]


def joined(first, second):
    assert first.size == second.size
    if set(first.edges) & set(second.edges):
        return None
    degrees = tuple(a + b for a, b in zip(first.degrees, second.degrees))
    if any(g > 4 for g in degrees):
        return None
    table = full.join_table(first.size)
    marker = table[first.marker][second.marker]
    live = live_mask(degrees)
    if marker < 0 or not live & (1 << marker):
        return None
    support = 0
    marker_seen = False
    second_support = tuple(bits(second.support))
    for i in bits(first.support):
        for j in second_support:
            target = table[i][j]
            if target < 0:
                continue
            if target == marker:
                if marker_seen:
                    return None
                marker_seen = True
            support |= 1 << target
    assert marker_seen
    return Pointed(
        degrees, tuple(sorted(first.edges + second.edges)), marker, support & live
    )


@lru_cache(maxsize=None)
def position_mask(size, position, allowed):
    return sum(
        1 << p
        for p, order in enumerate(permutations(size))
        if allowed & (1 << order[position])
    )


@lru_cache(maxsize=16384)
def join_order_mask(first_key, second_key):
    g1, edges1, q1 = first_key
    g2, edges2, q2 = second_key
    size = len(g1)
    states, _ = full.catalog(size)
    h1, h2 = states[q1].degrees, states[q2].degrees
    orders = permutations(size)
    candidates = (1 << len(orders)) - 1
    for i in range(size):
        allowed = sum(
            1 << j
            for j in range(size)
            if h1[i] + h2[j] <= 2 and g1[i] - h1[i] + g2[j] - h2[j] <= 2
        )
        candidates &= position_mask(size, i, allowed)
    result = 0
    edge_set = set(edges1)
    table = full.join_table(size)
    for p in bits(candidates):
        order = orders[p]
        inverse = {old: new for new, old in enumerate(order)}
        if any(
            tuple(sorted((inverse[u], inverse[v]))) in edge_set
            for u, v in edges2
        ):
            continue
        if table[q1][routing_permutation(size, order)[q2]] >= 0:
            result |= 1 << p
    return result


def bad_kind(state):
    states, _ = full.catalog(state.size)
    routing = states[state.marker]
    if not state.degrees and routing.closed:
        return "unique_hamiltonian_cycle"
    if (
        state.degrees == (2, 2)
        and not state.edges
        and routing == Routing((1, 1), ((0, 1),))
    ):
        return "unique_terminal_path"
    return None


def full_unary(signature, spec):
    if spec["op"] == "introduce":
        return full.project(full.introduce(signature))
    if spec["op"] == "edge":
        return full.project(full.add_edge(signature, *spec["edge"]))
    if spec["op"] == "forget":
        return full.project(full.forget(signature, spec["vertex"]))
    raise ValueError(spec["op"])


def sparse_marker(signature, marker):
    return full.Signature(
        signature.degrees,
        signature.edges,
        tuple(int(i == marker) for i in range(len(signature.counts))),
    )


def expected_pointed(signature, contribution):
    return [
        state for state in pointed(signature) if contribution.counts[state.marker]
    ]


class Search:
    def __init__(self, data=None):
        self.rows = [] if data is None else data["rows"]
        self.states = [Pointed.decode(row) for row in self.rows]
        self.vertex_counts = []
        for state, row in zip(self.states, self.rows):
            self.vertex_counts.append(self.graph_order(row["construction"], state.size))
        self.buckets = {}
        self.cursor = (
            {"state": 0, "unary": 0, "other": 0, "permutation": 0}
            if data is None
            else data["cursor"]
        )
        self.operations = Counter() if data is None else Counter(data["operations"])
        self.witness = None if data is None else data["witness"]
        for i, (state, row) in enumerate(zip(self.states, self.rows)):
            if row["active"]:
                self.buckets.setdefault(state.key, []).append(i)
        if data is None:
            self.insert(pointed(full.leaf())[0], {"op": "leaf"})

    def graph_order(self, construction, size):
        op = construction["op"]
        if op == "leaf":
            return 0
        if op == "join":
            return (
                self.vertex_counts[construction["left"]]
                + self.vertex_counts[construction["right"]]
                - size
            )
        return self.vertex_counts[construction["child"]] + int(op == "introduce")

    def covering(self, state):
        return next(
            (
                i
                for i in self.buckets.get(state.key, ())
                if self.states[i].support & state.support == self.states[i].support
            ),
            None,
        )

    def insert(self, state, construction):
        state, order = canonical(state)
        if self.covering(state) is not None:
            return
        bucket = self.buckets.setdefault(state.key, [])
        kept = []
        for i in bucket:
            if state.support & self.states[i].support == state.support:
                self.rows[i]["active"] = False
            else:
                kept.append(i)
        index = len(self.rows)
        self.rows.append(
            {
                **state.encode(),
                "active": True,
                "construction": construction,
                "canonical_order": order,
            }
        )
        self.states.append(state)
        self.vertex_counts.append(self.graph_order(construction, state.size))
        self.buckets[state.key] = kept + [index]
        if bad_kind(state):
            self.witness = index

    def advance_state(self):
        self.cursor = {
            "state": self.cursor["state"] + 1,
            "unary": 0,
            "other": 0,
            "permutation": 0,
        }

    def run(self, max_states, max_joins, seconds):
        deadline = time.monotonic() + seconds
        reason = "saturated"
        while self.cursor["state"] < len(self.rows):
            if self.witness is not None:
                reason = "counterexample_candidate"
                break
            if len(self.rows) >= max_states:
                reason = "state_budget"
                break
            if self.operations["relative_join_tests"] >= max_joins:
                reason = "join_budget"
                break
            if time.monotonic() >= deadline:
                reason = "time_budget"
                break
            i = self.cursor["state"]
            if not self.rows[i]["active"]:
                self.advance_state()
                continue
            state = self.states[i]
            specs = tuple(unary_specs(state))
            if self.cursor["unary"] < len(specs):
                spec = specs[self.cursor["unary"]]
                for result in unary(state, spec):
                    self.insert(result, {**spec, "child": i})
                self.operations[spec["op"]] += 1
                self.cursor["unary"] += 1
                continue
            if self.vertex_counts[i] == state.size:
                self.operations["boundary_only_join_rows_derived"] += 1
                self.advance_state()
                continue
            j = self.cursor["other"]
            if j > i:
                self.advance_state()
                continue
            if not self.rows[j]["active"] or self.states[j].size != state.size:
                self.cursor["other"] += 1
                self.cursor["permutation"] = 0
                continue
            if self.vertex_counts[j] == state.size:
                self.operations["boundary_only_join_pairs_derived"] += 1
                self.cursor["other"] += 1
                self.cursor["permutation"] = 0
                continue
            orders = permutations(state.size)
            p = self.cursor["permutation"]
            eligible = join_order_mask(state.key, self.states[j].key)
            eligible &= ~((1 << p) - 1)
            if not eligible:
                self.cursor["other"] += 1
                self.cursor["permutation"] = 0
                continue
            p = (eligible & -eligible).bit_length() - 1
            order = orders[p]
            other = permuted(self.states[j], order)
            result = joined(state, other)
            self.operations["relative_join_tests"] += 1
            if result is not None:
                self.operations["unique_join_outputs"] += 1
                self.insert(
                    result,
                    {"op": "join", "left": i, "right": j, "right_order": order},
                )
            self.cursor["permutation"] = p + 1
        saturated = self.cursor["state"] >= len(self.rows) and self.witness is None
        return {
            "schema": "pointed-support-v1",
            "stop_reason": reason,
            "saturated": saturated,
            "all_orders_exclusion_certified": False,
            "witness": self.witness,
            "cursor": self.cursor,
            "operations": dict(self.operations),
            "rows": self.rows,
            "summary": {
                "inserted_states": len(self.rows),
                "active_states": sum(row["active"] for row in self.rows),
                "active_by_boundary_size": dict(
                    sorted(
                        Counter(
                            state.size
                            for state, row in zip(self.states, self.rows)
                            if row["active"]
                        ).items()
                    )
                ),
                "fully_visited_row_prefix": self.cursor["state"],
            },
        }


def replay(data, check_closure):
    search = Search(data)
    signatures = []
    for i, (state, row) in enumerate(zip(search.states, search.rows)):
        term = row["construction"]
        if term["op"] == "leaf":
            signature = full.leaf()
        elif term["op"] == "join":
            assert 0 <= term["left"] < i and 0 <= term["right"] < i
            signature = full.glue(
                signatures[term["left"]],
                full.relabel(signatures[term["right"]], tuple(term["right_order"])),
            )
        else:
            assert 0 <= term["child"] < i
            signature = full_unary(signatures[term["child"]], term)
        signature = full.project(full.relabel(signature, tuple(row["canonical_order"])))
        assert state in pointed(signature), (i, "incorrect support or nonunique marker")
        assert search.vertex_counts[i] >= state.size
        signatures.append(signature)
        assert search.covering(state) is not None, (i, "uncovered stored state")
    for bucket in search.buckets.values():
        for i, j in itertools.combinations(bucket, 2):
            a, b = search.states[i].support, search.states[j].support
            assert a & b not in (a, b), (i, j, "nonminimal active supports")
    assert 0 <= data["cursor"]["state"] <= len(search.rows)
    if data["saturated"]:
        assert data["cursor"]["state"] == len(search.rows)
        assert data["witness"] is None
    bad = [i for i, state in enumerate(search.states) if bad_kind(state)]
    if data["witness"] is None:
        assert not bad
    else:
        assert data["witness"] in bad
    closure_tests = derived_boundary_joins = 0
    if check_closure:
        assert data["saturated"], "Incomplete frontier cannot certify all-orders closure"
        for i, row in enumerate(search.rows):
            if not row["active"]:
                continue
            state, signature = search.states[i], signatures[i]
            for spec in unary_specs(state):
                result = full_unary(signature, spec)
                contribution = full_unary(sparse_marker(signature, state.marker), spec)
                expected = expected_pointed(result, contribution)
                assert set(unary(state, spec)) == set(expected)
                for successor in expected:
                    canonical_successor, _ = canonical(successor)
                    assert search.covering(canonical_successor) is not None
                closure_tests += 1
            for j in range(i + 1):
                if not search.rows[j]["active"] or search.states[j].size != state.size:
                    continue
                if (
                    search.vertex_counts[i] == state.size
                    or search.vertex_counts[j] == state.size
                ):
                    derived_boundary_joins += 1
                    continue
                for order in permutations(state.size):
                    other = permuted(search.states[j], order)
                    if set(state.edges) & set(other.edges) or any(
                        a + b > 4 for a, b in zip(state.degrees, other.degrees)
                    ):
                        continue
                    right = full.relabel(signatures[j], order)
                    result = full.project(full.glue(signature, right))
                    contribution = full.project(
                        full.glue(
                            sparse_marker(signature, state.marker),
                            sparse_marker(right, other.marker),
                        )
                    )
                    expected = expected_pointed(result, contribution)
                    successor = joined(state, other)
                    assert ([] if successor is None else [successor]) == expected
                    for candidate in expected:
                        canonical_candidate, _ = canonical(candidate)
                        assert search.covering(canonical_candidate) is not None
                    closure_tests += 1
        assert search.covering(canonical(pointed(full.leaf())[0])[0]) is not None
    return {
        "classification": "exact_construction_replay",
        "replayed_states": len(signatures),
        "active_states": sum(row["active"] for row in search.rows),
        "saturated": data["saturated"],
        "closure_tests": closure_tests,
        "boundary_only_join_pairs_derived_from_unary_closure": derived_boundary_joins,
        "all_orders_exclusion_certified": bool(check_closure),
        "counterexample_reconstructed": False,
        "bad_state_ids": bad,
    }


def self_test():
    signatures = []
    for b in range(5):
        possible = tuple(itertools.combinations(range(b), 2))
        for mask in range(1 << len(possible)):
            signatures.append(
                full.project(
                    full.boundary_graph(
                        b, tuple(edge for k, edge in enumerate(possible) if mask >> k & 1)
                    )
                )
            )
    star = full.boundary_term(5, tuple((v, 4) for v in range(4)))
    term = {"op": "forget", "vertex": 4, "child": star}
    signatures.append(full.project(full.evaluate(term)))
    signatures.append(full.project(full.introduce(full.evaluate(term))))
    term = {"op": "join", "left": term, "right": term}
    signatures.append(full.project(full.evaluate(term)))
    obstruction = json.loads(
        Path(__file__).with_name("reachable_invariant_obstruction.result.json").read_text()
    )
    graph = obstruction["edge_countertransition"]["output_graph"]
    signatures.append(
        full.project(
            full.enumerate_graph_signature(
                graph["boundary"], graph["vertices"], graph["edges"]
            )
        )
    )
    unary_tests = join_tests = boundary_join_tests = permutation_mask_tests = 0
    for signature in signatures:
        for state in pointed(signature):
            for spec in unary_specs(state):
                actual = set(unary(state, spec))
                result = full_unary(signature, spec)
                contribution = full_unary(sparse_marker(signature, state.marker), spec)
                assert actual == set(expected_pointed(result, contribution))
                unary_tests += 1
            canonical_state, _ = canonical(state)
            for order in permutations(state.size):
                assert canonical(permuted(state, order))[0] == canonical_state
    small = [s for s in signatures if s.boundary_size <= 3]
    for first in small:
        for second in small:
            if (
                first.boundary_size != second.boundary_size
                or set(first.edges) & set(second.edges)
                or any(a + b > 4 for a, b in zip(first.degrees, second.degrees))
            ):
                continue
            result = full.project(full.glue(first, second))
            for a in pointed(first):
                for b in pointed(second):
                    contribution = full.project(
                        full.glue(sparse_marker(first, a.marker), sparse_marker(second, b.marker))
                    )
                    expected = expected_pointed(result, contribution)
                    actual = joined(a, b)
                    assert ([] if actual is None else [actual]) == expected
                    if actual is not None:
                        descendants = {a}
                        for edge in second.edges:
                            descendants = {
                                successor
                                for current in descendants
                                for successor in unary(
                                    current, {"op": "edge", "edge": edge}
                                )
                            }
                        assert actual in descendants
                        boundary_join_tests += 1
                    expected_mask = 0
                    for p, order in enumerate(permutations(a.size)):
                        mapped = permuted(b, order)
                        g = tuple(x + y for x, y in zip(a.degrees, mapped.degrees))
                        target = full.join_table(a.size)[a.marker][mapped.marker]
                        if (
                            not set(a.edges) & set(mapped.edges)
                            and all(x <= 4 for x in g)
                            and target >= 0
                            and live_mask(g) & (1 << target)
                        ):
                            expected_mask |= 1 << p
                    assert join_order_mask(a.key, b.key) == expected_mask
                    permutation_mask_tests += 1
                    join_tests += 1
    return {
        "classification": "finite_implementation_checks_not_saturation",
        "full_signatures": len(signatures),
        "unary_marked_tests": unary_tests,
        "join_marked_tests": join_tests,
        "boundary_join_unary_composition_tests": boundary_join_tests,
        "complete_relative_permutation_mask_tests": permutation_mask_tests,
        "all_orders_exclusion_certified": False,
    }


def certificate_examples(path):
    collection = Search(json.loads(path.read_text()))
    obstruction = json.loads(
        Path(__file__).with_name("reachable_invariant_obstruction.result.json").read_text()
    )
    examples = [
        ("reachable_I6_obstruction", obstruction["edge_countertransition"]["output_graph"], None)
    ]
    terminal_data = json.loads(
        Path(__file__).with_name("verify_two_pole.result.json").read_text()
    )
    for row in terminal_data["splits_of_reviewed_eight_vertex_graph"]:
        graph = {
            "boundary": row["terminals"],
            "vertices": sorted({v for edge in row["edges"] for v in edge}),
            "edges": row["edges"],
        }
        count = row["hamiltonian_terminal_paths"]
        examples.append((f"reviewed_terminal_count_{count}", graph, count))
    result = []
    for name, graph, previous_count in examples:
        signature = full.project(
            full.enumerate_graph_signature(
                graph["boundary"], graph["vertices"], graph["edges"]
            )
        )
        marked = pointed(signature)
        for state in marked:
            assert any(
                collection.covering(permuted(state, order)) is not None
                for order in permutations(state.size)
            ), (name, state)
        types, lookup = full.catalog(signature.boundary_size)
        if previous_count is not None:
            assert signature.counts[lookup[Routing((1, 1), ((0, 1),))]] == 2
        result.append(
            {
                "example": name,
                "previously_reviewed_exact_terminal_count": previous_count,
                "unique_live_markers": len(marked),
                "all_unique_markers_covered": True,
                "nonzero_closed_entries_retained": sum(
                    q.closed and n > 0 for q, n in zip(types, signature.counts)
                ),
            }
        )
    return {
        "classification": "reachable_regression_membership_checks",
        "examples": result,
        "previous_exact_path_counts_reenumerated": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    test = commands.add_parser("self-test")
    test.add_argument("--output", type=Path, required=True)
    run = commands.add_parser("run")
    run.add_argument("--resume", type=Path)
    run.add_argument("--max-states", type=int, required=True)
    run.add_argument("--max-joins", type=int, required=True)
    run.add_argument("--seconds", type=float, required=True)
    run.add_argument("--output", type=Path, required=True)
    verify = commands.add_parser("verify")
    verify.add_argument("checkpoint", type=Path)
    verify.add_argument("--closure", action="store_true")
    verify.add_argument("--output", type=Path, required=True)
    examples = commands.add_parser("examples")
    examples.add_argument("certificate", type=Path)
    examples.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    start = time.monotonic()
    if args.command == "self-test":
        result = self_test()
    elif args.command == "verify":
        result = replay(json.loads(args.checkpoint.read_text()), args.closure)
    elif args.command == "examples":
        result = certificate_examples(args.certificate)
    else:
        if min(args.max_states, args.max_joins, args.seconds) <= 0:
            parser.error("All budgets must be positive")
        previous = json.loads(args.resume.read_text()) if args.resume else None
        result = Search(previous).run(args.max_states, args.max_joins, args.seconds)
    result["elapsed_seconds"] = round(time.monotonic() - start, 6)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({key: value for key, value in result.items() if key != "rows"}))


if __name__ == "__main__":
    main()
