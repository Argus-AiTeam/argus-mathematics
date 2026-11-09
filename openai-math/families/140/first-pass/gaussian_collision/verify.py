#!/usr/bin/env python3
"""Replay exact checks and validate, but do not rerun, the official Lean record."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def equal(actual, expected):
    difference = sp.simplify(actual - expected)
    if difference != 0:
        raise AssertionError(f"Exact identity failed: {difference}")


def covariance_checks():
    cases = []
    for d, q in itertools.product(range(1, 5), range(1, 8)):
        matrices = {
            "coincident": sp.zeros(d, q),
            "rank_one": sp.Matrix(d, q, lambda i, j: (i + 1) * (j - 2)),
            "repeated_columns": sp.Matrix(d, q, lambda i, j: (i + j % 2) % 3 - 1),
            "structured": sp.Matrix(d, q, lambda i, j: ((i + 2) * (j + 3)) % 5 - 2),
        }
        for name, D in matrices.items():
            B = sp.eye(q) + sp.ones(q)
            P = sp.eye(q) - sp.ones(q) / (q + 1)
            equal((B * P - sp.eye(q)).norm(), 0)
            for v in (sp.Rational(1, 9), sp.Integer(1), sp.Rational(7, 3)):
                C = D.T * D + v * B
                Q = sp.eye(d) + D * P * D.T / v
                det_c = C.det()
                equal(det_c, v**q * (q + 1) * Q.det())
                for j in range(1, q + 1):
                    if C[:j, :j].det() <= 0:
                        raise AssertionError("Noise did not regularize the covariance")
                if name == "coincident":
                    equal(det_c, (q + 1) * v**q)
                cases.append({
                    "d": d,
                    "q": q,
                    "type": name,
                    "variance": str(v),
                    "rank": D.rank(),
                    "det_covariance": str(det_c),
                })
    return cases


def symbolic_checks():
    s = sp.Symbol("s", positive=True)
    a, b, c = sp.symbols("a b c", real=True)
    C = sp.Matrix([[a + 2 * s, b + s], [b + s, c + 2 * s]])
    equal(C.det(), a * c - b**2 + 2 * s * (a + c - b) + 3 * s**2)
    D = sp.Matrix(2, 3, sp.symbols("d0:6", real=True))
    B = sp.eye(3) + sp.ones(3)
    P = sp.eye(3) - sp.ones(3) / 4
    equal((D.T * D + s * B).det(),
          s**3 * 4 * (sp.eye(2) + D * P * D.T / s).det())
    y = sp.Symbol("y", real=True)
    for q in range(1, 8):
        B = sp.eye(q) + sp.ones(q)
        equal(B.det(), q + 1)
        equal((B * (sp.eye(q) - sp.ones(q) / (q + 1)) - sp.eye(q)).norm(), 0)
        u = sp.symbols(f"u0:{q}", real=True)
        S = sum(u)
        r = sum(x**2 for x in u) - S**2 / (q + 1)
        equal(y**2 + sum((y - x)**2 for x in u),
              (q + 1) * (y - S / (q + 1))**2 + r)
    return {
        "symbolic_covariance_determinant": str(sp.expand(C.det())),
        "symbolic_sylvester_case": {"d": 2, "q": 3, "free_entries": 6},
        "common_noise_inverse_and_determinant_q": list(range(1, 8)),
        "completed_square_q": list(range(1, 8)),
    }


def normalization_checks():
    v = sp.Symbol("v", positive=True)
    y = sp.Symbol("y", real=True)
    phi = sp.exp(-y**2 / (2 * v)) / sp.sqrt(2 * sp.pi * v)
    checks = []
    for k in range(2, 8):
        integral = sp.integrate(phi**k, (y, -sp.oo, sp.oo))
        target = 1 / (sp.sqrt(k) * sp.sqrt(2 * sp.pi * v)**(k - 1))
        equal(integral, target)
        for m in range(1, 5):
            equal(integral**m,
                  k**(-sp.Rational(m, 2)) *
                  (2 * sp.pi * v)**(-sp.Rational(m * (k - 1), 2)))
            checks.append({"k": k, "m": m, "value": str(sp.simplify(target**m))})
    f0, f1, f2, w0, w1, w2, scale = sp.symbols("f0 f1 f2 w0 w1 w2 scale")
    f, weights = (f0, f1, f2), (w0, w1, w2)
    for p in range(2, 6):
        expanded = sum(
            sp.prod(weights[i] * f[i] for i in indices)
            for indices in itertools.product(range(3), repeat=p)
        )
        equal(expanded, sum(w * z for w, z in zip(weights, f))**p)
        equal(expanded.subs({w: scale * w for w in weights}), scale**p * expanded)
        for mass in (0, sp.Rational(1, 3), sp.Rational(5, 2)):
            equal(expanded.subs({w0: mass, w1: 0, w2: 0}), mass**p * f0**p)
    return {
        "coincident_gaussian_integrals": checks,
        "unnormalized_moment_orders": list(range(2, 6)),
        "tested_masses": ["0", "1/3", "5/2"],
        "omitting_common_noise_is_not_the_manuscript": {
            "q": 2, "correct_determinant_at_D_zero_v_one": 3,
            "incorrect_independent_difference_determinant": 1,
        },
    }


def jacobian_check():
    operation = "matrix.symbolic.determinant.compute"
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    result = output.get("result", {})
    if output.get("error") or result.get("kind") == "error":
        raise AssertionError(f"Jacobian returned a non-conclusion: {output}")
    request = output["request"]
    if (request["operation_id"] != operation or result["operation_id"] != operation
            or request["payload"] != payload):
        raise AssertionError("The typed Jacobian result does not match the saved request")
    value = result.get("output", result.get("result", result))
    determinant = value.get("determinant")
    if determinant is None:
        raise AssertionError("Missing complete typed determinant output")
    variable = sp.Symbol("s")

    def polynomial(poly):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"]) *
            variable**term["exponents"][0] for term in poly["terms"]
        )

    def rational_function(value):
        if value["variables"] != ["s"]:
            raise AssertionError("Unexpected symbolic variables in the typed operation")
        return polynomial(value["numerator"]) / polynomial(value["denominator"])

    matrix = sp.Matrix([
        [rational_function(value) for value in row]
        for row in payload["matrix"]["entries"]
    ])
    D = sp.Matrix([[1, 2]])
    covariance = D.T * D + variable * (sp.eye(2) + sp.ones(2))
    equal((matrix - covariance).norm(), 0)
    exact = rational_function(determinant)
    equal(exact, matrix.det())
    equal(exact, 3 * variable**2 + 6 * variable)
    return {
        "operation_id": operation,
        "server": output["server"],
        "protocol_version": output["protocol_version"],
        "transport": output["transport"],
        "adapter_status": "completed",
        "typed_determinant": str(sp.expand(exact)),
        "payload_file": "jacobian_payload.json",
        "output_file": "jacobian_output.json",
        "scope": "one rank-deficient d=1,q=2 covariance, symbolic variance",
    }


def formal_record():
    result = json.loads((ROOT / "lean_check.json").read_text())
    source = (ROOT / "Main.lean").read_bytes()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    source_digest = hashlib.sha256(source).hexdigest()
    fidelity_digest = hashlib.sha256(fidelity.encode("utf-8")).hexdigest()
    version = result["tools"]["lean"]["version"]
    if (result["status"] != "success" or result["exit_code"] != 0
            or result["proof_holes"] != [] or result["audit_exit_code"] != 0
            or "version 4.31.0," not in version):
        raise AssertionError("The official compiler and axiom-audit record is not a pass")
    if (source_digest != result["source_sha256"]
            or fidelity_digest != result["statement_fidelity_sha256"]):
        raise AssertionError("Source or statement fidelity changed after official compilation")

    invocation = json.loads((ROOT / "lean_verify_output.json").read_text())
    recorded = invocation["kernel"]["recorded"]
    if (invocation["kernel"]["refusals"] or recorded["tier"] != "mechanical"
            or recorded["verdict"] != "supports"):
        raise AssertionError("No admissible claim-bound mechanical certificate was recorded")
    campaign = ROOT.parent.parent
    archive_path = (campaign / recorded["artifact"]).resolve()
    if not archive_path.is_relative_to(ROOT):
        raise AssertionError("The recorded certificate lies outside the assigned evidence directory")
    archive = json.loads(archive_path.read_text())
    state = json.loads((campaign / "research" / "MATH_STATE.json").read_text())
    claim = max(
        (claim for claim in state["claims"]
         if claim["claim_id"] == "GC_EXACT_VERIFICATION"),
        key=lambda claim: claim["version"],
    )
    if (recorded["subject"]["subject_id"] != claim["claim_id"]
            or archive["subject"] != recorded["subject"]
            or archive["subject"]["content_hash"] != claim["content_hash"]
            or claim["formal_statement"].strip() != source.decode("utf-8").strip()
            or claim["external_assumptions"]):
        raise AssertionError("The certificate does not bind the current unconditional claim")
    archived_result = archive["lean_check"]
    if (archive["tier"] != "mechanical" or archive["verdict"] != "supports"
            or archive["lean_source"]["text"] != source.decode("utf-8")
            or archive["statement_fidelity"]["text"] != fidelity
            or archived_result["status"] != "success"
            or archived_result["exit_code"] != 0
            or archived_result["proof_holes"] != []
            or archived_result["audit_exit_code"] != 0
            or archived_result["source_sha256"] != source_digest
            or archived_result["statement_fidelity_sha256"] != fidelity_digest):
        raise AssertionError("The archived certificate does not certify the current source and reading")
    return {
        "claim_id": claim["claim_id"],
        "source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "certificate": str(archive_path.relative_to(ROOT)),
        "lean_version": version,
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "source_sha256": source_digest,
        "statement_fidelity_sha256": fidelity_digest,
        "compiler_rerun_by_this_script": False,
        "fidelity_and_novelty_require_independent_review": True,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write the computed certificate")
    args = parser.parse_args()
    certificate = {
        "result_class": "independent_verification",
        "counterexample_to_staged_manuscript": False,
        "mathematical_novelty_claimed": False,
        "finite_checks_are_uniform_proof": False,
        "uniform_proof": formal_record(),
        "symbolic": symbolic_checks(),
        "normalization": normalization_checks(),
        "cases": covariance_checks(),
        "jacobian": jacobian_check(),
    }
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        if certificate != json.loads(path.read_text()):
            raise AssertionError("Stored certificate differs from exact replay")
    print(json.dumps({
        "status": "pass", "rational_covariance_cases": len(certificate["cases"]),
        "coincident_integrals": len(certificate["normalization"]["coincident_gaussian_integrals"]),
        "jacobian": certificate["jacobian"]["adapter_status"],
        "official_lean_record_fresh": True,
        "compiler_rerun_by_this_script": False,
    }))


if __name__ == "__main__":
    main()
