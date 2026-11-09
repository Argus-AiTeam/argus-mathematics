#!/usr/bin/env python3
"""Replay the exact algebra in REPORT.md using only the Python standard library.

The geometric and interpolation arguments are mathematical proofs in the
report, not kernel-checked proofs. The finite localization probes below are
explicitly separate from the uniform symbolic identities.
"""

import argparse
import json
from fractions import Fraction
from itertools import zip_longest
from math import comb, factorial, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent


def polynomial(coefficients):
    result = list(map(Fraction, coefficients))
    while len(result) > 1 and result[-1] == 0:
        result.pop()
    return tuple(result or [Fraction(0)])


def add(left, right):
    return polynomial(a + b for a, b in zip_longest(left, right, fillvalue=0))


def scale(value, scalar):
    return polynomial(scalar * coefficient for coefficient in value)


def multiply(left, right):
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return polynomial(result)


def derivative(value):
    return polynomial(i * value[i] for i in range(1, len(value)))


def compose(outer, inner):
    result = polynomial([0])
    for coefficient in reversed(outer):
        result = add(multiply(result, inner), polynomial([coefficient]))
    return result


def serialized(value):
    return [str(coefficient) for coefficient in value]


def determinant(matrix):
    rows = [list(map(Fraction, row)) for row in matrix]
    result = Fraction(1)
    for column in range(len(rows)):
        pivot = next(i for i in range(column, len(rows)) if rows[i][column])
        if pivot != column:
            rows[column], rows[pivot] = rows[pivot], rows[column]
            result = -result
        value = rows[column][column]
        result *= value
        for i in range(column + 1, len(rows)):
            ratio = rows[i][column] / value
            for j in range(column + 1, len(rows)):
                rows[i][j] -= ratio * rows[column][j]
            rows[i][column] = 0
    return result


def interpolation_instance(cutoff):
    bases = []
    for node in range(cutoff):
        basis = polynomial([1])
        denominator = 1
        for other in range(cutoff):
            if other != node:
                basis = multiply(basis, polynomial([-other, 1]))
                denominator *= node - other
        bases.append(scale(basis, Fraction(1, denominator)))
    weights = [
        [basis[arity - 1] / arity for basis in bases]
        for arity in range(1, cutoff + 1)
    ]
    for arity in range(1, cutoff + 1):
        for k in range(1, cutoff + 1):
            isolated = sum(
                weights[arity - 1][node] * k * node ** (k - 1)
                for node in range(cutoff)
            )
            assert isolated == (k == arity), (arity, k, isolated)
    matrix = [
        [k * node ** (k - 1) for node in range(cutoff)]
        for k in range(1, cutoff + 1)
    ]
    expected = factorial(cutoff) * prod(
        j - i for j in range(cutoff) for i in range(j)
    )
    actual = determinant(matrix)
    assert actual == expected and actual != 0
    return {
        "classification": "finite instance of the general Lagrange identity",
        "moment_cutoff": cutoff,
        "nodes": list(range(cutoff)),
        "determinant": str(actual),
        "bare_triple_weights": serialized(weights[2]),
        "all_arity_isolation_residuals_zero": True,
    }


def dual_multiply(left, right):
    # Divisor products at one position on a smooth curve are zero.
    return (
        multiply(left[0], right[0]),
        *(
            add(multiply(left[0], right[i]), multiply(left[i], right[0]))
            for i in range(1, len(left))
        ),
    )


