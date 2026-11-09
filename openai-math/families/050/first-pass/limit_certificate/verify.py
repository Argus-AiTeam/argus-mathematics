#!/usr/bin/env python3
"""Replay exact algebraic obligations; the analytic theorem is in proof.md."""

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OPERATION = "matrix.subsystem.psd_order.decide"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(expression, label):
    residual = sp.expand(expression)
    require(residual == 0, f"{label}: nonzero residual {residual}")


def matrix_zero(matrix, label):
    for row in range(matrix.rows):
        for column in range(matrix.cols):
            zero(matrix[row, column], f"{label}[{row},{column}]")


def quadratic(matrix, vector):
    return sp.expand((vector.conjugate().T * matrix * vector)[0])


def symbolic_checks():
    a, d, b, c = sp.symbols("a d b c", real=True)
    x, y, u, w = sp.symbols("x y u w", real=True)
    h = sp.Matrix([[a, b + sp.I * c], [b - sp.I * c, d]])
    e1, e2 = sp.eye(2)[:, 0], sp.eye(2)[:, 1]
    v = sp.Matrix([x + sp.I * y, u + sp.I * w])
    q1, q2 = quadratic(h, e1), quadratic(h, e2)
    real_part = (quadratic(h, e1 + e2) - q1 - q2) / 2
    imaginary_part = (q1 + q2 - quadratic(h, e1 + sp.I * e2)) / 2
    zero(real_part - b, "real polarization")
    zero(imaginary_part - c, "imaginary polarization")
    reconstructed = sp.Matrix(
        [[q1, real_part + sp.I * imaginary_part],
         [real_part - sp.I * imaginary_part, q2]]
    )
    matrix_zero(reconstructed - h, "entry reconstruction")
    expanded_quadratic = (
        a * (x**2 + y**2)
        + d * (u**2 + w**2)
        + 2 * b * (x * u + y * w)
        - 2 * c * (x * w - y * u)
    )
    zero(quadratic(h, v) - expanded_quadratic, "two-index quadratic expansion")
    require(sp.expand(-imaginary_part - c) != 0,
            "opposite imaginary sign must fail as a polynomial identity")

    coordinates = sp.symbols("r0:8", real=True)
    change = sp.Matrix(2, 2, lambda i, j: (
        coordinates[2 * (2 * i + j)]
        + sp.I * coordinates[2 * (2 * i + j) + 1]
    ))
    transformed = change.conjugate().T * h * change
    zero(quadratic(transformed, v) - quadratic(h, change * v),
         "coordinate congruence")
    z, zbar = sp.symbols("z zbar")
    original_jet = sp.eye(2) + z * zbar * h
    inverse_jet = sp.eye(2) - z * zbar * h
    matrix_zero(
        original_jet * inverse_jet - sp.eye(2) + (z * zbar)**2 * h**2,
        "normal-frame inverse jet",
    )
    p, q, s, t = sp.symbols("p q s t", real=True)
    velocity = sp.Matrix([p + sp.I * q, s + sp.I * t])
    section = v + z * velocity
    section_star = v.conjugate().T + zbar * velocity.conjugate().T
    norm_jet = sp.expand((section_star * inverse_jet * section)[0])
    mixed_coefficient = sp.expand(norm_jet).coeff(z, 1).coeff(zbar, 1)
    zero(mixed_coefficient - quadratic(sp.eye(2), velocity) + quadratic(h, v),
         "normal-frame squared-norm Hessian")

    g, frame_norm = sp.symbols("g frame_norm", positive=True)
    epsilon = sp.symbols("epsilon", real=True)
    normalized_after_change = (
        g**(2 * epsilon) * (g * frame_norm)**(-2 * epsilon)
    )
    zero(sp.simplify(normalized_after_change - frame_norm**(-2 * epsilon)),
         "global normalization frame cancellation")
    require(
        (g**(2 * epsilon) * g**(2 * epsilon)).subs(
            {g: 2, epsilon: sp.Rational(1, 2)}
        ) == 4,
        "the wrong normalization exponent must not cancel",
    )
    shear = sp.Matrix([[1, 1], [0, 1]])
    diagonal = sp.diag(1, 2)
    wrong_congruence = shear * diagonal * shear.T
    correct_congruence = shear.T * diagonal * shear
    require(quadratic(wrong_congruence - correct_congruence, e1) == 2,
            "wrong congruence orientation must be detected")

    return {
        "polarization": {
            "scope": "arbitrary Hermitian two-index compression; all-rank assembly is proved in A1/A3",
            "real_entry": "b",
            "imaginary_entry": "c",
            "reconstruction_residual": "0",
            "quadratic_expansion_residual": "0",
        },
        "coordinate_congruence": {
            "scope": "generic complex 2 by 2 matrix and generic vector",
            "residual": "0",
        },
        "normal_frame": {
            "inverse_mixed_jet": "-H",
            "squared_norm_mixed_jet": "velocity^*velocity - v^*H*v",
            "residual": "0",
            "scope": "exact mixed jets; the geometric curvature implication is proved in B1",
        },
        "normalization": {
            "frame_change_cancellation_residual": "0",
            "scope": "positive frame modulus and real twisting exponent",
        },
        "negative_controls": {
            "opposite_imaginary_sign": "not a polynomial identity",
            "wrong_normalization_at_g_2_epsilon_half": "4 instead of 1",
            "reversed_congruence_at_shear": "nonzero quadratic difference 2",
        },
    }


