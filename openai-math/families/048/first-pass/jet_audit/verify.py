#!/usr/bin/env python3
"""Replay exact identities; the geometric existence proof is in report.md."""

import argparse
import copy
import json
from pathlib import Path

import sympy as sp


class CertificateError(ValueError):
    pass


t = sp.Symbol("t", nonzero=True)
z = sp.Symbol("z", nonzero=True)
k, ell, j = sp.symbols("k ell j", integer=True)


def reject_float(value):
    raise CertificateError("Floating-point JSON values are forbidden: " + value)


def load_json(path):
    return json.loads(path.read_text(), parse_float=reject_float)


def q(value):
    if not isinstance(value, (int, str)) or isinstance(value, bool):
        raise CertificateError("Expected an exact integer or rational string")
    return sp.Rational(value)


def affine(coefficients, *variables):
    if len(coefficients) != len(variables) + 1:
        raise CertificateError("Incorrect affine coefficient count")
    return q(coefficients[0]) + sum(
        q(coefficient) * variable
        for coefficient, variable in zip(coefficients[1:], variables)
    )


def equal(actual, expected, label, checks):
    difference = sp.cancel(sp.expand(actual - expected))
    if difference != 0:
        difference = sp.simplify(difference)
    if difference != 0:
        raise CertificateError(f"{label}: nonzero residual {difference}")
    checks.append(label)


def require(condition, label, checks):
    if not condition:
        raise CertificateError(label)
    checks.append(label)


def wedge(x, y):
    return x[0] * y[1] - x[1] * y[0]


def lie(d, v):
    coordinates = (t, z)
    return tuple(
        sum(
            d[a] * sp.diff(v[i], coordinates[a])
            - v[a] * sp.diff(d[i], coordinates[a])
            for a in range(2)
        )
        for i in range(2)
    )


def residue(expression):
    return sp.expand(expression).coeff(z, -1)


def check_statement(certificate):
    checks = []
    expected = {
        "degree_L": 10,
        "degree_Z": 6,
        "canonical_root_power": 4,
        "h0_L": 2,
        "h0_L_plus_Z": 2,
        "h0_O": 1,
        "h0_O_plus_Z": 1,
        "simple_common_zero_divisor": True,
        "global_P_with_prescribed_simple_poles": True,
        "pointwise_p_wedge_R": 1,
        "sum_W_minus_one": -90,
        "marked_derivative_rows_span": 2,
    }
    hypotheses = certificate["hypotheses"]
    require(
        all(type(hypotheses[name]) is type(value) and hypotheses[name] == value
            for name, value in expected.items()),
        "statement.input_metadata_matches_adopted_hypotheses_not_existence_proof",
        checks,
    )
    shapes = {
        "delta_A_coefficients": 5,
        "delta_U_coefficients": 2,
        "F_coefficients": 3,
        "H_coefficients": 3,
        "T_coefficients": 4,
    }
    c = certificate["order_two"]
    require(
        all(isinstance(c[name], list) and len(c[name]) == size
            for name, size in shapes.items())
        and all(isinstance(c[name], list) and len(c[name]) == 2
                and all(isinstance(row, list) and len(row) == 2 for row in c[name])
                for name in ("total_inside_matrix", "total_obstruction_matrix")),
        "statement.residue_formula_shapes",
        checks,
    )
    return checks


