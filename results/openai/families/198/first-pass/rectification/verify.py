#!/usr/bin/env python3
"""Replay an exact bimodule fixture and check recorded Lean evidence freshness."""

import argparse
import hashlib
import json
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROJECT_ROOT = ROOT.parents[1]


@dataclass
class Matrix:
    rows: int
    cols: int
    entries: dict

    def __add__(self, other):
        assert (self.rows, self.cols) == (other.rows, other.cols)
        out = defaultdict(int, self.entries)
        for key, value in other.entries.items():
            out[key] += value
        return Matrix(self.rows, self.cols, {k: v for k, v in out.items() if v})

    def __neg__(self):
        return Matrix(self.rows, self.cols, {k: -v for k, v in self.entries.items()})

    def __sub__(self, other):
        return self + -other

    def __matmul__(self, other):
        assert self.cols == other.rows
        by_row = defaultdict(list)
        for (i, j), value in other.entries.items():
            by_row[i].append((j, value))
        out = defaultdict(int)
        for (i, k), value in self.entries.items():
            for j, value2 in by_row[k]:
                out[i, j] += value * value2
        return Matrix(self.rows, other.cols, {k: v for k, v in out.items() if v})

    @classmethod
    def identity(cls, size):
        return cls(size, size, {(i, i): 1 for i in range(size)})


def build(source, target, image):
    indices = {item: i for i, item in enumerate(target)}
    out = defaultdict(int)
    for j, item in enumerate(source):
        for result, value in image(item):
            if value:
                assert result in indices, ("wrong degree or vertex", result)
                out[indices[result], j] += value
    return Matrix(len(target), len(source), {k: v for k, v in out.items() if v})


def equal(actual, expected, label):
    assert actual == expected, label


def zero(matrix, label):
    assert not matrix.entries, (label, matrix.entries)


NAMES = ["e0", "e1", "e2", "s", "a", "t", "b", "u", "v"]
START = [0, 1, 2, 0, 0, 1, 1, 0, 0]
END = [0, 1, 2, 1, 1, 2, 2, 2, 2]
STEPS = [(), (), (), ("s",), ("a",), ("t",), ("b",), ("s", "t"), ("a", "t")]
INDEX = {name: i for i, name in enumerate(NAMES)}
ARROWS = ["s", "a", "t", "b"]
F = {"s": 1, "a": 0, "t": 1, "b": 1}
RELATIONS = [[("b", "s", 1), ("t", "a", -1)], [("b", "a", 1)]]


def multiply(p, q):
    """Product p*q, with paths composed right to left."""
    if START[p] != END[q]:
        return None
    word = STEPS[q] + STEPS[p]
    if not word:
        return p
    if len(word) == 1:
        return INDEX[word[0]]
    return {
        ("s", "t"): INDEX["u"],
        ("a", "t"): INDEX["v"],
        ("s", "b"): INDEX["v"],
        ("a", "b"): None,
    }[word]


def product(p, q):
    return None if p is None or q is None else multiply(p, q)


