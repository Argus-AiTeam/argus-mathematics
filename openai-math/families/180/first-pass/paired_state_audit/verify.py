#!/usr/bin/env python3
"""Exact replay accompanying the uniform proof in report.md."""

import argparse
from collections import defaultdict, deque
from fractions import Fraction as Q
from functools import cmp_to_key
from itertools import combinations, permutations
import json
from math import comb, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ZERO = (0, 0)
ONE = (1, 0)
PHASES = (ONE, (0, 1), (-1, 0), (0, -1))


def add(a, b):
    return a[0] + b[0], a[1] + b[1]


def mul(a, b):
    return a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0]


def clean(p):
    return {k: v for k, v in p.items() if v != ZERO}


def p_add(p, q):
    out = dict(p)
    for k, v in q.items():
        out[k] = add(out.get(k, ZERO), v)
    return clean(out)


def p_mul(p, q):
    out = {}
    for j, a in p.items():
        for k, b in q.items():
            out[j + k] = add(out.get(j + k, ZERO), mul(a, b))
    return clean(out)


def shifted(p):
    out = {}
    for n, a in p.items():
        for j in range(n + 1):
            term = a[0] * comb(n, j), a[1] * comb(n, j)
            out[j] = add(out.get(j, ZERO), term)
    return clean(out)


def cross(a, b, c):
    return (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])


def area2(points):
    return sum(a[0] * b[1] - a[1] * b[0]
               for a, b in zip(points, points[1:] + points[:1]))


def on_segment(p, a, b):
    return (cross(a, b, p) == 0
            and min(a[0], b[0]) <= p[0] <= max(a[0], b[0])
            and min(a[1], b[1]) <= p[1] <= max(a[1], b[1]))


def intersects(a, b, c, d):
    ab_c, ab_d = cross(a, b, c), cross(a, b, d)
    cd_a, cd_b = cross(c, d, a), cross(c, d, b)
    if ab_c * ab_d < 0 and cd_a * cd_b < 0:
        return True
    return (on_segment(c, a, b) or on_segment(d, a, b)
            or on_segment(a, c, d) or on_segment(b, c, d))


def location(p, polygon):
    """Return -1 outside, 0 on the boundary, and 1 inside."""
    inside = False
    for a, b in zip(polygon, polygon[1:] + polygon[:1]):
        if on_segment(p, a, b):
            return 0
        if (a[1] > p[1]) != (b[1] > p[1]):
            x = a[0] + (p[1] - a[1]) * (b[0] - a[0]) / (b[1] - a[1])
            if x > p[0]:
                inside = not inside
    return 1 if inside else -1


def edges_of(cycle):
    return list(zip(cycle, cycle[1:] + cycle[:1]))


def edge(u, v):
    return tuple(sorted((u, v)))


def solve(matrix, rhs):
    n = len(rhs)
    a = [[Q(x) for x in row] + [Q(rhs[i])] for i, row in enumerate(matrix)]
    for j in range(n):
        pivot = next(i for i in range(j, n) if a[i][j])
        a[j], a[pivot] = a[pivot], a[j]
        scale = a[j][j]
        a[j] = [x / scale for x in a[j]]
        for i in range(n):
            if i != j and a[i][j]:
                scale = a[i][j]
                a[i] = [x - scale * y for x, y in zip(a[i], a[j])]
    return [row[-1] for row in a]


def bipyramid(m):
    assert m >= 4 and m % 2 == 0
    faces = []
    for j in range(m):
        v, w = j + 1, (j + 1) % m + 1
        faces.extend([((0, v, w), j % 2 == 0),
                      ((m + 1, w, v), j % 2 == 1)])
    return faces


def subdivide(faces):
    source_edges = sorted({edge(u, v) for f, _ in faces for u, v in edges_of(list(f))})
    first = 1 + max(v for f, _ in faces for v in f)
    midpoint = {e: first + j for j, e in enumerate(source_edges)}
    out = []
    for (a, b, c), black in faces:
        ab, bc, ca = midpoint[edge(a, b)], midpoint[edge(b, c)], midpoint[edge(c, a)]
        out.extend([((a, ab, ca), black), ((ab, b, bc), black),
                    ((ca, bc, c), black), ((ab, bc, ca), not black)])
    return out


