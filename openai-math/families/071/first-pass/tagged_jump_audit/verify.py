#!/usr/bin/env python3
"""Replay the exact scalar certificates, not the analytic proof in proof.md."""

from fractions import Fraction
import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, label):
    require(sp.simplify(expression) == 0, label)


def polynomial(spec):
    variables = sp.symbols(" ".join(spec["variables"]), seq=True)
    result = sp.Integer(0)
    for term in spec["polynomial"]["terms"]:
        coefficient = term["coefficient"]
        value = sp.Rational(coefficient["num"], coefficient["den"])
        require(len(term["exponents"]) == len(variables), "polynomial arity")
        for variable, exponent in zip(variables, term["exponents"]):
            require(exponent >= 0, "polynomial exponent")
            value *= variable**exponent
        result += value
    return sp.expand(result)


def check_jacobian(certificate):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    reply = json.loads((HERE / "jacobian_result.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    operation = certificate["jacobian"]["operation_id"]
    require(contract["result"]["operation"]["operation_id"] == operation,
            "inspected operation differs")
    require(reply["request"]["operation_id"] == operation, "wrong executed operation")
    require(reply["request"]["payload"] == payload, "payload binding")
    require(reply["result"]["operation_id"] == operation, "wrong result operation")
    require(reply["server"]["name"] == "jacobian", "wrong server")
    require(reply["server"]["version"] == certificate["jacobian"]["server_version"],
            "server version")
    require(reply["protocol_version"] == certificate["jacobian"]["protocol_version"],
            "protocol version")
    require(certificate["jacobian"]["adapter_exit_code"] == 0, "adapter failure")
    require(certificate["jacobian"]["error"] is None, "adapter error")
    output = reply["result"]["output"]
    require(output["is_valid"] is True, "SOS identity not verified")
    require(output["method"] == "EXACT_COEFFICIENT_IDENTITY", "inexact method")
    require(output["polynomial"] == payload["polynomial"], "source polynomial binding")
    require(output["summands"] == payload["summands"], "source summand binding")
    p = polynomial(payload["polynomial"])
    squares = sum(polynomial(q) ** 2 for q in payload["summands"])
    zero(p - squares, "independent SOS coefficient replay")
    zero(polynomial(output["computed_sum"]) - p, "returned polynomial replay")
    a, b, c, d = sp.symbols("a b c d")
    zero((a*a+b*b)*(c*c+d*d)-(a*c+b*d)**2-p,
         "Cauchy--Schwarz determinant, not just an arbitrary SOS")


def check_algebra():
    t, eta, eps = sp.symbols("t eta eps", positive=True)
    s = sp.symbols("s", nonnegative=True)
    j = sp.symbols("j", integer=True, positive=True)
    n = sp.symbols("n", integer=True, positive=True)
    kappa = 1 + t
    delta = t / (4 * kappa)
    zero(kappa*(1-2*delta)-1-t/2, "universal scale margin")
    zero(sp.Rational(1, 4)-delta-1/(4*kappa), "delta upper bound")
    zero(sp.summation(eta/2**(j+1), (j, 1, sp.oo))-eta/2,
         "complete infinite fragment-and-join allowance")
    zero(sp.summation(eta/2**(j+1), (j, n+1, sp.oo))-eta/2**(n+1),
         "exact infinite allowance tail")
    zero(sp.summation(delta/2**(j+1), (j, 1, sp.oo))-delta/2,
         "complete infinite jump-loss budget")
    zero(eps-((eps/(2*(s+1)))*s+eps/2)-eps/(2*(s+1)),
         "coefficient-one additive tolerance")
    q = (n/(n+1))**2
    zero(1-q-(2*n+1)/(n+1)**2, "universal sharpness deficit")
    zero(2/(n+1)-(1-q)-1/(n+1)**2, "strict rational sharpness tail")
    left, right = sp.symbols("left right", integer=True, nonnegative=True)
    toll, surplus = sp.symbols("toll surplus", nonnegative=True)
    zero((left*toll+(toll+surplus)+right*toll)
         -(left+right+1)*toll-surplus, "per-time junction budget")


def check_radial_family(certificate):
    r = sp.symbols("r", positive=True)
    x = sp.symbols("x", nonnegative=True)
    require(certificate["sharpness"]["n_min"] == 2, "sharpness parameter range")
    require(certificate["sharpness"]["m"] == 0, "sharpness toll")
    require(certificate["sharpness"]["g_lower_bound"] == "1/n",
            "strictly positive density hypothesis")
    zero(sp.integrate(1/(r*sp.log(2)), (r, 1, 2))-1,
         "radial endpoint length")
    zero(sp.integrate(2*sp.pi/(r*sp.log(2)**2), (r, 1, 2))
         -2*sp.pi/sp.log(2), "exact conformal density energy")
    zero(sp.integrate(8*sp.pi*r/(1+r*r)**2, (r, 1, sp.oo))-2*sp.pi,
         "exact spherical area")
    require(sp.reduce_inequalities([r >= 1, r <= 2, 1/r < sp.Rational(1, 2)], r)
            is sp.false, "pointwise lower bound for log(2)")
    require(sp.reduce_inequalities([r >= 1, r <= sp.Rational(3, 2), 1/r > 1], r)
            is sp.false, "first upper log interval")
    require(sp.reduce_inequalities([r >= sp.Rational(3, 2), r <= 2,
                                   1/r > sp.Rational(2, 3)], r)
            is sp.false, "second upper log interval")
    require(Fraction(1, 2)+Fraction(1, 3) < 1, "strict upper log bound")
    zero(sp.diff(x-sp.log(1+x), x)-x/(1+x), "log(1+x)<=x derivative")
    zero((x-sp.log(1+x)).subs(x, 0), "log inequality base value")


def check_lean(certificate):
    path = HERE / certificate["formal"]["certificate"]
    data = json.loads(path.read_text())
    require(data["subject"]["subject_id"] == "C_TOLL_CORE", "wrong formal claim")
    require(data["tier"] == "mechanical" and data["verdict"] == "supports",
            "no supporting mechanical certificate")
    checked = data["lean_check"]
    require(checked["status"] == "success" and checked["exit_code"] == 0,
            "Lean compilation did not succeed")
    require(checked["audit_exit_code"] == 0, "Lean axiom audit failed")
    require(checked["proof_holes"] == [], "Lean proof holes")
    require(checked["environment_failure"] == "", "unverified Lean environment")
    require("version 4.31.0," in checked["tools"]["lean"]["version"], "Lean version")
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    require(checked["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
            "Lean source changed after compilation")
    require(checked["statement_fidelity_sha256"]
            == hashlib.sha256(fidelity.read_bytes()).hexdigest(),
            "statement fidelity changed after compilation")
    require(data["lean_source"]["text"] == source.read_text(), "archived formal statement")
    require(data["statement_fidelity"]["text"] == fidelity.read_text(),
            "archived fidelity statement")
    state = json.loads((HERE.parent / "MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C_TOLL_CORE"),
                key=lambda c: c["version"])
    require(data["subject"]["content_hash"] == claim["content_hash"],
            "mechanical evidence is about a superseded claim")
    return str(path.relative_to(HERE))


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["independent_review"] == "pending",
            "this Engineer certificate cannot assert Reviewer approval")
    require(certificate["machine_checked_scope"] == "algebra_and_per_visit_core_only",
            "the analytic proof must not be relabelled machine-checked")
    check_algebra()
    check_radial_family(certificate)
    check_jacobian(certificate)
    result = {
        "exact_scalar_checks": "passed",
        "infinite_allowance_formula": "eta/2^(N+1)",
        "sharpness_deficit_bound": "0 < 1-(n/(n+1))^2 < 2/(n+1)",
        "analytic_proof": "proof.md; independent review required",
    }
    result["lean_certificate"] = check_lean(certificate)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
