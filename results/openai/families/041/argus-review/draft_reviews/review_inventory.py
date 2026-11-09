"""Reconcile the assigned inventory and preserve its exact evidence bindings."""

import argparse
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import shutil

from argus_skill.verticals.math import math_state


ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"
CLAIMS = {
    "cartier-adjoint": "C_ADJOINT",
    "differential-identity": "C_DIFF",
    "frobenius-trace-lift": "C_TRACE",
    "completed-trace": "C_COMPLETION",
    "clearing-bridge": "C_CLEARING",
    "semiampleness": "C_SEMIAMPLENESS",
    "ordinary-base-change": "C_ORDINARY",
    "projective-base": "C_PROJECTIVE",
    "strong-syz": "C_SYZ",
}
ACTIVE = {unit: "RV_" + claim.removeprefix("C_") for unit, claim in CLAIMS.items()}
ACTIVE["boundary-controls"] = "RV_BOUNDARIES"


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=True, indent=2) + "\n")


def populate():
    index = json.loads(INDEX.read_text())
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    old_root = Path(prior["old_workspace"])
    old = math_state.load_state(old_root)
    mapping = {
        version: unit["id"]
        for unit in index["units"]
        for version in unit["legacy_claims"]
    }
    index["legacy_claim_versions"] = []
    for claim in old.claims:
        key = f"{claim.claim_id}@{claim.version}"
        index["legacy_claim_versions"].append({
            "claim_version": key,
            "unit": mapping.get(key),
            "exclusion": "legacy_goal_exclusion" if key == "C9000041@1" else None,
            "statement": claim.natural_statement,
            "context": claim.context.as_dict(),
            "content_hash": claim.content_hash,
            "has_formal_statement": bool(claim.formal_statement),
            "assumptions": [item.as_dict() for item in claim.external_assumptions],
            "retired_assumptions": [item.as_dict() for item in claim.retired_assumptions],
        })
    subjects = {}
    for claim in old.claims:
        key = (claim.ref().kind.value, claim.claim_id, claim.content_hash)
        subjects.setdefault(key, []).append(f"{claim.claim_id}@{claim.version}")
        for assumption in claim.external_assumptions:
            ref = assumption.ref()
            key = (ref.kind.value, ref.subject_id, ref.content_hash)
            subjects.setdefault(key, []).append(f"{claim.claim_id}@{claim.version}")
    index["legacy_evidence"] = []
    for evidence in old.evidence:
        ref = evidence.subject
        item = evidence.as_dict()
        item["bound_claim_versions"] = sorted(set(subjects.get(
            (ref.kind.value, ref.subject_id, ref.content_hash), []
        )))
        item["units"] = sorted({
            mapping[version] for version in item["bound_claim_versions"]
            if version in mapping
        })
        item["current_use"] = (
            "unchanged historical independent citation reading"
            if evidence.tier == math_state.EvidenceTier.LITERATURE
            and evidence.verdict == math_state.Verdict.SUPPORTS
            else "historical evidence only; not a new acceptance"
        )
        index["legacy_evidence"].append(item)
    listed = {item["path"]: item for item in prior["artifacts"]}
    snapshot = json.loads(Path(prior["preserved_snapshot_manifest"]).read_text())
    members = {
        item["path"].removeprefix("9000041/"): item
        for item in snapshot["files"] if item["path"].startswith("9000041/")
    }
    for item in index["artifacts"]:
        source = old_root / item["path"]
        item["listed_bytes"] = listed[item["path"]]["bytes"]
        item["observed_bytes"] = source.stat().st_size
        item["snapshot_member"] = "9000041/" + item["path"] if item["path"] in members else None
        if item["path"] in members:
            item["snapshot_sha256"] = members[item["path"]]["sha256"]
        item["provenance"] = (
            "snapshot member matched archive and old workspace during initial reconciliation"
            if item["path"] in members else
            "listed old-workspace supplement, not present in the preserved archive"
        )
    index["preserved_snapshot"]["archive_and_workspace_members_verified"] = 11
    index["preserved_snapshot"]["unlisted_family_members"] = sorted(set(members) - set(listed))
    manifest = json.loads(Path(prior["manuscript_reference_manifest"]).read_text())
    references = []
    for manuscript in manifest["manuscripts"]:
        base = Path(manuscript["source_directory"])
        declared = {item["path"]: item for item in manuscript["tex_sources"]}
        files = []
        for directory, dirs, names in os.walk(base):
            dirs[:] = sorted(name for name in dirs if name not in {".git", "__pycache__"})
            for name in sorted(names):
                if name.endswith(".pyc"):
                    continue
                source = Path(directory) / name
                relative = source.relative_to(base).as_posix()
                item = {
                    "path": relative,
                    "bytes": source.stat().st_size,
                    "role": "versioned manuscript source" if relative in declared else
                            "reference asset/tooling, not a separate Argus result",
                }
                if relative in declared:
                    item["expected_sha256"] = declared[relative]["sha256"]
                    item["matches_reference_manifest"] = (
                        hashlib.sha256(source.read_bytes()).hexdigest()
                        == declared[relative]["sha256"]
                    )
                    if not item["matches_reference_manifest"]:
                        raise ValueError(f"Reference version changed: {source}")
                files.append(item)
        missing = set(declared) - {item["path"] for item in files}
        if missing:
            raise ValueError(f"Missing declared sources for {manuscript['manuscript_id']}: {missing}")
        link = old_root / "research/openai_manuscript" / manuscript["manuscript_id"]
        references.append({
            "manuscript_id": manuscript["manuscript_id"],
            "source_revision": manuscript["source_revision"],
            "source_directory": str(base),
            "old_staged_path": str(link),
            "staged_resolves_to_declared_source": link.resolve() == base.resolve(),
            "files": files,
        })
    index["reference_source_inventory"] = references
    index["coverage"]["versioned_reference_sources"] = sum(
        item["role"] == "versioned manuscript source"
        for reference in references for item in reference["files"]
    )
    for unit in index["units"]:
        unit["active_claim"] = ACTIVE[unit["id"]]
    write_json(INDEX, index)
    print(json.dumps({
        "indexed_artifacts": len(index["artifacts"]),
        "indexed_claim_versions": len(index["legacy_claim_versions"]),
        "indexed_evidence_records": len(index["legacy_evidence"]),
        "versioned_sources_matched": index["coverage"]["versioned_reference_sources"],
        "reference_tree_files": sum(len(item["files"]) for item in references),
    }))


