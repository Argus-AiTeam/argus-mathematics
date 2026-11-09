"""Replay unchanged old subclaim checkers without writing to the old workspace."""

import json
import subprocess
import sys
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PYTHON = "$WORKSPACE/argus-latest/.venv/bin/python"
GEOMETRY = ROOT / "research/draft_reviews/surface-geometry/replay"


def run(command, output, timeout):
    started = time.monotonic()
    try:
        result = subprocess.run(
            command, cwd=ROOT, capture_output=True, text=True, timeout=timeout
        )
    except subprocess.TimeoutExpired as error:
        record = {
            "command": command,
            "cwd": str(ROOT),
            "exit_code": None,
            "timed_out": True,
            "stdout": str(error.stdout or ""),
            "stderr": str(error.stderr or ""),
            "interpretation": "Execution timeout, not a mathematical verdict.",
        }
        output.write_text(json.dumps(record, indent=2) + "\n")
        raise SystemExit(f"Replay timed out; partial output preserved at {output}")
    record = {
        "command": command,
        "cwd": str(ROOT),
        "python": sys.version,
        "exit_code": result.returncode,
        "timed_out": False,
        "stdout": result.stdout,
        "stderr": result.stderr,
        "duration_seconds": time.monotonic() - started,
    }
    output.write_text(json.dumps(record, indent=2) + "\n")
    return record


def main():
    replays = {}
    for unit in ("weighted-quotient", "surface-geometry"):
        directory = ROOT / "research/draft_reviews" / unit / "replay"
        record = run(
            [PYTHON, str(directory / "verify.py")],
            directory / "replay.json",
            120,
        )
        replays[unit] = record
        if record["exit_code"] != 0:
            raise SystemExit(f"Subclaim checker failed for {unit}; see replay.json")

    command = [
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(GEOMETRY / "Main.lean"),
        "--statement-fidelity", str(GEOMETRY / "statement_fidelity.md"),
        "--artifact-dir", str(GEOMETRY),
        "--claim", "S_MERIDIAN_KERNEL",
        "--project-root", str(ROOT),
        "--timeout", "120",
    ]
    lean = run(command, GEOMETRY / "lean_execution.json", 300)
    check_path = GEOMETRY / "lean_check.json"
    if not check_path.is_file():
        raise SystemExit("Official Lean verification produced no compiler record.")
    check = json.loads(check_path.read_text())
    lean_passed = (
        lean["exit_code"] == 0
        and check["status"] == "success"
        and check["exit_code"] == 0
        and check["audit_exit_code"] == 0
        and check["proof_holes"] == []
    )
    if not lean_passed:
        raise SystemExit("Lean replay is not verified; retain its actual recorded status.")

    gates = {}
    for name in ("math_state", "proof_graph_check"):
        gates[name] = run(
            [
                PYTHON, "-m", f"argus_skill.verticals.math.{name}", "check",
                "--project-root", str(ROOT),
            ],
            GEOMETRY / f"{name}_after_compile.json",
            30,
        )
    summary = {
        "project_root": str(ROOT),
        "subclaim_replay_exits": {
            unit: record["exit_code"] for unit, record in replays.items()
        },
        "lean_compile_exit": check["exit_code"],
        "lean_axiom_audit_exit": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "gate_exits": {name: record["exit_code"] for name, record in gates.items()},
        "whole_surface_kernel_verified": False,
    }
    (GEOMETRY / "replay_summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(summary, sort_keys=True))
    return 0 if all(record["exit_code"] == 0 for record in gates.values()) else 2


if __name__ == "__main__":
    raise SystemExit(main())
