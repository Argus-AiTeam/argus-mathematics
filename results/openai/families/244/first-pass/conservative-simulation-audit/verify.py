#!/usr/bin/env python3
"""Replay exact infinite-base examples and the claim-bound formal evidence."""

from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
from functools import cache
from itertools import product
import json
from pathlib import Path
import subprocess
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "term_rewriting.critical_pairs.compute"


@dataclass(frozen=True, order=True)
class Ordinal:
    high: int
    middle: int
    low: int

    def __post_init__(self) -> None:
        assert min(self.high, self.middle, self.low) >= 0


@dataclass(frozen=True)
class Base:
    ordinal: Ordinal
    word: tuple[int, ...] = ()


ONE = Base(Ordinal(0, 0, 0))
D = Base(Ordinal(0, 1, 0))
A = Base(Ordinal(1, 0, 0))
B = Base(Ordinal(1, 0, 0), (0,))
E = Base(Ordinal(0, 1, 0), (1,))


def small(x: Base) -> bool:
    return x.ordinal.low == 0 and all(c in (0, 1) for c in x.word)


def ordinal_mul(x: Ordinal, y: Ordinal) -> Ordinal:
    if y.high:
        return Ordinal(x.high + y.high, y.middle, y.low)
    if y.middle:
        return Ordinal(x.high, x.middle + y.middle, y.low)
    return Ordinal(x.high, x.middle, x.low + y.low)


def mul(x: Base, y: Base) -> Base:
    return Base(ordinal_mul(x.ordinal, y.ordinal), x.word + y.word)


def prefix_quotient(x: tuple[int, ...], y: tuple[int, ...]) -> tuple[int, ...] | None:
    return y[len(x):] if y[:len(x)] == x else None


def divide(x: Base, y: Base) -> Base | None:
    suffix = prefix_quotient(x.word, y.word)
    if suffix is None or y.ordinal < x.ordinal:
        return None
    a, b = x.ordinal, y.ordinal
    if b.high > a.high:
        q = Ordinal(b.high - a.high, b.middle, b.low)
    elif b.middle > a.middle:
        q = Ordinal(0, b.middle - a.middle, b.low)
    else:
        q = Ordinal(0, 0, b.low - a.low)
    return Base(q, suffix)


def join(x: Base, y: Base) -> Base | None:
    if prefix_quotient(x.word, y.word) is not None:
        word = y.word
    elif prefix_quotient(y.word, x.word) is not None:
        word = x.word
    else:
        return None
    return Base(max(x.ordinal, y.ordinal), word)


@dataclass(frozen=True)
class Letter:
    high: int
    drift: int
    word: tuple[int, ...] = ()

    def __post_init__(self) -> None:
        assert self.high >= 0


def letter_small(s: Letter) -> bool:
    return all(c in (0, 1) for c in s.word)


def letter_class(x: Base, i: int) -> Letter:
    return Letter(x.ordinal.high, x.ordinal.middle - i, x.word)


def act_letter(a: Base, s: Letter) -> Letter:
    return Letter(
        a.ordinal.high + s.high,
        s.drift if s.high else a.ordinal.middle + s.drift,
        a.word + s.word,
    )


def divide_letter(a: Base, s: Letter) -> Letter | None:
    suffix = prefix_quotient(a.word, s.word)
    if suffix is None or s.high < a.ordinal.high:
        return None
    high = s.high - a.ordinal.high
    return Letter(high, s.drift if high else s.drift - a.ordinal.middle, suffix)


def h(s: Letter) -> Base:
    return Base(Ordinal(s.high + 1, 1, 0), s.word + E.word)


@dataclass(frozen=True)
class ProbeWord:
    heads: tuple[Letter, ...]
    tail: Base


def old(x: Base) -> ProbeWord:
    return ProbeWord((), x)


def probe_small(x: ProbeWord) -> bool:
    return small(x.tail) and all(letter_small(s) for s in x.heads)


def probe_normal(x: ProbeWord) -> bool:
    return not x.heads or (
        all(divide_letter(B, s) is None for s in x.heads[1:])
        and divide(B, x.tail) is None
    )


