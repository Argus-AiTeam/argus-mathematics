#!/usr/bin/env python3
"""Recheck the finite logarithm models in colimit-witness.json over Q[h]/h^n."""

import argparse
import copy
import json
import math
from fractions import Fraction
from pathlib import Path


def polynomial(coefficients, length):
    return tuple(
        Fraction(coefficients[k]) if k < len(coefficients) else Fraction(0)
        for k in range(length)
    )


def add(left, right):
    return tuple(a + b for a, b in zip(left, right))


def multiply(left, right):
    length = len(left)
    return tuple(
        sum((left[j] * right[k - j] for j in range(k + 1)), Fraction(0))
        for k in range(length)
    )


def power(value, exponent):
    result = polynomial([1], len(value))
    for _ in range(exponent):
        result = multiply(result, value)
    return result


def matrix(raw, length):
    return tuple(tuple(polynomial(entry, length) for entry in row) for row in raw)


def matrix_multiply(left, right):
    size, length = len(left), len(left[0][0])
    return tuple(
        tuple(
            sum_polynomials(
                (multiply(left[i][k], right[k][j]) for k in range(size)), length
            )
            for j in range(size)
        )
        for i in range(size)
    )


def sum_polynomials(values, length):
    result = polynomial([], length)
    for value in values:
        result = add(result, value)
    return result


def matrix_power(value, exponent):
    size, length = len(value), len(value[0][0])
    result = tuple(
        tuple(polynomial([int(i == j)], length) for j in range(size))
        for i in range(size)
    )
    for _ in range(exponent):
        result = matrix_multiply(result, value)
    return result


def require_zero(value):
    if any(coefficient for row in value for entry in row for coefficient in entry):
        raise ValueError("the claimed truncated zero map is nonzero")


def require_nonzero(value):
    try:
        require_zero(value)
    except ValueError:
        return
    raise ValueError("the claimed nonzero map is zero")


def require_mixed(system):
    offsets = system["weight_offsets"]
    slope = system["weight_slope"]
    raw = system["matrix"]
    if len(raw) != len(offsets) or any(len(row) != len(offsets) for row in raw):
        raise ValueError("matrix and generator weights have different dimensions")
    for target, row in enumerate(raw):
        for source, entry in enumerate(row):
            for degree, coefficient in enumerate(entry):
                if Fraction(coefficient) and offsets[source] != (
                    slope + offsets[target] - 2 * degree
                ):
                    raise ValueError("transition does not preserve the mixed weight")


def require_cutoff(upper, source, length):
    if length < 1 or upper - 2 * length >= source:
        raise ValueError("the strict weight-separation inequality fails")


def expect_rejection(check, *arguments):
    try:
        check(*arguments)
    except ValueError:
        return
    raise AssertionError(f"{check.__name__} accepted a negative control")


def self_test(witness):
    length = witness["max_length"]
    h = matrix([[[0, 1]]], length + 1)
    expect_rejection(require_zero, matrix_power(h, length))
    expect_rejection(require_mixed, witness["systems"][1])
    expect_rejection(require_cutoff, 2, 0, 1)
    malformed = copy.deepcopy(witness["systems"][0])
    malformed["weight_offsets"].append(0)
    expect_rejection(require_mixed, malformed)
    require_zero(matrix_power(matrix([[[0, 1]]], length), length))
    require_mixed(witness["systems"][0])
    require_cutoff(2, 0, 2)
    return {
        "negative_controls_rejected": [
            "h^a is not zero modulo h^(a+1)",
            "bounded weights with a nonmixed h transition",
            "equality at the proposed strict cutoff",
            "inconsistent matrix dimensions"
        ],
        "positive_controls": 3
    }


