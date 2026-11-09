#!/usr/bin/env python3
"""Replay exact algebra and genuine recorded compiler/adapter evidence."""

import json
from fractions import Fraction
from math import comb
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BUILD = (
    ROOT
    / "research/openai_manuscript"
    / "Smooth-isometric-immersions-of-closed-surfaces-into-Euclidean-four-space-September-23-2026"
    / "build"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def zero(expression, label):
    require(sp.expand(expression) == 0, label)


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "noncanonical rational in adapter evidence",
    )
    return result


def symbolic_checks():
    ux, uy, uxx, uxy, uyx, uyy, omega = sp.symbols(
        "ux uy uxx uxy uyx uyy omega"
    )
    gxxx, gxxy, gxyx, gxyy, gyyx, gyyy = sp.symbols(
        "gxxx gxxy gxyx gxyy gyyx gyyy"
    )
    hxx, hxy, hyy, cxx, cxy, bxv, bxyv = sp.symbols(
        "hxx hxy hyy cxx cxy bxv bxyv"
    )
    eliminated = uyy - gyyx * ux - gyyy * uy - hyy / 2
    dyy = 2 * uyy - 2 * gyyx * ux - 2 * gyyy * uy - 2 * eliminated
    dxx_half = uxx - gxxx * ux - gxxy * uy + omega * ux - bxv - cxx * eliminated
    dxy = uyx + uxy - 2 * gxyx * ux - 2 * gxyy * uy + omega * uy - 2 * bxyv - 2 * cxy * eliminated
    reduced_x = (
        omega * ux + uxx - gxxx * ux - gxxy * uy
        - cxx * (uyy - gyyx * ux - gyyy * uy)
        - (hxx / 2 + bxv - cxx * hyy / 2)
    )
    reduced_y = (
        omega * uy + uyx + uxy - 2 * gxyx * ux - 2 * gxyy * uy
        - 2 * cxy * (uyy - gyyx * ux - gyyy * uy)
        - (hxy + 2 * bxyv - cxy * hyy)
    )
    zero(dyy - hyy, "yy elimination")
    zero(dxx_half - hxx / 2 - reduced_x, "xx reduction")
    zero(dxy - hxy - reduced_y, "xy reduction")

    tensor = sp.Matrix([[hxx, hxy], [hxy, hyy]])
    covectors = [sp.Matrix([1, 0]), sp.Matrix([sp.Rational(1, 2), 1]), sp.Matrix([-sp.Rational(1, 2), 1])]
    coefficients = [hxx - hyy / 4, hyy / 2 + hxy, hyy / 2 - hxy]
    reconstructed = sp.zeros(2)
    for coefficient, covector in zip(coefficients, covectors):
        reconstructed += coefficient * covector * covector.T
    for entry in reconstructed - tensor:
        zero(entry, "positive phase basis identity")
    require(
        [v.subs({hxx: 1, hxy: 0, hyy: 1}) for v in coefficients]
        == [sp.Rational(3, 4), sp.Rational(1, 2), sp.Rational(1, 2)],
        "strict positivity of the reference decomposition",
    )

    x, y = sp.symbols("x y")
    zero(-y + (1 + x) * y + (-x) * y, "finite parametrix induction")
    for order in (1, 2, 4, 40):
        partial = sum((-x) ** j for j in range(order))
        zero((1 + x) * partial - (1 - (-x) ** order), "finite parametrix instance")
    lead, error, eta = sp.symbols("lead error eta")
    zero(
        (lead + eta * error) ** 2 - lead**2
        - eta * (2 * lead * error + eta * error**2),
        "quadratic mean error retains its small factor",
    )

    g1, g2, s1, s2, u1, u2, h, hs, ht, delta, next_delta = sp.symbols(
        "g1 g2 s1 s2 u1 u2 h hs ht delta next_delta"
    )
    mode_error = (
        (s1 + u1) * (s2 + u2) - s1 * s2
        - delta**2 * hs + next_delta**2 * ht
    )
    cross = (g1 - s1) * u2 + (g2 - s2) * u1
    left = h - (g1 + u1) * (g2 + u2) - next_delta**2 * h
    right = (
        (h - g1 * g2) - delta**2 * hs - mode_error - cross
        + next_delta**2 * (ht - h)
    )
    zero(left - right, "metric transfer including varying target")
    tail1, tail2 = sp.symbols("tail1 tail2")
    tail_polynomial = sp.Poly(cross.subs({g1: s1 + tail1, g2: s2 + tail2}), tail1, tail2)
    require(tail_polynomial.total_degree() == 1, "the metric-transfer tail must remain linear")

    k = sp.symbols("k", real=True)
    beta, lam = sp.Rational(6, 5), sp.Rational(11, 10)
    r = q = 40 * (k + 1)
    divisor = 2 * beta * (k + 1)
    actual = [
        k + (beta - lam) * q - divisor,
        3 * k - beta - divisor,
        2 * k + (lam - 1) * r - divisor,
        2 * k + (beta - 1) * r - divisor,
        k + (lam - 1) * r - divisor,
        k + (beta - 1) * r - divisor,
    ]
    expected = [
        (13 * k + 8) / 5,
        (3 * k - 18) / 5,
        (18 * k + 8) / 5,
        (38 * k + 28) / 5,
        (13 * k + 8) / 5,
        (33 * k + 28) / 5,
    ]
    for value, reference in zip(actual, expected):
        zero(value - reference, "displayed exponent identity")
    all_exponents = actual + [(lam - 1) * r, (beta - 1) * r, k - beta, beta - 1]
    for exponent in all_exponents:
        polynomial = sp.Poly(exponent - sp.Rational(1, 5), k)
        require(polynomial.degree() <= 1, "exponent margin must be affine")
        require(sp.diff(exponent, k) >= 0, "negative universal exponent slope")
        require(exponent.subs(k, 10) >= sp.Rational(1, 5), "insufficient exponent at k=10")
    n = sp.symbols("n", nonnegative=True)
    for parity in (0, 1):
        exponent = (2 * n + parity) + beta * (1 - n)
        require(sp.diff(exponent, n) > 0, "increment summability slope")
        require(exponent.subs(n, 5) > 1, "increment summability base")
    return {"minimum_error_exponent": str(min(v.subs(k, 10) for v in actual)), "inherited_order_gain": "1/5"}


