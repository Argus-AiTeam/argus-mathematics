#!/usr/bin/env python3
"""Replay exact finite checks; the general geometric proof is in report.md."""

import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def rref_pivots(matrix):
    rows = [[Fraction(x) for x in row] for row in matrix]
    assert rows and rows[0], "Expected a nonempty matrix"
    width = len(rows[0])
    assert all(len(row) == width for row in rows), "Nonrectangular matrix"
    pivots = []
    for column in range(width):
        pivot = next(
            (i for i in range(len(pivots), len(rows)) if rows[i][column]), None
        )
        if pivot is None:
            continue
        k = len(pivots)
        rows[k], rows[pivot] = rows[pivot], rows[k]
        divisor = rows[k][column]
        rows[k] = [x / divisor for x in rows[k]]
        for i in range(len(rows)):
            if i != k and rows[i][column]:
                factor = rows[i][column]
                rows[i] = [x - factor * y for x, y in zip(rows[i], rows[k])]
        pivots.append(column)
        if len(pivots) == len(rows):
            break
    return pivots


def rank(matrix):
    return len(rref_pivots(matrix))


def matmul(left, right):
    assert len(left[0]) == len(right), "Matrix dimensions do not match"
    return [
        [
            sum(Fraction(x) * Fraction(y) for x, y in zip(row, column))
            for column in zip(*right)
        ]
        for row in left
    ]


def average(matrices):
    count = len(matrices)
    return [
        [
            sum(Fraction(matrix[i][j]) for matrix in matrices) / count
            for j in range(len(matrices[0][0]))
        ]
        for i in range(len(matrices[0]))
    ]


def minus_identity(matrix):
    return [
        [Fraction(x) - int(i == j) for j, x in enumerate(row)]
        for i, row in enumerate(matrix)
    ]


def permutation_matrix(permutation):
    n = len(permutation)
    return [[int(permutation[j] == i) for j in range(n)] for i in range(n)]


def generated_group(generators):
    n = len(generators[0])
    identity = tuple(range(n))
    known, queue = {identity}, [identity]
    while queue:
        current = queue.pop()
        for generator in generators:
            product = tuple(generator[current[i]] for i in range(n))
            if product not in known:
                known.add(product)
                queue.append(product)
    assert len(known) <= math.factorial(n), "Invalid permutation group"
    return sorted(known)


def orbits(group):
    remaining = set(range(len(group[0])))
    result = []
    while remaining:
        point = min(remaining)
        orbit = {permutation[point] for permutation in group}
        assert orbit <= remaining, "Group orbits must partition the sheets"
        result.append(sorted(orbit))
        remaining -= orbit
    return result


def finite_permutation_checks():
    cases = 0
    for n in range(1, 5):
        permutations = list(itertools.permutations(range(n)))
        for first, second in itertools.product(permutations, repeat=2):
            group = generated_group([first, second])
            operators = [permutation_matrix(first), permutation_matrix(second)]
            differences = [minus_identity(operator) for operator in operators]
            invariant_dimension = n - rank(
                [row for difference in differences for row in difference]
            )
            coinvariant_dimension = n - rank(
                [differences[0][i] + differences[1][i] for i in range(n)]
            )
            reynolds = average([permutation_matrix(p) for p in group])
            orbit_count = len(orbits(group))
            assert invariant_dimension == coinvariant_dimension == orbit_count
            assert matmul(reynolds, reynolds) == reynolds
            assert rank(reynolds) == orbit_count
            redundant = tuple(first[second[i]] for i in range(n))
            restricted_image = generated_group([first, second, redundant])
            assert restricted_image == group
            assert orbits(restricted_image) == orbits(group)
            cases += 1
    return {
        "maximum_sheets": 4,
        "ordered_generator_pairs": cases,
        "invariant_coinvariant_orbit_equalities": cases,
        "reynolds_projector_checks": cases,
        "unchanged_surjective_image_checks": cases,
    }


def invariant_lift_checks():
    group = list(itertools.permutations(range(3)))
    w_operators, v_operators = [], []
    quotient = [[int(i == j) for j in range(5)] for i in range(4)]
    for permutation in group:
        inversions = sum(
            permutation[i] > permutation[j] for i in range(3) for j in range(i + 1, 3)
        )
        w = [[0] * 5 for _ in range(5)]
        for i, row in enumerate(permutation_matrix(permutation)):
            w[i][:3] = row
        w[3][3], w[4][4] = 1, (-1) ** inversions
        v = [row[:4] for row in w[:4]]
        assert matmul(quotient, w) == matmul(v, quotient)
        w_operators.append(w)
        v_operators.append(v)
    w_average, v_average = average(w_operators), average(v_operators)
    lifts = [[1, 0], [1, 0], [1, 0], [0, 1], [1, 2]]
    invariant_lifts = matmul(w_average, lifts)
    images = matmul(quotient, invariant_lifts)
    assert images == matmul(quotient, lifts)
    assert images == matmul(v_average, images)
    assert rank(images) == rank(w_average) == rank(v_average) == 2
    assert rank(quotient) == 4
    return {
        "group": "S3",
        "group_order": 6,
        "W_dimension": 5,
        "V_dimension": 4,
        "quotient_rank": 4,
        "W_invariant_dimension": 2,
        "V_invariant_dimension": 2,
        "independent_lift_images": 2,
        "nontrivial_sign_kernel": True,
    }


