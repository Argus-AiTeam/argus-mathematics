#!/usr/bin/env python3
"""Replay exact algebraic identities and explicitly bounded diagnostics."""

import argparse
import hashlib
import itertools
import json
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path

import sympy as sp
from sympy.core.random import seed
from sympy.polys.galoistools import gf_factor


ROOT = Path(__file__).resolve().parent
Element = tuple[int, ...]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


@dataclass(frozen=True)
class FiniteField:
    prime: int
    modulus: tuple[int, ...]

    @property
    def degree(self):
        return len(self.modulus) - 1

    @property
    def order(self):
        return self.prime**self.degree

    def reduce(self, coefficients):
        values = [int(c) % self.prime for c in coefficients]
        values += [0] * max(0, self.degree - len(values))
        for k in range(len(values) - 1, self.degree - 1, -1):
            c = values[k]
            for j in range(self.degree):
                values[k - self.degree + j] = (
                    values[k - self.degree + j] - c * self.modulus[j]
                ) % self.prime
        return tuple(values[: self.degree])

    def scalar(self, n):
        return self.reduce([n])

    def add(self, x, y):
        return tuple((a + b) % self.prime for a, b in zip(x, y, strict=True))

    def subtract(self, x, y):
        return tuple((a - b) % self.prime for a, b in zip(x, y, strict=True))

    def multiply(self, x, y):
        values = [0] * (2 * self.degree - 1)
        for i, a in enumerate(x):
            for j, b in enumerate(y):
                values[i + j] += a * b
        return self.reduce(values)

    def power(self, x, n):
        if n < 0:
            require(x != self.scalar(0), "negative power of zero")
            return self.power(self.power(x, self.order - 2), -n)
        result = self.scalar(1)
        while n:
            if n % 2:
                result = self.multiply(result, x)
            x = self.multiply(x, x)
            n //= 2
        return result

    def total(self, values):
        result = self.scalar(0)
        for value in values:
            result = self.add(result, value)
        return result

    def basis(self):
        return [
            tuple(int(i == j) for j in range(self.degree))
            for i in range(self.degree)
        ]


