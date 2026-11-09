#!/usr/bin/env python3
"""Replay an integral, universal, noncommutative plus-construction certificate.

Only the Python standard library is used.  Words are freely reduced signed
generator tuples in the order x1,a1,x2,a2,s.  Polynomials are sparse elements of
S = Z[F5], not evaluations at characters or matrices.  An equality L = R in
Z[G] carries a sparse integer sum of u*(r_i-1)*v, for exactly the six oriented
attaching words in the certificate.  EVERY equality object, including every
intermediate operation, is checked by expanding that sum literally in S and
comparing it with L-R.  No group-word oracle or additional relation is used.

The JSON contains the six original word factorizations, raw Fox rows, all
filling chains, D3, splitting matrices, and explicit reconstruction formulas.
To avoid storing enormous duplicated proof expressions, this program
deterministically reconstructs the ideal terms.  In particular it expands
all ten final dB(Fj)-bj residuals, all ten D3*D2 coordinates, and the degree-two
retraction chain-map coordinates.  Torsion equalities are DERIVED from the P
witnesses and the two new relators; they are not extra ideal generators.

Rows represent free LEFT modules: coefficients multiply Fox rows on the
LEFT.  Matrix multiplication below is ordered row composition, so D3*D2
represents the conventionally written D2 o D3.  The splitting identities
other than the boundary identities already hold in S itself.

This certifies the displayed algebraic construction, not geometric sphere
maps, topological realization, Lean proofs, independent review, or novelty.
It does not rerun or depend on the earlier wall_d2_audit verifier.

Usage:
  python3 verify.py --emit-certificate
  python3 verify.py --self-test
  python3 verify.py --certificate exact_certificate.json

The combined self-test replays its baseline once, rejects in-memory
corruptions, and invokes the public CLI on a corrupted JSON fixture strictly
beside this script.  That fixture is removed even if its test fails.
"""

from __future__ import annotations

import argparse
import copy
import json
import os
from pathlib import Path
import subprocess
import sys
from dataclasses import dataclass
from functools import lru_cache
from typing import Any


Word = tuple[int, ...]
Poly = dict[Word, int]
IdealKey = tuple[Word, int, Word]
Ideal = dict[IdealKey, int]
Row = list[Poly]
Matrix = list[Row]

GENERATOR_NAMES = ["x1", "a1", "x2", "a2", "s"]
WITNESS_NAMES = ["U1", "U2", "P1", "P2", "E1", "E2"]
CHAIN_NAMES = WITNESS_NAMES + ["F26", "F15_2", "F15_1", "F1", "F2"]
ONE: Poly = {(): 1}
ZERO: Poly = {}
X1, A1, X2, A2, S = ((i,) for i in range(1, 6))
T1, T2 = (1, 1), (3, 3, 3)
RELATORS: tuple[Word, ...] = (
    (1, 2, -1) + (-2,) * 4,
    (3, 4, -3) + (-4,) * 3,
    (1,) + (-4,) * 13,
    (5, 3, -5) + (-2,) * 5,
    T1,
    T2,
)