def insert_octahedron(faces, want_black):
    roots = set(faces[0][0])
    target = next(i for i, (f, black) in enumerate(faces)
                  if i and black == want_black
                  and len(set(f) - roots) >= (2 if want_black else 3))
    boundary, color = faces[target]
    a, b, c = boundary
    mapping = {0: a, 1: c, 2: b}
    next_vertex = 1 + max(v for f, _ in faces for v in f)
    mapping.update({j: next_vertex + j - 3 for j in (3, 4, 5)})
    inserted = [(tuple(mapping[v] for v in f), black if not color else not black)
                for f, black in bipyramid(4)[1:]]
    return faces[:target] + faces[target + 1:] + inserted


def embedding(faces):
    vertices = sorted({v for f, _ in faces for v in f})
    assert vertices == list(range(len(vertices)))
    incident = defaultdict(list)
    for i, (f, _) in enumerate(faces):
        assert len(set(f)) == 3
        for u, v in edges_of(list(f)):
            incident[edge(u, v)].append((i, u, v))
    assert len({tuple(sorted(f)) for f, _ in faces}) == len(faces)
    for sides in incident.values():
        assert len(sides) == 2
        (i, u, v), (j, w, x) = sides
        assert (u, v) == (x, w) and faces[i][1] != faces[j][1]
    assert len(vertices) - len(incident) + len(faces) == 2
    neighbors = {v: set() for v in vertices}
    for u, v in incident:
        neighbors[u].add(v)
        neighbors[v].add(u)
    roots = list(faces[0][0])
    coords = dict(zip(roots, [(Q(0), Q(0)), (Q(0), Q(12)), (Q(12), Q(0))]))
    nonroots = sorted(set(vertices) - set(roots))
    matrix = [[len(neighbors[v]) if v == w else -int(w in neighbors[v])
               for w in nonroots] for v in nonroots]
    for axis in (0, 1):
        rhs = [sum(coords[w][axis] for w in neighbors[v] if w in roots)
               for v in nonroots]
        values = solve(matrix, rhs)
        for v, value in zip(nonroots, values):
            old = coords.get(v, (Q(0), Q(0)))
            coords[v] = (value, old[1]) if axis == 0 else (old[0], value)
    assert len(set(coords.values())) == len(vertices)
    signed_areas = [area2([coords[v] for v in f]) for f, _ in faces]
    assert signed_areas[0] < 0 and all(a > 0 for a in signed_areas[1:])
    assert sum(signed_areas) == 0
    check_plane_edges(coords, list(incident))
    assert all(location(coords[v], [coords[r] for r in roots]) == 1 for v in nonroots)
    return coords, incident, roots, nonroots


def check_plane_edges(coords, edges):
    for u, v in edges:
        assert u != v
        for w in coords:
            if w not in (u, v):
                assert not on_segment(coords[w], coords[u], coords[v])
    for (u, v), (w, x) in combinations(edges, 2):
        if not {u, v} & {w, x}:
            assert not intersects(coords[u], coords[v], coords[w], coords[x])


def angle_compare(a, b):
    ha = 0 if a[1] > 0 or (a[1] == 0 and a[0] > 0) else 1
    hb = 0 if b[1] > 0 or (b[1] == 0 and b[0] > 0) else 1
    if ha != hb:
        return -1 if ha < hb else 1
    determinant = a[0] * b[1] - a[1] * b[0]
    assert determinant != 0 or a[0] * b[0] + a[1] * b[1] < 0
    return -1 if determinant > 0 else 1


