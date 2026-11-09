#!/usr/bin/env python3
"""Exact finite fidelity replay; the all-size proof is in proof.md."""

import argparse
import json
from collections import Counter, defaultdict
from fractions import Fraction as Q
from itertools import combinations, product
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent


def edge(u, v, color):
    assert u != v
    return (min(u, v), max(u, v), color)


def matching(edges):
    result = tuple(sorted(edges))
    vertices = [v for u, v, _ in result] + [u for u, v, _ in result]
    assert len(set(result)) == len(result)
    assert len(vertices) == len(set(vertices))
    return result


class TreeGraph:
    def __init__(self, memberships, parents, d=1, variable=False, clamp=None):
        self.n = len(memberships)
        assert self.n >= 2 and self.n % 2 == 0 and d >= 1
        self.memberships = tuple(frozenset(s) for s in memberships)
        self.parents = parents
        self.d = d
        self.weights = {}
        heights = []
        for label, parent in enumerate(parents):
            assert (label == 0 and parent is None) or (
                parent is not None and 0 <= parent < label
            )
            heights.append(1 if parent is None else 2 * heights[parent])
        for s in self.memberships:
            assert 1 <= len(s) <= 2 and all(0 <= c < len(parents) for c in s)
            if len(s) == 2:
                u, v = sorted(s)
                assert parents[v] == u or parents[u] == v
        if clamp is not None:
            assert 0 < clamp[0] <= clamp[1]
        for u, v in combinations(range(self.n), 2):
            for c in self.palette(u, v):
                w = Q(heights[c] * (1 + (u + v) % 3 if variable else 1))
                assert Q(heights[c], d) <= w <= 3 * heights[c]
                if clamp is not None:
                    w = max(clamp[0], min(clamp[1], w))
                self.weights[edge(u, v, c)] = w

    def palette(self, u, v):
        return tuple(sorted(self.memberships[u] & self.memberships[v]))

    def check(self, a):
        assert matching(a) == a
        assert {v for e in a for v in e[:2]} == set(range(self.n))
        assert all(e in self.weights for e in a)

    def weight(self, a):
        result = Q(1)
        for e in a:
            result *= self.weights[e]
        return result

    def matchings(self):
        def rec(vertices):
            if not vertices:
                yield ()
                return
            u = vertices[0]
            for v in vertices[1:]:
                rest = tuple(x for x in vertices[1:] if x != v)
                for color in self.palette(u, v):
                    for tail in rec(rest):
                        yield matching((edge(u, v, color),) + tail)

        result = tuple(sorted(rec(tuple(range(self.n)))))
        assert len(result) == len(set(result)) and result
        for a in result:
            self.check(a)
        return result


def components(a, b):
    maps = [{v: e for e in layer for v in e[:2]} for layer in (a, b)]
    remaining = {v for v in maps[0] if maps[0][v] != maps[1][v]}
    result = []
    while remaining:
        start = min(remaining)
        vertices = []
        v, layer = start, 0
        while not vertices or v != start:
            assert v not in vertices
            vertices.append(v)
            e = maps[layer][v]
            v = e[1] if v == e[0] else e[0]
            layer = 1 - layer
        assert layer == 0 and len(vertices) % 2 == 0
        remaining.difference_update(vertices)
        result.append(tuple(vertices))
    return result


def swap(a, b, vertices):
    vertices = set(vertices)
    ac = {e for e in a if e[0] in vertices}
    bc = {e for e in b if e[0] in vertices}
    assert all((u in vertices) == (v in vertices) for u, v, _ in a + b)
    return matching((set(a) - ac) | bc), matching((set(b) - bc) | ac)


