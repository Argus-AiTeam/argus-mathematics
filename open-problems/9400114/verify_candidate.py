"""Search-independent coefficientwise verifier for the original conjecture."""

import argparse
import json
import math
from pathlib import Path


def cyclic_product(left, right, modulus):
    size = len(left)
    result = [0] * size
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[(i + j) % size] += a * b
    return [a % modulus for a in result]


def coefficients(exponent, r, modulus):
    result = [1] + [0] * (r - 1)
    base = [0] * r
    base[0] -= 1
    base[1 % r] += 1
    remaining = exponent
    while remaining:
        if remaining & 1:
            result = cyclic_product(result, base, modulus)
        remaining //= 2
        if remaining:
            base = cyclic_product(base, base, modulus)
    right = [0] * r
    right[exponent % r] += 1
    right[0] -= 1
    right = [a % modulus for a in right]
    return result, right, [(a - b) % modulus for a, b in zip(result, right)]


def read_integer(value):
    if type(value) is int:
        return value
    if isinstance(value, str) and value.isascii() and value.isdecimal():
        if value == str(int(value)):
            return int(value)
    raise ValueError("n, r, and d must be canonical nonnegative integers")


def verify(candidate):
    n, r, d = (read_integer(candidate[key]) for key in ("n", "r", "d"))
    if n < 2 or r < 1:
        raise ValueError("the arithmetic verifier requires n >= 2 and r >= 1")
    left, right, residual = coefficients(n, r, n)
    checks = {
        "proper_divisor": 1 < d < n,
        "divides_n": d > 0 and n % d == 0,
        "coprime": math.gcd(n, r) == 1,
        "failed_conclusion": (n * n - 1) % r != 0,
        "full_ring_identity": not any(residual),
    }
    return {
        "n": str(n),
        "r": r,
        "d": str(d),
        "gcd_n_r": math.gcd(n, r),
        "n_squared_mod_r": n * n % r,
        "coefficient_modulus": str(n),
        "left_coefficients": [str(a) for a in left],
        "right_coefficients": [str(a) for a in right],
        "residual_coefficients": [str(a) for a in residual],
        "checks": checks,
        "is_counterexample": all(checks.values()),
        "independent_reviewer_replay": "not_asserted",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    args = parser.parse_args()
    result = verify(json.loads(args.candidate.read_text()))
    print(json.dumps(result, indent=2))
    return 0 if result["is_counterexample"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
