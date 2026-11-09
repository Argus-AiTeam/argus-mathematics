#!/usr/bin/env python3
"""Generate a small-kernel LRAT proof of the complete finite model."""

import argparse
from itertools import combinations, product
import json
from pathlib import Path
import time

ROOT = Path(__file__).resolve().parent


def masks(k):
    return [s for s in range(1024) if s.bit_count() == k]


def contained(a, b):
    return (a & b) == a


def model_gates():
    facets, triangles, pairs = masks(4), masks(3), masks(2)
    ti = {t: 210 + i for i, t in enumerate(triangles)}
    incident = [[i for i, s in enumerate(facets) if contained(t, s)]
                for t in triangles]
    gates = [("nonempty", *range(210))]
    gates += [("down", ti[t], *row) for t, row in zip(triangles, incident)]
    gates += [("parity", *row) for row in incident]
    complements, pair_rows = [], []
    for i, s in enumerate(facets):
        c = 1023 ^ s
        local = [t for t in triangles if contained(t, c)]
        complements += [("complement", i, ti[t], ti[c ^ t]) for t in local]
        pair_rows += [("two", i, *[ti[t] for t in local if contained(p, t)])
                      for p in pairs if contained(p, c)]
    return gates + complements + pair_rows


def encode_gate(gate):
    kind, *v = gate
    positive = lambda i: i + 1
    negative = lambda i: -(i + 1)
    if kind == "nonempty":
        return [[positive(i) for i in v]]
    if kind == "down":
        out, *xs = v
        assert len(xs) == 7
        return [[negative(out), *map(positive, xs)]] + [
            [negative(x), positive(out)] for x in xs]
    if kind == "parity":
        assert len(v) == 7
        return [[negative(i) if value else positive(i)
                 for i, value in zip(v, values)]
                for values in product((False, True), repeat=7)
                if sum(values) % 2 == 1]
    if kind == "complement":
        guard, a, b = v
        return [[negative(guard), positive(a), positive(b)],
                [negative(guard), negative(a), negative(b)]]
    if kind == "two":
        guard, *xs = v
        assert len(xs) == 4
        return [clause for triple in combinations(xs, 3) for clause in (
            [negative(guard), *map(positive, triple)],
            [negative(guard), *map(negative, triple)])]
    raise ValueError(f"Unknown gate: {kind}")


def full_cnf():
    return [clause for gate in model_gates() for clause in encode_gate(gate)]


