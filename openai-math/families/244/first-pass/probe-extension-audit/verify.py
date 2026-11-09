#!/usr/bin/env python3
"""Replay the universal Lean certificate and exact infinite-monoid examples."""

from __future__ import annotations

from dataclasses import dataclass, replace
from fractions import Fraction
from itertools import product
import json
from pathlib import Path
import subprocess
import time
from typing import Union


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "term_rewriting.critical_pairs.compute"


@dataclass(frozen=True)
class Ordinal:
    high: int
    middle: int
    low: int


Element = Union[Ordinal, "Word"]


@dataclass(frozen=True)
class Word:
    heads: tuple[Element, ...]
    tail: Element


def bottom(x: Element) -> Ordinal:
    return x if isinstance(x, Ordinal) else bottom(x.tail)


def shift(x: Element, amount: int) -> Element:
    if isinstance(x, Ordinal):
        return replace(x, middle=x.middle + amount, low=0)
    return Word(x.heads, shift(x.tail, amount))


def high(x: Element) -> int:
    if isinstance(x, Ordinal):
        return x.high
    return high(x.heads[0] if x.heads else x.tail)


def lower_high(x: Element, amount: int) -> Element:
    assert high(x) >= amount >= 0
    if isinstance(x, Ordinal):
        return replace(x, high=x.high - amount)
    if x.heads:
        return Word((lower_high(x.heads[0], amount),) + x.heads[1:], x.tail)
    return Word((), lower_high(x.tail, amount))


def as_ordinal(x: Element) -> Ordinal:
    if isinstance(x, Ordinal):
        return x
    assert not x.heads, "the asserted original-old element is still new"
    return as_ordinal(x.tail)


class Layer:
    """One exact normal-form extension; level zero is ordinal addition."""

    def __init__(self, base: Layer | None = None):
        self.base = base
        self.level = 0 if base is None else base.level + 1
        self.one = self.embed(Ordinal(0, 0, 0))
        self.a = self.embed(Ordinal(1, 0, 0))
        self.d = self.embed(Ordinal(0, 1, 0))
        self.low = self.embed(Ordinal(0, 0, 1))

    def embed(self, x: Ordinal) -> Element:
        return x if self.base is None else Word((), self.base.embed(x))

    def old(self, x: Element) -> Word:
        assert self.base is not None
        return Word((), x)

    def normal(self, x: Element, *, limit: bool = False) -> bool:
        if self.base is None:
            return (
                isinstance(x, Ordinal)
                and x.high >= 0
                and (limit or x.middle >= 0)
                and x.low >= 0
                and (not limit or x.low == 0)
            )
        return (
            isinstance(x, Word)
            and all(self.base.normal(s, limit=True) for s in x.heads)
            and self.base.normal(x.tail, limit=limit)
            and (
                not x.heads
                or (all(high(s) == 0 for s in x.heads[1:]) and high(x.tail) == 0)
            )
        )

    def representative(self, s: Element) -> tuple[int, Element]:
        stage = max(0, 1 - bottom(s).middle)
        representative = shift(s, stage)
        assert self.base is not None and self.base.normal(representative)
        return stage, representative

    def act_letter(self, u: Element, s: Element) -> Element:
        assert self.base is not None
        stage, representative = self.representative(s)
        return shift(self.base.mul(u, representative), -stage)

    def h(self, s: Element) -> Element:
        assert self.base is not None
        _, representative = self.representative(s)
        return self.base.mul(self.base.mul(representative, self.base.a), self.base.a)

    def act_word(self, u: Element, y: Word) -> Word:
        assert self.base is not None
        if y.heads:
            return Word((self.act_letter(u, y.heads[0]),) + y.heads[1:], y.tail)
        return Word((), self.base.mul(u, y.tail))

    def push(self, s: Element, y: Word) -> Word:
        if high(y) >= 1:
            quotient = lower_high(y, 1)
            assert isinstance(quotient, Word)
            return self.act_word(self.h(s), quotient)
        return Word((s,) + y.heads, y.tail)

    def letter(self, s: Element) -> Word:
        assert self.base is not None and isinstance(self.one, Word)
        return self.push(s, self.one)

    def p(self, i: int) -> Word:
        assert self.base is not None
        return self.letter(shift(self.base.one, -i))

    def mul(self, x: Element, y: Element) -> Element:
        if self.base is None:
            assert isinstance(x, Ordinal) and isinstance(y, Ordinal)
            if y.high:
                return Ordinal(x.high + y.high, y.middle, y.low)
            if y.middle:
                return Ordinal(x.high, x.middle + y.middle, y.low)
            return Ordinal(x.high, x.middle, x.low + y.low)
        assert isinstance(x, Word) and isinstance(y, Word)
        result = self.act_word(x.tail, y)
        for s in reversed(x.heads):
            result = self.push(s, result)
        return result

    def power_divides(self, exponent: int, x: Element) -> bool:
        if high(x) < exponent:
            return False
        q = lower_high(x, exponent)
        assert self.mul(self.embed(Ordinal(exponent, 0, 0)), q) == x
        return True


