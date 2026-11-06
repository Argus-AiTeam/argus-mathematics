#!/usr/bin/env python3
"""Exact support for the prose algebraization proof, not a proof of existence."""

from __future__ import annotations

import argparse
import copy
import itertools
import json
import re
import sys
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OPERATION = "matrix.symbolic.multiply.compute"
SCOPE = "exact_symbolic_support_only; general_theorem_requires_report_and_sources"


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def expression(value):
    return sp.sstr(sp.expand(sp.cancel(value)))


def entries(matrix):
    return [[expression(matrix[i, j]) for j in range(matrix.cols)]
            for i in range(matrix.rows)]


def derive():
    alpha, beta, ell, delta, n, N = sp.symbols("alpha beta ell delta n N")
    c0 = beta + ell
    c = c0 + delta
    q = n - c
    constraints = {
        "relation_threshold": N - alpha - 1,
        "equation_relation_threshold": n - c - N,
        "coordinate_threshold": n - c - 2,
        "quadratic_threshold": n - 2 * c - 1,
        "alpha_nonnegative": alpha,
        "beta_nonnegative": beta,
        "ell_nonnegative": ell,
        "delta_nonnegative": delta,
        "one": sp.Integer(1),
    }
    targets = {
        "epsilon_improves": n + N - alpha - (n + 1),
        "fixed_relation_precision": q - N,
        "identity_linear_part": q - 2,
        "quadratic_remainder_improves": 2 * q - (n + 1),
        "error_substitution_improves": n + q - 1 - (n + 1),
        "image_artin_rees_applicable": n + N - alpha,
        "kernel_artin_rees_applicable": n - beta,
        "finite_length_factor_available": n - beta - ell,
        "ideal_artin_rees_applicable": n - c0 - delta,
        "derivative_coefficients_at_least_q": n - c0 - q,
        "generator_change_in_maximal_ideal": q - 1,
        "relation_precision_positive": N - 1,
        "successive_correction_orders_increase": (n + 1 - c) - q,
    }
    result = {
        "constants": {
            "c0": expression(c0),
            "c": expression(c),
            "N_minimum": expression(alpha + 1),
            "n0_lower_bounds": [expression(c + N), expression(c + 2),
                                expression(2 * c + 1)],
        },
        "orders": {
            "relation_error": expression(n + N),
            "epsilon": expression(n + N - alpha),
            "derivative_coefficients": expression(n - c0),
            "ideal_remainder": expression(n - c0),
            "generator_coefficients": expression(n - c0 - delta),
            "quadratic_taylor_remainder": expression(2 * q),
            "error_substitution_remainder": expression(n + q - 1),
        },
        "nonnegative_constraints": {
            key: expression(value) for key, value in constraints.items()
        },
        "order_slacks": {
            key: expression(value) for key, value in targets.items()
        },
    }

    r, k, Q, u, v, w0, z0, qslack = sp.symbols("r k Q u v w0 z0 qslack")
    quadratic = sp.expand((r - k + k * Q - 2 * Q).subs(
        {r: u + v + 2, k: v + 2, Q: qslack + 2}, simultaneous=True))
    high_error = sp.expand((r - k + k * Q - (n + Q - 1)).subs(
        {r: n + w0, k: z0 + 1, Q: qslack + 2}, simultaneous=True))
    result["monomial_bounds"] = {
        "quadratic_slack": expression(quadratic),
        "high_error_slack": expression(high_error),
        "quadratic_nonnegative_coefficients":
            all(a >= 0 for a in sp.Poly(quadratic, u, v, qslack).coeffs()),
        "high_error_nonnegative_coefficients":
            all(a >= 0 for a in sp.Poly(high_error, w0, z0, qslack).coeffs()),
    }

    a, b, cc, d = sp.symbols("a b c d")
    C = sp.Matrix([[a, b], [cc, d]])
    K = sp.eye(2) + C
    adjugate = K.adjugate()
    inverse = K.inv()
    row = sp.Matrix(1, 2, sp.symbols("g0 g1"))
    B = sp.Matrix(2, 1, sp.symbols("b0 b1"))
    D = sp.Matrix(2, 1, sp.symbols("d0 d1"))
    f = sp.Matrix(1, 2, sp.symbols("f0 f1"))
    derivative = sp.Matrix(1, 2, sp.symbols("r0 r1"))
    epsilon = sp.Matrix(1, 2, sp.symbols("e0 e1"))
    h = derivative + f * C + epsilon
    U = sp.Matrix(2, 2, sp.symbols("u00 u01 u10 u11"))
    t = sp.Symbol("t")
    wrong_K = sp.diag(1 + t, 1)
    wrong_row = sp.Matrix([[1, -1]]) * wrong_K.inv()
    wrong_B = wrong_K.inv() * sp.Matrix([1, 1])
    wrong_numerator, wrong_denominator = sp.fraction(
        sp.cancel((wrong_row * wrong_B)[0]))
    result["matrix_identities"] = {
        "determinant": expression(K.det()),
        "adjugate_product": entries(K * adjugate),
        "inverse_left_residual": entries(inverse * K - sp.eye(2)),
        "inverse_right_residual": entries(K * inverse - sp.eye(2)),
        "linear_correction_remainder": entries(f + h - derivative - f * K),
        "transformed_relation_residual":
            entries((row * inverse) * (K * B) - row * B),
        "reduced_relation_factorization":
            entries(row * D + row * (B - D) - row * B),
        "cumulative_right_update":
            entries((row * U) * inverse - row * (U * inverse)),
        "wrong_inverse_relation_numerator": expression(wrong_numerator),
        "wrong_inverse_relation_denominator": expression(wrong_denominator),
    }

    # Independent first-jet symbols retain the generator-derivative term.
    e, s = 4, 3
    coordinate_jacobian = sp.Matrix(
        e, e, lambda i, j: sp.Symbol(f"A{i}{j}"))
    equation_jacobian = sp.Matrix(
        e, s, lambda i, j: sp.Symbol(f"G{i}{j}"))
    generator = sp.Matrix(s, s, lambda i, j: sp.Symbol(f"U{i}{j}"))
    values = sp.Matrix(1, s, sp.symbols("v0:3"))
    generator_derivatives = [
        sp.Matrix(s, s, lambda i, j: sp.Symbol(f"H{axis}{i}{j}"))
        for axis in range(e)
    ]
    direct = sp.Matrix(e, s, lambda axis, col: sum(
        sum(equation_jacobian[j, l] * coordinate_jacobian[axis, j]
            for j in range(e)) * generator[l, col]
        + values[l] * generator_derivatives[axis][l, col]
        for l in range(s)))
    generator_term = sp.Matrix(
        e, s, lambda axis, col: (values * generator_derivatives[axis])[col])
    chain_product = coordinate_jacobian * equation_jacobian * generator
    result["finite_jacobian"] = {
        "arity": [e, s],
        "chain_rule_residual": entries(direct - chain_product - generator_term),
        "mod_equations_residual": entries(
            (direct - chain_product).subs({value: 0 for value in values})),
        "first_generator_derivative_term": expression(generator_term[0, 0]),
        "generator_term_zero_before_quotient": generator_term == sp.zeros(e, s),
    }
    left = sp.Matrix(2, 3, sp.symbols("l0:6"))
    right = sp.Matrix(3, 2, sp.symbols("r0:6"))
    minor_sum = sum(left[:, cols].det() * right[list(cols), :].det()
                    for cols in itertools.combinations(range(3), 2))
    result["finite_jacobian"]["cauchy_binet_residual"] = expression(
        (left * right).det() - minor_sum)

    x, y, z, w, H, uu, vv = sp.symbols("x y z w H u v")
    cone = sp.Matrix([[x * z - y**2, x * w - y * z, y * w - z**2]])
    relations = sp.Matrix([[z, w], [-y, -z], [x, y]])
    perturbed = cone + sp.Matrix([[0, 0, H]])
    param = {x: uu**3, y: uu**2 * vv, z: uu * vv**2, w: vv**3}
    signed_minors = sp.Matrix([[
        relations[[1, 2], :].det(),
        -relations[[0, 2], :].det(),
        relations[[0, 1], :].det(),
    ]])
    jacobian = cone.jacobian([x, y, z, w]).T
    result["equations_only_obstruction"] = {
        "original_relations": entries(cone * relations),
        "signed_minors": entries(signed_minors),
        "signed_minor_residual": entries(signed_minors - cone),
        "parametrization_residual": entries(cone.subs(param, simultaneous=True)),
        "perturbed_relations": entries(perturbed * relations),
        "elimination_identity": expression(
            z * perturbed[0] - y * perturbed[1] + x * perturbed[2]),
        "jacobian_minors": [
            expression(jacobian[[2, 3], [0, 1]].det()),
            expression(jacobian[[0, 1], [1, 2]].det()),
        ],
        "power_after_H_equals_x_to_k": expression(k + sp.degree(x, x)),
    }
    numerator, denominator, dn, dd = sp.symbols("a0 s0 da0 ds0")
    quotient_derivative = (denominator * dn - numerator * dd) / denominator**2
    result["localization_leibniz_residual"] = expression(
        denominator * quotient_derivative + numerator / denominator * dd - dn)
    return result, constraints, targets


