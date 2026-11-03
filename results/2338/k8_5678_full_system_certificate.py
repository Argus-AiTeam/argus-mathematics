#!/usr/bin/env python3
from __future__ import annotations

import json
import math
from fractions import Fraction
from functools import reduce
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESEARCH = ROOT / "research"
OUTPUT = RESEARCH / "k8_5678_full_system_classification.json"
JACOBIAN = RESEARCH / "jacobian/k8_5678_full_system"


def trim(poly: list[int | Fraction]) -> list[int | Fraction]:
    out = poly[:]
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out


def poly_add(
    left: list[int | Fraction], right: list[int | Fraction]
) -> list[Fraction]:
    out = [Fraction(0)] * max(len(left), len(right))
    for index, value in enumerate(left):
        out[index] += value
    for index, value in enumerate(right):
        out[index] += value
    return trim(out)


def poly_mul(
    left: list[int | Fraction], right: list[int | Fraction]
) -> list[Fraction]:
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] += a * b
    return trim(out)


def poly_scale(
    poly: list[int | Fraction], scale: int | Fraction
) -> list[Fraction]:
    return trim([Fraction(scale) * value for value in poly])


def linear_substitute(
    poly: list[int | Fraction], scale: int | Fraction, shift: int | Fraction
) -> list[Fraction]:
    result: list[Fraction] = [Fraction(0)]
    power: list[Fraction] = [Fraction(1)]
    linear = [Fraction(shift), Fraction(scale)]
    for coefficient in poly:
        result = poly_add(result, poly_scale(power, coefficient))
        power = poly_mul(power, linear)
    return trim(result)


def derivative(poly: list[int | Fraction]) -> list[Fraction]:
    if len(poly) <= 1:
        return [Fraction(0)]
    return trim(
        [Fraction(index) * poly[index] for index in range(1, len(poly))]
    )


def falling(length: int) -> list[int]:
    out: list[int | Fraction] = [1]
    for offset in range(length):
        out = poly_mul(out, [-offset, 1])
    assert all(value.denominator == 1 for value in out)
    return [int(value) for value in out]


def evaluate(poly: list[int | Fraction], value: int | Fraction) -> Fraction:
    out = Fraction(0)
    for coefficient in reversed(poly):
        out = out * value + coefficient
    return out


def bareiss_determinant(matrix: list[list[int]]) -> int:
    work = [row[:] for row in matrix]
    size = len(work)
    if size == 0:
        return 1
    sign = 1
    previous = 1
    for pivot_index in range(size - 1):
        if work[pivot_index][pivot_index] == 0:
            swap = next(
                (
                    row
                    for row in range(pivot_index + 1, size)
                    if work[row][pivot_index] != 0
                ),
                None,
            )
            if swap is None:
                return 0
            work[pivot_index], work[swap] = (
                work[swap],
                work[pivot_index],
            )
            sign = -sign
        pivot = work[pivot_index][pivot_index]
        for row in range(pivot_index + 1, size):
            for column in range(pivot_index + 1, size):
                numerator = (
                    work[row][column] * pivot
                    - work[row][pivot_index] * work[pivot_index][column]
                )
                assert numerator % previous == 0
                work[row][column] = numerator // previous
        previous = pivot
        for row in range(pivot_index + 1, size):
            work[row][pivot_index] = 0
    return sign * work[-1][-1]


def resultant(left: list[int], right: list[int]) -> int:
    left = [int(value) for value in trim(left)]
    right = [int(value) for value in trim(right)]
    left_degree = len(left) - 1
    right_degree = len(right) - 1
    size = left_degree + right_degree
    left_descending = list(reversed(left))
    right_descending = list(reversed(right))
    matrix: list[list[int]] = []
    for shift in range(right_degree):
        matrix.append(
            [0] * shift
            + left_descending
            + [0] * (size - shift - len(left_descending))
        )
    for shift in range(left_degree):
        matrix.append(
            [0] * shift
            + right_descending
            + [0] * (size - shift - len(right_descending))
        )
    return bareiss_determinant(matrix)


def interpolate(values: list[int]) -> list[Fraction]:
    result: list[Fraction] = [Fraction(0)]
    for index, value in enumerate(values):
        basis: list[Fraction] = [Fraction(1)]
        denominator = Fraction(1)
        for other in range(len(values)):
            if index == other:
                continue
            basis = poly_mul(basis, [-other, 1])
            denominator *= index - other
        result = poly_add(
            result, poly_scale(basis, Fraction(value, 1) / denominator)
        )
    return trim(result)