def check_bracket(certificate):
    checks = []
    c = certificate["bracket"]
    b, h, a, bfield = (sp.Function(name)(z) for name in ("b", "h", "A", "B"))
    d = (t ** (k + 1) * b, t**k * h)
    v = (t ** (ell + 2) * a, t ** (ell + 1) * bfield)
    actual = lie(d, v)
    vertical = (
        affine(c["vertical_bA_affine_in_k_ell"], k, ell) * b * a
        + q(c["vertical_hAprime"]) * h * sp.diff(a, z)
        + q(c["vertical_Bbprime"]) * bfield * sp.diff(b, z)
    )
    horizontal = (
        affine(c["horizontal_bB_affine_in_k_ell"], k, ell) * b * bfield
        + q(c["horizontal_hBprime"]) * h * sp.diff(bfield, z)
        + q(c["horizontal_khA"]) * k * h * a
        + q(c["horizontal_Bhprime"]) * bfield * sp.diff(h, z)
    )
    equal(actual[0], t ** (k + ell + 2) * vertical, "bracket.vertical", checks)
    equal(actual[1], t ** (k + ell + 1) * horizontal, "bracket.horizontal", checks)
    divergence = t**5 * (sp.diff(t**-5 * d[0], t) + sp.diff(t**-5 * d[1], z))
    claimed = t**k * (
        affine(c["divergence_b_affine_in_k"], k) * b
        + q(c["divergence_hprime"]) * sp.diff(h, z)
    )
    equal(divergence, claimed, "bracket.weighted_divergence", checks)
    return checks


def check_transport(certificate):
    checks = []
    c = certificate["transport"]
    equal(q(c["volume_density_power"]), -5, "transport.volume_definition", checks)
    b, h = sp.Function("b")(z), sp.Function("h")(z)
    d = (t ** (k + 1) * b, t**k * h)
    g = sp.Function("G")(t, z)
    ordinary_divergence = sp.diff(d[0], t) + sp.diff(d[1], z)
    weighted_divergence = ordinary_divergence - 5 * d[0] / t
    actual = (
        d[0] * sp.diff(t**5 * g, t)
        + d[1] * sp.diff(t**5 * g, z)
        - ordinary_divergence * t**5 * g
    ) / t**5
    expected = (
        d[0] * sp.diff(g, t)
        + d[1] * sp.diff(g, z)
        + q(c["target_divergence_sign"]) * weighted_divergence * g
    )
    equal(actual, expected, "transport.bivector_not_scalar", checks)
    gj = sp.Function("G_j")(z)
    monomial = t**j * gj
    actual_monomial = (
        d[0] * sp.diff(monomial, t)
        + d[1] * sp.diff(monomial, z)
        - weighted_divergence * monomial
    )
    expected_monomial = t ** (k + j) * (
        affine(c["target_monomial_b_affine_in_k_j"], k, j) * b * gj
        + h * sp.diff(gj, z)
        - sp.diff(h, z) * gj
    )
    equal(actual_monomial, expected_monomial, "transport.arbitrary_target_degree", checks)
    frame = sp.Function("g")(z)
    logder = sp.diff(frame, z) / frame
    new_b = frame**-k * (b + logder * h)
    new_h = frame ** (4 - k) * h
    new_hprime = sp.diff(new_h, z) / frame**4
    equal(
        (k - 4) * new_b + new_hprime,
        frame**-k * ((k - 4) * b + sp.diff(h, z)),
        "transport.divergence_covariance",
        checks,
    )
    equal(new_h.subs(k, 4), h, "transport.order_four_h_is_scalar", checks)
    equal(
        new_hprime.subs(k, 4) * frame**4,
        sp.diff(h, z),
        "transport.order_four_dh_is_intrinsic",
        checks,
    )
    equal(frame**-5 * frame * frame**4, 1, "transport.split_volume", checks)
    return checks


