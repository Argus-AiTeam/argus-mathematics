#!/usr/bin/env python3
"""Rerun the entire standalone hierarchy proof and axiom audit, without ledger writes."""

import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
WORKSPACE = Path("/home/argustest/.local/share/argus-skill/mathlib-v4.31.0")
LAKE = "/home/argustest/.elan/bin/lake"
AUDIT = "/home/argustest/zimo/argus-live-update/argus_skill/tools/lean_axiom_audit.lean"
CLAIMS = ("C_TFC_PROTOCOL_EXTRACTION", "C_TFC_HISTORY")
DECLARATIONS = [
    "LiteralHierarchy.thm_structure",
    "LiteralHierarchy.bounded_hierarchy_exists",
    "LiteralHierarchy.literal_protocol_extraction",
    "LiteralHierarchy.literal_history_preservation",
    "LiteralHierarchy.BoundedHierarchy",
    "LiteralHierarchy.BoundedHierarchy.nodeCount",
    "LiteralHierarchy.SideSystem.run_exists",
    "LiteralHierarchy.SideSystem.Run.all_promotions",
    "LiteralHierarchy.SideSystem.Run.promotions_in_order",
    "LiteralHierarchy.SideSystem.Run.every_position_collected",
    "LiteralHierarchy.Batch.all_same_promotions",
    "LiteralHierarchy.Batch.all_switched_promotions",
    "LiteralHierarchy.Batch.every_gap_realized",
    "LiteralHierarchy.Batch.every_mark_described",
    "LiteralHierarchy.Batch.original_marks",
    "LiteralHierarchy.Batch.original_child",
    "LiteralHierarchy.Batch.every_child_smaller",
    "LiteralHierarchy.Batch.marks_and_children_cover",
    "LiteralHierarchy.Tiling.partition_jobs",
    "LiteralHierarchy.Tiling.unique_part",
    "LiteralHierarchy.switch_exhausted_sentinel",
    "LiteralHierarchy.switch_exhausted_transport",
    "LiteralHierarchy.switched_final_threshold",
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    subprocess.run([sys.executable, str(HERE / "compose.py"), "--check"], cwd=ROOT, check=True)
    source, fidelity = HERE / "Main.lean", HERE / "statement_fidelity.md"
    before = [digest(source), digest(fidelity)]
    evidence = HERE / "evidence"
    official = json.loads((evidence / "lean_check.json").read_text())
    assert official["status"] == "success"
    assert official["exit_code"] == official["audit_exit_code"] == 0
    assert official["proof_holes"] == []
    assert official["source_sha256"] == digest(source) == digest(evidence / "Main.lean")
    assert official["statement_fidelity_sha256"] == digest(fidelity) == digest(
        evidence / "statement_fidelity.md"
    )
    certificates = []
    for claim in CLAIMS:
        archives = sorted((evidence / "certificates").glob(f"{claim}-*.json"))
        path = next(
            p for p in reversed(archives)
            if json.loads(p.read_text())["lean_check"]["source_sha256"] == before[0]
            and json.loads(p.read_text())["lean_check"]["statement_fidelity_sha256"] == before[1]
        )
        archive = json.loads(path.read_text())
        check = archive["lean_check"]
        assert check["status"] == "success"
        assert check["exit_code"] == check["audit_exit_code"] == 0
        assert check["proof_holes"] == []
        assert archive["lean_source"]["text"].encode() == source.read_bytes()
        certificates.append({
            "claim": claim, "path": str(path.relative_to(ROOT)), "sha256": digest(path),
            "proof_holes": [], "exit_code": 0, "audit_exit_code": 0,
        })
    version = subprocess.run(
        [LAKE, "env", "lean", "--version"], cwd=WORKSPACE,
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    assert "version 4.31.0," in version, version
    checks = []
    for label, command in (
        ("compile", [LAKE, "env", "lean", str(source)]),
        ("axiom_audit", [LAKE, "env", "lean", "--run", AUDIT, str(source)]),
    ):
        result = subprocess.run(command, cwd=WORKSPACE, capture_output=True, text=True)
        output = result.stdout + result.stderr
        (HERE / f"rerun_{label}.log").write_text(output)
        checks.append({"name": label, "command": command, "exit_code": result.returncode})
        if result.returncode:
            print(output)
            raise SystemExit(result.returncode)
    assert before == [digest(source), digest(fidelity)]
    assert not (HERE / "rerun_axiom_audit.log").read_text().strip(), (
        "The successful authoritative axiom auditor is normally silent; inspect any output."
    )
    report = {
        "claims": list(CLAIMS), "kind": "new_theorem",
        "role": "Engineer implementation, not independent Reviewer",
        "ts": datetime.now(timezone.utc).isoformat(),
        "scope": "Full literal promotion extraction, all gaps/marks, original-time "
        "partition, and a finite covering bounded-description hierarchy.",
        "lean_version": version, "source": str(source.relative_to(ROOT)),
        "source_sha256": before[0], "statement_fidelity_sha256": before[1],
        "composition": str((HERE / "composition.json").relative_to(ROOT)),
        "composition_sha256": digest(HERE / "composition.json"),
        "official_certificates": certificates,
        "proof_holes": [], "exit_code": 0, "audit_exit_code": 0,
        "warnings": official.get("warnings", []),
        "unchanged_during_verification": True,
        "checks": checks, "declarations": DECLARATIONS,
        "finite_job_or_depth_bound": None,
        "remaining_mathematical_bridge_obligations": [],
        "main_polynomial_algorithm_certified": False,
        "source_rule_preserved": "Exhausted switched final edge has r=|J|, h=|J|+1.",
        "guard_transformation_visible_and_every_theorem_recompiled": True,
        "original_natural_statements_preserved": True,
        "assumptions": [
            "Finite decidable job type.",
            "Strict transitive precedence with an injective compatible rank in 1..|J|.",
            "A feasible complete original-frame three-job-per-slot schedule.",
            "Local arbitrary-node results use the actual inductive RootedHistory; "
            "the root existence theorem has no history or invariant premise.",
        ],
        "retired_definitional_assumptions": ["A_MODEL", "A_HISTORY"],
        "independent_reviewer": "not performed; Host-owned",
        "nested_agents": False,
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(report, indent=2) + "\n")
    result = {
        "ok": True, "claims": list(CLAIMS), "proof_holes": [],
        "exit_code": 0, "audit_exit_code": 0,
    }
    (HERE / "verification_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
