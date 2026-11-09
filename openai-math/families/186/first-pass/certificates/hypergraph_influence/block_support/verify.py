#!/usr/bin/env python3
"""Rebuild all owned Lean sources and certify the imported exact theorem."""

import hashlib
import json
from pathlib import Path
import re
import subprocess

import build_support

BASE = Path(__file__).resolve().parent
ROOT = build_support.ROOT


def main():
    command = [
        "$WORKSPACE/argus-live-update/.venv/bin/python",
        str(BASE / "build_support.py"), "--dependencies",
        "research/certificates/hypergraph_influence/block_support/Orbit.lean",
        "research/certificates/hypergraph_influence/block_support/Restriction.lean",
        "research/certificates/hypergraph_influence/Block.lean",
        "research/certificates/hypergraph_influence/block_support/ApiCheck.lean",
    ]
    subprocess.run(command, cwd=ROOT, check=True, timeout=600)
    results = json.loads((BASE / "logs/last-build.json").read_text())
    assert len(results) == 10 and all(r["exit_code"] == 0 for r in results)
    log = (BASE / "logs/ApiCheck.log").read_text()
    axioms = {
        name: [x.strip() for x in values.split(",") if x.strip()]
        for name, values in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", log)
    }
    for name in re.findall(r"'([^']+)' does not depend on any axioms", log):
        axioms[name] = []
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    assert len(axioms) == 12, axioms
    assert all(set(values) <= allowed for values in axioms.values())
    manifest = json.loads((BASE / "source-manifest.json").read_text())
    for item in manifest["sources"]:
        original = BASE / "original" / item["path"]
        assert hashlib.sha256(original.read_bytes()).hexdigest() == item["sha256"]
    certificate = {
        "claim": "H_VARIANCE_AVERAGED_HYPERGRAPH_BLOCK",
        "theorem": "HypergraphInfluence.averaged_block",
        "kind": "unconditional_lean_dependency",
        "lean_version": subprocess.check_output(
            [build_support.LEAN, "--version"], text=True
        ).strip(),
        "compiler_exit_code": 0,
        "imported_exact_type_smoke_test": "passed",
        "proof_holes": [],
        "unsupported_axioms": [],
        "axioms": axioms,
        "block_source": "research/certificates/hypergraph_influence/Block.lean",
        "block_olean": (
            "research/certificates/hypergraph_influence/build/"
            "research/certificates/hypergraph_influence/Block.olean"
        ),
        "extra_lean_path": str(BASE / "build"),
        "logical_support_module_prefix": "HypergraphBlockSupport",
        "upstream_commit": manifest["commit"],
        "upstream_license": manifest["license"],
        "compiled_sources": results,
    }
    (BASE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print("PASS: averaged_block, exact imported type, 10 compiled sources, standard axioms only.")


if __name__ == "__main__":
    main()
