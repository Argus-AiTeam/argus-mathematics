#!/usr/bin/env python3
"""Replay exact identities and finite checks; bind the universal Lean evidence."""

import argparse
import ast
from copy import deepcopy
from fractions import Fraction
import hashlib
import itertools
import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parent
VARIABLES = frozenset("f z w l r y u v a b p".split())
COMMUTATIVE = {
    "plus_idempotent": ("((1+f)/2)**2", "(1+f)/2", {"f*f-1"}),
    "minus_idempotent": ("((1-f)/2)**2", "(1-f)/2", {"f*f-1"}),
    "spectral_orthogonality": ("((1+f)/2)*((1-f)/2)", "0", {"f*f-1"}),
    "spectral_complement": ("(1+f)/2+(1-f)/2", "1", set()),
    "partial_flip_unitarity": (
        "((1+f+w*(1-f))/2)*((1+f+z*(1-f))/2)",
        "1",
        {"f*f-1", "z*w-1"},
    ),
    "initial_endpoint": ("(1+f)/2+(1-f)/2", "1", set()),
    "terminal_endpoint": ("(1+f)/2-(1-f)/2", "f", set()),
    "uniform_terminal_difference": (
        "(1+f)/2+z*(1-f)/2-f", "(z+1)*(1-f)/2", set()
    ),
    "cutoff_rescaling": ("(1-l)*r*y", "y", {"(1-l)*r-1"}),
    "product_defect_recursion": ("1-a*p", "(1-a)+a*(1-p)", set()),
    "product_defect_nonnegative_remainder": (
        "(1-a)+(1-p)-(1-a*p)", "(1-a)*(1-p)", set()
    ),
}
NONCOMMUTATIVE = {
    "conjugation_multiplication": ("unitary", "(u*a*v)*(u*b*v)", "u*(a*b)*v"),
    "conjugation_unital": ("unitary", "u*1*v", "1"),
    "uniform_norm_expansion": (
        "free", "u*a*v-f*a*w", "(u-f)*a*v+f*a*(v-w)"
    ),
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def artifact(name):
    path = (ROOT / name).resolve()
    require(path.is_relative_to(ROOT), f"Artifact escapes the owned directory: {name}")
    return path


def read_json(path):
    with path.open(encoding="utf-8") as stream:
        return json.load(stream)


def add(left, right, coefficient=Fraction(1)):
    result = dict(left)
    for word, value in right.items():
        result[word] = result.get(word, Fraction(0)) + coefficient * value
        if not result[word]:
            del result[word]
    return result


def multiply(left, right, mode):
    result = {}
    for first, a in left.items():
        for second, b in right.items():
            word = first + second
            if mode == "commutative":
                word = tuple(sorted(word))
            elif mode == "unitary":
                stack = []
                for letter in word:
                    if stack and (stack[-1], letter) in {("u", "v"), ("v", "u")}:
                        stack.pop()
                    else:
                        stack.append(letter)
                word = tuple(stack)
            result[word] = result.get(word, Fraction(0)) + a * b
            if not result[word]:
                del result[word]
    return result


def polynomial(expression, mode="commutative"):
    def visit(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return {(): Fraction(node.value)} if node.value else {}
        if isinstance(node, ast.Name) and node.id in VARIABLES:
            return {(node.id,): Fraction(1)}
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.UAdd, ast.USub)):
            value = visit(node.operand)
            return value if isinstance(node.op, ast.UAdd) else add({}, value, -1)
        if isinstance(node, ast.BinOp):
            left = visit(node.left)
            if isinstance(node.op, ast.Pow):
                require(
                    isinstance(node.right, ast.Constant)
                    and type(node.right.value) is int
                    and 0 <= node.right.value <= 8,
                    "Only bounded nonnegative integer powers are admitted",
                )
                result = {(): Fraction(1)}
                for _ in range(node.right.value):
                    result = multiply(result, left, mode)
                return result
            right = visit(node.right)
            if isinstance(node.op, ast.Add):
                return add(left, right)
            if isinstance(node.op, ast.Sub):
                return add(left, right, -1)
            if isinstance(node.op, ast.Mult):
                return multiply(left, right, mode)
            if isinstance(node.op, ast.Div):
                require(set(right) == {()} and right[()] != 0, "Nonconstant divisor")
                return {word: value / right[()] for word, value in left.items()}
        raise ValueError(f"Unadmitted exact expression: {expression}")

    return visit(ast.parse(expression, mode="eval").body)


