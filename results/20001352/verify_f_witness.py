#!/usr/bin/env python3
"""Exact finite inputs to the two universal proofs in F_counterexample.md."""

import argparse
from dataclasses import dataclass
from fractions import Fraction
import json
from math import prod
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OPERATION = "matrix.rational_linear_system.solve"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    require(isinstance(value, str), "Rationals must be exact strings.")
    number = Fraction(value)
    require(str(number) == value, "Use canonical integer or fraction strings.")
    return number


def power_of_two(number):
    return number > 0 and number & (number - 1) == 0


def slope_exponent(slope):
    require(
        power_of_two(slope.numerator) and power_of_two(slope.denominator),
        "Every slope must be a positive integer power of two.",
    )
    return slope.numerator.bit_length() - slope.denominator.bit_length()


@dataclass(frozen=True)
class Piece:
    left: Fraction
    right: Fraction
    slope: Fraction
    intercept: Fraction

    def at(self, point):
        return self.slope * point + self.intercept

    def as_dict(self):
        return {
            key: str(getattr(self, key))
            for key in ("left", "right", "slope", "intercept")
        }


def verify_membership(document):
    require(isinstance(document, dict), "The witness must be an object.")
    require(
        set(document) == {"name", "segments", "nonidentity_at"},
        "Unexpected or missing witness fields.",
    )
    require(isinstance(document["name"], str) and document["name"], "Missing name.")
    raw_pieces = document["segments"]
    require(isinstance(raw_pieces, list) and raw_pieces, "Missing affine pieces.")
    pieces = []
    fields = ("left", "right", "slope", "intercept")
    for raw in raw_pieces:
        require(isinstance(raw, dict) and set(raw) == set(fields), "Invalid piece.")
        piece = Piece(*(rational(raw[key]) for key in fields))
        require(piece.left < piece.right, "Every interval must have positive length.")
        for number in (piece.left, piece.right, piece.intercept):
            require(power_of_two(number.denominator), "Non-dyadic affine data.")
        slope_exponent(piece.slope)
        pieces.append(piece)

    require(pieces[0].left == 0 and pieces[-1].right == 1, "Domain must be [0,1].")
    for previous, current in zip(pieces, pieces[1:]):
        require(previous.right == current.left, "Domain gap, overlap, or reordering.")
        require(
            previous.at(previous.right) == current.at(current.left),
            "Discontinuous affine pieces.",
        )
    require(pieces[0].at(0) == 0 and pieces[-1].at(1) == 1, "Endpoints must be fixed.")

    affine_intervals = []
    inverse_intervals = []
    for piece in pieces:
        low, high = piece.at(piece.left), piece.at(piece.right)
        require(0 <= low < high <= 1, "Piece image is not increasing inside [0,1].")
        require(
            power_of_two(low.denominator) and power_of_two(high.denominator),
            "Non-dyadic image breakpoint.",
        )
        inverse = Piece(low, high, 1 / piece.slope, -piece.intercept / piece.slope)
        # These are identities of affine coefficients on the entire intervals.
        require(
            inverse.slope * piece.slope == 1
            and inverse.slope * piece.intercept + inverse.intercept == 0
            and piece.slope * inverse.slope == 1
            and piece.slope * inverse.intercept + piece.intercept == 0,
            "Inverse coefficient identity failed.",
        )
        affine_intervals.append(
            {**piece.as_dict(), "image_left": str(low), "image_right": str(high)}
        )
        inverse_intervals.append(inverse.as_dict())

    point = rational(document["nonidentity_at"])
    require(0 <= point <= 1, "Nonidentity point must lie in [0,1].")
    images = [piece.at(point) for piece in pieces if piece.left <= point <= piece.right]
    require(images and all(image == images[0] for image in images), "Ambiguous image.")
    require(images[0] != point, "The supplied point does not witness nonidentity.")
    character = [slope_exponent(pieces[0].slope), slope_exponent(pieces[-1].slope)]
    return pieces, {
        "witness": document["name"],
        "arithmetic": "exact fractions; complete affine intervals; no sampled grid",
        "membership_in_F": True,
        "affine_intervals": affine_intervals,
        "inverse_intervals": inverse_intervals,
        "inverse_identities": "coefficient equality on all domain and image intervals",
        "nonidentity": {"point": str(point), "image": str(images[0])},
        "endpoint_character": character,
    }


