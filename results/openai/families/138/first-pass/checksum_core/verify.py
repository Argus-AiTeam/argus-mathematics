#!/usr/bin/env python3
"""Replay the fixed certificate with integer/rational outward rounding."""

import argparse
import hashlib
import json
from dataclasses import dataclass
from fractions import Fraction as Q
from math import factorial
from pathlib import Path


class CertificateError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise CertificateError(message)


SCALE = 1 << 192


def ceil_div(a, b):
    return -((-a) // b)


@dataclass(frozen=True)
class Interval:
    lo: int
    hi: int

    def __post_init__(self):
        require(self.lo <= self.hi, "reversed interval")

    @classmethod
    def of(cls, value):
        if isinstance(value, cls):
            return value
        value = Q(value)
        return cls(value.numerator * SCALE // value.denominator,
                   ceil_div(value.numerator * SCALE, value.denominator))

    @property
    def lower(self):
        return Q(self.lo, SCALE)

    @property
    def upper(self):
        return Q(self.hi, SCALE)

    def magnitude(self):
        return max(abs(self.lower), abs(self.upper))

    def __add__(self, other):
        other = Interval.of(other)
        return Interval(self.lo + other.lo, self.hi + other.hi)

    __radd__ = __add__

    def __neg__(self):
        return Interval(-self.hi, -self.lo)

    def __sub__(self, other):
        return self + -Interval.of(other)

    def __rsub__(self, other):
        return Interval.of(other) + -self

    def __mul__(self, other):
        other = Interval.of(other)
        products = [a * b for a in (self.lo, self.hi)
                    for b in (other.lo, other.hi)]
        return Interval(min(products) // SCALE,
                        ceil_div(max(products), SCALE))

    __rmul__ = __mul__

    def __truediv__(self, other):
        other = Interval.of(other)
        require(not other.lo <= 0 <= other.hi, "division through zero")
        quotients = [Q(a * SCALE, b) for a in (self.lo, self.hi)
                     for b in (other.lo, other.hi)]
        low, high = min(quotients), max(quotients)
        return Interval(low.numerator // low.denominator,
                        ceil_div(high.numerator, high.denominator))

    def __rtruediv__(self, other):
        return Interval.of(other) / self

    def __pow__(self, exponent):
        require(isinstance(exponent, int) and exponent >= 0,
                "unsupported interval power")
        result = Interval.of(1)
        base = self
        while exponent:
            if exponent % 2:
                result = result * base
            base = base * base
            exponent //= 2
        return result


def less(left, right, message):
    require(Interval.of(left).upper < Interval.of(right).lower, message)


def enclosed(value, center, radius, label):
    center, radius = Q(center), Q(radius)
    require(radius >= 0, label + ": negative radius")
    require(center - radius <= value.lower and value.upper <= center + radius,
            label + ": claimed enclosure fails")


def symmetric_error(value, error):
    error = Interval.of(error).upper
    return value + Interval.of(-error) + Interval.of(2 * error) * Interval(0, SCALE)


def exp(value):
    value = Interval.of(value)
    halvings = 0
    while value.magnitude() > 1:
        value = value / 2
        halvings += 1
    result = Interval.of(Q(1, factorial(45)))
    for degree in range(44, -1, -1):
        result = result * value + Q(1, factorial(degree))
    t = value.magnitude()
    remainder = t ** 46 / (factorial(46) * (1 - t / 47))
    result = symmetric_error(result, remainder)
    require(result.lower > 0, "exponential enclosure lost positivity")
    for _ in range(halvings):
        result = result * result
    return result


def ln(value):
    value = Interval.of(value)
    require(value.lower > 0, "logarithm outside its real domain")
    d = (value - 1) / (value + 1)
    t = d.magnitude()
    require(t < 1, "logarithm tail is not convergent")
    term = d
    total = Interval.of(0)
    for index in range(64):
        total = total + term / (2 * index + 1)
        term = term * d * d
    remainder = 2 * t ** 129 / (129 * (1 - t * t))
    return symmetric_error(2 * total, remainder)


LN2 = ln(2)


def log2(value):
    return ln(value) / LN2


def power2(value):
    return exp(Interval.of(value) * LN2)


def cosh(value):
    value = Interval.of(value)
    return (exp(value) + exp(-value)) / 2


def arctan_rational(value):
    value = Q(value)
    total = sum(((-1) ** index * value ** (2 * index + 1)
                 / (2 * index + 1) for index in range(80)), Q(0))
    return Interval.of(total) + Interval.of(
        value ** 161 / 161) * Interval(0, SCALE)


def cosine_small(value):
    value = Interval.of(value)
    square = value * value
    result = Interval.of(Q(1, factorial(24)))
    for index in range(11, -1, -1):
        result = result * square + Q((-1) ** index, factorial(2 * index))
    return symmetric_error(result, value.magnitude() ** 26 / factorial(26))


EXPECTED_PARAMETERS = {
    "eta": "0.51772", "tau": "0.48996", "delta": "0.02776",
    "gamma": "0.46220", "kappa": "1.0315", "epsilon": "0.00000001",
    "r": ["0.851", "0.466", "0.325", "0.253", "0.224", "-0.314"],
    "s": ["1.281", "-0.938", "0.731", "-0.559", "0.391", "0.110"],
}


def verify_nodes(certificate):
    require(certificate["parameters"] == EXPECTED_PARAMETERS,
            "parameters do not match the staged theorem")
    p = certificate["parameters"]
    kappa, delta = Q(p["kappa"]), Q(p["delta"])
    a = delta / Q(p["gamma"])
    pi = 4 * (arctan_rational("1/2") + arctan_rational("1/3"))
    less("3.1415926535897", pi, "pi lower bound")
    less(pi, "3.1415926535899", "pi upper bound")
    cosines = [cosine_small(pi * Q(j, 32)) for j in range(17)]
    require(len(certificate["cosine_centers"]) == 17, "cosine table length")
    for j, value in enumerate(cosines):
        enclosed(value, certificate["cosine_centers"][j],
                 certificate["cosine_error"], f"cosine {j}")
    full_cos = []
    for j in range(64):
        index = min(j, 64 - j)
        full_cos.append(cosines[index] if index <= 16
                        else -cosines[32 - index])
    r_coeff, s_coeff = [[Q(x) for x in p[key]] for key in ("r", "s")]

    def samples(coefficients):
        return [sum((coefficient * full_cos[(harmonic * j) % 64]
                     for harmonic, coefficient in enumerate(coefficients, 1)),
                    Interval.of(0)) for j in range(64)]

    r, s = samples(r_coeff), samples(s_coeff)
    F, G = [power2(x) for x in r], [power2(x) for x in s]
    zf, zg = sum(F) / 64, sum(G) / 64
    zfk = sum(power2(kappa * x) for x in r) / 64
    zgk = sum(power2(kappa * x) for x in s) / 64
    beta = Q(certificate["analytic_bounds"]["split_strip"])
    r_beta = samples([c * cosh(beta * j)
                      for j, c in enumerate(r_coeff, 1)])
    s_beta = samples([c * cosh(beta * j)
                      for j, c in enumerate(s_coeff, 1)])
    shifted_f = sum(power2(2 * x) for x in r_beta) / 64
    shifted_g = sum(power2(2 * x) for x in s_beta) / 64
    normalizers = [zf, zg, zfk, zgk, shifted_f, shifted_g]
    require(len(certificate["normalizers"]) == 6, "normalizer table length")
    for index, (value, row) in enumerate(zip(normalizers, certificate["normalizers"])):
        enclosed(value, *row, f"normalizer {index}")
    require(len(certificate["nodes"]) == 33, "node table length")
    convolutions, weighted, moments, moments2 = [], [], [], []
    for j in range(33):
        products = [F[(i + j) % 64] * G[i] for i in range(64)]
        convolution = sum(products) / 64
        y = sum(products[i] * (r[(i + j) % 64] + s[i])
                for i in range(64)) / 64
        t = y / convolution
        c = log2(convolution)
        h = log2(zfk) + log2(zgk)
        u = c + (kappa - 1) * t - h
        v = (2 - kappa) * t - 2 * c + h
        m2 = 2 + 2 * full_cos[j]
        x1 = m2 * power2(Q("8.5") * (delta - u))
        x2 = m2 * power2(Q("8.3") * (a * v - u))
        row = [convolution, y, x1, x2]
        require(len(certificate["nodes"][j]) == 4, "node row length")
        for column, value in enumerate(row):
            enclosed(value, certificate["nodes"][j][column],
                     certificate["node_errors"][column], f"node {j}, column {column}")
        convolutions.append(convolution)
        weighted.append(y)
        moments.append(x1)
        moments2.append(x2)
    mean_bound = Q(certificate["analytic_bounds"]["hatted_mean_bound"])
    for column, values in ((2, moments), (3, moments2)):
        table_upper = sum((1 if j in (0, 32) else 2) *
                          (Q(row[column]) + Q(certificate["node_errors"][column]))
                          for j, row in enumerate(certificate["nodes"])) / 64
        require(table_upper < mean_bound, "table-average upper bound fails")
        mean = sum((1 if j in (0, 32) else 2) * value
                   for j, value in enumerate(values)) / 64
        less(mean, mean_bound, "computed hatted mean bound fails")
    return normalizers, convolutions, weighted, r_coeff, s_coeff


def verify_analysis(certificate, node_data):
    normalizers, convolutions, weighted, r_coeff, s_coeff = node_data
    zf, zg, zfk, zgk, shifted_f, shifted_g = normalizers
    b = {key: Q(value) for key, value in certificate["analytic_bounds"].items()}
    p = certificate["parameters"]
    kappa, delta = Q(p["kappa"]), Q(p["delta"])
    a = delta / Q(p["gamma"])
    sigma, beta = b["inner_strip"], b["split_strip"]
    require(sigma == Q("0.45") and beta == Q("0.19"), "strip fidelity")
    for coefficients, bound, shifted_bound in (
            (r_coeff, b["r_strip"], b["r_beta_strip"]),
            (s_coeff, b["s_strip"], b["s_beta_strip"])):
        strip_sum = sum(abs(c) * cosh(j * sigma)
                        for j, c in enumerate(coefficients, 1))
        shifted_sum = sum(2 * abs(c) * cosh(j * beta) * cosh(j * sigma)
                          for j, c in enumerate(coefficients, 1))
        less(strip_sum, bound, "inner-strip coefficient bound")
        less(shifted_sum, shifted_bound, "shifted inner-strip coefficient bound")
    denominator = exp(64 * sigma) - 1
    z_error = b["normalizer_quadrature_error"]
    c_error = b["convolution_quadrature_error"]
    y_error = b["weighted_convolution_quadrature_error"]
    shifted_error = b["shifted_l2_quadrature_error"]
    less(2 * power2(kappa * b["s_strip"]) / denominator, z_error,
         "normalizer quadrature error")
    joint = b["r_strip"] + b["s_strip"]
    less(2 * power2(joint) / denominator, c_error, "convolution quadrature error")
    less(2 * joint * power2(joint) / denominator, y_error,
         "weighted convolution quadrature error")
    less(2 * power2(b["s_beta_strip"]) / denominator, shifted_error,
         "shifted L2 quadrature error")
    min_c = min(x.lower for x in convolutions)
    max_y = max(x.magnitude() for x in weighted)
    log_z_error = sum(z_error / ((z.lower - z_error) * LN2)
                      for z in (zf, zg))
    error_l = c_error / ((min_c - c_error) * LN2) + log_z_error
    error_b = (y_error / (min_c - c_error)
               + max_y * c_error / (min_c * (min_c - c_error))
               + log_z_error)
    error_h = (sum(z_error / ((z.lower - z_error) * LN2) for z in (zfk, zgk))
               + kappa * log_z_error)
    for error, name in ((error_l, "L_error"), (error_b, "B_error"),
                        (error_h, "H_error")):
        less(error, b[name], name + " propagation")
    du = b["L_error"] + (kappa - 1) * b["B_error"] + b["H_error"]
    dv = (2 - kappa) * b["B_error"] + 2 * b["L_error"] + b["H_error"]
    for exponent_error in (Q("8.5") * du, Q("8.3") * (a * dv + du)):
        less(power2(exponent_error), b["node_multiplier"], "node multiplier")
    less((shifted_f + shifted_error) / (zf - z_error) ** 2, "1.761", "f shifted L2")
    less((shifted_g + shifted_error) / (zg - z_error) ** 2, "1.38", "g shifted L2")
    require(Q("0.761") * Q("0.38") < Q("0.54") ** 2, "zero-free Q disk")
    less(-log2("0.46"), "1.121", "log Q strip bound")
    for coefficients, bound in ((r_coeff, Q("2.96")), (s_coeff, Q("4.67"))):
        less(sum(abs(c) * cosh(j * beta) for j, c in enumerate(coefficients, 1)),
             bound, "half-strip score coefficient bound")
    sum_logs = log2(zf + z_error) + log2(zg + z_error)
    less(Q("1.761") * Q("1.38") * (Q("2.96") + Q("4.67") + sum_logs) ** 2,
         13 ** 2, "QB strip bound")
    H = log2(zfk) + log2(zgk) - kappa * (log2(zf) + log2(zg))
    less(H + b["H_error"], "0.016", "H upper bound")
    exponent1 = Q("8.5") * (delta + Q("1.121")
                            + (kappa - 1) * 13 / Q("0.46") + Q("0.016"))
    exponent2 = Q("8.3") * ((1 + 2 * a) * Q("1.121")
                            + abs(a * (2 - kappa) - (kappa - 1)) * 13 / Q("0.46")
                            + (1 + a) * Q("0.016"))
    require(max(exponent1, exponent2) < Q("17.6"), "outer-strip exponent bound")
    less(2 + 2 * cosh(2 * beta), "4.16", "outer-strip M^2 bound")
    less(Q("4.16") * power2("17.6"), 2 ** 20, "outer integrand strip bound")
    less(2 ** 21 / (exp(64 * 2 * beta) - 1), b["outer_quadrature_error"],
         "outer trapezoid error")
    bound = b["hatted_mean_bound"] * b["node_multiplier"] + b["outer_quadrature_error"]
    require(bound == b["continuous_moment_bound"], "continuous upper-bound arithmetic")
    less(bound, power2("0.5168"), "continuous moment threshold")
    return bound


def verify_transfer(certificate, continuous_bound):
    p = certificate["parameters"]
    r, s = [[Q(x) for x in p[key]] for key in ("r", "s")]
    kappa, a = Q(p["kappa"]), Q(p["delta"]) / Q(p["gamma"])
    require(sum(map(abs, r)) < 3 and sum(map(abs, s)) < 5, "real coefficient bounds")
    require(sum(j * abs(c) for j, c in enumerate(r, 1)) < 8, "r derivative bound")
    require(sum(j * abs(c) for j, c in enumerate(s, 1)) < 12, "s derivative bound")
    require(1 <= kappa < Q(9, 8) and 0 <= Q(p["delta"]) <= Q(1, 32)
            and 0 <= a <= Q(1, 16), "transfer parameter bounds")
    less("1/2", LN2, "ln 2 lower bound")
    less(LN2, 1, "ln 2 upper bound")
    require(8 + Q(1, 8) * 8 + 9 <= 18, "uniform u bound")
    require(8 + 16 + 9 <= 33, "uniform v bound")
    require(Q("8.5") * (Q(1, 32) + 18) < 168, "first real exponent bound")
    require(Q("8.3") * (Q(1, 16) * 33 + 18) < 168, "second real exponent bound")
    require(3 * Q(9, 8) < 4 and 5 * Q(9, 8) < 6, "powered normalizer ranges")
    require(max(8 * 2 ** 3, 12 * 2 ** 5,
                Q(9, 8) * 8 * 2 ** 4, Q(9, 8) * 12 * 2 ** 6) < 2 ** 10,
            "normalizer derivative bounds")
    require(8 * 2 ** 8 <= 2 ** 11 and 8 * 9 * 2 ** 8 <= 2 ** 15,
            "x derivative numerator bounds")
    require(20 * 2 ** 8 <= 2 ** 13 and 20 * 9 * 2 ** 8 <= 2 ** 16,
            "w derivative numerator bounds")
    require(8 * 2 ** 16 <= 2 ** 20, "common normalized Riemann error")
    t_error = 2 ** 8 * (1 + 8)
    c_log_error = 2 ** 9
    h_error = 2 * 2 ** 9
    u_error = c_log_error + t_error / Q(8) + h_error
    v_error = t_error + 2 * c_log_error + h_error
    require(max(Q("8.5") * u_error, Q("8.3") * (v_error / Q(16) + u_error))
            * 2 ** 20 <= 2 ** 40, "finite-to-continuous exponent error")
    t_speed = 2 ** 8 * (2 ** 15 + 8 * 2 ** 11)
    c_speed = 2 ** 9 * 2 ** 11
    u_speed = c_speed + t_speed / Q(8)
    v_speed = t_speed + 2 * c_speed
    require(max(Q("8.5") * u_speed, Q("8.3") * (v_speed / Q(16) + u_speed))
            <= 2 ** 26, "outer real exponent derivative")
    require((2 + 4 * 2 ** 26) * 2 ** 168 <= 2 ** 197,
            "outer real integrand derivative")
    transfer = certificate["finite_transfer"]
    error_power = transfer["moment_error_power_of_two"]
    threshold_power = transfer["modulus_threshold_power_of_two"]
    require(error_power == 224 and threshold_power == 256, "effective transfer fidelity")
    require(8 * 2 ** 197 + 4 * 2 ** 168 * 2 ** 40 <= 2 ** error_power,
            "effective moment transfer bound")
    finite_bound = continuous_bound + Q(2) ** (error_power - threshold_power)
    less(finite_bound, power2("0.5169"), "all sufficiently large finite circles")
    return finite_bound


def verify_probability(certificate):
    p = certificate["parameters"]
    eta, tau, delta, gamma, epsilon = [Q(p[key]) for key in
                                      ("eta", "tau", "delta", "gamma", "epsilon")]
    a = delta / gamma
    b = {key: Q(value) for key, value in certificate["probability_arithmetic"].items()}
    require(delta == eta - tau and gamma == 2 * tau - eta, "budget identities")
    require(0 < delta and 0 < gamma and tau - gamma == delta, "digit balance")
    require(b["rounding_domination"] >= Q("8.5") * 3, "first dominance rounding")
    require(b["rounding_domination"] >= Q("8.3") * (4 * a + 3),
            "second dominance rounding")
    require(Q("8.5") > 1 and Q("8.3") > 1, "dominance slope conditions")
    require(b["combined_rounding"] == 18 + b["rounding_domination"],
            "combined domination slack")
    exponent = -tau - delta + Q("0.5169") + b["combined_rounding"] * epsilon
    require(exponent == b["mse_exponent"] < b["eventual_mse_exponent"] < 0,
            "negative unconditional MSE exponent")
    require(tau + 20 * epsilon == b["all_history_time_exponent"] < Q("0.49"),
            "all-history time exponent")
    require(6 * epsilon > 0 and 20 * epsilon > 18 * epsilon > 14 * epsilon,
            "cap and Markov slacks")
    return exponent


def verify_kernel_fixtures(certificate):
    for fixture in certificate["kernel_fixtures"]:
        multiplicities = fixture["multiplicities"]
        values = [tuple(Q(x) for x in pair) for pair in fixture["values"]]
        require(len(multiplicities) == len(values), "kernel fixture dimension")
        require(all(isinstance(m, int) and m > 0 for m in multiplicities),
                "fixture lacks coverage")
        P = fixture["normalizer"]
        L = sum(multiplicities) + fixture["rejected_matches"]
        require(P > 0 and L > 0 and fixture["rejected_matches"] >= 0,
                "fixture normalization")
        first = [Q(0), Q(0)]
        second = Q(0)
        energy = Q(0)
        for m, z in zip(multiplicities, values):
            x = [Q(L, P * m) * part for part in z]
            for component in range(2):
                first[component] += Q(m, L) * x[component]
            second += Q(m, L) * sum(part * part for part in x)
            energy += sum(part * part for part in z)
        require(first == [sum((z[c] for z in values), Q(0)) / P for c in range(2)],
                "inverse-multiplicity first moment")
        require(second <= Q(L, P * P) * energy, "inverse-multiplicity second moment")


def verify_jacobian(directory):
    payload = json.loads((directory / "jacobian_payload.json").read_text())
    response = json.loads((directory / "jacobian_result.json").read_text())
    require(response["request"]["payload"] == payload, "Jacobian source binding")
    require(response["result"]["operation_id"] ==
            "analysis.real_function.point_enclosure.compute", "Jacobian operation")
    output = response["result"]["output"]
    require(output["status"] == "ENCLOSED" and output["function"] == "LOG"
            and output["argument"] == {"num": "2", "den": "1"}, "Jacobian typed outcome")
    bounds = output["enclosure"]
    endpoints = [Q(bounds[key]["mantissa"]) * Q(2) ** bounds[key]["exponent"]
                 for key in ("lower", "upper")]
    require(endpoints[0] <= LN2.lower <= LN2.upper <= endpoints[1],
            "independent rational replay of Jacobian log(2)")


def verify_lean(directory, artifact):
    archived = json.loads((directory / artifact).read_text())
    result = archived["lean_check"]
    source = (directory / "Main.lean").read_bytes()
    fidelity = (directory / "statement_fidelity.md").read_text()
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["audit_exit_code"] == 0 and result["proof_holes"] == [],
            "Lean compilation or axiom audit is not verified")
    require("version 4.31.0," in result["tools"]["lean"]["version"],
            "wrong Lean compiler version")
    require(archived["subject"]["subject_id"] == "C_MATCH_KERNEL"
            and archived["tier"] == "mechanical" and archived["verdict"] == "supports",
            "wrong formal claim or evidence tier")
    require(archived["lean_source"]["text"].encode("utf-8") == source
            and result["source_sha256"] == hashlib.sha256(source).hexdigest(),
            "Lean source changed after compilation")
    require(archived["statement_fidelity"]["text"] == fidelity
            and result["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.encode("utf-8")).hexdigest(),
            "statement fidelity changed after compilation")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path,
                        default=Path(__file__).with_name("exact_certificate.json"))
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    require(certificate["schema_version"] == 1 and certificate["claim"] == "C_CHECKSUM",
            "certificate identity")
    node_data = verify_nodes(certificate)
    continuous = verify_analysis(certificate, node_data)
    finite = verify_transfer(certificate, continuous)
    exponent = verify_probability(certificate)
    verify_kernel_fixtures(certificate)
    verify_jacobian(Path(__file__).resolve().parent)
    verify_lean(Path(__file__).resolve().parent, certificate["formal_evidence"])
    print(json.dumps({
        "status": "verified",
        "arithmetic": "integer/rational outward-rounded intervals; no floating point",
        "continuous_moments_strict_upper": str(continuous),
        "finite_moments_strict_upper": str(finite),
        "finite_modulus_threshold": "2^256",
        "restricted_mse_exponent": str(exponent),
        "lean_kernel": "Lean 4.31.0; compiler and axiom audit exit 0; proof_holes=[]",
        "logical_scope": "Arithmetic obligations and finite kernel; see report.md for the quantified proof.",
        "independent_review": "not supplied by this verifier"
    }, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (CertificateError, OSError, KeyError, TypeError, json.JSONDecodeError) as error:
        raise SystemExit("CERTIFICATE REJECTED: " + str(error))
