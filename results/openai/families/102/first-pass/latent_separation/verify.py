#!/usr/bin/env python3
"""Exact finite diagnostics; these do not certify the full latent lemma."""

import argparse
import copy
import itertools
import json
import math
import sys
from fractions import Fraction
from pathlib import Path


class InvalidCertificate(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise InvalidCertificate(message)


def integer(value, low, high, name):
    require(type(value) is int and low <= value <= high, f"invalid {name}")
    return value


def keys(value, expected, name):
    require(type(value) is dict and set(value) == set(expected), f"invalid {name} fields")


def polynomial_remainder(a, b):
    require(b > 0, "zero polynomial divisor")
    while a and a.bit_length() >= b.bit_length():
        a ^= b << (a.bit_length() - b.bit_length())
    return a


def polynomial_gcd(a, b):
    while b:
        a, b = b, polynomial_remainder(a, b)
    return a


class BinaryField:
    def __init__(self, degree, modulus):
        self.d = integer(degree, 1, 16, "field degree")
        self.q = 1 << degree
        self.modulus = integer(modulus, self.q, 2 * self.q - 1, "field modulus")
        power = polynomial_remainder(2, modulus)
        for i in range(1, degree + 1):
            power = self.mul(power, power)
            if i <= degree // 2:
                require(polynomial_gcd(power ^ 2, modulus) == 1, "reducible modulus")
        require(power == polynomial_remainder(2, modulus), "reducible modulus")

    def mul(self, a, b):
        result = 0
        while b:
            if b & 1:
                result ^= a
            a <<= 1
            if a & self.q:
                a ^= self.modulus
            b >>= 1
        return result

    def power(self, a, n):
        result = 1
        while n:
            if n & 1:
                result = self.mul(result, a)
            a = self.mul(a, a)
            n >>= 1
        return result

    def trace(self, a):
        result = 0
        for _ in range(self.d):
            result ^= a
            a = self.mul(a, a)
        require(result in (0, 1), "trace left the prime field")
        return result

    def dot(self, a, b):
        result = 0
        for x, y in zip(a, b, strict=True):
            result ^= self.mul(x, y)
        return result

    def rank(self, rows):
        require(bool(rows) and all(len(row) == len(rows[0]) for row in rows), "ragged matrix")
        matrix = [list(row) for row in rows]
        rank = 0
        for column in range(len(matrix[0])):
            pivot = next((i for i in range(rank, len(matrix)) if matrix[i][column]), None)
            if pivot is None:
                continue
            matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
            inverse = self.power(matrix[rank][column], self.q - 2)
            matrix[rank] = [self.mul(x, inverse) for x in matrix[rank]]
            for i in range(rank + 1, len(matrix)):
                factor = matrix[i][column]
                if factor:
                    matrix[i] = [
                        x ^ self.mul(factor, y)
                        for x, y in zip(matrix[i], matrix[rank], strict=True)
                    ]
            rank += 1
            if rank == len(matrix):
                break
        return rank

    def normalize_line(self, vector):
        pivot = next((x for x in vector if x), None)
        require(pivot is not None, "zero has no projective line")
        inverse = self.power(pivot, self.q - 2)
        return tuple(self.mul(x, inverse) for x in vector)


def add(a, b):
    return tuple(x ^ y for x, y in zip(a, b, strict=True))


def quadratic(field, x):
    return (field.mul(x[1], x[2]), field.mul(x[0], x[2]), field.mul(x[0], x[1]))


def binary_basis(vectors):
    pivots = {}
    for vector in vectors:
        while vector:
            pivot = vector.bit_length() - 1
            if pivot not in pivots:
                pivots[pivot] = vector
                break
            vector ^= pivots[pivot]
    return list(pivots.values())


def binary_span(basis):
    span = {0}
    for vector in basis:
        span |= {x ^ vector for x in span}
    return span


def generic_space(field, basis, bound):
    r = len(basis)
    images = [tuple(0 for _ in range(3))]
    for vector in basis:
        images += [add(x, vector) for x in images]
    require(len(set(images)) == 1 << r, "basis is not binary independent")
    lines = [field.normalize_line(z) for z in images[1:]]
    require(len(set(lines)) == len(lines), "two distinct nonzero characters are field-proportional")
    require(bound == 3 * r, "alignment bound is not the manuscript's 3r")
    size = bound + 1
    require(size <= len(images) - 1, "vacuous alignment certificate is not admissible")
    matrix = {}
    cubic = {}
    for t, z in enumerate(images[1:], 1):
        matrix[t] = [
            field.mul(z[i], z[i]) if (t >> j) & 1 else 0
            for i in range(3)
            for j in range(r)
        ]
        cubic[t] = field.mul(field.mul(z[0], z[1]), z[2])
    gaps = []
    for subset in itertools.combinations(range(1, 1 << r), size):
        rows = [matrix[t] for t in subset]
        augmented = [matrix[t] + [cubic[t]] for t in subset]
        gap = field.rank(augmented) - field.rank(rows)
        require(gap == 1, f"an extension map aligns on {size} characters: inputs {subset}")
        gaps.append(gap)
    return {"checked_subsets": len(gaps), "minimum_augmented_rank_gap": min(gaps)}


def block_diagnostics():
    field = BinaryField(2, 7)
    vectors = list(itertools.product(range(field.q), repeat=3))
    lines = sorted({field.normalize_line(v) for v in vectors if any(v)})
    require(len(lines) == field.q**2 + field.q + 1, "wrong projective-line count")
    traces = {
        vector: sum(
            field.trace(field.mul(vector[i], 1 << j)) << (field.d * i + j)
            for i in range(3)
            for j in range(field.d)
        )
        for vector in vectors
    }
    kernel_checks = 0
    update_checks = 0
    for v in lines:
        hyperplane = [w for w in vectors if field.dot(v, w) == 0]
        updates = []
        encoded = set()
        for scalar in range(field.q):
            a = tuple(field.mul(scalar, x) for x in v)
            for w in hyperplane:
                y = add(quadratic(field, a), w)
                updates.append((a, w))
                encoded.add(sum(x << (field.d * i) for i, x in enumerate(a + y)))
        basis = binary_basis(encoded)
        require(len(basis) == 3 * field.d and binary_span(basis) == encoded, "U_A is not binary linear")
        unchanged = 0
        total = 0
        for a, w in updates:
            if not any(a) and not any(w):
                continue
            for x in vectors:
                polar = add(add(quadratic(field, add(x, a)), quadratic(field, x)), quadratic(field, a))
                require(field.dot(v, polar) == 0, "polar response left D_A")
                unchanged += polar == w
                total += 1
        require(Fraction(unchanged, total) == Fraction(1, len(lines)), "wrong nonlinear response law")
        update_checks += total
        for z in vectors[1:]:
            sqrt_product = field.power(field.mul(field.mul(z[0], z[1]), z[2]), 1 << (field.d - 1))
            for gx in vectors:
                mask = traces[gx] | (traces[z] << (3 * field.d))
                vanishes = all((mask & row).bit_count() % 2 == 0 for row in basis)
                predicted = field.normalize_line(z) == v and field.dot(z, gx) == sqrt_product
                require(vanishes == predicted, "block kernel criterion failed")
                kernel_checks += 1
    return {
        "field_size": field.q,
        "lines": len(lines),
        "nonzero_update_input_pairs": update_checks,
        "linear_kernel_checks": kernel_checks,
        "unchanged_probability": "1/21",
    }


def verify(data):
    keys(data, ("schema_version", "result_class", "field", "basis", "alignment_bound", "subset_count"), "certificate")
    require(data["schema_version"] == 1 and type(data["schema_version"]) is int, "unsupported schema")
    require(data["result_class"] == "finite_verification", "finite certificate mislabeled")
    keys(data["field"], ("degree", "modulus"), "field")
    field = BinaryField(data["field"]["degree"], data["field"]["modulus"])
    require(type(data["basis"]) is list and len(data["basis"]) == 4, "this certificate requires rank four")
    basis = []
    for row in data["basis"]:
        require(type(row) is list and len(row) == 3, "basis vectors must have three coordinates")
        basis.append(tuple(integer(x, 0, field.q - 1, "field element") for x in row))
    bound = integer(data["alignment_bound"], 0, 3 * len(basis), "alignment bound")
    count = integer(data["subset_count"], 1, 1000, "subset count")
    require(count == math.comb((1 << len(basis)) - 1, bound + 1), "wrong subset count")
    result = generic_space(field, basis, bound)
    require(result["checked_subsets"] == count, "incomplete subset enumeration")
    return {"field_size": field.q, "binary_rank": len(basis), **result}


def reject_duplicate_keys(pairs):
    result = {}
    for name, value in pairs:
        require(name not in result, f"duplicate JSON key {name}")
        result[name] = value
    return result


def reject_constant(value):
    raise InvalidCertificate(f"non-JSON constant {value}")


def rejection_tests(data):
    mutations = []
    for key, value in (("alignment_bound", 0), ("subset_count", 1), ("result_class", "new_theorem")):
        changed = copy.deepcopy(data)
        changed[key] = value
        mutations.append(changed)
    for key, value in (("degree", True), ("modulus", 256)):
        changed = copy.deepcopy(data)
        changed["field"][key] = value
        mutations.append(changed)
    for replacement in ([0, 0, 0], data["basis"][0], [999999, 0, 0], [True, 0, 0]):
        changed = copy.deepcopy(data)
        changed["basis"][1] = replacement
        mutations.append(changed)
    for changed in mutations:
        try:
            verify(changed)
        except InvalidCertificate:
            continue
        raise InvalidCertificate("an inadmissible mutation was accepted")
    return len(mutations)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=Path(__file__).with_name("exact_certificate.json"))
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--candidate", action="store_true", help="print a deterministic Frobenius-graph candidate")
    parser.add_argument("--jacobian-payload", action="store_true", help="print the exact degree-three Boolean evaluation matrix")
    args = parser.parse_args()
    if args.candidate:
        field = BinaryField(8, 283)
        print(json.dumps({"schema_version": 1, "result_class": "finite_verification",
                          "field": {"degree": 8, "modulus": 283},
                          "basis": [[x, field.power(x, 2), field.power(x, 4)] for x in (1, 2, 4, 8)],
                          "alignment_bound": 12, "subset_count": 105}, indent=2))
        return 0
    if args.jacobian_payload:
        columns = [mask for mask in range(1, 16) if mask.bit_count() <= 3]
        matrix = [[int((t & mask) == mask) for mask in columns] for t in range(1, 16)]
        print(json.dumps({"matrix": {"prime": 2, "columns": len(columns), "entries": matrix}}, indent=2))
        return 0
    try:
        data = json.loads(args.certificate.read_text(), object_pairs_hook=reject_duplicate_keys,
                          parse_constant=reject_constant)
        generic = verify(data)
        block = block_diagnostics()
        rejected = rejection_tests(data) if args.self_test else 0
    except (InvalidCertificate, json.JSONDecodeError, OSError) as exc:
        print(f"verification failed: {exc}", file=sys.stderr)
        return 1
    print(json.dumps({"certificate_valid": True, "result_class": "finite_verification",
                      "generic_subspace": generic, "quadratic_block": block,
                      "inadmissible_mutations_rejected": rejected,
                      "scope": "Exact finite diagnostics only; not a parameter-uniform proof of lem:latent."},
                     sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
