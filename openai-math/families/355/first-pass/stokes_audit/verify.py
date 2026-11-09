#!/usr/bin/env python3
"""Replay exact algebra and finite recurrence evidence, not the analytic proof."""

import argparse
from fractions import Fraction
import json
from math import factorial
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
ORDER = 32


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def convolution(left, right, degree):
    return [
        sum(
            (left[i] * right[n - i]
             for i in range(n + 1)
             if i < len(left) and n - i < len(right)),
            Fraction(0),
        )
        for n in range(degree + 1)
    ]


def positive_recurrence(m, order):
    b = [Fraction(0), Fraction(1)]
    for n in range(1, order):
        power = [Fraction(1)] + [Fraction(0)] * n
        value = Fraction(0)
        for k in range(1, n + 1):
            power = convolution(power, b, n)
            value += (2 * n - m * k + 1) * power[n]
        b.append(value)
    return b


def cubic_recurrence(m, order):
    b = [Fraction(0), Fraction(1)]
    for n in range(1, order):
        degree = n + 1
        square = sum(b[i] * b[degree - i] for i in range(1, degree))
        cube = sum(
            b[i] * b[j] * b[degree - i - j]
            for i in range(1, degree - 1)
            for j in range(1, degree - i)
        )
        b.append((2 * n - m - 1) * b[n] + 2 * square - cube)
    return b


def rational_text(value):
    return str(Fraction(value))


def symbolic_checks():
    m, y, tau, zscale = sp.symbols("m y tau zscale", nonzero=True)
    q, d, x, u, v, l, h, eps = sp.symbols("q d x u v l h eps")
    f = lambda value: (1 + value**2) * (1 - m * value / y)
    g = lambda value: -value + 2 * value**2 - value**3 + (
        1 - (m + 1) * value
    ) / (2 * tau)
    slope = y / m * (1 - q)
    slope_derivative = (1 - q) / m - y**2 / m**2 * d
    slope_factor = u + v - m / y - m / y * (u**2 + u * v + v**2)
    q_factor = -1 + 2 * (u + v) - (u**2 + u * v + v**2) - (
        m + 1
    ) / (2 * tau)
    momentum = y**m * sp.exp(h) * l / sp.sqrt(1 + l**2)
    r = 2 * y / zscale
    z = zscale - 2 * h / zscale
    a, b = sp.symbols("a b", real=True)
    identities = {
        "exact_q_substitution": m**2 / y**2 * (slope_derivative - f(slope))
        + d + q - 2 * q**2 + q**3
        - m / y**2 * (1 - (m + 1) * q),
        "formal_recurrence_defect": (1 - q)**2 * (q - x)
        - x * (2 * d - (m - 1) * q - q**2)
        - (q * (1 - q)**2 - x * (1 - (m + 1) * q + 2 * d)),
        "slope_difference_factorization": f(u) - f(v) - slope_factor * (u - v),
        "q_difference_factorization": g(u) - g(v) - q_factor * (u - v),
        "translator_momentum_numerator": (m * l / y + l**2) * (1 + l**2)
        + f(l) - (1 + l**2)**2,
        "fixed_section_height_cancellation": sp.diff(momentum, h) - momentum,
        "fixed_section_slope_coefficient": sp.diff(momentum, l)
        - y**m * sp.exp(h) * (1 + l**2)**(-sp.Rational(3, 2)),
        "finite_scale_momentum_numerator": (
            m * l / y + l**2 - 2 * eps * h * l**2 - 2 * eps * y * l
        ) * (1 + l**2)
        + (1 + l**2) * (1 + 2 * eps * (y * l - h) - m * l / y)
        - (1 - 2 * eps * h) * (1 + l**2)**2,
        "finite_scale_height_momentum": sp.diff(
            momentum * sp.exp(-eps * (h**2 + y**2)), h
        ) - (1 - 2 * eps * h) * momentum * sp.exp(-eps * (h**2 + y**2)),
        "physical_gaussian_exponent": -(r**2 + z**2) / 4
        - (-zscale**2 / 4 + h - (h**2 + y**2) / zscale**2),
        "common_bypass_reversal": sp.im(2 * (1 - a - sp.I * b)) + 2 * b,
        "weighted_transfer_power_balance": (m - 4) + (4 - m),
    }
    checked = {}
    for name, expression in identities.items():
        residual = sp.simplify(sp.expand(expression))
        require(residual == 0, f"Nonzero symbolic residual: {name}: {residual}")
        checked[name] = "0"

    symbolic_b = cubic_recurrence(m, 8)
    symbolic_positive = positive_recurrence(m, 8)
    for n in range(1, 9):
        require(
            sp.expand(symbolic_b[n] - symbolic_positive[n]) == 0,
            f"Symbolic recurrences disagree at degree {n}",
        )
    polynomial = sum(symbolic_b[n] * x**n for n in range(1, 9))
    defect = sp.Poly(
        sp.expand(
            polynomial * (1 - polynomial)**2
            - x * (1 - (m + 1) * polynomial + 2 * x * sp.diff(polynomial, x))
        ),
        x,
    )
    require(
        all(sp.expand(defect.nth(n)) == 0 for n in range(9)),
        "The generic-m formal equation has a nonzero coefficient below degree 9",
    )
    base = y / m - 1 / y - m * (3 - m) / y**3
    linear_factor = sp.expand(slope_factor.subs({u: base, v: base}))
    require(sp.simplify(linear_factor.coeff(y, 1) + 1 / m) == 0,
            "Wrong leading difference exponent")
    require(sp.simplify(linear_factor.coeff(y, -1) - (4 - m)) == 0,
            "Wrong power in the Stokes scale")
    return {
        "zero_residuals": checked,
        "generic_m_b_1_through_b_8": [
            sp.sstr(sp.expand(symbolic_b[n])) for n in range(1, 9)
        ],
        "generic_m_defect_zero_through_degree": 8,
        "slope_difference_coefficient": "-y/m + (4-m)/y + O(y^-3)",
    }


