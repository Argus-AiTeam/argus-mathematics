#!/usr/bin/env python3
"""Replay universal contraction identities and exact local-coordinate checks."""

import argparse
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.symbolic.determinant.compute"


def zero(expression):
    residual = sp.cancel(expression)
    if residual != 0:
        raise AssertionError(f"Nonzero exact residual: {sp.factor(residual)}")
    return "0"


def rational_function(expression, variables):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    denominator_poly = sp.Poly(denominator, *variables, domain=sp.QQ)
    leading = denominator_poly.LC()

    def terms(value):
        polynomial = sp.Poly(value / leading, *variables, domain=sp.QQ)
        return {
            "terms": [
                {
                    "coefficient": {"num": str(c.p), "den": str(c.q)},
                    "exponents": list(exponents),
                }
                for exponents, c in polynomial.terms()
                if c
            ]
        }

    return {
        "domain": "QQ",
        "variables": [str(v) for v in variables],
        "numerator": terms(numerator),
        "denominator": terms(denominator),
    }


def decode_rational_function(value, variables):
    if value["variables"] != [str(v) for v in variables]:
        raise AssertionError("Jacobian variable order differs from the payload")
    if value.get("domain", "QQ") != "QQ":
        raise AssertionError("Jacobian returned a different coefficient domain")

    def polynomial(record):
        total = sp.S.Zero
        for term in record["terms"]:
            exponents = term["exponents"]
            if len(exponents) != len(variables):
                raise AssertionError("Incorrect Jacobian exponent-vector length")
            coefficient = term["coefficient"]
            total += sp.Rational(coefficient["num"], coefficient["den"]) * sp.prod(
                v**exponent for v, exponent in zip(variables, exponents)
            )
        return total

    return polynomial(value["numerator"]) / polynomial(value["denominator"])


def axial_matrix():
    k, c, s, d, a = sp.symbols("k c s d a")
    matrix = sp.Matrix(
        [
            [k + 1, -c, 0],
            [
                -c,
                2 * k * c - (k - 1) * c**2,
                2 * k * s * c * a,
            ],
            [
                0,
                2 * k * s * c * a,
                2 * k**2 * s * d,
            ],
        ]
    )
    determinant = 2 * k**2 * s * c * (
        2 * k * (k + 1) * d - k**2 * d * c - 2 * s * c * a**2 * (k + 1)
    )
    return (k, c, s, d, a), matrix, determinant


def payload():
    variables, matrix, _ = axial_matrix()
    return {
        "matrix": {
            "variables": [str(v) for v in variables],
            "entries": [
                [rational_function(matrix[i, j], variables) for j in range(3)]
                for i in range(3)
            ],
        }
    }


def replay_jacobian():
    supplied = json.loads((ROOT / "jacobian_payload.json").read_text())
    if supplied != payload():
        raise AssertionError("Jacobian payload is not the claimed axial matrix")
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    if response["tool"] != "math.run":
        raise AssertionError("Expected a typed Jacobian execution response")
    request = response["request"]
    if request["operation_id"] != OPERATION:
        raise AssertionError("Different Jacobian operation")
    if request["payload"] != supplied:
        raise AssertionError("Jacobian did not execute the retained payload")
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    if status["exit_code"] != 0 or status["timeout"]:
        raise AssertionError("The successful response has no successful adapter receipt")
    result = response["result"]
    if result.get("kind") == "error" or "error" in result:
        raise AssertionError(f"Jacobian operation failed: {result}")
    variables, matrix, expected = axial_matrix()
    typed = result["output"]
    returned = decode_rational_function(typed["determinant"], variables)
    zero(returned - expected)
    zero(matrix.det(method="bareiss") - returned)
    k, c, s, d, a = variables
    p = sp.Symbol("p")
    q = k + p * a**2
    specialized = returned.subs(
        {c: k * (1 - a**2) / q, s: p + (k - 1) / 2, d: 1 - a**2},
        simultaneous=True,
    )
    original_determinant = (
        k * (p + (k - 1) / 2) * (1 - a**2)**2
        * (k * (k + 2) + a**2) / (4 * q**2)
    )
    zero(specialized / (2 * k)**3 - original_determinant)
    rejected = json.loads((ROOT / "jacobian_rejected_output.json").read_text())
    rejected_status = json.loads((ROOT / "jacobian_rejected_status.json").read_text())
    if rejected.get("ok") is not False or rejected_status["exit_code"] != 2:
        raise AssertionError("The rejected operation must remain recorded as a failure")
    if rejected["error"]["data"]["errors"][0]["code"] != "matrix.budget_exceeded":
        raise AssertionError("Unexpected recorded rejection")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "adapter_error": None,
        "timeout": False,
        "typed_determinant_replay": "0",
        "factored_determinant": str(expected),
        "specialized_original_determinant": str(original_determinant),
        "rejected_larger_payload": {
            "payload": "jacobian_rejected_payload.json",
            "output": "jacobian_rejected_output.json",
            "status": rejected_status,
            "error_code": "matrix.budget_exceeded",
            "mathematical_conclusion": "none",
        },
    }