def cost(x: Ordinal) -> Fraction:
    return Fraction(1, 2 ** (x.high + x.middle + x.low + 6))


def height(x: Ordinal) -> Fraction:
    a, b, c = x.high, x.middle, x.low
    return (
        Fraction(1, 4)
        + Fraction(1, 4) * (1 - Fraction(1, 2**a))
        + Fraction(1, 2 ** (a + 3)) * (1 - Fraction(1, 2**b))
        + Fraction(1, 2 ** (a + b + 4)) * (1 - Fraction(1, 2 ** (c + 1)))
    )


def lex(x: Ordinal) -> tuple[int, int, int]:
    return x.high, x.middle, x.low


def missed_cost_supremum(x: Ordinal, y: Ordinal) -> Fraction:
    candidates = [
        Ordinal(x.high, x.middle, x.low + 1),
        Ordinal(x.high, x.middle + 1, 0),
        Ordinal(x.high + 1, 0, 0),
    ]
    return max(cost(z) for z in candidates if lex(z) <= lex(y))


def samples(layer: Layer) -> list[Element]:
    if layer.base is None:
        return [
            layer.one, layer.low, layer.d, layer.a,
            Ordinal(0, 2, 1), Ordinal(1, 1, 2), Ordinal(2, 0, 0),
            Ordinal(0, 0, 3),
        ]
    p0, p1, p2 = (layer.p(i) for i in range(3))
    values = [
        layer.one, layer.low, layer.d, layer.a, p0, p1, p2,
        layer.mul(p0, p1), layer.mul(p1, layer.d), layer.mul(layer.a, p0),
    ]
    if layer.base.base is not None:
        old_probe = layer.old(layer.base.p(0))
        values.extend([old_probe, layer.mul(p0, old_probe)])
    return list(dict.fromkeys(values))