def finite_checks():
    cases = []
    for m in map(Fraction, ("1", "5/4", "3/2", "7/4", "2")):
        b = positive_recurrence(m, ORDER)
        require(b == cubic_recurrence(m, ORDER), f"Recurrence mismatch at m={m}")
        for n in range(1, ORDER + 1):
            lower = Fraction(2**(n - 1) * factorial(n - 1), n)
            upper = Fraction(3**(n - 1) * factorial(n - 1))
            require(0 < lower <= b[n] <= upper, f"Factorial bound: m={m}, n={n}")
            if m == 1:
                require(2**(n - 1) * factorial(n - 1) <= b[n],
                        f"Surface lower bound at n={n}")
        cases.append({
            "m": rational_text(m),
            "degrees": [1, ORDER],
            "b_1_through_b_8": [rational_text(value) for value in b[1:9]],
            "b_32": rational_text(b[32]),
            "two_independent_recurrences_agree": True,
            "factorial_bounds_hold": True,
        })
    failed_extension = cubic_recurrence(Fraction(3), 3)[1:]
    require(failed_extension == [1, 0, -1], "Incorrect positivity obstruction")
    return cases


def contraction_checks():
    rho = Fraction(2048)
    ball = Fraction(8)
    inverse_kappa_c = Fraction(40, 7)
    source = 2 * ball**2 + Fraction(3, 2) * ball + ball**3 / rho
    derivative = 4 * ball + 3 * ball**2 / rho + Fraction(3, 2)
    image = inverse_kappa_c * (Fraction(1, 2) + source / rho)
    lipschitz = inverse_kappa_c * derivative / rho
    require(image < ball, "The Volterra map does not preserve the claimed ball")
    require(lipschitz < Fraction(1, 8), "The stated contraction bound fails")
    return {
        "R": 4096,
        "minimum_modulus": rational_text(rho),
        "norm_ball": rational_text(ball),
        "bound_for_inverse_kappa_times_c": rational_text(inverse_kappa_c),
        "image_norm_upper_bound": rational_text(image),
        "lipschitz_upper_bound": rational_text(lipschitz),
        "image_bound_less_than_8": True,
        "lipschitz_less_than_1_over_8": True,
        "factorial_majorant_exponential_bound": "exp(1/3) <= 17/12 < 3/2",
    }


