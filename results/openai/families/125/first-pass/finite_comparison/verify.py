#!/usr/bin/env python3
"""Replay the manuscript's rational certificates, not a numerical optimizer.

Requires SymPy. The finite-space and analytic deductions are in report.md;
this program checks their explicitly finite rational/algebraic obligations.
"""

import json
from math import comb, factorial
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
DATA = json.loads((ROOT / "exact_certificate.json").read_text())
Q = sp.Rational
X, r, eta = sp.symbols("X r eta")
EPS = Q(DATA["epsilon"])
SIGMA = Q(DATA["sigma"])
PRINTED_BETA = Q("1.6")
STRONG_BETA = Q(DATA["strengthening"]["beta"])


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def poly(coefficients):
    return sum(Q(c) * X**i for i, c in enumerate(coefficients))


def coefficients(expression):
    p = sp.Poly(sp.expand(expression), X, domain=sp.QQ)
    if p.is_zero:
        return []
    return [p.nth(i) for i in range(p.degree() + 1)]


def equal(left, right, message):
    require(sp.expand(left - right) == 0, message)


def bernstein(coeffs, alpha, beta, degree=6):
    n = len(coeffs) - 1
    require(n <= degree, "minorant degree exceeds Bernstein degree")
    return [
        sum(
            Q(comb(m, h), comb(degree, h))
            * (beta - alpha)**h
            * sum(coeffs[j] * comb(j, h) * alpha**(j - h)
                  for j in range(h, n + 1))
            for h in range(m + 1)
        )
        for m in range(degree + 1)
    ]


p, v, k = (poly(DATA[name]) for name in ("p", "v", "k"))
x = 1 - X
H0 = Q(".394") - Q(".42") * X**2 + Q(".04") * X**3


def parameters(s, beta=PRINTED_BETA):
    d = Q(".52") if s == 0 else Q(".4")
    h = beta + Q(".4") * d
    c = 1 - s * p
    N = c - (1 - s) * k
    ell = c + 1 - v + s * p * x
    H = H0 if s == 0 else Q(".25")
    return d, h, c, N, ell, H


def first_polynomial(name, s, beta=PRINTED_BETA):
    d, h, c, N, ell, _ = parameters(s, beta)
    u0 = d / h
    u1 = (2 - s) * (1 + d) / (2 * h)
    Y = N - p * ((2 - s) * x + Q((2 - s)**2) / (4 * beta))
    Yprime = N + p * (beta * X**2 - 2)
    families = {
        "Tk": 4 * k - (p + EPS) * (1 + k)**2,
        "T1": 1 - p - Q("1.12") * p * (1 + x)
              + Q(".4") * p**2 * X * (1 + x),
        "T2": ((1 - p)**2 - Q(".38") * p * X + p * x)
              * (1 + x) - 2 * x * (1 - p),
        "Q0u": N - d * v + p * u0 * (h * u0 - 2 * d),
        "Q0X": N - d * v + p * X * (h * X - 2 * d),
        "Q1": N - (2 - s) * p * x - d * (c * p - ell)
              - h * p * u1**2,
        "YH": Y - H0,
        "Y25": Y - Q(".25"),
        "YprimeH": Yprime + Q(".52") * k - H0,
        "Yprime25": Yprime - Q(".25"),
    }
    return families[name]


def third_coefficients(s, i, beta=PRINTED_BETA):
    _, _, c, N, ell, H = parameters(s, beta)
    j = c * H
    b0, b1 = (2 - s) * p * x, (2 - s) * p * X
    f, z = 2 * p * X, p * X**2
    e, e2, t = Q(i, 3), Q(i * (i - 1), 6), int(i == 3)
    B0 = z * ((beta * v + Q(".4") * N) * e2
              + beta * f * t) - SIGMA * X**2 * e2
    B1 = ((j - b0) * v + N * ell
          + ((j - b0) * f - b1 * v - N * b1) * e
          - b1 * f * e2
          - z * ((beta * (v - c * p) + Q(".4") * j) * e2
                 + beta * f * t) - SIGMA)
    B2 = ((b0 - j) * (v - c * p) - j * ell
          + ((b0 - j) * f + b1 * (v - c * p) + j * b1) * e
          + b1 * f * e2)
    return tuple(sp.expand(b) for b in (B0, B1, B2))


