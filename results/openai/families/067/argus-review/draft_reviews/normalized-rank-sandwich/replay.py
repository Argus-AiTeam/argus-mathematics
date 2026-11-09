#!/usr/bin/env python3
"""Replay only the completed certificate and its two checker tests."""

import json
import os
import platform
import subprocess
import sys
import time
from pathlib import Path

import numpy
import sympy


HERE = Path(__file__).resolve().parent
OLD = Path("campaigns/9000067")
AUDIT = OLD / "research/pseudoindex-five-audit"
ADAPTER_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
environment = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
environment.pop("PYTHONOPTIMIZE", None)
commands = {
    "verifier": [sys.executable, "-u", str(AUDIT / "verify.py")],
    "checker_tests": [sys.executable, str(AUDIT / "test_verify.py"), "-q"],
    "jacobian": [
        ADAPTER_PYTHON, "-m", "argus_skill.tools.jacobian", "run",
        "--operation", "polynomial.ideal.normal_form.compute",
        "--payload-file", str(HERE / "jacobian_payload.json"),
    ],
}
record = {
    "project_root": str(HERE.parents[2]),
    "read_only_old_workspace": str(OLD),
    "toolchain": {
        "executable": sys.executable,
        "python": platform.python_version(),
        "sympy": sympy.__version__,
        "numpy": numpy.__version__,
        "assertions_enabled": __debug__,
    },
    "runs": {},
}
for name, command in commands.items():
    started = time.monotonic()
    try:
        result = subprocess.run(
            command, cwd=OLD, env=environment, capture_output=True,
            text=True, timeout=90, check=False,
        )
    except subprocess.TimeoutExpired as error:
        record["runs"][name] = {
            "command": command, "timeout_seconds": 90, "timed_out": True,
            "stdout": (error.stdout or b"").decode() if isinstance(error.stdout, bytes) else error.stdout,
            "stderr": (error.stderr or b"").decode() if isinstance(error.stderr, bytes) else error.stderr,
        }
        break
    run = {
        "command": command, "cwd": str(OLD), "exit_code": result.returncode,
        "timed_out": False, "elapsed_seconds": round(time.monotonic() - started, 3),
        "stdout": result.stdout, "stderr": result.stderr,
    }
    if name in ("verifier", "jacobian") and result.returncode == 0:
        run["typed_output"] = json.loads(result.stdout)
    if name == "jacobian":
        (HERE / "jacobian_output.json").write_text(result.stdout, encoding="utf-8")
    record["runs"][name] = run
    if result.returncode != 0:
        break
(HERE / "replay.json").write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8")
print(json.dumps({
    name: {"exit_code": run.get("exit_code"), "timed_out": run["timed_out"]}
    for name, run in record["runs"].items()
}, sort_keys=True))
if len(record["runs"]) != len(commands) or any(
    run.get("exit_code") != 0 or run["timed_out"] for run in record["runs"].values()
):
    raise SystemExit(1)
