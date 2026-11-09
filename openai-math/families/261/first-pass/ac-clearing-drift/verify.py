#!/usr/bin/env python3
"""Exact algebra and scalar bookkeeping for the clearing-drift proof."""

import argparse
import json
from math import isqrt
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
R = sp.Rational
I = sp.I


def reduced(value):
    return sp.cancel(sp.expand(value))


def equal(left, right):
    if isinstance(left, sp.MatrixBase):
        assert left.shape == right.shape
        assert all(reduced(x) == 0 for x in left - right)
    else:
        assert reduced(left - right) == 0


def rational_real(value):
    value = reduced(value)
    assert value.is_Rational, value
    return value


def nonnegative(value):
    assert rational_real(value) >= 0


def square_norm(row):
    return rational_real((row * row.H)[0])


def sqrt_upper(value):
    value = rational_real(value)
    assert value >= 0
    scale = 2**24
    n = isqrt(int(value.p) * scale**2 // int(value.q))
    if n * n * value.q < value.p * scale**2:
        n += 1
    bound = R(n, scale)
    nonnegative(bound**2 - value)
    return bound


def psd_two(matrix, strict=False):
    equal(matrix, matrix.H)
    values = [matrix[0, 0], matrix[1, 1], matrix.det()]
    for value in values:
        value = rational_real(value)
        assert value > 0 if strict else value >= 0


def nonnegative_coefficients(expression, variable):
    x = sp.Symbol("x", nonnegative=True)
    polynomial = sp.Poly(sp.expand(expression.subs(variable, x + 2)), x)
    assert all(coefficient >= 0 for coefficient in polynomial.all_coeffs())


def jacobian_and_noncommuting_inverse():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    contract = json.loads((HERE / "jacobian_inverse_contract.json").read_text())
    discovery = json.loads((HERE / "jacobian_discovery.json").read_text())
    operation = "matrix.inverse.compute"
    assert contract["result"]["operation"]["operation_id"] == operation
    assert any(
        item["operation_id"] == operation
        for item in discovery["result"]["matches"]
    )
    assert response["request"] == {"operation_id": operation, "payload": payload}
    assert response["protocol_version"] == "2025-11-25"
    assert response["server"]["version"] == "0.14.0"
    assert response["result"]["operation_id"] == operation
    assert "error" not in response
    returned = response["result"]["output"]
    assert returned["convention"] == "TWO_SIDED_INVERSE_OVER_QQ"
    integer_matrix = sp.Matrix(payload["matrix"]["entries"]).applyfunc(sp.Integer)
    inverse = sp.Matrix(
        [
            [R(entry["num"], entry["den"]) for entry in row]
            for row in returned["inverse"]["entries"]
        ]
    )
    identity = sp.eye(2)
    equal(integer_matrix * inverse, identity)
    equal(inverse * integer_matrix, identity)

    T = 100 * inverse
    D = integer_matrix / 100 - identity
    L = sp.Matrix([[2, 1], [1, 3]])
    J = L.inv()
    G = L * L
    Q = identity - J * J
    V = identity - Q
    Gprime = L * (identity + D) * L
    normalized_inverse = J * T * J
    equal(Gprime * normalized_inverse, identity)
    equal(normalized_inverse * Gprime, identity)
    equal((Q + D) * T - Q, V * T * D)
    equal(T - identity, -D + D * D * T)
    assert Q * D != D * Q
    assert normalized_inverse != G.inv() * T
    A = sp.trace((G - identity) * G.inv())
    Aprime = sp.trace((Gprime - identity) * normalized_inverse)
    equal(Aprime - A, sp.trace(V * T * D))
    psd_two(Q, strict=True)
    psd_two(Q + D, strict=True)
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "timeout": False,
        "exact_inverse_denominator": 10099,
        "noncommuting_inverse_order_mutation_detected": True,
    }


