#!/usr/bin/env python3
"""Replay exact algebra and compiler-certificate freshness, not the analytic proof."""

import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(expression, label):
    residual = sp.expand(expression)
    require(residual == 0, f"{label}: nonzero exact residual {residual}")


def norm_sq(z):
    return sp.expand(z * sp.conjugate(z))


def complex_symbol(name):
    re, im = sp.symbols(f"{name}_re {name}_im", real=True)
    return re + sp.I * im


def nonnegative_affine(expression, parameters):
    polynomial = sp.Poly(sp.expand(expression), *parameters, domain=sp.QQ)
    return polynomial.total_degree() <= 1 and all(
        coefficient >= 0 for coefficient in polynomial.coeffs()
    )


def check_tail_indices():
    m = sp.Symbol("m", integer=True)
    k, h = sp.symbols("k h", integer=True, nonnegative=True)
    n = m + 2 + h
    p, q = sp.symbols("p q")
    cases = [
        ("left", m - 2 - k, n, (0, 0, 0), 0),
        ("lower_one", m - 1, n, (0, 1, 0), q),
        ("lower_two", m, n, (0, 1, 1), -p),
        ("interior", m + 1 + k, m + 2 + k + h, (1, 1, 1), 0),
        ("upper_one", n, n, (1, 0, 1), -q),
        ("upper_two", n + 1, n, (1, 0, 0), p),
        ("right", n + 2 + k, n, (0, 0, 0), 0),
    ]
    for label, j, upper, masks, target in cases:
        require(nonnegative_affine(upper - m - 2, (k, h)), label)
        for index, mask in zip((j - 1, j + 1, j), masks):
            if mask:
                certified = nonnegative_affine(index - m, (k, h)) and (
                    nonnegative_affine(upper - index, (k, h))
                )
            else:
                certified = nonnegative_affine(m - index - 1, (k, h)) or (
                    nonnegative_affine(index - upper - 1, (k, h))
                )
            require(certified, f"{label}: invalid interval mask at {index}")
        # The exact recurrence says i*lambda*f_j = p+q, without division.
        output = masks[0] * p + masks[1] * q - masks[2] * (p + q)
        zero(output - target, f"finite tail: {label}")
    return len(cases)


def check_symbolic_algebra():
    l = sp.Symbol("lambda", real=True)
    p, q, w = (complex_symbol(name) for name in ("p", "q", "w"))
    local_pair = sp.re((p + q - sp.I * l * w) * sp.conjugate(p - q))
    correction = sp.re(sp.I * l * w * sp.conjugate(p)) - sp.re(
        sp.I * l * w * sp.conjugate(q)
    )
    zero(norm_sq(p) - norm_sq(q) - local_pair - correction, "local spectral sign")
    z = complex_symbol("z")
    zero(
        sp.re(-sp.I * l * z) - sp.re(sp.I * l * sp.conjugate(z)),
        "spectral adjoint sign",
    )

    b, a, u, v = (complex_symbol(name) for name in ("b", "a", "u", "v"))
    energy = norm_sq(b) + norm_sq(a)
    mass = norm_sq(v) + norm_sq(u)
    c = b * sp.conjugate(v) + a * sp.conjugate(u)
    pairing = b * sp.conjugate(-l * v - 2 * sp.I * b) - a * sp.conjugate(
        l * u + 2 * sp.I * a
    )
    zero(pairing - (2 * sp.I * energy - l * c), "two-boundary pairing")
    zero(
        energy * mass - norm_sq(c) - norm_sq(b * u - a * v),
        "two-complex-vector Cauchy identity",
    )
    zero(
        sp.I * (sp.I * l * v - b) - sp.I * b - (-l * v - 2 * sp.I * b),
        "lower transverse mode",
    )
    zero(
        sp.I * a - sp.I * (sp.I * l * u - a) - (l * u + 2 * sp.I * a),
        "upper transverse mode",
    )

    e, mu, re, im = sp.symbols("E M re im", real=True)
    gap = l**2 * e * mu - 4 * e**2
    sos = l**2 * (e * mu - re**2 - im**2) + (l * re) ** 2
    zero(
        gap - sos - (l * im - 2 * e) * (l * im + 2 * e),
        "sharp scalar bound factorization",
    )
    bs, ass = sp.I * l * v / 2, sp.I * l * u / 2
    zero(-l * v - 2 * sp.I * bs, "sharp lower mode")
    zero(l * u + 2 * sp.I * ass, "sharp upper mode")
    zero(norm_sq(bs) + norm_sq(ass) - l**2 * mass / 4, "sharp constant")
    zero(
        norm_sq(p) + norm_sq(q)
        - 2 * (norm_sq((p - sp.I * q) / 2) + norm_sq((p + sp.I * q) / 2)),
        "complex spatial gradient identity",
    )

    m = sp.Symbol("m", integer=True)
    n = sp.Symbol("n", integer=True, nonnegative=True)
    d, correction_sequence = sp.Function("D"), sp.Function("C")

    def endpoint(length):
        return (
            d(m) + d(m + 1) - d(m + length) - d(m + length + 1)
            - correction_sequence(m) + correction_sequence(m + length)
        )

    zero(endpoint(0), "arbitrary-index induction base")
    next_summand = (
        d(m + n) - d(m + n + 2)
        - correction_sequence(m + n) + correction_sequence(m + n + 1)
    )
    zero(endpoint(n + 1) - endpoint(n) - next_summand, "arbitrary-index induction step")
    return {
        "local_spectral_identity": "zero_polynomial",
        "spectral_adjoint_sign": "zero_polynomial",
        "two_boundary_pairing": "zero_polynomial",
        "two_complex_vector_cauchy": "exact_sum_of_squares",
        "transverse_mode_formulas": "zero_polynomials",
        "sharp_scalar_bound": "exact_factorization",
        "sharp_constant": "universal_saturating_family",
        "complex_gradient_identity": "zero_polynomial",
        "consecutive_telescope": "symbolic_base_and_induction_step",
        "finite_tail_integer_regions": check_tail_indices(),
    }


