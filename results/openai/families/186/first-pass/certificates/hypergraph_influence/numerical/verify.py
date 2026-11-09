#!/usr/bin/env python3
"""Recompile the exact numerical API and reject nonstandard axioms."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
SOURCE = HERE.parent / "Constants.lean"
BUILD = HERE.parent / "build"
OBJECT = BUILD / SOURCE.relative_to(ROOT).with_suffix(".olean")
THEOREM = "HypergraphInfluence.uniform_numerical_parameters"
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}


def run(command, *, cwd=ROOT, env=None, log=None):
    result = subprocess.run(
        command, cwd=cwd, env=env, text=True, capture_output=True, timeout=60, check=False
    )
    output = result.stdout + result.stderr
    if log is not None:
        (HERE / log).write_text(output)
    if result.returncode:
        raise RuntimeError(f"Command failed ({result.returncode}): {command}\n{output}")
    return output


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    version = run([str(LEAN), "--version"]).strip()
    if re.search(r"\bversion 4\.31\.0(?:,|\s)", version) is None:
        raise RuntimeError(f"Wrong Lean version: {version}")
    text = SOURCE.read_text()
    if re.search(r"\b(sorry|admit|axiom)\b", text):
        raise RuntimeError("The numerical source contains a forbidden proof token")
    run(["bash", str(HERE / "compile.sh")], log="compile.log")
    lean_path = run(["lake", "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE).strip()
    env = dict(os.environ, LEAN_PATH=f"{BUILD}:{lean_path}")
    audit = run(
        [str(LEAN), f"--root={ROOT}", str(HERE / "AxiomAudit.lean")],
        env=env,
        log="axiom-audit.log",
    )
    match = re.search(
        r"'HypergraphInfluence\.uniform_numerical_parameters' depends on axioms:\s*\[([^\]]*)\]",
        audit,
    )
    if match is None:
        raise RuntimeError(f"The expected axiom report is missing:\n{audit}")
    axioms = [entry.strip() for entry in match.group(1).split(",") if entry.strip()]
    if not set(axioms) <= STANDARD_AXIOMS:
        raise RuntimeError(f"Unexpected axiom dependencies: {axioms}")
    certificate = {
        "claim": THEOREM,
        "kind": "unconditional_numerical_parameter_theorem",
        "scope": "Numerical input to H_VARIANCE, not a proof of H_VARIANCE",
        "lean_version": version,
        "source": str(SOURCE.relative_to(ROOT)),
        "source_sha256": sha256(SOURCE),
        "object": str(OBJECT.relative_to(ROOT)),
        "object_sha256": sha256(OBJECT),
        "imports": ["Mathlib"],
        "api_audit": str((HERE / "AxiomAudit.lean").relative_to(ROOT)),
        "compile_exit_code": 0,
        "exact_api_check_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "axioms": axioms,
        "proof_holes": [],
        "large_n_witness": "m = Nat.ceil (Real.sqrt (n : Real))",
        "witness_independent_of_sigma": True,
        "uniform_sigma_argument": "sigma^2 <= sigma^alpha for 0 < sigma <= 1/2 and alpha <= 2",
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps(certificate, indent=2))


if __name__ == "__main__":
    main()
