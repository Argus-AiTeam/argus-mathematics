#!/usr/bin/env python3
"""Exact symbolic replay plus source-bound Lean evidence, not a GMT checker."""

import argparse
import copy
import hashlib
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def exact(value):
    expression = sp.sympify(value)
    require(not expression.has(sp.Float), "Inexact number in certificate")
    require(not expression.free_symbols, "Nonconstant example parameter")
    return expression


def zero(expression, label):
    entries = list(expression) if isinstance(expression, sp.MatrixBase) else [expression]
    for entry in entries:
        require(sp.simplify(entry) == 0, f"{label}: nonzero residual {entry}")


def symbolic_identities():
    C, S, r, b = sp.symbols("C S r b", real=True)
    f, g, p, q, j, ell, t = sp.symbols("f g p q j ell t", real=True)
    vectors = [sp.eye(7)[:, i] for i in range(7)]
    a, N, x, w, k, u, _ = vectors
    gram = sp.zeros(7)
    for i in range(7):
        for n in range(i, 7):
            gram[i, n] = gram[n, i] = sp.Symbol(f"G{i}{n}", real=True)
    for i in range(3):
        gram[i, i] = 1
    for n, value in enumerate([g, f, p, q, j, ell], start=1):
        gram[0, n] = gram[n, 0] = value
    for n in range(2, 7):
        gram[1, n] = gram[n, 1] = 0

    def dot(v, z):
        return (v.T * gram * z)[0]

    def boost(v):
        return v + (C - 1) * dot(a, v) * a

    D = C - S * g
    numerator = boost(N) - S * a
    normal = numerator / D

    def transport(v):
        return boost(v) + S * dot(a, v) * normal

    height = (b + r * S * f) / D
    Y = r * transport(x) + b * normal
    z = boost(x) + b * S * a
    time = C * b + S * f
    Nt, xt = N + t * k, x + t * w
    normal_t = (boost(Nt) - S * a) / (C - S * dot(a, Nt))
    Yt = r * (boost(xt) + S * dot(a, xt) * normal_t) + b * normal_t

    identities = {
        "boost_square": boost(boost(w)) - w - S**2 * p * a,
        "boost_inner": dot(boost(w), boost(u)) - dot(w, u) - S**2 * p * j,
        "normal_norm_residual_factor": (
            dot(numerator, numerator) - D**2
            - (C**2 - S**2 - 1) * (g**2 - 1)
        ),
        "normal_unit": dot(normal, normal) - 1,
        "transport_perpendicular": dot(transport(w), normal),
        "transport_isometry": dot(transport(w), transport(u)) - dot(w, u),
        "lorentz_norm": dot(z, z) - time**2 - dot(x, x) + b**2,
        "inverse_space": boost(z) - S * time * a - x,
        "inverse_height": C * time - S * dot(a, z) - b,
        "contact_inverse": boost(r * x + height * N) - S * height * a - Y,
        "target_unit": dot(Y, Y) - 1,
        "normal_quotient_derivative": (
            normal_t.diff(t).subs(t, 0) - transport(k) / D
        ),
        "target_full_derivative": (
            Yt.diff(t).subs(t, 0) - transport(r * w + height * k)
        ),
    }
    for name, expression in identities.items():
        entries = list(expression) if isinstance(expression, sp.MatrixBase) else [expression]
        for entry in entries:
            require(not entry.has(sp.Float), f"{name}: inexact symbolic expression")
            num = sp.fraction(sp.cancel(entry))[0]
            remainder = sp.rem(sp.expand(num), C**2 - S**2 - 1, C)
            remainder = sp.rem(sp.expand(remainder), r**2 + b**2 - 1, r)
            require(sp.expand(remainder) == 0, f"{name}: residual {remainder}")
    return list(identities)


