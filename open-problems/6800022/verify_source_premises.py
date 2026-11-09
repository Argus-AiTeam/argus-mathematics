#!/usr/bin/env python3
import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
OPERATION = "matrix.symbolic.multiply.compute"
PASSAGE = (
    "research/kato-muroya-nonzero-reciprocal-fixed/"
    "reviewer-source-passages.txt"
)
PRIOR_READS = (
    (
        "KM-NONZERO-RECIPROCAL-FIXED-DECISION",
        "KM2012-THEOREM73-IMMERSION",
        "judgement-KM2012-THEOREM73-IMMERSION-f9d261a02eaf",
    ),
    (
        "KM-RECIPROCAL-LOCAL",
        "KM2012-RECIPROCAL-LOCAL",
        "judgement-KM2012-RECIPROCAL-LOCAL-38b7f8ff4b0d",
    ),
    (
        "KM-RECIPROCAL-PERIODS",
        "KM2012-RECIPROCAL-PERIODS",
        "judgement-KM2012-RECIPROCAL-PERIODS-07609dfed709",
    ),
)
A, ALPHA, Z = VARIABLES = sp.symbols("a alpha z")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def equal(left, right):
    require(sp.cancel(left - right) == 0, f"Unequal expressions: {left}, {right}")


def rational(value):
    numerator, denominator = sp.fraction(sp.cancel(value))
    leading = sp.Poly(denominator, *VARIABLES, domain=sp.QQ).LC()

    def polynomial(expression):
        terms = sp.Poly(expression / leading, *VARIABLES, domain=sp.QQ).terms()
        return {
            "terms": [
                {
                    "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                    "exponents": list(exponents),
                }
                for exponents, coefficient in terms
                if coefficient
            ]
        }

    return {
        "variables": [str(variable) for variable in VARIABLES],
        "domain": "QQ",
        "numerator": polynomial(numerator),
        "denominator": polynomial(denominator),
    }


def model_normalization():
    x, b, alpha = Z / A, 1 / A, ALPHA / A
    curve = (Z**2 - A**2) * (Z**2 - 1)
    equal(A**4 * (x**2 - 1) * (x**2 - b**2), curve)
    gauss_numerator = (Z - ALPHA) * (Z + A) * (Z - 1)
    equal(A**3 * (x - alpha) * (x + 1) * (x - b), gauss_numerator)
    equal((x + alpha) / A**2, (Z + ALPHA) / A**3)
    equal(
        gauss_numerator.subs(Z, -Z) * gauss_numerator,
        (-Z + ALPHA) * (Z + ALPHA) * curve,
    )
    dh = A * (Z**2 - ALPHA**2) / curve
    equal((x**2 - alpha**2) / ((x**2 - 1) * (x**2 - b**2)) / A, dh)
    equal(dh.subs(Z, -Z), dh)

    u = (ALPHA**2 - A**2) / (1 - A**2)
    v = A * (1 - ALPHA**2) / (1 - A**2)
    residues = []
    for point, expected in ((-A, -u), (1, v), (A, u), (-1, -v)):
        residue = sp.cancel(2 * (Z - point) * dh).subs(Z, point)
        equal(residue, expected)
        residues.append(str(sp.factor(residue)))
    equal((-u) * v - u * (-v), 0)

    left_values = (
        (Z**2 - A**2) / A**2,
        (Z - ALPHA) * (Z + A) / A**2,
        (Z**2 - ALPHA**2) / A**3,
    )
    right_values = (
        (Z**2 - 1) / A**2,
        (Z - 1) / A,
        A**4,
    )
    names = [str(variable) for variable in VARIABLES]
    payload = {
        "left": {
            "variables": names,
            "entries": [
                [
                    rational(left_values[row] if row == column else 0)
                    for column in range(3)
                ]
                for row in range(3)
            ],
        },
        "right": {
            "variables": names,
            "entries": [[rational(value)] for value in right_values],
        },
    }
    expected = {
        "variables": names,
        "entries": [
            [rational(curve / A**4)],
            [rational(gauss_numerator / A**3)],
            [rational(curve * dh)],
        ],
    }
    return payload, expected, residues


def prior_reads():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = {claim["claim_id"]: claim for claim in state["claims"]}
    evidence = {item["evidence_id"]: item for item in state["evidence"]}
    reads = []
    for claim_id, assumption_id, evidence_id in PRIOR_READS:
        assumptions = {
            item["assumption_id"]: item
            for item in claims[claim_id]["external_assumptions"]
        }
        assumption = assumptions[assumption_id]
        prior = evidence[evidence_id]
        require(
            prior["subject"]
            == {
                "kind": "assumption",
                "subject_id": assumption_id,
                "content_hash": assumption["content_hash"],
            },
            f"Prior source verdict no longer matches {assumption_id}",
        )
        require(
            prior["tier"] == "judgement"
            and prior["verdict"] == "supports"
            and prior["produced_by"] == "reviewer:copilot-l2"
            and prior["artifact"] == PASSAGE,
            f"Unexpected prior source reader or artifact for {assumption_id}",
        )
        require(
            assumption["source_id"] == "doi:10.18910/23417"
            and assumption["filed_by"] != prior["produced_by"],
            f"Source provenance or independence changed for {assumption_id}",
        )
        reads.append((claim_id, assumption_id, prior))
    return reads


