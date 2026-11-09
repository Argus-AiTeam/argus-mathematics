#!/usr/bin/env python3
"""Literal finite-scan runtime for the manuscript's compiler.tex.

This module uses only the standard library and does not import verify.py or
read the manuscript.  Its scope is one headed sector, not the monoid word
evaluator.  The quiver already puts every cell on the appropriate L/R side.

Public API
----------
* ``TapeMachine(start, halts, transitions, alphabet=..., tape_alphabet=...,
  blank=...)`` specifies a finite, possibly partial deterministic table.
  Keys are ``(state, work_symbol)``; values are
  ``Transition(next_state, write, Move.LEFT/STAY/RIGHT)``.  Missing transitions
  get stuck; only explicitly declared halting states halt.
* ``compile_machine(machine)`` returns a ``ScanRuntime``.  ``rules`` is the
  fully expanded tuple of local rules; ``states`` records reading sides;
  ``machine_states`` maps supplied state names to fresh simulation heads.
* ``runtime.clean_entry(x, y, quota, alpha=True, omega=True)`` constructs
  alpha x_L C_L W_L^quota I D_R y_R omega with entirely clean tags.
* ``runtime.step(sector)`` is one internal step or None.  ``runtime.run(
  sector, max_steps=N)`` returns status ``ok``, ``stuck``, ``cycle``, or
  ``limit``.  ``record_trace=True`` retains the initial and visited sectors.
* ``runtime.predecessors(sector)`` inverts the actual compiled rules.
  ``runtime.weak_component(sector, max_vertices=N, max_edges=M)`` is bounded.
  Its ``complete`` flag refers only to this particular component; a limit
  never establishes absence, uniqueness, reachability, or any general lemma.
* ``runtime.exit_step`` and ``runtime.cleanup_step`` implement the separate
  exit/cleanup equations.  They are NOT internal edges.  ``raw_payload``
  recognizes a full, clean raw singleton after cleanup.

Tags retain all five source fields on every base.  C, D, W are enum members,
so even an anchor named "C" is distinct from the first cut.  For a nondefault
blank, construct clean cells using ``runtime.clean(base)`` rather than the
default ``Tag()``.  Alphabets and outputs are sequences of string tokens;
ordinary strings also work when the alphabet has single-character tokens.

Every scan invocation has its own states.  Only the repetitions explicitly
specified in the source return to an existing scan.  In particular q_start
is fresh and q_ok has no outgoing internal rule.  Bases and boundary flags
are immutable under internal steps.  Finite tests of this implementation
are not a universal proof of the manuscript's component lemma.
"""

from collections import defaultdict, deque
from collections.abc import Mapping
from dataclasses import dataclass, field, replace
from enum import Enum, IntEnum
from itertools import product
from types import MappingProxyType


class Base(Enum):
    C = "C"
    D = "D"
    W = "W"


C, D, W = Base.C, Base.D, Base.W


class Side(Enum):
    LEFT = "left"
    RIGHT = "right"

    @property
    def opposite(self):
        return Side.RIGHT if self is Side.LEFT else Side.LEFT


class Boundary(Enum):
    ALPHA = "alpha"
    OMEGA = "omega"


class Move(IntEnum):
    LEFT = -1
    STAY = 0
    RIGHT = 1


I, J, JP, N, V = "I", "J", "J'", "N", "V"
Q_START, Q_REWIND, Q_OK = "q_start", "q_rewind", "q_ok"
Q, P, Z = "Q", "P", "Z"


def _bound(value, name, minimum=0):
    if type(value) is not int or value < minimum:
        raise ValueError(f"{name} must be an integer >= {minimum}")


def _symbols(values, name):
    values = tuple(values)
    if not values or any(not isinstance(value, str) for value in values):
        raise ValueError(f"{name} must be a nonempty finite sequence of strings")
    if len(set(values)) != len(values):
        raise ValueError(f"{name} contains duplicate symbols")
    return tuple(sorted(values))


