#!/usr/bin/env python3
"""Replay the exact algebra in REPORT.md; this is not an analytic proof checker."""

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def universal_identities():
    q, U, T, A, B, t, A0 = sp.symbols("q U T A B t A0")
    identities = {
        "geometric_induction_step": q * U - (U + (1 - 1 / q) * q * U),
        "triple_valuation_step": 1 / (q * U) - (1 / q) * (1 / U),
        "positive_valuation_majorant_margin": (
            1 - ((q - 1) / q) ** 2 - (2 * q - 1) / q**2
        ),
    }
    kernel = (1, 0, B / T**4)
    for r in range(3):
        shells = [sp.Integer(0)] * 3
        shells[-r % 3] += U
        terminal_integral = (B / T**6, A / T**6, -1 / T**6)[r]
        shells[(r + 2) % 3] += U * T ** (2 * (r + 1)) * terminal_integral
        common = T ** (-4 * r) / U**2
        spherical_value = (1 / U, A / (T**6 * U), sp.Integer(0))[r]
        for coordinate in range(3):
            identities[f"Jacquet_class_{r}_coordinate_{coordinate}"] = (
                common * shells[coordinate] - spherical_value * kernel[coordinate]
            )
    relation = sp.groebner([A * B - q, T**6 - q], A, B, T, U, q)
    remainders = {}
    for name, expression in identities.items():
        numerator, _ = sp.fraction(sp.cancel(expression))
        remainder = relation.reduce(sp.expand(numerator))[1]
        require(remainder == 0, f"Universal identity failed: {name}")
        remainders[name] = str(remainder)

    phase_checks = 0
    for e_class in range(6):
        require(
            (4 * (e_class - 2) - 4 * e_class) % 6 == 4,
            "The reflected digit exponent is not 4 modulo 6",
        )
        for j in range(6):
            require(
                (4 + (4 - j)) % 6 == (8 - j) % 6,
                "The zero-valuation unit exponent has the wrong orientation",
            )
            phase_checks += 1
    require((1 - 4) % 6 == 3, "The row-column pairing is not quadratic")
    require((2 * 3) % 6 == 0, "A cube column has an extra spherical unit phase")

    M = sp.Rational(1033, 1000)
    delta = t / 16
    delta1 = t / (32 * M)
    delta2 = t / (16 * (3 * M + 1))
    delta3 = t / 16
    loss = delta + 2 * M * delta1 + (3 * M - 1 + delta) * delta2 + delta3
    margin = sp.factor(t / 4 - loss)
    expected_margin = t * (32 - t) / (256 * (3 * M + 1))
    require(sp.cancel(margin - expected_margin) == 0, "Power-loss margin failed")
    N = 1 + (A0 + 2 * M * delta1 + 2 * (2 * M - 1) + 1) / (2 * delta)
    tail_exponent = 2 * M * delta1 + 2 * (2 * M - 1) - 2 * delta * (N - 1)
    require(
        sp.cancel(tail_exponent + A0 + 1) == 0,
        "The chosen tail exponent does not give the asserted saving",
    )
    x = sp.symbols("x", nonnegative=True)
    require(
        sp.expand((2 * q - 1).subs(q, x + 2)) == 2 * x + 3,
        "The local squared-majorant margin is not positive for q >= 2",
    )
    return {
        "domain": "q>1; k>=0 integer; U=q^k; T=q^(1/6); A*B=q",
        "method": "polynomial zero remainders and an explicit induction step",
        "geometric_base": "C_0=1=q^0",
        "shell_construction": {
            "common_factor_for_e_3k_r": "U^(-2) T^(-4r)",
            "combined_ball_and_trivial_shells": "U e_(-r mod 3)",
            "terminal_integrals_by_r": ["B/T^6", "A/T^6", "-1/T^6"],
            "terminal_measure_times_norm": "U T^(2(r+1))",
            "terminal_basis_index": "(r+2) mod 3",
        },
        "zero_remainders": remainders,
        "phase_residue_checks": phase_checks,
        "zero_valuation_unit_exponents_by_j": [(8 - j) % 6 for j in range(6)],
        "positive_valuation_support": "Only j=4 and e=3k or 3k+1; e>0",
        "positive_valuation_recurrence": "R(j,e+3,t)=q^(-1)R(j,e,t), e>=1",
        "quadratic_pairing_exponent": (1 - 4) % 6,
        "unrestricted_cube_unit_exponent": (2 * 3) % 6,
        "power_losses": {
            "M": str(M),
            "t": "min(epsilon,1), hence 0<t<=1",
            "delta": str(delta),
            "delta1": str(delta1),
            "delta2": str(delta2),
            "delta3": str(delta3),
            "total_loss": str(sp.factor(loss)),
            "t_over_4_minus_loss": str(margin),
            "positivity_reason": "t>0 and 32-t>=31",
            "tail_N": str(sp.factor(N)),
            "tail_Z_exponent": str(sp.cancel(tail_exponent)),
        },
    }