def derivative(polynomial, variable):
    result = {}
    for exponent, coefficient in polynomial.items():
        if exponent[variable]:
            new_exponent = list(exponent)
            new_exponent[variable] -= 1
            result[tuple(new_exponent)] = coefficient * exponent[variable]
    return result


def monomial_substitution(polynomial, images):
    result = {}
    for exponent, coefficient in polynomial.items():
        new_exponent = tuple(
            sum(exponent[i] * images[i][j] for i in range(len(images)))
            for j in range(len(images[0]))
        )
        result[new_exponent] = result.get(new_exponent, 0) + coefficient
    return {exponent: value for exponent, value in result.items() if value}


def sharp_example_checks():
    basis = [tuple(int(i == j) for i in range(4)) for j in range(4)]
    node = {(1, 1, 0, 0): 1, (0, 0, 1, 1): -1}
    gradients = [derivative(node, i) for i in range(4)]
    assert gradients == [
        {basis[1]: 1},
        {basis[0]: 1},
        {basis[3]: -1},
        {basis[2]: -1},
    ]
    for selected in range(4):
        images, other = [], 1
        for coordinate in range(4):
            exponent = [1, 0, 0, 0]
            if coordinate != selected:
                exponent[other] = 1
                other += 1
            images.append(tuple(exponent))
        total = monomial_substitution(node, images)
        assert all(exponent[0] >= 2 for exponent in total)
        strict = {
            (exponent[0] - 2,) + exponent[1:]: coefficient
            for exponent, coefficient in total.items()
        }
        expected = (
            {(0, 1, 0, 0): 1, (0, 0, 1, 1): -1}
            if selected < 2
            else {(0, 1, 1, 0): 1, (0, 0, 0, 1): -1}
        )
        assert strict == expected
        assert any(
            derivative(strict, i) in ({(0, 0, 0, 0): 1}, {(0, 0, 0, 0): -1})
            for i in range(4)
        )
        assert images[selected] == (1, 0, 0, 0)
        assert all(exponent[0] >= 1 for exponent in images)
    quadratic_form = [
        [0, Fraction(1, 2), 0, 0],
        [Fraction(1, 2), 0, 0, 0],
        [0, 0, 0, Fraction(-1, 2)],
        [0, 0, Fraction(-1, 2), 0],
    ]
    assert rank(quadratic_form) == 4
    segre_images = [(1, 0, 1, 0), (0, 1, 0, 1), (1, 0, 0, 1), (0, 1, 1, 0)]
    assert monomial_substitution(node, segre_images) == {}
    incidence_charts = [
        [(0, 1, 0, 0), (1, 0, 1, 0), (0, 0, 1, 0), (1, 1, 0, 0)],
        [(1, 1, 0, 0), (0, 0, 1, 0), (1, 0, 1, 0), (0, 1, 0, 0)],
    ]
    for images in incidence_charts:
        assert monomial_substitution(node, images) == {}
    gysin = [[-1], [-1]]
    coefficient = (4 - 1) - 2
    assert coefficient == 1
    assert coefficient + 1 == 2
    assert rank(gysin) == 1 and rank([[1]]) == 1
    return {
        "gradient_generates_projective_vertex_ideal": True,
        "blowup_charts": 4,
        "strict_transform_unit_derivative_checks": 4,
        "singular_ideal_principalization_chart_checks": 4,
        "exceptional_quadric_rank": 4,
        "segre_polynomial_identity": True,
        "small_resolution_incidence_identities": 2,
        "relative_canonical_coefficient": coefficient,
        "log_discrepancy": coefficient + 1,
        "gysin_matrix_rank": rank(gysin),
        "gysin_cokernel_dimension": 2 - rank(gysin),
        "degree_matrix_rank": rank([[1]]),
    }