def sparse_polynomial(data):
    require(data["domain"] == "QQ", "Jacobian polynomial has wrong coefficient ring")
    variables = [sp.Symbol(name) for name in data["variables"]]
    result = sp.S.Zero
    for term in data["polynomial"]["terms"]:
        coefficient = term["coefficient"]
        require(len(term["exponents"]) == len(variables), "Wrong monomial arity")
        result += sp.Rational(coefficient["num"], coefficient["den"]) * sp.prod(
            v**power for v, power in zip(variables, term["exponents"])
        )
    return sp.expand(result)


def check_jacobian(certificate):
    spec = certificate["jacobian"]
    payload = json.loads((HERE / spec["payload"]).read_text())
    response = json.loads((HERE / spec["result"]).read_text())
    require(response["request"]["payload"] == payload, "Adapter payload mismatch")
    require(response["server"]["version"] == spec["server_version"], "Server mismatch")
    require(response["protocol_version"] == spec["protocol_version"], "Protocol mismatch")
    require(response["result"]["operation_id"] == spec["operation_id"], "Operation mismatch")
    require(spec["adapter_exit_code"] == 0 and not spec["timed_out"], "Adapter failed")
    require(spec["error"] is None, "Adapter error is not mathematical evidence")
    output = response["result"]["output"]
    require(output["status"] == spec["typed_status"] == "FACTORIZED", "No factorization")
    require(output["product_reconstruction"] == "EXACT", "Incomplete reconstruction")
    require(output["normalization"] == "CONTENT_AND_MONIC_IRREDUCIBLES", "Wrong normalization")
    polynomial = sparse_polynomial(payload["polynomial"])
    C, S, g = sp.symbols("C S g")
    zero(polynomial - (C**2 - S**2 - 1) * (g**2 - 1), "normal-norm polynomial")
    coefficient = output["coefficient"]
    reconstructed = sp.Rational(coefficient["num"], coefficient["den"])
    for factor in output["factors"]:
        reconstructed *= sparse_polynomial(factor["factor"]) ** factor["multiplicity"]
    zero(reconstructed - polynomial, "Jacobian exact factor product")
    zero(sparse_polynomial(output["reconstructed"]) - polynomial, "Jacobian retained source")


