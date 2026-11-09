#!/usr/bin/env python3
"""Replay exact arithmetic and the source-bound universal Lean certificate."""

import argparse
import hashlib
import json
from fractions import Fraction
from itertools import product
from math import comb
from pathlib import Path

import sympy as sp


BASE = Path(__file__).resolve().parent
ROOT = BASE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "Uniform-exclusion-of-Landau-Siegel-zeros-October-1-2026/build/paper.tex"
)
ZERO = (Fraction(0),) * 4
ONE = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))
COMPONENTS = (
    "DeterminantCore.lean",
    "Greedy.lean",
    "LatticeGeometry.lean",
    "RectInterpolation.lean",
    "Construction.lean",
    "Parameters.lean",
    "Biquadratic.lean",
    "ScalarDescent.lean",
    "FinalChain.lean",
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


class Biquadratic:
    def __init__(self, d):
        require(d in (-2, -1, 3), "Only the certified degree-four test fields are accepted")
        self.d = d

    @staticmethod
    def add(x, y):
        return tuple(a + b for a, b in zip(x, y, strict=True))

    @staticmethod
    def scale(n, x):
        return tuple(n * a for a in x)

    def sub(self, x, y):
        return self.add(x, self.scale(-1, y))

    def mul(self, x, y):
        out = [Fraction(0)] * 4
        for i, a in enumerate(x):
            for j, b in enumerate(y):
                overlap = i & j
                factor = (self.d if overlap & 1 else 1) * (2 if overlap & 2 else 1)
                out[i ^ j] += factor * a * b
        return tuple(out)

    def power(self, x, n):
        require(isinstance(n, int) and n >= 0, "Power exponent must be a nonnegative integer")
        result = ONE
        while n:
            if n & 1:
                result = self.mul(result, x)
            x = self.mul(x, x)
            n //= 2
        return result

    @staticmethod
    def conjugate(x, sigma=False, tau=False):
        return tuple(
            (-a if (bool(i & 1) and sigma) ^ (bool(i & 2) and tau) else a)
            for i, a in enumerate(x)
        )

    def inverse(self, x):
        require(x != ZERO, "Cannot invert zero")
        adj = ONE
        for sigma, tau in ((True, False), (False, True), (True, True)):
            adj = self.mul(adj, self.conjugate(x, sigma, tau))
        norm = self.mul(x, adj)
        require(norm[0] != 0 and norm[1:] == ZERO[1:], "Invalid field norm")
        return self.scale(1 / norm[0], adj)

    def norm(self, x):
        result = x
        for sigma, tau in ((True, False), (False, True), (True, True)):
            result = self.mul(result, self.conjugate(x, sigma, tau))
        require(result[1:] == ZERO[1:], "Norm is not rational")
        return result[0]

    @staticmethod
    def divisible(x, modulus):
        return all(a.denominator == 1 and a.numerator % modulus == 0 for a in x)


def reduce_row(field, row, basis):
    row = list(row)
    for pivot in sorted(basis):
        coefficient = row[pivot]
        if coefficient != ZERO:
            row = [
                field.sub(x, field.mul(coefficient, y))
                for x, y in zip(row, basis[pivot], strict=True)
            ]
    return row


def insert_row(field, row, basis):
    row = reduce_row(field, row, basis)
    pivot = next((i for i, x in enumerate(row) if x != ZERO), None)
    if pivot is None:
        return False
    inverse = field.inverse(row[pivot])
    basis[pivot] = tuple(field.mul(x, inverse) for x in row)
    return True


def determinant(field, matrix):
    n = len(matrix)
    require(all(len(row) == n for row in matrix), "Determinant matrix must be square")
    matrix = [list(row) for row in matrix]
    answer = ONE
    for i in range(n):
        pivot = next((j for j in range(i, n) if matrix[j][i] != ZERO), None)
        if pivot is None:
            return ZERO
        if pivot != i:
            matrix[i], matrix[pivot] = matrix[pivot], matrix[i]
            answer = field.scale(-1, answer)
        value = matrix[i][i]
        answer = field.mul(answer, value)
        inverse = field.inverse(value)
        for j in range(i + 1, n):
            factor = field.mul(matrix[j][i], inverse)
            if factor != ZERO:
                matrix[j] = [
                    field.sub(x, field.mul(factor, y))
                    for x, y in zip(matrix[j], matrix[i], strict=True)
                ]
    return answer


def weight(alpha, H):
    return alpha[0] + H * (alpha[1] + alpha[2])


def monomial_row(field, points, alpha):
    result = []
    for theta in points:
        value = field.power(theta, alpha[0])
        value = field.mul(value, field.power(field.conjugate(theta, True), alpha[1]))
        value = field.mul(value, field.power(field.conjugate(theta, True, True), alpha[2]))
        result.append(value)
    return tuple(result)


def greedy(field, N, H, reverse_ties):
    points = tuple(tuple(map(Fraction, n)) for n in product(range(N), repeat=4))
    require(len(set(points)) == N**4, "Integer box contains duplicate points")
    basis, selected, rows, prefixes = {}, [], [], []
    for w in range(N**4):
        indices = [
            (w - H * (b + c), b, c)
            for b in range(w // H + 1)
            for c in range(w // H - b + 1)
        ]
        for alpha in sorted(indices, reverse=reverse_ties):
            row = monomial_row(field, points, alpha)
            before = dict(basis)
            if insert_row(field, row, basis):
                selected.append(alpha)
                rows.append(row)
                prefixes.append(before)
                if len(selected) == N**4:
                    return points, selected, rows, prefixes
    raise AssertionError("Greedy selection did not reach the Vandermonde rank bound")


def legendre(d, p):
    value = pow(d % p, (p - 1) // 2, p)
    require(value in (0, 1, p - 1), "Euler criterion output is invalid")
    return -1 if value == p - 1 else value


def replay_grid(H, reverse_ties):
    field, N = Biquadratic(3), 2
    points, selected, rows, prefixes = greedy(field, N, H, reverse_ties)
    delta = determinant(field, rows)
    require(delta != ZERO, "Selected determinant is zero")
    require(all(x.denominator == 1 for x in delta), "Determinant left the integer order")
    norm = field.norm(delta)
    require(norm.denominator == 1 and norm != 0, "Norm is not a nonzero integer")
    primes = []
    simultaneous = 1
    for p in (5, 7):
        require(sp.isprime(p) and p > H and 2 * 12 % p != 0, "Prime is not admissible")
        require(legendre(3, p) == -1, "Prime is not inert in Q(sqrt(3))")
        j = 1 if legendre(2, p) == 1 else 2
        replaced = []
        exponents = []
        for i, alpha in enumerate(selected):
            k, r = divmod(alpha[0], p)
            exponents.append(k)
            expansion = list(rows[i])
            for m in range(1, k + 1):
                beta = list(alpha)
                beta[0] -= p * m
                beta[j] += m
                require(min(beta) >= 0, "Replacement index is negative")
                require(weight(beta, H) == weight(alpha, H) - m * (p - H),
                        "Incorrect weight-drop identity")
                require(weight(beta, H) < weight(alpha, H), "Weight does not decrease")
                lower = monomial_row(field, points, beta)
                require(all(x == ZERO for x in reduce_row(field, lower, prefixes[i])),
                        "Lower-weight row is not in the earlier retained span")
                coefficient = (-1)**m * comb(k, m)
                expansion = [
                    field.add(x, field.scale(coefficient, y))
                    for x, y in zip(expansion, lower, strict=True)
                ]
            new_row = []
            for theta in points:
                conjugate = field.conjugate(theta, True, j == 2)
                frobenius_difference = field.sub(field.power(theta, p), conjugate)
                require(field.divisible(frobenius_difference, p), "Frobenius congruence failed")
                value = field.mul(
                    field.power(theta, r), field.power(frobenius_difference, k)
                )
                value = field.mul(value, field.power(field.conjugate(theta, True), alpha[1]))
                value = field.mul(
                    value, field.power(field.conjugate(theta, True, True), alpha[2])
                )
                require(field.divisible(value, p**k), "Replacement row lacks its power of p")
                new_row.append(value)
            require(new_row == expansion, "Exact binomial replacement identity failed")
            replaced.append(new_row)
        require(determinant(field, replaced) == delta, "Replacement changed the determinant")
        E = sum(exponents)
        require(field.divisible(delta, p**E), "Determinant divisibility failed")
        divisor = p**(4 * E)
        require(norm.numerator % divisor == 0, "Norm divisibility failed")
        simultaneous *= divisor
        primes.append({"p": p, "conjugate_coordinate": j + 1, "E": E, "norm_divisor": divisor})
    require(norm.numerator % simultaneous == 0, "Simultaneous norm divisibility failed")
    B = max(max(a[1:]) for a in selected)
    M, Q = len(selected), (B + 1)**2
    S1 = sum(a[0] for a in selected)
    S2 = sum(a[1] + a[2] for a in selected)
    require(M**2 <= 2 * Q * S1 + Q * M, "Universal packing inequality failed")
    require(S2 <= 2 * B * M, "Small-coordinate bound failed")
    return {
        "d": 3, "N": N, "H": H, "reverse_lexicographic_ties": reverse_ties,
        "indices": selected, "S1": S1, "S2": S2,
        "delta_in_basis_1_a_b_ab": [str(x) for x in delta],
        "norm": norm.numerator, "primes": primes,
        "simultaneous_norm_divisor": simultaneous,
    }


def symbolic_checks():
    Q, k, r = sp.symbols("Q k r")
    M = k * Q + r
    difference = Q * k * (k - 1) / 2 + k * r - (M**2 / (2 * Q) - M / 2)
    require(sp.cancel(difference - r * (Q - r) / (2 * Q)) == 0,
            "Packing remainder identity is false")
    h = sp.symbols("h0:4")
    v = sp.symbols("v0:4")
    eta = sp.Symbol("eta")
    hd = sum(a * b for a, b in zip(h, v, strict=True))
    hv = sum(a * a for a in v)
    diff = sum((a - eta * b)**2 - a**2 for a, b in zip(h, v, strict=True))
    require(sp.expand(diff + 2 * eta * hd - eta**2 * hv) == 0,
            "Nearest-point displacement sign is wrong")
    H, V = sp.symbols("H V")
    require(sp.expand((32 * H * V) * (32 * V)**2 - 32**3 * H * V**3) == 0,
            "Rectangular degree product is incorrect")
    require(sp.expand(32 * H * V + H * 32 * V + H * 32 * V - 96 * H * V) == 0,
            "Rectangular maximum weight is incorrect")
    n = sp.Symbol("n", nonnegative=True)
    margin = sp.Poly(sp.expand(4096 * (n + 1)**4 - (4 * n + 1)**4), n)
    require(all(coefficient > 0 for coefficient in margin.all_coeffs()),
            "Rectangular budget margin lacks a positive coefficient certificate")
    return {
        "packing_remainder": "r*(Q-r)/(2*Q)",
        "distance_difference": "-2*eta*dot(h,v)+eta^2*dot(v,v)",
        "degree_product": "32768*H*V^3; H*V^3=N^4",
        "maximum_weight": "96*H*V",
        "rectangle_positive_margin_N_equals_n_plus_1": {
            "polynomial": str(margin.as_expr()),
            "coefficients_descending": list(map(int, margin.all_coeffs())),
        },
        "scope": "These are universal polynomial identities, not quantified existence proofs.",
    }


def jacobian_payload():
    field = Biquadratic(3)
    a = (Fraction(0), Fraction(1), Fraction(0), Fraction(0))
    b = (Fraction(0), Fraction(0), Fraction(1), Fraction(0))
    ab = field.mul(a, b)
    matrix = (
        (ONE, a, b, ab),
        (ONE, field.scale(-1, a), b, field.scale(-1, ab)),
        (ONE, field.scale(-1, a), field.scale(-1, b), ab),
    )
    basis = [tuple(Fraction(int(i == j)) for i in range(4)) for j in range(4)]
    entries = []
    for row in matrix:
        blocks = [[field.mul(x, e) for e in basis] for x in row]
        for coordinate in range(4):
            entries.append([
                {"num": str(block[column][coordinate].numerator),
                 "den": str(block[column][coordinate].denominator)}
                for block in blocks for column in range(4)
            ])
    require(sp.Matrix([[sp.Rational(x["num"], x["den"]) for x in row]
                       for row in entries]).rank() == 12, "Rationalized A lacks rank 12")
    return {"matrix": {"domain": "QQ", "entries": entries}}


def jacobian_replay():
    payload = json.loads((BASE / "jacobian_payload.json").read_text())
    response = json.loads((BASE / "jacobian_result.json").read_text())
    require(payload == jacobian_payload(), "Jacobian input is not the rationalized manuscript map")
    require(response.get("error") is None, "Jacobian returned a structured error")
    require(response.get("tool") == "math.run", "Not a Jacobian execution response")
    result = response.get("result", {})
    require(result.get("operation_id") == "matrix.rank.compute", "Jacobian operation mismatch")
    output = result.get("output", {})
    require(output.get("matrix") == payload["matrix"], "Jacobian output lost source binding")
    require(output.get("rank") == 12, "Jacobian rank disagrees with independent rational replay")
    require(output.get("method") == "EXACT_RATIONAL_ROW_REDUCTION", "Non-exact rank method")
    return {
        "operation_id": result["operation_id"],
        "server": response["server"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_exit_code_observed_at_execution": 0,
        "structured_error": None,
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_result.json",
        "rationalized_A_shape": [12, 16],
        "rank": output["rank"],
        "scope": "A single exact specialization, not evidence for uniform interpolation.",
    }


def negative_controls():
    field = Biquadratic(3)
    points = tuple(tuple(map(Fraction, n)) for n in product(range(2), repeat=4))
    delta = ONE
    for j in range(len(points)):
        for i in range(j):
            delta = field.mul(delta, field.sub(points[j], points[i]))
    norm = field.norm(delta)
    E = sum(a // 5 for a in range(16))
    require(delta != ZERO and not field.divisible(delta, 5**E),
            "The non-greedy control did not expose a failed hypothesis")
    valuation, remaining = 0, abs(norm.numerator)
    while remaining % 5 == 0:
        valuation += 1
        remaining //= 5
    require(valuation < 4 * E, "Non-greedy norm control is not a counterexample")
    basis = {}
    for a in range(3):
        require(insert_row(field, monomial_row(field, points, (a, 0, 0)), basis),
                "Non-greedy prefix is unexpectedly dependent")
    residual = reduce_row(field, monomial_row(field, points, (0, 1, 0)), basis)
    require(any(x != ZERO for x in residual), "The prefix did not omit an earlier independent row")
    rational_A = sp.Matrix([[1, -1, 0, 0], [0, 1, -1, 0], [0, 0, 1, -1]])
    c = sp.ones(4, 1)
    require(rational_A.rank() == 3 and rational_A * c == sp.zeros(3, 1),
            "Rational-kernel control has incorrect rank or collision")
    return {
        "nongreedy": {
            "hypothesis_removed": "weighted greedy selection",
            "d": 3, "N": 2, "H": 2, "p": 5,
            "indices": [[a, 0, 0] for a in range(16)],
            "earlier_independent_row_omitted_before_index_3": [0, 1, 0],
            "claimed_E_if_greediness_were_omitted": E,
            "actual_norm_5_valuation": valuation,
            "delta_in_basis_1_a_b_ab": [str(x) for x in delta],
        },
        "rational_kernel": {
            "hypothesis_removed": "rational independence of the kernel coordinates",
            "A": [list(map(int, row)) for row in rational_A.tolist()],
            "c": [1, 1, 1, 1],
            "colliding_box_points": [[0, 0, 0, 0], [1, 1, 1, 1]],
        },
        "scope": "Neither control satisfies all manuscript hypotheses; neither refutes the paper.",
    }


def lean_replay():
    response = json.loads((BASE / "lean_verification_result.json").read_text())
    source = (BASE / "Main.lean").read_bytes()
    fidelity = (BASE / "statement_fidelity.md").read_text()
    require(response.get("status") == "success" and response.get("exit_code") == 0,
            "The formal core has no successful compiler result")
    require(response.get("proof_holes") == [] and response.get("audit_exit_code") == 0,
            "Lean proof holes or axiom-audit failure")
    require("version 4.31.0" in response["tools"]["lean"]["version"], "Wrong Lean version")
    require(hashlib.sha256(source).hexdigest() == response["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == response["statement_fidelity_sha256"],
            "Statement fidelity changed after compilation")
    parts, component_hashes = [], {}
    for i, name in enumerate(COMPONENTS):
        data = (BASE / name).read_bytes()
        lines = data.splitlines(keepends=True)
        require(lines and lines[0] == b"import Mathlib\n", f"Unexpected component header: {name}")
        parts.extend(lines if i == 0 else lines[1:])
        component_hashes[name] = hashlib.sha256(data).hexdigest()
    require(b"".join(parts) == source, "Main.lean is not the exact implementation aggregate")
    record = response["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "No supporting mechanical ledger record")
    require(record["subject"]["subject_id"] == "C_LS_CORE", "Wrong formal claim")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C_LS_CORE"),
                key=lambda c: c["version"])
    require(claim["formal_statement"] == source.decode(), "Claim carries a different formal source")
    require(claim["content_hash"] == record["subject"]["content_hash"],
            "Compiler evidence belongs to a superseded claim")
    archive_path = ROOT / record["artifact"]
    require(archive_path.is_file(), "Archived compiler certificate is missing")
    archive = json.loads(archive_path.read_text())
    require(archive["evidence_id"] == record["evidence_id"], "Archived evidence ID differs")
    require(archive["lean_source"]["text"].encode() == source, "Archived formal source differs")
    archived = archive["lean_check"]
    for key in ("source_sha256", "statement_fidelity_sha256", "exit_code",
                "audit_exit_code", "proof_holes"):
        require(archived.get(key) == response[key], f"Archived compiler result differs: {key}")
    return {
        "claim": "C_LS_CORE",
        "source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "compiler_result": "lean_verification_result.json",
        "archived_certificate": record["artifact"],
        "lean_version": "4.31.0",
        "exit_code": response["exit_code"],
        "proof_holes": response["proof_holes"],
        "axiom_audit_exit_code": response["audit_exit_code"],
        "source_sha256": response["source_sha256"],
        "statement_fidelity_sha256": response["statement_fidelity_sha256"],
        "implementation_sha256": component_hashes,
        "interpolation_theorem": "LSChain.interpolation_polynomial",
        "construction_theorem": "LSChain.constructed_core",
        "combined_theorem": "LSChain.full_chain",
        "instantiated_core": "UniformDeterminant.uniform_core",
        "scope": (
            "Universal projected-box interpolation and the actual bounded greedy construction, "
            "derived triangular replacements, literal concentration constants, Legendre-derived "
            "Frobenius, and simultaneous integer-norm divisibility from explicit rank-four order "
            "data. Not the analytic zero-free theorem."
        ),
    }


def source_locations():
    lines = SOURCE.read_text().splitlines()
    result = {}
    for label in ("lem:interpolation", "cor:rectangle", "lem:exponents", "lem:divisibility"):
        start = next(i for i, line in enumerate(lines) if rf"\label{{{label}}}" in line)
        end = next(i for i in range(start, len(lines)) if r"\end{proof}" in lines[i])
        result[label] = {"start_line": start + 1, "end_line": end + 1}
    for label, first, last in (
        ("biquadratic_order_data", "Temporarily exclude", r"generate $\Gal(K/\Q)$."),
        ("weighted_greedy", r"For $\alpha\in\N^3$", r"\cite[Section~6]{Laurent}."),
        ("frobenius", "Call a prime $p$ admissible if", "This is the Frobenius relation in the ring"),
        ("simultaneous_norm", r"Taking norms in \eqref{eq:divisibility}",
         "distinct admissible primes may be combined."),
    ):
        start = next(i for i, line in enumerate(lines) if first in line)
        end = next(i for i in range(start, len(lines)) if last in lines[i])
        result[label] = {"start_line": start + 1, "end_line": end + 1}
    for literal in (
        r"four coordinates of $c$ are linearly independent over $\Q$.",
        r"its weight is $w(\alpha)-m(p-H)$.",
        r"from the replacement entries themselves, so no integrality of $L$",
    ):
        require(literal in "\n".join(lines), f"Source binding missing: {literal}")
    return result


def certificate():
    lean = lean_replay()
    return {
        "result_class": "complete_solution",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": "required; not performed by this script",
        "source": str(SOURCE.relative_to(ROOT)),
        "manuscript_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        "source_locations": source_locations(),
        "quantifiers": {
            "universal_interpolation": (
                "Every N>=1, every surjective complex-linear A:C^4->C^3 with kernel C*c "
                "and Q-independent entries of c, every literal separate-degree budget, "
                "and every prescribed complex function on the integer box."
            ),
            "whole_construction": (
                "Every 1<=H<=N satisfying H^(2/3)*N^(4/3)>=2*97^2, every weight-compatible "
                "tie order, every rank-four integral domain R embedded in C with a^2=d, "
                "b^2=2 and Q-independent 1,a,b,ab, and every finite set of odd primes "
                "p>H with (d/p)=-1. The determinant, greedy basis, and replacements are derived."
            ),
            "explicit_structure_inputs": [
                "A Z-basis of the order indexed by Fin 4 for the degree-four integer norm.",
                "An injective ring embedding of the order into C and Q-independence of 1,a,b,ab.",
            ],
            "finite_replays": "Only N=2, d=3, H=1,2, both lexicographic tie directions, p=5,7.",
            "not_formalized": [
                "Primitive-character and squarefree-discriminant reduction to rank-four order data.",
                "The arbitrary-dimension unequal-input-box prose extension.",
                "The analytic real-zero gap, novelty, publishability, and independent review.",
            ],
        },
        "symbolic_identities": symbolic_checks(),
        "finite_replays": [replay_grid(H, reverse) for H in (1, 2) for reverse in (False, True)],
        "negative_controls": negative_controls(),
        "jacobian": jacobian_replay(),
        "lean": lean,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    if args.write_jacobian_payload:
        path = BASE / "jacobian_payload.json"
        path.write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        print(f"Wrote {path.relative_to(ROOT)}")
    result = certificate()
    path = BASE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(json.loads(json.dumps(result)) == expected, "Exact certificate differs from replay")
    print("Exact replay passed; the source-bound Lean 4.31.0 certificate covers the universal algebraic chain.")


if __name__ == "__main__":
    main()
