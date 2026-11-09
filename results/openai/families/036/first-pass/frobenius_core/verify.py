#!/usr/bin/env python3
"""Replay exact algebra; geometric hypotheses are proved separately in REPORT.md."""

import argparse
import ast
import copy
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
IDENTITIES = {
    "product_chord_induction": (
        ["a", "b", "A", "B", "t", "Y"],
        "a*A+t*((a+b)*B-a*A)-(a+b*t)*Y",
        "(a+b*t)*(A+t*(B-A)-Y)+b*(B-A)*t*(1-t)",
    ),
    "determinant_class_error": (
        ["p", "D", "T", "a", "K", "lam", "S"],
        "2*(p*D+T-a*D)+(p-1)*K+2*p*lam*S",
        "2*p*(D+K/2+lam*S)+2*(T-a*D-K/2)",
    ),
    "jet_order_difference": (
        ["n", "p", "a"],
        "(2*n+2)*(p-a)-(2*n+1)*(p-1)",
        "p-(2*n+2)*a+(2*n+1)",
    ),
    "complement_exponent": (["x", "p"], "x+(p-1-x)", "p-1"),
    "multiplicity_gap": (["R", "B", "U"], "(R-R*B)-R*U", "R*(1-B-U)"),
}
CASES = [(2, 2), (2, 3), (2, 5), (3, 2), (3, 3)]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def add(a, b):
    result = a.copy()
    for exponent, coefficient in b.items():
        result[exponent] = result.get(exponent, Fraction(0)) + coefficient
        if not result[exponent]:
            del result[exponent]
    return result


def scale(a, scalar):
    return {e: scalar * c for e, c in a.items() if scalar * c}


def multiply(a, b):
    result = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            exponent = tuple(x + y for x, y in zip(ea, eb))
            result = add(result, {exponent: ca * cb})
    return result


