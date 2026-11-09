#!/usr/bin/env python3
"""Replay exact algebra and the recorded formal core, not the nonformal proof."""

import hashlib
import json
import re
from fractions import Fraction as F
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "Computing-the-Random-3-SAT-Threshold-September-27-2026/build/sections"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def normalized(text):
    return re.sub(r"\s+", " ", text).strip()


def rational(value):
    return F(int(value["num"]), int(value["den"]))


def verify_source(certificate):
    for assertion in certificate["source_assertions"]:
        text = (SOURCE / assertion["file"]).read_text()
        marker = "\\label{" + assertion["label"] + "}"
        require(
            marker in text,
            f"Missing staged source label: {assertion['label']}",
        )
        ending = "\\subsection" if assertion["label"] == "ctr:record" else "\\end{lemma}"
        passage = text.partition(marker)[2].partition(ending)[0]
        require(
            normalized(assertion["text"]) in normalized(passage),
            f"Staged source assertion changed: {assertion['label']}",
        )
    return len(certificate["source_assertions"])


def verify_algebra(certificate):
    a, eps, left, right, pair = sp.symbols("a eps left right pair", real=True)
    squared_distance = (a + eps - left) + (a + eps - right) - 2 * (a + pair)
    slack = sp.expand(2 * eps - squared_distance)
    require(
        sp.expand(slack - (left + right + 2 * pair)) == 0,
        "Support diameter slack identity failed",
    )
    require(
        certificate["identities"]["diameter_slack_coefficients"] == [1, 1, 2],
        "Certificate does not contain nonnegative diameter-slack coefficients",
    )
    J, delta, e0 = sp.symbols("J delta e0", positive=True)
    gamma = delta**2 / (2 * J)
    require(sp.cancel(2 * J * gamma - delta**2) == 0, "Tolerance factor failed")
    joint_budget = e0**2 / (8 * J)
    old_budget = e0**2 / (8 * J**3)
    require(
        sp.cancel(2 * J * joint_budget - e0**2 / 4) == 0,
        "Joint finite-test error budget failed",
    )
    require(
        sp.cancel(joint_budget / old_budget - J**2) == 0,
        "Finite-test band-budget improvement failed",
    )
    n = sp.symbols("n", integer=True, nonnegative=True)
    require(sp.summation(2 ** (-n), (n, 0, sp.oo)) == 2, "Dyadic sum failed")
    m, eta, s, xp = sp.symbols("m eta s xp", real=True)
    xc = 1 - eta + s
    require(
        sp.expand(eta - (m - m * xc) - (eta * (1 - m) + m * s)) == 0,
        "Exponent-band nonnegative-slack identity failed",
    )
    require(
        sp.expand((1 - eta) * m - m * xp - m * (1 - eta - xp)) == 0,
        "Parent-progress factor failed",
    )
    for parent in (False, True):
        for child in (False, True):
            eta_value, m_value = F(1, 4), F(1, 3)
            xp_value = F(1, 2) if parent else F(0)
            xc_value = F(7, 8) if child else F(1)
            hidden = ([m_value * xp_value] if parent else []) + (
                [m_value * xc_value] if child else []
            )
            sample = len(hidden) + 1
            start = 1 if parent else 0
            exponents = hidden + [m_value]
            require(len(hidden) <= 2, "Too many inserted levels")
            require(exponents == sorted(exponents), "Exponent order failed")
            require(
                all(m_value - eta_value <= t <= m_value for t in exponents[start:]),
                "Processed exponent band failed",
            )
            require(sample > start, "Empty new block")
            if parent:
                require(
                    0 < exponents[0] <= (1 - eta_value) * m_value,
                    "Parent progress failed",
                )
    return 8


def verify_sharpness(certificate):
    p = sp.symbols("p", real=True)
    mean = sp.Matrix([p, 1 - p])
    v = sp.Matrix([1, 0])
    error = sp.expand((v - mean).dot(v - mean))
    require(sp.expand(error - 2 * (1 - p) ** 2) == 0, "Sharpness identity failed")
    require(sp.limit(error, p, 0, dir="+") == 2, "Sharpness limit failed")
    rare_mass = F(certificate["sharpness"]["p"])
    require(
        2 * (1 - rare_mass) ** 2 == F(certificate["sharpness"]["squared_error"]),
        "Exact rare-point error failed",
    )
    require(2 * (1 - rare_mass) ** 2 > 1, "Negative control lost its gap")
    support = [tuple(F(x) for x in v) for v in certificate["sharpness"]["support"]]
    gram = [[sum(x * y for x, y in zip(v, w)) for w in support] for v in support]
    require(gram == [[F(1), F(0)], [F(0), F(1)]], "Sharpness Gram matrix failed")
    return gram


def verify_posterior(certificate):
    data = certificate["posterior_negative_control"]
    prior = list(map(F, data["base_global_probabilities"]))
    densities = list(map(F, data["global_densities"]))
    posterior = [p * d for p, d in zip(prior, densities)]
    require(sum(posterior) == 1, "Posterior is not normalized")
    require(
        posterior == list(map(F, data["posterior_global_probabilities"])),
        "Posterior global law failed",
    )
    joint = {
        (g, x, s): prior[g] * F(1, 4) * densities[g]
        for g in range(2)
        for x in range(2)
        for s in range(2)
    }
    for g in range(2):
        for x in range(2):
            for s in range(2):
                require(
                    joint[g, x, s] / posterior[g] == F(1, 4),
                    "Fresh-site product uniform law changed",
                )
        error = sum((F(g * x) - F(x, 2)) ** 2 for x in range(2)) / 2
        require(
            error == F(data["old_and_retained_pathwise_squared_error"]),
            "Retained type no longer has the pathwise record",
        )
    recomputed_error = sum((F(0) - posterior[1] * x) ** 2 for x in range(2)) / 2
    require(
        recomputed_error == F(data["recomputed_error_on_global_zero"]),
        "Recomputed-type negative control failed",
    )
    require(recomputed_error > F(1, 8), "Recomputation should violate the old tolerance")
    return len(joint)