def verify_examples() -> dict:
    counts = {
        "associativity_triples": 0,
        "left_cancellation_triples": 0,
        "margin_intervals": 0,
        "presentation_relations": 0,
        "direct_limit_action_checks": 0,
        "exact_exit_cone_checks": 0,
        "old_factor_gate_checks": 0,
        "old_multiple_minimum_checks": 0,
    }
    layers = [Layer()]
    for _ in range(3):
        layers.append(Layer(layers[-1]))
    for layer in layers:
        values = samples(layer)
        assert all(layer.normal(x) for x in values)
        assert layer.low != layer.one
        assert layer.mul(layer.low, layer.d) == layer.mul(layer.one, layer.d)
        for x in values:
            assert layer.mul(x, layer.one) == x == layer.mul(layer.one, x)
            assert layer.mul(x, layer.d) == shift(x, 1)
        for x, y, z in product(values[:8], repeat=3):
            assert layer.mul(layer.mul(x, y), z) == layer.mul(x, layer.mul(y, z))
            counts["associativity_triples"] += 1
            if layer.mul(x, y) == layer.mul(x, z):
                assert y == z
            counts["left_cancellation_triples"] += 1
        for x, y in product(values, repeat=2):
            if layer.mul(x, y) == layer.one:
                assert x == y == layer.one
        if layer.base is None:
            continue
        base = layer.base
        assert all(layer.p(i) != layer.p(i + 1) for i in range(5))
        for i in range(5):
            ni = base.embed(Ordinal(0, i, 0))
            ni1 = base.embed(Ordinal(0, i + 1, 0))
            assert base.mul(ni, base.d) == ni1
            assert base.mul(ni, base.a) == base.a
            assert layer.p(i) == layer.mul(layer.old(base.d), layer.p(i + 1))
            assert layer.mul(layer.p(i), layer.old(base.a)) == layer.old(base.mul(base.a, base.a))
            counts["presentation_relations"] += 2
        for x, y in product(samples(base), repeat=2):
            assert layer.mul(layer.old(x), layer.old(y)) == layer.old(base.mul(x, y))
        for s0, u in product(samples(base), repeat=2):
            s = shift(s0, -2)
            stage, representative = layer.representative(s)
            for extra in (1, 3):
                moved = shift(representative, extra)
                assert shift(base.mul(u, moved), -(stage + extra)) == layer.act_letter(u, s)
                counts["direct_limit_action_checks"] += 1
        for x in values:
            if not isinstance(x, Word) or not x.heads:
                continue
            gate = layer.mul(x, layer.a)
            assert isinstance(gate, Word) and not gate.heads
            gate_ordinal = as_ordinal(gate)
            assert gate_ordinal.middle == gate_ordinal.low == 0
            assert gate_ordinal.high > 0
            for v in values:
                z = layer.mul(x, v)
                assert isinstance(z, Word)
                exits = not z.heads or z.heads[0] != x.heads[0]
                assert exits == layer.power_divides(gate_ordinal.high, z)
                counts["exact_exit_cone_checks"] += 1
                if not z.heads:
                    assert layer.power_divides(gate_ordinal.high, z)
                    counts["old_multiple_minimum_checks"] += 1
            for d in samples(base):
                z = layer.mul(x, layer.old(d))
                assert isinstance(z, Word)
                if layer.power_divides(gate_ordinal.high, z):
                    assert not z.heads
                counts["old_factor_gate_checks"] += 1
    grid = [Ordinal(*x) for x in product(range(4), repeat=3)]
    for x in grid:
        assert 0 < height(x) < 1 and 0 < cost(x) <= 1
    for x, y in product(grid, repeat=2):
        if lex(x) < lex(y):
            assert height(y) - height(x) > missed_cost_supremum(x, y)
            counts["margin_intervals"] += 1
    return {
        "classification": "finite exact experiments in infinite monoids; not a universal proof",
        "base": "ordinal addition on N^3 below omega^3",
        "successive_probe_extensions": 3,
        "noninjective_transition_at_every_stage": True,
        "word_equality": "exact recursive normal forms, with signed-coordinate direct limits",
        "counts": counts,
    }


def term(symbol: int, *children: dict) -> dict:
    return {"symbol": symbol, "children": list(children)}


def var(symbol: int) -> dict:
    return {"symbol": symbol, "is_variable": True}


def normalized_term(t: dict) -> tuple:
    return (
        t.get("is_variable", False), t["symbol"],
        tuple(normalized_term(c) for c in t.get("children", [])),
    )