def polynomial(text, variables):
    zero = (0,) * len(variables)

    def constant(value):
        return {zero: Fraction(value)} if value else {}

    def parse(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return constant(node.value)
        if isinstance(node, ast.Name) and node.id in variables:
            exponent = [0] * len(variables)
            exponent[variables.index(node.id)] = 1
            return {tuple(exponent): Fraction(1)}
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
            return scale(parse(node.operand), -1)
        require(isinstance(node, ast.BinOp), "non-polynomial syntax")
        left = parse(node.left)
        if isinstance(node.op, ast.Pow):
            require(
                isinstance(node.right, ast.Constant)
                and type(node.right.value) is int
                and 0 <= node.right.value <= 16,
                "nonconstant or oversized exponent",
            )
            result = constant(1)
            for _ in range(node.right.value):
                result = multiply(result, left)
            return result
        right = parse(node.right)
        if isinstance(node.op, ast.Add):
            return add(left, right)
        if isinstance(node.op, ast.Sub):
            return add(left, scale(right, -1))
        if isinstance(node.op, ast.Mult):
            return multiply(left, right)
        if isinstance(node.op, ast.Div):
            require(
                set(right) == {zero} and right[zero] != 0,
                "division by a variable or zero",
            )
            return scale(left, 1 / right[zero])
        raise ValueError("unsupported polynomial operation")

    return parse(ast.parse(text, mode="eval").body)


def rational(value):
    require(isinstance(value, str), "rational must be a canonical string")
    result = Fraction(value)
    require(str(result) == value, "noncanonical rational")
    return result


def positive_integer(value):
    require(type(value) is int and value > 0, "positive integer required")
    return value


def prime(p):
    return p >= 2 and all(p % d for d in range(2, math.isqrt(p) + 1))


def univariate_product(factors):
    coefficients = [Fraction(1)]
    for constant, linear in factors:
        result = [Fraction(0)] * (len(coefficients) + 1)
        for i, c in enumerate(coefficients):
            result[i] += c * constant
            result[i + 1] += c * linear
        coefficients = result
    return coefficients


def scalar_fixture(fixture):
    require(
        set(fixture)
        == {"n", "k0", "epsilon", "h", "l", "c0", "curve_error", "p", "expected"},
        "unexpected scalar fixture fields",
    )
    n = positive_integer(fixture["n"])
    k0 = positive_integer(fixture["k0"])
    p = positive_integer(fixture["p"])
    require(2 <= n <= 12, "fixture dimension outside the replay budget")
    l = fixture["l"]
    require(isinstance(l, list) and len(l) == n - 1, "wrong flag length")
    for li in l:
        positive_integer(li)
    epsilon, h, c0, curve_error = (
        rational(fixture[k]) for k in ("epsilon", "h", "c0", "curve_error")
    )
    require(epsilon > 0 and h > 0 and c0 >= 0 and curve_error >= 0, "invalid signs")
    require(h <= (2 * epsilon) ** n, "small volume hypothesis fails")
    require((14 * epsilon) ** n < Fraction(1, 4), "rank gap is not strict")
    require(80 * epsilon < Fraction(3, 4), "order gap is not strict")
    flag_product = math.prod(l)
    a = 7 * flag_product * h
    degrees = [li * flag_product * h for li in l]
    factors = [(c0 + 1, a)] + [(1 + c0 / d, a / d) for d in degrees]
    coefficients = univariate_product(factors)
    leading = 7**n * h
    require(coefficients[-1] == leading, "flag leading coefficient is wrong")
    rank_error = sum(coefficients[:-1])
    require(
        rank_error == (a + c0 + 1) * math.prod(1 + (a + c0) / d for d in degrees)
        - leading,
        "two definitions of rank error disagree",
    )
    require(all(c >= 0 for c in coefficients), "negative flag coefficient")
    rank_threshold = math.floor(rank_error / (Fraction(1, 4) - leading)) + 1
    order_threshold = math.floor(
        2 * curve_error / (Fraction(3, 4) - 80 * epsilon)
    ) + 1
    jet_threshold = (2 * n + 2) * (k0 - 1)
    threshold = max(2, k0, jet_threshold, rank_threshold, order_threshold)
    expected = {
        "leading": str(leading),
        "rank_error": str(rank_error),
        "rank_threshold": rank_threshold,
        "order_threshold": order_threshold,
        "jet_threshold": jet_threshold,
        "threshold": threshold,
    }
    require(fixture["expected"] == expected, "corrupt scalar output")
    require(prime(p) and p >= threshold, "fixture prime is below the certified threshold")
    normalized = sum(c * Fraction(p) ** (i - n) for i, c in enumerate(coefficients))
    require(normalized <= leading + rank_error / p < Fraction(1, 4), "rank budget fails")
    require(80 * epsilon + 2 * curve_error / p < Fraction(3, 4), "order budget fails")
    require(
        (2 * n + 1) * (p - 1) <= (2 * n + 2) * k0 * (p // k0),
        "Frobenius jet containment fails",
    )
    return {"n": n, "p": p, **expected}


def truncated_multiply(a, b, p):
    result = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            exponent = tuple(x + y for x, y in zip(ea, eb))
            if all(e < p for e in exponent):
                result[exponent] = (result.get(exponent, 0) + ca * cb) % p
    return {e: c for e, c in result.items() if c}


def determinant(matrix, p):
    n = len(matrix)
    total = 0
    for permutation in itertools.permutations(range(n)):
        inversions = sum(
            permutation[i] > permutation[j] for i in range(n) for j in range(i + 1, n)
        )
        total += (-1) ** inversions * math.prod(matrix[i][permutation[i]] for i in range(n))
    return total % p


def truncated_case(n, p):
    require((n, p) in CASES, "unexpected finite experiment")
    exponents = list(itertools.product(range(p), repeat=n))
    top = (p - 1,) * n
    require(len(exponents) == p**n, "wrong truncated rank")
    for alpha in exponents:
        beta = tuple(p - 1 - e for e in alpha)
        require(tuple(p - 1 - e for e in beta) == alpha, "complement is not involutive")
        require(sum(alpha) + sum(beta) == n * (p - 1), "socle degree pairing fails")
        require(
            truncated_multiply({alpha: 1}, {beta: 1}, p) == {top: 1},
            "complementary multiplication is not the top monomial",
        )
    for coordinate in range(n):
        require(
            2 * sum(a[coordinate] for a in exponents) == p**n * (p - 1),
            "determinant character weight sum fails",
        )
    identity = [[int(i == j) for j in range(n)] for i in range(n)]
    matrices = [identity]
    for i in range(n):
        for scalar in range(1, p):
            matrix = copy.deepcopy(identity)
            matrix[i][i] = scalar
            matrices.append(matrix)
        for j in range(n):
            if i != j:
                matrix = copy.deepcopy(identity)
                matrix[i], matrix[j] = matrix[j], matrix[i]
                matrices.append(matrix)
                for scalar in range(1, p):
                    matrix = copy.deepcopy(identity)
                    matrix[i][j] = scalar
                    matrices.append(matrix)
    for matrix in matrices:
        result = {(0,) * n: 1}
        for row in matrix:
            linear = {
                tuple(int(i == j) for i in range(n)): coefficient
                for j, coefficient in enumerate(row) if coefficient
            }
            for _ in range(p - 1):
                result = truncated_multiply(result, linear, p)
        expected = pow(determinant(matrix, p), p - 1, p)
        require(result == {top: expected}, "socle frame character fails")
    return len(exponents), len(matrices)


def rational_rank(matrix):
    rows = [list(map(Fraction, row)) for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(rank, len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        pivot_value = rows[rank][column]
        rows[rank] = [value / pivot_value for value in rows[rank]]
        for i in range(len(rows)):
            if i != rank:
                multiplier = rows[i][column]
                rows[i] = [a - multiplier * b for a, b in zip(rows[i], rows[rank])]
        rank += 1
        if rank == len(rows):
            break
    return rank


def vanishing_order(poly):
    require(bool(poly), "the zero germ has no finite vanishing order")
    return min(map(sum, poly))


def determinant_case(case):
    require(
        case == {
            "variables": ["x", "y"],
            "entry_alphabet": ["0", "1", "x", "y", "1+x"],
            "matrix_size": 2,
            "matrices": 625,
        },
        "determinant experiment changed",
    )
    alphabet = [polynomial(entry, case["variables"]) for entry in case["entry_alphabet"]]
    nonzero = 0
    for a, b, c, d in itertools.product(alphabet, repeat=4):
        det = add(multiply(a, d), scale(multiply(b, c), -1))
        rank = rational_rank([[entry.get((0, 0), 0) for entry in row]
                              for row in ((a, b), (c, d))])
        if det:
            require(vanishing_order(det) >= 2 - rank, "rank-defect order bound fails")
            nonzero += 1
    return nonzero


def reduce_coefficients(poly, p):
    result = {}
    for exponent, coefficient in poly.items():
        coefficient = Fraction(coefficient)
        require(coefficient.denominator % p != 0, "coefficient has a bad denominator")
        residue = coefficient.numerator * pow(coefficient.denominator, -1, p) % p
        if residue:
            result[exponent] = residue
    return result


def tensor_case(case):
    require(
        case == {
            "prime": 3,
            "first_basis": ["1+x", "1+2*x"],
            "second_basis": ["1+y", "1+2*y"],
            "nonzero_factor_vectors": 8,
            "nonzero_tensors": 80,
            "maximum_factor_orders": [1, 1],
            "maximum_tensor_order": 2,
        },
        "tensor experiment changed",
    )
    p = case["prime"]
    first = [polynomial(entry, ["x", "y"]) for entry in case["first_basis"]]
    second = [polynomial(entry, ["x", "y"]) for entry in case["second_basis"]]
    for basis, forbidden_coordinate in ((first, 1), (second, 0)):
        require(all(e[forbidden_coordinate] == 0 for poly in basis for e in poly),
                "tensor factors do not use disjoint parameters")
    maxima = []
    for basis in (first, second):
        orders = []
        for coefficients in itertools.product(range(p), repeat=2):
            if any(coefficients):
                poly = {}
                for coefficient, entry in zip(coefficients, basis):
                    poly = add(poly, scale(entry, coefficient))
                orders.append(vanishing_order(reduce_coefficients(poly, p)))
        require(len(orders) == case["nonzero_factor_vectors"], "factor coverage changed")
        maxima.append(max(orders))
    require(maxima == case["maximum_factor_orders"], "wrong factor maximum order")
    orders = []
    products = [multiply(f, g) for f in first for g in second]
    for coefficients in itertools.product(range(p), repeat=4):
        if any(coefficients):
            poly = {}
            for coefficient, entry in zip(coefficients, products):
                poly = add(poly, scale(entry, coefficient))
            order = vanishing_order(reduce_coefficients(poly, p))
            require(order <= sum(maxima), "external-product order upper bound fails")
            orders.append(order)
    require(len(orders) == case["nonzero_tensors"], "tensor coverage changed")
    require(max(orders) == case["maximum_tensor_order"], "wrong tensor maximum order")
    require(all(vanishing_order(entry) == 0 for entry in first + second),
            "fixture no longer tests cancellation in an unadapted basis")
    return len(orders)


def jacobian_replay(record):
    require(
        record == {
            "operation_id": "prime_field.matrix.rank.compute",
            "payload": "jacobian_rank_payload.json",
            "output": "jacobian_rank_result.json",
            "expected_prime": 3,
            "expected_rank": 3,
            "scope": "bounded_torus_quotient_only",
        },
        "Jacobian evidence scope changed",
    )
    payload = json.loads((ROOT / record["payload"]).read_text())
    output = json.loads((ROOT / record["output"]).read_text())
    require(output["server"]["version"] == "0.14.0", "unexpected Jacobian version")
    require(output["protocol_version"] == "2025-11-25", "unexpected bridge protocol")
    require(output["request"]["payload"] == payload, "Jacobian source payload differs")
    require(output["result"]["operation_id"] == record["operation_id"], "wrong operation")
    result = output["result"]["output"]
    require(result["source"] == payload and result["prime"] == 3, "source binding fails")
    matrix = payload["matrix"]["entries"]
    require(
        matrix == [[int(j % 3 == i) for j in range(7)] for i in range(3)],
        "not the declared torus quotient matrix",
    )
    require(matrix[0][:3] == [1, 0, 0], "constant coordinate is wrong")
    require(result["rank"] == 3, "typed rank is incorrect")
    require(determinant([row[:3] for row in matrix], 3) == 1, "rank witness fails")
    require(len(matrix) == 3, "rank upper bound fails")


def validate(certificate):
    require(
        set(certificate) == {
            "schema_version", "target", "claim", "classification",
            "geometry_formalized", "independent_review", "identities",
            "scalar_fixtures", "truncated_cases", "determinant_case",
            "tensor_case", "jacobian",
        },
        "unexpected certificate fields",
    )
    require(certificate["schema_version"] == 1, "unknown certificate schema")
    require(certificate["target"] == "thm:finite-data", "target changed")
    require(certificate["claim"] == "C9000036-FROB", "claim changed")
    require(
        certificate["classification"] == "universal_algebraic_verification_with_geometric_proof"
        and certificate["geometry_formalized"] is False
        and certificate["independent_review"] == "pending",
        "certificate overstates its proof or review boundary",
    )
    identities = certificate["identities"]
    require([i["name"] for i in identities] == list(IDENTITIES), "missing or reordered identity")
    for row in identities:
        require(set(row) == {"name", "variables", "left", "right"}, "identity fields changed")
        variables, left, right = IDENTITIES[row["name"]]
        require(row["variables"] == variables, "identity variables changed")
        lhs, rhs = polynomial(row["left"], variables), polynomial(row["right"], variables)
        require(lhs == polynomial(left, variables), "identity left side was weakened")
        require(rhs == polynomial(right, variables), "identity right side was weakened")
        require(lhs == rhs, "polynomial identity is false")
    require(len(certificate["scalar_fixtures"]) == 2, "missing scalar fixture")
    scalars = [scalar_fixture(f) for f in certificate["scalar_fixtures"]]
    require(
        [(c["n"], c["p"]) for c in certificate["truncated_cases"]] == CASES,
        "finite experiment coverage changed",
    )
    dimensions, matrices = 0, 0
    for case in certificate["truncated_cases"]:
        require(set(case) == {"n", "p"}, "truncated case fields changed")
        dimension, count = truncated_case(case["n"], case["p"])
        dimensions += dimension
        matrices += count
    nonzero_determinants = determinant_case(certificate["determinant_case"])
    tensors = tensor_case(certificate["tensor_case"])
    jacobian_replay(certificate["jacobian"])
    return {"universal_identities": len(identities), "basis_monomials": dimensions,
            "socle_frame_tests": matrices, "scalar_fixtures": scalars,
            "determinant_matrices": certificate["determinant_case"]["matrices"],
            "nonzero_determinants": nonzero_determinants,
            "nonzero_tensors": tensors}


def corruption_tests(certificate):
    mutations = [
        lambda c: c["identities"][0].update(right="0"),
        lambda c: c["identities"][1].update(left="0", right="0"),
        lambda c: c["scalar_fixtures"][0]["expected"].update(rank_error="0"),
        lambda c: c["scalar_fixtures"][0].update(c0="-1"),
        lambda c: c["scalar_fixtures"][0].update(p=3),
        lambda c: c.update(geometry_formalized=True),
        lambda c: c.update(independent_review="accepted"),
        lambda c: c["jacobian"].update(expected_rank=2),
        lambda c: c["truncated_cases"].pop(),
        lambda c: c["determinant_case"].update(matrices=624),
        lambda c: c["tensor_case"].update(prime=2),
    ]
    for index, mutate in enumerate(mutations, 1):
        corrupt = copy.deepcopy(certificate)
        mutate(corrupt)
        try:
            validate(corrupt)
        except ValueError:
            continue
        raise ValueError(f"corruption test {index} was incorrectly accepted")
    return len(mutations)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    try:
        certificate = json.loads(args.certificate.read_text())
        result = validate(certificate)
        if args.self_test:
            result["corruptions_rejected"] = corruption_tests(certificate)
    except (ValueError, KeyError, TypeError, OSError, SyntaxError) as error:
        print(f"INVALID CERTIFICATE: {error}")
        return 1
    print(json.dumps({"verified": True, **result,
                      "boundary": "Exact algebra only; geometric proof in REPORT.md; independent review pending."},
                     sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