def proposal(g, a, b):
    row = defaultdict(Q)
    hold = (a, b)
    m = len(a)
    if m < 2:
        row[hold] += Q(1, 3)
    else:
        atom = Q(1, 3 * comb(m, 2) * 2 * 4)
        for e, f in combinations(a, 2):
            u, v = e[:2]
            x, y = f[:2]
            for pairing in (((u, x), (v, y)), ((u, y), (v, x))):
                palettes = [g.palette(*p) for p in pairing]
                for i, j in product(range(2), repeat=2):
                    if i >= len(palettes[0]) or j >= len(palettes[1]):
                        row[hold] += atom
                    else:
                        added = {
                            edge(*pairing[0], palettes[0][i]),
                            edge(*pairing[1], palettes[1][j]),
                        }
                        row[(matching((set(a) - {e, f}) | added), b)] += atom
    for e in a:
        palette = g.palette(*e[:2])
        for i in range(2):
            if i >= len(palette):
                row[hold] += Q(1, 6 * m)
            else:
                new = edge(*e[:2], palette[i])
                row[(matching((set(a) - {e}) | {new}), b)] += Q(1, 6 * m)
    cycles = components(a, b)
    if cycles:
        for c in cycles:
            row[swap(a, b, c)] += Q(1, 3 * len(cycles))
    else:
        row[hold] += Q(1, 3)
    assert sum(row.values()) == 1
    return dict(row)


def audit_kernel(name, g):
    matchings = g.matchings()
    weights = {a: g.weight(a) for a in matchings}
    z = sum(weights.values())
    pi = {a: w / z for a, w in weights.items()}
    states = tuple(product(matchings, repeat=2))
    rows = {state: proposal(g, *state) for state in states}
    f1 = lambda a: int(a == matchings[0])
    f2 = lambda b: int(b == matchings[-1])
    f = lambda state: f1(state[0]) + f2(state[1])
    energy, cycle_sum = Q(0), Q(0)
    capacities = {}
    atoms = 0
    for state, row in rows.items():
        mass = pi[state[0]] * pi[state[1]]
        accepted = defaultdict(Q)
        for dest, q in row.items():
            assert dest in rows and q == rows[dest].get(state, Q(0))
            dest_mass = pi[dest[0]] * pi[dest[1]]
            acceptance = min(Q(1), dest_mass / mass)
            accepted[dest] += q * acceptance
            accepted[state] += q * (1 - acceptance)
            capacities[(state, dest)] = mass * q * acceptance
            energy += mass * q * acceptance * (f(state) - f(dest)) ** 2 / 2
            atoms += 1
        assert sum(accepted.values()) == 1
        for c in components(*state):
            dest = swap(*state, c)
            assert g.weight(state[0]) * g.weight(state[1]) == (
                g.weight(dest[0]) * g.weight(dest[1])
            )
            cycle_sum += mass * (f(state) - f(dest)) ** 2
    for (state, dest), capacity in capacities.items():
        assert capacity == capacities[(dest, state)]
    a0 = 1000 * g.d
    safe, recolor = Q(0), Q(0)
    for a in matchings:
        for (dest, b), q in rows[(a, matchings[0])].items():
            if b != matchings[0] or dest == a:
                continue
            removed = set(a) - set(dest)
            added = set(dest) - set(a)
            if len(removed) == len(added) == 1:
                assert next(iter(removed))[:2] == next(iter(added))[:2]
                recolor += pi[a] * (f1(a) - f1(dest)) ** 2
            elif len(removed) == len(added) == 2:
                changed = [g.weights[e] for e in removed | added]
                if max(changed) <= a0 * min(changed):
                    safe += pi[a] * (f1(a) - f1(dest)) ** 2
            else:
                raise AssertionError("Unexpected first-coordinate destination")
    variance = pi[matchings[0]] * (1 - pi[matchings[0]])
    assert safe <= 60 * g.n**2 * a0**2 * energy
    assert recolor <= 12 * g.n * a0 * energy
    assert cycle_sum <= 6 * g.n * energy
    assert variance <= 44040192 * g.n**12 * a0**6 * energy
    return {
        "name": name,
        "vertices": g.n,
        "colored_matchings": len(matchings),
        "pair_states": len(states),
        "aggregated_proposal_entries": atoms,
        "partition_function": str(z),
        "variance": str(variance),
        "additive_energy": str(energy),
        "safe_switch_sum": str(safe),
        "color_change_sum": str(recolor),
        "component_swap_sum": str(cycle_sum),
        "stochastic_symmetric_reversible": True,
    }


def arc_indices(start, end, size, direction=1):
    result = [start]
    while result[-1] != end:
        result.append((result[-1] + direction) % size)
        assert len(result) <= size
    return tuple(result)


