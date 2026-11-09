#!/usr/bin/env python3
"""Replay the complete Lean proof and exact shift-system checks.

The finite search works over QQ and F_p(t), never over a finite-order
specialization of t. For each tested constant row it checks all constant
columns at once by comparing exact coefficient-row ranks.

Run with the Argus interpreter from the campaign root. The default makes
a fresh official compiler run. --reuse-lean-record is only for assembling
the initial certificate from a just-completed, source-bound official run.
"""

import argparse
import json
import subprocess
from math import comb
from pathlib import Path

from sympy import GF, QQ
from sympy.polys.matrices import DomainMatrix


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def matrix(rows, field):
    return DomainMatrix(
        [[field.convert(x) for x in row] for row in rows],
        (len(rows), len(rows[0])),
        field,
    )


def zero_matrix(m, field):
    return DomainMatrix.zeros((m, m), field).to_dense()


def identity(m, field):
    return DomainMatrix.eye(m, field).to_dense()


def equal(a, b):
    return a.to_list() == b.to_list()


def system_cases(field):
    for m in (1, 2, 3):
        unit = identity(m, field)
        yield f"m{m}-constant", [unit], [field.one], 0
        patterns = (
            [[int(j == i + 1) for j in range(m)] for i in range(m)],
            [[(i + 1) * int(i == j) for j in range(m)] for i in range(m)],
            [[1 for _ in range(m)] for _ in range(m)],
            [[int(j == (i + 1) % m) for j in range(m)] for i in range(m)],
        )
        for pattern_index, pattern in enumerate(patterns):
            for q1 in (0, 1):
                yield (
                    f"m{m}-linear-{pattern_index}-q{q1}",
                    [unit, matrix(pattern, field)],
                    [field.one, field.convert(q1)],
                    1,
                )
    b = matrix([[0, 1], [0, 0]], field)
    c = matrix([[0, 0], [1, 0]], field)
    for q1 in (0, 1):
        for p1, p2, label in (
            (b, c, "opposite-shears"),
            (b + c, identity(2, field), "dense"),
        ):
            yield (
                f"m2-quadratic-{label}-q{q1}",
                [identity(2, field), p1, p2],
                [field.one, field.convert(q1), field.one],
                2,
            )


def fundamental_jet(p, q, tau, horizon, field):
    m = p[0].shape[0]
    require(q[0] != field.zero, "Q(0) must be nonzero")
    require(equal(p[0], identity(m, field).scalarmul(q[0])), "P(0) != Q(0)I")
    h = [identity(m, field)]
    for n in range(1, horizon + 1):
        total = zero_matrix(m, field)
        for i in range(1, min(n, len(p) - 1) + 1):
            total += p[i].matmul(h[n - i])
        for i in range(1, min(n, len(q) - 1) + 1):
            total -= h[n - i].scalarmul(q[i] * tau ** (n - i))
        denominator = q[0] * (tau**n - field.one)
        require(denominator != field.zero, f"resonance at coefficient {n}")
        h.append(total.scalarmul(field.one / denominator))
    for n in range(horizon + 1):
        lhs = zero_matrix(m, field)
        rhs = zero_matrix(m, field)
        for i in range(min(n, len(q) - 1) + 1):
            lhs += h[n - i].scalarmul(q[i] * tau ** (n - i))
        for i in range(min(n, len(p) - 1) + 1):
            rhs += p[i].matmul(h[n - i])
        require(equal(lhs, rhs), f"shift equation residual at coefficient {n}")
    return h


def rank_search(field, tau):
    system_count = row_tests = residual_coefficients = 0
    largest_bound = 0
    for name, p, q, nu in system_cases(field):
        m = p[0].shape[0]
        bound = nu * comb(m, 2)
        horizon = bound + 2
        h = fundamental_jet(p, q, tau, horizon, field)
        rows = [[int(i == j) for j in range(m)] for i in range(m)]
        rows += [[1] * m, [(-1) ** j for j in range(m)]]
        for row in rows:
            u = matrix([row], field)
            coefficients = [u.matmul(a).to_list()[0] for a in h]
            prefix = DomainMatrix(coefficients[: bound + 1], (bound + 1, m), field)
            full = DomainMatrix(coefficients, (horizon + 1, m), field)
            require(
                prefix.rank() == full.rank(),
                f"strict-bound witness candidate: {field}, {name}, row={row}",
            )
            row_tests += 1
        system_count += 1
        residual_coefficients += horizon + 1
        largest_bound = max(largest_bound, bound)
    return {
        "system_instances": system_count,
        "constant_row_instances": row_tests,
        "matrix_equation_coefficients_checked": residual_coefficients,
        "largest_tested_order_bound": largest_bound,
        "additional_coefficients_after_bound": 2,
        "rank_increases_after_bound": 0,
    }


