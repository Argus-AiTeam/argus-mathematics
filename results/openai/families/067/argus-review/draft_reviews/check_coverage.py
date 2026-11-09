#!/usr/bin/env python3
"""Check the requested artifact, historical-claim and assessment coverage."""

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
INDEX = json.loads((ROOT / "research/DRAFT_REVIEW_INDEX.json").read_text())
INVENTORY = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
OLD = Path(INVENTORY["old_workspace"])
STATE = json.loads((OLD / "research/MATH_STATE.json").read_text())
GRAPH = json.loads((OLD / "research/PROOF_GRAPH.json").read_text())
issues = []


def require(condition, message):
    if not condition:
        issues.append(message)


units = {unit["id"]: unit for unit in INDEX["units"]}
require(len(units) == len(INDEX["units"]), "duplicate mathematical unit")
require(INDEX["novelty_status"] == "not_applicable", "review novelty is not applicable")
listed = {item["path"] for item in INVENTORY["artifacts"]}
indexed = {item["path"] for item in INDEX["artifacts"]}
require(indexed == listed, f"artifact mismatch: {sorted(indexed ^ listed)}")
require(len(indexed) == len(INDEX["artifacts"]), "duplicate artifact disposition")
for item in INVENTORY["artifacts"]:
    path = OLD / item["path"]
    require(path.is_file(), f"missing listed input: {item['path']}")
    if path.is_file():
        require(path.stat().st_size == item["bytes"], f"inventory size changed: {item['path']}")
for item in INDEX["artifacts"]:
    require(bool(item.get("disposition")), f"no artifact disposition: {item['path']}")
    require(set(item["units"]) <= units.keys(), f"unknown artifact unit: {item['path']}")
    require(bool(item["units"]) or item["disposition"] == "exclude_nonmathematical",
            f"unassigned substantive artifact: {item['path']}")
require(
    {item["path"] for item in INDEX["reference_inputs_and_tooling"]}
    == {item["path"] for item in INVENTORY["reference_inputs_and_tooling"]},
    "reference/tooling input mismatch",
)
for item in INDEX["reference_inputs_and_tooling"]:
    require(bool(item["disposition"]) and bool(item["reason"]), "unexplained reference input")
    require((OLD / item["path"]).is_dir(), f"missing reference directory: {item['path']}")

expected_versions = {(c["claim_id"], c["version"]) for c in STATE["claims"]}
mapped_versions = {(c["id"], c["version"]) for c in INDEX["claim_versions"]}
require(expected_versions == mapped_versions,
        f"claim-version mismatch: {sorted(expected_versions ^ mapped_versions)}")
require(len(mapped_versions) == len(INDEX["claim_versions"]), "duplicate claim version")
require(
    {(c["context_id"], c["version"]) for c in STATE["contexts"]}
    == {(c["id"], c["version"]) for c in INDEX["historical_contexts"]},
    "historical context mismatch",
)
require(
    {r["route_id"] for r in STATE["routes"]} == {r["id"] for r in INDEX["routes"]},
    "ledger route mismatch",
)
require(
    {r["name"] for r in GRAPH["routes"]}
    == {r["name"] for r in INDEX["historical_graph_routes"]},
    "historical graph route mismatch",
)
require(
    {a["assumption_id"] for c in STATE["claims"] for a in c["external_assumptions"]}
    == {a["id"] for a in INDEX["ledger_assumptions"]},
    "historical assumption mismatch",
)
require(
    {e["evidence_id"] for e in STATE["evidence"]}
    == {e["id"] for e in INDEX["historical_evidence"]},
    "historical evidence mismatch",
)
for entry in INDEX["historical_evidence"]:
    require(entry["unit"] in units and bool(entry["disposition"]),
            f"unassigned evidence record: {entry['id']}")
for evidence in STATE["evidence"]:
    require(evidence["artifact"] in listed, f"unmapped evidence artifact: {evidence['artifact']}")
known_assertions = {c["id"] for c in INDEX["claim_versions"]} | {
    a["id"] for a in INDEX["nonledger_assertions"]
}
require(set(GRAPH["nodes"]) <= known_assertions, "unmapped historical graph assertion")
for unit in units.values():
    require(set(unit["dependencies"]) <= units.keys(), f"unknown dependency: {unit['id']}")
    require(unit["id"] not in unit["dependencies"], f"self-dependency: {unit['id']}")