def check(witness):
    maximum = witness["max_length"]
    if not isinstance(maximum, int) or maximum < 2:
        raise ValueError("max_length must be an integer at least two")
    results = []
    for system in witness["systems"]:
        if system["mixed"]:
            require_mixed(system)
        else:
            expect_rejection(require_mixed, system)
        finite_checks = []
        for length in range(1, maximum + 1):
            value = matrix(system["matrix"], length)
            require_zero(matrix_power(value, length))
            if system["zero_power"] is None:
                require_nonzero(matrix_power(
                    matrix(system["matrix"], length + 1), length
                ))
            else:
                require_zero(matrix_power(value, system["zero_power"]))
            finite_checks.append(length)
        results.append({
            "name": system["name"],
            "mixed": system["mixed"],
            "lengths_killed_by_that_many_transitions": finite_checks,
            "nonzero_at_length_a_plus_one_after_a_transitions": (
                system["zero_power"] is None
            ),
            "fixed_zero_power": system["zero_power"]
        })

    gauge_checks = []
    for length in range(2, maximum + 1):
        exp_minus_one = tuple(
            Fraction(0) if degree == 0 else Fraction(1, math.factorial(degree))
            for degree in range(length)
        )
        unit = tuple(
            Fraction(1, math.factorial(degree + 1)) for degree in range(length)
        )
        h = polynomial([0, 1], length)
        for stage in range(maximum + 1):
            if multiply(power(unit, stage), exp_minus_one) != multiply(
                h, power(unit, stage + 1)
            ):
                raise AssertionError("q-1 to h gauge identity failed")
        gauge_checks.append(length)

    torsion_pairs = 0
    for source_stage in range(witness["torsion_ladder_max_stage"] + 1):
        for target_stage in range(
            source_stage, witness["torsion_ladder_max_stage"] + 1
        ):
            degree = target_stage - source_stage
            monomial = [0] * degree + [1]
            require_nonzero(matrix([[monomial]], target_stage + 1))
            relation_image = [0] * (degree + source_stage + 1) + [1]
            require_zero(matrix([[relation_image]], target_stage + 1))
            torsion_pairs += 1
        for length in range(1, maximum + 1):
            target_stage = source_stage + length
            target_length = min(length, target_stage + 1)
            require_zero(matrix([[[0] * length + [1]]], target_length))

    thresholds = []
    for case in witness["threshold_cases"]:
        upper, source = case["target_upper_weight"], case["source_weight"]
        safe = max(1, (upper - source) // 2 + 1)
        require_cutoff(upper, source, safe)
        boundary = None
        if safe > 1:
            unsafe = safe - 1
            expect_rejection(require_cutoff, upper, source, unsafe)
            monomial = [0] * unsafe + [1]
            require_mixed({
                "weight_offsets": [source],
                "weight_slope": 2 * unsafe,
                "matrix": [[monomial]]
            })
            if source + 2 * unsafe > upper:
                raise AssertionError("boundary witness exceeds the upper weight")
            require_zero(matrix([[monomial]], unsafe))
            require_nonzero(matrix([[monomial]], unsafe + 1))
            boundary = {
                "nonzero_map": f"h^{unsafe}",
                "target_generator_weight": source + 2 * unsafe,
                "killed_length": unsafe
            }
        thresholds.append({
            **case,
            "first_safe_positive_length": safe,
            "last_unsafe_length_witness": boundary
        })
    return {
        "arithmetic": "fractions.Fraction; no floating point",
        "systems": results,
        "exp(h)-1 = h*u(h) gauge_lengths": gauge_checks,
        "torsion_ladder": {
            "modules": "R/(h^(i+1)), transition h",
            "well_defined_nonzero_composites_checked": torsion_pairs,
            "each_fixed_truncation_killed_in_n_steps": True,
            "scope": "does not test generic nonzero: every module here is torsion"
        },
        "thresholds": thresholds,
        "scope": "finite experiments, not a proof of the infinite-system statements"
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", type=Path)
    parser.add_argument("--self-test", action="store_true")
    arguments = parser.parse_args()
    witness = json.loads(arguments.witness.read_text())
    result = check(witness)
    if arguments.self_test:
        result["self_test"] = self_test(witness)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
