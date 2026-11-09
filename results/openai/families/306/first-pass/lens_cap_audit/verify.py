#!/usr/bin/env python3
"""Replay the exact, all-sector arithmetic of the negative-four cap theorem."""

import argparse
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
Q, H = sp.symbols("q h", integer=True)
M, E, KAPPA, B = sp.symbols("m e kappa b")


def exact_zero(expression, label):
    difference = sp.simplify(sp.expand(expression))
    if difference != 0:
        raise AssertionError(f"{label}: nonzero exact difference {difference}")


def line_index(a):
    quotient, residue = divmod(a, 4)
    return quotient * (1 - residue - 2 * quotient)


def affine_index(a):
    polynomial = sp.Poly(sp.expand(a), Q)
    if polynomial.degree() > 1:
        raise ValueError(f"Not an affine integer twist: {a}")
    coefficient = polynomial.coeff_monomial(Q)
    constant = polynomial.coeff_monomial(1)
    if coefficient.is_Integer is not True or constant.is_Integer is not True:
        raise ValueError(f"Noninteger affine twist: {a}")
    slope = int(coefficient)
    if slope % 4:
        raise ValueError(f"Character has not been split into residues: {a}")
    base, residue = divmod(int(constant), 4)
    quotient = (slope // 4) * Q + base
    return sp.expand(quotient * (1 - residue - 2 * quotient))


def fixed_point_term(residue, dual=True):
    sign = -1 if dual else 1
    return sp.simplify(
        sum(
            sp.I ** (residue * j) / (1 - sp.I ** (sign * j)) ** 2
            for j in range(1, 4)
        )
        / 4
    )


def build_certificate():
    identities = []

    def identity(label, left, right=0):
        exact_zero(left - right, label)
        identities.append(label)

    corrections = [fixed_point_term(r) for r in range(4)]
    expected = [sp.Rational(1, 16), sp.Rational(3, 16),
                sp.Rational(1, 16), sp.Rational(-5, 16)]
    if corrections != expected:
        raise AssertionError(f"Wrong isolated-point terms: {corrections}")

    polynomial_rows = []
    for r, correction in enumerate(corrections):
        a = 4 * Q + r
        smooth_rr = sp.Rational(8 + 4, 12) + a * sp.Rational(2, 2)
        orbifold_rr = (
            a**2 * sp.Rational(1, 8)
            + a * sp.Rational(3, 4)
            + sp.Rational(15, 16)
        )
        index = sp.expand(smooth_rr - orbifold_rr - correction)
        expected_index = Q * (1 - r - 2 * Q)
        identity(f"dirac_all_integer_twists_r{r}", index, expected_index)
        identity(
            f"dirac_square_r{r}",
            32 * index,
            (2 * r - 2) ** 2 - (2 * a - 2) ** 2,
        )
        identity(
            f"dirac_period_shift_r{r}",
            affine_index(a + 4) - index,
            -a - 1,
        )
        identity(f"dirac_conjugation_r{r}", affine_index(2 - a), index)
        polynomial_rows.append({
            "residue": r,
            "all_integer_a": f"4*q+{r}",
            "fixed_point_term": str(correction),
            "index_polynomial": str(sp.expand(index)),
            "determinant_reference_evaluation": 2 * r - 2,
        })

    charge_rows = []
    for r in range(4):
        m = 4 * Q + r
        d = 2 * m
        parity = r % 2
        offset = sp.Rational(parity, 4)
        split_charge = sp.expand(m**2 / 4)
        integral_part = sp.Poly(split_charge - offset, Q)
        if any(c.is_Integer is not True for c in integral_part.all_coeffs()):
            raise AssertionError(f"Nonintegral charge sector for residue {r}")
        asd = -2 * (affine_index(d) + affine_index(-d))
        identity(f"asd_all_charges_r{r}", asd, 8 * split_charge)
        for lam in (-2, 2):
            base = (lam + 2) // 2
            coupled = affine_index(base + m) + affine_index(base - m)
            identity(f"coupled_background_{lam}_r{r}",
                     coupled, offset - split_charge)
            charge = split_charge + H
            shifted_asd = asd + 8 * H
            shifted_dirac = coupled - H
            identity(f"relative_asd_{lam}_r{r}", shifted_asd, 8 * charge)
            identity(f"relative_dirac_{lam}_r{r}",
                     shifted_dirac, offset - charge)
            identity(f"relative_spinor_{lam}_r{r}",
                     shifted_asd + 2 * shifted_dirac, 6 * charge + 2 * offset)
        charge_rows.append({
            "m_residue_mod_4": r,
            "intrinsic_state": ("+" if r == 0 else "-" if r == 2 else "trace"),
            "ordered_eigenvalue": str(sp.I**r),
            "charge_fraction": str(offset),
            "split_charge_minus_fraction": str(integral_part.as_expr()),
            "relative_shift": "h is any integer",
            "framed_asd": "8*kappa",
            "complex_coupled_dirac": f"{offset}-kappa",
            "real_spinor": f"6*kappa+{2 * offset}",
        })

    references = []
    for lam in (-2, 2):
        for state, m in (("+", 0), ("-", -lam), ("trace+i", 1), ("trace-i", -1)):
            a = (lam + 2) // 2 + m
            correction = 2 * line_index(a)
            if correction != 0:
                raise AssertionError(f"Nonzero sharp tangential reference: {lam,state,m}")
            references.append({
                "Lambda_S": lam,
                "intrinsic_state": state,
                "d": 2 * m,
                "active_K_S": lam + 2 * m,
                "active_twist_a": a,
                "real_tangential_correction": correction,
            })
        wrong_m = lam
        wrong_a = (lam + 2) // 2 + wrong_m
        if 2 * line_index(wrong_a) != -2:
            raise AssertionError("The alternative minus reference must cost -2")

    p = -2 * E + M
    other = -2 * E - M
    identity("bundle_line_sum", p + other, -4 * E)
    identity("bundle_line_difference", p - other, 2 * M)
    identity("fixed_spin_c_not_fixed_Lambda", (2 - 4 * E) - (-4 * E), 2)
    identity("actual_active_spinor_twist", p + B, B - 2 * E + M)
    identity("actual_complementary_spinor_twist", other + B, B - 2 * E - M)
    identity("active_spinor_determinant",
             (2 * B - 2) + 2 * p, (2 * B - 2 - 4 * E) + 2 * M)
    identity("complementary_spinor_determinant",
             (2 * B - 2) + 2 * other, (2 * B - 2 - 4 * E) - 2 * M)
    identity("tracefree_charge_transport",
             KAPPA - E**2 - (-4 * E**2) / 4, KAPPA)
    identity("determinant_square_shift",
             -4 * (E + 1)**2 + 4 * E**2, -4 * (2 * E + 1))
    identity("second_chern_shift",
             (KAPPA - (E + 1)**2) - (KAPPA - E**2), -(2 * E + 1))
    identity("fixed_exterior_central_active_twist", B - 2 + (M + 2), B + M)
    identity("fixed_exterior_central_complement",
             B - 2 - (M + 2), B - M - 4)
    identity("central_reference_integer_charge_change",
             (M + 2)**2 / 4 - M**2 / 4, M + 1)

    weyl = sp.Matrix([[0, -1], [1, 0]])
    if weyl.det() != 1 or weyl.conjugate().T * weyl != sp.eye(2):
        raise AssertionError("The chosen boundary matrix is not in SU(2)")
    if weyl * weyl != -sp.eye(2):
        raise AssertionError("Incorrect Weyl square")
    if weyl * sp.Matrix([1, 0]) != sp.Matrix([0, 1]):
        raise AssertionError("The prescribed eigenline was not swapped")
    if weyl * sp.Matrix([0, 1]) != sp.Matrix([-1, 0]):
        raise AssertionError("Incorrect complementary eigenline map")

    boundary_rows = []
    for r in range(4):
        intrinsic = sp.diag(sp.I**r, sp.I**(-r))
        for e in (0, 1):
            bundle_boundary = sp.diag(sp.I**(-2 * e + r),
                                      sp.I**(-2 * e - r))
            root_character = sp.I**(-2 * e)
            for entry in bundle_boundary - (-1)**e * intrinsic:
                exact_zero(entry, "common exterior determinant normalization")
            for entry in bundle_boundary / root_character - intrinsic:
                exact_zero(entry, "intrinsic determinant root normalization")
            exact_zero(bundle_boundary.det() - 1, "boundary determinant")
            boundary_rows.append({
                "m_residue": r,
                "determinant_bit": e,
                "root_character": str(root_character),
                "external_bundle_characters": [
                    str(sp.simplify(bundle_boundary[0, 0])),
                    str(sp.simplify(bundle_boundary[1, 1])),
                ],
                "ordered_spinor_characters": [
                    str(sp.I**((2 - 2 * e + r) % 4)),
                    str(sp.I**((2 - 2 * e - r) % 4)),
                ],
            })
        if r % 2:
            for entry in weyl * (-intrinsic) * weyl.inv() - intrinsic:
                exact_zero(entry, "trace determinant-one conjugacy")
            m = 4 * Q + r
            first_multiple = sp.expand(((-m) - (2 + m)) / 4)
            second_multiple = sp.expand((m - (2 - m)) / 4)
            for multiple in (first_multiple, second_multiple):
                if any(c.is_Integer is not True
                       for c in sp.Poly(multiple, Q).all_coeffs()):
                    raise AssertionError("Trace permutation lost a full character")
            identity(f"trace_active_index_transport_r{r}",
                     affine_index(-m), affine_index(2 + m))
            identity(f"trace_complement_index_transport_r{r}",
                     affine_index(m), affine_index(2 - m))
        else:
            if intrinsic == -intrinsic:
                raise AssertionError("Distinct central states were collapsed")

    central_transitions = []
    for exterior, m0, m1 in (("+", 0, 2), ("-", -2, 0)):
        if m1 != m0 + 2:
            raise AssertionError("Incorrect fixed-exterior central reference")
        active0 = 2 + m0
        active1 = m1
        complement0 = 2 - m0
        complement1 = -m1
        if active1 != active0 or complement1 != complement0 - 4:
            raise AssertionError("Central transition lost active boundary data")
        if line_index(active0) != 0 or line_index(active1) != 0:
            raise AssertionError("Central transition lost sharp tangency")
        central_transitions.append({
            "fixed_exterior_state": exterior,
            "m_at_e0": m0,
            "m_at_e1": m1,
            "active_twist_at_both_bits": active0,
            "reference_charge_change": m0 + 1,
        })

    # These are adversarial tests of shortcuts, not manuscript refutations.
    if sp.I**(2 + 2 * 1) != sp.I**(2 + 2 * 3):
        raise AssertionError("The determinant-only ambiguity example is malformed")
    if corrections[1] - corrections[3] != sp.Rational(1, 2):
        raise AssertionError("Full boundary characters were silently identified")
    if fixed_point_term(1, dual=False) != corrections[3]:
        raise AssertionError("The tangent/dual-tangent mutation was not detected")

    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    adapter = json.loads((ROOT / "jacobian_status.json").read_text())
    operation = "finite_abelian_group.spectral_pair.decide"
    if adapter["adapter_exit_code"] != 0 or adapter["timeout"] is not False:
        raise RuntimeError("The archived Jacobian execution is inconclusive")
    if output["request"] != {"operation_id": operation, "payload": payload}:
        raise AssertionError("Jacobian output does not bind to the exact payload")
    typed = output["result"]["output"]
    expected_source = {
        "group": {"moduli": [4]},
        "points": [[0], [1], [2], [3]],
        "frequencies": [[0], [1], [2], [3]],
    }
    if (typed["source"] != expected_source or typed["is_spectral"] is not True
            or typed["reason"] != "SPECTRAL"
            or typed["first_nonorthogonal_pair"] is not None
            or typed["character_convention"] != "POSITIVE_PRODUCT_DUAL_PAIRING"):
        raise AssertionError("Unexpected typed cyclic-character result")
    fourier = sp.Matrix([[sp.I**(r * j) for j in range(4)] for r in range(4)])
    if fourier * fourier.conjugate().T != 4 * sp.eye(4):
        raise AssertionError("Independent exact Fourier replay failed")

    return {
        "result_class": "local_verification_theorem",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": "required_not_claimed_by_this_script",
        "novelty_status": "not_established",
        "scope": "Negative-four disk bundle local indices and fixed-l determinant transport",
        "quantifiers": {
            "a": "every integer, represented uniquely by 4*q+r, 0<=r<4",
            "d": "every even integer, d=2*m",
            "Lambda_S": [-2, 2],
            "relative_charge_shift": "every integer h; no existence assertion",
            "actual_bit_family": "e in {0,1}, c[S]=-4e, Lambda[S]=2-4e, l[S]=2",
        },
        "geometry_inputs_not_machine_proved": [
            "APS product-collar index theorem and the relative comparison in proof.md",
            "Smooth and orbifold Riemann-Roch with actual fiber and dual-normal actions",
            "Complex-oriented contraction and its full spin-c boundary identification",
            "Flat quotient-ball framed index zero and closed relative clutching coefficients",
            "Positive-scalar/ASD Weitzenbock vanishing when invertibility is asserted",
        ],
        "isolated_point_corrections": [str(value) for value in corrections],
        "dirac_quasipolynomials": polynomial_rows,
        "all_charge_sectors": charge_rows,
        "sharp_tangential_references": references,
        "boundary_character_transport": boundary_rows,
        "fixed_exterior_central_references": central_transitions,
        "trace_transport": {
            "weyl": [[0, -1], [1, 0]],
            "determinant": 1,
            "square": "-identity",
            "prescribed_line": "swapped; no unordered-line shortcut",
            "new_spinor_twists_after_swap": ["-m", "m"],
            "old_spinor_twists": ["2+m", "2-m"],
            "differences": ["-2*(m+1)", "2*(m-1)"],
            "full_character_condition": "m is odd",
        },
        "adversarial_shortcut_checks": {
            "same_determinant_different_full_characters": [1, 3],
            "fixed_point_discrepancy": "1/2",
            "wrong_tangent_denominator_detected": True,
            "fixed_Lambda_is_not_manuscript_bit_family": True,
        },
        "jacobian": {
            "operation_id": operation,
            "server": output["server"],
            "protocol_version": output["protocol_version"],
            "transport": output["transport"],
            "payload_file": "jacobian_payload.json",
            "typed_output_file": "jacobian_output.json",
            "adapter_status": adapter,
            "independent_fourier_replay": True,
            "limited_role": "exhaustive four-character orthogonality only, not the index theorem",
        },
        "symbolic_identity_count": len(identities),
        "symbolic_identities": identities,
        "manuscript_equations_verified_locally": [
            "eq:negative:cap-index",
            "eq:negative:tensor-charge",
            "eq:indices:lens-table",
            "eq:indices:reference-fillings",
            "eq:indices:dirac-table",
        ],
        "established_false_manuscript_assertions": [],
        "not_certified": [
            "ASD normal surjectivity, cut counts, or analytic gluing",
            "The real determinant-line comparison sign s or its global coherence",
            "The global numerical exclusion theorem",
            "The global purely cosmetic surgery theorem",
            "Verified novelty, publishable significance, or independent Reviewer acceptance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    target = ROOT / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        stored = json.loads(target.read_text())
        if stored != certificate:
            raise AssertionError("Stored certificate differs from exact recomputation")
    print(
        f"PASS: {certificate['symbolic_identity_count']} all-parameter identities; "
        "4 complete character classes; both determinant bits; exact Fourier replay."
    )
    print("Local index verification only; geometry inputs and independent review remain explicit.")


if __name__ == "__main__":
    main()
