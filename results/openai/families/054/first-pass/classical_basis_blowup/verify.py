#!/usr/bin/env python3
"""Replay exact arithmetic and check the separately scoped Lean evidence."""

import argparse
import hashlib
import itertools
import json
import math
import re
import subprocess
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
MANUSCRIPT = (
    "research/openai_manuscript/"
    "Irrational-cubic-fourfolds-with-geometric-K3-categories-September-24-2026/"
    "build/sections/gw.tex"
)
DECLARATIONS = [
    "positiveCount_le_sum",
    "positiveCount_lt_of_merge",
    "positiveCount_rigidity",
    "length_le_sum_of_positive",
    "restricted_contact",
    "restricted_empty_tail",
    "divisor_balance",
    "divisor_length_order",
    "empty_divisor_tail",
    "divisor_measure_lt",
    "fibreCoefficient_pos",
    "labelled_tail_coefficient_pos",
    "tensor_recover",
]


def read_json(path):
    return json.loads(path.read_text())


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def replay_lean():
    command = [
        ARGUS_PYTHON,
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity",
        str(HERE / "statement_fidelity.md"),
        "--claim",
        "C_RECONSTRUCTION_ORDER",
        "--project-root",
        str(ROOT),
    ]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    (HERE / "lean_verification.json").write_text(result.stdout)
    if result.stderr:
        print(result.stderr, end="")
    exits = [result.returncode]
    for module in ("math_state", "proof_graph_check"):
        checked = subprocess.run(
            [
                ARGUS_PYTHON,
                "-m",
                f"argus_skill.verticals.math.{module}",
                "check",
                "--project-root",
                str(ROOT),
            ],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        (HERE / f"{module}_current_check.json").write_text(checked.stdout)
        if checked.stderr:
            print(checked.stderr, end="")
        exits.append(checked.returncode)
    check(exits == [0, 0, 0], f"Lean/campaign checks failed: exit codes {exits}")


def checked_formal_core():
    record = read_json(HERE / "lean_verification.json")
    check(record["status"] == "success", "Lean result is not successful")
    check(record["exit_code"] == 0, "Lean compiler failed")
    check(record["audit_exit_code"] == 0, "Lean axiom audit failed")
    check(record["proof_holes"] == [], "Lean proof has holes")
    check(record["environment_failure"] == "", "Lean environment was unverified")
    check(
        "version 4.31.0" in record["tools"]["lean"]["version"],
        "The required Lean version was not used",
    )
    for name, field in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        digest = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        check(digest == record[field], f"Stale compiler evidence for {name}")
    declarations = re.findall(
        r"^theorem\s+(\w+)", (HERE / "Main.lean").read_text(), re.MULTILINE
    )
    check(declarations == DECLARATIONS, "The certified theorem inventory changed")

    evidence = record["kernel"]["recorded"]
    check(evidence["verdict"] == "supports", "No supporting mechanical verdict")
    check(
        evidence["subject"]["subject_id"] == "C_RECONSTRUCTION_ORDER",
        "Compiler evidence is attached to the wrong claim",
    )
    archived = read_json(ROOT / evidence["artifact"])
    check(archived["subject"] == evidence["subject"], "Archive subject mismatch")
    check(archived["verdict"] == "supports", "Archive does not support the claim")
    for field in (
        "source_sha256",
        "statement_fidelity_sha256",
        "exit_code",
        "proof_holes",
        "audit_exit_code",
    ):
        check(archived["lean_check"][field] == record[field], f"Archive mismatch: {field}")
    ledger = read_json(ROOT / "research/MATH_STATE.json")
    claim = max(
        (c for c in ledger["claims"] if c["claim_id"] == "C_RECONSTRUCTION_ORDER"),
        key=lambda c: c["version"],
    )
    check(
        claim["content_hash"] == evidence["subject"]["content_hash"],
        "The formal claim has been revised since this compiler run",
    )
    check(
        any(
            e.get("artifact") == evidence["artifact"]
            and e.get("verdict") == "supports"
            and e.get("tier") == "mechanical"
            and e.get("subject") == evidence["subject"]
            for e in ledger["evidence"]
        ),
        "The archived compiler result is not current mechanical ledger evidence",
    )
    return {
        "claim": "C_RECONSTRUCTION_ORDER",
        "evidence": "lean_verification.json",
        "lean_version": "4.31.0",
        "source_sha256": record["source_sha256"],
        "statement_fidelity_sha256": record["statement_fidelity_sha256"],
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "declarations": DECLARATIONS,
        "scope": "Unbounded arithmetic and rational tensor division, not GW geometry",
    }


def fibre_coefficient(r, k, j):
    check(r >= 1 and k >= 1 and 0 <= j < r, "Invalid HLR fibre data")
    return Fraction(1, k ** (r - j) * math.factorial(k - 1) ** r)


def multiply(a, b):
    return [
        [sum(x * y for x, y in zip(row, col)) for col in zip(*b)]
        for row in a
    ]


def transpose(a):
    return [list(row) for row in zip(*a)]


def exact_arithmetic():
    qz = [[0, 1], [1, 0]]
    qy = [[-x for x in row] for row in qz]
    operator = [[-1, 0], [0, -1]]
    check(multiply(transpose(operator), qy) == qz, "Wrong exceptional sign")
    check(operator != [[1, 0], [0, 1]], "Projector sign was lost")
    determinant = qy[0][0] * qy[1][1] - qy[0][1] * qy[1][0]
    check(determinant == -1, "The tested pairing is degenerate")

    payload = read_json(HERE / "jacobian/exceptional_pairing_payload.json")
    output = read_json(HERE / "jacobian/exceptional_pairing_output.json")
    check(output["server"]["version"] == "0.14.0", "Jacobian version mismatch")
    check(output["protocol_version"] == "2025-11-25", "Jacobian protocol mismatch")
    check(
        output["request"]["operation_id"] == "matrix.determinant.compute",
        "Wrong Jacobian operation",
    )
    check(output["request"]["payload"] == payload, "Jacobian payload mismatch")
    check("error" not in output and "result" in output, "Jacobian did not conclude")
    check(
        output["result"]["operation_id"] == "matrix.determinant.compute",
        "Jacobian returned a different operation",
    )
    typed = output["result"]["output"]["determinant"]
    check(
        Fraction(int(typed["num"]), int(typed["den"])) == determinant,
        "Independent determinant replay failed",
    )
    decoded = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in payload["matrix"]["entries"]
    ]
    check(decoded == qy, "The Jacobian matrix is not the tested pairing")

    labelled_restricted_data = [(1, 0), (2, 1)]
    restricted = Fraction(1)
    for k, b in labelled_restricted_data:
        leading = k * fibre_coefficient(2, k, 1 - b)
        check(
            leading == Fraction(1, k**b * math.factorial(k - 1) ** 2),
            "Restricted leading coefficient mismatch",
        )
        restricted *= leading
    check(restricted == Fraction(1, 2), "Restricted arithmetic replay failed")

    contacts = [3, 1, 1, 1]
    codimensions = [1, 1, 0, 0]
    trivial_count = sum(k == 1 and d == 0 for k, d in zip(contacts, codimensions))
    K = sum(contacts)
    allocation_sum = sum(
        math.prod(contacts[i] for i in assignment)
        for assignment in itertools.product(range(len(contacts)), repeat=trivial_count)
    )
    check(allocation_sum == K**trivial_count, "Label-allocation weights mismatch")
    divisor = Fraction(K**trivial_count, math.prod(math.factorial(k - 1) for k in contacts))
    check(divisor == 18, "MP coefficient replay failed")
    return {
        "exceptional_operator": operator,
        "exceptional_pairing": qy,
        "two_point_pairing": qz,
        "pairing_determinant": determinant,
        "labelled_restricted_example": {
            "r": 2,
            "contacts_and_exponents": [list(x) for x in labelled_restricted_data],
            "coefficient": str(restricted),
        },
        "divisor_example": {
            "contacts": contacts,
            "base_codimensions": codimensions,
            "K": K,
            "trivial_labels": trivial_count,
            "allocation_weight_sum": allocation_sum,
            "MP_coefficient": str(divisor),
        },
        "interpretation": "Exact coefficient/sign examples, not geometric counterexamples",
    }


