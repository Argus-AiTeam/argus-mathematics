#!/usr/bin/env python3
"""Replay the exact algebra and the uniform Lean cores, not the prose theorem."""

import json
import subprocess
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
LEAN = "$WORKSPACE/.elan/bin/lean"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational_polynomial(value, variables):
    require(value["domain"] == "QQ", "Jacobian coefficient domain is not QQ")
    require(value["variables"] == [str(v) for v in variables], "Variable axes differ")
    terms = value["polynomial"]["terms"]
    exponents = [tuple(term["exponents"]) for term in terms]
    require(exponents == sorted(set(exponents), reverse=True), "Noncanonical terms")
    expression = sp.S.Zero
    for term in terms:
        powers = term["exponents"]
        require(len(powers) == len(variables), "Wrong monomial dimension")
        require(all(isinstance(e, int) and e >= 0 for e in powers), "Negative exponent")
        raw = term["coefficient"]
        numerator, denominator = int(raw["num"]), int(raw["den"])
        coefficient = sp.Rational(numerator, denominator)
        require(denominator > 0 and coefficient != 0, "Invalid coefficient")
        require(
            str(coefficient.p) == raw["num"] and str(coefficient.q) == raw["den"],
            "Noncanonical rational",
        )
        expression += coefficient * sp.prod(v**e for v, e in zip(variables, powers))
    return sp.Poly(expression, *variables, domain=sp.QQ)


