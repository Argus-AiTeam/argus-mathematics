#!/usr/bin/env python3
import hashlib
import itertools
import json
from fractions import Fraction
from math import gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent
INPUT = ROOT / "affine-coset-witness-alexander.json"
FACET_PAYLOAD = ROOT / "certificates" / "jacobian-facets-payload.json"
FACET_OUTPUT = ROOT / "certificates" / "jacobian-facets-output.json"
EXPECTED_INPUT_SHA256 = (
    "08f2a60d3c585868bd43c1b1b2511453cf0a90da3edc84b82f2d2430dacdcfda"
)
WORD = "SSTSST"
DERIVATIVE = ((11, 4), (8, 3))

ONE = (1, 0)
MINUS_ONE = (-1, 0)
I = (1, 1)
MINUS_I = (-1, 1)
J = (1, 2)
MINUS_J = (-1, 2)
K = (1, 3)
MINUS_K = (-1, 3)
ELEMENTS = (ONE, MINUS_ONE, I, MINUS_I, J, MINUS_J, K, MINUS_K)
POSITIVE_REPRESENTATIVES = (ONE, I, J, K)
NAMES = {
    ONE: "1",
    MINUS_ONE: "-1",
    I: "i",
    MINUS_I: "-i",
    J: "j",
    MINUS_J: "-j",
    K: "k",
    MINUS_K: "-k",
}
INDEX = {element: index for index, element in enumerate(ELEMENTS)}
ELEMENT_BY_NAME = {name: element for element, name in NAMES.items()}
DECK = MINUS_I

POSITIVE_PRODUCTS = {
    (0, 0): (1, 0),
    (0, 1): (1, 1),
    (0, 2): (1, 2),
    (0, 3): (1, 3),
    (1, 0): (1, 1),
    (1, 1): (-1, 0),
    (1, 2): (1, 3),
    (1, 3): (-1, 2),
    (2, 0): (1, 2),
    (2, 1): (-1, 3),
    (2, 2): (-1, 0),
    (2, 3): (1, 1),
    (3, 0): (1, 3),
    (3, 1): (1, 2),
    (3, 2): (-1, 1),
    (3, 3): (-1, 0),
}

F2_INVERSE = {"x": "X", "X": "x", "y": "Y", "Y": "y"}
F2_AUTOMORPHISMS = {
    "T": {"x": tuple("x"), "y": tuple("xy")},
    "S": {"x": tuple("yx"), "y": tuple("y")},
}


def multiply(left, right):
    left_sign, left_basis = left
    right_sign, right_basis = right
    product_sign, product_basis = POSITIVE_PRODUCTS[(left_basis, right_basis)]
    return left_sign * right_sign * product_sign, product_basis


def negative(element):
    return -element[0], element[1]


def beta_t(element):
    images = (ONE, I, K, MINUS_J)
    sign, basis = element
    image_sign, image_basis = images[basis]
    return sign * image_sign, image_basis


def beta_s(element):
    images = (ONE, MINUS_K, J, I)
    sign, basis = element
    image_sign, image_basis = images[basis]
    return sign * image_sign, image_basis


def zero_vector(length=16):
    return [0] * length


def add_vectors(*vectors):
    return [sum(entries) for entries in zip(*vectors)]


def scale_vector(scalar, vector):
    return [scalar * entry for entry in vector]


def edge(axis, label):
    result = zero_vector()
    result[(0 if axis == "x" else 8) + INDEX[label]] = 1
    return result


def identity_matrix(size):
    return [[int(row == column) for column in range(size)] for row in range(size)]