def act(a: Base, x: ProbeWord) -> ProbeWord:
    if x.heads:
        return ProbeWord((act_letter(a, x.heads[0]),) + x.heads[1:], x.tail)
    return old(mul(a, x.tail))


def b_quotient(x: ProbeWord) -> ProbeWord | None:
    if x.heads:
        s = divide_letter(B, x.heads[0])
        return None if s is None else ProbeWord((s,) + x.heads[1:], x.tail)
    q = divide(B, x.tail)
    return None if q is None else old(q)


def push(s: Letter, x: ProbeWord) -> ProbeWord:
    q = b_quotient(x)
    return ProbeWord((s,) + x.heads, x.tail) if q is None else act(h(s), q)


def probe_mul(x: ProbeWord, y: ProbeWord) -> ProbeWord:
    z = act(x.tail, y)
    for s in reversed(x.heads):
        z = push(s, z)
    return z


@cache
def gate(x: ProbeWord) -> tuple[Base, Base] | None:
    assert x.heads
    suffix = ProbeWord(x.heads[1:], x.tail)
    if suffix.heads:
        previous = gate(suffix)
        if previous is None:
            return None
        root, factor = previous
    else:
        root, factor = suffix.tail, ONE
    z = join(root, B)
    if z is None:
        return None
    u, v = divide(B, z), divide(root, z)
    assert u is not None and v is not None
    return mul(h(x.heads[0]), u), mul(factor, v)


def probe_divide(x: ProbeWord, y: ProbeWord) -> ProbeWord | None:
    if not x.heads:
        if not y.heads:
            q = divide(x.tail, y.tail)
            return None if q is None else old(q)
        s = divide_letter(x.tail, y.heads[0])
        return None if s is None else ProbeWord((s,) + y.heads[1:], y.tail)
    if y.heads and x.heads[0] == y.heads[0]:
        return probe_divide(
            ProbeWord(x.heads[1:], x.tail), ProbeWord(y.heads[1:], y.tail)
        )
    g = gate(x)
    if g is None:
        return None
    root, factor = g
    q = probe_divide(old(root), y)
    return None if q is None else act(factor, q)


def probe_join(x: ProbeWord, y: ProbeWord) -> ProbeWord | None:
    if not x.heads and not y.heads:
        z = join(x.tail, y.tail)
        return None if z is None else old(z)
    if not y.heads:
        return probe_join(y, x)
    if not x.heads:
        if divide_letter(x.tail, y.heads[0]) is not None:
            return y
        g = gate(y)
        z = None if g is None else join(x.tail, g[0])
        return None if z is None else old(z)
    if x.heads[0] == y.heads[0]:
        z = probe_join(
            ProbeWord(x.heads[1:], x.tail), ProbeWord(y.heads[1:], y.tail)
        )
        return None if z is None else push(x.heads[0], z)
    gx, gy = gate(x), gate(y)
    if gy is not None and divide_letter(gy[0], x.heads[0]) is not None:
        return x
    if gx is not None and divide_letter(gx[0], y.heads[0]) is not None:
        return y
    z = None if gx is None or gy is None else join(gx[0], gy[0])
    return None if z is None else old(z)


STARTS = (Base(Ordinal(0, 1, 0), (0,)), B, Base(Ordinal(0, 0, 0), (0, 1)))


@dataclass(frozen=True)
class MergerLetter:
    copy: int
    value: Base


def merger_letter(i: int, x: Base) -> MergerLetter:
    q = divide(STARTS[i], x)
    return MergerLetter(i, x) if q is None else MergerLetter(-1, q)


def represent(z: MergerLetter) -> tuple[int, Base]:
    return (0, mul(STARTS[0], z.value)) if z.copy == -1 else (z.copy, z.value)


def merger_act(z: MergerLetter, a: Base) -> MergerLetter:
    if z.copy == -1:
        return MergerLetter(-1, mul(z.value, a))
    return merger_letter(z.copy, mul(z.value, a))


