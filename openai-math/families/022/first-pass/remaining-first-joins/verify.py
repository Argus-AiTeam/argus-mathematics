#!/usr/bin/env python3
"""Replay exact local algebra and parameter margins, not the analytic proof."""

import argparse
import json
from fractions import Fraction
from math import gcd
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PRIMES = (2, 3, 5, 7, 11, 101)
MAX_EXPONENT = 12


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def identity(left, right, name):
    require(sp.cancel(left - right) == 0, name)
    return name


def power(p, exponent):
    return Fraction(p**exponent) if exponent >= 0 else Fraction(1, p**-exponent)


def symbolic_local_checks():
    x, h, t, k = sp.symbols("x h t k")
    f0 = (1 + 6 * x + x**2) / (1 - x)**2
    fh = ((2 * h + 1) + 6 * x + (1 - 2 * h) * x**2) / (1 - x)**2
    names = [
        identity(f0, 1 + 8 * x / (1 - x)**2, "common_mask_generating_function"),
        identity(
            fh, f0 + 2 * h * (1 + x) / (1 - x),
            "discrepant_mask_generating_function",
        ),
        identity(
            (1 + 32 * x - f0) * (1 - x)**2,
            8 * x * (1 - 2 * x) * (3 - 2 * x),
            "common_mask_bound_positive_factorization",
        ),
        identity(
            ((2 * h + 1) * f0 - fh) * (1 - x)**2,
            4 * h * x * (3 + x),
            "discrepant_mask_comparison_positive_factorization",
        ),
        identity((h + 1)**2 - (2 * h + 1), h**2, "divisor_square_allowance"),
        identity(
            ((t + 1)**2 * (1 + 4 * x) - (1 + 2 * t + 2 * x / (1 - x)))
            * (1 - x),
            t**2 * (1 - x) + 2 * x * (t**2 + 2 * t)
            + 2 * x * (t + 1)**2 * (1 - 2 * x),
            "conditional_free_deficit_bound",
        ),
        identity(
            (1 + 4 * x) * (1 - x) - (1 + x),
            2 * x * (1 - 2 * x),
            "conditional_geometric_tail_bound",
        ),
        identity(
            (h + 1) * (t + 1) - (h + t + 1),
            h * t,
            "conditional_allowance_product",
        ),
        identity(
            (1 + 2 * x) * (1 - x) - 1,
            x * (1 - 2 * x),
            "coincident_static_residue_bound",
        ),
        identity(
            (1 - x)**2 - (1 - 2 * x),
            x**2,
            "distinct_static_residue_bound",
        ),
        identity(
            (8 * k + 4 * h) - 2 * (8 * (k - 1) + 4 * h)
            + (8 * (k - 2) + 4 * h),
            0,
            "all_higher_generating_function_coefficients_recur",
        ),
    ]
    require(sp.expand(fh * (1 - x)**2).coeff(x, 0) == 2 * h + 1,
            "constant coefficient")
    require((8 + 4 * h) - 2 * (2 * h + 1) == 6, "linear coefficient")
    require(sp.expand((16 + 4 * h) - 2 * (8 + 4 * h) + (2 * h + 1))
            == 1 - 2 * h, "quadratic coefficient")
    return {
        "identities": names,
        "sign_domain": "0 <= x <= 1/2; h,t >= 0",
        "sign_reason": "Every displayed factor or summand is nonnegative on this domain.",
        "infinite_series_step": "Geometric tails tend to zero for 0 <= x <= 1/2; proved in report.md.",
    }


