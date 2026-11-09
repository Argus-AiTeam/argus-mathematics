"""Output-only, single-attempt adapter for the preserved verifier's compute()."""

import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import platform
import runpy
import subprocess
import sys
import time


sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
OLD = Path("campaigns/9000049")
CORE = OLD / "research/stable_core_certificate"
SOURCE = Path(
    "openai-math/preprints/"
    "An-explicit-noncoordinate-polynomial-with-affine-three-space-zero-fibre-"
    "September-24-2026/build/paper.tex"
)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def now():
    return datetime.now(timezone.utc).isoformat()


def worker(output):
    namespace = runpy.run_path(str(CORE / "verify.py"), run_name="preserved_verifier")
    result = namespace["compute"]()
    with output.open("x") as stream:
        stream.write(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(
        f"PASS: {result['check_count']} exact checks from unchanged compute(); "
        "preserved main() was not called."
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    output = args.output.resolve()
    if output != HERE / "exact_replay.json":
        parser.error("--output must be this review unit's exact_replay.json")
    if args.worker:
        worker(output)
        return 0

    receipt = HERE / "exact_replay_run.json"
    stdout_path = HERE / "exact_replay.stdout"
    stderr_path = HERE / "exact_replay.stderr"
    for path in (output, receipt, stdout_path, stderr_path):
        if path.exists():
            parser.error(f"single-attempt evidence already exists: {path}")

    inputs = [
        CORE / name
        for name in (
            "verify.py", "exact_certificate.json", "jacobian_request.json",
            "jacobian_result.json", "jacobian_contract.json", "report.md", "Main.lean",
        )
    ] + [
        OLD / "research/MATH_STATE.json",
        OLD / "research/PROOF_GRAPH.json",
        SOURCE,
        Path("campaigns/9100049/MANUSCRIPTS.json"),
    ]
    before = {str(path): digest(path) for path in inputs}
    command = [
        sys.executable, str(Path(__file__).resolve()),
        "--output", str(output), "--worker",
    ]
    record = {
        "state": "running",
        "started_at": now(),
        "outer_command": [sys.executable, str(Path(__file__).resolve()), "--output", str(output)],
        "bounded_child_command": command,
        "cwd": str(ROOT),
        "environment_overrides": {"PYTHONDONTWRITEBYTECODE": "1"},
        "timeout_seconds": 110,
        "python_executable": sys.executable,
        "python_version": sys.version,
        "platform": platform.platform(),
        "dependencies": {
            name: importlib.metadata.version(name) for name in ("sympy", "mpmath")
        },
        "adapter_sha256": digest(Path(__file__)),
        "input_sha256_before": before,
        "original_main_executed": False,
        "mathematical_implementation": "unchanged preserved verify.py compute()",
        "fresh_jacobian_operation_executed": False,
    }
    receipt.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
    start = time.monotonic()
    try:
        completed = subprocess.run(
            command, cwd=ROOT, env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
            capture_output=True, text=True, timeout=110,
        )
        stdout, stderr = completed.stdout, completed.stderr
        record["child_exit_code"] = completed.returncode
        record["state"] = "completed" if completed.returncode == 0 else "failed"
    except subprocess.TimeoutExpired as exc:
        stdout, stderr = exc.stdout or "", exc.stderr or ""
        if isinstance(stdout, bytes):
            stdout = stdout.decode(errors="replace")
        if isinstance(stderr, bytes):
            stderr = stderr.decode(errors="replace")
        record.update(state="timeout_nonconclusion", child_exit_code=None)
    record["elapsed_seconds"] = time.monotonic() - start
    record["finished_at"] = now()
    stdout_path.write_text(stdout)
    stderr_path.write_text(stderr)
    record["stdout_file"] = str(stdout_path)
    record["stderr_file"] = str(stderr_path)
    after = {str(path): digest(path) for path in inputs}
    record["input_sha256_after"] = after
    record["preserved_inputs_unchanged"] = before == after
    if output.exists():
        fresh = json.loads(output.read_text())
        old = json.loads((CORE / "exact_certificate.json").read_text())
        old_checks, new_checks = old["checks"], fresh["checks"]
        record["comparison"] = {
            "entire_certificate_equal_by_contents": fresh == old,
            "ordered_check_list_equal_by_contents": new_checks == old_checks,
            "certificate_bytes_equal": output.read_bytes() == (CORE / "exact_certificate.json").read_bytes(),
            "old_declared_count": old["check_count"],
            "new_declared_count": fresh["check_count"],
            "actual_old_count": len(old_checks),
            "actual_new_count": len(new_checks),
            "new_names": [check["name"] for check in new_checks],
            "changed_check_indices": [
                i for i in range(max(len(old_checks), len(new_checks)))
                if i >= len(old_checks) or i >= len(new_checks)
                or old_checks[i] != new_checks[i]
            ],
            "check_kind_counts": dict(Counter(check["kind"] for check in new_checks)),
        }
        record["output_sha256"] = digest(output)
    passed = (
        record["state"] == "completed"
        and record["preserved_inputs_unchanged"]
        and record.get("comparison", {}).get("entire_certificate_equal_by_contents") is True
        and record["comparison"]["actual_new_count"] == 81
    )
    record["adapter_exit_code"] = 0 if passed else 124 if record["state"] == "timeout_nonconclusion" else 1
    receipt.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
    print(stdout, end="")
    print(stderr, end="", file=sys.stderr)
    print(f"state={record['state']}; evidence={receipt}; adapter_exit_code={record['adapter_exit_code']}")
    return record["adapter_exit_code"]


if __name__ == "__main__":
    raise SystemExit(main())
