#!/usr/bin/env python3
"""Replay the exact stencil and source-bound all-order Lean core.

The analytic argument in report.md requires independent mathematical review.
Use --compile for a fresh official Lean run and campaign-local structural gates.
"""

import argparse
import hashlib
import json
import math
import re
import subprocess
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def rational(value):
    num, den = value["num"], value["den"]
    require(str(int(num)) == num, "Noncanonical rational numerator")
    require(str(int(den)) == den and int(den) > 0, "Invalid rational denominator")
    require(math.gcd(int(num), int(den)) == 1, "Unreduced rational")
    return Fraction(int(num), int(den))


def compile_and_check():
    command = [
        ARGUS_PYTHON,
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity",
        str(HERE / "statement_fidelity.md"),
        "--claim",
        "C_RJD_FORMAL",
        "--project-root",
        str(ROOT),
        "--timeout",
        "110",
    ]
    compiled = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    (HERE / "lean_verify_output.json").write_text(compiled.stdout, encoding="utf-8")
    if compiled.stderr:
        print(compiled.stderr, end="")
    checks = []
    for module in ("math_state", "proof_graph_check"):
        checked = subprocess.run(
            [
                ARGUS_PYTHON,
                "-m",
                "argus_skill.verticals.math." + module,
                "check",
                "--project-root",
                str(ROOT),
            ],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        checks.append(
            {
                "module": module,
                "exit_code": checked.returncode,
                "stdout": checked.stdout,
                "stderr": checked.stderr,
            }
        )
    (HERE / "validation.json").write_text(
        json.dumps({"project_root": str(ROOT), "checks": checks}, indent=2) + "\n",
        encoding="utf-8",
    )
    require(compiled.returncode == 0, "Fresh official Lean compilation failed; inspect lean_verify_output.json")
    require(all(item["exit_code"] == 0 for item in checks), "A campaign-local structural gate failed")


def replay_stencil(certificate):
    adapter = certificate["bounded_adapter_replay"]
    payload = load(ROOT / adapter["payload"])
    contract = load(ROOT / adapter["contract"])
    response = load(ROOT / adapter["typed_output"])
    operation = adapter["operation_id"]
    require(contract["result"]["operation"]["operation_id"] == operation, "Wrong inspected operation")
    require(response["request"] == {"operation_id": operation, "payload": payload}, "Adapter request mismatch")
    require(response["protocol_version"] == adapter["protocol_version"], "Protocol mismatch")
    require(response["server"]["version"] == adapter["server_version"], "Server version mismatch")
    require("error" not in response and "error" not in response["result"], "Adapter error is not evidence")
    require(response["result"]["operation_id"] == operation, "Wrong executed operation")
    require(adapter["observed_adapter_exit_code"] == 0 and not adapter["timeout"], "Incomplete adapter run")
    require(adapter["transport_error"] is None, "Transport failure is not evidence")
    output = response["result"]["output"]
    require(output["source"] == payload["table"], "Unbound typed interpolation source")
    require(output["total_multiplicity"] == 3 and output["degree"] == 2, "Wrong interpolation degree")
    polynomial = output["polynomial"]
    require(polynomial["domain"] == "QQ" and polynomial["variables"] == ["x"], "Wrong polynomial ring")
    terms = polynomial["polynomial"]["terms"]
    require([term["exponents"] for term in terms] == [[2], [1], [0]], "Unexpected polynomial terms")
    coefficients = [rational(term["coefficient"]) for term in reversed(terms)]
    require(coefficients == [Fraction(x) for x in adapter["polynomial_coefficients_ascending"]], "Wrong polynomial")
    nodes, values = [], []
    for jet in payload["table"]["jets"]:
        require([entry["derivative_order"] for entry in jet["derivatives"]] == [0], "Unexpected jet order")
        nodes.append(rational(jet["node"]))
        values.append(rational(jet["derivatives"][0]["value"]))
    require(nodes == [Fraction(x) for x in adapter["nodes"]], "Wrong sample nodes")
    require(values == [Fraction(x) for x in adapter["values"]], "Wrong sample values")
    require(len(set(nodes)) == 3, "Coincident interpolation nodes")
    for node, value in zip(nodes, values):
        require(sum(c * node**i for i, c in enumerate(coefficients)) == value, "Exact polynomial replay failed")
    expected_replay = [
        {"node": jet["node"], "derivative_order": 0,
         "expected": jet["derivatives"][0]["value"],
         "computed": jet["derivatives"][0]["value"]}
        for jet in payload["table"]["jets"]
    ]
    require(output["replay"] == expected_replay, "Incomplete or inaccurate typed replay")
    determinant = math.prod(nodes[j] - nodes[i] for i in range(3) for j in range(i + 1, 3))
    require(determinant == Fraction(adapter["vandermonde_determinant"]) != 0, "Singular stencil")
    target = Fraction(adapter["evaluation_target"])
    require(target not in nodes, "The replay must not sample its evaluation target")
    weights = [
        math.prod((target - nodes[j]) / (nodes[i] - nodes[j]) for j in range(3) if j != i)
        for i in range(3)
    ]
    require(weights == [Fraction(x) for x in adapter["evaluation_weights"]], "Wrong evaluation weights")
    for degree in range(3):
        require(sum(w * x**degree for w, x in zip(weights, nodes)) == target**degree, "Polynomial reproduction failed")
    require(sum(abs(w) for w in weights) == Fraction(adapter["evaluation_weight_l1_norm"]), "Wrong stencil norm")
    require(sum(w * v for w, v in zip(weights, values)) == Fraction(adapter["recovered_value"]), "Wrong interpolated value")
    return {"nodes": 3, "exact_polynomial": "x^2+x+1", "scope": "bounded stencil only"}


def check_formal_core(certificate):
    formal = certificate["formal_core"]
    source_path = ROOT / formal["source"]
    fidelity_path = ROOT / formal["statement_fidelity"]
    archive_path = ROOT / formal["certificate"]
    archive = load(archive_path)
    result = archive["lean_check"]
    source = source_path.read_text(encoding="utf-8")
    fidelity = fidelity_path.read_text(encoding="utf-8")
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean did not prove the encoded statement")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "Wrong Lean kernel version")
    require(archive["lean_source"]["text"] == source, "Archived formal source is stale")
    require(archive["statement_fidelity"]["text"] == fidelity, "Archived statement reading is stale")
    require(hashlib.sha256(source_path.read_bytes()).hexdigest() == result["source_sha256"], "Source changed after compilation")
    require(hashlib.sha256(fidelity.encode("utf-8")).hexdigest() == result["statement_fidelity_sha256"], "Statement reading changed after compilation")
    require(not re.search(r"\b(sorry|admit|axiom)\b", source), "Unproved declaration in formal source")
    require("sorryAx" not in result["stdout"], "Compiler reported an admitted axiom")
    axiom_lists = re.findall(r"depends on axioms: \[([^]]*)\]", result["stdout"])
    require(len(axiom_lists) == len(formal["declarations"]), "Missing compiler axiom reports")
    for declaration in formal["declarations"]:
        require("'" + declaration + "' depends on axioms:" in result["stdout"], "Missing certified declaration")
    for names in axiom_lists:
        require(set(names.split(", ")) <= {"propext", "Classical.choice", "Quot.sound"}, "Unexpected proof axiom")
    ledger = load(ROOT / "research/MATH_STATE.json")
    versions = [claim for claim in ledger["claims"] if claim["claim_id"] == formal["claim"]]
    require(bool(versions), "Formal claim is absent from the ledger")
    latest = max(versions, key=lambda claim: claim["version"])
    require(latest["formal_statement"] == source, "Ledger formalization is stale")
    require(archive["subject"]["content_hash"] == latest["content_hash"], "Certificate proves another claim version")
    require(archive["verdict"] == "supports" and archive["tier"] == "mechanical", "Archive is not mechanical support")
    require(
        any(
            evidence["artifact"] == formal["certificate"]
            and evidence["verdict"] == "supports"
            and evidence["subject"]["content_hash"] == latest["content_hash"]
            for evidence in ledger["evidence"]
        ),
        "Successful compiler result is not recorded on the current formal claim",
    )
    return {"claim": formal["claim"], "exit_code": 0, "proof_holes": [], "quantification": "unbounded natural orders and times"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compile", action="store_true", help="Obtain and record a fresh official Lean compiler answer")
    args = parser.parse_args()
    certificate = load(HERE / "exact_certificate.json")
    require(certificate["claim"] == "C_RJD_BRIDGE", "Wrong mathematical target")
    require(certificate["conditional_inputs"] == [
        "A_GEOMETRY", "A_COHERENCE", "A_FORMAL_EQUIVARIANCE",
        "A_PRODUCT_MEASURE", "A_UNSTABLE_CHARACTERIZATION",
    ], "Conditional theorem hypotheses changed")
    require(certificate["research_target_level"] == "publishable", "Research target was weakened")
    require(certificate["math_objective_mode"] == "exploratory", "Research mode was changed")
    require(certificate["false_manuscript_assertions"] == [], "This is a verification, not a refutation certificate")
    require(not certificate["campaign_completion_claimed"] and not certificate["full_manuscript_verified"], "Unsupported global conclusion")
    require(certificate["novelty_status"] == "not_established", "Novelty has not been independently established")
    require((ROOT / certificate["analytic_proof"]).is_file(), "Missing analytic proof")
    source = (ROOT / certificate["source"]["file"]).read_text(encoding="utf-8")
    for label in certificate["source"]["labels"]:
        require("\\label{" + label + "}" in source, "Missing manuscript source locator: " + label)
    if args.compile:
        compile_and_check()
    stencil = replay_stencil(certificate)
    formal = check_formal_core(certificate)
    validation = load(HERE / "validation.json")
    require(validation["project_root"] == str(ROOT), "Checks ran against the wrong project root")
    require({item["module"] for item in validation["checks"]} == {"math_state", "proof_graph_check"}, "Missing official gate")
    require(all(item["exit_code"] == 0 for item in validation["checks"]), "An official gate did not pass")
    result = {
        "status": "verified_conditional_core",
        "stencil": stencil,
        "formal_core": formal,
        "analytic_proof_requires_independent_review": True,
        "upstream_source_assumptions_independently_proved": False,
        "independent_review": certificate["independent_review_status"],
        "project_root": str(ROOT),
        "math_state_exit": 0,
        "proof_graph_check_exit": 0,
    }
    rendered = json.dumps(result, indent=2) + "\n"
    (HERE / "verification_result.json").write_text(rendered, encoding="utf-8")
    print(rendered, end="")


if __name__ == "__main__":
    main()