@dataclass(frozen=True, slots=True)
class Transition:
    next_state: str
    write: str
    move: Move

    def __post_init__(self):
        if not isinstance(self.next_state, str) or not isinstance(self.write, str):
            raise ValueError("transition state and write symbol must be strings")
        if isinstance(self.move, bool) or not isinstance(self.move, (int, Move)):
            raise ValueError("move must be Move.LEFT, STAY, RIGHT (or -1, 0, 1)")
        try:
            object.__setattr__(self, "move", Move(self.move))
        except ValueError as exc:
            raise ValueError("move must be -1, 0, or 1") from exc


@dataclass(frozen=True, slots=True)
class TapeMachine:
    start: str
    halts: frozenset[str]
    transitions: Mapping
    alphabet: tuple[str, ...] = ("a", "b")
    tape_alphabet: tuple[str, ...] = ("_", "a", "b")
    blank: str = "_"
    states: tuple[str, ...] = field(init=False)

    def __post_init__(self):
        alphabet = _symbols(self.alphabet, "alphabet")
        tape = _symbols(self.tape_alphabet, "tape_alphabet")
        if not isinstance(self.blank, str) or self.blank not in tape:
            raise ValueError("blank must belong to tape_alphabet")
        if self.blank in alphabet or not set(alphabet).issubset(tape):
            raise ValueError("input symbols must be nonblank tape symbols")
        if not isinstance(self.start, str):
            raise ValueError("start must be a string state name")
        halts = frozenset(self.halts)
        if any(not isinstance(state, str) for state in halts):
            raise ValueError("halting state names must be strings")
        if not isinstance(self.transitions, Mapping):
            raise ValueError("transitions must be a mapping with unique keys")
        table = {}
        states = {self.start, *halts}
        for key, transition in self.transitions.items():
            if (
                not isinstance(key, tuple)
                or len(key) != 2
                or not isinstance(key[0], str)
                or key[1] not in tape
            ):
                raise ValueError(f"invalid transition key: {key!r}")
            if not isinstance(transition, Transition):
                raise ValueError("table values must be Transition objects")
            if transition.write not in tape:
                raise ValueError("transition writes outside tape_alphabet")
            if key[0] in halts:
                raise ValueError("a halting state cannot also have transitions")
            table[key] = transition
            states.update((key[0], transition.next_state))
        object.__setattr__(self, "alphabet", alphabet)
        object.__setattr__(self, "tape_alphabet", tape)
        object.__setattr__(self, "halts", halts)
        object.__setattr__(self, "transitions", MappingProxyType(dict(sorted(table.items()))))
        object.__setattr__(self, "states", tuple(sorted(states)))


@dataclass(frozen=True, slots=True)
class Tag:
    anchor_read: bool = False
    filled: bool = False
    work: str = "_"
    output_read: bool = False
    output_mark: str | None = None

    def __post_init__(self):
        if any(type(bit) is not bool for bit in (self.anchor_read, self.filled, self.output_read)):
            raise ValueError("tag bits must be booleans")
        if not isinstance(self.work, str) or (
            self.output_mark is not None and not isinstance(self.output_mark, str)
        ):
            raise ValueError("work and output marks must be string symbols")


@dataclass(frozen=True, slots=True)
class Cell:
    base: str | Base
    tag: Tag = Tag()

    def __post_init__(self):
        if not isinstance(self.base, (str, Base)) or not isinstance(self.tag, Tag):
            raise ValueError("a cell needs a string/special base and a full Tag")


@dataclass(frozen=True, slots=True)
class Sector:
    alpha: bool
    left: tuple[Cell, ...]
    head: str
    right: tuple[Cell, ...]
    omega: bool

    def __post_init__(self):
        if type(self.alpha) is not bool or type(self.omega) is not bool:
            raise ValueError("boundary flags must be booleans")
        if not isinstance(self.head, str):
            raise ValueError("head must be a string state name")
        object.__setattr__(self, "left", tuple(self.left))
        object.__setattr__(self, "right", tuple(self.right))
        if any(not isinstance(cell, Cell) for cell in self.cells):
            raise ValueError("sector loops must be Cell objects")

    @property
    def cells(self):
        return self.left + self.right

    @property
    def bases(self):
        return tuple(cell.base for cell in self.cells)

    @property
    def gap(self):
        return len(self.left)