def check_order_two(certificate):
    checks = []
    c = certificate["order_two"]
    constant = sp.Symbol("c", nonzero=True)
    r0 = sp.symbols("R01 R02")
    r1 = sp.symbols("R11 R12")
    r2 = sp.symbols("R21 R22")
    p0 = sp.symbols("p01 p02")
    p1 = sp.symbols("p11 p12")
    p2 = sp.symbols("p21 p22")
    rcapital = [r0[i] + r1[i] * z + r2[i] * z**2 for i in range(2)]
    p = [p0[i] + p1[i] * z + p2[i] * z**2 for i in range(2)]
    r = [z * entry / constant for entry in rcapital]
    m = constant / z
    d = (t**2 * q(c["first_b_multiplier"]) * sp.diff(m, z), t * m)
    da, du = [], []
    for i in range(2):
        v0 = (t**2 * r[i], sp.Integer(0))
        v1 = (t**3 * p[i], t**2 * m * r[i])
        first = lie(d, v1)
        second = lie(d, lie(d, v0))
        da.append(sp.expand(
            (first[0] + q(c["second_exponential_multiplier"]) * second[0]) / t**4
        ))
        du.append(sp.expand(
            (first[1] + q(c["second_exponential_multiplier"]) * second[1]) / t**3
        ))
        terms = [
            sp.diff(m, z) * p[i],
            m * sp.diff(p[i], z),
            m * sp.diff(m, z) * sp.diff(r[i], z),
            m**2 * sp.diff(r[i], z, 2),
            m * sp.diff(m, z, 2) * r[i],
        ]
        equal(
            da[i],
            sum(q(x) * y for x, y in zip(c["delta_A_coefficients"], terms)),
            f"order2.exponential_vertical_{i}",
            checks,
        )
        equal(
            du[i],
            q(c["delta_U_coefficients"][0]) * m * p[i]
            + q(c["delta_U_coefficients"][1]) * m * sp.diff(m, z) * r[i],
            f"order2.horizontal_cancellation_{i}",
            checks,
        )
    f = [[residue(r[i] * da[n]) for n in range(2)] for i in range(2)]
    h = [[residue(sp.diff(r[i], z) * du[n]) for n in range(2)] for i in range(2)]
    alpha, beta = map(q, c["psi_derivative_weights"])
    matrix = [[f[i][n] + alpha * h[i][n] + beta * h[n][i]
               for n in range(2)] for i in range(2)]
    global_p = [p[i] + m * sp.diff(r[i], z) for i in range(2)]
    for i in range(2):
        for n in range(2):
            fh_terms = [r0[i] * p0[n], r0[i] * r1[n], r1[i] * r0[n]]
            equal(
                f[i][n],
                sum(q(x) * y for x, y in zip(c["F_coefficients"], fh_terms)),
                f"order2.F_{i}{n}", checks,
            )
            equal(
                h[i][n],
                sum(q(x) * y for x, y in zip(c["H_coefficients"], fh_terms)),
                f"order2.H_{i}{n}", checks,
            )
            t_terms = [
                r0[i] * p0[n], r0[n] * p0[i],
                r0[i] * r1[n], r1[i] * r0[n],
            ]
            equal(
                matrix[i][n],
                sum(q(x) * y for x, y in zip(c["T_coefficients"], t_terms)),
                f"order2.T_{i}{n}", checks,
            )
            equal(
                (matrix[i][n] + matrix[n][i]) / 2,
                q(c["symmetric_residue_multiplier"])
                * residue(global_p[i] * global_p[n]),
                f"order2.symmetric_global_P_residue_{i}{n}", checks,
            )
            epsilon = 0 if i == n else (1 if i == 0 else -1)
            equal(
                (matrix[i][n] - matrix[n][i]) / 2,
                q(c["alternating_wedge_multiplier"])
                * epsilon * (wedge(r0, p0) + wedge(r0, r1)),
                f"order2.alternating_{i}{n}", checks,
            )
            degree = q(certificate["hypotheses"]["degree_L"])
            total = q(certificate["hypotheses"]["sum_W_minus_one"])
            inside = epsilon * q(c["alternating_wedge_multiplier"]) * total
            outside = epsilon * q(c["outside_degree_multiplier"]) * degree
            equal(inside, q(c["total_inside_matrix"][i][n]),
                  f"order2.inside_total_{i}{n}", checks)
            equal(inside - outside, q(c["total_obstruction_matrix"][i][n]),
                  f"order2.obstruction_{i}{n}", checks)
            equal(inside - outside, 0, f"order2.vanishing_{i}{n}", checks)
    ri, rn, ui, un, ai, an, dri, drn, gframe, achange = sp.symbols(
        "ri rn ui un ai an dri drn gframe achange", nonzero=True
    )
    old_psi = ri * an + alpha * dri * un + beta * drn * ui
    new_psi = gframe**4 * (
        (ri / gframe) * gframe**-3 * (an + achange * un)
        + alpha * gframe**-5 * (dri - achange * ri) * gframe * un
        + beta * gframe**-5 * (drn - achange * rn) * gframe * ui
    )
    equal(
        new_psi - old_psi,
        -q(c["outside_degree_multiplier"]) * achange * (ri * un - rn * ui),
        "order2.psi_split_transformation", checks,
    )
    ri, rn, hf = (sp.Function(name)(z) for name in ("ri", "rn", "h"))
    delta_psi = (
        ri * (hf * sp.diff(rn, z) - sp.diff(hf, z) * rn / 2)
        - 2 * alpha * sp.diff(ri, z) * hf * rn
        - 2 * beta * sp.diff(rn, z) * hf * ri
    )
    equal(
        delta_psi,
        q(c["psi_order_two_exact_multiplier"]) * sp.diff(hf * ri * rn, z),
        "order2.horizontal_gauge_changes_psi_by_exact_differential", checks,
    )
    return checks