def record_prior_citations():
    from argus_skill.proof_ledger import Verdict
    from argus_skill.verticals.math.citation_check import attribute_citation

    reads = prior_reads()
    excerpt = (ROOT / PASSAGE).read_text()
    results = []
    for claim_id, assumption_id, prior in reads:
        result = attribute_citation(
            ROOT,
            claim_id=claim_id,
            assumption_id=assumption_id,
            excerpt=excerpt,
            verdict=Verdict.SUPPORTS,
            checked_by=prior["produced_by"],
            note=(
                "Archival import of the unchanged independent source reading "
                f"already recorded as {prior['evidence_id']}, against this exact "
                "assumption reference and passage. Imported by engineer:copilot; "
                "the named reader is the original reader, not a newly dispatched "
                "reviewer. No new independent examination or confirmation is claimed."
            ),
        )
        require(result["ok"], f"Source archive refused {assumption_id}: {result}")
        results.append(
            {
                "claim": claim_id,
                "assumption": assumption_id,
                "original_judgment": prior["evidence_id"],
                "original_reader": prior["produced_by"],
                "recording": result,
            }
        )
    return results


def verify():
    from argus_skill.verticals.math.citation_check import citation_status

    payload, expected, residues = model_normalization()
    discovery = json.loads((HERE / "jacobian-find-model-normalization.json").read_text())
    inspection = json.loads((HERE / "jacobian-inspect-model-normalization.json").read_text())
    require(
        any(item["operation_id"] == OPERATION for item in discovery["result"]["matches"])
        and inspection["result"]["operation"]["operation_id"] == OPERATION
        and inspection["result"]["operation"]["read_only"] is True,
        "The preserved discovery and typed inspection do not cover this operation",
    )
    require(
        json.loads((HERE / "jacobian-payload-model-normalization-cleared.json").read_text())
        == payload,
        "Preserved Jacobian payload differs from the exact model normalization",
    )
    rejected = json.loads((HERE / "jacobian-output-model-normalization.json").read_text())
    require(
        rejected["ok"] is False
        and rejected["error"]["data"]["operation_id"] == OPERATION
        and rejected["error"]["data"]["code"] == "INVALID_REQUEST",
        "The retained initial adapter refusal is missing or mislabeled",
    )
    output = json.loads((HERE / "jacobian-output-model-normalization-cleared.json").read_text())
    require("error" not in output, f"Jacobian returned a non-conclusion: {output}")
    require(
        output["protocol_version"] == "2025-11-25"
        and output["server"]["name"] == "jacobian"
        and output["server"]["version"] == "0.14.0",
        "Unexpected Jacobian server or protocol",
    )
    require(
        output["request"] == {"operation_id": OPERATION, "payload": payload}
        and output["result"]["operation_id"] == OPERATION
        and output["result"]["output"] == expected,
        "Jacobian result does not certify the three exact normalization products",
    )
    reads = prior_reads()
    status = citation_status(ROOT)
    for claim_id, assumption_id, _ in reads:
        citation = next(
            item
            for item in status["claims"][claim_id]
            if item["assumption_id"] == assumption_id
        )
        require(citation["status"] == "confirmed", f"Unsettled source: {citation}")
    cccc = status["claims"].get("CCCC-FAMILY-DATA", [])
    require(
        not any(item["assumption_id"] == "WOHLGEMUTH-CCCC-DATA" for item in cccc),
        "Historical display attribution still stands as a live mathematical dependency",
    )
    return {
        "status": "exact_explicit_model_and_prior_source_provenance_verified",
        "project_root": str(ROOT),
        "jacobian_operation": OPERATION,
        "jacobian_outcome": "three_exact_products_with_height_denominator_cleared",
        "initial_adapter_refusal": "INVALID_REQUEST; not a mathematical conclusion",
        "residues_at_minus_a_one_a_minus_one": residues,
        "holomorphic_halfturn_identity": "g(-z,W)=1/g(z,W), T*dh=-dh",
        "unchanged_prior_source_readings": len(reads),
        "historical_display_attribution": "inconclusive_and_not_used",
        "new_independent_review": "required_for_changed_explicit_model_premise",
    }


def main():
    parser = argparse.ArgumentParser()
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--write-payload", action="store_true")
    modes.add_argument("--record-prior-citations", action="store_true")
    args = parser.parse_args()
    if args.write_payload:
        payload, _, _ = model_normalization()
        path = HERE / "jacobian-payload-model-normalization-cleared.json"
        path.write_text(json.dumps(payload, indent=2) + "\n")
        result = {"status": "payload_written", "artifact": str(path)}
    elif args.record_prior_citations:
        result = {"status": "prior_independent_readings_archived", "records": record_prior_citations()}
    else:
        result = verify()
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