def symbolic_identities():
    zero = polynomial([0])
    one = polynomial([1])
    w = polynomial([0, 1])
    q_of_w = polynomial([0, 1, 1])
    v = polynomial([1, 2])
    square_residual = add(multiply(v, v), scale(add(one, scale(q_of_w, 4)), -1))
    assert square_residual == zero
    assert derivative(q_of_w) == v

    d2_numerator = multiply(
        q_of_w,
        add(
            multiply(derivative(q_of_w), v),
            scale(multiply(q_of_w, derivative(v)), -1),
        ),
    )
    target_numerator = multiply(q_of_w, add(one, scale(q_of_w, 2)))
    d2_residual = add(d2_numerator, scale(target_numerator, -1))
    assert d2_residual == zero

    # Coefficients in the formal basis (1, k, j), with no values assigned.
    power_rule_coefficient = tuple(a + b for a, b in zip((4, 0, 4), (2, -4, 0)))
    recurrence_coefficient = (6, -4, 4)
    assert power_rule_coefficient == recurrence_coefficient

    q = polynomial([0, 1])
    p_k = one
    numerator_k = q_of_w
    generated = {}
    for k in range(1, 7):
        assert numerator_k == multiply(q_of_w, compose(p_k, q_of_w))
        generated[str(k)] = serialized(p_k)
        numerator_k = multiply(
            q_of_w,
            add(
                multiply(v, derivative(numerator_k)),
                scale(numerator_k, -2 * (2 * k - 1)),
            ),
        )
        p_k = add(
            multiply(add(one, scale(q, 6 - 4 * k)), p_k),
            multiply(multiply(q, add(one, scale(q, 4))), derivative(p_k)),
        )

    d = polynomial([0, 1])
    intersection = add(one, scale(d, -1))
    h2 = scale(multiply(intersection, add(polynomial([2]), scale(d, -1))), Fraction(1, 2))
    degree1 = add(one, scale(d, 2))
    degree2 = add(multiply(d, d), polynomial([-1]))
    exponent_a = add(
        add(degree1, degree2),
        add(scale(one, -2), add(scale(h2, -2), scale(intersection, 4))),
    )
    exponent_b = add(add(one, h2), scale(intersection, -2))
    assert exponent_a == d
    assert exponent_b == scale(multiply(d, add(d, one)), Fraction(1, 2))

    t = w
    constant = lambda value: polynomial([value])
    left = dual_multiply(
        (t, constant(-1), constant(-1), zero),
        (t, zero, constant(-1), constant(-2)),
    )
    right = dual_multiply(
        (t, constant(-1), constant(-1), constant(-1)),
        (t, zero, constant(-1), constant(-1)),
    )
    curve_residual = [add(a, scale(b, -1)) for a, b in zip(left, right)]
    assert all(value == zero for value in curve_residual)

    cross_roots = [(1, (1, 0)), (1, (0, -1)), (-1, (0, 0)), (-1, (1, -1))]
    assert sum(sign for sign, _ in cross_roots) == 0
    assert all(sum(sign * root[i] for sign, root in cross_roots) == 0 for i in range(2))
    return {
        "classification": "exact symbolic polynomial identities, not series agreement",
        "variable": "w",
        "q": serialized(q_of_w),
        "v": serialized(v),
        "v_squared_minus_1_minus_4q": serialized(square_residual),
        "D_squared_w_numerator": serialized(d2_numerator),
        "D_squared_w_denominator": "(1+2w)^3",
        "D_squared_w_target_residual": serialized(d2_residual),
        "general_derivative_recurrence": {
            "formula": "P_(k+1)=(1+(6-4k)q)P_k+q(1+4q)P_k', P_1=1",
            "basis": ["1", "k", "j"],
            "generic_q_coefficient_by_power_rule": list(power_rule_coefficient),
            "generic_q_coefficient_by_recurrence": list(recurrence_coefficient),
            "generated_P_k": generated,
        },
        "unmarked_exponent_A_divided_by_sK": serialized(exponent_a),
        "unmarked_exponent_B_divided_by_sK": serialized(exponent_b),
        "curve_one_body_residual_basis_1_K_A_D": [serialized(value) for value in curve_residual],
        "cross_Hom_virtual_roots": [[sign, list(root)] for sign, root in cross_roots],
        "shift_of_M0_H3_linear_term": "-3 M_0(H^2)",
        "triple_exponential_normalizations": [
            str(Fraction(1, 6**j * factorial(j))) for j in range(7)
        ],
    }


def partitions(size, maximum=None):
    if size == 0:
        yield ()
        return
    upper = size if maximum is None else min(size, maximum)
    for first in range(upper, 0, -1):
        for tail in partitions(size - first, first):
            yield (first, *tail)


def complete_homogeneous(weights, degree):
    coefficients = [1] + [0] * degree
    for weight in weights:
        for k in range(1, degree + 1):
            coefficients[k] += weight * coefficients[k - 1]
    return coefficients[degree]


def small_root(order):
    coefficients = [Fraction(0)] * order
    if order > 1:
        coefficients[1] = Fraction(1)
    for n in range(2, order):
        coefficients[n] = -sum(coefficients[i] * coefficients[n - i] for i in range(1, n))
    return coefficients


def local_euler_derivative(partition, a, b):
    size = sum(partition)
    contents = []
    tangent = 1
    for row, width in enumerate(partition):
        for column in range(width):
            content = column * a + row * b
            contents.append(content)
            arm = width - column - 1
            leg = sum(other_width > column for other_width in partition[row + 1 :])
            tangent *= ((arm + 1) * a - leg * b) * ((leg + 1) * b - arm * a)
    assert tangent != 0, ("non-isolated chosen torus weights", partition, a, b)
    nonorigin = contents[1:]
    assert len(nonorigin) == size - 1 and all(nonorigin)
    euler_derivative = prod(nonorigin)
    moving_coefficient = complete_homogeneous(contents, size - 1)
    return Fraction(size * a * b * euler_derivative * moving_coefficient, tangent)


