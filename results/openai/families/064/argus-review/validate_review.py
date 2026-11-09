#!/usr/bin/env python3
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEGACY = "$WORKSPACE/argus-latest/.venv/bin/python"
CURRENT = "$WORKSPACE/argus-live-update/.venv/bin/python"


def load(path):
    return json.loads(path.read_text())


def digest(path):
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def main():
    issues = []

    def require(condition, message):
        if not condition:
            issues.append(message)

    index = load(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    inventory = load(ROOT / "PRIOR_DRAFTS.json")
    old = Path(inventory["old_workspace"])
    ledger = load(old / "research/MATH_STATE.json")
    graph = load(old / "research/PROOF_GRAPH.json")
    units = {unit["id"]: unit for unit in index["units"]}
    artifacts = {row["path"]: row for row in index["artifacts"]}
    claims = {(row["id"], row["version"]): row for row in index["claim_versions"]}
    old_claims = {(row["claim_id"], row["version"]): row for row in ledger["claims"]}
    require(index["project_root"] == str(ROOT), "wrong authoritative project root")
    require(index["review_status"] == "review_ready", "index is not review-ready")
    require(index["research_target_level"] == "exploratory", "target level changed")
    require(index["novelty_status"] == "not_applicable", "review claims novelty")
    require(index["independent_acceptance"] == "reserved_for_native_reviewer", "acceptance boundary changed")
    require(len(artifacts) == len(index["artifacts"]) == 11, "duplicate or missing artifact index entry")
    require(set(artifacts) == {row["path"] for row in inventory["artifacts"]}, "artifact inventory mismatch")
    require(len(claims) == len(index["claim_versions"]) == 15, "duplicate or missing claim/version")
    require(set(claims) == set(old_claims), "claim/version coverage mismatch")

    for key, row in claims.items():
        require(row["hash"] == old_claims[key]["content_hash"], f"claim hash mismatch: {key}")
        require(bool(row["disposition"]), f"missing claim disposition: {key}")
        require(row["unit"] is None or row["unit"] in units, f"unknown claim unit: {key}")
        require(not old_claims[key]["formal_statement"], f"unexpected old formalization: {key}")

    covered = set()
    for unit_id, unit in units.items():
        report = ROOT / unit["report"]
        require(report.is_file() and report.stat().st_size > 0, f"missing report: {unit_id}")
        verdict = load(ROOT / unit["verdict"])
        require(verdict["unit_id"] == unit_id, f"unit verdict mismatch: {unit_id}")
        require(verdict["review_status"] == "review_ready", f"unfinished unit: {unit_id}")
        require(verdict["source_workspace"] == str(old), f"wrong source workspace: {unit_id}")
        require(verdict["manuscript_revision"] == index["manuscript_revision"], f"wrong revision: {unit_id}")
        require(verdict["research_target_level"] == "exploratory", f"wrong target: {unit_id}")
        require(verdict["independent_acceptance"] == "pending_native_reviewer", f"self-acceptance: {unit_id}")
        require(verdict["formalization"]["lean_present"] is False, f"invented Lean evidence: {unit_id}")
        unit_claims = set()
        for claim in verdict["claims"]:
            for field in ("statement", "hypotheses", "assessment", "supported_scope", "open_status", "novelty", "attribution", "evidence"):
                require(bool(claim[field]), f"empty {field}: {unit_id}/{claim['id']}")
            require(bool(claim["novelty"]["status"]), f"missing novelty disposition: {unit_id}")
            for version in claim["versions"]:
                key = (claim["id"], version)
                require(key in claims and claims[key]["unit"] == unit_id, f"wrong unit/claim mapping: {key}")
                require(key not in covered, f"duplicate assessment: {key}")
                covered.add(key)
                unit_claims.add(f"{claim['id']}@{version}")
        require(unit_claims == set(unit["claims"]), f"unit claim list mismatch: {unit_id}")
        require(set(unit["depends_on_units"]) <= set(units), f"unknown unit dependency: {unit_id}")
    expected_covered = {key for key, row in claims.items() if row["unit"] is not None}
    require(covered == expected_covered, "substantive claim/version coverage is incomplete")
    excluded = {(row["id"], version) for row in index["excluded_claim_assessments"] for version in row["versions"]}
    require(excluded == set(claims) - covered, "excluded claim assessment mismatch")
    require({(row["id"], row["version"]) for row in index["contexts"]} == {(row["context_id"], row["version"]) for row in ledger["contexts"]}, "context coverage mismatch")
    assumptions = {row["id"]: row for row in index["external_assumptions"]}
    require(set(assumptions) == {a["assumption_id"] for c in ledger["claims"] for a in c["external_assumptions"]}, "external assumption coverage mismatch")

    evidence = {row["id"]: row for row in index["evidence_records"]}
    require(len(evidence) == len(index["evidence_records"]) == len(ledger["evidence"]) == 14, "evidence count mismatch")
    require(set(evidence) == {row["evidence_id"] for row in ledger["evidence"]}, "evidence coverage mismatch")
    for item in ledger["evidence"]:
        row = evidence[item["evidence_id"]]
        require(row["by"] == item["produced_by"] and row["verdict"] == item["verdict"], f"changed inherited judgement: {row['id']}")
        subject = item["subject"]
        if subject["kind"] == "assumption":
            expected_unit = assumptions[subject["subject_id"]]["unit"]
        else:
            matches = [c for c in claims.values() if c["id"] == subject["subject_id"] and c["hash"] == subject["content_hash"]]
            require(bool(matches), f"unmatched judgement subject: {row['id']}")
            expected_unit = matches[0]["unit"] if matches else None
        require(row["unit"] == expected_unit, f"wrong evidence unit: {row['id']}")

    nodes = {row["id"]: row for row in index["proof_graph_nodes"]}
    require(set(nodes) == set(graph["nodes"]) and len(nodes) == len(index["proof_graph_nodes"]) == 13, "proof-graph coverage mismatch")
    for node_id, node in graph["nodes"].items():
        row = nodes[node_id]
        require(row["old_status"] == node["status"] and row["depends_on"] == node["depends_on"], f"changed graph status/dependencies: {node_id}")
        expected_units = {c["unit"] for c in claims.values() if c["id"] == node_id}
        require(len(expected_units) == 1, f"ambiguous graph claim unit: {node_id}")
        expected_unit = next(iter(expected_units))
        require(row.get("unit") == expected_unit, f"wrong graph unit: {node_id}")
        require(expected_unit is not None or bool(row.get("disposition")), f"missing graph exclusion: {node_id}")
    graph_evidence = {path for node in graph["nodes"].values() for path in node["evidence"]}
    require(graph_evidence == {row["path"] for row in index["proof_graph_evidence_dispositions"]}, "unmapped graph evidence")
    routes = {row["id"]: row for row in index["routes"]}
    require(set(routes) == {row["route_id"] for row in ledger["routes"]} and len(routes) == 3, "route coverage mismatch")
    for route in ledger["routes"]:
        row = routes[route["route_id"]]
        for named, old_ref in [(row["goal"], route["goal"])] + list(zip(row["obligations"], route["obligations"])):
            claim_id, version = named.rsplit("@", 1)
            indexed_claim = claims[(claim_id, int(version))]
            require(claim_id == old_ref["subject_id"] and indexed_claim["hash"] == old_ref["content_hash"], f"route reference mismatch: {row['id']}/{named}")
        require(len(row["obligations"]) == len(route["obligations"]), f"route obligation count mismatch: {row['id']}")

    manifest_path = Path(inventory["preserved_snapshot_manifest"])
    manifest = load(manifest_path)
    baseline = index["integrity_baseline"]
    require(digest(manifest_path) == baseline["preserved_manifest_sha256"], "preserved manifest changed")
    manifested = {row["path"].split("/", 1)[1]: row for row in manifest["files"] if row["path"].startswith(old.name + "/")}
    require(len(manifested) == 5, "unexpected manifest family membership")
    measured_artifacts = []
    for row in inventory["artifacts"]:
        path = old / row["path"]
        indexed = artifacts[row["path"]]
        measured = {"path": row["path"], "bytes": path.stat().st_size, "sha256": digest(path)}
        unchanged = measured["bytes"] == indexed["bytes"] == row["bytes"] and measured["sha256"] == indexed["sha256"]
        require(unchanged, f"old artifact changed: {row['path']}")
        require(indexed["preserved_manifest_member"] == (row["path"] in manifested), f"false snapshot provenance: {row['path']}")
        if row["path"] in manifested:
            expected = manifested[row["path"]]
            require(measured["bytes"] == expected["bytes"] and measured["sha256"] == expected["sha256"], f"manifest mismatch: {row['path']}")
        measured_artifacts.append({**measured, "unchanged": unchanged})
    archive = Path(baseline["snapshot_archive"])
    archive_digest = digest(archive)
    archive_unchanged = archive.stat().st_size == baseline["snapshot_archive_bytes"] and archive_digest == baseline["snapshot_archive_sha256"]
    require(archive_unchanged, "preserved snapshot archive changed")

    reference = load(Path(inventory["manuscript_reference_manifest"]))
    require(reference["upstream_commit"] == index["manuscript_revision"], "manuscript revision changed")
    manuscript = reference["manuscripts"][0]
    require(manuscript["source_revision"] == index["manuscript_revision"], "manuscript source revision mismatch")
    require(len(manuscript["tex_sources"]) == 18, "manuscript source inventory changed")
    reference_matches = 0
    for row in manuscript["tex_sources"]:
        old_copy = old / index["manuscript_directory"] / row["path"]
        upstream_copy = Path(manuscript["source_directory"]) / row["path"]
        matches = digest(old_copy) == row["sha256"] and digest(upstream_copy) == row["sha256"]
        require(matches, f"manuscript source mismatch: {row['path']}")
        reference_matches += int(matches)

    local = load(ROOT / "research/draft_reviews/local-toric/verdict.json")
    replay = local["tools_and_replays"]
    require(replay["checker"]["exit_status"] == 0 and not replay["checker"]["timeout"], "local checker did not pass")
    require(replay["checker"]["summary_semantically_matches_preserved_certificate"], "local replay comparison failed")
    adapter = replay["jacobian"]
    require(adapter["mathematical_operation_runs"] == 1 and adapter["current_contract_inspected_before_run"], "unbounded or uninspected adapter use")
    require(adapter["adapter_exit_code"] == 0 and adapter["adapter_error"] is None and adapter["transport_error"] is None and not adapter["timeout"], "adapter result is a non-conclusion")
    require(adapter["input_and_output_validate_inspected_schemas"], "typed adapter contract mismatch")
    require(digest(ROOT / adapter["payload_file"]) == artifacts["research/log-model-audit/jacobian_payload.json"]["sha256"], "current payload differs from the original exact input")
    for field in ("discovery_file", "contract_file", "payload_file", "typed_result_file", "adapter_status_file", "verification_file"):
        require((ROOT / adapter[field]).is_file(), f"missing adapter evidence: {field}")
    active_graph = load(ROOT / "research/PROOF_GRAPH.json")
    require(all(node["status"] == "open" and node["reviewer_confirmed"] is False for node in active_graph["nodes"].values()), "Engineer crossed independent acceptance boundary")
    require(not list((ROOT / "research").rglob("*.lean")), "unexpected active Lean source")
    require((ROOT / "research/OLD_ROUND_REVIEW.md").is_file(), "missing whole-inventory summary")
    require(index["final_review_result"]["novelty_status"] == "not_applicable" and index["final_review_result"]["acceptance_status"] == "pending_native_reviewer", "wrong final review result")

    commands = {
        "math_state": [LEGACY, "-m", "argus_skill.verticals.math.math_state", "check", "--project-root", str(ROOT)],
        "proof_graph": [LEGACY, "-m", "argus_skill.verticals.math.proof_graph_check", "check", "--project-root", str(ROOT)],
        "delivery_gate": [CURRENT, "-m", "argus_skill.verticals.math.check", "--project-root", str(ROOT), "--stage", "review"],
    }
    official = {}
    for name, command in commands.items():
        result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, timeout=30, check=False)
        official[name] = {"command": command, "project_root": str(ROOT), "exit_status": result.returncode, "stdout": result.stdout, "stderr": result.stderr}
        require(result.returncode == 0, f"official {name} check failed: exit {result.returncode}")

    output = {
        "ok": not issues,
        "measured_at": datetime.now(timezone.utc).isoformat(),
        "project_root": str(ROOT),
        "command": [LEGACY, "research/validate_review.py"],
        "coverage": {"artifacts": len(artifacts), "claim_versions": len(claims), "unique_claims": len({key[0] for key in claims}), "substantive_claim_versions": len(covered), "excluded_claim_versions": len(excluded), "units": len(units), "evidence_records": len(evidence), "routes": len(routes), "graph_nodes": len(nodes), "graph_evidence_paths": len(graph_evidence)},
        "old_artifacts": measured_artifacts,
        "snapshot_archive": {"bytes": archive.stat().st_size, "sha256": archive_digest, "unchanged": archive_unchanged, "initial_streamed_manifest_matches": baseline["manifested_archive_matches"]},
        "manuscript_reference_matches_in_both_copies": reference_matches,
        "replay": {"checker_exit_status": replay["checker"]["exit_status"], "semantic_comparison": "PASS", "adapter_exit_status": adapter["adapter_exit_code"], "operation_id": adapter["operation_id"], "mathematical_operation_runs": adapter["mathematical_operation_runs"], "rerun_unchanged_computation": False},
        "official_checks": official,
        "independent_acceptance": "pending_native_reviewer",
        "issues": issues,
    }
    print(json.dumps(output, indent=2))
    return int(bool(issues))


if __name__ == "__main__":
    raise SystemExit(main())