BCOEFFS = {(s, i): third_coefficients(s, i)
           for s in (0, 1) for i in range(4)}
STRONG_BCOEFFS = {(s, i): third_coefficients(s, i, STRONG_BETA)
                  for s in (0, 1) for i in range(4)}


def third_polynomial(name, s, i, beta=PRINTED_BETA):
    table = BCOEFFS if beta == PRINTED_BETA else STRONG_BCOEFFS
    require(beta in (PRINTED_BETA, STRONG_BETA), "uncertified beta")
    B0, B1, B2 = table[s, i]
    return {
        "B1": B1,
        "B2": B2,
        "B1+B2": B1 + B2,
        "Disc": 4 * B0 * B2 - B1**2,
        "Sum": B0 + B1 + B2,
        "B0-B2": B0 - B2,
    }[name]


def check_row(row, expression, label):
    raw = coefficients(expression)
    n = len(row["lambda"]) - 1
    scale = 10**row["scale"]
    for j in range(n):
        require(scale * (raw[j] if j < len(raw) else 0)
                >= row["lambda"][j], f"{label}: coefficient {j}")
    tail = sum(min(0, c) for c in raw[n:])
    require(scale * tail >= row["lambda"][n],
            f"{label}: negative tail {tail} below {Q(row['lambda'][n], scale)}")
    minorant = [Q(c, scale) for c in row["lambda"]]
    d, h, *_ = parameters(row["s"])
    ends = [d / h if e == "u0" else Q(e) for e in row["ends"]]
    require(all(0 <= a < b <= 1 for a, b in zip(ends, ends[1:])),
            f"{label}: interval order")
    minimum = min(b for a, z in zip(ends, ends[1:])
                  for b in bernstein(minorant, a, z))
    require(minimum >= Q(row["bernstein_micro"], 10**6),
            f"{label}: printed Bernstein lower bound")
    require(minimum > (0 if row["name"] == "Tk" or label.startswith("third")
                       else SIGMA), f"{label}: insufficient sign budget")
    return str(minimum)


def check_nodal_approximation():
    errors = [Q(0), Q(0)]
    for node in [Q(i, 4) for i in range(5)]:
        xx = 1 - node
        sums = {
            (power, n): sum((-xx)**j / (factorial(j) * (j + power + 1))
                           for j in range(n + 1))
            for power in (0, 1) for n in (12, 13)
        }
        enclosures = [(sums[1, 13], sums[1, 12]),
                      (3 - 2 * sums[0, 12], 3 - 2 * sums[0, 13])]
        for index, (interpolant, (lower, upper)) in enumerate(zip((p, v), enclosures)):
            require(lower <= upper, "Taylor enclosure reversed")
            value = interpolant.subs(X, node)
            errors[index] = max(errors[index], abs(value - lower), abs(value - upper))
    require(errors[0] < Q("2.343560e-9"), "printed p nodal error")
    require(errors[1] < Q("2.344324e-9"), "printed v nodal error")
    require(max(errors) < Q("4e-9"), "nodal approximation budget")
    lebesgue = sum(Q(4**4, factorial(i) * factorial(4 - i)) for i in range(5))
    require(lebesgue == Q(512, 3), "Lagrange basis budget")
    require(Q(1, 256) < Q(".0045") and Q(9, 2048) < Q(".0045"),
            "node-product budget")
    require(lebesgue * Q("4e-9") + Q(".0045") / 840 < EPS,
            "P interpolation remainder")
    require(lebesgue * Q("4e-9") + Q(".0045") / 360 < 2 * EPS,
            "A interpolation remainder")
    return [str(e) for e in errors]


