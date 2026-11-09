#!/usr/bin/env python3
"""Compile only the upstream obstruction's dependency closure with Lean 4.31."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time


HERE = Path(__file__).resolve().parent
UPSTREAM = Path("openai-math/lean")
MATHLIB = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean")
TARGET = "OAI.Analysis.C0Absorption.Tags"
BUILD = HERE / "build"
COMPATIBILITY_EDITS = {
    "OAI.Analysis.C0Absorption.Lists": [
        ("[completedSigma, smul_apply, NNReal.smul_def, NNReal.coe_inv,",
         "[completedSigma, Seminorm.smul_apply, NNReal.smul_def, NNReal.coe_inv,")
    ],
    "OAI.Analysis.C0Absorption.Localization": [
        ("Set.preimage_ofPred_eq", "Set.preimage_setOf_eq"),
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict"),
        ("ite_eq_right (ne_of_lt hij)", "if_neg (ne_of_lt hij)"),
        ("ite_eq_left rfl", "if_pos rfl"),
    ],
    "OAI.Analysis.C0Absorption.Coordinates": [
        ("rw [ite_eq_left hi,", "rw [if_pos hi,"),
        ("rw [ite_eq_right hi]", "rw [if_neg hi]"),
        ("simp only [ite_eq_right hi,", "simp only [if_neg hi,"),
    ],
    "OAI.Analysis.C0Absorption.Triangular": [
        ("(Q.lipschitzWith.dist_le_mul _ _).trans", "(Q.lipschitz.dist_le_mul _ _).trans"),
        (":= Q.lipschitzWith.dist_le_mul _ _", ":= Q.lipschitz.dist_le_mul _ _"),
    ],
    "OAI.Analysis.C0Absorption.Detection": [
        ("Set.mem_ofPred_eq", "Set.mem_setOf_eq"),
    ],
    "OAI.Analysis.C0Absorption.Angles": [
        ("ite_eq_right hj.ne]", "if_neg hj.ne]"),
        ("ite_eq_right hj.ne',zero_add", "if_neg hj.ne',zero_add"),
    ],
    "OAI.Analysis.C0Absorption.Tags": [
        ("Set.mem_ofPred_eq", "Set.mem_setOf_eq"),
    ],
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fresh", action="store_true", help="Replay every dependency compiler run.")
    args = parser.parse_args()
    version = subprocess.run(
        [str(LEAN), "--version"], check=True, capture_output=True, text=True
    ).stdout.strip()
    if "version 4.31.0," not in version:
        raise RuntimeError(f"Wrong compiler: {version}")
    base_path = subprocess.run(
        ["$WORKSPACE/.elan/bin/lake", "env", "printenv", "LEAN_PATH"],
        cwd=MATHLIB,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    order = []
    seen = set()
    dependencies = {}

    def visit(module):
        if module in seen:
            return
        seen.add(module)
        source = UPSTREAM / (module.replace(".", "/") + ".lean")
        dependencies[module] = []
        for line in source.read_text().splitlines():
            match = re.fullmatch(r"(?:public )?import (.+)", line)
            if match:
                for dependency in match.group(1).split():
                    if dependency.startswith("OAI."):
                        dependencies[module].append(dependency)
                        visit(dependency)
        order.append((module, source))

    visit(TARGET)
    BUILD.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, LEAN_PATH=str(BUILD) + ":" + base_path)
    previous_path = HERE / "compiler_build.json"
    previous = json.loads(previous_path.read_text()) if previous_path.exists() else {}
    prior = {item["module"]: item for item in previous.get("modules", [])}
    report = {
        "compiler": version,
        "project_root": str(HERE.parents[2]),
        "source_root": str(UPSTREAM),
        "target": TARGET,
        "modules": [],
        "status": "running",
    }
    print(f"Compiling {len(order)} modules with {version}", flush=True)
    for module, source in order:
        source_root = UPSTREAM
        if module in COMPATIBILITY_EDITS:
            text = source.read_text()
            for old, new in COMPATIBILITY_EDITS[module]:
                if text.count(old) != 1:
                    raise RuntimeError(f"Compatibility edit has no unique match in {source}")
                text = text.replace(old, new)
            source_root = HERE / "compat"
            source = source_root / source.relative_to(UPSTREAM)
            source.parent.mkdir(parents=True, exist_ok=True)
            if not source.exists() or source.read_text() != text:
                source.write_text(text)
        output = BUILD / (module.replace(".", "/") + ".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        log = output.with_suffix(".log")
        previous_entry = prior.get(module)
        input_time = max(
            [source.stat().st_mtime_ns]
            + [
                (BUILD / (dep.replace(".", "/") + ".olean")).stat().st_mtime_ns
                for dep in dependencies[module]
            ]
        )
        if (
            not args.fresh
            and previous_entry
            and previous_entry["exit_code"] == 0
            and previous_entry["source"] == str(source)
            and output.exists()
            and output.stat().st_mtime_ns >= input_time
        ):
            report["modules"].append(previous_entry)
            print(f"{module}: reusing the unchanged successful compiler run", flush=True)
            continue
        if previous_entry and previous_entry["exit_code"] and log.exists():
            saved_log = log.with_suffix(".previous.log")
            suffix = 1
            while saved_log.exists():
                saved_log = log.with_suffix(f".previous.{suffix}.log")
                suffix += 1
            saved_log.write_text(log.read_text())
        started = time.monotonic()
        command = [
            str(LEAN),
            "-DautoImplicit=false",
            "-o",
            str(output),
            str(source.relative_to(source_root)),
        ]
        with log.open("w") as stream:
            result = subprocess.run(
                command,
                cwd=source_root,
                env=env,
                stdout=stream,
                stderr=subprocess.STDOUT,
                timeout=300,
            )
        entry = {
            "module": module,
            "source": str(source),
            "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            "command": command,
            "exit_code": result.returncode,
            "seconds": round(time.monotonic() - started, 3),
            "log": str(log.relative_to(HERE)),
        }
        report["modules"].append(entry)
        print(f"{module}: exit={result.returncode} seconds={entry['seconds']}", flush=True)
        if result.returncode:
            report["status"] = "failed"
            (HERE / "compiler_build.json").write_text(json.dumps(report, indent=2) + "\n")
            print(log.read_text()[-16000:], flush=True)
            raise SystemExit(result.returncode)
    report["status"] = "compiled"
    (HERE / "compiler_build.json").write_text(json.dumps(report, indent=2) + "\n")
    (HERE / "lean_path.txt").write_text(env["LEAN_PATH"] + "\n")
    print("Dependency closure compiled; no manuscript theorem is certified yet.", flush=True)


if __name__ == "__main__":
    main()
