#!/usr/bin/env python3
"""Replay the exact specimen and bind it to the uniform Lean reduction."""

import argparse
import hashlib
import json
from pathlib import Path
import re


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
P = 5
H = 20
ENDPOINTS = 2
DIM = ENDPOINTS * (P + H)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def parity(value):
    return value.bit_count() & 1


def dot(left, right):
    return parity(left & right)


def xor(values):
    result = 0
    for value in values:
        result ^= value
    return result


def apply(columns, vector):
    return xor(column for index, column in enumerate(columns) if vector >> index & 1)


def rank(vectors):
    pivots = {}
    for vector in vectors:
        while vector:
            pivot = vector.bit_length() - 1
            if pivot in pivots:
                vector ^= pivots[pivot]
            else:
                pivots[pivot] = vector
                break
    return len(pivots)


def primal(endpoint, coordinate):
    return 1 << (endpoint * (P + H) + coordinate)


def channel(endpoint, coordinate):
    return 1 << (endpoint * (P + H) + P + coordinate)


def project_channel(vector, endpoint):
    return vector >> (endpoint * (P + H) + P) & ((1 << H) - 1)


def gram_value(rows, left, right):
    return dot(apply(rows, left), right)


def matrix(function):
    return [
        xor(function(1 << row, 1 << column) << column for column in range(DIM))
        for row in range(DIM)
    ]


def source_anchors():
    families = [
        "A-counterexample-to-Hadwigers-conjecture-September-23-2026",
        "A-counterexample-to-the-Colin-de-Verdiere-chromatic-conjecture-September-23-2026",
    ]
    anchors = []
    theorem_texts = []
    for family in families:
        base = ROOT / "research/openai_manuscript" / family / "build"
        preamble = (base / "preamble.tex").read_text()
        require(r"\newcommand{\F}{\mathbb F_2}" in preamble, "source field is not F_2")
        for filename, labels in [
            ("05-realization.tex", [
                "thm:gradient-realization", "def:small-table", "lem:small-tables",
                "eq:recipe-scalars", "eq:recipe-gradients", "eq:table-injection",
                "eq:allowed-channel-changes", "eq:target-difference",
                "eq:baseline-rank-bound", "eq:residual-rank-bound",
                "eq:quotient-compression-bound", "eq:final-pure-rank",
                "eq:realization-r0-requirement",
            ]),
            ("04-moments.tex", [
                "eq:moment-parameters", "lem:base-moments", "lem:label-support",
                "lem:sparse-pin-labels", "eq:effective-space",
            ]),
        ]:
            path = base / "sections" / filename
            text = path.read_text()
            for label in labels:
                marker = r"\label{" + label + "}"
                require(text.count(marker) == 1, f"source anchor not unique: {path}:{label}")
                offset = text.index(marker)
                anchors.append({
                    "path": str(path.relative_to(ROOT)),
                    "label": label,
                    "line": text.count("\n", 0, offset) + 1,
                })
            if filename == "05-realization.tex":
                match = re.search(
                    r"\\begin\{theorem\}\[Gradient realization\].*?\\end\{theorem\}",
                    text, re.S,
                )
                require(match is not None, "literal realization statement missing")
                theorem_texts.append(re.sub(r"\s+", " ", match.group()).strip())
                for formula in [
                    r"B_{\mathrm{lin}}=3K+28",
                    r"R_{\mathrm{res}}=2K+28+4B_{\mathrm{lin}}=14K+140",
                    r"30r_0+28J|\cE|+D_{\mathrm{quo}}",
                    r"970r_0>28J|\cE|+D_{\mathrm{quo}}+2K+4B_{\mathrm{lin}}",
                ]:
                    require(formula in text, f"source budget changed: {formula}")
    require(theorem_texts[0] == theorem_texts[1], "the two literal theorem statements differ")
    return anchors, theorem_texts[0]


