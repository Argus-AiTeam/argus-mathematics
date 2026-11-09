#!/usr/bin/env python3
"""Replay cut compression and bind its source-specific Lean certificate."""

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


ALG = load("annihilator_arithmetic", HERE.parent / "annihilator/verify.py")
SOURCE = load("protected_source", HERE.parent / "verify.py")
require, xor, dot, rank = ALG.require, ALG.xor, ALG.dot, ALG.rank


def apply(columns, vector):
    return xor(column for j, column in enumerate(columns) if vector >> j & 1)


def independent(vectors):
    result = []
    for vector in vectors:
        if rank(result + [vector]) > len(result):
            result.append(vector)
    return result


def coordinates(vector, basis):
    pivots = {}
    for j, value in enumerate(basis):
        coefficient = 1 << j
        while value:
            pivot = value.bit_length() - 1
            if pivot not in pivots:
                pivots[pivot] = value, coefficient
                break
            old, witness = pivots[pivot]
            value ^= old
            coefficient ^= witness
        require(value != 0, "coordinate family is not independent")
    answer = 0
    while vector:
        pivot = vector.bit_length() - 1
        require(pivot in pivots, "vector is outside the asserted image")
        value, witness = pivots[pivot]
        vector ^= value
        answer ^= witness
    return answer


def compression(vectors, forms, dimension):
    unit = [1 << j for j in range(dimension)]
    fixed = independent(vectors)
    basis = fixed[:]
    for vector in unit:
        if rank(basis + [vector]) > len(basis):
            basis.append(vector)
    image = []
    section = []
    for vector in unit:
        value = xor(dot(form, vector) << j for j, form in enumerate(forms))
        if rank(image + [value]) > len(image):
            image.append(value)
            section.append(vector)
    result = []
    for vector in unit:
        projection = apply(fixed, coordinates(vector, basis) & ((1 << len(fixed)) - 1))
        observation = xor(dot(form, vector ^ projection) << j
                          for j, form in enumerate(forms))
        result.append(projection ^ apply(section, coordinates(observation, image)))
    require(all(apply(result, v) == v for v in vectors), "expanded pin/key moved")
    require(all(dot(f, result[j]) == dot(f, unit[j])
                for f in forms for j in range(dimension)), "expanded form changed")
    require(rank(result) <= rank(vectors) + rank(forms), "block rank bound")
    return result


