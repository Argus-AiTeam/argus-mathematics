#!/usr/bin/env python3
"""Replay exact algebra and the universal Lean orbit theorem for rigidity047."""

import argparse
import hashlib
import json
from pathlib import Path
import subprocess

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "polynomial.ideal.groebner_basis.compute"
DECLARATIONS = [
    "Rigidity047.determinant_coefficients",
    "Rigidity047.ratFunc_neg_X_cube_not_square",
    "Rigidity047.low_degree_coprime",
    "Rigidity047.radical_mul_degree_le",
    "Rigidity047.orbit_radical_degree_le",
    "Rigidity047.orbit_polynomials_constant",
    "Rigidity047.ratFunc_orbit_polynomials_constant",
]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def exact_zero(expression, label):
    require(sp.cancel(expression) == 0, f"{label}: nonzero exact residual")


def command(*args):
    result = subprocess.run(
        [ARGUS_PYTHON, "-m", *args],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=120,
    )
    require(
        result.returncode == 0,
        f"Command failed ({result.returncode}): {' '.join(args)}\n"
        f"{result.stdout}\n{result.stderr}",
    )
    return result.stdout


def fresh_lean_and_local_checks():
    command(
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        "research/rigidity/Main.lean",
        "--project-root",
        str(ROOT),
        "--claim",
        "C_RIGIDITY047",
        "--statement-fidelity",
        "research/rigidity/statement_fidelity.md",
        "--artifact-dir",
        "research/rigidity",
        "--timeout",
        "100",
    )
    command(
        "argus_skill.verticals.math.math_state",
        "check",
        "--project-root",
        str(ROOT),
    )
    command(
        "argus_skill.verticals.math.proof_graph_check",
        "check",
        "--project-root",
        str(ROOT),
    )


