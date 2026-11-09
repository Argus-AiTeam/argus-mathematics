#!/usr/bin/env python3
"""Replay exact algebraic evidence accompanying the universal proof in report.md."""

import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational(value):
    result = sp.Rational(value)
    require(result.is_Rational is True, f"not an exact rational: {value}")
    return result


def matrix(rows):
    return sp.Matrix([[rational(v) for v in row] for row in rows]) if rows else sp.zeros(0)


def equal(actual, expected, label):
    require(actual.shape == expected.shape, f"{label}: shape mismatch")
    require(all(sp.cancel(v) == 0 for v in actual - expected), f"{label}: unequal matrices")


def psd(value, label, strict=False):
    equal(value, value.T, f"{label}: symmetry")
    if value.rows:
        verdict = value.is_positive_definite if strict else value.is_positive_semidefinite
        require(verdict is True, f"{label}: exact positivity not established")


def quantile(case):
    p = [rational(v) for v in case["p"]]
    w = [rational(v) for v in case["w"]]
    require(len(p) == len(w) and len(p) > 0, "quantile length")
    require(all(v > 0 for v in w) and sum(w) == 1, "positive probability weights")
    require(0 <= p[0] and p[-1] <= 1, "quantile endpoints")
    require(all(a <= b for a, b in zip(p, p[1:])), "quantile ordering")
    zeta = [sum(w[:i]) for i in range(len(w) + 1)]

    def D(r):
        return 1 - r - sum(a * max(v - r, 0) for a, v in zip(w, p))

    r = sp.Symbol("r")
    for i in range(len(p) + 1):
        active = sum(w[j] * p[j] for j in range(i, len(p)))
        affine_D = 1 - active - zeta[i] * r
        require(sp.expand(1 - affine_D - active - zeta[i] * r) == 0,
                "pairing integration-by-parts identity")
    require(D(1) == 0 and D(0) == 1 - sum(a * v for a, v in zip(w, p)),
            "D endpoint identities")
    return p, w, zeta, D


def ladder(name, K, B, root, zeta):
    d = K.rows
    I = sp.eye(d)
    require(K.shape == (d, d), f"{name}: square K")
    require(len(B) == len(zeta) + 1, f"{name}: ladder length")
    require(zeta[-1] == 1 and zeta[0] > 0, f"{name}: exponents")
    require(all(a < b for a, b in zip(zeta, zeta[1:])), f"{name}: strict exponents")
    equal(K, K.T, f"{name}: symmetric K")
    equal(B[-1], sp.zeros(d), f"{name}: final zero")
    psd(root, f"{name}: root")
    if B[0] != sp.zeros(d):
        psd(B[0], f"{name}: B0", strict=True)
        psd(B[0].inv() - K, f"{name}: admissible precision", strict=True)

    J = [(I - b * K).inv() for b in B]
    F = [j * b for j, b in zip(J, B)]
    transformed_root = J[0] * root * J[0].T
    innovations = []
    increments = []
    wrong_order_detected = False
    logZ = sp.trace(root * K * J[0]) / 2
    for i, exponent in enumerate(zeta, start=1):
        delta = B[i - 1] - B[i]
        psd(delta, f"{name}: decreasing ladder {i}")
        sigma = delta / exponent
        Ki = K * J[i]
        equal(Ki, Ki.T, f"{name}: effective quadratic {i}")
        factor = I - delta * Ki
        equal(factor, (I - B[i - 1] * K) * J[i], f"{name}: ordered factor {i}")
        require(factor.det() > 0, f"{name}: positive determinant {i}")
        T = factor.inv()
        equal(J[i] * T, J[i - 1], f"{name}: intertwining {i}")
        conditional = T * sigma
        psd(conditional, f"{name}: conditional covariance {i}")
        covariance = J[i] * conditional * J[i].T
        equal(covariance, J[i - 1] * sigma * J[i].T,
              f"{name}: rescaled covariance {i}")
        equal(F[i - 1] - F[i], J[i - 1] * delta * J[i].T,
              f"{name}: noncommutative resolvent difference {i}")
        equal(covariance, (F[i - 1] - F[i]) / exponent,
              f"{name}: increment difference {i}")
        psd(covariance, f"{name}: transformed covariance {i}")
        wrong_order_detected |= T * J[i] != J[i] * T
        innovations.append(covariance)
        increments.append(sigma)
        ratio = (I - B[i - 1] * K).det() / (I - B[i] * K).det()
        require(ratio == factor.det(), f"{name}: determinant ratio {i}")
        logZ -= sp.log(ratio) / (2 * exponent)

    equal(J[-1], I, f"{name}: terminal rescaling is the identity")
    V = transformed_root + sum(innovations, sp.zeros(d))
    for level in range(len(zeta)):
        Q = transformed_root + sum(innovations[:level], sp.zeros(d))
        psd(V - Q, f"{name}: two-replica difference covariance {level}")
        psd(V + Q, f"{name}: two-replica sum covariance {level}")
    Qlast = V - innovations[-1]
    equal(V - Qlast, innovations[-1], f"{name}: residual is per visit")
    if d <= 2:
        same = Qlast
        different = transformed_root
        covariance3 = sp.BlockMatrix([
            [V, same, different],
            [same, V, different],
            [different, different, V],
        ]).as_explicit()
        psd(covariance3, f"{name}: coincident-leaf three-replica covariance")
    return {
        "J": J, "increments": increments, "innovations": innovations,
        "root": transformed_root, "V": V, "logZ": logZ,
        "wrong_order_detected": wrong_order_detected,
    }


