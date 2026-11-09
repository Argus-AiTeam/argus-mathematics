#!/usr/bin/env python3
"""Replay the scoped raw-algebra certificate and bounded malformed-sector tests."""

import argparse
from collections import Counter, defaultdict
from dataclasses import dataclass, replace
import hashlib
import io
from itertools import product
import json
from pathlib import Path
import unittest


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MANUSCRIPT = (
    ROOT
    / "research/openai_manuscript"
    / "Finite-algebraic-envelopes-and-the-Boone-Higman-conjecture-September-23-2026"
    / "build"
)


@dataclass(frozen=True, slots=True)
class Cell:
    base: str
    tag: int = 0

    def clean_anchor(self):
        return self.base in ("a", "b") and self.tag == 0

    def output(self):
        return {2: "a", 3: "b"}.get(self.tag)

    def grade(self):
        return 2 if self.base == "C" else 0 if self.base == "W" else 1


C, D, W = Cell("C"), Cell("D"), Cell("W")


@dataclass(frozen=True, slots=True)
class Sector:
    alpha: bool
    left: tuple[Cell, ...]
    head: str
    right: tuple[Cell, ...]
    omega: bool

    def grade(self):
        return (
            int(self.alpha)
            + int(self.omega)
            + 1
            + sum(c.grade() for c in self.left + self.right)
        )


def cleanup_step(s):
    assert s.head == "Z"
    if s.left:
        b = s.left[-1]
        emitted = ()
        if b.base in ("a", "b") and b.output() is not None:
            emitted = (Cell(b.output()),)
        return replace(s, left=s.left[:-1], right=emitted + s.right)
    if s.alpha:
        return replace(s, head="Q")
    return None


def preprocess(s):
    if s.head == "Q":
        left, right = s.left, s.right
        while left and left[-1].clean_anchor():
            right = (left[-1],) + right
            left = left[:-1]
        return (replace(s, left=left, right=right),)
    if s.head == "P":
        if not s.right or s.right[0] != D:
            return (s,)
        left = s.left
        while left and left[-1] == W:
            left = left[:-1]
        if left and left[-1] == C:
            a = Sector(s.alpha, left[:-1], "Q", (), True)
            b = Sector(True, (), "Q", s.right[1:], s.omega)
            return preprocess(a) + preprocess(b)
        return (replace(s, left=left),)
    if s.head == "Z":
        while s.head == "Z":
            nxt = cleanup_step(s)
            if nxt is None:
                return (s,)
            assert nxt.grade() <= s.grade()
            s = nxt
        return preprocess(s)
    raise ValueError(f"Unmodelled internal head {s.head!r}")


def source_guard():
    compiler = (MANUSCRIPT / "compiler.tex").read_text()
    compact = "".join(compiler.split())
    fragments = (
        r"\mathsfQa_R&=a_L\mathsfQ",
        r"\mathsfQ\omega\alpha\mathsfQ&=\mathsfC_L\mathsfP\mathsfD_R",
        r"\mathsfP\mathsfD_R&=\mathsfW_L\mathsfP\mathsfD_R",
        r"\mathsfP\mathsfD_R&=\mathsfI\mathsfD_R",
        r"\mathsfW_L\mathsfI&\longrightarrow\mathsfI\mathsfW_R",
        r"\mathsfC_L\mathsfI&\longrightarrow\mathsfJ\mathsfC_R",
        r"a_L\mathsfJ&\longrightarrow\mathsfJa_R",
        r"\alpha\mathsfJ&\longrightarrow\alpha\mathsfJ'",
        r"\mathsfJ'a_R&\longrightarrowa_L\mathsfJ'",
        r"\mathsfJ'\mathsfC_R&\longrightarrow\mathsfC_L\mathsfN",
        r"\mathsfN\mathsfW_R&\longrightarrow\mathsfW_L\mathsfN",
        r"\mathsfN\mathsfD_R&\longrightarrow\mathsfD_L\mathsfV",
        r"\mathsfVa_R&\longrightarrowa_L\mathsfV",
        r"\mathsfV\omega&\longrightarrowq_{\rmstart}\omega",
        r"b_L\mathsfZ\longrightarrow\mathsfZa_R",
        r"b_L\mathsfZ\to\mathsfZ",
        r"\alpha\mathsfZ\to\alpha\mathsfQ",
    )
    for fragment in fragments:
        assert fragment in compact, f"Source equation changed: {fragment}"
    assert "A bare cell base in a rule means" in compiler
    assert "the cell with its entire tag clean" in compiler
    return {"equation_fragments": len(fragments), "tag_convention": "entire tag clean"}


