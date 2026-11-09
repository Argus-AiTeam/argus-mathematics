#!/usr/bin/env python3
"""Replay finite rational shadows, not the spectrum generation problem."""

import argparse
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def basis(mask):
    return {mask: Fraction(1)}


def multiply(left, right):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            if a & b:
                continue
            inversions = sum(
                1
                for i in range(3)
                for j in range(3)
                if a & (1 << i) and b & (1 << j) and i > j
            )
            mask = a | b
            result[mask] = result.get(mask, Fraction(0)) + (-1) ** inversions * x * y
    return {mask: value for mask, value in result.items() if value}


def apply_map(images, element):
    result = {}
    for mask, coefficient in element.items():
        value = basis(0)
        for i in range(3):
            if mask & (1 << i):
                value = multiply(value, images[i])
        for target, scalar in value.items():
            result[target] = result.get(target, Fraction(0)) + coefficient * scalar
    return {mask: value for mask, value in result.items() if value}


def degree(mask, weights):
    return -sum(weight for i, weight in enumerate(weights) if mask & (1 << i))


def check_ring_map(images, source_weights, target_weights):
    require(apply_map(images, basis(0)) == basis(0), "Unit was not preserved")
    for mask in range(8):
        require(
            all(
                degree(mask, source_weights) == degree(target, target_weights)
                for target in apply_map(images, basis(mask))
            ),
            "Comparison is not graded",
        )
    for a in range(8):
        for b in range(8):
            require(
                apply_map(images, multiply(basis(a), basis(b)))
                == multiply(
                    apply_map(images, basis(a)), apply_map(images, basis(b))
                ),
                "Comparison is not multiplicative",
            )
    return 64


def matrix(images):
    columns = [apply_map(images, basis(mask)) for mask in range(8)]
    return [
        [columns[column].get(row, Fraction(0)) for column in range(8)]
        for row in range(8)
    ]


