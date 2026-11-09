#!/usr/bin/env python3
"""Exact replay for theorem.md; finite tests do not replace its uniform proof."""

import argparse
import itertools
import json
from fractions import Fraction as F
from math import isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def power(p, n):
    return F(p**n) if n >= 0 else F(1, p**(-n))


def vp(x, p):
    x = F(x)
    if not x:
        return None
    result = 0
    a, b = abs(x.numerator), x.denominator
    while a % p == 0:
        result += 1
        a //= p
    while b % p == 0:
        result -= 1
        b //= p
    return result


def minimum_valuation(values, p):
    vals = [v for x in values if (v := vp(x, p)) is not None]
    return min(vals) if vals else None


def integral(values, p):
    v = minimum_valuation(values, p)
    return v is None or v >= 0


def eye(n):
    return [[F(i == j) for j in range(n)] for i in range(n)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def matmul(a, b):
    return [[sum(x * y for x, y in zip(row, col))
             for col in zip(*b)] for row in a]


def matvec(a, x):
    return [sum(t * s for t, s in zip(row, x)) for row in a]


def scale(a, s):
    return [[s * x for x in row] for row in a]


def entries(a):
    return [x for row in a for x in row]


def determinant(a):
    n = len(a)
    total = F(0)
    for perm in itertools.permutations(range(n)):
        inversions = sum(perm[i] > perm[j]
                         for i in range(n) for j in range(i + 1, n))
        term = F((-1)**inversions)
        for i in range(n):
            term *= a[i][perm[i]]
        total += term
    return total


def inverse(a):
    n = len(a)
    b = [[F(x) for x in row] + unit for row, unit in zip(a, eye(n))]
    for j in range(n):
        pivot = next((i for i in range(j, n) if b[i][j]), None)
        require(pivot is not None, "singular matrix passed to inverse")
        b[j], b[pivot] = b[pivot], b[j]
        pivot_value = b[j][j]
        b[j] = [x / pivot_value for x in b[j]]
        for i in range(n):
            if i != j:
                ratio = b[i][j]
                b[i] = [x - ratio * y for x, y in zip(b[i], b[j])]
    return [row[n:] for row in b]


def matrix_power(a, n):
    require(n >= 0, "matrix_power needs a nonnegative exponent")
    result = eye(len(a))
    while n:
        if n % 2:
            result = matmul(result, a)
        a = matmul(a, a)
        n //= 2
    return result


def smith_exponents(a, p):
    n = len(a)
    previous = 0
    result = []
    for k in range(1, n + 1):
        minors = []
        for rows in itertools.combinations(range(n), k):
            for cols in itertools.combinations(range(n), k):
                minors.append(determinant([[a[i][j] for j in cols]
                                           for i in rows]))
        value = minimum_valuation(minors, p)
        if value is None:
            break
        result.append(value - previous)
        previous = value
    return result


def mass_from_exponents(exponents, p):
    return power(p, -sum(max(0, -a) for a in exponents))


def mass(a, p):
    return mass_from_exponents(smith_exponents(a, p), p)


def irreducible_polynomial(p, degree):
    for b in range(1, p):
        for a in range(p):
            if all((x**degree + a * x + b) % p for x in range(p)):
                return [b, a] + [0] * (degree - 2) + [1]
    raise AssertionError(f"no irreducible polynomial found: p={p}, d={degree}")


class CubicAlgebra:
    def __init__(self, p, name, factors):
        self.p, self.name, self.factors = p, name, factors
        require(sum(len(poly) - 1 for poly, _ in factors) == 3,
                "algebra must have dimension three")
        self.unit = []
        for poly, _ in factors:
            self.unit += [F(1)] + [F(0)] * (len(poly) - 2)
        self.basis = eye(3)
        self.multipliers = [self.multiply_matrix(v) for v in self.basis]
        self.gram = [[sum(matmul(a, b)[i][i] for i in range(3))
                      for b in self.multipliers] for a in self.multipliers]
        self.dual = inverse(self.gram)
        expected_disc = 0
        for poly, ramified in factors:
            degree = len(poly) - 1
            if ramified:
                expected_disc += degree * vp(degree, p) + degree - 1
            elif degree > 1:
                require(all(sum(c * x**i for i, c in enumerate(poly)) % p
                            for x in range(p)), "reducible control polynomial")
        require(vp(determinant(self.gram), p) == expected_disc,
                f"trace different mismatch in {p}:{name}")
        for a in self.multipliers:
            ga = matmul(self.gram, a)
            require(ga == transpose(ga), "action is not trace self-adjoint")

    def multiply(self, a, b):
        result = []
        offset = 0
        for poly, _ in self.factors:
            degree = len(poly) - 1
            c = [F(0)] * (2 * degree - 1)
            for i in range(degree):
                for j in range(degree):
                    c[i + j] += a[offset + i] * b[offset + j]
            for i in range(2 * degree - 2, degree - 1, -1):
                value = c[i]
                for j in range(degree):
                    c[i - degree + j] -= value * poly[j]
            result.extend(c[:degree])
            offset += degree
        return result

    def multiply_matrix(self, a):
        return transpose([self.multiply(a, b) for b in eye(3)])

    def valuations(self, a):
        vals = []
        offset = 0
        for poly, ramified in self.factors:
            degree = len(poly) - 1
            values = []
            for i in range(degree):
                v = vp(a[offset + i], self.p)
                if v is not None:
                    values.append(degree * v + i if ramified else v)
            vals.append(min(values) if values else None)
            offset += degree
        return vals

    def ideal(self, profile):
        a = [[F(0) for _ in range(3)] for _ in range(3)]
        offset = 0
        for (poly, ramified), h in zip(self.factors, profile):
            degree = len(poly) - 1
            uniformizer = [F(0)] * 3
            uniformizer[offset + (1 if ramified else 0)] = (
                F(1) if ramified else F(self.p))
            block = self.multiply_matrix(uniformizer)
            local = [row[offset:offset + degree]
                     for row in block[offset:offset + degree]]
            if h < 0:
                local = inverse(local)
            local = matrix_power(local, abs(h))
            for i in range(degree):
                for j in range(degree):
                    a[offset + i][offset + j] = local[i][j]
            offset += degree
        return a

    def norm_ideal(self, profile):
        exponent = sum(h * (1 if ramified else len(poly) - 1)
                       for (poly, ramified), h in zip(self.factors, profile))
        return self.p**exponent

    def in_shell(self, a, profile):
        return all((v is None or v >= 0) if h == 0 else v == -h
                   for v, h in zip(self.valuations(a), profile))


def algebras(p):
    q = ([0, 1], False)
    r2 = ([-p, 0, 1], True)
    r3 = ([-p, 0, 0, 1], True)
    result = [CubicAlgebra(p, "totally_ramified_cubic", [r3]),
              CubicAlgebra(p, "ramified_quadratic_times_scalar", [r2, q])]
    if p <= 3:
        result += [CubicAlgebra(p, "split", [q, q, q]),
                   CubicAlgebra(p, "unramified_cubic",
                                [(irreducible_polynomial(p, 3), False)]),
                   CubicAlgebra(p, "unramified_quadratic_times_scalar",
                                [(irreducible_polynomial(p, 2), False), q])]
    return result


def profiles(rank, m):
    result = [tuple([h] * rank) for h in (0, 1, 2, m, m + 1)]
    for i in range(rank):
        for h in (1, 2, m + 1):
            result.append(tuple(h if j == i else 0 for j in range(rank)))
    return list(dict.fromkeys(result))


def conductor_lattice(algebra, m):
    t = eye(3)
    for i in range(3):
        t[i][0] = algebra.unit[i]
    for j in (1, 2):
        for i in range(3):
            t[i][j] *= algebra.p**m
    ti = inverse(t)
    n = matmul(algebra.dual, transpose(ti))
    require(matmul(matmul(transpose(t), algebra.gram), n) == eye(3),
            "L=M plus trace-dual(M) is not self-dual")
    require(integral(matvec(ti, algebra.unit), algebra.p),
            "conductor lattice does not contain 1")
    for b in transpose(t):
        mb = matmul(matmul(ti, algebra.multiply_matrix(b)), t)
        require(integral(entries(mb), algebra.p), "conductor lattice is not a ring")
    return t, ti


def direct_kernel_mass(a, p):
    v = minimum_valuation(entries(a), p)
    depth = max(0, -v) if v is not None else 0
    modulus = p**depth
    require(modulus**3 <= 4096, "direct finite kernel replay is out of bounds")
    count = sum(integral(matvec(a, x), p)
                for x in itertools.product(range(modulus), repeat=3))
    return F(count, modulus**3)


def ramified_replay():
    result = []
    for p in (2, 3, 5, 7):
        for algebra in algebras(p):
            tested = period_tests = direct_tests = 0
            largest_g = largest_c = 0
            for m in (0, 1, 2, 6, 12):
                t, ti = conductor_lattice(algebra, m)
                raw_rows = list(itertools.product(range(p), repeat=3))
                if p > 3:
                    raw_rows = raw_rows[:8] + raw_rows[-2:]
                rows = [list(map(F, row)) for row in raw_rows]
                for r in sorted({1, max(1, m - 1), max(1, m)}):
                    for j in range(3):
                        rows.append([x + (p**r if i == j else 0)
                                     for i, x in enumerate(algebra.unit)])
                rows = list(dict.fromkeys(tuple(row) for row in rows))
                direct_done = False
                for profile in profiles(len(algebra.factors), m):
                    ideal = algebra.ideal(profile)
                    ideal_inverse = inverse(ideal)
                    hnorm = algebra.norm_ideal(profile)
                    require(power(p, vp(determinant(ideal), p)) == hnorm,
                            "ideal norm ignored ramification or residue degree")
                    exponents = smith_exponents(matmul(ti, ideal), p)
                    g = sum(max(0, -a) for a in exponents)
                    c = max([0] + [-a for a in exponents])
                    require(c <= g and (c == 0) == (g == 0), "invalid c,g")
                    largest_g, largest_c = max(largest_g, g), max(largest_c, c)
                    if p == 2:
                        n = max(c + 3, 4)
                        period = scale(ideal_inverse, power(p, n))
                        require(n <= 4 * (g + 1), "dyadic support comparison failed")
                    elif c:
                        period = scale(ideal_inverse, power(p, c))
                        require(c <= 4 * (g + 1), "odd support comparison failed")
                    else:
                        period = algebra.ideal(tuple(1 - h if h else 0
                                                      for h in profile))
                    for raw in rows:
                        a = matvec(ideal_inverse, raw)
                        if not algebra.in_shell(a, profile):
                            continue
                        context = f"p={p}, {algebra.name}, m={m}, h={profile}, A={a}"
                        action = matmul(matmul(ti, algebra.multiply_matrix(a)), t)
                        gamma = mass(action, p)
                        iota = int(p <= 5)
                        shift = None
                        for s in range(4):
                            alpha = [x + s * y for x, y in zip(a, algebra.unit)]
                            vals = algebra.valuations(alpha)
                            valid = True
                            for v, h, (poly, ramified) in zip(
                                    vals, profile, algebra.factors):
                                e = len(poly) - 1 if ramified else 1
                                valid &= (v == -h if h else
                                          v is not None and 0 <= v <= e * iota)
                            if valid:
                                shift = alpha
                                break
                        require(shift is not None, "no literal scalar shift: " + context)
                        shifted = matmul(matmul(
                            ti, algebra.multiply_matrix(shift)), t)
                        reciprocal = inverse(shifted)
                        j = max(0, -minimum_valuation(entries(reciprocal), p))
                        norm_abs = power(p, -vp(determinant(shifted), p))
                        require(power(p, -3 * iota) * hnorm <= norm_abs <= hnorm,
                                "literal shift norm bounds violated: " + context)
                        require(j <= c + iota <= g + iota,
                                "inverse stabilizer denominator bound violated: " + context)
                        require(gamma == mass(reciprocal, p) / norm_abs,
                                "reciprocal quadratic identity violated: " + context)
                        bound_squared = power(p, 6 * iota - j) / hnorm**2
                        require(gamma**2 <= bound_squared,
                                "literal coefficient decay violated: " + context)
                        if p % 2:
                            require(gamma <= F(1, hnorm),
                                    "improved odd norm bound violated: " + context)
                        for delta in transpose(period):
                            translated = [x + y for x, y in zip(a, delta)]
                            require(algebra.in_shell(translated, profile),
                                    "support period did not preserve shell: " + context)
                            translated_action = matmul(matmul(
                                ti, algebra.multiply_matrix(translated)), t)
                            require(mass(translated_action, p) == gamma,
                                    "improved period violated: " + context)
                            period_tests += 1
                        v = minimum_valuation(entries(action), p)
                        denominator = max(0, -v) if v is not None else 0
                        if (not direct_done and m <= 1 and denominator > 0
                                and p**(3 * denominator) <= 4096):
                            require(direct_kernel_mass(action, p) == gamma,
                                    "Smith mass disagrees with direct enumeration")
                            direct_tests += 1
                            direct_done = True
                        tested += 1
            result.append({
                "prime": p,
                "algebra": algebra.name,
                "factor_polynomials_low_to_high": [poly for poly, _ in algebra.factors],
                "trace_discriminant_valuation": vp(determinant(algebra.gram), p),
                "lattice_depths": [0, 1, 2, 6, 12],
                "frequency_tests": tested,
                "reciprocal_identity_tests": tested,
                "shift_norm_and_denominator_tests": tested,
                "improved_period_tests": period_tests,
                "direct_finite_kernel_counts": direct_tests,
                "maximum_g": largest_g,
                "maximum_c": largest_c,
            })
    return result


def cyclotomic_remainder(coefficients, p, c):
    modulus = p**c
    require(len(coefficients) == modulus, "character polynomial has wrong size")
    stride = p**(c - 1)
    degree = (p - 1) * stride
    a = [F(x) for x in coefficients]
    for i in range(modulus - 1, degree - 1, -1):
        coefficient = a[i]
        for j in range(p):
            a[i - degree + j * stride] -= coefficient
    require(not any(a[degree:]), "cyclotomic division was not exact")
    return a[:degree]


def sharp_finite_fourier(p, c):
    modulus = p**c
    units = [a for a in range(modulus) if a % p]
    coefficients = [F(0)] * modulus
    for a in units:
        for b in units:
            difference = (a - b) % modulus
            w = vp(difference, p)
            weight = power(p, -max(0, c - w)) if w is not None else F(1)
            coefficients[(-difference) % modulus] += weight / modulus**2
    remainder = cyclotomic_remainder(coefficients, p, c)
    expected = (1 - F(1, p))**2 * power(p, -c)
    require(remainder == [expected] + [F(0)] * (len(remainder) - 1),
            f"sharp exact Fourier value failed at p={p}, c={c}")
    return {"prime": p, "c": c, "unit_pairs": len(units)**2,
            "kernel_value": str(expected),
            "cyclotomic_remainder": [str(x) for x in remainder]}


def sharp_family(p, k, c):
    require(p >= 2 and k >= 1 and c >= 2, "family requires p>=2, k>=1, c>=2")
    require(all(p % d for d in range(2, isqrt(p) + 1)), "p must be prime")
    m = k + c
    t = [[F(1), F(0), F(0)],
         [F(1), power(p, m), F(0)],
         [F(0), F(0), F(1)]]
    ti = inverse(t)
    ideal = [[power(p, k), F(0), F(0)],
             [F(0), power(p, k), F(0)],
             [F(0), F(0), F(1)]]
    elementary = smith_exponents(matmul(ti, ideal), p)
    require(sum(max(0, -a) for a in elementary) == c,
            "sharp family order quotient has wrong cardinality")
    require(max([0] + [-a for a in elementary]) == c,
            "sharp family order quotient has wrong exponent")
    gamma_tests = 0
    for w in [None] + list(range(0 if p > 2 else 1, m + 2)):
        a = F(1)
        b = a if w is None else a + power(p, w)
        frequency = [power(p, -k) * a, power(p, -k) * b, F(0)]
        action = matmul(matmul(ti, [[frequency[i] if i == j else F(0)
                                    for j in range(3)] for i in range(3)]), t)
        expected = power(p, -2 * k)
        if w is not None:
            expected *= power(p, -max(0, c - w))
        require(mass(action, p) == expected, "sharp family Gaussian formula failed")
        gamma_tests += 1
    value = (1 - F(1, p))**2 * power(p, -c)
    require(value > 0, "sharpness kernel value must be positive")
    return {"prime": p, "k": k, "c": c, "m": m, "g": c,
            "gamma_identity_tests": gamma_tests,
            "nonzero_output": [str(power(p, k - c)), str(-power(p, k - c)), "1"],
            "kernel_value_by_uniform_formula": str(value),
            "first_two_output_valuations": [k - c, k - c],
            "excluded_smaller_support_minimum": k - c + 1}


def jacobian_replay():
    payload = json.loads((HERE / "jacobian/ramanujan_payload.json").read_text())
    record = json.loads((HERE / "jacobian/ramanujan_result.json").read_text())
    operation = "finite_abelian_group.spectral_pair.decide"
    require(record["request"]["operation_id"] == operation, "wrong Jacobian operation")
    require(record["request"]["payload"] == payload, "Jacobian payload mismatch")
    output = record["result"]["output"]
    require(output["source"] == payload["source"], "Jacobian output source mismatch")
    witness = output["first_nonorthogonal_pair"]
    require(output["reason"] == "NONORTHOGONAL_FREQUENCIES"
            and not output["is_spectral"], "unexpected typed Jacobian result")
    coefficients = [F(0)] * 9
    difference = witness["difference"][0]
    for point in payload["source"]["points"]:
        coefficients[(difference * point[0]) % 9] += 1
    remainder = cyclotomic_remainder(coefficients, 3, 2)
    expected = [F(-3)] + [F(0)] * 5
    require(remainder == expected, "independent residue-character replay failed")
    require(list(map(F, witness["remainder_coefficients"])) == expected,
            "typed Jacobian remainder disagrees with exact replay")
    return {"operation_id": operation, "server_version": record["server"]["version"],
            "protocol_version": record["protocol_version"], "adapter_status": "success",
            "adapter_error": None, "timeout": False,
            "exact_character_sum": "-3",
            "scope": "One Ramanujan boundary sum, not a p-adic theorem verdict."}


def certificate():
    finite = [sharp_finite_fourier(p, c) for p, c in
              ((2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (5, 2), (7, 2))]
    families = [sharp_family(p, k, c)
                for p in (2, 3, 5, 7) for k in (1, 2, 7) for c in (2, 3, 12, 25)]
    return {
        "format": "quartic-shell-exact-certificate-v1",
        "mathematical_result": "Uniform verification and stronger sharp conductor support",
        "result_class": "improved_bound",
        "independent_review_status": "pending",
        "novelty_status": "pending_independent_assessment",
        "uniform_proof": "theorem.md, Sections 2-7; mathematical proof, not Lean evidence",
        "literal_manuscript_assertion_refuted": None,
        "proved_support": {"odd_c_positive": "p^(-c) h d^(-1)",
                           "odd_c_zero": "componentwise one-step boundary support",
                           "dyadic": "2^(-max(c+3,4)) h d^(-1)"},
        "profile_improvement": {"old_G0_exponent": 24, "new_G0_exponent": 3,
                               "new_exponent_parameter": "G_exp=product p^c",
                               "constant_new_boundary_convention": 2**12,
                               "constant_original_boundary_convention": 2**12 * 3**3 * 5**3},
        "finite_test_scope": "Hyperbolic E-spaces only; all-case coverage is by the proof.",
        "jacobian": jacobian_replay(),
        "ramified_lattice_tests": ramified_replay(),
        "sharp_finite_fourier": finite,
        "deep_sharp_family": families,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--family", nargs=3, type=int, metavar=("P", "K", "C"))
    args = parser.parse_args()
    if args.family is not None:
        print(json.dumps(sharp_family(*args.family), indent=2))
        return
    expected = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(expected, indent=2) + "\n")
    recorded = json.loads(path.read_text())
    require(recorded == expected, "exact_certificate.json does not match recomputed evidence")
    rows = expected["ramified_lattice_tests"]
    print(json.dumps({
        "status": "PASS",
        "frequency_tests": sum(row["frequency_tests"] for row in rows),
        "improved_period_tests": sum(row["improved_period_tests"] for row in rows),
        "direct_finite_kernel_counts": sum(row["direct_finite_kernel_counts"] for row in rows),
        "sharp_finite_fourier_instances": len(expected["sharp_finite_fourier"]),
        "deep_sharp_family_instances": len(expected["deep_sharp_family"]),
        "uniform_proof": expected["uniform_proof"],
        "independent_review": "not performed by this script",
    }, indent=2))


if __name__ == "__main__":
    main()
