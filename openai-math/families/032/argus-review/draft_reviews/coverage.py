#!/usr/bin/env python3
"""Reconcile the assigned old-draft inventory and its mathematical units."""

import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"
UNITS = {
    "actual-group": {
        "title": "Actual small-column Hodge groups and derived independence",
        "kind": "prose_theorem_with_exact_algebraic_checks",
        "dependencies": [],
    },
    "determinant-supply": {
        "title": "All-degree determinant balance and CM correspondence supply",
        "kind": "prose_theorem_with_exact_algebraic_checks",
        "dependencies": ["actual-group"],
    },
    "cm-applicability": {
        "title": "Ordinary-geometric interpretation of the imported CM theorem",
        "kind": "statement_fidelity_and_prose_applicability_argument",
        "dependencies": ["actual-group", "determinant-supply"],
    },
    "cm-kernel": {
        "title": "Pinned Lean replay of the imported CM declaration",
        "kind": "incomplete_formal_replay",
        "dependencies": [],
    },
    "cm-consequence": {
        "title": "Conditional discharge of the CM input and all-powers corollary",
        "kind": "conditional_prose_deduction",
        "dependencies": ["determinant-supply", "cm-applicability", "cm-kernel"],
    },
    "ks10-source-inventory": {
        "title": "September 10 conditional Kuga-Satake source-claim inventory",
        "kind": "attribution_and_dependency_inventory_not_a_proof",
        "dependencies": [],
    },
    "ks30-source-inventory": {
        "title": "September 30 quadratic-locus source-claim inventory",
        "kind": "attribution_and_dependency_inventory_not_a_proof",
        "dependencies": [],
    },
    "milne-source-inventory": {
        "title": "October 7 Milne rationality source-claim inventory",
        "kind": "attribution_and_dependency_inventory_not_a_proof",
        "dependencies": [],
    },
    "weil-source-inventory": {
        "title": "Weil-powers source statements, detached proofs, and geometric tail",
        "kind": "attribution_and_dependency_inventory_not_a_proof",
        "dependencies": ["actual-group", "determinant-supply"],
    },
}
CM_UNITS = ["cm-applicability", "cm-kernel", "cm-consequence"]
CATALOG_UNITS = [
    "ks10-source-inventory", "ks30-source-inventory",
    "milne-source-inventory", "weil-source-inventory",
]


def read(path):
    return json.loads(Path(path).read_text())


def assessed_versions(assessment):
    versions = [
        item["version"] if isinstance(item, dict) else item
        for item in assessment["versions"]
    ]
    assert all(type(version) is int and version > 0 for version in versions), assessment["old_claim_id"]
    assert len(versions) == len(set(versions)), assessment["old_claim_id"]
    return versions


def claim_unit(claim_id):
    if claim_id.startswith("AG-"):
        return "actual-group"
    if claim_id.startswith("DS-"):
        return "determinant-supply"
    if claim_id.startswith(("ks10:", "ks30:", "milne:", "weil:")):
        return claim_id.split(":")[0] + "-source-inventory"
    return {
        "CM-APPLICABILITY": "cm-applicability",
        "CM-KERNEL": "cm-kernel",
        "CM-INPUT": "cm-consequence",
        "C9000032": None,
    }[claim_id]


