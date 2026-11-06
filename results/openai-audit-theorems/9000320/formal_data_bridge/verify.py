#!/usr/bin/env python3
"""Replay exact identities; do not infer an unconditional bridge theorem."""

import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MANUSCRIPT = (
    ROOT
    / "research/openai_manuscript"
    / "Nonhomeomorphic-closed-aspherical-four-manifolds-with-the-same-homotopy-type-October-4-2026"
    / "build/sections/formal.tex"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def add_words(*parts):
    answer = {}
    for scale, terms in parts:
        for word, coefficient in terms.items():
            answer[word] = answer.get(word, Fraction(0)) + scale * coefficient
    return {word: coefficient for word, coefficient in answer.items() if coefficient}


def multiply_words(left, right):
    answer = {}
    for first, a in left.items():
        for second, b in right.items():
            word = first + second
            answer[word] = answer.get(word, Fraction(0)) + a * b
    return answer


DEGREE = {"A": 1, "D": 2, "B": 1, "E": 2}


def derive_words(terms, variation=False):
    substitutions = {"A": "B", "D": "E"} if variation else {"A": "D", "B": "E"}
    answer = {}
    for word, coefficient in terms.items():
        prefix_degree = 0
        for index, letter in enumerate(word):
            if letter in substitutions:
                sign = 1 if variation or prefix_degree % 2 == 0 else -1
                changed = word[:index] + (substitutions[letter],) + word[index + 1 :]
                answer[changed] = answer.get(changed, Fraction(0)) + sign * coefficient
            prefix_degree += DEGREE[letter]
    return answer


def graded_trace(terms):
    answer = {}
    for word, coefficient in terms.items():
        if not word:
            answer[word] = answer.get(word, Fraction(0)) + coefficient
            continue
        total_degree = sum(DEGREE[letter] for letter in word)
        prefix_degree = 0
        rotations = []
        for index, letter in enumerate(word):
            sign = (-1) ** (prefix_degree * (total_degree - prefix_degree))
            rotations.append((word[index:] + word[:index], sign))
            prefix_degree += DEGREE[letter]
        canonical = min(rotation for rotation, _ in rotations)
        signs = {sign for rotation, sign in rotations if rotation == canonical}
        if len(signs) == 1:
            answer[canonical] = answer.get(canonical, Fraction(0)) + coefficient * signs.pop()
    return {word: coefficient for word, coefficient in answer.items() if coefficient}


def check_action_identities():
    cs = {("A", "D"): Fraction(1, 2), ("A", "A", "A"): Fraction(1, 3)}
    curvature = {("D",): Fraction(1), ("A", "A"): Fraction(1)}
    transgression = graded_trace(
        add_words(
            (1, derive_words(cs)),
            (Fraction(-1, 2), multiply_words(curvature, curvature)),
        )
    )
    variation = graded_trace(
        add_words(
            (1, derive_words(cs, variation=True)),
            (-1, multiply_words({("B",): Fraction(1)}, curvature)),
            (Fraction(1, 2), derive_words({("A", "B"): Fraction(1)})),
        )
    )
    require(not transgression, f"Chern--Simons transgression failed: {transgression}")
    require(not variation, f"Chern--Simons variation sign failed: {variation}")
    require(Fraction(-1, 2) + Fraction(1, 2) == 0, "Polarization adjustment failed")
    return {
        "method": "exact rational noncommutative words modulo graded cyclic trace",
        "generator_degrees": DEGREE,
        "dA": "D",
        "dB": "E",
        "dD": "0",
        "dE": "0",
        "transgression": "d CS(A) = tr((D+A*A)^2)/2",
        "variation": "delta CS(A) = tr(B*(D+A*A)) - d tr(A*B)/2",
        "transgression_remainder": {},
        "variation_remainder": {},
        "plus_boundary_coefficient": "-1/2",
        "plus_potential_adjustment": "1/2",
        "scope": "universal trace identities, not a proof of Stokes on a vertex",
    }


def check_adjoint_and_four_slot_identities():
    sigma = sp.Symbol("sigma")
    e = sp.Matrix([[0, 1], [0, 0]])
    h = sp.diag(1, -1)
    f = sp.Matrix([[0, 0], [1, 0]])
    e_ad = sp.Matrix([[0, -2, 0], [0, 0, 1], [0, 0, 0]])
    f_ad = sp.Matrix([[0, 0, 0], [-1, 0, 0], [0, 2, 0]])
    require(e_ad**3 == sp.zeros(3) and f_ad**3 == sp.zeros(3), "Adjoint cubes")
    columns = []
    for a in range(3):
        for b in range(3):
            left = sp.eye(3) + a * sigma * e_ad + (a * sigma) ** 2 * e_ad**2 / 2
            right = sp.eye(3) + b * sigma * f_ad + (b * sigma) ** 2 * f_ad**2 / 2
            adjoint = left * right
            g = (sp.eye(2) + a * sigma * e) * (sp.eye(2) + b * sigma * f)
            g_inverse = (sp.eye(2) - b * sigma * f) * (sp.eye(2) - a * sigma * e)
            direct_columns = []
            for vector in (e, h, f):
                image = g * vector * g_inverse
                direct_columns.append(sp.Matrix([image[0, 1], image[0, 0], image[1, 0]]))
            difference = adjoint - sp.Matrix.hstack(*direct_columns)
            require(difference.applyfunc(sp.expand) == sp.zeros(3), "Adjoint representation")
            columns.append(sp.Matrix(list(adjoint)))
    determinant = sp.factor(sp.Matrix.hstack(*columns).det(method="domain-ge"))
    require(determinant == 512 * sigma**18, f"Adjoint determinant: {determinant}")
    basis = [
        sp.Matrix(list(e_ad**p * f_ad**q / (sp.factorial(p) * sp.factorial(q))))
        for p in range(3)
        for q in range(3)
    ]
    basis_determinant = sp.Matrix.hstack(*basis).det()
    require(basis_determinant == 8, f"Adjoint monomial basis: {basis_determinant}")

    x1, x2, x3, x4 = sp.symbols("x1 x2 x3 x4")

    def bracket(first, second):
        return first * second - second * first

    value = bracket(bracket(x1 * h, x2 * e), bracket(x3 * h, x4 * f))
    require(value == -4 * x1 * x2 * x3 * x4 * h, "Four-slot rank-one test")
    require(sp.expand(-value[0, 0] / 4) == x1 * x2 * x3 * x4, "Output functional")
    return {
        "adjoint_basis": ["e", "h", "f"],
        "adjoints_replayed_as": "conjugation by (1+a*sigma*e)(1+b*sigma*f) on all three basis matrices",
        "ordering": "lexicographic (a,b), row-major matrix vectorization",
        "adjoint_monomial_basis_determinant": "8",
        "nine_adjoint_determinant": "512*sigma**18",
        "four_slot_polynomial_identity": "[[x1*h,x2*e],[x3*h,x4*f]] = -4*x1*x2*x3*x4*h",
        "coordinate_product_functional": "-output_h_coordinate/4",
        "scope": "exact polynomial identities and rank-one spanning argument, not sampled sigma values",
    }


def check_parameter_adapter():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "polynomial.ideal.normal_form.compute"
    require(response["request"]["operation_id"] == operation, "Wrong adapter operation")
    require(response["request"]["payload"] == payload, "Adapter payload changed")
    require(response["result"]["operation_id"] == operation, "Wrong typed-result operation")
    output = response["result"]["output"]
    require(output["outcome"] == "COMPUTED", f"Non-conclusion from adapter: {output}")
    require(output["in_ideal"] is False, "Adapter did not certify nonmembership")
    require(output["remainder"] == payload["polynomial"], "Wrong mixed-monomial remainder")
    require(output["request"] == payload, "Typed output is not bound to this request")
    t1, t2 = sp.symbols("t1 t2")
    remainder = sp.groebner([t1**2, t2**2], t1, t2, order="lex").reduce(t1 * t2)[1]
    require(remainder == t1 * t2, "Independent exact ideal replay failed")
    return {
        "operation_id": operation,
        "server": response["server"]["name"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_outcome": output["outcome"],
        "adapter_error": output["detail"],
        "in_ideal": False,
        "exact_remainder": "t1*t2",
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "independent_replay": "SymPy exact QQ Groebner remainder",
        "scope": "this exact quotient-ring fact only",
    }


def check_literal_locator():
    target = MANUSCRIPT.read_text()
    offending = [
        (number, line.strip())
        for number, line in enumerate(target.splitlines(), start=1)
        if r"\cite[Lemma~3.9]{MT}" in line
    ]
    require(len(offending) == 1, "The challenged literal manuscript assertion changed")
    primary = (HERE / "literature/mt_paper.txt").read_text()
    require(
        re.search(r"Lemma\s+6\.7\s*\(Correction over the full parameter algebra\)", primary),
        "The archived printed MT correction locator changed",
    )
    require(not re.search(r"\bLemma\s+3\.9\b", primary), "MT now contains a Lemma 3.9")
    source = (HERE / "literature/mt_vertices.tex").read_text()
    require(r"\label{lem:tensor-nilpotent-correction}" in source, "Missing source label")
    require(r"J^{m+1}=0" in source, "Missing full-parameter nilpotency argument")
    return {
        "claim_id": "F_MT_NILPOTENT_LOCATOR",
        "manuscript": str(MANUSCRIPT.relative_to(ROOT)),
        "line": offending[0][0],
        "literal_latex": offending[0][1],
        "cited_locator": "MT Lemma 3.9",
        "actual_locator": "MT Lemma 6.7",
        "actual_title": "Correction over the full parameter algebra",
        "source_commit": "4eaee87548250b2682affda7d05d947c05554bae",
        "scope": "repairable citation-only error, not a mathematical counterexample",
    }


def check_lean_core():
    result = json.loads((HERE / "lean_verification.json").read_text())
    require(result["status"] == "success", "The formal core did not compile successfully")
    require(result["exit_code"] == 0, "The real Lean compiler returned nonzero")
    require(result["proof_holes"] == [], "The formal core contains proof holes")
    source = (HERE / "Main.lean").read_text()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(
        result["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(),
        "The Lean source changed after its recorded compiler run",
    )
    require(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
        "The statement-fidelity document changed after its recorded compiler run",
    )
    record = result["kernel"]["recorded"]
    require(record["subject"]["subject_id"] == "C320_FORMAL_CORE", "Wrong formal claim")
    require(record["verdict"] == "supports", "The compiler outcome was not recorded as support")
    require(record["produced_by"] == "lean_evidence/lean 4.31.0", "Wrong compiler toolchain")
    require((ROOT / record["artifact"]).is_file(), "Missing official archived compiler certificate")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    versions = [claim for claim in state["claims"] if claim["claim_id"] == "C320_FORMAL_CORE"]
    require(bool(versions), "The formal core is absent from the claim ledger")
    current = max(versions, key=lambda claim: claim["version"])
    require(
        current["formal_statement"].strip() == source.strip(),
        "The ledger carries another formal statement",
    )
    require(
        current["content_hash"] == record["subject"]["content_hash"],
        "The successful compiler result belongs to a superseded claim",
    )
    return {
        "claim_id": "C320_FORMAL_CORE",
        "compiler": record["produced_by"],
        "exit_code": 0,
        "proof_holes": [],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "official_certificate": record["artifact"],
        "scope": "the universal algebraic declarations only; not the topological or imported algebraicity inputs",
    }


def build_certificate():
    return {
        "schema_version": 1,
        "result_class": "partial_result",
        "complete_bridge_certified": False,
        "substantive_mathematical_refutation": False,
        "novelty_status": "not_established",
        "independent_review_status": "not_performed",
        "conditional_bridge_claim": "C320_FORMAL",
        "undischarged_inputs": ["MT_EDGE", "MT_ALGEBRAIC", "PD_FORMS"],
        "report": "report.md",
        "formal_core_claim": "C320_FORMAL_CORE",
        "formal_core_source": "Main.lean",
        "formal_scope_document": "statement_fidelity.md",
        "action_identities": check_action_identities(),
        "law_spanning_identities": check_adjoint_and_four_slot_identities(),
        "individual_square_ring": check_parameter_adapter(),
        "literal_locator_refutation": check_literal_locator(),
        "lean_core": check_lean_core(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    require(path.is_file(), "Missing exact_certificate.json; use --write-certificate once")
    require(json.loads(path.read_text()) == certificate, "Certificate does not replay exactly")
    print(
        json.dumps(
            {
                "ok": True,
                "result_class": certificate["result_class"],
                "complete_bridge_certified": False,
                "literal_claim_refuted": "F_MT_NILPOTENT_LOCATOR",
                "certificate": str(path.relative_to(ROOT)),
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
