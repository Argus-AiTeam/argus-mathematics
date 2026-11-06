#!/usr/bin/env python3
"""Exact regression certificates for the uniform proof in report.md."""

import argparse
import hashlib
import itertools
import json
from functools import lru_cache
from pathlib import Path


HERE = Path(__file__).resolve().parent


def add(*polynomials):
    out = set()
    for polynomial in polynomials:
        out.symmetric_difference_update(polynomial)
    return frozenset(out)


def mul(left, right):
    out = set()
    for a in left:
        for b in right:
            term = tuple(x + y for x, y in zip(a, b))
            if term in out:
                out.remove(term)
            else:
                out.add(term)
    return frozenset(out)


def power(polynomial, exponent):
    assert exponent >= 0
    assert polynomial
    dimension = len(next(iter(polynomial)))
    out = frozenset({(0,) * dimension})
    while exponent:
        if exponent & 1:
            out = mul(out, polynomial)
        polynomial = frozenset(tuple(2 * x for x in m) for m in polynomial)
        exponent //= 2
    return out


@lru_cache(None)
def dickson(k):
    unit = (0,) * (k + 1)
    polynomial = frozenset({unit})
    u = (1,) + (0,) * k
    for binary_form in range(1 << k):
        terms = {u}
        for j in range(k):
            if binary_form & (1 << j):
                terms.add((0,) * (j + 1) + (1,) + (0,) * (k - j - 1))
        polynomial = mul(polynomial, frozenset(terms))
    coefficients = {}
    for term in polynomial:
        coefficients.setdefault(term[0], set()).add(term[1:])
    assert set(coefficients) == {1 << j for j in range(k + 1)}
    assert coefficients[1 << k] == {(0,) * k}
    return tuple(frozenset(coefficients[1 << j]) for j in range(k))


@lru_cache(None)
def expand_d(k, monomial):
    assert all(x >= 0 for x in monomial)
    out = frozenset({(0,) * k})
    for generator, exponent in zip(dickson(k), monomial):
        out = mul(out, power(generator, exponent))
    return out


@lru_cache(None)
def sq_monomial(monomial, r):
    if r < 0:
        return frozenset()
    if not monomial:
        return frozenset({()}) if r == 0 else frozenset()
    a = monomial[0]
    return frozenset(
        (a + j,) + tail
        for j in range(min(a, r) + 1)
        if j & ~a == 0
        for tail in sq_monomial(monomial[1:], r - j)
    )


@lru_cache(None)
def sq(polynomial, r):
    return add(*(sq_monomial(m, r) for m in polynomial))


@lru_cache(None)
def q_from_squares(polynomial, i):
    if i == 0:
        return sq(polynomial, 1)
    return add(
        sq(q_from_squares(polynomial, i - 1), 1 << i),
        q_from_squares(sq(polynomial, 1 << i), i - 1),
    )


def q_x(polynomial, i):
    out = frozenset()
    for monomial in polynomial:
        for j, exponent in enumerate(monomial):
            if exponent & 1:
                term = list(monomial)
                term[j] += (1 << (i + 1)) - 1
                out = add(out, frozenset({tuple(term)}))
    return out


@lru_cache(None)
def q_d(k, i, monomial):
    if i < k - 1:
        if monomial[i + 1] & 1 == 0:
            return frozenset()
        term = list(monomial)
        term[0] += 1
        term[i + 1] -= 1
        return frozenset({tuple(term)})
    if i == k - 1:
        if sum(monomial) & 1 == 0:
            return frozenset()
        return frozenset({(monomial[0] + 1,) + monomial[1:]})
    r = i - k
    out = frozenset()
    for j in range(k):
        for term in q_d(k, j + r, monomial):
            term = list(term)
            term[j] += 1 << (r + 1)
            out = add(out, frozenset({tuple(term)}))
    return out


def apply_primitives(k, indices, polynomial):
    for i in indices:
        polynomial = add(*(q_d(k, i, m) for m in polynomial))
    return polynomial


