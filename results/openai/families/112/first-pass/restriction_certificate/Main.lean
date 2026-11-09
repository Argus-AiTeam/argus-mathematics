import Mathlib

open scoped BigOperators
open Finset

namespace RestrictionCertificate

set_option linter.unusedSectionVars false
attribute [local instance] Classical.propDecidable

variable {V : Type*} [Fintype V] [DecidableEq V]

abbrev Assignment (V : Type*) := V → Bool
abbrev Restriction (V : Type*) := V → Option Bool

structure Clause (V : Type*) where
  scope : Finset V
  pattern : Assignment V

abbrev CNF (V : Type*) := List (Clause V)
abbrev Expansion (V : Type*) := List (ℝ × CNF V)

noncomputable def clauseValue (c : Clause V) (x : Assignment V) : ℝ :=
  if ∀ i ∈ c.scope, x i = c.pattern i then 0 else 1

noncomputable def cnfValue (H : CNF V) (x : Assignment V) : ℝ :=
  (H.map (fun c => clauseValue c x)).prod

def fill (r : Restriction V) (x : Assignment V) : Assignment V :=
  fun i => (r i).getD (x i)

def live (c : Clause V) (r : Restriction V) : Finset V :=
  c.scope.filter (fun i => r i = none)

def compatible (c : Clause V) (r : Restriction V) : Prop :=
  ∀ i ∈ c.scope, r i = none ∨ r i = some (c.pattern i)

def close (c : Clause V) (r : Restriction V) : Restriction V :=
  fun i => if i ∈ c.scope then some (c.pattern i) else r i

def reduced (c : Clause V) (r : Restriction V) : Clause V :=
  ⟨live c r, c.pattern⟩

def unit (i : V) (a : Bool) : Clause V :=
  ⟨{i}, fun _ => !a⟩

noncomputable def guard (c : Clause V) (r : Restriction V) : CNF V :=
  (live c r).toList.map (fun i => unit i (c.pattern i))

noncomputable def denote (E : Expansion V) (x : Assignment V) : ℝ :=
  (E.map (fun t => t.1 * cnfValue t.2 x)).sum

noncomputable def mass (E : Expansion V) : ℝ :=
  (E.map (fun t => |t.1|)).sum

def width (b : ℕ) (H : CNF V) : Prop :=
  ∀ c ∈ H, c.scope.card ≤ b

def expansionWidth (b : ℕ) (E : Expansion V) : Prop :=
  ∀ t ∈ E, width b t.2

def supported (r : Restriction V) (H : CNF V) : Prop :=
  ∀ c ∈ H, ∀ i ∈ c.scope, r i = none

noncomputable def restrictCNF (r : Restriction V) : CNF V → CNF V
  | [] => []
  | c :: H =>
    if compatible c r then reduced c r :: restrictCNF r H else restrictCNF r H

noncomputable def attach (A : CNF V) (E : Expansion V) : Expansion V :=
  E.map (fun t => (t.1, A ++ t.2))

noncomputable def negative (E : Expansion V) : Expansion V :=
  E.map (fun t => (-t.1, t.2))

noncomputable def expand (b : ℕ) : CNF V → Restriction V → Expansion V
  | [], _ => [(1, [])]
  | c :: H, r => by
    classical
    exact if ¬compatible c r then expand b H r
      else if live c r = ∅ then []
      else if (live c r).card ≤ b then attach [reduced c r] (expand b H r)
      else expand b H r ++ negative (attach (guard c r) (expand b H (close c r)))

@[simp] theorem cnfValue_nil (x : Assignment V) : cnfValue [] x = 1 := by
  simp [cnfValue]

@[simp] theorem cnfValue_cons (c : Clause V) (H : CNF V) (x : Assignment V) :
    cnfValue (c :: H) x = clauseValue c x * cnfValue H x := by
  simp [cnfValue]

@[simp] theorem cnfValue_append (H K : CNF V) (x : Assignment V) :
    cnfValue (H ++ K) x = cnfValue H x * cnfValue K x := by
  simp [cnfValue]

@[simp] theorem fill_fill (r : Restriction V) (x : Assignment V) :
    fill r (fill r x) = fill r x := by
  funext i
  cases h : r i <;> simp [fill, h]

theorem compatible_of_violation (c : Clause V) (r : Restriction V)
    (x : Assignment V) (h : ∀ i ∈ c.scope, fill r x i = c.pattern i) :
    compatible c r := by
  intro i hi
  cases hr : r i with
  | none => exact Or.inl rfl
  | some a =>
      right
      have ha := h i hi
      simp [fill, hr] at ha
      simp [ha]

theorem violation_reduced (c : Clause V) (r : Restriction V)
    (hc : compatible c r) (x : Assignment V) :
    (∀ i ∈ c.scope, fill r x i = c.pattern i) ↔
      ∀ i ∈ live c r, x i = c.pattern i := by
  constructor
  · intro h i hi
    obtain ⟨his, hir⟩ := Finset.mem_filter.mp hi
    simpa [fill, hir] using h i his
  · intro h i hi
    rcases hc i hi with hr | hr
    · have hx := h i (Finset.mem_filter.mpr ⟨hi, hr⟩)
      simpa [fill, hr] using hx
    · simp [fill, hr]

