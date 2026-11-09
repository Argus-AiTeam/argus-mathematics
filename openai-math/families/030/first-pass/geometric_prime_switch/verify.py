#!/usr/bin/env python3
"""Replay exact certificates for the geometrically derived slit-cover model.

The universal geometric proof is report.md; the universally quantified
algebra is also certified in Main.lean. Finite replays below are not used
as an induction argument or as a novelty claim.
"""

import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
DEGREES = (3, 5, 9, 15)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(rows, columns):
    return [[0] * columns for _ in range(rows)]


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def multiply(a, b):
    bt = transpose(b)
    return [[sum(x * y for x, y in zip(row, col)) for col in bt] for row in a]


def matvec(a, x):
    return [sum(c * y for c, y in zip(row, x)) for row in a]


def matrix_rank(matrix, prime=None):
    a = [[Fraction(x) if prime is None else x % prime for x in row] for row in matrix]
    row = 0
    for column in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inverse = 1 / a[row][column] if prime is None else pow(a[row][column], -1, prime)
        a[row] = [x * inverse for x in a[row]]
        if prime is not None:
            a[row] = [x % prime for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][column]:
                factor = a[i][column]
                a[i] = [x - factor * y for x, y in zip(a[i], a[row])]
                if prime is not None:
                    a[i] = [x % prime for x in a[i]]
        row += 1
        if row == len(a):
            break
    return row


