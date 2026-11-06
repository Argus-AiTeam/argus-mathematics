#!/usr/bin/env python3
"""Replay exact algebra supporting proof.md; this is not a virtual-class checker."""

import copy
import itertools
import json
import math
import re
import sys
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.normal_form.smith.certified.compute"


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def determinant(matrix):
    n = len(matrix)
    require(all(len(row) == n for row in matrix), "nonsquare determinant")
    total = 0
    for permutation in itertools.permutations(range(n)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(n)
            for j in range(i + 1, n)
        )
        total += (-1) ** inversions * math.prod(
            matrix[i][permutation[i]] for i in range(n)
        )
    return total


def multiply(left, right):
    require(len(left[0]) == len(right), "incompatible matrix dimensions")
    return [
        [sum(x * y for x, y in zip(row, column)) for column in zip(*right)]
        for row in left
    ]


def typed_matrix(value):
    require(value["domain"] == "ZZ", "matrix domain is not ZZ")
    rows, columns = value["row_count"], value["column_count"]
    entries = value["entries"]
    require(len(entries) == rows, "incorrect typed row count")
    require(all(len(row) == columns for row in entries), "incorrect column count")
    require(
        all(
            isinstance(entry, str) and re.fullmatch(r"0|-?[1-9][0-9]*", entry)
            for row in entries
            for entry in row
        ),
        "noncanonical integer entry",
    )
    return [[int(entry) for entry in row] for row in entries]


def maximal_minor_gcd(matrix):
    n = len(matrix)
    minors = (
        determinant([[row[j] for j in columns] for row in matrix])
        for columns in itertools.combinations(range(len(matrix[0])), n)
    )
    return math.gcd(*minors)


def power_map_matrix(weights):
    g = math.gcd(*weights)
    return [
        [weight if i == j else 0 for j in range(len(weights))] + [weight // g]
        for i, weight in enumerate(weights)
    ]


def check_smith(response, payload, contract):
    require("error" not in response, "adapter returned an error")
    require(response["result"].get("error") is None, "operation returned an error")
    require(response["tool"] == "math.run", "not a typed execution")
    require(response["transport"] == "mcp-stdio", "unexpected adapter transport")
    require(response["request"]["operation_id"] == OPERATION, "wrong operation")
    require(response["request"]["payload"] == payload, "request payload changed")
    require(response["result"]["operation_id"] == OPERATION, "wrong result operation")
    require(
        response["server"] == contract["server"]
        and response["protocol_version"] == contract["protocol_version"],
        "inspection/execution server or protocol mismatch",
    )
    require(
        contract["result"]["operation"]["operation_id"] == OPERATION,
        "wrong inspected contract",
    )
    output = response["result"]["output"]
    require(output["exactness"] == "EXACT_INTEGER", "nonexact output")
    require(
        output["completeness"] == "FULL_MATRIX_TRANSFORMATIONS",
        "incomplete output is not evidence",
    )
    certificate = output["certificate"]
    require(
        certificate["relation"] == "DIAGONAL_EQUALS_LEFT_TIMES_SOURCE_TIMES_RIGHT",
        "unexpected Smith relation",
    )
    source = typed_matrix(certificate["source"])
    diagonal = typed_matrix(certificate["diagonal"])
    left = typed_matrix(certificate["left_transformation"])
    right = typed_matrix(certificate["right_transformation"])
    require(source == typed_matrix(payload["matrix"]), "certificate source mismatch")
    require(source == power_map_matrix([2, 4, 6]), "wrong torus-lattice presentation")
    require(multiply(multiply(left, source), right) == diagonal, "D != U*A*V")
    require(abs(determinant(left)) == abs(determinant(right)) == 1, "not unimodular")
    require(
        determinant(left) == int(certificate["left_determinant"])
        and determinant(right) == int(certificate["right_determinant"]),
        "incorrect reported determinant",
    )
    expected_diagonal = [[1, 0, 0, 0], [0, 2, 0, 0], [0, 0, 12, 0]]
    require(diagonal == expected_diagonal, "wrong canonical Smith diagonal")
    require(certificate["rank"] == 3, "wrong rank")
    require(certificate["invariant_factors"] == ["1", "2", "12"], "wrong factors")
    coarse_degree = maximal_minor_gcd(source)
    generic_stabilizer = math.gcd(2, 4, 6)
    require(coarse_degree == 24, "incorrect coarse torus degree")
    require(coarse_degree * generic_stabilizer == 48, "generic gerbe factor lost")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "invariant_factors": [1, 2, 12],
        "coarse_degree": coarse_degree,
        "generic_stabilizer_order": generic_stabilizer,
        "stack_degree": coarse_degree * generic_stabilizer,
        "weighted_degree": "1/48",
    }


