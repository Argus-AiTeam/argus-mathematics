#!/usr/bin/env python3
"""Replay the exact algebra in proof.md; this is not a QFT model checker."""

import argparse
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def null_rotation(u, v):
    return sp.Matrix(
        [
            [1, (u**2 + v**2) / 2, u, v],
            [0, 1, 0, 0],
            [0, u, 1, 0],
            [0, v, 0, 1],
        ]
    )


def require_zero(name, expression, identities):
    entries = list(expression) if isinstance(expression, sp.MatrixBase) else [expression]
    residues = [sp.cancel(entry) for entry in entries]
    if any(entry != 0 for entry in residues):
        raise AssertionError(f"{name}: nonzero exact remainder {residues}")
    identities.append(name)


def rational_function(expression, variables):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    num = sp.Poly(numerator, *variables, domain=sp.QQ)
    den = sp.Poly(denominator, *variables, domain=sp.QQ)
    leading = den.LC()

    def sparse(polynomial):
        return {
            "terms": [
                {
                    "coefficient": {
                        "num": str((coefficient / leading).p),
                        "den": str((coefficient / leading).q),
                    },
                    "exponents": list(exponents),
                }
                for exponents, coefficient in polynomial.terms()
                if coefficient != 0
            ]
        }

    return {
        "domain": "QQ",
        "variables": [str(variable) for variable in variables],
        "numerator": sparse(num),
        "denominator": sparse(den),
    }


def matrix_payload(matrix, variables):
    return {
        "variables": [str(variable) for variable in variables],
        "entries": [
            [rational_function(matrix[i, j], variables) for j in range(matrix.cols)]
            for i in range(matrix.rows)
        ],
    }


def jacobian_request():
    u, v, s, t = sp.symbols("u v s t")
    variables = [u, v, s, t]
    return {
        "left": matrix_payload(null_rotation(u, v), variables),
        "right": matrix_payload(null_rotation(s, t), variables),
    }


def decode_matrix(data):
    variables = [sp.Symbol(name) for name in data["variables"]]

    def polynomial(data):
        result = sp.S.Zero
        for term in data["terms"]:
            coefficient = term["coefficient"]
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            if len(term["exponents"]) != len(variables):
                raise AssertionError("Jacobian exponent tuple has the wrong dimension")
            for variable, exponent in zip(variables, term["exponents"]):
                monomial *= variable**exponent
            result += monomial
        return result

    def entry(data):
        if data["variables"] != [str(variable) for variable in variables]:
            raise AssertionError("Jacobian changed the rational-function field")
        denominator = polynomial(data["denominator"])
        if denominator == 0:
            raise AssertionError("Jacobian returned a zero denominator")
        return polynomial(data["numerator"]) / denominator

    return sp.Matrix([[entry(item) for item in row] for row in data["entries"]])


