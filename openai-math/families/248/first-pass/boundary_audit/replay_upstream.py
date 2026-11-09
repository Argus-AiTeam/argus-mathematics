#!/usr/bin/env python3
"""Replay only FiniteBoundary's OAI closure against the read-only Lean 4.31 host.

Missing sources are copied; --refresh restores the exact recorded API patches.
Source/dependency/output hashes govern cache reuse. Reports, compiler logs, and
the wrapper API are written under upstream/.replay; no Lake project is created.
"""

import argparse
import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import time
from datetime import datetime, timezone


ROOT = Path(__file__).resolve().parent / "upstream"
SOURCE = Path("openai-math/lean")
MATHLIB = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
TARGET = "OAI.GroupTheory.Thompson.FiniteBoundary"
OPTIONS = ["-DautoImplicit=false", "-j2", "-M8192"]
# Exact source-to-4.31 compatibility substitutions, applied also by --refresh.
PATCHES = {
    f"OAI.GroupTheory.Thompson.{name}": [
        ("import Mathlib.Basic.Real.Basic\n", "import Mathlib.Data.Real.Basic\n")
    ]
    for name in ("BasicInterval", "DyadicArithmetic", "FiniteAverage", "BoundaryAlgebra")
}
TOKEN_RENAMES = {
    "ite_eq_left": "if_pos",
    "ite_eq_right": "if_neg",
    "dite_eq_left": "dif_pos",
    "dite_eq_right": "dif_neg",
}
PROBE = f"""import {TARGET}
#check @OAI.ThompsonNonamenability.exists_fixed_boundary
#print axioms OAI.ThompsonNonamenability.exists_fixed_boundary
#print OAI.ThompsonNonamenability.F
#print OAI.ThompsonNonamenability.globalColor
#print OAI.ThompsonNonamenability.fixedTransportSet
#print OAI.ThompsonNonamenability.boundaryRatio
#print OAI.ThompsonNonamenability.boundaryConstant
#print OAI.ThompsonNonamenability.UnitBall
#print OAI.ThompsonNonamenability.IntervalIndex
#print OAI.ThompsonNonamenability.leftTranslate
"""


def digest(data):
    return hashlib.sha256(data).hexdigest()


def file_hash(path):
    return digest(path.read_bytes())


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    pending = path.with_name(path.name + ".new")
    pending.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    pending.replace(path)


def code_only(text):
    """Blank nested Lean comments and strings without changing line positions."""
    out = list(text)
    i, depth, string = 0, 0, False
    while i < len(text):
        if depth:
            if text.startswith("/-", i):
                out[i:i + 2] = "  "
                depth += 1
                i += 2
            elif text.startswith("-/", i):
                out[i:i + 2] = "  "
                depth -= 1
                i += 2
            else:
                if text[i] != "\n":
                    out[i] = " "
                i += 1
        elif string:
            out[i] = "\n" if text[i] == "\n" else " "
            if text[i] == "\\" and i + 1 < len(text):
                out[i + 1] = " "
                i += 2
            else:
                if text[i] == '"':
                    string = False
                i += 1
        elif text.startswith("--", i):
            end = text.find("\n", i)
            end = len(text) if end < 0 else end
            out[i:end] = " " * (end - i)
            i = end
        elif text.startswith("/-", i):
            out[i:i + 2] = "  "
            depth = 1
            i += 2
        elif text[i] == '"':
            out[i] = " "
            string = True
            i += 1
        else:
            i += 1
    if depth or string:
        raise ValueError("Unterminated Lean comment or string")
    return "".join(out)


def imports(text):
    lines = re.findall(
        r"(?m)^\s*(?:(?:public|private|meta)\s+)*import[ \t]+([^\n]+)",
        code_only(text),
    )
    return [module for line in lines for module in line.split()]