theorem clauseValue_incompatible (c : Clause V) (r : Restriction V)
    (h : ¬compatible c r) (x : Assignment V) :
    clauseValue c (fill r x) = 1 := by
  unfold clauseValue
  rw [if_neg]
  exact fun hv => h (compatible_of_violation c r x hv)

theorem clauseValue_reduced (c : Clause V) (r : Restriction V)
    (hc : compatible c r) (x : Assignment V) :
    clauseValue c (fill r x) = clauseValue (reduced c r) x := by
  simp only [clauseValue, reduced]
  simp only [violation_reduced c r hc x]
  rfl

theorem clauseValue_dead (c : Clause V) (r : Restriction V)
    (hc : compatible c r) (he : live c r = ∅) (x : Assignment V) :
    clauseValue c (fill r x) = 0 := by
  rw [clauseValue_reduced c r hc x]
  simp [clauseValue, reduced, he]

@[simp] theorem denote_nil (x : Assignment V) : denote [] x = 0 := by
  simp [denote]

@[simp] theorem denote_append (E F : Expansion V) (x : Assignment V) :
    denote (E ++ F) x = denote E x + denote F x := by
  simp [denote]

@[simp] theorem mass_nil : mass ([] : Expansion V) = 0 := by
  simp [mass]

@[simp] theorem mass_append (E F : Expansion V) :
    mass (E ++ F) = mass E + mass F := by
  simp [mass]

@[simp] theorem mass_attach (A : CNF V) (E : Expansion V) :
    mass (attach A E) = mass E := by
  simp [mass, attach, List.map_map, Function.comp_def]

@[simp] theorem mass_negative (E : Expansion V) : mass (negative E) = mass E := by
  simp [mass, negative, List.map_map, Function.comp_def]

theorem mass_nonneg (E : Expansion V) : 0 ≤ mass E := by
  unfold mass
  exact List.sum_nonneg (fun a ha => by
    obtain ⟨t, _, rfl⟩ := List.mem_map.mp ha
    exact abs_nonneg t.1)

@[simp] theorem denote_cons (t : ℝ × CNF V) (E : Expansion V) (x : Assignment V) :
    denote (t :: E) x = t.1 * cnfValue t.2 x + denote E x := by
  simp [denote]

@[simp] theorem mass_cons (t : ℝ × CNF V) (E : Expansion V) :
    mass (t :: E) = |t.1| + mass E := by
  simp [mass]

@[simp] theorem denote_attach (A : CNF V) (E : Expansion V) (x : Assignment V) :
    denote (attach A E) x = cnfValue A x * denote E x := by
  induction E with
  | nil => simp [attach]
  | cons t E ih =>
      simp only [attach, List.map_cons, denote_cons, cnfValue_append] at *
      rw [ih]
      ring

@[simp] theorem denote_negative (E : Expansion V) (x : Assignment V) :
    denote (negative E) x = -denote E x := by
  induction E with
  | nil => simp [negative]
  | cons t E ih =>
      simp only [negative, List.map_cons, denote_cons] at *
      rw [ih]
      ring

@[simp] theorem unit_value (i : V) (a : Bool) (x : Assignment V) :
    clauseValue (unit i a) x = if x i = a then 1 else 0 := by
  simp only [clauseValue, unit, Finset.mem_singleton, forall_eq]
  cases a <;> cases x i <;> simp

theorem guard_value (c : Clause V) (r : Restriction V) (x : Assignment V) :
    cnfValue (guard c r) x =
      if ∀ i ∈ live c r, x i = c.pattern i then 1 else 0 := by
  classical
  simp only [cnfValue, guard, List.map_map, Function.comp_def, unit_value]
  by_cases h : ∀ i ∈ live c r, x i = c.pattern i
  · rw [if_pos h]
    apply List.prod_eq_one
    intro a ha
    obtain ⟨i, hi, rfl⟩ := List.mem_map.mp ha
    rw [if_pos (h i (Finset.mem_toList.mp hi))]
  · rw [if_neg h]
    push Not at h
    obtain ⟨i, hi, hx⟩ := h
    apply List.prod_eq_zero
    exact List.mem_map.mpr ⟨i, Finset.mem_toList.mpr hi, if_neg hx⟩

theorem fill_close_of_violation (c : Clause V) (r : Restriction V)
    (x : Assignment V) (h : ∀ i ∈ c.scope, fill r x i = c.pattern i) :
    fill (close c r) x = fill r x := by
  funext i
  by_cases hi : i ∈ c.scope
  · simpa [fill, close, hi] using (h i hi).symm
  · simp [fill, close, hi]

theorem insertion_identity (c : Clause V) (H : CNF V) (r : Restriction V)
    (hc : compatible c r) (x : Assignment V) :
    cnfValue (c :: H) (fill r x) =
      cnfValue H (fill r x) -
        cnfValue (guard c r) x * cnfValue H (fill (close c r) x) := by
  classical
  rw [cnfValue_cons, guard_value]
  by_cases hv : ∀ i ∈ live c r, x i = c.pattern i
  · have hs := (violation_reduced c r hc x).mpr hv
    rw [if_pos hv, fill_close_of_violation c r x hs]
    have hcv : clauseValue c (fill r x) = 0 := if_pos hs
    rw [hcv]
    ring
  · have hs := mt (violation_reduced c r hc x).mp hv
    have hcv : clauseValue c (fill r x) = 1 := if_neg hs
    rw [hcv, if_neg hv]
    ring