def specimen():
    p, blocks, n, h = 2, 12, 3, 12
    base = 1 + blocks * n
    primal_dimension = p * base
    nominal_dimension = 2 * (primal_dimension + h)
    edges = [(0, 1), (0, 2), (1, 2)]
    mask = (1 << primal_dimension) - 1

    def primal(i, value):
        return value << (i * (primal_dimension + h))

    def channel(i, value):
        return value << (i * (primal_dimension + h) + primal_dimension)

    def primal_part(value, i):
        return value >> (i * (primal_dimension + h)) & mask

    def channel_part(value, i):
        return value >> (i * (primal_dimension + h) + primal_dimension) & ((1 << h) - 1)

    def embed(label, value):
        return value ^ ((value << base) if label else 0)

    def sliced(value, selector, block):
        return value >> (selector * base + 1 + block * n) & ((1 << n) - 1)

    def form_slice(value, selector, block):
        return sliced(value, selector, block)

    key_vectors = [embed(0, 1 ^ (3 << 1)), embed(1, 1 ^ (3 << (1 + n)))]
    pin_vectors = [5 << (1 + 2 * n), 5 << (base + 1 + 2 * n)]
    frozen = [
        primal(0, pin_vectors[0]) ^ channel(0, 1) ^ channel(1, 2),
        primal(1, pin_vectors[1]) ^ channel(0, 2) ^ channel(1, 1),
        primal(0, key_vectors[0]), primal(1, key_vectors[1]),
    ]
    private = [channel(i, 1 << c) for i in range(2) for c in range(2, h)]
    q_rows = ALG.annihilator(frozen + private, nominal_dimension)

    def q(value):
        return xor(dot(row, value) << j for j, row in enumerate(q_rows))

    chosen = [j for j, row in enumerate(q_rows) if any(primal_part(row, i) for i in range(2))]
    selected_rows = [q_rows[j] for j in chosen[:4]]
    require(len(selected_rows) == 4, "insufficient nontrivial quotient functionals")
    retained = [[primal_part(row, i) for row in selected_rows] for i in range(2)]
    block_maps = []
    for i in range(2):
        vectors = [pin_vectors[i], key_vectors[i]]
        block_maps.append([
            compression(
                [sliced(v, s, b) for v in vectors for s in range(p)],
                [form_slice(f, s, b) for f in retained[i] for s in range(p)], n,
            ) for b in range(blocks)
        ])

    def compress_primal(i, value):
        return xor(
            ((value >> (s * base) & 1) << (s * base)) ^
            xor(apply(block_maps[i][b], sliced(value, s, b)) <<
                (s * base + 1 + b * n) for b in range(blocks))
            for s in range(p)
        )

    def compress_nominal(value):
        return xor(primal(i, compress_primal(i, primal_part(value, i))) ^
                   channel(i, channel_part(value, i)) for i in range(2))

    for vector in frozen + private:
        require(compress_nominal(vector) == vector, "full mixed pin/key/private moved")
    for i in range(2):
        for form in retained[i]:
            require(all(dot(form, compress_primal(i, 1 << j)) == dot(form, 1 << j)
                        for j in range(primal_dimension)), "unexpanded residual form changed")

    q_columns = [q(1 << j) for j in range(nominal_dimension)]
    independent_columns = []
    section = []
    for j, value in enumerate(q_columns):
        if rank(independent_columns + [value]) > len(independent_columns):
            independent_columns.append(value)
            section.append(1 << j)
    quotient_compression = [
        q(compress_nominal(apply(section, coordinates(1 << j, independent_columns))))
        for j in range(len(q_rows))
    ]
    for j in range(nominal_dimension):
        require(q(compress_nominal(1 << j)) == apply(quotient_compression, q_columns[j]),
                "quotient naturality fails")
    actual_primal_ranks = [
        rank(compress_primal(i, 1 << j) for j in range(primal_dimension)) for i in range(2)
    ]
    require(rank(quotient_compression) <= sum(actual_primal_ranks) + 4,
            "protected-channel quotient rank bound")

    def pair_value(left, right, role=0):
        a, b, c, d = (0, 1, 2, 3) if role == 0 else (1, 0, 3, 2)
        return dot(selected_rows[a], left) * dot(selected_rows[b], right) ^ (
            dot(selected_rows[c], left) * dot(selected_rows[d], right))

    point_checks = residual_checks = 0
    cut_generators = [[], []]
    for i, tag, label, active in itertools.product(range(2), range(3), range(2), range(1 << 9)):
        value = 1 ^ (active << 1)
        if (value >> (1 + tag * n)) & ((1 << n) - 1):
            continue
        image = embed(label, value)
        compressed = compress_primal(i, image)
        compressed_base = compressed & ((1 << base) - 1)
        require(compressed == embed(label, compressed_base), "selector changed")
        require(compressed_base & 1, "affine constant changed")
        require(not ((compressed_base >> (1 + tag * n)) & ((1 << n) - 1)),
                "forbidden block is no longer zero")
        point_checks += 1
        require(pair_value(primal(i, compressed), primal(i, compressed)) ==
                pair_value(primal(i, image), primal(i, image)), "residual changed on a point")
        residual_checks += 1
        square = sum(image << (primal_dimension * j)
                     for j in range(primal_dimension) if image >> j & 1)
        pushed = sum(compressed << (primal_dimension * j)
                     for j in range(primal_dimension) if compressed >> j & 1)
        cut = xor(square << (primal_dimension ** 2 * e)
                  for e, edge in enumerate(edges) if tag in edge)
        cut_image = xor(pushed << (primal_dimension ** 2 * e)
                        for e, edge in enumerate(edges) if tag in edge)
        require(xor((cut_image >> (primal_dimension ** 2 * e)) &
                    ((1 << primal_dimension ** 2) - 1) for e in range(3)) == 0,
                "compressed cut violates its triangle identity")
        cut_generators[i].append(cut)
        require(bool(cut) == bool(cut_image), "affine generator disappeared")
    cut_ranks = [rank(generators) for generators in cut_generators]

    frozen_checks = channel_checks = 0
    full_basis = [1 << j for j in range(nominal_dimension)]
    primal_basis = [primal(i, 1 << j) for i in range(2) for j in range(primal_dimension)]
    for role in range(2):
        def correction(value, target, sign):
            compressed = compress_nominal(value)
            a, b = ((0, 2) if sign == "F" else (1, 3))
            if role:
                a, b = a ^ 1, b ^ 1
            return (dot(selected_rows[a], compressed) << (4 + 2 * target)) ^ (
                dot(selected_rows[b], compressed) << (5 + 2 * target))

        def delta(left, right):
            return xor(dot(correction(left, j, "F"), channel_part(right, j))
                       for j in range(2)) ^ xor(
                dot(channel_part(left, j), correction(right, j, "G")) for j in range(2))

        for pin in frozen:
            for value in full_basis:
                require(delta(pin, value) == delta(value, pin) == 0,
                        "simultaneous Gram assembly changed a frozen row/column")
                frozen_checks += 2
        for value, j, c in itertools.product(primal_basis, range(2), range(h)):
            require(delta(value, channel(j, 1 << c)) ==
                    dot(correction(value, j, "F"), 1 << c), "forward Gram channel changed")
            require(delta(channel(j, 1 << c), value) ==
                    dot(1 << c, correction(value, j, "G")), "reciprocal Gram channel changed")
            channel_checks += 2
        compressed_basis = [compress_nominal(value) for value in full_basis]
        for j in range(2):
            left_factors = [correction(value, j, "F") for value in full_basis]
            right_factors = [correction(value, j, "G") for value in full_basis]
            for a, b in itertools.product(range(nominal_dimension), repeat=2):
                require(dot(left_factors[a], right_factors[b]) ==
                        pair_value(compressed_basis[a], compressed_basis[b], role),
                        "pure factor product differs from the compressed pure form")

    return {
        "field": 2, "selectors": p, "blocks": blocks, "coordinates_per_block": n,
        "tags": 3, "endpoints": 2, "active_blocks_enumerated": 3,
        "allowed_affine_point_checks": point_checks, "residual_generator_checks": residual_checks,
        "cut_space_dimensions_in_active_subspace": cut_ranks,
        "primal_compression_ranks": actual_primal_ranks,
        "quotient_compression_rank": rank(quotient_compression),
        "nominal_quotient_dimension": len(q_rows),
        "block_maps": block_maps, "frozen_basis": frozen, "retained_quotient_rows": selected_rows,
        "frozen_basis_entry_checks": frozen_checks, "primal_channel_checks": channel_checks,
        "scope": "Exact active-subspace specimen of the universal compression, not an admissible manuscript construction.",
    }


