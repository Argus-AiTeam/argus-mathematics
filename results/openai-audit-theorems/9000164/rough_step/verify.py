#!/usr/bin/env python3
"""Recompute exact algebraic witnesses; the analytic theorem is in report.md."""

import argparse
import json
from fractions import Fraction as F
from itertools import zip_longest
from math import comb, factorial, gcd, isqrt, lcm, prod
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OPERATION = "polynomial.interpolation.newton_form.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def trim(p):
    p = list(map(F, p))
    while len(p) > 1 and p[-1] == 0:
        p.pop()
    return p or [F(0)]


def add(*polys):
    return trim(sum(row, F(0)) for row in zip_longest(*polys, fillvalue=F(0)))


def scale(p, c):
    return trim(F(c) * a for a in p)


def mul(p, q):
    out = [F(0)] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            out[i + j] += a * b
    return trim(out)


def power(p, e):
    out = [F(1)]
    for _ in range(e):
        out = mul(out, p)
    return out


def evaluate(p, x):
    out = F(0)
    for a in reversed(p):
        out = out * x + a
    return out


def hasse(p, j):
    return trim(comb(i, j) * p[i] for i in range(j, len(p)))


def divide(p, q):
    require(q != [F(0)], "division by the zero polynomial")
    rem = trim(p)
    out = [F(0)] * max(1, len(p) - len(q) + 1)
    while rem != [F(0)] and len(rem) >= len(q):
        shift = len(rem) - len(q)
        c = rem[-1] / q[-1]
        out[shift] += c
        rem = add(rem, [F(0)] * shift + scale(q, -c))
    return trim(out), rem


def lagrange(nodes, values):
    out = [F(0)]
    for j, x in enumerate(nodes):
        basis = [F(1)]
        denominator = F(1)
        for k, y in enumerate(nodes):
            if j != k:
                basis = mul(basis, [-y, 1])
                denominator *= x - y
        out = add(out, scale(basis, values[j] / denominator))
    return out


def newton(nodes, values):
    coefficients = list(map(F, values))
    for order in range(1, len(nodes)):
        for j in range(len(nodes) - 1, order - 1, -1):
            coefficients[j] = (
                (coefficients[j] - coefficients[j - 1])
                / (nodes[j] - nodes[j - order])
            )
    return coefficients


def expand_newton(nodes, coefficients):
    out, basis = [F(0)], [F(1)]
    for x, c in zip(nodes, coefficients):
        out = add(out, scale(basis, c))
        basis = mul(basis, [-x, 1])
    return out


def binomial_polynomial(k):
    out = [F(1)]
    for j in range(k):
        out = mul(out, [-j, 1])
    return scale(out, F(1, factorial(k)))


def nearest(x):
    return (2 * x.numerator + x.denominator) // (2 * x.denominator)


def primes(w):
    return [p for p in range(2, w + 1)
            if all(p % q for q in range(2, isqrt(p) + 1))]


def smooth(n, w):
    require(n > 0, "smoothness input must be positive")
    for p in primes(w):
        while n % p == 0:
            n //= p
    return n == 1


