#!/usr/bin/env python3
"""Bounded, read-only replays for the shared formal-core review."""

import argparse
from datetime import datetime, timezone
import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import time


OUT = Path(__file__).resolve().parent
CURRENT = OUT.parents[2]
OLD_ROOT = Path("campaigns/9000068")
OLD = OLD_ROOT / "research/toroidal_volume_audit"
LATEST = "$WORKSPACE/argus-latest/.venv/bin/python"
LEGACY = "$WORKSPACE/argus-live-update/.venv/bin/python"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean")
OPERATION = "matrix.symbolic.determinant.compute"
JACOBIAN = [LEGACY, "-m", "argus_skill.tools.jacobian"]
OLD_NAMES = [
    "Main.lean", "statement_fidelity.md", "verify.py", "compile.log",
    "exact_certificate.json", "jacobian_contract.json",
    "jacobian_execution.json", "jacobian_output.json", "jacobian_payload.json",
    "lean_check.json", "lean_submission.json", "lean_verification.json",
]


def dump(name, data):
    (OUT / name).write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def snapshot():
    paths = [OLD / name for name in OLD_NAMES]
    paths.extend(sorted((OLD / "certificates").glob("*.json")))
    return {
        str(path.relative_to(OLD)): {
            "sha256": sha(path),
            "size_bytes": path.stat().st_size,
            "mtime_ns": path.stat().st_mtime_ns,
        }
        for path in paths
    }


def capture(name, command, *, cwd=OUT, timeout=100, updates=None, input_bytes=None):
    if not 0 < timeout <= 110:
        raise ValueError("This runner only supports bounded synchronous commands")
    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    environment.update(updates or {})
    record = {
        "started_at": datetime.now(timezone.utc).isoformat(),
        "command": [str(part) for part in command],
        "command_shell": shlex.join([str(part) for part in command]),
        "cwd": str(cwd),
        "environment_overrides": {
            "PYTHONDONTWRITEBYTECODE": "1", **(updates or {})
        },
        "timeout_seconds": timeout,
        "capture_interpreter": sys.executable,
        "capture_interpreter_version": sys.version,
        "stdin_sha256": (
            hashlib.sha256(input_bytes).hexdigest() if input_bytes is not None else None
        ),
    }
    started = time.monotonic()
    try:
        result = subprocess.run(
            command, cwd=cwd, env=environment, input=input_bytes,
            capture_output=True, timeout=timeout, check=False,
        )
        record.update({
            "exit_code": result.returncode, "timeout": False,
            "stdout": result.stdout.decode("utf-8", errors="replace"),
            "stderr": result.stderr.decode("utf-8", errors="replace"),
            "adapter_error": None,
            "status": "success" if result.returncode == 0 else "nonzero_exit",
        })
    except subprocess.TimeoutExpired as exc:
        record.update({
            "exit_code": None, "timeout": True, "status": "timeout",
            "stdout": (exc.stdout or b"").decode("utf-8", errors="replace"),
            "stderr": (exc.stderr or b"").decode("utf-8", errors="replace"),
            "adapter_error": "subprocess deadline exceeded",
        })
    except OSError as exc:
        record.update({
            "exit_code": None, "timeout": False, "status": "launch_error",
            "stdout": "", "stderr": "",
            "adapter_error": f"{type(exc).__name__}: {exc}",
        })
    record["duration_seconds"] = round(time.monotonic() - started, 6)
    if record["stdout"].strip():
        try:
            typed = json.loads(record["stdout"])
        except json.JSONDecodeError:
            pass
        else:
            dump(name + ".json", typed)
            record["typed_output_file"] = name + ".json"
    dump(name + "_execution.json", record)
    print(json.dumps({
        "artifact": name + "_execution.json",
        "status": record["status"], "exit_code": record["exit_code"],
        "duration_seconds": record["duration_seconds"],
        "stdout": record["stdout"][:1200],
        "stderr": record["stderr"][:1200],
    }))
    return record


