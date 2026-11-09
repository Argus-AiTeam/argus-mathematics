"""Replay the preserved algebraic source without writing into the old project."""

import json
from pathlib import Path
import subprocess
import time


HERE = Path(__file__).resolve().parent
OLD = Path("campaigns/9000055")
SOURCE = OLD / "research/gepner-aisle-audit/Main.lean"
FIDELITY = SOURCE.with_name("statement_fidelity.md")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LAKE = "$WORKSPACE/.elan/bin/lake"
AUDIT = "$WORKSPACE/argus-latest/argus_skill/tools/lean_axiom_audit.lean"


def run(command):
    start = time.monotonic()
    try:
        result = subprocess.run(
            command, cwd=WORKSPACE, capture_output=True, text=True, timeout=180
        )
    except subprocess.TimeoutExpired as error:
        return {
            "command": command,
            "exit_code": None,
            "status": "timeout",
            "duration_seconds": time.monotonic() - start,
            "stdout": (error.stdout or b"").decode(),
            "stderr": (error.stderr or b"").decode(),
        }
    return {
        "command": command,
        "exit_code": result.returncode,
        "status": "success" if result.returncode == 0 else "failed",
        "duration_seconds": time.monotonic() - start,
        "stdout": result.stdout,
        "stderr": result.stderr,
    }


source_before = SOURCE.read_bytes()
fidelity_before = FIDELITY.read_bytes()
certificate = json.loads(
    (SOURCE.parent / "lean-evidence/certificates/C55_CORE-16b808fb34f65fe6.json")
    .read_text()
)
result = {
    "kind": "read_only_compiler_replay_not_new_kernel_ledger_evidence",
    "source": str(SOURCE),
    "statement_fidelity": str(FIDELITY),
    "workspace": str(WORKSPACE),
    "lean_version": run([LAKE, "env", "lean", "--version"]),
    "lake_version": run([LAKE, "--version"]),
    "source_matches_successful_historical_certificate": (
        source_before.decode() == certificate["lean_source"]["text"]
    ),
    "fidelity_matches_successful_historical_certificate": (
        fidelity_before.decode() == certificate["statement_fidelity"]["text"]
    ),
    "compiler": run([LAKE, "env", "lean", str(SOURCE)]),
}
if result["compiler"]["status"] == "success":
    result["axiom_audit"] = run(
        [LAKE, "env", "lean", "--run", AUDIT, str(SOURCE)]
    )
else:
    result["axiom_audit"] = {"status": "not_run_after_compiler_failure"}
result["source_unchanged_during_replay"] = SOURCE.read_bytes() == source_before
result["fidelity_unchanged_during_replay"] = FIDELITY.read_bytes() == fidelity_before
result["scope"] = (
    "Universal real algebra only. The source and fidelity are old read-only "
    "inputs. No new Lean source, certificate or mechanical ledger status is "
    "minted. Categorical statement fidelity remains a human obligation."
)
path = HERE / "lean_replay.json"
path.write_text(json.dumps(result, indent=2) + "\n")
ok = (
    result["compiler"]["status"] == "success"
    and result["axiom_audit"]["status"] == "success"
    and result["source_matches_successful_historical_certificate"]
    and result["fidelity_matches_successful_historical_certificate"]
    and result["source_unchanged_during_replay"]
    and result["fidelity_unchanged_during_replay"]
)
print(json.dumps({"ok": ok, "result": str(path)}))
raise SystemExit(0 if ok else 1)