def spoke_data(coords, black_faces):
    original_count = len(coords)
    points = dict(coords)
    spokes = []
    for t, f in enumerate(black_faces):
        center = original_count + t
        points[center] = tuple(sum(coords[v][a] for v in f) / 3 for a in (0, 1))
        spokes.extend((center, v) for v in f)
    check_plane_edges(points, spokes)
    neighbors = {v: [] for v in points}
    for u, v in spokes:
        neighbors[u].append(v)
        neighbors[v].append(u)
    rotation = {}
    for v, adjacent in neighbors.items():
        def compare(u, w):
            a = tuple(points[u][j] - points[v][j] for j in (0, 1))
            b = tuple(points[w][j] - points[v][j] for j in (0, 1))
            return angle_compare(a, b)
        rotation[v] = sorted(adjacent, key=cmp_to_key(compare))
    component = {}
    for v in points:
        if v not in component:
            todo = [v]
            component[v] = v
            while todo:
                w = todo.pop()
                for x in neighbors[w]:
                    if x not in component:
                        component[x] = v
                        todo.append(x)
    dart_face = {}
    records = []
    for first in sorted((u, v) for u, ns in neighbors.items() for v in ns):
        if first in dart_face:
            continue
        darts = []
        u, v = first
        while (u, v) not in dart_face:
            dart_face[u, v] = len(records)
            darts.append((u, v))
            around = rotation[v]
            u, v = v, around[(around.index(u) - 1) % len(around)]
        assert (u, v) == first
        polygon = [points[u] for u, _ in darts]
        records.append({"darts": darts, "component": component[first[0]],
                        "area2": area2(polygon), "polygon": polygon})
    for v, ns in neighbors.items():
        if not ns:
            records.append({"darts": [], "component": component[v],
                            "area2": Q(0), "polygon": []})
    by_component = defaultdict(list)
    for f, record in enumerate(records):
        by_component[record["component"]].append(f)
    dual = defaultdict(list)
    for spoke in spokes:
        a, b = dart_face[spoke], dart_face[spoke[::-1]]
        if a != b:
            dual[a].append((b, spoke))
            dual[b].append((a, spoke))
    weights = {s: 0 for s in spokes}
    bounded = []
    for comp, face_ids in by_component.items():
        outer, = [f for f in face_ids if records[f]["area2"] <= 0]
        inner = [f for f in face_ids if f != outer]
        vs = sum(c == comp for c in component.values())
        es = sum(component[u] == comp for u, _ in spokes)
        assert len(face_ids) == es - vs + 2
        for f in inner:
            assert records[f]["area2"] > 0
            bounded.append(f)
            parent = {f: None}
            queue = deque([f])
            while queue and outer not in parent:
                current = queue.popleft()
                for nxt, spoke in sorted(dual[current]):
                    if nxt not in parent:
                        parent[nxt] = current, spoke
                        queue.append(nxt)
            assert outer in parent
            current = outer
            while current != f:
                previous, spoke = parent[current]
                weights[spoke] += 1 if dart_face[spoke] == previous else -1
                current = previous
        for f in face_ids:
            expected = 1 if f != outer else -len(inner)
            records[f]["expected_circulation"] = expected
    F = len(bounded)
    assert all(-F <= a <= F for a in weights.values())
    weights = {spoke: a + F for spoke, a in weights.items()}
    for record in records:
        circulation = sum(weights[(u, v)] if u >= original_count else -weights[(v, u)]
                          for u, v in record["darts"])
        assert circulation == record["expected_circulation"]
    for f in bounded:
        record = records[f]
        u, v = record["darts"][0]
        a, b = points[u], points[v]
        midpoint = ((a[0] + b[0]) / 2, (a[1] + b[1]) / 2)
        normal = a[1] - b[1], b[0] - a[0]
        for k in range(1, 201):
            p = tuple(midpoint[j] + normal[j] / 2**k for j in (0, 1))
            if location(p, record["polygon"]) == 1 and not any(
                    on_segment(p, points[w], points[x]) for w, x in spokes):
                record["witness"] = p
                break
        assert "witness" in record
    incidence = {(t, v): weights[(original_count + t, v)]
                 for t, face in enumerate(black_faces) for v in face}
    return points, component, records, bounded, F, incidence


def all_states(black_faces, nonroots):
    allowed = [sorted(set(f) & set(nonroots)) for f in black_faces]
    order = sorted(range(len(black_faces)), key=lambda t: (len(allowed[t]), t))
    states = []
    current = [None] * len(black_faces)

    def visit(j, used):
        if j == len(order):
            states.append(tuple(current))
            return
        t = order[j]
        for v in allowed[t]:
            if v not in used:
                current[t] = v
                visit(j + 1, used | {v})
    visit(0, set())
    return sorted(states)


