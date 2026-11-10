#!/usr/bin/env python3
"""Check exact angle integrals and rational bounds for the transport scalar."""

from fractions import Fraction as F
from math import isqrt

import mpmath as mp
import sympy as sp


def atan_bounds(x, terms):
    partial = sum((-1) ** k * x ** (2 * k + 1) / (2 * k + 1)
                  for k in range(terms))
    next_partial = partial + (-1) ** terms * x ** (2 * terms + 1) / (2 * terms + 1)
    return min(partial, next_partial), max(partial, next_partial)


a, b = sp.symbols("a b", real=True)
w = sp.sin(a) * sp.sin(b) * sp.sin(a + b)
normal = sp.integrate(sp.integrate(sp.expand_trig(w), (b, 0, sp.pi - a)),
                      (a, 0, sp.pi))
moment = sp.integrate(sp.integrate(sp.expand_trig(w * sp.sin(a) ** 2),
                                 (b, 0, sp.pi - a)), (a, 0, sp.pi))
assert normal == 3 * sp.pi / 8
assert moment == 15 * sp.pi / 64
assert sp.simplify(moment / normal) == sp.Rational(5, 8)
print("Exact angle integrals: normalizer 3*pi/8, sin^2 moment ratio 5/8.")

lo5, hi5 = atan_bounds(F(1, 5), 16)
lo239, hi239 = atan_bounds(F(1, 239), 6)
tan4 = F(1, 5)
for _ in range(2):
    tan4 = 2 * tan4 / (1 - tan4 ** 2)
assert (tan4 - F(1, 239)) / (1 + tan4 / 239) == 1
assert 0 < 4 * lo5 - hi239 < 4 * hi5 - lo239 < F(4, 5)
pi_lo, pi_hi = 16 * lo5 - 4 * hi239, 16 * hi5 - 4 * lo239
scale = 10 ** 20
floor = isqrt(3 * scale * scale)
root_lo, root_hi = F(floor, scale), F(floor + 1, scale)
assert root_lo ** 2 < 3 < root_hi ** 2
r_lo = 5 * root_lo / (4 * pi_hi) - F(1, 2)
r_hi = 5 * root_hi / (4 * pi_lo) - F(1, 2)
assert 0 < r_lo < r_hi
lower, upper = F(285120, 10 ** 6), F(285121, 10 ** 6)
assert lower ** 2 + (2 * lower - 1) * r_lo < 0
assert upper ** 2 + (2 * upper - 1) * r_hi > 0
assert 1 - 2 * upper == F(429758, 10 ** 6)
print("Rational certificate: 0.285120 < sqrt(r*(1+r))-r < 0.285121.")
print("Thus Re(a) < 0.285121 and 1-2*Re(a) > 0.429758.")
try:
    assert F(28, 100) ** 2 + (2 * F(28, 100) - 1) * r_hi > 0
except AssertionError:
    print("REJECT falsely tightened bound Re(a) <= 0.28 from this disk.")
else:
    raise AssertionError("incorrect constant was accepted")

mp.mp.dps = 40
cardy = lambda x: mp.betainc(mp.mpf(1) / 3, mp.mpf(1) / 3, 0, x, regularized=True)
print("Illustrative decimals only; not percolation simulation or error certificates:")
for aspect in (1, 2, 3):
    q = mp.exp(-mp.pi * aspect)
    x = (mp.jtheta(2, 0, q) / mp.jtheta(3, 0, q)) ** 4
    p = cardy(x)
    hyper = (3 * mp.gamma(mp.mpf(2) / 3) / mp.gamma(mp.mpf(1) / 3) ** 2
             * x ** (mp.mpf(1) / 3)
             * mp.hyp2f1(mp.mpf(1) / 3, mp.mpf(2) / 3, mp.mpf(4) / 3, x))
    assert abs(p - hyper) < mp.mpf("1e-35")
    assert abs(cardy(x) + cardy(1 - x) - 1) < mp.mpf("1e-35")
    print(f"width/height={aspect}: x={mp.nstr(x, 15)}, F(x)={mp.nstr(p, 15)}")
