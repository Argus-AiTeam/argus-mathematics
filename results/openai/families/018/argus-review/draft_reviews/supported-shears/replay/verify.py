#!/usr/bin/env python3
"""Replay universal identities and the fresh Lean record, not finite evidence."""

import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OPERATION = "matrix.symbolic.multiply.compute"


def symbolic_checks():
    checks = []

    def equal(name, left, right):
        if isinstance(left, sp.MatrixBase):
            assert left.shape == right.shape, name
            differences = list(left - right)
        else:
            differences = [left - right]
        for difference in differences:
            numerator, _ = sp.cancel(difference).as_numer_denom()
            assert numerator == 0, f"{name}: nonzero numerator {numerator}"
        checks.append({"id": name, "kind": "universal_localized_identity"})

    def multiply(*matrices):
        result = matrices[0]
        for matrix in matrices[1:]:
            result = (result * matrix).applyfunc(sp.cancel)
        return result

    def upper(x):
        return sp.Matrix([[1, x], [0, 1]])

    def lower(x):
        return sp.Matrix([[1, 0], [x, 1]])

    a, b, c, d, x, y, z, t = sp.symbols("a b c d x y z t")
    delta = a * d - b * c
    g = sp.Matrix([[a, b], [c, d]])
    gi = sp.Matrix([[d, -b], [-c, a]]) / delta
    equal("inverse_matrix", multiply(g, gi), sp.eye(2))

    def phase_comm(v):
        return multiply(sp.diag(v, 1), g, sp.diag(1 / v, 1), gi)

    def phase_comm_inverse(v):
        return multiply(g, sp.diag(v, 1), gi, sp.diag(1 / v, 1))

    double = multiply(
        phase_comm(x), phase_comm(y),
        phase_comm_inverse(x), phase_comm_inverse(y),
    )
    expected = (
        b * c**2 * d * (x - 1) * (x - y) * (y - 1)
        * (a * d * x * y - a * d * x - a * d * y + b * c)
        / (x**2 * y**2 * delta**3)
    )
    equal("kernel_double_commutator", double[1, 0], expected)
    equal(
        "triangular_phase_commutator",
        phase_comm(x).subs(c, 0),
        upper((x - 1) * b / d),
    )
    equal("triangular_double_commutator", double.subs(c, 0), sp.eye(2))
    cubic = a * d * x**3 - a * d * x**2 - a * d * x + b * c
    assert sp.Poly(cubic, x).degree() == 3
    assert sp.Poly(cubic, x).LC() == a * d
    equal(
        "five_exception_kernel_factor",
        expected.subs(y, x**2),
        b * c**2 * d * (x - 1) * (x - x**2) * (x**2 - 1)
        * cubic / (x**6 * delta**3),
    )
    checks.append({
        "id": "nonvanishing_kernel_polynomial",
        "kind": "symbolic_degree",
        "degree": 3,
        "leading_coefficient": "a*d",
        "phase_exception_bound": sp.Poly(cubic, x).degree() + 2,
        "requires": "a*d != 0; x is a nonzero phase outside at most five roots",
    })

    def inverse_word(word):
        return [(letter, -sign) for letter, sign in reversed(word)]

    def commutator_word(first, second):
        return first + second + inverse_word(first) + inverse_word(second)

    separator_word = [("Bhpzp", -1), ("Bhp", -1), ("B1", 1), ("Bz", 1)]
    kernel_word = commutator_word(
        commutator_word([("Dx", 1)], separator_word),
        commutator_word([("Dx2", 1)], separator_word),
    )
    checks.append({
        "id": "kernel_witness_word_bound",
        "kind": "exact_word_length_upper_bound",
        "boost_separator_length": len(separator_word),
        "kernel_word_length": len(kernel_word),
        "counts": "Boosts and simultaneous diagonal phases are generators; cancellation can only shorten the word.",
    })

    denominator = (1 + a * b - 2 * a) * z + b - a
    zp = ((a - b) * z + 1 + a * b - 2 * b) / denominator
    hp = (a - 1) * (b + z) / ((b - 1) * (a * z + 1))
    exceptional = (a * b - 2 * a + 1) * z - a * b + 2 * b - 1

    def conjugate(expression):
        return expression.xreplace({a: b, b: a, z: 1 / z})

    ell = lambda v: (1 + v)**2 / ((1 + a * v) * (v + b))
    equal("other_fiber_norm", zp * conjugate(zp), sp.Integer(1))
    equal("slope_ratio_norm", hp * conjugate(hp), sp.Integer(1))
    equal("same_norm_fiber", ell(zp), ell(z))
    equal(
        "simplified_slope_ratio",
        hp,
        (1 + z) * (1 + a * zp) / ((1 + a * z) * (1 + zp)),
    )
    equal("branch_gap", zp - z, -(z + 1) * exceptional / denominator)
    equal(
        "odd_characteristic_branch_coefficients",
        sp.Poly(exceptional, z).coeff_monomial(z)
        + sp.Poly(exceptional, z).coeff_monomial(1),
        2 * (b - a),
    )
    assert sp.Poly(
        exceptional - (a * b + 1) * (z + 1), a, b, z, modulus=2,
    ).is_zero
    derivative = (a * b + 1) * (1 + z)**2 / (
        (1 + a * z)**2 * (z + b)**2
    )
    derivative_difference = sp.cancel(sp.diff(ell(z), z) - derivative)
    derivative_numerator = derivative_difference.as_numer_denom()[0]
    assert sp.Poly(derivative_numerator, a, b, z, modulus=2).is_zero
    checks.append({
        "id": "characteristic_two_branch_restriction",
        "kind": "exact_polynomial_reduction",
        "restriction": "a*b != 1",
        "excluded_boundary": "a*b=1 makes the degree-two map inseparable",
    })

    def boost_pair(h, v):
        return sp.Matrix([
            [1 + t * v, t * (1 + 1 / v) / h],
            [h * (1 + v), 1 + t / v],
        ])

    def boost_pair_inverse(h, v):
        return sp.Matrix([
            [1 + t / v, -t * (1 + 1 / v) / h],
            [-h * (1 + v), 1 + t * v],
        ]) / (1 - t)**2

    equal(
        "boost_pair_inverse",
        multiply(boost_pair(hp, zp), boost_pair_inverse(hp, zp)),
        sp.eye(2),
    )
    triangular = boost_pair_inverse(hp, zp) * boost_pair(sp.Integer(1), z)
    lower_entry = (
        -(t - a) * (z + 1)**2 * exceptional
        / ((t - 1)**2 * (a * z + 1) * denominator)
    )
    equal("triangular_separator_entry", triangular[1, 0], lower_entry)
    equal(
        "opposite_separator_entry",
        triangular[0, 1],
        t * conjugate(lower_entry),
    )
    equal("separator_regular_identity_value", triangular.subs(z, -1), sp.eye(2))

    u, s = sp.symbols("u s")
    r = a / c
    translation = (1 - u**2) * r
    h = sp.Matrix([[u, translation / u], [0, 1 / u]])
    hi = sp.Matrix([[1 / u, -translation / u], [0, u]])
    q = multiply(hi, gi, h, g)
    q12 = (1 - u**2) * (d - a * u**2) / (u**2 * c)
    equal("normalizing_commutator", q, sp.Matrix([[u**-2, q12], [0, u**2]]))
    qi = sp.Matrix([[u**2, -q12], [0, u**-2]])
    equal(
        "normal_shear_extraction",
        multiply(q, upper(x), qi, upper(-x)),
        upper((u**-4 - 1) * x),
    )
    v = 1 + s * t
    equal(
        "four_shear_diagonal",
        multiply(upper(s), lower(t), upper(-s / v), lower(-t * v)),
        sp.diag(v, 1 / v),
    )
    equal(
        "opposite_root_intersection",
        multiply(upper(x), lower(y), upper(-x), lower(-y))[1, 0],
        x * y**2,
    )
    xb = sp.symbols("xb")
    phase = x / xb
    shifted_phase = (x + 1) / (xb + 1)
    equal(
        "phase_field_recovery",
        (1 - shifted_phase) / (shifted_phase - phase),
        xb,
    )
    cc, r0, r1, w = sp.symbols("cc r0 r1 w")
    congruence_unit = 1 + cc**2 * r1 * w
    equal(
        "congruence_ideal_coefficients",
        (1 - congruence_unit**2) * r0 / r1,
        -cc**2 * w * r0 * (2 + cc**2 * r1 * w),
    )
    return checks