def localization_probes(maximum):
    results = []
    root = small_root(maximum + 1)
    for a, b in [(11, 37), (7, 19), (5, -13)]:
        coefficients = []
        counts = []
        for size in range(1, maximum + 1):
            shapes = list(partitions(size))
            actual = sum(
                (local_euler_derivative(shape, a, b) for shape in shapes),
                Fraction(0),
            )
            catalan = Fraction(comb(2 * size - 2, size - 1), size)
            expected = root[size]
            assert expected == (-1) ** (size - 1) * catalan
            assert actual == expected, (size, a, b, actual, expected)
            coefficients.append(actual)
            counts.append(len(shapes))
        results.append({
            "tangent_weights": [a, b],
            "partition_counts": counts,
            "bare_one_Euler_derivative": serialized(coefficients),
            "bare_triple_Euler_derivative": serialized(
                size**2 * value for size, value in enumerate(coefficients, 1)
            ),
        })
    return {
        "classification": "finite falsification probes; not the uniform proof",
        "lengths": [1, maximum],
        "derivation": "REPORT.md, Independent localization probe",
        "chambers": results,
    }


def rational_values(series):
    return [Fraction(int(value["num"]), int(value["den"])) for value in series["coefficients"]]


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    operation = "formal_series.rational.multiply.compute"
    assert status["operation_id"] == operation
    assert status["adapter_exit_status"] == 0 and status["timeout"] is False
    assert response["request"]["operation_id"] == operation
    assert response["request"]["payload"] == payload
    assert response["result"]["operation_id"] == operation
    output = response["result"]["output"]
    assert output["exactness"] == "EXACT_RATIONAL"
    assert output["residual_congruence"] == "EXACT_MOD_X_TO_N"
    assert output["left"] == payload["left"] and output["right"] == payload["right"]
    assert output["left"]["variable"] == output["right"]["variable"] == "q"
    order = payload["left"]["truncation_order"]
    assert order == payload["right"]["truncation_order"] == 6
    left = rational_values(payload["left"])
    right = rational_values(payload["right"])
    root = small_root(order)
    expected_left = [n**2 * root[n] for n in range(order)]
    expected_right = [Fraction(1)]
    for n in range(1, order):
        expected_right.append(expected_right[-1] * (Fraction(3, 2) - n + 1) * 4 / n)
    assert left == expected_left and right == expected_right
    convolution = [
        sum(left[i] * right[n - i] for i in range(n + 1))
        for n in range(order)
    ]
    assert convolution == rational_values(output["result"])
    assert output["result"]["variable"] == "q"
    assert output["result"]["truncation_order"] == order
    assert len(output["result"]["coefficients"]) == order
    assert convolution == [
        Fraction(int(value["num"]), int(value["den"]))
        for value in output["convolution_ledger"]
    ]
    assert convolution == list(map(Fraction, [0, 1, 2, 0, 0, 0]))
    return {
        "operation_id": operation,
        "protocol_version": response["protocol_version"],
        "server_version": response["server"]["version"],
        "adapter_exit_status": status["adapter_exit_status"],
        "timeout": status["timeout"],
        "structured_error": response.get("error", response["result"].get("error")),
        "exactness": output["exactness"],
        "recomputed_product_mod_q6": serialized(convolution),
        "classification": "bounded adapter probe, independently recomputed offline",
    }


def derive_certificate():
    return {
        "result": "Uniform marked-coefficient transfer and an all-arity structural extension",
        "mathematical_proof": "REPORT.md",
        "uniform_statement": {
            "cutoffs": "every finite Hilbert length, marked-output, and shift cutoff",
            "arity": "every integer m>=1",
            "bare_evaluation": "actual unmarked moments; M_m(1)=1; other marked moments zero",
            "logarithm": "log E_m(Theta)=log Theta_unmarked+C_m p^m/m!",
            "all_shifts_arity_identity": "C_m=(q d/dq)^(m-1) C_1",
            "zero_Euler_shift": "C_m(q,0,x_m)=0",
            "diagonal_first_shift": "[x] C_m(q,x,x)=(q d/dq)^(m-1)w, w(1+w)=q",
            "triple": "[x] C_3=q(1+2q)/(1+4q)^(3/2)",
        },
        "scope": {
            "kernel_formal_verification": False,
            "geometric_proof": "Prose proof using the stated nested-Hilbert and Chow intersection inputs",
            "machine_checked": "Exact symbolic identities, constructive interpolation instance, finite localization probes, and typed adapter replay",
            "independent_review": "pending Host Reviewer",
            "novelty": "not certified; numerical log-additivity is known",
            "main_manuscript_theorem": "not verified or refuted",
        },
        "symbolic_identities": symbolic_identities(),
        "interpolation_instance": interpolation_instance(8),
        "localization_probes": localization_probes(8),
        "jacobian": replay_jacobian(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    certificate = derive_certificate()
    destination = HERE / "exact_certificate.json"
    if arguments.write_certificate:
        destination.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(destination.read_text())
        assert recorded == certificate, "Stored certificate differs from independently derived checks"
    print(json.dumps({
        "ok": True,
        "uniform_proof": "REPORT.md (not kernel formalized)",
        "symbolic_residuals": "zero",
        "interpolation_cutoff": 8,
        "localization_length_max": 8,
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
