#!/usr/bin/env python3
"""Replay the universal upper proof and separate exact finite obstruction checks."""

import argparse
from datetime import datetime, timezone
from fractions import Fraction
import json
from math import comb, isqrt, prod
from pathlib import Path
import re
import subprocess
import sys
from time import monotonic

from prepare import source_text


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_GROWING_DIVISOR_UPPER"
THEOREMS = (
    "GrowingDivisorMoments.momentSeriesConst_explicit",
    "GrowingDivisorMoments.growing_divisor_moment_real",
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def unit_log_bounds(x, terms=24):
    if not 1 <= x <= 2:
        raise ValueError("The reduced logarithm argument must lie in [1,2].")
    z = (x - 1) / (x + 1)
    lower = 2 * sum((z ** (2 * j + 1) / (2 * j + 1) for j in range(terms)), Fraction())
    tail = 2 * z ** (2 * terms + 1) / ((2 * terms + 1) * (1 - z * z))
    return lower, lower + tail


def log_bounds(x):
    x = Fraction(x)
    if x < 1:
        raise ValueError("This certificate only needs logarithms of arguments >=1.")
    exponent = 0
    while x > 2:
        x /= 2
        exponent += 1
    lower, upper = unit_log_bounds(x)
    lo2, hi2 = unit_log_bounds(Fraction(2))
    lower += exponent * lo2
    upper += exponent * hi2
    scale = 10**9
    lo = (lower.numerator * scale) // lower.denominator
    hi = -((-upper.numerator * scale) // upper.denominator)
    return Fraction(lo, scale), Fraction(hi, scale)


def interval_json(bounds):
    return [str(endpoint) for endpoint in bounds]


def primes_le(t):
    return [p for p in range(2, t + 1)
            if all(p % d for d in range(2, isqrt(p) + 1))]


def divisor_count(x, n):
    if n < 1:
        raise ValueError("A positive integer is required.")
    result = 0
    for d in range(1, isqrt(n) + 1):
        if n % d == 0:
            result += d <= x
            result += n // d <= x and n // d != d
    return result


def series_checks():
    q = Fraction(3, 4)
    numerator = [1]
    largest = None
    for k in range(65):
        value = sum((a * q**j for j, a in enumerate(numerator)), Fraction()) / (1 - q)**(k + 1)
        bound = 16 * (4 * k)**k
        require(0 < value <= bound, f"Series estimate failed at order {k}.")
        largest = {"k": k, "exact_series_value": str(value), "bound": str(bound)}
        next_numerator = [0] * (len(numerator) + 1)
        for j, a in enumerate(numerator):
            next_numerator[j] += (j + 2) * a
            next_numerator[j + 1] += (k - 1 - j) * a
        numerator = next_numerator
    return {
        "classification": "finite_orders_only; universal series inequality is kernel-certified",
        "orders": [0, 64],
        "count": 65,
        "method": "F_k(q)=P_k(q)/(1-q)^(k+1); F_(k+1)=q F'_k+2 F_k",
        "largest_checked": largest,
    }


def witness(t, x_power, y_power, root_bound, exp_power, full_sum=False):
    s = 2 * t
    ps = primes_le(t)
    p = prod(ps)
    x, y = 2**x_power, 2**y_power
    lo2, hi2 = log_bounds(2)
    log_s = log_bounds(s)
    loglog_s = (log_bounds(log_s[0])[0], log_bounds(log_s[1])[1])
    require(loglog_s[0] > 0, "The moment-order denominator must be positive.")
    r_bounds = (4 * log_s[0] / loglog_s[1], 4 * log_s[1] / loglog_s[0])
    require(r_bounds[0] >= 8, "The real order is not bounded below by the tested order.")
    require(2 * log_s[0] * x_power * lo2 >= s, "The lower log(X) constraint failed.")
    require(x_power * hi2 <= s, "The upper log(X) constraint failed.")
    require(x <= y*y and y <= x, "The real interval-length constraints failed.")
    require(p < 2**s and hi2 < 1, "The shift bound N<exp(S) was not established.")
    require(s < root_bound**4, "The strict fourth-root upper bound failed.")
    require(root_bound < exp_power * lo2, "The exponential enclosure failed.")
    k = x_power // (t.bit_length() - 1)
    require(t == 2**(t.bit_length() - 1), "This witness must use a dyadic prime cutoff.")
    require(1 <= k <= len(ps) and t**k <= x, "The subset products exceed X.")
    b = comb(len(ps), k)
    require(b * k**k >= len(ps)**k, "The elementary binomial lower bound failed.")
    rhs_upper = y * 2**exp_power
    if full_sum:
        counts = [divisor_count(x, p - 1 + h) for h in range(1, y + 1)]
        require(all(d >= 1 for d in counts), "The monotone real-power comparison failed.")
        lower = sum(d**8 for d in counts)
        require(counts[0] >= b, "The primorial subset-product bound failed.")
    else:
        counts = None
        lower = b**8
    require(lower > rhs_upper, "The finite witness does not strictly violate the target bound.")
    return {
        "classification": "exact_finite_witness_not_proof_of_the_infinite_family",
        "D": 1, "S": s, "t": t, "X": x, "Y": y, "N": str(p - 1),
        "r": "4*log(S)/log(log(S))",
        "r_enclosure": interval_json(r_bounds),
        "log_S_enclosure": interval_json(log_s),
        "loglog_S_enclosure": interval_json(loglog_s),
        "primes": ps, "subset_size": k, "subset_product_count_lower": str(b),
        "full_interval_counts": counts,
        "moment_lower_at_integer_order_8": str(lower),
        "strict_rhs_upper": str(rhs_upper),
        "rhs_upper_reason": f"S^(1/4)<{root_bound}<{exp_power}*log(2)",
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "integer.compute.divisor_count"
    require(contract["result"]["operation"]["operation_id"] == operation, "Wrong typed contract.")
    require(output["request"] == {"operation_id": operation, "payload": payload}, "Payload mismatch.")
    require(output["result"]["operation_id"] == operation, "Wrong operation result.")
    require(payload == {"n": 2310}, "Unexpected finite squarefree input.")
    require(int(output["result"]["output"]["value"]) == divisor_count(2310, 2310) == 32,
            "The exact Jacobian divisor count disagrees.")
    return {
        "operation_id": operation, "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"], "adapter_status": "success",
        "adapter_error": None, "timeout": False,
        "payload_file": "research/growing_divisor_moments/jacobian_payload.json",
        "contract_file": "research/growing_divisor_moments/jacobian_contract.json",
        "typed_output_file": "research/growing_divisor_moments/jacobian_output.json",
        "scope": "Only tau(2310)=32; not an asymptotic conclusion.",
    }


def finite_checks():
    return {
        "series": series_checks(),
        "witnesses": [witness(16, 7, 4, 3, 5, full_sum=True), witness(256, 60, 30, 5, 8)],
        "jacobian": jacobian_check(),
        "logarithm_method": "Exact rational atanh series with a proved geometric tail bound; no floating point.",
    }


def campaign_checks():
    checks = []
    for module in ("math_state", "proof_graph_check"):
        command = [ARGUS, "-m", f"argus_skill.verticals.math.{module}",
                   "check", "--project-root", str(PROJECT)]
        result = subprocess.run(command, cwd=PROJECT, capture_output=True, text=True)
        checks.append({"module": module, "command": command, "exit_code": result.returncode,
                       "stdout": result.stdout, "stderr": result.stderr})
    report = {"project_root": str(PROJECT), "checks": checks}
    (HERE / "campaign_checks.json").write_text(json.dumps(report, indent=2) + "\n")
    require(all(check["exit_code"] == 0 for check in checks),
            "Campaign-local structural validation failed: " + json.dumps(report))
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--finite-only", action="store_true",
                        help="Run the exact finite checks without claiming universal certification.")
    args = parser.parse_args()
    start = monotonic()
    sanity = finite_checks()
    if args.finite_only:
        print(json.dumps(sanity, indent=2))
        return 0
    require((HERE / "Main.lean").read_text() == source_text(),
            "Main.lean does not match the approved dependency slice and new proof source.")
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE), "--claim", CLAIM, "--project-root", str(PROJECT),
    ]
    result = subprocess.run(command, cwd=PROJECT, capture_output=True, text=True)
    checks = campaign_checks()
    if result.returncode:
        sys.stderr.write(result.stdout + result.stderr)
        return result.returncode
    evidence = json.loads(result.stdout)
    require(evidence["status"] == "success" and evidence["exit_code"] == 0, "Lean did not succeed.")
    require(evidence["audit_exit_code"] == 0 and evidence["proof_holes"] == [], "Proof holes remain.")
    version = evidence["tools"]["lean"]["version"]
    require(re.search(r"version 4\.31\.0\b", version), f"Incorrect Lean version: {version}")
    mechanical = evidence["kernel"]["recorded"]
    require(mechanical is not None, "The compiler result was not attached to the claim ledger.")
    reports = dict(re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",
                              evidence["stdout"], re.DOTALL))
    axioms = {}
    for theorem in THEOREMS:
        require(theorem in reports, f"Missing axiom report for {theorem}.")
        axioms[theorem] = [a.strip() for a in reports[theorem].split(",") if a.strip()]
        require(set(axioms[theorem]) <= {"propext", "Classical.choice", "Quot.sound"},
                f"Nonfoundational axiom in {theorem}: {axioms[theorem]}")
    certificate = {
        "claim": CLAIM, "result_class": "new_theorem_candidate",
        "status": "kernel_upper_verified_obstruction_and_novelty_await_independent_review",
        "research_target_level": "publishable", "math_objective_mode": "exploratory",
        "upper_constant": "1/200000",
        "obstruction_constants": "Every fixed C>1/2; C=4 checked in finite witnesses.",
        "universal_upper": {
            "evidence_type": "Lean 4.31.0 kernel proof with no postulated target estimate",
            "source": "research/growing_divisor_moments/Main.lean",
            "statement_fidelity": "research/growing_divisor_moments/statement_fidelity.md",
            "lean_version": version, "exit_code": evidence["exit_code"],
            "audit_exit_code": evidence["audit_exit_code"], "proof_holes": evidence["proof_holes"],
            "source_sha256": evidence["source_sha256"],
            "statement_fidelity_sha256": evidence["statement_fidelity_sha256"],
            "axioms": axioms, "mechanical_evidence": mechanical,
        },
        "infinite_obstruction": {
            "evidence_type": "Complete mathematical proof, not Lean-certified",
            "proof": "research/growing_divisor_moments/proof.md#infinite-obstruction-theorem",
            "family": "t=2^m; S=2t; N=prod_(p<=t)p-1; X=exp(S/(2log S)); Y=sqrt X; D=1",
            "prime_inputs": "Elementary dyadic central-binomial and Legendre-valuation arguments proved in the note.",
            "external_analytic_assumptions": [],
            "independent_review": "Required; finite witness checks do not certify the infinite quantifier.",
        },
        "cited_analytic_inputs": {
            "upper_or_obstruction_dependencies": [],
            "comparison_only": "research/growing_divisor_moments/literature/comparison.md",
            "citation_attribution": "Host-owned independent Reviewer still owes the recorded primary-source attributions.",
        },
        "finite_checks": sanity, "campaign_checks": checks,
        "novelty_status": "unestablished", "significance_status": "unreviewed",
        "independent_review": "Required; the Engineer has not accepted its own theorem.",
        "false_manuscript_assertions_identified": [],
        "elapsed_seconds": round(monotonic() - start, 3),
    }
    path = HERE / "exact_certificate.json"
    path.write_text(json.dumps(certificate, indent=2) + "\n")
    action = {
        "ts": datetime.now(timezone.utc).isoformat(), "role": "engineer", "agent": "gpt-6.1-sol",
        "kind": "exact_replay",
        "action": "Certified the growing real-order upper theorem with Lean 4.31.0, no proof holes, "
                  "and only standard foundational axioms. Exact finite obstruction witnesses passed. "
                  f"Both official checks exited 0 at {PROJECT}. Infinite-family reading, source "
                  "attribution, novelty and significance remain for the Host-owned Reviewer.",
        "status": "ready_for_review", "artifact": "research/growing_divisor_moments/exact_certificate.json",
    }
    with (PROJECT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps(action) + "\n")
    print(json.dumps({"claim": CLAIM, "exit_code": 0, "proof_holes": [],
                      "status": certificate["status"], "certificate": str(path),
                      "project_root": str(PROJECT),
                      "campaign_check_exit_codes": [c["exit_code"] for c in checks["checks"]],
                      "elapsed_seconds": certificate["elapsed_seconds"]}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
