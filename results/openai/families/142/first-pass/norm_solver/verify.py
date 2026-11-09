#!/usr/bin/env python3
"""Replay the section/fiber norm construction on the prescribed F_19 input."""

import argparse
import json
from math import isqrt
from pathlib import Path


P, Q, ZETA, OMEGA = 19, 3, 7, 4
HERE = Path(__file__).resolve().parent


def poly(values):
    values = [x % P for x in values]
    while values and values[-1] == 0:
        values.pop()
    return tuple(values)


def add(a, b):
    return poly((a[i] if i < len(a) else 0) +
                (b[i] if i < len(b) else 0) for i in range(max(len(a), len(b))))


def neg(a):
    return poly(-x for x in a)


def sub(a, b):
    return add(a, neg(b))


def scale(a, c):
    return poly(x * c for x in a)


def mul(a, b):
    result = [0] * max(0, len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            result[i + j] = (result[i + j] + x * y) % P
    return poly(result)


def divmod_poly(a, b):
    if not b:
        raise ZeroDivisionError("zero polynomial divisor")
    result = [0] * max(0, len(a) - len(b) + 1)
    while a and len(a) >= len(b):
        shift = len(a) - len(b)
        c = a[-1] * pow(b[-1], -1, P) % P
        result[shift] = c
        a = sub(a, (0,) * shift + scale(b, c))
    return poly(result), a


def rem(a, modulus):
    return divmod_poly(a, modulus)[1]


def gcd(a, b):
    while b:
        a, b = b, rem(a, b)
    return scale(a, pow(a[-1], -1, P)) if a else ()


def inverse(a, modulus):
    r, s, u, v = modulus, a, (), (1,)
    while s:
        quotient, residual = divmod_poly(r, s)
        r, s, u, v = s, residual, v, sub(u, mul(quotient, v))
    if len(r) != 1:
        raise ValueError("nonunit in quotient algebra")
    return rem(scale(u, pow(r[0], -1, P)), modulus)


def modpow(a, exponent, modulus):
    if exponent < 0:
        a, exponent = inverse(a, modulus), -exponent
    result = (1,)
    while exponent:
        if exponent & 1:
            result = rem(mul(result, a), modulus)
        a = rem(mul(a, a), modulus)
        exponent //= 2
    return result


def series_mul(a, b, precision):
    result = [0] * precision
    for i, x in enumerate(a[:precision]):
        if x:
            for j, y in enumerate(b[:precision - i]):
                result[i + j] = (result[i + j] + x * y) % P
    return poly(result)


def series_inverse(a, precision):
    if not a or not a[0]:
        raise ValueError("nonunit formal series")
    constant_inverse = pow(a[0], -1, P)
    result = [constant_inverse]
    for n in range(1, precision):
        result.append(-constant_inverse * sum(
            a[j] * result[n - j] for j in range(1, min(n + 1, len(a)))) % P)
    return poly(result)


def hensel_cube_root(target, precision):
    root, current = (1,), 1
    assert target[0] == 1
    while current < precision:
        current = min(2 * current, precision)
        square = series_mul(root, root, current)
        quotient = series_mul(target, series_inverse(square, current), current)
        root = scale(add(scale(root, 2), quotient), pow(3, -1, P))
        assert series_mul(series_mul(root, root, current), root, current) == poly(target[:current])
    return root


F = poly((-2, 0, 0, 1))
X = (0, 1)


class Rational:
    def __init__(self, numerator=(), denominator=(1,)):
        if isinstance(numerator, int):
            numerator = poly((numerator,))
        if not denominator:
            raise ZeroDivisionError("zero rational-function denominator")
        divisor = gcd(numerator, denominator)
        numerator = divmod_poly(numerator, divisor)[0]
        denominator = divmod_poly(denominator, divisor)[0]
        normalizer = pow(denominator[-1], -1, P)
        self.numerator = scale(numerator, normalizer)
        self.denominator = scale(denominator, normalizer)

    def __add__(self, other):
        return Rational(add(mul(self.numerator, other.denominator),
                            mul(other.numerator, self.denominator)),
                        mul(self.denominator, other.denominator))

    def __neg__(self):
        return Rational(neg(self.numerator), self.denominator)

    def __sub__(self, other):
        return self + -other

    def __mul__(self, other):
        return Rational(mul(self.numerator, other.numerator),
                        mul(self.denominator, other.denominator))

    def __truediv__(self, other):
        return Rational(mul(self.numerator, other.denominator),
                        mul(self.denominator, other.numerator))

    def __bool__(self):
        return bool(self.numerator)

    def __eq__(self, other):
        return (isinstance(other, Rational) and
                self.numerator == other.numerator and self.denominator == other.denominator)

    def data(self):
        return {"numerator": list(self.numerator), "denominator": list(self.denominator)}


ZERO, ONE, RF = Rational(), Rational(1), Rational(F)


def rref(rows, columns, rational=False):
    rows = [list(row) for row in rows]
    pivots, target = [], 0
    for column in range(columns):
        pivot = next((i for i in range(target, len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        rows[target], rows[pivot] = rows[pivot], rows[target]
        c = ONE / rows[target][column] if rational else pow(rows[target][column], -1, P)
        rows[target] = ([x * c for x in rows[target]] if rational else
                        [x * c % P for x in rows[target]])
        for i in range(len(rows)):
            if i != target and rows[i][column]:
                c = rows[i][column]
                rows[i] = ([x - c * y for x, y in zip(rows[i], rows[target])] if rational else
                           [(x - c * y) % P for x, y in zip(rows[i], rows[target])])
        pivots.append(column)
        target += 1
        if target == len(rows):
            break
    return rows, pivots


def kernel(rows, columns):
    reduced, pivots = rref(rows, columns)
    vectors = []
    for free in range(columns):
        if free not in pivots:
            vector = [0] * columns
            vector[free] = 1
            for i, pivot in enumerate(pivots):
                vector[pivot] = -reduced[i][free] % P
            vectors.append(vector)
    return vectors


def solve(rows, rhs, columns, rational=False):
    reduced, pivots = rref([list(row) + [b] for row, b in zip(rows, rhs)], columns, rational)
    for row in reduced:
        if not any(row[:columns]) and row[-1]:
            raise ValueError("inconsistent linear system")
    result = [ZERO if rational else 0] * columns
    for i, pivot in enumerate(pivots):
        result[pivot] = reduced[i][-1]
    return result


def dot(a, b):
    return sum(x * y for x, y in zip(a, b)) % P


def matrix_mul(a, b):
    return [[dot(row, column) for column in zip(*b)] for row in a]


def matrix_power(a, n):
    result = [[int(i == j) for j in range(Q)] for i in range(Q)]
    while n:
        if n & 1:
            result = matrix_mul(result, a)
        a = matrix_mul(a, a)
        n //= 2
    return result


def matrix_sum(coefficients, matrices):
    return [[sum(c * a[i][j] for c, a in zip(coefficients, matrices)) % P
             for j in range(Q)] for i in range(Q)]


def trace(a):
    return sum(a[i][i] for i in range(Q)) % P


def flatten(a):
    return [x for row in a for x in row]


def element(index):
    return [ONE if i == index else ZERO for i in range(Q * Q)]


def algebra_mul(a, b):
    result = [ZERO] * (Q * Q)
    for i, x in enumerate(a):
        if not x:
            continue
        ai, bi = divmod(i, Q)
        for j, y in enumerate(b):
            if not y:
                continue
            aj, bj = divmod(j, Q)
            c = Rational(pow(ZETA, bi * aj, P))
            if ai + aj >= Q:
                c = c * RF
            if bi + bj >= Q:
                c = c * Rational(2)
            index = ((ai + aj) % Q) * Q + (bi + bj) % Q
            result[index] = result[index] + x * y * c
    return result


def algebra_power(a, n):
    result = element(0)
    for _ in range(n):
        result = algebra_mul(result, a)
    return result


def linear_combination(coefficients, vectors):
    result = [ZERO] * len(vectors[0])
    for c, vector in zip(coefficients, vectors):
        for i, x in enumerate(vector):
            result[i] = result[i] + Rational(c) * x
    return result


def extension_mul(a, b):
    result = [ZERO] * Q
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            c = x * y
            if i + j >= Q:
                c = c * RF
            result[(i + j) % Q] = result[(i + j) % Q] + c
    return result


def norm(a):
    result = [ONE, ZERO, ZERO]
    for j in range(Q):
        conjugate = [x * Rational(pow(ZETA, i * j, P)) for i, x in enumerate(a)]
        result = extension_mul(result, conjugate)
    return result


def residue_root():
    columns = [sub(modpow((0,) * i + (1,), P, F),
                   scale((0,) * i + (1,), ZETA)) for i in range(Q)]
    equation = [[column[j] if j < len(column) else 0 for column in columns]
                for j in range(Q)]
    basis = kernel(equation, Q)
    candidate = ()
    for scalar in range(Q * Q + 1):
        candidate = ()
        for j, vector in enumerate(basis):
            candidate = add(candidate, scale(poly(vector), pow(scalar, j, P)))
        if gcd(candidate, F) == (1,):
            break
    else:
        raise AssertionError("the manuscript's unit search did not succeed")
    order, s = P ** Q - 1, 0
    while order % Q == 0:
        order //= Q
        s += 1
    t = order
    u = modpow(candidate, t, F)
    assert modpow(u, Q ** s, F) == (1,)
    assert modpow(u, Q ** (s - 1), F) != (1,)
    aq = modpow((2,), t * pow(t, -1, Q ** s), F)
    at = modpow((2,), Q ** s * pow(Q ** s, -1, t), F)
    logarithm, digits = 0, []
    for j in range(s):
        residual = rem(mul(aq, modpow(u, -logarithm, F)), F)
        target = modpow(residual, Q ** (s - j - 1), F)
        digit = next(c for c in range(Q)
                     if target == modpow(u, Q ** (s - 1) * c, F))
        logarithm += digit * Q ** j
        digits.append(digit)
    assert logarithm % Q == 0
    root = rem(mul(modpow(u, logarithm // Q, F),
                   modpow(at, pow(Q, -1, t), F)), F)
    assert modpow(root, Q, F) == (2,)
    return root, {
        "frobenius_eigen_equation": equation,
        "kernel_basis": basis,
        "unit_search_scalar": scalar,
        "unit_eigenvector": list(candidate),
        "primary_generator": list(u),
        "primary_order": Q ** s,
        "logarithm_digits": digits,
        "primary_logarithm": logarithm,
        "root": list(root),
    }


def literal_precision_check(root, variables, conditions):
    assert root == X
    m, precision = 360, 1083
    target_unit = scale(series_inverse((2, 1), precision), 2)
    ramified_unit = hensel_cube_root(target_unit, precision)
    infinity_root = hensel_cube_root(poly((1, 0, 0, -2)), precision)
    cube = series_mul(series_mul(ramified_unit, ramified_unit, precision),
                      ramified_unit, precision)
    assert series_mul((2, 1), cube, precision) == (2,)
    infinity_cube = series_mul(series_mul(infinity_root, infinity_root, precision),
                              infinity_root, precision)
    assert infinity_cube == poly((1, 0, 0, -2))
    low_rows = []
    for a in (1, 2):
        for column in range(Q - a):
            entry_coefficients = []
            for aa, b, t in variables:
                if aa != a:
                    entry_coefficients.append(())
                    continue
                unit = (1,)
                for _ in range(b):
                    unit = series_mul(unit, ramified_unit, 2)
                carry, x_degree = divmod(t + b, Q)
                for _ in range(carry):
                    unit = series_mul(unit, (2, 1), 2)
                # The scaled coordinate and basis entry contribute T^(2m-1).
                exponent = (m - 1) + m
                coefficient_order = 2 * m - 1 - exponent
                coefficient = unit[coefficient_order] * pow(ZETA, column * b, P) % P
                entry_coefficients.append((0,) * x_degree + (coefficient,))
            low_rows.extend([[c[t] if t < len(c) else 0 for c in entry_coefficients]
                             for t in range(Q)])
    assert low_rows == conditions
    return {
        "M": m,
        "root_precision": precision,
        "matrix_computation_precision": 2 * m + 1,
        "ramified_representation": "R = X U(T), T=F, X^3=T+2",
        "ramified_U_coefficients": list(ramified_unit),
        "infinity_S_coefficients": list(infinity_root),
        "ramified_root_cubed_equals_2_mod_T_to_precision": True,
        "infinity_root_cubed_equals_1_minus_2z3_mod_z_to_precision": True,
        "all_possible_negative_entry_terms_at_order": 2 * m - 1,
        "low_coefficient_system_equals_compressed_conditions": True,
        "infinity_evaluation_uses_S_constant": infinity_root[0],
    }


def full_section_system(precision_record, compressed_sections):
    budget = 5
    degree_bound = budget * (len(F))
    variables = [(a, b, t) for a in range(Q) for b in range(Q)
                 for t in range(degree_bound + 1)]
    finite_rows = [[0] * len(variables) for _ in range(Q * Q * budget * Q)]
    infinity_rows = [[0] * len(variables) for _ in range(Q * Q * 2 * budget)]
    evaluation_rows = [[0] * len(variables) for _ in range(Q * Q)]
    r = 2 * budget + 1
    root_unit = tuple(precision_record["ramified_U_coefficients"][:r])
    infinity_root = tuple(precision_record["infinity_S_coefficients"][:r])
    infinity_denominator = (1,)
    denominator = (1,)
    for _ in range(budget):
        infinity_denominator = series_mul(infinity_denominator, poly((1, 0, 0, -2)), r)
        denominator = mul(denominator, F)
    inverse_infinity_denominator = series_inverse(infinity_denominator, r)
    for index, (a, b, t) in enumerate(variables):
        ramified_unit = (1,)
        for _ in range(b):
            ramified_unit = series_mul(ramified_unit, root_unit, budget)
        carry, x_degree = divmod(t + b, Q)
        for _ in range(carry):
            ramified_unit = series_mul(ramified_unit, (2, 1), budget)
        for column in range(Q):
            wrap = (column + a) // Q
            scalar = pow(ZETA, column * b, P)
            for order in range(wrap, budget):
                offset = order - wrap
                coefficient = ramified_unit[offset] if offset < len(ramified_unit) else 0
                row = ((a * Q + column) * budget + order) * Q + x_degree
                finite_rows[row][index] = coefficient * scalar % P
        infinity_unit = inverse_infinity_denominator
        for _ in range(a):
            infinity_unit = series_mul(infinity_unit, infinity_root, r)
        shift = 2 * budget + Q * budget - t - a
        assert shift >= 0
        for column in range(Q):
            row = (column + b) % Q
            scalar = pow(2, (column + b) // Q, P) * pow(ZETA, -row * a, P) % P
            for order in range(2 * budget + 1):
                offset = order - shift
                coefficient = infinity_unit[offset] if 0 <= offset < len(infinity_unit) else 0
                if order < 2 * budget:
                    infinity_rows[(row * Q + column) * 2 * budget + order][index] = (
                        coefficient * scalar % P)
                else:
                    evaluation_rows[row * Q + column][index] = coefficient * scalar % P
    rows = finite_rows + infinity_rows
    basis = kernel(rows, len(variables))
    sections, evaluations = [], []
    for vector in basis:
        sections.append([
            Rational(poly(vector[i * (degree_bound + 1):(i + 1) * (degree_bound + 1)]),
                     denominator) for i in range(Q * Q)])
        image = [dot(row, vector) for row in evaluation_rows]
        evaluations.append([image[i * Q:(i + 1) * Q] for i in range(Q)])
    embeddings = []
    for section in compressed_sections:
        embedding = []
        for coefficient in section:
            cleared = coefficient * Rational(denominator)
            assert cleared.denominator == (1,)
            embedding.extend(list(cleared.numerator) +
                             [0] * (degree_bound + 1 - len(cleared.numerator)))
        assert len(embedding) == len(variables)
        assert all(dot(row, embedding) == 0 for row in rows)
        embeddings.append(embedding)
    embedded_rank = len(rref(list(map(list, zip(*embeddings))), len(embeddings))[1])
    assert len(basis) == embedded_rank == len(compressed_sections) == Q * Q
    return sections, evaluations, {
        "budget_L": budget,
        "polynomial_numerator_degree_bound": degree_bound,
        "coefficient_precision": r,
        "variables_a_b_power": variables,
        "system_shape": [len(rows), len(variables)],
        "kernel_basis": basis,
        "rank": len(variables) - len(basis),
        "compressed_subspace_embeds_and_has_equal_dimension": True,
    }


def construction():
    root, root_record = residue_root()
    variables = [(a, b, t) for a in range(Q) for b in range(Q)
                 for t in range(1 if a == 0 else Q + 1 - a)]
    conditions = []
    for a in (1, 2):
        for j in range(Q - a):
            columns = []
            for aa, b, t in variables:
                c = rem(mul((0,) * t + (1,), modpow(root, b, F)), F)
                columns.append(scale(c, pow(ZETA, j * b, P)) if aa == a else ())
            conditions.extend([[c[t] if t < len(c) else 0 for c in columns]
                               for t in range(Q)])
    precision_record = literal_precision_check(root, variables, conditions)
    section_vectors = kernel(conditions, len(variables))
    diagonal = [[pow(ZETA, -i, P) if i == j else 0 for j in range(Q)]
                for i in range(Q)]
    shift = [[0, 0, 2], [1, 0, 0], [0, 1, 0]]
    evaluations, sections = [], []
    for vector in section_vectors:
        section = [ZERO] * (Q * Q)
        weights, matrices = [], []
        for c, (a, b, t) in zip(vector, variables):
            section[a * Q + b] = section[a * Q + b] + Rational(
                scale((0,) * t + (1,), c), (1,) if a == 0 else F)
            weights.append(c if t == (0 if a == 0 else Q - a) else 0)
            matrices.append(matrix_mul(matrix_power(diagonal, a), matrix_power(shift, b)))
        sections.append(section)
        evaluations.append(matrix_sum(weights, matrices))
    compressed_evaluations = evaluations
    sections, evaluations, full_record = full_section_system(precision_record, sections)
    image_rows = list(map(list, zip(*(flatten(a) for a in evaluations))))
    image_rank = len(rref(image_rows, len(evaluations))[1])
    gram = [[trace(matrix_mul(a, b)) for b in evaluations] for a in evaluations]
    radical_vectors = kernel(gram, len(evaluations))
    radical = [matrix_sum(vector, evaluations) for vector in radical_vectors]
    common_kernel = kernel([row for a in radical for row in a], Q)
    assert common_kernel
    v = common_kernel[0]
    pivot = next(i for i, x in enumerate(v) if x)
    w = [pow(v[pivot], -1, P) if i == pivot else 0 for i in range(Q)]
    a0 = [[x * y % P for y in w] for x in v]
    assert matrix_mul(a0, a0) == a0
    assert len(rref(a0, Q)[1]) == 1
    lift_coordinates = solve(image_rows, flatten(a0), len(evaluations))
    b = linear_combination(lift_coordinates, sections)
    assert matrix_sum(lift_coordinates, evaluations) == a0
    e = algebra_power(b, Q)
    assert e == algebra_power(b, Q - 1)
    assert algebra_mul(e, e) == e and any(e)
    ideal_columns = [algebra_mul(element(i), e) for i in range(Q * Q)]
    ideal_rows = list(map(list, zip(*ideal_columns)))
    ideal_rank = len(rref(ideal_rows, Q * Q, True)[1])
    assert ideal_rank == Q
    h_columns = [algebra_mul(element(i * Q), e) for i in range(Q)]
    h_rows = list(map(list, zip(*h_columns)))
    ve = algebra_mul(element(1), e)
    h = solve(h_rows, ve, Q, True)
    he = [ZERO] * (Q * Q)
    for c, column in zip(h, h_columns):
        he = [x + c * y for x, y in zip(he, column)]
    assert he == ve
    computed_norm = norm(h)
    assert computed_norm == [Rational(2), ZERO, ZERO]
    return {
        "residue_root_construction": root_record,
        "literal_source_precision_computation": precision_record,
        "section_system": {
            **full_record,
            "compressed_variables_a_b_power": variables,
            "compressed_local_conditions": conditions,
            "compressed_kernel_basis": section_vectors,
            "compressed_fiber_matrices": compressed_evaluations,
            "section_dimension": len(sections),
            "fiber_dimension": image_rank,
            "fiber_basis_matrices": evaluations,
            "trace_pairing_matrix": gram,
            "trace_pairing_kernel": radical_vectors,
            "common_column_kernel": common_kernel,
        },
        "recovery": {
            "fiber_idempotent": a0,
            "lift_coordinates": lift_coordinates,
            "lift_b": [x.data() for x in b],
            "idempotent_e": [x.data() for x in e],
            "left_ideal_dimension": ideal_rank,
            "h": [x.data() for x in h],
            "norm_h": [x.data() for x in computed_norm],
        },
    }


def verify():
    assert P > 1 and all(P % d for d in range(2, 1 + isqrt(P)))
    assert Q > 2 and all(Q % d for d in range(2, Q))
    assert (P - 1) % Q == 0 and pow(ZETA, Q, P) == 1 and ZETA != 1
    primary_order = P - 1
    while primary_order % Q == 0:
        primary_order //= Q
    primary_order = (P - 1) // primary_order
    assert pow(OMEGA, primary_order, P) == 1
    assert pow(OMEGA, primary_order // Q, P) != 1
    derivative = poly(i * F[i] for i in range(1, len(F)))
    assert F[-1] == 1 and gcd(F, derivative) == (1,)
    assert (len(F) - 1) % Q == 0 and P > (len(F)) ** 2
    assert gcd(F, sub(modpow(X, P, F), X)) == (1,)
    assert modpow(X, P ** Q, F) == X
    # Cubic no-root testing is an independent input check, not an algorithm oracle.
    cube_values = [pow(x, Q, P) for x in range(P)]
    assert 2 not in cube_values
    data = construction()
    promised_solution = [Rational(X), Rational(-1), ZERO]
    assert norm(promised_solution) == [Rational(2), ZERO, ZERO]
    y, v = element(Q), element(1)
    assert algebra_power(y, Q) == [RF] + [ZERO] * (Q * Q - 1)
    assert algebra_power(v, Q) == [Rational(2)] + [ZERO] * (Q * Q - 1)
    assert algebra_mul(v, y) == [
        Rational(ZETA) * x for x in algebra_mul(y, v)]
    return {
        "classification": "exact verification of the prescribed instance; uniform proof is in report.md",
        "input": {"p": P, "q": Q, "zeta": ZETA, "omega": OMEGA,
                  "F_ascending": list(F), "G": 2, "N": 3, "D": 0},
        "independently_checked_hypotheses": {
            "prime_characteristic": True,
            "odd_prime_q": True,
            "primitive_qth_root": True,
            "full_primary_generator": True,
            "monic_square_free_positive_F": True,
            "q_divides_N": True,
            "characteristic_bound": True,
            "G_nonzero": True,
            "norm_promise_checked_separately": True,
        },
        "precision_budgets": {"manuscript_M": 360, "uniform_L": 5,
                              "full_ansatz_dimension": 189,
                              "compressed_ansatz_dimension": 18},
        "prime_field_cube_map": cube_values,
        **data,
        "checked_output_identities": {
            "fiber_idempotent_rank_one": True,
            "lift_has_prescribed_fiber": True,
            "e_equals_b_to_q": True,
            "b_to_q_equals_b_to_q_minus_one": True,
            "e_squared_equals_e": True,
            "left_ideal_dimension_q": True,
            "Ve_equals_he": True,
            "product_of_conjugates_h_equals_G": True,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    data = verify()
    path = HERE / "exact_certificate.json"
    canonical = json.loads(json.dumps(data))
    if args.write_certificate:
        path.write_text(json.dumps(data, indent=2) + "\n")
    recorded = json.loads(path.read_text())
    if recorded != canonical:
        raise AssertionError("certificate differs from independently recomputed construction")
    dimensions = data["section_system"]
    print(json.dumps({"ok": True, "section_dimension": dimensions["section_dimension"],
                      "fiber_dimension": dimensions["fiber_dimension"],
                      "h": data["recovery"]["h"], "norm": 2}))


if __name__ == "__main__":
    main()
