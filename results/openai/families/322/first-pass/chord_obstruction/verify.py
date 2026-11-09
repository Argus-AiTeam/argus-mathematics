#!/usr/bin/env python3
"""Replay the exact algebra and the universal Lean chord obstruction."""

import argparse
import hashlib
import json
import re
import subprocess
from fractions import Fraction
from itertools import product
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def symbolic_checks(certificate):
    p, u, M, t, h, X, Z, W, lv, ly, D, delta, eta = sp.symbols(
        "p u M t h X Z W lv ly D delta eta"
    )
    s, r, d, e = p + M, u + M, p + u + M, 1 - t
    a, c, B = p / s, r / u, u / d
    identities = {
        "cross_product": s * r - p * u - M * d,
        "secant_denominator": c - a - M * d / (s * u),
        "one_minus_B": 1 - B - s / d,
        "small_secant_multiplier": (1 - B) * (c - a) - M / u,
        "large_secant_multiplier": B * (c - a) - M / s,
        "phase_boundary": (e * s - t * u) - (e * d - u),
        "weighted_cancellation": u * s * (W - X) + s * u * (Z - W)
        - s * u * (Z - X),
        "support_endpoint": s * (a * lv + h * ly) + t - s * h
        - (p * lv + t + s * h * (ly - 1)),
        "inverse_diameter": u + s - d,
        "small_source_rearrangement": r - (p * D + r * t - p * e)
        - (e * d - p * D),
        "small_target_rearrangement": s * D - (u + s * e - u * t)
        - (s * D - e * d),
        "inward_normalization": c * (h / c) - h,
        "outward_cancellation": delta * eta + eta * (-delta),
    }
    require(list(identities) == certificate["symbolic_identities"], "Identity list changed")
    for label, expression in identities.items():
        require(sp.cancel(expression) == 0, f"False symbolic identity: {label}")
    return len(identities)


def rational_function(value):
    variables = [sp.Symbol(name) for name in value["variables"]]

    def polynomial(data):
        answer = sp.Integer(0)
        for term in data["terms"]:
            q = term["coefficient"]
            coefficient = sp.Rational(int(q["num"]), int(q["den"]))
            require(len(term["exponents"]) == len(variables), "Bad exponent arity")
            answer += coefficient * sp.prod(
                variable**exponent
                for variable, exponent in zip(variables, term["exponents"])
            )
        return answer

    numerator = polynomial(value["numerator"])
    denominator = polynomial(value["denominator"])
    require(denominator != 0, "Zero rational-function denominator")
    return sp.cancel(numerator / denominator)


def jacobian_checks(certificate):
    metadata = certificate["jacobian"]
    payload = json.loads((HERE / metadata["payload"]).read_text())
    response = json.loads((HERE / metadata["typed_output"]).read_text())
    adapter = json.loads((HERE / metadata["adapter_status"]).read_text())
    require(adapter["exit_code"] == 0 and adapter["timeout"] is False, "Adapter failed")
    require(adapter["stderr"] == "", "Adapter reported an error")
    require(response["server"]["version"] == metadata["server_version"], "Server changed")
    require(response["protocol_version"] == metadata["protocol_version"], "Protocol changed")
    require(response["request"]["operation_id"] == metadata["operation_id"], "Wrong operation")
    require(response["request"]["payload"] == payload, "Payload not retained exactly")
    require(response["result"]["operation_id"] == metadata["operation_id"], "Wrong result")
    output = response["result"]["output"]
    require(output["variables"] == ["p", "u", "M"], "Wrong symbolic field")
    left = sp.Matrix([[rational_function(v) for v in row] for row in payload["left"]["entries"]])
    right = sp.Matrix([[rational_function(v) for v in row] for row in payload["right"]["entries"]])
    actual = sp.Matrix([[rational_function(v) for v in row] for row in output["entries"]])
    p, u, M = sp.symbols("p u M")
    require(left == sp.Matrix([[p + M, p, -M]]), "Wrong identity row")
    require(right == sp.Matrix([[u + M], [-u], [p + u + M]]), "Wrong identity column")
    require(actual == sp.zeros(1, 1), "Jacobian did not return zero")
    require((left * right).applyfunc(sp.expand) == actual, "Independent identity replay failed")