def verify_identities(certificate):
    entries = certificate["commutative_identities"]
    require(
        len(entries) == len(COMMUTATIVE)
        and {entry["id"] for entry in entries} == set(COMMUTATIVE),
        "The intended universal commutative obligations have changed",
    )
    for entry in entries:
        left, right, generators = COMMUTATIVE[entry["id"]]
        require((entry["left"], entry["right"]) == (left, right), entry["id"])
        require(
            {term["generator"] for term in entry["ideal"]} == generators
            and len(entry["ideal"]) == len(generators),
            f"Wrong hypotheses in {entry['id']}",
        )
        residual = add(polynomial(left), polynomial(right), -1)
        for term in entry["ideal"]:
            product = multiply(
                polynomial(term["generator"]), polynomial(term["multiplier"]),
                "commutative",
            )
            residual = add(residual, product, -1)
        require(not residual, f"False polynomial certificate: {entry['id']}")

    entries = certificate["noncommutative_identities"]
    require(
        len(entries) == len(NONCOMMUTATIVE)
        and {entry["id"] for entry in entries} == set(NONCOMMUTATIVE),
        "The intended noncommutative obligations have changed",
    )
    for entry in entries:
        mode, left, right = NONCOMMUTATIVE[entry["id"]]
        require(
            (entry["mode"], entry["left"], entry["right"]) == (mode, left, right),
            entry["id"],
        )
        require(
            polynomial(left, mode) == polynomial(right, mode),
            f"False noncommutative identity: {entry['id']}",
        )
    return len(COMMUTATIVE), len(NONCOMMUTATIVE)


