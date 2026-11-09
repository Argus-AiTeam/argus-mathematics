#!/usr/bin/env python3
"""Replay exact identities; the universal proof is report.md, not enumeration."""

import argparse
import hashlib
import json
from fractions import Fraction
from math import comb
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def character(index, point):
    return -1 if (index & point).bit_count() % 2 else 1


def binary_rank(index, m):
    rows = [(index >> (m * i)) & ((1 << m) - 1) for i in range(m)]
    rank = 0
    for j in range(m):
        pivot = next((i for i in range(rank, m) if rows[i] & (1 << j)), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for i in range(m):
            if i != rank and rows[i] & (1 << j):
                rows[i] ^= rows[rank]
        rank += 1
    return rank


def parities(index, m):
    row = sum(
        ((((index >> (m * i)) & ((1 << m) - 1)).bit_count() % 2) << i)
        for i in range(m)
    )
    col = sum(
        ((sum((index >> (m * i + j)) & 1 for i in range(m)) % 2) << j)
        for j in range(m)
    )
    return row, col


def row_mask(vector, m):
    return sum(((1 << m) - 1) << (m * i) for i in range(m) if vector & (1 << i))


def col_mask(vector, m):
    return sum(vector << (m * i) for i in range(m))


def rectangle(p, h, m):
    return sum(h << (m * i) for i in range(m) if p & (1 << i))


def verify_binary_algebra():
    cases = []
    for m in range(1, 4):
        size = 1 << (m * m)
        counts = [0] * (m + 1)
        odd_rectangles = 0
        parity_tests = 0
        for index in range(size):
            rank = binary_rank(index, m)
            counts[rank] += 1
            rp, cp = parities(index, m)
            factors = [
                (p, h)
                for p in range(1, 1 << m)
                for h in range(1, 1 << m)
                if rectangle(p, h, m) == index
            ]
            require(len(factors) == (1 if rank == 1 else 0), "Rectangle classification")
            if factors and index.bit_count() % 2:
                p, h = factors[0]
                require(p.bit_count() % 2 == h.bit_count() % 2 == 1, "Odd rectangle")
                require((rp, cp) == (p, h), "Rectangle parities")
                odd_rectangles += 1
            for vector in range(1 << m):
                require(
                    character(index, row_mask(vector, m)) == character(rp, vector),
                    "Row-action character identity",
                )
                require(
                    character(index, col_mask(vector, m)) == character(cp, vector),
                    "Column-action character identity",
                )
                parity_tests += 2
            for i in range(m):
                row_eigenvalue = sum(
                    character(1 << i, vector)
                    * character(index, row_mask(vector, m))
                    for vector in range(1 << m)
                )
                col_eigenvalue = sum(
                    character(1 << i, vector)
                    * character(index, col_mask(vector, m))
                    for vector in range(1 << m)
                )
                require(row_eigenvalue == ((1 << m) if rp == 1 << i else 0), "Row selector")
                require(col_eigenvalue == ((1 << m) if cp == 1 << i else 0), "Column selector")
                if index & ~row_mask(1 << i, m) == 0:
                    require(rank <= 1, "Single-row rank bound")
                if index & ~col_mask(1 << i, m) == 0:
                    require(rank <= 1, "Single-column rank bound")
        require(odd_rectangles == 1 << (2 * m - 2), "Odd rectangle count")
        cases.append(
            {
                "m": m,
                "matrices": size,
                "rank_counts": counts,
                "odd_rectangles": odd_rectangles,
                "row_column_character_tests": parity_tests,
            }
        )
    return cases


def sign_probability(bits, n, mean):
    return ((1 - mean) / 2) ** bits.bit_count() * (
        (1 + mean) / 2
    ) ** (n - bits.bit_count())


def verify_damping():
    m = 2
    s, u, noise = Fraction(1, 3), Fraction(-2, 5), Fraction(1, 2)
    measure = [Fraction(0) for _ in range(1 << (m * m))]
    for d in range(1 << m):
        for e in range(1 << m):
            for z in range(1 << (m * m)):
                point = row_mask(d, m) ^ col_mask(e, m) ^ z
                measure[point] += (
                    sign_probability(d, m, s)
                    * sign_probability(e, m, u)
                    * sign_probability(z, m * m, noise)
                )
    require(sum(measure) == 1, "Noise-model normalization")
    for index in range(1 << (m * m)):
        rp, cp = parities(index, m)
        actual = sum(
            probability * character(index, point)
            for point, probability in enumerate(measure)
        )
        predicted = s ** rp.bit_count() * u ** cp.bit_count() * noise ** index.bit_count()
        require(actual == predicted, "Exact damped character identity")
    mass_checks = 0
    for n in range(1, 65):
        actual = sum(Fraction(comb(n, k), 2**k) for k in range(1, n + 1, 2))
        require(actual == (Fraction(3, 2) ** n - Fraction(1, 2) ** n) / 2, "Odd mass")
        mass_checks += 1
    return {
        "m": m,
        "means": [str(s), str(u), str(noise)],
        "characters_checked": 1 << (m * m),
        "odd_mass_dimensions_checked": mass_checks,
        "universal_odd_mass_proof": "Main.lean: odd_mass_closed, with the cube recurrence in report.md",
    }


def monomial_chebyshev(k, x):
    coefficients = {}
    for j in range(k + 1):
        if (k - j) % 2:
            continue
        coefficients[j] = sp.Rational(comb(k, (k - j) // 2), 2**k) * (1 if j == 0 else 2)
    expansion = sum(c * sp.chebyshevt(j, x) for j, c in coefficients.items())
    require(sp.expand(expansion - x**k) == 0, "Exact Chebyshev expansion")
    return coefficients


def verify_chebyshev():
    x, y = sp.symbols("x y")
    expansions = {k: monomial_chebyshev(k, x) for k in range(13)}
    for j in range(33):
        derivative = sp.diff(sp.chebyshevt(j, x), x).subs(x, 0)
        require(abs(derivative) <= j, "Chebyshev derivative at zero")
    basis_tests = 0
    d = 4
    for k in range(13):
        low = sum(c * sp.chebyshevt(j, x) for j, c in expansions[k].items() if j <= d)
        require(sp.degree(low, x) <= d, "Low Chebyshev degree")
        for l in range(13):
            if min(k, l) > d:
                continue
            remainder = sp.expand((x**k - low) * y**l)
            require(remainder == 0 or sp.degree(remainder, y) <= d, "Cross-degree separation")
            basis_tests += 1
    return {
        "monomial_degrees": [0, 12],
        "derivative_degrees": [0, 32],
        "cross_degree_cutoff": d,
        "cross_basis_tests": basis_tests,
        "scope": "Finite identity checks; the general norm estimates are proved by cosine orthogonality in report.md.",
    }


def nonnegative_coefficients(expression, variables, label):
    poly = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
    require(all(coefficient >= 0 for coefficient in poly.coeffs()), label)
    return str(poly.as_expr())


def verify_universal_algebra():
    d, a, b = sp.symbols("d A B")
    D, L = d * (d + 1), d * (d + 1) ** 2
    x, y, z = sp.symbols("x y z", nonnegative=True)
    residual = a * b / 2 - 4 * D * (a + b) - 5 * D * L * (640 * d + 512)
    decomposition = (40 * L - 4 * D) * (a + b - 160 * L) + (a - 80 * L) * (b - 80 * L) / 2
    require(sp.expand(residual - decomposition) == 0, "Universal final-margin identity")
    coefficient = nonnegative_coefficients(
        (40 * L - 4 * D).subs(d, 4 + z), (z,), "Nonnegative margin coefficient"
    )
    margin = sp.expand(residual.subs({a: 80 * L + x, b: 80 * L + y}).subs(d, 4 + z))
    margin_polynomial = nonnegative_coefficients(margin, (x, y, z), "Universal nonnegative residual")
    tail_log = sp.expand(
        ((d + 1 + x) * (d + 1 + y) - (2 * d + 2 + x + y) * d / 2).subs(d, 4 + z)
    )
    tail_geometric = sp.expand((5 + x) * (5 + y) / 2 - (10 + x + y))
    return {
        "identity": "AB/2-4D(A+B)-5DL(640d+512)=(40L-4D)(A+B-160L)+(A-80L)(B-80L)/2",
        "margin_coefficient_at_d_4_plus_z": coefficient,
        "residual_at_A_80L_plus_x_B_80L_plus_y_d_4_plus_z": margin_polynomial,
        "tail_log_residual": nonnegative_coefficients(tail_log, (x, y, z), "Tail logarithmic exponent"),
        "tail_geometric_residual": nonnegative_coefficients(tail_geometric, (x, y), "Tail geometric exponent"),
        "epsilon_times_mass_minimum": 3064,
        "quantifiers": "All real d>=4, A>=80d(d+1)^2, B>=80d(d+1)^2; no finite extrapolation.",
    }


def verify_jacobian():
    payload = json.loads((ROOT / "jacobian/walsh_payload.json").read_text())
    result = json.loads((ROOT / "jacobian/walsh_result.json").read_text())
    require(result["request"]["payload"] == payload, "Adapter payload provenance")
    require(result["result"]["operation_id"] == "boolean.fourier.walsh_transform.compute", "Operation id")
    output = result["result"]["output"]
    predicted = [
        sum((1 - 2 * f) * character(p, s) for s, f in enumerate(payload["truth_table"]))
        for p in range(16)
    ]
    require(output["spectrum"] == list(map(str, predicted)), "Independent adapter replay")
    require(predicted[11] == 16 and sum(abs(v) for v in predicted) == 16, "Character normalization")
    require(binary_rank(11, 2) == 2, "Binary rank of bounded normalization example")
    return {
        "operation_id": result["result"]["operation_id"],
        "protocol_version": result["protocol_version"],
        "server_version": result["server"]["version"],
        "adapter_status": "success",
        "error": None,
        "timeout": False,
        "normalized_nonzero_coefficient": {"index": 11, "value": "1", "binary_rank": 2},
        "scope": "One Boolean character, not the universal real-valued rank-separation theorem.",
        "contract_mismatch": "matrix.rank.compute is over QQ; Boolean Walsh truth tables are bounded and do not supply a universal real-valued Fourier/rank postcondition.",
    }


def verify_formal_core():
    check = json.loads((ROOT / "lean_evidence/lean_check.json").read_text())
    require(check["status"] == "success" and check["exit_code"] == 0, "Real Lean compiler result")
    require(check["audit_exit_code"] == 0 and check["proof_holes"] == [], "Lean proof-hole audit")
    require("version 4.31.0," in check["tools"]["lean"]["version"], "Required Lean version")
    for name, key in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        content = (ROOT / name).read_bytes()
        require(hashlib.sha256(content).hexdigest() == check[key], "Fresh compiler/reading binding")
        require(content == (ROOT / "lean_evidence" / name).read_bytes(), "Archived compiler input")
    state = json.loads((ROOT.parent / "MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "L_COEFF_FORMAL_CORE"),
        key=lambda c: c["version"],
    )
    records = [
        e
        for e in state["evidence"]
        if e["subject"]["subject_id"] == "L_COEFF_FORMAL_CORE"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical"
        and e["verdict"] == "supports"
    ]
    require(records, "Mechanical evidence attached to the current formal-core claim")
    require(
        all((ROOT.parent.parent / e["artifact"]).is_file() for e in records),
        "Archived claim certificates",
    )
    return {
        "claim": "L_COEFF_FORMAL_CORE",
        "lean_version": "4.31.0",
        "compiler_exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "source_and_statement_fidelity_match_compiler_inputs": True,
        "mechanical_evidence_bound_to_current_claim": True,
        "scope": "The finite core only. This replay checks recorded compiler evidence; it does not rerun Lean.",
    }


def certificate():
    return {
        "claim": "C_COEFF_EXPLICIT",
        "result_class": "new_theorem",
        "statement": "Under the literal coefficient-lemma hypotheses, epsilon*W >= (AB/2-4D(A+B))/(5DL)-8 >=640d+504; in particular epsilon >=(2/3)^(m^2)>2^(-m^2).",
        "definitions": {
            "D": "d(d+1)",
            "L": "d(d+1)^2",
            "W": "((3/2)^(m^2)-(1/2)^(m^2))/2",
            "epsilon": "max over binary rank at least two of abs(Psi_hat(P))",
        },
        "proof": "report.md",
        "binary_algebra_finite_replay": verify_binary_algebra(),
        "damping_finite_replay": verify_damping(),
        "chebyshev_finite_replay": verify_chebyshev(),
        "universal_polynomial_certificate": verify_universal_algebra(),
        "jacobian": verify_jacobian(),
        "formal_core": verify_formal_core(),
        "trust_boundary": {
            "finite_replay_is_universal_proof": False,
            "full_scalar_theorem_is_formalized": False,
            "external_mathematical_assumptions_of_scalar_proof": [],
            "full_banach_space_theorem_verified": False,
            "independent_review": "not established by this script; requires the Host-invoked Reviewer",
            "novelty_and_publishability": "not established by computational replay",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Generate the initial deterministic certificate.")
    args = parser.parse_args()
    actual = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == actual, "Persisted certificate differs from exact replay")
    print("Exact certificate replay passed: finite Fourier/noise checks and universal polynomial identities.")


if __name__ == "__main__":
    main()
