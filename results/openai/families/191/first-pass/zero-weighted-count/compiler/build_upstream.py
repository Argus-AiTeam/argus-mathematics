"""Compile read-only upstream dependencies into this diagnostic directory."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time


ROOT = Path("openai-math/lean")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
OUTPUT = Path(__file__).resolve().parent
BUILD = OUTPUT / "upstream-olean"
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean")
TARGETS = (
    "OAI.Geometry.HeilbronnTriangle.AuxiliaryZeroCount",
    "OAI.Geometry.HeilbronnTriangle.ZeroRowData",
)
COMPATIBILITY_NAMES = (
    ("Finset.prod_le_prod₀", "Finset.prod_le_prod"),
    ("dite_eq_left", "dif_pos"),
    ("dite_eq_right", "dif_neg"),
    ("ite_eq_left", "if_pos"),
    ("ite_eq_right", "if_neg"),
    ("Set.mem_ofPred_eq", "Set.mem_setOf_eq"),
)
MODULE_PATCHES = {
    "OAI.Geometry.HeilbronnTriangle.LatticeResidues": (
        ("      apply prod_le_prod\n",
         "      apply prod_le_prod (fun _ _ => Nat.zero_le _)\n"),
    ),
    "OAI.Geometry.HeilbronnTriangle.OrbitEstimate": (
        (
            "Matrix.GeneralLinearGroup.det_surjective",
            """(by
        intro u
        let A : Matrix (Fin 3) (Fin 3) (ZMod (p ^ k)) :=
          Matrix.diagonal ![(u : ZMod (p ^ k)), 1, 1]
        have hA : A.det = (u : ZMod (p ^ k)) := by
          simp [A, Matrix.det_diagonal, Fin.prod_univ_three]
        refine ⟨Matrix.GeneralLinearGroup.mk'' A ?_, ?_⟩
        · rw [hA]
          exact u.isUnit
        · apply Units.ext
          change A.det = (u : ZMod (p ^ k))
          exact hA)""",
        ),
    ),
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    order = []
    seen = set()

    def visit(module):
        if module in seen:
            return
        seen.add(module)
        source = ROOT.joinpath(*module.split(".")).with_suffix(".lean")
        for line in source.read_text().splitlines():
            if line.startswith("import "):
                for dependency in line.split()[1:]:
                    if dependency.startswith("OAI."):
                        visit(dependency)
        order.append((module, source))

    for target in TARGETS:
        visit(target)
    inherited = subprocess.check_output(
        ["lake", "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE, text=True
    ).strip()
    environment = dict(os.environ, LEAN_PATH=f"{BUILD}:{inherited}")
    report_path = OUTPUT / "upstream-build.json"
    previous = {}
    if report_path.exists():
        previous = {
            entry["module"]: entry
            for entry in json.loads(report_path.read_text())["modules"]
            if entry["exit_code"] == 0
        }
    report = {
        "lean": str(LEAN),
        "workspace": str(WORKSPACE),
        "upstream_root": str(ROOT),
        "upstream_toolchain": (ROOT / "lean-toolchain").read_text().strip(),
        "target_toolchain": "leanprover/lean4:v4.31.0",
        "module_count": len(order),
        "modules": [],
        "status": "running",
    }
    for index, (module, source) in enumerate(order, 1):
        artifact = BUILD.joinpath(*module.split(".")).with_suffix(".olean")
        artifact.parent.mkdir(parents=True, exist_ok=True)
        log = OUTPUT / f"{module.rsplit('.', 1)[-1]}.log"
        original = source.read_text()
        effective = original
        replacements = []
        for old, new in (*COMPATIBILITY_NAMES, *MODULE_PATCHES.get(module, ())):
            if old in effective:
                effective = effective.replace(old, new)
                replacements.append({"from": old, "to": new})
        source_hash = hashlib.sha256(source.read_bytes()).hexdigest()
        effective_hash = hashlib.sha256(effective.encode()).hexdigest()
        cached = previous.get(module)
        if (
            not args.force and cached and cached["source_sha256"] == source_hash and artifact.exists()
            and cached.get("effective_source_sha256", source_hash) == effective_hash
        ):
            report["modules"].append(dict(cached, reused_success=True))
            print(f"[{index}/{len(order)}] {module}: reusing checked artifact", flush=True)
            report_path.write_text(json.dumps(report, indent=2) + "\n")
            continue
        command = [
            str(LEAN), "-j", "2", "--root", str(ROOT),
            "-o", str(artifact), str(source),
        ]
        if effective != original:
            command.insert(1, "--stdin")
        start = time.monotonic()
        with log.open("w") as stream:
            result = subprocess.run(
                command, cwd=ROOT, env=environment, stdout=stream,
                stderr=subprocess.STDOUT, timeout=180,
                input=effective if effective != original else None, text=True,
            )
        item = {
            "module": module,
            "source_sha256": source_hash,
            "effective_source_sha256": effective_hash,
            "compatibility_replacements": replacements,
            "command": command,
            "exit_code": result.returncode,
            "seconds": round(time.monotonic() - start, 3),
            "log": str(log),
        }
        report["modules"].append(item)
        print(f"[{index}/{len(order)}] {module}: exit={result.returncode}", flush=True)
        if result.returncode:
            report["status"] = "blocked"
            report["first_failing_module"] = module
            report_path.write_text(json.dumps(report, indent=2) + "\n")
            print(log.read_text(), flush=True)
            return result.returncode
        report_path.write_text(json.dumps(report, indent=2) + "\n")
    report["status"] = "completed"
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