def initialize():
    dump("old_inputs_before.json", snapshot())
    index = load(CURRENT / "research/DRAFT_REVIEW_INDEX.json")
    versions = [
        entry for entry in index["claim_versions"]
        if entry.get("record", {}).get("claim_id") == "C_TV_FORMAL_CORE"
    ]
    failed = load(OLD / "certificates/C_TV_FORMAL_CORE-35e31b26e468f3fb.json")
    passed = load(OLD / "certificates/C_TV_FORMAL_CORE-65971c48af507c01.json")
    source = (OLD / "Main.lean").read_text(encoding="utf-8")
    before, after = failed["lean_source"]["text"], passed["lean_source"]["text"]
    dump("historical_comparison.json", {
        "claim_id": "C_TV_FORMAL_CORE",
        "versions_from_current_coverage_index": versions,
        "failed_evidence_id": failed["evidence_id"],
        "successful_evidence_id": passed["evidence_id"],
        "failed_status": failed["lean_check"]["status"],
        "failed_exit_code": failed["lean_check"]["exit_code"],
        "failed_stdout": failed["lean_check"]["stdout"],
        "failed_source_sha256": hashlib.sha256(before.encode()).hexdigest(),
        "successful_source_sha256": hashlib.sha256(after.encode()).hexdigest(),
        "current_source_sha256": sha(OLD / "Main.lean"),
        "successful_archive_equals_immutable_source": after == source,
        "same_statement_fidelity_text": (
            failed["statement_fidelity"]["text"] == passed["statement_fidelity"]["text"]
        ),
        "source_diff": list(difflib.unified_diff(
            before.splitlines(keepends=True), after.splitlines(keepends=True),
            fromfile="failed/Main.lean", tofile="successful/Main.lean",
        )),
        "declarations": [
            {"kind": kind, "name": name}
            for kind, name in re.findall(
                r"^(def|theorem)\s+([A-Za-z0-9_]+)", source, re.MULTILINE
            )
        ],
        "historical_records_are_current_evidence": False,
    })
    print("Saved baseline hashes and historical comparison.")


def discover():
    capture("jacobian_interpreter", [LEGACY, "--version"], timeout=5)
    capture("jacobian_status", JACOBIAN + ["status"], timeout=25)
    capture("jacobian_discovery", JACOBIAN + [
        "find", "--query",
        "exact symbolic determinant polynomial rational matrix coefficient",
        "--limit", "4",
    ], timeout=35)


def inspect():
    capture("jacobian_contract", JACOBIAN + [
        "inspect", "--operation", OPERATION
    ], timeout=40)


def verify():
    capture("verify_interpreter", [LATEST, "--version"], timeout=5)
    capture("verify_replay", [LATEST, str(OLD / "verify.py")],
            cwd=OLD_ROOT, timeout=100)


def lean():
    manifest_path = WORKSPACE / "lake-manifest.json"
    manifest = load(manifest_path)
    library_paths = [
        WORKSPACE / ".lake/packages" / package["name"] / ".lake/build/lib/lean"
        for package in manifest["packages"]
    ]
    library_paths = [path for path in library_paths if path.is_dir()]
    own_library = WORKSPACE / ".lake/build/lib/lean"
    if own_library.is_dir():
        library_paths.append(own_library)
    environment = {"LEAN_PATH": os.pathsep.join(map(str, library_paths))}
    source = (OLD / "Main.lean").read_bytes()
    mathlib = WORKSPACE / ".lake/packages/mathlib"
    mathlib_olean = mathlib / ".lake/build/lib/lean/Mathlib.olean"
    dump("lean_toolchain.json", {
        "workspace": str(WORKSPACE),
        "lean_toolchain": (WORKSPACE / "lean-toolchain").read_text().strip(),
        "workspace_manifest": manifest,
        "workspace_manifest_sha256": sha(manifest_path),
        "mathlib_manifest_revision": next(
            p["rev"] for p in manifest["packages"] if p["name"] == "mathlib"
        ),
        "mathlib_package_toolchain": (mathlib / "lean-toolchain").read_text().strip(),
        "mathlib_root_source_sha256": sha(mathlib / "Mathlib.lean"),
        "mathlib_root_olean_sha256": sha(mathlib_olean),
        "lean_executable": str(LEAN),
        "lean_executable_sha256": sha(LEAN),
        "library_paths": list(map(str, library_paths)),
        "source_path": str(OLD / "Main.lean"),
        "source_sha256": hashlib.sha256(source).hexdigest(),
        "source_size_bytes": len(source),
        "mode": "exact unmodified bytes on stdin; no Lake command or build",
        "revision_attestation": (
            "Installed workspace manifest and artifact hashes; no Git used, "
            "no independent rebuild or attestation of the dependency closure."
        ),
    })
    capture("lean_version", [str(LEAN), "--version"], cwd=WORKSPACE,
            timeout=5, updates=environment)
    capture("lean_stdin", [str(LEAN), "--stdin"], cwd=WORKSPACE,
            timeout=100, updates=environment, input_bytes=source)