class Cyclotomic78:
    """Exact Q[z]/Phi_78(z) arithmetic for the F_13 diagnostic."""

    z = sp.Symbol("z")
    phi = tuple(int(c) for c in reversed(sp.Poly(sp.cyclotomic_poly(78, z), z).all_coeffs()))
    degree = len(phi) - 1

    def __init__(self, coefficients=()):
        work = [Fraction(c) for c in coefficients]
        while len(work) > self.degree:
            coefficient = work.pop()
            offset = len(work) - self.degree
            if coefficient:
                for i in range(self.degree):
                    work[offset + i] -= coefficient * self.phi[i]
        self.coefficients = tuple(work + [Fraction(0)] * (self.degree - len(work)))

    def __add__(self, other):
        return Cyclotomic78(a + b for a, b in zip(self.coefficients, other.coefficients))

    def __neg__(self):
        return self.scale(-1)

    def __sub__(self, other):
        return self + (-other)

    def __mul__(self, other):
        work = [Fraction(0)] * (2 * self.degree - 1)
        for i, a in enumerate(self.coefficients):
            if a:
                for j, b in enumerate(other.coefficients):
                    if b:
                        work[i + j] += a * b
        return Cyclotomic78(work)

    def scale(self, scalar):
        return Cyclotomic78(Fraction(scalar) * c for c in self.coefficients)

    def conjugate(self):
        result = ZERO
        for i, coefficient in enumerate(self.coefficients):
            if coefficient:
                result = result + POWERS[-i % 78].scale(coefficient)
        return result

    def __eq__(self, other):
        return isinstance(other, Cyclotomic78) and self.coefficients == other.coefficients

    def serialized(self):
        return [str(c) for c in self.coefficients]


ZERO = Cyclotomic78()
ONE = Cyclotomic78([1])
POWERS = [Cyclotomic78([0] * exponent + [1]) for exponent in range(78)]