def fixture():
    for a in range(9):
        for b in range(9):
            for c in range(9):
                assert product(product(a, b), c) == product(a, product(b, c))
        assert [product(i, a) for i in range(3)].count(a) == 1
        assert [product(a, i) for i in range(3)].count(a) == 1

    basis = {n: [] for n in range(-3, 4)}
    for column in range(3):
        cells = range(3) if column == 0 else ARROWS if column == 1 else range(2)
        for cell in cells:
            vertex = cell if column == 0 else END[INDEX[cell]] if column == 1 else 2
            for path in range(9):
                if START[path] != vertex:
                    continue
                for degree in (0, 1):
                    for right in range(9):
                        basis[degree - column].append((column, cell, path, degree, right))

    def differential(item, h_coefficient=1):
        column, cell, path, degree, right = item
        if degree == 0:
            yield (column, cell, path, 1, right), (-1) ** column
        if column == 1:
            a = INDEX[cell]
            composed = multiply(path, a)
            if composed is not None:
                yield (0, START[a], composed, degree, right), 1
            yield (0, END[a], path, degree, right), -F[cell]
        if column == 2:
            for b, a, coefficient in RELATIONS[cell]:
                composed = multiply(path, INDEX[b])
                if composed is not None:
                    yield (1, a, composed, degree, right), coefficient
                yield (1, b, path, degree, right), coefficient * F[a]
            if cell == 0 and degree == 1:
                yield (0, 2, path, 0, right), h_coefficient

    def action(item, a, side):
        column, cell, path, degree, right = item
        result = multiply(a, path) if side == "left" else multiply(right, a)
        if result is not None:
            yield (column, cell, result if side == "left" else path,
                   degree, right if side == "left" else result), 1

    def d(n, h_coefficient=1):
        return build(basis[n], basis[n + 1],
                     lambda x: differential(x, h_coefficient))

    def act(n, a, side):
        if a is None:
            return Matrix(len(basis[n]), len(basis[n]), {})
        return build(basis[n], basis[n], lambda x: action(x, a, side))

    for n in range(-2, 1):
        zero(d(n + 1) @ d(n), f"d^2 in degree {n}")
    negative_controls = {}
    for label, coefficient in (("erased_h", 0), ("negated_h", -1)):
        defects = {}
        for n in range(-2, 1):
            residual = d(n + 1, coefficient) @ d(n, coefficient)
            if residual.entries:
                defects[str(n)] = {
                    "nonzero_entries": len(residual.entries),
                    "coefficients": sorted(set(residual.entries.values())),
                }
        assert defects, (label, "the invalid homotopy should break square-zero")
        negative_controls[label] = defects
    for n in range(-2, 2):
        left = [act(n, a, "left") for a in range(9)]
        right = [act(n, a, "right") for a in range(9)]
        equal(left[0] + left[1] + left[2], Matrix.identity(len(basis[n])), "left unit")
        equal(right[0] + right[1] + right[2], Matrix.identity(len(basis[n])), "right unit")
        for a in range(9):
            equal(d(n) @ left[a], act(n + 1, a, "left") @ d(n), "left-linear d")
            equal(d(n) @ right[a], act(n + 1, a, "right") @ d(n), "right-linear d")
            for b in range(9):
                equal(left[a] @ left[b], act(n, multiply(a, b), "left"), "left action")
                equal(right[a] @ right[b], act(n, multiply(b, a), "right"), "right action")
                equal(left[a] @ right[b], right[b] @ left[a], "commuting actions")
        groups = defaultdict(set)
        for column, cell, path, degree, q in basis[n]:
            groups[column, cell, path, degree].add(q)
        assert all(q == set(range(9)) for q in groups.values())
        assert 9 * len(groups) == len(basis[n])

    vertex = {
        (i, n): [x for x in basis[n] if END[x[2]] == i]
        for i in range(3) for n in range(-3, 4)
    }

    def vdiff(i, n):
        return build(vertex[i, n], vertex[i, n + 1], differential)

    def dbasis(n):
        return [(n, q) for q in range(9)] if n in (0, 1) else []

    def dd(n):
        return build(dbasis(n), dbasis(n + 1),
                     lambda x: [((1, x[1]), 1)] if n == 0 else [])

    def dright(n, a):
        return build(dbasis(n), dbasis(n),
                     lambda x: [] if multiply(x[1], a) is None else
                     [((x[0], multiply(x[1], a)), 1)])

    def include(i, n):
        return build(dbasis(n), vertex[i, n],
                     lambda x: [((0, i, i, x[0], x[1]), 1)])

    def retract_image(i, item):
        col, cell, path, degree, q = item
        if col == 0:
            coefficient = 1 if cell == i else F[NAMES[path]] if i == 1 else (
                1 if cell == 1 or NAMES[path] == "u" else 0)
            if coefficient:
                yield (degree, q), coefficient
        if i == 2 and col == 1 and cell == "s" and path == INDEX["b"] and degree == 1:
            yield (0, q), -1

    def retract(i, n):
        return build(vertex[i, n], dbasis(n), lambda x: retract_image(i, x))

    def contract_image(i, item):
        col, cell, path, degree, q = item
        if i == 1 and col == 0 and cell == 0:
            yield (1, NAMES[path], 1, degree, q), 1
        if i == 2 and col == 0 and cell == 1:
            yield (1, NAMES[path], 2, degree, q), 1
        if i == 2 and col == 0 and cell == 0:
            first = "s" if NAMES[path] == "u" else "a"
            yield (1, first, INDEX["t"], degree, q), 1
            if first == "s":
                yield (1, "t", 2, degree, q), 1
        if i == 2 and col == 1 and path == INDEX["b"] and cell in ("s", "a"):
            yield (2, 0 if cell == "s" else 1, 2, degree, q), 1

    def contraction(i, n):
        return build(vertex[i, n], vertex[i, n - 1], lambda x: contract_image(i, x))

    for i in range(3):
        for n in range(-2, 2):
            inc, ret = include(i, n), retract(i, n)
            equal(ret @ inc, Matrix.identity(len(dbasis(n))), "retract inclusion")
            equal(vdiff(i, n) @ inc, include(i, n + 1) @ dd(n), "inclusion chain")
            equal(dd(n) @ ret, retract(i, n + 1) @ vdiff(i, n), "retraction chain")
            equal(vdiff(i, n - 1) @ contraction(i, n) +
                  contraction(i, n + 1) @ vdiff(i, n),
                  Matrix.identity(len(vertex[i, n])) - inc @ ret, "vertex contraction")
            for a in range(9):
                vr = build(vertex[i, n], vertex[i, n], lambda x: action(x, a, "right"))
                dr = dright(n, a)
                equal(vr @ inc, inc @ dr, "right-linear inclusion")
                equal(ret @ vr, dr @ ret, "right-linear retraction")
                vr_lower = build(vertex[i, n - 1], vertex[i, n - 1],
                                 lambda x: action(x, a, "right"))
                equal(vr_lower @ contraction(i, n), contraction(i, n) @ vr,
                      "right-linear contraction")

    for arrow in ARROWS:
        a = INDEX[arrow]
        i, j = START[a], END[a]

        def hom(n):
            return build(dbasis(n), vertex[j, n - 1],
                         lambda x: [((1, arrow, j, x[0], x[1]), 1)])

        for n in range(-2, 2):
            arrow_action = build(vertex[i, n], vertex[j, n],
                                 lambda x: action(x, a, "left"))
            f = build(dbasis(n), dbasis(n), lambda x: [(x, F[arrow])])
            equal(vdiff(j, n - 1) @ hom(n) + hom(n + 1) @ dd(n),
                  arrow_action @ include(i, n) - include(j, n) @ f,
                  "arrow homotopy")
            for right_basis in range(9):
                vr_lower = build(
                    vertex[j, n - 1], vertex[j, n - 1],
                    lambda x: action(x, right_basis, "right"))
                equal(vr_lower @ hom(n), hom(n) @ dright(n, right_basis),
                      "right-linear arrow homotopy")

    j = [[0, 0], [-1, 0], [1, 0], [0, 1]]
    pi = [[1, 0, 0, 0], [0, 1, 1, 0]]
    s = [[1, 0], [0, 1], [0, 0], [0, 0]]
    ell = [[0, 0, 1, 0], [0, 0, 0, 1]]

    def dense(values):
        return Matrix(len(values), len(values[0]),
                      {(i, k): v for i, row in enumerate(values)
                       for k, v in enumerate(row) if v})

    jm, pm, sm, lm = map(dense, (j, pi, s, ell))
    equal(lm @ jm, Matrix.identity(2), "relation basis injective")
    equal(pm @ sm, Matrix.identity(2), "quotient section")
    zero(pm @ jm, "quadratic relations in quotient")
    zero(lm @ sm, "complement")
    equal(sm @ pm + jm @ lm, Matrix.identity(4), "split exact path sequence")
    assert F["b"] * F["s"] - F["t"] * F["a"] == 1
    assert F["b"] * F["a"] == 0
    # d=id on degrees 0,1; h=id from degree 1 back to degree 0.
    h = Matrix.identity(9)
    equal(dd(0) @ h, Matrix.identity(9), "nonzero homotopy at degree 1")
    equal(h @ dd(0), Matrix.identity(9), "nonzero homotopy at degree 0")

    return {
        "field": "QQ (integer coefficients, exact arithmetic)",
        "encoded_algebra": "R=QQ[x]/(x^2), B relations b*s-t*a=0, b*a=0",
        "B_basis": NAMES,
        "B_dimension": 9,
        "input_complexes": "D0=D1=D2=(B --id--> B) in cochain degrees 0,1",
        "arrow_maps": F,
        "relation_homotopies": ["id:B^1->B^0", "0"],
        "first_relation_composite": "id (not zero)",
        "relation_inclusion_matrix": j,
        "path_quotient_matrix": pi,
        "path_section_matrix": s,
        "relation_retraction_matrix": ell,
        "total_dimensions": {str(n): len(basis[n]) for n in range(-2, 2)},
        "right_free_ranks": {str(n): len(basis[n]) // 9 for n in range(-2, 2)},
        "invalid_homotopy_negative_controls": negative_controls,
        "checked": [
            "associativity and unit of the nine-dimensional algebra",
            "the manuscript's full three-column differential including h!=0",
            "differential square and both module actions in every degree",
            "all left and right multiplication tables and commuting actions",
            "right regular-module decomposition of every total term",
            "all three right-linear homotopy retractions",
            "all four right-linear arrow homotopies",
            "split exact relation sequence and nonzero relation homotopy",
            "erasing or negating the required h makes differential square nonzero",
        ],
        "all_checks_passed": True,
        "scope": "A full exact regression fixture, not a universal proof or a counterexample.",
    }


def universal_evidence(artifact):
    source = ROOT / "Main.lean"
    fidelity = ROOT / "statement_fidelity.md"
    source_hash = hashlib.sha256(source.read_bytes()).hexdigest()
    fidelity_hash = hashlib.sha256(fidelity.read_bytes()).hexdigest()
    archived = json.loads((PROJECT_ROOT / artifact).read_text())
    current_run = json.loads((ROOT / "lean_check.json").read_text())
    for run in (current_run, archived["lean_check"]):
        equal(run["status"], "success", "Lean compiler did not succeed")
        equal(run["exit_code"], 0, "nonzero Lean compiler exit")
        equal(run["audit_exit_code"], 0, "Lean axiom audit did not succeed")
        equal(run["proof_holes"], [], "Lean proof has holes")
        equal(run["environment_failure"], "", "Lean environment failure")
        equal(run["tools"]["lean"]["available"], True, "Lean unavailable")
        assert run["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"), (
            "unexpected Lean version", run["tools"]["lean"]["version"])
        equal(Path(run["source"]).resolve(), source, "wrong compiler source")
        equal(Path(run["statement_fidelity"]).resolve(), fidelity,
              "wrong statement-fidelity source")
        equal(run["source_sha256"], source_hash, "Lean source changed since compile")
        equal(run["statement_fidelity_sha256"], fidelity_hash,
              "statement fidelity changed since compile")
    equal(archived["lean_source"]["text"], source.read_text(),
          "archived Lean source differs")
    equal(archived["statement_fidelity"]["text"], fidelity.read_text(),
          "archived statement-fidelity text differs")
    equal(archived["tier"], "mechanical", "not mechanical compiler evidence")
    equal(archived["verdict"], "supports", "compiler evidence does not support claim")
    equal(archived["produced_by"], "lean_evidence/lean 4.31.0",
          "unexpected evidence producer")
    equal(archived["subject"]["kind"], "claim", "wrong evidence subject kind")
    equal(archived["subject"]["subject_id"], "C_RECTIFICATION",
          "wrong evidence claim")
    ledger = json.loads((PROJECT_ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in ledger["claims"] if c["claim_id"] == "C_RECTIFICATION"),
                key=lambda c: c["version"])
    equal(archived["subject"]["content_hash"], claim["content_hash"],
          "compiler certificate concerns a superseded claim")
    return {
        "principal_declaration": "ThreeLayer.complete_rectification",
        "formal_source": "research/rectification/Main.lean",
        "statement_fidelity": "research/rectification/statement_fidelity.md",
        "compiler_certificate": artifact,
        "evidence_id": archived["evidence_id"],
        "compiler": "Lean 4.31.0",
        "compiler_status": "success",
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "source_sha256": source_hash,
        "statement_fidelity_sha256": fidelity_hash,
        "scope": (
            "Universal three-layer rectification in graded-module and "
            "quiver-presentation coordinates, including both actions, "
            "right-projective finite bounded terms, vertex homotopy "
            "equivalences, and right-linear arrow homotopies."
        ),
        "replay_scope": (
            "Checks recorded compiler evidence and source/fidelity freshness; "
            "does not rerun Lean or independently establish statement fidelity."
        ),
    }


def main():
    if not __debug__:
        raise RuntimeError("Run without -O: assertions enforce the exact checks.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact certificate")
    args = parser.parse_args()
    path = ROOT / "exact_certificate.json"
    if args.write:
        recorded = json.loads((ROOT / "lean_verify_output.json").read_text())
        artifact = recorded["kernel"]["recorded"]["artifact"]
    else:
        saved = json.loads(path.read_text())
        artifact = saved["universal_proof"]["compiler_certificate"]
    result = {
        "claim": "C_RECTIFICATION",
        "result_class": "formal_verification",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": "pending",
        "statement_fidelity_review": "pending",
        "novelty_status": "not_assessed",
        "significance_status": "not_assessed",
        "universal_proof": universal_evidence(artifact),
        "fixture": fixture(),
    }
    if args.write:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        equal(result, saved, "certificate differs from exact replay")
    print("PASS: exact nonzero-homotopy fixture and fresh Lean 4.31.0 certificate; "
          "no compiler rerun")


if __name__ == "__main__":
    main()