def merger_letter_divide(z: MergerLetter, w: MergerLetter) -> Base | None:
    i, x = represent(z)
    j, y = represent(w)
    if i == j:
        return divide(x, y)
    coordinate = divide(STARTS[j], y)
    return None if coordinate is None else divide(x, mul(STARTS[i], coordinate))


def merger_letter_join(z: MergerLetter, w: MergerLetter) -> MergerLetter | None:
    i, x = represent(z)
    j, y = represent(w)
    if i == j:
        q = join(x, y)
        return None if q is None else merger_letter(i, q)
    jx, jy = join(x, STARTS[i]), join(y, STARTS[j])
    if jx is None or jy is None:
        return None
    u, v = divide(STARTS[i], jx), divide(STARTS[j], jy)
    assert u is not None and v is not None
    k = join(u, v)
    return None if k is None else MergerLetter(-1, k)


@dataclass(frozen=True)
class MergerWord:
    head: Base
    letters: tuple[MergerLetter, ...] = ()


def merger_small(x: MergerWord) -> bool:
    return small(x.head) and all(small(z.value) for z in x.letters)


def merger_mul(x: MergerWord, y: MergerWord) -> MergerWord:
    if not x.letters:
        return MergerWord(mul(x.head, y.head), y.letters)
    return MergerWord(
        x.head, x.letters[:-1] + (merger_act(x.letters[-1], y.head),) + y.letters
    )


def merger_divide(x: MergerWord, y: MergerWord) -> MergerWord | None:
    if not x.letters:
        q = divide(x.head, y.head)
        return None if q is None else MergerWord(q, y.letters)
    p = len(x.letters)
    if (
        len(y.letters) < p or x.head != y.head
        or x.letters[:-1] != y.letters[:p - 1]
    ):
        return None
    q = merger_letter_divide(x.letters[-1], y.letters[p - 1])
    return None if q is None else MergerWord(q, y.letters[p:])


def merger_join(x: MergerWord, y: MergerWord) -> MergerWord | None:
    if not x.letters and not y.letters:
        q = join(x.head, y.head)
        return None if q is None else MergerWord(q)
    if not y.letters:
        return merger_join(y, x)
    if not x.letters:
        return y if divide(x.head, y.head) is not None else None
    p, q = len(x.letters), len(y.letters)
    if x.head != y.head or x.letters[:min(p, q) - 1] != y.letters[:min(p, q) - 1]:
        return None
    if p == q:
        z = merger_letter_join(x.letters[-1], y.letters[-1])
        return None if z is None else MergerWord(x.head, x.letters[:-1] + (z,))
    if p > q:
        return merger_join(y, x)
    return y if merger_letter_divide(x.letters[-1], y.letters[p - 1]) is not None else None


Prescription = dict[tuple[int, int], tuple[Base, Base]]


def prescription(entries: tuple[tuple[Base, Base] | None, ...]) -> Prescription:
    result: Prescription = {}
    for (i, j), entry in zip(((0, 1), (0, 2), (1, 2)), entries, strict=True):
        if entry is not None:
            result[i, j] = entry
            result[j, i] = entry[1], entry[0]
    return result


def directly_related(table: Prescription, i: int, x: Base, j: int, y: Base) -> bool:
    if i == j:
        return x == y
    edge = table.get((i, j))
    if edge is None:
        return False
    a, b = edge
    q, r = divide(a, x), divide(b, y)
    return q is not None and q == r


def exact_validity(table: Prescription) -> tuple[bool, dict | None]:
    for i, j, k in product(range(3), repeat=3):
        if (i, j) not in table or (j, k) not in table:
            continue
        a, b = table[i, j]
        c, d = table[j, k]
        middle = join(b, c)
        if middle is None:
            continue
        u, v = divide(b, middle), divide(c, middle)
        assert u is not None and v is not None
        x, y = mul(a, u), mul(d, v)
        if not directly_related(table, i, x, k, y):
            return False, {
                "copies": [i, j, k], "middle_join": asdict(middle),
                "left_endpoint": asdict(x), "right_endpoint": asdict(y),
            }
    return True, None


