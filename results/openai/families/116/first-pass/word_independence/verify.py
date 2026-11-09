#!/usr/bin/env python3
"""Replay the universal Lean proof and separate exact finite experiments.

Run from any directory with the explicit Argus interpreter. The default
invokes the real compiler and axiom audit and records C_WORD_INDEPENDENCE.
Finite ranks are reported as experiments, never as the universal proof.
"""

import json
import subprocess
from itertools import product
from pathlib import Path

from sympy import GF, QQ
from sympy.polys.matrices import DomainMatrix


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_WORD_INDEPENDENCE"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def run_checked(command):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    require(
        result.returncode == 0,
        f"command failed ({result.returncode}): {command}\n{result.stdout}\n{result.stderr}",
    )
    return result.stdout


def formal_proof():
    output = run_checked(
        [
            ARGUS_PYTHON,
            "-m",
            "argus_skill.verticals.math.lean_evidence",
            "verify",
            str(HERE / "Main.lean"),
            "--statement-fidelity",
            str(HERE / "statement_fidelity.md"),
            "--claim",
            CLAIM,
            "--project-root",
            str(ROOT),
            "--artifact-dir",
            str(HERE / "certificates"),
            "--timeout",
            "600",
        ]
    )
    (HERE / "lean_verification.json").write_text(output)
    run = json.loads(output)
    require(run["status"] == "success", "official Lean verification did not succeed")
    require(run["exit_code"] == 0, "Lean rejected the formalization")
    require(run["audit_exit_code"] == 0, "the axiom audit did not pass")
    require(run["proof_holes"] == [], "the proof has holes")
    require(run["environment_failure"] == "", "the compiler environment failed")
    require(run["kernel"]["refusals"] == [], "claim-bound evidence was refused")
    evidence = run["kernel"]["recorded"]
    require(evidence["tier"] == "mechanical", "evidence is not mechanical")
    require(evidence["verdict"] == "supports", "the compiler did not support the claim")
    require(evidence["subject"]["subject_id"] == CLAIM, "wrong claim was certified")
    archive = json.loads((ROOT / evidence["artifact"]).read_text())
    require(archive["evidence_id"] == evidence["evidence_id"], "archive binding differs")
    require(archive["subject"] == evidence["subject"], "archive claim differs")
    require(
        archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
        "the current source differs from the checked source",
    )
    require(
        archive["statement_fidelity"]["text"]
        == (HERE / "statement_fidelity.md").read_text(),
        "the statement reading differs from the checked reading",
    )
    for key in ("source_sha256", "statement_fidelity_sha256", "exit_code", "proof_holes"):
        require(archive["lean_check"][key] == run[key], f"archive mismatch: {key}")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in ledger["claims"] if c["claim_id"] == CLAIM),
        key=lambda c: c["version"],
    )
    require(claim["content_hash"] == evidence["subject"]["content_hash"], "stale claim")
    require(
        any(item == evidence for item in ledger["evidence"]),
        "the mechanical evidence is absent from the campaign ledger",
    )
    require("version 4.31.0," in run["tools"]["lean"]["version"], "wrong Lean version")
    for declaration in (
        "word_series_linearIndependent",
        "parameter_fixed_field",
        "word_pole_obstruction",
        "integrate_unique",
    ):
        expected = (
            f"'WordIndependence.{declaration}' depends on axioms: "
            "[propext, Classical.choice, Quot.sound]"
        )
        require(expected in run["stdout"].splitlines(), f"unexpected axioms: {declaration}")
    return {
        "theorem": "WordIndependence.word_series_linearIndependent",
        "claim_version": claim["version"],
        "evidence": evidence["artifact"],
        "lean_version": "4.31.0",
        "exit_code": run["exit_code"],
        "audit_exit_code": run["audit_exit_code"],
        "proof_holes": run["proof_holes"],
        "axioms": ["propext", "Classical.choice", "Quot.sound"],
        "source_sha256": run["source_sha256"],
        "statement_fidelity_sha256": run["statement_fidelity_sha256"],
        "claim_content_hash": claim["content_hash"],
    }


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


def words(n, length):
    return [w for k in range(length + 1) for w in product(range(1, n + 1), repeat=k)]