theorem attach_width (b : ℕ) (A : CNF V) (E : Expansion V)
    (ha : width b A) (he : expansionWidth b E) :
    expansionWidth b (attach A E) := by
  intro t ht
  obtain ⟨u, hu, rfl⟩ := List.mem_map.mp ht
  intro c hc
  rcases List.mem_append.mp hc with hc | hc
  · exact ha c hc
  · exact he u hu c hc

theorem guard_width (b : ℕ) (hb : 1 ≤ b) (c : Clause V) (r : Restriction V) :
    width b (guard c r) := by
  intro e he
  obtain ⟨i, _, rfl⟩ := List.mem_map.mp he
  simpa [unit] using hb

theorem expand_width (b : ℕ) (hb : 1 ≤ b) (H : CNF V) (r : Restriction V) :
    expansionWidth b (expand b H r) := by
  classical
  induction H generalizing r with
  | nil => simp [expand, expansionWidth, width]
  | cons c H ih =>
      unfold expand
      split
      · exact ih r
      · split
        · simp [expansionWidth]
        · split
          · next h =>
              apply attach_width _ _ _ _ (ih r)
              intro e he
              have heq : e = reduced c r := by simpa using he
              simpa [heq, reduced] using h
          · intro t ht
            rcases List.mem_append.mp ht with ht | ht
            · exact ih r t ht
            · obtain ⟨u, hu, rfl⟩ := List.mem_map.mp ht
              exact attach_width b _ _ (guard_width b hb c r) (ih (close c r)) u hu

theorem expand_correct (b : ℕ) (H : CNF V) (r : Restriction V)
    (x : Assignment V) :
    denote (expand b H r) x = cnfValue H (fill r x) := by
  classical
  induction H generalizing r with
  | nil => simp [expand, denote]
  | cons c H ih =>
      by_cases hc : compatible c r
      · by_cases he : live c r = ∅
        · simp [expand, hc, he, clauseValue_dead c r hc he x]
        · by_cases hb : (live c r).card ≤ b
          · simp only [expand, hc, not_true_eq_false, ↓reduceIte,
              he, hb, denote_attach, cnfValue_cons, cnfValue_nil, mul_one]
            rw [ih, ← clauseValue_reduced c r hc x]
          · simp only [expand, hc, not_true_eq_false, ↓reduceIte, he, hb,
              denote_append, denote_negative, denote_attach, ih]
            exact (insertion_identity c H r hc x).symm
      · simp [expand, hc, ih, clauseValue_incompatible c r hc x]

theorem restrictCNF_value (r : Restriction V) (H : CNF V) (x : Assignment V) :
    cnfValue (restrictCNF r H) x = cnfValue H (fill r x) := by
  induction H with
  | nil => simp [restrictCNF]
  | cons c H ih =>
      by_cases hc : compatible c r
      · simp [restrictCNF, hc, ih, clauseValue_reduced c r hc x]
      · simp [restrictCNF, hc, ih, clauseValue_incompatible c r hc x]

theorem restrictCNF_width (r : Restriction V) (b : ℕ) (H : CNF V)
    (hw : width b H) : width b (restrictCNF r H) := by
  induction H with
  | nil => simp [restrictCNF, width]
  | cons c H ih =>
      have hh : width b H := fun e he => hw e (List.mem_cons_of_mem _ he)
      by_cases hc : compatible c r
      · simp only [restrictCNF, hc, ↓reduceIte]
        intro e he
        rcases List.mem_cons.mp he with he | he
        · subst e
          have hscope : (reduced c r).scope ⊆ c.scope := Finset.filter_subset _ _
          exact (Finset.card_le_card hscope).trans (hw c List.mem_cons_self)
        · exact ih hh e he
      · simpa only [restrictCNF, hc, ↓reduceIte] using ih hh

theorem restrictCNF_supported (r : Restriction V) (H : CNF V) :
    supported r (restrictCNF r H) := by
  induction H with
  | nil => simp [restrictCNF, supported]
  | cons c H ih =>
      by_cases hc : compatible c r
      · simp only [restrictCNF, hc, ↓reduceIte]
        intro e he i hi
        rcases List.mem_cons.mp he with he | he
        · subst e
          exact (Finset.mem_filter.mp hi).2
        · exact ih e he i hi
      · simpa only [restrictCNF, hc, ↓reduceIte] using ih

theorem supported_value (r : Restriction V) (H : CNF V)
    (hs : supported r H) (x : Assignment V) :
    cnfValue H (fill r x) = cnfValue H x := by
  induction H with
  | nil => simp
  | cons c H ih =>
      have he :
          (∀ i ∈ c.scope, fill r x i = c.pattern i) ↔
            ∀ i ∈ c.scope, x i = c.pattern i := by
        constructor <;> intro h i hi <;> simpa [fill, hs c List.mem_cons_self i hi] using h i hi
      have hcv : clauseValue c (fill r x) = clauseValue c x := by
        simp only [clauseValue, he]
      have hh : supported r H := fun e he i hi => hs e (List.mem_cons_of_mem _ he) i hi
      simp [hcv, ih hh]