def matrix_multiply(left, right):
    return [
        [
            sum(left[row][index] * right[index][column] for index in range(len(right)))
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def apply_matrix(matrix, vector):
    return [
        sum(matrix[row][column] * vector[column] for column in range(len(vector)))
        for row in range(len(matrix))
    ]


def rref(rows):
    matrix = [[Fraction(value) for value in row] for row in rows]
    pivots = []
    pivot_row = 0
    for column in range(len(matrix[0])):
        selected = next(
            (
                row
                for row in range(pivot_row, len(matrix))
                if matrix[row][column]
            ),
            None,
        )
        if selected is None:
            continue
        matrix[pivot_row], matrix[selected] = matrix[selected], matrix[pivot_row]
        pivot = matrix[pivot_row][column]
        matrix[pivot_row] = [entry / pivot for entry in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row != pivot_row and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [
                    entry - factor * pivot_entry
                    for entry, pivot_entry in zip(matrix[row], matrix[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix, pivots


def matrix_rank(matrix):
    return len(rref(matrix)[1])


def column_rank(columns):
    rows = [
        [column[row] for column in columns]
        for row in range(len(columns[0]))
    ]
    return matrix_rank(rows)


def determinant(matrix):
    if not matrix:
        return 1
    work = [list(row) for row in matrix]
    sign = 1
    previous_pivot = 1
    for column in range(len(work) - 1):
        pivot_row = next(
            (
                row
                for row in range(column, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot_row is None:
            return 0
        if pivot_row != column:
            work[column], work[pivot_row] = work[pivot_row], work[column]
            sign *= -1
        pivot = work[column][column]
        for row in range(column + 1, len(work)):
            for other_column in range(column + 1, len(work)):
                numerator = (
                    work[row][other_column] * pivot
                    - work[row][column] * work[column][other_column]
                )
                assert numerator % previous_pivot == 0
                work[row][other_column] = numerator // previous_pivot
        previous_pivot = pivot
    return sign * work[-1][-1]


def smith_factors_from_minors(matrix):
    rank = matrix_rank(matrix)
    previous_divisor = 1
    factors = []
    row_count = len(matrix)
    column_count = len(matrix[0])
    for size in range(1, rank + 1):
        divisor = 0
        for rows in itertools.combinations(range(row_count), size):
            for columns in itertools.combinations(range(column_count), size):
                minor = [
                    [matrix[row][column] for column in columns]
                    for row in rows
                ]
                divisor = gcd(divisor, abs(determinant(minor)))
        assert divisor and divisor % previous_divisor == 0
        factors.append(divisor // previous_divisor)
        previous_divisor = divisor
    return factors + [0] * (column_count - rank)


def s_chain_matrix():
    first_case = {ONE, MINUS_ONE, J, MINUS_J}
    matrix = [[0] * 16 for _ in range(16)]
    for label in ELEMENTS:
        if label in first_case:
            x_image = add_vectors(edge("x", label), edge("y", multiply(label, I)))
            y_image = edge("y", label)
        else:
            x_image = add_vectors(
                edge("x", multiply(J, label)),
                edge("y", multiply(label, K)),
            )
            y_image = edge("y", multiply(J, label))
        for row, value in enumerate(x_image):
            matrix[row][INDEX[label]] = value
        for row, value in enumerate(y_image):
            matrix[row][8 + INDEX[label]] = value
    return matrix


def t_chain_matrix():
    first_case = {ONE, MINUS_ONE, I, MINUS_I}
    matrix = [[0] * 16 for _ in range(16)]
    for label in ELEMENTS:
        if label in first_case:
            x_image = edge("x", label)
            y_image = add_vectors(edge("y", label), edge("x", multiply(label, J)))
        else:
            x_image = edge("x", multiply(I, label))
            y_image = add_vectors(
                edge("y", multiply(I, label)),
                edge("x", multiply(negative(label), K)),
            )
        for row, value in enumerate(x_image):
            matrix[row][INDEX[label]] = value
        for row, value in enumerate(y_image):
            matrix[row][8 + INDEX[label]] = value
    return matrix


def deck_chain_matrix(element):
    matrix = [[0] * 16 for _ in range(16)]
    for label in ELEMENTS:
        image = multiply(element, label)
        matrix[INDEX[image]][INDEX[label]] = 1
        matrix[8 + INDEX[image]][8 + INDEX[label]] = 1
    return matrix


def source_chain_data():
    boundary_one = [[0] * 16 for _ in range(4)]
    for label in ELEMENTS:
        for direction, offset in ((I, 0), (J, 8)):
            boundary_one[label[1]][offset + INDEX[label]] -= 1
            boundary_one[multiply(label, direction)[1]][offset + INDEX[label]] += 1
    square_boundaries = [
        add_vectors(
            edge("x", label),
            edge("y", multiply(label, I)),
            scale_vector(-1, edge("y", label)),
            scale_vector(-1, edge("x", multiply(label, J))),
        )
        for label in ELEMENTS
    ]
    return boundary_one, square_boundaries


def epsilon_cycle(label):
    label_j = multiply(label, J)
    return add_vectors(
        edge("x", label),
        scale_vector(-1, edge("x", negative(label))),
        scale_vector(-1, edge("x", label_j)),
        edge("x", negative(label_j)),
    )


def homology_coordinate_solver(square_boundaries):
    sigma = add_vectors(*(edge("x", label) for label in ELEMENTS))
    zeta = add_vectors(*(edge("y", label) for label in ELEMENTS))
    homology_basis = [sigma, zeta] + [
        epsilon_cycle(label) for label in POSITIVE_REPRESENTATIVES
    ]
    columns = homology_basis[:]
    for boundary in square_boundaries:
        if column_rank(columns + [boundary]) > len(columns):
            columns.append(boundary)
    assert len(columns) == 13
    assert column_rank(columns) == 13

    def solve(cycle):
        augmented = [
            [column[row] for column in columns] + [cycle[row]]
            for row in range(16)
        ]
        reduced, pivots = rref(augmented)
        solution = [Fraction(0)] * len(columns)
        for row, pivot in zip(reduced, pivots):
            if pivot < len(columns):
                solution[pivot] = row[-1]
        reconstructed = [
            sum(
                Fraction(columns[column][row]) * solution[column]
                for column in range(len(columns))
            )
            for row in range(16)
        ]
        assert reconstructed == [Fraction(value) for value in cycle]
        return solution[:6]

    return homology_basis, solve


def reduce_f2(word):
    result = []
    for letter in word:
        if result and result[-1] == F2_INVERSE[letter]:
            result.pop()
        else:
            result.append(letter)
    return tuple(result)


def inverse_f2(word):
    return tuple(F2_INVERSE[letter] for letter in reversed(word))


def substitute_f2(word, images):
    expanded = []
    for letter in word:
        image = images[letter.lower()]
        expanded.extend(image if letter.islower() else inverse_f2(image))
    return reduce_f2(expanded)


def alpha_word(word):
    for operation in WORD:
        word = substitute_f2(word, F2_AUTOMORPHISMS[operation])
    return word


def q8_image(word):
    images = {"x": I, "X": MINUS_I, "y": J, "Y": MINUS_J}
    result = ONE
    for letter in word:
        result = multiply(result, images[letter])
    return result


def floor_fraction(value):
    return value.numerator // value.denominator


def lift_operation(state, operation):
    label, x_coordinate, y_coordinate = state
    total = x_coordinate + y_coordinate
    crossing = floor_fraction(total)
    assert crossing in (0, 1)
    if operation == "T":
        label = beta_t(label)
        if crossing:
            label = multiply(label, I)
        return label, total - crossing, y_coordinate
    label = beta_s(label)
    if crossing:
        label = multiply(label, J)
    return label, x_coordinate, total - crossing


def lift_map(label, x_coordinate, y_coordinate):
    state = (label, x_coordinate, y_coordinate)
    for operation in WORD:
        state = lift_operation(state, operation)
    return multiply(DECK, state[0]), state[1], state[2]


def mat_vec(matrix, vector):
    return tuple(
        sum(matrix[row][column] * vector[column] for column in range(len(vector)))
        for row in range(len(matrix))
    )


def fraction_text(value):
    return str(value.numerator) if value.denominator == 1 else str(value)


def segment_crossing_word(start, displacement):
    events = []
    for axis, (coordinate, delta, negative_letter, positive_letter) in enumerate(
        (
            (start[0], displacement[0], "X", "x"),
            (start[1], displacement[1], "Y", "y"),
        )
    ):
        if not delta:
            continue
        lower = floor_fraction(min(coordinate, coordinate + delta))
        upper = floor_fraction(max(coordinate, coordinate + delta))
        for boundary in range(lower, upper + 1):
            time = (Fraction(boundary) - coordinate) / delta
            if 0 < time < 1:
                events.append(
                    (
                        time,
                        axis,
                        negative_letter if delta < 0 else positive_letter,
                    )
                )
    events.sort()
    assert len({time for time, _, _ in events}) == len(events)
    return tuple(letter for _, _, letter in events)


def radial_image_word(point):
    x_coordinate, y_coordinate = point
    if y_coordinate:
        displacement = tuple(
            -entry for entry in mat_vec(DERIVATIVE, point)
        )
        return {
            "path_kind": "straight_corner_to_fixed_point",
            "waypoints": [["0", "0"], [fraction_text(x_coordinate), fraction_text(y_coordinate)]],
            "word": segment_crossing_word(point, displacement),
        }

    epsilon = Fraction(1, 100)
    first_displacement = mat_vec(DERIVATIVE, (Fraction(0), epsilon))
    join = tuple(point[index] + first_displacement[index] for index in range(2))
    second_displacement = tuple(
        -entry
        for entry in mat_vec(DERIVATIVE, (x_coordinate, epsilon))
    )
    return {
        "path_kind": "interior_detour_at_horizontal_edge",
        "waypoints": [
            ["0", "0"],
            [fraction_text(x_coordinate), fraction_text(epsilon)],
            [fraction_text(x_coordinate), "0"],
        ],
        "word": (
            segment_crossing_word(point, first_displacement)
            + segment_crossing_word(join, second_displacement)
        ),
    }


def make_schreier_coordinate_map(presentation):
    pair_to_generator = {
        (
            ELEMENT_BY_NAME[record["start_label"]],
            record["base_letter"],
        ): record["index"]
        for record in presentation["schreier_generators"]
    }

    def rewrite(word):
        result = []
        label = ONE
        for letter in word:
            if letter.islower():
                pair = (label, letter)
                target = multiply(label, I if letter == "x" else J)
                if pair in pair_to_generator:
                    result.append(pair_to_generator[pair])
            else:
                lower = letter.lower()
                target = multiply(
                    label, MINUS_I if lower == "x" else MINUS_J
                )
                pair = (target, lower)
                if pair in pair_to_generator:
                    result.append(-pair_to_generator[pair])
            label = target
        assert label == ONE
        return result

    remaining = presentation["remaining_schreier_generators"]
    remaining_index = {
        generator: index for index, generator in enumerate(remaining)
    }
    replacements = {
        record["generator"]: record["replacement"]
        for record in presentation["eliminated_generators"]
    }
    cache = {}
    active = set()

    def resolve(generator):
        if generator in cache:
            return cache[generator]
        assert generator not in active
        active.add(generator)
        result = [0] * 6
        if generator in remaining_index:
            result[remaining_index[generator]] = 1
        else:
            assert generator in replacements
            for letter in replacements[generator]:
                image = resolve(abs(letter))
                for index in range(6):
                    result[index] += (1 if letter > 0 else -1) * image[index]
        active.remove(generator)
        cache[generator] = result
        return result

    old_generator_images = {
        generator: resolve(generator) for generator in range(1, 10)
    }
    free_images = {
        int(generator): coordinates
        for generator, coordinates in presentation["generator_free_images"].items()
    }

    def coordinates(word):
        schreier_word = rewrite(word)
        old_exponents = [0] * 9
        for letter in schreier_word:
            old_exponents[abs(letter) - 1] += 1 if letter > 0 else -1
        surface_exponents = [
            sum(
                old_exponents[old] * old_generator_images[old + 1][new]
                for old in range(9)
            )
            for new in range(6)
        ]
        free_coordinates = list(free_images[7])
        for generator in range(1, 7):
            for coordinate in range(len(free_coordinates)):
                free_coordinates[coordinate] += (
                    surface_exponents[generator - 1]
                    * free_images[generator][coordinate]
                )
        return schreier_word, surface_exponents, free_coordinates

    return coordinates


def canonical_rational(value):
    numerator = int(value["num"])
    denominator = int(value["den"])
    assert denominator > 0
    result = Fraction(numerator, denominator)
    assert str(result.numerator) == value["num"]
    assert str(result.denominator) == value["den"]
    return result


def rational_point(record):
    return tuple(canonical_rational(value) for value in record["coordinates"])


def verify_jacobian_facets(support, target):
    payload = json.loads(FACET_PAYLOAD.read_text(encoding="utf-8"))
    record = json.loads(FACET_OUTPUT.read_text(encoding="utf-8"))
    assert record["protocol_version"] == "2025-11-25"
    assert record["server"]["name"] == "jacobian"
    assert record["request"] == {
        "operation_id": "polytope.facets.compute",
        "payload": payload,
    }
    assert record["result"]["operation_id"] == "polytope.facets.compute"
    output = record["result"]["output"]
    assert output["dimension"] == 3

    differences = sorted(
        {
            tuple(left[index] - right[index] for index in range(3))
            for left in support
            for right in support
        }
    )
    vertices = [rational_point(vertex) for vertex in payload["vertices"]]
    assert len(vertices) == len(set(vertices)) == 14
    assert all(vertex in differences for vertex in vertices)
    assert [rational_point(vertex) for vertex in output["vertices"]] == vertices

    facets = []
    for facet in output["facets"]:
        coefficients = tuple(
            canonical_rational(value)
            for value in facet["halfspace"]["coefficients"]
        )
        offset = canonical_rational(facet["halfspace"]["offset"])
        assert all(value.denominator == 1 for value in coefficients + (offset,))
        common_divisor = 0
        for value in coefficients + (offset,):
            common_divisor = gcd(common_divisor, abs(value.numerator))
        assert common_divisor == 1
        assert any(coefficients)
        assert all(
            sum(coefficients[index] * point[index] for index in range(3))
            <= offset
            for point in differences
        )
        incident = [
            index
            for index, vertex in enumerate(vertices)
            if sum(coefficients[j] * vertex[j] for j in range(3)) == offset
        ]
        assert incident == facet["source_vertex_indices"]
        base = vertices[incident[0]]
        affine_rows = [
            [vertices[index][coordinate] - base[coordinate] for coordinate in range(3)]
            for index in incident[1:]
        ]
        assert matrix_rank(affine_rows) == 2
        slack = offset - sum(
            coefficients[index] * target[index] for index in range(3)
        )
        facets.append(
            {
                "coefficients": [int(value) for value in coefficients],
                "offset": int(offset),
                "source_vertex_indices": incident,
                "target_slack": int(slack),
            }
        )

    assert len(facets) == len(
        {
            (tuple(facet["coefficients"]), facet["offset"])
            for facet in facets
        }
    ) == 12
    for vertex_index, vertex in enumerate(vertices):
        active_normals = [
            facet["coefficients"]
            for facet in facets
            if vertex_index in facet["source_vertex_indices"]
        ]
        assert matrix_rank(active_normals) == 3
    assert all(facet["target_slack"] >= 0 for facet in facets)
    assert any(facet["target_slack"] == 0 for facet in facets)
    difference_witnesses = [
        [list(left), list(right)]
        for left in support
        for right in support
        if tuple(left[index] - right[index] for index in range(3)) == target
    ]
    assert difference_witnesses
    return {
        "operation_id": record["request"]["operation_id"],
        "protocol_version": record["protocol_version"],
        "server_version": record["server"]["version"],
        "adapter_error": None,
        "adapter_timeout": False,
        "runtime_ms": record["result"]["runtime_ms"],
        "vertex_count": len(vertices),
        "difference_generator_count": len(differences),
        "facets": facets,
        "target_is_raw_support_difference": True,
        "target_difference_witnesses": difference_witnesses,
    }


def main():
    raw_input = INPUT.read_bytes()
    input_sha256 = hashlib.sha256(raw_input).hexdigest()
    assert input_sha256 == EXPECTED_INPUT_SHA256
    data = json.loads(raw_input)
    presentation = data["presentation"]
    assert data["status"] == "PASS"
    assert data["scope"] == "exact_multivariable_alexander_polynomial"
    assert data["affine_word_application_order"] == WORD
    assert data["postcomposed_deck_transformation"] == "-i"
    assert data["derivative"] == [list(row) for row in DERIVATIVE]
    assert presentation["map"] == {
        "affine_word_application_order": WORD,
        "family_parameters": None,
        "postcomposed_deck_transformation": "-i",
    }
    assert presentation["orbit_words"] == []

    commutator = multiply(multiply(multiply(I, J), MINUS_I), MINUS_J)
    assert commutator == MINUS_ONE
    faces = 8
    edges = 16
    vertices = 4
    euler_characteristic = faces - edges + vertices
    genus = 1 - euler_characteristic // 2
    assert genus == 3

    derivative = identity_matrix(2)
    derivative_generators = {
        "S": [[1, 0], [1, 1]],
        "T": [[1, 1], [0, 1]],
    }
    for operation in WORD:
        derivative = matrix_multiply(
            derivative_generators[operation], derivative
        )
    assert derivative == [list(row) for row in DERIVATIVE]
    derivative_determinant = determinant(derivative)
    derivative_trace = sum(derivative[index][index] for index in range(2))
    assert derivative_determinant == 1
    assert derivative_trace == 14
    assert derivative_trace > 2

    chain_action = identity_matrix(16)
    for operation in WORD:
        chain_action = matrix_multiply(
            s_chain_matrix() if operation == "S" else t_chain_matrix(),
            chain_action,
        )
    chain_action = matrix_multiply(deck_chain_matrix(DECK), chain_action)
    boundary_one, square_boundaries = source_chain_data()
    assert matrix_rank(boundary_one) == 3
    assert column_rank(square_boundaries) == 7
    assert all(
        apply_matrix(boundary_one, boundary) == [0, 0, 0, 0]
        for boundary in square_boundaries
    )
    homology_basis, solve_homology = homology_coordinate_solver(
        square_boundaries
    )
    homology_columns = [
        solve_homology(apply_matrix(chain_action, cycle))
        for cycle in homology_basis
    ]
    homology_action = [
        [homology_columns[column][row] for column in range(6)]
        for row in range(6)
    ]
    homology_cokernel = [
        [
            Fraction(int(row == column)) - homology_action[row][column]
            for column in range(6)
        ]
        for row in range(6)
    ]
    fixed_homology_dimension = 6 - matrix_rank(homology_cokernel)
    assert fixed_homology_dimension == 2
    assert sum(homology_action[index][index] for index in range(6)) == 14

    exponent_matrix = presentation["exponent_matrix"]
    assert smith_factors_from_minors(exponent_matrix) == [1, 1, 2, 6, 0, 0, 0]
    assert presentation["abelianization_smith_factors"] == [1, 1, 2, 6, 0, 0, 0]
    assert presentation["free_abelianization_basis"] == ["time", "u", "v"]
    free_homomorphisms = [
        presentation["generator_free_images"][str(generator)]
        for generator in range(1, 8)
    ]
    assert matrix_multiply(exponent_matrix, free_homomorphisms) == [
        [0, 0, 0] for _ in range(7)
    ]
    assert matrix_rank(free_homomorphisms) == 3
    maximal_minor_gcd = 0
    for rows in itertools.combinations(range(7), 3):
        minor = [[free_homomorphisms[row][column] for column in range(3)] for row in rows]
        maximal_minor_gcd = gcd(maximal_minor_gcd, abs(determinant(minor)))
    assert maximal_minor_gcd == 1
    stored_monodromy = presentation["monodromy_h1_action"]
    stored_cokernel = [
        [
            int(row == column) - stored_monodromy[row][column]
            for column in range(6)
        ]
        for row in range(6)
    ]
    assert 6 - matrix_rank(stored_cokernel) == 2
    assert sum(stored_monodromy[index][index] for index in range(6)) == 14
    mapping_torus_b1 = 1 + fixed_homology_dimension
    assert mapping_torus_b1 == 3

    singularity_images = []
    for representative in POSITIVE_REPRESENTATIVES:
        image = representative
        for operation in WORD:
            image = (beta_s if operation == "S" else beta_t)(image)
        image = multiply(DECK, image)
        singularity_images.append(
            {
                "source": NAMES[representative],
                "image": NAMES[POSITIVE_REPRESENTATIVES[image[1]]],
                "image_square_label": NAMES[image],
            }
        )
    singularity_permutation = {
        record["source"]: record["image"] for record in singularity_images
    }
    assert singularity_permutation == {
        "1": "i",
        "i": "1",
        "j": "k",
        "k": "j",
    }
    assert all(source != image for source, image in singularity_permutation.items())

    fixed_matrix = [
        [DERIVATIVE[row][column] - int(row == column) for column in range(2)]
        for row in range(2)
    ]
    fixed_degree = abs(determinant(fixed_matrix))
    assert fixed_degree == 12
    regular_local_index = (
        1 if determinant(fixed_matrix) > 0 else -1
    )
    assert regular_local_index == -1
    base_fixed_points = []
    regular_fixed_points = []
    for x_numerator in range(fixed_degree):
        for y_numerator in range(fixed_degree):
            point = (
                Fraction(x_numerator, fixed_degree),
                Fraction(y_numerator, fixed_degree),
            )
            displacement = mat_vec(fixed_matrix, point)
            if not all(value.denominator == 1 for value in displacement):
                continue
            fixed_labels = []
            for label in ELEMENTS:
                image = lift_map(label, *point)
                assert image[1:] == point
                if image[0] == label:
                    fixed_labels.append(label)
                    if point != (Fraction(0), Fraction(0)):
                        regular_fixed_points.append((*point, label))
            base_fixed_points.append(
                {
                    "point": [fraction_text(value) for value in point],
                    "point_type": (
                        "branched_singularity_fiber"
                        if point == (Fraction(0), Fraction(0))
                        else "regular_fiber"
                    ),
                    "fixed_square_labels": [NAMES[label] for label in fixed_labels],
                }
            )
    assert len(base_fixed_points) == fixed_degree
    assert len(regular_fixed_points) == 12
    assert not base_fixed_points[0]["fixed_square_labels"]

    transversals = {
        name: tuple(word) for name, word in presentation["transversal"].items()
    }
    assert all(
        q8_image(transversals[name]) == ELEMENT_BY_NAME[name]
        for name in transversals
    )
    deck_path = transversals["-i"]
    coordinate_map = make_schreier_coordinate_map(presentation)
    orbit_records = []
    for index, (x_coordinate, y_coordinate, label) in enumerate(
        regular_fixed_points, start=1
    ):
        radial = radial_image_word((x_coordinate, y_coordinate))
        loop_word = reduce_f2(
            transversals[NAMES[label]]
            + radial["word"]
            + inverse_f2(alpha_word(transversals[NAMES[label]]))
            + inverse_f2(deck_path)
        )
        assert q8_image(loop_word) == ONE
        schreier_word, surface_exponents, free_coordinates = coordinate_map(
            loop_word
        )
        assert free_coordinates[0] == 1
        orbit_records.append(
            {
                "id": f"p{index}",
                "base_point": [
                    fraction_text(x_coordinate),
                    fraction_text(y_coordinate),
                ],
                "square_label": NAMES[label],
                "type": "regular",
                "local_index": regular_local_index,
                "path_kind": radial["path_kind"],
                "path_waypoints_in_square": radial["waypoints"],
                "image_crossing_word": "".join(radial["word"]),
                "based_surface_loop": "".join(loop_word),
                "schreier_word": schreier_word,
                "surface_generator_exponents": surface_exponents,
                "free_homology_coordinates": free_coordinates,
            }
        )

    lefschetz_from_homology = 2 - 14
    lefschetz_from_fixed_points = sum(
        record["local_index"] for record in orbit_records
    )
    assert lefschetz_from_homology == lefschetz_from_fixed_points == -12

    support_records = data["alexander_polynomial"]["support"]
    support = [tuple(record["exponents"]) for record in support_records]
    assert len(support) == len(set(support)) == 21
    assert data["alexander_polynomial"]["support_size"] == 21
    coefficient_gcd = 0
    for record in support_records:
        coefficient_gcd = gcd(coefficient_gcd, abs(record["coefficient"]))
    assert coefficient_gcd == 1
    assert data["alexander_polynomial"]["fiber_specialization"] == [
        1,
        -12,
        -26,
        -12,
        1,
    ]
    reciprocity_translation = tuple(
        min(point[coordinate] for point in support)
        + max(point[coordinate] for point in support)
        for coordinate in range(3)
    )
    coefficient_by_exponent = {
        tuple(record["exponents"]): record["coefficient"]
        for record in support_records
    }
    assert reciprocity_translation == (4, 4, 4)
    assert all(
        coefficient
        == coefficient_by_exponent[
            tuple(
                reciprocity_translation[coordinate] - exponent[coordinate]
                for coordinate in range(3)
            )
        ]
        for exponent, coefficient in coefficient_by_exponent.items()
    )
    minimum_time = min(point[0] for point in support)
    maximum_time = max(point[0] for point in support)
    low_points = [point for point in support if point[0] == minimum_time]
    high_points = [point for point in support if point[0] == maximum_time]
    assert low_points == [(0, 2, 2)]
    assert high_points == [(4, 2, 2)]
    first_layer = [
        record
        for record in support_records
        if record["exponents"][0] == minimum_time + 1
    ]
    assert first_layer
    assert all(record["coefficient"] < 0 for record in first_layer)
    expected_orbit_multiset = []
    for record in first_layer:
        relative_exponent = tuple(
            record["exponents"][coordinate] - low_points[0][coordinate]
            for coordinate in range(3)
        )
        expected_orbit_multiset.extend(
            [relative_exponent] * (-record["coefficient"])
        )
    actual_orbit_multiset = [
        tuple(record["free_homology_coordinates"])
        for record in orbit_records
    ]
    assert sorted(actual_orbit_multiset) == sorted(expected_orbit_multiset)
    assert len(actual_orbit_multiset) == 12

    euler_class = tuple(
        low_points[0][coordinate] - high_points[0][coordinate]
        for coordinate in range(3)
    )
    candidate_a = (1, -1, 1)
    candidate_w = tuple(
        euler_class[coordinate] + 2 * candidate_a[coordinate]
        for coordinate in range(3)
    )
    assert euler_class == (-4, 0, 0)
    assert candidate_w == (-2, -2, 2)
    assert candidate_a[0] == 1
    assert candidate_a not in actual_orbit_multiset
    assert euler_class[0] == euler_characteristic
    assert all(
        (candidate_w[index] - euler_class[index]) % 2 == 0
        for index in range(3)
    )
    assert all(coordinate % 2 == 0 for coordinate in candidate_w)

    jacobian = verify_jacobian_facets(support, candidate_w)
    multiplicities = []
    for homology_class in sorted(set(actual_orbit_multiset)):
        multiplicities.append(
            {
                "free_homology_coordinates": list(homology_class),
                "multiplicity": actual_orbit_multiset.count(homology_class),
            }
        )
    first_layer_certificate = [
        {
            "free_homology_coordinates": [
                record["exponents"][coordinate] - low_points[0][coordinate]
                for coordinate in range(3)
            ],
            "coefficient": record["coefficient"],
        }
        for record in first_layer
    ]

    result = {
        "status": "PASS",
        "scope": "exact_SSTSST_minus_i_Liu_candidate_certificate",
        "input": {
            "path": "affine-coset-witness-alexander.json",
            "sha256": input_sha256,
            "hash_matches_frozen_input": True,
        },
        "surface": {
            "name": "Eierlegende Wollmilchsau",
            "square_labels": [NAMES[element] for element in ELEMENTS],
            "horizontal_gluing": "g -> g*i",
            "vertical_gluing": "g -> g*j",
            "faces": faces,
            "edges": edges,
            "vertices": vertices,
            "euler_characteristic": euler_characteristic,
            "genus": genus,
            "closed": True,
            "oriented": True,
            "singularity_count": 4,
            "singularity_type": "four simple zeros, four prongs per invariant foliation",
        },
        "map": {
            "affine_word_application_order": WORD,
            "postcomposed_deck_transformation": "-i",
            "derivative": [list(row) for row in DERIVATIVE],
            "determinant": derivative_determinant,
            "trace": derivative_trace,
            "dilatation": "7+4*sqrt(3)",
            "inverse_dilatation": "7-4*sqrt(3)",
            "type": "pseudo-Anosov affine standard representative",
            "invariant_foliations_orientable": True,
            "singularity_images": singularity_images,
            "fixed_singularities": 0,
        },
        "homology": {
            "surface_h1_dimension": 6,
            "rational_basis": [
                "sigma",
                "zeta",
                "epsilon_1",
                "epsilon_i",
                "epsilon_j",
                "epsilon_k",
            ],
            "rational_action": [
                [fraction_text(value) for value in row]
                for row in homology_action
            ],
            "fixed_subspace_dimension": fixed_homology_dimension,
            "mapping_torus_b1": mapping_torus_b1,
            "mapping_torus_h1_over_Z": "Z^3 + Z/2 + Z/6",
            "abelianization_smith_factors": [1, 1, 2, 6, 0, 0, 0],
            "free_coordinate_basis": ["time", "u", "v"],
            "free_coordinate_lattice_saturated": True,
        },
        "fixed_points": {
            "complete": True,
            "base_fixed_point_count": len(base_fixed_points),
            "base_fixed_points": base_fixed_points,
            "regular_count": len(orbit_records),
            "singular_count": 0,
            "regular_local_index": regular_local_index,
            "lefschetz_from_homology": lefschetz_from_homology,
            "lefschetz_from_local_indices": lefschetz_from_fixed_points,
        },
        "suspension_orbit_homology": {
            "complete_for_one_periodic_trajectories": True,
            "coordinate_basis": ["time", "u", "v"],
            "fixed_point_records": orbit_records,
            "distinct_classes_with_multiplicity": multiplicities,
            "alexander_first_layer": first_layer_certificate,
            "alexander_first_layer_multiset_matches": True,
        },
        "alexander_dual_ball": {
            "support_size": len(support),
            "unique_low_fiber_vertex": list(low_points[0]),
            "unique_high_fiber_vertex": list(high_points[0]),
            "fiber_specialization": data["alexander_polynomial"]["fiber_specialization"],
            "primitive": True,
            "reciprocity_translation": list(reciprocity_translation),
            "reciprocity_sign": 1,
            "euler_class_free_coordinates": list(euler_class),
            "jacobian_exact_facet_certificate": jacobian,
        },
        "candidate": {
            "a_free_coordinates": list(candidate_a),
            "fiber_evaluation_of_a": candidate_a[0],
            "a_is_integral_lattice_point": True,
            "PD_a_absent_from_every_one_periodic_trajectory": True,
            "w_equals_e_f_plus_2a": list(candidate_w),
            "w_is_even_integral_free_lattice_point": True,
            "w_in_alexander_dual_unit_ball": True,
            "w_on_alexander_dual_unit_ball_boundary": True,
        },
        "liu_lemma_3_2_hypotheses": {
            "surface_oriented_connected_closed": True,
            "surface_genus_at_least_three": True,
            "standard_representative_pseudo_Anosov": True,
            "a_integral": True,
            "a_fiber_evaluation_one": True,
            "PD_a_absent_from_all_one_periodic_trajectories": True,
            "all_hypotheses_pass": True,
        },
        "external_theorem_links": {
            "alexander_to_thurston": (
                "McMullen Theorem 1.1: for b1>1 the Alexander norm is at "
                "most the Thurston norm, and agrees on fibered cones."
            ),
            "hyperbolicity": (
                "Thurston hyperbolization: a closed pseudo-Anosov mapping "
                "torus is hyperbolic."
            ),
            "nonrealizability": (
                "Yi Liu, arXiv:2409.14504v2, Lemma 3.2 excludes e_f+2a "
                "as the real Euler class of a weakly fillable contact structure."
            ),
            "taut_foliation_implication": (
                "The Eliashberg-Thurston approximation recalled in Liu "
                "Section 2.2 transfers the exclusion to smooth cooriented "
                "taut foliations with the same Euler class."
            ),
        },
        "conclusion": (
            "The frozen SSTSST/-i affine map and a=(1,-1,1) pass the exact "
            "candidate checks; w=e_f+2a has free coordinates (-2,-2,2), "
            "lies in the Alexander and hence Thurston dual unit ball, and "
            "PD(a) is absent from every one-periodic suspension trajectory."
        ),
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
