"""Check exhaustive draft/version coverage and record read-only source bindings."""

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def load(path):
    return json.loads(Path(path).read_text())


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--record-provenance", action="store_true")
    args = parser.parse_args()
    inventory = load(ROOT / "PRIOR_DRAFTS.json")
    index_path = ROOT / "research/DRAFT_REVIEW_INDEX.json"
    index = load(index_path)
    old = Path(inventory["old_workspace"])
    ledger = load(old / "research/MATH_STATE.json")
    manifest = load(inventory["preserved_snapshot_manifest"])
    snapshot = {
        row["path"].removeprefix("9000075/"): row
        for row in manifest["files"] if row["path"].startswith("9000075/")
    }
    indexed = {row["path"]: row for row in index["artifacts"]}
    expected = {row["path"]: row for row in inventory["artifacts"]}
    require(len(index["artifacts"]) == len(indexed) == len(expected) == 24,
            "duplicate or missing inventory artifact")
    require(indexed.keys() == expected.keys(), "inventory/index path mismatch")
    require(len(snapshot) == 13 and snapshot.keys() <= indexed.keys(),
            "snapshot family is not the expected inventory subset")
    artifact_bindings = []
    for path, entry in indexed.items():
        source = old / path
        size = source.stat().st_size
        require(size == expected[path]["bytes"] == entry["bytes"], f"size changed: {path}")
        require(bool(entry["reason"]), f"missing disposition reason: {path}")
        require(entry["snapshot_entry"] == (path in snapshot), f"wrong snapshot mapping: {path}")
        sha = digest(source)
        if path in snapshot:
            require(sha == snapshot[path]["sha256"], f"preserved digest mismatch: {path}")
        artifact_bindings.append({
            "path": path, "actual_bytes": size, "sha256": sha,
            "snapshot_path": snapshot[path]["path"] if path in snapshot else None,
            "snapshot_match": sha == snapshot[path]["sha256"] if path in snapshot else None,
        })

    units = {unit["id"]: unit for unit in index["units"]}
    require(len(units) == len(index["units"]) == 9, "unit partition changed unexpectedly")
    assignments = {}
    for unit in units.values():
        for version in unit["claims"]:
            require(version not in assignments, f"claim counted twice: {version}")
            assignments[version] = unit["id"]
        report = ROOT / unit["report"]
        require(report.is_file() and len(report.read_text()) > 500, f"missing report: {unit['id']}")
        verdict = load(ROOT / unit["verdict"])
        require(verdict["unit_id"] == unit["id"], "wrong verdict unit")
        require(verdict["assessment"] in {"supported", "partially_supported", "invalid", "unresolved"},
                "unsupported assessment category")
        require({claim["historical_version"] for claim in verdict["claims"]} == set(unit["claims"]),
                f"verdict version coverage mismatch: {unit['id']}")
        require(verdict["independent_review"] == "required_pending", "engineer self-acceptance")
        for claim in verdict["claims"]:
            require(all(key in claim for key in ("disposition", "novelty_status", "attribution", "open_status")),
                    "incomplete per-claim assessment")
        if verdict["assessment"] in {"partially_supported", "unresolved"}:
            require(bool(verdict["open_obligations"]), "unresolved unit without a concrete gap")
    versions = {f"{claim['claim_id']}@{claim['version']}" for claim in ledger["claims"]}
    require(set(assignments) == versions and len(versions) == 23, "historical versions not exhaustive")
    require(len({claim["claim_id"] for claim in ledger["claims"]}) == 20, "claim count mismatch")

    evidence = []
    for item in ledger["evidence"]:
        entry = {key: item[key] for key in
                 ("evidence_id", "subject", "tier", "verdict", "produced_by", "artifact")}
        path = old / item["artifact"]
        entry["artifact_exists"] = path.is_file()
        require(path.is_file(), f"missing historical evidence: {path}")
        entry["current_artifact_sha256"] = digest(path)
        entry["binding_limit"] = (
            "Claim, exact source and fidelity text are embedded in the certificate."
            if item["tier"] == "mechanical" or path.suffix == ".json"
            else "Claim content hash and artifact path; no contemporaneous source hash in this judgement."
        )
        if item["tier"] == "mechanical":
            certificate = load(path)
            source = certificate["lean_source"]
            fidelity = certificate["statement_fidelity"]
            require(certificate["subject"] == item["subject"], "wrong mechanical claim version")
            require(source["text"] == (old / source["path"]).read_text(), "stale source certificate")
            require(fidelity["text"] == (old / fidelity["path"]).read_text(), "stale fidelity certificate")
            entry["source_text_matches"] = True
            entry["fidelity_text_matches"] = True
        evidence.append(entry)
    claims = []
    for claim in ledger["claims"]:
        version = f"{claim['claim_id']}@{claim['version']}"
        formal = claim["formal_statement"]
        claims.append({
            "historical_version": version, "unit": assignments[version],
            "statement": claim["natural_statement"], "context": claim["context"],
            "content_hash": claim["content_hash"],
            "formal_statement_matches_Main": (
                formal == (old / "research/entropy_refinement/Main.lean").read_text()
                if formal else None
            ),
            "external_assumptions": claim["external_assumptions"],
            "retired_assumptions": claim["retired_assumptions"],
            "evidence_ids": [
                item["evidence_id"] for item in ledger["evidence"]
                if item["subject"]["kind"] == "claim"
                and item["subject"]["subject_id"] == claim["claim_id"]
                and item["subject"]["content_hash"] == claim["content_hash"]
            ],
        })

    manuscript = load(inventory["manuscript_reference_manifest"])["manuscripts"][0]
    reference_bindings = []
    for entry in manuscript["tex_sources"]:
        path = old / "research/openai_manuscript" / manuscript["manuscript_id"] / entry["path"]
        require(path.is_file(), f"reference source missing: {path}")
        sha = digest(path)
        require(sha == entry["sha256"], f"reference revision differs: {path}")
        reference_bindings.append({
            "path": str(path), "sha256": sha, "manifest_match": True,
            "reference_revision": manuscript["source_revision"],
        })
    for duplicate in index["artifacts"]:
        if "duplicate_of" in duplicate:
            require((old / duplicate["path"]).read_bytes() == (old / duplicate["duplicate_of"]).read_bytes(),
                    "alleged duplicate differs")
    for path in ("certificates/C_ER_FINITE-fe02f05b69bc51fe.json",
                 "lean_certificates/certificates/C_ER_FINITE-fe02f05b69bc51fe.json"):
        certificate = load(old / "research/entropy_refinement" / path)
        require(certificate["subject"]["content_hash"] ==
                next(claim["content_hash"] for claim in ledger["claims"]
                     if claim["claim_id"] == "C_ER_FINITE" and claim["version"] == 2),
                "certificate bound to wrong finite-search version")
        for key in ("lean_source", "statement_fidelity"):
            require(certificate[key]["text"] == (old / certificate[key]["path"]).read_text(),
                    f"historical receipt text differs: {path}")

    replay_dir = ROOT / "research/draft_reviews/finite-search/replay"
    replay = load(replay_dir / "lean_check.json")
    require(replay["status"] == "success" and replay["exit_code"] == 0
            and replay["audit_exit_code"] == 0 and replay["proof_holes"] == [],
            "no fresh complete Lean replay")
    require(replay["source_sha256"] == digest(replay_dir / "Main.lean"), "stale active source replay")
    require(replay["statement_fidelity_sha256"] == digest(replay_dir / "statement_fidelity.md"),
            "stale active fidelity replay")
    require((replay_dir / "Main.lean").read_bytes() ==
            (old / "research/entropy_refinement/Main.lean").read_bytes(), "replayed another source")
    require((replay_dir / "statement_fidelity.md").read_bytes() ==
            (old / "research/entropy_refinement/statement_fidelity.md").read_bytes(),
            "replayed another interpretation")
    math_replay = load(ROOT / "research/draft_reviews/finite-search/replay_math.json")
    require(math_replay["status"] == "passed", "exact arithmetic replay missing")
    active = load(ROOT / "research/MATH_STATE.json")
    require(not any(item["tier"] == "mechanical" for item in active["evidence"]),
            "a compiler receipt was attached to the review claim")
    summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
    require(all(unit in summary for unit in units), "summary omits a unit")
    require(index["novelty_status"] == "not_applicable", "review claims mathematical novelty")
    if args.record_provenance:
        index["source_bindings"] = {
            "contexts": ledger["contexts"], "historical_claim_versions": claims,
            "historical_evidence": evidence, "historical_routes": ledger["routes"],
            "artifacts": artifact_bindings, "manuscript_references": reference_bindings,
            "historical_judgement_caveat": (
                "Reuse is as old independent opinion, not fresh acceptance. Only the finite certificate embeds "
                "exact source/fidelity text; manuscript judgements have claim hashes and source paths, "
                "not historical byte hashes. Current sources were read and match the reference revision."
            ),
        }
        index["snapshot_reconciliation"]["byte_and_version_verification"] = "all_13_match_preserved_manifest"
        index["review_state"] = "ready_for_native_independent_review"
        index["coverage"]["assessment_complete"] = True
        index_path.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    print(json.dumps({
        "status": "passed", "project_root": str(ROOT),
        "inventory_entries": 24, "snapshot_entries_matched": 13, "additional_inventory_entries": 11,
        "mathematical_units": len(units), "historical_claims": 20, "historical_versions": len(versions),
        "historical_evidence_records": len(evidence), "reference_files_matched": len(reference_bindings),
        "fresh_lean_exit_code": replay["exit_code"], "fresh_axiom_audit_exit_code": replay["audit_exit_code"],
        "engineer_self_acceptance": False,
    }, indent=2))


if __name__ == "__main__":
    main()