def artifact_role(path):
    parts = Path(path).parts
    if path.endswith((".pyc", ".lock")) or "__pycache__" in parts:
        return [], "excluded_infrastructure", "No mathematical statement or evidence."
    if path in ("research/MATH_STATE.json", "research/PROOF_GRAPH.json"):
        return list(UNITS), "historical_claim_and_evidence_index", "Old labels are data, not current verdicts."
    if parts[1] == "actual_group_audit":
        if parts[-1] == "other_manuscript_claims.json":
            return CATALOG_UNITS[:3], "source_claim_catalog", "Three distinct mathematical source inventories share this file."
        if parts[-1] == "weil_tail_claims.json":
            return ["weil-source-inventory"], "source_claim_catalog", "Detached proofs and the geometric tail are not new Argus theorems."
        if parts[-1] == "populate_source_claims.py":
            return CATALOG_UNITS, "catalog_population_tool", "Records source assertions; does not prove them."
        if "literature" in parts:
            return ["actual-group", "cm-applicability"], "external_reference", "Cited foundations, not an original result."
        return ["actual-group"], "proof_checker_or_evidence", "One argument with supporting files, not one result per file."
    if parts[1] == "determinant_supply_audit":
        role = "external_reference" if "literature" in parts else "proof_checker_or_evidence"
        return ["determinant-supply"], role, "Supports the all-degree supply argument, not unconditional algebraicity."
    if parts[1] == "literature":
        return ["actual-group", "determinant-supply"], "archived_citation_evidence", "Historical reader evidence; attribution is retained below."
    if parts[1] == "cm_dependency_audit":
        if len(parts) > 2 and parts[2] in (".work", "runtime", "downloads", "tooling"):
            return ["cm-kernel", "cm-applicability"], "imported_source_dependency_or_toolchain", "Imported closure and tools are not separately authored mathematical drafts."
        if parts[-1] in ("report.tex", "report.pdf", "statement_fidelity.md"):
            return CM_UNITS, "shared_cm_proof_or_interpretation", "Three distinct obligations share the CM report."
        return ["cm-kernel"], "historical_replay_support", "Receipts, cache objects, and intermediate compiles do not certify the target."
    raise ValueError(f"Unclassified inventory artifact: {path}")