def polynomial_checks():
    equations = 0
    for k in range(1, 4):
        samples = {
            tuple(int(j == s) for j in range(k)) for s in range(k)
        }
        samples.update({(1,) * k, (2,) * k})
        for monomial in sorted(samples):
            polynomial = expand_d(k, monomial)
            for i in range(k + 2):
                from_binomial_cartan = q_from_squares(polynomial, i)
                from_coordinates = add(
                    *(expand_d(k, term) for term in q_d(k, i, monomial))
                )
                assert from_binomial_cartan == q_x(polynomial, i)
                assert from_binomial_cartan == from_coordinates
                equations += 2
    return {
        "k": [1, 2, 3],
        "primitive_indices": "0 through k+1 inclusive",
        "equations": equations,
        "model": "Lucas binomial coefficients, Cartan, and the Milnor commutator recurrence",
    }


def laurent_basis_checks():
    records = []
    for k in range(1, 6):
        v0 = (-k,) + (1,) * (k - 1)
        parities = set()
        for mask in range(1 << (k - 1)):
            indices = tuple(j for j in range(k - 1) if mask & (1 << j))
            a = len(indices) - k
            ys = tuple(int(j not in indices) for j in range(k - 1))
            first = (a,) + ys
            last = (a + 1,) + ys
            orbit = apply_primitives(k, indices, frozenset({v0}))
            assert orbit == frozenset({first})
            assert apply_primitives(k, [k - 1], orbit) == frozenset({last})
            parities.update({(a % 2,) + ys, ((a + 1) % 2,) + ys})
        assert len(parities) == 1 << k
        assert apply_primitives(k, range(k), frozenset({v0})) == frozenset({(0,) * k})
        records.append({"k": k, "square_free_basis_size": len(parities)})
    return records


