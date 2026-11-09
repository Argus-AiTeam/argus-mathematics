#!/usr/bin/env python3
"""Exact finite verifier for candidate 3110.

The checker uses only integer/set arithmetic from the Python standard library.
It validates the explicit graph and mask, checks exact two-stage external
connectivity, and checks two independent capacity obstructions for the
four-stage routing claim.  It can also emit the full typed payload used by the
Jacobian minimum-cut operation.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict, deque
from pathlib import Path
from typing import Any


class CheckFailure(RuntimeError):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise CheckFailure(message)


def load_json_object(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    require(isinstance(value, dict), f"{path} must contain one JSON object")
    return value


def exact_length_pairs(
    vertices: tuple[str, ...], edges: set[tuple[str, str]], length: int
) -> set[tuple[str, str]]:
    adjacency: dict[str, list[str]] = {vertex: [] for vertex in vertices}
    for source, target in sorted(edges):
        adjacency[source].append(target)
    pairs = {(vertex, vertex) for vertex in vertices}
    for _ in range(length):
        pairs = {
            (start, target)
            for start, middle in pairs
            for target in adjacency[middle]
        }
    return pairs


def enumerate_xy_paths(
    x_vertices: set[str],
    y_vertices: set[str],
    edges: set[tuple[str, str]],
    length: int,
) -> tuple[int, int]:
    adjacency: dict[str, list[str]] = defaultdict(list)
    for source, target in sorted(edges):
        adjacency[source].append(target)

    total_xy_paths = 0
    xy_paths_without_crossing = 0

    def visit(vertex: str, remaining: int, crossed: bool) -> None:
        nonlocal total_xy_paths, xy_paths_without_crossing
        if remaining == 0:
            if vertex in y_vertices:
                total_xy_paths += 1
                if not crossed:
                    xy_paths_without_crossing += 1
            return
        for target in adjacency[vertex]:
            visit(
                target,
                remaining - 1,
                crossed or (vertex in x_vertices and target in y_vertices),
            )

    for source in sorted(x_vertices):
        visit(source, length, False)
    return total_xy_paths, xy_paths_without_crossing


def build_flow_payload(
    vertex_order: tuple[str, ...],
    edges: set[tuple[str, str]],
    x_vertices: tuple[str, ...],
    y_vertices: tuple[str, ...],
    stages: int,
    degree: int,
) -> dict[str, Any]:
    base_index = {vertex: index for index, vertex in enumerate(vertex_order)}
    width = len(vertex_order)

    def layered(layer: int, vertex: str) -> int:
        return layer * width + base_index[vertex]

    super_source = (stages + 1) * width
    super_sink = super_source + 1
    capacity_one = {"num": "1", "den": "1"}
    capacity_degree = {"num": str(degree), "den": "1"}
    flow_edges: list[dict[str, Any]] = []

    for stage in range(stages):
        for source, target in sorted(edges):
            flow_edges.append(
                {
                    "source": layered(stage, source),
                    "target": layered(stage + 1, target),
                    "capacity": capacity_one,
                }
            )
    for vertex in x_vertices:
        flow_edges.append(
            {
                "source": super_source,
                "target": layered(0, vertex),
                "capacity": capacity_degree,
            }
        )
    for vertex in y_vertices:
        flow_edges.append(
            {
                "source": layered(stages, vertex),
                "target": super_sink,
                "capacity": capacity_degree,
            }
        )

    return {
        "graph": {
            "vertex_count": super_sink + 1,
            "edges": flow_edges,
        },
        "source": super_source,
        "sink": super_sink,
    }


def integer_max_flow(payload: dict[str, Any]) -> tuple[int, set[int], int]:
    graph = payload["graph"]
    vertex_count = graph["vertex_count"]
    source = payload["source"]
    sink = payload["sink"]
    residual: list[dict[int, int]] = [defaultdict(int) for _ in range(vertex_count)]
    original_edges: list[tuple[int, int, int]] = []

    for edge in graph["edges"]:
        u = edge["source"]
        v = edge["target"]
        numerator = int(edge["capacity"]["num"])
        denominator = int(edge["capacity"]["den"])
        require(denominator == 1 and numerator >= 0, "flow capacities must be integers")
        residual[u][v] += numerator
        residual[v].setdefault(u, 0)
        original_edges.append((u, v, numerator))

    flow_value = 0
    while True:
        parent = {source: -1}
        queue = deque([source])
        while queue and sink not in parent:
            u = queue.popleft()
            for v in sorted(residual[u]):
                if residual[u][v] > 0 and v not in parent:
                    parent[v] = u
                    queue.append(v)
        if sink not in parent:
            break
        increment: int | None = None
        v = sink
        while v != source:
            u = parent[v]
            increment = residual[u][v] if increment is None else min(increment, residual[u][v])
            v = u
        require(increment is not None and increment > 0, "invalid augmenting path")
        v = sink
        while v != source:
            u = parent[v]
            residual[u][v] -= increment
            residual[v][u] += increment
            v = u
        flow_value += increment

    reachable = {source}
    queue = deque([source])
    while queue:
        u = queue.popleft()
        for v in sorted(residual[u]):
            if residual[u][v] > 0 and v not in reachable:
                reachable.add(v)
                queue.append(v)
    cut_value = sum(
        capacity
        for u, v, capacity in original_edges
        if u in reachable and v not in reachable
    )
    require(flow_value == cut_value, "integer max-flow/min-cut equality failed")
    return flow_value, reachable, cut_value


def check_jacobian_output(
    output_path: Path,
    expected_payload: dict[str, Any],
    expected_cut_value: int,
) -> list[str]:
    record = load_json_object(output_path)
    require(record.get("protocol_version") == "2025-11-25", "unexpected Jacobian MCP protocol")
    server = record.get("server")
    require(isinstance(server, dict), "Jacobian server metadata is missing")
    require(server.get("name") == "jacobian", "unexpected Jacobian server name")
    require(server.get("version") == "0.14.0", "unexpected Jacobian server version")
    request = record.get("request")
    require(isinstance(request, dict), "Jacobian request is missing")
    require(
        request.get("operation_id") == "graph.cut.minimum_st.compute",
        "unexpected Jacobian operation",
    )
    require(request.get("payload") == expected_payload, "Jacobian echoed payload differs")
    result = record.get("result")
    require(isinstance(result, dict), "Jacobian result is missing")
    require(
        result.get("operation_id") == "graph.cut.minimum_st.compute",
        "Jacobian result operation differs",
    )
    output = result.get("output")
    require(isinstance(output, dict), "Jacobian typed output is missing")
    cut_value_object = output.get("cut_value")
    require(isinstance(cut_value_object, dict), "Jacobian cut value is missing")
    require(cut_value_object.get("den") == "1", "Jacobian cut value is not integral")
    reported_cut = int(cut_value_object.get("num"))
    require(reported_cut == expected_cut_value, "Jacobian cut differs from local exact cut")

    vertex_count = expected_payload["graph"]["vertex_count"]
    reachable = set(output.get("reachable", ()))
    unreachable = set(output.get("unreachable", ()))
    all_vertices = set(range(vertex_count))
    require(reachable.isdisjoint(unreachable), "Jacobian cut sides overlap")
    require(reachable | unreachable == all_vertices, "Jacobian cut does not partition vertices")
    require(expected_payload["source"] in reachable, "Jacobian source is on wrong cut side")
    require(expected_payload["sink"] in unreachable, "Jacobian sink is on wrong cut side")

    recomputed_cut = 0
    for edge in expected_payload["graph"]["edges"]:
        if edge["source"] in reachable and edge["target"] in unreachable:
            require(edge["capacity"]["den"] == "1", "nonintegral cut edge")
            recomputed_cut += int(edge["capacity"]["num"])
    require(recomputed_cut == reported_cut, "Jacobian cut partition has wrong capacity")
    return [
        "jacobian_mcp_checked=true",
        f"jacobian_server_version={server['version']}",
        f"jacobian_protocol_version={record['protocol_version']}",
        "jacobian_operation=graph.cut.minimum_st.compute",
        f"jacobian_cut_value={reported_cut}",
        f"jacobian_cut_partition={len(reachable)}+{len(unreachable)}",
    ]


def check(
    witness_path: Path,
    payload_output: Path | None,
    jacobian_output: Path | None,
) -> list[str]:
    raw = witness_path.read_bytes()
    witness = load_json_object(witness_path)
    require(witness.get("candidate_id") == 3110, "candidate_id must be 3110")

    parameters = witness.get("parameters")
    require(isinstance(parameters, dict), "parameters must be an object")
    n = parameters.get("N")
    m = parameters.get("m")
    degree = parameters.get("degree")
    stages = parameters.get("rearrangeability_stage_count")
    require((n, m, degree, stages) == (5, 2, 5, 4), "expected N=5, m=2, degree=5, stages=4")

    expected_x = tuple(f"x{i}" for i in range(n))
    expected_y = tuple(f"y{i}" for i in range(n))
    expected_vertices = expected_x + expected_y
    vertex_order = tuple(witness.get("vertex_order", ()))
    require(vertex_order == expected_vertices, "unexpected vertex_order")
    require(len(set(vertex_order)) == len(vertex_order), "vertices must be distinct")

    classes = witness.get("classes")
    require(isinstance(classes, dict), "classes must be an object")
    x_vertices = tuple(classes.get("X", ()))
    y_vertices = tuple(classes.get("Y", ()))
    require(x_vertices == expected_x and y_vertices == expected_y, "unexpected X/Y classes")
    require(set(x_vertices).isdisjoint(y_vertices), "X and Y must be disjoint")
    require(set(x_vertices) | set(y_vertices) == set(vertex_order), "X and Y must partition V")

    edge_rows = witness.get("edges")
    require(isinstance(edge_rows, list), "edges must be a list")
    require(all(isinstance(edge, list) and len(edge) == 2 for edge in edge_rows), "each edge must be a pair")
    edge_list = [(edge[0], edge[1]) for edge in edge_rows]
    require(all(u in vertex_order and v in vertex_order for u, v in edge_list), "edge endpoint outside V")
    edges = set(edge_list)
    require(len(edges) == len(edge_list), "parallel base edges violate simplicity")

    expected_edges = {("x0", target) for target in expected_y}
    expected_edges |= {
        (source, target)
        for source in expected_x[1:]
        for target in expected_x
    }
    expected_edges |= {("y0", target) for target in expected_x}
    expected_edges |= {
        (source, target)
        for source in expected_y[1:]
        for target in expected_y
    }
    require(edges == expected_edges, "edge list does not equal the explicit L_5 construction")

    outdegree = Counter(source for source, _ in edges)
    indegree = Counter(target for _, target in edges)
    require(all(outdegree[v] == degree for v in vertex_order), "outdegree is not uniformly 5")
    require(all(indegree[v] == degree for v in vertex_order), "indegree is not uniformly 5")

    one_stage = exact_length_pairs(vertex_order, edges, 1)
    two_stage = exact_length_pairs(vertex_order, edges, m)
    all_pairs = {(source, target) for source in vertex_order for target in vertex_order}
    require(one_stage != all_pairs, "L unexpectedly externally connected in one stage")
    require(("x0", "x0") not in one_stage, "expected x0->x0 to be absent in one stage")
    require(two_stage == all_pairs, "L^2 is not externally connected")

    mask_rows = witness.get("unroutable_mask")
    require(isinstance(mask_rows, list), "unroutable_mask must be a list")
    mask: dict[tuple[str, str], int] = {}
    for row in mask_rows:
        require(isinstance(row, dict), "mask row must be an object")
        source = row.get("source")
        target = row.get("target")
        multiplicity = row.get("multiplicity")
        require(source in vertex_order and target in vertex_order, "mask endpoint outside V")
        require(isinstance(multiplicity, int) and not isinstance(multiplicity, bool) and multiplicity > 0, "mask multiplicity must be positive integer")
        require((source, target) not in mask, "duplicate mask pair")
        mask[(source, target)] = multiplicity
    expected_mask = {(expected_x[i], expected_y[i]): n for i in range(n)}
    expected_mask |= {(expected_y[i], expected_x[i]): n for i in range(n)}
    require(mask == expected_mask, "mask does not equal the explicit parallel-request mask")

    mask_outdegree = Counter()
    mask_indegree = Counter()
    for (source, target), multiplicity in mask.items():
        mask_outdegree[source] += multiplicity
        mask_indegree[target] += multiplicity
    require(all(mask_outdegree[v] == degree for v in vertex_order), "mask source degree is not uniformly 5")
    require(all(mask_indegree[v] == degree for v in vertex_order), "mask target degree is not uniformly 5")

    x_set = set(x_vertices)
    y_set = set(y_vertices)
    crossing_edges = {(u, v) for u, v in edges if u in x_set and v in y_set}
    expected_crossing = {("x0", target) for target in expected_y}
    require(crossing_edges == expected_crossing, "unexpected X-to-Y crossing edges")
    available_crossings = stages * len(crossing_edges)
    forced_xy_requests = sum(
        multiplicity
        for (source, target), multiplicity in mask.items()
        if source in x_set and target in y_set
    )
    require(available_crossings == 20, "expected exactly 20 X-to-Y edge slots in L^4")
    require(forced_xy_requests == 25, "expected exactly 25 forced X-to-Y requests")
    require(forced_xy_requests > available_crossings, "cut obstruction is not strict")

    path_count, paths_without_crossing = enumerate_xy_paths(x_set, y_set, edges, stages)
    require(path_count > 0, "expected X-to-Y paths in L^4")
    require(paths_without_crossing == 0, "an X-to-Y path avoided every X-to-Y edge")

    flow_payload = build_flow_payload(
        vertex_order, edges, x_vertices, y_vertices, stages, degree
    )
    require(flow_payload["graph"]["vertex_count"] == 52, "unexpected flow graph vertex count")
    require(len(flow_payload["graph"]["edges"]) == 210, "unexpected flow graph edge count")
    flow_value, reachable, cut_value = integer_max_flow(flow_payload)
    require(flow_value < forced_xy_requests, "aggregate network can carry all 25 requests")

    if payload_output is not None:
        payload_output.write_text(
            json.dumps(flow_payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )

    lines = [
        f"witness_sha256={hashlib.sha256(raw).hexdigest()}",
        "candidate_id=3110",
        f"vertices={len(vertex_order)}",
        f"base_edges={len(edges)}",
        "simple=true",
        "in_out_regular_degree=5",
        f"exact_length_1_reachable_pairs={len(one_stage)}/100",
        f"exact_length_2_reachable_pairs={len(two_stage)}/100",
        "L2_externally_connected=true",
        f"mask_requests_total={sum(mask.values())}",
        "mask_in_out_regular_degree=5",
        f"enumerated_X_to_Y_plain_paths_in_L4={path_count}",
        f"X_to_Y_paths_without_X_to_Y_edge={paths_without_crossing}",
        f"paper_cut_capacity={available_crossings}",
        f"forced_X_to_Y_requests={forced_xy_requests}",
        "paper_cut_strict=true",
        f"aggregate_flow_graph_vertices={flow_payload['graph']['vertex_count']}",
        f"aggregate_flow_graph_edges={len(flow_payload['graph']['edges'])}",
        f"exact_aggregate_max_flow={flow_value}",
        f"exact_aggregate_min_cut={cut_value}",
        f"min_cut_source_side_size={len(reachable)}",
        "L4_rearrangeable=false",
        "counterexample_verified=true",
    ]
    if jacobian_output is not None:
        lines.extend(check_jacobian_output(jacobian_output, flow_payload, cut_value))
    return lines


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--witness",
        type=Path,
        default=Path(__file__).with_name("witness.json"),
    )
    parser.add_argument("--emit-jacobian-payload", type=Path)
    parser.add_argument("--jacobian-output", type=Path)
    args = parser.parse_args()
    try:
        lines = check(
            args.witness,
            args.emit_jacobian_payload,
            args.jacobian_output,
        )
    except (CheckFailure, OSError, json.JSONDecodeError, KeyError, TypeError, ValueError) as exc:
        print(f"FAIL: {exc}")
        return 1
    for line in lines:
        print(line)
    print("PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
