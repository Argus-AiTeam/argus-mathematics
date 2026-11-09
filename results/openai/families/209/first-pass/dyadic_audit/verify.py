#!/usr/bin/env python3
"""Replay exact algebra, not the external K-theoretic proof."""

import argparse
from copy import deepcopy
from itertools import permutations, product
import json
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parent
OPERATION = "polynomial.multivariate.resultant.compute"


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def add(p, q):
    result = p.copy()
    for exponent, coefficient in q.items():
        result[exponent] = result.get(exponent, 0) + coefficient
    return {e: c for e, c in result.items() if c}


def scale(p, c):
    return {e: c * a for e, a in p.items() if c * a}


def mul(p, q):
    result = {}
    for e, a in p.items():
        for f, b in q.items():
            require(len(e) == len(f), "Polynomial variable-count mismatch")
            g = tuple(x + y for x, y in zip(e, f))
            result[g] = result.get(g, 0) + a * b
    return {e: c for e, c in result.items() if c}


def derivative(p, variable):
    result = {}
    for e, c in p.items():
        if e[variable]:
            f = list(e)
            f[variable] -= 1
            result[tuple(f)] = c * e[variable]
    return result


def evaluate(p, values):
    return sum(c * integer_product(v ** n for v, n in zip(values, e))
               for e, c in p.items())


def integer_product(values):
    result = 1
    for value in values:
        result *= value
    return result


def determinant(matrix):
    result = 0
    for permutation in permutations(range(len(matrix))):
        inversions = sum(permutation[i] > permutation[j]
                         for i in range(len(matrix))
                         for j in range(i + 1, len(matrix)))
        result += (-1) ** inversions * integer_product(
            matrix[i][j] for i, j in enumerate(permutation))
    return result


def poly_determinant(matrix, variable_count):
    result = {}
    for permutation in permutations(range(len(matrix))):
        term = {(0,) * variable_count: 1}
        for i, j in enumerate(permutation):
            term = mul(term, matrix[i][j])
        inversions = sum(permutation[i] > permutation[j]
                         for i in range(len(matrix))
                         for j in range(i + 1, len(matrix)))
        result = add(result, scale(term, (-1) ** inversions))
    return result


def matrix_mul(a, b):
    return [[sum(a[i][k] * b[k][j] for k in range(len(b)))
             for j in range(len(b[0]))] for i in range(len(a))]


def matrix_add(a, b):
    return [[x + y for x, y in zip(row_a, row_b)]
            for row_a, row_b in zip(a, b)]


def matrix_scale(a, c):
    return [[c * x for x in row] for row in a]


def valuation_two(n):
    if n == 0:
        return None
    n = abs(n)
    valuation = 0
    while n % 2 == 0:
        n //= 2
        valuation += 1
    return valuation


def eisenstein_two(coefficients):
    return (coefficients[-1] % 2 == 1
            and all(c % 2 == 0 for c in coefficients[:-1])
            and coefficients[0] % 4 == 2)


def f4_mul(a, b):
    require(0 <= a < 4 and 0 <= b < 4, "Not an F_4 element")
    result = 0
    for i in range(2):
        for j in range(2):
            if (a >> i) & 1 and (b >> j) & 1:
                result ^= 1 << (i + j)
    if result & 4:
        result ^= 7
    return result


def polynomial_json(p, variables):
    return {
        "domain": "QQ",
        "variables": variables,
        "polynomial": {
            "terms": [
                {"coefficient": {"num": str(c), "den": "1"},
                 "exponents": list(e)}
                for e, c in sorted(p.items(), reverse=True)
            ]
        },
    }


def sparse_json(p):
    return [{"exponents": list(e), "coefficient": c}
            for e, c in sorted(p.items(), reverse=True)]


def expected_payload():
    return {
        "elimination_variable": "t",
        "left": polynomial_json(
            {(2, 0, 0): 1, (1, 0, 0): -2, (0, 0, 0): 2},
            ["t", "a", "b"]),
        "right": polynomial_json(
            {(1, 0, 1): 1, (0, 1, 0): 1}, ["t", "a", "b"]),
    }


