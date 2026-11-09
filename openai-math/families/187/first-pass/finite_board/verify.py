#!/usr/bin/env python3
"""Replay the staged certificate and bind its syntax to the finite-support proof."""

import argparse
import json
import re
import runpy
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
SOURCE = ROOT / "research/openai_manuscript/Snaky-in-21-Maker-moves-September-25-2026"
SYMBOLS = "0123456789ABCDEFG"
SNAKY = ((0, 0), (1, 0), (2, 0), (3, 0), (3, 1), (4, 1))
MARKER = "/- BEGIN SOURCE-BOUND CERTIFICATE DATA -/"


def require(condition, message):
    if not condition:
        raise ValueError(message)


@dataclass(frozen=True)
class Ref:
    index: int
    symmetry: int
    shift: tuple


@dataclass(frozen=True)
class Node:
    pivot: tuple
    children: tuple


@dataclass(frozen=True)
class Card:
    required: frozenset
    envelope: frozenset
    height: int


def point(token):
    require(len(token) == 2 and all(c in SYMBOLS for c in token), f"Invalid point {token!r}")
    return tuple(SYMBOLS.index(c) for c in token)


def orient(s, p):
    x, y = p
    if s & 2:
        x = -x
    if s & 4:
        y = -y
    if s & 1:
        x, y = y, x
    return x, y


def put(s, shift, cells):
    dx, dy = shift
    return frozenset((x + dx, y + dy) for x, y in (orient(s, p) for p in cells))


class Parser:
    def __init__(self, tokens, limit):
        self.tokens = iter(tokens)
        self.limit = limit

    def node(self):
        pivot = point(next(self.tokens))
        children = []
        for token in self.tokens:
            if token == ")":
                require(children, "Empty child family")
                return Node(pivot, tuple(children))
            if token == "(":
                children.append(self.node())
                continue
            match = re.fullmatch(r"([0-9]+)(?::([0-7])([0-9A-G]{2}))?", token)
            require(match is not None, f"Invalid reference {token!r}")
            index = int(match[1])
            require(0 <= index < self.limit, f"Non-backward reference {index}")
            children.append(Ref(index, int(match[2] or 0), point(match[3] or "00")))
        raise ValueError("Unterminated composition")


def parse(text):
    rows = []
    for line in text.strip().splitlines():
        words = line.replace("(", " ( ").replace(")", " ) ").split()
        require(int(words[0]) == len(rows) + 6, "Nonconsecutive card index")
        parser = Parser(words[1:] + [")"], len(rows) + 6)
        rows.append(parser.node())
        require(next(parser.tokens, None) is None, "Trailing certificate token")
    require(len(rows) == 722, "Expected 722 numbered nonbase cards")
    return rows


def evaluate(expr, cards, statistics):
    if isinstance(expr, Ref):
        c = cards[expr.index]
        a = put(expr.symmetry, expr.shift, c.required)
        t = put(expr.symmetry, expr.shift, c.envelope)
        require(len(a) == len(c.required) and len(t) == len(c.envelope), "Noninjective placement")
        return Card(a, t, c.height)
    cs = [evaluate(child, cards, statistics) for child in expr.children]
    required_union = frozenset().union(*(c.required for c in cs))
    common = frozenset.intersection(*(c.envelope for c in cs))
    a = (required_union | common) - {expr.pivot}
    t = frozenset({expr.pivot}).union(*(c.envelope for c in cs))
    height = 1 + max(c.height for c in cs)
    require(a <= t and expr.pivot not in a, "Invalid standing conditions")
    owned = a | {expr.pivot}
    require(all(c.required <= owned and c.envelope <= t for c in cs), "Invalid child containment")
    require(common <= owned, "Common-envelope obligation failed")
    for b in t - owned:
        require(any(b not in c.envelope for c in cs), f"No surviving child for reply {b}")
        statistics["local_reply_classes"] += 1
    statistics["outside_reply_classes"] += 1
    statistics["composition_nodes"] += 1
    return Card(a, t, height)


def lean_point(p):
    return f"({p[0]},{p[1]})"


def lean_expr(expr):
    if isinstance(expr, Ref):
        return f"(cacheCard (placed {expr.symmetry} {lean_point(expr.shift)} card{expr.index}))"
    children = ", ".join(lean_expr(child) for child in expr.children)
    return f"(cacheCard (combine {lean_point(expr.pivot)} #v[{children}]))"