def falseOn (c : Clause V) (r : Restriction V) : Prop :=
  ∀ i ∈ c.scope, r i = some (c.pattern i)

theorem live_subset (c : Clause V) (r : Restriction V) : live c r ⊆ c.scope :=
  Finset.filter_subset _ _

theorem falseOn_iff (c : Clause V) (r : Restriction V) :
    falseOn c r ↔ compatible c r ∧ live c r = ∅ := by
  constructor
  · intro h
    constructor
    · exact fun i hi => Or.inr (h i hi)
    · apply Finset.eq_empty_iff_forall_notMem.mpr
      intro i hi
      obtain ⟨his, hin⟩ := Finset.mem_filter.mp hi
      rw [h i his] at hin
      contradiction
  · rintro ⟨hc, he⟩ i hi
    rcases hc i hi with hr | hr
    · have hmem : i ∈ live c r := Finset.mem_filter.mpr ⟨hi, hr⟩
      simp [he] at hmem
    · exact hr

theorem close_eq_self (c : Clause V) (r : Restriction V) (h : falseOn c r) :
    close c r = r := by
  funext i
  by_cases hi : i ∈ c.scope
  · simp [close, hi, h i hi]
  · simp [close, hi]

noncomputable def switch (c : Clause V) (D : Finset V) :
    Restriction V ≃ Restriction V :=
  Equiv.piCongrRight (fun i =>
    if i ∈ D then Equiv.swap none (some (c.pattern i)) else Equiv.refl _)

theorem switch_mem (c : Clause V) (D : Finset V) (r : Restriction V)
    (i : V) (hi : i ∈ D) :
    switch c D r i = Equiv.swap none (some (c.pattern i)) (r i) := by
  simp [switch, hi, Equiv.piCongrRight]

theorem switch_not_mem (c : Clause V) (D : Finset V) (r : Restriction V)
    (i : V) (hi : i ∉ D) : switch c D r i = r i := by
  simp [switch, hi, Equiv.piCongrRight]

theorem event_switch (c : Clause V) (D : Finset V) (hd : D ⊆ c.scope)
    (r : Restriction V) :
    (compatible c (switch c D r) ∧ live c (switch c D r) = D) ↔ falseOn c r := by
  constructor
  · rintro ⟨hc, hl⟩ i hi
    by_cases hid : i ∈ D
    · have hm : i ∈ live c (switch c D r) := by
        rw [hl]
        exact hid
      have hpair : i ∈ c.scope ∧ switch c D r i = none := by
        simpa only [live, Finset.mem_filter] using hm
      have he := hpair.2
      rw [switch_mem c D r i hid] at he
      apply (Equiv.swap none (some (c.pattern i))).injective
      simpa using he
    · rcases hc i hi with hr | hr
      · have hm : i ∈ live c (switch c D r) := Finset.mem_filter.mpr ⟨hi, hr⟩
        exact False.elim (hid (hl ▸ hm))
      · simpa [switch_not_mem c D r i hid] using hr
  · intro hf
    constructor
    · intro i hi
      by_cases hid : i ∈ D
      · left
        rw [switch_mem c D r i hid, hf i hi, Equiv.swap_apply_right]
      · right
        rw [switch_not_mem c D r i hid, hf i hi]
    · apply Finset.ext
      intro i
      constructor
      · intro hi
        obtain ⟨his, hin⟩ := Finset.mem_filter.mp hi
        by_contra hid
        rw [switch_not_mem c D r i hid, hf i his] at hin
        contradiction
      · intro hid
        apply Finset.mem_filter.mpr
        refine ⟨hd hid, ?_⟩
        rw [switch_mem c D r i hid, hf i (hd hid), Equiv.swap_apply_right]

theorem close_switch (c : Clause V) (D : Finset V) (hd : D ⊆ c.scope)
    (r : Restriction V) (hf : falseOn c r) : close c (switch c D r) = r := by
  funext i
  by_cases hi : i ∈ c.scope
  · simp [close, hi, hf i hi]
  · have hid : i ∉ D := fun h => hi (hd h)
    simp [close, hi, switch_not_mem c D r i hid]

noncomputable def stateWeight (p q : ℝ) (s : Option Bool) : ℝ :=
  if s = none then p else q

noncomputable def weight (p q : ℝ) (r : Restriction V) : ℝ :=
  ∏ i, stateWeight p q (r i)

theorem weight_nonneg (p q : ℝ) (hp : 0 ≤ p) (hq : 0 ≤ q) (r : Restriction V) :
    0 ≤ weight p q r := by
  apply Finset.prod_nonneg
  intro i _
  unfold stateWeight
  split <;> assumption