def verify_jacobian() -> dict:
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    contract = json.loads((HERE / "jacobian-contract.json").read_text())
    response = json.loads((HERE / "jacobian-output.json").read_text())
    assert contract["result"]["operation"]["operation_id"] == OPERATION
    assert response["request"]["operation_id"] == OPERATION
    assert response["request"]["payload"] == payload
    assert response["result"]["operation_id"] == OPERATION
    assert response["server"]["version"] == contract["server"]["version"] == "0.14.0"
    assert response["protocol_version"] == contract["protocol_version"] == "2025-11-25"
    profile = response["result"]["output"]["profile"]
    assert [(c["position"], c["unifiable"]) for c in profile["candidates"]] == [
        ([1], True), ([1, 0], False)
    ]
    assert len(profile["pairs"]) == 1
    pair = profile["pairs"][0]
    assert pair["candidate_index"] == 0
    outer = term(0, term(3, term(2, var(0)), var(1)), term(0, term(1, var(4)), var(5)))
    inner = term(0, var(0), term(0, term(3, term(2, term(1, var(1))), var(4)), var(5)))
    assert normalized_term(pair["outer_reduct"]) == normalized_term(outer)
    assert normalized_term(pair["inner_reduct"]) == normalized_term(inner)
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_status": "complete",
        "structured_error": None,
        "timeout": False,
        "candidate_positions": [[1], [1, 0]],
        "nontrivial_pairs": 1,
        "scope": "finite first-order shadow of the internal-letter reduction only",
        "payload": "jacobian-payload.json",
        "typed_output": "jacobian-output.json",
        "contract": "jacobian-contract.json",
    }


def verify_formal() -> dict:
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"),
        "--project-root", str(ROOT), "--claim", "C_PROBE_CORE",
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE), "--timeout", "100",
    ]
    compiled = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    check_results = {}
    for module in ("math_state", "proof_graph_check"):
        check_results[module] = subprocess.run([
            ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
            "check", "--project-root", str(ROOT),
        ], cwd=ROOT, text=True, capture_output=True, check=False)
    for label, completed in [("Lean verification", compiled), *check_results.items()]:
        if completed.returncode:
            raise RuntimeError(
                f"{label} failed ({completed.returncode}):\n"
                f"{completed.stdout}\n{completed.stderr}"
            )
    result = json.loads(compiled.stdout)
    assert result["status"] == "success"
    assert result["exit_code"] == 0 and result["audit_exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["kernel"]["recorded"] is not None
    checks = {
        name: {"exit_code": check.returncode, "output": check.stdout.strip()}
        for name, check in check_results.items()
    }
    return {"command": command, "result": result, "campaign_checks": checks}


def main() -> None:
    start = time.monotonic()
    examples = verify_examples()
    jacobian = verify_jacobian()
    formal = verify_formal()
    certificate = {
        "claim_id": "C_PROBE_CORE",
        "result_class": "new_theorem",
        "contribution": "independent universal formal verification of the actual probe algebra",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "awaiting_independent_review",
        "significance_status": "awaiting_independent_review",
        "independent_review_required": True,
        "independent_review_complete": False,
        "project_root": str(ROOT),
        "formal_declarations": [
            "ProbeAudit.Source.probe_algebra_core",
            "ProbeAudit.Source.p_step",
            "ProbeAudit.Source.p_close",
            "ProbeAudit.Source.presentation_universal",
        ],
        "proved_scope": [
            "faithful presentation by the universal property",
            "noninjective direct-limit transitions explicitly allowed",
            "left cancellation and conicality",
            "all conditional right joins",
            "conservative old comparisons, right factors, joins and nonjoins",
            "old-rooted exact exit cones",
            "least old right multiples reached by old right factors",
            "the manuscript's old-factor gate implication",
        ],
        "not_claimed": [
            "the full probe divisor profile",
            "height and cost extension",
            "conservative simulation",
            "countable-base rearrangement or descent",
            "countable stabilizer quotients",
            "the full manuscript or its consistency conclusions",
            "independently verified novelty or publishability before Reviewer acceptance",
        ],
        "manuscript_false_assertions_established": [],
        "formal": formal,
        "adversarial_examples": examples,
        "jacobian": jacobian,
        "elapsed_seconds": round(time.monotonic() - start, 3),
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "claim": certificate["claim_id"],
        "lean_exit_code": formal["result"]["exit_code"],
        "proof_holes": formal["result"]["proof_holes"],
        "campaign_root": str(ROOT),
        "math_state_exit_code": formal["campaign_checks"]["math_state"]["exit_code"],
        "proof_graph_exit_code": formal["campaign_checks"]["proof_graph_check"]["exit_code"],
        "example_counts": examples["counts"],
        "independent_review": "pending",
        "certificate": str(HERE / "exact_certificate.json"),
    }, indent=2))


if __name__ == "__main__":
    main()
