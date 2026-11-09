import argparse
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"


def load(path):
    return json.loads(Path(path).read_text())


def build():
    index = load(INDEX)
    manifest = load(ROOT / "PRIOR_DRAFTS.json")
    old = Path(manifest["old_workspace"])
    ledger = load(old / "research/MATH_STATE.json")
    graph = load(old / "research/PROOF_GRAPH.json")
    preserved = load(manifest["preserved_snapshot_manifest"])
    snapshot = {entry["path"]: entry for entry in preserved["files"]}
    owners = {}
    for unit in index["units"]:
        for claim in unit["claims"]:
            if claim in owners:
                raise ValueError(f"Claim assigned twice: {claim}")
            owners[claim] = unit["id"]
    if set(owners) != {claim["claim_id"] for claim in ledger["claims"]}:
        raise ValueError("Unit assignments do not cover the old ledger")
    if set(index["artifact_roles"]) != {
        entry["path"] for entry in manifest["artifacts"]
    }:
        raise ValueError("Artifact assignments do not match the manifest")
    index["artifacts"] = []
    for entry in manifest["artifacts"]:
        record = {
            **entry,
            **index["artifact_roles"][entry["path"]],
            "read_only_source": str(old / entry["path"]),
        }
        member = snapshot.get("9000062/" + entry["path"])
        record["preserved_manifest_sha256"] = member["sha256"] if member else None
        record["historical_binding"] = (
            "sha256 matched in baseline measurement"
            if member
            else "no preserved-manifest member; measured presence and size only"
        )
        index["artifacts"].append(record)
    index["contexts"] = ledger["contexts"]
    index["claim_versions"] = []
    assumptions = {}
    for position, claim in enumerate(ledger["claims"]):
        record = {
            "claim_id": claim["claim_id"],
            "version": claim["version"],
            "content_hash": claim["content_hash"],
            "context": claim["context"],
            "statement": claim["natural_statement"],
            "unit": owners[claim["claim_id"]],
            "source_pointer": f"research/MATH_STATE.json#/claims/{position}",
            "formal_statement_present": bool(claim.get("formal_statement")),
            "assumptions": [
                {"id": a["assumption_id"], "content_hash": a["content_hash"]}
                for a in claim["external_assumptions"]
            ],
            "retired_assumptions": claim["retired_assumptions"],
            "evidence_ids": [
                e["evidence_id"]
                for e in ledger["evidence"]
                if e["subject"]["kind"] == "claim"
                and e["subject"]["subject_id"] == claim["claim_id"]
                and e["subject"]["content_hash"] == claim["content_hash"]
            ],
        }
        index["claim_versions"].append(record)
        for assumption in claim["external_assumptions"]:
            key = assumption["content_hash"]
            if key not in assumptions:
                assumptions[key] = {**assumption, "claim_versions": []}
            assumptions[key]["claim_versions"].append(
                f'{claim["claim_id"]}@{claim["version"]}'
            )
    index["assumptions"] = list(assumptions.values())
    index["evidence"] = []
    for evidence in ledger["evidence"]:
        subject = evidence["subject"]
        record = {**evidence}
        record["unit"] = (
            owners[subject["subject_id"]]
            if subject["kind"] == "claim"
            else "contact_value_descent"
        )
        record["matching_claim_versions"] = [
            f'{c["claim_id"]}@{c["version"]}'
            for c in ledger["claims"]
            if subject["kind"] == "claim"
            and c["claim_id"] == subject["subject_id"]
            and c["content_hash"] == subject["content_hash"]
        ]
        record["matching_assumption_hash"] = (
            subject["content_hash"]
            if subject["kind"] == "assumption"
            and subject["content_hash"] in assumptions
            else None
        )
        record["artifact_binding_limit"] = (
            "Compiler certificate contains source/fidelity hashes; inspected separately."
            if evidence["tier"] == "mechanical"
            else "Ledger binds subject hash and artifact path, not an artifact digest. "
            "The report's preserved-manifest byte identity is separately established; "
            "reviewer_source_excerpts.txt is supplementary, not snapshot-bound."
        )
        index["evidence"].append(record)
    index["routes"] = [
        {
            **route,
            "unit": owners[route["goal"]["subject_id"]],
            "obligation_units": [
                owners[obligation["subject_id"]]
                for obligation in route["obligations"]
            ],
        }
        for route in ledger["routes"]
    ]
    index["graph_nodes"] = [
        {"claim_id": claim, "unit": owners[claim], **node}
        for claim, node in graph["nodes"].items()
    ]
    index["graph_routes"] = graph["routes"]
    index["counts"] = {
        "manifest_artifacts": len(index["artifacts"]),
        "reference_manifest_entries": len(manifest["reference_inputs_and_tooling"]),
        "reference_files": len(index["reference_tooling"]["files"]),
        "units": len(index["units"]),
        "claim_versions": len(index["claim_versions"]),
        "distinct_claims": len(owners),
        "contexts": len(index["contexts"]),
        "distinct_assumptions": len(index["assumptions"]),
        "evidence_records": len(index["evidence"]),
        "ledger_routes": len(index["routes"]),
        "graph_nodes": len(index["graph_nodes"]),
    }
    INDEX.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    print(json.dumps({"index": str(INDEX), "counts": index["counts"]}))