def jacobian_check():
    payload = json.loads((HERE / "jacobian_polynomial_payload.json").read_text())
    output = json.loads((HERE / "jacobian_polynomial_output.json").read_text())
    failure = json.loads((HERE / "jacobian_output.json").read_text())
    assert failure["ok"] is False
    assert failure["error"]["data"]["stage"] == "operation_validation"
    assert failure["error"]["data"]["errors"][0]["code"] == "matrix.budget_exceeded"
    assert output["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == "2025-11-25"
    assert output["transport"] == "mcp-stdio"
    assert output["request"]["operation_id"] == OPERATION
    assert output["request"]["payload"] == payload
    assert output["result"]["operation_id"] == OPERATION
    s, t = sp.symbols("s t")

    def rational_function(value):
        assert value["variables"] == ["s", "t"]

        def polynomial(part):
            result = sp.Integer(0)
            for term in part["terms"]:
                coefficient = term["coefficient"]
                result += sp.Rational(coefficient["num"], coefficient["den"]) * (
                    s**term["exponents"][0] * t**term["exponents"][1]
                )
            return result

        denominator = polynomial(value["denominator"])
        assert denominator != 0
        return polynomial(value["numerator"]) / denominator

    typed = output["result"]["output"]
    assert typed["variables"] == ["s", "t"]
    matrix = sp.Matrix([
        [rational_function(value) for value in row]
        for row in typed["entries"]
    ])
    target = sp.diag((1 + s * t)**2, 1)
    assert all(sp.cancel(entry) == 0 for entry in matrix - target)
    return {
        "id": "jacobian_typed_replay",
        "kind": "exact_typed_output",
        "operation_id": OPERATION,
        "first_request": "validation_refused_not_a_mathematical_verdict",
        "polynomial_request": "success",
    }


def lean_check():
    result = json.loads((HERE / "lean_check.json").read_text())
    assert result["status"] == "success"
    assert result["exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["source_sha256"] == hashlib.sha256(
        (HERE / "Main.lean").read_bytes()
    ).hexdigest(), "Lean source changed after compilation"
    fidelity = (HERE / "statement_fidelity.md").read_text()
    assert result["statement_fidelity_sha256"] == hashlib.sha256(
        fidelity.encode("utf-8")
    ).hexdigest(), "Statement fidelity changed after compilation"
    return {
        "id": "lean_formal_core",
        "kind": "fresh_compiler_record",
        "exit_code": 0,
        "proof_holes": [],
        "statement_fidelity": "statement_fidelity.md",
        "arithmetic_inputs": "not_formalized",
    }


def main():
    certificate_path = HERE / "exact_certificate.json"
    certificate = json.loads(certificate_path.read_text())
    checks = symbolic_checks() + [jacobian_check(), lean_check()]
    assert {check["id"] for check in checks} == set(certificate["required_checks"])
    by_id = {check["id"]: check for check in checks}
    assert certificate["normal_kernel_word_length_at_most"] == (
        by_id["kernel_witness_word_bound"]["kernel_word_length"]
    )
    assert certificate["forbidden_phase_values_at_most"] == (
        by_id["nonvanishing_kernel_polynomial"]["phase_exception_bound"]
    )
    certificate["verification"] = {
        "status": "passed",
        "checks": checks,
        "independent_review": "required_not_claimed",
        "novelty": "not_certified_by_this_program",
        "arithmetic_citations": "not_certified_by_this_program",
    }
    certificate_path.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "status": "passed",
        "universal_checks": len(checks),
        "certificate": str(certificate_path),
        "independent_review": "required",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
