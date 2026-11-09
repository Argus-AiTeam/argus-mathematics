#!/usr/bin/env python3
"""Exact arithmetic for the corrected BP Bockstein cubic (weights <= 81)."""

import argparse
import json
import math
import time
from functools import cache
from pathlib import Path


WIDTH = 4
BITS = 8
BLOCK = WIDTH * BITS
MASK = (1 << BLOCK) - 1
WEIGHTS = (1, 4, 13, 40)
ZERO = {0: 1}
HERE = Path(__file__).resolve().parent


def variable(i):
    return {1 << (BITS * i): 1}


def add(a, b, modulus, scale=1):
    result = a.copy()
    for monomial, coefficient in b.items():
        value = (result.get(monomial, 0) + scale * coefficient) % modulus
        if value:
            result[monomial] = value
        else:
            result.pop(monomial, None)
    return result


def mul(a, b, modulus):
    result = {}
    for x, c in a.items():
        for y, d in b.items():
            monomial = x + y
            result[monomial] = (result.get(monomial, 0) + c * d) % modulus
    return {m: c for m, c in result.items() if c}


def power(a, n, modulus):
    if modulus == 3 and n >= 3:
        quotient, remainder = divmod(n, 3)
        frobenius = {3 * m: c for m, c in a.items()}
        return mul(power(frobenius, quotient, modulus),
                   power(a, remainder, modulus), modulus)
    result = ZERO
    while n:
        if n & 1:
            result = mul(result, a, modulus)
        n //= 2
        if n:
            a = mul(a, a, modulus)
    return result


def scaled(a, coefficient, modulus):
    return {m: c * coefficient % modulus for m, c in a.items()
            if c * coefficient % modulus}


def accumulate(result, key, coefficient):
    value = (result.get(key, 0) + coefficient) % 3
    if value:
        result[key] = value
    else:
        result.pop(key, None)


def substitute(a, images, modulus):
    powers = {}
    result = {}
    for monomial, coefficient in a.items():
        term = {0: coefficient % modulus}
        index = 0
        while monomial:
            exponent = monomial & 255
            if exponent:
                key = (index, exponent)
                if key not in powers:
                    powers[key] = power(images[index], exponent, modulus)
                term = mul(term, powers[key], modulus)
            monomial >>= BITS
            index += 1
        result = add(result, term, modulus)
    return result


def exponents(monomial, width=WIDTH):
    return tuple((monomial >> (BITS * i)) & 255 for i in range(width))


def pack(values):
    return sum(value << (BITS * i) for i, value in enumerate(values))


@cache
def weight(monomial):
    return sum(a * b for a, b in zip(exponents(monomial), WEIGHTS))


def divides(a, b):
    return all(x <= y for x, y in zip(exponents(a), exponents(b)))


def encode_polynomial(a, width):
    return [[list(exponents(m, width)), c] for m, c in sorted(a.items())]