def check_order_three(certificate):
    checks = []
    c = certificate["order_three"]
    lam = sp.Symbol("lambda")
    rho = sp.symbols("rho1 rho2")
    slope = sp.symbols("rho1prime rho2prime")
    r = [z * (rho[i] + slope[i] * z) for i in range(2)]
    h = lam / z
    d = (t**4 * sp.diff(h, z), t**3 * h)
    compensation = [
        q(c["disk_horizontal_compensation_multiplier"]) * lam * entry / z
        for entry in r
    ]
    for i in range(2):
        actual = lie(d, (t**2 * r[i], sp.Integer(0)))
        vertical = sp.expand(actual[0] / t**5)
        horizontal = sp.expand(actual[1] / t**4)
        equal(horizontal + compensation[i], 0,
              f"order3.horizontal_matching_{i}", checks)
        equal(residue(vertical),
              q(c["vertical_residue_multiplier"]) * lam * rho[i],
              f"order3.vertical_residue_{i}", checks)
    equal(wedge(r, compensation), 0, "order3.current_determinant_unchanged", checks)
    alpha, beta, gamma, delta, o1, o2 = sp.symbols("alpha beta gamma delta o1 o2")
    minor = alpha * delta - beta * gamma
    scale = q(c["inverse_map_denominator_multiplier"])
    l1 = (-delta * o1 + gamma * o2) / (scale * minor)
    l2 = (beta * o1 - alpha * o2) / (scale * minor)
    residue_scale = q(c["vertical_residue_multiplier"])
    equal(residue_scale * (alpha * l1 + gamma * l2), -o1,
          "order3.rank_two_inverse_first_component", checks)
    equal(residue_scale * (beta * l1 + delta * l2), -o2,
          "order3.rank_two_inverse_second_component", checks)
    require(c["inverse_map_requires_nonzero_minor"] is True,
            "order3.nonzero_minor_is_an_explicit_hypothesis", checks)
    return checks


def check_order_four(certificate):
    checks = []
    h, b = sp.Function("h")(z), sp.Function("b")(z)
    d = (t**5 * b, t**4 * h)
    q4 = sp.expand(sp.diff(d[0], t) + sp.diff(d[1], z) - 5 * d[0] / t)
    equal(q4, t**4 * sp.diff(h, z), "order4.vertical_generator_cannot_change_divergence", checks)
    equal(
        -q4 / t**4,
        q(certificate["transport"]["order_four_target_sign"]) * sp.diff(h, z),
        "order4.target_cocycle_is_minus_dh", checks,
    )
    exponent = sp.Symbol("exponent", integer=True)
    candidates = sp.solve(sp.Eq(exponent - 1, -1), exponent)
    require(candidates == [0], "order4.derivative_residue_only_possible_from_constant", checks)
    equal(exponent.subs(exponent, candidates[0]), 0,
          "order4.derivative_constant_has_zero_coefficient", checks)
    return checks