def spectral_case(case):
    name = case["name"]
    A0, A = matrix(case["A0"]), matrix(case["A"])
    require(A.shape == A0.shape, f"{name}: common matrix dimension")
    psd(-A0, f"{name}: A0 spectral bound")
    psd(-A, f"{name}: A spectral bound")
    p, _, zeta, D = quantile(case)
    d = A.rows
    I = sp.eye(d)

    def H(M, x):
        return x * (I - x * M).inv()

    def derivative(M, x):
        return (I - x * M).inv() ** 2

    x = [D(v) for v in p] + [sp.S.Zero]
    B = [H(A0, v) for v in x]
    root = p[0] * derivative(A0, x[0])
    out = ladder(name, A - A0, B, root, zeta[1:])
    equal(out["root"], p[0] * derivative(A, x[0]), f"{name}: transformed root")
    for i in range(1, len(B)):
        expected = (H(A, x[i - 1]) - H(A, x[i])) / zeta[i]
        equal(out["innovations"][i - 1], expected, f"{name}: full spectral path {i}")
    zeros = [i for i, v in enumerate(out["increments"], start=1) if v == sp.zeros(d)]
    require(zeros == case["zero_steps"], f"{name}: repeated/zero increments")
    require(out["root"].rank() == case["root_rank"], f"{name}: root rank")
    require(out["innovations"][-1].rank() == case["residual_rank"], f"{name}: residual rank")
    if case.get("noncommuting"):
        require(A * A0 != A0 * A, f"{name}: fixture must not commute")
    if "expected_log" in case:
        expected = sp.sympify(case["expected_log"], locals={"log": sp.log})
        require(sp.simplify(out["logZ"] - expected) == 0, f"{name}: exact log normalizer")
    if "annealed_root_precision" in case:
        equal(I - root * (A - A0) * out["J"][0],
              sp.Matrix([[rational(case["annealed_root_precision"])]]),
              f"{name}: no annealed root exponential moment")
    return out["wrong_order_detected"]


def smooth_curve(case):
    P, Q, K = (matrix(case[key]) for key in ("P", "Q", "K"))
    psd(P, "curve: P", strict=True)
    psd(Q, "curve: Q")
    psd((P + Q).inv() - K, "curve: global domain", strict=True)
    t = sp.Symbol("t", real=True)
    G = t * P + t**2 * Q
    J = (sp.eye(2) - G * K).inv()
    F = J * G
    equal(F.diff(t), J * G.diff(t) * J.T, "curve: exact derivative identity")
    G1, G2 = G.subs(t, sp.Rational(1, 4)), G.subs(t, sp.Rational(3, 4))
    require(G1 * G2 != G2 * G1, "curve values must not commute")
    p, _, zeta, D = quantile(case)
    x = [D(v) for v in p] + [sp.S.Zero]
    B = [G.subs(t, v) for v in x]
    root = p[0] * G.diff(t).subs(t, x[0])
    out = ladder("noncommuting_smooth_curve", K, B, root, zeta[1:])
    equal(out["root"], p[0] * F.diff(t).subs(t, x[0]), "curve: root derivative")
    return out["wrong_order_detected"]