theorem weight_switch (p q α : ℝ) (hp : p = α * q)
    (c : Clause V) (D : Finset V) (hd : D ⊆ c.scope)
    (r : Restriction V) (hf : falseOn c r) :
    weight p q (switch c D r) = α ^ D.card * weight p q r := by
  calc
    weight p q (switch c D r) =
        ∏ i, (if i ∈ D then α else 1) * stateWeight p q (r i) := by
      apply Finset.prod_congr rfl
      intro i _
      by_cases hi : i ∈ D
      · rw [switch_mem c D r i hi, hf i (hd hi), Equiv.swap_apply_right]
        simp [stateWeight, hi, hp]
      · rw [switch_not_mem c D r i hi]
        simp [hi]
    _ = (∏ i : V, if i ∈ D then α else 1) * weight p q r := by
      rw [Finset.prod_mul_distrib]
      rfl
    _ = α ^ D.card * weight p q r := by
      simp [Finset.prod_ite_mem]

noncomputable def falsePart (c : Clause V) (f : Restriction V → ℝ)
    (r : Restriction V) : ℝ :=
  if falseOn c r then f r else 0

noncomputable def fiberPart (c : Clause V) (D : Finset V)
    (f : Restriction V → ℝ) (r : Restriction V) : ℝ :=
  if compatible c r ∧ live c r = D then f (close c r) else 0

noncomputable def hardPart (c : Clause V) (b : ℕ)
    (f : Restriction V → ℝ) (r : Restriction V) : ℝ :=
  if compatible c r ∧ b < (live c r).card then f (close c r) else 0

noncomputable def subsetTail (S : Finset V) (b : ℕ) (α : ℝ) : ℝ :=
  ∑ D ∈ S.powerset, if b < D.card then α ^ D.card else 0

theorem fiber_reweight (p q α : ℝ) (hp : p = α * q)
    (c : Clause V) (D : Finset V) (hd : D ⊆ c.scope)
    (f : Restriction V → ℝ) :
    (∑ r, weight p q r * fiberPart c D f r) =
      α ^ D.card * ∑ r, weight p q r * falsePart c f r := by
  rw [← (switch c D).sum_comp (fun r => weight p q r * fiberPart c D f r)]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro r _
  by_cases hf : falseOn c r
  · rw [weight_switch p q α hp c D hd r hf]
    simp only [fiberPart, falsePart, event_switch c D hd r, hf, ↓reduceIte,
      close_switch c D hd r hf]
    ring
  · simp [fiberPart, falsePart, event_switch c D hd r, hf]

theorem hard_fibers (c : Clause V) (b : ℕ) (f : Restriction V → ℝ)
    (r : Restriction V) :
    hardPart c b f r =
      ∑ D ∈ c.scope.powerset, if b < D.card then fiberPart c D f r else 0 := by
  unfold hardPart fiberPart
  by_cases hc : compatible c r
  · simp only [hc, true_and]
    symm
    calc
      (∑ D ∈ c.scope.powerset,
          if b < D.card then (if live c r = D then f (close c r) else 0) else 0) =
          ∑ D ∈ c.scope.powerset,
            if live c r = D then (if b < D.card then f (close c r) else 0) else 0 := by
        apply Finset.sum_congr rfl
        intro D _
        split_ifs <;> rfl
      _ = if b < (live c r).card then f (close c r) else 0 := by
        rw [Finset.sum_ite_eq]
        simp [Finset.mem_powerset.mpr (live_subset c r)]
  · simp [hc]

