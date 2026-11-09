#!/usr/bin/env python3
"""Fetch and compile only the additional pinned forward-implication imports."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time
from urllib.request import urlopen


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
WALK = ROOT / "research/finite_walk_certificate"
HOST = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
PREFIX = "OAI.Analysis.MarkovType."
TARGETS = ("OrderedNormStructural", "MarkovObstruction", "OddEdgeTransfer")
ORIGINALS = HERE / "public_sources"
SOURCES = HERE / "lean431"
BUILD = HERE / "build"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def module_path(base, name, suffix=".lean"):
    return base / "OAI/Analysis/MarkovType" / (name + suffix)


def custom_imports(text):
    imports = re.findall(r"^import\s+(\S+)", text, re.MULTILINE)
    unexpected = [name for name in imports if name.startswith("OAI.") and not name.startswith(PREFIX)]
    if unexpected:
        raise RuntimeError(f"Uninspected external custom imports: {unexpected}")
    return [name.removeprefix(PREFIX) for name in imports if name.startswith(PREFIX)]


def fetch():
    old_inventory = json.loads((WALK / "public_sources/inventory.json").read_text())
    if old_inventory["revision"] != REVISION:
        raise RuntimeError("The reviewed finite-walk source revision differs")
    old = {
        name: {"source_sha256": sha, "imports": imports}
        for name, sha, imports in old_inventory["custom_dependency_graph"]["nodes"]
    }
    inventory_path = HERE / "source_inventory.json"
    prior = json.loads(inventory_path.read_text())["modules"] if inventory_path.exists() else {}

    def retrieve(name):
        path = module_path(ORIGINALS, name)
        if not path.exists():
            url = f"https://raw.githubusercontent.com/openai/math/{REVISION}/lean/OAI/Analysis/MarkovType/{name}.lean"
            with urlopen(url, timeout=60) as response:
                data = response.read()
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        if name in prior and digest(path) != prior[name]["source_sha256"]:
            raise RuntimeError(f"The previously pinned public source changed: {name}")
        return name, {
            "source": str(path.relative_to(ROOT)),
            "source_sha256": digest(path),
            "imports": custom_imports(path.read_text()),
        }

    nodes = {}
    frontier = set(TARGETS)
    while frontier:
        reused = frontier & old.keys()
        for name in reused:
            nodes[name] = {**old[name], "reused_reviewed_walk_module": True}
        new = sorted(frontier - old.keys())
        with ThreadPoolExecutor(max_workers=6) as pool:
            for name, entry in pool.map(retrieve, new):
                nodes[name] = {**entry, "reused_reviewed_walk_module": False}
        frontier = {
            dependency
            for name in frontier
            for dependency in nodes[name]["imports"]
            if dependency not in nodes
        }
    inventory = {
        "revision": REVISION,
        "repository": "https://github.com/openai/math",
        "targets": list(TARGETS),
        "license": "../finite_walk_certificate/public_sources/lean/LICENSE",
        "source_toolchain": "4.34.1",
        "requested_toolchain": "4.31.0",
        "reviewed_walk_certificate": "research/finite_walk_certificate/certificates/CWalk-d0a6fb48b124f143.json",
        "new_module_count": sum(not entry["reused_reviewed_walk_module"] for entry in nodes.values()),
        "reused_module_count": sum(entry["reused_reviewed_walk_module"] for entry in nodes.values()),
        "modules": dict(sorted(nodes.items())),
    }
    (HERE / "source_inventory.json").write_text(json.dumps(inventory, indent=2) + "\n")
    print(json.dumps({key: value for key, value in inventory.items() if key != "modules"}, indent=2))
    return inventory


def environment():
    version = subprocess.run(
        ["lean", "--version"], cwd=ROOT, check=True, capture_output=True, text=True,
    ).stdout.strip()
    if "version 4.31.0," not in version:
        raise RuntimeError(f"Required Lean 4.31.0, found {version}")
    path = subprocess.run(
        ["lake", "--dir", str(HOST), "env", "printenv", "LEAN_PATH"],
        cwd=ROOT, check=True, capture_output=True, text=True,
    ).stdout.strip()
    env = os.environ.copy()
    env["LEAN_PATH"] = os.pathsep.join((str(BUILD), str(WALK / "build"), path))
    return version, env


def build():
    inventory = json.loads((HERE / "source_inventory.json").read_text())
    if inventory["revision"] != REVISION:
        raise RuntimeError("The new dependency inventory does not use the authorized revision")
    walk_record = json.loads((WALK / "build_result.json").read_text())
    version, env = environment()
    if walk_record["lean_version"] != version or walk_record["status"] != "success":
        raise RuntimeError("The accepted finite-walk build does not match this compiler")
    nodes = inventory["modules"]
    for name, entry in nodes.items():
        if not entry["reused_reviewed_walk_module"]:
            continue
        previous = walk_record["modules"][name]
        original = module_path(WALK / "public_sources/lean", name)
        source = module_path(WALK / "lean431", name)
        output = module_path(WALK / "build", name, ".olean")
        if (digest(original) != entry["source_sha256"]
                or digest(source) != previous["source_sha256"]
                or digest(output) != previous["olean_sha256"]):
            raise RuntimeError(f"The accepted CWalk dependency changed: {name}")
        reused_output = module_path(BUILD, name, ".olean")
        reused_output.parent.mkdir(parents=True, exist_ok=True)
        if not reused_output.exists():
            reused_output.symlink_to(output)
        if digest(reused_output) != previous["olean_sha256"]:
            raise RuntimeError(f"The reused CWalk artifact differs: {name}")
    result_path = HERE / "build_result.json"
    previous = json.loads(result_path.read_text()) if result_path.exists() else {}
    old_modules = previous.get("modules", {}) if previous.get("lean_version") == version else {}
    patches_path = HERE / "compatibility_patches.json"
    patches = json.loads(patches_path.read_text()) if patches_path.exists() else {}
    result = {
        "project_root": str(ROOT),
        "public_revision": REVISION,
        "lean_version": version,
        "lean_path": env["LEAN_PATH"],
        "status": "in_progress",
        "reviewed_walk_modules_recompiled": 0,
        "modules": {},
    }
    remaining = {name for name, entry in nodes.items() if not entry["reused_reviewed_walk_module"]}
    while remaining:
        ready = sorted(
            name for name in remaining
            if all(nodes[d]["reused_reviewed_walk_module"]
                   or result["modules"].get(d, {}).get("exit_code") == 0
                   for d in nodes[name]["imports"])
        )
        if not ready:
            result["status"] = "compile_failed"
            result["blocked_modules"] = sorted(remaining)
            result_path.write_text(json.dumps(result, indent=2) + "\n")
            raise SystemExit(1)
        for name in ready:
            original = module_path(ORIGINALS, name)
            if digest(original) != nodes[name]["source_sha256"]:
                raise RuntimeError(f"Pinned original changed: {name}")
            text = original.read_text()
            changes = []
            for old, new in (
                ("Mathlib.Basic.Real.Basic", "Mathlib.Data.Real.Basic"),
                ("Mathlib.Basic.Real.ConjExponents", "Mathlib.Data.Real.ConjExponents"),
                ("Mathlib.Basic.Countable.Basic", "Mathlib.Data.Countable.Basic"),
                ("Mathlib.Analysis.Normed.Module.Seminorm.Norm", "Mathlib.Analysis.Seminorm"),
            ):
                if "import " + old in text:
                    text = text.replace("import " + old, "import " + new)
                    changes.append(f"{old} -> {new}")
            for old, new in (
                ("ite_eq_right", "if_neg"), ("ite_eq_left", "if_pos"),
                ("dite_eq_right", "dif_neg"), ("dite_eq_left", "dif_pos"),
                ("Set.mem_ofPred_eq", "Set.mem_setOf_eq"),
            ):
                text, count = re.subn(r"\b" + re.escape(old) + r"\b", new, text)
                if count:
                    changes.append(f"{old} -> {new}: {count}")
            for patch in patches.get(name, []):
                if text.count(patch["old"]) != 1:
                    raise RuntimeError(f"Compatibility edit must match exactly once in {name}")
                text = text.replace(patch["old"], patch["new"], 1)
                changes.append(patch["reason"])
            source = module_path(SOURCES, name)
            source.parent.mkdir(parents=True, exist_ok=True)
            if not source.exists() or source.read_text() != text:
                source.write_text(text)
            output = module_path(BUILD, name, ".olean")
            dependency_hashes = {
                d: (walk_record["modules"][d] if nodes[d]["reused_reviewed_walk_module"]
                    else result["modules"][d])["olean_sha256"]
                for d in nodes[name]["imports"]
            }
            old = old_modules.get(name, {})
            if (old.get("exit_code") == 0 and old.get("source_sha256") == digest(source)
                    and old.get("dependency_olean_sha256") == dependency_hashes
                    and output.exists() and old.get("olean_sha256") == digest(output)):
                result["modules"][name] = old
                remaining.remove(name)
                continue
            output.parent.mkdir(parents=True, exist_ok=True)
            command = ["lean", "-j1", "--root", str(SOURCES), "-o", str(output), str(source)]
            started = time.monotonic()
            compiled = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True)
            log = output.with_suffix(".log")
            log.write_text(compiled.stdout + compiled.stderr)
            entry = {
                "source": str(source.relative_to(ROOT)),
                "source_sha256": digest(source),
                "original_source_sha256": nodes[name]["source_sha256"],
                "compatibility_changes": changes,
                "dependency_olean_sha256": dependency_hashes,
                "exit_code": compiled.returncode,
                "elapsed_seconds": round(time.monotonic() - started, 3),
                "command": command,
                "log": str(log.relative_to(ROOT)),
            }
            if compiled.returncode == 0:
                entry["olean_sha256"] = digest(output)
            result["modules"][name] = entry
            result_path.write_text(json.dumps(result, indent=2) + "\n")
            print(f"{name}: exit {compiled.returncode} ({entry['elapsed_seconds']}s)", flush=True)
            if compiled.returncode:
                print(compiled.stdout + compiled.stderr, flush=True)
            remaining.remove(name)
    if any(entry["exit_code"] for entry in result["modules"].values()):
        result["status"] = "compile_failed"
        result_path.write_text(json.dumps(result, indent=2) + "\n")
        raise SystemExit(1)
    result["status"] = "success"
    result["new_module_count"] = len(result["modules"])
    result_path.write_text(json.dumps(result, indent=2) + "\n")
    return result, env


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fetch", action="store_true")
    parser.add_argument("--build", action="store_true")
    args = parser.parse_args()
    if not args.fetch and not args.build:
        parser.error("Choose --fetch or --build")
    if args.fetch:
        fetch()
    if args.build:
        build()
