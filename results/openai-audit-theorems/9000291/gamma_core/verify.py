#!/usr/bin/env python3
"""Replay universal algebra and exact arithmetic, not finite-sample C*-analysis."""

import hashlib
import json
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def mono(word="", c_power=0, coefficient=1):
    return {(c_power, tuple(word)): Q(coefficient)}


def add(*polynomials):
    result = Counter()
    for polynomial in polynomials:
        for key, coefficient in polynomial.items():
            result[key] += coefficient
    return {key: value for key, value in result.items() if value}


def scale(polynomial, coefficient, c_shift=0):
    return {
        (power + c_shift, word): value * Q(coefficient)
        for (power, word), value in polynomial.items()
        if value * Q(coefficient)
    }


def mul(left, right):
    result = Counter()
    for (p, u), a in left.items():
        for (q, v), b in right.items():
            result[(p + q, u + v)] += a * b
    return {key: value for key, value in result.items() if value}


def power(polynomial, exponent):
    result = mono()
    for _ in range(exponent):
        result = mul(result, polynomial)
    return result


def adjoint(polynomial):
    return {(p, word[::-1]): coefficient for (p, word), coefficient in polynomial.items()}


def reduce_involution(word):
    stack = []
    for letter in word:
        if letter == "r" and stack and stack[-1] == "r":
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def trace_word(word):
    word = reduce_involution(word)
    while word:
        candidates = [
            reduce_involution(word[k:] + word[:k]) for k in range(len(word))
        ]
        shortest = min(candidates, key=lambda value: (len(value), value))
        if len(shortest) == len(word):
            return shortest
        word = shortest
    return ()


def normal(polynomial, word_normalizer):
    result = Counter()
    for (p, word), coefficient in polynomial.items():
        result[(p, word_normalizer(word))] += coefficient
    return {key: value for key, value in result.items() if value}


def trace(polynomial):
    return normal(polynomial, trace_word)


def profile(polynomial):
    return [
        {"c_power": p, "word": "".join(word), "coefficient": str(coefficient)}
        for (p, word), coefficient in sorted(polynomial.items())
    ]


def scalar_coefficients(polynomial, degree):
    require(all(not word for _, word in polynomial), "Unexpected nonscalar term")
    return [str(polynomial.get((k, ()), Q(0))) for k in range(degree + 1)]


def check_universal_algebra(certificate):
    x, r, b = mono("x"), mono("r"), mono("b")
    z = add(x, scale(r, 1, 1))
    actual = trace(power(z, 4))
    expected = trace(add(
        power(x, 4),
        scale(mul(power(x, 3), r), 4, 1),
        scale(power(x, 2), 4, 2),
        scale(mul(mul(mul(x, r), x), r), 2, 2),
        scale(mul(x, r), 4, 3),
        mono(c_power=4),
    ))
    require(actual == expected, "Noncommutative fourth expansion failed")
    require(
        profile(actual) == certificate["universal_algebra"]["cyclic_fourth_profile"],
        "Serialized fourth profile disagrees with the exact expansion",
    )
    commutator = add(mul(x, r), scale(mul(r, x), -1))
    square = trace(mul(adjoint(commutator), commutator))
    require(
        square == trace(add(
            scale(power(x, 2), 2),
            scale(mul(mul(mul(x, r), x), r), -2),
        )),
        "Squared commutator identity failed",
    )
    require(
        profile(square) == certificate["universal_algebra"]["commutator_square_profile"],
        "Serialized commutator profile disagrees",
    )
    require(trace_word(tuple("xrxr")) != trace_word(tuple("xx")),
            "An illicit commutation collapsed the alternating word")
    centered = {key: value for key, value in actual.items() if key[0] % 2 == 0}
    deficit_form = add(
        trace(power(x, 4)), scale(trace(power(x, 2)), 6, 2),
        mono(c_power=4), scale(square, -1, 2),
    )
    require(centered == deficit_form, "Centered fourth deficit identity failed")

    second = trace(mul(b, power(z, 2)))
    mixed = {key: value for key, value in second.items() if key[0] == 1}
    require(len(mixed) == 2, "A coefficient was incorrectly commuted with x")
    require(all(word.count("r") == 1 for _, word in mixed),
            "A second-moment cancellation used a repeated maximal index")
    residual = {key: value for key, value in second.items() if key[0] != 1}
    require(residual == trace(add(mul(b, power(x, 2)), scale(b, 1, 2))),
            "Coefficient second-moment induction step failed")

    a, ri, rj = mono("a"), mono("i"), mono("j")
    ki = add(mul(ri, a), scale(mul(a, ri), -1))
    kj = add(mul(rj, a), scale(mul(a, rj), -1))
    gram = mul(adjoint(ki), kj)
    require(len(gram) == 4, "Mixed commutator expansion is incomplete")
    require(all(word.count("j") == 1 and set(word) <= set("aij") for _, word in gram),
            "Gram cancellation is not a maximal-index singleton cancellation")

    v, q, d, delta = mono("v"), mono("q"), mono("d"), mono("t")
    c2, c4 = mono(c_power=2), mono(c_power=4)
    new_formula = add(
        scale(power(add(v, c2), 2), 3),
        scale(add(q, c4), -2),
        scale(add(d, mul(c2, delta)), -1),
    )
    old_plus_increment = add(
        scale(power(v, 2), 3), scale(q, -2), scale(d, -1),
        scale(mul(c2, v), 6), c4, scale(mul(c2, delta), -1),
    )
    require(normal(new_formula, sorted_tuple) == normal(old_plus_increment, sorted_tuple),
            "Universal finite-prefix recurrence failed")
    return 7


