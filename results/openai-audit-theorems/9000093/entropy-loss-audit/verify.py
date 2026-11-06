#!/usr/bin/env python3
"""Replay exact algebra and the strictness construction, not the analytic proof."""

import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def exact_checks():
    checked = []

    def equal(name, left, right=0):
        difference = sp.simplify(sp.cancel(left - right))
        require(difference == 0, f"{name}: nonzero remainder {difference}")
        checked.append(name)

    b, delta = sp.symbols("b delta", positive=True)
    j = sp.symbols("j", integer=True, nonnegative=True)
    alpha = lambda k: b / (b + k * delta)
    weight = b**2 * delta / ((b + j * delta) * (b + (j + 1) * delta))

    equal(
        "nested_multiplier_normal_equation",
        b * (1 - alpha(j)),
        j * delta * alpha(j),
    )
    equal(
        "nested_weight_difference",
        alpha(j) - alpha(j + 1),
        b * delta / ((b + j * delta) * (b + (j + 1) * delta)),
    )
    equal(
        "component_minimum",
        b * (1 - alpha(j)) ** 2 + j * delta * alpha(j) ** 2,
        b * j * delta / (b + j * delta),
    )
    penalty = lambda k: b * k * delta / (b + k * delta)
    equal("telescoping_induction_step", penalty(j + 1) - penalty(j), weight)
    equal("telescoping_initial_value", penalty(0))
    equal(
        "cell_weight_exact_integral",
        weight,
        b**2 * (1 / (b + j * delta) - 1 / (b + (j + 1) * delta)),
    )

    # These are Gram entries, so the identities do not fix a dimension.
    w2, v_b_v, w_v, star_b_star = sp.symbols("w2 v_b_v w_v star_b_star")
    true_quadratic = b * w2 - 2 * b * w_v + v_b_v
    minimum = b * w2 - star_b_star
    b_norm_difference = v_b_v - 2 * b * w_v + star_b_star
    equal(
        "universal_square_completion",
        true_quadratic - minimum,
        b_norm_difference,
    )

    qv2, qg2, pg2, qv_qg = sp.symbols("qv2 qg2 pg2 qv_qg")
    equal(
        "orthogonal_dual_remainder",
        qv2 - (2 * qv_qg - qg2 - pg2),
        qv2 - 2 * qv_qg + qg2 + pg2,
    )

    v2, v02, v_v0, s2, v_s, g2 = sp.symbols("v2 v02 v_v0 s2 v_s g2")
    # Substitute W=v0+(delta/b)S and <v0,S>=sum_i ||g_i||^2=g2.
    w_norm2 = v02 + 2 * delta * g2 / b + delta**2 * s2 / b**2
    w_v = v_v0 + delta * v_s / b
    dual_value = b * (w_norm2 + v2 - 2 * w_v) + 2 * delta * v_s - delta * g2
    dual_minimum = delta**2 * s2 / b + delta * g2
    equal(
        "universal_dual_completion",
        dual_value - dual_minimum,
        b * (v2 + v02 - 2 * v_v0),
    )

    t, u, information = sp.symbols("t u information", positive=True)
    equal("heat_time_change_of_variables", sp.diff(1 / (b + t), t), -1 / (b + t) ** 2)
    equal(
        "finite_precision_boundary_term",
        information / b - information * (1 / b - 1 / (b + u)),
        information / (b + u),
    )
    equal(
        "prediction_integral_constant_part",
        sp.integrate(information / (b + t) ** 2, (t, 0, u)),
        information * (1 / b - 1 / (b + u)),
    )

    k, excess = sp.symbols("K excess", positive=True)
    conditional_mean = k + excess
    equal(
        "uniform_integrability_truncation",
        conditional_mean - k / 2 - conditional_mean / 2,
        excess / 2,
    )
    require((excess / 2).is_positive is True, "UI truncation sign")
    eta = sp.symbols("eta", positive=True)
    equal(
        "sublinear_rank_epsilon_allocation",
        eta,
        k * (eta / (2 * k)) + 2 * (eta / 4),
    )

    n = sp.symbols("n", integer=True, nonnegative=True)
    equal(
        "exponential_remainder_coefficient",
        (n + 2) * (n + 1) - 2,
        n * (n + 3),
    )
    require((n * (n + 3)).is_nonnegative is True, "Taylor coefficient sign")

    epsilon, score2, position2, cross = sp.symbols(
        "epsilon score2 position2 cross", real=True
    )
    equal(
        "damped_score_quadratic_bound",
        2 * score2 + 8 * epsilon**2 * position2
        - (score2 - 4 * epsilon * cross + 4 * epsilon**2 * position2),
        score2 + 4 * epsilon * cross + 4 * epsilon**2 * position2,
    )

    v, r = sp.symbols("v r", positive=True)
    score, output = sp.symbols("score output", real=True)
    initial_conditional_score = (1 + r / v) * score + output / v
    relative_heat_score = score + output / (v + r)
    equal(
        "gaussian_reference_exclusion",
        initial_conditional_score,
        (v + r) * relative_heat_score / v,
    )
    equal("gaussian_contraction_gap", 1 - v / (v + r), r / (v + r))
    require((r / (v + r)).is_positive is True, "Gaussian contraction sign")

    x = sp.symbols("x", real=True)
    p = 2 / (sp.pi * (1 + x**2) ** 2)
    equal("heavy_tail_normalization", sp.integrate(p, (x, -sp.oo, sp.oo)), 1)
    equal(
        "heavy_tail_first_absolute_moment",
        2 * sp.integrate(x * p, (x, 0, sp.oo)),
        2 / sp.pi,
    )
    potential = sp.sqrt(1 + x**2)
    equal(
        "reference_positive_curvature",
        sp.diff(potential, x, 2),
        (1 + x**2) ** sp.Rational(-3, 2),
    )
    equal(
        "heavy_tail_relative_score",
        sp.diff(sp.log(p), x) + sp.diff(potential, x),
        -4 * x / (1 + x**2) + x / sp.sqrt(1 + x**2),
    )
    positive_x = sp.symbols("positive_x", nonnegative=True)
    equal(
        "bounded_rational_score",
        2 - 4 * positive_x / (1 + positive_x**2),
        2 * (positive_x - 1) ** 2 / (1 + positive_x**2),
    )
    require(
        (2 * (positive_x - 1) ** 2 / (1 + positive_x**2)).is_nonnegative is True,
        "Rational score bound sign",
    )
    equal(
        "reference_linear_tail_lower_square",
        (1 + positive_x**2) - positive_x**2,
        1,
    )
    equal(
        "reference_linear_tail_upper_square",
        (1 + positive_x) ** 2 - (1 + positive_x**2),
        2 * positive_x,
    )
    equal(
        "heavy_tail_denominator_bound",
        4 * (1 + positive_x) ** 2 - (2 + positive_x) ** 2,
        positive_x * (4 + 3 * positive_x),
    )
    c = sp.symbols("c", positive=True)
    equal(
        "infinite_square_exponential_moment_lower_bound",
        (2 / sp.pi) * (c**3 * x**6 / 6) / (4 * x**4),
        c**3 * x**2 / (12 * sp.pi),
    )
    return checked


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0 and status["timeout"] is False, "Adapter failure")
    require((HERE / "jacobian_stderr.txt").read_text() == "", "Unexpected adapter stderr")
    require(response["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(response["server"]["version"] == "0.14.0", "Unexpected server version")
    operation = "matrix.rational_linear_system.solve"
    require(response["request"]["operation_id"] == operation, "Wrong requested operation")
    require(response["request"]["payload"] == payload, "Payload was not retained exactly")
    require(response["result"]["operation_id"] == operation, "Wrong result operation")
    output = response["result"]["output"]
    require(output["outcome"] == "UNIQUE", "No unique exact solution")
    require(output["convention"] == "LINEAR_SYSTEM_CLASSIFICATION_OVER_QQ", "Wrong convention")
    require(output["matrix"] == payload["matrix"] and output["rhs"] == payload["rhs"], "Wrong system")

    def rational(value):
        result = Fraction(int(value["num"]), int(value["den"]))
        require(str(result.numerator) == value["num"], "Noncanonical numerator")
        require(str(result.denominator) == value["den"], "Noncanonical denominator")
        return result

    matrix = [[rational(value) for value in row] for row in output["matrix"]["entries"]]
    rhs = [rational(value) for value in output["rhs"]]
    solution = [rational(value) for value in output["solution"]]
    require(
        [sum(a * x for a, x in zip(row, solution)) for row in matrix] == rhs,
        "Exact linear-system witness failed",
    )
    require(solution == [Fraction(3, 4), Fraction(-1, 4)], "Wrong minimizer")
    qv = [(solution[0] + solution[1]) / 2] * 2
    value = 2 * ((1 - solution[0]) ** 2 + solution[1] ** 2)
    value += 2 * sum(x**2 for x in qv)
    require(value == Fraction(1, 2), "Singular-projection variational check failed")


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "C_ENTROPY_NO_MOMENT", "Wrong theorem")
    require(certificate["extra_moment_assumption"] is False, "Statement drift")
    require(certificate["mechanical_scope"]["analytic_proof_kernel_checked"] is False, "Overclaim")
    extension = certificate["structural_extension"]
    require(
        extension["finite_observation_entropy_cost_assumes_exponential_square_moment"] is True
        and extension["residual_bound_requires_only_finite_relative_fisher"] is True,
        "Discarded-rank extension hypotheses drifted",
    )
    checked = exact_checks()
    require(checked == certificate["exact_symbolic_checks"], "Certificate/check list mismatch")
    check_jacobian()
    print(json.dumps({
        "ok": True,
        "exact_symbolic_checks": len(checked),
        "jacobian_witness": "verified over QQ",
        "heavy_tail_construction": "verified by exact identities and analytic bounds",
        "analytic_proof": "report.md; independent review required",
        "universal_analytic_proof_kernel_checked": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
