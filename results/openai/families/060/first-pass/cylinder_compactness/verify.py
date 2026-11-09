#!/usr/bin/env python3
"""Replay the exact algebra in report.md; this is not an analytic proof kernel."""

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
VARIABLES = sp.symbols("x1 y1 x2 y2 u1 v1 u2 v2")


def lagrange_identity():
    x1, y1, x2, y2, u1, v1, u2, v2 = VARIABLES
    norm_f = x1**2 + y1**2 + x2**2 + y2**2
    norm_d = u1**2 + v1**2 + u2**2 + v2**2
    inner_re = x1*u1 + y1*v1 + x2*u2 + y2*v2
    inner_im = x1*v1 - y1*u1 + x2*v2 - y2*u2
    gram = norm_f*norm_d - inner_re**2 - inner_im**2
    wedge_re = x1*u2 - y1*v2 - x2*u1 + y2*v1
    wedge_im = x1*v2 + y1*u2 - x2*v1 - y2*u1
    assert sp.expand(gram - wedge_re**2 - wedge_im**2) == 0
    return gram, [wedge_re, wedge_im]


def encode_polynomial(expression):
    polynomial = sp.Poly(expression, *VARIABLES, domain=sp.QQ)
    return {
        "domain": "QQ",
        "variables": [str(v) for v in VARIABLES],
        "polynomial": {
            "terms": [
                {
                    "coefficient": {"num": str(c.p), "den": str(c.q)},
                    "exponents": list(exponents),
                }
                for exponents, c in polynomial.terms()
                if c
            ]
        },
    }


def expected_payload():
    gram, summands = lagrange_identity()
    return {
        "polynomial": encode_polynomial(gram),
        "summands": [encode_polynomial(q) for q in summands],
    }


def assert_zero(expression):
    numerator = sp.together(expression).as_numer_denom()[0]
    variables = sorted(numerator.free_symbols, key=str)
    if variables:
        assert sp.Poly(numerator, *variables, domain=sp.QQ).is_zero, expression
    else:
        assert numerator == 0, expression


def positive_coefficients(expression, variable):
    polynomial = sp.Poly(sp.expand(expression), variable)
    assert polynomial.eval(0) > 0
    assert all(c >= 0 for c in polynomial.all_coeffs())


def verify_constants(certificate):
    P, K, r, H, B, L, C, Q_symbol = sp.symbols("P K r H B L C Q", positive=True)
    symbols = {str(s): s for s in (P, K, r, H, B, L, C, Q_symbol)}
    data = {
        key: sp.sympify(value, locals=symbols)
        for key, value in certificate["constants"].items()
    }
    R_s, N, Q = data["R_s"], data["N"], data["Q"]
    assert_zero(R_s - (2*P + 8))
    assert_zero(N - (R_s + 1))
    assert_zero(Q - (2*R_s + 2))
    assert_zero(data["epsilon"]*K**2*N/r**2 - sp.Rational(1, 65536))
    assert_zero(data["delta"] - (8*K*r*H + 1))
    assert_zero(data["D"] - 2*K*r)
    assert_zero(data["L"] - 4*P*data["D"])
    assert_zero(data["Lambda"] - H*data["L"])
    assert_zero(data["R0"] - data["Lambda"] - data["delta"])
    assert_zero(data["overlap"] - 2*Q - 3)
    assert_zero(data["B"]*data["epsilon"] - data["overlap"])
    assert_zero(data["C"] - (1 + B + 6*L*B))
    assert_zero(data["C_end"] - (C + 2*Q_symbol + 4 + 3*L))

    z = sp.Symbol("z", nonnegative=True)
    disk_margin = R_s**2 - (2*P + 3)**2 - 16
    assert_zero(disk_margin - (20*P + 39))
    positive_coefficients(disk_margin.subs(P, 4 + z), z)
    assert_zero(Q - 2*R_s - 2)
    assert_zero(N - (2*R_s/3 + 1) - R_s/3)
    assert_zero(data["delta"] - 4*K*r*H - (4*K*r*H + 1))
    assert_zero((1+B)**2 - B - (B**2 + B + 1))

    k = sp.Symbol("k", positive=True)
    slack = sp.Symbol("slack", nonnegative=True)
    assert_zero(
        (sp.Rational(1, 2) - 2*k/P).subs(P, 4*k + slack)
        - slack/(2*(4*k + slack))
    )
    q, n = sp.symbols("q n", positive=True)
    assert sp.simplify((1-q)*q**n - (q**n - q**(n+1))) == 0
    assert_zero(2*P*data["D"]/(1-sp.Rational(1, 2)) - data["L"])
    x = sp.Symbol("x", real=True)
    assert_zero((1+x**2)/2 - x - (x-1)**2/2)
    return len(data)


