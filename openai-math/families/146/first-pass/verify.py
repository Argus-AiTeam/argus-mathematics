#!/usr/bin/env python3
"""Replay exact algebra behind the analytic local-scarcity proof.

This does not machine-check the analytic theorem or claim a counterexample.
Run with --write-certificate once to materialize the deterministic certificate.
Subsequent ordinary runs compare every derived field with that certificate.
"""

import argparse
from collections import defaultdict
from fractions import Fraction
from itertools import product
import json
from math import factorial
from pathlib import Path


ROOT = Path(__file__).resolve().parent
LOCAL = ROOT / "local_scarcity"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compositions(n):
    if n == 0:
        yield ()
        return
    for first in range(1, n + 1):
        for rest in compositions(n - first):
            yield (first,) + rest


def exact_determinant(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    sign = 1
    answer = Fraction(1)
    for column in range(len(a)):
        pivot = next((i for i in range(column, len(a)) if a[i][column]), None)
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            a[column], a[pivot] = a[pivot], a[column]
            sign *= -1
        value = a[column][column]
        answer *= value
        for i in range(column + 1, len(a)):
            ratio = a[i][column] / value
            for j in range(column + 1, len(a)):
                a[i][j] -= ratio * a[column][j]
            a[i][column] = 0
    return sign * answer


def check_jacobian():
    payload = json.loads((LOCAL / "jacobian_alternation_payload.json").read_text())
    retained = json.loads((LOCAL / "jacobian_alternation_output.json").read_text())
    require(retained["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(retained["schema_version"] == 1, "Unexpected adapter schema")
    require(retained["protocol_version"] == "2025-11-25", "Protocol changed")
    require(retained["server"]["name"] == "jacobian", "Wrong mathematical server")
    require(retained["server"]["version"] == "0.14.0", "Server version changed")
    operation = "matrix.determinant.compute"
    require(retained["request"]["operation_id"] == operation, "Wrong requested operation")
    require(retained["result"]["operation_id"] == operation, "Wrong returned operation")
    output = retained["result"]["output"]
    require("error" not in retained and "error" not in retained["result"],
            "The retained adapter result is an error, not evidence")
    matrix = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in payload["matrix"]["entries"]
    ]
    expected = [[0, 0, 1, 1], [1, 1, 1, -1],
                [4, 2, 1, 1], [9, 3, 1, -1]]
    require(matrix == expected, "Not the four consecutive-zero equations")
    determinant = exact_determinant(matrix)
    typed = output["determinant"]
    require(determinant == Fraction(int(typed["num"]), int(typed["den"])) == 16,
            "The opposite-cosine alternation obstruction failed")
    return {
        "operation_id": operation,
        "server_version": retained["server"]["version"],
        "protocol_version": retained["protocol_version"],
        "transport": retained["transport"],
        "adapter_status": "success",
        "adapter_error": None,
        "timeout": False,
        "payload_file": "research/local_scarcity/jacobian_alternation_payload.json",
        "typed_output_file": "research/local_scarcity/jacobian_alternation_output.json",
        "determinant": str(determinant),
        "scope": "Exact four-zero quadratic alternation obstruction, not sine-orbit scarcity.",
        "capability_mismatch": (
            "Inspected rational and symbolic determinant contracts accept bounded matrices, "
            "not sine-map orbit inequalities, arbitrary path lengths, Hausdorff limits, "
            "or a universal analytic-scarcity theorem. No nearby operation is treated as "
            "an oracle for that theorem."
        ),
    }


def check_formal_core():
    run = json.loads((LOCAL / "lean_run.json").read_text())
    recording = run["kernel"]["recorded"]
    require(recording is not None, "The compiler result was not attached to its claim")
    require(run["kernel"]["refusals"] == [], "Lean evidence recording was refused")
    require(recording["subject"]["subject_id"] == "C_FORMAL_ALGEBRA",
            "The formal certificate names another claim")
    require(recording["tier"] == "mechanical" and recording["verdict"] == "supports",
            "This is not supporting mechanical evidence")
    archive = json.loads((ROOT.parent / recording["artifact"]).read_text())
    check = archive["lean_check"]
    require(check == json.loads((LOCAL / "lean_check.json").read_text()),
            "Archived and current compiler results disagree")
    require(check["status"] == "success" and check["exit_code"] == 0,
            "The retained Lean compilation did not succeed")
    require(check["proof_holes"] == [] and check["audit_exit_code"] == 0,
            "The retained formal source has proof holes")
    require("version 4.31.0," in check["tools"]["lean"]["version"],
            "The retained run used a different Lean version")
    require(archive["lean_source"]["text"] == (LOCAL / "Main.lean").read_text(),
            "The formal source changed after compilation")
    require(archive["statement_fidelity"]["text"]
            == (LOCAL / "statement_fidelity.md").read_text(),
            "The statement-fidelity reading changed after compilation")
    return {
        "claim_id": "C_FORMAL_ALGEBRA",
        "source": "research/local_scarcity/Main.lean",
        "statement_fidelity": "research/local_scarcity/statement_fidelity.md",
        "archived_certificate": recording["artifact"],
        "lean_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "scope": (
            "Unrestricted real-depth expanded eighth-order chain inequality, "
            "quadratic alternation, error exponents and polynomial degree obstruction. "
            "Not the full analytic scarcity theorem. This script checks the retained "
            "compiler certificate and source consistency; it does not rerun Lean."
        ),
    }


def check_inverse_chains(order):
    words = {(): 1}
    for n in range(1, order + 1):
        next_words = defaultdict(int)
        for word, coefficient in words.items():
            for i in range(len(word)):
                changed = word[:i] + (word[i] + 1,) + word[i + 1:]
                next_words[changed] += coefficient
            for i in range(len(word) + 1):
                inserted = word[:i] + (1,) + word[i:]
                next_words[inserted] -= coefficient
        words = dict(next_words)
        expected = {}
        for word in compositions(n):
            denominator = 1
            for p in word:
                denominator *= factorial(p)
            expected[word] = (-1) ** len(word) * factorial(n) // denominator
        require(words == expected, f"Inverse derivative composition failure at order {n}")
    return len(words)


def cut_value(mask, weights, c):
    endpoints = mask[0] + mask[-1]
    adjacent = sum(
        min(a, b) - c * max(a, b) for a, b in zip(mask, mask[1:])
    )
    return endpoints + adjacent - c * sum(p * x for p, x in zip(weights, mask))


def check_chain_bound(order):
    c0 = Fraction(order + 2, 2 * order - 1)
    cuts = 0
    nonempty = 0
    for weights in compositions(order):
        for mask in product((0, 1), repeat=len(weights)):
            value = cut_value(mask, weights, c0)
            bound = -Fraction(sum(mask), order)
            require(value <= bound, f"Chain cut inequality failed: {weights}, {mask}")
            cuts += 1
            nonempty += bool(sum(mask))

    left_coefficients = [Fraction(i, order) for i in range(1, order)]
    vertex_coefficients = [Fraction(0) for _ in range(order)]
    for edge, a in enumerate(left_coefficients):
        require(0 <= a <= 1, "Invalid convex min bound")
        vertex_coefficients[edge] += a
        vertex_coefficients[edge + 1] += 1 - a
    expected = [Fraction(1, order)] + [
        Fraction(order + 1, order) for _ in range(order - 2)
    ] + [Fraction(1, order)]
    require(vertex_coefficients == expected, "Weighted path sum did not telescope")
    endpoint = (1 - 2 * c0) + (1 + c0) / order
    interior = -3 * c0 + (1 + c0) * Fraction(order + 1, order)
    require(endpoint == interior == -Fraction(1, order),
            "Critical exponent calculation failed")
    require(cuts == 2 * 3 ** (order - 1), "Cut enumeration is incomplete")
    return {
        "order": order,
        "critical_c": str(c0),
        "ordered_compositions": 2 ** (order - 1),
        "all_binary_cuts": cuts,
        "nonempty_binary_cuts": nonempty,
        "convex_edge_left_coefficients": [str(x) for x in left_coefficients],
        "summed_vertex_coefficients": [str(x) for x in vertex_coefficients],
        "critical_vertex_coefficient": str(endpoint),
        "all_depth_exponent": (
            f"{order} - {2 * order - 1}*c - "
            f"sum(p_i*(d_i-1))/{order}"
        ),
        "lifting": (
            "Repeat depth d_i exactly p_i times; for c<1 expansion increases H by "
            "(1-c)*sum((p_i-1)*d_i). Weighted min bounds prove the expanded "
            "inequality for every real depth>=1. The finite cut table is an "
            "independent exact cross-check, not a depth cutoff."
        ),
        "inverse_derivative_words": check_inverse_chains(order),
    }


def differentiate_jets(expression):
    result = defaultdict(int)
    for powers, coefficient in expression.items():
        for i in range(len(powers) - 1):
            if powers[i]:
                changed = list(powers)
                changed[i] -= 1
                changed[i + 1] += 1
                result[tuple(changed)] += coefficient * powers[i]
    return {powers: coefficient for powers, coefficient in result.items() if coefficient}


def weighted_partitions(n, maximum=None):
    maximum = n if maximum is None else maximum
    if maximum == 0:
        if n == 0:
            yield ()
        return
    for multiplicity in range(n // maximum + 1):
        for lower in weighted_partitions(n - multiplicity * maximum, maximum - 1):
            yield lower + (multiplicity,)


def check_reciprocal_derivative(order):
    expression = {(-1,) + (0,) * order: 1}
    for _ in range(order):
        expression = differentiate_jets(expression)
    bell = {}
    for multiplicities in weighted_partitions(order):
        k = sum(multiplicities)
        numerator = (-1) ** k * factorial(order) * factorial(k)
        denominator = 1
        for i, count in enumerate(multiplicities, start=1):
            denominator *= factorial(count) * factorial(i) ** count
        coefficient = Fraction(numerator, denominator)
        require(coefficient.denominator == 1, "Nonintegral reciprocal derivative")
        bell[(-k - 1,) + multiplicities] = int(coefficient)
    require(expression == bell, f"Reciprocal derivative sign failure at order {order}")
    leading = (-order - 1, order) + (0,) * (order - 1)
    require(expression[leading] == (-1) ** order * factorial(order),
            "Wrong leading reciprocal derivative")
    terms = []
    for powers, coefficient in sorted(expression.items()):
        require(sum(i * powers[i] for i in range(1, order + 1)) == order,
                "A jet monomial has the wrong total derivative order")
        k = sum(powers[1:])
        if powers != leading:
            require(k < order, "A second unsuppressed leading monomial exists")
        terms.append({
            "coefficient": coefficient,
            "powers_S0_through_Sn": list(powers),
            "relative_w_power": order - k,
        })
    return {
        "order": order,
        "monomials": len(expression),
        "leading_coefficient": expression[leading],
        "terms": terms,
        "meaning": (
            "Universal differential-polynomial identity for D^n(1/S). "
            "If |S^(i)|=O(r^i), |S'| is comparable to r and |S| is comparable "
            "to w->0, every nonleading term is relatively O(w) or smaller."
        ),
    }


def opposite_expansion_coefficients():
    powers = list(range(5))
    inv = [(-1) ** n for n in powers]
    derivative_squared_inverse = [(-1) ** n * (n + 1) for n in powers]
    for n in range(1, 5):
        require(sum(inv[:n + 1]) in (0, 1), "Geometric prefix error")
        require(sum(inv[i] * inv[n - i] for i in range(n + 1))
                == derivative_squared_inverse[n], "Wrong reciprocal-square series")
    require(inv[1] == -1 and derivative_squared_inverse[1] == -2,
            "Opposite-expansion sign changed")
    return {
        "D_x_of_y_inverse_squared_sec_2pi_x": "2*pi*y^(-2)*sin(2*pi*x)*sec(2*pi*x)^2",
        "D_y_of_y_inverse_squared_sec_2pi_x": "-2*y^(-3)*sec(2*pi*x)",
        "normalized_shift_coefficient": 2 * inv[1] * 2,
        "explanation": (
            "Both shifts are +2/K before taking reciprocals of opposite cosines; "
            "each contributes -2/K times sec^2. The phase difference contributes "
            "-f_x*p-f_y*p_prime. Differentiating trigonometric functions is part "
            "of the analytic proof, not asserted to be checked by this series test."
        ),
    }


def certificate():
    c = Fraction(99, 100)
    alpha = Fraction(3, 5)
    generic_error = 1 - 3 * c + 2 * alpha
    fourth_exponent = 4 - 7 * c
    eighth_exponent = 8 - 15 * c
    require(generic_error == -Fraction(77, 100), "Original matching range changed")
    require(fourth_exponent < -2 - Fraction(4, 5), "Original fourth bound not implied")
    require(9 - 15 * c < -1 and 1 - 3 * c < -1,
            "Opposite-cosine normalization is not justified")
    return {
        "claim_id": "C_SCARCITY_EXT",
        "result_class": "analytic_theorem_with_exact_algebraic_support",
        "statement": (
            "For actual standard sine-map orbits, every fixed 2/3<c<1 and "
            "alpha>=0 with 2*alpha<3*c-1 satisfy the complete uniform "
            "can:local-scarcity statement, including unbounded selected indices "
            "and h-dependent common normalized witnessing solutions."
        ),
        "proof": "research/local_scarcity/proof.md",
        "certificate_scope": (
            "Machine-replayed universal algebraic identities, chain coefficients, "
            "weighted-min summation, exhaustive finite cut reductions and retained "
            "typed Jacobian determinant. The complete analytic proof requires "
            "independent mathematical review; finite samples are not substituted."
        ),
        "false_manuscript_assertion_established": False,
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_independently_established",
        "jacobian": check_jacobian(),
        "formal_core": check_formal_core(),
        "chain_bounds": [check_chain_bound(4), check_chain_bound(8)],
        "reciprocal_derivatives": [
            check_reciprocal_derivative(4), check_reciprocal_derivative(8)
        ],
        "opposite_expansion": opposite_expansion_coefficients(),
        "original_parameters": {
            "c": str(c),
            "alpha": str(alpha),
            "success_error_exponent": str(generic_error),
            "fourth_boundary_exponent": str(fourth_exponent),
            "eighth_boundary_exponent": str(eighth_exponent),
            "eighth_Taylor_error_exponent": str(9 - 15 * c),
            "eighth_error_after_opposite_normalization": str(10 - 15 * c),
            "boundary_error_after_opposite_normalization": str(2 - 3 * c),
        },
        "excluded_overclaims": [
            "No counterexample to the manuscript has been found.",
            "No full Lean formalization of sine-orbit scarcity is claimed.",
            "No independent Reviewer verdict or publication-level novelty is invented.",
            "No conclusion about the downstream main entropy theorem is certified.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    derived = certificate()
    destination = ROOT / "exact_certificate.json"
    if args.write_certificate:
        destination.write_text(json.dumps(derived, indent=2, sort_keys=True) + "\n")
    retained = json.loads(destination.read_text())
    require(retained == derived, "The retained certificate differs from exact replay")
    print(
        "PASS: universal chain algebra (orders 4,8), 4428 cut cases, "
        "inverse/reciprocal derivative identities, alternation determinant 16, "
        "fresh-source Lean certificate."
    )
    print("Scope: exact algebraic support; full analytic theorem awaits independent review.")


if __name__ == "__main__":
    main()
