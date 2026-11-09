#!/usr/bin/env python3
"""Replay exact algebra, graph-realizable probes, and the universal Lean evidence."""

import argparse
import hashlib
import itertools
import json
import re
import subprocess
from collections import defaultdict
from fractions import Fraction as F
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def zeros(n):
    return [[F(0) for _ in range(n)] for _ in range(n)]


def eye(n):
    result = zeros(n)
    for i in range(n):
        result[i][i] = F(1)
    return result


def add(*terms):
    n = len(terms[0][1])
    return [
        [sum((scale * a[i][j] for scale, a in terms), F(0)) for j in range(n)]
        for i in range(n)
    ]


def mul(a, b):
    result = zeros(len(a))
    rows = [[(j, value) for j, value in enumerate(row) if value] for row in b]
    for i, row in enumerate(a):
        for k, value in enumerate(row):
            if value:
                for j, other in rows[k]:
                    result[i][j] += value * other
    return result


def apply(a, vector):
    return [sum((x * y for x, y in zip(row, vector)), F(0)) for row in a]


def psd(a, label):
    n = len(a)
    assert all(a[i][j] == a[j][i] for i in range(n) for j in range(n)), label
    work = [row[:] for row in a]
    rank = 0
    for k in range(n):
        pivot = work[k][k]
        assert pivot >= 0, (label, "negative exact Schur pivot", k, str(pivot))
        if not pivot:
            assert all(not work[k][j] for j in range(k + 1, n)), (
                label, "zero diagonal with nonzero row", k
            )
            continue
        rank += 1
        nonzero = [i for i in range(k + 1, n) if work[i][k]]
        for position, i in enumerate(nonzero):
            for j in nonzero[position:]:
                value = work[i][j] - work[i][k] * work[k][j] / pivot
                work[i][j] = work[j][i] = value
    return rank


def projector(vector):
    norm = sum((x * x for x in vector), F(0))
    if not norm:
        return zeros(len(vector))
    return [[x * y / norm for y in vector] for x in vector]


