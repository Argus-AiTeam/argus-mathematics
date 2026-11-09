#!/usr/bin/env python3
"""Replay an exact paired-cut specimen and bind the universal Lean certificate."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BASE = 2
PRIMAL = 4
CHANNEL = 3
NOMINAL = 2 * (PRIMAL + CHANNEL)
EDGES = [(0, 1), (0, 2), (1, 2)]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def xor(values):
    result = 0
    for value in values:
        result ^= value
    return result


def dot(left, right):
    return (left & right).bit_count() & 1


def reduced_basis(vectors):
    pivots = {}
    for value in vectors:
        for pivot in sorted(pivots, reverse=True):
            if value >> pivot & 1:
                value ^= pivots[pivot]
        if not value:
            continue
        pivot = value.bit_length() - 1
        for old in pivots:
            if pivots[old] >> pivot & 1:
                pivots[old] ^= value
        pivots[pivot] = value
    return [pivots[pivot] for pivot in sorted(pivots)]


def rank(vectors):
    return len(reduced_basis(vectors))


def span(vectors):
    result = [0]
    for value in reduced_basis(vectors):
        result += [old ^ value for old in result]
    return set(result)


def annihilator(vectors, dimension):
    rows = reduced_basis(vectors)
    pivots = {row.bit_length() - 1 for row in rows}
    result = []
    for free in range(dimension):
        if free in pivots:
            continue
        value = 1 << free
        for row in rows:
            if dot(row, value):
                value ^= 1 << (row.bit_length() - 1)
        require(all(dot(row, value) == 0 for row in rows), "nullspace construction")
        result.append(value)
    require(len(result) + len(rows) == dimension, "rank-nullity")
    return result


def primal(endpoint, value):
    return value << (endpoint * (PRIMAL + CHANNEL))


def channel(endpoint, value):
    return value << (endpoint * (PRIMAL + CHANNEL) + PRIMAL)


def project_primal(value, endpoint):
    return value >> (endpoint * (PRIMAL + CHANNEL)) & ((1 << PRIMAL) - 1)


def project_channel(value, endpoint):
    return value >> (endpoint * (PRIMAL + CHANNEL) + PRIMAL) & ((1 << CHANNEL) - 1)


def point_square(value, dimension):
    return [value if value >> coordinate & 1 else 0 for coordinate in range(dimension)]


def baseline(value, mode):
    first = value & 1
    second = value >> (PRIMAL + CHANNEL) & 1
    return (first << (1 + mode)) ^ (second << (2 - mode))


def exact_specimen():
    pins = [
        primal(0, 1),
        primal(1, 1),
        primal(0, 2) ^ primal(1, 2) ^ channel(0, 1) ^ channel(1, 2),
    ]
    private = [channel(0, 2), channel(0, 4), channel(1, 1), channel(1, 4)]
    selected = [(1, 0, 3), (1, 1, 1)]
    protected_target = [1]
    pin_bound = rank(pins)
    rank_bound = 2 * (pin_bound + 20)
    pin_space = span(pins)
    require(pin_bound == 3, "nominal pin dimension")
    projected = [[project_primal(pin, i) for pin in pins] for i in range(2)]
    injection_checks = 0
    sparse_checks = 0
    intersections = []
    for i in range(2):
        pure_pins = [value for value in pin_space if value == primal(i, project_primal(value, i))]
        intersections.append(rank(pure_pins))
        require(rank(projected[i]) == 2 and rank(pure_pins) == 1,
                "specimen must distinguish projected pins from actual intersections")
        h0 = [project_channel(pin, i) for pin in pins]
        h1 = [project_channel(value, i) for value in private]
        require(rank(h0 + h1) == rank(h0) + rank(h1) == CHANNEL,
                "private channel complement")
        for mode in range(2):
            for value in pure_pins:
                injection_checks += 1
                require(baseline(value, mode) not in span(protected_target) or value == 0,
                        "injecting table on the actual pin intersection")

    q, r = point_square(1, BASE), point_square(3, BASE)
    blocks = [[0, 0], q, r, [a ^ b for a, b in zip(q, r)]]
    moment_checks = 0
    for left, right in itertools.product(blocks, repeat=2):
        full = [left[0], left[1], right[0] << 2, right[1] << 2]
        support = int(any(left)) + int(any(right))
        require(rank(full) == rank(left) + rank(right), "direct label-block rank")
        require(support <= rank(full) <= rank_bound, "low-rank label support")
        for block in (left, right):
            require(all(((block[i] >> j) & 1) == ((block[j] >> i) & 1)
                        for i in range(BASE) for j in range(BASE)), "symmetric Boolean block")
            require(all(((block[i] >> i) & 1) == ((block[i] >> 0) & 1)
                        for i in range(BASE)), "Boolean diagonal identity")
        moment_checks += 1

    interpolation_checks = 0
    for size in range(3):
        for labels in itertools.combinations(range(2), size):
            columns = [1 << (2 * label + j) for label in labels for j in range(BASE)]
            require(rank(columns) == BASE * len(labels), "local label interpolation")
            interpolation_checks += 1
            for coefficients in itertools.product(range(1 << BASE), repeat=size):
                value = xor(coefficient << (BASE * label)
                            for label, coefficient in zip(labels, coefficients))
                for i in range(2):
                    for _mode, _edge in itertools.product(range(2), EDGES):
                        sparse_checks += 1
                        if value in span(projected[i]) and 1 in labels:
                            require(coefficients[labels.index(1)] == 0,
                                    "selected label in sparse projected pin")

    generators = [
        (i, label, base, tag)
        for i in range(2) for label in range(2)
        for base, tag in [(1, 0), (1, 1), (3, 0)]
    ]
    dimension = len(generators)
    flattened = []
    for i, label, base, tag in generators:
        require(base & 1 and (tag == 0 or base == 1), "tag-admissible affine generator")
        vector = base << (BASE * label)
        matrix = point_square(vector, PRIMAL)
        flat = 0
        for edge_index, edge in enumerate(EDGES):
            if tag in edge:
                for row, value in enumerate(matrix):
                    flat ^= value << ((i * len(EDGES) + edge_index) * PRIMAL**2 + row * PRIMAL)
        flattened.append(flat)
    require(rank(flattened) == dimension == 12, "faithful cut-profile basis")

    response_rows = []
    component_dimensions = []
    for edge in EDGES:
        keys = [
            primal(i, base << (BASE * label))
            for i, (label, tag, base) in enumerate(selected) if tag in edge
        ]
        frozen = pins + private + keys
        quotient = annihilator(frozen, NOMINAL)
        require(
            all(rank(projected[i]) + len([key for key in keys if project_primal(key, i)])
                <= pin_bound + 14 for i in range(2)),
            "pin/key budget",
        )
        component_dimensions.append({
            "edge": list(edge), "frozen_dimension": rank(frozen),
            "quotient_dimension": len(quotient),
        })
        nominal_vectors = [primal(i, base << (BASE * label))
                           for i, label, base, tag in generators]
        incidence = [int(tag in edge) for i, label, base, tag in generators]
        for alpha, beta in itertools.product(quotient, repeat=2):
            response_rows.append(xor(
                (incident & dot(alpha, value) & dot(beta, value)) << j
                for j, (value, incident) in enumerate(zip(nominal_vectors, incidence))
            ))
        for mode, c, phi in itertools.product(
                range(2), annihilator(protected_target, CHANNEL), quotient):
            response_rows.append(xor(
                (incident & dot(c, baseline(value, mode)) & dot(phi, value)) << j
                for j, (value, incident) in enumerate(zip(nominal_vectors, incidence))
            ))

    effective = [1 << j for j, (_i, label, _base, _tag) in enumerate(generators) if label == 0]
    atoms = []
    for i, (label, tag, base) in enumerate(selected):
        atoms.append(1 << generators.index((i, label, base, tag)))
    expected = effective + atoms
    expected_space = span(expected)
    kernel_basis = annihilator(response_rows, dimension)
    require(rank(effective) == 6 and rank(expected) == 8, "effective plus selected dimension")
    require(rank(response_rows) + len(kernel_basis) == dimension, "paired response rank-nullity")
    require(span(kernel_basis) <= expected_space, "paired annihilator escapes effective plus selected")
    checked = 0
    kernel_count = 0
    for profile in range(1 << dimension):
        killed = all(dot(row, profile) == 0 for row in response_rows)
        require(not killed or profile in expected_space, "exhaustive paired-profile containment")
        checked += 1
        kernel_count += int(killed)
    targets = span(annihilator(expected, dimension))
    require(targets <= span(response_rows), "target vanishing does not give a shared response")
    return {
        "field": 2, "endpoints": 2, "tags": 3, "labels": 2,
        "base_dimension": BASE, "primal_dimension": PRIMAL, "channel_dimension": CHANNEL,
        "nominal_dimension": NOMINAL, "pin_bound": pin_bound, "rank_bound": rank_bound,
        "mixed_pin_basis": pins, "projected_pin_dimensions": [2, 2],
        "actual_primal_pin_intersection_dimensions": intersections,
        "private_channel_basis": private, "opposite_protected_channel_basis": protected_target,
        "selected_points_label_tag_base": [list(point) for point in selected],
        "allowed_points": "At tag 0 both affine base points are allowed; at tags 1 and 2 only (1,0) is allowed.",
        "moment_matrices_checked": moment_checks,
        "interpolation_supports_checked": interpolation_checks,
        "sparse_representations_checked": sparse_checks,
        "pin_intersection_injection_checks": injection_checks,
        "profile_dimension": dimension, "profile_generators": [list(g) for g in generators],
        "components": component_dimensions, "rank_one_response_tests": len(response_rows),
        "response_basis": reduced_basis(response_rows), "response_rank": rank(response_rows),
        "kernel_basis": kernel_basis, "kernel_dimension": len(kernel_basis),
        "effective_basis": effective, "selected_atom_basis": atoms,
        "all_profiles_checked": checked, "annihilating_profiles": kernel_count,
        "all_vanishing_targets_checked": len(targets),
        "scope": "An exact finite specimen of the universal implication, not manuscript-sized data or a counterexample.",
    }


def source_anchors():
    families = [
        "A-counterexample-to-Hadwigers-conjecture-September-23-2026",
        "A-counterexample-to-the-Colin-de-Verdiere-chromatic-conjecture-September-23-2026",
    ]
    result = []
    for family in families:
        base = ROOT / "research/openai_manuscript" / family / "build"
        require(r"\newcommand{\F}{\mathbb F_2}" in (base / "preamble.tex").read_text(),
                "manuscript field changed")
        for filename, labels in [
            ("02-geometry.tex", ["eq:point-evaluation", "eq:cut-profile-space"]),
            ("04-moments.tex", ["eq:moment-parameters", "lem:base-moments",
                                "lem:label-support", "lem:sparse-pin-labels",
                                "eq:effective-space"]),
            ("05-realization.tex", ["def:small-table", "eq:table-injection",
                                    "thm:gradient-realization", "eq:allowed-channel-changes"]),
        ]:
            path = base / "sections" / filename
            text = path.read_text()
            for label in labels:
                marker = r"\label{" + label + "}"
                require(text.count(marker) == 1, f"source anchor not unique: {label}")
                result.append({
                    "path": str(path.relative_to(ROOT)), "label": label,
                    "line": text.count("\n", 0, text.index(marker)) + 1,
                    "file_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
                })
    return result


def formal_evidence():
    check = json.loads((HERE / "lean_check.json").read_text())
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_bytes()
    require(check["status"] == "success" and check["exit_code"] == 0, "Lean compile unsuccessful")
    require(check["audit_exit_code"] == 0 and check["proof_holes"] == [], "Lean proof audit failed")
    require("4.31.0" in check["tools"]["lean"]["version"], "wrong Lean version")
    require(hashlib.sha256(source).hexdigest() == check["source_sha256"], "stale Lean source")
    require(hashlib.sha256(fidelity).hexdigest() == check["statement_fidelity_sha256"],
            "stale statement fidelity")
    archives = []
    for path in sorted((HERE / "certificates").glob("G157_ANNIHILATOR-*.json")):
        record = json.loads(path.read_text())
        if record["lean_check"]["source_sha256"] == check["source_sha256"]:
            require(record["lean_source"]["text"].encode() == source, "archived source mismatch")
            require(record["lean_check"]["statement_fidelity_sha256"] ==
                    check["statement_fidelity_sha256"], "archived fidelity mismatch")
            require(record["lean_check"]["proof_holes"] == [] and
                    record["lean_check"]["exit_code"] == 0 and
                    record["lean_check"]["audit_exit_code"] == 0, "archive did not pass")
            archives.append(str(path.relative_to(ROOT)))
    require(archives, "no archived mechanical evidence for G157_ANNIHILATOR")
    return {
        "claim_id": "G157_ANNIHILATOR", "lean_version": "4.31.0",
        "exit_code": 0, "audit_exit_code": 0, "proof_holes": [],
        "source_sha256": check["source_sha256"],
        "statement_fidelity_sha256": check["statement_fidelity_sha256"],
        "archived_certificates": archives,
        "declarations": [
            "BooleanCutAnnihilator.PairedBooleanData.paired_boolean_annihilator",
            "BooleanCutAnnihilator.PairedBooleanData.response_kernel_exact",
            "BooleanCutAnnihilator.PairedBooleanData.target_in_response",
        ],
    }


def build_certificate(arithmetic_only):
    result = {
        "schema_version": 1, "claim_id": "G157_ANNIHILATOR",
        "result_kind": "universal_implication_from_manuscript_moment_sparse_and_injection_hypotheses",
        "verifier_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "source_anchors": source_anchors(), "exact_specimen": exact_specimen(),
        "assumptions": [
            "A157_LABEL_SUPPORT", "A157_LOCAL_INTERPOLATION", "A157_SPARSE_PINS",
            "A157_TABLE_INJECTION", "A157_ADMISSIBLE_CUT_DATA",
        ],
        "limitations": [
            "The named manuscript moment, interpolation, and sparse-pin lemmas remain explicit inputs.",
            "Containment, selected-star consistency, nominal pin stripping, and target solvability are derived, not assumed.",
            "The full realization theorem still requires cut-compression specialization and composition.",
            "No false manuscript assertion, admissible counterexample, or graph-theoretic conclusion is certified.",
            "Statement fidelity and retained source lemmas require independent Host-invoked Reviewer assessment.",
        ],
    }
    if not arithmetic_only:
        result["formal_evidence"] = formal_evidence()
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--arithmetic-only", action="store_true")
    args = parser.parse_args()
    require(not (args.write_certificate and args.arithmetic_only),
            "arithmetic-only execution cannot publish a formal certificate")
    result = build_certificate(args.arithmetic_only)
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    if not args.arithmetic_only:
        require(json.loads(certificate.read_text()) == result, "certificate does not replay exactly")
    specimen = result["exact_specimen"]
    print(json.dumps({
        "ok": True, "claim_id": result["claim_id"], "formal_checked": not args.arithmetic_only,
        "profiles_checked": specimen["all_profiles_checked"],
        "annihilating_profiles": specimen["annihilating_profiles"],
        "response_rank": specimen["response_rank"],
        "manuscript_counterexample": False,
    }))


if __name__ == "__main__":
    main()
