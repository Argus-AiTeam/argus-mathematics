"""Direct component evaluation of the printed Table I and its first jets."""

from itertools import combinations_with_replacement, permutations, product
from fractions import Fraction
from pathlib import Path
import re

import numpy as np


MANUSCRIPT = (
    Path(__file__).resolve().parents[1]
    / "openai_manuscript"
    / "The-critical-dimension-for-one-phase-Bernoulli-minimizers-September-24-2026"
)
TABLES = MANUSCRIPT / "build/appendices/tables.tex"
RANK = {"f": 0, "U": 2, "K": 4, "M": 1, "P": 1}
Q = 250000


def table_one():
    rows = []
    for name, word, coefficient in re.findall(
        r"^([fUKMP]) (\d+) (-?\d+)$", TABLES.read_text(), re.M
    ):
        rank = RANK[name]
        assert len(word) % 3 == 0
        h, b, j = map(int, word[:3])
        edges = [tuple(map(int, word[k : k + 3])) for k in range(3, len(word), 3)]
        endpoints = [u for edge in edges for u in edge[:2]]
        assert j == 0 and all(u < rank or u == 5 for u in endpoints)
        assert all(endpoints.count(i) == 1 for i in range(rank))
        assert name != "P" or h > 0
        assert name not in ("U", "K") or endpoints.count(5) % 2 == 0
        rows.append((name, word, int(coefficient), h, b, edges))
    assert {name: sum(row[0] == name for row in rows) for name in RANK} == {
        "f": 34, "U": 57, "K": 34, "M": 74, "P": 32
    }
    return rows


def cubic_basis():
    omitted = {tuple(sorted((i, 4, 4))) for i in range(5)}
    triples = [t for t in combinations_with_replacement(range(5), 3) if t not in omitted]
    basis = np.zeros((32, 5, 5, 5))
    for n, triple in enumerate(triples):
        for t in set(permutations(triple)):
            basis[(n,) + t] = 1
        for i in range(5):
            correction = -sum(basis[n, i, j, j] for j in range(4))
            for t in set(permutations((i, 4, 4))):
                basis[(n,) + t] = correction
    assert len(triples) == 30
    assert np.array_equal(basis, basis.transpose(0, 2, 1, 3))
    assert np.array_equal(basis, basis.transpose(0, 1, 3, 2))
    assert not np.trace(basis, axis1=2, axis2=3).any()
    return basis


ROWS = table_one()
XBASIS = cubic_basis()


def coefficients(A, p, g):
    """Return F and D_l F, linear in (30 cubic coordinates,w,z)."""
    powers = [np.eye(5), A, A @ A, A @ A @ A]
    q = np.einsum("mlij,ij->lm", XBASIS, A)
    dA = XBASIS.transpose(1, 0, 2, 3) - q[:, :, None, None] * A
    dp = np.zeros((5, 32, 5))
    dp[:, 30, :] = A
    dp[:, 31, :] = -g * np.eye(5)
    dg = np.zeros((5, 32))
    dg[:, 31] = p
    dpowers = [np.zeros((5, 32, 5, 5))]
    for k in range(1, 4):
        dpowers.append(sum(powers[h] @ dA @ powers[k - 1 - h] for h in range(k)))
    vectors = [B @ p for B in powers]
    dvectors = [
        np.einsum("lmij,j->lmi", dB, p) + np.einsum("ij,lmj->lmi", B, dp)
        for B, dB in zip(powers, dpowers)
    ]
    scalars = [p @ v for v in vectors]
    dscalars = [
        np.einsum("lmi,i->lm", dp, v) + np.einsum("i,lmi->lm", p, dv)
        for v, dv in zip(vectors, dvectors)
    ]
    t3 = np.trace(powers[3])
    dt3 = np.trace(dpowers[3], axis1=2, axis2=3)
    values = {name: np.zeros((5,) * rank) for name, rank in RANK.items()}
    derivatives = {name: np.zeros((5, 32) + (5,) * rank) for name, rank in RANK.items()}
    for name, word, c, h, b, edges in ROWS:
        rank = RANK[name]
        factors = [(g**h * t3**b, (
            (h * g ** (h - 1) * t3**b * dg if h else 0)
            + (b * g**h * t3 ** (b - 1) * dt3 if b else 0)
        ), ())]
        for u, v, k in edges:
            if u == v == 5:
                factors.append((scalars[k], dscalars[k], ()))
            elif u == 5 or v == 5:
                factors.append((vectors[k], dvectors[k], (v if u == 5 else u,)))
            else:
                slots = (u, v)
                B, dB = powers[k], dpowers[k]
                if u > v:
                    slots = (v, u)
                    B, dB = B.T, dB.transpose(0, 1, 3, 2)
                factors.append((B, dB, slots))
        value = np.ones((5,) * rank)
        derivative = np.zeros((5, 32) + (5,) * rank)
        for base, jet, slots in factors:
            shape = tuple(5 if i in slots else 1 for i in range(rank))
            base = np.asarray(base).reshape(shape)
            if np.isscalar(jet):
                jet = np.zeros((5, 32))
            jet = np.asarray(jet).reshape((5, 32) + shape)
            derivative = derivative * base + value * jet
            value = value * base
        values[name] += c / Q * value
        derivatives[name] += c / Q * derivative
    return values, derivatives, q