def universal_algebra():
    n, q, r, p, rho, x, y, left, right, center = sp.symbols(
        "N q r p rho x y L R C"
    )
    probability = (q * (q - 1) + r * (r - 1)) / (n * (n - 1))
    mu1 = (q - r) ** 2 / (2 * (n - 2) * probability)
    mu2 = 2 * (q - 1) * (r - 1) / ((n - 3) * (n - 2) * probability)

    def zero(expression):
        assert sp.factor(expression.subs(n, q + r)) == 0, str(expression)

    zero(
        (n - 1) * (n * (n - 2) * probability - (q - r) ** 2)
        - 2 * n * (q - 1) * (r - 1)
    )
    zero(
        n * ((n - 1) * (n - 2) * probability - 2 * (q - 1) * (r - 1))
        - (n - 1) * (q - r) ** 2
    )
    pairs = n * (n - 1) / 2
    zero((n - 1) * mu1 + (pairs - n) * mu2 - pairs)
    assert sp.expand(
        (1 - rho ** 2) * (x * x + y * y + 2 * rho * x * y)
        - (1 - rho ** 2) *
        (rho * (x + y) ** 2 + (1 - rho) * (x * x + y * y))
    ) == 0
    assert sp.expand(
        (left + center) * (right + center) - left * right
        - center * (left + right + center)
    ) == 0

    # These are binomial-count factors, not probabilities inferred from samples.
    a0, a1, a2, b0, b1, b2 = sp.symbols("a0 a1 a2 b0 b1 b2")
    weights = sp.Matrix([
        [0, a0 * b1, 0],
        [a1 * b0, 2 * a1 * b1, a1 * b2],
        [0, a2 * b1, 0],
    ])
    total = sum(weights)
    row = weights * sp.ones(3, 1)
    column = sp.ones(1, 3) * weights
    covariance_numerator = total * weights - row * column
    for rows in itertools.combinations(range(3), 2):
        for columns in itertools.combinations(range(3), 2):
            assert sp.factor(covariance_numerator.extract(rows, columns).det()) == 0
    assert any(value != 0 for value in covariance_numerator)
    for s in (0, 1, 3, 4):
        table = sp.zeros(3)
        for bits in itertools.product((0, 1), repeat=4):
            if sum(bits) == s:
                table[bits[0] + bits[1], bits[0] + bits[2]] += 1
        assert table.rank() == 1, (s, table)
    m = sp.symbols("m", positive=True)
    interaction = 2 * (2 * (-m ** 2 / (m + 2) ** 2)) / (2 * m + 2)
    error = (m * 4 / (m + 2) ** 2 + 2 * m ** 2 / (m + 2) ** 2) / (2 * m + 2)
    assert sp.factor(interaction + 2 * m ** 2 / ((m + 1) * (m + 2) ** 2)) == 0
    assert sp.factor(error - m / ((m + 1) * (m + 2))) == 0
    assert sp.factor(-interaction / (2 * error) - m / (m + 2)) == 0
    return {
        "domain": "all integers N>=0, 0<=q<=N; interior formulas use N>=3, 1<=q<=N-1; mu2 uses N>=4",
        "identities": [
            "(N-1)*(N*(N-2)*p-(q-r)^2)=2*N*(q-1)*(r-1)",
            "N*((N-1)*(N-2)*p-2*(q-1)*(r-1))=(N-1)*(q-r)^2",
            "(N-1)*mu1+(N*(N-1)/2-N)*mu2=N*(N-1)/2",
            "(1-rho^2)*(x^2+y^2+2*rho*x*y)=(1-rho^2)*(rho*(x+y)^2+(1-rho)*(x^2+y^2))",
            "(L+C)*(R+C)-L*R=C*(L+R+C)",
        ],
        "cell_centered_correlation_rank": 1,
        "independent_cross_totals": [0, 1, 3, 4],
        "sign_reason": "q,r>=1 imply (q-1)(r-1)>=0; squares>=0; N>=4 implies N-3>=1; 0<=rho<1 makes every plane-square coefficient nonnegative",
        "sharp_slice_coefficients": {
            "p": "(q*(q-1)+r*(r-1))/(N*(N-1)), r=N-q",
            "mu1": "(q-r)^2/(2*(N-2)*p)",
            "mu2": "2*(q-1)*(r-1)/((N-3)*(N-2)*p)",
            "comparison": "S<=max(2*mu1/N,mu2/(N-1))*G for N>=4, 1<=q<=N-1; the zero-image coefficient may be omitted",
            "second_ratio_bound": "mu2/(N-1)<=1/(N-3)<=1",
        },
        "scope": "exact symbolic identities plus the explicitly stated sign hypotheses; the all-graph implication is also checked by Lean, not inferred from these formulas alone",
        "graph_realizable_sharpness": {
            "parameter": "every positive integer m",
            "n": "m+4",
            "degree_vector": "(1,m+1,1,m+1,2,...,2), with m entries equal to 2",
            "cell_count": "2*m+2",
            "twice_interaction_conditional": "-2*m^2/((m+1)*(m+2)^2)",
            "each_directed_error_energy_conditional": "m/((m+1)*(m+2))",
            "gain_energy": "0",
            "necessary_error_coefficient": "m/(m+2)",
            "consequence": "the uniform coefficient 1 multiplying both directed errors in the manuscript local interaction inequality is optimal",
            "formal_scope": "Lean checks the all-real rational identity and the unbounded natural-parameter ratio; graph realization and counting are proved in report.md",
        },
    }


