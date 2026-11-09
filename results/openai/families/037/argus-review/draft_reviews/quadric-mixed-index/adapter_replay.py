#!/usr/bin/env python3
"""Capture exactly one bounded rank call through the required Jacobian adapter."""

import json
import os
import subprocess
import time
from pathlib import Path


UNIT = Path(__file__).resolve().parent
INTERPRETER = "$WORKSPACE/argus-live-update/.venv/bin/python"


def main():
    output_path = UNIT / "jacobian_output.json"
    exit_path = UNIT / "jacobian_exit.json"
    if output_path.exists() or exit_path.exists():
        raise RuntimeError("Existing run evidence: refusing an unchanged second adapter operation.")
    discovery = json.loads((UNIT / "jacobian_discovery.json").read_text())
    contract = json.loads((UNIT / "jacobian_contract.json").read_text())
    operation = contract["result"]["operation"]
    assert operation["operation_id"] == "matrix.rank.compute"
    assert operation["read_only"]
    assert any(
        card["operation_id"] == "matrix.rank.compute"
        for card in discovery["result"]["matches"]
    )
    payload_path = UNIT / "jacobian_payload.json"
    payload_path.write_bytes((UNIT / "archive" / "jacobian_payload.json").read_bytes())
    payload = json.loads(payload_path.read_text())
    entries = payload["matrix"]["entries"]
    assert payload["matrix"]["domain"] == "QQ"
    assert len(entries) == 15 and all(len(row) == 6 for row in entries)
    assert all(value["den"] == "1" and value["num"] in {"0", "1"}
               for row in entries for value in row)

    command = [
        INTERPRETER, "-m", "argus_skill.tools.jacobian", "run",
        "--operation", "matrix.rank.compute",
        "--payload-file", str(payload_path), "--timeout", "60",
    ]
    started = time.monotonic()
    error = ""
    timed_out = False
    returncode = None
    try:
        completed = subprocess.run(
            command, capture_output=True, timeout=100, check=False,
            env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
        )
        stdout, stderr = completed.stdout, completed.stderr
        returncode = completed.returncode
    except subprocess.TimeoutExpired as exc:
        stdout, stderr = exc.stdout or b"", exc.stderr or b""
        timed_out = True
        error = "Adapter process exceeded the outer 100-second bound."
    except OSError as exc:
        stdout, stderr = b"", b""
        error = str(exc)
    output_path.write_bytes(stdout)
    parsed = None
    try:
        parsed = json.loads(stdout)
        if parsed.get("error"):
            error = json.dumps(parsed["error"], sort_keys=True)
    except (ValueError, UnicodeDecodeError) as exc:
        error = error or f"Incomplete/non-JSON typed output: {exc}"
    if parsed is not None:
        (UNIT / "jacobian_server.json").write_text(
            json.dumps(parsed.get("server"), indent=2) + "\n"
        )
        (UNIT / "jacobian_protocol.json").write_text(json.dumps({
            "protocol_version": parsed.get("protocol_version"),
            "transport": parsed.get("transport"),
            "tool": parsed.get("tool"),
            "schema_version": parsed.get("schema_version"),
        }, indent=2) + "\n")
    (UNIT / "jacobian_stderr.json").write_text(json.dumps({
        "stderr": stderr.decode("utf-8", errors="replace"), "bytes": len(stderr),
    }, indent=2) + "\n")
    status = {
        "operation_id": "matrix.rank.compute",
        "command": command,
        "adapter_exit_code": returncode,
        "timeout": timed_out,
        "adapter_timeout_seconds": 60,
        "outer_timeout_seconds": 100,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "error": error,
        "stdout_is_complete_json": parsed is not None,
        "mathematical_operation_count": 1,
        "payload_shape": [15, 6],
    }
    exit_path.write_text(json.dumps(status, indent=2) + "\n")
    print(json.dumps(status, sort_keys=True))
    if returncode != 0 or timed_out or error:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