def node_data(q, H):
    N = H - 1
    nodes = [j * N // q for j in range(q + 1)]
    denominator = prod(nodes[j] - nodes[i]
                       for i in range(q + 1) for j in range(i + 1, q + 1))
    return nodes, denominator


def interpolation_case(q, e, H, w, S, t0, m, Z=None):
    require(H >= 2 * q + 2 and 1 <= e <= q, "interpolation degree/length")
    nodes, DH = node_data(q, H)
    N = H - 1
    Cq = (q + 1) * (4 * q) ** q
    Jq = 2 ** q * Cq
    A = 2 ** q
    if Z is None:
        multiplier = 1 + DH * (Jq * A * 3 ** q + (Cq + 1) * A)
        Z = multiplier * S ** (2 * q + 2)
    W = prod(primes(w))
    ts = [t0 + m * z for z in range(H)]
    require(min(ts) >= S and max(ts) < 2 * S, "dyadic step range")
    require(smooth(m, w), "step difference is not smooth")
    require(all(gcd(t, W) == 1 for t in ts), "a step is not rough")

    k = q - e
    M = add(binomial_polynomial(k), [1])
    perturbation = scale(power([1, F(1, N)], k), F(1, Z ** e))
    theta = add(M, perturbation)
    linear_power = power([t0, m], e)
    T = mul(linear_power, theta)
    R0 = mul(linear_power, M)
    epsilon = A * F(S, Z) ** e
    require(len(T) - 1 <= q, "joint degree exceeded")
    values = [nearest(evaluate(T, z)) for z in nodes]
    R = lagrange(list(map(F, nodes)), list(map(F, values)))
    require(R == R0, "integer interpolation failed to recover the exact factor")
    require(all((DH * a).denominator == 1 for a in R), "Lagrange denominator")
    require(DH <= N ** (q * (q + 1) // 2), "Vandermonde height bound")

    root = -F(t0, m)
    root_multiplier = DH * m ** q
    root_bound = DH * S ** q * Jq * epsilon * (1 + 2 * S) ** q
    value_bound = DH * (Cq + 1) * epsilon
    require(root_bound < 1 and value_bound < 1, "strict exactness thresholds")
    jets = [evaluate(hasse(R, j), root) for j in range(e)]
    require(all(jet == 0 for jet in jets), "root multiplicity")
    require(all((root_multiplier * jet).denominator == 1 for jet in jets),
            "root denominator clearing")
    quotient, remainder = divide(R, linear_power)
    require(remainder == [F(0)] and quotient == M, "exact linear division")
    Mden = lcm(*(a.denominator for a in quotient))
    require((DH * m ** (e * (q - e + 1))) % Mden == 0,
            "long-division denominator bound")
    require(smooth(DH, w) and smooth(Mden, w), "interpolation smoothness")

    maximum_error = F(0)
    for z, t in enumerate(ts):
        actual = evaluate(T, z)
        require(abs(actual - nearest(actual)) <= epsilon, "input modular bound")
        require(evaluate(R, z).denominator == 1, "interpolated value not integral")
        require(evaluate(M, z).denominator == 1, "rough cancellation not integral")
        error = abs(evaluate(theta, z) - evaluate(M, z))
        require(error <= F(Cq * A, Z ** e), "length-independent output bound")
        maximum_error = max(maximum_error, error)

    bad_R = add(R, [F(1, DH)])
    bad_jet = evaluate(bad_R, root)
    require(bad_jet == F(1, DH), "nonzero-jet negative control")
    require(abs(root_multiplier * bad_jet) >= 1,
            "rational gap incorrectly accepted a nonzero jet")
    return {
        "q": q, "e": e, "H": H, "w": w, "W": W, "S": S,
        "t0": t0, "m": m, "Z": Z, "A": A, "nodes": nodes,
        "node_integer_values": values, "D_H": DH, "C_q": Cq, "J_q": Jq,
        "R_coefficients": list(map(str, R)),
        "M_coefficients": list(map(str, M)),
        "M_common_denominator": Mden,
        "root": str(root), "root_jets": list(map(str, jets)),
        "root_exactness_bound": str(root_bound),
        "value_exactness_bound": str(value_bound),
        "maximum_scaled_error": str(maximum_error * Z ** e / A),
    }


def lagrange_audit():
    cases = 0
    largest_ratio = F(0)
    for q in range(1, 7):
        for H in (2 * q + 2, 2 * q + 3, 7 * q + 11, 101 * q + 19):
            nodes, DH = node_data(q, H)
            N = H - 1
            normalized = [F(z, N) for z in nodes]
            require(all(normalized[j + 1] - normalized[j] >= F(1, 2 * q)
                        for j in range(q)), "node separation")
            for j in range(q + 1):
                values = [F(int(i == j)) for i in range(q + 1)]
                basis = lagrange(normalized, values)
                norm = sum(map(abs, basis), F(0))
                require(norm <= (4 * q) ** q, "uniform Lagrange coefficient bound")
                largest_ratio = max(largest_ratio, norm / (4 * q) ** q)
                require([evaluate(basis, x) for x in normalized] == values,
                        "Lagrange cardinal identity")
                integer_basis = lagrange(list(map(F, nodes)), values)
                require(all((DH * a).denominator == 1 for a in integer_basis),
                        "Vandermonde fails to clear a Lagrange denominator")
            cases += 1
    return {"cases": cases, "largest_coefficient_bound_ratio": str(largest_ratio)}


def jacobian_replay(example):
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    contract = json.loads((ROOT / "jacobian_contract.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    status = json.loads((ROOT / "jacobian_adapter_status.json").read_text())
    require(contract["result"]["operation"]["operation_id"] == OPERATION,
            "wrong inspected operation")
    require(output["result"]["operation_id"] == OPERATION, "wrong executed operation")
    require(output["request"]["payload"] == payload, "operation payload changed")
    require(output["server"]["version"] == "0.14.0"
            and output["protocol_version"] == "2025-11-25", "sidecar provenance")
    require(status["execution"]["adapter_exit"] == 0
            and status["execution"]["structured_error"] is None
            and status["execution"]["timeout"] is False, "nonconclusive adapter run")

    def rational(d):
        r = F(int(d["num"]), int(d["den"]))
        require(str(r.numerator) == d["num"] and str(r.denominator) == d["den"],
                "noncanonical sidecar rational")
        return r

    samples = payload["samples"]
    xs = list(map(rational, samples["nodes"]))
    ys = list(map(rational, samples["values"]))
    expected = newton(xs, ys)
    received = output["result"]["output"]
    require(list(map(rational, received["nodes"])) == xs, "sidecar nodes")
    require(list(map(rational, received["coefficients"])) == expected,
            "independent divided differences disagree with Jacobian")
    expanded = expand_newton(xs, expected)
    require(expanded == lagrange(xs, ys), "Newton/Lagrange mismatch")
    require(list(map(str, expanded)) == example["R_coefficients"], "source polynomial mismatch")
    require(list(map(int, xs)) == example["nodes"]
            and list(map(int, ys)) == example["node_integer_values"], "source sample mismatch")
    return {
        "operation_id": OPERATION, "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit": status["execution"]["adapter_exit"],
        "coefficients": list(map(str, expected)),
        "independent_replay": "exact divided differences and polynomial expansion",
    }


def ceil_fraction(x):
    return -((-x.numerator) // x.denominator)


def count_interval(lo, hi, q, b):
    return max(0, ceil_fraction((hi - b) / q) - ceil_fraction((lo - b) / q))


def bezout(a, b):
    old_r, r, old_s, s, old_t, t = a, b, 1, 0, 0, 1
    while r:
        q = old_r // r
        old_r, r = r, old_r - q * r
        old_s, s = s, old_s - q * s
        old_t, t = t, old_t - q * t
    return old_r, old_s, old_t


def residue_and_count_audit():
    counts, residues, fibers = 0, 0, 0
    maximum_count_error = F(0)
    for lo in (F(-31, 3), F(-7, 2), F(0), F(19, 3)):
        for length in (F(1, 2), F(7, 3), F(23, 2)):
            hi = lo + length
            for q in range(1, 10):
                for b in range(q):
                    count = count_interval(lo, hi, q, b)
                    brute = sum(x % q == b for x in
                                range(ceil_fraction(lo), ceil_fraction(hi)))
                    require(count == brute, "interval lattice count")
                    error = abs(count - length / q)
                    require(error <= 2, "uniform endpoint error")
                    maximum_count_error = max(maximum_count_error, error)
                    counts += 1
    for K in range(1, 10):
        for t in range(1, 12):
            g, p, q = bezout(K, t)
            if g != 1:
                continue
            require(p * K + q * t == 1, "Bezout identity")
            for b in range(t):
                for u in range(K):
                    a = p * (b - u)
                    require((u + K * a - b) % t == 0, "CRT representative")
                    for y in range(-8, 9):
                        require(((u + K * y - b) % t == 0) == ((y - a) % t == 0),
                                "CRT did not preserve the removed step")
                        residues += 1
    m_coefficients = [add(binomial_polynomial(3), [7]),
                      add(binomial_polynomial(2), [-5]), [F(11)]]
    for z in range(10):
        f = [evaluate(p, z) for p in m_coefficients]
        require(all(a.denominator == 1 for a in f), "noninteger spatial fiber")
        for K in range(2, 8):
            for u in range(K):
                for y in range(-2, 3):
                    difference = evaluate(f, u + K * y) - evaluate(f, u)
                    require(difference.denominator == 1 and difference.numerator % K == 0,
                            "integer spatial polynomial residue splitting")
                    fibers += 1
    return {"interval_count_cases": counts, "maximum_count_error": str(maximum_count_error),
            "CRT_membership_cases": residues, "integer_spatial_fiber_cases": fibers}


def sp_add(*polys):
    out = {}
    for p in polys:
        for monomial, coefficient in p.items():
            out[monomial] = out.get(monomial, F(0)) + coefficient
    return {m: c for m, c in out.items() if c}


def sp_scale(p, c):
    return {m: c * a for m, a in p.items() if c * a}


def sp_mul(p, q):
    out = {}
    for a, ca in p.items():
        for b, cb in q.items():
            monomial = tuple(x + y for x, y in zip(a, b))
            out[monomial] = out.get(monomial, F(0)) + ca * cb
    return {m: c for m, c in out.items() if c}


def sp_variable(i):
    return {tuple(int(j == i) for j in range(4)): F(1)}


def symbolic_heisenberg(left, right):
    x, y, z = left
    X, Y, Z = right
    return (sp_add(x, X), sp_add(y, Y),
            sp_add(z, Z, sp_scale(sp_add(sp_mul(x, Y), sp_scale(sp_mul(y, X), -1)),
                                 F(1, 2))))


def heisenberg(left, right):
    x, y, z = left
    X, Y, Z = right
    return x + X, y + Y, z + Z + (x * Y - y * X) / 2


def noncommutative_audit():
    a, m, y, z = [sp_variable(i) for i in range(4)]
    zero = {}
    P = (sp_scale(sp_add(a, m), F(1, 2)), y, z)
    left = (sp_scale(a, F(-1, 2)), zero, zero)
    right = (sp_scale(m, F(-1, 2)), zero, zero)
    Q = symbolic_heisenberg(symbolic_heisenberg(left, P), right)
    expected_center = sp_add(z, sp_scale(sp_mul(sp_add(m, sp_scale(a, -1)), y), F(1, 4)))
    require(Q == (zero, y, expected_center), "noncommutative kernel polynomial")
    recovered = symbolic_heisenberg(
        symbolic_heisenberg((sp_scale(a, F(1, 2)), zero, zero), Q),
        (sp_scale(m, F(1, 2)), zero, zero))
    require(recovered == P, "kernel factor order")
    wrong = symbolic_heisenberg(symbolic_heisenberg(right, left), P)
    require(wrong != Q, "orientation negative control lost noncommutativity")
    difference = sp_add(wrong[2], sp_scale(Q[2], -1))
    require(difference == sp_scale(sp_mul(m, y), F(-1, 2)), "orientation defect sign")
    degree = max(sum(exponent) for coordinate in Q for exponent in coordinate)
    require(degree == 2, "step-two degree bound")

    lattices = []
    conjugacy_cases = 0
    for j in range(2):
        sigma = (F(j, 2), F(0), F(0))
        inverse = tuple(-x for x in sigma)
        for n in range(-2, 3):
            for k in range(-2, 3):
                h = (F(0), F(n), F(k))
                conjugate = heisenberg(heisenberg(sigma, h), inverse)
                require(conjugate == (F(0), F(n), F(k) + F(j * n, 2)),
                        "conjugate kernel lattice")
                conjugacy_cases += 1
        basis = [(F(1), F(j, 2)), (F(0), F(1))]
        determinant = basis[0][0] * basis[1][1] - basis[0][1] * basis[1][0]
        require(determinant == 1, "kernel lattice covolume")
        lattices.append({"j": j, "basis_y_z": [list(map(str, row)) for row in basis],
                         "determinant": str(determinant)})
    return {
        "group": "step-two Heisenberg group in exponential coordinates",
        "character": "2*x", "V": ["1/2", "0", "0"], "K": 2,
        "kernel_logarithm": ["0", "Y", "Z+(m-a)*Y/4"],
        "kernel_total_degree": degree,
        "incorrect_two_left_factors_defect": "-m*Y/2",
        "quotient_lattices": lattices, "lattice_conjugacy_cases": conjugacy_cases,
        "scope": "symbolic identity in four independent variables; finite lattice example",
    }


def constant_coefficient_audit():
    cases = 0
    for q in range(7):
        H = 2 * q + 4
        N = H - 1
        integer_part = scale(binomial_polynomial(q), 10 ** (q + 1))
        delta = F(1, 2 ** (q + 3))
        theta = add(integer_part, [F(3, 8)],
                    scale(power([0, F(1, N)], q), delta / 2))
        floors = [evaluate(theta, z).numerator // evaluate(theta, z).denominator
                  for z in range(H)]
        fractions = [evaluate(theta, z) - floors[z] for z in range(H)]
        require(all(F(3, 8) <= x < F(3, 8) + delta for x in fractions),
                "fractional-part color interval")
        differences = floors[:]
        for _ in range(q + 1):
            differences = [b - a for a, b in zip(differences, differences[1:])]
        require(all(x == 0 for x in differences), "integer floor differences")
        polynomial = lagrange(list(map(F, range(q + 1))), list(map(F, floors[:q + 1])))
        require(all(evaluate(polynomial, z) == floors[z] for z in range(H)),
                "floor polynomial reconstruction")
        require(all((factorial(q) * a).denominator == 1 for a in polynomial),
                "Newton denominator bound")
        cases += 1
    return {"floor_polynomial_cases": cases, "degree_range": [0, 6]}


def exponent_audit():
    cases = 0
    largest_exponent = None
    for n in range(1, 6):
        for s in range(1, n + 1):
            for D in range(1, 5):
                Q = D * s ** (n - 1)
                A = 2 * Q + 2
                if n >= 2:
                    require(2 * (s * D) * s ** (n - 2) + 2 == A, "descent exponent")
                for j in range(n):
                    q = D * s ** j
                    require(q <= Q, "degree growth")
                    for e in range(1, q + 1):
                        exponent = 2 * q + e - A * e
                        require(exponent <= -1, "root exactness fails at polynomial scale")
                        largest_exponent = (exponent if largest_exponent is None
                                            else max(largest_exponent, exponent))
                        cases += 1
    return {"degree_exponent_cases": cases, "largest_root_bound_exponent": largest_exponent,
            "formula": "A=2*D*s^(n-1)+2"}


def compute_certificate():
    example = interpolation_case(3, 1, 10, 11, 23100, 23101, 2310, 23100 ** 10)
    interpolation_cases = []
    W = prod(primes(17))
    for q in range(1, 7):
        for e in range(1, q + 1):
            for H in (2 * q + 2, 2 * q + 3):
                S = (H + 1) * W
                interpolation_cases.append(interpolation_case(q, e, H, 17, S, S + 1, W))
    require(F(13) * F(1, 13) == 1 and F(1, 13).denominator != 1,
            "denominator negative control construction")
    require(not smooth(13, 11) and gcd(13, 13) != 1,
            "coprimality hypotheses must reject the denominator negative control")
    return {
        "certificate_type": "exact_algebra_and_finite_audit",
        "analytic_claim": "RS_VERIFY",
        "analytic_proof": "report.md, Theorems 1 and 2",
        "formal_claim": "RS_EXACT_ALGEBRA",
        "formal_source": "Main.lean",
        "scope_limit": "This replay does not mechanically prove equidistribution or the asymptotic theorem.",
        "example_with_nonzero_interpolation_error": example,
        "jacobian": jacobian_replay(example),
        "lagrange_bounds": lagrange_audit(),
        "interpolation_audit": {
            "cases": len(interpolation_cases),
            "q_range": [1, 6], "all_e_from_1_to_q": True,
            "largest_scaled_error": str(max(F(x["maximum_scaled_error"])
                                            for x in interpolation_cases)),
            "largest_root_exactness_bound": str(max(F(x["root_exactness_bound"])
                                                   for x in interpolation_cases)),
            "nonzero_jet_negative_controls": len(interpolation_cases) + 1,
            "rough_denominator_negative_control": {"t": 13, "M": "1/13", "coprime": False},
        },
        "residues_and_weights": residue_and_count_audit(),
        "constant_coefficient": constant_coefficient_audit(),
        "noncommutative_kernel": noncommutative_audit(),
        "finite_power_bookkeeping": exponent_audit(),
        "external_inputs_not_mechanically_proved": [
            "arxiv:1311.6170v3, corrected Theorem 8.6, equal sides only",
            "doi:10.1007/s00039-001-0332-9, Theorem 1.2",
            "arxiv:0709.3562v4, Definition 2.1 Remarks, Proposition A.10, Lemmas A.2-A.3",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = compute_certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(actual == expected, "certificate differs from recomputed mathematics")
    print(json.dumps({
        "exact_replay": "passed",
        "interpolation_cases": actual["interpolation_audit"]["cases"] + 1,
        "lagrange_cases": actual["lagrange_bounds"]["cases"],
        "CRT_membership_cases": actual["residues_and_weights"]["CRT_membership_cases"],
        "scope": actual["scope_limit"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
