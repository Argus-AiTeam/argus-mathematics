#!/usr/bin/env python3
"""Replay exact new-reduction tests and obtain real Lean claim certificates."""

import argparse
import json
from pathlib import Path
import re
import subprocess

from build_forward import build, digest
from exact_tests import exact_checks, run_jacobian


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIMS = ("COrdered", "CEdgeTransfer", "CMain")
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
DECLARATIONS = (
    "Campaign9000327.MainTheorem.ordered_norm_construction",
    "Campaign9000327.MainTheorem.odd_edge_transfer",
    "Campaign9000327.MainTheorem.odd_edge_transfer_span",
    "Campaign9000327.MainTheorem.main_implication",
    "Campaign9000327.MainTheorem.main_explicit",
    "OAI.MarkovSuperreflexivity.exists_nonreflexive_finitelyRepresentable_of_not_hasEquivalentUCNorm",
)


def reviewed_walk_state():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    preserved = {
        "CWalk", "CChartTransport", "CPrefixDisplacement",
        "CTwoLevels", "CReducedProbability", "CMarkedLaw",
    }
    return {
        "claims": [entry for entry in state["claims"] if entry["claim_id"] in preserved],
        "evidence": [entry for entry in state["evidence"]
                     if entry["subject"]["subject_id"] in preserved],
        "routes": [entry for entry in state["routes"]
                   if entry["goal"]["subject_id"] in preserved],
    }


def local_gates():
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        command = [ARGUS, "-m", "argus_skill.verticals.math." + module,
                   "check", "--project-root", str(ROOT)]
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        checks[module] = {
            "command": command, "exit_code": result.returncode,
            "stdout": result.stdout, "stderr": result.stderr,
        }
    data = {"project_root": str(ROOT), "checks": checks}
    (HERE / "validation.json").write_text(json.dumps(data, indent=2) + "\n")
    if any(entry["exit_code"] for entry in checks.values()):
        raise RuntimeError(f"Campaign-local validation failed: {json.dumps(data)}")
    return data


def claim_assessment(claim):
    command = [ARGUS, "-m", "argus_skill.verticals.math.math_state",
               "show", "--project-root", str(ROOT), "--claim", claim]
    result = subprocess.run(command, cwd=ROOT, check=True, capture_output=True, text=True)
    return json.loads(result.stdout)["claim"]


def axiom_reports(log):
    reports = {}
    for declaration in DECLARATIONS:
        matches = re.findall(
            re.escape(declaration) + r"'?\s+depends on axioms:\s*\[([^\]]*)\]", log,
        )
        if len(matches) != 1:
            raise RuntimeError(f"Expected exactly one compiler axiom report for {declaration}")
        axioms = sorted(x.strip() for x in matches[0].split(",") if x.strip())
        if not set(axioms) <= ALLOWED_AXIOMS:
            raise RuntimeError(f"Unallowed transitive axioms for {declaration}: {axioms}")
        reports[declaration] = axioms
    return reports


def verify_claim(claim, env):
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--project-root", str(ROOT), "--claim", claim, "--no-lake",
    ]
    result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True)
    (HERE / f"formal_verifier_{claim}.json").write_text(result.stdout)
    (HERE / f"formal_verifier_{claim}.stderr").write_text(result.stderr)
    gates = local_gates()
    if result.returncode:
        raise RuntimeError(f"Official Lean verification failed for {claim}:\n{result.stdout}\n{result.stderr}")
    payload = json.loads(result.stdout)
    kernel = payload["kernel"]
    record = kernel["recorded"]
    if (kernel["refusals"] or record["tier"] != "mechanical" or record["verdict"] != "supports"
            or record["subject"]["subject_id"] != claim):
        raise RuntimeError(f"No valid mechanical evidence was recorded for {claim}: {kernel}")
    certificate_path = ROOT / record["artifact"]
    certificate = json.loads(certificate_path.read_text())
    lean = certificate["lean_check"]
    if (lean["status"] != "success" or lean["exit_code"] != 0
            or lean["proof_holes"] != [] or lean["audit_exit_code"] != 0
            or "version 4.31.0," not in lean["tools"]["lean"]["version"]):
        raise RuntimeError(f"The required actual Lean 4.31.0 outcome is absent for {claim}")
    reports = axiom_reports(lean["stdout"])
    return {"record": record, "axiom_reports": reports, "local_gates": gates}