def slice_probes():
    checked = 0
    zero_linear = 0
    zero_quadratic = 0
    equality = None
    for n in range(8):
        pairs = list(itertools.combinations(range(n), 2))
        for q in range(n + 1):
            states = [frozenset(s) for s in itertools.combinations(range(n), q)]
            count = len(states)
            index = {state: i for i, state in enumerate(states)}
            s_operator = zeros(count)
            g_operator = zeros(count)
            centered = {}
            for i, j in pairs:
                indicators = [F((i in state) == (j in state)) for state in states]
                mean = sum(indicators) / count
                z = [value - mean for value in indicators]
                centered[i, j] = z
                s_operator = add((1, s_operator), (1, projector(z)))
                for k, state in enumerate(states):
                    image = state
                    if (i in state) != (j in state):
                        image = state.symmetric_difference((i, j))
                    g_operator[k][k] += F(1, 2)
                    g_operator[k][index[image]] -= F(1, 2)
            psd(add((1, g_operator), (-1, s_operator)), ("slice", n, q))
            if n >= 3 and 0 < q < n:
                p = F(q * (q - 1) + (n - q) * (n - q - 1), n * (n - 1))
                mu1 = F((2 * q - n) ** 2, 2 * (n - 2)) / p
                linear = [F((0 in state) - (1 in state)) for state in states]
                assert apply(s_operator, linear) == [mu1 * z for z in linear]
                assert apply(g_operator, linear) == [F(n, 2) * z for z in linear]
                if 2 * q == n:
                    image = [
                        sum((F((i == 0) - (i == 1) + (j == 0) - (j == 1)) *
                             centered[i, j][k] for i, j in pairs), F(0))
                        for k in range(count)
                    ]
                    assert not any(image)
                    zero_linear += 1
                if n >= 4:
                    mu2 = F(2 * (q - 1) * (n - q - 1), (n - 3) * (n - 2)) / p
                    quadratic = [
                        F(((0 in t) - (1 in t)) * ((2 in t) - (3 in t)))
                        for t in states
                    ]
                    assert apply(s_operator, quadratic) == [mu2 * z for z in quadratic]
                    assert apply(g_operator, quadratic) == [F(n - 1) * z for z in quadratic]
                    if q in (1, n - 1):
                        assert not any(quadratic)
                        zero_quadratic += 1
                    if (n, q) == (4, 2):
                        assert any(quadratic)
                        assert apply(add((1, g_operator), (-1, s_operator)), quadratic) == [0] * count
                        equality = {"N": n, "q": q, "mu1": str(mu1), "mu2": str(mu2),
                                    "witness": [str(z) for z in quadratic]}
            checked += 1
    assert equality is not None
    return {"scope": "every uniform q-subset slice with 0<=N<=7",
            "slices": checked, "balanced_zero_linear_images": zero_linear,
            "extreme_zero_quadratic_images": zero_quadratic,
            "N4_q2_equality": equality}


