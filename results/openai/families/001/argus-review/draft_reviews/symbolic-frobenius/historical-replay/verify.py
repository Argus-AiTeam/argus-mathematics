#!/usr/bin/env python3
"""Replay the exact algebra; this does not machine-check the geometric inputs."""

import argparse
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
PARAMETERS = sp.symbols("p u v")
p, u, v = PARAMETERS


def dual(matrix):
    return matrix.inv().T


def frame_equations():
    b = sp.Matrix([[0, 1], [-1 / p, 0]])
    sigma_g = sp.Matrix([[1, u], [0, 1]])
    sigma2_g = sp.Matrix([[1, v], [0, 1]])
    basis = dual(sigma_g)
    rhs_matrix = dual(b) * dual(sigma2_g)
    coefficients = sp.zeros(4)
    for i in range(2):
        for j in range(2):
            for k in range(2):
                coefficients[2 * i + j, 2 * k + j] = basis[i, k]
    return b, sigma_g, sigma2_g, basis, coefficients, sp.Matrix(list(rhs_matrix))


def rational_function(expression):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    numerator = sp.Poly(numerator, *PARAMETERS, domain=sp.QQ)
    denominator = sp.Poly(denominator, *PARAMETERS, domain=sp.QQ)
    leading = denominator.LC()

    def polynomial(poly):
        return {
            "terms": [
                {
                    "coefficient": {
                        "num": str((coefficient / leading).p),
                        "den": str((coefficient / leading).q),
                    },
                    "exponents": list(exponents),
                }
                for exponents, coefficient in poly.terms()
                if coefficient != 0
            ]
        }

    return {
        "domain": "QQ",
        "variables": [str(symbol) for symbol in PARAMETERS],
        "numerator": polynomial(numerator),
        "denominator": polynomial(denominator),
    }


def payload():
    *_, coefficients, rhs = frame_equations()
    return {
        "matrix": {
            "variables": [str(symbol) for symbol in PARAMETERS],
            "entries": [
                [rational_function(value) for value in row]
                for row in coefficients.tolist()
            ],
        },
        "rhs": [rational_function(value) for value in rhs],
    }


def decode_function(value):
    assert value["variables"] == [str(symbol) for symbol in PARAMETERS]
    assert value.get("domain", "QQ") == "QQ"

    def polynomial(data):
        answer = sp.Integer(0)
        for term in data["terms"]:
            coefficient = term["coefficient"]
            monomial = sp.Rational(int(coefficient["num"]), int(coefficient["den"]))
            assert len(term["exponents"]) == len(PARAMETERS)
            for symbol, exponent in zip(PARAMETERS, term["exponents"]):
                assert isinstance(exponent, int) and exponent >= 0
                monomial *= symbol**exponent
            answer += monomial
        return answer

    denominator = polynomial(value["denominator"])
    assert denominator != 0
    return sp.cancel(polynomial(value["numerator"]) / denominator)


def zero_matrix(matrix):
    return all(sp.cancel(entry) == 0 for entry in matrix)


def verify_frame_and_adapter(certificate):
    b, sigma_g, sigma2_g, basis, coefficients, rhs = frame_equations()
    expected = sp.Matrix([-v, 1, -p - u * v, u])
    assert coefficients.det() == 1
    assert zero_matrix(coefficients * expected - rhs)
    matrix = sp.Matrix(2, 2, list(expected))
    assert zero_matrix(
        matrix - dual(sigma_g.inv() * b * sigma2_g)
    )
    assert zero_matrix(basis * matrix - dual(b) * dual(sigma2_g))
    assert sp.cancel(matrix.det() - p) == 0

    adapter = certificate["jacobian"]
    assert adapter["operation_id"] == "matrix.symbolic.linear_system.solve"
    actual_payload = json.loads((ROOT / adapter["payload"]).read_text())
    assert actual_payload == payload(), "adapter input is not the derived frame equation"
    output = json.loads((ROOT / adapter["output"]).read_text())
    assert output["server"]["name"] == "jacobian"
    assert output["protocol_version"], "missing adapter protocol record"
    assert output["request"]["operation_id"] == adapter["operation_id"]
    assert output["request"]["payload"] == actual_payload
    assert output["result"]["operation_id"] == adapter["operation_id"]
    result = output["result"]["output"]
    assert result["classification"] == "UNIQUE"
    assert result["consistency"] == "EXACT_RATIONAL_FUNCTION"
    assert result["field_semantics"] == "GENERIC_OVER_QQ_FIELD"
    assert result["system"] == actual_payload
    solution = sp.Matrix([decode_function(value) for value in result["solution"]])
    assert zero_matrix(solution - expected)
    assert zero_matrix(coefficients * solution - rhs)
    return matrix