def check_preprocessing():
    cells = tuple(Cell(b, t) for b in ("a", "b", "C", "D", "W") for t in range(4))
    counts = Counter()
    for n in range(4):
        for word in product(cells, repeat=n):
            for gap in range(n + 1):
                left, right = word[:gap], word[gap:]
                for alpha, omega in product((False, True), repeat=2):
                    for head in ("Q", "P", "Z"):
                        s = Sector(alpha, left, head, right, omega)
                        out = preprocess(s)
                        assert sum(t.grade() for t in out) <= s.grade(), s
                        counts["graded_preprocessings"] += 1
                        if head == "Q" and right and right[0].clean_anchor():
                            nxt = replace(s, left=left + right[:1], right=right[1:])
                            assert out == preprocess(nxt), ("slide", s, nxt)
                            counts["slide_equations"] += 1
                        if head == "P" and right and right[0] == D:
                            nxt = replace(s, left=left + (W,))
                            assert out == preprocess(nxt), ("quota", s, nxt)
                            counts["quota_equations"] += 1
                        if head == "Z":
                            nxt = cleanup_step(s)
                            if nxt is not None:
                                assert out == preprocess(nxt), ("cleanup", s, nxt)
                                counts["cleanup_equations"] += 1
                    a = Sector(alpha, left, "Q", (), True)
                    b = Sector(True, (), "Q", right, omega)
                    merged = Sector(alpha, left + (C,), "P", (D,) + right, omega)
                    assert preprocess(a) + preprocess(b) == preprocess(merged), (
                        "merge",
                        a,
                        b,
                        merged,
                    )
                    assert a.grade() + b.grade() == merged.grade()
                    counts["merge_equations"] += 1
    return {
        "result_class": "finite_verification",
        "max_original_cells": 3,
        "anchor_representatives": ["a", "b"],
        "tag_classes": ["clean", "dirty_unmarked", "marked_a", "marked_b"],
        "outer_boundaries": "all four choices",
        "counts": dict(sorted(counts.items())),
    }


PHASES = ("I", "J", "Jp", "N", "V", "start")


def validator_step(word, alpha, omega, state):
    phase, gap = state
    left = word[gap - 1] if gap else None
    right = word[gap] if gap < len(word) else None
    if phase == "I":
        if left == W:
            return ("I", gap - 1)
        if left == C:
            return ("J", gap - 1)
    elif phase == "J":
        if left == Cell("a"):
            return ("J", gap - 1)
        if gap == 0 and alpha:
            return ("Jp", gap)
    elif phase == "Jp":
        if right == Cell("a"):
            return ("Jp", gap + 1)
        if right == C:
            return ("N", gap + 1)
    elif phase == "N":
        if right == W:
            return ("N", gap + 1)
        if right == D:
            return ("V", gap + 1)
    elif phase == "V":
        if right == Cell("a"):
            return ("V", gap + 1)
        if gap == len(word) and omega:
            return ("start", gap)
    return None


def clean_entry(word, alpha, omega, gap):
    if not alpha or not omega or word[gap : gap + 1] != (D,):
        return False
    left = word[:gap]
    while left and left[-1] == W:
        left = left[:-1]
    return (
        bool(left)
        and left[-1] == C
        and all(c == Cell("a") for c in left[:-1])
        and all(c == Cell("a") for c in word[gap + 1 :])
    )


def check_validator():
    cells = tuple(Cell(b, dirty) for b in ("a", "C", "D", "W") for dirty in (0, 1))
    counts = Counter()
    for n in range(5):
        for word in product(cells, repeat=n):
            states = tuple(product(PHASES, range(n + 1)))
            for alpha, omega in product((False, True), repeat=2):
                outgoing = {
                    s: validator_step(word, alpha, omega, s) for s in states
                }
                predecessors = defaultdict(list)
                neighbors = {s: [] for s in states}
                for s, t in outgoing.items():
                    if t is not None:
                        predecessors[t].append(s)
                        neighbors[s].append(t)
                        neighbors[t].append(s)
                        counts["transitions"] += 1
                assert all(len(p) <= 1 for p in predecessors.values())
                counts["configurations"] += len(states)
                entries = {("I", i) for i in range(n) if word[i] == D}
                assert all(not predecessors[e] for e in entries)
                passing = 0
                for e in entries:
                    s, seen = e, set()
                    while outgoing[s] is not None:
                        assert s not in seen, ("validator cycle", word, e)
                        seen.add(s)
                        s = outgoing[s]
                    accepted = s[0] == "start"
                    assert accepted == clean_entry(word, alpha, omega, e[1]), (
                        "entry language",
                        word,
                        alpha,
                        omega,
                        e,
                    )
                    passing += int(accepted)
                    counts["entries"] += 1
                    counts["passing_entries"] += int(accepted)
                assert passing <= 1
                seen = set()
                for s in states:
                    if s in seen:
                        continue
                    component, todo = set(), [s]
                    while todo:
                        t = todo.pop()
                        if t not in component:
                            component.add(t)
                            todo.extend(neighbors[t])
                    seen.update(component)
                    assert len(entries & component) <= 1
                    counts["weak_components"] += 1
    return {
        "result_class": "finite_verification",
        "max_cells": 4,
        "anchor_quotient": "one base; validator preserves anchor identity",
        "tag_quotient": "clean versus arbitrary nonclean",
        "states": list(PHASES),
        "excluded": "all machine-phase transitions after q_start",
        "counts": dict(sorted(counts.items())),
    }


