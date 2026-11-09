#!/usr/bin/env python3
"""Replay the source-faithful universal Lean theorem and supporting exact checks."""

from fractions import Fraction
import json
import os
from pathlib import Path
import re
import subprocess
import sys


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")


def exact_checks():
    B, kappa = 2**32, 2**100
    t, eta = Fraction(1, 2**140), Fraction(1, 2**12)
    gamma = eta / 16
    error = Fraction(1, 2**23) + t * kappa + (1 + t * kappa) / (B - 1)
    assert gamma == Fraction(1, 2**16)
    assert t * kappa == Fraction(1, 2**40)
    assert error < Fraction(1, 2**21)
    assert gamma / 4 - Fraction(1, 2**21) >= gamma / 8
    ratio = t * gamma / (32 * kappa * B)
    assert ratio == Fraction(1, 2**293)
    assert Fraction(1, 2**310) <= ratio

    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    evidence = json.loads((ROOT / "jacobian_output.json").read_text())
    assert evidence["request"]["operation_id"] == "matrix.rank.compute"
    assert evidence["request"]["payload"] == payload
    result = evidence["result"]
    assert result["operation_id"] == "matrix.rank.compute"
    output = result["output"]
    assert output["matrix"] == payload["matrix"]
    assert output["rank"] == 2 and output["pivot_columns"] == [1, 3]
    assert output["method"] == "EXACT_RATIONAL_ROW_REDUCTION"
    matrix = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in payload["matrix"]["entries"]
    ]
    assert matrix == [[0, 1, 1, 0], [0, 0, 0, 1]]
    subsets = [{e for e in range(4) if mask & (1 << e)} for mask in range(16)]

    def rank(S):
        return int(bool(S & {1, 2})) + int(3 in S)

    for A in subsets:
        for C in subsets:
            assert rank(A) + rank(C) >= rank(A | C) + rank(A & C)
    independent = [S for S in subsets if rank(S) == len(S)]
    for I in independent:
        for J in independent:
            if len(I) < len(J):
                assert any(rank(I | {e}) == len(I) + 1 for e in J - I)
    return {
        "fixed_vector_ratio": str(ratio),
        "public_ratio": str(Fraction(1, 2**310)),
        "weighted_error": str(error),
        "boundary_matroid": {
            "rank": 2, "loops": [0], "parallel_class": [1, 2],
            "independent_sets": len(independent), "submodular_pairs": 256,
        },
        "jacobian": {
            "operation_id": result["operation_id"],
            "protocol_version": evidence["protocol_version"],
            "server_version": evidence["server"]["version"],
            "adapter_status": "success",
            "payload": "research/full_seed/jacobian_payload.json",
            "typed_output": "research/full_seed/jacobian_output.json",
        },
    }


def run(command, environment=None):
    result = subprocess.run(command, cwd=PROJECT, env=environment, text=True, capture_output=True)
    print(result.stdout, end="")
    print(result.stderr, end="", file=sys.stderr)
    if result.returncode:
        raise subprocess.CalledProcessError(
            result.returncode, command, output=result.stdout, stderr=result.stderr
        )
    return {"command": command, "exit_code": result.returncode, "stdout": result.stdout}