def verify_jacobian(certificate, gram):
    specification = certificate["jacobian"]
    payload = json.loads((HERE / specification["payload"]).read_text())
    output = json.loads((HERE / specification["typed_output"]).read_text())
    require(specification["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(not specification["timed_out"], "Jacobian timeout is not evidence")
    require(specification["adapter_error"] is None, "Jacobian adapter error")
    require(
        output["server"]["version"] == specification["server_version"],
        "Jacobian server version changed",
    )
    require(
        output["protocol_version"] == specification["protocol_version"],
        "Jacobian protocol mismatch",
    )
    require(
        output["request"]["operation_id"] == specification["operation_id"],
        "Jacobian operation mismatch",
    )
    require(output["request"]["payload"] == payload, "Jacobian source-payload mismatch")
    require("output" in output["result"], "Jacobian result is incomplete")
    result = output["result"]["output"]
    require(result["is_less_or_equal"] is True, "Exact Gram matrix is not PSD")
    require(
        result["inertia"] == {"n_positive": 2, "n_negative": 0, "n_zero": 0},
        "Exact Gram inertia mismatch",
    )
    require(result["negative_witness"] is None, "Unexpected negative witness")
    for key in ("right", "difference"):
        entries = result[key]["matrix"]["entries"]
        require(
            [[rational(x) for x in row] for row in entries] == gram,
            f"Jacobian {key} matrix differs from the sharpness Gram matrix",
        )
    left = result["left"]["matrix"]["entries"]
    require(
        all(rational(x) == 0 for row in left for x in row),
        "PSD comparison left operand is not zero",
    )


def verify_lean(certificate):
    specification = certificate["lean"]
    record = json.loads((HERE / specification["record"]).read_text())
    require(record["status"] == "success", "Lean compiler did not succeed")
    require(record["exit_code"] == specification["required_exit_code"], "Lean exit failed")
    require(record["proof_holes"] == specification["required_proof_holes"], "Lean proof holes")
    require(record.get("environment_failure") in (None, ""), "Unverified Lean environment")
    lean_tool = record["tools"]["lean"]
    require(lean_tool["available"] is True, "Lean executable was unavailable")
    require(
        re.search(r"version 4\.31\.0(?:,|\))", lean_tool["version"]) is not None,
        "The actual compiler is not Lean 4.31.0",
    )
    require("sorryAx" not in record["stdout"], "An axiom trace contains a proof hole")
    source = (HERE / specification["source"]).read_bytes()
    fidelity = (HERE / specification["statement_fidelity"]).read_text().encode()
    require(
        hashlib.sha256(source).hexdigest() == record["source_sha256"],
        "Lean source changed after compilation",
    )
    require(
        hashlib.sha256(fidelity).hexdigest() == record["statement_fidelity_sha256"],
        "Statement fidelity changed after compilation",
    )
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current_claim = max(
        (c for c in state["claims"] if c["claim_id"] == certificate["formal_core_claim"]),
        key=lambda c: c["version"],
    )
    evidence = [
        e
        for e in state["evidence"]
        if e["subject"]["subject_id"] == certificate["formal_core_claim"]
        and e["subject"]["content_hash"] == current_claim["content_hash"]
        and e["tier"] == "mechanical"
        and e["verdict"] == "supports"
    ]
    require(bool(evidence), "No current mechanical evidence in the campaign ledger")
    for item in evidence:
        archived = json.loads((ROOT / item["artifact"]).read_text())
        require(
            archived["lean_check"]["source_sha256"] == record["source_sha256"],
            "Archived compiler result is stale",
        )
        require(
            archived["lean_source"]["text"].encode() == source,
            "Archived formal source differs",
        )
        require(
            archived["lean_check"]["statement_fidelity_sha256"]
            == record["statement_fidelity_sha256"],
            "Archived statement-fidelity mapping differs",
        )
    return len(evidence)


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["result_class"] == "new_reduction", "Wrong result classification")
    require(
        certificate["review"]["false_manuscript_assertion_identified"] is False,
        "This certificate must not be relabeled as a source refutation",
    )
    source_count = verify_source(certificate)
    algebra_count = verify_algebra(certificate)
    gram = verify_sharpness(certificate)
    posterior_atoms = verify_posterior(certificate)
    verify_jacobian(certificate, gram)
    mechanical_records = verify_lean(certificate)
    print(
        json.dumps(
            {
                "ok": True,
                "result_class": certificate["result_class"],
                "source_assertions": source_count,
                "exact_algebra_checks": algebra_count,
                "posterior_atoms": posterior_atoms,
                "jacobian_exact_psd": True,
                "current_lean_mechanical_records": mechanical_records,
                "universal_array_proof": "record_transfer.md; requires independent mathematical review",
                "novelty": certificate["novelty_status"],
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