def functional_cycles(outgoing):
    done = set()
    cycles = []
    for start in sorted(outgoing):
        path, positions = [], {}
        v = start
        while v in outgoing and v not in done and v not in positions:
            positions[v] = len(path)
            path.append(v)
            v = outgoing[v]
        if v in positions:
            cycles.append(path[positions[v]:])
        done.update(path)
    return cycles


def find_cycle(edges):
    neighbors = defaultdict(list)
    for u, v in edges:
        neighbors[u].append(v)
        neighbors[v].append(u)
    done, active, stack = set(), {}, []

    def visit(v, parent):
        active[v] = len(stack)
        stack.append(v)
        for w in sorted(neighbors[v]):
            if w == parent:
                continue
            if w in active:
                return stack[active[w]:]
            if w not in done:
                found = visit(w, v)
                if found is not None:
                    return found
        stack.pop()
        del active[v]
        done.add(v)
        return None

    for v in sorted(neighbors):
        if v not in done:
            found = visit(v, None)
            if found is not None:
                return found
    return None


def linear_and_triangle_checks():
    unsigned = [1, 1, -2, -1, 0, 2]
    signed = [3, -3, 0, 1, -2, 0]
    matching = [1, 0, -1, 0, -1, 0]
    target = [0, 0, 0, -1, 2, 3]
    assert [3*a + b - 6*c for a, b, c in zip(unsigned, signed, matching)] == [
        2*x for x in target]
    cyclic = {(0, 1), (1, 2), (2, 0)}
    delta = lambda u, v: 1 if (u, v) in cyclic else -1
    for r, s, u in permutations(range(3)):
        assert delta(u, s) - delta(r, s) == 2 * delta(r, u)
    return {"disk_identity_multiplier": [3, 1, -6],
            "disk_target_multiplier": 2, "triangle_orders": 6}