class Graphs:
    def __init__(self, n):
        self.n = n
        self.edges = list(itertools.combinations(range(n), 2))
        self.bit = {edge: 1 << k for k, edge in enumerate(self.edges)}
        self.pairs = self.edges

    def adjacent(self, state, i, j):
        return bool(state & self.bit[tuple(sorted((i, j)))])

    def degrees(self, state):
        return tuple(sum(self.adjacent(state, i, j)
                         for j in range(self.n) if j != i) for i in range(self.n))

    def fiber_key(self, state, pair):
        outside = [i for i in range(self.n) if i not in pair]
        return (
            tuple(self.adjacent(state, i, j)
                  for i, j in self.edges if i not in pair and j not in pair),
            self.adjacent(state, *pair),
            tuple(sum(self.adjacent(state, i, w) for i in pair) for w in outside),
        )

    def cell_key(self, state, a, b):
        outside = [i for i in range(self.n) if i not in a + b]
        return (
            tuple(self.adjacent(state, i, j) for i, j in itertools.combinations(outside, 2)),
            self.adjacent(state, *a), self.adjacent(state, *b),
            tuple((sum(self.adjacent(state, i, w) for i in a),
                   sum(self.adjacent(state, j, w) for j in b)) for w in outside),
        )

    def singleton(self, state, pair):
        return tuple(w for w in range(self.n) if w not in pair
                     and sum(self.adjacent(state, i, w) for i in pair) == 1)

    def cross(self, state, a, b):
        return tuple(int(self.adjacent(state, i, j)) for i in a for j in b)

    def encode(self, state, a, b):
        outside = [i for i in range(self.n) if i not in a + b]
        aa = tuple(w for w in outside if w in self.singleton(state, a))
        bb = tuple(w for w in outside if w in self.singleton(state, b))
        u = tuple(w for w in aa if self.adjacent(state, a[0], w))
        w = tuple(w for w in bb if self.adjacent(state, b[0], w))
        return self.cross(state, a, b), u, w

    def decode_cell(self, base, a, b):
        outside = [i for i in range(self.n) if i not in a + b]
        aa = tuple(w for w in outside if w in self.singleton(base, a))
        bb = tuple(w for w in outside if w in self.singleton(base, b))
        degrees = self.degrees(base)
        q0 = degrees[a[0]] - self.adjacent(base, *a)
        q1 = degrees[b[0]] - self.adjacent(base, *b)
        fixed = 0
        for i, j in self.edges:
            if (i in outside and j in outside) or (i, j) in (a, b):
                if self.adjacent(base, i, j):
                    fixed |= self.bit[i, j]
        for pair, singletons in ((a, aa), (b, bb)):
            for w in outside:
                if w not in singletons and self.adjacent(base, pair[0], w):
                    for i in pair:
                        fixed |= self.bit[tuple(sorted((i, w)))]
                    if pair == a:
                        q0 -= 1
                    else:
                        q1 -= 1
        total = sum(self.cross(base, a, b))
        result = {}
        for cross in itertools.product((0, 1), repeat=4):
            if sum(cross) != total:
                continue
            size_u = q0 - cross[0] - cross[1]
            size_w = q1 - cross[0] - cross[2]
            if not (0 <= size_u <= len(aa) and 0 <= size_w <= len(bb)):
                continue
            for u in itertools.combinations(aa, size_u):
                for w in itertools.combinations(bb, size_w):
                    state = fixed
                    for value, (i, j) in zip(cross, itertools.product(a, b)):
                        if value:
                            state |= self.bit[tuple(sorted((i, j)))]
                    for pair, singles, chosen in ((a, aa, u), (b, bb, w)):
                        for v in singles:
                            edge = tuple(sorted((pair[0] if v in chosen else pair[1], v)))
                            state |= self.bit[edge]
                    assert self.degrees(state) == degrees
                    encoding = (cross, u, w)
                    assert state not in result
                    assert self.encode(state, a, b) == encoding
                    result[state] = encoding
        return result, len(set(aa) & set(bb))


def grouped(values, key):
    groups = defaultdict(list)
    for value in values:
        groups[key(value)].append(value)
    return list(groups.values())


