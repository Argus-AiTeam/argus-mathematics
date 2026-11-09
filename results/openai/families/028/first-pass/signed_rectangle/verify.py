#!/usr/bin/env python3
"""Replay the exact arithmetic certificate; the universal proof is PROOF.md."""

import itertools
import json
import math
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def check_zero(expression, name):
    require(sp.cancel(sp.expand(expression)) == 0, f"Identity failed: {name}")


def check_nonnegative_coefficients(expression, variables, name):
    coefficients = sp.Poly(sp.expand(expression), *variables).coeffs()
    require(all(c >= 0 for c in coefficients), f"Negative coefficient: {name}")


def gaussian_mul(z, w):
    a, b = z
    x, y = w
    return a * x - b * y, a * y + b * x


def norm(z):
    return z[0] ** 2 + z[1] ** 2


def gaussian_divides(z, w):
    a, b = z
    x, y = w
    n = norm(z)
    require(n > 0, "Zero Gaussian divisor")
    return (a * x + b * y) % n == 0 and (a * y - b * x) % n == 0


def is_prime(p):
    return p >= 2 and all(p % n for n in range(2, math.isqrt(p) + 1))


def gaussian_product(factors):
    value = (1, 0)
    for factor in factors:
        value = gaussian_mul(value, factor)
    return value


def symbolic_checks(certificate):
    a, b, x, y, z, w = sp.symbols("a b x y z w", real=True)
    k, u, v, d, r, L, t, s, lam, e = sp.symbols(
        "k u v d r L t s lambda e", nonnegative=True
    )
    mx, my = a * x - b * y, b * x + a * y
    mz, mw = a * z - b * w, b * z + a * w
    identities = {
        "norm_multiplication": mx**2 + my**2 - (a**2 + b**2) * (x**2 + y**2),
        "determinant_multiplication": mx * mw - my * mz
        - (a**2 + b**2) * (x * w - y * z),
        "factorial_induction_step": (2*k+2)*(2*k+1) - 2*(k+1) - 4*k*(k+1),
        "fair_bit_chernoff_optimum": (
            (lam**2 * r * L**2 / 8 - lam * t).subs(lam, 4*t/(r*L**2))
            + 2*t**2/(r*L**2)
        ),
        "two_set_completing_square": r*lam**2/4 - lam*s
        + s**2/r - (r*lam-2*s)**2/(4*r),
        "two_set_chernoff_optimum": (
            (r*lam**2/4-lam*s).subs(lam, 2*s/r) + s**2/r
        ),
        "fixed_line_exponent": 2*(d*r*L/2)**2/(r*(2*L)**2) - d**2*r/8,
        "class_aggregation_exponent": (d*r/4)**2/(2*r) - d**2*r/32,
        "determinant_power_margin": d*r-2*(d*r/4-e)-d*r/2-2*e,
        "balanced_product_margin": (b/3+u)*(b/3+v)-b**2/9
        - b*(u+v)/3-u*v,
    }
    require(set(identities) == set(certificate["universal_identities"]),
            "Universal identity list changed")
    for name, expression in identities.items():
        check_zero(expression, name)
    require(math.factorial(0) == 2**0 * math.factorial(0),
            "Factorial induction base failed")

    positivity = {
        "factorial_induction_slack": (4*k*(k+1), (k,)),
        "T_squared_dominates_2T": ((u+5)**2-2*(u+5), (u,)),
        "fixed_line_decay_dominates_final_decay": (d**2*r/8-d**2*r/32, (d, r)),
        "original_cubic_exponent_dominated": (d**2*r*(sp.Rational(3, 4)+u), (d, r, u)),
        "balanced_product_slack": (b*(u+v)/3+u*v, (b, u, v)),
    }
    require(set(positivity) == set(certificate["nonnegative_coefficient_certificates"]),
            "Positivity certificate list changed")
    for name, (expression, variables) in positivity.items():
        check_nonnegative_coefficients(expression, variables, name)
    check_zero(
        (d**2*r-d**3*r) - d**2*r*(sp.Rational(3, 4)+u).subs(u, sp.Rational(1, 4)-d),
        "cubic exponent domain substitution",
    )

    axes = sp.symbols("x0:4", real=True)
    determinant = axes[0]*axes[3]-axes[1]*axes[2]
    polynomial = sp.Poly(determinant, *axes)
    require(all(polynomial.degree(axis) <= 1 for axis in axes),
            "Rectangle determinant is not multi-affine")
    values = [
        determinant.subs(dict(zip(axes, corner)))
        for corner in itertools.product((-1, 1), repeat=4)
    ]
    require((min(values), max(values)) == (-2, 2),
            "Rectangle determinant range certificate failed")
    rectangle = certificate["normalized_rectangle_determinant"]
    require(rectangle == {
        "variables": 4, "multi_affine": True, "box": ["-1", "1"],
        "range": ["-2", "2"],
        "method": "multi-affine interpolation from exact corner values",
    }, "Rectangle certificate changed")
    # Multi-affine interpolation is an identity, not a vertex-sampling heuristic.
    interpolation = 0
    for corner, value in zip(itertools.product((-1, 1), repeat=4), values):
        weight = sp.prod((1+sign*axis)/2 for sign, axis in zip(corner, axes))
        interpolation += value * weight
    check_zero(interpolation-determinant, "rectangle interpolation")

    constants = {name: Fraction(value) for name, value in certificate["constants"].items()}
    require(constants == {
        "amplitude": Fraction(3), "quadratic_decay": Fraction(1, 32),
        "fixed_line_decay": Fraction(1, 8), "hamming_separation_fraction": Fraction(1, 4),
        "nontrivial_branch_q_min": Fraction(1), "original_C0": Fraction(1),
    }, "The theorem's constants changed")
    margins = certificate["rational_margins"]
    require(Fraction(margins["determinant_divisor_ratio_lower"]) == Fraction(5**2, 2) > 1,
            "Determinant divisor margin failed")
    require(Fraction(margins["small_q_exponential_upper"]) == 1/(1-Fraction(1, 32)),
            "Small-q series margin failed")
    require(Fraction(margins["small_q_amplitude_margin"])
            == Fraction(3)-Fraction(32, 31) > 0, "Small-q amplitude failed")
    power_check = margins["logarithmic_margin_power_check"]
    require(power_check == {"left": 5**4, "right": 2}
            and power_check["left"] > power_check["right"],
            "Fixed-line logarithmic margin failed")
    return len(identities), len(positivity)


