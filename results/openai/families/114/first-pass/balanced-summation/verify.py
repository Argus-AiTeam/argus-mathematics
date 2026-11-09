#!/usr/bin/env python3
"""Replay exact arithmetic; separately authenticate the real Lean certificate."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path
import random

import sympy as sp


ROOT = Path(__file__).resolve().parent


def inertia(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    assert all(len(row) == len(a) for row in a)
    assert all(a[i][j] == a[j][i] for i in range(len(a)) for j in range(len(a)))
    positive = negative = zero = 0
    while a:
        n = len(a)
        pivot = next((i for i in range(n) if a[i][i]), None)
        if pivot is not None:
            order = [pivot] + [i for i in range(n) if i != pivot]
            a = [[a[i][j] for j in order] for i in order]
            d = a[0][0]
            positive += d > 0
            negative += d < 0
            a = [
                [a[i][j] - a[i][0] * a[0][j] / d for j in range(1, n)]
                for i in range(1, n)
            ]
            continue
        pair = next(
            ((i, j) for i in range(n) for j in range(i + 1, n) if a[i][j]),
            None,
        )
        if pair is None:
            zero += n
            break
        i, j = pair
        order = [i, j] + [k for k in range(n) if k not in pair]
        a = [[a[i][j] for j in order] for i in order]
        c = a[0][1]
        positive += 1
        negative += 1
        a = [
            [
                a[i][j] - (a[i][0] * a[1][j] + a[i][1] * a[0][j]) / c
                for j in range(2, n)
            ]
            for i in range(2, n)
        ]
    return positive, negative, zero


def profiles(capacities, total):
    return [
        z
        for z in itertools.product(*(range(m + 1) for m in capacities))
        if sum(z) == total
    ]


def test_matrix(weight, z, sign):
    n = len(z)
    matrix = []
    for i in range(n):
        row = []
        for j in range(n):
            v = list(z)
            v[i] += sign
            v[j] += sign
            row.append(weight.get(tuple(v), Fraction(0)))
        matrix.append(row)
    return matrix


def signature(weight, capacities, total, sign):
    count = 0
    for z in profiles(capacities, total - 2 * sign):
        count += 1
        if inertia(test_matrix(weight, z, sign))[0] > 1:
            return False, count
    return True, count


def balanced(weight, old_caps, pair_caps, total):
    out = {}
    for z in profiles(old_caps, total - sum(pair_caps)):
        value = Fraction(0)
        for choices in itertools.product(*(range(m + 1) for m in pair_caps)):
            tail = tuple(
                coordinate
                for k, m in zip(choices, pair_caps)
                for coordinate in (k, m - k)
            )
            value += weight.get(z + tail, Fraction(0))
        assert value > 0
        out[z] = value
    return out


def reflected(weight, capacities):
    return {tuple(m - v for m, v in zip(capacities, z)): w for z, w in weight.items()}


def symbolic_identity():
    v, p, q, r, left, g, right = sp.symbols("v p q r left g right", real=True)
    s = q * g - p * left
    t = r * right - q * g
    original = v + 2 * g * (s - t) + (p - 2 * q + r) * g**2
    bound = p * (g - left) ** 2 + r * (g - right) ** 2
    energy = v + 2 * q * g**2 - p * left**2 - r * right**2
    assert sp.expand(original - bound - energy) == 0
    return {
        "result_class": "polynomial_identity",
        "identity": "N(v,v)-projection_bound=V(a,a)+2*u*g^2-u_left*g_left^2-u_right*g_right^2",
        "exact_residual": "0",
        "not_a_universal_signature_certificate_by_itself": True,
    }


def inertia_controls():
    cases = [
        ([], (0, 0, 0)),
        ([[0, 0], [0, 0]], (0, 0, 2)),
        ([[0, 1], [1, 0]], (1, 1, 0)),
        ([[1, 0], [0, 1]], (2, 0, 0)),
        ([[-1, 0], [0, -2]], (0, 2, 0)),
        ([[1, 2], [2, 4]], (1, 0, 1)),
    ]
    for matrix, expected in cases:
        assert inertia(matrix) == expected
    return {"exact_congruence_controls": len(cases), "two_positive_directions_rejected": True}


def finite_experiment():
    cases = [
        ((1, 1, 1, 1), (1,), 3),
        ((2, 2, 1), (2,), 4),
        ((2, 1, 1), (3,), 4),
        ((0, 2, 2), (2,), 3),
        ((2, 2, 1), (1, 2), 5),
        ((2,), (1,), -1),
        ((2,), (1,), 0),
        ((), (2,), 2),
    ]
    rng = random.Random(114)
    records = []
    for old_caps, pair_caps, total in cases:
        caps = old_caps + tuple(m for m in pair_caps for _ in range(2))
        support = profiles(caps, total)
        tested = accepted_removal = accepted_addition = output_tests = 0
        input_tests = 0
        for variant in range(6):
            weight = {}
            for z in support:
                if variant == 0:
                    value = Fraction(1)
                elif variant < 3:
                    value = Fraction(
                        10_000 + rng.randrange(-100, 101),
                        10_000 * 2 ** sum(v * v for v in z),
                    )
                else:
                    value = Fraction(rng.randrange(1, 10))
                assert value > 0
                weight[z] = value
            tested += 1
            out = balanced(weight, old_caps, pair_caps, total)
            ref = reflected(weight, caps)
            ref_total = sum(caps) - total
            ref_out = balanced(ref, old_caps, pair_caps, ref_total)
            assert reflected(out, old_caps) == ref_out
            for sign in (-1, 1):
                for z in profiles(caps, total - 2 * sign):
                    rz = tuple(m - v for m, v in zip(caps, z))
                    assert test_matrix(weight, z, sign) == test_matrix(ref, rz, -sign)
                holds, count = signature(weight, caps, total, sign)
                input_tests += count
                if not holds:
                    continue
                if sign == -1:
                    accepted_removal += 1
                else:
                    accepted_addition += 1
                output_holds, count = signature(out, old_caps, total - sum(pair_caps), sign)
                output_tests += count
                assert output_holds, (old_caps, pair_caps, total, variant, sign)
        records.append(
            {
                "old_capacities": list(old_caps),
                "pair_capacities": list(pair_caps),
                "input_total": total,
                "weights_tested": tested,
                "admissible_removal_weights": accepted_removal,
                "admissible_addition_weights": accepted_addition,
                "exact_input_tests": input_tests,
                "exact_output_tests": output_tests,
            }
        )
    return {
        "result_class": "finite_verification",
        "arithmetic": "rational symmetric congruence with 1x1 and hyperbolic 2x2 pivots",
        "counterexamples_found": 0,
        "universal_conclusion_from_experiment": False,
        "cases": records,
    }


def jacobian_evidence():
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    assert response.get("ok", True), response
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    assert response["request"] == {"operation_id": "matrix.inertia.compute", "payload": payload}
    assert response["result"]["operation_id"] == "matrix.inertia.compute"
    result = response["result"]
    if "output" in result:
        result = result["output"]
    matrix = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in result["matrix"]["entries"]
    ]
    expected = [[Fraction(i != j) for j in range(4)] for i in range(4)]
    assert matrix == expected
    signs = inertia(matrix)
    assert signs == (1, 3, 0)
    assert signs == (result["n_positive"], result["n_negative"], result["n_zero"])
    rejected = json.loads((ROOT / "jacobian_rejected_output.json").read_text())
    assert rejected["error"]["data"]["code"] == "INVALID_REQUEST"
    return {
        "operation_id": "matrix.inertia.compute",
        "server": response["server"],
        "protocol_version": response["protocol_version"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "adapter_exit_code": 0,
        "status": "exact_typed_result_independently_replayed",
        "inertia": list(signs),
        "scope": "The M=2 middle test for the uniform full-slice weight, not the general theorem.",
        "first_request": {
            "payload_file": "jacobian_rejected_payload.json",
            "output_file": "jacobian_rejected_output.json",
            "adapter_exit_code": 2,
            "status": "invalid_request_no_mathematical_conclusion",
        },
    }


def lean_evidence():
    path = ROOT / "lean_check.json"
    result = json.loads(path.read_text())
    assert result["status"] == "success", result
    assert result["exit_code"] == 0
    assert result["audit_exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["source_sha256"] == hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    assert result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest()
    version = result["tools"]["lean"]["version"]
    assert version.startswith("Lean (version 4.31.0,"), version
    declarations = [
        "BalancedSummation.balanced_pairs_removal_spectral",
        "BalancedSummation.balanced_pairs_addition_spectral",
        "BalancedSummation.fixing_removal_spectral",
        "BalancedSummation.fixing_addition_spectral",
    ]
    axioms = {"propext", "Classical.choice", "Quot.sound"}
    for declaration in declarations:
        prefix = f"'{declaration}' depends on axioms: ["
        lines = [line for line in result["stdout"].splitlines() if line.startswith(prefix)]
        assert len(lines) == 1, (declaration, lines)
        assert lines[0].endswith("]")
        assert set(lines[0][len(prefix):-1].split(", ")) == axioms
    official = json.loads((ROOT / "lean_verify_output.json").read_text())
    recording = official["kernel"]
    assert recording["refusals"] == []
    record = recording["recorded"]
    assert record["tier"] == "mechanical" and record["verdict"] == "supports"
    assert record["produced_by"] == "lean_evidence/lean 4.31.0"
    archive = json.loads((ROOT.parent.parent / record["artifact"]).read_text())
    assert archive["lean_check"] == result
    assert archive["subject"] == record["subject"]
    assert archive["lean_source"]["text"] == (ROOT / "Main.lean").read_text()
    assert archive["statement_fidelity"]["text"] == fidelity
    state = json.loads((ROOT.parent / "MATH_STATE.json").read_text())
    claim = max(
        (claim for claim in state["claims"] if claim["claim_id"] == "C_BALANCED"),
        key=lambda claim: claim["version"],
    )
    assert record["subject"]["subject_id"] == claim["claim_id"]
    assert record["subject"]["content_hash"] == claim["content_hash"]
    assert record in state["evidence"]
    return {
        "status": "success",
        "exit_code": 0,
        "proof_holes": [],
        "lean_version": version,
        "certificate_file": path.name,
        "archived_certificate": record["artifact"],
        "declarations": declarations,
        "axioms": sorted(axioms),
        "universal_theorem_certified": True,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "claim_id": "C_BALANCED",
        "result_class": "formal_verification",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "scope": "Balanced summation only; no FPRAS or originality claim.",
        "inertia_controls": inertia_controls(),
        "symbolic_identity": symbolic_identity(),
        "finite_experiment": finite_experiment(),
        "jacobian": jacobian_evidence(),
        "lean": lean_evidence(),
        "independent_review": "required_not_performed_by_engineer",
    }
    if args.write_certificate:
        path = ROOT / "exact_certificate.json"
        path.write_text(json.dumps(certificate, indent=2) + "\n")
        assert json.loads(path.read_text()) == certificate
    else:
        stored = json.loads((ROOT / "exact_certificate.json").read_text())
        assert certificate == stored, "Certificate does not reproduce the current evidence."
    print(json.dumps({
        "ok": True,
        "universal_theorem_certified": certificate["lean"]["universal_theorem_certified"],
        "lean_exit_code": certificate["lean"]["exit_code"],
        "proof_holes": certificate["lean"]["proof_holes"],
        "finite_cases": len(certificate["finite_experiment"]["cases"]),
    }))


if __name__ == "__main__":
    main()
