"""Validate the completed review against its inputs and fresh scalar certificate."""

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    index = load(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    prior = load(ROOT / "PRIOR_DRAFTS.json")
    bindings = load(HERE / "input_bindings.json")
    expected = {item["path"] for item in prior["artifacts"]}
    require(
        len(index["artifacts"]) == len(expected) == 40
        and {item["path"] for item in index["artifacts"]} == expected,
        "Coverage does not account for exactly the forty listed inputs",
    )
    require(len(bindings["listed_artifacts"]) == 40, "Input checks were incomplete")
    require(
        len(bindings["reference_files"]) == len(index["reference_inputs"]) == 9,
        "Reference tree is incomplete",
    )
    require(
        all(item["sha256_matches_manifest"] for item in bindings["snapshot_manifest_agreement"])
        and len(bindings["snapshot_manifest_agreement"]) == 11,
        "Preserved versions are not bound",
    )
    require(
        all(item["sha256_matches_manifest"] for item in bindings["manuscript_source_bindings"])
        and len(bindings["manuscript_source_bindings"]) == 7,
        "Manuscript source version is not bound",
    )
    old_versions = {
        (item["claim_id"], item["version"]) for item in bindings["old_claim_versions"]
    }
    mapped = {
        (item["claim"], version)
        for item in index["claim_version_mapping"]
        for version in item["versions"]
    }
    require(mapped == old_versions and len(mapped) == 17, "Claim-version coverage differs")
    units = {item["id"] for item in index["units"]}
    require(len(units) == len(index["units"]) == 7, "Unit grouping differs")
    for item in index["artifacts"]:
        require(bool(item["role"]), "An artifact has no explained role")
        if item["units"] == []:
            require(bool(item["exclusion"]), "An artifact is silently excluded")
        elif item["units"] != "all":
            require(set(item["units"]) <= units, "Artifact refers to an unknown unit")
    for item in index["claim_version_mapping"]:
        if item["versions"]:
            require(
                bool(item.get("unit") or item.get("units") or item.get("exclusion")),
                "Claim has no unit or justified exclusion",
            )

    required_fields = [
        "assessment", "supported_scope", "result_kind", "active_claim",
        "old_claim_versions", "exact_claim", "hypotheses", "sources",
        "decisive_argument", "argument_assessment", "external_assumptions",
        "evidence", "execution_scope", "remaining_obligations",
        "excluded_conclusions", "novelty_status", "independent_review", "assessor",
    ]
    assessments = []
    for item in index["units"]:
        report = ROOT / item["report"]
        verdict_path = ROOT / item["verdict"]
        require(report.is_file() and verdict_path.is_file(), "Missing unit assessment")
        require(len(report.read_text().strip()) > 500, "A unit lacks substantive prose")
        verdict = load(verdict_path)
        require(verdict["unit"] == item["id"], "Verdict/unit mismatch")
        missing = [key for key in required_fields if key not in verdict]
        require(not missing, f"Incomplete verdict {item['id']}: {missing}")
        require(
            verdict["assessment"] in {"supported", "partial", "invalid", "unresolved"},
            "Invalid assessment classification",
        )
        for key in required_fields:
            require(bool(verdict[key]), "Empty assessment field: " + key)
        require(
            verdict["independent_review"]
            == {"required": True, "performed": False, "family_accepted": False},
            "Engineer represents independent acceptance",
        )
        for label in verdict["old_claim_versions"]:
            claim, suffix = label.split("@")
            version = int(suffix.split(":")[0])
            require((claim, version) in old_versions, "Unknown claimed-result version")
        for source in verdict["sources"]:
            require(Path(source["path"]).is_file(), "Missing assessment source")
            require(bool(source["locator"]) and bool(source["attribution"]), "Unattributed source")
        for artifact in verdict["evidence"]:
            require((ROOT / artifact).is_file(), "Missing assessment evidence: " + artifact)
        assessments.append({
            "unit": item["id"],
            "assessment": verdict["assessment"],
            "active_claim": verdict["active_claim"],
            "report": item["report"],
            "verdict": item["verdict"],
        })

    check = load(HERE / "universal-partition-obstruction/lean_verify.json")
    require(check["status"] == "success" and check["exit_code"] == 0, "No fresh compile")
    require(check["proof_holes"] == [] and check["audit_exit_code"] == 0, "Formal proof has holes")
    require(check["kernel"]["refusals"] == [], "Compiler recording was refused")
    record = check["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "No kernel support")
    require(record["subject"]["subject_id"] == "C1", "Wrong fresh formal claim")
    certificate = load(ROOT / record["artifact"])
    for name, document, hash_key in [
        ("Main.lean", "lean_source", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity", "statement_fidelity_sha256"),
    ]:
        data = (HERE / "universal-partition-obstruction/replay" / name).read_bytes()
        require(hashlib.sha256(data).hexdigest() == check[hash_key], "Fresh evidence is stale")
        require(certificate[document]["text"].encode() == data, "Certificate text differs")
        require(certificate["lean_check"][hash_key] == check[hash_key], "Certificate hash differs")
    require(certificate["subject"] == record["subject"], "Certificate subject differs")
    state = load(ROOT / "research/MATH_STATE.json")
    current = max(
        (claim for claim in state["claims"] if claim["claim_id"] == "C1"),
        key=lambda claim: claim["version"],
    )
    require(current["content_hash"] == record["subject"]["content_hash"], "Formal claim changed")
    require(
        current["formal_statement"] == certificate["lean_source"]["text"],
        "Formal source and current claim differ",
    )
    for assessment in assessments:
        require(
            any(
                row["tier"] == "judgement"
                and row["verdict"] == "supports"
                and row["produced_by"] == "engineer:9200038"
                and row["subject"]["subject_id"] == assessment["active_claim"]
                and row["artifact"] == assessment["report"]
                for row in state["evidence"]
            ),
            "Unit assessment was not recorded as an Engineer opinion",
        )
    archived = load(HERE / "archived_exact_replay_status.json")
    require(archived["exit_code"] == 0, "Existing exact replay did not pass")
    require(
        bindings["fresh_jacobian"]["independent_product_reconstruction"] == "EXACT",
        "Fresh typed polynomial result was not reconstructed",
    )
    summary = ROOT / "research/OLD_ROUND_REVIEW.md"
    require(summary.is_file(), "Missing all-unit summary")
    require(all(item["unit"] in summary.read_text() for item in assessments), "Summary omits a unit")
    local_checks = load(HERE / "final_validation.json")
    require(local_checks["project_root"] == str(ROOT), "Wrong campaign root")
    require(local_checks["math_state_exit_code"] == 0, "Active ledger check failed")
    result = {
        "project_root": str(ROOT),
        "coverage_status": "passed",
        "listed_artifacts": 40,
        "reference_files": 9,
        "manifest_bound_snapshot_entries": 11,
        "manifest_bound_manuscript_sources": 7,
        "claim_versions": 17,
        "units": assessments,
        "source_fresh_scalar_certificate": record["artifact"],
        "fresh_lean_exit_code": check["exit_code"],
        "fresh_axiom_audit_exit_code": check["audit_exit_code"],
        "fresh_proof_holes": check["proof_holes"],
        "statement_fidelity": "Engineer prose assessment only; native independent reading pending",
        "fresh_exact_replay_exit_code": archived["exit_code"],
        "fresh_jacobian": bindings["fresh_jacobian"],
        "math_state_exit_code": local_checks["math_state_exit_code"],
        "proof_graph_exit_code": local_checks["proof_graph_exit_code"],
        "campaign_handoff_gate_passed": local_checks["proof_graph_exit_code"] == 0,
        "citation_status": "BM-compact independent attribution pending; prose-only upstream inputs remain exposed",
        "native_independent_family_acceptance": False,
    }
    destination = HERE / "coverage_validation.json"
    destination.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "coverage_status": result["coverage_status"],
        "artifacts": 40,
        "reference_files": 9,
        "claim_versions": 17,
        "units": 7,
        "fresh_lean_exit_code": check["exit_code"],
        "math_state_exit_code": local_checks["math_state_exit_code"],
        "proof_graph_exit_code": local_checks["proof_graph_exit_code"],
        "campaign_handoff_gate_passed": result["campaign_handoff_gate_passed"],
        "independent_review": "pending",
        "output": str(destination.relative_to(ROOT)),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