theorem hard_reweight (p q α : ℝ) (hp : p = α * q)
    (c : Clause V) (b : ℕ) (f : Restriction V → ℝ) :
    (∑ r, weight p q r * hardPart c b f r) =
      subsetTail c.scope b α * ∑ r, weight p q r * falsePart c f r := by
  conv_lhs => simp only [hard_fibers, Finset.mul_sum]
  rw [Finset.sum_comm]
  calc
    (∑ D ∈ c.scope.powerset,
        ∑ r, weight p q r * (if b < D.card then fiberPart c D f r else 0)) =
        ∑ D ∈ c.scope.powerset,
          (if b < D.card then
            α ^ D.card * ∑ r, weight p q r * falsePart c f r else 0) := by
      apply Finset.sum_congr rfl
      intro D hd
      by_cases hb : b < D.card
      · simp only [hb, ↓reduceIte]
        exact fiber_reweight p q α hp c D (Finset.mem_powerset.mp hd) f
      · simp [hb]
    _ = subsetTail c.scope b α * ∑ r, weight p q r * falsePart c f r := by
      rw [subsetTail, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro D _
      split_ifs <;> simp

theorem mass_step (b : ℕ) (c : Clause V) (H : CNF V) (r : Restriction V) :
    mass (expand b (c :: H) r) =
      mass (expand b H r) - falsePart c (fun s => mass (expand b H s)) r +
        hardPart c b (fun s => mass (expand b H s)) r := by
  unfold falsePart hardPart
  rw [falseOn_iff]
  by_cases hc : compatible c r
  · by_cases he : live c r = ∅
    · simp [expand, hc, he]
    · by_cases hb : (live c r).card ≤ b
      · simp [expand, hc, he, hb, not_lt_of_ge hb]
      · simp [expand, hc, he, hb, Nat.lt_of_not_ge hb]
  · simp [expand, hc]

theorem expected_mass_step (p q α : ℝ) (hp : p = α * q)
    (c : Clause V) (H : CNF V) (b : ℕ) :
    (∑ r, weight p q r * mass (expand b (c :: H) r)) =
      (∑ r, weight p q r * mass (expand b H r)) +
        (subsetTail c.scope b α - 1) *
          ∑ r, weight p q r * falsePart c (fun s => mass (expand b H s)) r := by
  simp_rw [mass_step, mul_add, mul_sub]
  rw [Finset.sum_add_distrib, Finset.sum_sub_distrib,
    hard_reweight p q α hp c b]
  ring

theorem sum_weight (p q : ℝ) (hn : p + 2 * q = 1) :
    ∑ r : Restriction V, weight p q r = 1 := by
  unfold weight
  rw [← Fintype.prod_sum]
  have hs : (∑ s : Option Bool, stateWeight p q s) = 1 := by
    simp [Fintype.sum_option, stateWeight]
    linarith
  simp [hs]

theorem expected_mass_le_one (H : CNF V) (b : ℕ) (p q α : ℝ)
    (hp : 0 ≤ p) (hq : 0 ≤ q) (hn : p + 2 * q = 1) (hr : p = α * q)
    (ht : ∀ c ∈ H, subsetTail c.scope b α ≤ 1) :
    (∑ r, weight p q r * mass (expand b H r)) ≤ 1 := by
  induction H with
  | nil => simpa [expand, mass] using le_of_eq (sum_weight (V := V) p q hn)
  | cons c H ih =>
      rw [expected_mass_step p q α hr c H b]
      have htail := ht c List.mem_cons_self
      have hprefix := ih (fun e he => ht e (List.mem_cons_of_mem _ he))
      have hfalse :
          0 ≤ ∑ r, weight p q r * falsePart c (fun s => mass (expand b H s)) r := by
        apply Finset.sum_nonneg
        intro r _
        apply mul_nonneg (weight_nonneg p q hp hq r)
        unfold falsePart
        split
        · exact mass_nonneg _
        · rfl
      have hdecrease := mul_nonpos_of_nonpos_of_nonneg (sub_nonpos.mpr htail) hfalse
      linarith

noncomputable def theta (k b : ℕ) (α : ℝ) : ℝ :=
  ∑ j ∈ Finset.range (k + 1), if b < j then (k.choose j : ℝ) * α ^ j else 0

theorem theta_eq_Icc (k b : ℕ) (α : ℝ) :
    theta k b α = ∑ j ∈ Finset.Icc (b + 1) k, (k.choose j : ℝ) * α ^ j := by
  unfold theta
  rw [← Finset.sum_filter]
  apply Finset.sum_congr
  · ext j
    simp only [Finset.mem_filter, Finset.mem_range, Finset.mem_Icc]
    omega
  · intro j _
    rfl

theorem subsetTail_eq_binomial (S : Finset V) (b : ℕ) (α : ℝ) :
    subsetTail S b α = theta S.card b α := by
  unfold subsetTail theta
  rw [Finset.sum_powerset]
  apply Finset.sum_congr rfl
  intro j _
  calc
    (∑ D ∈ Finset.powersetCard j S, if b < D.card then α ^ D.card else 0) =
        ∑ _D ∈ Finset.powersetCard j S, if b < j then α ^ j else 0 := by
      apply Finset.sum_congr rfl
      intro D hd
      rw [(Finset.mem_powersetCard.mp hd).2]
    _ = if b < j then (S.card.choose j : ℝ) * α ^ j else 0 := by
      by_cases hj : b < j <;> simp [hj, Finset.card_powersetCard, nsmul_eq_mul]

theorem theta_nonneg (k b : ℕ) (α : ℝ) (ha : 0 ≤ α) : 0 ≤ theta k b α := by
  apply Finset.sum_nonneg
  intro j _
  split
  · positivity
  · rfl

theorem subsetTail_le_theta (S : Finset V) (b k : ℕ) (α : ℝ)
    (ha : 0 ≤ α) (hk : S.card ≤ k) :
    subsetTail S b α ≤ theta k b α := by
  rw [subsetTail_eq_binomial]
  unfold theta
  calc
    (∑ j ∈ Finset.range (S.card + 1),
        if b < j then (S.card.choose j : ℝ) * α ^ j else 0) ≤
        ∑ j ∈ Finset.range (S.card + 1),
          if b < j then (k.choose j : ℝ) * α ^ j else 0 := by
      apply Finset.sum_le_sum
      intro j _
      split
      · apply mul_le_mul_of_nonneg_right _ (pow_nonneg ha _)
        exact_mod_cast Nat.choose_le_choose j hk
      · rfl
    _ ≤ ∑ j ∈ Finset.range (k + 1),
        if b < j then (k.choose j : ℝ) * α ^ j else 0 := by
      apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.range_mono (Nat.add_le_add_right hk 1))
      intro j _ _
      split
      · positivity
      · rfl

theorem theta_zero_of_le (k b : ℕ) (α : ℝ) (hk : k ≤ b) : theta k b α = 0 := by
  apply Finset.sum_eq_zero
  intro j hj
  have hn : ¬b < j := by
    have := Finset.mem_range.mp hj
    omega
  simp [hn]