def record_scope():
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    old_root = Path(prior["old_workspace"])
    old = math_state.load_state(old_root)
    state = math_state.load_state(ROOT)
    if state.latest_context("RV_CTX") is not None:
        raise ValueError("Review scope already exists; do not overwrite an earlier round.")
    context = state.add_context(math_state.ContextVersion(
        "RV_CTX", 1,
        "Exploratory review of every old Family 041 draft under OBJECTIVE.md and PRIOR_DRAFTS.json; no new error search and no claim of either manuscript theorem.",
        {
            "unit": "one substantive argument or independently assessable scope, with copies and evidence versions grouped",
            "supported": "support for the exact stated hypotheses and conclusion, not global manuscript correctness",
            "formal_scope": "the PBasisCartier, subring, derivative-stability, scalar-identity and psi-formula hypotheses in the copied Lean statement",
            "boundary_attack": "an excluded-hypothesis control, never an admissible manuscript counterexample",
            "acceptance": "only the native independent Reviewer may accept family completion",
        },
    ))
    for unit, old_id in CLAIMS.items():
        inherited = old.latest_claim(old_id)
        statement = inherited.natural_statement
        if unit == "clearing-bridge":
            statement = (
                "Conditional on the retained scalar identity, the Cartier formula, derivative-stable regular coefficients, and psi(1) not in the closed-point maximal ideal, the explicit adjoint witness T in R gives psi(g*T)=psi(1), hence psi(g*T)(b) is nonzero. This does not establish the geometric inputs or ordinary base change."
            )
        state.add_claim(math_state.ClaimVersion(
            ACTIVE[unit], 1, context.ref(), statement,
            formal_statement=inherited.formal_statement if unit == "cartier-adjoint" else "",
            external_assumptions=inherited.external_assumptions,
        ))
    state.add_claim(math_state.ClaimVersion(
        "RV_BOUNDARIES", 1, context.ref(),
        "For every prime p, R=F_p[u], s=u^(p-1), g=u^p and psi(r)=Cartier(s*r) have psi(1)=1 and psi(g*R) contained in (u). The proposed order-zero coefficient u^(-p) is nonregular; the p-th Hasse derivative is not an allowed ordinary derivative. These examples do not refute the manuscript's retained-hypothesis clearing lemma.",
    ))
    state.add_claim(math_state.ClaimVersion(
        "RV_LIMITS", 1, context.ref(),
        "The old inventory has 57 listed artifacts, 21 legacy claim versions and ten substantive units. Historical compiler/source-attribution records, finite diagnostics, local algebra and excluded-hypothesis attacks must not be promoted to an independent verification of either manuscript.",
        external_assumptions=(
            math_state.ExternalAssumption(
                "INHERITED_EVIDENCE_LIMITS",
                "The final old certificate concerns only the conditional algebraic source; its human statement reading, source excerpts and geometric instantiations are distinct evidence. Earlier compiler certificates were inconclusive, registry resolutions only established document existence, and the old umbrella audit objective is not a theorem.",
                "Read-only old research/MATH_STATE.json, PROOF_GRAPH.json, exact_certificate.json and PRIOR_DRAFTS.json; inherited evidence whose mathematical scope is being reviewed here.",
                filed_by="engineer:old-draft-review",
            ),
            math_state.ExternalAssumption(
                "EXCLUDED_HYPOTHESIS_ATTACKS",
                "The polynomial controls in exact_certificate.json omit regular coefficient stability or replace ordinary derivatives with a p-th Hasse derivative; they cannot serve as counterexamples to the retained geometric hypotheses.",
                "Old research/cartier-clearing/exact_certificate.json, supplemental_experiments.hypothesis_controls; inspect verify.py before any isolated replay.",
                filed_by="engineer:old-draft-review",
            ),
        ),
    ))
    assumptions = {
        item.ref() for claim in state.current_claims() for item in claim.external_assumptions
    }
    for evidence in old.evidence:
        if evidence.tier != math_state.EvidenceTier.LITERATURE or evidence.subject not in assumptions:
            continue
        target = ROOT / "research/draft_reviews/inherited/literature" / Path(evidence.artifact).name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(old_root / evidence.artifact, target)
        state.add_evidence(math_state.EvidenceRecord(
            evidence.evidence_id, evidence.subject, evidence.tier, evidence.verdict,
            evidence.produced_by, target.relative_to(ROOT).as_posix(),
        ))
    write_json(ROOT / "research/MATH_STATE.json", state.as_dict())
    print(json.dumps({
        "active_context": "RV_CTX",
        "active_claims": len(state.current_claims()),
        "inherited_citation_records": len(state.evidence),
        "scope_recorded_before_assessment": True,
        "historical_citation_producers_preserved_not_impersonated": True,
    }))