def compare(expected, actual, path):
    require(type(expected) is type(actual), f"{path}: wrong value type")
    if isinstance(actual, dict):
        require(expected.keys() == actual.keys(), f"{path}: assertion keys differ")
        return sum(compare(expected[key], actual[key], f"{path}.{key}")
                   for key in actual)
    if isinstance(actual, list):
        require(len(expected) == len(actual), f"{path}: wrong list length")
        return sum(compare(a, b, f"{path}[{i}]")
                   for i, (a, b) in enumerate(zip(expected, actual)))
    require(expected == actual,
            f"{path}: asserted {expected!r}, derived {actual!r}")
    return 1


def verify_assertions(certificate, derived, constraints, targets):
    require(isinstance(certificate, dict), "certificate: must be an object")
    require(set(certificate) == {
        "schema_version", "scope", "derived", "inequality_witnesses"
    }, "certificate: unexpected or missing fields")
    require(type(certificate["schema_version"]) is int
            and certificate["schema_version"] == 1, "schema_version: must be 1")
    require(certificate["scope"] == SCOPE, "scope: unsupported theorem claim")
    count = compare(certificate["derived"], derived, "derived")
    witnesses = certificate["inequality_witnesses"]
    require(isinstance(witnesses, dict) and witnesses.keys() == targets.keys(),
            "inequality_witnesses: missing or additional inequality")
    for name, target in targets.items():
        witness = witnesses[name]
        require(isinstance(witness, dict) and witness,
                f"inequality_witnesses.{name}: empty or invalid witness")
        value = sp.Integer(0)
        for key, coefficient in witness.items():
            require(key in constraints, f"inequality_witnesses.{name}: unknown constraint")
            require(type(coefficient) is int and coefficient >= 0,
                    f"inequality_witnesses.{name}: coefficient is not nonnegative")
            value += coefficient * constraints[key]
        require(sp.expand(target - value) == 0,
                f"inequality_witnesses.{name}: nonnegative combination is not the slack")
    return count, len(targets)