def quadrangulation(colors):
    size = len(colors)
    sv = [set((colors[i - 1], colors[i])) for i in range(size)]
    cells = []

    def split(path):
        s = len(path) - 1
        if s == 1:
            return
        assert s >= 3 and s % 2 == 1
        direction = 1 if path[1] == (path[0] + 1) % size else -1
        exterior = arc_indices(path[-1], path[0], size, direction)
        good = len(exterior) == 2 or bool(sv[exterior[1]] & sv[exterior[-2]])
        p = min(sv[path[0]] & sv[path[-1]])
        if not good and p in sv[exterior[-2]]:
            path = tuple(reversed(path))
            direction = -direction
            exterior = arc_indices(path[-1], path[0], size, direction)
        labels = [
            colors[u] if direction == 1 else colors[v]
            for u, v in zip(path, path[1:])
        ]
        if good:
            if p not in labels:
                assert labels[0] == labels[-1]
                p = labels[0]
            odd = [i for i in range(1, s, 2) if labels[i] == p]
            occurrences = [i for i, label in enumerate(labels) if label == p]
            if odd:
                p1, p2 = odd[0], odd[0] + 1
            elif occurrences[0] > 0:
                p1, p2 = occurrences[0] - 1, occurrences[0]
            elif occurrences[-1] < s - 1:
                p1, p2 = occurrences[-1] + 1, occurrences[-1] + 2
            else:
                p1, p2 = 1, s - 1
        else:
            assert p not in sv[exterior[-2]] and labels[0] == p
            if labels[-1] == p:
                p1, p2 = 1, s - 1
            else:
                t = max(i for i, label in enumerate(labels) if label == p) + 1
                assert labels[t] == labels[-1]
                p1, p2 = (1, t) if t % 2 == 0 else (t, s - 1)
        assert 0 < p1 < p2 < s and p1 % 2 == 1 and p2 % 2 == 0
        cells.append(tuple(sorted((path[0], path[p1], path[p2], path[-1]))))
        split(path[: p1 + 1])
        split(path[p1 : p2 + 1])
        split(path[p2:])

    split(tuple(range(size)))
    assert len(cells) == (size - 2) // 2 and len(set(cells)) == len(cells)
    return tuple(cells)


def arc_data(colors, start, end):
    size = len(colors)
    path = arc_indices(start, end, size)
    assert (len(path) - 1) % 2 == 1
    sv = lambda i: {colors[i - 1], colors[i]}
    common = sv(start) & sv(end)
    assert common
    edges = [edge(u, v, colors[u]) for u, v in zip(path, path[1:])]
    chord = edges[0] if len(edges) == 1 else edge(start, end, min(common))
    through, interior = frozenset(edges[::2]), frozenset(edges[1::2])
    repair = None
    if len(edges) > 1 and sv(path[1]) & sv(path[-2]):
        repair = edge(path[1], path[-2], min(sv(path[1]) & sv(path[-2])))
    return {
        "path": path, "T": through, "N": interior,
        "C": interior | {chord}, "chord": chord, "repair": repair,
        "long": len(edges) > 1, "boundary": (edges[0], edges[-1]),
    }


def form(*terms):
    result = Counter()
    for a, coefficient in terms:
        result[a] += coefficient
    return {a: c for a, c in result.items() if c}


def form_sum(terms):
    return form(*[(a, scale * c) for term, scale in terms for a, c in term.items()])


def convert(a, arc):
    assert arc["T"] <= set(a)
    return matching((set(a) - arc["T"]) | arc["C"])