def discrepancy_checks():
    excesses = []
    for denominator in range(1, 13):
        for numerator in range(1, denominator + 1):
            coefficient = Fraction(numerator, denominator)
            for order in range(1, 5):
                for smooth_log_discrepancy in (2, 3):
                    value = smooth_log_discrepancy + coefficient * order
                    assert value > 2
                    excesses.append(value - smooth_log_discrepancy)
    assert 2 + Fraction(0) * 1 == 2
    return {
        "maximum_denominator": 12,
        "coefficient_range": "1/denominator through 1",
        "positive_order_range": [1, 4],
        "smooth_log_discrepancies": [2, 3],
        "cases": len(excesses),
        "minimum_strict_excess": str(min(excesses)),
        "zero_coefficient_control_equals_two": True,
    }


def negative_controls():
    global_group = generated_group([(1, 0)])
    dropped_loop_group = generated_group([(0, 1)])
    global_orbits, local_orbits = orbits(global_group), orbits(dropped_loop_group)
    assert global_orbits == [[0, 1]]
    assert local_orbits == [[0], [1]]
    unipotent, quotient = [[1, 1], [0, 1]], [[0, 1]]
    invariant_basis = [[1], [0]]
    assert matmul(quotient, unipotent) == quotient
    assert matmul(minus_identity(unipotent), invariant_basis) == [[0], [0]]
    assert rank(minus_identity(unipotent)) == 1
    assert matmul(quotient, invariant_basis) == [[0]]
    assert rank(quotient) == 1
    return {
        "lost_loop": {
            "global_orbits": global_orbits,
            "restricted_orbits": local_orbits,
            "restricted_image_surjective": False,
        },
        "infinite_unipotent": {
            "quotient_dimension": 1,
            "invariant_lift_image_dimension": 0,
            "finite_monodromy": False,
        },
        "geometric_counterexample_claimed": False,
    }


def rational_matrix(typed_matrix):
    assert typed_matrix["domain"] == "QQ"
    result = []
    for row in typed_matrix["entries"]:
        values = []
        for entry in row:
            assert set(entry) == {"num", "den"}
            value = Fraction(int(entry["num"]), int(entry["den"]))
            assert value.denominator > 0
            assert str(value.numerator) == entry["num"]
            assert str(value.denominator) == entry["den"]
            values.append(value)
        result.append(values)
    return result


def jacobian_replay(certificate):
    metadata = certificate["jacobian"]
    payload = json.loads((ROOT / metadata["payload_file"]).read_text())
    response = json.loads((ROOT / metadata["output_file"]).read_text())
    operation = metadata["operation_id"]
    assert operation == "matrix.rank.compute"
    assert metadata["adapter_exit_code"] == 0
    assert metadata["error"] is None and metadata["timeout"] is False
    assert response["tool"] == "math.run"
    assert response["schema_version"] == 1
    assert response["protocol_version"] == metadata["protocol_version"]
    assert response["server"]["name"] == "jacobian"
    assert response["server"]["version"] == metadata["server_version"]
    assert "error" not in response
    assert response["request"] == {"operation_id": operation, "payload": payload}
    result = response["result"]
    assert result["operation_id"] == operation and "error" not in result
    output = result["output"]
    assert output["method"] == "EXACT_RATIONAL_ROW_REDUCTION"
    assert output["matrix"] == payload["matrix"]
    matrix = rational_matrix(payload["matrix"])
    assert matrix == [[-1], [-1]], "Adapter payload is not the example's Gysin matrix"
    pivots = rref_pivots(matrix)
    assert output["pivot_columns"] == pivots
    assert output["rank"] == len(pivots) == 1
    return {
        "rank": len(pivots),
        "pivot_columns": pivots,
        "payload_matches_sharp_example": True,
        "typed_output_independently_replayed": True,
    }


def main():
    if not __debug__:
        raise RuntimeError("Run without -O: the certificate requires active assertions")
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    assert certificate["claim_id"] == "CP_BOUND"
    computed = {
        "sharp_example": sharp_example_checks(),
        "permutation_actions": finite_permutation_checks(),
        "finite_invariant_lifts": invariant_lift_checks(),
        "strict_discrepancy": discrepancy_checks(),
        "negative_controls": negative_controls(),
        "jacobian_replay": jacobian_replay(certificate),
    }
    assert computed == certificate["mechanical_results"], (
        "Certificate does not match exact recomputation:\n"
        + json.dumps(computed, indent=2, sort_keys=True)
    )
    print(
        json.dumps(
            {
                "status": "passed",
                "claim": "CP_BOUND",
                "sharp_example_charts": computed["sharp_example"]["blowup_charts"],
                "permutation_generator_pairs": computed["permutation_actions"][
                    "ordered_generator_pairs"
                ],
                "strict_discrepancy_cases": computed["strict_discrepancy"]["cases"],
                "jacobian_rank_replayed": computed["jacobian_replay"]["rank"],
                "general_geometric_proof": "report.md; not machine-checked",
                "independent_review": "required",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