def normalize_tokens(tokens, f):
    out, calls = [], []
    for kind, value in reversed(tokens):
        if kind == "raw" and out and out[0][0] == "raw":
            arg = value + out[0][1]
            calls.append(arg)
            out[0] = ("raw", f(arg))
        else:
            out.insert(0, (kind, value))
    return tuple(out), calls


def source_tokens(tokens, f):
    out, run = [], []

    def flush():
        if len(run) == 1:
            out.append(("raw", run[0]))
        elif run:
            out.append(("raw", f("".join(run))))
        run.clear()

    for kind, value in tokens:
        if kind == "raw":
            run.append(value)
        else:
            flush()
            out.append((kind, value))
    flush()
    return tuple(out)


def token_grade(tokens):
    return sum(3 + len(value) if kind == "raw" else 1 for kind, value in tokens)


def check_tokens():
    programs = {
        "identity": lambda w: w,
        "erase_all": lambda w: "",
        "erase_b": lambda w: w.replace("b", ""),
        "length_parity": lambda w: "a" if len(w) % 2 else "",
    }
    words = tuple(
        "".join(w) for n in range(5) for w in product(("a", "b"), repeat=n)
    )
    counts = Counter()
    alphabet = tuple(("raw", w) for w in ("", "a", "b", "aa", "ab")) + (
        ("barrier", "dirty_or_incomplete"),
    )
    for f in programs.values():
        for w in words:
            assert len(f(w)) <= len(w)
            for x in words:
                for y in words:
                    if len(x + w + y) <= 4:
                        assert f(x + f(w) + y) == f(x + w + y)
                        counts["bounded_budget_instances"] += 1
        for n in range(5):
            for ts in product(alphabet, repeat=n):
                out, calls = normalize_tokens(ts, f)
                assert out == source_tokens(ts, f)
                assert token_grade(out) <= token_grade(ts)
                assert all(len(arg) <= token_grade(ts) for arg in calls)
                counts["token_lists"] += 1
                for i in range(n - 1):
                    if ts[i][0] == ts[i + 1][0] == "raw":
                        arg = ts[i][1] + ts[i + 1][1]
                        contracted = ts[:i] + (("raw", f(arg)),) + ts[i + 2 :]
                        assert normalize_tokens(contracted, f)[0] == out
                        assert token_grade(contracted) <= token_grade(ts)
                        counts["contextual_raw_contractions"] += 1
        groups = defaultdict(list)
        for n in range(3):
            for ts in product(alphabet, repeat=n):
                groups[normalize_tokens(ts, f)[0]].append(ts)
        contexts = ((),) + tuple((t,) for t in alphabet)
        for group in groups.values():
            for u, v in product(group, repeat=2):
                for l, r in product(contexts, repeat=2):
                    assert normalize_tokens(l + u + r, f)[0] == normalize_tokens(
                        l + v + r, f
                    )[0]
                    counts["equal_output_contexts"] += 1
        for w in words:
            assert normalize_tokens((("raw", w),), f) == ((("raw", w),), [])
    assert "".join(reversed("ab")) != "ab"
    reversal = lambda w: w[::-1]
    assert reversal(reversal("ab")) != reversal("ab")
    return {
        "result_class": "finite_verification",
        "programs": list(programs),
        "max_token_count": 4,
        "max_budget_test_word_length": 4,
        "negative_control": "reversal fails the required contextual identity",
        "counts": dict(sorted(counts.items())),
    }