def exact_specimen():
    pins = [
        primal(0, 0) ^ channel(0, 0) ^ channel(1, 1),
        primal(1, 0) ^ channel(0, 1) ^ channel(1, 0),
    ]
    keys = [primal(endpoint, 1) for endpoint in range(ENDPOINTS)]
    frozen = pins + keys
    private = [
        channel(endpoint, coordinate)
        for endpoint in range(ENDPOINTS) for coordinate in range(2, H)
    ]
    q_rows = [
        primal(0, 0) ^ channel(0, 0),
        primal(1, 0) ^ channel(0, 1),
        primal(0, 2), primal(1, 2),
        primal(0, 3), primal(0, 4), primal(1, 3), primal(1, 4),
        channel(1, 0) ^ channel(0, 1),
        channel(1, 1) ^ channel(0, 0),
    ]
    q = [xor(dot(row, 1 << column) << index for index, row in enumerate(q_rows))
         for column in range(DIM)]
    require(rank(q) == 10, "quotient map has the wrong rank")
    require(rank(frozen + private) == DIM - rank(q), "not the full frozen/private quotient")
    for vector in frozen + private:
        require(apply(q, vector) == 0, "quotient fails a frozen/private direction")

    nominal_compression = [
        0 if any((1 << column) == primal(endpoint, coordinate)
                 for endpoint in range(ENDPOINTS) for coordinate in (3, 4))
        else 1 << column
        for column in range(DIM)
    ]
    keep = sum(1 << index for index in (0, 1, 2, 3, 8, 9))
    for column in range(DIM):
        require(
            apply(q, nominal_compression[column]) == q[column] & keep,
            "compression does not descend to the quotient",
        )
    for vector in frozen:
        require(apply(nominal_compression, vector) == vector, "compression moves a mixed pin/key")
    require(rank([value & keep for value in q]) == 6, "compressed quotient rank")

    primal_vectors = [primal(i, j) for i in range(ENDPOINTS) for j in range(P)]
    pure_maps = {}
    derivative_maps = {}
    baseline_maps = {}
    final_corrections = {}
    for role in range(2):
        for target in range(ENDPOINTS):
            for sign in ("F", "G"):
                base = []
                derivative = []
                pure = []
                for column in range(DIM):
                    vector = 1 << column
                    bits = q[column]
                    b0, b1, b2, b3 = [(bits >> index) & 1 for index in range(4)]
                    if sign == "F":
                        d = ((b0 ^ (target & b3)) << 2) ^ ((b2 ^ (role & b1)) << 3)
                        f = (b0 << 4) ^ (b1 << 5) ^ (b2 << 6) ^ (b3 << 7)
                    else:
                        d = ((b1 ^ (role & b2)) << 2) ^ ((b3 ^ (target & b0)) << 3)
                        f = (b0 << 4) ^ ((b1 ^ (target & b0)) << 5)
                        f ^= (b2 << 6) ^ ((b3 ^ (role & b2)) << 7)
                    derivative.append(d)
                    pure.append(f)
                    endpoint = column // (P + H)
                    local = column % (P + H)
                    base.append(
                        (((local + target + role) & 1) << 2) ^
                        (((endpoint + local + target + 1) & 1) << 3)
                        if local < P else 0
                    )
                key = (role, target, sign)
                pure_maps[key] = pure
                derivative_maps[key] = derivative
                baseline_maps[key] = base
                final_corrections[key] = [d ^ f for d, f in zip(derivative, pure)]
                for vector in frozen + private:
                    require(apply(derivative, vector) == 0, "derivative violates its source quotient")
                    require(apply(pure, vector) == 0, "pure factor violates its source quotient")
                for value in final_corrections[key]:
                    require(value & 3 == 0, "output does not annihilate protected channels")

    contractions = []
    for role in range(2):
        for target in range(ENDPOINTS):
            F0 = baseline_maps[role, target, "F"]
            G0 = baseline_maps[role, target, "G"]
            dF = derivative_maps[role, target, "F"]
            dG = derivative_maps[role, target, "G"]
            pF = pure_maps[role, target, "F"]
            pG = pure_maps[role, target, "G"]
            target_rows = []
            for left in primal_vectors:
                row = 0
                for index, right in enumerate(primal_vectors):
                    f0, g0 = apply(F0, left), apply(G0, right)
                    df, dg = apply(dF, left), apply(dG, right)
                    pf, pg = apply(pF, left), apply(pG, right)
                    require(dot(pf, g0 ^ dg) == 0, "first forbidden mixed term")
                    require(dot(f0 ^ df, pg) == 0, "second forbidden mixed term")
                    pure = dot(pf, pg)
                    relaxed_pure = pure ^ dot(df, dg)
                    relaxed = dot(f0, g0) ^ dot(f0, dg) ^ dot(df, g0) ^ relaxed_pure
                    actual = dot(f0 ^ df ^ pf, g0 ^ dg ^ pg)
                    require(actual == relaxed, "relaxed-to-factored response identity failed")
                    row ^= actual << index
                target_rows.append(row)
            pure_rows = [
                xor(dot(apply(pF, left), apply(pG, right)) << index
                    for index, right in enumerate(primal_vectors))
                for left in primal_vectors
            ]
            require(rank(pure_rows) == 4, "pure rank does not exercise all four factors")
            require(2 + 6 + 4 + 4 <= H, "uniform codimension budget fails")
            contractions.append({
                "role": role, "target_endpoint": target,
                "pure_rank": rank(pure_rows), "target_rows": target_rows,
            })

    blocks = []
    frozen_tests = 0
    channel_tests = 0
    for role in range(2):
        opposite = 1 - role
        F = [final_corrections[role, target, "F"] for target in range(ENDPOINTS)]
        G = [final_corrections[opposite, target, "G"] for target in range(ENDPOINTS)]

        def correction(left, right):
            return xor(dot(apply(F[z], left), project_channel(right, z))
                       for z in range(ENDPOINTS)) ^ xor(
                dot(project_channel(left, i), apply(G[i], right))
                for i in range(ENDPOINTS)
            )

        delta = matrix(correction)
        for vector in frozen:
            for column in range(DIM):
                require(gram_value(delta, vector, 1 << column) == 0, "frozen row changed")
                require(gram_value(delta, 1 << column, vector) == 0, "frozen column changed")
                frozen_tests += 2
        for vector in primal_vectors:
            for endpoint in range(ENDPOINTS):
                for coordinate in range(H):
                    require(
                        correction(vector, channel(endpoint, coordinate)) ==
                        (apply(F[endpoint], vector) >> coordinate & 1),
                        "reciprocal changes interfered with a primal-to-channel entry",
                    )
                    require(
                        correction(channel(endpoint, coordinate), vector) ==
                        (apply(G[endpoint], vector) >> coordinate & 1),
                        "forward changes interfered with a channel-to-primal entry",
                    )
                    channel_tests += 2
        blocks.append({"source_role": role, "delta_rows": delta})

    sharp_basis = [0b0011, 0b0100, 0b1000]
    sharp_matrix = [
        [dot(left, right) for right in sharp_basis] for left in sharp_basis
    ]
    require(rank([xor(bit << j for j, bit in enumerate(row)) for row in sharp_matrix]) == 2,
            "sharp restricted pairing example")
    require(all(dot(vector, 0b0011) == 0 for vector in sharp_basis),
            "sharp example is not the protected annihilator")
    return {
        "field": 2, "primal_dimension_per_endpoint": P, "channel_dimension": H,
        "endpoints_per_role": ENDPOINTS, "nominal_dimension_per_role_and_sign": DIM,
        "mixed_pin_basis": pins, "key_basis": keys, "quotient_rows": q_rows,
        "quotient_dimension": 10, "compressed_quotient_rank": 6,
        "fixed_large_pure_rank_bound": 2, "allowed_channel_codimensions": [4, 4],
        "sufficient_channel_budget": 16,
        "frozen_basis_entry_checks": frozen_tests, "primal_channel_checks": channel_tests,
        "contractions": contractions, "gram_corrections": blocks,
        "sharp_pairing_matrix": sharp_matrix,
        "scope": "A specimen of the field-general reduction, not a manuscript counterexample or a full manuscript recipe.",
    }


