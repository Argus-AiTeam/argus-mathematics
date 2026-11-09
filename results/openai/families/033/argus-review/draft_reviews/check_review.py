"""Check old-draft coverage and saved evidence, not mathematical correctness."""

import json
from collections import Counter, defaultdict
from pathlib import Path


def load(path):
    return json.loads(Path(path).read_text())


def main():
    root = Path.cwd().resolve()
    index_path = Path("research/DRAFT_REVIEW_INDEX.json")
    index = load(index_path)
    prior = load("PRIOR_DRAFTS.json")
    old = Path(prior["old_workspace"])
    state = load(old / "research/MATH_STATE.json")
    summary = Path("research/OLD_ROUND_REVIEW.md").read_text()

    inventory = {a["path"]: a["bytes"] for a in prior["artifacts"]}
    assert len(inventory) == len(prior["artifacts"]) == 17
    assert Counter(a["path"] for a in index["artifacts"]) == Counter(
        inventory.keys()
    ), "Inventory/index artifact mismatch"
    for artifact in index["artifacts"]:
        path = artifact["path"]
        assert artifact["inventory_bytes"] == artifact["observed_bytes"] == inventory[path]
        assert artifact["present"] is True
        if not artifact["units"]:
            assert artifact.get("exclusion") and path == "research/MATH_STATE.json.lock"
        assert artifact["count_as_result"] is False
    assert Counter(r["path"] for r in index["reference_inputs_and_tooling"]) == Counter(
        r["path"] for r in prior["reference_inputs_and_tooling"]
    )
    assert len(index["reference_inputs_and_tooling"]) == 1

    units = {u["id"]: u for u in index["units"]}
    assert len(units) == len(index["units"]) == 6
    mapped = []
    for unit in units.values():
        verdict = load(unit["verdict"])
        report = Path(unit["report"]).read_text()
        assert verdict["unit_id"] == unit["id"]
        assert verdict["assessment"] == unit["assessment"]
        assert verdict["review_state"] == "engineer_assessment_complete"
        assert verdict["independent_review_required"] is True
        assert verdict["family_accepted"] is False
        assert verdict["actual_lean_theorem"] is None
        assert verdict["current_evidence"] == unit["current_evidence"]
        expected = {(c["id"], v) for c in unit["claims"] for v in c["versions"]}
        actual = {(c["id"], v) for c in verdict["claims"] for v in c["versions"]}
        assert actual == expected, unit["id"]
        mapped.extend((c["id"], v) for c in unit["claims"] for v in c["versions"])
        assert all(c["id"] in report for c in unit["claims"]), unit["id"]
        assert unit["id"] in summary and unit["assessment"] in summary
        for path in unit["current_evidence"]:
            assert Path(path).is_file(), path
    assert Counter(mapped) == Counter(
        (c["claim_id"], c["version"]) for c in state["claims"]
    ), "Historical claim/version coverage mismatch"
    assert len(mapped) == 23 and len({c for c, _ in mapped}) == 13

    catalog = index["historical_catalog"]
    assert catalog["contexts"] == state["contexts"]
    assert catalog["evidence"] == state["evidence"]
    assert catalog["routes"] == state["routes"]
    claims = {c["claim_id"]: c for c in catalog["claims"]}
    assert set(claims) == {c["claim_id"] for c in state["claims"]}
    assumptions = {a["assumption_id"]: a for a in catalog["assumptions"]}
    assert len(assumptions) == 10
    uses = defaultdict(set)
    for claim in state["claims"]:
        imported = claims[claim["claim_id"]]
        for key in ("natural_statement", "formal_statement", "context", "content_hash"):
            assert imported[key] == claim[key], (claim["claim_id"], claim["version"], key)
        versions = {v["version"]: v for v in imported["versions"]}
        version = versions[claim["version"]]
        assert version["assumption_ids"] == [
            a["assumption_id"] for a in claim["external_assumptions"]
        ]
        assert version["retired_assumptions"] == claim["retired_assumptions"]
        assert any(
            c["id"] == claim["claim_id"]
            for c in units[imported["unit_id"]]["claims"]
        )
        for assumption in claim["external_assumptions"]:
            assert all(
                assumptions[assumption["assumption_id"]][key] == value
                for key, value in assumption.items()
            )
            uses[assumption["assumption_id"]].add(
                (claim["claim_id"], claim["version"])
            )
    for assumption in assumptions.values():
        assert {
            (u["claim_id"], u["version"]) for u in assumption["used_by_versions"]
        } == uses[assumption["assumption_id"]]

    claim_hashes = {c["content_hash"] for c in state["claims"]}
    assumption_hashes = {a["content_hash"] for a in assumptions.values()}
    assigned_evidence = set()
    for unit in units.values():
        ids = {c["id"] for c in unit["claims"]}
        aids = {
            a["assumption_id"]
            for a in assumptions.values()
            if any(u[0] in ids for u in uses[a["assumption_id"]])
        }
        expected = {
            e["evidence_id"]
            for e in state["evidence"]
            if e["subject"]["subject_id"] in ids | aids
        }
        assert set(unit["historical_evidence_ids"]) == expected, unit["id"]
        assigned_evidence.update(expected)
    assert assigned_evidence == {e["evidence_id"] for e in state["evidence"]}
    for evidence in state["evidence"]:
        assert evidence["subject"]["content_hash"] in claim_hashes | assumption_hashes
        assert evidence["artifact"] in inventory
        assert (old / evidence["artifact"]).is_file()
    strongest = next(
        e for e in state["evidence"]
        if e["evidence_id"] == "judgement-C_COMMON_TAIL_DIMENSION-adb16092602d"
    )
    assert strongest["subject"]["content_hash"] == claims["C_COMMON_TAIL_DIMENSION"]["content_hash"]
    assert strongest["produced_by"] == "reviewer:copilot-872fb7da27af"

    # Check the recorded identity measurements without repeating source-hash scans.
    manifest = load(prior["preserved_snapshot_manifest"])
    archived = {
        f["path"].removeprefix("9000033/"): f
        for f in manifest["files"]
        if f["path"].startswith("9000033/")
    }
    measured = {f["path"]: f for f in index["snapshot_identity"]["measured_matches"]}
    assert set(archived) == set(measured) and len(measured) == 5
    for path, measurement in measured.items():
        assert measurement["matches"] is True
        assert measurement["sha256"] == archived[path]["sha256"]
        assert measurement["bytes"] == inventory[path]
    assert set(index["snapshot_identity"]["not_in_family_slice"]) == set(inventory) - set(archived)
    reference = load(prior["manuscript_reference_manifest"])
    packages = {
        p["manuscript_id"]: p for p in index["reference_source_identity"]["packages"]
    }
    assert set(packages) == {p["manuscript_id"] for p in reference["manuscripts"]}
    assert index["reference_source_identity"]["manifest_reported_revision"] == reference["upstream_commit"]
    for package in reference["manuscripts"]:
        imported = packages[package["manuscript_id"]]
        assert imported["source_revision"] == package["source_revision"]
        assert imported["tex_sources"] == [f["path"] for f in package["tex_sources"]]
        assert imported["measured_matches"] == len(package["tex_sources"])
        assert imported["whole_manuscript_independently_verified"] is False
    assert sum(p["measured_matches"] for p in packages.values()) == 58

    replay = load("research/draft_reviews/local-tail-kernel/replay.json")
    assert replay["exit_code"] == 0 and replay["timeout"] is False
    assert replay["stderr"] == ""
    result = replay["output"]
    assert result["ok"] is True
    assert len(result["universal_operator_implications"]) == 8
    assert result["negative_controls_rejected"] == 10
    assert result["arbitrary_length_word_induction"] is True
    assert result["dimension_independent_rank_identity"] is True
    assert result["full_geometric_claim_mechanically_verified"] is False
    assert result["manuscript_refuted"] is False
    payload = load("research/draft_reviews/root-kernel/jacobian-payload.json")
    output = load("research/draft_reviews/root-kernel/jacobian-output.json")
    status = load("research/draft_reviews/root-kernel/jacobian-status.json")
    assert output["request"]["payload"] == payload
    assert output["request"]["operation_id"] == output["result"]["operation_id"] == "matrix.symbolic.rank.compute"
    assert output["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == "2025-11-25"
    assert output["result"]["output"] == {
        "method": "EXACT_SYMBOLIC_ROW_REDUCTION",
        "rank": 3,
        "pivot_columns": [0, 1, 2],
    }
    assert status["exit_code"] == 0 and status["timeout"] is False
    assert status["structured_error"] is None
    assert status["payload_matches_historical_request"] is True
    frontier = load(units["downstream-frontier"]["verdict"])
    assert len(frontier["unverified_interfaces"]) == 6
    assert len(frontier["supported_conditional_steps"]) == 3
    assert len(frontier["claims"]) == 4 and not frontier["historical_receipts"]

    current = load("research/MATH_STATE.json")
    assert set(index["current_review_ledger"]["finding_ids"]) <= {
        c["claim_id"] for c in current["claims"]
    }
    weighted = max(
        (c for c in current["claims"] if c["claim_id"] == "C_REVIEW033_WEIGHTED"),
        key=lambda c: c["version"],
    )
    assert len(weighted["external_assumptions"]) == 10
    assert all(
        a["assumption_id"].startswith("OLD033_")
        for a in weighted["external_assumptions"]
    )
    assert all(
        e["produced_by"] == "engineer:copilot-84490772"
        for e in current["evidence"]
        if e["subject"]["subject_id"].startswith("C_REVIEW033_")
    )
    validation_path = Path("research/draft_reviews/review-validation.json")
    validation = load(validation_path)
    assert validation["project_root"] == str(root)
    assert [c["exit_code"] for c in validation["official_checks"]] == [0, 2]
    assert all(c["command"][-1] == str(root) for c in validation["official_checks"])
    assert not Path("research/PROOF_GRAPH.json").exists(), (
        "A new graph appeared; that material change needs fresh official feedback."
    )
    assert index["handoff_gate"]["passes"] is False
    assert index["family_accepted"] is False
    assert "exits **2**" in summary and "Handoff gate blocked" in summary

    index["coverage"].update(
        final_coverage_check="pass",
        historical_assumptions=10,
        historical_evidence_receipts=28,
        all_required_reports_and_verdicts_present=True,
    )
    index["review_checker"] = "research/draft_reviews/check_review.py"
    validation["coverage_check"] = {
        "exit_code": 0,
        "listed_artifacts": 17,
        "reference_directories": 1,
        "units": 6,
        "claim_ids": 13,
        "claim_versions": 23,
        "assumptions": 10,
        "evidence_receipts": 28,
        "reports": 6,
        "verdicts": 6,
        "issues": [],
        "scope": "Exact inventory, version, statement, dependency, receipt and "
        "report/verdict/summary consistency; saved replay contracts, not a proof checker.",
    }
    validation.update(
        all_requested_review_outputs_present=True,
        native_independent_review_required=True,
        overall_engineer_handoff_gate_passed=False,
    )
    index_path.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    validation_path.write_text(json.dumps(validation, indent=2, ensure_ascii=True) + "\n")
    assert load(index_path)["coverage"]["final_coverage_check"] == "pass"
    assert load(validation_path)["coverage_check"]["exit_code"] == 0
    print(json.dumps({
        "project_root": str(root),
        "coverage_check_exit_code": 0,
        "artifacts": 17,
        "reference_directories": 1,
        "units": 6,
        "claims": 13,
        "claim_versions": 23,
        "assumptions": 10,
        "historical_receipts": 28,
        "math_state_exit_code": 0,
        "proof_graph_exit_code": 2,
        "handoff_gate_passed": False,
        "next_owner": "reviewer",
    }, indent=2))
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
