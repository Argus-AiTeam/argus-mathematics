#!/usr/bin/env python3
"""Read historical claim bindings and probe the available Lean/Lake tools."""

import difflib
import hashlib
import json
import os
import shutil
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
OLD_ROOT = ROOT.parent / "9000024"
OLD = OLD_ROOT / "research" / "prefix-collisions"


def digest(text):
    return hashlib.sha256(text.encode()).hexdigest()


def main():
    ledger = json.loads((OLD_ROOT / "research" / "MATH_STATE.json").read_text())
    active = json.loads((ROOT / "research" / "MATH_STATE.json").read_text())
    relevant = {"C_ROOT_BOUNDS", "C_RECOVERY_CORE"}
    claims = [claim for claim in ledger["claims"] if claim["claim_id"] in relevant]
    versions = [claim for claim in claims if claim["claim_id"] == "C_RECOVERY_CORE"]
    evidence = [item for item in ledger["evidence"]
                if item["subject"]["subject_id"] in relevant]
    paths = [
        "Main.lean", "statement_fidelity.md", "lean_check.json",
        "lean_verification.json", "compile.log", "compiler_receipt_1.json",
        "certificates/C_RECOVERY_CORE-2c1aeabdc5dc640e.json",
        "certificates/C_RECOVERY_CORE-3bad1558c8a1cd6a.json",
    ]
    certificates = {}
    for name in paths[-2:]:
        certificate = json.loads((OLD / name).read_text())
        text = certificate["lean_source"]["text"]
        fidelity = certificate["statement_fidelity"]["text"]
        version = next(claim["version"] for claim in versions
                       if claim["formal_statement"] == text)
        certificates[name] = {
            "evidence_id": certificate["evidence_id"],
            "subject": certificate["subject"],
            "tier": certificate["tier"],
            "verdict": certificate["verdict"],
            "lean_check": certificate["lean_check"],
            "formal_claim_version_matched": version,
            "embedded_source_sha256": digest(text),
            "embedded_fidelity_sha256": digest(fidelity),
            "recorded_source_sha256_matches": (
                digest(text) == certificate["lean_check"]["source_sha256"]
            ),
            "recorded_fidelity_sha256_matches": (
                digest(fidelity)
                == certificate["lean_check"]["statement_fidelity_sha256"]
            ),
        }
    source = (OLD / "Main.lean").read_text()
    formal = next(claim for claim in active["claims"] if claim["claim_id"] == "RV_FORMAL")
    data = {
        "schema_version": 1,
        "historical_root": str(OLD_ROOT),
        "active_root": str(ROOT),
        "input_sha256": {
            name: hashlib.sha256((OLD / name).read_bytes()).hexdigest()
            for name in paths
        },
        "historical_ledger_sha256": hashlib.sha256(
            (OLD_ROOT / "research" / "MATH_STATE.json").read_bytes()
        ).hexdigest(),
        "claims": [
            {**{key: value for key, value in claim.items() if key != "formal_statement"},
             "formal_statement_sha256": digest(claim.get("formal_statement") or "")}
            for claim in claims
        ],
        "routes": [route for route in ledger["routes"] if route["route_id"]
                   in {"R_RECOVERY_CORE", "R_RECOVERY_CORE_CURRENT"}],
        "evidence": evidence,
        "certificates": certificates,
        "version_diff": "".join(difflib.unified_diff(
            versions[0]["formal_statement"].splitlines(keepends=True),
            versions[1]["formal_statement"].splitlines(keepends=True),
            fromfile="C_RECOVERY_CORE-v1", tofile="C_RECOVERY_CORE-v2",
        )),
        "lean_check": json.loads((OLD / "lean_check.json").read_text()),
        "lean_verification": json.loads((OLD / "lean_verification.json").read_text()),
        "compile_log": (OLD / "compile.log").read_text(),
        "compiler_receipt_1": json.loads((OLD / "compiler_receipt_1.json").read_text()),
        "active_formal_claim": {
            **{key: value for key, value in formal.items() if key != "formal_statement"},
            "source_text_matches_current": formal["formal_statement"] == source,
            "formal_statement_sha256": digest(formal["formal_statement"]),
        },
    }
    (HERE / "historical_bindings.json").write_text(json.dumps(data, indent=2) + "\n")

    probes = {}
    for name in ["lean", "lake"]:
        path = shutil.which(name)
        if path is None:
            probes[name] = {"available": False, "path": None}
            continue
        result = subprocess.run(
            [path, "--version"], cwd=ROOT, capture_output=True, text=True,
            timeout=30, env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
        )
        probes[name] = {
            "available": True, "path": path, "exit_code": result.returncode,
            "stdout": result.stdout, "stderr": result.stderr, "cwd": str(ROOT),
        }
    (HERE / "tool_probes.json").write_text(json.dumps(probes, indent=2) + "\n")
    print(json.dumps({
        "active_formal_source_matches": formal["formal_statement"] == source,
        "certificates": {name: item["formal_claim_version_matched"]
                         for name, item in certificates.items()},
        "tool_probes": probes,
        "binding_output": str(HERE / "historical_bindings.json"),
    }))


if __name__ == "__main__":
    main()