def lean_certificate():
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    result = read_json(HERE / "lean_check.json")
    require(result["status"] == "success", "Lean did not succeed")
    require(result["exit_code"] == 0, "Lean compiler exit was not zero")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not succeed")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["environment_failure"] == "", "Lean environment failure")
    require(
        "version 4.31.0," in result["tools"]["lean"]["version"],
        "Wrong Lean version",
    )
    require(
        result["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(),
        "Lean source changed since its compilation",
    )
    require(
        result["statement_fidelity_sha256"]
        == hashlib.sha256(fidelity.encode()).hexdigest(),
        "Statement fidelity changed since compilation",
    )
    for declaration in DECLARATIONS:
        short_name = declaration.split(".")[-1]
        require(f"theorem {short_name}" in source, f"Missing {declaration}")
        require(short_name in fidelity, f"Undocumented {declaration}")
    state = read_json(ROOT / "research/MATH_STATE.json")
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_RIGIDITY047"),
        key=lambda c: c["version"],
    )
    require(claim["formal_statement"] == source, "Claim does not carry this source")
    require(
        any(
            a["assumption_id"] == "A_PROSE_BRIDGE047"
            for a in claim["external_assumptions"]
        ),
        "The unformalized bridge must remain explicit",
    )
    evidence = [
        e
        for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_RIGIDITY047"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical"
        and e["verdict"] == "supports"
    ]
    require(len(evidence) == 1, "Expected one current mechanical certificate")
    archive_path = (ROOT / evidence[0]["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE), "Certificate is outside mission scope")
    archive = read_json(archive_path)
    require(archive["lean_source"]["text"] == source, "Archived source differs")
    require(
        archive["statement_fidelity"]["text"] == fidelity,
        "Archived statement fidelity differs",
    )
    require(
        archive["lean_check"]["source_sha256"] == result["source_sha256"]
        and archive["lean_check"]["statement_fidelity_sha256"]
        == result["statement_fidelity_sha256"]
        and archive["lean_check"]["status"] == "success"
        and archive["lean_check"]["exit_code"] == 0
        and archive["lean_check"]["audit_exit_code"] == 0
        and archive["lean_check"]["proof_holes"] == [],
        "Archived compiler run is inadmissible",
    )
    return {
        "version": "4.31.0",
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "archive": evidence[0]["artifact"],
        "declarations": DECLARATIONS,
        "universal_orbit_theorem": True,
        "coprimality_derived": True,
        "nonsquare_proved_over_RatFunc": True,
        "full_LND_and_intersection_formalization": False,
    }


def typed_polynomial(item, variables):
    require(item["domain"] == "QQ", "Jacobian polynomial has the wrong domain")
    require(item["variables"] == [str(v) for v in variables], "Wrong variable order")
    expression = sp.Integer(0)
    for term in item["polynomial"]["terms"]:
        num = int(term["coefficient"]["num"])
        den = int(term["coefficient"]["den"])
        require(den > 0 and num != 0, "Noncanonical rational coefficient")
        require(sp.gcd(num, den) == 1, "Unreduced rational coefficient")
        exponents = term["exponents"]
        require(
            len(exponents) == len(variables)
            and all(type(e) is int and e >= 0 for e in exponents),
            "Invalid exponent vector",
        )
        expression += sp.Rational(num, den) * sp.prod(
            v**e for v, e in zip(variables, exponents)
        )
    return sp.Poly(expression, *variables, domain=sp.QQ)


def determinant_and_jacobian():
    a, d, b, c, x, y = variables = sp.symbols("a d b c x y")
    relation = a * c - b * d - 1
    differentiated = a * y - d * x
    h = c * x - b * y
    residuals = [a * h - x, d * h - y]
    exact_zero(residuals[0] - (x * relation - b * differentiated), "a h identity")
    exact_zero(residuals[1] - (y * relation - c * differentiated), "d h identity")
    exact_zero(relation.subs(c, (1 + b * d) / a), "a-chart")
    exact_zero(relation.subs(b, (a * c - 1) / d), "d-chart")

    payload = read_json(HERE / "jacobian_payload.json")
    raw = read_json(HERE / "jacobian_output.json")
    adapter = read_json(HERE / "jacobian_adapter_status.json")
    require(adapter["adapter_exit_code"] == 0, "Jacobian adapter failed")
    require(adapter["transport_status"] == "completed", "Incomplete Jacobian transport")
    require(raw["protocol_version"] == adapter["protocol_version"], "Protocol mismatch")
    require(raw["server"]["version"] == adapter["server_version"], "Server mismatch")
    require(raw["request"]["operation_id"] == OPERATION, "Wrong requested operation")
    require(raw["request"]["payload"] == payload, "Payload binding differs")
    require(raw["result"]["operation_id"] == OPERATION, "Wrong result operation")
    output = raw["result"]["output"]
    require(
        output["outcome"] == adapter["outcome"] == "COMPUTED",
        "Timeout, unknown, error, or incomplete result is not evidence",
    )
    require(output["detail"] is None, "Jacobian returned a diagnostic")
    require(output["request"] == payload, "Typed request differs")
    require(output["backend"] == "SYMPY", "Unexpected exact backend")
    supplied = [
        typed_polynomial(p, variables) for p in payload["ideal"]["generators"]
    ]
    require(
        supplied
        == [
            sp.Poly(relation, *variables, domain=sp.QQ),
            sp.Poly(differentiated, *variables, domain=sp.QQ),
        ],
        "The bounded ideal does not encode the determinant bridge",
    )
    basis = sp.groebner(supplied, *variables, order="lex", domain=sp.QQ)
    returned = [
        typed_polynomial(p, variables) for p in output["basis"]["generators"]
    ]
    require(returned == basis.polys, "Exact Groebner replay disagrees")
    require(len(returned) == output["generator_count"] == 3, "Wrong basis size")
    for residual in residuals:
        require(basis.reduce(residual)[1] == 0, "Nonzero determinant remainder")
    return {
        "relation": str(relation),
        "differentiated_relation": str(differentiated),
        "h": str(h),
        "syzygy_residuals": [0, 0],
        "chart_residuals": [0, 0],
        "operation_id": OPERATION,
        "adapter_exit_code": 0,
        "protocol_version": raw["protocol_version"],
        "server_version": raw["server"]["version"],
        "outcome": output["outcome"],
        "groebner_basis": [str(p.as_expr()) for p in returned],
        "groebner_remainders": [0, 0],
        "universal_intersection_proof": "report.md Section 5; not inferred from a finite ideal calculation",
    }


def weights_and_boundaries():
    a, d, b, c, u, q, s = sp.symbols("a d b c u q s")
    generators = (a, d, b, c, u)
    fiber = (1, 1, -1, -1, 0)
    auxiliary = (0, 3, -3, 0, 2)
    relation = a * c - b * d - 1
    v = a**3 * b - a**2 * u**3 - d**2
    N = d**2 + a**2 * u**3

    def degrees(expression, weights):
        return sorted(
            {
                sum(e * w for e, w in zip(monomial, weights))
                for monomial, _ in sp.Poly(expression, *generators).terms()
            }
        )

    require(degrees(relation, fiber) == [0], "Determinant fiber degree")
    require(degrees(relation, auxiliary) == [0], "Determinant auxiliary degree")
    require(degrees(v, fiber) == [2], "v fiber degree")
    require(degrees(a**3 * b, auxiliary) == [-3], "Perturbation degree")
    require(degrees(N, auxiliary) == [6], "N auxiliary degree")

    def shear(expression):
        return sp.expand(a * sp.diff(expression, b) + d * sp.diff(expression, c))

    exact_zero(shear(relation), "shear determinant derivative")
    require(shear(v) == a**4, "Wrong shear image of v")
    exact_zero(shear(shear(v)), "shear second image of v")
    for generator in generators:
        exact_zero(shear(shear(generator)), "shear generator second image")
    require(
        degrees(shear(b), fiber) == [-1 + 2]
        and degrees(shear(c), fiber) == [-1 + 2],
        "Shear shift is not +2",
    )
    exact_zero(
        relation.subs({b: b + q * a, c: c + q * d}, simultaneous=True) - relation,
        "shear polynomial orbit",
    )

    def chart_derivation(expression):
        return sp.cancel(sp.diff(expression, b) / a + d * sp.diff(expression, c) / a**2)

    exact_zero(chart_derivation(relation), "localized determinant derivative")
    exact_zero(chart_derivation(chart_derivation(v)), "localized second image of v")
    require(chart_derivation(b) == 1 / a, "Wrong localized image of b")
    require(relation.subs({a: 0, d: 1, b: -1, c: 0, u: 0}) == 0, "a-zero point")

    enlarged = sp.expand((d + s * q) ** 2 + (a + q) ** 2 * u**3)
    expected = N + 2 * q * (d * s + a * u**3)
    exact_zero(
        enlarged - expected - q**2 * (s**2 + u**3),
        "enlarged-field orbit boundary",
    )
    return {
        "generator_order": [str(g) for g in generators],
        "fiber_weights": list(fiber),
        "auxiliary_degrees": list(auxiliary),
        "determinant_degrees": {"fiber": 0, "auxiliary": 0},
        "v_fiber_degree": 2,
        "perturbation_auxiliary_degree": -3,
        "N_auxiliary_degree": 6,
        "positive_boundary": {
            "images": ["0", "0", "a", "d", "0"],
            "shift": 2,
            "image_v": "a**4",
            "second_image_v": 0,
            "local_nilpotence_proof": "b -> b+q*a, c -> c+q*d; degree lowering in b,c",
            "counterexample_to_manuscript": False,
        },
        "localized_boundary": {
            "image_b": "1/a",
            "image_c": "d/a**2",
            "shift": 0,
            "second_image_v": 0,
            "global_membership": False,
            "point_showing_a_nonunit": [0, 1, -1, 0, 0],
            "counterexample_to_manuscript": False,
        },
        "enlarged_field_boundary": {
            "relation": "s**2+u**3=0",
            "A": "a+q",
            "D": "d+s*q",
            "U": "u",
            "orbit": "d**2+a**2*u**3+2*q*(d*s+a*u**3)",
            "identity_residual": 0,
            "original_coefficient_field": False,
            "counterexample_to_manuscript": False,
        },
    }


def symbolic_generalization():
    m, da, dd, du, r, df, dg = sp.symbols("m da dd du r df dg", integer=True)
    lower = dd - da - (m - 1) * du
    upper = da + du - dd
    exact_zero(lower + upper + (m - 2) * du, "general odd-power degree squeeze")
    exact_zero(
        (2 * df - (2 * r + 1) - 2 * dg) - (2 * (df - dg - r) - 1),
        "odd square-degree obstruction",
    )
    return {
        "statement": "For every characteristic-zero k, odd m>=3, and P of auxiliary degree <2m for (0,m,-m,0,2), E homogeneous LND with shift e<2 and E^2(P-d^2-a^2*u^m)=0 implies E=0.",
        "proof": "report.md Sections 1--6",
        "formalized_exponent": 3,
        "all_odd_exponents_kernel_formalized": False,
        "degree_squeeze_identity_residual": 0,
        "odd_degree_identity_residual": 0,
        "novelty_status": "unassessed",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--reuse-lean",
        action="store_true",
        help="Replay current source-bound compiler evidence without a fresh compilation.",
    )
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if not args.reuse_lean:
        fresh_lean_and_local_checks()
    certificate = {
        "claim_id": "C_RIGIDITY047",
        "result_kind": "universal_verification_theorem",
        "statement": "Every homogeneous locally nilpotent C-derivation of C[a,d,b,c,u]/(ac-bd-1), of shift e<=0 for weights (1,1,-1,-1,0), with E^2(a^3*b-a^2*u^3-d^2)=0, is zero.",
        "proof": "report.md Sections 1--6",
        "scope": {
            "unbounded_quantification": True,
            "full_cancellation_theorem_verified": False,
            "independent_reviewer_acceptance_recorded_by_engineer": False,
            "new_false_manuscript_assertion_identified": False,
        },
        "lean": lean_certificate(),
        "determinant_bridge": determinant_and_jacobian(),
        "weights_and_boundaries": weights_and_boundaries(),
        "structural_extension": symbolic_generalization(),
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    else:
        require(read_json(path) == certificate, "Exact certificate differs from replay")
    print(
        json.dumps(
            {
                "status": "verified",
                "claim": "C_RIGIDITY047",
                "lean_mode": "recorded_run_replay" if args.reuse_lean else "fresh_compilation",
                "proof_holes": [],
                "exact_algebra": "passed",
                "universal_polynomial_theorem": "kernel_checked",
                "LND_and_intersection_bridge": "prose_proof_requires_independent_review",
                "certificate": str(path.relative_to(ROOT)),
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