def finite_prime_exponent_checks():
    gcd_cases = conditional_cases = deficit_cases = grid_identity_cases = 0
    for p in PRIMES:
        x = Fraction(1, p)
        for n in range(MAX_EXPONENT + 1):
            for m in range(MAX_EXPONENT + 1):
                u, v = max(n - m, 0), max(m - n, 0)
                total = Fraction(0)
                for a in range(n + 1):
                    for b in range(m + 1):
                        ratio = power(p, min(v + a, u + b) - a - b)
                        actual = Fraction(gcd(p**(n-a), p**(m-b)), p**min(n, m))
                        require(actual == ratio, "projected-grid gcd identity")
                        total += 2**((a > 0) + (b > 0)) * ratio
                        grid_identity_cases += 1
                h = abs(n - m)
                infinite = ((2 * h + 1) + 6 * x + (1 - 2 * h) * x*x) / (1 - x)**2
                require(total <= infinite <= (h + 1)**2 * (1 + 32 * x),
                        f"gcd mask p={p}, n={n}, m={m}")
                gcd_cases += 1
                for c in range(m + 1):
                    w = m - c
                    total = sum(
                        2**(a > 0) * power(p, min(w, n - a) - w)
                        for a in range(n + 1)
                    )
                    exterior_inverse = power(p, -max(w - n, 0))
                    bound = exterior_inverse * (u + 1)**2 * (c + 1)**2 * (1 + 4*x)
                    require(total <= bound, f"conditional p={p}, n={n}, m={m}, c={c}")
                    conditional_cases += 1
            if n:
                law = [
                    (1 - x) * power(p, -a) if a < n else power(p, -n)
                    for a in range(n + 1)
                ]
                require(sum(law) == 1, "deficit law normalization")
                require(sum(law[1:]) == x, "forced omission probability")
                require(law[1] <= x, "forced deficit exactly one")
                deficit_cases += 1
    return {
        "primes": list(PRIMES),
        "centre_exponents": [0, MAX_EXPONENT],
        "gcd_cases": gcd_cases,
        "actual_projected_grid_identities": grid_identity_cases,
        "conditional_cases": conditional_cases,
        "deficit_law_cases": deficit_cases,
        "classification": "bounded adversarial regression tests, not a universal proof",
    }


