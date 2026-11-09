#!/usr/bin/env python3
"""Replay exact algebra for the written uniform Kummer bridge, not its inputs."""

import argparse
import ast
from copy import deepcopy
from fractions import Fraction
import json
from math import gcd
from pathlib import Path
import sys

import sympy as sp


ROOT = Path(__file__).resolve().parent
NAMES = "e t u b c d s ts ell x D a h z q r1 r2 g rs gs delta"
SYMBOLS = dict(zip(NAMES.split(), sp.symbols(NAMES)))


class VerificationError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def expression(text, allowed):
    require(isinstance(text, str) and len(text) <= 1024, "invalid expression")
    tree = ast.parse(text, mode="eval")
    require(len(list(ast.walk(tree))) <= 128, "expression is too large")

    def read(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return sp.Integer(node.value)
        if isinstance(node, ast.Name) and node.id in allowed:
            return SYMBOLS[node.id]
        if isinstance(node, ast.UnaryOp):
            if isinstance(node.op, ast.USub):
                return -read(node.operand)
            if isinstance(node.op, ast.UAdd):
                return read(node.operand)
        if isinstance(node, ast.BinOp):
            left, right = read(node.left), read(node.right)
            if isinstance(node.op, ast.Add):
                return left + right
            if isinstance(node.op, ast.Sub):
                return left - right
            if isinstance(node.op, ast.Mult):
                return left * right
            if isinstance(node.op, ast.Div):
                require(right != 0, "zero denominator")
                return left / right
        raise VerificationError("expression uses an unsupported operation or variable")

    return read(tree.body)


def typed_matrix(data):
    variables = data["variables"]
    require(variables == ["x", "s", "t"], "unexpected typed matrix field")

    def polynomial(data):
        result = sp.Integer(0)
        previous = None
        for term in data["terms"]:
            exponents = term["exponents"]
            require(len(exponents) == 3, "wrong monomial arity")
            require(
                all(type(n) is int and 0 <= n <= 8 for n in exponents),
                "invalid monomial exponents",
            )
            key = tuple(exponents)
            require(previous is None or previous > key, "noncanonical monomial order")
            previous = key
            rational = term["coefficient"]
            num, den = int(rational["num"]), int(rational["den"])
            require(den > 0 and num != 0 and gcd(num, den) == 1, "invalid rational")
            coefficient = sp.Rational(num, den)
            for name, exponent in zip(variables, exponents):
                coefficient *= SYMBOLS[name] ** exponent
            result += coefficient
        return result

    def entry(data):
        require(data["domain"] == "QQ", "wrong coefficient domain")
        require(data["variables"] == variables, "inconsistent entry field")
        numerator = polynomial(data["numerator"])
        denominator = polynomial(data["denominator"])
        require(denominator != 0, "zero typed denominator")
        return sp.cancel(numerator / denominator)

    rows = data["entries"]
    require(rows and rows[0], "empty typed matrix")
    require(all(len(row) == len(rows[0]) for row in rows), "ragged typed matrix")
    return sp.Matrix([[entry(value) for value in row] for row in rows])


def verify(certificate, evidence):
    require(certificate["schema_version"] == 1, "unknown certificate schema")
    require(certificate["claim_id"] == "C_UNIFORM", "wrong claim")
    checks = []

    def equal(label, left, right=0):
        require(sp.cancel(left - right) == 0, f"{label}: nonzero exact residual")
        checks.append(label)

    v = SYMBOLS
    e, t, u, b, c = (v[name] for name in ("e", "t", "u", "b", "c"))
    twist = certificate["twist"]
    conjugated = expression(twist["conjugated_cocycle"], {"b", "c", "u", "t", "e"})
    derived = -b / (t * e) + c / (t * e) + u * b / (t * e)
    equal("cocycle conjugation", conjugated, derived)
    eigenvalue = expression(twist["eigenvalue"], {"e"})
    parameter = expression(twist["coboundary_parameter"], {"b", "e"})
    equal("inverse twist modulo coboundary", t * conjugated, eigenvalue * c + (u - 1) * parameter)

    fixture = twist["nonquadratic_residue_fixture"]
    prime, residue = fixture["ell"], fixture["epsilon_mod_ell"]
    require(type(prime) is int and 2 < prime <= 31 and sp.isprime(prime), "bad residue prime")
    order = fixture["order"]
    require(type(order) is int and 2 < order < prime, "fixture is not nonquadratic")
    require(pow(residue, order, prime) == 1, "wrong character order")
    require(all(pow(residue, j, prime) != 1 for j in range(1, order)), "order is not exact")
    inverse = fixture["inverse_mod_ell"]
    require(residue * inverse % prime == 1 and inverse != residue, "inverse orientation not detected")

    d, s, ts = (v[name] for name in ("d", "s", "ts"))
    parameter = expression(certificate["restriction_averaging"]["coboundary_parameter"], {"s", "d"})
    coboundary = parameter.subs(s, ts) - parameter
    averaging_relation = s - d * c - ts
    equal("finite quotient restriction is injective", d * (c - coboundary), -averaging_relation)

    a, h = v["a"], v["h"]
    recovered = expression(certificate["kummer_independence"]["recovered_coefficient"], {"a", "h"})
    equal("diagonal valuation independence", h * recovered, a)

    ell, x, divisor = v["ell"], v["x"], v["D"]
    completion = certificate["completion"]
    valuation = expression(completion["next_level_valuation"], {"ell", "x", "D"})
    transition = expression(completion["obstruction_transition"], {"ell", "D"})
    equal("next-level principal divisor", valuation, ell * x * divisor)
    equal("class obstruction transition is multiplication by ell", valuation / x, transition)

    bezout = certificate["prime_to_ell_index"]
    first, second = bezout["ell_coefficient"], bezout["ell_minus_one_coefficient"]
    require(type(first) is int and type(second) is int, "invalid Bezout coefficients")
    equal("twist index is prime to ell", first * ell + second * (ell - 1), 1)

    geometric = certificate["geometric_sum_induction"]
    base = expression(geometric["base_sum"], set())
    next_sum = expression(geometric["next_sum"], {"s", "t"})
    next_power = expression(geometric["next_power"], {"x", "t"})
    equal("geometric sum base", (x - 1) * base, x - 1)
    equal("finite sum successor definition", next_sum, s + t)
    equal("power successor definition", next_power, x * t)
    invariant = (x - 1) * s - (t - 1)
    equal("geometric sum induction for every length", (x - 1) * next_sum - (next_power - 1), invariant)

    z, q = v["z"], v["q"]
    cyclic = certificate["cyclic_eigenvector"]
    initial = expression(cyclic["initial_coefficient"], {"a"})
    successor = expression(cyclic["successor_coefficient"], {"q", "z"})
    last = expression(cyclic["last_coefficient"], {"z", "a", "t"})
    obstruction = expression(cyclic["boundary_obstruction"], {"z", "a", "t"})
    equal("cycle initial coefficient", initial, a)
    equal("cycle recurrence for every interior index", z * successor, q)
    equal("cycle last coefficient with t=z^m", last, z * a / t)
    equal("cycle closing equation for every length", last - z * a, obstruction)

    rs, r2, gs, delta = (v[name] for name in ("rs", "r2", "gs", "delta"))
    multiplicity = certificate["multiplicity"]
    require(multiplicity["trivial_summand_multiplicity"] == 1, "missing augmentation correction")
    dimension = expression(multiplicity["faithful_character_dimension"], {"rs", "r2", "gs", "delta"})
    equal("faithful character multiplicity", dimension, rs + r2 + gs - delta)

    r1, g = v["r1"], v["g"]
    equalities = {"degree_signature": d - r1 - 2 * r2}
    nonnegative = {
        "number_of_ell_primes": d - g,
        "split_real_places": r1 - rs,
        "split_ell_primes": g - gs,
        "complex_places": r2,
        "trivial_character": delta,
    }
    bound = certificate["uniform_bound"]
    combination = sp.Integer(0)
    for key, weight in bound["equality_weights"].items():
        require(key in equalities, "unrecognized equality hypothesis")
        weight = Fraction(weight)
        combination += sp.Rational(weight.numerator, weight.denominator) * equalities[key]
    for key, weight in bound["nonnegative_weights"].items():
        require(key in nonnegative, "unrecognized nonnegative hypothesis")
        weight = Fraction(weight)
        require(weight >= 0, "negative Farkas multiplier")
        combination += sp.Rational(weight.numerator, weight.denominator) * nonnegative[key]
    equal("uniform bound in every degree", 2 * d - dimension, combination)

    coverage = set()
    cases = certificate["quadratic_boundary_cases"]
    require(isinstance(cases, list) and cases, "missing arithmetic boundary cases")
    for case in cases:
        prime = case["ell"]
        require(type(prime) is int and 2 < prime <= 31 and sp.isprime(prime), "bad fixture prime")
        polynomial = case["twist_polynomial"]
        if polynomial is None:
            coverage.add("trivial_twist")
            require(case["base"] in {"Q", "Qi"}, "unsupported fixture base")
            if case["base"] == "Q":
                expected_dimension = 1
            else:
                root_count = sum((j * j + 1) % prime == 0 for j in range(prime))
                require(root_count in {0, 2}, "invalid Gaussian splitting")
                expected_dimension = 2 if root_count == 2 else 1
                coverage.add("complex_base")
            ramified = []
        else:
            require(case["base"] == "Q", "nontrivial fixture must have base Q")
            require(polynomial in ([1, -1, -1], [1, 0, 1]), "unsupported quadratic fixture")
            leading, linear, constant = polynomial
            discriminant = linear * linear - 4 * leading * constant
            roots = sum((j * j + linear * j + constant) % prime == 0 for j in range(prime))
            split_real = int(discriminant > 0)
            split_prime = int(roots == 2 and discriminant % prime != 0)
            expected_dimension = split_real + split_prime
            ramified = sorted(int(p) for p in sp.factorint(abs(discriminant)) if p != prime)
            coverage.add("real_split" if split_real else "real_to_complex")
            if discriminant % prime == 0:
                coverage.add("ell_ramified")
            else:
                coverage.add("ell_split" if split_prime else "ell_inert")
            if ramified:
                coverage.add("twist_ramified_outside_ell")
        require(case["dimension"] == expected_dimension, f"{case['name']}: wrong unit multiplicity")
        require(case["ramified_twist_primes_outside_ell"] == ramified, f"{case['name']}: wrong ramification")
        checks.append(f"arithmetic fixture: {case['name']}")
    required_coverage = {
        "trivial_twist", "complex_base", "real_split", "real_to_complex",
        "ell_ramified", "ell_split", "ell_inert", "twist_ramified_outside_ell",
    }
    require(required_coverage <= coverage, "arithmetic boundary coverage is incomplete")

    arithmetic = certificate["unit_arithmetic"]
    unit_norm = sp.rem(x * (1 - x), x * x - x - 1, x)
    equal("real quadratic unit norm", unit_norm, arithmetic["real_unit_norm"])
    real, imaginary = arithmetic["gaussian_split_element"]
    require(
        real * real + imaginary * imaginary == arithmetic["gaussian_split_element_norm"] == 5,
        "Gaussian prime element has the wrong norm",
    )

    payload, record, status = evidence
    specification = certificate["jacobian"]
    operation = specification["operation_id"]
    require(operation == "matrix.symbolic.multiply.compute", "wrong Jacobian operation")
    require(status["adapter_exit_code"] == 0, "adapter failure is a non-conclusion")
    require(record["protocol_version"] == specification["protocol_version"], "protocol mismatch")
    require(record["server"]["version"] == specification["server_version"], "server mismatch")
    require(record["transport"] == "mcp-stdio" and record["tool"] == "math.run", "wrong adapter provenance")
    require(record["request"]["operation_id"] == operation, "wrong recorded operation")
    require(record["request"]["payload"] == payload, "typed request is not bound to the saved payload")
    result = record["result"]
    require(result["operation_id"] == operation and "output" in result, "incomplete typed result")
    require(record.get("error") is None and result.get("error") is None, "adapter error is a non-conclusion")
    left, right, output = (typed_matrix(item) for item in (payload["left"], payload["right"], result["output"]))
    expected_left = sp.Matrix([[x - 1, -1, 1]])
    expected_right = sp.Matrix([[s + t], [x * t], [1]])
    require(left.shape == (1, 3) and right.shape == (3, 1), "wrong operation dimensions")
    require(output.shape == (1, 1), "wrong output dimensions")
    for index, (actual, expected) in enumerate(zip(left, expected_left)):
        equal(f"typed left factor {index}", actual, expected)
    for index, (actual, expected) in enumerate(zip(right, expected_right)):
        equal(f"typed right factor {index}", actual, expected)
    equal("independent typed matrix replay", output[0, 0], (left * right)[0, 0])
    equal("Jacobian geometric induction residual", output[0, 0], invariant)
    return {"exact_checks": len(checks), "arithmetic_boundary_cases": len(cases)}


def rejection_tests(certificate, evidence):
    mutations = [
        ("twist", "eigenvalue", "e"),
        ("restriction_averaging", "coboundary_parameter", "s/d"),
        ("kummer_independence", "recovered_coefficient", "a"),
        ("completion", "obstruction_transition", "D"),
        ("geometric_sum_induction", "next_power", "t"),
        ("cyclic_eigenvector", "successor_coefficient", "z*q"),
        ("multiplicity", "faithful_character_dimension", "rs+r2+gs+delta"),
        ("multiplicity", "trivial_summand_multiplicity", 0),
        ("unit_arithmetic", "real_unit_norm", 1),
    ]
    rejected = 0

    def reject(altered, altered_evidence):
        nonlocal rejected
        try:
            verify(altered, altered_evidence)
        except VerificationError:
            rejected += 1
        else:
            raise VerificationError("an invalid certificate was accepted")

    for section, key, value in mutations:
        altered = deepcopy(certificate)
        altered[section][key] = value
        reject(altered, evidence)
    altered = deepcopy(certificate)
    altered["uniform_bound"]["nonnegative_weights"]["complex_places"] = -1
    reject(altered, evidence)
    altered = deepcopy(certificate)
    altered["quadratic_boundary_cases"][2]["dimension"] = 1
    reject(altered, evidence)
    altered = deepcopy(certificate)
    altered["uniform_bound"]["equality_weights"]["degree_signature"] = 2
    reject(altered, evidence)
    altered = deepcopy(certificate)
    altered["prime_to_ell_index"]["ell_minus_one_coefficient"] = 1
    reject(altered, evidence)
    altered = deepcopy(certificate)
    altered["twist"]["conjugated_cocycle"] = "__import__('os').system('false')"
    reject(altered, evidence)
    altered_evidence = deepcopy(evidence)
    altered_evidence[1]["result"]["output"]["entries"][0][0]["numerator"]["terms"][0]["coefficient"]["num"] = "2"
    reject(certificate, altered_evidence)
    altered_evidence = deepcopy(evidence)
    altered_evidence[2]["adapter_exit_code"] = 124
    reject(certificate, altered_evidence)
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    arguments = parser.parse_args()
    certificate = json.loads(arguments.certificate.read_text())
    specification = certificate["jacobian"]
    paths = [ROOT / specification[key] for key in ("payload", "output", "adapter_status")]
    require(all(path.resolve().is_relative_to(ROOT) for path in paths), "evidence is outside research/")
    evidence = tuple(json.loads(path.read_text()) for path in paths)
    result = verify(certificate, evidence)
    result["invalid_certificates_rejected"] = rejection_tests(certificate, evidence)
    result["status"] = "exact_checks_passed"
    result["not_machine_checked"] = "Arithmetic proof, cited theorems, and upstream logarithmic compatibility; independent review is required."
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (VerificationError, KeyError, TypeError, SyntaxError, json.JSONDecodeError) as error:
        print(f"verification failed: {error}", file=sys.stderr)
        raise SystemExit(1)
