#!/usr/bin/env python3
"""Reconstruct the sliced RUP certificate as ordinary Lean proof terms."""

import argparse
import json
from pathlib import Path
import re

import formal

ROOT = Path(__file__).resolve().parent

HELPERS = """
noncomputable def model (a : Nat → Bool) : Bool := gates.all (evaluate a)

def disj (a : Nat → Bool) : CNF.Clause Nat → Prop
  | [] => False
  | (i, b) :: xs => a i = b ∨ disj a xs

theorem disj_correct (a : Nat → Bool) (xs : CNF.Clause Nat) :
    CNF.Clause.eval a xs = true ↔ disj a xs := by
  induction xs with
  | nil => simp [CNF.Clause.eval, disj]
  | cons x xs ih =>
      rcases x with ⟨i, b⟩
      cases hb : a i <;> cases b <;>
        simp_all [CNF.Clause.eval, disj, List.any]

theorem model_gate (a : Nat → Bool) (h : model a = true) (g : Gate)
    (hg : g ∈ gates) : evaluate a g = true :=
  List.all_eq_true.mp h g hg

theorem encoded_consequence (a : Nat → Bool) (g : Gate) (c : CNF.Clause Nat)
    (hc : c ∈ encode g) (hg : evaluate a g = true) : disj a c := by
  apply (disj_correct a c).mp
  exact List.all_eq_true.mp ((encode_correct a g).trans hg) c hc

theorem nonempty_member : Gate.nonempty (List.range 210) ∈ gates := by
  simp only [gates, List.mem_append]
  exact Or.inl (Or.inl (Or.inl (Or.inl (List.mem_singleton.mpr rfl))))

theorem down_member (r : List Nat) (i : Nat)
    (h : (r, i) ∈ incidenceRows.zipIdx) : downGate i r ∈ gates := by
  simp only [gates, List.mem_append]
  exact Or.inl (Or.inl (Or.inl (Or.inr (List.mem_map.mpr ⟨(r, i), h, rfl⟩))))

theorem parity_member (r : List Nat) (h : r ∈ incidenceRows) :
    parityGate r ∈ gates := by
  simp only [gates, List.mem_append]
  exact Or.inl (Or.inl (Or.inr (List.mem_map.mpr ⟨r, h, rfl⟩)))

theorem complement_member (r : List (Nat × Nat)) (i j k : Nat)
    (h : (r, i) ∈ complementRows.zipIdx) (hp : (j, k) ∈ r) :
    Gate.complement i (210 + j) (210 + k) ∈ gates := by
  simp only [gates, List.mem_append]
  exact Or.inl (Or.inr (List.mem_flatMap.mpr
    ⟨(r, i), h, List.mem_map.mpr ⟨(j, k), hp, rfl⟩⟩))

theorem two_member (r : List (List Nat)) (i : Nat) (xs : List Nat)
    (h : (r, i) ∈ pairRows.zipIdx) (hp : xs ∈ r) :
    twoGate i xs ∈ gates := by
  simp only [gates, List.mem_append]
  exact Or.inr (List.mem_flatMap.mpr
    ⟨(r, i), h, List.mem_map.mpr ⟨xs, hp, rfl⟩⟩)

theorem flip_false {b s : Bool} (h : b = s) : ¬ b = !s := by
  cases b <;> cases s <;> simp_all
"""


def clause_text(clause):
    return "[" + ",".join(f"({abs(x)-1},{'true' if x > 0 else 'false'})"
                           for x in clause) + "]"


def atom(lit):
    return f"(a {abs(lit)-1} = {'true' if lit > 0 else 'false'})"


def gate_text(gate):
    kind, *args = gate
    if kind == "nonempty":
        assert args == list(range(210))
        return "(Gate.nonempty (List.range 210))"
    return f"(Gate.{kind} {' '.join(map(str, args))})"