def determinant(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    result = Fraction(1)
    for j in range(len(a)):
        pivot = next((i for i in range(j, len(a)) if a[i][j]), None)
        if pivot is None:
            return 0
        if pivot != j:
            a[j], a[pivot] = a[pivot], a[j]
            result = -result
        result *= a[j][j]
        for i in range(j + 1, len(a)):
            factor = a[i][j] / a[j][j]
            a[i] = [x - factor * y for x, y in zip(a[i], a[j])]
    require(result.denominator == 1, "an integral determinant became nonintegral")
    return result.numerator


def face_words(m):
    return [
        [
            ("a", i, 1),
            ("b", i, 1),
            ("a", i, -1),
            ("b", i, -1),
            ("e", i, 1),
            ("e", (i + 1) % m, -1),
        ]
        for i in range(m)
    ]


def ribbon_surface(m):
    words = face_words(m)
    following = {word[j]: word[(j + 1) % 6] for word in words for j in range(6)}
    require(len(following) == 6 * m, "each oriented edge must occur exactly once")

    def rotate(dart):
        kind, i, sign = dart
        return following[(kind, i, -sign)]

    remaining = set(following)
    vertices = []
    while remaining:
        start = min(remaining)
        cycle = []
        dart = start
        while dart not in cycle:
            cycle.append(dart)
            remaining.remove(dart)
            dart = rotate(dart)
        require(dart == start, "vertex link is not a circle")
        vertices.append(cycle)
    require(sorted(map(len, vertices)) == [m, 5 * m], "wrong ramified vertex links")
    plus = next(cycle for cycle in vertices if ("a", 0, 1) in cycle)
    minus = next(cycle for cycle in vertices if ("e", 0, -1) in cycle)
    require(all(("e", i, 1) in plus and ("e", i, -1) in minus for i in range(m)),
            "edge endpoints do not agree with the two branch vertices")
    positions = {dart: j for j, dart in enumerate(plus)}
    for kind in ("a", "b"):
        for i in range(m):
            start = positions[(kind, i, 1)]
            end = (positions[(kind, i, -1)] - start) % len(plus)
            for other in ("a", "b"):
                for j in range(m):
                    if (kind, i) == (other, j):
                        continue
                    inside = [0 < (positions[(other, j, sign)] - start) % len(plus) < end
                              for sign in (-1, 1)]
                    require((inside[0] != inside[1]) == (kind != other and i == j),
                            "handle chords have the wrong intersection pattern")
    for i in range(m):
        dart = ("a", i, 1)
        for _ in range(5):
            dart = rotate(dart)
        require(dart == ("a", (i - 1) % m, 1), "first branch has wrong sheet step")
        require(rotate(("e", i, -1)) == ("e", (i + 1) % m, -1),
                "second branch has wrong sheet step")
    return words


def cellular_matrices(m):
    words = ribbon_surface(m)
    edges = [(kind, i) for kind in ("a", "b", "e") for i in range(m)]
    index = {edge: j for j, edge in enumerate(edges)}
    d1 = zero(2, 3 * m)
    for i in range(m):
        d1[0][index[("e", i)]] = -1
        d1[1][index[("e", i)]] = 1
    d2 = zero(3 * m, m)
    for j, word in enumerate(words):
        for kind, i, sign in word:
            d2[index[(kind, i)]][j] += sign
    require(multiply(d1, d2) == zero(2, m), "cellular differential does not square to zero")
    return d1, d2


def difference_matrix(m):
    result = zero(m, m)
    for j in range(m):
        result[j][j] += 1
        result[(j + 1) % m][j] -= 1
    return result


def cellular_replay(m):
    d1, d2 = cellular_matrices(m)
    difference = difference_matrix(m)
    require(d2[:2 * m] == zero(2 * m, m) and d2[2 * m:] == difference,
            "attaching words did not produce the claimed cyclic difference")
    for modulus in (0, 3, 5, 9):
        for j in range(m - 1):
            c = [int(i == j) - int(i == m - 1) for i in range(m)]
            prefix = [0]
            for value in c:
                prefix.append(prefix[-1] + value)
            q = prefix[1:]
            recovered = matvec(difference, q)
            require(all((x == y if modulus == 0 else (x - y) % modulus == 0)
                        for x, y in zip(recovered, c)), "telescoping primitive failed")
    r1, r2 = matrix_rank(d1), matrix_rank(d2)
    require((r1, r2) == (1, m - 1), "incorrect rational differential ranks")
    for prime in (3, 5):
        require(matrix_rank(d1, prime) == 1 and matrix_rank(d2, prime) == m - 1,
                "cellular homology changed at a coefficient prime")
    return {"m": m, "cells": [2, 3 * m, m], "betti_numbers": [1, 2 * m, 1],
            "differential_ranks": [r1, r2], "integral_primitive_checks": m - 1}


def monodromy_replay(m):
    difference = difference_matrix(m)
    laplacian = multiply(difference, transpose(difference))
    expected = zero(m, m)
    for j in range(m):
        expected[j][j] += 2
        expected[(j - 1) % m][j] -= 1
        expected[(j + 1) % m][j] -= 1
    require(laplacian == expected, "adjacent-sheet twist sum is not the Laplacian")
    symplectic = zero(2 * m, 2 * m)
    for i in range(m):
        symplectic[i][m + i], symplectic[m + i][i] = 1, -1
    for sign_a in (-1, 1):
        for sign_b in (-1, 1):
            ta, tb = identity(2 * m), identity(2 * m)
            for i in range(m):
                for j in range(m):
                    ta[i][m + j] = sign_a * laplacian[i][j]
                    tb[m + i][j] = sign_b * laplacian[i][j]
            for operator in (ta, tb):
                require(multiply(multiply(transpose(operator), symplectic), operator)
                        == symplectic, "monodromy is not integral symplectic")
    shift = zero(m, m)
    reversal = zero(m, m)
    for j in range(m):
        shift[(j + 1) % m][j] = 1
        reversal[(-j) % m][j] = 1
    require(multiply(shift, laplacian) == multiply(laplacian, shift),
            "common cyclic relabeling changed the operator")
    require(multiply(multiply(reversal, laplacian), reversal) == laplacian,
            "deck-generator inversion changed the operator")
    cofactor = determinant([row[:-1] for row in laplacian[:-1]])
    require(cofactor == m, "the Laplacian cofactor is not m")
    kernels = {str(p): m - matrix_rank(laplacian, p) for p in (3, 5)}
    require(all(kernels[str(p)] == (2 if m % p == 0 else 1) for p in (3, 5)),
            "wrong kernel dimension at a coefficient prime")
    return {"m": m, "all_four_sign_choices_symplectic": True,
            "cyclic_shift_and_reversal_invariant": True, "laplacian_cofactor": cofactor,
            "laplacian_kernel_dimensions": kernels}


def poly_add(a, b):
    result = dict(a)
    for monomial, coefficient in b.items():
        result[monomial] = result.get(monomial, 0) + coefficient
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def poly_scale(a, coefficient):
    return {monomial: value * coefficient for monomial, value in a.items()
            if value * coefficient}


def poly_mul(a, b):
    result = {}
    for x, cx in a.items():
        for y, cy in b.items():
            monomial = tuple(i + j for i, j in zip(x, y))
            result[monomial] = result.get(monomial, 0) + cx * cy
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def universal_identities():
    one, u, inverse = {(0,): 1}, {(1,): 1}, {(-1,): 1}
    difference = poly_add(one, poly_scale(u, -1))
    opposite = poly_add(one, poly_scale(inverse, -1))
    laplacian = poly_add(poly_scale(one, 2), poly_scale(poly_add(u, inverse), -1))
    require(poly_mul(difference, opposite) == laplacian, "Laurent identity failed")
    z, n, t, w = ({tuple(int(i == j) for i in range(4)): 1} for j in range(4))
    constant = {(0, 0, 0, 0): 1}
    nt = poly_mul(n, t)
    x = poly_add(z, nt)
    local_left = poly_add(poly_mul(x, w), poly_scale(poly_add(z, poly_scale(nt, -1)), -1))
    local_right = poly_add(poly_mul(x, poly_add(w, poly_scale(constant, -1))),
                           poly_scale(nt, 2))
    require(local_left == local_right, "local nodal equation has a sign error")
    return {"laurent_identity": "(1-u)(1-u^-1)=2-u-u^-1",
            "node_identity": "(z+nt)w-(z-nt)=(z+nt)(w-1)+2nt",
            "node_smoothing_order_in_characteristic_zero": 1}


def exceptional_replay():
    cases = []
    for n, m in ((3, 3), (9, 3), (9, 9), (15, 3), (15, 5), (15, 15),
                 (303, 3), (303, 101), (303, 303),
                 (327, 3), (327, 109), (327, 327)):
        require(n >= 3 and n % 2 == 1 and m > 1 and n % m == 0,
                "exceptional-fiber example violates the literal hypotheses")
        value_at_zero = Fraction(-n, n) * Fraction(1, -1) ** n
        require(value_at_zero == 1, "odd-degree exceptional normalization has wrong sign")
        divisor = {n: 1, -n: -1, 1: -n, -1: n}
        divisor[1] += m * (n // m)
        divisor[-1] -= m * (n // m)
        require({point: order for point, order in divisor.items() if order}
                == {n: 1, -n: -1}, "exceptional Kummer coordinate did not remove n-fold zeros")
        cases.append({"n": n, "m": m, "normalized_value_at_zero": 1,
                      "remaining_branch_orders": [1, -1]})
    return cases


def elliptic_function_replay():
    curve_a, curve_b = Fraction(-1), Fraction(1)
    origin = None
    r = (Fraction(0), Fraction(1))

    def negate(p):
        return origin if p is origin else (p[0], -p[1])

    def add(p, q):
        if p is origin:
            return q
        if q is origin:
            return p
        x, y = p
        xx, yy = q
        if x == xx and y == -yy:
            return origin
        slope = (3 * x * x + curve_a) / (2 * y) if p == q else (yy - y) / (xx - x)
        intercept = y - slope * x
        third_x = slope * slope - x - xx
        require(x + xx + third_x == slope * slope
                and x * xx + x * third_x + xx * third_x == curve_a - 2 * slope * intercept
                and -x * xx * third_x == curve_b - intercept * intercept,
                "the actual line/Weierstrass cubic intersection does not factor")
        result = (third_x, -slope * third_x - intercept)
        require(result[1] ** 2 == result[0] ** 3 + curve_a * result[0] + curve_b,
                "elliptic addition left the actual curve")
        return result

    def add_divisor(divisor, p, coefficient):
        divisor[p] = divisor.get(p, 0) + coefficient
        if divisor[p] == 0:
            del divisor[p]

    def miller_divisor(n, p):
        current, divisor = p, {}
        for _ in range(1, n):
            following = add(current, p)
            require(current is not origin and following is not origin and current != negate(p),
                    "the chosen finite Miller example met a torsion boundary")
            for point, coefficient in ((current, 1), (p, 1), (following, -1), (origin, -1)):
                add_divisor(divisor, point, coefficient)
            current = following
        expected = {}
        for point, coefficient in ((p, n), (current, -1), (origin, -(n - 1))):
            add_divisor(expected, point, coefficient)
        require(divisor == expected, "Miller line/vertical factors have the wrong divisor")
        return current, divisor

    examples = []
    for n in (3, 5, 9):
        s, positive = miller_divisor(n, r)
        negative_s, negative = miller_divisor(n, negate(r))
        require(negative_s == negate(s), "multiplication did not commute with inversion")
        require(len({origin, r, negate(r), s, negate(s)}) == 5,
                "actual arithmetic parameter is outside the manuscript open U")
        actual = dict(negative)
        for point, coefficient in positive.items():
            add_divisor(actual, point, -coefficient)
        expected = {}
        for point, coefficient in ((s, 1), (negate(s), -1), (r, -n), (negate(r), n)):
            add_divisor(expected, point, coefficient)
        require(actual == expected, "the actual rational function is not geo:kummer")
        examples.append({"n": n, "curve": "y^2=x^3-x+1", "t": 0, "R": ["0", "1"],
                         "nR": [str(coordinate) for coordinate in s],
                         "line_factorizations_checked": 2 * (n - 1),
                         "five_required_points_distinct": True,
                         "normalized_value_at_O": 1,
                         "divisor_matches_geo_kummer": True})
    return examples


def character_replay():
    examples = []
    for p in (101, 109):
        require(all(p % d for d in range(2, p)), "character example is not prime")
        n = 3 * p
        a, b = 3 * pow(3, -1, p), p * pow(p, -1, 3)
        require((a + b) % n == 1 and a % 3 == 0 and b % p == 0,
                "incorrect primary character exponents")
        require(a % p == 1 and b % 3 == 1, "primary factors do not recombine")
        for j in range(n):
            require(j % 3 == b * j % 3 and a * j % 3 == 0,
                    "the two characteristic-p evaluation maps differ")
            require(j % p == a * j % p and b * j % p == 0,
                    "the two characteristic-three evaluation maps differ")
        examples.append({"p": p, "n": n, "psi_exponent": a, "eta_exponent": b,
                         "all_group_ring_basis_images_compared": n})
    for prime in (3, 5, 7):
        for u in range(2, prime):
            c = (2 - u - pow(u, -1, prime)) % prime
            require(c != 0, "a nontrivial field character killed the Laplacian")
            for sign_a in (-1, 1):
                for sign_b in (-1, 1):
                    for x in range(prime):
                        for y in range(prime):
                            upper = (x * y - (x + sign_a * c * y) * y) % prime
                            lower = (x * (y + sign_b * c * x) - x * y) % prime
                            require(upper or lower or (x == 0 and y == 0),
                                    "a common invariant line survived both shears")
    return examples


def jacobian_replay():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    d1, d2 = cellular_matrices(3)
    expected = {"complex": {"coefficient_field": "QQ", "degree_min": 0, "degree_max": 2,
                           "basis_sizes": [2, 9, 3],
                           "differential_matrices": [
                               [[str(x) for x in row] for row in d1],
                               [[str(x) for x in row] for row in d2]]}}
    require(payload == expected, "Jacobian input is not the derived m=3 surface complex")
    envelope = json.loads((ROOT / "jacobian_output.json").read_text())
    require(envelope.get("request", {}).get("operation_id") == "chain_complex.homology.compute",
            "Jacobian operation id is missing")
    require(envelope["request"].get("payload") == payload, "Jacobian retained a different payload")
    require(envelope.get("server", {}).get("version"), "Jacobian server version missing")
    response = envelope.get("result", {})
    require("error" not in envelope and "error" not in response,
            "Jacobian reported a structured error")
    require(response.get("operation_id") == "chain_complex.homology.compute",
            "Jacobian output names a different operation")
    result = response.get("output", {})
    require("homology_groups" in result, "Jacobian returned no typed homology result")
    require(result.get("complex") == {**payload["complex"], "prime": None},
            "Jacobian output is attached to a different source complex")
    groups = result["homology_groups"]
    require([(g["degree"], g["cycle_rank"], g["boundary_rank"], g["betti_number"])
             for g in groups] == [(0, 2, 1, 1), (1, 8, 2, 6), (2, 1, 0, 1)],
            "Jacobian did not return the expected homology")
    return {"operation_id": "chain_complex.homology.compute",
            "server_version": envelope["server"]["version"],
            "protocol_version": envelope["protocol_version"],
            "adapter_status": "success",
            "structured_error": None,
            "timeout": False,
            "betti_numbers": [g["betti_number"] for g in groups],
            "scope": "one bounded rational replay, not an integral or universal proof"}


def lean_replay():
    result = json.loads((ROOT / "lean_check.json").read_text())
    require(result.get("status") == "success" and result.get("exit_code") == 0,
            "the Lean compiler did not succeed")
    require(result.get("proof_holes") == [], "Lean evidence contains proof holes")
    for path, key in ((ROOT / "Main.lean", "source_sha256"),
                      (ROOT / "statement_fidelity.md", "statement_fidelity_sha256")):
        require(hashlib.sha256(path.read_bytes()).hexdigest() == result.get(key),
                f"stale compiler evidence for {path.name}")
    require("4.31.0" in json.dumps(result.get("tools", {})), "wrong Lean toolchain")
    return {"exit_code": 0, "proof_holes": [], "source_and_fidelity_match_compiler_run": True,
            "scope": "universal algebra only; geometric identification is in report.md"}


def certificate():
    return {
        "claim": "C_GPS_CORE",
        "result_kind": "geometric_verification_theorem_with_formal_algebraic_core",
        "independent_review": "required_not_performed_by_this_script",
        "novelty_status": "not_established",
        "not_a_proof_of": "the full modularity theorem",
        "universal_proof": "report.md",
        "universal_identities": universal_identities(),
        "exceptional_fiber_replays": exceptional_replay(),
        "actual_elliptic_function_replays": elliptic_function_replay(),
        "cellular_replays": [cellular_replay(m) for m in DEGREES],
        "monodromy_replays": [monodromy_replay(m) for m in DEGREES],
        "character_examples": character_replay(),
        "jacobian": jacobian_replay(),
        "lean": lean_replay(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == result, "exact certificate does not replay")
    print("PASS: exact slit-surface, twist, specialization, Jacobian, and fresh Lean evidence")


if __name__ == "__main__":
    main()
