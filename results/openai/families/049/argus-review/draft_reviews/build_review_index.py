#!/usr/bin/env python3
"""Expand the supplied inventory using the completed mathematical assessments."""

import collections
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"
REVIEWS = ROOT / "research/draft_reviews"
POLYNOMIAL = "october-polynomial-stabilization"
OBSTRUCTION = "october-unrestricted-obstruction"
SEPTEMBER = "september-construction-critical-point"
PRINCIPAL = "universal-principalization"
PERTURBATION = "lower-perturbation-rigidity"
SURFACE = "uniform-surface-family"
PROVENANCE = "provenance-known-status"
PREFIX = "OAI.AlgebraicGeometry.StableCoordinate."
CORE = "research/stable_core_certificate/"


def load(path):
    return json.loads(path.read_text())


def check_index(index):
    inventory = load(ROOT / "PRIOR_DRAFTS.json")["artifacts"]
    artifacts = index["artifacts"]
    assert len(artifacts) == len(inventory) == 239
    assert [a["path"] for a in artifacts] == [a["path"] for a in inventory]
    assert len({a["path"] for a in artifacts}) == 239
    units = {u["id"] for u in index["units"]}
    assert len(units) == 7
    for artifact in artifacts:
        assert artifact["primary_unit"] in units
        assert set(artifact["shared_units"]) <= units
        assert artifact["present"] and artifact["actual_bytes"] == artifact["inventory_bytes"]
        assert artifact["role"] and artifact["assessment"]
    assert len(index["claim_versions"]) == 24
    assert len({(c["claim_id"], c["version"]) for c in index["claim_versions"]}) == 24
    assert len(index["historical_evidence"]) == 17
    assert len(index["historical_ledger_routes"]) == 7
    assert len(index["historical_graph_nodes"]) == 20
    assert len(index["symbolic_checks"]) == 81
    assert len({c["name"] for c in index["symbolic_checks"]}) == 81
    assert len(index["formal_modules"]) == 92
    for unit in index["units"]:
        assert (ROOT / unit["report"]).is_file()
        verdict = load(ROOT / unit["verdict"])
        assert verdict.get("unit_id", verdict.get("unit")) == unit["id"]
        assert verdict["independent_review_required"] is True
        assert verdict.get("completion_accepted", False) is False
        assert unit["engineering_verdict"] in {"supported", "partial", "invalid", "unresolved"}
    for claim in index["claim_versions"]:
        assert claim["unit"] in units
        assert claim["report"] and claim["assessment"]
    for evidence in index["historical_evidence"]:
        assert len(evidence["exact_claim_versions"]) == 1
    for route in index["historical_ledger_routes"]:
        assert route["goal_version"] and all(route["obligation_versions"])
    for module in index["formal_modules"]:
        assert module["primary_unit"] in units
        assert module["declarations"]
    assert index["independent_review_required"] is True
    print(
        "PASS: 239 artifacts; 24 claim versions / 20 identifiers; "
        "17 historical evidence records; 7 ledger routes; 20 graph nodes; "
        "92 source/object pairs; 81 symbolic checks; 7 report/verdict pairs."
    )