def build():
    from pysat.solvers import Solver
    from verify import RupChecker

    clauses = full_cnf()
    assert len(model_gates()) == 7591 and len(clauses) == 42241
    assert max(abs(lit) for c in clauses for lit in c) == 330
    start = time.monotonic()
    with Solver(name="glucose4", bootstrap_with=clauses, with_proof=True) as solver:
        solver.conf_budget(200000)
        outcome = solver.solve_limited()
        if outcome is not False:
            raise RuntimeError(f"No refutation obtained: solver outcome {outcome!r}")
        proof = solver.get_proof()
        statistics = solver.accum_stats()
    (ROOT / "formal_refutation.drat").write_text("\n".join(proof) + "\n")
    checker = RupChecker(330, clauses)
    lines = []
    additions = 0
    hint_count = 0
    empty = False
    for line in proof:
        tokens = line.split()
        if tokens[0] == "d":
            continue
        assert tokens[-1] == "0"
        clause = [int(x) for x in tokens[:-1]]
        assert all(-x not in clause for x in clause)
        hints = checker.trace(clause)
        assert hints is not None, "A formal-proof clause is not RUP"
        ident = len(clauses) + additions + 1
        assert hints and all(0 < hint < ident for hint in hints)
        lines.append(" ".join(map(str, [ident, *clause, 0, *hints, 0])))
        checker.add(clause)
        additions += 1
        hint_count += len(hints)
        empty |= not clause
    assert empty
    (ROOT / "formal_refutation.lrat").write_text("\n".join(lines) + "\n")
    result = {"variables": 330, "gates": 7591, "clauses": len(clauses),
              "rup_additions": additions, "lrat_hints": hint_count,
              "derived_empty_clause": True, "statistics": statistics,
              "seconds": time.monotonic() - start}
    (ROOT / "formal_search_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))


def check_primitives():
    cases = 0
    examples = [
        (("down", *range(8)), 8, lambda v: v[0] == any(v[1:])),
        (("parity", *range(7)), 7, lambda v: sum(v) % 2 == 0),
        (("complement", *range(3)), 3, lambda v: not v[0] or v[1] != v[2]),
        (("two", *range(5)), 5, lambda v: not v[0] or sum(v[1:]) == 2),
    ]
    examples += [(("nonempty", *range(n)), n, any) for n in (0, 1, 7)]
    for gate, width, expected in examples:
        clauses = encode_gate(gate)
        for values in product((False, True), repeat=width):
            actual = all(any(values[abs(lit) - 1] == (lit > 0) for lit in c)
                         for c in clauses)
            assert actual == expected(values), (gate, values)
            cases += 1
    return cases


def replay_file(initial, path):
    """Check supplied hints directly, without watches or a solver."""
    clauses = list(initial)
    initial_count = len(clauses)
    assert all(len({abs(lit) for lit in c}) == len(c) for c in clauses)
    additions = 0
    hint_count = 0
    empty = False
    for line in path.read_text().splitlines():
        assert not empty, "There are proof actions after the empty clause"
        values = list(map(int, line.split()))
        end = values.index(0)
        assert values[-1] == 0
        ident, clause, hints = values[0], values[1:end], values[end + 1:-1]
        assert ident == len(clauses) + 1
        assert all(0 < abs(lit) <= 330 for lit in clause)
        assert len({abs(lit) for lit in clause}) == len(clause)
        assert hints and all(0 < hint < ident for hint in hints)
        assigned = {abs(lit): lit < 0 for lit in clause}
        contradiction = False
        for hint in hints:
            c = clauses[hint - 1]
            if any(abs(lit) in assigned and assigned[abs(lit)] == (lit > 0) for lit in c):
                continue
            unassigned = [lit for lit in c if abs(lit) not in assigned]
            if not unassigned:
                contradiction = True
                break
            assert len(unassigned) == 1, (ident, hint, "Hint is not unit")
            lit = unassigned[0]
            assigned[abs(lit)] = lit > 0
        assert contradiction, (ident, "RUP hints do not derive a contradiction")
        clauses.append(clause)
        additions += 1
        hint_count += len(hints)
        empty = not clause
    assert empty
    return {"initial_clauses": initial_count,
            "rup_additions": additions, "lrat_hints": hint_count,
            "derived_empty_clause": True}


def replay():
    clauses = full_cnf()
    assert len(model_gates()) == 7591 and len(clauses) == 42241
    assert max(abs(lit) for c in clauses for lit in c) == 330
    return {"variables": 330, "gates": 7591,
            **replay_file(clauses, ROOT / "formal_refutation_trimmed.lrat"),
            "primitive_assignments": check_primitives()}


def replay_core():
    clauses = full_cnf()
    indices = json.loads((ROOT / "core_indices.json").read_text())
    assert indices == sorted(set(indices))
    assert all(type(i) is int and 0 <= i < len(clauses) for i in indices)
    return {"variables": 330,
            **replay_file([clauses[i] for i in indices], ROOT / "core_refutation.lrat")}


def slice_core():
    """Retain only assignments ancestral to each propagation conflict."""
    initial = full_cnf()
    clauses = list(initial)
    rows = []
    for line in (ROOT / "formal_refutation_trimmed.lrat").read_text().splitlines():
        values = list(map(int, line.split()))
        end = values.index(0)
        ident, clause, hints = values[0], values[1:end], values[end + 1:-1]
        assert ident == len(clauses) + 1 and values[-1] == 0
        assigned = {abs(lit): lit < 0 for lit in clause}
        reasons = {}
        conflict = None
        for hint in hints:
            c = clauses[hint - 1]
            if any(abs(lit) in assigned and assigned[abs(lit)] == (lit > 0) for lit in c):
                continue
            remaining = [lit for lit in c if abs(lit) not in assigned]
            if not remaining:
                conflict = hint
                todo = [abs(lit) for lit in c]
                break
            assert len(remaining) == 1
            lit = remaining[0]
            reasons[abs(lit)] = (hint, [abs(x) for x in c if x != lit])
            assigned[abs(lit)] = lit > 0
        assert conflict is not None
        needed = {conflict}
        visited = set()
        while todo:
            var = todo.pop()
            if var in visited:
                continue
            visited.add(var)
            if var in reasons:
                hint, dependencies = reasons[var]
                needed.add(hint)
                todo.extend(dependencies)
        rows.append((ident, clause, [h for h in hints if h in needed]))
        clauses.append(clause)
    assert rows[-1][1] == []
    by_id = {ident: (clause, hints) for ident, clause, hints in rows}
    needed = set()
    todo = [rows[-1][0]]
    while todo:
        ident = todo.pop()
        if ident <= len(initial) or ident in needed:
            continue
        needed.add(ident)
        todo.extend(by_id[ident][1])
    kept = [row for row in rows if row[0] in needed]
    input_ids = sorted({h for _, _, hs in kept for h in hs if h <= len(initial)})
    remap = {ident: i + 1 for i, ident in enumerate(input_ids)}
    remap.update({ident: len(input_ids) + i + 1
                  for i, (ident, _, _) in enumerate(kept)})
    lines = [" ".join(map(str, [remap[ident], *clause, 0,
                                *(remap[h] for h in hints), 0]))
             for ident, clause, hints in kept]
    (ROOT / "core_indices.json").write_text(json.dumps([i - 1 for i in input_ids]) + "\n")
    (ROOT / "core_refutation.lrat").write_text("\n".join(lines) + "\n")
    result = replay_core()
    (ROOT / "core_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))


def trim():
    rows = []
    for line in (ROOT / "formal_refutation.lrat").read_text().splitlines():
        values = list(map(int, line.split()))
        end = values.index(0)
        assert values[-1] == 0
        rows.append((values[0], values[1:end], values[end + 1:-1]))
    assert rows[-1][1] == []
    by_id = {ident: (clause, hints) for ident, clause, hints in rows}
    needed = set()
    todo = [rows[-1][0]]
    while todo:
        ident = todo.pop()
        if ident <= 42241 or ident in needed:
            continue
        needed.add(ident)
        todo.extend(by_id[ident][1])
    kept = [row for row in rows if row[0] in needed]
    new_id = {ident: 42242 + i for i, (ident, _, _) in enumerate(kept)}
    lines = []
    for ident, clause, hints in kept:
        mapped = [hint if hint <= 42241 else new_id[hint] for hint in hints]
        assert all(0 < hint < new_id[ident] for hint in mapped)
        lines.append(" ".join(map(str, [new_id[ident], *clause, 0, *mapped, 0])))
    (ROOT / "formal_refutation_trimmed.lrat").write_text("\n".join(lines) + "\n")
    result = {"original_actions": len(rows), "retained_actions": len(kept),
              "retained_hints": sum(len(hints) for _, _, hints in kept),
              "derived_empty_clause": True}
    (ROOT / "formal_trim_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))


def kernel_backend_source():
    return """
open LRAT.Internal

def packClause (xs : CNF.Clause (PosFin 331)) : Option (DefaultClause 331) :=
  if h : xs.all (fun l => !(xs.contains (l.1, !l.2))) = true ∧ xs.Nodup then
    some {
      clause := xs
      nodupkey := by
        intro v
        by_cases hm : (v, true) ∈ xs
        · right
          have hh := List.all_eq_true.mp h.1 (v, true) hm
          simpa using hh
        · exact Or.inl hm
      nodup := h.2 }
  else none

theorem packClause_correct (xs : CNF.Clause (PosFin 331)) (c : DefaultClause 331)
    (h : packClause xs = some c) : c.clause = xs := by
  unfold packClause at h
  split at h
  · cases h; rfl
  · contradiction

def liftLits : CNF.Clause Nat → Option (CNF.Clause (PosFin 331))
  | [] => some []
  | (i, b) :: xs =>
      if h : i + 1 < 331 then
        match liftLits xs with
        | some ys => some ((⟨i + 1, by omega⟩, b) :: ys)
        | none => none
      else none

theorem liftLits_correct (a : Nat → Bool) (xs : CNF.Clause Nat)
    (ys : CNF.Clause (PosFin 331)) (h : liftLits xs = some ys) :
    CNF.Clause.eval (fun v => a (v.val - 1)) ys = CNF.Clause.eval a xs := by
  induction xs generalizing ys with
  | nil =>
      simp only [liftLits, Option.some.injEq] at h
      subst ys
      rfl
  | cons x xs ih =>
      rcases x with ⟨i, b⟩
      simp only [liftLits] at h
      split at h
      · split at h
        · rename_i zs hz
          cases h
          change ((a i == b) || CNF.Clause.eval (fun v => a (v.val - 1)) zs) =
            ((a i == b) || CNF.Clause.eval a xs)
          exact congrArg (fun z => (a i == b) || z) (ih zs hz)
        · contradiction
      · contradiction

def prepareClause (xs : CNF.Clause Nat) : Option (DefaultClause 331) :=
  (liftLits xs).bind packClause

theorem prepareClause_correct (a : Nat → Bool) (xs : CNF.Clause Nat)
    (c : DefaultClause 331) (h : prepareClause xs = some c) :
    CNF.Clause.eval (fun v => a (v.val - 1)) c.clause = CNF.Clause.eval a xs := by
  unfold prepareClause at h
  cases hl : liftLits xs with
  | none => simp [hl] at h
  | some ys =>
      simp only [hl, Option.bind_some] at h
      rw [packClause_correct ys c h]
      exact liftLits_correct a xs ys hl

theorem clause_eval_eq (a : PosFin 331 → Bool) (c : DefaultClause 331) :
    Clause.eval a c = CNF.Clause.eval a c.clause := by
  change c.clause.any (fun l => decide (a l.1 = l.2)) =
    c.clause.any (fun l => a l.1 == l.2)
  apply congrArg (fun f => c.clause.any f)
  funext l
  rcases l with ⟨v, b⟩
  cases a v <;> cases b <;> rfl

def prepare (f : CNF Nat) : DefaultFormula 331 :=
  DefaultFormula.ofArray (#[none] ++ f.clauses.map prepareClause)

theorem prepare_sound (f : CNF Nat) :
    Unsatisfiable (PosFin 331) (prepare f) → f.Unsat := by
  intro hu a
  apply eq_false_of_ne_true
  intro ha
  apply hu (fun v => a (v.val - 1))
  simp only [Formula.formulaEntails_def, List.all_eq_true, decide_eq_true_eq]
  intro c hc
  simp [prepare, Formula.toList, DefaultFormula.toList, DefaultFormula.ofArray] at hc
  obtain ⟨raw, hraw, hp⟩ := hc
  change Clause.eval (fun v => a (v.val - 1)) c = true
  rw [clause_eval_eq, prepareClause_correct a raw c hp]
  simp only [CNF.eval, Array.all_eq_true] at ha
  obtain ⟨i, hi, he⟩ := Array.mem_iff_getElem.mp hraw
  simpa only [he] using ha i hi

def convertAction : LRAT.IntAction → Option (DefaultClauseAction 331)
  | .addEmpty i hs => some (.addEmpty i hs)
  | .addRup i xs hs =>
      match xs.toList.mapM (intToLiteral (n := 331)) with
      | none => none
      | some ys =>
          match packClause ys with
          | none => none
          | some c => some (.addRup i c hs)
  | .del ids => some (.del ids)
  | .addRat _ _ _ _ _ => none

theorem convertAction_wellformed (a : LRAT.IntAction) (b : DefaultClauseAction 331)
    (h : convertAction a = some b) : WellFormedAction b := by
  cases a with
  | addEmpty i hs =>
      simp only [convertAction, Option.some.injEq] at h
      subst b
      trivial
  | del ids =>
      simp only [convertAction, Option.some.injEq] at h
      subst b
      trivial
  | addRat _ _ _ _ _ => simp [convertAction] at h
  | addRup i xs hs =>
      simp only [convertAction] at h
      split at h <;> try contradiction
      split at h <;> try contradiction
      cases h
      trivial

def typedProof (raw : Array LRAT.IntAction) : List (DefaultClauseAction 331) :=
  raw.toList.filterMap convertAction

theorem typedProof_wellformed (raw : Array LRAT.IntAction) :
    ∀ a ∈ typedProof raw, WellFormedAction a := by
  intro a ha
  obtain ⟨b, hb, hconv⟩ := List.mem_filterMap.mp ha
  exact convertAction_wellformed b a hconv

theorem refutation_sound (f : CNF Nat) (raw : Array LRAT.IntAction)
    (h : lratChecker (prepare f) (typedProof raw) = .success) : f.Unsat := by
  apply prepare_sound f
  exact lratCheckerSound (prepare f)
    (DefaultFormula.readyForRupAdd_ofArray _)
    (DefaultFormula.readyForRatAdd_ofArray _)
    (typedProof raw) (typedProof_wellformed raw) h

elab "lrat_data% " text:str : term => do
  match LRAT.parseLRATProof text.getString.toUTF8 with
  | .error e => Lean.throwError m!"LRAT syntax error: {e}"
  | .ok p =>
      for a in p do
        match a with
        | .addRat _ _ _ _ _ => Lean.throwError "Only RUP proof additions are supported"
        | .del _ => Lean.throwError "The kernel proof must not contain deletions"
        | _ =>
            if (convertAction a).isNone then
              Lean.throwError "Invalid, duplicate, complementary, or out-of-range proof literal"
      return Lean.toExpr p
"""


def backend_test_source():
    primitives = "inductive Gate where" + lean_source().split(
        "inductive Gate where", 1)[1].split("def downGate", 1)[0]
    return """import Lean.Elab.Tactic.BVDecide.Frontend.LRAT
set_option maxRecDepth 10000
set_option maxHeartbeats 0
namespace TenLabel
open Std.Sat Std.Tactic.BVDecide
""" + primitives + kernel_backend_source() + """
example : (BitVec.ofNat 10 7).cpop.toNat = 3 := by decide +kernel
def sample : CNF Nat := ⟨#[[(0,true)],[(0,false)]]⟩
def sampleProof : Array LRAT.IntAction := lrat_data% "3 0 1 2 0\\n"
theorem sample_check : lratChecker (prepare sample) (typedProof sampleProof) = .success := by
  decide +kernel
theorem sample_unsat : sample.Unsat := refutation_sound sample sampleProof sample_check
#print axioms encode_correct
#print axioms sample_unsat
end TenLabel
"""


def lean_value(value):
    if isinstance(value, tuple):
        return "(" + ", ".join(lean_value(v) for v in value) + ")"
    if isinstance(value, list):
        return "[" + ", ".join(lean_value(v) for v in value) + "]"
    return str(value)


def table_data():
    facets, triangles, pairs = masks(4), masks(3), masks(2)
    ti = {t: i for i, t in enumerate(triangles)}
    incidence = [[i for i, s in enumerate(facets) if contained(t, s)] for t in triangles]
    complement_rows, pair_rows = [], []
    for s in facets:
        c = 1023 ^ s
        local = [t for t in triangles if contained(t, c)]
        complement_rows.append([(ti[t], ti[c ^ t]) for t in local])
        pair_rows.append([[ti[t] for t in local if contained(p, t)]
                          for p in pairs if contained(p, c)])
    return [("facets", "List Nat", facets),
            ("triangles", "List Nat", triangles),
            ("pairs", "List Nat", pairs),
            ("incidenceRows", "List (List Nat)", incidence),
            ("complementRows", "List (List (Nat × Nat))", complement_rows),
            ("pairRows", "List (List (List Nat))", pair_rows)]


def data_source():
    return "\n\n".join(f"noncomputable def {name} : {kind} :=\n  {lean_value(data)}"
                       for name, kind, data in table_data())


def parity_clauses_source():
    clauses = []
    for values in product((False, True), repeat=7):
        if sum(values) % 2 == 1:
            clauses.append("[" + ", ".join(
                f"(x{i}, {'false' if value else 'true'})"
                for i, value in enumerate(values)) + "]")
    return "[" + ",\n      ".join(clauses) + "]"


def checker_source():
    proof_text = (ROOT / "formal_refutation_trimmed.lrat").read_text()
    return """import Lean.Elab.Tactic.BVDecide.Frontend.LRAT

set_option maxRecDepth 100000
set_option maxHeartbeats 0

namespace TenLabel
open Std.Sat
open Std.Tactic.BVDecide

""" + data_source() + """

noncomputable def allMasks (k : Nat) : List Nat :=
  (List.range 1024).filter fun s => (BitVec.ofNat 10 s).cpop.toNat == k

theorem facets_complete : facets = allMasks 4 := by decide +kernel
theorem triangles_complete : triangles = allMasks 3 := by decide +kernel
theorem pairs_complete : pairs = allMasks 2 := by decide +kernel

def subset (a b : Nat) : Bool := a &&& b == a

theorem incidenceRows_complete :
    incidenceRows = triangles.map (fun t =>
      (facets.zipIdx.filter (fun si => subset t si.1)).map Prod.snd) := by decide +kernel

theorem complementRows_complete :
    complementRows = facets.map (fun s =>
      let c := 1023 ^^^ s
      (triangles.filter (fun t => subset t c)).map
        (fun t => (triangles.idxOf t, triangles.idxOf (c ^^^ t)))) := by decide +kernel

theorem pairRows_complete :
    pairRows = facets.map (fun s =>
      let c := 1023 ^^^ s
      (pairs.filter (fun p => subset p c)).map (fun p =>
        (triangles.filter (fun t => subset t c && subset p t)).map
          (fun t => triangles.idxOf t))) := by decide +kernel

theorem row_shapes :
    facets.length = 210 ∧ triangles.length = 120 ∧ pairs.length = 45 ∧
      incidenceRows.length = 120 ∧ complementRows.length = 210 ∧ pairRows.length = 210 ∧
      incidenceRows.all (fun r => r.length == 7) = true ∧
      complementRows.all (fun r => r.length == 20) = true ∧
      pairRows.all (fun r => r.length == 15 && r.all (fun p => p.length == 4)) = true := by
  decide +kernel

theorem row_indices :
    incidenceRows.flatten.all (fun i => decide (i < 210)) = true ∧
      complementRows.flatten.all (fun ij => decide (ij.1 < 120) && decide (ij.2 < 120)) = true ∧
      pairRows.flatten.flatten.all (fun i => decide (i < 120)) = true := by
  decide +kernel

inductive Gate where
  | nonempty (xs : List Nat)
  | down (o x0 x1 x2 x3 x4 x5 x6 : Nat)
  | parity (x0 x1 x2 x3 x4 x5 x6 : Nat)
  | complement (g x y : Nat)
  | two (g x0 x1 x2 x3 : Nat)
  | bad
  deriving BEq

def exactlyTwo4 (a b c d : Bool) : Bool :=
  !(a ^^ b ^^ c ^^ d) && (a || b || c || d) && (!a || !b || !c || !d)

theorem exactlyTwo_spec (a b c d : Bool) :
    exactlyTwo4 a b c d =
      decide (a.toNat + b.toNat + c.toNat + d.toNat = 2) := by
  cases a <;> cases b <;> cases c <;> cases d <;> rfl

def evaluate (a : Nat → Bool) : Gate → Bool
  | .nonempty xs => xs.any a
  | .down o x0 x1 x2 x3 x4 x5 x6 =>
      a o == (a x0 || a x1 || a x2 || a x3 || a x4 || a x5 || a x6)
  | .parity x0 x1 x2 x3 x4 x5 x6 =>
      !(a x0 ^^ a x1 ^^ a x2 ^^ a x3 ^^ a x4 ^^ a x5 ^^ a x6)
  | .complement g x y => !a g || Bool.xor (a x) (a y)
  | .two g x0 x1 x2 x3 => !a g || exactlyTwo4 (a x0) (a x1) (a x2) (a x3)
  | .bad => false

def encode : Gate → List (CNF.Clause Nat)
  | .nonempty xs => [xs.map (fun i => (i, true))]
  | .down o x0 x1 x2 x3 x4 x5 x6 =>
      [[(o, false), (x0, true), (x1, true), (x2, true), (x3, true), (x4, true), (x5, true), (x6, true)],
       [(x0, false), (o, true)], [(x1, false), (o, true)], [(x2, false), (o, true)],
       [(x3, false), (o, true)], [(x4, false), (o, true)], [(x5, false), (o, true)],
       [(x6, false), (o, true)]]
  | .parity x0 x1 x2 x3 x4 x5 x6 =>
      """ + parity_clauses_source() + """
  | .complement g x y =>
      [[(g, false), (x, true), (y, true)], [(g, false), (x, false), (y, false)]]
  | .two g x0 x1 x2 x3 =>
      [[(g, false), (x0, true), (x1, true), (x2, true)],
       [(g, false), (x0, false), (x1, false), (x2, false)],
       [(g, false), (x0, true), (x1, true), (x3, true)],
       [(g, false), (x0, false), (x1, false), (x3, false)],
       [(g, false), (x0, true), (x2, true), (x3, true)],
       [(g, false), (x0, false), (x2, false), (x3, false)],
       [(g, false), (x1, true), (x2, true), (x3, true)],
       [(g, false), (x1, false), (x2, false), (x3, false)]]
  | .bad => [[]]

theorem encode_correct (a : Nat → Bool) (g : Gate) :
    (encode g).all (CNF.Clause.eval a) = evaluate a g := by
  cases g with
  | nonempty xs =>
      simp [encode, evaluate, CNF.Clause.eval, List.any_map]
      apply congrArg (fun f : Nat → Bool => xs.any f)
      funext i
      change (a i == true) = a i
      cases a i <;> rfl
  | bad => rfl
  | down o x0 x1 x2 x3 x4 x5 x6 =>
      simp only [encode, evaluate, CNF.Clause.eval, List.all, List.any]
      cases a o <;> cases a x0 <;> cases a x1 <;> cases a x2 <;>
        cases a x3 <;> cases a x4 <;> cases a x5 <;> cases a x6 <;> rfl
  | parity x0 x1 x2 x3 x4 x5 x6 =>
      simp only [encode, evaluate, CNF.Clause.eval, List.all, List.any]
      cases a x0 <;> cases a x1 <;> cases a x2 <;> cases a x3 <;>
        cases a x4 <;> cases a x5 <;> cases a x6 <;> rfl
  | complement g x y =>
      simp only [encode, evaluate, CNF.Clause.eval, List.all, List.any]
      cases a g <;> cases a x <;> cases a y <;> rfl
  | two g x0 x1 x2 x3 =>
      simp only [encode, evaluate, exactlyTwo4, CNF.Clause.eval, List.all, List.any]
      cases a g <;> cases a x0 <;> cases a x1 <;> cases a x2 <;> cases a x3 <;> rfl

def downGate (j : Nat) : List Nat → Gate
  | [x0, x1, x2, x3, x4, x5, x6] => .down (210 + j) x0 x1 x2 x3 x4 x5 x6
  | _ => .bad

def parityGate : List Nat → Gate
  | [x0, x1, x2, x3, x4, x5, x6] => .parity x0 x1 x2 x3 x4 x5 x6
  | _ => .bad

def twoGate (g : Nat) : List Nat → Gate
  | [x0, x1, x2, x3] => .two g (210 + x0) (210 + x1) (210 + x2) (210 + x3)
  | _ => .bad

noncomputable def gates : List Gate :=
  [.nonempty (List.range 210)] ++
  incidenceRows.zipIdx.map (fun ri => downGate ri.2 ri.1) ++
  incidenceRows.map parityGate ++
  complementRows.zipIdx.flatMap (fun ri =>
    ri.1.map (fun ij => .complement ri.2 (210 + ij.1) (210 + ij.2))) ++
  pairRows.zipIdx.flatMap (fun ri => ri.1.map (twoGate ri.2))

theorem gates_valid : gates.length = 7591 ∧ gates.all (fun g => g != .bad) = true := by
  decide +kernel

noncomputable def cnf : CNF Nat := ⟨(gates.flatMap encode).toArray⟩

theorem cnf_size : cnf.clauses.size = 42241 := by decide +kernel

theorem cnf_variables : cnf.numLiterals = 330 := by decide +kernel

noncomputable def model (a : Nat → Bool) : Bool := gates.all (evaluate a)

theorem encode_all_correct (gs : List Gate) (a : Nat → Bool) :
    (gs.flatMap encode).all (CNF.Clause.eval a) = gs.all (evaluate a) := by
  induction gs with
  | nil => rfl
  | cons g gs ih =>
      simp only [List.flatMap_cons, List.all_append, List.all_cons, encode_correct, ih]

theorem cnf_models (a : Nat → Bool) : cnf.eval a = model a := by
  simpa only [cnf, model, CNF.eval, List.all_toArray] using encode_all_correct gates a

""" + kernel_backend_source() + """

theorem initial_clauses_preserved :
    cnf.clauses.all (fun c => (prepareClause c).isSome) = true := by decide +kernel

noncomputable def proof : Array LRAT.IntAction := lrat_data% """ + json.dumps(proof_text) + """

theorem proof_shape : proof.size = 4939 ∧ (typedProof proof).length = 4939 := by
  decide +kernel

theorem checked_refutation : lratChecker (prepare cnf) (typedProof proof) = .success := by
  decide +kernel

theorem cnf_unsat : cnf.Unsat := refutation_sound cnf proof checked_refutation

theorem no_nonempty_good_family (a : Nat → Bool) : model a = false := by
  rw [← cnf_models]
  exact cnf_unsat a

theorem no_model : ¬ ∃ a : Nat → Bool, model a = true := by
  intro ⟨a, h⟩
  rw [no_nonempty_good_family] at h
  contradiction

end TenLabel

#print axioms TenLabel.no_nonempty_good_family
"""


def lean_source():
    import proof_terms
    return proof_terms.lean_source()


def main():
    if not __debug__:
        raise SystemExit("Verification requires assertions; do not run Python with -O.")
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--build", action="store_true")
    mode.add_argument("--trim", action="store_true")
    mode.add_argument("--replay", action="store_true")
    mode.add_argument("--slice-core", action="store_true")
    mode.add_argument("--replay-core", action="store_true")
    mode.add_argument("--write-lean", action="store_true")
    mode.add_argument("--write-backend-test", action="store_true")
    parser.add_argument("--output", default="Main.lean")
    args = parser.parse_args()
    if args.build:
        build()
    elif args.trim:
        trim()
    elif args.replay:
        print(json.dumps(replay()))
    elif args.slice_core:
        slice_core()
    elif args.replay_core:
        print(json.dumps(replay_core()))
    elif args.write_backend_test:
        (ROOT / args.output).write_text(backend_test_source())
        print(f"Wrote {args.output}")
    else:
        (ROOT / args.output).write_text(lean_source())
        print(f"Wrote {args.output}")


if __name__ == "__main__":
    main()
