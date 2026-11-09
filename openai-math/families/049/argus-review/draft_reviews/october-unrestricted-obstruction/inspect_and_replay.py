#!/usr/bin/env python3
"""Read-only old-input inventory and one bounded stdin replay; no Lean outputs."""

import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time


ROOT = Path.cwd()
OUT = ROOT / "research/draft_reviews/october-unrestricted-obstruction"
OLD = Path("campaigns/9000049")
CORE = OLD / "research/stable_core_certificate"
SOURCE = CORE / "formal_sources"
BUILD = CORE / "formal_build"
HOST = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean")
PREFIX = "OAI.AlgebraicGeometry.StableCoordinate."


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(name, value):
    (OUT / name).write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n")


def lean_code(text):
    """Preserve newlines while masking nested comments and string literals."""
    chars = list(text)
    i = 0
    depth = 0
    string = False
    while i < len(chars):
        if depth:
            if text[i:i + 2] == "/-":
                chars[i:i + 2] = "  "
                depth += 1
                i += 2
            elif text[i:i + 2] == "-/":
                chars[i:i + 2] = "  "
                depth -= 1
                i += 2
            else:
                if chars[i] != "\n":
                    chars[i] = " "
                i += 1
        elif string:
            if text[i] == "\\":
                chars[i] = " "
                if i + 1 < len(chars) and chars[i + 1] != "\n":
                    chars[i + 1] = " "
                i += 2
            else:
                if text[i] == '"':
                    string = False
                if chars[i] != "\n":
                    chars[i] = " "
                i += 1
        elif text[i:i + 2] == "/-":
            chars[i:i + 2] = "  "
            depth = 1
            i += 2
        elif text[i:i + 2] == "--":
            end = text.find("\n", i)
            end = len(text) if end < 0 else end
            chars[i:end] = " " * (end - i)
            i = end
        elif text[i] == '"':
            chars[i] = " "
            string = True
            i += 1
        else:
            i += 1
    return "".join(chars)


