#!/usr/bin/env python3
"""Replay the universal arithmetic certificate, not the geometric proof."""

import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
VARIABLES = ("e", "lam", "C", "D", "B", "b", "h", "R", "V", "q", "m")
ZERO_EXPONENT = (0,) * len(VARIABLES)
OPERATION = "polynomial.box.enclosure.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def constant(value):
    value = Fraction(value)
    return {ZERO_EXPONENT: value} if value else {}


def variable(name):
    exponent = list(ZERO_EXPONENT)
    exponent[VARIABLES.index(name)] = 1
    return {tuple(exponent): Fraction(1)}


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            result[exponent] = result.get(exponent, Fraction(0)) + coefficient
    return {e: c for e, c in result.items() if c}


def multiply(*polynomials):
    result = constant(1)
    for polynomial in polynomials:
        product = {}
        for left, a in result.items():
            for right, b in polynomial.items():
                exponent = tuple(x + y for x, y in zip(left, right))
                product[exponent] = product.get(exponent, Fraction(0)) + a * b
        result = {e: c for e, c in product.items() if c}
    return result


def subtract(left, right):
    return add(left, multiply(constant(-1), right))


def identity(left, right, name):
    residual = subtract(left, right)
    require(not residual, f"Nonzero polynomial residual in {name}: {residual}")
    return {"name": name, "residual_terms": 0}


def rational(value):
    require(set(value) == {"num", "den"}, "Invalid rational object")
    numerator, denominator = int(value["num"]), int(value["den"])
    require(denominator > 0, "Nonpositive rational denominator")
    result = Fraction(numerator, denominator)
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "Noncanonical rational",
    )
    return result


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def check_identities():
    e, lam, C, D, B, b, h, R, V, q, m = map(variable, VARIABLES)
    one, two, four = map(constant, (1, 2, 4))
    k = add(one, multiply(C, e))
    s = add(e, multiply(lam, h))
    margin = subtract(one, multiply(lam, add(D, multiply(C, B))))
    gap = subtract(multiply(s, V), multiply(lam, b, R))
    positive_terms = (
        multiply(R, e, margin),
        multiply(R, lam, C, e, subtract(B, b)),
        multiply(R, lam, add(h, multiply(constant(-1), b), multiply(D, e))),
        multiply(s, subtract(multiply(k, V), R)),
    )
    checks = [
        identity(multiply(k, gap), add(*positive_terms), "exact_penalty_sign_decomposition"),
        identity(
            subtract(multiply(m, add(one, q)), m),
            multiply(m, q),
            "arbitrary_degree_cancellation_loss",
        ),
        identity(
            subtract(add(two, q), two),
            q,
            "smooth_surface_lc_defect",
        ),
        identity(
            subtract(
                multiply(add(q, multiply(two, lam)), add(q, multiply(two, lam))),
                multiply(four, lam, lam, add(one, q)),
            ),
            multiply(q, add(q, multiply(four, lam, subtract(one, lam)))),
            "off_skeleton_surface_volume_excess",
        ),
    ]
    return checks


def check_jacobian():
    payload = read_json(HERE / "jacobian_payload.json")
    response = read_json(HERE / "jacobian_response.json")
    expected = {
        "polynomial": {
            "domain": "QQ",
            "variables": ["t"],
            "polynomial": {
                "terms": [
                    {"coefficient": {"num": "-1", "den": "1"}, "exponents": [1]},
                    {"coefficient": {"num": "1", "den": "1"}, "exponents": [0]},
                ]
            },
        },
        "box": {
            "domain": "QQ",
            "variables": ["t"],
            "intervals": [
                {"lower": {"num": "0", "den": "1"}, "upper": {"num": "1", "den": "2"}}
            ],
        },
    }
    require(payload == expected, "The retained request is not the stated threshold problem")
    require(response["schema_version"] == 1, "Unexpected Jacobian wire schema")
    require(response["request"]["operation_id"] == OPERATION, "Wrong requested operation")
    require(response["request"]["payload"] == payload, "Adapter payload changed")
    require("error" not in response, "Adapter reported an error")
    result = response["result"]
    require("error" not in result, "Jacobian operation reported an error")
    require("status" not in result or result["status"] in {"success", "completed"},
            "Jacobian returned a nonconclusive operation status")
    require(result["operation_id"] == OPERATION, "Wrong executed operation")
    output = result["output"]
    require(output["polynomial"] == payload["polynomial"], "Output polynomial mismatch")
    require(output["box"] == payload["box"], "Output box mismatch")

    interval = payload["box"]["intervals"][0]
    lower, upper = rational(interval["lower"]), rational(interval["upper"])
    require(0 <= lower <= upper, "The replay uses nonnegative input endpoints")
    enclosure_lower = enclosure_upper = Fraction(0)
    for term in payload["polynomial"]["polynomial"]["terms"]:
        coefficient = rational(term["coefficient"])
        exponent = term["exponents"][0]
        require(isinstance(exponent, int) and exponent >= 0, "Invalid exponent")
        a, b = lower**exponent, upper**exponent
        if coefficient < 0:
            a, b = b, a
        enclosure_lower += coefficient * a
        enclosure_upper += coefficient * b
    actual = output["enclosure"]
    require(
        rational(actual["lower"]) == enclosure_lower
        and rational(actual["upper"]) == enclosure_upper,
        "Independent exact interval replay disagrees with Jacobian",
    )
    require(enclosure_lower == Fraction(1, 2) and enclosure_upper == 1,
            "The uniform margin is not bounded below by one half")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_status": "completed_typed_output",
        "structured_error": None,
        "timeout": False,
        "enclosure": [str(enclosure_lower), str(enclosure_upper)],
    }


