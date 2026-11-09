#!/usr/bin/env python3
"""Replay exact universal algebra; the analytic theorem is proved in report.md."""

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ZERO_EXP = (0,) * 8
UNIT = {(0, ZERO_EXP): Fraction(1)}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for key, coefficient in polynomial.items():
            result[key] = result.get(key, 0) + coefficient
    return {key: value for key, value in result.items() if value}


def scale(polynomial, coefficient):
    coefficient = Fraction(coefficient)
    return {key: value * coefficient for key, value in polynomial.items()
            if value * coefficient}


def multiply(left, right):
    result = {}
    for (mask, powers), coefficient in left.items():
        for (other_mask, other_powers), other_coefficient in right.items():
            if mask & other_mask:
                continue
            key = (mask | other_mask, tuple(a + b for a, b in
                                           zip(powers, other_powers)))
            result[key] = result.get(key, 0) + coefficient * other_coefficient
    return {key: value for key, value in result.items() if value}


def variable(index, mask=0):
    powers = list(ZERO_EXP)
    powers[index] = 1
    return {(mask, tuple(powers)): Fraction(1)}


def matrix_add(*matrices):
    return [[add(*(matrix[i][j] for matrix in matrices))
             for j in range(3)] for i in range(3)]


def matrix_scale(matrix, coefficient):
    return [[scale(entry, coefficient) for entry in row] for row in matrix]


def matrix_multiply(left, right):
    return [[add(*(multiply(left[i][k], right[k][j]) for k in range(3)))
             for j in range(3)] for i in range(3)]


def scalar_matrix(matrix, scalar):
    return [[multiply(entry, scalar) for entry in row] for row in matrix]


def constant_matrix(entries):
    return [[scale(UNIT, coefficient) for coefficient in row] for row in entries]


IDENTITY = constant_matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
A = constant_matrix([[0, 0, 0], [0, 0, -1], [0, 1, 0]])
B = constant_matrix([[0, 0, 1], [0, 0, 0], [-1, 0, 0]])
C = constant_matrix([[0, -1, 0], [1, 0, 0], [0, 0, 0]])


def exponential(matrix):
    result = IDENTITY
    power = IDENTITY
    for degree in range(1, 5):
        power = matrix_multiply(power, matrix)
        result = matrix_add(result, matrix_scale(power, Fraction(1, math.factorial(degree))))
    return result


def logarithm_near_identity(matrix):
    difference = matrix_add(matrix, matrix_scale(IDENTITY, -1))
    result = [[{} for _ in range(3)] for _ in range(3)]
    power = IDENTITY
    for degree in range(1, 5):
        power = matrix_multiply(power, difference)
        result = matrix_add(result, matrix_scale(power, Fraction((-1) ** (degree + 1), degree)))
    return result


def component(matrix, mask):
    return [[{(0, powers): coefficient for (term_mask, powers), coefficient in entry.items()
              if term_mask == mask} for entry in row] for row in matrix]


def gauge_certificate():
    require(matrix_add(matrix_multiply(A, B),
                       matrix_scale(matrix_multiply(B, A), -1)) == C,
            "The generators have the wrong bracket orientation")
    generators = [A, B, A, B]
    fx = matrix_add(*(scalar_matrix(generator, variable(i, 1 << i))
                      for i, generator in enumerate(generators)))
    fy = matrix_add(*(scalar_matrix(generator, variable(i + 4, 1 << i))
                      for i, generator in enumerate(generators)))
    product = matrix_multiply(
        matrix_multiply(exponential(fx),
                        exponential(matrix_add(fy, matrix_scale(fx, -1)))),
        exponential(matrix_scale(fy, -1)))
    logarithm = logarithm_near_identity(product)
    zero = [[{} for _ in range(3)] for _ in range(3)]
    require(component(logarithm, 0) == zero, "Nonzero constant logarithm")
    for i in range(4):
        require(component(logarithm, 1 << i) == zero, "Nonzero first derivative")
    quadratic = []
    for i, j in itertools.combinations(range(4), 2):
        bracket = matrix_add(matrix_multiply(generators[i], generators[j]),
                             matrix_scale(matrix_multiply(generators[j], generators[i]), -1))
        wedge = scale(add(multiply(variable(i), variable(j + 4)),
                          scale(multiply(variable(j), variable(i + 4)), -1)), Fraction(1, 2))
        require(component(logarithm, (1 << i) | (1 << j)) == scalar_matrix(bracket, wedge),
                f"Incorrect second derivative in slots {i + 1},{j + 1}")
        quadratic.append([i + 1, j + 1])
    require(component(logarithm, 15) == zero, "Nonzero labeled (a,b,a,b) fourth derivative")
    return {
        "ring": "QQ[x1,x2,x3,x4,y1,y2,y3,y4][t1,t2,t3,t4]/(t1^2,t2^2,t3^2,t4^2)",
        "why_universal": "Endpoint variables are indeterminates, not sampled values; mixed squarefree coefficients are exact labeled derivatives.",
        "generator_bracket": "[a,b]=c",
        "quadratic_pairs_checked": quadratic,
        "first_derivatives_zero": True,
        "abab_fourth_derivative_residual_terms": 0,
    }


