#!/usr/bin/env python3
"""Expand and check the review index against its read-only input inventories."""

import argparse
from collections import defaultdict
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / "research" / "DRAFT_REVIEW_INDEX.json"
GENERATED_KEYS = (
    "artifact_inventory", "context_inventory", "claim_inventory", "assumption_inventory",
    "route_inventory", "evidence_inventory", "graph_inventory", "coverage",
)


def load(path):
    return json.loads(path.read_text())


def disposition(value):
    if value in {"supported", "partially_supported", "invalid", "unresolved",
                 "excluded_nonmathematical"}:
        return value
    if value.startswith("supported_"):
        return "supported"
    if value == "historical_inventory_resolved_to_source_specific_inputs_not_a_theorem":
        return "partially_supported"
    raise ValueError(f"Unknown qualified verdict: {value}")


def expand(index):
    manifest = load(ROOT / index["manifest"])
    old = Path(index["old_root"])
    state = load(old / "research" / "MATH_STATE.json")
    graph = load(old / "research" / "PROOF_GRAPH.json")
    units = {unit["id"]: unit for unit in index["units"]}
    owner = {}
    verdicts = {}
    assessments = {}
    assessment_records = {}
    for unit_id, unit in units.items():
        report = ROOT / unit["report"]
        if not report.is_file() or not report.read_text().strip():
            raise ValueError(f"Missing substantive report: {report}")
        verdict = load(ROOT / unit["verdict"])
        if verdict["unit_id"] != unit_id:
            raise ValueError(f"Mismatched verdict unit: {unit_id}")
        if (verdict["independent_review_required"] is not True
                or verdict["independent_review_status"] != "pending_native_reviewer"):
            raise ValueError(f"Engineer must not self-accept: {unit_id}")
        verdicts[unit_id] = verdict
        assessments[unit_id] = {
            entry["claim_id"]: entry for entry in verdict["claim_assessments"]
        }
        assessment_records[unit_id] = defaultdict(list)
        for entry in verdict["claim_assessments"]:
            disposition(entry["verdict"])
            assessment_records[unit_id][entry["claim_id"]].append(entry)
        for claim_id in unit["claim_ids"]:
            if claim_id in owner:
                raise ValueError(f"Duplicate primary claim owner: {claim_id}")
            owner[claim_id] = unit_id
            assessment = assessments[unit_id][claim_id]
            if not assessment["reason"]:
                raise ValueError(f"Unjustified claim disposition: {claim_id}")

    records = defaultdict(list)
    assumption_records = {}
    assumption_units = defaultdict(set)
    for claim in state["claims"]:
        claim_id = claim["claim_id"]
        records[claim_id].append(claim)
        unit_id = owner[claim_id]
        for assumption in claim["external_assumptions"]:
            key = assumption["content_hash"]
            if key not in assumption_records:
                assumption_records[key] = dict(assumption, claim_versions=[])
            assumption_records[key]["claim_versions"].append(
                {"claim_id": claim_id, "version": claim["version"], "unit": unit_id}
            )
            assumption_units[key].add(unit_id)
    if set(records) != set(owner):
        raise ValueError("Claim inventory is not an exact partition of the ledger")

    claims = []
    for claim_id, versions in records.items():
        versions.sort(key=lambda claim: claim["version"])
        unit_id = owner[claim_id]
        latest = versions[-1]
        claims.append({
            "claim_id": claim_id, "unit": unit_id,
            "latest_version": latest["version"],
            "exact_statement": latest["natural_statement"],
            "context": latest["context"],
            "assessment": assessments[unit_id][claim_id],
            "disposition": disposition(assessments[unit_id][claim_id]["verdict"]),
            "all_version_assessments": assessment_records[unit_id][claim_id],
            "assessment_report": units[unit_id]["report"],
            "versions": [{
                "version": claim["version"],
                "statement_binding": claim["content_hash"],
                "exact_statement": claim["natural_statement"],
                "assumptions": [{
                    "id": assumption["assumption_id"],
                    "binding": assumption["content_hash"],
                } for assumption in claim["external_assumptions"]],
                "retired_assumptions": claim["retired_assumptions"],
                "disposition": ("latest statement assessed" if claim is latest else
                                "superseded dependency annotation; assessed in report history"),
            } for claim in versions],
        })

    evidence = []
    for entry in state["evidence"]:
        subject = entry["subject"]
        ident = subject["subject_id"]
        if subject["kind"] == "claim":
            unit_ids = [owner[ident]]
        elif subject["kind"] == "assumption":
            unit_ids = sorted(assumption_units[subject["content_hash"]])
            if not unit_ids:
                raise ValueError(f"Unmapped assumption binding: {subject}")
        else:
            raise ValueError(f"Unmapped evidence subject: {subject}")
        evidence.append(dict(
            entry, units=unit_ids,
            assessment_reports=[units[unit]["report"] for unit in unit_ids],
            authority_limit="Historical evidence, not current native acceptance",
        ))

    artifact_groups = {}
    for group in index["artifact_groups"]:
        for path in group["paths"]:
            if path in artifact_groups:
                raise ValueError(f"Duplicate artifact assignment: {path}")
            artifact_groups[path] = group
    expected = {entry["path"] for entry in manifest["artifacts"]}
    if set(artifact_groups) != expected:
        raise ValueError("Manifest artifact inventory has omissions or additions")
    artifacts = []
    for entry in manifest["artifacts"]:
        path = entry["path"]
        if not (old / path).is_file():
            raise ValueError(f"Listed input is unavailable: {path}")
        group = artifact_groups[path]
        linked = [item for item in evidence if item["artifact"] == path]
        unit_ids = group["unit_ids"]
        details = {}
        if path.startswith("research/literature/") and path.endswith(".json"):
            if not linked:
                raise ValueError(f"Unmapped archived citation record: {path}")
            unit_ids = sorted({unit for item in linked for unit in item["units"]})
            citation = load(old / path)
            details["citation_record"] = {
                key: citation[key] for key in
                ("kind", "source_id", "locator", "outcome") if key in citation
            }
            details["exact_subject_bindings"] = [item["subject"] for item in linked]
        artifacts.append(dict(
            entry, disposition=group["disposition"], units=unit_ids,
            evidence_ids=[item["evidence_id"] for item in linked],
            assessment_reports=[units[unit]["report"] for unit in unit_ids],
            **details,
        ))

    nodes = []
    for ident, node in graph["nodes"].items():
        if ident in owner:
            unit_id = owner[ident]
            node_disposition = disposition(assessments[unit_id][ident]["verdict"])
        else:
            extra = index["additional_graph_nodes"][ident]
            unit_id = extra["unit"]
            node_disposition = extra["disposition"]
        nodes.append({
            "node_id": ident, "unit": unit_id,
            "historical_node": node, "disposition": node_disposition,
            "assessment_report": units[unit_id]["report"],
        })
    if {node["node_id"] for node in nodes} != set(owner) | set(index["additional_graph_nodes"]):
        raise ValueError("Graph nodes do not match the claimed coverage")

    routes = [{
        "route_id": route["route_id"],
        "unit": owner[route["goal"]["subject_id"]],
        "goal": route["goal"],
        "and_obligations": route["obligations"],
        "retired_because": route["retired_because"],
        "disposition": ("retired for the stated reason, not automatically refuted"
                        if route["retired_because"] else
                        "assessed decomposition; not evidence by itself"),
        "assessment_report": units[owner[route["goal"]["subject_id"]]]["report"],
    } for route in state["routes"]]
    return {
        "artifact_inventory": artifacts,
        "context_inventory": state["contexts"],
        "claim_inventory": claims,
        "assumption_inventory": list(assumption_records.values()),
        "route_inventory": routes,
        "evidence_inventory": evidence,
        "graph_inventory": nodes,
        "coverage": {
            "manifest_artifacts_mapped": len(artifacts),
            "reference_inputs_mapped": len(manifest["reference_inputs_and_tooling"]),
            "units_with_report_and_verdict": len(verdicts),
            "distinct_claim_ids_assessed": len(claims),
            "historical_claim_versions_mapped": sum(map(len, records.values())),
            "historical_contexts_mapped": len(state["contexts"]),
            "distinct_external_assumption_bindings_mapped": len(assumption_records),
            "ledger_routes_mapped": len(routes),
            "ledger_evidence_records_mapped": len(evidence),
            "graph_nodes_mapped": len(nodes),
            "omitted_manifest_paths": [], "omitted_claim_ids": [],
            "unassigned_graph_nodes": [], "multiply_counted_primary_claims": [],
            "native_independent_review": "required; pending Host invocation",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--refresh", action="store_true",
                        help="Bulk-expand the hand-authored index from exact old records")
    args = parser.parse_args()
    index = load(INDEX)
    generated = expand(index)
    if args.refresh:
        index.update(generated)
        INDEX.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    else:
        for key in GENERATED_KEYS:
            if index.get(key) != generated[key]:
                raise ValueError(f"Stale or incomplete index section: {key}")
    print(json.dumps({"ok": True, **generated["coverage"]}, indent=2))


if __name__ == "__main__":
    main()