def sorted_tuple(word):
    return tuple(sorted(word))


def check_universal_inequalities(certificate):
    data = certificate["universal_inequalities"]
    y = mono(c_power=1)
    one = mono()
    x = add(one, y)
    first = add(power(x, 4), scale(y, -1))
    second = add(power(x, 4), scale(power(x, 2), -1), one)
    fourth = add(power(x, 4), scale(one, -1))
    for name, polynomial in (("first", first), ("second", second), ("fourth", fourth)):
        coefficients = scalar_coefficients(polynomial, 4)
        require(coefficients == data[f"{name}_tail_nonnegative_coefficients"],
                f"Incorrect {name} clipping-tail polynomial")
        require(all(Q(value) >= 0 for value in coefficients),
                f"The {name} clipping polynomial is not certified on y >= 0")

    u = y
    variance = add(u, scale(power(u, 2), -1))
    partition_gap = add(mono(coefficient=Q(1, 16)), scale(power(variance, 2), -1))
    factors = mul(
        power(add(u, mono(coefficient=Q(-1, 2))), 2),
        add(mono(coefficient=Q(1, 4)), variance),
    )
    require(partition_gap == factors, "Gaussian partition defect factorization failed")
    one_step = list(map(Q, data["clt_one_step_decay_exponents"]))
    summed = list(map(Q, data["clt_summed_decay_exponents"]))
    require([value - 1 for value in one_step] == summed and min(summed) > 0,
            "The conditional CLT errors do not decay after summation")

    constants = {key: Q(value) for key, value in certificate["proof_constants"].items()}
    require(constants == {
        "averaged_square_error": Q(3),
        "replacement_square_error": 4 * Q(1) + 2,
        "combined_square_error": 2 * Q(3) + 2 * Q(6),
        "commutator_square_error": 4 * Q(18),
        "fourth_moment": Q(3),
        "moving_corner_error": 2 * Q(1, 16) + Q(1, 8),
        "single_run_progress": 1 - Q(1, 4) - Q(1, 4),
        "corner_symmetry_error_fraction": 3 * Q(1, 8),
        "gaussian_partition_defect": 1 + Q(1, 16),
    }, "A displayed dimension-independent proof constant is inconsistent")
    require(Q(1, 2) > Q(1, 4) and Q(3, 8) < 1,
            "Strict margins in the centering construction failed")
    return 6


def matrix_mul(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(2))
                       for j in range(2)) for i in range(2))


def matrix_add(a, b, weight=1):
    return tuple(tuple(a[i][j] + weight * b[i][j] for j in range(2)) for i in range(2))


def matrix_scale(a, weight):
    return tuple(tuple(weight * value for value in row) for row in a)


def matrix_adjoint(a):
    return tuple(tuple(a[j][i] for j in range(2)) for i in range(2))


def normalized_trace(a):
    return (a[0][0] + a[1][1]) / 2