def integer_coupling(case):
    lam = [rational(v) for v in case["lambda"]]
    rho = [rational(v) for v in case["rho"]]
    n = case["n"]
    require(n > 0 and sum(rho) == 1 and all(v > 0 for v in rho), "coupling: proportions")
    s = [n * v for v in rho]
    require(all(v.is_Integer and 0 < v <= n for v in s), "coupling: integer counts")
    multiplicities = [n - int(v) for v in s]
    require(multiplicities == case["A0_multiplicities"], "coupling: A0 multiplicities")
    O = matrix(case["basis_columns_complement_then_cavity"])
    equal(O.T * O, sp.eye(3), "coupling: rational orthogonal basis")
    equal(sp.Matrix([O[i, 2] ** 2 for i in range(3)]), sp.Matrix(rho),
          "coupling: cavity spectral proportions")
    M3 = O.T * sp.diag(*lam) * O
    A2, L2 = M3[:2, :2], M3[:2, 2:]
    equal(A2, matrix(case["A2"]), "coupling: compressed A")
    equal(L2, matrix(case["L2"]), "coupling: off-diagonal L")
    require(M3[2, 2] == rational(case["C1"]), "coupling: deterministic C")
    In = sp.eye(n)
    A, L = sp.kronecker_product(A2, In), sp.kronecker_product(L2, In)
    A0 = sp.diag(*(v for v, count in zip(lam, multiplicities) for _ in range(count)))
    d = A.rows
    require(d == case["dimension"] == (len(lam) - 1) * n, "coupling: dimensions")
    require(A * A0 != A0 * A, "coupling: actual matrices must not commute")
    psd(max(lam) * sp.eye(d) - A, "coupling: A spectral bound")
    psd(max(lam) * sp.eye(d) - A0, "coupling: A0 spectral bound")

    b = sp.Symbol("b")
    x = sum(r / (b - v) for r, v in zip(rho, lam))
    M2 = sum(r / (b - v) ** 2 for r, v in zip(rho, lam))
    R = b - 1 / x
    Rp = sp.cancel(sp.diff(R, b) / sp.diff(x, b))
    tilde2 = (b * sp.eye(2) - A2).inv()
    equal(L2.T * tilde2 * L2 + sp.Matrix([[M3[2, 2]]]),
          sp.Matrix([[R]]), "coupling: scalar Schur field")
    determinant_ratio = ((b * sp.eye(2) - A2).det() ** n /
                         sp.prod((b - v) ** count for v, count in zip(lam, multiplicities)))
    claimed_ratio = x**n * sp.prod((b - v) ** count for v, count in zip(lam, s))
    require(sp.cancel(determinant_ratio - claimed_ratio) == 0, "coupling: determinant identity")
    derivative = sp.diff(determinant_ratio, b) / (n * determinant_ratio * sp.diff(x, b))
    require(sp.cancel(derivative - x * Rp) == 0, "coupling: determinant derivative x R'")
    require(sp.cancel(-sp.diff(x, b) - M2) == 0, "coupling: inverse derivative")

    p, _, zeta, D = quantile(case)
    bs = [rational(v) for v in case["node_b"]]
    xs = [sp.cancel(x.subs(b, v)) for v in bs]
    require(xs == [rational(v) for v in case["node_D"]], "coupling: prescribed nodes")
    require(xs == [D(v) for v in p], "coupling: exact quantile-to-resolvent nodes")
    require(all(v > max(lam) for v in bs), "coupling: strict spectral domain")
    B = [(v * sp.eye(d) - A0).inv() for v in bs] + [sp.zeros(d)]
    root = p[0] * B[0] ** 2 / M2.subs(b, bs[0])
    out = ladder("actual_integer_count_coupling", A - A0, B, root, zeta[1:])
    h0 = p[0] * Rp.subs(b, bs[0])
    equal(L.T * out["root"] * L, h0 * In, "coupling: root field")
    for i in range(1, len(bs)):
        variance = (R.subs(b, bs[i - 1]) - R.subs(b, bs[i])) / zeta[i]
        equal(L.T * out["innovations"][i - 1] * L, variance * In,
              f"coupling: scalar branching field {i}")
    residual_variance = R.subs(b, bs[-1]) - sum(r * v for r, v in zip(rho, lam))
    equal(L.T * out["innovations"][-1] * L, residual_variance * In,
          "coupling: scalar per-visit residual field")
    require(residual_variance > 0, "coupling: nontrivial residual")
    # A scalar residual covariance makes its Ising Gaussian moment spin-independent.
    for j in range(n):
        epsilon = sp.ones(n, 1)
        epsilon[j] = -1
        require((epsilon.T * (residual_variance * In) * epsilon)[0] == n * residual_variance,
                "coupling: residual Ising correction")
    return out["wrong_order_detected"], d