def universal_identities():
    k, p, p1, a = sp.symbols("k p p1 a")
    d, v, q = 1 - a**2, a**2, k + p * a**2
    chi, s = k * d / q, p + (k - 1) / 2
    F, j, x, t0, m2, my, y2 = sp.symbols("F j x t0 m2 my y2")
    r = F - chi * j
    A = k * s - (k - 1) ** 2 * v / 4
    B = (k * (k + 2) + v) / (2 * (k + 1))
    shifted_m2 = m2 + 2 * s * a * my + s**2 * v * y2
    axial = (
        k * s * d * x**2
        - (k - 1) * r**2 / (2 * k)
        + chi * j**2
        - chi * F * j
        + F**2
        + 2 * s * chi * j * a * x
    )
    completed = (
        k * s * d * (x + a * j / q) ** 2
        + (k + 1) / (2 * k) * (F - chi * j / (k + 1)) ** 2
        + k * d * B / q**2 * j**2
    )
    qtrace = r + j + 2 * p * a * x
    qnorm = (
        t0
        + r**2 / k
        + 2 * (m2 + 2 * p * a * my + p**2 * v * y2)
        + (j + 2 * p * a * x) ** 2
    )
    pq_w_dt = a * my + p * v * y2 - a * r * x
    invariant = (
        (qnorm - qtrace**2) / 2
        + (k - 1) * pq_w_dt
        + k * s * (y2 + d * x**2)
        + F * (r + j + 2 * s * a * x)
    )
    displayed = t0 / 2 + shifted_m2 + A * y2 + axial
    checks = {
        "invariant_to_displayed_quadratic": zero(invariant - displayed),
        "completed_axial": zero(axial - completed),
        "B_two_expressions": zero(
            B - d * k * (k + 2) / (2 * (k + 1)) - v * (k + 1) / 2
        ),
        "transverse_flux": zero(a * my + q * y2 - (a * my + (k + p * v) * y2)),
        "axial_flux": zero(
            chi * (q * x + a * j) - (-a * r + k * d * x) - F * a
        ),
        "Achi_axial_eigenvalue": zero(1 - (k + p) * v / q - chi),
        "A_positive_decomposition": zero(
            A - (k**2 - 1) / 4 - k * p - (k - 1) ** 2 * d / 4
        ),
        "alpha_positive_decomposition": zero(
            k * s - 1 - k * p - (k - 2) * (k + 1) / 2
        ),
        "gamma_quadratic_bound_decomposition": zero(
            2 * (1 + p) ** 2 * k * B
            - q**2
            - p * (k - v) * (k * (1 + p) + q)
            - k * (k + v) / (k + 1) * (1 + p) ** 2
        ),
        "chi_weight_decomposition": zero(
            d - chi**2 - d * v * (k**2 + 2 * k * p + p**2 * v) / q**2
        ),
        "shift_recovery_gap": zero(
            2 * (sp.Symbol("m") + s * a * sp.Symbol("y")) ** 2
            + 2 * s**2 * v * sp.Symbol("y") ** 2
            - sp.Symbol("m") ** 2
            - (sp.Symbol("m") + 2 * s * a * sp.Symbol("y")) ** 2
        ),
    }

    hr, hn, hm2, hmy, hj, ht, hx, ric = sp.symbols(
        "hr hn hm2 hmy hj ht hx ric"
    )
    b = a * x
    hww = v * hj
    hwt = a * (hmy + hj * x)
    tr_h = hr + hj
    norm_h = hn + 2 * hm2 + hj**2
    tr_c = tr_h + 2 * p * b
    norm_c = (
        hn
        + 2 * (hm2 + 2 * p * a * hmy + p**2 * v * y2)
        + (hj + 2 * p * b) ** 2
    )
    bcc = norm_c - tr_c**2
    grad_alpha_h2 = v * (hm2 + hj**2)
    ph_gradalpha_w = (
        p * d * hwt
        - grad_alpha_h2
        - tr_h * (p * d * b - hww)
    )
    div_pe_w = p1 * v * y2 + p * (
        v * ht - (1 + v) * a * hmy + hr * a * x + p * d * v * y2
    )
    graph_gauss = (
        (hr**2 - hn) / 2
        + hr * (d * hj + p * a * x * (2 - v))
        - d * (hm2 + 2 * p * a * hmy + p**2 * v * y2)
    )
    direct_bar = -ric + graph_gauss - p * v * ht - (p1 + p**2) * v * y2
    divergence_bar = -bcc / 2 - ric - ph_gradalpha_w - div_pe_w
    checks["riemannian_graph_vs_expanded_divergence"] = zero(
        direct_bar - divergence_bar
    )

    laplace_bar = ht + d * hx - b * (hr + d * hj) + p * v * y2 - p * v * d * x**2
    logu_dt_A = (k - 1 + p) * (y2 + d * x**2)
    checks["conformal_weight_change"] = zero(
        k * s * (y2 + d * x**2)
        - k * logu_dt_A
        + k * (k - 1) / 2 * (y2 + d * x**2)
    )
    checks["laplace_formula"] = zero(
        laplace_bar
        - (ht + d * hx - b * (tr_h - hww)
           + p * (v * (y2 + x**2) - (2 - v) * b**2))
    )
    checks["div_u_w"] = zero(
        tr_h - hww + p * d * b
        + (k - 1 + p * (1 + v)) * b + hww
        - (tr_h + 2 * s * b)
    )
    checks["weighted_tensor_product_rule_coefficient"] = zero(
        p * d + k - 1 + p * (1 + v) - 2 * s
    )
    bkk, bkc, bcc_variable = sp.symbols("BKK BKC BCC")
    checks["arbitrary_K_cancellation"] = zero(
        -bkk / 2 + (bkk + 2 * bkc + bcc_variable) / 2
        - (bkc + bcc_variable) + bcc_variable / 2
    )

    cp = sp.diff(chi, p)
    checks["cutoff_pprime_coefficient"] = zero(
        p1 * cp * a * x * j - p1 * (v * y2 + cp * a * x * j) + p1 * v * y2
    )
    checks["direct_curvature_pprime_coefficient"] = zero(
        sp.diff(direct_bar - k * laplace_bar, p1) + v * y2
    )

    tau, kn, kh, htrace = sp.symbols("tau kn kh htrace")
    lnorm, ltrace = kn + 2 * kh + norm_h, tau + htrace
    zero_slope_rhs = (
        (tau**2 - kn) / 2
        + (lnorm + ltrace**2) / 2
        + k * s * (y2 + x**2)
        - ltrace * tau
        - norm_h
        - kh
        - k * (k - 1 + p) * (y2 + x**2)
    )
    zero_slope_lhs = (
        (htrace**2 - norm_h) / 2 - k * (k - 1) / 2 * (y2 + x**2)
    )
    checks["zero_slope_axis_independent_identity"] = zero(
        zero_slope_rhs - zero_slope_lhs
    )
    stationary = (
        t0 / 2 + m2
        + (k + 1) / (2 * k) * (F - chi * j / (k + 1)) ** 2
        + chi * (1 - k * chi / (2 * (k + 1))) * j**2
    )
    checks["stationary_completion"] = zero(
        (t0 / 2 + m2 + axial).subs(x, 0) - stationary
    )
    sharp_subs = {k: 2, a: sp.Rational(1, 2), j: q, x: -a,
                  F: k * d / (k + 1), t0: 0, m2: 0, my: 0, y2: 0}
    sharp_energy = sp.cancel(displayed.subs(sharp_subs, simultaneous=True).subs(
        {k: 2, a: sp.Rational(1, 2)}, simultaneous=True
    ))
    sharp_norm = sp.cancel(
        (t0 + r**2 / k + m2 + d * j**2 + F**2 + y2 + d * x**2)
        .subs(sharp_subs, simultaneous=True)
        .subs({k: 2, a: sp.Rational(1, 2)}, simultaneous=True)
    )
    checks["quadratic_exponent_sharp_energy"] = zero(sharp_energy - sp.Rational(33, 16))
    checks["quadratic_exponent_sharp_ratio"] = zero(
        sharp_norm / sharp_energy - (p**2 / 44 + 4 * p / 11 + sp.Rational(21, 11))
    )
    degenerating = displayed.subs(
        {p: 0, k: 2, t0: 0, m2: 0, my: 0, y2: 0},
        simultaneous=True,
    ).subs({j: 1, x: -a / 2, F: (1 - a**2) / 3}, simultaneous=True)
    checks["degenerating_weight_sharp_family"] = zero(
        degenerating - (1 - a**2) * (8 + a**2) / 12
    )
    return checks