def check_uniform_approximation():
    settings = DATA["uniform_approximation"]
    require(settings["taylor_even"] == 12 and settings["taylor_odd"] == 13,
            "uniform Taylor orders")
    sums = {(power, n): sum((-x)**j / (factorial(j) * (j + power + 1))
                           for j in range(n + 1))
            for power in (0, 1) for n in (12, 13)}
    differences = [
        EPS - p + sums[1, 13], EPS + p - sums[1, 12],
        2 * EPS - v + 3 - 2 * sums[0, 12],
        2 * EPS + v - 3 + 2 * sums[0, 13],
    ]
    count = settings["subdivisions"]
    require(count == 16, "uniform approximation partition")
    minima = []
    for expression in differences:
        cs = coefficients(expression)
        minimum = min(value for j in range(count) for value in bernstein(
            cs, Q(j, count), Q(j + 1, count), len(cs) - 1))
        require(minimum >= Q(settings["minimum_error_slack"]) > 0,
                "uniform approximation margin")
        minima.append(str(minimum))
    return {"cells": 4 * count, "minimum_error_slacks": minima}


def check_ranges_and_budgets():
    require(EPS == Q("0.0000075") and SIGMA == Q("0.0002"),
            "literal approximation budgets")
    require(all(c >= 0 for c in coefficients(p)), "p monotonicity")
    require(all(c <= 0 for c in coefficients(v)[1:]), "v monotonicity")
    require(all(c >= 0 for c in coefficients(k)), "k monotonicity")
    require(p.subs(X, 1) == Q(".5") and v.subs(X, 1) == 1, "interpolant endpoints")
    require(p.subs(X, 0) == Q(".26424112")
            and v.subs(X, 0) == Q("1.73575888")
            and k.subs(X, 0) == Q(".0767"), "interpolant lower endpoints")
    require(k.subs(X, 1) == Q(".1719"), "k endpoint")
    require(H0.subs(X, 0) == Q(".394") and H0.subs(X, 1) == Q(".014"),
            "H0 endpoints")
    equal(sp.diff(H0, X), X * (-Q(".84") + Q(".12") * X), "H0 monotonicity")
    derivative_bounds = [(Q("3.64"), 0), (Q("8.76"), 0),
                         (Q("3.848"), Q(".52")), (Q("4.848"), Q(".52")),
                         (Q("2.625"), 0), (2, 0)]
    for dp, dv in derivative_bounds:
        require(dp * EPS + dv * 2 * EPS < SIGMA, "first-table perturbation")
    require((3 * 2 + Q("1.1") * 4 + 2 + 4) * EPS == Q(".000123"),
            "third perturbation total")
    require(Q(".000123") < SIGMA, "third-table perturbation margin")
    require(Q(".26424112") * Q("1.8") - SIGMA == Q(".475434016"),
            "B0 lower bracket")
    require(Q(".26424112") * (STRONG_BETA + Q(".2")) - SIGMA > 0,
            "strengthened B0 lower bracket")
    require(STRONG_BETA == Q(159, 100)
            and Q(DATA["strengthening"]["alpha"]) == Q(2, 5),
            "strengthened theorem parameters")
    require(STRONG_BETA + Q(DATA["strengthening"]["alpha"])
            == Q(DATA["strengthening"]["conclusion_coefficient"]),
            "strengthened conclusion coefficient")
    require((2 + 1 / STRONG_BETA) < 3 and 3 * EPS < SIGMA,
            "strengthened Y substitution budget")
    for s in (0, 1):
        d, h, *_ = parameters(s, STRONG_BETA)
        require(0 < d / h < 1 and 0 < (2 - s) * (1 + d) / (2 * h) <= 1,
                "strengthened completed-square centers")
    require(Q(".2") > Q(".44")**2 and Q(".4") > Q(".62")**2,
            "AM-GM coefficient bounds")
    require(Q(35, 96) < Q(".47") and Q(".52") < Q(".53"), "type-zero split")