def dissipative_matrix_replay():
    t = R(1, 25)
    rt = R(1, 5)
    roots = [R(1), R(2), R(3, 2), R(1, 2)]
    p = [value**2 for value in roots]
    real_r = [R(1, 3), R(-1, 2), R(1, 4), R(-2, 3)]
    r = [a + I * b for a, b in zip(real_r, p)]
    M = sp.Matrix([[3, 1, 1, 0], [1, 4, 0, 1],
                   [1, 0, 5, 1], [0, 1, 1, 6]])
    damped = M - t * sp.diag(*r)
    g = damped.inv()
    root_p = sp.diag(*roots)
    S = sp.eye(4) + 2 * I * t * root_p * g * root_p
    equal(S, S.T)
    equal(S * S.H, sp.eye(4))
    equal((g - g.H) / (2 * I), t * g * sp.diag(*p) * g.H)

    core, exterior, x = [0, 1], [2, 3], 2
    survivor, exterior_survivor = [0, 1, 3], [3]
    C = S.extract(exterior, core)
    SB = S.extract(core, core)
    Gamma = C.H * C
    equal(Gamma, sp.eye(2) - SB.H * SB)
    equal(SB.H * Gamma.conjugate() * SB, Gamma - Gamma**2)
    psd_two(Gamma, strict=True)
    epsilon = R(1, 10**12)
    anisotropic = sp.eye(2) + epsilon * sp.Matrix([[0, 1 + I], [1 - I, 0]])
    psd_two(anisotropic, strict=True)
    balance_slack = anisotropic - SB.H * anisotropic.conjugate() * SB
    psd_two(balance_slack, strict=True)
    assert Gamma * anisotropic != anisotropic * Gamma

    ridges = [sp.eye(2), sp.eye(2) / 10**6,
              sp.eye(2) / 10**30, anisotropic]
    conjugation_mutation = False
    completed = 0
    for xi in [-rt, rt]:
        diagonal_change = xi + t * r[x]
        c = -diagonal_change / (rt * (1 + diagonal_change * g[x, x]))
        v = sp.Matrix([rt * g[3, x] * roots[3] / roots[x]])
        old_rows = C.extract([1], [0, 1])
        pivot_row = C.extract([0], [0, 1])
        cross_update = old_rows + c * v * pivot_row

        terminal_value = M[x, x] + xi
        assert terminal_value != 0
        schur = damped.extract(survivor, survivor) - (
            M.extract(survivor, [x]) * M.extract([x], survivor) / terminal_value
        )
        gprime = schur.inv()
        resolvent_update = g.extract(survivor, survivor) + (
            c * rt * g.extract(survivor, [x]) * g.extract([x], survivor)
        )
        equal(gprime, resolvent_update)
        survivor_p = sp.diag(*(roots[i] for i in survivor))
        Sprime = sp.eye(3) + 2 * I * t * survivor_p * gprime * survivor_p
        equal(Sprime * Sprime.H, sp.eye(3))
        Cprime = Sprime.extract([2], core)
        equal(Cprime, cross_update)
        assert Cprime.rank() == 1
        conjugation_mutation |= any(
            reduced(entry) != 0
            for entry in Cprime - (old_rows + c * v * pivot_row.conjugate())
        )
        Gammaprime = Cprime.H * Cprime

        for ridge in ridges:
            G = Gamma + ridge
            Gprime = Gammaprime + ridge
            inverse_G = G.inv()
            inverse_Gprime = Gprime.inv()
            increment = Gammaprime - Gamma
            A = sp.trace(Gamma * inverse_G)
            Aprime = sp.trace(Gammaprime * inverse_Gprime)
            equal(
                Aprime - A,
                sp.trace(ridge * inverse_G * increment * inverse_Gprime),
            )
            pivot_m = rational_real((pivot_row * inverse_G * pivot_row.H)[0])
            cancelled_column = C.H * S.extract(exterior, [x])
            equal(cancelled_column, -SB.H * pivot_row.T)
            norm_squared = rational_real(
                (cancelled_column.H * inverse_G * cancelled_column)[0]
            )
            nonnegative(pivot_m - norm_squared)
            b_squared = rational_real(
                (v.H * old_rows * inverse_G * old_rows.H * v)[0]
            )
            nonnegative(pivot_m / (t * p[x]**2) - b_squared)
            completed += 1
    assert conjugation_mutation
    return {
        "dimension": 4,
        "core_size": 2,
        "ridges": 4,
        "residual_outcomes": 2,
        "exact_replays": completed,
        "post_heat_cross_block_rank": 1,
        "noncommuting_balanced_ridge": True,
        "wrong_conjugation_mutation_detected": True,
        "scope": "exact matrix identities, not an admissible asymptotic prestate family",
    }


