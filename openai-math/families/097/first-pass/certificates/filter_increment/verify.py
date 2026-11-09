#!/usr/bin/env python3
"""Replay exact algebra; the analytic theorem is proved in report.md."""

import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def equal(left, right, message):
    if isinstance(left, sp.MatrixBase):
        require(left.shape == right.shape, message + ": shape")
        require(all(sp.cancel(x) == 0 for x in left - right), message)
    else:
        require(sp.cancel(left - right) == 0, message)


def read_json(name):
    return json.loads((ROOT / name).read_text(encoding="utf-8"))


def scalar_certificate(certificate):
    u = sp.symbols("u", real=True)
    forward = (u - 1) ** 2 * (3 * u**2 + 2 * u + 1)
    reverse = (u - 1) ** 2 * (u**2 + 2 * u + 3)
    equal(forward, 3 * u**4 - 4 * u**3 + 1, "forward quartic")
    equal(reverse, u**4 - 4 * u + 3, "reverse quartic")
    for polynomial in (3 * u**2 + 2 * u + 1, u**2 + 2 * u + 3):
        require(all(c >= 0 for c in sp.Poly(polynomial, u).all_coeffs()),
                "nonnegative remainder coefficients")

    q = sp.Rational
    require(q(7, 8) ** 4 > q(1, 2), "small-r root threshold")
    require(q(9, 8) ** 4 < 2, "large-r root threshold")
    require(q(1, 2) ** 4 <= q(1, 2) and 2**4 >= 2,
            "middle-r root thresholds")
    require(sum(2**j for j in range(4)) == 15, "middle Lipschitz factor")
    lower_bounds = [q(1, 192), q(1, 64), q(1, 675), q(1, 81), q(1, 243)]
    require(all(b >= q(1, 1024) for b in lower_bounds),
            "all three remainder regions")

    increment = certificate["manuscript_increment"]
    c = sp.Rational(increment["scalar_comparison_constant"])
    require(c > 0 and c <= q(1, 8 * 1024 * 2304),
            "middle cutoff comparison")
    require(c <= q(1, 8 * 1024 * 5), "outer cutoff comparisons")
    equal(c, q(1, 2**25), "declared scalar constant")
    endpoint = int(increment["endpoint_constant"])
    require(endpoint >= 2 / c + 32, "weighted endpoint triangle constant")
    require(endpoint >= 40, "contraction deficit constant")
    final = int(increment["absolute_constant"])
    require(final >= 64 * endpoint, "final increment constant")
    equal(final, 2**33, "declared increment constant")
    e0 = sp.Rational(increment["energy_threshold"])
    equal(e0, q(1, 24), "energy threshold")
    require((q(3, 2) * e0) ** 2 < q(1, 4) ** 3, "q < 1/4")
    require(q(3, 2) ** 2 <= 2**3, "(3/2)^(2/3) <= 2")
    require(2**7 <= 16**2, "2^(a+2) <= 16")

    r = sp.symbols("r", real=True)
    potential = 2 * (sp.atanh(r) - r)
    delta_derivative = sp.diff(potential - q(2, 3) * r**3, r)
    equal(delta_derivative, 2 * r**4 / (1 - r**2),
          "universal saturated-potential lower bound derivative")
    require(sp.Poly(2 * r**4, r).all_coeffs()[0] > 0,
            "lower-bound numerator positive for 0 <= r < 1")
    coordinate = r**2 / (1 - r**2)
    equal(sp.diff(potential, r) / sp.diff(coordinate, r),
          r * (1 - r**2), "primitive derivative under h=r^2")
    equal((r * (1 - r**2)) / (1 - r**2), r,
          "saturated scalar conjugation")
    equal(sp.diff(q(2, 3) * r**3, r) / (2 * r), r,
          "p derivative below one")
    equal(sp.diff(q(5, 3) - r**-2, r) / (2 * r), r**-4,
          "p derivative above one")
    return {
        "universal_quartic_identities": 2,
        "remainder_regions": 3,
        "potential_derivative_identity": True,
        "explicit_constants_valid": True,
    }


