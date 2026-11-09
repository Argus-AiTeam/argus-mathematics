"""Exact verification from the printed words and their Einstein-index semantics.

No manuscript Python module or retained arithmetic output is loaded.
Run with --write-certificate to record the computed certificate, or without
arguments to recompute it and compare every field with the recorded result.
"""

import argparse
from collections import Counter, defaultdict
from dataclasses import dataclass
from fractions import Fraction as F
from itertools import permutations, product
import json
from math import isqrt, prod
from pathlib import Path
import re
import time

import numpy as np

from tensor_semantics import MANUSCRIPT, Q, RANK, ROWS, TABLES


HERE = Path(__file__).resolve().parent
PROOF = MANUSCRIPT / "build/sections/certificate-proof.tex"
P_ENDPOINT, ELL_ENDPOINT, X_FIRST, X_SECOND = -1, -2, -3, -4


def canonical(rank, key):
    h, w, z, traces, edges = key
    counts = Counter(u for edge in edges for u in edge[:2])
    assert all(counts[i] == 1 for i in range(rank))
    assert all(u < rank and u >= -4 for u in counts)
    assert all(counts[x] in (0, 3) for x in (X_FIRST, X_SECOND))
    assert h >= 0 and w >= 0 and z >= 0
    assert all(k >= 0 for _, _, k in edges)
    if 1 in traces or any(u == v and u <= -3 and k == 0 for u, v, k in edges):
        return None, 0
    multiplier = 5 ** traces.count(0)
    traces = tuple(sorted(k for k in traces if k not in (0, 2)))
    if counts[X_SECOND] and not counts[X_FIRST]:
        edges = tuple((X_FIRST if u == X_SECOND else u,
                       X_FIRST if v == X_SECOND else v, k) for u, v, k in edges)
    edges = tuple(sorted((min(u, v), max(u, v), k) for u, v, k in edges))
    if counts[X_FIRST] and counts[X_SECOND]:
        exchange = {X_FIRST: X_SECOND, X_SECOND: X_FIRST}
        swapped = tuple(sorted(
            (min(exchange.get(u, u), exchange.get(v, v)),
             max(exchange.get(u, u), exchange.get(v, v)), k)
            for u, v, k in edges
        ))
        edges = max(edges, swapped)
    return (h, w, z, traces, edges), multiplier