@lru_cache(None)
def monomials(k, n, polynomial_degree):
    weights = tuple((1 << k) - (1 << j) for j in range(k))

    def generate(j, remaining):
        if j == k:
            return [()] if remaining == 0 else []
        lower = n if j == 0 else 0
        return [
            (a,) + tail
            for a in range(lower, remaining // weights[j] + 1)
            for tail in generate(j + 1, remaining - a * weights[j])
        ]

    return tuple(generate(0, polynomial_degree)) if polynomial_degree >= 0 else ()


def q_degree(i):
    return (1 << (i + 1)) - 1


def chain_basis(k, n, degree, s, primitive_count):
    out = []
    for indices in itertools.combinations_with_replacement(range(primitive_count), s):
        coefficient_degree = degree - n - sum(q_degree(i) for i in indices)
        out.extend((indices, m) for m in monomials(k, n, coefficient_degree))
    return tuple(out)


def differential(k, source, target):
    rows = {item: j for j, item in enumerate(target)}
    columns = []
    for indices, monomial in source:
        column = 0
        for i in sorted(set(indices)):
            remaining = list(indices)
            remaining.remove(i)
            for term in q_d(k, i, monomial):
                column ^= 1 << rows[(tuple(remaining), term)]
        columns.append(column)
    return tuple(columns)


def matvec(columns, vector):
    out = 0
    while vector:
        bit = vector & -vector
        out ^= columns[bit.bit_length() - 1]
        vector ^= bit
    return out


def reduce_columns(columns):
    pivots = {}
    kernel = []
    for j, column in enumerate(columns):
        combination = 1 << j
        while column:
            row = column.bit_length() - 1
            if row not in pivots:
                pivots[row] = (column, combination)
                break
            pivot, used = pivots[row]
            column ^= pivot
            combination ^= used
        if column == 0:
            kernel.append(combination)
    return pivots, tuple(kernel)


def fill(vector, pivots):
    combination = 0
    while vector:
        row = vector.bit_length() - 1
        assert row in pivots, "A complete graded cycle has no filling"
        pivot, used = pivots[row]
        vector ^= pivot
        combination ^= used
    return combination


def support(vector):
    return [j for j in range(vector.bit_length()) if vector & (1 << j)]


def graded_case(k, n, degree, s=1, first_k=False, detailed=False):
    primitive_count = k
    if not first_k:
        primitive_count = 0
        while q_degree(primitive_count) <= degree - n * (1 << k):
            primitive_count += 1
    c_prev, c_now, c_next = (
        chain_basis(k, n, degree, t, primitive_count)
        for t in (s - 1, s, s + 1)
    )
    d_now = differential(k, c_now, c_prev)
    d_next = differential(k, c_next, c_now)
    assert all(matvec(d_now, column) == 0 for column in d_next)
    pivots_now, kernel = reduce_columns(d_now)
    pivots_next, _ = reduce_columns(d_next)
    homology_dimension = len(kernel) - len(pivots_next)
    assert homology_dimension >= 0
    fillings = []
    if first_k:
        floor_mask = sum(1 << j for j, (_, m) in enumerate(c_now) if m[0] == n)
        floor_columns = [column for j, column in enumerate(d_now) if floor_mask & (1 << j)]
        floor_pivots, _ = reduce_columns(floor_columns)
        assert homology_dimension == len(floor_columns) - len(floor_pivots)
        assert all(column & floor_mask == 0 for column in d_next)
        for vector in kernel:
            floor = vector & floor_mask
            assert matvec(d_now, floor) == 0
            filling = fill(vector ^ floor, pivots_next)
            assert matvec(d_next, filling) == vector ^ floor
        if degree % 2 != s % 2:
            assert homology_dimension == 0
    elif degree % 2 == 0:
        assert n % 2 == k % 2
        assert homology_dimension == 0
        for vector in kernel:
            filling = fill(vector, pivots_next)
            assert matvec(d_now, vector) == 0
            assert matvec(d_next, filling) == vector
            fillings.append(filling)
    record = {
        "k": k,
        "n": n,
        "degree": degree,
        "s": s,
        "primitive_count": primitive_count,
        "dimensions": [len(c_prev), len(c_now), len(c_next)],
        "ranks": [len(pivots_now), len(pivots_next)],
        "homology_dimension": homology_dimension,
    }
    if detailed:
        record.update({
            "basis_previous": c_prev,
            "basis_source": c_now,
            "basis_fillings": c_next,
            "d_source_columns": d_now,
            "d_filling_columns": d_next,
            "kernel_basis": [support(v) for v in kernel],
            "fillings": [support(v) for v in fillings],
        })
    return record


def formal_core():
    verification = json.loads((HERE / "lean_verification.json").read_text())
    recorded = verification["kernel"]["recorded"]
    archive_path = HERE.parents[1] / recorded["artifact"]
    archive = json.loads(archive_path.read_text())
    checked = archive["lean_check"]
    assert recorded["subject"]["subject_id"] == "C316_TRUNCATION"
    assert recorded["tier"] == "mechanical" and recorded["verdict"] == "supports"
    assert archive["subject"] == recorded["subject"]
    ledger = json.loads((HERE.parents[1] / "research/MATH_STATE.json").read_text())
    current_claim = max(
        (claim for claim in ledger["claims"] if claim["claim_id"] == "C316_TRUNCATION"),
        key=lambda claim: claim["version"],
    )
    assert current_claim["content_hash"] == recorded["subject"]["content_hash"]
    assert archive["verdict"] == "supports"
    assert checked["status"] == "success" and checked["exit_code"] == 0
    assert checked["audit_exit_code"] == 0 and checked["proof_holes"] == []
    assert checked["environment_failure"] == ""
    assert "version 4.31.0," in checked["tools"]["lean"]["version"]
    for filename, hash_key, text_key in [
        ("Main.lean", "source_sha256", "lean_source"),
        ("statement_fidelity.md", "statement_fidelity_sha256", "statement_fidelity"),
    ]:
        content = (HERE / filename).read_bytes()
        assert hashlib.sha256(content).hexdigest() == checked[hash_key]
        assert content.decode() == archive[text_key]["text"]
    return {
        "claim": "C316_TRUNCATION",
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "certificate": recorded["artifact"],
        "scope": "Conditional Laurent filling theorem and canonical floor representatives, not the whole Steenrod claim",
    }


def build_certificate():
    coverage = [(1, 1, 40), (1, 3, 40), (2, 0, 52), (2, 2, 52),
                (2, 4, 52), (3, 1, 64), (3, 3, 64)]
    full_cases = [
        graded_case(k, n, degree)
        for k, n, bound in coverage
        for degree in range(0, bound + 1, 2)
    ]
    first_k_cases = [
        graded_case(k, n, degree, s, first_k=True)
        for k, n in [(1, 0), (1, 1), (2, 1), (2, 2), (3, 1), (3, 2)]
        for s in [1, 2, 3]
        for degree in range(n * (1 << k) + s, n * (1 << k) + s + 25)
    ]
    control = graded_case(2, 2, 9, detailed=True)
    assert control["homology_dimension"] == 1
    assert control["basis_source"] == (((0,), (2, 0)),)
    assert control["d_source_columns"] == (0,)
    assert control["basis_fillings"] == ()
    control["separating_functional"] = [1]
    control["interpretation"] = "Nonzero odd-degree Tor class; not a counterexample to the even-degree claim"
    return {
        "claim": "C316_TOR",
        "result": "Uniform human proof with Lean-certified truncation core; finite exact regressions are not the uniform proof",
        "proof": "report.md, Sections 1-5",
        "formal_core_claim": "C316_TRUNCATION",
        "formal_core": formal_core(),
        "formal_source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "independent_review": "pending",
        "novelty_status": "not_established",
        "polynomial_actions": polynomial_checks(),
        "laurent_orbit_basis": laurent_basis_checks(),
        "all_primitive_even_tor1_coverage": coverage,
        "all_primitive_even_tor1_cases": full_cases,
        "first_k_floor_support_cases": first_k_cases,
        "detailed_even_cycle_fillings": graded_case(2, 2, 18, detailed=True),
        "odd_degree_nonzero_control": control,
    }


def jacobian_payload():
    case = graded_case(2, 2, 18, detailed=True)
    rows = case["dimensions"][1]
    columns = case["d_filling_columns"]
    return {
        "matrix": {
            "prime": 2,
            "entries": [[(column >> j) & 1 for column in columns] for j in range(rows)],
            "columns": len(columns),
        }
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    if args.write_jacobian_payload:
        (HERE / "jacobian_payload.json").write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        if not args.write_certificate:
            print("Wrote the bounded graded relation-matrix payload.")
            return
    certificate = build_certificate()
    serialized = json.dumps(certificate, indent=2) + "\n"
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(serialized)
    else:
        assert json.loads(path.read_text()) == json.loads(serialized), "Certificate mismatch"
    if not args.write_jacobian_payload:
        typed = json.loads((HERE / "jacobian_result.json").read_text())
        status = json.loads((HERE / "jacobian_status.json").read_text())
        assert status["adapter_exit_code"] == 0
        assert status["error"] is None and status["timeout"] is False
        assert status["typed_output"] == "complete"
        assert typed["result"]["operation_id"] == "prime_field.matrix.rank.compute"
        result = typed["result"]["output"]
        assert result["source"] == jacobian_payload()
        assert result["prime"] == 2
        assert result["rank"] == certificate["detailed_even_cycle_fillings"]["ranks"][1]
    print(json.dumps({
        "exact_replay": "pass",
        "polynomial_equations": certificate["polynomial_actions"]["equations"],
        "complete_even_tor1_components": len(certificate["all_primitive_even_tor1_cases"]),
        "first_k_floor_support_components": len(certificate["first_k_floor_support_cases"]),
        "lean_core": "fresh successful Lean 4.31.0 compiler and axiom-audit record",
        "scope": "Uniform proof is in report.md; Lean checks its truncation core only",
        "independent_review": "pending",
    }))


if __name__ == "__main__":
    main()
