#!/usr/bin/env python3
"""Replay the preserved verifier's bounded evidence without invoking its main."""

import sys

sys.dont_write_bytecode = True

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OLD = HERE.parents[3] / "9000024" / "research" / "prefix-collisions"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    output = args.output.resolve()
    if not output.is_relative_to(HERE):
        parser.error("output must be inside the owned exact-arithmetic directory")

    source = OLD / "verify.py"
    spec = importlib.util.spec_from_file_location("preserved_prefix_verifier", source)
    verifier = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(verifier)
    functions = {
        "source_bindings": verifier.source_bindings,
        "root": verifier.root_certificate,
        "uniform_decay": verifier.uniform_decay_certificate,
        "tuple_recovery": verifier.recovery_checks,
        "jacobian": verifier.jacobian_check,
        "lean": verifier.lean_check,
    }
    results = {key: function() for key, function in functions.items()}
    archived = json.loads((OLD / "exact_certificate.json").read_text())
    matches = {key: value == archived[key] for key, value in results.items()}
    if not all(matches.values()):
        raise AssertionError(f"archived diagnostic section mismatch: {matches}")

    files = [
        "verify.py",
        "exact_certificate.json",
        "jacobian_contract.json",
        "jacobian_payload.json",
        "jacobian_result.json",
        "lean_check.json",
        "Main.lean",
        "statement_fidelity.md",
    ]
    evidence = {
        "schema_version": 1,
        "status": "exact_checks_passed",
        "historical_directory": str(OLD),
        "verifier_import_name": spec.name,
        "historical_main_invoked": False,
        "bytecode_writes_disabled": sys.dont_write_bytecode,
        "input_sha256": {
            name: hashlib.sha256((OLD / name).read_bytes()).hexdigest()
            for name in files
        },
        "functions_replayed": [function.__name__ for function in functions.values()],
        "archived_sections_identical": matches,
        "results": results,
        "limits": {
            "source_bindings": "snippet equality only; no analytic-proof assessment",
            "jacobian": "checks historical typed output, not a fresh adapter invocation",
            "lean": "checks historical source-bound compiler receipt, not recompilation",
            "tuple_recovery": "480 diagnostics, not an arbitrary-n proof",
            "uniform_decay": "4096 is not an analytic effective H0",
            "independent_acceptance": "pending_native_reviewer",
        },
    }
    output.write_text(json.dumps(evidence, indent=2) + "\n")
    print(json.dumps({
        "status": evidence["status"],
        "output": str(output),
        "archived_sections_identical": all(matches.values()),
        "finite_diagnostic_cases": results["tuple_recovery"]["finite_diagnostic_only"]["cases"],
    }))


if __name__ == "__main__":
    main()