def build():
    prior = read(ROOT / "PRIOR_DRAFTS.json")
    old = Path(prior["old_workspace"])
    ledger = read(old / "research/MATH_STATE.json")
    graph = read(old / "research/PROOF_GRAPH.json")
    snapshot = read(prior["preserved_snapshot_manifest"])
    family = old.name + "/"
    selected = [x for x in snapshot["files"] if x["path"].startswith(family)]
    snapshot_by_path = {x["path"][len(family):]: x for x in selected}
    versions = defaultdict(list)
    for claim in ledger["claims"]:
        versions[claim["claim_id"]].append(claim["version"])
    evidence_by_subject = defaultdict(list)
    for evidence in ledger["evidence"]:
        evidence_by_subject[evidence["subject"]["subject_id"]].append(evidence)

    artifacts = []
    for item in prior["artifacts"]:
        path = item["path"]
        units, role, reason = artifact_role(path)
        actual = old / path
        size = actual.stat().st_size if actual.is_file() else None
        row = {
            "path": path, "manifest_bytes": item["bytes"], "observed_bytes": size,
            "units": units, "role": role, "reason": reason,
            "manifest_size_matches": size == item["bytes"],
        }
        if path in snapshot_by_path:
            preserved = snapshot_by_path[path]
            # The inherited digest identifies the preserved version, not new evidence.
            digest = hashlib.sha256(actual.read_bytes()).hexdigest()
            row["preserved_version"] = {
                "snapshot": snapshot["snapshot"], "sha256": preserved["sha256"],
                "bytes": preserved["bytes"],
                "matches_preserved_bytes": size == preserved["bytes"],
                "matches_preserved_digest": digest == preserved["sha256"],
            }
        artifacts.append(row)

    claims = []
    assumptions = {}
    for claim in ledger["claims"]:
        cid = claim["claim_id"]
        unit = claim_unit(cid)
        node = graph["nodes"].get(cid, {})
        refs = evidence_by_subject[cid]
        external = []
        for assumption in claim.get("external_assumptions", []):
            aid = assumption["assumption_id"]
            anchor = aid + "@" + assumption["content_hash"]
            external.append(anchor)
            entry = assumptions.setdefault(anchor, {
                "old_assumption_id": aid,
                "old_content_hash": assumption["content_hash"],
                "record": assumption, "units": [],
            })
            if unit and unit not in entry["units"]:
                entry["units"].append(unit)
        claims.append({
            "old_claim_id": cid, "old_version": claim["version"],
            "old_content_hash": claim["content_hash"],
            "old_context_id": claim["context"]["subject_id"],
            "unit": unit, "statement": claim["natural_statement"],
            "latest_old_version": max(versions[cid]),
            "duplicate_or_superseded_version": claim["version"] != max(versions[cid]),
            "role": "historical_objective_excluded" if unit is None else (
                "source_assertion_not_argus_proof" if "-source-inventory" in unit
                else "argus_claim_or_obligation"
            ),
            "proof_or_source_artifacts": node.get("evidence", []),
            "source_lines": node.get("source_lines"),
            "dependencies": node.get("depends_on", []),
            "old_evidence_ids": [x["evidence_id"] for x in refs],
            "external_assumptions": external,
        })

    evidence = []
    for item in ledger["evidence"]:
        sid = item["subject"]["subject_id"]
        matching = [a for a in assumptions.values() if a["old_assumption_id"] == sid]
        units = sorted({u for a in matching for u in a["units"]})
        if sid in versions:
            units = [claim_unit(sid)] if claim_unit(sid) else []
        evidence.append({
            "old_evidence_id": item["evidence_id"], "subject": item["subject"],
            "units": units, "tier": item["tier"], "verdict": item["verdict"],
            "produced_by": item["produced_by"], "artifact": item.get("artifact"),
            "current_acceptance": "not_inherited",
        })

    units = []
    for uid, details in UNITS.items():
        ids = sorted({c["old_claim_id"] for c in claims if c["unit"] == uid})
        units.append({
            "unit_id": uid, **details, "old_claim_ids": ids,
            "old_claim_version_count": sum(c["unit"] == uid for c in claims),
            "report": f"research/draft_reviews/{uid}/report.md",
            "verdict": f"research/draft_reviews/{uid}/verdict.json",
            "independent_review": "required_pending_host_reviewer",
        })
    result = {
        "schema_version": 1, "task": "old_draft_review", "family": prior["family"],
        "project_root": str(ROOT), "objective": "OBJECTIVE.md",
        "old_workspace": str(old), "old_workspace_read_only": True,
        "preserved_snapshot_manifest": prior["preserved_snapshot_manifest"],
        "preserved_snapshot_archive": str(Path(prior["preserved_snapshot_manifest"]).parent / snapshot["archive"]),
        "snapshot": snapshot["snapshot"],
        "manuscript_reference_manifest": prior["manuscript_reference_manifest"],
        "grouping_rule": "A unit is a distinct mathematical argument or substantive attribution inventory; obligations, revisions, binaries, imports, and copies are not counted as independent discoveries.",
        "summary": {
            "manifest_artifacts": len(artifacts), "mathematical_units": len(units),
            "old_claim_versions": len(claims), "old_distinct_claim_ids": len(versions),
            "old_evidence_records": len(evidence), "old_routes": len(ledger["routes"]),
            "old_graph_nodes": len(graph["nodes"]),
            "snapshot_family_entries": len(selected),
            "snapshot_other_family_entries": len(snapshot["files"]) - len(selected),
            "artifact_role_counts": dict(Counter(x["role"] for x in artifacts)),
            "missing_or_size_changed": [x["path"] for x in artifacts if not x["manifest_size_matches"]],
        },
        "units": units, "artifacts": artifacts, "claim_versions": claims,
        "old_external_assumptions": list(assumptions.values()), "old_evidence": evidence,
        "old_routes": [{
            "old_route_id": r["route_id"], "goal": r["goal"]["subject_id"],
            "unit": claim_unit(r["goal"]["subject_id"]),
            "obligations": [x["subject_id"] for x in r["obligations"]],
            "retired_because": r.get("retired_because", ""),
            "current_role": "historical_plan_not_evidence",
        } for r in ledger["routes"]],
        "old_graph_nodes": [{
            "old_node_id": cid, "unit": claim_unit(cid),
            "statement": node["statement"], "dependencies": node.get("depends_on", []),
            "evidence": node.get("evidence", []),
            "source_lines": node.get("source_lines"),
            "historical_status": node.get("status"),
            "historical_reviewer_flag": node.get("reviewer_confirmed"),
            "interpretation": "Graph flags may lag the hash-bound ledger; neither is current acceptance.",
        } for cid, node in graph["nodes"].items()],
        "snapshot_family_entries": selected,
        "snapshot_exclusion": {
            "rule": f"Snapshot paths outside {family} are other campaigns, not Family 032 drafts.",
            "counts_by_campaign": dict(Counter(x["path"].split("/")[0] for x in snapshot["files"] if not x["path"].startswith(family))),
            "reports_absent_from_snapshot_manifest": "The preserved manifest has only 14 Family 032 entries; the assigned old-workspace reports remain review inputs, but no snapshot digest for an omitted report is invented.",
        },
        "reference_inputs_and_tooling": [{
            **x, "units": list(UNITS) if "openai_manuscript" in x["path"] else ["cm-kernel", "cm-applicability"],
            "reason": "Read-only source/tooling reference, not an additional authored result.",
        } for x in prior["reference_inputs_and_tooling"]],
        "justified_exclusions": [
            {"item": "C9000032 and old objectives/status labels", "reason": "Historical error-search mission is not the current review contract."},
            {"item": "Imported OAI/Mathlib/dependency sources and toolchains", "reason": "Evidence and theorem dependencies, not tens of thousands of independent Argus drafts."},
            {"item": "Source-catalog theorem correctness", "reason": "Catalogued original-paper assertions are assessed as attributions and unresolved dependencies, not silently certified or subjected to a new manuscript-error search."},
            {"item": "Repeated claim versions, PDF renderings, receipts and caches", "reason": "Mapped supporting/revision artifacts; not counted as new mathematical contributions."},
        ],
        "acceptance": "Engineer inventory; final family acceptance belongs only to the native independent Reviewer.",
    }
    INDEX.write_text(json.dumps(result, indent=2, ensure_ascii=True) + "\n")
    print(json.dumps(result["summary"], indent=2))


