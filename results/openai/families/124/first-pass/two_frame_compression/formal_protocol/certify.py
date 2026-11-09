#!/usr/bin/env python3
"""Official scoped certification, with immediate post-mutation ledger checks."""

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_TFC_PROTOCOL_PREPARATION_LEAN"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    before = [digest(source), digest(fidelity)]
    command = [
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(source.relative_to(ROOT)),
        "--statement-fidelity", str(fidelity.relative_to(ROOT)),
        "--claim", CLAIM, "--project-root", str(ROOT),
        "--artifact-dir", str((HERE / "evidence").relative_to(ROOT)),
        "--lean-bin", "$WORKSPACE/.elan/bin/lean",
        "--lake-bin", "$WORKSPACE/.elan/bin/lake", "--lake",
    ]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    (HERE / "certification_command.log").write_text(result.stdout + result.stderr)
    checks = []
    for module in (
        "argus_skill.verticals.math.math_state",
        "argus_skill.verticals.math.proof_graph_check",
    ):
        cmd = [PYTHON, "-m", module, "check", "--project-root", str(ROOT)]
        check = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
        checks.append({
            "command": cmd, "exit_code": check.returncode,
            "stdout": check.stdout, "stderr": check.stderr,
        })
    unchanged = before == [digest(source), digest(fidelity)]
    report = {
        "claim": CLAIM, "command": command, "exit_code": result.returncode,
        "source_sha256": before[0], "statement_fidelity_sha256": before[1],
        "unchanged_during_verification": unchanged,
        "post_mutation_checks": checks,
    }
    (HERE / "certification_result.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    return 0 if unchanged and result.returncode == 0 and all(
        c["exit_code"] == 0 for c in checks
    ) else 1


if __name__ == "__main__":
    raise SystemExit(main())
