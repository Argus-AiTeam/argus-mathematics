#!/usr/bin/env python3
"""Replay a universal symbolic certificate and exact arithmetic regressions."""

import json
from fractions import Fraction as F
from math import gcd
from pathlib import Path
from time import perf_counter

import sympy as sp


ROOT = Path(__file__).resolve().parent
VERTICES = ((F(1), F(0)), (F(0), F(-1)), (F(-1), F(0)), (F(0), F(1)))
PREFIX = ((F(0), F(0)), (F(1, 8), F(-1, 8)),
          (F(0), F(-1, 4)), (F(-1, 8), F(-1, 8)))
UVAR = sp.Symbol("u")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def floor(value):
    return value.numerator // value.denominator


def ceil(value):
    return -floor(-value)


def rational(value):
    value = sp.Rational(value)
    return F(int(value.p), int(value.q))


def symbolic(value):
    return sp.Rational(value.numerator, value.denominator)


def cadd(left, right):
    return tuple(left[i] + right[i] for i in range(2))


def cscale(value, scalar):
    return tuple(scalar * coordinate for coordinate in value)


def cmul(left, right):
    return (left[0] * right[0] - left[1] * right[1],
            left[0] * right[1] + left[1] * right[0])


def phase(value):
    q = floor(4 * value)
    t = 4 * value - q
    return tuple((1 - t) * VERTICES[q % 4][i] +
                 t * VERTICES[(q + 1) % 4][i] for i in range(2))


def primitive(value):
    q = floor(4 * value)
    t = 4 * value - q
    return tuple(PREFIX[q % 4][i] + VERTICES[q % 4][i] * t / 4 +
                 (VERTICES[(q + 1) % 4][i] - VERTICES[q % 4][i]) * t * t / 8
                 for i in range(2))


def phase_polynomial(argument, q):
    t = 4 * argument - q
    return tuple((1 - t) * symbolic(VERTICES[q % 4][i]) +
                 t * symbolic(VERTICES[(q + 1) % 4][i]) for i in range(2))


def primitive_polynomial(argument, q):
    t = 4 * argument - q
    return tuple(symbolic(PREFIX[q % 4][i]) +
                 symbolic(VERTICES[q % 4][i]) * t / 4 +
                 symbolic(VERTICES[(q + 1) % 4][i] - VERTICES[q % 4][i])
                 * t * t / 8 for i in range(2))


def parameters(n, d, j):
    require(n >= 128, "The original manuscript requires n >= 128")
    B = 1 << n
    require(1 <= d < B and 0 <= j < d and gcd(j, d) == 1, "Invalid reduced label")
    Q = B ** 16
    k = (2 * j * Q + d) // (2 * d)
    eta = F(k * d - j * Q, d)
    require(abs(eta) <= F(1, 2), "Rounded-bin relation failed")
    require(0 <= k < Q, "Bin outside data register")
    return B, Q, k, eta


def recover_label(B, Q, k):
    require(0 <= k < Q, "Invalid observed bin")
    numerator, denominator = k, Q
    old_p, old_v, p, v = 0, 1, 1, 0
    last = None
    while denominator:
        quotient, remainder = divmod(numerator, denominator)
        next_p, next_v = quotient * p + old_p, quotient * v + old_v
        if next_v >= B:
            break
        last = (next_v, next_p)
        old_p, old_v, p, v = p, v, next_p, next_v
        numerator, denominator = denominator, remainder
    if last is None:
        return None
    d, j = last
    if 0 <= j < d and (2 * j * Q + d) // (2 * d) == k:
        return d, j
    return None


