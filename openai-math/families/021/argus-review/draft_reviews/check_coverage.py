#!/usr/bin/env python3
"""Check retrospective coverage and references, not mathematical acceptance."""

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def load(path):
    return json.loads(path.read_text())


def main():
    index = load(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    inventory = load(ROOT / "PRIOR_DRAFTS.json")
    old_root = Path(index["old_root"])
    old = load(old_root / "research/MATH_STATE.json")
    active = load(ROOT / "research/MATH_STATE.json")
    units = {unit["id"]: unit for unit in index["units"]}
    assert len(units) == len(index["units"]) == 7

    listed = {item["path"] for item in inventory["artifacts"]}
    covered = {item["path"] for item in index["artifact_coverage"]}
    assert listed == covered
    assert len(listed) == len(index["artifact_coverage"]) == 22
    for item in inventory["artifacts"]:
        assert (old_root / item["path"]).stat().st_size == item["bytes"], item["path"]
    for item in index["artifact_coverage"]:
        assert item["primary_unit"] in units
        assert not item["independent_result"]
        assert set(item.get("also_supports", [])) <= units.keys()

    references = {item["path"] for item in inventory["reference_inputs_and_tooling"]}
    assert references == {item["path"] for item in index["reference_input_coverage"]}
    for path in references:
        assert (old_root / path).is_dir()
    snapshot = index["snapshot_reconciliation"]
    preserved = set(snapshot["snapshot_members"])
    supplementary = set(snapshot["supplementary_live_members"])
    assert len(preserved) == 9 and len(supplementary) == 13
    assert not preserved & supplementary
    assert preserved | supplementary == listed
    shared = index["replay_evidence"]["shared_by_units"]
    assert len(shared) == len(set(shared))
    assert set(shared) == units.keys() - {"scope-and-frontier"}

    old_claims = {(claim["claim_id"], claim["version"]): claim for claim in old["claims"]}
    mapped = {(item["claim"], item["version"]): item
              for item in index["historical_claim_version_coverage"]}
    assert old_claims.keys() == mapped.keys()
    assert len(old_claims) == len(mapped) == len(old["claims"]) == 21
    for key, claim in old_claims.items():
        item = mapped[key]
        assert item["unit"] in units
        assert item["natural_statement"] == claim["natural_statement"]
        assert item["formal_statement_present"] == bool(claim["formal_statement"])
        assert item["assumption_ids"] == [
            assumption["assumption_id"] for assumption in claim["external_assumptions"]
        ]
        matching = [
            evidence["evidence_id"] for evidence in old["evidence"]
            if evidence["subject"]["kind"] == "claim"
            and evidence["subject"]["subject_id"] == claim["claim_id"]
            and evidence["subject"]["content_hash"] == claim["content_hash"]
        ]
        assert item["evidence_ids_for_content_reference"] == matching
    old_evidence = {item["evidence_id"]: item for item in old["evidence"]}
    bindings = {item["evidence_id"]: item for item in index["historical_evidence_bindings"]}
    assert old_evidence.keys() == bindings.keys()
    assert len(bindings) == len(index["historical_evidence_bindings"])
    for evidence_id, evidence in old_evidence.items():
        binding = bindings[evidence_id]
        assert binding["claim"] == evidence["subject"]["subject_id"]
        assert binding["tier"] == evidence["tier"]
        assert binding["verdict"] == evidence["verdict"]
        assert binding["produced_by"] == evidence["produced_by"]
        assert binding["artifact_under_old_root"] == evidence["artifact"] in listed
        assert binding["matching_versions"] == [
            claim["version"] for claim in old["claims"]
            if claim["claim_id"] == evidence["subject"]["subject_id"]
            and claim["content_hash"] == evidence["subject"]["content_hash"]
        ]
    assert {(item["context_id"], item["version"]) for item in old["contexts"]} == {
        (item["id"], item["version"]) for item in index["historical_contexts"]
    }
    assert {route["route_id"] for route in old["routes"]} == {
        route["id"] for route in index["historical_routes"]
    }
    finite = [old_claims["C_INVERSE_FINITE", version] for version in (1, 2)]
    assert finite[0]["natural_statement"] == finite[1]["natural_statement"]
    assert finite[0]["formal_statement"] != finite[1]["formal_statement"]

    summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
    active_ids = {claim["claim_id"] for claim in active["claims"]}
    assert set(index["active_claim_unit_mapping"]) == active_ids
    for unit_id, unit in units.items():
        report = ROOT / unit["report"]
        verdict = load(ROOT / unit["verdict"])
        assert report.is_file() and report.stat().st_size > 1000
        assert unit["report"] in index["review_artifacts"]
        assert unit["verdict"] in index["review_artifacts"]
        assert verdict["unit"] == unit_id
        assert verdict["report"] == unit["report"]
        assert verdict["summary"] == "research/OLD_ROUND_REVIEW.md"
        assert verdict["assessment"] == unit["assessment"]
        assert not verdict["final_acceptance"]
        assert verdict["independent_review"] == "pending_native_host_reviewer"
        assert set(verdict["active_claims"]) <= active_ids
        assert f"draft_reviews/{unit_id}/report.md" in summary
        assert f"draft_reviews/{unit_id}/verdict.json" in summary
        for path in verdict.get("evidence", []):
            assert (ROOT / path).is_file(), path

    markdown = [ROOT / "research/OLD_ROUND_REVIEW.md"]
    markdown.extend(ROOT / unit["report"] for unit in units.values())
    for path in markdown:
        for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", path.read_text()):
            if target.startswith(("https://", "http://", "#")):
                continue
            assert (path.parent / target.split("#", 1)[0]).exists(), (path, target)

    replay = ROOT / "research/draft_reviews/finite-rigidity"
    fixture = load(replay / "fixture_replay.json")
    assert fixture["ok"] and fixture["finite_family_regression_cases"] == 5058
    compiler = load(replay / "replay/compiler_result.json")
    assert compiler["status"] == "success"
    assert compiler["exit_code"] == compiler["audit_exit_code"] == 0
    assert compiler["proof_holes"] == []
    assert compiler["kernel"]["recorded"]["subject"]["subject_id"] == "R_FINITE_KERNEL"
    assert (ROOT / compiler["kernel"]["recorded"]["artifact"]).is_file()
    for filename in ("Main.lean", "statement_fidelity.md"):
        assert (replay / "replay" / filename).read_bytes() == (
            old_root / "research/inverse_certificate" / filename
        ).read_bytes()
    run_status = load(replay / "replay/run_status.json")
    assert run_status["project_root"] == str(ROOT)
    assert run_status["compiler_command_exit"] == run_status["math_state_exit"] == 0
    assert run_status["proof_graph_exit"] == 2
    jacobian = load(replay / "jacobian_output.json")
    status = load(replay / "jacobian_status.json")
    assert status["adapter_exit_code"] == 0 and not status["timeout"]
    assert jacobian["request"]["payload"] == load(replay / "jacobian_payload.json")
    assert jacobian["request"]["operation_id"] == "matrix.determinant.compute"
    assert jacobian["result"]["output"]["determinant"] == {"num": "0", "den": "1"}

    print(json.dumps({
        "ok": True,
        "project_root": str(ROOT),
        "inventory_paths": len(covered),
        "reference_directories": len(references),
        "historical_claim_ids": len({key[0] for key in old_claims}),
        "historical_claim_versions": len(old_claims),
        "units_with_reports_and_verdicts": len(units),
        "preserved_snapshot_members": len(preserved),
        "supplementary_live_paths": len(supplementary),
        "old_input_sizes_match_inventory": True,
        "formal_replay_inputs_match_old_bytes": True,
        "report_verdict_summary_links_consistent": True,
        "official_graph_check_exit": 2,
        "graph_limitation": "No active graph; exploratory review, outside writable scope.",
        "mathematical_acceptance": "not_decided_by_this_check",
        "independent_review": "pending_native_host_reviewer",
    }, indent=2))


if __name__ == "__main__":
    main()