def relative_gain_instance(certificate):
    instance = certificate["relative_gain_instance"]
    z = sp.Matrix(instance["Z"]).applyfunc(sp.Rational)
    v = sp.Matrix(instance["V"]).applyfunc(sp.Rational)
    a = sp.diag(sp.Rational(1, 2), sp.Rational(1, 3)) * v
    a *= sp.diag(sp.Rational(1, 2), sp.Rational(1, 3))
    equal(a, sp.Matrix(instance["A"]).applyfunc(sp.Rational), "relative A")
    require(z * v != v * z, "noncommuting old and new covariances")
    require(v[0, 0] > 0 and v[1, 1] > 0 and v.det() == 0, "gain PSD")
    x = sp.symbols("x")
    spectrum_a = [sp.Rational(x) for x in instance["A_spectrum"]]
    equal(a.charpoly(x).as_expr(), sp.prod(x - l for l in spectrum_a),
          "exact A spectrum")
    j = sp.eye(2) + z + v
    spectrum_h = [sp.Rational(x) for x in instance["H_spectrum"]]
    equal((v - x * j).det(), j.det() * sp.prod(x - l for l in spectrum_h),
          "exact generalized spectrum of H")
    equal(spectrum_h[1], spectrum_a[1] / (1 + spectrum_a[1]),
          "relative spectral normalization")
    return {
        "noncommuting": True,
        "A_spectrum": [str(x) for x in spectrum_a],
        "H_spectrum": [str(x) for x in spectrum_h],
    }


def admissible_filter():
    q = sp.Rational
    identity = sp.eye(2)
    u = sp.Matrix([q(3, 5), q(4, 5)])
    rotation = sp.Matrix([[0, -1], [1, 0]])
    contractions = [
        sp.diag(q(3, 5), 1),
        identity - q(2, 5) * u * u.T,
        rotation * sp.diag(q(5, 13), 1),
    ]
    injections = [
        sp.Matrix([q(4, 5), 0]),
        q(4, 5) * u,
        rotation * sp.Matrix([q(12, 13), 0]),
    ]
    weight = sp.diag(1, 2, q(1, 16), q(1, 32), q(1, 64))
    states = [sp.eye(2).row_join(sp.zeros(2, 3))]
    for i, (c, b) in enumerate(zip(contractions, injections)):
        require(c.det() != 0, "filter contraction invertible")
        equal(c * c.T + b * b.T, identity, "admissible filter identity")
        state = c * states[-1]
        state[:, 2 + i] = b
        equal(state * state.T, identity, "coisometry")
        states.append(state)
    require(contractions[0] * contractions[1] != contractions[1] * contractions[0],
            "noncommuting contractions")
    require(contractions[2] != contractions[2].T, "nonsymmetric contraction")
    count = 0
    for s in range(4):
        old_weight = sp.diag(*[weight[j, j] if j < 2 + s else 0 for j in range(5)])
        new_weight = weight - old_weight
        y = states[s] * weight * states[s].T
        for t in range(s, 4):
            product = identity
            for i in range(s, t):
                product = contractions[i] * product
            rt = states[t]
            x = rt * weight * rt.T
            z = product * y * product.T
            v = x - z
            equal(rt * states[s].T, product, "old-state overlap")
            equal(rt * old_weight * states[s].T, product * y, "weighted overlap")
            equal(rt * old_weight * rt.T, z, "old covariance")
            equal(rt * new_weight * rt.T, v, "new covariance")
            equal(states[s] * new_weight, sp.zeros(2, 5), "new support disjoint")
            transported = sp.zeros(2)
            for i in range(s, t):
                tail = identity
                for j in range(i + 1, t):
                    tail = contractions[j] * tail
                column = tail * injections[i]
                transported += weight[2 + i, 2 + i] * column * column.T
            equal(v, transported, "PSD transported-gain decomposition")
            count += 1
    return {"rational_filter_intervals": count, "all_support_identities_exact": True}


