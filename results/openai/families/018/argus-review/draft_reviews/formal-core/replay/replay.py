from __future__ import annotations

import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time


REPLAY = Path(__file__).resolve().parent
ROOT = REPLAY.parents[3]
PYTHON = "$WORKSPACE/argus-latest/.venv/bin/python"
MATHLIB = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean")


def save(name: str, data: object) -> None:
    (REPLAY / name).write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )


def environment() -> dict[str, str]:
    env = os.environ.copy()
    env.update(
        PYTHONDONTWRITEBYTECODE="1",
        ARGUS_SKILL_HOME=str(REPLAY / "runtime"),
        ARGUS_SKILL_PROJECT_ROOT=str(ROOT),
        ARGUS_SKILL_MATHLIB_WORKSPACE=str(MATHLIB),
        XDG_CACHE_HOME=str(REPLAY / "cache"),
        TMPDIR=str(REPLAY / "scratch"),
        GIT_DIR=str(REPLAY / "unavailable-repository"),
        GIT_CONFIG_NOSYSTEM="1",
        GIT_CONFIG_GLOBAL="/dev/null",
    )
    manifest = json.loads((MATHLIB / "lake-manifest.json").read_text())
    libraries = [
        MATHLIB / manifest["packagesDir"] / package["name"] / ".lake/build/lib/lean"
        for package in manifest["packages"]
    ]
    libraries.append(MATHLIB / ".lake/build/lib/lean")
    if not (libraries[0] / "Mathlib.olean").is_file():
        raise RuntimeError("The probed Mathlib import is no longer available")
    if not LEAN.is_file():
        raise RuntimeError("The probed Lean/library installation changed")
    env["LEAN_PATH"] = os.pathsep.join(str(path) for path in libraries if path.is_dir())
    return env


def capture(
    command: list[str], name: str, *, timeout: float, input_text: str | None = None
) -> dict[str, object]:
    started = time.monotonic()
    process = subprocess.run(
        command,
        cwd=ROOT,
        env=environment(),
        input=input_text,
        capture_output=True,
        text=True,
        timeout=timeout,
        check=False,
    )
    (REPLAY / f"{name}.stdout").write_text(process.stdout, encoding="utf-8")
    (REPLAY / f"{name}.stderr").write_text(process.stderr, encoding="utf-8")
    record = {
        "command": command,
        "cwd": str(ROOT),
        "exit_code": process.returncode,
        "duration_seconds": round(time.monotonic() - started, 3),
        "stdout": f"{name}.stdout",
        "stderr": f"{name}.stderr",
    }
    save(f"{name}.json", record)
    return record


def checks(phase: str) -> dict[str, object]:
    records = {}
    for module in ("math_state", "proof_graph_check"):
        command = [
            PYTHON,
            "-B",
            "-m",
            f"argus_skill.verticals.math.{module}",
            "check",
            "--project-root",
            str(ROOT),
        ]
        records[module] = capture(command, f"{phase}_{module}", timeout=60)
    save(f"{phase}_checks.json", records)
    return records


def verify() -> int:
    source = REPLAY / "Main.lean"
    fidelity = REPLAY / "statement_fidelity.md"
    env = environment()
    manifest = json.loads((MATHLIB / "lake-manifest.json").read_text())
    save(
        "toolchain_context.json",
        {
            "workspace": str(MATHLIB),
            "workspace_toolchain": (MATHLIB / "lean-toolchain").read_text().strip(),
            "mathlib_manifest_entry": next(
                package for package in manifest["packages"] if package["name"] == "mathlib"
            ),
            "lean_binary": str(LEAN),
            "lean_path": env["LEAN_PATH"].split(os.pathsep),
            "compilation_mode": "bare Lean with existing built library paths; no Lake build",
            "manifest_revision_is_not_a_git_checkout_attestation": True,
            "no_reference_tree_writes": True,
        },
    )
    command = [
        PYTHON,
        "-B",
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        str(source),
        "--statement-fidelity",
        str(fidelity),
        "--artifact-dir",
        str(REPLAY),
        "--claim",
        "R_FORMAL",
        "--project-root",
        str(ROOT),
        "--timeout",
        "450",
        "--no-lake",
        "--lean-bin",
        str(LEAN),
    ]
    invocation = capture(command, "verify_invocation", timeout=1020)
    payload = json.loads((REPLAY / "verify_invocation.stdout").read_text())
    save("verify_result.json", payload)
    ledger_checks = checks("after_verify")
    successful = (
        invocation["exit_code"] == 0
        and payload.get("status") == "success"
        and payload.get("exit_code") == 0
        and payload.get("audit_exit_code") == 0
        and not payload.get("proof_holes")
        and payload.get("kernel", {}).get("recorded") is not None
    )
    axioms = None
    if successful:
        text = source.read_text(encoding="utf-8")
        names = re.findall(r"^(?:abbrev|def|theorem) ([A-Za-z_][A-Za-z0-9_]*)", text, re.M)
        queries = "\n".join(f"#print axioms ExactTransitivity.{name}" for name in names)
        axioms = capture(
            [str(LEAN), "--stdin"],
            "kernel_axioms",
            timeout=180,
            input_text=text + "\n" + queries + "\n",
        )
        output = (REPLAY / "kernel_axioms.stdout").read_text()
        dependencies = {}
        pattern = (
            r"'(ExactTransitivity\.[^']+)'\s+"
            r"(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)"
        )
        for match in re.finditer(pattern, output):
            dependencies[match[1]] = (
                [item.strip() for item in match[2].split(",") if item.strip()]
                if match[2] is not None
                else []
            )
        save(
            "kernel_axiom_dependencies.json",
            {
                "exit_code": axioms["exit_code"],
                "source": str(source),
                "method": "unchanged source on Lean --stdin, followed only by #print axioms",
                "queried_declarations": [f"ExactTransitivity.{name}" for name in names],
                "dependencies": dependencies,
                "all_queries_parsed": len(dependencies) == len(names),
            },
        )
    save(
        "replay_outcome.json",
        {
            "verified_and_recorded": successful,
            "verify_exit_code": invocation["exit_code"],
            "compiler_status": payload.get("status"),
            "compiler_exit_code": payload.get("exit_code"),
            "local_axiom_audit_exit_code": payload.get("audit_exit_code"),
            "proof_holes": payload.get("proof_holes"),
            "recorded": payload.get("kernel", {}).get("recorded"),
            "official_checks": {
                name: record["exit_code"] for name, record in ledger_checks.items()
            },
            "kernel_axioms_exit_code": axioms["exit_code"] if axioms else None,
        },
    )
    return 0 if successful else 1


if __name__ == "__main__":
    if Path.cwd().resolve() != ROOT:
        raise SystemExit("Ledger operations must run from the exact campaign root")
    if sys.argv[1:2] == ["checks"] and len(sys.argv) == 3:
        print(json.dumps(checks(sys.argv[2]), indent=2))
    elif sys.argv[1:] == ["verify"]:
        raise SystemExit(verify())
    else:
        raise SystemExit("usage: replay.py checks PHASE | verify")
