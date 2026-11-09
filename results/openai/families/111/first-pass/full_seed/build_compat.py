#!/usr/bin/env python3
"""Compile the pinned theorem closure against the assigned Lean 4.31 workspace."""

import json
import os
from pathlib import Path
import re
import subprocess
import time


ROOT = Path(__file__).resolve().parent
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")


def main():
    closure = json.loads((ROOT / "upstream/import_closure.json").read_text())
    dependencies = closure["dependencies"]
    output = ROOT / "compat"
    output.mkdir(exist_ok=True)
    for module in dependencies:
        relative = Path(module.replace(".", "/") + ".lean")
        source = (ROOT / "upstream" / relative).read_text()
        lines = source.splitlines()
        imports = []
        body = []
        for line in lines:
            if re.match(r"^(?:public )?import Mathlib(?:\.|$)", line):
                if "import Mathlib" not in imports:
                    imports.append("import Mathlib")
            elif re.match(r"^(?:public )?import ", line):
                imports.append(line)
            else:
                body.append(line)
        destination = output / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        translated = "\n".join(imports + ["set_option autoImplicit false"] + body) + "\n"
        for old, new in {
            "ENat.natCast_toNat": "ENat.coe_toNat",
            "ite_eq_left": "if_pos",
            "ite_eq_right": "if_neg",
            "Measurable.of_eval": "measurable_pi_iff.mpr",
            "prod_le_prod₀": "prod_le_prod",
            "Set.mem_ofPred_eq": "Set.mem_setOf_eq",
            "Set.ofPred_forall": "Set.setOf_forall",
        }.items():
            translated = translated.replace(old, new)
        if module.endswith(".Density.Path"):
            translated = translated.replace(
                "(hJmono hi).trans subset_union_left",
                "Set.Subset.trans (hJmono hi) Set.subset_union_left",
            )
        if module.endswith(".Density.Guarded"):
            translated = translated.replace(
                "    intro i j hij\n    by_cases hi",
                "    intro i j hij\n    simp only [Set.le_eq_subset]\n    by_cases hi",
            )
        if module.endswith(".Gluing"):
            translated = translated.replace(
                "  have hj := glue_seed_joint_law",
                "  letI : IsProbabilityMeasure (μ.map V) :=\n"
                "    Measure.isProbabilityMeasure_map hV.aemeasurable\n"
                "  have hj := glue_seed_joint_law",
            )
        if module.endswith(".Algorithm.SeedLaw"):
            translated = translated.replace(
                "  inferInstanceAs (IsProbabilityMeasure ((mainBlockLaw n q h0 h1).map encodeMainSeed))",
                "  Measure.isProbabilityMeasure_map\n"
                "    (measurable_of_countable (encodeMainSeed (n := n))).aemeasurable",
            )
        if module.endswith(".GroupSafety"):
            translated = translated.replace(
                "  exact hij ((List.Nodup.getElem?_inj hi (groups_nodup M d s)).mp (hei.symm.trans hej))",
                "  have hj : j < (groups M d s).length := by\n"
                "    by_contra hj\n"
                "    exact hc.1 (hej.trans (List.getElem?_eq_none (by omega)))\n"
                "  have heq : (groups M d s)[i] = (groups M d s)[j] := by\n"
                "    simpa only [List.getElem?_eq_getElem hi, List.getElem?_eq_getElem hj,\n"
                "      Option.some.injEq] using hei.symm.trans hej\n"
                "  exact hij ((groups_nodup M d s).getElem_inj_iff.mp heq)",
            )
        if module.endswith(".Pivots.Entropy"):
            translated = translated.replace(
                "    convert hall using 1\n",
                "    convert hall using 1 <;> try rfl\n",
            )
        if not destination.exists() or destination.read_text() != translated:
            destination.write_text(translated)

    completed = set()
    failed = set()
    environment = dict(os.environ, LEAN_PATH=str(output))
    log = ROOT / "compat_build.json"
    records = json.loads(log.read_text())["records"] if log.exists() else []
    while len(completed) < len(dependencies):
        ready = sorted(
            module
            for module, imports in dependencies.items()
            if module not in completed | failed and all(name in completed for name in imports)
        )
        if not ready:
            if failed:
                print(json.dumps({
                    "failed": sorted(failed),
                    "blocked_modules": len(dependencies) - len(completed) - len(failed),
                }), flush=True)
                raise SystemExit(1)
            raise RuntimeError("The pinned OAI import graph has a cycle")
        for module in ready:
            source = output / (module.replace(".", "/") + ".lean")
            artifact = source.with_suffix(".olean")
            inputs = [source] + [
                output / (name.replace(".", "/") + ".olean")
                for name in dependencies[module]
            ]
            if artifact.exists() and all(
                artifact.stat().st_mtime_ns >= path.stat().st_mtime_ns for path in inputs
            ):
                completed.add(module)
                continue
            command = [
                "lake", "env", "lean", "--root=" + str(output),
                "-o", str(artifact), str(source),
            ]
            started = time.monotonic()
            result = subprocess.run(
                command, cwd=WORKSPACE, env=environment,
                text=True, capture_output=True, timeout=120,
            )
            record = {
                "module": module, "command": command, "exit_code": result.returncode,
                "seconds": round(time.monotonic() - started, 3),
                "stdout": result.stdout, "stderr": result.stderr,
            }
            records.append(record)
            log.write_text(
                json.dumps({"workspace": str(WORKSPACE), "records": records}, indent=2) + "\n"
            )
            print(json.dumps({key: record[key] for key in ("module", "exit_code", "seconds")}), flush=True)
            if result.returncode:
                print(result.stdout + result.stderr, flush=True)
                failed.add(module)
            else:
                completed.add(module)


if __name__ == "__main__":
    main()