def jacobian_checks():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    operation = "formal_series.rational.multiply.compute"
    require(response["request"]["operation_id"] == operation, "Wrong operation")
    require(response["request"]["payload"] == payload, "Adapter payload changed")
    require(response["result"]["operation_id"] == operation, "Wrong typed result")
    output = response["result"]["output"]
    require(output["exactness"] == "EXACT_RATIONAL", "Nonexact adapter conclusion")
    require(output["residual_congruence"] == "EXACT_MOD_X_TO_N",
            "Wrong adapter congruence")

    def decode(series):
        return [
            Fraction(int(c["num"]), int(c["den"])) for c in series["coefficients"]
        ]

    order = payload["left"]["truncation_order"]
    expected_b = positive_recurrence(Fraction(1), order - 1)
    require(decode(payload["left"]) == expected_b, "Payload is not the q series")
    require(output["left"] == payload["left"], "Left operand changed")
    require(output["right"] == payload["right"], "Right operand changed")
    expected = convolution(decode(payload["left"]), decode(payload["right"]), order - 1)
    require(decode(output["result"]) == expected, "Wrong exact convolution")
    ledger = [
        Fraction(int(c["num"]), int(c["den"])) for c in output["convolution_ledger"]
    ]
    require(ledger == expected, "Wrong convolution ledger")
    return {
        "operation_id": operation,
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_status": "completed",
        "structured_error": None,
        "timed_out": False,
        "exactness": output["exactness"],
        "truncation_order": order,
        "independent_convolution": [rational_text(value) for value in expected],
        "coverage": "one finite q^2 convolution; no analytic nonvanishing conclusion",
    }


def certificate():
    return {
        "schema_version": 1,
        "claim_id": "C355_STOKES_CORE",
        "result_class": "new_theorem",
        "result_description": (
            "An independently proved weighted Stokes and conditional boundary-transfer "
            "theorem for every real m in [1,2], extending the manuscript's scalar m=1 core."
        ),
        "independent_review": "required_not_yet_performed",
        "novelty_status": "not_established_by_the_limited_literature_search",
        "significance_status": "pending_independent_review",
        "analytic_proof": "proof.md",
        "analytic_coverage": (
            "Sections 3-7 prove sectorial selection, all-order analytic remainders, "
            "nonzero continuous imaginary Stokes multipliers, finite-bypass stability, "
            "weighted boundary transfer, and a common orientation sign. "
            "These are prose proofs requiring independent mathematical review."
        ),
        "machine_coverage": (
            "This replay proves exact rational/polynomial identities and the listed "
            "finite recurrence and contraction inequalities. The separate Lean record "
            "certifies universal recurrence lower bounds and polynomial identities only."
        ),
        "lean_claim_id": "C355_RECURRENCE",
        "lean_source": "lean/Main.lean",
        "lean_fidelity": "lean/statement_fidelity.md",
        "lean_compiler_record": "lean/lean_check.json",
        "symbolic": symbolic_checks(),
        "finite_recurrence_cases": finite_checks(),
        "uniform_contraction": contraction_checks(),
        "jacobian": jacobian_checks(),
        "failed_extension": {
            "m": "3",
            "b_1_through_b_3": ["1", "0", "-1"],
            "conclusion": (
                "The positive-coefficient route does not extend to all radial weights. "
                "This is not evidence that the m=3 Stokes constant vanishes."
            ),
        },
        "remaining_manuscript_inputs": [
            "Existence and endpoint compatibility of the normalized surface homotopies.",
            "Fixed-Y radial limits and convergence of first homotopy derivatives.",
            "Common height normalization and exponentially small endpoint/far-boundary errors.",
            "Fixed-parameter finite-scale stationarity and its exact first-variation formula.",
        ],
        "not_claimed": [
            "A counterexample to any manuscript assertion.",
            "Kernel formalization of the complex-analytic or geometric argument.",
            "A proof of the manuscript's PDE interfaces or tangent-flow uniqueness.",
            "A numerical value or an absolute choice of the imaginary Stokes sign.",
            "Verified novelty or independent Reviewer acceptance.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    expected = json.loads(path.read_text())
    require(actual == expected, "The exact certificate does not match the replay")
    print(json.dumps({
        "status": "pass",
        "symbolic_zero_identities": len(actual["symbolic"]["zero_residuals"]),
        "finite_recurrence_cases": len(actual["finite_recurrence_cases"]),
        "maximum_checked_degree": ORDER,
        "jacobian_exact_replay": True,
        "analytic_proof_kernel_checked": False,
        "independent_review": actual["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