def finite_diagnostic():
    q = 13
    logarithms = {pow(2, exponent, q): exponent for exponent in range(q - 1)}
    require(len(logarithms) == q - 1, "2 is not a primitive root modulo 13")

    def character(value, power):
        residue = value % q
        if residue == 0:
            return ZERO
        return POWERS[(13 * power * logarithms[residue]) % 78]

    def additive(residue):
        return POWERS[(6 * residue) % 78]

    gauss = [
        sum((character(v, j) * additive(v) for v in range(1, q)), ZERO)
        for j in range(6)
    ]
    require(gauss[0] == -ONE, "The masked trivial Gauss sum is not -1")
    for j in range(1, 6):
        require(gauss[j] * gauss[-j % 6] == ONE.scale(q), "Gauss inversion failed")

    def alpha(j, v):
        if j == 0:
            return ONE.scale(Fraction(q - 1, q) if v == 0 else Fraction(-1, q))
        if v == 0:
            return ZERO
        tau_inverse = gauss[-j % 6].conjugate().scale(Fraction(1, q))
        return character(v, -j) * tau_inverse

    mask_checks = 0
    for j in range(6):
        for value in range(q):
            transform = sum(
                (alpha(j, v) * additive(value * v) for v in range(q)), ZERO
            )
            require(transform == character(value, j), f"Fourier mask failed: j={j}, t={value}")
            mask_checks += 1

    def spherical(e):
        if e < 0 or e % 3 == 2:
            return ZERO
        if e % 3 == 0:
            return ONE.scale(Fraction(1, q ** (e // 3)))
        return gauss[2].scale(Fraction(1, q ** (e // 3 + 1)))

    def reflected(j, e, unit):
        if e < 0:
            return ZERO
        result = ZERO
        for v in range(1, q):
            inverse_v = pow(v, -1, q)
            cocycle = character(unit, 4) * character(v, 4 * (e - 2))
            local_unit = character(unit * inverse_v**2, 2 * e)
            phase = additive(unit * inverse_v) if e == 0 else ONE
            result = result + alpha(j, v) * cocycle * local_unit * spherical(e) * phase
        return result

    local_checks = 0
    squared_magnitudes = {}
    for j in range(6):
        for e in range(5):
            scalar = reflected(j, e, 1)
            squared = scalar * scalar.conjugate()
            expected_squared = (
                Fraction(1, q) if j in (0, 4) else Fraction(1)
            ) if e == 0 else Fraction(0)
            if e > 0 and j == 4 and e % 3 != 2:
                spherical_squared = (
                    Fraction(1, q ** (2 * (e // 3)))
                    if e % 3 == 0
                    else Fraction(1, q ** (2 * (e // 3) + 1))
                )
                expected_squared = Fraction((q - 1) ** 2, q) * spherical_squared
            require(squared == ONE.scale(expected_squared), "A local magnitude is incorrect")
            squared_magnitudes[f"{j},{e}"] = str(expected_squared)
            exponent = (8 - j) % 6 if e == 0 else (4 + 2 * e) % 6
            for unit in range(1, q):
                require(
                    reflected(j, e, unit) == scalar * character(unit, exponent),
                    f"Local monomial failed: j={j}, e={e}, unit={unit}",
                )
                local_checks += 1
            if e > 0:
                require(
                    reflected(j, e + 3, 1) == scalar.scale(Fraction(1, q)),
                    "The finite diagnostic disagrees with the positive-valuation recurrence",
                )
    return {
        "scope": "F_13 only; diagnostic, not an all-parameter moment proof",
        "q": q,
        "multiplicative_generator": 2,
        "cyclotomic_order": 78,
        "cyclotomic_polynomial_low_to_high": list(Cyclotomic78.phi),
        "gauss_sums_low_to_high": {str(j): gauss[j].serialized() for j in range(6)},
        "Fourier_mask_checks": mask_checks,
        "local_unit_checks": local_checks,
        "local_squared_magnitudes": squared_magnitudes,
    }


def certificate():
    return {
        "claim_id": "C_REFLECTION_ALGEBRA",
        "result_kind": "exact symbolic verification with a separate finite diagnostic",
        "universal": universal_identities(),
        "finite_diagnostic": finite_diagnostic(),
        "limits": [
            "The compiler/kernel did not check a Lean theorem.",
            "Finite-field orthogonality and the analytic moment argument are proved in REPORT.md, not by this program.",
            "The representation-theoretic and quadratic-sieve inputs need the independent source review recorded in the ledger.",
            "This certificate is not a counterexample and does not settle either manuscript's main theorem.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(
            result == json.loads(path.read_text()),
            "The recorded certificate differs from the exact replay",
        )
    print(json.dumps({
        "verified": True,
        "universal_zero_remainders": len(result["universal"]["zero_remainders"]),
        "Fourier_mask_checks": result["finite_diagnostic"]["Fourier_mask_checks"],
        "local_unit_checks": result["finite_diagnostic"]["local_unit_checks"],
        "analytic_proof_checked_by_program": False,
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
