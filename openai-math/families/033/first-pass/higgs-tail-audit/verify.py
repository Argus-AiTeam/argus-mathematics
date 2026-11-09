#!/usr/bin/env python3
"""Replay universal operator certificates and the exact sl4 obstruction."""

import copy
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
ALPHABET = frozenset("l q r a x d y p b c u k z w".split())

HYPOTHESES = {
    "generation": {"a l": 1, "q a l": -1},
    "adjoint_tail_null": {"q a": 1, "q a q": -1},
    "orthogonality": {"q l": 1},
    "g1_in_tail": {"q r": 1, "r": -1},
    "tail_null": {"x q": 1, "q x q": -1},
    "raising_grade": {"q x r": 1},
    "chern_normal_null": {"d l": 1, "l d l": -1, "q d l": -1},
    "chern_grading": {"q d l": 1},
    "orbit_fill": {"r y l": 1, "y l": -1},
    "highest_grade": {"x l": 1},
    "higgs_commutes": {"a z": 1, "z a": -1},
    "tail_zero_raising_null": {"x u": 1, "u x u": -1},
    "piece_in_tail_zero": {"u k": 1, "k": -1},
    "chern_tail_zero_null": {"d u": 1, "u d u": -1},
    "grading_isolation": {"u d k": 1, "k d k": -1},
}
TARGETS = {
    "a_kills_line": {"a l": 1},
    "x_kills_g1": {"x r": 1},
    "flat_line": {"d l": 1, "a l": 1, "l d l": -1, "l a l": -1},
    "all_commutators_kill_line": {"x y l": 1, "y x l": -1},
    "cyclic_action_step": {"a z w l": 1},
    "x_kills_generated_tail": {"x u": 1},
    "x_kills_arbitrary_piece": {"x k": 1},
    "chern_preserves_arbitrary_piece": {"d k": 1, "k d k": -1},
}


class CertificateError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise CertificateError(message)


def word(text):
    require(isinstance(text, str), "A word must be a string")
    letters = tuple(text.split())
    require(all(letter in ALPHABET for letter in letters), "Unknown symbol")
    require(" ".join(letters) == text, "A word is not in canonical form")
    return letters


def polynomial(encoded):
    require(isinstance(encoded, dict), "A polynomial must be an object")
    result = {}
    for text, coefficient in encoded.items():
        require(type(coefficient) is int and coefficient != 0,
                "Coefficients must be nonzero integers")
        result[word(text)] = Fraction(coefficient)
    return result


def add(*polynomials):
    result = {}
    for value in polynomials:
        for monomial, coefficient in value.items():
            result[monomial] = result.get(monomial, 0) + coefficient
    return {monomial: coefficient for monomial, coefficient in result.items()
            if coefficient}


def multiply(left, right):
    result = {}
    for u, a in left.items():
        for v, b in right.items():
            key = u + v
            result[key] = result.get(key, 0) + a * b
    return {monomial: coefficient for monomial, coefficient in result.items()
            if coefficient}


def derivation_result(derivation, relations):
    terms = []
    for term in derivation["terms"]:
        require(set(term) == {"coefficient", "left", "relation", "right"},
                "Unexpected derivation fields")
        coefficient = term["coefficient"]
        require(type(coefficient) is int and coefficient != 0,
                "Invalid proof coefficient")
        name = term["relation"]
        require(name in relations, "Forward or unknown proof dependency")
        terms.append(multiply(
            multiply({word(term["left"]): Fraction(coefficient)}, relations[name]),
            {word(term["right"]): Fraction(1)},
        ))
    return add(*terms)


def verify_derivations(certificate):
    require(certificate["hypotheses"] == HYPOTHESES,
            "The certificate changed a mathematical hypothesis")
    require([item["id"] for item in certificate["derivations"]] == list(TARGETS),
            "Missing, duplicated, reordered, or unexpected postcondition")
    relations = {name: polynomial(value) for name, value in HYPOTHESES.items()}
    for item in certificate["derivations"]:
        name = item["id"]
        require(item["target"] == TARGETS[name],
                f"The certificate changed the postcondition {name}")
        target = polynomial(TARGETS[name])
        scope = dict(relations)
        if name == "cyclic_action_step":
            induction = certificate["span_induction"]
            require(induction == {
                "base": "a_kills_line",
                "step": "cyclic_action_step",
                "local_induction_hypothesis": {"a w l": 1},
                "line_projection": "l",
                "generated_span_projection": "u",
                "generators": "all Higgs contractions z, each commuting with a",
                "conclusion": {"a u": 1},
                "adjoint_conclusion": {"u x": 1},
            }, "Invalid generated-word induction rule")
            require(relations["a_kills_line"] == polynomial({"a l": 1}),
                    "The word induction has no verified base")
            scope["word_induction"] = polynomial({"a w l": 1})
        require(derivation_result(item, scope) == target,
                f"Nonzero universal proof residual for {name}")
        if name == "cyclic_action_step":
            span_equation = polynomial(certificate["span_induction"]["conclusion"])
            star = {"a": "x", "u": "u"}
            adjoint_equation = {
                tuple(star[letter] for letter in reversed(monomial)): coefficient
                for monomial, coefficient in span_equation.items()
            }
            require(adjoint_equation == polynomial({"u x": 1}),
                    "The generated-span adjoint was not derived correctly")
            relations["cyclic_adjoint"] = adjoint_equation
        else:
            relations[name] = target
    return relations