def retire_proved_structural_assumption():
    assessment = claim_assessment("COrdered")
    ids = set(assessment["undischarged"])
    if "JAMES_ENFLO" not in ids:
        if ids:
            raise RuntimeError(f"Unexpected remaining assumptions on COrdered: {ids}")
        return
    reason = (
        "The pinned JamesEnflo construction and its complete custom dependency cone now compile "
        "on Lean 4.31.0. The official COrdered certificate prints the transitive axiom closure "
        "of exists_nonreflexive_finitelyRepresentable_of_not_hasEquivalentUCNorm as only "
        "propext, Classical.choice, and Quot.sound. Its completed nonreflexive finitely "
        "representable space is therefore a proved dependency, not an external assumption."
    )
    subprocess.run(
        [ARGUS, "-m", "argus_skill.verticals.math.math_state", "revise-claim",
         "--project-root", str(ROOT), "--id", "COrdered", "--retire", "JAMES_ENFLO=" + reason],
        cwd=ROOT, check=True, capture_output=True, text=True,
    )
    local_gates()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--exact-only", action="store_true")
    mode.add_argument("--formal-only", action="store_true")
    parser.add_argument("--run-jacobian", action="store_true",
                        help="Execute the bounded typed operation; otherwise replay its preserved result.")
    args = parser.parse_args()
    if args.run_jacobian:
        run_jacobian()
    exact_path = HERE / "exact_results.json"
    if args.formal_only:
        exact = json.loads(exact_path.read_text())
        if exact["test_source_sha256"] != digest(HERE / "exact_tests.py"):
            raise RuntimeError("The exact-test source changed after its recorded run")
    else:
        exact = {
            "test_source_sha256": digest(HERE / "exact_tests.py"),
            "results": exact_checks(),
        }
        exact_path.write_text(json.dumps(exact, indent=2) + "\n")
    if args.exact_only:
        print(json.dumps({
            "classification": exact["results"]["classification"],
            "ordered_checks": exact["results"]["ordered_norm"],
            "lift_cases": len(exact["results"]["lattice_lift"]),
            "jacobian_adapter_exit_code": exact["results"]["jacobian"]["adapter_exit_code"],
        }, indent=2))
        return
    walk_before = reviewed_walk_state()
    compiled, env = build()
    formal = {}
    for claim in CLAIMS:
        formal[claim] = verify_claim(claim, env)
        if claim == "COrdered":
            retire_proved_structural_assumption()
    assessments = {claim: claim_assessment(claim) for claim in CLAIMS}
    if any(item["status"] != "closed_kernel" or item["undischarged"] for item in assessments.values()):
        raise RuntimeError(f"Some required claims are not unconditionally kernel closed: {assessments}")
    if reviewed_walk_state() != walk_before:
        raise RuntimeError("The accepted CWalk claim, dependencies, routes, or review evidence changed")
    data = {
        "classification": "source-faithful universal formal verification of the existing forward implication",
        "claim_id": "CMain",
        "theorem": "Campaign9000327.MainTheorem.main_explicit",
        "statement": "Every real Banach space with ordinary Markov type p for some real p>1 admits an equivalent uniformly convex real norm, including the zero space.",
        "source_sha256": digest(HERE / "Main.lean"),
        "statement_fidelity_sha256": digest(HERE / "statement_fidelity.md"),
        "lean_version": compiled["lean_version"],
        "exit_code": 0,
        "proof_holes": [],
        "axiom_reports": formal["CMain"]["axiom_reports"],
        "formal_records": {claim: formal[claim]["record"]["artifact"] for claim in CLAIMS},
        "claim_statuses": {claim: {"status": item["status"], "undischarged": item["undischarged"]}
                           for claim, item in assessments.items()},
        "reviewed_walk": {
            "certificate": "research/finite_walk_certificate/certificates/CWalk-d0a6fb48b124f143.json",
            "modules_recompiled": compiled["reviewed_walk_modules_recompiled"],
            "claim_and_review_unchanged": True,
        },
        "new_module_count": compiled["new_module_count"],
        "source_inventory": "source_inventory.json",
        "build_record": "build_result.json",
        "exact_experiments": "exact_results.json",
        "experiment_classification": exact["results"]["classification"],
        "jacobian_result": "jacobian_result.json",
        "campaign_local_validation": formal["CMain"]["local_gates"],
        "independent_review": "pending Host-invoked Reviewer; no Engineer self-confirmation",
        "novelty": "No new-discovery claim; this verifies an existing manuscript and pinned public proof.",
        "outside_scope": ["converse characterization", "uniformly smooth renorming consequences"],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(data, indent=2) + "\n")
    print(json.dumps({
        "claim": "CMain", "exit_code": 0, "proof_holes": [],
        "new_module_count": compiled["new_module_count"],
        "recompiled_reviewed_walk_modules": 0,
        "claim_statuses": data["claim_statuses"],
        "certificate": "research/main_theorem_certificate/exact_certificate.json",
        "independent_review": data["independent_review"],
    }, indent=2))


if __name__ == "__main__":
    main()