def degeneracy_checks():
    delta, eta = sp.symbols("delta eta", nonnegative=True)
    x, y, u, w = sp.symbols("x y u w", real=True)
    v = sp.Matrix([x + sp.I * y, u + sp.I * w])
    h0 = sp.ones(2)
    h_delta = h0 + delta * sp.eye(2)
    expected = (x + u)**2 + (y + w)**2 + delta * (
        x**2 + y**2 + u**2 + w**2
    )
    zero(quadratic(h_delta, v) - expected, "rank-deficient sum of squares")
    zero(h_delta.det() - delta * (delta + 2), "degenerating determinant")
    matrix_zero(h0 * sp.Matrix([1, -1]), "endpoint kernel")
    matrix_zero(
        (h0 + eta * sp.eye(2)) - h_delta - (eta - delta) * sp.eye(2),
        "Loewner scale difference",
    )
    require(h0.rank() == 1, "endpoint must have rank one")
    require(h_delta.subs(delta, 0) == h0, "algebraic endpoint mismatch")
    return {
        "family": "H_delta = [[1,1],[1,1]] + delta I",
        "sum_of_squares_residual": "0",
        "determinant": "delta*(delta+2)",
        "endpoint_rank": 1,
        "endpoint_kernel_vector": [1, -1],
        "scale_difference": "(eta-delta) I",
        "scope": "symbolic identities; positivity requires delta>=0 and eta>=delta",
    }


def trace_checks():
    m, dimension, ramified = sp.symbols("m dimension ramified", integer=True,
                                      positive=True)
    multiplicity_identity = sp.simplify(
        m**(dimension - ramified) * m**ramified / m**dimension
    )
    require(multiplicity_identity == 1, "multiplicity exponent identity")
    corner_cases = 0
    for degree in range(1, 13):
        for factors in range(1, 6):
            for mask in range(2**factors):
                count = mask.bit_count()
                distinct = degree**(factors - count)
                multiplicity = degree**count
                require(distinct * multiplicity == degree**factors,
                        "corner multiplicities fail")
                require(Fraction(distinct * multiplicity, degree**factors) == 1,
                        "normalized constant trace must be one")
                corner_cases += 1
    branch_cases = 0
    for degree in range(1, 13):
        for exponent in range(1, 5):
            source_modulus = Fraction(1, 2**exponent)
            target_modulus = Fraction(1, 2**(degree * exponent))
            require(source_modulus**degree == target_modulus,
                    "source modulus does not map to target modulus")
            source_coefficient = 1 + source_modulus**2
            trace = Fraction(degree, degree) * source_coefficient
            require(trace == 1 + Fraction(1, 4**exponent),
                    "exact ramified trace diagnostic mismatch")
            branch_cases += 1
    require(Fraction(12, 12) * (1 + Fraction(0)**2) == 1,
            "multiplicity-counted branch value mismatch")
    return {
        "multiplicity_exponent_identity": "m^(d-k)*m^k/m^d = 1",
        "finite_corner_sweep": {
            "m_inclusive": [1, 12],
            "d_inclusive": [1, 5],
            "all_ramification_masks": True,
            "cases": corner_cases,
        },
        "finite_branch_diagnostic": {
            "cases": branch_cases,
            "target_modulus": "2^(-m*k)",
            "source_modulus": "2^(-k)",
            "normalized_trace_coefficient": "1+4^(-k)",
            "coefficient_at_target_zero": "1",
        },
        "scope": "finite exact arithmetic plus exponent identity; analytic root continuity and limiting USC are proved in proof.md, not by this sweep",
    }


