#!/usr/bin/env python3
"""Exact replays for report.md; finite tests do not prove its general theorem."""

from collections import defaultdict, deque
from dataclasses import dataclass
from fractions import Fraction as Q
from hashlib import sha256
from itertools import combinations, product
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def clean(vector):
    return {key: Q(value) for key, value in vector.items() if value}


def combine(*terms):
    result = defaultdict(Q)
    for scale, vector in terms:
        for key, value in vector.items():
            result[key] += scale * value
    return clean(result)


@dataclass(frozen=True)
class Edge:
    tail: str
    head: str
    length: int
    walk: tuple = ()


def boundary(edges, vector):
    result = defaultdict(Q)
    for key, value in vector.items():
        edge = edges[key]
        result[edge.tail] -= value
        result[edge.head] += value
    return clean(result)


def norm(edges, vector):
    return sum((edges[key].length * abs(value) for key, value in vector.items()), Q())


def projection(edges, vector):
    result = defaultdict(Q)
    for key, value in vector.items():
        for physical, sign in edges[key].walk:
            result[physical] += sign * value
    return clean(result)


def gradient(physical, vector):
    return sum((physical[key][3] * value for key, value in vector.items()), Q())


def walk_vector(walk):
    result = defaultdict(Q)
    for edge, sign in walk:
        require(sign in (-1, 1), "a traversal is not unit-oriented")
        result[edge] += sign
    return clean(result)


def reverse(walk):
    return [(edge, -sign) for edge, sign in reversed(walk)]


def raw(edges, physical, walk):
    return sum(
        (physical[key][2] for edge, _ in walk for key, _ in edges[edge].walk), 0
    )


def full_length(edges, walk):
    return sum(edges[key].length for key, _ in walk)


def check_maps(edges, images, physical):
    for key, edge in edges.items():
        require(edge.length >= 1, f"nonpositive construction length: {key}")
        current = images[edge.tail]
        mapped_length = 0
        for actual, sign in edge.walk:
            require(actual in physical, f"dead or missing mapped edge: {actual}")
            require(sign in (-1, 1), "invalid reference orientation")
            tail, head, length, _ = physical[actual]
            if sign == -1:
                tail, head = head, tail
            require(current == tail, f"discontinuous expansion: {key}")
            current = head
            mapped_length += length
        require(current == images[edge.head], f"wrong endpoint image: {key}")
        require(mapped_length <= edge.length, f"length domination fails: {key}")


def forest_path(edges, start, end):
    if start == end:
        return []
    adjacency = defaultdict(list)
    for key, edge in edges.items():
        adjacency[edge.tail].append((edge.head, key, 1))
        adjacency[edge.head].append((edge.tail, key, -1))
    predecessor = {start: None}
    queue = deque([start])
    while queue and end not in predecessor:
        vertex = queue.popleft()
        for other, key, sign in adjacency[vertex]:
            if other not in predecessor:
                predecessor[other] = (vertex, key, sign)
                queue.append(other)
    if end not in predecessor:
        return None
    answer = []
    vertex = end
    while vertex != start:
        vertex, key, sign = predecessor[vertex]
        answer.append((key, sign))
    return list(reversed(answer))


def is_forest(edges):
    parent = {}

    def find(vertex):
        parent.setdefault(vertex, vertex)
        while parent[vertex] != vertex:
            vertex = parent[vertex]
        return vertex

    for edge in edges.values():
        left, right = find(edge.tail), find(edge.head)
        if left == right:
            return False
        parent[left] = right
    return True


def rref(matrix):
    rows = [list(row) for row in matrix]
    pivot_columns = []
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(len(pivot_columns), len(rows)) if rows[row][column]),
            None,
        )
        if pivot is None:
            continue
        target = len(pivot_columns)
        rows[target], rows[pivot] = rows[pivot], rows[target]
        scale = rows[target][column]
        rows[target] = [value / scale for value in rows[target]]
        for row in range(len(rows)):
            if row != target:
                scale = rows[row][column]
                rows[row] = [
                    a - scale * b for a, b in zip(rows[row], rows[target])
                ]
        pivot_columns.append(column)
    return rows, pivot_columns


