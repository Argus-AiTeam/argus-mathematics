#!/usr/bin/env python3
"""Replay exact localization algebra, not the geometric virtual-cycle proof."""

import argparse
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OPERATION = "polynomial.multivariate.factor.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def constant(value, dimension):
    value = Fraction(value)
    return {(0,) * dimension: value} if value else {}


def variable(index, dimension):
    powers = [0] * dimension
    powers[index] = 1
    return {tuple(powers): Fraction(1)}


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for powers, coefficient in polynomial.items():
            result[powers] = result.get(powers, Fraction(0)) + coefficient
    return {powers: coefficient for powers, coefficient in result.items() if coefficient}


def scale(polynomial, scalar):
    return {powers: coefficient * scalar for powers, coefficient in polynomial.items()
            if coefficient * scalar}


def multiply(left, right):
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            require(len(a) == len(b), "Polynomial dimensions differ")
            powers = tuple(x + y for x, y in zip(a, b))
            result[powers] = result.get(powers, Fraction(0)) + ca * cb
    return {powers: coefficient for powers, coefficient in result.items() if coefficient}


def encode(polynomial):
    return [
        {"exponents": list(powers), "coefficient": str(coefficient)}
        for powers, coefficient in sorted(polynomial.items(), reverse=True)
    ]


def rational(value):
    numerator, denominator = value["num"], value["den"]
    result = Fraction(int(numerator), int(denominator))
    require(str(result.numerator) == numerator, "Noncanonical rational numerator")
    require(str(result.denominator) == denominator, "Noncanonical rational denominator")
    return result


def decode(value):
    require(value["domain"] == "QQ", "Expected an exact QQ polynomial")
    variables = value["variables"]
    require(variables == ["q", "p"], "Unexpected Jacobian variable order")
    result = {}
    previous = None
    for term in value["polynomial"]["terms"]:
        powers = tuple(term["exponents"])
        coefficient = rational(term["coefficient"])
        require(len(powers) == len(variables), "Incorrect exponent arity")
        require(all(type(e) is int and e >= 0 for e in powers), "Invalid exponent")
        require(coefficient != 0, "Zero sparse term")
        require(previous is None or powers < previous, "Noncanonical sparse ordering")
        result[powers] = coefficient
        previous = powers
    return result


def check_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    raw = json.loads((ROOT / "jacobian_result.json").read_text())
    contract = json.loads((ROOT / "jacobian_contract.json").read_text())
    adapter = json.loads((ROOT / "jacobian_adapter_status.json").read_text())
    require(adapter["operation_id"] == OPERATION, "Adapter operation mismatch")
    require(adapter["exit_code"] == 0, "The adapter did not complete successfully")
    require(not adapter["external_timeout_used"], "Unexpected external timeout")
    require((ROOT / adapter["stderr_file"]).read_text() == "", "Adapter stderr is nonempty")
    require(raw["request"] == {"operation_id": OPERATION, "payload": payload},
            "The typed result is not bound to the preserved payload")
    require(contract["result"]["operation"]["operation_id"] == OPERATION,
            "The inspected contract names another operation")
    require(raw["result"]["operation_id"] == OPERATION, "Typed operation mismatch")
    require(raw["protocol_version"] == contract["protocol_version"] == "2025-11-25",
            "Protocol mismatch")
    require(raw["server"]["name"] == contract["server"]["name"] == "jacobian",
            "Unexpected server")
    require(raw["server"]["version"] == contract["server"]["version"] == "0.14.0",
            "Server-version mismatch")
    output = raw["result"]["output"]
    require(output["status"] == "FACTORIZED", "Jacobian returned a non-conclusion")
    require(output["product_reconstruction"] == "EXACT", "Inexact reconstruction")
    require(output["normalization"] == "CONTENT_AND_MONIC_IRREDUCIBLES",
            "Unexpected factor normalization")
    requested = decode(payload["polynomial"])
    product = constant(rational(output["coefficient"]), 2)
    for entry in output["factors"]:
        multiplicity = entry["multiplicity"]
        require(type(multiplicity) is int and 1 <= multiplicity <= 64,
                "Invalid factor multiplicity")
        for _ in range(multiplicity):
            product = multiply(product, decode(entry["factor"]))
    require(product == requested == decode(output["reconstructed"]),
            "The returned factors do not reconstruct the requested polynomial")

    q, p = variable(0, 2), variable(1, 2)
    q2 = multiply(q, q)
    left = add(p, scale(q, -2))
    right = add(scale(q2, 8), scale(q, -2), scale(p, -1))
    require(multiply(left, right) == requested, "Incorrect support factorization")
    return {
        "operation_id": OPERATION,
        "server_version": raw["server"]["version"],
        "protocol_version": raw["protocol_version"],
        "adapter_exit_code": adapter["exit_code"],
        "typed_status": output["status"],
        "polynomial_variables": ["q", "p"],
        "polynomial": encode(requested),
        "positive_on_interval_factors": [encode(left), encode(right)],
        "independent_product_reconstruction": True,
    }


