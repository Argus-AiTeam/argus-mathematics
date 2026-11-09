#!/usr/bin/env python3
"""Exact finite premises for the whole-line theorem proved in report.md."""

import argparse
import ast
import copy
import json
import math
from fractions import Fraction as F
from pathlib import Path


D = 10**36
AD = 10**7
LD = 10**10
HN = 100
RADIUS = 24
SHOOT = 20
DEGREE = 18
CONSTANTS = {
    "D": D,
    "AD": AD,
    "LD": LD,
    "HN": HN,
    "profile_radius": RADIUS,
    "shoot_radius": SHOOT,
    "degree": DEGREE,
}
BOUNDS = {
    "profile_residual": "1e-23",
    "profile_boundary": "1e-23",
    "profile_value_error": "1e-22",
    "profile_derivative_error": "4e-20",
    "riccati_residual": "1e-20",
    "riccati_source": "3e-19",
    "center_error_per_half": "1e-10",
    "sharpened_center_error_per_half": "3e-14",
    "mismatch_margin": "1e-9",
}
WINDOWS = {
    2936533: (2936535023, 2936535043, "positive"),
    2936535: (2936533037, 2936533057, "negative"),
}


class InvalidCertificate(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise InvalidCertificate(message)


def validate_certificate(cert):
    require(isinstance(cert, dict), "certificate must be an object")
    require(
        set(cert) == {"format", "claim", "constants", "analytic_bounds", "endpoints"},
        "unexpected or missing certificate fields",
    )
    require(cert["format"] == "whole-line-jamming-spectral-v1", "wrong format")
    require(cert["claim"] == "C222_SPECTRAL", "wrong claim")
    require(isinstance(cert["constants"], dict), "constants must be an object")
    require(all(type(value) is int for value in cert["constants"].values()),
            "constants must be integers, not floating approximations")
    require(cert["constants"] == CONSTANTS, "the theorem's constants were changed")
    require(cert["analytic_bounds"] == BOUNDS, "analytic bounds were changed")
    endpoints = cert["endpoints"]
    require(isinstance(endpoints, list) and len(endpoints) == 2, "need two endpoints")
    for endpoint, A in zip(endpoints, WINDOWS):
        require(isinstance(endpoint, dict), "endpoint must be an object")
        require(
            set(endpoint)
            == {
                "A", "m0_numerator", "k0_step_numerator", "lambda_seed_numerator",
                "lambda_window_numerators", "sharpened_lambda_window_numerators",
                "lambda_minus_a_sign",
            },
            "unexpected or missing endpoint fields",
        )
        for key in ["A", "m0_numerator", "k0_step_numerator", "lambda_seed_numerator"]:
            require(type(endpoint[key]) is int, f"{key} must be an integer")
        require(endpoint["A"] == A, "wrong parameter or endpoint order")
        lower, upper, sign = WINDOWS[A]
        for key in ["lambda_window_numerators", "sharpened_lambda_window_numerators"]:
            require(isinstance(endpoint[key], list)
                    and all(type(value) is int for value in endpoint[key]),
                    "eigenvalue windows must contain exact integers")
        require(endpoint["lambda_window_numerators"] == [lower, upper], "wrong target window")
        require(endpoint["lambda_minus_a_sign"] == sign, "wrong target sign")
        require(endpoint["lambda_seed_numerator"] * 2 == lower + upper, "wrong eigenvalue seed")
        seed = endpoint["lambda_seed_numerator"]
        require(endpoint["sharpened_lambda_window_numerators"] == [seed, seed + 1],
                "wrong sharpened window")
        require(endpoint["m0_numerator"] > 0, "nonpositive stationary seed")
        require(0 < HN * endpoint["k0_step_numerator"] < D, "invalid initial slope")


def bind_source(cert, path):
    text = path.read_text()
    start = text.index("\\begin{lstlisting}") + len("\\begin{lstlisting}")
    stop = text.index("\\end{lstlisting}", start)
    tree = ast.parse(text[start:stop])
    assignments = {
        node.targets[0].id: node.value
        for node in tree.body
        if isinstance(node, ast.Assign)
        and len(node.targets) == 1
        and isinstance(node.targets[0], ast.Name)
    }
    db = ast.literal_eval(assignments["db"])
    for endpoint in cert["endpoints"]:
        expected = [
            endpoint["m0_numerator"],
            endpoint["k0_step_numerator"],
            endpoint["lambda_seed_numerator"],
        ]
        require(db[endpoint["A"]] == expected, "seeds differ from the printed source")
    for name, expression in {
        "D": "10**36", "HN": "100", "L": "24", "DEG": "18",
        "LD": "10**10", "LQ": "20",
    }.items():
        expected = ast.parse(expression, mode="eval").body
        require(ast.dump(assignments[name]) == ast.dump(expected), f"source {name} changed")
    driver = next(
        node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == "driver"
    )
    changes = [
        node.value
        for node in driver.body
        if isinstance(node, ast.Assign)
        and any(isinstance(target, ast.Name) and target.id == "AD" for target in node.targets)
    ]
    expected = ast.parse("10**7", mode="eval").body
    require(len(changes) == 1 and ast.dump(changes[0]) == ast.dump(expected),
            "source endpoint denominator changed")


def derivative(c):
    return [n * c[n] for n in range(1, len(c))]


def product(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def add_scaled(out, coefficients, scale, shift=0):
    for n, value in enumerate(coefficients):
        out[n + shift] += scale * value


def convolution_coefficient(a, b, n):
    return sum(a[i] * b[n - i] for i in range(max(0, n + 1 - len(b)), min(n + 1, len(a))))


def stationary_trial(A, side, j, value, slope):
    c = [value, slope]
    denominator = HN**2 * AD * D
    for n in range(DEGREE - 1):
        rhs = ((AD * (1 - n) - 2 * A) * c[n] - j * (n + 1) * AD * c[n + 1]) * D
        rhs -= 2 * A * side * HN * convolution_coefficient(c, derivative(c), n)
        c.append(rhs // (denominator * (n + 2) * (n + 1)))
    return c


def stationary_residual(A, side, j, c):
    # Re-expand the physical differential equation independently of the recurrence.
    dc = derivative(c)
    out = [0] * (2 * DEGREE + 1)
    add_scaled(out, derivative(dc), HN**2 * AD * D)
    add_scaled(out, dc, j * AD * D)
    add_scaled(out, dc, AD * D, 1)
    add_scaled(out, product(c, dc), 2 * A * side * HN)
    add_scaled(out, c, -(AD - 2 * A) * D)
    return out


def check_stationary_cell(A, side, j, c):
    norm = sum(abs(x) for x in stationary_residual(A, side, j, c))
    require(norm * 10**23 < AD * D**2, f"stationary residual failed: {A}, {side}, {j}")
    center = -side * HN * c[1]
    radius = HN * sum(n * abs(c[n]) for n in range(2, len(c)))
    require((center - radius) * 100 >= -D, "stationary lower slope bound failed")
    require((center + radius) * 100 <= 101 * D, "stationary upper slope bound failed")
    return norm


def stationary_polynomials(endpoint):
    A = endpoint["A"]
    data = {}
    boundaries = []
    largest_residual = 0
    for side in [-1, 1]:
        value = endpoint["m0_numerator"]
        slope = -side * endpoint["k0_step_numerator"]
        cells = []
        for j in range(RADIUS * HN):
            c = stationary_trial(A, side, j, value, slope)
            largest_residual = max(largest_residual, check_stationary_cell(A, side, j, c))
            require(c[0] == value and c[1] == slope, "stationary join failed")
            value = sum(c)
            slope = sum(derivative(c))
            cells.append(c)
        boundaries.append(value - (RADIUS * D if side < 0 else 0))
        data[side] = cells
    require(data[-1][0][0] == data[1][0][0], "value mismatch at zero")
    require(-data[-1][0][1] == data[1][0][1], "physical slope mismatch at zero")
    require(max(abs(x) for x in boundaries) * 10**23 < D, "hinge boundary error failed")
    return data, largest_residual, boundaries


def reverse_polynomial(c):
    return [
        (-1)**j * sum(c[i] * math.comb(i, j) for i in range(j, len(c)))
        for j in range(len(c))
    ]


def riccati_coefficients(A, data):
    out = {}
    for side in [-1, 1]:
        cells = []
        for j, c in enumerate(data[side][:SHOOT * HN]):
            reversed_m = reverse_polynomial(c)
            require(reverse_polynomial(reversed_m) == c, "reversed polynomial identity failed")
            beta = [2 * A * side * x for x in reversed_m]
            beta[0] += AD * D * (j + 1) // HN
            beta[1] -= AD * D // HN
            k = [side * HN * x for x in derivative(reversed_m)]
            cells.append((beta, k))
        out[side] = cells
    return out


def tail_coefficients(A, eigenvalue, side):
    p = F(1, 2) - (F(A, AD) if side < 0 else 0)
    c = eigenvalue / p - 1
    require(F(-71, 100) < c < F(81, 100), "tail c outside certified range")
    require(side > 0 or c > F(-1, 100), "negative-side tail c too small")
    d = c * (c - 1) / (2 * p)
    e = (2 * c - 3) * d / (2 * p)
    K = (10 * abs(e) + 3 * d**2 + 30) / p
    require(abs(d) < F(7, 5) and abs(e) < 24 and K < 3066, "tail constants failed")
    return c, d, e


def riccati_trial(A, Lam, beta, k, initial):
    c = [initial]
    denominator = HN * LD * AD * D
    for n in range(DEGREE):
        rhs = LD * (
            convolution_coefficient(beta, c, n) - AD * convolution_coefficient(c, c, n)
        )
        if n < len(k):
            rhs -= 2 * LD * D * A * k[n]
        if n == 0:
            rhs += (LD - 2 * Lam) * AD * D**2
        c.append((-rhs) // (denominator * (n + 1)))
    return c


def riccati_residual(A, Lam, beta, k, c):
    out = [0] * (2 * DEGREE + 1)
    add_scaled(out, derivative(c), -HN * LD * AD * D)
    add_scaled(out, product(beta, c), -LD)
    add_scaled(out, product(c, c), LD * AD)
    add_scaled(out, k, 2 * LD * D * A)
    out[0] += (2 * Lam - LD) * AD * D**2
    return out


def check_riccati_cell(A, Lam, beta, k, c):
    norm = sum(abs(x) for x in riccati_residual(A, Lam, beta, k, c))
    require(norm * 10**20 < LD * AD * D**2, "Riccati residual failed")
    require(sum(abs(x) for x in c) * 100 < 95 * D, "Riccati trial magnitude failed")
    return norm


def shoot(A, Lam, coefs):
    ends = []
    drift_bounds = []
    largest_residual = 0
    sample = None
    for side in [-1, 1]:
        c, d, e = tail_coefficients(A, F(Lam, LD), side)
        initial = c / SHOOT + d / SHOOT**3 + e / SHOOT**5
        value = initial.numerator * D // initial.denominator
        require(0 <= initial - F(value, D) < F(1, D), "tail rounding error failed")
        total_drift = negative_drift = exterior_drift = 0
        for j in range(SHOOT * HN - 1, -1, -1):
            beta, k = coefs[side][j]
            trial = riccati_trial(A, Lam, beta, k, value)
            largest_residual = max(
                largest_residual, check_riccati_cell(A, Lam, beta, k, trial)
            )
            require(trial[0] == value, "Riccati continuity failed")
            value = sum(trial)
            g = (
                beta[0] - sum(abs(x) for x in beta[1:])
                - 2 * AD * (trial[0] + sum(abs(x) for x in trial[1:]))
                - AD * D // 500
            )
            total_drift += g
            negative_drift += min(g, 0)
            if j >= 1203:
                exterior_drift += g
            if sample is None:
                sample = (A, Lam, beta, k, trial)
        require(total_drift > 20 * HN * AD * D, "total inward damping failed")
        require(negative_drift > -2 * HN * AD * D, "negative drift budget failed")
        require(exterior_drift > 8 * HN * AD * D, "exterior damping failed")
        ends.append(value)
        drift_bounds.append((total_drift, negative_drift, exterior_drift))
    return sum(ends), largest_residual, drift_bounds, sample


def exp_lower(x, terms=128):
    term = total = F(1)
    for n in range(1, terms + 1):
        term *= x / n
        total += term
    return total


def exp_upper(x, terms=32):
    total = exp_lower(x, terms)
    next_term = x**(terms + 1) / math.factorial(terms + 1)
    require(0 <= x < terms + 2, "invalid exponential tail majorant")
    return total + next_term / (1 - x / (terms + 2))


def analytic_inequalities():
    p, a = F(9, 100), F(41, 100)
    dm, dk, rm = F("1e-22"), F("4e-20"), F("1e-23")
    require(4 * sum((F((-1)**j, 2 * j + 1) for j in range(64)), F(0)) > F(25, 8),
            "elementary lower bound for pi failed")
    require(2 * p - 2 * a / 100 > F(17, 100), "proper damping failed")
    require(F(17, 100) * dm > rm, "constant error barrier failed")
    for rate, divisor in [(F(1, 2), F(RADIUS)), (p, 2 * p * RADIUS)]:
        tail = 1 / (divisor * exp_lower(rate * RADIUS**2))
        require(tail + rm < dm, "true-profile boundary allowance failed")
    require(F(34, 100)**2 / p < F(129, 100), "negative drift area failed")
    require(F(1, 20) + a * F(4, 5) < F(38, 100), "central drift cap failed")
    f = F("2.1e-22")
    require((1 + 2 * a / 100) * dm + rm < f, "profile derivative source failed")
    require(exp_upper(F(129, 100)) < 4, "exp(1.29) cap failed")
    require(exp_upper(F(76, 1000)) < F(27, 25), "exp(.076) cap failed")
    f0 = (2 * dm + F(1, 200) * 4 * f) * F(27, 25) * 10
    require(f0 < F("2.4e-21"), "initial derivative estimate failed")
    require(4 * (F("2.4e-21") + RADIUS * f) < dk, "global derivative estimate failed")

    x, d, e, K = F(12), F(7, 5), F(24), F(3066)
    require(F(1215, 1000) < d and F(1, 4) / (2 * p) < d, "d bound failed")
    require(F(302, 100) * d / (2 * p) < e, "negative-side e bound failed")
    require(F(442, 100) * F(1215, 1000) < e, "positive-side e bound failed")
    pK = 10 * e + 3 * d**2 + 30
    require(pK / p < K, "K bound failed")
    require(F(442, 100) / (2 * p * x**2) < 1, "d/e correction sign failed")
    require(F(171, 100) / (2 * p * x**2) < 1, "tail leading-term sign failed")
    require(2 * d * e / x**2 + e**2 / x**4 < 1, "tail residual remainder failed")
    shift_ratio = (
        (7 + F(162, 100) + 2 * d / x**2 + 2 * e / x**4) / x**2 + K / x**8
    )
    require(shift_ratio < F(7, 10) * p, "barrier perturbation budget failed")
    require(F(81, 100) / x + d / x**3 + e / x**5 + K / x**7 < F(71, 1000),
            "tail log-slope bound failed")
    exp12 = exp_lower(p * x**2)
    require(a / (2 * p * exp12) < F(1, 100), "tail drift correction cap failed")
    coefficient_cost = (a * F(71, 1000) / (p * x) + 2 * a) * x**6 / exp12
    require(coefficient_cost < 8, "true tail coefficient allowance failed")
    require(2 * p * x - a / (p * x * exp12) - F(142, 1000) > p * x,
            "tail uniqueness damping failed")
    derivative_bound = 2 * d / x**3 + (
        4 * e + F(662, 100) * e + d**2 + 9 + 2 * pK
        + F(264, 100) * K / x**2 + K**2 / x**8
    ) / x**5
    require(derivative_bound < F(514, 100000), "tail derivative bound failed")

    tder = (
        1 / (p * SHOOT)
        + F(262, 100) / (2 * p**2 * SHOOT**3)
        + (6 * F(81, 100)**2 + 10 * F(81, 100) + 3) / (4 * p**3 * SHOOT**5)
    )
    require(tder < F(3, 5), "tail dependence on lambda failed")
    initial = F("2.41e-6")
    require(K / SHOOT**7 + F(3, 5) * F("1e-9") + F(1, D) < initial,
            "initial Riccati allowance failed")
    source = F("3e-19")
    require(2 * a * dm * F(95, 100) + 2 * a * dk + F("1e-20") < source,
            "Riccati source allowance failed")
    require(F(1, 1000) + 2 * a * dm < F(1, 500), "drift subtraction failed")
    require(exp_upper(F(2)) < F(15, 2), "exp(2) cap failed")
    require(exp_lower(F(6)) > 400, "exterior integrating factor cap failed")
    require(exp_lower(F(20)) > 10**8, "center integrating factor cap failed")
    window_source = 2 * F("1e-9") + source
    require(F(15, 2) * (initial + SHOOT * window_source) < F("2.9e-5"),
            "global Riccati bootstrap failed")
    require(initial / 400 + SHOOT * F(15, 2) * window_source < F("4.5e-7"),
            "central Riccati error failed")
    require(initial / 10**8 + SHOOT * F(15, 2) * source < F("1e-10"),
            "endpoint Riccati error at zero failed")
    require(initial / 10**8 + SHOOT * F(15, 2) * source < F("3e-14"),
            "sharpened endpoint Riccati error at zero failed")


def expect_rejection(action):
    try:
        action()
    except InvalidCertificate:
        return
    raise InvalidCertificate("an intentionally invalid certificate was accepted")


def rejection_tests(cert, stationary_sample, riccati_sample):
    changed = copy.deepcopy(cert)
    changed["constants"]["AD"] = 10**6
    expect_rejection(lambda: validate_certificate(changed))
    changed = copy.deepcopy(cert)
    changed["endpoints"][0]["lambda_window_numerators"][0] += 1
    expect_rejection(lambda: validate_certificate(changed))
    changed = copy.deepcopy(cert)
    changed["endpoints"][0]["sharpened_lambda_window_numerators"][1] = 2936535034.0
    expect_rejection(lambda: validate_certificate(changed))
    A, side, j, c = stationary_sample
    changed_m = c.copy()
    changed_m[-1] += D
    expect_rejection(lambda: check_stationary_cell(A, side, j, changed_m))
    A, Lam, beta, k, c = riccati_sample
    changed_s = c.copy()
    changed_s[-1] += D
    expect_rejection(lambda: check_riccati_cell(A, Lam, beta, k, changed_s))
    return 5


def verify(cert, self_test=False):
    validate_certificate(cert)
    analytic_inequalities()
    results = []
    stationary_sample = riccati_sample = None
    for endpoint in cert["endpoints"]:
        A, seed = endpoint["A"], endpoint["lambda_seed_numerator"]
        data, mres, boundaries = stationary_polynomials(endpoint)
        if stationary_sample is None:
            stationary_sample = (A, -1, 0, data[-1][0])
        coefs = riccati_coefficients(A, data)
        trials = []
        for Lam in [seed - 10, seed, seed + 1, seed + 10]:
            mismatch, qres, drifts, sample = shoot(A, Lam, coefs)
            if riccati_sample is None:
                riccati_sample = sample
            if Lam < seed:
                require(mismatch * 10**9 < -D, "lower center matching sign failed")
            if Lam == seed + 10:
                require(mismatch * 10**9 > D, "upper center matching sign failed")
            if Lam == seed:
                require(mismatch * 10**14 < -6 * D, "sharpened lower matching sign failed")
            if Lam == seed + 1:
                require(mismatch * 10**14 > 6 * D, "sharpened upper matching sign failed")
            trials.append({
                "lambda_numerator": Lam,
                "mismatch_numerator_over_D": mismatch,
                "riccati_residual_norm_over_LD_AD_D_squared": qres,
                "drift_integral_numerators_over_HN_AD_D": drifts,
            })
        lower, upper, sign = WINDOWS[A]
        signed_gap = lower - A * (LD // AD) if sign == "positive" else upper - A * (LD // AD)
        require(signed_gap > 0 if sign == "positive" else signed_gap < 0,
                "the certified window does not imply the target sign")
        results.append({
            "A": A,
            "stationary_cells": 2 * RADIUS * HN,
            "riccati_cells": 8 * SHOOT * HN,
            "stationary_residual_norm_over_AD_D_squared": mres,
            "boundary_error_numerators_over_D": boundaries,
            "lambda_window_numerators_over_LD": [lower, upper],
            "sharpened_lambda_window_numerators_over_LD": [seed, seed + 1],
            "signed_gap_bound_numerator_over_LD": signed_gap,
            "trials": trials,
        })
    rejected = rejection_tests(cert, stationary_sample, riccati_sample) if self_test else 0
    return {
        "claim": "C222_SPECTRAL",
        "finite_premises_verified": True,
        "analytic_argument": "report.md: profile construction, comparison, tails, matching and ground-state identity",
        "not_a_Lean_or_independent_Reviewer_verdict": True,
        "invalid_certificate_tests_rejected": rejected,
        "endpoints": results,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path,
                        default=Path(__file__).with_name("exact_certificate.json"))
    parser.add_argument("--source", type=Path, help="also bind seeds and constants to the printed LaTeX listing")
    parser.add_argument("--self-test", action="store_true", help="reject five deliberately corrupted premises")
    parser.add_argument("--details", action="store_true", help="print exact integer residual and drift diagnostics")
    args = parser.parse_args()
    try:
        cert = json.loads(args.certificate.read_text())
        validate_certificate(cert)
        if args.source is not None:
            bind_source(cert, args.source)
        result = verify(cert, args.self_test)
    except InvalidCertificate as error:
        parser.exit(1, f"REJECTED: {error}\n")
    result["source_bound"] = args.source is not None
    if not args.details:
        for endpoint in result["endpoints"]:
            for key in [
                "trials", "stationary_residual_norm_over_AD_D_squared",
                "boundary_error_numerators_over_D",
            ]:
                del endpoint[key]
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
