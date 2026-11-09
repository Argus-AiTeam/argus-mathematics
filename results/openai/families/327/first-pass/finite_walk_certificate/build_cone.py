#!/usr/bin/env python3
"""Recompile only the pinned custom dependency cone with the host's Lean 4.31."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
HOST = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
ORIGINALS = HERE / "public_sources" / "lean"
SOURCES = HERE / "lean431"
BUILD = HERE / "build"
RESULT = HERE / "build_result.json"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def lean_environment():
    version = subprocess.run(
        ["lean", "--version"], check=True, capture_output=True, text=True, cwd=ROOT
    ).stdout.strip()
    if "version 4.31.0," not in version:
        raise RuntimeError(f"Required Lean 4.31.0, found {version}")
    path = subprocess.run(
        ["lake", "--dir", str(HOST), "env", "printenv", "LEAN_PATH"],
        check=True, capture_output=True, text=True, cwd=ROOT,
    ).stdout.strip()
    env = os.environ.copy()
    env["LEAN_PATH"] = str(BUILD) + os.pathsep + path
    return version, env


def build():
    inventory = json.loads((HERE / "public_sources" / "inventory.json").read_text())
    nodes = {
        name: (original_hash, imports)
        for name, original_hash, imports in inventory["custom_dependency_graph"]["nodes"]
    }
    version, env = lean_environment()
    previous = json.loads(RESULT.read_text()) if RESULT.exists() else {}
    old_modules = previous.get("modules", {}) if previous.get("lean_version") == version else {}
    result = {
        "project_root": str(ROOT),
        "lean_version": version,
        "public_revision": inventory["revision"],
        "mathlib_workspace": str(HOST),
        "lean_path": env["LEAN_PATH"],
        "status": "in_progress",
        "modules": {},
    }
    BUILD.mkdir(exist_ok=True)
    patches = json.loads((HERE / "compatibility_patches.json").read_text())
    remaining = set(nodes)
    while remaining:
        ready = sorted(
            name for name in remaining
            if all(
                dependency in result["modules"]
                and result["modules"][dependency]["exit_code"] == 0
                for dependency in nodes[name][1]
            )
        )
        if not ready:
            if any(module["exit_code"] for module in result["modules"].values()):
                result["status"] = "compile_failed"
                result["blocked_modules"] = sorted(remaining)
                RESULT.write_text(json.dumps(result, indent=2) + "\n")
                raise SystemExit(1)
            raise RuntimeError("The pinned custom import graph is cyclic or incomplete")
        for name in ready:
            original_hash, dependencies = nodes[name]
            original = ORIGINALS / "OAI" / "Analysis" / "MarkovType" / f"{name}.lean"
            if digest(original) != original_hash:
                raise RuntimeError(f"Pinned public source changed: {original}")
            source = SOURCES / "OAI" / "Analysis" / "MarkovType" / f"{name}.lean"
            text = original.read_text()
            changes = []
            for old_module, new_module in (
                ("Mathlib.Basic.Real.Basic", "Mathlib.Data.Real.Basic"),
                ("Mathlib.Analysis.Normed.Module.Seminorm.Norm", "Mathlib.Analysis.Seminorm"),
            ):
                old_import = "import " + old_module
                if old_import in text:
                    text = text.replace(old_import, "import " + new_module)
                    changes.append(f"{old_module} -> {new_module} (import path only)")
            for new_name, old_name in (
                ("if_neg", "ite_eq_right"), ("if_pos", "ite_eq_left"),
                ("dif_neg", "dite_eq_right"), ("dif_pos", "dite_eq_left"),
                ("Set.mem_setOf_eq", "Set.mem_ofPred_eq"),
            ):
                text, count = re.subn(r"\b" + re.escape(old_name) + r"\b", new_name, text)
                if count:
                    changes.append(f"{old_name} -> {new_name} (Lean/Mathlib theorem API rename, {count} occurrences)")
            for patch in patches.get(name, []):
                if text.count(patch["old"]) != 1:
                    raise RuntimeError(f"Compatibility edit does not match exactly once in {name}")
                text = text.replace(patch["old"], patch["new"], 1)
                changes.append(patch["reason"])
            source.parent.mkdir(parents=True, exist_ok=True)
            if not source.exists() or source.read_text() != text:
                source.write_text(text)
            source_hash = digest(source)
            output = BUILD / "OAI" / "Analysis" / "MarkovType" / f"{name}.olean"
            dependency_hashes = {
                dependency: result["modules"][dependency]["olean_sha256"]
                for dependency in dependencies
            }
            old = old_modules.get(name, {})
            unchanged = (
                old.get("exit_code") == 0
                and old.get("source_sha256") == source_hash
                and old.get("dependency_olean_sha256") == dependency_hashes
                and output.exists()
                and old.get("olean_sha256") == digest(output)
            )
            if unchanged:
                result["modules"][name] = old
                remaining.remove(name)
                continue
            output.parent.mkdir(parents=True, exist_ok=True)
            command = [
                "lean", "-j1", "--root", str(SOURCES), "-o", str(output), str(source),
            ]
            started = time.monotonic()
            compiled = subprocess.run(
                command, cwd=ROOT, env=env, capture_output=True, text=True,
            )
            log = output.with_suffix(".log")
            log.write_text(compiled.stdout + compiled.stderr)
            entry = {
                "source": str(source.relative_to(ROOT)),
                "source_sha256": source_hash,
                "original_source_sha256": original_hash,
                "source_unmodified": source_hash == original_hash,
                "compatibility_changes": changes,
                "dependency_olean_sha256": dependency_hashes,
                "command": command,
                "exit_code": compiled.returncode,
                "elapsed_seconds": round(time.monotonic() - started, 3),
                "log": str(log.relative_to(ROOT)),
            }
            if compiled.returncode == 0:
                entry["olean_sha256"] = digest(output)
            result["modules"][name] = entry
            RESULT.write_text(json.dumps(result, indent=2) + "\n")
            print(f"{name}: exit {compiled.returncode} ({entry['elapsed_seconds']}s)", flush=True)
            if compiled.returncode:
                print(compiled.stdout + compiled.stderr, flush=True)
            remaining.remove(name)
    if any(module["exit_code"] for module in result["modules"].values()):
        result["status"] = "compile_failed"
        result["blocked_modules"] = []
        RESULT.write_text(json.dumps(result, indent=2) + "\n")
        raise SystemExit(1)
    result["status"] = "success"
    result["module_count"] = len(result["modules"])
    RESULT.write_text(json.dumps(result, indent=2) + "\n")
    return result, env


if __name__ == "__main__":
    build()
