#!/usr/bin/env python3
"""Replay only the formal dependency closure used by Main.lean on Lean 4.31.0."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import time


HERE = Path(__file__).resolve().parent
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
UPSTREAM = Path("openai-math/lean")
TARGETS = (
    "CoordinateToQuadric",
    "LiftObstruction",
    "DeterminantNonzero",
    "DeterminantDomain",
    "LeadingLocallyNilpotent",
    "DeterminantFinalStep",
    "VerticalLND",
    "Stabilization",
)
PREFIX = "OAI.AlgebraicGeometry.StableCoordinate."


def dependencies(root, module):
    source = root.joinpath(*module.split(".")).with_suffix(".lean")
    imports = []
    for line in source.read_text().splitlines():
        if line.startswith("import "):
            imports.extend(dep for dep in line[7:].split() if dep.startswith("OAI."))
    return source, imports


def ordered_modules(root):
    ordered = []
    seen = set()

    def visit(module):
        if module in seen:
            return
        seen.add(module)
        _, imports = dependencies(root, module)
        for dependency in imports:
            visit(dependency)
        ordered.append(module)

    for target in TARGETS:
        visit(PREFIX + target)
    return ordered


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stage", action="store_true")
    parser.add_argument("--rebuild", action="store_true",
                        help="Recompile every selected module for independent replay.")
    parser.add_argument("--certify-main", action="store_true",
                        help="Run official claim certification and both campaign-local gates.")
    args = parser.parse_args()
    sources = HERE / "formal_sources"
    build = HERE / "formal_build"
    if args.stage:
        for module in ordered_modules(UPSTREAM):
            source, _ = dependencies(UPSTREAM, module)
            target = sources / source.relative_to(UPSTREAM)
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists():
                raise FileExistsError(f"Refusing to overwrite staged source: {target}")
            shutil.copyfile(source, target)
        shutil.copyfile(UPSTREAM / "LICENSE", sources / "LICENSE")

    modules = ordered_modules(sources)
    build.mkdir(parents=True, exist_ok=True)
    environment = dict(os.environ)
    environment["LEAN_PATH"] = str(build)
    environment["ELAN_TOOLCHAIN"] = "leanprover/lean4:v4.31.0"
    records = []
    failed = set()
    blocked = set()
    started = time.monotonic()
    for module in modules:
        source, imports = dependencies(sources, module)
        unavailable = [dependency for dependency in imports if dependency in failed | blocked]
        if unavailable:
            blocked.add(module)
            records.append({"module": module, "status": "blocked", "dependencies": unavailable})
            continue
        output = build.joinpath(*module.split(".")).with_suffix(".olean")
        prerequisite_times = [source.stat().st_mtime]
        prerequisite_times.extend(
            build.joinpath(*dependency.split(".")).with_suffix(".olean").stat().st_mtime
            for dependency in imports
        )
        if not args.rebuild and output.exists() and output.stat().st_mtime > max(prerequisite_times):
            records.append({"module": module, "status": "unchanged"})
            continue
        output.parent.mkdir(parents=True, exist_ok=True)
        command = [
            "lake", "--dir", str(WORKSPACE), "env", "lean",
            f"--root={sources}", "-o", str(output), str(source),
        ]
        tick = time.monotonic()
        result = subprocess.run(
            command, env=environment, text=True, capture_output=True, check=False
        )
        record = {
            "module": module,
            "status": "compiled" if result.returncode == 0 else "failed",
            "command": command,
            "exit_code": result.returncode,
            "seconds": round(time.monotonic() - tick, 3),
            "stdout": result.stdout,
            "stderr": result.stderr,
        }
        records.append(record)
        if result.returncode:
            failed.add(module)
            errors = [line for line in (result.stdout+result.stderr).splitlines()
                      if ": error" in line]
            print(f"FAILED {module}\n"+"\n".join(errors[:4]), flush=True)
        else:
            print(f"COMPILED {module.rsplit('.', 1)[-1]} {record['seconds']}s", flush=True)
    report = {
        "toolchain": environment["ELAN_TOOLCHAIN"],
        "upstream_toolchain": "leanprover/lean4:v4.34.1",
        "source_root": str(sources),
        "build_root": str(build),
        "module_count": len(modules),
        "elapsed_seconds": round(time.monotonic() - started, 3),
        "complete": not failed and not blocked,
        "failed_modules": sorted(failed),
        "blocked_modules": sorted(blocked),
        "records": records,
    }
    (HERE / "formal_build_result.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Closure: {len(modules)} modules, {len(failed)} failed, {len(blocked)} blocked.",
          flush=True)
    if failed or blocked:
        raise SystemExit(1)
    if args.certify_main:
        project = HERE.parent.parent.resolve()
        if Path.cwd().resolve() != project:
            raise ValueError(f"Certification must run from the campaign root: {project}")
        python = "$WORKSPACE/argus-live-update/.venv/bin/python"
        commands = (
            ("lean_verification", [
                python, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
                str(HERE / "Main.lean"), "--project-root", str(project),
                "--claim", "C_STABLE_CORE_VERIFY", "--artifact-dir", str(HERE),
                "--statement-fidelity", str(HERE / "statement_fidelity.md"),
            ]),
            ("math_state_check", [
                python, "-m", "argus_skill.verticals.math.math_state", "check",
                "--project-root", str(project),
            ]),
            ("proof_graph_check", [
                python, "-m", "argus_skill.verticals.math.proof_graph_check", "check",
                "--project-root", str(project),
            ]),
        )
        gate = {"project_root": str(project), "commands": {}, "axiom_gate": "not_checked"}
        for label, command in commands:
            result = subprocess.run(
                command, env=environment, text=True, capture_output=True, check=False
            )
            suffix = "log" if label == "proof_graph_check" else "json"
            target = HERE / f"{label}_result.{suffix}"
            target.write_text(result.stdout)
            gate["commands"][label] = {
                "command": command, "exit_code": result.returncode,
                "output": str(target.relative_to(project)), "stderr": result.stderr,
            }
        if gate["commands"]["lean_verification"]["exit_code"] == 0:
            official = json.loads((HERE / "lean_verification_result.json").read_text())
            expected = {
                "universal_principalization", "signed_quadric_identity",
                "lower_perturbation_rigidity", "unrestricted_invariant_exclusion",
                "literal_coordinate_to_invariant", "literal_noncoordinate",
                "literal_one_stable", "stable_core_verify",
            }
            printed = dict(re.findall(
                r"'IndependentStableCore\.([^']+)'\s+depends on axioms:\s*\[([^\]]*)\]",
                official["stdout"],
            ))
            axioms = {
                name.strip() for names in printed.values() for name in names.split(",")
                if name.strip()
            }
            foundation_only = axioms <= {"propext", "Classical.choice", "Quot.sound"}
            complete = set(printed) == expected
            verified = (
                official.get("exit_code") == 0 and official.get("proof_holes") == []
                and official.get("kernel", {}).get("recorded") is not None
            )
            gate["printed_axioms"] = printed
            gate["axiom_gate"] = "passed" if complete and foundation_only and verified else "failed"
        (HERE / "formal_gate_result.json").write_text(json.dumps(gate, indent=2) + "\n")
        print(json.dumps(gate, indent=2), flush=True)
        if (any(row["exit_code"] for row in gate["commands"].values())
                or gate["axiom_gate"] != "passed"):
            raise SystemExit(1)


if __name__ == "__main__":
    main()