def graph_probe(world, states, summary):
    count = len(states)
    index = {state: i for i, state in enumerate(states)}
    fibers = {}
    fluctuations = {}
    for a in world.pairs:
        fibers[a] = grouped(states, lambda s: world.fiber_key(s, a))
        expectation = zeros(count)
        for fiber in fibers[a]:
            singles = world.singleton(fiber[0], a)
            q = sum(world.adjacent(fiber[0], a[0], w) for w in singles)
            assert len(fiber) == sp.binomial(len(singles), q)
            if q in (0, len(singles)):
                summary["degenerate_fibers"] += 1
            for s in fiber:
                for t in fiber:
                    expectation[index[s]][index[t]] = F(1, len(fiber))
        fluctuations[a] = add((1, eye(count)), (-1, expectation))
    budgets = {a: zeros(count) for a in world.pairs}
    d_operator = zeros(count)
    local_residual_sum = zeros(count)
    for a, b in itertools.combinations(world.pairs, 2):
        if set(a) & set(b):
            continue
        gain = zeros(count)
        errors = []
        for s in states:
            cross = world.cross(s, a, b)
            if (cross[0] + cross[1] == cross[2] + cross[3] ==
                    cross[0] + cross[2] == cross[1] + cross[3] == 1):
                toggled = s
                for i, j in itertools.product(a, b):
                    toggled ^= world.bit[tuple(sorted((i, j)))]
                assert toggled in index
                gain[index[s]][index[s]] = F(1, 2)
                gain[index[s]][index[toggled]] = -F(1, 2)
        for first, second in ((a, b), (b, a)):
            error = zeros(count)
            for fiber in fibers[first]:
                if not set(second) <= set(world.singleton(fiber[0], first)):
                    summary["zero_error_fibers"] += 1
                    continue
                values = [F(world.adjacent(s, first[0], second[0]) ==
                            world.adjacent(s, first[0], second[1])) for s in fiber]
                mean = sum(values) / len(values)
                z = [v - mean for v in values]
                block = projector(z)
                if not any(z):
                    summary["zero_error_fibers"] += 1
                for i, s in enumerate(fiber):
                    for j, t in enumerate(fiber):
                        error[index[s]][index[t]] = block[i][j]
            errors.append(error)
        for cell in grouped(states, lambda s: world.cell_key(s, a, b)):
            encodings, overlap = world.decode_cell(cell[0], a, b)
            assert set(encodings) == set(cell), ("graph-cell bijection", world.n, a, b)
            summary["max_outside_singleton_overlap"] = max(
                summary["max_outside_singleton_overlap"], overlap)
            if overlap:
                summary["overlapping_cells"] += 1
            total = sum(world.cross(cell[0], a, b))
            if total == 2 and not any(
                sum(world.cross(s, a, b)[:2]) == 1 and
                world.cross(s, a, b)[0] + world.cross(s, a, b)[2] == 1 for s in cell
            ):
                summary["absent_center_cells"] += 1
            for first, second, side in ((a, b, 0), (b, a, 1)):
                actual = grouped(cell, lambda s: world.fiber_key(s, first))
                if side == 0:
                    encoded = grouped(cell, lambda s: (
                        encodings[s][0][0] + encodings[s][0][2], encodings[s][2]))
                else:
                    encoded = grouped(cell, lambda s: (
                        encodings[s][0][0] + encodings[s][0][1], encodings[s][1]))
                assert {frozenset(g) for g in actual} == {frozenset(g) for g in encoded}
                for group in actual:
                    assert set(next(g for g in fibers[first] if group[0] in g)) == set(group)
            summary["cells"] += 1
        interaction = add((1, mul(fluctuations[a], fluctuations[b])),
                          (1, mul(fluctuations[b], fluctuations[a])))
        residual = add((1, interaction), (-2, gain), (1, errors[0]), (1, errors[1]))
        psd(residual, ("local interaction", world.n, a, b, world.degrees(states[0])))
        local_residual_sum = add((1, local_residual_sum), (1, residual))
        d_operator = add((1, d_operator), (1, interaction))
        budgets[a] = add((1, budgets[a]), (1, gain), (-1, errors[0]))
        budgets[b] = add((1, budgets[b]), (1, gain), (-1, errors[1]))
        summary["unordered_disjoint_interactions"] += 1
    for a, budget in budgets.items():
        psd(budget, ("full directed budget", world.n, a, world.degrees(states[0])))
    psd(d_operator, ("D", world.n, world.degrees(states[0])))
    assembly = add((1, local_residual_sum), *((1, b) for b in budgets.values()))
    assert assembly == d_operator
    summary["degree_spaces"] += 1
    summary["graphs"] += count
    return fluctuations, d_operator