def typed_polynomial(data, variables, path):
    require(isinstance(data, dict) and set(data) == {"terms"},
            f"{path}: invalid sparse polynomial")
    terms = data["terms"]
    require(isinstance(terms, list), f"{path}: terms must be a list")
    previous = None
    value = sp.Integer(0)
    for index, term in enumerate(terms):
        label = f"{path}.terms[{index}]"
        require(isinstance(term, dict) and set(term) == {"coefficient", "exponents"},
                f"{label}: invalid term")
        powers = term["exponents"]
        require(isinstance(powers, list) and len(powers) == len(variables)
                and all(type(p) is int and p >= 0 for p in powers),
                f"{label}: invalid exponents")
        powers = tuple(powers)
        require(previous is None or powers < previous,
                f"{label}: repeated or noncanonical monomial order")
        previous = powers
        coefficient = term["coefficient"]
        require(isinstance(coefficient, dict) and set(coefficient) == {"num", "den"},
                f"{label}: invalid coefficient")
        num, den = coefficient["num"], coefficient["den"]
        require(isinstance(num, str) and isinstance(den, str)
                and re.fullmatch(r"-?[1-9][0-9]*", num)
                and re.fullmatch(r"[1-9][0-9]*", den),
                f"{label}: noncanonical or zero coefficient")
        rational = Fraction(int(num), int(den))
        require(str(rational.numerator) == num and str(rational.denominator) == den,
                f"{label}: coefficient not reduced")
        value += sp.Rational(rational.numerator, rational.denominator) * sp.prod(
            symbol**power for symbol, power in zip(variables, powers))
    return value


