#!/usr/bin/env python3
"""Replay the direct rational certificate without importing the manuscript."""

import argparse
import json
from fractions import Fraction
from functools import lru_cache
from itertools import combinations_with_replacement
from math import factorial
from pathlib import Path

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


def combine(first, second, left, right, divisor):
    assert type(left) is int and type(right) is int
    assert type(divisor) is int and divisor > 0
    result = {column: left*value for column, value in first.items()}
    for column, value in second.items():
        result[column] = result.get(column, 0) - right*value
    assert all(value % divisor == 0 for value in result.values())
    return {
        column: value // divisor for column, value in result.items() if value
    }


def replay(nodes, leaves, roots):
    references = [0] * len(nodes)
    for index, operation in enumerate(nodes):
        if operation[0] == "op":
            assert len(operation) == 6
            for parent in operation[1:3]:
                assert type(parent) is int and 0 <= parent < index
                references[parent] += 1
    for root in roots:
        assert type(root) is int and 0 <= root < len(nodes)
        references[root] += 1
    rows = [None] * len(nodes)
    for index, operation in enumerate(nodes):
        assert isinstance(operation, list) and operation
        if operation[0] == "op":
            assert len(operation) == 6
            _, a, b, left, right, divisor = operation
            assert type(a) is int and type(b) is int
            assert 0 <= a < index and 0 <= b < index
            row = combine(rows[a], rows[b], left, right, divisor)
            for parent in (a, b):
                references[parent] -= 1
                if references[parent] == 0:
                    rows[parent] = None
        else:
            row = leaves(operation)
        assert all(type(j) is int and type(v) is int and v for j, v in row.items())
        rows[index] = row
    return {root: rows[root] for root in roots}


def rational_matrix(rows, columns):
    data = {}
    for i, entries in enumerate(rows):
        row = {}
        for j, value in entries:
            assert type(j) is int and 0 <= j < columns and j not in row
            coefficient = Fraction(value)
            assert coefficient
            row[j] = QQ(coefficient.numerator, coefficient.denominator)
        if row:
            data[i] = row
    return DomainMatrix(data, (len(rows), columns), QQ)