def unique(values: list) -> list:
    return list(dict.fromkeys(values))


def base_samples() -> tuple[list[Base], list[Base]]:
    smaller = [
        ONE, D, A, B, E, Base(Ordinal(0, 0, 0), (0,)),
        Base(Ordinal(0, 0, 0), (1,)), Base(Ordinal(0, 2, 0)),
        Base(Ordinal(1, 1, 0), (0, 1)), Base(Ordinal(2, 0, 0)),
    ]
    outside = [
        Base(Ordinal(0, 0, 1)), Base(Ordinal(0, 1, 2)),
        Base(Ordinal(1, 0, 1)), Base(Ordinal(0, 0, 0), (2,)),
        Base(Ordinal(1, 0, 0), (0, 2)), Base(Ordinal(0, 0, 1), (2,)),
    ]
    return smaller, outside


def check_base() -> dict:
    smaller, outside = base_samples()
    ambient = smaller + outside
    low = outside[0]
    assert low != ONE and mul(low, D) == mul(ONE, D)
    assert not small(low) and letter_class(low, 0) == letter_class(ONE, 0)
    assert join(Base(Ordinal(0, 0, 0), (0,)), Base(Ordinal(0, 0, 0), (1,))) is None
    for i in range(8):
        n = Base(Ordinal(0, i, 0))
        assert mul(n, D) == Base(Ordinal(0, i + 1, 0))
        assert mul(n, A) == A
    for x, y, z in product(ambient, repeat=3):
        assert mul(mul(x, y), z) == mul(x, mul(y, z))
        q = divide(x, y)
        assert q is None or mul(x, q) == y
        g = join(x, y)
        common = divide(x, z) is not None and divide(y, z) is not None
        assert common == (g is not None and divide(g, z) is not None)
    for x, y in product(smaller, repeat=2):
        q = divide(x, y)
        assert q is None or small(q)
    return {
        "model": "(ordinals below omega^3 under addition) times a free monoid",
        "smaller_base": "zero finite ordinal coefficient and alphabet {0,1}",
        "larger_base": "all three ordinal coefficients and alphabet {0,1,2}",
        "infinite_non_right_cancellative": True,
        "noninjective_transition": {
            "distinct_left_inputs": [asdict(low), asdict(ONE)],
            "same_right_factor": asdict(D), "same_product": asdict(D),
        },
        "representative_outside_B_but_class_inside_SB": {
            "representative": asdict(low), "stage": 0,
            "same_class_as": asdict(ONE), "class": asdict(letter_class(low, 0)),
        },
        "base_associativity_triples": len(ambient) ** 3,
    }