theorem expected_mass_uniform (H : CNF V) (b k : ℕ) (p : ℝ)
    (hw : width k H) (hp : 0 < p) (hp1 : p < 1)
    (ht : theta k b (2 * p / (1 - p)) ≤ 1) :
    (∑ r, weight p ((1 - p) / 2) r * mass (expand b H r)) ≤ 1 := by
  have hq : 0 < (1 - p) / 2 := by linarith
  have ha : 0 ≤ 2 * p / (1 - p) := by positivity
  have hr : p = (2 * p / (1 - p)) * ((1 - p) / 2) := by
    field_simp [ne_of_gt (sub_pos.mpr hp1)]
  apply expected_mass_le_one H b p ((1 - p) / 2) (2 * p / (1 - p))
    (le_of_lt hp) (le_of_lt hq) (by ring) hr
  intro c hc
  exact (subsetTail_le_theta c.scope b k _ ha (hw c hc)).trans ht

theorem clauseValue_zero_or_one (c : Clause V) (x : Assignment V) :
    clauseValue c x = 0 ∨ clauseValue c x = 1 := by
  unfold clauseValue
  split <;> simp

theorem cnfValue_zero_or_one (H : CNF V) (x : Assignment V) :
    cnfValue H x = 0 ∨ cnfValue H x = 1 := by
  induction H with
  | nil => simp
  | cons c H ih =>
      rw [cnfValue_cons]
      rcases clauseValue_zero_or_one c x with hc | hc <;>
        rcases ih with hh | hh <;> simp [hc, hh]

noncomputable def average (f : Assignment V → ℝ) : ℝ :=
  (Fintype.card (Assignment V) : ℝ)⁻¹ * ∑ x, f x