def check_jacobian(certificate):
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    record = json.loads((ROOT / "jacobian_output.json").read_text())
    require("error" not in record, "adapter returned an error, not evidence")
    require(record["request"]["payload"] == payload, "Jacobian source mismatch")
    require(record["server"]["version"] == certificate["jacobian"]["server_version"],
            "unexpected Jacobian version")
    require(record["protocol_version"] == certificate["jacobian"]["protocol_version"],
            "unexpected adapter protocol")
    require(record["result"]["operation_id"] == "matrix.nullspace.compute",
            "wrong exact operation")
    output = record["result"]["output"]
    require(output["matrix"] == payload["matrix"], "typed matrix mismatch")
    rational = lambda value: Q(int(value["num"]), int(value["den"]))
    matrix = [[rational(value) for value in row] for row in payload["matrix"]["entries"]]
    reduced, pivots = rref(matrix)
    free = [column for column in range(len(matrix[0])) if column not in pivots]
    basis = []
    for column in free:
        vector = [Q()] * len(matrix[0])
        vector[column] = Q(1)
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column]
        basis.append(vector)
    supplied = [[rational(value) for value in row] for row in output["basis_vectors"]]
    require(basis == supplied == [[Q(1)] * 4], "incorrect nullspace basis")
    require(output["rank"] == len(pivots) == 3, "incorrect exact rank")
    require(output["nullity"] == len(free) == 1, "incorrect nullity")
    require(output["free_columns"] == free == [3], "incorrect free columns")
    return {"rank": 3, "nullity": 1, "adapter_status": "complete"}


def check_deletion():
    images = [("e0", 1), ("e0", -1), ("e1", 1), ("e1", -1), (None, 0)]
    lengths = {"e0": 2, "e1": 3}

    def project(values):
        result = defaultdict(Q)
        for value, (edge, sign) in zip(values, images):
            if edge is not None:
                result[edge] += sign * value
        return clean(result)

    count = 0
    for values in product((Q(-1, 2), Q(), Q(1, 2)), repeat=len(images)):
        projected = project(values)
        physical_norm = sum(lengths[e] * abs(v) for e, v in projected.items())
        raw_norm = sum(
            lengths[e] * abs(v)
            for v, (e, _) in zip(values, images) if e is not None
        )
        require(physical_norm <= raw_norm, "projection increased weighted norm")
        for bits in product((False, True), repeat=2):
            live = {edge for edge, bit in zip(lengths, bits) if bit}
            clipped = [
                value if edge is None or edge in live else Q()
                for value, (edge, _) in zip(values, images)
            ]
            expected = {edge: value for edge, value in projected.items() if edge in live}
            require(project(clipped) == expected, "copy deletion does not commute")
            count += 1
    require(project([Q(), Q(1), Q(), Q(), Q()]) == {"e0": Q(-1)},
            "partial-deletion negative control was not detected")
    return {"vectors": 243, "live_masks": 4, "identities": count}


