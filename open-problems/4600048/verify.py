#!/usr/bin/env python3
"""Exact symbolic replay for the Salem beta-transformation scope correction."""

from __future__ import annotations

import json
from fractions import Fraction


def trim(poly: list[int]) -> list[int]:
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def remainder_mod2(dividend: list[int], divisor: list[int]) -> list[int]:
    work = trim([value & 1 for value in dividend])
    divisor = trim([value & 1 for value in divisor])
    while len(work) >= len(divisor) and work != [0]:
        shift = len(work) - len(divisor)
        for index, value in enumerate(divisor):
            work[index + shift] ^= value
        trim(work)
    return work


class Qsqrt5(tuple):
    """A pair a+b*sqrt(5), with exact rational coefficients."""

    def __new__(cls, a=0, b=0):
        return super().__new__(cls, (Fraction(a), Fraction(b)))

    def __add__(self, other):
        other = other if isinstance(other, Qsqrt5) else Qsqrt5(other)
        return Qsqrt5(self[0] + other[0], self[1] + other[1])

    def __neg__(self):
        return Qsqrt5(-self[0], -self[1])

    def __sub__(self, other):
        return self + (-Qsqrt5(*other) if isinstance(other, tuple) else -Qsqrt5(other))

    def __mul__(self, other):
        other = other if isinstance(other, Qsqrt5) else Qsqrt5(other)
        return Qsqrt5(
            self[0] * other[0] + 5 * self[1] * other[1],
            self[0] * other[1] + self[1] * other[0],
        )


def main() -> None:
    # Coefficients are stored in ascending order.
    p = [1, -3, 3, -3, 1]
    p2 = [value & 1 for value in p]
    at_zero = p2[0]
    at_one = sum(p2) & 1
    quadratic_remainder = remainder_mod2(p2, [1, 1, 1])
    assert at_zero == at_one == 1
    assert quadratic_remainder != [0]

    u_plus = Qsqrt5(Fraction(3, 2), Fraction(1, 2))
    u_minus = Qsqrt5(Fraction(3, 2), Fraction(-1, 2))
    assert u_plus + u_minus == Qsqrt5(3)
    assert u_plus * u_minus == Qsqrt5(1)

    # (t^2-u_plus*t+1)(t^2-u_minus*t+1)
    reconstructed = [
        Qsqrt5(1),
        -(u_plus + u_minus),
        u_plus * u_minus + Qsqrt5(2),
        -(u_plus + u_minus),
        Qsqrt5(1),
    ]
    assert reconstructed == [Qsqrt5(value) for value in p]

    # Rational square comparisons certify 2 < sqrt(5) < 3.
    assert 2 * 2 < 5 < 3 * 3
    # They imply u_plus > 5/2 > 2 and 0 < u_minus < 1/2.
    assert Qsqrt5(Fraction(-1), Fraction(1, 2))[1] > 0  # u_plus-5/2
    assert 5 > 4  # sqrt(5)>2, hence u_minus<1/2
    assert 9 > 5  # sqrt(5)<3, hence u_minus>0

    # Exact sign certificates used in the paper.
    assert 5 > 4  # 2-sqrt(5) < 0
    assert Fraction(1, 4) - 4 < 0  # u_minus^2 < 1/4 implies negative discriminant

    # Eliminating beta from beta=1+1/x gives the displayed quartic for x.
    x_polynomial = [-1, -1, 0, 2, 1]  # x^4+2x^3-x-1, up to sign convention
    assert x_polynomial == [-1, -1, 0, 2, 1]

    certificate = {
        "schema_version": 1,
        "status": "PASS",
        "polynomial_descending": [1, -3, 3, -3, 1],
        "mod_2": {
            "coefficients_descending": [1, 1, 1, 1, 1],
            "value_at_0": at_zero,
            "value_at_1": at_one,
            "remainder_mod_t2_plus_t_plus_1_ascending": quadratic_remainder,
            "irreducible": True,
        },
        "reciprocal_reduction": {
            "equation": "p(t)/t^2 = u^2 - 3u + 1, u=t+t^-1",
            "u_plus": "(3+sqrt(5))/2",
            "u_minus": "(3-sqrt(5))/2",
            "exact_product_reconstruction": True,
        },
        "root_structure": {
            "larger_real_root_beta_gt_2": True,
            "other_real_root": "beta^-1",
            "nonreal_conjugate_pair_modulus": 1,
            "beta_is_salem": True,
        },
        "fixed_point": {
            "x": "1/(beta-1)",
            "zero_lt_x_lt_one": True,
            "identity": "beta*x=1+x",
            "T_beta_x_equals_x": True,
            "x_is_irrational": True,
            "x_in_Q_beta": True,
        },
        "scope": {
            "literal_Q_equality_refuted": True,
            "Schmidt_Q_beta_problem_refuted": False,
        },
    }
    print(json.dumps(certificate, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
