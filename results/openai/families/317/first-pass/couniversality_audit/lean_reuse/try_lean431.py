#!/usr/bin/env python3
"""Attempt the pinned dependency closure with the installed Lean 4.31 library."""

import json
import os
from pathlib import Path
import subprocess
import time


ROOT = Path(__file__).resolve().parent


def main():
    manifest = json.loads((ROOT / "dependency_manifest.json").read_text())
    paths = json.loads((ROOT / "host_lean_path.json").read_text())
    for path in paths:
        if not Path(path).is_dir():
            raise RuntimeError(f"Recorded library path no longer exists: {path}")
    modules = manifest["modules"]
    order = []
    seen = set()

    def visit(name):
        if name in seen:
            return
        seen.add(name)
        for dependency in modules[name]["imports"]:
            if dependency.startswith("OAI."):
                visit(dependency)
        order.append(name)

    for name in manifest["roots"]:
        visit(name)

    build = ROOT / "build431"
    build.mkdir(exist_ok=True)
    env = dict(os.environ, LEAN_PATH=os.pathsep.join([str(build), *paths]))
    command = ["lean", "+leanprover/lean4:v4.31.0"]
    version = subprocess.run(
        [*command, "--version"], env=env, text=True, capture_output=True, check=True
    ).stdout.strip()
    result = {
        "classification": "compatibility experiment, not theorem certification",
        "compiler": version,
        "library_paths": paths,
        "modules_requested": len(order),
        "compiled": [],
    }
    for name in order:
        archive = ROOT / modules[name]["path"]
        source = build / "source" / (name.replace(".", "/") + ".lean")
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_bytes(archive.read_bytes())
        output = build / (name.replace(".", "/") + ".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        args = [
            *command,
            "--root=" + str(build / "source"),
            "-o",
            str(output),
            str(source),
        ]
        start = time.monotonic()
        try:
            completed = subprocess.run(args, env=env, text=True, capture_output=True)
        finally:
            source.unlink()
        log = build / (name.replace(".", "_") + ".log")
        log.write_text(completed.stdout + completed.stderr)
        entry = {
            "module": name,
            "command": args,
            "exit_code": completed.returncode,
            "elapsed_seconds": round(time.monotonic() - start, 3),
            "log": str(log.relative_to(ROOT)),
        }
        result["compiled"].append(entry)
        print(json.dumps(entry), flush=True)
        if completed.returncode:
            result["status"] = "incompatible_source"
            break
    else:
        result["status"] = "dependency_closure_compiled"
    (ROOT / "lean431_build_result.json").write_text(json.dumps(result, indent=2) + "\n")
    return 0 if result["status"] == "dependency_closure_compiled" else 1


if __name__ == "__main__":
    raise SystemExit(main())