def critical_resultant(length: int, multiplier: int) -> list[int]:
    polynomial = falling(length)
    derivative_polynomial = [
        int(value) for value in derivative(polynomial)
    ]
    values = []
    for parameter in range(length):
        specialized = polynomial[:]
        specialized[0] -= multiplier * parameter
        values.append(resultant(specialized, derivative_polynomial))
    interpolated = interpolate(values)
    assert all(value.denominator == 1 for value in interpolated)
    return [int(value) for value in interpolated]


def qpoly_divmod(
    numerator: list[int | Fraction], denominator: list[int | Fraction]
) -> tuple[list[Fraction], list[Fraction]]:
    numerator = [Fraction(value) for value in trim(numerator)]
    denominator = [Fraction(value) for value in trim(denominator)]
    quotient = [Fraction(0)] * max(
        1, len(numerator) - len(denominator) + 1
    )
    while len(numerator) >= len(denominator) and numerator != [0]:
        degree = len(numerator) - len(denominator)
        coefficient = numerator[-1] / denominator[-1]
        quotient[degree] = coefficient
        for index, value in enumerate(denominator):
            numerator[degree + index] -= coefficient * value
        numerator = trim(numerator)
    return trim(quotient), trim(numerator)


def qpoly_gcd(
    left: list[int | Fraction], right: list[int | Fraction]
) -> list[Fraction]:
    a = [Fraction(value) for value in trim(left)]
    b = [Fraction(value) for value in trim(right)]
    while b != [0]:
        _, remainder = qpoly_divmod(a, b)
        a, b = b, remainder
    return poly_scale(a, 1 / a[-1])


