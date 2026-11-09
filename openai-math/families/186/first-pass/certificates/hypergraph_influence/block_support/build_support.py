#!/usr/bin/env python3
"""Compile owned block dependencies using the existing Lean 4.31 workspace."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[4]
BASE = Path(__file__).resolve().parent
LEAN = "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean"
MATHLIB = "$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
MODULES = [
    "BlockSymmetry", "RestrictionInfluence", "BlockOrbit", "BlockCounting",
    "BlockAverage", "RestrictionMassSubtype",
]


def environment():
    inherited = subprocess.check_output(
        ["lake", "env", "printenv", "LEAN_PATH"], cwd=MATHLIB, text=True
    ).strip()
    env = os.environ.copy()
    env["LEAN_PATH"] = ":".join([
        str(ROOT / "research/certificates/hypergraph_influence/build"),
        str(ROOT / "research/certificates/hypergraph_influence/upstream/build/lean"),
        str(BASE / "build"),
        inherited,
    ])
    return env


def main():
    env = environment()
    results = []
    sources = []
    if "--dependencies" in sys.argv:
        sources.extend(
            BASE / "port/OAI/Combinatorics/SharpThreshold" / (m + ".lean")
            for m in MODULES
        )
    for arg in sys.argv[1:]:
        if not arg.startswith("--"):
            sources.append(ROOT / arg)
    if not sources:
        sources.append(ROOT / "research/certificates/hypergraph_influence/Block.lean")
    for source in sources:
        rel = source.relative_to(ROOT)
        if source.name == "Block.lean":
            output = ROOT / "research/certificates/hypergraph_influence/build" / rel.with_suffix(".olean")
        else:
            output = BASE / "build/HypergraphBlockSupport" / (source.stem + ".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        log = BASE / "logs" / (source.stem + ".log")
        start = time.monotonic()
        command = [LEAN, "--root=" + str(ROOT), "-o", str(output), str(source)]
        completed = subprocess.run(
            command, cwd=ROOT, env=env, text=True, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, timeout=600
        )
        log.write_text(completed.stdout)
        result = {
            "source": str(rel), "output": str(output.relative_to(ROOT)),
            "command": command, "exit_code": completed.returncode,
            "seconds": time.monotonic() - start,
            "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            "log": str(log.relative_to(ROOT)),
        }
        results.append(result)
        print(json.dumps(result), flush=True)
        if completed.stdout:
            print(completed.stdout, flush=True)
        if completed.returncode:
            break
    (BASE / "logs/last-build.json").write_text(json.dumps(results, indent=2) + "\n")
    return results[-1]["exit_code"]


if __name__ == "__main__":
    raise SystemExit(main())
