#!/usr/bin/env python3
"""Exact low-order checks.

Completeness and global minimization:
guide/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026.md
"""

import argparse
import json
from fractions import Fraction as Q
from itertools import combinations, combinations_with_replacement, permutations, product
from pathlib import Path

import sympy as s


def energy(weight):
    a, b, c = weight
    norm = Q(3, 4) * (a * a + c * c) + b * b + a * b + b * c + Q(a * c, 2)
    return Q(3, 8) * (norm + 2 * (a + c) + Q(8, 3) * b)


def residue(weight):
    a, b, c = weight
    return (a + 2 * b + 3 * c) % 4


def operator(poly, z):
    derivatives = [zi * s.diff(poly, zi) for zi in z]
    laplacian = sum(zi * s.diff(di, zi) for zi, di in zip(z, derivatives))
    drift = sum(
        (z[i] + z[j]) * s.cancel((derivatives[i] - derivatives[j]) / (z[i] - z[j]))
        for i, j in combinations(range(4), 2)
    )
    return s.expand(-s.Rational(3, 8) * laplacian - s.Rational(1, 4) * drift)


def verify_witness(witness):
    weight = tuple(witness["weight"])
    if len(weight) != 3 or any(type(v) is not int or v < 0 for v in weight):
        raise ValueError("weight must have three nonnegative integer Dynkin labels")
    if residue(weight) != witness["cyclic_residue"]:
        raise ValueError("cyclic character does not match the weight")
    if energy(weight) != Q(witness["relative_energy"]):
        raise ValueError("relative energy does not match the generator normalization")


def require_rejection(witness):
    try:
        verify_witness(witness)
    except ValueError:
        return
    raise AssertionError(f"accepted corrupted witness: {witness}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--witness", type=Path, default=Path(__file__).with_name("witness.json"))
    args = parser.parse_args()
    witnesses = json.loads(args.witness.read_text())
    for witness in witnesses:
        verify_witness(witness)
    require_rejection(dict(witnesses[1], relative_energy="1"))
    require_rejection(dict(witnesses[1], cyclic_residue=0))
    require_rejection(dict(witnesses[1], weight=[0, -1, 0]))

    z = s.symbols("z1:5")
    for k in range(1, 5):
        elementary = sum(s.prod(terms) for terms in combinations(z, k))
        total = Q(3 * k, 8) + Q(k * (4 - k), 4)
        relative = total - Q(3 * k * k, 32)
        assert s.expand(operator(elementary, z) + s.Rational(total) * elementary) == 0
        if k < 4:
            weight = tuple(int(j == k - 1) for j in range(3))
            assert relative == energy(weight)
        else:
            assert relative == 0
        print(f"elementary e_{k}: total={total}, relative={relative}; operator identity PASS")

    # T(r) shifts every exp(i*r_j) by -i, up to permutation.
    for k in range(1, 5):
        assert s.expand(s.I ** (-k) * sum(s.prod(t) for t in combinations(z, k))) == s.expand(
            sum(s.prod(t) for t in combinations(tuple(-s.I * zi for zi in z), k))
        )
    theta, phi = s.symbols("theta phi", real=True)
    center_mode = s.exp(2 * s.I * (theta - phi))
    assert s.simplify(
        s.Rational(3, 32) * (s.diff(center_mode, theta, 2) + s.diff(center_mode, phi, 2))
        + s.Rational(3, 4) * center_mode
    ) == 0
    for variable in (theta, phi):
        assert s.simplify(center_mode.subs(variable, variable + s.pi / 2) + center_mode) == 0
    print("center extremizer: energy=3/4, both cyclic signs=-1; PASS")

    for degree in range(5):
        partitions = [
            tuple(reversed(p))
            for p in combinations_with_replacement(range(degree + 1), 4)
            if sum(p) == degree
        ]
        images = []
        for partition in partitions:
            orbit_sum = sum(
                s.prod(zi ** exponent for zi, exponent in zip(z, exponents))
                for exponents in set(permutations(partition))
            )
            images.append(s.Poly(operator(orbit_sum, z), *z))
        matrix = s.Matrix(
            [[image.coeff_monomial(partition) for image in images] for partition in partitions]
        )
        actual = sorted(
            Q(-value) - Q(3 * degree * degree, 32)
            for value, multiplicity in matrix.eigenvals().items()
            for _ in range(multiplicity)
        )
        predicted = sorted(energy(tuple(p[i] - p[i + 1] for i in range(3))) for p in partitions)
        assert actual == predicted
        print(f"exact symmetric degree={degree} matrix: relative eigenvalues={list(map(str, actual))}")

    rows = [(energy(w), w, residue(w)) for w in product(range(7), repeat=3)]
    minima = {}
    for character in range(4):
        candidate = min(row for row in rows if row[2] == character)
        minima[character] = candidate[0]
        print(f"finite search character={character}: energy={candidate[0]}, weight={candidate[1]}")
    assert minima == {0: Q(0), 1: Q(33, 32), 2: Q(11, 8), 3: Q(33, 32)}
    for n in range(5):
        pair = 2 * minima[(n + 2) % 4] + Q(3 * n * n, 16)
        print(f"finite search center pair=({n},{-n}): sector minimum={pair}")
    p, t = s.symbols("p t", positive=True)
    for gap, forcing in ((Q(1), Q(1)), (Q(1), Q(7, 4)), (Q(11, 4), Q(7, 4))):
        integral = s.integrate(s.exp(-s.Rational(gap) * (p - t) - s.Rational(forcing) * t), (t, 0, p))
        expected = (
            p * s.exp(-s.Rational(gap) * p)
            if gap == forcing
            else (s.exp(-s.Rational(forcing) * p) - s.exp(-s.Rational(gap) * p))
            / s.Rational(gap - forcing)
        )
        assert s.simplify(integral - expected) == 0
        print(f"Duhamel gap={gap}, forcing={forcing}: {s.simplify(integral)}")
    print("Witness checks and three corrupted-input rejection tests PASS")
    print("Finite search is a check, NOT a proof of spectral completeness or a global lower bound.")


if __name__ == "__main__":
    main()