def typed_polynomial(data):
    variables = sp.symbols(" ".join(data["variables"]), seq=True)
    return sp.expand(sum(
        sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
        * sp.prod(variable**power for variable, power in zip(variables, term["exponents"]))
        for term in data["polynomial"]["terms"]
    ))


def check_jacobian(expected):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_result.json").read_text())
    operation = expected["operation_id"]
    require(envelope["request"]["operation_id"] == operation, "wrong Jacobian operation")
    require(envelope["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(envelope["result"]["operation_id"] == operation, "wrong typed result")
    require(envelope["server"]["version"] == expected["server_version"], "server version")
    require(envelope["protocol_version"] == expected["protocol_version"], "protocol version")
    output = envelope["result"]["output"]
    require(output["request"] == payload, "typed request mismatch")
    require(output["outcome"] == "COMPUTED", "Jacobian output is incomplete")
    require(output["detail"] is None, "Jacobian reported an error")
    require(output["in_ideal"] is True, "Jacobian did not certify membership")
    require(output["remainder"]["polynomial"]["terms"] == [], "nonzero remainder")
    require(output["remainder"]["variables"] == ["E", "l", "y"], "wrong remainder ring")
    e, l, y = sp.symbols("E l y")
    generator = typed_polynomial(payload["ideal"]["generators"][0])
    polynomial = typed_polynomial(payload["polynomial"])
    zero(generator - (2 * e - l * y), "typed ideal binding")
    zero(polynomial - (4 * e**2 - l**2 * y**2), "typed polynomial binding")
    zero(polynomial - generator * (2 * e + l * y), "independent exact ideal witness")


def check_lean(expected):
    result = json.loads((HERE / "lean_verify.json").read_text())
    require(result["status"] == "success", "Lean did not compile")
    require(result["exit_code"] == 0, "nonzero Lean exit")
    require(result["proof_holes"] == [], "Lean proof holes")
    require(result["environment_failure"] == "", "Lean environment failure")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean toolchain")
    record = result["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "Lean verdict")
    require(record["subject"]["subject_id"] == expected["claim"], "wrong Lean claim")
    archive = json.loads((ROOT / record["artifact"]).read_text())
    source = (HERE / "Main.lean").read_text()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(archive["lean_source"]["text"] == source, "Lean source changed after compilation")
    require(archive["statement_fidelity"]["text"] == fidelity, "fidelity changed after compilation")
    require(archive["subject"] == record["subject"], "wrong archived subject")
    require(archive["lean_check"] == {k: v for k, v in result.items() if k != "kernel"}, "run mismatch")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = next(
        item for item in reversed(state["claims"]) if item["claim_id"] == expected["claim"]
    )
    require(claim["formal_statement"] == source, "ledger carries different formal source")
    require(claim["content_hash"] == record["subject"]["content_hash"], "stale claim version")
    require(record in state["evidence"], "compiler evidence absent from campaign ledger")
    return record["artifact"]


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    checks = check_symbolic_algebra()
    require(checks == certificate["exact_checks"], "exact certificate expectations changed")
    check_jacobian(certificate["jacobian"])
    lean_artifact = check_lean(certificate["lean"])
    require(certificate["analytic_proof"]["machine_checked"] is False, "analytic scope overclaim")
    print(json.dumps({
        "status": "exact_algebra_verified",
        "exact_checks": checks,
        "jacobian": "source_bound_zero_remainder_independently_replayed",
        "lean": "fresh_Lean_4.31.0_zero_hole_certificate",
        "lean_artifact": lean_artifact,
        "analytic_proof": "report.md; independent human review required",
        "main_theorem_certified": False,
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