def check_moments(order):
    coefficients = [(-1) ** (i - 1) * comb(order + 1, i) for i in range(1, order + 2)]
    powers = [1] * (order + 1)
    for degree in range(order + 1):
        moment = sum(c * p for c, p in zip(coefficients, powers))
        require(moment == (1 if degree == 0 else 0), f"moment cancellation r={order}, degree={degree}")
        powers = [p * i for i, p in enumerate(powers, 1)]
    return coefficients


def check_jacobian(certificate):
    spec = certificate["jacobian"]
    request = read_json(spec["payload"])
    response = read_json(spec["output"])
    status = read_json(spec["status"])
    discovery = read_json("jacobian_discovery.json")
    contract = read_json("jacobian_contract.json")
    operation = spec["operation_id"]
    require(status["adapter_exit_code"] == 0 and status["timeout"] is False, "adapter did not complete successfully")
    require(status["operation_id"] == operation, "status operation mismatch")
    require(response["protocol_version"] == spec["protocol_version"], "protocol mismatch")
    require(response["server"]["version"] == spec["server_version"], "server version mismatch")
    require(response["request"] == {"operation_id": operation, "payload": request}, "source payload mismatch")
    require(response["result"]["operation_id"] == operation, "output operation mismatch")
    require(contract["result"]["operation"]["operation_id"] == operation, "contract operation mismatch")
    require(operation in [m["operation_id"] for m in discovery["result"]["matches"]], "operation was not discovered")
    output = response["result"]["output"]
    require(output["outcome"] == "UNIQUE", "UNKNOWN or nonunique output is not support")
    require(output["matrix"] == request["matrix"] and output["rhs"] == request["rhs"], "typed output source mismatch")
    matrix = [[rational(v) for v in row] for row in request["matrix"]["entries"]]
    rhs = [rational(v) for v in request["rhs"]]
    solution = [rational(v) for v in output["solution"]]
    require(matrix == [[Fraction(i**j) for i in range(1, 6)] for j in range(5)], "wrong moment system")
    require(rhs == [1, 0, 0, 0, 0], "wrong moment right-hand side")
    require(solution == spec["solution"] == check_moments(4), "wrong smoothing coefficients")
    require(
        [sum(a * x for a, x in zip(row, solution)) for row in matrix] == rhs,
        "independent rational replay failed",
    )
    require(sp.Matrix(matrix).det() != 0, "missing uniqueness certificate")


