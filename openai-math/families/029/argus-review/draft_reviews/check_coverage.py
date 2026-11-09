#!/usr/bin/env python3
"""Check old-draft review coverage; this is not a mathematical proof checker."""

import json
import os
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(path):
    return json.loads(path.read_text())


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    inventory = read(ROOT / "PRIOR_DRAFTS.json")
    index = read(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    old = Path(inventory["old_workspace"])
    ledger = read(old / "research/MATH_STATE.json")
    graph = read(old / "research/PROOF_GRAPH.json")
    units = {unit["id"]: unit for unit in index["units"]}
    artifacts = {row["id"]: row for row in index["artifacts"]}
    claim_map = {row["id"]: row for row in index["claim_node_map"]}

    require(len(artifacts) == len(index["artifacts"]), "Duplicate artifact ID")
    require(len(units) == len(index["units"]), "Duplicate unit ID")
    require(len(claim_map) == len(index["claim_node_map"]), "Duplicate claim ID")
    require(
        sorted(row["path"] for row in index["artifacts"])
        == sorted(row["path"] for row in inventory["artifacts"]),
        "Artifact inventory is not covered exactly once",
    )
    for row in inventory["artifacts"]:
        require((old / row["path"]).is_file(), f"Missing old input: {row['path']}")
        require(
            (old / row["path"]).stat().st_size == row["bytes"],
            f"Old input size differs from inventory: {row['path']}",
        )
    require(
        sorted(row["path"] for row in index["reference_directories"])
        == sorted(row["path"] for row in inventory["reference_inputs_and_tooling"]),
        "Reference/tooling directory inventory is not covered",
    )
    for row in index["reference_directories"]:
        require((old / row["path"]).is_dir(), f"Missing reference directory: {row['path']}")
        source_manifest = read(Path(inventory["manuscript_reference_manifest"]))
        expected_files = {
            str(Path(manuscript["manuscript_id"]) / source["path"])
            for manuscript in source_manifest["manuscripts"]
            for source in manuscript["tex_sources"]
        }
        expected_files.update(
            str(Path(manuscript["manuscript_id"]) / "README.md")
            for manuscript in source_manifest["manuscripts"]
        )
        reference_root = old / row["path"]
        for manuscript in source_manifest["manuscripts"]:
            require(
                (reference_root / manuscript["manuscript_id"]).resolve()
                == Path(manuscript["source_directory"]).resolve(),
                f"Reference target differs from manifest: {manuscript['manuscript_id']}",
            )
        actual_files = set()
        for base, directories, files in os.walk(reference_root, followlinks=True):
            directories[:] = [name for name in directories if not name.startswith(".")]
            actual_files.update(str((Path(base) / name).relative_to(reference_root)) for name in files)
        require(
            actual_files == expected_files,
            f"Reference files differ: missing={sorted(expected_files - actual_files)[:5]}, "
            f"extra={sorted(actual_files - expected_files)[:5]}",
        )
        require(len(actual_files) == row["observed_file_count"], "Reference file count differs")
    for row in index["artifacts"] + index["reference_directories"]:
        require(bool(row["disposition"]), f"Missing disposition: {row['id']}")
        require(set(row["units"]) <= units.keys(), f"Unknown unit: {row['id']}")

    latest = {claim["claim_id"]: claim for claim in ledger["claims"]}
    require(set(claim_map) == set(latest), "Old ledger claim coverage differs")
    require(set(claim_map) == set(graph["nodes"]), "Old graph node coverage differs")
    for claim_id, row in claim_map.items():
        require(row["unit"] in units, f"Unknown claim unit: {claim_id}")
        require(bool(row["disposition"]), f"Missing claim disposition: {claim_id}")
        expected = index["ledger_versions"]["overrides"].get(
            claim_id, index["ledger_versions"]["default"]
        )
        actual = [c["version"] for c in ledger["claims"] if c["claim_id"] == claim_id]
        require(actual == expected, f"Unmapped historical versions: {claim_id}")

    assumptions = {
        (claim_id, assumption["assumption_id"])
        for claim_id, claim in latest.items()
        for assumption in claim["external_assumptions"]
    }
    mapped_assumptions = {(row["claim"], row["id"]) for row in index["old_assumptions"]}
    require(assumptions == mapped_assumptions, "Old assumptions not covered exactly")
    routes = {route["route_id"]: route for route in ledger["routes"]}
    require(set(routes) == {row["id"] for row in index["old_routes"]}, "Old route omitted")
    for row in index["old_routes"]:
        source = routes[row["id"]]
        require(row["goal"] == source["goal"]["subject_id"], "Route goal differs")
        require(
            row["obligations"] == [ref["subject_id"] for ref in source["obligations"]],
            f"Route obligations differ: {row['id']}",
        )
        require(
            row.get("retired_because", "") == source["retired_because"],
            f"Route retirement reason differs: {row['id']}",
        )

    evidence = index["old_evidence_map"]
    require(
        [row["ordinal"] for row in evidence] == list(range(1, len(ledger["evidence"]) + 1)),
        "Old evidence record omitted or repeated",
    )
    for row, source in zip(evidence, ledger["evidence"]):
        require(row["subject"] == source["subject"]["subject_id"], "Evidence subject differs")
        require(
            row.get("subject_kind", "claim") == source["subject"]["kind"],
            "Evidence subject kind differs",
        )
        require(
            artifacts[row["artifact"]]["path"] == source["artifact"],
            "Evidence artifact differs",
        )
        for key in ("tier", "verdict"):
            require(row[key] == source[key], f"Evidence {key} differs")
        require(row["by"] == source["produced_by"], "Evidence actor differs")
        expected_unit = (
            claim_map[row["subject"]]["unit"]
            if source["subject"]["kind"] == "claim"
            else next(a["unit"] for a in index["old_assumptions"] if a["id"] == row["subject"])
        )
        require(row["unit"] == expected_unit, "Evidence unit differs")

    manifest = read(Path(inventory["preserved_snapshot_manifest"]))
    expected_snapshot = {
        row["path"].split("/", 1)[1]
        for row in manifest["files"]
        if row["path"].startswith("9000029/")
    }
    require(
        expected_snapshot == {row["path"] for row in artifacts.values() if row["snapshot_member"]},
        "Snapshot scope was expanded or omitted",
    )
    summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
    for unit_id, unit in units.items():
        require(unit_id in summary, f"Family summary omits {unit_id}")
        require((ROOT / unit["report"]).stat().st_size > 0, f"Empty report: {unit_id}")
        verdict = read(ROOT / unit["verdict"])
        require(verdict["unit"] == unit_id, f"Wrong verdict unit: {unit_id}")
        require(
            set(verdict["old_claim_ids"])
            == {cid for cid, row in claim_map.items() if row["unit"] == unit_id},
            f"Unit claim coverage differs: {unit_id}",
        )
        require(verdict["independent_review_required"] is True, "Independent review flag absent")
        require(verdict["native_review_status"] == "pending", "Engineer claimed native acceptance")
        require(verdict["final_acceptance"] is False, "Engineer self-accepted")

    replay = read(ROOT / "research/draft_reviews/local-normalization/replay.json")
    require(replay["exit_status"] == 0 and not replay["timeout"], "Exact replay did not pass")
    require(replay["stdout"]["analytic_proof_checked_by_program"] is False, "Replay scope changed")
    jacobian = ROOT / "research/draft_reviews/local-normalization/jacobian"
    payload = read(jacobian / "principal_payload.json")
    output = read(jacobian / "principal_output.json")
    old_output = read(old / "research/reflection_audit/jacobian/principal_output.json")
    require(payload == output["request"]["payload"] == {"modulus": 13}, "Jacobian input differs")
    require(output["result"]["output"] == old_output["result"]["output"], "Jacobian result differs")
    require(read(jacobian / "principal_execution.json")["adapter_exit_status"] == 0, "Adapter failed")

    counts = {
        "listed_artifacts": len(artifacts),
        "reference_tooling_directories": len(index["reference_directories"]),
        "distinct_old_claim_ids": len(latest),
        "old_claim_version_records": len(ledger["claims"]),
        "old_graph_nodes": len(graph["nodes"]),
        "old_graph_routes": len(graph["routes"]),
        "old_ledger_route_records": len(routes),
        "old_evidence_records": len(evidence),
    }
    for key, value in counts.items():
        require(index["coverage"][key] == value, f"Incorrect coverage total: {key}")
    print(json.dumps({
        "ok": True,
        **counts,
        "unit_assessment_pairs": len(units),
        "reference_files": len(actual_files),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
