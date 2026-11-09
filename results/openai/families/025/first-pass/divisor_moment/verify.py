#!/usr/bin/env python3
"""Replay exact sanity checks and the full-quantifier Lean 4.31.0 certificate."""

from fractions import Fraction
import json
from math import isqrt
from pathlib import Path
import re
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_DIVISOR_MOMENT_REAL"
THEOREMS = (
    "OAI.ShortEgyptian.uniform_divisor_moment",
    "DivisorMomentAudit.manuscript_divisor_moment",
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def divisors(n):
    if n < 1:
        raise ValueError("Only positive integers have a finite divisor list here.")
    small = [a for a in range(1, isqrt(n) + 1) if n % a == 0]
    return sorted(set(small + [n // a for a in small]))


def count(x, n):
    return sum(a <= x for a in divisors(n))


def finite_checks():
    xs = tuple(map(Fraction, (1, "3/2", "17/3", 12, "25/2")))
    ys = tuple(map(Fraction, (0, "1/2", 1, "3/2", "7/3", 10, "101/10")))
    shifts = (0, 1, 17, 100, 10**6)
    shifted_cases = 0
    for n in shifts:
        for y in ys:
            hmax = y.numerator // y.denominator
            hs = list(range(1, hmax + 1))
            ns = list(range(n + 1, n + hmax + 1))
            require([n + h for h in hs] == ns, "Shifted interval mismatch.")
            require(all(Fraction(h) <= y for h in hs), "Incorrect real endpoint.")
            require(Fraction(hmax + 1) > y, "Upper floor endpoint omitted an integer.")
            for x in xs:
                for k in (1, 2, 4):
                    left = sum(count(x, n + h) ** k for h in hs)
                    right = sum(count(x, m) ** k for m in ns)
                    require(left == right, "Shifted moment sums differ.")
                    shifted_cases += 1

    factor_cases = 0
    for n in range(1, 129):
        for d in divisors(n):
            for x in xs:
                require(
                    count(x, n) <= len(divisors(d)) * count(x, n // d),
                    f"Divisor-product inequality failed at {(x, n, d)}.",
                )
                factor_cases += 1

    ceiling_cases = 0
    for r in map(Fraction, (1, "3/2", "7/3", "16/5", "101/10")):
        k = -(-r.numerator // r.denominator)
        for d in range(1, 65):
            require(d**r.numerator <= d ** (k * r.denominator), "Ceiling comparison failed.")
            ceiling_cases += 1

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    require(output["request"]["payload"] == payload, "Jacobian payload mismatch.")
    require(
        output["result"]["operation_id"] == "integer.compute.divisor_count",
        "Unexpected Jacobian operation.",
    )
    require(
        int(output["result"]["output"]["value"]) == len(divisors(payload["n"])) == 24,
        "Jacobian exact divisor count disagrees.",
    )
    return {
        "classification": "finite_sanity_checks_not_an_asymptotic_proof",
        "shifted_moment_cases": shifted_cases,
        "divisor_product_cases": factor_cases,
        "rational_ceiling_cases": ceiling_cases,
        "jacobian": {
            "operation_id": output["result"]["operation_id"],
            "payload_file": "research/divisor_moment/jacobian_payload.json",
            "typed_output_file": "research/divisor_moment/jacobian_output.json",
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "adapter_status": "success",
            "adapter_error": None,
            "scope": "Only the exact equality tau(360)=24.",
        },
    }


def record_checks():
    checks = []
    for name in ("math_state", "proof_graph_check"):
        command = [
            ARGUS, "-m", f"argus_skill.verticals.math.{name}",
            "check", "--project-root", str(PROJECT),
        ]
        result = subprocess.run(command, cwd=PROJECT, capture_output=True, text=True)
        checks.append({
            "module": name,
            "command": command,
            "exit_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        })
    report = {"project_root": str(PROJECT), "checks": checks}
    (HERE / "campaign_checks.json").write_text(json.dumps(report, indent=2) + "\n")
    require(
        all(check["exit_code"] == 0 for check in checks),
        "Campaign-local structural validation failed: " + json.dumps(report),
    )
    return report


def main():
    certificate_path = HERE / "exact_certificate.json"
    if certificate_path.exists():
        certificate_path.unlink()
    sanity = finite_checks()
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--claim", CLAIM, "--project-root", str(PROJECT),
    ]
    process = subprocess.run(command, cwd=PROJECT, capture_output=True, text=True)
    checks = record_checks()
    if process.returncode:
        sys.stderr.write(process.stdout + process.stderr)
        return process.returncode
    result = json.loads(process.stdout)
    require(result["status"] == "success", "The compiler did not certify success.")
    require(result["exit_code"] == 0, "Nonzero Lean compiler exit status.")
    require(result["audit_exit_code"] == 0, "The proof-hole audit failed.")
    require(result["proof_holes"] == [], "Lean proof holes remain.")
    version = result["tools"]["lean"]["version"]
    require(re.search(r"version 4\.31\.0\b", version), f"Wrong Lean version: {version}")
    recorded = result["kernel"]["recorded"]
    require(recorded is not None, "No mechanical evidence was written to the claim ledger.")
    reports = dict(re.findall(
        r"'([^']+)' depends on axioms: \[([^\]]*)\]", result["stdout"], re.DOTALL
    ))
    axioms = {}
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    for theorem in THEOREMS:
        require(theorem in reports, f"Missing axiom report for {theorem}.")
        used = [name.strip() for name in reports[theorem].split(",") if name.strip()]
        require(set(used) <= allowed, f"Unproved or nonfoundational axiom: {used}")
        axioms[theorem] = used
    certificate = {
        "claim": CLAIM,
        "result_class": "formal_verification",
        "scope": "Full real-exponent, real-endpoint, shift-uniform divisor-moment theorem.",
        "status": "kernel_verified_pending_independent_review",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty": "Not claimed: the natural-exponent theorem already exists upstream.",
        "independent_review": "Required; only the Host Reviewer may accept this handoff.",
        "source": "research/divisor_moment/Main.lean",
        "statement_fidelity": "research/divisor_moment/statement_fidelity.md",
        "lean_version": version,
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "audit_exit_code": result["audit_exit_code"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "axioms": axioms,
        "mechanical_evidence": recorded,
        "finite_checks": sanity,
        "campaign_checks": checks,
    }
    certificate_path.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "claim": CLAIM, "status": certificate["status"], "exit_code": 0,
        "proof_holes": [], "certificate": str(certificate_path),
        "project_root": str(PROJECT),
        "campaign_check_exit_codes": [check["exit_code"] for check in checks["checks"]],
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