def check_lean(certificate):
    spec = certificate["lean"]
    result = read_json(spec["compiler_result"])
    archive = read_json(spec["archive"])
    require(result["status"] == "success" and result["exit_code"] == 0, "no successful real compiler result")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0, "formal proof holes or failed axiom audit")
    require(spec["version"] in result["tools"]["lean"]["version"], "unexpected Lean version")
    require(archive["lean_source"]["text"] == (HERE / spec["source"]).read_text(encoding="utf-8"), "Lean source changed since compilation")
    require(
        archive["statement_fidelity"]["text"]
        == (HERE / spec["statement_fidelity"]).read_text(encoding="utf-8"),
        "statement fidelity changed since compilation",
    )
    require(archive["subject"]["subject_id"] == spec["claim"], "compiler evidence attached to wrong claim")
    require(archive["lean_check"]["source_sha256"] == result["source_sha256"], "archive/compiler mismatch")
    require(
        result["kernel"]["recorded"]["artifact"] == str((HERE / spec["archive"]).relative_to(ROOT)),
        "compiler evidence was not archived in the ledger",
    )


def check_source_anchors():
    anchors = {
        "exact-correction.tex": [
            r"\label{prop:exact-correction}",
            r"\label{lem:exact-step}",
            r"\label{eq:exact-all-order-recurrence}",
            r"\label{eq:exact-error-identity}",
            "The integers $R,N$ do not depend on the constants",
            "The scale threshold and the constants are independent of derivatives",
            r"R=r(10)=440",
        ],
        "small-modes.tex": [
            r"\label{prop:small-increment}",
            r"\label{eq:normal-elimination}",
            r"\label{eq:mean-map-difference}",
            r"\label{rem:small-polynomial-control}",
            "Their required orders may increase with $q$.",
        ],
        "preliminaries.tex": [
            r"\label{lem:polynomial-phase-data}",
            "No regularity with respect to $z$ is required.",
            "independent of the",
        ],
    }
    for filename, phrases in anchors.items():
        text = (BUILD / filename).read_text(encoding="utf-8")
        for phrase in phrases:
            require(phrase in text, f"staged source anchor missing: {filename}: {phrase}")


def main():
    certificate = read_json("exact_certificate.json")
    require(certificate["statement"]["retained_order_R"] == 440, "wrong retained order")
    require(certificate["independent_review"] == "pending", "this script cannot manufacture independent acceptance")
    check_source_anchors()
    margins = symbolic_checks()
    for order in certificate["moment_orders_replayed"]:
        check_moments(order)
    check_jacobian(certificate)
    check_lean(certificate)
    print(json.dumps({
        "status": "pass",
        "claim": certificate["claim"],
        "result": "exact_algebra_and_recorded_formal_core_replayed",
        "retained_order": 440,
        "moment_orders": certificate["moment_orders_replayed"],
        "exponent_margins": margins,
        "lean_version": certificate["lean"]["version"],
        "proof_holes": [],
        "analytic_proof": "theorem.md",
        "independent_mathematical_review": "required",
        "main_theorem": "not_certified",
    }, indent=2))


if __name__ == "__main__":
    main()
