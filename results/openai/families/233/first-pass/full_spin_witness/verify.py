#!/usr/bin/env python3
"""Replay exact finite cores; the uniform spatial theorem is proved in report.md."""

import argparse
from collections import defaultdict, deque
from fractions import Fraction
from itertools import product
import json
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def bits(mask):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask -= low


def rational(value):
    return {"num": str(value.numerator), "den": str(value.denominator)}


def read_rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(rational(result) == value, "noncanonical typed rational")
    return result


class Grid:
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.vertices = [(x, y) for y in range(height) for x in range(width)]
        self.vertex_id = {point: i for i, point in enumerate(self.vertices)}
        self.face_count = (width - 1) * (height - 1)
        self.edges = []
        self.dual = []
        self.boundary = 0
        self.adjacency = [[] for _ in self.vertices]
        self.dual_adjacency = [[] for _ in range(self.face_count + 1)]
        outside = self.face_count
        for x, y in self.vertices:
            for dx, dy in [(1, 0), (0, 1)]:
                if x + dx >= width or y + dy >= height:
                    continue
                u = self.vertex_id[x, y]
                v = self.vertex_id[x + dx, y + dy]
                edge = len(self.edges)
                self.edges.append((u, v))
                if dx:
                    a = self.face(x, y - 1) if y else outside
                    b = self.face(x, y) if y < height - 1 else outside
                else:
                    a = self.face(x - 1, y) if x else outside
                    b = self.face(x, y) if x < width - 1 else outside
                self.dual.append((a, b))
                if outside in (a, b):
                    self.boundary |= 1 << edge
                self.adjacency[u].append((v, edge))
                self.adjacency[v].append((u, edge))
                self.dual_adjacency[a].append((b, edge))
                self.dual_adjacency[b].append((a, edge))
        self.all_edges = (1 << len(self.edges)) - 1
        self.interior = self.all_edges ^ self.boundary

    def face(self, x, y):
        return y * (self.width - 1) + x

    def reach(self, source, barriers, include_outside=False):
        visited = 1 << source
        queue = deque([source])
        while queue:
            u = queue.popleft()
            for v, edge in self.dual_adjacency[u]:
                if not include_outside and v == self.face_count:
                    continue
                if barriers >> edge & 1 or visited >> v & 1:
                    continue
                visited |= 1 << v
                queue.append(v)
        return visited

    def components(self, open_w):
        labels = [-1] * self.face_count
        count = 0
        for source in range(self.face_count):
            if labels[source] != -1:
                continue
            for vertex in bits(self.reach(source, open_w)):
                labels[vertex] = count
            count += 1
        return labels, count

    def cycles(self):
        found = {}
        for start in range(len(self.vertices)):
            def visit(path, vertex_mask, edge_mask):
                last = path[-1]
                for vertex, edge in self.adjacency[last]:
                    if vertex == start:
                        if len(path) >= 4 and path[1] < path[-1]:
                            mask = edge_mask | 1 << edge
                            exterior = self.reach(
                                self.face_count, mask, include_outside=True
                            )
                            inside = ((1 << self.face_count) - 1) & ~exterior
                            require(inside != 0, "simple cycle has empty interior")
                            found[mask] = (vertex_mask, inside)
                    elif vertex > start and not vertex_mask >> vertex & 1:
                        visit(path + [vertex], vertex_mask | 1 << vertex,
                              edge_mask | 1 << edge)
            visit([start], 1 << start, 0)
        return sorted((mask, vertices, inside)
                      for mask, (vertices, inside) in found.items())

    def cell_closure_vertices(self, faces):
        result = 0
        for face in bits(faces):
            x = face % (self.width - 1)
            y = face // (self.width - 1)
            for dx, dy in product(range(2), repeat=2):
                result |= 1 << self.vertex_id[x + dx, y + dy]
        return result


def monochromatic_edges(grid, minus_vertices):
    return sum(1 << edge for edge, (u, v) in enumerate(grid.edges)
               if (minus_vertices >> u & 1) == (minus_vertices >> v & 1))


