#!/usr/bin/env python3
"""Independently construct the characteristic-number constraints over QQ."""

import json
from functools import lru_cache
from math import factorial
from pathlib import Path
from time import monotonic

import sympy as sp
from sympy.polys.domains import QQ
from sympy.polys.matrices import DomainMatrix
from sympy.polys.rings import ring


ROOT = Path(__file__).resolve().parent
WEIGHTS = (1, 2, 3, 4, 5, 6, 1, 1, 2, 3)
BASE = tuple(range(6))
INVARIANT = (6, 7, 8, 9)
ALL = tuple(range(10))
J = (0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 16, 17)
R, h, x2, x3, x4, x5, x6, ell, r, s, t = ring(
    "h,x2,x3,x4,x5,x6,ell,r,s,t", QQ
)
GENERATORS = R.gens


@lru_cache(None)
def monomials(weight, indices):
    if weight < 0:
        return ()
    if not indices:
        return ((0,) * 10,) if weight == 0 else ()
    index = indices[0]
    answer = []
    for degree in range(weight // WEIGHTS[index] + 1):
        for tail in monomials(weight - degree * WEIGHTS[index], indices[1:]):
            entry = list(tail)
            entry[index] = degree
            answer.append(tuple(entry))
    return tuple(sorted(answer, key=lambda powers: powers[::-1]))


def monomial(powers):
    return R.from_dict({powers: QQ.one})


def symmetric_to_shifted(expression, roots):
    symmetric, remainder, elementary = sp.symmetrize(
        expression, roots, formal=True
    )
    assert remainder == 0
    hs, rs, ss, ts = (R.symbols[i] for i in (0, 7, 8, 9))
    chern = (
        rs - 3 * hs,
        ss - 2 * hs * rs + 3 * hs**2,
        ts - hs * ss + hs**2 * rs - hs**3,
    )
    substitutions = {
        symbol: value for (symbol, _), value in zip(elementary, chern)
    }
    return R.from_expr(symmetric.subs(substitutions, simultaneous=True))


def characteristic_polynomials():
    roots = sp.symbols("a b d")
    todd_factor = (
        1, sp.Rational(1, 2), sp.Rational(1, 12), 0,
        -sp.Rational(1, 720), 0, sp.Rational(1, 30240), 0,
        -sp.Rational(1, 1209600), 0,
    )
    for degree in range(1, 11):
        coefficient = sum(
            todd_factor[j] * sp.Rational((-1)**(degree-j+1), factorial(degree-j))
            for j in range(degree)
        )
        assert coefficient == (1 if degree == 1 else 0)
    root_todd = []
    for weight in range(10):
        expression = 0
        for i in range(weight + 1):
            for j in range(weight - i + 1):
                k = weight - i - j
                expression += (
                    todd_factor[i] * todd_factor[j] * todd_factor[k]
                    * roots[0]**i * roots[1]**j * roots[2]**k
                )
        root_todd.append(sp.expand(expression))
    root_powers = [sum(a**i for a in roots) for i in range(11)]
    q = [symmetric_to_shifted(power, roots) for power in root_powers]
    theta = [
        symmetric_to_shifted(expression, roots) for expression in root_todd
    ]
    psi = [
        symmetric_to_shifted(
            sp.expand(sum(
                sp.Rational((-1)**j, factorial(j))
                * root_powers[j] * root_todd[i - j]
                for j in range(i + 1)
            )),
            roots,
        )
        for i in range(10)
    ]
    assert q[0] == 3 and q[1] == r - 3 * h
    assert theta[1] == (r - 3 * h) / 2
    assert theta[2] == ((r - 3 * h)**2 + s - 2*h*r + 3*h**2) / 12
    return q, theta, psi


def replace_h(polynomial, replacement):
    result = R.zero
    for powers, coefficient in polynomial.items():
        term = coefficient * replacement**powers[0]
        for generator, exponent in zip(GENERATORS[1:], powers[1:]):
            term *= generator**exponent
        result += term
    return result


def build_constraints():
    q, theta, psi = characteristic_polynomials()
    c = 2 * h - ell
    D = [R.zero]
    for i in range(1, 11):
        numerator = c**i - q[i] - (-c)**i + replace_h(q[i], ell - h)
        D.append(numerator.exquo(c))
    assert D[1] == 5 and D[2] == 2*r - 3*ell
    conjugates = (ell - h,) + tuple(
        GENERATORS[i] - c * D[i + 1] for i in range(1, 6)
    )

    @lru_cache(None)
    def delta(powers):
        original = monomial(powers)
        conjugate = R.one
        for generator, degree in zip(conjugates, powers[:6]):
            conjugate *= generator**degree
        return (original - conjugate).exquo(c)

    columns = monomials(9, ALL)
    column_index = {powers: i for i, powers in enumerate(columns)}
    rows = []
    descriptions = []

    def append(polynomial, description):
        if polynomial:
            rows.append({
                column_index[powers]: coefficient
                for powers, coefficient in polynomial.items()
            })
            descriptions.append(description)

    for weight in range(11):
        for powers in monomials(weight, BASE):
            m = monomial(powers)
            if weight <= 6:
                for w in monomials(9 - weight, INVARIANT):
                    append(monomial(w) * (m - h*delta(powers)),
                           ["descent", list(powers), list(w)])
                for w in monomials(10 - weight, INVARIANT):
                    append(monomial(w) * delta(powers),
                           ["integrated_descent", list(powers), list(w)])
            else:
                for w in monomials(9 - weight, ALL):
                    append(monomial(w) * m,
                           ["base_dimension", list(powers), list(w)])
                for w in monomials(10 - weight, ALL):
                    append(monomial(w) * delta(powers),
                           ["integrated_base_dimension", list(powers), list(w)])
        if weight >= 7:
            for w in monomials(10 - weight, ALL):
                append(monomial(w) * D[weight],
                       ["high_character", weight, list(w)])
        if 4 <= weight <= 9:
            for w in monomials(9 - weight, BASE):
                append(monomial(w) * theta[weight],
                       ["todd", weight, list(w)])
                append(monomial(w) * psi[weight],
                       ["todd_dual", weight, list(w)])
    A = DomainMatrix(dict(enumerate(rows)), (len(rows), len(columns)), QQ)
    M = monomials(6, BASE)
    G = monomials(3, INVARIANT) + monomials(4, INVARIANT)
    coordinates = [
        (i, j) for i, powers in enumerate(M) for j in J
        if sum(a*b for a, b in zip(G[j], WEIGHTS)) == 3 or powers[0]
    ]
    selected = []
    for i, j in coordinates:
        powers = [a + b for a, b in zip(M[i], G[j])]
        powers[0] -= sum(a*b for a, b in zip(G[j], WEIGHTS)) - 3
        selected.append(column_index[tuple(powers)])
    assert A.shape == (1785, 581)
    assert len(M) == 11 and len(G) == 18 and len(coordinates) == 129
    return A, columns, descriptions, M, G, coordinates, selected


def encode_rows(matrix):
    data = matrix.to_sparse().rep.to_sdm()
    return [
        [[j, str(value)] for j, value in sorted(data.get(i, {}).items())]
        for i in range(matrix.shape[0])
    ]


def main():
    started = monotonic()
    A, columns, descriptions, M, G, coordinates, selected = build_constraints()
    print(f"independent A {A.shape}; construction {monotonic()-started:.3f}s",
          flush=True)
    K = A.nullspace(divide_last=True).transpose()
    assert K.shape == (581, 65)
    assert (A * K).is_zero_matrix
    print(f"rational kernel complete {monotonic()-started:.3f}s", flush=True)
    P = K.extract(selected, list(range(K.shape[1])))
    N = P.transpose().nullspace(divide_last=True).rref()[0]
    assert N.shape == (69, 129)
    assert (N * P).is_zero_matrix
    result = {
        "variables": [str(symbol) for symbol in R.symbols],
        "weights": list(WEIGHTS),
        "columns": [list(powers) for powers in columns],
        "row_descriptions": descriptions,
        "A": encode_rows(A),
        "K": encode_rows(K),
        "N": encode_rows(N),
        "M": [list(powers) for powers in M],
        "G": [list(powers) for powers in G],
        "J": list(J),
        "C1": [list(coordinate) for coordinate in coordinates],
        "selected": selected,
    }
    (ROOT / "linear_data.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="ascii"
    )
    print(f"rational N complete {monotonic()-started:.3f}s", flush=True)
    print(f"N nonzeros {sum(len(row) for row in result['N'])}", flush=True)


if __name__ == "__main__":
    main()
