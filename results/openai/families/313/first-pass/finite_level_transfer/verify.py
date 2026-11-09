#!/usr/bin/env python3
"""Replay the exact algebra in proof.md; do not certify its categorical inputs."""

import json
from fractions import Fraction
from itertools import product
from math import prod
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((ROOT / name).read_text(encoding="utf-8"))


def add(*vectors):
    require(len({len(v) for v in vectors}) == 1, "coefficient basis mismatch")
    return tuple(sum(entries) for entries in zip(*vectors))


def scale(vector, coefficient):
    return tuple(coefficient * entry for entry in vector)


def check_vector(actual, expected, message):
    require(actual == tuple(expected), message)


def universal_algebra(certificate):
    schemas = certificate["universal_schemas"]
    chain = schemas["chain_exponent"]
    require(chain["basis"] == ["s", "gap", "1"], "wrong exponent basis")
    s, gap = (1, 0, 0), (0, 1, 0)
    q = add(s, gap)
    check_vector(q, chain["q_definition"], "q must equal s+gap")
    target = add(q, scale(gap, 0))
    source = add(s, scale(gap, 1))
    require(target == source, "removed-coordinate chain identity failed")
    check_vector(target, chain["target_removed_coordinate"], "wrong target exponent")
    check_vector(source, chain["source_removed_coordinate"], "wrong source exponent")
    require(
        chain["other_coordinate_memberships"] == [0, 1],
        "both possible membership states must be covered",
    )
    for member in chain["other_coordinate_memberships"]:
        left = scale(gap, 1 - member)
        right = scale(gap, 1 - member)
        require(left == right, "unchanged-coordinate identity failed")

    for first_parity, second_parity in product((0, 1), repeat=2):
        first_sign = -1 if first_parity else 1
        second_sign = -1 if second_parity else 1
        shifted_second_sign = -1 if (second_parity + 1) % 2 else 1
        require(
            second_sign * first_sign + first_sign * shifted_second_sign == 0,
            "Koszul two-removal signs do not cancel",
        )
    require(prod(()) == certificate["ordinary_normalization"]["top_coefficient"] == 1,
            "the top component must be the empty product 1")

    pairing = schemas["pairing_complement"]
    require(pairing["basis"] == ["q", "alpha", "1"], "wrong pairing basis")
    q, alpha, one = (1, 0, 0), (0, 1, 0), (0, 0, 1)
    complement = add(q, scale(one, -1), scale(alpha, -1))
    check_vector(complement, pairing["complement"], "wrong complementary exponent")
    twice = add(q, scale(one, -1), scale(complement, -1))
    require(twice == alpha, "complement pairing must be an involution")
    check_vector(twice, pairing["complement_twice"], "wrong pairing involution")
    negative_wrap = add(q, scale(one, -1), scale(q, -1))
    check_vector(negative_wrap, pairing["negative_wrap_upper_bound"],
                 "a negative wrap must lie below zero")
    require(negative_wrap == scale(one, -1), "negative-wrap gap must be exactly 1")
    positive_wrap = add(q, scale(one, -1), q)
    largest_sum = add(scale(q, 2), scale(one, -2))
    excess = add(positive_wrap, scale(largest_sum, -1))
    check_vector(excess, pairing["positive_wrap_excess"],
                 "a positive wrap must exceed 2q-2")
    require(excess == one, "positive-wrap gap must be exactly 1")

    socles = schemas["successive_socles"]
    require(socles["basis"] == ["1", "s", "t", "s*t"], "wrong socle basis")
    first, second = (-1, 1, 0, 0), (0, -1, 0, 1)
    check_vector(first, socles["first_extraction"], "first extraction is s-1")
    check_vector(second, socles["second_extraction"], "second extraction is s(t-1)")
    check_vector(add(first, second), socles["combined_extraction"],
                 "successive socles must select st-1")
    require(add(first, second) == (-1, 0, 0, 1), "socle identity failed")

    filtration = schemas["filtration_induction"]
    require(filtration["basis"] == ["steps", "1"], "wrong filtration basis")
    require(filtration["initial_grade"] == filtration["per_step_increase"] == 1,
            "the forgetting kernel starts at F^1 and each step raises its grade")
    grade, one = (1, 1), (0, 1)
    check_vector(grade, filtration["grade_after_steps"], "wrong induction invariant")
    next_grade = add(grade, one)
    check_vector(next_grade, filtration["grade_after_one_more_step"],
                 "filtration induction step failed")
    require(next_grade == (1, 2), "grade(steps+1) must equal grade(steps)+1")
    require(filtration["restrictions_in_degree_j"] == "j", "wrong restriction count")
    require(filtration["terminal_grade"] == "j+1", "wrong terminal grade")
    require(filtration["terminal_filtration"] == "F^(j+1) H^j = 0",
            "the vanishing filtration hypothesis must remain explicit")


def matrix(strings):
    require(bool(strings) and bool(strings[0]), "empty matrix")
    width = len(strings[0])
    require(all(len(row) == width for row in strings), "ragged matrix")
    return [[Fraction(entry) for entry in row] for row in strings]