def check_support_and_ranks():
    q, p, n = [variable(i, 3) for i in range(3)]
    q2 = multiply(q, q)
    gap = multiply(
        add(p, scale(q, -2)),
        add(scale(q2, 8), scale(q, -2), scale(p, -1)),
    )
    hodge_defect = add(
        multiply(scale(q2, 8), add(scale(n, 2), p)),
        scale(multiply(p, p), -1),
    )
    scaled_dimension = add(
        multiply(scale(q2, 16), add(n, q)), scale(q2, -4)
    )
    require(add(hodge_defect, scale(gap, -1)) == scaled_dimension,
            "Hodge and interval signs do not imply the support estimate")

    nu, l1d, l2d, kd, dsq, chi = [variable(i, 6) for i in range(6)]
    ch2 = add(nu, l1d, scale(dsq, Fraction(-1, 2)))
    chi_vq = add(scale(ch2, 2), scale(add(kd, l1d, l2d), -1))
    chi_qq = scale(dsq, -1)
    derived_rank = add(chi_vq, scale(chi_qq, -1), chi, constant(-1, 6))
    expected_rank = add(scale(nu, 2), l1d, scale(l2d, -1),
                        scale(kd, -1), chi, constant(-1, 6))
    require(derived_rank == expected_rank, "Incorrect Riemann--Roch rank")

    c = variable(0, 1)
    one = constant(1, 1)
    surface_square = scale(c, 8)
    t = add(scale(c, 25), scale(one, -1))
    point_nu = add(t, scale(one, -1))
    length = add(point_nu, scale(surface_square, 3))
    rank = add(scale(t, 2), c, scale(one, -3))
    hyperplane_dimension = add(c, scale(surface_square, 3), scale(one, -1))
    chi_b = add(c, scale(surface_square, Fraction((-4) * (-5), 2)))
    chi_minus_a = add(c, scale(surface_square, Fraction((-1) * (-2), 2)))
    require(length == add(scale(c, 49), scale(one, -2)), "Incorrect surviving length")
    require(rank == add(scale(c, 51), scale(one, -5)), "Incorrect virtual rank")
    require(hyperplane_dimension == t, "Incorrect hyperplane dimension")
    require(chi_b == scale(c, 81), "Incorrect outside hyperplane exponent")
    require(chi_minus_a == scale(c, 9), "Incorrect omitted base-complex rank")
    moving_rank = add(length, chi_minus_a, scale(chi_b, -1))
    fixed_rank = add(length, t)
    require(add(fixed_rank, moving_rank) == rank,
            "The fixed and moving theories do not reconstruct the total virtual rank")
    rank_gap = add(rank, scale(t, -2))
    require(rank_gap == add(c, scale(one, -3)), "Incorrect rank-gap sign")

    ordered_divisors = [(0, 3), (3, 0), (1, 2), (2, 1)]
    lengths = [
        add(point_nu, scale(surface_square, (1 - d1) * d2))
        for d1, d2 in ordered_divisors
    ]
    require(lengths == [length, point_nu, point_nu,
                        add(point_nu, scale(surface_square, -1))],
            "Ordered branch lengths disagree")
    b = 5
    c0 = (b - 1) ** 2
    boundary = {"b": b, "chi": c0, "s": 8 * c0, "t": 25 * c0 - 1,
                "N": 49 * c0 - 2, "v": 51 * c0 - 5, "v_minus_2t": c0 - 3}
    require(boundary["v_minus_2t"] == 13, "Incorrect least-genus rank margin")
    return {
        "support_identity_variables": ["q", "p", "n"],
        "hodge_defect_minus_interval_product": encode(scaled_dimension),
        "integrality_step": "16q^2(n+q)<=4q^2 and integer n+q imply n+q<=0",
        "rank_identity_variables": ["nu", "L1.D", "L2.D", "K.D", "D^2", "chi"],
        "rank_identity": encode(derived_rank),
        "parameter_variable": "chi",
        "surviving_length": encode(length),
        "virtual_rank": encode(rank),
        "rank_minus_2t": encode(rank_gap),
        "outside_hyperplane_exponent": encode(chi_b),
        "omitted_base_complex_rank": encode(chi_minus_a),
        "moving_virtual_rank": encode(moving_rank),
        "fixed_virtual_rank": encode(fixed_rank),
        "fixed_plus_moving_equals_total_rank": True,
        "ordered_divisor_multiples": [list(pair) for pair in ordered_divisors],
        "ordered_lengths": [encode(value) for value in lengths],
        "least_admissible_genus": boundary,
    }