def boundary_checks():
    count = 0
    small_survivors = 0
    values = [Fraction(i, 8) for i in range(1, 8)]
    for p, u, M, t in product(values, repeat=4):
        s, r, e = p + M, u + M, 1 - t
        d = p + r
        if d > 2:
            continue
        count += 1
        A, B = p / d, u / d
        h = min(t / s, e / u)
        a, c = p / s, r / u
        require((t / s <= e / u) == (B <= e), "Phase orientation failed")
        require(0 < a < c and h > 0, "Degenerate secant denominator")
        if B == e:
            require(h == 1 / d, "Equality boundary misoriented")
        if A <= e and B <= e and e <= p * (1 - B) and e <= u * (1 - A):
            small_survivors += 1
            require(e < Fraction(1, 2), "Small-regime half bound failed")
            require(r * t - p * e > 0 and s * e - u * t >= 0, "Negative coefficient")
            require(e * d / p > e * d / s, "Terminal distance interval not empty")
    return {"rational_parameter_cases": count, "small_regime_scalar_survivors": small_survivors}


def compiler_replay(certificate):
    source = HERE / certificate["formal_source"]
    fidelity = HERE / certificate["statement_fidelity"]
    source_bytes, fidelity_bytes = source.read_bytes(), fidelity.read_bytes()
    text = source_bytes.decode()
    require(not re.search(r"\b(sorry|admit)\b|^\s*axiom\b", text, re.MULTILINE), "Proof hole")
    record = json.loads((HERE / certificate["compiler_result"]).read_text())
    require(record["exit_code"] == 0 and record["proof_holes"] == [], "Unverified compiler record")
    require(record["source_sha256"] == hashlib.sha256(source_bytes).hexdigest(), "Stale source")
    require(
        record["statement_fidelity_sha256"] == hashlib.sha256(fidelity_bytes).hexdigest(),
        "Stale statement fidelity",
    )
    version = subprocess.run(
        ["lake", "env", "lean", "--version"], cwd=WORKSPACE,
        capture_output=True, text=True, timeout=15, check=True,
    )
    require(
        version.stdout.startswith(f"Lean (version {certificate['required_lean_version']},"),
        "Wrong Lean version",
    )
    compiled = subprocess.run(
        ["lake", "env", "lean", str(source)], cwd=WORKSPACE,
        capture_output=True, text=True, timeout=100, check=False,
    )
    require(source.read_bytes() == source_bytes, "Source changed during replay")
    require(fidelity.read_bytes() == fidelity_bytes, "Fidelity changed during replay")
    require(compiled.returncode == 0, compiled.stdout + compiled.stderr)
    require("sorryAx" not in compiled.stdout and "uses 'sorry'" not in compiled.stdout, "Axiom hole")
    for declaration in certificate["principal_declarations"]:
        require(f"'{declaration}' depends on axioms:" in compiled.stdout, f"Missing {declaration}")
    return {"exit_code": compiled.returncode, "proof_holes": [], "version": version.stdout.strip()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--arithmetic-only", action="store_true")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "C_CHORD_OBSTRUCTION", "Wrong claim")
    identities = symbolic_checks(certificate)
    jacobian_checks(certificate)
    result = {
        "claim_id": certificate["claim_id"],
        "symbolic_identities_verified": identities,
        "jacobian_identity_replayed": True,
        "finite_sanity_checks": boundary_checks(),
        "scope": certificate["scope"],
        "independent_review": certificate["independent_review"],
    }
    if args.arithmetic_only:
        result["universal_proof_replayed"] = False
        result["status"] = "exact_arithmetic_only"
    else:
        result["lean"] = compiler_replay(certificate)
        result["universal_proof_replayed"] = True
        result["status"] = "universal_theorem_replayed"
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
