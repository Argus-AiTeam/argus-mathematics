#!/usr/bin/env python3
"""Replay exact scalar obligations, not the unformalized analytic proof."""

from collections import defaultdict
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def add(*polynomials):
    result = defaultdict(Fraction)
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            result[exponent] += coefficient
    return {exponent: value for exponent, value in result.items() if value}


def scale(polynomial, coefficient):
    return {exponent: value * coefficient for exponent, value in polynomial.items()}


def multiply(left, right):
    result = defaultdict(Fraction)
    for le, lc in left.items():
        for re, rc in right.items():
            result[tuple(a + b for a, b in zip(le, re))] += lc * rc
    return {exponent: value for exponent, value in result.items() if value}


def check_symbolic_identity():
    one = {(0, 0, 0): Fraction(1)}
    q = {(1, 0, 0): Fraction(1)}
    x = {(0, 1, 0): Fraction(1)}
    y = {(0, 0, 1): Fraction(1)}
    left = add(
        multiply(add(one, q), add(one, x)),
        scale(multiply(add(one, x), add(one, x)), -1),
        scale(multiply(y, y), -1),
    )
    right = add(
        multiply(q, q),
        scale(multiply(x, x), -1),
        scale(multiply(y, y), -1),
        multiply(add(one, scale(q, -1)), add(q, scale(x, -1))),
    )
    require(left == right, "The universal resolvent slack identity is false.")
    require(Fraction(3, 8) ** 2 * 2 / 2 == Fraction(3, 8) ** 2,
            "The normalized squared tip constants disagree.")


def rational(value):
    return Fraction(int(value["num"]), int(value["den"]))


def check_jacobian(spec):
    payload = load(spec["payload"])
    output = load(spec["typed_output"])
    status = load(spec["adapter_status"])
    operation = "polynomial.box.enclosure.compute"
    require(spec["operation_id"] == operation == status["operation_id"],
            "Unexpected Jacobian operation.")
    require(status["exit_code"] == 0, "The Jacobian adapter failed.")
    require(output["server"]["version"] == spec["server_version"] == "0.14.0",
            "Unexpected Jacobian server version.")
    require(output["protocol_version"] == spec["protocol_version"] == "2025-11-25",
            "Unexpected Jacobian protocol.")
    require(output["request"]["payload"] == payload,
            "The typed result is not bound to the preserved payload.")
    result = output["result"]
    require(result["operation_id"] == operation, "Result operation mismatch.")
    typed = result["output"]
    require(typed["polynomial"] == payload["polynomial"]
            and typed["box"] == payload["box"], "Result source mismatch.")
    require(payload["polynomial"]["variables"] == ["d", "u", "v"]
            and payload["box"]["variables"] == ["d", "u", "v"],
            "The ordered polynomial axes changed.")
    terms = payload["polynomial"]["polynomial"]["terms"]
    require([(term["exponents"], rational(term["coefficient"])) for term in terms]
            == [([1, 0, 0], 1), ([0, 1, 1], 1)],
            "The polynomial is not d+u*v.")
    intervals = [(rational(i["lower"]), rational(i["upper"]))
                 for i in payload["box"]["intervals"]]
    require(intervals == [(0, 1), (0, 2), (0, 1)], "Wrong positivity box.")
    require(rational(typed["enclosure"]["lower"]) == 0
            and rational(typed["enclosure"]["upper"]) == 3,
            "The exact Jacobian enclosure is not [0,3].")
    require(not (HERE / status["stderr"]).read_text(encoding="utf-8").strip(),
            "The Jacobian adapter reported stderr; inspect it.")


def check_lean(spec):
    result = load(spec["compiler_result"])
    require(result["status"] == "success" and result["exit_code"] == 0,
            "A successful real Lean compile is required.")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "The Lean proof has holes or its axiom audit failed.")
    require(result["environment_failure"] == "", "Lean environment failure.")
    version = result["tools"]["lean"]["version"]
    require("version " + spec["required_version"] + "," in version,
            "The requested Lean version did not compile the file.")
    for file_key, digest_key in [
        ("source", "source_sha256"),
        ("statement_fidelity", "statement_fidelity_sha256"),
    ]:
        file = HERE / spec[file_key]
        require(hashlib.sha256(file.read_bytes()).hexdigest() == result[digest_key],
                "Stale Lean evidence: " + spec[file_key])
    require(result["kernel"]["recorded"] is not None
            and not result["kernel"]["refusals"],
            "Lean succeeded but mechanical ledger recording was refused.")
    source = (HERE / spec["source"]).read_text(encoding="utf-8")
    for name in spec["declarations"]:
        require("theorem " + name + " " in source,
                "Missing formal declaration: " + name)
    return {"version": spec["required_version"], "exit_code": 0, "proof_holes": []}


def disk_stress(denominator):
    require(denominator == 16, "The exact disk stress grid changed.")
    count = 0
    for n in range(denominator):
        q = Fraction(n, denominator)
        for i in range(-n, n + 1):
            for j in range(-n, n + 1):
                if i * i + j * j > n * n:
                    continue
                x, y = Fraction(i, denominator), Fraction(j, denominator)
                d = q * q - x * x - y * y
                u, v = q - x, 1 - q
                require(0 <= d <= 1 and 0 <= u <= 2 and 0 <= v <= 1,
                        "A disk point did not map into the positivity box.")
                require(1 / (1 + q) <= (1 + x) / ((1 + x) ** 2 + y * y),
                        "Exact rational resolvent counterexample.")
                count += 1
    return count


