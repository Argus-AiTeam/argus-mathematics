#!/usr/bin/env python3
"""Bounded, source-specific tests; not a proof of the component lemma.

Run without writing bytecode:
    python3 -B research/compiler_context/scan_runtime_tests.py
"""

from collections import Counter
from dataclasses import replace
from itertools import product
from pathlib import Path
import random
import sys
from time import perf_counter
import unittest

from scan_runtime import (
    Boundary, C, Cell, D, I, J, JP, LocalRule, Move, N, P, Q, Q_OK,
    Q_REWIND, Q_START, Sector, Side, Tag, TapeMachine, Transition, V, W, Z,
    compile_machine,
)


MEASUREMENTS = Counter()


def machine_identity(*, start="scan", halt="halt", blank="_", alphabet=("a", "b")):
    table = {
        (start, a): Transition(start, a, Move.RIGHT) for a in alphabet
    }
    table[(start, blank)] = Transition(halt, blank, Move.STAY)
    return TapeMachine(
        start, frozenset((halt,)), table, alphabet, (blank,) + alphabet, blank,
    )


def machine_erase():
    table = {
        ("erase", a): Transition("erase", "_", Move.RIGHT) for a in ("a", "b")
    }
    table[("erase", "_")] = Transition("halt", "_", Move.STAY)
    return TapeMachine("erase", frozenset(("halt",)), table)


def machine_walk():
    table = {}
    for state, dest, move in (
        ("start", "zero", Move.LEFT),
        ("zero", "one", Move.RIGHT),
        ("one", "back", Move.LEFT),
        ("back", "one_again", Move.RIGHT),
        ("one_again", "halt", Move.LEFT),
    ):
        for symbol in ("_", "a", "b"):
            table[(state, symbol)] = Transition(dest, symbol, move)
    return TapeMachine("start", frozenset(("halt",)), table)


def words(max_length):
    for length in range(max_length + 1):
        yield from product(("a", "b"), repeat=length)


def reference(machine, word, *, max_steps):
    """Independent ordinary nonnegative tape interpreter, without scan macros."""
    tape = {index: symbol for index, symbol in enumerate(word)}
    head, state = 0, machine.start
    for steps in range(max_steps + 1):
        if state in machine.halts:
            output = []
            for index in range(max(tape, default=-1) + 2):
                symbol = tape.get(index, machine.blank)
                if symbol == machine.blank:
                    return "halt", tuple(output), tape, head, state, steps
                if symbol not in machine.alphabet:
                    return "invalid_output", (), tape, head, state, steps
                output.append(symbol)
            raise AssertionError("finite tape must have a blank outside its support")
        transition = machine.transitions.get((state, tape.get(head, machine.blank)))
        if transition is None:
            return "stuck", (), tape, head, state, steps
        if steps == max_steps:
            return "limit", (), tape, head, state, steps
        tape[head] = transition.write
        head = max(0, head + int(transition.move))
        state = transition.next_state
    raise AssertionError("unreachable")


class RuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.identity = compile_machine(machine_identity())
        cls.erase = compile_machine(machine_erase())
        cls.walk = compile_machine(machine_walk())
        MEASUREMENTS["identity_states"] = len(cls.identity.states)
        MEASUREMENTS["identity_rules"] = len(cls.identity.rules)
        MEASUREMENTS["tag_variants_per_base"] = len(cls.identity.tags)
        MEASUREMENTS["tagged_cells"] = len(cls.identity.cells)

    def run_success(self, runtime, x, y, quota, expected):
        entry = runtime.clean_entry(x, y, quota)
        result = runtime.run(entry, max_steps=10000, record_trace=True)
        self.assertEqual(result.status, "ok", (entry, result))
        self.assertEqual(runtime.marked_output(result.sector), tuple(expected))
        for sector in result.trace:
            self.assertEqual(sector.bases, entry.bases)
            self.assertEqual((sector.alpha, sector.omega), (entry.alpha, entry.omega))
        self.assertIn(Q_START, {s.head for s in result.trace})
        self.assertEqual(result.sector.gap, len(entry.cells))
        self.assertIsNone(runtime.step(result.sector))
        sector = runtime.exit_step(result.sector)
        self.assertIsNotNone(sector)
        for _ in range(len(entry.cells) + 1):
            if sector.head == Q:
                break
            sector = runtime.cleanup_step(sector)
            self.assertIsNotNone(sector)
        self.assertEqual(sector.head, Q)
        self.assertEqual(runtime.raw_payload(sector), tuple(expected))
        MEASUREMENTS["successful_pipelines"] += 1
        MEASUREMENTS["pipeline_internal_steps"] += result.steps
        return result

    def test_source_conventions(self):
        path = (
            Path(__file__).resolve().parents[1] / "openai_manuscript"
            / "Finite-algebraic-envelopes-and-the-Boone-Higman-conjecture-September-23-2026"
            / "build/compiler.tex"
        )
        source = path.read_text()
        for quote in (
            "A bare cell base in a rule means",
            "the cell with its entire tag clean.",
            "All invocations are expanded with distinct phase states",
            "its only incoming rule is the validator handoff",
            "A halt is recognized only at a workspace cell in bounds.",
            "An invalid output symbol, or exhaustion of",
            "with no outgoing",
        ):
            self.assertIn(quote, source)
        compact = "".join(source.split())
        for equation in (
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
            r"q_{\rmstart}\omega\toq_{\rmrewind}\omega",
            r"b_L\mathsfZ\longrightarrow\mathsfZa_R",
            r"b_L\mathsfZ\to\mathsfZ",
            r"\alpha\mathsfZ\to\alpha\mathsfQ",
        ):
            self.assertIn(equation, compact)

    def test_full_expansion_and_state_hygiene(self):
        runtime = self.identity
        self.assertEqual(len(runtime.tags), 8 * 3 * 3)
        self.assertEqual(len(runtime.cells), 5 * len(runtime.tags))
        self.assertEqual(len({(r.state, r.read) for r in runtime.rules}), len(runtime.rules))
        for rule in runtime.rules:
            self.assertIs(rule.side, runtime.states[rule.state])
            self.assertIn(rule.next_state, runtime.states)
            if isinstance(rule.read, Cell):
                self.assertEqual(rule.read.base, rule.write.base)
            else:
                self.assertFalse(rule.cross)
                self.assertIs(rule.read, rule.write)
        incoming = [r for r in runtime.rules if r.next_state == Q_START]
        self.assertEqual(len(incoming), 1)
        self.assertEqual((incoming[0].state, incoming[0].read), (V, Boundary.OMEGA))
        outgoing = [r for r in runtime.rules if r.state == Q_START]
        self.assertEqual(len(outgoing), 1)
        self.assertEqual(
            (outgoing[0].read, outgoing[0].cross, outgoing[0].next_state),
            (Boundary.OMEGA, False, Q_REWIND),
        )
        self.assertFalse(any(r.state == Q_OK for r in runtime.rules))
        self.assertFalse(any(r.next_state in (I, J, JP, N, V) and
                             r.state not in (I, J, JP, N, V) for r in runtime.rules))
        colliding = compile_machine(machine_identity(start=Q_START, halt=Q_OK))
        self.assertNotEqual(colliding.machine_states[Q_START], Q_START)
        self.assertNotEqual(colliding.machine_states[Q_OK], Q_OK)
        self.run_success(colliding, "a", "b", 3, "ab")

    def test_every_expanded_rule_locally_and_in_reverse(self):
        runtime = self.identity
        guard = Cell("b", Tag(True, True, "a", True, "a"))
        for rule in runtime.rules:
            if rule.read is Boundary.ALPHA:
                sector = Sector(True, (), rule.state, (guard,), True)
            elif rule.read is Boundary.OMEGA:
                sector = Sector(True, (guard,), rule.state, (), True)
            elif rule.side is Side.LEFT:
                sector = Sector(True, (guard, rule.read), rule.state, (guard,), True)
            else:
                sector = Sector(True, (guard,), rule.state, (rule.read, guard), True)
            after = runtime.step(sector)
            self.assertEqual(after, rule.apply(sector))
            self.assertEqual(after.bases, sector.bases)
            self.assertEqual((after.alpha, after.omega), (True, True))
            self.assertEqual(rule.inverse(after), sector)
            self.assertIn(sector, runtime.predecessors(after))
            for predecessor in runtime.predecessors(after):
                self.assertEqual(runtime.step(predecessor), after)
            if isinstance(rule.read, Boundary):
                missing = replace(
                    sector, **{"alpha" if rule.side is Side.LEFT else "omega": False},
                )
                self.assertIsNone(runtime.step(missing))
                shadowed = replace(
                    sector, **{"left" if rule.side is Side.LEFT else "right": (guard,)},
                )
                self.assertIsNone(rule.apply(shadowed))
            MEASUREMENTS["expanded_rule_roundtrips"] += 1

    def test_identity_all_short_words_splits_and_two_quotas(self):
        for word in words(4):
            expected = reference(self.identity.machine, word, max_steps=20)
            self.assertEqual(expected[:2], ("halt", word))
            for split in range(len(word) + 1):
                for spare in (1, 2):
                    self.run_success(
                        self.identity, word[:split], word[split:], len(word) + spare, word,
                    )

    def test_erase_all_and_empty_input(self):
        for word in words(3):
            self.assertEqual(reference(self.erase.machine, word, max_steps=20)[:2], ("halt", ()))
            for split in range(len(word) + 1):
                self.run_success(self.erase, word[:split], word[split:], len(word) + 1, ())

    def test_left_right_and_zero_stays(self):
        for word in words(3):
            oracle = reference(self.walk.machine, word, max_steps=20)
            self.assertEqual(oracle[:2], ("halt", word))
            self.assertEqual(oracle[3], 0)
            self.run_success(self.walk, word, (), max(2, len(word) + 1), word)
        runtime = self.walk
        dirty_cut = Cell(C, Tag(True, True, "b", True, "b"))
        sector = Sector(
            False, (dirty_cut,), runtime.machine_states["start"],
            (runtime.clean(W),), False,
        )
        written = runtime.step(sector)
        self.assertEqual(written.gap, 1)
        stayed = runtime.step(written)
        self.assertEqual(stayed.gap, 1)
        self.assertEqual(stayed.head, runtime.machine_states["zero"])
        for left in ((), (runtime.clean("a"),), (runtime.clean(D),)):
            bad = replace(written, left=left, alpha=True)
            self.assertIsNone(runtime.step(bad))

    def test_quota_is_strictly_more_than_input_length(self):
        for runtime in (self.identity, self.erase):
            for word in words(3):
                for quota in range(len(word) + 1):
                    result = runtime.run(runtime.clean_entry(word, (), quota), max_steps=2000)
                    self.assertEqual(result.status, "stuck")
                    self.assertFalse(runtime.is_success(result.sector))
                    MEASUREMENTS["insufficient_quota_runs"] += 1
        result = self.erase.run(self.erase.clean_entry("ab", (), 2), max_steps=2000)
        self.assertEqual(result.sector.head, "copy.check_unfilled.find")

    def test_halt_requires_in_bounds_workspace(self):
        machine = TapeMachine(
            "go", frozenset(("halt",)),
            {("go", "_"): Transition("halt", "_", Move.RIGHT)},
        )
        runtime = compile_machine(machine)
        result = runtime.run(runtime.clean_entry((), (), 1), max_steps=500)
        self.assertEqual(result.status, "stuck")
        self.assertEqual(result.sector.head, runtime.machine_states["halt"])
        self.assertIs(result.sector.right[0].base, D)
        self.run_success(runtime, (), (), 2, ())
        for base in ("a", C, D):
            malformed = Sector(
                True, (), runtime.machine_states["halt"], (runtime.clean(base),), True,
            )
            self.assertIsNone(runtime.step(malformed))

    def test_output_anchor_exhaustion(self):
        machine = TapeMachine(
            "first", frozenset(("halt",)), {
                ("first", "a"): Transition("append", "b", Move.RIGHT),
                ("append", "_"): Transition("halt", "b", Move.STAY),
            },
        )
        self.assertEqual(reference(machine, "a", max_steps=10)[:2], ("halt", ("b", "b")))
        runtime = compile_machine(machine)
        result = runtime.run(runtime.clean_entry("a", (), 3), max_steps=1000)
        self.assertEqual(result.status, "stuck")
        self.assertTrue(result.sector.head.startswith("output.carry."))
        self.assertTrue(result.sector.head.endswith(".find"))
        self.assertEqual(runtime.marked_output(result.sector), ("b",))
        no_anchors = TapeMachine(
            "write", frozenset(("halt",)),
            {("write", "_"): Transition("halt", "a", Move.STAY)},
        )
        runtime = compile_machine(no_anchors)
        result = runtime.run(runtime.clean_entry((), (), 2), max_steps=1000)
        self.assertEqual(result.status, "stuck")

    def test_invalid_output_and_no_workspace_delimiter(self):
        machine = TapeMachine(
            "write", frozenset(("halt",)),
            {("write", "a"): Transition("halt", "X", Move.STAY)},
            tape_alphabet=("_", "a", "b", "X"),
        )
        runtime = compile_machine(machine)
        result = runtime.run(runtime.clean_entry("a", (), 2), max_steps=1000)
        self.assertEqual(result.status, "stuck")
        self.assertEqual(result.sector.head, "output.find_unread")
        self.assertEqual(result.sector.right[0].tag.work, "X")
        self.assertFalse(result.sector.right[0].tag.output_read)
        runtime = self.identity
        sector = Sector(
            True, (runtime.clean("a"), runtime.clean("b"), runtime.clean(C)),
            runtime.machine_states["halt"],
            (Cell(W, Tag(work="a")), Cell(W, Tag(work="b")), runtime.clean(D)), True,
        )
        result = runtime.run(sector, max_steps=1000)
        self.assertEqual(result.status, "stuck")
        self.assertEqual(result.sector.head, "output.find_unread")
        self.assertEqual(result.sector.right, ())
        self.assertEqual(runtime.marked_output(result.sector), ("a", "b"))

    def test_all_dirty_tags_on_every_entry_cell(self):
        runtime = self.identity
        clean = runtime.clean_entry("a", "b", 1)
        for position, cell in enumerate(clean.cells):
            for tag in runtime.tags:
                if tag == cell.tag:
                    continue
                cells = list(clean.cells)
                cells[position] = Cell(cell.base, tag)
                entry = replace(clean, left=tuple(cells[:clean.gap]), right=tuple(cells[clean.gap:]))
                result = runtime.run(entry, max_steps=200, record_trace=True)
                self.assertEqual(result.status, "stuck")
                self.assertNotIn(Q_START, {s.head for s in result.trace})
                MEASUREMENTS["dirty_entry_rejections"] += 1

    def test_malformed_entries_and_missing_boundaries(self):
        runtime = self.identity
        clean = runtime.clean
        for bases in (
            (W,), (C, C, W), (C, W, "b", W), (D, W), ("a", W),
        ):
            sector = Sector(True, tuple(clean(base) for base in bases), I, (clean(D),), True)
            self.assertTrue(runtime.is_entry(sector))
            result = runtime.run(sector, max_steps=200, record_trace=True)
            self.assertEqual(result.status, "stuck")
            self.assertNotIn(Q_START, {s.head for s in result.trace})
        for alpha, omega in product((False, True), repeat=2):
            if alpha and omega:
                continue
            result = runtime.run(
                runtime.clean_entry("a", "b", 3, alpha=alpha, omega=omega),
                max_steps=200, record_trace=True,
            )
            self.assertEqual(result.status, "stuck")
            self.assertNotIn(Q_START, {s.head for s in result.trace})
            MEASUREMENTS["missing_boundary_runs"] += 1
        sector = Sector(
            True, (clean("a"), clean(C)), I, (clean(W), clean(W), clean(D)), True,
        )
        self.assertFalse(runtime.is_entry(sector))
        self.assertEqual(runtime.run(sector, max_steps=1000).status, "ok")
        for alpha, omega in product((False, True), repeat=2):
            sector = Sector(alpha, (), Q_START, (clean(W),), omega)
            self.assertIsNone(runtime.step(sector))
            sector = replace(sector, head=Q_OK)
            self.assertIsNone(runtime.step(sector))
            self.assertFalse(runtime.is_success(sector))
        rewind = Sector(False, (clean(W),), Q_REWIND, (), True)
        result = runtime.run(rewind, max_steps=10)
        self.assertEqual((result.status, result.sector.gap), ("stuck", 0))
        go_right = Sector(True, (), "output.go_right", (clean(W),), False)
        result = runtime.run(go_right, max_steps=10)
        self.assertEqual((result.status, result.sector.gap), ("stuck", 1))

    def test_predicates_and_updates_preserve_untested_fields(self):
        runtime = self.identity
        for cell in runtime.cells:
            sector = Sector(True, (), "copy.find_anchor", (cell,), True)
            after = runtime.step(sector)
            if cell.base in runtime.machine.alphabet and not cell.tag.anchor_read:
                self.assertEqual(after.right[0], replace(cell, tag=replace(cell.tag, anchor_read=True)))
                self.assertEqual(after.gap, 0)
            else:
                self.assertEqual(after.left, (cell,))
            sector = replace(sector, head="copy.carry.0.find")
            after = runtime.step(sector)
            if cell.base is W and not cell.tag.filled:
                self.assertEqual(
                    after.right[0], replace(cell, tag=replace(cell.tag, filled=True, work="a")),
                )
            else:
                self.assertEqual(after.left, (cell,))
            sector = replace(sector, head="output.carry.0.find")
            after = runtime.step(sector)
            if cell.base in runtime.machine.alphabet and cell.tag.output_mark is None:
                self.assertEqual(
                    after.right[0], replace(cell, tag=replace(cell.tag, output_mark="a")),
                )
            else:
                self.assertEqual(after.left, (cell,))
            MEASUREMENTS["full_tag_predicate_cases"] += 3
        sector = Sector(
            True, (runtime.clean("b"), runtime.clean(C)), runtime.machine_states["halt"],
            (
                Cell(W, Tag(output_read=True)), Cell(W, Tag(work="a")),
                runtime.clean(W), runtime.clean(D),
            ), True,
        )
        result = runtime.run(sector, max_steps=1000)
        self.assertEqual(result.status, "ok")
        self.assertEqual(runtime.marked_output(result.sector), ("a",))

    def test_supplied_tables_against_independent_tape_steps(self):
        rng = random.Random(20261105)
        symbols = ("_", "a", "b", "X")
        for _ in range(12):
            table = {}
            for state in ("s", "t"):
                for symbol in symbols:
                    if rng.randrange(5):
                        table[(state, symbol)] = Transition(
                            rng.choice(("s", "t", "halt")), rng.choice(symbols),
                            rng.choice(tuple(Move)),
                        )
            runtime = compile_machine(
                TapeMachine("s", frozenset(("halt",)), table, tape_alphabet=symbols),
            )
            MEASUREMENTS["supplied_tables"] += 1
            for word in ((), ("a",), ("b", "a")):
                work = list(word) + ["_"] * (8 - len(word))
                dirty = Tag(True, True, "_", True, "b")
                sector = Sector(
                    False, (Cell(C, dirty),), runtime.machine_states["s"],
                    tuple(Cell(W, replace(dirty, work=a)) for a in work) + (Cell(D, dirty),),
                    False,
                )
                state, head = "s", 0
                for _ in range(32):
                    if head >= len(work):
                        self.assertIsNone(runtime.step(sector))
                        break
                    if state == "halt":
                        after = runtime.step(sector)
                        self.assertEqual(after.head, "output.halt_rewind")
                        self.assertEqual(after.cells, sector.cells)
                        break
                    transition = table.get((state, work[head]))
                    if transition is None:
                        self.assertIsNone(runtime.step(sector))
                        break
                    work[head] = transition.write
                    head = max(0, head + int(transition.move))
                    after = runtime.step(sector)
                    self.assertIsNotNone(after)
                    if transition.move is Move.LEFT:
                        after = runtime.step(after)
                        self.assertIsNotNone(after)
                    state = transition.next_state
                    self.assertEqual(after.head, runtime.machine_states[state])
                    self.assertEqual(after.gap, head + 1)
                    self.assertEqual([c.tag.work for c in after.cells if c.base is W], work)
                    for cell in after.cells:
                        self.assertEqual(
                            (cell.tag.anchor_read, cell.tag.filled, cell.tag.output_read,
                             cell.tag.output_mark), (True, True, True, "b"),
                        )
                    sector = after
                    MEASUREMENTS["oracle_tape_transitions"] += 1

    def test_nondefault_blank_and_disjoint_base_namespace(self):
        runtime = compile_machine(machine_identity(blank="blank", alphabet=("C", "a", "b")))
        self.assertNotEqual(runtime.clean("C"), runtime.clean(C))
        self.assertEqual(runtime.clean(W).tag.work, "blank")
        self.run_success(runtime, ("C", "a"), ("b",), 4, ("C", "a", "b"))
        with self.assertRaises(ValueError):
            runtime.step(Sector(True, (), I, (Cell(D),), True))

    def test_cycles_and_explicit_run_limits(self):
        table = {
            ("loop", symbol): Transition("loop", symbol, Move.STAY)
            for symbol in ("_", "a", "b")
        }
        runtime = compile_machine(TapeMachine("loop", frozenset(), table))
        entry = runtime.clean_entry("a", (), 2)
        result = runtime.run(entry, max_steps=1000)
        self.assertEqual(result.status, "cycle")
        limited = runtime.run(entry, max_steps=100, detect_cycles=False)
        self.assertTrue(limited.limit_reached)
        self.assertEqual(limited.steps, 100)
        zero = runtime.run(entry, max_steps=0)
        self.assertEqual((zero.status, zero.steps), ("limit", 0))
        terminal = replace(entry, head=Q_OK, left=entry.cells, right=())
        self.assertEqual(runtime.run(terminal, max_steps=0).status, "ok")
        for bad in (-1, True, 1.5):
            with self.assertRaises(ValueError):
                runtime.run(entry, max_steps=bad)

    def test_bounded_component_search_flags_limits(self):
        runtime = self.identity
        sector = Sector(False, (runtime.clean(W), runtime.clean(W)), I, (runtime.clean(D),), False)
        component = runtime.weak_component(sector, max_vertices=10, max_edges=50)
        self.assertTrue(component.complete)
        self.assertFalse(component.limit_reached)
        self.assertEqual(len(component.vertices), 3)
        self.assertEqual(component.entries, (sector,))
        self.assertEqual(component.successes, ())
        self.assertEqual({s.bases for s in component.vertices}, {sector.bases})
        vertex_limit = runtime.weak_component(sector, max_vertices=1, max_edges=50)
        self.assertFalse(vertex_limit.complete)
        self.assertEqual(vertex_limit.limit_reason, "max_vertices")
        edge_limit = runtime.weak_component(sector, max_vertices=10, max_edges=0)
        self.assertFalse(edge_limit.complete)
        self.assertEqual(edge_limit.limit_reason, "max_edges")
        isolated = Sector(False, (), I, (runtime.clean(D),), False)
        complete = runtime.weak_component(isolated, max_vertices=1, max_edges=0)
        self.assertTrue(complete.complete)
        self.assertEqual(complete.vertices, (isolated,))
        MEASUREMENTS["bounded_components"] += 4

    def test_cleanup_on_dirty_cells_and_missing_alpha(self):
        runtime = self.identity
        dirty = Tag(True, True, "b", True, "a")
        sector = Sector(
            False, (Cell("b", dirty), Cell(C, dirty), Cell(W, dirty), Cell(D, dirty)),
            Z, (), False,
        )
        for _ in range(4):
            sector = runtime.cleanup_step(sector)
        self.assertEqual(sector.right, (runtime.clean("a"),))
        self.assertIsNone(runtime.cleanup_step(sector))
        with_alpha = replace(sector, alpha=True)
        self.assertEqual(runtime.cleanup_step(with_alpha).head, Q)

    def test_reject_invalid_api_data_without_cleaning_it(self):
        for call in (
            lambda: Transition("h", "a", 2),
            lambda: Transition("h", "a", True),
            lambda: TapeMachine("s", frozenset(), {("s", "X"): Transition("s", "a", 0)}),
            lambda: TapeMachine("s", frozenset(), {("s", "a"): Transition("s", "X", 0)}),
            lambda: TapeMachine("s", frozenset(("s",)), {("s", "a"): Transition("s", "a", 0)}),
            lambda: TapeMachine("s", frozenset(), {}, alphabet=("a", "a")),
            lambda: TapeMachine("s", frozenset(), {}, blank="X"),
            lambda: TapeMachine("s", frozenset(), {}, alphabet=("_", "a")),
            lambda: TapeMachine("s", frozenset(), {("s",): Transition("s", "a", 0)}),
            lambda: TapeMachine("s", frozenset(), {("s", "a"): ("s", "a", 0)}),
            lambda: Tag(anchor_read=1),
            lambda: LocalRule("s", Side.RIGHT, Cell("a"), Cell("b"), True, "s", "test"),
            lambda: LocalRule(
                "s", Side.RIGHT, Boundary.ALPHA, Boundary.ALPHA, False, "s", "test",
            ),
        ):
            with self.assertRaises(ValueError):
                call()
        runtime = self.identity
        with self.assertRaises(ValueError):
            runtime.clean_entry("X", (), 2)
        with self.assertRaises(ValueError):
            runtime.step(Sector(True, (), "unknown", (), True))
        with self.assertRaises(ValueError):
            runtime.step(Sector(True, (), I, (Cell(D, Tag(output_mark="X")),), True))
        with self.assertRaises(ValueError):
            runtime.weak_component(runtime.clean_entry((), (), 1), max_vertices=0, max_edges=1)


if __name__ == "__main__":
    import json

    started = perf_counter()
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(RuntimeTests)
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    print(json.dumps({
        "scope": "bounded runtime tests only; no universal lemma certification",
        "tests_run": result.testsRun,
        "successful": result.wasSuccessful(),
        "elapsed_seconds": round(perf_counter() - started, 3),
        "measurements": dict(sorted(MEASUREMENTS.items())),
    }, sort_keys=True))
    sys.exit(0 if result.wasSuccessful() else 1)