def connection_jets(metric, first, second):
    n = len(metric)
    inverse = sp.Matrix(metric).inv().tolist()
    inverse_first = [
        [
            [
                -sum(inverse[i][r] * first[a][r][s] * inverse[s][j]
                     for r in range(n) for s in range(n))
                for j in range(n)
            ]
            for i in range(n)
        ]
        for a in range(n)
    ]
    gamma = [
        [
            [
                sum(inverse[h][l] * (first[i][l][j] + first[j][l][i] - first[l][i][j])
                    for l in range(n)) / 2
                for j in range(n)
            ]
            for i in range(n)
        ]
        for h in range(n)
    ]
    gamma_first = [
        [
            [
                [
                    sum(
                        inverse_first[a][h][l]
                        * (first[i][l][j] + first[j][l][i] - first[l][i][j])
                        + inverse[h][l]
                        * (second[a][i][l][j] + second[a][j][l][i] - second[a][l][i][j])
                        for l in range(n)
                    ) / 2
                    for j in range(n)
                ]
                for i in range(n)
            ]
            for h in range(n)
        ]
        for a in range(n)
    ]
    ricci = [
        [
            sum(
                gamma_first[h][h][i][j] - gamma_first[j][h][i][h]
                + sum(gamma[h][h][l] * gamma[l][i][j]
                      - gamma[h][j][l] * gamma[l][i][h] for l in range(n))
                for h in range(n)
            )
            for j in range(n)
        ]
        for i in range(n)
    ]
    scalar = sum(inverse[i][j] * ricci[i][j] for i in range(n) for j in range(n))
    return scalar, ricci, gamma_first


