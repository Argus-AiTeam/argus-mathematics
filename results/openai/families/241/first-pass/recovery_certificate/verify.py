#!/usr/bin/env python3
"""Replay the recovery theorem and bounded exact adversarial checks."""

import json
import subprocess
from datetime import datetime, timezone
from fractions import Fraction
from math import isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_RECOVERY_CORE"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def run_json(argv):
    result = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True, check=False)
    if result.returncode:
        raise RuntimeError(
            f"Command exited {result.returncode}: {argv!r}\n"
            f"{result.stdout[-16000:]}\n{result.stderr[-4000:]}"
        )
    return json.loads(result.stdout)


def confinement_checks():
    lo, hi = Fraction(-3, 4), Fraction(2, 3)
    steps = 0
    boundary_cases = 0
    for denominator in range(2, 13):
        for numerator in range(1, denominator):
            t = Fraction(numerator, denominator)
            for k in (7, 11, 19):
                delta = Fraction(1, k)
                require(3 * delta < hi - lo, "Endpoint strips must be disjoint")
                for policy in range(3):
                    s = Fraction(0)
                    total = 0
                    for n in range(128):
                        require(lo <= s <= hi, "All-time invariant failed in a finite prefix")
                        if s <= lo + delta:
                            r = 0
                        elif s >= hi - delta:
                            r = 1
                        elif policy == 0:
                            r = n % 2
                        elif policy == 1:
                            r = int(s >= 0)
                        else:
                            r = int((n * n + 3 * n + 7) % 5 < 3)
                        s += delta * (t - r)
                        total += r
                        require(s == delta * ((n + 1) * t - total), "Telescoping sign error")
                        require(lo <= s <= hi, "Inward step escaped the interval")
                        require(
                            abs(t - Fraction(total, n + 1)) < Fraction(k, n + 1),
                            "Effective strict error bound failed",
                        )
                        steps += 1
                for s in (
                    lo, lo + delta / 2, lo + delta, lo + 2 * delta,
                    Fraction(0), hi - 2 * delta, hi - delta, hi - delta / 2, hi,
                ):
                    if not lo <= s <= hi:
                        continue
                    for r in (0, 1):
                        if (r == 1 and s <= lo + delta) or (r == 0 and s >= hi - delta):
                            continue
                        nxt = s + delta * (t - r)
                        require(lo <= nxt <= hi, "Endpoint-inclusive confinement failed")
                        boundary_cases += 1
    t, delta = Fraction(1, 2), Fraction(1, 7)
    require(lo + delta * (t - 1) < lo, "Negative control did not detect a forbidden left step")
    require(hi + delta * t > hi, "Negative control did not detect a forbidden right step")
    return {"rational_prefix_steps": steps, "endpoint_cases": boundary_cases,
            "negative_controls": 2, "classification": "finite_experiment_only"}


def cut_arithmetic_checks():
    cases = 0
    equalities = 0
    for k in (1, 7, 17):
        for a in range(6):
            for b in range(6):
                for denominator in range(1, 8):
                    query = Fraction(a - b, denominator)
                    for n in range(1, 12):
                        for total in range(n + 1):
                            low = a * n + k * denominator < total * denominator + b * n
                            high = (total + k) * denominator + b * n < a * n
                            average, error = Fraction(total, n), Fraction(k, n)
                            require(low == (query < average - error), "Lower cut orientation error")
                            require(high == (query > average + error), "Upper cut orientation error")
                            require(not (low and high), "Both strict cut branches accepted")
                            if query in (average - error, average + error):
                                equalities += 1
                            cases += 1
    queries = [Fraction(a, d) for a in range(-3, 5) for d in range(1, 8)]
    max_stage = 0
    decoded = 0
    for k in (1, 7):
        for query in queries:
            shifted = query + 1
            expected = shifted <= 0 or shifted * shifted < 2
            for n in range(1, 10001):
                total = isqrt(2 * n * n) - n
                average, error = Fraction(total, n), Fraction(k, n)
                if query < average - error:
                    answer = True
                elif query > average + error:
                    answer = False
                else:
                    continue
                require(answer == expected, "Exact sqrt(2)-1 cut fixture decoded incorrectly")
                max_stage = max(max_stage, n)
                decoded += 1
                break
            else:
                raise AssertionError("Bounded exact cut fixture did not terminate")
    return {"cross_multiplication_cases": cases, "strict_boundary_equalities": equalities,
            "quadratic_cut_queries": decoded, "quadratic_max_stage": max_stage,
            "classification": "finite_experiment_only"}


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    retained = json.loads((HERE / "jacobian_output.json").read_text())
    require(retained["protocol_version"] == "2025-11-25", "Unexpected Jacobian protocol")
    require(retained["server"]["version"] == "0.14.0", "Unexpected retained server version")
    require(retained["request"]["payload"] == payload, "Jacobian input was not retained exactly")
    result = retained["result"]
    operation = "polynomial.box.enclosure.compute"
    require(result["operation_id"] == operation, "Wrong bounded operation")
    require("output" in result and "error" not in result, "Jacobian did not return a typed result")
    output = result["output"]
    require(output["polynomial"] == payload["polynomial"], "Polynomial source mismatch")
    require(output["box"] == payload["box"], "Rational box source mismatch")
    require(output["enclosure"] == {
        "lower": {"num": "-2", "den": "1"},
        "upper": {"num": "0", "den": "1"}}, "Unexpected exact sign enclosure")
    return {"operation_id": operation, "server_version": retained["server"]["version"],
            "protocol_version": retained["protocol_version"],
            "input": "research/recovery_certificate/jacobian_payload.json",
            "typed_output": "research/recovery_certificate/jacobian_output.json",
            "adapter_exit_code": 0, "adapter_error": None, "timeout": False,
            "scope": "bounded polynomial sign check, not an infinite-orbit conclusion"}


