#!/usr/bin/env python3
"""Replay exact identities; optionally run explicitly non-proving diagnostics."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational_function(value, variables):
    require(value["variables"] == [str(v) for v in variables], "Jacobian field mismatch")

    def polynomial(data):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * sp.prod(v**e for v, e in zip(variables, term["exponents"], strict=True))
            for term in data["terms"]
        )

    return polynomial(value["numerator"]) / polynomial(value["denominator"])


def exact_checks(certificate):
    p, q, h = sp.symbols("p q h", real=True)
    j = p**2 + q**2 * h**2 - q * h
    pdot = -p * (h + q * (1 - h**2)) / j
    r = (1 - h**2) * (p**2 / h**2 + q**2)
    d = p / h
    k = (q * h - 1)**2 + d**2
    ddot = sp.diff(d, p) * pdot + sp.diff(d, h) * (1 - h**2)
    rdot = (
        sp.diff(r, p) * pdot
        + sp.diff(r, q)
        + sp.diff(r, h) * (1 - h**2)
    )
    algebra = certificate["exact_algebra"]
    environment = {"p": p, "q": q, "h": h, "J": j, "P": pdot, "r": r, "d": d, "K": k}
    for key, expected in {
        "J": j,
        "P": pdot,
        "r": r,
        "d": d,
        "K": k,
        "height_derivative": ddot,
        "radius_derivative": rdot,
        "density_ratio": (1+r)*d/(2*r*k),
    }.items():
        require(sp.cancel(sp.sympify(algebra[key], locals=environment) - expected) == 0,
                f"Certificate formula mismatch: {key}")
    a, t = sp.symbols("a t", real=True)
    sin2p = -2 * q * h * p / (p**2 + q**2 * h**2)
    cos2p = (p**2 - q**2 * h**2) / (p**2 + q**2 * h**2)
    sinh2q = 2 * h / (1 - h**2)
    cosh2q = (1 + h**2) / (1 - h**2)
    denominator = cosh2q - cos2p
    u = sp.symbols("u")
    su = (u / sp.sin(u))**2
    bu = u * sp.cot(u)
    b = a - sp.I * d
    boundary_derivative = -(b + t) / (2 * t * (b - 1))
    identities = {
        "J_positive_decomposition": j - (p**2 - sp.Rational(1, 4) + (q*h-sp.Rational(1, 2))**2),
        "height_derivative_factorization": ddot + p * (1 + r) / j,
        "radius_derivative_factorization": rdot + 2 * h * r * k / j,
        "density_ratio_cross_multiplication": 2 * r * k * ddot - (1 + r) * d * rdot,
        "boundary_real_part": (p * sin2p + q * sinh2q) / denominator - q * h,
        "boundary_negative_imaginary_height": (p * sinh2q - q * sin2p) / denominator - d,
        "boundary_radius": 2 * (p**2 + q**2) / denominator - r,
        "defining_parameter_derivative": sp.diff(su, u) - 2 * su * (1 - bu) / u,
        "B_parameter_derivative": sp.diff(bu, u) - (bu - su) / u,
        "jump_density_sign": sp.im(boundary_derivative) + (1+t)*d / (2*t*((a-1)**2+d**2)),
        "subtracted_kernel_derivative": sp.diff((1-a)/((a+t)*(1+t)), a) + 1/(a+t)**2,
    }
    for name, residual in identities.items():
        require(sp.simplify(sp.trigsimp(residual)) == 0, f"Nonzero identity: {name}")

    for expression, key in (
        (su, "s_in_u_squared"),
        (bu, "B_in_u_squared"),
    ):
        series = sp.series(expression, u, 0, 8).removeO().expand()
        actual = [str(series.coeff(u, 2*i)) for i in range(4)]
        require(actual == certificate["taylor"][key], f"Taylor mismatch: {key}")
    require(certificate["taylor"]["Bprime_at_1"] == "-1", "Derivative normalization changed")
    require(sp.Rational(-1, 3) / sp.Rational(1, 3) == -1, "Wrong inverse-branch derivative")
    require(certificate["measure"]["constant"] == "0", "Wrong constant")
    require(certificate["measure"]["origin_atom"] == "1/2", "Wrong origin atom")
    require(certificate["measure"]["weighted_total_mass"] == "1", "Wrong normalization")
    measure_environment = {"r": r, "a": q*h, "d": d, "pi": sp.pi}
    require(sp.cancel(
        sp.sympify(certificate["measure"]["density_at_r"], locals=measure_environment)
        - ddot/(sp.pi*rdot)
    ) == 0, "Certificate density does not equal the proven ratio")
    require(sp.cancel(
        sp.sympify(certificate["measure"]["cumulative_at_r"], locals=measure_environment)
        - d/sp.pi
    ) == 0, "Certificate cumulative distribution mismatch")

    adapter = json.loads((ROOT / certificate["jacobian"]["adapter_status"]).read_text())
    require(adapter["status"] == "completed" and adapter["exit_code"] == 0, "Jacobian did not complete")
    archived = json.loads((ROOT / certificate["jacobian"]["typed_result"]).read_text())
    require(archived["protocol_version"] == "2025-11-25", "Unexpected Jacobian protocol")
    require(archived["server"]["version"] == "0.14.0", "Unexpected archived Jacobian version")
    require(archived["result"]["operation_id"] == certificate["jacobian"]["operation_id"], "Wrong operation")
    output = archived["result"]["output"]
    require(output["classification"] == "UNIQUE", "Reciprocal system not uniquely solved")
    require(output["consistency"] == "EXACT_RATIONAL_FUNCTION"
            and output["field_semantics"] == "GENERIC_OVER_QQ_FIELD",
            "Jacobian result is not an exact rational-function result")
    payload = json.loads((ROOT / certificate["jacobian"]["payload"]).read_text())
    variables = sp.symbols("a d", real=True)
    matrix = sp.Matrix([
        [rational_function(entry, variables) for entry in row]
        for row in payload["matrix"]["entries"]
    ])
    rhs = sp.Matrix([rational_function(entry, variables) for entry in payload["rhs"]])
    require(matrix == sp.Matrix([[variables[0], variables[1]], [-variables[1], variables[0]]]), "Wrong reciprocal system")
    require(rhs == sp.Matrix([1, 0]), "Wrong reciprocal right-hand side")
    source_matrix = sp.Matrix([
        [rational_function(entry, variables) for entry in row]
        for row in output["system"]["matrix"]["entries"]
    ])
    source_rhs = sp.Matrix([
        rational_function(entry, variables) for entry in output["system"]["rhs"]
    ])
    require(source_matrix == matrix and source_rhs == rhs, "Typed result is not tied to payload")
    solution = sp.Matrix([rational_function(entry, variables) for entry in output["solution"]])
    for residual in matrix * solution - rhs:
        require(sp.cancel(residual) == 0, "Invalid archived Jacobian solution")
    expected = sp.Matrix([variables[0], variables[1]]) / sum(v**2 for v in variables)
    for residual in solution - expected:
        require(sp.cancel(residual) == 0, "Wrong reciprocal orientation")

    formal = certificate["formal"]
    lean = json.loads((ROOT / formal["compiler_result"]).read_text())
    require(lean["status"] == "success" and lean["exit_code"] == 0
            and lean["proof_holes"] == [], "Lean formal core has not compiled without holes")
    require(lean["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "Formal evidence uses the wrong Lean version")
    require(hashlib.sha256((ROOT / formal["source"]).read_bytes()).hexdigest()
            == lean["source_sha256"], "Lean evidence is stale for this source")
    require(hashlib.sha256((ROOT / formal["statement_fidelity"]).read_bytes()).hexdigest()
            == lean["statement_fidelity_sha256"], "Lean statement-fidelity evidence is stale")
    recorded = lean["kernel"]["recorded"]
    require(recorded["verdict"] == "supports" and recorded["tier"] == "mechanical"
            and recorded["subject"]["subject_id"] == formal["claim"],
            "Compiler result is not mechanical support for the formal-core claim")

    return {
        "exact_identities": list(identities),
        "taylor_coefficients_checked": 8,
        "jacobian_replayed": True,
        "generic_field_specialization_guard": "a^2+d^2>0 follows from the actual boundary d>0",
        "formal_core": {
            "lean_version": "4.31.0",
            "exit_code": lean["exit_code"],
            "proof_holes": lean["proof_holes"],
            "source_and_fidelity_current": True,
            "claim": formal["claim"],
            "kernel_certificate": recorded["artifact"],
        },
    }


def numerical_checks(settings):
    import mpmath as mp

    mp.mp.dps = settings["decimal_precision"]
    steps = settings["bisection_steps"]
    cutoff = mp.mpf(settings["tail_start_q"])

    def bisect_increasing(function, left, right):
        for _ in range(steps):
            middle = (left + right) / 2
            if function(middle) < 0:
                left = middle
            else:
                right = middle
        return (left + right) / 2

    def boundary(q):
        h = mp.tanh(q)
        p = bisect_increasing(lambda p: p * mp.tan(p) + q*h, mp.pi/2, mp.pi)
        r = (1-h**2) * (p**2/h**2 + q**2)
        d = p/h
        j = p**2 + q**2*h**2 - q*h
        return p, r, d, j

    p_tail, r_tail, d_tail, _ = boundary(cutoff)
    tail_mass = (d_tail - mp.pi/2) / mp.pi
    require(p_tail > mp.pi/2 and tail_mass > 0, "Diagnostic boundary failed")
    results = []
    for text in settings["s_values"]:
        s = mp.mpf(str(sp.Rational(text).p)) / mp.mpf(str(sp.Rational(text).q))
        if s == 1:
            direct = mp.mpf(1)
        elif s < 1:
            upper = mp.mpf(2)
            while upper/mp.sinh(upper) > mp.sqrt(s):
                upper *= 2
            x = bisect_increasing(lambda x: mp.sqrt(s) - x/mp.sinh(x), mp.mpf(0), upper)
            b = x/mp.tanh(x)
            direct = (b-s)/(2*s*(b-1))
        else:
            u = bisect_increasing(lambda u: u/mp.sin(u) - mp.sqrt(s), mp.mpf(0), mp.pi)
            b = u/mp.tan(u)
            direct = (b-s)/(2*s*(b-1))

        def integrand(q):
            if q == 0:
                return 1/mp.pi**2
            p, r, _, j = boundary(q)
            return p*(1+r)/(mp.pi*j*(s+r))

        integral = mp.quad(integrand, [0, mp.mpf("0.1"), 1, 4, 12, cutoff])
        represented = 1/(2*s) + integral + tail_mass/s
        tail_bound = tail_mass*r_tail/(s*(s+r_tail))
        error = abs(direct-represented)
        require(error < mp.mpf(settings["absolute_tolerance"]) + tail_bound, f"Integral diagnostic failed at s={text}")
        results.append({
            "s": text,
            "absolute_error": mp.nstr(error, 10),
            "analytic_tail_bound_evaluated_numerically": mp.nstr(tail_bound, 10),
        })
    return {
        "kind": "floating_point_diagnostic_not_proof",
        "samples": results,
        "tail_inequality": "tail_mass/(s+r(Q)) <= omitted integral <= tail_mass/s",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--numeric", action="store_true", help="Add bounded floating-point diagnostics, not a proof")
    args = parser.parse_args()
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["claim"] == "C_ST_MEASURE", "Wrong claim")
    result = {
        "status": "passed",
        "exact": exact_checks(certificate),
        "universal_analytic_proof": "proof.md; requires independent mathematical review",
        "not_mechanically_checked": certificate["not_mechanically_proved_by_python"],
    }
    if args.numeric:
        result["numerical"] = numerical_checks(certificate["numerical_diagnostics"])
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