def block_matrix(encoded):
    require(encoded and encoded[0], "Empty block matrix")
    require(all(len(row) == len(encoded[0]) for row in encoded),
            "Ragged block matrix")
    return [[polynomial(entry) for entry in row] for row in encoded]


def block_product(left, right):
    require(len(left[0]) == len(right), "Incompatible block product")
    return [[add(*(multiply(left[i][k], right[k][j])
                   for k in range(len(right))))
             for j in range(len(right[0]))] for i in range(len(left))]


def verify_rank_identity(certificate):
    rank = certificate["rank_certificate"]
    expected_stack = [[{"p": 1}], [{"b": 1}], [{"c p": 1}]]
    expected_reduced = [[{"p": 1}], [{"b": 1}], [{}]]
    require(rank["stack"] == expected_stack, "Wrong stacked rank problem")
    require(rank["reduced_stack"] == expected_reduced,
            "Wrong reduced rank postcondition")
    eliminator = block_matrix(rank["eliminator"])
    inverse = block_matrix(rank["inverse"])
    identity = [[{(): Fraction(1)} if i == j else {}
                 for j in range(3)] for i in range(3)]
    require(block_product(eliminator, inverse) == identity,
            "The rank eliminator has no certified right inverse")
    require(block_product(inverse, eliminator) == identity,
            "The rank eliminator has no certified left inverse")
    require(block_product(eliminator, block_matrix(expected_stack))
            == block_matrix(expected_reduced), "Rank reduction failed")


def zeros(rows, columns):
    return [[Fraction(0) for _ in range(columns)] for _ in range(rows)]


def matrix_unit(i, j):
    require(1 <= i <= 4 and 1 <= j <= 4, "Invalid matrix unit")
    result = zeros(4, 4)
    result[i - 1][j - 1] = Fraction(1)
    return result


def matrix_add(left, right, factor=1):
    return [[a + factor * b for a, b in zip(u, v)]
            for u, v in zip(left, right)]


def matrix_product(left, right):
    return [[sum((left[i][k] * right[k][j] for k in range(len(right))),
                 Fraction(0))
             for j in range(len(right[0]))] for i in range(len(left))]


def transpose(matrix):
    return [list(row) for row in zip(*matrix)]


def bracket(left, right):
    return matrix_add(matrix_product(left, right),
                      matrix_product(right, left), -1)


def trace_product(left, right):
    return sum((a * b for u, v in zip(left, right) for a, b in zip(u, v)),
               Fraction(0))


