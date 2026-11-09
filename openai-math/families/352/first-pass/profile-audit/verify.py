#!/usr/bin/env python3
"""Independent exact certificate for the Calabi shrinking-profile construction.

No manuscript program is imported or executed. Run without -O or -OO.
The numerical certificate is paired with the analytic proof in report.md.
"""

import argparse
import json
import sys
from fractions import Fraction as F
from math import comb
from pathlib import Path


GRID = 2**256
ZERO = (0, 0)
ONE = (GRID, GRID)
B = F(751, 4)
C = -F(1215, 4)
RADIUS = F(5, 10**10)
K0 = F("-0.094617116666041")
D0 = F("0.400682721856639")
PARAMETER = [[F(25190, 10**8), F(-63731, 10**8)],
             [F(721855, 10**8), F(359157, 10**8)]]
LAMBDA = [[F(x, 10**5) for x in row] for row in
          [[30756, -27384, 33447], [34622, 13692, -16724],
           [-2925, -34040, -28850]]]
HERE = Path(__file__).resolve().parent


def ceil_div(a, b):
    assert b > 0
    return -((-a) // b)


def interval(x, upper=None):
    x = F(x)
    y = x if upper is None else F(upper)
    assert x <= y
    return (x.numerator * GRID // x.denominator,
            ceil_div(y.numerator * GRID, y.denominator))


def add(x, y):
    return x[0] + y[0], x[1] + y[1]


def neg(x):
    return -x[1], -x[0]


def sub(x, y):
    return add(x, neg(y))


def total(values):
    lo = hi = 0
    for a, b in values:
        lo += a
        hi += b
    return lo, hi


def scale(x, numerator, denominator=1):
    assert denominator > 0
    a, b = (x[0], x[1]) if numerator >= 0 else (x[1], x[0])
    return a * numerator // denominator, ceil_div(b * numerator, denominator)


def mul(x, y):
    products = (x[0] * y[0], x[0] * y[1],
                x[1] * y[0], x[1] * y[1])
    return min(products) // GRID, ceil_div(max(products), GRID)


def reciprocal(x):
    assert x[0] * x[1] > 0, "reciprocal interval contains zero"
    return GRID**2 // x[1], -((-GRID**2) // x[0])


def quotient(x, y):
    return mul(x, reciprocal(y))


def power(x, n):
    assert n >= 0
    answer = ONE
    for _ in range(n):
        answer = mul(answer, x)
    return answer


def magnitude(x):
    return max(abs(x[0]), abs(x[1]))


def midpoint(x):
    value = (x[0] + x[1]) // 2
    return value, value


def widen(x, allowance):
    return x[0] - allowance, x[1] + allowance


def inside(x, lower, upper):
    return F(lower) < F(x[0], GRID) <= F(x[1], GRID) < F(upper)


def dual_mul(x, y):
    return [mul(x[0], y[0])] + [
        add(mul(x[0], b), mul(a, y[0])) for a, b in zip(x[1:], y[1:])]


def inverse_coefficient(series, inverse):
    n = len(inverse)
    if n == 0:
        base = reciprocal(series[0][0])
        square = mul(base, base)
        answer = [base] + [neg(mul(square, v)) for v in series[0][1:]]
    else:
        products = [dual_mul(series[i], inverse[n-i]) for i in range(1, n+1)]
        convolution = [total(column) for column in zip(*products)]
        answer = [neg(v) for v in dual_mul(inverse[0], convolution)]
    inverse.append(answer)
    return answer


def matrix_product(left, right):
    columns = list(zip(*right))
    return [[total(mul(a, b) for a, b in zip(row, column))
             for column in columns] for row in left]


def matrix_norm(matrix):
    return max(sum(magnitude(v) for v in row) for row in matrix)


def identity(n):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def rational_left_product(left, right):
    return [[total(scale(v, a.numerator, a.denominator)
                   for a, v in zip(row, column))
             for column in zip(*right)] for row in left]


def origin():
    series = [[interval(1 + D0)] + [interval(v) for v in PARAMETER[1]],
              [interval(K0)] + [interval(v) for v in PARAMETER[0]]]
    inverse = []
    for n in range(59):
        coefficient = inverse_coefficient(series, inverse)
        coefficient = coefficient.copy()
        if n == 0:
            coefficient[0] = sub(coefficient[0], ONE)
        denominator = 27 * (n+1) * (n+11) * (n+12)
        series.append([scale(v, 8, denominator) for v in coefficient])
    jets = []
    for order in range(3):
        weights = [F(1) if order == 0 else F(3*i, 2) if order == 1
                   else F(3*i*(3*i-2), 4) for i in range(61)]
        row = [total(scale(series[i][j], w.numerator, w.denominator)
                     for i, w in enumerate(weights)) for j in range(3)]
        if order == 0:
            row[0] = sub(row[0], ONE)
        jets.append(row)
    width = max(v[1] - v[0] for row in jets for v in row)
    assert width * 10**20 < GRID, "origin enclosure too wide"
    central = [midpoint(row[0]) for row in jets]
    tangent = [[midpoint(v) for v in row[1:]] for row in jets]
    tangent.append([interval(v) for v in PARAMETER[1]])
    assert 50 * matrix_norm(tangent) < GRID
    return central, tangent, width


def horner(coefficients):
    result = ZERO
    for coefficient in reversed(coefficients):
        result = add(coefficient, scale(result, 1, 8))
    return result


def taylor_step(state, tangent, r8, h, stats):
    assert inside(state[0], "-.76", ".4")
    assert magnitude(state[1]) * 100 < 6 * GRID
    assert magnitude(state[2]) * 100 < GRID
    assert max(magnitude(v) for row in tangent for v in row) < 6 * GRID
    stats["step_starts_checked"] += 1
    stats["largest_scaled_tangent"] = max(
        stats["largest_scaled_tangent"],
        max(magnitude(v) for row in tangent for v in row))
    series = [[add(state[0], ONE)] + tangent[0],
              [state[1]] + tangent[1],
              [scale(v, 1, 2) for v in [state[2]] + tangent[2]]]
    inverse = []
    constant = [interval(1 + D0), ZERO, ZERO, ZERO, ONE]
    r3 = [comb(3, a) * r8**(3-a) * 8**a for a in range(4)]
    r2 = [8 * comb(2, a) * r8**(2-a) * 8**a for a in range(3)]
    r1 = [64 * r8, 512]
    for n in range(44):
        inverse_coefficient(series, inverse)
        row = []
        for column in range(5):
            forcing = []
            for a in range(min(3, n) + 1):
                value = inverse[n-a][column]
                if column == 0 and n == a:
                    value = sub(value, ONE)
                forcing.append(scale(value, 4 * r3[a]))
            terms = [scale(total(forcing), 1, h**3)]
            for a in range(1, min(3, n) + 1):
                k = n-a+3
                terms.append(scale(series[k][column],
                                   -4 * r3[a] * k * (k-1) * (k-2)))
            for a in range(min(2, n) + 1):
                k = n-a+2
                terms.append(scale(series[k][column], -120 * r2[a] * k * (k-1)))
            for a in range(min(1, n) + 1):
                k = n-a+1
                terms.append(scale(series[k][column], -751 * r1[a] * k))
            terms.append(scale(series[n][column], 1215 * 512))
            if n == 0:
                terms.append(scale(constant[column], -1215 * 512))
            row.append(scale(total(terms), 1, 4 * r3[0] * (n+1) * (n+2) * (n+3)))
        series.append(row)
    series[0][0] = sub(series[0][0], ONE)
    allowance = interval(F(48, 4**45))[1]
    jets = []
    for order in range(3):
        row = []
        for column in range(5):
            coefficients = []
            for i in range(order, 47):
                weight = 1 if order == 0 else i if order == 1 else i * (i-1)
                coefficients.append(scale(series[i][column], weight))
            row.append(widen(horner(coefficients), allowance))
        jets.append(row)
    return [row[0] for row in jets], [row[1:] for row in jets]


def finite_integration():
    central, initial_tangent, origin_width = origin()
    stats = {"step_starts_checked": 0, "largest_scaled_tangent": 0,
             "largest_state_width": 0, "largest_transfer_width": 0}
    schedule = [32] * 32 + [16] * 32 + [8] * 32 + [4] * 192
    matrices, minima = [], []
    s32 = 32
    for h in schedule:
        state = [scale(v, 1, h**i) for i, v in enumerate(central)]
        tangent = identity(4)[:3]
        assert s32 * h % 4 == 0
        r8 = s32 * h // 4
        minimum = 2 * GRID
        for substep in range(8):
            minimum = min(minimum, state[0][0] + GRID - (GRID // 100 + 1))
            state, tangent = taylor_step(state, tangent, r8 + substep, h, stats)
        physical = [scale(v, h**i) for i, v in enumerate(state)]
        state_width = max(v[1] - v[0] for v in physical)
        assert state_width * 10**19 < GRID, "physical state width exceeded"
        central = [midpoint(v) for v in physical]
        transfer = [[scale(v, h**i, h**j if j < 3 else 1)
                     for j, v in enumerate(row)] for i, row in enumerate(tangent)]
        transfer.append([ZERO, ZERO, ZERO, ONE])
        transfer_width = max(v[1] - v[0] for row in transfer for v in row)
        assert transfer_width * 10**15 < GRID, "physical transfer width exceeded"
        matrices.append([[midpoint(v) for v in row] for row in transfer])
        minima.append((h, minimum))
        stats["largest_state_width"] = max(stats["largest_state_width"], state_width)
        stats["largest_transfer_width"] = max(
            stats["largest_transfer_width"], transfer_width)
        s32 += 32 // h
    assert s32 == 56 * 32 and len(matrices) == 288
    assert stats["step_starts_checked"] == 2304
    return central, initial_tangent, matrices, minima, origin_width, stats


def tail_polynomial(d):
    a = C * d
    b = a*a + 567*a
    c = 2*a*b - a**3 + F(2025, 4)*b
    e = b*b + 2*a*c - 3*a*a*b + a**4 + F(567, 2)*c
    return [a, b, c, e]


def product_certificate(central, initial_tangent, matrices, minima):
    maximum_product = maximum_sum = maximum_weighted = maximum_linear = 0
    for endpoint in range(1, 289):
        product = identity(4)
        accumulated = weighted = 0
        for j in range(endpoint-1, -1, -1):
            h, minimum = minima[j]
            assert 100 * minimum > 23 * GRID
            leading = matrix_norm([row[:3] for row in product[:3]])
            accumulated += leading
            weighted += ceil_div(leading * GRID**2, h * minimum**3)
            product = matrix_product(product, matrices[j])
            product_size = matrix_norm(product)
            assert product_size <= 8500 * GRID
            maximum_product = max(maximum_product, product_size)
        linear = matrix_product(product, initial_tangent)
        assert 10 * matrix_norm(linear) <= 27 * GRID
        assert accumulated <= 570000 * GRID and weighted <= 246000
        maximum_sum = max(maximum_sum, accumulated)
        maximum_weighted = max(maximum_weighted, weighted)
        maximum_linear = max(maximum_linear, matrix_norm(linear))
    coefficients = tail_polynomial(D0)
    tail_jet = [sum(a * (1 if order == 0 else -3*j if order == 1
                        else 3*j*(3*j+1)) / 56**(3*j+order)
                    for j, a in enumerate(coefficients, 1)) for order in range(3)]
    offset = [[sub(v, interval(a))] for v, a in zip(central, tail_jet)]
    projected = rational_left_product(LAMBDA, offset)
    assert F(matrix_norm(offset), GRID) < F(".04") * RADIUS
    assert F(matrix_norm(projected), GRID) < F(".006") * RADIUS
    endpoint_linear = rational_left_product(LAMBDA, linear[:3])
    real_linear = matrix_norm(endpoint_linear[:1])
    nonreal_error = matrix_norm([
        [sub(v, ONE if i == j else ZERO) for j, v in enumerate(row)]
        for i, row in enumerate(endpoint_linear[1:])])
    assert 1000 * real_linear < 116 * GRID
    assert 1000 * nonreal_error < GRID
    return {
        "blocks": 288, "substeps": 2304, "endpoint": 56,
        "minimum_reference_1_plus_p": str(F(min(v for _, v in minima), GRID)),
        "maximum_rounded_product_norm": str(F(maximum_product, GRID)),
        "maximum_leading_product_sum": str(F(maximum_sum, GRID)),
        "maximum_weighted_leading_product_sum_upper_integer": maximum_weighted,
        "maximum_linear_parameter_norm": str(F(maximum_linear, GRID)),
        "central_offset_in_R": str(F(matrix_norm(offset), GRID) / RADIUS),
        "projected_central_offset_in_R": str(F(matrix_norm(projected), GRID) / RADIUS),
        "real_linear_row_norm": str(F(real_linear, GRID)),
        "nonreal_linear_minus_identity_norm": str(F(nonreal_error, GRID)),
    }


def exp_upper(x):
    x = F(x)
    term = value = F(1)
    for i in range(1, 81):
        term *= x / i
        value += term
    assert 0 <= x < 82
    return value + term * x / 81 / (1 - x / 82)


def analytic_allowances():
    assert 3*(abs(K0)+F(".1")) < F(".585")
    assert 1+D0-F(".1") > F("1.30")
    assert F(27, 8)*11*12 > 440
    assert F(27, 440) < F(".2")
    assert F(36, 440) < 1
    assert 3*(abs(K0)+F(".1")) + F(27, 440) < F(".8")
    assert F(".8") / 3 + D0 + F(".1") < 2
    origin_tail = F(".8") * F(3*61, 2)**2 / 3**61
    assert origin_tail < F("5.267e-26")
    t = F(".11") * RADIUS
    parameter_tail = 2*((1-t)**-2 - 1 - 2*t)
    assert parameter_tail < F("1.816e-20")
    parameter_sum = sum(abs(v) for row in PARAMETER for v in row)
    assert parameter_sum == F(".01169933")
    assert 10*parameter_sum < F(".12")
    assert max(sum(abs(v) for v in row) for row in PARAMETER) < F(".011")
    origin_error = (F("5e-21") + origin_tail + parameter_tail
                    + F(".12")*origin_tail*RADIUS + F("1e-20")*RADIUS + F(3, GRID))
    assert origin_error < F("2.316e-20") < F("2e-19")
    e = exp_upper(F(".477"))
    base = F(".01") + (F(".190")*F(".06") + F(".011")*F("1.3")
                       + F(".015625")*F(".86")/F(".14"))/2
    assert e*F(".190")/4 < 1
    h2 = e*base/(1-e*F(".190")/4)
    assert h2 < F(".123602") < F(".13")
    assert F(".06")/2 + F(".13")/8 == F(".04625") < F(".1")
    assert F(".06")/8 + F(".13")/128 == F(".008515625") < F(".01")
    complex_norm = (F(30)/F("31.5") + B/F("31.5")**2
                    + 2*abs(C)/F("31.5")**3 + F(1, 64)/F(".14")**2)
    assert complex_norm < F("2.1")
    assert 6*exp_upper(F("1.05")) < F("17.146") < 32
    assert F(32, 1)*F(1, 4)**45/(1-F(1, 4)) < F(48, 4**45)
    real_norm = F(30, 32)+B/32**2+2*abs(C)/32**3+F(1, 64)/F(".23")**2
    assert real_norm > 1 and exp_upper(real_norm) < F("4.3")
    product_error = 8500*((1+F("4e-15")*8500)**288-1)
    assert product_error < F(".001")
    assert 570000 + 288*F(".001") < 580000
    assert 246000 + 55*F(".001")/F(".23")**3 < 250000
    assert F(".23")/(F(".23")-14*RADIUS) < F("1.001")
    assert F("2.7") + F(".001")*F(".02") < F("2.72")
    endpoint = (580000*F("1e-19")+8501*F("2e-19")
                +F("4.3")*250000*F("1.001")*(14*RADIUS)**2)/RADIUS
    interior = F("4.3")*(F("2.72")+F(".11")) + (
        F("4.3")*F("1.001")*(14*RADIUS)**2/F(".23")**3)/RADIUS
    assert endpoint == F(".1055747504") < F(".11")
    assert interior < F("12.169035") < 14
    real_projection = (F(".006")+F(".003")*F(".04")+F(".116")
                       +F(".003")*F("2.7")
                       +F(".92")*(F(".11")+F(".001")*F(".02")+F(".01")*F(".011")))
    nonreal_projection = (F(".006")+F(".003")*F(".04")+F(".001")
                          +F(".003")*F("2.7")
                          +F(".68")*(F(".11")+F(".001")*F(".02")+F(".01")*F(".011")))
    assert real_projection == F(".2315396") < F(".25")
    assert nonreal_projection == F(".0901084") < F(".13")
    return {
        "origin_tail_upper": str(origin_tail),
        "parameter_tail_upper": str(parameter_tail),
        "origin_error_upper": str(origin_error),
        "complex_disk_radius": "1/2",
        "complex_second_derivative_upper": "123602/1000000",
        "complex_variation_upper": "8573/500",
        "step_tail_allowance": str(F(48, 4**45)),
        "physical_partial_transfer_upper": "43/10",
        "all_product_error_upper": "1/1000",
        "uniform_endpoint_error_in_R_upper": str(endpoint),
        "uniform_interior_error_in_R_upper": str(interior),
        "real_projection_in_R_upper": str(real_projection),
        "nonreal_projection_in_R_upper": str(nonreal_projection),
    }


def polynomial_add(x, y):
    return [(x[i] if i < len(x) else F(0)) + (y[i] if i < len(y) else F(0))
            for i in range(max(len(x), len(y)))]


def polynomial_scale(x, a):
    return [a*v for v in x]


def polynomial_mul(x, y):
    result = [F(0)] * (len(x)+len(y)-1)
    for i, a in enumerate(x):
        for j, b in enumerate(y):
            result[i+j] += a*b
    return result


def linear_symbol(v):
    return v*(v-1)*(v-2)+30*v*(v-1)+B*v+C


def check_symbolic_cancellations():
    a = [F(0), C]
    a2 = polynomial_mul(a, a)
    b = polynomial_add(a2, polynomial_scale(a, 567))
    c = polynomial_add(polynomial_add(polynomial_scale(polynomial_mul(a, b), 2),
                                      polynomial_scale(polynomial_mul(a2, a), -1)),
                       polynomial_scale(b, F(2025, 4)))
    e = polynomial_add(
        polynomial_add(polynomial_mul(b, b), polynomial_scale(polynomial_mul(a, c), 2)),
        polynomial_add(polynomial_scale(polynomial_mul(a2, b), -3),
                       polynomial_add(polynomial_mul(a2, a2),
                                      polynomial_scale(c, F(567, 2)))))
    coefficients = [[F(0)], a, b, c, e]
    inverse = [[F(1)]]
    for n in range(1, 5):
        convolution = [F(0)]
        for i in range(1, n+1):
            convolution = polynomial_add(
                convolution, polynomial_mul(coefficients[i], inverse[n-i]))
        inverse.append(polynomial_scale(convolution, -1))
        residual = polynomial_scale(inverse[n], -1)
        residual = polynomial_add(residual, polynomial_scale(
            [F(0), F(1)] if n == 1 else coefficients[n-1],
            -C if n == 1 else linear_symbol(-3*(n-1))))
        assert all(v == 0 for v in residual), "tail cancellation failed as a polynomial in d"
    assert [linear_symbol(-3*j) for j in range(1, 5)] == [
        F(-567), F(-2025, 4), F(-567, 2), F(-243, 4)]
    # Equality of cubic polynomials is checked by their monomial coefficients.
    q = polynomial_mul(polynomial_mul([F(-1), F(2, 3)],
                                      [F(9), F(2, 3)]), [F(10), F(2, 3)])
    assert polynomial_scale(q, F(27, 8)) == [C, B-28, F(27), F(1)]
    return True


def tail_and_roots():
    alpha, beta, h0 = F(15, 56), B/(2*56**2), 1+C/(2*56**3)
    cubic = lambda x: x**3+alpha*x**2+beta*x+h0
    assert alpha**2-3*beta == F(-453, 25088) < 0
    assert cubic(-F("1.08659")) < 0 < cubic(-F("1.08655"))
    r = interval("1.08655", "1.08659")
    u = scale(sub(r, interval(alpha)), 1, 2)
    assert inside(u, ".40933", ".40938")
    rho2 = quotient(interval(h0), r)
    v2 = sub(rho2, mul(u, u))
    assert inside(v2, F(".8671")**2, F(".86721")**2)
    assert F(rho2[1], GRID) < F(".959")**2
    v = interval(".8671", ".86721")
    energy = add(power(add(r, u), 2), v2)
    assert F(energy[0], GRID) > F("2.9895") > F("1.729")**2
    denominator = scale(mul(v, energy), 2)
    rows = [
        [quotient(rho2, energy), quotient(scale(u, -2), energy),
         reciprocal(energy)],
        [quotient(mul(r, add(r, scale(u, 2))), scale(energy, 2)),
         quotient(u, energy), scale(reciprocal(energy), -1, 2)],
        [quotient(mul(r, sub(mul(u, add(r, u)), v2)), denominator),
         quotient(neg(sub(add(v2, mul(r, r)), mul(u, u))), denominator),
         quotient(neg(add(r, u)), denominator)],
    ]
    for row, approximation, limit in zip(rows, LAMBDA, [F(".92"), F(".68"), F(".68")]):
        assert F(sum(magnitude(x) for x in row), GRID) < limit
        assert all(F(magnitude(sub(x, interval(a))), GRID) < F(".001")
                   for x, a in zip(row, approximation))
    convolution = [F("1.08659")**i/(F("1.08655")*F("2.9895"))
                   + F(".959")**i/(F(".40933")*F(".8671")*F("1.729"))
                   for i in range(3)]
    assert all(x < bound for x, bound in zip(convolution, map(F, ["1.96", "1.92", "1.88"])))
    xi_response = 1/(2*F(".40933")*F(".8671")*F("1.729"))
    assert xi_response < F(".82")
    d_shift = sum(abs(v) for v in PARAMETER[1])*RADIUS
    assert F(".40068272185") < D0-d_shift < D0+d_shift < F(".40068272187")
    a = [scale(interval(".40068272185", ".40068272187"), C.numerator, C.denominator),
         interval(C)]
    dadd = lambda x, y: [add(v, w) for v, w in zip(x, y)]
    dscale = lambda x, f: [scale(v, F(f).numerator, F(f).denominator) for v in x]
    a2 = dual_mul(a, a)
    b = dadd(a2, dscale(a, 567))
    c = dadd(dadd(dscale(dual_mul(a, b), 2), dscale(dual_mul(a2, a), -1)),
             dscale(b, F(2025, 4)))
    e = dadd(dadd(dual_mul(b, b), dscale(dual_mul(a, c), 2)),
             dadd(dscale(dual_mul(a2, b), -3),
                  dadd(dual_mul(a2, a2), dscale(c, F(567, 2)))))
    bounds = [122, 54200, 12500000, 5100000000]
    derivative_bounds = [304, 100000, 65000000, 100000000000]
    for coefficient, bound, derivative in zip([a, b, c, e], bounds, derivative_bounds):
        assert F(magnitude(coefficient[0]), GRID) < bound
        assert F(magnitude(coefficient[1]), GRID) < derivative
    terms = list(map(F, [".00070", ".0000018", ".0000000081", ".000000000032"]))
    assert all(F(bound, 56**(3*j)) < term
               for j, (bound, term) in enumerate(zip(bounds, terms), 1))
    t1, t2, t3, t4 = terms
    t = sum(terms)
    tails = [t*t-t1*t1-2*t1*t2-2*t1*t3-t2*t2,
             t**3-t1**3-3*t1*t1*t2, t**4-t1**4]
    assert all(0 < x < bound for x, bound in zip(tails, map(F, ["8e-14", "2e-14", "3e-15"])))
    residual = sum(tails)+F(".001")**5/(1-F(".001"))+F(243, 4)*t4/56**3
    assert residual < F("3e-13")
    derivatives = []
    for order in range(4):
        value = F(0)
        for j, bound in enumerate(derivative_bounds, 1):
            factor = 1
            for k in range(order):
                factor *= 3*j+k
            value += F(bound*factor, 56**(3*j+order))
        derivatives.append(value)
    assert derivatives[0] < F(".001735") < F(".01")
    residual_d = (derivatives[3]+F(30, 56)*derivatives[2]
                  +B/56**2*derivatives[1]+abs(C)/56**3*(1+derivatives[0])
                  +derivatives[0]/(1-F(".001"))**2)
    assert residual_d < F(".004")
    assert F(".001")*(2+F(".001"))/(1-F(".001"))**2 < F(".0021")
    lip = alpha*F("1.88")+beta*F("1.92")+(abs(C)/(2*56**3)+F(".0021"))*F("1.96")
    stable = alpha*F("1.08659")**2+beta*F("1.08659")+abs(C)/(2*56**3)+F(".0021")
    assert lip < F(".57") and stable < F(".36")
    assert t+(F(".26")+F("1.96")*F(".3"))*RADIUS < F(".001")
    assert F("3e-13")/RADIUS+F(".36")*F(".26")+F(".57")*F(".3") == F(".2652") < F(".3")
    assert F(".82")*F(".3") == F(".246") < F(".25")
    return {
        "convolution_upper": [str(x) for x in convolution],
        "nonreal_response_upper": str(xi_response),
        "tail_residual_upper": str(residual),
        "tail_polynomial_parameter_derivative_upper": str(derivatives[0]),
        "tail_residual_parameter_derivative_upper": str(residual_d),
        "tail_contraction_upper": str(lip),
        "tail_stable_coefficient_upper": str(stable),
        "tail_source_ball_in_R": "3/10",
        "tail_nonreal_coordinate_in_R_upper": "123/500",
    }


def contraction_matching():
    t = F(".11")*RADIUS
    origin_lipschitz = F(".44")*((1-t)**-3-1)
    origin_lipschitz += F(".12")*F(".8")*F(3*61, 2)**2/3**61 + F("1e-20") + F(3, GRID)
    assert origin_lipschitz < F("1e-9")
    ratio = 14*RADIUS/F(".23")
    assert (2+ratio)/(1-ratio)**2 < F("2.01")
    nonlinear_difference_coefficient = F("2.01")*14*RADIUS
    endpoint_error = 8501*F("1e-9")+F("4.3")*250000*nonlinear_difference_coefficient*13
    interior = F("4.3")*(F("2.72")+endpoint_error)
    interior += F("4.3")*nonlinear_difference_coefficient*13/F(".23")**3
    assert endpoint_error < F(".197") and interior < 13
    common = F(".197")+F(".001")*F(".02")+F(".01")*F(".011")
    real_lip = F(".116")+F(".003")*F("2.7")+F(".92")*common
    nonreal_lip = F(".001")+F(".003")*F("2.7")+F(".68")*common
    assert real_lip < F(".31") and nonreal_lip < F(".15")
    assert 2/(1-F(".001"))**3 < F("2.01")
    assert F(".004")+F("2.01")*F(".848")*RADIUS*F(".001735") < F(".005")
    tail_lip = F(".82")*(F(".36")*F(".31")+F(".005")*F(".011"))/(1-F(".57"))
    matching = F(".15")+tail_lip
    assert matching < F(".37") < 1
    assert F(".13")+F(".25") == F(".38") < 1
    return {
        "origin_nonlinear_remainder_lipschitz_upper": str(origin_lipschitz),
        "two_shot_interior_lipschitz_upper": str(interior),
        "two_shot_endpoint_linearization_error_upper": str(endpoint_error),
        "real_shot_lipschitz_upper": str(real_lip),
        "nonreal_shot_minus_identity_lipschitz_upper": str(nonreal_lip),
        "tail_coordinate_composite_lipschitz_upper": str(tail_lip),
        "matching_map_lipschitz_upper": str(matching),
        "matching_self_map_radius_in_R_upper": "19/50",
        "uniqueness_scope": "specified shooting square and constructed source ball ||j||<=0.3R",
    }


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    retained = json.loads((HERE / "jacobian_result.json").read_text())
    assert retained["server"]["version"] == "0.14.0"
    assert retained["protocol_version"] == "2025-11-25"
    assert retained["request"]["operation_id"] == "polynomial.box.enclosure.compute"
    assert retained["request"]["payload"] == payload
    output = retained["result"]["output"]
    assert output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"]
    assert payload["polynomial"]["variables"] == payload["box"]["variables"] == ["x"]
    rational = lambda x: F(int(x["num"]), int(x["den"]))
    terms = [(rational(term["coefficient"]), term["exponents"])
             for term in payload["polynomial"]["polynomial"]["terms"]]
    assert terms == [(F(-9979, 10000), [2]), (F(-10021, 5000), [1]),
                     (F(21, 10000), [0])]
    axis = payload["box"]["intervals"]
    assert len(axis) == 1
    left, right = rational(axis[0]["lower"]), rational(axis[0]["upper"])
    assert (left, right) == (F(0), F(1, 1000))
    lower = upper = F(0)
    for coefficient, (exponent,) in terms:
        endpoints = [coefficient*left**exponent, coefficient*right**exponent]
        lower += min(endpoints)
        upper += max(endpoints)
    assert lower == F(948021, 10**10) > 0
    enclosure = output["enclosure"]
    for endpoint, value in [("lower", lower), ("upper", upper)]:
        assert rational(enclosure[endpoint]) == value
    return {
        "operation": "polynomial.box.enclosure.compute",
        "server_version": "0.14.0", "protocol": "2025-11-25",
        "adapter_exit": 0, "adapter_error": None, "timeout": False,
        "independently_replayed_lower": str(lower),
        "meaning": "uniform |Nprime(p)|<0.0021 for real |p|<=0.001, not an ODE certificate",
    }


def main():
    if not __debug__ or sys.flags.optimize:
        raise SystemExit("Assertions must be enabled; do not use -O or -OO.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    allowances = analytic_allowances()
    assert check_symbolic_cancellations()
    tail = tail_and_roots()
    matching = contraction_matching()
    jacobian = replay_jacobian()
    print("Analytic allowances, symbolic cancellations, tail and matching bounds: exact checks passed.", flush=True)
    central, tangent, matrices, minima, origin_width, stats = finite_integration()
    print("Independent Taylor integration: 288 blocks and 2304 complex-disk enclosures passed.", flush=True)
    finite = product_certificate(central, tangent, matrices, minima)
    certificate = {
        "result_class": "new_theorem",
        "claim": "C_PROFILE_UNIQUE",
        "method": "integer outward-rounded intervals; exact rational inequalities; analytic proof in report.md",
        "assertions_enabled": True, "floating_point_used": False,
        "manuscript_programs_imported_or_executed": False,
        "parameter_radius": str(RADIUS),
        "parameters": {"center": [str(K0), str(D0)],
                       "linear_map": [[str(v) for v in row] for row in PARAMETER]},
        "symbolic_cancellations": "identities over QQ[d], not parameter samples",
        "origin_maximum_computed_interval_width": str(F(origin_width, GRID)),
        "finite": finite,
        "integration": {key: value if key == "step_starts_checked" else str(F(value, GRID))
                        for key, value in stats.items()},
        "allowances": allowances, "tail": tail, "matching": matching, "jacobian": jacobian,
        "proof_boundary": {
            "exact_machine_checks": "finite arithmetic, every reference block and tangent, and explicit analytic constants",
            "prose_proof": "analytic interpretation, infinite-dimensional contractions, uniform continuation and all-order asymptotics",
            "independent_review": "required; this file does not record reviewer approval",
            "lean_formalization": "not claimed",
            "compact_calabi_flow_theorem": "not established here",
        },
    }
    destination = HERE / "exact_certificate.json"
    if args.write_certificate:
        destination.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        assert certificate == json.loads(destination.read_text()), "certificate differs from exact replay"
    print("PASS C_PROFILE_UNIQUE: full-square bounds, positive global profile, and matching Lipschitz < 0.37.", flush=True)


if __name__ == "__main__":
    main()