def verify_quadratic_diagnostic(certificate, symbolic_matrix):
    data = certificate["quadratic_frobenius_diagnostic"]
    assert data["prime"] == 2
    t = sp.Symbol("t")
    a, b, c = data["minimal_polynomial_coefficients"]
    polynomial = sp.Poly(a * t**2 + b * t + c, t, domain=sp.QQ)
    assert polynomial.as_expr() == t**2 + t + 1
    assert all(int(polynomial.eval(value)) % 2 == 1 for value in (0, 1))
    constant, linear = data["frobenius_coefficients"]
    sigma_t = constant + linear * t

    def reduce(expression):
        return sp.rem(sp.Poly(sp.expand(expression), t, domain=sp.QQ), polynomial).as_expr()

    def sigma(matrix):
        return matrix.applyfunc(lambda entry: reduce(entry.subs(t, sigma_t)))

    assert reduce(sigma_t.subs(t, sigma_t) - t) == 0
    assert reduce(polynomial.as_expr().subs(t, sigma_t)) == 0
    g = sp.Matrix([[1, t], [0, 1]])
    b_matrix = sp.Matrix([[0, 1], [-sp.Rational(1, 2), 0]])
    crystalline = dual(b_matrix)
    correct = (dual(sigma(g)).inv() * crystalline * sigma(dual(sigma(g)))).applyfunc(reduce)
    family = symbolic_matrix.subs({p: 2, u: sigma_t, v: t}).applyfunc(reduce)
    assert zero_matrix(correct - family)
    wrong = (dual(g).inv() * crystalline * sigma(dual(g))).applyfunc(reduce)
    assert any(reduce(entry) != 0 for entry in correct - wrong)
    assert reduce(correct.det()) == 2


def verify_integral_obstruction(certificate):
    data = certificate["integral_shortcut_obstruction"]
    assert data["prime"] == data["character_modulus"] == 2
    lattice = sp.Matrix(data["lattice_columns"])
    projector = sp.Matrix(data["rational_projector"])
    assert lattice == sp.Matrix([[1, 0], [1, 2]])
    assert lattice.det() == 2
    assert projector == sp.diag(1, 0)
    assert projector**2 == projector
    s = sp.Symbol("s")
    action = sp.diag(1, 1 + 2 * s)
    integral_action = lattice.inv() * action * lattice
    assert integral_action == sp.Matrix([[1, 0], [s, 1 + 2 * s]])
    for entry in integral_action:
        assert sp.Poly(entry, s).domain == sp.ZZ
    assert integral_action.det() == 1 + 2 * s
    transported = lattice.inv() * projector * lattice
    assert transported == sp.Matrix([[1, 0], [-sp.Rational(1, 2), 0]])
    assert transported[1, 0].q == 2
    assert all(entry.q == 1 for entry in projector)
    assert data["not_a_counterexample_to"] == "PF-REALIZATION"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--emit-jacobian-payload", action="store_true")
    arguments = parser.parse_args()
    if arguments.emit_jacobian_payload:
        print(json.dumps(payload(), indent=2))
        return
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    assert certificate["schema_version"] == 1
    assert certificate["formal_core_claim"] == "PF-CORE"
    symbolic_matrix = verify_frame_and_adapter(certificate)
    verify_quadratic_diagnostic(certificate, symbolic_matrix)
    verify_integral_obstruction(certificate)
    print(json.dumps({
        "exact_algebra": "PASS",
        "symbolic_frame_family": "QQ(p,u,v), determinant p",
        "quadratic_frobenius_diagnostic": "PASS at p=2; omitted-sigma convention differs",
        "arbitrary_lattice_shortcut": "REFUTED; not a manuscript counterexample",
        "geometric_realization": "external theorem reduction; not machine-checked by this script",
        "independent_review": "pending",
    }, indent=2))


if __name__ == "__main__":
    main()
