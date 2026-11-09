#!/usr/bin/env python3
"""Replay exact integer identities and direct tensor-index contractions."""

import argparse
import itertools
import json
import math
from pathlib import Path


if not __debug__:
    raise RuntimeError("Run without -O: exact identity checks require assertions")


I = ((1, 0), (0, 1))
Z = ((1, 0), (0, -1))
T = ((0, 1), (1, 0))
J = ((0, 1), (-1, 0))
ZERO = ((0, 0), (0, 0))
Q = ((1, 1), (1, 2))
QI = ((2, -1), (-1, 1))
M = (I, Z, T, J)


def add(a, b):
    return tuple(tuple(a[i][j] + b[i][j] for j in range(2)) for i in range(2))


def scale(c, a):
    return tuple(tuple(c * x for x in row) for row in a)


def mul(a, b):
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )


def transpose(a):
    return tuple(zip(*a))


def adj(a):
    return ((a[1][1], -a[0][1]), (-a[1][0], a[0][0]))


def matrix_product(xs):
    out = I
    for x in xs:
        out = mul(out, x)
    return out


N = tuple(mul(mul(Q, x), QI) for x in M)


def sign(xs):
    inversions = sum(x > y for i, x in enumerate(xs) for y in xs[i + 1 :])
    return (-1) ** inversions


def determinant(a):
    n = len(a)
    return sum(
        sign(p) * math.prod(a[i][p[i]] for i in range(n))
        for p in itertools.permutations(range(n))
    )


def segment(basis, r, even):
    out = ZERO
    for p in itertools.permutations(range(r)):
        word = [adj(basis[x]) if even ^ (i % 2) else basis[x] for i, x in enumerate(p)]
        out = add(out, scale(sign(p), matrix_product(word)))
    return out


def raw_segment(r, even):
    """Actual index transfers: transpose at even slots, then a J edge."""
    out = ZERO
    for p in itertools.permutations(range(r)):
        word = [
            mul(transpose(N[x]) if even ^ (i % 2) else N[x], J)
            for i, x in enumerate(p)
        ]
        out = add(out, scale(sign(p), matrix_product(word)))
    return out


def actual_tensor(columns, basis):
    """Expand the generator's two independent layers, not a matrix recurrence."""
    k = sum(columns)
    if k <= 0 or k % 2 != 1 or any(r not in range(1, 5) for r in columns):
        raise ValueError("Expected column lengths 1..4 with positive odd total")
    t = (k - 1) // 2
    total = 0
    for row_bits in itertools.product(range(2), repeat=t):
        a = [0] * k
        row_sign = 1
        for i, bit in enumerate(row_bits):
            a[2 * i + 1], a[2 * i + 2] = bit, 1 - bit
            row_sign *= J[bit][1 - bit]
        for col_bits in itertools.product(range(2), repeat=t):
            b = [0] * k
            coefficient = row_sign
            for i, bit in enumerate(col_bits):
                b[2 * i], b[2 * i + 1] = bit, 1 - bit
                coefficient *= J[bit][1 - bit]
            value = coefficient
            start = 0
            for r in columns:
                # Rows are path slots; columns are the initial r test covectors.
                value *= determinant(
                    [[basis[j][a[start + i]][b[start + i]] for j in range(r)] for i in range(r)]
                )
                start += r
            total += value
    return total


def actual_word(xs):
    """The same physical generator paired with one unalternated matrix word."""
    k = len(xs)
    t = (k - 1) // 2
    total = 0
    for rb in itertools.product(range(2), repeat=t):
        a = [0] * k
        rs = 1
        for i, bit in enumerate(rb):
            a[2 * i + 1], a[2 * i + 2] = bit, 1 - bit
            rs *= J[bit][1 - bit]
        for cb in itertools.product(range(2), repeat=t):
            b = [0] * k
            c = rs
            for i, bit in enumerate(cb):
                b[2 * i], b[2 * i + 1] = bit, 1 - bit
                c *= J[bit][1 - bit]
            total += c * math.prod(x[a[i]][b[i]] for i, x in enumerate(xs))
    return total


