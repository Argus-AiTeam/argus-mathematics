#!/usr/bin/env python3
"""Bounded, isolated replay of the archived family013 algebra evidence."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time


OWN = Path(__file__).resolve().parent
ROOT = OWN.parents[2]
REPLAY = OWN / "replay"
PYTHON = "$WORKSPACE/argus-latest/.venv/bin/python"
CLAIM = "C_REVIEW_ALG_013"
COPIED_INPUTS = (
    "Main.lean",
    "statement_fidelity.md",
    "verify.py",
    "exact_certificate.json",
    "lean_verify_output.json",
    "jacobian_result.json",
)


def save(name, value):
    (OWN / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def digests():
    return {
        name: hashlib.sha256((REPLAY / name).read_bytes()).hexdigest()
        for name in COPIED_INPUTS
        if (REPLAY / name).exists()
    }


def capture(command, stdout_name, stderr_name, *, cwd=ROOT, timeout=30, data=None, env=None):
    started = time.monotonic()
    timed_out = False
    try:
        result = subprocess.run(
            command, cwd=cwd, input=data, text=True, capture_output=True,
            timeout=timeout, env=env,
        )
        exit_code, stdout, stderr = result.returncode, result.stdout, result.stderr
    except subprocess.TimeoutExpired as error:
        timed_out = True
        exit_code = None
        stdout = error.stdout or ""
        stderr = error.stderr or ""
        if isinstance(stdout, bytes):
            stdout = stdout.decode(errors="replace")
        if isinstance(stderr, bytes):
            stderr = stderr.decode(errors="replace")
    (OWN / stdout_name).write_text(stdout)
    (OWN / stderr_name).write_text(stderr)
    return {
        "command": command, "cwd": str(cwd), "exit_code": exit_code,
        "timed_out": timed_out, "timeout_seconds": timeout,
        "duration_seconds": round(time.monotonic() - started, 3),
        "stdout": stdout_name, "stderr": stderr_name,
    }


def checks(stage):
    results = {}
    for label, module in (
        ("math_state", "argus_skill.verticals.math.math_state"),
        ("proof_graph", "argus_skill.verticals.math.proof_graph_check"),
    ):
        results[label] = capture(
            [PYTHON, "-m", module, "check", "--project-root", str(ROOT)],
            f"{stage}_{label}_check.txt", f"{stage}_{label}_check.stderr.log",
        )
    payload = {"project_root": str(ROOT), "checks": results}
    save(f"{stage}_structural_checks.json", payload)
    return payload


def formal():
    before = digests()
    source = REPLAY / "Main.lean"
    fidelity = REPLAY / "statement_fidelity.md"
    result = capture(
        [
            PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
            str(source), "--statement-fidelity", str(fidelity),
            "--project-root", str(ROOT), "--claim", CLAIM, "--timeout", "90",
        ],
        "lean_verify_output.current.json", "lean_verify_output.current.stderr.log",
        cwd=OWN, timeout=220,
    )
    try:
        output = json.loads((OWN / result["stdout"]).read_text())
    except (ValueError, OSError):
        output = {}
    recorded = output.get("kernel", {}).get("recorded") or {}
    after = digests()
    verified = (
        result["exit_code"] == 0
        and output.get("status") == "success"
        and output.get("exit_code") == 0
        and output.get("audit_exit_code") == 0
        and output.get("proof_holes") == []
        and recorded.get("subject", {}).get("subject_id") == CLAIM
        and recorded.get("tier") == "mechanical"
        and recorded.get("verdict") == "supports"
        and output.get("source_sha256") == before.get("Main.lean")
        and output.get("statement_fidelity_sha256") == before.get("statement_fidelity.md")
        and before == after
    )
    dependencies = None
    if verified:
        names = re.findall(r"^theorem\s+(\w+)", source.read_text(), re.MULTILINE)
        query = source.read_text() + "\n" + "\n".join(
            f"#print axioms TreeComparison.{name}" for name in names
        ) + "\n"
        lake = output["tools"]["lake"]["path"]
        dependencies = capture(
            [lake, "env", "lean", "--stdin"],
            "axiom_dependencies.log", "axiom_dependencies.stderr.log",
            cwd=Path(output["lake_workspace"]), timeout=60, data=query,
        )
        dependencies["declarations"] = [f"TreeComparison.{name}" for name in names]
        dependencies["stdin"] = "Unchanged Main.lean followed only by #print axioms commands."
        dependencies["created_additional_lean_file"] = False
    else:
        source.unlink(missing_ok=True)
    structural = checks("after_lean")
    payload = {
        "project_root": str(ROOT), "claim": CLAIM, "official_verification": result,
        "verified_no_holes": verified, "copied_input_sha256_before": before,
        "copied_input_sha256_after_compilation": after,
        "source_and_fidelity_unchanged": before == after,
        "copied_lean_deleted_on_failure": not verified,
        "axiom_dependency_query": dependencies, "structural_checks": structural,
        "certificate": recorded.get("artifact"),
        "evidence_id": recorded.get("evidence_id"),
        "claim_content_hash": recorded.get("subject", {}).get("content_hash"),
    }
    save("formal_replay_result.json", payload)
    print(json.dumps(payload, sort_keys=True))
    return 0 if verified else 1


def exact():
    if sys.flags.optimize:
        raise RuntimeError("The archived checker requires active Python assertions.")
    base_site = (
        Path(sys.base_prefix) / "lib"
        / f"python{sys.version_info.major}.{sys.version_info.minor}" / "site-packages"
    )
    sys.path.append(str(base_site))
    import mpmath
    import sympy

    before = digests()
    env = os.environ.copy()
    env["PYTHONDONTWRITEBYTECODE"] = "1"
    env["PYTHONOPTIMIZE"] = "0"
    env["PYTHONPATH"] = str(base_site)
    command = [PYTHON, str(REPLAY / "verify.py")]
    result = capture(
        command, "exact_checker.stdout.log", "exact_checker.stderr.log",
        cwd=OWN, timeout=300, env=env,
    )
    after = digests()
    old = json.loads((REPLAY / "exact_certificate.json").read_text())
    try:
        stdout = json.loads((OWN / result["stdout"]).read_text())
    except ValueError:
        stdout = {}
    diagrams = old["finite_diagram_diagnostics"]
    paired = old["finite_paired_diagnostics"]
    counts = {
        "universal_polynomial_identities": len(old["universal_polynomial_identities"]),
        "rational_budget_assert_statements": 12,
        "rational_budget_scalar_inequalities": 14,
        "field_fiber_cases": len(old["finite_fiber_diagnostics"]),
        "diagram_parameter_cases": len(diagrams),
        "leaf_tuple_occurrences": sum(d["leaf_tuples"] for d in diagrams),
        "valid_tuple_occurrences": sum(d["valid_tuples"] for d in diagrams),
        "invalid_zero_reconstruction_occurrences": sum(
            d["invalid_zero_reconstruction"] for d in diagrams
        ),
        "function_conjugation_cases": sum(d["function_conjugation_cases"] for d in diagrams),
        "quartet_sign_lift_checks": sum(d["quartet_sign_lift_checks"] for d in diagrams),
        "paired_parameter_cases": len(paired),
        "paired_partition_cases": sum(d["paired_partition_cases"] for d in paired),
    }
    success = (
        result["exit_code"] == 0
        and stdout == {
            "ok": True, "universal_identities": 9, "diagram_cases": 20,
            "paired_cases": 259, "full_analytic_proof_review": "pending",
        }
        and before == after
    )
    payload = {
        "ok": success, "execution": result, "stdout_summary": stdout,
        "python": sys.version, "interpreter": PYTHON,
        "assertions_active": True, "sympy": sympy.__version__,
        "mpmath": mpmath.__version__, "dependency_site": str(base_site),
        "sympy_path": sympy.__file__, "mpmath_path": mpmath.__file__,
        "no_dependency_installation": True, "write_certificate_flag_used": False,
        "copied_input_sha256_before": before, "copied_input_sha256_after": after,
        "all_copied_inputs_unchanged": before == after,
        "counts": counts, "rational_budgets": old["universal_rational_budgets"],
        "field_fiber_results": old["finite_fiber_diagnostics"],
        "diagram_parameter_results": diagrams, "paired_results": paired,
        "bounds_enlarged": False,
        "metadata_boundary": (
            "The unchanged checker compares the unchanged exact_certificate.json "
            "using copied archival lean_verify_output.json and jacobian_result.json. "
            "It does not freshly verify Lean or invoke Jacobian. Fresh official Lean "
            "verification is recorded separately for C_REVIEW_ALG_013."
        ),
    }
    save("exact_replay_result.json", payload)
    print(json.dumps({"ok": success, "counts": counts}, sort_keys=True))
    return 0 if success else 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("formal", "exact", "checks"))
    parser.add_argument("--stage", default="after_registration")
    args = parser.parse_args()
    if args.operation == "formal":
        return formal()
    if args.operation == "exact":
        return exact()
    result = checks(args.stage)
    print(json.dumps(result, sort_keys=True))
    return int(any(r["exit_code"] != 0 for r in result["checks"].values()))


if __name__ == "__main__":
    raise SystemExit(main())