def colored_edges(grid, open_w, minus_vertices, minus_color):
    return sum(1 << edge for edge in bits(open_w)
               if bool(minus_vertices >> grid.edges[edge][0] & 1) == minus_color)


def separation_mask(inside, marks):
    return sum(1 << pair for pair, (i, j) in enumerate([(0, 1), (0, 2), (1, 2)])
               if bool(inside >> marks[i] & 1) != bool(inside >> marks[j] & 1))


def signature_partition(loop_mark_sets, mark_count):
    signatures = [tuple(bool(enclosed >> i & 1) for enclosed in loop_mark_sets)
                  for i in range(mark_count)]
    return len(set(signatures))


def evaluate(coefficients, t, edge_count):
    return sum((Fraction(coefficient) * t ** (edge_count - closed)
                * (1 - t) ** closed)
               for closed, coefficient in enumerate(coefficients))


def expand_variable_weights(records, variable):
    degree = variable.bit_count()
    polynomials = [[0] * (degree + 1) for _ in range(4)]
    for open_w, components, minus_loop, plus_loop, _ in records:
        opened = (open_w & variable).bit_count()
        polynomial = polynomials[2 * minus_loop + plus_loop]
        for extra in range(degree - opened + 1):
            polynomial[opened + extra] += (
                (1 << components) * comb(degree - opened, extra) * (-1) ** extra
            )
    expected = [[0] * 9 for _ in range(4)]
    expected[0][0], expected[0][4], expected[0][8] = 2, -4, 2
    expected[1][4], expected[1][8] = 4, -4
    expected[2][4], expected[2][8] = 4, -4
    expected[3][8] = 8
    require(polynomials == expected, "symbolic mixed-loop weight identity failed")
    total = [sum(polynomial[i] for polynomial in polynomials) for i in range(9)]
    require(total == [2, 0, 0, 0, 4, 0, 0, 0, 2],
            "symbolic two-loop partition function failed")
    left = [0] * 13
    right = [0] * 13
    for i, coefficient in enumerate(polynomials[3]):
        left[i] += coefficient
        left[i + 4] += coefficient
    for i in range(9):
        right[i + 4] = 2 * (polynomials[2][i] + polynomials[3][i])
    require(left == right, "symbolic residual-loop conditioning identity failed")
    return polynomials


