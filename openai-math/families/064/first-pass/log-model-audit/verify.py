#!/usr/bin/env python3
"""Replay one local toric subdivision, not the global log-model proposition."""

import json
from fractions import Fraction
from itertools import product
from math import gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def determinant(matrix):
    a, b, c = matrix
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    )


def transpose(columns):
    return [list(row) for row in zip(*columns)]


def multiply(left, right):
    return [
        [sum(x * y for x, y in zip(row, column)) for column in zip(*right)]
        for row in left
    ]


def coordinates(cone, point):
    matrix = transpose(cone)
    denominator = determinant(matrix)
    assert denominator != 0
    answer = []
    for column in range(3):
        replaced = [row[:] for row in matrix]
        for row in range(3):
            replaced[row][column] = point[row]
        answer.append(Fraction(determinant(replaced), denominator))
    return answer


def canonical_cones(cones):
    return sorted(tuple(sorted(tuple(ray) for ray in cone)) for cone in cones)


def star_subdivide(cones, point):
    assert all(tuple(point) not in map(tuple, cone) for cone in cones)
    result = []
    affected = 0
    for cone in cones:
        weights = coordinates(cone, point)
        if any(weight < 0 for weight in weights):
            result.append(cone)
            continue
        affected += 1
        assert sum(weights) == 1
        for index, weight in enumerate(weights):
            if weight > 0:
                new_cone = [ray[:] for ray in cone]
                new_cone[index] = point[:]
                result.append(new_cone)
    assert affected > 0
    return result


def verify_jacobian(matrix):
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    assert [[int(x) for x in row] for row in payload["matrix"]["entries"]] == matrix
    envelope = json.loads((ROOT / "jacobian_result.json").read_text())
    assert envelope["server"]["name"] == "jacobian"
    assert envelope["server"]["version"]
    assert envelope["protocol_version"]
    operation = "matrix.normal_form.smith.certified.compute"
    assert envelope["request"] == {"operation_id": operation, "payload": payload}
    assert envelope["result"]["operation_id"] == operation
    status = json.loads((ROOT / "jacobian_adapter_status.json").read_text())
    assert status["adapter_exit_code"] == 0
    assert status["operation_id"] == operation
    result = envelope["result"]["output"]
    assert result["exactness"] == "EXACT_INTEGER"
    assert result["completeness"] == "FULL_MATRIX_TRANSFORMATIONS"
    certificate = result["certificate"]

    def entries(name):
        return [[int(value) for value in row] for row in certificate[name]["entries"]]

    source = entries("source")
    left = entries("left_transformation")
    right = entries("right_transformation")
    diagonal = entries("diagonal")
    assert source == matrix
    assert multiply(multiply(left, source), right) == diagonal
    assert abs(determinant(left)) == abs(determinant(right)) == 1
    assert determinant(left) == int(certificate["left_determinant"])
    assert determinant(right) == int(certificate["right_determinant"])
    assert diagonal == [[1, 0, 0], [0, 1, 0], [0, 0, 3]]
    assert [int(value) for value in certificate["invariant_factors"]] == [1, 1, 3]
    assert certificate["rank"] == 3


def main():
    data = json.loads((ROOT / "exact_certificate.json").read_text())
    assert data["result_class"] == "finite_verification"
    coefficients = data["coefficients"]
    exponent = data["base_change_exponent"]
    assert len(coefficients) == 3 and all(a > 0 and exponent % a == 0 for a in coefficients)

    def height(point):
        return Fraction(sum(a * x for a, x in zip(coefficients, point)), exponent)

    lattice_index = exponent // gcd(exponent, *coefficients)
    assert lattice_index == data["congruence_lattice_index"]
    basis = transpose(data["congruence_lattice_basis_columns"])
    assert abs(determinant(basis)) == lattice_index
    assert all(height(column).denominator == 1 for column in transpose(basis))

    rays = data["initial_rays"]
    matrix = data["initial_ray_matrix_in_lattice_basis"]
    assert multiply(basis, matrix) == transpose(rays)
    assert all(height(ray) == 1 for ray in rays)
    assert abs(determinant(matrix)) == data["initial_cone_lattice_index"] == 3

    points = [
        list(point)
        for point in product(*(range(exponent // a + 1) for a in coefficients))
        if height(point) == 1
    ]
    assert points == data["all_height_one_points"]
    assert sorted(map(tuple, rays + data["inserted_rays_in_order"])) == list(map(tuple, points))
    cones = [rays]
    for point in data["inserted_rays_in_order"]:
        cones = star_subdivide(cones, point)
    assert canonical_cones(cones) == canonical_cones(data["final_maximal_cones"])
    indices = [Fraction(abs(determinant(transpose(cone))), lattice_index) for cone in cones]
    assert indices == data["final_cone_lattice_indices"]
    assert sum(indices) == data["initial_cone_lattice_index"]
    for cone in cones:
        assert abs(determinant(transpose(cone))) == lattice_index
        for point in points:
            weights = coordinates(cone, point)
            if all(weight >= 0 for weight in weights):
                assert point in cone
    assert [height(point) for point in points] == data["final_vertical_multiplicities"]
    verify_jacobian(matrix)
    print(json.dumps({
        "result": "PASS",
        "result_class": "finite_verification",
        "scope": "one local toric chart, not prop:log-model",
        "initial_cone_index": 3,
        "regular_final_cones": len(cones),
        "height_one_points": len(points),
        "jacobian_smith_replayed": True,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