def endpoint_over_pi(k, a):
    n = 2 * k - 1
    total = Fraction(0)
    previous = Fraction(1, 2)
    for j in range(n + 1):
        moment = Fraction(math.comb(2 * j, j), (j + 1) * 2 * 4 ** j)
        if j:
            require(moment == previous * Fraction(2 * j - 1, 2 * j + 2),
                    "The normalized beta-moment recurrence failed.")
        previous = moment
        total += math.comb(n, j) * a ** (n - j) * (1 - a) ** j * moment
    return k * (1 - a) * total


def endpoint_stress(spec):
    ks = [2, 3, 4, 8, 16, 32, 64]
    require(spec["endpoint_k"] == ks, "The endpoint stress suite changed.")
    for benchmark in spec["exact_endpoint_benchmarks"]:
        a = Fraction(*benchmark["a"])
        require(endpoint_over_pi(benchmark["k"], a)
                == Fraction(*benchmark["I_over_pi"]),
                "An exact endpoint benchmark failed.")
    count = 0
    for k in ks:
        endpoints = {Fraction(0), Fraction(1, 2)}
        endpoints.update(1 - Fraction(1, k ** p) for p in [1, 2, 4, 8])
        for a in endpoints:
            normalized = endpoint_over_pi(k, a)
            require(0 <= normalized <= Fraction(1, 2),
                    "A finite exact endpoint stress case exceeded pi/2.")
            count += 1
        radius = 1 - Fraction(1, k * k)
        require(1 - Fraction(2, k) <= radius ** (2 * k) <= 1,
                "A sharpness-sequence Bernoulli test failed.")
    return count


def numerical_majorant_diagnostics():
    rows = []
    for k in [2, 3, 4, 16, 256, 10 ** 6, 10 ** 12, 10 ** 50]:
        logk = math.log(k)
        power = math.exp((2 * k - 2) * math.log1p(-logk / k))
        lower = 4 / math.pi ** 2 * math.log((2 * k - logk) / logk)
        bound = (math.pi ** 2 / 2 * k * power
                 + 3 * math.sqrt(2) * math.pi ** 2 / 8
                 * (1 + math.pi / math.e) / math.sqrt(lower))
        coarse = (math.pi ** 2 * math.e / (2 * k)
                  + 3 * math.pi ** 3 / 8
                  * (1 + math.pi / math.e) / math.sqrt(logk))
        require(math.isfinite(bound) and 0 < bound <= coarse * (1 + 1e-12),
                "Floating-point majorant diagnostic failed.")
        rows.append({"k": k, "B_k_approx": round(bound, 10)})
    return rows


def main():
    certificate = load("exact_certificate.json")
    require(certificate["claim_id"] == "C_UNIFORM_RATE", "Wrong claim.")
    require(certificate["quantifiers"] == {
        "k": "every integer k >= 2",
        "point": "every v+it in D",
        "moving_tips": "no separation hypothesis on t, r_0, R, or R-r_0",
    }, "The required all-point quantifiers changed.")
    require(certificate["majorant"] == {
        "cutoff": "r_k = 1 - log(k)/k",
        "compact_coefficient": "pi^2/2",
        "tip_coefficient": "3*sqrt(2)*pi^2/8",
        "endpoint_bound": "1 + pi/e",
        "lower_T_prime": "(8/pi^2)*atanh(r_k)",
        "formula": "(pi^2/2)*k*r_k^(2*k-2) + (3*sqrt(2)*pi^2/8)*(1+pi/e)/sqrt((8/pi^2)*atanh(r_k))",
        "coarse_vanishing_bound": "pi^2*e/(2*k) + 3*pi^3*(1+pi/e)/(8*sqrt(log(k)))",
        "global_derivative_bound": "Re(F_prime(w)) >= 2/pi",
        "diameter_bound": 2,
    }, "The certified majorant specification changed.")
    require((HERE / certificate["analytic_proof"]["file"]).is_file(),
            "The separate analytic proof is missing.")
    check_symbolic_identity()
    check_jacobian(certificate["jacobian"])
    lean = check_lean(certificate["formal_core"])
    finite = certificate["finite_experiments"]
    summary = {
        "status": "exact_obligations_passed",
        "lean_scalar_core": lean,
        "exact_polynomial_identity": True,
        "jacobian_enclosure": [0, 3],
        "finite_experiments_not_universal_proofs": {
            "disk_points": disk_stress(finite["disk_grid_denominator"]),
            "endpoint_cases": endpoint_stress(finite),
            "sharpness_cases": len(finite["endpoint_k"]),
        },
        "floating_point_diagnostics_not_certificates": numerical_majorant_diagnostics(),
        "all_point_theorem": "Analytic proof in REPORT.md; independent review pending.",
        "full_mahler_theorem_verified": False,
    }
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