def main():
    finite = {"confinement": confinement_checks(), "cut_arithmetic": cut_arithmetic_checks()}
    jacobian = jacobian_check()
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        "research/recovery_certificate/Main.lean",
        "--project-root", str(ROOT),
        "--claim", CLAIM,
        "--statement-fidelity", "research/recovery_certificate/statement_fidelity.md",
    ]
    lean = run_json(command)
    require(lean["status"] == "success", "Lean did not certify the source")
    require(lean["exit_code"] == 0, "Compiler exit was not zero")
    require(lean["proof_holes"] == [], "Compiler detected a proof hole")
    require("4.31.0" in lean["tools"]["lean"]["version"], "Wrong Lean version")
    require(lean["kernel"]["recorded"] is not None, "Mechanical evidence was not recorded")
    require("sorryAx" not in lean.get("stdout", ""), "An axiom report contains a proof hole")
    require("FourValueRecovery.four_value_recovery" in lean.get("stdout", ""),
            "The main theorem axiom report is missing")
    checks = {}
    for module, name in (("math_state", "math_state"), ("proof_graph_check", "proof_graph")):
        argv = [ARGUS, "-m", f"argus_skill.verticals.math.{module}",
                "check", "--project-root", str(ROOT)]
        result = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True, check=False)
        require(result.returncode == 0, f"{name} failed:\n{result.stdout}\n{result.stderr}")
        checks[name] = {"exit_code": result.returncode, "output": result.stdout.strip()}
    certificate = {
        "claim_id": CLAIM,
        "result_class": "new_theorem",
        "result_kind": "independent_machine_checked_recovery_verification",
        "scope": "universal infinite local-program recovery core, with a separate human category proof",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "significance_status": "awaiting_independent_review",
        "novelty_status": "not_assessed",
        "independent_review_complete": False,
        "campaign_complete": False,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "project_root": str(ROOT),
        "main_theorem": "FourValueRecovery.four_value_recovery",
        "oracle_substitution_theorem": "FourValueRecovery.infinite_oracle_substitution",
        "oracle_budget": {"streams": 4, "fixed_local_programs": 2,
                          "extra_real_oracles": 0,
                          "finite_constants": ["p", "q", "j", "h", "delta", "K >= 1/delta"]},
        "lean_command": command,
        "lean": {
            "status": lean["status"], "exit_code": lean["exit_code"],
            "proof_holes": lean["proof_holes"],
            "lean_version": lean["tools"]["lean"]["version"],
            "source_sha256": lean["source_sha256"],
            "statement_fidelity_sha256": lean["statement_fidelity_sha256"],
            "kernel": lean["kernel"],
            "axiom_report": lean.get("stdout", "").strip(),
            "lake_workspace": lean.get("lake_workspace", ""),
        },
        "campaign_local_checks": checks,
        "jacobian": jacobian,
        "finite_adversarial_checks": finite,
        "human_proof_dependencies": [
            "Comeager localization and countable-fiber endpoint separation, recovery.md",
            "Translation from oracle-machine programs to finite-transcript verifier codes, recovery.md",
            "Equivalence of the coded rational cut and four-stream addressing with the manuscript encodings",
        ],
        "external_inputs": [
            "Marker, Descriptive Set Theory, Fall 2002, Theorem 2.52 (nonempty Polish application)",
            "Marker, Descriptive Set Theory, Fall 2002, Corollary 2.57",
        ],
        "not_claimed": [
            "A refutation of Proposition prop:recovery",
            "A kernel proof of the category-localization argument",
            "Verification of the all-input Slaman-Woodin representation theorem",
            "Unrestricted rigidity of the Turing degrees",
            "Independent Reviewer acceptance or verified mathematical novelty",
        ],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "claim_id": CLAIM, "main_theorem": certificate["main_theorem"],
        "lean_exit_code": lean["exit_code"], "proof_holes": lean["proof_holes"],
        "project_root": str(ROOT),
        "math_state_exit_code": checks["math_state"]["exit_code"],
        "proof_graph_exit_code": checks["proof_graph"]["exit_code"],
        "certificate": "research/recovery_certificate/exact_certificate.json",
        "independent_review_complete": False,
    }, indent=2))


if __name__ == "__main__":
    main()
