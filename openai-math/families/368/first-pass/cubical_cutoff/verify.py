#!/usr/bin/env python3
"""Replay exact algebra used in proof.md; this is not a topology checker."""

import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational(pair):
    numerator, denominator = pair
    require(denominator > 0, "Rational denominator must be positive")
    return sp.Rational(numerator, denominator)


def run():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(
        certificate["certificate_kind"] == "exact_algebra_and_all_depth_induction",
        "Wrong certificate scope",
    )
    require(certificate["dimension"] == 3, "The audited dimension is three")
    require(certificate["layer_codimension"] == 1, "The layer is codimension one")
    require(certificate["inverse_jacobian_power"] == 3, "Wrong Jacobian power")
    require(certificate["overlap_growth_power"] == 2, "Wrong overlap power")
    require(certificate["dyadic_base"] == 2, "Wrong depth scale")

    q, s, ell = sp.symbols("q s ell", positive=True)
    inverse_weight = (ell / s) ** certificate["inverse_jacobian_power"]
    overlap_weight = (s / ell) ** certificate["overlap_growth_power"]
    require(sp.cancel(inverse_weight * overlap_weight - ell / s) == 0,
            "Weighted overlap retains an unwanted scale factor")
    require(sp.cancel((ell / s) * (s / ell) - 1) == 0,
            "Conjugation factors do not cancel")
    require((q * sp.eye(3)).det() == q ** 3, "Scalar determinant power is wrong")

    v = sp.Matrix(sp.symbols("v0:3", real=True))
    w = sp.Matrix(sp.symbols("w0:3", real=True))
    d = w.dot(w)
    numerator = d * sp.eye(3) + (v - w) * w.T
    require(sp.expand(numerator.det() - d ** 2 * v.dot(w)) == 0,
            "Full-frame transport determinant identity fails")
    require(all(sp.cancel(entry) == 0 for entry in numerator * w - d * v),
            "Frame transport does not carry w to v")

    geometric = certificate["geometric_sum"]
    ratio = rational(geometric["ratio"])
    bound = rational(geometric["sum_bound"])
    next_multiplier = rational(geometric["next_z_multiplier"])
    z = sp.Symbol("z", positive=True)
    partial = sum(
        rational(coefficient) * z ** degree
        for degree, coefficient in enumerate(geometric["partial_sum_coefficients_in_z"])
    )
    next_term = sum(
        rational(coefficient) * z ** degree
        for degree, coefficient in enumerate(geometric["next_term_coefficients_in_z"])
    )
    require(ratio == sp.Rational(1, 2) and 0 < ratio < 1, "Wrong geometric ratio")
    require(next_multiplier == ratio, "The induction changes depth incorrectly")
    require(partial.subs(z, 1) == 0, "Depth-zero base case fails")
    require(sp.expand(partial.subs(z, ratio * z) - partial - next_term) == 0,
            "The symbolic induction step fails")
    require(next_term == z, "The added term must be 2^(-N)")
    require(sp.expand(bound - partial - 2 * z) == 0, "Wrong nonnegative tail")
    require(bound == 1 / (1 - ratio), "Wrong infinite-sum bound")
    require(certificate["depth_quantifier"] == "every natural N, not a bounded search",
            "A finite experiment cannot replace the induction")

    packing = certificate["packing"]
    require(packing["slab_count"] == 6 and packing["tangential_dimension"] == 2,
            "Wrong cubical layer geometry")
    require(
        packing["slab_count"] *
        packing["projection_length_factor"] ** packing["tangential_dimension"]
        == packing["volume_coefficient"] == 24,
        "Wrong slab-volume coefficient",
    )

    a, b, r = sp.symbols("a b r", positive=True)
    psi = b * (r - a) / (b - a)
    require(sp.cancel(psi.subs(r, a)) == 0, "Collapse is not continuous at a")
    require(sp.cancel(psi.subs(r, b) - b) == 0, "Collapse is not continuous at b")
    require(sp.cancel(1 - psi / r - a * (b - r) / (r * (b - a))) == 0,
            "Angular Lipschitz bound identity fails")
    require(sp.cancel(sp.diff(psi, r) - b / (b - a)) == 0,
            "Wrong radial slope")

    J, A, diameter, volume, m, P, L, p = sp.symbols(
        "J A d v m P L p", positive=True
    )
    packing_constant = 24 * b * (A + diameter) ** 2 / volume
    energy_constant = 2 * J * packing_constant / m ** 3 * (P * L / m) ** p
    expected = 48 * J * b * (A + diameter) ** 2 / (volume * m ** 3) * (P * L / m) ** p
    require(sp.simplify(energy_constant - expected) == 0, "Wrong energy constant")
    allowed = set(certificate["energy_constant"]["allowed_parameters"])
    excluded = set(certificate["energy_constant"]["excluded_parameters"])
    actual_parameters = {str(symbol) for symbol in energy_constant.free_symbols}
    require(actual_parameters == allowed and not actual_parameters & excluded,
            "The energy constant has an unpermitted dependency")

    payload = json.loads((ROOT / certificate["jacobian_payload"]).read_text())
    output = json.loads((ROOT / certificate["jacobian_output"]).read_text())
    status = json.loads((ROOT / certificate["jacobian_status"]).read_text())
    operation = certificate["jacobian_operation"]
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["timeout_status"] == "no_external_timeout", "Jacobian run timed out")
    require(output["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(output["server"]["name"] == "jacobian", "Unexpected sidecar")
    require(output["server"]["version"] == "0.14.0", "Unexpected sidecar version")
    require(output["request"]["operation_id"] == operation, "Wrong operation binding")
    require(output["request"]["payload"] == payload, "Payload/output binding differs")
    require(output["result"]["operation_id"] == operation, "Wrong typed result")
    determinant = output["result"]["output"]["determinant"]
    require(determinant["variables"] == ["q"], "Wrong determinant variable")
    require(determinant["numerator"]["terms"] ==
            [{"coefficient": {"den": "1", "num": "1"}, "exponents": [3]}],
            "Jacobian did not return q^3")
    require(determinant["denominator"]["terms"] ==
            [{"coefficient": {"den": "1", "num": "1"}, "exponents": [0]}],
            "Wrong exact determinant denominator")
    require(Fraction(1, 2) ** 3 * Fraction(2) ** 2 == Fraction(1, 2),
            "Dyadic specialization disagrees with the symbolic identity")

    for key in ("mathematical_proof", "formal_source", "formal_reading"):
        require((ROOT / certificate[key]).is_file(), f"Missing {key}")

    return {
        "ok": True,
        "classification": "exact_algebra_and_universal_induction",
        "claim": certificate["claim"],
        "checks": [
            "frame_transport_identity_and_determinant",
            "conjugation_scale_cancellation",
            "third_power_jacobian",
            "codimension_one_weighted_overlap",
            "all_natural_depths_by_base_and_symbolic_induction",
            "radial_collapse_matching_and_slope",
            "uniform_constant_parameter_dependencies",
            "typed_jacobian_payload_and_output_binding",
        ],
        "whole_cutoff_kernel_verified": False,
        "independent_review_asserted": False,
    }


if __name__ == "__main__":
    print(json.dumps(run(), indent=2))