def check_hub_completion(certificate):
    physical = {"e": ("a", "b", 1, 5), "new": ("b", "a", 3, 7)}
    images = {"a0": "a", "a1": "a", "b0": "b", "b1": "b",
              "ha": "a", "hb": "b"}
    old = {
        "q0": Edge("a0", "b0", 1, (("e", 1),)),
        "q1": Edge("a1", "b1", 1, (("e", 1),)),
        "null": Edge("a0", "a1", 1),
    }
    new = {"new": Edge("hb", "ha", 3, (("new", 1),))}
    connectors = {f"h:{v}": Edge(v, "h" + images[v], 1)
                  for v in ("a0", "a1", "b0", "b1")}
    edges = old | new | connectors
    check_maps(edges, images, physical)
    count = 0
    for a, b, c in product(range(-2, 3), repeat=3):
        vector = clean({"q0": a, "q1": b, "null": c})
        nvector = clean({"new": a + b})
        divergence = boundary(old, vector)
        completion = {f"h:{v}": value for v, value in divergence.items()}
        completed = combine((1, vector), (1, nvector), (1, completion))
        require(not boundary(edges, completed), "null hub completion is unbalanced")
        require(projection(edges, completed) ==
                projection(edges, combine((1, vector), (1, nvector))),
                "null hub completion changed projection")
        require(norm(edges, completed) <= 3 * norm(old, vector) + norm(new, nvector),
                "three-times-old-plus-new norm bound failed")
        count += 1
    witness = {"q0": Q(1), "q1": Q(-1)}
    d = boundary(old, witness)
    completion = {f"h:{v}": value for v, value in d.items()}
    completed = combine((1, witness), (1, completion))
    measured = {
        "old_norm": str(norm(old, witness)),
        "connector_norm": str(norm(connectors, completion)),
        "completed_norm": str(norm(edges, completed)),
        "physical_projection": projection(old, witness),
    }
    require(measured == certificate["witnesses"]["canonical_hub_completion"],
            "sharp canonical-completion witness mismatch")
    return {"grid_cases": count, "sharp_factor": "3"}


def check_local_raw(certificate):
    physical = {
        "tail": ("a", "u", 2, 3), "head": ("v", "b", 3, -2),
        "bridge": ("a", "b", 1, 1),
        "f": ("u", "v", 4, 7), "g": ("u", "v", 5, 2),
    }
    edges = {key: Edge(tail, head, length, ((key, 1),))
             for key, (tail, head, length, _) in physical.items()}
    lf = [("tail", 1), ("f", 1), ("head", 1)]
    lg = [("tail", 1), ("g", 1), ("head", 1)]
    correction = lf + reverse(lg)
    vector = walk_vector(correction)
    require(not boundary(edges, vector), "local correction is not a circulation")
    raw_length = raw(edges, physical, correction)
    net_length = norm(edges, vector)
    numerator = abs(gradient(physical, projection(edges, vector)))
    measured = {"raw_length": raw_length, "net_length": str(net_length),
                "absolute_gradient": str(numerator), "width": 16,
                "certified_denominator": 80 * 16}
    require(measured == certificate["witnesses"]["opposite_local_traversals"],
            "raw-versus-net witness mismatch")
    require(raw_length <= 34 * 16, "local beta-width bound failed")
    require(raw_length > net_length, "opposite traversals were silently canceled")
    require(numerator / (80 * 16) <= numerator / raw_length,
            "local certified score overstates the raw score")
    return measured


def check_pure_new_cycle(certificate):
    physical = {
        "n0": ("a", "b", 2, 1),
        "n1": ("b", "c", 3, -2),
        "n2": ("c", "a", 5, 7),
    }
    edges = {key: Edge("h" + tail, "h" + head, length, ((key, 1),))
             for key, (tail, head, length, _) in physical.items()}
    images = {"ha": "a", "hb": "b", "hc": "c"}
    check_maps(edges, images, physical)
    vector = {key: Q(1) for key in edges}
    require(not boundary(edges, vector), "pure-new child cycle is unbalanced")
    measured = {"old_norm": "0", "new_norm": str(norm(edges, vector)),
                "connector_norm": "0",
                "completed_norm": str(norm(edges, vector)),
                "absolute_gradient": str(abs(gradient(physical, projection(edges, vector))))}
    require(measured == certificate["witnesses"]["pure_new_cycle"],
            "pure-new-cycle witness mismatch")
    return measured