def hom(source, target, twist):
    return {(a, b, twist): ca * cb
            for a, ca in source.items() for b, cb in target.items() if ca * cb}


def check_moving_ratio():
    ideal1, ideal2 = {"O": 1, "Z1": -1}, {"O": 1, "Z2": -1}
    line, point1 = {"O": 1}, {"Z1": 1}
    arrows = [
        ("1", hom(ideal1, line, "-A")),
        ("1-x", scale(hom(ideal1, ideal2, "B"), -1)),
        ("-1+x", hom(ideal2, point1, "-B")),
    ]
    duality = {
        ("1", "O", "O", "-A"): "e_1(Rpi(-A))",
        ("1", "Z1", "O", "-A"): "e_1(T_r(K+A)^dual)",
        ("1-x", "O", "O", "B"): "e_(1-x)(Rpi(B))",
        ("1-x", "Z1", "O", "B"): "e_(1-x)(T_r(K-B)^dual)",
        ("1-x", "O", "Z2", "B"): "e_(1-x)(T_s(B))",
        ("1-x", "Z1", "Z2", "B"): "e_(1-x)(C_B)",
        ("-1+x", "O", "Z1", "-B"): "e_(-1+x)(T_r(-B))",
        ("-1+x", "Z2", "Z1", "-B"): "e_(1-x)(C_(K+B))",
    }
    inverse_euler = {}
    expanded = []
    for weight, terms in arrows:
        for (source, target, twist), coefficient in sorted(terms.items()):
            factor = duality[(weight, source, target, twist)]
            inverse_euler[factor] = inverse_euler.get(factor, 0) - coefficient
            expanded.append({"weight": weight, "source": source, "target": target,
                             "twist": twist, "tangent_coefficient": coefficient})
    expected = {
        "e_1(Rpi(-A))": -1,
        "e_1(T_r(K+A)^dual)": 1,
        "e_(1-x)(Rpi(B))": 1,
        "e_(1-x)(T_r(K-B)^dual)": -1,
        "e_(1-x)(T_s(B))": -1,
        "e_(1-x)(C_B)": 1,
        "e_(-1+x)(T_r(-B))": -1,
        "e_(1-x)(C_(K+B))": 1,
    }
    require(inverse_euler == expected, "The direct arrow expansion differs from moving-ratio")
    point_chern_degree = 2
    require(2 * point_chern_degree > 2, "Cross-Hom rank-zero degree argument failed")
    cross_rank = 0
    require((-1) ** cross_rank == 1, "An erroneous dual-weight rank sign was introduced")

    k, d, x = [variable(i, 3) for i in range(3)]
    obstruction_line = add(k, scale(d, -1), scale(x, -1))
    dual_line = scale(obstruction_line, -1)
    require(dual_line == add(scale(k, -1), d, x), "High Euler shift is not +x")
    require(dual_line != add(scale(k, -1), d, scale(x, -1)),
            "The incorrect -x shift was not distinguished")
    a = variable(0, 1)
    based_cancellation = add(scale(a, -1),
                             scale(add(constant(1, 1), scale(a, -1)), -1))
    require(based_cancellation == constant(-1, 1), "Trace summands failed to cancel")
    return {
        "direct_moving_arrow_terms": expanded,
        "inverse_euler_exponents": inverse_euler,
        "cross_hom_virtual_rank": cross_rank,
        "dual_weight_cross_sign": 1,
        "fixed_high_dual_line_variables": ["K", "D", "x"],
        "fixed_high_dual_line": encode(dual_line),
        "fixed_high_euler_shift": "+x",
        "omitted_base_euler_scalar": 1,
        "outside_hyperplane_exponent": "chi(B)=chi+10s=81chi",
        "geometric_inputs_not_computed": [
            "relative surface Serre duality",
            "proper base change",
            "rank-zero cross Hom from surface Riemann--Roch",
            "the compatible obstruction theories and their Euler classes",
        ],
    }


