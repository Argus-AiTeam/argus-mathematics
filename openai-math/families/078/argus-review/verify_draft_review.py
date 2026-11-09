"""Populate the source inventory and check exhaustive old-draft review coverage."""

import argparse
import hashlib
import json
import os
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"
CLASSIFICATIONS = (
    "confirmed_original",
    "confirmed_reproduction",
    "refutes_argus_attack",
    "invalid",
    "unresolved",
)


def read_json(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def files_under(root):
    for current, directories, files in os.walk(root):
        directories[:] = sorted(
            d for d in directories if d not in (".git", "__pycache__")
        )
        for name in sorted(files):
            if not name.endswith(".pyc"):
                yield Path(current) / name


def populate():
    index = read_json(INDEX)
    contract = read_json(ROOT / "PRIOR_DRAFTS.json")
    old = Path(contract["old_workspace"])
    ledger = read_json(old / "research/MATH_STATE.json")
    graph = read_json(old / "research/PROOF_GRAPH.json")
    snapshot_path = Path(contract["preserved_snapshot_manifest"])
    snapshot = read_json(snapshot_path)
    preserved = {
        row["path"].split("/", 1)[1]: row
        for row in snapshot["files"]
        if row["path"].startswith(old.name + "/")
    }
    expected = {row["path"]: row for row in contract["artifacts"]}
    actual = {row["path"]: row for row in index["artifacts"]}
    assert len(expected) == len(actual) == 20 and expected.keys() == actual.keys()
    for path, row in actual.items():
        source = old / path
        row["bytes"] = source.stat().st_size
        row["inventory_bytes"] = expected[path]["bytes"]
        row["sha256"] = digest(source)
        assert row["bytes"] == row["inventory_bytes"], path
        if path in preserved:
            row["snapshot_sha256"] = preserved[path]["sha256"]
            row["snapshot_match"] = row["sha256"] == row["snapshot_sha256"]
            assert row["snapshot_match"], path
        else:
            row["snapshot_match"] = None
            row["snapshot_limitation"] = "Listed auxiliary file absent from snapshot manifest."
    index["snapshot"] = {
        "manifest": str(snapshot_path),
        "version": snapshot["snapshot"],
        "archive": str(snapshot_path.parent / snapshot["archive"]),
        "manifest_hashed_artifacts": len(preserved),
        "matched_artifacts": sum(row.get("snapshot_match") is True for row in actual.values()),
        "auxiliary_artifacts_without_snapshot_hash": len(actual) - len(preserved),
    }
    assignments = {
        claim: unit["unit_id"]
        for unit in index["units"]
        for claim in unit["claim_ids"]
    }
    assert len(assignments) == sum(len(u["claim_ids"]) for u in index["units"])
    assert assignments.keys() == {c["claim_id"] for c in ledger["claims"]}
    assumptions = {}
    versions = []
    for claim in ledger["claims"]:
        row = {
            "claim_id": claim["claim_id"],
            "version": claim["version"],
            "unit_id": assignments[claim["claim_id"]],
            "statement": claim["natural_statement"],
            "content_hash": claim["content_hash"],
            "context": claim["context"],
            "formal_source": "research/directional_bootstrap/Main.lean"
            if claim["formal_statement"] else None,
            "external_assumptions": [],
            "retired_assumptions": claim["retired_assumptions"],
            "evidence_ids": [],
        }
        for assumption in claim["external_assumptions"]:
            key = (assumption["assumption_id"], assumption["content_hash"])
            assumptions[key] = assumption
            row["external_assumptions"].append(
                {"assumption_id": key[0], "content_hash": key[1]}
            )
        row["evidence_ids"] = [
            e["evidence_id"] for e in ledger["evidence"]
            if e["subject"]["kind"] == "claim"
            and e["subject"]["subject_id"] == claim["claim_id"]
            and e["subject"]["content_hash"] == claim["content_hash"]
        ]
        versions.append(row)
    index["context_versions"] = ledger["contexts"]
    index["claim_versions"] = versions
    index["assumption_versions"] = [
        {
            **a,
            "evidence_ids": [
                e["evidence_id"] for e in ledger["evidence"]
                if e["subject"]["kind"] == "assumption"
                and e["subject"]["subject_id"] == a["assumption_id"]
                and e["subject"]["content_hash"] == a["content_hash"]
            ],
            "used_by_versions": [
                {"claim_id": c["claim_id"], "version": c["version"]}
                for c in versions if {
                    "assumption_id": a["assumption_id"],
                    "content_hash": a["content_hash"],
                } in c["external_assumptions"]
            ],
        }
        for a in assumptions.values()
    ]
    index["evidence_records"] = ledger["evidence"]
    index["route_records"] = ledger["routes"]
    index["historical_graph_nodes"] = [
        {
            "node_id": name,
            **node,
            "unit_id": assignments.get(name)
            or index["graph_only_nodes"].get(name, {}).get("unit_id"),
        }
        for name, node in graph["nodes"].items()
    ]
    index["historical_status_reconciliation"] = {
        "rule": "Statement-hash-matched independent evidence is retained; pending prose and graph labels are not contrary mathematical evidence.",
        "claim_hash_does_not_discharge_dependencies": True,
        "finite_core_certificate_is_not_review_claim_evidence": True,
        "application_assumptions_remain_conditional": ["ONE_LABEL_OUTPUT", "NO_STRIP_BRANCH"],
        "whole_manuscript_remains_unverified": ["BR_MAIN", "BR_OTHER_ARGUMENTS"],
    }
    manifest_path = Path(contract["manuscript_reference_manifest"])
    manuscript_manifest = read_json(manifest_path)
    manuscript = next(
        m for m in manuscript_manifest["manuscripts"]
        if m["manuscript_id"] == index["manuscript_id"]
    )
    source_root = Path(manuscript["source_directory"])
    reference_root = old / contract["reference_inputs_and_tooling"][0]["path"]
    aliases = []
    for current, directories, unused in os.walk(reference_root):
        directories[:] = sorted(d for d in directories if d != ".git")
        for name in directories:
            path = Path(current) / name
            if path.is_symlink():
                aliases.append({
                    "path": str(path.relative_to(old)),
                    "link_target": os.readlink(path),
                    "resolved_target": str(path.resolve(strict=True)),
                })
    assert aliases and all(Path(a["resolved_target"]) == source_root for a in aliases)
    canonical = {row["path"]: row["sha256"] for row in manuscript["tex_sources"]}
    reference_files = []
    for source in files_under(source_root):
        path = str(source.relative_to(source_root))
        if path.endswith("07-rate-transfer.tex"):
            units = ["analytical-bridges", "bounded-bootstrap", "asymmetric-strengthening", "conditional-application", "product-replacement-attack"]
            disposition = "exact_target_and_upstream_conditional_source"
        elif path.endswith("03-projection.tex"):
            units = ["analytical-bridges", "prior-result-attribution"]
            disposition = "weighted_projection_source"
        elif path.endswith("02-entropy.tex"):
            units = ["bounded-bootstrap", "conditional-application"]
            disposition = "homogenization_and_profile_source"
        elif path.endswith("01-introduction.tex"):
            units = ["whole-manuscript", "prior-result-attribution"]
            disposition = "theorem_statement_not_whole_proof_verification"
        elif "/sections/" in path:
            units = ["whole-manuscript"]
            disposition = "original_manuscript_outside_bounded_draft_no_new_error_sweep"
        else:
            units = ["whole-manuscript"] if path.endswith(("README.md", "paper.tex", "references.bib")) else []
            disposition = "reference_context_or_build_tooling_not_an_argus_result"
        row = {
            "path": path,
            "bytes": source.stat().st_size,
            "sha256": digest(source),
            "unit_ids": units,
            "disposition": disposition,
        }
        if path in canonical:
            row["manifest_sha256"] = canonical[path]
            row["manifest_match"] = row["sha256"] == canonical[path]
            assert row["manifest_match"], path
        reference_files.append(row)
    assert set(canonical) <= {r["path"] for r in reference_files}
    index["reference_tree"] = {
        "listed_path": str(reference_root.relative_to(old)),
        "manifest": str(manifest_path),
        "source_revision": manuscript["source_revision"],
        "resolved_source_directory": str(source_root),
        "aliases": aliases,
        "files": reference_files,
        "manifest_hashed_files": len(canonical),
        "matched_files": sum(r.get("manifest_match") is True for r in reference_files),
        "non_manifest_context_files": [r["path"] for r in reference_files if r["path"] not in canonical],
    }
    index["counts"] = {
        "listed_artifacts": len(actual),
        "reference_files": len(reference_files),
        "mathematical_units": len(index["units"]),
        "claim_ids": len(assignments),
        "claim_versions": len(versions),
        "assumption_versions": len(assumptions),
        "evidence_records": len(ledger["evidence"]),
        "independent_evidence_records": sum(e["produced_by"] == "reviewer:copilot-independent" for e in ledger["evidence"]),
        "route_records": len(ledger["routes"]),
        "historical_graph_nodes": len(graph["nodes"]),
    }
    INDEX.write_text(json.dumps(index, indent=2) + "\n")
    print(json.dumps({"project_root": str(ROOT), "inventory": index["counts"], "snapshot": index["snapshot"], "source_matches": index["reference_tree"]["matched_files"]}, indent=2))


def finalize():
    index = read_json(INDEX)
    reused_by = {}
    for unit in index["units"]:
        base = "research/draft_reviews/" + unit["unit_id"]
        verdict = read_json(ROOT / base / "verdict.json")
        unit["report"] = base + "/report.md"
        unit["verdict"] = base + "/verdict.json"
        unit["assessment"] = verdict["assessment"]
        assert verdict["classification"] in CLASSIFICATIONS, unit["unit_id"]
        unit["classification"] = verdict["classification"]
        unit["attribution_rationale"] = verdict["attribution_rationale"]
        unit["covered_claim_versions"] = [
            {"claim_id": c["claim_id"], "versions": c["versions"]}
            for c in verdict["old_claims"]
        ]
        for evidence in verdict["reused_evidence"]:
            reused_by.setdefault(evidence, []).append(unit["unit_id"])
    coverage = []
    for evidence in index["evidence_records"]:
        subject = evidence["subject"]
        claims = [
            {"claim_id": c["claim_id"], "version": c["version"], "unit_id": c["unit_id"]}
            for c in index["claim_versions"]
            if subject["kind"] == "claim"
            and c["claim_id"] == subject["subject_id"]
            and c["content_hash"] == subject["content_hash"]
        ]
        assumptions = [
            a for a in index["assumption_versions"]
            if subject["kind"] == "assumption"
            and a["assumption_id"] == subject["subject_id"]
            and a["content_hash"] == subject["content_hash"]
        ]
        units = {c["unit_id"] for c in claims}
        for assumption in assumptions:
            for use in assumption["used_by_versions"]:
                units.update(
                    c["unit_id"] for c in index["claim_versions"]
                    if c["claim_id"] == use["claim_id"] and c["version"] == use["version"]
                )
        units.update(reused_by.get(evidence["evidence_id"], []))
        assert units and (claims or assumptions), evidence["evidence_id"]
        if evidence["tier"] == "mechanical":
            role = "historical_mechanical_finite_only"
        elif evidence["produced_by"] == "reviewer:copilot-independent":
            role = "historical_independent_" + evidence["verdict"]
        else:
            role = "historical_engineer_opinion"
        coverage.append({
            "evidence_id": evidence["evidence_id"],
            "role": role,
            "unit_ids": sorted(units),
            "exact_claim_versions": claims,
            "exact_assumption_versions": [
                {"assumption_id": a["assumption_id"], "content_hash": a["content_hash"]}
                for a in assumptions
            ],
            "directly_reused_by_reports": reused_by.get(evidence["evidence_id"], []),
            "artifact": evidence["artifact"],
            "not_native_acceptance": True,
        })
    index["evidence_coverage"] = coverage
    by_claim = {c["claim_id"]: c["unit_id"] for c in index["claim_versions"]}
    for node in index["historical_graph_nodes"]:
        if node["node_id"] in by_claim:
            node["assessment_locator"] = "research/draft_reviews/" + by_claim[node["node_id"]] + "/report.md"
        else:
            disposition = index["graph_only_nodes"][node["node_id"]]
            node["review_disposition"] = disposition["disposition"]
            if disposition["unit_id"]:
                node["assessment_locator"] = "research/draft_reviews/" + disposition["unit_id"] + "/report.md"
    index["version_reconciliation"] = [
        "DB_FINITE_CORE v1 has no exact-hash evidence; v2 adds formal text and has the compiler/independent-reading bindings. Same mathematics, distinct certificates and claim hashes.",
        "DB_MAIN v1 registers no RW41, v2 registers abbreviated hash 1d5e25e..., and v3 registers detailed hash 95d5f6fb.... The unchanged conclusion hash never discharges a changed dependency.",
        "DB_ASYMMETRIC v1 has no registered input; v2 uses the detailed RW41. DB_PROJECTION_INPUT v1-v2 likewise adds the detailed input without creating another result.",
        "DB_APPLICATION v1 is conditional in prose; v2 registers ONE_LABEL_OUTPUT, v3 also NO_STRIP_BRANCH. Both remain undischarged despite support for the conditional argument.",
        "DB_PRIOR_RESULTS v1-v3 adds unversioned OSW and then versioned SW assumptions; this is attribution refinement, not three original results.",
        "Both old literature records archive the same two-paper excerpt, but bind different versioned propositions; they are not two independent readers or duplicated theorem proofs.",
    ]
    finite = read_json(ROOT / "research/draft_reviews/finite-core/verdict.json")
    index["replay_records"] = finite["replay"]
    index["replay_duplicates"] = {
        "source": "research/draft_reviews/finite-core/replay/Main.lean",
        "fidelity": "research/draft_reviews/finite-core/replay/statement_fidelity.md",
        "relation": "Verbatim old-source reproduction, not a new mathematical unit or evidence for the review claim.",
    }
    index["current_review_ledger"] = {
        "path": "research/MATH_STATE.json",
        "review_claim_id": "OLD_DRAFT_REVIEW",
        "separate_reproduction_claim_id": "DB_FINITE_CORE_REPLAY",
        "cited_assumptions": ["RW41", "SW_PRECEDENT", "OSW_PRECEDENT"],
        "undischarged_application_assumptions": ["ONE_LABEL_OUTPUT", "NO_STRIP_BRANCH"],
        "current_citation_evidence": ["citation-RW41-20bda673fbbb", "citation-SW_PRECEDENT-ae9775bba048"],
        "review_has_mechanical_certificate": False,
    }
    index["classification_basis"] = "Contribution relative to the pinned manuscript, within each unit's stated hypotheses and supported scope; not verified global novelty or native acceptance."
    index["classification_counts"] = {
        classification: sum(
            u["classification"] == classification for u in index["units"]
        )
        for classification in CLASSIFICATIONS
    }
    index["coverage_status"] = "all_units_assessed_native_acceptance_pending"
    INDEX.write_text(json.dumps(index, indent=2) + "\n")
    print(json.dumps({"project_root": str(ROOT), "units_indexed": len(index["units"]), "classification_counts": index["classification_counts"], "evidence_records_mapped": len(coverage), "native_acceptance": False}, indent=2))


def check():
    index = read_json(INDEX)
    contract = read_json(ROOT / "PRIOR_DRAFTS.json")
    expected = {a["path"] for a in contract["artifacts"]}
    assert expected == {a["path"] for a in index["artifacts"]} and len(expected) == 20
    all_units = {u["unit_id"] for u in index["units"]}
    expected_versions = {}
    for row in index["claim_versions"]:
        expected_versions.setdefault(row["claim_id"], []).append(row["version"])
    covered = {}
    for unit in index["units"]:
        base = ROOT / "research/draft_reviews" / unit["unit_id"]
        report = (base / "report.md").read_text()
        verdict = read_json(base / "verdict.json")
        assert verdict["unit_id"] == unit["unit_id"]
        assert verdict["research_target_level"] == "exploratory"
        assert verdict["novelty_status"] == "not_applicable"
        assert verdict["acceptance_status"] == "awaiting_native_independent_reviewer"
        assert verdict["independent_acceptance"] is False
        for key in ("hypotheses", "source_version", "attribution", "attribution_rationale", "contribution_type", "supported_scope", "unresolved_gaps"):
            assert verdict[key], (unit["unit_id"], key)
        classification = verdict["classification"]
        assert classification in CLASSIFICATIONS, unit["unit_id"]
        assert isinstance(verdict["attribution_rationale"], str)
        assert unit["classification"] == classification
        assert unit["attribution_rationale"] == verdict["attribution_rationale"]
        assert f"**Classification: `{classification}`.**" in report
        assert "## Contribution classification and attribution rationale" in report
        assert {c["claim_id"] for c in verdict["old_claims"]} == set(unit["claim_ids"])
        for claim in verdict["old_claims"]:
            claim_id = claim["claim_id"]
            assert claim_id not in covered
            assert sorted(claim["versions"]) == sorted(expected_versions[claim_id])
            for key in ("assessment", "novelty_status", "attribution", "open_status", "hypotheses", "supported_scope", "unresolved_gaps"):
                assert claim[key], (claim_id, key)
            assert claim_id in report
            covered[claim_id] = sorted(claim["versions"])
        if unit["unit_id"] == "conditional-application":
            assumption_ids = {
                a if isinstance(a, str) else a["assumption_id"]
                for a in verdict["external_assumptions"]
            }
            assert {"ONE_LABEL_OUTPUT", "NO_STRIP_BRANCH"} <= assumption_ids
            assert verdict["assessment"] == "supported_conditional"
        if unit["unit_id"] == "whole-manuscript":
            assert verdict["assessment"] == "unverified_outside_bounded_review"
        for artifact in index["artifacts"]:
            assert set(artifact["unit_ids"]) <= all_units
            assert artifact["unit_ids"] or artifact.get("exclusion")
    assert covered == {k: sorted(v) for k, v in expected_versions.items()}
    summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
    assert all(unit in summary for unit in all_units)
    for unit in index["units"]:
        rows = [
            line for line in summary.splitlines()
            if line.startswith(f"| **{unit['unit_id']}**:")
        ]
        assert len(rows) == 1 and f"`{unit['classification']}`" in rows[0]
    assert index["classification_counts"] == {
        classification: sum(
            u["classification"] == classification for u in index["units"]
        )
        for classification in CLASSIFICATIONS
    }
    old = Path(index["old_workspace"])
    unchanged = all(digest(old / row["path"]) == row["sha256"] for row in index["artifacts"])
    assert unchanged, "Preserved old inputs changed"
    source_root = Path(index["reference_tree"]["resolved_source_directory"])
    assert all(digest(source_root / row["path"]) == row["sha256"] for row in index["reference_tree"]["files"])
    evidence_ids = {e["evidence_id"] for e in index["evidence_records"]}
    assert all(set(row["evidence_ids"]) <= evidence_ids for row in index["claim_versions"])
    assert evidence_ids == {e["evidence_id"] for e in index["evidence_coverage"]}
    independent_ids = {
        e["evidence_id"] for e in index["evidence_records"]
        if e["produced_by"] == "reviewer:copilot-independent"
    }
    assert all(e["directly_reused_by_reports"] for e in index["evidence_coverage"] if e["evidence_id"] in independent_ids)
    assert all(row["unit_ids"] or row["disposition"] for row in index["reference_tree"]["files"])
    assert all(row.get("assessment_locator") or row.get("review_disposition") for row in index["historical_graph_nodes"])
    gates = read_json(ROOT / "research/review_gate_check.json")
    assert gates["project_root"] == str(ROOT)
    assert {c["module"] for c in gates["checks"]} == {
        "argus_skill.verticals.math.math_state",
        "argus_skill.verticals.math.proof_graph_check",
    }
    assert all(c["project_root"] == str(ROOT) and c["exit_status"] == 0 for c in gates["checks"])
    replay = ROOT / "research/draft_reviews/finite-core/replay"
    completion = read_json(replay / "lean_completion_status.json")
    assert completion["state"] == "done" and completion["exit_code"] == 0
    lean = json.loads(completion["stdout_tail"])
    assert lean["status"] == "success" and lean["exit_code"] == lean["audit_exit_code"] == 0
    assert lean["proof_holes"] == []
    assert digest(replay / "Main.lean") == lean["source_sha256"]
    assert digest(replay / "statement_fidelity.md") == lean["statement_fidelity_sha256"]
    assert lean["kernel"]["recorded"]["subject"]["subject_id"] == "DB_FINITE_CORE_REPLAY"
    current = read_json(ROOT / "research/MATH_STATE.json")
    assert not any(e["tier"] == "mechanical" and e["subject"]["subject_id"] == "OLD_DRAFT_REVIEW" for e in current["evidence"])
    jacobian = read_json(replay / "jacobian_condition_execution.json")
    assert jacobian["adapter_exit_status"] == 0 and jacobian["timeout"] is False
    assert jacobian["structured_error"] is None
    assert jacobian["exact_payload_preserved"] and jacobian["matches_preserved_typed_output"]
    result = {
        "project_root": str(ROOT),
        "exit_status": 0,
        "artifacts_covered": len(expected),
        "reference_files_covered": len(index["reference_tree"]["files"]),
        "units_assessed": len(all_units),
        "claim_ids_covered": len(covered),
        "claim_versions_covered": sum(len(v) for v in covered.values()),
        "units_with_required_classification_and_rationale": len(all_units),
        "classification_counts": index["classification_counts"],
        "historical_evidence_records_mapped": len(evidence_ids),
        "historical_independent_records_reused": len(independent_ids),
        "historical_graph_nodes_accounted_for": len(index["historical_graph_nodes"]),
        "old_inputs_unchanged": unchanged,
        "official_campaign_checks": [c["exit_status"] for c in gates["checks"]],
        "fresh_lean_compile_and_axiom_audit": [lean["exit_code"], lean["audit_exit_code"]],
        "review_claim_has_no_mechanical_evidence": True,
        "independent_acceptance": False,
    }
    (ROOT / "research/draft_review_check.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("populate", "finalize", "check"))
    args = parser.parse_args()
    {"populate": populate, "finalize": finalize, "check": check}[args.operation]()