def _read(sector, side):
    if side is Side.LEFT:
        return sector.left[-1] if sector.left else (Boundary.ALPHA if sector.alpha else None)
    return sector.right[0] if sector.right else (Boundary.OMEGA if sector.omega else None)


@dataclass(frozen=True, slots=True)
class LocalRule:
    state: str
    side: Side
    read: Cell | Boundary
    write: Cell | Boundary
    cross: bool
    next_state: str
    source: str

    def __post_init__(self):
        if not isinstance(self.side, Side) or type(self.cross) is not bool:
            raise ValueError("a local rule needs a reading side and a crossing flag")
        if isinstance(self.read, Cell):
            if not isinstance(self.write, Cell) or self.read.base != self.write.base:
                raise ValueError("internal cell rules must preserve the base")
        elif isinstance(self.read, Boundary):
            boundary = Boundary.ALPHA if self.side is Side.LEFT else Boundary.OMEGA
            if self.read is not boundary or self.write is not self.read or self.cross:
                raise ValueError("boundary rules must be stationary on their reading side")
        else:
            raise ValueError("rule must read a tagged cell or a boundary")

    def apply(self, sector):
        if sector.head != self.state or _read(sector, self.side) != self.read:
            return None
        if isinstance(self.read, Boundary):
            return replace(sector, head=self.next_state)
        if self.side is Side.RIGHT:
            if self.cross:
                return replace(
                    sector, left=sector.left + (self.write,),
                    head=self.next_state, right=sector.right[1:],
                )
            return replace(sector, head=self.next_state, right=(self.write,) + sector.right[1:])
        if self.cross:
            return replace(
                sector, left=sector.left[:-1],
                head=self.next_state, right=(self.write,) + sector.right,
            )
        return replace(sector, left=sector.left[:-1] + (self.write,), head=self.next_state)

    def inverse(self, sector):
        if sector.head != self.next_state:
            return None
        written_side = self.side.opposite if self.cross else self.side
        if _read(sector, written_side) != self.write:
            return None
        if isinstance(self.read, Boundary):
            return replace(sector, head=self.state)
        if self.side is Side.RIGHT:
            if self.cross:
                return replace(
                    sector, left=sector.left[:-1],
                    head=self.state, right=(self.read,) + sector.right,
                )
            return replace(sector, head=self.state, right=(self.read,) + sector.right[1:])
        if self.cross:
            return replace(
                sector, left=sector.left + (self.read,),
                head=self.state, right=sector.right[1:],
            )
        return replace(sector, left=sector.left[:-1] + (self.read,), head=self.state)


@dataclass(frozen=True, slots=True)
class RunResult:
    status: str
    sector: Sector
    steps: int
    trace: tuple[Sector, ...] = ()

    @property
    def limit_reached(self):
        return self.status == "limit"


@dataclass(frozen=True, slots=True)
class ComponentResult:
    vertices: tuple[Sector, ...]
    entries: tuple[Sector, ...]
    successes: tuple[Sector, ...]
    edges_examined: int
    complete: bool
    limit_reason: str | None

    @property
    def limit_reached(self):
        return not self.complete


class _Builder:
    def __init__(self, cells):
        self.cells = cells
        self.states = {}
        self.rules = {}

    def state(self, name, side):
        if name in self.states:
            raise ValueError(f"scan state reused: {name}")
        self.states[name] = side
        return name

    def add(self, state, read, write, cross, next_state, source):
        key = (state, read)
        if key in self.rules:
            raise ValueError(f"overlapping rules at {key!r}")
        self.rules[key] = LocalRule(
            state, self.states[state], read, write, cross, next_state, source,
        )

    def boundary(self, state, next_state, source):
        symbol = Boundary.ALPHA if self.states[state] is Side.LEFT else Boundary.OMEGA
        self.add(state, symbol, symbol, False, next_state, source)

    def rewind(self, state, continuation, source):
        for cell in self.cells:
            self.add(state, cell, cell, True, state, source)
        self.boundary(state, continuation, source)

    def find(self, state, predicate, match, source, end=None):
        for cell in self.cells:
            if predicate(cell):
                update = match(cell)
                if update is not None:
                    written, continuation = update
                    self.add(state, cell, written, False, continuation, source)
            else:
                self.add(state, cell, cell, True, state, source)
        if end is not None:
            self.boundary(state, end, source)

    def go_right(self, state, continuation, source):
        for cell in self.cells:
            self.add(state, cell, cell, True, state, source)
        self.boundary(state, continuation, source)