def check_frozen_hole(certificate):
    frozen_physical = {
        "e0": ("u", "v", 2, 2), "e1": ("v", "w", 3, 3),
        "e2": ("w", "u", 5, 5),
        "new_vw": ("v", "w", 3, 7), "new_vu": ("v", "u", 4, 11),
    }
    current_physical = {e: data for e, data in frozen_physical.items() if e != "e1"}
    physical_graph = {e: Edge(t, h, length) for e, (t, h, length, _) in current_physical.items()}
    images = {f"x_{v}": v for v in ("u", "v", "w")}
    images.update({f"t_{v}": v for v in ("u", "v", "w")})
    images.update({f"r_{v}": v for v in ("u", "v", "w")})
    images["top_w"] = "w"
    tree = {f"out_{v}": Edge(f"x_{v}", f"t_{v}", 1) for v in ("u", "v", "w")}
    tree.update({
        "t0": Edge("t_u", "t_v", 2, (("e0", 1),)),
        "t1": Edge("t_v", "t_w", 3, (("e1", 1),)),
        "in": Edge("t_w", "top_w", 1),
    })
    chords = {
        "f0": Edge("x_u", "x_v", 2, (("e0", 1),)),
        "f2": Edge("x_w", "x_u", 5, (("e2", 1),)),
    }
    raw_forest = {
        "r0": Edge("r_u", "r_v", 2, (("e0", 1),)),
        "r1": Edge("r_v", "r_w", 3, (("e1", 1),)),
    }
    frozen = tree | chords
    cycles = {
        key: [(key, 1)] + forest_path(tree, edge.head, edge.tail)
        for key, edge in chords.items()
    }
    require([full_length(frozen, cycles[e]) for e in ("f0", "f2")] == [6, 12],
            "wrong frozen fundamental-cycle lengths")
    live_tree = {e: data for e, data in tree.items() if e != "t1"}
    live_raw = {"r0": raw_forest["r0"]}
    live_parent = live_tree | chords
    clip_cycles = {
        key: [(e, sign) for e, sign in walk if e in live_parent]
        for key, walk in cycles.items()
    }
    lf0 = forest_path(live_tree, "t_v", "x_u") + [("f0", 1)] + \
        forest_path(live_tree, "x_v", "t_v")
    lf2 = forest_path(live_tree, "t_w", "x_w") + [("f2", 1)] + \
        forest_path(live_tree, "x_u", "t_v")
    correction_walks = {"f0": lf0, "f2": lf2 + reverse(lf2)}
    correction_vectors = {e: walk_vector(walk) for e, walk in correction_walks.items()}
    remainders = {
        e: combine((1, walk_vector(clip_cycles[e])), (-1, correction_vectors[e]))
        for e in chords
    }
    require(remainders["f0"] == {} and remainders["f2"] == walk_vector(lf2),
            "clipped correction remainder has the wrong sign")
    for edge in chords:
        require(not boundary(live_parent, correction_vectors[edge]),
                "local correction lost conservation after a hole")
        width = 8 if edge == "f0" else 16
        require(raw(live_parent, current_physical, correction_walks[edge]) <= 34 * width,
                "local raw length exceeds beta W")
    child = live_tree | {"f2": chords["f2"]} | live_raw
    copied_vertices = list(images)
    for vertex in ("u", "v", "w"):
        images[f"hub_{vertex}"] = vertex
    for vertex in copied_vertices:
        child[f"hub:{vertex}"] = Edge(vertex, f"hub_{images[vertex]}", 1)
    child["new_vw"] = Edge("hub_v", "hub_w", 3, (("new_vw", 1),))
    child["new_vu"] = Edge("hub_v", "hub_u", 4, (("new_vu", 1),))
    check_maps(child, images, current_physical)
    routes = {"u": {"r0": Q(1), "r1": Q(1)}, "v": {"r1": Q(1)}, "w": {}}
    count = 0
    examples = {}
    for values in product(range(-2, 3), repeat=4):
        delta = clean(dict(zip(("e0", "e2", "new_vw", "new_vu"), values)))
        if boundary(physical_graph, delta):
            continue
        surviving = {e: v for e, v in delta.items() if e in ("e0", "e2")}
        new = {e: v for e, v in delta.items() if e.startswith("new")}
        alpha = {"f0": delta.get("e0", Q()), "f2": delta.get("e2", Q())}
        z = combine(*[(value, routes[vertex])
                      for vertex, value in boundary(physical_graph, surviving).items()])
        z_live = {e: value for e, value in z.items() if e in live_raw}
        frozen_sum = combine(*[(alpha[e], projection(frozen, walk_vector(cycles[e])))
                               for e in chords])
        require(frozen_sum == combine((1, surviving), (1, projection(raw_forest, z))),
                "fixed-marginal frozen identity failed")
        clipped_sum = combine(*[(alpha[e], projection(live_parent, walk_vector(clip_cycles[e])))
                                for e in chords])
        require(combine((1, clipped_sum), (-1, projection(live_raw, z_live))) == surviving,
                "clipped identity lost a deleted or oppositely traversed coordinate")
        x = sum(current_physical[e][2] * abs(v) for e, v in surviving.items())
        y = sum(current_physical[e][2] * abs(v) for e, v in new.items())
        require(sum(abs(alpha[e]) * full_length(frozen, cycles[e]) for e in chords) <= 3 * x,
                "frozen coefficient bound failed")
        require(norm(raw_forest, z) <= 3 * x, "raw residual bound failed")
        old_vector = combine(*[(alpha[e], remainders[e]) for e in chords], (-1, z_live))
        local = combine(*[(alpha[e], projection(live_parent, correction_vectors[e]))
                          for e in chords])
        require(projection(child, combine((1, old_vector), (1, new))) ==
                combine((1, delta), (-1, local)),
                "child construction has the wrong physical projection")
        divergence = boundary(child, old_vector)
        completion = {f"hub:{vertex}": value for vertex, value in divergence.items()}
        xi = combine((1, old_vector), (1, new), (1, completion))
        require(not boundary(child, xi), "completed child vector is not conserved")
        qnorm = norm(child, old_vector)
        xinorm = norm(child, xi)
        require(qnorm <= (2 * 34 + 1) * 3 * x, "old child norm bound failed")
        require(xinorm <= 3 * qnorm + y, "new edges were incorrectly tripled or unbalanced")
        numerator = abs(gradient(current_physical, delta))
        child_numerator = abs(gradient(current_physical, projection(child, xi)))
        child_score = child_numerator / xinorm if xinorm else Q()
        require(numerator <= ((6 * 34 + 3) * 3 * x + y) * child_score,
                "strengthened transfer inequality failed")
        count += 1
        if values in ((1, 1, 1, 0), (1, 0, 0, 1)):
            name = "deleted_residual" if values[1] else "surviving_residual"
            examples[name] = {
                "z": {e: str(v) for e, v in z.items()},
                "z_live": {e: str(v) for e, v in z_live.items()},
                "old_child_norm": str(qnorm), "new_norm": str(y),
                "completed_child_norm": str(xinorm),
                "absolute_gradient": str(numerator),
            }
    require(examples == certificate["witnesses"]["frozen_hole"],
            "exact frozen-hole witness mismatch")
    return {"circulations": count, "examples": examples}