def check_probe() -> dict:
    bases, outside = base_samples()
    letters = [
        Letter(0, 0), Letter(0, -2), Letter(1, -1), Letter(0, 2, (0,)),
        Letter(1, 0, (0,)), Letter(1, 1, (1,)), Letter(0, 0, (0, 1)),
    ]
    small_words = unique(
        [old(x) for x in bases]
        + [push(s, old(ONE)) for s in letters]
        + [push(s, old(x)) for s, x in product(letters[:4], bases[3:7])]
        + [push(s, push(t, old(ONE))) for s, t in product(letters[:3], repeat=2)]
    )
    extra_letters = [Letter(0, -1, (2,)), Letter(1, 1, (0, 2))]
    extra = (
        [old(x) for x in outside]
        + [push(s, old(x)) for s, x in product(extra_letters, (ONE, B))]
        + [push(s, old(x)) for s, x in product(letters[:2], outside[:2])]
    )
    ambient = unique(small_words + extra)
    assert all(probe_normal(x) for x in ambient)
    assert all(probe_small(x) for x in small_words)
    for i in range(5):
        pi = push(Letter(0, -i), old(ONE))
        pn = push(Letter(0, -i - 1), old(ONE))
        assert pi == probe_mul(old(D), pn)
        assert probe_mul(pi, old(B)) == old(mul(A, E))
    for a, s in product(bases, letters):
        q = divide_letter(a, s)
        assert q is None or letter_small(q) and act_letter(a, q) == s
    triples = ambient[:10] + extra[:4]
    for x, y, z in product(triples, repeat=3):
        assert probe_mul(probe_mul(x, y), z) == probe_mul(x, probe_mul(y, z))
    gate_count = no_gate_count = 0
    for x in small_words:
        if not x.heads:
            continue
        g = gate(x)
        if g is None:
            no_gate_count += 1
        else:
            gate_count += 1
            root, factor = g
            assert small(root) and small(factor)
            assert probe_mul(x, old(factor)) == old(root)
    assert gate_count > 0 and no_gate_count > 0
    join_count = no_join_count = quotient_count = common_tests = 0
    for x, y in product(small_words, repeat=2):
        q = probe_divide(x, y)
        if q is not None:
            quotient_count += 1
            assert probe_small(q) and probe_normal(q)
            assert probe_mul(x, q) == y
        g = probe_join(x, y)
        if g is None:
            no_join_count += 1
        else:
            join_count += 1
            assert probe_small(g) and probe_normal(g)
            assert probe_divide(x, g) is not None and probe_divide(y, g) is not None
        for z in ambient:
            common = probe_divide(x, z) is not None and probe_divide(y, z) is not None
            assert common == (g is not None and probe_divide(g, z) is not None)
            common_tests += 1
    for x, q in product(small_words, ambient):
        y = probe_mul(x, q)
        assert probe_normal(y)
        assert not probe_small(y) or probe_small(q)
        assert probe_divide(x, y) == q
    return {
        "small_normal_forms": len(small_words), "ambient_normal_forms": len(ambient),
        "gates": gate_count, "missing_gates": no_gate_count,
        "small_right_quotients": quotient_count, "join_pairs": join_count,
        "nonjoin_pairs": no_join_count, "larger_common_multiple_tests": common_tests,
        "factor_closure_product_tests": len(small_words) * len(ambient),
        "associativity_triples": len(triples) ** 3,
    }


def check_merger() -> dict:
    bases, outside = base_samples()
    small_letters = unique([merger_letter(i, x) for i in range(3) for x in bases[:7]])
    large_letters = unique(
        small_letters + [merger_letter(i, x) for i in range(3) for x in outside]
    )
    smaller = unique(
        [MergerWord(x) for x in bases[:7]]
        + [MergerWord(ONE, (z,)) for z in small_letters[:9]]
        + [MergerWord(D, (z, w)) for z, w in product(small_letters[:3], repeat=2)]
    )
    extra = (
        [MergerWord(x) for x in outside]
        + [MergerWord(ONE, (z,)) for z in large_letters if not small(z.value)]
    )
    ambient = unique(smaller + extra)
    assert all(merger_small(x) for x in smaller)
    valid_table = prescription(
        tuple((STARTS[i], STARTS[j]) for i, j in ((0, 1), (0, 2), (1, 2)))
    )
    assert exact_validity(valid_table)[0]
    for i, j, x in product(range(3), range(3), bases + outside):
        assert merger_letter(i, mul(STARTS[i], x)) == merger_letter(j, mul(STARTS[j], x))
    for z, a, b in product(large_letters, bases + outside, bases[:4]):
        assert merger_act(merger_act(z, a), b) == merger_act(z, mul(a, b))
    for z, w in product(small_letters, repeat=2):
        q = merger_letter_divide(z, w)
        assert q is None or small(q) and merger_act(z, q) == w
        g = merger_letter_join(z, w)
        for t in large_letters:
            common = (
                merger_letter_divide(z, t) is not None
                and merger_letter_divide(w, t) is not None
            )
            assert common == (g is not None and merger_letter_divide(g, t) is not None)
    triples = smaller[:8] + smaller[8:12] + extra[:2]
    for x, y, z in product(triples, repeat=3):
        assert merger_mul(merger_mul(x, y), z) == merger_mul(x, merger_mul(y, z))
    joins = nonjoins = quotients = common_tests = 0
    for x, y in product(smaller, repeat=2):
        q = merger_divide(x, y)
        if q is not None:
            quotients += 1
            assert merger_small(q) and merger_mul(x, q) == y
        g = merger_join(x, y)
        if g is None:
            nonjoins += 1
        else:
            joins += 1
            assert merger_small(g)
            assert merger_divide(x, g) is not None and merger_divide(y, g) is not None
        for z in ambient:
            common = merger_divide(x, z) is not None and merger_divide(y, z) is not None
            assert common == (g is not None and merger_divide(g, z) is not None)
            common_tests += 1
    for x, q in product(smaller, ambient):
        y = merger_mul(x, q)
        assert not merger_small(y) or merger_small(q)
        assert merger_divide(x, y) == q
    assert joins and nonjoins and quotients
    return {
        "small_letters": len(small_letters), "ambient_letters": len(large_letters),
        "small_normal_forms": len(smaller), "ambient_normal_forms": len(ambient),
        "small_right_quotients": quotients, "join_pairs": joins,
        "nonjoin_pairs": nonjoins, "larger_common_multiple_tests": common_tests,
        "factor_closure_product_tests": len(smaller) * len(ambient),
        "associativity_triples": len(triples) ** 3,
    }