def certificate():
    check((HERE / "REPORT.md").is_file(), "The geometric proof is missing")
    manuscript = (ROOT / MANUSCRIPT).read_text()
    literal_statements = {}
    for label in ("gw:blowup", "gw:relative", "gw:divisor"):
        match = re.search(
            r"\\begin\{(theorem|lemma)\}(?:\[[^\]]*\])?\s*\\label\{"
            + re.escape(label)
            + r"\}.*?\\end\{\1\}",
            manuscript,
            re.DOTALL,
        )
        check(match is not None, f"The literal manuscript statement {label} is missing")
        literal_statements[label] = match.group()
    return {
        "schema_version": 1,
        "claim": "C_EVEN_HODGE_SPLIT",
        "manuscript_claim": "C_GW_SPLIT",
        "literal_location": "gw.tex, Theorem gw:blowup and Lemmas gw:relative/gw:divisor",
        "manuscript_source": MANUSCRIPT,
        "literal_manuscript_assertions": literal_statements,
        "result_class": "new_theorem",
        "certification_stage": "engineer_candidate",
        "status": "core_verified_geometric_review_pending",
        "independent_review": "pending_host_invocation",
        "significance_status": "unreviewed",
        "novelty_status": "unverified",
        "manuscript_assertions_refuted": [],
        "hypotheses": [
            "M is a smooth connected projective complex fourfold",
            "h^{2,0}(M)=h^{4,0}(M)=0",
            "The blowup center is smooth, connected, and has codimension at least two",
            "Connected genus-zero numerical-class invariants",
            "Two distinct formal transcendental variable labels",
            "All other insertions are rational diagonal-Hodge classes",
            "Arbitrary nonnegative descendants only at ordinary markings",
        ],
        "conclusion": (
            "The classical integral transcendental blowup splitting has zero mixed "
            "GW blocks, scalar exceptional block, and exactly the old operator algebra"
        ),
        "geometric_proof": "REPORT.md",
        "formal_core": checked_formal_core(),
        "exact_arithmetic": exact_arithmetic(),
        "jacobian": {
            "protocol_version": "2025-11-25",
            "server_version": "0.14.0",
            "operation_id": "matrix.determinant.compute",
            "contract": "jacobian/determinant_contract.json",
            "payload": "jacobian/exceptional_pairing_payload.json",
            "typed_output": "jacobian/exceptional_pairing_output.json",
            "adapter_exit_code": 0,
            "timeout": False,
            "structured_error": None,
            "scope": "One exact nondegenerate exceptional-pairing example only",
        },
        "not_machine_verified": [
            "Hodge-theoretic and integral geometric inputs",
            "Virtual classes and descendant-compatible degeneration",
            "Application of the two reconstructions to all geometric data",
            "Statement fidelity, publication significance, and novelty",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--replay-lean", action="store_true")
    args = parser.parse_args()
    if args.replay_lean:
        replay_lean()
    computed = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2) + "\n")
    check(read_json(path) == computed, "The exact certificate is stale")
    print(
        json.dumps(
            {
                "status": computed["status"],
                "formal_claim": computed["formal_core"]["claim"],
                "lean_exit_code": 0,
                "proof_holes": [],
                "geometric_claim": computed["claim"],
                "independent_review": computed["independent_review"],
                "certificate": str(path.relative_to(ROOT)),
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