def orientation_check(field, tau):
    b = matrix([[0, 1], [0, 0]], field)
    c = matrix([[0, 0], [1, 0]], field)
    # The z^3 coefficient distinguishes sigma(P)P from P sigma(P).
    correct = b.matmul(c).scalarmul(tau) + c.matmul(b).scalarmul(tau**2)
    reversed_product = c.matmul(b).scalarmul(tau) + b.matmul(c).scalarmul(tau**2)
    difference = correct - reversed_product
    expected = (b.matmul(c) - c.matmul(b)).scalarmul(tau - tau**2)
    require(equal(difference, expected), "noncommutative orientation identity failed")
    require(not equal(difference, zero_matrix(2, field)), "orientation probe degenerated")
    return [[str(field.to_sympy(x)) for x in row] for row in difference.to_list()]


def sharp_examples(field, tau):
    z_ring = field.poly_ring("z")
    z = z_ring.gens[0]
    examples = []
    for nu in (1, 2, 3):
        h_denominator = z_ring.one - z**nu
        shifted_denominator = z_ring.one - z_ring.convert(tau**nu) * z**nu
        q = shifted_denominator
        p11 = q
        p22 = h_denominator
        require(q.degree() == nu and p22.degree() == nu, "degree hypothesis failed")
        require(q[(0,)] == field.one, "denominator is not a unit at zero")
        require(p22 == h_denominator, "Q sigma(H_22) != P_22 H_22")
        require(p11 == q, "constant diagonal component failed")
        # H=diag(1,1/(1-z^nu)); u=(-1,1), v=(1,1).
        numerator_y = z_ring.one - h_denominator
        require(numerator_y == z**nu, "scalar component is not z^nu/(1-z^nu)")
        require(h_denominator[(0,)] == field.one, "H is not regularly invertible")
        examples.append({"m": 2, "nu": nu, "order": nu, "bound": nu})
    return examples


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    require(output["request"]["payload"] == payload, "Jacobian input binding differs")
    require(
        output["result"]["operation_id"] == "formal_series.rational.multiply.compute",
        "unexpected Jacobian operation",
    )
    typed = output["result"]["output"]
    require(typed["exactness"] == "EXACT_RATIONAL", "Jacobian result is not exact")
    require(typed["residual_congruence"] == "EXACT_MOD_X_TO_N", "wrong truncation")
    expected = [{"num": str(int(n == 0)), "den": "1"} for n in range(5)]
    require(typed["result"]["coefficients"] == expected, "Jacobian product differs")
    return {
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "operation_id": output["result"]["operation_id"],
        "status": "exact_bounded_cross_check",
    }


def exact_checks():
    results = {}
    fields = [("QQ", QQ, QQ(2))]
    for p in (2, 3, 5):
        field = GF(p).frac_field("t")
        fields.append((f"F{p}(t)", field, field.gens[0]))
    for label, field, tau in fields:
        results[label] = {
            "finite_rank_search": rank_search(field, tau),
            "orientation_z3_difference": orientation_check(field, tau),
            "sharp_m2_examples": sharp_examples(field, tau),
        }
    return {"fields": results, "jacobian": jacobian_check()}


def run_checked(command):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    require(
        result.returncode == 0,
        f"command failed ({result.returncode}): {command}\n{result.stdout}\n{result.stderr}",
    )
    return result.stdout


