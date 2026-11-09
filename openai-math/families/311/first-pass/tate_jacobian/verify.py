#!/usr/bin/env python3
"""Replay the exact algebraic evidence, not the unformalized geometry."""

import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(path):
    value = json.loads(path.read_text(encoding="utf-8"))
    require(isinstance(value, dict), f"Expected a JSON object: {path}")
    return value


def dual_add(x, y, p):
    return ((x[0] + y[0]) % p, (x[1] + y[1]) % p)


def dual_mul(x, y, p):
    return (x[0] * y[0] % p, (x[0] * y[1] + x[1] * y[0]) % p)


def dual_pow(x, exponent, p):
    result = (1, 0)
    while exponent:
        if exponent % 2:
            result = dual_mul(result, x, p)
        x = dual_mul(x, x, p)
        exponent //= 2
    return result


def check_square_zero_frobenius():
    cases = 0
    for p in (2, 3, 5, 7, 11):
        for a in range(p):
            for b in range(p):
                require(dual_pow((a, b), p, p) == (a, 0),
                        f"Square-zero Frobenius failed at {(p, a, b)}")
                cases += 1
    return cases


def check_linearized_polynomials():
    cases = 0
    for p in (2, 3, 5, 7):
        parameter_points = sorted({(0, 0), (1, p - 1), (p - 1, 1)})
        directions = ((0, 0), (1, 0), (0, 1), (1, 1))
        for h in (1, 2, 3):
            q = p ** h
            terms = ((1, (1, 0), q), (1, (0, 1), 2 * q),
                     (1, (1, 1), p * q), (p - 1, (2, 1), (p + 1) * q))
            for x in parameter_points:
                for v in directions:
                    for t in range(p):
                        for s in range(p):
                            actual = (0, 0)
                            value = derivative = 0
                            for weight, powers, exponent in terms:
                                coefficient = (weight, 0)
                                base_coefficient = weight
                                for j in range(2):
                                    coefficient = dual_mul(
                                        coefficient, dual_pow((x[j], v[j]), powers[j], p), p)
                                    base_coefficient *= pow(x[j], powers[j], p)
                                tangent_coefficient = 0
                                for j in range(2):
                                    if powers[j]:
                                        term = weight * powers[j] * v[j]
                                        for k in range(2):
                                            term *= pow(x[k], powers[k] - (j == k), p)
                                        tangent_coefficient += term
                                actual = dual_add(
                                    actual,
                                    dual_mul(coefficient, dual_pow((t, s), exponent, p), p), p)
                                require(exponent % p == 0, "Invalid inseparable test exponent")
                                value += base_coefficient * pow(t, exponent, p)
                                derivative += tangent_coefficient * pow(t, exponent, p)
                            require(actual == (value % p, derivative % p),
                                    f"First-order chain identity failed at {(p, h, x, v, t, s)}")
                            cases += 1
        require(dual_pow((0, 1), 1, p) != (0, 0),
                "The control with a non-inseparable monomial must retain its tangent")
    return cases


def check_height_parameter_units():
    cases = binomial_coefficients = 0
    for p in (2, 3, 5, 7, 11):
        for i in (1, 2, 3):
            degree = p ** i
            for k in range(1, degree):
                require(math.comb(degree, k) % p == 0,
                        f"The integral binomial form fails at {(p, i, k)}")
                binomial_coefficients += 1
            coefficient = 0
            for k in range(1, p):
                numerator = (k + 1) ** degree - k ** degree - 1
                require(numerator % p == 0, "Binomial form is not integral")
                coefficient += numerator // p
            require(coefficient == p ** (degree - 1) - 1,
                    f"p-fold-sum telescoping failed at {(p, i)}")
            require(coefficient % p == p - 1,
                    f"Height parameter coefficient is not a unit at {(p, i)}")
            cases += 1
    return {"p_fold_sums": cases, "binomial_coefficients": binomial_coefficients}


def check_quotient_descent():
    positive = negative_controls = 0
    for p in (2, 3, 5):
        for level in (1, 2, 3):
            d, source_order = p ** level, p ** (level + 1)
            for a in sorted({0, 1, p - 1}):
                def W(k):
                    return (k % d, a * k % p)

                def section(k):
                    return W(k % d)

                require(W(source_order) == (0, 0), "W is not defined on the source quotient")
                for x in range(d):
                    require(section(x)[0] == x, "Descent did not give a section")
                    for k in range(p):
                        require(W(x + k * d) == section(x), "W is not constant on a fiber")
                    for y in range(d):
                        sx, sy = section(x), section(y)
                        require(section(x + y) == ((sx[0] + sy[0]) % d,
                                                  (sx[1] + sy[1]) % p),
                                "The descended section is not additive")
                positive += 1
            require(d % source_order != 0,
                    "Negative control must not annihilate the kernel")
            negative_controls += 1
    return {"quotient_examples": positive, "nonannihilating_controls": negative_controls}


def check_block_rank():
    candidates = invertible = 0
    for p in (2, 3, 5, 7):
        for a in range(p):
            for b in range(p):
                for d in range(p):
                    candidates += 1
                    determinant = (a * d - 0 * b) % p
                    if determinant:
                        require(d != 0, "An invertible full comparison had singular etale block")
                        invertible += 1
    return {"matrices": candidates, "invertible_full_matrices": invertible}


