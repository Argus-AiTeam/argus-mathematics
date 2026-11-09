#!/usr/bin/env python3
"""Replay exact algebra and the recorded Lean core; geometry is in report.md."""

import argparse
from fractions import Fraction
import hashlib
from itertools import product
import json
from pathlib import Path
import re


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
OPERATION = "matrix.symbolic.determinant.compute"
VARIABLES = ["t", "m1", "m2", "a1", "a2", "b1", "b2"]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def polynomial(value):
    require(value["domain"] == "QQ", "Nonrational Jacobian output")
    require(value["variables"] == VARIABLES, "Variable order changed")
    unit = {
        "terms": [{
            "coefficient": {"num": "1", "den": "1"},
            "exponents": [0] * len(VARIABLES),
        }]
    }
    require(value["denominator"] == unit, "Expected polynomial denominator one")
    result = {}
    order = []
    for term in value["numerator"]["terms"]:
        exponents = tuple(term["exponents"])
        require(
            len(exponents) == len(VARIABLES)
            and all(type(e) is int and e >= 0 for e in exponents),
            "Invalid polynomial exponent",
        )
        coefficient = term["coefficient"]
        rational = Fraction(int(coefficient["num"]), int(coefficient["den"]))
        require(
            rational != 0
            and str(rational.numerator) == coefficient["num"]
            and str(rational.denominator) == coefficient["den"],
            "Noncanonical polynomial coefficient",
        )
        require(exponents not in result, "Duplicate monomial")
        result[exponents] = rational
        order.append(exponents)
    require(order == sorted(order, reverse=True), "Noncanonical monomial order")
    return result


def multiply(left, right):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            exponent = tuple(i + j for i, j in zip(a, b))
            result[exponent] = result.get(exponent, Fraction(0)) + x * y
    return {e: c for e, c in result.items() if c}


def subtract(left, right):
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, Fraction(0)) - coefficient
    return {e: c for e, c in result.items() if c}


def replay_jacobian():
    payload = load("jacobian_payload.json")
    envelope = load("jacobian_output.json")
    execution = load("jacobian_execution.json")
    require(
        execution["adapter_exit_code"] == 0
        and execution["timeout"] is False
        and execution["adapter_error"] is None
        and execution["status"] == "success",
        "The adapter did not return a conclusive successful calculation",
    )
    require(envelope["schema_version"] == 1, "Unknown adapter envelope schema")
    require(envelope["protocol_version"] == "2025-11-25", "Protocol changed")
    require(envelope["server"]["version"] == "0.14.0", "Server version changed")
    require("error" not in envelope, "Adapter reported an error")
    request, result = envelope["request"], envelope["result"]
    require(request["operation_id"] == OPERATION, "Wrong requested operation")
    require(result["operation_id"] == OPERATION, "Wrong returned operation")
    require(request["payload"] == payload, "Output is not bound to this payload")
    require(result["output"]["method"] == "SYMPY_BAREISS", "Unexpected method")
    matrix = payload["matrix"]
    require(matrix["variables"] == VARIABLES, "Payload variable order changed")
    require(
        len(matrix["entries"]) == 2
        and all(len(row) == 2 for row in matrix["entries"]),
        "Expected the inspected two-by-two subproblem",
    )
    entries = [[polynomial(x) for x in row] for row in matrix["entries"]]
    expected_entries = [
        [
            {(1, 0, 0, 1, 0, 0, 0): Fraction(1),
             (0, 1, 0, 0, 0, 0, 0): Fraction(1)},
            {(1, 0, 0, 0, 1, 0, 0): Fraction(1),
             (0, 0, 1, 0, 0, 0, 0): Fraction(1)},
        ],
        [
            {(0, 0, 0, 0, 0, 1, 0): Fraction(1)},
            {(0, 0, 0, 0, 0, 0, 1): Fraction(1)},
        ],
    ]
    require(entries == expected_entries, "The logarithmic matrix changed")
    independent = subtract(
        multiply(entries[0][0], entries[1][1]),
        multiply(entries[0][1], entries[1][0]),
    )
    returned = polynomial(result["output"]["determinant"])
    require(independent == returned, "Exact determinant replay disagrees")
    require(len(returned) == 4, "Unexpected determinant support")
    require(max(e[0] for e in returned) == 1, "A higher pole term survived")
    return {
        "operation_id": OPERATION,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_code": execution["adapter_exit_code"],
        "timeout": execution["timeout"],
        "adapter_error": execution["adapter_error"],
        "typed_output_replayed": True,
        "determinant": "t*a1*b2 - t*a2*b1 + m1*b2 - m2*b1",
        "degree_in_uniformizer": 1,
        "scope": "Exact symbolic two-by-two identity, not an all-dimension proof",
    }