def verify_algebra():
    identities = []
    u, v, s, t = sp.symbols("u v s t")
    metric = sp.Matrix(
        [[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, -1, 0], [0, 0, 0, -1]]
    )
    rotation = null_rotation(u, v)
    require_zero(
        "null_rotation_group_law",
        rotation * null_rotation(s, t) - null_rotation(u + s, v + t),
        identities,
    )
    require_zero(
        "null_rotation_preserves_minkowski_metric",
        rotation.T * metric * rotation - metric,
        identities,
    )
    require_zero("null_rotation_determinant_one", rotation.det() - 1, identities)
    for entry in rotation:
        if entry != 0 and sp.Poly(entry, u, v).total_degree() > 2:
            raise AssertionError("Null-rotation matrix degree exceeds two")

    q1, q2, r1, r2, b, mo, z = sp.symbols(
        "q1 q2 r1 r2 b mo z", real=True
    )
    radius = r1**2 + r2**2
    w1, w2 = q1 + r1, q2 + r2
    a = (mo**2 + w1**2 + w2**2) / (2 * b)
    ax = a + (z - radius) / (2 * b)
    output = sp.Matrix([a, b, w1, w2])
    transfer = sp.Matrix([ax, 0, q1, q2])
    require_zero(
        "output_mass_shell",
        (output.T * metric * output)[0] - mo**2,
        identities,
    )
    require_zero(
        "first_virtuality",
        (transfer.T * metric * transfer)[0] + q1**2 + q2**2,
        identities,
    )
    leg = output - transfer
    require_zero(
        "second_virtuality",
        (leg.T * metric * leg)[0] + z,
        identities,
    )
    translated_output = output.subs(
        {r1: r1 + b * u, r2: r2 + b * v}, simultaneous=True
    )
    translated_transfer = transfer.subs(
        {r1: r1 + b * u, r2: r2 + b * v}, simultaneous=True
    )
    require_zero(
        "null_rotation_translates_r_at_fixed_q_X_z",
        rotation * output - translated_output,
        identities,
    )
    require_zero(
        "null_rotation_transports_transfer_at_fixed_z",
        rotation * transfer - translated_transfer,
        identities,
    )
    require_zero(
        "null_rotation_matrix_is_z_independent", rotation.diff(z), identities
    )

    mass, z0 = sp.symbols("M z0", positive=True)
    scalar, sz, sz1, sz2, t11, t12 = sp.symbols("l sz sz1 sz2 t11 t12")
    denominator = mass**2 + radius
    direction = sp.Matrix(
        [
            (radius - mass**2) / denominator,
            -2 * mass * r1 / denominator,
            -2 * mass * r2 / denominator,
        ]
    )
    tensor = sp.Matrix(
        [
            [sz, sz1, sz2],
            [sz1, -sz / 2 + t11, t12],
            [sz2, t12, -sz / 2 - t11],
        ]
    )
    require_zero("polarization_direction_is_unit", direction.dot(direction) - 1, identities)
    direct_wave = denominator * (scalar / 3 + (direction.T * tensor * direction)[0])
    tf = (r1**2 - r2**2) * t11 + 2 * r1 * r2 * t12
    vector = r1 * sz1 + r2 * sz2
    wave = (
        denominator * scalar / 3
        + (radius - 5 * mass**2 + 6 * mass**4 / denominator) * sz
        + (-4 * mass + 8 * mass**3 / denominator) * vector
        + 4 * mass**2 * tf / denominator
    )
    require_zero("D_chi_expansion_all_polarizations", direct_wave - wave, identities)
    subtraction = (
        denominator * scalar / 3
        + (mass**2 - 5 * radius) * sz
        + (4 * mass - 8 * radius / mass) * vector
        + 4 * tf
    )
    tail = (
        6 * radius**2 * sz / denominator
        + 8 * radius**2 * vector / (mass * denominator)
        - 4 * radius * tf / denominator
    )
    require_zero(
        "exact_large_mass_regularization_remainder",
        wave - subtraction - tail,
        identities,
    )
    reflection = {r1: -r1, sz1: -sz1, t12: -t12}
    require_zero(
        "cutoff_prescription_respects_transverse_reflection",
        subtraction.subs(reflection, simultaneous=True) - subtraction,
        identities,
    )

    x, y, Q, xd, yd = sp.symbols("x y Q xd yd")
    require_zero("power_quotient_induction_base", (x - y) * 1 - (x - y), identities)
    require_zero(
        "power_quotient_induction_step_for_arbitrary_d",
        (x - y) * (x * Q + yd)
        - (x * xd - y * yd)
        - x * ((x - y) * Q - (xd - yd)),
        identities,
    )
    require_zero(
        "power_quotient_denominator_is_M2_plus_R",
        (radius - z0) - (-mass**2 - z0) - denominator,
        identities,
    )
    numerator = sp.cancel(denominator * wave)
    if sp.Poly(numerator, r1, r2).total_degree() > 4:
        raise AssertionError("Wave numerator degree exceeds four")
    if sp.Poly(subtraction, r1, r2).total_degree() > 3:
        raise AssertionError("Cutoff polynomial degree exceeds three")

    wnorm = w1**2 + w2**2
    outden = mo**2 + wnorm
    first_row = sp.Matrix(
        [(wnorm - mo**2) / outden, -2 * mo * w1 / outden, -2 * mo * w2 / outden]
    )
    require_zero("output_frame_first_row_is_unit", first_row.dot(first_row) - 1, identities)
    n = sp.Matrix([1, 0, 0, 0])
    barn = sp.Matrix([0, 1, 0, 0])
    transverse1 = sp.Matrix([0, 0, 1, 0])
    transverse2 = sp.Matrix([0, 0, 0, 1])
    ez_n = mo * n / b - output / mo
    ez_bar = mo * barn / a - output / mo
    e1_bar = transverse1 + w1 * barn / a
    e2_bar = transverse2 + w2 * barn / a
    require_zero(
        "output_frame_relation_from_actual_tetrads",
        ez_n - first_row[0] * ez_bar - first_row[1] * e1_bar - first_row[2] * e2_bar,
        identities,
    )
    for entry in ez_n:
        if entry != 0 and sp.Poly(entry, r1, r2).total_degree() > 2:
            raise AssertionError("Adapted output-frame degree exceeds two")
    halfturn = sp.Matrix(
        [[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, -1, 0], [0, 0, 0, 1]]
    )
    reflected_output = halfturn * output
    require_zero(
        "horizon_halfturn_has_no_longitudinal_label_sign",
        halfturn * ez_n - (mo * barn / b - reflected_output / mo),
        identities,
    )
    require_zero(
        "horizon_halfturn_transverse_sign",
        halfturn * (transverse1 + w1 * n / b)
        + (transverse1 - w1 * barn / b),
        identities,
    )
    Az, Bz, B1, B2 = sp.symbols("Az Bz B1 B2")
    gap_relation = Az - first_row.dot(sp.Matrix([Bz, B1, B2]))
    two_horizon = outden * Az - (wnorm - mo**2) * Bz + 2 * mo * (w1 * B1 + w2 * B2)
    require_zero(
        "D_two_horizon_denominator_clearing",
        outden * gap_relation - two_horizon,
        identities,
    )
    return identities


