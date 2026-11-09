import Mathlib

theorem ite_eq_left {α : Sort*} {p : Prop} [Decidable p] {x y : α} (h : p) :
    (if p then x else y) = x := if_pos h

theorem ite_eq_right {α : Sort*} {p : Prop} [Decidable p] {x y : α} (h : ¬ p) :
    (if p then x else y) = y := if_neg h

theorem dite_eq_left {α : Sort*} {p : Prop} [Decidable p]
    {x : p → α} {y : ¬ p → α} (h : p) :
    (if h : p then x h else y h) = x h := dif_pos h

theorem dite_eq_right {α : Sort*} {p : Prop} [Decidable p]
    {x : p → α} {y : ¬ p → α} (h : ¬ p) :
    (if h : p then x h else y h) = y h := dif_neg h

theorem Set.mem_ofPred_eq {α : Type*} {p : α → Prop} {a : α} :
    a ∈ {x | p x} ↔ p a := Iff.rfl

theorem List.Nodup.getD_inj {α : Type*} {l : List α} {i j : ℕ} {fallback : α}
    (hi : i < l.length) (hj : j < l.length) (h : l.Nodup) :
    l.getD i fallback = l.getD j fallback ↔ i = j :=
  List.getD_inj hi hj h

theorem List.Nodup.head_eq_getLast_iff {α : Type*} {l : List α}
    (hne : l ≠ []) (hnd : l.Nodup) :
    l.head hne = l.getLast hne ↔ ∃ a, l = [a] := by
  cases l with
  | nil => contradiction
  | cons a l =>
    cases l with
    | nil => simp
    | cons b l =>
      constructor
      · intro he
        have hnot := (List.nodup_cons.mp hnd).1
        have hm := List.getLast_mem (show b :: l ≠ [] by simp)
        simp only [List.head_cons, List.getLast_cons_cons] at he
        rw [← he] at hm
        exact False.elim (hnot hm)
      · rintro ⟨c, hc⟩
        simp at hc

namespace SimpleGraph.Walk

attribute [simp] support_mapLe_eq_support

theorem IsPath.map {V W : Type*} {G : SimpleGraph V} {H : SimpleGraph W}
    {u v : V} {p : G.Walk u v} (hp : p.IsPath) {f : G →g H}
    (hf : Function.Injective f) : (p.map f).IsPath :=
  map_isPath_of_injective hf hp

@[simp] theorem length_tail {V : Type*} {G : SimpleGraph V} {u v : V}
    (p : G.Walk u v) : p.tail.length = p.length - 1 := by
  cases p <;> simp

@[simp] theorem length_mapLe {V : Type*} {G H : SimpleGraph V} (h : G ≤ H)
    {u v : V} (p : G.Walk u v) : (p.mapLe h).length = p.length :=
  length_map _ _

theorem getVert_append' {V : Type*} {G : SimpleGraph V} {u v w : V}
    (p : G.Walk u v) (q : G.Walk v w) (i : ℕ) :
    (p.append q).getVert i =
      if i ≤ p.length then p.getVert i else q.getVert (i - p.length) := by
  rw [getVert_append]
  by_cases hi : i < p.length
  · simp [hi, hi.le]
  · by_cases he : i = p.length
    · subst i
      simp
    · have hnot : ¬ i ≤ p.length := by omega
      simp [hi, hnot]

end SimpleGraph.Walk

namespace SimpleGraph

open scoped SimpleGraph
open Walk

-- Backport of Mathlib CycleGraph.lean at d13f23b, Apache-2.0.
theorem cycleGraph_isContained_iff {V : Type*} {G : SimpleGraph V}
    {n : ℕ} (hn : 2 < n) :
    cycleGraph n ⊑ G ↔ ∃ (v : V) (p : G.Walk v v), p.IsCycle ∧ p.length = n := by
  have hn' : n - 3 + 3 = n := by omega
  refine ⟨fun ⟨h⟩ ↦
    ⟨_, _, cycleGraph.isCycle_cycle.map (hn' ▸ h).injective, by simp [hn']⟩, ?_⟩
  intro ⟨a, p, hp₁, hp₂⟩
  refine ⟨⟨fun i ↦ p.support[i.succ]'(by grind [not_nil_iff_lt_length]), ?_⟩, ?_⟩
  · intro ⟨x, hx⟩ ⟨y, hy⟩ hab
    wlog hle : x > y
    · have hne : x ≠ y := by simpa using hab.ne
      exact this hn hn' a p hp₁ hp₂ y hy x hx hab.symm (by omega) |>.symm
    rcases cycleGraph_adj'.mp hab with hab | hab
    · simp_rw [show x = y + 1 by grind [Fin.sub_val_of_le]]
      exact p.isChain_adj_support.getElem _ _ |>.symm
    · rw [Fin.coe_sub_iff_lt.mpr hle] at hab
      simp only [Fin.val_mk] at hab
      simp_rw [show x = n - 1 by omega, show y = 0 by omega, Fin.succ_mk,
        show n - 1 + 1 = n by omega]
      simp [← hp₂, hp₁.not_nil]
  · have hlen : p.tail.support.length = n := by
      rw [length_support, length_tail_add_one hp₁.not_nil, hp₂]
    have (i : Fin n) : p.support[i.succ]'(by grind) = p.tail.support[i] := by
      simp [support_tail_of_not_nil p hp₁.not_nil]
    simp_rw [this]
    exact hlen ▸ (isPath_iff_injective_get_support _).mp hp₁.isPath_tail

end SimpleGraph

#print axioms SimpleGraph.cycleGraph_isContained_iff
#print axioms List.Nodup.head_eq_getLast_iff
#print axioms SimpleGraph.Walk.getVert_append'