def check_validity() -> dict:
    options = (None, (ONE, ONE), (D, D), (B, E), (E, B))
    valid = invalid = 0
    first_invalid = None
    for entries in product(options, repeat=3):
        table = prescription(entries)
        ok, witness = exact_validity(table)
        if ok:
            valid += 1
        else:
            invalid += 1
            if first_invalid is None:
                first_invalid = witness
        assert all(small(x) and small(y) for x, y in table.values())
    assert valid > 0 and invalid > 0
    return {
        "prescriptions": len(options) ** 3, "valid": valid, "invalid": invalid,
        "method": "Complete three-copy join-root criterion on infinite bases, not point exhaustion.",
        "invalid_test_data_witness": first_invalid,
        "scope": "These intentionally invalid data do not refute any manuscript assertion.",
    }


def term(t: dict) -> tuple:
    return bool(t.get("is_variable", False)), t["symbol"], tuple(
        term(c) for c in t.get("children", ())
    )


def normal_term(t: tuple) -> tuple:
    variable, symbol, children = t
    if variable:
        return t
    children = tuple(normal_term(c) for c in children)
    if symbol in (0, 1) and len(children) == 2:
        left, right = children
        if not left[0] and left[1] == symbol:
            a, b = left[2]
            return normal_term((False, symbol, (a, (False, 0, (b, right)))))
    return variable, symbol, children


def check_jacobian() -> dict:
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    assert status["exit_code"] == 0 and status["timeout"] is False
    assert not status["stderr"] and response["result"]["operation_id"] == OPERATION
    output = response["result"]["output"]
    assert output["signature"] == payload["signature"]
    assert [(term(r["lhs"]), term(r["rhs"])) for r in output["rules"]] == [
        (term(r["lhs"]), term(r["rhs"])) for r in payload["rules"]
    ]
    profile = output["profile"]
    assert len(profile["candidates"]) == 6 and len(profile["pairs"]) == 2
    assert sum(c["unifiable"] for c in profile["candidates"]) == 2
    for pair in profile["pairs"]:
        assert normal_term(term(pair["inner_reduct"])) == normal_term(term(pair["outer_reduct"]))
    return {
        "operation_id": OPERATION, "server": response["server"],
        "protocol_version": response["protocol_version"], "adapter_exit_code": 0,
        "timeout": False, "candidate_positions": 6, "critical_pairs": 2,
        "both_pairs_joined": True,
        "scope": "Finite first-order associativity/right-action overlaps only.",
    }


def current_claim(state: dict, claim_id: str) -> dict:
    return max(
        (c for c in state["claims"] if c["claim_id"] == claim_id),
        key=lambda c: c["version"],
    )


