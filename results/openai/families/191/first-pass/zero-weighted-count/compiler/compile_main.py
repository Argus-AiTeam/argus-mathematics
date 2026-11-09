"""Reproduce the local Lean check without changing either external workspace."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "Main.lean"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LEAN = "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean"


def main():
    inherited = subprocess.check_output(
        ["lake", "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE, text=True
    ).strip()
    environment = dict(
        os.environ, LEAN_PATH=f"{HERE / 'upstream-olean'}:{inherited}"
    )
    command = [
        LEAN, "-j", "2", "--root", str(SOURCE.parent),
        "-o", str(HERE / "Main.olean"), "-i", str(HERE / "Main.ilean"), str(SOURCE),
    ]
    start = time.monotonic()
    result = subprocess.run(
        command, cwd=SOURCE.parent, env=environment, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
    )
    (HERE / "Main.compile.log").write_text(result.stdout)
    axiom_reports = [
        {"declaration": name, "axioms": re.findall(r"[\w.]+", axioms)}
        for name, axioms in re.findall(
            r"'([^']+)'\s+depends on axioms:\s*\[([^\]]*)\]", result.stdout
        )
    ]
    allowlist = {"propext", "Classical.choice", "Quot.sound"}
    unexpected = sorted(
        {a for report in axiom_reports for a in report["axioms"]} - allowlist
    )
    principal_checked = any(
        item["declaration"] == "ZeroWeightedCount.manuscript_zero_count"
        for item in axiom_reports
    )
    report = {
        "exit_code": result.returncode,
        "elapsed_seconds": round(time.monotonic() - start, 3),
        "source": str(SOURCE),
        "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        "compiler_version": subprocess.check_output([LEAN, "--version"], text=True).strip(),
        "compiler_command": command,
        "lean_path": environment["LEAN_PATH"],
        "log": str(HERE / "Main.compile.log"),
        "axiom_reports": axiom_reports,
        "unexpected_axioms": unexpected,
        "principal_axioms_checked": principal_checked,
        "official_lean_evidence": False,
    }
    (HERE / "Main.compile.json").write_text(json.dumps(report, indent=2) + "\n")
    print(result.stdout)
    print(json.dumps({"exit_code": result.returncode, "unexpected_axioms": unexpected}))
    return result.returncode or bool(unexpected) or not principal_checked


if __name__ == "__main__":
    raise SystemExit(main())