def check_compression(edges, vector, terminals, physical):
    require(is_forest(edges), "compression input is not a forest")
    require(set(boundary(edges, vector)) <= terminals, "divergence outside terminals")
    adjacency = defaultdict(set)
    for key, edge in edges.items():
        adjacency[edge.tail].add(key)
        adjacency[edge.head].add(key)
    remaining = set(edges)
    queue = deque(v for v in adjacency if len(adjacency[v]) <= 1 and v not in terminals)
    while queue:
        vertex = queue.popleft()
        if vertex in terminals or len(adjacency[vertex]) != 1:
            continue
        key = next(iter(adjacency[vertex]))
        require(not vector.get(key, Q()), "nonzero flow outside terminal Steiner subtree")
        edge = edges[key]
        other = edge.head if edge.tail == vertex else edge.tail
        adjacency[vertex].remove(key)
        adjacency[other].remove(key)
        remaining.remove(key)
        if len(adjacency[other]) <= 1 and other not in terminals:
            queue.append(other)
    retained = terminals | {v for v in adjacency if len(adjacency[v]) != 2}
    visited = set()
    compressed_norm = Q()
    compressed_gradient = Q()
    for start in sorted(retained):
        for first in sorted(adjacency[start]):
            if first in visited:
                continue
            vertex, key = start, first
            segment = []
            while True:
                edge = edges[key]
                sign = 1 if edge.tail == vertex else -1
                segment.append((key, sign))
                visited.add(key)
                vertex = edge.head if sign == 1 else edge.tail
                if vertex in retained:
                    break
                key = next(e for e in adjacency[vertex] if e != key)
            coefficient = vector.get(segment[0][0], Q()) * segment[0][1]
            require(all(vector.get(e, Q()) * sign == coefficient for e, sign in segment),
                    "suppressed segment has nonconstant oriented coefficient")
            compressed_norm += abs(coefficient) * full_length(edges, segment)
            compressed_gradient += coefficient * gradient(
                physical, projection(edges, walk_vector(segment))
            )
    require(visited == remaining, "compression omitted a represented edge")
    require(compressed_norm == norm(edges, vector), "compression changed length norm")
    require(compressed_gradient == gradient(physical, projection(edges, vector)),
            "compression changed gradient")