def _retag(cell, **changes):
    return replace(cell, tag=replace(cell.tag, **changes))


def _compile(machine, cells, clean):
    b = _Builder(cells)
    for head in (I, J):
        b.state(head, Side.LEFT)
    for head in (JP, N, V, Q_START, Q_OK):
        b.state(head, Side.RIGHT)
    b.state(Q_REWIND, Side.LEFT)
    anchor_find = b.state("copy.find_anchor", Side.RIGHT)
    blank_rewind = b.state("copy.check_unfilled.rewind", Side.LEFT)
    blank_find = b.state("copy.check_unfilled.find", Side.RIGHT)
    first_rewind = b.state("copy.locate_first.rewind", Side.LEFT)
    first_find = b.state("copy.locate_first.find", Side.RIGHT)
    copy_carry, output_carry = {}, {}
    for index, symbol in enumerate(machine.alphabet):
        copy_carry[symbol] = (
            b.state(f"copy.carry.{index}.rewind", Side.LEFT),
            b.state(f"copy.carry.{index}.find", Side.RIGHT),
            b.state(f"copy.carry.{index}.repeat_rewind", Side.LEFT),
        )
        output_carry[symbol] = (
            b.state(f"output.carry.{index}.rewind", Side.LEFT),
            b.state(f"output.carry.{index}.find", Side.RIGHT),
            b.state(f"output.carry.{index}.repeat_rewind", Side.LEFT),
        )
    sim = {
        state: b.state(f"machine.{index}", Side.RIGHT)
        for index, state in enumerate(machine.states)
    }
    left_states = {
        key: b.state(f"machine.left.{index}", Side.LEFT)
        for index, (key, transition) in enumerate(machine.transitions.items())
        if transition.move is Move.LEFT
    }
    output_rewind = b.state("output.halt_rewind", Side.LEFT)
    output_find = b.state("output.find_unread", Side.RIGHT)
    output_right = b.state("output.go_right", Side.RIGHT)

    source = "eq:compiler-validation"
    for state, base, cross, dest in (
        (I, W, True, I), (I, C, True, J),
        (JP, C, True, N), (N, W, True, N), (N, D, True, V),
    ):
        cell = clean(base)
        b.add(state, cell, cell, cross, dest, source)
    for symbol in machine.alphabet:
        cell = clean(symbol)
        b.add(J, cell, cell, True, J, source)
        b.add(JP, cell, cell, True, JP, source)
        b.add(V, cell, cell, True, V, source)
    b.boundary(J, JP, source)
    b.boundary(V, Q_START, source)
    b.boundary(Q_START, Q_REWIND, "fresh q_start handoff")
    b.rewind(Q_REWIND, anchor_find, "copy: initial rewind")

    b.find(
        anchor_find,
        lambda cell: cell.base in machine.alphabet and not cell.tag.anchor_read,
        lambda cell: (_retag(cell, anchor_read=True), copy_carry[cell.base][0]),
        "copy: find first unread anchor", end=blank_rewind,
    )
    for symbol, (rewind, find, repeat) in copy_carry.items():
        b.rewind(rewind, find, "copy: carry anchor to workspace, rewind")
        b.find(
            find, lambda cell: cell.base is W and not cell.tag.filled,
            lambda cell, a=symbol, dest=repeat: (_retag(cell, work=a, filled=True), dest),
            "copy: fill first unfilled workspace",
        )
        b.rewind(repeat, anchor_find, "copy: repeat anchor search, rewind")
    b.rewind(blank_rewind, blank_find, "copy: check spare workspace, rewind")
    b.find(
        blank_find, lambda cell: cell.base is W and not cell.tag.filled,
        lambda cell: (cell, first_rewind), "copy: require unfilled workspace",
    )
    b.rewind(first_rewind, first_find, "copy: locate first workspace, rewind")
    b.find(
        first_find, lambda cell: cell.base is W,
        lambda cell: (cell, sim[machine.start]), "copy: locate first workspace",
    )

    workspace = tuple(cell for cell in cells if cell.base is W)
    for state in machine.states:
        for cell in workspace:
            if state in machine.halts:
                b.add(sim[state], cell, cell, False, output_rewind, "machine: in-bounds halt")
                continue
            transition = machine.transitions.get((state, cell.tag.work))
            if transition is None:
                continue
            written = _retag(cell, work=transition.write)
            if transition.move is Move.LEFT:
                b.add(
                    sim[state], cell, written, False, left_states[(state, cell.tag.work)],
                    "machine: left write, stationary",
                )
            else:
                b.add(
                    sim[state], cell, written, transition.move is Move.RIGHT,
                    sim[transition.next_state], "machine: right/stationary",
                )
    for key, intermediate in left_states.items():
        dest = sim[machine.transitions[key].next_state]
        for cell in cells:
            if cell.base is W:
                b.add(intermediate, cell, cell, True, dest, "machine: cross left workspace")
            elif cell.base is C:
                b.add(intermediate, cell, cell, False, dest, "machine: stay at tape zero")

    b.rewind(output_rewind, output_find, "output: after halt, rewind")

    def output_match(cell):
        if cell.tag.work == machine.blank:
            return cell, output_right
        if cell.tag.work in machine.alphabet:
            return _retag(cell, output_read=True), output_carry[cell.tag.work][0]
        return None

    b.find(
        output_find, lambda cell: cell.base is W and not cell.tag.output_read,
        output_match, "output: first unread workspace; invalid symbol has no rule",
    )
    for symbol, (rewind, find, repeat) in output_carry.items():
        b.rewind(rewind, find, "output: carry symbol to anchor, rewind")
        b.find(
            find,
            lambda cell: cell.base in machine.alphabet and cell.tag.output_mark is None,
            lambda cell, a=symbol, dest=repeat: (_retag(cell, output_mark=a), dest),
            "output: mark first available anchor",
        )
        b.rewind(repeat, output_find, "output: repeat workspace search, rewind")
    b.go_right(output_right, Q_OK, "output: blank found, go to omega")
    for rule in b.rules.values():
        if rule.next_state not in b.states:
            raise ValueError(f"undefined continuation: {rule.next_state}")
    return b, sim


