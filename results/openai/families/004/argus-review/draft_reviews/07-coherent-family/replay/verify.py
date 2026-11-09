#!/usr/bin/env python3
"""Replay universal identities and the retained integral switch certificate."""

import copy
import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
P = sp.Symbol("p", nonzero=True)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def matrix(entries):
    def entry(value):
        if isinstance(value, int):
            return sp.Integer(value)
        if value == "p":
            return P
        if value == "-p":
            return -P
        raise ValueError(f"Unsupported certificate entry: {value!r}")

    return sp.Matrix([[entry(value) for value in row] for row in entries])


def equal(actual, expected, message):
    require(actual.shape == expected.shape, f"{message}: dimensions")
    require(
        all(sp.cancel(value) == 0 for value in actual - expected),
        message,
    )


def check_universal_identities():
    f, a, ell = sp.symbols("f a ell")
    finite = a * f - (ell + 1)
    singular = a - (ell + 1) * f
    quotient, remainder = sp.div(
        (f - a) * finite - singular, f**2 - a * f + ell, f
    )
    require(quotient == a and remainder == 0, "exact Frobenius identity")

    s, z, n, derivative, norm = sp.symbols("s z n derivative norm")
    invariant = (
        (s - 1) * derivative + norm - n - (n - 1) * (z - 1)
    )
    next_invariant = invariant.subs(
        {
            derivative: derivative + n * z,
            norm: norm + z,
            n: n + 1,
            z: s * z,
        },
        simultaneous=True,
    )
    require(
        sp.expand(next_invariant - invariant) == 0,
        "cyclic derivative induction step for arbitrary order",
    )
    require(
        invariant.subs({derivative: 0, norm: 0, n: 0, z: 1}) == 0,
        "cyclic derivative induction base",
    )

    b, k = sp.symbols("b k", integer=True)
    q = 1 + 2 * b * k
    require(sp.expand(1 - q - b * (-2 * k)) == 0, "Fox differential clearing")
    require(
        sp.expand(q * (q - 1) / 2 - b * k * q) == 0,
        "Fox pure-tame coefficient clearing",
    )
    ell = 2 * b * k - 1
    require(
        sp.expand(ell * (ell + 1) / 2 - b * k * ell) == 0,
        "extra precision clears the half factor without a new multiplier",
    )

    h, x, j = sp.symbols("h x j")
    require(
        sp.expand(h * (h * x) - h**2 * x) == 0,
        "one simultaneous h-squared clearing",
    )
    require(
        sp.expand(h * (h * x) - h**3 * j - h**2 * (x - h * j)) == 0,
        "sharp natural-clearing divisibility identity",
    )