THEOREMS = r"""
def T727 : Finset Cell := card727.T
def axis17 : Finset ℤ := (Finset.range 17).image Int.ofNat
def board17 : Finset Cell := axis17.product axis17

theorem mem_axis17 (x : ℤ) : x ∈ axis17 ↔ 0 ≤ x ∧ x ≤ 16 := by
  simp only [axis17, Finset.mem_image, Finset.mem_range]
  constructor
  · rintro ⟨n,hn,rfl⟩
    change 0 ≤ (n : ℤ) ∧ (n : ℤ) ≤ 16
    omega
  · rintro ⟨hx0,hx16⟩
    refine ⟨x.toNat,by omega,?_⟩
    change (x.toNat : ℤ) = x
    omega

set_option maxHeartbeats 20000000 in
set_option maxRecDepth 65536 in
theorem endpoint :
    card727.A = ∅ ∧ card727.h = 21 ∧ card727.T.card = 251 ∧
      (∀ p ∈ card727.T, 0 ≤ p.1 ∧ p.1 ≤ 16 ∧ 0 ≤ p.2 ∧ p.2 ≤ 16) := by
  decide +kernel

theorem supported_root : WinIn HasSnaky T727 21 ∅ ∅ := by
  have hw := card727.valid card727.T ∅ ∅ (Finset.Subset.refl _)
    (by simp) (by simp [endpoint.1]) (by simp)
    (by norm_num [endpoint.2.1, endpoint.2.2.1])
  simpa only [endpoint.2.1, T727] using hw

theorem not_hasSnaky_empty : ¬HasSnaky ∅ := by
  rintro ⟨r,t,h⟩
  have hx := h (Finset.mem_image_of_mem (place r t)
    (show (0,0) ∈ snaky by decide))
  simp at hx

theorem fixed_confined_policy :
    ∃ σ : Policy Cell,
      Forces σ HasSnaky T727 21 ∅ ∅ ∧
      ∀ β : ℕ → Cell, Legal σ HasSnaky β 21 0 ∅ ∅ →
        ∃ F G c d, Execution σ HasSnaky T727 β 21 0 ∅ ∅ F G c d ∧
          HasSnaky F ∧ Disjoint F G ∧ F ⊆ T727 ∧
          F.card = c ∧ G.card = d ∧ c ≤ 21 ∧ d ≤ 20 ∧ c = d+1 := by
  have hf := fixed_policy supported_root
  refine ⟨policy HasSnaky T727,hf,?_⟩
  intro β hl
  obtain ⟨F,G,c,d,he⟩ := hf.executes β 0 (by simp) hl
  obtain ⟨hw,hd,_,_,hs,hc,hb,hcn,hdn,hcd⟩ := he.summary
  refine ⟨F,G,c,d,he,hw,hd,?_,?_,?_,hcn,by omega,?_⟩
  · simpa only [Finset.empty_union] using hs
  · simpa only [Finset.card_empty, Nat.zero_add] using hc
  · simpa only [Finset.card_empty, Nat.zero_add] using hb
  · exact hcd.resolve_left not_hasSnaky_empty

theorem finite_board_has_room (M B : Finset Cell)
    (h : M.card + B.card ≤ 40) :
    ∃ x ∈ T727, x ∉ M ∧ x ∉ B := by
  apply fresh_in
  have hc : T727.card = 251 := endpoint.2.2.1
  omega

theorem envelope_in_board17 : T727 ⊆ board17 := by
  intro p hp
  obtain ⟨hx0,hx16,hy0,hy16⟩ := endpoint.2.2.2 p hp
  exact Finset.mem_product.mpr ⟨(mem_axis17 _).mpr ⟨hx0,hx16⟩,
    (mem_axis17 _).mpr ⟨hy0,hy16⟩⟩

theorem finite_board_corollaries :
    T727.card = 251 ∧ board17.card = 289 ∧ T727 ⊆ board17 ∧
    ∃ σ : Policy Cell,
      Forces σ HasSnaky T727 21 ∅ ∅ ∧
      ∀ Q : Finset Cell, T727 ⊆ Q →
        ∀ β : ℕ → Cell, Legal σ HasSnaky β 21 0 ∅ ∅ →
          ∃ F G c d, Execution σ HasSnaky T727 β 21 0 ∅ ∅ F G c d ∧
            HasSnaky F ∧ Disjoint F G ∧ F ⊆ Q ∧
            F.card = c ∧ G.card = d ∧ c ≤ 21 ∧ d ≤ 20 ∧ c = d+1 := by
  obtain ⟨σ,hf,hw⟩ := fixed_confined_policy
  refine ⟨endpoint.2.2.1,by decide +kernel,envelope_in_board17,σ,hf,?_⟩
  intro Q hQ β hl
  obtain ⟨F,G,c,d,he,hs,hd,hT,hc,hb,hcn,hdn,hcd⟩ := hw β hl
  exact ⟨F,G,c,d,he,hs,hd,hT.trans hQ,hc,hb,hcn,hdn,hcd⟩

#print axioms fixed_confined_policy
#print axioms finite_board_corollaries

end SnakyFinite
"""