def check_lean(certificate):
    source = (HERE / certificate["lean_source"]).read_text(encoding="utf-8")
    fidelity = (HERE / certificate["statement_fidelity"]).read_text(encoding="utf-8")
    archive = json.loads((HERE / certificate["lean_archive"]).read_text())
    answer = archive["lean_check"]
    require(answer["status"] == "success", "Lean compiler did not succeed")
    require(answer["exit_code"] == 0 and answer["audit_exit_code"] == 0, "Lean failed")
    require(answer["proof_holes"] == [], "Lean proof has holes")
    require(answer["environment_failure"] == "", "Unverified Lean environment")
    require("version 4.31.0," in answer["tools"]["lean"]["version"], "Wrong Lean version")
    require(
        answer["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(),
        "Lean source changed after compilation",
    )
    require(
        answer["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
        "Statement fidelity changed after compilation",
    )
    require(archive["lean_source"]["text"] == source, "Archive contains another source")
    require(archive["subject"]["subject_id"] == certificate["algebra_claim_id"], "Wrong claim")
    require(archive["verdict"] == "supports" and archive["tier"] == "mechanical", "Wrong evidence")
    require({
        "lorentz_contact_core", "target_jet_shape", "psd_determinant_bounds",
        "contact_matrix_metric_jacobian_bounds",
    }.issubset(certificate["lean_obligations"]), "Missing load-bearing formal obligations")
    for name in certificate["lean_obligations"]:
        require(f"theorem {name}" in source, f"Missing formal obligation: {name}")
        require(f"`{name}`" in fidelity, f"Undocumented formal obligation: {name}")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [
        item for item in state["claims"]
        if item["claim_id"] == certificate["algebra_claim_id"]
    ]
    require(bool(claims), "Formal claim is absent from the ledger")
    claim = max(claims, key=lambda item: item["version"])
    require(archive["subject"]["content_hash"] == claim["content_hash"], "Stale claim version")
    require(claim["formal_statement"] == source, "Ledger formalization differs from source")
    return archive["evidence_id"]


def check_examples(certificate):
    a = sp.Matrix([1, 0, 0, 0])
    x = sp.ones(4, 1) / 2
    N = sp.Matrix([1, 1, -1, -1]) / 2
    zero(x.dot(x) - 1, "Clifford position unit")
    zero(N.dot(N) - 1, "Clifford normal unit")
    zero(x.dot(N), "Clifford orthogonality")
    require(len(certificate["examples"]) == 5, "Missing geometric example")
    results = []
    for data in certificate["examples"]:
        C, S, r, b = [exact(data[key]) for key in ["C", "S", "r", "b"]]
        label = data["id"]
        require(C >= 1 and S >= 0 and r > 0 and -1 < b < 1, f"{label}: bad parameters")
        zero(C**2 - S**2 - 1, f"{label}: hyperbola")
        zero(r**2 + b**2 - 1, f"{label}: level radius")
        B = sp.eye(4) + (C - 1) * a * a.T
        D = C - S * a.dot(N)
        require(D > 0, f"{label}: nonpositive D")
        h = sp.simplify((b + S * r * a.dot(x)) / D)
        normal = (B * N - S * a) / D

        def transport(w):
            return B * w + S * a.dot(w) * normal

        Y = sp.simplify(r * transport(x) + b * normal)
        z = r * x + h * N
        zero(h - exact(data["expected_h"]), f"{label}: contact height")
        zero(Y - sp.Matrix([exact(value) for value in data["expected_y"]]), f"{label}: Y")
        zero(Y.dot(Y) - 1, f"{label}: target sphere")
        zero(B * Y + b * S * a - z, f"{label}: forward space")
        zero(C * b + S * a.dot(Y) - h, f"{label}: forward height")
        lengths = [sp.sqrt(z[:2, :].dot(z[:2, :])), sp.sqrt(z[2:, :].dot(z[2:, :]))]
        distance = sp.simplify((lengths[0] - lengths[1]) / sp.sqrt(2))
        closest_r = sp.simplify((lengths[0] + lengths[1]) / sp.sqrt(2))
        zero(distance - exact(data["expected_signed_distance"]), f"{label}: signed distance")
        eigenvalues = [sp.simplify(r + h), sp.simplify(r - h)]
        require(len(data["expected_eigenvalues"]) == 2, f"{label}: wrong eigenvalue count")
        for value, expected in zip(eigenvalues, data["expected_eigenvalues"]):
            zero(value - exact(expected), f"{label}: eigenvalue")
        determinant = sp.simplify(sp.prod(eigenvalues))
        zero(determinant - exact(data["expected_determinant"]), f"{label}: determinant")
        require(data["degenerate"] == (determinant == 0), f"{label}: degeneracy")
        if data["genuine_contact"]:
            zero(distance - h, f"{label}: geometric contact sign")
            zero(closest_r - r, f"{label}: closest-ray radius")
            zero((z - r * x).dot(z - r * x) - h**2, f"{label}: nearest distance")
            require(all(value >= 0 for value in eigenvalues), f"{label}: contact is not PSD")
            require(0 <= determinant <= r**2 <= 1, f"{label}: contact density bound")
            if data["degenerate"]:
                require(any(length == 0 for length in lengths), f"{label}: missing nonunique fiber")
        else:
            require(distance != h and closest_r != r, f"{label}: unexpectedly a contact")
            require(any(value < 0 for value in eigenvalues), f"{label}: expected indefinite matrix")
            require(abs(determinant) > r**2, f"{label}: expected unrestricted-bound failure")
            require(b > sp.sqrt(2) / 2, f"{label}: level not certified empty")
        results.append(label)
    return results


def negative_controls(certificate):
    a = sp.Matrix([1, 0, 0, 0])
    x = sp.ones(4, 1) / 2
    N = sp.Matrix([1, 1, -1, -1]) / 2
    w = sp.Matrix([-1, 1, 0, 0]) / sp.sqrt(2)
    C, S = sp.Rational(5, 4), sp.Rational(3, 4)
    B = sp.eye(4) + (C - 1) * a * a.T
    D = C - S * a.dot(N)
    normal = (B * N - S * a) / D

    def transport(vector):
        return B * vector + S * a.dot(vector) * normal

    h = sp.Rational(3, 7)
    normal_jet = transport(w) / D
    actual = B * w + S * a.dot(w) * normal + S * a.dot(x) * normal_jet
    zero(actual - transport((1 + h) * w), "Correct A=-dN derivative")
    require(any(sp.simplify(entry) != 0 for entry in actual - transport((1 - h) * w)),
            "Opposite shape sign was not rejected")
    require(any(sp.simplify(entry) != 0 for entry in actual - transport(w)),
            "Frozen transformed normal was not rejected")
    bad = copy.deepcopy(certificate)
    bad["examples"][0]["expected_h"] = "4/7"
    try:
        check_examples(bad)
    except AssertionError:
        pass
    else:
        raise AssertionError("A mutated geometric certificate was accepted")
    try:
        zero(sp.Integer(1), "intentional failed identity")
    except AssertionError:
        pass
    else:
        raise AssertionError("A nonzero symbolic obligation was accepted")
    expected = [
        "opposite_shape_sign",
        "frozen_transformed_normal",
        "indefinite_noncontact_is_not_a_refutation",
        "mutated_contact_height_is_rejected",
        "nonzero_identity_is_rejected",
    ]
    require(certificate["negative_controls"] == expected, "Missing negative controls")
    return expected


def replay_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--claim", "C349_LORENTZ_ALGEBRA", "--project-root", str(ROOT), "--timeout", "1200",
    ]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
    require(result.returncode == 0, f"Fresh Lean replay failed:\n{result.stdout}\n{result.stderr}")
    answer = json.loads(result.stdout)
    require(answer["exit_code"] == 0 and answer["proof_holes"] == [], "Fresh Lean proof failed")
    require(answer["kernel"]["recorded"] is not None, "Fresh Lean answer was not recorded")
    for module in ["math_state", "proof_graph_check"]:
        subprocess.run(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
             "--project-root", str(ROOT)],
            cwd=ROOT, check=True, stdout=subprocess.DEVNULL,
        )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--replay-lean", action="store_true", help="Run the real official compiler")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["schema_version"] == 1, "Unknown certificate schema")
    require(certificate["claim_id"] == "C349_ALL_LEVELS", "Wrong target claim")
    require(certificate["shape_convention"] == "A=-dN", "Wrong shape convention")
    require(certificate["distance_convention"] == "positive toward N", "Wrong distance sign")
    if args.replay_lean:
        replay_lean()
    identities = symbolic_identities()
    require(identities == certificate["symbolic_obligations"], "Missing symbolic obligation")
    check_jacobian(certificate)
    evidence = check_lean(certificate)
    examples = check_examples(certificate)
    controls = negative_controls(certificate)
    print(json.dumps({
        "status": "success",
        "symbolic_identities": len(identities),
        "lean_evidence": evidence,
        "lean_replayed": args.replay_lean,
        "geometric_examples": examples,
        "negative_controls": controls,
        "GMT": "explicit external assumptions, not machine-checked here",
        "independent_review": "pending",
        "global_volume_theorem": "not certified",
    }, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, KeyError, ValueError, OSError, subprocess.SubprocessError) as error:
        print(f"VERIFICATION FAILED: {error}", file=sys.stderr)
        sys.exit(1)
