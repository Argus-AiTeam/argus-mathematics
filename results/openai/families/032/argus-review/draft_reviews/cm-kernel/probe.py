#!/usr/bin/env python3
"""Read-only preflight and bounded diagnostic of the old pinned CM replay."""

import json
import os
from pathlib import Path
import subprocess
import sys
import time


ROOT = Path(__file__).resolve().parents[3]
OLD = Path(json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())["old_workspace"])
AUDIT = OLD / "research/cm_dependency_audit"
OUT = Path(__file__).resolve().parent
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.34.1/bin/lean")
TARGET = "OAI.AlgebraicGeometry.HodgeConjecture.MainSolution"


def run(command, *, timeout, env=None, stdin=None):
    started = time.monotonic()
    try:
        result = subprocess.run(
            command, cwd=OUT, env=env, input=stdin, text=True,
            capture_output=True, timeout=timeout,
        )
        return {
            "command": command, "cwd": str(OUT), "stdin": stdin,
            "timeout_seconds": timeout, "timed_out": False,
            "exit_code": result.returncode, "stdout": result.stdout,
            "stderr": result.stderr,
            "elapsed_seconds": round(time.monotonic() - started, 3),
        }
    except subprocess.TimeoutExpired as error:
        return {
            "command": command, "cwd": str(OUT), "stdin": stdin,
            "timeout_seconds": timeout, "timed_out": True, "exit_code": None,
            "stdout": (error.stdout or b"").decode() if isinstance(error.stdout, bytes) else error.stdout or "",
            "stderr": (error.stderr or b"").decode() if isinstance(error.stderr, bytes) else error.stderr or "",
            "elapsed_seconds": round(time.monotonic() - started, 3),
        }


def main():
    manifest = json.loads((AUDIT / "source_manifest.json").read_text())
    dependencies = json.loads((AUDIT / "dependency_manifest.json").read_text())
    replay = json.loads((AUDIT / "upstream_replay.json").read_text())
    latest = {}
    with (AUDIT / "compiler_runs.jsonl").open() as journal:
        for line in journal:
            record = json.loads(line)
            latest[record["module"]] = record
    result = {
        "project_root": str(ROOT), "old_audit": str(AUDIT),
        "old_workspace_modified": False,
        "upstream_commit": manifest["commit"],
        "target_module": TARGET,
        "declared_toolchain": (AUDIT / "upstream/lean/lean-toolchain").read_text().strip(),
        "mathlib_revision": next(p["revision"] for p in dependencies if p["name"] == "mathlib"),
        "manifest_local_modules": len(manifest["modules"]),
        "manifest_external_modules": len(manifest["external_modules"]),
        "historical_build": {
            "exit_code": replay["exit_code"],
            "successful_modules": replay["successful_modules"],
            "total_modules": replay["total_modules"],
            "failure_count": len(replay["failures"]),
            "failure_modules": [p["module"] for p in replay["failures"]],
            "interpretation": "A stored incomplete build, not a live process or a theorem verdict.",
        },
        "journal": {
            "distinct_modules": len(latest),
            "latest_successful_modules": sum(p["exit_code"] == 0 for p in latest.values()),
            "latest_failed_modules": sum(p["exit_code"] != 0 for p in latest.values()),
            "target_record_present": TARGET in latest,
        },
        "required_artifacts": {
            str(p.relative_to(AUDIT)): p.is_file()
            for p in [
                AUDIT / "lean/Main.lean", AUDIT / "lean/lean_check.json",
                AUDIT / "exact_certificate.json",
                AUDIT / "replay/.lake/build/lib/lean/OAI/AlgebraicGeometry/HodgeConjecture/MainSolution.olean",
            ]
        },
        "historical_running_receipts": "Not queried or treated as live availability.",
    }
    source_program = (
        "import runpy,sys;"
        f"sys.path.insert(0,{str(AUDIT)!r});"
        f"v=runpy.run_path({str(AUDIT / 'verify.py')!r});"
        "m=v['check_sources']();"
        "print('source import closure and all recorded source digests match:',len(m['modules']))"
    )
    env = os.environ.copy()
    env["PYTHONDONTWRITEBYTECODE"] = "1"
    result["source_preflight"] = run(
        [sys.executable, "-B", "-c", source_program], timeout=85, env=env,
    )
    if not LEAN.is_file():
        result["compiler_diagnostic"] = {
            "status": "compiler_unavailable", "path": str(LEAN),
            "exit_code": None, "transitive_axioms": None,
        }
    else:
        result["compiler_version_probe"] = run([str(LEAN), "--version"], timeout=5)
        paths = [AUDIT / "replay/.lake/build/lib/lean"] + [
            AUDIT / p["directory"] / ".lake/build/lib/lean" for p in dependencies
        ]
        env["PATH"] = str(LEAN.parent) + os.pathsep + env["PATH"]
        env["LEAN_PATH"] = os.pathsep.join(map(str, paths))
        declaration = TARGET + ".hodge_conjecture_for_cm_abelian_varieties"
        program = (
            f"import {TARGET}\n"
            f"#check {declaration}\n"
            f"#print {declaration}\n"
            f"#print axioms {declaration}\n"
        )
        result["compiler_search_paths"] = [
            {"path": str(p), "is_directory": p.is_dir()} for p in paths
        ]
        result["compiler_diagnostic"] = run(
            [str(LEAN), "--trust=0", "-j1", "--stdin"],
            timeout=20, env=env, stdin=program,
        )
    diagnostic = result["compiler_diagnostic"]
    imported = diagnostic["exit_code"] == 0 and not diagnostic.get("timed_out", False)
    result["assessment"] = {
        "target_kernel_certificate": "present_but_not_accepted" if result["required_artifacts"]["exact_certificate.json"] else "absent",
        "elaborated_target_statement": "see_diagnostic_stdout" if imported else "not_obtained",
        "target_transitive_axioms": "see_diagnostic_stdout" if imported else "not_obtained",
        "formal_replay_status": "diagnostic_only_not_native_certification" if imported else "unverified",
        "mathematical_truth": "not_decided_by_build_or_import_failure",
        "geometric_statement_fidelity": "separate assessment in ../cm-applicability/report.md",
        "diagnostic_exit_code": diagnostic["exit_code"],
        "native_lean_evidence_record": "not_issued",
    }
    (OUT / "replay_probe.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "source_preflight_exit_code": result["source_preflight"]["exit_code"],
        "source_preflight_timed_out": result["source_preflight"]["timed_out"],
        "compiler_version": result.get("compiler_version_probe", {}).get("stdout", "").strip(),
        "compiler_diagnostic_exit_code": diagnostic["exit_code"],
        "historical_build": result["historical_build"],
        "journal": result["journal"], "assessment": result["assessment"],
        "output": str(OUT / "replay_probe.json"),
    }, indent=2))


if __name__ == "__main__":
    main()
