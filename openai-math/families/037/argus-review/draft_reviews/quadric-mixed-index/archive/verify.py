#!/usr/bin/env python3
"""Replay the exact arithmetic, Taylor example, and bound Lean evidence."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    value = sp.Rational(value)
    return {"num": str(value.p), "den": str(value.q)}


def monomials(dimension, degree):
    return sorted(
        (a for a in itertools.product(range(degree + 1), repeat=dimension)
         if sum(a) <= degree),
        key=lambda a: (sum(a), a),
    )


def taylor_data():
    z = sp.symbols("z1:5")
    basis = (sp.Integer(1), *z, sum(x**2 for x in z))
    rows = monomials(4, 2)
    polys = [sp.Poly(f, *z) for f in basis]
    matrix = sp.Matrix([
        [f.coeff_monomial(a) for f in polys] for a in rows
    ])
    payload = {
        "matrix": {
            "domain": "QQ",
            "entries": [[rational(x) for x in row] for row in matrix.tolist()],
        }
    }
    return rows, matrix, payload


def symbolic_identities():
    j, r, t0, p, S = sp.symbols("j r t0 p S", real=True)
    a = sp.Symbol("a", positive=True, integer=True)
    U = p + S
    M, KB, L, E, KY, Eprime, G = sp.symbols("M KB L E KY Eprime G")
    KZ = KB + (S - 1) * E
    P = M - p * E
    H = a * t0 * L - a * U * E
    adjoint_difference = sp.expand(P - (KZ + E) - H / a)
    expected_difference = M - KB - t0 * L
    require(sp.expand(adjoint_difference - expected_difference) == 0,
            "Weighted canonical cancellation failed.")
    specialization = sp.expand(
        adjoint_difference.subs({M: j * L, KB: -r * L})
        - (j + r - t0) * L
    )
    require(specialization == 0, "Subcanonical specialization failed.")
    floor = sp.Symbol("floor_G_over_a")
    A = KY + P - KZ - E - floor
    fractional = G / a - floor
    require(sp.expand(
        A - (KY + fractional)
        - (M - KB - t0 * L + (H - G) / a)
    ) == 0, "Resolution positivity identity failed.")
    require(sp.expand(
        A + Eprime - P
        - (KY - KZ - E + Eprime - floor)
    ) == 0, "Pushdown correction identity failed.")
    Dc, Kc, R, Theta, frac = sp.symbols("Dc Kc R Theta frac")
    Delta = R + Theta - frac
    require(sp.expand(
        Dc - frac - (Kc + Delta) - (Dc - (Kc + R + Theta))
    ) == 0, "Coarse rounding identity failed.")
    T = sp.Symbol("T")
    require(sp.cancel(
        (1 - T**2) / (1 - T)**6 - (1 + T) / (1 - T)**5
    ) == 0, "Quadric normal-form Hilbert identity failed.")
    return {
        "method": "exact symbolic polynomial and rational-function identities",
        "weighted_canonical_difference": str(expected_difference),
        "subcanonical_difference": "(j+r-t0)*L",
        "resolution_positivity_residual": "0",
        "pushdown_correction_residual": "0",
        "coarse_rounding_residual": "0",
        "quadric_hilbert_residual": "0",
        "logical_limit": "Identities do not prove nefness, vanishing, or lifting.",
    }


def quadric_check():
    rows, matrix, payload = taylor_data()
    require(matrix.rank() == 6, "The actual degree-one Taylor map lost rank.")
    target = (0, 0, 0, 2)
    near_miss = (0, 0, 1, 1)

    def prefix_ranks(alpha):
        index = rows.index(alpha)
        return [matrix[:index, :].rank(), matrix[:index + 1, :].rank()]

    require(prefix_ranks(target) == [5, 6], "Required initial is not attained.")
    require(prefix_ranks(near_miss) == [6, 6],
            "The boundary near-miss unexpectedly occurs.")
    c = sp.Matrix([4, 1, 1, 1, 1])
    q = sp.Matrix([1, *target])
    bad = sp.Matrix([1, *near_miss])
    eta = sp.Matrix([[2, -2, -2, -2, -1]])
    generators = [
        sp.Matrix([1, 0, 0, 0, 0]),
        sp.Matrix([1, 1, 0, 0, 0]),
        sp.Matrix([1, 0, 1, 0, 0]),
        sp.Matrix([1, 0, 0, 1, 0]),
        sp.Matrix([1, 0, 0, 0, 2]),
    ]
    coefficients = [sp.Rational(1, 2), 1, 1, 1, sp.Rational(3, 2)]
    V = sp.Matrix.hstack(*generators)
    require(V.det() != 0, "The actual initial indices do not span.")
    require(all(x > 0 for x in coefficients), "Convex coefficients not strict.")
    require(V * sp.Matrix(coefficients) == q + c,
            "Strict-interior witness does not use actual section indices.")
    require((eta * c)[0] == 1, "Primitive facet height is not one.")
    require((eta * (q + c))[0] == 1, "Admissible shift is not strict.")
    require((eta * (bad + c))[0] == 0,
            "Rejected target should have a boundary, not interior, shift.")

    z = sp.symbols("z1:5")
    quadric = sum(x**2 for x in z)
    checked = {}
    for degree in range(5):
        actual = set()
        for powers in itertools.product(range(degree + 1), repeat=6):
            if sum(powers) != degree or powers[4] > 1:
                continue
            a0, a1, a2, a3, a4, b = powers
            polynomial = sp.Poly(
                z[0]**a1 * z[1]**a2 * z[2]**a3 * z[3]**a4 * quadric**b,
                *z,
            )
            initial = min(polynomial.monoms(), key=lambda x: (sum(x), x))
            expected = (a1, a2, a3, a4 + 2 * b)
            require(initial == expected, "Quadric normal-form initial failed.")
            require(initial not in actual, "Normal-form initials collided.")
            require(a0 == degree - a1 - a2 - a3 - a4 - b,
                    "Normal-form degree bookkeeping failed.")
            actual.add(initial)
        predicted = {
            alpha for alpha in monomials(4, 2 * degree)
            if sum(alpha[:3]) + (alpha[3] + 1) // 2 <= degree
        }
        require(actual == predicted, "Exact section indices differ from the cone.")
        expected_dimension = sp.binomial(degree + 5, 5)
        if degree >= 2:
            expected_dimension -= sp.binomial(degree + 3, 5)
        require(len(actual) == expected_dimension,
                "Degree slice disagrees with the quadric section-ring dimension.")
        checked[str(degree)] = len(actual)
    return {
        "variety": "Q^4: X0*Y=X1^2+X2^2+X3^2+X4^2 in P^5",
        "chart": "X0=1, zi=Xi/X0",
        "section_basis_degree_one": ["1", "z1", "z2", "z3", "z4",
                                     "z1^2+z2^2+z3^2+z4^2"],
        "lattice": "Z^5 (m=1)",
        "canonical_vector": [int(x) for x in c],
        "primitive_noncoordinate_facet": [int(x) for x in eta],
        "actual_independent_section_indices": [[int(y) for y in x] for x in generators],
        "strict_interior_target_shift": [int(x) for x in q + c],
        "strict_positive_generator_coefficients": [str(x) for x in coefficients],
        "target_prefix_ranks": prefix_ranks(target),
        "excluded_boundary_near_miss": {
            "index": [int(x) for x in bad],
            "shifted_facet_value": 0,
            "prefix_ranks": prefix_ranks(near_miss),
            "classification": "not a counterexample: strict interior fails",
        },
        "finite_normal_form_replay_dimensions": checked,
        "universal_normal_form_proof": "report.md, exact quadric replay",
        "logical_limit": "The example is not evidence for the universal geometric theorem.",
    }, payload


def jacobian_check(payload):
    submitted = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    adapter = json.loads((HERE / "jacobian_exit.json").read_text())
    require(adapter == {
        "operation_id": "matrix.rank.compute", "adapter_exit_code": 0, "timeout": False,
    }, "Jacobian adapter did not complete successfully.")
    require(submitted == payload, "Jacobian payload is not the actual Taylor map.")
    require(response["request"] == {
        "operation_id": "matrix.rank.compute", "payload": payload,
    }, "The adapter request differs from the preserved payload.")
    require(response["server"]["version"] == "0.14.0",
            "Unexpected Jacobian server version; inspect its new contract.")
    require(response["protocol_version"] == "2025-11-25",
            "Unexpected Jacobian protocol.")
    result = response["result"]
    require(result["operation_id"] == "matrix.rank.compute",
            "Wrong Jacobian operation.")
    require(result["output"]["matrix"] == payload["matrix"],
            "Jacobian result is not bound to the exact supplied matrix.")
    require(result["output"]["rank"] == 6, "Jacobian rank disagrees.")
    require(result["output"]["pivot_columns"] == list(range(6)),
            "Jacobian pivot columns disagree.")
    return {
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "operation_id": result["operation_id"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "rank": 6,
        "adapter_status": "success",
    }


def lean_check():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["exit_code"] == 0 and result["proof_holes"] == [],
            "A successful hole-free Lean run is required.")
    require("version 4.31.0," in result["tools"]["lean"]["version"],
            "The formal certificate was not produced by Lean 4.31.0.")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not pass.")
    require(result["environment_failure"] == "", "Lean environment was not verified.")
    for name, key in (("Main.lean", "source_sha256"),
                      ("statement_fidelity.md", "statement_fidelity_sha256")):
        current = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        require(current == result[key], f"{name} changed after its compiler run.")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_AJL_FACET_KERNEL"
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(len(evidence) == 1, "Expected one current formal kernel certificate.")
    claims = [c for c in state["claims"] if c["claim_id"] == "C_AJL_FACET_KERNEL"]
    require(bool(claims), "The formal claim is missing.")
    latest = max(claims, key=lambda c: c["version"])
    require(evidence[0]["subject"]["content_hash"] == latest["content_hash"],
            "The formal claim has been revised since its compile.")
    require(latest["formal_statement"].strip() == (HERE / "Main.lean").read_text().strip(),
            "The claim's formal statement differs from its source.")
    archive_path = ROOT / evidence[0]["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == result, "The archived compile result differs.")
    require(archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
            "The archived theorem differs from the current source.")
    require(archive["statement_fidelity"]["text"]
            == (HERE / "statement_fidelity.md").read_text(),
            "The archived fidelity document differs.")
    return {
        "claim": "C_AJL_FACET_KERNEL",
        "compiler": "Lean 4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "audit_exit_code": 0,
        "certificate": evidence[0]["artifact"],
        "scope": "arbitrary finite integral height-one support forms; not orbifold geometry",
        "statement_fidelity_review": "pending independent Reviewer",
    }


def certificate():
    example, payload = quadric_check()
    return {
        "schema_version": 1,
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "result_class": "complete_solution",
        "result_scope": "adjoint-lifting and saturation mission, not the full volume-gap campaign",
        "mathematical_proof": {
            "artifact": "report.md",
            "theorems": ["A: nef-twisted adjoint Taylor lifting",
                         "B: abstract lattice-strip cone rigidity"],
            "manuscript_consequences": ["adj:implication", "adj:saturation"],
            "kind": "prose proof using explicitly recorded external geometric theorems",
        },
        "refuted_manuscript_assertions": [],
        "symbolic_identities": symbolic_identities(),
        "exact_quadric_replay": example,
        "jacobian": jacobian_check(payload),
        "lean": lean_check(),
        "independent_review": "pending Host-appointed Reviewer",
        "novelty_status": "not_established",
        "significance_status": "not_independently_assessed",
        "not_certified": [
            "The companion fourfold theorem and the complete volume-gap argument",
            "Machine verification of the geometric and real-convex proofs",
            "Independent citation attribution, statement fidelity, novelty, significance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        _, _, payload = taylor_data()
        path = HERE / "jacobian_payload.json"
        path.write_text(json.dumps(payload, indent=2) + "\n")
        print(f"Prepared actual Q^4 degree-one Taylor matrix: {path}")
        return
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == result,
                "Certificate differs from the current exact replay.")
    print("PASS: symbolic identities, actual Taylor map, strict interior witness, "
          "boundary rejection, and current hole-free Lean 4.31 certificate.")
    print("Geometry is proved in report.md; independent review and novelty remain pending.")


if __name__ == "__main__":
    main()
