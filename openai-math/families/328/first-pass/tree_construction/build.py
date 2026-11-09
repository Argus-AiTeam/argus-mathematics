#!/usr/bin/env python3
"""Compile the integration against the locally checked Lean 4.31.0 libraries."""

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LIB = HERE / "build/lib/lean"


def lean_environment():
    base = subprocess.run(
        ["lake", "env", "printenv", "LEAN_PATH"],
        cwd=WORKSPACE, text=True, capture_output=True, check=True,
    ).stdout.strip()
    env = os.environ.copy()
    env["LEAN_PATH"] = ":".join([
        str(LIB),
        str(HERE / "producer/build/lib/lean"),
        str(HERE / "difference/build/lib/lean"),
        base,
    ])
    return env


def compile_source(source, env):
    source = source.resolve()
    name = source.stem
    log = HERE / f"build/{name}.log"
    started = time.monotonic()
    result = subprocess.run(
        ["lake", "env", "lean", f"--root={HERE}",
         "-o", str(LIB / f"{name}.olean"), str(source)],
        cwd=WORKSPACE, env=env, text=True, capture_output=True, check=False,
    )
    log.write_text(result.stdout + result.stderr, encoding="utf-8")
    print(f"{name}: exit={result.returncode}, seconds={time.monotonic()-started:.3f}")
    if result.stdout:
        print(result.stdout[-16000:])
    if result.stderr:
        print(result.stderr[-4000:])
    if result.returncode:
        raise SystemExit(result.returncode)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, default=HERE / "Main.lean")
    args = parser.parse_args()
    LIB.mkdir(parents=True, exist_ok=True)
    original = ROOT / "research/switching_bridge/Main.lean"
    snapshot = HERE / "ReviewedSwitchingBridge.lean"
    changed = not snapshot.exists() or snapshot.read_bytes() != original.read_bytes()
    if changed:
        shutil.copyfile(original, snapshot)
    env = lean_environment()
    if changed or not (LIB / "ReviewedSwitchingBridge.olean").exists():
        compile_source(snapshot, env)
    compile_source(args.source, env)


if __name__ == "__main__":
    main()