def coordinate_replay(n, zero_gradient):
    k = n - 1
    R = sp.Rational
    p, p1 = R(5, 2), R(-7, 3)
    metric = [[sp.Integer(i == j) for j in range(n)] for i in range(n)]
    metric_first = [[[sp.S.Zero for _ in range(n)] for _ in range(n)] for _ in range(n)]
    metric_second = [
        [
            [[R(((i + j + 2) * (a + b + 3)) % 7 - 3, 29)
              for j in range(n)] for i in range(n)]
            for b in range(n)
        ]
        for a in range(n)
    ]
    f1 = [sp.S.Zero] * (n - 1) + [sp.S.Zero if zero_gradient else R(3, 4)]
    f2 = [[R((i + j + 1) % 5 - 2, 7) for j in range(n)] for i in range(n)]
    f3 = [[[R((i + j + a + 1) % 7 - 3, 11) for j in range(n)]
           for i in range(n)] for a in range(n)]
    t1 = [R(i + 1, 13) for i in range(n)]
    t2 = [[R((i + j + 1) % 5 - 2, 17) for j in range(n)] for i in range(n)]
    K = [[R((i + j + 2) % 5 - 2, 19) for j in range(n)] for i in range(n)]
    K1 = [[[R((2 * a + i + j + 1) % 7 - 3, 23) for j in range(n)]
           for i in range(n)] for a in range(n)]
    l2first = [2 * p * ti for ti in t1]
    l2second = [[(4 * p**2 + 2 * p1) * t1[a] * t1[b] + 2 * p * t2[a][b]
                for b in range(n)] for a in range(n)]
    bar = [[metric[i][j] + f1[i] * f1[j] for j in range(n)] for i in range(n)]
    bar1 = [
        [[l2first[a] * f1[i] * f1[j] + f2[a][i] * f1[j] + f1[i] * f2[a][j]
          for j in range(n)] for i in range(n)]
        for a in range(n)
    ]
    bar2 = [
        [
            [
                [
                    metric_second[a][b][i][j]
                    + l2second[a][b] * f1[i] * f1[j]
                    + l2first[a] * (f2[b][i] * f1[j] + f1[i] * f2[b][j])
                    + l2first[b] * (f2[a][i] * f1[j] + f1[i] * f2[a][j])
                    + f3[a][b][i] * f1[j] + f2[a][i] * f2[b][j]
                    + f2[b][i] * f2[a][j] + f1[i] * f3[a][b][j]
                    for j in range(n)
                ]
                for i in range(n)
            ]
            for b in range(n)
        ]
        for a in range(n)
    ]
    hat1 = [
        [[bar1[a][i][j] + 2 * t1[a] * bar[i][j] for j in range(n)] for i in range(n)]
        for a in range(n)
    ]
    hat2 = [
        [
            [
                [
                    bar2[a][b][i][j]
                    + 2 * t1[a] * bar1[b][i][j] + 2 * t1[b] * bar1[a][i][j]
                    + (4 * t1[a] * t1[b] + 2 * t2[a][b]) * bar[i][j]
                    for j in range(n)
                ]
                for i in range(n)
            ]
            for b in range(n)
        ]
        for a in range(n)
    ]
    scalar_g, _, gamma_g_first = connection_jets(metric, metric_first, metric_second)
    scalar_hat, _, _ = connection_jets(bar, hat1, hat2)

    S = sum(fi**2 for fi in f1)
    S1 = [2 * sum(f1[i] * f2[a][i] for i in range(n)) for a in range(n)]
    S2 = [
        [
            -sum(metric_second[a][b][i][j] * f1[i] * f1[j]
                 for i in range(n) for j in range(n))
            + 2 * sum(f2[a][i] * f2[b][i] + f1[i] * f3[a][b][i] for i in range(n))
            for b in range(n)
        ]
        for a in range(n)
    ]
    D, sqrtD = 1 + S, sp.sqrt(1 + S)
    D1 = [l2first[a] * S + S1[a] for a in range(n)]
    D2 = [
        [l2second[a][b] * S + l2first[a] * S1[b] + l2first[b] * S1[a] + S2[a][b]
         for b in range(n)]
        for a in range(n)
    ]
    Z1 = [t1[a] + D1[a] / (2 * k * D) for a in range(n)]
    Z2 = [
        [t2[a][b] + (D2[a][b] / D - D1[a] * D1[b] / D**2) / (2 * k)
         for b in range(n)]
        for a in range(n)
    ]
    w = [fi / sqrtD for fi in f1]
    H = [[f2[i][j] / sqrtD for j in range(n)] for i in range(n)]
    v, d = sum(wi**2 for wi in w), 1 / D
    q = k + p * v
    chi, s = k * d / q, p + R(k - 1, 2)
    Hw = [sum(H[a][i] * w[i] for i in range(n)) for a in range(n)]
    logalpha = [p * d * t1[a] - Hw[a] for a in range(n)]
    dw = [[H[a][i] + logalpha[a] * w[i] for i in range(n)] for a in range(n)]
    v1 = [2 * sum(w[i] * dw[a][i] for i in range(n)) for a in range(n)]
    q1 = [p1 * t1[a] * v + p * v1[a] for a in range(n)]
    c, c1 = (k + p) / q, [
        p1 * t1[a] / q - (k + p) * q1[a] / q**2 for a in range(n)
    ]
    Ac = [[metric[i][j] - c * w[i] * w[j] for j in range(n)] for i in range(n)]
    Ac1 = [
        [[-c1[a] * w[i] * w[j] - c * (dw[a][i] * w[j] + w[i] * dw[a][j])
          for j in range(n)] for i in range(n)]
        for a in range(n)
    ]
    H1 = [
        [
            [
                logalpha[a] * H[i][j]
                + (f3[a][i][j]
                   - sum(gamma_g_first[a][m][i][j] * f1[m] for m in range(n))) / sqrtD
                for j in range(n)
            ]
            for i in range(n)
        ]
        for a in range(n)
    ]
    L = [[K[i][j] + H[i][j] for j in range(n)] for i in range(n)]
    F = sum(Ac[i][j] * L[i][j] for i in range(n) for j in range(n))
    F1 = [
        sum(Ac1[a][i][j] * L[i][j] + Ac[i][j] * (K1[a][i][j] + H1[a][i][j])
            for i in range(n) for j in range(n))
        for a in range(n)
    ]
    Bv = [k * Z1[i] + sum(K[i][j] * w[j] for j in range(n)) for i in range(n)]
    Bv1 = [
        [
            k * Z2[a][i] + sum(K1[a][i][j] * w[j] + K[i][j] * dw[a][j]
                               for j in range(n))
            for i in range(n)
        ]
        for a in range(n)
    ]
    Vu = [sum(Ac[i][j] * Bv[j] for j in range(n)) for i in range(n)]
    divVu = sum(Ac1[i][i][j] * Bv[j] + Ac[i][j] * Bv1[i][j]
                for i in range(n) for j in range(n))
    logu1 = [(k - 1 + p) * t1[i] + D1[i] / (2 * D) for i in range(n)]
    divuV = divVu + sum(logu1[i] * Vu[i] for i in range(n))
    tau = sum(K[i][i] for i in range(n))
    mu = (scalar_g + tau**2 - sum(K[i][j]**2 for i in range(n) for j in range(n))) / 2
    J = [sum(K1[i][i][j] - K1[j][i][i] for i in range(n)) for j in range(n)]
    trT = sum(L[i][i] for i in range(k))
    T0norm = sum((L[i][j] - (trT / k if i == j else 0))**2
                 for i in range(k) for j in range(k))
    aw = w[-1]
    quadratic = (
        T0norm / 2
        + sum((L[i][-1] + s * aw * t1[i])**2 for i in range(k))
        + (k * s - R((k - 1)**2, 4) * v) * sum(t1[i]**2 for i in range(k))
        + k * s * d * t1[-1]**2
        - R(k - 1, 2 * k) * (F - chi * L[-1][-1])**2
        + chi * L[-1][-1]**2 - chi * F * L[-1][-1] + F**2
        + 2 * s * chi * L[-1][-1] * aw * t1[-1]
    )
    rhs = (
        mu + sum(J[i] * w[i] for i in range(n)) + quadratic
        + sum(w[i] * F1[i] for i in range(n)) - F * tau - divuV
    )
    return {
        "n": n,
        "zero_gradient": zero_gradient,
        "p": str(p),
        "p_prime": str(p1),
        "scalar_identity_residual": zero(scalar_hat / 2 - rhs),
        "role": "supplemental exact coordinate regression, not the universal proof",
    }