def verify_filling_margins(certificate):
    margins = {
        key: Fraction(value)
        for key, value in certificate["disk_filling_margins"].items()
    }
    assert all(value > 0 for value in margins.values())
    energy = margins["normalized_energy"]
    small = margins["small_circle_point_radius"]
    length = margins["circle_image_length_upper_bound"]
    boundary = margins["outer_circle_image_radius_bound"]
    relaxed = margins["outer_circle_image_radius_relaxed"]
    escape = margins["forbidden_escape_radius"]
    ball = margins["escape_test_ball_radius"]
    assert energy == Fraction(1, 65536)
    assert 16*energy == length**2
    assert energy < 3*small**2
    assert boundary == small + length
    assert boundary < relaxed < escape
    assert escape - relaxed > ball
    assert escape + ball < 4
    assert energy < 3*ball**2
    assert margins["filled_image_radius"] == escape

    x = sp.Symbol("x", real=True)
    alternating = sum((-1)**j*x**(2*j) for j in range(8))
    assert_zero((1+x*x)*alternating - (1-x**16))
    lower_pi = 4*sum(Fraction((-1)**j, 2*j+1) for j in range(8))
    assert 3 < lower_pi < 4
    assert 2*4 < 3**2
    return str(lower_pi)


def verify_exponents_and_gauge():
    A, eta, eps, rho = sp.symbols("A eta eps rho", positive=True)
    gamma = 2*A + 10 + eta
    assert_zero(gamma - A - (A + 10 + eta))
    assert_zero(2*gamma - A - (3*A + 20 + 2*eta))
    b = A + eps + rho
    assert_zero(b - A - (eps + rho))
    assert_zero(b - eps - (A + rho))
    ell, shift = sp.symbols("ell shift", real=True)
    assert sp.simplify(
        sp.exp(A*(ell+shift))/(sp.exp(A*ell)*sp.exp(A*shift))
    ) == 1

    xi, n = sp.symbols("xi n", real=True)
    den = xi**2 + n**2
    assert_zero(8*den - 4*(1+den) - 4*(den-1))
    p = sp.Symbol("p", positive=True)
    s = 2*p/(p-2)
    assert_zero(1/(p/(p-1)) - sp.Rational(1, 2) - 1/s)
    assert_zero(2/(s-2) - (p-2)/2)
    assert 4*3*Fraction(1, 24) == Fraction(1, 2)
    return {
        "connection_L1_decay": str(gamma-A),
        "connection_L2_decay": str(2*gamma-A),
        "current_weight_gap": str(b-A),
        "gauge_moment_series_ratio_upper_bound": "1/2",
    }


def verify_jacobian(certificate, payload):
    operation = certificate["jacobian"]["operation_id"]
    assert operation == "polynomial.sos.decomposition.check"
    result = json.loads((ROOT / certificate["jacobian"]["output"]).read_text())
    contract = json.loads((ROOT / certificate["jacobian"]["contract"]).read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    assert status["operation_id"] == operation
    assert status["adapter_exit_code"] == 0
    assert status["timeout_seconds"] == 45
    assert status["timed_out"] is False
    assert status["adapter_error"] is None
    assert result["request"] == {"operation_id": operation, "payload": payload}
    assert result["protocol_version"] == contract["protocol_version"]
    assert result["server"]["version"] == contract["server"]["version"]
    assert contract["result"]["operation"]["operation_id"] == operation
    assert result["result"]["operation_id"] == operation
    output = result["result"]["output"]
    assert set(output) == {"polynomial", "summands", "computed_sum", "is_valid", "method"}
    assert output["is_valid"] is True
    assert output["method"] == "EXACT_COEFFICIENT_IDENTITY"
    assert output["polynomial"] == payload["polynomial"]
    assert output["summands"] == payload["summands"]
    assert output["computed_sum"] == payload["polynomial"]
    return {
        "operation_id": operation,
        "adapter_exit_code": status["adapter_exit_code"],
        "timed_out": status["timed_out"],
        "adapter_error": status["adapter_error"],
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "runtime_ms": result["result"]["runtime_ms"],
        "is_valid": output["is_valid"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-payload", action="store_true")
    args = parser.parse_args()
    payload = expected_payload()
    if args.write_payload:
        path = ROOT / "jacobian_payload.json"
        path.write_text(json.dumps(payload, indent=2) + "\n")
        print(json.dumps({"payload": str(path), "operation": "polynomial.sos.decomposition.check"}))
        return

    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    assert certificate["claim_id"] == "C_CYL_UNIFORM"
    assert certificate["certification_type"] == "analytic_proof_with_exact_algebra_replay"
    assert certificate["independent_review_required"] is True
    assert certificate["geometry"] == {
        "complex_dimension": 2,
        "K": "K >= 1",
        "r": "r > 0",
        "H": "H >= 0",
        "P": "integer P >= 4*K**2",
        "source_period": "2*pi",
        "chart_radius": "4*r",
    }
    assert json.loads((ROOT / "jacobian_payload.json").read_text()) == payload
    constants = verify_constants(certificate)
    lower_pi = verify_filling_margins(certificate)
    exponents = verify_exponents_and_gauge()
    jacobian = verify_jacobian(certificate, payload)
    print(json.dumps({
        "claim_id": "C_CYL_UNIFORM",
        "exact_algebra_replay": "pass",
        "uniform_symbolic_constants_checked": constants,
        "complex_lagrange_identity": "exact",
        "pi_rational_lower_bound": lower_pi,
        "exponents": exponents,
        "jacobian": jacobian,
        "analytic_proof": "report.md, Sections 2-7; independent human review required",
        "upstream_manuscript_inputs": "not verified by this script",
        "kernel_certification": False,
    }, indent=2))


if __name__ == "__main__":
    main()