def finalize():
    index = json.loads(INDEX.read_text())
    state = math_state.load_state(ROOT)
    replay = ROOT / "research/draft_reviews/cartier-adjoint/replay"
    runtime = math_state.load_state(replay)
    formal = runtime.latest_claim("RV_ADJOINT")
    if formal.ref() != state.latest_claim("RV_ADJOINT").ref():
        raise ValueError("The runtime compiler answered a different claim version.")
    records = [
        item for item in runtime.evidence
        if item.subject == formal.ref()
        and item.tier == math_state.EvidenceTier.MECHANICAL
    ]
    if len(records) != 1:
        raise ValueError("Expected one actual native compiler record, not a selected verdict.")
    native = records[0]
    certificate_path = replay / native.artifact
    certificate = json.loads(certificate_path.read_text())
    check = certificate["lean_check"]
    if (
        check["exit_code"] != 0 or check["audit_exit_code"] != 0
        or check["proof_holes"] or certificate["subject"] != formal.ref().as_dict()
    ):
        raise ValueError("The real native compiler result does not support this claim.")
    relative_certificate = certificate_path.relative_to(ROOT).as_posix()
    state.add_evidence(math_state.EvidenceRecord(
        native.evidence_id, native.subject, native.tier, native.verdict,
        native.produced_by, relative_certificate,
    ))
    counts = Counter()
    for unit in index["units"]:
        verdict = json.loads((ROOT / unit["verdict"]).read_text())
        counts[verdict["assessment"]] += 1
        unit["assessment"] = verdict["assessment"]
        unit["result_class"] = verdict["result_class"]
        unit["native_independent_review"] = "required_pending"
        unit["current_claim_reference"] = state.latest_claim(ACTIVE[unit["id"]]).ref().as_dict()
        opinion = (
            math_state.Verdict.SUPPORTS
            if verdict["assessment"] == "supported_scope" else
            math_state.Verdict.INCONCLUSIVE
        )
        state.add_evidence(math_state.EvidenceRecord(
            "engineer-review-" + unit["id"],
            state.latest_claim(ACTIVE[unit["id"]]).ref(),
            math_state.EvidenceTier.JUDGEMENT, opinion,
            "engineer:old-draft-review",
            relative_certificate if unit["id"] == "cartier-adjoint" else unit["report"],
        ))
    state.add_evidence(math_state.EvidenceRecord(
        "engineer-review-scope",
        state.latest_claim("RV_LIMITS").ref(),
        math_state.EvidenceTier.JUDGEMENT, math_state.Verdict.SUPPORTS,
        "engineer:old-draft-review", "research/OLD_ROUND_REVIEW.md",
    ))
    for route_id, obligations in (
        ("RV_ADJOINT_ROUTE", ("RV_ADJOINT", "RV_DIFF", "RV_TRACE")),
        ("RV_COMPLETION_ROUTE", ("RV_COMPLETION", "RV_DIFF", "RV_TRACE")),
    ):
        state.add_route(math_state.ProofRoute(
            route_id, state.latest_claim("RV_CLEARING").ref(),
            tuple(state.latest_claim(item).ref() for item in obligations),
        ))
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    old = math_state.load_state(prior["old_workspace"])
    index["legacy_contexts"] = [item.as_dict() for item in old.contexts]
    routes = {item.route_id: item.as_dict() for item in old.routes}
    for route in index["legacy_routes"]:
        route["legacy_record"] = routes[route["id"]]
    for reference in index["reference_source_inventory"]:
        for item in reference["files"]:
            if item["path"].endswith("README.md"):
                item["role"] = "manuscript package metadata; supporting attribution, not an Argus mathematical draft"
            elif item["path"].endswith(".bib"):
                item["role"] = "manuscript bibliography; supporting citation metadata, not an independently proved result"
    index["coverage"]["assessment_state"] = "all_ten_assessed_native_review_pending"
    index["coverage"]["assessment_counts"] = dict(counts)
    index["coverage"]["engineer_self_acceptance"] = False
    index["fresh_evidence"] = {
        "formal": {
            "unit": "cartier-adjoint",
            "certificate": relative_certificate,
            "produced_by": native.produced_by,
            "compiler_exit_code": check["exit_code"],
            "audit_exit_code": check["audit_exit_code"],
            "proof_holes": check["proof_holes"],
            "duration_ms": check["duration_ms"],
            "source": check["source"],
            "source_sha256": check["source_sha256"],
            "statement_fidelity": check["statement_fidelity"],
            "statement_fidelity_sha256": check["statement_fidelity_sha256"],
            "tools": check["tools"],
            "runtime_record_reused_without_changing_its_subject_or_verdict": True,
            "certificate_envelope_paths_relative_to": str(replay),
            "ledger_artifact_path_relative_to": str(ROOT),
        },
        "finite_diagnostics": {
            "units": ["cartier-adjoint", "boundary-controls"],
            "artifact": "research/draft_reviews/cartier-adjoint/diagnostics.json",
            "scope": "finite experiment, not universal proof",
        },
        "jacobian": {
            "unit": "boundary-controls",
            "execution": "research/draft_reviews/boundary-controls/jacobian_execution.json",
            "scope": "one exact QQ derivative; not a Cartier-field or geometric result",
        },
    }
    index["citation_reuse"] = {
        "inherited_records": 11,
        "registry_only_inconclusive": 3,
        "historical_independent_proposition_readings": 8,
        "copied_to": "research/draft_reviews/inherited/literature/",
        "original_producers_preserved": True,
        "fresh_native_reviewer_acceptance_claimed": False,
        "limitation": "Archived source attributions support only their propositions, not the geometric instantiations. Stacks tag texts carry the old retrieval date, not a newly invented upstream revision.",
    }
    write_json(ROOT / "research/MATH_STATE.json", state.as_dict())
    write_json(INDEX, index)
    print(json.dumps({
        "active_claims": len(state.current_claims()),
        "actual_runtime_compiler_records_reused": len(records),
        "engineer_judgements": 11,
        "assessment_counts": dict(counts),
        "native_review": "required_pending",
    }))