def main():
    if ROOT != Path("campaigns/9200049"):
        raise ValueError("Run from the current campaign root.")
    if (OUT / "main_replay.json").exists():
        raise FileExistsError("One replay only; existing receipt must not be overwritten.")

    modules = {}
    suspicious = re.compile(
        r"\b(sorry|sorryAx|admit|axiom|unsafe|partial|implemented_by|extern|"
        r"native_decide|run_tac)\b|set_option\s+(?:debug|kernel)"
    )
    declarations = re.compile(
        r"(?m)^[ \t]*(?:(?:noncomputable|private|protected|unsafe|partial)\s+)*"
        r"(theorem|lemma|def|abbrev|structure|class|instance|axiom|opaque)\b[^\n]*"
    )
    for path in sorted(SOURCE.rglob("*.lean")):
        module = ".".join(path.relative_to(SOURCE).with_suffix("").parts)
        text = path.read_text()
        code = lean_code(text)
        imports = [
            item for line in code.splitlines() if line.startswith("import ")
            for item in line[7:].split()
        ]
        olean = BUILD.joinpath(*module.split(".")).with_suffix(".olean")
        modules[module] = {
            "source": str(path),
            "source_sha256": digest(path),
            "lines": len(text.splitlines()),
            "imports": imports,
            "olean": str(olean),
            "olean_exists": olean.exists(),
            "olean_sha256": digest(olean) if olean.exists() else None,
            "source_mtime_ns": path.stat().st_mtime_ns,
            "olean_mtime_ns": olean.stat().st_mtime_ns if olean.exists() else None,
            "suspicious_code_tokens": [
                {"line": code[:m.start()].count("\n") + 1, "token": m.group()}
                for m in suspicious.finditer(code)
            ],
            "declarations": [
                {"line": code[:m.start()].count("\n") + 1, "header": m.group().strip()}
                for m in declarations.finditer(code)
            ],
            "variable_context_lines": [
                {"line": i, "text": line.strip()}
                for i, line in enumerate(code.splitlines(), 1)
                if line.strip().startswith(("variable ", "variables ", "include ", "omit "))
            ],
        }

    main_text = (CORE / "Main.lean").read_text()
    targets = [
        item for line in main_text.splitlines() if line.startswith("import ")
        for item in line[7:].split() if item.startswith("OAI.")
    ]
    ordered = []
    seen = set()
    missing = set()

    def visit(module):
        if module in seen:
            return
        seen.add(module)
        if module not in modules:
            missing.add(module)
            return
        for dependency in modules[module]["imports"]:
            if dependency.startswith("OAI."):
                visit(dependency)
        ordered.append(module)

    for target in targets:
        visit(target)
    source_audit = {
        "unit_id": "october-unrestricted-obstruction",
        "kind": "static inventory, not source-recompiled dependency certification",
        "main_source": str(CORE / "Main.lean"),
        "main_sha256": digest(CORE / "Main.lean"),
        "main_suspicious_code_tokens": [
            m.group() for m in suspicious.finditer(lean_code(main_text))
        ],
        "direct_imports": targets,
        "source_count": len(modules),
        "source_line_count": sum(row["lines"] for row in modules.values()),
        "reachable_source_count": len(ordered),
        "unreachable_staged_sources": sorted(set(modules) - seen),
        "missing_OAI_sources": sorted(missing),
        "ordered_closure": ordered,
        "external_imports": sorted({
            item for row in modules.values() for item in row["imports"]
            if not item.startswith("OAI.")
        }),
        "modules": modules,
    }
    save("dependency_audit.json", source_audit)

    ledger = json.loads((OLD / "research/MATH_STATE.json").read_text())
    wanted = {
        "C_OCT_GRADED", "C_OCT_COORDINATE_LINK", "C_OCT_PRINCIPAL",
        "C_OCT_ACTION_LIFT", "C_OCT_RIGIDITY", "C_OCT_EXCLUSION",
        "C_STABLE_CORE_VERIFY",
    }
    claims = []
    composite = []
    for claim in ledger["claims"]:
        if claim.get("claim_id") not in wanted:
            continue
        statement = claim.get("formal_statement", "")
        row = {k: v for k, v in claim.items() if k != "formal_statement"}
        row["formal_statement_sha256"] = hashlib.sha256(statement.encode()).hexdigest()
        row["formal_statement_length"] = len(statement)
        row["formal_statement_equals_current_Main"] = statement == main_text
        claims.append(row)
        if claim["claim_id"] == "C_STABLE_CORE_VERIFY":
            composite.append(claim)
    historical = {}
    for path in sorted(CORE.glob("*.json")):
        if path.name.startswith(("formal_", "lean_", "algebra_core", "claim_revision")):
            x = json.loads(path.read_text())
            historical[path.name] = {
                "path": str(path), "sha256": digest(path), "record": x
            }
    certificates = {}
    for path in sorted((CORE / "certificates").glob("*.json")):
        certificates[path.name] = {
            "path": str(path), "sha256": digest(path),
            "record": json.loads(path.read_text()),
        }
    save("historical_compiler_audit.json", {
        "claims": claims,
        "v2_to_v3_source_diff": "".join(difflib.unified_diff(
            composite[1]["formal_statement"].splitlines(True),
            composite[2]["formal_statement"].splitlines(True),
            fromfile="C_STABLE_CORE_VERIFY/v2", tofile="C_STABLE_CORE_VERIFY/v3",
        )),
        "historical_records": historical,
        "certificates": certificates,
        "driver_safety": {
            "driver": str(CORE / "replay_formal.py"),
            "sha256": digest(CORE / "replay_formal.py"),
            "executed": False,
            "reason": "Writes formal_build, build results, certifications and old ledgers.",
        },
    })

    lean_path = [
        BUILD, HOST / ".lake/build/lib/lean",
        *sorted((HOST / ".lake/packages").glob("*/.lake/build/lib/lean")),
    ]
    env = dict(os.environ)
    env["LEAN_PATH"] = os.pathsep.join(map(str, lean_path))
    env["ELAN_TOOLCHAIN"] = "leanprover/lean4:v4.31.0"
    command = [str(LEAN), "--stdin"]
    started = time.monotonic()
    version = subprocess.run(
        [str(LEAN), "--version"], env=env, text=True, capture_output=True,
        timeout=5, check=False,
    )
    try:
        result = subprocess.run(
            command, input=main_text, cwd=OUT, env=env, text=True,
            capture_output=True, timeout=104, check=False,
        )
        replay = {
            "status": "completed", "exit_code": result.returncode,
            "stdout": result.stdout, "stderr": result.stderr,
        }
    except subprocess.TimeoutExpired as error:
        replay = {
            "status": "timeout", "exit_code": None,
            "stdout": error.stdout.decode() if isinstance(error.stdout, bytes) else error.stdout,
            "stderr": error.stderr.decode() if isinstance(error.stderr, bytes) else error.stderr,
        }
    replay.update({
        "unit_id": "october-unrestricted-obstruction",
        "command": command, "cwd": str(OUT), "timeout_seconds": 104,
        "elapsed_seconds": round(time.monotonic() - started, 3),
        "toolchain": env["ELAN_TOOLCHAIN"],
        "compiler_version_command": [str(LEAN), "--version"],
        "compiler_version_exit_code": version.returncode,
        "compiler_version_stdout": version.stdout,
        "compiler_version_stderr": version.stderr,
        "LEAN_PATH": lean_path and list(map(str, lean_path)),
        "stdin_source": str(CORE / "Main.lean"),
        "stdin_sha256": hashlib.sha256(main_text.encode()).hexdigest(),
        "dependency_evidence": "dependency_audit.json",
        "outputs_requested": "none; no -o, -i, .lean or compiled artifact created",
        "scope": "Fresh wrapper elaboration against preserved .oleans and host built Mathlib; not a 92-module rebuild or independent review.",
    })
    save("main_replay.json", replay)
    print(json.dumps({
        "closure_sources": len(ordered),
        "suspicious_tokens": sum(len(r["suspicious_code_tokens"]) for r in modules.values()),
        "compiler": version.stdout.strip(),
        "replay_status": replay["status"], "exit_code": replay["exit_code"],
        "elapsed_seconds": replay["elapsed_seconds"],
        "stdout": replay["stdout"], "stderr": replay["stderr"],
    }, indent=2))


if __name__ == "__main__":
    main()
