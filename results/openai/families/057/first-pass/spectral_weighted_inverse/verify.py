#!/usr/bin/env python3
"""Replay exact algebra and compiler evidence, not the analytic proof."""

import hashlib
import json
from fractions import Fraction
from math import isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def polynomial(value):
    require(value["domain"] == "QQ", "Expected rational polynomial coefficients")
    require(value["variables"] == ["mu", "a"], "Unexpected polynomial variable axis")
    result = {}
    for term in value["polynomial"]["terms"]:
        exponent = tuple(term["exponents"])
        coefficient = Fraction(
            int(term["coefficient"]["num"]), int(term["coefficient"]["den"])
        )
        require(len(exponent) == 2 and min(exponent) >= 0, "Invalid exponent")
        require(exponent not in result and coefficient != 0, "Noncanonical support")
        result[exponent] = coefficient
    return result


def check_jacobian(certificate):
    specification = certificate["jacobian"]
    contract = load(specification["contract"])
    payload = load(specification["payload"])
    response = load(specification["typed_output"])
    operation = specification["operation_id"]
    require(
        contract["result"]["operation"]["operation_id"] == operation,
        "The inspected contract does not match the executed operation",
    )
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "The typed response is not for the retained exact payload")
    require(response["server"]["version"] == specification["server_version"],
            "Unexpected Jacobian server version")
    require(response["protocol_version"] == specification["protocol_version"],
            "Unexpected Jacobian protocol")
    require(response["result"]["operation_id"] == operation,
            "Unexpected Jacobian result operation")
    require(specification["adapter_exit_status"] == 0
            and specification["error_or_timeout"] is None,
            "The adapter did not complete successfully")
    output = response["result"]["output"]
    require(output["is_valid"] is True
            and output["method"] == "EXACT_COEFFICIENT_IDENTITY",
            "No exact completed-square verdict")
    require(output["polynomial"] == payload["polynomial"]
            and output["summands"] == payload["summands"],
            "The returned polynomial differs from the submitted one")
    total = {}
    for summand in payload["summands"]:
        terms = polynomial(summand)
        for left, left_value in terms.items():
            for right, right_value in terms.items():
                exponent = tuple(x + y for x, y in zip(left, right))
                total[exponent] = total.get(exponent, Fraction(0)) + left_value * right_value
    total = {exponent: value for exponent, value in total.items() if value}
    expected = {(2, 0): Fraction(4), (1, 1): Fraction(4), (0, 2): Fraction(1)}
    require(total == polynomial(payload["polynomial"]) == expected,
            "Independent coefficient replay failed")
    require(polynomial(output["computed_sum"]) == expected,
            "The typed computed sum is incorrect")


def check_curvature(certificate):
    wedge = [[0] * 4 for _ in range(4)]
    wedge[3][0] = 1
    adjoint = [list(row) for row in zip(*wedge)]
    commutator = [
        [
            sum(wedge[i][k] * adjoint[k][j] - adjoint[i][k] * wedge[k][j]
                for k in range(4))
            for j in range(4)
        ]
        for i in range(4)
    ]
    diagonal = certificate["curvature_local_check"]["wedge_adjoint_commutator_diagonal"]
    require(diagonal == [-1, 0, 0, 1], "Wrong local curvature sign")
    require(
        commutator == [[diagonal[i] if i == j else 0 for j in range(4)]
                       for i in range(4)],
        "Exterior multiplication/contraction identity failed",
    )
    occupancy = [(0, 0), (1, 0), (0, 1), (1, 1)]
    require(diagonal == [hol + anti - 1 for hol, anti in occupancy],
            "Curvature is not the claimed number-operator expression")
    require([diagonal[1], diagonal[3]] == [0, 1],
            "Wrong sign on top-holomorphic-degree forms")


