#!/usr/bin/env python3
"""Register only the new scoped claim, then immediately validate both ledgers."""

import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
PYTHON = "/home/argustest/zimo/argus-live-update/.venv/bin/python"
CLAIM = "C_TFC_PROTOCOL_PREPARATION_LEAN"


def main():
    command = [
        PYTHON, "-m", "argus_skill.verticals.math.math_state", "claim",
        "--project-root", str(ROOT), "--id", CLAIM, "--context", "CTX_TFC",
        "--statement", (HERE / "claim_statement.txt").read_text().strip(),
        "--formal-file", str(HERE / "Main.lean"),
    ]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
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
    report = {
        "claim": CLAIM, "exit_code": result.returncode,
        "stdout": result.stdout, "stderr": result.stderr,
        "post_mutation_checks": checks,
    }
    (HERE / "claim_registration.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({
        "claim": CLAIM, "exit_code": result.returncode,
        "post_mutation_checks": checks,
        "full_registration": str(HERE / "claim_registration.json"),
    }, indent=2))
    return 0 if result.returncode == 0 and all(c["exit_code"] == 0 for c in checks) else 1


if __name__ == "__main__":
    raise SystemExit(main())