def rational_stress_tests():
    branches = [(Fraction(a), Fraction(e))
                for a in range(7) for e in range(1, 7)]
    threshold_cases = 0
    intersection_cases = 0
    weights = [(1, 0), (0, 1), (1, 1), (1, 2),
               (2, 1), (2, 3), (3, 2)]
    for components in product(branches, repeat=2):
        lam = min((a + 1) / e for a, e in components)
        correction = max(Fraction(0), lam - 1)
        room = min(lam, Fraction(1))
        require(lam > 0 and room > 0, "Empty proposed chamber")
        require(lam - correction == room, "Incorrect clipped-minimum identity")
        for a, e in components:
            require(a - e * correction >= 0, "Boundary is not nonpositive")
            if a == 0:
                require(correction == 0, "Correction is not exceptional")
        for b in (-Fraction(1, 3), Fraction(0), room / 2,
                  room, room + Fraction(1, 3)):
            exponents = [a - e * (correction + b) for a, e in components]
            require(
                all(gamma > -1 for gamma in exponents) == (b < room),
                f"Sharp threshold failed for {components}, b={b}",
            )
            threshold_cases += 1
        positive_discrepancies = [
            1 + a - e * (correction + room / 2) for a, e in components
        ]
        for w in weights:
            value = sum(weight * discrepancy
                        for weight, discrepancy in zip(w, positive_discrepancies))
            require(value > 0, "A sampled intersection valuation is not klt")
            intersection_cases += 1
    return {
        "branch_pairs": len(branches) ** 2,
        "threshold_cases": threshold_cases,
        "intersection_weight_cases": intersection_cases,
        "bounds": {"jacobian_order": [0, 6], "multiplicity": [1, 6]},
        "endpoint_included": True,
        "scope": "Finite adversarial arithmetic tests only; universal proof is separate",
    }