def module_path(root, module, suffix=".lean"):
    if not re.fullmatch(r"OAI(?:\.[A-Za-z_][A-Za-z_0-9]*)+", module):
        raise ValueError(f"Not an individual OAI module: {module}")
    path = root.joinpath(*module.split(".")).with_suffix(suffix)
    if not path.resolve().is_relative_to(root.resolve()):
        raise ValueError(f"Module path escapes root: {path}")
    return path


def wrapper_api():
    declarations = {
        "exists_fixed_boundary": "FiniteBoundary",
        "F": "Model",
        "globalColor": "GlobalColors",
        "fixedTransportSet": "TransportFamily",
        "boundaryRatio": "FiniteAverage",
        "boundaryConstant": "BoundaryAlgebra",
        "UnitBall": "UnitBall",
        "IntervalIndex": "IntervalFamily",
        "leftTranslate": "FiniteAverage",
    }
    api = {"namespace": "OAI.ThompsonNonamenability",
           "hilbert_context": "{E : Type uE} [NormedAddCommGroup E] [InnerProductSpace ℝ E]",
           "boundaryRatio_context": "{G : Type uG} [Group G] [DecidableEq G]"}
    for name, file in declarations.items():
        text = module_path(ROOT, f"OAI.GroupTheory.Thompson.{file}").read_text()
        start = re.search(
            r"(?m)^(?:noncomputable )?(?:def|abbrev|theorem) " + name + r"\b", text
        ).start()
        block = text[start:].partition("\n\n")[0]
        api[name] = block.partition(" := by")[0] if name == "exists_fixed_boundary" else block
    return api


def prepare(source, refresh):
    order, dependencies, diffs, visiting = [], {}, {}, set()

    def visit(module):
        if module in visiting:
            raise ValueError(f"Import cycle at {module}")
        if module in dependencies:
            return
        visiting.add(module)
        origin = module_path(source, module)
        local = module_path(ROOT, module)
        upstream = origin.read_text()
        if refresh or not local.exists():
            text = upstream
            for before, after in PATCHES.get(module, []):
                if text.count(before) != 1:
                    raise ValueError(f"Portability patch no longer matches {module}: {before!r}")
                text = text.replace(before, after, 1)
            for before, after in TOKEN_RENAMES.items():
                text = re.sub(r"\b" + before + r"\b", after, text)
            local.parent.mkdir(parents=True, exist_ok=True)
            if not local.exists() or local.read_text() != text:
                local.write_text(text)
        text = local.read_text()
        clean = code_only(text)
        banned = re.search(
            r"\b(?:sorry|admit|axiom|unsafe|native_decide)\b|debug\.skipKernelTC", clean
        )
        if banned:
            raise ValueError(f"Forbidden proof construct in {local}: {banned.group()}")
        direct = imports(text)
        if any(m.startswith("ComparatorChallenges") for m in direct):
            raise ValueError(f"ComparatorChallenges import in {local}")
        for dep in sorted(m for m in direct if m.startswith("OAI")):
            visit(dep)
        dependencies[module] = direct
        visiting.remove(module)
        order.append(module)
        if text != upstream:
            diffs[module] = "".join(difflib.unified_diff(
                upstream.splitlines(True), text.splitlines(True),
                fromfile=f"readonly-upstream/{module.replace('.', '/')}.lean",
                tofile=f"local-4.31/{module.replace('.', '/')}.lean",
            ))

    visit(TARGET)
    return order, dependencies, diffs


