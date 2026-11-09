#!/usr/bin/env python3
"""Untrusted witness proposer; verify.py never imports this or the manuscript."""

import argparse
import json
import time
from fractions import Fraction
from math import gcd, isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
UPSTREAM = (
    ROOT
    / "research/openai_manuscript"
    / "Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026"
    / "verification/verify.py"
)


def subtract_mod(target, row, coefficient, prime):
    for coordinate, value in row.items():
        result = (target.get(coordinate, 0) - coefficient * value) % prime
        if result:
            target[coordinate] = result
        else:
            target.pop(coordinate, None)


def modular_duals(rows, targets, prime):
    echelon = {}
    tape = []
    for row in rows:
        work = {k: v % prime for k, v in row.items() if v % prime}
        operations = []
        while work:
            pivot = max(work)
            coefficient = work[pivot]
            if pivot not in echelon:
                inverse = pow(coefficient, -1, prime)
                number = len(tape)
                echelon[pivot] = (
                    number,
                    {k: value * inverse % prime for k, value in work.items()},
                )
                tape.append((inverse, operations))
                break
            number, known = echelon[pivot]
            operations.append((number, coefficient))
            subtract_mod(work, known, coefficient, prime)
        else:
            raise ValueError("selected witness rows are dependent modulo this prime")
    outputs = []
    for target in targets:
        work = {
            k: value.numerator * pow(value.denominator, -1, prime) % prime
            for k, value in target.items()
        }
        coordinates = [0] * len(tape)
        while work:
            pivot = max(work)
            if pivot not in echelon:
                raise ValueError("target is outside proposed row span")
            number, known = echelon[pivot]
            coefficient = work[pivot]
            coordinates[number] = (coordinates[number] + coefficient) % prime
            subtract_mod(work, known, coefficient, prime)
        result = [0] * len(tape)
        for number in reversed(range(len(tape))):
            inverse, operations = tape[number]
            value = coordinates[number] * inverse % prime
            result[number] = value
            for earlier, coefficient in operations:
                coordinates[earlier] = (
                    coordinates[earlier] - value * coefficient
                ) % prime
        outputs.append(result)
    return outputs