def verify_rank_certificate(certificate, A, M, G, C1, selected):
    import numpy as np

    prime = certificate["prime"]
    assert prime == 10007
    assert all(prime % d for d in range(2, 101))
    assert 6820*(prime-1)**2 < 2**63 - 1
    K = rational_matrix(certificate["K"], 65)
    N = rational_matrix(certificate["N"], 129)
    assert K.shape == (581, 65) and N.shape == (69, 129)
    P = K.extract(selected, list(range(65)))
    assert (A*K).is_zero_matrix
    assert (N*P).is_zero_matrix

    def reduce_matrix(matrix):
        result = np.zeros(matrix.shape, dtype=np.int64)
        for i, row in matrix.to_sparse().rep.to_sdm().items():
            for j, value in row.items():
                value = Fraction(str(value))
                assert value.denominator % prime != 0
                result[i, j] = (
                    value.numerator*pow(value.denominator, -1, prime) % prime
                )
        return result

    def multiply(left, right):
        assert left.shape[1] == right.shape[0] <= 6820
        assert left.dtype == right.dtype == np.dtype("int64")
        return (left @ right) % prime

    def field_kernel(matrix):
        echelon = matrix.copy() % prime
        row = 0
        pivots = []
        for column in range(echelon.shape[1]):
            available = np.flatnonzero(echelon[row:, column])
            if not len(available):
                continue
            other = row + int(available[0])
            echelon[[row, other]] = echelon[[other, row]]
            echelon[row] = (
                echelon[row]*pow(int(echelon[row, column]), -1, prime)
            ) % prime
            if row + 1 < echelon.shape[0]:
                factors = echelon[row+1:, column:column+1].copy()
                echelon[row+1:] = (
                    echelon[row+1:] - factors*echelon[row:row+1]
                ) % prime
            pivots.append(column)
            row += 1
            if row == echelon.shape[0]:
                break
        free = [j for j in range(echelon.shape[1]) if j not in set(pivots)]
        basis = np.zeros((echelon.shape[1], len(free)), dtype=np.int64)
        basis[free] = np.eye(len(free), dtype=np.int64)
        for i in reversed(range(len(pivots))):
            column = pivots[i]
            basis[column] = (
                -multiply(echelon[i:i+1, column+1:], basis[column+1:])[0]
            ) % prime
        assert not np.any(multiply(matrix % prime, basis))
        return basis

    ranks = {}
    for name, matrix, expected in (("A", A, 516), ("K", K, 65), ("P", P, 60), ("N", N, 69)):
        dimension = field_kernel(reduce_matrix(matrix)).shape[1]
        ranks[name] = matrix.shape[1] - dimension
        assert ranks[name] == expected

    nmod = reduce_matrix(N)
    basis = field_kernel(nmod)
    coordinates = [(i, (j,)) for i, j in C1]
    dimensions = [basis.shape[1]]
    slice_order = tuple(j for j in J if j <= 6) + tuple(reversed([j for j in J if j > 6]))

    def prolong(previous, old_coordinates):
        current = np.zeros((0, 0), dtype=np.int64)
        index = {}
        union = []
        for j in slice_order:
            image = [(i, tuple(sorted((*z, j)))) for i, z in old_coordinates]
            assert len(image) == len(set(image))
            common = [k for k, coordinate in enumerate(image) if coordinate in index]
            fresh = [k for k, coordinate in enumerate(image) if coordinate not in index]
            width = current.shape[1]
            old_overlap = current[[index[image[k]] for k in common]]
            new_overlap = previous[common]
            compatibility = np.concatenate((old_overlap, -new_overlap), axis=1) % prime
            parameters = field_kernel(compatibility)
            current = np.concatenate((
                multiply(current, parameters[:width]),
                multiply(previous[fresh], parameters[width:]),
            ), axis=0)
            for k in fresh:
                index[image[k]] = len(union)
                union.append(image[k])
        return current, union

    for expected in ((1140, 163), (6820, 6)):
        basis, coordinates = prolong(basis, coordinates)
        assert basis.shape == expected
        dimensions.append(basis.shape[1])
    lookup = {coordinate: i for i, coordinate in enumerate(coordinates)}
    for pair in combinations_with_replacement(J, 2):
        selection = [
            lookup[(i, tuple(sorted((j, *pair))))] for i, j in C1
        ]
        assert not np.any(multiply(nmod, basis[selection]))

    nrows = N.to_sparse().rep.to_sdm()
    rational_rows = [
        {j: Fraction(str(value)) for j, value in nrows[i].items()}
        for i in range(69)
    ]
    products = [
        ([Fraction(v) for v in column["B"]], [Fraction(v) for v in column["H"]])
        for column in certificate["product_columns"]
    ]
    assert len(products) == 3
    for b, eta in products:
        assert len(b) == 11 and len(eta) == 18 and b[0] == eta[0] == 1
        values = [b[i]*eta[j] for i, j in C1]
        assert all(sum(a*values[j] for j, a in row.items()) == 0 for row in rational_rows)
    sparse = {
        (i, tuple(z)): tuple(Fraction(v) for v in values)
        for i, z, values in certificate["sparse_columns"]
    }
    assert len(sparse) == len(certificate["sparse_columns"])
    assert all(coordinate in lookup and len(values) == 3 for coordinate, values in sparse.items())
    for pair in combinations_with_replacement(J, 2):
        slices = [
            sparse.get((i, tuple(sorted((j, *pair)))), (0, 0, 0))
            for i, j in C1
        ]
        for row in rational_rows:
            assert all(
                sum(value*slices[j][k] for j, value in row.items()) == 0
                for k in range(3)
            )

    def six_values(i, z):
        return [
            b[i]*sp.prod(eta[j] for j in z) for b, eta in products
        ] + list(sparse.get((i, tuple(z)), (0, 0, 0)))

    minor_rows = certificate["minor_rows"]
    assert len(minor_rows) == 6 and all((i, tuple(z)) in lookup for i, z in minor_rows)
    minor = sp.Matrix([six_values(i, z) for i, z in minor_rows])
    determinant = minor.det()
    assert determinant == sp.Rational(certificate["minor_determinant"]) == -sp.Rational(16, 5)
    values = [
        six_values(0, (0, 0, 0)),
        six_values(0, (0, 0, 1)),
        six_values(0, (0, 1, 1)),
    ]
    assert all(32*a-20*b+3*c == 0 for a, b, c in zip(*values))
    return {
        "status": "pass",
        "result_class": "exact_verification_theorem",
        "proof_format": "rational_rank_sandwich",
        "source_shape": list(A.shape),
        "modular_ranks": ranks,
        "modular_kernel_dimensions": dimensions,
        "rational_cubic_basis_dimension": 6,
        "rational_minor": str(determinant),
        "conclusion": "3S^2-20SD+32D^2=0 for u=S/D",
        "geometric_hypotheses": "as stated and justified in report.md",
        "independent_review": "pending",
    }