def typed_matrix(data, variables, path):
    names = [str(v) for v in variables]
    require(isinstance(data, dict) and set(data) == {"variables", "entries"}
            and data["variables"] == names, f"{path}: invalid matrix field")
    rows = data["entries"]
    require(isinstance(rows, list) and 1 <= len(rows) <= 8
            and all(isinstance(row, list) for row in rows),
            f"{path}: invalid rows")
    width = len(rows[0])
    require(1 <= width <= 8 and all(len(row) == width for row in rows),
            f"{path}: invalid dimensions")
    values = []
    for i, row in enumerate(rows):
        for j, entry in enumerate(row):
            label = f"{path}[{i},{j}]"
            require(isinstance(entry, dict)
                    and set(entry) == {"domain", "variables", "numerator", "denominator"}
                    and entry["domain"] == "QQ" and entry["variables"] == names,
                    f"{label}: invalid rational-function field")
            top = typed_polynomial(entry["numerator"], variables, label + ".numerator")
            bottom = typed_polynomial(entry["denominator"], variables, label + ".denominator")
            require(bottom != 0, f"{label}: zero denominator")
            require(sp.Poly(bottom, *variables, domain=sp.QQ).LC() == 1,
                    f"{label}: denominator not monic")
            require(sp.Poly(sp.gcd(top, bottom), *variables).total_degree() == 0,
                    f"{label}: fraction not reduced")
            values.append(top / bottom)
    return sp.Matrix(len(rows), width, values)


def read_json(path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def verify_jacobian():
    payload = read_json(HERE / "jacobian_payload.json")
    response = read_json(HERE / "jacobian_output.json")
    run = read_json(HERE / "jacobian_run.json")
    contract = read_json(HERE / "jacobian_contract.json")
    require(run["adapter_exit_code"] == 0 and run["timeout"] is False
            and run["status"] == "returned" and run["structured_error"] is None
            and run["adapter_stderr"] == "", "jacobian: adapter did not complete cleanly")
    require(response["schema_version"] == 1 and response["tool"] == "math.run",
            "jacobian: wrong response envelope")
    require(response["request"] == {"operation_id": OPERATION, "payload": payload},
            "jacobian: exact payload echo differs")
    require(response["result"]["operation_id"] == OPERATION
            and run["operation_id"] == OPERATION and contract["operation_id"] == OPERATION,
            "jacobian: operation differs")
    require(response["server"] == run["server"]
            and response["server"]["version"] == contract["inspected_server_version"],
            "jacobian: server version differs from inspected contract")
    require(response["protocol_version"] == run["protocol_version"]
            == contract["inspected_protocol_version"], "jacobian: protocol differs")
    require(type(response["result"]["runtime_ms"]) is int
            and response["result"]["runtime_ms"] >= 0, "jacobian: invalid runtime")
    a, b, c, d = variables = sp.symbols("a b c d")
    left = typed_matrix(payload["left"], variables, "payload.left")
    right = typed_matrix(payload["right"], variables, "payload.right")
    actual = typed_matrix(response["result"]["output"], variables, "output")
    expected_left = sp.Matrix([[1 + a, b], [c, 1 + d]])
    require(left == expected_left and right == expected_left.adjugate(),
            "jacobian: payload does not encode the stated generic adjugate product")
    require(actual == sp.expand(left * right), "jacobian: returned product is incorrect")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": run["adapter_exit_code"],
        "timeout": run["timeout"],
        "structured_error": run["structured_error"],
        "runtime_ms": response["result"]["runtime_ms"],
        "product": entries(actual),
        "offline_exact_replay": True,
    }