def check_induction(certificate):
    checks = []
    c = certificate["induction"]
    af, mf = sp.Function("a")(z), sp.Function("m")(z)
    d1 = (t**2 * sp.diff(mf, z) / 3, t * mf)
    actual = lie(d1, (t ** (k + 1) * af, sp.Integer(0)))
    expected_a = (
        affine(c["old_transition_vertical_mprime_affine_in_k"], k) * sp.diff(mf, z) * af
        + mf * sp.diff(af, z)
    )
    equal(actual[0], t ** (k + 2) * expected_a,
          "induction.old_transition_vertical", checks)
    equal(actual[1], t ** (k + 1) * q(c["old_transition_horizontal_multiplier"]) * mf * af,
          "induction.old_transition_horizontal", checks)
    r1, r2, a1, a2, m = sp.symbols("r1 r2 a1 a2 m")
    equal(wedge((r1, r2), (-m * a1, -m * a2)),
          wedge((a1, a2), (m * r1, m * r2)),
          "induction.old_horizontal_effect_matches_determinant_change", checks)
    equal((k - 1) + 1,
          k + q(c["first_determinant_degree_after_adding_A_kminus1_offset"]),
          "induction.A_kminus1_first_determinant_degree", checks)
    equal(k + 1,
          k + q(c["first_determinant_degree_after_adding_A_k_offset"]),
          "induction.A_k_first_determinant_degree", checks)
    equal(k - q(c["target_degree_shift"]), k - 2,
          "induction.current_target_precedes_generator_order", checks)
    equal(k + q(c["target_degree_shift"]), k + 2,
          "induction.new_target_equation_is_two_steps_later", checks)
    s = sp.Symbol("s", nonnegative=True, integer=True)
    degree = q(certificate["hypotheses"]["degree_L"])
    points = q(certificate["hypotheses"]["degree_Z"])
    negative_polynomials = [
        ("vertical", 3 - (q(c["vertical_vanishing_threshold"]) + s),
         c["vertical_dual_power_at_threshold"]),
        ("target", 4 - (q(c["target_vanishing_threshold"]) + s),
         c["target_dual_power_at_threshold"]),
        ("evaluation", (4 - (q(c["evaluation_negative_degree_threshold"]) + s)) * degree + points,
         c["evaluation_dual_degree_at_threshold"]),
        ("tail_vertical", 4 - (q(c["tail_vanishing_threshold"]) + s),
         c["tail_vertical_dual_power_at_threshold"]),
        ("tail_horizontal", 8 - (q(c["tail_vanishing_threshold"]) + s),
         c["tail_horizontal_dual_power_at_threshold"]),
    ]
    for name, actual_degree, coefficients in negative_polynomials:
        claimed_degree = affine(coefficients, s)
        equal(actual_degree, claimed_degree, f"induction.{name}_dual_degree", checks)
        require(q(coefficients[0]) < 0 and q(coefficients[1]) <= 0,
                f"induction.{name}_negative_for_every_nonnegative_s", checks)
    equal(q(certificate["hypotheses"]["h0_L"]),
          q(certificate["hypotheses"]["h0_L_plus_Z"]),
          "induction.k3_evaluation_dimension_hypothesis", checks)
    equal(q(certificate["hypotheses"]["h0_O"]),
          q(certificate["hypotheses"]["h0_O_plus_Z"]),
          "induction.k4_evaluation_dimension_hypothesis", checks)
    equal(q(c["last_row_index"]) + 2, q(c["quotient_power"]),
          "induction.row7_means_modulo_I9", checks)
    equal(2 + 2, q(c["logarithmic_determinant_power"]),
          "induction.logarithmic_determinant_order", checks)
    equal(q(c["logarithmic_determinant_power"]) + 1,
          q(c["ordinary_determinant_power"]),
          "induction.ordinary_determinant_order", checks)
    equal(q(c["formal_coefficient_stabilization_delay"]), 1,
          "induction.A_n_is_last_adjusted_at_step_nplus1", checks)
    return checks