def verify_jacobian(identities):
    request_path = ROOT / "jacobian_request.json"
    result_path = ROOT / "jacobian_result.json"
    if json.loads(request_path.read_text()) != jacobian_request():
        raise AssertionError("Saved Jacobian payload is not the stated null-rotation product")
    envelope = json.loads(result_path.read_text())
    operation = "matrix.symbolic.multiply.compute"
    if envelope["schema_version"] != 1 or envelope["tool"] != "math.run":
        raise AssertionError("Unexpected Jacobian adapter response schema")
    if envelope["request"] != {
        "operation_id": operation,
        "payload": jacobian_request(),
    }:
        raise AssertionError("Jacobian response is for a different operation or payload")
    result = envelope["result"]
    if "error" in envelope or "error" in result or "output" not in result:
        raise AssertionError("Jacobian did not return a complete successful typed result")
    if result["operation_id"] != operation:
        raise AssertionError("Jacobian result operation does not match the request")
    u, v, s, t = sp.symbols("u v s t")
    require_zero(
        "Jacobian_typed_null_rotation_product",
        decode_matrix(result["output"]) - null_rotation(u + s, v + t),
        identities,
    )
    return {
        "server": envelope["server"]["name"],
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "transport": envelope["transport"],
        "operation_id": operation,
        "payload_file": "jacobian_request.json",
        "typed_response_file": "jacobian_result.json",
        "adapter_status": "complete_typed_response",
        "structured_error": None,
        "timeout": False,
        "runtime_ms": result["runtime_ms"],
        "exact_output_replayed": True,
    }


def certificate(identities, jacobian):
    return {
        "claim_id": "C_SUBTRACTIONS",
        "result": "conditional_exact_verification_theorem",
        "assertion": "D:subtractions and D:two-horizon follow from the common covariant causal continuation and the stated common jump formula.",
        "hypotheses": [
            "b>0, M_o>0, M>0, z0>0; q,r are arbitrary real two-vectors",
            "The same finite Lorentz tensor family is split covariantly on both horizons.",
            "Its fixed-virtuality boundary values have the common gap, jump signs and uniform finite growth asserted by D:causal-continuation.",
            "D:jump holds with the same nonzero normalization on both horizons.",
            "The stated finite polarization waves and bounded Fourier transforms of the positive measure are used.",
            "One common sufficiently high Cauchy subtraction order d>=2 is used before contraction.",
        ],
        "unreviewed_manuscript_dependencies": [
            "ass:framework",
            "D:plane-matrix",
            "D:causal-continuation",
            "D:jump",
            "D:measure-input",
        ],
        "exact_zero_remainders": identities,
        "jacobian": jacobian,
        "arbitrary_order_identity": {
            "definition": "Q_d(x,y)=sum_{j=0}^{d-1} x^(d-1-j)y^j",
            "identity": "(x-y)Q_d=x^d-y^d for every integer d>=1",
            "induction": "Q_1=1; Q_(d+1)=x Q_d+y^d; base and symbolic induction step replayed",
            "application": "chi_C,d-chi_reg=N Q_d(R-z0,-M^2-z0)/(-M^2-z0)^d+zeta S",
            "N": "(M^2+R)chi, polynomial of transverse degree <=4",
            "degree": "deg_r(chi_C,d-chi_reg)<=2d+2 for every d>=2",
        },
        "uniform_degree_bound": {
            "parameters": "t=finite raw Lorentz tensor rank; e=uniform z-polynomial degree; d=common Cauchy order",
            "one_channel": "2t+2+2e before wave replacement; 2d+2 for the replacement",
            "separated_remainder": "N_sep=max(2t+2+2e,2d+2,3)+2",
            "qualifier": "Conservative bound; uniform in q,r. Coefficients may depend on the other transverse variable and on compact positive output-mass tests.",
        },
        "proof_obligations_in_prose": [
            "Uniform finite one-variable polynomial remainder from tempered half-plane boundary values",
            "Finite tensor covariance implies a polynomial null-rotation orbit and commutes with the common-order Cauchy operator",
            "L2 integrability and continuity for the mass regularization and coefficient interpolation",
            "Common-gap comparison, frame transformation and extension across both axes",
        ],
        "mechanical_scope": "Exact rational-function identities, the base and generic step of the all-order quotient induction, and finite degree facts. No numerical experiment is used as a proof of an analytic or QFT premise.",
        "manuscript_false_assertions_identified": [],
        "full_QFT_theorem_settled": False,
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_claimed",
        "campaign_complete": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-jacobian-request", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.write_jacobian_request:
        (ROOT / "jacobian_request.json").write_text(
            json.dumps(jacobian_request(), indent=2) + "\n"
        )
        print("Wrote the typed 4x4 null-rotation product payload.")
        return
    identities = verify_algebra()
    jacobian = verify_jacobian(identities)
    expected = certificate(identities, jacobian)
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(expected, indent=2) + "\n")
    elif json.loads(path.read_text()) != expected:
        raise AssertionError("exact_certificate.json differs from the replayed theorem and identities")
    print(f"PASS: {len(identities)} exact identities; arbitrary-order induction; finite degree bounds.")
    print("Scope: conditional subtraction theorem only; analytic premises and independent review remain explicit.")


if __name__ == "__main__":
    main()
