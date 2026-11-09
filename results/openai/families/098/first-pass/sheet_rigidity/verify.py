#!/usr/bin/env python3
"""Replay exact algebra and finite sanity checks; check current Lean evidence."""

import argparse
import ast
from fractions import Fraction
from itertools import combinations, product
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def add(p, q):
    out = dict(p)
    for monomial, coefficient in q.items():
        out[monomial] = out.get(monomial, Fraction(0)) + coefficient
    return {m: c for m, c in out.items() if c}


def scale(p, c):
    return {m: c * a for m, a in p.items() if c * a}


def multiply(p, q):
    out = {}
    for m, a in p.items():
        for n, b in q.items():
            key = tuple(sorted(m + n))
            out[key] = out.get(key, Fraction(0)) + a * b
    return {m: c for m, c in out.items() if c}


def polynomial(text):
    def read(node):
        if isinstance(node, ast.Name):
            return {(node.id,): Fraction(1)}
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return {} if node.value == 0 else {(): Fraction(node.value)}
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
            return scale(read(node.operand), -1)
        if isinstance(node, ast.BinOp):
            left = read(node.left)
            if isinstance(node.op, ast.Pow):
                assert isinstance(node.right, ast.Constant)
                exponent = node.right.value
                assert type(exponent) is int and 0 <= exponent <= 20
                out = {(): Fraction(1)}
                for _ in range(exponent):
                    out = multiply(out, left)
                return out
            right = read(node.right)
            if isinstance(node.op, ast.Add):
                return add(left, right)
            if isinstance(node.op, ast.Sub):
                return add(left, scale(right, -1))
            if isinstance(node.op, ast.Mult):
                return multiply(left, right)
            if isinstance(node.op, ast.Div):
                assert set(right) == {()}, "Only nonzero rational divisors are allowed"
                return scale(left, 1 / right[()])
        raise ValueError(f"Unsupported exact-polynomial expression: {ast.dump(node)}")

    return read(ast.parse(text, mode="eval").body)


def typed_polynomial(value):
    assert value["domain"] == "QQ"
    variables = value["variables"]
    out = {}
    for term in value["polynomial"]["terms"]:
        exponents = term["exponents"]
        assert len(exponents) == len(variables)
        assert all(type(e) is int and e >= 0 for e in exponents)
        key = tuple(sorted(v for v, e in zip(variables, exponents) for _ in range(e)))
        c = term["coefficient"]
        coefficient = Fraction(int(c["num"]), int(c["den"]))
        assert str(coefficient.numerator) == c["num"]
        assert str(coefficient.denominator) == c["den"]
        assert coefficient and key not in out
        out[key] = coefficient
    return out


def check_jacobian(certificate):
    spec = certificate["jacobian"]
    assert spec["adapter_exit_code"] == 0 and spec["structured_error"] is None
    payload = json.loads((HERE / spec["payload"]).read_text())
    envelope = json.loads((HERE / spec["typed_output"]).read_text())
    assert envelope["server"]["version"] == spec["server_version"]
    assert envelope["protocol_version"] == spec["protocol_version"]
    assert envelope["request"]["operation_id"] == spec["operation_id"]
    assert envelope["request"]["payload"] == payload
    result = envelope["result"]
    assert result["operation_id"] == spec["operation_id"]
    output = result["output"]
    assert output["is_valid"] is True
    assert output["method"] == "EXACT_COEFFICIENT_IDENTITY"
    assert output["polynomial"] == payload["polynomial"]
    assert output["summands"] == payload["summands"]
    computed = {}
    for summand in payload["summands"]:
        p = typed_polynomial(summand)
        computed = add(computed, multiply(p, p))
    assert computed == typed_polynomial(output["computed_sum"])
    assert computed == typed_polynomial(payload["polynomial"])
    assert computed == polynomial("2*a**2+2*b**2-(a+b)**2")


def finite_adversarial_checks(spec):
    grid = tuple(Fraction(x) for x in spec["coordinates"])
    points = tuple(product(grid, repeat=2))
    denominator = spec["probability_weight_denominator"]
    sets_checked = measures_checked = 0
    for size in spec["compact_set_sizes"]:
        weights = tuple(w for w in product(range(denominator + 1), repeat=size)
                        if sum(w) == denominator)
        for K in combinations(points, size):
            A = max(s for s, _ in K)
            B = max(t for s, t in K if s == A)
            for epsilon in map(Fraction, spec["epsilon_values"]):
                gaps = [A - s for s, t in K if t > B + epsilon]
                delta = min(gaps) / 2 if gaps else Fraction(1)
                assert delta > 0
                for s, t in K:
                    assert t <= B + epsilon + 2 * (A - s) / delta
                for numerators in weights:
                    mean_s = sum(Fraction(w, denominator) * p[0]
                                 for w, p in zip(numerators, K))
                    mean_t = sum(Fraction(w, denominator) * p[1]
                                 for w, p in zip(numerators, K))
                    assert mean_t <= B + epsilon + 2 * (A - mean_s) / delta
                    measures_checked += 1
                sets_checked += 1
    return sets_checked, measures_checked


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--arithmetic-only", action="store_true",
                        help="Run the standalone standard-library checks without Lean evidence.")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    for identity in certificate["identities"]:
        assert polynomial(identity["lhs"]) == polynomial(identity["rhs"]), identity["name"]
    separation = certificate["rational_separation"]
    c = Fraction(separation["weakened_source_distance"])
    omega = Fraction(separation["transport_bound"])
    margin = Fraction(separation["pair_distance_lower_bound"])
    assert c * c < Fraction(separation["source_squared_distance"])
    assert c - 2 * omega == margin > Fraction(separation["required_pair_distance"])
    for N in range(1, 9):
        budget_boundary = Fraction(1, 128 * N ** 3)
        assert 2 * N ** 3 * budget_boundary == omega ** 2
    check_jacobian(certificate)
    sets_checked, measures_checked = finite_adversarial_checks(
        certificate["finite_adversarial_search"])
    lean_verified = False
    if not args.arithmetic_only:
        result = subprocess.run(
            [ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence",
             "check", "--project-root", str(ROOT)],
            text=True, capture_output=True, check=True)
        report = json.loads(result.stdout)
        assert report["ok"], report
        compiler = json.loads((HERE / "lean_check.json").read_text())
        assert compiler["exit_code"] == 0
        assert compiler["proof_holes"] == []
        archive = json.loads((HERE / certificate["formal_certificate"]).read_text())
        assert archive["subject"]["subject_id"] == certificate["formal_claim"]
        assert archive["tier"] == "mechanical" and archive["verdict"] == "supports"
        assert archive["lean_check"] == compiler
        lean_verified = True
    print(json.dumps({
        "exact_polynomial_identities": len(certificate["identities"]),
        "jacobian_exact_sos_replayed": True,
        "finite_set_epsilon_cases": sets_checked,
        "finite_rational_measure_cases": measures_checked,
        "rational_transport_margin": str(margin),
        "current_lean_evidence_verified": lean_verified,
        "analytic_proof": "proof.md; independently review the analytic instantiation",
        "counterexample_found": False
    }, indent=2))


if __name__ == "__main__":
    main()