def check_eta_identities(beta=PRINTED_BETA):
    for s in (0, 1):
        _, _, c, N, ell, H = parameters(s, beta)
        w = X * eta
        j = c * H
        full = ((j - (2 - s) * p * (x + w)) * r + beta * p * w**2) \
            * ((1 - r) * (v + 2 * p * w) + c * p * r) \
            + (N - j * r) * ((ell - (2 - s) * p * w) * r + Q(".4") * p * w**2) \
            - SIGMA * (r + w**2)
        full = sp.Poly(sp.expand(full), eta)
        require(full.degree() <= 3, "eta degree")
        for i in range(4):
            converted = sum(full.nth(h) * Q(comb(i, h), comb(3, h))
                            for h in range(i + 1))
            table = BCOEFFS if beta == PRINTED_BETA else STRONG_BCOEFFS
            B0, B1, B2 = table[s, i]
            equal(converted, B0 + B1 * r + B2 * r**2, f"eta identity {s},{i}")
            actual = [None if not coefficients(B) else len(coefficients(B)) - 1
                      for B in (B0, B1, B2)]
            require(actual == DATA["degrees"][str(s)][i], f"printed degrees {s},{i}")
            if i < 2:
                require(B0 == 0, "vanishing B0")


def check_algebra():
    P, A, w, D, C, kk, b, a, m, z, J, q, t, beta, R, s, y = sp.symbols(
        "P A w D C kk b a m z J q t beta R s y")
    L = (C - m - b) * r + Q(".4") * z
    M = (1 - r) * a + C * P * r
    G = M - L
    K = C - kk - b * r + beta * z
    T = (J - b) * r + beta * z
    equal(T * M + (C - kk - J * r) * L, T * G + K * L, "charge rearrangement")
    U = m * D + b * (D + 1)
    uprime = (U * r - (Q(".4") * D + beta) * z) / (C * r)
    require(sp.cancel(uprime - D - (b * r - beta * z - L * D) / (C * r)) == 0,
            "Uprime-D identity")
    require(sp.cancel(uprime - ((D + 1) * (m + b - Q(".4") * z / r) / C
                                - m / C - (beta - Q(".4")) * z / (C * r))) == 0,
            "Uprime first-scalar identity")
    psi = (1 - q) / (1 - P * q)
    require(sp.cancel(psi - (1 - q + P * q * psi)) == 0, "psi identity")
    linear_integrand = ((m * D + b * (D + 1)) * q
                        + D * (C * (1 - q + P * q) + a * (1 - q) - C)
                        - (Q(".4") * D + beta) * z - C + kk)
    equal(linear_integrand, (D * G - K).subs(r, q), "pointwise linear majorant")
    cc = 1 - P * s
    aa = 1 + m + 2 * P * y
    normalized = (-3 + (1 - r) * (D + cc * R) + aa * r * D + 2 * P * y * r
                  + P * s * (1 - y * r) * (1 + D))
    finite = cc * (1 - r) * R + r * (m * D + (2 - s) * P * y * (D + 1)) - cc * (D + 1)
    equal(normalized - finite, 2 * (D - 1), "rounding normalization centering")
    for s in (0, 1):
        require(sp.cancel(((1 - s * P) * psi - (1 - q))
                          - (P * q * (1 - q) / (1 - P * q) if s == 0
                             else -P * (1 - q)**2 / (1 - P * q))) == 0,
                "kappa formula")
        dd, _, _, _, _, _ = parameters(s)
        hh = beta + Q(".4") * dd
        cc = 1 - s * P
        nn = cc - (1 - s) * kk
        ll = cc + 1 - A + s * P * x
        bb = (2 - s) * P * (x + w)
        zz = P * w**2
        aa = A + 2 * P * w
        mm = A - 1 - 2 * P * x
        LL = (cc - mm - bb) * r + Q(".4") * zz
        GG = (1 - r) * aa + cc * P * r - LL
        gap = nn - bb * r + beta * zz - dd * GG
        equal(gap.subs(r, 0), nn - dd * A + P * w * (hh * w - 2 * dd),
              "K-dG endpoint zero")
        u1 = (2 - s) * (1 + dd) / (2 * hh)
        Q1 = nn - (2 - s) * P * x - dd * (cc * P - ll) - hh * P * u1**2
        require(sp.cancel(gap.subs(r, 1) - Q1 - hh * P * (w - u1)**2) == 0,
                "K-dG endpoint one")
        # Substitute the integral identity A-1=2x(1-P)/(1+x).
        first_gap = cc * (1 - P) / (1 - P * r) - (mm + bb - Q(".4") * zz / r)
        substituted = first_gap.subs(A, 1 + 2 * x * (1 - P) / (1 + x)).subs(r, 1 / (t + P))
        target = (cc * (1 - P) - 2 * x * (1 - P) / (1 + x)
                  + s * P * x - (2 - s) * P * w + Q(".4") * P**2 * w**2
                  + P * (cc * (1 - P) / t + Q(".4") * w**2 * t))
        require(sp.cancel(substituted - target) == 0, "first-scalar AM-GM identity")