@dataclass
class Tensor:
    rank: int
    terms: dict

    @classmethod
    def monomial(cls, rank, key, coefficient=1):
        key, multiplier = canonical(rank, key)
        return cls(rank, {} if not multiplier else {key: coefficient * multiplier})

    @classmethod
    def word(cls, rank, word):
        assert len(word) % 3 == 0
        h, b, j = map(int, word[:3])
        endpoints = {5: P_ENDPOINT, 6: ELL_ENDPOINT, 7: X_FIRST, 8: X_SECOND}
        edges = []
        for i in range(3, len(word), 3):
            u, v, k = map(int, word[i : i + 3])
            edges.append((endpoints.get(u, u), endpoints.get(v, v), k))
        return cls.monomial(rank, (h, int(j == 1), int(j == 2), (3,) * b, tuple(edges)))

    def scaled(self, coefficient):
        return Tensor(self.rank, {k: c * coefficient for k, c in self.terms.items() if c * coefficient})

    def plus(self, other):
        assert self.rank == other.rank
        terms = self.terms.copy()
        for key, coefficient in other.terms.items():
            terms[key] = terms.get(key, 0) + coefficient
            if not terms[key]:
                del terms[key]
        return Tensor(self.rank, terms)

    def permute(self, mapping):
        assert sorted(mapping) == list(range(self.rank))
        result = Tensor(self.rank, {})
        for (h, w, z, traces, edges), coefficient in self.terms.items():
            edges = tuple((mapping[u] if u >= 0 else u,
                           mapping[v] if v >= 0 else v, k) for u, v, k in edges)
            result = result.plus(Tensor.monomial(
                self.rank, (h, w, z, traces, edges), coefficient
            ))
        return result

    def outer(self, other):
        result = defaultdict(int)
        rank = self.rank + other.rank
        for left, lc in self.terms.items():
            for right, rc in other.terms.items():
                h, w, z, traces, edges = left
                H, W, Z, TR, ED = right
                left_x = {u for edge in edges for u in edge[:2] if u <= -3}
                right_x = {u for edge in ED for u in edge[:2] if u <= -3}
                assert len(left_x) + len(right_x) <= 2
                xmap = {x: -3 - len(left_x) - i for i, x in enumerate(sorted(right_x, reverse=True))}
                def rename(u):
                    return u + self.rank if u >= 0 else xmap.get(u, u)
                joined = edges + tuple((rename(u), rename(v), k) for u, v, k in ED)
                key, multiplier = canonical(rank, (h + H, w + W, z + Z, traces + TR, joined))
                if multiplier:
                    result[key] += multiplier * lc * rc
        return Tensor(rank, {k: c for k, c in result.items() if c})

    def trace(self, a, b):
        assert 0 <= a < b < self.rank
        remaining = [i for i in range(self.rank) if i not in (a, b)]
        rename = {old: new for new, old in enumerate(remaining)}
        result = defaultdict(int)
        for (h, w, z, traces, edges), coefficient in self.terms.items():
            ia = next(i for i, e in enumerate(edges) if a in e[:2])
            ib = next(i for i, e in enumerate(edges) if b in e[:2])
            ea, eb = edges[ia], edges[ib]
            kept = [e for i, e in enumerate(edges) if i not in (ia, ib)]
            if ia == ib:
                traces += (ea[2],)
            else:
                u = ea[1] if ea[0] == a else ea[0]
                v = eb[1] if eb[0] == b else eb[0]
                kept.append((u, v, ea[2] + eb[2]))
            kept = tuple((rename.get(u, u), rename.get(v, v), k) for u, v, k in kept)
            key, multiplier = canonical(self.rank - 2, (h, w, z, traces, kept))
            if multiplier:
                result[key] += multiplier * coefficient
        return Tensor(self.rank - 2, {k: c for k, c in result.items() if c})

    def derivative(self):
        result = Tensor(self.rank + 1, {})
        for (h, w, z, traces, edges), coefficient in self.terms.items():
            assert w == z == 0
            assert all(u >= -1 for edge in edges for u in edge[:2])
            shifted = tuple((u + 1 if u >= 0 else u, v + 1 if v >= 0 else v, k)
                            for u, v, k in edges)
            def emit(H, W, Z, TR, ED, c):
                nonlocal result
                result = result.plus(Tensor.monomial(
                    self.rank + 1, (H, W, Z, TR, tuple(ED)), coefficient * c
                ))
            if h:
                emit(h - 1, 0, 1, traces, shifted + ((0, P_ENDPOINT, 0),), h)
            degree = sum(k for _, _, k in edges) + sum(traces)
            if degree:
                emit(h, 0, 0, traces,
                     shifted + ((X_FIRST, X_FIRST, 1), (0, X_FIRST, 0)), -degree)
            for index, (u, v, k) in enumerate(shifted):
                others = shifted[:index] + shifted[index + 1 :]
                for position in range(k):
                    emit(h, 0, 0, traces, others + (
                        (u, X_FIRST, position), (v, X_FIRST, k - 1 - position),
                        (0, X_FIRST, 0)), 1)
                for endpoint, opposite in ((u, v), (v, u)):
                    if endpoint == P_ENDPOINT:
                        emit(h, 1, 0, traces, others + ((0, opposite, k + 1),), 1)
                        emit(h + 1, 0, 1, traces, others + ((0, opposite, k),), -1)
            for index, k in enumerate(traces):
                emit(h, 0, 0, traces[:index] + traces[index + 1 :],
                     shifted + ((X_FIRST, X_FIRST, k - 1), (0, X_FIRST, 0)), k)
        return result