def main():
    supporting = exact_checks()
    closure = json.loads((ROOT / "upstream/import_closure.json").read_text())
    assert closure["commit"] == COMMIT
    assert len(closure["dependencies"]) == 125
    for module, imports in closure["dependencies"].items():
        path = ROOT / "upstream" / (module.replace(".", "/") + ".lean")
        source = path.read_text()
        assert not re.search(r"\b(?:sorry|admit|axiom)\b", source), str(path)
        actual_imports = [
            name for line in source.splitlines()
            if re.match(r"^(?:public )?import ", line)
            for name in line.split("import ", 1)[1].split() if name.startswith("OAI.")
        ]
        assert imports == actual_imports, str(path)

    run([PYTHON, str(ROOT / "build_compat.py")])
    version = subprocess.run(
        ["lake", "env", "lean", "--version"], cwd=WORKSPACE,
        text=True, capture_output=True, check=True,
    ).stdout.strip()
    assert "version 4.31.0," in version, version
    environment = dict(os.environ, LEAN_PATH=str(ROOT / "compat"))
    compiler = run([
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        "--project-root", str(PROJECT),
        "--claim", "V_ONE_SAMPLE_ALMIGHTY",
        str(ROOT / "Main.lean"),
        "--statement-fidelity", str(ROOT / "statement_fidelity.md"),
    ], environment)
    lean = json.loads(compiler["stdout"])
    assert lean["exit_code"] == 0 and lean["proof_holes"] == []
    assert lean["status"] == "success"
    assert lean["kernel"]["recorded"] is not None
    assert Path(lean["lake_workspace"]).resolve() == WORKSPACE
    axiom_output = (ROOT / "compile.log").read_text()
    assert "sorryAx" not in axiom_output
    axiom_lists = re.findall(r"depends on axioms:\s*\[([^\]]*)\]", axiom_output)
    assert len(axiom_lists) == 6, axiom_output
    for names in axiom_lists:
        assert set(name.strip() for name in names.split(",")) <= {
            "propext", "Classical.choice", "Quot.sound",
        }, names
    checks = [
        run([PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
             "--project-root", str(PROJECT)])
        for module in ("math_state", "proof_graph_check")
    ]
    certificate = {
        "result_kind": "source-faithful universal formal verification",
        "claim_id": "V_ONE_SAMPLE_ALMIGHTY",
        "upstream_commit": COMMIT,
        "project_root": str(PROJECT),
        "statement": {
            "fixed_vector": "Every size, finite labeled matroid, nonnegative real vector: expected minimum over all orders >= 2^-293 OPT.",
            "one_sample": "For mutually independent nonnegative sample/value coordinates with matching laws and finite expected optimum, the concrete exactly-one-sample simulation with an independent complete seed guarantees 2^-293, hence 2^-310, against every measurable complete-information order.",
            "correspondence": "Rank-one testing against previously accepted layer labels equals the implementation's closure test against all prior eligible layer labels.",
        },
        "formal_source": "research/full_seed/Main.lean",
        "formal_source_sha256": lean["source_sha256"],
        "statement_fidelity": "research/full_seed/statement_fidelity.md",
        "statement_fidelity_sha256": lean["statement_fidelity_sha256"],
        "definitions": {
            "fixed_vector_rule": "OAI.MatroidProphet.completeHiddenRule",
            "one_sample_rule": "OAI.MatroidProphet.sampleSimulation (completeHiddenRule M hE)",
            "complete_seed_law": "OAI.MatroidProphet.sourceSeedLaw n",
            "dependency_graph": "research/full_seed/upstream/import_closure.json",
            "compatibility_translation": "research/full_seed/build_compat.py",
        },
        "oai_dependency_modules": len(closure["dependencies"]),
        "compiler_exit_code": lean["exit_code"],
        "lean_version": version,
        "proof_holes": lean["proof_holes"],
        "axioms": ["propext", "Classical.choice", "Quot.sound"],
        "mechanical_evidence": lean["kernel"],
        "campaign_local_checks": checks,
        "supporting_exact_checks": supporting,
        "independent_review": "pending Host-invoked Reviewer",
        "novelty_status": "not_assessed",
        "significance_status": "not_assessed",
        "limitations": [
            "The compiler does not verify the interpretation of LaTeX or novelty.",
            "Transport from arbitrary finite ordered label sets to Fin n is justified in prose.",
            "The exact finite boundary calculation is supporting evidence, not the universal theorem.",
        ],
    }
    (ROOT / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "verified": True, "claim": certificate["claim_id"],
        "compiler_exit_code": lean["exit_code"], "proof_holes": [],
        "independent_review": certificate["independent_review"],
    }))


if __name__ == "__main__":
    main()