def check_coverage():
    expected = {
        (0, 0): [("B1", "0", "1"), ("B1+B2", "0", "1")],
        (0, 1): [("B1", "0", "1"), ("B1+B2", "0", "1")],
        (1, 0): [("B1", "0", "1"), ("B1+B2", "0", "1")],
        (1, 1): [("B1", "0", "1"), ("B1+B2", "0", "1")],
        (0, 2): [("B1", "0", ".05"), ("B2", "0", ".05"), ("Disc", ".05", "1")],
        (0, 3): [("B1", "0", ".015"), ("B2", "0", ".015"), ("Disc", ".015", "1")],
        (1, 2): [("B1", "0", ".2"), ("B2", "0", ".2"), ("Disc", ".2", "1")],
        (1, 3): [("B1", "0", ".1"), ("B2", "0", ".1"), ("Disc", ".1", ".75"),
                 ("Sum", ".75", "1"), ("B0-B2", ".75", "1")],
    }
    for (s, i), requirements in expected.items():
        for name, lo, hi in requirements:
            found = [row for row in DATA["third_table"]
                     if row["s"] == s and i in row["i"] and row["name"] == name]
            require(len(found) == 1, f"coverage missing {s},{i},{name}")
            require(Q(found[0]["ends"][0]) == Q(lo)
                    and Q(found[0]["ends"][-1]) == Q(hi), "coverage endpoints")
    first_requirements = [
        ("Tk", 0, "0", "1"), ("T1", 0, "0", "1"), ("T2", 0, "0", "1"),
        ("Q0u", 1, "0", "1"), ("Q1", 1, "0", "1"), ("Q1", 0, "0", "1"),
        ("Q0u", 0, "u0", "1"), ("Q0X", 0, "0", "u0"),
        ("YH", 1, "0", "1"), ("Y25", 1, "0", "1"),
        ("YH", 0, ".5", "1"), ("Y25", 0, ".5", "1"),
        ("YprimeH", 0, "0", ".5"), ("Yprime25", 0, "0", ".5"),
    ]
    for name, s, low, high in first_requirements:
        found = [row for row in DATA["first_table"]
                 if row["s"] == s and row["name"] == name]
        require(len(found) == 1 and found[0]["ends"][0] == low
                and found[0]["ends"][-1] == high, "first-table domain coverage")
    require(len(DATA["first_table"]) == 14 and len(DATA["third_table"]) == 21,
            "printed table row count")


def check_tails():
    for row in DATA["tails"]:
        expression = third_polynomial("Disc", row["s"], row["i"])
        cs = coefficients(expression)
        require(len(cs) - 1 == row["degree"] <= 28, "discriminant degree")
        for block, printed in enumerate(row["blocks"]):
            start = row["n"] + 5 * block
            actual = sum(min(0, c) for c in cs[start:start + 5])
            require(actual >= Q(printed, 10000), f"tail block {row['s']},{row['i']},{block}")