def cell_data(g, colors, cell):
    cycle = tuple(edge(i, (i + 1) % g.n, c) for i, c in enumerate(colors))
    orientations = (matching(cycle[::2]), matching(cycle[1::2]))
    arcs = [arc_data(colors, cell[i], cell[(i + 1) % 4]) for i in range(4)]
    pairs = ((0, 2), (1, 3))
    good = lambda i: not arcs[i]["long"] or arcs[i]["repair"] is not None
    assert any(all(good(i) for i in pair) for pair in pairs)
    for k, pair in enumerate(pairs):
        if all(arcs[i]["long"] for i in pair):
            assert all(good(i) for i in pairs[1 - k])
    p = tuple(i for i in range(4) if arcs[i]["T"] <= set(orientations[0]))
    q = tuple(i for i in range(4) if i not in p)
    assert p in pairs and q in pairs
    interior = set().union(*(arc["N"] for arc in arcs))
    ap = matching(interior | {arcs[i]["chord"] for i in p})
    aq = matching(interior | {arcs[i]["chord"] for i in q})
    gains, errors = [], {}
    for arc in arcs:
        orientation = next(a for a in orientations if arc["T"] <= set(a))
        gains.append(form((orientation, 1), (convert(orientation, arc), -1)))
    for pair in pairs:
        x, y = pair
        a0 = next(a for a in orientations if arcs[x]["T"] <= set(a))
        a1 = convert(a0, arcs[y])
        ax = convert(a0, arcs[x])
        axy = convert(a1, arcs[x])
        errors[pair] = form((a1, 1), (axy, -1), (a0, -1), (ax, 1))
        if not all(arcs[i]["long"] for i in pair):
            assert not errors[pair]
        for a in (a0, a1, ax, axy):
            g.check(a)
    delta = form((ap, 1), (aq, -1))
    d = form((orientations[0], 1), (orientations[1], -1))
    rhs = [(delta, 1), (errors[p], 1), (errors[q], -1)]
    rhs += [(gains[i], 1 if i in p else -1) for i in range(4)]
    assert d == form_sum(rhs)
    for a in (ap, aq):
        g.check(a)
    changed = [arc["chord"] for arc in arcs]
    changed += [e for arc in arcs for e in arc["boundary"]]
    changed += [arc["repair"] for arc in arcs if arc["repair"] is not None]
    assert max(g.weights[e] for e in changed) <= 1000 * g.d * min(
        g.weights[e] for e in changed
    )
    return arcs, p, q, ap, aq, errors, delta


def audit_cycle(g, colors):
    cells = quadrangulation(colors)
    terms, diagonal_occurrences = [], Counter()
    for cell in cells:
        arcs, p, q, ap, aq, errors, delta = cell_data(g, colors, cell)
        terms += [(delta, 1), (errors[p], 1), (errors[q], -1)]
        for arc in arcs:
            if arc["long"]:
                diagonal_occurrences[arc["chord"]] += 1
    cycle = tuple(edge(i, (i + 1) % g.n, c) for i, c in enumerate(colors))
    d = form((matching(cycle[::2]), 1), (matching(cycle[1::2]), -1))
    assert form_sum(terms) == d
    assert len(diagonal_occurrences) == (g.n - 4) // 2
    assert all(count == 2 for count in diagonal_occurrences.values())
    return cells


def compact_tag(g, i1, i2, cell, arcs, chord_pair, repair_pair, kind):
    leaves, long_bits = [], []
    colors = []
    for i in chord_pair:
        e = arcs[i]["chord"]
        colors.append(g.palette(*e[:2]).index(e[2]))
    for i in repair_pair:
        arc = arcs[i]
        long_bits.append(int(arc["long"]))
        leaves += list((arc["path"][1], arc["path"][-2]) if arc["long"] else
                       (cell[i], cell[i]))
        e = arc["repair"]
        colors.append(0 if e is None else g.palette(*e[:2]).index(e[2]))
    for i in repair_pair:
        first, last = arcs[i]["boundary"]
        colors += [g.palette(*first[:2]).index(first[2]),
                   g.palette(*last[:2]).index(last[2]) if arcs[i]["long"] else 0]
    incident = sorted(e for e in i1 + i2 if cell[0] in e[:2])
    orientation = int(incident[0] not in i1)
    pairs = ((0, 2), (1, 3))
    bits = [orientation, 0, pairs.index(chord_pair), pairs.index(repair_pair),
            *long_bits, 0]
    flag = kind
    for bit in bits:
        assert bit in (0, 1)
        flag = 2 * flag + bit
    assert 0 <= flag < 384 and len(colors) == len(cell + tuple(leaves)) == 8
    return flag, cell + tuple(leaves), tuple(colors)