def replay_lean():
    result = load("lean_verification.json")
    require(result["status"] == "success", "Lean did not certify the source")
    require(result["exit_code"] == 0, "Lean returned a nonzero exit code")
    require(result["proof_holes"] == [], "Lean source has proof holes")
    require(result["environment_failure"] == "", "Lean environment failure")
    version = result["tools"]["lean"]["version"]
    require("Lean (version 4.31.0," in version, "Wrong Lean version")
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    require(Path(result["source"]).resolve() == source, "Wrong compiled source")
    require(
        Path(result["statement_fidelity"]).resolve() == fidelity,
        "Wrong statement-fidelity document",
    )
    source_hash = hashlib.sha256(source.read_bytes()).hexdigest()
    fidelity_text = fidelity.read_text(encoding="utf-8")
    fidelity_hash = hashlib.sha256(fidelity_text.encode("utf-8")).hexdigest()
    require(result["source_sha256"] == source_hash, "Lean evidence is stale")
    require(
        result["statement_fidelity_sha256"] == fidelity_hash,
        "Statement fidelity changed after compilation",
    )
    recorded = result["kernel"]["recorded"]
    require(recorded["verdict"] == "supports", "No supporting compiler evidence")
    require(recorded["tier"] == "mechanical", "Wrong compiler evidence tier")
    require(
        recorded["subject"]["subject_id"] == "C_TV_FORMAL_CORE",
        "Compiler evidence belongs to a different claim",
    )
    archive_path = (ROOT / recorded["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE), "Certificate leaves the owned subtree")
    archive = json.loads(archive_path.read_text(encoding="utf-8"))
    require(
        archive["lean_source"]["text"] == source.read_text(encoding="utf-8"),
        "Archived formal source changed",
    )
    require(
        archive["statement_fidelity"]["text"] == fidelity_text,
        "Archived statement fidelity changed",
    )
    require(
        archive["lean_check"] == {k: v for k, v in result.items() if k != "kernel"},
        "Compiler envelope and archived result disagree",
    )
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text(encoding="utf-8"))
    versions = [c for c in ledger["claims"] if c["claim_id"] == "C_TV_FORMAL_CORE"]
    require(versions, "Formal claim is absent from the ledger")
    current = max(versions, key=lambda c: c["version"])
    require(
        current["content_hash"] == recorded["subject"]["content_hash"],
        "Compiler evidence refers to a superseded claim",
    )
    declarations = re.findall(
        r"^theorem\s+([A-Za-z0-9_]+)", source.read_text(encoding="utf-8"), re.MULTILINE
    )
    expected = [
        "cleared_logarithmic_determinant",
        "at_most_simple_logarithmic_pole",
        "correction_nonnegative",
        "room_identity",
        "correction_bounded_by_jacobian",
        "nonexceptional_branch_forces_zero",
        "minimum_positive",
        "positive_room",
        "sharp_prime_threshold",
        "full_support_discrepancy",
        "klt_type_monotonicity",
        "blowup_endpoint",
    ]
    require(declarations == expected, "The formal theorem set changed")
    return {
        "claim": "C_TV_FORMAL_CORE",
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "source_sha256": source_hash,
        "statement_fidelity_sha256": fidelity_hash,
        "archived_certificate": recorded["artifact"],
        "declarations": declarations,
        "scope": "Universal algebraic core only; no formal analytic or geometric theorem",
    }


def certificate():
    return {
        "campaign": "9000068",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "target_claim": "C_G_VOLUME",
        "extensions": ["C_TV_KLT_TYPE", "C_TV_SHARP_CHAMBER"],
        "mathematical_evidence": "report.md: complete prose proof with explicit cited input",
        "classification": {
            "result": "verification_theorem_with_structural_extensions",
            "counterexample_found": False,
            "novelty_status": "unverified",
            "significance_status": "pending_independent_review",
            "independent_reviewer_acceptance": False,
            "campaign_complete": False,
        },
        "jacobian": replay_jacobian(),
        "adversarial_tests": rational_stress_tests(),
        "lean": replay_lean(),
        "sharpness_construction": {
            "parameters": "all integers c>=2 and r>=0",
            "X": "P^c x P^r",
            "Y": "Bl_coordinate_point(P^c)",
            "W": "Y x P^r",
            "p": "blowdown x identity",
            "f": "projection to Y",
            "source_jacobian_order": "c-1",
            "base_multiplicity": 1,
            "correction": "(c-1)D",
            "full_generic_adjoint_rank_at_zero": 1,
            "perturbed_exponent": "-s",
            "integrability_condition": "s<1",
            "endpoint_s_equals_one": "logarithmic divergence",
            "geometric_hypotheses": "proved in report.md, not inferred from numeric data",
        },
        "unverified": [
            "Independent Reviewer acceptance and statement-fidelity assessment",
            "Publication significance and novelty of the structural extensions",
            "Official literature-attribution records outside the writable boundary",
            "Applications' model, generic-rank and curvature-patch premises",
            "Other manuscripts' principal theorems and headline nonvanishing",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    else:
        require(load("exact_certificate.json") == result, "Exact certificate is stale")
    print(json.dumps({
        "ok": True,
        "jacobian": "exact typed output independently replayed",
        "threshold_cases": result["adversarial_tests"]["threshold_cases"],
        "intersection_cases": result["adversarial_tests"]["intersection_weight_cases"],
        "lean_exit_code": result["lean"]["exit_code"],
        "proof_holes": result["lean"]["proof_holes"],
        "scope": "Report proves geometry/analysis; Lean certifies the stated algebraic core",
        "independent_review": "pending",
        "novelty": "unverified",
    }, indent=2))


if __name__ == "__main__":
    main()