theorem average_live (r : Restriction V)
    (g : ({i : V // r i = none} → Bool) → ℝ) :
    average (fun x => g (fun i => x i.val)) =
      (Fintype.card ({i : V // r i = none} → Bool) : ℝ)⁻¹ * ∑ z, g z := by
  let e := Equiv.piEquivPiSubtypeProd (fun i => r i = none) (fun _ : V => Bool)
  have hs :
      (∑ x : Assignment V, g (fun i => x i.val)) =
        (Fintype.card ({i : V // ¬r i = none} → Bool) : ℝ) * ∑ z, g z := by
    calc
      (∑ x : Assignment V, g (fun i => x i.val)) =
          ∑ z : ({i : V // r i = none} → Bool) ×
            ({i : V // ¬r i = none} → Bool), g z.1 :=
          e.sum_comp (fun z => g z.1)
      _ = _ := by
        simp [Fintype.sum_prod_type, nsmul_eq_mul, Finset.mul_sum]
  have hc :
      (Fintype.card (Assignment V) : ℝ) =
        (Fintype.card ({i : V // r i = none} → Bool) : ℝ) *
          (Fintype.card ({i : V // ¬r i = none} → Bool) : ℝ) := by
    exact_mod_cast (Fintype.card_congr e).trans (Fintype.card_prod _ _)
  have hl : (Fintype.card ({i : V // r i = none} → Bool) : ℝ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  have hf : (Fintype.card ({i : V // ¬r i = none} → Bool) : ℝ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  unfold average
  rw [hs, hc]
  field_simp

@[simp] theorem average_zero : average (fun _ : Assignment V => (0 : ℝ)) = 0 := by
  simp [average]

theorem average_add (f g : Assignment V → ℝ) :
    average (fun x => f x + g x) = average f + average g := by
  simp [average, Finset.sum_add_distrib, mul_add]

theorem average_scale (a : ℝ) (f : Assignment V → ℝ) :
    average (fun x => a * f x) = a * average f := by
  simp [average, Finset.mul_sum, mul_assoc, mul_comm]

noncomputable def testCorrelation (r : Restriction V) (G : Assignment V → ℝ)
    (H : CNF V) : ℝ :=
  average (fun x => G (fill r x) * cnfValue H (fill r x))

noncomputable def truth (H : CNF V) : Assignment V → Bool :=
  fun x => decide (cnfValue H x = 1)

theorem truth_value (H : CNF V) (x : Assignment V) :
    (if truth H x then (1 : ℝ) else 0) = cnfValue H x := by
  rcases cnfValue_zero_or_one H x with h | h <;> simp [truth, h]

noncomputable def tests (b : ℕ) (r : Restriction V) : Finset (Assignment V → Bool) :=
  Finset.univ.filter (fun f => ∃ H : CNF V, width b H ∧ supported r H ∧ truth H = f)

theorem truth_mem_tests (b : ℕ) (r : Restriction V) (H : CNF V)
    (hw : width b H) (hs : supported r H) : truth H ∈ tests b r := by
  simp only [tests, Finset.mem_filter, Finset.mem_univ, true_and]
  exact ⟨H, hw, hs, rfl⟩

theorem tests_nonempty (b : ℕ) (r : Restriction V) : (tests b r).Nonempty :=
  ⟨truth [], truth_mem_tests b r [] (by simp [width]) (by simp [supported])⟩

noncomputable def corr (b : ℕ) (r : Restriction V) (G : Assignment V → ℝ) : ℝ :=
  (tests b r).sup' (tests_nonempty b r)
    (fun f => |average (fun x => G (fill r x) * (if f (fill r x) then 1 else 0))|)

theorem testCorrelation_le_corr (b : ℕ) (r : Restriction V)
    (G : Assignment V → ℝ) (H : CNF V) (hw : width b H) :
    |testCorrelation r G H| ≤ corr b r G := by
  unfold corr
  have h := Finset.le_sup'
    (fun f : Assignment V → Bool =>
      |average (fun x => G (fill r x) * (if f (fill r x) then 1 else 0))|)
    (truth_mem_tests b r (restrictCNF r H) (restrictCNF_width r b H hw)
      (restrictCNF_supported r H))
  simpa only [truth_value, restrictCNF_value, fill_fill, testCorrelation] using h

theorem corr_nonneg (b : ℕ) (r : Restriction V) (G : Assignment V → ℝ) :
    0 ≤ corr b r G :=
  (abs_nonneg (testCorrelation r G [])).trans
    (testCorrelation_le_corr b r G [] (by simp [width]))

theorem expansion_correlation (b : ℕ) (r : Restriction V)
    (G : Assignment V → ℝ) (E : Expansion V) (B : ℝ)
    (hw : expansionWidth b E)
    (hb : ∀ H : CNF V, width b H → |testCorrelation r G H| ≤ B) :
    |average (fun x => G (fill r x) * denote E (fill r x))| ≤ mass E * B := by
  induction E with
  | nil => simp [denote, mass]
  | cons t E ih =>
      have he : expansionWidth b E := fun u hu => hw u (List.mem_cons_of_mem _ hu)
      have ht : width b t.2 := hw t List.mem_cons_self
      have hind := ih he
      have hf :
          (fun x => G (fill r x) * denote (t :: E) (fill r x)) =
            (fun x => t.1 * (G (fill r x) * cnfValue t.2 (fill r x)) +
              G (fill r x) * denote E (fill r x)) := by
        funext x
        rw [denote_cons]
        ring
      rw [hf, average_add, average_scale, mass_cons]
      change |t.1 * testCorrelation r G t.2 +
          average (fun x => G (fill r x) * denote E (fill r x))| ≤
        (|t.1| + mass E) * B
      calc
        _ ≤ |t.1 * testCorrelation r G t.2| +
            |average (fun x => G (fill r x) * denote E (fill r x))| := abs_add_le _ _
        _ ≤ |t.1| * B + mass E * B := by
          apply add_le_add _ hind
          rw [abs_mul]
          exact mul_le_mul_of_nonneg_left (hb t.2 ht) (abs_nonneg t.1)
        _ = _ := by ring

theorem restriction_correlation (b : ℕ) (hb : 1 ≤ b) (H : CNF V)
    (r : Restriction V) (G : Assignment V → ℝ) :
    |testCorrelation r G H| ≤ mass (expand b H r) * corr b r G := by
  have h := expansion_correlation b r G (expand b H r) (corr b r G)
    (expand_width b hb H r) (fun J hj => testCorrelation_le_corr b r G J hj)
  simpa only [expand_correct, fill_fill, testCorrelation] using h

theorem independent_restriction (H : CNF V) (b k : ℕ) (p : ℝ)
    (hb : 1 ≤ b) (hw : width k H) (hp : 0 < p) (hp1 : p < 1)
    (ht : theta k b (2 * p / (1 - p)) ≤ 1) :
    (∀ r, expansionWidth b (expand b H r) ∧
      (∀ x, denote (expand b H r) x = cnfValue H (fill r x)) ∧
      0 ≤ mass (expand b H r)) ∧
    (∑ r, weight p ((1 - p) / 2) r * mass (expand b H r)) ≤ 1 ∧
    (∀ r G, |testCorrelation r G H| ≤ mass (expand b H r) * corr b r G) := by
  refine ⟨?_, expected_mass_uniform H b k p hw hp hp1 ht, ?_⟩
  · intro r
    exact ⟨expand_width b hb H r, expand_correct b H r, mass_nonneg _⟩
  · exact fun r G => restriction_correlation b hb H r G

theorem manuscript_corollary (H : CNF V) (b k : ℕ) (p : ℝ)
    (hb : 1 ≤ b) (hw : width k H) (hp : 0 < p) (hp1 : p < 1)
    (ht : theta k b (2 * p / (1 - p)) < 1) :
    ∃ W : Restriction V → ℝ,
      (∀ r, 0 ≤ W r) ∧
      (∑ r, weight p ((1 - p) / 2) r * W r) ≤
        1 / (1 - theta k b (2 * p / (1 - p))) ∧
      ∀ r G, |testCorrelation r G H| ≤ W r * corr b r G := by
  refine ⟨fun r => mass (expand b H r), fun r => mass_nonneg _, ?_, ?_⟩
  · apply (expected_mass_uniform H b k p hw hp hp1 (le_of_lt ht)).trans
    have hn := theta_nonneg k b (2 * p / (1 - p)) (by positivity)
    apply (le_div_iff₀ (sub_pos.mpr ht)).mpr
    linarith
  · exact fun r G => restriction_correlation b hb H r G

#print axioms independent_restriction
#print axioms manuscript_corollary

end RestrictionCertificate