def rational_function(value, variables):
    require(value["variables"] == [str(x) for x in variables],
            "Jacobian rational-function axes changed")
    require(value.get("domain", "QQ") == "QQ", "Jacobian coefficient field changed")
    def polynomial(part):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * sp.prod(x**n for x, n in zip(variables, term["exponents"], strict=True))
            for term in part["terms"]
        )
    numerator = polynomial(value["numerator"])
    denominator = polynomial(value["denominator"])
    require(denominator != 0, "Jacobian denominator is zero")
    return numerator / denominator


def jacobian_check(certificate):
    evidence = certificate["jacobian"]
    status = json.loads((HERE / evidence["status"]).read_text())
    output = json.loads((HERE / evidence["output"]).read_text())
    payload = json.loads((HERE / evidence["payload"]).read_text())
    require(status["status"] == "completed" and status["exit_code"] == 0
            and status["stderr"] == "", "Jacobian did not complete successfully")
    require(output["server"]["version"] == evidence["expected_server_version"],
            "Archived Jacobian server version changed")
    require(output["protocol_version"] == evidence["expected_protocol_version"],
            "Archived Jacobian protocol version changed")
    require(output["request"]["operation_id"] == evidence["operation_id"]
            == output["result"]["operation_id"] == status["operation_id"],
            "Jacobian operation binding changed")
    require(output["request"]["payload"] == payload,
            "Jacobian result is bound to another payload")
    variables = sp.symbols("r s lambda")
    require(payload["left"]["variables"] == payload["right"]["variables"]
            == output["result"]["output"]["variables"] == [str(x) for x in variables],
            "Jacobian matrix axes changed")
    expected = variables[0]*variables[2]-2*variables[1]
    for side in ("left", "right"):
        entries = payload[side]["entries"]
        require(len(entries) == len(entries[0]) == 1, "Jacobian input shape changed")
        check_zero(rational_function(entries[0][0], variables)-expected,
                   f"Jacobian {side} payload")
    entries = output["result"]["output"]["entries"]
    require(len(entries) == len(entries[0]) == 1, "Jacobian output shape changed")
    check_zero(rational_function(entries[0][0], variables)-expected**2,
               "Jacobian completing-square output")