def verify(certificate):
    A, _, _, M, G, C1, selected = build_constraints()
    assert certificate["source_shape"] == list(A.shape) == [1785, 581]
    assert certificate["selected_coordinates"] == len(C1) == 129
    if certificate["proof_format"] == "rational_rank_sandwich":
        assert certificate["cubic_coordinates"] == 6820
        return verify_rank_certificate(certificate, A, M, G, C1, selected)
    source = A.to_sparse().rep.to_sdm()

    def projection_leaf(operation):
        assert len(operation) == 3 and operation[0] == "A"
        _, index, encoded_scale = operation
        assert type(index) is int and 0 <= index < A.shape[0]
        scale = Fraction(encoded_scale)
        assert scale != 0
        rational = {
            column: Fraction(str(value))*scale
            for column, value in source[index].items()
        }
        assert all(value.denominator == 1 for value in rational.values())
        return {column: value.numerator for column, value in rational.items()}

    projection_roots = certificate["projection_roots"]
    projection = replay(
        certificate["projection_nodes"], projection_leaf, projection_roots
    )
    selected_index = {column: i for i, column in enumerate(selected)}
    assert len(selected_index) == 129
    relations = []
    for root in projection_roots:
        row = projection[root]
        assert row and set(row).issubset(selected_index)
        relations.append({selected_index[j]: value for j, value in row.items()})

    c3 = [
        (i, z) for i in range(len(M))
        for z in combinations_with_replacement(J, 3)
        if M[i][0] or any(sum(a*b for a, b in zip(G[j], WEIGHTS)) == 3 for j in z)
    ]
    assert certificate["cubic_coordinates"] == len(c3) == 6820
    lookup = {coordinate: i for i, coordinate in enumerate(c3)}
    target = {
        lookup[(0, (0, 0, 0))]: 32,
        lookup[(0, (0, 0, 1))]: -20,
        lookup[(0, (0, 1, 1))]: 3,
        len(c3): 1,
    }

    proof_format = certificate["proof_format"]
    if proof_format == "polynomial_module_identity":
        assert certificate["eta_indices"] == list(J)
        accumulated = {}
        multipliers = certificate["module_multipliers"]
        assert multipliers
        for index, powers, encoded_coefficient in multipliers:
            assert type(index) is int and 0 <= index < len(relations)
            assert len(powers) == len(J) and sum(powers) == 2
            assert all(type(power) is int and power >= 0 for power in powers)
            coefficient = Fraction(encoded_coefficient)
            assert coefficient != 0
            pair = tuple(j for j, count in zip(J, powers) for _ in range(count))
            for column, value in relations[index].items():
                i, j = C1[column]
                coordinate = lookup[(i, tuple(sorted((j, *pair))))]
                accumulated[coordinate] = (
                    accumulated.get(coordinate, Fraction(0)) + coefficient*value
                )
        accumulated = {j: value for j, value in accumulated.items() if value}
        assert accumulated == {j: v for j, v in target.items() if j != len(c3)}
        normalization = 1
        cubic_operations = 0
        cofactor_terms = len(multipliers)
    else:
        assert proof_format == "row_operation_trace"

        def cubic_leaf(operation):
            if operation[0] == "target":
                assert operation == ["target"]
                return dict(target)
            assert operation[0] == "L" and len(operation) == 3
            _, index, pair = operation
            assert type(index) is int and 0 <= index < len(relations)
            assert len(pair) == 2 and tuple(pair) == tuple(sorted(pair))
            assert all(j in J for j in pair)
            row = {}
            for column, value in relations[index].items():
                i, j = C1[column]
                coordinate = lookup[(i, tuple(sorted((j, *pair))))]
                assert coordinate not in row
                row[coordinate] = value
            return row

        root = certificate["cubic_root"]
        cubic = replay(certificate["cubic_nodes"], cubic_leaf, [root])
        final = cubic[root]
        assert set(final) == {len(c3)}
        normalization = final[len(c3)]
        assert normalization != 0
        cubic_operations = len(certificate["cubic_nodes"])
        cofactor_terms = 0
    return {
        "status": "pass",
        "result_class": "exact_verification_theorem",
        "source_shape": list(A.shape),
        "lifted_relations": len(relations),
        "projection_operations": len(certificate["projection_nodes"]),
        "proof_format": proof_format,
        "cubic_operations": cubic_operations,
        "cofactor_terms": cofactor_terms,
        "normalization": normalization,
        "conclusion": "32-20u+3u^2=0, hence 3S^2-20SD+32D^2=0 for u=S/D",
        "arithmetic": "exact rational identities; no modular rank inference",
        "geometric_hypotheses": "as stated and justified in report.md",
        "independent_review": "pending",
    }


def main():
    if not __debug__:
        raise SystemExit("Assertions must be enabled; remove -O and PYTHONOPTIMIZE.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--certificate", type=Path, default=ROOT / "exact_certificate.json"
    )
    arguments = parser.parse_args()
    certificate = json.loads(arguments.certificate.read_text(encoding="ascii"))
    print(json.dumps(verify(certificate), sort_keys=True))


if __name__ == "__main__":
    main()