def check_strengthening():
    count = DATA["strengthening"]["subdivisions_per_listed_interval"]
    require(isinstance(count, int) and count > 0, "strengthening subdivision count")
    margin = Q(DATA["strengthening"]["minimum_sign_margin"])
    minima = []
    cells = 0
    for table in ("first_table", "third_table"):
        for row in DATA[table]:
            d, h, *_ = parameters(row["s"], STRONG_BETA)
            ends = [d / h if e == "u0" else Q(e) for e in row["ends"]]
            require(all(0 <= a < b <= 1 for a, b in zip(ends, ends[1:])),
                    "strengthened interval order")
            for i in ([None] if table == "first_table" else row["i"]):
                expression = (
                    first_polynomial(row["name"], row["s"], STRONG_BETA) if i is None
                    else third_polynomial(row["name"], row["s"], i, STRONG_BETA)
                )
                cs = coefficients(expression)
                degree = len(cs) - 1
                require(0 <= degree <= 28, "strengthened polynomial degree")
                bound = SIGMA if table == "first_table" and row["name"] != "Tk" else 0
                minimum = None
                for a, b in zip(ends, ends[1:]):
                    for j in range(count):
                        lower, upper = a + (b - a) * Q(j, count), a + (b - a) * Q(j + 1, count)
                        bc = bernstein(cs, lower, upper, degree)
                        cell_min = min(bc)
                        require(cell_min > bound,
                                f"strengthening {table} {row['name']} {row['s']},{i} [{lower},{upper}]")
                        minimum = cell_min if minimum is None else min(minimum, cell_min)
                        cells += 1
                require(minimum >= margin, "strengthened advertised sign margin")
                minima.append(minimum)
    check_eta_identities(STRONG_BETA)
    shortcut = DATA["retired_shortcut"]
    actual = coefficients(third_polynomial("Disc", shortcut["s"], shortcut["i"],
                                           STRONG_BETA))[shortcut["power"]]
    require(actual == Q(shortcut["actual_coefficient"])
            < Q(shortcut["printed_minorant_coefficient"]), "retired shortcut obstruction")
    return {"beta": str(STRONG_BETA), "coefficient": "199/100",
            "cells": cells, "minimum_bernstein": str(min(minima))}


def check_jacobian():
    result = json.loads((ROOT / "jacobian_output.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timeout"], "Jacobian status")
    require(result["request"]["payload"] == payload, "Jacobian payload binding")
    require(result["result"]["operation_id"] == "polynomial.box.enclosure.compute",
            "Jacobian operation")
    output = result["result"]["output"]
    require(output["box"] == payload["box"] and output["polynomial"] == payload["polynomial"],
            "Jacobian retained source")
    def rational(value):
        return Q(int(value["num"]), int(value["den"]))
    enclosure = output["enclosure"]
    require(rational(enclosure["lower"]) == Q(87, 1600)
            and rational(enclosure["upper"]) == Q(121, 800), "Jacobian exact enclosure")
    require(rational(enclosure["lower"]) > 0, "Jacobian positivity on [0,1/2]")
    terms = payload["polynomial"]["polynomial"]["terms"]
    equal(sum(rational(t["coefficient"]) * X**t["exponents"][0] for t in terms),
          poly(DATA["first_table"][1]["lambda"]) / 100, "Jacobian manuscript binding")


def main():
    node_errors = check_nodal_approximation()
    uniform = check_uniform_approximation()
    check_ranges_and_budgets()
    check_algebra()
    check_eta_identities()
    check_coverage()
    minima = {"first": [], "third": []}
    for n, row in enumerate(DATA["first_table"], 1):
        minima["first"].append(check_row(row, first_polynomial(row["name"], row["s"]),
                                         f"first {n} {row['name']}"))
    for n, row in enumerate(DATA["third_table"], 1):
        for i in row["i"]:
            minima["third"].append(check_row(row, third_polynomial(row["name"], row["s"], i),
                                             f"third {n} s={row['s']} i={i} {row['name']}"))
    check_tails()
    check_jacobian()
    strengthening = check_strengthening()
    print(json.dumps({"ok": True, "first_rows": 14, "third_rows": 21,
                      "third_instantiations": 22, "eta_identities": 16,
                      "tail_blocks": 20, "nodal_error_enclosures": node_errors,
                      "uniform_approximation": uniform,
                      "strengthening": strengthening,
                      "minimum_bernstein": min(Q(v) for a in minima.values() for v in a).__str__(),
                      "scope": "Exact finite obligations; see report.md for universal analytic and directed deductions."},
                     sort_keys=True))


if __name__ == "__main__":
    main()
