#!/usr/bin/env python3
"""Exact finite replays of the general clause-insertion construction.

The general theorem is proved in Main.lean and report.md. Enumeration here
checks the executable construction and edge cases, not infinitely many CNFs.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from functools import lru_cache
from fractions import Fraction
from math import comb
from pathlib import Path

Clause = tuple[int, ...]
CNF = tuple[Clause, ...]
Restriction = tuple[int | None, ...]
Expansion = tuple[tuple[int, CNF], ...]
ROOT = Path(__file__).resolve().parent


def normalize(clauses: tuple[Clause, ...]) -> CNF:
    result = []
    for clause in clauses:
        literals = set(clause)
        if 0 in literals:
            raise ValueError("Literal zero is not a variable.")
        if any(-literal in literals for literal in literals):
            continue
        result.append(tuple(sorted(literals, key=abs)))
    return tuple(result)


def value(formula: CNF, assignment: tuple[int, ...]) -> int:
    return int(all(any(assignment[abs(t) - 1] == (t > 0) for t in c) for c in formula))


def fill(r: Restriction, x: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(x[i] if t is None else t for i, t in enumerate(r))


def reduced(clause: Clause, r: Restriction) -> Clause | None:
    if any(r[abs(t) - 1] == (t > 0) for t in clause):
        return None
    return tuple(t for t in clause if r[abs(t) - 1] is None)


def falsify(clause: Clause, r: Restriction) -> Restriction:
    result = list(r)
    for t in clause:
        result[abs(t) - 1] = int(t < 0)
    return tuple(result)


@lru_cache(maxsize=16384)
def expansion(formula: CNF, r: Restriction, b: int) -> Expansion:
    if b < 1:
        raise ValueError("The construction needs b >= 1 for its unit guards.")
    if not formula:
        return ((1, ()),)
    clause, prefix = formula[0], formula[1:]
    c = reduced(clause, r)
    if c == ():
        return ()
    old = expansion(prefix, r, b)
    if c is None:
        return old
    if len(c) <= b:
        return tuple((a, atom + (c,)) for a, atom in old)
    guard = tuple((-t,) for t in c)
    correction = expansion(prefix, falsify(clause, r), b)
    return old + tuple((-a, atom + guard) for a, atom in correction)


def restrictions(d: int):
    return itertools.product((None, 0, 1), repeat=d)


def weight(r: Restriction, p: Fraction) -> Fraction:
    q = (1 - p) / 2
    return p ** r.count(None) * q ** (len(r) - r.count(None))


def expected_mass(formula: CNF, d: int, b: int, p: Fraction) -> Fraction:
    return sum(
        (weight(r, p) * len(expansion(formula, r, b)) for r in restrictions(d)),
        Fraction(),
    )


def tail(k: int, b: int, p: Fraction) -> Fraction:
    alpha = 2 * p / (1 - p)
    return sum((comb(k, j) * alpha**j for j in range(b + 1, k + 1)), Fraction())


def insertion_difference(prefix: CNF, clause: Clause, d: int, b: int, p: Fraction):
    scope = {abs(t) - 1 for t in clause}
    outside = [i for i in range(d) if i not in scope]
    conditional = Fraction()
    for state in restrictions(len(outside)):
        r: list[int | None] = [None] * d
        for i, t in zip(outside, state):
            r[i] = t
        closed = falsify(clause, tuple(r))
        conditional += weight(state, p) * len(expansion(prefix, closed, b))
    q = (1 - p) / 2
    return q ** len(scope) * (tail(len(scope), b, p) - 1) * conditional


def check_formula(formula: CNF, d: int, b: int, p: Fraction) -> tuple[int, int]:
    original, formula = formula, normalize(formula)
    for x in itertools.product((0, 1), repeat=d):
        assert value(original, x) == value(formula, x)
    identities = 0
    for r in restrictions(d):
        terms = expansion(formula, r, b)
        assert all(abs(a) == 1 for a, _ in terms)
        assert all(
            len(c) <= b and all(r[abs(t) - 1] is None for t in c)
            for _, atom in terms
            for c in atom
        )
        live = [i for i, t in enumerate(r) if t is None]
        for bits in itertools.product((0, 1), repeat=len(live)):
            x = [0] * d
            for i, t in zip(live, bits):
                x[i] = t
            lhs = value(formula, fill(r, tuple(x)))
            rhs = sum(a * value(atom, tuple(x)) for a, atom in terms)
            assert lhs == rhs, (formula, r, bits, lhs, rhs)
            identities += 1
    old = Fraction(1)
    prefix: CNF = ()
    differences = 0
    for clause in reversed(formula):
        new = expected_mass((clause,) + prefix, d, b, p)
        assert new - old == insertion_difference(prefix, clause, d, b, p)
        prefix = (clause,) + prefix
        old = new
        differences += 1
    k = max((len(c) for c in formula), default=0)
    if tail(k, b, p) <= 1:
        assert old <= 1, (formula, b, p, old)
    return identities, differences


def sat_payload() -> dict:
    """Negate one overlapping-scope insertion identity using Tseitin clauses."""
    variables = ["a", "c", "f", "g", "lhs", "rhs", "v", "x", "y", "z"]
    ix = {name: i + 1 for i, name in enumerate(variables)}
    clauses: list[list[int]] = []
    gates = []

    def gate(out: str, inputs: list[tuple[str, bool]], conjunction: bool):
        gates.append((out, inputs, conjunction))
        o = ix[out]
        literals = [ix[name] if positive else -ix[name] for name, positive in inputs]
        if conjunction:
            clauses.extend([[-o, t] for t in literals])
            clauses.append([o] + [-t for t in literals])
        else:
            clauses.extend([[o, -t] for t in literals])
            clauses.append([-o] + literals)

    # F=(x or z) and (not y or z), C=(x or y), F_closed=z.
    gate("a", [("x", True), ("z", True)], False)
    gate("c", [("x", True), ("y", True)], False)
    gate("g", [("y", False), ("z", True)], False)
    gate("f", [("a", True), ("g", True)], True)
    gate("v", [("x", False), ("y", False), ("z", True)], True)
    gate("lhs", [("f", True), ("c", True)], True)
    gate("rhs", [("f", True), ("v", False)], True)
    clauses.extend([[ix["lhs"], ix["rhs"]], [-ix["lhs"], -ix["rhs"]]])
    canonical = sorted({tuple(sorted(c, key=abs)) for c in clauses})
    payload = {"cnf": {"variables": variables, "clauses": [list(c) for c in canonical]},
               "timeout_ms": 1000}
    satisfying = []
    gate_assignments = 0
    for bits in itertools.product((False, True), repeat=len(variables)):
        cnf_holds = all(any(bits[abs(t) - 1] == (t > 0) for t in c) for c in canonical)
        circuit_holds = all(
            bits[ix[out] - 1] == (all if conjunction else any)(
                bits[ix[name] - 1] == positive for name, positive in inputs
            )
            for out, inputs, conjunction in gates
        )
        disagreement = bits[ix["lhs"] - 1] != bits[ix["rhs"] - 1]
        assert cnf_holds == (circuit_holds and disagreement)
        if circuit_holds:
            gate_assignments += 1
            x, y, z = (bits[ix[name] - 1] for name in ("x", "y", "z"))
            f = (x or z) and ((not y) or z)
            assert bits[ix["lhs"] - 1] == (f and (x or y))
            assert bits[ix["rhs"] - 1] == (f - ((not x) and (not y)) * z)
        if cnf_holds:
            satisfying.append(bits)
    assert not satisfying
    assert gate_assignments == 8
    return payload


def jacobian_evidence(source: dict) -> tuple[dict, dict]:
    named = json.loads((ROOT / "jacobian_named_payload.json").read_text())
    canonical = json.loads((ROOT / "jacobian_canonicalize_result.json").read_text())
    result = json.loads((ROOT / "jacobian_result.json").read_text())
    status = json.loads((ROOT / "jacobian_adapter_status.json").read_text())
    assert named == {"variable_names": source["cnf"]["variables"],
                     "clauses": source["cnf"]["clauses"]}
    assert canonical["request"] == {
        "operation_id": "sat.cnf.canonicalize", "payload": named
    }
    assert canonical["result"]["operation_id"] == "sat.cnf.canonicalize"
    assert json.loads((ROOT / "jacobian_canonicalize_status.json").read_text())[
        "adapter_exit_code"
    ] == 0
    cnf = canonical["result"]["output"]["cnf"]
    assert cnf["variables"] == source["cnf"]["variables"]
    assert {tuple(c) for c in cnf["clauses"]} == {
        tuple(c) for c in source["cnf"]["clauses"]
    }
    payload = {"cnf": cnf, "timeout_ms": 1000}
    assert json.loads((ROOT / "jacobian_payload.json").read_text()) == payload
    assert status["adapter_exit_code"] == 0
    assert result["request"] == {"operation_id": "sat.solve", "payload": payload}
    assert result["result"]["operation_id"] == "sat.solve"
    output = result["result"]["output"]
    assert output["source"] == payload
    assert output["outcome"] == "UNSAT"
    assert output["exhausted"] is None
    assert result["protocol_version"] == canonical["protocol_version"]
    assert result["server"]["version"] == canonical["server"]["version"]
    assert result["schema_version"] == canonical["schema_version"] == 1
    rejected = json.loads((ROOT / "jacobian_rejected_result.json").read_text())
    assert rejected["error"]["data"]["code"] == "INVALID_REQUEST"
    return payload, {
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "operation_id": "sat.solve",
        "adapter_exit_code": status["adapter_exit_code"],
        "typed_outcome": output["outcome"],
        "local_replay": "All 1024 total assignments; Tseitin reduction checked against its circuit.",
        "initial_rejection": "Noncanonical ordering; preserved as a non-conclusion.",
    }


def lean_evidence() -> dict:
    project = ROOT.parent.parent
    result = json.loads((ROOT / "lean_verification.json").read_text())
    check = json.loads((ROOT / "lean_check.json").read_text())
    assert all(result[key] == value for key, value in check.items())
    assert result["status"] == "success"
    assert result["exit_code"] == result["audit_exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    source = (ROOT / "Main.lean").read_bytes()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    assert hashlib.sha256(source).hexdigest() == result["source_sha256"]
    assert hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"]
    recorded = result["kernel"]["recorded"]
    assert result["kernel"]["refusals"] == []
    assert recorded["tier"] == "mechanical" and recorded["verdict"] == "supports"
    assert recorded["subject"]["subject_id"] == "C_RESTRICTION_INDEPENDENT"
    archive_path = project / recorded["artifact"]
    assert archive_path.resolve().is_relative_to(ROOT / "certificates")
    archive = json.loads(archive_path.read_text())
    assert archive["evidence_id"] == recorded["evidence_id"]
    assert archive["subject"] == recorded["subject"]
    assert archive["lean_check"] == check
    assert archive["lean_source"]["text"] == source.decode()
    assert archive["statement_fidelity"]["text"] == fidelity
    state = json.loads((project / "research/MATH_STATE.json").read_text())
    current = max(
        (c for c in state["claims"] if c["claim_id"] == "C_RESTRICTION_INDEPENDENT"),
        key=lambda c: c["version"],
    )
    assert current["content_hash"] == recorded["subject"]["content_hash"]
    assert " ".join(current["formal_statement"].split()) == " ".join(source.decode().split())
    assert not current["external_assumptions"]
    assert any(e["evidence_id"] == recorded["evidence_id"] for e in state["evidence"])
    return {
        "status": result["status"],
        "exit_code": result["exit_code"],
        "axiom_audit_exit_code": result["audit_exit_code"],
        "proof_holes": result["proof_holes"],
        "compiler_version": result["tools"]["lean"]["version"],
        "certificate": recorded["artifact"],
        "current_source_and_fidelity_match": True,
        "claim_has_no_external_assumptions": True,
        "declarations": [
            "RestrictionCertificate.expand_correct",
            "RestrictionCertificate.expand_width",
            "RestrictionCertificate.expected_mass_step",
            "RestrictionCertificate.expected_mass_uniform",
            "RestrictionCertificate.average_live",
            "RestrictionCertificate.restriction_correlation",
            "RestrictionCertificate.independent_restriction",
            "RestrictionCertificate.manuscript_corollary",
        ],
    }


def run() -> dict:
    counts = {"formulas": 0, "pointwise_identities": 0, "exact_mass_differences": 0}
    families = []
    for d in range(4):
        clauses = [
            tuple((i + 1) * s for i, s in enumerate(pattern) if s)
            for pattern in itertools.product((0, -1, 1), repeat=d)
        ]
        families.append((d, ()))
        families.extend((d, (c,)) for c in clauses)
        families.extend((d, (c, e)) for c in clauses for e in clauses)
    families.extend([
        (3, ((1, 2, 3),) * 9),
        (3, ((1, 2), (-2, 3), (1, -3), (-1, 2, 3))),
        (3, ((1, -1), (2, 2, 3), ())),
        (0, ((), (), ())),
    ])
    for d, formula in families:
        identities, differences = check_formula(formula, d, 1, Fraction(1, 5))
        counts["formulas"] += 1
        counts["pointwise_identities"] += identities
        counts["exact_mass_differences"] += differences
    equality = []
    for d, b in [(2, 1), (3, 2)]:
        formula = (tuple(range(1, d + 1)),)
        check_formula(formula, d, b, Fraction(1, 3))
        m = expected_mass(formula, d, b, Fraction(1, 3))
        assert tail(d, b, Fraction(1, 3)) == m == 1
        equality.append({"d": d, "b": b, "p": "1/3", "theta": "1", "expected_mass": str(m)})
    for b in (1, 2, 3, 4):
        check_formula(((1, 2, 3), (-1, 2), ()), 3, b, Fraction(2, 3))
    for b in (3, 4):
        formula = ((1, 2, 3), (-1, 2))
        check_formula(formula, 3, b, Fraction(2, 3))
        assert all(len(expansion(formula, r, b)) <= 1 for r in restrictions(3))
    check_formula(((1, -1), (2, 2, 3)), 3, 1, Fraction(1, 5))
    beyond = expected_mass(((1, 2, 3),), 3, 1, Fraction(1, 4))
    assert beyond == Fraction(529, 512)
    payload, jacobian = jacobian_evidence(sat_payload())
    return {
        "result_class": "formal_verification",
        "mathematical_argument_provenance": "Known clause-insertion bound; independently formalized here.",
        "claim": "C_RESTRICTION_INDEPENDENT",
        "general_proof": "Main.lean",
        "scope": "Arbitrary finite clause lists are covered by the proof, not by enumeration.",
        "finite_replay": counts,
        "additional_edge_cases": [
            "theta=1",
            "k<=b with nonconstant satisfiable formulas and arbitrary admissible p",
            "true/tautological clauses and repeated literals removed without changing values",
            "false clauses, including dimension zero",
        ],
        "lean": lean_evidence(),
        "theta_equal_one": equality,
        "outside_hypothesis": {
            "d": 3, "b": 1, "p": "1/4", "theta": "44/27",
            "expected_constructed_mass": str(beyond),
            "interpretation": "Sharp sign of this construction's insertion identity, not a manuscript refutation.",
        },
        "jacobian_operation": "sat.solve",
        "jacobian_payload": payload,
        "jacobian_evidence": jacobian,
        "jacobian_local_exhaustive_result": "UNSAT on all 1024 total assignments",
        "limitations": [
            "Does not improve the expectation of the manuscript's specific path-defined W.",
            "Does not independently verify the full depth-three circuit theorem.",
            "The clause-insertion mathematical bound is known; no novelty of that argument is claimed.",
            "Independent Reviewer certification is a separate Host action.",
        ],
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write the exact replay and SAT payload.")
    args = parser.parse_args()
    certificate = run()
    text = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        (ROOT / "exact_certificate.json").write_text(text)
        (ROOT / "jacobian_payload.json").write_text(
            json.dumps(certificate["jacobian_payload"], indent=2, sort_keys=True) + "\n"
        )
    else:
        assert json.loads((ROOT / "exact_certificate.json").read_text()) == certificate
    print(json.dumps({"ok": True, **certificate["finite_replay"]}, sort_keys=True))