def check_compressions():
    ends = [("0", "1"), ("1", "2"), ("2", "3"), ("3", "4"), ("2", "5"), ("5", "6")]
    physical = {f"e{i}": (u, v, i + 1, 2 * i - 3) for i, (u, v) in enumerate(ends)}
    count = 0
    for signs in product((-1, 1), repeat=6):
        edges = {}
        for i, ((u, v), sign) in enumerate(zip(ends, signs)):
            edges[f"e{i}"] = Edge(u if sign == 1 else v, v if sign == 1 else u,
                                  i + 1, ((f"e{i}", sign),))
        for a, b in product(range(-2, 3), repeat=2):
            flow = [a, a, b, b, a - b, a - b]
            vector = clean({f"e{i}": sign * value for i, (sign, value) in enumerate(zip(signs, flow))})
            check_compression(edges, vector, {"0", "4", "6"}, physical)
            count += 1
            clipped_edges = {e: data for e, data in edges.items() if e != "e1"}
            clipped_vector = {e: value for e, value in vector.items() if e != "e1"}
            check_compression(clipped_edges, clipped_vector, {"0", "1", "2", "4", "6"}, physical)
            count += 1
            if a == b:
                check_compression(edges, vector, {"0", "4"}, physical)
                count += 1
        check_compression(edges, {}, set(), physical)
        check_compression(edges, {}, {"0"}, physical)
        count += 2
    return {"exact_compressions": count, "orientations": 64}


def check_shared_arms():
    graphs = paths = canceled = 0
    for n in range(2, 6):
        pairs = list(combinations(range(n), 2))
        forests = []
        for bits in product((False, True), repeat=len(pairs)):
            edges = {f"f{k}": Edge(str(i), str(j), 1)
                     for k, ((i, j), bit) in enumerate(zip(pairs, bits)) if bit}
            if is_forest(edges):
                forests.append(edges)
        for closed in (False, True):
            physical = {"p0": ("a", "b", 2, 3),
                        "p1": ("b", "a" if closed else "c", 3, -1)}
            slot_image = ("a", "a" if closed else "c")
            for labels in product((0, 1), repeat=n):
                arms, images = {}, {}
                for slot in list(range(n)) + ["d0", "d1"]:
                    label = labels[slot] if isinstance(slot, int) else int(slot[1])
                    center = f"c:{slot}"
                    images[center] = slot_image[label]
                    current, here = center, slot_image[label]
                    steps = [(None, 0, 1), ("p0", 1, 2), ("p1", 1, 3)]
                    if label:
                        steps = [(p, -sign, length) for p, sign, length in reversed(steps)]
                    for step, (p, sign, length) in enumerate(steps):
                        other = f"arm:{slot}:{step}"
                        if p is not None:
                            tail, head, _, _ = physical[p]
                            require(here == (tail if sign == 1 else head),
                                    "invalid outward arm orientation")
                            here = head if sign == 1 else tail
                        images[other] = here
                        arms[f"a:{slot}:{step}"] = Edge(
                            current, other, length, () if p is None else ((p, sign),)
                        )
                        current = other
                for topology in forests:
                    public, child = dict(arms), {}
                    for key, edge in topology.items():
                        i, j = int(edge.tail), int(edge.head)
                        if labels[i] == labels[j]:
                            public[key] = Edge(f"c:{i}", f"c:{j}", 1)
                            child[key] = Edge(str(i), str(j), 0)
                        else:
                            q, z = (i, j) if labels[i] == 0 else (j, i)
                            public[key] = Edge(f"arm:{q}:2", f"c:{z}", 1)
                            mapped = (("p0", 1), ("p1", 1))
                            if labels[i]:
                                mapped = tuple(reverse(mapped))
                            child[key] = Edge(str(i), str(j), 6, mapped)
                    require(is_forest(public), "shared-arm construction introduced a cycle")
                    check_maps(public, images, physical)
                    graphs += 1
                    for start, end in product(range(n), repeat=2):
                        if start == end:
                            continue
                        child_path = forest_path(child, str(start), str(end))
                        if child_path is None:
                            continue
                        parent_path = forest_path(public, f"c:{start}", f"c:{end}")
                        require(parent_path is not None, "lift disconnected child endpoints")
                        child_projection = projection(child, walk_vector(child_path))
                        parent_projection = projection(public, walk_vector(parent_path))
                        require(parent_projection == child_projection, "shared-arm projection changed")
                        child_raw = full_length(child, child_path)
                        parent_raw = raw(public, physical, parent_path)
                        require(parent_raw <= child_raw, "shared-arm lift increased raw length")
                        require(gradient(physical, parent_projection) ==
                                gradient(physical, child_projection), "lift changed signed gradient")
                        if child_raw > 0 and not parent_projection and parent_raw == 0:
                            canceled += 1
                        paths += 1
    require(canceled > 0, "no genuine shared-arm cancellation was exercised")
    return {"public_forests": graphs, "oriented_paths": paths,
            "positive_child_zero_parent_paths": canceled, "max_child_vertices": 5}


