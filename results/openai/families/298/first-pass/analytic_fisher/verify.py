#!/usr/bin/env python3
"""Replay exact finite checks supporting the all-order proof in report.md."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from fractions import Fraction
from functools import cache
from itertools import combinations, product
import json
from math import comb
from pathlib import Path
from typing import Callable, TypeVar


Word = tuple[int, ...]
Partition = tuple[tuple[int, ...], ...]
K = 128


@dataclass(frozen=True)
class ComplexQ:
    real: Fraction = Fraction(0)
    imag: Fraction = Fraction(0)

    def __add__(self, other: ComplexQ) -> ComplexQ:
        return ComplexQ(self.real + other.real, self.imag + other.imag)

    def __neg__(self) -> ComplexQ:
        return ComplexQ(-self.real, -self.imag)

    def __sub__(self, other: ComplexQ) -> ComplexQ:
        return self + (-other)

    def __mul__(self, other: ComplexQ) -> ComplexQ:
        return ComplexQ(
            self.real * other.real - self.imag * other.imag,
            self.real * other.imag + self.imag * other.real,
        )

    def conjugate(self) -> ComplexQ:
        return ComplexQ(self.real, -self.imag)

    def as_json(self) -> dict[str, str]:
        return {"real": str(self.real), "imag": str(self.imag)}


ZERO = ComplexQ()
ONE = ComplexQ(Fraction(1))
I = ComplexQ(Fraction(0), Fraction(1))


def scalar(value: int | Fraction) -> ComplexQ:
    return ComplexQ(Fraction(value))


@cache
def noncrossing_partitions(n: int) -> tuple[Partition, ...]:
    if n == 0:
        return ((),)
    result = []
    for size in range(n):
        for rest in combinations(range(1, n), size):
            first = (0,) + rest
            intervals = [
                (left + 1, right) for left, right in zip(first, first[1:] + (n,))
            ]
            choices = [noncrossing_partitions(right - left) for left, right in intervals]
            for gap_partitions in product(*choices):
                blocks = [first]
                for (offset, _), partition in zip(intervals, gap_partitions):
                    blocks.extend(tuple(offset + i for i in block) for block in partition)
                result.append(tuple(sorted(blocks)))
    return tuple(result)


def catalan(n: int) -> int:
    return comb(2 * n, n) // (n + 1)


@cache
def mobius_to_top(partition: Partition) -> int:
    n = sum(map(len, partition))
    permutation = list(range(n))
    for block in partition:
        for a, b in zip(block, block[1:] + block[:1]):
            permutation[a] = b
    inverse = [0] * n
    for a, b in enumerate(permutation):
        inverse[b] = a
    kreweras = [inverse[(a + 1) % n] for a in range(n)]
    seen = set()
    value = 1
    for a in range(n):
        if a in seen:
            continue
        length = 0
        while a not in seen:
            seen.add(a)
            length += 1
            a = kreweras[a]
        value *= (-1) ** (length - 1) * catalan(length - 1)
    return value


@cache
def semicircular_moment(word: Word) -> int:
    if not word:
        return 1
    if len(word) % 2:
        return 0
    return sum(
        semicircular_moment(word[1:j]) * semicircular_moment(word[j + 1 :])
        for j in range(1, len(word), 2)
        if word[0] == word[j]
    )


T = TypeVar("T", Fraction, ComplexQ)


def cumulant_function(moment: Callable[[Word], T]) -> Callable[[Word], T]:
    one = moment(())
    zero = one - one

    @cache
    def cumulant(word: Word) -> T:
        assert word, "An empty word has no cumulant."
        value = moment(word)
        for partition in noncrossing_partitions(len(word)):
            if len(partition) == 1:
                continue
            term = one
            for block in partition:
                factor = cumulant(tuple(word[j] for j in block))
                if factor == zero:
                    term = zero
                    break
                term = term * factor
            value = value - term
        return value

    return cumulant


def mobius_cumulant(word: Word, moment: Callable[[Word], Fraction]) -> Fraction:
    total = Fraction(0)
    for partition in noncrossing_partitions(len(word)):
        term = Fraction(mobius_to_top(partition))
        for block in partition:
            term *= moment(tuple(word[j] for j in block))
        total += term
    return total


@cache
def atom_moment(p: int, degree: int) -> Fraction:
    return sum(
        (Fraction(2 * j, p - 1) - 1) ** degree for j in range(p)
    ) / p


def tensor_moment_function(p: int) -> Callable[[Word], Fraction]:
    @cache
    def moment(word: Word) -> Fraction:
        bword = tuple(i for i in word if i != p)
        return semicircular_moment(bword) * atom_moment(p, len(word) - len(bword))

    return moment


@cache
def wick_terms(word: Word) -> tuple[tuple[Word, int], ...]:
    terms: dict[Word, int] = {}

    def visit(position: int, kept: Word, coefficient: int) -> None:
        if position == len(word):
            terms[kept] = terms.get(kept, 0) + coefficient
            return
        visit(position + 1, kept + (word[position],), coefficient)
        if position + 1 < len(word) and word[position] == word[position + 1]:
            visit(position + 2, kept, -coefficient)

    visit(0, (), 1)
    return tuple(sorted((word, coefficient) for word, coefficient in terms.items() if coefficient))


def check_wick_orthonormality() -> int:
    words = [word for degree in range(5) for word in product(range(2), repeat=degree)]
    assert dict(wick_terms((0, 0, 0, 0))) == {
        (0, 0, 0, 0): 1, (0, 0): -3, (): 1
    }
    count = 0
    for first, second in product(words, repeat=2):
        pairing = sum(
            a * b * semicircular_moment(left[::-1] + right)
            for left, a in wick_terms(first)
            for right, b in wick_terms(second)
        )
        assert pairing == int(first == second), (first, second, pairing)
        count += 1
    return count


Matrix = tuple[tuple[ComplexQ, ComplexQ], tuple[ComplexQ, ComplexQ]]
IDENTITY: Matrix = ((ONE, ZERO), (ZERO, ONE))
PAULI: tuple[Matrix, ...] = (
    ((ZERO, ONE), (ONE, ZERO)),
    ((ZERO, -I), (I, ZERO)),
    ((ONE, ZERO), (ZERO, -ONE)),
)


def matrix_product(a: Matrix, b: Matrix) -> Matrix:
    return tuple(
        tuple(sum((a[i][k] * b[k][j] for k in range(2)), ZERO) for j in range(2))
        for i in range(2)
    )


@cache
def pauli_moment(word: Word) -> ComplexQ:
    matrix = IDENTITY
    for i in word:
        matrix = matrix_product(matrix, PAULI[i])
    return scalar(Fraction(1, 2)) * (matrix[0][0] + matrix[1][1])


def check_pauli_testing() -> dict:
    cumulant = cumulant_function(pauli_moment)
    sqrt_u = 2
    u = sqrt_u**2

    @cache
    def ambient_moment(word: tuple[tuple[str, int], ...]) -> ComplexQ:
        total = ZERO
        for partition in noncrossing_partitions(len(word)):
            term = ONE
            for block in partition:
                letters = tuple(word[j] for j in block)
                if all(kind == "C" for kind, _ in letters):
                    factor = cumulant(tuple(i for _, i in letters))
                elif len(letters) == 2 and letters[0][0] == letters[1][0] == "S":
                    factor = scalar(int(letters[0][1] == letters[1][1]))
                else:
                    factor = ZERO
                if factor == ZERO:
                    term = ZERO
                    break
                term = term * factor
            total = total + term
        return total

    @cache
    def z_moment(word: Word) -> ComplexQ:
        total = ZERO
        for partition in noncrossing_partitions(len(word)):
            term = ONE
            for block in partition:
                indices = tuple(word[j] for j in block)
                factor = cumulant(indices)
                if len(indices) == 2 and indices[0] == indices[1]:
                    factor = factor + scalar(u)
                term = term * factor
            total = total + term
        return total

    @cache
    def testing_derivative(indices: Word, word: Word) -> ComplexQ:
        total = ZERO
        for selected in combinations(range(len(word)), len(indices)):
            if tuple(word[j] for j in selected) != indices:
                continue
            endpoints = (-1,) + selected + (len(word),)
            term = ONE
            for left, right in zip(endpoints, endpoints[1:]):
                term = term * z_moment(word[left + 1 : right])
            total = total + term
        return total

    @cache
    def wick_trace(indices: Word, word: Word, adjoint: bool = True) -> ComplexQ:
        total = ZERO
        for prefix, coefficient in wick_terms(indices):
            initial = tuple(("S", i) for i in (prefix[::-1] if adjoint else prefix))
            for choices in product((False, True), repeat=len(word)):
                suffix = tuple(
                    ("S" if noise else "C", i) for noise, i in zip(choices, word)
                )
                total = total + scalar(coefficient * sqrt_u ** sum(choices)) * ambient_moment(
                    initial + suffix
                )
        return total

    words = [word for degree in range(4) for word in product(range(3), repeat=degree)]
    count = 0
    for degree in (1, 2):
        for indices in product(range(3), repeat=degree):
            for word in words:
                actual = scalar(Fraction(1, sqrt_u**degree)) * wick_trace(indices, word)
                expected = testing_derivative(indices, word)
                assert actual == expected, (indices, word, actual, expected)
                count += 1
    for indices, word in (
        ((0, 1, 2), (0, 1, 2)),
        ((2, 1, 0), (0, 1, 2)),
        ((0, 0, 0), (0, 0, 0)),
        ((0, 1, 1), (0, 1, 1)),
        ((0, 1, 2), (0, 1)),
    ):
        assert scalar(Fraction(1, sqrt_u ** len(indices))) * wick_trace(
            indices, word
        ) == testing_derivative(indices, word)
        count += 1

    word = (1, 2)
    residual = z_moment((0,) + word) - scalar(u + 1) * testing_derivative((0,), word)
    correct = ZERO
    wrong_adjoint = ZERO
    wrong_conjugation = ZERO
    for indices in product(range(3), repeat=2):
        coefficient = scalar(Fraction(1, u)) * cumulant((0,) + indices)
        correct = correct + coefficient * wick_trace(indices, word)
        wrong_adjoint = wrong_adjoint + coefficient * wick_trace(indices, word, False)
        wrong_conjugation = wrong_conjugation + coefficient.conjugate() * wick_trace(indices, word)
    assert cumulant((0, 1, 2)) == I
    assert residual == correct == I
    assert wrong_adjoint == wrong_conjugation == -I
    return {
        "u": u,
        "exact_testing_identities": count,
        "kappa_XYZ": cumulant((0, 1, 2)).as_json(),
        "bilinear_residual": residual.as_json(),
        "manuscript_adjoint_unconjugated_coefficients": correct.as_json(),
        "incorrect_no_adjoint": wrong_adjoint.as_json(),
        "incorrect_conjugated_coefficients": wrong_conjugation.as_json(),
        "interpretation": "The staged orientation passes; the two deliberately changed formulas fail.",
    }


def check_tensor_signal() -> list[dict]:
    result = []
    for p, maximum_degree in ((2, 6), (3, 6), (5, 4)):
        moment = tensor_moment_function(p)
        cumulant = cumulant_function(moment)
        c = Fraction(p + 1, 3 * (p - 1))
        fourth_y = -Fraction((p + 1) * (p * p + 11), 45 * (p - 1) ** 3)
        assert atom_moment(p, 2) == c
        assert cumulant((p, p, p, p)) == fourth_y
        assert cumulant((0, p, 0, p)) == c
        assert cumulant((0, 0, p, p)) == 0
        degrees = []
        for degree in range(1, maximum_degree + 1):
            squared_norm = Fraction(0)
            support_size = 0
            inversion_checks = 0
            for word in product(range(p + 1), repeat=degree):
                value = cumulant(word)
                if degree <= 4:
                    assert value == mobius_cumulant(word, moment), (p, word)
                    inversion_checks += 1
                if value:
                    support_size += 1
                    bword = tuple(i for i in word if i != p)
                    assert semicircular_moment(bword) > 0, (p, word, value)
                    assert degree % 2 == 0, (p, word, value)
                    if degree >= 3:
                        assert len(word) - len(bword) >= 2, (p, word, value)
                squared_norm += value * value
            assert squared_norm**2 <= K ** (4 * degree) * p**degree
            if degree >= 4 and degree % 2 == 0:
                assert squared_norm <= K ** (2 * degree) * p ** ((degree - 2) // 2)
            if degree == 4:
                assert squared_norm == 2 * p * c**2 + fourth_y**2
            degrees.append({
                "m": degree,
                "words": (p + 1) ** degree,
                "nonzero_cumulants": support_size,
                "squared_l2_norm": str(squared_norm),
                "independent_mobius_inversions": inversion_checks,
            })
        result.append({
            "p": p,
            "variance_Y": str(c),
            "kappa4_Y": str(fourth_y),
            "fisher_u5_limit": str(2 * p * c**2 + fourth_y**2),
            "entropy_a4_limit": str((2 * p * c**2 + fourth_y**2) / 8),
            "degrees": degrees,
        })
    return result


def build_certificate() -> dict:
    partition_counts = []
    for n in range(9):
        partitions = noncrossing_partitions(n)
        assert len(partitions) == len(set(partitions)) == catalan(n)
        assert all(abs(mobius_to_top(partition)) <= 4**n for partition in partitions)
        partition_counts.append(len(partitions))
    assert 32**2 * 5 <= K**2
    return {
        "certificate_version": 1,
        "classification": "exact finite replay supporting an all-order verification and structural refinement",
        "universal_proof": "report.md",
        "formal_kernel_source": "Main.lean",
        "formal_kernel_claim": "AF_KERNEL",
        "full_analytic_theorem_formalized": False,
        "independent_reviewer_approval": False,
        "novelty": "not established by bounded literature search",
        "manuscript_false_assertion_identified": False,
        "main_entropy_separation_certified": False,
        "noncrossing_partition_counts_m0_through_m8": partition_counts,
        "wick_orthonormal_pairings": check_wick_orthonormality(),
        "pauli_orientation": check_pauli_testing(),
        "tensor_signal": check_tensor_signal(),
        "scope": "Finite computations do not prove universal claims; see the all-order proof and the separately compiler-checked combinatorial kernel.",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = Path(__file__).with_name("exact_certificate.json")
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
        print(f"Wrote {path.name}: all exact finite checks passed.")
    else:
        recorded = json.loads(path.read_text())
        assert certificate == recorded, "Replay differs from exact_certificate.json."
        print("PASS: exact certificate replay; Pauli orientation, Wick tests and tensor cumulants.")


if __name__ == "__main__":
    main()