def four_by_four():
    grid = Grid(4, 4)
    inner_vertices = [grid.vertex_id[x, y]
                      for y in (1, 2) for x in (1, 2)]
    inner_vertex_mask = sum(1 << vertex for vertex in inner_vertices)
    core = sum(1 << edge for edge, (u, v) in enumerate(grid.edges)
               if inner_vertex_mask >> u & 1 and inner_vertex_mask >> v & 1)
    marks = [grid.face(0, 0), grid.face(1, 1), grid.face(2, 2)]
    pairs = [(0, 1), (0, 2), (1, 2)]
    cycles = grid.cycles()
    d_violations = [
        sum(1 << edge for edge in bits(grid.interior)
            if bool(colors >> grid.dual[edge][0] & 1)
            != bool(colors >> grid.dual[edge][1] & 1))
        for colors in range(1 << grid.face_count)
    ]
    edge_count = grid.interior.bit_count()
    coefficients = {name: [0] * (edge_count + 1)
                    for name in ("partition", "compatibility", "core_witness")}
    counts = defaultdict(int, {"opposite_color_source_checks": 0})
    for spin_bits in range(1 << len(inner_vertices)):
        minus = sum(1 << vertex for index, vertex in enumerate(inner_vertices)
                    if spin_bits >> index & 1)
        available = monochromatic_edges(grid, minus) & grid.interior
        open_subset = available
        while True:
            open_w = grid.boundary | open_subset
            closed = grid.interior & ~open_w
            labels, component_count = grid.components(open_w)
            color_count = sum(not (closed & violations) for violations in d_violations)
            require(color_count == 1 << component_count, "free-color factor failed")
            closed_mono = (available & ~open_w).bit_count()
            coefficients["partition"][closed_mono] += color_count
            loops = []
            local_mark_sets = []
            all_separations = 0
            local_separations = 0
            for mask, vertices, inside in cycles:
                if mask & ~open_w:
                    continue
                require(vertices & minus in (0, vertices),
                        "an actual open loop is not monochromatic")
                enclosed = sum(1 << index for index, mark in enumerate(marks)
                               if inside >> mark & 1)
                separation = separation_mask(inside, marks)
                all_separations |= separation
                loop = (mask, vertices, inside, enclosed, separation,
                        bool(vertices & minus))
                loops.append(loop)
                if not mask & ~core:
                    local_mark_sets.append(enclosed)
                    local_separations |= separation
            for assignment in range(8):
                required = sum(1 << pair for pair, (i, j) in enumerate(pairs)
                               if bool(assignment >> i & 1)
                               != bool(assignment >> j & 1))
                compatible = all(
                    labels[marks[i]] != labels[marks[j]]
                    for pair, (i, j) in enumerate(pairs) if required >> pair & 1
                )
                require(compatible == (required & ~all_separations == 0),
                        "planar cut-cycle identity failed")
                if assignment == 5:
                    if compatible:
                        coefficients["compatibility"][closed_mono] += color_count
                    if required & ~local_separations == 0:
                        coefficients["core_witness"][closed_mono] += color_count
                counts["assignment_checks"] += 1
                if not compatible:
                    continue
                missing = required & ~local_separations
                if not missing:
                    continue
                target = min(
                    (loop for loop in loops if loop[4] & missing),
                    key=lambda loop: (loop[3].bit_count(), loop[3], loop[0])
                )
                mask, vertices, inside, enclosed, _, target_minus = target
                for pair, (i, j) in enumerate(pairs):
                    require(not (missing >> pair & 1 and enclosed >> i & 1
                                 and enclosed >> j & 1),
                            "minimal target encloses a missing pair")
                before = signature_partition(local_mark_sets, len(marks))
                after = signature_partition(local_mark_sets + [enclosed], len(marks))
                require(after > before, "new separating loop did not refine signatures")
                counts["minimal_target_checks"] += 1
                opposite_w = colored_edges(grid, open_w, minus, not target_minus)
                first_inside_mark = next(bits(enclosed))
                for pair, (i, j) in enumerate(pairs):
                    if not missing >> pair & 1 or enclosed >> i & 1 or enclosed >> j & 1:
                        continue
                    witness = min(
                        (loop for loop in loops if loop[4] >> pair & 1),
                        key=lambda loop: loop[0]
                    )
                    if witness[5] == target_minus:
                        continue
                    witness_contains_target = bool(
                        witness[2] >> marks[first_inside_mark] & 1
                    )
                    source = next(
                        marks[index] for index in (i, j)
                        if bool(witness[2] >> marks[index] & 1)
                        != witness_contains_target
                    )
                    other = marks[j] if source == marks[i] else marks[i]
                    explored = grid.reach(source, opposite_w)
                    require(not explored >> other & 1, "minus certificate failed")
                    require(not explored & inside, "source enters target disk")
                    require(not grid.cell_closure_vertices(explored) & vertices,
                            "closed source cells touch target loop")
                    for edge in bits(grid.interior):
                        a, b = grid.dual[edge]
                        if bool(explored >> a & 1) != bool(explored >> b & 1):
                            require(opposite_w >> edge & 1,
                                    "full complement frontier is not matching")
                    counts["opposite_color_source_checks"] += 1
            counts["states"] += 1
            counts["transverse_assignments_checked"] += len(d_violations)
            if open_subset == 0:
                break
            open_subset = (open_subset - 1) & available
    probabilities = []
    for t in (Fraction(1, 2), Fraction(2, 3), Fraction(3, 4)):
        partition = evaluate(coefficients["partition"], t, edge_count)
        probabilities.append({
            "t": rational(t),
            "compatibility": rational(
                evaluate(coefficients["compatibility"], t, edge_count) / partition
            ),
            "core_witness": rational(
                evaluate(coefficients["core_witness"], t, edge_count) / partition
            )
        })
    return {
        "geometry": "4x4 W vertices; outer perimeter open plus; four interior spins free",
        "marks": marks,
        "assignment_for_probabilities": ["+", "-", "+"],
        "core": "the central four-edge W square",
        "underlying_simple_cycles": len(cycles),
        "edge_count": edge_count,
        "weight_basis": "coefficient[j] * t^(edge_count-j) * (1-t)^j",
        "coefficients": coefficients,
        "counts": dict(counts),
        "probabilities": probabilities
    }