def check_example_and_jacobian(certificate):
    data = certificate["rational_example"]
    r1 = tuple(tuple(map(Q, row)) for row in data["r1"])
    r2 = tuple(tuple(map(Q, row)) for row in data["r2"])
    c1, c2 = Q(data["c1"]), Q(data["c2"])
    identity = ((Q(1), Q(0)), (Q(0), Q(1)))
    zero = matrix_scale(identity, 0)
    require(matrix_mul(r1, r1) == matrix_mul(r2, r2) == identity,
            "Example matrices are not involutions")
    require(matrix_adjoint(r1) == r1 and matrix_adjoint(r2) == r2,
            "Example matrices are not selfadjoint")
    require(matrix_add(matrix_mul(r1, r2), matrix_mul(r2, r1)) == zero,
            "The ancillary example must actually be noncommuting")
    require(normalized_trace(r1) == normalized_trace(r2) == 0 and
            normalized_trace(matrix_mul(r1, r2)) == 0,
            "Successive centering failed on the prior generated algebra")
    require(c1 * c1 + c2 * c2 == 1 and Q(data["trace_normalization"]) == Q(1, 2),
            "Incorrect example normalization")
    z = matrix_add(matrix_scale(r1, c1), matrix_scale(r2, c2))
    require(matrix_mul(z, z) == identity, "The ancillary z is not a symmetry")
    x = matrix_scale(r1, c1)
    commutator = matrix_add(matrix_mul(x, r2), matrix_mul(r2, x), -1)
    deficit = c2 ** 2 * normalized_trace(matrix_mul(matrix_adjoint(commutator), commutator))
    baseline = 3 - 2 * (c1 ** 4 + c2 ** 4)
    fourth = normalized_trace(matrix_mul(matrix_mul(z, z), matrix_mul(z, z)))
    require(fourth == baseline - deficit, "Exact noncommuting deficit failed")
    require([str(fourth), str(baseline), str(deficit)] ==
            [data["fourth_moment"], data["baseline"], data["commutator_deficit"]],
            "Serialized rational example disagrees")

    payload = json.loads((ROOT / data["jacobian_payload"]).read_text())
    response = json.loads((ROOT / data["jacobian_output"]).read_text())
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    operation = data["jacobian_operation"]
    require(response["request"]["operation_id"] == operation and
            response["result"]["operation_id"] == operation,
            "Wrong Jacobian operation")
    require(response["server"]["version"] == "0.14.0" and
            response["protocol_version"] == "2025-11-25",
            "Unexpected archived Jacobian server or protocol")
    require(data["jacobian_adapter_exit_code"] == 0 and
            not data["jacobian_timeout"] and data["jacobian_structured_error"] is None,
            "A failed/unknown adapter call cannot be treated as evidence")
    output = response["result"]["output"]
    require(output["outcome"] == "VALID" and output["valid_complete_rational_spectrum"],
            "The exact spectrum was not established")
    require(output["matrix"] == payload["matrix"] and output["matrix_order"] == 2,
            "Jacobian checked a different matrix")
    require(output["claimed_profile"] == payload["claimed_profile"] and
            output["claimed_multiplicity_sum"] == output["established_multiplicity_sum"] == 2,
            "Jacobian checked a different or incomplete spectrum claim")
    require(len(output["nullity_ledger"]) == 2 and
            all(item["exact_nullity"] == item["claimed_multiplicity"] == 1 and
                item["multiplicity_matches"] for item in output["nullity_ledger"]),
            "Jacobian did not establish both exact nullities")
    materialized = tuple(tuple(Q(int(entry["num"]), int(entry["den"])) for entry in row)
                         for row in payload["matrix"]["entries"])
    require(materialized == z, "The adapter matrix is not the example observable")
    eigenvalues = {
        Q(int(item["eigenvalue"]["num"]), int(item["eigenvalue"]["den"])): item["multiplicity"]
        for item in payload["claimed_profile"]
    }
    require(eigenvalues == {Q(-1): 1, Q(1): 1}, "Wrong claimed spectrum")
    for eigenvalue in eigenvalues:
        shifted = matrix_add(z, matrix_scale(identity, -eigenvalue))
        determinant = shifted[0][0] * shifted[1][1] - shifted[0][1] * shifted[1][0]
        require(determinant == 0 and shifted != zero, "Exact eigenvalue nullity is not one")
    return 2


def check_fresh_lean(certificate):
    scope = certificate["evidence_scope"]
    record = json.loads((ROOT / scope["lean_certificate"]).read_text())
    check = record["lean_check"]
    source = (ROOT / scope["formal_source"]).read_text()
    fidelity = (ROOT / scope["statement_fidelity"]).read_text()
    require(record["subject"]["subject_id"] == scope["formal_claim"] and
            record["tier"] == "mechanical" and record["verdict"] == "supports",
            "No supporting mechanical Lean evidence")
    require(check["exit_code"] == 0 and check["proof_holes"] == [] and
            check["audit_exit_code"] == 0 and check["status"] == "success",
            "The real compiler run is not successful and hole-free")
    require("4.31.0" in check["tools"]["lean"]["version"], "Wrong Lean version")
    require(record["lean_source"]["text"] == source and
            record["statement_fidelity"]["text"] == fidelity,
            "The certificate describes different source or statement fidelity")
    require(hashlib.sha256(source.encode()).hexdigest() == check["source_sha256"] and
            hashlib.sha256(fidelity.encode()).hexdigest() == check["statement_fidelity_sha256"],
            "The compiler evidence is stale")
    claims = json.loads((ROOT / "research/MATH_STATE.json").read_text())["claims"]
    matching = [claim for claim in claims if claim["claim_id"] == scope["formal_claim"]]
    require(bool(matching), "The formal claim is missing from the ledger")
    latest_version = max(claim["version"] for claim in matching)
    current = [claim for claim in matching if claim["version"] == latest_version]
    require(len(current) == 1 and current[0]["content_hash"] == record["subject"]["content_hash"],
            "The Lean evidence is bound to an obsolete or ambiguous claim")
    require(not scope["analytic_theorem_kernel_verified"] and
            not scope["finite_search_is_theorem_evidence"],
            "The evidence scope overstates the compiler result")
    return check["exit_code"]


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    universal_checks = check_universal_algebra(certificate)
    universal_checks += check_universal_inequalities(certificate)
    ancillary_checks = check_example_and_jacobian(certificate)
    lean_exit = check_fresh_lean(certificate)
    print(json.dumps({
        "status": "PASS",
        "universal_algebra_and_inequality_checks": universal_checks,
        "ancillary_exact_example_checks": ancillary_checks,
        "lean_exit_code": lean_exit,
        "proof_holes": [],
        "analytic_theorem_kernel_verified": False,
        "independent_review": certificate["independent_review"]["status"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