def check_diamond(certificate):
    data = certificate["diamond"]
    d0 = matrix(data["strict_differential"])
    boundary = matrix(data["local_boundary"])
    dr = matrix(data["relaxed_differential"])
    pf = matrix(data["finite_pair"])
    ps = matrix(data["singular_pair"])
    k1 = matrix(data["relative_one"])
    k2 = matrix(data["relative_two"])
    i1 = matrix(data["inverse_one"])
    i2 = matrix(data["inverse_two"])
    homotopy = matrix(data["homotopy"])
    lift = matrix(data["local_duality_lift"])
    local_pair = matrix(data["local_pair"])
    involution = matrix(data["J"])
    equal(dr, d0.row_join(boundary), "the same strict complex and boundary")

    df = dr[:, [0, 1, 2, 3]]
    ds = dr[:, [0, 1, 4, 5]]
    equal(k2 * dr, d0.T * k1, "relative duality is a chain map")
    equal(dr * i1, i2 * d0.T, "relative inverse is a chain map")
    equal(k1 * i1, sp.eye(4), "relative left inverse in degree one")
    equal(k2 * i2, sp.eye(2), "relative left inverse in degree two")
    equal(
        sp.eye(6) - i1 * k1,
        homotopy * dr,
        "relative integral contraction in degree one",
    )
    equal(
        sp.eye(4) - i2 * k2,
        dr * homotopy,
        "relative integral contraction in degree two",
    )
    equal(pf * df + (pf * df).T, sp.zeros(4), "finite signed duality")
    equal(ps * ds + (ps * ds).T, sp.zeros(4), "singular signed duality")
    equal(k1[:, [0, 1, 2, 3]], -pf.T, "finite comparison in degree one")
    equal(k1[:, [0, 1, 4, 5]], -ps.T, "singular comparison in degree one")
    equal(k2, pf[:2, :], "finite comparison in degree two")
    equal(k2, ps[:2, :], "singular comparison in degree two")
    equal(lift, k1[:, 2:], "the local duality lift is retained")
    equal(
        lift.T * boundary + boundary.T * lift,
        local_pair,
        "the actual local duality defect",
    )

    weil = sp.Matrix([[0, 1], [-1, 0]])
    equal(involution**2, sp.eye(2), "J is an involution")
    require(involution.det() == -1, "J is anti-symplectic, not symplectic")
    equal(involution.T * weil * involution, -weil, "conjugate-Weil convention")
    cross = weil * involution
    equal(local_pair[:2, 2:], cross, "finite-singular cross pairing")
    equal(local_pair[2:, :2], cross.T, "singular-finite cross pairing")
    equal(local_pair[:2, :2], sp.zeros(2), "finite plane isotropy")
    equal(local_pair[2:, 2:], sp.zeros(2), "singular plane isotropy")
    require(local_pair.det() in (-1, 1), "integral local perfect pairing")

    zf = matrix([data["finite_class"]]).T
    zs = matrix([data["singular_class"]]).T
    lf = matrix([data["finite_functional"]])
    ls = matrix([data["singular_functional"]])
    equal(df * zf, sp.zeros(4, 1), "old class is an actual cycle")
    equal(ds * zs, sp.zeros(4, 1), "new class is an actual cycle")
    equal(lf, -zf.T * pf, "old functional uses the retained duality")
    equal(ls, -zs.T * ps, "new functional uses the retained duality")
    equal(lf * df, sp.zeros(1, 4), "old functional is closed")
    equal(ls * ds, sp.zeros(1, 4), "new functional is closed")
    old_local = zf[2:4, :]
    new_local = zs[2:4, :]
    equal(old_local, sp.Matrix([P, 0]), "arbitrary nonprimitive old localization")
    equal(new_local, involution * old_local, "singular switch identity")
    require(old_local != sp.zeros(2, 1), "nonzero generic localization")

    rf = sp.Matrix.hstack(zf, sp.eye(4)[:, 0], sp.eye(4)[:, 3], sp.eye(4)[:, 2])
    rs = sp.Matrix.hstack(zs, sp.eye(4)[:, 1], sp.eye(4)[:, 3], sp.eye(4)[:, 2])
    lf_change = sp.eye(4)[[0, 3, 1, 2], :]
    ls_change = sp.eye(4)[[1, 2, 0, 3], :]
    for change in (rf, rs, lf_change, ls_change):
        require(change.det() in (-1, 1), "normalization is integral unimodular")
    equal(lf_change * df * rf, sp.diag(0, P, P, 1), "finite integral normal form")
    equal(
        ls_change * ds * rs,
        sp.diag(0, -P, P, -1),
        "singular integral normal form",
    )
    normal_pf = rf.T * pf * lf_change.T
    normal_ps = rs.T * ps * ls_change.T
    for normal_pair in (normal_pf, normal_ps):
        equal(normal_pair[3:, :], sp.zeros(1, 4), "duality kills the unit disk")
        equal(normal_pair[:, 3:], sp.zeros(4, 1), "unit disk has no duality defect")
        require(
            normal_pair[:3, :3].det() in (-1, 1),
            "plane duality is perfect after the integral disk contraction",
        )

    require(d0.rank() == 2 and dr.rank() == 4, "strict and relaxed generic ranks")
    require(df.rank() == ds.rank() == 3, "rank-one generic plane cohomology")
    equal(d0[:2, :], sp.zeros(2), "strict free cokernel has rank two")
    equal(d0[2:, :], -P * weil, "two strict torsion factors p are retained")
    require(data["strict_torsion_copies"] == 2, "strict torsion is not discarded")

    uf = sp.cancel(zf[1] * lf[0] / df.adjugate()[1, 0])
    us = sp.cancel(zs[0] * ls[1] / ds.adjugate()[0, 1])
    equal(uf * df.adjugate(), zf * lf, "old determinant tensor in the based lattice")
    equal(us * ds.adjugate(), zs * ls, "new determinant tensor in the based lattice")
    for name, actual in (("finite_coordinate", uf), ("singular_coordinate", us)):
        proposed = data[name]["numerator"] / P ** data[name]["denominator_power"]
        require(sp.cancel(actual - proposed) == 0, f"{name}: exact coordinate")
    require(
        sp.cancel(us / uf) == data["coordinate_ratio"] == -1,
        "determinant ratio is an integral unit for arbitrary p",
    )
    return df, uf, us


