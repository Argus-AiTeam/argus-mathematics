#!/usr/bin/env python3
"""Replay the exact sharpness family and the source-bound Lean evidence."""

import argparse
from fractions import Fraction as Q
from hashlib import sha256
from itertools import product
import json
from math import prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SIZES = (3, 4, 5, 6, 8, 12)
ZERO = ()
ONE = (Q(1),)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def canonical(coefficients):
    result = list(map(Q, coefficients))
    while result and result[-1] == 0:
        result.pop()
    return tuple(result)


def add(a, b):
    return canonical([
        (a[k] if k < len(a) else 0) + (b[k] if k < len(b) else 0)
        for k in range(max(len(a), len(b)))
    ])


def scale(a, scalar):
    return canonical([scalar * x for x in a])


def multiply(a, b):
    if not a or not b:
        return ZERO
    result = [Q(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            result[i + j] += x * y
    return canonical(result)


def evaluate(a, t):
    result = Q(0)
    for coefficient in reversed(a):
        result = result * t + coefficient
    return result


def newton(nodes, values):
    require(len(nodes) == len(values) > 0, "Invalid interpolation dimensions")
    require(len(set(nodes)) == len(nodes), "Repeated interpolation node")
    coefficients = list(map(Q, values))
    for order in range(1, len(nodes)):
        for j in range(len(nodes) - 1, order - 1, -1):
            coefficients[j] = (
                (coefficients[j] - coefficients[j - 1]) / (nodes[j] - nodes[j - order])
            )
    polynomial, basis = ZERO, ONE
    for node, coefficient in zip(nodes, coefficients):
        polynomial = add(polynomial, scale(basis, coefficient))
        basis = multiply(basis, (-Q(node), Q(1)))
    require(all(evaluate(polynomial, t) == v for t, v in zip(nodes, values)),
            "Interpolation replay failed")
    return coefficients, polynomial


def identity(n):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def matrix_add(a, b):
    return [[add(x, y) for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def matrix_scale(a, scalar):
    return [[scale(x, scalar) for x in row] for row in a]


def matrix_multiply(a, b):
    n = len(a)
    result = [[ZERO for _ in range(n)] for _ in range(n)]
    for i, j, k in product(range(n), repeat=3):
        result[i][j] = add(result[i][j], multiply(a[i][k], b[k][j]))
    return result


def in_polynomial_group(a):
    n = len(a)
    require(all(len(row) == n for row in a), "Nonsquare matrix")
    return all(
        (a[i][j] == (ONE if i == j else ZERO)) if j <= i else len(a[i][j]) <= j - i + 1
        for i, j in product(range(n), repeat=2)
    )


def inverse(a):
    require(in_polynomial_group(a), "Matrix outside the declared polynomial group")
    n = len(a)
    minus_x = matrix_add(identity(n), matrix_scale(a, -1))
    result, power = identity(n), identity(n)
    for _ in range(1, n):
        power = matrix_multiply(power, minus_x)
        result = matrix_add(result, power)
    require(matrix_multiply(power, minus_x) == [[ZERO] * n for _ in range(n)],
            "Strict-upper nilpotency failed")
    return result


def commutator(a, b):
    return matrix_multiply(matrix_multiply(matrix_multiply(a, b), inverse(a)), inverse(b))


def transvection(n, i, j):
    result = identity(n)
    result[i][j] = ONE
    return result


def at(a, t):
    return [[evaluate(entry, t) for entry in row] for row in a]


def in_image(values):
    s, n = len(values), len(values[0])
    require(all(len(a) == n and all(len(row) == n for row in a) for a in values),
            "Invalid evaluation tuple")
    for a in values:
        require(all(a[i][j] == (1 if i == j else 0)
                    for i in range(n) for j in range(i + 1)),
                "Tuple entry is not unitriangular")
    for i in range(n):
        for j in range(i + 1, n):
            _, polynomial = newton(tuple(range(s)), [a[i][j] for a in values])
            if len(polynomial) > j - i + 1:
                return False
    return True


def dense_polynomial_matrix(n, offset):
    result = identity(n)
    for i in range(n):
        for j in range(i + 1, n):
            result[i][j] = canonical([
                Q((-1) ** (k + offset) * (i + j + k + offset + 1), k + 1)
                for k in range(j - i + 1)
            ])
    return result


def check_family(s):
    require(type(s) is int and s >= 3, "The sharpness family requires integer s>=3")
    c, n = s - 2, s - 1
    nodes = tuple(range(s))
    basis = [(i, j, d) for i in range(n) for j in range(i + 1, n)
             for d in range(j - i + 1)]
    nonzero_products = 0
    for (i, j, d), (k, l, e) in product(basis, repeat=2):
        if j == k:
            require(i < j < l and d + e <= l - i, "Algebra degree closure failed")
            nonzero_products += 1

    weights = [Q(1, prod(i - j for j in nodes if j != i)) for i in nodes]
    moments = [sum(w * Q(t) ** d for w, t in zip(weights, nodes)) for d in range(c + 1)]
    require(all(x == 0 for x in moments), "Evaluation-code annihilator failed")
    require(all(w != 0 for w in weights), "A supported coordinate is not separated")

    recipes = []
    for alpha, beta in product(nodes, repeat=2):
        if alpha == beta:
            continue
        first = (Q(beta, beta - alpha), Q(-1, beta - alpha))
        second = (Q(-alpha, beta - alpha), Q(1, beta - alpha))
        require((evaluate(first, alpha), evaluate(first, beta)) == (1, 0),
                "First interpolation basis failed")
        require((evaluate(second, alpha), evaluate(second, beta)) == (0, 1),
                "Second interpolation basis failed")
        recipes.append({
            "pair": [alpha, beta],
            "first": list(map(str, first)),
            "second": list(map(str, second)),
        })

    for i in range(n):
        for j in range(i + 1, n):
            diagonal = transvection(n, i, j)
            require(in_image([at(diagonal, t) for t in nodes]), "Constant diagonal failed")
            for degree in range(j - i + 1):
                values = [Q(t) ** degree for t in nodes]
                _, recovered = newton(nodes, values)
                require(recovered == (Q(0),) * degree + ONE, "Basis evaluation is not faithful")

    a, b = dense_polynomial_matrix(n, 1), dense_polynomial_matrix(n, 2)
    ab, ai = matrix_multiply(a, b), inverse(a)
    require(in_polynomial_group(ab) and in_polynomial_group(ai), "Group closure failed")
    require(matrix_multiply(a, ai) == identity(n), "Right inverse failed")
    require(matrix_multiply(ai, a) == identity(n), "Left inverse failed")
    fraction = matrix_multiply(a, inverse(b))
    require(in_image([at(fraction, t) for t in nodes]), "An actual fraction left M")
    require(in_image([at(identity(n), t) for t in nodes]), "Identity fraction failed")

    witness = transvection(n, 0, 1)
    for k in range(1, c):
        witness = commutator(witness, transvection(n, k, k + 1))
        require(witness == transvection(n, 0, k + 1), "Nested commutator identity failed")
    require(witness == transvection(n, 0, c) and witness != identity(n),
            "The gamma_(s-2) witness is trivial")
    excluded = []
    for i in nodes:
        supported = [at(witness if k == i else identity(n), 0) for k in nodes]
        require(not in_image(supported), "A nontrivial supported witness entered M")
        require(sum(weights[k] * supported[k][0][c] for k in nodes) == weights[i],
                "Witness separation functional has wrong orientation")
        excluded.append(i)

    return {
        "s": s,
        "matrix_size": n,
        "nilpotency_class": c,
        "nodes": list(nodes),
        "algebra_dimension": len(basis),
        "basis_products_checked": len(basis) ** 2,
        "nonzero_basis_products": nonzero_products,
        "annihilator_weights": list(map(str, weights)),
        "annihilated_degrees": list(range(c + 1)),
        "moment_sums": list(map(str, moments)),
        "all_ordered_pair_lifts": recipes,
        "diagonal_matrix_units_checked": n * (n - 1) // 2,
        "group_product_and_two_sided_inverse": True,
        "actual_fraction_membership": True,
        "supported_identity_fraction": True,
        "nested_commutator_length": c,
        "witness_entry": [0, c, "1"],
        "nontrivial_supported_witness_excluded_at": excluded,
    }


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "polynomial.interpolation.newton_form.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not complete successfully")
    require(result["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian payload differs")
    require(result["result"]["operation_id"] == operation and "error" not in result,
            "Jacobian has no usable typed mathematical result")
    rational = lambda x: Q(int(x["num"]), int(x["den"]))
    nodes = list(map(rational, payload["samples"]["nodes"]))
    values = list(map(rational, payload["samples"]["values"]))
    expected, polynomial = newton(nodes, values)
    output = result["result"]["output"]
    require(list(map(rational, output["nodes"])) == nodes, "Jacobian nodes differ")
    require(list(map(rational, output["coefficients"])) == expected,
            "Independent Newton replay disagrees with Jacobian")
    require(len(polynomial) - 1 == 4 and expected[-1] == Q(1, 4),
            "The s=5 supported interpolation obstruction failed")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "newton_coefficients": list(map(str, expected)),
        "supported_polynomial_degree": len(polynomial) - 1,
        "scope": "A bounded s=5 cross-check, not the universal theorem",
    }


def check_lean():
    record = json.loads((HERE / "lean_check.json").read_text())
    require(record["status"] == "success" and record["exit_code"] == 0,
            "Lean compiler did not succeed")
    require(record["audit_exit_code"] == 0 and record["proof_holes"] == [],
            "Lean axiom audit failed or found proof holes")
    require(record["environment_failure"] == "", "Lean environment is unverified")
    require("version 4.31.0," in record["tools"]["lean"]["version"], "Wrong Lean version")
    require(record["source_sha256"] == sha256((HERE / "Main.lean").read_bytes()).hexdigest(),
            "Lean source changed after certification")
    require(record["statement_fidelity_sha256"] ==
            sha256((HERE / "statement_fidelity.md").read_bytes()).hexdigest(),
            "Statement fidelity changed after certification")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((x for x in state["claims"] if x["claim_id"] == "C172_LOWER_CENTRAL"),
                key=lambda x: x["version"])
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C172_LOWER_CENTRAL"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(len(evidence) == 1, "Missing or ambiguous current mechanical evidence")
    binding = evidence[0]
    archive_path = ROOT / binding["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == record, "Compiler result differs from its archive")
    require(archive["lean_source"]["text"].encode() == (HERE / "Main.lean").read_bytes(),
            "Archived Lean source differs")
    require(archive["statement_fidelity"]["text"].encode() ==
            (HERE / "statement_fidelity.md").read_bytes(), "Archived fidelity differs")
    require(archive["subject"] == binding["subject"], "Claim binding differs")
    require(archive["evidence_id"] == binding["evidence_id"]
            and archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "The archive does not certify the recorded mechanical evidence")
    require(claim["formal_statement"] == (HERE / "Main.lean").read_text(),
            "Ledger formalization differs")
    require(claim["external_assumptions"] == [], "The inclusion relies on an unproved assumption")
    require(claim["content_hash"] == archive["subject"]["content_hash"], "Stale claim")
    accepted_path = ROOT / (
        "research/endpoint_bridge/certificates/C172_ENDPOINT_BRIDGE-e19a2382289ef811.json"
    )
    accepted = json.loads(accepted_path.read_text())
    require(accepted["lean_source"]["text"].encode() ==
            (ROOT / "research/endpoint_bridge/Main.lean").read_bytes(),
            "The accepted dependency source was changed")
    require(accepted["lean_check"]["exit_code"] == 0
            and accepted["lean_check"]["audit_exit_code"] == 0
            and accepted["lean_check"]["proof_holes"] == [],
            "The accepted dependency has no successful hole-free compiler record")
    for declaration in (
        "actual_right_fraction", "lower_inclusion", "derived_le_lower_pow", "endpoint_bridge_depth"
    ):
        report = (f"'LowerCentralBridge.{declaration}' depends on axioms: "
                  "[propext, Classical.choice, Quot.sound]")
        require(report in record["stdout"], f"Missing restricted axiom report: {declaration}")
    return {
        "claim": "C172_LOWER_CENTRAL",
        "compiler_exit_code": record["exit_code"],
        "axiom_audit_exit_code": record["audit_exit_code"],
        "proof_holes": record["proof_holes"],
        "archive": str(archive_path.relative_to(ROOT)),
        "accepted_source_unchanged": True,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--s", type=int, help="Replay one further sharpness instance, s>=3")
    parser.add_argument("--write", action="store_true", help="Write the canonical exact certificate")
    args = parser.parse_args()
    require(not (args.write and args.s is not None), "--write uses the canonical replay sizes")
    sizes = SIZES if args.s is None else (args.s,)
    certificate = {
        "claim": "C172_LOWER_SHARPNESS",
        "family_domain": "Every integer s>=3, proved parametrically in theorem.md",
        "construction": "K=UT_(s-1)(Q); polynomial entry degrees <= column-row; s evaluations",
        "universal_supported_fraction_subgroups": "L_i={1}",
        "universal_witness": "left-nested adjacent-transvection commutator 1+E_(0,s-2)",
        "finite_replay_is_not_universal_proof": True,
        "instances": [check_family(s) for s in sizes],
        "jacobian": check_jacobian(),
        "lean": check_lean(),
    }
    if args.write:
        (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    elif args.s is None:
        stored = json.loads((HERE / "exact_certificate.json").read_text())
        require(stored == certificate, "Stored exact certificate differs from replay")
    print(json.dumps({
        "status": "success",
        "replayed_s": list(sizes),
        "basis_products_checked": sum(x["basis_products_checked"] for x in certificate["instances"]),
        "ordered_pair_projections_checked": sum(
            len(x["all_ordered_pair_lifts"]) for x in certificate["instances"]
        ),
        "supported_witness_exclusions": sum(sizes),
        "lean": certificate["lean"],
        "universal_proof": "research/lower_central_bridge/theorem.md",
        "independent_review": "Host-invoked Reviewer required",
    }, indent=2))


if __name__ == "__main__":
    main()