def check_jacobian_adapter(certificate):
    payload = read_json(HERE / "jacobian/payload.json")
    result = read_json(HERE / "jacobian/result.json")
    capability = read_json(HERE / "jacobian/capability.json")
    require(result["protocol_version"] == "2025-11-25", "Unexpected adapter protocol")
    require(result["server"]["version"] == "0.14.0", "Unexpected recorded adapter version")
    operation = certificate["jacobian"]["operation_id"]
    require(result["request"] == {"operation_id": operation, "payload": payload},
            "Adapter request is not the preserved exact payload")
    require(result["result"]["operation_id"] == operation, "Adapter operation mismatch")
    require(result["result"]["output"] == {"prime": 2, "rank": 1, "source": payload},
            "Unexpected typed finite rank result")
    require(capability["adapter_exit_code"] == 0 and
            capability["adapter_error"] is None and not capability["adapter_timeout"],
            "An adapter error or timeout is not mathematical evidence")
    require(payload == {"matrix": {"prime": 2, "entries": [[1, 0], [0, 0]], "columns": 2}},
            "This check is only the stated square-zero Frobenius projection")


def latest_claim(state, claim_id):
    claims = [c for c in state["claims"] if c["claim_id"] == claim_id]
    require(bool(claims), f"Claim missing from the shared ledger: {claim_id}")
    return max(claims, key=lambda c: c["version"])


def check_sources(certificate, state):
    expected = {(a["claim_id"], a["assumption_id"]) for a in certificate["external_assumptions"]}
    actual = set()
    for claim_id in sorted({a["claim_id"] for a in certificate["external_assumptions"]}):
        for assumption in latest_claim(state, claim_id)["external_assumptions"]:
            actual.add((claim_id, assumption["assumption_id"]))
    require(actual == expected, "The certificate omits or invents an active external assumption")
    for source in certificate["external_assumptions"]:
        claim = latest_claim(state, source["claim_id"])
        assumption = next(a for a in claim["external_assumptions"]
                          if a["assumption_id"] == source["assumption_id"])
        require(assumption["source_id"] == source["source_id"] and
                assumption["locator"] == source["locator"],
                f"Source citation changed for {source['assumption_id']}")
        require((HERE / source["excerpt_file"]).is_file(), "A source passage is missing")


def check_lean(certificate, state):
    formal = certificate["formal_core"]
    source = HERE / formal["source"]
    fidelity = HERE / formal["statement_fidelity"]
    result = read_json(HERE / formal["compiler_result"])
    require(result["status"] == "success" and result["exit_code"] == 0,
            "No successful real Lean compile is recorded")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof-hole or axiom audit is not clean")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "This certificate requires Lean 4.31.0")
    require(Path(result["source"]).resolve() == source, "The compiler checked another source")
    require(Path(result["statement_fidelity"]).resolve() == fidelity,
            "The compiler checked another fidelity document")
    # These only recheck the freshness bindings required by the official verifier.
    require(hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.read_text(encoding="utf-8").encode()).hexdigest() ==
            result["statement_fidelity_sha256"], "Statement fidelity changed after compilation")
    require("sorryAx" not in result["stdout"], "The printed declarations depend on a proof hole")
    for declaration in formal["declarations"]:
        require(f"'{declaration}' depends on axioms:" in result["stdout"],
                f"Missing compiler axiom output for {declaration}")
    claim = latest_claim(state, formal["claim_id"])
    require(claim["formal_statement"].strip() == source.read_text(encoding="utf-8").strip(),
            "The ledger carries a different formal statement")
    evidence = [e for e in state["evidence"]
                if e["tier"] == "mechanical" and e["verdict"] == "supports"
                and e["subject"]["subject_id"] == formal["claim_id"]
                and e["subject"]["content_hash"] == claim["content_hash"]]
    require(bool(evidence), "The current claim has no supporting mechanical evidence")
    require(any(e["artifact"] == formal["archived_certificate"] for e in evidence),
            "The exact archived compiler certificate is not cited by the current claim")
    archive = read_json(PROJECT / formal["archived_certificate"])
    require(archive["lean_check"] == result and archive["verdict"] == "supports",
            "Archived compiler evidence does not match the successful run")
    return {"version": "4.31.0", "exit_code": 0, "proof_holes": [],
            "declarations": len(formal["declarations"])}


def main():
    certificate = read_json(HERE / "exact_certificate.json")
    require(certificate["claim_id"] == "C_TATE9000311", "Unexpected target claim")
    require(certificate["full_theorem_mechanically_verified"] is False,
            "Do not substitute algebraic checks for the geometric proof")
    state = read_json(PROJECT / "research/MATH_STATE.json")
    latest_claim(state, certificate["claim_id"])
    check_sources(certificate, state)
    check_jacobian_adapter(certificate)
    bounded = {
        "square_zero_frobenius": check_square_zero_frobenius(),
        "linearized_polynomials": check_linearized_polynomials(),
        "height_parameter_units": check_height_parameter_units(),
        "quotient_descent": check_quotient_descent(),
        "block_rank": check_block_rank(),
    }
    require(bounded == certificate["bounded_replay_expected"], "Finite replay counts changed")
    lean = check_lean(certificate, state)
    print(json.dumps({
        "claim_id": certificate["claim_id"],
        "algebraic_replay": "pass",
        "lean": lean,
        "bounded_replay": bounded,
        "full_theorem_mechanically_verified": False,
        "full_theorem_evidence": "ordinary proof in report.md",
        "independent_review_status": certificate["independent_review_status"],
        "official_citation_attribution": certificate["official_citation_attribution"],
    }, indent=2))


if __name__ == "__main__":
    main()