def decode(g, a, b, tag):
    flag, vertices, colors = tag
    bits = []
    for _ in range(7):
        flag, bit = divmod(flag, 2)
        bits.append(bit)
    orientation, direction, hp, gp, long0, long1, order = reversed(bits)
    assert flag in range(3) and direction in range(2) and order in range(2)
    corners = vertices[:4]
    pairs = ((0, 2), (1, 3))
    add, drop = [], []

    def colored(u, v, slot):
        palette = g.palette(u, v)
        assert colors[slot] < len(palette)
        return edge(u, v, palette[colors[slot]])

    for k, i in enumerate(pairs[hp]):
        add.append(colored(corners[i], corners[(i + 1) % 4], k))
    for k, (i, is_long) in enumerate(zip(pairs[gp], (long0, long1))):
        u, v = vertices[4 + 2 * k: 6 + 2 * k]
        if is_long:
            add.append(colored(u, v, 2 + k))
            drop += [colored(corners[i], u, 4 + 2 * k),
                     colored(v, corners[(i + 1) % 4], 5 + 2 * k)]
        else:
            assert u == v == corners[i]
            drop.append(colored(corners[i], corners[(i + 1) % 4], 4 + 2 * k))
    union = Counter(a + b)
    for e in add:
        assert union[e] > 0
        union[e] -= 1
        if union[e] == 0:
            del union[e]
    union.update(drop)
    adjacency = defaultdict(list)
    for e, multiplicity in union.items():
        for _ in range(multiplicity):
            for v in e[:2]:
                adjacency[v].append(e)
    assert all(len(es) == 2 for es in adjacency.values())
    v = corners[0]
    first = min(adjacency[v])
    path_edges, cycle_vertices = [], []
    current = first
    while not cycle_vertices or v != corners[0]:
        assert v not in cycle_vertices
        cycle_vertices.append(v)
        path_edges.append(current)
        v = current[1] if v == current[0] else current[0]
        current = next(e for e in adjacency[v] if e != current)
    assert len(cycle_vertices) >= 4
    outside_a = {e for e in a if e[0] not in cycle_vertices}
    outside_b = {e for e in b if e[0] not in cycle_vertices}
    return (
        matching(outside_a | set(path_edges[orientation::2])),
        matching(outside_b | set(path_edges[1 - orientation::2])),
    )


def encode_demands(g, colors, i1, i2):
    outputs = []
    rho = g.weight(i1) * g.weight(i2)
    pairs = ((0, 2), (1, 3))
    for cell in quadrangulation(colors):
        arcs, _, _, _, _, _, _ = cell_data(g, colors, cell)
        p = next(pair for pair in pairs if arcs[pair[0]]["T"] <= set(i1))
        interior = set().union(*(arc["N"] for arc in arcs))
        ap = matching(interior | {arcs[i]["chord"] for i in p})
        good = lambda i: not arcs[i]["long"] or arcs[i]["repair"] is not None
        gp = next(pair for pair in pairs if all(good(i) for i in pair))
        all_through = set().union(*(arc["T"] for arc in arcs))

        def repair(edges, selected):
            edges = set(edges)
            for i in selected:
                edges.difference_update(arcs[i]["boundary"])
                if arcs[i]["long"]:
                    assert arcs[i]["repair"] is not None
                    edges.add(arcs[i]["repair"])
            return matching(edges)

        b = repair(all_through, gp)
        outputs.append((ap, b, compact_tag(g, i1, i2, cell, arcs, p, gp, 0), None))
        for hp in pairs:
            if not all(arcs[i]["long"] for i in hp):
                continue
            x, y = hp
            a0 = next(a for a in (i1, i2) if arcs[x]["T"] <= set(a))
            opposite = i2 if a0 == i1 else i1
            gp = pairs[1 - pairs.index(hp)]
            assert all(good(i) for i in gp)
            b0 = repair(set(opposite) | {arcs[i]["chord"] for i in hp}, gp)
            a1 = convert(a0, arcs[y])
            assert arcs[y]["C"] <= set(b0)
            b1 = matching((set(b0) - arcs[y]["C"]) | arcs[y]["T"])
            for j, (a, b) in enumerate(((a0, b0), (a1, b1))):
                assert arcs[x]["T"] <= set(a) and arcs[x]["C"] <= set(b)
                tag = compact_tag(g, i1, i2, cell, arcs, hp, gp, 1 + j)
                outputs.append((a, b, tag, arcs[x]))
    for a, b, tag, arc in outputs:
        g.check(a)
        g.check(b)
        assert rho <= (1000 * g.d) ** 4 * g.weight(a) * g.weight(b)
        assert decode(g, a, b, tag) == (i1, i2)
        original, encoded = Counter(i1 + i2), Counter(a + b)
        assert sum((original - encoded).values()) <= 4
        assert sum((encoded - original).values()) <= 4
    return outputs


