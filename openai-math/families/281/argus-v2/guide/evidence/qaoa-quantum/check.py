#!/usr/bin/env python3
"""Exact local checks for the pinned QAOA helper and seed constructions, not their limits."""

import argparse
import copy
import hashlib
import itertools
import json
import math
from dataclasses import dataclass
from fractions import Fraction as F
from pathlib import Path


@dataclass(frozen=True)
class C:
    re: F = F(0)
    im: F = F(0)

    def __add__(self, other):
        if not isinstance(other, C):
            other = C(F(other))
        return C(self.re + other.re, self.im + other.im)

    __radd__ = __add__

    def __neg__(self):
        return C(-self.re, -self.im)

    def __sub__(self, other):
        return self + (-other)

    def __mul__(self, other):
        if not isinstance(other, C):
            other = C(F(other))
        return C(self.re * other.re - self.im * other.im,
                 self.re * other.im + self.im * other.re)

    __rmul__ = __mul__


ZERO, ONE, I = C(), C(F(1)), C(F(0), F(1))
PAULI = {
    "I": [[ONE, ZERO], [ZERO, ONE]],
    "X": [[ZERO, ONE], [ONE, ZERO]],
    "Y": [[ZERO, -I], [I, ZERO]],
    "Z": [[ONE, ZERO], [ZERO, -ONE]],
}


def scale(a, scalar):
    return [[scalar * x for x in row] for row in a]