def word_jets(field, t, n, length, horizon):
    jets = {(): [field.one] + [field.zero] * (horizon - 1)}
    for w in words(n, length)[1:]:
        a = (field.one + t) ** w[0]
        tail = jets[w[1:]]
        coefficients = [field.zero]
        for r in range(1, horizon):
            rhs = sum(
                (a ** (k - 1) * tail[r - k] for k in range(1, r + 1)),
                field.zero,
            )
            denominator = t**r - field.one
            require(denominator != field.zero, f"invalid resonance at r={r}")
            coefficient = rhs / denominator
            require(denominator * coefficient == rhs, "shift equation failed")
            coefficients.append(coefficient)
        require(all(c == field.zero for c in coefficients[: len(w)]), "order raising failed")
        jets[w] = coefficients
    return jets


def finite_experiments():
    results = {}
    for characteristic, base in ((0, QQ), (2, GF(2)), (3, GF(3)), (5, GF(5))):
        field = base.frac_field("t")
        t = field.gens[0]
        label = "QQ(t)" if characteristic == 0 else f"F{characteristic}(t)"
        n_orbit = 6 if characteristic == 0 else 2 * characteristic
        orbit_values = [
            t**j / (field.one + t) ** i
            for i in range(1, n_orbit + 1)
            for j in range(-3, 4)
        ]
        require(len(set(orbit_values)) == len(orbit_values), "finite orbit collision")
        rank_cases = []
        for n, length, degree in ((1, 2, 1), (2, 1, 1), (2, 2, 0), (1, 3, 0)):
            family = [(w, d) for w in words(n, length) for d in range(degree + 1)]
            horizon = len(family) + 4
            jets = word_jets(field, t, n, length, horizon)
            rows = [
                [
                    jets[w][r - d] if r >= d else field.zero
                    for w, d in family
                ]
                for r in range(horizon)
            ]
            rank = DomainMatrix(rows, (horizon, len(family)), field).rank()
            require(rank == len(family), f"finite rank deficiency in {label}: {n,length,degree}")
            rank_cases.append(
                {
                    "letters": n,
                    "maximum_word_length": length,
                    "polynomial_coefficient_degree": degree,
                    "horizon": horizon,
                    "columns": len(family),
                    "rank": rank,
                }
            )
        orientation = word_jets(field, t, 2, 2, 7)
        difference_degree = next(
            (r for r in range(7) if orientation[(1, 2)][r] != orientation[(2, 1)][r]),
            None,
        )
        require(difference_degree is not None, f"prefix orientation test inconclusive in {label}")
        results[label] = {
            "orbit_points": len(orbit_values),
            "distinct_orbit_points": len(set(orbit_values)),
            "characteristic_dividing_letter_indices": (
                [] if characteristic == 0 else [characteristic, 2 * characteristic]
            ),
            "polynomial_relation_rank_experiments": rank_cases,
            "h12_minus_h21_first_nonzero_degree": difference_degree,
        }
    return {
        "classification": "finite_verification_only; not the universal proof",
        "fields": results,
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_output.json").read_text())
    require(result["request"]["payload"] == payload, "Jacobian payload changed")
    operation = "formal_series.rational.multiply.compute"
    require(result["request"]["operation_id"] == operation, "wrong Jacobian operation")
    output = result["result"]["output"]
    expected = [
        {"num": "0", "den": "1"},
        {"num": "0", "den": "1"},
        {"num": "1", "den": "1"},
        {"num": "4", "den": "1"},
        {"num": "93", "den": "7"},
    ]
    require(output["result"]["coefficients"] == expected, "wrong exact Cauchy product")
    require(output["exactness"] == "EXACT_RATIONAL", "nonexact Jacobian result")
    require(output["residual_congruence"] == "EXACT_MOD_X_TO_N", "wrong truncation")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_status": "success",
        "scope": "one QQ computation at t=2 modulo z^5, not a proof over arbitrary fields",
    }


def main():
    formal = formal_proof()
    validation = structural_checks()
    certificate = {
        "claim": CLAIM,
        "result_class": "complete_solution",
        "scope": "full thm:words only, not the complete hitting theorem",
        "formal_proof": formal,
        "finite_experiments": finite_experiments(),
        "jacobian": jacobian_check(),
        "campaign_local_validation": validation,
        "independent_review": "required_pending_host_invocation",
        "novelty_status": "not_assessed",
    }
    text = json.dumps(certificate, indent=2) + "\n"
    (HERE / "exact_certificate.json").write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