def matrix_rank(matrix):
    rows = copy.deepcopy(matrix)
    pivot_row = 0
    pivots = []
    for column in range(len(rows[0])):
        pivot = next((i for i in range(pivot_row, len(rows))
                      if rows[i][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        value = rows[pivot_row][column]
        rows[pivot_row] = [a / value for a in rows[pivot_row]]
        for i in range(len(rows)):
            if i != pivot_row:
                value = rows[i][column]
                rows[i] = [a - value * b for a, b in
                           zip(rows[i], rows[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return len(pivots), pivots


def verify_obstruction(certificate):
    data = certificate["diagonal_obstruction"]
    require(data["grading_element"] == [1, 1, 0, 0], "Wrong grading")
    expected_basis = [[1, 3], [1, 4], [2, 3], [2, 4]]
    require(data["highest_basis"] == expected_basis, "Wrong highest space")
    require(data["x"] == [1, 3] and data["s"] == [2, 4]
            and data["y"] == [3, 2], "Wrong obstruction")
    highest = [matrix_unit(*indices) for indices in expected_basis]
    x, s, y = (matrix_unit(*data[key]) for key in ("x", "s", "y"))
    x_star = transpose(x)
    require(bracket(x_star, s) == zeros(4, 4), "x*s is nonzero")
    require(bracket(bracket(x, x_star), s) == zeros(4, 4),
            "Diagonal commutator does not vanish")
    require(bracket(bracket(x, y), s) == matrix_unit(1, 4),
            "The universally quantified hypothesis was not disproved")
    h = matrix_add(matrix_unit(1, 1), matrix_unit(3, 3), -1)
    image_basis = [h, matrix_unit(3, 4), matrix_unit(2, 1)]
    action = data["x_star_on_highest"]
    require(action == [[-1, 0, 0, 0], [0, 1, 0, 0], [0, 0, -1, 0]],
            "Wrong claimed action matrix")
    for j, vector in enumerate(highest):
        image = zeros(4, 4)
        for i, basis_vector in enumerate(image_basis):
            image = matrix_add(image, basis_vector, action[i][j])
        require(bracket(x_star, vector) == image,
                "Compressed action does not reconstruct the full action")
    full_basis = [matrix_unit(i, j) for i in range(1, 5)
                  for j in range(1, 5) if i != j]
    full_basis += [matrix_add(matrix_unit(i, i), matrix_unit(i + 1, i + 1), -1)
                   for i in range(1, 4)]
    for u in full_basis:
        for v in full_basis:
            require(trace_product(bracket(x, u), v)
                    == trace_product(u, bracket(x_star, v)),
                    "Adjoint compatibility failed")
    diagonal = zeros(4, 4)
    for i, degree in enumerate(data["grading_element"]):
        diagonal[i][i] = Fraction(degree)
    for vector in highest:
        require(bracket(diagonal, vector) == vector,
                "The proposed top vector has the wrong grade")
    require(matrix_rank(action) == (3, [0, 1, 2]), "Action rank is not three")
    return action


def decode_rational_function(entry):
    require(entry.get("domain", "QQ") == "QQ" and entry["variables"] == [],
            "The bounded Jacobian replay must be rational, not specialized")
    numerator = entry["numerator"]["terms"]
    denominator = entry["denominator"]["terms"]
    require(len(numerator) <= 1 and len(denominator) == 1,
            "Noncanonical constant rational function")
    def constant(term):
        require(term["exponents"] == [], "A constant has exponents")
        coefficient = term["coefficient"]
        return Fraction(int(coefficient["num"]), int(coefficient["den"]))
    require(constant(denominator[0]) == 1, "Nonunit constant denominator")
    return constant(numerator[0]) if numerator else Fraction(0)


def verify_jacobian(certificate, action):
    evidence = certificate["jacobian"]
    status = json.loads((ROOT / evidence["adapter_status"]).read_text())
    output = json.loads((ROOT / evidence["typed_output"]).read_text())
    payload = json.loads((ROOT / evidence["payload"]).read_text())
    require(status["exit_code"] == 0, "Jacobian adapter failed")
    require(output["server"]["name"] == "jacobian", "Wrong mathematical server")
    require(output["server"]["version"], "Missing server version")
    require(output["protocol_version"], "Missing adapter protocol")
    require(evidence["operation_id"] == "matrix.symbolic.rank.compute",
            "Unexpected Jacobian operation")
    request = output["request"]
    require(request["operation_id"] == evidence["operation_id"],
            "The returned operation differs from the requested one")
    require(request["payload"] == payload, "Returned payload differs from the input")
    matrix = payload["matrix"]
    require(matrix["variables"] == [], "Unexpected rank specialization")
    decoded = [[decode_rational_function(entry) for entry in row]
               for row in matrix["entries"]]
    require(decoded == action, "Jacobian checked a different linear map")
    result = output["result"]
    require(result["operation_id"] == evidence["operation_id"]
            and "output" in result and "error" not in result,
            "Jacobian did not conclude successfully")
    answer = result["output"]
    require(answer["method"] == "EXACT_SYMBOLIC_ROW_REDUCTION",
            "Jacobian used an unexpected method")
    require(answer["rank"] == 3 and answer["pivot_columns"] == [0, 1, 2],
            "Jacobian rank disagrees with exact replay")
    return {"server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "operation_id": evidence["operation_id"], "rank": answer["rank"]}


def verify_negative_controls(certificate):
    for index in range(len(TARGETS)):
        altered = copy.deepcopy(certificate)
        altered["derivations"][index]["terms"][0]["coefficient"] *= -1
        try:
            verify_derivations(altered)
        except CertificateError:
            pass
        else:
            raise CertificateError("An altered proof coefficient was accepted")
    altered = copy.deepcopy(certificate)
    altered["rank_certificate"]["eliminator"][2][0] = {"c": 1}
    try:
        verify_rank_identity(altered)
    except CertificateError:
        pass
    else:
        raise CertificateError("A wrong rank eliminator was accepted")
    altered = copy.deepcopy(certificate)
    altered["span_induction"]["generated_span_projection"] = "q"
    try:
        verify_derivations(altered)
    except CertificateError:
        pass
    else:
        raise CertificateError("An induction over the wrong span was accepted")


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["claim"] == "C_TAIL_KERNEL", "Wrong local claim")
    require(certificate["associated_geometric_claim"] == "C_COMMON_TAIL_DIMENSION",
            "Wrong associated geometric claim")
    verify_derivations(certificate)
    verify_rank_identity(certificate)
    action = verify_obstruction(certificate)
    jacobian = verify_jacobian(certificate, action)
    verify_negative_controls(certificate)
    print(json.dumps({
        "ok": True,
        "claim": "C_TAIL_KERNEL",
        "associated_geometric_claim": "C_COMMON_TAIL_DIMENSION",
        "universal_operator_implications": list(TARGETS),
        "dimension_independent_rank_identity": True,
        "exact_sl4_diagonal_obstruction": True,
        "arbitrary_length_word_induction": True,
        "negative_controls_rejected": len(TARGETS) + 2,
        "jacobian": jacobian,
        "full_geometric_proof": "report.md; independent review required",
        "machine_checked_scope": "Exact algebraic components, not external Hodge theory",
        "full_geometric_claim_mechanically_verified": False,
        "manuscript_refuted": False,
    }, indent=2))


if __name__ == "__main__":
    main()