def add(a, b):
    return [[x + y for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def mul(a, b):
    return [[sum((a[i][k] * b[k][j] for k in range(len(b))), ZERO)
             for j in range(len(b[0]))] for i in range(len(a))]


def kron(a, b):
    return [[x * y for x in ra for y in rb] for ra in a for rb in b]


def word(axes):
    result = [[ONE]]
    for axis in axes:
        result = kron(result, PAULI[axis])
    return result


def comm(a, b):
    return add(mul(a, b), scale(mul(b, a), -1))


def require_equal(actual, expected, description):
    if actual != expected:
        raise ValueError(f"{description}: {actual!r} != {expected!r}")


def vacuum_mean(a):
    return sum((x for row in a for x in row), ZERO) * F(1, 2)


def apply_q(state, mode):
    """Unnormalized (a*)^n vacuum basis: a|n> = n|n-1>, norm squared n!."""
    out = {}
    for occupation, coefficient in state.items():
        raised = list(occupation)
        raised[mode] += 1
        raised = tuple(raised)
        out[raised] = out.get(raised, F(0)) + coefficient
        if occupation[mode]:
            lowered = list(occupation)
            lowered[mode] -= 1
            lowered = tuple(lowered)
            out[lowered] = (out.get(lowered, F(0))
                            + occupation[mode] * coefficient)
    return {key: value for key, value in out.items() if value}


def exact_checks(witness):
    count = 0
    for p in "YZ":
        require_equal(
            scale(comm(word(p + "YI"), word("IZZ")), -I * F(1, 2)),
            word(p + "XZ"), "first helper commutator")
        require_equal(
            scale(comm(word("YI"), word("ZY")), -I * F(1, 2)),
            word("XY"), "second helper commutator")
        require_equal(
            scale(comm(word(p + "XZ"), word("IXY")), I * F(1, 2)),
            scale(word(p + "IX"), witness["returning_sign"]),
            "returning sender cancellation")
        require_equal(
            scale(comm(word(p + "XZI"), word("IIYX")), I * F(1, 2)),
            scale(word(p + "XXX"), witness["nonreturning_sign"]),
            "nonreturning path")
        count += 4
    require_equal(mul(word("X"), mul(word("Z"), word("X"))),
                  scale(word("Z"), -1), "selective flip")
    require_equal(mul(word("Y"), word("X")),
                  scale(word("Z"), -I), "initial address sign")
    rotate_z = scale(mul(add(word("I"), scale(word("X"), I)),
                         mul(word("Z"),
                             add(word("I"), scale(word("X"), -I)))),
                     F(1, 2))
    require_equal(rotate_z, word("Y"), "beta_star rotation")

    k_second = add(scale(word("I"), -2),
                   scale(mul(word("Y"), word("Z")), -2))
    t = add(word("Y"), word("Z"))
    scalar = vacuum_mean(add(k_second, mul(t, t))) * F(1, 2)
    require_equal(scalar,
                  I * witness["unitary_clt_scalar_imaginary_coefficient"],
                  "small-unitary scalar correction")

    axis1 = add(scale(word("Z"), F(3, 5)), scale(word("Y"), F(4, 5)))
    axis2 = add(scale(word("Z"), F(-4, 5)), scale(word("Y"), F(3, 5)))
    require_equal(scale(comm(axis1, axis2), I * F(1, 2)),
                  word("X"), "perpendicular selective axes")
    vectors = [(1, 2), (2, 3), (-1, -2), (1, -2)]
    projections = [(F(3 * z + 4 * y, 5), F(-4 * z + 3 * y, 5))
                   for z, y in vectors]
    samples = {}
    for c1, c2 in projections:
        if not c1 or not c2:
            raise ValueError("zero selective projection")
        key, value = c1 ** 2, 1 / (c1 * c2)
        if key in samples:
            require_equal(samples[key], value, "opposite-pair compatibility")
        samples[key] = value
        a = scale(axis1, -I * c1)
        b = scale(axis2, -I * c2)
        bracket = comm(a, b)
        require_equal(comm(a, comm(a, bracket)),
                      scale(bracket, -4 * c1 ** 2),
                      "first-axis double bracket")
        require_equal(comm(b, comm(b, bracket)),
                      scale(bracket, -4 * c2 ** 2),
                      "second-axis double bracket")
    for c1, c2 in projections:
        u = c1 ** 2
        interpolated = F(0)
        for node, value in samples.items():
            basis = F(1)
            for other in samples:
                if other != node:
                    basis *= (u - other) / (node - other)
            interpolated += value * basis
        require_equal(c1 * c2 * interpolated, F(1),
                      "common X coefficient from polynomial interpolation")

    degree = witness["degree"]
    root_degree = math.isqrt(degree)
    require_equal(root_degree ** 2, degree, "square degree for rational example")
    coefficient = (F(witness["helper_count"], root_degree ** 3)
                   / F(witness["helper_probability"]))
    require_equal(coefficient, F(witness["returning_coefficient"]),
                  "three edge weights and helper density")
    occupation_cases = 0
    for degree in range(2, 9):
        for m in range(degree):
            subsets = list(itertools.combinations(range(degree), m))
            pairs = sum(degree - len(subset) for subset in subsets)
            squared = F(pairs ** 2,
                        degree * math.comb(degree, m)
                        * math.comb(degree, m + 1))
            require_equal(squared, (m + 1) * (1 - F(m, degree)),
                          "occupation creation coefficient squared")
            require_equal(F(math.comb(degree - 1, m), math.comb(degree, m)),
                          1 - F(m, degree), "vacuum deletion squared")
            occupation_cases += 1

    probabilities = [F(x) for x in witness["sender_probabilities"]]
    if any(p <= 0 for p in probabilities) or sum(probabilities) > 1:
        raise ValueError("invalid disjoint-mask probabilities")
    vacuum = (0,) * len(probabilities)
    state = {}
    for mode, p in enumerate(probabilities):
        term = apply_q(apply_q({vacuum: F(1)}, mode), mode)
        term[vacuum] -= 1
        for occupation, coefficient in term.items():
            state[occupation] = state.get(occupation, F(0)) + p * coefficient
    norm_squared = sum(coefficient ** 2
                       * math.prod(math.factorial(n) for n in occupation)
                       for occupation, coefficient in state.items())
    require_equal(norm_squared, 2 * sum(p * p for p in probabilities),
                  "orthogonal quadratic vacuum norm")
    require_equal(norm_squared,
                  F(witness["centered_quadratic_vacuum_norm_squared"]),
                  "quadratic witness")
    return {
        "helper_pauli_identities": count,
        "seed_pauli_identities": 3,
        "occupation_cases": occupation_cases,
        "small_unitary_scalar": "-i",
        "selective_interpolation_vectors": len(vectors),
        "distinct_selective_interpolation_nodes": len(samples),
        "returning_coefficient": str(F(witness["returning_coefficient"])),
        "quadratic_vacuum_norm_squared": str(norm_squared),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", nargs="?", type=Path,
                        default=Path(__file__).with_name("witness.json"))
    args = parser.parse_args()
    witness = json.loads(args.witness.read_text())
    result = exact_checks(witness)
    evidence = Path(__file__).resolve().parent
    sources = json.loads((evidence / "source-blobs.json").read_text())
    sections = (evidence.parents[2] / "paper"
                / sources["upstream_directory"].split("/")[1]
                / "build" / "sections")
    for name, expected in sources["sections"].items():
        data = (sections / name).read_bytes()
        blob = hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()
        require_equal(blob, expected, f"pinned section {name}")
    result["pinned_source_blobs"] = len(sources["sections"])
    mutations = {
        "flipped_returning_sign": ("returning_sign", -1),
        "flipped_nonreturning_sign": ("nonreturning_sign", -1),
        "wrong_helper_normalization": ("returning_coefficient", "1/100"),
        "omitted_covariance": ("centered_quadratic_vacuum_norm_squared", "7/16"),
        "omitted_unitary_scalar": ("unitary_clt_scalar_imaginary_coefficient", 0),
    }
    rejected = []
    for name, (key, value) in mutations.items():
        broken = copy.deepcopy(witness)
        broken[key] = value
        try:
            exact_checks(broken)
        except ValueError:
            rejected.append(name)
        else:
            raise AssertionError(f"checker accepted {name}")
    result["rejected_mutations"] = rejected
    result["p1_numerical_sanity_only"] = {
        "gamma": 0.5,
        "beta": math.pi / 8,
        "limiting_energy": math.exp(-0.5) / 2,
        "formula": "gamma * exp(-2*gamma**2) * sin(4*beta)",
        "finite_degree_edge_energy_at_same_angles": {
            str(d): math.sqrt(d) / 2 * math.sin(1 / math.sqrt(d))
                    * math.cos(1 / math.sqrt(d)) ** d
            for d in (10, 100, 1000, 10000)
        },
    }
    result["scope"] = (
        "Exact rational local algebra and finite occupation checks only; "
        "floating p=1 numbers are a normalization sanity check, "
        "not a proof of helper refinement or the singular echo limit."
    )
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
