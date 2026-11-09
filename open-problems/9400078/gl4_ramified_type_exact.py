#!/usr/bin/env python3
"""Exact polynomial and conductor diagnostics, not a density theorem."""

import argparse
import json
import sys
from collections import Counter
from fractions import Fraction
from pathlib import Path

sys.dont_write_bytecode = True
from gl4_degree20_exact import (
    add,
    inclusion_matrix,
    rational_pivots,
    require_equal,
    tensor,
)


def substitute(polynomial, images):
    result = Counter()
    for exponents, coefficient in polynomial.items():
        image = tuple(
            sum(exponents[i] * images[i][j] for i in range(len(images)))
            for j in range(len(images[0]))
        )
        result[image] += coefficient
    return add({}, result)


def power_sum(index):
    if index == 0:
        return Counter({(0, 0, 0): 2})
    return Counter({(0, index, 0): 1, (0, 0, index): 1})


def encode(polynomial):
    return {
        "domain": "QQ",
        "variables": ["b", "x", "y"],
        "polynomial": {
            "terms": [
                {"coefficient": {"num": str(c), "den": "1"}, "exponents": list(e)}
                for e, c in sorted(polynomial.items(), reverse=True)
                if c
            ]
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--index", type=int, default=3)
    parser.add_argument("--emit-payload", type=Path)
    args = parser.parse_args()
    k = args.index
    if k < 1:
        parser.error("--index must be positive")

    b = Counter({(1, 0, 0): 1})
    x = Counter({(0, 1, 0): 1})
    y = Counter({(0, 0, 1): 1})
    cutoff = Counter({
        (2, 1, 1): 1,
        (0, 1, 1): 1,
        (1, 2, 0): -1,
        (1, 0, 2): -1,
    })
    factored = tensor(add(tensor(b, x), y, -1), add(tensor(b, y), x, -1))
    require_equal(factored, cutoff, "b B=(b x-y)(b y-x)")

    pk = power_sum(k)
    h = tensor(cutoff, pk)
    square = tensor(h, h)
    require_equal(
        substitute(h, ((1, 0, 0), (0, 0, 1), (0, 1, 0))),
        h,
        "Weyl symmetry",
    )
    for images in (((1, 0), (1, 1), (0, 1)),
                   ((1, 0), (0, 1), (1, 1))):
        require_equal(substitute(h, images), Counter(), "Steinberg cutoff")
    require_equal(
        substitute(pk, ((1, 0), (1, 1), (0, 1))),
        Counter({(k, k): 1, (0, k): 1}),
        "unfiltered value at (x,y)=(b u,u)",
    )

    complementary = substitute(cutoff, ((1, 0), (0, 1), (0, -1)))
    require_equal(
        complementary,
        Counter({(2, 0): 1, (0, 0): 1, (1, 2): -1, (1, -2): -1}),
        "complementary-series normalization",
    )
    if k >= 2:
        recurrence = add(
            tensor(add(x, y), power_sum(k - 1)),
            tensor(tensor(x, y), power_sum(k - 2)),
            -1,
        )
        require_equal(recurrence, pk, "power-sum recurrence")
    require_equal({e[1] + e[2] for e, c in h.items() if c},
                  {k + 2}, "Bernstein degree, not spatial support")

    differential = inclusion_matrix()
    wedge_n = [[differential[6 * i + j][1] for j in range(6)] for i in range(6)]
    expected_n = [[0] * 6 for _ in range(6)]
    expected_n[1][3] = 1
    expected_n[2][4] = 1
    require_equal(wedge_n, expected_n, "exterior square of N=E_01")
    require_equal(len(rational_pivots(wedge_n)), 2, "exterior-square monodromy rank")

    tau = Fraction(1, 8)
    transfer_exponent = 24 - 96 * tau
    target_exponent = 3 - 4 * tau
    require_equal(transfer_exponent - target_exponent, Fraction(19, 2),
                  "favorable transfer comparison at tau=1/8")

    payload = {"polynomial": encode(square), "summands": [encode(h)]}
    if args.emit_payload:
        args.emit_payload.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps({
        "result_class": "exact_algebraic_verification",
        "index": k,
        "variables": ["b", "x", "y"],
        "normalization": "b*h_k=(b*x-y)(b*y-x)(x^k+y^k)",
        "factorization_verified": True,
        "weyl_symmetry_verified": True,
        "both_steinberg_branches_annihilated": True,
        "complementary_specialization_verified": True,
        "bernstein_degree": k + 2,
        "bernstein_degree_is_not_a_geometric_support_bound": True,
        "square": encode(square),
        "wedge_rank_one_monodromy_matrix": wedge_n,
        "wedge_rank_one_monodromy_rank": 2,
        "transfer_comparison_at_tau_1_over_8": {
            "transferred_distinct_representation_exponent": str(transfer_exponent),
            "target_exponent": str(target_exponent),
            "difference": str(transfer_exponent - target_exponent),
            "transfer_fibre_bound_proved": False,
        },
        "all_indices_proved_by_this_finite_run": False,
        "analytic_estimate_proved": False,
        "density_theorem_proved": False,
        "novelty_verified": False,
    }, indent=2))


if __name__ == "__main__":
    main()
