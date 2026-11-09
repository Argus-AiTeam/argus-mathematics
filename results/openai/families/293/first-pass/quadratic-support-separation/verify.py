#!/usr/bin/env python3
"""Replay the exact analytic core; do not promote the full prose theorem to Lean."""

import json
import re
import subprocess
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ARGUS_PYTHON = Path("$WORKSPACE/argus-live-update/.venv/bin/python")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(name):
    return json.loads((HERE / name).read_text())


def polynomial_terms(value):
    result = {}
    for term in value["polynomial"]["terms"]:
        powers = tuple(term["exponents"])
        coefficient = term["coefficient"]
        number = Fraction(int(coefficient["num"]), int(coefficient["den"]))
        require(powers not in result, "Duplicate monomial in Jacobian payload")
        require(number != 0, "Noncanonical zero coefficient")
        require(
            (str(number.numerator), str(number.denominator))
            == (coefficient["num"], coefficient["den"]),
            "Noncanonical rational in Jacobian payload",
        )
        result[powers] = number
    return result


def run_module(module, *arguments):
    command = [str(ARGUS_PYTHON), "-m", module, *map(str, arguments)]
    result = subprocess.run(
        command, cwd=ROOT, text=True, capture_output=True, timeout=110, check=False
    )
    if result.returncode:
        raise RuntimeError(
            f"Command failed ({result.returncode}): {' '.join(command)}\n"
            f"{result.stdout}{result.stderr}"
        )
    return result.stdout


def verify_jacobian(certificate):
    specification = certificate["jacobian"]
    operation = specification["operation_id"]
    discovery = read_json(specification["discovery"])
    contract = read_json(specification["contract"])
    payload = read_json(specification["payload"])
    response = read_json(specification["typed_output"])
    require(
        any(
            item["operation_id"] == operation
            for item in discovery["result"]["matches"]
        ),
        "Executed operation was not in the stored discovery",
    )
    require(
        contract["result"]["operation"]["operation_id"] == operation,
        "Stored contract names a different operation",
    )
    require(response["request"]["operation_id"] == operation, "Operation mismatch")
    require(response["request"]["payload"] == payload, "Payload binding mismatch")
    require(
        response["server"]["version"] == specification["server_version"],
        "Server version mismatch",
    )
    require(
        response["protocol_version"] == specification["protocol_version"],
        "Protocol version mismatch",
    )
    output = response["result"]["output"]
    require(output["outcome"] == "COMPUTED", "Jacobian result is not a conclusion")
    require(output["detail"] is None, "Jacobian returned a diagnostic")
    require(output["in_ideal"] is True, "Margin identity was not established")
    require(output["request"] == payload, "Typed request binding mismatch")
    require(
        output["remainder"]["polynomial"]["terms"] == [],
        "Nonzero polynomial remainder",
    )
    generators = payload["ideal"]["generators"]
    require(len(generators) == 1, "Unexpected ideal presentation")
    generator = polynomial_terms(generators[0])
    target = polynomial_terms(payload["polynomial"])
    require(
        generator == {(1, 1): Fraction(1), (0, 1): Fraction(-1), (0, 0): Fraction(-1)},
        "The generator is not (x-1)*y-1",
    )
    require(
        target == {powers: -2 * coefficient for powers, coefficient in generator.items()},
        "Exact independent identity replay failed",
    )


def verify_lean_result(certificate, result):
    require(result["status"] == "success", "Lean did not certify the core")
    require(result["exit_code"] == 0, "Lean compiler returned nonzero")
    require(result["proof_holes"] == [], "Lean reported proof holes")
    require(result["audit_exit_code"] == 0, "Lean environment axiom audit failed")
    expected_version = certificate["formal"]["lean_version"]
    require(
        result["tools"]["lean"]["version"].startswith(f"Lean (version {expected_version},"),
        "The compiler version does not match the required Lean toolchain",
    )
    require(
        result["kernel"]["recorded"] is not None,
        "Successful compilation was not recorded on the scoped core claim",
    )


def main():
    certificate = read_json("exact_certificate.json")
    require(str(ROOT) == certificate["project_root"], "Wrong campaign root")
    require(
        certificate["formal"]["whole_support_theorem_kernel_formalized"] is False,
        "This replay must not mislabel the full manuscript theorem as kernel-checked",
    )
    require(certificate["campaign_terminal"] is False, "Known-result checkpoint is not terminal")
    require(certificate["requires_independent_review"] is True, "Independent review is required")
    require(
        certificate["formal"]["declared_assumptions"] == [],
        "Unexpected extra formal assumptions",
    )
    for field in ("criterion", "proof"):
        require((ROOT / certificate["source"][field]).is_file(), "Missing manuscript source")
    criterion = (ROOT / certificate["source"]["criterion"]).read_text()
    manuscript = (ROOT / certificate["source"]["proof"]).read_text()
    for label in certificate["source"]["target_labels"]:
        require(
            "\\label{" + label + "}" in criterion + manuscript,
            f"Target label missing from source: {label}",
        )
    source = (HERE / certificate["formal"]["source"]).read_text()
    declarations = set(re.findall(r"^theorem ([A-Za-z0-9_]+)", source, re.MULTILINE))
    require(
        set(certificate["formal"]["required_declarations"]) <= declarations,
        "A required universal theorem is missing",
    )
    require(
        re.search(r"\b(sorry|admit|axiom)\b", source) is None,
        "A proof hole or added axiom appears in the source",
    )
    require((HERE / certificate["proof"]).is_file(), "Missing complete mathematical proof")
    verify_jacobian(certificate)
    formal_result = json.loads(
        run_module(
            "argus_skill.verticals.math.lean_evidence",
            "verify",
            HERE / certificate["formal"]["source"],
            "--statement-fidelity",
            HERE / certificate["formal"]["statement_fidelity"],
            "--project-root",
            ROOT,
            "--claim",
            certificate["claims"]["formal_core"],
            "--timeout",
            "90",
        )
    )
    verify_lean_result(certificate, formal_result)
    state_check = run_module(
        "argus_skill.verticals.math.math_state", "check", "--project-root", ROOT
    )
    require(json.loads(state_check)["ok"] is True, "Campaign-local ledger check failed")
    graph_check = run_module(
        "argus_skill.verticals.math.proof_graph_check", "check", "--project-root", ROOT
    )
    print(
        json.dumps(
            {
                "project_root": str(ROOT),
                "formal_core": "verified",
                "lean_exit_code": formal_result["exit_code"],
                "proof_holes": formal_result["proof_holes"],
                "mechanical_claim": certificate["claims"]["formal_core"],
                "certificate": formal_result["kernel"]["recorded"]["artifact"],
                "jacobian_identity": "independently_replayed_exactly",
                "math_state_check_exit": 0,
                "proof_graph_check_exit": 0,
                "proof_graph_check": graph_check.strip(),
                "full_support_theorem": "complete_prose_proof_requires_independent_review",
                "whole_support_theorem_kernel_formalized": False,
                "campaign_terminal": False,
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
