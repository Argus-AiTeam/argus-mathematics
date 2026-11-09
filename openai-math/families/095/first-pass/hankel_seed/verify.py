#!/usr/bin/env python3
"""Reconstruct the Hankel certificate with exact prime-field/rational arithmetic."""

import argparse
import copy
import json
import sys
from fractions import Fraction
from itertools import combinations_with_replacement
from pathlib import Path


def scalar(value, prime):
    return value % prime if prime else Fraction(value)


def inv(value, prime):
    if not value:
        raise ArithmeticError("singular pivot")
    return pow(value, -1, prime) if prime else 1 / Fraction(value)


def transpose(matrix):
    return [list(row) for row in zip(*matrix)]


def multiply(left, right, prime):
    return [
        [scalar(sum(x * y for x, y in zip(row, col)), prime)
         for col in zip(*right)]
        for row in left
    ]


def add(left, right, prime, sign=1):
    return [[scalar(x + sign * y, prime) for x, y in zip(a, b)]
            for a, b in zip(left, right)]


def submatrix(matrix, rows, columns):
    return [[matrix[r][c] for c in columns] for r in rows]


def identity(size):
    return [[int(i == j) for j in range(size)] for i in range(size)]


def eliminate(matrix, prime):
    work = [[scalar(x, prime) for x in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot_row = next((r for r in range(row, len(work))
                          if work[r][column]), None)
        if pivot_row is None:
            continue
        pivot = work[pivot_row][column]
        pivots.append(scalar(pivot if pivot_row == row else -pivot, prime))
        work[row], work[pivot_row] = work[pivot_row], work[row]
        inverse = inv(pivot, prime)
        work[row] = [scalar(x * inverse, prime) for x in work[row]]
        for r in range(len(work)):
            if r != row and work[r][column]:
                factor = work[r][column]
                work[r] = [scalar(x - factor * y, prime)
                           for x, y in zip(work[r], work[row])]
        row += 1
        if row == len(work):
            break
    return work, pivots


def rank(matrix, prime):
    return len(eliminate(matrix, prime)[1])


def determinant(matrix, prime):
    size = len(matrix)
    if any(len(row) != size for row in matrix):
        raise ValueError("determinant requires a square matrix")
    _, pivots = eliminate(matrix, prime)
    result = scalar(1, prime)
    for pivot in pivots:
        result = scalar(result * pivot, prime)
    return result if len(pivots) == size else scalar(0, prime)


def inverse(matrix, prime):
    size = len(matrix)
    if not determinant(matrix, prime):
        raise ArithmeticError("singular matrix")
    augmented = [a + b for a, b in zip(matrix, identity(size))]
    reduced, _ = eliminate(augmented, prime)
    return [row[size:] for row in reduced]


def nullspace(matrix, pivots, prime):
    columns = len(matrix[0])
    free = [j for j in range(columns) if j not in pivots]
    pivot_matrix = submatrix(matrix, range(len(matrix)), pivots)
    solved = multiply(inverse(pivot_matrix, prime),
                      submatrix(matrix, range(len(matrix)), free), prime)
    result = [[scalar(0, prime) for _ in free] for _ in range(columns)]
    for r, index in enumerate(pivots):
        result[index] = [scalar(-x, prime) for x in solved[r]]
    for j, index in enumerate(free):
        result[index][j] = scalar(1, prime)
    return result


def retain(size, omissions):
    if len(set(omissions)) != len(omissions):
        raise ValueError("duplicate omitted index")
    if any(i < 1 or i > size for i in omissions):
        raise ValueError("out-of-range omitted index")
    return [i for i in range(size) if i + 1 not in omissions]


def indices(one_based):
    return [i - 1 for i in one_based]


def polynomial_columns(monomials, matrix):
    return [{m: row[j] for m, row in zip(monomials, matrix) if row[j]}
            for j in range(len(matrix[0]))]


def polynomial_product(left, right, prime):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            monomial = tuple(sorted(a + b))
            result[monomial] = scalar(result.get(monomial, 0) + x * y, prime)
    return result


def product_matrix(left, right, rows, weight, prime, symmetric=False,
                   left_derivative=None, right_derivative=None):
    columns = []
    for i in range(10):
        j = (weight - i) % 10
        for u, first in enumerate(left[i]):
            for v, second in enumerate(right[j]):
                if symmetric and (i, u) > (j, v):
                    continue
                if left_derivative is None:
                    product = polynomial_product(first, second, prime)
                else:
                    product = polynomial_product(left_derivative[i][u],
                                                 second, prime)
                    other = polynomial_product(first, right_derivative[j][v],
                                               prime)
                    for m, value in other.items():
                        product[m] = scalar(product.get(m, 0) + value, prime)
                columns.append([product.get(m, scalar(0, prime)) for m in rows])
    return transpose(columns)


def monomial_value(monomial, a):
    value = 1
    for i in monomial:
        value *= a[i]
    return value


def data(certificate, prime, tangent=None):
    weights = certificate["weights"]
    a = certificate["a"]
    quadratics = list(combinations_with_replacement(range(8), 2))
    quartics = list(combinations_with_replacement(range(8), 4))

    def weight(m):
        return sum(weights[j] for j in m) % 10

    blocks = [[m for m in quadratics if weight(m) == i] for i in range(10)]
    rows = [[m for m in quartics if weight(m) == i] for i in range(10)]
    tangent = certificate["tangent_zero_weight"] if tangent is None else tangent
    if len(tangent) != len(rows[0]):
        raise ValueError("wrong number of weight-zero tangent moments")
    t1 = dict(zip(rows[0], tangent))

    def moment(m):
        return scalar(1 + monomial_value(m, a) if weight(m) == 0 else 0, prime)

    def variation(m):
        return scalar(t1.get(m, 0), prime)

    def form(first, second, functional=moment):
        return [[functional(tuple(sorted(u + v))) for v in second]
                for u in first]

    pivot_indices = [[0, 2] if i in (0, 8) else [0, 1] for i in range(10)]
    pivot_monomials = [[blocks[i][j] for j in pivot_indices[i]]
                       for i in range(10)]
    l_indices = [next((j for j, m in enumerate(block) if m[0] == 0), None)
                 for block in blocks]
    j_bases, n_bases, j_derivatives, n_derivatives = [], [], [], []
    for i in range(10):
        block = blocks[i]
        opposite = (-i) % 10
        c = [[scalar(1, prime)] * len(block),
             [scalar(monomial_value(m, a), prime) for m in block]]
        j_basis = nullspace(c, pivot_indices[i], prime)
        pivot_form = form(pivot_monomials[opposite], pivot_monomials[i])
        rhs = multiply(form(pivot_monomials[opposite], block, variation),
                       j_basis, prime)
        derivative_pivots = multiply(inverse(pivot_form, prime), rhs, prime)
        j_derivative = [[scalar(0, prime)] * len(j_basis[0]) for _ in block]
        for r, index in enumerate(pivot_indices[i]):
            j_derivative[index] = [scalar(-x, prime)
                                   for x in derivative_pivots[r]]
        if l_indices[opposite] is None:
            n_basis = identity(len(block))
            n_derivative = [[scalar(0, prime)] * len(block) for _ in block]
        else:
            l_monomial = [blocks[opposite][l_indices[opposite]]]
            constraint = form(l_monomial, block)
            n_basis = nullspace(constraint, [l_indices[i]], prime)
            n_derivative = [[scalar(0, prime)] * len(n_basis[0]) for _ in block]
            rhs = multiply(form(l_monomial, block, variation), n_basis, prime)[0]
            n_derivative[l_indices[i]] = [
                scalar(-x * inv(constraint[0][l_indices[i]], prime), prime)
                for x in rhs
            ]
        j_bases.append(j_basis)
        n_bases.append(n_basis)
        j_derivatives.append(j_derivative)
        n_derivatives.append(n_derivative)

    j = [polynomial_columns(block, matrix) for block, matrix in zip(blocks, j_bases)]
    n = [polynomial_columns(block, matrix) for block, matrix in zip(blocks, n_bases)]
    jp = [polynomial_columns(block, matrix)
          for block, matrix in zip(blocks, j_derivatives)]
    np = [polynomial_columns(block, matrix)
          for block, matrix in zip(blocks, n_derivatives)]
    linear = [[{(0, v): scalar(1, prime)} for v in range(1, 8)
               if weights[v] == i] for i in range(10)]
    matrices = {}
    for w in range(10):
        matrices[w] = {
            "JJ": product_matrix(j, j, rows[w], w, prime, symmetric=True),
            "G1": product_matrix(j, j, [m for m in rows[w] if 0 not in m],
                                 w, prime, symmetric=True),
            "G2": product_matrix(j, linear, [m for m in rows[w] if m.count(0) == 1],
                                 w, prime),
            "D": product_matrix(j, n, rows[w], w, prime),
            "D1": product_matrix(j, n, rows[w], w, prime,
                                 left_derivative=jp, right_derivative=np)
        }
    equations = []
    for i in range(10):
        equations += [x for row in multiply(form(quadratics, blocks[i]),
                                            j_bases[i], prime) for x in row]
        derivative = add(
            multiply(form(quadratics, blocks[i]), j_derivatives[i], prime),
            multiply(form(quadratics, blocks[i], variation), j_bases[i], prime),
            prime)
        equations += [x for row in derivative for x in row]
        l = [(0, v) for v in range(8)]
        equations += [x for row in multiply(form(l, blocks[i]), n_bases[i], prime)
                      for x in row]
        derivative = add(
            multiply(form(l, blocks[i]), n_derivatives[i], prime),
            multiply(form(l, blocks[i], variation), n_bases[i], prime), prime)
        equations += [x for row in derivative for x in row]
    return {
        "blocks": blocks, "rows": rows, "J": j_bases, "N": n_bases,
        "Jp": j_derivatives, "Np": n_derivatives, "matrices": matrices,
        "T": form(quadratics, quadratics), "L": form([(0, v) for v in range(8)],
                                                   [(0, v) for v in range(8)]),
        "equations": equations
    }


def bordered(d, d1):
    columns = len(d[0])
    return [row + [0] * columns for row in d] + [a + b for a, b in zip(d1, d)]


def corner(d, d1, table, prime):
    r = retain(len(d), table["D_omit_rows"])
    s = retain(len(d[0]), table["D_omit_columns"])
    rp, sp = indices(table["R_prime"]), indices(table["S_prime"])
    e = submatrix(d, r, s)
    ia = multiply(inverse(e, prime), submatrix(d, r, sp), prime)
    bi = multiply(submatrix(d, rp, s), inverse(e, prime), prime)
    z = submatrix(d1, rp, sp)
    z = add(z, multiply(submatrix(d1, rp, s), ia, prime), prime, -1)
    z = add(z, multiply(bi, submatrix(d1, r, sp), prime), prime, -1)
    z = add(z, multiply(multiply(bi, submatrix(d1, r, s), prime), ia, prime), prime)
    return e, z


def reduction(value, prime=7):
    value = Fraction(value)
    return value.numerator % prime * pow(value.denominator, -1, prime) % prime


def lifted_tangent(certificate, modular):
    rational = data(certificate, None)
    pure_rows = [i for i, m in enumerate(rational["rows"][0]) if 0 not in m]
    selected = retain(len(pure_rows), certificate["minors"][0]["G1_omit_rows"])
    pivots = [pure_rows[i] for i in selected]
    free = [i for i in range(35) if i not in pivots]
    equations = transpose(rational["matrices"][0]["JJ"])
    a = submatrix(equations, range(17), pivots)
    tangent = [Fraction(x) for x in certificate["tangent_zero_weight"]]
    b = [[-sum(equations[j][i] * tangent[i] for i in free)] for j in range(17)]
    solved = multiply(inverse(a, None), b, None)
    for i, value in zip(pivots, solved):
        tangent[i] = value[0]
    if any(sum(row[i] * tangent[i] for i in range(35)) for row in equations):
        raise AssertionError("characteristic-zero tangent equations failed")
    if [reduction(x) for x in tangent] != certificate["tangent_zero_weight"]:
        raise AssertionError("tangent lift has wrong reduction")
    rational = data(certificate, None, tangent)
    if any(rational["equations"]):
        raise AssertionError("characteristic-zero differentiated equations failed")
    for key in ("J", "N", "Jp", "Np", "T", "L"):
        rational_matrices = rational[key] if key in ("J", "N", "Jp", "Np") else [rational[key]]
        modular_matrices = modular[key] if key in ("J", "N", "Jp", "Np") else [modular[key]]
        for actual, expected in zip(rational_matrices, modular_matrices):
            if [[reduction(x) for x in row] for row in actual] != expected:
                raise AssertionError(f"wrong characteristic-zero reduction: {key}")
    for w in range(10):
        for key in ("JJ", "G1", "G2", "D", "D1"):
            actual = rational["matrices"][w][key]
            expected = modular["matrices"][w][key]
            if [[reduction(x) for x in row] for row in actual] != expected:
                raise AssertionError(f"wrong characteristic-zero reduction: weight {w} {key}")
    return {
        "pivot_rows_one_based_in_weight_zero_quartics": [i + 1 for i in pivots],
        "pivot_determinant": str(determinant(a, None)),
        "tangent": [str(x) for x in tangent],
        "exact_tangency": True,
        "all_denominators_prime_to_seven": True,
        "all_bases_products_and_derivatives_reduce_correctly": True
    }


def compute(certificate):
    prime = certificate["prime"]
    if prime != 7:
        raise ValueError("this manuscript certificate is over F_7")
    if [table["weight"] for table in certificate["minors"]] != list(range(6)):
        raise ValueError("exactly the six displayed minor tables are required")
    if set(certificate["rank_lower_bounds"]) != {"G1", "G2", "D", "bordered"}:
        raise ValueError("all four rank conditions are required")
    if any(len(bounds) != 10 for bounds in certificate["rank_lower_bounds"].values()):
        raise ValueError("rank bounds must include all ten weights")
    result = data(certificate, prime)
    if any(result["equations"]):
        raise AssertionError("kernel, H0, or differentiated equations failed")
    tangent = certificate["tangent_zero_weight"]
    if any(sum(row[i] * tangent[i] for i in range(35)) % prime
           for row in transpose(result["matrices"][0]["JJ"])):
        raise AssertionError("modular tangency failed")
    measured = {
        "quadratic_blocks": [["".join(map(str, m)) for m in block] for block in result["blocks"]],
        "kernel_columns": [["".join(map(str, column)) for column in zip(*matrix)]
                           for matrix in result["J"]],
        "zero_quartics": ["".join(map(str, m)) for m in result["rows"][0]],
        "T_rank": rank(result["T"], prime),
        "L_determinant": determinant(result["L"], prime),
        "rank_by_weight": {key: [] for key in ("G1", "G2", "D", "bordered")},
        "minors": []
    }
    for w in range(10):
        matrices = result["matrices"][w]
        for key in ("G1", "G2", "D"):
            measured["rank_by_weight"][key].append(rank(matrices[key], prime))
        measured["rank_by_weight"]["bordered"].append(
            rank(bordered(matrices["D"], matrices["D1"]), prime))
    for table in certificate["minors"]:
        w = table["weight"]
        matrices = result["matrices"][w]
        g1 = matrices["G1"]
        g1_minor = submatrix(g1, retain(len(g1), table["G1_omit_rows"]),
                             range(len(g1[0])))
        g2 = matrices["G2"]
        g2_minor = submatrix(g2, range(len(g2)),
                             retain(len(g2[0]), table["G2_omit_columns"]))
        d, d1 = matrices["D"], matrices["D1"]
        e, z = corner(d, d1, table, prime)
        r = retain(len(d), table["D_omit_rows"])
        s = retain(len(d[0]), table["D_omit_columns"])
        block_minor = submatrix(
            bordered(d, d1), r + [len(d) + i for i in r + indices(table["R_prime"])],
            s + indices(table["S_prime"]) + [len(d[0]) + i for i in s])
        block_det = determinant(block_minor, prime)
        if not block_det:
            raise AssertionError(f"singular bordered minor in weight {w}")
        if block_det != scalar((-1) ** (len(e) * len(z))
                               * determinant(e, prime) ** 2 * determinant(z, prime), prime):
            raise AssertionError(f"bordered determinant identity failed in weight {w}")
        measured["minors"].append({
            "weight": w, "G1_size": len(g1_minor), "G1_det": determinant(g1_minor, prime),
            "G2_size": len(g2_minor), "G2_det": determinant(g2_minor, prime),
            "D_shape": [len(d), len(d[0])],
            "E_size": len(e), "E_det": determinant(e, prime),
            "Z": z, "Z_det": determinant(z, prime), "bordered_det": block_det
        })
        if w == 0:
            measured["G2_weight_zero_signed_pivots"] = eliminate(g2_minor, prime)[1]
            measured["E_weight_zero_signed_pivots"] = eliminate(e, prime)[1]
    measured["rank_totals"] = {key: sum(values)
                               for key, values in measured["rank_by_weight"].items()}
    measured["tangent_lift"] = lifted_tangent(certificate, result)
    return measured, result


def compare(certificate, measured):
    failures = []

    def check(label, actual, expected):
        if actual != expected:
            failures.append({"assertion": label, "advertised": expected, "computed": actual})

    for key in ("quadratic_blocks", "kernel_columns", "zero_quartics", "L_determinant"):
        check(key, measured[key], certificate[key])
    check("T_rank", measured["T_rank"], 20)
    for advertised, actual in zip(certificate["minors"], measured["minors"]):
        for key in ("weight", "G1_size", "G1_det", "G2_size", "G2_det",
                    "D_shape", "E_size", "E_det", "Z", "Z_det"):
            check(f"weight {advertised['weight']} {key}", actual[key], advertised[key])
    for key in ("G2_weight_zero_signed_pivots", "E_weight_zero_signed_pivots"):
        check(key, measured[key], [x % 7 for x in certificate[key]])
    for key, bounds in certificate["rank_lower_bounds"].items():
        for w, bound in enumerate(bounds):
            actual = measured["rank_by_weight"][key][w]
            if actual < bound:
                failures.append({"assertion": f"weight {w} {key} rank >= {bound}",
                                 "advertised": bound, "computed": actual})
    for key, total in certificate["rank_totals"].items():
        check(f"{key} total", measured["rank_totals"][key], total)
    check("characteristic-zero lift", measured["tangent_lift"],
          certificate["characteristic_zero_lift"])
    return failures


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path,
                        default=Path(__file__).with_name("exact_certificate.json"))
    parser.add_argument("--details", action="store_true")
    parser.add_argument("--self-test", action="store_true",
                        help="also check that altered decisive values are rejected")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    measured, result = compute(certificate)
    failures = compare(certificate, measured)
    if args.self_test:
        altered = copy.deepcopy(certificate)
        altered["minors"][0]["Z"][0][0] = (altered["minors"][0]["Z"][0][0] + 1) % 7
        if not compare(altered, measured):
            raise AssertionError("altered corner was accepted")
        altered = copy.deepcopy(certificate)
        altered["characteristic_zero_lift"]["tangent"][13] = "0"
        if not compare(altered, measured):
            raise AssertionError("altered rational lift was accepted")
        tangent = certificate["tangent_zero_weight"][:]
        tangent[0] = (tangent[0] + 1) % 7
        jj = result["matrices"][0]["JJ"]
        if not any(sum(row[i] * tangent[i] for i in range(35)) % 7
                   for row in transpose(jj)):
            raise AssertionError("altered tangent was accepted")
    output = {"ok": not failures, "failures": failures,
              "rank_totals": measured["rank_totals"],
              "exact_characteristic_zero_tangent": True,
              "tamper_checks": args.self_test}
    if args.details:
        output["computed"] = measured
    print(json.dumps(output, indent=2))
    return 0 if not failures else 1


if __name__ == "__main__":
    sys.exit(main())
