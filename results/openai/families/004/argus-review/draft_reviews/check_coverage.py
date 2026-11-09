"""Check old-draft coverage and replay bindings, not mathematical acceptance."""

import argparse
import hashlib
import json
import re
from collections import defaultdict
from pathlib import Path

from argus_skill.verticals.math.proof_graph import load_graph


def read_json(path):
    return json.loads(path.read_text())


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def declarations(text):
    found = re.findall(
        r"^\s*(?:noncomputable\s+)?(theorem|def)\s+([A-Za-z_][A-Za-z_0-9]*)",
        text,
        re.MULTILINE,
    )
    return {
        kind: {name for declaration_kind, name in found if declaration_kind == kind}
        for kind in ("theorem", "def")
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=Path(__file__).resolve().parents[2])
    root = parser.parse_args().project_root.resolve()
    inventory = read_json(root / "PRIOR_DRAFTS.json")
    index = read_json(root / "research/DRAFT_REVIEW_INDEX.json")
    old = Path(inventory["old_workspace"])
    expected = {item["path"]: item for item in inventory["artifacts"]}
    indexed = {item["path"]: item for item in index["artifacts"]}
    require(len(expected) == len(inventory["artifacts"]) == 34, "inventory duplicates/count")
    require(len(indexed) == len(index["artifacts"]) == 34, "index duplicates/count")
    require(expected.keys() == indexed.keys(), "index must cover exactly the listed paths")
    for path, item in expected.items():
        require((old / path).is_file(), f"missing historical input: {path}")
        require((old / path).stat().st_size == item["bytes"], f"historical size differs: {path}")
        require(indexed[path]["bytes"] == item["bytes"], f"index byte count differs: {path}")
        require(bool(indexed[path]["disposition"]), f"missing disposition: {path}")

    manifest = read_json(Path(inventory["preserved_snapshot_manifest"]))
    prefix = old.name + "/"
    preserved = {
        item["path"][len(prefix):]: item
        for item in manifest["files"]
        if item["path"].startswith(prefix) and item["path"][len(prefix):] in expected
    }
    require(len(preserved) == 13, "existing manifest coverage is not the recorded 13")
    for path, item in indexed.items():
        require(item["snapshot_manifest_entry"] == (path in preserved), f"provenance flag: {path}")
        if path in preserved:
            digest = hashlib.sha256((old / path).read_bytes()).hexdigest()
            require(digest == preserved[path]["sha256"], f"preserved input differs: {path}")
    require(index["provenance"]["listed_paths_not_in_manifest"] == 21, "unpreserved coverage")

    unit_ids = {unit["id"] for unit in index["units"]}
    require(len(unit_ids) == len(index["units"]) == 8, "unit count/duplicates")
    summary = (root / "research/OLD_ROUND_REVIEW.md").read_text()
    required_fields = {
        "exact_claim", "hypotheses", "source_version", "attribution",
        "decisive_reasoning", "supported_scope", "invalid_inferences",
        "unresolved_obligations", "formal_statement_fidelity",
        "replay_evidence", "recommendation",
    }
    for unit in index["units"]:
        unit_id = unit["id"]
        report = root / unit["report"]
        require(report.is_file() and bool(report.read_text().strip()), f"report: {unit_id}")
        verdict = read_json(root / unit["verdict"])
        require(verdict["unit_id"] == unit_id, f"verdict binding: {unit_id}")
        require(required_fields <= verdict.keys(), f"assessment fields: {unit_id}")
        require(all(bool(verdict[key]) for key in required_fields), f"empty assessment: {unit_id}")
        require(verdict["independent_review"] == "pending_host_reviewer", f"self-acceptance: {unit_id}")
        require(unit_id in summary, f"unit absent from synthesis: {unit_id}")
        for evidence in verdict["replay_evidence"]:
            require((root / evidence).is_file(), f"missing replay evidence: {evidence}")
    for item in index["artifacts"]:
        require(set(item["units"]) <= unit_ids, f"unknown artifact unit: {item['path']}")
        require(bool(item["units"]) or item["bytes"] == 0, f"unassigned substantive artifact: {item['path']}")

    coverage = {item["id"]: item for item in index["claim_coverage"]}
    require(len(coverage) == len(index["claim_coverage"]), "duplicate claim dispositions")
    ledger = read_json(old / "research/MATH_STATE.json")
    versions = defaultdict(set)
    for claim in ledger["claims"]:
        versions[claim["claim_id"]].add(claim["version"])
    require(len(versions) == 9, "historical distinct ledger ID count")
    require(sum(map(len, versions.values())) == 17, "historical version count")
    for claim_id, recorded_versions in versions.items():
        require(claim_id in coverage, f"uncovered ledger claim: {claim_id}")
        require(set(coverage[claim_id]["versions"]) == recorded_versions, f"claim versions: {claim_id}")
    graph = load_graph(old)
    require(graph is not None, "historical graph inaccessible")
    for node in graph.nodes:
        require(node in coverage, f"uncovered historical graph node: {node}")
    for item in coverage.values():
        assigned = item.get("units", [item["unit"]] if "unit" in item else [])
        require(set(assigned) <= unit_ids, f"claim unit: {item['id']}")
        if item["classification"] == "dependency-only":
            require(bool(item["why_not_new_audit_unit"]), f"unjustified dependency: {item['id']}")
            require(item["unit_for_boundary_assessment"] in unit_ids, f"dependency boundary: {item['id']}")

    old_package = old / "research/integral-two-switch"
    embedded = index["embedded_statement_coverage"]
    named = declarations((old_package / "lean/Main.lean").read_text())
    require(named["theorem"] == embedded["lean_theorems"].keys(), "Lean theorem coverage")
    require(named["def"] == embedded["lean_definitions"].keys(), "Lean definition coverage")
    for mapping in (embedded["lean_theorems"], embedded["lean_definitions"]):
        require(set(mapping.values()) <= unit_ids, "unknown Lean declaration unit")
    algebra_versions = index["historical_version_reconciliation"]["algebra_versions"]
    for version in algebra_versions:
        certificate = read_json(old_package / "lean/certificates" / version["certificate"])
        require(certificate["subject"]["content_hash"] == version["claim_hash"], "certificate claim binding")
        historical = next(
            item for item in ledger["claims"]
            if item["claim_id"] == "CITS-ALG" and item["version"] == version["version"]
        )
        require(historical["content_hash"] == version["claim_hash"], "ledger/certificate version binding")
        certificate_names = declarations(certificate["lean_source"]["text"])
        require(certificate_names["theorem"] <= named["theorem"], "uncovered archived theorem")
        require(certificate_names["def"] <= named["def"], "uncovered archived definition")
        if version["version"] == 1:
            require(
                named["theorem"] - certificate_names["theorem"]
                == {"optimal_natural_clearing", "coherent_diamond"},
                "reduced version coverage",
            )
        else:
            require(certificate_names == named, "full archived declaration coverage")
        require(
            (certificate["lean_check"]["status"] == "success") == (version["version"] in (1, 5)),
            "historical compiler outcome reconciliation",
        )

    replay = root / "research/draft_reviews/07-coherent-family/replay"
    for filename in ("verify.py", "exact_certificate.json", "jacobian_payload.json", "jacobian_result.json"):
        require((replay / filename).read_bytes() == (old_package / filename).read_bytes(), f"copied input changed: {filename}")
    algebra = read_json(replay / "algebra_replay.json")
    require(algebra["status"] == "PASS" and algebra["negative_controls_rejected"] == 4, "algebra replay")
    lean = read_json(replay / "lean/lean_check.json")
    require(lean["status"] == "success" and lean["exit_code"] == lean["audit_exit_code"] == 0, "fresh Lean replay")
    require(lean["proof_holes"] == [], "Lean proof holes")
    for filename, key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        active = replay / "lean" / filename
        require(active.read_bytes() == (old_package / "lean" / filename).read_bytes(), f"formal copy changed: {filename}")
        require(hashlib.sha256(active.read_bytes()).hexdigest() == lean[key], f"stale compiler record: {filename}")
    submission = read_json(replay / "lean_submission.json")
    status = read_json(replay / "lean_status.json")
    require(submission["state"] == "submitted", "durable submission receipt")
    require(submission["run_id"] == status["run_id"] and status["state"] == "done", "durable completion binding")
    require(status["exit_code"] == 0 and not status["live"], "durable runner outcome")
    print(json.dumps({
        "status": "PASS",
        "scope": "coverage, file dispositions, versions and replay bindings; not mathematical acceptance",
        "project_root": str(root),
        "inventory_paths": 34,
        "units_with_reports_and_verdicts": 8,
        "historical_ledger_claim_ids": len(versions),
        "historical_claim_versions": sum(map(len, versions.values())),
        "historical_graph_nodes_covered": len(graph.nodes),
        "lean_theorems_covered": len(named["theorem"]),
        "lean_definitions_covered": len(named["def"]),
        "preserved_manifest_files_matching": len(preserved),
        "other_inventory_files_size_matching_only": 21,
        "arithmetic_applicability": "not certified",
        "independent_review": "pending_host_reviewer",
        "official_proof_graph_gate": "not applicable to exploratory old-draft review; diagnostic exit 2, no active owned graph"
    }, indent=2))


if __name__ == "__main__":
    main()