def graph_probes():
    summary = dict(degree_spaces=0, graphs=0, cells=0,
                   unordered_disjoint_interactions=0, degenerate_fibers=0,
                   zero_error_fibers=0, absent_center_cells=0,
                   overlapping_cells=0, max_outside_singleton_overlap=0)
    for n in range(6):
        world = Graphs(n)
        all_states = range(1 << len(world.edges))
        for states in grouped(all_states, world.degrees):
            graph_probe(world, states, summary)
    world = Graphs(6)
    regular = defaultdict(list)
    for state in range(1 << len(world.edges)):
        degree = world.degrees(state)
        if degree in ((1,) * 6, (2,) * 6):
            regular[degree].append(state)
    assert set(regular) == {(1,) * 6, (2,) * 6}
    for states in regular.values():
        graph_probe(world, states, summary)

    world = Graphs(5)
    degree = (1, 2, 1, 2, 2)
    states = [s for s in range(1 << len(world.edges)) if world.degrees(s) == degree]
    a, b = (0, 1), (2, 3)
    # Select the common cell by its outside counts and absent internal edges.
    cell = [s for s in states if not world.adjacent(s, *a) and not world.adjacent(s, *b)
            and sum(world.adjacent(s, i, 4) for i in a) == 1
            and sum(world.adjacent(s, j, 4) for j in b) == 1]
    assert len(cell) == 4
    values = {}
    for s in cell:
        cross = world.cross(s, a, b)
        values[s] = F(cross[0] + cross[2] != 1) - F(cross[0] + cross[1] != 1)
    ha = {}
    hb = {}
    for pair, result in ((a, ha), (b, hb)):
        for fiber in grouped(cell, lambda s: world.fiber_key(s, pair)):
            mean = sum(values[s] for s in fiber) / len(fiber)
            for s in fiber:
                result[s] = values[s] - mean
    interaction = 2 * sum(ha[s] * hb[s] for s in cell) / len(cell)
    assert interaction == -F(1, 9)
    assert summary["absent_center_cells"] > 0
    assert summary["max_outside_singleton_overlap"] >= 2
    summary["scope"] = "all degree spaces on 0<=n<=5; additionally n=6 degrees all 1 or all 2"
    summary["negative_single_interaction_not_a_refutation"] = {
        "n": 5, "d": degree, "a": a, "b": b,
        "graphs_in_cell_as_edge_masks": cell,
        "function_values_in_cell": [str(values[s]) for s in cell],
        "twice_inner_product_conditional": str(interaction),
        "meaning": "allowed diagnostic; positivity is claimed only after the ordered sum",
    }
    return summary


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    assert status["adapter_exit_code"] == 0
    assert output["request"]["payload"] == payload
    assert output["result"]["operation_id"] == "matrix.symbolic.eigenvalues.compute"
    assert output["result"]["output"]["representation"] == "EXPLICIT_ROOTS"
    answer = output["result"]["output"]
    assert dict(zip(answer["eigenvalues"], answer["multiplicities"])) == {"3": 2, "0": 1}
    entries = []
    for row in payload["matrix"]["entries"]:
        entries.append([
            F(entry["numerator"]["terms"][0]["coefficient"]["num"]) /
            F(entry["numerator"]["terms"][0]["coefficient"]["den"]) for entry in row
        ])
    matrix = sp.Matrix(entries)
    assert matrix == sp.Matrix([[2, -1, -1], [-1, 2, -1], [-1, -1, 2]])
    states = [frozenset(s) for s in itertools.combinations(range(4), 2)]

    def equal_vector(i, j):
        indicators = [F((i in s) == (j in s)) for s in states]
        mean = sum(indicators) / len(states)
        return [v - mean for v in indicators]

    vectors = [equal_vector(0, i) for i in (1, 2, 3)]
    for pair, complement in (((0, 1), (2, 3)), ((0, 2), (1, 3)), ((0, 3), (1, 2))):
        assert equal_vector(*pair) == equal_vector(*complement)
    norm = sum(v * v for v in vectors[0])
    gram = sp.Matrix([
        [sum(x * y for x, y in zip(v, w)) / norm for w in vectors]
        for v in vectors
    ])
    assert matrix == 2 * gram, "Jacobian payload is not the stated slice Gram matrix"
    variable = sp.Symbol("lambda")
    assert matrix.charpoly().as_expr().expand() == sp.expand(variable * (variable - 3) ** 2)
    return {"operation_id": output["result"]["operation_id"],
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "adapter_exit_code": status["adapter_exit_code"],
            "eigenvalues": answer["eigenvalues"], "multiplicities": answer["multiplicities"],
            "binding": "twice the Gram matrix of the three complementary equality-indicator classes on X_(4,2); nonzero spectrum equals the six-pair frame spectrum"}