def primitive(poly: list[int | Fraction]) -> list[int]:
    fractions = [Fraction(value) for value in trim(poly)]
    common_denominator = math.lcm(
        *(value.denominator for value in fractions)
    )
    integers = [
        int(value * common_denominator) for value in fractions
    ]
    common_content = reduce(math.gcd, (abs(value) for value in integers))
    integers = [value // common_content for value in integers]
    if integers[-1] < 0:
        integers = [-value for value in integers]
    return integers


def squarefree_support(poly: list[int]) -> list[int]:
    repeated = qpoly_gcd(poly, derivative(poly))
    quotient, remainder = qpoly_divmod(poly, repeated)
    assert remainder == [0]
    return primitive(quotient)


def row_gap_polynomial(short: int, long: int) -> list[int]:
    out: list[int | Fraction] = [1]
    for offset_difference in range(-(long - 1), short):
        out = poly_mul(out, [-offset_difference, 1])
    assert all(value.denominator == 1 for value in out)
    return [int(value) for value in out]


def positive_divisors(value: int) -> list[int]:
    lower = []
    upper = []
    divisor = 1
    while divisor * divisor <= value:
        if value % divisor == 0:
            lower.append(divisor)
            if divisor * divisor != value:
                upper.append(value // divisor)
        divisor += 1
    return lower + list(reversed(upper))


def integer_evaluate(poly: list[int], value: int) -> int:
    out = 0
    for coefficient in reversed(poly):
        out = out * value + coefficient
    return out


def integer_translate(poly: list[int], shift: int) -> list[int]:
    out = [0] * len(poly)
    for source_degree, coefficient in enumerate(poly):
        for target_degree in range(source_degree + 1):
            out[target_degree] += (
                coefficient
                * math.comb(source_degree, target_degree)
                * shift ** (source_degree - target_degree)
            )
    return [int(value) for value in trim(out)]


def sign_variations(poly: list[int]) -> int:
    signs = [
        1 if coefficient > 0 else -1
        for coefficient in reversed(poly)
        if coefficient != 0
    ]
    return sum(left != right for left, right in zip(signs, signs[1:]))


def binomial_row(value: int, length: int) -> int | None:
    lower = 2 * length
    if math.comb(lower, length) > value:
        return None
    upper = lower
    while math.comb(upper, length) < value:
        upper *= 2
    while lower <= upper:
        middle = (lower + upper) // 2
        candidate = math.comb(middle, length)
        if candidate < value:
            lower = middle + 1
        elif candidate > value:
            upper = middle - 1
        else:
            return middle
    return None


def marginal_occupancy_record() -> dict[str, object]:
    records = []
    for length in range(5, 9):
        factorial = math.factorial(length)
        divisors = positive_divisors(factorial)
        candidate_rows = sorted(
            {
                divisor + offset
                for divisor in divisors
                for offset in range(length)
                if divisor + offset >= 2 * length
            }
        )
        full_intersections = []
        for row in candidate_rows:
            value = math.comb(row, length)
            rows = {
                other: binomial_row(value, other)
                for other in range(5, 9)
            }
            if all(candidate is not None for candidate in rows.values()):
                full_intersections.append(
                    {
                        "a": value,
                        "rows": {
                            str(other): rows[other]
                            for other in range(5, 9)
                        },
                    }
                )
        assert not full_intersections
        records.append(
            {
                "length": length,
                "factorial_divisor_count": len(divisors),
                "distinct_campaign_row_candidates": len(candidate_rows),
                "minimum_candidate_row": candidate_rows[0],
                "maximum_candidate_row": candidate_rows[-1],
                "four_column_intersections": full_intersections,
            }
        )
    assert [
        (
            record["factorial_divisor_count"],
            record["distinct_campaign_row_candidates"],
            record["minimum_candidate_row"],
            record["maximum_candidate_row"],
        )
        for record in records
    ] == [
        (16, 39, 10, 124),
        (30, 102, 12, 725),
        (60, 259, 14, 5046),
        (96, 544, 16, 40327),
    ]
    return {
        "proof": (
            "If a marginal L_(k,h)=1, then n_k-h=u_(k,h) divides "
            "k!, so n_k is in the displayed finite divisor list. Exact "
            "monotone inversion in the other three columns finds no "
            "four-column intersection."
        ),
        "records": records,
        "all_marginals_are_nontrivial": True,
    }


def singleton_78_polynomial(
    h7: int, h8: int, p: int, q: int
) -> list[int]:
    left = linear_substitute(falling(8), q, h8)
    right = poly_scale(linear_substitute(falling(7), p, h7), 8)
    difference = poly_add(left, poly_scale(right, -1))
    assert all(coefficient.denominator == 1 for coefficient in difference)
    return [int(coefficient) for coefficient in difference]


def ceil_div(numerator: int, denominator: int) -> int:
    assert denominator > 0
    return -((-numerator) // denominator)


def sparse_support_record() -> dict[str, object]:
    p_values = positive_divisors(math.factorial(7))
    p7_base = falling(7)
    p8_base = falling(8)
    p7_polynomials = {
        (h7, p): [
            int(coefficient)
            for coefficient in linear_substitute(p7_base, p, h7)
        ]
        for h7 in range(7)
        for p in p_values
    }
    p8_polynomials = {
        (h8, q): [
            int(coefficient)
            for coefficient in linear_substitute(p8_base, q, h8)
        ]
        for h8 in range(8)
        for q in range(1, math.factorial(7))
    }
    assert singleton_78_polynomial(0, 7, 15, 8) == [
        0,
        -46080,
        4011552,
        -37124416,
        325400824,
        -998899720,
        1998035368,
        -1308154744,
        16777216,
    ]

    total = 0
    exponent_counts = {1: 0, 2: 0}
    no_positive_root = 0
    one_root = 0
    root_above_integer_bound = 0
    consecutive_integer_bracket = 0
    for h7 in range(7):
        for h8 in range(8):
            for p in p_values:
                right = p7_polynomials[h7, p] + [0]
                for q in range(1, p):
                    total += 1
                    left = p8_polynomials[h8, q]
                    polynomial = [
                        left[index] - 8 * right[index]
                        for index in range(9)
                    ]
                    exponent = next(
                        index
                        for index, coefficient in enumerate(polynomial)
                        if coefficient != 0
                    )
                    assert exponent in exponent_counts
                    exponent_counts[exponent] += 1
                    integer_root_bound = abs(polynomial[exponent])
                    minimum_a = max(
                        1,
                        ceil_div(16 - h8, q),
                        ceil_div(7 + h8 - h7, p - q),
                    )
                    translated = integer_translate(polynomial, minimum_a)
                    value_at_minimum = translated[0]
                    assert value_at_minimum != 0
                    variations = sign_variations(translated)
                    if value_at_minimum > 0:
                        assert variations == 0
                        no_positive_root += 1
                        continue
                    assert variations == 1
                    one_root += 1
                    if (
                        integer_root_bound < minimum_a
                        or integer_evaluate(
                            polynomial, integer_root_bound
                        )
                        < 0
                    ):
                        root_above_integer_bound += 1
                        continue
                    assert integer_evaluate(
                        polynomial, integer_root_bound
                    ) > 0
                    lower = minimum_a
                    upper = integer_root_bound
                    while upper - lower > 1:
                        middle = (lower + upper) // 2
                        value = integer_evaluate(polynomial, middle)
                        assert value != 0
                        if value < 0:
                            lower = middle
                        else:
                            upper = middle
                    assert integer_evaluate(polynomial, lower) < 0
                    assert integer_evaluate(polynomial, upper) > 0
                    consecutive_integer_bracket += 1

    assert total == 1_079_904
    assert exponent_counts == {1: 1_079_759, 2: 145}
    assert no_positive_root == 489_636
    assert one_root == 590_268
    assert root_above_integer_bound == 108_345
    assert consecutive_integer_bracket == 481_923
    boundary_cells = [
        (index % 5, index % 6, index % 7, index % 8)
        for index in range(14)
    ]
    assert len(set(boundary_cells)) == 14
    assert all(
        {cell[coordinate] for cell in boundary_cells}
        == set(range(length))
        for coordinate, length in enumerate(range(5, 9))
    )
    assert all(
        sum(cell[2] == offset for cell in boundary_cells) == 2
        for offset in range(7)
    )
    return {
        "occupied_cell_threshold": 14,
        "prime_support_consequence": "omega(a)>=14",
        "proof": (
            "If at most 13 primary cells are occupied, the seven "
            "nonempty column-7 marginals include a singleton A. Its "
            "column-8 marginal is A*B. Writing p=u_(7,h), "
            "q=B*u_(8,j), ordered disjointness gives 1<=q<p with p|7!. "
            "The exact equality is P8(j+q*A)=8*P7(h+p*A). The exhaustive "
            "integer-root certificate below has no campaign root."
        ),
        "root_classification": {
            "parameter_tuples": total,
            "zero_multiplicity_counts": {
                str(key): value for key, value in exponent_counts.items()
            },
            "no_positive_root_after_domain_start": no_positive_root,
            "one_positive_real_root_after_domain_start": one_root,
            "real_root_above_integer_root_bound": (
                root_above_integer_bound
            ),
            "real_root_strictly_between_consecutive_integers": (
                consecutive_integer_bracket
            ),
            "campaign_integer_roots": 0,
        },
        "boundary": (
            "The incidence argument stops at 14 occupied cells; it does "
            "not classify the remaining omega(a)>=14 tensors."
        ),
        "boundary_incidence": {
            "cells": [list(cell) for cell in boundary_cells],
            "column_7_marginal_sizes": [2] * 7,
            "all_column_marginals_nonempty": True,
            "arithmetic_realizability_not_claimed": True,
        },
    }


def tensor_strictness_record() -> dict[str, object]:
    row_multipliers = {5: 40, 6: 36, 7: 28, 8: 16}
    pairs = [(5, 6), (6, 7), (7, 8), (5, 7), (6, 8), (5, 8)]
    samples = []
    for prime in (2, 3, 5, 7, 11, 101):
        rows = {
            length: multiplier * prime
            for length, multiplier in row_multipliers.items()
        }
        assert rows[5] - rows[6] >= 5
        assert rows[6] - rows[7] >= 6
        assert rows[7] - rows[8] >= 7
        for length, row in rows.items():
            assert row >= 2 * length
            assert row % prime == 0
            terms = list(range(row - length + 1, row + 1))
            assert math.lcm(*terms) % (length * prime) == 0
        for short, long in pairs:
            gap = rows[short] - rows[long]
            assert gap % prime == 0
            assert (
                int(evaluate(row_gap_polynomial(short, long), gap))
                % prime
                == 0
            )
        samples.append(
            {
                "prime": prime,
                "a": prime,
                "rows": {
                    str(length): row for length, row in rows.items()
                },
            }
        )
    return {
        "family": (
            "For every prime q>=2, set a=q and "
            "(n5,n6,n7,n8)=(40q,36q,28q,16q)."
        ),
        "verified_identities": (
            "All campaign inequalities hold, the sole primary has coherent "
            "offset tuple (0,0,0,0), k*a divides each window lcm through "
            "the displayed endpoint, and a divides all six row-gap "
            "polynomials."
        ),
        "not_curve_points_claimed": True,
        "sample_checks": samples,
    }


def prime_powers_at_most(limit: int) -> list[int]:
    out = set()
    for prime in (2, 3, 5, 7):
        value = prime
        while value <= limit:
            out.add(value)
            value *= prime
    return sorted(out)


def lcm_kernel_records() -> list[dict[str, object]]:
    records = []
    for length in range(5, 9):
        residue_checks = []
        for prime_power in prime_powers_at_most(length - 1):
            counts = []
            for start in range(prime_power):
                counts.append(
                    sum(
                        (start + offset) % prime_power == 0
                        for offset in range(length)
                    )
                )
            maximum = max(counts)
            assert maximum - 1 <= (length - 1) // prime_power
            residue_checks.append(
                {
                    "prime_power": prime_power,
                    "maximum_multiples_in_window": maximum,
                    "remaining_after_one_maximal_term": maximum - 1,
                    "factorial_layer_bound": (
                        (length - 1) // prime_power
                    ),
                }
            )
        samples = []
        for row in range(2 * length, 2 * length + 21):
            terms = list(range(row - length + 1, row + 1))
            interval_lcm = math.lcm(*terms)
            divisor = length * math.comb(row, length)
            assert interval_lcm % divisor == 0
            samples.append(
                {
                    "row": row,
                    "interval_lcm_over_k_times_binomial": (
                        interval_lcm // divisor
                    ),
                }
            )
        records.append(
            {
                "length": length,
                "finite_residue_layer_checks": residue_checks,
                "sample_checks": samples,
            }
        )
    return records


def centered_records() -> dict[str, list[int]]:
    p5 = falling(5)
    p6 = falling(6)
    p7 = falling(7)
    p8 = falling(8)
    centered = {
        "P5(u+2)": primitive(linear_substitute(p5, 1, 2)),
        "64*P6((V+5)/2)": primitive(
            poly_scale(linear_substitute(p6, Fraction(1, 2), Fraction(5, 2)), 64)
        ),
        "P7(v+3)": primitive(linear_substitute(p7, 1, 3)),
        "256*P8((W+7)/2)": primitive(
            poly_scale(linear_substitute(p8, Fraction(1, 2), Fraction(7, 2)), 256)
        ),
    }
    expected = {
        "P5(u+2)": [0, 4, 0, -5, 0, 1],
        "64*P6((V+5)/2)": [-225, 0, 259, 0, -35, 0, 1],
        "P7(v+3)": [0, -36, 0, 49, 0, -14, 0, 1],
        "256*P8((W+7)/2)": [
            11025,
            0,
            -12916,
            0,
            1974,
            0,
            -84,
            0,
            1,
        ],
    }
    assert centered == expected
    return centered


def critical_support_records() -> tuple[list[dict[str, object]], dict[int, list[int]]]:
    expected = {
        5: [82944, 0, -47500, 0, 3125],
        6: [-14400, -12576, 26555, 10368],
        7: [
            -13271040000,
            0,
            199502585856,
            0,
            -542352478080,
            0,
            96889010407,
        ],
        8: [354375, -1375650, -15700041, 35051856, 22478848],
    }
    multipliers = {5: 1, 6: 6, 7: 42, 8: 336}
    records = []
    supports = {}
    for length in range(5, 9):
        p = falling(length)
        p_prime = derivative(p)
        assert qpoly_gcd(p_prime, derivative(p_prime)) == [Fraction(1)]
        full_resultant = critical_resultant(length, multipliers[length])
        support = squarefree_support(full_resultant)
        assert support == expected[length]
        supports[length] = support
        records.append(
            {
                "length": length,
                "parameter_multiplier": multipliers[length],
                "critical_resultant_ascending": full_resultant,
                "squarefree_branch_support_ascending": support,
                "derivative_is_squarefree": True,
            }
        )
    for first in range(5, 9):
        for second in range(first + 1, 9):
            assert qpoly_gcd(supports[first], supports[second]) == [
                Fraction(1)
            ]
    return records, supports


def coherent_offset_record() -> dict[str, object]:
    quadruples = [
        (h5, h6, h7, h8)
        for h5 in range(5)
        for h6 in range(6)
        for h7 in range(7)
        for h8 in range(8)
    ]
    coherent = {
        (h5 - h6, h6 - h7, h7 - h8)
        for h5, h6, h7, h8 in quadruples
    }
    six_pair_range_set = {
        (d56, d67, d78)
        for d56 in range(-5, 5)
        for d67 in range(-6, 6)
        for d78 in range(-7, 7)
        if -6 <= d56 + d67 <= 4
        and -7 <= d67 + d78 <= 5
        and -7 <= d56 + d67 + d78 <= 4
    }
    assert len(quadruples) == 1680
    assert len(coherent) == 840
    assert coherent == six_pair_range_set
    return {
        "offset_quadruple_count": len(quadruples),
        "distinct_adjacent_gap_residue_triples": len(coherent),
        "coherent_set_equals_all_six_pair_range_conditions": True,
        "adjacent_ranges": {
            "d56": [-5, 4],
            "d67": [-6, 5],
            "d78": [-7, 6],
        },
        "cumulative_ranges": {
            "d57": [-6, 4],
            "d68": [-7, 5],
            "d58": [-7, 4],
        },
    }


def strictness_record() -> dict[str, object]:
    r56 = row_gap_polynomial(5, 6)
    assert evaluate(r56, 5) == math.factorial(10)
    v2_r56 = 0
    value = math.factorial(10)
    while value % 2 == 0:
        v2_r56 += 1
        value //= 2
    assert v2_r56 == 8
    samples = []
    for exponent in range(4, 21):
        z = 2**exponent
        a = 2 ** (4 * exponent)
        rows = {
            "n5": z + 18,
            "n6": z + 13,
            "n7": z + 7,
            "n8": z,
        }
        assert rows["n5"] - rows["n6"] == 5
        assert rows["n6"] - rows["n7"] == 6
        assert rows["n7"] - rows["n8"] == 7
        assert a == z**4
        assert a % int(evaluate(r56, 5)) != 0
        samples.append(
            {
                "N": exponent,
                "a": a,
                "z": z,
                "rows": rows,
                "v2_a": 4 * exponent,
                "v2_R56_5": v2_r56,
            }
        )
    return {
        "family": (
            "For N>=4, a_N=2^(4N), z_N=2^N, and "
            "(n5,n6,n7,n8)=(z_N+18,z_N+13,z_N+7,z_N)."
        ),
        "old_relaxation": (
            "The p>8 part is L=1, the residual b=a_N is 8-smooth, "
            "b=z_N^4, and the windows have the exact disjoint gaps 5,6,7."
        ),
        "new_exclusion": (
            "R_56(5)=10! has 2-adic valuation 8, while "
            "v_2(a_N)=4N>=16, so a_N does not divide R_56(5)."
        ),
        "not_curve_points": True,
        "sample_checks": samples,
    }


def jacobian_record(supports: dict[int, list[int]]) -> dict[str, object]:
    discovery = json.loads((JACOBIAN / "discovery.json").read_text())
    contract = json.loads((JACOBIAN / "contract.json").read_text())
    payload = json.loads((JACOBIAN / "payload.json").read_text())
    result = json.loads((JACOBIAN / "result.json").read_text())
    status = json.loads((JACOBIAN / "status.json").read_text())
    operation = "polynomial.compute.resultant"
    assert any(
        match["operation_id"] == operation
        for match in discovery["result"]["matches"]
    )
    assert contract["result"]["operation"]["operation_id"] == operation
    assert contract["result"]["operation"]["read_only"] is True
    assert result["request"]["operation_id"] == operation
    assert result["result"]["operation_id"] == operation
    left = [
        int(term["coefficient"]["num"])
        for term in reversed(payload["left"]["polynomial"]["terms"])
    ]
    right = [
        int(term["coefficient"]["num"])
        for term in reversed(payload["right"]["polynomial"]["terms"])
    ]
    assert left == supports[6]
    assert right == supports[8]
    exact_resultant = resultant(left, right)
    expected = -1032328973349640579114596832324104960000
    assert exact_resultant == expected
    output = result["result"]["output"]
    assert output["resultant"] == {
        "kind": "SCALAR",
        "value": {"den": "1", "num": str(expected)},
    }
    assert status["command_exit_code"] == 0
    assert status["timed_out"] is False
    assert status["structured_error"] is None
    return {
        "server": result["server"],
        "protocol_version": result["protocol_version"],
        "operation_id": operation,
        "exact_payload": payload,
        "typed_output": output,
        "runtime_ms": result["result"]["runtime_ms"],
        "adapter_status": status,
        "scope": (
            "This checks only that the degree-6 and degree-8 finite "
            "branch-support polynomials have nonzero resultant."
        ),
    }


def jacobian_singleton_root_record() -> dict[str, object]:
    discovery = json.loads(
        (JACOBIAN / "discovery_singleton_roots.json").read_text()
    )
    contract = json.loads(
        (JACOBIAN / "contract_singleton_roots.json").read_text()
    )
    payload = json.loads(
        (JACOBIAN / "payload_singleton_roots.json").read_text()
    )
    result = json.loads(
        (JACOBIAN / "result_singleton_roots.json").read_text()
    )
    status = json.loads(
        (JACOBIAN / "status_singleton_roots.json").read_text()
    )
    operation = "polynomial.roots.isolate"
    assert any(
        match["operation_id"] == operation
        for match in discovery["result"]["matches"]
    )
    assert contract["result"]["operation"]["operation_id"] == operation
    assert contract["result"]["operation"]["read_only"] is True
    assert result["request"]["operation_id"] == operation
    assert result["request"]["payload"] == payload
    assert result["result"]["operation_id"] == operation
    coefficients = [
        int(coefficient["num"])
        for coefficient in payload["coefficients_descending"]
    ]
    assert coefficients == list(
        reversed(singleton_78_polynomial(0, 7, 15, 8))
    )
    output = result["result"]["output"]
    assert output == {
        "convention": "SYMPY_REAL_ROOTS",
        "multiplicities": [1, 1, 1, 1],
        "roots": [
            [
                {"den": "1", "num": "0"},
                {"den": "1", "num": "0"},
            ],
            [
                {"den": "1", "num": "0"},
                {"den": "5", "num": "1"},
            ],
            [
                {"den": "1", "num": "1"},
                {"den": "1", "num": "1"},
            ],
            [
                {"den": "1", "num": "76"},
                {"den": "1", "num": "77"},
            ],
        ],
    }
    assert status["command_exit_code"] == 0
    assert status["timed_out"] is False
    assert status["structured_error"] is None
    return {
        "server": result["server"],
        "protocol_version": result["protocol_version"],
        "operation_id": operation,
        "exact_payload": payload,
        "typed_output": output,
        "runtime_ms": result["result"]["runtime_ms"],
        "adapter_status": status,
        "scope": (
            "This isolates the roots of one off-domain control polynomial "
            "from the 1,079,904-case singleton classification. The project "
            "certificate proves completeness for the entire finite family."
        ),
    }


def main() -> None:
    centered = centered_records()
    critical_records, supports = critical_support_records()
    marginal_occupancy = marginal_occupancy_record()
    sparse_support = sparse_support_record()
    pairs = [(5, 6), (6, 7), (7, 8), (5, 7), (6, 8), (5, 8)]
    row_gap_records = []
    for short, long in pairs:
        coefficients = row_gap_polynomial(short, long)
        assert len(coefficients) - 1 == short + long - 1
        row_gap_records.append(
            {
                "pair": [short, long],
                "degree": len(coefficients) - 1,
                "offset_range": [-(long - 1), short - 1],
                "ascending_coefficients": coefficients,
            }
        )

    degree = math.prod(range(5, 9))
    ramification_index = math.lcm(*range(5, 9))
    infinity_points = degree // ramification_index
    pole_orders = {
        "t": ramification_index,
        "x": ramification_index // 5,
        "s": ramification_index // 6,
        "y": ramification_index // 7,
        "z": ramification_index // 8,
    }
    finite_ramification = {
        str(length): (length - 1) * degree // length
        for length in range(5, 9)
    }
    infinity_ramification = infinity_points * (ramification_index - 1)
    twice_genus_minus_two = (
        -2 * degree
        + sum(finite_ramification.values())
        + infinity_ramification
    )
    assert degree == 1680
    assert ramification_index == 840
    assert infinity_points == 2
    assert pole_orders == {"t": 840, "x": 168, "s": 140, "y": 120, "z": 105}
    assert twice_genus_minus_two == 3972
    genus = (twice_genus_minus_two + 2) // 2
    assert genus == 1987

    report = {
        "schema_version": 1,
        "target": {
            "equations": [
                "C(x,5)=C(s,6)=C(y,7)=C(z,8)=a",
                "P5(x)=t, P6(s)=6t, P7(y)=42t, P8(z)=336t",
                "t=120a",
            ],
            "domain": {
                "x_min": 10,
                "s_min": 12,
                "y_min": 14,
                "z_min": 16,
                "x_minus_s_min": 5,
                "s_minus_y_min": 6,
                "y_minus_z_min": 7,
            },
            "centered_polynomials_ascending": centered,
            "centered_domain": {
                "u_min": 8,
                "V_min": 19,
                "V_odd": True,
                "v_min": 11,
                "W_min": 25,
                "W_odd": True,
                "2u_minus_V_min": 11,
                "V_minus_2v_min": 13,
                "2v_minus_W_min": 15,
            },
        },
        "geometry": {
            "critical_branch_records": critical_records,
            "all_pairwise_finite_branch_support_gcds_are_one": True,
            "affine_fiber_product_is_smooth": True,
            "geometrically_integral_degree_over_Q_t": degree,
            "infinity": {
                "geometric_point_count": infinity_points,
                "ramification_index_each": ramification_index,
                "pole_orders_each": pole_orders,
                "distinguishing_residue": "z^4/s^3 = +/-sqrt(56)",
                "closed_points_over_Q": 1,
                "closed_point_residue_field": "Q(sqrt(14))",
            },
            "riemann_hurwitz": {
                "finite_contributions": finite_ramification,
                "infinity_contribution": infinity_ramification,
                "twice_genus_minus_two": twice_genus_minus_two,
                "genus": genus,
            },
        },
        "all_primary_synchronization": {
            "lcm_lemma": (
                "For every length-k consecutive integer window, its "
                "product divided by (k-1)! divides the window lcm. "
                "For a binomial occurrence this says k*a divides the lcm."
            ),
            "lcm_kernel_records": lcm_kernel_records(),
            "consequence": (
                "For every p^e exactly dividing a and every k in {5,6,7,8}, "
                "one numerator term is divisible by p^e. The four selected "
                "offsets are coherent for that same primary power."
            ),
            "primary_power_bound": (
                "p^e <= min(d56+5,d67+6,d78+7) for every p^e||a."
            ),
            "coherent_offsets": coherent_offset_record(),
            "row_gap_polynomials": row_gap_records,
            "six_divisibilities": (
                "a divides R_56(d56), R_67(d67), R_78(d78), "
                "R_57(d56+d67), R_68(d67+d78), and "
                "R_58(d56+d67+d78)."
            ),
            "strictness_against_large_prime_only_relaxation": (
                strictness_record()
            ),
        },
        "primary_factor_allocation": {
            "exact_tensor_model": (
                "Group each primary p^e||a by one coherent offset tuple H. "
                "For A_H equal to the product in a cell and "
                "L_(k,h)=product_(H:h_k=h) A_H, the exact equations are "
                "n_k-h=L_(k,h)u_(k,h), product_h u_(k,h)=k!, and "
                "product_H A_H=a. Conversely these equations recover all "
                "four binomial equalities."
            ),
            "marginal_occupancy": marginal_occupancy,
            "sparse_support_exclusion": sparse_support,
            "strictness_against_coherent_offset_relaxation": (
                tensor_strictness_record()
            ),
        },
        "jacobian": jacobian_record(supports),
        "jacobian_singleton_root_cross_check": (
            jacobian_singleton_root_record()
        ),
        "claim_boundary": {
            "proved": [
                "The displayed four-column model is bidirectionally exact.",
                "Its affine fiber product is smooth and geometrically integral.",
                "Its normalization has genus 1987 and exactly two geometric "
                "infinity points forming one Q(sqrt(14)) closed point over Q.",
                "Every primary power of a has one coherent selected term in "
                "all four windows; the residual-free gap divisibilities follow.",
                "The all-primary condition deletes the displayed infinite "
                "8-smooth family from the prior large-primary relaxation.",
                "The primary-cell tensor model is bidirectionally exact, every "
                "marginal is nontrivial, and every campaign point would satisfy "
                "omega(a)>=14.",
            ],
            "not_proved": [
                "A complete integer-point classification of the full system.",
                "The campaign-domain full system is empty.",
                "A campaign-domain exact solution exists.",
                "The remaining omega(a)>=14 primary-cell tensors are empty.",
                "The {5,6,7,8} branch is excluded.",
                "C-T5.",
            ],
        },
    }
    OUTPUT.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps({"ok": True, "output": str(OUTPUT.relative_to(ROOT))}))


if __name__ == "__main__":
    main()
