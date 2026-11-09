#!/usr/bin/env python3
"""Replay exact family witnesses; distinguish finite checks from the Lean theorem."""

import argparse
import hashlib
import json
import re
from fractions import Fraction
from pathlib import Path

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
LEAN_CERTIFICATE = HERE / "certificates/C_SHARP_COMPARISON-3b065712b1907f9f.json"
LATTICE_CERTIFICATE = HERE / "lattice/certificates/C_SHARP_LATTICE_CORE-175235729223f4a4.json"
AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
DECLARATIONS = {
    "SharpCharacterComparison.sharp_character_comparison",
    "SharpCharacterComparison.comparison_denominators",
}
BASE_PARAMETERS = (
    (3, 1), (3, 2), (3, 3), (3, 4),
    (5, 1), (5, 2), (7, 1), (7, 2), (11, 1),
)
Y = sp.Symbol("Y")
Z = sp.Symbol("Z")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rational(value):
    q = sp.Rational(value)
    return Fraction(int(q.p), int(q.q))


def valuation(value, p):
    value = rational(value)
    require(value != 0, "valuation of zero was requested")
    numerator, denominator = abs(value.numerator), value.denominator
    result = 0
    while numerator % p == 0:
        numerator //= p
        result += 1
    while denominator % p == 0:
        denominator //= p
        result -= 1
    return result


def residue(value, p):
    value = rational(value)
    require(value.denominator % p != 0, "nonintegral p-local residue")
    return value.numerator * pow(value.denominator, -1, p) % p


def cyclic_product(left, right, order):
    result = {}
    for i, a in left.items():
        for j, b in right.items():
            k = (i + j) % order
            result[k] = result.get(k, Fraction(0)) + a * b
    return {i: a for i, a in result.items() if a}


def matrix_from_typed(data):
    require(data["domain"] == "ZZ", "Jacobian matrix domain changed")
    rows = data["entries"]
    require(len(rows) == data["row_count"], "Jacobian row count mismatch")
    require(all(len(row) == data["column_count"] for row in rows),
            "Jacobian column count mismatch")
    return sp.Matrix([[int(x) for x in row] for row in rows])