def check_examples(certificate):
    for example in certificate["abstract_examples"]:
        delta, B, a, w = (
            Fraction(example[key]) for key in ("delta", "B", "a", "target_weight")
        )
        require(delta > 0 and B >= 1 and a >= 0 and 1 <= w <= B,
                f"Invalid abstract hypotheses: {example['name']}")
        eigenvalue = delta * w / B
        energy = delta * w * w / B
        lift = B / delta
        bochner_slack = energy + a * w - delta
        quadratic_slack = eigenvalue * (eigenvalue + a) - delta * delta / B
        require(w * w == energy * lift and delta * lift == B,
                f"Primitive or Cauchy-Schwarz equality failed: {example['name']}")
        require(bochner_slack >= 0 and quadratic_slack >= 0,
                f"The comparison hypotheses or conclusion fail: {example['name']}")
        numerator_root, denominator_root = isqrt(B.numerator), isqrt(B.denominator)
        require(numerator_root**2 == B.numerator
                and denominator_root**2 == B.denominator,
                "The retained rational examples require rational sqrt(B)")
        sqrt_B = Fraction(numerator_root, denominator_root)
        squared_bound = sqrt_B / delta + a * B / delta**2
        expected = {
            "weighted_eigenvalue": eigenvalue,
            "inverse_norm_squared": 1 / eigenvalue,
            "bochner_slack": bochner_slack,
            "quadratic_slack": quadratic_slack,
            "squared_bound": squared_bound,
        }
        for key, value in expected.items():
            require(Fraction(example[key]) == value,
                    f"Incorrect {key}: {example['name']}")
        require(1 / eigenvalue <= squared_bound,
                f"The claimed squared inverse bound fails: {example['name']}")
    return len(certificate["abstract_examples"])


def check_lean(certificate):
    specification = certificate["lean"]
    result = load(specification["compiler_result"])
    archive = load(specification["archived_certificate"])
    source = (HERE / specification["source"]).read_bytes()
    fidelity = (HERE / specification["statement_fidelity"]).read_text(encoding="utf-8")
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "No successful, hole-free, axiom-audited Lean run")
    require(f"version {specification['version']}," in result["tools"]["lean"]["version"],
            "Wrong Lean compiler version")
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.encode("utf-8")).hexdigest()
            == result["statement_fidelity_sha256"],
            "Statement fidelity changed after compilation")
    require(archive["lean_check"] == result
            and archive["lean_source"]["text"] == source.decode("utf-8")
            and archive["statement_fidelity"]["text"] == fidelity,
            "Archived compiler evidence does not bind the current source and reading")
    require(archive["subject"]["subject_id"] == certificate["formal_claim"]
            and archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "The archive does not certify the formal scalar claim")
    state = json.loads((PROJECT / "research/MATH_STATE.json").read_text(encoding="utf-8"))
    claim = max(
        (claim for claim in state["claims"]
         if claim["claim_id"] == certificate["formal_claim"]),
        key=lambda claim: claim["version"],
    )
    require(claim["formal_statement"] == source.decode("utf-8")
            and claim["content_hash"] == archive["subject"]["content_hash"],
            "The current ledger claim differs from what Lean compiled")
    artifact = (HERE / specification["archived_certificate"]).relative_to(PROJECT).as_posix()
    require(any(
        evidence["subject"] == archive["subject"]
        and evidence["artifact"] == artifact
        and evidence["tier"] == "mechanical"
        and evidence["verdict"] == "supports"
        for evidence in state["evidence"]
    ), "The real compiler result is not recorded on the current claim")


def main():
    certificate = load("exact_certificate.json")
    require(certificate["schema_version"] == 1
            and certificate["analytic_claim"] == "C_SWI"
            and certificate["formal_claim"] == "C_SWI_ALG",
            "Unexpected certificate statement")
    require(certificate["result_class"] == "known_result"
            and certificate["campaign_complete"] is False
            and certificate["novelty_status"] == "not_claimed",
            "This local verification cannot certify campaign completion or novelty")
    require((HERE / certificate["proof"]).is_file(), "The analytic proof is missing")
    check_jacobian(certificate)
    check_curvature(certificate)
    examples = check_examples(certificate)
    check_lean(certificate)
    print(json.dumps({
        "exact_replay": "pass",
        "result_class": certificate["result_class"],
        "formal_claim": certificate["formal_claim"],
        "lean_version": certificate["lean"]["version"],
        "proof_holes": [],
        "completed_square": "exact",
        "local_curvature_sign": "exact",
        "abstract_examples_checked": examples,
        "analytic_claim": certificate["analytic_claim"],
        "analytic_proof": "proof.md; requires independent mathematical review",
        "campaign_complete": False,
    }, indent=2))


if __name__ == "__main__":
    main()
