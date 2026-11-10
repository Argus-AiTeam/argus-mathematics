#!/usr/bin/env python3
"""Exact local checks, not a verification of geometric propagation.

Run: python3 guide/evidence/elliptic_geometry_check.py --self-test
The JSON specifies dyadic product-law instances and the signs to be checked.
The infinite-scale proof and the meaning of the exponent ceiling belong in
the elliptic-capacity reader's guide, not in this checker.
"""

import argparse
import copy
from fractions import Fraction
import json
from pathlib import Path


class CheckFailure(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise CheckFailure(message)


class Polynomial:
    def __init__(self, terms):
        self.terms = {key: value for key, value in terms.items() if value}

    @staticmethod
    def coerce(value):
        if isinstance(value, Polynomial):
            return value
        return Polynomial({(): Fraction(value)})

    def __add__(self, other):
        result = dict(self.terms)
        for key, value in self.coerce(other).terms.items():
            result[key] = result.get(key, 0) + value
        return Polynomial(result)

    __radd__ = __add__

    def __neg__(self):
        return Polynomial({key: -value for key, value in self.terms.items()})

    def __sub__(self, other):
        return self + -self.coerce(other)

    def __rsub__(self, other):
        return self.coerce(other) + -self

    def __mul__(self, other):
        result = {}
        for left, a in self.terms.items():
            for right, b in self.coerce(other).terms.items():
                key = tuple(sorted(left + right))
                result[key] = result.get(key, 0) + a * b
        return Polynomial(result)

    __rmul__ = __mul__


def symbols(names):
    return [Polynomial({(name,): Fraction(1)}) for name in names.split()]


def identity(left, right, name):
    require(not (left - right).terms, f"Polynomial identity failed: {name}")


def check_identities(data):
    x, y, z, w, dr, dt = symbols("x y z w dr dt")
    yd = y - dr * x
    zd = z + dt * x
    wd = w + dt * y - dr * z + data["mixed_shear_sign"] * dt * dr * x
    identity(
        wd - dt * yd + dr * zd,
        w + data["overlap_product_sign"] * dr * dt * x,
        "proj:overlap-identity, including the mixed shear term",
    )

    p, n, e, g, t, r, k, m, lam = symbols("p n e g t r k m lam")
    kl, kn = p + e, n + g
    parameter = t + lam * r
    gain = (
        t + lam * r - m * p - (m - lam) * n
        + (1 - m) * e + (1 - m + lam) * g
        + (1 + k) * m + (1 - k) * (m - lam)
    )
    identity(
        gain,
        parameter + e + g + m * (2 - kl - kn) + lam * (kn - 1 + k),
        "eq:source-19 to eq:source-23",
    )
    midpoint = (lam + 1) * Fraction(1, 2)
    midpoint_gain = (
        parameter + e + g + midpoint * (2 - kl - kn)
        + lam * (kn - 1 + k)
    )
    identity(
        midpoint_gain,
        parameter + 1 - p + g + (lam - 1) * Fraction(1, 2) * (kn - kl) + k * lam,
        "asp:increasing-zero, lambda > 1 midpoint",
    )

    a, b, q, nn, u = symbols("a b q nn u")
    identity(
        k * (a - b) + a * (u - p) - b * nn + (1 - a) * p,
        k * (a - b) + a * (u - p - nn) + (a - b) * nn + (1 - a) * p,
        "eq:source-26, clipped normal output",
    )
    identity(
        k * (a - b) + p + q - u + a * (u - 2 * p) + b * (u - nn - q),
        k * (a - b) + (1 - b) * (p + q - u)
        + (a - b) * (u - 2 * p) + b * (u - p - nn),
        "eq:source-26, unclipped normal output",
    )

    loss, dilation, tau, c = symbols("loss dilation tau c")
    identity(
        2 * loss - 8 * (loss + tau),
        -6 * loss - 8 * tau,
        "geo:heavy-count, with kappa*c = 4",
    )
    identity(
        (3 + c) * loss + 6 * dilation + c * tau
        - (c + 10) * (loss + dilation + tau),
        -7 * loss - (c + 4) * dilation - 10 * tau,
        "geo:angular-exclusion",
    )


def check_dyadic_profile(alpha, depth, supplied_counts=None):
    counts = (
        [int(alpha * j) for j in range(depth + 1)]
        if supplied_counts is None else supplied_counts
    )
    require(len(counts) == depth + 1, "Wrong number of prefix counts")
    require(counts[0] == 0, "A depth-zero partition has one cell")
    for j, count in enumerate(counts):
        require(type(count) is int, "A free-bit count must be an integer")
        require(0 <= alpha * j - count < 1, "Dyadic support/weight exponent failed")
        if j:
            require(count - counts[j - 1] in (0, 1), "Invalid binary branching")
        for parent in range(j + 1):
            discrepancy = count - counts[parent] - alpha * (j - parent)
            require(-1 < discrepancy < 1, "Conditional descendant profile failed")
    return counts


def check_ellipse_sections(kappa, short_sign):
    rotations = [
        (Fraction(1), Fraction(0)),
        (Fraction(0), Fraction(1)),
        (Fraction(3, 5), Fraction(4, 5)),
        (Fraction(5, 13), Fraction(12, 13)),
    ]
    radii = [Fraction(1, 2**j) for j in (0, 1, 2, 4, 7)]
    numerator, denominator = kappa.numerator, kappa.denominator
    checked = 0
    for long in radii:
        for short in radii:
            if short > long:
                continue
            for cosine, sine in rotations:
                require(cosine * cosine + sine * sine == 1, "Invalid rotation")
                qxx = long * long * cosine * cosine + short * short * sine * sine
                qyy = long * long * sine * sine + short * short * cosine * cosine
                qxy = (long * long - short * short) * cosine * sine
                determinant = qxx * qyy - qxy * qxy
                require(determinant == (long * short) ** 2, "Ellipse determinant failed")
                height_squared = qyy
                section_squared = determinant / qyy
                require(short**2 <= height_squared <= long**2, "Projection radius failed")
                require(short**2 <= section_squared <= long**2, "Section radius failed")
                # Squaring and raising to the denominator removes every radical.
                left = (
                    section_squared ** (denominator + numerator)
                    * height_squared ** (denominator - numerator)
                )
                right = (
                    long ** (2 * (denominator + numerator))
                    * short ** (2 * (denominator + short_sign * numerator))
                )
                require(left <= right, "Rotated product-law capacity bound failed")
                checked += 1
    return checked


def check(data):
    check_identities(data)
    results = []
    for instance in data["instances"]:
        kappa = Fraction(instance["kappa"])
        s = Fraction(instance["s"])
        depth = instance["depth"]
        require(0 < kappa < Fraction(1, 10), "kappa outside the paper's range")
        require(0 < s <= 1, "s outside the paper's range")
        require(type(depth) is int and 1 <= depth <= 256, "Invalid finite depth")
        check_dyadic_profile(kappa, depth)
        normal_counts = check_dyadic_profile(1 - kappa, depth)
        time_counts = check_dyadic_profile(s, depth, instance.get("time_free_counts"))
        exponent = 1 + depth + time_counts[-1] + normal_counts[-1]
        require(
            exponent <= 1 + (2 + s - kappa) * depth,
            "Terminal support exceeds the proposed covering bound",
        )
        section_tests = check_ellipse_sections(kappa, data["capacity_short_kappa_sign"])
        results.append({
            "kappa": str(kappa),
            "s": str(s),
            "depth": depth,
            "terminal_cover_count": str(2**exponent),
            "terminal_cover_log2": exponent,
            "ceiling_exponent": str(2 + s - kappa),
            "exact_ellipse_checks": section_tests,
        })
    return results


def rejection_tests(data):
    mutations = []
    for field in ("mixed_shear_sign", "overlap_product_sign", "capacity_short_kappa_sign"):
        changed = copy.deepcopy(data)
        changed[field] *= -1
        mutations.append((field, changed))
    changed = copy.deepcopy(data)
    changed["instances"][0]["time_free_counts"] = [0] * (changed["instances"][0]["depth"] + 1)
    mutations.append(("concentrated time law", changed))
    for name, changed in mutations:
        try:
            check(changed)
        except CheckFailure:
            continue
        raise CheckFailure(f"Negative control was accepted: {name}")
    return [name for name, _ in mutations]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "witness", nargs="?", type=Path,
        default=Path(__file__).with_name("elliptic_geometry_witness.json"),
    )
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    data = json.loads(args.witness.read_text())
    output = {"instances": check(data)}
    if args.self_test:
        output["rejected_negative_controls"] = rejection_tests(data)
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