def root_field(prime, blocks):
    length = 5 * blocks + int(5 * blocks % prime == 0)
    variable = sp.Symbol("T")
    polynomial = sp.Poly(sp.cyclotomic_poly(length, variable), variable)
    _, factors = gf_factor(
        [int(c) for c in polynomial.all_coeffs()], prime, sp.ZZ
    )
    factor = min((f for f, _ in factors), key=lambda f: (len(f), f))
    modulus = tuple(int(c) % prime for c in reversed(factor))
    field = FiniteField(prime, modulus)
    require(modulus[-1] == 1, "extension modulus must be monic")
    extension_poly = sp.Poly(
        sum(c * variable**i for i, c in enumerate(modulus)),
        variable,
        modulus=prime,
    )
    require(extension_poly.is_irreducible, "extension modulus is reducible")
    root = field.reduce([0, 1])
    require(field.power(root, length) == field.scalar(1), "root power")
    for divisor in sp.factorint(length):
        require(
            field.power(root, length // int(divisor)) != field.scalar(1),
            "root is not primitive",
        )
    return field, root, length


def polynomial_identities():
    g, h, u, v, m = sp.symbols("g h u v m")
    mismatch = (
        g**2 + h * u - h**2 - h * v
        - (g - h)**2 - h * (u - v + 2 * (g - h))
    )
    growth = (3 * m + 1)**3 - 27 * m**3 - 27 * m**2 - (9 * m + 1)
    require(sp.Poly(sp.expand(mismatch), g, h, u, v).is_zero, "weight identity")
    require(sp.Poly(sp.expand(growth), m).is_zero, "growth identity")
    return {"integer_weight_residual": "0", "integer_growth_residual": "0"}


def fourier_checks(fields):
    phase_count = 0
    support_count = 0
    presentations = []
    for (prime, blocks), (field, root, length) in fields.items():
        require(3 * (blocks - 1) < length <= 5 * blocks + 1, "Fourier range")
        require(length % prime != 0, "Fourier denominator is not invertible")
        powers = [field.power(root, r) for r in range(length)]
        inverse_length = field.scalar(pow(length, -1, prime))
        phases = {}
        for k in range(-3 * (blocks - 1), 3 * (blocks - 1) + 1):
            phase = field.multiply(
                inverse_length, field.total(powers[r * k % length] for r in range(length))
            )
            require(phase == field.scalar(int(k == 0)), "Fourier phase indicator")
            phases[k] = phase
            phase_count += 1
        for sector, guess, left, right in itertools.product(
            range(1, blocks + 1), repeat=4
        ):
            relation = left - right + 2 * (guess - sector)
            if phases[relation] != field.scalar(0):
                weight = guess**2 + sector * left - sector**2 - sector * right
                require(weight == (guess - sector)**2, "surviving weight")
                require(weight >= 0, "negative supported weight")
                require(
                    (weight == 0) == (guess == sector and left == right),
                    "separated support",
                )
            support_count += 1
        presentations.append({
            "characteristic": prime,
            "M": blocks,
            "L": length,
            "degree": field.degree,
            "modulus_constant_first": list(field.modulus),
        })
    return {
        "presentations": presentations,
        "exact_phase_sums": phase_count,
        "sector_quadruples": support_count,
    }


def descent_checks(fields):
    coefficient_checks = 0
    powered_support_checks = 0
    dense_product_checks = 0
    copies_by_power = []
    for prime in (2, 3, 5):
        field, root, _ = fields[prime, 2]
        basis = field.basis()
        p = field.prime
        dense = [
            field.reduce([(i + 1) * (r + 1) + i * i for i in range(field.degree)])
            for r in range(3)
        ]
        structure = {
            (s, t, k): field.multiply(field.multiply(bs, bt), bk)[0]
            for s, bs in enumerate(basis)
            for t, bt in enumerate(basis)
            for k, bk in enumerate(basis)
        }
        for x, y, z in itertools.product(dense, repeat=3):
            left = field.multiply(field.multiply(x, y), z)[0]
            right = sum(
                x[s] * y[t] * z[k] * value
                for (s, t, k), value in structure.items()
            ) % p
            require(left == right, "normalized functional product expansion")
            dense_product_checks += 1

        a, b = 2, 3
        output = a + b - 1
        left_maps = [field.power(root, i + 1) for i in range(a)]
        right_maps = [field.power(root, j + 2) for j in range(b)]
        output_maps = [field.power(root, -k - 3) for k in range(output)]
        third_maps = {
            (s, t, k): field.multiply(field.multiply(bs, bt), output_maps[k])[0]
            for s, bs in enumerate(basis)
            for t, bt in enumerate(basis)
            for k in range(output)
        }
        u = lambda i, x: int(x == i or x == i + 1)
        v = lambda j, y: int(y == j or y == j + 1)
        w = lambda k, z: int(z == k or z == k + 1)
        for x, y, z in itertools.product(range(a), range(b), range(output)):
            expected = sum(
                u(i, x) * v(j, y) * w(i + j, z)
                for i in range(a) for j in range(b)
            ) % p
            extended = field.total(
                field.multiply(
                    field.scalar(u(i, x) * v(j, y) * w(i + j, z)),
                    field.multiply(
                        field.multiply(left_maps[i], right_maps[j]),
                        output_maps[i + j],
                    ),
                )
                for i in range(a) for j in range(b)
            )
            require(extended == field.scalar(expected), "E-restriction target not in F")
            descended = sum(
                u(i, x) * v(j, y) * w(i + j, z)
                * left_maps[i][s] * right_maps[j][t] * third_maps[s, t, i + j]
                for s in range(field.degree) for t in range(field.degree)
                for i in range(a) for j in range(b)
            ) % p
            require(descended == expected, "F-restriction coefficient formula")
            coefficient_checks += 1

        for power in (1, 2, 3):
            for word in itertools.product(list(itertools.product(range(a), range(b))),
                                          repeat=power):
                x = field.power(root, sum(i + 1 for i, _ in word))
                y = field.power(root, sum(j + 2 for _, j in word))
                z = field.power(root, -sum(i + j + 3 for i, j in word))
                require(field.multiply(field.multiply(x, y), z) == field.scalar(1),
                        "powered E-restriction")
                descended = sum(
                    x[s] * y[t] * field.multiply(field.multiply(bs, bt), z)[0]
                    for s, bs in enumerate(basis) for t, bt in enumerate(basis)
                ) % p
                require(descended == 1, "powered descent")
                powered_support_checks += 1
            copies_by_power.append({
                "characteristic": prime, "tensor_power": power,
                "extension_degree": field.degree, "source_copies": field.degree**2,
            })
    return {
        "dense_product_checks": dense_product_checks,
        "mixed_target_coefficients": coefficient_checks,
        "powered_support_checks": powered_support_checks,
        "copy_count_by_power": copies_by_power,
    }


def filtration_basis(degree):
    size = 2 * (degree + 1)
    columns = []
    for i in range(degree + 1):
        vector = [0] * size
        vector[i] = 1
        columns.append(sp.Matrix(vector))
    vector = [0] * size
    vector[-1] = 1
    columns.append(sp.Matrix(vector))
    for j in range(degree):
        vector = [0] * size
        vector[degree + 1 + j] = 1
        vector[j + 1] = -1
        columns.append(sp.Matrix(vector))
    matrix = sp.Matrix.hstack(*columns)
    require(abs(matrix.det()) == 1, "determinant basis is not unimodular")
    return matrix


def filtration_checks():
    slices = 0
    for a in range(1, 6):
        for b in range(2, 7):
            e, target_degree = b - 1, a + b - 2
            source_basis = filtration_basis(e)
            target_basis = filtration_basis(target_degree)
            inverse = target_basis.inv()
            for i in range(a):
                original = sp.zeros(2 * (target_degree + 1), 2 * (e + 1))
                for j in range(e + 1):
                    original[i + j, j] = 1
                    original[target_degree + 1 + i + j, e + 1 + j] = 1
                transformed = inverse * original * source_basis
                expected = sp.zeros(*transformed.shape)
                for j in range(e + 2):
                    expected[i + j, j] = 1
                for j in range(e):
                    expected[target_degree + 2 + i + j, e + 2 + j] = 1
                if i < a - 1:
                    expected[target_degree + 2 + e + i, e + 1] = 1
                require(transformed == expected, "simultaneous slice or orientation")
                for row in range(transformed.rows):
                    for col in range(transformed.cols):
                        weight = int(row >= target_degree + 2) - int(col >= e + 2)
                        if transformed[row, col] != 0:
                            require(weight >= 0, "negative filtration block")
                        if weight == 0:
                            require(transformed[row, col] ==
                                    expected[row, col], "diagonal block mismatch")
                for prime in (2, 3, 5):
                    require(transformed.applyfunc(lambda n: int(n) % prime) ==
                            expected.applyfunc(lambda n: int(n) % prime),
                            "characteristic slice reduction")
                slices += 1
    return {"a": [1, 5], "b": [2, 6], "simultaneous_slices": slices,
            "unimodular_over_integers": True, "diagnostic_characteristics": [2, 3, 5]}


def tripling_checks():
    parameter_pairs = 0
    supported_terms = 0
    for a in range(1, 8):
        for h in range(1, 7):
            length = 3 * h + a - 1
            surviving = set()
            for x in range(a):
                for y in range(length):
                    z = x + y
                    weight = int(h <= y <= 2 * h + a - 2) - int(
                        h + a - 1 <= z <= 2 * h + a - 2
                    )
                    require(weight >= 0, "negative tripling weight")
                    if weight == 0:
                        surviving.add((x, y, z))
                    supported_terms += 1
            left = {(x, r, x + r) for x in range(a) for r in range(h)}
            right = {
                (x, 2 * h + a - 1 + r, 2 * h + a - 1 + x + r)
                for x in range(a) for r in range(h)
            }
            middle = {
                (a - 1 - u, h + u + r, h + a - 1 + r)
                for u in range(a) for r in range(h)
            }
            require(surviving == left | middle | right, "tripling branch support")
            require(len(surviving) == 3 * a * h, "tripling branch count")
            parameter_pairs += 1
    return {"a": [1, 7], "h": [1, 6], "parameter_pairs": parameter_pairs,
            "supported_terms": supported_terms, "middle_reverses_first_leg": True}


def convolution_checks(fields):
    coefficients = 0
    for prime in (2, 3, 5):
        field, root, _ = fields[prime, 2]
        for a in range(1, 4):
            for b in range(1, 4):
                size = a + b - 1
                points = [field.power(root, t) for t in range(size)]
                require(len(set(points)) == size, "interpolation points collide")
                lagrange = []
                for t, point in enumerate(points):
                    polynomial = [field.scalar(1)]
                    denominator = field.scalar(1)
                    for r, other in enumerate(points):
                        if r == t:
                            continue
                        expanded = [field.scalar(0)] * (len(polynomial) + 1)
                        for k, c in enumerate(polynomial):
                            expanded[k] = field.subtract(
                                expanded[k], field.multiply(other, c)
                            )
                            expanded[k + 1] = field.add(expanded[k + 1], c)
                        polynomial = expanded
                        denominator = field.multiply(
                            denominator, field.subtract(point, other)
                        )
                    require(denominator != field.scalar(0), "zero Lagrange denominator")
                    inverse = field.power(denominator, field.order - 2)
                    lagrange.append([field.multiply(c, inverse) for c in polynomial])
                for i, j, k in itertools.product(range(a), range(b), range(size)):
                    reconstructed = field.total(
                        field.multiply(field.power(point, i + j), lagrange[t][k])
                        for t, point in enumerate(points)
                    )
                    require(reconstructed == field.scalar(int(k == i + j)),
                            "convolution interpolation coefficient")
                    coefficients += 1
    return {"a": [1, 3], "b": [1, 3], "characteristics": [2, 3, 5],
            "exact_reconstructed_coefficients": coefficients,
            "proof_scope": "finite-extension rank decompositions, not all-size rank proof"}


def growth_and_overhead_checks():
    h_value = Fraction(1)
    for a in range(1, 129):
        if a > 1:
            h_value *= 1 + Fraction(1, 3 * (a - 1))
        d_value = Fraction(3 * a - 1, 2) * h_value
        require(h_value**3 >= a and d_value**3 >= a**4, "diagonal recurrence")
    count = 0
    for q, degree, j in itertools.product((2, 3, 5), (0, 1, 7, 9), (1, 2, 4, 8, 64)):
        s = 1
        while q**s < j * degree + 2:
            s += 1
        require(q**s - 1 >= j * degree + 1, "insufficient nonzero points")
        require(s == 1 or q**(s - 1) < j * degree + 2, "nonminimal extension degree")
        count += 1
    variable = sp.Symbol("s")
    for prime in (2, 3, 5):
        for exponent in range(prime):
            matrix = sp.zeros(prime)
            for column in range(prime):
                row = (column + exponent) % prime
                matrix[row, column] = variable**((column + exponent) // prime)
            trace = sp.Poly(sp.trace(matrix), variable, modulus=prime)
            require(trace.is_zero, "inseparable trace diagnostic")
    return {"exact_diagonal_checks": [1, 128], "interpolation_degree_cases": count,
            "inseparable_trace_characteristics": [2, 3, 5],
            "limit_proof": "report.md sections 2, 3, 4, and 8; not inferred from samples"}


def jacobian_check():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    request = output["request"]
    require(request["operation_id"] == "modular.polynomial_identity.compute",
            "wrong Jacobian operation")
    require(request["payload"] == payload, "Jacobian payload mismatch")
    require(output["result"]["operation_id"] == request["operation_id"],
            "Jacobian result operation mismatch")
    value = output["result"]["output"]
    require(value["comparison_scope"] == "FORMAL_COEFFICIENTWISE_IDENTITY",
            "Jacobian operation did not certify formal coefficients")
    require(value["identical"] and value["residual"] == [], "Jacobian residual")
    require(value["modulus"] == 3, "Jacobian diagnostic characteristic")
    return {"operation_id": request["operation_id"], "server": output["server"]["version"],
            "protocol": output["protocol_version"], "modulus": 3,
            "adapter_status": "completed", "identical": True, "residual": [],
            "scope": "characteristic-three diagnostic only"}


def formal_check():
    record = json.loads((ROOT / "lean_result.json").read_text())
    require(record["status"] == "success" and record["exit_code"] == 0,
            "the stored real Lean compilation did not succeed")
    require(record["proof_holes"] == [] and record["audit_exit_code"] == 0,
            "Lean proof-hole or axiom audit failed")
    require(record["kernel"]["recorded"]["subject"]["subject_id"] == "AF_DESCENT_CORE",
            "the compiler record concerns another claim")
    require(record["kernel"]["recorded"]["verdict"] == "supports",
            "the compiler record is not supporting evidence")
    for path, key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        require(hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == record[key],
                f"{path} changed after the real compiler run")
    require("version 4.31.0," in record["tools"]["lean"]["version"], "wrong Lean version")
    return {
        "claim": "AF_DESCENT_CORE",
        "source": "Main.lean",
        "fidelity": "statement_fidelity.md",
        "official_record": "lean_result.json",
        "compiler_exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "source_and_fidelity_match": True,
        "compiler_replay": "This script checks the stored real compiler record and file hashes; use lean_evidence verify for a fresh compilation.",
    }


def bound_comparison():
    comparator = Fraction("2.371054886006746")
    conclusion = Fraction(9, 4)
    require(conclusion < comparator, "the theorem does not improve the staged all-field bound")
    return {
        "staged_every_field_bound": str(comparator),
        "candidate_every_field_bound": str(conclusion),
        "exact_difference": str(comparator - conclusion),
        "scope": "numerical strengthening of the staged every-field theorem; not a novelty verdict",
    }


def certificate():
    seed(0)
    fields = {(p, m): root_field(p, m) for p in (2, 3, 5) for m in (1, 2, 3)}
    return {
        "schema_version": 1,
        "theorem": "For every fixed field F, omega_F <= 9/4 in exact scalar arithmetic.",
        "evidence_class": "complete_prose_proof_with_formal_descent_core_and_exact_diagnostics",
        "novelty_status": "unestablished",
        "independent_review": "pending_host_invocation",
        "universal_polynomial_identities": polynomial_identities(),
        "fourier": fourier_checks(fields),
        "descent": descent_checks(fields),
        "determinant_filtration": filtration_checks(),
        "tripling": tripling_checks(),
        "convolution": convolution_checks(fields),
        "growth_and_overheads": growth_and_overhead_checks(),
        "jacobian": jacobian_check(),
        "formal_core": formal_check(),
        "bound_comparison": bound_comparison(),
        "external_theorem": "arxiv:1709.07851v3, section 1.2, Theorem 1.1 and Proposition 1.6",
        "not_machine_checked": [
            "The complete real-analytic and spectral argument in report.md",
            "Independent citation attribution and statement-fidelity approval",
            "Originality and publishable significance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    result = certificate()
    target = ROOT / "exact_certificate.json"
    if arguments.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(target.is_file(), "missing exact_certificate.json")
        require(json.loads(target.read_text()) == result, "certificate differs from exact replay")
    print(json.dumps({"ok": True, "certificate": str(target),
                      "stored_formal_core_matches": True,
                      "whole_exponent_theorem_is_not_formalized": True}, sort_keys=True))


if __name__ == "__main__":
    main()