def formal_binding(directory):
    record = json.loads((directory / "lean_check.json").read_text())
    require(record["status"] == "success" and record["exit_code"] == 0 and
            record["audit_exit_code"] == 0 and record["proof_holes"] == [],
            f"missing real hole-free compiler result: {directory}")
    require("4.31.0" in record["tools"]["lean"]["version"], "wrong Lean version")
    for filename, field in [("Main.lean", "source_sha256"),
                            ("statement_fidelity.md", "statement_fidelity_sha256")]:
        require(hashlib.sha256((directory / filename).read_bytes()).hexdigest() == record[field],
                f"stale source/fidelity binding: {directory / filename}")
    return {
        "record": str((directory / "lean_check.json").relative_to(ROOT)),
        "source_sha256": record["source_sha256"],
        "statement_fidelity_sha256": record["statement_fidelity_sha256"],
        "exit_code": record["exit_code"], "audit_exit_code": record["audit_exit_code"],
        "proof_holes": record["proof_holes"],
    }


def channel_thresholds():
    cases = []
    for p, g, k, j in itertools.product((1, 2), (1, 3), (0, 2), (0, 2)):
        e = g * (g - 1) // 2
        blin = 3 * k + 28
        rres = 14 * k + 140
        dblk = 2 * p * e * (k + 14 + rres)
        dquo = 2 * p * (1 + (g * g + 3) * dblk) + 2 * k
        overhead = 28 * j * e + dquo + 2 * k + 4 * blin
        r0 = overhead // 970 + 1
        require(970 * r0 > overhead and not 970 * (r0 - 1) > overhead,
                "strict manuscript channel threshold")
        pure = 30 * r0 + 28 * j * e + dquo
        require(pure + 2 * k + 4 * blin < 1000 * r0, "derived channel budget")
        cases.append({
            "p": p, "g": g, "E": e, "K": k, "J": j, "Dblk": dblk, "Dquo": dquo,
            "least_r0_for_strict_requirement": r0,
            "spare_channel_rank": 1000 * r0 - 2 * k - 4 * blin - pure,
        })
    return cases


def build_certificate(arithmetic_only):
    anchors, _ = SOURCE.source_anchors()
    result = {
        "schema_version": 1, "claim_id": "G157_CUT_COMPRESSION",
        "result_kind": "source_specific_cut_compression",
        "source_anchors": anchors, "exact_specimen": specimen(),
        "exact_channel_thresholds": channel_thresholds(),
        "limitations": [
            "The specimen is supplementary; the universal statement is the Lean source.",
            "Moment and recipe/key dependencies of complete realization are not discharged by compression alone.",
            "No false manuscript assertion or graph-theoretic counterexample is claimed.",
        ],
    }
    if not arithmetic_only:
        result["formal_evidence"] = formal_binding(HERE)
        result["reviewed_dependencies"] = []
        for directory in (HERE.parent, HERE.parent / "annihilator"):
            dependency = formal_binding(directory)
            compiled = directory / "Main.olean"
            require(compiled.is_file(), f"missing compiled reviewed import: {compiled}")
            dependency["compiled_module"] = str(compiled.relative_to(ROOT))
            dependency["compiled_module_sha256"] = hashlib.sha256(compiled.read_bytes()).hexdigest()
            result["reviewed_dependencies"].append(dependency)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--arithmetic-only", action="store_true")
    args = parser.parse_args()
    require(not (args.write_certificate and args.arithmetic_only),
            "an arithmetic-only run cannot publish a formal certificate")
    result = build_certificate(args.arithmetic_only)
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    if not args.arithmetic_only:
        require(json.loads(path.read_text()) == result, "certificate does not replay exactly")
    specimen_result = result["exact_specimen"]
    print(json.dumps({
        "ok": True, "claim": result["claim_id"], "formal_checked": not args.arithmetic_only,
        "allowed_affine_point_checks": specimen_result["allowed_affine_point_checks"],
        "quotient_compression_rank": specimen_result["quotient_compression_rank"],
        "frozen_basis_entry_checks": specimen_result["frozen_basis_entry_checks"],
        "primal_channel_checks": specimen_result["primal_channel_checks"],
    }))


if __name__ == "__main__":
    main()
