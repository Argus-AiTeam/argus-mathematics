#!/usr/bin/env python3
"""Replay only the preserved checker's finite support, without Jacobian execution."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
ACTIVE = HERE.parents[3]
OLD = ACTIVE.parent / "9000048"
AUDIT = OLD / "research" / "algebraization_audit"


def main():
    if not sys.dont_write_bytecode:
        raise RuntimeError("Run with -B; the old workspace must remain read-only.")
    started = time.monotonic()
    files = ("verify.py", "exact_certificate.json", "verification_output.json",
             "negative_control_cli_output.json")
    before = {
        name: hashlib.sha256((AUDIT / name).read_bytes()).hexdigest()
        for name in files
    }
    namespace = {
        "__name__": "preserved_algebraization_support_read_only",
        "__file__": str(AUDIT / "verify.py"),
    }
    exec(compile((AUDIT / "verify.py").read_text(), str(AUDIT / "verify.py"),
                 "exec"), namespace)

    def forbidden_jacobian():
        raise RuntimeError("Jacobian execution is outside this unit's replay.")

    namespace["verify_jacobian"] = forbidden_jacobian
    certificate = json.loads((AUDIT / "exact_certificate.json").read_text())
    derived, constraints, targets = namespace["derive"]()
    assertions, inequalities = namespace["verify_assertions"](
        certificate, derived, constraints, targets)
    rejected = namespace["negative_controls"](
        certificate, derived, constraints, targets)

    corrupted = json.loads(json.dumps(certificate))
    corrupted["derived"]["orders"]["relation_error"] = "N"
    environment = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
    child = subprocess.run(
        [sys.executable, "-B", str(AUDIT / "verify.py"),
         "--certificate", "/dev/stdin"],
        input=json.dumps(corrupted), text=True, capture_output=True,
        cwd=HERE, env=environment, timeout=45, check=False,
    )
    response = json.loads(child.stdout)
    assert child.returncode == 1
    assert child.stderr == ""
    assert response == {
        "status": "failed",
        "error": "derived.orders.relation_error: asserted 'N', derived 'N + n'",
    }
    after = {
        name: hashlib.sha256((AUDIT / name).read_bytes()).hexdigest()
        for name in files
    }
    assert before == after
    assert (assertions, inequalities, len(rejected)) == (107, 13, 18)
    result = {
        "status": "passed",
        "review_role": "Engineer, not native independent Reviewer",
        "purpose": "Fresh finite-support execution because no applicable native "
                   "algebraization receipt accompanies the nominal reviewer labels.",
        "scope": namespace["SCOPE"],
        "initial_attempt": {
            "python_executable": "$WORKSPACE/argus-latest/.venv/bin/python",
            "outcome": "ModuleNotFoundError: No module named 'sympy'",
            "resolution": "Use the existing system Python with SymPy; install "
                          "nothing and invoke no Argus module.",
        },
        "python_executable": sys.executable,
        "python_version": sys.version,
        "sympy_version": namespace["sp"].__version__,
        "dont_write_bytecode": sys.dont_write_bytecode,
        "checker_execution": "Read, compile and execute preserved source in memory; "
                             "call derive, verify_assertions and negative_controls.",
        "derived_exact_assertions": assertions,
        "universal_inequality_certificates": inequalities,
        "corrupted_assertions_rejected": len(rejected),
        "negative_controls": rejected,
        "invalid_certificate_cli": {
            "command": [sys.executable, "-B", str(AUDIT / "verify.py"),
                        "--certificate", "/dev/stdin"],
            "exit_code": child.returncode,
            "response": response,
            "stderr": child.stderr,
            "jacobian_code_reached": False,
        },
        "jacobian_execution": False,
        "jacobian_note": "Historical typed artifacts were read, not rerun. "
                         "The parent owns any current adapter operation.",
        "old_input_sha256_before_and_after": before,
        "old_inputs_unchanged": before == after,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "kernel_verified": False,
        "general_theorem_verified_by_computation": False,
    }
    (HERE / "replay.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        key: result[key] for key in
        ("status", "derived_exact_assertions", "universal_inequality_certificates",
         "corrupted_assertions_rejected", "jacobian_execution", "elapsed_seconds")
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