def audit_eight_cycle(clamp):
    memberships = [(0, 1) if i in (0, 3, 4, 7) else (1, 2) for i in range(8)]
    g = TreeGraph(memberships, (None, 0, 1), clamp=clamp)
    colors = (1, 2, 1, 0, 1, 2, 1, 0)
    cells = audit_cycle(g, colors)
    assert (0, 3, 4, 7) in cells
    arcs, p, q, ap, aq, errors, delta = cell_data(g, colors, (0, 3, 4, 7))
    x, y = arcs[0], arcs[2]
    tt = matching(edge(i, (i + 1) % 8, colors[i]) for i in range(0, 8, 2))
    other = matching(edge(i, (i + 1) % 8, colors[i]) for i in range(1, 8, 2))
    ct, tc = convert(tt, x), convert(tt, y)
    cc = convert(tc, x)
    assert len({tt, ct, tc, cc}) == 4
    f1 = lambda a: Q(int(a == tt))
    f2 = lambda a: Q(int(a == cc))
    derivative = lambda f, a, arc: f(a) - f(convert(a, arc))
    error = derivative(f1, tc, x) - derivative(f1, tt, x)
    assert error == -1
    encoded = []
    seen = {}
    for i1, i2 in ((tt, other), (other, tt)):
        for a, b, tag, identity in encode_demands(g, colors, i1, i2):
            key = (a, b, tag)
            demand = (i1, i2, tag)
            assert key not in seen or seen[key] == demand
            seen[key] = demand
            encoded.append((i1, i2, a, b, tag, identity))
    matchings = g.matchings()
    z = sum(g.weight(a) for a in matchings)
    pi = {a: g.weight(a) / z for a in matchings}
    guides = [b for b in matchings if x["C"] <= set(b)]
    through = [a for a in matchings if x["T"] <= set(a)]
    p_x = sum(pi[b] for b in guides)
    assert 0 < p_x < 1
    guide_derivative = lambda b: f2(matching((set(b) - x["C"]) | x["T"])) - f2(b)
    mu = sum(pi[b] * guide_derivative(b) for b in guides) / p_x
    centered_left, swap_sum = Q(0), Q(0)
    swap_pairs = 0
    for a in through:
        u = derivative(f1, a, x)
        centered_left += pi[a] * p_x * (u - mu) ** 2
        local = Q(0)
        for b in guides:
            component = x["path"]
            matching_components = components(a, b)
            assert sum(set(c) == set(component) for c in matching_components) == 1
            new_a, new_b = swap(a, b, component)
            value = u - guide_derivative(b)
            assert value == f1(a) + f2(b) - f1(new_a) - f2(new_b)
            assert g.weight(a) * g.weight(b) == g.weight(new_a) * g.weight(new_b)
            local += pi[b] * value**2
            swap_pairs += 1
        assert p_x * (u - mu) ** 2 <= local
        swap_sum += pi[a] * local
    assert centered_left <= swap_sum
    mass_groups = defaultdict(Q)
    output_counts = Counter()
    for i1, i2, a, b, tag, identity in encoded:
        if identity is None:
            continue
        key = (identity["path"], identity["chord"], tag[0] // 128, a)
        mass_groups[key] += pi[i1] * pi[i2]
        output_counts[(tag[0] // 128, a, b)] += 1
        identity_mass = sum(pi[c] for c in matchings if identity["C"] <= set(c))
        assert identity_mass > 0
    for (path, chord, kind, a), mass in mass_groups.items():
        closed = arc_data(colors, path[0], path[-1])["C"]
        identity_mass = sum(pi[b] for b in matchings if closed <= set(b))
        assert mass <= (1000 * g.d) ** 4 * 2**17 * g.n**8 * pi[a] * identity_mass
    return {
        "clamp": None if clamp is None else [str(q) for q in clamp],
        "colored_matchings": len(matchings),
        "cells": [list(c) for c in cells],
        "opposite_long_context_values": [str(f1(a)) for a in (tt, ct, tc, cc)],
        "context_error": str(error),
        "context_error_squared": str(error**2),
        "encoded_demands_including_contexts": len(encoded),
        "max_tested_encoding_preimages": max(output_counts.values()),
        "guide_count": len(guides),
        "through_count": len(through),
        "p_X": str(p_x),
        "conditional_guide_mean": str(mu),
        "p_weighted_center_sum": str(centered_left),
        "individual_identity_swap_sum": str(swap_sum),
        "checked_arc_swap_pairs": swap_pairs,
    }


def audit_label_walks():
    results = []
    for size in (4, 6, 8):
        checked = 0
        cells = 0
        for colors in product(range(3), repeat=size):
            if any(abs(colors[i] - colors[i - 1]) > 1 for i in range(size)):
                continue
            memberships = [tuple(sorted({colors[i - 1], colors[i]}))
                           for i in range(size)]
            g = TreeGraph(memberships, (None, 0, 1))
            result = audit_cycle(g, colors)
            cells += len(result)
            checked += 1
        results.append({"cycle_length": size, "closed_label_walks": checked,
                        "checked_cells": cells})
    return results


def replay():
    flag_count = 3 * 2 * 2 * 2 * 2 * 4 * 2
    assert flag_count == 384 and flag_count * 2**8 <= 2**17
    assert 336 * 2**17 == 44040192
    assert 336 * 2**17 * 1000**6 <= 10000**100
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    jacobian = json.loads((HERE / "jacobian_output.json").read_text())
    assert jacobian["request"]["payload"] == payload
    assert jacobian["result"]["operation_id"] == "quadratic_form.evaluate.compute"
    assert jacobian["result"]["output"]["value"] == {"num": "1", "den": "1"}
    vector = [Q(c["num"]) / Q(c["den"]) for c in payload["vector"]["coordinates"]]
    coefficients = payload["form"]
    value = sum(Q(c["num"]) / Q(c["den"]) * x**2 for c, x in
                zip(coefficients["diagonal_coefficients"], vector))
    value += sum(Q(t["coefficient"]["num"]) / Q(t["coefficient"]["den"]) *
                 vector[t["left"]] * vector[t["right"]]
                 for t in coefficients["cross_terms"])
    assert value == 1
    return {
        "result_class": "improved_bound",
        "review_status": "independent_review_required_not_performed",
        "all_size_evidence": "proof.md; Main.lean certifies only the core scoped in statement_fidelity.md",
        "comparison": {"coefficient": 44040192, "N_exponent": 12,
                       "activity_comparability_exponent": 6,
                       "tag_vertices": 8, "tag_binary_colors": 8,
                       "tag_flags": flag_count, "tag_bound": "2^17 N^8",
                       "source_bound": "10^51 N^34 D^6",
                       "tree_bag_activity_comparability": "1000D"},
        "kernel_cases": [
            audit_kernel("two_vertices_parallel_colors",
                         TreeGraph([(0, 1)] * 2, (None, 0))),
            audit_kernel("four_vertices_absent_second_index",
                         TreeGraph([(0,)] * 4, (None,))),
            audit_kernel("four_vertices_nonuniform_parallel_colors",
                         TreeGraph([(0, 1)] * 4, (None, 0), d=2, variable=True)),
            audit_kernel("four_vertices_common_clamp",
                         TreeGraph([(0, 1)] * 4, (None, 0), d=2, variable=True,
                                   clamp=(Q(3, 2), Q(7, 2)))),
        ],
        "label_walk_exhaustions": audit_label_walks(),
        "eight_cycle": [audit_eight_cycle(None), audit_eight_cycle((Q(3, 2), Q(3)))],
        "jacobian": {"server": jacobian["server"]["name"],
                     "server_version": jacobian["server"]["version"],
                     "protocol_version": jacobian["protocol_version"],
                     "operation_id": jacobian["result"]["operation_id"],
                     "adapter_exit_code": 0, "structured_error": None,
                     "timeout": False, "exact_value": str(value)},
        "limits": [
            "Finite replays are not the all-size proof.",
            "Lean checks the explicitly scoped abstract core, not graph encodings.",
            "No false staged assertion was established.",
            "Headline FPRAS, entropy, novelty and significance are not certified here.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = replay()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert json.loads(path.read_text()) == result, "Exact certificate differs from replay"
    print(json.dumps({"ok": True, "certificate": str(path),
                      "kernel_cases": len(result["kernel_cases"]),
                      "closed_label_walks": sum(r["closed_label_walks"]
                                               for r in result["label_walk_exhaustions"]),
                      "eight_cycle_error_squared": [r["context_error_squared"]
                                                    for r in result["eight_cycle"]]}))


if __name__ == "__main__":
    main()