def jacobian_run():
    payload_path = OUT / "jacobian_payload.json"
    if not payload_path.is_file():
        raise ValueError("An inspected dedicated payload is required")
    contract = load(OUT / "jacobian_contract.json")["result"]["operation"]
    payload = load(payload_path)
    if contract["operation_id"] != OPERATION or not contract["read_only"]:
        raise ValueError("Wrong inspected contract")
    if payload != load(OLD / "jacobian_payload.json"):
        raise ValueError("This review is restricted to the old symbolic identity")
    dump("jacobian_payload_binding.json", {
        "operation_id": OPERATION,
        "input_type": contract["input_schema"]["title"],
        "output_type": contract["output_schema"]["title"],
        "contract_file": "jacobian_contract.json",
        "contract_sha256": sha(OUT / "jacobian_contract.json"),
        "payload_file": "jacobian_payload.json",
        "payload_sha256": sha(payload_path),
        "historical_payload_sha256": sha(OLD / "jacobian_payload.json"),
        "payload_json_equals_historical": True,
        "payload_bytes_equal_historical": (
            payload_path.read_bytes() == (OLD / "jacobian_payload.json").read_bytes()
        ),
        "fit_assessment": (
            "The inspected request accepts a square 2x2 matrix with seven "
            "ordered variables, polynomial entries, denominator one, "
            "canonical coefficients +/-1, and determinant expansion of four "
            "terms with exponent at most one; all published bounds are met."
        ),
        "mathematical_subproblem": (
            "det([[t*a1+m1,t*a2+m2],[b1,b2]]) "
            "= t*a1*b2-t*a2*b1+m1*b2-m2*b1"
        ),
        "scope": "Coefficient/exponent identity only; no analytic request.",
    })
    execution = capture("jacobian_output", JACOBIAN + [
        "run", "--operation", OPERATION,
        "--payload-file", str(payload_path), "--timeout", "60",
    ], timeout=95)
    assessment = {
        "operation_id": OPERATION, "operation_invocations": 1,
        "adapter_exit_code": execution["exit_code"],
        "timeout": execution["timeout"],
        "adapter_error": execution["adapter_error"],
        "adapter_status": execution["status"],
        "conclusion": "non-conclusion",
    }
    if execution["status"] == "success" and execution.get("typed_output_file"):
        envelope = load(OUT / execution["typed_output_file"])
        assessment.update({
            "server": envelope.get("server"),
            "protocol_version": envelope.get("protocol_version"),
            "typed_error": envelope.get("error"),
        })
        result = envelope.get("result", {})
        determinant = result.get("output", {}).get("determinant")
        expected = {
            "domain": "QQ",
            "variables": ["t", "m1", "m2", "a1", "a2", "b1", "b2"],
            "numerator": {"terms": [
                {"coefficient": {"num": "1", "den": "1"},
                 "exponents": [1, 0, 0, 1, 0, 0, 1]},
                {"coefficient": {"num": "-1", "den": "1"},
                 "exponents": [1, 0, 0, 0, 1, 1, 0]},
                {"coefficient": {"num": "1", "den": "1"},
                 "exponents": [0, 1, 0, 0, 0, 0, 1]},
                {"coefficient": {"num": "-1", "den": "1"},
                 "exponents": [0, 0, 1, 0, 0, 1, 0]},
            ]},
            "denominator": {"terms": [
                {"coefficient": {"num": "1", "den": "1"},
                 "exponents": [0, 0, 0, 0, 0, 0, 0]}
            ]},
        }
        checks = {
            "operation_id_matches": result.get("operation_id") == OPERATION,
            "request_payload_matches": (
                envelope.get("request", {}).get("payload") == payload
            ),
            "no_typed_error": "error" not in envelope,
            "method_is_sympy_bareiss": (
                result.get("output", {}).get("method") == "SYMPY_BAREISS"
            ),
            "output_equals_direct_two_by_two_expansion": determinant == expected,
        }
        assessment["checks"] = checks
        assessment["server_runtime_ms"] = result.get("runtime_ms")
        if all(checks.values()):
            assessment["conclusion"] = "exact_two_by_two_identity_reproduced"
            assessment["determinant"] = (
                "t*a1*b2 - t*a2*b1 + m1*b2 - m2*b1"
            )
    assessment["limitations"] = [
        "Not an all-dimension proof; that proof is in the reviewed Lean source.",
        "No varieties, valuations, differential regularity or integrals checked.",
        "No claim about absent operations outside the four discovered cards.",
    ]
    dump("jacobian_assessment.json", assessment)
    print("Jacobian assessment:", assessment["conclusion"])


def finalize():
    before = load(OUT / "old_inputs_before.json")
    after = snapshot()
    dump("old_inputs_after.json", after)
    dump("immutability_check.json", {
        "scope": "The fourteen named input files, including both certificates",
        "file_count": len(before),
        "same_paths": set(before) == set(after),
        "content_size_and_mtime_unchanged": before == after,
        "changed": [
            key for key in sorted(set(before) | set(after))
            if before.get(key) != after.get(key)
        ],
        "old_ledger_not_read_directly": True,
        "old_ledger_read_by_mandated_verify_py": True,
        "limitation": "No claim of a whole-filesystem write audit.",
    })
    print("Input content, sizes and modification times unchanged:", before == after)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=[
        "initialize", "discover", "inspect", "verify", "lean", "jacobian_run", "finalize"
    ])
    action = parser.parse_args().action
    globals()[action]()