def formal_evidence():
    path = HERE / "lean_check.json"
    result = json.loads(path.read_text())
    require(result["status"] == "success", "Lean did not certify the source")
    require(result["exit_code"] == 0 and result["proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not pass")
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    require(hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
            "Lean source changed after certification")
    require(hashlib.sha256(fidelity.read_text().encode()).hexdigest() ==
            result["statement_fidelity_sha256"], "statement fidelity changed after certification")
    require("4.31.0" in result["tools"]["lean"]["version"], "certificate is not Lean 4.31.0")
    return {
        "result": str(path.relative_to(ROOT)), "status": result["status"],
        "exit_code": result["exit_code"], "proof_holes": result["proof_holes"],
        "audit_exit_code": result["audit_exit_code"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "scope": "Universal protected realization under explicit annihilator and compression-diagram hypotheses; see statement_fidelity.md.",
    }


def build_certificate(arithmetic_only):
    anchors, literal = source_anchors()
    specimen = exact_specimen()
    payload = json.loads((HERE / "jacobian_rank_payload.json").read_text())
    output = json.loads((HERE / "jacobian_rank_output.json").read_text())
    status = json.loads((HERE / "jacobian_rank_status.json").read_text())
    require(status["exit_code"] == 0 and not status["timeout"], "Jacobian adapter did not complete")
    operation = "prime_field.matrix.rank.compute"
    require(status["operation_id"] == output["request"]["operation_id"] ==
            output["result"]["operation_id"] == operation, "Jacobian operation binding")
    require(output["request"]["payload"] == payload, "Jacobian payload binding")
    require(output["result"]["output"]["source"] == payload, "Jacobian typed source binding")
    require(output["result"]["output"]["rank"] == 2, "Jacobian rank result")
    require(payload["matrix"]["entries"] == specimen["sharp_pairing_matrix"],
            "Jacobian example is not the independently replayed example")
    result = {
        "schema_version": 1,
        "claim_id": "G157_PROTECTED_REDUCTION",
        "result_kind": "uniform_conditional_reduction",
        "source_anchors": anchors,
        "literal_manuscript_theorem": literal,
        "exact_specimen": specimen,
        "jacobian": {
            "operation_id": output["result"]["operation_id"],
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "adapter_status": status,
            "payload_file": "research/gradient-realization/jacobian_rank_payload.json",
            "typed_output_file": "research/gradient-realization/jacobian_rank_output.json",
        },
        "limitations": [
            "No false manuscript assertion or admissible counterexample has been established.",
            "The Lean reduction assumes annihilator containment, compression naturality, and residual invariance.",
            "The paired Boolean annihilator implication is independently certified in annihilator/; cut-compression specialization and residual invariance remain unresolved formally.",
            "Novelty, publishability, statement fidelity, and the manuscript specialization require independent Reviewer assessment.",
            "No probabilistic lemma or graph-theoretic conclusion is certified here.",
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
            "an arithmetic-only run cannot publish the formal certificate")
    result = build_certificate(args.arithmetic_only)
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    if not args.arithmetic_only:
        require(json.loads(certificate.read_text()) == result, "certificate does not replay exactly")
    print(json.dumps({
        "ok": True, "scope": result["result_kind"],
        "formal_checked": not args.arithmetic_only,
        "frozen_entry_checks": result["exact_specimen"]["frozen_basis_entry_checks"],
        "primal_channel_checks": result["exact_specimen"]["primal_channel_checks"],
        "manuscript_counterexample": False,
    }))


if __name__ == "__main__":
    main()
