#!/usr/bin/env python3
"""Replay the exact algebraic evidence; do not substitute it for the prose proof."""

import argparse
from fractions import Fraction
import hashlib
from itertools import product
import json
from math import comb, factorial, isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def trim(poly):
    poly = list(poly)
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly or [0]


def coefficient(poly, degree):
    return poly[degree] if degree < len(poly) else 0


def add(left, right):
    return trim(
        coefficient(left, i) + coefficient(right, i)
        for i in range(max(len(left), len(right)))
    )


def scale(poly, scalar):
    return trim(scalar * value for value in poly)


def multiply(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return trim(result)


def power(poly, exponent):
    result = [1]
    for _ in range(exponent):
        result = multiply(result, poly)
    return result


def monomial(degree, value=1):
    return [0] * degree + [value]


def is_prime(number):
    return number >= 2 and all(number % d for d in range(2, isqrt(number) + 1))


def valuation(number, prime):
    result = 0
    while number % prime == 0:
        number //= prime
        result += 1
    return result


def a_b(degree):
    return [(-1) ** i * comb(degree, i + 1) for i in range(degree)]


def bezout_certificate(poly, prime, h):
    require(is_prime(prime), "The Bezout constructor requires a prime modulus.")
    nonzero = [i for i, a in enumerate(poly) if a % prime]
    require(bool(nonzero), "A modulo p must be a nonzero polynomial.")
    nu = nonzero[0]
    require(h >= nu, "The inverse truncation requires h >= nu.")
    unit = poly[nu:]
    inverse_constant = pow(unit[0], -1, prime)
    inverse = [inverse_constant]
    for n in range(1, h - nu + 1):
        value = sum(
            coefficient(unit, i) * inverse[n - i] for i in range(1, n + 1)
        )
        inverse.append((-inverse_constant * value) % prime)
    residual = add(monomial(nu), scale(multiply(poly, inverse), -1))
    require(
        all(coefficient(residual, i) % prime == 0 for i in range(h + 1)),
        "The constructed inverse does not have the required coefficientwise order.",
    )
    t = trim(coefficient(residual, i) // prime for i in range(h + 1))
    u = trim(residual[h + 1 :])
    right = add(
        add(multiply(poly, inverse), scale(t, prime)),
        multiply(monomial(h + 1), u),
    )
    require(right == monomial(nu), "The integral Bezout identity is false.")
    return {"nu": nu, "D": trim(inverse), "T": t, "U": u}


def determinant_checks():
    chi_a = [1, -1]
    chi_av = [2, -1]
    weight_a = add(scale(chi_av, -1), chi_a)
    weight_v = add(scale(chi_av, -1), chi_av)
    require(weight_a == [-1] and weight_v == [0], "Wrong determinant weights.")
    signed_exp = {}
    for i in range(3):
        for j in range(3 - i):
            value = -Fraction(1, factorial(i) * factorial(j))
            if j == 0:
                value += Fraction(1, factorial(i))
            if i == 0:
                value += Fraction(1, factorial(j))
            if value:
                signed_exp[f"a^{i}v^{j}"] = str(value)
    require(
        signed_exp == {"a^0v^0": "1", "a^1v^1": "-1"},
        "The degree-four Riemann-Roch cancellation is wrong.",
    )
    return {
        "A_scalar_weight_as_polynomial_in_genus": weight_a,
        "V_scalar_weight_as_polynomial_in_genus": weight_v,
        "signed_exponential_through_total_exponent_two": signed_exp,
    }


def exterior_multiply(left, right):
    result = {}
    for a, av in left.items():
        for b, bv in right.items():
            if a & b:
                continue
            swaps = sum(
                (b & ((1 << i) - 1)).bit_count()
                for i in range(a.bit_length())
                if a & (1 << i)
            )
            mask = a | b
            value = av * bv * (-1) ** swaps
            result[mask] = result.get(mask, Fraction(0)) + value
    return {mask: value for mask, value in result.items() if value}


def picard_checks():
    results = []
    for genus in range(1, 5):
        theta = {}
        for i in range(genus):
            theta[(1 << (2 * i)) | (1 << (2 * genus + 2 * i + 1))] = Fraction(1)
            theta[(1 << (2 * i + 1)) | (1 << (2 * genus + 2 * i))] = Fraction(-1)
        exp_theta = {}
        term = {0: Fraction(1)}
        for n in range(2 * genus + 1):
            for mask, value in term.items():
                exp_theta[mask] = exp_theta.get(mask, Fraction(0)) + value / factorial(n)
            term = exterior_multiply(term, theta)
        top = (1 << (4 * genus)) - 1
        integral = exp_theta.get(top, Fraction(0))
        require(integral == (-1) ** genus, "The mixed pairing has the wrong top coefficient.")
        tested = (1 << (2 * genus)) - 1
        for gamma in range(1, tested + 1):
            value = exterior_multiply({gamma: Fraction(1)}, exp_theta).get(top, 0)
            require(value == 0, "A positive B-degree term survived rank extraction.")
        results.append(
            {
                "genus": genus,
                "top_integral": int(integral),
                "positive_B_basis_terms_vanishing": tested,
            }
        )
    return {
        "scope": "Finite exterior-algebra regressions; the arbitrary-genus proof is in report.md.",
        "cases": results,
    }


def arithmetic_checks():
    parameters = [
        (2, 1, 2, 1),
        (2, 1, 2, 3),
        (4, 1, 2, 2),
        (4, 2, 2, 2),
        (6, 2, 2, 2),
        (6, 2, 3, 2),
        (12, 2, 2, 3),
        (12, 2, 3, 2),
        (3, 2, 2, 2),
        (12, 0, 2, 3),
        (5, 1, 5, 1),
        (2, 0, 3, 2),
    ]
    cases = []
    for b, s, p, v in parameters:
        poly = power(a_b(b), s)
        expected_order = s * (p ** valuation(b, p) - 1)
        h = v * expected_order
        witness = bezout_certificate(poly, p, h)
        require(witness["nu"] == expected_order, "The claimed Frobenius order is wrong.")
        cases.append(
            {"b": b, "s": s, "p": p, "v": v, "h": h, "A": poly, **witness}
        )
    finite_cases = []
    for poly, p, v, h in [([2, -1], 2, 2, 2), ([3, -3, 1], 3, 1, 2)]:
        modulus = p**v
        valid = 0
        for q in product(range(modulus), repeat=h + 1):
            aq = multiply(poly, q)
            if all(coefficient(aq, i) % modulus == 0 for i in range(h + 1)):
                require(q[0] == 0, "An admissible truncated counterexample was found.")
                valid += 1
        finite_cases.append(
            {
                "A": poly,
                "p": p,
                "v": v,
                "h": h,
                "vectors_tested": modulus ** (h + 1),
                "annihilators": valid,
                "all_annihilator_constant_coefficients_zero": True,
            }
        )
    return {
        "scope": "Constructive Bezout identities and bounded regressions, not an exhaustive generic-index search.",
        "bezout_identities": cases,
        "finite_annihilator_regressions": finite_cases,
    }


def sharpness_checks():
    cases = []
    for p, v, nu in [(2, 1, 1), (2, 3, 1), (3, 2, 2), (5, 2, 3)]:
        h = nu * v - 1
        a = add([p], monomial(nu))
        q = [0]
        for i in range(v):
            q = add(q, monomial(nu * (v - 1 - i), (-p) ** i))
        aq = multiply(a, q)
        expected = add(monomial(nu * v), [-((-p) ** v)])
        require(aq == expected, "The telescoping sharpness identity is false.")
        require(
            all(coefficient(aq, i) % (p**v) == 0 for i in range(h + 1)),
            "The negative control does not satisfy the weakened congruence.",
        )
        require(q[0] % (p**v) != 0, "The negative control is not a counterexample.")
        cases.append({"p": p, "v": v, "nu": nu, "h": h, "A": a, "Q": q, "AQ": aq})
    return {
        "scope": "Counterexamples only after dropping h>=v*nu; not manuscript counterexamples.",
        "cases": cases,
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian/frobenius-b12-p2.payload.json").read_text())
    response = json.loads((HERE / "jacobian/frobenius-b12-p2.output.json").read_text())
    operation = "modular.polynomial_identity.compute"
    require(response["request"]["operation_id"] == operation, "Wrong saved Jacobian operation.")
    require(response["request"]["payload"] == payload, "Jacobian output belongs to another payload.")
    result = response["result"]
    require(result["operation_id"] == operation and "error" not in result, "Jacobian operation failed.")
    value = result["output"]
    require(value["comparison_scope"] == "FORMAL_COEFFICIENTWISE_IDENTITY", "Wrong identity scope.")
    require(value["identical"] is True and value["residual"] == [], "Jacobian did not certify equality.")
    require(value["normalized_left"] == value["normalized_right"], "Typed normal forms disagree.")
    expected_left = [
        {"coefficient": str(a), "exponents": [i + 1]} for i, a in enumerate(a_b(12))
    ]
    require(payload["left"] == expected_left, "The payload is not 1-(1-u)^12.")
    expected_normal = [
        {"coefficient": a % 2, "exponents": [i + 1]}
        for i, a in enumerate(a_b(12))
        if a % 2
    ]
    require(value["normalized_left"] == expected_normal, "Saved modular coefficients are false.")
    require(payload["modulus"] == 2 and value["modulus"] == 2, "Wrong modulus.")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_status": "success",
        "adapter_exit_code": 0,
        "error": None,
        "timeout": False,
        "exact_payload": "jacobian/frobenius-b12-p2.payload.json",
        "typed_output": "jacobian/frobenius-b12-p2.output.json",
    }


def lean_check():
    source = HERE / "lean/Main.lean"
    fidelity = HERE / "lean/statement_fidelity.md"
    output = json.loads((HERE / "lean/verify.output.json").read_text())
    require(output["status"] == "success" and output["exit_code"] == 0, "Lean has not succeeded.")
    require(output["proof_holes"] == [] and output["audit_exit_code"] == 0, "Lean proof audit failed.")
    require("4.31.0" in output["tools"]["lean"]["version"], "Wrong Lean version.")
    require(
        hashlib.sha256(source.read_bytes()).hexdigest() == output["source_sha256"],
        "The Lean source changed after its compiler run.",
    )
    require(
        hashlib.sha256(fidelity.read_text().encode()).hexdigest()
        == output["statement_fidelity_sha256"],
        "The statement-fidelity document changed after its compiler run.",
    )
    record = output["kernel"]["recorded"]
    require(record is not None and record["verdict"] == "supports", "No mechanical ledger evidence.")
    require(record["subject"]["subject_id"] == "C_DIA_FORMAL_CORE", "Wrong formal claim.")
    archive_path = ROOT / record["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"]["source_sha256"] == output["source_sha256"], "Wrong archived source.")
    require(archive["lean_source"]["text"] == source.read_text(), "The archive carries another theorem.")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    versions = [c for c in state["claims"] if c["claim_id"] == "C_DIA_FORMAL_CORE"]
    require(bool(versions), "The formal claim is missing.")
    claim = max(versions, key=lambda c: c["version"])
    require(claim["formal_statement"] == source.read_text(), "The ledger theorem differs from the source.")
    require(claim["content_hash"] == record["subject"]["content_hash"], "The formal claim was superseded.")
    return {
        "claim": "C_DIA_FORMAL_CORE",
        "declaration": "DivisionIndexAudit.constant_zero_of_truncated_bezout",
        "compiler_version": "4.31.0",
        "exit_code": output["exit_code"],
        "audit_exit_code": output["audit_exit_code"],
        "proof_holes": output["proof_holes"],
        "archived_certificate": record["artifact"],
        "formalizes_the_entire_division_theorem": False,
    }


def build_certificate():
    require((HERE / "report.md").is_file(), "The quantified mathematical proof is missing.")
    return {
        "result_type": "mathematical_verification_proof_with_formal_algebraic_core",
        "main_claim": "C_DIA_DIVISION",
        "main_conclusion": "ind_F(Delta)=deg_F(Delta)=e0*e1 under every stated thm:division hypothesis",
        "main_proof": "report.md, Sections 1-8",
        "generic_fields_and_arbitrary_block_characters_preserved": True,
        "structural_extension": "The same index conclusion for any constant connected etale G-cover of a positive-genus curve and any genuinely G-linearized degree-|G| line.",
        "independent_reviewer_status_at_engineer_handoff": "pending",
        "novelty_status": "not_assessed",
        "significance_status": "not_assessed",
        "campaign_complete": False,
        "manuscript_refutations_established": [],
        "determinant": determinant_checks(),
        "picard_pairing": picard_checks(),
        "arithmetic": arithmetic_checks(),
        "threshold_negative_controls": sharpness_checks(),
        "jacobian": jacobian_check(),
        "lean": lean_check(),
        "not_claimed": [
            "Finite computations prove the generic index.",
            "The Lean compiler checked the geometric inputs or the full division theorem.",
            "An independent Reviewer accepted this proof or its statement fidelity.",
            "EGH or lex-plus-powers has been verified.",
            "Novelty or publishable significance has been established.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    computed = build_certificate()
    destination = HERE / "exact_certificate.json"
    if args.write_certificate:
        destination.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    else:
        saved = json.loads(destination.read_text())
        require(saved == computed, "The saved exact certificate does not match replay.")
    print(
        json.dumps(
            {
                "ok": True,
                "certificate": str(destination.relative_to(ROOT)),
                "formal_claim": "C_DIA_FORMAL_CORE",
                "whole_division_claim": "mathematical proof awaiting independent review",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
