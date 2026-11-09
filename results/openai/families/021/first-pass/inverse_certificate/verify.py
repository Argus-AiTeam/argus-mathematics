#!/usr/bin/env python3
"""Replay exact fixtures and numerical hypotheses; universal proofs are in Main.lean and REPORT.md."""

import json
from fractions import Fraction
from itertools import product
from math import comb, gcd, isqrt, prod
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def prime(n):
    return n >= 2 and all(n % d for d in range(2, isqrt(n) + 1))


def primes_in_bin(lo, hi):
    assert 0 <= lo < hi
    start = max(2, lo + 1)
    if start > hi:
        return []
    sieve = bytearray(b"\x01") * (hi - start + 1)
    for p in range(2, isqrt(hi) + 1):
        if prime(p):
            first = max(p * p, ((start + p - 1) // p) * p)
            if first <= hi:
                sieve[first - start::p] = b"\x00" * ((hi - first) // p + 1)
    return [start + i for i, flag in enumerate(sieve) if flag]


def crt(classes):
    b, modulus = 0, 1
    for p, a in classes:
        assert prime(p) and gcd(modulus, p) == 1
        b += modulus * ((a - b) * pow(modulus, -1, p) % p)
        modulus *= p
    b = b % modulus or modulus
    assert 1 <= b <= modulus
    assert all((b - a) % p == 0 for p, a in classes)
    return b


def divisor_count_bound(R, value):
    assert R >= 2 and value >= 1
    bound = 0
    while R ** (bound + 1) <= value:
        bound += 1
    return bound


def collision(rows, N, B):
    assert N >= 0 and B >= 0
    assert all(row <= set(range(N)) for row in rows)
    for x in range(N):
        for y in range(N):
            if x != y:
                assert sum(x in row and y in row for row in rows) <= B
    mass = sum(map(len, rows))
    energy = sum(len(row) ** 2 for row in rows)
    assert energy <= B * N * (N - 1) + mass
    assert mass ** 2 <= len(rows) * energy
    assert mass ** 2 <= len(rows) * (B * N * (N - 1) + mass)
    return mass, energy


def verify_main_fixture(c):
    xi = Fraction(*c["xi"])
    A, D = c["intercept"]
    base_classes = {int(p): a for p, a in c["classes_at_base_primes"].items()}
    assert set(base_classes) == {7, 11}
    bins = [c["isolated_bin"], *c["other_parent_bins"], c["edge_bin"]]
    choices = [primes_in_bin(*interval) for interval in bins]
    assert all(choices)
    for (lo, hi), values in zip(bins, choices):
        assert Fraction(hi, lo) <= 1 + xi
        assert all(lo < p <= hi and p > c["small_prime_cutoff"] for p in values)
    assert all(set(a).isdisjoint(b) for i, a in enumerate(choices) for b in choices[i + 1:])
    P, base1, base2, large_bin, U = choices
    assert base1 == [7] and base2 == [11] and U == [5]
    assert min(large_bin) > max(P) > 11 > 7 > 5
    Q = [77 * ell for ell in large_bin]
    assert len(set(Q)) == len(Q)
    assert all(gcd(77, ell) == 1 for ell in large_bin)
    assert all(gcd(q, 6) == 1 for q in Q)
    full_representatives = {}
    for ell, q in zip(large_bin, Q):
        b = crt([(7, base_classes[7]), (11, base_classes[11]),
                 (ell, A * pow(D, -1, ell) % ell)])
        assert 1 <= b <= q
        full_representatives[ell] = b

    selected = c["selected_large_primes"]
    assert len(selected) == len(set(selected)) and set(selected) <= set(large_bin)
    points = [(77 * ell, full_representatives[ell]) for ell in selected]
    d, a, b0 = (c["line"][key] for key in ("d", "a", "b"))
    g = gcd(b0, d)
    assert d > 0 and gcd(a, d) == 1 and gcd(A, D) == 1 and D > 0
    assert d == g * D and b0 == g * A and g == 77
    assert gcd(D, g) == 7 and D == 7 ** 2
    assert all(d * b == a * q + b0 for q, b in points)
    ap = {p: A * pow(D, -1, p) % p for p in P}
    unaligned_count = c["unaligned_isolated_count"]
    assert 0 < unaligned_count < len(P) and c["omitted_alignments_per_point"] == 1
    assert 0 < c["unaligned_offset"] < min(P)
    for p in P[-unaligned_count:]:
        ap[p] = (ap[p] + c["unaligned_offset"]) % p
    aligned = [p for p in P if (D * ap[p] - A) % p == 0]
    exceptional = [p for p in P if d % p == 0]
    slopes = {}
    for p in P:
        if p in aligned:
            slopes[p] = {-a * pow(d, -1, p) % p}
        else:
            slopes[p] = {(ap[p] - b) * pow(q, -1, p) % p for q, b in points[:2]}
    K = sum(map(len, slopes.values()))
    cells, rows = [], []
    for p in P:
        for s in slopes[p]:
            cells.append((p, s))
            rows.append({j for j, (q, b) in enumerate(points)
                         if p not in aligned and p not in exceptional
                         and (b + s * q - ap[p]) % p == 0})

    incidences = set()
    for j, (q, b) in enumerate(points):
        for p in P:
            selected_incidence = ((p in aligned and p != aligned[j])
                                  or (p not in aligned and j in c["unaligned_point_indices"]))
            if selected_incidence:
                incidences.add((p, j))
                s = (ap[p] - b) * pow(q, -1, p) % p
                assert s in slopes[p] and (b + s * q - ap[p]) % p == 0
                assert p in aligned or p in exceptional or any(
                    cell_p == p and j in row for (cell_p, _), row in zip(cells, rows))
    N, n = len(points), len(P)
    r = min(sum((p, j) in incidences for p in P) for j in range(N))
    t, m = n // 4, c["m"]
    R, S = c["isolated_bin"][0], 7 * 11 * c["other_parent_bins"][-1][1]
    H_D, H_A = S // (m - 1), 2 * S * (S // (m - 1))
    e, Cq = divisor_count_bound(R, H_D), divisor_count_bound(R, S)
    Cdet = divisor_count_bound(R, 2 * H_A * H_D)
    assert N >= m >= 2 and r >= e + t
    assert len(exceptional) <= e
    assert R ** (Cq + 1) > S and R ** (e + 1) > H_D
    assert R ** (Cdet + 1) > 2 * H_A * H_D
    mass, energy = collision(rows, N, Cq)
    assert mass <= n * N and len(rows) == K
    assert r * N <= (len(aligned) + e) * N + mass
    margin_left = K * (Cq * m * m + n * m)
    margin_right = ((r - e - t) * m) ** 2
    assert margin_left < margin_right
    assert len(aligned) > t
    assert 2 * Cdet * n <= t * t
    assert A <= H_A and D <= H_D
    for ell, (q, b) in zip(selected, points):
        factors = [7, 11, ell]
        assert len(set(factors)) == len(factors) and all(prime(p) for p in factors)
        assert prod(factors) == q and g != 0 and q % g == 0
        classes = {**base_classes, ell: A * pow(D, -1, ell) % ell}
        bad = [p for p in factors if (D * classes[p] - A) % p]
        qE = prod(bad)
        assert g % qE == 0 and D * qE <= d <= H_D
        assert D * b - A == a * (q // g)
        assert all((D * ap[p] - A) % p == 0 for p in aligned)
    measured = {
        "n": n, "N": N, "r": r, "t": t, "K": K, "S": S,
        "H_D": H_D, "H_A": H_A, "e": e,
        "difference_overlap_bound": Cq, "determinant_overlap_bound": Cdet,
        "collision_margin_left": margin_left, "collision_margin_right": margin_right,
        "packing_threshold_left": 2 * Cdet * n, "packing_threshold_right": t * t,
        "list_bound": (2 * n * n) // (t * t), "aligned_primes": len(aligned),
        "exception_product": qE, "structured_height": D * qE,
    }
    assert measured == c["expected"], (measured, c["expected"])
    return P, points, {"box_triples": n * len(Q) * len(U), "cell_mass": mass, "cell_energy": energy,
                       "list_bound": measured["list_bound"]}


def verify_complete_small(c):
    P, Q = c["isolated_primes"], c["q_values"]
    assert all(prime(p) for p in P + Q) and set(P).isdisjoint(Q)
    assert c["b_value"] == c["all_prescribed_classes"] == 1
    assert c["all_slopes"] == [0] and c["polynomial"] == "Y-1"
    d, h, r, t, m = (c[key] for key in ("d", "coefficient_box_cap", "r", "t", "m"))
    n, N, R, S, K = len(P), len(Q), min(P), max(Q), len(P)
    v, index = comb(d + 2, 2), prod(p ** (d + 1) for p in P)
    assert (h + 1) ** v > index and v * h * S ** d < R ** r
    assert 1 <= h and d == 1
    assert all(crt([(q, 1)]) == 1 for q in Q)
    assert all((1 + 0 * q - 1) % p == 0 for p in P for q in Q)
    H_D, H_A = S // (m - 1), 2 * S * (S // (m - 1))
    e, Cq, Cdet = (divisor_count_bound(R, v) for v in (H_D, S, 2 * H_A * H_D))
    assert c["nonlinear_points"] == 0
    assert N > d * (m - 1) and N >= m >= 2
    assert K * (Cq * m * m + n * m) < ((r - e - t) * m) ** 2
    assert t * t >= 2 * Cdet * n
    assert 1 <= H_D and 1 <= H_A and n >= r
    return {"coefficient_box_vectors": (h + 1) ** v, "congruence_index_bound": index,
            "polynomial_value_bound": v * h * S ** d, "prime_product_lower_bound": R ** r}


def verify_boundary(c):
    d, a, b0 = (c["line"][key] for key in ("d", "a", "b"))
    A, D = c["intercept"]
    g = gcd(d, b0)
    assert gcd(a, d) == 1 and gcd(A, D) == 1 and d == g * D and b0 == g * A
    assert gcd(g, D) == 2 and D == 2 ** 2
    for (q, b), factors in zip(c["points"], c["factorizations"]):
        assert prod(factors) == q and len(set(factors)) == len(factors)
        assert all(prime(p) for p in factors)
        assert d * b == a * q + b0 and 1 <= b <= q
        classes = {int(p): ap for p, ap in c["classes_at_base_primes"].items()}
        assert set(classes) == {2, 3}
        classes[factors[-1]] = A * pow(D, -1, factors[-1]) % factors[-1]
        assert b == crt(list(classes.items()))
        qE = prod(p for p in factors if (D * classes[p] - A) % p)
        assert q % g == 0 and g % qE == 0 and D * qE == d
    payload = json.loads((ROOT / c["jacobian_payload"]).read_text())
    output = json.loads((ROOT / c["jacobian_output"]).read_text())
    status = json.loads((ROOT / c["jacobian_status"]).read_text())
    assert status == {"adapter_exit_code": 0, "timeout": False}
    assert output["server"]["version"] == "0.14.0" and output["protocol_version"] == "2025-11-25"
    assert output["request"]["operation_id"] == output["result"]["operation_id"] == "matrix.determinant.compute"
    assert output["request"]["payload"] == payload
    matrix = [[Fraction(int(x["num"]), int(x["den"])) for x in row]
              for row in payload["matrix"]["entries"]]
    assert matrix == [[Fraction(q), Fraction(b), Fraction(1)] for q, b in c["points"]]
    det = sum(matrix[0][j]
              * (matrix[1][(j + 1) % 3] * matrix[2][(j + 2) % 3]
                 - matrix[1][(j + 2) % 3] * matrix[2][(j + 1) % 3])
              for j in range(3))
    assert det == 0
    typed = output["result"]["output"]
    assert Fraction(int(typed["determinant"]["num"]), int(typed["determinant"]["den"])) == det
    assert typed["method"] == "FRACTION_FREE_BAREISS"


def verify_crt_slopes(c, P, points):
    M0, U = c["M0"], c["edge_primes"]
    p = P[c["isolated_prime_index"]]
    centers = [points[j] for j in c["point_indices"]]
    W = prod(U)
    assert M0 == 6 and len(U) == len(set(U)) and all(prime(u) for u in U)
    assert all(gcd(M0, u) == 1 and gcd(p, u) == 1 for u in U)
    assert len({(q % M0, b % M0) for q, b in centers}) == 1
    patterns = {}
    for v in range(M0):
        for i, u in enumerate(U):
            patterns[v, u] = {(v + i) % u}
            if v % 2 == 0:
                patterns[v, u].add((v + i + 1) % u)
    density_sum = sum((prod(Fraction(len(patterns[v, u]), u) for u in U)
                       for v in range(M0)), Fraction())
    Kp = Fraction(p, M0) * density_sum + M0 * W
    counts = []
    for q, b in centers:
        assert gcd(q * p, M0 * W) == 1
        inverses = {u: pow(p * q, -1, u) for u in U}

        def passes(s):
            return all(((au - b - q * s) * inverses[u] % u) in patterns[s % M0, u]
                       for u, au in zip(U, c["edge_classes"]))

        residues_by_v = [0] * M0
        for s in range(M0 * W):
            if passes(s):
                residues_by_v[s % M0] += 1
        assert residues_by_v == [prod(len(patterns[v, u]) for u in U) for v in range(M0)]
        for u in U:
            assert (-q * inverses[u]) % u == (-pow(p, -1, u)) % u
        actual = sum(passes(s) for s in range(p))
        assert actual <= Kp
        counts.append(actual)
    return {"slope_counts": counts, "rounding_term": M0 * W,
            "uniform_upper_bound": [Kp.numerator, Kp.denominator]}


def verify_constants(c, exponents):
    sigma, astar = Fraction(*c["sigma"]), Fraction(*c["a_star"])
    h = c["h1"]
    beta = sigma / 16
    gamma = beta / 2 * (beta / 4) ** h
    c5, cp = gamma / 8, gamma / 32
    assert 0 < sigma < 1 and astar * h / 2 > 12
    assert c["gamma_inc_power_of_two"] < 0
    assert gamma == Fraction(1, 2 ** -c["gamma_inc_power_of_two"])
    assert c5 == Fraction(1, 2 ** -c["c5_power_of_two"])
    assert cp == Fraction(1, 2 ** -c["cp_power_of_two"])
    assert cp == c5 / 4 and 2 / cp ** 2 == 2 ** c["F_power_of_two"]
    amin = Fraction(*exponents["alpha_min"])
    amax = Fraction(*exponents["manuscript_alpha_max"])
    extended = Fraction(*exponents["illustrative_extended_alpha_max"])
    limit = Fraction(*exponents["strict_structural_alpha_limit"])
    assert 0 < amin <= amax < extended < limit == Fraction(1, 5)
    assert (10 * amax - 2) / 3 == Fraction(*exponents["cubic_nonlinear_exponent"]) < 0
    assert (13 * amax - 2) / 3 == Fraction(*exponents["manuscript_quartic_nonlinear_exponent"]) < 0
    assert 3 * amax - 2 == Fraction(*exponents["collision_small_line_exponent"]) < 0
    assert (10 * extended - 2) / 3 == Fraction(*exponents["extended_cubic_exponent"]) < 0
    for degree in range(2, 101):
        assert 5 * degree ** 2 + 4 * degree + 2 <= 8 * degree ** 2
        assert 8 * degree ** 3 * 32 + 8 * degree ** 3 <= 512 * degree ** 3


def verify_small_families():
    cases = 0
    for N in range(5):
        subsets = [{x for x in range(N) if mask & (1 << x)} for mask in range(1 << N)]
        for K in range(4):
            for rows in product(subsets, repeat=K):
                B = max((sum(x in row and y in row for row in rows)
                         for x in range(N) for y in range(N) if x != y), default=0)
                collision(rows, N, B)
                cases += 1
    return cases


def main():
    c = json.loads((ROOT / "exact_certificate.json").read_text())
    assert c["claim"] == "C_INVERSE_FINITE" and c["independent_review"] == "pending"
    P, points, main_result = verify_main_fixture(c["main_fixture"])
    complete = verify_complete_small(c["complete_small_fixture"])
    verify_boundary(c["boundary_fixture"])
    slopes = verify_crt_slopes(c["crt_slope_fixture"], P, points)
    verify_constants(c["manuscript_constants"], c["exponent_checks"])
    cases = verify_small_families()
    print(json.dumps({"ok": True, "claim": c["claim"], "main_fixture": main_result,
                      "complete_small_fixture": complete, "crt_slopes": slopes,
                      "finite_family_regression_cases": cases,
                      "scope": "exact fixtures and numerical bridges; universal theorem uses the Lean proof and report",
                      "independent_review": "pending"}, sort_keys=True))


if __name__ == "__main__":
    main()