def check_codimension_and_signs():
    t, k, n = [variable(i, 3) for i in range(3)]
    incidence_codimension = scale(add(scale(t, 3), scale(k, -1), scale(n, -1)), 2)
    available = add(scale(t, 4), scale(k, -2))
    difference = add(incidence_codimension, scale(available, -1))
    require(difference == scale(add(t, scale(n, -1)), 2),
            "Short-length comparison has a sign error")
    size = variable(0, 1)
    generic_slack = add(scale(add(scale(size, 2), constant(-2, 1)), 3),
                        scale(size, -4))
    require(generic_slack == add(scale(size, 2), constant(-6, 1)),
            "Incorrect large-block slack")
    require(3 * 2 - 4 == 2 and 3 * 4 - 4 * 2 == 4,
            "Incorrect one- or two-output slack")
    triple_crossings = 3 * (3 - 1) // 2
    adjacent_surface_swap_crossings = 2 * 2
    require((-1) ** triple_crossings == -1, "Incorrect triple-axis grouping sign")
    require((-1) ** adjacent_surface_swap_crossings == 1,
            "Even surface inputs must commute")
    return {
        "short_length_variables": ["t", "k", "n_points"],
        "incidence_minus_available_codimension": encode(difference),
        "block_slack": {"size_1": 2, "size_2": 4,
                        "size_at_least_3": "2k-6"},
        "zero_total_slack": "All positive block sizes are 3",
        "one_triple_axis_grouping_sign": -1,
        "adjacent_surface_input_swap_sign": 1,
        "common_partition_sign": "(-1)^t in the displayed axis convention",
        "labeled_normalization": "(3t)!; nonzero over QQ",
        "geometric_cost_hypotheses": "Assumed Section 04 tensor rules and reviewed recursion",
    }


def certificate():
    return {
        "claim": "C53_LOCALIZATION",
        "result_kind": "uniform_prose_verification_with_exact_algebra",
        "geometry_proof": "REPORT.md, Sections 1-6",
        "full_geometry_is_kernel_verified": False,
        "tensor_model_independently_verified": False,
        "independent_host_review": "required; not asserted by this certificate",
        "novelty_and_publishability": "not certified",
        "jacobian_support_factorization": check_jacobian(),
        "support_and_virtual_rank_algebra": check_support_and_ranks(),
        "moving_euler_bookkeeping": check_moving_ratio(),
        "codimension_and_koszul_bookkeeping": check_codimension_and_signs(),
        "formal_numeric_claim": {
            "claim": "C53_LOC_NUMERICS",
            "source": "lean/Main.lean",
            "fidelity": "lean/statement_fidelity.md",
            "compiler_evidence": "lean/lean_check.json",
            "offline_algebra_replay_is_not_a_Lean_compilation": True,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Generate the exact algebra certificate after checking every identity")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == result,
                "Persisted certificate differs from the exact replay")
    print(json.dumps({"exact_algebra": "passed", "certificate": str(path),
                      "geometric_proof": "prose; independent review required",
                      "tensor_model": "unverified input"}, sort_keys=True))


if __name__ == "__main__":
    main()