def reconstruct(value, modulus):
    bound = isqrt(modulus // 2)
    old, remainder = modulus, value
    old_denominator, denominator = 0, 1
    while abs(remainder) > bound:
        quotient = old // remainder
        old, remainder = remainder, old - quotient * remainder
        old_denominator, denominator = (
            denominator,
            old_denominator - quotient * denominator,
        )
    if not denominator or abs(denominator) > bound:
        return None
    fraction = Fraction(remainder, denominator)
    if gcd(fraction.denominator, modulus) != 1:
        return None
    if (fraction.numerator - value * fraction.denominator) % modulus:
        return None
    return fraction


def exact_duals_hold(rows, targets, duals):
    for target, coefficients in zip(targets, duals):
        total = {}
        for row, coefficient in zip(rows, coefficients):
            if not coefficient:
                continue
            for key, value in row.items():
                result = total.get(key, Fraction(0)) + coefficient * value
                if result:
                    total[key] = result
                else:
                    total.pop(key, None)
        if total != target:
            return False
    return True


def propose(output):
    start = time.monotonic()
    source = UPSTREAM.read_text().split("\ndef normalize(c):", 1)[0]
    namespace = {"__name__": "untrusted_manuscript_proposer"}
    exec(compile(source, str(UPSTREAM), "exec"), namespace)
    raw_arrays = []
    original_expand = namespace["expand_degree1"]

    def capture_boundary(matrix, source_row):
        if len(matrix) == 7:
            raw_arrays.append(matrix)
        return original_expand(matrix, source_row)

    namespace["expand_degree1"] = capture_boundary
    namespace["eliminate"] = lambda rows, keys: (rows, keys)
    relations, keys = namespace["pairtable"]()
    print(json.dumps({"phase": "generated", "relations": len(relations),
                      "coordinates": len(keys),
                      "seconds": time.monotonic() - start}), flush=True)
    numbering = {key: index for index, key in enumerate(keys)}
    integer_rows, origins, scales = [], {}, {}
    for matrix, relation in zip(raw_arrays, relations):
        if not relation:
            continue
        denominator, integer_relation = namespace["intscale"](relation)
        row = {numbering[key]: value for key, value in integer_relation.items()}
        integer_rows.append(row)
        origins[id(row)] = matrix
        scales[id(row)] = denominator
    _, witnesses = namespace["echelon"](integer_rows, 1000000007)
    namespace["Epair"] = {key: {key: 1} for key in keys}
    alpha = (1, 1, 1, -1, -1, -1)
    w = (-3, -2, 0, 1, 2, 2)
    auxiliary = [
        (-1, -1, 0, 0, 1, 1),
        (-2, 0, 0, 0, 1, 1),
        (-1, -1, 0, 1, 0, 1),
        (-1, -1, 0, 1, 1, 0),
    ]
    terms = [(-1, (w,))] + [
        (coefficient, (charge, tuple(x - y for x, y in zip(w, charge))))
        for coefficient, charge in zip((2, 1, 1, 1), auxiliary)
    ]
    square = {}
    for c, left in terms:
        for d, right in terms:
            charges = left + tuple(tuple(-x for x in a) for a in right)
            namespace["add"](square, namespace["apair"](*charges), 3 * c * d)
    q_charges = ((2, 0, 0, -2, 0, 0), (2, -2, 0, 0, 0, 0))
    targets = []
    for charge in q_charges:
        target = square.copy()
        namespace["add"](
            target,
            namespace["apair"](
                alpha, charge, tuple(-x for x in alpha), tuple(-x for x in charge)
            ),
        )
        targets.append({numbering[key]: Fraction(value) for key, value in target.items()})

    residues = None
    modulus = 1
    duals = None
    for prime in (1000000007, 1000000009, 998244353, 1000003,
                  2013265921, 754974721, 32452843, 86028121):
        proposed = modular_duals(witnesses, targets, prime)
        if residues is None:
            residues = proposed
        else:
            inverse = pow(modulus, -1, prime)
            residues = [
                [
                    old + ((new - old) * inverse % prime) * modulus
                    for old, new in zip(old_vector, new_vector)
                ]
                for old_vector, new_vector in zip(residues, proposed)
            ]
        modulus *= prime
        reconstructed = [
            [reconstruct(value, modulus) for value in vector]
            for vector in residues
        ]
        if all(value is not None for vector in reconstructed for value in vector):
            if exact_duals_hold(witnesses, targets, reconstructed):
                duals = reconstructed
                break
        print(json.dumps({"phase": "lifting", "modulus_bits": modulus.bit_length(),
                          "seconds": time.monotonic() - start}), flush=True)
    if duals is None:
        raise ValueError("bounded rational reconstruction did not yield an exact dual")

    boundary_witnesses = []
    for index, row in enumerate(witnesses):
        coefficients = [
            dual[index] * scales[id(row)]
            for dual in duals
        ]
        if any(coefficients):
            boundary_witnesses.append({
                "matrix": origins[id(row)],
                "contracted_row": 0,
                "coefficients": [str(value) for value in coefficients],
            })
    certificate = {
        "format": "pair-boundary-dual-v1",
        "result_class": "exact_verification_theorem",
        "source_assertion": "02-pair-moments.tex, Proposition prop:pair-certificate",
        "alpha": alpha,
        "w": w,
        "auxiliary": auxiliary,
        "auxiliary_coefficients": [2, 1, 1, 1],
        "q_charges": q_charges,
        "boundary_witnesses": boundary_witnesses,
        "proposer_metadata": {
            "trusted_by_checker": False,
            "raw_equations": len(relations),
            "nonzero_equations": len(integer_rows),
            "coordinates": len(keys),
            "selected_rows": len(witnesses),
            "modulus_bits": modulus.bit_length(),
        },
    }
    output.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({"phase": "certificate_written", "path": str(output),
                      "boundary_witnesses": len(boundary_witnesses),
                      "seconds": time.monotonic() - start}), flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path,
                        default=HERE / "exact_certificate.json")
    propose(parser.parse_args().output)
