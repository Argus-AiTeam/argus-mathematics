#!/usr/bin/env python3
"""Observe one unchanged old-checker replay without writing its certificate."""

import contextlib
import hashlib
import json
import os
import platform
import runpy
import sys
import time
import traceback
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path


LOCAL = Path(__file__).resolve().parent
OLD = Path("families/039/first-pass/reshaping_audit")
SOURCE = OLD / "verify.py"
INPUTS = [
    SOURCE,
    OLD / "exact_certificate.json",
    OLD / "verification_task.json",
    *sorted(OLD.glob("jacobian_*.json")),
    OLD / "jacobian_stderr.txt",
]
STAGES = [
    "original_simplex",
    "nodal_weighted_least_terms",
    "shear_then_axis_1_compression",
    "unimodular_direction_change",
    "axis_0_compression",
    "axis_1_compression",
]


def save(name, value):
    (LOCAL / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def hashes():
    return {
        str(path): {"bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
        for path in INPUTS
    }


def now():
    return datetime.now(timezone.utc).isoformat()


def main():
    initial = hashes()
    save("replay_inputs_before.json", initial)
    certificate = {}
    ranks = []
    supports = []
    counters = defaultdict(int)

    def observe_return(frame, event, value):
        if event != "return":
            return observe_return
        name = frame.f_code.co_name
        values = frame.f_locals
        if name == "certificate" and isinstance(value, dict):
            certificate.update(value)
        elif name == "support_checks" and isinstance(value, dict):
            supports.append({
                "characteristic": values["prime"],
                "dimension": values["dimension"],
                "maximum_degree": values["maximum"],
                "intercepts": [str(x) for x in values["intercepts"]],
                "stages": [
                    {
                        "index": index,
                        "name": STAGES[index],
                        "degrees": {
                            str(degree): {
                                "support": sorted(exponents),
                                "label_multiplicities": [
                                    {"label": label, "count": count}
                                    for label, count in sorted(Counter(e[2:] for e in exponents).items())
                                ],
                            }
                            for degree, exponents in family.items()
                        },
                    }
                    for index, family in enumerate(values["families"])
                ],
            })
        elif name == "jet_rank" and isinstance(value, int):
            caller = frame.f_back
            enclosing_support = None
            enclosing_mixed = None
            while caller is not None:
                if caller.f_code.co_name == "support_checks":
                    enclosing_support = caller.f_locals
                elif caller.f_code.co_name == "mixed_jet_checks":
                    enclosing_mixed = caller.f_locals
                caller = caller.f_back
            if enclosing_support is None:
                raise RuntimeError("Unexpected jet-rank call outside the original support check.")
            context = enclosing_mixed if enclosing_mixed is not None else enclosing_support
            phase = "mixed_two_point" if enclosing_mixed is not None else "one_point"
            orders = tuple(values["orders"])
            key = (phase, values["prime"], enclosing_support["dimension"], context["N"], orders)
            ordinal = counters[key]
            counters[key] += 1
            tuple_count = len(context["tuples"]) if enclosing_mixed is not None else 1
            stage = ordinal // tuple_count
            ranks.append({
                "phase": phase,
                "characteristic": values["prime"],
                "dimension": enclosing_support["dimension"],
                "degree": context["N"],
                "orders": orders,
                "points": values["points"],
                "stage_index": stage,
                "stage": STAGES[stage],
                "normalized_tuple_index": ordinal % tuple_count,
                "columns": len(values["support"]),
                "rows": len(values["rows"]),
                "rank": value,
            })
        return observe_return

    def observe_call(frame, event, value):
        if (
            event == "call"
            and frame.f_code.co_filename == str(SOURCE)
            and frame.f_code.co_name in {"certificate", "support_checks", "jet_rank"}
        ):
            frame.f_trace_lines = False
            frame.f_trace_opcodes = False
            return observe_return
        return None

    metadata = {
        "state": "running",
        "started_at": now(),
        "command_argv": [sys.executable, str(Path(__file__).resolve())],
        "effective_old_script_argv": [str(SOURCE)],
        "entrypoint": "runpy.run_path(source, run_name='__main__')",
        "instrumentation": "Return-value-only tracing; original checker functions and assertions are unchanged.",
        "cwd": str(Path.cwd()),
        "python_executable": sys.executable,
        "python_executable_resolved": str(Path(sys.executable).resolve()),
        "python_version": sys.version,
        "python_implementation": platform.python_implementation(),
        "python_build": platform.python_build(),
        "python_optimize": sys.flags.optimize,
        "assertions_enabled": __debug__,
        "dont_write_bytecode": sys.dont_write_bytecode,
        "PYTHONDONTWRITEBYTECODE": os.environ.get("PYTHONDONTWRITEBYTECODE"),
        "certificate_writing_flag": False,
    }
    save("replay_execution.json", metadata)
    started = time.monotonic()
    exit_code = 0
    old_argv = sys.argv
    old_trace = sys.gettrace()
    with (LOCAL / "replay_stdout.txt").open("w") as out, (LOCAL / "replay_stderr.txt").open("w") as err:
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            try:
                sys.argv = [str(SOURCE)]
                sys.settrace(observe_call)
                runpy.run_path(str(SOURCE), run_name="__main__")
            except BaseException as exc:
                exit_code = exc.code if isinstance(exc, SystemExit) and isinstance(exc.code, int) else 1
                if exit_code:
                    traceback.print_exc()
            finally:
                sys.settrace(old_trace)
                sys.argv = old_argv
    final = hashes()
    save("replay_inputs_after.json", final)
    save("replay_stage_supports.json", {"stage_order": STAGES, "configurations": supports})
    save("replay_jet_ranks.json", {"stage_order": STAGES, "evaluations": ranks})
    actual = json.loads(json.dumps(certificate)) if certificate else None
    expected = json.loads((OLD / "exact_certificate.json").read_text())
    save("replay_certificate.json", actual)
    one_point = [r for r in ranks if r["phase"] == "one_point"]
    mixed = [r for r in ranks if r["phase"] == "mixed_two_point"]
    comparison = {
        "old_certificate": str(OLD / "exact_certificate.json"),
        "new_certificate": str(LOCAL / "replay_certificate.json"),
        "structured_equal": actual == expected,
        "byte_equality_not_required": True,
        "original_inputs_unchanged": initial == final,
        "rational_geometry_cases": actual.get("rational_geometry_cases") if actual else None,
        "support_compositions": len(actual.get("support_compositions", [])) if actual else None,
        "degree_configuration_count": sum(len(x["degrees"]) for x in actual["support_compositions"]) if actual else 0,
        "stage_count": len(STAGES),
        "one_point_jet_rank_evaluations": len(one_point),
        "mixed_jet_rank_evaluations": len(mixed),
        "total_jet_rank_evaluations": len(ranks),
        "one_point_monotonicity_inequalities": len(one_point) // 6 * 5,
        "mixed_maximum_monotonicity_inequalities": len(mixed) // (6 * 15) * 5,
        "node_identity_truncations": sum(x["node_identity_truncations"] for x in actual["support_compositions"]) if actual else 0,
    }
    save("replay_comparison.json", comparison)
    metadata.update({
        "state": "completed" if exit_code == 0 else "failed",
        "finished_at": now(),
        "duration_seconds": time.monotonic() - started,
        "exit_code": exit_code,
        "original_inputs_unchanged": initial == final,
        "structured_equal": actual == expected,
    })
    save("replay_execution.json", metadata)
    print(json.dumps({"exit_code": exit_code, **comparison}, sort_keys=True))
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