def build_certificate():
    if not (ROOT / "lean" / "Main.lean").is_file():
        raise AssertionError("The canonical formal source is missing")
    if not (ROOT / "lean" / "statement_fidelity.md").is_file():
        raise AssertionError("The statement-fidelity document is missing")
    identities = universal_identities()
    jacobian = replay_jacobian()
    coordinates = [
        coordinate_replay(n, at_zero)
        for n in (3, 4)
        for at_zero in (False, True)
    ]
    return {
        "result_type": "universal_local_verification_with_optimal_quadratic_exponent",
        "claim_scope": ["prop:scalar:identity", "prop:scalar:coercivity"],
        "source": (
            "research/openai_manuscript/"
            "The-spacetime-Penrose-inequality-and-enclosing-area-September-27-2026/"
            "build/sections/scalar-identity.tex"
        ),
        "universal_parameters": {
            "k": "every integer k >= 2; contraction identities hold rationally in k",
            "p": "0 <= p <= N for coercivity",
            "a": "a^2 = v < 1",
            "p_prime": "unrestricted; never set to zero",
        },
        "identity_residuals": identities,
        "coercivity": {
            "constant_C_k": "32 + 4*k^2",
            "large_parameter_dependence": "(1+N)^2, not a higher polynomial",
            "proof": "report.md and lean/Main.lean",
            "stationary_lower_constant": "1/16",
            "stationary_upper_constant": "3",
            "sharpness_k": 2,
            "sharpness_v": "1/4",
            "sharpness_energy": "33/16",
            "sharpness_norm_to_energy": "p^2/44 + 4*p/11 + 21/11",
        },
        "jacobian": jacobian,
        "coordinate_regressions": coordinates,
        "external_literature_assumptions": [],
        "not_established": [
            "full differential geometry in the Lean kernel",
            "global elliptic existence",
            "enclosure and limiting energy comparison",
            "the Penrose inequality",
            "independent Reviewer acceptance",
            "verified novelty or publishable significance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write-jacobian-payload", action="store_true")
    mode.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.write_jacobian_payload:
        target = ROOT / "jacobian_payload.json"
        target.write_text(json.dumps(payload(), indent=2) + "\n")
        print(f"Wrote {target.name} for {OPERATION}")
        return
    computed = build_certificate()
    target = ROOT / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(computed, indent=2) + "\n")
    elif json.loads(target.read_text()) != computed:
        raise AssertionError("Stored certificate differs from exact replay")
    print(
        f"PASS: {len(computed['identity_residuals'])} universal identities; "
        f"{len(computed['coordinate_regressions'])} exact coordinate regressions; "
        "Jacobian determinant independently replayed."
    )


if __name__ == "__main__":
    main()