def audit(name, faces):
    coords, incident, roots, nonroots = embedding(faces)
    black_faces = [f for i, (f, black) in enumerate(faces) if i and black]
    assert faces[0][1] and len(black_faces) == len(nonroots)
    black_index = {tuple(sorted(f)): t for t, f in enumerate(black_faces)}
    edge_black = {}
    delta = {}
    for f, black in faces:
        if black:
            for u, v in edges_of(list(f)):
                edge_black[edge(u, v)] = f
                delta[u, v], delta[v, u] = 1, -1
    points, components, regions, bounded, F, weights = spoke_data(coords, black_faces)
    states = all_states(black_faces, nonroots)
    state_set = set(states)
    pairs = [(r, s) for r in states for s in states if all(a != b for a, b in zip(r, s))]
    assert pairs, f"{name}: fixture has no pair"
    groups, by_s = defaultdict(list), defaultdict(list)
    disk_checks = 0

    def disk(cycle, r):
        nonlocal disk_checks
        assert len(cycle) >= 3 and len(cycle) == len(set(cycle))
        assert not set(cycle) & set(roots)
        polygon = [coords[v] for v in cycle]
        orientation = 1 if area2(polygon) > 0 else -1
        assert area2(polygon) != 0
        inner = []
        for i, (f, _) in enumerate(faces):
            if i == 0:
                inner.append(False)
                continue
            center = tuple(sum(coords[v][a] for v in f) / 3 for a in (0, 1))
            loc = location(center, polygon)
            assert loc != 0
            inner.append(loc == 1)
        B = sum(inside and black for inside, (_, black) in zip(inner, faces))
        W = sum(inside and not black for inside, (_, black) in zip(inner, faces))
        I = sum(location(coords[v], polygon) == 1 for v in coords if v not in cycle)
        inside_by_face = {tuple(sorted(f)): inside for (f, _), inside in zip(faces, inner)}
        l = 0
        for u, v in edges_of(cycle):
            f = edge_black[edge(u, v)]
            t = black_index[tuple(sorted(f))]
            assert r[t] == u
            l += inside_by_face[tuple(sorted(f))]
        h = len(cycle)
        assert B + W == 2 * I + h - 2
        assert 3 * (B - W) == 2 * l - h
        assert B == I + l and 2 * l - h == -3
        assert sum(delta[u, v] for u, v in edges_of(cycle)) == -3 * orientation
        assert all(location(coords[v], polygon) == -1 for v in roots)
        disk_checks += 1

    def J(r, s):
        total = sum(delta[u, v] for u, v in zip(r, s))
        assert total % 3 == 0
        return total // 3

    direct = {}
    for r, s in pairs:
        selected = tuple(sorted(edge(u, v) for u, v in zip(r, s)))
        assert len(set(selected)) == len(black_faces)
        degree = {v: 0 for v in nonroots}
        for u, v in selected:
            degree[u] += 1
            degree[v] += 1
        assert set(degree.values()) == {2}
        cycles = functional_cycles(dict(zip(r, s)))
        assert sum(map(len, cycles)) == len(nonroots)
        for cycle in cycles:
            disk(cycle, r)
        assert J(r, s) == sum(-1 if area2([coords[v] for v in c]) > 0 else 1
                              for c in cycles)
        omega = sum(weights[t, v] for t, v in enumerate(s))
        direct = p_add(direct, {omega: PHASES[J(r, s) % 4]})
        groups[selected].append((r, s))
        by_s[s].append(r)
    cyclic_states, involution_checks = 0, 0
    for s, partners in by_s.items():
        q_edges = [tuple(v for v in f if v != s[t]) for t, f in enumerate(black_faces)]
        chosen = find_cycle(q_edges)
        if chosen is None:
            continue
        cyclic_states += 1
        q_indices = {edge(*e): t for t, e in enumerate(q_edges)}
        chosen_indices = {q_indices[edge(u, v)] for u, v in edges_of(chosen)}

        def flip(r):
            return tuple(next(v for v in black_faces[t] if v not in (r[t], s[t]))
                         if t in chosen_indices else r[t] for t in range(len(r)))
        phase_sum = ZERO
        for r in partners:
            outgoing = {r[t]: next(v for v in f if v not in (r[t], s[t]))
                        for t, f in enumerate(black_faces)}
            cycle = chosen
            if not all(outgoing[u] == v for u, v in edges_of(cycle)):
                cycle = list(reversed(cycle))
            assert all(outgoing[u] == v for u, v in edges_of(cycle))
            disk(cycle, r)
            changed = flip(r)
            assert changed in state_set and changed in partners and changed != r
            assert flip(changed) == r
            assert all(a != b for a, b in zip(changed, s))
            assert abs(J(changed, s) - J(r, s)) == 2
            assert add(PHASES[J(changed, s) % 4], PHASES[J(r, s) % 4]) == ZERO
            phase_sum = add(phase_sum, PHASES[J(r, s) % 4])
            involution_checks += 1
        assert phase_sum == ZERO
    grouped = {}
    group_counts = defaultdict(int)
    group_mass = defaultdict(int)
    third_corner_cases = 0
    areas = []
    for selected, rows in groups.items():
        r, s = rows[0]
        cycles = functional_cycles(dict(zip(r, s)))
        assert len(rows) == 2 ** len(cycles)
        assert len(set(rows)) == len(rows)
        product_polynomial = {0: ONE}
        group_area = 1
        for cycle in cycles:
            if area2([coords[v] for v in cycle]) < 0:
                cycle = list(reversed(cycle))
            detour, plus, minus = [], 0, 0
            for u, v in edges_of(cycle):
                f = edge_black[edge(u, v)]
                t = black_index[tuple(sorted(f))]
                detour.extend([u, len(coords) + t])
                plus += weights[t, v]
                minus += weights[t, u]
                third_corner_cases += int(next(w for w in f if w not in (u, v)) in cycle)
            assert len(set(detour)) == len(detour)
            polygon = [points[v] for v in detour]
            assert area2(polygon) > 0
            check_plane_edges({v: points[v] for v in detour}, edges_of(detour))
            comp, = {components[v] for v in detour}
            enclosed = sum(location(regions[f]["witness"], polygon) == 1
                           for f in bounded if regions[f]["component"] == comp)
            assert plus - minus == enclosed and enclosed >= 1
            areas.append(enclosed)
            group_area *= enclosed
            product_polynomial = p_mul(product_polynomial, {plus: (0, -1), minus: (0, 1)})
        row_polynomial = {}
        orientation_choices = set()
        for r, s in rows:
            omega = sum(weights[t, v] for t, v in enumerate(s))
            row_polynomial = p_add(row_polynomial, {omega: PHASES[J(r, s) % 4]})
            orientations = tuple(area2([coords[v] for v in c]) > 0
                                 for c in functional_cycles(dict(zip(r, s))))
            orientation_choices.add(orientations)
        assert len(orientation_choices) == 2 ** len(cycles)
        assert row_polynomial == product_polynomial
        normalized = shifted(product_polynomial)
        c = len(cycles)
        assert min(normalized) == c
        assert normalized[c] == mul(PHASES[-c % 4], (group_area, 0))
        group_counts[c] += 1
        group_mass[c] += group_area
        grouped = p_add(grouped, product_polynomial)
    assert direct == grouped
    m = min(group_counts)
    taylor = shifted(direct)
    assert taylor and min(taylor) == m
    assert taylor[m] == mul(PHASES[-m % 4], (group_mass[m], 0))
    assert group_mass[m] >= 1
    assert max(direct) <= 2 * len(black_faces) * F
    forest_states = [s for s in by_s if find_cycle(
        [tuple(v for v in f if v != s[t]) for t, f in enumerate(black_faces)]) is None]
    assert forest_states
    return {
        "name": name, "vertices": len(coords), "black_nonouter_faces": len(black_faces),
        "states": len(states), "pairs": len(pairs), "groups": len(groups),
        "cycle_count_distribution": dict(sorted(group_counts.items())),
        "bounded_spoke_faces": F, "disk_checks": disk_checks,
        "cyclic_partnered_second_states": cyclic_states,
        "involution_checks": involution_checks,
        "third_corner_elsewhere_on_cycle_checks": third_corner_cases,
        "orientation_differences": sorted(set(areas)),
        "minimum_cycle_order": m, "minimum_order_positive_mass": group_mass[m],
        "first_coefficient": list(taylor[m]), "polynomial_degree": max(direct),
        "forest_partnered_second_states": len(forest_states),
        "one_forest_pair": [list(by_s[forest_states[0]][0]), list(forest_states[0])],
        "polynomial": [[k, list(v)] for k, v in sorted(direct.items())],
    }


