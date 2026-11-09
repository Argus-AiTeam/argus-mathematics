#!/usr/bin/env python3
"""Replay internal exact checks; do not certify the open Poisson estimates."""

import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def load_json(name):
    with (ROOT / name).open(encoding="utf-8") as stream:
        return json.load(stream)


def rational(value):
    return sp.Rational(value["num"], value["den"])


def check_cyclic_core(certificate):
    payload = load_json("jacobian_payload.json")
    response = load_json("jacobian_output.json")
    adapter = load_json("jacobian_status.json")
    assert adapter["adapter_exit_code"] == 0, "Jacobian did not complete successfully"
    assert adapter["timeout"] is False, "A timeout is not mathematical evidence"
    assert response["request"]["operation_id"] == certificate["jacobian"]["operation_id"]
    assert response["request"]["payload"] == payload, "Jacobian source mismatch"
    assert response["server"]["version"] == certificate["jacobian"]["server_version"]
    assert response["protocol_version"] == certificate["jacobian"]["protocol_version"]
    output = response["result"]["output"]
    assert output["matrix"]["matrix"] == payload["matrix"]
    matrix = sp.Matrix(
        [[rational(entry) for entry in row] for row in payload["matrix"]["entries"]]
    )
    identity = sp.eye(4)
    assert matrix**4 == identity
    orbit = sp.Matrix.hstack(*(matrix**i * identity[:, 0] for i in range(4)))
    assert orbit == identity, "The claimed degree-four cyclic vector is absent"
    expected = list(map(sp.Rational, certificate["jacobian"]["minimal_polynomial"]))
    for key in ("minimal_polynomial", "characteristic_polynomial"):
        assert [rational(c) for c in output[key]["coefficients"]] == expected
    assert output["degree"] == 4
    odd_projector = (identity - matrix + matrix**2 - matrix**3) / 4
    assert odd_projector**2 == odd_projector
    assert matrix * odd_projector == -odd_projector
    assert (identity + matrix + matrix**2 + matrix**3) * odd_projector == sp.zeros(4)


def check_signed_reindexing():
    histories = [(c, angle, shape) for c in range(2) for angle in range(4)
                 for shape in range(2)]
    kernel = dict(zip(histories, sp.symbols("k0:16"), strict=True))

    def coefficient(history):
        colour, _, shape = history
        return sp.Rational((-1) ** colour * (shape + 1), 16)

    def rotate(history, angle):
        colour, old_angle, shape = history
        return colour, (old_angle + angle) % 4, shape

    def flip(history):
        colour, angle, shape = history
        return 1 - colour, angle, shape

    original = sum(coefficient(h) * kernel[h] for h in histories)
    averaged = sum(
        coefficient(h) * (kernel[rotate(h, angle)] - kernel[flip(rotate(h, angle))])
        for angle in range(4) for h in histories
    ) / 8
    assert original != 0, "The check must not use a zero coefficient"
    assert sp.expand(original - averaged) == 0


def check_cotangent_algebra(certificate):
    coordinates = sp.symbols("t0:4")
    cot = {
        (i, j): (1 + coordinates[i] * coordinates[j])
        / (coordinates[i] - coordinates[j])
        for i in range(4) for j in range(4) if i != j
    }
    drift = [sum(cot[i, j] for j in range(4) if i != j) for i in range(4)]
    residual = sp.factor(sp.together(
        sum(value**2 for value in drift)
        - sum(1 + value**2 for value in cot.values()) + 20
    ))
    assert str(residual) == certificate["symbolic"]["cotangent_residual"]
    eigenvalue = sp.Rational(certificate["symbolic"]["active_generator_eigenvalue"])
    residues = []
    for i in range(4):
        active = (
            -sum(1 + cot[i, j]**2 for j in range(4) if i != j) / 4
            + drift[i]**2 / 12
            - sum(cot[i, j] * drift[j] for j in range(4) if i != j) / 6
        )
        residues.append(str(sp.factor(sp.together(active - eigenvalue))))
    assert residues == certificate["symbolic"]["active_generator_residuals"]
    assert eigenvalue / 2 == sp.Rational(
        certificate["symbolic"]["one_tuple_averaged_eigenvalue"]
    )


def check_formal_record(certificate):
    formal = certificate["formal_evidence"]
    result = load_json(formal["compiler_result"])
    assert result["status"] == "success", "Lean has not certified the finite core"
    assert result["exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["source_sha256"] == hashlib.sha256(
        (ROOT / formal["source"]).read_bytes()
    ).hexdigest(), "The source changed after compilation"
    fidelity = (ROOT / formal["statement_fidelity"]).read_text(encoding="utf-8")
    assert result["statement_fidelity_sha256"] == hashlib.sha256(
        fidelity.encode("utf-8")
    ).hexdigest(), "The statement-fidelity reading changed after compilation"


def main():
    certificate = load_json("exact_certificate.json")
    assert certificate["qualifies_as_campaign_completion"] is False
    assert certificate["refuted_manuscript_assertions"] == []
    check_cyclic_core(certificate)
    check_signed_reindexing()
    check_cotangent_algebra(certificate)
    check_formal_record(certificate)
    print(json.dumps({
        "status": "internal_exact_checks_passed",
        "result_class": certificate["result_class"],
        "formal_claim": certificate["formal_evidence"]["claim"],
        "manuscript_transfer_verdict": "open",
        "qualifies_as_campaign_completion": False,
        "unresolved": certificate["unresolved"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