def partitions(items):
    if not items:
        yield ()
        return
    first, *rest = items
    for partition in partitions(rest):
        yield ((first,),) + partition
        for index in range(len(partition)):
            yield partition[:index] + ((first,) + partition[index],) + partition[index + 1:]


def canonical_partition(partition):
    return tuple(sorted(tuple(sorted(block)) for block in partition))


def gram_token(x, y):
    return (min(x, y), max(x, y), x > y)


def contractions_certificate():
    rows = [
        ("H13 X2 X4", ((0, 2), (1,), (3,)), ((0, 1, False), (0, 2, True)), 4),
        ("H14 X2 X3", ((0, 3), (1,), (2,)), ((0, 1, False), (0, 2, False)), 4),
        ("H23 X1 X4", ((1, 2), (0,), (3,)), ((0, 1, True), (0, 2, True)), 4),
        ("H24 X1 X3", ((1, 3), (0,), (2,)), ((0, 1, True), (0, 2, False)), 4),
        ("H13 H24", ((0, 2), (1, 3)), ((0, 1, False), (0, 1, True)), 4),
        ("H14 H23", ((0, 3), (1, 2)), ((0, 1, False), (0, 1, False)), 4),
        ("H123 X4", ((0, 1, 2), (3,)), ((0, 0, False), (0, 1, True)), 3),
        ("H124 X3", ((0, 1, 3), (2,)), ((0, 0, False), (0, 1, False)), 3),
        ("H134 X2", ((0, 2, 3), (1,)), ((0, 0, False), (0, 1, False)), 3),
        ("H234 X1", ((1, 2, 3), (0,)), ((0, 0, False), (0, 1, True)), 3),
        ("H1234", ((0, 1, 2, 3),), ((0, 0, False), (0, 0, False)), 2),
    ]
    positive = {
        canonical_partition(p) for p in [
            ((0,), (1,), (2,), (3,)), ((0, 1), (2,), (3,)),
            ((0,), (1,), (2, 3)), ((0, 1), (2, 3)),
        ]
    }
    all_partitions = {canonical_partition(p) for p in partitions([0, 1, 2, 3])}
    require(len(all_partitions) == 15, "Incorrect fourth exponential derivative enumeration")
    require({canonical_partition(row[1]) for row in rows} == all_partitions - positive,
            "The eleven contractions do not exhaust the complement of the square")
    outputs = []
    for name, blocks, expected, beta_sqrt_power in rows:
        locations = {}
        for edge, block in enumerate(blocks):
            for slot in block:
                locations[slot] = edge
        actual = sorted([gram_token(locations[0], locations[1]),
                         gram_token(locations[3], locations[2])])
        require(actual == sorted(expected), f"Conjugation error in {name}")
        outputs.append({"term": name, "kernel_factors": actual,
                        "power_of_sqrt_beta_in_bound": beta_sqrt_power})
    counts = {power: sum(row[3] == power for row in rows) for power in [4, 3, 2]}
    require(counts == {4: 6, 3: 4, 2: 1}, "Incorrect K_rot coefficient count")
    return {"set_partitions": 15, "positive_square_partitions": 4,
            "master_identity": "sum_i,j u_i(e1) conj(u_i(e2)) conj(u_j(e3)) u_j(e4) = T(e1,e2) T(e4,e3)",
            "formal_universality": "Main.lean: kernel_factor and contraction_table",
            "rows": outputs, "bound_counts": counts}


