"""Exact algebra for the Wu-Ye Example 7.2 certificate; no numerical arithmetic."""

from fractions import Fraction
from itertools import product
import json
from pathlib import Path


BASE = Path(__file__).resolve().parent
ALPHABET = (1, -1, 2, -2)
PHI = {1: (1, 2), 2: (1, 2, 2)}
EXPECTED_INVERSE = {1: (1, -2, 1), 2: (-1, 2)}
OPERATION = "matrix.characteristic_polynomial.compute"


def require_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")


def reduce_word(word):
    reduced = []
    for letter in word:
        if letter not in ALPHABET:
            raise ValueError(f"Invalid free-group letter: {letter!r}")
        if reduced and reduced[-1] == -letter:
            reduced.pop()
        else:
            reduced.append(letter)
    return tuple(reduced)


def substitute(word, images):
    expanded = []
    for letter in word:
        image = images[abs(letter)]
        expanded.extend(image if letter > 0 else (-x for x in reversed(image)))
    return reduce_word(expanded)


def display(word):
    names = {1: "a", -1: "a^-1", 2: "b", -2: "b^-1"}
    return " ".join(names[x] for x in word) or "1"


def find_inverse():
    found = {}
    examined = 0
    for length in range(4):
        for word in product(ALPHABET, repeat=length):
            if reduce_word(word) != word:
                continue
            examined += 1
            image = substitute(word, PHI)
            for generator in (1, 2):
                if image == (generator,):
                    if generator in found:
                        raise AssertionError("Two distinct preimages in the search")
                    found[generator] = word
    require_equal(examined, 53, "complete reduced-word search through length three")
    require_equal(found, EXPECTED_INVERSE, "recovered inverse words")
    return found, examined


def exponent_sum(word, generator):
    return word.count(generator) - word.count(-generator)


def multiply(left, right):
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )


def determinant(matrix):
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]


def rational(value):
    return Fraction(int(value["num"]), int(value["den"]))


def verify_jacobian(matrix, coefficients):
    payload = json.loads((BASE / "jacobian-payload.json").read_text())
    declaration = json.loads((BASE / "jacobian-operation.json").read_text())
    result = json.loads((BASE / "jacobian-result.json").read_text())
    require_equal(declaration["operation_id"], OPERATION, "inspected operation")
    require_equal(result["operation_id"], OPERATION, "executed operation")
    require_equal(payload["matrix"]["domain"], "QQ", "Jacobian scalar domain")
    input_matrix = tuple(
        tuple(rational(entry) for entry in row)
        for row in payload["matrix"]["entries"]
    )
    require_equal(input_matrix, matrix, "payload matches word-derived matrix")
    output = result["output"]
    require_equal(output["degree"], 2, "Jacobian polynomial degree")
    require_equal(output["monic"], True, "Jacobian monicity")
    require_equal(output["variable"], "lambda", "Jacobian variable")
    require_equal(
        output["convention"], "DET_LAMBDA_I_MINUS_A", "Jacobian sign convention"
    )
    reported = tuple(rational(entry) for entry in output["coefficients_descending"])
    require_equal(reported, coefficients, "independent characteristic polynomial")


def verify_trace_induction():
    # Affine expressions use coefficients in the order (constant, p, q).
    u = (2, 1, 0)
    v = (3, 1, 1)
    next_u = v
    next_v = tuple(3 * y - x for x, y in zip(u, v))
    next_p = (next_u[0] - 2, next_u[1], next_u[2])
    difference = tuple(y - x for x, y in zip(next_u, next_v))
    next_q = (difference[0] - 1, difference[1], difference[2])
    require_equal(next_p, (1, 1, 1), "p' = 1 + p + q")
    require_equal(next_q, (3, 1, 2), "q' = 3 + p + 2q")
    require_equal(all(x >= 0 for x in next_p + next_q), True, "cone preservation")
    require_equal(next_p[0] > 0, True, "strict trace lower bound after one step")
    return {"p_next": list(next_p), "q_next": list(next_q)}


def main():
    inverse, examined = find_inverse()
    compositions = {}
    for generator in (1, 2):
        left = substitute(inverse[generator], PHI)
        right = substitute(PHI[generator], inverse)
        require_equal(left, (generator,), "phi composed with inverse")
        require_equal(right, (generator,), "inverse composed with phi")
        compositions[display((generator,))] = {
            "phi_after_inverse": display(left),
            "inverse_after_phi": display(right),
        }

    matrix = tuple(
        tuple(exponent_sum(PHI[column], row) for column in (1, 2))
        for row in (1, 2)
    )
    require_equal(matrix, ((1, 1), (1, 2)), "word-derived abelianization matrix")
    trace = matrix[0][0] + matrix[1][1]
    det = determinant(matrix)
    coefficients = (1, -trace, det)
    require_equal(coefficients, (1, -3, 1), "characteristic polynomial")
    require_equal(det, 1, "unimodularity")
    verify_jacobian(matrix, coefficients)

    square = multiply(matrix, matrix)
    three_m_minus_identity = tuple(
        tuple(3 * matrix[i][j] - int(i == j) for j in range(2))
        for i in range(2)
    )
    require_equal(square, three_m_minus_identity, "M^2 - 3M + I = 0")
    cone = verify_trace_induction()

    polynomial_values = [x * x - 3 * x + 1 for x in range(4)]
    require_equal(polynomial_values, [1, -1, -1, 1], "exact root-interval signs")

    nielsen_lambda = {1: (2, 1), 2: (2,)}
    nielsen_rho = {1: (1,), 2: (1, 2)}
    for generator in (1, 2):
        changed_stable_letter = reduce_word((2,) + PHI[generator] + (-2,))
        lambda_after_rho = substitute(nielsen_rho[generator], nielsen_lambda)
        require_equal(
            changed_stable_letter, lambda_after_rho, "s=bt gives lambda after rho"
        )

    print(
        json.dumps(
            {
                "kind": "exact_finite_algebra_certificate",
                "published_example": "Wu-Ye arXiv:2504.14192v1, Example 7.2",
                "rank": 2,
                "phi": {display((g,)): display(PHI[g]) for g in (1, 2)},
                "inverse_search": {
                    "maximum_reduced_word_length": 3,
                    "words_examined": examined,
                    "inverse": {display((g,)): display(inverse[g]) for g in (1, 2)},
                },
                "compositions": compositions,
                "abelianization_matrix": matrix,
                "characteristic_polynomial_descending": coefficients,
                "jacobian_saved_output_agrees": True,
                "cayley_hamilton_identity": "M^2 - 3M + I = 0",
                "trace_recurrence": "T_0=2, T_1=3, T_(n+2)=3T_(n+1)-T_n",
                "affine_induction_certificate": cone,
                "root_interval_signs_at_0_1_2_3": polynomial_values,
                "cat0_construction_normalization": "s=bt, conjugation=lambda o rho",
                "proof_scope": (
                    "The universal quantifiers, presentation isomorphism, and CAT(0) "
                    "theorem application are proved in certificate.md. This output "
                    "checks their finite algebraic data, not a Lean theorem or "
                    "an exhaustive enumeration of filtrations."
                ),
                "review_status": "independent Reviewer acceptance is not asserted",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