def einsum(*operands, out=""):
    value = Tensor.word(0, "000")
    labels = []
    for tensor, indices in operands:
        assert tensor.rank == len(indices)
        value = value.outer(tensor)
        labels.extend(indices)
    assert all(n <= 2 for n in Counter(labels).values())
    for label in list(dict.fromkeys(labels)):
        if labels.count(label) == 2:
            a = labels.index(label)
            b = labels.index(label, a + 1)
            value = value.trace(a, b)
            labels = [x for i, x in enumerate(labels) if i not in (a, b)]
    assert sorted(labels) == sorted(out)
    return value.permute(tuple(out.index(x) for x in labels))


DELTA = Tensor.word(2, "000010")
AMATRIX = Tensor.word(2, "000011")
XTENSOR = Tensor.word(3, "000700710720")
QVECTOR = Tensor.word(1, "000771700")
ELL = Tensor.word(1, "000600")
WSCALAR = Tensor.word(0, "001")
ZSCALAR = Tensor.word(0, "002")
CHI = Tensor.word(0, "000").plus(Tensor.word(0, "000550").scaled(-1)).plus(
    Tensor.word(0, "200").scaled(-1)
)


def interior_row(name, tensor):
    """25 times one unscaled Table I monomial's literal contribution."""
    D = tensor.derivative()
    if name == "f":
        return (
            einsum((ZSCALAR, ""), (ZSCALAR, ""), (tensor, "")).scaled(-100)
            .plus(einsum((tensor, ""), (ELL, "l"), (ELL, "l")).scaled(25))
            .plus(einsum((D, "l"), (ELL, "l")).scaled(-25))
            .plus(einsum((QVECTOR, "l"), (tensor, ""), (ELL, "l")).scaled(-29))
        )
    if name == "U":
        return (
            einsum((ZSCALAR, ""), (ZSCALAR, ""), (tensor, "jk"), (AMATRIX, "jk")).scaled(125)
            .plus(einsum((D, "ljk"), (XTENSOR, "ljk")).scaled(25))
            .plus(einsum((QVECTOR, "l"), (tensor, "jk"), (XTENSOR, "ljk")).scaled(4))
        )
    if name == "K":
        C = tensor.plus(tensor.permute((1, 0, 2, 3)).scaled(-1))
        DC = C.derivative()
        return (
            einsum((ZSCALAR, ""), (ZSCALAR, ""), (C, "lijk"),
                   (DELTA, "lj"), (AMATRIX, "ik")).scaled(25)
            .plus(einsum((ZSCALAR, ""), (ZSCALAR, ""), (C, "lijk"),
                        (DELTA, "lk"), (AMATRIX, "ij")).scaled(25))
            .plus(einsum((DC, "llijk"), (XTENSOR, "ijk")).scaled(25))
            .plus(einsum((QVECTOR, "l"), (C, "lijk"), (XTENSOR, "ijk")).scaled(4))
        )
    if name == "M":
        return einsum((WSCALAR, ""), (D, "ll")).scaled(25).plus(
            einsum((WSCALAR, ""), (QVECTOR, "l"), (tensor, "l")).scaled(54)
        )
    assert name == "P"
    return einsum((ZSCALAR, ""), (D, "ll")).scaled(25).plus(
        einsum((ZSCALAR, ""), (QVECTOR, "l"), (tensor, "l")).scaled(29)
    )


def table_two():
    blocks = []
    for line in TABLES.read_text().splitlines():
        if line.startswith("@ "):
            _, rank, kind, mode = line.split()
            blocks.append({"rank": int(rank), "kind": kind, "mode": mode, "rows": []})
        elif blocks and re.fullmatch(r"\d+ (?:-?\d+ ?)+", line):
            word, *coefficients = line.split()
            blocks[-1]["rows"].append((word, tuple(map(int, coefficients))))
    assert len(blocks) == 21
    assert sum(len(b["rows"]) for b in blocks if b["rank"] >= 0) == 529
    assert [len(b["rows"]) for b in blocks if b["rank"] == -1] == [14, 14]
    for block in blocks:
        assert len({len(c) for _, c in block["rows"]}) == 1
        assert block["mode"] in (("I", "H") if block["rank"] == -1 else ("I", "B"))
        for word, _ in block["rows"]:
            if block["rank"] >= 0:
                tensor = Tensor.word(block["rank"], word)
                assert all(semantic_degree(key) == 1 for key in tensor.terms)
    return blocks


