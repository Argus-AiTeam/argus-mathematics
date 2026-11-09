#!/usr/bin/env python3
"""Rebuild exact local Lean imports or check the alignment theorem."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def lean_environment():
    env = os.environ.copy()
    paths = subprocess.check_output(
        ["lake", "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE, text=True
    ).strip()
    env["LEAN_PATH"] = str(HERE / "imports") + os.pathsep + paths
    env["ARGUS_SKILL_MATHLIB_WORKSPACE"] = str(WORKSPACE)
    (HERE / "work").mkdir(exist_ok=True)
    env["TMPDIR"] = str(HERE / "work")
    return env


def build_imports(env):
    manifest = {
        "lean_version": subprocess.check_output(
            ["lean", "--version"], env=env, text=True
        ).strip(),
        "project_root": str(ROOT),
        "LEAN_PATH": env["LEAN_PATH"],
        "imports": [],
    }
    for name in ("genericity", "radicals"):
        source = Path("research/latent_separation") / name / "Main.lean"
        output = HERE / "imports" / source.with_suffix(".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        digest = sha256(ROOT / source)
        command = ["lean", f"--root={ROOT}", "-o", str(output), str(source)]
        subprocess.run(command, cwd=ROOT, env=env, check=True)
        if sha256(ROOT / source) != digest:
            raise RuntimeError(f"Prerequisite changed while compiling: {source}")
        manifest["imports"].append({
            "source": str(source), "source_sha256": digest,
            "output": str(output.relative_to(ROOT)), "output_sha256": sha256(output),
            "command": command, "exit_code": 0,
        })
    (HERE / "imports" / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["imports", "check"])
    args = parser.parse_args()
    env = lean_environment()
    if args.action == "imports":
        build_imports(env)
    else:
        subprocess.run(
            ["lean", f"--root={ROOT}", "-o", str(HERE / "Main.olean"),
             str(HERE / "Main.lean")],
            cwd=ROOT, env=env, check=True,
        )


if __name__ == "__main__":
    main()
