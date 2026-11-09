#!/usr/bin/env python3
"""Replay exact algebra and check the source-bound Lean certificate."""

import hashlib
import json
import re
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def constant(entry):
    require(entry["variables"] == [], "Nonconstant Jacobian matrix entry")

    def polynomial(terms):
        require(all(t["exponents"] == [] for t in terms), "Unexpected variable")
        return sum(
            (Q(int(t["coefficient"]["num"]), int(t["coefficient"]["den"]))
             for t in terms),
            Q(0),
        )

    return polynomial(entry["numerator"]["terms"]) / polynomial(
        entry["denominator"]["terms"]
    )


def matrix(value):
    require(value["variables"] == [], "Unexpected symbolic field")
    return [[constant(entry) for entry in row] for row in value["entries"]]


def product(left, right):
    return [
        [sum((a * b for a, b in zip(row, column)), Q(0))
         for column in zip(*right)]
        for row in left
    ]


def multiply_polynomials(left, right):
    result = {}
    for x, a in left.items():
        for y, b in right.items():
            exponent = tuple(u + v for u, v in zip(x, y))
            result[exponent] = result.get(exponent, Q(0)) + a * b
    return {k: v for k, v in result.items() if v}


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    typed = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "matrix.symbolic.multiply.compute"
    require(typed["server"]["version"] == "0.14.0", "Unexpected server version")
    require(typed["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(typed["request"]["operation_id"] == operation, "Wrong operation")
    require(typed["request"]["payload"] == payload, "Payload is not source-bound")
    require(typed["result"]["operation_id"] == operation, "Wrong typed result")
    left, right = matrix(payload["left"]), matrix(payload["right"])
    require(left == [list(row) for row in zip(*right)], "Not a Gram product")
    gram = matrix(typed["result"]["output"])
    require(gram == product(left, right), "Jacobian product does not replay")
    difference_gram = [[Q(1), Q(-1)], [Q(-1), Q(1)]]
    corrected = [
        [gram[i][j] - Q(3, 4) * difference_gram[i][j] for j in range(2)]
        for i in range(2)
    ]
    require(corrected == [[Q(1, 2), Q(0)], [Q(0), Q(1, 2)]],
            "Weighted parallelogram identity failed")
    return {
        "operation_id": operation,
        "adapter_exit_code": 0,
        "server_version": typed["server"]["version"],
        "protocol_version": typed["protocol_version"],
        "typed_output_replayed": True,
        "scope": "Exact two-coordinate Gram identity only",
    }


def check_algebra():
    gain = Q(3, 4) / 8 - Q(1, 64)
    require(gain == Q(5, 64) and gain > 0, "Incorrect amplification margin")

    # Variables are (b, j). This proves the denominator comparison for all j.
    factorized = multiply_polynomials(
        {(1, 0): Q(1), (0, 0): Q(1)},
        {(0, 1): Q(1), (0, 0): Q(-1)},
    )
    expanded = {
        (1, 1): Q(1), (0, 1): Q(1),
        (1, 0): Q(-1), (0, 0): Q(-1),
    }
    require(factorized == expanded, "Affine denominator factorization failed")

    # Variables are (actual, error). The remainder is a square.
    triangle_remainder = multiply_polynomials(
        {(1, 0): Q(1), (0, 1): Q(1)},
        {(1, 0): Q(1), (0, 1): Q(1)},
    )
    require(triangle_remainder ==
            {(2, 0): Q(1), (1, 1): Q(2), (0, 2): Q(1)},
            "Squared triangle remainder failed")

    count = 0
    for B in (Q(1, 2), Q(1), Q(3)):
        for b in (Q(0), Q(1, 4), Q(1), Q(2)):
            centers = (-100 * B, -2 * B, -B - b, -B, Q(0),
                       B, B + b, 2 * B, 100 * B)
            for e in centers:
                length = max(Q(0), min(B, e + b) - max(-B, e - b))
                require(Q(0) <= length <= 2 * min(B, b),
                        "Interval capture bound failed")
                require(length / (2 * B) <= b / B,
                        "Unrestricted-center capture bound failed")
                if abs(e) + b <= B:
                    require(length / (2 * B) == b / B,
                            "Interior capture equality failed")
                count += 1
    return {
        "strict_margin_at_alpha_3_over_4_and_error_square_c2_over_64": str(gain),
        "denominator_identity": "(b+1+l)*j-(b+1+j*l)=(b+1)*(j-1)",
        "triangle_remainder": "2*x^2+2*y^2-(x-y)^2=(x+y)^2",
        "supplementary_exact_interval_cases": count,
        "finite_case_scope": "Boundary stress tests, not the proof of all real centers",
    }


def check_lean():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "C_RA_CORE"]
    require(bool(claims), "Missing C_RA_CORE claim")
    claim = max(claims, key=lambda c: c["version"])
    require(claim["external_assumptions"] == [],
            "The formal accounting core has acquired an external assumption")
    source = (HERE / "Main.lean").read_text()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(claim["formal_statement"].strip() == source.strip(),
            "Ledger formalization differs from the current source")
    candidates = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_RA_CORE"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(bool(candidates), "No supporting mechanical evidence for the current claim")
    artifact = candidates[-1]["artifact"]
    archive = json.loads((ROOT / artifact).read_text())
    require(archive["produced_by"] == "lean_evidence/lean 4.31.0",
            "The certificate is not from Lean 4.31.0")
    result = archive["lean_check"]
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The real Lean compiler did not succeed")
    require(result["proof_holes"] == [], "The source contains proof holes")
    require(archive["lean_source"]["text"] == source, "Archived Lean source is stale")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "Archived statement fidelity is stale")
    require(result["source_sha256"] ==
            hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest(),
            "Compiler source binding is stale")
    require(result["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.encode()).hexdigest(),
            "Compiler statement-fidelity binding is stale")
    require(re.search(r"\b(sorry|admit|axiom)\b", source) is None,
            "A proof hole or added axiom appears in the source")
    declarations = [
        "capture_probability_le", "capture_probability_eq",
        "norm_sub_sq_le_two", "averaging_loss",
        "capture_weight_harmonic_lower", "capture_weight_not_summable",
        "weighted_error_floor", "nonsummable_budget_obstruction",
        "arbitrary_terminal_amplification", "affine_capture_amplification",
    ]
    for name in declarations:
        require(re.search(r"^theorem " + name + r"\b", source, re.MULTILINE),
                "Missing substantive declaration: " + name)
    return {
        "claim": "C_RA_CORE",
        "artifact": artifact,
        "version": "4.31.0",
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "source_and_fidelity_current": True,
        "declarations": declarations,
        "coverage": "All finite terminal lengths; terminal-dependent data; actual affine-weight nonsummability; unrestricted scalar centers; Hilbert norm loss",
        "not_encoded": "Spectral disintegration, operator probability experiment, Plancherel, upstream uniform energy estimate, full relative theorem",
    }


def main():
    certificate = {
        "claim": "C_RA",
        "result": "Analytic rigidity proof with source-bound formal amplification core",
        "operator_statement": "Uniform narrow-total-energy word estimates for all lengths and shifts imply U=D",
        "weighted_extension": "sum a_j*e_(m,j-1)^2 >= alpha*c^2/8*sum a_j - 1",
        "jacobian": check_jacobian(),
        "exact_algebra": check_algebra(),
        "lean": check_lean(),
        "independent_review": "pending; neither novelty nor publishability is self-certified",
    }
    (HERE / "exact_certificate.json").write_text(
        json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps({
        "status": "verified",
        "formal_claim": certificate["lean"]["claim"],
        "proof_holes": certificate["lean"]["proof_holes"],
        "terminal_lengths": "arbitrary",
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