def jacobian_certificate(certificate):
    declared = certificate["jacobian"]
    payload = read_json(declared["payload"])
    output = read_json(declared["typed_output"])
    require(output["protocol_version"] == declared["protocol_version"],
            "Jacobian protocol")
    require(output["server"]["version"] == declared["server_version"],
            "Jacobian server")
    require(output["request"]["operation_id"] == declared["operation_id"],
            "Jacobian operation request")
    require(output["request"]["payload"] == payload, "exact Jacobian payload binding")
    require(output["result"]["operation_id"] == declared["operation_id"],
            "Jacobian operation response")
    materialized = sp.Matrix([
        [sp.Rational(int(x["num"]), int(x["den"])) for x in row]
        for row in payload["matrix"]["entries"]
    ])
    equal(materialized,
          sp.Matrix(certificate["relative_gain_instance"]["A"]).applyfunc(sp.Rational),
          "Jacobian matrix is the relative-gain instance")
    result = output["result"]["output"]
    require(result["matrix"] == payload["matrix"], "Jacobian retained source")
    require(result["claimed_profile"] == payload["claimed_profile"],
            "Jacobian retained spectrum claim")
    require(result["outcome"] == "VALID" and result["valid_complete_rational_spectrum"],
            "Jacobian conclusive valid spectrum")
    require(result["matrix_order"] == result["established_multiplicity_sum"] == 2,
            "Jacobian complete spectrum")
    require(result["first_failed_condition"] is None, "Jacobian no failed condition")
    for entry in result["nullity_ledger"]:
        require(entry["multiplicity_matches"]
                and entry["exact_nullity"] == entry["claimed_multiplicity"] == 1,
                "Jacobian exact nullity")
    require(declared["adapter_exit_code"] == 0 and not declared["timeout"]
            and declared["structured_error"] is None, "adapter execution status")
    return {"jacobian_outcome": "VALID", "jacobian_operation": declared["operation_id"]}


def lean_certificate(certificate):
    evidence = read_json("lean_check.json")
    require(evidence["status"] == "success" and evidence["exit_code"] == 0,
            "real Lean compiler success")
    require(evidence["proof_holes"] == [], "Lean proof holes")
    require(evidence["audit_exit_code"] == 0, "Lean axiom audit")
    require("version 4.31.0," in evidence["tools"]["lean"]["version"],
            "required Lean version")
    for filename, field in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        actual = hashlib.sha256((ROOT / filename).read_bytes()).hexdigest()
        require(actual == evidence[field], "fresh Lean binding: " + filename)
    recorded = read_json("lean_verify_output.json")
    record = recorded["kernel"]["recorded"]
    require(record is not None, "mechanical ledger evidence")
    require(record["subject"]["subject_id"] == certificate["mechanical_claim_id"]
            and record["tier"] == "mechanical" and record["verdict"] == "supports",
            "formal claim and evidence tier")
    declared = certificate["formal_verification"]
    require(record["artifact"] == declared["archived_certificate"],
            "immutable compiler certificate pointer")
    project = ROOT.parents[2]
    archive = json.loads((project / record["artifact"]).read_text(encoding="utf-8"))
    require(archive["lean_check"] == evidence, "archived compiler result")
    require(archive["lean_source"]["text"] == (ROOT / "Main.lean").read_text(),
            "archived Lean source")
    require(archive["statement_fidelity"]["text"]
            == (ROOT / "statement_fidelity.md").read_text(),
            "archived statement reading")
    require(declared["exit_code"] == 0 and declared["proof_holes"] == []
            and declared["axiom_audit_exit_code"] == 0,
            "declared formal verification")
    return {"lean_exit_code": 0, "proof_holes": [], "formal_scope": "C_FILTER_ALGEBRA"}


def main():
    certificate = read_json("exact_certificate.json")
    require(certificate["claim_id"] == "C_FILTER_SATURATING_GAIN", "theorem identity")
    require(certificate["proof_kind"] == "all_dimensional_analytic_proof_with_exact_algebra",
            "proof classification")
    require(not certificate["full_analytic_theorem_kernel_checked"],
            "honest formalization boundary")
    require(not certificate["finite_sampling_used_to_prove_universal_claim"],
            "no sampling substitution")
    validation = certificate["campaign_local_validation"]
    require(Path(validation["project_root"]).resolve() == ROOT.parents[2],
            "campaign-local validation root")
    require(validation["math_state_exit_code"] == validation["proof_graph_exit_code"] == 0,
            "campaign-local check declarations")
    results = {
        "scalar": scalar_certificate(certificate),
        "relative_gain": relative_gain_instance(certificate),
        "filter": admissible_filter(),
        "jacobian": jacobian_certificate(certificate),
        "lean": lean_certificate(certificate),
        "analytic_proof": "report.md, Sections 2-4; independent review required",
    }
    print(json.dumps(results, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
