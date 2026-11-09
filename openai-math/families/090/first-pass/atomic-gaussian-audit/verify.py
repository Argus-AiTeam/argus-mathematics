#!/usr/bin/env python3
"""Independent exact arithmetic for the atomic Gaussian construction.

Only the Python standard library is used. See theorem.md for the analytic
implications of these uniform inequalities; this is not a Lean proof.
"""

import argparse
import json
import math
from fractions import Fraction
from functools import cache
from pathlib import Path


SCALE = 10**72
ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
MANUSCRIPT = (
    ROOT / "research/openai_manuscript"
    / "An-atomic-certificate-for-triangular-lattice-universal-optimality-September-26-2026"
    / "build/main.tex"
)


def ceil_div(a, b):
    return -((-a) // b)


class Bound:
    __slots__ = ("lo", "hi")

    def __init__(self, value=0):
        if isinstance(value, Bound):
            self.lo, self.hi = value.lo, value.hi
        else:
            q = Fraction(value)
            self.lo = q.numerator * SCALE // q.denominator
            self.hi = ceil_div(q.numerator * SCALE, q.denominator)

    @classmethod
    def endpoints(cls, lo, hi):
        if lo > hi:
            raise ArithmeticError("Reversed interval")
        out = cls.__new__(cls)
        out.lo, out.hi = lo, hi
        return out

    def __add__(self, other):
        if isinstance(other, Rectangle):
            return NotImplemented
        other = Bound(other)
        return Bound.endpoints(self.lo + other.lo, self.hi + other.hi)

    __radd__ = __add__

    def __neg__(self):
        return Bound.endpoints(-self.hi, -self.lo)

    def __sub__(self, other):
        return self + (-other if isinstance(other, (Bound, Rectangle)) else -Bound(other))

    def __rsub__(self, other):
        return -self + other

    def __mul__(self, other):
        if isinstance(other, Rectangle):
            return NotImplemented
        other = Bound(other)
        products = (
            self.lo * other.lo, self.lo * other.hi,
            self.hi * other.lo, self.hi * other.hi,
        )
        return Bound.endpoints(min(products) // SCALE, ceil_div(max(products), SCALE))

    __rmul__ = __mul__

    def reciprocal(self):
        if self.lo <= 0 <= self.hi:
            raise ArithmeticError("Division interval contains zero")
        return Bound.endpoints(
            SCALE * SCALE // self.hi, ceil_div(SCALE * SCALE, self.lo)
        )

    def __truediv__(self, other):
        return self * Bound(other).reciprocal()

    def __rtruediv__(self, other):
        return Bound(other) * self.reciprocal()

    def square(self):
        low = 0 if self.lo <= 0 <= self.hi else min(self.lo**2, self.hi**2)
        high = max(self.lo**2, self.hi**2)
        return Bound.endpoints(low // SCALE, ceil_div(high, SCALE))

    def __pow__(self, exponent):
        if not isinstance(exponent, int):
            raise TypeError("Only integer powers are supported")
        if exponent < 0:
            return self.reciprocal() ** (-exponent)
        if exponent == 0:
            return Bound(1)
        if exponent == 1:
            return self
        half = (self ** (exponent // 2)).square()
        return half * self if exponent % 2 else half

    def __abs__(self):
        low = 0 if self.lo <= 0 <= self.hi else min(abs(self.lo), abs(self.hi))
        return Bound.endpoints(low, max(abs(self.lo), abs(self.hi)))

    def sqrt(self):
        if self.lo < 0:
            raise ArithmeticError("Square root lacks a nonnegative argument")
        lo = math.isqrt(self.lo * SCALE)
        hi = math.isqrt(self.hi * SCALE)
        if hi * hi < self.hi * SCALE:
            hi += 1
        return Bound.endpoints(lo, hi)


class Rectangle:
    __slots__ = ("real", "imag")

    def __init__(self, real=0, imag=0):
        if isinstance(real, Rectangle):
            self.real, self.imag = real.real, real.imag
        else:
            self.real, self.imag = Bound(real), Bound(imag)

    def __add__(self, other):
        other = Rectangle(other)
        return Rectangle(self.real + other.real, self.imag + other.imag)

    __radd__ = __add__

    def __neg__(self):
        return Rectangle(-self.real, -self.imag)

    def __sub__(self, other):
        return self + (-Rectangle(other))

    def __rsub__(self, other):
        return -self + other

    def __mul__(self, other):
        other = Rectangle(other)
        return Rectangle(
            self.real * other.real - self.imag * other.imag,
            self.real * other.imag + self.imag * other.real,
        )

    __rmul__ = __mul__

    def __truediv__(self, other):
        return Rectangle(self.real / other, self.imag / other)

    def __abs__(self):
        return (self.real.square() + self.imag.square()).sqrt()


def exp_bound(value):
    complex_value = isinstance(value, Rectangle)
    size = abs(value)
    steps = 0
    while size.hi > SCALE:
        value = value / 2
        size = abs(value)
        steps += 1
    term = Rectangle(1) if complex_value else Bound(1)
    total = term
    for order in range(1, 101):
        term = term * value / order
        total = total + term
    # For |value| <= 1, the omitted norm is <= 2/101! < 1/SCALE.
    if not 2 * SCALE < math.factorial(101):
        raise ArithmeticError("Taylor remainder budget is insufficient")
    epsilon = Bound.endpoints(-1, 1)
    total = total + (Rectangle(epsilon, epsilon) if complex_value else epsilon)
    for _ in range(steps):
        total = total * total if complex_value else total.square()
    if not complex_value:
        total = Bound.endpoints(max(0, total.lo), total.hi)
    return total


def atan_reciprocal(q):
    partial = sum(
        (Fraction((-1) ** j, (2 * j + 1) * q ** (2 * j + 1)) for j in range(60)),
        Fraction(0),
    )
    remainder = Fraction(1, 121 * q**121)
    return Bound.endpoints(Bound(partial).lo, Bound(partial + remainder).hi)


PI = 16 * atan_reciprocal(5) - 4 * atan_reciprocal(239)
IMAGINARY = Rectangle(0, 1)
B = Fraction(4, 3)
H = Fraction(27, 50)
H0 = Fraction(17, 50)
ETA = H - H0
KAPPA = PI / 36
BETA = Bound(3).sqrt() / 2
RESIDUES = (0, 1, 3, 4, 7, 9, 12, 13, 16, 19, 21, 25, 27, 28, 31)
FINITE = RESIDUES[1:11]
LOW = (0,) + FINITE
TAIL_PERIOD = RESIDUES[11:] + tuple(n + 36 for n in LOW)
FREQUENCIES = tuple(Fraction(j, 18) for j in range(16))
ZMAX, WMAX, DELTA_MAX, UMAX, PMAX = map(
    Bound, ("0.391", "0.0061", "0.00018", "0.00048", "0.0000003")
)


def lower_max(values):
    values = [Bound(x) for x in values]
    return Bound.endpoints(max(x.lo for x in values), max(x.hi for x in values))


def lower_min(values):
    values = [Bound(x) for x in values]
    return Bound.endpoints(min(x.lo for x in values), min(x.hi for x in values))


def dot(left, right):
    if len(left) != len(right):
        raise ValueError("Dot-product dimensions differ")
    return sum(a * b for a, b in zip(left, right))


def product(left, right):
    if not left or not right or len(left[0]) != len(right):
        raise ValueError("Matrix dimensions differ")
    columns = list(zip(*right))
    return [[dot(row, column) for column in columns] for row in left]


def add(left, right, a=1, b=1):
    if len(left) != len(right):
        raise ValueError("Matrix row counts differ")
    if any(len(x) != len(y) for x, y in zip(left, right)):
        raise ValueError("Matrix column counts differ")
    return [[a * x + b * y for x, y in zip(u, v)] for u, v in zip(left, right)]


def matrix_norm(matrix):
    return lower_max(sum(abs(x) for x in column) for column in zip(*matrix))


def ring_reduce(coefficients):
    coefficients = list(coefficients) + [0] * max(0, 12 - len(coefficients))
    for k in range(len(coefficients) - 1, 11, -1):
        a = coefficients[k]
        coefficients[k - 6] += a
        coefficients[k - 12] -= a
    return tuple(coefficients[:12])


ZERO_RING = (0,) * 12
ONE_RING = (1,) + (0,) * 11


def ring_add(left, right, factor=1):
    return tuple(a + factor * b for a, b in zip(left, right))


def root_multiple(value, power):
    return ring_reduce([0] * (power % 36) + list(value))


def ring_scale(value, factor):
    return tuple(factor * a for a in value)


def sine_product(omitted=None):
    polynomial = {0: ONE_RING}
    for residue in RESIDUES:
        if residue == omitted:
            continue
        updated = {}
        for degree, coefficient in polynomial.items():
            for shift, term in (
                (-1, ring_scale(root_multiple(coefficient, residue), -1)),
                (0, ring_scale(coefficient, 2)),
                (1, ring_scale(root_multiple(coefficient, -residue), -1)),
            ):
                index = degree + shift
                updated[index] = ring_add(updated.get(index, ZERO_RING), term)
        polynomial = updated
    return polynomial


@cache
def phase72(power):
    return exp_bound(IMAGINARY * PI * Fraction(power % 72, 36))


def evaluate_ring(value):
    return sum(a * phase72(2 * j) for j, a in enumerate(value))


def evaluate_laurent_at_node(polynomial, node, derivative_order):
    result = ZERO_RING
    for degree, coefficient in polynomial.items():
        term = root_multiple(coefficient, degree * node)
        result = ring_add(result, ring_scale(term, degree**derivative_order))
    return result


class Audit:
    def __init__(self):
        self.enclosures = {}
        self.exact = {}

    def bound(self, name, value, *, below=None, above=None):
        value = Bound(value)
        if below is not None and not value.hi < Bound(below).lo:
            raise AssertionError(f"{name}: upper endpoint is not below {below}")
        if above is not None and not Bound(above).hi < value.lo:
            raise AssertionError(f"{name}: lower endpoint is not above {above}")
        self.enclosures[name] = {
            "lower_numerator": str(value.lo), "upper_numerator": str(value.hi),
            **({"strictly_below": str(below)} if below is not None else {}),
            **({"strictly_above": str(above)} if above is not None else {}),
        }
        return value

    def identity(self, name, condition):
        if not condition:
            raise AssertionError(name)
        self.exact[name] = True


def spectral_data(audit):
    polynomial = sine_product()
    for node in RESIDUES:
        for order in (0, 1):
            audit.identity(
                f"double_zero_{node}_{order}",
                evaluate_laurent_at_node(polynomial, node, order) == ZERO_RING,
            )
    p = [evaluate_ring(polynomial[j]) for j in range(16)]
    folded_p = [[(1 if j == 0 else 2) * x] for j, x in enumerate(p)]
    q, d = {}, {}
    for node in RESIDUES:
        value = 4 * KAPPA.square()
        logarithmic_derivative = Bound(0)
        for residue in RESIDUES:
            if residue != node:
                trig = phase72(node - residue)
                value = value * 4 * trig.imag.square()
                logarithmic_derivative += 2 * KAPPA * trig.real / trig.imag
        q[node], d[node] = value, logarithmic_derivative

    atoms = [[] for _ in range(16)]
    for node in LOW:
        omitted = sine_product(node)
        simple = {}
        for degree, coefficient in omitted.items():
            for shift, power, sign in ((1, 9 - node, -1), (-1, 9 + node, 1)):
                index = degree + shift
                term = ring_scale(root_multiple(coefficient, power), sign)
                simple[index] = ring_add(simple.get(index, ZERO_RING), term)
        for j in range(16):
            double = ring_scale(omitted.get(j, ZERO_RING), 4)
            suffix_c, suffix_d = ZERO_RING, polynomial[j]
            for l in range(j + 1, 16):
                term = root_multiple(polynomial[l], (l - j) * node)
                suffix_c = ring_add(suffix_c, ring_scale(term, -4 * (l - j)))
                suffix_d = ring_add(suffix_d, ring_scale(term, 2))
            audit.identity(f"atomic_c_{node}_{j}", double == suffix_c)
            audit.identity(
                f"atomic_d_{node}_{j}",
                simple.get(j, ZERO_RING) == root_multiple(suffix_d, 9),
            )
            fold = 1 if j == 0 else 2
            atoms[j].extend((
                fold * KAPPA.square() * evaluate_ring(double),
                fold * KAPPA * evaluate_ring(simple.get(j, ZERO_RING)),
            ))
    variation = [[Bound(0), Bound(0)]]
    for j in range(1, 16):
        variation.append([
            2 * (PI / 18).square()
            * sum(Fraction(2 * (l - j) + 1, 2) * abs(p[l]) for l in range(j, 16)),
            2 * PI / 18 * sum(abs(p[l]) for l in range(j, 16)),
        ])
    return atoms, folded_p, variation, q, d


class Wave:
    def __init__(self, k, v):
        self.k, self.v = k, v
        self.direct_rate = PI * (k - H0)
        self.direct, self.transformed, self.prefactor = [], [], []
        self.direct_modulus, self.transformed_modulus = [], []
        self.amplitude, self.rate = [], []
        for t in FREQUENCIES:
            x = Bound(B) / (k * k + t * t)
            self.direct.append(Rectangle(-self.direct_rate, PI * t))
            self.transformed.append(Rectangle(-PI * (k * x - v), -PI * t * x))
            self.prefactor.append(Rectangle(k, t) / (BETA * (k * k + t * t)))
            self.direct_modulus.append(PI * Bound(t * t + (k - H0)**2).sqrt())
            self.transformed_modulus.append(
                PI * (v * v + (B - 2 * k * v) * x).sqrt()
            )
            self.amplitude.append(x.sqrt())
            self.rate.append(PI * (k * x - v))

    def jet_map(self, nodes, matrix, q, d):
        rows = []
        for n in nodes:
            values = [
                prefactor * exp_bound(w * n)
                for prefactor, w in zip(self.prefactor, self.transformed)
            ]
            complex_rows = [
                [-value for value in values],
                [(d[n % 36] - w) * value for w, value in zip(self.transformed, values)],
            ]
            rows.extend(
                [x.real / q[n % 36] for x in row]
                for row in product(complex_rows, matrix)
            )
        return rows

    def jet_envelope(self, nodes, matrix, q, d, repeat=False):
        row = []
        for rate, amplitude, derivative in zip(
            self.rate, self.amplitude, self.transformed_modulus
        ):
            entry = amplitude * sum(
                (1 + abs(d[n % 36]) + derivative)
                * exp_bound(-rate * n) / q[n % 36] for n in nodes
            )
            if repeat:
                entry /= 1 - exp_bound(-36 * rate)
            row.append(entry)
        return lower_max(product([row], matrix)[0])

    def curvature(self, s, matrix):
        direct = [
            x.square() * exp_bound(-self.direct_rate * s) / 2
            for x in self.direct_modulus
        ]
        transformed = [
            x.square() * a * exp_bound(-r * s) / 2
            for x, a, r in zip(self.transformed_modulus, self.amplitude, self.rate)
        ]
        return [lower_max(row) for row in product([direct, transformed], matrix)]

    def taylor_error(self, m, y, matrix):
        def remainder(derivative, rate):
            u = abs(y) * derivative
            if not u.hi < 24 * SCALE:
                raise ArithmeticError("Taylor ratio is not below one")
            return (
                derivative.square() * u**21 * exp_bound(-m * rate)
                / math.factorial(23) / (1 - u / 24)
            )
        direct = [remainder(x, self.direct_rate) for x in self.direct_modulus]
        transformed = [
            a * remainder(x, r)
            for x, a, r in zip(self.transformed_modulus, self.amplitude, self.rate)
        ]
        return sum(lower_max(row) for row in product([direct, transformed], matrix))

    def taylor_rows(self, m, y, direct_spectrum, transformed_spectrum):
        result = []
        tables = []
        for exponents, amplitudes in (
            (self.direct, [1] * 16), (self.transformed, self.prefactor)
        ):
            columns = []
            for w, amplitude in zip(exponents, amplitudes):
                term = w * w * exp_bound(m * w) * amplitude / 2
                column = [term]
                for order in range(1, 21):
                    term = term * y * w / (order + 2)
                    column.append(term)
                columns.append(column)
            tables.append(list(zip(*columns)))
        for row in add(
            product(tables[0], direct_spectrum),
            product(tables[1], transformed_spectrum),
        ):
            result.append([x.real for x in row])
        return result


def inverse(matrix, audit, name):
    size = len(matrix)
    work = [
        list(row) + [Bound(int(i == j)) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    pivots = []
    for i in range(size):
        pivot = work[i][i]
        pivots.append(abs(pivot))
        work[i][i:] = [x / pivot for x in work[i][i:]]
        work[i][i] = Bound(1)
        for j in range(size):
            if j != i:
                multiplier = work[j][i]
                work[j][i:] = [
                    x - multiplier * y
                    for x, y in zip(work[j][i:], work[i][i:])
                ]
                work[j][i] = Bound(0)
    audit.bound(name + "_smallest_pivot", lower_min(pivots), above="0.12")
    audit.bound(name + "_largest_pivot", lower_max(pivots), below="1.74")
    return [row[size:] for row in work]


def basis(index, coefficient=1):
    return [Bound(coefficient if j == index else 0) for j in range(8)]


def zero_rows(count):
    return [basis(0, 0) for _ in range(count)]


def finite_coefficients(atoms, constant, q, d, waves, audit):
    pole_map = waves[H, H].jet_map(FINITE, atoms, q, d)
    constant_map = waves[H0, H].jet_map(FINITE, constant, q, d)
    coupling = [row[2:] for row in pole_map]
    fixed_map = [row[:2] + extra for row, extra in zip(pole_map, constant_map)]
    fixed = [
        [basis(1, "0.44"), basis(1, 0), basis(1, coefficient)]
        for coefficient in ("-0.006", "0.006")
    ]
    target = zero_rows(20)
    for position, node in enumerate(FINITE[:4]):
        factor = q[1] * exp_bound(PI * ETA * node) / q[node]
        target[2 * position] = basis(2 * position, factor)
        target[2 * position + 1] = [
            x + y for x, y in zip(
                basis(2 * position + 1, -factor),
                basis(2 * position, factor * (PI * ETA - d[node])),
            )
        ]
    rhs1 = add(target, product(fixed_map, fixed[1]))
    rhs2 = product(fixed_map, fixed[0])
    identity = [[Bound(int(i == j)) for j in range(20)] for i in range(20)]
    solutions = []
    for sign, label, ceiling in ((1, "plus", "16.16"), (-1, "minus", "3.89")):
        inv = inverse(add(identity, coupling, b=-sign), audit, label)
        audit.bound(label + "_inverse_norm", matrix_norm(inv), below=ceiling)
        solutions.append(product(inv, add(rhs1, rhs2, b=sign)))
    output = [
        fixed[i][:2]
        + add(solutions[0], solutions[1], a=Fraction(1, 2), b=Fraction(sign, 2))
        + fixed[i][2:]
        for i, sign in enumerate((1, -1))
    ]
    for i, (matrix, threshold) in enumerate(zip(output, ("2.58", "2.80")), 1):
        columns = list(zip(*matrix))
        endpoint = lower_max(
            sum(abs(a * z + b) for a, b in zip(columns[0], columns[1]))
            for z in (Bound(0), ZMAX)
        )
        remaining = dot(
            [sum(abs(x) for x in column) for column in columns[2:]],
            [Bound("0.0024"), WMAX, ZMAX * UMAX, UMAX, PMAX, PMAX],
        )
        audit.bound(f"side_{i}_finite_norm", endpoint + remaining, below=threshold)
    return output


def half_cells():
    cells = []
    for position, node in enumerate(FINITE[:7]):
        left = Fraction(-1) if position == 0 else Fraction(FINITE[position - 1] - node, 2)
        right = Fraction(FINITE[position + 1] - node, 2)
        cells.extend(((node, left), (node, right)))
    return cells


def envelope_checks(atoms, constant, variation, q, d, waves, audit):
    audit.bound("maximum_z", 1 / (PI * (1 / BETA - H0)), below="0.391")
    for exponent, ceiling in ((2, "0.0061"), (3, "0.00048"), (6, "0.0000003")):
        audit.bound(f"parameter_exp_{exponent}", exp_bound(-exponent / ZMAX), below=ceiling)
    critical = (1 + 2 * ZMAX).sqrt() - 1
    audit.bound(
        "parameter_delta_maximum", (ZMAX - critical) * exp_bound(-2 / critical),
        below="0.00015",
    )
    audit.bound("smallest_Q", lower_min(q.values()), above="0.157")
    audit.bound("largest_Q", lower_max(q.values()), below=40)
    audit.bound("largest_abs_D", lower_max(abs(x) for x in d.values()), below="2.83")
    audit.bound("large_cell_Q", lower_min(q[n] for n in (16, 19, 21)), above=16)
    midpoint_thresholds = (
        ".165", ".120", ".054", ".482", ".656", "1.11", ".337",
        "3.13", "9.26", "8.19", "19.08", "2.34", ".706", "6.80", "14.1",
    )
    for left, right, threshold in zip(
        RESIDUES, RESIDUES[1:] + (36,), midpoint_thresholds
    ):
        midpoint = Fraction(left + right, 2)
        value = Bound(1)
        for residue in RESIDUES:
            trig = exp_bound(IMAGINARY * PI * (midpoint - residue) / 36)
            value = value * 4 * trig.imag.square()
        audit.bound(
            f"midpoint_{left}_{right}", value / Fraction((right - left)**2, 4),
            above=threshold,
        )
    absolute_atoms = [[abs(x) for x in row] for row in atoms]
    absolute_constant = [[abs(row[0])] for row in constant]
    audit.bound("tail_variation_norm", matrix_norm(variation), below=119)
    for name, nodes, k, v, matrix, repeat, ceiling in (
        ("tail_to_finite", FINITE, H0, H, variation, False, "335"),
        ("finite_to_tail", TAIL_PERIOD, H, H0, absolute_atoms, True, "0.000000000000007"),
        ("tail_to_tail", TAIL_PERIOD, H0, H0, variation, True, "0.000000023"),
        ("constant_to_tail", TAIL_PERIOD, H0, H0, absolute_constant, True, "0.000000127"),
    ):
        audit.bound(
            name, waves[k, v].jet_envelope(nodes, matrix, q, d, repeat), below=ceiling
        )
    alias = (1 + PI * ETA) / (exp_bound(36 * PI * ETA) - 1)
    audit.bound("direct_repetitions", alias, below="0.00000000025")
    missing_finite = q[1] * sum(
        (1 + ZMAX + ZMAX * abs(PI * ETA - d[n]))
        * exp_bound(PI * ETA * n + (1 - n) / ZMAX) / q[n]
        for n in FINITE[4:]
    )
    missing_tail = q[1] * sum(
        (1 + ZMAX + ZMAX * abs(d[n % 36]))
        * exp_bound((1 - n) / ZMAX) / q[n % 36]
        for n in TAIL_PERIOD
    ) / (1 - exp_bound(-36 / ZMAX))
    audit.bound("omitted_finite_target", missing_finite, below="0.000000081")
    audit.bound("omitted_tail_target", missing_tail, below="0.000000000000000000000000000092")
    pole_limits = ("1498", "45.1", "13.8", ".00458", ".000022")
    constant_limits = ("13530", "151", "31", ".00122", ".000004")
    tail_limits = ("26500", "1160", "800", "800", "800")
    for s, pl, cl, tl in zip(("0", "1", "2", "14.5", "23"), pole_limits, constant_limits, tail_limits):
        s = Bound(s)
        audit.bound(
            f"pole_curvature_{s.lo // SCALE}_{s.lo % SCALE}",
            sum(waves[H, H0].curvature(s, absolute_atoms)), below=pl,
        )
        audit.bound(
            f"constant_curvature_{s.lo // SCALE}_{s.lo % SCALE}",
            waves[H0, H0].curvature(s, absolute_constant)[1], below=cl,
        )
        tail_wave = waves[H0, H0]
        index = 0 if s.hi == 0 else 15
        tail_value = 60 * (
            tail_wave.direct_modulus[15].square()
            + tail_wave.transformed_modulus[index].square()
            * tail_wave.amplitude[index] * exp_bound(-s * tail_wave.rate[index])
        )
        audit.bound(f"tail_curvature_{s.lo}", tail_value, below=tl)
    for m, y in half_cells():
        error = (
            3 * waves[H, H0].taylor_error(m, Bound(y), absolute_atoms)
            + Bound(".006") * waves[H0, H0].taylor_error(m, Bound(y), absolute_constant)
        )
        audit.bound(f"taylor_{m}_{y}", error, below=".00161" if m == 1 else ".0000075")


def polytope_minimum(row):
    z, c, zw, w, a, u, r, p = row
    return (
        c + ZMAX * lower_min((z, 0))
        + WMAX * lower_min((w + ZMAX * zw, 0))
        + DELTA_MAX * lower_min((-zw, 0))
        + UMAX * lower_min((0, u, u + ZMAX * a))
        + PMAX * (lower_min((r, 0)) + lower_min((p, 0)))
    )


def bernstein_minimum(polynomial):
    degree = len(polynomial) - 1
    rows = [
        [
            sum(
                Fraction(math.comb(i, j), math.comb(degree, j)) * polynomial[j][k]
                for j in range(i + 1)
            )
            for k in range(8)
        ]
        for i in range(degree + 1)
    ]
    return lower_min(polytope_minimum(row) for row in rows)


def polynomial_checks(coefficients, atoms, constant, q, waves, audit):
    spectra = [product(atoms, matrix[:-1]) for matrix in coefficients]
    constants = [product(constant, matrix[-1:]) for matrix in coefficients]
    ordinary_count = 0
    for m, y in half_cells():
        polynomials = [
            add(
                waves[H, H0].taylor_rows(m, y, spectra[i], spectra[1 - i]),
                waves[H0, H0].taylor_rows(m, y, constants[i], constants[1 - i]),
            )
            for i in (0, 1)
        ]
        position = FINITE.index(m)
        threshold2 = (".174" if y < 0 else ".011") if m == 1 else (
            ".00097", ".00097", ".0028", ".0039", ".0020", ".0020"
        )[position - 1]
        audit.bound(f"sign_side2_{m}_{y}", bernstein_minimum(polynomials[1]), above=threshold2)
        ordinary_count += 1
        negative = [[-x for x in row] for row in polynomials[0]]
        if m == 1 and y > 0:
            def at_endpoint(z):
                return [[Bound(0), row[1] + z * row[0], *row[2:]] for row in negative]

            def shift(poly, amount):
                return zero_rows(amount) + poly + zero_rows(2 - amount)

            def multiply_quadratic(poly, index):
                out = shift(poly, 2)
                if index:
                    out = add(out, shift(poly, 1), b=2 * index * ZMAX)
                if index == 2:
                    out = add(out, shift(poly, 0), b=6 * ZMAX.square())
                return out

            a, d = at_endpoint(Bound(0)), at_endpoint(ZMAX)
            exceptional = [
                shift(a, 1),
                add(multiply_quadratic(a, 1), multiply_quadratic(d, 0), a=Fraction(2, 3), b=Fraction(1, 3)),
                add(multiply_quadratic(a, 2), multiply_quadratic(d, 1), a=Fraction(1, 3), b=Fraction(2, 3)),
                multiply_quadratic(d, 2),
            ]
            for j, (poly, ceiling) in enumerate(zip(exceptional, (".046", ".056", ".024", ".027"))):
                poly[0][1] += q[1] * (1 if j == 0 else j * ZMAX)
                if j:
                    poly[1][1] += q[1]
                audit.bound(f"exceptional_{j}", bernstein_minimum(poly), above=ceiling)
            continue
        if m == 1:
            negative[0][1] += q[1] / (2 * ZMAX)
        if m == 3:
            negative[0][3] += Fraction(4, 5) * q[1]
        threshold1 = (".057", ".00055", ".00047", ".0028", ".0039", ".0020", ".0020")[position]
        audit.bound(f"sign_side1_{m}_{y}", bernstein_minimum(negative), above=threshold1)
        ordinary_count += 1
    audit.identity("ordinary_polynomial_count_27", ordinary_count == 27)
    audit.identity("bernstein_row_count_659", ordinary_count * 21 + 4 * 23 == 659)


def continuum_checks(audit):
    F = Fraction
    actual = {(m * m + m * n + n * n) % 36 for m in range(36) for n in range(36)}
    audit.identity("quadratic_form_residues", actual == set(RESIDUES))
    audit.identity("tail_period_has_15_distinct_residues", len(TAIL_PERIOD) == 15 and len({n % 36 for n in TAIL_PERIOD}) == 15)
    expected = (F(100079, 455650), F(8949, 455650), F(216419, 554650), F(105489, 554650))
    for (k, v), target in zip(((H0, H0), (H0, H), (H, H0), (H, H)), expected):
        audit.identity(f"positive_decay_{k}_{v}", B * k / (k * k + F(25, 36)) - v == target and target > 0)
        audit.identity(f"jet_monotonicity_{k}_{v}", B - 2 * k * v > 0 and (k * k + F(25, 36)) / B < 3 * k)
    audit.bound("pi_above_3", PI, above=3)
    audit.bound("tail_curvature_monotonicity", PI * H0 - F(3, 2) * (H0 * H0 + F(25, 36)) / B, above=0)
    audit.bound("largest_wave_derivative", PI * (B / H0 - H0), below=12)
    beta, delta, residual = F(3, 10**10), F(3, 10**8), F(82, 10**9)
    tail_errors, finite_errors = [], []
    for label, norm, constant in (("plus", 17, F(0)), ("minus", 5, F(12, 1000) * F(13, 10**8))):
        contraction = delta + 340 * beta * norm
        audit.bound(label + "_schur_contraction", contraction, below=1)
        tail_residual = F(1, 10**26) + 6 * beta + constant
        tail_error = (tail_residual + beta * norm * residual) / (1 - contraction)
        finite_error = norm * (residual + 340 * tail_error)
        tail_errors.append(tail_error)
        finite_errors.append(finite_error)
        audit.bound(label + "_tail_error", tail_error, below=".000000003361")
        audit.bound(label + "_finite_error", finite_error, below=".000012")
    audit.bound("individual_tail_error", sum(tail_errors) / 2, below=".000000003")
    audit.bound("individual_finite_error", sum(finite_errors) / 2, below=".00001")
    for name, finite, tail, truncation, threshold in (
        ("left_first", 1510, 26500, F(2, 1000), ".018"),
        ("right_first", 46, 1160, F(2, 1000), ".003"),
        ("later_cells", 14, 800, F(1, 100000), ".00016"),
    ):
        audit.bound(name + "_deleted_error", finite * F(1, 100000) + tail * F(3, 10**9) + truncation, below=threshold)
    audit.identity("gaussian_q_second_derivative", [2 - 8 + 6, 0 - 4 + 4, 1] == [0, 0, 1])
    audit.identity("gaussian_q_identity", [-6, -4 + 6, -1 + 4 - 3, 1 - 1] == [-6, 2, 0, 0])
    z, v = F(391, 1000), F(1, 2)
    r = (3 * z + v) / (6 * z * z + 4 * z * v + v * v)
    audit.bound("gaussian_m3_comparison", r, above=".8")
    audit.bound("exceptional_first_margin", F(46, 1000) - F(3, 1000), above=0)
    audit.bound("exceptional_other_margin", F(24, 1000) - F(3, 1000) * F(7, 2), above=0)
    for label, q, barrier in (("middle", F(465, 100000), F(18, 1000)), ("unbounded", F(23, 1000000), F(324, 1000000))):
        curvature = F(301, 100) * q + 800 * F(3, 10**9) + F(6, 1000) * F(2, 1000)
        audit.bound(label + "_curvature", curvature, below=barrier)
        audit.bound(label + "_sign_margin", barrier - curvature, above=0)


def run():
    audit = Audit()
    text = MANUSCRIPT.read_text()
    bindings = (
        r"\label{prop:exact-interpolation}",
        r"\label{prop:global-signs}",
        r"h=\frac{17}{50},\quad H=\frac{27}{50}",
        r"c_{1,0}=c_{2,0}=\frac{11}{25}",
        r"C_1=-\frac3{500},\quad C_2=\frac3{500}",
        r"z=\frac1{\pi(\alpha/b-h)}",
        r"G_z(s)=Q_1z e^{(1-s)/z}",
    )
    for index, binding in enumerate(bindings):
        audit.identity(f"source_binding_{index}", binding in text)
    continuum_checks(audit)
    atoms, constant, variation, q, d = spectral_data(audit)
    waves = {(k, v): Wave(k, v) for k in (H0, H) for v in (H0, H)}
    envelope_checks(atoms, constant, variation, q, d, waves, audit)
    coefficients = finite_coefficients(atoms, constant, q, d, waves, audit)
    polynomial_checks(coefficients, atoms, constant, q, waves, audit)
    jacobian = json.loads((HERE / "jacobian_result.json").read_text())
    jacobian_output = jacobian["result"]["output"]
    audit.identity("jacobian_nonconclusion_preserved", jacobian_output["status"] == "DOMAIN_UNPROVEN")
    return {
        "claim": "C_ATOMIC9000090",
        "result_class": "exact_verification_theorem",
        "independent_review": "required_not_yet_performed",
        "source": str(MANUSCRIPT.relative_to(ROOT)),
        "arithmetic": {
            "denominator": str(SCALE),
            "pi": "Machin identity with 60-term alternating rational enclosures",
            "transcendentals": "100-term Taylor enclosure, exact range reduction and repeated squaring",
            "spectral_coefficients": "integer arithmetic modulo X^12-X^6+1",
        },
        "analytic_argument": "theorem.md",
        "scope": "all alpha>=1, all positive nodes, all s>=0; analytic implications require reading theorem.md",
        "jacobian": {
            "operation_id": jacobian["result"]["operation_id"],
            "server_version": jacobian["server"]["version"],
            "protocol_version": jacobian["protocol_version"],
            "status": jacobian_output["status"],
            "mathematical_weight": "none; domain-unproven is not evidence for or against the theorem",
        },
        "exact_identities": audit.exact,
        "enclosures": audit.enclosures,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = run()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(certificate.read_text())
        if result != recorded:
            raise AssertionError("Recomputed certificate differs from the recorded result")
    print(
        f"PASS: {len(result['exact_identities'])} exact identities, "
        f"{len(result['enclosures'])} rigorous enclosures, 659 Bernstein rows; "
        "analytic proof and independent review remain separate."
    )


if __name__ == "__main__":
    main()