def conjunction(expressions):
    if len(expressions) == 1:
        return expressions[0], [""]
    mid = len(expressions) // 2
    left, lp = conjunction(expressions[:mid])
    right, rp = conjunction(expressions[mid:])
    return f"And ({left}) ({right})", [".1" + p for p in lp] + [".2" + p for p in rp]


def and_proof(expressions):
    if len(expressions) == 1:
        return expressions[0]
    mid = len(expressions) // 2
    return f"And.intro ({and_proof(expressions[:mid])}) ({and_proof(expressions[mid:])})"


def unit_helper(k, unit):
    name = f"unit_{k}_{unit}" if unit is not None else f"conflict_{k}"
    ps = [f"p{i}" for i in range(k)]
    disjunction = "False"
    for p in reversed(ps):
        disjunction = f"Or {p} ({disjunction})"
    parameters = " {" + " ".join(ps) + " : Prop}" if ps else ""
    negatives = "".join(f" (n{i} : ¬ p{i})" for i in range(k) if i != unit)
    conclusion = f"p{unit}" if unit is not None else "False"

    def eliminate(i, h):
        if i == k:
            return f"False.elim {h}" if unit is not None else h
        branch = "hp" if i == unit else (
            f"False.elim (n{i} hp)" if unit is not None else f"n{i} hp")
        return (f"Or.elim {h} (fun hp => {branch}) "
                f"(fun ht => {eliminate(i+1, 'ht')})")

    return (f"theorem {name}{parameters} (h : {disjunction}){negatives} : "
            f"{conclusion} :=\n  {eliminate(0, 'h')}\n")


def rup_sources(initial, lines=None):
    clauses = list(initial)
    helper_keys = set()
    sources = []
    if lines is None:
        lines = (ROOT / "core_refutation.lrat").read_text().splitlines()
    for line in lines:
        values = list(map(int, line.split()))
        end = values.index(0)
        ident, target, hints = values[0], values[1:end], values[end + 1:-1]
        assert ident == len(clauses) + 1 and values[-1] == 0
        body = [f"theorem step_{ident} (a : Nat → Bool) (h : Inputs a) : "
                f"disj a {clause_text(target)} :="]
        assigned = {}
        false_names = {}
        indent = "    " if target else "  "
        if target:
            body.append("  Classical.byContradiction fun hn =>")
        for j, lit in enumerate(target):
            proof = "hp"
            proof = f"Or.inl ({proof})"
            for _ in range(j):
                proof = f"Or.inr ({proof})"
            body.append(f"{indent}let s{j} : ¬ {atom(lit)} := (fun hp => hn ({proof}));")
            assigned[abs(lit)] = lit < 0
            false_names[abs(lit)] = f"s{j}"
        units = 0
        conflict = False
        for hint in hints:
            assert 0 < hint < ident
            c = clauses[hint - 1]
            if any(abs(x) in assigned and assigned[abs(x)] == (x > 0) for x in c):
                continue
            remaining = [j for j, x in enumerate(c) if abs(x) not in assigned]
            assert len(remaining) <= 1
            unit = remaining[0] if remaining else None
            helper_keys.add((len(c), unit))
            premise = (f"input_{hint-1} a h" if hint <= len(initial)
                       else f"step_{hint} a h")
            negatives = " ".join(false_names[abs(x)] for j, x in enumerate(c) if j != unit)
            helper = f"unit_{len(c)}_{unit}" if unit is not None else f"conflict_{len(c)}"
            propositions = " ".join(atom(x) for x in c)
            term = f"@{helper} {propositions} ({premise}) {negatives}".rstrip()
            if unit is None:
                body.append(f"{indent}{term}")
                conflict = True
                break
            lit = c[unit]
            body.append(f"{indent}let u{units} : {atom(lit)} := {term};")
            body.append(f"{indent}let f{units} : ¬ {atom(-lit)} := flip_false u{units};")
            assigned[abs(lit)] = lit > 0
            false_names[abs(lit)] = f"f{units}"
            units += 1
        assert conflict
        clauses.append(target)
        sources.append("\n".join(body))
    assert clauses[-1] == []
    helpers = "\n".join(unit_helper(k, u) for k, u in
                        sorted(helper_keys, key=lambda x: (x[0], -1 if x[1] is None else x[1])))
    return helpers, "\n\n".join(sources), len(clauses)