def check_lean():
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    result = read_json(HERE / "lean_check.json")
    require(result["status"] == "success", "Lean did not succeed")
    require(result["exit_code"] == 0, "Lean returned a nonzero exit status")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(),
            "The Lean source changed after compilation")
    require(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
        "Statement fidelity changed after compilation",
    )
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "The run did not use Lean 4.31.0")
    ledger = read_json(HERE.parent / "MATH_STATE.json")
    claims = [c for c in ledger["claims"] if c["claim_id"] == "C_LC_PENALTY_ALG"]
    require(bool(claims), "The formal claim is missing from the ledger")
    current = max(claims, key=lambda c: c["version"])
    require(current["formal_statement"] == source, "The current claim has another formal source")
    matching = []
    for path in sorted((HERE / "certificates").glob("*.json")):
        archive = read_json(path)
        if (
            archive["subject"]["subject_id"] == "C_LC_PENALTY_ALG"
            and archive["subject"]["content_hash"] == current["content_hash"]
            and archive["verdict"] == "supports"
            and archive["lean_check"] == result
            and archive["lean_source"]["text"] == source
            and archive["statement_fidelity"]["text"] == fidelity
        ):
            artifact = path.relative_to(HERE.parent.parent).as_posix()
            require(
                any(
                    record["subject"] == archive["subject"]
                    and record["tier"] == "mechanical"
                    and record["verdict"] == "supports"
                    and record["artifact"] == artifact
                    for record in ledger["evidence"]
                ),
                "The archive is not current mechanical evidence in the ledger",
            )
            matching.append(path.name)
    require(len(matching) == 1, "No unique current official claim certificate")
    return {
        "version": version,
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "claim": "C_LC_PENALTY_ALG",
        "claim_version": current["version"],
        "official_certificate": f"certificates/{matching[0]}",
        "formal_scope": "universal scalar and abstract-minimizer reduction only",
    }


def certificate():
    return {
        "certificate_version": 1,
        "result_class": "exact_verification_theorem",
        "claim": "C_LC_EXACT_BRIDGE",
        "mathematical_proof": "verification.md",
        "scope": "Universal exact-penalty reduction; geometric proof requires independent review.",
        "variables": list(VARIABLES),
        "polynomial_identities": check_identities(),
        "sign_certificate": {
            "hypotheses": [
                "e>0", "lam>0", "C>=0", "D>=0", "B>=0", "0<b<=B", "R>0",
                "h-b+D*e>=0", "(1+C*e)*V-R>=0", "e+lam*h>0",
                "1-lam*(D+C*B)>0",
            ],
            "denominator": "1+C*e>0",
            "strict_term": "R*e*(1-lam*(D+C*B))>0",
            "other_nonnegative_terms": [
                "R*lam*C*e*(B-b)",
                "R*lam*(h-b+D*e)",
                "(e+lam*h)*((1+C*e)*V-R)",
            ],
            "conclusion": "(e+lam*h)*V>lam*b*R",
        },
        "adversarial_family": {
            "germ": "Spec C[x,y] at (0,0)",
            "lc_boundary": "div(x*y)",
            "valuation": "monomial in x,z=y-x with weights 1,1+q, q>0",
            "function": "(y-x)^m, m a positive integer",
            "discrepancy": "2+q",
            "lc_defect": "q",
            "retraction": "ord_(0,0)",
            "value_excess": "m*q",
            "relative_excess": "q",
            "pair_volume_excess": "q*(q+4*lam*(1-lam))/(1+q)>0 for 0<lam<1",
            "meaning": "Exact infinite-family sharpness check, not a manuscript counterexample.",
        },
        "jacobian": check_jacobian(),
        "lean": check_lean(),
        "independent_review": "required_not_supplied_by_this_verifier",
        "novelty_status": "not_established_by_arithmetic_or_compilation",
        "final_geometric_theorems": "remain_open",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    require(read_json(path) == result, "The retained exact certificate differs from replay")
    print(json.dumps({
        "status": "verified",
        "universal_polynomial_identities": len(result["polynomial_identities"]),
        "jacobian_enclosure": result["jacobian"]["enclosure"],
        "lean_exit_code": result["lean"]["exit_code"],
        "proof_holes": result["lean"]["proof_holes"],
        "scope": result["scope"],
        "independent_review": result["independent_review"],
    }, indent=2))


if __name__ == "__main__":
    main()
