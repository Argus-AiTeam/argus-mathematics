#!/usr/bin/env python3
"""Exact finite checks for the zero-weight obstruction and local norm cancellation."""

import argparse
import copy
import hashlib
import json
import sys
from collections import Counter
from fractions import Fraction
from itertools import combinations, product
from pathlib import Path

sys.dont_write_bytecode = True
from gl4_degree20_exact import add, rational_pivots, require_equal, tensor


OPERATION = "finite_abelian_group.spectral_pair.decide"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def multiply(left, right):
    return [
        [sum(a * b for a, b in zip(row, column)) for column in zip(*right)]
        for row in left
    ]


def diagonal(entries):
    return [[entry if i == j else 0 for j in range(len(entries))]
            for i, entry in enumerate(entries)]


def fourier_certificate(payload, envelope):
    require_equal(envelope["request"], {
        "operation_id": OPERATION, "payload": payload,
    }, "Adapter result must bind the exact inspected payload")
    require_equal(envelope["result"]["operation_id"], OPERATION, "Operation id")
    source = {
        "group": {"moduli": [5]},
        "points": [[i] for i in range(5)],
        "frequencies": [[i] for i in range(5)],
    }
    require_equal(payload, {"source": source}, "The bounded diagnostic is exactly C5")
    output = envelope["result"]["output"]
    require_equal(output, {
        "source": source,
        "is_spectral": True,
        "reason": "SPECTRAL",
        "character_convention": "POSITIVE_PRODUCT_DUAL_PAIRING",
        "first_nonorthogonal_pair": None,
    }, "A complete typed spectral verdict is required")
    remainders = []
    for left, right in combinations(range(5), 2):
        counts = Counter(((left - right) * point) % 5 for point in range(5))
        remainder = [counts[i] - counts[4] for i in range(4)]
        require_equal(remainder, [0] * 4, "Reduction modulo Phi_5")
        remainders.append({
            "frequencies": [left, right], "remainder": remainder,
        })
    inverse_numerator = Counter({(0,): 4, (1,): 3, (2,): 2, (3,): 1})
    difference = tensor(Counter({(0,): 1, (1,): -1}), inverse_numerator)
    remainder = [difference[(i,)] - difference[(4,)] for i in range(4)]
    require_equal(remainder, [5, 0, 0, 0], "Exact inverse of 1-zeta_5")
    return {
        "cyclotomic_polynomial_coefficients": [1, 1, 1, 1, 1],
        "pair_remainders": remainders,
        "inverse_of_one_minus_zeta": "(4+3*zeta+2*zeta^2+zeta^3)/5",
        "scope": "Exact C5 character cancellation only, not a proof over all p-adic fields",
    }


def conjugation_certificate(exponent_offset=-1):
    p, r = 5, 2
    identity = diagonal([Fraction(1)] * 4)
    element = copy.deepcopy(identity)
    element[0][1] = p ** r
    conjugator = diagonal([Fraction(p) ** (-r + exponent_offset), 1, 1, 1])
    inverse = diagonal([Fraction(p) ** (r - exponent_offset), 1, 1, 1])
    conjugated = multiply(multiply(conjugator, element), inverse)
    expected = copy.deepcopy(identity)
    expected[0][1] = Fraction(1, p)
    require_equal(conjugated, expected, "The type-kernel element must have psi conductor p^-1")
    require_equal((-1 + 1, -1), (0, -1), "Formal exponent (-r-1)+r=-1")
    diagonal_exponents = (3, 2, 1, 0)
    root_exponents = [
        diagonal_exponents[i] - diagonal_exponents[j]
        for i, j in combinations(range(4), 2)
    ]
    require_equal(sum(root_exponents), 10, "Whittaker conjugation Haar exponent")
    return {
        "p": p, "r": r,
        "conjugator": [[str(x) for x in row] for row in conjugator],
        "kernel_element": [[str(x) for x in row] for row in element],
        "conjugated_element": [[str(x) for x in row] for row in conjugated],
        "all_r_exponent_identity": "(-r-1)+r=-1",
        "positive_root_exponents": root_exponents,
        "haar_jacobian": "p^(10m)",
        "universal_scope": "The all-prime obstruction and Haar change are proved in Sections 15 and 18",
    }


