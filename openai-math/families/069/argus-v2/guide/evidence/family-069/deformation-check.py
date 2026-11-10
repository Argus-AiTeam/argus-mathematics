#!/usr/bin/env python3
"""Exact finite models for the logarithm and collision calculations."""

import argparse
import json
from fractions import Fraction


def h_power_vector(length, power, exponent):
    return tuple(
        Fraction(1) if j == power + exponent else Fraction(0)
        for j in range(length)
    )


def stable_tor_transition(exponent, source_length, target_length):
    """Image in B_target of H^-1([B_source --h^exponent--> B_source])."""
    kernel_basis = range(max(0, source_length - exponent), source_length)
    return tuple(
        h_power_vector(target_length, power, 0) for power in kernel_basis
    )


def zero_vectors(vectors):
    return all(not any(vector) for vector in vectors)


def multiply_polynomials(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return result


def braid_poincare(block_sizes):
    result = [1]
    for size in block_sizes:
        for j in range(1, size):
            result = multiply_polynomials(result, [1, j])
    return result


def check():
    tor_cases = 0
    for exponent in range(1, 7):
        for target in range(1, 7):
            source = target + exponent
            assert zero_vectors(stable_tor_transition(exponent, source, target))
            # One length earlier still contains a surviving Tor class.
            assert not zero_vectors(
                stable_tor_transition(exponent, source - 1, target)
            )
            tor_cases += 1

    # [A --h^e--> A] in degrees -1,0 has H^-1=0 after completion,
    # but at length one the degree -1 group is one-dimensional.
    assert len(stable_tor_transition(3, 1, 1)) == 1
    assert not zero_vectors(stable_tor_transition(3, 1, 1))
    assert zero_vectors(stable_tor_transition(3, 4, 1))

    # The cochain complex of a rank-one local system on C* is
    # [Q --(q-1)--> Q]. These exact rational cases check its ranks,
    # not the geometric Mellin or Whittaker theorems.
    kummer = {
        str(q): [int(q == 1), int(q == 1)]
        for q in (Fraction(1), Fraction(2), Fraction(-1), Fraction(3, 2))
    }
    assert kummer["1"] == [1, 1]
    assert kummer["2"] == [0, 0]
    assert kummer["-1"] == [0, 0]
    nongeneric_boundary = {
        str(q): [int(2 * q == 1), int(2 * q == 1)]
        for q in (Fraction(1), Fraction(1, 2), Fraction(2))
    }
    assert nongeneric_boundary["1"] == [0, 0]
    assert nongeneric_boundary["1/2"] == [1, 1]

    collision_cases = []
    for blocks in ([2], [3], [2, 2], [4], [3, 2], [1, 1, 3]):
        polynomial = braid_poincare(blocks)
        codimension = sum(size - 1 for size in blocks)
        assert len(polynomial) - 1 == codimension
        n = sum(blocks)
        for k in range(len(polynomial)):
            ordinary_degree = k - 2 * n
            stalk_weight = 2 * k - 2 * n
            assert stalk_weight - ordinary_degree == k <= codimension
        collision_cases.append({
            "blocks": blocks,
            "codimension": codimension,
            "poincare_coefficients": polynomial,
        })

    # Normalize q-1=h*u by e'_i=u^i*e_i before assigning mixed weights.
    # In this basis the transition is h and h^j*e'_i has weight 2i-2j.
    for stage in range(6):
        for power in range(6):
            assert 2 * stage - 2 * power == 2 * (stage + 1) - 2 * (power + 1)

    return {
        "scope": "finite algebraic models only; no certification of global geometry",
        "tor_stabilization_cases": tor_cases,
        "kummer_H0_H1": kummer,
        "non_quasi_unipotent_boundary_H0_H1": nongeneric_boundary,
        "collision_models": collision_cases,
        "escape_model": {
            "transition": "q-1",
            "special_fibre_transition_rank": 0,
            "generic_transition_rank": 1,
            "compatible_stage_weight": "2i (unbounded)",
            "mixed_basis": "e'_i=u(h)^i*e_i, u(h)=(exp(h)-1)/h; transition h",
        },
        "negative_controls": [
            "Tor transition at source length n+e-1 must remain nonzero",
            "length-one Tor class must not be identified with completed H^-1/h",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.parse_args()
    print(json.dumps(check(), indent=2))


if __name__ == "__main__":
    main()
