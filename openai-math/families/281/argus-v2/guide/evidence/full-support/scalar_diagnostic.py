#!/usr/bin/env python3
"""Print explicit SK trial values; floating-point diagnostics are not certificates."""

import math


def constant_trial(c):
    if not math.isfinite(c) or c < 0:
        raise ValueError("the coefficient must be finite and nonnegative")
    if c == 0:
        return math.sqrt(2 / math.pi)
    return c / 4 + math.log1p(math.erf(c / math.sqrt(2))) / c


def main():
    print("Explicit trial values, xi(t)=t^2/2 (floating-point diagnostics):")
    print(f"P(0) = {constant_trial(0):.12f}")
    print(f"P(4/5) = {constant_trial(4 / 5):.12f}")
    print(f"q_0(1/2) = {2 / math.pi * math.asin(0.5):.12f}")
    print(f"q_0'(0) = {2 / math.pi:.12f}")
    print(f"terminal layer constant = {2 * math.sqrt(2) / math.pi:.12f}")
    print("Published numerical benchmark: P_* approximately 0.763166")
    print("Source: Montanari, arXiv:1812.10897v2, section 1.1, printed p. 4.")
    print("Neither trial is the minimizing order parameter.")


if __name__ == "__main__":
    main()