def check_lean():
    record = json.loads((ROOT / "lean_check.json").read_text())
    require(record["status"] == "success" and record["exit_code"] == 0,
            "Lean has not successfully checked the source")
    require(record["proof_holes"] == [], "Lean proof has holes")
    require(record["source_sha256"] == sha256((ROOT / "Main.lean").read_bytes()).hexdigest(),
            "Lean source changed after compilation")
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    require(record["statement_fidelity_sha256"] == sha256(fidelity.encode()).hexdigest(),
            "statement fidelity changed after compilation")
    require("version 4.31.0" in record["tools"]["lean"]["version"], "wrong Lean version")
    ledger_record = json.loads((ROOT / "lean_verification.json").read_text())
    mechanical = ledger_record["kernel"]["recorded"]
    require(mechanical["verdict"] == "supports", "compiler support was not recorded")
    archived = json.loads((ROOT / "certificates" / Path(mechanical["artifact"]).name).read_text())
    require(archived["lean_source"]["text"] == (ROOT / "Main.lean").read_text(),
            "archived Lean source is not current")
    require(archived["statement_fidelity"]["text"] == fidelity,
            "archived statement fidelity is not current")
    return {"version": "4.31.0", "exit_code": 0, "proof_holes": [],
            "claim": "C_RAW_ALGEBRA", "statement_fidelity_independently_reviewed": False}


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["claim"] == "C_RAW_TRANSFER", "wrong theorem certificate")
    require(certificate["refuted_manuscript_assertions"] == [],
            "this certificate does not establish a manuscript refutation")
    results = {
        "jacobian": check_jacobian(certificate),
        "deletion": check_deletion(),
        "hub_completion": check_hub_completion(certificate),
        "local_raw": check_local_raw(certificate),
        "pure_new_cycle": check_pure_new_cycle(certificate),
        "frozen_hole": check_frozen_hole(certificate),
        "compression": check_compressions(),
        "shared_arms": check_shared_arms(),
        "lean_algebraic_core": check_lean(),
    }
    print(json.dumps({"ok": True, "claim": certificate["claim"],
                      "universal_proof": "report.md and the delimited Lean algebraic core",
                      "independent_review": "outstanding", "results": results}, indent=2))


if __name__ == "__main__":
    main()