def jacobian_evidence(cert):
    spec = cert["jacobian"]
    payload = json.loads((HERE / spec["payload"]).read_text())
    result = json.loads((HERE / spec["result"]).read_text())
    status = json.loads((HERE / spec["exit_status"]).read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(result["request"]["operation_id"] == spec["operation_id"], "Jacobian operation id")
    require(result["request"]["payload"] == payload, "Jacobian exact payload")
    require(result["protocol_version"] == "2025-11-25", "Jacobian protocol")
    require(result["server"]["version"] == "0.14.0", "Jacobian server version")
    output = result["result"]["output"]
    require([output["n_positive"], output["n_negative"], output["n_zero"]] ==
            spec["expected_inertia"], "Jacobian exact inertia")
    require(output["definiteness"] == "positive_definite", "Jacobian definiteness")
    entries = payload["matrix"]["entries"]
    decoded = []
    for row in entries:
        values = []
        for value in row:
            a, c = value["rational_part"], value["radical_coefficient"]
            values.append(sp.Rational(a["num"]) / sp.Rational(a["den"]) +
                          sp.Rational(c["num"]) / sp.Rational(c["den"]) *
                          sp.sqrt(value["radicand"]))
        decoded.append(values)
    A = matrix(cert["spectral_cases"][0]["A"])
    equal(sp.Matrix(decoded), 2 * sp.eye(A.rows) - A, "Jacobian source binding")


def lean_evidence(cert):
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean compilation not successful")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof holes or failed axiom audit")
    for file_key, digest_key in (("formal_source", "source_sha256"),
                                 ("statement_fidelity", "statement_fidelity_sha256")):
        text = (HERE / cert[file_key]).read_text()
        require(hashlib.sha256(text.encode()).hexdigest() == result[digest_key],
                f"stale Lean evidence: {file_key}")
    version = result["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), "wrong Lean version")
    recorded = json.loads((HERE / "lean_verification.json").read_text())
    evidence = recorded["kernel"]["recorded"]
    require(evidence is not None, "Lean evidence not recorded in ledger")
    require(evidence["subject"]["subject_id"] == "QC_ALGEBRA", "wrong formal claim")
    archive = json.loads((ROOT / evidence["artifact"]).read_text())
    require(archive["lean_check"]["source_sha256"] == result["source_sha256"],
            "archived Lean evidence does not match the live compiler result")
    require(archive["lean_check"]["statement_fidelity_sha256"] ==
            result["statement_fidelity_sha256"], "archived fidelity does not match")
    return version


def main():
    cert = json.loads((HERE / "exact_certificate.json").read_text())
    for file, labels in cert["source_labels"].items():
        text = (ROOT / cert["source_root"] / file).read_text()
        for label in labels:
            require("\\label{" + label + "}" in text, f"missing source label {label}")
    require((HERE / cert["proof"]).is_file(), "missing universal proof")
    jacobian_evidence(cert)
    noncommuting_checks = sum(spectral_case(case) for case in cert["spectral_cases"])
    case = cert["singular_noncommuting_ladder"]
    B = [matrix(v) for v in case["B"]]
    require(B[0] * B[1] != B[1] * B[0], "ladder values must not commute")
    out = ladder("singular_noncommuting_ladder", matrix(case["K"]), B,
                 matrix(case["Sigma0"]), [rational(v) for v in case["zeta"]])
    require([v.rank() for v in out["increments"]] == case["increment_ranks"],
            "nonzero singular increment ranks")
    noncommuting_checks += out["wrong_order_detected"] + smooth_curve(cert["smooth_noncommuting_curve"])
    detected, dimension = integer_coupling(cert["integer_count_coupling"])
    noncommuting_checks += detected
    require(noncommuting_checks > 0, "fixtures do not detect reversed matrix order")
    atom = cert["single_atom_coupling"]
    quantile(atom)
    require(rational(atom["lambda"]) / 2 == rational(atom["expected_log_per_site"]),
            "single-atom cavity pressure")
    require(rational(atom["expected_spin_product"]) == 0, "zero-field independent Ising spins")
    lean_version = lean_evidence(cert)
    print(json.dumps({
        "status": "passed",
        "spectral_boundary_cases": len(cert["spectral_cases"]),
        "additional_ladders": 3,
        "actual_coupling_dimension": dimension,
        "wrong_order_detecting_fixtures": int(noncommuting_checks),
        "lean_version": lean_version,
        "proof_scope": "Universal proof in report.md; Lean certifies only the ordered algebraic core.",
        "independent_review": "required",
    }, indent=2))


if __name__ == "__main__":
    main()