def determinant_cycle_checks():
    cases = 0
    for p in (2, 3, 5, 7):
        ordinary = Fraction(p-1, p)
        for nu in (1, 2):
            common = p**nu
            for u, t in ((1, 1), (1, 2), (2, 3)):
                if (u*t) % p == 0:
                    continue
                v = common*u
                for n in range(p):
                    points = [
                        (z, (t*z-n)//u) for z in range(v) if (t*z-n) % u == 0
                    ]
                    require(len(points) == common, "determinant cycle length")
                    for forbidden_left in range(p):
                        for forbidden_right in range(p):
                            observed = Fraction(sum(
                                z % p != forbidden_left and zz % p != forbidden_right
                                for z, zz in points
                            ), common)
                            coincident = (
                                n - t*forbidden_left + u*forbidden_right
                            ) % p == 0
                            expected = ordinary if coincident else 1 - Fraction(2, p)
                            require(observed == expected, "static coincidence orientation")
                            require(
                                observed / ordinary**2
                                <= 1 + Fraction(2, p)*coincident,
                                "static cycle density majorant",
                            )
                            cases += 1
    return {
        "primes": [2, 3, 5, 7],
        "common_exponents": [1, 2],
        "cycles_and_residue_tests": cases,
        "classification": "bounded actual-grid orientation tests; universal argument is in report.md",
    }


def positive_rational_certificate(expression, variables, name):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    npoly = sp.Poly(numerator, *variables)
    dpoly = sp.Poly(denominator, *variables)
    for poly, label in ((npoly, "numerator"), (dpoly, "denominator")):
        require(all(c >= 0 for c in poly.coeffs()), f"{name}: {label} signs")
        require(poly.coeff_monomial(1) > 0, f"{name}: {label} constant")
    return {
        "name": name,
        "numerator_terms": len(npoly.terms()),
        "denominator_terms": len(dpoly.terms()),
        "numerator_constant": str(npoly.coeff_monomial(1)),
        "denominator_constant": str(dpoly.coeff_monomial(1)),
        "all_coefficients_nonnegative": True,
        "positive_constants": True,
    }


def parameter_checks():
    d, a, b = sp.symbols("d a b", nonnegative=True)
    D, A = 64 + d, 8 + a
    beta = 64 * (3 * D + 3) + b
    eta = sp.Rational(3, 200)
    eps = eta / (128 * (beta * A + 2))
    delta = eps
    theta = eta / 128
    sprime = eta / (128 * D)
    slow = sprime / 100
    ud = sp.Rational(3, 4)
    uw = sp.Rational(201, 400)
    density_cost = sp.Rational(4, 25) + sp.Rational(33, 25) * (ud - sp.Rational(1, 2))
    variables = (d, a, b)
    margins = {
        "distant_decay_beyond_one":
            beta/32 - 3*D - (4*density_cost + 2*eps)/A - 1,
        "distant_ut_power_budget": sp.Rational(1, 16) - eps - delta,
        "width_ut_power_budget": sp.Rational(1, 800) - eps - delta,
        "width_harmonic_budget": sp.Rational(1, 100) - 2*eps - D*slow,
        "mixed_exterior_saving_beyond_eta_over_two":
            eta/2 - eps*(2 + beta*A/2) - delta*beta*A/2
            - D*slow - D*sprime - 4*theta,
        "bad_omission_inverse_density": A/4 - sp.Rational(16, 25),
        "linked_restore_exponent_below_25": 25 - 24 - sp.Rational(32, 25)/A,
        "band_separation_implies_shell_ratio": sp.Rational(1, 100) - 2*theta,
    }
    certificates = [
        positive_rational_certificate(expr, variables, name)
        for name, expr in margins.items()
    ]
    width_shell_margin = (
        sp.Rational(3, 8) * sp.Rational(13, 20)
        - (sp.Rational(4, 25) + sp.Rational(33, 25) * (uw - sp.Rational(1, 2)))
        * sp.Rational(101, 100)
        - sp.Rational(1, 100) - sp.Rational(1, 20)
    )
    exact_margins = {
        "distant_tensor": sp.Rational(3, 8) - (1 - ud),
        "width_tensor": sp.Rational(399, 800) - (1 - uw),
        "width_shell_beyond_reserved_1_over_20": width_shell_margin,
        "bad_log_moment_beyond_1_over_4":
            sp.Rational(3, 10) - 8*sp.Rational(1, 320) - sp.Rational(1, 4),
        "common_outer_mask_with_Eg_at_least_2": 2 - sp.Rational(16, 25),
        "distant_mass_power_beyond_goal": 2*ud - sp.Rational(201, 200),
        "quadratic_mass_power_beyond_goal": 2 - sp.Rational(201, 200),
    }
    require(all(v > 0 for v in exact_margins.values()), "strict rational margins")
    return {
        "universality": "All d,a,b >= 0, not a numerical feasible-point test.",
        "family": {
            "D": "64+d",
            "A0": "8+a, enlarged further for the pre-existing geometric constraints",
            "beta": "64*(3*D+3)+b",
            "eta": "3/200",
            "epsilon": "eta/(128*(beta*A0+2))",
            "divisor_power_delta": "epsilon",
            "s_prime": "eta/(128*D)",
            "s_low_upper_bound": "s_prime/100; may be made smaller for mask purge",
            "band_ratio_theta_upper_bound": "eta/128",
            "kappa_upper_bound": "min(1/320,s_low/(100*A0))",
        },
        "positive_coefficient_certificates": certificates,
        "exact_strict_margins": {k: str(v) for k, v in exact_margins.items()},
        "goal_c": "1/200",
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    contract = json.loads((HERE / "jacobian-contract.json").read_text())
    archived = json.loads((HERE / "jacobian-output.json").read_text())
    status = json.loads((HERE / "jacobian-run-status.json").read_text())
    operation = "combinatorics.generating_function.coefficients.compute"
    require(status["adapter_exit_code"] == 0 and not status["timeout"], "adapter status")
    require(archived["request"]["operation_id"] == operation, "operation binding")
    require(archived["result"]["operation_id"] == operation, "typed result binding")
    require(status["operation_id"] == operation, "adapter receipt binding")
    require(archived["request"]["payload"] == payload, "exact payload binding")
    require(contract["operation_id"] == operation, "inspected contract binding")
    require(archived["server"]["version"] == contract["server"]["version"], "server version")
    require(archived["protocol_version"] == contract["protocol_version"], "protocol")
    result = archived["result"]["output"]
    for key in ("coefficient_convention", "expansion_point"):
        require(result[key] == payload[key], f"typed {key}")
    require(result["exactness"] == "EXACT_RATIONAL", "Jacobian exactness")
    require(result["determinism"] == "DETERMINISTIC", "Jacobian determinism")
    coefficients = [Fraction(int(q["num"]), int(q["den"])) for q in result["coefficients"]]
    require(coefficients == [Fraction(1)] + [Fraction(8*k) for k in range(1, 13)],
            "typed coefficient prefix")
    require(all(int(q["num"]) == 0 and q["den"] == "1"
                for q in result["residual_coefficients"]), "typed residual congruence")
    require(len(result["residual_coefficients"]) == 13, "residual output shape")
    require(result["residual_congruence"]
            == "DENOMINATOR_TIMES_SERIES_MINUS_NUMERATOR_IS_ZERO_MOD_X_TO_ORDER",
            "typed residual meaning")
    require(result["truncation_order"] == payload["truncation_order"] == 13,
            "bounded truncation")
    return {
        "operation_id": operation,
        "server_version": archived["server"]["version"],
        "protocol_version": archived["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "timeout": status["timeout"],
        "typed_error": None,
        "coefficient_prefix": [str(q) for q in coefficients],
        "scope": "exact order-13 corroboration, not universal analytic evidence",
    }


def certificate():
    return {
        "claim_id": "C_RFJ_QUANT",
        "result_class": "improved_bound",
        "theorem": "Both remaining first-join counts are O_k0(W^(201/200)); the oriented mixed roundoff is O(W^2).",
        "proof_kind": "universal analytic proof in report.md plus exact symbolic local checks",
        "formal_kernel_verification_of_this_theorem": False,
        "independent_review": "required; not asserted by this script",
        "scope_limit": "Stipulated retained-centre, good-mask, core-equivariant histories only; not the main conjecture or other construction inputs.",
        "reused_mechanism": {
            "claim": "C_BC v2, unchanged",
            "reviewer_judgement": "judgement-C_BC-4e16cb0094e9",
            "certificate": "research/backward-charge/certificates/C_BC-a0a4835af61d31ec.json",
            "action": "reuse, not recompilation or recertification",
        },
        "symbolic_local": symbolic_local_checks(),
        "prime_exponent_regressions": finite_prime_exponent_checks(),
        "determinant_cycle_regressions": determinant_cycle_checks(),
        "parameter_feasibility": parameter_checks(),
        "jacobian": jacobian_check(),
        "analytic_obligations_not_executed_by_python": [
            "one-sided field/orbit argument and deterministic determinant-cycle averaging",
            "ordinary-factor restoration and convergence of the stopping-prime series",
            "one-coordinate concentration, tensorization, and dyadic convolution",
            "classification of each charged pair and the W-sensitive smaller-band centre count",
            "LaTeX-to-model and actual-history statement fidelity",
        ],
        "manuscript_refutations_established": [],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(target.read_text()) == result, "certificate replay mismatch")
    print(json.dumps({
        "ok": True,
        "claim": result["claim_id"],
        "symbolic_identities": len(result["symbolic_local"]["identities"]),
        "finite_cases": result["prime_exponent_regressions"],
        "actual_cycle_cases": result["determinant_cycle_regressions"]["cycles_and_residue_tests"],
        "strict_parameter_certificates": len(
            result["parameter_feasibility"]["positive_coefficient_certificates"]
        ),
        "c": result["parameter_feasibility"]["goal_c"],
        "universal_analytic_proof": "report.md; independent review required",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
