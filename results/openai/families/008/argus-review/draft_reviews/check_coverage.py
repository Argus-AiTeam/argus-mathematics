"""Check the requested artifact coverage and consistency of review outputs."""

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(path):
    return json.loads(path.read_text())


def main():
    inventory = read(ROOT / "PRIOR_DRAFTS.json")
    index = read(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    old_state = read(Path(inventory["old_workspace"]) / "research/MATH_STATE.json")
    errors = []
    expected_artifacts = {item["path"] for item in inventory["artifacts"]}
    artifacts = [item["path"] for item in index["artifacts"]]
    if len(artifacts) != len(set(artifacts)):
        errors.append("Duplicate artifact mappings")
    if set(artifacts) != expected_artifacts:
        errors.append({
            "missing_artifacts": sorted(expected_artifacts - set(artifacts)),
            "unexpected_artifacts": sorted(set(artifacts) - expected_artifacts),
        })
    units = {unit["id"]: unit for unit in index["units"]}
    if len(units) != len(index["units"]):
        errors.append("Duplicate unit identifiers")
    mapped_claims = {item["claim"]: item for item in index["claim_map"]}
    if len(mapped_claims) != len(index["claim_map"]):
        errors.append("Duplicate primary claim mappings")
    expected_versions = {}
    assumptions = set()
    for claim in old_state["claims"]:
        expected_versions.setdefault(claim["claim_id"], set()).add(claim["version"])
        assumptions.update(
            item["assumption_id"] for item in claim["external_assumptions"]
        )
    for identifier, versions in expected_versions.items():
        mapping = mapped_claims.get(identifier)
        if mapping is None or set(mapping.get("versions", [])) != versions:
            errors.append({"uncovered_claim_versions": identifier})
    if {item["assumption"] for item in index["assumption_map"]} != assumptions:
        errors.append("Assumption coverage mismatch")
    if {item["route"] for item in index["route_map"]} != {
        route["route_id"] for route in old_state["routes"]
    }:
        errors.append("Historical route coverage mismatch")
    for artifact in index["artifacts"]:
        if not artifact["units"] and not artifact.get("reason"):
            errors.append({"unreasoned_artifact_exclusion": artifact["path"]})
        if not set(artifact["units"]) <= set(units):
            errors.append({"unknown_artifact_unit": artifact["path"]})
    for claim in index["claim_map"]:
        unit = claim["unit"]
        if unit is None:
            if not claim.get("exclusion"):
                errors.append({"unreasoned_claim_exclusion": claim["claim"]})
        elif unit not in units or claim["claim"] not in units[unit]["claims"]:
            errors.append({"inconsistent_claim_owner": claim["claim"]})
    expected_references = {
        item["path"] for item in inventory["reference_inputs_and_tooling"]
    } | {
        inventory["preserved_snapshot_manifest"],
        inventory["manuscript_reference_manifest"],
    }
    if not expected_references <= {
        item["path"] for item in index["reference_inputs"]
    }:
        errors.append("Reference-input coverage mismatch")
    manuscript_manifest = read(Path(inventory["manuscript_reference_manifest"]))
    expected_source_files = {
        source["path"]
        for manuscript in manuscript_manifest["manuscripts"]
        for source in manuscript["tex_sources"] + manuscript["pdf_sources"]
    }
    mapped_source_files = {
        source["path"]
        for reference in index["reference_inputs"]
        if reference.get("kind") == "manuscript_reference_manifest"
        for source in reference["files"]
    }
    if expected_source_files != mapped_source_files:
        errors.append("Manuscript reference-file coverage mismatch")
    summary = ROOT / index["summary"]
    summary_text = summary.read_text()
    assessment_counts = {}
    for unit in units.values():
        report = ROOT / unit["report"]
        verdict_path = ROOT / unit["verdict"]
        report_text = report.read_text()
        verdict = read(verdict_path)
        if verdict["unit"] != unit["id"] or verdict["report"] != unit["report"]:
            errors.append({"report_verdict_identity_mismatch": unit["id"]})
        if {item["claim"] for item in verdict["claim_assessments"]} != set(unit["claims"]):
            errors.append({"verdict_claim_coverage_mismatch": unit["id"]})
        if not verdict["assessment_complete"]:
            errors.append({"incomplete_assessment": unit["id"]})
        if (
            not verdict["independent_review"]["required"]
            or verdict["independent_review"]["completed"]
        ):
            errors.append({"independent_review_boundary_violation": unit["id"]})
        if verdict["assessment"] == "partially_supported" and not verdict[
            "unresolved_mathematical_obligations"
        ]:
            errors.append({"unspecified_partial_support": unit["id"]})
        if not report_text.strip():
            errors.append({"empty_report": unit["id"]})
        for key in ("report", "verdict"):
            if Path(unit[key]).relative_to("research").as_posix() not in summary_text:
                errors.append({"missing_summary_link": unit[key]})
        for evidence in verdict["evidence"]:
            path = Path(evidence)
            if not (path if path.is_absolute() else ROOT / path).is_file():
                errors.append({"missing_verdict_evidence": evidence})
        if not set(unit["depends_on"]) <= set(units):
            errors.append({"unknown_dependency": unit["id"]})
        assessment_counts[verdict["assessment"]] = (
            assessment_counts.get(verdict["assessment"], 0) + 1
        )
    result = {
        "project_root": str(ROOT),
        "passed": not errors,
        "artifact_count": len(expected_artifacts),
        "historical_claim_count": len(expected_versions),
        "historical_claim_version_count": len(old_state["claims"]),
        "historical_assumption_count": len(assumptions),
        "historical_route_count": len(old_state["routes"]),
        "manuscript_reference_file_count": len(expected_source_files),
        "unit_count": len(units),
        "assessment_counts": assessment_counts,
        "errors": errors,
        "scope": "Coverage/link/consistency check, not mathematical proof or independent acceptance.",
    }
    print(json.dumps(result, indent=2))
    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main())