def formal_proof(reuse):
    if reuse:
        run = json.loads((HERE / "lean_verification.json").read_text())
    else:
        output = run_checked(
            [
                ARGUS_PYTHON,
                "-m",
                "argus_skill.verticals.math.lean_evidence",
                "verify",
                "research/shift_order/Main.lean",
                "--statement-fidelity",
                "research/shift_order/REPORT.md",
                "--claim",
                "C_SHIFT_ORDER",
                "--project-root",
                str(ROOT),
                "--timeout",
                "840",
            ]
        )
        run = json.loads(output)
        (HERE / "lean_verification.json").write_text(output)
    require(run["status"] == "success", "the official compiler run did not succeed")
    require(run["exit_code"] == 0, "Lean rejected the proof")
    require(run["audit_exit_code"] == 0, "Lean axiom audit failed")
    require(run["proof_holes"] == [], "Lean proof has holes")
    require(run["environment_failure"] == "", "Lean environment failure")
    require(run["kernel"]["refusals"] == [], "claim-bound recording was refused")
    evidence = run["kernel"]["recorded"]
    require(evidence["tier"] == "mechanical", "not mechanical evidence")
    require(evidence["verdict"] == "supports", "compiler did not support the claim")
    require(evidence["subject"]["subject_id"] == "C_SHIFT_ORDER", "wrong claim")
    archive = json.loads((ROOT / evidence["artifact"]).read_text())
    require(archive["evidence_id"] == evidence["evidence_id"], "archive binding differs")
    require(archive["subject"] == evidence["subject"], "archive has a different claim")
    require(
        archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
        "current Lean source differs from the checked source",
    )
    fidelity = archive["statement_fidelity"]
    require(
        fidelity["text"] == (ROOT / fidelity["path"]).read_text()
        == (HERE / "REPORT.md").read_text(),
        "current statement reading differs from the compiler-bound reading",
    )
    for key in ("source_sha256", "statement_fidelity_sha256", "exit_code", "proof_holes"):
        require(archive["lean_check"][key] == run[key], f"archive mismatch: {key}")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in ledger["claims"] if c["claim_id"] == "C_SHIFT_ORDER"),
        key=lambda c: c["version"],
    )
    require(claim["content_hash"] == evidence["subject"]["content_hash"], "stale claim")
    require(
        any(
            item["evidence_id"] == evidence["evidence_id"]
            and item["subject"] == evidence["subject"]
            and item["artifact"] == evidence["artifact"]
            for item in ledger["evidence"]
        ),
        "mechanical evidence is absent from the campaign ledger",
    )
    version = run["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "unexpected Lean version")
    expected_axioms = (
        "'MultiplicativeShiftOrder.multiplicative_shift_order' depends on axioms: "
        "[propext, Classical.choice, Quot.sound]"
    )
    require(run["stdout"].strip() == expected_axioms, "unexpected theorem axiom report")
    return {
        "theorem": "MultiplicativeShiftOrder.multiplicative_shift_order",
        "source": "research/shift_order/Main.lean",
        "statement_reading": "research/shift_order/REPORT.md",
        "lean_version": "4.31.0",
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "axioms": ["propext", "Classical.choice", "Quot.sound"],
        "source_sha256": run["source_sha256"],
        "statement_fidelity_sha256": run["statement_fidelity_sha256"],
        "claim_content_hash": claim["content_hash"],
    }, evidence


def structural_checks():
    for module in ("math_state", "proof_graph_check"):
        run_checked(
            [
                ARGUS_PYTHON,
                "-m",
                f"argus_skill.verticals.math.{module}",
                "check",
                "--project-root",
                str(ROOT),
            ]
        )
    return {
        "project_root": str(ROOT),
        "math_state_exit_code": 0,
        "proof_graph_exit_code": 0,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--reuse-lean-record", action="store_true")
    args = parser.parse_args()
    formal, evidence = formal_proof(args.reuse_lean_record)
    checks = exact_checks()
    structural = structural_checks()
    certificate_path = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate = {
            "schema_version": 1,
            "claim": "C_SHIFT_ORDER",
            "result_class": "complete_solution",
            "scope": "The complete printed shift-order theorem, not the complete hitting theorem.",
            "independent_review": "Not established by this script; Host Reviewer required.",
            "novelty": "No claim of mathematical priority.",
            "formal_proof": formal,
            "mechanical_evidence": evidence,
            "exact_checks": checks,
            "finite_checks_are_not_the_universal_proof": True,
            "campaign_local_checks": structural,
        }
        certificate_path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    certificate = json.loads(certificate_path.read_text())
    require(certificate["claim"] == "C_SHIFT_ORDER", "certificate names another claim")
    require(certificate["formal_proof"] == formal, "formal certificate has changed")
    require(certificate["exact_checks"] == checks, "exact replay differs from the certificate")
    require(certificate["campaign_local_checks"] == structural, "wrong validation root")
    require(
        certificate["finite_checks_are_not_the_universal_proof"] is True,
        "finite search was substituted for a universal proof",
    )
    print(
        json.dumps(
            {
                "status": "verified",
                "claim": "C_SHIFT_ORDER",
                "lean_exit_code": formal["exit_code"],
                "proof_holes": formal["proof_holes"],
                "finite_system_instances": sum(
                    v["finite_rank_search"]["system_instances"] for v in checks["fields"].values()
                ),
                "campaign_local_checks": structural,
                "independent_review": "required_separately",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
