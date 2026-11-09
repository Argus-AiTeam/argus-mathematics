#!/usr/bin/env python3
"""Rerun the standalone kernel check and audit; no finite experiments."""

import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LAKE = "$WORKSPACE/.elan/bin/lake"
AUDIT = "$WORKSPACE/argus-live-update/argus_skill/tools/lean_axiom_audit.lean"
CLAIM = "C_TFC_RAW_CONSTRUCTION_INTEGRATION_LEAN"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    subprocess.run([sys.executable, str(HERE / "compose.py"), "--check"], cwd=ROOT, check=True)
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    evidence = HERE / "evidence"
    certified = json.loads((evidence / "lean_check.json").read_text())
    assert certified["status"] == "success"
    assert certified["exit_code"] == 0
    assert certified["audit_exit_code"] == 0
    assert certified["proof_holes"] == []
    assert certified["source_sha256"] == digest(source) == digest(evidence / "Main.lean")
    assert certified["statement_fidelity_sha256"] == digest(fidelity) == digest(
        evidence / "statement_fidelity.md"
    )
    certificates = sorted((evidence / "certificates").glob(f"{CLAIM}-*.json"))
    assert certificates
    archive_path = next(
        path for path in certificates
        if json.loads(path.read_text())["lean_check"]["source_sha256"] == digest(source)
    )
    archive = json.loads(archive_path.read_text())
    assert archive["lean_check"] == certified
    assert archive["lean_source"]["text"].encode() == source.read_bytes()
    version = subprocess.run(
        [LAKE, "env", "lean", "--version"], cwd=WORKSPACE,
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    assert "version 4.31.0," in version, version
    checks = []
    for name, command in (
        ("compile", [LAKE, "env", "lean", str(source)]),
        ("axiom_audit", [LAKE, "env", "lean", "--run", AUDIT, str(source)]),
    ):
        result = subprocess.run(command, cwd=WORKSPACE, capture_output=True, text=True)
        (HERE / f"rerun_{name}.log").write_text(result.stdout + result.stderr)
        checks.append({"name": name, "command": command, "exit_code": result.returncode})
        if result.returncode:
            print(result.stdout + result.stderr)
            raise SystemExit(result.returncode)
    report = {
        "claim": CLAIM,
        "kind": "new_theorem",
        "role": "Engineer implementation, not independent Reviewer",
        "ts": datetime.now(timezone.utc).isoformat(),
        "lean_version": version,
        "source": str(source.relative_to(ROOT)),
        "source_sha256": digest(source),
        "statement_fidelity_sha256": digest(fidelity),
        "official_certificate": str(archive_path.relative_to(ROOT)),
        "proof_holes": certified["proof_holes"],
        "exit_code": 0,
        "checks": checks,
        "main_theorem": "LiteralConstruction.RootedHistory.construction_integration",
        "remaining": [
            "Existence/extraction of all raw local schedule, priority, center, shared-cutoff "
            "separator and earliest-advance certificates from the complete literal protocol.",
            "Assembly and coverage of the full branching marked hierarchy.",
            "Independent Reviewer acceptance; C_TFC_HISTORY and the main scheduling theorem "
            "are not closed.",
        ],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(report, indent=2) + "\n")
    (HERE / "verification_result.json").write_text(
        json.dumps({"ok": True, "claim": CLAIM, "proof_holes": [], "exit_code": 0}, indent=2) + "\n"
    )
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