def progression_amplitude(Q, d, j, k, t):
    require(0 <= t < d < Q, "Invalid progression")
    eta = F(k * d - j * Q, d)
    require(abs(eta) <= F(1, 2), "The bin must be rounded from jQ/d")
    count = (Q - 1 - t) // d + 1
    alpha = F((j * t) % d, d) + eta * F(t, Q)
    beta = eta * F(d, Q)
    if not beta:
        return cscale(phase(alpha), F(count, Q)), 1
    endpoints = (alpha, alpha + beta * (count - 1))
    low, high = min(endpoints), max(endpoints)
    cuts = {0, count}
    for q in range(floor(4 * low), floor(4 * high) + 2):
        cut = ceil((F(q, 4) - alpha) / beta)
        if 0 < cut < count:
            cuts.add(cut)
    cuts = sorted(cuts)
    total = (F(0), F(0))
    for lo, hi in zip(cuts, cuts[1:]):
        midpoint = alpha + beta * F(lo + hi - 1, 2)
        q = floor(4 * midpoint)
        size = hi - lo
        indices = F((lo + hi - 1) * size, 2)
        part = tuple(
            size * (VERTICES[q % 4][i] +
                    (VERTICES[(q + 1) % 4][i] - VERTICES[q % 4][i])
                    * (4 * alpha - q)) +
            (VERTICES[(q + 1) % 4][i] - VERTICES[q % 4][i]) * 4 * beta * indices
            for i in range(2)
        )
        total = cadd(total, part)
    require(len(cuts) - 1 <= 3, "Too many progression pieces")
    return cscale(total, F(1, Q)), len(cuts) - 1