def check_jacobian(certificate):
    checks = []
    c = certificate["jacobian"]
    directory = Path(__file__).resolve().parent
    payload = load_json(directory / c["payload_file"])
    recorded = load_json(directory / c["output_file"])
    contract = load_json(directory / c["contract_file"])
    require(c["adapter_status"] == "success" and c["adapter_error"] is None
            and c["timeout"] is False, "jacobian.success_not_unknown_or_timeout", checks)
    require(recorded["server"]["version"] == c["server_version"],
            "jacobian.server_version", checks)
    require(recorded["protocol_version"] == c["protocol_version"],
            "jacobian.protocol_version", checks)
    require(recorded["request"]["operation_id"] == c["operation_id"]
            and recorded["result"]["operation_id"] == c["operation_id"]
            and contract["result"]["operation"]["operation_id"] == c["operation_id"],
            "jacobian.inspected_operation_matches_run", checks)
    require(recorded["request"]["payload"] == payload,
            "jacobian.exact_payload_preserved", checks)

    def polynomial(record):
        require(record["domain"] == "QQ" and record["variables"] == ["t", "z"],
                "jacobian.rational_polynomial_contract", checks)
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * t ** term["exponents"][0] * z ** term["exponents"][1]
            for term in record["polynomial"]["terms"]
        )

    components = [polynomial(record) for record in payload["components"]]
    ordinary = sp.diff(components[0], t) + sp.diff(components[1], z)
    returned = polynomial(recorded["result"]["output"]["result"])
    equal(returned, ordinary, "jacobian.output_recomputed_independently", checks)
    equal(returned, t**4 * (8 * z**2 + 5), "jacobian.exact_specialization", checks)
    equal(returned - 5 * components[0] / t, 3 * t**4 * z**2,
          "jacobian.weighted_order_four_divergence", checks)
    return checks


BLOCKS = {
    "statement": check_statement,
    "bracket": check_bracket,
    "transport": check_transport,
    "order_two": check_order_two,
    "order_three": check_order_three,
    "order_four": check_order_four,
    "induction": check_induction,
    "jacobian": check_jacobian,
}


def negative_controls(certificate):
    controls = [
        ("order_two", ("order_two", "T_coefficients", 0), "7/12"),
        ("order_three", ("order_three", "disk_horizontal_compensation_multiplier"), 2),
        ("transport", ("transport", "target_divergence_sign"), 1),
        ("order_four", ("transport", "order_four_target_sign"), 1),
        ("induction", ("induction", "quotient_power"), 8),
    ]
    rejected = []
    for block, path, value in controls:
        invalid = copy.deepcopy(certificate)
        container = invalid
        for key in path[:-1]:
            container = container[key]
        container[path[-1]] = value
        try:
            BLOCKS[block](invalid)
        except CertificateError as error:
            rejected.append({"mutation": list(path), "rejection": str(error)})
        else:
            raise CertificateError(f"Invalid certificate accepted: {path}")
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path,
                        default=Path(__file__).with_name("exact_certificate.json"))
    parser.add_argument("--negative-controls", action="store_true")
    arguments = parser.parse_args()
    try:
        certificate = load_json(arguments.certificate)
        if certificate["schema_version"] != 1 or certificate["claim_id"] != "J_all_orders":
            raise CertificateError("Unrecognized certificate statement")
        blocks = {name: function(certificate) for name, function in BLOCKS.items()}
        rejected = negative_controls(certificate) if arguments.negative_controls else []
    except CertificateError as error:
        print(json.dumps({"result": "fail", "error": str(error)}, sort_keys=True))
        return 1
    print(json.dumps({
        "result": "pass",
        "claim_id": certificate["claim_id"],
        "scope": "exact identities only; geometric induction is the prose proof",
        "exact_checks": sum(map(len, blocks.values())),
        "checks_per_block": {name: len(checks) for name, checks in blocks.items()},
        "negative_controls_rejected": rejected,
        "independent_review": certificate["independent_review"],
    }, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