def sharp_family_probes():
    result = []
    for m in (1, 2, 5, 20):
        world = Graphs(m + 4)
        outside = range(4, m + 4)

        def edge(i, j):
            return world.bit[tuple(sorted((i, j)))]

        base = 0
        for w in outside:
            base |= edge(1, w) | edge(3, w)
        centers = [base | edge(0, 2) | edge(1, 3),
                   base | edge(0, 3) | edge(1, 2)]
        tops = [(base ^ edge(1, w)) | edge(0, w) | edge(1, 2) | edge(1, 3)
                for w in outside]
        sides = [(base ^ edge(3, w)) | edge(2, w) | edge(0, 3) | edge(1, 3)
                 for w in outside]
        states = tops + sides + centers
        assert len(set(states)) == 2 * m + 2
        assert {world.degrees(s) for s in states} == {(1, m + 1, 1, m + 1) + (2,) * m}
        assert len({world.cell_key(s, (0, 1), (2, 3)) for s in states}) == 1
        decoded, overlap = world.decode_cell(centers[0], (0, 1), (2, 3))
        assert set(decoded) == set(states) and overlap == m
        values = {s: F(-1) for s in tops}
        values.update({s: F(1) for s in sides})
        values.update({s: F(0) for s in centers})
        deviations = []
        for pair, other in (((0, 1), (2, 3)), ((2, 3), (0, 1))):
            image = {}
            for fiber in grouped(states, lambda s: world.fiber_key(s, pair)):
                singles = world.singleton(fiber[0], pair)
                q = sum(world.adjacent(fiber[0], pair[0], w) for w in singles)
                assert len(fiber) == sp.binomial(len(singles), q), "not a full pair fiber"
                mean = sum(values[s] for s in fiber) / len(fiber)
                image.update({s: values[s] - mean for s in fiber})
                if set(other) <= set(singles):
                    equal = [F(world.adjacent(s, pair[0], other[0]) ==
                               world.adjacent(s, pair[0], other[1])) for s in fiber]
                    equality_mean = sum(equal) / len(equal)
                    line = [v - equality_mean for v in equal]
                    error_image = apply(projector(line), [values[s] for s in fiber])
                else:
                    error_image = [F(0)] * len(fiber)
                assert error_image == [image[s] for s in fiber], "R f differs from h f"
            deviations.append(image)
        for s in states:
            cross = world.cross(s, (0, 1), (2, 3))
            if (cross[0] + cross[1] == cross[2] + cross[3] ==
                    cross[0] + cross[2] == cross[1] + cross[3] == 1):
                toggled = s
                for i, j in itertools.product((0, 1), (2, 3)):
                    toggled ^= edge(i, j)
                assert values[toggled] == values[s], "nonzero gain in sharpness family"
        interaction = 2 * sum(deviations[0][s] * deviations[1][s] for s in states) / len(states)
        error = [sum(image[s] ** 2 for s in states) / len(states)
                 for image in deviations]
        assert interaction == -F(2 * m * m, (m + 1) * (m + 2) ** 2)
        assert error == [F(m, (m + 1) * (m + 2))] * 2
        assert -interaction / sum(error) == F(m, m + 2)
        result.append({"m": m, "graphs_in_full_common_cell": len(states),
                       "overlap": overlap, "twice_interaction": str(interaction),
                       "each_error_energy": str(error[0]), "required_coefficient": str(F(m, m + 2))})
    return result


