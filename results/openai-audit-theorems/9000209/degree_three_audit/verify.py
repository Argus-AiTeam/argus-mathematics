#!/usr/bin/env python3
"""Replay the exact algebra in report.md; this is not a K-theory proof checker."""

import argparse
import itertools
import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parent
ZERO = (0,)
ONE = (1,)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def trim(a):
    a = list(a)
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return tuple(a) if a else ZERO


def add(a, b):
    c = [0] * max(len(a), len(b))
    for i, x in enumerate(a):
        c[i] += x
    for i, x in enumerate(b):
        c[i] += x
    return trim(c)


def neg(a):
    return tuple(-x for x in a)


def mul(a, b):
    c = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            c[i + j] += x * y
    return trim(c)


def power(a, n):
    require(n >= 0, "Polynomial exponent must be nonnegative")
    out = ONE
    while n:
        if n & 1:
            out = mul(out, a)
        a = mul(a, a)
        n //= 2
    return out


def remainder(a, modulus, p):
    a = list(trim([x % p for x in a]))
    modulus = trim([x % p for x in modulus])
    require(modulus != ZERO, "Division by the zero polynomial")
    inverse = pow(modulus[-1], -1, p)
    while len(a) >= len(modulus) and trim(a) != ZERO:
        factor = a[-1] * inverse % p
        offset = len(a) - len(modulus)
        for j, x in enumerate(modulus):
            a[offset + j] = (a[offset + j] - factor * x) % p
        a = list(trim(a))
    return trim(a)


def power_mod(a, n, modulus, p):
    out = ONE
    a = remainder(a, modulus, p)
    while n:
        if n & 1:
            out = remainder(mul(out, a), modulus, p)
        a = remainder(mul(a, a), modulus, p)
        n //= 2
    return out


def gcd_mod(a, b, p):
    while b != ZERO:
        a, b = b, remainder(a, b, p)
    require(a != ZERO, "Both gcd inputs are zero")
    inverse = pow(a[-1], -1, p)
    return trim([x * inverse % p for x in a])


def identity(n):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def matrix_mul(a, b):
    n = len(a)
    out = [[ZERO for _ in range(n)] for _ in range(n)]
    for i in range(n):
        for j in range(n):
            for k in range(n):
                out[i][j] = add(out[i][j], mul(a[i][k], b[k][j]))
    return out


def matrix_power(a, n):
    out = identity(len(a))
    while n:
        if n & 1:
            out = matrix_mul(out, a)
        a = matrix_mul(a, a)
        n //= 2
    return out


def determinant(a):
    # The only determinant used is 5 by 5 over Z[zeta].
    n = len(a)
    require(n == 5, "Determinant replay is bounded to the degree-five divisor")
    out = ZERO
    for perm in itertools.permutations(range(n)):
        inversions = sum(perm[i] > perm[j] for i in range(n) for j in range(i + 1, n))
        term = (-1,) if inversions % 2 else ONE
        for i, j in enumerate(perm):
            term = mul(term, a[i][j])
        out = add(out, term)
    return out


def cyclotomic_at_one_minus_t(p):
    out = ZERO
    for k in range(p):
        out = add(out, power((1, -1), k))
    return out


def eisenstein_at(a, p):
    return (
        a[-1] % p != 0
        and all(x % p == 0 for x in a[:-1])
        and a[0] % (p * p) != 0
    )


def valuation(n, p):
    require(n != 0, "Valuation of zero is not a finite integer")
    n = abs(n)
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def sparse_z_polynomial(value):
    require(value["kind"] == "POLYNOMIAL", "Jacobian returned no polynomial")
    poly = value["value"]
    require(poly["domain"] == "QQ" and poly["variables"] == ["z"], "Wrong resultant ring")
    result = ZERO
    for term in poly["polynomial"]["terms"]:
        c = term["coefficient"]
        require(c["den"] == "1", "Unexpected nonintegral resultant coefficient")
        require(len(term["exponents"]) == 1, "Wrong monomial arity")
        degree = term["exponents"][0]
        require(degree >= 0, "Negative polynomial degree")
        result = add(result, (0,) * degree + (int(c["num"]),))
    return result