def finalize():
    index = read(INDEX)
    references = {}
    for unit in index["units"]:
        verdict = read(ROOT / unit["verdict"])
        assert verdict["unit_id"] == unit["unit_id"]
        unit["assessment"] = verdict["assessment"]
        unit["assessed_result_class"] = verdict["result_class"]
        unit["source_versions"] = verdict["source_versions"]
        unit["assessed_distinct_claims"] = len(verdict["claim_assessments"])
        for offset, assessment in enumerate(verdict["claim_assessments"]):
            cid = assessment["old_claim_id"]
            assert cid not in references, f"Claim counted in multiple units: {cid}"
            references[cid] = {
                "report": unit["report"], "verdict": unit["verdict"],
                "json_pointer": f"/claim_assessments/{offset}",
                "covered_old_versions": assessed_versions(assessment),
            }
    for claim in index["claim_versions"]:
        if claim["unit"]:
            claim["review_assessment"] = references[claim["old_claim_id"]]
            assert claim["old_version"] in references[claim["old_claim_id"]]["covered_old_versions"], (
                claim["old_claim_id"], claim["old_version"]
            )
    for node in index["old_graph_nodes"]:
        if node["unit"]:
            node["review_assessment"] = references[node["old_node_id"]]
    current = []
    for path in sorted((ROOT / "research/draft_reviews").rglob("*")):
        if not path.is_file() or path.suffix == ".pyc" or "__pycache__" in path.parts:
            continue
        relative = path.relative_to(ROOT)
        candidate = relative.parts[2]
        current.append({
            "path": str(relative),
            "units": [candidate] if candidate in UNITS else list(UNITS),
            "role": "unit_assessment" if path.name in ("report.md", "verdict.json")
            else "replay_or_mapping_support",
        })
    index["review_artifacts"] = current
    index["summary"]["assessed_distinct_claims"] = len(references)
    index["summary"]["assessed_old_claim_versions"] = sum(bool(c["unit"]) for c in index["claim_versions"])
    index["summary"]["excluded_historical_objective_versions"] = sum(c["unit"] is None for c in index["claim_versions"])
    index["summary"]["unit_reports"] = len(index["units"])
    index["summary"]["unit_verdicts"] = len(index["units"])
    index["summary"]["independent_acceptance"] = "pending_host_reviewer_not_issued"
    INDEX.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    print(json.dumps({
        "units": len(index["units"]), "assessed_distinct_claims": len(references),
        "assessed_old_claim_versions": index["summary"]["assessed_old_claim_versions"],
        "review_artifacts": len(current), "independent_acceptance": "not_issued",
    }, indent=2))