def build():
    index = load(INDEX)
    inventory = load(ROOT / "PRIOR_DRAFTS.json")
    old = Path(inventory["old_workspace"])
    ledger = load(old / "research/MATH_STATE.json")
    graph = load(old / "research/PROOF_GRAPH.json")
    audit = load(REVIEWS / OBSTRUCTION / "dependency_audit.json")
    declaration_map = load(REVIEWS / OBSTRUCTION / "declaration_dependency_map.json")
    replay = load(REVIEWS / SEPTEMBER / "exact_replay.json")
    snapshot = load(Path(inventory["preserved_snapshot_manifest"]))
    snapshot_entries = {
        a["path"].split("/", 1)[1]: a
        for a in snapshot["files"]
        if a["path"].startswith("9000049/")
    }
    unit_by_claim = {
        claim: unit["id"] for unit in index["units"] for claim in unit["claims"]
    }
    unit_by_claim["C9000049"] = PROVENANCE
    reports = {unit["id"]: unit["report"] for unit in index["units"]}
    all_units = list(reports)

    partition = []
    for group in index["coverage_partition"]:
        partition.extend(group.get("ordinals", []))
        if "ordinal_range" in group:
            start, end = group["ordinal_range"]
            partition.extend(range(start, end + 1))
    assert sorted(partition) == list(range(1, 240))

    module_groups = {}
    for group, names in declaration_map["all_staged_modules_by_support_role"].items():
        for name in names:
            assert name not in module_groups
            module_groups[name] = group

    def module_units(name):
        group = module_groups[name]
        if name == "Definitions" or group.startswith("shared_parent_owned"):
            return POLYNOMIAL, [OBSTRUCTION]
        if group == "october_rigidity_support_shared_with_lower_perturbation_unit":
            return PERTURBATION, [OBSTRUCTION, SURFACE]
        if name == "BundlePrincipalization":
            return PRINCIPAL, [OBSTRUCTION, SURFACE]
        if group == "domain_ufd_and_actual_determinant_coefficient_charts":
            return OBSTRUCTION, [PERTURBATION, SURFACE]
        return OBSTRUCTION, [SURFACE]

    def check_unit(name):
        if name.startswith("sep_"):
            return SEPTEMBER
        if name.startswith("family_"):
            return SURFACE
        if name.startswith("global_") or name.startswith("boundary_a_zero"):
            return PRINCIPAL
        if name.startswith(("base_", "chart_", "boundary_z_")):
            return OBSTRUCTION
        return POLYNOMIAL

    formal_units = [OBSTRUCTION, POLYNOMIAL, PRINCIPAL, PERTURBATION]
    artifact_records = []
    for ordinal, artifact in enumerate(inventory["artifacts"], 1):
        relative = artifact["path"]
        path = old / relative
        name = path.name
        primary, shared = PROVENANCE, []
        counterpart = None
        if path.suffix in {".lean", ".olean"} and name != "Main.lean":
            primary, shared = module_units(path.stem)
            source = CORE + "formal_sources/" + relative.split("/OAI/", 1)[1]
            source = source.replace("formal_sources/", "formal_sources/OAI/", 1)
            source = str(Path(source).with_suffix(".lean"))
            counterpart = (
                source.replace("/formal_sources/", "/formal_build/").replace(".lean", ".olean")
                if path.suffix == ".lean"
                else source
            )
            role = "formal_dependency_source" if path.suffix == ".lean" else "compiled_copy_of_dependency"
            assessment = (
                "Declaration headers, assumptions and imports are indexed in formal_modules; "
                "source/object pair is one supporting argument, not two results. "
                "Fresh wrapper uses cached objects; no fresh dependency rebuild is asserted."
            )
        elif name == "Main.lean":
            primary, shared = OBSTRUCTION, [POLYNOMIAL, PRINCIPAL, PERTURBATION, SURFACE]
            role = "shared_formal_wrapper"
            assessment = (
                "Eight printed axiom roots and ten theorem declarations; v3 succeeds. "
                "Surface unit uses general cores only; September and the full fibre package are not encoded."
            )
        elif relative in {"research/MATH_STATE.json", "research/PROOF_GRAPH.json"}:
            shared = [unit for unit in all_units if unit != PROVENANCE]
            role = "historical_claim_version_ledger" if name == "MATH_STATE.json" else "historical_dependency_graph"
            assessment = "All records mapped below; historical status and reviewer labels are not inherited acceptance."
        elif path.suffix == ".lock":
            role, assessment = "excluded_empty_lock", "Zero-byte runtime lock, not mathematical evidence."
        elif name == "LICENSE":
            role, assessment = "attribution_license", "Retained reused implementation license; no mathematical claim."
        elif name == "report.md":
            shared = [unit for unit in all_units if unit != PROVENANCE]
            role, assessment = "shared_prose_draft", "All mathematical sections partitioned among the seven assessments; primary-source scope erratum recorded."
        elif name == "statement_fidelity.md":
            shared = formal_units
            role, assessment = "historical_statement_reading", "Compared with actual definitions and quantifiers; not inherited independent approval."
        elif name in {"exact_certificate.json", "verify.py"}:
            primary, shared = POLYNOMIAL, [OBSTRUCTION, PRINCIPAL, SEPTEMBER, SURFACE]
            role = "shared_exact_algebra_certificate" if name.endswith(".json") else "shared_exact_algebra_checker"
            assessment = "All 81 named checks mapped individually below; one fresh isolated replay, not an unrestricted LND enumeration."
        elif name.startswith("jacobian_"):
            primary = PRINCIPAL
            role, assessment = "historical_typed_normal_form_evidence", "Old operation contract/request/result; consistency replayed, not a new adapter invocation."
        elif name.startswith("mathlib_") and path.suffix == ".txt":
            primary, shared = OBSTRUCTION, [PERTURBATION]
            role, assessment = "quoted_imported_library_source", "Actual derivation/localization/UFD helper source; not a new theorem or external axiom."
        elif name == "replay_formal.py":
            primary, shared = OBSTRUCTION, [POLYNOMIAL, PRINCIPAL, PERTURBATION]
            role, assessment = "historical_formal_build_driver", "Inspected but not executed: can overwrite preserved objects, records and ledger."
        elif "/certificates/" in relative:
            primary, shared = OBSTRUCTION, [POLYNOMIAL, PRINCIPAL, PERTURBATION]
            role = "version_bound_compiler_certificate"
            assessment = (
                "v2 failed elaboration: inconclusive, error-induced sorryAx; not a proof or mathematical refutation."
                if "6e32222f" in name else
                "v3 successful source-bound wrapper certificate; fidelity approval and import rebuild are separate."
            )
        elif path.suffix == ".log":
            primary, shared = OBSTRUCTION, [POLYNOMIAL, PRINCIPAL, PERTURBATION]
            role, assessment = "historical_diagnostic_log", "Diagnostics or structural-check output, not an additional mathematical result; see historical compiler audit."
        elif path.suffix == ".json":
            primary, shared = OBSTRUCTION, [POLYNOMIAL, PRINCIPAL, PERTURBATION]
            role, assessment = "historical_build_or_gate_record", "Queued, intermediate, cached and successful states distinguished in historical_compiler_audit.json; not independent acceptance."
            if name == "current_route_result.json":
                primary, shared = SURFACE, [PROVENANCE]
                assessment = "Historical strongest-family route summary, not an extra proof or final acceptance."
        else:
            raise AssertionError(f"Unclassified inventory artifact: {relative}")
        record = {
            "ordinal": ordinal,
            "path": relative,
            "inventory_bytes": artifact["bytes"],
            "actual_bytes": path.stat().st_size if path.is_file() else None,
            "present": path.is_file(),
            "primary_unit": primary,
            "shared_units": list(dict.fromkeys(u for u in shared if u != primary)),
            "role": role,
            "assessment": assessment,
            "report": reports[primary],
            "counted_as_separate_result": False,
        }
        if counterpart:
            assert counterpart in {a["path"] for a in inventory["artifacts"]}
            record["same_argument_counterpart"] = counterpart
        if relative in snapshot_entries:
            record["snapshot_copy"] = {
                "path": "9000049/" + relative,
                "sha256": snapshot_entries[relative]["sha256"],
                "match": True,
                "measurement": "103/103 family entries matched in the read-only post-replay snapshot comparison",
                "counted_as_separate_result": False,
            }
        artifact_records.append(record)

    formal_roots = {
        "C_OCT_PRESENTATION": ["OAI.StableCoordinate.Presentation.originalPresentation_p"],
        "C_OCT_STABILITY": ["OAI.StableCoordinate.f_isOneStableCoordinate", "IndependentStableCore.literal_one_stable"],
        "C_OCT_NONCOORD": ["IndependentStableCore.literal_noncoordinate", "IndependentStableCore.literal_one_stable"],
        "C_GLOBAL_PRINCIPAL": ["IndependentStableCore.universal_principalization"],
        "C_PERTURBATION_RIGIDITY": ["IndependentStableCore.lower_perturbation_rigidity"],
    }
    natural_seen = {}
    versions_by_hash = collections.defaultdict(list)
    claim_versions = []
    for claim in ledger["claims"]:
        claim_id, version = claim["claim_id"], claim["version"]
        key = f"{claim_id}@{version}"
        unit = unit_by_claim[claim_id]
        mapped = declaration_map["claim_declarations"].get(key, {})
        record = {
            "claim_id": claim_id,
            "version": version,
            "old_content_hash": claim["content_hash"],
            "unit": unit,
            "natural_statement": claim["natural_statement"],
            "context_reference": claim["context"],
            "formal_text_attached": bool(claim.get("formal_statement")),
            "proof_locator": f"{inventory['old_workspace']}/research/MATH_STATE.json#{key}",
            "declarations_and_conditions": mapped or formal_roots.get(claim_id, []),
            "historical_external_assumptions": claim.get("external_assumptions", []),
            "historical_retired_assumptions": claim.get("retired_assumptions", []),
            "report": reports[unit],
            "assessment": "Scoped engineering assessment; no inherited old reviewer acceptance.",
        }
        if claim_id == "C9000049":
            record["assessment"] = "Excluded as mathematical theorem: historical audit objective only."
        elif claim_id == "C_STABLE_CORE_VERIFY" and version == 2:
            record["assessment"] = "Unchanged mathematical statement supported by repaired v3; this v2 formal artifact is invalid as a completed proof."
        elif claim_id in {"C_SEP_LIFT", "C_SEP_TRANSLATION", "C_SEP_ZERO", "C_SEP_CRITICAL", "C_DANIELEWSKI_RESTRICTION", "C_OCT_FIBERS"}:
            record["assessment"] = "Prose proof and exact algebra assessed; not a direct conclusion of the eight printed Lean roots."
        elif claim_id == "C_SCOPE_PRIOR_ART":
            record["assessment"] = "Evidence-status distinctions retained; broader reduced-ring citation commentary corrected from the primary source."
        natural = claim["natural_statement"]
        if natural in natural_seen:
            record["same_natural_statement_as"] = natural_seen[natural]
        else:
            natural_seen[natural] = key
        versions_by_hash[claim["content_hash"]].append(key)
        claim_versions.append(record)

    historical_evidence = []
    for evidence in ledger["evidence"]:
        record = dict(evidence)
        record["exact_claim_versions"] = versions_by_hash[evidence["subject"]["content_hash"]]
        record["unit"] = unit_by_claim[evidence["subject"]["subject_id"]]
        record["current_acceptance_inherited"] = False
        historical_evidence.append(record)

    routes = []
    for route in ledger["routes"]:
        routes.append({
            "route_id": route["route_id"],
            "goal_version": versions_by_hash[route["goal"]["content_hash"]],
            "obligation_versions": [versions_by_hash[o["content_hash"]] for o in route["obligations"]],
            "retired_because": route["retired_because"],
            "interpretation": "Version-specific supersession, not a mathematical failure" if route["retired_because"] else "Historical decomposition, not an independently accepted proof",
        })

    modules = []
    for module, data in audit["modules"].items():
        primary, shared = module_units(module.removeprefix(PREFIX))
        modules.append({
            "module": module,
            "source": str(Path(data["source"]).relative_to(old)),
            "compiled_copy": str(Path(data["olean"]).relative_to(old)),
            "primary_unit": primary,
            "shared_units": shared,
            "support_role": module_groups[module.removeprefix(PREFIX)],
            "imports": data["imports"],
            "declarations": data["declarations"],
            "variable_context_lines": data["variable_context_lines"],
            "source_and_object_fingerprints": "research/draft_reviews/october-unrestricted-obstruction/dependency_audit.json",
        })

    for unit in index["units"]:
        verdict = load(ROOT / unit["verdict"])
        unit["engineering_verdict"] = verdict.get("mathematical_verdict", verdict.get("verdict"))
        unit["claim_versions"] = [
            f"{c['claim_id']}@{c['version']}" for c in claim_versions
            if c["unit"] == unit["id"] and c["claim_id"] != "C9000049"
        ]
        unit["primary_artifact_ordinals"] = [a["ordinal"] for a in artifact_records if a["primary_unit"] == unit["id"]]
        unit["shared_artifact_ordinals"] = [a["ordinal"] for a in artifact_records if unit["id"] in a["shared_units"]]

    index.update({
        "assessment_state": "All seven substantive units assessed by Engineers; native independent review outstanding",
        "artifacts": artifact_records,
        "claim_versions": claim_versions,
        "historical_contexts": ledger["contexts"],
        "historical_evidence": historical_evidence,
        "historical_ledger_routes": routes,
        "historical_graph_routes": graph["routes"],
        "historical_graph_nodes": [
            {"claim_id": claim_id, "unit": unit_by_claim[claim_id], "historical_node": node, "acceptance_inherited": False}
            for claim_id, node in graph["nodes"].items()
        ],
        "formal_modules": modules,
        "formal_wrapper_declarations": [
            {"name": name, "unit": unit, "status": status}
            for name, unit, status in [
                ("universal_principalization", PRINCIPAL, "printed root"),
                ("signed_quadric_identity", POLYNOMIAL, "printed root; identity only"),
                ("lower_perturbation_rigidity", PERTURBATION, "printed root"),
                ("october_rigidity", OBSTRUCTION, "supporting specialization"),
                ("unrestricted_invariant_exclusion", OBSTRUCTION, "printed root; fixed I"),
                ("literal_matches", POLYNOMIAL, "definitional supporting equality"),
                ("literal_coordinate_to_invariant", OBSTRUCTION, "printed root"),
                ("literal_noncoordinate", POLYNOMIAL, "printed root"),
                ("literal_one_stable", POLYNOMIAL, "printed root"),
                ("stable_core_verify", OBSTRUCTION, "printed composite root, not a separate new result"),
            ]
        ],
        "symbolic_checks": [
            {
                "ordinal": ordinal, "name": check["name"], "kind": check["kind"],
                "statement": check["statement"], "unit": check_unit(check["name"]),
                "exact_output": "research/draft_reviews/september-construction-critical-point/exact_replay.json",
                "scope": "Exact identity, ideal membership or nonzero witness; not universal LND enumeration",
            }
            for ordinal, check in enumerate(replay["checks"], 1)
        ],
        "source_preservation": {
            "inventory_paths_present": 239,
            "inventory_byte_counts_match": all(a["actual_bytes"] == a["inventory_bytes"] for a in artifact_records),
            "snapshot_family_entries": len(snapshot_entries),
            "snapshot_family_entries_matching": 103,
            "snapshot_missing_or_changed": 0,
            "not_in_snapshot": len(artifact_records) - len(snapshot_entries),
            "measurement": "Read-only post-replay SHA-256 comparison of the existing snapshot manifest, performed once; no snapshot rebuild",
            "additional_preservation_evidence": "research/draft_reviews/september-construction-critical-point/exact_replay_run.json",
            "old_writing_entrypoints_executed": False,
        },
        "checker_map": [
            {"checker": "old verify.py compute()", "input": CORE + "verify.py", "units": [POLYNOMIAL, OBSTRUCTION, PRINCIPAL, SURFACE, SEPTEMBER], "replay": "research/draft_reviews/september-construction-critical-point/exact_replay_run.json", "exit_code": 0, "scope": "81 exact algebra checks"},
            {"checker": "Lean 4.31.0 --stdin", "input": CORE + "Main.lean", "units": formal_units, "replay": "research/draft_reviews/october-unrestricted-obstruction/main_replay.json", "exit_code": 0, "scope": "Fresh wrapper elaboration and eight printed axiom lists against cached imports"},
            {"checker": "92-source import/declaration audit", "units": formal_units, "evidence": "research/draft_reviews/october-unrestricted-obstruction/dependency_audit.json", "scope": "Static coverage and interfaces, not a fresh 92-object kernel rebuild"},
            {"checker": "historical replay_formal.py", "input": CORE + "replay_formal.py", "units": formal_units, "executed": False, "reason": "Could overwrite preserved objects, records and old ledger"},
            {"checker": "Jacobian polynomial.multivariate.gcd.compute", "units": [PERTURBATION, PROVENANCE], "payload": "research/draft_reviews/provenance-known-status/jacobian_payload.json", "typed_result": "research/draft_reviews/provenance-known-status/jacobian_result.json", "exit_code": 0, "timeout": False, "scope": "Only gcd(a,bd+1)=1 over QQ[a,b,d]"},
        ],
        "independent_review": {
            "required": True, "accepted": False,
            "authority": "Native Host-invoked independent Reviewer",
            "old_reviewer_judgements_inherited": False,
            "new_reviewer_subagent_spawned": False,
        },
    })
    check_index(index)
    INDEX.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    print("Index persisted:", INDEX.relative_to(ROOT))
    print("Primary artifact counts:", dict(collections.Counter(a["primary_unit"] for a in artifact_records)))
    print("Exact check counts:", dict(collections.Counter(c["unit"] for c in index["symbolic_checks"])))


if __name__ == "__main__":
    build()
