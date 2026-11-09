"""Project old records into the required review index, or check review coverage.

This checks provenance and coverage, not mathematical truth or acceptance.
"""

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"


def read(path):
    return json.loads(path.read_text())


def require(condition, message):
    if not condition:
        raise ValueError(message)


def populate(index):
    inventory = read(ROOT / "PRIOR_DRAFTS.json")
    old = Path(inventory["old_workspace"])
    state = read(old / "research/MATH_STATE.json")
    manifest = read(Path(inventory["preserved_snapshot_manifest"]))
    snapshots = {x["path"]: x for x in manifest["files"]}
    coverage = {c["claim_id"]: c for c in index["claim_coverage"]}
    require(len(coverage) == len(index["claim_coverage"]), "duplicate claim mapping")
    for artifact in index["artifacts"]:
        path = artifact["path"]
        data = (old / path).read_bytes()
        require(len(data) == artifact["inventory_bytes"], f"size changed: {path}")
        snapshot = snapshots.get(f"{old.name}/{path}")
        artifact["observed_bytes"] = len(data)
        if snapshot:
            require(hashlib.sha256(data).hexdigest() == snapshot["sha256"],
                    f"snapshot mismatch: {path}")
            artifact["snapshot_entry"] = snapshot
            artifact["snapshot_disposition"] = "matches_preserved_manifest"
        else:
            artifact["snapshot_disposition"] = (
                "Not in this snapshot manifest; reviewed from the explicitly "
                "listed read-only old workspace, not represented as snapshot-backed."
            )
    index["snapshot_reconciliation"] = {
        "listed_artifacts": len(index["artifacts"]),
        "manifest_backed": sum("snapshot_entry" in a for a in index["artifacts"]),
        "not_in_manifest": [
            a["path"] for a in index["artifacts"] if "snapshot_entry" not in a
        ],
        "archive_rebuilt": False,
    }
    versions = []
    for claim in state["claims"]:
        mapping = coverage[claim["claim_id"]]
        require(claim["version"] in mapping["versions"], "unmapped claim version")
        entry = {
            key: claim[key] for key in (
                "claim_id", "version", "content_hash", "context",
                "natural_statement", "external_assumptions", "retired_assumptions"
            )
        }
        entry["unit"] = mapping["unit"]
        entry["disposition"] = mapping["disposition"]
        entry["formal_statement_present"] = bool(claim["formal_statement"])
        if claim["formal_statement"]:
            entry["formal_statement"] = claim["formal_statement"]
        hashes = {claim["content_hash"]}
        hashes.update(a["content_hash"] for a in claim["external_assumptions"])
        entry["evidence_ids"] = [
            e["evidence_id"] for e in state["evidence"]
            if e["subject"]["content_hash"] in hashes
        ]
        versions.append(entry)
    index["claim_versions"] = versions
    index["historical_contexts"] = state["contexts"]
    index["historical_evidence"] = state["evidence"]
    index["historical_routes"] = state["routes"]
    index["historical_graph"] = read(old / "research/PROOF_GRAPH.json")
    references = read(Path(index["source_reference_manifest"]))
    sources = []
    for manuscript in references["manuscripts"]:
        base = old / "research/openai_manuscript" / manuscript["manuscript_id"]
        for source in manuscript["tex_sources"]:
            matches = hashlib.sha256(
                (base / source["path"]).read_bytes()).hexdigest() == source["sha256"]
            require(matches, f"source revision mismatch: {base / source['path']}")
            sources.append({
                "manuscript_id": manuscript["manuscript_id"],
                "path": source["path"],
                "reference_revision": manuscript["source_revision"],
                "matches_reference_digest": matches,
            })
    index["manuscript_source_fidelity"] = sources
    INDEX.write_text(json.dumps(index, indent=2) + "\n")
    return {
        "artifacts": len(index["artifacts"]),
        "claims": len(coverage),
        "claim_versions": len(versions),
        "historical_evidence_records": len(state["evidence"]),
        "units": len(index["units"]),
        "manifest_backed_artifacts": index["snapshot_reconciliation"]["manifest_backed"],
        "version_matched_manuscript_sources": len(sources),
    }


def check(index):
    inventory = read(ROOT / "PRIOR_DRAFTS.json")
    require(
        sorted(a["path"] for a in index["artifacts"]) ==
        sorted(a["path"] for a in inventory["artifacts"]),
        "inventory coverage differs",
    )
    expected = {(c["claim_id"], v) for c in index["claim_coverage"]
                for v in c["versions"]}
    actual = {(c["claim_id"], c["version"]) for c in index["claim_versions"]}
    require(expected == actual, "claim-version coverage differs")
    summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
    assessed = set()
    for unit in index["units"]:
        require(unit["id"] in summary, f"unit absent from summary: {unit['id']}")
        report = ROOT / unit["report"]
        require(report.is_file() and report.stat().st_size > 0,
                f"missing report: {report}")
        verdict = read(ROOT / unit["verdict"])
        require(verdict["unit_id"] == unit["id"], "unit ID mismatch")
        require(verdict["independent_review"] == "pending_native_reviewer",
                "Engineer must not self-accept")
        for claim in verdict["claim_assessments"]:
            require(claim["claim_id"] in unit["claims"], "claim in wrong unit")
            for version in claim["versions"]:
                key = (claim["claim_id"], version)
                require(key not in assessed, f"duplicate assessment: {key}")
                assessed.add(key)
            for field in ("assessment", "novelty_status", "open_obligations"):
                require(field in claim, f"missing {field}: {claim['claim_id']}")
    require(assessed == expected, "assessments omit or add claim versions")
    result = read(ROOT / "research/result.json")
    require(result["novelty_status"] == "not_applicable", "review asserts novelty")
    require(result["next_owner"] == "reviewer", "native review not requested")
    require(result["independent_review"] == "pending_native_reviewer",
            "result self-accepts")
    return {
        "ok": True,
        "artifacts": len(index["artifacts"]),
        "claim_versions_assessed": len(assessed),
        "historical_evidence_records": len(index["historical_evidence"]),
        "complete_unit_report_verdict_pairs": len(index["units"]),
        "mathematical_truth_or_acceptance_checked": False,
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--populate-index", action="store_true")
    arguments = parser.parse_args()
    current = read(INDEX)
    print(json.dumps(populate(current) if arguments.populate_index else check(current),
                     indent=2))
