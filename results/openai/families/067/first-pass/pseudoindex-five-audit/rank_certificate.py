#!/usr/bin/env python3
"""Package exact rational witnesses from the independent linear derivation."""

import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def main():
    linear = json.loads((ROOT / "linear_data.json").read_text())
    first = [
        "1", "7", "45", "275", "11", "65", "85", "17", "95", "25", "35"
    ]
    second = [
        "1", "33/5", "41", "245", "11", "63", "85", "17", "93", "25", "35"
    ]
    third = ["1", "11/5", "5", "11", "-1", "-1", "10", "-3", "-1", "0", "14"]
    ha = [1, 4, 16, 64, 6, 24, 4, 3, 12, 48, 192, 768, 17, 68, 272, 96, 9, 36]
    hb = [3, 8, 21, 54, 9, 24, 6, 14, 37, 97, 252, 648, 37, 97, 252, 96, 16, 42]
    certificate = {
        "proof_format": "rational_rank_sandwich",
        "result_class": "exact_verification_theorem",
        "statement": "The actual pseudoindex-five universal-family hypotheses imply 3S^2-20SD+32D^2=0.",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "unassessed",
        "independent_review": "pending",
        "source_shape": [1785, 581],
        "selected_coordinates": 129,
        "cubic_coordinates": 6820,
        "prime": 10007,
        "K": linear["K"],
        "N": linear["N"],
        "product_columns": [
            {"B": first, "H": [str(v) for v in ha]},
            {"B": second, "H": [str(v) for v in ha]},
            {"B": third, "H": [str(Fraction(v, 3)) for v in hb]},
        ],
        "sparse_columns": [
            [5, [15, 15, 15], [3, 0, 0]],
            [7, [15, 15, 15], [1, 0, 0]],
            [9, [15, 15, 15], [-5, 0, 0]],
            [7, [10, 10, 15], [0, 2, 0]],
            [7, [10, 10, 10], [0, 4, 1]],
            [9, [10, 10, 10], [0, 25, 0]],
        ],
        "minor_rows": [
            [0, [0, 0, 0]], [0, [0, 0, 1]], [1, [0, 0, 0]],
            [5, [15, 15, 15]], [7, [10, 10, 15]], [7, [10, 10, 10]],
        ],
        "minor_determinant": "-16/5",
        "proof_method": "Exact QQ kernel identities, a modular dimension upper bound, and six independent QQ cubic columns.",
    }
    (ROOT / "exact_certificate.json").write_text(
        json.dumps(certificate, separators=(",", ":")) + "\n", encoding="ascii"
    )
    print("Packaged rational implication witnesses; verification is still required.")


if __name__ == "__main__":
    main()
