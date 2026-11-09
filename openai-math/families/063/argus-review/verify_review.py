#!/usr/bin/env python3
"""Check old-draft coverage and evidence boundaries, not geometric correctness."""

import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def verify():
    require(Path.cwd().resolve() == ROOT, "run from the current campaign root")
    inventory = read_json(ROOT / "PRIOR_DRAFTS.json")
    index = read_json(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    old = Path(inventory["old_workspace"])
    ledger = read_json(old / "research/MATH_STATE.json")
    graph = read_json(old / "research/PROOF_GRAPH.json")
    units = {unit["unit"]: unit for unit in index["units"]}
    require(len(units) == len(index["units"]), "duplicate review unit")
    require(index["novelty_status"] == "not_applicable", "review claims novelty")

    artifacts = {row["path"]: row for row in inventory["artifacts"]}
    indexed_artifacts = {row["path"]: row for row in index["artifacts"]}
    require(len(index["artifacts"]) == len(artifacts) == 14, "artifact count mismatch")
    require(set(indexed_artifacts) == set(artifacts), "artifact omission or addition")
    for path, row in indexed_artifacts.items():
        require(row["inventory_bytes"] == artifacts[path]["bytes"], f"size mapping: {path}")
        require((old / path).is_file(), f"missing old artifact: {path}")
        require(set(row["units"]) <= set(units), f"unknown artifact unit: {path}")
        require(row["units"] or row.get("exclusion_reason"), f"unexplained artifact: {path}")

    old_claims = {(c["claim_id"], c["version"]): c for c in ledger["claims"]}
    mapped = {}
    for row in index["claim_versions"]:
        require(row["unit"] in units or row.get("exclusion_reason"), "unexplained claim")
        for version in row["versions"]:
            key = row["claim_id"], version
            require(key not in mapped, f"duplicate indexed claim version: {key}")
            mapped[key] = row
    require(set(mapped) == set(old_claims), "claim/version coverage mismatch")

    for context in index["contexts"]:
        actual = {
            c["claim_id"] for c in ledger["claims"]
            if c["context"]["subject_id"] == context["context_id"]
        }
        require(actual == set(context["claims"]), "context-to-claim mismatch")
    actual_contexts = {(c["context_id"], c["version"]) for c in ledger["contexts"]}
    mapped_contexts = {
        (c["context_id"], version)
        for c in index["contexts"] for version in c["versions"]
    }
    require(actual_contexts == mapped_contexts, "context/version coverage mismatch")

    old_assumptions = {}
    for claim in ledger["claims"]:
        for assumption in claim["external_assumptions"]:
            old_assumptions.setdefault(assumption["assumption_id"], set()).add(
                f'{claim["claim_id"]}@{claim["version"]}'
            )
    indexed_assumptions = {
        a["id"]: set(a["claim_versions"]) for a in index["foundational_assumptions"]
    }
    require(old_assumptions == indexed_assumptions, "assumption/version coverage mismatch")

    routes = {route["route_id"]: route for route in ledger["routes"]}
    require(set(routes) <= set(index["dependencies"]), "route omitted")
    expected_edges = dict(index["dependencies"]["graph_only_internal_edges"])
    for route_id, route in routes.items():
        recorded = index["dependencies"][route_id]
        goal = route["goal"]["subject_id"]
        obligations = {o["subject_id"] for o in route["obligations"]}
        require(recorded["goal"] == goal, f"route goal mismatch: {route_id}")
        require(set(recorded["obligations"]) == obligations, f"route obligations: {route_id}")
        require(recorded["retired_because"] == route["retired_because"], "route retirement changed")
        expected_edges[goal] = list(obligations)
    require(set(graph["nodes"]) == {c["claim_id"] for c in ledger["claims"]}, "old graph/claim mismatch")
    for claim_id, node in graph["nodes"].items():
        require(
            set(node["depends_on"]) == set(expected_edges.get(claim_id, [])),
            f"graph dependency omitted: {claim_id}",
        )

    evidence = {e["evidence_id"]: e for e in ledger["evidence"]}
    recorded_evidence = []
    for group in index["evidence_groups"]:
        require(group["unit"] in units, "unknown evidence unit")
        for evidence_id in group["evidence_ids"]:
            require(evidence_id in evidence, f"unknown evidence: {evidence_id}")
            require(evidence[evidence_id]["artifact"] == group["artifact"], "evidence artifact mismatch")
            require(evidence[evidence_id]["tier"] == "judgement", "evidence tier widened")
            recorded_evidence.append(evidence_id)
    require(len(recorded_evidence) == len(set(recorded_evidence)), "evidence double counted")
    require(set(recorded_evidence) == set(evidence), "evidence omitted")

    summary = (ROOT / index["coverage"]["final_summary"]).read_text()
    assessed = set()
    for unit_id, unit in units.items():
        report = ROOT / unit["report"]
        verdict_path = ROOT / unit["verdict"]
        require(report.is_file() and report.stat().st_size > 0, f"missing report: {unit_id}")
        verdict = read_json(verdict_path)
        require(verdict["unit"] == unit_id, f"verdict unit mismatch: {unit_id}")
        require(verdict["novelty_status"] == "not_applicable", "review result novelty widened")
        require(verdict["native_independent_review"] == "pending_host_reviewer", "self acceptance")
        require(unit_id in summary, f"unit not summarized: {unit_id}")
        for path in [unit["report"], unit["verdict"]]:
            require(str(Path(path).relative_to("research")) in summary, f"summary link missing: {path}")
        claims = verdict["claims"]
        require({c["claim_id"] for c in claims} == set(unit["claims"]), f"unit claim mismatch: {unit_id}")
        for claim in claims:
            require(claim["attribution"] and claim["novelty_status"] and claim["open_status"], "missing claim assessment")
            claim_id = claim["claim_id"]
            require(
                set(claim["depends_on"]) == set(graph["nodes"][claim_id]["depends_on"]),
                f"verdict dependencies: {claim_id}",
            )
            for version in claim["versions"]:
                key = claim_id, version
                require(key not in assessed, f"claim assessed twice: {key}")
                require(mapped[key]["unit"] == unit_id, f"claim assigned differently: {key}")
                old_claim = old_claims[key]
                require(claim["ledger_statement"] == old_claim["natural_statement"], f"statement mismatch: {key}")
                assumptions = {a["assumption_id"] for a in old_claim["external_assumptions"]}
                require(
                    set(claim.get("assumption_history", {}).get(str(version), [])) == assumptions,
                    f"verdict assumption history: {key}",
                )
                assessed.add(key)
    exclusions = {key for key, row in mapped.items() if row["unit"] is None}
    require(assessed | exclusions == set(old_claims), "unassessed claim version")
    require(assessed.isdisjoint(exclusions), "excluded claim also counted as assessed")

    replay_dir = ROOT / "research/draft_reviews/exact-algebra-support"
    replay = read_json(replay_dir / "verifier_replay.json")
    require(replay["exit_status"] == 0 and not replay["timed_out"], "retained replay incomplete")
    require(replay["old_artifact_metadata_unchanged"], "retained inputs changed during replay")
    require(not replay["geometric_certification"], "algebra promoted to geometry")
    require(json.loads(replay["stdout"])["exact_checks"] == 9, "check group coverage mismatch")
    adapter = read_json(replay_dir / "jacobian_replay_status.json")
    require(adapter["exit_status"] == 0 and not adapter["timed_out"], "live adapter incomplete")
    require(adapter["structured_error"] is None, "adapter error counted as support")
    output = read_json(replay_dir / "jacobian_output.json")
    payload = read_json(replay_dir / "jacobian_payload.json")
    require(output["request"]["payload"] == payload, "live exact payload not preserved")
    require(output["result"]["output"]["completeness"] == "FULL_MATRIX_TRANSFORMATIONS", "incomplete typed output")

    require(index["coverage"]["unexplained_omissions"] == [], "unexplained omission recorded")
    require(index["coverage"]["mapped_claim_versions"] == len(mapped), "reported claim count")
    require(index["coverage"]["mapped_artifacts"] == len(artifacts), "reported artifact count")
    require(index["coverage"]["substantive_units"] == len(units), "reported unit count")
    return {
        "ok": True,
        "project_root": str(ROOT),
        "inventory_artifacts": len(artifacts),
        "unique_old_claims": len({key[0] for key in old_claims}),
        "old_claim_versions": len(old_claims),
        "assessed_versions": len(assessed),
        "explicitly_excluded_versions": len(exclusions),
        "unit_reports": len(units),
        "unit_verdicts": len(units),
        "historical_evidence_records": len(recorded_evidence),
        "old_routes": len(routes),
        "retained_algebra_groups": 9,
        "native_independent_review": "still_required",
    }


if __name__ == "__main__":
    try:
        print(json.dumps(verify(), indent=2, sort_keys=True))
    except (OSError, KeyError, TypeError, ValueError) as error:
        print(f"review coverage failed: {error}", file=sys.stderr)
        sys.exit(1)