def canonical_pair(value):
    return {"num": str(value.numerator), "den": str(value.denominator)}


def verify_jacobian(pieces, payload, result):
    entries, rhs = [], []
    for index, piece in enumerate(pieces):
        for point in (piece.left, piece.right):
            row = [Fraction(0)] * (2 * len(pieces))
            row[2 * index] = point
            row[2 * index + 1] = Fraction(1)
            entries.append([canonical_pair(value) for value in row])
            rhs.append(canonical_pair(piece.at(point)))
    expected = {"matrix": {"domain": "QQ", "entries": entries}, "rhs": rhs}
    require(payload == expected, "Jacobian payload does not encode this witness.")
    require(result["operation_id"] == OPERATION, "Unexpected Jacobian operation.")
    output = result["output"]
    require(
        output["matrix"] == payload["matrix"] and output["rhs"] == payload["rhs"],
        "Jacobian result is bound to different input.",
    )
    require(output["outcome"] == "UNIQUE", "Jacobian did not return a unique solution.")
    coefficients = [value for piece in pieces for value in (piece.slope, piece.intercept)]
    require(
        output["solution"] == [canonical_pair(value) for value in coefficients],
        "Jacobian affine coefficients disagree with the witness.",
    )

    def decode(value):
        return Fraction(int(value["num"]), int(value["den"]))

    residuals = [
        sum(decode(entry) * coefficient for entry, coefficient in zip(row, coefficients))
        - decode(target)
        for row, target in zip(entries, rhs)
    ]
    require(all(residual == 0 for residual in residuals), "Nonzero exact residual.")
    determinant = prod(piece.left - piece.right for piece in pieces)
    require(determinant != 0, "Affine interpolation system is singular.")
    return {
        "operation_id": OPERATION,
        "payload_bound_to_witness": True,
        "outcome": output["outcome"],
        "exact_residuals": [str(value) for value in residuals],
        "block_diagonal_determinant": str(determinant),
        "scope": "affine coefficients only",
    }


def certify(document, route):
    require(route in {"involutions", "commutators"}, "Unknown obstruction route.")
    pieces, report = verify_membership(document)
    report["route"] = route
    report["finite_certificate_status"] = "verified"
    report["independent_review"] = "pending; universal proofs require mathematical reading"
    if route == "involutions":
        report["obstruction"] = {
            "verified_inputs": "strict order preservation and a nonidentity point",
            "universal_argument": "An increasing map with h^2=id must be id.",
            "consequence": "No finite involution factorization in F, even with identity factors.",
            "proof": "research/F_counterexample.md#route-r-involutions-order-preservation",
        }
    else:
        require(report["endpoint_character"] != [0, 0], "Zero character is not an obstruction.")
        report["obstruction"] = {
            "verified_inputs": "nonzero exact endpoint-slope exponent pair",
            "universal_argument": "The character is additive and annihilates every commutator.",
            "consequence": "No finite commutator factorization in F.",
            "proof": "research/F_counterexample.md#route-r-character-endpoint-slopes",
        }
    return pieces, report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--route", choices=("involutions", "commutators"), required=True)
    parser.add_argument("--witness", type=Path, default=ROOT / "evidence/f_witness.json")
    args = parser.parse_args()
    pieces, report = certify(json.loads(args.witness.read_text()), args.route)
    folder = ROOT / "evidence/jacobian"
    report["jacobian_replay"] = verify_jacobian(
        pieces,
        json.loads((folder / "affine-system.payload.json").read_text()),
        json.loads((folder / "affine-system.result.json").read_text()),
    )
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
