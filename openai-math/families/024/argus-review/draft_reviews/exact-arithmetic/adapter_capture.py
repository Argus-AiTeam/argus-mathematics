#!/usr/bin/env python3
"""Capture a bounded invocation of the authorized Jacobian adapter."""

import argparse
import json
import os
import subprocess
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent
ADAPTER = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "integer.compute.prime_factorization"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("stage", choices=["discovery", "contract", "run"])
    args = parser.parse_args()
    payload = HERE / "jacobian_payload.json"
    commands = {
        "discovery": ["find", "--query", "exact prime factorization of 360",
                      "--domain", "integer", "--limit", "3"],
        "contract": ["inspect", "--operation", OPERATION],
        "run": ["run", "--operation", OPERATION, "--payload-file", str(payload),
                "--timeout", "60"],
    }
    if args.stage == "run":
        if json.loads(payload.read_text()) != {"value": "360"}:
            raise AssertionError("the one authorized exact payload changed")
    command = [ADAPTER, "-m", "argus_skill.tools.jacobian", *commands[args.stage]]
    started = time.time()
    timeout = False
    error = None
    try:
        result = subprocess.run(
            command, cwd=HERE.parents[2], capture_output=True, text=True,
            timeout=90, env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
        )
        stdout, stderr, exit_code = result.stdout, result.stderr, result.returncode
    except subprocess.TimeoutExpired as exc:
        timeout = True
        error = "outer capture timeout after 90 seconds"
        stdout = exc.stdout or ""
        stderr = exc.stderr or ""
        if isinstance(stdout, bytes):
            stdout = stdout.decode(errors="replace")
        if isinstance(stderr, bytes):
            stderr = stderr.decode(errors="replace")
        exit_code = None
    except OSError as exc:
        stdout, stderr, exit_code = "", str(exc), None
        error = str(exc)

    (HERE / f"jacobian_{args.stage}.stdout").write_text(stdout)
    (HERE / f"jacobian_{args.stage}.stderr").write_text(stderr)
    try:
        body = json.loads(stdout)
        parse_error = None
    except json.JSONDecodeError as exc:
        body = {"raw_stdout": stdout}
        parse_error = str(exc)
    (HERE / f"jacobian_{args.stage}.json").write_text(json.dumps(body, indent=2) + "\n")
    typed_result = body.get("result") or {}
    typed_output = typed_result.get("output") or {}
    output_status = typed_output.get("status")
    adapter_error = body.get("error") or typed_result.get("error") or error
    capture = {
        "schema_version": 1,
        "stage": args.stage,
        "command": command,
        "cwd": str(HERE.parents[2]),
        "elapsed_seconds": round(time.time() - started, 3),
        "exit_code": exit_code,
        "stdout_file": f"jacobian_{args.stage}.stdout",
        "stderr_file": f"jacobian_{args.stage}.stderr",
        "response_file": f"jacobian_{args.stage}.json",
        "protocol_version": body.get("protocol_version"),
        "server": body.get("server"),
        "operation_id": typed_result.get("operation_id"),
        "typed_output_status": output_status,
        "adapter_error": adapter_error,
        "capture_error": error,
        "json_parse_error": parse_error,
        "timeout": timeout or output_status == "TIMEOUT",
        "unknown": output_status == "UNKNOWN",
        "bounded_run_is_conclusive": (
            args.stage == "run" and exit_code == 0 and output_status == "COMPLETE"
            and not timeout and adapter_error is None and parse_error is None
        ),
        "payload_file": "jacobian_payload.json" if args.stage == "run" else None,
        "scope": "one exact factorization of 360; no universal or analytic inference",
    }
    (HERE / f"jacobian_{args.stage}_status.json").write_text(
        json.dumps(capture, indent=2) + "\n"
    )
    print(json.dumps({
        "stage": args.stage, "exit_code": exit_code,
        "typed_output_status": output_status,
        "timeout": capture["timeout"], "adapter_error": adapter_error,
        "response_file": capture["response_file"],
    }))


if __name__ == "__main__":
    main()