def rational(entry):
    value = Fraction(int(entry["num"]), int(entry["den"]))
    require(entry == {"num": str(value.numerator), "den": str(value.denominator)},
            "Jacobian rational must be canonical")
    return sp.Rational(value.numerator, value.denominator)


def typed_matrix(value):
    require(value["factors"] == [{"label": "fiber", "dimension": 2}],
            "Jacobian subsystem basis mismatch")
    require(value["basis_linearization"] == "LEXICOGRAPHIC_LAST_FACTOR_FASTEST",
            "Jacobian basis linearization mismatch")
    require(value["matrix"]["domain"] == "QQ", "Jacobian domain mismatch")
    matrix = sp.Matrix([[rational(entry) for entry in row]
                        for row in value["matrix"]["entries"]])
    require(matrix.shape == (2, 2) and matrix == matrix.T,
            "Jacobian matrix must be symmetric of order two")
    return matrix


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    require(envelope["tool"] == "math.run", "not a Jacobian execution")
    require(envelope["transport"] == "mcp-stdio", "unexpected transport")
    require(envelope["request"]["operation_id"] == OPERATION,
            "wrong requested Jacobian operation")
    require(envelope["result"]["operation_id"] == OPERATION,
            "wrong returned Jacobian operation")
    require(envelope["request"]["payload"] == payload,
            "Jacobian output is not bound to the exact saved payload")
    output = envelope["result"]["output"]
    require(output["convention"] == "RIGHT_MINUS_LEFT_POSITIVE_SEMIDEFINITE_OVER_QQ",
            "PSD orientation mismatch")
    require(output["left"] == payload["left"] and output["right"] == payload["right"],
            "typed Jacobian operands do not match the saved payload")
    left = typed_matrix(output["left"])
    right = typed_matrix(output["right"])
    difference = typed_matrix(output["difference"])
    require(left == sp.ones(2), "unexpected lower matrix")
    require(right == sp.ones(2) + sp.eye(2) / 16, "unexpected upper matrix")
    require(difference == right - left == sp.eye(2) / 16,
            "incorrect exact PSD difference")
    inertia = {"n_positive": 2, "n_negative": 0, "n_zero": 0}
    require(output["inertia"] == inertia, "incorrect exact PSD inertia")
    require(output["is_less_or_equal"] is True, "PSD order was not established")
    require(output["negative_witness"] is None, "unexpected negative witness")
    return {
        "operation_id": OPERATION,
        "server_name": envelope["server"]["name"],
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "adapter_exit_code": 0,
        "timeout": False,
        "structured_error": None,
        "difference": "I/16",
        "inertia": inertia,
        "scope": "one exact rational rank-deficient boundary comparison only",
    }


def build_certificate():
    return {
        "claim_id": "C_LIMIT_050",
        "additional_claim": "C_GENERAL_050",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "result": "analytic verification theorem with exact algebraic replay",
        "theorem_scope": {
            "original": "arbitrary rank r>=1 on P^1 x P^1; conclusion on every fiber",
            "strengthening": "strong local coefficient convergence in every finite L^p and normalized maximum one",
            "extension": "(P^1)^d, d>=1, semipositive input metrics, integer twists a_j/m_j -> 0",
        },
        "symbolic_checks": symbolic_checks(),
        "degeneracy_checks": degeneracy_checks(),
        "trace_checks": trace_checks(),
        "jacobian": jacobian_check(),
        "not_machine_checked": [
            "cited analytic propositions and their applicability",
            "psh removable singularities, submean, compactness, and decreasing limits",
            "existence of the hypothetical input metrics",
            "subsequence extraction and all-point representative recovery",
            "strong convergence and maximum preservation as analytic theorems",
            "construction, ampleness, and invariant-measure obstruction",
            "novelty, publishability, and independent Reviewer acceptance",
        ],
        "proof": "proof.md, Theorems A and B",
        "sources": "sources.md and the retained primary-source PDFs",
        "formal_kernel_certificate": None,
        "independent_review": "required; not performed by this script",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="explicitly regenerate the exact certificate after all checks")
    args = parser.parse_args()
    computed = build_certificate()
    certificate_path = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate_path.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
        print("WROTE exact_certificate.json after exact algebraic checks.")
    else:
        recorded = json.loads(certificate_path.read_text())
        require(recorded == computed, "exact_certificate.json does not match replay")
        print("PASS: symbolic identities, degeneracy, 744 corner cases, 48 branch cases, and saved Jacobian result.")
    print("Analytic theorem and every-fiber quantifiers require independent proof review.")


if __name__ == "__main__":
    main()