def rooted_tree_identities():
    count = 0
    for n in range(1, 8):
        for choices in itertools.product(*(range(v) for v in range(1, n))):
            parents = [-1, *choices]
            children = [[v for v in range(1, n) if parents[v] == p] for p in range(n)]
            subtree = [[int(v == i) for i in range(n)] for v in range(n)]
            for v in range(n - 1, 0, -1):
                for i in range(n):
                    subtree[parents[v]][i] += subtree[v][i]
            for v in range(n):
                after = [
                    int(i == v)
                    - (subtree[v][i] if v else 0)
                    + sum(subtree[w][i] for w in children[v])
                    for i in range(n)
                ]
                require(after == ([1] * n if v == 0 else [0] * n), "twist identity")
            count += 1
    return {"increasing_labeled_trees": count, "max_vertices": 7, "symbolic_degrees": True}


def add_polynomials(left, right, factor=1):
    result = left.copy()
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, 0) + factor * coefficient
        if result[monomial] == 0:
            del result[monomial]
    return result


def multiply_polynomials(left, right):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            exponent = tuple(i + j for i, j in zip(a, b))
            result[exponent] = result.get(exponent, 0) + x * y
    return {key: value for key, value in result.items() if value}


def boundary_gap_identity():
    one = {(0, 0, 0, 0): 1}
    d0, s, t, r = [{tuple(int(i == j) for i in range(4)): 1} for j in range(4)]
    delta = add_polynomials({(0, 0, 0, 0): 2}, s)
    u = add_polynomials(one, t)
    d = add_polynomials(add_polynomials(d0, multiply_polynomials(delta, u)), r)
    h = add_polynomials(d, {(0, 0, 0, 0): 2}, -1)
    root_image = add_polynomials(
        add_polynomials(d0, u), {(0, 0, 0, 0): 2}, -1
    )
    gap = add_polynomials(h, root_image, -1)
    expected = add_polynomials(
        add_polynomials(add_polynomials(add_polynomials(one, s), t), r),
        multiply_polynomials(s, t),
    )
    require(gap == expected, "boundary gap polynomial is incorrect")
    require(all(value > 0 for value in gap.values()), "gap not coefficientwise positive")
    require(gap[(0, 0, 0, 0)] == 1, "strict gap lost")
    return {
        "substitution": "delta=2+s, u=1+t, d=d0+delta*u+r",
        "domain": "s,t,r are nonnegative; d0 is arbitrary",
        "gap_polynomial": "1+s+t+s*t+r",
        "strict_lower_bound": 1,
        "verification": "exact formal coefficient identity and nonnegative monomials",
    }


def affine_polynomial(coefficients, scale, shift, b):
    return [
        sum(
            coefficients[i] * math.comb(i, k) * scale**k * shift ** (i - k)
            for i in range(k, b + 1)
        )
        / scale**b
        for k in range(b + 1)
    ]


def center_tuple(polynomials, b):
    shift = -polynomials[0][b - 1] / b
    centered = [affine_polynomial(p, Fraction(1), shift, b) for p in polynomials]
    require(centered[0][b - 1] == 0, "translation did not center the tuple")
    return centered


def coefficient_charts():
    count = 0
    for b in range(1, 11):
        polynomials = [
            [Fraction((-1) ** (b - k) * (k + 1), b + 1) for k in range(b)]
            + [Fraction(1)],
            [Fraction(k + 1, k + 2) for k in range(b)] + [Fraction(0)],
            [Fraction((-1) ** k * (b - k), b + 2) for k in range(b)] + [Fraction(0)],
        ]
        centered = center_tuple(polynomials, b)
        for scale in [Fraction(2), Fraction(-3, 2), Fraction(3, 5)]:
            for shift in [Fraction(0), Fraction(2, 7)]:
                transformed = [
                    affine_polynomial(p, scale, shift, b) for p in polynomials
                ]
                recentered = center_tuple(transformed, b)
                residual = [
                    affine_polynomial(p, scale, Fraction(0), b) for p in centered
                ]
                require(recentered == residual, "affine chart transition is not scaling")
                for p, q in zip(centered, residual):
                    require(
                        all(q[k] == p[k] * scale ** (k - b) for k in range(b + 1)),
                        "wrong coefficient weight",
                    )
                count += 1
    return {"exact_affine_chart_tests": count, "projective_degrees": [1, 10]}


def constant_root_tests():
    count = 0
    for e1, e2 in itertools.product(range(1, 5), repeat=2):
        b = e1 + e2
        polynomial = [Fraction(0)] * (b + 1)
        for k in range(e2 + 1):
            polynomial[e1 + k] = Fraction(math.comb(e2, k) * (-1) ** (e2 - k))
        centered = center_tuple([polynomial], b)[0]
        require(any(centered[k] for k in range(b - 1)), "two attachments became one root")
        count += 1
    return {"two_attachment_constant_roots": count, "attachment_multiplicities": [1, 4]}