def stochastic_row_replay():
    v = sp.Matrix([R(3, 5), R(4, 5), 0, 0])
    q = rational_real((v.H * v)[0])
    Hv = sum(reduced(abs(entry)**4) for entry in v)
    equal(q, 1)
    results = []
    for scale in [R(1, 4), R(1, 20), R(1, 100)]:
        a = scale * sp.Matrix([[1, I / 2]])
        U0 = scale * sp.Matrix([
            [R(1, 3), I / 4], [R(1, 5), I / 6],
            [I / 7, R(1, 4)], [(1 + I) / 8, R(1, 9)],
        ])
        U = a.col_join(U0)
        Q = U.H * U
        A = rational_real(sp.trace(Q))
        m = square_norm(a)
        mi = [square_norm(U0.row(i)) for i in range(4)]
        assert 0 < A < 1
        assert all(value <= m for value in mi)
        b = U0.H * v
        B = sqrt_upper((b.H * b)[0])
        sqrt_m = sqrt_upper(m)
        d = 2 * m + 2 * B * sqrt_m
        assert 0 <= d <= R(1, 2)
        z = sqrt_upper(m * A * Hv)
        J = 4
        Z = 2 * m * sqrt_m + m**2
        expected_A = 0
        expected_P = 0
        expected_D = sp.zeros(2)
        P = m**2 + sum(value**2 for value in mi)
        for c in [-1, 1]:
            W = U0 + c * v * a
            D = W.H * W - Q
            equal(D, (c**2 * q - 1) * a.H * a + c * b * a + c * a.H * b.H)
            expected_D += D / 2
            T = (sp.eye(2) + D).inv()
            mprime = [rational_real((W.row(i) * T * W.row(i).H)[0])
                      for i in range(4)]
            expected_A += (sum(mprime) - A) / 2
            expected_P += (sum(value**2 for value in mprime) - P) / 2
            raw = [square_norm(W.row(i)) - mi[i] for i in range(4)]
            norm = [mprime[i] - square_norm(W.row(i)) for i in range(4)]
            nonnegative(8 * m * z + 2 * m**2 * Hv - sum(value**2 for value in raw))
            nonnegative(6 * J * m * d**2 - sum(value**2 for value in norm))
            equal(sp.trace((Q + D) * T - Q),
                  sp.trace((sp.eye(2) - Q) * T * D))
        equal(expected_D, sp.zeros(2))
        nonnegative(2 * d**2 - abs(expected_A))
        error_P = 18 * m * z + 2 * Z * d + (6 + 12 * J) * m * d**2
        error_P += 4 * m**2 * Hv
        nonnegative(-m**2 + error_P - expected_P)
        results.append({"scale": str(scale), "pivot_weight": str(m),
                        "A_drift": str(expected_A), "P_drift": str(expected_P)})
    return results


