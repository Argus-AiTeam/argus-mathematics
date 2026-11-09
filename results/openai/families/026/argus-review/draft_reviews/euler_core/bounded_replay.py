"""Replay only the inherited checker's finite, read-only components."""

import hashlib
import json
from pathlib import Path
import runpy
import sys
import time

import sympy


OLD = Path("campaigns/9000026")
SOURCE = OLD / "research/audit026/moments/verify.py"
EXPECTED = SOURCE.with_name("exact_certificate.json")
CALLS = {
    "local_factors": "local_factor_checks",
    "symbolic": "symbolic_checks",
    "support_and_deletion": "support_and_deletion_checks",
    "relative_route_obstruction": "zero_obstruction",
    "jacobian": "jacobian_replay",
}


def main():
    started = time.monotonic()
    before = SOURCE.read_bytes()
    namespace = runpy.run_path(str(SOURCE), run_name="bounded_review")
    expected = json.loads(EXPECTED.read_text())
    results = {key: namespace[function]() for key, function in CALLS.items()}
    matches = {key: value == expected[key] for key, value in results.items()}
    source_unchanged = before == SOURCE.read_bytes()
    record = {
        "kind": "fresh_bounded_exact_replay",
        "source": str(SOURCE),
        "source_sha256": hashlib.sha256(before).hexdigest(),
        "source_unchanged_during_replay": source_unchanged,
        "python": sys.version,
        "sympy": sympy.__version__,
        "command": [
            sys.executable,
            "-B",
            str(Path(__file__).resolve()),
        ],
        "function_calls": CALLS,
        "results": results,
        "matches_inherited_sections": matches,
        "elapsed_seconds": time.monotonic() - started,
        "not_checked": [
            "The historical checker main(), certificate() and lean_replay() were not called.",
            "No new Lean compilation or live Jacobian call occurs in this replay.",
            "Prose assertions inside returned dictionaries are not computational proofs.",
            "Finite enumerations are not universal analytic theorems.",
        ],
        "exit_code": 0 if all(matches.values()) and source_unchanged else 1,
    }
    Path(__file__).with_name("finite_replay.json").write_text(
        json.dumps(record, indent=2) + "\n"
    )
    print(json.dumps({key: record[key] for key in (
        "kind", "matches_inherited_sections", "elapsed_seconds", "exit_code"
    )}))
    return record["exit_code"]


if __name__ == "__main__":
    raise SystemExit(main())
