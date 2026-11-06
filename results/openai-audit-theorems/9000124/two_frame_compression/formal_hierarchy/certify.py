#!/usr/bin/env python3
"""Certify both unchanged full claims, checking state after every mutation."""

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
PYTHON = "/home/argustest/zimo/argus-live-update/.venv/bin/python"
MATH_STATE = "argus_skill.verticals.math.math_state"
CLAIMS = ("C_TFC_PROTOCOL_EXTRACTION", "C_TFC_HISTORY")
MODEL_REASON = (
    "Definitions, not a missing theorem: the full-schedule, global strict "
    "precedence/rank, two-frame, sentinel and confined-reordering model is "
    "encoded in the standalone formal_hierarchy/Main.lean and recompiled. "
    "The existence theorem retains those precise model inputs; it does not "
    "assume a model-success, invariant or compression theorem."
)
HISTORY_REASON = (
    "Definitions, not a missing theorem: the literal center/normalization/"
    "priority/promotion/earliest-walk/carry/switch/pruning protocol is encoded "
    "in standalone formal_hierarchy/Main.lean. Run collects all promotions; "
    "Batch constructs all actual raw children and histories; thm_structure "
    "constructs the covering terminating hierarchy by cardinal induction. "
    "The switched final h=|J|+1 sentinel is explicitly encoded and recompiled. "
    "No protocol-success, list/boundary invariant or compression input remains."
)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def latest_claims():
    state = json.loads((ROOT / "research" / "MATH_STATE.json").read_text())
    return {
        claim: max(
            (c for c in state["claims"] if c["claim_id"] == claim),
            key=lambda c: c["version"],
        )
        for claim in CLAIMS
    }


def checked_mutation(label, command):
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    (HERE / f"{label}.log").write_text(result.stdout + result.stderr)
    checks = []
    for module in (MATH_STATE, "argus_skill.verticals.math.proof_graph_check"):
        cmd = [PYTHON, "-m", module, "check", "--project-root", str(ROOT)]
        check = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
        checks.append({
            "command": cmd, "exit_code": check.returncode,
            "stdout": check.stdout, "stderr": check.stderr,
        })
    report = {
        "command": command, "exit_code": result.returncode,
        "post_mutation_checks": checks,
    }
    (HERE / f"{label}.json").write_text(json.dumps(report, indent=2) + "\n")
    if result.returncode or any(c["exit_code"] for c in checks):
        raise RuntimeError(json.dumps(report, indent=2))
    return report


def main():
    subprocess.run([PYTHON, str(HERE / "compose.py"), "--check"], cwd=ROOT, check=True)
    source, fidelity = HERE / "Main.lean", HERE / "statement_fidelity.md"
    before = [digest(source), digest(fidelity)]
    initial = latest_claims()
    snapshot_path = HERE / "claim_snapshot.json"
    if snapshot_path.exists():
        snapshot = json.loads(snapshot_path.read_text())
        assert all(
            snapshot[c]["natural_statement"] == initial[c]["natural_statement"]
            for c in CLAIMS
        )
    else:
        snapshot = initial
        snapshot_path.write_text(json.dumps(snapshot, indent=2) + "\n")

    reports = []
    remaining = {
        a["assumption_id"] for a in initial["C_TFC_HISTORY"]["external_assumptions"]
    }
    retire = []
    for assumption, why in (("A_MODEL", MODEL_REASON), ("A_HISTORY", HISTORY_REASON)):
        if assumption in remaining:
            retire.extend(("--retire", f"{assumption}={why}"))
    if retire:
        reports.append(checked_mutation("retire_definitional_assumptions", [
            PYTHON, "-m", MATH_STATE, "revise-claim",
            "--project-root", str(ROOT), "--id", "C_TFC_HISTORY", *retire,
        ]))
    for claim in CLAIMS:
        reports.append(checked_mutation(f"certify_{claim}", [
            PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
            str(source.relative_to(ROOT)), "--statement-fidelity",
            str(fidelity.relative_to(ROOT)), "--claim", claim,
            "--project-root", str(ROOT), "--artifact-dir",
            str((HERE / "evidence").relative_to(ROOT)),
            "--lean-bin", "/home/argustest/.elan/bin/lean",
            "--lake-bin", "/home/argustest/.elan/bin/lake", "--lake",
        ]))
        assert before == [digest(source), digest(fidelity)]

    final = latest_claims()
    assert all(
        snapshot[c]["natural_statement"] == final[c]["natural_statement"]
        for c in CLAIMS
    )
    assert not final["C_TFC_HISTORY"]["external_assumptions"]
    report = {
        "claims": list(CLAIMS), "exit_code": 0,
        "source_sha256": before[0], "statement_fidelity_sha256": before[1],
        "source_and_fidelity_unchanged": before == [digest(source), digest(fidelity)],
        "original_natural_statements_preserved": True,
        "retirements_explain_encoded_definitions_not_unproved_inputs": True,
        "independent_reviewer": "not performed; Host-owned",
        "operations": reports,
    }
    (HERE / "certification_result.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
