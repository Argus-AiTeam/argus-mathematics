#!/usr/bin/env python3
"""Exact diagnostics and source-bound formal-core replay; see report.md for the proof."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
Polynomial = dict[tuple[int, ...], Fraction]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def monomial(exponents: tuple[int, ...], coefficient=1) -> Polynomial:
    return {exponents: Fraction(coefficient)} if coefficient else {}


def constant(nvars: int, coefficient=1) -> Polynomial:
    return monomial((0,) * nvars, coefficient)


def variable(nvars: int, index: int) -> Polynomial:
    exponents = [0] * nvars
    exponents[index] = 1
    return monomial(tuple(exponents))


def add(left: Polynomial, right: Polynomial, factor=1) -> Polynomial:
    result = left.copy()
    for exponents, coefficient in right.items():
        value = result.get(exponents, Fraction(0)) + factor * coefficient
        if value:
            result[exponents] = value
        else:
            result.pop(exponents, None)
    return result


def scale(polynomial: Polynomial, factor) -> Polynomial:
    return {e: c * factor for e, c in polynomial.items() if c * factor}


def multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for e, c in left.items():
        for f, d in right.items():
            require(len(e) == len(f), "Polynomial coordinate axes differ")
            key = tuple(x + y for x, y in zip(e, f))
            result[key] = result.get(key, Fraction(0)) + c * d
    return {e: c for e, c in result.items() if c}


def power(polynomial: Polynomial, exponent: int, nvars: int) -> Polynomial:
    require(exponent >= 0, "Negative polynomial exponent")
    result = constant(nvars)
    factor = polynomial
    while exponent:
        if exponent % 2:
            result = multiply(result, factor)
        exponent //= 2
        if exponent:
            factor = multiply(factor, factor)
    return result


def partial(polynomial: Polynomial, index: int) -> Polynomial:
    result: Polynomial = {}
    for e, c in polynomial.items():
        if e[index]:
            key = list(e)
            key[index] -= 1
            result[tuple(key)] = c * e[index]
    return result


def direction(polynomial: Polynomial, source: range, target: range) -> Polynomial:
    result: Polynomial = {}
    require(len(source) == len(target), "Directional blocks differ in size")
    for i, j in zip(source, target):
        for e, c in partial(polynomial, i).items():
            key = list(e)
            key[j] += 1
            key = tuple(key)
            result[key] = result.get(key, Fraction(0)) + c
    return {e: c for e, c in result.items() if c}


def iterate(polynomial: Polynomial, operator, count: int) -> Polynomial:
    for _ in range(count):
        polynomial = operator(polynomial)
    return polynomial


def compositions(total: int, length: int):
    if length == 0:
        if total == 0:
            yield ()
        return
    for first in range(total, -1, -1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def exact_rank(columns) -> int:
    pivots = {}
    for original in columns:
        column = {row: Fraction(c) for row, c in original.items() if c}
        while column:
            pivot = min(column)
            coefficient = column[pivot]
            if pivot not in pivots:
                pivots[pivot] = {row: c / coefficient for row, c in column.items()}
                break
            column = add(column, pivots[pivot], -coefficient)
    return len(pivots)


def scalar_identities():
    n = variable(2, 0)
    w = variable(2, 1)
    one = constant(2)
    n1 = add(n, one)
    left = add(
        multiply(n1, add(w, n, -1)),
        add(w, scale(n1, -2)),
    )
    right = multiply(add(n, constant(2, 2)), add(add(w, n, -1), one, -1))
    require(left == right, "Universal power-commutator coefficient identity failed")
    r = n
    r2 = multiply(r, r)
    rm1 = add(r, one, -1)
    require(
        add(add(r2, r, -1), multiply(rm1, rm1), -1) == rm1,
        "Universal induction threshold identity failed",
    )
    require(
        add(r2, multiply(rm1, r), -1) == r,
        "Whole-power endpoint weight identity failed",
    )
    return {"universal_scalar_polynomial_identities": 3}


def commutator_diagnostics():
    cases = 0
    for n in (1, 2, 3):
        x, y = range(n), range(n, 2 * n)
        d = lambda f: direction(f, x, y)
        e = lambda f: direction(f, y, x)
        h = lambda f: {
            key: c * (sum(key[:n]) - sum(key[n:2 * n]))
            for key, c in f.items()
            if sum(key[:n]) != sum(key[n:2 * n])
        }
        for p, q in itertools.product(range(4), repeat=2):
            for alpha, beta in itertools.product(compositions(p, n), compositions(q, n)):
                f = monomial(alpha + beta + (2,))
                require(add(e(d(f)), d(e(f)), -1) == h(f), "ED-DE sign failed")
                require(add(h(d(f)), d(h(f)), -1) == scale(d(f), -2), "HD-DH failed")
                require(add(h(e(f)), e(h(f)), -1) == scale(e(f), 2), "HE-EH failed")
                require(not iterate(f, e, q + 1), "Raising local nilpotence failed")
                for k in range(4):
                    left = e(iterate(f, d, k + 1))
                    right = add(
                        iterate(e(f), d, k + 1),
                        scale(iterate(f, d, k), (k + 1) * (p - q - k)),
                    )
                    require(left == right, "Full power-commutator identity failed")
                cases += 1
    return {
        "basis_monomials_with_spectator": cases,
        "commutator_equalities": 3 * cases,
        "local_nilpotence_checks": cases,
        "power_commutator_equalities": 4 * cases,
    }


def joint_columns(n: int, r: int, length: int, j: int):
    basis = tuple(compositions(j, n))
    for blocks in itertools.product(basis, repeat=r):
        f = monomial(tuple(itertools.chain.from_iterable(blocks)) + (0,) * n)
        for i in range(r):
            d = lambda p, i=i: direction(p, range(i * n, (i + 1) * n), range(r * n, (r + 1) * n))
            f = iterate(f, d, length)
        yield f


def joint_rank_diagnostics():
    rows = []
    cases = (
        (0, 1, 1, 1), (0, 2, 1, 0), (1, 2, 1, 1), (1, 3, 2, 6),
        (2, 1, 2, 2), (2, 2, 1, 1), (2, 2, 1, 2),
        (3, 2, 1, 1), (3, 2, 1, 2),
        (2, 2, 2, 3), (2, 2, 2, 4), (2, 3, 1, 3), (3, 3, 1, 2),
    )
    for n, r, length, j in cases:
        dimension = len(tuple(compositions(j, n))) ** r
        rank = exact_rank(joint_columns(n, r, length, j))
        if j >= r * length:
            require(rank == dimension, "Joint operator failed inside the sufficient range")
        if n == r and j < r * length:
            require(rank < dimension, "Determinant obstruction was not reflected in rank")
        rows.append({"n": n, "r": r, "L": length, "j": j, "source_dimension": dimension, "rank": rank})
    require(rows[2]["rank"] == 1, "Fixed-dimension qualification was lost")
    return rows


def determinant(matrix, nvars: int) -> Polynomial:
    result: Polynomial = {}
    for permutation in itertools.permutations(range(len(matrix))):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(len(matrix)) for j in range(i + 1, len(matrix))
        )
        term = constant(nvars, (-1) ** inversions)
        for row, column in enumerate(permutation):
            term = multiply(term, matrix[row][column])
        result = add(result, term)
    return result


def determinant_data(r: int, with_t=False):
    nvars = r * r + r + (r if with_t else 0)
    matrix = [[variable(nvars, column * r + row) for column in range(r)] for row in range(r)]
    base = determinant(matrix, nvars)
    deltas = []
    for i in range(r):
        replacement = [
            [variable(nvars, r * r + row) if column == i else matrix[row][column] for column in range(r)]
            for row in range(r)
        ]
        deltas.append(determinant(replacement, nvars))
    return nvars, matrix, base, deltas


def determinant_diagnostics():
    for r in (1, 2, 3):
        nvars, matrix, base, deltas = determinant_data(r, with_t=True)
        updated = [
            [
                add(matrix[row][i], multiply(variable(nvars, r * r + r + i), variable(nvars, r * r + row)))
                for i in range(r)
            ]
            for row in range(r)
        ]
        expected = base
        for i in range(r):
            expected = add(expected, multiply(variable(nvars, r * r + r + i), deltas[i]))
        require(determinant(updated, nvars) == expected, "Unspecialized determinant rank-one update failed")
    rows = []
    for r, length in ((1, 1), (1, 3), (2, 1), (2, 2), (3, 1)):
        nvars, _, base, deltas = determinant_data(r)
        boundary = constant(nvars, math.factorial(r * length))
        for delta in deltas:
            boundary = multiply(boundary, power(delta, length, nvars))
        for j in range(r * length + 1):
            f = power(base, j, nvars)
            diagonal = [0] * nvars
            for i in range(r):
                diagonal[i * r + i] = j
            require(f.get(tuple(diagonal)) == 1, "Determinant witness is zero or misoriented")
            image = f
            for i in range(r):
                d = lambda p, i=i: direction(p, range(i * r, (i + 1) * r), range(r * r, r * r + r))
                image = iterate(image, d, length)
            expected = {} if j < r * length else boundary
            require(image == expected, "Exact determinant-power image failed")
            require(j < r * length or bool(image), "Endpoint determinant image must be nonzero")
            rows.append({"r": r, "L": length, "j": j, "source_terms": len(f), "image_terms": len(image)})
    return {"rank_one_update_identities": 3, "power_images": rows}


def canonical_data(n: int, a: int, b: int):
    inner = tuple(compositions(a, n))
    lower = tuple(sorted(compositions(b, n)))
    target = set(itertools.combinations_with_replacement(lower, a))
    averages = {}
    for alpha in inner:
        averages[alpha] = {}
    for word in itertools.product(range(n), repeat=a):
        alpha = tuple(word.count(k) for k in range(n))
        exponents = [0] * (a * n)
        for row, coordinate in enumerate(word):
            exponents[row * n + coordinate] += 1
        coefficient = Fraction(math.prod(math.factorial(k) for k in alpha), math.factorial(a))
        averages[alpha][tuple(exponents)] = coefficient
    columns = []
    source = tuple(itertools.combinations_with_replacement(inner, b))
    for factors in source:
        f = constant(a * n)
        for alpha in factors:
            f = multiply(f, averages[alpha])
        column = {}
        for exponents, coefficient in f.items():
            rows = tuple(sorted(exponents[i * n:(i + 1) * n] for i in range(a)))
            require(rows in target, "Canonical image has the wrong row degrees")
            column[rows] = column.get(rows, Fraction(0)) + coefficient
        columns.append(column)
    return source, target, columns


def canonical_diagnostics():
    rows = []
    cases = (
        (0, 2, 1), (0, 3, 4), (1, 2, 1), (1, 6, 25),
        (2, 2, 1), (3, 2, 1), (2, 2, 2), (3, 2, 2),
        (3, 2, 3), (2, 3, 4), (2, 3, 3),
    )
    for n, a, b in cases:
        source, target, columns = canonical_data(n, a, b)
        rank = exact_rank(columns)
        if b >= (a - 1) ** 2:
            require(rank == len(target), "Normalized canonical map is not surjective in range")
        if b == 1 or n == 1:
            require(all(len(c) == 1 and tuple(c.values()) == (1,) for c in columns), "Identity normalization failed")
        if (n, a, b) == (2, 2, 2):
            column = columns[source.index(((1, 1), (1, 1)))]
            require(
                column == {
                    ((0, 2), (2, 0)): Fraction(1, 2),
                    ((1, 1), (1, 1)): Fraction(1, 2),
                },
                "The exact 1/a! normalization, not merely rank, failed",
            )
        rows.append({
            "n": n, "a": a, "b": b, "source_dimension": len(source),
            "target_dimension": len(target), "rank": rank,
        })
    return {"exact_half_coefficient_check": True, "maps": rows}


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def formal_binding():
    result = read_json(HERE / "lean_verify.json")
    recorded = result["kernel"]["recorded"]
    archive_path = ROOT / recorded["artifact"]
    archive = read_json(archive_path)
    checked = archive["lean_check"]
    for check in (result, checked):
        require(check["status"] == "success" and check["exit_code"] == 0, "Lean compilation did not succeed")
        require(check["audit_exit_code"] == 0 and check["proof_holes"] == [], "Lean axiom audit is not hole-free")
        require("version 4.31.0," in check["tools"]["lean"]["version"], "Wrong Lean version")
        require(
            check["source_sha256"] == hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest(),
            "Lean source changed after compilation",
        )
        fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
        require(
            check["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode("utf-8")).hexdigest(),
            "Statement fidelity changed after compilation",
        )
    require(archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(encoding="utf-8"), "Archived Lean source differs")
    require(archive["statement_fidelity"]["text"] == fidelity, "Archived fidelity differs")
    require(archive["subject"] == recorded["subject"], "Formal evidence subjects differ")
    ledger = read_json(ROOT / "research" / "MATH_STATE.json")
    claim = max((c for c in ledger["claims"] if c["claim_id"] == "C_POWER"), key=lambda c: c["version"])
    require(claim["content_hash"] == archive["subject"]["content_hash"], "Formal claim was restated")
    require(archive["subject"]["subject_id"] == "C_POWER", "Wrong formal claim")
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports", "Wrong formal evidence tier")
    return {
        "claim": "C_POWER",
        "declaration": "SquareStabilization.sl2_power_injective",
        "certificate": str(archive_path.relative_to(ROOT)),
        "compiler": "Lean 4.31.0",
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "current_source_and_fidelity_match": True,
    }


def typed_polynomial(document):
    require(document["domain"] == "QQ", "Jacobian coefficient domain differs")
    result = {}
    for term in document["polynomial"]["terms"]:
        exponents = tuple(term["exponents"])
        require(len(exponents) == len(document["variables"]), "Jacobian axis length differs")
        coefficient = term["coefficient"]
        result[exponents] = Fraction(int(coefficient["num"]), int(coefficient["den"]))
    return result


def jacobian_binding():
    payload = read_json(HERE / "jacobian_payload.json")
    status = read_json(HERE / "jacobian_status.json")
    response = read_json(HERE / "jacobian_result.json")
    contract = read_json(HERE / "jacobian_contract.json")
    operation = "polynomial.differential_operator.apply.compute"
    require(status["adapter_exit"] == 0, "Jacobian adapter failed or timed out")
    require(response["request"] == {"operation_id": operation, "payload": payload}, "Jacobian request binding differs")
    require(response["result"]["operation_id"] == operation, "Jacobian operation differs")
    require(contract["result"]["operation"]["operation_id"] == operation, "Uninspected Jacobian contract")
    require(response["server"] == contract["server"], "Jacobian server identity changed")
    require(response["protocol_version"] == contract["protocol_version"], "Jacobian protocol changed")
    source = typed_polynomial(payload["polynomial"])
    require(
        source == {(1, 0, 0, 1): Fraction(1), (0, 1, 1, 0): Fraction(-1)},
        "Jacobian input is not the stated determinant",
    )
    require(payload["iterations"] == 1, "Unexpected Jacobian iteration count")
    expected_orders = {(1, 0, 1, 0), (1, 0, 0, 1), (0, 1, 1, 0), (0, 1, 0, 1)}
    require({tuple(t["orders"]) for t in payload["operator"]["terms"]} == expected_orders, "Joint specialization differs")
    own: Polynomial = {}
    for term in payload["operator"]["terms"]:
        coefficient = term["coefficient"]
        require(coefficient == {"num": "1", "den": "1"}, "Joint specialization coefficient differs")
        derivative = source
        for index, count in enumerate(term["orders"]):
            derivative = iterate(derivative, lambda f, index=index: partial(f, index), count)
        own = add(own, derivative)
    typed = response["result"]["output"]
    require(all(typed[key] == payload[key] for key in ("polynomial", "operator", "iterations", "expected")), "Typed output lost its input")
    require(typed["is_zero"] is True and typed["matches_expected"] is True, "Jacobian did not certify the expected specialization")
    require(typed_polynomial(typed["output"]) == own == {}, "Independent exact Jacobian replay differs")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit": status["adapter_exit"],
        "specialization": "r=2,L=1,j=1,y=(1,1)",
        "typed_output_matches_independent_replay": True,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true", help="Persist freshly measured exact diagnostics")
    args = parser.parse_args()
    certificate = {
        "schema_version": 1,
        "claim": "C_SQUARE",
        "result_class": "new_theorem",
        "statement": "The normalized canonical map Sym^b(Sym^a V) -> Sym^a(Sym^b V) is surjective for finite-dimensional complex V, a>=2, b>=(a-1)^2.",
        "proof": "report.md",
        "scope": {
            "universal_formal_proof": "The locally nilpotent sl2 whole-power operator theorem C_POWER, not the full canonical-map theorem.",
            "universal_prose_proof": "Polynomial specialization, exact joint threshold, determinant obstruction, normalized diagonal criterion, and square-bound induction.",
            "finite_diagnostics": "The exact ranks and determinant expansions below are adversarial checks, not a universal proof.",
        },
        "formal_core": formal_binding(),
        "scalar_identities": scalar_identities(),
        "polynomial_commutators": commutator_diagnostics(),
        "joint_operator_ranks": joint_rank_diagnostics(),
        "determinant": determinant_diagnostics(),
        "normalized_canonical_maps": canonical_diagnostics(),
        "jacobian": jacobian_binding(),
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_independently_certified",
        "significance_status": "proposed_publishable",
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    require(read_json(path) == certificate, "Exact certificate differs from current replay")
    print(json.dumps({
        "status": "PASS",
        "formal_core": certificate["formal_core"]["claim"],
        "proof_holes": [],
        "commutator_monomials": certificate["polynomial_commutators"]["basis_monomials_with_spectator"],
        "joint_rank_cases": len(certificate["joint_operator_ranks"]),
        "determinant_cases": len(certificate["determinant"]["power_images"]),
        "normalized_map_cases": len(certificate["normalized_canonical_maps"]["maps"]),
        "independent_review": certificate["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