def power_sums(M):
    require(M >= 0, "Negative power-sum endpoint")
    first = M * (M - 1) // 2
    return (M, first, M * (M - 1) * (2 * M - 1) // 6, first * first,
            M * (M - 1) * (2 * M - 1) * (3 * M * M - 3 * M - 1) // 30)


def evaluate(coefficients, argument):
    value = F(0)
    for coefficient in reversed(coefficients):
        value = value * argument + coefficient
    return value


def envelope(n, d, j):
    B, Q, _, eta = parameters(n, d, j)
    boundaries = {F(0), F(d)}
    for q in range(-2, 7):
        for value in (F(d * q, 4), d * (F(q, 4) - eta)):
            if 0 < value < d:
                boundaries.add(value)
    boundaries = sorted(boundaries)
    D = Q * B ** 8
    pieces = []
    total = F(0)
    covered = 0
    for left, right in zip(boundaries, boundaries[1:]):
        midpoint = (left + right) / 2
        q0 = floor(4 * midpoint / d)
        if eta:
            q1 = floor(4 * (midpoint / d + eta))
            G0 = primitive_polynomial(UVAR / d, q0)
            G1 = primitive_polynomial(UVAR / d + symbolic(eta), q1)
            integral = tuple((G1[i] - G0[i]) / (d * symbolic(eta))
                             for i in range(2))
        else:
            integral = tuple(value / d for value in phase_polynomial(UVAR / d, q0))
        polynomial = sp.Poly(sp.expand(sum(value ** 2 for value in integral)),
                             UVAR, domain=sp.QQ)
        require(polynomial.degree() <= 4, "Envelope degree exceeds four")
        raw = tuple(rational(polynomial.nth(q)) for q in range(5))
        rounded = tuple(F(ceil(D * value), D) for value in raw)
        lo, hi = max(0, ceil(left)), min(d, ceil(right))
        require(lo == covered, "Integer boundary ownership is inconsistent")
        covered = hi
        lower_sums, upper_sums = power_sums(lo), power_sums(hi)
        total += sum(rounded[q] * (upper_sums[q] - lower_sums[q]) for q in range(5))
        total += F(64, Q) * (hi - lo)
        pieces.append((left, right, raw, rounded))
    require(covered == d and len(pieces) <= 8, "Incomplete or excessive envelope pieces")
    return pieces, total / 2


def envelope_value(pieces, u, Q):
    for left, right, _, rounded in pieces:
        if left <= u < right:
            return evaluate(rounded, u) + F(64, Q)
    raise ValueError("Residue not owned by an envelope piece")


def correction(n, d, S):
    require(S > 0, "Nonpositive majorant sum")
    lam = F(1, 1 << ((d - 1).bit_length() + 10))
    precision = 1 << (10 * n)
    c = F(floor(precision * lam / S), precision)
    rho = lam - c * S
    return lam, c, rho


def positive_expression(terms, bases):
    expression = 0
    for numerator, denominator, exponents in terms:
        require(numerator >= 0 and denominator > 0, "Invalid nonnegative coefficient")
        require(len(exponents) == len(bases) and all(e >= 0 for e in exponents),
                "Invalid nonnegative monomial")
        expression += sp.Rational(numerator, denominator) * sp.prod(
            base ** exponent for base, exponent in zip(bases, exponents))
    return expression


def verify_symbolic(certificate):
    require(certificate["domain"] == {
        "n_min": 128, "B": "2^n", "Q": "B^16", "d": "1 <= d < B",
        "j": "0 <= j < d and gcd(j,d)=1", "bin": "floor(j*Q/d+1/2)"
    }, "Certificate has changed the admissible domain")
    require(certificate["phase_vertices"] == [list(map(int, v)) for v in VERTICES],
            "Certificate has changed the phase orientation")
    require(certificate["constants"] == {
        "average_modulus_lower": [1, 2], "rectangle_amplitude_error": 6,
        "squared_mass_error": 32, "majorant_offset": 64,
        "majorant_error_lower": 32, "majorant_error_upper": 97,
        "manuscript_majorant_error_upper": 128,
        "rounding_denominator_B_exponent": 8, "coefficient_bits_per_n": 10,
        "lambda_offset": 10, "max_envelope_pieces": 8, "max_progression_pieces": 3
    }, "Certificate constants do not match the implementation")
    identities = 0

    def identity(expression, label):
        nonlocal identities
        require(sp.expand(expression) == 0, "False symbolic identity: " + label)
        identities += 1

    w, s, a, x, y = sp.symbols("w s a x y")
    for q in range(4):
        value = phase_polynomial((q + s) / 4, q)
        rotated = cmul(VERTICES[q], (1 - s, -s))
        G = primitive_polynomial(w, q)
        g = phase_polynomial(w, q)
        for i in range(2):
            identity(value[i] - rotated[i], "quarter-turn covariance")
            identity(sp.diff(G[i], w) - g[i], "primitive derivative")
            identity(G[i].subs(w, sp.Rational(q + 1, 4)) -
                     symbolic(PREFIX[(q + 1) % 4][i]), "primitive continuity")
    identity((1 - s) ** 2 + s ** 2 - (sp.Rational(1, 2) +
             2 * (s - sp.Rational(1, 2)) ** 2), "zero-length lower bound")
    identity(1 - ((1 - s) ** 2 + s ** 2) - 2 * s * (1 - s), "phase upper bound")

    def segment(q, lo, hi):
        values = phase_polynomial(w / 4, q)
        return tuple(sp.integrate(value, (w, lo, hi)) for value in values)

    R0, I0 = segment(0, s, s + a)
    sector0 = R0 ** 2 + I0 ** 2 - a ** 2 / 4
    squares = (a * (s + a / 2 - sp.Rational(1, 2)), a / 2)
    coefficients = certificate["sector_zero_square_coefficients"]
    require(len(coefficients) == 2 and all(p >= 0 and q > 0 for p, q in coefficients),
            "Invalid zero-sector SOS")
    identity(sector0 - sum(sp.Rational(*c) * t ** 2
                          for c, t in zip(coefficients, squares)), "zero sector SOS")
    R1, I1 = cadd(segment(0, 1 - x, 1), segment(1, 1, 1 + y))
    E = x * (1 - x) + y * (1 - y)
    identity(R1 ** 2 + I1 ** 2 - (x + y) ** 2 / 4 -
             positive_expression(certificate["sector_one_positive_terms"],
                                 (R1 ** 2, x + y, E)), "one-vertex sector")
    R2, I2 = cadd(cadd(segment(0, 1 - x, 1), segment(1, 1, 2)),
                 segment(2, 2, 2 + y))
    target2 = R2 ** 2 + I2 ** 2 - (1 + x + y) ** 2 / 4
    identity(target2 - positive_expression(certificate["sector_two_positive_terms"],
                                           (x, y, x + y, 1 - x - y)),
             "two-vertex sector")
    identity(target2.subs({x: 1, y: 0}), "sharpness")

    M = sp.Symbol("M")
    require(len(certificate["power_sum_coefficients"]) == 5, "Missing power sums")
    for q, coefficients in enumerate(certificate["power_sum_coefficients"]):
        polynomial = sum(sp.Rational(*coefficient) * M ** exponent
                         for exponent, coefficient in enumerate(coefficients))
        identity(polynomial.subs(M, 0), "power-sum initial value")
        identity(polynomial.subs(M, M + 1) - polynomial - M ** q,
                 "power-sum induction")

    h, v, t = sp.symbols("h v t")
    identity(6 * h - (2 * h * (1 + h) + 2 * h) - 2 * h * (1 - h),
             "rectangle-rule uniform bound")
    identity(32 - 6 * (2 * v + t) - (14 + 12 * (1 - v) + 6 * (1 - t)),
             "squared-mass error bound")
    B = sp.Symbol("B")
    positive_bounds = (
        B ** 8 - sum(B ** q for q in range(5)),
        3 * B ** 15 - 65,
        B ** 13 - 256,
        B ** 8 - 8,
        2 * B ** 16 - B ** 3,
    )
    for polynomial in positive_bounds:
        coefficients = sp.Poly(sp.expand(polynomial.subs(B, 2 + w)), w).all_coeffs()
        require(all(c >= 0 for c in coefficients) and coefficients[-1] > 0,
                "Failed universal bound for every B >= 2")
        identities += 1
    P, U, c, lam = sp.symbols("P U c lam")
    rho = lam - c * U / 2
    identity(c * P / 2 + c * (U - P) / 2 + rho - lam, "three-mode mass")
    identity(64 - 32 - 32, "majorant lower discrepancy")
    identity(64 + 32 + 1 - 97, "majorant upper discrepancy")
    require(97 <= 128 and F(1, 8) >= F(1, 128), "Manuscript bounds not implied")
    return identities


def verify_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    operation = "polynomial.sos.decomposition.check"
    require(status["exit_code"] == 0 and status["operation_id"] == operation,
            "Jacobian operation failed or was not completed")
    require(output["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian payload/output mismatch")
    result = output["result"]["output"]
    require(output["result"]["operation_id"] == operation and result["is_valid"],
            "Jacobian supplied no exact certificate")
    require(result["method"] == "EXACT_COEFFICIENT_IDENTITY", "Unexpected Jacobian method")
    a, z = sp.symbols("a z")

    def decode(polynomial):
        require(polynomial["variables"] == ["a", "z"] and polynomial["domain"] == "QQ",
                "Unexpected Jacobian coefficient ring")
        return sum(sp.Rational(int(term["coefficient"]["num"]),
                               int(term["coefficient"]["den"])) *
                   a ** term["exponents"][0] * z ** term["exponents"][1]
                   for term in polynomial["polynomial"]["terms"])

    target = (a * (1 - z) - a * a / 2) ** 2 + (-a * z - a * a / 2) ** 2 - a * a / 4
    require(sp.expand(decode(payload["polynomial"]) - target) == 0,
            "Jacobian target is not the zero-sector inequality")
    require(sp.expand(sum(decode(s) ** 2 for s in payload["summands"]) - target) == 0,
            "Independent replay of Jacobian SOS failed")
    require(result["polynomial"] == payload["polynomial"] and
            result["summands"] == payload["summands"], "Jacobian changed the request")
    require(sp.expand(decode(result["computed_sum"]) - target) == 0,
            "Jacobian computed sum does not match")
    return {"server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"], "operation_id": operation,
            "exit_code": status["exit_code"], "is_valid": True}


def finite_diagnostics():
    progression_replays = 0
    for Q in (4, 16, 64):
        for d in range(1, min(10, Q)):
            for j in range(d):
                if gcd(j, d) != 1:
                    continue
                k = (2 * j * Q + d) // (2 * d)
                for t in range(d):
                    actual, _ = progression_amplitude(Q, d, j, k, t)
                    direct = (F(0), F(0))
                    for x in range(t, Q, d):
                        direct = cadd(direct, phase(F(k * x, Q)))
                    require(actual == cscale(direct, F(1, Q)),
                            "Direct progression replay failed")
                    progression_replays += 1
    transform_entries = 0
    for b in (2, 3, 4, 5):
        Q = 1 << b
        for D in range(Q):
            direct = (F(0), F(0))
            for y in range(Q):
                initial = ((F(1), F(0)), (F(0), F(1)),
                           (F(-1), F(0)), (F(0), F(-1)))[4 * y // Q]
                final = ((F(1), F(0)), (F(0), F(1)),
                         (F(-1), F(0)), (F(0), F(-1)))[4 * ((y + D) % Q) // Q]
                direct = cadd(direct, cmul(initial, (final[0], -final[1])))
            require(cscale(direct, F(1, Q)) == phase(F(D, Q)),
                    "Forward-shift overlap has the wrong sign")
        for x in range(Q):
            for k in range(Q):
                h = sum(((x >> i) & 1) * ((k >> j) & 1)
                        for i in range(b) for j in range(b) if i + j == b - 1)
                D = sum((1 << (i + j)) * ((x >> i) & 1) * ((k >> j) & 1)
                        for i in range(b) for j in range(b) if i + j < b - 1)
                require((x * k - D - (Q // 2) * h) % Q == 0, "Bit-product identity")
                require(cscale(phase(F(D, Q)), (-1) ** h) == phase(F(x * k, Q)),
                        "Selected-branch transform mismatch")
                transform_entries += 1
    return progression_replays, transform_entries


def original_domain_replays():
    B = 1 << 128
    labels = [(128, 1, 0), (128, 2, 1), (128, 3, 1), (128, 3, 2),
              (128, 4, 1), (128, 5, 2), (128, 7, 1), (128, 7, 6),
              (128, 16, 15), (128, 17, 8), (128, B // 2, 1),
              (128, B - 1, (B - 2) // 2), (128, B - 1, B // 2),
              (128, B - 1, B - 2), (129, (1 << 129) - 1, 1),
              (256, (1 << 256) - 1, (1 << 255) - 1)]
    residues = 0
    max_pieces = 0
    max_progression_pieces = 0
    exact_small_sums = 0
    for n, d, j in labels:
        B, Q, k, eta = parameters(n, d, j)
        require(recover_label(B, Q, k) == (d, j), "Continued-fraction label recovery")
        for invalid in (Q // 2 - 1, Q // 2 + 1, Q - 1):
            require(recover_label(B, Q, invalid) is None, "Invalid bin was accepted")
        pieces, S = envelope(n, d, j)
        require(F(1, 8 * d) <= S <= 2, "Majorant sum bound failed")
        lam, c, rho = correction(n, d, S)
        require(0 <= c <= F(1, 8), "Invalid rounded coefficient")
        require(0 <= rho < F(2, 1 << (10 * n)), "Invalid correction remainder")
        require(0 <= 4 * B * B * rho <= 1, "Mode 3 is not a probability")
        require(c * S + rho == lam, "Exact corrected mass failed")
        max_pieces = max(max_pieces, len(pieces))
        test_u = {0, d // 2, d - 1}
        for left, _, _, _ in pieces:
            if left.denominator == 1 and 0 <= left < d:
                test_u.add(int(left))
        if d <= 17:
            test_u.update(range(d))
            require(sum(envelope_value(pieces, u, Q) for u in range(d)) / 2 == S,
                    "Small-residue sum disagrees with nonenumerative S")
            exact_small_sums += 1
        inverse = pow(j, -1, d) if d > 1 else 0
        for u in sorted(test_u):
            t = (inverse * u) % d
            amplitude, parts = progression_amplitude(Q, d, j, k, t)
            max_progression_pieces = max(max_progression_pieces, parts)
            P = sum(value * value for value in amplitude)
            if eta:
                integral = cscale(cadd(primitive(F(u, d) + eta),
                                      cscale(primitive(F(u, d)), -1)), 1 / (d * eta))
            else:
                integral = cscale(phase(F(u, d)), F(1, d))
            J = sum(value * value for value in integral)
            U = envelope_value(pieces, u, Q)
            require(abs(P - J) <= F(32, Q), "Rectangle estimate failed")
            require(F(32, Q) <= U - P <= F(97, Q), "Majorant discrepancy failed")
            require(0 <= 2 * B ** 3 * (U - P) * c <= 1, "Mode 2 is not a probability")
            for value in (P, U, S, c, rho):
                denominator = value.denominator
                require(denominator & (denominator - 1) == 0, "Nondyadic sampled value")
            for left, right, raw, rounded in pieces:
                if left <= u < right:
                    require(evaluate(raw, u) == J, "Primitive/envelope mismatch")
                    require(all(0 <= b - a < F(1, Q * B ** 8)
                                for a, b in zip(raw, rounded)), "Coefficient rounding")
            residues += 1
    return {"labels": len(labels), "residue_replays": residues,
            "small_exact_sum_replays": exact_small_sums, "max_envelope_pieces": max_pieces,
            "max_progression_pieces": max_progression_pieces,
            "largest_denominator_bits": max(d.bit_length() for _, d, _ in labels)}


def order_trial_replays():
    n = 128
    B = 1 << n
    cases = ((2, 1), (3, 2), (4, 3), (7, 3), (15, 2), (35, 2), (65, 2))
    numerators = 0
    for m, a in cases:
        r = 1
        while pow(a, r, m) != 1:
            r += 1
        total = F(0)
        phi = 0
        for j in range(r):
            if gcd(j, r) != 1:
                continue
            phi += 1
            _, Q, k, _ = parameters(n, r, j)
            pieces, S = envelope(n, r, j)
            lam, c, rho = correction(n, r, S)
            masses = []
            discrepancies = []
            for t in range(r):
                amplitude, _ = progression_amplitude(Q, r, j, k, t)
                P = sum(value * value for value in amplitude)
                U = envelope_value(pieces, (j * t) % r, Q)
                masses.append(P)
                discrepancies.append(2 * B ** 3 * (U - P) * c)
            mode1 = F(1, 2) * c * sum(masses)
            mode2 = F(1, 4) * F(1, B ** 3) * sum(discrepancies)
            mode3 = F(1, 4) * F(1, B ** 2) * (4 * B ** 2 * rho)
            require(mode1 + mode2 + mode3 == lam, "Three-mode true-numerator mass")
            total += mode1 + mode2 + mode3
            numerators += 1
        expected = phi * F(1, 1 << ((r - 1).bit_length() + 10))
        require(total == expected, "Exact true-order probability")
        for d in range(1, 2 * r + 2):
            require((pow(a, d, m) == 1) == (d % r == 0), "Candidate order-multiple test")
    return {"original_domain_inputs": len(cases), "true_numerators": numerators,
            "probability_identity": "phi(r)*2^(-ceil(log2(r))-10)"}


def main():
    start = perf_counter()
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    identities = verify_symbolic(certificate)
    jacobian = verify_jacobian()
    progressions, transform_entries = finite_diagnostics()
    original = original_domain_replays()
    trial = order_trial_replays()
    print(json.dumps({
        "ok": True,
        "universal_certificate": {
            "kind": certificate["certificate_kind"], "symbolic_checks": identities,
            "sharp_phase_average_lower_bound": "1/2",
            "sharpened_S_lower_bound": "1/(8d)",
            "all_B_at_least_two_inequalities": True,
            "finite_tests_used_as_universal_proof": False,
            "proof_connection": "report.md",
            "formal_scope": "Three polynomial sectors; power sums; correction identity"
        },
        "jacobian": jacobian,
        "supplementary_finite_diagnostics": {
            "artificial_precision_progressions": progressions,
            "artificial_precision_transform_entries": transform_entries,
            "original_domain": original,
            "complete_three_mode_mass": trial
        },
        "full_factoring_theorem_verified": False,
        "independent_review": "required_not_yet_performed",
        "elapsed_seconds": round(perf_counter() - start, 3)
    }, indent=2))


if __name__ == "__main__":
    main()
