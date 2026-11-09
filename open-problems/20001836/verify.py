#!/usr/bin/env python3
import json
from fractions import Fraction


WEIGHTS = (1, 2)
A = [
    [0, -WEIGHTS[0], 0, 0],
    [WEIGHTS[0], 0, 0, 0],
    [0, 0, 0, -WEIGHTS[1]],
    [0, 0, WEIGHTS[1], 0],
]
BIVECTORS = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
BIVECTOR_NAMES = ["e12", "e13", "e14", "e23", "e24", "e34"]


def metric_second_derivative(i, j, k, ell):
    """Coefficient of t in d_k d_ell[-t (Ax)_i (Ax)_j]."""
    return -(A[i][k] * A[j][ell] + A[i][ell] * A[j][k])


def curvature_increment(i, j, k, ell):
    """Coefficient of t in <R(e_i,e_j)e_ell,e_k>."""
    return Fraction(
        metric_second_derivative(j, k, i, ell)
        - metric_second_derivative(j, ell, i, k)
        - metric_second_derivative(i, k, j, ell)
        + metric_second_derivative(i, ell, j, k),
        2,
    )


coefficient_matrix = [
    [curvature_increment(i, j, k, ell) for k, ell in BIVECTORS]
    for i, j in BIVECTORS
]

expected_matrix = [
    [3, 0, 0, 0, 0, 4],
    [0, 0, 0, 0, 2, 0],
    [0, 0, 0, -2, 0, 0],
    [0, 0, -2, 0, 0, 0],
    [0, 2, 0, 0, 0, 0],
    [4, 0, 0, 0, 0, 12],
]

alpha = [WEIGHTS[0], 0, 0, 0, 0, WEIGHTS[1]]
star = [[0 for _ in BIVECTORS] for _ in BIVECTORS]
star[0][5] = star[5][0] = 1
star[1][4] = star[4][1] = -1
star[2][3] = star[3][2] = 1
bianchi_projection = [
    [
        3 * alpha[row] * alpha[column]
        - WEIGHTS[0] * WEIGHTS[1] * star[row][column]
        for column in range(6)
    ]
    for row in range(6)
]

negative_vector = [0, 1, 0, 0, -1, 0]
negative_image = [
    sum(coefficient_matrix[row][column] * negative_vector[column]
        for column in range(6))
    for row in range(6)
]
negative_coefficient = Fraction(
    sum(
        negative_vector[row]
        * coefficient_matrix[row][column]
        * negative_vector[column]
        for row in range(6)
        for column in range(6)
    ),
    sum(value * value for value in negative_vector),
)

bianchi_defect = (
    curvature_increment(0, 1, 2, 3)
    - curvature_increment(0, 2, 1, 3)
    + curvature_increment(0, 3, 1, 2)
)

checks = {
    "matrix_matches_expected": coefficient_matrix == expected_matrix,
    "matrix_is_symmetric": coefficient_matrix
    == [list(row) for row in zip(*coefficient_matrix)],
    "bianchi_identity": bianchi_defect == 0,
    "bianchi_projection_identity": coefficient_matrix == bianchi_projection,
    "negative_eigenvector": negative_image
    == [negative_coefficient * value for value in negative_vector],
    "negative_eigenvalue_coefficient": negative_coefficient == -2,
}

result = {
    "schema_version": 1,
    "status": "verified" if all(checks.values()) else "failed",
    "action_weights": list(WEIGHTS),
    "generator_matrix": A,
    "ordered_bivector_basis": BIVECTOR_NAMES,
    "curvature_convention": (
        "R_ijkl=<R(e_i,e_j)e_l,e_k>; the unit round sphere has operator I"
    ),
    "quotient_parameter": "t=epsilon^(-2)",
    "metric_second_jet": "q_ij=-t*(A*x)_i*(A*x)_j",
    "t_coefficient_matrix": [
        [int(value) if value.denominator == 1 else str(value) for value in row]
        for row in coefficient_matrix
    ],
    "curvature_operator_matrix": [
        ["1+3*t", "0", "0", "0", "0", "4*t"],
        ["0", "1", "0", "0", "2*t", "0"],
        ["0", "0", "1", "-2*t", "0", "0"],
        ["0", "0", "-2*t", "1", "0", "0"],
        ["0", "2*t", "0", "0", "1", "0"],
        ["4*t", "0", "0", "0", "0", "1+12*t"],
    ],
    "bianchi_defect_coefficient": int(bianchi_defect),
    "bianchi_projection": "3*t*alpha_tensor_alpha-2*t*HodgeStar",
    "negative_unit_bivector": "(e13-e24)/sqrt(2)",
    "negative_eigenvalue": "1-2*t=1-2/epsilon^2",
    "limit_as_epsilon_to_zero": "-infinity",
    "checks": checks,
}

print(json.dumps(result, indent=2, sort_keys=True))
raise SystemExit(0 if all(checks.values()) else 1)