def recurrence(columns, basis=N):
    even = 0
    result = I
    for r in columns:
        result = mul(result, segment(basis, r, even))
        even ^= r % 2
    return (-1) ** ((sum(columns) - 1) // 2) * result[0][0]


def compositions(n):
    if n == 0:
        yield ()
    for r in range(1, min(4, n) + 1):
        for tail in compositions(n - r):
            yield (r,) + tail


def certificate():
    if mul(Q, QI) != I or mul(QI, Q) != I:
        raise AssertionError("Conjugator inverse")
    units = tuple(
        tuple(tuple(int(i == a and j == b) for j in range(2)) for i in range(2))
        for a in range(2)
        for b in range(2)
    )
    for x in units:
        assert mul(mul(J, transpose(x)), J) == scale(-1, adj(x))
        assert adj(mul(mul(Q, x), QI)) == mul(mul(Q, adj(x)), QI)
        for y in units:
            assert mul(mul(x, J), mul(transpose(y), J)) == scale(-1, mul(x, adj(y)))
    assert add(mul(J, J), I) == ZERO

    tables = []
    raw_normalized = {}
    for even in range(2):
        for r in range(1, 5):
            a = segment(M, r, even)
            f = math.factorial(r)
            e = sum((even + i) % 2 for i in range(r))
            expected = scale(f * (-1) ** (e - even), matrix_product(M[:r]))
            assert a == expected
            an = segment(N, r, even)
            assert an == mul(mul(Q, a), QI)
            raw = raw_segment(r, even)
            assert all(x % f == 0 for row in raw for x in row)
            normalized = tuple(tuple(x // f for x in row) for row in raw)
            raw_normalized[even, r] = normalized
            tables.append(
                dict(even_start=bool(even), length=r, segment=a, conjugated=an,
                     raw_transfer=raw, raw_normalized=normalized)
            )

    signed = N + tuple(scale(-1, x) for x in N)
    transitions = []
    for even in range(2):
        for g, base in enumerate(signed):
            state = mul(base, J if even else I)
            for r in range(1, 5):
                next_even = even ^ (r % 2)
                target = mul(state, raw_normalized[even, r])
                matches = [
                    h for h, candidate in enumerate(signed)
                    if mul(candidate, J if next_even else I) == target
                ]
                assert len(matches) == 1
                transitions.append([even, g, r, next_even, matches[0]])
    endpoints = [mul(x, J)[0][1] for x in signed]
    assert all(x in (-3, -1, 1, 3) for x in endpoints)
    coordinates = [[x[i][j] for x in N] for i in range(2) for j in range(2)]
    basis_det = determinant(coordinates)
    assert abs(basis_det) == 4

    word_checks = 0
    for k in (1, 3, 5):
        for xs in itertools.product(units, repeat=k):
            expected = (-1) ** ((k - 1) // 2) * matrix_product(
                [adj(x) if i % 2 else x for i, x in enumerate(xs)]
            )[0][0]
            assert actual_word(xs) == expected
            word_checks += 1

    direct_checks = 0
    epsilon_counts = dict.fromkeys(("-3", "-1", "1", "3"), 0)
    for k in (1, 3, 5, 7, 9):
        for columns in compositions(k):
            observed = actual_tensor(columns, N)
            assert observed == recurrence(columns)
            f = math.prod(math.factorial(r) for r in columns)
            assert observed % f == 0
            epsilon = observed // f
            assert epsilon in (-3, -1, 1, 3)
            epsilon_counts[str(epsilon)] += 1
            direct_checks += 1

    assert actual_tensor((3, 2), M) == 0
    witnesses = []
    for columns in ((1,), (3,), (2, 1), (3, 2), (4, 3, 2)):
        value = actual_tensor(columns, N)
        assert value == recurrence(columns)
        witnesses.append(dict(columns=columns, actual=value,
                              epsilon=value // math.prod(math.factorial(r) for r in columns)))
    return dict(
        claim="C_ODD_PATH_UNIFORM",
        theorem="For every ordered column list in {1,2,3,4} of odd total length, "
                "the fixed-endpoint contraction in basis N equals epsilon times "
                "the product of column factorials, epsilon in {-3,-1,1,3}.",
        conventions=dict(indexing="zero-based; manuscript letter 1 is 0",
                         row_pairs="(1,2),(3,4),... zero-based",
                         column_pairs="(0,1),(2,3),... zero-based",
                         endpoints="a[0]=b[k-1]=0",
                         pair_coefficient="J[a,b] in increasing path order",
                         final_transfer_boundary="1, since J[b,1] is delta(b,0)",
                         companion_generator="u=(-1)^t*u_(m,2), t=m-1"),
        Q=Q, Q_inverse=QI, basis=N, basis_coordinate_determinant=basis_det,
        segment_tables=tables, normalized_signed_states=signed,
        transitions=transitions, odd_endpoint_values=endpoints,
        induction=dict(base="empty prefix: parity=odd-start, signed-state=I, weight=1",
                       step="Each transition multiplies the weight by length! "
                            "and is an exact raw index-transfer identity.",
                       invariant="prefix transfer = factorial weight times "
                                 "signed conjugated Pauli matrix times J^parity",
                       conclusion="Odd total ends with J; its (0,1) entry is "
                                  "the physical fixed-endpoint contraction.",
                       unbounded_proof="REPORT.md; kernel proof in Main.lean"),
        independent_direct_checks=dict(odd_lengths=[1, 3, 5, 7, 9],
                                       ordered_lists=direct_checks,
                                       epsilon_counts=epsilon_counts,
                                       matrix_unit_words=word_checks,
                                       purpose="Regression/semantic checks, not the unbounded proof"),
        old_basis_zero=dict(columns=[3, 2], actual=0, manuscript_claim_refuted=False),
        witnesses=witnesses,
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    path = Path(__file__).with_name("exact_certificate.json")
    computed = json.loads(json.dumps(certificate()))
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2) + "\n")
    else:
        stored = json.loads(path.read_text())
        if computed != stored:
            raise AssertionError("Stored certificate differs from exact recomputation")
    print(json.dumps(dict(ok=True, claim=computed["claim"],
                          direct_checks=computed["independent_direct_checks"],
                          exact_transitions=len(computed["transitions"])),
                     sort_keys=True))


if __name__ == "__main__":
    main()