def parse_rational_function(value):
    require(value["variables"] == ["x", "y"], "Unexpected Jacobian variable order")
    denominator = value["denominator"]["terms"]
    require(denominator == [{"coefficient": {"num": "1", "den": "1"}, "exponents": [0, 0]}],
            "Unexpected nonunit denominator")
    return {tuple(term["exponents"]): Fraction(int(term["coefficient"]["num"]),
                                              int(term["coefficient"]["den"]))
            for term in value["numerator"]["terms"]}


def jacobian_certificate():
    status = json.loads((HERE / "jacobian-status.json").read_text())
    output = json.loads((HERE / "jacobian-output.json").read_text())
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    operation = "matrix.symbolic.characteristic_polynomial.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian did not complete successfully")
    require(output["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(output["request"]["payload"] == payload, "Jacobian did not use the retained payload")
    require(output["result"]["operation_id"] == operation, "Unexpected Jacobian result")
    expected_matrix = [[{}, {}, {(0, 1): Fraction(1)}],
                       [{}, {}, {(1, 0): Fraction(-1)}],
                       [{(0, 1): Fraction(-1)}, {(1, 0): Fraction(1)}, {}]]
    require([[parse_rational_function(entry) for entry in row]
             for row in payload["matrix"]["entries"]] == expected_matrix,
            "The payload is not x a + y b")
    value = output["result"]["output"]
    require(value["degree"] == 3 and value["convention"] == "DET_LAMBDA_I_MINUS_A",
            "Incorrect characteristic polynomial convention")
    require([parse_rational_function(coefficient) for coefficient in value["coefficients_descending"]]
            == [{(0, 0): Fraction(1)}, {}, {(2, 0): Fraction(1), (0, 2): Fraction(1)}, {}],
            "Incorrect symbolic characteristic polynomial")
    x, y = variable(0), variable(1)
    matrix = matrix_add(scalar_matrix(A, x), scalar_matrix(B, y))
    relation = matrix_add(matrix_multiply(matrix_multiply(matrix, matrix), matrix),
                          scalar_matrix(matrix, add(multiply(x, x), multiply(y, y))))
    require(all(not entry for row in relation for entry in row), "Cayley-Hamilton replay failed")
    lam = variable(2)
    characteristic_matrix = matrix_add(scalar_matrix(IDENTITY, lam), matrix_scale(matrix, -1))
    determinant = {}
    for permutation in itertools.permutations(range(3)):
        inversions = sum(permutation[i] > permutation[j] for i in range(3) for j in range(i + 1, 3))
        term = UNIT
        for i in range(3):
            term = multiply(term, characteristic_matrix[i][permutation[i]])
        determinant = add(determinant, scale(term, (-1) ** inversions))
    require(determinant == add(multiply(multiply(lam, lam), lam),
                               multiply(lam, add(multiply(x, x), multiply(y, y)))),
            "Independent symbolic determinant replay failed")
    return {"operation_id": operation, "adapter_exit_code": 0, "structured_error": None,
            "timeout_status": "completed_without_timeout",
            "server_version": output["server"]["version"], "protocol": output["protocol_version"],
            "characteristic_polynomial": "lambda^3+(x^2+y^2)lambda",
            "independent_matrix_cube_residual_terms": 0}


def costs_certificate():
    r = variable(0)
    half_shell = add(scale(r, 2), UNIT, scale(add(r, scale(UNIT, -1)), 2))
    require(half_shell == add(scale(r, 4), scale(UNIT, -1)), "Half-shell count mismatch")
    require(Fraction(50 * 9, 4) <= 128, "Mode norm constant too small")
    require(16 + 8 <= 32, "Directional operator constant too small")
    require(16 * (2 * 32 ** 2) ** 2 * 4 == 2 ** 28, "HS cost constant mismatch")
    require(2 * 16 ** 2 * 128 == 2 ** 16, "Minimum-pair cost constant mismatch")
    require(Fraction(25, 24) <= 2, "Midpoint error constant too small")
    k = {2: 1, 3: 4, 4: 6}
    error = {2: 2 ** 18 + 300, 3: 1600, 4: 10000}
    slack = {power: (2 ** 31 - 2 ** 30) * coefficient - error[power]
             for power, coefficient in k.items()}
    require(all(value > 0 for value in slack.values()), "Response budget not uniform in beta")
    return {
        "scope": "All N>=2 and all beta>=0; no scale or temperature sampling",
        "half_plane_modes_per_shell": "4r-1",
        "all_four_groups_modes_per_shell_bound": "16r",
        "lambda_lower_bound": "H_N/2; sine concavity proof in report.md",
        "HS_cost_bound": "2^28 M^4 H_N",
        "minimum_pair_cost_bound": "2^16 M^4 H_N",
        "midpoint_l1_bound": "100 M^2/N",
        "response_bound": "2^31 M^4 K(beta)/H_N",
        "response_budget_slack_in_t_equals_sqrt_beta": slack,
        "annular_minmax_bound": "1-2^34 M^4 K(beta)/H_N",
    }


def formal_certificate():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result.get("status") == "success" and result.get("exit_code") == 0,
            "Lean has not successfully compiled")
    require(result.get("proof_holes") == [], "Lean proof holes are present")
    require(result.get("audit_exit_code") == 0, "The Lean axiom audit did not succeed")
    source_digest = hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest()
    fidelity_digest = hashlib.sha256((HERE / "statement_fidelity.md").read_bytes()).hexdigest()
    require(result.get("source_sha256") == source_digest
            and result.get("statement_fidelity_sha256") == fidelity_digest,
            "The Lean record is not bound to the current source and reading")
    compiler_version = result["tools"]["lean"]["version"]
    require(compiler_version.startswith("Lean (version 4.31.0,"),
            "The retained compiler is not Lean 4.31.0")
    return {"source": "Main.lean", "reading": "statement_fidelity.md",
            "success": True, "proof_holes": [], "axiom_audit_exit_code": 0,
            "compiler_version": compiler_version,
            "scope": "Universal finite-family algebra and error accounting, not the analytic Gibbs theorem"}


def nonpositivity_certificate():
    current = C[0][1]
    second_local = matrix_multiply(C, C)[0][1]
    response = scale(add(second_local, multiply(current, current)), -1)
    require(current == scale(UNIT, -1) and not second_local and response == scale(UNIT, -1),
            "The prescribed-spin nonpositivity stress case failed")
    return {
        "graph": "One edge, both spins prescribed as e1 and e2, b=1, h=1",
        "X": -1, "H2": 0, "R(h,h)": -1,
        "role": "Demonstrates why no positive-form transfer argument is admissible",
    }


def build_certificate():
    return {
        "claim_id": "C_ANNULAR_SIGNED",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "result_kind": "parameter_uniform_verification_and_structural_extension",
        "independent_review": "Not asserted by this artifact; consult the claim ledger for independent verdicts",
        "novelty": "Extension beyond the staged theorem is explicit; this artifact makes no prior-art completeness claim",
        "gauge": gauge_certificate(),
        "fourth_derivative": contractions_certificate(),
        "jacobian": jacobian_certificate(),
        "uniform_costs": costs_certificate(),
        "formal_core": formal_certificate(),
        "nonpositivity_stress_case": nonpositivity_certificate(),
        "analytic_proof": "report.md, Theorems A and B",
        "not_claimed": [
            "A refutation of any staged assertion",
            "A full Lean formalization of the analytic theorem",
            "A proof of the separate cluster transfer",
            "A full transfer gap, continuum limit, isolated pole, or exact mass asymptotic",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == json.loads(json.dumps(certificate)),
            "The retained exact certificate differs from this replay")
    print("PASS: universal gauge jets, 15 partitions, 11 contractions, uniform cost accounting, and current Lean core")


if __name__ == "__main__":
    main()