verdicts = {}
for unit_id, unit in units.items():
    report_path = ROOT / unit["report"]
    verdict_path = ROOT / unit["verdict"]
    require(report_path.is_file(), f"missing report: {unit_id}")
    require(verdict_path.is_file(), f"missing verdict: {unit_id}")
    if not verdict_path.is_file():
        continue
    verdict = json.loads(verdict_path.read_text())
    verdicts[unit_id] = verdict
    require(verdict["unit"] == unit_id, f"wrong verdict unit: {unit_id}")
    require(verdict["assessment_complete"] is True, f"incomplete assessment: {unit_id}")
    require(verdict["novelty_status"] == "not_applicable", f"wrong review novelty: {unit_id}")
    require(verdict["independent_review"] == "required_pending_native_reviewer",
            f"unauthorized acceptance: {unit_id}")
    for claim in verdict["claims"] + verdict["nonledger_assertions"]:
        require(all(claim.get(k) for k in ("assessment", "novelty_status", "attribution", "open_status")),
                f"incomplete substantive disposition: {unit_id}/{claim['id']}")
    for evidence in verdict["decisive_evidence"]:
        if not evidence.startswith(("http://", "https://")):
            require((verdict_path.parent / evidence).is_file(),
                    f"missing decisive evidence: {unit_id}/{evidence}")

for claim in INDEX["claim_versions"]:
    require(bool(claim["disposition"]), f"no claim disposition: {claim['id']}")
    require(bool(claim["units"]) or claim["disposition"] == "objective_not_mathematical_result",
            f"unassigned claim: {claim['id']}@{claim['version']}")
    for unit_id in claim["units"]:
        require(unit_id in verdicts, f"missing assessment unit: {unit_id}")
        if unit_id in verdicts:
            assessed = {(c["id"], v) for c in verdicts[unit_id]["claims"] for v in c["versions"]}
            require((claim["id"], claim["version"]) in assessed,
                    f"unassessed claim version: {unit_id}/{claim['id']}@{claim['version']}")
for assertion in INDEX["nonledger_assertions"]:
    for unit_id in assertion["units"]:
        require(unit_id in verdicts and assertion["id"] in {
            a["id"] for a in verdicts[unit_id]["nonledger_assertions"]
        }, f"unassessed nonledger assertion: {assertion['id']}")

lean_text = (OLD / "research/pseudoindex-five-audit/Main.lean").read_text()
declared = set(re.findall(r"^theorem\s+([A-Za-z0-9_]+)", lean_text, re.MULTILINE))
assessed_declarations = {
    a["declaration"].split(".")[-1]
    for a in verdicts.get("lean-auxiliary-lemmas", {}).get("nonledger_assertions", [])
}
require(declared == assessed_declarations, "Lean declaration coverage mismatch")
summary_path = ROOT / "research/OLD_ROUND_REVIEW.md"
require(summary_path.is_file(), "missing all-unit summary")
if summary_path.is_file():
    summary = summary_path.read_text()
    for unit_id in units:
        require(unit_id in summary, f"unit absent from summary: {unit_id}")
    require("novelty_status=not_applicable" in summary, "wrong final review novelty")

result = {
    "project_root": str(ROOT),
    "status": "pass" if not issues else "fail",
    "inventory_artifacts": len(listed),
    "reference_inputs_and_tooling": len(INDEX["reference_inputs_and_tooling"]),
    "historical_context_versions": len(STATE["contexts"]),
    "historical_claims": len({c["claim_id"] for c in STATE["claims"]}),
    "historical_claim_versions": len(expected_versions),
    "historical_evidence_records": len(STATE["evidence"]),
    "historical_assumptions": len(INDEX["ledger_assumptions"]),
    "ledger_routes": len(STATE["routes"]),
    "historical_graph_routes": len(GRAPH["routes"]),
    "historical_graph_nodes": len(GRAPH["nodes"]),
    "nonledger_assertions": len(INDEX["nonledger_assertions"]),
    "units": len(units),
    "required_assessment_files": 2 * len(units),
    "lean_declarations": len(declared),
    "issues": issues,
    "scope": "Structural coverage only; does not decide mathematical validity or native Reviewer acceptance.",
}
(ROOT / INDEX["coverage_output"]).write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps(result, sort_keys=True))
raise SystemExit(1 if issues else 0)