def check_jacobian():
    payload = load(HERE / "jacobian_payload.json")
    data = load(HERE / "jacobian_output.json")
    operation = "matrix.normal_form.smith.certified.compute"
    require(data["server"]["version"] == "0.14.0", "Jacobian version changed")
    require(data["protocol_version"] == "2025-11-25", "Jacobian protocol changed")
    require(data["tool"] == "math.run", "not a Jacobian execution")
    require(data["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian request does not match the retained exact payload")
    result = data["result"]
    require(result["operation_id"] == operation, "Jacobian operation changed")
    output = result["output"]
    require(output["exactness"] == "EXACT_INTEGER", "Jacobian result is not exact")
    require(output["completeness"] == "FULL_MATRIX_TRANSFORMATIONS",
            "Jacobian result is incomplete")
    certificate = output["certificate"]
    source = matrix_from_typed(certificate["source"])
    diagonal = matrix_from_typed(certificate["diagonal"])
    left = matrix_from_typed(certificate["left_transformation"])
    right = matrix_from_typed(certificate["right_transformation"])
    require(source == matrix_from_typed(payload["matrix"]), "source matrix changed")
    expected_source = sp.Matrix(9, 9, lambda i, j:
                                3 * int(i == j) - 2 * int((i - j) % 9 in (0, 3, 6)))
    require(source == expected_source, "payload is not the stated p=3,e=r=2,a=2 case")
    require(left * source * right == diagonal, "Jacobian D=U M V failed")
    require(left.det() == int(certificate["left_determinant"]) in (-1, 1),
            "Jacobian left matrix is not unimodular")
    require(right.det() == int(certificate["right_determinant"]) in (-1, 1),
            "Jacobian right matrix is not unimodular")
    factors = [1] * 3 + [3] * 3 + [9] * 3
    require(diagonal == sp.diag(*factors), "Jacobian Smith diagonal differs")
    require(certificate["invariant_factors"] == list(map(str, factors)),
            "Jacobian invariant-factor list differs")
    require(certificate["rank"] == 9, "Jacobian rank differs")
    return {
        "operation_id": operation,
        "server_version": data["server"]["version"],
        "protocol_version": data["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "timeout": False,
        "runtime_ms": result["runtime_ms"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "independent_exact_relation": "D=U*M*V; det(U),det(V) in {-1,1}",
        "invariant_factors": factors,
        "scope": "one finite order; not the all-parameter theorem",
    }


def check_formal(certificate_path, claim_id, source_name, fidelity_name, declarations):
    certificate = load(certificate_path)
    check = certificate["lean_check"]
    require(certificate["tier"] == "mechanical" and certificate["verdict"] == "supports",
            "not a mechanical supports certificate")
    require(certificate["subject"]["subject_id"] == claim_id,
            "formal evidence belongs to a different claim")
    require(check["status"] == "success", "Lean run did not succeed")
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0,
            "Lean compiler or axiom audit failed")
    require(check["proof_holes"] == [] and check["environment_failure"] == "",
            "Lean run has proof holes or an environment failure")
    require(check["stderr"] == "" and check["audit_stderr"] == "",
            "unexpected Lean stderr")
    require(check["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "wrong Lean toolchain")
    for key, file, hash_key in (
        ("lean_source", HERE / source_name, "source_sha256"),
        ("statement_fidelity", HERE / fidelity_name, "statement_fidelity_sha256"),
    ):
        require(certificate[key]["text"] == file.read_text(), f"stale {key} text")
        require(digest(file) == check[hash_key], f"stale {key} compiler hash")
        runtime_path = Path(check["source" if key == "lean_source" else "statement_fidelity"])
        require(runtime_path.resolve() == (ROOT / certificate[key]["path"]).resolve(),
                f"wrong {key} compiler input")
        require(runtime_path.read_text() == file.read_text(), f"stale {key} runtime snapshot")
    matches = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", check["stdout"])
    require({name for name, _ in matches} == declarations and len(matches) == len(declarations),
            "expected complete printed axiom closures")
    for name, axiom_text in matches:
        require({a.strip() for a in axiom_text.split(",")} == AXIOMS,
                f"unexpected transitive axiom in {name}")
    ledger = load(ROOT / "research/MATH_STATE.json")
    current = [claim for claim in ledger["claims"]
               if claim["claim_id"] == claim_id][-1]
    require(current["content_hash"] == certificate["subject"]["content_hash"],
            "formal certificate is bound to an obsolete claim")
    require(current["formal_statement"] == (HERE / source_name).read_text(),
            "ledger formalization differs from the compiled source")
    require(current["external_assumptions"] == [], "undischarged formal assumptions")
    relative_certificate = str(certificate_path.relative_to(ROOT))
    require(any(e["artifact"] == relative_certificate and e["tier"] == "mechanical"
                and e["verdict"] == "supports" and e["subject"] == certificate["subject"]
                for e in ledger["evidence"]), "mechanical evidence is absent from the ledger")
    return {
        "claim": claim_id,
        "certificate_file": str(certificate_path.relative_to(HERE)),
        "source_sha256": check["source_sha256"],
        "statement_fidelity_sha256": check["statement_fidelity_sha256"],
        "compiler_exit_code": check["exit_code"],
        "axiom_audit_exit_code": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "duration_ms": check["duration_ms"],
        "transitive_axioms": sorted(AXIOMS),
    }


def check_accepted_dependencies():
    accepted = ROOT / "research/odd_square_audit"
    old_certificate = load(accepted / "exact_certificate.json")["formal_verification"]
    manifest_path = accepted / "formal_build_manifest.json"
    require(digest(manifest_path) == old_certificate["dependency_build"]["sha256"],
            "the independently accepted dependency manifest changed")
    manifest = load(manifest_path)
    require(manifest["exit_code"] == 0, "accepted dependency build failed")
    for module in manifest["modules"]:
        for file_key in ("source", "olean"):
            require(digest(accepted / module[file_key]) == module[file_key + "_sha256"],
                    f"accepted dependency changed: {module[file_key]}")
    return len(manifest["modules"])


def eisenstein_checks(p, t, a):
    lam = sp.Rational(1, a)
    degree = p - 1
    h = sp.Poly(sum((1 + Z) ** j for j in range(p)) - p * lam, Z, domain=sp.QQ)
    require(h.degree() == degree and h.LC() == 1, "wrong monic quotient")
    require(h.nth(0) == p * (1 - lam), "wrong constant term")
    require(residue(1 - lam, p) != 0, "nonunit constant multiplier")
    for i in range(degree):
        require(valuation(h.nth(i), p) >= 1 if h.nth(i) else True,
                "non-Eisenstein lower coefficient")
    require(valuation(h.nth(0), p) == 1, "constant term does not have exact valuation one")

    def reduce(poly):
        return sp.Poly(poly, Z, domain=sp.QQ).rem(h)

    unit = sp.Poly(1, Z, domain=sp.QQ)
    for level in range(1, t + 1):
        identity = reduce((1 + Z) ** (p ** level) - 1 -
                          p ** level * lam * Z * unit.as_expr())
        require(identity.is_zero, "all-parameter recurrence failed at an exact instance")
        require(all(rational(c).denominator % p != 0 for c in unit.all_coeffs()),
                "recurrence unit is not p-integral")
        require(residue(unit.nth(0), p) == 1, "recurrence unit is not residue one")
        if level < t:
            w = reduce(lam * Z * unit.as_expr())
            bracket = sp.Poly(1, Z, domain=sp.QQ)
            for j in range(2, p):
                require(sp.binomial(p, j) % p == 0, "binomial divisibility failed")
                bracket += reduce((sp.binomial(p, j) // p) *
                                  p ** (level * (j - 1)) * w.as_expr() ** (j - 1))
            bracket += reduce(p ** (level * (p - 1) - 1) * w.as_expr() ** (p - 1))
            unit = reduce(unit * bracket)

    companion = sp.zeros(degree)
    for j in range(degree - 1):
        companion[j + 1, j] = 1
    for i in range(degree):
        companion[i, degree - 1] = -h.nth(i)
    change = sp.zeros(degree)
    c0 = 1 - lam
    change[degree - 1, 0] = -1 / c0
    for i in range(1, degree):
        change[i - 1, 0] = -h.nth(i) / c0
        change[i - 1, i] = 1
    expected = sp.diag(p ** (t + 1), *([p ** t] * (degree - 1)))
    require(p ** t * companion * change == expected, "coordinate lattice equality failed")
    require(valuation(change.det(), p) == 0, "coordinate change is not locally unimodular")
    require(all(rational(c).denominator % p != 0 for c in change),
            "coordinate change is not p-integral")
    return {
        "h_coefficients_low_to_high": [str(h.nth(i)) for i in range(degree + 1)],
        "V_t_coefficients_low_to_high": [str(unit.nth(i)) for i in range(degree)],
        "power_identity": "(1+Z)^(p^t)-1=p^t*a^(-1)*Z*V_t mod h",
        "lattice_identity": "p^t*C_Z*U=diag(p^(t+1),p^t,...,p^t)",
        "local_change_determinant": str(change.det()),
    }


def family_case(p, t, a):
    require(bool(sp.isprime(p)) and p % 2 == 1 and t >= 1, "invalid prime or gap")
    require(a % p != 0 and (a - 1) % p != 0, "a or a-1 is not a p-local unit")
    order = p ** t
    f = sp.Poly(p - a * sum(Y ** j for j in range(p)), Y, domain=sp.QQ)
    cyclic = sp.Poly(Y ** order - 1, Y, domain=sp.QQ)
    inverse = sp.invert(f, cyclic)
    k = (p ** (t + 1) * inverse).rem(cyclic)
    require((f * k - sp.Poly(p ** (t + 1), Y)).rem(cyclic).is_zero,
            "exact cyclic scalar product failed")
    coefficients = [rational(k.nth(i)) for i in range(order)]
    require(all(q.denominator % p != 0 for q in coefficients), "K is not p-integral")
    minimum_inverse_valuation = min(valuation(c, p) for c in inverse.all_coeffs() if c)
    require(minimum_inverse_valuation == -(t + 1), "scalar-clearing exponent is not sharp")
    phi = sp.Poly(sum(Y ** j for j in range(p)), Y, domain=sp.QQ)
    require(f.rem(phi) == sp.Poly(p, Y, domain=sp.QQ), "F character value differs")
    require(k.rem(phi) == sp.Poly(p ** t, Y, domain=sp.QQ), "K character value differs")
    require(f.eval(1) == p * (1 - a) and k.eval(1) == sp.Rational(p ** t, 1 - a),
            "augmentation differs")
    ratio = sp.Rational(1, 1 - a)
    require(residue(ratio, p) != 1 and residue(1 - a, p) != 1,
            "excluded comparison unexpectedly has residue one")

    integer_coefficients = [int(f.nth(i)) for i in range(order)]
    matrix = sp.Matrix(order, order, lambda i, j: integer_coefficients[(i - j) % order])
    diagonal = smith_normal_form(matrix, domain=sp.ZZ)
    expected_valuations = [0] * (order - p + 1) + [t] * (p - 2) + [t + 1]
    actual_valuations = [valuation(diagonal[i, i], p) for i in range(order)]
    require(actual_valuations == expected_valuations, "full local Smith factors differ")
    require(sum(actual_valuations) == (p - 1) * t + 1, "determinant valuation differs")

    lifts = []
    for r in (1, 2, 3):
        m = p ** (r - 1)
        e = r + t - 1
        n = p ** e
        left = {j * m: Fraction(integer_coefficients[j]) for j in range(p)}
        right = {i * m: c for i, c in enumerate(coefficients) if c}
        require(cyclic_product(left, right, n) == {0: Fraction(p ** (t + 1))},
                "lifted factorization fails in the actual larger cyclic group ring")
        if r > 1:
            projected_f = sum(left.values())
            projected_k = sum(right.values())
            require(projected_f * projected_k == p ** (t + 1),
                    "included lower-conductor endpoint failed")
        lifts.append({
            "e": e, "r": r, "group_order": n, "scalar_exponent": t + 1,
            "smith_multiplicities": {
                "unit": n - (p - 1) * m,
                "p^t": (p - 2) * m,
                "p^(t+1)": m,
            },
        })
    if a == 2 and t == 1:
        require(k == f, "the manuscript's F^2=p^2 case was not recovered")
    return {
        "p": p, "t": t, "a": a,
        "base_group_order": order,
        "K_coefficients_low_to_high": [str(c) for c in coefficients],
        "inverse_minimum_p_valuation": minimum_inverse_valuation,
        "smith_p_valuations": actual_valuations,
        "F_ratio": str(ratio),
        "K_ratio": str(1 - a),
        "F_ratio_residue": residue(ratio, p),
        "K_ratio_residue": residue(1 - a, p),
        "quotient_checks": eisenstein_checks(p, t, a),
        "actual_cyclic_factorization_lifts": lifts,
    }


def build_certificate():
    formal = check_formal(LEAN_CERTIFICATE, "C_SHARP_COMPARISON", "Main.lean",
                          "statement_fidelity.md", DECLARATIONS)
    formal["scope"] = "all-parameter comparison; not the cokernel or novelty claims"
    formal["accepted_dependency_modules_unchanged"] = check_accepted_dependencies()
    lattice = check_formal(
        LATTICE_CERTIFICATE, "C_SHARP_LATTICE_CORE", "CokernelCore.lean", "cokernel_fidelity.md",
        {"SharpCharacterComparison.companion_image_iff",
         "SharpCharacterComparison.scalar_class_annihilator"},
    )
    lattice["scope"] = "exact all-parameter companion-coordinate lattice and scalar annihilator; " \
                       "not the cyclic-ring quotient reduction"
    jacobian = check_jacobian()
    cases = [family_case(p, t, a) for p, t in BASE_PARAMETERS for a in (2, -1, p + 2)]
    return {
        "schema_version": 1,
        "goal": "C_SHARP_BOUNDARY",
        "result_class": "new_theorem_candidate",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "comparison_theorem": "s+r<=e+1 implies both evaluation ratios are residue-one units",
        "cokernel_theorem": "(A/(p^(e-r+2)))^(p^(r-1)) plus "
                            "(A/(p^(e-r+1)))^((p-2)*p^(r-1))",
        "all_parameter_proof": "report.md, Theorems 1 and 2",
        "formal_verification": formal,
        "lattice_formal_verification": lattice,
        "classification_proof_type": "all-parameter mathematical proof; companion-coordinate "
                                     "lattice kernel-certified; quotient reduction not formalized",
        "finite_experiment": {
            "base_cases": len(cases),
            "actual_cyclic_lifts": sum(len(c["actual_cyclic_factorization_lifts"]) for c in cases),
            "maximum_base_matrix_order": max(c["base_group_order"] for c in cases),
            "cases": cases,
        },
        "jacobian": jacobian,
        "manuscript_refutation_found": False,
        "strongest_prior_comparison": "r=1,s=e; smaller s follows by scalar padding",
        "advance_needing_independent_review": "higher conductor range, exact two-exponent "
                                             "cokernel, and scalar-class annihilator",
        "novelty_status": "unmatched_in_bounded_retrieval_not_verified_new",
        "independent_review": "required; not performed by this script",
        "campaign_complete": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    require(load(path) == certificate, "persisted exact certificate differs from replay")
    finite = certificate["finite_experiment"]
    print(json.dumps({
        "status": "verified",
        "formal_comparison": "all parameters; Lean 4.31.0, no proof holes, standard axioms",
        "formal_lattice": "all dimensions and exponents; Lean 4.31.0, no proof holes",
        "family_base_cases": finite["base_cases"],
        "actual_cyclic_lifts": finite["actual_cyclic_lifts"],
        "classification_scope": "all-parameter prose proof plus explicitly finite exact checks",
        "independent_review": "pending",
        "campaign_complete": False,
    }, indent=2))


if __name__ == "__main__":
    main()