def sign(permutation):
    return (-1) ** sum(a > b for i, a in enumerate(permutation) for b in permutation[i + 1 :])


def projection(tensor, kind):
    r = tensor.rank
    if kind == "none":
        return tensor
    sym = Tensor(r, {})
    for permutation in permutations(range(r)):
        sym = sym.plus(tensor.permute(permutation).scaled(sign(permutation) if kind == "anti" else 1))
    if kind == "anti":
        return sym
    if kind == "hook":
        assert r == 3
        sym = tensor.plus(tensor.permute((1, 0, 2))).scaled(3).plus(sym.scaled(-1))
    v = sym.trace(0, 1)
    if r == 2:
        assert kind == "sym"
        return sym.scaled(5).plus(einsum((DELTA, "ij"), (v, ""), out="ij").scaled(-1))
    assert r == 3
    J12 = einsum((DELTA, "ij"), (v, "k"), out="ijk")
    J13 = einsum((DELTA, "ik"), (v, "j"), out="ijk")
    J23 = einsum((DELTA, "jk"), (v, "i"), out="ijk")
    if kind == "hook":
        return sym.scaled(8).plus(J12.scaled(-2)).plus(J13).plus(J23)
    assert kind == "sym"
    return sym.scaled(7).plus(J12.scaled(-1)).plus(J13.scaled(-1)).plus(J23.scaled(-1))


def semantic_degree(key):
    _, w, z, _, edges = key
    endpoints = [u for edge in edges for u in edge[:2]]
    return w + z + endpoints.count(ELL_ENDPOINT) + len({u for u in endpoints if u <= -3})


def gram_interior(blocks):
    result = Tensor(0, {})
    for index, block in enumerate(blocks):
        r = block["rank"]
        if r < 0:
            continue
        rows = [(Tensor.word(r, word), coefficients) for word, coefficients in block["rows"]]
        projected = [projection(tensor, block["kind"]) for tensor, _ in rows]
        labels = "ijk"[:r]
        contribution = Tensor(0, {})
        for s, (left, coefficients) in enumerate(rows):
            for t in range(s, len(rows)):
                c = sum(a * b for a, b in zip(coefficients, rows[t][1]))
                if c:
                    contribution = contribution.plus(
                        einsum((left, labels), (projected[t], labels)).scaled(c * (1 if s == t else 2))
                    )
        if block["mode"] == "B":
            contribution = contribution.outer(CHI)
        result = result.plus(contribution)
        print(f"interior block {index + 1}: {len(contribution.terms)} collected terms", flush=True)
    return result