def run(command, cwd, env, timeout, log, input_text=None):
    process = subprocess.Popen(
        command, cwd=cwd, env=env, stdin=subprocess.PIPE if input_text is not None else None,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, start_new_session=True,
    )
    try:
        output, _ = process.communicate(input_text, timeout=timeout)
        exit_code = process.returncode
    except subprocess.TimeoutExpired:
        try:
            os.killpg(process.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
        try:
            output, _ = process.communicate(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            output, _ = process.communicate()
        output += f"\nReplay timeout after {timeout:.1f} seconds.\n"
        exit_code = 124
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_text(output)
    return exit_code, output


def output_hashes(source):
    output = source.with_suffix(".olean")
    return {
        str(p.relative_to(ROOT)): file_hash(p)
        for p in sorted(output.parent.glob(output.name + "*")) if p.is_file()
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, default=SOURCE)
    parser.add_argument("--mathlib", type=Path, default=MATHLIB)
    parser.add_argument("--refresh", action="store_true",
                        help="Restore closure sources from upstream plus exact recorded patches")
    parser.add_argument("--copy-only", action="store_true")
    parser.add_argument("--per-module-timeout", type=float, default=180)
    parser.add_argument("--total-timeout", type=float, default=1800)
    args = parser.parse_args()
    if args.per_module_timeout <= 0 or args.total_timeout <= 0:
        parser.error("timeouts must be positive")
    ROOT.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    work = ROOT / ".replay" / stamp
    report = {
        "target": TARGET, "status": "running", "run": stamp,
        "source_root": str(args.source_root), "local_root": str(ROOT),
        "mathlib": str(args.mathlib), "results": [], "compile_options": OPTIONS,
        "parent_environment": {
            "LEAN_PATH": str(ROOT),
            "ARGUS_SKILL_MATHLIB_WORKSPACE": str(args.mathlib.resolve()),
        },
    }
    state_path = ROOT / ".replay" / "cache.json"
    state = json.loads(state_path.read_text()) if state_path.exists() else {}
    deadline = time.monotonic() + args.total_timeout

    def persist():
        write_json(work / "report.json", report)
        write_json(ROOT / ".replay" / "last_run.json", report)
        write_json(state_path, state)

    def remaining():
        seconds = min(args.per_module_timeout, deadline - time.monotonic())
        if seconds <= 0:
            raise TimeoutError("Replay total-time budget exhausted")
        return seconds

    try:
        order, dependencies, diffs = prepare(args.source_root.resolve(), args.refresh)
        report.update(module_count=len(order), topological_order=order, portability_diffs=diffs)
        report["source_sha256"] = {
            module: {
                "upstream": file_hash(module_path(args.source_root, module)),
                "local": file_hash(module_path(ROOT, module)),
            } for module in order
        }
        report["wrapper_api"] = wrapper_api()
        print(f"OAI closure: {len(order)} modules; source patches: {len(diffs)}", flush=True)
        if args.copy_only:
            report["status"] = "copied_only"
            persist()
            return 0
        env = os.environ.copy()
        env["PYTHONDONTWRITEBYTECODE"] = "1"
        inherited = [p for p in env.get("LEAN_PATH", "").split(os.pathsep)
                     if p and Path(p).resolve() != ROOT]
        env["LEAN_PATH"] = os.pathsep.join([str(ROOT), *inherited])
        for label, command in (
            ("version", ["lake", "env", "lean", "--version"]),
            ("lean_path", ["lake", "env", "printenv", "LEAN_PATH"]),
        ):
            exit_code, output = run(command, args.mathlib, env, remaining(), work / f"{label}.log")
            report[label] = output.strip()
            if exit_code:
                raise RuntimeError(f"{label} exited {exit_code}: {output.strip()}")
        if not report["version"].startswith("Lean (version 4.31.0,"):
            raise RuntimeError(f"Wrong Lean version: {report['version']}")
        search_path = [Path(p) for p in report["lean_path"].split(os.pathsep) if p]
        if ROOT not in search_path:
            raise RuntimeError("Host lake env did not retain the local module root in LEAN_PATH")
        external = {}
        for module in sorted({m for ds in dependencies.values() for m in ds
                              if not m.startswith("OAI")}):
            relative = Path(*module.split(".")).with_suffix(".olean")
            found = next((base / relative for base in search_path
                          if (base / relative).is_file()), None)
            external[module] = (
                {str(p): file_hash(p) for p in sorted(found.parent.glob(found.name + "*"))}
                if found else {"missing": module}
            )
        context = digest(json.dumps(
            [report["version"], report["lean_path"], OPTIONS, external], sort_keys=True
        ).encode())
        for module in order:
            source = module_path(ROOT, module)
            output = source.with_suffix(".olean")
            deps = {
                dep: state[dep]["outputs"]
                for dep in dependencies[module] if dep.startswith("OAI")
            }
            fingerprint = digest(json.dumps(
                [context, file_hash(source), deps], sort_keys=True
            ).encode())
            cached = state.get(module, {})
            artifacts = output_hashes(source)
            if (cached.get("fingerprint") == fingerprint and output.is_file()
                    and cached.get("outputs") == artifacts):
                report["results"].append({
                    "module": module, "status": "cached", "compile_exit_code": None,
                    "previous_compile_exit_code": 0, "previous_log": cached["log"],
                })
                print(f"CACHED {module}", flush=True)
                persist()
                continue
            state.pop(module, None)
            for path in artifacts:
                (ROOT / path).unlink()
            log = work / (module.replace(".", "_") + ".log")
            command = ["lake", "env", "lean", *OPTIONS, "-R", str(ROOT),
                       "-o", str(output), str(source)]
            print(f"COMPILE {module}", flush=True)
            exit_code, text = run(command, args.mathlib, env, remaining(), log)
            result = {
                "module": module, "status": "compiled" if exit_code == 0 else "failed",
                "compile_exit_code": exit_code, "command": command, "log": str(log),
            }
            report["results"].append(result)
            if exit_code == 0 and not output.is_file():
                raise RuntimeError(f"Compiler exited zero without producing {output}")
            if exit_code:
                report["status"] = "failed"
                persist()
                print(text, end="", flush=True)
                print(f"FAILED {module}; exit={exit_code}; receipt={work / 'report.json'}",
                      flush=True)
                return exit_code if 0 < exit_code < 256 else 1
            state[module] = {
                "fingerprint": fingerprint, "outputs": output_hashes(source),
                "compile_exit_code": 0, "log": str(log), "compiled_run": stamp,
            }
            persist()
            print(f"OK exit=0 {module}", flush=True)
        exit_code, output = run(
            ["lake", "env", "lean", *OPTIONS, "--stdin"], args.mathlib, env,
            remaining(), work / "probe.log", PROBE,
        )
        report["probe"] = {
            "exit_code": exit_code, "log": str(work / "probe.log"), "source": PROBE,
        }
        axioms = re.search(
            r"'OAI\.ThompsonNonamenability\.exists_fixed_boundary' "
            r"depends on axioms: \[([^\]]*)\]", output,
        )
        report["axioms"] = (
            [a.strip() for a in axioms.group(1).split(",") if a.strip()] if axioms else None
        )
        report["standard_axioms_only"] = (
            exit_code == 0 and axioms is not None
            and set(report["axioms"]) <= {"propext", "Classical.choice", "Quot.sound"}
        )
        if exit_code == 0 and not report["standard_axioms_only"]:
            exit_code = 1
        report["status"] = "success" if exit_code == 0 else "probe_failed"
        report["compiled_count"] = sum(r["status"] == "compiled" for r in report["results"])
        report["cached_count"] = sum(r["status"] == "cached" for r in report["results"])
        persist()
        print(output, end="", flush=True)
        print(f"{report['status'].upper()}: compiled={report['compiled_count']} "
              f"cached={report['cached_count']} modules={len(order)} "
              f"probe_exit={exit_code}; receipt={work / 'report.json'}", flush=True)
        return exit_code if 0 <= exit_code < 256 else 1
    except (OSError, ValueError, RuntimeError, TimeoutError) as exc:
        report.update(status="error", error=str(exc))
        persist()
        print(f"ERROR: {exc}; receipt={work / 'report.json'}", file=sys.stderr, flush=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