def exact_algebra():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim"] == "C_SHARED_GENERAL", "Wrong theorem claim")
    require(certificate["formal_core_claim"] == "C_SHARED_FORMAL_CORE", "Wrong core")
    require(certificate["campaign_completion"] is False, "Unreviewed campaign closure")
    require(certificate["refuted_manuscript_assertions"] == [], "Unproved refutation")
    require(certificate["novelty_status"] == "not_established", "Unproved originality")

    a, u, q = sp.symbols("a u q")
    variables = (a, u, q)
    t, f = u - a * q, q + a * u
    generators = [t**2, a**3, f]
    identity = (1 - 2 * a**2) * (f**2 - 2 * a * f * t + a**2 * t**2)
    identity += a**3 * a * (3 + 2 * a**2) * q**2
    require(sp.Poly(identity - q**2, *variables).is_zero, "Membership identity fails")
    require(not sp.Poly(u, a, u).eval(a, 0).is_zero, "Base pole hypothesis fails")
    require(sp.expand(t.subs(u, a * q)) == 0, "Graph parametrization fails")
    require(sp.expand(t.subs({a: 0, q: 0})) == u, "Boundary constraint is wrong")

    epsilon, eta = sp.symbols("epsilon eta")
    substitution = {a: epsilon, u: eta, q: -epsilon * eta}

    def square_zero_image(expression):
        polynomial = sp.Poly(
            expression.subs(substitution, simultaneous=True), epsilon, eta, domain=sp.QQ
        )
        return {
            powers: coefficient
            for powers, coefficient in polynomial.terms()
            if powers[0] < 2 and powers[1] < 2 and coefficient != 0
        }

    require(all(square_zero_image(g) == {} for g in generators), "Witness hypotheses fail")
    require(square_zero_image(q) == {(1, 1): -1}, "Witness conclusion fails")

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = certificate["nonradical_stress_test"]["jacobian_operation"]
    require(status["adapter_exit_code"] == 0, "Adapter failed; not mathematical evidence")
    require(status["operation_id"] == operation, "Wrong recorded operation")
    require(output["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(output["server"]["version"] == "0.14.0", "Unexpected server version")
    require(output["result"]["operation_id"] == operation, "Output operation differs")
    require(output["request"]["payload"] == payload, "Output is not source-bound")
    typed = output["result"]["output"]
    require(typed["request"] == payload, "Typed request differs")
    require(typed["outcome"] == "COMPUTED", "Incomplete Jacobian outcome")
    require(typed["in_ideal"] is False, "Wrong ideal-membership conclusion")
    require(typed["monomial_order"] == payload["monomial_order"], "Order differs")
    actual_generators = [
        rational_polynomial(g, variables).as_expr()
        for g in payload["ideal"]["generators"]
    ]
    require(
        all(sp.expand(g - h) == 0 for g, h in zip(actual_generators, generators))
        and len(actual_generators) == len(generators),
        "Typed ideal differs from the witness",
    )
    polynomial = rational_polynomial(payload["polynomial"], variables).as_expr()
    require(polynomial == q, "Wrong tested polynomial")
    remainder = rational_polynomial(typed["remainder"], variables).as_expr()
    basis = sp.groebner(actual_generators, *variables, order="grevlex", domain=sp.QQ)
    require(sp.expand(basis.reduce(polynomial)[1] - remainder) == 0, "Replay disagrees")
    require(remainder != 0, "Zero remainder cannot certify nonmembership")
    require(basis.reduce(q**2)[1] == 0, "Actual-ideal member does not reduce to zero")

    B, r, L, A, H = sp.symbols("B r L A H")
    base_gap = (2 + B * r + B) * L - (1 + L + B * (r * L) + B)
    require(sp.expand(base_gap - (B + 1) * (L - 1)) == 0, "Uniform base gap fails")
    ratio = 2 * A * (H + 1) + 2
    coefficient = -ratio * L + A * L * H + A * L
    require(
        sp.expand(coefficient + L * (A * (H + 1) + 2)) == 0,
        "Product-formula coefficient identity fails",
    )
    return {
        "actual_ideal_identity": True,
        "nonmembership_witness": "QQ[epsilon,eta]/(epsilon^2,eta^2)",
        "witness_hypotheses_verified": True,
        "failed_membership_verified": True,
        "jacobian_typed_replay": True,
        "uniform_polynomial_identities": True,
    }


def official_checks():
    statuses = {}
    for name in ("math_state", "proof_graph_check"):
        command = [
            ARGUS_PYTHON,
            "-m",
            "argus_skill.verticals.math." + name,
            "check",
            "--project-root",
            str(ROOT),
        ]
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        statuses[name] = result.returncode
        if result.returncode != 0:
            print(result.stdout, end="")
            print(result.stderr, end="")
    return statuses


def formal_evidence(compiled):
    require(compiled["status"] == "success", "Compiler did not succeed")
    require(compiled["exit_code"] == 0, "Nonzero compiler exit")
    require(compiled["proof_holes"] == [], "Formal source contains proof holes")
    recorded = compiled["kernel"]["recorded"]
    require(recorded is not None, "Mechanical evidence not recorded")
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    expected = (HERE / certificate["formal_core_certificate"]).relative_to(ROOT)
    require(recorded["artifact"] == str(expected), "Wrong formal certificate")
    archived = json.loads((ROOT / expected).read_text())
    require(archived["subject"] == recorded["subject"], "Formal subject differs")
    require(archived["lean_check"]["exit_code"] == 0, "Archived compiler failed")
    require(archived["lean_check"]["proof_holes"] == [], "Archived proof has holes")
    require(
        archived["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
        "Formal source changed since compilation",
    )
    require(
        archived["statement_fidelity"]["text"]
        == (HERE / "statement_fidelity.md").read_text(),
        "Statement fidelity changed since compilation",
    )
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_SHARED_FORMAL_CORE"),
        key=lambda c: c["version"],
    )
    require(
        claim["content_hash"] == recorded["subject"]["content_hash"],
        "Formal claim changed since compilation",
    )


def main():
    algebra = exact_algebra()
    version = subprocess.run([LEAN, "--version"], check=True, capture_output=True, text=True)
    require("Lean (version 4.31.0," in version.stdout, "Lean is not version 4.31.0")
    command = [
        ARGUS_PYTHON,
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity",
        str(HERE / "statement_fidelity.md"),
        "--claim",
        "C_SHARED_FORMAL_CORE",
        "--project-root",
        str(ROOT),
        "--timeout",
        "600",
    ]
    compile_result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    (HERE / "lean_verify_output.json").write_text(compile_result.stdout)
    checks = official_checks()
    if compile_result.returncode != 0:
        print(compile_result.stdout, end="")
        print(compile_result.stderr, end="")
        raise SystemExit(compile_result.returncode)
    compiled = json.loads(compile_result.stdout)
    formal_evidence(compiled)
    require(all(code == 0 for code in checks.values()), "Campaign-local gate failed")
    result = {
        "project_root": str(ROOT),
        "exact_algebra": algebra,
        "lean_version": version.stdout.strip(),
        "lean_exit_code": compiled["exit_code"],
        "proof_holes": compiled["proof_holes"],
        "formal_core_claim": "C_SHARED_FORMAL_CORE",
        "official_check_exit_codes": checks,
        "whole_prose_theorem_machine_checked": False,
        "independent_review": "pending",
        "campaign_completion": False,
    }
    (HERE / "verification_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