def matrix_multiply(left, right):
    return [
        [
            sum((left[i][s] * right[s][j] for s in range(len(right))), Fraction(0))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def identity(size):
    return [[Fraction(i == j) for j in range(size)] for i in range(size)]


def rational_matrix(data):
    require(data.get("domain", "QQ") == "QQ", "Nonrational Jacobian matrix")
    result = []
    for row in data["entries"]:
        values = []
        for value in row:
            number = Fraction(int(value["num"]), int(value["den"]))
            require(
                str(number.numerator) == value["num"]
                and str(number.denominator) == value["den"],
                "Noncanonical typed rational",
            )
            values.append(number)
        result.append(values)
    require(
        bool(result) and bool(result[0])
        and all(len(row) == len(result[0]) for row in result),
        "Invalid matrix shape",
    )
    return result


def verify_jacobian(payload, result, status):
    operation = "matrix.polynomial.evaluate.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not complete")
    require(status["operation_id"] == operation, "Wrong adapter operation")
    require(result["request"]["operation_id"] == operation, "Wrong typed request")
    require(result["request"]["payload"] == payload, "Payload/source mismatch")
    require(result["result"]["operation_id"] == operation, "Wrong typed result")
    require(result["tool"] == "math.run", "Not an executed operation")
    require(result["transport"] == "mcp-stdio", "Missing sidecar transport")
    require(bool(result["server"]["version"]), "Missing Jacobian server version")
    require(bool(result["protocol_version"]), "Missing Jacobian protocol version")
    output = result["result"]["output"]
    source = rational_matrix(payload["matrix"])
    flip = [
        [Fraction(i // 2 == j % 2 and i % 2 == j // 2) for j in range(4)]
        for i in range(4)
    ]
    require(source == flip, "Input is not the actual M2 flip")
    require(rational_matrix(output["source_matrix"]) == flip, "Source matrix changed")
    terms = payload["polynomial"]["polynomial"]["terms"]
    coefficients = {
        tuple(term["exponents"]): Fraction(
            int(term["coefficient"]["num"]), int(term["coefficient"]["den"])
        )
        for term in terms
    }
    require(
        payload["polynomial"]["variables"] == ["t"]
        and coefficients == {(2,): Fraction(1), (0,): Fraction(-1)},
        "The requested polynomial is not t^2-1",
    )
    require(
        output["polynomial"]["polynomial"] == payload["polynomial"]["polynomial"]
        and output["polynomial"]["variables"] == ["t"],
        "Returned polynomial changed",
    )
    square = matrix_multiply(flip, flip)
    value = [[square[i][j] - identity(4)[i][j] for j in range(4)] for i in range(4)]
    require(
        rational_matrix(output["value"]) == value
        and all(entry == 0 for row in value for entry in row),
        "False typed Jacobian polynomial value",
    )
    require(
        output["method"] == "HORNER_OVER_QQ"
        and output["polynomial_degree"] == 2
        and output["matrix_multiplications"] == 2
        and output["scalar_product_terms"] == 128,
        "Typed computation accounting changed",
    )
    e21 = [[Fraction(0), Fraction(0)], [Fraction(1), Fraction(0)]]
    e12 = [list(row) for row in zip(*e21)]
    require(matrix_multiply(e12, e21) == [[1, 0], [0, 0]], "e21 initial corner")
    require(matrix_multiply(e21, e12) == [[0, 0], [0, 1]], "e21 final corner")


def boundary_points(k, delta):
    levels = (Fraction(0), delta / 4, delta / 2, delta, (1 + delta) / 2, Fraction(1))
    points = {
        (Fraction(0),) * k,
        (delta / 8,) * k,
        (delta / 2,) * k,
        (delta,) * k,
        tuple(levels[i % len(levels)] for i in range(k)),
    }
    if k <= 3:
        points.update(itertools.product(levels, repeat=k))
    for j in {0, k // 2, k - 1}:
        for background in (Fraction(0), delta / 4):
            point = [background] * k
            point[j] = (1 + delta) / 2
            points.add(tuple(point))
    return points


def verify_finite_supplements(config):
    dimensions = config["cube_dimensions"]
    deltas = [Fraction(value) for value in config["deltas"]]
    require(dimensions == [1, 2, 3, 7, 17, 64], "Changed finite-dimension supplement")
    require(deltas == [Fraction(1, 4), Fraction(1, 2), Fraction(2, 3)], "Changed cuts")
    count = 0
    for k in dimensions:
        for delta in deltas:
            for t in boundary_points(k, delta):
                require(all(0 <= value <= 1 for value in t), "Point outside cube")
                g = [max(1 - 2 * value / delta, 0) for value in t]
                q = [max(value - delta, 0) for value in t]
                x = math.prod(g)
                h = 1 - x
                require(0 <= h <= min(1, 2 * sum(t) / delta), "Origin bound")
                require(all(a * b == 0 for a, b in zip(g, q)), "Cut-gap overlap")
                y = [
                    q[j] * math.prod(g[i] for i in range(k) if i != j)
                    for j in range(k)
                ]
                require(all(x * value == 0 for value in y), "Defect-axis overlap")
                require(
                    all(y[i] * y[j] == 0 for i in range(k) for j in range(i)),
                    "Axis supports are not orthogonal",
                )
                maximum = max(t)
                if maximum:
                    weights = [max(value / maximum - Fraction(1, 2), 0) for value in t]
                    denominator = sum(weights)
                    require(denominator >= Fraction(1, 2), "Vanishing denominator")
                    r = [value / denominator for value in weights]
                    require(sum(r) == 1, "Weights do not sum to one")
                    require(all(r[i] == 0 for i in range(k) if t[i] == 0), "Zero face")
                    for j, value in enumerate(y):
                        if value:
                            require(
                                delta < t[j]
                                and all(t[i] < delta / 2 for i in range(k) if i != j)
                                and r == [Fraction(i == j) for i in range(k)]
                                and h == 1,
                                "The axis is not the exact localized vertex",
                            )
                else:
                    require(h == 0 and not any(y), "Origin assignment")
                count += 1

    sizes = config["matrix_sizes"]
    require(sizes == [2, 3, 4, 5] and config["maximum_N"] == 32, "Parameter supplement")
    parameters = 0
    for d in sizes:
        for n in range(1, config["maximum_N"] + 1):
            first_l = 1
            while d ** first_l < n:
                first_l += 1
            for length in (first_l, first_l + 1):
                k = n ** length
                m = k + length
                require(length >= 1 and d ** length >= n and k >= 1 and m >= 1, "Exponents")
                words = sum(1 for _ in itertools.product(range(d), repeat=length))
                require(words == d ** length, "Incorrect tensor-word count")
                parameters += 1
    return count, parameters


def verify_lean_binding(config):
    require(config["claim"] == "C_CONE_FORMAL", "Wrong formal claim")
    certificate = read_json(artifact(config["certificate"]))
    check = certificate["lean_check"]
    require(
        check["status"] == "success"
        and check["exit_code"] == 0
        and check["audit_exit_code"] == 0
        and check["proof_holes"] == []
        and check["environment_failure"] == "",
        "No successful proof-hole-free compiler and audit result",
    )
    require("version 4.31.0" in check["tools"]["lean"]["version"], "Wrong Lean version")
    source = artifact(config["source"]).read_text(encoding="utf-8")
    fidelity = artifact(config["statement_fidelity"]).read_text(encoding="utf-8")
    for text, embedded, copied, digest in (
        (source, certificate["lean_source"]["text"], check["source"], check["source_sha256"]),
        (
            fidelity, certificate["statement_fidelity"]["text"],
            check["statement_fidelity"], check["statement_fidelity_sha256"],
        ),
    ):
        copied_path = Path(copied).resolve()
        require(copied_path.is_relative_to(ROOT), "Compiler copy escaped the owned tree")
        require(
            text == embedded == copied_path.read_text(encoding="utf-8")
            and hashlib.sha256(text.encode("utf-8")).hexdigest() == digest,
            "The live source or its statement fidelity differs from the compiler input",
        )
    require(
        certificate["subject"]["subject_id"] == config["claim"]
        and certificate["tier"] == "mechanical"
        and certificate["verdict"] == "supports",
        "Unbound mechanical evidence",
    )
    state = read_json(ROOT.parent / "MATH_STATE.json")
    claims = [claim for claim in state["claims"] if claim["claim_id"] == config["claim"]]
    require(bool(claims), "The formal claim is missing from the campaign ledger")
    current = max(claims, key=lambda claim: claim["version"])
    require(
        current["content_hash"] == certificate["subject"]["content_hash"]
        and current["formal_statement"] == source,
        "The compiler certificate is not about the current formal claim",
    )
    require(
        any(
            evidence["evidence_id"] == certificate["evidence_id"]
            and evidence["artifact"] == str(artifact(config["certificate"]).relative_to(ROOT.parent.parent))
            for evidence in state["evidence"]
        ),
        "The kernel result is not recorded in the campaign ledger",
    )


def verify(certificate, self_test):
    require(
        certificate["format"] == "cone-drop-exact-v1"
        and certificate["claim"] == "C_CONE_GENERAL",
        "Wrong theorem certificate",
    )
    commutative, noncommutative = verify_identities(certificate)
    jacobian = certificate["jacobian"]
    payload = read_json(artifact(jacobian["payload"]))
    result = read_json(artifact(jacobian["typed_result"]))
    status = read_json(artifact(jacobian["adapter_status"]))
    verify_jacobian(payload, result, status)
    boundary, parameters = verify_finite_supplements(certificate["finite_boundary_experiments"])
    verify_lean_binding(certificate["lean"])
    rejected = 0
    if self_test:
        bad_identity = deepcopy(certificate)
        bad_identity["commutative_identities"][0]["ideal"][0]["multiplier"] = "1/3"
        bad_result = deepcopy(result)
        bad_result["result"]["output"]["value"]["entries"][0][0]["num"] = "1"
        for replay in (
            lambda: verify_identities(bad_identity),
            lambda: verify_jacobian(payload, bad_result, status),
        ):
            try:
                replay()
            except ValueError:
                rejected += 1
            else:
                raise ValueError("An intentionally false certificate was accepted")
    return {
        "status": "verified",
        "universal_polynomial_identities": commutative,
        "universal_noncommutative_identities": noncommutative,
        "jacobian_exact_value_replayed": True,
        "finite_rational_cube_points": boundary,
        "finite_amplification_parameter_cases": parameters,
        "lean": "Recorded Lean 4.31.0 compiler/audit success; live source and fidelity match",
        "lean_recompiled_by_this_script": False,
        "tamper_cases_rejected": rejected,
        "scope": "Universal supporting certificates plus finite supplements; C*-proof is in report.md",
        "independent_review": "pending Host Reviewer",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    parser.add_argument("--self-test", action="store_true", help="Reject two false certificate mutations")
    args = parser.parse_args()
    result = verify(read_json(args.certificate), args.self_test)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