def replay():
    universal = linear_and_triangle_checks()
    fixtures = [(f"bipyramid_{m}", bipyramid(m)) for m in (4, 6, 8)]
    fixtures.extend([
        ("octahedron_white_insertion", insert_octahedron(bipyramid(4), False)),
        ("octahedron_two_white_insertions",
         insert_octahedron(insert_octahedron(bipyramid(4), False), False)),
        ("subdivided_octahedron", subdivide(bipyramid(4))),
    ])
    results = [audit(name, faces) for name, faces in fixtures]
    control = insert_octahedron(bipyramid(4), True)
    _, _, _, nonroots = embedding(control)
    black_faces = [f for i, (f, black) in enumerate(control) if i and black]
    states = all_states(black_faces, nonroots)
    assert len(states) == 4
    assert not any(all(a != b for a, b in zip(r, s)) for r in states for s in states)
    adapter = json.loads((HERE / "jacobian_result.json").read_text())
    assert adapter["request"]["operation_id"] == "graph.multigraph.cycle_multicover.check"
    assert adapter["request"]["payload"] == json.loads((HERE / "jacobian_request.json").read_text())
    output = adapter["result"]["output"]
    assert output["cycle_validity"] == [True] and output["is_exact_k_cover"] is True
    assert output["edge_multiplicity"] == [["d0", 1], ["d1", 1], ["d2", 1]]
    octa_r, octa_s = results[0]["one_forest_pair"]
    labels = sorted(octa_r)
    graph = adapter["request"]["payload"]["graph"]
    assert graph["vertex_count"] == len(labels) == 3
    actual_edges = {edge(u, v) for u, v in zip(octa_r, octa_s)}
    mapped_edges = {edge(labels[e["left"]], labels[e["right"]]) for e in graph["edges"]}
    assert mapped_edges == actual_edges
    assert any(r["involution_checks"] for r in results), "Need a nonvacuous cyclic-Q fixture"
    assert any(r["third_corner_elsewhere_on_cycle_checks"] for r in results)
    assert any(r["minimum_cycle_order"] > 1 for r in results)
    formal = json.loads((HERE / "formal_verification.json").read_text())
    assert formal["status"] == "success" and formal["exit_code"] == 0
    assert formal["audit_exit_code"] == 0 and formal["proof_holes"] == []
    assert "Lean (version 4.31.0," in formal["tools"]["lean"]["version"]
    record = formal["kernel"]["recorded"]
    assert record["subject"]["subject_id"] == "C180_ALGEBRA"
    assert record["tier"] == "mechanical" and record["verdict"] == "supports"
    archive_path = HERE.parent.parent / record["artifact"]
    assert archive_path.resolve().parent == HERE / "certificates"
    archive = json.loads(archive_path.read_text())
    assert archive["lean_source"]["text"] == (HERE / "Main.lean").read_text()
    assert archive["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text()
    for key in ("status", "exit_code", "audit_exit_code", "proof_holes",
                "source_sha256", "statement_fidelity_sha256"):
        assert archive["lean_check"][key] == formal[key]
    return {"universal_linear_and_local_checks": universal, "fixtures": results,
            "antecedent_control": {"name": "octahedron_black_insertion", "states": 4,
                                   "pairs": 0, "is_counterexample": False},
            "jacobian_source_binding": {"adapter_vertex_labels": labels,
                                        "actual_pair_edges": sorted(actual_edges)},
            "jacobian_cycle_incidence_replayed": True,
            "lean": {"certificate": record["artifact"], "version": "4.31.0",
                     "exit_code": formal["exit_code"], "proof_holes": formal["proof_holes"],
                     "current_source_and_fidelity_match_compiled_archive": True}}


def main():
    if not __debug__:
        raise SystemExit("Run without -O: assertions are part of this exact verifier.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    checks = replay()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate = {
            "claim": "C180_INTEGRAL",
            "result_class": "uniform_verification_theorem",
            "independent_review": "pending",
            "novelty_status": "not_yet_certified",
            "uniform_theorem": "Under the original sphere-triangulation and state hypotheses, a nonempty pair set has a pair with Q_s a forest; nonnegative integral spoke weights give a nonzero Gaussian-integer polynomial of degree at most 2|A|F and exact order min_D c(D) at z=1.",
            "uniform_proof": "research/paired_state_audit/report.md",
            "formal_source": "research/paired_state_audit/Main.lean",
            "statement_fidelity": "research/paired_state_audit/statement_fidelity.md",
            "mechanical_scope": "Exact universal disk-equation elimination and six local corner orders; exact finite original-hypothesis graph/embedding/state/cancellation/area/grouping replays below. The official Lean certificate checks the uniform algebra, and this replay matches its archived compiled source and statement fidelity to the current files. It does not recompile Lean. Plane topology and the complete theorem are proved in prose, not inferred from the fixtures.",
            "checks": checks,
        }
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    certificate = json.loads(path.read_text())
    expected = json.loads(json.dumps(checks))
    assert certificate["checks"] == expected, "Exact replay disagrees with the certificate"
    print(json.dumps({"ok": True, "claim": certificate["claim"],
                      "fixtures": len(checks["fixtures"]),
                      "pairs": sum(r["pairs"] for r in checks["fixtures"]),
                      "involution_checks": sum(r["involution_checks"] for r in checks["fixtures"]),
                      "complete_uniform_proof": certificate["uniform_proof"],
                      "independent_review": certificate["independent_review"]},
                     sort_keys=True))


if __name__ == "__main__":
    main()