def lean_tail(rows):
    bases = [f"def card{j} : Card := cacheCard (base {j})" for j in range(6)]
    definitions = [f"def card{i} : Card := {lean_expr(row)}" for i, row in enumerate(rows, 6)]
    return ("\n\nset_option maxHeartbeats 2000000\nset_option maxRecDepth 65536\n"
            + "\n".join(bases + definitions) + "\n" + THEOREMS)


def check_symmetries():
    probes = ((0, 0), (1, 0), (0, 1), (-3, 7), (9, -2))
    signatures = {tuple(orient(s, p) for p in probes): s for s in range(8)}
    require(len(signatures) == 8, "D4 orientations are not distinct")
    for r in range(8):
        require(any(all(orient(s, orient(r, p)) == p for p in probes) for s in range(8)),
                "Missing inverse")
        for s in range(8):
            require(tuple(orient(r, orient(s, p)) for p in probes) in signatures,
                    "Orientation family is not closed")


def main():
    require(__debug__, "Run without -O: the reused staged checker requires active assertions")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--emit-lean", action="store_true", help="Compile original certificate expressions to Lean definitions")
    args = parser.parse_args()
    text = (SOURCE / "verification/certificate.txt").read_text(encoding="ascii")
    runpy.run_path(str(SOURCE / "verification/verify_certificate.py"))["verify"](text)
    rows = parse(text)
    check_symmetries()
    cards = [Card(frozenset(SNAKY) - {p}, frozenset(SNAKY), 1) for p in SNAKY]
    stats = {"composition_nodes": 0, "local_reply_classes": 0, "outside_reply_classes": 0}
    for row in rows:
        cards.append(evaluate(row, cards, stats))
    c = cards[-1]
    require(c.required == frozenset(), "Endpoint requires preowned cells")
    require(c.height == 21 and len(c.envelope) == 251, "Wrong endpoint height or cardinality")
    require(all(0 <= x <= 16 and 0 <= y <= 16 for x, y in c.envelope), "Envelope escapes 17-by-17 board")
    path = HERE / "Main.lean"
    core, sep, _ = path.read_text().partition(MARKER)
    require(sep == MARKER, "Missing source-binding marker")
    expected = core + MARKER + lean_tail(rows)
    if args.emit_lean:
        path.write_text(expected)
    require(path.read_text() == expected, "Lean certificate syntax differs from staged certificate")
    result = {
        "claim": "C9000187_FINITE_BOARD",
        "result_class": "new_theorem",
        "source": str((SOURCE / "verification/certificate.txt").relative_to(ROOT)),
        "source_binding": "All original certificate expressions, including nested frames, compare exactly to generated Lean definitions; no set snapshots are substituted.",
        "staged_short_checker": "passed",
        "numbered_cards": len(cards),
        **stats,
        "endpoint": {
            "card": 727, "required": [], "height": c.height,
            "envelope_cardinality": len(c.envelope),
            "bounding_box": [0, 16, 0, 16],
            "envelope": [list(p) for p in sorted(c.envelope)],
        },
        "semantics": {
            "fixed_policy": "SnakyFinite.policy SnakyFinite.HasSnaky SnakyFinite.T727",
            "theorem": "SnakyFinite.fixed_confined_policy",
            "finite_board_theorem": "SnakyFinite.finite_board_corollaries",
            "maximum_actual_maker_claims": 21,
            "maximum_intervening_breaker_replies": 20,
            "replacement_claims_charged": True,
            "outside_breaker_replies_allowed": True,
            "no_reply_after_victory": True,
            "maximum_occupied_before_claim_21": 40,
            "master_envelope_capacity": 251,
        },
        "evidence_boundary": "The finite checks certify the source data and local set obligations. The universally quantified policy statement is proved by Main.lean, not by finite sampling.",
        "independent_review": "pending",
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({k: v for k, v in result.items() if k not in ("endpoint", "source_binding", "evidence_boundary", "semantics")}, sort_keys=True))
    print("A_727=empty; h_727=21; |T_727|=251; T_727 subset [0,16]^2; source-bound Lean syntax matches.")


if __name__ == "__main__":
    main()