def check_jacobian(certificate, df):
    info = certificate["jacobian"]
    payload = json.loads((HERE / info["payload"]).read_text())
    output = json.loads((HERE / info["typed_output"]).read_text())
    require(info["adapter_exit_code"] == 0, "Jacobian adapter exit status")
    require(info["adapter_status"] == "completed", "Jacobian adapter completion")
    require(info["structured_error"] is None, "no Jacobian error is mathematical evidence")
    require(output["server"]["version"] == info["server_version"], "Jacobian version")
    require(output["protocol_version"] == info["protocol_version"], "Jacobian protocol")
    require(output["request"]["operation_id"] == info["operation_id"], "Jacobian operation")
    require(output["request"]["payload"] == payload, "exact Jacobian payload retained")
    result = output["result"]
    require(result["operation_id"] == info["operation_id"], "Jacobian typed operation")
    result = result["output"]
    require(result["exactness"] == "EXACT_INTEGER", "Jacobian exactness")
    require(result["completeness"] == "FULL_MATRIX_TRANSFORMATIONS", "Jacobian completeness")
    proof = result["certificate"]

    def integer_matrix(item):
        require(item["domain"] == "ZZ", "integer certificate domain")
        value = sp.Matrix([[int(x) for x in row] for row in item["entries"]])
        require(value.shape == (item["row_count"], item["column_count"]), "typed dimensions")
        return value

    source = integer_matrix(proof["source"])
    left = integer_matrix(proof["left_transformation"])
    right = integer_matrix(proof["right_transformation"])
    diagonal = integer_matrix(proof["diagonal"])
    equal(source, df.subs(P, info["parameter"]), "Jacobian uses this torsion model")
    equal(source, integer_matrix(payload["matrix"]), "Jacobian source equals payload")
    equal(left * source * right, diagonal, "independent Smith transformation replay")
    require(left.det() == int(proof["left_determinant"]) in (-1, 1), "Smith left unit")
    require(right.det() == int(proof["right_determinant"]) in (-1, 1), "Smith right unit")
    require(proof["rank"] == source.rank() == 3, "Smith rank")
    require([int(x) for x in proof["invariant_factors"]] == [1, 8, 8], "Smith torsion")
    equal(diagonal, sp.diag(1, 8, 8, 0), "Smith canonical diagonal")


def check_lean(certificate):
    info = certificate["lean"]
    result = json.loads((HERE / info["result"]).read_text())
    require(result["status"] == "success", "fresh real Lean compiler result")
    require(result["exit_code"] == info["required_exit_code"] == 0, "Lean exit status")
    require(result["audit_exit_code"] == 0, "Lean axiom audit")
    require(result["proof_holes"] == info["required_proof_holes"] == [], "Lean proof holes")
    require(
        f"version {info['required_version']}," in result["tools"]["lean"]["version"],
        "Lean 4.31.0",
    )
    source = HERE / info["source"]
    fidelity = HERE / info["statement_fidelity"]
    require(Path(result["source"]) == source, "Lean source path")
    require(Path(result["statement_fidelity"]) == fidelity, "Lean fidelity path")
    require(
        hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
        "compiler record matches the current source",
    )
    require(
        hashlib.sha256(fidelity.read_bytes()).hexdigest()
        == result["statement_fidelity_sha256"],
        "compiler record matches the current statement reading",
    )
    recorded = json.loads((HERE / info["claim_record"]).read_text())["kernel"]
    require(recorded["refusals"] == [], "compiler evidence was recorded without refusal")
    evidence = recorded["recorded"]
    require(evidence["subject"]["subject_id"] == info["claim"], "compiler core-claim binding")
    archive = json.loads((ROOT / evidence["artifact"]).read_text())
    require(archive["lean_check"] == result, "archived compiler answer")
    require(archive["lean_source"]["text"] == source.read_text(), "archived formal statement")
    require(
        archive["statement_fidelity"]["text"] == fidelity.read_text(),
        "archived statement reading",
    )


def check_negative_controls(certificate):
    mutations = []
    bad = copy.deepcopy(certificate)
    bad["diamond"]["singular_functional"] = [0, -2, 0, 0]
    mutations.append(("rescaled functional", bad))
    bad = copy.deepcopy(certificate)
    bad["diamond"]["strict_differential"][3][0] = 1
    mutations.append(("discarded strict torsion", bad))
    bad = copy.deepcopy(certificate)
    bad["diamond"]["J"] = [[1, 0], [0, 1]]
    mutations.append(("wrong conjugation orientation", bad))
    bad = copy.deepcopy(certificate)
    bad["diamond"]["finite_coordinate"]["denominator_power"] = 0
    mutations.append(("cohomology-only determinant coordinate", bad))
    for name, bad in mutations:
        try:
            check_diamond(bad)
        except AssertionError:
            continue
        raise AssertionError(f"Negative control was not rejected: {name}")
    return len(mutations)


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    manuscript = (ROOT / certificate["source"]["path"]).read_text()
    for label in certificate["source"]["labels"]:
        require(f"\\label{{{label}}}" in manuscript, f"source label {label}")
    report = (HERE / certificate["report"]).read_text()
    for label in ("rd:local-model", "rd:derivative", "rd:det-switch"):
        require(label in report, f"report source binding {label}")
    require(
        certificate["independent_review"] == "pending_host_reviewer",
        "this engineer certificate cannot invent an independent review",
    )
    check_universal_identities()
    df, uf, us = check_diamond(certificate)
    check_jacobian(certificate, df)
    check_lean(certificate)
    rejected = check_negative_controls(certificate)
    print(
        json.dumps(
            {
                "status": "PASS",
                "universal_symbolic_identities": True,
                "coherent_integral_dualities_and_torsion": True,
                "arbitrary_nonzero_parameter": "p",
                "determinant_coordinates": {"finite": str(uf), "singular": str(us)},
                "unit_ratio": "-1",
                "natural_clearing": "h^2; sharp in the stated naturality category",
                "negative_controls_rejected": rejected,
                "lean": "4.31.0, exit_code=0, proof_holes=[]; current source and fidelity",
                "arithmetic_applicability": "conditional on the report's explicit inputs",
                "independent_review": "pending_host_reviewer",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