class CertificateError(Exception):
    """A malformed input or a failed exact identity."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise CertificateError(message)


def reduce_word(word: Word | list[int]) -> Word:
    stack: list[int] = []
    for letter in word:
        if stack and stack[-1] == -letter:
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def word_mul(left: Word, right: Word) -> Word:
    """Both arguments are already reduced; cancellations occur at the seam."""
    i, j = len(left), 0
    while i and j < len(right) and left[i - 1] == -right[j]:
        i -= 1
        j += 1
    return left[:i] + right[j:]


def word_inv(word: Word) -> Word:
    return tuple(-letter for letter in reversed(word))


def word_product(*words: Word) -> Word:
    result: Word = ()
    for word in words:
        result = word_mul(result, reduce_word(word))
    return result


def commutator(left: Word, right: Word) -> Word:
    return word_product(left, right, word_inv(left), word_inv(right))


def add_term(result: dict, key: Any, coefficient: int) -> None:
    if coefficient:
        new = result.get(key, 0) + coefficient
        if new:
            result[key] = new
        else:
            result.pop(key, None)


def monomial(word: Word) -> Poly:
    return {reduce_word(word): 1}


def p_add(*polys: Poly) -> Poly:
    result: Poly = {}
    for poly in polys:
        for word, coefficient in poly.items():
            add_term(result, word, coefficient)
    return result


def p_scale(coefficient: int, poly: Poly) -> Poly:
    return {word: coefficient * n for word, n in poly.items()} if coefficient else {}


def p_neg(poly: Poly) -> Poly:
    return p_scale(-1, poly)


def p_sub(left: Poly, right: Poly) -> Poly:
    return p_add(left, p_neg(right))


def p_mul(left: Poly, right: Poly) -> Poly:
    result: Poly = {}
    for u, m in left.items():
        for v, n in right.items():
            add_term(result, word_mul(u, v), m * n)
    return result


def norm(generator: int, order: int) -> Poly:
    return {(generator,) * j: 1 for j in range(order)}


@lru_cache(maxsize=256)
def fox(word: Word) -> tuple[Poly, ...]:
    result: list[Poly] = [{} for _ in range(5)]
    prefix: Word = ()
    for letter in word:
        if letter > 0:
            add_term(result[letter - 1], prefix, 1)
            prefix = word_mul(prefix, (letter,))
        else:
            prefix = word_mul(prefix, (letter,))
            add_term(result[-letter - 1], prefix, -1)
    return tuple(result)


def row_add(*rows: Row) -> Row:
    require(bool(rows), "row_add requires at least one row")
    require(all(len(row) == len(rows[0]) for row in rows), "row width mismatch")
    return [p_add(*(row[j] for row in rows)) for j in range(len(rows[0]))]


def row_scale(coefficient: Poly, row: Row) -> Row:
    return [p_mul(coefficient, entry) for entry in row]


def row_neg(row: Row) -> Row:
    return [p_neg(entry) for entry in row]


def row_sub(left: Row, right: Row) -> Row:
    return row_add(left, row_neg(right))


def basis_row(width: int, index: int, coefficient: Poly = ONE) -> Row:
    return [coefficient.copy() if j == index else {} for j in range(width)]


def identity_matrix(size: int) -> Matrix:
    return [basis_row(size, j) for j in range(size)]


def matrix_mul(left: Matrix, right: Matrix) -> Matrix:
    require(bool(left) and bool(right), "empty matrix")
    require(all(len(row) == len(right) for row in left), "matrix size mismatch")
    width = len(right[0])
    require(all(len(row) == width for row in right), "ragged matrix")
    return [
        [
            p_add(*(p_mul(row[k], right[k][j]) for k in range(len(right))))
            for j in range(width)
        ]
        for row in left
    ]


def matrix_sub(left: Matrix, right: Matrix) -> Matrix:
    require(len(left) == len(right), "matrix height mismatch")
    return [row_sub(a, b) for a, b in zip(left, right)]


def boundary(chain: Row, old_fox_rows: Matrix) -> Row:
    return matrix_mul([chain], old_fox_rows)[0]


def original_witnesses() -> list[dict[str, Any]]:
    """The literal six factorizations, including unreduced conjugator lists."""
    def factor(index: int, conjugator: Word, sign: int = 1) -> dict[str, Any]:
        return {"relator": index, "conjugator": list(conjugator), "sign": sign}

    u1 = [factor(1, X1)] + [factor(1, (2,) * j) for j in (0, 4, 8, 12)]
    u2 = [factor(2, (3, 3))]
    u2 += [factor(2, (3,) + (4,) * j) for j in (0, 3, 6)]
    u2 += [factor(2, (4,) * (3 * j)) for j in range(9)]
    p1 = [factor(3, X1), factor(3, ())]
    p2 = [factor(4, (5, 3, -5) * j) for j in (2, 1, 0)]

    def inverted_factors(factors: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            factor(f["relator"], tuple(f["conjugator"]), -f["sign"])
            for f in reversed(factors)
        ]

    descriptions = [
        ("[t1,a1]=a1^15", word_product(commutator(T1, A1), (-2,) * 15), u1),
        ("[t2,a2]=a2^26", word_product(commutator(T2, A2), (-4,) * 26), u2),
        ("t1=a2^26", word_product(T1, (-4,) * 26), p1),
        (
            "s*t2*s^-1=a1^15",
            word_product(S, T2, word_inv(S), (-2,) * 15),
            p2,
        ),
        (
            "t1=[t2,a2]",
            word_product(T1, word_inv(commutator(T2, A2))),
            p1 + inverted_factors(u2),
        ),
        (
            "s*t2*s^-1=[t1,a1]",
            word_product(S, T2, word_inv(S), word_inv(commutator(T1, A1))),
            p2 + inverted_factors(u1),
        ),
    ]
    return [
        {"identity": label, "target_free_word": list(target), "relator_conjugates": factors}
        for label, target, factors in descriptions
    ]


def witness_chain(witness: dict[str, Any]) -> Row:
    result: Row = [{} for _ in range(4)]
    for factor in witness["relator_conjugates"]:
        add_term(
            result[factor["relator"] - 1],
            reduce_word(factor["conjugator"]),
            factor["sign"],
        )
    return result


def material(witnesses: list[dict[str, Any]], bezout: list[int]) -> dict[str, Any]:
    chains = {name: witness_chain(w) for name, w in zip(WITNESS_NAMES, witnesses)}
    n15, n26 = norm(2, 15), norm(4, 26)
    one_a1, one_a2 = p_sub(ONE, monomial(A1)), p_sub(ONE, monomial(A2))
    sinv = monomial(word_inv(S))
    chains["F26"] = row_sub(
        row_scale(p_scale(26, ONE), chains["P1"]), row_scale(n26, chains["U2"])
    )
    chains["F15_2"] = row_scale(
        sinv,
        row_sub(
            row_scale(p_scale(15, ONE), chains["P2"]),
            row_scale(n15, chains["U1"]),
        ),
    )
    chains["F15_1"] = row_add(
        row_scale(p_scale(15, ONE), chains["E1"]),
        row_scale(one_a2, chains["F15_2"]),
    )
    chains["F1"] = row_add(
        row_scale(p_scale(bezout[0], ONE), chains["F15_1"]),
        row_scale(p_scale(bezout[1], ONE), chains["F26"]),
    )
    chains["F2"] = row_scale(
        sinv, row_add(chains["E2"], row_scale(one_a1, chains["F1"]))
    )
    d3 = [
        row_neg(chains["F1"]) + basis_row(2, 0),
        row_neg(chains["F2"]) + basis_row(2, 1),
    ]
    q = [[{}, {}] for _ in range(4)] + identity_matrix(2)
    splitting = {
        "q": q,
        "h2": copy.deepcopy(q),
        "r2": identity_matrix(4) + [chains["F1"], chains["F2"]],
        "i2": [basis_row(6, j) for j in range(4)],
    }
    return {
        "chains": chains,
        "D3": d3,
        "splitting_coefficients": splitting,
        "raw_fox_boundary_rows": [list(fox(r)) for r in RELATORS],
    }


def recipe() -> dict[str, Any]:
    return {
        "ideal_generators": [1, 2, 3, 4, 5, 6],
        "ideal_term": "n*u*(r_i-1)*v; u,v are reduced free words; n is an integer",
        "equality_multiplication": "(L1-R1)*L2 + R1*(L2-R2)",
        "inverse_word_equality": "-w^-1*(w-v)*v^-1 = w^-1-v^-1",
        "negative_relator": "r_i^-1-1 = -r_i^-1*(r_i-1)",
        "witness_word_telescoping": "previous*(factor-1)+(previous-1)",
        "positive_factor_derivative": "Fox(c*r*c^-1)-c*Fox(r)=(1-c*r*c^-1)*Fox(c)",
        "negative_factor_derivative": (
            "Fox(c*r^-1*c^-1)+c*Fox(r)="
            "(1-c*r^-1*c^-1)*Fox(c)-c*(r^-1-1)*Fox(r)"
        ),
        "product_derivative": "Fox(p*f)=Fox(p)+p*Fox(f); retain p until proved p=1",
        "path_product": "Fox(p*q)=Fox(p)+p*Fox(q)",
        "path_inverse": "Fox(p^-1)=-p^-1*Fox(p)",
        "derived_torsion": [
            "P1_target*a2^26=t1; P1_target=1; t1=r5=1",
            "P2_target*a1^15=s*t2*s^-1; P2_target=1; t2=r6=1",
        ],
        "norm_annihilator": "N_n(a)*(1-a)=1-a^n",
        "norm_square": "N_n(a)^2-n*N_n(a)=Q_n(a)*(a^n-1)",
        "norm_square_quotient": "Q_n(a)=sum((n-1-k)*a^k, k=0,...,n-2)",
        "norm_square_quotient_coefficients": {
            "15": list(range(14, 0, -1)),
            "26": list(range(25, 0, -1)),
        },
        "chain_formulas": {
            "E1": "P1-U2",
            "E2": "P2-U1",
            "F26": "26*P1-N26*U2",
            "F15_2": "s^-1*(15*P2-N15*U1)",
            "F15_1": "15*E1+(1-a2)*F15_2",
            "F1": "7*F15_1-4*F26",
            "F2": "s^-1*(E2+(1-a1)*F1)",
        },
        "witness_boundary_formulas": {
            "U1": "(1-a1)*b1-N15*e_a1",
            "U2": "(1-a2)*b2-N26*e_a2",
            "P1": "b1-N26*e_a2",
            "P2": "s*b2-N15*e_a1",
            "E1": "b1-(1-a2)*b2",
            "E2": "s*b2-(1-a1)*b1",
        },
        "final_coordinate_selectors": [
            [name, generator]
            for name in ("F1", "F2")
            for generator in GENERATOR_NAMES
        ],
        "row_composition_checks": [
            "D3*D2=0 in Z[G]",
            "r2*dB=D2 in Z[G]",
            "D3*q=I2 in Z[F5]",
            "D3*h2=I2 in Z[F5]",
            "i2*r2=I4 in Z[F5]",
            "D3*r2=0 in Z[F5]",
            "I6-r2*i2=h2*D3 in Z[F5]",
        ],
        "proof_storage": (
            "Reconstruct sparse ideal terms deterministically using this recipe, "
            "the six factorizations, and verify.py; expand every equality in Z[F5]. "
            "No stored success flags or scalar/matrix specializations are accepted."
        ),
    }


def metadata() -> dict[str, Any]:
    return {
        "format": "integral-plus-free-group-ring-v1",
        "generator_order": GENERATOR_NAMES,
        "ring": "Z[F(x1,a1,x2,a2,s)] / two-sided ideal (r1-1,r2-1,r3-1,r4-1,t1-1,t2-1)",
        "module_convention": "free left modules; rows; coefficients multiply boundary rows on the left",
        "encoding": {
            "word": "signed generator indices 1,...,5; empty word is 1",
            "polynomial": "list of [nonzero integer coefficient, reduced word], sorted by (length,word)",
            "zero_polynomial": [],
            "matrix": "list of source-generator rows; each row is a list of polynomials",
        },
        "source": "research/wall_d2_audit/exact_certificate.json#/free_group_identity_witnesses",
        "ideal_membership_recipe": recipe(),
        "scope": [
            "Exact integral identities over the six-relator group ring, without a group-word solver.",
            "Both torsion identities are derived, not assumed or added as ideal generators.",
            "Explicit filling chains, cycle orientations, retraction, projection, and contraction.",
            "No geometric sphere maps, topological realization, Lean certification, independent review, or novelty claim.",
        ],
    }


def word_key(word: Word) -> tuple[int, Word]:
    return len(word), word


def encode_poly(poly: Poly) -> list:
    return [[poly[word], list(word)] for word in sorted(poly, key=word_key)]


def encode_row(row: Row) -> list:
    return [encode_poly(poly) for poly in row]


def encode_matrix(matrix: Matrix) -> list:
    return [encode_row(row) for row in matrix]


def make_certificate() -> dict[str, Any]:
    witnesses = original_witnesses()
    derived = material(witnesses, [7, -4])
    result = metadata()
    result.update(
        {
            "attaching_words": [
                {"name": name, "word": list(word)}
                for name, word in zip(("r1", "r2", "r3", "r4", "t1", "t2"), RELATORS)
            ],
            "free_group_identity_witnesses": witnesses,
            "parameters": {"torsion_orders": [15, 26], "bezout_coefficients": [7, -4]},
            "raw_fox_boundary_rows": encode_matrix(derived["raw_fox_boundary_rows"]),
            "chains": {name: encode_row(derived["chains"][name]) for name in CHAIN_NAMES},
            "D3": encode_matrix(derived["D3"]),
            "splitting_coefficients": {
                name: encode_matrix(matrix)
                for name, matrix in derived["splitting_coefficients"].items()
            },
        }
    )
    return result


def exact_keys(value: Any, keys: set[str], path: str) -> None:
    require(type(value) is dict, f"{path}: expected an object")
    require(set(value) == keys, f"{path}: missing or unexpected object fields")


def exact_literal(value: Any, expected: Any, path: str) -> None:
    require(type(value) is type(expected), f"{path}: wrong JSON type")
    if type(expected) is dict:
        exact_keys(value, set(expected), path)
        for key in expected:
            exact_literal(value[key], expected[key], f"{path}.{key}")
    elif type(expected) is list:
        require(len(value) == len(expected), f"{path}: wrong list length")
        for j, (actual, wanted) in enumerate(zip(value, expected)):
            exact_literal(actual, wanted, f"{path}[{j}]")
    else:
        require(value == expected, f"{path}: does not match the specified construction")


def read_word(value: Any, path: str, reduced: bool = True) -> Word:
    require(type(value) is list, f"{path}: expected a word list")
    require(
        all(type(g) is int and 1 <= abs(g) <= 5 for g in value),
        f"{path}: letters must be nonzero signed integer generator indices",
    )
    word = tuple(value)
    if reduced:
        require(reduce_word(word) == word, f"{path}: word is not freely reduced")
    return word


def read_poly(value: Any, path: str) -> Poly:
    require(type(value) is list, f"{path}: expected a polynomial list")
    result: Poly = {}
    previous: tuple[int, Word] | None = None
    for j, term in enumerate(value):
        require(type(term) is list and len(term) == 2, f"{path}[{j}]: expected [coefficient,word]")
        coefficient, raw_word = term
        require(
            type(coefficient) is int and coefficient != 0,
            f"{path}[{j}]: coefficient must be a nonzero integer (not bool)",
        )
        word = read_word(raw_word, f"{path}[{j}].word")
        key = word_key(word)
        require(previous is None or previous < key, f"{path}: repeated or unsorted monomial")
        previous = key
        result[word] = coefficient
    return result


def read_row(value: Any, width: int, path: str) -> Row:
    require(type(value) is list and len(value) == width, f"{path}: wrong row shape")
    return [read_poly(entry, f"{path}[{j}]") for j, entry in enumerate(value)]


def read_matrix(value: Any, height: int, width: int, path: str) -> Matrix:
    require(type(value) is list and len(value) == height, f"{path}: wrong matrix shape")
    return [read_row(row, width, f"{path}[{j}]") for j, row in enumerate(value)]


def validate_witnesses(value: Any) -> None:
    path = "free_group_identity_witnesses"
    expected = original_witnesses()
    require(type(value) is list and len(value) == 6, f"{path}: expected six witnesses")
    for j, (witness, original) in enumerate(zip(value, expected)):
        here = f"{path}[{j}]"
        exact_keys(witness, {"identity", "target_free_word", "relator_conjugates"}, here)
        exact_literal(witness["identity"], original["identity"], here + ".identity")
        target = read_word(witness["target_free_word"], here + ".target_free_word")
        require(target == tuple(original["target_free_word"]), here + ": changed target orientation")
        factors = witness["relator_conjugates"]
        require(
            type(factors) is list and len(factors) == len(original["relator_conjugates"]),
            here + ": wrong factor list shape",
        )
        product: Word = ()
        for k, factor in enumerate(factors):
            loc = f"{here}.relator_conjugates[{k}]"
            exact_keys(factor, {"relator", "conjugator", "sign"}, loc)
            index, sign = factor["relator"], factor["sign"]
            require(type(index) is int and 1 <= index <= 4, loc + ": invalid original relator index")
            require(type(sign) is int and sign in (-1, 1), loc + ": invalid sign")
            c = reduce_word(read_word(factor["conjugator"], loc + ".conjugator", reduced=False))
            r = RELATORS[index - 1]
            product = word_product(product, c, r if sign == 1 else word_inv(r), word_inv(c))
        require(product == target, here + ": factorization does not equal target in the free group")
    exact_literal(value, expected, path)


def validate_input(data: Any) -> dict[str, Any]:
    fixed = metadata()
    variable_keys = {
        "attaching_words",
        "free_group_identity_witnesses",
        "parameters",
        "raw_fox_boundary_rows",
        "chains",
        "D3",
        "splitting_coefficients",
    }
    exact_keys(data, set(fixed) | variable_keys, "certificate")
    for key, expected in fixed.items():
        exact_literal(data[key], expected, key)
    exact_literal(
        data["attaching_words"],
        [
            {"name": name, "word": list(word)}
            for name, word in zip(("r1", "r2", "r3", "r4", "t1", "t2"), RELATORS)
        ],
        "attaching_words",
    )
    validate_witnesses(data["free_group_identity_witnesses"])
    exact_literal(
        data["parameters"],
        {"torsion_orders": [15, 26], "bezout_coefficients": [7, -4]},
        "parameters",
    )
    bezout = data["parameters"]["bezout_coefficients"]
    require(15 * bezout[0] + 26 * bezout[1] == 1, "Bezout identity failed")
    expected = material(data["free_group_identity_witnesses"], bezout)
    actual: dict[str, Any] = {
        "raw_fox_boundary_rows": read_matrix(data["raw_fox_boundary_rows"], 6, 5, "raw_fox_boundary_rows"),
        "D3": read_matrix(data["D3"], 2, 6, "D3"),
    }
    exact_keys(data["chains"], set(CHAIN_NAMES), "chains")
    actual["chains"] = {
        name: read_row(data["chains"][name], 4, f"chains.{name}") for name in CHAIN_NAMES
    }
    exact_keys(data["splitting_coefficients"], {"q", "r2", "i2", "h2"}, "splitting_coefficients")
    actual["splitting_coefficients"] = {
        name: read_matrix(data["splitting_coefficients"][name], h, w, f"splitting_coefficients.{name}")
        for name, h, w in (("q", 6, 2), ("h2", 6, 2), ("r2", 6, 4), ("i2", 4, 6))
    }
    for name in CHAIN_NAMES:
        require(actual["chains"][name] == expected["chains"][name], f"chains.{name}: incorrect filling/witness coefficients")
    for key in ("raw_fox_boundary_rows", "D3", "splitting_coefficients"):
        require(actual[key] == expected[key], f"{key}: incorrect coefficients or orientation")
    return actual


def ideal_add(*ideals: Ideal) -> Ideal:
    result: Ideal = {}
    for ideal in ideals:
        for key, coefficient in ideal.items():
            add_term(result, key, coefficient)
    return result


def ideal_neg(ideal: Ideal) -> Ideal:
    return {key: -n for key, n in ideal.items()}


def ideal_left(poly: Poly, ideal: Ideal) -> Ideal:
    result: Ideal = {}
    for word, m in poly.items():
        for (u, index, v), n in ideal.items():
            add_term(result, (word_mul(word, u), index, v), m * n)
    return result


def ideal_right(ideal: Ideal, poly: Poly) -> Ideal:
    result: Ideal = {}
    for (u, index, v), n in ideal.items():
        for word, m in poly.items():
            add_term(result, (u, index, word_mul(v, word)), n * m)
    return result


@lru_cache(maxsize=32768)
def ideal_words(key: IdealKey) -> tuple[Word, Word]:
    u, index, v = key
    require(1 <= index <= 6, "an ideal term used an extra relator")
    return word_product(u, RELATORS[index - 1], v), word_mul(u, v)


def expand_ideal(ideal: Ideal) -> Poly:
    result: Poly = {}
    for key, coefficient in ideal.items():
        positive, negative = ideal_words(key)
        add_term(result, positive, coefficient)
        add_term(result, negative, -coefficient)
    return result


class Kernel:
    def __init__(self) -> None:
        self.checked_equalities = 0
        self.expanded_ideal_terms = 0
        self.max_ideal_terms = 0

    def equality(self, left: Poly, right: Poly, ideal: Ideal, label: str = "equality") -> Equality:
        residual = p_sub(left, right)
        require(expand_ideal(ideal) == residual, f"{label}: literal ideal expansion is not lhs-rhs")
        self.checked_equalities += 1
        self.expanded_ideal_terms += len(ideal)
        self.max_ideal_terms = max(self.max_ideal_terms, len(ideal))
        return Equality(self, left, right, ideal)

    def reflexive(self, left: Poly, right: Poly | None = None) -> Equality:
        if right is None:
            right = left
        require(left == right, "reflexive equality is not an exact free-ring identity")
        return self.equality(left, right, {}, "reflexivity")

    def primitive(self, index: int) -> Equality:
        require(type(index) is int and 1 <= index <= 6, "invalid primitive relator")
        return self.equality(monomial(RELATORS[index - 1]), ONE, {((), index, ()): 1}, "primitive")


@dataclass(frozen=True)
class Equality:
    kernel: Kernel
    lhs: Poly
    rhs: Poly
    ideal: Ideal

    def plus(self, other: Equality) -> Equality:
        require(self.kernel is other.kernel, "mixed proof kernels")
        return self.kernel.equality(
            p_add(self.lhs, other.lhs), p_add(self.rhs, other.rhs), ideal_add(self.ideal, other.ideal), "addition"
        )

    def neg(self) -> Equality:
        return self.kernel.equality(p_neg(self.lhs), p_neg(self.rhs), ideal_neg(self.ideal), "negation")

    def minus(self, other: Equality) -> Equality:
        return self.plus(other.neg())

    def flip(self) -> Equality:
        return self.kernel.equality(self.rhs, self.lhs, ideal_neg(self.ideal), "symmetry")

    def left(self, poly: Poly) -> Equality:
        return self.kernel.equality(
            p_mul(poly, self.lhs), p_mul(poly, self.rhs), ideal_left(poly, self.ideal), "left multiplication"
        )

    def right(self, poly: Poly) -> Equality:
        return self.kernel.equality(
            p_mul(self.lhs, poly), p_mul(self.rhs, poly), ideal_right(self.ideal, poly), "right multiplication"
        )

    def times(self, other: Equality) -> Equality:
        require(self.kernel is other.kernel, "mixed proof kernels")
        ideal = ideal_add(ideal_right(self.ideal, other.lhs), ideal_left(self.rhs, other.ideal))
        return self.kernel.equality(p_mul(self.lhs, other.lhs), p_mul(self.rhs, other.rhs), ideal, "product")

    def then(self, other: Equality) -> Equality:
        require(self.kernel is other.kernel, "mixed proof kernels")
        require(self.rhs == other.lhs, "transitivity endpoints are not equal in the free ring")
        return self.kernel.equality(self.lhs, other.rhs, ideal_add(self.ideal, other.ideal), "transitivity")

    def endpoints(self, lhs: Poly, rhs: Poly, label: str) -> Equality:
        return self.kernel.equality(lhs, rhs, self.ideal, label)


def inverse_word_equality(equality: Equality, raw: Word, chosen: Word) -> Equality:
    require(equality.lhs == monomial(raw) and equality.rhs == monomial(chosen), "inverse word endpoints")
    inverse_raw, inverse_chosen = monomial(word_inv(raw)), monomial(word_inv(chosen))
    return (
        equality.left(p_neg(inverse_raw))
        .right(inverse_chosen)
        .endpoints(inverse_raw, inverse_chosen, "inverse word")
    )


def certify_witness(
    kernel: Kernel, witness: dict[str, Any], chain: Row, old_rows: Matrix
) -> tuple[Equality, list[Equality]]:
    prefix: Word = ()
    word_equality = kernel.reflexive(ONE)
    derivative_equalities = [kernel.reflexive(ZERO) for _ in range(5)]
    accumulated: Row = [{} for _ in range(4)]
    for factor in witness["relator_conjugates"]:
        index, sign = factor["relator"], factor["sign"]
        c = reduce_word(factor["conjugator"])
        r = RELATORS[index - 1]
        relation_equality = kernel.primitive(index)
        if sign == -1:
            relation_equality = inverse_word_equality(relation_equality, r, ())
        signed_r = r if sign == 1 else word_inv(r)
        factor_word = word_product(c, signed_r, word_inv(c))
        factor_equality = relation_equality.left(monomial(c)).right(monomial(word_inv(c)))
        factor_equality = factor_equality.endpoints(monomial(factor_word), ONE, "conjugate relation")
        factor_derivatives: list[Equality] = []
        contribution = row_scale(p_scale(sign, monomial(c)), old_rows[index - 1])
        for j in range(5):
            derivative = factor_equality.right(fox(c)[j]).neg()
            if sign == -1:
                derivative = derivative.minus(relation_equality.left(monomial(c)).right(fox(r)[j]))
            factor_derivatives.append(
                derivative.endpoints(fox(factor_word)[j], contribution[j], "conjugate Fox derivative")
            )
        next_prefix = word_mul(prefix, factor_word)
        add_term(accumulated[index - 1], c, sign)
        next_boundary = boundary(accumulated, old_rows)
        derivative_equalities = [
            derivative_equalities[j]
            .plus(word_equality.times(factor_derivatives[j]))
            .endpoints(fox(next_prefix)[j], next_boundary[j], "telescoping Fox derivative")
            for j in range(5)
        ]
        word_equality = word_equality.times(factor_equality)
        prefix = next_prefix
    target = tuple(witness["target_free_word"])
    require(prefix == target and accumulated == chain, "witness chain/target extraction failed")
    raw_boundary = boundary(chain, old_rows)
    return (
        word_equality.endpoints(monomial(target), ONE, "witness word"),
        [
            equality.flip().endpoints(raw_boundary[j], fox(target)[j], "witness boundary")
            for j, equality in enumerate(derivative_equalities)
        ],
    )


@dataclass(frozen=True)
class PathEvaluation:
    raw: Word
    chosen: Word
    value: Equality
    derivatives: tuple[Equality, ...]

    @classmethod
    def literal(cls, kernel: Kernel, word: Word) -> PathEvaluation:
        word = reduce_word(word)
        return cls(word, word, kernel.reflexive(monomial(word)), tuple(kernel.reflexive(p) for p in fox(word)))

    @classmethod
    def trivial_value(cls, word: Word, value: Equality) -> PathEvaluation:
        require(value.lhs == monomial(word) and value.rhs == ONE, "trivial path value endpoints")
        return cls(word, (), value, tuple(value.kernel.reflexive(p) for p in fox(word)))

    def multiply(self, other: PathEvaluation) -> PathEvaluation:
        raw, chosen = word_mul(self.raw, other.raw), word_mul(self.chosen, other.chosen)
        value = self.value.times(other.value).endpoints(monomial(raw), monomial(chosen), "path value product")
        derivatives = []
        for j in range(5):
            equality = self.derivatives[j].plus(self.value.times(other.derivatives[j]))
            derivatives.append(equality.endpoints(fox(raw)[j], equality.rhs, "path derivative product"))
        return PathEvaluation(raw, chosen, value, tuple(derivatives))

    def inverse(self) -> PathEvaluation:
        raw, chosen = word_inv(self.raw), word_inv(self.chosen)
        value = inverse_word_equality(self.value, self.raw, self.chosen)
        derivatives = []
        for j in range(5):
            equality = value.times(self.derivatives[j]).neg()
            derivatives.append(equality.endpoints(fox(raw)[j], equality.rhs, "path inverse derivative"))
        return PathEvaluation(raw, chosen, value, tuple(derivatives))


def path_product(*paths: PathEvaluation) -> PathEvaluation:
    require(bool(paths), "empty path product")
    result = paths[0]
    for path in paths[1:]:
        result = result.multiply(path)
    return result


def path_commutator(left: PathEvaluation, right: PathEvaluation) -> PathEvaluation:
    return path_product(left, right, left.inverse(), right.inverse())


def norm_equalities(kernel: Kernel, generator: int, order: int, torsion: Equality) -> tuple[Equality, Equality]:
    n = norm(generator, order)
    quotient = {(generator,) * k: order - 1 - k for k in range(order - 1)}
    annihilator = torsion.neg().endpoints(
        p_mul(n, p_sub(ONE, monomial((generator,)))), ZERO, "norm annihilator"
    )
    square = torsion.left(quotient).endpoints(p_mul(n, n), p_scale(order, n), "norm square")
    return annihilator, square


def expected_witness_boundaries(rows: Matrix) -> dict[str, Row]:
    b1, b2 = rows[4], rows[5]
    n15, n26 = norm(2, 15), norm(4, 26)
    one_a1, one_a2 = p_sub(ONE, monomial(A1)), p_sub(ONE, monomial(A2))
    return {
        "U1": row_sub(row_scale(one_a1, b1), basis_row(5, 1, n15)),
        "U2": row_sub(row_scale(one_a2, b2), basis_row(5, 3, n26)),
        "P1": row_sub(b1, basis_row(5, 3, n26)),
        "P2": row_sub(row_scale(monomial(S), b2), basis_row(5, 1, n15)),
        "E1": row_sub(b1, row_scale(one_a2, b2)),
        "E2": row_sub(row_scale(monomial(S), b2), row_scale(one_a1, b1)),
    }


def certify_boundaries(
    kernel: Kernel, data: dict[str, Any], actual: dict[str, Any]
) -> tuple[dict[str, list[Equality]], tuple[Equality, Equality], tuple[Equality, Equality]]:
    rows, chains = actual["raw_fox_boundary_rows"], actual["chains"]
    word_proofs: dict[str, Equality] = {}
    raw_proofs: dict[str, list[Equality]] = {}
    for name, witness in zip(WITNESS_NAMES, data["free_group_identity_witnesses"]):
        word_proofs[name], raw_proofs[name] = certify_witness(kernel, witness, chains[name], rows[:4])
    require(chains["E1"] == row_sub(chains["P1"], chains["U2"]), "E1 chain is not P1-U2")
    require(chains["E2"] == row_sub(chains["P2"], chains["U1"]), "E2 chain is not P2-U1")

    t1_value, t2_value = kernel.primitive(5), kernel.primitive(6)
    a26, a15 = (4,) * 26, (2,) * 15
    torsion26 = word_proofs["P1"].right(monomial(a26)).flip().then(t1_value)
    conjugated_t2 = t2_value.left(monomial(S)).right(monomial(word_inv(S)))
    torsion15 = word_proofs["P2"].right(monomial(a15)).flip().then(conjugated_t2)
    torsion26 = torsion26.endpoints(monomial(a26), ONE, "derived a2 torsion")
    torsion15 = torsion15.endpoints(monomial(a15), ONE, "derived a1 torsion")

    t1 = PathEvaluation.trivial_value(T1, t1_value)
    t2 = PathEvaluation.trivial_value(T2, t2_value)
    a1, a2, s = (PathEvaluation.literal(kernel, w) for w in (A1, A2, S))
    a15_path, a26_path = PathEvaluation.trivial_value(a15, torsion15), PathEvaluation.trivial_value(a26, torsion26)
    comm1, comm2 = path_commutator(t1, a1), path_commutator(t2, a2)
    conjugated_t2_path = path_product(s, t2, s.inverse())
    paths = {
        "U1": path_product(comm1, a15_path.inverse()),
        "U2": path_product(comm2, a26_path.inverse()),
        "P1": path_product(t1, a26_path.inverse()),
        "P2": path_product(conjugated_t2_path, a15_path.inverse()),
        "E1": path_product(t1, comm2.inverse()),
        "E2": path_product(conjugated_t2_path, comm1.inverse()),
    }
    wanted = expected_witness_boundaries(rows)
    result: dict[str, list[Equality]] = {}
    for name, witness in zip(WITNESS_NAMES, data["free_group_identity_witnesses"]):
        path = paths[name]
        require(path.raw == tuple(witness["target_free_word"]) and path.chosen == (), f"{name}: wrong evaluated path")
        result[name] = [
            raw_proofs[name][j]
            .then(path.derivatives[j])
            .endpoints(boundary(chains[name], rows[:4])[j], wanted[name][j], f"{name} boundary formula")
            for j in range(5)
        ]
    return result, norm_equalities(kernel, 2, 15, torsion15), norm_equalities(kernel, 4, 26, torsion26)


def certify_fillings(
    kernel: Kernel,
    actual: dict[str, Any],
    proofs: dict[str, list[Equality]],
    norms15: tuple[Equality, Equality],
    norms26: tuple[Equality, Equality],
) -> dict[str, list[Equality]]:
    rows, chains = actual["raw_fox_boundary_rows"], actual["chains"]
    b1, b2 = rows[4], rows[5]
    n15, n26 = norm(2, 15), norm(4, 26)
    one_a1, one_a2 = p_sub(ONE, monomial(A1)), p_sub(ONE, monomial(A2))
    sinv = monomial(word_inv(S))
    result = {name: [] for name in ("F26", "F15_2", "F15_1", "F1", "F2")}
    raw_boundaries = {name: boundary(chains[name], rows[:4]) for name in result}
    for j in range(5):
        substitute26 = proofs["P1"][j].left(p_scale(26, ONE)).minus(proofs["U2"][j].left(n26))
        correction26 = norms26[0].right(b2[j]).neg()
        if j == 3:
            correction26 = correction26.plus(norms26[1])
        correction26 = correction26.endpoints(substitute26.rhs, p_scale(26, b1[j]), "F26 norm cancellation")
        result["F26"].append(
            substitute26.then(correction26).endpoints(raw_boundaries["F26"][j], p_scale(26, b1[j]), "F26 boundary")
        )

        substitute15 = proofs["P2"][j].left(p_scale(15, ONE)).minus(proofs["U1"][j].left(n15))
        correction15 = norms15[0].right(b1[j]).neg()
        if j == 1:
            correction15 = correction15.plus(norms15[1])
        correction15 = correction15.endpoints(
            substitute15.rhs, p_scale(15, p_mul(monomial(S), b2[j])), "F15 norm cancellation"
        )
        result["F15_2"].append(
            substitute15.then(correction15)
            .left(sinv)
            .endpoints(raw_boundaries["F15_2"][j], p_scale(15, b2[j]), "F15_2 boundary")
        )
        result["F15_1"].append(
            proofs["E1"][j]
            .left(p_scale(15, ONE))
            .plus(result["F15_2"][j].left(one_a2))
            .endpoints(raw_boundaries["F15_1"][j], p_scale(15, b1[j]), "F15_1 boundary")
        )
        result["F1"].append(
            result["F15_1"][j]
            .left(p_scale(7, ONE))
            .minus(result["F26"][j].left(p_scale(4, ONE)))
            .endpoints(raw_boundaries["F1"][j], b1[j], f"FINAL F1 coordinate {j}")
        )
        result["F2"].append(
            proofs["E2"][j]
            .plus(result["F1"][j].left(one_a1))
            .left(sinv)
            .endpoints(raw_boundaries["F2"][j], b2[j], f"FINAL F2 coordinate {j}")
        )
    return result


def certify_splitting(kernel: Kernel, actual: dict[str, Any], fillings: dict[str, list[Equality]]) -> int:
    rows, d3 = actual["raw_fox_boundary_rows"], actual["D3"]
    splitting = actual["splitting_coefficients"]
    q, h2, r2, i2 = (splitting[name] for name in ("q", "h2", "r2", "i2"))
    require(matrix_mul(d3, q) == identity_matrix(2), "D3*q is not I2")
    require(matrix_mul(d3, h2) == identity_matrix(2), "D3*h2 is not I2")
    require(matrix_mul(i2, r2) == identity_matrix(4), "i2*r2 is not I4")
    require(matrix_mul(d3, r2) == [[{} for _ in range(4)] for _ in range(2)], "D3*r2 is not zero")
    require(
        matrix_sub(identity_matrix(6), matrix_mul(r2, i2)) == matrix_mul(h2, d3),
        "I6-r2*i2 is not h2*D3",
    )
    cycles = matrix_mul(d3, rows)
    chain_map = matrix_mul(r2, rows[:4])
    for i, name in enumerate(("F1", "F2")):
        for j in range(5):
            fillings[name][j].neg().endpoints(cycles[i][j], ZERO, f"D3*D2[{i},{j}]")
    for i in range(6):
        for j in range(5):
            if i < 4:
                kernel.reflexive(chain_map[i][j], rows[i][j])
            else:
                fillings["F1" if i == 4 else "F2"][j].endpoints(
                    chain_map[i][j], rows[i][j], f"retraction chain map [{i},{j}]"
                )
    return 5


def verify(data: Any) -> dict[str, Any]:
    actual = validate_input(data)
    kernel = Kernel()
    for word in RELATORS + tuple(tuple(w["target_free_word"]) for w in data["free_group_identity_witnesses"]):
        fundamental = p_add(
            *(p_mul(fox(word)[j], p_sub(monomial((j + 1,)), ONE)) for j in range(5))
        )
        require(fundamental == p_sub(monomial(word), ONE), "raw Fox fundamental identity failed")
    boundaries, norms15, norms26 = certify_boundaries(kernel, data, actual)
    fillings = certify_fillings(kernel, actual, boundaries, norms15, norms26)
    free_splitting_checks = certify_splitting(kernel, actual, fillings)
    finals = fillings["F1"] + fillings["F2"]
    return {
        "checked_equalities": kernel.checked_equalities,
        "expanded_ideal_terms_including_intermediates": kernel.expanded_ideal_terms,
        "maximum_ideal_terms": kernel.max_ideal_terms,
        "source_witnesses": 6,
        "source_factors": sum(len(w["relator_conjugates"]) for w in data["free_group_identity_witnesses"]),
        "fox_fundamental_checks": 12,
        "witness_boundary_coordinates": 30,
        "final_filling_coordinates": 10,
        "final_coordinate_ideal_terms": [len(e.ideal) for e in finals],
        "final_coordinate_residual_terms": [len(p_sub(e.lhs, e.rhs)) for e in finals],
        "D3_cycle_coordinates": 10,
        "retraction_chain_map_coordinates": 30,
        "free_ring_splitting_identities": free_splitting_checks,
        "all_final_ideal_expansions_match": True,
    }


def unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        require(key not in result, f"duplicate JSON key: {key}")
        result[key] = value
    return result


def invalid_number(value: str) -> Any:
    raise CertificateError(f"non-integral or non-finite JSON number: {value}")


def parse_certificate(text: str) -> Any:
    try:
        return json.loads(
            text, object_pairs_hook=unique_object, parse_float=invalid_number, parse_constant=invalid_number
        )
    except (ValueError, RecursionError) as error:
        raise CertificateError(f"invalid JSON: {error}") from error


def replace_at(data: Any, path: tuple, value: Any) -> None:
    for key in path[:-1]:
        data = data[key]
    data[path[-1]] = value


def self_test(certificate_path: Path) -> dict[str, Any]:
    data = parse_certificate(certificate_path.read_text(encoding="utf-8"))
    baseline = verify(data)
    first_f1 = next(i for i, poly in enumerate(data["chains"]["F1"]) if poly)
    first_f2 = next(i for i, poly in enumerate(data["chains"]["F2"]) if poly)
    mutations: list[tuple[str, tuple, Any]] = [
        ("attaching_orientation", ("attaching_words", 0, "word"), list(word_inv(RELATORS[0]))),
        ("target_orientation", ("free_group_identity_witnesses", 0, "target_free_word"), list(word_inv(tuple(data["free_group_identity_witnesses"][0]["target_free_word"])))),
        ("positive_witness_sign", ("free_group_identity_witnesses", 0, "relator_conjugates", 0, "sign"), -1),
        ("negative_witness_sign", ("free_group_identity_witnesses", 4, "relator_conjugates", 2, "sign"), 1),
        ("positive_conjugator", ("free_group_identity_witnesses", 0, "relator_conjugates", 0, "conjugator"), [1, 2]),
        ("negative_conjugator", ("free_group_identity_witnesses", 4, "relator_conjugates", 2, "conjugator"), [1]),
        ("bezout_coefficient", ("parameters", "bezout_coefficients", 1), -3),
        ("torsion_order", ("parameters", "torsion_orders", 0), 16),
        ("D3_orientation", ("D3", 0, first_f1, 0, 0), -data["D3"][0][first_f1][0][0]),
        ("projection_coefficient", ("splitting_coefficients", "q", 4, 0, 0, 0), 2),
        ("homotopy_coefficient", ("splitting_coefficients", "h2", 5, 1, 0, 0), -1),
        ("retraction_coefficient", ("splitting_coefficients", "r2", 4, first_f1, 0, 0), data["splitting_coefficients"]["r2"][4][first_f1][0][0] + 1),
        ("boundary_coefficient", ("raw_fox_boundary_rows", 0, 0, 0, 0), data["raw_fox_boundary_rows"][0][0][0][0] + 1),
        ("filling_coefficient", ("chains", "F1", first_f1, 0, 0), data["chains"]["F1"][first_f1][0][0] + 1),
        ("bool_integer", ("parameters", "torsion_orders", 0), True),
        ("float_integer", ("chains", "F2", first_f2, 0, 0), 1.0),
        ("string_letter", ("free_group_identity_witnesses", 0, "relator_conjugates", 0, "conjugator"), ["1"]),
        ("bool_sign", ("free_group_identity_witnesses", 0, "relator_conjugates", 0, "sign"), True),
        ("wrong_matrix_width", ("raw_fox_boundary_rows", 0), data["raw_fox_boundary_rows"][0][:-1]),
        ("wrong_term_shape", ("chains", "F1", first_f1, 0), [1]),
        ("zero_coefficient", ("chains", "F1", first_f1, 0, 0), 0),
        ("unreduced_monomial", ("chains", "F1", first_f1, 0, 1), [1, -1]),
        ("repeated_monomial", ("chains", "F1", first_f1), data["chains"]["F1"][first_f1] + [data["chains"]["F1"][first_f1][0]]),
        ("null_polynomial", ("chains", "F1", first_f1), None),
        ("extra_ideal_generator", ("ideal_membership_recipe", "ideal_generators"), [1, 2, 3, 4, 5, 6, 7]),
    ]
    rejections: list[str] = []
    for name, path, value in mutations:
        corrupted = copy.deepcopy(data)
        replace_at(corrupted, path, value)
        try:
            verify(parse_certificate(json.dumps(corrupted)))
        except CertificateError:
            rejections.append(name)
        else:
            raise CertificateError(f"self-test accepted corruption: {name}")
    malformed = [
        ("unknown_field", json.dumps(dict(data, unexpected=True))),
        ("missing_field", json.dumps({k: v for k, v in data.items() if k != "D3"})),
        ("root_shape", "[]"),
        ("duplicate_json_key", '{"format":"a","format":"b"}'),
        ("nonfinite_json_number", '{"value":NaN}'),
    ]
    for name, text in malformed:
        try:
            verify(parse_certificate(text))
        except CertificateError:
            rejections.append(name)
        else:
            raise CertificateError(f"self-test accepted malformed JSON: {name}")

    bad = copy.deepcopy(data)
    replace_at(bad, ("chains", "F1", first_f1, 0, 0), data["chains"]["F1"][first_f1][0][0] + 1)
    fixture = Path(__file__).resolve().parent / f".corrupted_certificate_cli_{os.getpid()}.json"
    created = False
    try:
        with fixture.open("x", encoding="utf-8") as handle:
            created = True
            json.dump(bad, handle, separators=(",", ":"))
        completed = subprocess.run(
            [sys.executable, str(Path(__file__).resolve()), "--certificate", str(fixture)],
            capture_output=True,
            text=True,
            check=False,
            timeout=60,
        )
        require(completed.returncode == 2, f"public CLI corruption returned {completed.returncode}, expected 2")
        require(
            "certificate rejected" in completed.stderr and "chains.F1" in completed.stderr,
            "public CLI did not reject the changed filling coefficient",
        )
        require(not completed.stdout.strip(), "public CLI emitted success output for a corruption")
        cli_diagnostic = completed.stderr.strip()
    finally:
        if created:
            fixture.unlink()
    require(not fixture.exists(), "public CLI fixture was not removed")
    return {
        "status": "ok",
        "baseline": baseline,
        "mutation_rejections": len(rejections),
        "rejected_mutations": rejections,
        "public_cli_rejection": {
            "exit_code": completed.returncode,
            "diagnostic": cli_diagnostic,
            "fixture_removed": True,
        },
        "certificate_bytes": certificate_path.stat().st_size,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--certificate", type=Path, default=Path(__file__).resolve().with_name("exact_certificate.json"))
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--emit-certificate", action="store_true", help="write the explicit input certificate, without claiming replay success")
    mode.add_argument("--self-test", action="store_true", help="one baseline replay plus corruption tests and a public-CLI rejection")
    args = parser.parse_args()
    try:
        if args.emit_certificate:
            encoded = json.dumps(make_certificate(), ensure_ascii=True, separators=(",", ":")) + "\n"
            args.certificate.write_text(encoded, encoding="utf-8")
            output = {"status": "emitted", "path": str(args.certificate), "bytes": args.certificate.stat().st_size}
        elif args.self_test:
            output = self_test(args.certificate)
        else:
            output = {
                "status": "ok",
                **verify(parse_certificate(args.certificate.read_text(encoding="utf-8"))),
                "certificate_bytes": args.certificate.stat().st_size,
            }
    except (CertificateError, OSError, subprocess.SubprocessError) as error:
        print(f"certificate rejected: {error}", file=sys.stderr)
        return 2
    print(json.dumps(output, sort_keys=True, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