def interior_matrix(A, p, g):
    F, D, q = coefficients(A, p, g)
    f, U, K, M, P = (F[name] for name in ("f", "U", "K", "M", "P"))
    C = K - K.swapaxes(0, 1)
    G = np.eye(5)[:, :, None, None] * U + C
    dGcontract = (
        D["U"].transpose(1, 0, 2, 3)
        + np.einsum("lmlijk->mijk", D["K"])
        - np.einsum("lmiljk->mijk", D["K"])
    )
    cubic_term = dGcontract + 4 / 25 * np.einsum("lm,lijk->mijk", q, G)
    B = np.zeros((37, 37))
    B[:32, :32] = np.einsum("mijk,nijk->mn", cubic_term, XBASIS)
    B[31, 31] += (
        5 * np.sum(U * A)
        + np.einsum("lilk,ik", C, A)
        + np.einsum("lijl,ij", C, A)
        - 4 * f
    )
    B[30, :32] += np.einsum("lml->m", D["M"]) + 54 / 25 * np.einsum("lm,l->m", q, M)
    B[31, :32] += np.einsum("lml->m", D["P"]) + 29 / 25 * np.einsum("lm,l->m", q, P)
    B[32:, 32:] += f * np.eye(5)
    B[32:, :32] -= D["f"] + 29 / 25 * f * q
    return (B + B.T) / 2


def boundary(A, p):
    F, _, _ = coefficients(A, p, 0)
    f, U, K, M = (F[name] for name in ("f", "U", "K", "M"))
    lam = p @ A @ p
    S0 = lam * A - A @ A
    V = (
        np.einsum("i,jk->ijk", p, S0)
        + np.einsum("j,ki->ijk", p, S0)
        + np.einsum("k,ij->ijk", p, S0)
        + np.einsum("i,j,k->ijk", p, p, p)
    )
    C = K - K.swapaxes(0, 1)
    return -lam * f + np.sum(U * (S0 + np.outer(p, p))) + np.einsum("lijk,l,ijk", C, p, V) + p @ M


