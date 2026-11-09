"""Replay exact algebra, not the imported analytic soliton theorems."""

import argparse
import json
from fractions import Fraction as Q
from math import factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
OPERATION = "matrix.symmetric.rational_spectrum_claim.check"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    return Q(int(value["num"]), int(value["den"]))


def normalize(coefficients):
    values = tuple(Q(c) for c in coefficients)
    while len(values) > 1 and values[-1] == 0:
        values = values[:-1]
    return values or (Q(0),)


def add(*polynomials):
    return normalize(
        sum(p[i] if i < len(p) else Q(0) for p in polynomials)
        for i in range(max(map(len, polynomials)))
    )


def scale(polynomial, factor):
    return normalize(c * factor for c in polynomial)


def multiply(left, right):
    result = [Q(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return normalize(result)


def derivative(polynomial):
    return normalize(i * polynomial[i] for i in range(1, len(polynomial)))


def verify_spectrum(payload, envelope):
    alpha = Q(1, 2)
    require(0 < alpha < 1, "Lai's parameter must be strictly between 0 and 1")
    b = 1 / (alpha + 2)
    diagonal = (alpha * b, b, b)
    require(sum(diagonal) == 1, "Ricci normalization is not trace one")
    require(diagonal[0] / diagonal[1] == alpha, "Incorrect eigenvalue ratio")
    require(all(x > 0 for x in diagonal), "The Ricci matrix must be positive")
    require(len(set(diagonal)) == 2, "The prescribed Ricci tensor is not isotropic")
    expected = [[diagonal[i] if i == j else Q(0) for j in range(3)]
                for i in range(3)]
    actual = [[rational(x) for x in row] for row in payload["matrix"]["entries"]]
    require(actual == expected, "Payload does not encode the source-implied matrix")
    profile = [(rational(c["eigenvalue"]), c["multiplicity"])
               for c in payload["claimed_profile"]]
    computed = [(x, diagonal.count(x)) for x in sorted(set(diagonal))]
    require(profile == computed, "Payload multiplicities differ from exact nullities")
    require(envelope["operation_id"] == OPERATION, "Unexpected Jacobian operation")
    result = envelope["output"]
    require(result["matrix"] == payload["matrix"], "Jacobian retained a different matrix")
    require(result["claimed_profile"] == payload["claimed_profile"],
            "Jacobian retained different claims")
    require(result["outcome"] == "VALID", "Jacobian did not report VALID")
    require(result["valid_complete_rational_spectrum"] is True,
            "Jacobian did not establish a complete spectrum")
    require(result["first_failed_condition"] is None
            and result["first_failed_claim_index"] is None,
            "Jacobian reports a failed condition")
    require(result["matrix_order"] == 3
            and result["claimed_multiplicity_sum"] == 3
            and result["established_multiplicity_sum"] == 3,
            "Jacobian dimension or multiplicity totals differ")
    require(result["method"] == "PYTHON_FLINT_EXACT_RANK_AFTER_ROW_DENOMINATOR_CLEARING",
            "Unexpected Jacobian method")
    ledger = result["nullity_ledger"]
    require(len(ledger) == len(computed), "Incomplete shifted-nullity ledger")
    for entry, (eigenvalue, multiplicity) in zip(ledger, computed):
        require(rational(entry["eigenvalue"]) == eigenvalue
                and entry["claimed_multiplicity"] == multiplicity
                and entry["exact_nullity"] == multiplicity
                and entry["multiplicity_matches"] is True,
                "Shifted-nullity ledger disagrees with independent diagonal calculation")
    sectional = tuple((diagonal[i] + diagonal[j] - diagonal[k]) / 2
                      for i, j, k in ((0, 1, 2), (0, 2, 1), (1, 2, 0)))
    require(all(x > 0 for x in sectional), "Nonpositive pointwise sectional value")
    return {
        "alpha": str(alpha),
        "trace_one_ricci_eigenvalues": list(map(str, diagonal)),
        "ricci_determinant": str(diagonal[0] * diagonal[1] * diagonal[2]),
        "three_dimensional_sectional_values": list(map(str, sectional)),
        "jacobian_result_matches_independent_exact_arithmetic": True,
        "scope": "Pointwise algebra conditional on Lai's eigenvalue prescription.",
    }


def verify_cigar_identities():
    # Coefficients are in ascending powers of u = tanh(s).
    u = normalize((0, 1))
    u_prime = normalize((1, 0, -1))
    curvature = normalize((2, 0, -2))

    def ds(polynomial):
        return multiply(derivative(polynomial), u_prime)

    u_second = ds(u_prime)
    require(add(u_second, multiply(u, curvature)) == (0,),
            "The identity u'' + u*K = 0 failed")
    potential_prime = scale(u, 2)
    require(ds(potential_prime) == curvature,
            "The radial steady cigar equation failed")
    require(multiply(potential_prime, u_prime) == multiply(curvature, u),
            "The angular steady cigar equation failed")
    components = (curvature, scale(curvature, -1),
                  scale(curvature, -1), curvature)
    tensor_norm_squared = add(*(multiply(c, c) for c in components))
    proposed_norm = scale(u_prime, 4)
    require(tensor_norm_squared == multiply(proposed_norm, proposed_norm),
            "The full curvature tensor norm identity failed")
    return {
        "K_coefficients_in_tanh_s": list(map(str, curvature)),
        "Rm_norm_squared_coefficients_in_tanh_s": list(map(str, tensor_norm_squared)),
        "identities": [
            "K = -u''/u = 2*(1-u^2)",
            "Hess(2*log(cosh(s))) = K*g_cigar",
            "|Rm_(line_times_cigar)|^2 = 16*(1-u^2)^2",
        ],
        "scope": "Exact polynomial identities using u'=1-u^2 and the coordinate formulas.",
    }


def verify_transfer_constants(kappa):
    require(kappa > 0, "The illustrative kappa must be positive")
    radius_multiple = 8
    cylinder_half_width = 2
    metric_lower = Q(3, 4)
    metric_upper = Q(5, 4)
    exponential_coefficient = Q(16 * factorial(4), 4**4)
    require(exponential_coefficient == Q(3, 2), "Exponential bound coefficient is wrong")
    curvature_margin = exponential_coefficient / radius_multiple**2
    require(curvature_margin == Q(3, 128) and curvature_margin < Q(1, 2),
            "There is no strict curvature margin for all integers j>=1")
    require(metric_lower * cylinder_half_width**2 > 1,
            "The first-exit length lower bound is insufficient")
    require(metric_upper**3 < 2**2, "Volume distortion is not strictly below two")
    cylinder_volume_pi_coefficient = (2 * cylinder_half_width)**2 * 2
    require(cylinder_volume_pi_coefficient == 32, "Cylinder volume coefficient is wrong")
    target_volume_pi_coefficient = 2 * cylinder_volume_pi_coefficient
    ratio_coefficient = Q(4 * target_volume_pi_coefficient, radius_multiple)
    require(ratio_coefficient == 32, "The final ratio is not bounded by 32/j")
    threshold = ratio_coefficient / kappa
    j = threshold.numerator // threshold.denominator + 1
    require(j >= 1 and j > threshold, "The illustrative integer choice is invalid")
    upper_bound = ratio_coefficient / j
    require(upper_bound < kappa, "The illustrative strict volume bound failed")
    return {
        "r": "8*j",
        "curvature_bound_times_r_squared": "3/(128*j^2)",
        "uniform_curvature_margin": str(curvature_margin),
        "first_exit_lower_bound_squared_over_r_squared": "3",
        "volume_distortion_bound_cubed_metric_factor": str(metric_upper**3),
        "ball_volume_ratio_strict_upper_bound": "32/j",
        "illustrative_rational_kappa": str(kappa),
        "illustrative_integer_j": j,
        "illustrative_radius": radius_multiple * j,
        "illustrative_strict_ratio_bound": str(upper_bound),
        "scope": "Exact constants. The proof supplies all-real quantifiers and the convergence index.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--kappa", default="1/100",
                        help="Positive rational for an illustrative integer choice, not a metric search")
    args = parser.parse_args()
    kappa = Q(args.kappa)
    payload = json.loads((HERE / "jacobian/spectrum-payload.json").read_text())
    envelope = json.loads((HERE / "jacobian/spectrum-result.json").read_text())
    report = {
        "outcome": "exact_algebra_passed",
        "spectrum": verify_spectrum(payload, envelope),
        "cigar": verify_cigar_identities(),
        "transfer": verify_transfer_constants(kappa),
        "trusted_analytic_imports": [
            "arxiv:2010.07272v2 Theorem 1.1",
            "arxiv:2010.07272v2 Corollary 1.3, in particular clause",
            "arxiv:2010.07272v2 Corollary 1.5",
        ],
        "not_mechanically_verified": [
            "Primary-source fidelity and the interpretation of AIMPL Problem 6.7",
            "Existence, completeness, and the analytic soliton and convergence theorems",
            "Coordinate differential geometry and positive-curvature product obstruction",
            "Uniform chart control, first-exit containment, and volume transfer",
            "Scaling, elementary analytic inequalities, and quantification over all real kappa",
        ],
        "reviewer_acceptance": "not_asserted",
        "wing_metric_constructed_numerically": False,
    }
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