def negative_controls(certificate, derived, constraints, targets):
    changes = [
        (("derived", "constants", "c"), "beta + ell"),
        (("derived", "constants", "N_minimum"), "alpha"),
        (("derived", "orders", "relation_error"), "N"),
        (("derived", "orders", "ideal_remainder"), "n"),
        (("derived", "orders", "generator_coefficients"), "-beta - ell + n"),
        (("derived", "monomial_bounds", "quadratic_slack"), "0"),
        (("derived", "matrix_identities", "determinant"), "a*d + a + b*c + d + 1"),
        (("derived", "matrix_identities", "linear_correction_remainder", 0, 0), "-e0"),
        (("derived", "matrix_identities", "transformed_relation_residual", 0, 0), "1"),
        (("derived", "matrix_identities", "wrong_inverse_relation_numerator"), "0"),
        (("derived", "finite_jacobian", "chain_rule_residual", 0, 0), "1"),
        (("derived", "finite_jacobian", "generator_term_zero_before_quotient"), True),
        (("derived", "finite_jacobian", "cauchy_binet_residual"), "1"),
        (("derived", "equations_only_obstruction", "perturbed_relations", 0, 0), "0"),
        (("derived", "equations_only_obstruction", "jacobian_minors", 0), "x"),
        (("inequality_witnesses", "epsilon_improves"), {"one": 1}),
        (("inequality_witnesses", "quadratic_remainder_improves"),
         {"quadratic_threshold": -1}),
        (("scope",), "the_general_algebraization_theorem_is_kernel_verified"),
    ]
    rejected = []
    for path, replacement in changes:
        corrupted = copy.deepcopy(certificate)
        cursor = corrupted
        for key in path[:-1]:
            cursor = cursor[key]
        cursor[path[-1]] = replacement
        try:
            verify_assertions(corrupted, derived, constraints, targets)
        except VerificationError as error:
            rejected.append({"path": ".".join(map(str, path)), "reason": str(error)})
        else:
            raise VerificationError(f"negative control accepted: {path}")
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=HERE / "exact_certificate.json")
    parser.add_argument("--negative-controls", action="store_true")
    args = parser.parse_args()
    try:
        certificate = read_json(args.certificate)
        derived, constraints, targets = derive()
        assertions, inequalities = verify_assertions(certificate, derived, constraints, targets)
        jacobian = verify_jacobian()
        rejected = (negative_controls(certificate, derived, constraints, targets)
                    if args.negative_controls else [])
    except (VerificationError, json.JSONDecodeError, OSError) as error:
        print(json.dumps({"status": "failed", "error": str(error)}))
        return 1
    print(json.dumps({
        "status": "passed",
        "scope": SCOPE,
        "derived_exact_assertions": assertions,
        "universal_inequality_certificates": inequalities,
        "corrupted_assertions_rejected": len(rejected),
        "negative_controls": rejected,
        "jacobian": jacobian,
        "kernel_verified": False,
        "general_proof": "research/algebraization_audit/report.md",
    }, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