def check():
    index = load(INDEX)
    manifest = load(ROOT / "PRIOR_DRAFTS.json")
    old = Path(manifest["old_workspace"])
    ledger = load(old / "research/MATH_STATE.json")
    graph = load(old / "research/PROOF_GRAPH.json")
    errors = []
    expected_artifacts = {a["path"] for a in manifest["artifacts"]}
    if (
        expected_artifacts != {a["path"] for a in index["artifacts"]}
        or len(index["artifacts"]) != len(manifest["artifacts"])
    ):
        errors.append("Manifest coverage mismatch")
    expected_versions = {
        (c["claim_id"], c["version"], c["content_hash"])
        for c in ledger["claims"]
    }
    indexed_versions = {
        (c["claim_id"], c["version"], c["content_hash"])
        for c in index["claim_versions"]
    }
    if (
        expected_versions != indexed_versions
        or len(index["claim_versions"]) != len(ledger["claims"])
    ):
        errors.append("Old ledger version inventory mismatch")
    for collection, key in (("evidence", "evidence_id"), ("routes", "route_id")):
        original = {entry[key]: entry for entry in ledger[collection]}
        indexed = {entry[key]: entry for entry in index[collection]}
        if set(original) != set(indexed) or len(index[collection]) != len(original):
            errors.append(f"Old {collection} inventory mismatch")
        for identifier in set(original) & set(indexed):
            if any(indexed[identifier].get(k) != v
                   for k, v in original[identifier].items()):
                errors.append(f"Changed old binding: {identifier}")
    if set(graph["nodes"]) != {n["claim_id"] for n in index["graph_nodes"]}:
        errors.append("Old graph node inventory mismatch")
    evidence_by_id = {e["evidence_id"]: e for e in ledger["evidence"]}
    assignments = [
        claim for unit in index["units"] for claim in unit["claims"]
    ]
    if len(assignments) != len(set(assignments)):
        errors.append("Duplicate claim ownership")
    expected_claims = {c["claim_id"] for c in index["claim_versions"]}
    if set(assignments) != expected_claims:
        errors.append("Claim-version coverage mismatch")
    if expected_claims != {n["claim_id"] for n in index["graph_nodes"]}:
        errors.append("Graph coverage mismatch")
    covered = []
    for unit in index["units"]:
        report = ROOT / unit["assessment"]
        verdict_path = ROOT / unit["verdict"]
        if not report.is_file() or not verdict_path.is_file():
            errors.append(f'Missing assessment: {unit["id"]}')
            continue
        verdict = load(verdict_path)
        if verdict.get("unit_id") != unit["id"]:
            errors.append(f'Wrong verdict unit: {unit["id"]}')
        versions = {
            (c["claim_id"], c["version"])
            for c in index["claim_versions"]
            if c["unit"] == unit["id"]
        }
        actual = {
            (c["claim_id"], version)
            for c in verdict.get("old_claims", [])
            for version in c["versions"]
        }
        if versions != actual:
            errors.append(f'Verdict claim-version mismatch: {unit["id"]}')
        for claim in verdict.get("old_claims", []):
            for field in ("hypotheses", "attribution", "open_status",
                          "remaining_obligations"):
                if field not in claim:
                    errors.append(f'Missing {field}: {claim["claim_id"]}')
            if not claim.get("novelty_status") and not claim.get("old_novelty"):
                errors.append(f'Missing old novelty: {claim["claim_id"]}')
            judgment_id = claim.get("old_independent_judgment")
            if judgment_id:
                evidence = evidence_by_id.get(judgment_id)
                if (
                    not evidence
                    or evidence["subject"]["subject_id"] != claim["claim_id"]
                    or evidence["subject"]["content_hash"] != claim["content_hash"]
                    or not evidence["produced_by"].startswith("reviewer:")
                    or evidence["verdict"] != "supports"
                ):
                    errors.append(f'Incorrect old judgment: {claim["claim_id"]}')
            if claim.get("content_hash") and not any(
                c["claim_id"] == claim["claim_id"]
                and c["content_hash"] == claim["content_hash"]
                and c["version"] in claim["versions"]
                for c in index["claim_versions"]
            ):
                errors.append(f'Incorrect old claim hash: {claim["claim_id"]}')
        if not verdict.get("assessment") or "remaining_obligations" not in verdict:
            errors.append(f'Incomplete verdict: {unit["id"]}')
        if verdict.get("final_acceptance") != "native_independent_reviewer_pending":
            errors.append(f'Unexpected acceptance ownership: {unit["id"]}')
        covered.append(unit["id"])
    if not (ROOT / "research/OLD_ROUND_REVIEW.md").is_file():
        errors.append("Missing family summary")
    print(json.dumps({"ok": not errors, "counts": index["counts"],
                      "assessed_units": covered, "errors": errors}, indent=2))
    return 1 if errors else 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("operation", choices=("build", "check"))
    args = parser.parse_args()
    if args.operation == "build":
        build()
    else:
        raise SystemExit(check())
