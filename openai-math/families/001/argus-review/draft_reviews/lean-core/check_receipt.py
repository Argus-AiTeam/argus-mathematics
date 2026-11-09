#!/usr/bin/env python3
"""Check the historical claim-bound receipt without registering new evidence."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time


PROJECT = Path("campaigns/9200001")
OLD = PROJECT.parent / "9000001"
SOURCE = OLD / "research/prescribed-filtration-audit"
OUT = Path("research/draft_reviews/lean-core/replay.json")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LAKE = "$WORKSPACE/.elan/bin/lake"
DECLARATIONS = [
    "PrescribedFiltration.frobenius_basis_change",
    "PrescribedFiltration.representation_basis_change",
    "PrescribedFiltration.faithful_central_preimage",
    "PrescribedFiltration.propagate_tensor_equalities",
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalize(text):
    return "\n".join(line.rstrip() for line in text.strip().splitlines())


def command(argv, *, cwd=PROJECT, input_text=None):
    started = time.monotonic()
    try:
        result = subprocess.run(
            argv,
            cwd=cwd,
            input=input_text,
            text=True,
            capture_output=True,
            timeout=90,
            env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
            check=False,
        )
        return {
            "argv": argv,
            "cwd": str(cwd),
            "timeout_seconds": 90,
            "exit_code": result.returncode,
            "timed_out": False,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "duration_seconds": round(time.monotonic() - started, 3),
        }
    except subprocess.TimeoutExpired as error:
        def text(value):
            return value.decode(errors="replace") if isinstance(value, bytes) else value

        return {
            "argv": argv,
            "cwd": str(cwd),
            "timeout_seconds": 90,
            "exit_code": None,
            "timed_out": True,
            "stdout": text(error.stdout) or "",
            "stderr": text(error.stderr) or "",
            "duration_seconds": round(time.monotonic() - started, 3),
        }


def main():
    assert Path.cwd() == PROJECT
    files = [
        SOURCE / "Main.lean",
        SOURCE / "statement_fidelity.md",
        SOURCE / "lean-evidence/Main.lean",
        SOURCE / "lean-evidence/statement_fidelity.md",
        SOURCE / "lean-evidence/compile.log",
        SOURCE / "lean-evidence/lean_check.json",
        SOURCE / "lean-evidence/certificates/PF-CORE-1814cc54e847468b.json",
        SOURCE / "lean-submit.json",
        SOURCE / "exact_certificate.json",
        OLD / "research/MATH_STATE.json",
        OLD / "research/PROOF_GRAPH.json",
    ]
    before = {str(path): digest(path) for path in files}
    certificate_path = files[6]
    certificate = json.loads(certificate_path.read_text())
    receipt = json.loads((SOURCE / "lean-evidence/lean_check.json").read_text())
    ledger = json.loads((OLD / "research/MATH_STATE.json").read_text())
    claim = next(
        entry for entry in ledger["claims"]
        if entry["claim_id"] == "PF-CORE" and entry["version"] == 2
    )
    evidence = next(
        entry for entry in ledger["evidence"]
        if entry["evidence_id"] == certificate["evidence_id"]
    )
    source_text = (SOURCE / "Main.lean").read_text()
    fidelity_text = (SOURCE / "statement_fidelity.md").read_text()
    canonical = {
        "claim_id": claim["claim_id"],
        "natural_statement": normalize(claim["natural_statement"]),
        "formal_statement": normalize(claim["formal_statement"]),
        "context_hash": claim["context"]["content_hash"],
    }
    claim_digest = hashlib.sha256(
        json.dumps(
            canonical, sort_keys=True, separators=(",", ":"), ensure_ascii=False
        ).encode()
    ).hexdigest()
    checks = {
        "duplicate_source_bytes_match":
            files[0].read_bytes() == files[2].read_bytes(),
        "duplicate_fidelity_bytes_match":
            files[1].read_bytes() == files[3].read_bytes(),
        "certificate_embeds_exact_source":
            certificate["lean_source"]["text"] == source_text,
        "certificate_embeds_exact_fidelity":
            certificate["statement_fidelity"]["text"] == fidelity_text,
        "certificate_embeds_exact_compiler_receipt":
            certificate["lean_check"] == receipt,
        "source_hash_matches": digest(files[0]) == receipt["source_sha256"],
        "fidelity_hash_matches":
            digest(files[1]) == receipt["statement_fidelity_sha256"],
        "claim_formal_statement_is_exact_source":
            claim["formal_statement"] == source_text,
        "claim_hash_recomputed":
            claim_digest == claim["content_hash"]
            == certificate["subject"]["content_hash"],
        "claim_subject_matches_ledger_evidence":
            evidence["subject"] == certificate["subject"],
        "claim_is_PF_CORE_not_PF_REALIZATION":
            certificate["subject"]["subject_id"] == "PF-CORE",
        "historical_compile_succeeded":
            receipt["status"] == "success" and receipt["exit_code"] == 0,
        "historical_audit_succeeded": receipt["audit_exit_code"] == 0,
        "historical_proof_holes_empty": receipt["proof_holes"] == [],
        "historical_stdout_stderr_empty": all(
            receipt[key] == ""
            for key in ("stdout", "stderr", "audit_stdout", "audit_stderr")
        ),
    }
    assert all(checks.values()), checks
    manifest_path = WORKSPACE / "lake-manifest.json"
    manifest = json.loads(manifest_path.read_text())
    mathlib = next(p for p in manifest["packages"] if p["name"] == "mathlib")
    versions = {
        "lean": command([LAKE, "env", "lean", "--version"], cwd=WORKSPACE),
        "lake": command([LAKE, "--version"], cwd=WORKSPACE),
        "elan": command(["$WORKSPACE/.elan/bin/elan", "--version"]),
    }
    appendix = "\n" + "\n".join("#print axioms " + name for name in DECLARATIONS) + "\n"
    stdin_run = command(
        [LAKE, "env", "lean", "--stdin"],
        cwd=WORKSPACE,
        input_text=source_text + appendix,
    )
    stdin_run["stdin"] = {
        "existing_source": str(SOURCE / "Main.lean"),
        "existing_source_sha256": digest(SOURCE / "Main.lean"),
        "appended_text": appendix,
        "full_stdin_sha256":
            hashlib.sha256((source_text + appendix).encode()).hexdigest(),
    }
    dependencies = {}
    for name in DECLARATIONS:
        match = re.search(
            re.escape("'" + name + "'") + r" depends on axioms:\s*\[([^\]]*)\]",
            stdin_run["stdout"],
            flags=re.DOTALL,
        )
        if match:
            dependencies[name] = [
                value.strip() for value in match.group(1).split(",") if value.strip()
            ]
        elif f"'{name}' does not depend on any axioms" in stdin_run["stdout"]:
            dependencies[name] = []
    after = {str(path): digest(path) for path in files}
    checks["historical_read_set_unchanged"] = before == after
    checks["stdin_compiled_without_persistent_source"] = (
        stdin_run["exit_code"] == 0 and not stdin_run["timed_out"]
    )
    checks["all_four_axiom_dependencies_reported"] = (
        set(dependencies) == set(DECLARATIONS)
    )
    result = {
        "schema_version": 1,
        "unit_id": "lean-core",
        "result": "PASS" if all(checks.values()) else "INCOMPLETE_OR_MISMATCH",
        "historical_receipt_reused": str(certificate_path),
        "evidence_id": certificate["evidence_id"],
        "claim_version": 2,
        "claim_content_hash": claim_digest,
        "historical_compiler": receipt,
        "checks": checks,
        "historical_input_sha256": before,
        "direct_imports": [
            line.removeprefix("import ") for line in source_text.splitlines()
            if line.startswith("import ")
        ],
        "current_workspace": {
            "path": str(WORKSPACE),
            "toolchain": (WORKSPACE / "lean-toolchain").read_text().strip(),
            "manifest_sha256": digest(manifest_path),
            "mathlib_manifest_revision": mathlib["rev"],
            "revision_scope": "Manifest declaration only; installed dependency tree not separately pinned.",
        },
        "runtime": {"python": sys.version, "executable": sys.executable},
        "current_tool_versions": versions,
        "supplemental_stdin_axiom_inspection": stdin_run,
        "axiom_dependencies": dependencies,
        "new_claim_bound_certificate_created": False,
        "ledger_written": False,
        "persistent_lean_file_created": False,
        "independent_review": "pending_native_reviewer",
    }
    OUT.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "result": result["result"],
        "receipt": str(OUT),
        "checks": checks,
        "axiom_dependencies": dependencies,
    }, indent=2))
    return 0 if all(checks.values()) else 1


if __name__ == "__main__":
    raise SystemExit(main())