def explore(grid, open_w, minus_vertices, source, known_spins):
    barriers = colored_edges(grid, open_w, minus_vertices, True)
    reached = 1 << source
    queue = deque([source])
    queried_edges = 0
    transcript = []
    while queue:
        vertex = queue.popleft()
        for neighbor, edge in grid.dual_adjacency[vertex]:
            if neighbor == grid.face_count:
                continue
            if not queried_edges >> edge & 1:
                for endpoint in grid.edges[edge]:
                    if not known_spins >> endpoint & 1:
                        transcript.append(("s", endpoint,
                                           bool(minus_vertices >> endpoint & 1)))
                        known_spins |= 1 << endpoint
                u, v = grid.edges[edge]
                require(known_spins >> u & 1 and known_spins >> v & 1,
                        "edge queried before its endpoint spins")
                transcript.append(("W", edge, bool(open_w >> edge & 1)))
                queried_edges |= 1 << edge
            if not barriers >> edge & 1 and not reached >> neighbor & 1:
                reached |= 1 << neighbor
                queue.append(neighbor)
    return reached, tuple(transcript)


def mixed_loop_fixture():
    grid = Grid(7, 4)
    minus_vertices = sum(1 << grid.vertex_id[x, y]
                         for x, y in product((1, 2), (1, 2)))
    squares = []
    for x0 in (1, 4):
        vertices = {grid.vertex_id[x, y]
                    for x, y in product((x0, x0 + 1), (1, 2))}
        squares.append(sum(1 << edge for edge, (u, v) in enumerate(grid.edges)
                           if u in vertices and v in vertices))
    variable = squares[0] | squares[1]
    require(variable.bit_count() == 8, "fixture needs exactly two disjoint squares")
    variable_edges = list(bits(variable))
    source = grid.face(1, 1)
    target = grid.face(4, 1)
    exterior = grid.face(0, 0)
    records = []
    history_groups = defaultdict(list)
    witness_types = defaultdict(int)
    all_spins_known = (1 << len(grid.vertices)) - 1
    for state in range(256):
        open_w = grid.boundary | sum(
            1 << edge for index, edge in enumerate(variable_edges)
            if state >> index & 1
        )
        require(not open_w & ~monochromatic_edges(grid, minus_vertices),
                "inadmissible fixed-spin edge pattern")
        labels, component_count = grid.components(open_w)
        minus_loop = (open_w & squares[0]) == squares[0]
        plus_loop = (open_w & squares[1]) == squares[1]
        require(component_count == 1 + minus_loop + plus_loop,
                "fixture dual-component count failed")
        compatible = (labels[source] != labels[exterior]
                      and labels[target] != labels[exterior])
        require(compatible == (minus_loop and plus_loop),
                "mixed-color compatibility is not the two-loop event")
        reached, history = explore(
            grid, open_w, minus_vertices, source, all_spins_known
        )
        require(reached == grid.reach(
            source, colored_edges(grid, open_w, minus_vertices, True)
        ), "exploration is not the full complement-of-minus component")
        history_groups[history].append(state)
        value = 2 * minus_loop + plus_loop
        witness_types[value] += 1
        records.append((open_w, component_count, minus_loop, plus_loop, reached))
    cylinder_checks = 0
    for history, members in history_groups.items():
        matching = []
        for state, (open_w, _, _, _, _) in enumerate(records):
            if all(bool(open_w >> edge & 1) == value
                   for kind, edge, value in history if kind == "W"):
                matching.append(state)
        require(matching == members, "history is not precisely its query cylinder")
        cylinder_checks += len(records)
    retained = [record for record in records if record[2]]
    require(len(retained) == 16, "source-sealed history should leave four free edges")
    require(all(record[4] == 1 << source for record in retained),
            "sealed source is not one raw cell")
    retained_histories = [
        history for history, members in history_groups.items()
        if records[members[0]][2]
    ]
    require(len(retained_histories) == 1, "the full minus circuit should be one history")
    require(all(not (squares[1] >> edge & 1)
                for kind, edge, _ in retained_histories[0] if kind == "W"),
            "minus-source history queried the future plus circuit")
    plus_vertices = grid.cell_closure_vertices(1 << target)
    require(not grid.cell_closure_vertices(1 << source) & plus_vertices,
            "source closure meets the target plus disk")
    require(any(record[3] and record[4] >> target & 1
                for record in records if not record[2]),
            "fixture did not distinguish complement-of-minus from N")
    weight_polynomials = expand_variable_weights(records, variable)
    probabilities = []
    distributions = {}
    fkg_checks = 0
    for t in (Fraction(1, 2), Fraction(2, 3), Fraction(3, 4)):
        weights = [
            Fraction(1 << component_count) * t ** (open_w & variable).bit_count()
            * (1 - t) ** (8 - (open_w & variable).bit_count())
            for open_w, component_count, _, _, _ in records
        ]
        total = sum(weights)
        require(total == 2 * (1 + t ** 4) ** 2, "two-cycle partition identity failed")
        masses = [sum(weight for record, weight in zip(records, weights)
                      if 2 * record[2] + record[3] == value) / total
                  for value in range(4)]
        q = 2 * t ** 4 / (1 + t ** 4)
        require(masses == [(1 - q) ** 2, (1 - q) * q, q * (1 - q), q ** 2],
                "two-loop distribution does not factor")
        require(masses[3] / (masses[2] + masses[3]) == q,
                "minus history changed the residual plus-loop probability")
        residual = {}
        for record, weight in zip(records, weights):
            if record[2]:
                residual[record[0] & squares[1]] = weight
        for a, b in product(residual, repeat=2):
            require(residual[a & b] * residual[a | b] >= residual[a] * residual[b],
                    "residual lattice-FKG inequality failed")
            fkg_checks += 1
        probabilities.append({
            "t": rational(t),
            "compatibility": rational(q ** 2),
            "minus_history": rational(q),
            "plus_loop_given_minus_history": rational(q)
        })
        distributions[t] = masses
    return {
        "geometry": "7x4 W vertices; two disjoint four-edge squares",
        "initial_condition": "all s pinned; boundary W open plus; all other interior W edges closed",
        "scope": "an admissible pin-law fixture, not a mesh family of Qprime patterns",
        "transverse_conditioning": "none; every N component is free",
        "variable_edges": 8,
        "states": len(records),
        "history_count": len(history_groups),
        "history_cylinder_checks": cylinder_checks,
        "retained_history_completions": len(retained),
        "opposite_color_preserving_histories": len(retained_histories),
        "residual_lattice_fkg_checks": fkg_checks,
        "witness_type_state_counts": {str(k): v for k, v in sorted(witness_types.items())},
        "partition_identity": "2*(1+t^4)^2 after canceling the common fixed-edge factor",
        "unnormalized_mass_polynomials": {
            str(value): polynomial for value, polynomial in enumerate(weight_polynomials)
        },
        "polynomial_basis": "coefficient[i] * t^i; identities checked coefficientwise",
        "symbolic_conditional_identity": "mass[3]*(1+t^4) = 2*t^4*(mass[2]+mass[3])",
        "single_loop_probability": "2*t^4/(1+t^4)",
        "probabilities": probabilities
    }, distributions[Fraction(2, 3)]