def bound_certificate(state: dict, claim_id: str, source: Path, fidelity: Path) -> tuple[str, dict]:
    claim = current_claim(state, claim_id)
    evidence = next(
        e for e in reversed(state["evidence"])
        if e["subject"]["subject_id"] == claim_id
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    )
    path = evidence["artifact"]
    certificate = json.loads((ROOT / path).read_text())
    assert certificate["lean_source"]["text"] == source.read_text()
    assert claim["formal_statement"] == source.read_text()
    assert certificate["statement_fidelity"]["text"] == fidelity.read_text()
    check = certificate["lean_check"]
    assert check["status"] == "success" and check["exit_code"] == 0
    assert check["audit_exit_code"] == 0 and check["proof_holes"] == []
    assert "version 4.31.0" in check["tools"]["lean"]["version"]
    return path, check


def check_formal_evidence() -> dict:
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    local, check = bound_certificate(
        state, "C_SIM_SUPPORT_KERNEL", HERE / "Main.lean", HERE / "statement_fidelity.md"
    )
    accepted = ROOT / "research/probe-extension-audit"
    old_path, _ = bound_certificate(
        state, "C_PROBE_CORE", accepted / "Main.lean", accepted / "statement_fidelity.md"
    )
    core = current_claim(state, "C_PROBE_CORE")
    assert core["version"] == 2
    reviewers = [
        e["produced_by"] for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_PROBE_CORE"
        and e["subject"]["content_hash"] == core["content_hash"]
        and e["verdict"] == "supports" and e["produced_by"].startswith("reviewer:")
    ]
    assert "reviewer:copilot-74aa4471aa14" in reviewers
    return {
        "claim": "C_SIM_SUPPORT_KERNEL", "certificate": local,
        "lean_version": "4.31.0", "compiler_exit_code": check["exit_code"],
        "axiom_audit_exit_code": check["audit_exit_code"], "proof_holes": [],
        "coverage": [
            "universal overlap validity iff and exact restriction",
            "universal merger-letter old right-factor closure",
            "actual probe direct-limit embedding and old-left-division support lifting",
        ],
        "not_encoded": [
            "probe paired-gate and arbitrary-word intersection induction",
            "merger-word monoid and all word-cone calculations",
        ],
        "unchanged_accepted_dependency": {
            "claim": "C_PROBE_CORE", "version": 2, "certificate": old_path,
            "reviewer_support": reviewers, "recompiled": False,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--formal", action="store_true", help="Run a fresh official Lean check.")
    args = parser.parse_args()
    started = time.monotonic()
    if args.formal:
        subprocess.run(
            [PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
             str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
             "--claim", "C_SIM_SUPPORT_KERNEL", "--project-root", str(ROOT),
             "--artifact-dir", str(HERE / "certificates"), "--timeout", "100"],
            check=True,
        )
        for module in ("math_state", "proof_graph_check"):
            subprocess.run(
                [PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
                 "--project-root", str(ROOT)], check=True,
            )
    result = {
        "claim": "C_MONOID_SIMULATION",
        "result_class": "universal_verification_theorem",
        "universal_proof": "research/conservative-simulation-audit/report.md",
        "mathematical_scope": "Both actual presentations, all right factors, joins and nonjoins, and two-way finite-overlap validity.",
        "formal": check_formal_evidence(),
        "infinite_base": check_base(), "probe": check_probe(),
        "merger": check_merger(), "validity": check_validity(),
        "jacobian": check_jacobian(),
        "false_manuscript_assertions_established": [],
        "independent_review_required": True, "independent_review_complete": False,
        "novelty_status": "unverified", "significance_status": "unverified",
        "campaign_complete": False,
    }
    result["replay_seconds"] = round(time.monotonic() - started, 3)
    (HERE / "exact_certificate.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "status": "passed", "certificate": str(HERE / "exact_certificate.json"),
        "probe": result["probe"], "merger": result["merger"],
        "validity_counts": {k: result["validity"][k] for k in ("prescriptions", "valid", "invalid")},
        "replay_seconds": result["replay_seconds"],
        "independent_review": "required; full simulation proof is not wholly encoded in Lean",
    }, indent=2))


if __name__ == "__main__":
    main()
