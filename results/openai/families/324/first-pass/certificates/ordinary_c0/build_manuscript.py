#!/usr/bin/env python3
"""Include cutoff zero after reindexing the manuscript's coordinates by Nat."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
LEAN = "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean"
SOURCE = HERE / "manuscript_src"
BUILD = HERE / "manuscript_build"


def main():
    original = json.loads((HERE / "compiler_build.json").read_text())
    if original["status"] != "compiled" or any(
        item["exit_code"] for item in original["modules"]
    ):
        raise RuntimeError("The reusable upstream dependency compilation is incomplete")
    previous_path = HERE / "manuscript_build.json"
    previous = json.loads(previous_path.read_text()) if previous_path.exists() else {}
    prior = {item["module"]: item for item in previous.get("modules", [])}
    BUILD.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, LEAN_PATH=str(BUILD) + ":" + (HERE / "lean_path.txt").read_text().strip())
    affected = set()
    report = {
        "coordinate_mapping": "manuscript coordinate k>=1 is Lean coordinate k-1",
        "tail_mapping": "manuscript cutoff N>=1 is Lean cutoff N-1>=0",
        "change": "TailOperation.factor uses tailIndex, not tailIndex+1",
        "status": "running",
        "modules": [],
    }
    for item in original["modules"]:
        module = item["module"]
        path = Path(item["source"])
        text = path.read_text()
        dependencies = [
            dep
            for line in text.splitlines()
            if line.startswith("import ")
            for dep in line[7:].split()
            if dep.startswith("OAI.")
        ]
        if not (module.endswith(".Tests") or any(dep in affected for dep in dependencies)):
            compiled = HERE / "build" / (module.replace(".", "/") + ".olean")
            for suffix in ["", ".private", ".server"]:
                original_output = compiled.with_name(compiled.name + suffix)
                local_output = BUILD / original_output.relative_to(HERE / "build")
                if original_output.exists() and not local_output.exists():
                    local_output.parent.mkdir(parents=True, exist_ok=True)
                    local_output.symlink_to(original_output)
            continue
        affected.add(module)
        changed = re.sub(r"\.tailIndex\s*\+\s*1\b", ".tailIndex", text)
        if module.endswith(".Supports"):
            old = "let t : TailOperation := ⟨a,N,true⟩"
            if changed.count(old) != 1:
                raise RuntimeError("Tail multiplication witness changed upstream")
            changed = changed.replace(old, "let t : TailOperation := ⟨a,N+1,true⟩")
        if module.endswith(".Detection"):
            old = "(tendsto_atTop_mono (fun i => Nat.le_succ _) hN)"
            if changed.count(old) != 1:
                raise RuntimeError("Escaping-index proof changed upstream")
            changed = changed.replace(old, "hN")
        relative = Path(module.replace(".", "/") + ".lean")
        root = path.parents[len(relative.parts) - 1]
        if changed != text:
            path = SOURCE / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            if not path.exists() or path.read_text() != changed:
                path.write_text(changed)
            root = SOURCE
        output = BUILD / relative.with_suffix(".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        old_entry = prior.get(module)
        dependency_time = max(
            [path.stat().st_mtime_ns]
            + [
                (BUILD / Path(dep.replace(".", "/") + ".olean")).stat().st_mtime_ns
                for dep in dependencies if dep in affected
            ]
        )
        if (
            old_entry and old_entry["exit_code"] == 0
            and old_entry["source_sha256"] == digest
            and output.exists() and output.stat().st_mtime_ns >= dependency_time
        ):
            report["modules"].append(old_entry)
            print(f"{module}: reuse unchanged exact-model compilation", flush=True)
            continue
        command = [LEAN, "-DautoImplicit=false", "-o", str(output), str(relative)]
        result = subprocess.run(
            command, cwd=root, env=env, capture_output=True, text=True, timeout=110
        )
        log = output.with_suffix(".log")
        log.write_text(result.stdout + result.stderr)
        entry = {
            "module": module, "source": str(path), "source_sha256": digest,
            "exit_code": result.returncode, "command": command,
            "log": str(log.relative_to(HERE)),
        }
        report["modules"].append(entry)
        print(f"{module}: exit={result.returncode}", flush=True)
        if result.returncode:
            report["status"] = "failed"
            previous_path.write_text(json.dumps(report, indent=2) + "\n")
            print(log.read_text()[-14000:], flush=True)
            raise SystemExit(result.returncode)
    report["status"] = "compiled"
    previous_path.write_text(json.dumps(report, indent=2) + "\n")
    (HERE / "manuscript_lean_path.txt").write_text(env["LEAN_PATH"] + "\n")
    print(f"Compiled {len(affected)} affected modules for the exact manuscript tail family.", flush=True)


if __name__ == "__main__":
    main()