def structure():
    """Scaled logarithms avoid any division in a finite field."""
    variables = [variable(i) for i in range(3 * WIDTH)]
    v = [ZERO] + variables[:WIDTH]
    t = [ZERO] + variables[WIDTH:2 * WIDTH]
    s = [ZERO] + variables[2 * WIDTH:]
    precision = 12
    modulus = 3 ** precision
    logarithms = [ZERO]
    for n in range(1, WIDTH + 1):
        current = {}
        for j in range(n):
            term = mul(logarithms[j], power(v[n-j], 3**j, modulus), modulus)
            current = add(current, term, modulus, 3 ** (n-j-1))
        logarithms.append(current)
    rho = []
    for n in range(WIDTH + 1):
        current = {}
        for j in range(n + 1):
            term = mul(logarithms[j], power(t[n-j], 3**j, modulus), modulus)
            current = add(current, term, modulus, 3 ** (n-j))
        rho.append(current)
    right = [ZERO]
    right_precision = precision
    coproduct = [ZERO]
    coproduct_precision = precision
    for n in range(1, WIDTH + 1):
        modulus = 3 ** right_precision
        numerator = {m: c % modulus for m, c in rho[n].items() if c % modulus}
        for j in range(1, n):
            term = mul(rho[j], power(right[n-j], 3**j, modulus), modulus)
            numerator = add(numerator, term, modulus, -3 ** (n-j-1))
        denominator = 3 ** (n-1)
        assert all(c % denominator == 0 for c in numerator.values())
        right.append({m: c // denominator for m, c in numerator.items()})
        right_precision -= n-1

        modulus = 3 ** coproduct_precision
        numerator = {}
        for j in range(n + 1):
            for k in range(n-j+1):
                h = n-j-k
                term = mul(logarithms[j], power(t[k], 3**j, modulus), modulus)
                term = mul(term, power(s[h], 3 ** (j+k), modulus), modulus)
                numerator = add(numerator, term, modulus, 3 ** (n-j))
        for j in range(1, n + 1):
            term = mul(logarithms[j], power(coproduct[n-j], 3**j, modulus), modulus)
            numerator = add(numerator, term, modulus, -3 ** (n-j))
        denominator = 3**n
        assert all(c % denominator == 0 for c in numerator.values())
        coproduct.append({m: c // denominator for m, c in numerator.items()})
        coproduct_precision -= n
    assert right_precision >= 2 and coproduct_precision >= 2
    return right, coproduct


def corrected_bockstein(right):
    v, v2 = variable(0), variable(1)
    t, s = variable(WIDTH), variable(2 * WIDTH)
    h = add(power(t, 3, 3), mul(power(v, 2, 3), t, 3), 3, -1)
    shift = add(v2, mul(v, h, 3), 3)
    seventh_difference = add(power(shift, 7, 3), power(v2, 7, 3), 3, -1)
    assert all((m & 255) >= 1 for m in seventh_difference)
    seventh = {m-1: c for m, c in seventh_difference.items()}
    y = add(power(h, 9, 3), seventh, 3, -1)
    q = add(power(v2, 9, 3), mul(power(v, 8, 3), power(v2, 7, 3), 3), 3, -1)
    images = [variable(i) for i in range(3 * WIDTH)]
    images[1] = shift
    difference = add(substitute(q, images, 3), q, 3, -1)
    assert all((m & 255) >= 9 for m in difference)
    assert {m-9: c for m, c in difference.items()} == y
    images = [variable(i) for i in range(3 * WIDTH)]
    images[WIDTH] = add(t, s, 9)
    delta_y = substitute(y, images, 9)
    images = right[1:] + [variable(i+WIDTH) for i in range(2 * WIDTH)]
    for i in range(WIDTH):
        images[WIDTH+i] = variable(2 * WIDTH+i)
    last = substitute(y, images, 9)
    numerator = add(add(delta_y, y, 9, -1), last, 9, -1)
    assert all(c % 3 == 0 for c in numerator.values())
    beta = {m: c // 3 for m, c in numerator.items()}
    assert all((m >> BLOCK) & MASK and m >> (2 * BLOCK) for m in beta)
    return y, beta


def check_low_structure(right, coproduct):
    v, v2 = variable(0), variable(1)
    t, t2 = variable(WIDTH), variable(WIDTH+1)
    s, s2 = variable(2*WIDTH), variable(2*WIDTH+1)
    reduce_nine = lambda a: {m: c % 9 for m, c in a.items() if c % 9}
    expected_right = add(v2, t2, 9, 3)
    expected_right = add(expected_right, mul(power(v, 3, 9), t, 9), 9, 5)
    expected_right = add(expected_right, mul(v, power(t, 3, 9), 9), 9)
    assert reduce_nine(right[1]) == add(v, t, 9, 3)
    assert reduce_nine(right[2]) == expected_right
    expected_delta = add(add(t2, s2, 9), mul(t, power(s, 3, 9), 9), 9)
    expected_delta = add(expected_delta, mul(v, mul(power(t, 2, 9), s, 9), 9), 9, -1)
    expected_delta = add(expected_delta, mul(v, mul(t, power(s, 2, 9), 9), 9), 9, -1)
    assert reduce_nine(coproduct[1]) == add(t, s, 9)
    assert reduce_nine(coproduct[2]) == expected_delta


def check_cobar_cocycle(beta, right, coproduct):
    variables = [variable(i) for i in range(4 * WIDTH)]
    used = {i for m in beta for i, exponent in enumerate(exponents(m, 3*WIDTH))
            if exponent}
    assert used <= {0, 1, WIDTH, WIDTH+1, 2*WIDTH}
    first = variables[:]
    first[:WIDTH] = right[1:]
    first[WIDTH:3*WIDTH] = variables[2*WIDTH:4*WIDTH]
    second = variables[:]
    second[WIDTH:2*WIDTH] = coproduct[1:]
    second[2*WIDTH:3*WIDTH] = variables[3*WIDTH:4*WIDTH]
    third = variables[:]
    third[2*WIDTH] = add(variables[2*WIDTH], variables[3*WIDTH], 3)
    boundary = add(substitute(beta, first, 3), substitute(beta, second, 3), 3, -1)
    boundary = add(boundary, substitute(beta, third, 3), 3)
    boundary = add(boundary, beta, 3, -1)
    assert not boundary, ("ordinary_cobar_cocycle_failure", boundary)


class Resolution:
    def __init__(self, cutoff, right, coproduct):
        self.cutoff = cutoff
        self.right = [{m: c % 3 for m, c in a.items() if c % 3} for a in right]
        self.coproduct = [{m: c % 3 for m, c in a.items() if c % 3}
                          for a in coproduct]
        self.digits = []
        for i in reversed(range(WIDTH)):
            j = 0
            while WEIGHTS[i] * 3**j <= cutoff:
                j += 1
            for j in reversed(range(j)):
                self.digits.append((i, j, 3**j << (BITS*i)))
        self.products = {}
        self.started = time.monotonic()

    def progress(self, action, **values):
        print(json.dumps({"elapsed": round(time.monotonic()-self.started, 3),
                          "action": action, **values}), flush=True)

    @cache
    def coefficient_monomials(self, degree):
        if degree < 0:
            return ()
        result = []

        def visit(i, remaining, monomial):
            if i == 0:
                result.append(monomial + remaining)
                return
            for exponent in range(remaining // WEIGHTS[i] + 1):
                visit(i-1, remaining-exponent*WEIGHTS[i],
                      monomial + (exponent << (BITS*i)))
        visit(WIDTH-1, degree, 0)
        return tuple(result)

    @cache
    def generator_degree(self, g):
        return sum((g >> (4*k)) & 15 for k in range(len(self.digits)))

    @cache
    def generator_content(self, g):
        result = 0
        for k, (_, _, m) in enumerate(self.digits):
            exponent = (g >> (4*k)) & 15
            result += (3*(exponent//2) + exponent % 2)*m
        return result

    def generator_weight(self, g):
        return weight(self.generator_content(g))

    @cache
    def generators(self, degree, cutoff):
        result = []

        def visit(k, remaining_degree, remaining_weight, g):
            if k == len(self.digits):
                if remaining_degree == 0:
                    result.append(g)
                return
            _, _, m = self.digits[k]
            for exponent in range(remaining_degree + 1):
                consumed = (3*(exponent//2) + exponent % 2)*weight(m)
                if consumed <= remaining_weight:
                    visit(k+1, remaining_degree-exponent, remaining_weight-consumed,
                          g + (exponent << (4*k)))
        visit(0, degree, cutoff, 0)
        return tuple(sorted(result, key=lambda g: (self.generator_weight(g),
                                                   self.generator_content(g), g)))

    def delta(self, u):
        result = ZERO
        for i, exponent in enumerate(exponents(u)):
            if exponent:
                result = mul(result, power(self.coproduct[i+1], exponent, 3), 3)
        return result

    def build_products(self):
        count = 0
        for degree in range(1, self.cutoff+1):
            for u in self.coefficient_monomials(degree):
                for monomial, coefficient in self.delta(u).items():
                    left = (monomial >> BLOCK) & MASK
                    right = (monomial >> (2*BLOCK)) & MASK
                    if not left or not right:
                        continue
                    key = left | (right << BLOCK)
                    entry = (monomial & MASK) | (u << BLOCK)
                    self.products.setdefault(key, {})[entry] = coefficient
                    count += 1
            if degree % 9 == 0 or degree == self.cutoff:
                self.progress("operator_products", weight=degree,
                              entries=count, pairs=len(self.products))

    @cache
    def eta(self, q):
        result = ZERO
        for i, exponent in enumerate(exponents(q)):
            if exponent:
                result = mul(result, power(self.right[i+1], exponent, 3), 3)
        return result

    @cache
    def operator_product(self, s, q, t):
        result = {}
        for monomial, coefficient in self.eta(q).items():
            i = monomial >> BLOCK
            if not divides(i, s):
                continue
            prefix = monomial & MASK
            a = s-i
            if not a:
                product = {t << BLOCK: 1}
            elif not t:
                product = {a << BLOCK: 1}
            else:
                product = self.products.get(a | (t << BLOCK), {})
            for entry, c in product.items():
                value = entry + prefix
                result[value] = (result.get(value, 0) + coefficient*c) % 3
        return {entry: c for entry, c in result.items() if c}

    @cache
    def additive_differential(self, g):
        result = {}
        parity = 0
        for k, (_, _, m) in enumerate(self.digits):
            exponent = (g >> (4*k)) & 15
            if exponent:
                coefficient = (-1)**(parity + (1-exponent % 2)) % 3
                operator = m if exponent % 2 else 2*m
                result[(0, operator, g-(1 << (4*k)))] = coefficient
            parity += exponent
        return result

    def combine(self, a, b, scale=1):
        return add(a, b, 3, scale)

    def order(self, term):
        _, t, g = term
        content = t + self.generator_content(g)
        return weight(content), content

    def contract(self, p):
        result = {}
        for (q, t, g), coefficient in p.items():
            for k, (i, j, m) in enumerate(self.digits):
                operator_digit = ((t >> (BITS*i)) & 255) // 3**j % 3
                exponent = (g >> (4*k)) & 15
                if not operator_digit and not exponent:
                    continue
                required = 1 + exponent % 2
                if operator_digit >= required:
                    term = (q, t-required*m, g+(1 << (4*k)))
                    accumulate(result, term, coefficient*math.factorial(operator_digit))
                break
        return result

    def extend(self, z, mapping, cutoff):
        result = {}
        for (q, t, g), coefficient in z.items():
            for (u, a, h), c in mapping(g).items():
                for entry, b in self.operator_product(t, u, a).items():
                    output_operator = entry >> BLOCK
                    if weight(output_operator) + self.generator_weight(h) > cutoff:
                        continue
                    term = (q + (entry & MASK), output_operator, h)
                    accumulate(result, term, coefficient*c*b)
        return result

    def differential_terms(self, z, cutoff):
        return self.extend(z, self.differential, cutoff)

    def antidifferential(self, z, cutoff):
        result = {}
        error = z
        while error:
            least = min(self.order(term) for term in error)
            leading = {term: c for term, c in error.items() if self.order(term) == least}
            correction = self.contract(leading)
            assert correction, ("contraction_has_no_leading_preimage", least, leading)
            result = self.combine(result, correction)
            error = self.combine(error, self.differential_terms(correction, cutoff), -1)
            assert not error or min(self.order(term) for term in error) > least, (
                "nontriangular_antidifferential", least, error)
        return result

    @cache
    def differential(self, g):
        if not g:
            return {}
        initial = self.additive_differential(g)
        if self.generator_degree(g) == 1:
            return initial
        error = self.differential_terms(initial, self.cutoff)
        correction = self.antidifferential(error, self.cutoff)
        return self.combine(initial, correction, -1)

    def evaluate(self, cochain, z):
        result = {}
        for (q, t, g), coefficient in z.items():
            for u, c in cochain.get(g, {}).items():
                for monomial, b in self.eta(u).items():
                    if monomial >> BLOCK == t:
                        accumulate(result, q+(monomial & MASK), coefficient*c*b)
        return result

    def get_two(self, beta):
        result = {}
        for g in self.generators(2, 27):
            value = {}
            for (q, t, h), coefficient in self.differential(g).items():
                assert self.generator_degree(h) == 1
                k = next(k for k in range(len(self.digits)) if (h >> (4*k)) & 15)
                m = self.digits[k][2]
                for monomial, c in beta.items():
                    if (monomial >> BLOCK) & MASK == t and monomial >> (2*BLOCK) == m:
                        accumulate(value, q + (monomial & MASK), coefficient*c)
            if value:
                result[g] = value
        return result

    def cochain_differential(self, cochain, degree, internal_weight):
        result = {}
        for g in self.generators(degree+1, internal_weight):
            value = self.evaluate(cochain, self.differential(g))
            if value:
                result[g] = value
        return result

    def product(self, p, j, h, x, f, d):
        cutoff = h+d

        @cache
        def lift(s, g):
            if s == 0:
                return {(q, 0, 0): c for q, c in p.get(g, {}).items()}
            image = self.extend(self.differential(g), lambda a: lift(s-1, a), cutoff-h)
            return scaled(self.antidifferential(image, cutoff-h), (-1)**j, 3)

        result = {}
        for index, g in enumerate(self.generators(f+j, cutoff)):
            value = self.evaluate(x, lift(f, g))
            if value:
                result[g] = value
            if index % 100 == 0:
                self.progress("product", degree=f+j, generator=index,
                              total=len(self.generators(f+j, cutoff)),
                              terms=sum(map(len, result.values())))
        lift.cache_clear()
        return result

    @cache
    def basis(self, degree, internal_weight):
        return tuple((q, g) for g in self.generators(degree, internal_weight)
                     for q in sorted(self.coefficient_monomials(internal_weight-self.generator_weight(g))))

    @cache
    def actions(self, degree):
        result = {}
        for q in self.coefficient_monomials(degree):
            for monomial, coefficient in self.eta(q).items():
                result.setdefault(monomial >> BLOCK, []).append(
                    (q, monomial & MASK, coefficient))
        return result

    def incoming_matrix(self):
        columns = self.basis(5, 81)
        rows = self.basis(6, 81)
        column_index = {term: i for i, term in enumerate(columns)}
        row_index = {term: i for i, term in enumerate(rows)}
        matrix = [{} for _ in columns]
        generators = self.generators(6, 81)
        for index, g in enumerate(generators):
            for (u, t, h), coefficient in self.differential(g).items():
                for q, a, c in self.actions(81-self.generator_weight(h)).get(t, ()):
                    i = column_index[q, h]
                    j = row_index[u+a, g]
                    accumulate(matrix[i], j, coefficient*c)
            if index % 100 == 0:
                self.progress("incoming_matrix", generator=index, total=len(generators))
        return matrix, rows, columns


def flatten(cochain, basis):
    indices = {term: i for i, term in enumerate(basis)}
    return {indices[q, g]: c for g, polynomial in cochain.items()
            for q, c in polynomial.items()}


def unflatten(vector, basis):
    result = {}
    for index, coefficient in vector.items():
        q, g = basis[index]
        result.setdefault(g, {})[q] = coefficient
    return result


def solve_boundary(matrix, target, progress):
    pivots = {}
    vectors = []
    histories = []
    for column, original in enumerate(matrix):
        vector = original.copy()
        reductions = []
        while vector:
            pivot = min(vector)
            coefficient = vector[pivot]
            if pivot not in pivots:
                vector = scaled(vector, coefficient, 3)
                pivots[pivot] = len(vectors)
                vectors.append(vector)
                histories.append((column, coefficient, reductions))
                break
            previous = pivots[pivot]
            reductions.append((previous, coefficient))
            for row, value in vectors[previous].items():
                accumulate(vector, row, -coefficient*value)
        if column % 250 == 0:
            progress("boundary_elimination", column=column, total=len(matrix),
                     pivots=len(vectors))
    residue = target.copy()
    coefficients = {}
    for pivot in sorted(pivots):
        coefficient = residue.get(pivot, 0)
        if coefficient:
            previous = pivots[pivot]
            coefficients[previous] = coefficient
            for row, value in vectors[previous].items():
                accumulate(residue, row, -coefficient*value)
    if residue:
        coordinate = min(residue)
        functional = {coordinate: 1}
        for pivot in sorted(pivots, reverse=True):
            vector = vectors[pivots[pivot]]
            value = -sum(c * functional.get(row, 0) for row, c in vector.items()
                         if row != pivot) % 3
            if value:
                functional[pivot] = value
        assert all(sum(c*functional.get(row, 0) for row, c in column.items()) % 3 == 0
                   for column in matrix)
        value = sum(c*functional.get(row, 0) for row, c in target.items()) % 3
        assert value
        return "nonboundary", functional, len(vectors)
    solution = {}
    for index in reversed(range(len(histories))):
        coefficient = coefficients.get(index, 0)
        if not coefficient:
            continue
        column, inverse, reductions = histories[index]
        coefficient = coefficient*inverse % 3
        accumulate(solution, column, coefficient)
        for previous, value in reductions:
            accumulate(coefficients, previous, -coefficient*value)
    replay = {}
    for column, coefficient in solution.items():
        for row, value in matrix[column].items():
            accumulate(replay, row, coefficient*value)
    assert replay == target
    return "boundary", solution, len(vectors)


def encode_cochain(cochain):
    return [[g, encode_polynomial(polynomial, WIDTH)]
            for g, polynomial in sorted(cochain.items())]


def decode_cochain(data, resolution, degree, internal_weight):
    result = {}
    for g, polynomial in data:
        assert resolution.generator_degree(g) == degree
        assert g in resolution.generators(degree, internal_weight)
        value = {}
        for powers, coefficient in polynomial:
            assert len(powers) == WIDTH and all(isinstance(e, int) and e >= 0 for e in powers)
            q = pack(powers)
            assert weight(q) + resolution.generator_weight(g) == internal_weight
            assert coefficient in (1, 2) and q not in value
            value[q] = coefficient
        assert g not in result and value
        result[g] = value
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stage", choices=("bockstein", "products", "cube", "certify", "verify"),
                        default="verify")
    parser.add_argument("--cutoff", type=int, default=81)
    args = parser.parse_args()
    assert 27 <= args.cutoff <= 81
    start = time.monotonic()
    right, coproduct = structure()
    check_low_structure(right, coproduct)
    y, beta = corrected_bockstein(right)
    check_cobar_cocycle(beta, right, coproduct)
    summary = {
        "stage": args.stage,
        "cutoff": args.cutoff,
        "y_terms": len(y),
        "integral_bockstein_terms": len(beta),
        "right_unit_terms_mod_three": [sum(c % 3 != 0 for c in p.values()) for p in right[1:]],
        "coproduct_terms_mod_three": [sum(c % 3 != 0 for c in p.values()) for p in coproduct[1:]],
        "integral_arithmetic": "scaled integer logarithms, modular integral division, precision at least nine",
        "ordinary_bockstein_cocycle": True,
        "y": encode_polynomial(y, 8),
        "bockstein": encode_polynomial(beta, 12),
    }
    resolution = Resolution(args.cutoff, right, coproduct)
    summary["dimensions"] = {
        str(s): sum(len(resolution.coefficient_monomials(args.cutoff-resolution.generator_weight(g)))
                    for g in resolution.generators(s, args.cutoff))
        for s in (5, 6, 7)
    }
    if args.stage != "bockstein":
        resolution.build_products()
        p = resolution.get_two(beta)
        summary["small_bockstein"] = {
            str(g): encode_polynomial(a, 4) for g, a in p.items()
        }
        summary["small_bockstein_terms"] = sum(map(len, p.values()))
        dp = resolution.cochain_differential(p, 2, 27)
        assert not dp, ("bockstein_not_a_cocycle", dp)
        summary["small_bockstein_cocycle"] = True
        if args.stage in ("cube", "certify", "verify"):
            assert args.cutoff == 81
            square = resolution.product(p, 2, 27, p, 2, 27)
            cube = resolution.product(p, 2, 27, square, 4, 54)
            summary["cube"] = {str(g): encode_polynomial(a, 4) for g, a in cube.items()}
            summary["cube_terms"] = sum(map(len, cube.values()))
            assert not resolution.cochain_differential(cube, 6, 81)
            summary["cube_cocycle"] = True
            if args.stage == "certify":
                matrix, rows, columns = resolution.incoming_matrix()
                target = flatten(cube, rows)
                outcome, witness, rank = solve_boundary(matrix, target, resolution.progress)
                certificate = {
                    "target": "B(y)^3 in Ext^{6,324}_{(BP_*/3,BP_*BP/3)}(BP_*/3,BP_*/3)",
                    "prime": 3,
                    "cutoff": 81,
                    "digits": [list(digit[:2]) for digit in resolution.digits],
                    "outcome": outcome,
                    "bockstein": encode_cochain(p),
                    "cube": encode_cochain(cube),
                    "incoming_rank_computed_not_assumed": rank,
                    "dimensions_computed_not_assumed": summary["dimensions"],
                    "independent_review": "pending",
                }
                if outcome == "boundary":
                    primitive = unflatten(witness, columns)
                    assert resolution.cochain_differential(primitive, 5, 81) == cube
                    certificate["primitive"] = encode_cochain(primitive)
                    certificate["primitive_terms"] = len(witness)
                else:
                    certificate["dual_functional"] = sorted(witness.items())
                (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
                summary["outcome"] = outcome
            elif args.stage == "verify":
                certificate = json.loads((HERE / "exact_certificate.json").read_text())
                assert certificate["prime"] == 3 and certificate["cutoff"] == 81
                assert certificate["digits"] == [list(digit[:2]) for digit in resolution.digits]
                assert decode_cochain(certificate["bockstein"], resolution, 2, 27) == p
                assert decode_cochain(certificate["cube"], resolution, 6, 81) == cube
                if certificate["outcome"] == "boundary":
                    primitive = decode_cochain(certificate["primitive"], resolution, 5, 81)
                    assert resolution.cochain_differential(primitive, 5, 81) == cube
                elif certificate["outcome"] == "nonboundary":
                    matrix, rows, _ = resolution.incoming_matrix()
                    functional = dict(certificate["dual_functional"])
                    assert len(functional) == len(certificate["dual_functional"])
                    assert all(0 <= row < len(rows) and coefficient in (1, 2)
                               for row, coefficient in functional.items())
                    assert all(sum(c*functional.get(row, 0) for row, c in column.items()) % 3 == 0
                               for column in matrix)
                    assert sum(c*functional.get(row, 0)
                               for row, c in flatten(cube, rows).items()) % 3 != 0
                else:
                    raise ValueError("Certificate must carry a primitive or a nonboundary functional.")
                summary["verified_outcome"] = certificate["outcome"]
    summary["elapsed_seconds"] = round(time.monotonic()-start, 3)
    output = HERE / f"calculation_{args.stage}_{args.cutoff}.json"
    output.write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps({key: value for key, value in summary.items()
                      if key not in ("y", "bockstein", "small_bockstein", "cube")}, indent=2))


if __name__ == "__main__":
    main()
