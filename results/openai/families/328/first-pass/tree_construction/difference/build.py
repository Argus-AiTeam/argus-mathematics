#!/usr/bin/env python3
"""Compile DifferenceSpace against the existing Lean 4.31.0 producer build."""

from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import os
import pathlib
import re
import subprocess
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parent
DEFAULT_MATHLIB = pathlib.Path(
    "$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
)
PRODUCER_LIB = ROOT.parent / "producer" / "build" / "lib" / "lean"
PRINCIPALS = (
    "shiftEquiv",
    "shiftedSet_convex",
    "shiftEquiv_norm_sub",
    "shiftEquiv_convexAverage",
    "shiftConjugate_nonexpansive",
    "norm_restrictFunctional_le",
    "restrictFunctional_shift_sub",
    "weakSubspaceHomeomorph",
    "tendsto_shiftEquiv_weak",
    "normalized_shifted_dense_differences_span",
    "normalized_intrinsicWeakUnitBall_compact",
    "differenceSpace_completeSpace",
)
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}


def uncomment(text: str) -> str:
    """Remove nested Lean block comments and line comments."""
    out = []
    depth = 0
    i = 0
    while i < len(text):
        pair = text[i : i + 2]
        if pair == "/-":
            depth += 1
            i += 2
        elif depth and pair == "-/":
            depth -= 1
            i += 2
        elif depth:
            i += 1
        elif pair == "--":
            end = text.find("\n", i)
            i = len(text) if end < 0 else end
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mathlib", type=pathlib.Path, default=DEFAULT_MATHLIB)
    args = parser.parse_args()
    start = time.monotonic()
    build = ROOT / "build"
    outputs = build / "lib" / "lean"
    logs = build / "logs"
    outputs.mkdir(parents=True, exist_ok=True)
    logs.mkdir(parents=True, exist_ok=True)
    source = ROOT / "DifferenceSpace.lean"
    output = outputs / "DifferenceSpace.olean"
    log = logs / "DifferenceSpace.log"
    result = build / "result.json"
    report = {
        "started_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "status": "running",
        "mathlib_workspace": str(args.mathlib.resolve()),
        "producer_library": str(PRODUCER_LIB.resolve()),
        "source": str(source.relative_to(ROOT)),
        "supporting_lemma_only": True,
        "completes_C_TREE_CONSTRUCTION": False,
    }

    def persist() -> None:
        report["elapsed_seconds"] = time.monotonic() - start
        result.write_text(json.dumps(report, indent=2) + "\n")

    try:
        text = source.read_text()
        forbidden = re.findall(r"\b(?:sorry|admit|axiom|unsafe)\b", uncomment(text))
        if forbidden:
            raise RuntimeError(f"Forbidden proof-hole/declaration tokens: {forbidden}")
        report["source_sha256"] = hashlib.sha256(source.read_bytes()).hexdigest()
        report["producer_olean_sha256"] = hashlib.sha256(
            (PRODUCER_LIB / "Producer.olean").read_bytes()
        ).hexdigest()
        path_probe = subprocess.run(
            ["lake", "env", "printenv", "LEAN_PATH"],
            cwd=args.mathlib,
            capture_output=True,
            text=True,
            check=True,
        )
        env = os.environ.copy()
        env["LEAN_PATH"] = os.pathsep.join(
            (str(PRODUCER_LIB), str(outputs), path_probe.stdout.strip())
        )
        report["LEAN_PATH"] = env["LEAN_PATH"]
        version = subprocess.run(
            ["lake", "env", "lean", "--version"],
            cwd=args.mathlib,
            env=env,
            capture_output=True,
            text=True,
            check=True,
        )
        (logs / "version.log").write_text(version.stdout + version.stderr)
        report["compiler_version"] = version.stdout.strip()
        if not re.search(r"\bversion 4\.31\.0\b", version.stdout):
            raise RuntimeError(f"Wrong compiler: {version.stdout.strip()}")
        command = [
            "lake", "env", "lean", f"--root={ROOT}", "-o", str(output), str(source)
        ]
        report["command"] = command
        persist()
        output.unlink(missing_ok=True)
        lean_start = time.monotonic()
        with log.open("w") as stream:
            completed = subprocess.run(
                command,
                cwd=args.mathlib,
                env=env,
                stdout=stream,
                stderr=subprocess.STDOUT,
                text=True,
            )
        report["compiler_elapsed_seconds"] = time.monotonic() - lean_start
        report["compiler_exit_code"] = completed.returncode
        report["compiler_log"] = str(log.relative_to(ROOT))
        print(log.read_text(), end="", flush=True)
        if completed.returncode:
            raise RuntimeError(f"Lean exited with {completed.returncode}")
        if not output.is_file():
            raise RuntimeError("Lean returned success without an object file")
        axiom_report = {}
        log_text = log.read_text()
        for short in PRINCIPALS:
            name = "TreeConstruction." + short
            match = re.search(
                re.escape("'" + name + "'")
                + r"\s+depends on axioms:\s*\[([^\]]*)\]",
                log_text,
                flags=re.DOTALL,
            )
            if match:
                axioms = [a.strip() for a in match.group(1).split(",") if a.strip()]
            elif f"'{name}' does not depend on any axioms" in log_text:
                axioms = []
            else:
                raise RuntimeError(f"Missing actual #print axioms output: {name}")
            if not set(axioms) <= ALLOWED_AXIOMS:
                raise RuntimeError(f"Nonstandard axioms: {name}: {axioms}")
            axiom_report[name] = axioms
        report["principal_axioms"] = axiom_report
        report["proof_holes"] = []
        report["output"] = str(output.relative_to(ROOT))
        report["output_sha256"] = hashlib.sha256(output.read_bytes()).hexdigest()
        report["status"] = "passed"
        persist()
        print(json.dumps(report, indent=2))
        return 0
    except Exception as exc:
        report["status"] = "failed"
        report["error"] = str(exc)
        persist()
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