def graph_bound(key):
    h, w, z, traces, edges = key
    assert semantic_degree(key) == 2
    endpoints = [u for edge in edges for u in edge[:2]]
    types = [0] * w + [1] * z + [2] * endpoints.count(ELL_ENDPOINT) + [
        3 for _ in {u for u in endpoints if u <= -3}
    ]
    assert len(types) == 2
    theta = F(4, 5)
    L2 = prod(F(9, 20) if k == 3 else theta ** (k - 2) for k in traces)
    for u, v, k in edges:
        if u == v and u <= -3:
            assert k > 0
            L2 *= F(5, 7) if k == 1 else theta ** (k - 1)
        else:
            L2 *= theta**k
    b = endpoints.count(P_ENDPOINT)
    if h and b:
        L2 *= F(h, h + b) ** h * F(b, h + b) ** b
    n = isqrt((10**10 * L2.numerator) // L2.denominator)
    if n * n * L2.denominator < 10**10 * L2.numerator:
        n += 1
    assert n * n * L2.denominator >= 10**10 * L2.numerator
    assert n == 0 or (n - 1) ** 2 * L2.denominator < 10**10 * L2.numerator
    return tuple(sorted(types)), L2, n


def interior_certificate(blocks):
    I25Q = Tensor(0, {})
    for name, word, coefficient, _, _, _ in ROWS:
        I25Q = I25Q.plus(interior_row(name, Tensor.word(RANK[name], word)).scaled(coefficient))
    gamma = gram_interior(blocks)
    diagonal = (
        WSCALAR.outer(WSCALAR).scaled(Q * Q * 2 // 25)
        .plus(ZSCALAR.outer(ZSCALAR).scaled(Q * Q * 2 // 25))
        .plus(einsum((ELL, "i"), (ELL, "i")).scaled(Q * Q // 4))
        .plus(einsum((XTENSOR, "ijk"), (XTENSOR, "ijk")).scaled(Q * Q))
    )
    E = gamma.plus(diagonal).plus(I25Q.scaled(-(Q // 25)))
    counts = Counter()
    totals = Counter()
    terms = []
    for key, coefficient in sorted(E.terms.items()):
        types, L2, n = graph_bound(key)
        counts[types] += 1
        totals[types] += abs(coefficient) * n * (2 if types[0] == types[1] else 1)
        h, w, z, traces, edges = key
        terms.append({
            "g_w_z": [h, w, z], "traces": traces, "edges": edges,
            "Q_squared_coefficient": coefficient, "types": types,
            "bound_squared": str(L2), "rounded_bound_numerator": n
        })
    printed = {
        (int(i) - 1, int(j) - 1): (int(count), int(total))
        for i, j, count, total in re.findall(
            r"\((\d),(\d)\)&(\d+)&(\d+)", PROOF.read_text()
        )
    }
    assert len(printed) == 10
    assert {pair: (counts[pair], totals[pair]) for pair in counts} == printed
    Dbar = [[F(n, 100000) for n in row] for row in [
        [2571, 773, 2358, 3087], [773, 2157, 926, 1002],
        [2358, 926, 4845, 4948], [3087, 1002, 4948, 8037]
    ]]
    nu = [2484, 1440, 996, 304]
    d = [F(2, 25), F(2, 25), F(1, 4), F(1)]
    for (i, j), total in totals.items():
        assert F(total, 2 * 10**5 * Q * Q) <= Dbar[i][j]
    slacks = [d[i] - sum(Dbar[i][j] * nu[j] for j in range(4)) / nu[i] for i in range(4)]
    assert slacks == [F(673, 18400), F(438907, 12000000), F(2844869, 24900000), F(3479389, 7600000)]
    epsilon = F(438907, 12000000)
    assert min(slacks) == epsilon
    return I25Q, gamma, {
        "nonzero_remainder_terms": len(terms),
        "counts_and_scaled_D0": [
            {"types": pair, "count": counts[pair], "scaled_D0": totals[pair]}
            for pair in sorted(counts)
        ],
        "diagonal_slacks": list(map(str, slacks)),
        "epsilon": str(epsilon),
        "terms": terms
    }


ZERO4 = (0, 0, 0, 0)


def p_add(left, right, scale=1):
    result = left.copy()
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, 0) + scale * coefficient
        if not result[monomial]:
            del result[monomial]
    return result


def p_mul(left, right):
    result = defaultdict(int)
    for a, ca in left.items():
        for b, cb in right.items():
            result[tuple(x + y for x, y in zip(a, b))] += ca * cb
    return {m: c for m, c in result.items() if c}


def p_pow(base, n):
    result = {ZERO4: 1}
    for _ in range(n):
        result = p_mul(result, base)
    return result


def boundary_certificate(blocks):
    coordinates = [{tuple(int(i == j) for i in range(4)): 1} for j in range(4)]
    total = {}
    for coordinate in coordinates:
        total = p_add(total, coordinate)
    lam = {m: -c for m, c in total.items()}
    alpha = coordinates + [lam]
    powers = [[p_pow(a, k) for k in range(6)] for a in alpha]
    t3 = {}
    for row in powers:
        t3 = p_add(t3, row[3])
    def component(row, slots):
        name, _, _, h, b, edges = row
        assert len(slots) == RANK[name]
        if h:
            return {}
        result = p_pow(t3, b)
        for u, v, k in edges:
            i = 4 if u == 5 else slots[u]
            j = 4 if v == 5 else slots[v]
            if i != j:
                return {}
            result = p_mul(result, powers[i][k])
        return result
    S_Q = {}
    for row in ROWS:
        name, _, coefficient, _, _, _ = row
        contribution = {}
        if name == "f":
            contribution = p_mul(component(row, ()), total)
        elif name == "M":
            contribution = component(row, (4,))
        elif name in ("U", "K"):
            if name == "U":
                contribution = component(row, (4, 4))
            for i in range(4):
                b_i = p_add(p_mul(lam, coordinates[i]), powers[i][2], -1)
                if name == "U":
                    c_i = component(row, (i, i))
                else:
                    c_i = p_add(component(row, (4, i, 4, i)), component(row, (i, 4, 4, i)), -1)
                    c_i = p_add(c_i, component(row, (4, i, i, 4)))
                    c_i = p_add(c_i, component(row, (i, 4, i, 4)), -1)
                contribution = p_add(contribution, p_mul(b_i, c_i))
        S_Q = p_add(S_Q, contribution, coefficient)
    assert max(map(sum, S_Q)) <= 5
    for permutation in permutations(range(4)):
        assert {tuple(m[i] for i in permutation): c for m, c in S_Q.items()} == S_Q
    gram = {}
    for block in blocks:
        if block["rank"] != -1:
            continue
        contribution = {}
        for word, coefficients in block["rows"]:
            assert len(word) == 4
            assert sum(map(int, word)) in (1, 2)
        for word, coefficients in block["rows"]:
            for other, other_coefficients in block["rows"]:
                coefficient = sum(a * b for a, b in zip(coefficients, other_coefficients))
                monomial = tuple(int(a) + int(b) for a, b in zip(word, other))
                contribution = p_add(contribution, {monomial: coefficient})
        if block["mode"] == "H":
            contribution = p_mul(contribution, total)
        gram = p_add(gram, contribution)
    remainder = p_add(p_add(gram, {ZERO4: Q * Q // 4}), S_Q, -Q)
    R = p_pow(total, 2)
    for coordinate in coordinates:
        R = p_add(R, p_pow(coordinate, 2))
    homogenized = {}
    for monomial, coefficient in remainder.items():
        degree = sum(monomial)
        assert degree <= 5
        homogenized = p_add(homogenized, p_mul(
            {monomial: coefficient}, p_pow(R, (5 - degree) // 2)
        ))
    orbits = defaultdict(int)
    for monomial, coefficient in homogenized.items():
        assert sum(monomial) in (4, 5)
        orbits[tuple(sorted(monomial))] += coefficient
    orbits = {m: c for m, c in orbits.items() if c}
    printed = {
        (int(a), int(b), int(c), int(d)): int(value)
        for a, b, c, d, value in re.findall(
            r"\((\d),(\d),(\d),(\d)\)&(-?\d+)", PROOF.read_text()
        )
    }
    assert len(printed) == 11 and orbits == printed
    absolute_sum = sum(map(abs, orbits.values()))
    assert absolute_sum == 1656725282
    delta = F(1, 4) - F(absolute_sum, Q * Q)
    assert delta == F(6984137359, 31250000000)
    return {
        "component_polynomial_QS": [{"exponent": m, "coefficient": c} for m, c in sorted(S_Q.items())],
        "averaged_homogeneous_remainder": [{"exponent": m, "Q_squared_coefficient": c} for m, c in sorted(orbits.items())],
        "absolute_numerator_sum": absolute_sum,
        "delta": str(delta),
        "strict_domain": "sum(x)>0, R(x)=1; no sign condition on individual x_i"
    }


def dense_projection_certificate(blocks):
    result = []
    for rank, kind in sorted({(b["rank"], b["kind"]) for b in blocks if b["rank"] >= 0}):
        size = 5**rank
        identity = np.eye(5, dtype=np.int64)
        def apply(tensor):
            if kind == "none":
                return tensor
            sym = sum(sign(p) * tensor.transpose(p) if kind == "anti" else tensor.transpose(p)
                      for p in permutations(range(rank)))
            if kind == "anti":
                return sym
            if kind == "hook":
                sym = 3 * (tensor + tensor.swapaxes(0, 1)) - sym
            trace = np.trace(sym, axis1=0, axis2=1)
            if rank == 2:
                return 5 * sym - identity * trace
            j12 = identity[:, :, None] * trace[None, None, :]
            j13 = identity[:, None, :] * trace[None, :, None]
            j23 = identity[None, :, :] * trace[:, None, None]
            return 8 * sym - 2 * j12 + j13 + j23 if kind == "hook" else 7 * sym - j12 - j13 - j23
        columns = []
        for j in range(size):
            basis = np.zeros(size, dtype=np.int64)
            basis[j] = 1
            columns.append(apply(basis.reshape((5,) * rank)).reshape(size))
        matrix = np.stack(columns, axis=1)
        scale = {("sym", 2): 10, ("sym", 3): 42, ("hook", 3): 48,
                 ("anti", 2): 2, ("anti", 3): 6}.get((kind, rank), 1)
        assert np.array_equal(matrix, matrix.T)
        assert np.array_equal(matrix @ matrix, scale * matrix)
        result.append({"rank": rank, "kind": kind, "dimension": size, "positive_projection_scale": scale,
                       "symmetric": True, "squared_equals_scale_times_matrix": True})
    return result


def universal_cubic_contraction_identity():
    """Coefficientwise quartic identity for generic STF A and a generic vector."""
    def multiply(left, right):
        result = defaultdict(int)
        for a, ca in left.items():
            for b, cb in right.items():
                result[tuple(sorted(a + b))] += ca * cb
        return {m: c for m, c in result.items() if c}
    def add_many(polynomials):
        result = {}
        for polynomial in polynomials:
            result = p_add(result, polynomial)
        return result
    def scale(polynomial, c):
        return {m: c * value for m, value in polynomial.items() if c * value}
    A = [[{} for _ in range(5)] for _ in range(5)]
    index = 0
    for i in range(5):
        for j in range(i, 5):
            if (i, j) != (4, 4):
                A[i][j] = A[j][i] = {(index,): 1}
                index += 1
    assert index == 14
    A[4][4] = scale(add_many(A[i][i] for i in range(4)), -1)
    zeta = [{(14 + i,): 1} for i in range(5)]
    Az = [add_many(multiply(A[i][j], zeta[j]) for j in range(5)) for i in range(5)]
    B = {}
    STF = {}
    for i, j, k in product(range(5), repeat=3):
        B[i, j, k] = add_many([
            multiply(zeta[i], A[j][k]), multiply(zeta[j], A[i][k]),
            multiply(zeta[k], A[i][j])
        ])
        correction = add_many([
            Az[k] if i == j else {}, Az[j] if i == k else {},
            Az[i] if j == k else {}
        ])
        STF[i, j, k] = p_add(scale(B[i, j, k], 7), correction, -2)
    for k in range(5):
        assert add_many(B[i, i, k] for i in range(5)) == scale(Az[k], 2)
        assert not add_many(STF[i, i, k] for i in range(5))
    for i, j, k in product(range(5), repeat=3):
        assert STF[i, j, k] == STF[j, i, k] == STF[i, k, j]
    norm_A = add_many(multiply(A[i][j], A[i][j]) for i, j in product(range(5), repeat=2))
    norm_zeta = add_many(multiply(v, v) for v in zeta)
    norm_Az = add_many(multiply(v, v) for v in Az)
    norm_STF = add_many(multiply(v, v) for v in STF.values())
    target = p_add(scale(multiply(norm_A, norm_zeta), 147), norm_Az, 210)
    assert norm_STF == target
    cubic_extrema = [F((5 - 2 * j)**2, 5 * j * (5 - j)) for j in range(1, 5)]
    assert cubic_extrema == [F(9, 20), F(1, 30), F(1, 30), F(9, 20)]
    return {
        "generic_STF_matrix_coordinates": 14,
        "generic_vector_coordinates": 5,
        "identity": "|7 SymSum(zeta tensor A)-2 J(A zeta)|^2 = 147 |A|^2 |zeta|^2 + 210 |A zeta|^2",
        "meaning_of_SymSum": "zeta_i A_jk + zeta_j A_ik + zeta_k A_ij",
        "all_symmetry_and_trace_identities": True,
        "quartic_identity_checked_coefficientwise": True,
        "quartic_monomials": len(target),
        "cubic_trace_squared_at_all_extremal_multiplicities": list(map(str, cubic_extrema)),
        "contraction_bound_squared": "5/7"
    }


def main():
    if not __debug__:
        raise SystemExit("Exact verification requires Python assertions; do not use -O.")
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    started = time.monotonic()
    blocks = table_two()
    I25Q, gamma, interior = interior_certificate(blocks)
    boundary = boundary_certificate(blocks)
    projections = dense_projection_certificate(blocks)
    contraction_identity = universal_cubic_contraction_identity()
    from tensor_semantics import exact_component_check
    semantic_check = exact_component_check(Tensor, interior_row, I25Q, gamma, blocks)
    jacobian = json.loads((HERE / "jacobian_output.json").read_text())
    assert jacobian["result"]["output"]["value"] == {"num": "285734938", "den": "625"}
    assert jacobian["request"]["payload"] == json.loads((HERE / "jacobian_payload.json").read_text())
    certificate = {
        "result_class": "exact_verification_theorem",
        "claim": "C_UNIVERSAL",
        "statement": "The literal Table I tensor polynomials satisfy both inequalities of Proposition cert:universal on their full stated algebraic domains.",
        "method": "Independent Einstein-index expansion, exact component differentiation, positive projection matrices, universal tensor norm bounds, and rational remainder margins.",
        "not_claimed": ["Geometric realizability of arbitrary algebraic jets", "The analytic minimizing-cone contradiction", "Independent Reviewer acceptance"],
        "inputs": {
            "table_I": "build/appendices/tables.tex:Table I",
            "table_II": "build/appendices/tables.tex:Table II",
            "coefficient_denominator": Q,
            "table_I_rows": {name: sum(row[0] == name for row in ROWS) for name in RANK},
            "interior_blocks": 19, "interior_rows": 529,
            "boundary_blocks": 2, "boundary_rows": 28
        },
        "interior": interior,
        "boundary": boundary,
        "positive_projections": projections,
        "universal_contraction_identity": contraction_identity,
        "exact_component_semantics": semantic_check,
        "jacobian": {
            "operation_id": jacobian["request"]["operation_id"],
            "server_version": jacobian["server"]["version"],
            "protocol_version": jacobian["protocol_version"],
            "adapter_exit_code": 0, "error": None, "timeout": False,
            "role": "One exact evaluation of the printed comparison form, not a universal tensor proof."
        }
    }
    certificate = json.loads(json.dumps(certificate))
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        assert json.loads(target.read_text()) == certificate
    print(json.dumps({
        "result": "PASS universal interior and boundary certificate",
        "remainder_terms": interior["nonzero_remainder_terms"],
        "boundary_coefficients": len(boundary["averaged_homogeneous_remainder"]),
        "epsilon": interior["epsilon"], "delta": boundary["delta"],
        "exact_component_checks": semantic_check,
        "elapsed_seconds": round(time.monotonic() - started, 3)
    }, indent=2), flush=True)


if __name__ == "__main__":
    main()