def stabilizer_tests():
    for k in range(1, 9):
        b = 2 * k
        active_weights = [b - k, b]
        require(math.gcd(*active_weights) == k, "cover stabilizer does not match tuple")
    return {
        "veronese_multiple_cover_tests": 8,
        "maps": "f(z)=z^k into P1, followed by its quadratic Veronese embedding",
        "active_weights": "k,2*k",
        "pointed_stabilizer_order": "k",
    }


def weighted_lattice_tests():
    count = 0
    for size in range(1, 5):
        for weights in itertools.product(range(1, 7), repeat=size):
            product = math.prod(weights)
            g = math.gcd(*weights)
            index = maximal_minor_gcd(power_map_matrix(weights))
            require(index == product // g, "coarse weighted power-map degree")
            require(index * g == product, "stack degree missing stabilizer")
            require(Fraction(1, product) >= Fraction(1, max(weights) ** size), "degree bound")
            count += 1
    return {"ordered_weight_tuples": count, "weight_range": [1, 6], "dimensions": [0, 3]}


def projective_space_calibration():
    count = 0
    for n, b in itertools.product(range(1, 5), range(1, 9)):
        weights = [1] * n + [j for j in range(2, b + 1) for _ in range(n + 1)]
        h = (n + 1) * b - 2
        require(len(weights) == h + 1, "projective evaluation-fiber dimension")
        require(math.prod(weights) == math.factorial(b) ** (n + 1), "factorial degree")
        require(Fraction(1, math.prod(weights)) >= Fraction(1, b ** (h + 1)), "calibration")
        count += 1
    return {
        "weight_product_calibrations": count,
        "conditional_geometric_formula": "<tau_((N+1)*b-2)(pt)>_b^PN=1/(b!)^(N+1)",
        "warning": "The invariant formula uses proof.md; this code checks its weight product only.",
    }


def rejection_tests(response, payload, contract):
    bad_matrix = copy.deepcopy(response)
    bad_matrix["result"]["output"]["certificate"]["left_transformation"]["entries"][0][0] = "2"
    bad_error = copy.deepcopy(response)
    bad_error["result"]["error"] = {"code": "INCOMPLETE_TEST_OUTPUT"}
    for bad in [bad_matrix, bad_error]:
        try:
            check_smith(bad, payload, contract)
        except VerificationError:
            continue
        raise VerificationError("a deliberately invalid Jacobian certificate was accepted")
    return {"invalid_certificate_rejections": 2}


def verify():
    def read_json(name):
        return json.loads((ROOT / name).read_text(encoding="utf-8"))

    certificate = read_json("exact_certificate.json")
    response = read_json("jacobian_smith_output.json")
    payload = read_json("jacobian_smith_payload.json")
    contract = read_json("jacobian_smith_contract.json")
    adapter = read_json("jacobian_adapter_status.json")
    require(adapter["operation_id"] == OPERATION, "adapter status for wrong operation")
    require(adapter["exit_status"] == 0 and not adapter["timed_out"], "adapter did not complete")
    require(adapter["structured_error"] is None, "adapter error is not evidence")
    require(adapter["outcome"] == "complete_exact_output", "adapter outcome incomplete")
    checks = {
        "jacobian_smith": check_smith(response, payload, contract),
        "rooted_tree_twist": rooted_tree_identities(),
        "boundary_gap": boundary_gap_identity(),
        "coefficient_charts": coefficient_charts(),
        "constant_root": constant_root_tests(),
        "stabilizers": stabilizer_tests(),
        "weighted_degrees": weighted_lattice_tests(),
        "projective_space_calibration": projective_space_calibration(),
        "negative_tests": rejection_tests(response, payload, contract),
    }
    require(certificate["exact_checks"] == checks, "recorded exact facts differ from replay")
    require(
        certificate["certificate_kind"] == "exact_algebra_supporting_geometric_proof",
        "certificate must not claim to machine-check virtual geometry",
    )
    require(certificate["independent_review"] == "pending", "no independent review supplied here")
    require(certificate["novelty_status"] == "not_established", "novelty not verified by this code")
    return {"ok": True, "certificate_kind": certificate["certificate_kind"], "exact_checks": len(checks)}


if __name__ == "__main__":
    try:
        print(json.dumps(verify(), sort_keys=True))
    except (VerificationError, OSError, KeyError, TypeError, ValueError) as error:
        print(f"verification failed: {error}", file=sys.stderr)
        sys.exit(1)