def lean_source(test=False):
    all_gates = formal.model_gates()
    origins = [(i, c, j) for i, g in enumerate(all_gates)
               for j, c in enumerate(formal.encode_gate(g))]
    indices = (sorted(set(range(64)) | {960, 961, 8640, 8641, 17040, 17041, 42240}) if test
               else json.loads((ROOT / "core_indices.json").read_text()))
    assert indices == sorted(set(indices))
    assert all(type(i) is int and 0 <= i < len(origins) for i in indices)
    initial = [origins[i][1] for i in indices]
    used_gates = sorted({origins[i][0] for i in indices})
    prefix = formal.checker_source().split("theorem gates_valid", 1)[0]
    prefix = prefix.replace("set_option maxHeartbeats 0",
                            "set_option maxHeartbeats 0\nset_option Elab.async false")
    if test:
        for name in ["facets_complete", "triangles_complete", "pairs_complete",
                     "incidenceRows_complete", "complementRows_complete", "pairRows_complete",
                     "row_shapes", "row_indices"]:
            prefix = re.sub(r"theorem " + name + r"\b.*?(?=\n\n)", "", prefix, flags=re.S)
    out = [prefix, HELPERS]
    tables = {name: data for name, _, data in formal.table_data()}
    incidence = tables["incidenceRows"]
    complement = tables["complementRows"]
    pairs = tables["pairRows"]
    inc_used = sorted({g-1 for g in used_gates if 1 <= g < 121} |
                      {g-121 for g in used_gates if 121 <= g < 241})
    comp_used = sorted({(g-241)//20 for g in used_gates if 241 <= g < 4441})
    pair_used = sorted({(g-4441)//15 for g in used_gates if g >= 4441})
    if test:
        inc_used = sorted(set(inc_used) | {119})
        comp_used = sorted(set(comp_used) | {209})
        pair_used = sorted(set(pair_used) | {209})
    for kind, used, data, original, typ in [
            ("ir", inc_used, incidence, "incidenceRows", "List Nat"),
            ("cr", comp_used, complement, "complementRows", "List (Nat × Nat)"),
            ("pr", pair_used, pairs, "pairRows", "List (List Nat)")]:
        for i in used:
            out.append(f"noncomputable def {kind}{i} : {typ} := {formal.lean_value(data[i])}")
            out.append(f"theorem {kind}{i}_mem : ({kind}{i}, {i}) ∈ {original}.zipIdx := "
                       "List.mk_mem_zipIdx_iff_getElem?.mpr (by decide +kernel)")
            if kind == "ir":
                out.append(f"theorem ir{i}_plain : ir{i} ∈ incidenceRows := "
                           f"List.fst_mem_of_mem_zipIdx ir{i}_mem")
    for gi in used_gates:
        g = all_gates[gi]
        kind, *args = g
        if kind == "nonempty":
            membership = "nonempty_member"
        elif kind == "down":
            i = gi-1
            membership = f"down_member ir{i} {i} ir{i}_mem"
        elif kind == "parity":
            i = gi-121
            membership = f"parity_member ir{i} ir{i}_plain"
        elif kind == "complement":
            i = (gi-241)//20
            membership = (f"complement_member cr{i} {i} {args[1]-210} {args[2]-210} "
                          f"cr{i}_mem (by decide +kernel)")
        else:
            assert kind == "two"
            i = (gi-4441)//15
            xs = "[" + ",".join(str(x-210) for x in args[1:]) + "]"
            membership = f"two_member pr{i} {i} {xs} pr{i}_mem (by decide +kernel)"
        out.append(f"theorem gate_{gi} (a : Nat → Bool) (h : model a = true) : "
                   f"evaluate a {gate_text(g)} = true :=\n"
                   f"  model_gate a h _ ({membership})")
    block_names = []
    input_paths = []
    for start in range(0, len(initial), 32):
        chunk = initial[start:start+32]
        name = f"ib{start//32}"
        block_names.append(name)
        formula, paths = conjunction([f"disj a {clause_text(c)}" for c in chunk])
        input_paths.extend(paths)
        out.append(f"noncomputable def {name} (a : Nat → Bool) : Prop := {formula}")
        leaves = []
        for j, c in enumerate(chunk):
            gi, _, position = origins[indices[start+j]]
            leaves.append(f"encoded_consequence a {gate_text(all_gates[gi])} "
                          f"{clause_text(c)} (List.mem_iff_getElem?.mpr "
                          f"⟨{position}, rfl⟩) (gate_{gi} a h)")
        out.append(f"theorem {name}_model (a : Nat → Bool) (h : model a = true) : "
                   f"{name} a :=\n  {and_proof(leaves)}")
    node_counter = 0

    def nodes(names):
        nonlocal node_counter
        if len(names) == 1:
            return names[0], [""]
        mid = len(names)//2
        left, lp = nodes(names[:mid])
        right, rp = nodes(names[mid:])
        name = f"inode{node_counter}"
        node_counter += 1
        out.append(f"noncomputable def {name} (a : Nat → Bool) : Prop := {left} a ∧ {right} a")
        return name, [".1"+p for p in lp] + [".2"+p for p in rp]

    root, block_paths = nodes(block_names)
    out.append(f"noncomputable def Inputs (a : Nat → Bool) : Prop := {root} a")
    out.append("theorem model_entails_inputs (a : Nat → Bool) (h : model a = true) : "
               f"Inputs a :=\n  {and_proof([name+'_model a h' for name in block_names])}")
    for i, c in enumerate(initial):
        path = block_paths[i//32] + input_paths[i]
        out.append(f"theorem input_{i} (a : Nat → Bool) (h : Inputs a) : "
                   f"disj a {clause_text(c)} := h{path}")
    if test:
        mini = [[1, 2], [-1], [-2]]
        helpers, steps, last = rup_sources(mini, [
            "4 1 2 0 1 0", "5 2 0 2 4 0", "6 0 5 3 0"])
        out += ["""
namespace Mini
def Inputs (a : Nat → Bool) : Prop :=
  disj a [(0,true),(1,true)] ∧ disj a [(0,false)] ∧ disj a [(1,false)]
theorem input_0 (a) (h : Inputs a) : disj a [(0,true),(1,true)] := h.1
theorem input_1 (a) (h : Inputs a) : disj a [(0,false)] := h.2.1
theorem input_2 (a) (h : Inputs a) : disj a [(1,false)] := h.2.2
""", helpers, steps, f"""
end Mini
end TenLabel
#print axioms TenLabel.model_entails_inputs
#print axioms TenLabel.Mini.step_{last}
"""]
    else:
        helpers, steps, last = rup_sources(initial)
        out += [helpers, steps, f"""
theorem core_unsat (a : Nat → Bool) : ¬ Inputs a := by
  intro h
  exact step_{last} a h

theorem no_nonempty_good_family (a : Nat → Bool) : model a = false := by
  cases hm : model a with
  | false => rfl
  | true => exact False.elim (core_unsat a (model_entails_inputs a hm))

theorem no_model : ¬ ∃ a : Nat → Bool, model a = true := by
  intro ⟨a, h⟩
  rw [no_nonempty_good_family] at h
  contradiction

end TenLabel
#print axioms TenLabel.core_unsat
#print axioms TenLabel.no_nonempty_good_family
"""]
    return "\n\n".join(out) + "\n"


def main():
    if not __debug__:
        raise SystemExit("Proof generation requires assertions; do not use Python -O.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--test", action="store_true")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.write_text(lean_source(args.test))


if __name__ == "__main__":
    main()