def check(require_reports):
    prior = read(ROOT / "PRIOR_DRAFTS.json")
    index = read(INDEX)
    ledger = read(Path(prior["old_workspace"]) / "research/MATH_STATE.json")
    graph = read(Path(prior["old_workspace"]) / "research/PROOF_GRAPH.json")
    snapshot = read(prior["preserved_snapshot_manifest"])
    assert Counter(x["path"] for x in prior["artifacts"]) == Counter(x["path"] for x in index["artifacts"])
    assert Counter((x["claim_id"], x["version"]) for x in ledger["claims"]) == Counter(
        (x["old_claim_id"], x["old_version"]) for x in index["claim_versions"])
    assert {x["evidence_id"] for x in ledger["evidence"]} == {x["old_evidence_id"] for x in index["old_evidence"]}
    assert {x["route_id"] for x in ledger["routes"]} == {x["old_route_id"] for x in index["old_routes"]}
    assert set(graph["nodes"]) == {x["old_node_id"] for x in index["old_graph_nodes"]}
    family = Path(prior["old_workspace"]).name + "/"
    assert [x for x in snapshot["files"] if x["path"].startswith(family)] == index["snapshot_family_entries"]
    assert prior["reference_inputs_and_tooling"] == [
        {k: x[k] for k in ("path", "kind")} for x in index["reference_inputs_and_tooling"]]
    assert all(x["units"] or x["role"] == "excluded_infrastructure" for x in index["artifacts"])
    assert not index["summary"]["missing_or_size_changed"], "Assigned inventory differs from the observed old files."
    assert all(x["preserved_version"]["matches_preserved_digest"] for x in index["artifacts"] if "preserved_version" in x)
    if require_reports:
        summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
        for unit in index["units"]:
            assert (ROOT / unit["report"]).is_file(), unit["unit_id"]
            verdict = read(ROOT / unit["verdict"])
            assert verdict["unit_id"] == unit["unit_id"]
            assert verdict["independent_review"]["required"] is True
            assert verdict["independent_review"]["status"] == "pending_host_reviewer"
            assessed = {x["old_claim_id"] for x in verdict["claim_assessments"]}
            assert assessed == set(unit["old_claim_ids"]), (unit["unit_id"], assessed)
            assert len(assessed) == len(verdict["claim_assessments"]), unit["unit_id"]
            for assessment in verdict["claim_assessments"]:
                expected = {
                    c["old_version"]: c for c in index["claim_versions"]
                    if c["old_claim_id"] == assessment["old_claim_id"]
                }
                assert set(assessed_versions(assessment)) == set(expected), assessment["old_claim_id"]
                for version in assessment["versions"]:
                    if isinstance(version, dict):
                        claim = expected[version["version"]]
                        assert version["content_hash"] == claim["old_content_hash"], assessment["old_claim_id"]
                        assert set(version["external_assumptions_recorded"]) == set(
                            claim["external_assumptions"]
                        ), assessment["old_claim_id"]
                assert all(k in assessment for k in (
                    "assessment", "exact_scope", "decisive_argument", "evidence",
                    "external_assumptions", "gaps", "attribution",
                )), assessment["old_claim_id"]
            assert unit["unit_id"] in summary, unit["unit_id"]
        assert index["summary"]["assessed_distinct_claims"] == 207
        assert index["summary"]["assessed_old_claim_versions"] == 217
        assert index["summary"]["excluded_historical_objective_versions"] == 1
        assert all((ROOT / x["path"]).is_file() for x in index["review_artifacts"])
        for claim in index["claim_versions"]:
            if claim["unit"]:
                assert claim["old_version"] in claim["review_assessment"]["covered_old_versions"]
    print(json.dumps({
        "project_root": str(ROOT), "coverage": "complete",
        "manifest_artifacts": len(index["artifacts"]),
        "old_claim_versions": len(index["claim_versions"]),
        "units": len(index["units"]), "reports_required": require_reports,
        "independent_acceptance": "not_issued",
    }, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("operation", choices=("build", "finalize", "check"))
    parser.add_argument("--require-reports", action="store_true")
    args = parser.parse_args()
    if args.operation == "build":
        build()
    elif args.operation == "finalize":
        finalize()
    else:
        check(args.require_reports)