def scalar_envelopes():
    C = sp.Symbol("C", positive=True)
    D0, E0 = 80 * C**2, 250 * C**6
    majorants = {
        "heat_mean": 20 * C**5 - (C + C**2 + C**3 + 16 * C**5),
        "heat_second_moment": 50 * C**4 - 42 * C**2,
        "gram_size": D0 - (72 * C**2 + 1),
        "mean_beta": E0 - (40 * C**6 + C**2),
        "mean_sqrt_t": E0 - 200 * C**4,
        "mean_omitted_rows": E0 - 2 * C**2,
        "updated_row_size": 81 * C**2 - (1 + 8 * C)**2,
        "weighted_row_replacement": 80 * C**2 - (16 * C + 64 * C**2),
        "normalization_squared": 3912 * C**2 - 4 * (6 + 12 * 81 * C**2),
    }
    for expression in majorants.values():
        nonnegative_coefficients(expression, C)
    equal(4 * 20 * C**5 * 2, 160 * C**5)
    equal(18 * (4 * C)**2 * C**2, 288 * C**4)
    equal(2 * 80 * C**2 * D0 * 2, 320 * C**2 * D0)
    equal(4 * (4 * C)**4 * C**4, 1024 * C**8)
    equal(2 * D0**2 * 4, 8 * D0**2)

    beta, e, delta, nu = sp.symbols("beta e delta nu", real=True)
    gap_b, gap_d, gap_n = sp.symbols("gap_b gap_d gap_n", positive=True)
    exponent_identities = [
        (beta - e / 2, gap_b, {beta: gap_b + e / 2}),
        ((delta - e - nu) / 2, gap_d / 2, {delta: gap_d + e + nu}),
        ((1 + delta) / 2 - nu, gap_n, {nu: (1 + delta) / 2 - gap_n}),
        (beta, gap_b + e / 2, {beta: gap_b + e / 2}),
        (1 + delta, 1 + e + nu + gap_d, {delta: gap_d + e + nu}),
    ]
    for expression, positive_form, substitution in exponent_identities:
        equal(expression.subs(substitution), positive_form)
    selected = {delta: R(1, 100), e: R(11, 2500),
                beta: R(9, 2500), nu: R(1, 30000000)}
    exponents_A = [beta, R(1, 2), (1 + delta) / 2 - nu, e]
    exponents_P = [beta - e / 2, (delta - e - nu) / 2,
                   *exponents_A[:3], e / 2, e, 1 + delta]
    values_A = [rational_real(value.subs(selected) if hasattr(value, "subs") else value)
                for value in exponents_A]
    values_P = [rational_real(value.subs(selected) if hasattr(value, "subs") else value)
                for value in exponents_P]
    assert all(value > 0 for value in values_A + values_P)
    equal(min(values_A), R(9, 2500))
    equal(min(values_P), R(7, 5000))
    return {
        "constant_majorants": sorted(majorants),
        "exponent_positivity": {
            "beta-e/2": "positive by beta>e/2",
            "(delta-e-nu)/2": "positive by e<delta-nu",
            "(1+delta)/2-nu": "positive by nu<(1+delta)/2",
            "e/2": "positive by e>0",
            "beta": "(beta-e/2)+e/2",
            "1/2": "positive constant",
            "e": "positive hypothesis",
            "1+delta": "1+e+nu+(delta-e-nu)",
        },
        "selected_dimension": 3,
        "selected_A_rate": str(min(values_A)),
        "selected_P_rate": str(min(values_P)),
        "dimension_extension": "nu=delta/(100000*d) decreases for d>=3; all affected exponents increase",
    }


def certificate():
    return {
        "claim": "C_AC_DRIFT",
        "extended_claim": "C_AC_BALANCED",
        "result_class": "new_theorem",
        "mathematical_status": "analytic proof with exact algebra replay; independent review pending",
        "novelty_status": "unverified",
        "significance_status": "unreviewed",
        "conclusions": [
            "|E(Aprime-A)| <= m R_A(t), with R_A(t) tending to zero",
            "E(Pprime-P) <= -(1-R_P(t)) m^2, with R_P(t) tending to zero",
            "the same bounds hold for fixed balanced positive definite matrix ridges",
        ],
        "proof": "report.md: (T1)-(T2), (B), (8)-(10), (U1)-(U2)",
        "proof_boundary": {
            "exact_computations": "identities, rational finite fixtures and scalar majorants",
            "analytic_inequalities": "proved in report.md; require mathematical review",
            "formal_claim": "C_AC_NONCOMM only; full drift is not kernel certified",
            "spectral_theorems": "not established",
            "false_manuscript_assertions_found": [],
        },
        "jacobian": jacobian_and_noncommuting_inverse(),
        "dissipative_algebra": dissipative_matrix_replay(),
        "abstract_deletion_replays": stochastic_row_replay(),
        "uniform_scalar_certificate": scalar_envelopes(),
        "lean_submission": {
            "state": "submitted",
            "task_id": "ac-clearing-noncomm",
            "run_id": "ac-clearing-noncomm-1793921883386349718",
            "check_with": "$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent status --task-id ac-clearing-noncomm",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(target.read_text()) == result, "certificate differs from exact replay"
    print(json.dumps({
        "ok": True,
        "matrix_replays": result["dissipative_algebra"]["exact_replays"],
        "stochastic_replays": len(result["abstract_deletion_replays"]),
        "A_rate": result["uniform_scalar_certificate"]["selected_A_rate"],
        "P_rate": result["uniform_scalar_certificate"]["selected_P_rate"],
        "scope": "full drift has an analytic proof; exact checks do not replace independent review",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