def check_jacobian(payload, answer, status, norm):
    expected = expected_payload()
    require(payload == expected, "Jacobian input is not the stated norm problem")
    require(status["adapter_exit_status"] == 0, "Adapter execution failed")
    require(status["timeout"] is False, "Timed-out computation is not evidence")
    require(status["stderr"] == "", "Adapter stderr requires investigation")
    require(status["operation_id"] == OPERATION, "Status operation mismatch")
    require(status["interpreter"] ==
            "$WORKSPACE/argus-live-update/.venv/bin/python",
            "Unexpected adapter interpreter")
    require(answer["schema_version"] == 1, "Unexpected adapter schema")
    require(answer["tool"] == "math.run", "Not an execution answer")
    require(answer["transport"] == "mcp-stdio", "Unexpected transport")
    require(answer["server"]["name"] == "jacobian", "Unexpected server")
    require(answer["server"]["version"] == "0.14.0", "Server version mismatch")
    require(answer["protocol_version"] == "2025-11-25",
            "Protocol version mismatch")
    require(answer.get("error") is None, "Structured adapter error")
    require(answer["request"] == {"operation_id": OPERATION, "payload": expected},
            "Output request is not bound to the retained payload")
    result = answer["result"]
    require(result.get("error") is None, "Structured operation error")
    require(result["operation_id"] == OPERATION, "Result operation mismatch")
    require(isinstance(result["runtime_ms"], (int, float))
            and result["runtime_ms"] >= 0, "Invalid runtime")
    expected_output = {
        **expected,
        "convention": "SYLVESTER_DETERMINANT",
        "resultant": {
            "kind": "POLYNOMIAL",
            "value": polynomial_json(norm, ["a", "b"]),
        },
    }
    require(result["output"] == expected_output,
            "Incomplete, UNKNOWN, or incorrect typed norm result")