def formal_evidence(source_name, fidelity_name, evidence_dir, claim, scope):
    source = (HERE / source_name).read_bytes()
    fidelity = (HERE / fidelity_name).read_bytes()
    source_hash = hashlib.sha256(source).hexdigest()
    fidelity_hash = hashlib.sha256(fidelity).hexdigest()
    matches = []
    for path in sorted((HERE / evidence_dir / "certificates").glob("*.json")):
        certificate = json.loads(path.read_text())
        check = certificate["lean_check"]
        if check["source_sha256"] != source_hash:
            continue
        if check["statement_fidelity_sha256"] != fidelity_hash:
            continue
        assert check["status"] == "success"
        assert check["exit_code"] == 0 and check["audit_exit_code"] == 0
        assert check["proof_holes"] == []
        assert "4.31.0" in check["tools"]["lean"]["version"]
        assert Path(check["source"]).read_bytes() == source
        assert Path(check["statement_fidelity"]).read_bytes() == fidelity
        assert certificate["subject"]["subject_id"] == claim
        assert certificate["verdict"] == "supports"
        matches.append(str(path.relative_to(ROOT)))
    assert matches, "No fresh successful Lean certificate for this source and fidelity."
    return {
        "result_class": "formal_verification",
        "claim": claim,
        "certificate": matches[-1],
        "compiler_exit_code": 0,
        "proof_holes": [],
        "scope": scope,
        "full_compiler_verified": False,
    }


def jacobian_evidence():
    status = json.loads((HERE / "jacobian_associativity_status.json").read_text())
    contract = json.loads((HERE / "jacobian_smt_contract.json").read_text())
    error = json.loads((HERE / "jacobian_associativity_result.json").read_text())
    assert contract["server"]["version"] == status["server_version"]
    assert contract["protocol_version"] == status["protocol_version"]
    assert contract["result"]["operation"]["operation_id"] == status["operation_id"]
    assert status["adapter_exit_code"] == 2 and status["timeout"] is False
    assert error["ok"] is False
    assert error["error"]["data"]["code"] == "INVALID_REQUEST"
    assert error["error"]["data"]["operation_id"] == status["operation_id"]
    assert error["error"]["data"]["stage"] == "operation_validation"
    return status


def scan_runtime_evidence():
    from scan_runtime_tests import MEASUREMENTS, RuntimeTests

    MEASUREMENTS.clear()
    stream = io.StringIO()
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(RuntimeTests)
    result = unittest.TextTestRunner(stream=stream).run(suite)
    assert result.wasSuccessful(), stream.getvalue()
    return {
        "result_class": "finite_verification",
        "tests_run": result.testsRun,
        "measurements": dict(sorted(MEASUREMENTS.items())),
        "scope": "literal local scan runtime; tests are not the parametric proof",
    }


def replay():
    return {
        "result_class": "parametric_proof",
        "full_mission_acceptance": False,
        "independent_review": "required for the new composition proof",
        "manuscript_claim": "lem:compiler",
        "counterexample": None,
        "ordinary_proof": {
            "path": "research/compiler_context/compiler_theorem.md",
            "coverage": [
                "all presentation words, including malformed sectors and nonpaths",
                "exact bounded totality and contextual hypotheses",
                "scan/copy/simulation/output invariants and sufficient finite quota",
                "complete internal weak-component classification",
                "quota-to-entry and successful-exit equations in arbitrary contexts",
                "termination, program-call bounds and grade-nonincreasing derivations",
                "raw singletons, raw products and arbitrary-word context transport",
            ],
            "source_translation_review": "pending independent Reviewer",
            "fully_kernel_closed_literal_compiler": False,
            "novelty_status": "unverified",
        },
        "source_guard": source_guard(),
        "raw_run_theorem": formal_evidence(
            "Main.lean",
            "statement_fidelity.md",
            "lean_evidence",
            "C_COMPILER_RUN_ALGEBRA",
            "arbitrary alphabets, barriers, payloads, budgets, and token contexts",
        ),
        "primitive_preprocessing_theorem": formal_evidence(
            "Preprocess.lean",
            "preprocess_fidelity.md",
            "preprocess_evidence",
            "C_COMPILER_PRIMITIVE_PREPROCESS",
            "arbitrary anchors, dirty tag decorations, cell contexts, and boundary flags",
        ),
        "execution_theorems": formal_evidence(
            "CompilerProof.lean",
            "execution_fidelity.md",
            "execution_evidence",
            "C_COMPILER_EXECUTION_THEOREMS",
            "exact validator, arbitrary-list scans, copy/output arrays, arbitrary-table "
            "bounded pipelines, component criterion and original-word transport",
        ),
        "literal_scan_runtime": scan_runtime_evidence(),
        "jacobian": jacobian_evidence(),
        "validator": check_validator(),
        "preprocessing": check_preprocessing(),
        "token_experiments": check_tokens(),
        "remaining_review_boundary": (
            "The complete ordinary proof supplies the source-specific scan refinement, "
            "entry-component instantiation, exit comparison and literal-word lift. "
            "Independent review must assess those arguments. The Lean certificates "
            "do not claim a kernel definition of the full interleaved scan compiler "
            "and literal word evaluator."
        ),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = replay()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(path.read_text()) == result, "Certificate does not replay."
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
