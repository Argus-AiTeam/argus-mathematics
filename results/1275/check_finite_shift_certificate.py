#!/usr/bin/env python3
"""Replay the exact algebra in finite_shift_obstruction.md, not its analysis.

Run from the campaign root:
  /home/argustest/zimo/argus-live-update/.venv/bin/python \
      research/check_finite_shift_certificate.py

Requires the already installed SymPy. No network or Jacobian process is needed.
"""

import json
from pathlib import Path

import sympy as sp


def main():
    here = Path(__file__).resolve().parent
    checks = []

    def require(condition, label):
        if not condition:
            raise AssertionError(label)
        checks.append(label)

    def zero(expression, label):
        require(sp.simplify(expression) == 0, label)

    def rational(value):
        return sp.Rational(value["num"], value["den"])

    payload = json.loads((here / "finite_shift_box_payload.json").read_text())
    response = json.loads((here / "finite_shift_box_output.json").read_text())
    process = json.loads((here / "finite_shift_box_process.json").read_text())
    operation = "polynomial.box.enclosure.compute"
    require(
        process["exit_code"] == 0
        and process["timeout"] is False
        and process["operation_id"] == operation,
        "adapter_completed_without_timeout",
    )
    require(
        response.get("error") is None
        and response["result"].get("error") is None,
        "adapter_has_no_structured_error",
    )
    require(
        response["request"]["operation_id"] == operation
        and response["result"]["operation_id"] == operation
        and response["request"]["payload"] == payload,
        "typed_result_is_bound_to_retained_operation_and_payload",
    )
    output = response["result"]["output"]
    require(
        output["polynomial"] == payload["polynomial"]
        and output["box"] == payload["box"],
        "typed_result_retains_the_exact_source_polynomial_and_box",
    )

    u = sp.Symbol("u", real=True)
    require(
        payload["polynomial"]["domain"] == "QQ"
        and payload["box"]["domain"] == "QQ"
        and payload["polynomial"]["variables"] == ["u"]
        and payload["box"]["variables"] == ["u"],
        "cutoff_enclosure_has_the_declared_rational_axis",
    )
    polynomial = sum(
        rational(term["coefficient"]) * u ** term["exponents"][0]
        for term in payload["polynomial"]["polynomial"]["terms"]
    )
    zero(polynomial - (sp.Rational(1, 4) - u**2), "cutoff_polynomial_identity")
    interval = payload["box"]["intervals"][0]
    lower, upper = rational(interval["lower"]), rational(interval["upper"])
    require(
        (lower, upper) == (-sp.Rational(1, 6), sp.Rational(1, 6)),
        "cutoff_input_interval",
    )
    exact_lower = sp.Rational(1, 4) - upper**2
    exact_upper = sp.Rational(1, 4)
    require(
        (rational(output["enclosure"]["lower"]),
         rational(output["enclosure"]["upper"]))
        == (exact_lower, exact_upper)
        == (sp.Rational(2, 9), sp.Rational(1, 4)),
        "independent_exact_square_interval_replay",
    )

    t = sp.Symbol("t", positive=True)
    j = sp.Symbol("j", integer=True, nonnegative=True)
    v = t * (1 - t)
    w = sp.Symbol("v", positive=True)
    coefficient, coefficient_prime, v_prime = sp.symbols("A A_prime v_prime")
    cutoff_expression = sp.exp(-1 / w) * w ** (-2 * j) * coefficient
    recurrence = w**2 * coefficient_prime + v_prime * (
        1 - 2 * j * w
    ) * coefficient
    normalized_derivative = (
        sp.diff(cutoff_expression, w) * v_prime
        + sp.diff(cutoff_expression, coefficient) * coefficient_prime
    ) / (
        sp.exp(-1 / w) * w ** (-2 * j - 2)
    )
    zero(
        normalized_derivative - recurrence,
        "cutoff_induction_step_for_symbolic_nonnegative_integer_j",
    )

    cutoff_polynomials = [sp.Integer(1)]
    for order in range(2):
        current = cutoff_polynomials[-1]
        cutoff_polynomials.append(
            sp.expand(
                v**2 * sp.diff(current, t)
                + sp.diff(v, t) * (1 - 2 * order * v) * current
            )
        )
    zero(cutoff_polynomials[1] - (1 - 2 * t), "displayed_A1")
    zero(
        cutoff_polynomials[2] - (1 - 6*t + 12*t**2 - 12*t**3 + 6*t**4),
        "displayed_A2",
    )
    bounds = [
        sp.factorial(2 * order)
        * sum(abs(coefficient) for coefficient in sp.Poly(poly, t).all_coeffs())
        for order, poly in enumerate(cutoff_polynomials)
    ]
    require(bounds == [1, 6, 888], "displayed_U0_U1_U2")
    zero(v - (sp.Rational(1, 4) - (t - sp.Rational(1, 2))**2),
         "centered_cutoff_identity")
    h = sp.Rational(1, 486)
    require(
        sp.Rational(9, 2) < 5
        and sp.Rational(1, 243**2 * 3) > h**2,
        "rational_steps_in_cutoff_L2_lower_bound",
    )

    x = sp.Symbol("x", positive=True)
    length = sp.Symbol("L", positive=True)
    center = sp.Symbol("R", real=True)
    beta = sp.Symbol("beta")
    lam = sp.Symbol("lambda", real=True)
    shift = sp.Symbol("a", nonnegative=True)
    f = sp.Function("f")
    F = sp.Function("F")
    s = (sp.log(x) - center) / length
    Fprime = sp.diff(F(t), t).subs(t, s)
    zero(
        sp.diff(x**beta * F(s), x)
        - x**(beta - 1) * (beta * F(s) + Fprime / length),
        "generic_log_cutoff_derivative_step",
    )

    def dilation(expression):
        return -sp.I * (2 * x * sp.diff(expression, x) + expression)

    zero(
        dilation(f(x - shift))
        - dilation(f(x)).subs(x, x - shift)
        + 2 * sp.I * shift * sp.diff(f(x - shift), x),
        "generic_dilation_translation_commutator",
    )
    alpha = -sp.Rational(1, 2) + sp.I * lam / 2
    zero(-sp.I * (2 * alpha + 1) - lam, "dilation_eigenvalue_sign_and_scale")
    zero(
        dilation(x**alpha * F(s)) - lam * x**alpha * F(s)
        + 2 * sp.I / length * x**alpha * Fprime,
        "generic_log_cutoff_residual_identity",
    )
    zero(2 * sp.re(alpha) + 1, "logarithmic_L2_weight")
    zero(sp.integrate(t, (t, 0, 1)) - sp.Rational(1, 2),
         "one_coordinate_cube_first_moment")

    X = sp.Symbol("X")
    R1 = X + alpha + 1
    d = sp.Poly(sp.expand((X + alpha) * R1), X)
    zero(d.nth(0) - alpha * (alpha + 1), "BBM_d0")
    zero(d.nth(1) - sp.I * lam, "BBM_d1")
    zero(d.nth(2) - 1, "BBM_d2")
    rho_squared = (1 + lam**2) / 4
    zero(alpha * sp.conjugate(alpha) - rho_squared, "BBM_alpha_modulus_squared")
    zero(
        (alpha + 1) * sp.conjugate(alpha + 1) - rho_squared,
        "BBM_c0_modulus_squared",
    )
    zero(
        d.nth(0) * sp.conjugate(d.nth(0)) - rho_squared**2,
        "BBM_d0_modulus_squared",
    )
    rho = sp.Rational(1, 2)
    A = bounds[1]
    B = rho * bounds[1] + bounds[2]
    C = rho**2 + bounds[2]
    kappa = rho * h
    threshold = sp.ceiling((2 * A + C) / kappa)
    residual_constant = 4 * (B + C / 2) / kappa
    require(
        (threshold, residual_constant) == (875043, 5190966),
        "BBM_lambda_zero_threshold_and_residual_constant",
    )
    require(
        (A + C / 2) / threshold <= kappa / 2,
        "BBM_lambda_zero_normalization_threshold",
    )

    print(json.dumps({
        "status": "pass",
        "classification": "exact symbolic and rational arithmetic replay",
        "scope": (
            "Symbolic one-step identities hold for the declared parameters. "
            "The example arithmetic concerns only P=1-z, lambda=0. "
            "Domains, smooth cutoff bounds, all-order induction, weak convergence, "
            "and the all-extension essential-spectrum theorem require the prose proof."
        ),
        "proof": "finite_shift_obstruction.md",
        "replay": (
            "/home/argustest/zimo/argus-live-update/.venv/bin/python "
            "research/check_finite_shift_certificate.py"
        ),
        "sympy_version": sp.__version__,
        "jacobian_server_version": response["server"]["version"],
        "jacobian_protocol": response["protocol_version"],
        "jacobian_operation": operation,
        "jacobian_process_exit": process["exit_code"],
        "jacobian_timeout": process["timeout"],
        "checks": checks,
        "cutoff_bounds_U0_U1_U2": [int(bound) for bound in bounds],
        "cutoff_norm_lower_bound": str(h),
        "cutoff_interval_enclosure": [str(exact_lower), str(exact_upper)],
        "BBM_lambda_zero": {
            "N": int(threshold),
            "K": int(residual_constant),
        },
        "independent_review": "not_performed",
        "novelty_status": "unverified",
    }, indent=2))


if __name__ == "__main__":
    main()
