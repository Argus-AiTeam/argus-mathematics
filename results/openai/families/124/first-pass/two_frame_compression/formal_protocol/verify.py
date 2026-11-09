#!/usr/bin/env python3
"""Rerun the standalone Lean 4.31.0 proof and audit without mutating the ledger."""

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
CLAIM = "C_TFC_PROTOCOL_PREPARATION_LEAN"
DECLARATIONS = [
    "LiteralProtocol.root_preparation_exists",
    "LiteralProtocol.node_preparation_exists",
    "LiteralProtocol.shared_cutoff_walk",
    "LiteralProtocol.shared_cutoff_outside",
    "LiteralProtocol.ideal_center_exists",
    "LiteralProtocol.interval_priority_extension",
    "LiteralProtocol.normalized_sides_exists",
    "LiteralProtocol.initial_same_separator",
    "LiteralProtocol.initial_switched_separator",
    "LiteralProtocol.same_low_prefix",
    "LiteralProtocol.switched_low_prefix",
    "LiteralProtocol.next_same_cut_exists",
    "LiteralProtocol.next_switched_rank_exists",
    "LiteralProtocol.prepared_centers_certified",
]
REMAINING = [
    "Collect the complete finite O/X promotion sequence and all final positions, "
    "attained labels, and jointly indexed outgoing ExceptionWalk traces.",
    "Construct RawSameData / RawSwitchData for every nonempty gap, including "
    "the actual chronological switched Creation.",
    "Certify every internal mark, including marks bounding only empty gaps, "
    "in original root time.",
    "Prove deduplicated marks and gaps cover each parent and strictly decrease "
    "child cardinality; assemble a finite covering hierarchy by well-founded induction.",
    "Host-owned independent Reviewer acceptance. The full protocol and history "
    "claims remain open and unchanged.",
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    subprocess.run([sys.executable, str(HERE / "compose.py"), "--check"], cwd=ROOT, check=True)
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
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
    archives = sorted((evidence / "certificates").glob(f"{CLAIM}-*.json"))
    archive_path = next(
        path for path in archives
        if json.loads(path.read_text())["lean_check"]["source_sha256"] == digest(source)
    )
    archive = json.loads(archive_path.read_text())
    assert archive["lean_check"] == official
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
    assert before == [digest(source), digest(fidelity)]
    report = {
        "claim": CLAIM, "kind": "new_theorem",
        "role": "Engineer implementation, not independent Reviewer",
        "ts": datetime.now(timezone.utc).isoformat(),
        "scope": "Literal local protocol preparation and shared-cutoff existence; not full extraction",
        "lean_version": version, "source": str(source.relative_to(ROOT)),
        "source_sha256": digest(source),
        "statement_fidelity_sha256": digest(fidelity),
        "official_certificate": str(archive_path.relative_to(ROOT)),
        "official_certificate_sha256": digest(archive_path),
        "proof_holes": [], "exit_code": 0, "audit_exit_code": 0,
        "unchanged_during_verification": True,
        "checks": checks, "declarations": DECLARATIONS, "remaining": REMAINING,
        "C_TFC_HISTORY_closed": False,
        "C_TFC_PROTOCOL_EXTRACTION_closed": False,
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(report, indent=2) + "\n")
    (HERE / "verification_result.json").write_text(
        json.dumps({"ok": True, "claim": CLAIM, "proof_holes": [], "exit_code": 0}, indent=2) + "\n"
    )
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
