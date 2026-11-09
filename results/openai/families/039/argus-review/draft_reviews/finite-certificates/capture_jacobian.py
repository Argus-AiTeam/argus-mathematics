#!/usr/bin/env python3
"""Capture a single explicitly selected Jacobian adapter step."""

import argparse
import hashlib
import json
import os
import shlex
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


LOCAL = Path(__file__).resolve().parent
PROJECT = LOCAL.parents[2]
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "prime_field.matrix.rank.compute"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--step", choices=("find", "inspect", "run"), required=True)
    args = parser.parse_args()
    command = [PYTHON, "-m", "argus_skill.tools.jacobian", args.step]
    if args.step == "find":
        command += ["--query", "matrix rank over a prime finite field", "--limit", "3"]
    elif args.step == "inspect":
        command += ["--operation", OPERATION]
    else:
        command += [
            "--operation", OPERATION,
            "--payload-file", str(LOCAL / "jacobian_payload.json"),
            "--timeout", "45",
        ]
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
    toolchain = subprocess.run(
        [PYTHON, "-c", "import json,platform,sys; print(json.dumps({'executable':sys.executable,'version':sys.version,'implementation':platform.python_implementation(),'optimize':sys.flags.optimize,'dont_write_bytecode':sys.dont_write_bytecode}))"],
        cwd=PROJECT, env=env, stdin=subprocess.DEVNULL, capture_output=True, text=True, timeout=15, check=True,
    )
    metadata = {
        "step": args.step,
        "state": "running",
        "command_argv": command,
        "command": shlex.join(command),
        "cwd": str(PROJECT),
        "started_at": datetime.now(timezone.utc).isoformat(),
        "python_toolchain": json.loads(toolchain.stdout),
        "PYTHONDONTWRITEBYTECODE": "1",
        "process_timeout_seconds": 75,
        "operation_id": OPERATION if args.step != "find" else None,
    }
    status_path = LOCAL / f"jacobian_{args.step}_status.json"
    status_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    started = time.monotonic()
    timeout = False
    try:
        process = subprocess.run(
            command, cwd=PROJECT, env=env, stdin=subprocess.DEVNULL,
            capture_output=True, timeout=75,
        )
        stdout, stderr, exit_code = process.stdout, process.stderr, process.returncode
    except subprocess.TimeoutExpired as exc:
        timeout = True
        stdout, stderr, exit_code = exc.stdout or b"", exc.stderr or b"", 124
    (LOCAL / f"jacobian_{args.step}.json").write_bytes(stdout)
    (LOCAL / f"jacobian_{args.step}_stderr.txt").write_bytes(stderr)
    try:
        structured = json.loads(stdout)
        json_error = None
    except (ValueError, UnicodeDecodeError) as exc:
        structured = None
        json_error = str(exc)
    metadata.update({
        "state": "timed_out" if timeout else ("completed" if exit_code == 0 else "failed"),
        "adapter_exit_code": exit_code,
        "timeout": timeout,
        "finished_at": datetime.now(timezone.utc).isoformat(),
        "duration_seconds": time.monotonic() - started,
        "stdout_bytes": len(stdout),
        "stderr_bytes": len(stderr),
        "stdout_json_parse_error": json_error,
        "structured_error": structured.get("error") if isinstance(structured, dict) else None,
        "protocol_version": structured.get("protocol_version") if isinstance(structured, dict) else None,
        "server": structured.get("server") if isinstance(structured, dict) else None,
    })
    if args.step == "run":
        payload_bytes = (LOCAL / "jacobian_payload.json").read_bytes()
        metadata["payload"] = json.loads(payload_bytes)
        metadata["payload_sha256"] = hashlib.sha256(payload_bytes).hexdigest()
    status_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps({key: metadata[key] for key in ("step", "state", "adapter_exit_code", "timeout", "duration_seconds", "protocol_version")}, sort_keys=True))
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