def lean_summary(path):
    record = json.loads(path.read_text())
    assert record["subject"]["subject_id"] == "C_DISJOINT_CORE"
    assert record["verdict"] == "supports"
    check = record["lean_check"]
    assert check["exit_code"] == 0 and check["proof_holes"] == []
    assert not check["environment_failure"]
    assert "4.31.0" in check["tools"]["lean"]["version"]
    if check["audit_command"]:
        assert check["audit_exit_code"] == 0
    for name, field in (("Main.lean", "source_sha256"),
                        ("statement_fidelity.md", "statement_fidelity_sha256")):
        assert hashlib.sha256((HERE / name).read_bytes()).hexdigest() == check[field], name
    assert record["lean_source"]["text"] == (HERE / "Main.lean").read_text()
    assert record["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text()
    ledger = json.loads((PROJECT / "research" / "MATH_STATE.json").read_text())
    claim = max((c for c in ledger["claims"] if c["claim_id"] == "C_DISJOINT_CORE"),
                key=lambda c: c["version"])
    assert record["subject"]["content_hash"] == claim["content_hash"]
    axioms = {}
    for name, entries in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", check["stdout"]):
        names = [name.strip() for name in entries.split(",") if name.strip()]
        assert set(names) <= {"propext", "Classical.choice", "Quot.sound"}, (name, names)
        axioms[name] = names
    required = {
        "Argus9000131.disjoint_core",
        "OAI.Problem315.PairEquality.actual_named_interaction",
        "OAI.Problem315.PairEquality.pair_projection_budget",
        "OAI.Problem315.SliceNormalized.projection_comparison",
        "Argus9000131.no_uniform_smaller_ratio",
    }
    assert required <= set(axioms), "missing transitive kernel axiom output"
    return {"artifact": str(path.resolve().relative_to(PROJECT)),
            "claim": "C_DISJOINT_CORE", "exit_code": 0, "proof_holes": [],
            "source_sha256": check["source_sha256"],
            "statement_fidelity_sha256": check["statement_fidelity_sha256"],
            "evidence_tier": record["tier"], "axioms": axioms,
            "scope": "all n,d and all real functions; no finite-state bound"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lean-record", type=Path,
                        help="reuse this measured compiler record instead of recompiling")
    parser.add_argument("--record", action="store_true", help="write the exact certificate")
    parser.add_argument("--probe-record", type=Path,
                        help="reuse previously measured finite probes while binding the final certificate")
    parser.add_argument("--probes-only", action="store_true",
                        help="explicit finite/algebra checkpoint, not a universal certificate")
    args = parser.parse_args()
    if args.probe_record is not None:
        assert args.record, "--probe-record is only for binding, not independent replay"
        result = json.loads(args.probe_record.read_text())
        assert result["claim"] == "C_DISJOINT_CORE"
        result["universal_algebra"] = universal_algebra()
        result["jacobian"] = jacobian_replay()
        result["sharp_family_probes"] = sharp_family_probes()
    else:
        result = {
            "claim": "C_DISJOINT_CORE",
            "universal_algebra": universal_algebra(),
            "slice_probes": slice_probes(),
            "graph_probes": graph_probes(),
            "jacobian": jacobian_replay(),
            "sharp_family_probes": sharp_family_probes(),
        }
    if args.probes_only:
        assert not args.record and args.lean_record is None
        print(json.dumps(result, indent=2))
        return
    if args.lean_record is None:
        completed = subprocess.run(
            [ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
             str(HERE / "Main.lean"), "--project-root", str(PROJECT),
             "--statement-fidelity", str(HERE / "statement_fidelity.md"),
             "--artifact-dir", str(HERE / "lean_evidence"),
             "--claim", "C_DISJOINT_CORE"],
            check=False, capture_output=True, text=True,
        )
        if completed.returncode:
            raise RuntimeError(
                f"Lean certification exited {completed.returncode}\n"
                f"{completed.stdout[-8000:]}\n{completed.stderr[-2000:]}"
            )
        compilation = json.loads(completed.stdout)
        args.lean_record = PROJECT / compilation["kernel"]["recorded"]["artifact"]
        for module in ("math_state", "proof_graph_check"):
            subprocess.run(
                [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
                 "check", "--project-root", str(PROJECT)],
                check=True, capture_output=True, text=True,
            )
    result["lean"] = lean_summary(args.lean_record)
    result["scope_and_limits"] = {
        "result_class": "exact_verification",
        "universal_core": True,
        "graph_family_sharpness": "proved in prose with exact rational and scalar-kernel checks",
        "novelty_status": "not_established",
        "independent_review": "required; Engineer does not self-approve",
        "not_claimed": ["exact sampling", "all final mixing constants", "campaign completion"],
    }
    result = json.loads(json.dumps(result))
    certificate = HERE / "exact_certificate.json"
    if args.record:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        expected = json.loads(certificate.read_text())
        # A fresh real compilation can have a different archive path.
        expected["lean"].pop("artifact")
        comparison = json.loads(json.dumps(result))
        comparison["lean"].pop("artifact")
        assert expected == comparison, "certificate differs from the rerun"
    print(json.dumps({"ok": True, "claim": result["claim"],
                      "degree_spaces": result["graph_probes"]["degree_spaces"],
                      "graphs": result["graph_probes"]["graphs"],
                      "finite_probes_are_not_the_universal_proof": True}, sort_keys=True))


if __name__ == "__main__":
    main()