def check_complete():
    index = json.loads(INDEX.read_text())
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    old = math_state.load_state(prior["old_workspace"])
    expected_paths = Counter(item["path"] for item in prior["artifacts"])
    actual_paths = Counter(item["path"] for item in index["artifacts"])
    if expected_paths != actual_paths:
        raise ValueError("Artifact coverage differs from PRIOR_DRAFTS.json.")
    expected_claims = Counter(f"{item.claim_id}@{item.version}" for item in old.claims)
    actual_claims = Counter(item["claim_version"] for item in index["legacy_claim_versions"])
    if expected_claims != actual_claims:
        raise ValueError("Legacy claim-version coverage is incomplete or duplicated.")
    mapped = Counter(
        version for unit in index["units"] for version in unit["legacy_claims"]
    )
    mapped.update([index["legacy_goal_exclusion"]["claim"]])
    if mapped != expected_claims:
        raise ValueError("A legacy version is unmapped or counted in two units.")
    expected_evidence = {item.evidence_id for item in old.evidence}
    if {item["evidence_id"] for item in index["legacy_evidence"]} != expected_evidence:
        raise ValueError("An inherited evidence record is omitted.")
    ids = {unit["id"] for unit in index["units"]}
    if len(ids) != len(index["units"]):
        raise ValueError("Duplicate mathematical unit.")
    for artifact in index["artifacts"]:
        if not artifact["units"] and not artifact.get("exclusion"):
            raise ValueError(f"Unjustified artifact exclusion: {artifact['path']}")
        if not set(artifact["units"]) <= ids:
            raise ValueError(f"Unknown unit for {artifact['path']}")
    for unit in index["units"]:
        report = ROOT / unit["report"]
        verdict = json.loads((ROOT / unit["verdict"]).read_text())
        if not report.is_file() or report.stat().st_size == 0:
            raise ValueError(f"Missing assessment: {unit['id']}")
        if verdict["unit"] != unit["id"] or not verdict.get("assessment"):
            raise ValueError(f"Invalid assessment identity: {unit['id']}")
        if verdict.get("native_independent_review") != "required_pending":
            raise ValueError(f"Engineer cannot accept {unit['id']}.")
        if verdict.get("research_target_level") != "exploratory":
            raise ValueError(f"Research target changed for {unit['id']}.")
        if verdict["assessment"] in {"partial_support", "unresolved"} and not verdict.get("open_obligations"):
            raise ValueError(f"Unresolved assessment has no mathematical obligation: {unit['id']}")
    if not (ROOT / "research/OLD_ROUND_REVIEW.md").is_file():
        raise ValueError("Missing all-unit summary.")
    print(json.dumps({
        "project_root": str(ROOT),
        "artifact_coverage": len(actual_paths),
        "claim_version_coverage": sum(actual_claims.values()),
        "legacy_evidence_coverage": len(expected_evidence),
        "substantive_assessments": len(ids),
        "unexplained_omissions": 0,
        "duplicate_claim_results": 0,
        "native_acceptance": "not performed",
    }, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("populate", "scope", "finalize", "check"))
    operation = parser.parse_args().operation
    {"populate": populate, "scope": record_scope, "finalize": finalize, "check": check_complete}[operation]()
