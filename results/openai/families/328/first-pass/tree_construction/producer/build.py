#!/usr/bin/env python3
"""Rebuild the complete pinned producer closure with the host Lean 4.31.0."""

from __future__ import annotations

import argparse
import datetime
import difflib
import hashlib
import json
import os
import pathlib
import re
import subprocess
import sys
import time

from fetch_sources import ENTRY, FORBIDDEN, imports, uncomment

ROOT = pathlib.Path(__file__).resolve().parent
DEFAULT_MATHLIB = pathlib.Path(
    "$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
)
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
PRINCIPALS = (
    "OAI.ReflexiveFixedPoints.switchingTreeDataOfAnchor",
    "OAI.ReflexiveFixedPoints.exists_switchingTreeData",
    "OAI.ReflexiveFixedPoints.SwitchingTreeData.terminalDefect_tendsto",
    "OAI.ReflexiveFixedPoints.TreeEvaluation.pathDisplacement_eq_sum",
)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mathlib", type=pathlib.Path, default=DEFAULT_MATHLIB)
    parser.add_argument(
        "--resume",
        action="store_true",
        help="Reuse successful outputs whose source and dependencies are unchanged",
    )
    arguments = parser.parse_args()
    start = time.monotonic()
    build = ROOT / "build"
    outputs = build / "lib" / "lean"
    logs = build / "logs"
    outputs.mkdir(parents=True, exist_ok=True)
    logs.mkdir(parents=True, exist_ok=True)
    result_path = build / "result.json"
    report: dict[str, object] = {
        "started_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "status": "running",
        "mathlib_workspace": str(arguments.mathlib.resolve()),
        "compiled": [],
        "reused": [],
    }

    def persist() -> None:
        report["elapsed_seconds"] = time.monotonic() - start
        result_path.write_text(json.dumps(report, indent=2) + "\n")

    try:
        base_environment = os.environ.copy()
        # Lake supplies the already-built host Mathlib and all of its packages.
        path_result = subprocess.run(
            ["lake", "env", "printenv", "LEAN_PATH"],
            cwd=arguments.mathlib,
            check=True,
            capture_output=True,
            text=True,
        )
        environment = base_environment.copy()
        environment["LEAN_PATH"] = os.pathsep.join(
            (str(outputs), str(ROOT), path_result.stdout.strip())
        )
        report["LEAN_PATH"] = environment["LEAN_PATH"]
        version = subprocess.run(
            ["lake", "env", "lean", "--version"],
            cwd=arguments.mathlib,
            env=environment,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()
        report["compiler_version"] = version
        if not re.search(r"\bversion 4\.31\.0\b", version):
            raise RuntimeError(f"Wrong compiler: {version}")
        print(version, flush=True)

        modules: dict[str, dict[str, object]] = {}
        order: list[str] = []
        visiting: set[str] = set()

        def visit(module: str) -> None:
            if module in visiting:
                raise RuntimeError(f"Import cycle at {module}")
            if module in modules:
                return
            if module.split(".")[-1] in FORBIDDEN:
                raise RuntimeError(f"Forbidden dependency: {module}")
            visiting.add(module)
            source = ROOT / (module.replace(".", "/") + ".lean")
            text = source.read_text()
            clean = uncomment(text)
            if re.search(r"\b(?:sorry|admit|axiom)\b", clean):
                raise RuntimeError(f"Proof hole or unproved axiom in {source}")
            dependencies = imports(text)
            for dependency in dependencies:
                if dependency.startswith("OAI."):
                    visit(dependency)
            modules[module] = {
                "source": str(source.relative_to(ROOT)),
                "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                "imports": dependencies,
            }
            visiting.remove(module)
            order.append(module)

        visit(ENTRY)
        visit("Producer")
        manifest = json.loads((ROOT / "source_manifest.json").read_text())
        actual_upstream_modules = set(modules) - {"Producer"}
        if actual_upstream_modules != set(manifest["modules"]):
            raise RuntimeError("The local producer closure differs from the pinned closure")
        modified: list[str] = []
        changes: list[str] = []
        local_false_eliminations: list[dict[str, object]] = []
        for module in order:
            if module == "Producer":
                continue
            source = ROOT / str(modules[module]["source"])
            original = ROOT / "upstream" / manifest["modules"][module]["upstream_path"]
            original_bytes = original.read_bytes()
            if hashlib.sha256(original_bytes).hexdigest() != manifest["modules"][module]["upstream_sha256"]:
                raise RuntimeError(f"Upstream source hash mismatch: {original}")
            if original_bytes != source.read_bytes():
                modified.append(module)
                changes.extend(
                    difflib.unified_diff(
                        original_bytes.decode().splitlines(keepends=True),
                        source.read_text().splitlines(keepends=True),
                        fromfile=str(original.relative_to(ROOT)),
                        tofile=str(source.relative_to(ROOT)),
                    )
                )
            for line_number, line in enumerate(uncomment(source.read_text()).splitlines(), 1):
                if "False.elim" in line:
                    local_false_eliminations.append(
                        {"module": module, "line": line_number, "source": line.strip()}
                    )
        (build / "port_changes.diff").write_text("".join(changes))
        critical = (
            "Basic",
            "OrderedTree",
            "WeightedTree",
            "TreeEvaluation",
            "SwitchingTreeData",
            "TreeProducer",
        )
        for short_name in critical:
            module = f"OAI.Analysis.Nonexpansive.{short_name}"
            source = ROOT / str(modules[module]["source"])
            original = ROOT / "upstream" / manifest["modules"][module]["upstream_path"]

            def without_imports(text: str) -> str:
                return re.sub(r"(?m)^\s*import[^\n]*", "", uncomment(text)).strip()

            if without_imports(source.read_text()) != without_imports(original.read_text()):
                raise RuntimeError(f"Critical upstream declarations were changed: {module}")
        report["upstream_revision"] = manifest["revision"]
        report["modified_upstream_modules"] = modified
        report["source_count"] = len(order)
        report["dependency_order"] = order
        (build / "dependency_inspection.json").write_text(
            json.dumps(
                {
                    "entry": ENTRY,
                    "forbidden_modules": sorted(FORBIDDEN),
                    "forbidden_modules_present": [],
                    "hole_tokens_present": [],
                    "non_mathlib_external_imports": [
                        module for module in manifest["external_imports"]
                        if not module.startswith("Mathlib.")
                    ],
                    "critical_declarations_unchanged": list(critical),
                    "local_false_eliminations": local_false_eliminations,
                    "signature_inspection_log": "build/logs/Producer.log",
                    "modules": modules,
                },
                indent=2,
            )
            + "\n"
        )
        fingerprints: dict[str, str] = {}
        persist()
        for index, module in enumerate(order, 1):
            source = ROOT / str(modules[module]["source"])
            output = outputs / (module.replace(".", "/") + ".olean")
            stamp = output.with_suffix(".build.json")
            log = logs / (module.replace(".", "__") + ".log")
            digest = hashlib.sha256(
                json.dumps(
                    {
                        "version": version,
                        "source": modules[module]["sha256"],
                        "dependencies": {
                            dependency: fingerprints[dependency]
                            for dependency in modules[module]["imports"]
                            if dependency in fingerprints
                        },
                    },
                    sort_keys=True,
                ).encode()
            ).hexdigest()
            fingerprints[module] = digest
            if arguments.resume and output.is_file() and stamp.is_file():
                previous = json.loads(stamp.read_text())
                if previous.get("fingerprint") == digest and log.is_file():
                    report["reused"].append(module)
                    print(f"[{index}/{len(order)}] reuse {module}", flush=True)
                    continue
            output.parent.mkdir(parents=True, exist_ok=True)
            output.unlink(missing_ok=True)
            stamp.unlink(missing_ok=True)
            command = [
                "lake",
                "env",
                "lean",
                f"--root={ROOT}",
                "-o",
                str(output),
                str(source),
            ]
            print(f"[{index}/{len(order)}] compile {module}", flush=True)
            module_start = time.monotonic()
            with log.open("w") as stream:
                compilation = subprocess.run(
                    command,
                    cwd=arguments.mathlib,
                    env=environment,
                    stdout=stream,
                    stderr=subprocess.STDOUT,
                    text=True,
                )
            if compilation.returncode:
                report["failed_module"] = module
                report["failure_log"] = str(log.relative_to(ROOT))
                report["compiler_exit_code"] = compilation.returncode
                print(log.read_text(), flush=True)
                raise RuntimeError(f"Lean failed on {module}: exit {compilation.returncode}")
            if not output.is_file():
                raise RuntimeError(f"Lean produced no output for {module}")
            stamp.write_text(
                json.dumps(
                    {
                        "fingerprint": digest,
                        "elapsed_seconds": time.monotonic() - module_start,
                        "compiler_exit_code": 0,
                    },
                    indent=2,
                )
                + "\n"
            )
            report["compiled"].append(module)
            persist()

        top_log = (logs / "Producer.log").read_text()
        principal_axioms: dict[str, list[str]] = {}
        for principal in PRINCIPALS:
            match = re.search(
                re.escape("'" + principal + "'")
                + r"\s+depends on axioms:\s*\[([^\]]*)\]",
                top_log,
                flags=re.DOTALL,
            )
            if not match:
                raise RuntimeError(f"Missing #print axioms output for {principal}")
            axioms = [part.strip() for part in match.group(1).split(",") if part.strip()]
            if not set(axioms) <= ALLOWED_AXIOMS:
                raise RuntimeError(f"Nonstandard principal axioms: {principal}: {axioms}")
            principal_axioms[principal] = axioms
        report["principal_axioms"] = principal_axioms
        report["proof_holes"] = []
        report["compiled_objects"] = {
            module: {
                "path": str(
                    (outputs / (module.replace(".", "/") + ".olean")).relative_to(ROOT)
                ),
                "sha256": hashlib.sha256(
                    (outputs / (module.replace(".", "/") + ".olean")).read_bytes()
                ).hexdigest(),
                "source_sha256": modules[module]["sha256"],
            }
            for module in order
        }
        report["status"] = "passed"
        report["compiler_exit_code"] = 0
        print(top_log, end="", flush=True)
        persist()
        print(
            json.dumps(
                {
                    key: report[key]
                    for key in (
                        "status",
                        "compiler_version",
                        "source_count",
                        "elapsed_seconds",
                        "principal_axioms",
                    )
                }
            ),
            flush=True,
        )
        return 0
    except Exception as error:
        report["status"] = "failed"
        report["error"] = str(error)
        persist()
        print(f"BUILD FAILED: {error}", file=sys.stderr, flush=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