def multiply(left, right):
    require(len(left[0]) == len(right), "matrix dimensions do not match")
    return [
        [
            sum((left[i][k] * right[k][j] for k in range(len(right))), Fraction(0))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def zero(matrix_value):
    return all(entry == 0 for row in matrix_value for entry in row)


def koszul_fixture(exponent, coordinates):
    x, y = coordinates
    return [
        [[str(x ** exponent), str(y ** exponent)]],
        [[str(-(y ** exponent))], [str(x ** exponent)]],
    ]


def replay_jacobian(certificate):
    spec = certificate["jacobian"]
    payload = load(spec["payload"])
    response = load(spec["typed_output"])
    status = load(spec["adapter_status"])
    operation = "chain_complex.verify_chain_map.compute"
    require(spec["operation_id"] == operation, "wrong operation")
    require(status["operation_id"] == operation, "adapter operation mismatch")
    require(status["adapter_exit_code"] == spec["expected_adapter_exit_code"] == 0,
            "an adapter error or timeout is not a mathematical conclusion")
    require(response["protocol_version"] == spec["protocol_version"], "protocol mismatch")
    require(response["server"]["version"] == spec["server_version"], "server mismatch")
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "saved Jacobian answer is not bound to the exact saved payload")
    require(response["result"]["operation_id"] == operation, "result operation mismatch")
    output = response["result"]["output"]
    require(output["is_valid"] is True, "Jacobian did not verify the diagnostic")
    require(output["map_matrices"] == payload["map_matrices"], "returned map differs")

    for name in ("source", "target"):
        expected = dict(payload[name])
        expected.setdefault("prime", None)
        require(output[name] == expected, f"returned {name} differs")
        require(expected["coefficient_field"] == "QQ", "fixture is rational")
        require(expected["basis_sizes"] == [1, 2, 1], "wrong Koszul dimensions")
        require((expected["degree_min"], expected["degree_max"]) == (0, 2),
                "wrong Koszul degree range")

    fixture = spec["fixture"]
    require(fixture["dimension"] == 2 and fixture["field"] == "QQ", "wrong fixture")
    s, q = fixture["s"], fixture["q"]
    require(isinstance(s, int) and isinstance(q, int) and 1 <= s <= q,
            "invalid fixture exponents")
    x, y = fixture["coordinates"]
    require(payload["source"]["differential_matrices"] == koszul_fixture(s, (x, y)),
            "source does not implement the stated signed Koszul differential")
    require(payload["target"]["differential_matrices"] == koszul_fixture(q, (x, y)),
            "target does not implement the stated signed Koszul differential")
    gap = q - s
    expected_maps = [
        [[str(x ** gap * y ** gap)]],
        [[str(y ** gap), "0"], ["0", str(x ** gap)]],
        [["1"]],
    ]
    require(payload["map_matrices"] == expected_maps,
            "fixture map is not the complement-product comparison")

    source = [matrix(d) for d in payload["source"]["differential_matrices"]]
    target = [matrix(d) for d in payload["target"]["differential_matrices"]]
    maps = [matrix(f) for f in payload["map_matrices"]]
    require(zero(multiply(source[0], source[1])), "source d^2 is nonzero")
    require(zero(multiply(target[0], target[1])), "target d^2 is nonzero")
    for degree in (1, 2):
        require(
            multiply(target[degree - 1], maps[degree])
            == multiply(maps[degree - 1], source[degree - 1]),
            f"independent rational chain-map replay failed in degree {degree}",
        )
    return {"operation_id": operation, "adapter_exit_code": 0, "independent_replay": True}


def main():
    certificate = load("exact_certificate.json")
    require(certificate["schema_version"] == 1, "unsupported certificate schema")
    require(certificate["claim_id"] == "C_FT_BRIDGE", "wrong claim")
    quantifiers = certificate["quantifiers"]
    require(quantifiers["marking_subgroup"] == "exists one U_* before quantifying over q",
            "the required quantifier order has been changed")
    require(quantifiers["fixed_endpoints"] == ["N_s", "k"], "endpoints must be fixed")
    require(certificate["common_subgroup"]["q_dependent_intersection_used"] is False,
            "intersecting infinitely many power-dependent subgroups is not allowed")
    require(
        certificate["finite_stage"]["geometric_inputs_not_reproved"]
        == ["C_FT_LIFT_TORSOR", "C_FT_GEOMETRY", "C_FT_WHOLE_MODEL"],
        "the conditional geometric inputs must remain visible",
    )
    require(certificate["independent_review"] == "pending", "no review is fabricated")
    require(certificate["novelty_status"] == "unverified", "no novelty is fabricated")
    for name in [certificate["proof"], *certificate["source_excerpts"]]:
        require((ROOT / name).is_file(), f"missing proof or source excerpt: {name}")
    universal_algebra(certificate)
    jacobian = replay_jacobian(certificate)
    print(json.dumps({
        "exact_algebra": "verified",
        "parameter_scope": "coordinate and filtration induction schemas, not finite sweeps",
        "top_coefficient": 1,
        "jacobian_finite_diagnostic": jacobian,
        "full_equivariant_and_descent_proof": "proof.md; independent review required",
        "sphere_theorem": "not certified",
    }, indent=2))


if __name__ == "__main__":
    main()