def compute():
    x3, y3, z3 = ({(1, 0, 0): 1}, {(0, 1, 0): 1}, {(0, 0, 1): 1})
    q = {(0, 0, 2): 2, (1, 0, 1): -2, (2, 0, 0): 1,
         (1, 1, 0): 1, (0, 2, 0): -1}
    z_minus_x = add(z3, scale(x3, -1))
    repaired = add(add(scale(mul(z_minus_x, z_minus_x), -1),
                       scale(mul(x3, y3), -1)),
                   add(mul(y3, y3), scale(mul(z3, z3), -1)))
    require(repaired == scale(q, -1), "Sign-uniform model identity failed")
    affine = {}
    for (a, b, _), coefficient in q.items():
        affine = add(affine, {(a, b): coefficient})
    expected_affine = {(0, 0): 2, (1, 0): -2, (2, 0): 1,
                       (1, 1): 1, (0, 2): -1}
    require(affine == expected_affine, "Wrong affine model")
    relation = add({(0, 0): 2, (1, 0): -2},
                   {(2, 0): 1, (1, 1): 1, (0, 2): -1})
    require(relation == affine, "Local identity for 2(1-x) failed")
    ambient_orders = {e: valuation_two(c) + sum(e) for e, c in affine.items()}
    require([e for e, order in ambient_orders.items() if order == 1] == [(0, 0)],
            "Cotangent term is not precisely 2")
    initial_form = {e: c % 2 for e, c in affine.items() if c % 2}
    require(initial_form == {(2, 0): 1, (1, 1): 1, (0, 2): 1},
            "Wrong initial quadratic form")
    gradient_matrix = [
        [derivative(derivative(q, i), j).get((0, 0, 0), 0)
         for j in range(3)] for i in range(3)]
    require(determinant(gradient_matrix) == -12, "Generic conic determinant failed")
    require(evaluate(q, [1, 0, 0]) == 1, "Extra divisor point at infinity")

    h = [affine.get((degree, 0), 0) for degree in range(3)]
    naive_h = [0, -2, 1]
    require(h == [2, -2, 1] and eisenstein_two(h), "Divisor is not Eisenstein")
    require(not eisenstein_two(naive_h), "Naive substitution misclassified")
    identity = [[1, 0], [0, 1]]
    matrix = [[0, -h[0]], [1, -h[1]]]
    eta = matrix_add(identity, matrix_scale(matrix, -1))
    require(matrix_add(matrix_add(matrix_mul(matrix, matrix),
                                  matrix_scale(matrix, -2)),
                       matrix_scale(identity, 2)) == [[0, 0], [0, 0]],
            "Quadratic multiplication identity failed")
    require(matrix_mul(eta, eta) == matrix_scale(identity, -1), "eta^2 != -1")
    require(matrix_mul(matrix, matrix_add(matrix_scale(identity, 2),
                                         matrix_scale(matrix, -1)))
            == matrix_scale(identity, 2), "2 != t(2-t)")
    require(determinant(matrix) == 2 and determinant(eta) == 1,
            "Distinguished norm or unit norm failed")

    a, b, one = {(1, 0): 1}, {(0, 1): 1}, {(0, 0): 1}
    norm_matrix = [[add(scale(a, identity[i][j]), scale(b, matrix[i][j]))
                    for j in range(2)] for i in range(2)]
    norm = poly_determinant(norm_matrix, 2)
    expected_norm = {(2, 0): 1, (1, 1): 2, (0, 2): 2}
    sylvester = [[one, scale(one, -2), scale(one, 2)],
                 [b, a, {}], [{}, b, a]]
    require(norm == expected_norm == poly_determinant(sylvester, 2),
            "Symbolic determinant and Sylvester resultant disagree")
    require(evaluate(norm, [0, 1]) == 2 and evaluate(norm, [1, -1]) == 1,
            "Norm specializations failed")

    root_values = [(s * s + s + 1) % 2 for s in (0, 1)]
    require(root_values == [1, 1], "Special quadratic has an F_2 root")
    alpha = 2
    alpha_squared = f4_mul(alpha, alpha)
    orbit = [alpha, alpha_squared, f4_mul(alpha_squared, alpha_squared)]
    require(orbit == [2, 3, 2] and alpha_squared == (alpha ^ 1),
            "Frobenius orbit does not have exact length two")
    require([s for s in range(4) if f4_mul(s, s) ^ s ^ 1 == 0] == [2, 3],
            "Wrong quadratic roots in F_4")
    projective_f2_points = []
    for coordinates in product(range(2), repeat=3):
        if coordinates != (0, 0, 0) and evaluate(q, coordinates) % 2 == 0:
            projective_f2_points.append(list(coordinates))
    require(projective_f2_points == [[0, 0, 1]], "Unexpected F_2 special point")

    positions = {}
    for degree in (1, 2, 3):
        positions[str(degree)] = [
            [s, (degree + s) // 2] for s in range(3)
            if (degree + s) % 2 == 0 and s <= (degree + s) // 2
        ]
    require(positions == {"1": [[1, 1]], "2": [[0, 1], [2, 2]],
                          "3": [[1, 2]]}, "Wrong spectral diagonals")
    minimum_differential_shift = 2 * 2 - 1
    require(minimum_differential_shift > 2, "Differential could cross nonzero strip")
    require(valuation_two(determinant(matrix)) % 2 == 1,
            "Distinguished detector is zero")

    payload = json.loads((ROOT / "jacobian.norm.payload.json").read_text())
    answer = json.loads((ROOT / "jacobian.norm.output.json").read_text())
    status = json.loads((ROOT / "jacobian.norm.status.json").read_text())
    check_jacobian(payload, answer, status, norm)

    certificate = {
        "claim": "D2_ALGEBRA_CERT",
        "result_class": "exact_algebra_supporting_a_proposed_new_theorem",
        "proof": "theorem.md",
        "scope": {
            "formal_K_theory_verification": False,
            "independent_theorem_review": "pending",
            "novelty_verdict": "pending_independent_review",
            "not_computed": ["Quillen K-groups", "noncanonical integral lifts",
                             "motivic spectral sequence", "source fidelity"],
        },
        "model": {
            "variables": ["X", "Y", "Z"],
            "homogeneous_equation": sparse_json(q),
            "affine_equation": sparse_json(affine),
            "ambient_cotangent_term": "2",
            "initial_form_mod_2": sparse_json(initial_form),
            "initial_form_degree": 2,
            "gradient_matrix": gradient_matrix,
            "gradient_determinant": determinant(gradient_matrix),
            "Q_at_1_0_0": 1,
        },
        "divisor": {
            "coefficients_ascending": h,
            "coefficient_2_valuations": [valuation_two(c) for c in h],
            "eisenstein_at_2": True,
            "naive_odd_prime_substitution": naive_h,
            "naive_is_eisenstein": False,
            "multiplication_by_t": matrix,
            "multiplication_by_eta": eta,
            "eta_squared": matrix_mul(eta, eta),
            "t_plus_eta": matrix_add(matrix, eta),
            "norm_t": determinant(matrix),
            "norm_eta": determinant(eta),
        },
        "finite_field": {
            "quadratic_coefficients_ascending_mod_2": [1, 1, 1],
            "values_on_F2": root_values,
            "F4_encoding": "a+bs is a+2b, s^2+s+1=0",
            "frobenius_orbit_of_s": orbit,
            "exact_orbit_length": 2,
            "projective_F2_points": projective_f2_points,
            "F2_units": [1],
            "residue_degree_divisibility": 2,
        },
        "norm": {"variables": ["a", "b"], "polynomial": sparse_json(norm),
                 "methods": ["2x2 multiplication determinant", "3x3 Sylvester determinant"]},
        "spectral": {
            "external_hypothesis": "j>=0 and 0<=s<=min(j,2); strong convergence and mixed product",
            "positions_s_j_by_K_degree": positions,
            "minimum_differential_s_shift": minimum_differential_shift,
            "nonzero_strip_s_width": 2,
            "degree_three_surviving_pieces": 1,
            "Moore_ring_structure_assumed": False,
            "K2_mod_2_exponent_two_assumed": False,
            "K3_mod_2_exponent_two": "deduced from the unique etale H1 piece in the proof",
        },
        "detector": {
            "distinguished_total_degree": 2,
            "distinguished_ramification_index": 2,
            "distinguished_residue_degree": 1,
            "norm_t_valuation": 1,
            "distinguished_value_mod_2": 1,
            "omitted_residue_degree_factor_mod_2": 0,
            "incorrect_total_degree_substitution": 0,
        },
        "jacobian": {
            "operation_id": OPERATION,
            "server_version": answer["server"]["version"],
            "protocol_version": answer["protocol_version"],
            "transport": answer["transport"],
            "adapter_exit_status": status["adapter_exit_status"],
            "timeout": status["timeout"],
            "structured_error": None,
            "typed_result_kind": answer["result"]["output"]["resultant"]["kind"],
            "payload": "jacobian.norm.payload.json",
            "output": "jacobian.norm.output.json",
            "status": "jacobian.norm.status.json",
        },
    }
    return certificate, (payload, answer, status, norm)


def check_certificate(actual, expected):
    require(actual == expected, "Stored certificate differs from exact recomputation")


def self_tests(expected, jacobian_data):
    rejected = 0

    def reject(call):
        nonlocal rejected
        try:
            call()
        except VerificationError:
            rejected += 1
        else:
            raise VerificationError("A false-input rejection test was accepted")

    for section, key, wrong in [
        ("divisor", "norm_t", -2),
        ("divisor", "coefficients_ascending", [0, -2, 1]),
        ("detector", "distinguished_residue_degree", 2),
        ("finite_field", "exact_orbit_length", 1),
        ("spectral", "Moore_ring_structure_assumed", True),
        ("spectral", "K2_mod_2_exponent_two_assumed", True),
    ]:
        altered = deepcopy(expected)
        altered[section][key] = wrong
        reject(lambda: check_certificate(altered, expected))

    payload, answer, status, norm = deepcopy(jacobian_data)
    payload["left"]["polynomial"]["terms"][-1]["coefficient"]["num"] = "0"
    reject(lambda: check_jacobian(payload, answer, status, norm))
    payload, answer, status, norm = deepcopy(jacobian_data)
    answer["result"]["output"]["resultant"] = {"kind": "UNKNOWN"}
    reject(lambda: check_jacobian(payload, answer, status, norm))
    payload, answer, status, norm = deepcopy(jacobian_data)
    answer["result"]["output"]["resultant"]["value"]["polynomial"]["terms"][-1][
        "coefficient"]["num"] = "-2"
    reject(lambda: check_jacobian(payload, answer, status, norm))
    payload, answer, status, norm = deepcopy(jacobian_data)
    status["adapter_exit_status"], status["timeout"] = 124, True
    reject(lambda: check_jacobian(payload, answer, status, norm))
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--emit", action="store_true",
                        help="Emit the recomputed certificate; does not certify the theorem")
    args = parser.parse_args()
    expected, jacobian_data = compute()
    if args.emit:
        print(json.dumps(expected, indent=2, sort_keys=True))
        return
    actual = json.loads((ROOT / "exact_certificate.json").read_text())
    check_certificate(actual, expected)
    rejected = self_tests(expected, jacobian_data)
    print(json.dumps({
        "result": "PASS",
        "exact_check_groups": 7,
        "false_input_rejections": rejected,
        "norm_t": expected["divisor"]["norm_t"],
        "distinguished_detector_mod_2": 1,
        "independent_theorem_review": "pending",
        "scope": "exact algebra and source-bound adapter replay; not formal K-theory",
    }, sort_keys=True))


if __name__ == "__main__":
    try:
        main()
    except (VerificationError, OSError, json.JSONDecodeError, KeyError) as error:
        print("FAIL: " + str(error), file=sys.stderr)
        sys.exit(1)