class ScanRuntime:
    def __init__(self, machine):
        if not isinstance(machine, TapeMachine):
            raise TypeError("compile a TapeMachine")
        self.machine = machine
        self.tags = tuple(
            Tag(*fields)
            for fields in product(
                (False, True), (False, True), machine.tape_alphabet,
                (False, True), (None,) + machine.alphabet,
            )
        )
        self.cells = tuple(
            Cell(base, tag) for base in (*machine.alphabet, C, D, W) for tag in self.tags
        )
        self._cell_set = frozenset(self.cells)
        builder, sim = _compile(machine, self.cells, self.clean)
        self.states = MappingProxyType(builder.states)
        self.machine_states = MappingProxyType(sim)
        self.rules = tuple(builder.rules.values())
        self._forward = MappingProxyType(builder.rules)
        inverse = defaultdict(list)
        for rule in self.rules:
            side = rule.side.opposite if rule.cross else rule.side
            inverse[(rule.next_state, side, rule.write)].append(rule)
        self._inverse = {key: tuple(value) for key, value in inverse.items()}

    def clean(self, base):
        cell = Cell(base, Tag(work=self.machine.blank))
        if cell not in self._cell_set:
            raise ValueError(f"base outside this runtime's alphabet: {base!r}")
        return cell

    def validate(self, sector, *, external=False):
        if not isinstance(sector, Sector):
            raise TypeError("expected a Sector")
        if sector.head not in self.states and not (external and sector.head in (Q, P, Z)):
            raise ValueError(f"unknown compiled head: {sector.head!r}")
        if any(cell not in self._cell_set for cell in sector.cells):
            raise ValueError("cell base, work symbol, or output mark outside compiled alphabet")

    def clean_entry(self, x, y, quota, *, alpha=True, omega=True):
        _bound(quota, "quota")
        x, y = tuple(x), tuple(y)
        if any(symbol not in self.machine.alphabet for symbol in x + y):
            raise ValueError("entry payload is not over the input alphabet")
        return Sector(
            alpha, tuple(self.clean(a) for a in x) + (self.clean(C),)
            + (self.clean(W),) * quota,
            I, (self.clean(D),) + tuple(self.clean(a) for a in y), omega,
        )

    def is_entry(self, sector):
        return sector.head == I and bool(sector.right) and sector.right[0] == self.clean(D)

    @staticmethod
    def is_success(sector):
        return sector.head == Q_OK and not sector.right and sector.omega

    def applicable_rule(self, sector):
        self.validate(sector)
        return self._forward.get((sector.head, _read(sector, self.states[sector.head])))

    def step(self, sector):
        rule = self.applicable_rule(sector)
        return None if rule is None else rule.apply(sector)

    def run(self, sector, *, max_steps, detect_cycles=True, record_trace=False):
        _bound(max_steps, "max_steps")
        self.validate(sector)
        trace = [sector] if record_trace else []
        seen = {sector} if detect_cycles else set()
        steps = 0
        while True:
            successor = self.step(sector)
            if successor is None:
                status = "ok" if self.is_success(sector) else "stuck"
                return RunResult(status, sector, steps, tuple(trace))
            if steps == max_steps:
                return RunResult("limit", sector, steps, tuple(trace))
            sector = successor
            steps += 1
            if record_trace:
                trace.append(sector)
            if detect_cycles and sector in seen:
                return RunResult("cycle", sector, steps, tuple(trace))
            if detect_cycles:
                seen.add(sector)

    def predecessors(self, sector):
        self.validate(sector)
        result = []
        seen = set()
        for side in Side:
            symbol = _read(sector, side)
            for rule in self._inverse.get((sector.head, side, symbol), ()):
                predecessor = rule.inverse(sector)
                if predecessor is not None and predecessor not in seen:
                    seen.add(predecessor)
                    result.append(predecessor)
        return tuple(result)

    def weak_component(self, sector, *, max_vertices, max_edges):
        _bound(max_vertices, "max_vertices", 1)
        _bound(max_edges, "max_edges")
        self.validate(sector)
        vertices, seen, queue = [sector], {sector}, deque([sector])
        edges, reason = 0, None
        while queue and reason is None:
            current = queue.popleft()
            forward = self.step(current)
            neighbors = (() if forward is None else (forward,)) + self.predecessors(current)
            for neighbor in neighbors:
                if edges == max_edges:
                    reason = "max_edges"
                    break
                edges += 1
                if neighbor not in seen:
                    if len(vertices) == max_vertices:
                        reason = "max_vertices"
                        break
                    seen.add(neighbor)
                    vertices.append(neighbor)
                    queue.append(neighbor)
        return ComponentResult(
            tuple(vertices), tuple(v for v in vertices if self.is_entry(v)),
            tuple(v for v in vertices if self.is_success(v)), edges,
            reason is None, reason,
        )

    def exit_step(self, sector):
        self.validate(sector)
        return replace(sector, head=Z) if self.is_success(sector) else None

    def cleanup_step(self, sector):
        self.validate(sector, external=True)
        if sector.head != Z:
            raise ValueError("cleanup_step requires head Z")
        if sector.left:
            cell = sector.left[-1]
            emitted = ()
            if cell.base in self.machine.alphabet and cell.tag.output_mark is not None:
                emitted = (self.clean(cell.tag.output_mark),)
            return replace(sector, left=sector.left[:-1], right=emitted + sector.right)
        return replace(sector, head=Q) if sector.alpha else None

    def marked_output(self, sector):
        self.validate(sector, external=True)
        return tuple(
            cell.tag.output_mark for cell in sector.cells
            if cell.base in self.machine.alphabet and cell.tag.output_mark is not None
        )

    def raw_payload(self, sector):
        self.validate(sector, external=True)
        if not sector.alpha or not sector.omega or sector.head != Q or sector.left:
            return None
        if any(
            cell.base not in self.machine.alphabet or cell != self.clean(cell.base)
            for cell in sector.right
        ):
            return None
        return tuple(cell.base for cell in sector.right)


def compile_machine(machine):
    return ScanRuntime(machine)