def gaussian_regression(certificate):
    example = certificate["gaussian_regression"]
    primes = example["primes"]
    factors = [tuple(z) for z in example["factors"]]
    T = example["T"]
    r = len(primes)
    require(len(set(primes)) == r == len(factors), "Repeated or mismatched primes")
    require(all(is_prime(p) and p % 4 == 1 and T <= p <= 2*T for p in primes),
            "Regression violates the prime hypotheses")
    require(all(norm(z) == p for z, p in zip(factors, primes, strict=True)),
            "Regression factor has wrong norm")
    d = Fraction(example["d"])
    require(0 < d < Fraction(1, 4), "Regression d is inadmissible")
    P = math.prod(primes)
    direction = gaussian_product(factors)
    require(norm(direction) == P and math.gcd(*direction) == 1,
            "Regression direction is not primitive of norm P")
    # R=sqrt(P), W=1: admissibility follows from 1/2 <= 1-d, without floats.
    require(Fraction(1, 2) <= 1-d and P > 1, "Regression rectangle is inadmissible")
    require(example["R_squared"] == "P" and example["W"] == 1
            and example["orientation"] == "line of the all-unconjugated product",
            "Regression rectangle does not match the exact membership test")
    eligible_products = []
    bad = 0
    sign_choices = []
    for bits in itertools.product((0, 1), repeat=r):
        chosen = [(a, -b if bit else b) for (a, b), bit in zip(factors, bits, strict=True)]
        sign_choices.append(chosen)
        signed = gaussian_product(chosen)
        require(norm(signed) == P, "Signed-product norm failed")
        eligible = math.prod(
            p for p, pi in zip(primes, chosen, strict=True)
            if gaussian_divides(pi, direction)
        )
        eligible_products.append(eligible)
        a = P // eligible
        witness = (a*direction[0], a*direction[1])
        require(all(gaussian_divides(pi, witness) for pi in chosen),
                "Predicted minimal line multiplier failed")
        for p, pi in zip(primes, chosen, strict=True):
            if not gaussian_divides(pi, direction):
                require(a % p == 0, "Missing factor did not force p | a")
        # A witness has norm at most P+1 < 2P, so its cofactor is a unit.
        has_witness = False
        for unit in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            w = gaussian_mul(unit, signed)
            dot = direction[0]*w[0]+direction[1]*w[1]
            determinant = direction[0]*w[1]-direction[1]*w[0]
            has_witness |= dot**2 <= P**2 and determinant**2 <= P
        bad += int(has_witness)
    require(math.prod(eligible_products) == norm(direction)**(2**(r-1)),
            "Exact fair-sign logarithmic expectation identity failed")
    require(0 < bad <= 2**r, "Regression did not produce the designed witness")
    require(Fraction(bad, 2**r) == Fraction(example["expected_probability"]),
            "Exact rectangle probability regression failed")
    radius = example["primitive_coordinate_radius"]
    multiplier_radius = example["integer_multiplier_radius"]
    require(radius == 8 and multiplier_radius == 3, "Adversarial regression scope changed")
    directions = 0
    for v in itertools.product(range(-radius, radius+1), repeat=2):
        if math.gcd(*v) != 1:
            continue
        directions += 1
        eligible_norm = 1
        for p, pi in zip(primes, factors, strict=True):
            eligible = (gaussian_divides(pi, v), gaussian_divides((pi[0], -pi[1]), v))
            require(sum(eligible) <= 1, "Primitive direction contains both conjugates")
            if any(eligible):
                eligible_norm *= p
        require(norm(v) % eligible_norm == 0, "Eligible norm product does not divide N(v)")
        products = []
        for chosen in sign_choices:
            eligible = math.prod(
                p for p, pi in zip(primes, chosen, strict=True) if gaussian_divides(pi, v)
            )
            products.append(eligible)
            missing = P // eligible
            for a in range(-multiplier_radius, multiplier_radius+1):
                witness = (a*v[0], a*v[1])
                require(all(gaussian_divides(pi, witness) for pi in chosen)
                        == (a % missing == 0),
                        "Primitive-line divisibility equivalence failed")
        require(math.prod(products) <= norm(v)**(2**(r-1)),
                "Uniform fixed-line expectation inequality failed")
    return {"sign_vectors": 2**r, "bad_sign_vectors": bad,
            "exact_probability": str(Fraction(bad, 2**r)),
            "primitive_directions_checked": directions,
            "integer_multipliers_per_direction_and_sign": 2*multiplier_radius+1,
            "interpretation": "bounded regression only"}


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "C_RECTANGLE_SHARP"
            and certificate["result_class"] == "improved_bound",
            "Certificate claim changed")
    require(certificate["quantifier_scope"] == "for_each_fixed_rectangle_before_sampling",
            "Rectangle quantifier order changed")
    require(certificate["kernel_verified"] is False, "Unexpected kernel-verification claim")
    require((HERE / certificate["proof"]).is_file()
            and (HERE / certificate["statement_fidelity"]).is_file(),
            "Mathematical proof or statement-fidelity report is missing")
    identities, positivity = symbolic_checks(certificate)
    jacobian_check(certificate)
    regression = gaussian_regression(certificate)
    print(json.dumps({
        "claim_id": certificate["claim_id"],
        "exact_certificate_checks": "passed",
        "universal_symbolic_identities": identities,
        "nonnegative_polynomial_certificates": positivity,
        "rectangle_box_certificate": "universal multi-affine interpolation",
        "jacobian_typed_replay": "passed",
        "gaussian_regression": regression,
        "universal_theorem_proof": "PROOF.md; independent mathematical reading required",
        "kernel_verified": False,
        "independent_review": certificate["independent_review_status"],
    }, indent=2))


if __name__ == "__main__":
    main()
