import hashlib
import json
from pathlib import Path


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    root = Path(__file__).resolve().parents[2]
    inventory = json.loads((root / "PRIOR_DRAFTS.json").read_text())
    index = json.loads((root / "research/DRAFT_REVIEW_INDEX.json").read_text())
    old = Path(inventory["old_workspace"])
    state = json.loads((old / "research/MATH_STATE.json").read_text())
    graph = json.loads((old / "research/PROOF_GRAPH.json").read_text())
    manifest = json.loads(Path(inventory["preserved_snapshot_manifest"]).read_text())
    snapshot = {entry["path"]: entry for entry in manifest["files"]}

    artifacts = {entry["path"]: entry for entry in index["artifacts"]}
    require(len(artifacts) == len(index["artifacts"]), "Duplicate artifact mapping")
    require(
        set(artifacts) == {entry["path"] for entry in inventory["artifacts"]},
        "Artifact inventory and index differ",
    )
    archived = 0
    unarchived = []
    for entry in inventory["artifacts"]:
        path = entry["path"]
        data = (old / path).read_bytes()
        mapped = artifacts[path]
        require(len(data) == entry["bytes"] == mapped["bytes"], f"Size drift: {path}")
        digest = hashlib.sha256(data).hexdigest()
        if data:
            require(mapped["sha256"] == digest, f"Source hash drift: {path}")
        else:
            require("excluded" in mapped["role"], f"Unexplained empty artifact: {path}")
        saved = snapshot.get("9000066/" + path)
        if saved is not None:
            archived += 1
            require(
                saved["bytes"] == len(data) and saved["sha256"] == digest,
                f"Snapshot mismatch: {path}",
            )
        else:
            unarchived.append(path)
    require(
        set(unarchived) == set(index["source_alignment"]["not_in_snapshot_manifest"]),
        "Snapshot absence list differs",
    )

    claims = {(c["claim_id"], c["version"]): c for c in state["claims"]}
    require(len(claims) == len(state["claims"]), "Duplicate old claim version")
    mappings = {c["claim_id"]: c for c in index["claim_version_mapping"]}
    require(len(mappings) == len(index["claim_version_mapping"]), "Duplicate claim mapping")
    mapped_versions = set()
    for cid, mapping in mappings.items():
        require(len(mapping["versions"]) == len(set(mapping["versions"])), f"Repeated version: {cid}")
        for version in mapping["versions"]:
            key = (cid, version)
            require(key in claims, f"Nonexistent claim version: {key}")
            expected = (
                mapping["statement_hash_by_version"][str(version)]
                if "statement_hash_by_version" in mapping
                else mapping["statement_hash"]
            )
            require(claims[key]["content_hash"] == expected, f"Wrong claim hash: {key}")
            mapped_versions.add(key)
    require(mapped_versions == set(claims), "Historical claim versions omitted")
    require(
        set(mappings) == {cid for cid, _ in claims} | set(graph["nodes"]),
        "Ledger/graph claim union differs from index",
    )
    require(
        set(graph["nodes"]) == {cid for cid, _ in claims},
        "Claimed ledger/graph ID equality no longer holds",
    )
    old_contexts = {
        (c["context_id"], c["version"], c["content_hash"]) for c in state["contexts"]
    }
    indexed_contexts = {
        (c["id"], c["version"], c["content_hash"]) for c in index["source_contexts"]
    }
    require(old_contexts == indexed_contexts, "Context/version/hash mapping differs")

    actual_assumptions = set()
    for (cid, version), claim in claims.items():
        for assumption in claim["external_assumptions"]:
            actual_assumptions.add(
                (cid, version, assumption["assumption_id"], assumption["content_hash"])
            )
    indexed_assumptions = set()
    for entry in index["historical_assumption_mapping"]:
        for version in entry["versions"]:
            indexed_assumptions.add(
                (entry["claim"], version, entry["id"], entry["content_hash"])
            )
            matches = [
                a for a in claims[(entry["claim"], version)]["external_assumptions"]
                if a["assumption_id"] == entry["id"]
            ]
            require(len(matches) == 1, f"Ambiguous assumption mapping: {entry['id']}")
            require(
                matches[0]["source_id"] == entry["source_id"]
                and matches[0]["locator"] == entry["locator"],
                f"Assumption citation differs: {entry['id']} v{version}",
            )
    require(actual_assumptions == indexed_assumptions, "Historical assumptions omitted")

    evidence = {e["evidence_id"]: e for e in state["evidence"]}
    mapped_evidence = set()
    for entry in index["claim_evidence_mapping"]:
        for field in ("mechanical_evidence", "engineer_judgment", "reviewer_judgment"):
            if field not in entry:
                continue
            eid = entry[field]
            record = evidence[eid]
            require(
                record["subject"]["kind"] == "claim"
                and record["subject"]["subject_id"] == entry["claim_id"],
                f"Wrong evidence subject: {eid}",
            )
            versions = entry["versions"] if "versions" in entry else mappings[entry["claim_id"]]["versions"]
            require(
                record["subject"]["content_hash"]
                in {claims[(entry["claim_id"], v)]["content_hash"] for v in versions},
                f"Wrong evidence version binding: {eid}",
            )
            require(eid not in mapped_evidence, f"Evidence counted twice: {eid}")
            mapped_evidence.add(eid)
    for entry in index["assumption_evidence_mapping"]:
        eid = entry["reviewer_judgment"]
        record = evidence[eid]
        versions = entry["versions"] if "versions" in entry else mappings["L_LC_ORDINARY"]["versions"]
        allowed = {
            digest for cid, v, aid, digest in actual_assumptions
            if cid == "L_LC_ORDINARY" and aid == entry["id"] and v in versions
        }
        require(
            record["subject"]["kind"] == "assumption"
            and record["subject"]["subject_id"] == entry["id"]
            and record["subject"]["content_hash"] in allowed,
            f"Wrong assumption evidence binding: {eid}",
        )
        require(eid not in mapped_evidence, f"Evidence counted twice: {eid}")
        mapped_evidence.add(eid)
    require(mapped_evidence == set(evidence), "Old evidence records omitted")

    units = {unit["id"]: unit for unit in index["units"]}
    require(len(units) == len(index["units"]), "Duplicate unit ID")
    summary = (root / "research/OLD_ROUND_REVIEW.md").read_text()
    for uid, unit in units.items():
        require(set(unit["dependencies"]) <= set(units), f"Unknown unit dependency: {uid}")
        report = root / unit["report"]
        verdict_path = root / unit["verdict"]
        require(report.is_file() and verdict_path.is_file(), f"Missing pair: {uid}")
        verdict = json.loads(verdict_path.read_text())
        require(verdict["unit"] == uid, f"Verdict unit mismatch: {uid}")
        require(verdict["novelty_status"] == "not_applicable", f"Review novelty mislabel: {uid}")
        require(
            verdict["independent_review_required"] is True
            and verdict["independent_acceptance"] == "pending",
            f"Self-acceptance or missing review requirement: {uid}",
        )
        assessments = {c["claim_id"]: c for c in verdict["claim_assessments"]}
        require(set(assessments) == set(unit["claims"]), f"Unit claim coverage differs: {uid}")
        for cid, assessment in assessments.items():
            require(
                set(assessment["versions"]) == set(mappings[cid]["versions"]),
                f"Verdict version coverage differs: {cid}",
            )
            for field in ("mathematical_assessment", "open_status", "old_claim_novelty_status", "attribution"):
                require(bool(assessment[field]), f"Missing {field}: {cid}")
            require(cid in report.read_text(), f"Claim absent from report: {cid}")
        require(
            f"draft_reviews/{uid}/report.md" in summary
            and f"draft_reviews/{uid}/verdict.json" in summary,
            f"Unit omitted from summary: {uid}",
        )
    exclusions = [
        item for unit in units.values()
        for item in json.loads((root / unit["verdict"]).read_text()).get("administrative_exclusions", [])
    ]
    require(
        {(item["claim_id"], v) for item in exclusions for v in item["versions"]}
        == {("C9000066", 1)},
        "Administrative exclusion missing or broadened",
    )
    for artifact in artifacts.values():
        if artifact["units"] != "all":
            require(set(artifact["units"]) <= set(units), f"Unknown artifact unit: {artifact['path']}")
    require(
        {route["id"] for route in index["route_mapping"]}
        == {route["name"] for route in graph["routes"]},
        "Graph route omitted",
    )
    require(
        claims[("C_LC_PENALTY_ALG", 3)]["formal_statement"]
        == (old / "research/lc-slice-audit/Main.lean").read_text(),
        "v3 ledger formal text differs from compiled source",
    )
    manuscript_manifest = json.loads(Path(inventory["manuscript_reference_manifest"]).read_text())
    for section in index["source_alignment"]["primary_sections"]:
        manuscripts = [
            m for m in manuscript_manifest["manuscripts"]
            if m["manuscript_id"] == section["manuscript"]
        ]
        require(len(manuscripts) == 1, "Ambiguous manuscript mapping")
        entry = next(e for e in manuscripts[0]["tex_sources"] if e["path"] == section["path"])
        data = (old / "research/openai_manuscript" / section["manuscript"] / section["path"]).read_bytes()
        require(
            hashlib.sha256(data).hexdigest() == entry["sha256"] == section["sha256"],
            f"Manuscript source alignment drift: {section['path']}",
        )

    counts = index["counting"]
    require(counts["listed_artifacts"] == len(artifacts), "Artifact count differs")
    require(counts["distinct_ledger_graph_claim_ids"] == len(mappings), "Claim count differs")
    require(counts["historical_claim_versions"] == len(claims), "Version count differs")
    require(counts["draft_units"] == len(units), "Unit count differs")
    require(not list((root / "research").rglob("*.lean")), "Unexpected new formal source")
    for path in (root / "research/draft_reviews").rglob("*.json"):
        json.loads(path.read_text())
    print(json.dumps({
        "ok": True,
        "project_root": str(root),
        "artifacts": len(artifacts),
        "snapshot_matches": archived,
        "listed_but_not_in_snapshot_manifest": len(unarchived),
        "claim_ids": len(mappings),
        "claim_versions": len(claims),
        "historical_assumption_bindings": len(actual_assumptions),
        "old_evidence_records_mapped": len(evidence),
        "units_with_reports_and_verdicts": len(units),
        "old_inputs_unchanged": True,
        "native_independent_acceptance": "pending",
        "scope": "Coverage, provenance and output consistency; not a mathematical or native acceptance gate."
    }, indent=2))


if __name__ == "__main__":
    main()