def exact_rank(entries):
    rows = [[Fraction(value) for value in row] for row in entries]
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(pivot_row, len(rows)) if rows[row][column]), None
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scalar = rows[pivot_row][column]
        rows[pivot_row] = [value / scalar for value in rows[pivot_row]]
        for row in range(len(rows)):
            if row == pivot_row:
                continue
            scalar = rows[row][column]
            rows[row] = [
                value - scalar * pivot_value
                for value, pivot_value in zip(rows[row], rows[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return pivot_row


def hilbert(weights):
    return Counter(degree(mask, weights) for mask in range(1 << len(weights)))


def product(left, right):
    result = Counter()
    for a, x in left.items():
        for b, y in right.items():
            result[a + b] += x * y
    return result


def replay():
    source_weights = (1, 3, 5)
    k1_weights = (1, 1, 3)
    k2_weights = (1, 3, 1)
    overlap_weights = (1, 1, 1)
    tau2 = (basis(4), basis(2), {})
    k1_to_overlap = (basis(1), basis(4), {})
    k2_to_overlap = (basis(2), {}, basis(4))
    cases = []
    identities = 0

    for c in (0, 1):
        tau1 = (basis(2), basis(4), {7: Fraction(c)} if c else {})
        for images, source, target in (
            (tau1, source_weights, k1_weights),
            (tau2, source_weights, k2_weights),
            (k1_to_overlap, k1_weights, overlap_weights),
            (k2_to_overlap, k2_weights, overlap_weights),
        ):
            identities += check_ring_map(images, source, target)
        for mask in range(8):
            require(
                apply_map(k1_to_overlap, apply_map(tau1, basis(mask)))
                == apply_map(k2_to_overlap, apply_map(tau2, basis(mask))),
                "Positive-height comparison square does not commute",
            )
        require(
            apply_map(tau2, basis(2)) == basis(2),
            "The degree-minus-three K(2) detector was lost",
        )
        require(
            [apply_map(tau1, basis(mask)) for mask in (0, 1, 2, 3)]
            == [basis(mask) for mask in (0, 2, 4, 6)],
            "K(1) common-basis units were changed",
        )
        require(
            [apply_map(tau2, basis(mask)) for mask in (0, 1)]
            == [basis(0), basis(4)],
            "K(2) common-basis units were changed",
        )
        entries = matrix(tau1)
        quotient = [
            [entries[row][column] for column in (2, 3, 4, 5, 6, 7)]
            for row in (4, 5, 6, 7)
        ]
        require(exact_rank(entries) == 4 + c, "Unexpected comparison rank")
        require(exact_rank(quotient) == 2 + c, "Unexpected quotient rank")
        cases.append(
            {
                "c": c,
                "full_k1_comparison_rank": exact_rank(entries),
                "quotient_k1_comparison_rank": exact_rank(quotient),
                "degree_minus_five_image_nonzero": bool(
                    apply_map(tau1, basis(4))
                ),
            }
        )

    r2_hilbert = Counter({0: 1, -1: 1, -3: 1, -4: 1})
    free_shifts = Counter({0: 1, -1: 1})
    require(
        product(r2_hilbert, free_shifts) == hilbert(k2_weights),
        "The K(2) Hilbert factorization failed",
    )
    middle_shifts = (-3, -4)
    rational_shifts = (-5, -6, -8, -9)
    possible = [
        {"source_shift": d, "middle_shift": e}
        for d in rational_shifts
        for e in middle_shifts
        if d == e + 1 - 2
    ]
    require(
        possible == [{"source_shift": -5, "middle_shift": -4}],
        "There is not exactly one possible second-block attachment",
    )
    outer_mapping_lower_bound = min(-2, -4 - 1)
    removed = [shift for shift in rational_shifts if shift < outer_mapping_lower_bound]
    require(removed == [-6, -8, -9], "The rational-summand degree test failed")
    core_degrees = sorted(
        (degree(mask, source_weights) for mask in range(8) if mask not in (5, 6, 7)),
        reverse=True,
    )
    require(core_degrees == [0, -1, -3, -4, -5], "Wrong remaining rational core")

    payload = json.loads((ROOT / "jacobian-payload.json").read_text())
    typed = json.loads((ROOT / "jacobian-output.json").read_text())
    outcome = json.loads((ROOT / "jacobian-status.json").read_text())
    expected = [
        [{"num": str(value.numerator), "den": str(value.denominator)} for value in row]
        for row in matrix((basis(2), basis(4), {7: Fraction(1)}))
    ]
    require(payload["matrix"]["entries"] == expected, "Jacobian payload mismatch")
    require(outcome["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(outcome["timed_out"] is False, "Jacobian operation timed out")
    require(outcome["structured_error"] is None, "Jacobian returned an error")
    require(typed["server"]["version"] == "0.14.0", "Unexpected server version")
    require(typed["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(typed["result"]["output"]["rank"] == 5, "Jacobian rank disagrees")
    require(
        typed["result"]["output"]["matrix"]["entries"] == expected,
        "Jacobian output is bound to another matrix",
    )
    require(
        typed["request"]["operation_id"] == "matrix.rank.compute",
        "Wrong Jacobian operation",
    )

    return {
        "result_class": "finite_verification",
        "scope": "Two exact rational comparison shadows and attachment degree arithmetic",
        "spectrum_level_determined": False,
        "human_proof": "proof.md",
        "human_level_bounds": [2, 3],
        "source_rational_degrees": sorted(degree(mask, source_weights) for mask in range(8)),
        "ring_map_basis_product_checks": identities,
        "commuting_square_basis_checks": 16,
        "cases": cases,
        "possible_second_block_attachment": possible,
        "rational_summands_removed_by_human_fracture_proof": removed,
        "remaining_core_rational_degrees": core_degrees,
        "k2_retained_free_shifts": [0, -1],
        "jacobian": outcome,
        "not_checked": [
            "The actual K(1)-comparison scalar for the chromatic overlap",
            "Realization of either finite algebraic model by spectra",
            "Every possible two-layer presentation and arbitrary retract of one",
            "The universal spectral argument excluding level one",
            "The actual spectral splitting and level-preserving smaller-core reduction",
            "Publication novelty or significance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = replay()
    certificate = ROOT / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(
            json.loads(certificate.read_text()) == result,
            "Exact certificate differs from the rerun",
        )
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