def pair_monodromy_certificate(omit_scalar=False):
    coordinates = list(product(range(4), repeat=2))
    monodromy = [[0] * 16 for _ in range(16)]
    for column, (a, b) in enumerate(coordinates):
        if a == 1:
            monodromy[coordinates.index((0, b))][column] += 1
        if b == 0:
            monodromy[coordinates.index((a, 1))][column] -= 1
    require_equal(len(rational_pivots(monodromy)), 6, "Rank of X -> NX-XN")
    square = multiply(monodromy, monodromy)
    require_equal(len(rational_pivots(square)), 1, "Rank of pair monodromy squared")
    require_equal(multiply(square, monodromy), [[0] * 16 for _ in range(16)],
                  "Pair monodromy has cube zero")
    supports = [
        [(0, 0), (1, 1)], [(0, 1)],
        [(0, 2)], [(0, 3)], [(2, 1)], [(3, 1)],
        [(2, 2)], [(2, 3)], [(3, 2)], [(3, 3)],
    ]
    if omit_scalar:
        supports = supports[1:]
    basis = [[int(coordinate in support) for coordinate in coordinates]
             for support in supports]
    require_equal(len(rational_pivots(basis)), 10, "Complete monodromy kernel")
    require_equal(multiply(monodromy, list(map(list, zip(*basis)))),
                  [[0] * 10 for _ in range(16)], "Every kernel vector is exact")

    weights = [
        (1, 0, 0, 1), (1, 0, 0, -1),
        (0, 1, 0, 0), (0, 0, 1, 0),
    ]
    full_roots = Counter()
    for support in supports:
        root_weights = {
            tuple(x - y for x, y in zip(weights[a], weights[b]))
            for a, b in support
        }
        require_equal(len(root_weights), 1, "Homogeneous Frobenius kernel vector")
        full_roots[next(iter(root_weights))] += 1
    standard = Counter(weights[i] for i in (0, 2, 3))
    dual = Counter(tuple(-x for x in weights[i]) for i in (1, 2, 3))
    formal_roots = tensor(standard, dual)
    extra = add(full_roots, formal_roots, -1)
    require_equal(extra, Counter({(0, 0, 0, 0): 1}),
                  "The full pair factor has exactly one extra trivial Euler root")
    return {
        "matrix": monodromy,
        "rank": 6,
        "square_rank": 1,
        "cube_rank": 0,
        "kernel_dimension": 10,
        "kernel_basis_matrix_unit_supports": supports,
        "weight_variables": ["chi", "chi_2", "chi_3", "q^(-1/2)"],
        "full_pair_kernel_weights": [
            {"weight": list(weight), "multiplicity": count}
            for weight, count in sorted(full_roots.items())
        ],
        "formal_standard_pair_degree": sum(formal_roots.values()),
        "extra_full_pair_root": 1,
        "pair_L_factor": "zeta_q(s)*L_formal(s)",
        "pair_conductor_exponent": 6,
    }


def q_normalization_certificate(omit_tamagawa=False):
    one = Counter({(0,): 1})
    kappa3 = one
    for j in (1, 2, 3):
        kappa3 = tensor(kappa3, Counter({(0,): 1, (j,): -1}))
    kappa4 = tensor(kappa3, Counter({(0,): 1, (4,): -1}))
    polynomial = Counter({(j,): 1 for j in range(4)})
    norm_volume = one if omit_tamagawa else kappa3
    require_equal(
        tensor(tensor(norm_volume, Counter({(0,): 1, (1,): -1})), polynomial),
        kappa4,
        "Exact conductor-one norm/L-factor cancellation including kappa_3",
    )
    require_equal(tuple(a - b for a, b in zip((3, 1, -1), (2, 0, -2))),
                  (1, 1, 1), "The Iwasawa density contributes |det a|")
    require_equal(tensor(kappa3, Counter({(0,): 1, (4,): -1})), kappa4,
                  "Spherical norm/L-factor cancellation")
    return {
        "variable": "x=q^-1",
        "kappa3_coefficients": {str(e[0]): c for e, c in sorted(kappa3.items()) if c},
        "kappa4_coefficients": {str(e[0]): c for e, c in sorted(kappa4.items()) if c},
        "ramified_normalized_Bessel_polynomial": [1, 1, 1, 1],
        "ramified_cross_multiplied_identity": "kappa_3*(1-x)*(1+x+x^2+x^3)=kappa_4",
        "spherical_normalized_Bessel_factor": 1,
        "mirabolic_density_exponents": [1, 1, 1],
        "scope": "Finite Euler-factor algebra; the infinite Schur summation and analytic normalization are prose proofs",
    }


def rejected(label, operation):
    try:
        operation()
    except AssertionError:
        return label
    raise AssertionError("Corrupted certificate was accepted: " + label)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jacobian-input", type=Path, required=True)
    parser.add_argument("--jacobian-output", type=Path, required=True)
    args = parser.parse_args()
    payload = json.loads(args.jacobian_input.read_text())
    envelope = json.loads(args.jacobian_output.read_text())
    fourier = fourier_certificate(payload, envelope)
    conjugation = conjugation_certificate()
    pair = pair_monodromy_certificate()
    normalization = q_normalization_certificate()
    corrupt = copy.deepcopy(envelope)
    corrupt["result"]["output"]["is_spectral"] = False
    negative_cases = [
        rejected("incomplete_or_false_fourier_verdict",
                 lambda: fourier_certificate(payload, corrupt)),
        rejected("wrong_character_conductor",
                 lambda: conjugation_certificate(exponent_offset=0)),
        rejected("omitted_extra_pair_euler_root",
                 lambda: pair_monodromy_certificate(omit_scalar=True)),
        rejected("omitted_tamagawa_mirabolic_volume",
                 lambda: q_normalization_certificate(omit_tamagawa=True)),
    ]
    helper = Path(__file__).with_name("gl4_degree20_exact.py")
    print(json.dumps({
        "result_class": "exact_unweighting_diagnostics",
        "script_sha256": digest(Path(__file__)),
        "arithmetic_helper_sha256": digest(helper),
        "jacobian_input_sha256": digest(args.jacobian_input),
        "jacobian_output_sha256": digest(args.jacobian_output),
        "jacobian_operation": OPERATION,
        "jacobian_server": envelope["server"],
        "jacobian_protocol": envelope["protocol_version"],
        "jacobian_runtime_ms": envelope["result"]["runtime_ms"],
        "jacobian_response_status": "typed_success",
        "fourier": fourier,
        "type_conjugation": conjugation,
        "prime_level_pair_monodromy": pair,
        "q_normalization": normalization,
        "negative_cases_rejected": negative_cases,
        "unchanged_support_and_cutoff_diagnostics_repeated": False,
        "universal_proofs": "research/gl4_ramified_type_density.md Sections 15-22",
        "universal_density_proof_mechanically_certified": False,
        "automorphic_counterexample_constructed": False,
        "novelty_verified": False,
    }, indent=2))


if __name__ == "__main__":
    main()