def partitions(size):
    if size == 0:
        yield ()
        return
    def extend(prefix):
        if len(prefix) == size:
            yield prefix
        else:
            for label in range(max(prefix) + 2):
                yield from extend(prefix + (label,))
    yield from extend((0,))


def partition_rank():
    counts = {}
    split_checks = 0
    for size in range(1, 8):
        partition_count = 0
        for partition in partitions(size):
            partition_count += 1
            rank = len(set(partition))
            for label in set(partition):
                block = [i for i in range(size) if partition[i] == label]
                if len(block) < 2:
                    continue
                for subset in range(1, 1 << (len(block) - 1)):
                    added_loop = {block[0]} | {
                        block[i + 1] for i in range(len(block) - 1)
                        if not subset >> i & 1
                    }
                    refined = {(partition[i], i in added_loop) for i in range(size)}
                    require(len(refined) == rank + 1,
                            "a genuinely new loop did not increase partition rank")
                    require(rank + 1 <= size, "rank exceeded the number of marks")
                    split_checks += 1
        counts[str(size)] = partition_count
    require(list(counts.values()) == [1, 2, 5, 15, 52, 203, 877],
            "partition enumeration is incomplete")
    return {"partition_counts": counts, "binary_split_checks": split_checks,
            "universal_bound_proved_in_report": "at most k-1 successful localizations"}