def compute():
    checks = {}
    phi = cyclotomic_at_one_minus_t(5)
    require(phi == (5, -10, 10, -5, 1), "Incorrect Phi_5(1-T)")
    require(eisenstein_at(phi, 5), "Cyclotomic polynomial is not Eisenstein at five")
    unit = (-1, 2, -2, 1)
    require(add((0, 0, 0, 0, 1), neg(mul((5,), unit))) == phi, "Wrong cyclotomic unit")
    checks["cyclotomic"] = {
        "Phi5_at_1_minus_T": list(phi),
        "coefficient_order": "ascending",
        "eisenstein_prime": 5,
        "identity": "pi^4=5*h(pi) in V",
        "h": list(unit),
        "h_mod_pi": -1,
    }

    affine = {(k, 0, 0): math.comb(5, k) * (-1) ** (5 - k) for k in range(1, 6)}
    affine.update({(1, 4, 0): -1, (0, 5, 0): 1, (0, 0, 1): -1})
    weighted_terms = [
        {"powers_x_y_pi": list(e), "coefficient": c, "ambient_order": sum(e) + 4 * valuation(c, 5)}
        for e, c in sorted(affine.items())
    ]
    require([a["powers_x_y_pi"] for a in weighted_terms if a["ambient_order"] == 1] == [[0, 0, 1]], "F has the wrong linear term")
    require(all(a["ambient_order"] >= 5 for a in weighted_terms if a["powers_x_y_pi"] != [0, 0, 1]), "Unexpected low-order term")
    special = {}
    for k in range(6):
        c = math.comb(5, k) * (-1) ** (5 - k)
        e = (k, 0, 5 - k)
        special[e] = c
    special[(0, 0, 5)] += 1
    special[(1, 4, 0)] = -1
    special[(0, 5, 0)] = 1
    special = {e: c % 5 for e, c in special.items() if c % 5}
    require(special == {(5, 0, 0): 1, (1, 4, 0): 4, (0, 5, 0): 1}, "Wrong special fiber")
    checks["model_expansions"] = {
        "affine_terms": weighted_terms,
        "special_fiber": [{"powers_X_Y_Z": list(e), "coefficient_mod_5": c} for e, c in sorted(special.items())],
        "linear_term": "-pi",
        "leading_total_degree_in_x_y_after_pi_in_m_squared": 5,
        "point_Y_equals_Z_equals_zero": "P(1,0,0)=1, so it is absent",
    }

    f = (1, -1, 0, 0, 0, 1)
    s = (0, 1)
    orbit = []
    for r in range(6):
        actual = power_mod(s, 5**r, f, 5)
        expected = ((-r) % 5, 1)
        require(actual == expected, f"Frobenius identity failed at r={r}")
        orbit.append(list(actual))
    require(len({tuple(x) for x in orbit[:5]}) == 5, "Frobenius orbit is too short")
    require(orbit[5] == orbit[0], "Frobenius orbit does not close")
    root_counts = []
    for r in range(1, 11):
        diff = trim([x % 5 for x in add(power_mod(s, 5**r, f, 5), neg(s))])
        gcd = gcd_mod(f, diff, 5)
        degree = len(gcd) - 1
        require(degree == (5 if r % 5 == 0 else 0), "Wrong finite-field root count")
        root_counts.append({"residue_degree": r, "root_count": degree})
    checks["artin_schreier"] = {
        "polynomial": list(f),
        "Frobenius_orbit": orbit,
        "derivative_mod_5": [4],
        "finite_root_count_cases": root_counts,
        "universal_argument": "For a root alpha, alpha^(5^r)=alpha-r; hence it is fixed iff 5 divides r.",
    }
    require({pow(2, k, 5) for k in range(4)} == {1, 2, 3, 4}, "Two does not generate F_5 units")
    require(pow(2, 3, 5) == 3 and (3 + 3) % 5 == 1, "Wrong finite-field Steinberg pair")
    require(math.gcd(4, 3 * 3) == 1, "Symbol relations do not force the generator to vanish")
    checks["finite_field_K2_symbol_arithmetic"] = {
        "unit_generator": 2,
        "unit_order": 4,
        "Steinberg_pair": [3, 3],
        "three_as_generator_power": 3,
        "symbol_generator_annihilators": [4, 9],
        "Bezout_identity": "9-2*4=1",
        "external_input": "Matsumoto's presentation; the program checks only the field and exponent arithmetic.",
    }

    z = (0, 1)
    coeffs = [(-1, 1), (5,), (-10,), (10,), (-5,)]
    companion = [[ZERO for _ in range(5)] for _ in range(5)]
    for i in range(1, 5):
        companion[i][i - 1] = ONE
    for i, c in enumerate(coeffs):
        companion[i][4] = neg(c)
    eta = [[add(identity(5)[i][j], neg(companion[i][j])) for j in range(5)] for i in range(5)]
    norm_t = determinant(companion)
    norm_eta = determinant(eta)
    require(norm_t == (1, -1), "Norm sign error: N(t) must be 1-zeta")
    require(norm_eta == z, "N(1-t) must be zeta")
    require(matrix_power(eta, 5) == [[z if i == j else ZERO for j in range(5)] for i in range(5)], "(1-t)^5 is not zeta")
    require(all(add(eta[i][j], companion[i][j]) == identity(5)[i][j] for i in range(5) for j in range(5)), "Steinberg arguments do not add to one")
    relative_valuations = [1] + [4 * valuation(c[0], 5) for c in coeffs[1:]]
    require(relative_valuations == [1, 4, 4, 4, 4], "Relative Eisenstein valuations are incorrect")
    absolute = ZERO
    for k in range(5):
        absolute = add(absolute, power((1, -1), 5 * k))
    require(len(absolute) == 21 and eisenstein_at(absolute, 5), "Phi_25(1-t) is not Eisenstein of degree twenty")
    checks["divisor_and_norm"] = {
        "f_coefficients_in_Z_z_ascending": [list(c) for c in coeffs] + [[1]],
        "coefficient_pi_valuations_except_leading": relative_valuations,
        "multiplication_by_t_matrix_over_Z_z": [[list(x) for x in row] for row in companion],
        "norm_t": list(norm_t),
        "norm_eta": list(norm_eta),
        "eta_power_5": "zeta*I",
        "eta_plus_t": "I",
        "absolute_polynomial": list(absolute),
        "absolute_Eisenstein_degree": 20,
    }

    diagonals = {}
    for n in (1, 2, 3):
        pairs = [(degree, (n + degree) // 2) for degree in range(3) if (n + degree) % 2 == 0 and degree <= (n + degree) // 2]
        diagonals[str(n)] = [list(pair) for pair in pairs]
    require(diagonals == {"1": [[1, 1]], "2": [[0, 1], [2, 2]], "3": [[1, 2]]}, "Wrong spectral diagonals")
    require(2 * 2 - 1 > 2, "Differentials could stay inside the nonzero strip")
    checks["spectral_index_arithmetic"] = {
        "coordinate_order": ["s", "j"],
        "assumed_nonzero_strip": "0<=s<=min(j,2); j>=0",
        "diagonals": diagonals,
        "d_r": "(s,j)->(s+2*r-1,j+r-1), r>=2",
        "minimum_s_displacement": 3,
        "strip_s_width": 2,
        "discarded_product_filtration": "F^2 K_2 * F^1 K_1 is contained in F^3 K_3=0",
        "not_computed": "Existence, naturality, convergence and product identification of the spectral sequence are external theorems.",
    }

    require(1 * 1 % 5 == 1 and 5 * 1 % 5 == 0, "Residue-degree negative control failed")
    require(all((5 * a * v) % 5 == 0 for a in range(5) for v in range(5)), "Omitted-point detector is nonzero")
    require(norm_t != neg(norm_t), "Norm-sign negative control failed")
    checks["detector_arithmetic"] = {
        "distinguished_e": 5,
        "distinguished_f": 1,
        "v_D_t": 1,
        "v_L_norm_t_mod_5": 1,
        "incorrect_total_degree_substitution_mod_5": 0,
        "omitted_residue_degree_mod_5": 0,
        "omitted_detector_for_every_integer_valuation": 0,
        "reason": "v_L(N_E/L u)=f(E/L)*v_E(u); any multiple of five remains zero modulo five.",
        "symbol_boundary": "Both suspension signs multiply the zero Steinberg symbol by five.",
    }

    contract = json.loads((ROOT / "jacobian.resultant.contract.json").read_text())
    payload = json.loads((ROOT / "jacobian.resultant.payload.json").read_text())
    envelope = json.loads((ROOT / "jacobian.resultant.output.json").read_text())
    operation = "polynomial.multivariate.resultant.compute"
    expected_terms = []
    for t_degree, coefficient in enumerate(coeffs + [ONE]):
        for z_degree, value in enumerate(coefficient):
            if value:
                expected_terms.append({
                    "coefficient": {"num": str(value), "den": "1"},
                    "exponents": [t_degree, z_degree],
                })
    expected_terms.sort(key=lambda term: term["exponents"], reverse=True)
    expected_payload = {
        "left": {"domain": "QQ", "variables": ["t", "z"], "polynomial": {"terms": expected_terms}},
        "right": {
            "domain": "QQ",
            "variables": ["t", "z"],
            "polynomial": {"terms": [{"coefficient": {"num": "1", "den": "1"}, "exponents": [1, 0]}]},
        },
        "elimination_variable": "t",
    }
    require(payload == expected_payload, "The Jacobian payload is not the manuscript divisor and t")
    require(contract["result"]["operation"]["operation_id"] == operation, "Wrong inspected operation")
    require(envelope["request"] == {"operation_id": operation, "payload": payload}, "Typed result does not match the retained payload")
    require("error" not in envelope and "error" not in envelope["result"], "Jacobian error is not evidence")
    require(envelope["result"]["operation_id"] == operation, "Wrong executed operation")
    output = envelope["result"]["output"]
    require(output["convention"] == "SYLVESTER_DETERMINANT", "Wrong resultant convention")
    require(output["elimination_variable"] == "t", "Wrong elimination variable")
    require(output["left"] == payload["left"] and output["right"] == payload["right"], "Wrong typed input echo")
    require(sparse_z_polynomial(output["resultant"]) == norm_t, "Jacobian disagrees with the independent determinant")
    require(envelope["server"]["version"] == contract["server"]["version"], "Server changed between inspect and run")
    require(envelope["protocol_version"] == contract["protocol_version"], "Protocol changed between inspect and run")

    return {
        "schema_version": 1,
        "claim_id": "D3_MAIN",
        "certificate_kind": "exact_algebra_and_spectral_index_arithmetic",
        "mathematical_scope": "September 26 quintic, residue characteristic five",
        "executable_checks": checks,
        "jacobian": {
            "operation_id": operation,
            "server_version": envelope["server"]["version"],
            "protocol_version": envelope["protocol_version"],
            "transport": envelope["transport"],
            "status": "complete_typed_result",
            "structured_error": None,
            "timeout": False,
            "recorded_adapter_exit_code": 0,
            "payload_file": "jacobian.resultant.payload.json",
            "output_file": "jacobian.resultant.output.json",
            "independent_replay": "Leibniz determinant over Z[z], using only Python integers",
        },
        "external_not_machine_proved": [
            "Matsumoto/Quillen identification of the field K_2 product with Steinberg symbols",
            "Regular resolution, coherent localization and devissage",
            "Motivic spectral sequence, comparison, and actual mixed product",
            "Local-field cohomological dimension two",
            "Tensor projection formula and K_1 transfer",
            "Coherent continuity and proper functorial pushforward",
        ],
        "proof_artifact": "report.md",
        "degree_three_conclusion": "Prose derivation from the recorded standard inputs; independent Reviewer pending.",
        "degree_five_conclusion": "Unresolved; source inventory only.",
        "formal_verification": False,
        "independent_reviewer_approval": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true", help="Generate the deterministic certificate before replay")
    args = parser.parse_args()
    computed = compute()
    certificate = ROOT / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    expected = json.loads(certificate.read_text())
    require(expected == computed, "Stored certificate differs from exact recomputation")
    print("PASS: exact model, Frobenius, Eisenstein, norm, spectral-index and detector checks.")
    print("K-theory implications require report.md and its sources; this is not a formal K-theory proof.")


if __name__ == "__main__":
    main()