def exact_component_check(Tensor, interior_row, I25Q, gamma, blocks):
    """Component-level regressions, separate from the universal symbolic proof."""
    integer_A = np.diag([1, 1, 3, -5, 0]).astype(np.int64)
    integer_p = np.array([1, -2, 1, -1, 1], dtype=np.int64)
    ell = np.array([-1, 2, 0, 1, -2], dtype=np.int64)
    X = sum(((7 * n + 3) % 5 - 2) * XBASIS[n].astype(np.int64) for n in range(30))
    A = integer_A.astype(object) * Fraction(1, 6)
    p = integer_p.astype(object) * Fraction(1, 4)
    g, w, z = Fraction(-1, 2), -2, 3
    identity = np.eye(5, dtype=np.int64)
    assert np.trace(A) == 0 and np.sum(A * A) == 1
    assert g * g + p @ p < 1 and w < 0
    assert np.array_equal(X, X.swapaxes(0, 1)) and np.array_equal(X, X.swapaxes(1, 2))
    assert not np.trace(X, axis1=1, axis2=2).any()
    q = np.array([np.sum(X[l] * A) for l in range(5)], dtype=object)
    assert all(v != 0 for v in q)
    dA = X.astype(object) - q[:, None, None] * A
    dp = w * A - g * z * identity
    dg = z * p
    powers = [identity.astype(object), A, A @ A, A @ A @ A]
    dpowers = [np.zeros((5, 5, 5), dtype=object)]
    for k in range(1, 4):
        dpowers.append(sum(powers[h] @ dA @ powers[k - 1 - h] for h in range(k)))
    vectors = [B @ p for B in powers]
    dvectors = [dB @ p + np.stack([B @ dp[l] for l in range(5)]) for B, dB in zip(powers, dpowers)]
    scalars = [p @ v for v in vectors]
    dscalars = [np.array([dp[l] @ v + p @ dv[l] for l in range(5)], dtype=object)
                for v, dv in zip(vectors, dvectors)]
    t3 = np.trace(powers[3])
    dt3 = np.trace(dpowers[3], axis1=1, axis2=2)
    integer_powers = {0: identity, 1: integer_A}

    def network_component(rank, key):
        h, wp, zp, traces, edges = key
        operands = []
        next_index = rank
        x_indices = {-3: [], -4: []}
        def endpoint(u):
            nonlocal next_index
            if u >= 0:
                return u
            index = next_index
            next_index += 1
            if u == -1:
                operands.extend((integer_p, [index]))
            elif u == -2:
                operands.extend((ell, [index]))
            else:
                x_indices[u].append(index)
            return index
        degree_A = sum(traces) + sum(k for _, _, k in edges)
        p_count = sum(u == -1 for edge in edges for u in edge[:2])
        ell_count = sum(u == -2 for edge in edges for u in edge[:2])
        x_count = 0
        for u, v, k in edges:
            if k not in integer_powers:
                integer_powers[k] = np.linalg.matrix_power(integer_A, k)
            operands.extend((integer_powers[k], [endpoint(u), endpoint(v)]))
        for indices in x_indices.values():
            if indices:
                assert len(indices) == 3
                operands.extend((X, indices))
                x_count += 1
        bound = 5 ** len(edges) * 5**sum(k for _, _, k in edges) * 2 ** (p_count + ell_count) * int(np.max(np.abs(X))) ** x_count
        assert bound < 2**63
        if operands:
            numerator = np.einsum(*operands, list(range(rank)), optimize="greedy")
        else:
            numerator = np.array(1, dtype=np.int64)
        trace_numerator = 1
        for k in traces:
            trace_numerator *= sum(int(a) ** k for a in np.diag(integer_A))
        scalar = Fraction((-1)**h * w**wp * z**zp * trace_numerator, 2**h * 6**degree_A * 4**p_count)
        return np.asarray(np.asarray(numerator, dtype=object) * scalar, dtype=object)

    def value(polynomial):
        assert polynomial.rank == 0
        return sum((coefficient * network_component(0, key).item()
                    for key, coefficient in polynomial.terms.items()), Fraction(0))

    def differentiated_row(row):
        name, _, _, h, b, edges = row
        rank = RANK[name]
        factors = [(g**h * t3**b, (
            (h * g ** (h - 1) * t3**b * dg if h else 0)
            + (b * g**h * t3 ** (b - 1) * dt3 if b else 0)
        ), ())]
        for u, v, k in edges:
            if u == v == 5:
                factors.append((scalars[k], dscalars[k], ()))
            elif u == 5 or v == 5:
                factors.append((vectors[k], dvectors[k], (v if u == 5 else u,)))
            else:
                slots = (min(u, v), max(u, v))
                B, dB = powers[k], dpowers[k]
                if u > v:
                    B, dB = B.T, dB.transpose(0, 2, 1)
                factors.append((B, dB, slots))
        base = np.ones((5,) * rank, dtype=object)
        derivative = np.zeros((5,) * (rank + 1), dtype=object)
        for factor, jet, slots in factors:
            shape = tuple(5 if i in slots else 1 for i in range(rank))
            factor = np.asarray(factor, dtype=object).reshape(shape)
            if np.isscalar(jet):
                jet = np.zeros(5, dtype=object)
            jet = np.asarray(jet, dtype=object).reshape((5,) + shape)
            derivative = derivative * factor + base * jet
            base = base * factor
        return np.asarray(base, dtype=object), np.asarray(derivative, dtype=object)

    def row_interior(name, tensor, derivative):
        if name == "f":
            f = tensor.item()
            return -4 * z*z * f + f * (ell @ ell) - (derivative + Fraction(29, 25) * q * f) @ ell
        if name == "U":
            return (5 * z*z * np.sum(tensor * A) + np.sum(derivative * X)
                    + Fraction(4, 25) * sum(q[l] * np.sum(tensor * X[l]) for l in range(5)))
        if name == "K":
            C = tensor - tensor.swapaxes(0, 1)
            dC = derivative - derivative.swapaxes(1, 2)
            curvature = sum(C[l, i, l, k] * A[i, k] + C[l, i, k, l] * A[i, k]
                            for l, i, k in product(range(5), repeat=3))
            differentiated = sum(np.sum(dC[l, l] * X) for l in range(5))
            normalization = Fraction(4, 25) * sum(q[l] * np.sum(C[l] * X) for l in range(5))
            return z*z * curvature + differentiated + normalization
        scalar, coupling = (w, Fraction(54, 25)) if name == "M" else (z, Fraction(29, 25))
        return scalar * (np.trace(derivative) + coupling * (q @ tensor))

    I = Fraction(0)
    for row in ROWS:
        name, word, coefficient, _, _, _ = row
        tensor, derivative = differentiated_row(row)
        direct = row_interior(name, tensor, derivative)
        symbolic = interior_row(name, Tensor.word(RANK[name], word))
        assert value(symbolic) == 25 * direct, (name, word)
        I += Fraction(coefficient, Q) * direct
    assert value(I25Q) == 25 * Q * I

    def dense_project(tensor, rank, kind):
        if kind == "none":
            return tensor
        sym = sum(((-1) ** sum(p[i] > p[j] for i in range(rank) for j in range(i + 1, rank))
                   if kind == "anti" else 1) * tensor.transpose(p) for p in permutations(range(rank)))
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

    direct_gamma = Fraction(0)
    for block in blocks:
        rank = block["rank"]
        if rank < 0:
            continue
        columns = [np.zeros((5,) * rank, dtype=object) for _ in block["rows"][0][1]]
        for word, coefficients in block["rows"]:
            h, b, j = map(int, word[:3])
            endpoint_map = {5: -1, 6: -2, 7: -3, 8: -4}
            edges = []
            for i in range(3, len(word), 3):
                u, v, k = map(int, word[i : i + 3])
                edges.append((endpoint_map.get(u, u), endpoint_map.get(v, v), k))
            component = network_component(rank, (h, int(j == 1), int(j == 2), (3,) * b, edges))
            for column, coefficient in zip(columns, coefficients):
                column += coefficient * component
        weight = 1 - p @ p - g*g if block["mode"] == "B" else 1
        for column in columns:
            direct_gamma += weight * np.sum(column * dense_project(column, rank, block["kind"]))
    assert value(gamma) == direct_gamma
    return {
        "classification": "exact component regressions supplementing the universal Einstein-index proof",
        "A_diagonal": [str(Fraction(a, 6)) for a in [1, 1, 3, -5, 0]],
        "p": list(map(str, p)), "g": str(g), "w": w, "z": z,
        "trace_free_cubic_dimension": 30,
        "nonzero_q_coordinates": 5,
        "Table_I_row_identities_checked_exactly": len(ROWS),
        "Table_II_interior_block_sum_checked_exactly": 19,
        "I": str(I),
        "Q_squared_Gamma": str(direct_gamma)
    }