def jacobian_replay(masses):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    operation = "probability.finite_distribution.condition.compute"
    require(status["exit_code"] == 0, "Jacobian adapter did not complete successfully")
    require(envelope["tool"] == "math.run", "not a Jacobian execution envelope")
    require(envelope["request"]["operation_id"] == operation, "wrong operation")
    require(envelope["request"]["payload"] == payload, "payload was not preserved")
    require(envelope["result"]["operation_id"] == operation, "wrong typed result")
    source = {int(read_rational(atom["value"])): read_rational(atom["probability"])
              for atom in payload["distribution"]["atoms"]}
    require(source == dict(enumerate(masses)), "payload is not the exact cut-model law")
    event = {int(read_rational(value)) for value in payload["event_values"]}
    require(event == {2, 3}, "conditioning is not the minus-source history")
    event_probability = sum(source[value] for value in event)
    output = envelope["result"]["output"]
    require(read_rational(output["event_probability"]) == event_probability,
            "Jacobian event mass failed independent replay")
    conditional = {
        int(read_rational(atom["value"])): read_rational(atom["probability"])
        for atom in output["distribution"]["atoms"]
    }
    require(conditional == {value: source[value] / event_probability for value in event},
            "Jacobian normalization failed independent replay")
    for contribution in output["contributions"]:
        value = int(read_rational(contribution["value"]))
        require(read_rational(contribution["source_probability"]) == source[value],
                "Jacobian source contribution mismatch")
        require(read_rational(contribution["conditioned_probability"]) == conditional[value],
                "Jacobian conditional contribution mismatch")
    return {
        "operation_id": operation,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "event_probability": rational(event_probability),
        "plus_loop_given_minus_history": rational(conditional[3]),
        "scope": "exact finite normalization only; no spatial or asymptotic verdict"
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    finite_grid = four_by_four()
    fixture, masses = mixed_loop_fixture()
    certificate = {
        "claim": "BW",
        "classification": "exact finite-core verification accompanying a universal prose proof",
        "proof": "report.md",
        "independent_review": "pending",
        "not_machine_certified": [
            "the uniform anchored-collar estimate and the universal spatial theorem",
            "independent citation attribution",
            "novelty or publishable significance",
            "full-spin contiguity or the manuscript main theorem"
        ],
        "four_by_four": finite_grid,
        "mixed_loop_fixture": fixture,
        "partition_rank": partition_rank(),
        "jacobian": jacobian_replay(masses)
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate,
                "stored exact certificate differs from independent recomputation")
    print(json.dumps({
        "status": "passed",
        "states": finite_grid["counts"]["states"] + fixture["states"],
        "transverse_assignments": finite_grid["counts"]["transverse_assignments_checked"],
        "minimal_target_checks": finite_grid["counts"]["minimal_target_checks"],
        "opposite_color_source_checks": finite_grid["counts"]["opposite_color_source_checks"],
        "certificate": str(path.relative_to(HERE.parent.parent))
    }, sort_keys=True))


if __name__ == "__main__":
    main()
