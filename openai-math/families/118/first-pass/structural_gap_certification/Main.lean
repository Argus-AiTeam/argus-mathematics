import Mathlib

/-!
Self-contained localization for C118_STRUCTURAL_GAP on Lean 4.31.0.
All 44 OAI domain files in the StructuralGap import closure are included below,
in dependency order, with no imported OAI theorem or domain axiom.
Each named section restores file-local scope; original namespaces are retained.
See localization_provenance.json and STATEMENT_FIDELITY.md for the source map.
-/

set_option maxHeartbeats 4000000

/- Lean 4.34 conditional/set names, proved here using the Lean 4.31 API. -/
theorem ite_eq_left.{u} {p : Prop} {inst : Decidable p} {α : Sort u} {a b : α}
    (hp : p) : @ite α p inst a b = a := @if_pos p inst hp α a b

theorem ite_eq_right.{u} {p : Prop} {inst : Decidable p} {α : Sort u} {a b : α}
    (hp : ¬ p) : @ite α p inst a b = b := @if_neg p inst hp α a b

theorem dite_eq_left.{u} {p : Prop} {inst : Decidable p} {α : Sort u}
    {a : p → α} {b : ¬ p → α} (hp : p) :
    @dite α p inst a b = a hp := @dif_pos p inst hp α a b

theorem dite_eq_right.{u} {p : Prop} {inst : Decidable p} {α : Sort u}
    {a : p → α} {b : ¬ p → α} (hp : ¬ p) :
    @dite α p inst a b = b hp := @dif_neg p inst hp α a b

theorem Set.ofPred_forall.{u, v} {α : Type u} {ι : Sort v} (p : ι → α → Prop) :
    {x | ∀ i, p i x} = ⋂ i, {x | p i x} := Set.setOf_forall p

@[simp] theorem Lean431Compat.card_filter_sigma_fst
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {α : ι → Type*} [∀ i, Fintype (α i)] (v : ι) :
    (Finset.univ.filter (fun x : Sigma α => x.1 = v)).card = Fintype.card (α v) := by
  classical
  let e : {x : Sigma α // x.1 = v} ≃ α v :=
    { toFun := fun x => x.property ▸ x.val.2
      invFun := fun a => ⟨⟨v, a⟩, rfl⟩
      left_inv := by rintro ⟨⟨i, a⟩, h⟩; cases h; rfl
      right_inv := fun _ => rfl }
  exact (Fintype.card_subtype _).symm.trans (Fintype.card_congr e)

/- BEGIN LOCALIZED SOURCE 01/44: OAI/Computability/BinPacking/Packing/FiniteHall.lean
   SHA256: 6f80f6430bc72e510a6a0373ed6d83ba599ffb629b23879193099adbeffd5779 -/
section LocalizedSource01
/-
This file has been adapted from an external source.
The source copyright header and license information are preserved below.
-/

/-
Copyright (c) 2021 Alena Gusakov, Bhavik Mehta, Kyle Miller. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Alena Gusakov, Bhavik Mehta, Kyle Miller

This file is adapted from Mathlib.Combinatorics.Hall.Finite.
Source: https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/Combinatorics/Hall/Finite.lean

This code has been modified.
-/

-- localized import: Mathlib.Data.Fintype.Basic
-- localized import: Mathlib.Data.Fintype.Powerset
-- localized import: Mathlib.Data.Set.Finite.Basic

namespace OAI

open Finset

namespace BinPackingGap.FiniteHall

universe u v

namespace HallMarriageTheorem

variable {ι : Type u} {α : Type v} [DecidableEq α] {t : ι → Finset α}

section Fintype

variable [Fintype ι]

theorem hall_cond_of_erase {x : ι} (a : α)
    (ha : ∀ s : Finset ι, s.Nonempty → s ≠ univ → #s < #(s.biUnion t))
    (s' : Finset { x' : ι | x' ≠ x }) : #s' ≤ #(s'.biUnion fun x' => (t x').erase a) := by
  have := Classical.decEq ι
  specialize ha (s'.image fun z => z.1)
  rw [image_nonempty, Finset.card_image_of_injective s' Subtype.coe_injective] at ha
  by_cases! he : s'.Nonempty
  · have ha' : #s' < #(s'.biUnion fun x => t x) := by
      convert! ha he fun h => by simpa [← h] using mem_univ x using 2
      ext x
      simp only [mem_image, mem_biUnion, SetCoe.exists, exists_and_right,
        exists_eq_right]
    rw [← erase_biUnion]
    by_cases hb : a ∈ s'.biUnion fun x => t x
    · rw [card_erase_of_mem hb]
      exact Nat.le_sub_one_of_lt ha'
    · rw [erase_eq_of_notMem hb]
      exact Nat.le_of_lt ha'
  · subst s'
    exact Nat.zero_le _

theorem hall_hard_inductive_step_A {n : ℕ} (hn : Fintype.card ι = n + 1)
    (ht : ∀ s : Finset ι, #s ≤ #(s.biUnion t))
    (ih :
      ∀ {ι' : Type u} [Fintype ι'] (t' : ι' → Finset α),
        Fintype.card ι' ≤ n →
          (∀ s' : Finset ι', #s' ≤ #(s'.biUnion t')) →
            ∃ f : ι' → α, Function.Injective f ∧ ∀ x, f x ∈ t' x)
    (ha : ∀ s : Finset ι, s.Nonempty → s ≠ univ → #s < #(s.biUnion t)) :
    ∃ f : ι → α, Function.Injective f ∧ ∀ x, f x ∈ t x := by
  have : Nonempty ι := Fintype.card_pos_iff.mp (hn.symm ▸ Nat.succ_pos _)
  have := Classical.decEq ι

  let x := Classical.arbitrary ι
  have tx_ne : (t x).Nonempty := by
    rw [← Finset.card_pos]
    calc
      0 < 1 := Nat.one_pos
      _ ≤ #(.biUnion {x} t) := ht {x}
      _ = (t x).card := by rw [Finset.singleton_biUnion]
  choose y hy using tx_ne

  let ι' := { x' : ι | x' ≠ x }
  let t' : ι' → Finset α := fun x' => (t x').erase y
  have card_ι' : Fintype.card ι' = n :=
    calc
      Fintype.card ι' = Fintype.card ι - 1 := Set.card_ne_eq _
      _ = n := by rw [hn, Nat.add_succ_sub_one, add_zero]
  rcases ih t' card_ι'.le (hall_cond_of_erase y ha) with ⟨f', hfinj, hfr⟩

  refine ⟨fun z => if h : z = x then y else f' ⟨z, h⟩, ?_, ?_⟩
  · rintro z₁ z₂
    have key : ∀ {x}, y ≠ f' x := by
      intro x h
      simpa [t', ← h] using hfr x
    by_cases h₁ : z₁ = x <;> by_cases h₂ : z₂ = x <;>
      simp [h₁, h₂, hfinj.eq_iff, key, key.symm]
  · intro z
    simp only
    split_ifs with hz
    · rwa [hz]
    · specialize hfr ⟨z, hz⟩
      rw [mem_erase] at hfr
      exact hfr.2

theorem hall_cond_of_restrict {ι : Type u} {t : ι → Finset α} {s : Finset ι}
    (ht : ∀ s : Finset ι, #s ≤ #(s.biUnion t)) (s' : Finset (s : Set ι)) :
    #s' ≤ #(s'.biUnion fun a' => t a') := by
  classical
    rw [← card_image_of_injective s' Subtype.coe_injective]
    convert! ht (s'.image fun z => z.1) using 1
    apply congr_arg
    ext y
    simp

theorem hall_cond_of_compl {ι : Type u} {t : ι → Finset α} {s : Finset ι}
    (hus : #s = #(s.biUnion t)) (ht : ∀ s : Finset ι, #s ≤ #(s.biUnion t))
    (s' : Finset (sᶜ : Set ι)) : #s' ≤ #(s'.biUnion fun x' => t x' \ s.biUnion t) := by
  have := Classical.decEq ι
  have disj : Disjoint s (s'.image fun z => z.1) := by
    simp only [disjoint_left, not_exists, mem_image, SetCoe.exists, exists_and_right,
      exists_eq_right]
    intro x hx hc _
    exact absurd hx hc
  have : #s' = #(s ∪ s'.image fun z => z.1) - #s := by
    simp [disj, card_image_of_injective _ Subtype.coe_injective, Nat.add_sub_cancel_left]
  rw [this, hus]
  refine (Nat.sub_le_sub_right (ht _) _).trans ?_
  rw [← card_sdiff_of_subset]
  · gcongr
    intro t
    simp only [mem_biUnion, mem_sdiff, not_exists, mem_image, and_imp, mem_union,
      exists_imp]
    rintro x (hx | ⟨x', hx', rfl⟩) rat hs
    · exact False.elim <| (hs x) <| And.intro hx rat
    · use x', hx', rat, hs
  · apply biUnion_subset_biUnion_of_subset_left
    apply subset_union_left

theorem hall_hard_inductive_step_B {n : ℕ} (hn : Fintype.card ι = n + 1)
    (ht : ∀ s : Finset ι, #s ≤ #(s.biUnion t))
    (ih :
      ∀ {ι' : Type u} [Fintype ι'] (t' : ι' → Finset α),
        Fintype.card ι' ≤ n →
          (∀ s' : Finset ι', #s' ≤ #(s'.biUnion t')) →
            ∃ f : ι' → α, Function.Injective f ∧ ∀ x, f x ∈ t' x)
    (s : Finset ι) (hs : s.Nonempty) (hns : s ≠ univ) (hus : #s = #(s.biUnion t)) :
    ∃ f : ι → α, Function.Injective f ∧ ∀ x, f x ∈ t x := by
  have := Classical.decEq ι

  rw [Nat.add_one] at hn
  have card_ι'_le : Fintype.card s ≤ n := by
    apply Nat.le_of_lt_succ
    calc
      Fintype.card s = #s := Fintype.card_coe _
      _ < Fintype.card ι := (card_lt_iff_ne_univ _).mpr hns
      _ = n.succ := hn
  let t' : s → Finset α := fun x' => t x'
  rcases ih t' card_ι'_le (hall_cond_of_restrict ht) with ⟨f', hf', hsf'⟩

  set ι'' := (s : Set ι)ᶜ
  let t'' : ι'' → Finset α := fun a'' => t a'' \ s.biUnion t
  have card_ι''_le : Fintype.card ι'' ≤ n := by
    simp_rw [ι'', ← Nat.lt_succ_iff, ← hn, ← Finset.coe_compl, coe_sort_coe]
    rwa [Fintype.card_coe, card_compl_lt_iff_nonempty]
  rcases ih t'' card_ι''_le (hall_cond_of_compl hus ht) with ⟨f'', hf'', hsf''⟩

  have f''_notMem_biUnion : ∀ (x'') (hx'' : x'' ∉ s), f'' ⟨x'', hx''⟩ ∉ s.biUnion t := by
    intro x'' hx''
    have h := hsf'' ⟨x'', hx''⟩
    rw [mem_sdiff] at h
    exact h.2
  have im_disj :
      ∀ (x' x'' : ι) (hx' : x' ∈ s) (hx'' : x'' ∉ s), f' ⟨x', hx'⟩ ≠ f'' ⟨x'', hx''⟩ := by
    grind
  refine ⟨fun x => if h : x ∈ s then f' ⟨x, h⟩ else f'' ⟨x, h⟩, ?_, ?_⟩
  · refine hf'.dite _ hf'' (@fun x x' => im_disj x x' _ _)
  · intro x
    simp only
    split_ifs with h
    · exact hsf' ⟨x, h⟩
    · exact sdiff_subset (hsf'' ⟨x, h⟩)

end Fintype

variable [Finite ι]

theorem hall_hard_inductive (ht : ∀ s : Finset ι, #s ≤ #(s.biUnion t)) :
    ∃ f : ι → α, Function.Injective f ∧ ∀ x, f x ∈ t x := by
  cases nonempty_fintype ι
  generalize hn : Fintype.card ι = m
  induction m using Nat.strongRecOn generalizing ι with | ind n ih => _
  rcases n with (_ | n)
  · rw [Fintype.card_eq_zero_iff] at hn
    exact ⟨isEmptyElim, isEmptyElim, isEmptyElim⟩
  · have ih' : ∀ (ι' : Type u) [Fintype ι'] (t' : ι' → Finset α), Fintype.card ι' ≤ n →
        (∀ s' : Finset ι', #s' ≤ #(s'.biUnion t')) →
        ∃ f : ι' → α, Function.Injective f ∧ ∀ x, f x ∈ t' x := by
      intro ι' _ _ hι' ht'
      exact ih _ (Nat.lt_succ_of_le hι') ht' _ rfl
    by_cases! h : ∀ s : Finset ι, s.Nonempty → s ≠ univ → #s < #(s.biUnion t)
    · refine hall_hard_inductive_step_A hn ht (@fun ι' => ih' ι') h
    · rcases h with ⟨s, sne, snu, sle⟩
      exact hall_hard_inductive_step_B hn ht (@fun ι' => ih' ι')
        s sne snu (Nat.le_antisymm (ht _) sle)

end HallMarriageTheorem

theorem all_card_le_biUnion_card_iff_existsInjective {ι α : Type*} [Finite ι]
    [DecidableEq α] (t : ι → Finset α) :
    (∀ s : Finset ι, #s ≤ #(s.biUnion t)) ↔
      ∃ f : ι → α, Function.Injective f ∧ ∀ x, f x ∈ t x := by
  constructor
  · exact HallMarriageTheorem.hall_hard_inductive
  · rintro ⟨f, hf₁, hf₂⟩ s
    rw [← card_image_of_injective s hf₁]
    apply card_le_card
    intro
    rw [mem_image, mem_biUnion]
    rintro ⟨x, hx, rfl⟩
    exact ⟨x, hx, hf₂ x⟩

end BinPackingGap.FiniteHall

end OAI
end LocalizedSource01
/- END LOCALIZED SOURCE 01/44: OAI/Computability/BinPacking/Packing/FiniteHall.lean -/

/- BEGIN LOCALIZED SOURCE 02/44: OAI/Computability/BinPacking/Model.lean
   SHA256: de4560e0b8821a1c34c438b35bef17252c6e95534549e91aaf1f830f65550127 -/
section LocalizedSource02
-- localized import: Mathlib

namespace OAI

noncomputable section

namespace BinPackingGames.Foundations.Complexity

def encodeWord (n : Nat) : List Bool := List.replicate n true ++ [false]

end BinPackingGames.Foundations.Complexity

namespace BinPackingGames.Foundations.Complexity.MachineFiniteAlphabet

open Turing

def FiniteAlphabet (M : FinTM2) : Prop := ∀ k, Finite (M.Γ k)

end BinPackingGames.Foundations.Complexity.MachineFiniteAlphabet

namespace BinPackingGames.Foundations.Complexity.CookLevin

def pairBits (input : List Bool × List Bool) : List Bool :=
  encodeWord input.1.length ++ input.1 ++ input.2

structure NPVerifier where
  witnessBound : Polynomial Nat
  verify : (List Bool × List Bool) → Bool
  computation : Turing.TM2ComputableInPolyTime pairBits (fun bit => [bit]) verify
  finiteAlphabet : (k : computation.tm.K) → Fintype (computation.tm.Γ k)

def NPVerifier.Accepts (verifier : NPVerifier) (input : List Bool) : Prop :=
  ∃ witness : List Bool,
    witness.length ≤ verifier.witnessBound.eval input.length ∧
    verifier.verify (input, witness) = true

def InNP (language : List Bool → Prop) : Prop :=
  ∃ verifier : NPVerifier, ∀ input, language input ↔ verifier.Accepts input

end BinPackingGames.Foundations.Complexity.CookLevin

namespace BinPackingCompleteness.BinaryEncoding

def bitsValue : List Bool → Nat
  | [] => 0
  | b :: bits => Nat.bit b (bitsValue bits)

def frame : List Bool → List Bool
  | [] => [false]
  | b :: bits => true :: b :: frame bits

def parseFrame : List Bool → Option (List Bool × List Bool)
  | false :: rest => some ([], rest)
  | true :: b :: rest => do
      let (bits, trailing) ← parseFrame rest
      return (b :: bits, trailing)
  | _ => none

def nameBits (name : Nat) : List Bool := frame name.bits

def parseName (input : List Bool) : Option (Nat × List Bool) := do
  let (digits, rest) ← parseFrame input
  let name := bitsValue digits
  if digits = name.bits then some (name, rest) else none

end BinPackingCompleteness.BinaryEncoding

namespace BinPackingGap

open scoped BigOperators

structure Instance where
  n : ℕ
  size : Fin n → ℚ
  size_pos : ∀ i, 0 < size i
  size_le_one : ∀ i, size i ≤ 1

namespace Instance

abbrev Item (I : Instance) := Fin I.n

end Instance

structure Packing (I : Instance) (b : ℕ) where
  assignment : I.Item → Fin b
  capacity : ∀ j, (∑ i, if assignment i = j then I.size i else 0) ≤ 1

def HasPacking (I : Instance) (b : ℕ) : Prop := Nonempty (Packing I b)

def singletonPacking (I : Instance) : Packing I I.n where
  assignment i := i
  capacity j := by
    have hsum : (∑ i, if i = j then I.size i else 0) = I.size j := by
      calc
        (∑ i, if i = j then I.size i else 0) =
            (if j = j then I.size j else 0) :=
          Finset.sum_eq_single j (fun i _ hij => ite_eq_right hij)
            (fun h => False.elim (h (Finset.mem_univ _)))
        _ = I.size j := ite_eq_left rfl
    rw [hsum]
    exact I.size_le_one j

theorem exists_packing (I : Instance) : ∃ b, HasPacking I b :=
  ⟨I.n, ⟨singletonPacking I⟩⟩

noncomputable def opt (I : Instance) : ℕ := by
  classical
  exact Nat.find (exists_packing I)

def IndividualConfiguration (I : Instance) :=
  {H : Finset I.Item // ∑ i ∈ H, I.size i ≤ 1}

noncomputable instance (I : Instance) : Fintype (IndividualConfiguration I) :=
  inferInstanceAs (Fintype {H : Finset I.Item // ∑ i ∈ H, I.size i ≤ 1})

def NumericalSize (I : Instance) := ↥(Finset.univ.image I.size)

instance (I : Instance) : Fintype (NumericalSize I) :=
  inferInstanceAs (Fintype ↥(Finset.univ.image I.size))

namespace NumericalSize

variable {I : Instance}

theorem positive (s : NumericalSize I) : 0 < s.val := by
  obtain ⟨i, _, hi⟩ := Finset.mem_image.mp s.property
  rw [← hi]
  exact I.size_pos i

def multiplicity (s : NumericalSize I) : ℕ :=
  (Finset.univ.filter fun i : I.Item => I.size i = s.val).card

def capacityBound (s : NumericalSize I) : ℕ :=
  Classical.choose (exists_nat_gt (1 / s.val))

theorem capacityBound_spec (s : NumericalSize I) : 1 / s.val < (s.capacityBound : ℚ) :=
  Classical.choose_spec (exists_nat_gt (1 / s.val))

end NumericalSize

def TypeConfiguration (I : Instance) :=
  {c : NumericalSize I → ℕ // ∑ s, s.val * (c s : ℚ) ≤ 1}

namespace TypeConfiguration

variable {I : Instance}

theorem count_lt_bound (c : TypeConfiguration I) (s : NumericalSize I) :
    c.val s < s.capacityBound := by
  have hterm : s.val * (c.val s : ℚ) ≤ ∑ t, t.val * (c.val t : ℚ) := by
    exact Finset.single_le_sum (fun t _ => mul_nonneg (le_of_lt t.positive) (Nat.cast_nonneg _))
      (Finset.mem_univ s)
  have hquot : (c.val s : ℚ) ≤ 1 / s.val := by
    apply (le_div_iff₀ s.positive).mpr
    simpa [mul_comm] using hterm.trans c.property
  have hlt := hquot.trans_lt s.capacityBound_spec
  exact_mod_cast hlt

def boundedCounts (c : TypeConfiguration I) : ∀ s : NumericalSize I, Fin s.capacityBound :=
  fun s => ⟨c.val s, c.count_lt_bound s⟩

theorem boundedCounts_injective :
    Function.Injective
      (boundedCounts : TypeConfiguration I → ∀ s : NumericalSize I, Fin s.capacityBound) := by
  intro c d h
  apply Subtype.ext
  funext s
  exact congrArg Fin.val (congrFun h s)

instance : Finite (TypeConfiguration I) := by
  classical
  exact Finite.of_injective boundedCounts boundedCounts_injective

instance : Fintype (TypeConfiguration I) := Fintype.ofFinite _

end TypeConfiguration

namespace FractionalCover

open Set
variable {I C : Type*} [Fintype I] [Fintype C]

def Feasible (a : C → I → ℝ) (d : I → ℝ) (w : C → ℝ) : Prop :=
  (∀ c, 0 ≤ w c) ∧ ∀ i, d i ≤ ∑ c, a c i * w c

def objective (w : C → ℝ) : ℝ := ∑ c, w c

def objectiveSet (a : C → I → ℝ) (d : I → ℝ) : Set ℝ :=
  {v | ∃ w, Feasible a d w ∧ objective w = v}

def value (a : C → I → ℝ) (d : I → ℝ) : ℝ :=
  sInf (objectiveSet a d)

end FractionalCover

def individualMatrix (I : Instance) (H : IndividualConfiguration I) (i : I.Item) : ℝ :=
  if i ∈ H.val then 1 else 0

def individualLP (I : Instance) : ℝ :=
  FractionalCover.value (individualMatrix I) (fun _ => 1)

def typeMatrix (I : Instance) (c : TypeConfiguration I) (s : NumericalSize I) : ℝ :=
  c.val s

def typeLP (I : Instance) : ℝ :=
  FractionalCover.value (typeMatrix I) (fun s => (s.multiplicity : ℝ))

abbrev RawInstance := List (ℕ × ℕ)

abbrev RawReductionOutput := ℕ × RawInstance

namespace RawInstance

def Valid (r : RawInstance) : Prop :=
  ∀ q ∈ r, 0 < q.1 ∧ q.1 ≤ q.2

def ratValue (q : ℕ × ℕ) : ℚ := (q.1 : ℚ) / (q.2 : ℚ)

theorem den_pos {r : RawInstance} (hr : r.Valid) {q : ℕ × ℕ} (hq : q ∈ r) :
    0 < q.2 := lt_of_lt_of_le (hr q hq).1 (hr q hq).2

def toInstance (r : RawInstance) (hr : r.Valid) : Instance where
  n := r.length
  size i := ratValue (r.get i)
  size_pos i := div_pos (Nat.cast_pos.mpr (hr _ (List.get_mem r i)).1)
    (Nat.cast_pos.mpr (den_pos hr (List.get_mem r i)))
  size_le_one i := (div_le_one₀ (Nat.cast_pos.mpr (den_pos hr (List.get_mem r i)))).mpr
    (Nat.cast_le.mpr (hr _ (List.get_mem r i)).2)

end RawInstance

structure RawPacking where
  bins : ℕ
  assignments : List ℕ

namespace RawPacking

def load (r : RawInstance) (a : List ℕ) (j : ℕ) : ℚ :=
  ((r.zip a).map fun qa =>
    if qa.2 = j then RawInstance.ratValue qa.1 else 0).sum

def Feasible (r : RawInstance) (p : RawPacking) : Prop :=
  p.assignments.length = r.length ∧
  (∀ j ∈ p.assignments, j < p.bins) ∧
  ∀ j < p.bins, load r p.assignments j ≤ 1

end RawPacking

namespace BinaryEncoding

abbrev natBits := BinPackingCompleteness.BinaryEncoding.nameBits

abbrev parseNat := BinPackingCompleteness.BinaryEncoding.parseName

def listBits {α : Type} (encode : α → List Bool) : List α → List Bool
  | [] => [false]
  | a :: rest => true :: (encode a ++ listBits encode rest)

def pairBits {α β : Type} (ea : α → List Bool) (eb : β → List Bool)
    (p : α × β) : List Bool := ea p.1 ++ eb p.2

def optionBits {α : Type} (encode : α → List Bool) : Option α → List Bool
  | none => [false]
  | some a => true :: encode a

abbrev Parser (α : Type) := List Bool → Option (α × List Bool)

def parsePair {α β : Type} (pa : Parser α) (pb : Parser β) : Parser (α × β) :=
  fun input => do
    let (a, rest) ← pa input
    let (b, suffix) ← pb rest
    return ((a, b), suffix)

def parseListAux {α : Type} (parse : Parser α) : Nat → Parser (List α)
  | 0, _ => none
  | _ + 1, [] => none
  | _ + 1, false :: rest => some ([], rest)
  | fuel + 1, true :: rest => do
    let (a, rest) ← parse rest
    let (as, suffix) ← parseListAux parse fuel rest
    return (a :: as, suffix)

def parseList {α : Type} (parse : Parser α) : Parser (List α) :=
  fun input => parseListAux parse input.length input

def decode {α : Type} (parse : Parser α) (input : List Bool) : Option α := do
  let (a, rest) ← parse input
  if rest.isEmpty then some a else none

def rawInstanceBits (r : RawInstance) : List Bool :=
  listBits (pairBits natBits natBits) r

def assignmentBits (a : List Nat) : List Bool := listBits natBits a

def rawPackingBits (p : RawPacking) : List Bool :=
  natBits p.bins ++ assignmentBits p.assignments

def packingResultBits (p : Option RawPacking) : List Bool := optionBits rawPackingBits p

def rawReductionOutputBits (out : RawReductionOutput) : List Bool :=
  natBits out.1 ++ rawInstanceBits out.2

def parseRawInstance : Parser RawInstance := parseList (parsePair parseNat parseNat)

def decodeRawInstance := decode parseRawInstance

end BinaryEncoding

open Turing BinPackingGames.Foundations.Complexity

abbrev BitLanguage := List Bool → Prop

def InP (L : BitLanguage) : Prop :=
  ∃ decider : List Bool → Bool,
  ∃ computation : TM2ComputableInPolyTime
      (id : List Bool → List Bool) (fun b => [b]) decider,
    MachineFiniteAlphabet.FiniteAlphabet computation.tm ∧
    ∀ x, L x ↔ decider x = true

def ClassP : Set BitLanguage := {L | InP L}

def ClassNP : Set BitLanguage := {L | CookLevin.InNP L}

def PEqualsNP : Prop := ClassP = ClassNP

structure AbsoluteAdditiveAlgorithm (c : Nat) where
  run : List Bool → Option RawPacking
  computation : TM2ComputableInPolyTime (id : List Bool → List Bool)
    BinaryEncoding.packingResultBits run
  finiteAlphabet : MachineFiniteAlphabet.FiniteAlphabet computation.tm
  guarantee : ∀ (r : RawInstance) (hr : r.Valid), ∃ p : RawPacking,
    run (BinaryEncoding.rawInstanceBits r) = some p ∧
    RawPacking.Feasible r p ∧ p.bins ≤ opt (r.toInstance hr) + c

structure PackingGapReduction (c : Nat) (L : BitLanguage) where
  reduce : List Bool → RawReductionOutput
  computation : TM2ComputableInPolyTime (id : List Bool → List Bool)
    BinaryEncoding.rawReductionOutputBits reduce
  finiteAlphabet : MachineFiniteAlphabet.FiniteAlphabet computation.tm
  valid : ∀ x, (reduce x).2.Valid
  itemCount : ∀ x, (reduce x).2.length = 5 * (reduce x).1
  itemLower : ∀ x i,
    (1 / 6 : ℚ) < ((reduce x).2.toInstance (valid x)).size i
  completeness : ∀ x, L x →
    HasPacking ((reduce x).2.toInstance (valid x)) (reduce x).1
  soundness : ∀ x, ¬L x →
    ¬HasPacking ((reduce x).2.toInstance (valid x)) ((reduce x).1 + c)

def PackingGapNPHard (c : Nat) : Prop :=
  ∀ L : BitLanguage, CookLevin.InNP L → Nonempty (PackingGapReduction c L)

end BinPackingGap

end

end OAI
end LocalizedSource02
/- END LOCALIZED SOURCE 02/44: OAI/Computability/BinPacking/Model.lean -/

/- BEGIN LOCALIZED SOURCE 03/44: OAI/Computability/BinPacking/Packing/FractionWidth.lean
   SHA256: c239e25387ff3297964983e93a249151ec749c4713ef7db0c1a0192018987e39 -/
section LocalizedSource03
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.BigOperators.Fin
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Data.Fintype.Fin
-- localized import: Mathlib.Data.Fintype.Powerset
-- localized import: Mathlib.Data.List.OfFn
-- localized import: Mathlib.Data.Nat.Find
-- localized import: Mathlib.Data.Nat.Size
-- localized import: Mathlib.Data.Rat.Cast.Order
-- localized import: Mathlib.Tactic.FieldSimp
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.NormNum
-- localized import: Mathlib.Tactic.Ring
-- localized import: OAI.Computability.BinPacking.Model

namespace OAI

namespace BinPackingGap

open scoped BigOperators

namespace Instance

noncomputable def ofFintype {ι : Type*} [Fintype ι]
    (s : ι → ℚ) (hpos : ∀ i, 0 < s i) (hle : ∀ i, s i ≤ 1) : Instance where
  n := Fintype.card ι
  size i := s ((Fintype.equivFin ι).symm i)
  size_pos _ := hpos _
  size_le_one _ := hle _

end Instance

namespace Packing

variable {I : Instance} {b : ℕ}

def binItems (p : Packing I b) (j : Fin b) : Finset I.Item :=
  Finset.univ.filter fun i => p.assignment i = j

@[simp] theorem mem_binItems (p : Packing I b) (j : Fin b) (i : I.Item) :
    i ∈ p.binItems j ↔ p.assignment i = j := by
  simp [binItems]

theorem bin_capacity (p : Packing I b) (j : Fin b) :
    ∑ i ∈ p.binItems j, I.size i ≤ 1 := by
  simpa [binItems, Finset.sum_filter] using p.capacity j

theorem binItems_disjoint (p : Packing I b) {j k : Fin b} (h : j ≠ k) :
    Disjoint (p.binItems j) (p.binItems k) := by
  refine Finset.disjoint_left.mpr ?_
  intro i hi hj
  have hji := (p.mem_binItems j i).mp hi
  have hki := (p.mem_binItems k i).mp hj
  exact h (hji.symm.trans hki)

theorem mem_own_bin (p : Packing I b) (i : I.Item) :
    i ∈ p.binItems (p.assignment i) := by simp

theorem unique_bin (p : Packing I b) (i : I.Item) :
    ∃! j, i ∈ p.binItems j := by
  refine ⟨p.assignment i, p.mem_own_bin i, ?_⟩
  intro j hj
  exact ((p.mem_binItems j i).mp hj).symm

theorem chosen_injective (p : Packing I b) {J : Type*}
    (bin : J → Fin b) (hbin : Function.Injective bin)
    (chosen : J → I.Item) (hchosen : ∀ j, chosen j ∈ p.binItems (bin j)) :
    Function.Injective chosen := by
  intro j k hjk
  apply hbin
  have hj := (p.mem_binItems (bin j) (chosen j)).mp (hchosen j)
  have hk := (p.mem_binItems (bin k) (chosen k)).mp (hchosen k)
  rw [hjk] at hj
  exact hj.symm.trans hk

theorem sum_bins (p : Packing I b) {M : Type*} [AddCommMonoid M]
    (f : I.Item → M) :
    ∑ j, ∑ i ∈ p.binItems j, f i = ∑ i, f i := by
  simp only [binItems, Finset.sum_filter]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  calc
    (∑ j, if p.assignment i = j then f i else 0) =
        (if p.assignment i = p.assignment i then f i else 0) :=
      Finset.sum_eq_single (p.assignment i)
        (fun j _ hj => ite_eq_right (Ne.symm hj))
        (fun h => False.elim (h (Finset.mem_univ _)))
    _ = f i := ite_eq_left rfl

theorem sum_bin_card (p : Packing I b) :
    ∑ j, (p.binItems j).card = I.n := by
  simpa using p.sum_bins (fun _ => (1 : ℕ))

def enlarge (p : Packing I b) {c : ℕ} (hbc : b ≤ c) : Packing I c where
  assignment i := Fin.castLE hbc (p.assignment i)
  capacity j := by
    by_cases hj : j.val < b
    · let k : Fin b := ⟨j.val, hj⟩
      have heq : ∀ i, Fin.castLE hbc (p.assignment i) = j ↔ p.assignment i = k := by
        intro i
        simp [Fin.ext_iff, k]
      simpa only [heq] using p.capacity k
    · have heq : ∀ i, Fin.castLE hbc (p.assignment i) ≠ j := by
        intro i h
        have hv := congrArg Fin.val h
        have hi := (p.assignment i).isLt
        exact hj (hv ▸ hi)
      simp [heq]

end Packing

theorem opt_attained (I : Instance) : HasPacking I (opt I) := by
  classical
  exact Nat.find_spec (exists_packing I)

theorem opt_le_of_hasPacking {I : Instance} {b : ℕ} (h : HasPacking I b) :
    opt I ≤ b := by
  classical
  exact Nat.find_min' (exists_packing I) h

theorem opt_le_n (I : Instance) : opt I ≤ I.n :=
  opt_le_of_hasPacking ⟨singletonPacking I⟩

theorem opt_eq_zero_of_n_eq_zero (I : Instance) (h : I.n = 0) : opt I = 0 := by
  have := opt_le_n I
  omega

theorem HasPacking.mono {I : Instance} {b c : ℕ} (h : HasPacking I b) (hbc : b ≤ c) :
    HasPacking I c := by
  obtain ⟨p⟩ := h
  exact ⟨p.enlarge hbc⟩

theorem hasPacking_iff_opt_le (I : Instance) (b : ℕ) :
    HasPacking I b ↔ opt I ≤ b :=
  ⟨opt_le_of_hasPacking, fun h => (opt_attained I).mono h⟩

theorem not_hasPacking_iff_lt_opt (I : Instance) (b : ℕ) :
    ¬ HasPacking I b ↔ b < opt I := by
  rw [hasPacking_iff_opt_le, Nat.not_le]

noncomputable def packingOfFintype {ι : Type*} [Fintype ι]
    (s : ι → ℚ) (hpos : ∀ i, 0 < s i) (hle : ∀ i, s i ≤ 1)
    {b : ℕ} (a : ι → Fin b)
    (hcap : ∀ j, (∑ i, if a i = j then s i else 0) ≤ 1) :
    Packing (Instance.ofFintype s hpos hle) b where
  assignment i := a ((Fintype.equivFin ι).symm i)
  capacity j := by
    change (∑ i : Fin (Fintype.card ι),
      if a ((Fintype.equivFin ι).symm i) = j
      then s ((Fintype.equivFin ι).symm i) else 0) ≤ 1
    rw [(Fintype.equivFin ι).symm.sum_comp
      (fun i : ι => if a i = j then s i else 0)]
    exact hcap j

namespace IndividualConfiguration

variable {I : Instance}

def singleton (i : I.Item) : IndividualConfiguration I :=
  ⟨{i}, by simpa using I.size_le_one i⟩

theorem card_le_five (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i)
    (H : IndividualConfiguration I) : H.val.card ≤ 5 := by
  by_contra h
  have hcard : 6 ≤ H.val.card := by omega
  have hne : H.val.Nonempty := Finset.card_pos.mp (by omega)
  have hstrict := Finset.sum_lt_sum_of_nonempty hne (fun i _ => hlarge i)
  have hsum : (H.val.card : ℚ) * (1 / 6) < ∑ i ∈ H.val, I.size i := by
    simpa using hstrict
  have hc : (6 : ℚ) ≤ H.val.card := by exact_mod_cast hcard
  have hcap := H.property
  linarith

end IndividualConfiguration

namespace Packing

def configuration {I : Instance} {b : ℕ} (p : Packing I b) (j : Fin b) :
    IndividualConfiguration I := ⟨p.binItems j, p.bin_capacity j⟩

theorem bin_card_le_five {I : Instance} {b : ℕ}
    (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i) (p : Packing I b) (j : Fin b) :
    (p.binItems j).card ≤ 5 :=
  (p.configuration j).card_le_five hlarge

theorem item_count_le_five_mul {I : Instance} {b : ℕ}
    (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i) (p : Packing I b) : I.n ≤ 5 * b := by
  rw [← p.sum_bin_card]
  calc
    ∑ j, (p.binItems j).card ≤ ∑ _j : Fin b, 5 :=
      Finset.sum_le_sum (fun j _ => p.bin_card_le_five hlarge j)
    _ = 5 * b := by simp [Nat.mul_comm]

end Packing

namespace Instance

structure Reindexing (I J : Instance) where
  equiv : I.Item ≃ J.Item
  size_eq : ∀ i, I.size i = J.size (equiv i)

namespace Reindexing

variable {I J : Instance}

def symm (e : Reindexing I J) : Reindexing J I where
  equiv := e.equiv.symm
  size_eq j := by
    simpa using (e.size_eq (e.equiv.symm j)).symm

theorem count_eq (e : Reindexing I J) : I.n = J.n := by
  simpa [Item] using Fintype.card_congr e.equiv

theorem lower_bound_iff (e : Reindexing I J) (a : ℚ) :
    (∀ i, a < I.size i) ↔ ∀ j, a < J.size j := by
  constructor
  · intro h j
    simpa only [e.size_eq, Equiv.apply_symm_apply] using h (e.equiv.symm j)
  · intro h i
    rw [e.size_eq]
    exact h _

end Reindexing

end Instance

namespace Packing

def reindex {I J : Instance} {b : ℕ} (p : Packing I b)
    (e : Instance.Reindexing I J) : Packing J b where
  assignment j := p.assignment (e.equiv.symm j)
  capacity k := by
    calc
      (∑ j : J.Item, if p.assignment (e.equiv.symm j) = k then J.size j else 0) =
          ∑ i : I.Item, if p.assignment (e.equiv.symm (e.equiv i)) = k
            then J.size (e.equiv i) else 0 :=
        (e.equiv.sum_comp (fun j =>
          if p.assignment (e.equiv.symm j) = k then J.size j else 0)).symm
      _ = ∑ i : I.Item, if p.assignment i = k then I.size i else 0 := by
        apply Finset.sum_congr rfl
        intro i _
        rw [Equiv.symm_apply_apply, ← e.size_eq i]
      _ ≤ 1 := p.capacity k

end Packing

namespace Instance.Reindexing

variable {I J : Instance}

theorem hasPacking_iff (e : Reindexing I J) (b : ℕ) :
    HasPacking I b ↔ HasPacking J b := by
  constructor
  · rintro ⟨p⟩
    exact ⟨p.reindex e⟩
  · rintro ⟨p⟩
    exact ⟨p.reindex e.symm⟩

theorem opt_eq (e : Reindexing I J) : opt I = opt J := by
  apply Nat.le_antisymm
  · exact opt_le_of_hasPacking ((e.hasPacking_iff (opt J)).mpr (opt_attained J))
  · exact opt_le_of_hasPacking ((e.hasPacking_iff (opt I)).mp (opt_attained I))

end Instance.Reindexing

namespace RawInstance

@[simp] theorem toInstance_n (r : RawInstance) (hr : r.Valid) :
    (r.toInstance hr).n = r.length := rfl

@[simp] theorem toInstance_size (r : RawInstance) (hr : r.Valid) (i : Fin r.length) :
    (r.toInstance hr).size i = ratValue (r.get i) := rfl

@[simp] theorem valid_nil : Valid [] := by simp [Valid]

end RawInstance

namespace RawPacking

def addFraction (x y : ℕ × ℕ) : ℕ × ℕ :=
  (x.1 * y.2 + y.1 * x.2, x.2 * y.2)

def loadFraction (r : RawInstance) (a : List ℕ) (j : ℕ) : ℕ × ℕ :=
  (r.zip a).foldl
    (fun acc qa => if qa.2 = j then addFraction acc qa.1 else acc) (0, 1)

theorem addFraction_den_pos (x y : ℕ × ℕ) (hx : 0 < x.2) (hy : 0 < y.2) :
    0 < (addFraction x y).2 := Nat.mul_pos hx hy

theorem ratValue_addFraction (x y : ℕ × ℕ) (hx : 0 < x.2) (hy : 0 < y.2) :
    RawInstance.ratValue (addFraction x y) =
      RawInstance.ratValue x + RawInstance.ratValue y := by
  unfold RawInstance.ratValue addFraction
  simp only [Nat.cast_add, Nat.cast_mul]
  have hx' : (x.2 : ℚ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.ne_of_gt hx)
  have hy' : (y.2 : ℚ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.ne_of_gt hy)
  field_simp [hx', hy']

private theorem foldFraction_spec (rows : List ((ℕ × ℕ) × ℕ)) (j : ℕ)
    (acc : ℕ × ℕ) (hacc : 0 < acc.2)
    (hrows : ∀ row ∈ rows, 0 < row.1.2) :
    0 < (rows.foldl
      (fun acc qa => if qa.2 = j then addFraction acc qa.1 else acc) acc).2 ∧
    RawInstance.ratValue (rows.foldl
      (fun acc qa => if qa.2 = j then addFraction acc qa.1 else acc) acc) =
      RawInstance.ratValue acc +
        (rows.map fun qa => if qa.2 = j then RawInstance.ratValue qa.1 else 0).sum := by
  induction rows generalizing acc with
  | nil => simpa using And.intro hacc (rfl : RawInstance.ratValue acc = _)
  | cons row rows ih =>
      have hhead : 0 < row.1.2 := hrows row (List.mem_cons_self ..)
      have htail : ∀ q ∈ rows, 0 < q.1.2 :=
        fun q hq => hrows q (List.mem_cons_of_mem _ hq)
      by_cases h : row.2 = j
      · have hrec := ih (addFraction acc row.1) (addFraction_den_pos _ _ hacc hhead) htail
        refine ⟨?_, ?_⟩
        · simpa only [List.foldl_cons, ite_eq_left h] using hrec.1
        · simpa only [List.foldl_cons, ite_eq_left h, List.map_cons, List.sum_cons,
            ratValue_addFraction _ _ hacc hhead, add_assoc] using hrec.2
      · have hrec := ih acc hacc htail
        simpa only [List.foldl_cons, ite_eq_right h, List.map_cons, List.sum_cons, zero_add]
          using hrec

private theorem zip_den_pos {r : RawInstance} (hr : r.Valid) (a : List ℕ) :
    ∀ row ∈ r.zip a, 0 < row.1.2 := by
  intro row hrow
  exact RawInstance.den_pos hr (List.of_mem_zip hrow).1

theorem loadFraction_den_pos (r : RawInstance) (hr : r.Valid) (a : List ℕ) (j : ℕ) :
    0 < (loadFraction r a j).2 :=
  (foldFraction_spec (r.zip a) j (0, 1) (by decide) (zip_den_pos hr a)).1

theorem load_eq_loadFraction (r : RawInstance) (hr : r.Valid) (a : List ℕ) (j : ℕ) :
    load r a j = RawInstance.ratValue (loadFraction r a j) := by
  have h := (foldFraction_spec (r.zip a) j (0, 1) (by decide) (zip_den_pos hr a)).2
  simpa [load, loadFraction, RawInstance.ratValue] using h.symm

theorem load_le_one_iff (r : RawInstance) (hr : r.Valid) (a : List ℕ) (j : ℕ) :
    load r a j ≤ 1 ↔ (loadFraction r a j).1 ≤ (loadFraction r a j).2 := by
  rw [load_eq_loadFraction r hr a j]
  unfold RawInstance.ratValue
  rw [div_le_one₀ (Nat.cast_pos.mpr (loadFraction_den_pos r hr a j))]
  exact Nat.cast_le

theorem load_eq_zero_of_not_mem (r : RawInstance) (a : List ℕ) (j : ℕ)
    (hj : j ∉ a) : load r a j = 0 := by
  unfold load
  apply List.sum_eq_zero
  intro x hx
  obtain ⟨row, hrow, rfl⟩ := List.mem_map.mp hx
  have hmem : row.2 ∈ a := (List.of_mem_zip hrow).2
  have hne : row.2 ≠ j := fun h => hj (h ▸ hmem)
  simp [hne]

theorem feasible_iff_mem_capacity (r : RawInstance) (p : RawPacking) :
    Feasible r p ↔
      p.assignments.length = r.length ∧
      (∀ j ∈ p.assignments, j < p.bins) ∧
      ∀ j ∈ p.assignments, load r p.assignments j ≤ 1 := by
  constructor
  · rintro ⟨hl, hr, hc⟩
    exact ⟨hl, hr, fun j hj => hc j (hr j hj)⟩
  · rintro ⟨hl, hr, hc⟩
    refine ⟨hl, hr, fun j _ => ?_⟩
    by_cases hj : j ∈ p.assignments
    · exact hc j hj
    · rw [load_eq_zero_of_not_mem _ _ _ hj]
      decide

private theorem zip_ofFn_eq {α β : Type*} {n : ℕ} (f : Fin n → α) (g : Fin n → β) :
    (List.ofFn f).zip (List.ofFn g) = List.ofFn (fun i => (f i, g i)) := by
  induction n with
  | zero => simp
  | succ n ih => simp only [List.ofFn_succ, List.zip_cons_cons, ih]

theorem load_ofFn (r : RawInstance) (f : Fin r.length → ℕ) (j : ℕ) :
    load r (List.ofFn f) j =
      ∑ i : Fin r.length, if f i = j then RawInstance.ratValue (r.get i) else 0 := by
  have hz : r.zip (List.ofFn f) = List.ofFn (fun i => (r.get i, f i)) := by
    calc
      r.zip (List.ofFn f) = (List.ofFn r.get).zip (List.ofFn f) :=
        congrArg (fun xs => xs.zip (List.ofFn f)) (List.ofFn_get r).symm
      _ = _ := zip_ofFn_eq r.get f
  simp only [load, hz, List.map_ofFn, List.sum_ofFn, Function.comp_apply]

def assignmentFn (r : RawInstance) (p : RawPacking)
    (h : p.assignments.length = r.length) (i : Fin r.length) : ℕ :=
  p.assignments.get (Fin.cast h.symm i)

theorem assignments_eq_ofFn (r : RawInstance) (p : RawPacking)
    (h : p.assignments.length = r.length) :
    p.assignments = List.ofFn (assignmentFn r p h) := by
  exact (List.ofFn_get p.assignments).symm.trans
    (List.ofFn_congr h p.assignments.get)

def toPacking (r : RawInstance) (hr : r.Valid) (p : RawPacking) (hp : Feasible r p) :
    Packing (r.toInstance hr) p.bins where
  assignment i := ⟨assignmentFn r p hp.1 i,
    hp.2.1 _ (List.get_mem p.assignments (Fin.cast hp.1.symm i))⟩
  capacity j := by
    have hcap := hp.2.2 j.val j.isLt
    rw [assignments_eq_ofFn r p hp.1, load_ofFn] at hcap
    simpa only [RawInstance.toInstance, Fin.ext_iff] using! hcap

@[simp] theorem toPacking_assignment_val (r : RawInstance) (hr : r.Valid)
    (p : RawPacking) (hp : Feasible r p) (i : Fin r.length) :
    ((toPacking r hr p hp).assignment i).val = assignmentFn r p hp.1 i := rfl

def ofPacking {I : Instance} {b : ℕ} (q : Packing I b) : RawPacking where
  bins := b
  assignments := List.ofFn (fun i => (q.assignment i).val)

theorem ofPacking_feasible (r : RawInstance) (hr : r.Valid) {b : ℕ}
    (q : Packing (r.toInstance hr) b) : Feasible r (ofPacking q) := by
  refine ⟨by simp [ofPacking, RawInstance.toInstance], ?_, ?_⟩
  · intro j hj
    obtain ⟨i, rfl⟩ := List.mem_ofFn.mp hj
    exact (q.assignment i).isLt
  · intro j hj
    have hcap := q.capacity ⟨j, hj⟩
    change load r (List.ofFn (fun i : Fin r.length => (q.assignment i).val)) j ≤ 1
    rw [load_ofFn]
    simpa only [RawInstance.toInstance, Fin.ext_iff] using! hcap

theorem feasible_iff_exists_packing (r : RawInstance) (hr : r.Valid) (p : RawPacking) :
    Feasible r p ↔
      ∃ q : Packing (r.toInstance hr) p.bins,
        p.assignments = List.ofFn (fun i => (q.assignment i).val) := by
  constructor
  · intro hp
    exact ⟨toPacking r hr p hp, assignments_eq_ofFn r p hp.1⟩
  · rintro ⟨q, hq⟩
    have hp := ofPacking_feasible r hr q
    simpa only [ofPacking, ← hq] using hp

theorem hasPacking_iff_exists_feasible (r : RawInstance) (hr : r.Valid) (b : ℕ) :
    HasPacking (r.toInstance hr) b ↔
      ∃ a : List ℕ, Feasible r ⟨b, a⟩ := by
  constructor
  · rintro ⟨q⟩
    exact ⟨(ofPacking q).assignments, ofPacking_feasible r hr q⟩
  · rintro ⟨a, ha⟩
    exact ⟨toPacking r hr ⟨b, a⟩ ha⟩

@[simp] theorem feasible_nil_iff (p : RawPacking) :
    Feasible [] p ↔ p.assignments = [] := by
  constructor
  · intro hp
    exact List.length_eq_zero_iff.mp hp.1
  · intro h
    cases p with
    | mk b a =>
        dsimp at h
        subst a
        simp [Feasible, load]

theorem feasible_zero_bins_iff (r : RawInstance) (a : List ℕ) :
    Feasible r ⟨0, a⟩ ↔ r = [] ∧ a = [] := by
  constructor
  · rintro ⟨hl, hr, _⟩
    have ha : a = [] := by
      apply List.eq_nil_iff_forall_not_mem.mpr
      intro j hj
      exact Nat.not_lt_zero j (hr j hj)
    refine ⟨?_, ha⟩
    apply List.length_eq_zero_iff.mp
    simpa [ha] using hl.symm
  · rintro ⟨rfl, rfl⟩
    simp

end RawPacking

namespace Instance

def toRaw (I : Instance) : RawInstance :=
  List.ofFn fun i : Fin I.n => ((I.size i).num.toNat, (I.size i).den)

@[simp] theorem toRaw_length (I : Instance) : I.toRaw.length = I.n := by
  simp [toRaw]

private theorem ratValue_num_den (x : ℚ) (hx : 0 ≤ x) :
    RawInstance.ratValue (x.num.toNat, x.den) = x := by
  have hn : 0 ≤ x.num := Rat.num_nonneg.mpr hx
  have hc : (x.num.toNat : ℚ) = (x.num : ℚ) := by
    exact_mod_cast Int.toNat_of_nonneg hn
  simpa only [RawInstance.ratValue, hc] using Rat.num_div_den x

theorem toRaw_valid (I : Instance) : I.toRaw.Valid := by
  intro q hq
  obtain ⟨i, rfl⟩ := List.mem_ofFn.mp hq
  have hpos : 0 < (I.size i).num := Rat.num_pos.mpr (I.size_pos i)
  have hn : 0 < (I.size i).num.toNat := Int.pos_iff_toNat_pos.mp hpos
  refine ⟨hn, ?_⟩
  have hrat := I.size_le_one i
  rw [← ratValue_num_den (I.size i) (I.size_pos i).le] at hrat
  change ((I.size i).num.toNat : ℚ) / (I.size i).den ≤ 1 at hrat
  exact Nat.cast_le.mp ((div_le_one₀ (Nat.cast_pos.mpr (I.size i).den_pos)).mp hrat)

theorem toRaw_size (I : Instance) (i : Fin I.toRaw.length) :
    RawInstance.ratValue (I.toRaw.get i) = I.size (Fin.cast (toRaw_length I) i) := by
  have hget : I.toRaw.get i =
      ((I.size (Fin.cast (toRaw_length I) i)).num.toNat,
        (I.size (Fin.cast (toRaw_length I) i)).den) :=
    List.get_ofFn (fun j : Fin I.n => ((I.size j).num.toNat, (I.size j).den)) i
  rw [hget]
  exact ratValue_num_den (I.size (Fin.cast (toRaw_length I) i)) (I.size_pos _).le

def toRawReindexing (I : Instance) :
    Reindexing I (I.toRaw.toInstance (toRaw_valid I)) where
  equiv := finCongr (toRaw_length I).symm
  size_eq i := by
    change I.size i =
      RawInstance.ratValue (I.toRaw.get (Fin.cast (toRaw_length I).symm i))
    rw [toRaw_size]
    rfl

private theorem eq_of_indexed_sizes {I J : Instance} (h : I.n = J.n)
    (hs : ∀ i : I.Item, I.size i = J.size (Fin.cast h i)) : I = J := by
  cases I with
  | mk n s hp hl =>
    cases J with
    | mk m t hq hk =>
      dsimp at h hs
      subst m
      simp only [Fin.cast_refl] at hs
      have hst : s = t := funext hs
      subst t
      rfl

theorem toInstance_toRaw (I : Instance) :
    I.toRaw.toInstance (toRaw_valid I) = I := by
  apply eq_of_indexed_sizes (toRaw_length I)
  intro i
  exact toRaw_size I i

end Instance

namespace RawPacking

theorem ofPacking_cast {I J : Instance} {b : ℕ} (h : I = J) (q : Packing I b) :
    ofPacking (h ▸ q) = ofPacking q := by
  cases h
  rfl

theorem ofPacking_toRaw_feasible {I : Instance} {b : ℕ} (q : Packing I b) :
    Feasible I.toRaw (ofPacking q) := by
  have hI := (Instance.toInstance_toRaw I).symm
  have h := ofPacking_feasible I.toRaw I.toRaw_valid (hI ▸ q)
  rwa [ofPacking_cast hI q] at h

end RawPacking

end BinPackingGap

namespace BinPackingGap.FractionWidth

def denominatorBits (r : RawInstance) : ℕ :=
  (r.map fun q => q.2.size).sum

@[simp] theorem denominatorBits_nil : denominatorBits [] = 0 := rfl

@[simp] theorem denominatorBits_cons (q : ℕ × ℕ) (r : RawInstance) :
    denominatorBits (q :: r) = q.2.size + denominatorBits r := rfl

theorem size_mono {a b : ℕ} (h : a ≤ b) : a.size ≤ b.size := by
  apply Nat.size_le.mpr
  exact lt_of_le_of_lt h (Nat.size_le.mp (le_refl b.size))

theorem size_mul_le (a b : ℕ) : (a * b).size ≤ a.size + b.size := by
  apply Nat.size_le.mpr
  have ha : a < 2 ^ a.size := Nat.size_le.mp (le_refl a.size)
  have hb : b < 2 ^ b.size := Nat.size_le.mp (le_refl b.size)
  calc
    a * b ≤ a * 2 ^ b.size := Nat.mul_le_mul_left a (Nat.le_of_lt hb)
    _ < 2 ^ a.size * 2 ^ b.size :=
      mul_lt_mul_of_pos_right ha (pow_pos (by decide) _)
    _ = 2 ^ (a.size + b.size) := (pow_add 2 a.size b.size).symm

theorem size_add_le {a b H : ℕ} (ha : a.size ≤ H) (hb : b.size ≤ H) :
    (a + b).size ≤ H + 1 := by
  apply Nat.size_le.mpr
  have h := Nat.add_lt_add (Nat.size_le.mp ha) (Nat.size_le.mp hb)
  simpa only [pow_succ, Nat.mul_two] using h

theorem addFraction_left_product_size_le {x q : ℕ × ℕ} (hx : x.1 ≤ x.2) :
    (x.1 * q.2).size ≤ x.2.size + q.2.size := by
  exact (size_mono (Nat.mul_le_mul_right q.2 hx)).trans (size_mul_le x.2 q.2)

theorem addFraction_right_product_size_le {x q : ℕ × ℕ} (hq : q.1 ≤ q.2) :
    (q.1 * x.2).size ≤ x.2.size + q.2.size := by
  have h := (size_mono (Nat.mul_le_mul_right x.2 hq)).trans
    (size_mul_le q.2 x.2)
  simpa only [Nat.add_comm] using h

theorem addFraction_num_size_le {x q : ℕ × ℕ}
    (hx : x.1 ≤ x.2) (hq : q.1 ≤ q.2) :
    (RawPacking.addFraction x q).1.size ≤ x.2.size + q.2.size + 1 := by
  exact size_add_le (addFraction_left_product_size_le hx)
    (addFraction_right_product_size_le hq)

theorem addFraction_den_size_le (x q : ℕ × ℕ) :
    (RawPacking.addFraction x q).2.size ≤ x.2.size + q.2.size :=
  size_mul_le x.2 q.2

theorem fold_den_size_le (r : RawInstance) (a : List ℕ) (j : ℕ) (x : ℕ × ℕ) :
    ((r.zip a).foldl
      (fun acc qa => if qa.2 = j then RawPacking.addFraction acc qa.1 else acc) x).2.size
      ≤ x.2.size + denominatorBits r := by
  induction r generalizing a x with
  | nil => simp
  | cons q r ih =>
      cases a with
      | nil => simp
      | cons b a =>
          simp only [List.zip_cons_cons, List.foldl_cons, denominatorBits_cons]
          by_cases hb : b = j
          · simp only [ite_eq_left hb]
            have hfold := ih a (RawPacking.addFraction x q)
            have hstep := addFraction_den_size_le x q
            omega
          · simp only [ite_eq_right hb]
            have hfold := ih a x
            omega

theorem loadFraction_den_size_le (r : RawInstance) (a : List ℕ) (j : ℕ) :
    (RawPacking.loadFraction r a j).2.size ≤ denominatorBits r + 1 := by
  simpa [RawPacking.loadFraction, Nat.add_comm] using
    fold_den_size_le r a j (0, 1)

theorem loadFraction_num_size_le_of_accepted
    (r : RawInstance) (a : List ℕ) (j : ℕ)
    (h : (RawPacking.loadFraction r a j).1 ≤ (RawPacking.loadFraction r a j).2) :
    (RawPacking.loadFraction r a j).1.size ≤ denominatorBits r + 1 :=
  (size_mono h).trans (loadFraction_den_size_le r a j)

theorem addFraction_width_of_budget {x q : ℕ × ℕ} {H : ℕ}
    (hx : x.1 ≤ x.2) (hq : q.1 ≤ q.2) (hD : x.2.size ≤ H + 1) :
    (RawPacking.addFraction x q).2.size ≤ H + q.2.size + 1 ∧
    (x.1 * q.2).size ≤ H + q.2.size + 1 ∧
    (q.1 * x.2).size ≤ H + q.2.size + 1 ∧
    (RawPacking.addFraction x q).1.size ≤ H + q.2.size + 2 := by
  have hden := addFraction_den_size_le x q
  have hleft := addFraction_left_product_size_le (q := q) hx
  have hright := addFraction_right_product_size_le (x := x) hq
  have hnum := addFraction_num_size_le hx hq
  omega

theorem loadFraction_next_width (r : RawInstance) (a : List ℕ) (j : ℕ)
    (q : ℕ × ℕ)
    (h : (RawPacking.loadFraction r a j).1 ≤ (RawPacking.loadFraction r a j).2)
    (hq : q.1 ≤ q.2) :
    (RawPacking.addFraction (RawPacking.loadFraction r a j) q).2.size
        ≤ denominatorBits r + q.2.size + 1 ∧
    ((RawPacking.loadFraction r a j).1 * q.2).size
        ≤ denominatorBits r + q.2.size + 1 ∧
    (q.1 * (RawPacking.loadFraction r a j).2).size
        ≤ denominatorBits r + q.2.size + 1 ∧
    (RawPacking.addFraction (RawPacking.loadFraction r a j) q).1.size
        ≤ denominatorBits r + q.2.size + 2 :=
  addFraction_width_of_budget h hq (loadFraction_den_size_le r a j)

theorem addFraction_overflow {x q : ℕ × ℕ}
    (hx : x.2 < x.1) (hq : 0 < q.2) :
    (RawPacking.addFraction x q).2 < (RawPacking.addFraction x q).1 := by
  exact lt_of_lt_of_le (mul_lt_mul_of_pos_right hx hq)
    (Nat.le_add_right (x.1 * q.2) (q.1 * x.2))

theorem fold_overflow (r : RawInstance) (a : List ℕ) (j : ℕ) (x : ℕ × ℕ)
    (hr : r.Valid) (hx : x.2 < x.1) :
    let y := (r.zip a).foldl
      (fun acc qa => if qa.2 = j then RawPacking.addFraction acc qa.1 else acc) x
    y.2 < y.1 := by
  induction r generalizing a x with
  | nil => simpa using hx
  | cons q r ih =>
      have hr' : RawInstance.Valid r := fun z hz => hr z (List.mem_cons_of_mem q hz)
      have hq : 0 < q.2 := RawInstance.den_pos hr (List.mem_cons_self ..)
      cases a with
      | nil => simpa using hx
      | cons b a =>
          simp only [List.zip_cons_cons, List.foldl_cons]
          by_cases hb : b = j
          · simp only [ite_eq_left hb]
            exact ih a (RawPacking.addFraction x q) hr' (addFraction_overflow hx hq)
          · simp only [ite_eq_right hb]
            exact ih a x hr' hx

end BinPackingGap.FractionWidth

end OAI
end LocalizedSource03
/- END LOCALIZED SOURCE 03/44: OAI/Computability/BinPacking/Packing/FractionWidth.lean -/

/- BEGIN LOCALIZED SOURCE 04/44: OAI/Computability/BinPacking/Packing/PrimaryLoss.lean
   SHA256: 93fdc677ac0f24b65b0e680d727febe8f58158173b712f5b71aacaaa5afe0082 -/
section LocalizedSource04
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Basic
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Data.Fintype.Card
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.NormNum
-- localized import: Mathlib.Tactic.Positivity

namespace OAI

namespace BinPackingGap.PrimaryLoss

open scoped BigOperators

variable {ι : Type*} [Fintype ι] {N : ℕ}

def binItems (f : ι → Fin N) (b : Fin N) : Finset ι :=
  Finset.univ.filter fun i => f i = b

abbrev fiber (f : ι → Fin N) (b : Fin N) : Finset ι := binItems f b

def itemsIn (f : ι → Fin N) (s : Finset (Fin N)) : Finset ι :=
  Finset.univ.filter fun i => f i ∈ s

def binPrimary (f : ι → Fin N) (p : ι → ℤ) (b : Fin N) : ℤ :=
  ∑ i ∈ binItems f b, p i

def fullBins (f : ι → Fin N) : Finset (Fin N) :=
  Finset.univ.filter fun b => (fiber f b).card = 5

def nonfullBins (f : ι → Fin N) : Finset (Fin N) :=
  Finset.univ.filter fun b => (fiber f b).card < 5

def nonfullItems (f : ι → Fin N) : Finset ι := itemsIn f (nonfullBins f)

def negativeFullBins (f : ι → Fin N) (p : ι → ℤ) : Finset (Fin N) :=
  (fullBins f).filter fun b => binPrimary f p b < 0

def outsideZeroFullItems (f : ι → Fin N) (p : ι → ℤ) : Finset ι :=
  Finset.univ.filter fun i =>
    ¬ ((fiber f (f i)).card = 5 ∧ binPrimary f p (f i) = 0)

theorem fibers_disjoint (f : ι → Fin N) {b d : Fin N} (h : b ≠ d) :
    Disjoint (fiber f b) (fiber f d) := by
  apply Finset.disjoint_left.mpr
  intro i hi hd
  simp only [fiber, binItems, Finset.mem_filter, Finset.mem_univ, true_and] at hi hd
  exact h (hi.symm.trans hd)

theorem sum_fibers (f : ι → Fin N) (s : Finset (Fin N))
    {A : Type*} [AddCommMonoid A] (w : ι → A) :
    (∑ b ∈ s, ∑ i ∈ fiber f b, w i) = ∑ i ∈ itemsIn f s, w i := by
  exact Finset.sum_fiberwise_eq_sum_filter Finset.univ s f w

theorem card_itemsIn (f : ι → Fin N) (s : Finset (Fin N)) :
    (itemsIn f s).card = ∑ b ∈ s, (fiber f b).card := by
  exact (Finset.sum_card_fiberwise_eq_card_filter Finset.univ s f).symm

theorem sum_fiber_card (f : ι → Fin N) :
    ∑ b, (fiber f b).card = Fintype.card ι := by
  simpa [itemsIn] using (card_itemsIn f Finset.univ).symm

theorem sum_binPrimary (f : ι → Fin N) (p : ι → ℤ) :
    ∑ b, binPrimary f p b = ∑ i, p i := by
  simpa [itemsIn, binPrimary] using sum_fibers f Finset.univ p

theorem card_itemsIn_le (f : ι → Fin N)
    (hcap : ∀ b, (fiber f b).card ≤ 5) (s : Finset (Fin N)) :
    (itemsIn f s).card ≤ 5 * s.card := by
  rw [card_itemsIn]
  calc
    (∑ b ∈ s, (fiber f b).card) ≤ ∑ _ ∈ s, 5 :=
      Finset.sum_le_sum fun b _ => hcap b
    _ = 5 * s.card := by simp [Nat.mul_comm]

theorem nonfullBins_card_le (f : ι → Fin N) (B c : ℕ)
    (hcard : Fintype.card ι = 5 * B)
    (hcap : ∀ b, (fiber f b).card ≤ 5) (hN : N ≤ B + c) :
    (nonfullBins f).card ≤ 5 * c := by
  have hmass : ∑ b, (fiber f b).card = 5 * B := (sum_fiber_card f).trans hcard
  have hdef : (∑ b, (5 - (fiber f b).card)) = 5 * N - 5 * B := by
    rw [Finset.sum_tsub_distrib _ (fun b _ => hcap b), hmass]
    simp [Nat.mul_comm]
  calc
    (nonfullBins f).card = ∑ _ ∈ nonfullBins f, 1 := by simp
    _ ≤ ∑ b ∈ nonfullBins f, (5 - (fiber f b).card) := by
      apply Finset.sum_le_sum
      intro b hb
      have hb' : (fiber f b).card < 5 := (Finset.mem_filter.mp hb).2
      omega
    _ ≤ ∑ b : Fin N, (5 - (fiber f b).card) :=
      Finset.sum_le_sum_of_subset (Finset.subset_univ _)
    _ ≤ 5 * c := by rw [hdef]; omega

theorem nonfullItems_card_le (f : ι → Fin N) (B c : ℕ)
    (hcard : Fintype.card ι = 5 * B)
    (hcap : ∀ b, (fiber f b).card ≤ 5) (hN : N ≤ B + c) :
    (nonfullItems f).card ≤ 25 * c := by
  have hi := card_itemsIn_le f hcap (nonfullBins f)
  have hb := nonfullBins_card_le f B c hcard hcap hN
  change (itemsIn f (nonfullBins f)).card ≤ 25 * c
  omega

theorem full_nonfull_disjoint (f : ι → Fin N) :
    Disjoint (nonfullBins f) (fullBins f) := by
  apply Finset.disjoint_left.mpr
  intro b hn hf
  have hn' := (Finset.mem_filter.mp hn).2
  have hf' := (Finset.mem_filter.mp hf).2
  omega

theorem full_nonfull_union (f : ι → Fin N)
    (hcap : ∀ b, (fiber f b).card ≤ 5) :
    nonfullBins f ∪ fullBins f = Finset.univ := by
  ext b
  simp only [Finset.mem_union, nonfullBins, fullBins, Finset.mem_filter,
    Finset.mem_univ, true_and, iff_true]
  have := hcap b
  omega

theorem primary_conservation (f : ι → Fin N) (p : ι → ℤ)
    (hcap : ∀ b, (fiber f b).card ≤ 5) (htotal : ∑ i, p i = 0) :
    (∑ b ∈ nonfullBins f, binPrimary f p b) +
      (∑ b ∈ fullBins f, binPrimary f p b) = 0 := by
  rw [← Finset.sum_union (full_nonfull_disjoint f), full_nonfull_union f hcap,
    sum_binPrimary, htotal]

theorem negativeFullBins_card_le (f : ι → Fin N) (p : ι → ℤ) (B c P0 : ℕ)
    (hcard : Fintype.card ι = 5 * B)
    (hcap : ∀ b, (fiber f b).card ≤ 5) (hN : N ≤ B + c)
    (hp : ∀ i, p i ≤ (P0 : ℤ)) (htotal : ∑ i, p i = 0)
    (hfull : ∀ b, (fiber f b).card = 5 → binPrimary f p b ≤ 0) :
    (negativeFullBins f p).card ≤ 25 * c * P0 := by
  have hnegative : ((negativeFullBins f p).card : ℤ) ≤
      -(∑ b ∈ fullBins f, binPrimary f p b) := by
    calc
      ((negativeFullBins f p).card : ℤ) = ∑ _ ∈ negativeFullBins f p, (1 : ℤ) := by simp
      _ = ∑ b ∈ fullBins f, if binPrimary f p b < 0 then (1 : ℤ) else 0 := by
        rw [negativeFullBins, Finset.sum_filter]
      _ ≤ ∑ b ∈ fullBins f, -binPrimary f p b := by
        apply Finset.sum_le_sum
        intro b hb
        have h := hfull b (Finset.mem_filter.mp hb).2
        split_ifs <;> omega
      _ = _ := Finset.sum_neg_distrib (fun b => binPrimary f p b)
  have hnonfull : (∑ b ∈ nonfullBins f, binPrimary f p b) ≤
      ((nonfullItems f).card : ℤ) * (P0 : ℤ) := by
    change (∑ b ∈ nonfullBins f, ∑ i ∈ fiber f b, p i) ≤ _
    rw [sum_fibers]
    calc
      (∑ i ∈ itemsIn f (nonfullBins f), p i) ≤
          ∑ _ ∈ itemsIn f (nonfullBins f), (P0 : ℤ) :=
        Finset.sum_le_sum fun i _ => hp i
      _ = _ := by simp [nonfullItems]
  have hcons := primary_conservation f p hcap htotal
  have hitems : ((nonfullItems f).card : ℤ) ≤ (25 * c : ℕ) := by
    exact_mod_cast nonfullItems_card_le f B c hcard hcap hN
  have hscaled := mul_le_mul_of_nonneg_right hitems (Int.natCast_nonneg P0)
  have hbound : ((negativeFullBins f p).card : ℤ) ≤ ((25 * c * P0 : ℕ) : ℤ) := by
    push_cast
    push_cast at hscaled
    linarith
  exact_mod_cast hbound

variable [DecidableEq ι] in
theorem outsideZeroFullItems_eq (f : ι → Fin N) (p : ι → ℤ)
    (hcap : ∀ b, (fiber f b).card ≤ 5)
    (hfull : ∀ b, (fiber f b).card = 5 → binPrimary f p b ≤ 0) :
    outsideZeroFullItems f p = nonfullItems f ∪ itemsIn f (negativeFullBins f p) := by
  ext i
  simp only [outsideZeroFullItems, nonfullItems, itemsIn, negativeFullBins,
    nonfullBins, fullBins, Finset.mem_union, Finset.mem_filter, Finset.mem_univ, true_and]
  have hc := hcap (f i)
  have hs := hfull (f i)
  omega

theorem loss_items_disjoint (f : ι → Fin N) (p : ι → ℤ) :
    Disjoint (nonfullItems f) (itemsIn f (negativeFullBins f p)) := by
  apply Finset.disjoint_left.mpr
  intro i hi hj
  simp only [nonfullItems, itemsIn, negativeFullBins, nonfullBins, fullBins,
    Finset.mem_filter, Finset.mem_univ, true_and] at hi hj
  omega

variable [DecidableEq ι] in
theorem primary_loss_bound (f : ι → Fin N) (p : ι → ℤ) (B c P0 : ℕ)
    (hcard : Fintype.card ι = 5 * B)
    (hcap : ∀ b, (fiber f b).card ≤ 5) (hN : N ≤ B + c)
    (hp : ∀ i, |p i| < (P0 : ℤ)) (htotal : ∑ i, p i = 0)
    (hfull : ∀ b, (fiber f b).card = 5 → binPrimary f p b ≤ 0) :
    (nonfullItems f).card ≤ 25 * c ∧
    (negativeFullBins f p).card ≤ 25 * c * P0 ∧
    (outsideZeroFullItems f p).card ≤ 25 * c * (1 + 5 * P0) ∧
    (outsideZeroFullItems f p).card < 25 * (c + 1) * (1 + 5 * P0) := by
  have hnf := nonfullItems_card_le f B c hcard hcap hN
  have hneg := negativeFullBins_card_le f p B c P0 hcard hcap hN
    (fun i => (le_abs_self (p i)).trans (hp i).le) htotal hfull
  have hni := card_itemsIn_le f hcap (negativeFullBins f p)
  have hbad : (outsideZeroFullItems f p).card ≤ 25 * c * (1 + 5 * P0) := by
    rw [outsideZeroFullItems_eq f p hcap hfull,
      Finset.card_union_of_disjoint (loss_items_disjoint f p)]
    nlinarith
  refine ⟨hnf, hneg, hbad, hbad.trans_lt ?_⟩
  nlinarith

end BinPackingGap.PrimaryLoss

end OAI
end LocalizedSource04
/- END LOCALIZED SOURCE 04/44: OAI/Computability/BinPacking/Packing/PrimaryLoss.lean -/

/- BEGIN LOCALIZED SOURCE 05/44: OAI/Computability/BinPacking/Packing/PackingScalar.lean
   SHA256: e9adc108abf44bd1e4fd336fc12ca0767f9dacf6fdbb3d8756e42015734f6c63 -/
section LocalizedSource05
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.BigOperators.Fin
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Algebra.Order.Ring.Basic
-- localized import: Mathlib.Data.Fin.Basic
-- localized import: Mathlib.Data.Fintype.BigOperators
-- localized import: Mathlib.Data.Fintype.Card
-- localized import: Mathlib.Data.Fintype.EquivFin
-- localized import: Mathlib.Data.Int.Basic
-- localized import: Mathlib.Order.Fin.Basic
-- localized import: Mathlib.Tactic.FieldSimp
-- localized import: Mathlib.Tactic.FinCases
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.NormNum
-- localized import: Mathlib.Tactic.Positivity
-- localized import: Mathlib.Tactic.Ring
-- localized import: OAI.Computability.BinPacking.Packing.FractionWidth
-- localized import: OAI.Computability.BinPacking.Packing.PrimaryLoss

namespace OAI

noncomputable section

namespace BinPackingGap

section

open scoped BigOperators

inductive Role
  | x
  | anchor
  | «global»
  | «local»
  | flag
  deriving DecidableEq

instance : Fintype Role where
  elems := {.x, .anchor, .«global», .«local», .flag}
  complete := by intro r; cases r <;> simp

inductive Subclass
  | tp
  | tm
  | s
  | z
  | y
  | up
  | um
  | w
  | dm
  | dg
  | ft
  | fm
  | fg
  deriving DecidableEq

instance : Fintype Subclass where
  elems := {.tp, .tm, .s, .z, .y, .up, .um, .w, .dm, .dg, .ft, .fm, .fg}
  complete := by intro subclass; cases subclass <;> simp

inductive Pattern
  | plusTree
  | minusTree
  | mainJob
  | edgeJob
  deriving DecidableEq

instance : Fintype Pattern where
  elems := {.plusTree, .minusTree, .mainJob, .edgeJob}
  complete := by intro p; cases p <;> simp

namespace Role

def index : Role → Fin 5
  | .x => 0
  | .anchor => 1
  | .«global» => 2
  | .«local» => 3
  | .flag => 4

theorem index_injective : Function.Injective index := by
  intro r s
  cases r <;> cases s <;> decide

theorem sum_univ {A : Type*} [AddCommMonoid A] (f : Role → A) :
    (∑ r, f r) = f .x + f .anchor + f .«global» + f .«local» + f .flag := by
  have h : (Finset.univ : Finset Role) =
      {.x, .anchor, .«global», .«local», .flag} := by decide
  rw [h]
  simp [add_assoc]

end Role

def Subclass.role : Subclass → Role
  | .tp | .tm | .s => .x
  | .z | .y => .anchor
  | .up | .um | .w => .«global»
  | .dm | .dg => .«local»
  | .ft | .fm | .fg => .flag

@[simp] theorem role_eq_x_iff (c : Subclass) :
    c.role = Role.x ↔ c = .tp ∨ c = .tm ∨ c = .s := by
  cases c <;> simp [Subclass.role]

@[simp] theorem role_eq_anchor_iff (c : Subclass) :
    c.role = Role.anchor ↔ c = .z ∨ c = .y := by
  cases c <;> simp [Subclass.role]

@[simp] theorem role_eq_global_iff (c : Subclass) :
    c.role = Role.«global» ↔ c = .up ∨ c = .um ∨ c = .w := by
  cases c <;> simp [Subclass.role]

@[simp] theorem role_eq_local_iff (c : Subclass) :
    c.role = Role.«local» ↔ c = .dm ∨ c = .dg := by
  cases c <;> simp [Subclass.role]

@[simp] theorem role_eq_flag_iff (c : Subclass) :
    c.role = Role.flag ↔ c = .ft ∨ c = .fm ∨ c = .fg := by
  cases c <;> simp [Subclass.role]

def patternSubclass : Pattern → Role → Subclass
  | .plusTree, .x => .tp
  | .plusTree, .anchor => .z
  | .plusTree, .«global» => .up
  | .plusTree, .«local» => .dm
  | .plusTree, .flag => .ft
  | .minusTree, .x => .tm
  | .minusTree, .anchor => .z
  | .minusTree, .«global» => .um
  | .minusTree, .«local» => .dm
  | .minusTree, .flag => .ft
  | .mainJob, .x => .s
  | .mainJob, .anchor => .z
  | .mainJob, .«global» => .up
  | .mainJob, .«local» => .dm
  | .mainJob, .flag => .fm
  | .edgeJob, .x => .s
  | .edgeJob, .anchor => .y
  | .edgeJob, .«global» => .w
  | .edgeJob, .«local» => .dg
  | .edgeJob, .flag => .fg

@[simp] theorem patternSubclass_role (p : Pattern) (r : Role) :
    (patternSubclass p r).role = r := by
  cases p <;> cases r <;> rfl

theorem patternSubclass_injective (p : Pattern) :
    Function.Injective (patternSubclass p) := by
  intro r s h
  simpa only [patternSubclass_role] using congrArg Subclass.role h

theorem patternSubclass_function_injective : Function.Injective patternSubclass := by
  intro p q hpq
  have hx := congrFun hpq Role.x
  have hf := congrFun hpq Role.flag
  cases p <;> cases q <;> simp_all [patternSubclass]

@[simp] theorem card_role : Fintype.card Role = 5 := by decide

@[simp] theorem card_subclass : Fintype.card Subclass = 13 := by decide

@[simp] theorem card_pattern : Fintype.card Pattern = 4 := by decide

def IsPatternTuple (t : Fin 5 → Subclass) : Prop :=
  ∃ p : Pattern, ∃ e : Fin 5 ≃ Role, ∀ i, t i = patternSubclass p (e i)

theorem existsUnique_role_of_pattern {t : Fin 5 → Subclass}
    (ht : IsPatternTuple t) (r : Role) : ∃! i : Fin 5, (t i).role = r := by
  obtain ⟨p, e, he⟩ := ht
  refine ⟨e.symm r, ?_, ?_⟩
  · change (t (e.symm r)).role = r
    rw [he, patternSubclass_role, e.apply_symm_apply]
  · intro i hi
    apply e.injective
    simpa only [he, patternSubclass_role, e.apply_symm_apply] using hi

theorem pattern_eq_of_tuple {t : Fin 5 → Subclass} {p q : Pattern}
    {e f : Fin 5 ≃ Role}
    (hp : ∀ i, t i = patternSubclass p (e i))
    (hq : ∀ i, t i = patternSubclass q (f i)) : p = q := by
  have hef : e = f := by
    apply Equiv.ext
    intro i
    simpa only [patternSubclass_role] using
      congrArg Subclass.role ((hp i).symm.trans (hq i))
  apply patternSubclass_function_injective
  funext r
  simpa only [← hef, e.apply_symm_apply] using
    (hp (e.symm r)).symm.trans (hq (e.symm r))

end

section

def labelWeight {n : ℕ} (v : Fin n) : ℤ := 3 ^ (v.val + 1)

def labelSecondary {n : ℕ} (x d a : Fin n) : ℤ :=
  labelWeight x + labelWeight d - 2 * labelWeight a

theorem labelWeight_pos {n : ℕ} (v : Fin n) : 0 < labelWeight v := by
  exact pow_pos (by norm_num : (0 : ℤ) < 3) _

theorem labelWeight_le {n : ℕ} (v : Fin n) : labelWeight v ≤ (3 : ℤ) ^ n := by
  unfold labelWeight
  exact pow_le_pow_right₀ (by norm_num : (1 : ℤ) ≤ 3)
    (Nat.succ_le_of_lt v.isLt)

theorem labelWeight_strictMono {n : ℕ} : StrictMono (@labelWeight n) := by
  intro x y hxy
  change (3 : ℤ) ^ (x.val + 1) < (3 : ℤ) ^ (y.val + 1)
  exact pow_lt_pow_right₀ (by norm_num : (1 : ℤ) < 3)
    (Nat.add_lt_add_right hxy 1)

theorem labelWeight_mono {n : ℕ} {x a : Fin n} (h : x ≤ a) :
    labelWeight x ≤ labelWeight a :=
  labelWeight_strictMono.monotone h

theorem labelWeight_gap {n : ℕ} {a x : Fin n} (h : a < x) :
    3 * labelWeight a ≤ labelWeight x := by
  have hax : a.val + 1 ≤ x.val := Nat.succ_le_of_lt h
  have hpow : (3 : ℤ) ^ ((a.val + 1) + 1) ≤ (3 : ℤ) ^ (x.val + 1) :=
    pow_le_pow_right₀ (by norm_num : (1 : ℤ) ≤ 3)
      (Nat.add_le_add_right hax 1)
  calc
    3 * labelWeight a = (3 : ℤ) ^ ((a.val + 1) + 1) := by
      change (3 : ℤ) * (3 : ℤ) ^ (a.val + 1) = _
      rw [pow_succ (3 : ℤ) (a.val + 1), mul_comm]
    _ ≤ labelWeight x := hpow

theorem labelSecondary_nonpos_bounds {n : ℕ} {x d a : Fin n}
    (hq : labelSecondary x d a ≤ 0) : x ≤ a ∧ d ≤ a := by
  have ha := labelWeight_pos a
  have hx := labelWeight_pos x
  have hd := labelWeight_pos d
  change labelWeight x + labelWeight d - 2 * labelWeight a ≤ 0 at hq
  constructor
  · by_contra hxa
    have hgap := labelWeight_gap (lt_of_not_ge hxa)
    linarith
  · by_contra hda
    have hgap := labelWeight_gap (lt_of_not_ge hda)
    linarith

theorem labelSecondary_nonpos_iff {n : ℕ} {x d a : Fin n} :
    labelSecondary x d a ≤ 0 ↔ x ≤ a ∧ d ≤ a := by
  constructor
  · exact labelSecondary_nonpos_bounds
  · rintro ⟨hx, hd⟩
    have hqx := labelWeight_mono hx
    have hqd := labelWeight_mono hd
    unfold labelSecondary
    linarith

@[simp] theorem labelSecondary_self {n : ℕ} (a : Fin n) :
    labelSecondary a a a = 0 := by
  unfold labelSecondary
  linarith

theorem labelSecondary_eq_zero_iff {n : ℕ} {x d a : Fin n} :
    labelSecondary x d a = 0 ↔ x = a ∧ d = a := by
  constructor
  · intro hq
    obtain ⟨hx, hd⟩ := labelSecondary_nonpos_bounds (le_of_eq hq)
    have hqx := labelWeight_mono hx
    have hqd := labelWeight_mono hd
    change labelWeight x + labelWeight d - 2 * labelWeight a = 0 at hq
    constructor
    · rcases lt_or_eq_of_le hx with hxa | hxa
      · have hlt := labelWeight_strictMono hxa
        linarith
      · exact hxa
    · rcases lt_or_eq_of_le hd with hda | hda
      · have hlt := labelWeight_strictMono hda
        linarith
      · exact hda
  · rintro ⟨rfl, rfl⟩
    exact labelSecondary_self _

open scoped BigOperators

def subclassIndicator (a b : Subclass) : ℤ := if a = b then 1 else 0

def primaryCoeff (j : Fin 10) (subclass : Subclass) : ℤ :=
  match j.val with
  | 0 => 5 * (if subclass.role = .x then 1 else 0) - 1
  | 1 => 5 * (if subclass.role = .anchor then 1 else 0) - 1
  | 2 => 5 * (if subclass.role = .«global» then 1 else 0) - 1
  | 3 => 5 * (if subclass.role = .«local» then 1 else 0) - 1
  | 4 => 5 * (if subclass.role = .flag then 1 else 0) - 1
  | 5 => subclassIndicator subclass .tp + subclassIndicator subclass .tm - subclassIndicator subclass .ft
  | 6 => subclassIndicator subclass .z - subclassIndicator subclass .ft - subclassIndicator subclass .fm
  | 7 => subclassIndicator subclass .up + subclassIndicator subclass .um -
      subclassIndicator subclass .ft - subclassIndicator subclass .fm
  | 8 => subclassIndicator subclass .dm - subclassIndicator subclass .ft - subclassIndicator subclass .fm
  | 9 => subclassIndicator subclass .tm - subclassIndicator subclass .um
  | _ => 0

def primaryScore (subclass : Subclass) : ℤ :=
  ∑ j : Fin 10, (100 : ℤ) ^ j.val * primaryCoeff j subclass

def primaryBound : ℕ := 100 ^ 11

def roleCoeffIndex (r : Role) : Fin 10 :=
  ⟨r.index.val, lt_trans r.index.isLt (by decide)⟩

theorem primaryCoeff_role (r : Role) (subclass : Subclass) :
    primaryCoeff (roleCoeffIndex r) subclass = 5 * (if subclass.role = r then 1 else 0) - 1 := by
  cases r <;> cases subclass <;> decide

theorem primaryCoeff_abs_le (j : Fin 10) (subclass : Subclass) :
    |primaryCoeff j subclass| ≤ 4 := by
  fin_cases j <;> cases subclass <;> decide

theorem primaryScore_abs_lt (subclass : Subclass) :
    |primaryScore subclass| < (primaryBound : ℤ) := by
  cases subclass <;>
    simp [primaryScore, primaryCoeff, subclassIndicator, Subclass.role,
      primaryBound, Fin.sum_univ_succ] <;> norm_num

theorem sum_primaryScore_eq {I : Type*} [Fintype I] (t : I → Subclass) :
    (∑ i, primaryScore (t i)) =
      ∑ j : Fin 10, (100 : ℤ) ^ j.val * (∑ i, primaryCoeff j (t i)) := by
  simp only [primaryScore, Finset.mul_sum]
  exact Finset.sum_comm

def roleCount {I : Type*} [Fintype I] (t : I → Subclass) (r : Role) : ℤ :=
  ∑ i, if (t i).role = r then 1 else 0

def subclassCount {I : Type*} [Fintype I] (t : I → Subclass) (subclass : Subclass) : ℤ :=
  ∑ i, subclassIndicator (t i) subclass

theorem sum_primaryCoeff_role {I : Type*} [Fintype I]
    (t : I → Subclass) (r : Role) :
    (∑ i, primaryCoeff (roleCoeffIndex r) (t i)) =
      5 * roleCount t r - (Fintype.card I : ℤ) := by
  simp only [primaryCoeff_role, Finset.sum_sub_distrib, ← Finset.mul_sum,
    roleCount, Finset.sum_const, Finset.card_univ, nsmul_eq_mul, mul_one]

theorem sum_primaryCoeff_five {I : Type*} [Fintype I] (t : I → Subclass) :
    (∑ i, primaryCoeff 5 (t i)) =
      subclassCount t .tp + subclassCount t .tm - subclassCount t .ft := by
  simp [primaryCoeff, subclassCount, Finset.sum_add_distrib, Finset.sum_sub_distrib]

theorem sum_primaryCoeff_six {I : Type*} [Fintype I] (t : I → Subclass) :
    (∑ i, primaryCoeff 6 (t i)) =
      subclassCount t .z - subclassCount t .ft - subclassCount t .fm := by
  simp [primaryCoeff, subclassCount, Finset.sum_sub_distrib]

theorem sum_primaryCoeff_seven {I : Type*} [Fintype I] (t : I → Subclass) :
    (∑ i, primaryCoeff 7 (t i)) =
      subclassCount t .up + subclassCount t .um -
        subclassCount t .ft - subclassCount t .fm := by
  simp [primaryCoeff, subclassCount, Finset.sum_add_distrib, Finset.sum_sub_distrib]

theorem sum_primaryCoeff_eight {I : Type*} [Fintype I] (t : I → Subclass) :
    (∑ i, primaryCoeff 8 (t i)) =
      subclassCount t .dm - subclassCount t .ft - subclassCount t .fm := by
  simp [primaryCoeff, subclassCount, Finset.sum_sub_distrib]

theorem sum_primaryCoeff_nine {I : Type*} [Fintype I] (t : I → Subclass) :
    (∑ i, primaryCoeff 9 (t i)) = subclassCount t .tm - subclassCount t .um := by
  simp [primaryCoeff, subclassCount, Finset.sum_sub_distrib]

theorem radix100_eq_zero_iff {n : ℕ} (a : Fin n → ℤ)
    (ha : ∀ i, |a i| < 100) :
    (∑ i, (100 : ℤ) ^ i.val * a i) = 0 ↔ ∀ i, a i = 0 := by
  induction n with
  | zero => simp
  | succ n ih =>
      constructor
      · intro hs
        have hsplit : a 0 + 100 * (∑ i : Fin n, (100 : ℤ) ^ i.val * a i.succ) = 0 := by
          calc
            a 0 + 100 * (∑ i : Fin n, (100 : ℤ) ^ i.val * a i.succ) =
                ∑ i : Fin (n + 1), (100 : ℤ) ^ i.val * a i := by
              rw [Fin.sum_univ_succ]
              simp only [Fin.val_zero, pow_zero, one_mul, Fin.val_succ]
              congr 1
              rw [Finset.mul_sum]
              apply Finset.sum_congr rfl
              intro i _
              rw [pow_succ]
              ring
            _ = 0 := hs
        have hfirst := abs_lt.mp (ha 0)
        have hz : a 0 = 0 := by omega
        have htail : (∑ i : Fin n, (100 : ℤ) ^ i.val * a i.succ) = 0 := by omega
        have hrest := (ih (fun i => a i.succ) (fun i => ha i.succ)).mp htail
        intro i
        exact Fin.cases hz (fun k => hrest k) i
      · intro hz
        simp [hz]

theorem primaryCoeff_total_abs_lt (t : Fin 5 → Subclass) (j : Fin 10) :
    |∑ i, primaryCoeff j (t i)| < 100 := by
  calc
    |∑ i, primaryCoeff j (t i)| ≤ ∑ i, |primaryCoeff j (t i)| :=
      Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i : Fin 5, (4 : ℤ) :=
      Finset.sum_le_sum (fun i _ => primaryCoeff_abs_le j (t i))
    _ < 100 := by norm_num

theorem sum_primaryScore_eq_zero_iff_coefficients (t : Fin 5 → Subclass) :
    (∑ i, primaryScore (t i)) = 0 ↔ ∀ j : Fin 10, (∑ i, primaryCoeff j (t i)) = 0 := by
  rw [sum_primaryScore_eq]
  exact radix100_eq_zero_iff _ (primaryCoeff_total_abs_lt t)

theorem pattern_primaryCoeff_sum (p : Pattern) (j : Fin 10) :
    (∑ r : Role, primaryCoeff j (patternSubclass p r)) = 0 := by
  cases p <;> fin_cases j <;>
    simp [Role.sum_univ, patternSubclass, primaryCoeff, subclassIndicator,
      Subclass.role]

private theorem sum_role_subclassIndicator (v : Role → Subclass)
    (hrole : ∀ r, (v r).role = r) (c : Subclass) :
    (∑ r : Role, subclassIndicator (v r) c) = subclassIndicator (v c.role) c := by
  classical
  apply Finset.sum_eq_single c.role
  · intro r _ hr
    have hne : v r ≠ c := by
      intro he
      exact hr ((hrole r).symm.trans (congrArg Subclass.role he))
    simp [subclassIndicator, hne]
  · intro h
    exact (h (Finset.mem_univ _)).elim

theorem roleTuple_eq_pattern (v : Role → Subclass)
    (hrole : ∀ r, (v r).role = r)
    (hcoeff : ∀ j : Fin 10, (∑ r, primaryCoeff j (v r)) = 0) :
    ∃ p : Pattern, ∀ r, v r = patternSubclass p r := by
  have hx := (role_eq_x_iff _).mp (hrole .x)
  have ha := (role_eq_anchor_iff _).mp (hrole .anchor)
  have hu := (role_eq_global_iff _).mp (hrole .«global»)
  have hd := (role_eq_local_iff _).mp (hrole .«local»)
  have hf := (role_eq_flag_iff _).mp (hrole .flag)
  have h5 := hcoeff 5
  have h6 := hcoeff 6
  have h7 := hcoeff 7
  have h8 := hcoeff 8
  have h9 := hcoeff 9
  rw [sum_primaryCoeff_five] at h5
  rw [sum_primaryCoeff_six] at h6
  rw [sum_primaryCoeff_seven] at h7
  rw [sum_primaryCoeff_eight] at h8
  rw [sum_primaryCoeff_nine] at h9
  simp only [subclassCount, sum_role_subclassIndicator v hrole, Subclass.role]
    at h5 h6 h7 h8 h9
  rcases hf with hf | hf | hf
  all_goals
    rcases ha with ha | ha <;> rcases hd with hd | hd
  all_goals
    simp +decide [subclassIndicator, ha, hd, hf] at h6 h8
  all_goals
    rcases hx with hx | hx | hx <;> rcases hu with hu | hu | hu
  all_goals
    simp +decide [subclassIndicator, hx, hu, hf] at h5 h7 h9
  · refine ⟨.plusTree, ?_⟩
    intro r
    cases r <;> simp [patternSubclass, hx, ha, hu, hd, hf]
  · refine ⟨.minusTree, ?_⟩
    intro r
    cases r <;> simp [patternSubclass, hx, ha, hu, hd, hf]
  · refine ⟨.mainJob, ?_⟩
    intro r
    cases r <;> simp [patternSubclass, hx, ha, hu, hd, hf]
  · refine ⟨.edgeJob, ?_⟩
    intro r
    cases r <;> simp [patternSubclass, hx, ha, hu, hd, hf]

theorem sum_primaryScore_eq_zero_iff_pattern (t : Fin 5 → Subclass) :
    (∑ i, primaryScore (t i)) = 0 ↔ IsPatternTuple t := by
  classical
  rw [sum_primaryScore_eq_zero_iff_coefficients]
  constructor
  · intro hc
    have hcount (r : Role) : roleCount t r = 1 := by
      have h := hc (roleCoeffIndex r)
      rw [sum_primaryCoeff_role] at h
      norm_num at h
      omega
    have hsurj : Function.Surjective (fun i : Fin 5 => (t i).role) := by
      intro r
      by_contra hno
      have hne : ∀ i : Fin 5, (t i).role ≠ r := fun i hi => hno ⟨i, hi⟩
      have hh := hcount r
      simp [roleCount, hne] at hh
    let e₀ : Fin 5 ≃ Role := Fintype.equivOfCardEq (by simp)
    have hinj : Function.Injective (fun i : Fin 5 => (t i).role) :=
      (Finite.injective_iff_surjective_of_equiv e₀).mpr hsurj
    let e : Fin 5 ≃ Role := Equiv.ofBijective _ ⟨hinj, hsurj⟩
    let v : Role → Subclass := fun r => t (e.symm r)
    have hvrole (r : Role) : (v r).role = r := by
      change e (e.symm r) = r
      exact e.apply_symm_apply r
    have hvcoeff (j : Fin 10) : (∑ r : Role, primaryCoeff j (v r)) = 0 := by
      calc
        (∑ r : Role, primaryCoeff j (v r)) =
            ∑ i : Fin 5, primaryCoeff j (v (e i)) := (e.sum_comp _).symm
        _ = 0 := by simpa [v] using hc j
    obtain ⟨p, hp⟩ := roleTuple_eq_pattern v hvrole hvcoeff
    refine ⟨p, e, ?_⟩
    intro i
    simpa [v] using hp (e i)
  · rintro ⟨p, e, he⟩ j
    calc
      (∑ i, primaryCoeff j (t i)) =
          ∑ i : Fin 5, primaryCoeff j (patternSubclass p (e i)) := by simp only [he]
      _ = ∑ r : Role, primaryCoeff j (patternSubclass p r) :=
        e.sum_comp (fun r : Role => primaryCoeff j (patternSubclass p r))
      _ = 0 := pattern_primaryCoeff_sum p j

theorem sum_primaryScore_eq_zero_of_coefficients {I : Type*} [Fintype I]
    (t : I → Subclass) (h : ∀ j : Fin 10, (∑ i, primaryCoeff j (t i)) = 0) :
    (∑ i, primaryScore (t i)) = 0 := by
  rw [sum_primaryScore_eq]
  simp [h]

end

section

def secondaryScore {n : ℕ} (subclass : Subclass) (label : Option (Fin n)) : ℤ :=
  let q := label.elim 0 labelWeight
  match subclass.role with
  | .x => q
  | .anchor => -2 * q
  | .«global» => 0
  | .«local» => q
  | .flag => 0

@[simp] theorem secondaryScore_none {n : ℕ} (subclass : Subclass) :
    secondaryScore subclass (none : Option (Fin n)) = 0 := by
  cases hs : subclass.role <;> simp [secondaryScore, hs]

def tableRoleLabel {n : ℕ} (x d a : Fin n) : Role → Option (Fin n)
  | .x => some x
  | .anchor => some a
  | .«global» => none
  | .«local» => some d
  | .flag => none

def gamma : ℚ := 1 / (1000 * (primaryBound : ℚ))

def mu (n : ℕ) : ℚ := gamma / (1000 * (3 : ℚ) ^ n)

def nu (n : ℕ) : ℚ := mu n / 1000

def encodedSize {n : ℕ} (subclass : Subclass) (label : Option (Fin n)) (w : ℚ) : ℚ :=
  1 / 5 + gamma * (primaryScore subclass : ℚ) +
    mu n * (secondaryScore subclass label : ℚ) + nu n * w

theorem gamma_pos : 0 < gamma := by
  norm_num [gamma, primaryBound]

theorem gamma_le_one : gamma ≤ 1 := by
  norm_num [gamma, primaryBound]

theorem gamma_mul_primaryBound : gamma * (primaryBound : ℚ) = 1 / 1000 := by
  norm_num [gamma, primaryBound]

theorem mu_pos (n : ℕ) : 0 < mu n := by
  exact div_pos gamma_pos (mul_pos (by norm_num) (pow_pos (by norm_num) n))

theorem nu_pos (n : ℕ) : 0 < nu n := div_pos (mu_pos n) (by norm_num)

theorem mu_mul_labelBound (n : ℕ) : mu n * (3 : ℚ) ^ n = gamma / 1000 := by
  unfold mu
  have hn : (3 : ℚ) ^ n ≠ 0 := pow_ne_zero n (by norm_num)
  field_simp [hn]

theorem mu_le_gamma_div (n : ℕ) : mu n ≤ gamma / 1000 := by
  have hn : (1 : ℚ) ≤ 3 ^ n := one_le_pow₀ (by norm_num)
  have h := mul_le_mul_of_nonneg_left hn (mu_pos n).le
  rw [mul_one, mu_mul_labelBound] at h
  exact h

theorem nu_le_gamma_div (n : ℕ) : nu n ≤ gamma / 1000000 := by
  have h := div_le_div_of_nonneg_right (mu_le_gamma_div n) (by norm_num : (0 : ℚ) ≤ 1000)
  simpa only [nu, div_div, show (1000 : ℚ) * 1000 = 1000000 by norm_num] using h

theorem secondaryScore_abs_le {n : ℕ} (subclass : Subclass) (label : Option (Fin n)) :
    |secondaryScore subclass label| ≤ 2 * (3 : ℤ) ^ n := by
  cases label with
  | none =>
      cases hs : subclass.role <;> simp [secondaryScore, hs]
  | some v =>
      have hv0 := labelWeight_pos v
      have hv := labelWeight_le v
      cases hs : subclass.role <;>
        norm_num [secondaryScore, hs, abs_mul, abs_of_pos hv0] <;> linarith

theorem secondaryScore_rat_abs_le {n : ℕ} (subclass : Subclass) (label : Option (Fin n)) :
    |(secondaryScore subclass label : ℚ)| ≤ 2 * (3 : ℚ) ^ n := by
  exact_mod_cast secondaryScore_abs_le subclass label

theorem primaryScore_rat_abs_le (subclass : Subclass) :
    |(primaryScore subclass : ℚ)| ≤ (primaryBound : ℚ) := by
  exact_mod_cast (primaryScore_abs_lt subclass).le

private theorem perturbation_triangle (g m v p q w : ℚ)
    (hg : 0 ≤ g) (hm : 0 ≤ m) (hv : 0 ≤ v) :
    |(1 / 5 + g * p + m * q + v * w) - 1 / 5| ≤
      g * |p| + m * |q| + v * |w| := by
  have heq : (1 / 5 + g * p + m * q + v * w) - 1 / 5 =
      g * p + m * q + v * w := by ring
  rw [heq]
  have hp : |g * p| = g * |p| := by rw [abs_mul, abs_of_nonneg hg]
  have hq : |m * q| = m * |q| := by rw [abs_mul, abs_of_nonneg hm]
  have hw : |v * w| = v * |w| := by rw [abs_mul, abs_of_nonneg hv]
  have hfirst : |g * p + m * q| ≤ |g * p| + |m * q| :=
    abs_add_le (g * p) (m * q)
  have hsecond : |g * p + m * q + v * w| ≤ |g * p + m * q| + |v * w| :=
    abs_add_le (g * p + m * q) (v * w)
  rw [hp, hq] at hfirst
  rw [hw] at hsecond
  linarith only [hfirst, hsecond]

private theorem perturbation_small (g m v p q w : ℚ)
    (hg : 0 ≤ g) (hm : 0 ≤ m) (hv : 0 ≤ v) (hg1 : g ≤ 1)
    (hp : g * |p| ≤ 1 / 1000) (hq : m * |q| ≤ 2 * g / 1000)
    (hw : v * |w| ≤ v * 6) (hnu : v ≤ g / 1000000) :
    |(1 / 5 + g * p + m * q + v * w) - 1 / 5| ≤ 1 / 100 := by
  have hsum := perturbation_triangle g m v p q w hg hm hv
  nlinarith only [hsum, hg1, hp, hq, hw, hnu]

theorem encodedSize_perturbation_bound {n : ℕ} (subclass : Subclass)
    (label : Option (Fin n)) (w : ℚ) (hw : |w| ≤ 6) :
    |encodedSize subclass label w - 1 / 5| ≤ 1 / 100 := by
  have hp := mul_le_mul_of_nonneg_left (primaryScore_rat_abs_le subclass) gamma_pos.le
  rw [gamma_mul_primaryBound] at hp
  have hq := mul_le_mul_of_nonneg_left (secondaryScore_rat_abs_le subclass label) (mu_pos n).le
  have hq' : mu n * |(secondaryScore subclass label : ℚ)| ≤ 2 * gamma / 1000 := by
    calc
      _ ≤ mu n * (2 * (3 : ℚ) ^ n) := hq
      _ = 2 * gamma / 1000 := by
        rw [← mul_assoc, mul_comm (mu n) 2, mul_assoc, mu_mul_labelBound]
        ring
  have hw' := mul_le_mul_of_nonneg_left hw (nu_pos n).le
  exact perturbation_small gamma (mu n) (nu n) (primaryScore subclass)
    (secondaryScore subclass label) w gamma_pos.le (mu_pos n).le (nu_pos n).le
    gamma_le_one hp hq' hw' (nu_le_gamma_div n)

theorem encodedSize_mem_interval {n : ℕ} (subclass : Subclass)
    (label : Option (Fin n)) (w : ℚ) (hw : |w| ≤ 6) :
    1 / 6 < encodedSize subclass label w ∧ encodedSize subclass label w < 1 := by
  have hb := abs_le.mp (encodedSize_perturbation_bound subclass label w hw)
  constructor <;> linarith

theorem primary_tail_lt (n : ℕ) :
    mu n * (10 * (3 : ℚ) ^ n) + nu n * 30 < gamma := by
  have heq : mu n * (10 * (3 : ℚ) ^ n) = 10 * gamma / 1000 := by
    rw [← mul_assoc, mul_comm (mu n) 10, mul_assoc, mu_mul_labelBound]
    ring
  rw [heq]
  have hn := nu_le_gamma_div n
  have hg := gamma_pos
  nlinarith

theorem secondary_tail_lt (n : ℕ) : nu n * 30 < mu n := by
  have hμ := mu_pos n
  unfold nu
  nlinarith

open scoped BigOperators

namespace Packing

variable {I : Instance} {b : ℕ}

def primaryTotal (p : Packing I b) (subclass : I.Item → Subclass) (j : Fin b) : ℤ :=
  ∑ i ∈ p.binItems j, primaryScore (subclass i)

def IsTableBin (p : Packing I b) (subclass : I.Item → Subclass) (j : Fin b) : Prop :=
  (p.binItems j).card = 5 ∧ p.primaryTotal subclass j = 0

abbrev TableBin (p : Packing I b) (subclass : I.Item → Subclass) :=
  {j : Fin b // p.IsTableBin subclass j}

instance (p : Packing I b) (subclass : I.Item → Subclass) :
    Fintype (p.TableBin subclass) := Fintype.ofFinite _

instance (p : Packing I b) (subclass : I.Item → Subclass) :
    DecidableEq (p.TableBin subclass) := Classical.decEq _

theorem table_pattern (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) :
    ∃ pat : Pattern, ∃ e : Role ≃ p.binItems t.val,
      ∀ r, subclass (e r).val = patternSubclass pat r := by
  classical
  let e : Fin 5 ≃ p.binItems t.val :=
    (Finset.equivFinOfCardEq t.property.1).symm
  have hz : (∑ i : Fin 5, primaryScore (subclass (e i).val)) = 0 := by
    rw [e.sum_comp (fun i : p.binItems t.val => primaryScore (subclass i.val))]
    change (∑ i ∈ (p.binItems t.val).attach, primaryScore (subclass i.val)) = 0
    rw [Finset.sum_attach (p.binItems t.val) (fun i => primaryScore (subclass i))]
    exact t.property.2
  obtain ⟨pat, perm, hp⟩ :=
    (sum_primaryScore_eq_zero_iff_pattern (fun i => subclass (e i).val)).mp hz
  refine ⟨pat, perm.symm.trans e, ?_⟩
  intro r
  simpa using hp (perm.symm r)

def tablePattern (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) : Pattern :=
  Classical.choose (p.table_pattern subclass t)

def tableEquiv (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) : Role ≃ p.binItems t.val :=
  Classical.choose (Classical.choose_spec (p.table_pattern subclass t))

theorem tableEquiv_subclass (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (r : Role) :
    subclass (p.tableEquiv subclass t r).val =
      patternSubclass (p.tablePattern subclass t) r :=
  Classical.choose_spec (Classical.choose_spec (p.table_pattern subclass t)) r

def itemAtRole (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (r : Role) : I.Item :=
  (p.tableEquiv subclass t r).val

theorem itemAtRole_mem (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (r : Role) :
    p.itemAtRole subclass t r ∈ p.binItems t.val :=
  (p.tableEquiv subclass t r).property

theorem itemAtRole_subclass (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (r : Role) :
    subclass (p.itemAtRole subclass t r) =
      patternSubclass (p.tablePattern subclass t) r :=
  p.tableEquiv_subclass subclass t r

@[simp] theorem itemAtRole_role (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (r : Role) :
    (subclass (p.itemAtRole subclass t r)).role = r := by
  rw [p.itemAtRole_subclass subclass t r, patternSubclass_role]

theorem itemAtRole_injective (p : Packing I b) (subclass : I.Item → Subclass)
    (r : Role) : Function.Injective (fun t => p.itemAtRole subclass t r) :=
  p.chosen_injective Subtype.val Subtype.val_injective
    (fun t => p.itemAtRole subclass t r) (fun t => p.itemAtRole_mem subclass t r)

theorem itemAtRole_joint_injective (p : Packing I b) (subclass : I.Item → Subclass) :
    Function.Injective (fun tr : p.TableBin subclass × Role =>
      p.itemAtRole subclass tr.1 tr.2) := by
  intro x y h
  have hr : x.2 = y.2 := by
    have := congrArg (fun i => (subclass i).role) h
    simpa only [itemAtRole_role] using this
  have ht : x.1 = y.1 := by
    apply p.itemAtRole_injective subclass x.2
    simpa only [hr] using h
  exact Prod.ext ht hr

theorem mem_table_bin_iff (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (i : I.Item) :
    i ∈ p.binItems t.val ↔ ∃ r, p.itemAtRole subclass t r = i := by
  constructor
  · intro hi
    refine ⟨(p.tableEquiv subclass t).symm ⟨i, hi⟩, ?_⟩
    simp [itemAtRole]
  · rintro ⟨r, rfl⟩
    exact p.itemAtRole_mem subclass t r

theorem itemAtRole_eq_of_mem (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) (r : Role) (i : I.Item)
    (hi : i ∈ p.binItems t.val) (hr : (subclass i).role = r) :
    p.itemAtRole subclass t r = i := by
  obtain ⟨s, hs⟩ := (p.mem_table_bin_iff subclass t i).mp hi
  have hsr : s = r := by
    rw [← hs, p.itemAtRole_role] at hr
    exact hr
  simpa only [hsr] using hs

def IsGoodTableBin (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) (t : p.TableBin subclass) : Prop :=
  label (p.itemAtRole subclass t .x) = label (p.itemAtRole subclass t .anchor) ∧
    label (p.itemAtRole subclass t .«local») =
      label (p.itemAtRole subclass t .anchor)

abbrev GoodTableBin (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) :=
  {t : p.TableBin subclass // p.IsGoodTableBin subclass label t}

instance (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) :
    Fintype (p.GoodTableBin subclass label) := Fintype.ofFinite _

abbrev GoodM (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) :=
  {t : p.GoodTableBin subclass label // p.tablePattern subclass t.val ≠ .edgeJob}

abbrev GoodG (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) :=
  {t : p.GoodTableBin subclass label // p.tablePattern subclass t.val = .edgeJob}

instance (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) :
    Fintype (p.GoodM subclass label) := Fintype.ofFinite _

instance (p : Packing I b) (subclass : I.Item → Subclass)
    {n : ℕ} (label : I.Item → Option (Fin n)) :
    Fintype (p.GoodG subclass label) := Fintype.ofFinite _

end Packing

end

open scoped BigOperators

def primaryTotal (s : Fin 5 → Subclass) : ℤ := ∑ i, primaryScore (s i)

def secondaryTotal {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) : ℤ := ∑ i, secondaryScore (s i) (label i)

def coordinateTotal (w : Fin 5 → ℚ) : ℚ := ∑ i, w i

theorem encodedSize_sum {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (w : Fin 5 → ℚ) :
    (∑ i, encodedSize (s i) (label i) (w i)) =
      1 + gamma * (primaryTotal s : ℚ) +
        mu n * (secondaryTotal s label : ℚ) + nu n * coordinateTotal w := by
  simp [encodedSize, primaryTotal, secondaryTotal, coordinateTotal,
    Finset.sum_add_distrib, Finset.mul_sum]

theorem secondaryTotal_rat_abs_le {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) :
    |(secondaryTotal s label : ℚ)| ≤ 10 * (3 : ℚ) ^ n := by
  calc
    _ = |∑ i, (secondaryScore (s i) (label i) : ℚ)| := by simp [secondaryTotal]
    _ ≤ ∑ i, |(secondaryScore (s i) (label i) : ℚ)| :=
      Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i : Fin 5, 2 * (3 : ℚ) ^ n :=
      Finset.sum_le_sum (fun i _ => secondaryScore_rat_abs_le (s i) (label i))
    _ = _ := by norm_num; ring

theorem coordinateTotal_abs_le (w : Fin 5 → ℚ) (hw : ∀ i, |w i| ≤ 6) :
    |coordinateTotal w| ≤ 30 := by
  calc
    _ ≤ ∑ i, |w i| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i : Fin 5, (6 : ℚ) := Finset.sum_le_sum (fun i _ => hw i)
    _ = _ := by norm_num

theorem sum_primary_nonpos_of_feasible {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (w : Fin 5 → ℚ)
    (hw : ∀ i, |w i| ≤ 6)
    (hfeas : (∑ i, encodedSize (s i) (label i) (w i)) ≤ 1) :
    primaryTotal s ≤ 0 := by
  by_contra h
  have hp : (1 : ℤ) ≤ primaryTotal s :=
    Int.add_one_le_iff.mpr (lt_of_not_ge h)
  have hpQ : (1 : ℚ) ≤ (primaryTotal s : ℚ) := by exact_mod_cast hp
  have hp' := mul_le_mul_of_nonneg_left hpQ gamma_pos.le
  have hq := mul_le_mul_of_nonneg_left
    (abs_le.mp (secondaryTotal_rat_abs_le s label)).1 (mu_pos n).le
  have hw' := mul_le_mul_of_nonneg_left
    (abs_le.mp (coordinateTotal_abs_le w hw)).1 (nu_pos n).le
  have htail := primary_tail_lt n
  rw [encodedSize_sum] at hfeas
  nlinarith only [hfeas, hp', hq, hw', htail]

theorem sum_secondary_nonpos_of_feasible {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (w : Fin 5 → ℚ)
    (hw : ∀ i, |w i| ≤ 6) (hp : primaryTotal s = 0)
    (hfeas : (∑ i, encodedSize (s i) (label i) (w i)) ≤ 1) :
    secondaryTotal s label ≤ 0 := by
  by_contra h
  have hq : (1 : ℤ) ≤ secondaryTotal s label :=
    Int.add_one_le_iff.mpr (lt_of_not_ge h)
  have hqQ : (1 : ℚ) ≤ (secondaryTotal s label : ℚ) := by exact_mod_cast hq
  have hq' := mul_le_mul_of_nonneg_left hqQ (mu_pos n).le
  have hw' := mul_le_mul_of_nonneg_left
    (abs_le.mp (coordinateTotal_abs_le w hw)).1 (nu_pos n).le
  have htail := secondary_tail_lt n
  rw [encodedSize_sum, hp] at hfeas
  norm_num only [Int.cast_zero, mul_zero, add_zero] at hfeas
  nlinarith only [hfeas, hq', hw', htail]

theorem feasible_iff_coordinateSum_nonpos {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (w : Fin 5 → ℚ)
    (hp : primaryTotal s = 0) (hq : secondaryTotal s label = 0) :
    ((∑ i, encodedSize (s i) (label i) (w i)) ≤ 1) ↔ coordinateTotal w ≤ 0 := by
  rw [encodedSize_sum, hp, hq]
  norm_num only [Int.cast_zero, mul_zero, add_zero]
  constructor
  · intro h
    have hmul : nu n * coordinateTotal w ≤ nu n * 0 := by linarith
    exact le_of_mul_le_mul_left hmul (nu_pos n)
  · intro h
    have hmul := mul_le_mul_of_nonneg_left h (nu_pos n).le
    linarith

theorem secondaryTotal_eq_labelSecondary {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (e : Fin 5 ≃ Role) (x d a : Fin n)
    (hs : ∀ i, (s i).role = e i)
    (hl : ∀ i, label i = tableRoleLabel x d a (e i)) :
    secondaryTotal s label = labelSecondary x d a := by
  let f : Role → ℤ := fun r => match r with
    | .x => labelWeight x
    | .anchor => -2 * labelWeight a
    | .«global» => 0
    | .«local» => labelWeight d
    | .flag => 0
  calc
    secondaryTotal s label = ∑ i, f (e i) := by
      apply Finset.sum_congr rfl
      intro i _
      simp only [secondaryScore, hs i, hl i]
      cases he : e i <;> rfl
    _ = ∑ r, f r := e.sum_comp f
    _ = labelSecondary x d a := by
      rw [Role.sum_univ]
      simp only [f, labelSecondary]
      ring

theorem secondaryTotal_nonpos_iff_labels {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (e : Fin 5 ≃ Role) (x d a : Fin n)
    (hs : ∀ i, (s i).role = e i)
    (hl : ∀ i, label i = tableRoleLabel x d a (e i)) :
    secondaryTotal s label ≤ 0 ↔ x ≤ a ∧ d ≤ a := by
  rw [secondaryTotal_eq_labelSecondary s label e x d a hs hl]
  exact labelSecondary_nonpos_iff

theorem secondaryTotal_eq_zero_iff_labels {n : ℕ} (s : Fin 5 → Subclass)
    (label : Fin 5 → Option (Fin n)) (e : Fin 5 ≃ Role) (x d a : Fin n)
    (hs : ∀ i, (s i).role = e i)
    (hl : ∀ i, label i = tableRoleLabel x d a (e i)) :
    secondaryTotal s label = 0 ↔ x = a ∧ d = a := by
  rw [secondaryTotal_eq_labelSecondary s label e x d a hs hl]
  exact labelSecondary_eq_zero_iff

namespace Packing

variable {I : Instance} {b n : ℕ}

def fiveEquiv (p : Packing I b) (j : Fin b) (hc : (p.binItems j).card = 5) :
    Fin 5 ≃ p.binItems j := (Finset.equivFinOfCardEq hc).symm

theorem sum_fiveEquiv (p : Packing I b) (j : Fin b) (hc : (p.binItems j).card = 5)
    {M : Type*} [AddCommMonoid M] (f : I.Item → M) :
    (∑ i : Fin 5, f (p.fiveEquiv j hc i).val) = ∑ i ∈ p.binItems j, f i := by
  rw [(p.fiveEquiv j hc).sum_comp (fun i : p.binItems j => f i.val)]
  change (∑ i ∈ (p.binItems j).attach, f i.val) = ∑ i ∈ p.binItems j, f i
  exact Finset.sum_attach (p.binItems j) f

theorem full_primary_nonpos (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (subclass i) (label i) (coordinate i))
    (hw : ∀ i, |coordinate i| ≤ 6)
    (j : Fin b) (hc : (p.binItems j).card = 5) :
    p.primaryTotal subclass j ≤ 0 := by
  let e := p.fiveEquiv j hc
  have hcap : (∑ i : Fin 5,
      encodedSize (subclass (e i).val) (label (e i).val) (coordinate (e i).val)) ≤ 1 := by
    simp_rw [← hsize]
    rw [p.sum_fiveEquiv]
    exact p.bin_capacity j
  have hp := sum_primary_nonpos_of_feasible
    (fun i => subclass (e i).val) (fun i => label (e i).val)
    (fun i => coordinate (e i).val) (fun i => hw _) hcap
  change (∑ i : Fin 5, primaryScore (subclass (p.fiveEquiv j hc i).val)) ≤ 0 at hp
  rw [p.sum_fiveEquiv j hc (fun i => primaryScore (subclass i))] at hp
  exact hp

theorem table_secondary_nonpos (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (subclass i) (label i) (coordinate i))
    (hw : ∀ i, |coordinate i| ≤ 6) (t : p.TableBin subclass) :
    (∑ i ∈ p.binItems t.val, secondaryScore (subclass i) (label i)) ≤ 0 := by
  let e := p.fiveEquiv t.val t.property.1
  have hp : BinPackingGap.primaryTotal (fun i => subclass (e i).val) = 0 := by
    change (∑ i : Fin 5,
      primaryScore (subclass (p.fiveEquiv t.val t.property.1 i).val)) = 0
    rw [p.sum_fiveEquiv t.val t.property.1 (fun i => primaryScore (subclass i))]
    exact t.property.2
  have hcap : (∑ i : Fin 5,
      encodedSize (subclass (e i).val) (label (e i).val) (coordinate (e i).val)) ≤ 1 := by
    simp_rw [← hsize]
    rw [p.sum_fiveEquiv]
    exact p.bin_capacity t.val
  have hq := sum_secondary_nonpos_of_feasible
    (fun i => subclass (e i).val) (fun i => label (e i).val)
    (fun i => coordinate (e i).val) (fun i => hw _) hp hcap
  change (∑ i : Fin 5,
    secondaryScore (subclass (p.fiveEquiv t.val t.property.1 i).val)
      (label (p.fiveEquiv t.val t.property.1 i).val)) ≤ 0 at hq
  rw [p.sum_fiveEquiv t.val t.property.1
    (fun i => secondaryScore (subclass i) (label i))] at hq
  exact hq

theorem sum_itemAtRole (p : Packing I b) (subclass : I.Item → Subclass)
    (t : p.TableBin subclass) {M : Type*} [AddCommMonoid M] (f : I.Item → M) :
    (∑ r : Role, f (p.itemAtRole subclass t r)) = ∑ i ∈ p.binItems t.val, f i := by
  change (∑ r : Role, f (p.tableEquiv subclass t r).val) =
    ∑ i ∈ p.binItems t.val, f i
  rw [(p.tableEquiv subclass t).sum_comp (fun i : p.binItems t.val => f i.val)]
  change (∑ i ∈ (p.binItems t.val).attach, f i.val) = ∑ i ∈ p.binItems t.val, f i
  exact Finset.sum_attach (p.binItems t.val) f

theorem table_secondary_eq (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (t : p.TableBin subclass) (x d a : Fin n)
    (hl : ∀ r, label (p.itemAtRole subclass t r) = tableRoleLabel x d a r) :
    (∑ i ∈ p.binItems t.val, secondaryScore (subclass i) (label i)) =
      labelSecondary x d a := by
  rw [← p.sum_itemAtRole subclass t]
  simp only [secondaryScore, p.itemAtRole_role, hl]
  rw [Role.sum_univ]
  simp [tableRoleLabel, labelSecondary]
  ring

theorem table_labels_le_anchor (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (subclass i) (label i) (coordinate i))
    (hw : ∀ i, |coordinate i| ≤ 6) (t : p.TableBin subclass)
    (x d a : Fin n)
    (hl : ∀ r, label (p.itemAtRole subclass t r) = tableRoleLabel x d a r) :
    x ≤ a ∧ d ≤ a := by
  have hq := p.table_secondary_nonpos subclass label coordinate hsize hw t
  rw [p.table_secondary_eq subclass label t x d a hl] at hq
  exact labelSecondary_nonpos_iff.mp hq

theorem table_coordinate_nonpos (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (subclass i) (label i) (coordinate i))
    (t : p.TableBin subclass)
    (hq : (∑ i ∈ p.binItems t.val, secondaryScore (subclass i) (label i)) = 0) :
    (∑ i ∈ p.binItems t.val, coordinate i) ≤ 0 := by
  let e := p.fiveEquiv t.val t.property.1
  have hp : BinPackingGap.primaryTotal (fun i => subclass (e i).val) = 0 := by
    change (∑ i : Fin 5,
      primaryScore (subclass (p.fiveEquiv t.val t.property.1 i).val)) = 0
    rw [p.sum_fiveEquiv t.val t.property.1 (fun i => primaryScore (subclass i))]
    exact t.property.2
  have hq' : secondaryTotal (fun i => subclass (e i).val)
      (fun i => label (e i).val) = 0 := by
    change (∑ i : Fin 5,
      secondaryScore (subclass (p.fiveEquiv t.val t.property.1 i).val)
        (label (p.fiveEquiv t.val t.property.1 i).val)) = 0
    rw [p.sum_fiveEquiv t.val t.property.1
      (fun i => secondaryScore (subclass i) (label i))]
    exact hq
  have hcap : (∑ i : Fin 5,
      encodedSize (subclass (e i).val) (label (e i).val) (coordinate (e i).val)) ≤ 1 := by
    simp_rw [← hsize]
    rw [p.sum_fiveEquiv]
    exact p.bin_capacity t.val
  have hw := (feasible_iff_coordinateSum_nonpos
    (fun i => subclass (e i).val) (fun i => label (e i).val)
    (fun i => coordinate (e i).val) hp hq').mp hcap
  change (∑ i : Fin 5, coordinate (p.fiveEquiv t.val t.property.1 i).val) ≤ 0 at hw
  rw [p.sum_fiveEquiv t.val t.property.1 coordinate] at hw
  exact hw

theorem table_coordinate_nonpos_of_same_label (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (subclass i) (label i) (coordinate i))
    (t : p.TableBin subclass) (v : Fin n)
    (hl : ∀ r, label (p.itemAtRole subclass t r) = tableRoleLabel v v v r) :
    (∑ r : Role, coordinate (p.itemAtRole subclass t r)) ≤ 0 := by
  rw [p.sum_itemAtRole]
  apply p.table_coordinate_nonpos subclass label coordinate hsize t
  rw [p.table_secondary_eq subclass label t v v v hl]
  simp [labelSecondary]
  ring

def outsideTableItems (p : Packing I b) (subclass : I.Item → Subclass) :
    Finset I.Item := by
  classical
  exact Finset.univ.filter fun i => ¬ p.IsTableBin subclass (p.assignment i)

theorem outsideTableItems_card_lt (p : Packing I b)
    (subclass : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (subclass i) (label i) (coordinate i))
    (hw : ∀ i, |coordinate i| ≤ 6) (B c : ℕ)
    (hcard : I.n = 5 * B) (hb : b ≤ B + c)
    (htotal : (∑ i, primaryScore (subclass i)) = 0) :
    (p.outsideTableItems subclass).card <
      25 * (c + 1) * (1 + 5 * primaryBound) := by
  classical
  have hlarge (i : I.Item) : (1 / 6 : ℚ) < I.size i := by
    rw [hsize]
    exact (encodedSize_mem_interval _ _ _ (hw i)).1
  have hcap := p.bin_card_le_five hlarge
  have hfull (j : Fin b) (hc : (PrimaryLoss.fiber p.assignment j).card = 5) :
      PrimaryLoss.binPrimary p.assignment (fun i => primaryScore (subclass i)) j ≤ 0 := by
    exact p.full_primary_nonpos subclass label coordinate hsize hw j hc
  have h := PrimaryLoss.primary_loss_bound p.assignment
    (fun i => primaryScore (subclass i)) B c primaryBound
    (by simpa using hcard) hcap hb (fun i => primaryScore_abs_lt (subclass i)) htotal hfull
  have hsets : p.outsideTableItems subclass =
      PrimaryLoss.outsideZeroFullItems p.assignment (fun i => primaryScore (subclass i)) := by
    ext i
    constructor
    · intro hi
      have hi' := (Finset.mem_filter.mp hi).2
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ i, hi'⟩
    · intro hi
      have hi' := (Finset.mem_filter.mp hi).2
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ i, hi'⟩
  rw [hsets]
  exact h.2.2.2

end Packing

end BinPackingGap

end

end OAI
end LocalizedSource05
/- END LOCALIZED SOURCE 05/44: OAI/Computability/BinPacking/Packing/PackingScalar.lean -/

/- BEGIN LOCALIZED SOURCE 06/44: OAI/Computability/BinPacking/Trees/CompletionGeometry.lean
   SHA256: 3872bfd3c45e6dae41f0018455c728c565622d3421c47164c21c89828ca19e39 -/
section LocalizedSource06
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.Order.Field.Basic
-- localized import: Mathlib.Algebra.Order.Field.Rat
-- localized import: Mathlib.Data.Fin.Basic
-- localized import: Mathlib.Order.Interval.Set.Basic
-- localized import: Mathlib.Tactic.FieldSimp
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.NormNum
-- localized import: Mathlib.Tactic.Positivity
-- localized import: Mathlib.Tactic.Ring

namespace OAI

namespace BinPackingGap.Geometry

abbrev Position (m R : ℕ) := Fin m × Fin R

def theta (R : ℕ) {m : ℕ} (e : Fin m) : ℚ :=
  ((R : ℚ) + 1) ^ e.val - 1

def heightCode (R : ℕ) {m : ℕ} (r : Position m R) : ℚ :=
  ((r.2.val : ℚ) + 1) * ((R : ℚ) + 1) ^ r.1.val - 1

def gap (m R : ℕ) : ℚ := 1 / (16 * ((R : ℚ) + 1) ^ m)

def baseline (m R : ℕ) (r : Position m R) : ℚ :=
  1 / 2 + gap m R * heightCode R r

def beta (m R : ℕ) (e : Fin m) : ℚ := gap m R * theta R e

def lambda (m R D ell : ℕ) : ℚ :=
  gap m R / (100 * ((D : ℚ) + 1)) ^ ell

def delta (m R D L : ℕ) : ℚ := lambda m R D L / 10

theorem base_pos (R : ℕ) : 0 < (R : ℚ) + 1 := by positivity

theorem base_one_le (R : ℕ) : 1 ≤ (R : ℚ) + 1 := by
  have hR : (0 : ℚ) ≤ R := Nat.cast_nonneg R
  linarith

theorem widthScale_pos (D : ℕ) : 0 < 100 * ((D : ℚ) + 1) := by positivity

theorem widthScale_one_le (D : ℕ) : 1 ≤ 100 * ((D : ℚ) + 1) := by
  have hD : (0 : ℚ) ≤ D := Nat.cast_nonneg D
  linarith

theorem gap_pos (m R : ℕ) : 0 < gap m R := by
  unfold gap
  positivity

theorem gap_nonneg (m R : ℕ) : 0 ≤ gap m R := (gap_pos m R).le

theorem gap_le_one_sixteen (m R : ℕ) : gap m R ≤ 1 / 16 := by
  unfold gap
  apply div_le_div_of_nonneg_left (by norm_num) (by norm_num)
  have hp : (1 : ℚ) ≤ ((R : ℚ) + 1) ^ m := one_le_pow₀ (base_one_le R)
  linarith

theorem gap_mul_power (m R : ℕ) : gap m R * ((R : ℚ) + 1) ^ m = 1 / 16 := by
  unfold gap
  have hp : ((R : ℚ) + 1) ^ m ≠ 0 := (pow_pos (base_pos R) m).ne'
  field_simp [hp]

theorem theta_nonneg (R : ℕ) {m : ℕ} (e : Fin m) : 0 ≤ theta R e := by
  exact sub_nonneg.mpr (one_le_pow₀ (base_one_le R))

theorem theta_lt_power (R : ℕ) {m : ℕ} (e : Fin m) :
    theta R e < ((R : ℚ) + 1) ^ m := by
  have hp := pow_le_pow_right₀ (base_one_le R) (Nat.le_of_lt e.isLt)
  unfold theta
  linarith

theorem heightCode_nonneg (R : ℕ) {m : ℕ} (r : Position m R) :
    0 ≤ heightCode R r := by
  have hj : (1 : ℚ) ≤ (r.2.val : ℚ) + 1 := by
    have h := (Nat.cast_nonneg r.2.val : (0 : ℚ) ≤ r.2.val)
    linarith
  have hp : (1 : ℚ) ≤ ((R : ℚ) + 1) ^ r.1.val := one_le_pow₀ (base_one_le R)
  have hprod : (1 : ℚ) * 1 ≤ ((r.2.val : ℚ) + 1) * ((R : ℚ) + 1) ^ r.1.val :=
    mul_le_mul hj hp (by norm_num) (by positivity)
  unfold heightCode
  linarith

theorem heightCode_lt_power (R : ℕ) {m : ℕ} (r : Position m R) :
    heightCode R r < ((R : ℚ) + 1) ^ m := by
  have hj : (r.2.val : ℚ) + 1 < (R : ℚ) + 1 := by
    exact_mod_cast Nat.add_lt_add_right r.2.isLt 1
  have hp : 0 < ((R : ℚ) + 1) ^ r.1.val := pow_pos (base_pos R) _
  have he : r.1.val + 1 ≤ m := r.1.isLt
  have hpow := pow_le_pow_right₀ (base_one_le R) he
  have hmul := mul_lt_mul_of_pos_right hj hp
  rw [pow_succ] at hpow
  unfold heightCode
  nlinarith

theorem baseline_lower (m R : ℕ) (r : Position m R) : 1 / 2 ≤ baseline m R r := by
  unfold baseline
  exact le_add_of_nonneg_right (mul_nonneg (gap_nonneg _ _) (heightCode_nonneg _ _))

theorem baseline_upper (m R : ℕ) (r : Position m R) : baseline m R r < 9 / 16 := by
  have h := mul_lt_mul_of_pos_left (heightCode_lt_power R r) (gap_pos m R)
  rw [gap_mul_power] at h
  unfold baseline
  linarith

theorem baseline_range (m R : ℕ) (r : Position m R) :
    1 / 2 ≤ baseline m R r ∧ baseline m R r < 9 / 16 :=
  ⟨baseline_lower _ _ _, baseline_upper _ _ _⟩

theorem beta_nonneg (m R : ℕ) (e : Fin m) : 0 ≤ beta m R e :=
  mul_nonneg (gap_nonneg _ _) (theta_nonneg _ _)

theorem beta_lt_one_sixteen (m R : ℕ) (e : Fin m) : beta m R e < 1 / 16 := by
  have h := mul_lt_mul_of_pos_left (theta_lt_power R e) (gap_pos m R)
  rwa [gap_mul_power] at h

theorem lambda_pos (m R D ell : ℕ) : 0 < lambda m R D ell :=
  div_pos (gap_pos _ _) (pow_pos (widthScale_pos D) ell)

theorem lambda_nonneg (m R D ell : ℕ) : 0 ≤ lambda m R D ell :=
  (lambda_pos _ _ _ _).le

@[simp] theorem lambda_zero (m R D : ℕ) : lambda m R D 0 = gap m R := by
  simp [lambda]

theorem lambda_succ (m R D ell : ℕ) :
    lambda m R D (ell + 1) = lambda m R D ell / (100 * ((D : ℚ) + 1)) := by
  simp only [lambda, pow_succ, div_div]

theorem lambda_antitone (m R D : ℕ) : Antitone (lambda m R D) := by
  intro a b hab
  exact div_le_div_of_nonneg_left (gap_nonneg m R) (pow_pos (widthScale_pos D) a)
    (pow_le_pow_right₀ (widthScale_one_le D) hab)

theorem lambda_le_gap (m R D ell : ℕ) : lambda m R D ell ≤ gap m R := by
  simpa only [lambda_zero] using lambda_antitone m R D (Nat.zero_le ell)

theorem lambda_le_one (m R D ell : ℕ) : lambda m R D ell ≤ 1 := by
  have h := (lambda_le_gap m R D ell).trans (gap_le_one_sixteen m R)
  linarith

theorem lambda_lt_tenth (m R D ell : ℕ) : lambda m R D ell < 1 / 10 := by
  have h := (lambda_le_gap m R D ell).trans (gap_le_one_sixteen m R)
  linarith

theorem lambda_one_le_hundredth (m R D : ℕ) : lambda m R D 1 ≤ gap m R / 100 := by
  unfold lambda
  rw [pow_one]
  apply div_le_div_of_nonneg_left (gap_nonneg _ _) (by norm_num)
  have hD : (0 : ℚ) ≤ D := Nat.cast_nonneg D
  linarith

theorem delta_pos (m R D L : ℕ) : 0 < delta m R D L :=
  div_pos (lambda_pos _ _ _ _) (by norm_num)

theorem delta_nonneg (m R D L : ℕ) : 0 ≤ delta m R D L := (delta_pos _ _ _ _).le

theorem delta_le_tenth (m R D : ℕ) {ell L : ℕ} (h : ell ≤ L) :
    delta m R D L ≤ lambda m R D ell / 10 :=
  div_le_div_of_nonneg_right (lambda_antitone m R D h) (by norm_num)

theorem delta_lt_gap (m R D L : ℕ) : delta m R D L < gap m R := by
  have hd := delta_le_tenth m R D (Nat.zero_le L)
  rw [lambda_zero] at hd
  have hg := gap_pos m R
  linarith

theorem lambda_one_add_two_delta_lt_gap (m R D : ℕ) {L : ℕ} (hL : 1 ≤ L) :
    lambda m R D 1 + 2 * delta m R D L < gap m R := by
  have hd := delta_le_tenth m R D hL
  have hl := lambda_one_le_hundredth m R D
  have hg := gap_pos m R
  linarith

theorem children_succ_lt_parent (m R D ell : ℕ) :
    (4 * (D : ℚ) + 1) * lambda m R D (ell + 1) < lambda m R D ell := by
  rw [lambda_succ, ← mul_div_assoc]
  apply (div_lt_iff₀ (widthScale_pos D)).2
  have hcoeff : 4 * (D : ℚ) + 1 < 100 * ((D : ℚ) + 1) := by
    have hD : (0 : ℚ) ≤ D := Nat.cast_nonneg D
    linarith
  simpa only [mul_comm] using mul_lt_mul_of_pos_right hcoeff (lambda_pos m R D ell)

theorem first_children_lt_gap_twentyfifth (m R D : ℕ) :
    (4 * (D : ℚ) + 1) * lambda m R D 1 < gap m R / 25 := by
  simp only [lambda, pow_one]
  rw [← mul_div_assoc]
  apply (div_lt_iff₀ (widthScale_pos D)).2
  have hcoeff : 25 * (4 * (D : ℚ) + 1) < 100 * ((D : ℚ) + 1) := by
    linarith
  have h := mul_lt_mul_of_pos_right hcoeff (gap_pos m R)
  nlinarith

theorem first_children_lt_tenth (m R D : ℕ) :
    (4 * (D : ℚ) + 1) * lambda m R D 1 < 1 / 10 := by
  have h := first_children_lt_gap_twentyfifth m R D
  have hg := gap_le_one_sixteen m R
  linarith

theorem lambda_add_delta_lt_three (m R D : ℕ) {ell L : ℕ} (h : ell ≤ L) :
    lambda m R D ell + delta m R D L < 3 * lambda m R D ell := by
  have hd := delta_le_tenth m R D h
  have hl := lambda_pos m R D ell
  linarith

end BinPackingGap.Geometry

namespace BinPackingGap

def completion (b : ℚ) (short : Bool) (globalLen localLen delta : ℚ) : ℚ :=
  b - (if short then delta else 0) - globalLen - localLen

def completionInterval (b : ℚ) (short : Bool) (globalLen localLen delta : ℚ) :
    Set ℚ := Set.Ico (completion b short globalLen localLen delta) b

@[simp] theorem completion_false (b globalLen localLen delta : ℚ) :
    completion b false globalLen localLen delta = b - globalLen - localLen := by
  simp [completion]

@[simp] theorem completion_true (b globalLen localLen delta : ℚ) :
    completion b true globalLen localLen delta = b - delta - globalLen - localLen := by
  simp [completion]

theorem baseline_sub_completion (b : ℚ) (short : Bool) (globalLen localLen delta : ℚ) :
    b - completion b short globalLen localLen delta =
      (if short then delta else 0) + globalLen + localLen := by
  unfold completion
  ring

theorem completion_le_baseline (b : ℚ) (short : Bool) (globalLen localLen delta : ℚ)
    (hglobal : 0 ≤ globalLen) (hlocal : 0 ≤ localLen) (hdelta : 0 ≤ delta) :
    completion b short globalLen localLen delta ≤ b := by
  cases short <;> simp only [completion_false, completion_true] <;> linarith

theorem completion_length_nonneg (b : ℚ) (short : Bool) (globalLen localLen delta : ℚ)
    (hglobal : 0 ≤ globalLen) (hlocal : 0 ≤ localLen) (hdelta : 0 ≤ delta) :
    0 ≤ b - completion b short globalLen localLen delta :=
  sub_nonneg.mpr (completion_le_baseline b short globalLen localLen delta
    hglobal hlocal hdelta)

@[simp] theorem mem_completionInterval (b : ℚ) (short : Bool)
    (globalLen localLen delta a : ℚ) :
    a ∈ completionInterval b short globalLen localLen delta ↔
      completion b short globalLen localLen delta ≤ a ∧ a < b := Iff.rfl

theorem completion_le_deadline_iff (b : ℚ) (short : Bool)
    (globalLen localLen delta deadline : ℚ) :
    completion b short globalLen localLen delta ≤ deadline ↔
      b - (if short then delta else 0) - globalLen - localLen - deadline ≤ 0 := by
  unfold completion
  exact sub_nonpos.symm

theorem completion_zero_global_length_le (b : ℚ) (short : Bool) (localLen delta : ℚ)
    (hdelta : 0 ≤ delta) :
    b - completion b short 0 localLen delta ≤ localLen + delta := by
  cases short <;> simp only [completion_false, completion_true] <;> linarith

theorem completion_zero_global_interval_subset (b : ℚ) (short : Bool)
    (localLen delta : ℚ) (hdelta : 0 ≤ delta) :
    completionInterval b short 0 localLen delta ⊆ Set.Ico (b - (localLen + delta)) b := by
  intro a ha
  have hlength := completion_zero_global_length_le b short localLen delta hdelta
  exact ⟨by linarith [ha.1], ha.2⟩

theorem completion_zero_global_bounds (b : ℚ) (short : Bool) (localLen delta : ℚ)
    (hlocal : 0 ≤ localLen) (hdelta : 0 ≤ delta) :
    completion b short 0 localLen delta ∈ Set.Icc (b - (localLen + delta)) b := by
  constructor
  · linarith [completion_zero_global_length_le b short localLen delta hdelta]
  · exact completion_le_baseline b short 0 localLen delta le_rfl hlocal hdelta

@[simp] theorem completion_long_zero_lengths (b delta : ℚ) :
    completion b false 0 0 delta = b := by simp

@[simp] theorem completion_short_zero_lengths (b delta : ℚ) :
    completion b true 0 0 delta = b - delta := by simp

@[simp] theorem completionInterval_long_zero_lengths (b delta : ℚ) :
    completionInterval b false 0 0 delta = ∅ := by
  simp [completionInterval]

theorem completionInterval_short_zero_lengths (b delta : ℚ) :
    completionInterval b true 0 0 delta = Set.Ico (b - delta) b := by
  simp [completionInterval]

theorem completion_plus_le_one (b : ℚ) (short : Bool) (globalLen localLen delta : ℚ)
    (hbaseline : b ≤ 1) (hglobal : 0 ≤ globalLen) (hlocal : 0 ≤ localLen)
    (hdelta : 0 ≤ delta) : completion b short globalLen localLen delta ≤ 1 :=
  (completion_le_baseline b short globalLen localLen delta hglobal hlocal hdelta).trans
    hbaseline

theorem completion_minus_gt_one (b : ℚ) (short : Bool) (globalLen localLen delta lambdaOne : ℚ)
    (hbaseline : 4 ≤ b) (hshort : short = false) (hglobal : globalLen ≤ 1)
    (hlocal : localLen ≤ lambdaOne) (hlambda : lambdaOne < 1) :
    1 < completion b short globalLen localLen delta := by
  subst short
  rw [completion_false]
  linarith

theorem not_mem_plus_completionInterval (b : ℚ) (short : Bool)
    (globalLen localLen delta a : ℚ) (hbaseline : b ≤ 1) (ha : 1 ≤ a) :
    a ∉ completionInterval b short globalLen localLen delta := by
  intro hmem
  linarith [hmem.2]

theorem not_mem_minus_completionInterval (b : ℚ) (short : Bool)
    (globalLen localLen delta lambdaOne a : ℚ) (hbaseline : 4 ≤ b)
    (hshort : short = false) (hglobal : globalLen ≤ 1)
    (hlocal : localLen ≤ lambdaOne) (hlambda : lambdaOne < 1) (ha : a ≤ 1) :
    a ∉ completionInterval b short globalLen localLen delta := by
  intro hmem
  have hh := completion_minus_gt_one b short globalLen localLen delta lambdaOne
    hbaseline hshort hglobal hlocal hlambda
  linarith [hmem.1]

theorem completion_zero_global_geometry_length_le (m R D L ell : ℕ)
    (b : ℚ) (short : Bool) :
    b - completion b short 0 (Geometry.lambda m R D ell) (Geometry.delta m R D L) ≤
      Geometry.lambda m R D ell + Geometry.delta m R D L :=
  completion_zero_global_length_le b short _ _ (Geometry.delta_nonneg m R D L)

theorem completion_minus_geometry_gt_one (m R D L : ℕ) (b : ℚ) (short : Bool)
    (globalLen localLen : ℚ) (hbaseline : 4 ≤ b) (hshort : short = false)
    (hglobal : globalLen ≤ 1) (hlocal : localLen ≤ Geometry.lambda m R D 1) :
    1 < completion b short globalLen localLen (Geometry.delta m R D L) := by
  apply completion_minus_gt_one b short globalLen localLen _ (Geometry.lambda m R D 1)
    hbaseline hshort hglobal hlocal
  linarith [Geometry.lambda_lt_tenth m R D 1]

theorem completion_job_interval (m R D L : ℕ) (r : Geometry.Position m R) :
    completionInterval (Geometry.baseline m R r) true 0 0 (Geometry.delta m R D L) =
      Set.Ico (Geometry.baseline m R r - Geometry.delta m R D L)
        (Geometry.baseline m R r) :=
  completionInterval_short_zero_lengths _ _

end BinPackingGap

end OAI
end LocalizedSource06
/- END LOCALIZED SOURCE 06/44: OAI/Computability/BinPacking/Trees/CompletionGeometry.lean -/

/- BEGIN LOCALIZED SOURCE 07/44: OAI/Computability/BinPacking/Inventory/CurrentMatches.lean
   SHA256: 8ec5a70e03d856977b2d5fda55eac69b3530d19d8838d5657c98d14e2674e7a0 -/
section LocalizedSource07
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Data.Finset.Card
-- localized import: Mathlib.Data.Finset.Max
-- localized import: Mathlib.Data.Finset.Prod
-- localized import: Mathlib.Data.Fintype.EquivFin
-- localized import: Mathlib.Order.Interval.Set.Disjoint
-- localized import: OAI.Computability.BinPacking.Packing.FiniteHall
-- localized import: OAI.Computability.BinPacking.Packing.PackingScalar
-- localized import: OAI.Computability.BinPacking.Trees.CompletionGeometry

namespace OAI

noncomputable section

namespace BinPackingGap
namespace CoverageCounts

section FiniteCounts

variable {α β γ : Type*} [DecidableEq α] [DecidableEq β]

theorem interval_prefix_card [LinearOrder γ] (s : Finset α) (h b : α → γ)
    (hle : ∀ i ∈ s, h i ≤ b i) (a : γ) :
    (s.filter fun i => h i ≤ a).card =
      (s.filter fun i => b i ≤ a).card +
        (s.filter fun i => h i ≤ a ∧ a < b i).card := by
  classical
  have hunion : (s.filter fun i => h i ≤ a) =
      (s.filter fun i => b i ≤ a) ∪
        (s.filter fun i => h i ≤ a ∧ a < b i) := by
    ext i
    simp only [Finset.mem_filter, Finset.mem_union]
    constructor
    · rintro ⟨his, hia⟩
      by_cases hba : b i ≤ a
      · exact Or.inl ⟨his, hba⟩
      · exact Or.inr ⟨his, hia, lt_of_not_ge hba⟩
    · rintro (⟨his, hba⟩ | ⟨his, hia, _⟩)
      · exact ⟨his, (hle i his).trans hba⟩
      · exact ⟨his, hia⟩
  have hdis : Disjoint (s.filter fun i => b i ≤ a)
      (s.filter fun i => h i ≤ a ∧ a < b i) := by
    apply Finset.disjoint_left.mpr
    intro i hi hj
    exact (not_lt_of_ge (Finset.mem_filter.mp hi).2)
      (Finset.mem_filter.mp hj).2.2
  rw [hunion, Finset.card_union_of_disjoint hdis]

omit [DecidableEq α] in
theorem ordered_short_long_partition [LinearOrder γ]
    (s : Finset α) (position : α → γ) (current : γ) (short : α → Prop)
    [DecidablePred short] (horder : ∀ i ∈ s, position i ≤ current) :
    s.card = (s.filter fun i => position i < current).card +
      (s.filter fun i => position i = current ∧ short i).card +
      (s.filter fun i => position i = current ∧ ¬ short i).card := by
  classical
  have hexact : (s.filter fun i => ¬ position i < current) =
      (s.filter fun i => position i = current) := by
    ext i
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨his, hi⟩
      exact ⟨his, le_antisymm (horder i his) (le_of_not_gt hi)⟩
    · rintro ⟨his, hi⟩
      exact ⟨his, by rw [hi]; exact lt_irrefl _⟩
  have hpositions := Finset.card_filter_add_card_filter_not
    (s := s) (fun i => position i < current)
  rw [hexact] at hpositions
  have hlengths := Finset.card_filter_add_card_filter_not
    (s := s.filter fun i => position i = current) short
  simp only [Finset.filter_filter] at hlengths
  omega

theorem card_le_good_card_add {s bad : Finset α} {K : ℕ}
    (hbad : bad.card ≤ K) : s.card ≤ (s \ bad).card + K := by
  have hinter : (s ∩ bad).card ≤ K :=
    (Finset.card_le_card Finset.inter_subset_right).trans hbad
  have hsplit := Finset.card_sdiff_add_card_inter s bad
  omega

omit [DecidableEq β] in
theorem card_le_target_add_loss {s bad : Finset α} {t : Finset β} {K : ℕ}
    (f : α → β) (hbad : bad.card ≤ K)
    (hmap : ∀ i ∈ s \ bad, f i ∈ t)
    (hinj : Set.InjOn f (↑(s \ bad : Finset α) : Set α)) : s.card ≤ t.card + K := by
  have hgood := Finset.card_le_card_of_injOn f hmap hinj
  have htotal := card_le_good_card_add (s := s) hbad
  omega

omit [DecidableEq β] in
theorem card_add_card_le_of_disjoint_injections
    (s t : Finset α) (resources : Finset β) (row : α → β)
    (hdis : Disjoint s t)
    (hmap : ∀ i ∈ s ∪ t, row i ∈ resources)
    (hinj : Set.InjOn row (↑(s ∪ t : Finset α) : Set α)) : s.card + t.card ≤ resources.card := by
  rw [← Finset.card_union_of_disjoint hdis]
  exact Finset.card_le_card_of_injOn row hmap hinj

omit [DecidableEq β] in
theorem card_three_le_of_disjoint_injections
    (s t u : Finset α) (resources : Finset β) (row : α → β)
    (hst : Disjoint s t) (hsu : Disjoint s u) (htu : Disjoint t u)
    (hmap : ∀ i ∈ (s ∪ t) ∪ u, row i ∈ resources)
    (hinj : Set.InjOn row (↑((s ∪ t) ∪ u : Finset α) : Set α)) :
    s.card + t.card + u.card ≤ resources.card := by
  have hdis : Disjoint (s ∪ t) u := by
    apply Finset.disjoint_left.mpr
    intro i hi hu
    rcases Finset.mem_union.mp hi with hs | ht
    · exact Finset.disjoint_left.mp hsu hs hu
    · exact Finset.disjoint_left.mp htu ht hu
  have hcount := card_add_card_le_of_disjoint_injections
    (s ∪ t) u resources row hdis hmap hinj
  rwa [Finset.card_union_of_disjoint hst] at hcount

theorem card_le_add_of_subset_union (s t u : Finset α) (h : s ⊆ t ∪ u) :
    s.card ≤ t.card + u.card :=
  (Finset.card_le_card h).trans (Finset.card_union_le _ _)

end FiniteCounts

theorem displaced_baseline_bound {A B tree jobs used goodEarlier ξ K : ℕ}
    (hA : A ≤ tree + used) (hB : B = tree + jobs)
    (hrows : used + goodEarlier + ξ ≤ 2 * jobs)
    (hkeys : jobs ≤ goodEarlier + 3 * K) : A + ξ ≤ B + 3 * K := by
  omega

theorem coverage_lower_bound {A B C I d K : ℕ}
    (hpartition : C = A + I) (hdeadline : B + d ≤ C + 3 * K)
    (hbaseline : A ≤ B + 3 * K) : d ≤ I + 6 * K := by
  omega

theorem displaced_short_correction {A B C I d K ξ xplus shortM : ℕ}
    (hpartition : C = A + I) (hdeadline : B + d ≤ C + 3 * K)
    (hbaseline : A + ξ ≤ B + 3 * K) (hcoverage : I ≤ xplus + shortM) :
    d + ξ ≤ xplus + shortM + 6 * K := by
  omega

theorem short_le_displaced_add_long {d K ξ goodCurrent shortM shortG longG : ℕ}
    (hkeys : d ≤ goodCurrent + 3 * K)
    (hpartition : goodCurrent = ξ + shortG + longG)
    (hshort : shortM + shortG ≤ d) : shortM ≤ ξ + longG + 3 * K := by
  omega

theorem long_match_lower_bound {d K ξ xplus shortM longG : ℕ}
    (hcorrection : d + ξ ≤ xplus + shortM + 6 * K)
    (hshort : shortM ≤ ξ + longG + 3 * K) :
    d ≤ longG + xplus + 9 * K := by
  omega

end CoverageCounts
end BinPackingGap

namespace BinPackingGap.IntervalCoverage

variable {ι κ τ α : Type*} [LinearOrder α]

def prefixSet [Fintype ι] (f : ι → α) (a : α) : Finset ι := by
  classical
  exact Finset.univ.filter fun i => f i ≤ a

def prefixCount [Fintype ι] (f : ι → α) (a : α) : ℕ := (prefixSet f a).card

def coverageSet [Fintype ι] (h b : ι → α) (a : α) : Finset ι := by
  classical
  exact Finset.univ.filter fun i => h i ≤ a ∧ a < b i

def coverageCount [Fintype ι] (h b : ι → α) (a : α) : ℕ :=
  (coverageSet h b a).card

@[simp] theorem mem_prefixSet [Fintype ι] (f : ι → α) (a : α) (i : ι) :
    i ∈ prefixSet f a ↔ f i ≤ a := by
  classical
  simp [prefixSet]

@[simp] theorem mem_coverageSet [Fintype ι] (h b : ι → α) (a : α) (i : ι) :
    i ∈ coverageSet h b a ↔ h i ≤ a ∧ a < b i := by
  classical
  simp [coverageSet]

theorem completion_prefix_identity [Fintype ι] (h b : ι → α)
    (hle : ∀ i, h i ≤ b i) (a : α) :
    prefixCount h a = prefixCount b a + coverageCount h b a := by
  classical
  simpa only [prefixCount, coverageCount, prefixSet, coverageSet] using
    CoverageCounts.interval_prefix_card Finset.univ h b (fun i _ => hle i) a

structure ShiftData (Copy Test : Type*) (d : ℕ) (Coordinate : Type*)
    [LinearOrder Coordinate] where
  baseline : Copy → Coordinate
  left : Test → Coordinate
  right : Test → Coordinate
  designated : (Test × Fin d) ↪ Copy
  baseline_designated : ∀ q, baseline (designated q) = right q.1
  left_le_right : ∀ t, left t ≤ right t

namespace ShiftData

variable {d : ℕ} (D : ShiftData ι τ d α)

local instance : DecidableEq ι := Classical.decEq ι

def deadline (i : ι) : α := by
  classical
  exact if hi : ∃ q, D.designated q = i then D.left (Classical.choose hi).1
    else D.baseline i

@[simp] theorem deadline_designated (q : τ × Fin d) :
    D.deadline (D.designated q) = D.left q.1 := by
  classical
  have hi : ∃ q', D.designated q' = D.designated q := ⟨q, rfl⟩
  have heq : Classical.choose hi = q := D.designated.injective (Classical.choose_spec hi)
  simp only [deadline, dite_eq_left hi, heq]

theorem deadline_undesignated (i : ι) (hi : ∀ q, D.designated q ≠ i) :
    D.deadline i = D.baseline i := by
  classical
  have hn : ¬ ∃ q, D.designated q = i := by
    rintro ⟨q, hq⟩
    exact hi q hq
  simp only [deadline, dite_eq_right hn]

theorem designated_block_card (t : τ) :
    ((Finset.univ : Finset (Fin d)).image (fun j => D.designated (t, j))).card = d := by
  classical
  rw [Finset.card_image_of_injective]
  · exact Fintype.card_fin d
  · intro j k hjk
    exact congrArg Prod.snd (D.designated.injective hjk)

def activeTests [Fintype τ] (a : α) : Finset τ := by
  classical
  exact Finset.univ.filter fun t => D.left t ≤ a ∧ a < D.right t

@[simp] theorem mem_activeTests [Fintype τ] (a : α) (t : τ) :
    t ∈ D.activeTests a ↔ D.left t ≤ a ∧ a < D.right t := by
  classical
  simp [activeTests]

theorem deadline_prefix_of_agrees [Fintype ι] [Fintype τ]
    (z : ι → α)
    (hdesignated : ∀ q, z (D.designated q) = D.left q.1)
    (hother : ∀ i, (∀ q, D.designated q ≠ i) → z i = D.baseline i)
    (a : α) :
    prefixCount z a = prefixCount D.baseline a + d * (D.activeTests a).card := by
  classical
  have hle : ∀ i, z i ≤ D.baseline i := by
    intro i
    by_cases hi : ∃ q, D.designated q = i
    · obtain ⟨q, rfl⟩ := hi
      rw [hdesignated, D.baseline_designated]
      exact D.left_le_right q.1
    · rw [hother i (by simpa only [not_exists] using hi)]
  have hset : coverageSet z D.baseline a =
      ((D.activeTests a).product (Finset.univ : Finset (Fin d))).map D.designated := by
    ext i
    simp only [mem_coverageSet, Finset.mem_map, Finset.product_eq_sprod, Finset.mem_product,
      mem_activeTests, Finset.mem_univ, and_true]
    constructor
    · intro hi
      have hex : ∃ q, D.designated q = i := by
        by_contra hn
        have he := hother i (by simpa only [not_exists] using hn)
        exact (not_lt_of_ge (he ▸ hi.1)) hi.2
      obtain ⟨q, rfl⟩ := hex
      exact ⟨q, by simpa only [hdesignated, D.baseline_designated] using hi, rfl⟩
    · rintro ⟨q, hq, rfl⟩
      simpa only [hdesignated, D.baseline_designated] using hq
  rw [completion_prefix_identity z D.baseline hle a]
  unfold coverageCount
  rw [hset, Finset.card_map, Finset.product_eq_sprod, Finset.card_product,
    Finset.card_univ, Fintype.card_fin]
  rw [Nat.mul_comm]

theorem deadline_prefix [Fintype ι] [Fintype τ] (a : α) :
    prefixCount D.deadline a = prefixCount D.baseline a + d * (D.activeTests a).card :=
  D.deadline_prefix_of_agrees D.deadline D.deadline_designated D.deadline_undesignated a

theorem activeTests_card [Fintype τ]
    (hdisjoint : ∀ s t, s ≠ t →
      Disjoint (Set.Ico (D.left s) (D.right s)) (Set.Ico (D.left t) (D.right t)))
    (a : α) :
    (D.activeTests a).card = if ∃ t, D.left t ≤ a ∧ a < D.right t then 1 else 0 := by
  classical
  have hle : (D.activeTests a).card ≤ 1 := by
    apply Finset.card_le_one.mpr
    intro s hs t ht
    by_contra hst
    exact Set.disjoint_left.mp (hdisjoint s t hst)
      (D.mem_activeTests a s |>.mp hs) (D.mem_activeTests a t |>.mp ht)
  split_ifs with hex
  · obtain ⟨t, ht⟩ := hex
    have hpos := Finset.card_pos.mpr ⟨t, (D.mem_activeTests a t).mpr ht⟩
    omega
  · apply Finset.card_eq_zero.mpr
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro t ht
    exact hex ⟨t, (D.mem_activeTests a t).mp ht⟩

theorem deadline_prefix_disjoint_of_agrees [Fintype ι] [Fintype τ]
    (z : ι → α)
    (hdesignated : ∀ q, z (D.designated q) = D.left q.1)
    (hother : ∀ i, (∀ q, D.designated q ≠ i) → z i = D.baseline i)
    (hdisjoint : ∀ s t, s ≠ t →
      Disjoint (Set.Ico (D.left s) (D.right s)) (Set.Ico (D.left t) (D.right t)))
    (a : α) :
    prefixCount z a = prefixCount D.baseline a +
      d * (if ∃ t, D.left t ≤ a ∧ a < D.right t then 1 else 0) := by
  rw [D.deadline_prefix_of_agrees z hdesignated hother, D.activeTests_card hdisjoint]

theorem deadline_prefix_disjoint [Fintype ι] [Fintype τ]
    (hdisjoint : ∀ s t, s ≠ t →
      Disjoint (Set.Ico (D.left s) (D.right s)) (Set.Ico (D.left t) (D.right t)))
    (a : α) :
    prefixCount D.deadline a = prefixCount D.baseline a +
      d * (if ∃ t, D.left t ≤ a ∧ a < D.right t then 1 else 0) :=
  D.deadline_prefix_disjoint_of_agrees D.deadline D.deadline_designated
    D.deadline_undesignated hdisjoint a

end ShiftData

theorem exists_equiv_of_prefix_dominance [Fintype ι] [Fintype κ]
    (h : ι → α) (z : κ → α) (hcard : Fintype.card ι = Fintype.card κ)
    (hprefix : ∀ a, prefixCount z a ≤ prefixCount h a) :
    ∃ e : ι ≃ κ, ∀ i, h i ≤ z (e i) := by
  classical
  let neighbors : ι → Finset κ := fun i => Finset.univ.filter fun j => h i ≤ z j
  have hall : ∀ s : Finset ι, s.card ≤ (s.biUnion neighbors).card := by
    intro s
    let N := s.biUnion neighbors
    let bad := (Finset.univ : Finset κ) \ N
    have hpartition : bad.card + N.card = Fintype.card κ := by
      simpa only [bad, Finset.card_univ] using
        Finset.card_sdiff_add_card_eq_card (Finset.subset_univ N)
    by_cases hbad : bad.Nonempty
    · obtain ⟨j, hj, hmax⟩ := bad.exists_max_image z hbad
      have hN : j ∉ N := (Finset.mem_sdiff.mp hj).2
      have hd : Disjoint s (prefixSet h (z j)) := by
        apply Finset.disjoint_left.mpr
        intro i hi hip
        apply hN
        exact Finset.mem_biUnion.mpr ⟨i, hi, by
          simpa only [neighbors, Finset.mem_filter, Finset.mem_univ, true_and,
            mem_prefixSet] using hip⟩
      have hsum : s.card + prefixCount h (z j) ≤ Fintype.card ι := by
        rw [prefixCount, ← Finset.card_union_of_disjoint hd]
        exact Finset.card_le_univ _
      have hb : bad.card ≤ prefixCount z (z j) := by
        apply Finset.card_le_card
        intro k hk
        exact (mem_prefixSet z (z j) k).mpr (hmax k hk)
      have hp := hprefix (z j)
      change s.card ≤ N.card
      omega
    · have hb : bad.card = 0 := Finset.card_eq_zero.mpr
        (Finset.not_nonempty_iff_eq_empty.mp hbad)
      have hs := Finset.card_le_univ s
      change s.card ≤ N.card
      omega
  obtain ⟨f, hf, hmatch⟩ :=
    (FiniteHall.all_card_le_biUnion_card_iff_existsInjective neighbors).mp hall
  have hbij : Function.Bijective f :=
    (Fintype.bijective_iff_injective_and_card f).mpr ⟨hf, hcard⟩
  refine ⟨Equiv.ofBijective f hbij, ?_⟩
  intro i
  change h i ≤ z (f i)
  have hi := hmatch i
  simpa only [neighbors, Finset.mem_filter, Finset.mem_univ, true_and] using hi

end BinPackingGap.IntervalCoverage

namespace BinPackingGap
namespace Coverage

variable {I : Instance} {b n : ℕ}

def goodTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) : Finset (p.TableBin cls) := by
  classical
  exact Finset.univ.filter fun t => p.IsGoodTableBin cls label t ∧
    label (p.itemAtRole cls t .anchor) = some v

def mainTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) : Finset (p.TableBin cls) := by
  classical
  exact (goodTuplesAt p cls label v).filter fun t => p.tablePattern cls t ≠ .edgeJob

def edgeTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) : Finset (p.TableBin cls) := by
  classical
  exact (goodTuplesAt p cls label v).filter fun t => p.tablePattern cls t = .edgeJob

@[simp] theorem mem_goodTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (t : p.TableBin cls) :
    t ∈ goodTuplesAt p cls label v ↔ p.IsGoodTableBin cls label t ∧
      label (p.itemAtRole cls t .anchor) = some v := by
  classical
  simp [goodTuplesAt]

@[simp] theorem mem_mainTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (t : p.TableBin cls) :
    t ∈ mainTuplesAt p cls label v ↔ p.IsGoodTableBin cls label t ∧
      label (p.itemAtRole cls t .anchor) = some v ∧
        p.tablePattern cls t ≠ .edgeJob := by
  classical
  simp [mainTuplesAt, and_assoc]

@[simp] theorem mem_edgeTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (t : p.TableBin cls) :
    t ∈ edgeTuplesAt p cls label v ↔ p.IsGoodTableBin cls label t ∧
      label (p.itemAtRole cls t .anchor) = some v ∧
        p.tablePattern cls t = .edgeJob := by
  classical
  simp [edgeTuplesAt, and_assoc]

theorem mainTuplesAt_subset_good (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) :
    mainTuplesAt p cls label v ⊆ goodTuplesAt p cls label v := by
  classical
  exact Finset.filter_subset _ _

theorem edgeTuplesAt_subset_good (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) :
    edgeTuplesAt p cls label v ⊆ goodTuplesAt p cls label v := by
  classical
  exact Finset.filter_subset _ _

theorem goodTuplesAt_eq_union (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) :
    goodTuplesAt p cls label v =
      mainTuplesAt p cls label v ∪ edgeTuplesAt p cls label v := by
  classical
  ext t
  by_cases h : p.tablePattern cls t = .edgeJob <;>
    simp [mainTuplesAt, edgeTuplesAt, h]

theorem mainTuplesAt_disjoint_edge (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v w : Fin n) :
    Disjoint (mainTuplesAt p cls label v) (edgeTuplesAt p cls label w) := by
  apply Finset.disjoint_left.mpr
  intro t ht hu
  exact ((mem_mainTuplesAt p cls label v t).mp ht).2.2
    (((mem_edgeTuplesAt p cls label w t).mp hu).2.2)

theorem goodTuplesAt_disjoint_label (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) {v w : Fin n} (hvw : v ≠ w) :
    Disjoint (goodTuplesAt p cls label v) (goodTuplesAt p cls label w) := by
  apply Finset.disjoint_left.mpr
  intro t ht hu
  have hv := ((mem_goodTuplesAt p cls label v t).mp ht).2
  have hw := ((mem_goodTuplesAt p cls label w t).mp hu).2
  exact hvw (Option.some.inj (hv.symm.trans hw))

theorem mainTuplesAt_disjoint_label (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) {v w : Fin n} (hvw : v ≠ w) :
    Disjoint (mainTuplesAt p cls label v) (mainTuplesAt p cls label w) :=
  (goodTuplesAt_disjoint_label p cls label hvw).mono
    (mainTuplesAt_subset_good p cls label v) (mainTuplesAt_subset_good p cls label w)

theorem edgeTuplesAt_disjoint_label (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) {v w : Fin n} (hvw : v ≠ w) :
    Disjoint (edgeTuplesAt p cls label v) (edgeTuplesAt p cls label w) :=
  (goodTuplesAt_disjoint_label p cls label hvw).mono
    (edgeTuplesAt_subset_good p cls label v) (edgeTuplesAt_subset_good p cls label w)

def roleItems (p : Packing I b) (cls : I.Item → Subclass)
    (s : Finset (p.TableBin cls)) (role : Role) : Finset I.Item :=
  s.image fun t => p.itemAtRole cls t role

@[simp] theorem roleItems_card (p : Packing I b) (cls : I.Item → Subclass)
    (s : Finset (p.TableBin cls)) (role : Role) : (roleItems p cls s role).card = s.card :=
  Finset.card_image_of_injective s (p.itemAtRole_injective cls role)

def anchorItemsAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i => (cls i).role = .anchor ∧ label i = some v

@[simp] theorem mem_anchorItemsAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (i : I.Item) :
    i ∈ anchorItemsAt (I := I) cls label v ↔
      (cls i).role = .anchor ∧ label i = some v := by
  classical
  simp [anchorItemsAt]

def badAnchorsAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) : Finset I.Item :=
  anchorItemsAt (I := I) cls label v \
    roleItems p cls (goodTuplesAt p cls label v) .anchor

@[simp] theorem mem_badAnchorsAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (i : I.Item) :
    i ∈ badAnchorsAt p cls label v ↔
      i ∈ anchorItemsAt (I := I) cls label v ∧
        i ∉ roleItems p cls (goodTuplesAt p cls label v) .anchor := by
  simp only [badAnchorsAt, Finset.mem_sdiff]

theorem good_anchorItems_subset (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) :
    roleItems p cls (goodTuplesAt p cls label v) .anchor ⊆
      anchorItemsAt (I := I) cls label v := by
  intro i hi
  obtain ⟨t, ht, rfl⟩ := Finset.mem_image.mp hi
  exact (mem_anchorItemsAt cls label v _).mpr
    ⟨p.itemAtRole_role cls t .anchor, ((mem_goodTuplesAt p cls label v t).mp ht).2⟩

theorem card_le_role_resources (p : Packing I b) (cls : I.Item → Subclass)
    (s : Finset (p.TableBin cls)) (role : Role) (resources : Finset I.Item)
    (hmap : ∀ t ∈ s, p.itemAtRole cls t role ∈ resources) : s.card ≤ resources.card :=
  Finset.card_le_card_of_injOn (fun t => p.itemAtRole cls t role) hmap
    (p.itemAtRole_injective cls role).injOn

theorem card_three_le_row_resources (p : Packing I b) (cls : I.Item → Subclass)
    (s t u : Finset (p.TableBin cls)) (resources : Finset I.Item)
    (hst : Disjoint s t) (hsu : Disjoint s u) (htu : Disjoint t u)
    (hmap : ∀ x ∈ (s ∪ t) ∪ u, p.itemAtRole cls x .x ∈ resources) :
    s.card + t.card + u.card ≤ resources.card :=
  CoverageCounts.card_three_le_of_disjoint_injections s t u resources
    (fun x => p.itemAtRole cls x .x) hst hsu htu hmap
    (p.itemAtRole_injective cls .x).injOn

def tupleCompletion (p : Packing I b) (cls : I.Item → Subclass)
    (baseline : I.Item → ℚ) (short : I.Item → Bool)
    (globalLen localLen : I.Item → ℚ) (delta : ℚ) (t : p.TableBin cls) : ℚ :=
  completion (baseline (p.itemAtRole cls t .x)) (short (p.itemAtRole cls t .x))
    (globalLen (p.itemAtRole cls t .«global»))
    (localLen (p.itemAtRole cls t .«local»)) delta

theorem tupleCompletion_le_baseline (p : Packing I b) (cls : I.Item → Subclass)
    (baseline : I.Item → ℚ) (short : I.Item → Bool)
    (globalLen localLen : I.Item → ℚ) (delta : ℚ)
    (hglobal : ∀ i, 0 ≤ globalLen i) (hlocal : ∀ i, 0 ≤ localLen i)
    (hdelta : 0 ≤ delta) (t : p.TableBin cls) :
    tupleCompletion p cls baseline short globalLen localLen delta t ≤
      baseline (p.itemAtRole cls t .x) :=
  completion_le_baseline _ _ _ _ _ (hglobal _) (hlocal _) hdelta

def baselinePrefixAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (a : ℚ) : Finset (p.TableBin cls) :=
  (mainTuplesAt p cls label v).filter fun t => baseline (p.itemAtRole cls t .x) ≤ a

def completionPrefixAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (finish : p.TableBin cls → ℚ) (a : ℚ) : Finset (p.TableBin cls) :=
  (mainTuplesAt p cls label v).filter fun t => finish t ≤ a

def coveringTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (finish : p.TableBin cls → ℚ) (a : ℚ) :
    Finset (p.TableBin cls) :=
  (mainTuplesAt p cls label v).filter fun t =>
    finish t ≤ a ∧ a < baseline (p.itemAtRole cls t .x)

theorem completion_prefix_decomposition (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (finish : p.TableBin cls → ℚ)
    (hle : ∀ t ∈ mainTuplesAt p cls label v, finish t ≤ baseline (p.itemAtRole cls t .x))
    (a : ℚ) :
    (completionPrefixAt p cls label v finish a).card =
      (baselinePrefixAt p cls label v baseline a).card +
        (coveringTuplesAt p cls label v baseline finish a).card :=
  CoverageCounts.interval_prefix_card (mainTuplesAt p cls label v) finish
    (fun t => baseline (p.itemAtRole cls t .x)) hle a

theorem literal_completion_prefix_decomposition
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (short : I.Item → Bool)
    (globalLen localLen : I.Item → ℚ) (delta a : ℚ)
    (hglobal : ∀ i, 0 ≤ globalLen i) (hlocal : ∀ i, 0 ≤ localLen i)
    (hdelta : 0 ≤ delta) :
    (completionPrefixAt p cls label v
      (tupleCompletion p cls baseline short globalLen localLen delta) a).card =
      (baselinePrefixAt p cls label v baseline a).card +
        (coveringTuplesAt p cls label v baseline
          (tupleCompletion p cls baseline short globalLen localLen delta) a).card :=
  completion_prefix_decomposition p cls label v baseline _
    (fun t _ => tupleCompletion_le_baseline p cls baseline short globalLen localLen delta
      hglobal hlocal hdelta t) a

def deadlinePrefixAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (deadline : I.Item → ℚ) (a : ℚ) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i => cls i = .z ∧ label i = some v ∧ deadline i ≤ a

@[simp] theorem mem_deadlinePrefixAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (deadline : I.Item → ℚ) (a : ℚ) (i : I.Item) :
    i ∈ deadlinePrefixAt (I := I) cls label v deadline a ↔
      cls i = .z ∧ label i = some v ∧ deadline i ≤ a := by
  classical
  simp [deadlinePrefixAt]

theorem good_deadline_subset_completed_anchor_image
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (deadline : I.Item → ℚ) (finish : p.TableBin cls → ℚ) (a : ℚ)
    (hfeasible : ∀ t ∈ mainTuplesAt p cls label v,
      finish t ≤ deadline (p.itemAtRole cls t .anchor)) :
    deadlinePrefixAt (I := I) cls label v deadline a \ badAnchorsAt p cls label v ⊆
      roleItems p cls (completionPrefixAt p cls label v finish a) .anchor := by
  classical
  intro i hi
  obtain ⟨hi, hnotbad⟩ := Finset.mem_sdiff.mp hi
  obtain ⟨hcls, hlabel, hdeadline⟩ :=
    (mem_deadlinePrefixAt cls label v deadline a i).mp hi
  have hanchor : i ∈ anchorItemsAt (I := I) cls label v := by
    apply (mem_anchorItemsAt cls label v i).mpr
    exact ⟨by rw [hcls]; rfl, hlabel⟩
  have hused : i ∈ roleItems p cls (goodTuplesAt p cls label v) .anchor := by
    by_contra h
    exact hnotbad ((mem_badAnchorsAt p cls label v i).mpr ⟨hanchor, h⟩)
  obtain ⟨t, ht, hti⟩ := Finset.mem_image.mp hused
  have hM : t ∈ mainTuplesAt p cls label v := by
    have htgood := (mem_goodTuplesAt p cls label v t).mp ht
    refine (mem_mainTuplesAt p cls label v t).mpr ⟨htgood.1, htgood.2, ?_⟩
    intro hedge
    have hsub := p.itemAtRole_subclass cls t .anchor
    rw [hedge] at hsub
    have hnot : (Subclass.z : Subclass) = .y := by
      calc
        Subclass.z = cls i := hcls.symm
        _ = cls (p.itemAtRole cls t .anchor) := congrArg cls hti.symm
        _ = Subclass.y := hsub
    cases hnot
  apply Finset.mem_image.mpr
  refine ⟨t, ?_, hti⟩
  apply Finset.mem_filter.mpr
  refine ⟨hM, (hfeasible t hM).trans ?_⟩
  simpa only [hti] using hdeadline

theorem deadline_prefix_le_completion_add_loss
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (deadline : I.Item → ℚ) (finish : p.TableBin cls → ℚ) (a : ℚ) (K : ℕ)
    (hbad : (badAnchorsAt p cls label v).card ≤ 3 * K)
    (hfeasible : ∀ t ∈ mainTuplesAt p cls label v,
      finish t ≤ deadline (p.itemAtRole cls t .anchor)) :
    (deadlinePrefixAt (I := I) cls label v deadline a).card ≤
      (completionPrefixAt p cls label v finish a).card + 3 * K := by
  have hcount := Finset.card_le_card
    (good_deadline_subset_completed_anchor_image p cls label v deadline finish a hfeasible)
  rw [roleItems_card] at hcount
  have hloss := CoverageCounts.card_le_good_card_add
    (s := deadlinePrefixAt (I := I) cls label v deadline a) hbad
  omega

def jobRowPrefixAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (a : ℚ) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i => cls i = .s ∧ label i = some v ∧ baseline i ≤ a

def treeRowPrefixAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (a : ℚ) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i =>
    (cls i = .tp ∨ cls i = .tm) ∧ label i = some v ∧ baseline i ≤ a

def keyPrefixAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (a : ℚ) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i => cls i = .y ∧ label i = some v ∧ keyBaseline i ≤ a

def edgePrefixAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (a : ℚ) : Finset (p.TableBin cls) :=
  (edgeTuplesAt p cls label v).filter fun t => keyBaseline (p.itemAtRole cls t .anchor) ≤ a

def mainJobPrefixAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (a : ℚ) : Finset (p.TableBin cls) := by
  classical
  exact (baselinePrefixAt p cls label v baseline a).filter fun t =>
    cls (p.itemAtRole cls t .x) = .s

def mainTreePrefixAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (a : ℚ) : Finset (p.TableBin cls) := by
  classical
  exact (baselinePrefixAt p cls label v baseline a).filter fun t =>
    cls (p.itemAtRole cls t .x) ≠ .s

theorem baseline_prefix_row_partition
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (baseline : I.Item → ℚ) (a : ℚ) :
    (baselinePrefixAt p cls label v baseline a).card =
      (mainTreePrefixAt p cls label v baseline a).card +
        (mainJobPrefixAt p cls label v baseline a).card := by
  classical
  have h := Finset.card_filter_add_card_filter_not
    (s := baselinePrefixAt p cls label v baseline a)
    (fun t => cls (p.itemAtRole cls t .x) = .s)
  simpa only [mainTreePrefixAt, mainJobPrefixAt, Nat.add_comm] using h.symm

theorem main_tree_prefix_le_inventory
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (baseline : I.Item → ℚ) (a : ℚ) :
    (mainTreePrefixAt p cls label v baseline a).card ≤
      (treeRowPrefixAt (I := I) cls label v baseline a).card := by
  classical
  apply card_le_role_resources p cls _ .x _
  intro t ht
  obtain ⟨ht, hnots⟩ := Finset.mem_filter.mp ht
  obtain ⟨ht, hbase⟩ := Finset.mem_filter.mp ht
  obtain ⟨hgood, hlabel, _⟩ := (mem_mainTuplesAt p cls label v t).mp ht
  have hrole := (role_eq_x_iff (cls (p.itemAtRole cls t .x))).mp
    (p.itemAtRole_role cls t .x)
  have htree : cls (p.itemAtRole cls t .x) = .tp ∨
      cls (p.itemAtRole cls t .x) = .tm := by
    rcases hrole with hp | hm | hs
    · exact Or.inl hp
    · exact Or.inr hm
    · exact False.elim (hnots hs)
  exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, htree, hgood.1.trans hlabel, hbase⟩

theorem good_key_subset_edge_anchor_image
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (a : ℚ) :
    keyPrefixAt (I := I) cls label v keyBaseline a \ badAnchorsAt p cls label v ⊆
      roleItems p cls (edgePrefixAt p cls label v keyBaseline a) .anchor := by
  classical
  intro i hi
  obtain ⟨hi, hnotbad⟩ := Finset.mem_sdiff.mp hi
  obtain ⟨_, hcls, hlabel, hbase⟩ := Finset.mem_filter.mp hi
  have hanchor : i ∈ anchorItemsAt (I := I) cls label v :=
    (mem_anchorItemsAt cls label v i).mpr ⟨by rw [hcls]; rfl, hlabel⟩
  have hused : i ∈ roleItems p cls (goodTuplesAt p cls label v) .anchor := by
    by_contra h
    exact hnotbad ((mem_badAnchorsAt p cls label v i).mpr ⟨hanchor, h⟩)
  obtain ⟨t, ht, hti⟩ := Finset.mem_image.mp hused
  have hpattern : p.tablePattern cls t = .edgeJob := by
    have hsub : patternSubclass (p.tablePattern cls t) .anchor = .y :=
      (p.itemAtRole_subclass cls t .anchor).symm.trans ((congrArg cls hti).trans hcls)
    cases hp : p.tablePattern cls t <;> simp_all [patternSubclass]
  have htgood := (mem_goodTuplesAt p cls label v t).mp ht
  have hG : t ∈ edgeTuplesAt p cls label v :=
    (mem_edgeTuplesAt p cls label v t).mpr ⟨htgood.1, htgood.2, hpattern⟩
  apply Finset.mem_image.mpr
  refine ⟨t, Finset.mem_filter.mpr ⟨hG, ?_⟩, hti⟩
  simpa only [hti] using hbase

theorem key_prefix_le_edge_prefix_add_loss
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (a : ℚ) (K : ℕ)
    (hbad : (badAnchorsAt p cls label v).card ≤ 3 * K) :
    (keyPrefixAt (I := I) cls label v keyBaseline a).card ≤
      (edgePrefixAt p cls label v keyBaseline a).card + 3 * K := by
  have hcount := Finset.card_le_card
    (good_key_subset_edge_anchor_image p cls label v keyBaseline a)
  rw [roleItems_card] at hcount
  have hloss := CoverageCounts.card_le_good_card_add
    (s := keyPrefixAt (I := I) cls label v keyBaseline a) hbad
  omega

theorem edge_row_mem_job_prefix
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n) (baseline : I.Item → ℚ) (a : ℚ)
    {t : p.TableBin cls} (ht : t ∈ edgeTuplesAt p cls label v)
    (hbase : baseline (p.itemAtRole cls t .x) ≤ a) :
    p.itemAtRole cls t .x ∈ jobRowPrefixAt (I := I) cls label v baseline a := by
  obtain ⟨hgood, hlabel, hpattern⟩ := (mem_edgeTuplesAt p cls label v t).mp ht
  have hcls : cls (p.itemAtRole cls t .x) = .s := by
    rw [p.itemAtRole_subclass cls t .x, hpattern]
    rfl
  exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hcls, hgood.1.trans hlabel, hbase⟩

theorem displaced_baseline_prefix_le
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (a : ℚ)
    (extra : Finset (p.TableBin cls)) (B jobs K : ℕ)
    (hbad : (badAnchorsAt p cls label v).card ≤ 3 * K)
    (horder : ∀ t ∈ edgeTuplesAt p cls label v,
      baseline (p.itemAtRole cls t .x) ≤ keyBaseline (p.itemAtRole cls t .anchor))
    (hextra : extra ⊆ edgeTuplesAt p cls label v)
    (hextraRows : ∀ t ∈ extra, baseline (p.itemAtRole cls t .x) ≤ a)
    (hextraDis : Disjoint (edgePrefixAt p cls label v keyBaseline a) extra)
    (hjobStock : (jobRowPrefixAt (I := I) cls label v baseline a).card = 2 * jobs)
    (hkeyStock : (keyPrefixAt (I := I) cls label v keyBaseline a).card = jobs)
    (hbaselineStock : B = (treeRowPrefixAt (I := I) cls label v baseline a).card + jobs) :
    (baselinePrefixAt p cls label v baseline a).card + extra.card ≤ B + 3 * K := by
  classical
  let M := mainJobPrefixAt p cls label v baseline a
  let E := edgePrefixAt p cls label v keyBaseline a
  have hMsub : M ⊆ mainTuplesAt p cls label v := by
    intro t ht
    exact (Finset.mem_filter.mp (Finset.mem_filter.mp ht).1).1
  have hEsub : E ⊆ edgeTuplesAt p cls label v := Finset.filter_subset _ _
  have hME : Disjoint M E :=
    (mainTuplesAt_disjoint_edge p cls label v v).mono hMsub hEsub
  have hMX : Disjoint M extra :=
    (mainTuplesAt_disjoint_edge p cls label v v).mono hMsub hextra
  have hmap : ∀ t ∈ (M ∪ E) ∪ extra,
      p.itemAtRole cls t .x ∈ jobRowPrefixAt (I := I) cls label v baseline a := by
    intro t ht
    rcases Finset.mem_union.mp ht with ht | ht
    · rcases Finset.mem_union.mp ht with ht | ht
      · obtain ⟨hprefix, hcls⟩ := Finset.mem_filter.mp ht
        obtain ⟨htM, hbase⟩ := Finset.mem_filter.mp hprefix
        obtain ⟨hgood, hlabel, _⟩ := (mem_mainTuplesAt p cls label v t).mp htM
        exact Finset.mem_filter.mpr
          ⟨Finset.mem_univ _, hcls, hgood.1.trans hlabel, hbase⟩
      · obtain ⟨htG, hbase⟩ := Finset.mem_filter.mp ht
        exact edge_row_mem_job_prefix p cls label v baseline a htG
          ((horder t htG).trans hbase)
    · exact edge_row_mem_job_prefix p cls label v baseline a (hextra ht)
        (hextraRows t ht)
  have hrows := card_three_le_row_resources p cls M E extra
    (jobRowPrefixAt (I := I) cls label v baseline a) hME hMX hextraDis hmap
  rw [hjobStock] at hrows
  have hkeys := key_prefix_le_edge_prefix_add_loss p cls label v keyBaseline a K hbad
  rw [hkeyStock] at hkeys
  have hsplit := baseline_prefix_row_partition p cls label v baseline a
  have htrees := main_tree_prefix_le_inventory p cls label v baseline a
  have hmain : (baselinePrefixAt p cls label v baseline a).card ≤
      (treeRowPrefixAt (I := I) cls label v baseline a).card + M.card := by
    dsimp only [M]
    omega
  exact CoverageCounts.displaced_baseline_bound hmain hbaselineStock hrows hkeys

def currentKeyItemsAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (current : ℚ) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i =>
    cls i = .y ∧ label i = some v ∧ keyBaseline i = current

def currentEdgeTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (current : ℚ) : Finset (p.TableBin cls) :=
  (edgeTuplesAt p cls label v).filter fun t =>
    keyBaseline (p.itemAtRole cls t .anchor) = current

def displacedTuplesAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (current : ℚ) : Finset (p.TableBin cls) :=
  (currentEdgeTuplesAt p cls label v keyBaseline current).filter fun t =>
    baseline (p.itemAtRole cls t .x) < current

def currentShortMainAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ) :
    Finset (p.TableBin cls) :=
  (mainTuplesAt p cls label v).filter fun t =>
    baseline (p.itemAtRole cls t .x) = current ∧ short (p.itemAtRole cls t .x) = true

def currentShortEdgeAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ) :
    Finset (p.TableBin cls) :=
  (currentEdgeTuplesAt p cls label v keyBaseline current).filter fun t =>
    baseline (p.itemAtRole cls t .x) = current ∧ short (p.itemAtRole cls t .x) = true

def currentLongEdgeAt (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ) :
    Finset (p.TableBin cls) :=
  (currentEdgeTuplesAt p cls label v keyBaseline current).filter fun t =>
    baseline (p.itemAtRole cls t .x) = current ∧ short (p.itemAtRole cls t .x) ≠ true

def currentShortItemsAt (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ) : Finset I.Item := by
  classical
  exact Finset.univ.filter fun i => cls i = .s ∧ label i = some v ∧
    baseline i = current ∧ short i = true

theorem key_subset_le_matching_add_loss
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keys : Finset I.Item) (matchedTuples : Finset (p.TableBin cls)) (K : ℕ)
    (hkeys : ∀ i ∈ keys, cls i = .y ∧ label i = some v)
    (hselect : ∀ t ∈ edgeTuplesAt p cls label v,
      p.itemAtRole cls t .anchor ∈ keys → t ∈ matchedTuples)
    (hbad : (badAnchorsAt p cls label v).card ≤ 3 * K) :
    keys.card ≤ matchedTuples.card + 3 * K := by
  classical
  have hsubset : keys \ badAnchorsAt p cls label v ⊆ roleItems p cls matchedTuples .anchor := by
    intro i hi
    obtain ⟨hi, hnotbad⟩ := Finset.mem_sdiff.mp hi
    obtain ⟨hcls, hlabel⟩ := hkeys i hi
    have hanchor : i ∈ anchorItemsAt (I := I) cls label v :=
      (mem_anchorItemsAt cls label v i).mpr ⟨by rw [hcls]; rfl, hlabel⟩
    have hused : i ∈ roleItems p cls (goodTuplesAt p cls label v) .anchor := by
      by_contra h
      exact hnotbad ((mem_badAnchorsAt p cls label v i).mpr ⟨hanchor, h⟩)
    obtain ⟨t, ht, hti⟩ := Finset.mem_image.mp hused
    have hpattern : p.tablePattern cls t = .edgeJob := by
      have hsub : patternSubclass (p.tablePattern cls t) .anchor = .y :=
        (p.itemAtRole_subclass cls t .anchor).symm.trans ((congrArg cls hti).trans hcls)
      cases hp : p.tablePattern cls t <;> simp_all [patternSubclass]
    have htgood := (mem_goodTuplesAt p cls label v t).mp ht
    have hG : t ∈ edgeTuplesAt p cls label v :=
      (mem_edgeTuplesAt p cls label v t).mpr ⟨htgood.1, htgood.2, hpattern⟩
    refine Finset.mem_image.mpr ⟨t, hselect t hG ?_, hti⟩
    simpa only [hti] using hi
  have hcount := Finset.card_le_card hsubset
  rw [roleItems_card] at hcount
  have hloss := CoverageCounts.card_le_good_card_add (s := keys) hbad
  omega

theorem current_key_count_le_matches_add_loss
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (keyBaseline : I.Item → ℚ) (current : ℚ) (K : ℕ)
    (hbad : (badAnchorsAt p cls label v).card ≤ 3 * K) :
    (currentKeyItemsAt (I := I) cls label v keyBaseline current).card ≤
      (currentEdgeTuplesAt p cls label v keyBaseline current).card + 3 * K := by
  apply key_subset_le_matching_add_loss p cls label v _ _ K _ _ hbad
  · intro i hi
    obtain ⟨_, hcls, hlabel, _⟩ := Finset.mem_filter.mp hi
    exact ⟨hcls, hlabel⟩
  · intro t ht hi
    exact Finset.mem_filter.mpr ⟨ht, (Finset.mem_filter.mp hi).2.2.2⟩

theorem current_match_partition
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ)
    (horder : ∀ t ∈ edgeTuplesAt p cls label v,
      baseline (p.itemAtRole cls t .x) ≤ keyBaseline (p.itemAtRole cls t .anchor)) :
    (currentEdgeTuplesAt p cls label v keyBaseline current).card =
      (displacedTuplesAt p cls label v baseline keyBaseline current).card +
      (currentShortEdgeAt p cls label v baseline keyBaseline short current).card +
      (currentLongEdgeAt p cls label v baseline keyBaseline short current).card := by
  apply CoverageCounts.ordered_short_long_partition
    (currentEdgeTuplesAt p cls label v keyBaseline current)
    (fun t => baseline (p.itemAtRole cls t .x)) current
    (fun t => short (p.itemAtRole cls t .x) = true)
  intro t ht
  obtain ⟨ht, hcurrent⟩ := Finset.mem_filter.mp ht
  exact (horder t ht).trans_eq hcurrent

theorem current_short_consumption_le_stock
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ)
    (hshortJob : ∀ i, short i = true → cls i = .s) :
    (currentShortMainAt p cls label v baseline short current).card +
      (currentShortEdgeAt p cls label v baseline keyBaseline short current).card ≤
        (currentShortItemsAt (I := I) cls label v baseline short current).card := by
  classical
  let M := currentShortMainAt p cls label v baseline short current
  let G := currentShortEdgeAt p cls label v baseline keyBaseline short current
  have hMsub : M ⊆ mainTuplesAt p cls label v := Finset.filter_subset _ _
  have hGsub : G ⊆ edgeTuplesAt p cls label v := by
    intro t ht
    exact (Finset.mem_filter.mp (Finset.mem_filter.mp ht).1).1
  apply CoverageCounts.card_add_card_le_of_disjoint_injections M G
    (currentShortItemsAt (I := I) cls label v baseline short current)
    (fun t => p.itemAtRole cls t .x)
    ((mainTuplesAt_disjoint_edge p cls label v v).mono hMsub hGsub)
    _ (p.itemAtRole_injective cls .x).injOn
  intro t ht
  rcases Finset.mem_union.mp ht with ht | ht
  · obtain ⟨ht, hbase, hshort⟩ := Finset.mem_filter.mp ht
    obtain ⟨hgood, hlabel, _⟩ := (mem_mainTuplesAt p cls label v t).mp ht
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hshortJob _ hshort,
      hgood.1.trans hlabel, hbase, hshort⟩
  · obtain ⟨ht, hbase, hshort⟩ := Finset.mem_filter.mp ht
    obtain ⟨ht, _⟩ := Finset.mem_filter.mp ht
    obtain ⟨hgood, hlabel, _⟩ := (mem_edgeTuplesAt p cls label v t).mp ht
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hshortJob _ hshort,
      hgood.1.trans hlabel, hbase, hshort⟩

theorem current_long_matches_from_correction
    (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (v : Fin n)
    (baseline keyBaseline : I.Item → ℚ) (short : I.Item → Bool) (current : ℚ)
    (d K xplus : ℕ)
    (hbad : (badAnchorsAt p cls label v).card ≤ 3 * K)
    (horder : ∀ t ∈ edgeTuplesAt p cls label v,
      baseline (p.itemAtRole cls t .x) ≤ keyBaseline (p.itemAtRole cls t .anchor))
    (hshortJob : ∀ i, short i = true → cls i = .s)
    (hkeys : (currentKeyItemsAt (I := I) cls label v keyBaseline current).card = d)
    (hshortStock : (currentShortItemsAt (I := I) cls label v baseline short current).card = d)
    (hcorrection : d + (displacedTuplesAt p cls label v baseline keyBaseline current).card ≤
      xplus + (currentShortMainAt p cls label v baseline short current).card + 6 * K) :
    d ≤ (currentLongEdgeAt p cls label v baseline keyBaseline short current).card +
      xplus + 9 * K := by
  have hgood := current_key_count_le_matches_add_loss p cls label v keyBaseline current K hbad
  rw [hkeys] at hgood
  have hpartition := current_match_partition p cls label v baseline keyBaseline short current horder
  have hshort := current_short_consumption_le_stock p cls label v baseline keyBaseline
    short current hshortJob
  rw [hshortStock] at hshort
  exact CoverageCounts.long_match_lower_bound hcorrection
    (CoverageCounts.short_le_displaced_add_long hgood hpartition hshort)

end Coverage
end BinPackingGap

end

end OAI
end LocalizedSource07
/- END LOCALIZED SOURCE 07/44: OAI/Computability/BinPacking/Inventory/CurrentMatches.lean -/

/- BEGIN LOCALIZED SOURCE 08/44: OAI/Computability/BinPacking/Packing/K4Graph.lean
   SHA256: 62f74c2491e8939d5c3221383f3dc3ad915fc1b60530837a0a689947ef4821e2 -/
section LocalizedSource08
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.BigOperators.Ring.Finset
-- localized import: Mathlib.Algebra.Order.Archimedean.Real.Basic
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Algebra.Order.Floor.Ring
-- localized import: Mathlib.Data.Finset.Card
-- localized import: Mathlib.Data.Fintype.BigOperators
-- localized import: Mathlib.Data.Fintype.Fin
-- localized import: Mathlib.Basic.Real.Basic
-- localized import: Mathlib.Logic.Equiv.Sum
-- localized import: Mathlib.Tactic.FieldSimp
-- localized import: Mathlib.Tactic.FinCases
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.NormNum
-- localized import: Mathlib.Tactic.Positivity
-- localized import: Mathlib.Tactic.Ring

namespace OAI

noncomputable section

namespace BinPackingGap

def primaryScoreBound : ℕ := 100 ^ 11

def lossAllowance (c : ℕ) : ℕ := 25 * (c + 1) * (1 + 5 * primaryScoreBound)

def depthDemand (c : ℕ) (ρ : ℝ) : ℕ :=
  Nat.ceil (max (72 * (lossAllowance c : ℝ)) (120 * (lossAllowance c : ℝ) / ρ))

def repetitions (P n K : ℕ) : ℕ := 100 * (P + n * K + 1)

theorem primaryScoreBound_pos : 0 < primaryScoreBound := by
  unfold primaryScoreBound
  positivity

theorem lossAllowance_pos (c : ℕ) : 0 < lossAllowance c := by
  unfold lossAllowance
  positivity

theorem primary_loss_lt_lossAllowance (c : ℕ) :
    25 * c * (1 + 5 * primaryScoreBound) < lossAllowance c := by
  unfold lossAllowance
  apply mul_lt_mul_of_pos_right _ (by positivity)
  exact mul_lt_mul_of_pos_left (Nat.lt_succ_self c) (by norm_num)

theorem depthDemand_ge_72_real (c : ℕ) (ρ : ℝ) :
    72 * (lossAllowance c : ℝ) ≤ (depthDemand c ρ : ℝ) := by
  exact (le_max_left _ _).trans (Nat.le_ceil _)

theorem depthDemand_ge_72 (c : ℕ) (ρ : ℝ) :
    72 * lossAllowance c ≤ depthDemand c ρ := by
  exact_mod_cast depthDemand_ge_72_real c ρ

theorem depthDemand_ge_120_div (c : ℕ) (ρ : ℝ) :
    120 * (lossAllowance c : ℝ) / ρ ≤ (depthDemand c ρ : ℝ) := by
  exact (le_max_right _ _).trans (Nat.le_ceil _)

theorem depthDemand_pos (c : ℕ) (ρ : ℝ) : 0 < depthDemand c ρ :=
  lt_of_lt_of_le (Nat.mul_pos (by norm_num) (lossAllowance_pos c))
    (depthDemand_ge_72 c ρ)

theorem depthDemand_one_le (c : ℕ) (ρ : ℝ) : 1 ≤ depthDemand c ρ :=
  Nat.succ_le_of_lt (depthDemand_pos c ρ)

theorem depthDemand_ge_12 (c : ℕ) (ρ : ℝ) :
    12 * lossAllowance c ≤ depthDemand c ρ := by
  exact (Nat.mul_le_mul_right (lossAllowance c) (by norm_num : 12 ≤ 72)).trans
    (depthDemand_ge_72 c ρ)

theorem depthDemand_spec (c : ℕ) (ρ : ℝ) :
    1 ≤ depthDemand c ρ ∧
      max (72 * (lossAllowance c : ℝ)) (120 * (lossAllowance c : ℝ) / ρ) ≤
        (depthDemand c ρ : ℝ) :=
  ⟨depthDemand_one_le c ρ, Nat.le_ceil _⟩

theorem threshold_gap {d K : ℝ} (hd : 0 < d) (h72 : 72 * K ≤ d) :
    d / 8 < d - 6 * K := by
  linarith

theorem three_quarter_lower {d K x L : ℝ} (h72 : 72 * K ≤ d)
    (hx : x ≤ d / 8) (hL : d - x - 9 * K ≤ L) : 3 * d / 4 ≤ L := by
  linarith

theorem depthDemand_threshold_gap (c : ℕ) (ρ : ℝ) :
    (depthDemand c ρ : ℝ) / 8 < (depthDemand c ρ : ℝ) - 6 * (lossAllowance c : ℝ) :=
  threshold_gap (Nat.cast_pos.mpr (depthDemand_pos c ρ)) (depthDemand_ge_72_real c ρ)

theorem repetitions_pos (P n K : ℕ) : 0 < repetitions P n K := by
  unfold repetitions
  positivity

theorem repetitions_gt_P (P n K : ℕ) : P < repetitions P n K := by
  have hnK : 0 ≤ n * K := Nat.zero_le _
  unfold repetitions
  nlinarith

theorem repetitions_cast (P n K : ℕ) :
    (repetitions P n K : ℝ) = 100 * ((P : ℝ) + (n : ℝ) * K + 1) := by
  simp [repetitions]

theorem edge_demand_exceeds_capacity_real {P n K d : ℝ}
    (hP : 0 ≤ P) (hn : 0 ≤ n) (hK : 0 ≤ K) (hd : 1 ≤ d) :
    d * (100 * (P + n * K + 1)) + 3 * n * K <
      2 * (100 * (P + n * K + 1) - P) * (3 * d / 4) := by
  have hd0 : 0 ≤ d := le_trans zero_le_one hd
  have hdP : 0 ≤ d * P := mul_nonneg hd0 hP
  have hnK : 0 ≤ n * K := mul_nonneg hn hK
  have hrest : 0 ≤ (50 * d - 3) * (n * K) :=
    mul_nonneg (by linarith) hnK
  nlinarith

theorem edge_demand_exceeds_capacity (P n K d : ℕ) (hd : 1 ≤ d) :
    (d : ℝ) * (repetitions P n K : ℝ) + 3 * (n : ℝ) * K <
      2 * ((repetitions P n K : ℝ) - P) * (3 * (d : ℝ) / 4) := by
  rw [repetitions_cast]
  exact edge_demand_exceeds_capacity_real (Nat.cast_nonneg P) (Nat.cast_nonneg n)
    (Nat.cast_nonneg K) (by exact_mod_cast hd)

theorem sixty_loss_div_le {ρ d K n : ℝ} (hρ : 0 < ρ) (hd : 0 < d)
    (hK : 0 ≤ K) (hn : 0 ≤ n) (h120 : 120 * K / ρ ≤ d) :
    60 * K * n / d ≤ ρ * n := by
  have hmul := (div_le_iff₀ hρ).mp h120
  have h60 : 60 * K ≤ ρ * d := by nlinarith
  apply (div_le_iff₀ hd).mpr
  calc
    60 * K * n ≤ (ρ * d) * n := mul_le_mul_of_nonneg_right h60 hn
    _ = (ρ * n) * d := by ring

theorem depthDemand_sixty_loss_div_le (c n : ℕ) {ρ : ℝ} (hρ : 0 < ρ) :
    60 * (lossAllowance c : ℝ) * (n : ℝ) / (depthDemand c ρ : ℝ) ≤ ρ * n :=
  sixty_loss_div_le hρ (Nat.cast_pos.mpr (depthDemand_pos c ρ))
    (Nat.cast_nonneg _) (Nat.cast_nonneg _) (depthDemand_ge_120_div c ρ)

structure GraphInput where
  n : ℕ
  edges : List (Fin n × Fin n)
  ordered : ∀ e ∈ edges, e.1 < e.2
  distinct : edges.Nodup

namespace GraphInput

abbrev Vertex (G : GraphInput) := Fin G.n

abbrev Edge (G : GraphInput) := Fin G.edges.length

def left (G : GraphInput) (e : G.Edge) : G.Vertex := (G.edges[e]).1

def right (G : GraphInput) (e : G.Edge) : G.Vertex := (G.edges[e]).2

def IsCover (G : GraphInput) (C : Finset G.Vertex) : Prop :=
  ∀ e ∈ G.edges, e.1 ∈ C ∨ e.2 ∈ C

def CoverAtMost (G : GraphInput) (k : ℕ) : Prop :=
  ∃ C : Finset G.Vertex, G.IsCover C ∧ C.card ≤ k

end GraphInput

open scoped BigOperators

namespace GraphInput

def endpoint (G : GraphInput) (e : G.Edge) (s : Fin 2) : G.Vertex :=
  if s = 0 then G.left e else G.right e

@[simp] theorem endpoint_zero (G : GraphInput) (e : G.Edge) :
    G.endpoint e 0 = G.left e := by simp [endpoint]

@[simp] theorem endpoint_one (G : GraphInput) (e : G.Edge) :
    G.endpoint e 1 = G.right e := by simp [endpoint]

theorem left_lt_right (G : GraphInput) (e : G.Edge) : G.left e < G.right e :=
  G.ordered _ (List.getElem_mem e.isLt)

theorem left_ne_right (G : GraphInput) (e : G.Edge) : G.left e ≠ G.right e :=
  (G.left_lt_right e).ne

theorem endpoint_injective (G : GraphInput) (e : G.Edge) :
    Function.Injective (G.endpoint e) := by
  intro s t h
  have hs : s = 0 ∨ s = 1 := by omega
  have ht : t = 0 ∨ t = 1 := by omega
  rcases hs with rfl | rfl <;> rcases ht with rfl | rfl
  · rfl
  · exact False.elim (G.left_ne_right e (by simpa using h))
  · exact False.elim (G.left_ne_right e (by simpa using h.symm))
  · rfl

abbrev Incidence (G : GraphInput) (v : G.Vertex) :=
  {es : G.Edge × Fin 2 // G.endpoint es.1 es.2 = v}

def incidenceEquiv (G : GraphInput) :
    (Σ v : G.Vertex, G.Incidence v) ≃ G.Edge × Fin 2 :=
  Equiv.sigmaFiberEquiv (fun es : G.Edge × Fin 2 => G.endpoint es.1 es.2)

def degree (G : GraphInput) (v : G.Vertex) : ℕ :=
  Fintype.card (G.Incidence v)

theorem sum_degree (G : GraphInput) :
    (∑ v : G.Vertex, G.degree v) = 2 * G.edges.length := by
  have h := Fintype.card_congr (G.incidenceEquiv)
  simpa [degree, Fintype.card_sigma, Fintype.card_prod, Nat.mul_comm] using h

abbrev IncidencePosition (G : GraphInput) (R : ℕ) (v : G.Vertex) :=
  G.Incidence v × Fin R

abbrev JobCopy (G : GraphInput) (R d : ℕ) (v : G.Vertex) :=
  G.IncidencePosition R v × Fin d

theorem card_incidencePosition (G : GraphInput) (R : ℕ) (v : G.Vertex) :
    Fintype.card (G.IncidencePosition R v) = R * G.degree v := by
  simp [IncidencePosition, degree, Nat.mul_comm]

theorem card_jobCopy (G : GraphInput) (R d : ℕ) (v : G.Vertex) :
    Fintype.card (G.JobCopy R d v) = d * R * G.degree v := by
  simp [JobCopy, IncidencePosition, degree, Nat.mul_comm, Nat.mul_left_comm,
    Nat.mul_assoc]

theorem sum_card_jobCopy (G : GraphInput) (R d : ℕ) :
    (∑ v : G.Vertex, Fintype.card (G.JobCopy R d v)) =
      2 * d * G.edges.length * R := by
  simp_rw [card_jobCopy]
  rw [← Finset.mul_sum, sum_degree]
  ac_rfl

end GraphInput

end BinPackingGap

section
open scoped BigOperators

namespace BinPackingGap

variable {V : Type*} [Fintype V] [DecidableEq V]

def thresholdCover (d : ℕ) (xplus : V → ℕ) : Finset V := by
  classical
  exact Finset.univ.filter fun v => (d : ℝ) / 8 < (xplus v : ℝ)

def largePlus (d K : ℕ) (xplus : V → ℕ) : Finset V := by
  classical
  exact Finset.univ.filter fun v => (d : ℝ) - 6 * K ≤ (xplus v : ℝ)

theorem residual_plus_le {d K : ℕ} (xplus xminus : V → ℕ)
    (htotal : (∑ v, (xplus v + xminus v)) ≤ d * Fintype.card V)
    (hside : ∀ v, d ≤ xplus v + 6 * K ∨ d ≤ xminus v + 6 * K) :
    (∑ v, if v ∈ largePlus d K xplus then (0 : ℝ) else (xplus v : ℝ)) ≤
      6 * (K : ℝ) * Fintype.card V := by
  classical
  let charge : V → ℝ := fun v =>
    if v ∈ largePlus d K xplus then (xplus v : ℝ) else (xminus v : ℝ)
  let rest : V → ℝ := fun v =>
    if v ∈ largePlus d K xplus then 0 else (xplus v : ℝ)
  have hcharge : ∀ v, (d : ℝ) - 6 * K ≤ charge v := by
    intro v
    by_cases hv : v ∈ largePlus d K xplus
    · simpa only [charge, ite_eq_left hv] using (Finset.mem_filter.mp hv).2
    · have hnot : ¬ ((d : ℝ) - 6 * K ≤ (xplus v : ℝ)) := by
        simpa [largePlus] using hv
      rcases hside v with hp | hm
      · have hp' : (d : ℝ) ≤ (xplus v : ℝ) + 6 * K := by exact_mod_cast hp
        exact (hnot (by linarith)).elim
      · have hm' : (d : ℝ) ≤ (xminus v : ℝ) + 6 * K := by exact_mod_cast hm
        simp only [charge, ite_eq_right hv]
        linarith
  have hcharged : (Fintype.card V : ℝ) * ((d : ℝ) - 6 * K) ≤ ∑ v, charge v := by
    calc
      _ = ∑ _v : V, ((d : ℝ) - 6 * K) := by
        simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
      _ ≤ ∑ v, charge v := Finset.sum_le_sum fun v _ => hcharge v
  have hpoint : ∀ v, charge v + rest v ≤ (xplus v : ℝ) + xminus v := by
    intro v
    dsimp only [charge, rest]
    split_ifs <;> nlinarith [show (0 : ℝ) ≤ xplus v from Nat.cast_nonneg _,
      show (0 : ℝ) ≤ xminus v from Nat.cast_nonneg _]
  have hsum : (∑ v, charge v) + (∑ v, rest v) ≤
      (d : ℝ) * Fintype.card V := by
    calc
      _ = ∑ v, (charge v + rest v) := (Finset.sum_add_distrib).symm
      _ ≤ ∑ v, ((xplus v : ℝ) + xminus v) := Finset.sum_le_sum fun v _ => hpoint v
      _ ≤ (d : ℝ) * Fintype.card V := by exact_mod_cast htotal
  change (∑ v, rest v) ≤ _
  nlinarith

theorem thresholdCover_card_le_fractions {d K k : ℕ} (xplus xminus : V → ℕ)
    (hd : 0 < d) (h72 : 72 * K ≤ d)
    (hplus : (∑ v, xplus v) ≤ d * k)
    (htotal : (∑ v, (xplus v + xminus v)) ≤ d * Fintype.card V)
    (hside : ∀ v, d ≤ xplus v + 6 * K ∨ d ≤ xminus v + 6 * K) :
    ((thresholdCover d xplus).card : ℝ) ≤
      (d : ℝ) * k / ((d : ℝ) - 6 * K) + 48 * (K : ℝ) * Fintype.card V / d := by
  classical
  let A := largePlus d K xplus
  let C := thresholdCover d xplus
  let B := C \ A
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have h72' : 72 * (K : ℝ) ≤ d := by exact_mod_cast h72
  have hgap := threshold_gap hd0 h72'
  have hden : 0 < (d : ℝ) - 6 * K := lt_trans (by positivity) hgap
  have hAC : A ⊆ C := by
    intro v hv
    have hv' : (d : ℝ) - 6 * K ≤ (xplus v : ℝ) := (Finset.mem_filter.mp hv).2
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ v, hgap.trans_le hv'⟩
  have hAlower : (A.card : ℝ) * ((d : ℝ) - 6 * K) ≤ ∑ v, (xplus v : ℝ) := by
    calc
      _ = ∑ _v ∈ A, ((d : ℝ) - 6 * K) := by
        simp only [Finset.sum_const, nsmul_eq_mul]
      _ ≤ ∑ v ∈ A, (xplus v : ℝ) :=
        Finset.sum_le_sum fun v hv => (Finset.mem_filter.mp hv).2
      _ ≤ ∑ v, (xplus v : ℝ) :=
        Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _) (by intros; positivity)
  have hA : (A.card : ℝ) ≤ (d : ℝ) * k / ((d : ℝ) - 6 * K) := by
    apply (le_div_iff₀ hden).mpr
    exact hAlower.trans (by exact_mod_cast hplus)
  let rest : V → ℝ := fun v => if v ∈ A then 0 else (xplus v : ℝ)
  have hrest : (∑ v, rest v) ≤ 6 * (K : ℝ) * Fintype.card V :=
    residual_plus_le xplus xminus htotal hside
  have hBlower : (B.card : ℝ) * ((d : ℝ) / 8) ≤ ∑ v, rest v := by
    calc
      _ = ∑ _v ∈ B, ((d : ℝ) / 8) := by simp
      _ ≤ ∑ v ∈ B, rest v := by
        apply Finset.sum_le_sum
        intro v hv
        obtain ⟨hvC, hvA⟩ := Finset.mem_sdiff.mp hv
        have hv' : (d : ℝ) / 8 < (xplus v : ℝ) := (Finset.mem_filter.mp hvC).2
        simpa only [rest, ite_eq_right hvA] using hv'.le
      _ ≤ ∑ v, rest v := by
        apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _)
        intro v _ _
        dsimp only [rest]
        split_ifs <;> positivity
  have hB : (B.card : ℝ) ≤ 48 * (K : ℝ) * Fintype.card V / d := by
    apply (le_div_iff₀ hd0).mpr
    nlinarith
  have hcard : (C.card : ℝ) = (A.card : ℝ) + B.card := by
    have hh := Finset.card_sdiff_add_card_eq_card hAC
    dsimp only [B]
    exact_mod_cast hh.symm.trans (Nat.add_comm _ _)
  change (C.card : ℝ) ≤ _
  rw [hcard]
  exact add_le_add hA hB

theorem cover_fraction_bound {d K k n : ℝ} (hd : 0 < d) (hK : 0 ≤ K)
    (hk0 : 0 ≤ k) (hkn : k ≤ n) (h12 : 12 * K ≤ d) :
    d * k / (d - 6 * K) + 48 * K * n / d ≤ k + 60 * K * n / d := by
  have hn : 0 ≤ n := hk0.trans hkn
  have hden : 0 < d - 6 * K := by linarith
  have hmult := mul_le_mul_of_nonneg_left hkn (show 0 ≤ 6 * K * d by positivity)
  have hslack := mul_nonneg (show 0 ≤ 6 * K * n by positivity) (sub_nonneg.mpr h12)
  have hfrac : 6 * K * k / (d - 6 * K) ≤ 12 * K * n / d := by
    apply (div_le_div_iff₀ hden hd).mpr
    nlinarith
  have hid : d * k / (d - 6 * K) = k + 6 * K * k / (d - 6 * K) := by
    field_simp [hden.ne']; ring
  rw [hid]
  have hsplit : 60 * K * n / d = 12 * K * n / d + 48 * K * n / d := by ring
  rw [hsplit]
  linarith

theorem thresholdCover_card_le {d K k : ℕ} {ρ : ℝ} (xplus xminus : V → ℕ)
    (hd : 0 < d) (h72 : 72 * K ≤ d) (hk : k ≤ Fintype.card V)
    (hρ : 0 < ρ) (h120 : 120 * (K : ℝ) / ρ ≤ d)
    (hplus : (∑ v, xplus v) ≤ d * k)
    (htotal : (∑ v, (xplus v + xminus v)) ≤ d * Fintype.card V)
    (hside : ∀ v, d ≤ xplus v + 6 * K ∨ d ≤ xminus v + 6 * K) :
    ((thresholdCover d xplus).card : ℝ) ≤ (k : ℝ) + ρ * Fintype.card V := by
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have h72' : 72 * (K : ℝ) ≤ d := by exact_mod_cast h72
  calc
    _ ≤ (d : ℝ) * k / ((d : ℝ) - 6 * K) + 48 * (K : ℝ) * Fintype.card V / d :=
      thresholdCover_card_le_fractions xplus xminus hd h72 hplus htotal hside
    _ ≤ (k : ℝ) + 60 * (K : ℝ) * Fintype.card V / d :=
      cover_fraction_bound hd0 (Nat.cast_nonneg K) (Nat.cast_nonneg k)
        (by exact_mod_cast hk) (by linarith)
    _ ≤ (k : ℝ) + ρ * Fintype.card V :=
      add_le_add (le_refl (k : ℝ)) (sixty_loss_div_le hρ hd0 (Nat.cast_nonneg K)
        (Nat.cast_nonneg _) h120)

theorem longMatch_sum_lower {R P : ℕ} (S : Finset (Fin R)) (L : Fin R → ℕ)
    {a : ℝ} (ha : 0 ≤ a) (hS : (R : ℝ) - P ≤ (S.card : ℝ))
    (hL : ∀ j ∈ S, a ≤ (L j : ℝ)) :
    ((R : ℝ) - P) * a ≤ ∑ j, (L j : ℝ) := by
  calc
    _ ≤ (S.card : ℝ) * a := mul_le_mul_of_nonneg_right hS ha
    _ = ∑ _j ∈ S, a := by simp
    _ ≤ ∑ j ∈ S, (L j : ℝ) := Finset.sum_le_sum hL
    _ ≤ ∑ j, (L j : ℝ) :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _) (by intros; positivity)

theorem thresholdCover_isCover (G : GraphInput) {d K P R : ℕ}
    (xplus : G.Vertex → ℕ)
    (Sleft Sright : G.Edge → Finset (Fin R))
    (Lleft Lright : G.Edge → Fin R → ℕ)
    (hd : 1 ≤ d) (h72 : 72 * K ≤ d) (hR : R = repetitions P G.n K)
    (hSleft : ∀ e, (R : ℝ) - P ≤ ((Sleft e).card : ℝ))
    (hSright : ∀ e, (R : ℝ) - P ≤ ((Sright e).card : ℝ))
    (hLleft : ∀ e j, j ∈ Sleft e → d ≤ Lleft e j + xplus (G.left e) + 9 * K)
    (hLright : ∀ e j, j ∈ Sright e → d ≤ Lright e j + xplus (G.right e) + 9 * K)
    (hcapacity : ∀ e, (∑ j, Lleft e j) + (∑ j, Lright e j) ≤
      d * R + 3 * G.n * K) :
    G.IsCover (thresholdCover d xplus) := by
  classical
  let C := thresholdCover d xplus
  have hd0 : (0 : ℝ) < d := by exact_mod_cast (Nat.lt_of_lt_of_le Nat.zero_lt_one hd)
  have h72' : 72 * (K : ℝ) ≤ d := by exact_mod_cast h72
  have hstrict : (d : ℝ) * R + 3 * (G.n : ℝ) * K <
      2 * ((R : ℝ) - P) * (3 * (d : ℝ) / 4) := by
    rw [hR]
    exact edge_demand_exceeds_capacity P G.n K d hd
  have hindex : ∀ e : G.Edge, G.left e ∈ C ∨ G.right e ∈ C := by
    intro e
    by_cases hv : G.left e ∈ C
    · exact Or.inl hv
    right
    by_contra hw
    have hxleft : (xplus (G.left e) : ℝ) ≤ (d : ℝ) / 8 := by
      apply le_of_not_gt
      simpa [C, thresholdCover] using hv
    have hxright : (xplus (G.right e) : ℝ) ≤ (d : ℝ) / 8 := by
      apply le_of_not_gt
      simpa [C, thresholdCover] using hw
    have hleft : ((R : ℝ) - P) * (3 * (d : ℝ) / 4) ≤
        ∑ j, (Lleft e j : ℝ) := by
      apply longMatch_sum_lower _ _ (by positivity) (hSleft e)
      intro j hj
      have hmatch : (d : ℝ) ≤ (Lleft e j : ℝ) + xplus (G.left e) + 9 * K := by
        exact_mod_cast hLleft e j hj
      exact three_quarter_lower h72' hxleft (by linarith)
    have hright : ((R : ℝ) - P) * (3 * (d : ℝ) / 4) ≤
        ∑ j, (Lright e j : ℝ) := by
      apply longMatch_sum_lower _ _ (by positivity) (hSright e)
      intro j hj
      have hmatch : (d : ℝ) ≤ (Lright e j : ℝ) + xplus (G.right e) + 9 * K := by
        exact_mod_cast hLright e j hj
      exact three_quarter_lower h72' hxright (by linarith)
    have hcap : (∑ j, (Lleft e j : ℝ)) + (∑ j, (Lright e j : ℝ)) ≤
        (d : ℝ) * R + 3 * (G.n : ℝ) * K := by exact_mod_cast hcapacity e
    linarith
  intro e he
  obtain ⟨i, hi, heq⟩ := List.mem_iff_getElem.mp he
  have h := hindex ⟨i, hi⟩
  change (G.edges[i]).1 ∈ C ∨ (G.edges[i]).2 ∈ C at h
  rw [heq] at h
  exact h

theorem thresholdCover_card_le_graph (G : GraphInput) {d K k : ℕ} {ρ : ℝ}
    (xplus xminus : G.Vertex → ℕ)
    (hd : 0 < d) (h72 : 72 * K ≤ d) (hk : k ≤ G.n)
    (hρ : 0 < ρ) (h120 : 120 * (K : ℝ) / ρ ≤ d)
    (hplus : (∑ v, xplus v) ≤ d * k)
    (htotal : (∑ v, (xplus v + xminus v)) ≤ d * G.n)
    (hside : ∀ v, d ≤ xplus v + 6 * K ∨ d ≤ xminus v + 6 * K) :
    ((thresholdCover d xplus).card : ℝ) ≤ (k : ℝ) + ρ * G.n := by
  simpa only [Fintype.card_fin] using
    thresholdCover_card_le xplus xminus hd h72
      (by simpa only [Fintype.card_fin] using hk) hρ h120 hplus
      (by simpa only [Fintype.card_fin] using htotal) hside

end BinPackingGap

end

namespace BinPackingGap

def completeFourGraph : GraphInput where
  n := 4
  edges := [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
  ordered := by decide
  distinct := by decide

theorem completeFourGraph_edge_pos : 0 < completeFourGraph.edges.length := by decide

theorem completeFourGraph_cover_card {C : Finset completeFourGraph.Vertex}
    (hC : completeFourGraph.IsCover C) : 3 ≤ C.card := by
  classical
  change Finset (Fin 4) at C
  change 3 ≤ C.card
  change ∀ e : Fin 4 × Fin 4,
    e ∈ [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)] →
      e.1 ∈ C ∨ e.2 ∈ C at hC
  have h01 : (0 : Fin 4) ∈ C ∨ (1 : Fin 4) ∈ C :=
    hC ((0 : Fin 4), (1 : Fin 4)) (by decide)
  have h02 : (0 : Fin 4) ∈ C ∨ (2 : Fin 4) ∈ C :=
    hC ((0 : Fin 4), (2 : Fin 4)) (by decide)
  have h03 : (0 : Fin 4) ∈ C ∨ (3 : Fin 4) ∈ C :=
    hC ((0 : Fin 4), (3 : Fin 4)) (by decide)
  have h12 : (1 : Fin 4) ∈ C ∨ (2 : Fin 4) ∈ C :=
    hC ((1 : Fin 4), (2 : Fin 4)) (by decide)
  have h13 : (1 : Fin 4) ∈ C ∨ (3 : Fin 4) ∈ C :=
    hC ((1 : Fin 4), (3 : Fin 4)) (by decide)
  have h23 : (2 : Fin 4) ∈ C ∨ (3 : Fin 4) ∈ C :=
    hC ((2 : Fin 4), (3 : Fin 4)) (by decide)
  have hsmall : (Finset.univ \ C).card ≤ 1 := by
    apply Finset.card_le_one.mpr
    intro x hx y hy
    have hxC : x ∉ C := (Finset.mem_sdiff.mp hx).2
    have hyC : y ∉ C := (Finset.mem_sdiff.mp hy).2
    fin_cases x <;> fin_cases y <;> simp_all
  have htotal : (Finset.univ \ C).card + C.card = 4 := by
    simpa only [Finset.card_univ, Fintype.card_fin, completeFourGraph] using
      Finset.card_sdiff_add_card_eq_card (Finset.subset_univ C)
  omega

theorem completeFourGraph_cover_three : completeFourGraph.CoverAtMost 3 := by
  change ∃ C : Finset (Fin 4),
    (∀ e : Fin 4 × Fin 4,
      e ∈ [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)] →
        e.1 ∈ C ∨ e.2 ∈ C) ∧ C.card ≤ 3
  exact ⟨{0, 1, 2}, by decide, by decide⟩

theorem completeFourGraph_no_small_cover :
    ¬ ∃ C : Finset completeFourGraph.Vertex,
      completeFourGraph.IsCover C ∧
        (C.card : ℝ) ≤ 2 + (1 / 8 : ℝ) * completeFourGraph.n := by
  rintro ⟨C, hC, hcard⟩
  have hthree : (3 : ℝ) ≤ C.card := by exact_mod_cast completeFourGraph_cover_card hC
  norm_num [completeFourGraph] at hcard
  linarith

end BinPackingGap

end

end OAI
end LocalizedSource08
/- END LOCALIZED SOURCE 08/44: OAI/Computability/BinPacking/Packing/K4Graph.lean -/

/- BEGIN LOCALIZED SOURCE 09/44: OAI/Computability/BinPacking/Machines/IntegerPackingArithmetic.lean
   SHA256: 6124631d3b366c32a178e90431bbdd10f07019c0d694b0f7713cea61435788f8 -/
section LocalizedSource09
-- localized import: OAI.Computability.BinPacking.Packing.PackingScalar
-- localized import: OAI.Computability.BinPacking.Trees.CompletionGeometry

namespace OAI

namespace BinPackingGap.IntegerPackingArithmetic

def widthRadix (D : ℕ) : ℕ := 100 * (D + 1)

def geomDenominator (m R D L : ℕ) : ℕ :=
  160 * (R + 1) ^ m * widthRadix D ^ L

def sizeDenominator (n geom : ℕ) : ℕ :=
  10 ^ 9 * primaryBound * 3 ^ n * geom

def signedNumerator (n geom : ℕ) (p q W : ℤ) : ℤ :=
  200000000 * (primaryBound : ℤ) * 3 ^ n * geom +
    1000000 * 3 ^ n * geom * p + 1000 * geom * q + W

def itemNumerator {n : ℕ} (geom : ℕ) (subclass : Subclass)
    (label : Option (Fin n)) (W : ℤ) : ℤ :=
  signedNumerator n geom (primaryScore subclass) (secondaryScore subclass label) W

theorem widthRadix_pos (D : ℕ) : 0 < widthRadix D := by
  unfold widthRadix
  positivity

theorem geomDenominator_pos (m R D L : ℕ) : 0 < geomDenominator m R D L := by
  unfold geomDenominator
  exact Nat.mul_pos (by positivity) (pow_pos (widthRadix_pos D) L)

theorem sizeDenominator_pos (n geom : ℕ) (hgeom : 0 < geom) :
    0 < sizeDenominator n geom := by
  unfold sizeDenominator primaryBound
  positivity

theorem signedNumerator_ratio (n geom : ℕ) (hgeom : 0 < geom)
    (p q W : ℤ) :
    (signedNumerator n geom p q W : ℚ) / (sizeDenominator n geom : ℚ) =
      1 / 5 + gamma * (p : ℚ) + mu n * (q : ℚ) +
        nu n * ((W : ℚ) / geom) := by
  have hg : (geom : ℚ) ≠ 0 := by exact_mod_cast hgeom.ne'
  have hp : (primaryBound : ℚ) ≠ 0 := by norm_num [primaryBound]
  have hq : (3 : ℚ) ^ n ≠ 0 := pow_ne_zero n (by norm_num)
  simp only [signedNumerator, sizeDenominator, nu, mu, gamma]
  push_cast
  field_simp [hg, hp, hq]
  ring

theorem itemNumerator_ratio {n : ℕ} (geom : ℕ) (hgeom : 0 < geom)
    (subclass : Subclass) (label : Option (Fin n)) (W : ℤ) :
    (itemNumerator geom subclass label W : ℚ) / (sizeDenominator n geom : ℚ) =
      encodedSize subclass label ((W : ℚ) / geom) := by
  exact signedNumerator_ratio n geom hgeom (primaryScore subclass) (secondaryScore subclass label) W

theorem itemNumerator_pos_lt {n : ℕ} (geom : ℕ) (hgeom : 0 < geom)
    (subclass : Subclass) (label : Option (Fin n)) (W : ℤ)
    (hW : |(W : ℚ) / geom| ≤ 6) :
    0 < itemNumerator geom subclass label W ∧
      itemNumerator geom subclass label W < (sizeDenominator n geom : ℤ) := by
  have hd : (0 : ℚ) < sizeDenominator n geom := by
    exact_mod_cast sizeDenominator_pos n geom hgeom
  have hs := encodedSize_mem_interval subclass label ((W : ℚ) / geom) hW
  rw [← itemNumerator_ratio geom hgeom subclass label W] at hs
  have hpos : (0 : ℚ) < (itemNumerator geom subclass label W : ℚ) := by
    have hdiv : (0 : ℚ) < (itemNumerator geom subclass label W : ℚ) /
        (sizeDenominator n geom : ℚ) := lt_trans (by norm_num) hs.1
    rcases div_pos_iff.mp hdiv with h | h
    · exact h.1
    · exact (not_lt_of_ge hd.le h.2).elim
  have hlt : (itemNumerator geom subclass label W : ℚ) < (sizeDenominator n geom : ℚ) := by
    have h := (div_lt_iff₀ hd).mp hs.2
    simpa only [one_mul] using h
  constructor
  · exact_mod_cast hpos
  · exact_mod_cast hlt

def rawItem {n : ℕ} (geom : ℕ) (subclass : Subclass)
    (label : Option (Fin n)) (W : ℤ) : ℕ × ℕ :=
  ((itemNumerator geom subclass label W).toNat, sizeDenominator n geom)

theorem rawItem_numerator_cast {n : ℕ} (geom : ℕ) (hgeom : 0 < geom)
    (subclass : Subclass) (label : Option (Fin n)) (W : ℤ)
    (hW : |(W : ℚ) / geom| ≤ 6) :
    ((rawItem geom subclass label W).1 : ℤ) = itemNumerator geom subclass label W := by
  exact Int.toNat_of_nonneg (itemNumerator_pos_lt geom hgeom subclass label W hW).1.le

theorem rawItem_valid {n : ℕ} (geom : ℕ) (hgeom : 0 < geom)
    (subclass : Subclass) (label : Option (Fin n)) (W : ℤ)
    (hW : |(W : ℚ) / geom| ≤ 6) :
    0 < (rawItem geom subclass label W).1 ∧
      (rawItem geom subclass label W).1 < (rawItem geom subclass label W).2 := by
  have hs := itemNumerator_pos_lt geom hgeom subclass label W hW
  rw [← rawItem_numerator_cast geom hgeom subclass label W hW] at hs
  exact_mod_cast hs

theorem rawItem_ratio {n : ℕ} (geom : ℕ) (hgeom : 0 < geom)
    (subclass : Subclass) (label : Option (Fin n)) (W : ℤ)
    (hW : |(W : ℚ) / geom| ≤ 6) :
    ((rawItem geom subclass label W).1 : ℚ) / (rawItem geom subclass label W).2 =
      encodedSize subclass label ((W : ℚ) / geom) := by
  have hc : ((rawItem geom subclass label W).1 : ℚ) =
      (itemNumerator geom subclass label W : ℚ) := by
    exact_mod_cast rawItem_numerator_cast geom hgeom subclass label W hW
  rw [hc]
  exact itemNumerator_ratio geom hgeom subclass label W

def localNumerator (D L ell : ℕ) : ℕ := 10 * widthRadix D ^ (L - ell)

theorem geomDenominator_mul_gap (m R D L : ℕ) :
    (geomDenominator m R D L : ℚ) * Geometry.gap m R =
      10 * (widthRadix D : ℚ) ^ L := by
  have hp : ((R : ℚ) + 1) ^ m ≠ 0 :=
    pow_ne_zero m (by positivity)
  unfold geomDenominator Geometry.gap
  push_cast
  field_simp [hp]
  ring

theorem geomDenominator_mul_lambda (m R D L ell : ℕ) (hell : ell ≤ L) :
    (geomDenominator m R D L : ℚ) * Geometry.lambda m R D ell =
      (localNumerator D L ell : ℚ) := by
  have hc : (widthRadix D : ℚ) ≠ 0 := by
    exact_mod_cast (widthRadix_pos D).ne'
  have hpow : (widthRadix D : ℚ) ^ L =
      (widthRadix D : ℚ) ^ ell * (widthRadix D : ℚ) ^ (L - ell) := by
    rw [← pow_add, Nat.add_sub_of_le hell]
  have hrad : (100 * ((D : ℚ) + 1)) = (widthRadix D : ℚ) := by
    simp [widthRadix]
  rw [Geometry.lambda, ← mul_div_assoc, geomDenominator_mul_gap, hrad, hpow]
  simp only [localNumerator, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow]
  field_simp [hc]

theorem geomDenominator_mul_delta (m R D L : ℕ) :
    (geomDenominator m R D L : ℚ) * Geometry.delta m R D L = 1 := by
  rw [Geometry.delta, ← mul_div_assoc, geomDenominator_mul_lambda m R D L L le_rfl]
  norm_num [localNumerator]

def baselineNumerator (m R D L : ℕ) (r : Geometry.Position m R) : ℤ :=
  80 * (R + 1 : ℤ) ^ m * (widthRadix D : ℤ) ^ L +
    10 * (widthRadix D : ℤ) ^ L *
      (((r.2.val : ℤ) + 1) * (R + 1 : ℤ) ^ r.1.val - 1)

def betaNumerator (m R D L : ℕ) (e : Fin m) : ℤ :=
  10 * (widthRadix D : ℤ) ^ L * ((R + 1 : ℤ) ^ e.val - 1)

theorem geomDenominator_mul_baseline (m R D L : ℕ) (r : Geometry.Position m R) :
    (geomDenominator m R D L : ℚ) * Geometry.baseline m R r =
      (baselineNumerator m R D L r : ℚ) := by
  rw [Geometry.baseline, mul_add, ← mul_assoc, geomDenominator_mul_gap]
  simp only [baselineNumerator, Geometry.heightCode, geomDenominator]
  push_cast
  ring

theorem geomDenominator_mul_beta (m R D L : ℕ) (e : Fin m) :
    (geomDenominator m R D L : ℚ) * Geometry.beta m R e =
      (betaNumerator m R D L e : ℚ) := by
  rw [Geometry.beta, ← mul_assoc, geomDenominator_mul_gap]
  simp only [betaNumerator, Geometry.theta]
  push_cast
  ring

end BinPackingGap.IntegerPackingArithmetic

end OAI
end LocalizedSource09
/- END LOCALIZED SOURCE 09/44: OAI/Computability/BinPacking/Machines/IntegerPackingArithmetic.lean -/

/- BEGIN LOCALIZED SOURCE 10/44: OAI/Computability/BinPacking/Trees/IntegerTreeGeometry.lean
   SHA256: 20ed367aa68ec59d5f1889fde30ed8fa4c360cc8ab6b38c4e80be9e8284fd7e3 -/
section LocalizedSource10
-- localized import: Mathlib.Data.Finset.Dedup
-- localized import: Mathlib.Data.Finset.Disjoint
-- localized import: Mathlib.Data.Finset.Lattice.Fold
-- localized import: Mathlib.Data.Finset.Union
-- localized import: Mathlib.Data.Fintype.Card
-- localized import: Mathlib.Data.List.Infix
-- localized import: Mathlib.Order.Interval.Set.Basic
-- localized import: OAI.Computability.BinPacking.Machines.IntegerPackingArithmetic

namespace OAI

namespace BinPackingGap

structure UniformTree where
  height : ℕ
  leaves : Finset (List ℕ)
  leaves_nonempty : leaves.Nonempty
  length_leaf : ∀ l ∈ leaves, l.length = height
  positive_labels : ∀ l ∈ leaves, ∀ a ∈ l, 0 < a

namespace UniformTree

def prefixes (l : List ℕ) : Finset (List ℕ) :=
  (Finset.range (l.length + 1)).image (fun k => l.take k)

@[simp] theorem mem_prefixes_iff {w l : List ℕ} :
    w ∈ prefixes l ↔ w.IsPrefix l := by
  constructor
  · intro hw
    obtain ⟨k, _, rfl⟩ := Finset.mem_image.mp hw
    exact List.take_prefix k l
  · intro h
    exact Finset.mem_image.mpr
      ⟨w.length, Finset.mem_range.mpr (Nat.lt_succ_of_le h.length_le),
        (List.prefix_iff_eq_take.mp h).symm⟩

def vertices (T : UniformTree) : Finset (List ℕ) :=
  T.leaves.biUnion prefixes

theorem mem_vertices_iff (T : UniformTree) {w : List ℕ} :
    w ∈ T.vertices ↔ ∃ l ∈ T.leaves, w.IsPrefix l := by
  simp only [vertices, Finset.mem_biUnion, mem_prefixes_iff]

theorem leaf_mem_vertices (T : UniformTree) {l : List ℕ} (hl : l ∈ T.leaves) :
    l ∈ T.vertices :=
  (T.mem_vertices_iff).mpr ⟨l, hl, List.prefix_refl l⟩

theorem nil_mem_vertices (T : UniformTree) : [] ∈ T.vertices := by
  obtain ⟨l, hl⟩ := T.leaves_nonempty
  exact (T.mem_vertices_iff).mpr ⟨l, hl, List.nil_prefix⟩

theorem vertices_nonempty (T : UniformTree) : T.vertices.Nonempty :=
  ⟨[], T.nil_mem_vertices⟩

theorem prefix_mem_vertices (T : UniformTree) {u v : List ℕ}
    (hv : v ∈ T.vertices) (h : u.IsPrefix v) : u ∈ T.vertices := by
  obtain ⟨l, hl, hvl⟩ := T.mem_vertices_iff.mp hv
  exact T.mem_vertices_iff.mpr ⟨l, hl, h.trans hvl⟩

theorem take_mem_vertices (T : UniformTree) {w : List ℕ}
    (hw : w ∈ T.vertices) (k : ℕ) : w.take k ∈ T.vertices :=
  T.prefix_mem_vertices hw (List.take_prefix k w)

theorem length_le_height (T : UniformTree) {w : List ℕ}
    (hw : w ∈ T.vertices) : w.length ≤ T.height := by
  obtain ⟨l, hl, h⟩ := T.mem_vertices_iff.mp hw
  exact (T.length_leaf l hl) ▸ h.length_le

theorem mem_leaves_iff_length_eq_height (T : UniformTree) {w : List ℕ}
    (hw : w ∈ T.vertices) : w ∈ T.leaves ↔ w.length = T.height := by
  constructor
  · exact T.length_leaf w
  · intro hlen
    obtain ⟨l, hl, h⟩ := T.mem_vertices_iff.mp hw
    have heq : w = l := h.eq_of_length (hlen.trans (T.length_leaf l hl).symm)
    simpa only [heq] using hl

abbrev Node (T : UniformTree) := {w : List ℕ // w ∈ T.vertices}

instance nodeFintype (T : UniformTree) : Fintype T.Node :=
  Finset.fintypeCoeSort T.vertices

def root (T : UniformTree) : T.Node := ⟨[], T.nil_mem_vertices⟩

instance nodeNonempty (T : UniformTree) : Nonempty T.Node := ⟨T.root⟩

@[simp] theorem root_val (T : UniformTree) : T.root.val = [] := rfl

@[simp] theorem node_card (T : UniformTree) :
    Fintype.card T.Node = T.vertices.card := Fintype.card_coe T.vertices

theorem node_card_pos (T : UniformTree) : 0 < Fintype.card T.Node :=
  Fintype.card_pos

def depth {T : UniformTree} (v : T.Node) : ℕ := v.val.length

def ancestor {T : UniformTree} (u v : T.Node) : Prop := u.val.IsPrefix v.val

def leaf {T : UniformTree} (v : T.Node) : Prop := v.val ∈ T.leaves

def child {T : UniformTree} (u v : T.Node) : Prop :=
  ∃ a : ℕ, v.val = u.val ++ [a]

@[simp] theorem depth_root (T : UniformTree) : depth T.root = 0 := rfl

theorem depth_le_height {T : UniformTree} (v : T.Node) : depth v ≤ T.height :=
  T.length_le_height v.property

theorem leaf_iff_depth_eq_height {T : UniformTree} (v : T.Node) :
    leaf v ↔ depth v = T.height :=
  T.mem_leaves_iff_length_eq_height v.property

@[simp] theorem ancestor_refl {T : UniformTree} (v : T.Node) : ancestor v v :=
  List.prefix_refl v.val

theorem ancestor_trans {T : UniformTree} {u v w : T.Node}
    (huv : ancestor u v) (hvw : ancestor v w) : ancestor u w := huv.trans hvw

theorem ancestor_depth_le {T : UniformTree} {u v : T.Node}
    (h : ancestor u v) : depth u ≤ depth v := h.length_le

theorem eq_of_ancestor_of_depth_eq {T : UniformTree} {u v : T.Node}
    (h : ancestor u v) (hlen : depth u = depth v) : u = v :=
  Subtype.ext (h.eq_of_length hlen)

@[simp] theorem root_ancestor {T : UniformTree} (v : T.Node) : ancestor T.root v :=
  List.nil_prefix

theorem eq_root_iff_depth_eq_zero {T : UniformTree} (v : T.Node) :
    v = T.root ↔ depth v = 0 := by
  constructor
  · rintro rfl
    rfl
  · intro h
    apply Subtype.ext
    exact List.length_eq_zero_iff.mp h

def ancestorAt {T : UniformTree} (v : T.Node) (k : ℕ) : T.Node :=
  ⟨v.val.take k, T.take_mem_vertices v.property k⟩

@[simp] theorem ancestorAt_val {T : UniformTree} (v : T.Node) (k : ℕ) :
    (ancestorAt v k).val = v.val.take k := rfl

theorem ancestorAt_ancestor {T : UniformTree} (v : T.Node) (k : ℕ) :
    ancestor (ancestorAt v k) v := List.take_prefix k v.val

theorem depth_ancestorAt {T : UniformTree} (v : T.Node) {k : ℕ}
    (hk : k ≤ depth v) : depth (ancestorAt v k) = k := by
  exact List.length_take_of_le hk

theorem ancestor_eq_ancestorAt {T : UniformTree} {u v : T.Node}
    (h : ancestor u v) : u = ancestorAt v (depth u) :=
  Subtype.ext (List.prefix_iff_eq_take.mp h)

def branchBound (T : UniformTree) : ℕ :=
  max 1 (T.leaves.sup (fun l => l.toFinset.sup id))

theorem one_le_branchBound (T : UniformTree) : 1 ≤ T.branchBound :=
  le_max_left _ _

theorem branchBound_pos (T : UniformTree) : 0 < T.branchBound :=
  Nat.lt_of_lt_of_le Nat.zero_lt_one T.one_le_branchBound

theorem label_pos {T : UniformTree} (v : T.Node) {a : ℕ} (ha : a ∈ v.val) :
    0 < a := by
  obtain ⟨l, hl, h⟩ := T.mem_vertices_iff.mp v.property
  exact T.positive_labels l hl a (h.subset ha)

theorem label_le_branchBound {T : UniformTree} (v : T.Node) {a : ℕ}
    (ha : a ∈ v.val) : a ≤ T.branchBound := by
  obtain ⟨l, hl, h⟩ := T.mem_vertices_iff.mp v.property
  calc
    a ≤ l.toFinset.sup id :=
      Finset.le_sup (f := id) (List.mem_toFinset.mpr (h.subset ha))
    _ ≤ T.leaves.sup (fun l => l.toFinset.sup id) :=
      Finset.le_sup (f := fun l : List ℕ => l.toFinset.sup id) hl
    _ ≤ T.branchBound := le_max_right _ _

theorem exists_child_word {T : UniformTree} (v : T.Node) (hv : depth v < T.height) :
    ∃ a : ℕ, v.val ++ [a] ∈ T.vertices := by
  obtain ⟨l, hl, tail, htail⟩ := T.mem_vertices_iff.mp v.property
  cases tail with
  | nil =>
    have heq : v.val = l := by simpa using htail
    have hlen : depth v = T.height := by
      change v.val.length = T.height
      rw [heq, T.length_leaf l hl]
    exact (Nat.ne_of_lt hv hlen).elim
  | cons a tail =>
    refine ⟨a, T.mem_vertices_iff.mpr ⟨l, hl, tail, ?_⟩⟩
    simpa [List.append_assoc] using htail

theorem exists_child {T : UniformTree} (v : T.Node) (hv : depth v < T.height) :
    ∃ u : T.Node, child v u := by
  obtain ⟨a, ha⟩ := exists_child_word v hv
  exact ⟨⟨v.val ++ [a], ha⟩, a, rfl⟩

theorem child_depth {T : UniformTree} {u v : T.Node} (h : child u v) :
    depth v = depth u + 1 := by
  obtain ⟨a, ha⟩ := h
  simp only [depth, ha, List.length_append, List.length_singleton]

theorem child_ancestor {T : UniformTree} {u v : T.Node} (h : child u v) :
    ancestor u v := by
  obtain ⟨a, ha⟩ := h
  exact ⟨[a], ha.symm⟩

theorem child_label_bounds {T : UniformTree} {u v : T.Node} {a : ℕ}
    (h : v.val = u.val ++ [a]) : 0 < a ∧ a ≤ T.branchBound := by
  have ha : a ∈ v.val := by simp [h]
  exact ⟨label_pos v ha, label_le_branchBound v ha⟩

theorem leaf_iff_no_child {T : UniformTree} (v : T.Node) :
    leaf v ↔ ¬ ∃ u : T.Node, child v u := by
  constructor
  · intro hv ⟨u, hu⟩
    have heq := (leaf_iff_depth_eq_height v).mp hv
    have hle := depth_le_height u
    have hdepth := child_depth hu
    omega
  · intro h
    apply (leaf_iff_depth_eq_height v).mpr
    have hle := depth_le_height v
    by_contra hne
    exact h (exists_child v (lt_of_le_of_ne hle hne))

end UniformTree

def levelCount (marks : Finset (List ℕ)) (depth : ℕ) : ℕ :=
  (marks.filter (fun w => w.length = depth)).card

def colorCount (marks : Finset (List ℕ)) (leaf : List ℕ) : ℕ :=
  (marks.filter (fun w => w.IsPrefix leaf)).card

theorem colorCount_eq_card_inter_prefixes (marks : Finset (List ℕ))
    (leaf : List ℕ) :
    colorCount marks leaf = (marks ∩ UniformTree.prefixes leaf).card := by
  unfold colorCount
  congr 1
  ext w
  simp only [Finset.mem_filter, Finset.mem_inter,
    UniformTree.mem_prefixes_iff]

def RespectsTreeQuota (T : UniformTree) (quota : ℕ → ℕ)
    (marks : Finset (List ℕ)) : Prop :=
  [] ∉ marks ∧ ∀ depth, 1 ≤ depth → depth ≤ T.height →
    levelCount marks depth ≤ quota depth

structure AuxiliaryTree (phases : ℕ) where
  tree : UniformTree
  quota : ℕ → ℕ
  quota_pos : ∀ depth, 1 ≤ depth → depth ≤ tree.height → 0 < quota depth
  red : Finset (List ℕ)
  blue : Finset (List ℕ)
  red_subset : red ⊆ tree.vertices
  blue_subset : blue ⊆ tree.vertices
  root_not_red : [] ∉ red
  root_not_blue : [] ∉ blue
  red_blue_disjoint : Disjoint red blue
  red_level : ∀ depth, 1 ≤ depth → depth ≤ tree.height →
    levelCount red depth ≤ quota depth
  blue_level : ∀ depth, 1 ≤ depth → depth ≤ tree.height →
    levelCount blue depth ≤ quota depth
  total_count : ∀ leaf ∈ tree.leaves,
    colorCount red leaf + colorCount blue leaf = phases
  red_witness : ∃ leaf ∈ tree.leaves, colorCount red leaf = phases
  blue_witness : ∃ leaf ∈ tree.leaves, colorCount blue leaf = phases

  avoids : ∀ marks : Finset (List ℕ),
    RespectsTreeQuota tree quota marks →
    ∃ leaf ∈ tree.leaves, Disjoint marks (UniformTree.prefixes leaf)

theorem card_hit_le {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (I : Finset ι) (A : Finset α) (P : ι → Finset α)
    (hP : (I : Set ι).PairwiseDisjoint P) :
    (I.filter (fun i => ¬ Disjoint A (P i))).card ≤ A.card := by
  classical
  let hit := I.filter (fun i => ¬ Disjoint A (P i))
  have hx (i : {i // i ∈ hit}) : ∃ x : {x // x ∈ A}, x.val ∈ P i.val := by
    obtain ⟨x, hxA, hxP⟩ :=
      Finset.not_disjoint_iff.mp (Finset.mem_filter.mp i.property).2
    exact ⟨⟨x, hxA⟩, hxP⟩
  let f (i : {i // i ∈ hit}) : {x // x ∈ A} := (hx i).choose
  have hf (i : {i // i ∈ hit}) : (f i).val ∈ P i.val := (hx i).choose_spec
  have hinj : Function.Injective f := by
    intro i j hij
    apply Subtype.ext
    by_contra hne
    apply Finset.disjoint_left.mp
      (hP (Finset.mem_filter.mp i.property).1
        (Finset.mem_filter.mp j.property).1 hne) (hf i)
    rw [hij]
    exact hf j
  simpa only [Fintype.card_coe, hit] using Fintype.card_le_of_injective f hinj

theorem exists_disjoint_of_card_lt {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (I : Finset ι) (A : Finset α) (P : ι → Finset α)
    (hP : (I : Set ι).PairwiseDisjoint P) (hcard : A.card < I.card) :
    ∃ i ∈ I, Disjoint A (P i) := by
  classical
  by_contra h
  have hhit : ∀ i ∈ I, ¬ Disjoint A (P i) := fun i hi hd => h ⟨i, hi, hd⟩
  have hfilter : I.filter (fun i => ¬ Disjoint A (P i)) = I :=
    Finset.filter_eq_self.mpr hhit
  have hle := card_hit_le I A P hP
  rw [hfilter] at hle
  exact (Nat.not_le_of_lt hcard) hle

def prefixesAfter (stem word : List ℕ) : Finset (List ℕ) :=
  ((UniformTree.prefixes word).erase []).image (fun v => stem ++ v)

@[simp]
theorem mem_prefixesAfter_iff {stem word w : List ℕ} :
    w ∈ prefixesAfter stem word ↔
      ∃ v, v ≠ [] ∧ v.IsPrefix word ∧ stem ++ v = w := by
  simp [prefixesAfter, Finset.mem_image, and_assoc]

theorem stem_not_mem_prefixesAfter (stem word : List ℕ) :
    stem ∉ prefixesAfter stem word := by
  intro h
  obtain ⟨v, hv, _, heq⟩ := mem_prefixesAfter_iff.mp h
  apply hv
  apply List.append_cancel_left (as := stem)
  simpa only [List.append_nil] using heq

theorem prefixes_append_eq (stem word : List ℕ) :
    UniformTree.prefixes (stem ++ word) =
      UniformTree.prefixes stem ∪ prefixesAfter stem word := by
  ext w
  simp only [Finset.mem_union, UniformTree.mem_prefixes_iff]
  constructor
  · intro hw
    rcases List.prefix_or_prefix_of_prefix hw (List.prefix_append stem word) with h | h
    · exact Or.inl h
    · obtain ⟨v, rfl⟩ := h
      by_cases hv : v = []
      · subst v
        exact Or.inl (by simpa only [List.append_nil] using List.prefix_refl stem)
      · exact Or.inr (mem_prefixesAfter_iff.mpr
          ⟨v, hv, (List.prefix_append_right_inj stem).mp hw, rfl⟩)
  · rintro (hw | hw)
    · exact hw.trans (List.prefix_append stem word)
    · obtain ⟨v, _, hv, rfl⟩ := mem_prefixesAfter_iff.mp hw
      exact (List.prefix_append_right_inj stem).mpr hv

theorem disjoint_positive_prefixes_cons {a b : ℕ} (u v : List ℕ) (hab : a ≠ b) :
    Disjoint ((UniformTree.prefixes (a :: u)).erase [])
      ((UniformTree.prefixes (b :: v)).erase []) := by
  apply Finset.disjoint_left.mpr
  intro w hwa hwb
  have hpa := UniformTree.mem_prefixes_iff.mp (Finset.mem_erase.mp hwa).2
  have hpb := UniformTree.mem_prefixes_iff.mp (Finset.mem_erase.mp hwb).2
  cases w with
  | nil => exact (Finset.mem_erase.mp hwa).1 rfl
  | cons x xs =>
      exact hab ((List.cons_prefix_cons.mp hpa).1.symm.trans
        (List.cons_prefix_cons.mp hpb).1)

theorem disjoint_prefixesAfter_cons (stem : List ℕ) {a b : ℕ}
    (u v : List ℕ) (hab : a ≠ b) :
    Disjoint (prefixesAfter stem (a :: u)) (prefixesAfter stem (b :: v)) := by
  apply Finset.disjoint_left.mpr
  intro w hwa hwb
  obtain ⟨x, hx, hxeq⟩ := Finset.mem_image.mp hwa
  obtain ⟨y, hy, hyeq⟩ := Finset.mem_image.mp hwb
  have hxy : x = y := List.append_cancel_left (hxeq.trans hyeq.symm)
  exact Finset.disjoint_left.mp (disjoint_positive_prefixes_cons u v hab)
    hx (hxy.symm ▸ hy)

theorem disjoint_positive_spine_prefixes {a b n m : ℕ} (hab : a ≠ b) :
    Disjoint ((UniformTree.prefixes ((a + 1) :: List.replicate n 1)).erase [])
      ((UniformTree.prefixes ((b + 1) :: List.replicate m 1)).erase []) := by
  apply disjoint_positive_prefixes_cons
  exact fun h => hab (Nat.add_right_cancel h)

theorem disjoint_spine_prefixesAfter (stem : List ℕ) {a b n m : ℕ} (hab : a ≠ b) :
    Disjoint (prefixesAfter stem ((a + 1) :: List.replicate n 1))
      (prefixesAfter stem ((b + 1) :: List.replicate m 1)) := by
  apply disjoint_prefixesAfter_cons
  exact fun h => hab (Nat.add_right_cancel h)

end BinPackingGap

namespace BinPackingGap.TreeGeometry

open _root_.OAI.BinPackingGap.Geometry UniformTree

inductive Side where
  | plus
  | minus
  deriving DecidableEq

instance : Fintype Side where
  elems := {.plus, .minus}
  complete s := by cases s <;> simp

def rootOffset : Side → ℚ
  | .plus => 0
  | .minus => 4

def pathSum (m R D : ℕ) : ℕ → List ℕ → ℚ
  | _, [] => 0
  | k, a :: w => 4 * (a : ℚ) * lambda m R D (k + 1) + pathSum m R D (k + 1) w

def left (m R D : ℕ) (s : Side) (w : List ℕ) : ℚ :=
  rootOffset s + pathSum m R D 0 w

def width (m R D : ℕ) (w : List ℕ) : ℚ :=
  if w = [] then 1 else lambda m R D w.length

def right (m R D : ℕ) (s : Side) (w : List ℕ) : ℚ :=
  left m R D s w + width m R D w

def cell (m R D : ℕ) (s : Side) (w : List ℕ) : Set ℚ :=
  Set.Icc (left m R D s w) (right m R D s w)

def BoundedAddress (D : ℕ) (w : List ℕ) : Prop := ∀ a ∈ w, a ≤ D

theorem boundedAddress_node {T : UniformTree} (v : T.Node) {D : ℕ}
    (hD : T.branchBound ≤ D) : BoundedAddress D v.val :=
  fun _ ha => (label_le_branchBound v ha).trans hD

@[simp] theorem left_nil (m R D : ℕ) (s : Side) :
    left m R D s [] = rootOffset s := by simp [left, pathSum]

@[simp] theorem width_nil (m R D : ℕ) : width m R D [] = 1 := by simp [width]

@[simp] theorem right_nil (m R D : ℕ) (s : Side) :
    right m R D s [] = rootOffset s + 1 := by simp [right]

theorem width_of_ne_nil (m R D : ℕ) {w : List ℕ} (hw : w ≠ []) :
    width m R D w = lambda m R D w.length := by simp [width, hw]

theorem width_pos (m R D : ℕ) (w : List ℕ) : 0 < width m R D w := by
  by_cases hw : w = []
  · simp [width, hw]
  · simpa [width, hw] using lambda_pos m R D w.length

theorem left_lt_right (m R D : ℕ) (s : Side) (w : List ℕ) :
    left m R D s w < right m R D s w := by
  exact lt_add_of_pos_right _ (width_pos m R D w)

theorem cell_nonempty (m R D : ℕ) (s : Side) (w : List ℕ) :
    (cell m R D s w).Nonempty :=
  ⟨left m R D s w, le_rfl, (left_lt_right m R D s w).le⟩

theorem pathSum_append (m R D k : ℕ) (u v : List ℕ) :
    pathSum m R D k (u ++ v) =
      pathSum m R D k u + pathSum m R D (k + u.length) v := by
  induction u generalizing k with
  | nil => simp [pathSum]
  | cons a u ih =>
    simp only [List.cons_append, pathSum, ih, List.length_cons]
    rw [show k + 1 + u.length = k + (u.length + 1) by omega]
    ring

theorem left_append_singleton (m R D : ℕ) (s : Side) (w : List ℕ) (a : ℕ) :
    left m R D s (w ++ [a]) =
      left m R D s w + 4 * (a : ℚ) * lambda m R D (w.length + 1) := by
  simp only [left, pathSum_append, Nat.zero_add, pathSum, add_zero]
  ring

theorem right_append_singleton (m R D : ℕ) (s : Side) (w : List ℕ) (a : ℕ) :
    right m R D s (w ++ [a]) =
      left m R D s w + (4 * (a : ℚ) + 1) * lambda m R D (w.length + 1) := by
  have hn : w ++ [a] ≠ [] := by simp
  rw [right, left_append_singleton, width_of_ne_nil m R D hn]
  simp only [List.length_append, List.length_singleton]
  ring

theorem child_endpoints (m R D : ℕ) (s : Side) (w : List ℕ) {a : ℕ}
    (ha : a ≤ D) :
    left m R D s w ≤ left m R D s (w ++ [a]) ∧
      right m R D s (w ++ [a]) ≤ right m R D s w := by
  have hscale := lambda_pos m R D (w.length + 1)
  have hcast : (a : ℚ) ≤ D := by exact_mod_cast ha
  have ha0 : (0 : ℚ) ≤ a := Nat.cast_nonneg a
  constructor
  · rw [left_append_singleton]
    nlinarith
  · rw [right_append_singleton, right]
    have hmul : (4 * (a : ℚ) + 1) * lambda m R D (w.length + 1) ≤
        (4 * (D : ℚ) + 1) * lambda m R D (w.length + 1) := by
      exact mul_le_mul_of_nonneg_right (by linarith) hscale.le
    by_cases hw : w = []
    · subst w
      have hfirst := first_children_lt_tenth m R D
      simp only [List.length_nil, Nat.zero_add, width_nil] at *
      linarith
    · rw [width_of_ne_nil m R D hw]
      have hchild := children_succ_lt_parent m R D w.length
      linarith

theorem append_endpoints (m R D : ℕ) (s : Side) (u v : List ℕ)
    (hv : BoundedAddress D v) :
    left m R D s u ≤ left m R D s (u ++ v) ∧
      right m R D s (u ++ v) ≤ right m R D s u := by
  induction v generalizing u with
  | nil => simp
  | cons a v ih =>
    have hc := child_endpoints m R D s u (hv a (by simp))
    have ht := ih (u ++ [a]) (fun b hb => hv b (by simp [hb]))
    have heq : (u ++ [a]) ++ v = u ++ a :: v := by simp [List.append_assoc]
    rw [heq] at ht
    exact ⟨hc.1.trans ht.1, ht.2.trans hc.2⟩

theorem prefix_endpoints (m R D : ℕ) (s : Side) {u v : List ℕ}
    (h : u.IsPrefix v) (hv : BoundedAddress D v) :
    left m R D s u ≤ left m R D s v ∧ right m R D s v ≤ right m R D s u := by
  obtain ⟨t, rfl⟩ := h
  exact append_endpoints m R D s u t (fun a ha => hv a (by simp [ha]))

theorem cell_subset_of_prefix (m R D : ℕ) (s : Side) {u v : List ℕ}
    (h : u.IsPrefix v) (hv : BoundedAddress D v) :
    cell m R D s v ⊆ cell m R D s u := by
  have hb := prefix_endpoints m R D s h hv
  intro x hx
  exact ⟨hb.1.trans hx.1, hx.2.trans hb.2⟩

theorem nonroot_endpoints (m R D : ℕ) (s : Side) {w : List ℕ}
    (hw : w ≠ []) (hb : BoundedAddress D w) :
    rootOffset s ≤ left m R D s w ∧ right m R D s w < rootOffset s + 1 / 10 := by
  cases w with
  | nil => exact (hw rfl).elim
  | cons a w =>
    have ha := hb a (by simp)
    have hroot := prefix_endpoints m R D s (u := []) List.nil_prefix hb
    have hfirst := prefix_endpoints m R D s (u := [a]) ⟨w, rfl⟩ hb
    simp only [List.singleton_append] at hfirst
    have hm : (4 * (a : ℚ) + 1) * lambda m R D 1 ≤
        (4 * (D : ℚ) + 1) * lambda m R D 1 := by
      have hcast : (a : ℚ) ≤ D := by exact_mod_cast ha
      exact mul_le_mul_of_nonneg_right (by linarith) (lambda_nonneg m R D 1)
    have hf := first_children_lt_tenth m R D
    have hr := right_append_singleton m R D s [] a
    simp only [List.nil_append, List.length_nil, Nat.zero_add, left_nil] at hr
    exact ⟨by simpa only [left_nil] using hroot.1, by linarith [hfirst.2]⟩

private theorem exists_snoc_of_length_succ {w : List ℕ} {ell : ℕ}
    (h : w.length = ell + 1) :
    ∃ u a, w = u ++ [a] ∧ u.length = ell := by
  induction w using List.reverseRecOn with
  | nil => simp at h
  | append_singleton u a _ =>
    exact ⟨u, a, rfl, by simpa using h⟩

theorem same_depth_gap (m R D ell : ℕ) {s t : Side} {u v : List ℕ}
    (hu : u.length = ell) (hv : v.length = ell)
    (hbu : BoundedAddress D u) (hbv : BoundedAddress D v)
    (hne : (s, u) ≠ (t, v)) :
    right m R D s u + 3 * lambda m R D ell ≤ left m R D t v ∨
      right m R D t v + 3 * lambda m R D ell ≤ left m R D s u := by
  induction ell generalizing s t u v with
  | zero =>
    have hu0 : u = [] := List.length_eq_zero_iff.mp hu
    have hv0 : v = [] := List.length_eq_zero_iff.mp hv
    subst u
    subst v
    have hscale := lambda_le_one m R D 0
    cases s <;> cases t <;> simp only [left_nil, right_nil, rootOffset] at *
    · exact (hne rfl).elim
    · exact Or.inl (by linarith)
    · exact Or.inr (by linarith)
    · exact (hne rfl).elim
  | succ ell ih =>
    obtain ⟨u, a, rfl, hup⟩ := exists_snoc_of_length_succ hu
    obtain ⟨v, b, rfl, hvp⟩ := exists_snoc_of_length_succ hv
    have hau : a ≤ D := hbu a (by simp)
    have hbv' : b ≤ D := hbv b (by simp)
    have hpu : BoundedAddress D u := fun c hc => hbu c (by simp [hc])
    have hpv : BoundedAddress D v := fun c hc => hbv c (by simp [hc])
    by_cases hp : (s, u) = (t, v)
    · have hs : s = t := congrArg Prod.fst hp
      have huv : u = v := congrArg Prod.snd hp
      subst t
      subst v
      have hab : a ≠ b := by
        intro heq
        exact hne (by simp [heq])
      have hscale := lambda_nonneg m R D (ell + 1)
      rw [right_append_singleton, right_append_singleton,
        left_append_singleton, left_append_singleton, hup]
      rcases lt_or_gt_of_ne hab with hab | hba
      · left
        have hc : (a : ℚ) + 1 ≤ b := by exact_mod_cast (Nat.succ_le_iff.mpr hab)
        nlinarith
      · right
        have hc : (b : ℚ) + 1 ≤ a := by exact_mod_cast (Nat.succ_le_iff.mpr hba)
        nlinarith
    · have hgap := ih hup hvp hpu hpv hp
      have hcu := child_endpoints m R D s u hau
      have hcv := child_endpoints m R D t v hbv'
      have hscale := lambda_antitone m R D (Nat.le_succ ell)
      rcases hgap with hgap | hgap
      · left
        linarith [hcu.2, hcv.1]
      · right
        linarith [hcv.2, hcu.1]

theorem eq_of_short_intersections (m R D : ℕ) {ell L : ℕ}
    (hell : ell ≤ L) {s t : Side} {u v : List ℕ} {a b : ℚ}
    (hu : u.length = ell) (hv : v.length = ell)
    (hbu : BoundedAddress D u) (hbv : BoundedAddress D v)
    (hlen : b - a ≤ lambda m R D ell + delta m R D L)
    (hiu : (Set.Icc a b ∩ cell m R D s u).Nonempty)
    (hiv : (Set.Icc a b ∩ cell m R D t v).Nonempty) : (s, u) = (t, v) := by
  by_contra hne
  have hgap := same_depth_gap m R D ell hu hv hbu hbv hne
  obtain ⟨x, hx, hxu⟩ := hiu
  obtain ⟨y, hy, hyv⟩ := hiv
  have hshort := lambda_add_delta_lt_three m R D hell
  rcases hgap with hgap | hgap
  · linarith [hx.1, hx.2, hy.1, hy.2, hxu.1, hxu.2, hyv.1, hyv.2]
  · linarith [hx.1, hx.2, hy.1, hy.2, hxu.1, hxu.2, hyv.1, hyv.2]

def nodeCell (m R D : ℕ) (s : Side) {T : UniformTree} (v : T.Node) : Set ℚ :=
  cell m R D s v.val

theorem nodeCell_subset_of_ancestor (m R D : ℕ) (s : Side) {T : UniformTree}
    (hD : T.branchBound ≤ D) {u v : T.Node} (h : ancestor u v) :
    nodeCell m R D s v ⊆ nodeCell m R D s u :=
  cell_subset_of_prefix m R D s h (boundedAddress_node v hD)

theorem nodeCell_subset_root (m R D : ℕ) (s : Side) {T : UniformTree}
    (hD : T.branchBound ≤ D) (v : T.Node) :
    nodeCell m R D s v ⊆ Set.Icc (rootOffset s) (rootOffset s + 1) := by
  simpa [nodeCell, cell] using
    nodeCell_subset_of_ancestor m R D s hD (root_ancestor v)

theorem nonroot_nodeCell_first_tenth (m R D : ℕ) (s : Side) {T : UniformTree}
    (hD : T.branchBound ≤ D) {v : T.Node} (hv : v ≠ T.root) :
    nodeCell m R D s v ⊆ Set.Ico (rootOffset s) (rootOffset s + 1 / 10) := by
  have hn : v.val ≠ [] := by
    intro heq
    exact hv (Subtype.ext heq)
  have he := nonroot_endpoints m R D s hn (boundedAddress_node v hD)
  intro x hx
  exact ⟨he.1.trans hx.1, hx.2.trans_lt he.2⟩

theorem mem_ancestor_cell (m R D : ℕ) (s : Side) {T : UniformTree}
    (hD : T.branchBound ≤ D) (v : T.Node) (ell : ℕ) {x : ℚ}
    (hx : x ∈ nodeCell m R D s v) :
    x ∈ nodeCell m R D s (ancestorAt v ell) :=
  nodeCell_subset_of_ancestor m R D s hD (ancestorAt_ancestor v ell) hx

theorem leaf_intersection_is_ancestor (m R D : ℕ) {L ell : ℕ}
    (hell : ell ≤ L) {T U : UniformTree} (hT : T.height = L)
    (hDT : T.branchBound ≤ D) (hDU : U.branchBound ≤ D)
    {s t : Side} (v : T.Node) (hv : leaf v) (w : U.Node)
    (hw : depth w = ell) {a b x : ℚ}
    (hlen : b - a ≤ lambda m R D ell + delta m R D L)
    (hx : x ∈ Set.Icc a b) (hxv : x ∈ nodeCell m R D s v)
    (hwI : (Set.Icc a b ∩ nodeCell m R D t w).Nonempty) :
    (t, w.val) = (s, (ancestorAt v ell).val) := by
  have hdepth : depth v = L := ((leaf_iff_depth_eq_height v).mp hv).trans hT
  have hanc : depth (ancestorAt v ell) = ell :=
    depth_ancestorAt v (by simpa only [hdepth] using hell)
  exact eq_of_short_intersections m R D hell hw hanc
    (boundedAddress_node w hDU) (boundedAddress_node (ancestorAt v ell) hDT)
    hlen hwI ⟨x, hx, mem_ancestor_cell m R D s hDT v ell hxv⟩

def commonBranchBound (plus minus : UniformTree) : ℕ :=
  max plus.branchBound minus.branchBound

theorem plus_branch_le (plus minus : UniformTree) :
    plus.branchBound ≤ commonBranchBound plus minus := le_max_left _ _

theorem minus_branch_le (plus minus : UniformTree) :
    minus.branchBound ≤ commonBranchBound plus minus := le_max_right _ _

end BinPackingGap.TreeGeometry

namespace BinPackingGap.IntegerPackingArithmetic

def pathNumerator (D L : ℕ) : ℕ → List ℕ → ℕ
  | _, [] => 0
  | k, a :: w => 40 * a * widthRadix D ^ (L - (k + 1)) +
      pathNumerator D L (k + 1) w

def rootOffsetNumerator : TreeGeometry.Side → ℕ
  | .plus => 0
  | .minus => 4

def treeLeftNumerator (m R D L : ℕ) (side : TreeGeometry.Side)
    (w : List ℕ) : ℕ :=
  rootOffsetNumerator side * geomDenominator m R D L + pathNumerator D L 0 w

def treeRightNumerator (m R D L : ℕ) (side : TreeGeometry.Side)
    (w : List ℕ) : ℕ :=
  treeLeftNumerator m R D L side w +
    if w = [] then geomDenominator m R D L else localNumerator D L w.length

theorem geomDenominator_mul_pathSum (m R D L k : ℕ) (w : List ℕ)
    (hdepth : k + w.length ≤ L) :
    (geomDenominator m R D L : ℚ) * TreeGeometry.pathSum m R D k w =
      (pathNumerator D L k w : ℚ) := by
  induction w generalizing k with
  | nil => simp [TreeGeometry.pathSum, pathNumerator]
  | cons a w ih =>
      have hdepth' : k + (w.length + 1) ≤ L := hdepth
      have hfirst : k + 1 ≤ L := by omega
      have htail : (k + 1) + w.length ≤ L := by
        omega
      have hlocal := geomDenominator_mul_lambda m R D L (k + 1) hfirst
      have hrest := ih (k + 1) htail
      simp only [TreeGeometry.pathSum, pathNumerator, Nat.cast_add, Nat.cast_mul,
        Nat.cast_ofNat, Nat.cast_pow]
      calc
        _ = 4 * (a : ℚ) * ((geomDenominator m R D L : ℚ) *
              Geometry.lambda m R D (k + 1)) +
            (geomDenominator m R D L : ℚ) * TreeGeometry.pathSum m R D (k + 1) w := by ring
        _ = _ := by
          rw [hlocal, hrest]
          simp only [localNumerator, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow]
          ring

theorem rootOffsetNumerator_cast (side : TreeGeometry.Side) :
    (rootOffsetNumerator side : ℚ) = TreeGeometry.rootOffset side := by
  cases side <;> rfl

theorem geomDenominator_mul_treeLeft (m R D L : ℕ)
    (side : TreeGeometry.Side) (w : List ℕ) (hdepth : w.length ≤ L) :
    (geomDenominator m R D L : ℚ) * TreeGeometry.left m R D side w =
      (treeLeftNumerator m R D L side w : ℚ) := by
  have hpath := geomDenominator_mul_pathSum m R D L 0 w (by simpa using hdepth)
  simp only [TreeGeometry.left, treeLeftNumerator, Nat.cast_add, Nat.cast_mul,
    rootOffsetNumerator_cast]
  rw [mul_add, hpath]
  ring

theorem geomDenominator_mul_treeRight (m R D L : ℕ)
    (side : TreeGeometry.Side) (w : List ℕ) (hdepth : w.length ≤ L) :
    (geomDenominator m R D L : ℚ) * TreeGeometry.right m R D side w =
      (treeRightNumerator m R D L side w : ℚ) := by
  have hleft := geomDenominator_mul_treeLeft m R D L side w hdepth
  simp only [TreeGeometry.right, mul_add, hleft, treeRightNumerator, Nat.cast_add]
  by_cases hw : w = []
  · simp [TreeGeometry.width, hw]
  · simp only [TreeGeometry.width, hw, ite_false]
    rw [geomDenominator_mul_lambda m R D L w.length hdepth]

end BinPackingGap.IntegerPackingArithmetic

end OAI
end LocalizedSource10
/- END LOCALIZED SOURCE 10/44: OAI/Computability/BinPacking/Trees/IntegerTreeGeometry.lean -/

/- BEGIN LOCALIZED SOURCE 11/44: OAI/Computability/BinPacking/Inventory/InventoryScores.lean
   SHA256: 6e343a50603e8440aa06e331999cfeaa0195c90bcfd3bf7cf0f26af3690a3474 -/
section LocalizedSource11
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Data.Fintype.Prod
-- localized import: Mathlib.Data.Fintype.Sigma
-- localized import: Mathlib.Data.Fintype.Sum
-- localized import: Mathlib.Tactic.Ring
-- localized import: OAI.Computability.BinPacking.Packing.K4Graph
-- localized import: OAI.Computability.BinPacking.Trees.IntegerTreeGeometry

namespace OAI

namespace BinPackingGap

open scoped BigOperators

structure InventoryData where
  graph : GraphInput
  plus : UniformTree
  minus : UniformTree
  d : ℕ
  R : ℕ
  L : ℕ
  quota : ℕ → ℕ
  k : ℕ

namespace InventoryData

variable (D : InventoryData)

abbrev Vertex := D.graph.Vertex
abbrev Edge := D.graph.Edge
abbrev Position := D.graph.Edge × Fin D.R
abbrev IncidencePosition (v : D.Vertex) := D.graph.IncidencePosition D.R v
abbrev JobCopy (v : D.Vertex) := D.graph.JobCopy D.R D.d v
abbrev Depth := {ell : ℕ // ell ∈ Finset.Icc 1 D.L}

def P : ℕ := ∑ ell ∈ Finset.Icc 1 D.L, D.quota ell

def tPlus : ℕ := D.d * Fintype.card D.plus.Node + D.P
def tMinus : ℕ := D.d * Fintype.card D.minus.Node
def t : ℕ := D.tPlus + D.tMinus
def J (v : D.Vertex) : ℕ := D.d * D.R * D.graph.degree v
def B : ℕ := ∑ v : D.Vertex, (D.t + 2 * D.J v)

abbrev TreeRow :=
  (D.plus.Node × Fin D.d) ⊕ ((D.minus.Node × Fin D.d) ⊕ Fin D.P)

abbrev RowAt (v : D.Vertex) := D.TreeRow ⊕ (Bool × D.JobCopy v)

abbrev MBase (v : D.Vertex) := D.TreeRow ⊕ D.JobCopy v

abbrev AnchorAt (v : D.Vertex) := D.MBase v ⊕ D.JobCopy v

abbrev PositiveLocal := Σ ell : D.Depth, Fin (D.quota ell.val)

abbrev ZeroLocalAt (v : D.Vertex) := Fin (D.t - D.P) ⊕ D.JobCopy v
abbrev DMAt (v : D.Vertex) := D.PositiveLocal ⊕ D.ZeroLocalAt v
abbrev LocalAt (v : D.Vertex) := D.DMAt v ⊕ D.JobCopy v

abbrev LocalBin (v : D.Vertex) := D.MBase v ⊕ D.JobCopy v

abbrev PlusLeaf := {v : D.plus.Node // v.val ∈ D.plus.leaves}
abbrev MinusLeaf := {v : D.minus.Node // v.val ∈ D.minus.leaves}
abbrev TestAt (v : D.Vertex) :=
  D.PlusLeaf ⊕ (D.MinusLeaf ⊕ D.IncidencePosition v)

def designated {v : D.Vertex} : D.TestAt v × Fin D.d → D.MBase v
  | ⟨.inl leaf, j⟩ => .inl (.inl (leaf.val, j))
  | ⟨.inr (.inl leaf), j⟩ => .inl (.inr (.inl (leaf.val, j)))
  | ⟨.inr (.inr r), j⟩ => .inr (r, j)

def plusSlots : ℕ := ∑ v : D.Vertex, (D.tPlus + D.J v)
def minusSlots : ℕ := D.graph.n * D.tMinus
def treeFlags : ℕ := D.graph.n * D.t
def jobFlags : ℕ := ∑ v : D.Vertex, D.J v

end InventoryData

inductive GlobalSpecies (G : GraphInput) where
  | up (unitLength : Bool)
  | um (unitLength : Bool)
  | edge (e : G.Edge) (permit : Bool)
  deriving DecidableEq

instance (G : GraphInput) : Fintype (GlobalSpecies G) where
  elems := (Finset.univ.image GlobalSpecies.up) ∪
    (Finset.univ.image GlobalSpecies.um) ∪
    ((Finset.univ : Finset (G.Edge × Bool)).image
      (fun p => GlobalSpecies.edge p.1 p.2))
  complete := by
    intro s
    cases s <;> simp

inductive FlagSpecies where
  | tree
  | main
  | edge
  deriving DecidableEq

instance : Fintype FlagSpecies where
  elems := {.tree, .main, .edge}
  complete := by intro s; cases s <;> simp

namespace InventoryData

variable (D : InventoryData)

def globalStock : GlobalSpecies D.graph → ℕ
  | .up true => D.d * D.k
  | .up false => D.plusSlots - D.d * D.k
  | .um true => D.d * (D.graph.n - D.k)
  | .um false => D.minusSlots - D.d * (D.graph.n - D.k)
  | .edge _ _ => D.d * D.R

def flagStock : FlagSpecies → ℕ
  | .tree => D.treeFlags
  | .main => D.jobFlags
  | .edge => D.jobFlags

abbrev GlobalCopy := Σ s : GlobalSpecies D.graph, Fin (D.globalStock s)
abbrev FlagCopy := Σ s : FlagSpecies, Fin (D.flagStock s)

def RoleCopies : Role → Type
  | .x => Σ v : D.Vertex, D.RowAt v
  | .anchor => Σ v : D.Vertex, D.AnchorAt v
  | .«global» => D.GlobalCopy
  | .«local» => Σ v : D.Vertex, D.LocalAt v
  | .flag => D.FlagCopy

instance roleCopiesFintype (r : Role) : Fintype (D.RoleCopies r) := by
  cases r <;> dsimp [RoleCopies] <;> infer_instance

abbrev Item := Σ r : Role, D.RoleCopies r

def itemRole (i : D.Item) : Role := i.1

def itemLabel : D.Item → Option D.Vertex
  | ⟨.x, x⟩ => some x.1
  | ⟨.anchor, a⟩ => some a.1
  | ⟨.«global», _⟩ => none
  | ⟨.«local», a⟩ => some a.1
  | ⟨.flag, _⟩ => none

def treeSubclass : D.TreeRow → Subclass
  | .inl _ => .tp
  | .inr (.inl _) => .tm
  | .inr (.inr _) => .tp

def rowSubclass {v : D.Vertex} : D.RowAt v → Subclass
  | .inl t => D.treeSubclass t
  | .inr _ => .s

def itemSubclass : D.Item → Subclass
  | ⟨.x, ⟨_, r⟩⟩ => D.rowSubclass r
  | ⟨.anchor, ⟨_, .inl _⟩⟩ => .z
  | ⟨.anchor, ⟨_, .inr _⟩⟩ => .y
  | ⟨.«global», ⟨.up _, _⟩⟩ => .up
  | ⟨.«global», ⟨.um _, _⟩⟩ => .um
  | ⟨.«global», ⟨.edge _ _, _⟩⟩ => .w
  | ⟨.«local», ⟨_, .inl _⟩⟩ => .dm
  | ⟨.«local», ⟨_, .inr _⟩⟩ => .dg
  | ⟨.flag, ⟨.tree, _⟩⟩ => .ft
  | ⟨.flag, ⟨.main, _⟩⟩ => .fm
  | ⟨.flag, ⟨.edge, _⟩⟩ => .fg

theorem itemSubclass_role (i : D.Item) : (D.itemSubclass i).role = D.itemRole i := by
  rcases i with ⟨r, i⟩
  cases r with
  | x =>
      rcases i with ⟨v, (row | job)⟩
      · rcases row with (plus | (minus | padding)) <;> rfl
      · rfl
  | anchor => rcases i with ⟨v, (deadline | key)⟩ <;> rfl
  | «global» =>
      rcases i with ⟨s, copy⟩
      cases s <;> rfl
  | «local» => rcases i with ⟨v, (main | edge)⟩ <;> rfl
  | flag =>
      rcases i with ⟨s, copy⟩
      cases s <;> rfl

def rowShort {v : D.Vertex} : D.RowAt v → Bool
  | .inl _ => false
  | .inr r => r.1

def jobPosition {v : D.Vertex} (j : D.JobCopy v) : D.Position :=
  (j.1.1.val.1, j.1.2)

def rowPosition {v : D.Vertex} : D.RowAt v → Option D.Position
  | .inl _ => none
  | .inr r => some (D.jobPosition r.2)

def keyPosition {v : D.Vertex} (k : D.JobCopy v) : D.Position :=
  D.jobPosition k

def globalUnit : D.GlobalCopy → Bool
  | ⟨.up unit, _⟩ => unit
  | ⟨.um unit, _⟩ => unit
  | ⟨.edge _ _, _⟩ => false

def globalEdge : D.GlobalCopy → Option D.Edge
  | ⟨.edge e _, _⟩ => some e
  | _ => none

def globalPermit : D.GlobalCopy → Bool
  | ⟨.edge _ permit, _⟩ => permit
  | _ => false

def localDepth {v : D.Vertex} : D.LocalAt v → Option D.Depth
  | .inl (.inl p) => some p.1
  | _ => none

end InventoryData

theorem sum_primaryScore_eq_zero_of_inventory {ι : Type*} [Fintype ι]
    (s : ι → Subclass) (B : ℕ)
    (hcard : Fintype.card ι = 5 * B)
    (hrole : ∀ r : Role, roleCount s r = (B : ℤ))
    (htree : subclassCount s .tp + subclassCount s .tm = subclassCount s .ft)
    (hanchor : subclassCount s .z = subclassCount s .ft + subclassCount s .fm)
    (hglobal : subclassCount s .up + subclassCount s .um =
      subclassCount s .ft + subclassCount s .fm)
    (hlocal : subclassCount s .dm = subclassCount s .ft + subclassCount s .fm)
    (hminus : subclassCount s .tm = subclassCount s .um) :
    (∑ i, primaryScore (s i)) = 0 := by
  apply sum_primaryScore_eq_zero_of_coefficients
  have hr (r : Role) : (∑ i, primaryCoeff (roleCoeffIndex r) (s i)) = 0 := by
    rw [sum_primaryCoeff_role, hrole, hcard]
    push_cast
    ring
  intro j
  fin_cases j
  · simpa [roleCoeffIndex, Role.index] using hr .x
  · simpa [roleCoeffIndex, Role.index] using hr .anchor
  · simpa [roleCoeffIndex, Role.index] using hr .«global»
  · simpa [roleCoeffIndex, Role.index] using hr .«local»
  · simpa [roleCoeffIndex, Role.index] using hr .flag
  · change (∑ i, primaryCoeff (5 : Fin 10) (s i)) = 0
    rw [sum_primaryCoeff_five s, htree, sub_self]
  · change (∑ i, primaryCoeff (6 : Fin 10) (s i)) = 0
    rw [sum_primaryCoeff_six s, hanchor]
    ring
  · change (∑ i, primaryCoeff (7 : Fin 10) (s i)) = 0
    rw [sum_primaryCoeff_seven s, hglobal]
    ring
  · change (∑ i, primaryCoeff (8 : Fin 10) (s i)) = 0
    rw [sum_primaryCoeff_eight s, hlocal]
    ring
  · change (∑ i, primaryCoeff (9 : Fin 10) (s i)) = 0
    rw [sum_primaryCoeff_nine s, hminus, sub_self]

def labelledRoleCount {ι : Type*} [Fintype ι] {n : ℕ}
    (s : ι → Subclass) (label : ι → Option (Fin n)) (r : Role) (v : Fin n) : ℤ :=
  ∑ i, if (s i).role = r ∧ label i = some v then 1 else 0

theorem sum_secondaryScore_eq {ι : Type*} [Fintype ι] {n : ℕ}
    (s : ι → Subclass) (label : ι → Option (Fin n)) :
    (∑ i, secondaryScore (s i) (label i)) =
      ∑ v : Fin n, (labelledRoleCount s label .x v -
        2 * labelledRoleCount s label .anchor v +
        labelledRoleCount s label .«local» v) * labelWeight v := by
  classical
  have pointwise (c : Subclass) (l : Option (Fin n)) :
      secondaryScore c l =
        ∑ v : Fin n,
          ((if c.role = Role.x ∧ l = some v then (1 : ℤ) else 0) -
            2 * (if c.role = Role.anchor ∧ l = some v then (1 : ℤ) else 0) +
            (if c.role = Role.«local» ∧ l = some v then (1 : ℤ) else 0)) *
              labelWeight v := by
    cases l with
    | none => cases hc : c.role <;> simp [secondaryScore, hc]
    | some a =>
        cases hc : c.role <;>
          simp [secondaryScore, hc, eq_comm]
  simp_rw [pointwise]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro v _
  simp only [labelledRoleCount, Finset.sum_add_distrib,
    Finset.sum_sub_distrib, Finset.sum_mul, Finset.mul_sum,
    add_mul, sub_mul, mul_assoc]

theorem sum_secondaryScore_eq_zero_of_inventory {ι : Type*} [Fintype ι] {n : ℕ}
    (s : ι → Subclass) (label : ι → Option (Fin n))
    (hx : ∀ v, labelledRoleCount s label .x v = labelledRoleCount s label .anchor v)
    (hd : ∀ v, labelledRoleCount s label .«local» v =
      labelledRoleCount s label .anchor v) :
    (∑ i, secondaryScore (s i) (label i)) = 0 := by
  rw [sum_secondaryScore_eq]
  apply Finset.sum_eq_zero
  intro v _
  rw [hx, hd]
  ring

namespace GlobalSpecies

def equivSum (G : GraphInput) :
    GlobalSpecies G ≃ (Bool ⊕ Bool) ⊕ (G.Edge × Bool) where
  toFun
    | .up b => .inl (.inl b)
    | .um b => .inl (.inr b)
    | .edge e b => .inr (e, b)
  invFun
    | .inl (.inl b) => .up b
    | .inl (.inr b) => .um b
    | .inr (e, b) => .edge e b
  left_inv s := by cases s <;> rfl
  right_inv s := by rcases s with ((b | b) | ⟨e, b⟩) <;> rfl

theorem sum_univ {A : Type*} [AddCommMonoid A] (G : GraphInput)
    (f : GlobalSpecies G → A) :
    (∑ s, f s) = f (.up true) + f (.up false) + f (.um true) + f (.um false) +
      ∑ e : G.Edge, (f (.edge e true) + f (.edge e false)) := by
  calc
    _ = ∑ x : (Bool ⊕ Bool) ⊕ (G.Edge × Bool), f ((equivSum G).symm x) :=
      Fintype.sum_equiv (equivSum G) _ _ (fun _ => by simp)
    _ = _ := by
      simp [equivSum, Fintype.sum_sum_type, Fintype.sum_prod_type,
        add_assoc, add_comm]

end GlobalSpecies

namespace FlagSpecies

theorem sum_univ {A : Type*} [AddCommMonoid A] (f : FlagSpecies → A) :
    (∑ s, f s) = f .tree + f .main + f .edge := by
  have h : (Finset.univ : Finset FlagSpecies) = {.tree, .main, .edge} := by decide
  rw [h]
  simp [add_assoc]

end FlagSpecies

namespace InventoryData

variable (D : InventoryData)

theorem card_treeRow : Fintype.card D.TreeRow = D.t := by
  simp [TreeRow, t, tPlus, tMinus, Nat.mul_comm, Nat.add_assoc,
    Nat.add_comm, Nat.add_left_comm]

theorem card_jobCopy (v : D.Vertex) : Fintype.card (D.JobCopy v) = D.J v :=
  D.graph.card_jobCopy D.R D.d v

theorem card_rowAt (v : D.Vertex) : Fintype.card (D.RowAt v) = D.t + 2 * D.J v := by
  change Fintype.card (D.TreeRow ⊕ (Bool × D.JobCopy v)) = _
  rw [Fintype.card_sum, D.card_treeRow, Fintype.card_prod, Fintype.card_bool,
    D.card_jobCopy]

theorem card_mBase (v : D.Vertex) : Fintype.card (D.MBase v) = D.t + D.J v := by
  change Fintype.card (D.TreeRow ⊕ D.JobCopy v) = _
  rw [Fintype.card_sum, D.card_treeRow, D.card_jobCopy]

theorem card_anchorAt (v : D.Vertex) :
    Fintype.card (D.AnchorAt v) = D.t + 2 * D.J v := by
  change Fintype.card (D.MBase v ⊕ D.JobCopy v) = _
  rw [Fintype.card_sum, D.card_mBase, D.card_jobCopy]
  omega

theorem card_localBin (v : D.Vertex) :
    Fintype.card (D.LocalBin v) = D.t + 2 * D.J v :=
  D.card_anchorAt v

theorem P_le_t : D.P ≤ D.t := by
  dsimp [t, tPlus, tMinus]
  omega

theorem d_le_tPlus : D.d ≤ D.tPlus := by
  have h := Nat.mul_le_mul_left D.d (D.plus.node_card_pos)
  simpa [tPlus] using (show D.d ≤ D.d * Fintype.card D.plus.Node + D.P by omega)

theorem d_le_tMinus : D.d ≤ D.tMinus := by
  have h := Nat.mul_le_mul_left D.d (D.minus.node_card_pos)
  simpa [tMinus] using h

theorem two_mul_d_le_t_sub_P : 2 * D.d ≤ D.t - D.P := by
  have hp := Nat.mul_le_mul_left D.d (D.plus.node_card_pos)
  have hm := D.d_le_tMinus
  dsimp [t, tPlus, tMinus] at *
  omega

theorem card_positiveLocal : Fintype.card D.PositiveLocal = D.P := by
  classical
  simp only [PositiveLocal, Fintype.card_sigma, Fintype.card_fin]
  exact Finset.sum_coe_sort (Finset.Icc 1 D.L) D.quota

theorem card_zeroLocalAt (v : D.Vertex) :
    Fintype.card (D.ZeroLocalAt v) = D.t + D.J v - D.P := by
  simp only [ZeroLocalAt, Fintype.card_sum, Fintype.card_fin, card_jobCopy]
  have h := D.P_le_t
  omega

theorem card_dmAt (v : D.Vertex) : Fintype.card (D.DMAt v) = D.t + D.J v := by
  change Fintype.card (D.PositiveLocal ⊕ D.ZeroLocalAt v) = _
  rw [Fintype.card_sum, D.card_positiveLocal, D.card_zeroLocalAt]
  have h := D.P_le_t
  omega

theorem card_localAt (v : D.Vertex) : Fintype.card (D.LocalAt v) = D.t + 2 * D.J v := by
  change Fintype.card (D.DMAt v ⊕ D.JobCopy v) = _
  rw [Fintype.card_sum, D.card_dmAt, D.card_jobCopy]
  omega

theorem sum_J : (∑ v : D.Vertex, D.J v) = 2 * D.d * D.graph.edges.length * D.R := by
  simpa only [D.card_jobCopy] using D.graph.sum_card_jobCopy D.R D.d

theorem plusSlots_eq : D.plusSlots = D.graph.n * D.tPlus + ∑ v : D.Vertex, D.J v := by
  simp [plusSlots, Finset.sum_add_distrib, Finset.sum_const]

theorem B_eq : D.B = D.graph.n * D.t + 2 * ∑ v : D.Vertex, D.J v := by
  simp [B, Finset.sum_add_distrib, Finset.sum_const, Finset.mul_sum]

theorem B_closed : D.B = D.graph.n * D.t + 4 * D.d * D.graph.edges.length * D.R := by
  rw [B_eq, sum_J]
  ring

theorem unitPlus_le_stock (hk : D.k ≤ D.graph.n) : D.d * D.k ≤ D.plusSlots := by
  calc
    D.d * D.k ≤ D.d * D.graph.n := Nat.mul_le_mul_left D.d hk
    _ ≤ D.graph.n * D.tPlus := by
      simpa [Nat.mul_comm] using Nat.mul_le_mul_left D.graph.n D.d_le_tPlus
    _ ≤ D.plusSlots := by rw [plusSlots_eq]; omega

theorem unitMinus_le_stock : D.d * (D.graph.n - D.k) ≤ D.minusSlots := by
  calc
    D.d * (D.graph.n - D.k) ≤ D.d * D.graph.n :=
      Nat.mul_le_mul_left D.d (Nat.sub_le _ _)
    _ ≤ D.minusSlots := by
      simpa [minusSlots, Nat.mul_comm] using
        Nat.mul_le_mul_left D.graph.n D.d_le_tMinus

theorem up_species_total (hk : D.k ≤ D.graph.n) :
    D.globalStock (.up true) + D.globalStock (.up false) = D.plusSlots := by
  dsimp [globalStock]
  exact Nat.add_sub_of_le (D.unitPlus_le_stock hk)

theorem um_species_total :
    D.globalStock (.um true) + D.globalStock (.um false) = D.minusSlots := by
  dsimp [globalStock]
  exact Nat.add_sub_of_le D.unitMinus_le_stock

theorem card_globalCopy (hk : D.k ≤ D.graph.n) : Fintype.card D.GlobalCopy = D.B := by
  rw [Fintype.card_sigma]
  simp only [Fintype.card_fin]
  rw [GlobalSpecies.sum_univ]
  rw [D.up_species_total hk]
  rw [show D.plusSlots + D.globalStock (.um true) + D.globalStock (.um false) =
    D.plusSlots + D.minusSlots by rw [Nat.add_assoc, D.um_species_total]]
  simp only [globalStock, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul]
  rw [D.plusSlots_eq, D.B_eq, D.sum_J]
  dsimp [minusSlots, t]
  ring

theorem card_flagCopy : Fintype.card D.FlagCopy = D.B := by
  rw [Fintype.card_sigma]
  simp only [Fintype.card_fin]
  rw [FlagSpecies.sum_univ]
  dsimp [flagStock, treeFlags, jobFlags]
  rw [D.B_eq]
  ring

theorem card_roleCopies (hk : D.k ≤ D.graph.n) (r : Role) :
    Fintype.card (D.RoleCopies r) = D.B := by
  cases r with
  | x =>
      change Fintype.card (Σ v : D.Vertex, D.RowAt v) = D.B
      rw [Fintype.card_sigma]
      exact Finset.sum_congr rfl fun v _ => D.card_rowAt v
  | anchor =>
      change Fintype.card (Σ v : D.Vertex, D.AnchorAt v) = D.B
      rw [Fintype.card_sigma]
      exact Finset.sum_congr rfl fun v _ => D.card_anchorAt v
  | «global» => exact D.card_globalCopy hk
  | «local» =>
      change Fintype.card (Σ v : D.Vertex, D.LocalAt v) = D.B
      rw [Fintype.card_sigma]
      exact Finset.sum_congr rfl fun v _ => D.card_localAt v
  | flag => exact D.card_flagCopy

theorem card_item (hk : D.k ≤ D.graph.n) : Fintype.card D.Item = 5 * D.B := by
  rw [Fintype.card_sigma, Role.sum_univ]
  simp only [D.card_roleCopies hk]
  omega

end InventoryData

end BinPackingGap

noncomputable section

namespace BinPackingGap
namespace InventoryData

variable (D : InventoryData)

def allJobEquiv : (Σ v : D.Vertex, D.JobCopy v) ≃
    ((D.Edge × Fin 2) × Fin D.R) × Fin D.d where
  toFun j := ((j.2.1.1.val, j.2.1.2), j.2.2)
  invFun j := ⟨D.graph.endpoint j.1.1.1 j.1.1.2,
    ((⟨j.1.1, rfl⟩, j.1.2), j.2)⟩
  left_inv := by
    rintro ⟨v, ⟨⟨⟨es, hv⟩, rep⟩, copy⟩⟩
    cases hv
    rfl
  right_inv := by rintro ⟨⟨⟨edge, side⟩, rep⟩, copy⟩; rfl

def keyItem (j : Σ v : D.Vertex, D.JobCopy v) : D.Item :=
  ⟨.anchor, ⟨j.1, .inr j.2⟩⟩

def keyData : D.Item → Option (Σ v : D.Vertex, D.JobCopy v)
  | ⟨.anchor, ⟨v, .inr j⟩⟩ => some ⟨v, j⟩
  | _ => none

@[simp] theorem keyData_keyItem (j : Σ v : D.Vertex, D.JobCopy v) :
    D.keyData (D.keyItem j) = some j := by cases j; rfl

theorem keyItem_injective : Function.Injective D.keyItem := by
  intro i j h
  exact Option.some.inj (by simpa only [D.keyData_keyItem] using congrArg D.keyData h)

@[simp] theorem keyItem_role (j : Σ v : D.Vertex, D.JobCopy v) :
    D.itemRole (D.keyItem j) = .anchor := rfl

@[simp] theorem keyItem_subclass (j : Σ v : D.Vertex, D.JobCopy v) :
    D.itemSubclass (D.keyItem j) = .y := rfl

@[simp] theorem keyItem_label (j : Σ v : D.Vertex, D.JobCopy v) :
    D.itemLabel (D.keyItem j) = some j.1 := rfl

def edgeResourceItem (w : (D.Edge × Bool) × Fin (D.d * D.R)) : D.Item :=
  ⟨.«global», ⟨.edge w.1.1 w.1.2, w.2⟩⟩

def edgeResourceData : D.Item → Option ((D.Edge × Bool) × Fin (D.d * D.R))
  | ⟨.«global», ⟨.edge e permit, copy⟩⟩ => some ((e, permit), copy)
  | _ => none

@[simp] theorem edgeResourceData_edgeResourceItem
    (w : (D.Edge × Bool) × Fin (D.d * D.R)) :
    D.edgeResourceData (D.edgeResourceItem w) = some w := by cases w; rfl

theorem edgeResourceItem_injective : Function.Injective D.edgeResourceItem := by
  intro i j h
  exact Option.some.inj (by
    simpa only [D.edgeResourceData_edgeResourceItem] using congrArg D.edgeResourceData h)

def prefixJobIndex (h : ℕ) (hle : h ≤ D.graph.edges.length)
    (j : ((Fin h × Fin 2) × Fin D.R) × Fin D.d) :
    ((D.Edge × Fin 2) × Fin D.R) × Fin D.d :=
  ((⟨⟨j.1.1.1.val, lt_of_lt_of_le j.1.1.1.isLt hle⟩, j.1.1.2⟩, j.1.2), j.2)

theorem prefixJobIndex_injective (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    Function.Injective (D.prefixJobIndex h hle) := by
  intro i j hij
  apply Prod.ext
  · apply Prod.ext
    · apply Prod.ext
      · apply Fin.ext
        exact congrArg (fun x => x.1.1.1.val) hij
      · exact congrArg (fun x => x.1.1.2) hij
    · exact congrArg (fun x => x.1.2) hij
  · exact congrArg (fun x : ((D.Edge × Fin 2) × Fin D.R) × Fin D.d => x.2) hij

def earlierKeys (h : ℕ) (hle : h ≤ D.graph.edges.length) : Finset D.Item := by
  classical
  exact Finset.univ.image fun j => D.keyItem (D.allJobEquiv.symm (D.prefixJobIndex h hle j))

theorem earlierKeys_card (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.earlierKeys h hle).card = 2 * D.d * D.R * h := by
  classical
  have hinj : Function.Injective (fun j : ((Fin h × Fin 2) × Fin D.R) × Fin D.d =>
      D.keyItem (D.allJobEquiv.symm (D.prefixJobIndex h hle j))) := by
    intro i j hij
    exact D.prefixJobIndex_injective h hle
      (D.allJobEquiv.symm.injective (D.keyItem_injective hij))
  rw [earlierKeys, Finset.card_image_of_injective _ hinj]
  simp [Fintype.card_prod, Nat.mul_comm, Nat.mul_left_comm]

theorem mem_earlierKeys (h : ℕ) (hle : h ≤ D.graph.edges.length) (i : D.Item) :
    i ∈ D.earlierKeys h hle ↔
      ∃ j : Σ v : D.Vertex, D.JobCopy v,
        D.keyItem j = i ∧ (D.jobPosition j.2).1.val < h := by
  classical
  constructor
  · intro hi
    obtain ⟨j, _, rfl⟩ := Finset.mem_image.mp hi
    exact ⟨D.allJobEquiv.symm (D.prefixJobIndex h hle j), rfl, j.1.1.1.isLt⟩
  · rintro ⟨j, rfl, hj⟩
    let a := D.allJobEquiv j
    let x : ((Fin h × Fin 2) × Fin D.R) × Fin D.d :=
      ((⟨⟨a.1.1.1.val, hj⟩, a.1.1.2⟩, a.1.2), a.2)
    have hx : D.prefixJobIndex h hle x = a := by
      apply Prod.ext
      · apply Prod.ext
        · apply Prod.ext
          · apply Fin.ext; rfl
          · rfl
        · rfl
      · rfl
    refine Finset.mem_image.mpr ⟨x, Finset.mem_univ _, ?_⟩
    rw [hx]
    exact congrArg D.keyItem (D.allJobEquiv.symm_apply_apply j)

def prefixWIndex (h : ℕ) (hle : h ≤ D.graph.edges.length)
    (w : (Fin h × Bool) × Fin (D.d * D.R)) :
    (D.Edge × Bool) × Fin (D.d * D.R) :=
  ((⟨w.1.1.val, lt_of_lt_of_le w.1.1.isLt hle⟩, w.1.2), w.2)

theorem prefixWIndex_injective (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    Function.Injective (D.prefixWIndex h hle) := by
  intro i j hij
  apply Prod.ext
  · apply Prod.ext
    · apply Fin.ext
      exact congrArg (fun x => x.1.1.val) hij
    · exact congrArg (fun x => x.1.2) hij
  · exact congrArg (fun x : (D.Edge × Bool) × Fin (D.d * D.R) => x.2) hij

def earlierW (h : ℕ) (hle : h ≤ D.graph.edges.length) : Finset D.Item := by
  classical
  exact Finset.univ.image fun w => D.edgeResourceItem (D.prefixWIndex h hle w)

theorem earlierW_card (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.earlierW h hle).card = 2 * D.d * D.R * h := by
  classical
  have hinj : Function.Injective (fun w : (Fin h × Bool) × Fin (D.d * D.R) =>
      D.edgeResourceItem (D.prefixWIndex h hle w)) := by
    intro i j hij
    exact D.prefixWIndex_injective h hle (D.edgeResourceItem_injective hij)
  rw [earlierW, Finset.card_image_of_injective _ hinj]
  simp [Fintype.card_prod, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc]

theorem mem_earlierW (h : ℕ) (hle : h ≤ D.graph.edges.length) (i : D.Item) :
    i ∈ D.earlierW h hle ↔
      ∃ w : (D.Edge × Bool) × Fin (D.d * D.R),
        D.edgeResourceItem w = i ∧ w.1.1.val < h := by
  classical
  constructor
  · intro hi
    obtain ⟨w, _, rfl⟩ := Finset.mem_image.mp hi
    exact ⟨D.prefixWIndex h hle w, rfl, w.1.1.isLt⟩
  · rintro ⟨w, rfl, hw⟩
    let x : (Fin h × Bool) × Fin (D.d * D.R) :=
      ((⟨w.1.1.val, hw⟩, w.1.2), w.2)
    have hx : D.prefixWIndex h hle x = w := by
      apply Prod.ext
      · apply Prod.ext
        · apply Fin.ext; rfl
        · rfl
      · rfl
    exact Finset.mem_image.mpr ⟨x, Finset.mem_univ _, congrArg D.edgeResourceItem hx⟩

theorem earlierW_card_eq_keys (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.earlierW h hle).card = (D.earlierKeys h hle).card := by
  rw [D.earlierW_card, D.earlierKeys_card]

end InventoryData
end BinPackingGap

end

namespace BinPackingGap

open scoped BigOperators

namespace InventoryData

variable (D : InventoryData)

private theorem subclassCount_by_role (subclass : Subclass) :
    subclassCount D.itemSubclass subclass =
      ∑ i : D.RoleCopies subclass.role,
        subclassIndicator (D.itemSubclass ⟨subclass.role, i⟩) subclass := by
  classical
  unfold subclassCount
  rw [Fintype.sum_sigma]
  refine Finset.sum_eq_single subclass.role ?_ ?_
  · intro r _ hr
    apply Finset.sum_eq_zero
    intro i _
    apply ite_eq_right
    intro hi
    apply hr
    calc
      r = (D.itemSubclass ⟨r, i⟩).role := (D.itemSubclass_role ⟨r, i⟩).symm
      _ = subclass.role := congrArg Subclass.role hi
  · simp

theorem roleCount_itemSubclass (hk : D.k ≤ D.graph.n) (r : Role) :
    roleCount D.itemSubclass r = (D.B : ℤ) := by
  classical
  simp only [roleCount, D.itemSubclass_role, itemRole, Fintype.sum_sigma]
  have hrole : (∑ s : Role, ∑ _ : D.RoleCopies s,
      if s = r then (1 : ℤ) else 0) = (Fintype.card (D.RoleCopies r) : ℤ) := by
    simp
  rw [hrole, D.card_roleCopies hk]

theorem subclassCount_tp :
    subclassCount D.itemSubclass .tp = D.graph.n * (D.tPlus : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.RowAt v), subclassIndicator (D.itemSubclass ⟨.x, i⟩) .tp) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, rowSubclass, TreeRow, treeSubclass, subclassIndicator,
    Fintype.sum_sum_type, tPlus, Nat.cast_add, Nat.cast_mul, mul_add,
    mul_comm, mul_left_comm]

theorem subclassCount_tm :
    subclassCount D.itemSubclass .tm = D.graph.n * (D.tMinus : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.RowAt v), subclassIndicator (D.itemSubclass ⟨.x, i⟩) .tm) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, rowSubclass, TreeRow, treeSubclass, subclassIndicator,
    Fintype.sum_sum_type, tMinus, Nat.cast_mul, mul_comm, mul_left_comm]

theorem subclassCount_s :
    subclassCount D.itemSubclass .s = 2 * ∑ v : D.Vertex, (D.J v : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.RowAt v), subclassIndicator (D.itemSubclass ⟨.x, i⟩) .s) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, rowSubclass, TreeRow, treeSubclass, subclassIndicator,
    Fintype.sum_sum_type, D.card_jobCopy, Finset.mul_sum, mul_comm]

theorem subclassCount_z :
    subclassCount D.itemSubclass .z = ∑ v : D.Vertex, ((D.t + D.J v : ℕ) : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.AnchorAt v), subclassIndicator (D.itemSubclass ⟨.anchor, i⟩) .z) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator,
    Fintype.sum_sum_type, D.card_mBase]

theorem subclassCount_y :
    subclassCount D.itemSubclass .y = ∑ v : D.Vertex, (D.J v : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.AnchorAt v), subclassIndicator (D.itemSubclass ⟨.anchor, i⟩) .y) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator,
    Fintype.sum_sum_type, D.card_jobCopy]

theorem subclassCount_up (hk : D.k ≤ D.graph.n) :
    subclassCount D.itemSubclass .up = (D.plusSlots : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ t : GlobalSpecies D.graph, Fin (D.globalStock t)), subclassIndicator (D.itemSubclass ⟨.«global», i⟩) .up) = _
  rw [Fintype.sum_sigma]
  have h := congrArg (fun x : ℕ => (x : ℤ)) (D.up_species_total hk)
  simpa [subclassCount, itemSubclass, RoleCopies, subclassIndicator,
    Fintype.sum_sigma, Role.sum_univ, GlobalSpecies.sum_univ,
    Fintype.sum_sum_type] using h

theorem subclassCount_um :
    subclassCount D.itemSubclass .um = (D.minusSlots : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ t : GlobalSpecies D.graph, Fin (D.globalStock t)), subclassIndicator (D.itemSubclass ⟨.«global», i⟩) .um) = _
  rw [Fintype.sum_sigma]
  have h := congrArg (fun x : ℕ => (x : ℤ)) D.um_species_total
  simpa [subclassCount, itemSubclass, RoleCopies, subclassIndicator,
    Fintype.sum_sigma, Role.sum_univ, GlobalSpecies.sum_univ,
    Fintype.sum_sum_type] using h

theorem subclassCount_dm :
    subclassCount D.itemSubclass .dm = ∑ v : D.Vertex, ((D.t + D.J v : ℕ) : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.LocalAt v), subclassIndicator (D.itemSubclass ⟨.«local», i⟩) .dm) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator,
    Fintype.sum_sum_type, D.card_dmAt]

theorem subclassCount_dg :
    subclassCount D.itemSubclass .dg = ∑ v : D.Vertex, (D.J v : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ v : D.Vertex, D.LocalAt v), subclassIndicator (D.itemSubclass ⟨.«local», i⟩) .dg) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator,
    Fintype.sum_sum_type, D.card_jobCopy]

theorem subclassCount_ft :
    subclassCount D.itemSubclass .ft = (D.treeFlags : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ t : FlagSpecies, Fin (D.flagStock t)), subclassIndicator (D.itemSubclass ⟨.flag, i⟩) .ft) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator, FlagSpecies.sum_univ, flagStock]
  change Fintype.card (Fin D.treeFlags) = D.treeFlags
  exact Fintype.card_fin _

theorem subclassCount_fm :
    subclassCount D.itemSubclass .fm = (D.jobFlags : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ t : FlagSpecies, Fin (D.flagStock t)), subclassIndicator (D.itemSubclass ⟨.flag, i⟩) .fm) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator, FlagSpecies.sum_univ, flagStock]
  change Fintype.card (Fin D.jobFlags) = D.jobFlags
  exact Fintype.card_fin _

theorem subclassCount_fg :
    subclassCount D.itemSubclass .fg = (D.jobFlags : ℤ) := by
  classical
  rw [D.subclassCount_by_role]
  change (∑ i : (Σ t : FlagSpecies, Fin (D.flagStock t)), subclassIndicator (D.itemSubclass ⟨.flag, i⟩) .fg) = _
  rw [Fintype.sum_sigma]
  simp [itemSubclass, RoleCopies, subclassIndicator, FlagSpecies.sum_univ, flagStock]
  change Fintype.card (Fin D.jobFlags) = D.jobFlags
  exact Fintype.card_fin _

theorem total_primaryScore_eq_zero (hk : D.k ≤ D.graph.n) :
    (∑ i : D.Item, primaryScore (D.itemSubclass i)) = 0 := by
  apply sum_primaryScore_eq_zero_of_inventory D.itemSubclass D.B
    (D.card_item hk) (D.roleCount_itemSubclass hk)
  · rw [D.subclassCount_tp, D.subclassCount_tm, D.subclassCount_ft]
    simp [treeFlags, t, Nat.cast_mul, Nat.cast_add, mul_add]
  · rw [D.subclassCount_z, D.subclassCount_ft, D.subclassCount_fm]
    simp [treeFlags, jobFlags, Nat.cast_mul, Nat.cast_sum, Nat.cast_add,
      Finset.sum_add_distrib]
  · rw [D.subclassCount_up hk, D.subclassCount_um, D.subclassCount_ft,
      D.subclassCount_fm, D.plusSlots_eq]
    simp [minusSlots, treeFlags, jobFlags, t, Nat.cast_mul, Nat.cast_add,
      Nat.cast_sum, mul_add]
    ring
  · rw [D.subclassCount_dm, D.subclassCount_ft, D.subclassCount_fm]
    simp [treeFlags, jobFlags, Nat.cast_mul, Nat.cast_sum, Nat.cast_add,
      Finset.sum_add_distrib]
  · rw [D.subclassCount_tm, D.subclassCount_um]
    simp [minusSlots]

set_option backward.isDefEq.respectTransparency false in
theorem labelledRoleCount_x (v : D.Vertex) :
    labelledRoleCount D.itemSubclass D.itemLabel .x v =
      ((D.t + 2 * D.J v : ℕ) : ℤ) := by
  classical
  unfold labelledRoleCount
  simp_rw [D.itemSubclass_role]
  rw [Fintype.sum_sigma, Role.sum_univ]
  simp only [itemRole, RoleCopies, Fintype.sum_sigma]
  simp [itemLabel, D.card_rowAt]

set_option backward.isDefEq.respectTransparency false in
theorem labelledRoleCount_anchor (v : D.Vertex) :
    labelledRoleCount D.itemSubclass D.itemLabel .anchor v =
      ((D.t + 2 * D.J v : ℕ) : ℤ) := by
  classical
  unfold labelledRoleCount
  simp_rw [D.itemSubclass_role]
  rw [Fintype.sum_sigma, Role.sum_univ]
  simp only [itemRole, RoleCopies, Fintype.sum_sigma]
  simp [itemLabel, D.card_anchorAt]

set_option backward.isDefEq.respectTransparency false in
theorem labelledRoleCount_local (v : D.Vertex) :
    labelledRoleCount D.itemSubclass D.itemLabel .«local» v =
      ((D.t + 2 * D.J v : ℕ) : ℤ) := by
  classical
  unfold labelledRoleCount
  simp_rw [D.itemSubclass_role]
  rw [Fintype.sum_sigma, Role.sum_univ]
  simp only [itemRole, RoleCopies, Fintype.sum_sigma]
  simp [itemLabel, D.card_localAt]

theorem total_secondaryScore_eq_zero :
    (∑ i : D.Item, secondaryScore (D.itemSubclass i) (D.itemLabel i)) = 0 := by
  apply sum_secondaryScore_eq_zero_of_inventory D.itemSubclass D.itemLabel
  · intro v
    rw [D.labelledRoleCount_x, D.labelledRoleCount_anchor]
  · intro v
    rw [D.labelledRoleCount_local, D.labelledRoleCount_anchor]

end InventoryData

end BinPackingGap

end OAI
end LocalizedSource11
/- END LOCALIZED SOURCE 11/44: OAI/Computability/BinPacking/Inventory/InventoryScores.lean -/

/- BEGIN LOCALIZED SOURCE 12/44: OAI/Computability/BinPacking/Inventory/LabelConservation.lean
   SHA256: 3db132ddd43b3b3c464c9a2d266f575bc29ad70856397123a6a7216767a3b07c -/
section LocalizedSource12
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Basic
-- localized import: Mathlib.Data.Finset.Card
-- localized import: Mathlib.Data.Fintype.Basic

namespace OAI

namespace BinPackingGap
namespace FinitePrefixConservation

variable {α β : Type*} [DecidableEq α] [DecidableEq β]

theorem remaining_eq_bad (keys good : Finset α) (resources : Finset β)
    (f : α → β) (hgood : good ⊆ keys)
    (hmap : ∀ x ∈ good, f x ∈ resources)
    (hinj : Set.InjOn f (good : Set α))
    (hcard : resources.card = keys.card) :
    (resources \ good.image f).card = (keys \ good).card := by
  have himage : good.image f ⊆ resources := Finset.image_subset_iff.mpr hmap
  rw [Finset.card_sdiff_of_subset himage, Finset.card_sdiff_of_subset hgood,
    Finset.card_image_of_injOn hinj, hcard]

theorem remaining_le_bad (keys good : Finset α) (resources remaining : Finset β)
    (f : α → β) (hgood : good ⊆ keys)
    (hmap : ∀ x ∈ good, f x ∈ resources)
    (hinj : Set.InjOn f (good : Set α))
    (hcard : resources.card = keys.card)
    (hremaining : remaining ⊆ resources \ good.image f) :
    remaining.card ≤ (keys \ good).card := by
  calc
    remaining.card ≤ (resources \ good.image f).card := Finset.card_le_card hremaining
    _ = (keys \ good).card := remaining_eq_bad keys good resources f hgood hmap hinj hcard

end FinitePrefixConservation

namespace LabelConservation

open scoped BigOperators

variable {n : ℕ}
variable {T A R D : Type*}
variable [Fintype T] [Fintype A] [Fintype R] [Fintype D]
variable [DecidableEq A] [DecidableEq R] [DecidableEq D]

def outsideItems (f : T → A) : Finset A := Finset.univ \ Finset.univ.image f

def prefixItems (label : A → Fin n) (h : ℕ) : Finset A :=
  Finset.univ.filter fun x => (label x).val < h

def prefixOutside (label : A → Fin n) (f : T → A) (h : ℕ) : Finset A :=
  (outsideItems f).filter fun x => (label x).val < h

def exports (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R) (h : ℕ) : Finset T :=
  Finset.univ.filter fun t =>
    (labelR (role t)).val < h ∧ ¬ (labelA (anchor t)).val < h

def labelDefects (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R) (v : Fin n) : Finset T :=
  Finset.univ.filter fun t => labelA (anchor t) = v ∧ labelR (role t) ≠ v

omit [DecidableEq A] in
@[simp] theorem prefixItems_zero (label : A → Fin n) : prefixItems label 0 = ∅ := by
  simp [prefixItems]

@[simp] theorem prefixOutside_zero (label : A → Fin n) (f : T → A) :
    prefixOutside label f 0 = ∅ := by
  simp [prefixOutside]

omit [Fintype A] [Fintype R] [DecidableEq A] [DecidableEq R] in
@[simp] theorem exports_zero (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R) : exports labelA labelR anchor role 0 = ∅ := by
  simp [exports]

omit [DecidableEq A] [DecidableEq R] in
theorem prefix_inventory_eq (labelA : A → Fin n) (labelR : R → Fin n)
    (hInv : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun r => labelR r = v).card) (h : ℕ) :
    (prefixItems labelA h).card = (prefixItems labelR h).card := by
  let labels : Finset (Fin n) := Finset.univ.filter fun v => v.val < h
  have hA := Finset.sum_card_fiberwise_eq_card_filter (Finset.univ : Finset A)
    labels labelA
  have hR := Finset.sum_card_fiberwise_eq_card_filter (Finset.univ : Finset R)
    labels labelR
  have hsum : (∑ v ∈ labels, (Finset.univ.filter fun a => labelA a = v).card) =
      ∑ v ∈ labels, (Finset.univ.filter fun r => labelR r = v).card := by
    exact Finset.sum_congr rfl fun v _ => hInv v
  simpa only [labels, Finset.mem_filter, Finset.mem_univ, true_and, prefixItems]
    using hA.symm.trans (hsum.trans hR)

theorem outside_add_selected_eq (label : A → Fin n) (f : T → A)
    (hf : Function.Injective f) (h : ℕ) :
    (prefixOutside label f h).card + (prefixItems (label ∘ f) h).card =
      (prefixItems label h).card := by
  have hsplit := Finset.card_sdiff_add_card_inter
    (prefixItems label h) (Finset.univ.image f)
  have hout : prefixItems label h \ Finset.univ.image f = prefixOutside label f h := by
    ext x
    simp [prefixItems, prefixOutside, outsideItems, and_comm]
  have hin : prefixItems label h ∩ Finset.univ.image f =
      (Finset.univ.image f).filter (fun x => (label x).val < h) := by
    ext x
    simp [prefixItems, and_comm]
  rw [hout, hin, Finset.filter_image, Finset.card_image_of_injective _ hf] at hsplit
  simpa only [prefixItems, Function.comp_apply] using hsplit

omit [Fintype A] [Fintype R] [DecidableEq A] [DecidableEq R] in
theorem selected_add_exports_eq (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R)
    (hle : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val) (h : ℕ) :
    (prefixItems (labelA ∘ anchor) h).card + (exports labelA labelR anchor role h).card =
      (prefixItems (labelR ∘ role) h).card := by
  have hsplit := Finset.card_filter_add_card_filter_not
    (s := prefixItems (labelR ∘ role) h) (fun t => (labelA (anchor t)).val < h)
  have hin : (prefixItems (labelR ∘ role) h).filter
      (fun t => (labelA (anchor t)).val < h) = prefixItems (labelA ∘ anchor) h := by
    ext t
    simp only [Finset.mem_filter, prefixItems, Finset.mem_univ, true_and,
      Function.comp_apply]
    exact ⟨fun ht => ht.2, fun ht => ⟨lt_of_le_of_lt (hle t) ht, ht⟩⟩
  have hout : (prefixItems (labelR ∘ role) h).filter
      (fun t => ¬ (labelA (anchor t)).val < h) = exports labelA labelR anchor role h := by
    ext t
    simp [prefixItems, exports]
  rw [hin, hout] at hsplit
  exact hsplit

theorem exports_add_outsideRole_eq_outsideAnchor
    (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R)
    (hAnchor : Function.Injective anchor) (hRole : Function.Injective role)
    (hle : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val)
    (hInv : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun r => labelR r = v).card) (h : ℕ) :
    (exports labelA labelR anchor role h).card + (prefixOutside labelR role h).card =
      (prefixOutside labelA anchor h).card := by
  have hA := outside_add_selected_eq labelA anchor hAnchor h
  have hR := outside_add_selected_eq labelR role hRole h
  have hE := selected_add_exports_eq labelA labelR anchor role hle h
  have hI := prefix_inventory_eq labelA labelR hInv h
  omega

theorem exports_eq_outside_sub
    (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R)
    (hAnchor : Function.Injective anchor) (hRole : Function.Injective role)
    (hle : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val)
    (hInv : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun r => labelR r = v).card) (h : ℕ) :
    ((exports labelA labelR anchor role h).card : ℤ) =
      (prefixOutside labelA anchor h).card - (prefixOutside labelR role h).card := by
  have hcon := exports_add_outsideRole_eq_outsideAnchor
    labelA labelR anchor role hAnchor hRole hle hInv h
  omega

theorem exports_card_le_outside
    (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R)
    (hAnchor : Function.Injective anchor) (hRole : Function.Injective role)
    (hle : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val)
    (hInv : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun r => labelR r = v).card) (h : ℕ) :
    (exports labelA labelR anchor role h).card ≤ (outsideItems anchor).card := by
  have hcon := exports_add_outsideRole_eq_outsideAnchor
    labelA labelR anchor role hAnchor hRole hle hInv h
  have hout : (prefixOutside labelA anchor h).card ≤ (outsideItems anchor).card :=
    Finset.card_le_card (Finset.filter_subset _ _)
  omega

omit [Fintype A] [Fintype R] [DecidableEq A] [DecidableEq R] in
theorem labelDefects_subset_exports
    (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R)
    (hle : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val) (v : Fin n) :
    labelDefects labelA labelR anchor role v ⊆ exports labelA labelR anchor role v.val := by
  intro t ht
  obtain ⟨ha, hr⟩ := (Finset.mem_filter.mp ht).2
  have hl := hle t
  rw [ha] at hl
  have hn : (labelR (role t)).val ≠ v.val := fun he => hr (Fin.ext he)
  apply Finset.mem_filter.mpr
  refine ⟨Finset.mem_univ _, ?_, ?_⟩
  · omega
  · simp [ha]

theorem labelDefects_card_le_outside
    (labelA : A → Fin n) (labelR : R → Fin n)
    (anchor : T → A) (role : T → R)
    (hAnchor : Function.Injective anchor) (hRole : Function.Injective role)
    (hle : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val)
    (hInv : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun r => labelR r = v).card) (v : Fin n) :
    (labelDefects labelA labelR anchor role v).card ≤ (outsideItems anchor).card := by
  exact (Finset.card_le_card (labelDefects_subset_exports labelA labelR anchor role hle v)).trans
    (exports_card_le_outside labelA labelR anchor role hAnchor hRole hle hInv v.val)

def badAnchors (labelA : A → Fin n) (labelR : R → Fin n) (labelD : D → Fin n)
    (anchor : T → A) (role : T → R) (localRole : T → D) (v : Fin n) : Finset A :=
  ((outsideItems anchor).filter fun a => labelA a = v) ∪
    (labelDefects labelA labelR anchor role v).image anchor ∪
    (labelDefects labelA labelD anchor localRole v).image anchor

omit [Fintype R] [Fintype D] [DecidableEq R] [DecidableEq D] in
theorem mem_badAnchors_iff
    (labelA : A → Fin n) (labelR : R → Fin n) (labelD : D → Fin n)
    (anchor : T → A) (role : T → R) (localRole : T → D)
    (hAnchor : Function.Injective anchor) (v : Fin n) (a : A) :
    a ∈ badAnchors labelA labelR labelD anchor role localRole v ↔
      labelA a = v ∧
        ¬ ∃ t, anchor t = a ∧ labelR (role t) = v ∧ labelD (localRole t) = v := by
  constructor
  · intro hbad
    rcases Finset.mem_union.mp hbad with hleft | hd
    · rcases Finset.mem_union.mp hleft with ho | hr
      · obtain ⟨hoa, hv⟩ := Finset.mem_filter.mp ho
        refine ⟨hv, ?_⟩
        rintro ⟨t, hat, _, _⟩
        exact (Finset.mem_sdiff.mp hoa).2
          (Finset.mem_image.mpr ⟨t, Finset.mem_univ _, hat⟩)
      · obtain ⟨t, ht, hat⟩ := Finset.mem_image.mp hr
        obtain ⟨hva, hvr⟩ := (Finset.mem_filter.mp ht).2
        refine ⟨by simpa only [hat] using hva, ?_⟩
        rintro ⟨u, hua, hur, _⟩
        have htu : t = u := hAnchor (hat.trans hua.symm)
        exact hvr (by simpa only [htu] using hur)
    · obtain ⟨t, ht, hat⟩ := Finset.mem_image.mp hd
      obtain ⟨hva, hvd⟩ := (Finset.mem_filter.mp ht).2
      refine ⟨by simpa only [hat] using hva, ?_⟩
      rintro ⟨u, hua, _, hud⟩
      have htu : t = u := hAnchor (hat.trans hua.symm)
      exact hvd (by simpa only [htu] using hud)
  · rintro ⟨hv, hnot⟩
    by_cases ha : a ∈ Finset.univ.image anchor
    · obtain ⟨t, _, hat⟩ := Finset.mem_image.mp ha
      have htv : labelA (anchor t) = v := by simpa only [hat] using hv
      by_cases hr : labelR (role t) = v
      · have hd : labelD (localRole t) ≠ v := fun hd => hnot ⟨t, hat, hr, hd⟩
        apply Finset.mem_union_right
        exact Finset.mem_image.mpr ⟨t, Finset.mem_filter.mpr
          ⟨Finset.mem_univ _, htv, hd⟩, hat⟩
      · apply Finset.mem_union_left
        apply Finset.mem_union_right
        exact Finset.mem_image.mpr ⟨t, Finset.mem_filter.mpr
          ⟨Finset.mem_univ _, htv, hr⟩, hat⟩
    · apply Finset.mem_union_left
      apply Finset.mem_union_left
      exact Finset.mem_filter.mpr
        ⟨Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, ha⟩, hv⟩

theorem badAnchors_card_le_three_mul
    (labelA : A → Fin n) (labelR : R → Fin n) (labelD : D → Fin n)
    (anchor : T → A) (role : T → R) (localRole : T → D)
    (hAnchor : Function.Injective anchor) (hRole : Function.Injective role)
    (hLocal : Function.Injective localRole)
    (hleR : ∀ t, (labelR (role t)).val ≤ (labelA (anchor t)).val)
    (hleD : ∀ t, (labelD (localRole t)).val ≤ (labelA (anchor t)).val)
    (hInvR : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun r => labelR r = v).card)
    (hInvD : ∀ v, (Finset.univ.filter fun a => labelA a = v).card =
      (Finset.univ.filter fun d => labelD d = v).card)
    (K : ℕ) (hOutside : (outsideItems anchor).card ≤ K) (v : Fin n) :
    (badAnchors labelA labelR labelD anchor role localRole v).card ≤ 3 * K := by
  have hR := labelDefects_card_le_outside labelA labelR anchor role hAnchor hRole hleR hInvR v
  have hD := labelDefects_card_le_outside labelA labelD anchor localRole
    hAnchor hLocal hleD hInvD v
  have hO : ((outsideItems anchor).filter fun a => labelA a = v).card ≤
      (outsideItems anchor).card := Finset.card_le_card (Finset.filter_subset _ _)
  have hRi := Finset.card_image_le (s := labelDefects labelA labelR anchor role v) (f := anchor)
  have hDi := Finset.card_image_le (s := labelDefects labelA labelD anchor localRole v)
    (f := anchor)
  have hU := Finset.card_union_le
    ((outsideItems anchor).filter fun a => labelA a = v)
    ((labelDefects labelA labelR anchor role v).image anchor)
  have hV := Finset.card_union_le
    (((outsideItems anchor).filter fun a => labelA a = v) ∪
      (labelDefects labelA labelR anchor role v).image anchor)
    ((labelDefects labelA labelD anchor localRole v).image anchor)
  unfold badAnchors
  omega

end LabelConservation
end BinPackingGap

end OAI
end LocalizedSource12
/- END LOCALIZED SOURCE 12/44: OAI/Computability/BinPacking/Inventory/LabelConservation.lean -/

/- BEGIN LOCALIZED SOURCE 13/44: OAI/Computability/BinPacking/Packing/GoodAnchorBound.lean
   SHA256: d08ba82e39f6b4ab98787495e7571d259fd41c67f0bcf741c36a1ff55a7a522f -/
section LocalizedSource13
-- localized import: OAI.Computability.BinPacking.Inventory.CurrentMatches
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryScores
-- localized import: OAI.Computability.BinPacking.Inventory.LabelConservation

namespace OAI

noncomputable section

namespace BinPackingGap

open scoped BigOperators

variable {I : Instance} {b n : ℕ}

abbrev RoleItem (cls : I.Item → Subclass) (r : Role) :=
  {i : I.Item // (cls i).role = r}

theorem roleItem_label_count (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (r : Role)
    (roleLabel : RoleItem cls r → Fin n)
    (hspec : ∀ i, label i.val = some (roleLabel i)) (v : Fin n) :
    ((Finset.univ.filter fun i => roleLabel i = v).card : ℤ) =
      labelledRoleCount cls label r v := by
  classical
  have himage : (Finset.univ.filter fun i => roleLabel i = v).image Subtype.val =
      Finset.univ.filter (fun i => (cls i).role = r ∧ label i = some v) := by
    ext i
    constructor
    · intro hi
      obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hi
      have hv := (Finset.mem_filter.mp ha).2
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, a.property,
        (hspec a).trans (congrArg some hv)⟩
    · intro hi
      obtain ⟨hr, hv⟩ := (Finset.mem_filter.mp hi).2
      let a : RoleItem cls r := ⟨i, hr⟩
      have ha : roleLabel a = v := Option.some.inj ((hspec a).symm.trans hv)
      exact Finset.mem_image.mpr ⟨a, Finset.mem_filter.mpr ⟨Finset.mem_univ _, ha⟩, rfl⟩
  have hcard : (Finset.univ.filter fun i => roleLabel i = v).card =
      (Finset.univ.filter fun i => (cls i).role = r ∧ label i = some v).card := by
    rw [← himage, Finset.card_image_of_injective _ Subtype.val_injective]
  rw [hcard]
  simp [labelledRoleCount]

structure RoleLabelData (cls : I.Item → Subclass) (label : I.Item → Option (Fin n)) where
  row : RoleItem cls .x → Fin n
  anchor : RoleItem cls .anchor → Fin n
  localLabel : RoleItem cls .«local» → Fin n
  row_spec : ∀ i, label i.val = some (row i)
  anchor_spec : ∀ i, label i.val = some (anchor i)
  local_spec : ∀ i, label i.val = some (localLabel i)
  global_spec : ∀ i : RoleItem cls .«global», label i.val = none
  flag_spec : ∀ i : RoleItem cls .flag, label i.val = none

namespace RoleLabelData

theorem row_count {cls : I.Item → Subclass} {label : I.Item → Option (Fin n)}
    (L : RoleLabelData cls label) (v : Fin n) :
    ((Finset.univ.filter fun i => L.row i = v).card : ℤ) =
      labelledRoleCount cls label .x v :=
  roleItem_label_count cls label .x L.row L.row_spec v

theorem anchor_count {cls : I.Item → Subclass} {label : I.Item → Option (Fin n)}
    (L : RoleLabelData cls label) (v : Fin n) :
    ((Finset.univ.filter fun i => L.anchor i = v).card : ℤ) =
      labelledRoleCount cls label .anchor v :=
  roleItem_label_count cls label .anchor L.anchor L.anchor_spec v

theorem local_count {cls : I.Item → Subclass} {label : I.Item → Option (Fin n)}
    (L : RoleLabelData cls label) (v : Fin n) :
    ((Finset.univ.filter fun i => L.localLabel i = v).card : ℤ) =
      labelledRoleCount cls label .«local» v :=
  roleItem_label_count cls label .«local» L.localLabel L.local_spec v

def of_valid (cls : I.Item → Subclass) (label : I.Item → Option (Fin n))
    (hlabeled : ∀ i, (cls i).role = .x ∨ (cls i).role = .anchor ∨
      (cls i).role = .«local» → ∃ v, label i = some v)
    (hunlabeled : ∀ i, (cls i).role = .«global» ∨ (cls i).role = .flag →
      label i = none) : RoleLabelData cls label where
  row i := Classical.choose (hlabeled i.val (Or.inl i.property))
  anchor i := Classical.choose (hlabeled i.val (Or.inr (Or.inl i.property)))
  localLabel i := Classical.choose (hlabeled i.val (Or.inr (Or.inr i.property)))
  row_spec i := Classical.choose_spec (hlabeled i.val (Or.inl i.property))
  anchor_spec i := Classical.choose_spec (hlabeled i.val (Or.inr (Or.inl i.property)))
  local_spec i := Classical.choose_spec (hlabeled i.val (Or.inr (Or.inr i.property)))
  global_spec i := hunlabeled i.val (Or.inl i.property)
  flag_spec i := hunlabeled i.val (Or.inr i.property)

end RoleLabelData

namespace Packing

def roleItemAt (p : Packing I b) (cls : I.Item → Subclass) (r : Role)
    (t : p.TableBin cls) : RoleItem cls r :=
  ⟨p.itemAtRole cls t r, p.itemAtRole_role cls t r⟩

theorem roleItemAt_injective (p : Packing I b) (cls : I.Item → Subclass) (r : Role) :
    Function.Injective (p.roleItemAt cls r) := by
  intro t u h
  exact p.itemAtRole_injective cls r (congrArg Subtype.val h)

theorem roleItemAt_labels (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label)
    (t : p.TableBin cls) (r : Role) :
    label (p.itemAtRole cls t r) = tableRoleLabel
      (L.row (p.roleItemAt cls .x t))
      (L.localLabel (p.roleItemAt cls .«local» t))
      (L.anchor (p.roleItemAt cls .anchor t)) r := by
  cases r with
  | x => exact L.row_spec (p.roleItemAt cls .x t)
  | anchor => exact L.anchor_spec (p.roleItemAt cls .anchor t)
  | «global» => exact L.global_spec (p.roleItemAt cls .«global» t)
  | «local» => exact L.local_spec (p.roleItemAt cls .«local» t)
  | flag => exact L.flag_spec (p.roleItemAt cls .flag t)

theorem roleItemAt_labels_le (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label)
    (coordinate : I.Item → ℚ)
    (hsize : ∀ i, I.size i = encodedSize (cls i) (label i) (coordinate i))
    (hw : ∀ i, |coordinate i| ≤ 6) (t : p.TableBin cls) :
    L.row (p.roleItemAt cls .x t) ≤ L.anchor (p.roleItemAt cls .anchor t) ∧
      L.localLabel (p.roleItemAt cls .«local» t) ≤ L.anchor (p.roleItemAt cls .anchor t) :=
  p.table_labels_le_anchor cls label coordinate hsize hw t _ _ _
    (p.roleItemAt_labels cls label L t)

theorem outside_roleItems_image_subset (p : Packing I b) (cls : I.Item → Subclass)
    (r : Role) :
    (LabelConservation.outsideItems (p.roleItemAt cls r)).image Subtype.val ⊆
      p.outsideTableItems cls := by
  classical
  intro i hi
  obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hi
  apply Finset.mem_filter.mpr
  refine ⟨Finset.mem_univ _, ?_⟩
  intro ht
  have haout := (Finset.mem_sdiff.mp ha).2
  apply haout
  let t : p.TableBin cls := ⟨p.assignment a.val, ht⟩
  refine Finset.mem_image.mpr ⟨t, Finset.mem_univ _, ?_⟩
  apply Subtype.ext
  exact p.itemAtRole_eq_of_mem cls t r a.val (p.mem_own_bin a.val) a.property

theorem outside_roleItems_card_le (p : Packing I b) (cls : I.Item → Subclass) (r : Role) :
    (LabelConservation.outsideItems (p.roleItemAt cls r)).card ≤
      (p.outsideTableItems cls).card := by
  classical
  rw [← Finset.card_image_of_injective
    (LabelConservation.outsideItems (p.roleItemAt cls r)) Subtype.val_injective]
  exact Finset.card_le_card (p.outside_roleItems_image_subset cls r)

end Packing

namespace Coverage

theorem goodTuplesAt_iff_roleLabels (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label)
    (v : Fin n) (t : p.TableBin cls) :
    t ∈ goodTuplesAt p cls label v ↔
      L.anchor (p.roleItemAt cls .anchor t) = v ∧
        L.row (p.roleItemAt cls .x t) = v ∧
          L.localLabel (p.roleItemAt cls .«local» t) = v := by
  rw [mem_goodTuplesAt]
  have hx := L.row_spec (p.roleItemAt cls .x t)
  have ha := L.anchor_spec (p.roleItemAt cls .anchor t)
  have hd := L.local_spec (p.roleItemAt cls .«local» t)
  change label (p.itemAtRole cls t .x) = some _ at hx
  change label (p.itemAtRole cls t .anchor) = some _ at ha
  change label (p.itemAtRole cls t .«local») = some _ at hd
  simp only [Packing.IsGoodTableBin, hx, ha, hd, Option.some.injEq]
  constructor
  · rintro ⟨⟨hr, hl⟩, hv⟩
    exact ⟨hv, hr.trans hv, hl.trans hv⟩
  · rintro ⟨hv, hr, hl⟩
    exact ⟨⟨hr.trans hv.symm, hl.trans hv.symm⟩, hv⟩

def badRoleAnchors (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label) (v : Fin n) :
    Finset (RoleItem cls .anchor) := by
  classical
  exact LabelConservation.badAnchors L.anchor L.row L.localLabel
    (p.roleItemAt cls .anchor) (p.roleItemAt cls .x) (p.roleItemAt cls .«local») v

theorem mem_badRoleAnchors (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label)
    (v : Fin n) (a : RoleItem cls .anchor) :
    a ∈ badRoleAnchors p cls label L v ↔ L.anchor a = v ∧
      ¬ ∃ t, p.roleItemAt cls .anchor t = a ∧
        L.row (p.roleItemAt cls .x t) = v ∧
          L.localLabel (p.roleItemAt cls .«local» t) = v := by
  classical
  exact LabelConservation.mem_badAnchors_iff L.anchor L.row L.localLabel
    (p.roleItemAt cls .anchor) (p.roleItemAt cls .x) (p.roleItemAt cls .«local»)
    (p.roleItemAt_injective cls .anchor) v a

theorem badRoleAnchors_image_eq (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label) (v : Fin n) :
    (badRoleAnchors p cls label L v).image Subtype.val = badAnchorsAt p cls label v := by
  classical
  ext i
  constructor
  · intro hi
    obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hi
    obtain ⟨hv, hnot⟩ := (mem_badRoleAnchors p cls label L v a).mp ha
    apply (mem_badAnchorsAt p cls label v a.val).mpr
    refine ⟨(mem_anchorItemsAt cls label v a.val).mpr ⟨a.property, ?_⟩, ?_⟩
    · rw [L.anchor_spec, hv]
    · intro hgood
      obtain ⟨t, ht, hat⟩ := Finset.mem_image.mp hgood
      obtain ⟨_, hr, hd⟩ := (goodTuplesAt_iff_roleLabels p cls label L v t).mp ht
      exact hnot ⟨t, Subtype.ext hat, hr, hd⟩
  · intro hi
    obtain ⟨hiA, hiBad⟩ := (mem_badAnchorsAt p cls label v i).mp hi
    obtain ⟨hr, hv⟩ := (mem_anchorItemsAt cls label v i).mp hiA
    let a : RoleItem cls .anchor := ⟨i, hr⟩
    have hva : L.anchor a = v := Option.some.inj ((L.anchor_spec a).symm.trans hv)
    refine Finset.mem_image.mpr ⟨a, ?_, rfl⟩
    apply (mem_badRoleAnchors p cls label L v a).mpr
    refine ⟨hva, ?_⟩
    rintro ⟨t, hat, hrow, hlocal⟩
    apply hiBad
    refine Finset.mem_image.mpr ⟨t, ?_, congrArg Subtype.val hat⟩
    apply (goodTuplesAt_iff_roleLabels p cls label L v t).mpr
    exact ⟨by simpa only [hat] using hva, hrow, hlocal⟩

@[simp] theorem badRoleAnchors_card (p : Packing I b) (cls : I.Item → Subclass)
    (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label) (v : Fin n) :
    (badRoleAnchors p cls label L v).card = (badAnchorsAt p cls label v).card := by
  classical
  rw [← badRoleAnchors_image_eq p cls label L v,
    Finset.card_image_of_injective _ Subtype.val_injective]

variable (p : Packing I b) (cls : I.Item → Subclass)
variable (label : I.Item → Option (Fin n)) (L : RoleLabelData cls label)
variable (coordinate : I.Item → ℚ)
variable (hsize : ∀ i, I.size i = encodedSize (cls i) (label i) (coordinate i))
variable (hw : ∀ i, |coordinate i| ≤ 6) (B c : ℕ)
variable (hcard : I.n = 5 * B) (hb : b ≤ B + c)
variable (htotal : (∑ i, primaryScore (cls i)) = 0)
variable (hInvR : ∀ v, (Finset.univ.filter fun a => L.anchor a = v).card =
  (Finset.univ.filter fun r => L.row r = v).card)
variable (hInvD : ∀ v, (Finset.univ.filter fun a => L.anchor a = v).card =
  (Finset.univ.filter fun d => L.localLabel d = v).card)

include L coordinate hsize hw B hcard hb htotal hInvR hInvD

theorem badAnchorsAt_card_le (v : Fin n) :
    (badAnchorsAt p cls label v).card ≤
      3 * (25 * (c + 1) * (1 + 5 * primaryBound)) := by
  classical
  have hOutside := (p.outside_roleItems_card_le cls .anchor).trans
    (p.outsideTableItems_card_lt cls label coordinate hsize hw B c hcard hb htotal).le
  have hleR (t : p.TableBin cls) :
      (L.row (p.roleItemAt cls .x t)).val ≤
        (L.anchor (p.roleItemAt cls .anchor t)).val :=
    (p.roleItemAt_labels_le cls label L coordinate hsize hw t).1
  have hleD (t : p.TableBin cls) :
      (L.localLabel (p.roleItemAt cls .«local» t)).val ≤
        (L.anchor (p.roleItemAt cls .anchor t)).val :=
    (p.roleItemAt_labels_le cls label L coordinate hsize hw t).2
  have h := LabelConservation.badAnchors_card_le_three_mul L.anchor L.row L.localLabel
    (p.roleItemAt cls .anchor) (p.roleItemAt cls .x) (p.roleItemAt cls .«local»)
    (p.roleItemAt_injective cls .anchor) (p.roleItemAt_injective cls .x)
    (p.roleItemAt_injective cls .«local») hleR hleD hInvR hInvD
    (25 * (c + 1) * (1 + 5 * primaryBound)) hOutside v
  change (badRoleAnchors p cls label L v).card ≤ _ at h
  simpa only [badRoleAnchors_card] using h

theorem badAnchorsAt_subset_card_le (v : Fin n) (s : Finset I.Item)
    (hs : s ⊆ badAnchorsAt p cls label v) :
    s.card ≤ 3 * (25 * (c + 1) * (1 + 5 * primaryBound)) :=
  (Finset.card_le_card hs).trans
    (badAnchorsAt_card_le p cls label L coordinate hsize hw B c hcard hb htotal hInvR hInvD v)

theorem anchor_subset_loss_le (v : Fin n) (s : Finset I.Item)
    (hs : s ⊆ anchorItemsAt (I := I) cls label v) :
    (s \ roleItems p cls (goodTuplesAt p cls label v) .anchor).card ≤
      3 * (25 * (c + 1) * (1 + 5 * primaryBound)) := by
  apply badAnchorsAt_subset_card_le p cls label L coordinate hsize hw B c
    hcard hb htotal hInvR hInvD v
  intro i hi
  obtain ⟨his, hin⟩ := Finset.mem_sdiff.mp hi
  exact Finset.mem_sdiff.mpr ⟨hs his, hin⟩

theorem badAnchors_global_card_le :
    ((Finset.univ : Finset (Fin n)).biUnion (badAnchorsAt p cls label)).card ≤
      3 * n * (25 * (c + 1) * (1 + 5 * primaryBound)) := by
  classical
  calc
    _ ≤ ∑ v : Fin n, (badAnchorsAt p cls label v).card := Finset.card_biUnion_le
    _ ≤ ∑ _v : Fin n, 3 * (25 * (c + 1) * (1 + 5 * primaryBound)) := by
      apply Finset.sum_le_sum
      intro v _
      exact badAnchorsAt_card_le p cls label L coordinate hsize hw B c
        hcard hb htotal hInvR hInvD v
    _ = _ := by simp [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc]

end Coverage
end BinPackingGap

end

end OAI
end LocalizedSource13
/- END LOCALIZED SOURCE 13/44: OAI/Computability/BinPacking/Packing/GoodAnchorBound.lean -/

/- BEGIN LOCALIZED SOURCE 14/44: OAI/Computability/BinPacking/Packing/PackingSelections.lean
   SHA256: 6f660aadcb29791f60cae53b6e4b439d2ffcc109b3551fc49a95fee9738d425a -/
section LocalizedSource14
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Basic
-- localized import: OAI.Computability.BinPacking.Inventory.CurrentMatches
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryScores

namespace OAI

noncomputable section

section
open scoped BigOperators

namespace BinPackingGap
namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

def subclass (e : D.Item ≃ I.Item) : I.Item → Subclass :=
  D.itemSubclass ∘ e.symm

def label (e : D.Item ≃ I.Item) : I.Item → Option D.Vertex :=
  D.itemLabel ∘ e.symm

def globalResources (e : D.Item ≃ I.Item) (s : GlobalSpecies D.graph) :
    Finset I.Item := by
  classical
  exact Finset.univ.image fun i : Fin (D.globalStock s) => e ⟨.«global», ⟨s, i⟩⟩

theorem globalCopy_injective (e : D.Item ≃ I.Item) (s : GlobalSpecies D.graph) :
    Function.Injective (fun i : Fin (D.globalStock s) => e ⟨.«global», ⟨s, i⟩⟩) := by
  intro i j hij
  have h := e.injective hij
  have hg := @sigma_mk_injective Role D.RoleCopies .«global» _ _ h
  exact @sigma_mk_injective (GlobalSpecies D.graph)
    (fun s => Fin (D.globalStock s)) s i j hg

@[simp] theorem globalResources_card (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) :
    (globalResources e s).card = D.globalStock s := by
  classical
  simp only [globalResources, Finset.card_image_of_injective _ (globalCopy_injective e s),
    Finset.card_univ, Fintype.card_fin]

@[simp] theorem mem_globalResources (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) (x : I.Item) :
    x ∈ globalResources e s ↔
      ∃ i : Fin (D.globalStock s), e ⟨.«global», ⟨s, i⟩⟩ = x := by
  classical
  simp [globalResources]

theorem globalResources_disjoint (e : D.Item ≃ I.Item)
    {s t : GlobalSpecies D.graph} (hst : s ≠ t) :
    Disjoint (globalResources e s) (globalResources e t) := by
  classical
  apply Finset.disjoint_left.mpr
  intro x hx hy
  obtain ⟨i, hi⟩ := (mem_globalResources e s x).mp hx
  obtain ⟨j, hj⟩ := (mem_globalResources e t x).mp hy
  have h := e.injective (hi.trans hj.symm)
  have hg : (⟨s, i⟩ : D.GlobalCopy) = ⟨t, j⟩ := by
    exact @sigma_mk_injective Role D.RoleCopies .«global» _ _ h
  exact hst (congrArg Sigma.fst hg)

def fundedTuples (p : Packing I b) (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) (v : D.Vertex) : Finset (p.TableBin (subclass e)) := by
  classical
  exact (Coverage.mainTuplesAt p (subclass e) (label e) v).filter fun t =>
    p.itemAtRole (subclass e) t .«global» ∈ globalResources e s

@[simp] theorem mem_fundedTuples (p : Packing I b) (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) (v : D.Vertex) (t : p.TableBin (subclass e)) :
    t ∈ fundedTuples p e s v ↔
      t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v ∧
      p.itemAtRole (subclass e) t .«global» ∈ globalResources e s := by
  classical
  simp [fundedTuples]

theorem fundedTuples_subset_main (p : Packing I b) (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) (v : D.Vertex) :
    fundedTuples p e s v ⊆ Coverage.mainTuplesAt p (subclass e) (label e) v := by
  classical
  exact Finset.filter_subset _ _

theorem fundedTuples_disjoint_label (p : Packing I b) (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) {v w : D.Vertex} (hvw : v ≠ w) :
    Disjoint (fundedTuples p e s v) (fundedTuples p e s w) :=
  (Coverage.mainTuplesAt_disjoint_label p (subclass e) (label e) hvw).mono
    (fundedTuples_subset_main p e s v) (fundedTuples_subset_main p e s w)

theorem sum_card_main_subsets_le_resources (p : Packing I b) (e : D.Item ≃ I.Item)
    (S : D.Vertex → Finset (p.TableBin (subclass e)))
    (hS : ∀ v, S v ⊆ Coverage.mainTuplesAt p (subclass e) (label e) v)
    (r : Role) (resources : Finset I.Item)
    (hres : ∀ v t, t ∈ S v → p.itemAtRole (subclass e) t r ∈ resources) :
    (∑ v, (S v).card) ≤ resources.card := by
  classical
  have hdis : ∀ v ∈ (Finset.univ : Finset D.Vertex),
      ∀ w ∈ (Finset.univ : Finset D.Vertex), v ≠ w → Disjoint (S v) (S w) := by
    intro v _ w _ hvw
    exact (Coverage.mainTuplesAt_disjoint_label p (subclass e) (label e) hvw).mono
      (hS v) (hS w)
  calc
    (∑ v, (S v).card) = (Finset.univ.biUnion S).card :=
      (Finset.card_biUnion hdis).symm
    _ ≤ resources.card := by
      apply Coverage.card_le_role_resources p (subclass e) _ r resources
      intro t ht
      obtain ⟨v, _, htv⟩ := Finset.mem_biUnion.mp ht
      exact hres v t htv

theorem fundedTuples_sum_card_le (p : Packing I b) (e : D.Item ≃ I.Item)
    (s : GlobalSpecies D.graph) :
    (∑ v, (fundedTuples p e s v).card) ≤ D.globalStock s := by
  rw [← globalResources_card e s]
  apply sum_card_main_subsets_le_resources p e (fundedTuples p e s)
    (fundedTuples_subset_main p e s) .«global» (globalResources e s)
  intro v t ht
  exact ((mem_fundedTuples p e s v t).mp ht).2

def xplus (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) : ℕ :=
  (fundedTuples p e (.up true) v).card

def xminus (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) : ℕ :=
  (fundedTuples p e (.um true) v).card

theorem xplus_budget (p : Packing I b) (e : D.Item ≃ I.Item) :
    (∑ v, xplus p e v) ≤ D.d * D.k :=
  fundedTuples_sum_card_le p e (.up true)

theorem xminus_budget (p : Packing I b) (e : D.Item ≃ I.Item) :
    (∑ v, xminus p e v) ≤ D.d * (D.graph.n - D.k) :=
  fundedTuples_sum_card_le p e (.um true)

theorem total_budget (p : Packing I b) (e : D.Item ≃ I.Item) (hk : D.k ≤ D.graph.n) :
    (∑ v, (xplus p e v + xminus p e v)) ≤ D.d * D.graph.n := by
  rw [Finset.sum_add_distrib]
  calc
    _ ≤ D.d * D.k + D.d * (D.graph.n - D.k) :=
      Nat.add_le_add (xplus_budget p e) (xminus_budget p e)
    _ = D.d * D.graph.n := by
      have hsum : D.k + (D.graph.n - D.k) = D.graph.n := by omega
      rw [← Nat.mul_add, hsum]

def localDepthResources (e : D.Item ≃ I.Item) (v : D.Vertex) (ell : D.Depth) :
    Finset I.Item := by
  classical
  exact Finset.univ.image fun i : Fin (D.quota ell.val) =>
    e ⟨.«local», ⟨v, Sum.inl (Sum.inl ⟨ell, i⟩)⟩⟩

theorem localDepthCopy_injective (e : D.Item ≃ I.Item) (v : D.Vertex) (ell : D.Depth) :
    Function.Injective (fun i : Fin (D.quota ell.val) =>
      e ⟨.«local», ⟨v, Sum.inl (Sum.inl ⟨ell, i⟩)⟩⟩) := by
  intro i j hij
  have h := e.injective hij
  have hl := @sigma_mk_injective Role D.RoleCopies .«local» _ _ h
  have hv := @sigma_mk_injective D.Vertex D.LocalAt v _ _ hl
  have hp : (⟨ell, i⟩ : D.PositiveLocal) = ⟨ell, j⟩ :=
    Sum.inl.inj (Sum.inl.inj hv)
  exact @sigma_mk_injective D.Depth (fun ell => Fin (D.quota ell.val)) ell i j hp

@[simp] theorem localDepthResources_card (e : D.Item ≃ I.Item)
    (v : D.Vertex) (ell : D.Depth) :
    (localDepthResources e v ell).card = D.quota ell.val := by
  classical
  simp only [localDepthResources,
    Finset.card_image_of_injective _ (localDepthCopy_injective e v ell),
    Finset.card_univ, Fintype.card_fin]

theorem card_le_localDepth_stock (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (ell : D.Depth) (S : Finset (p.TableBin (subclass e)))
    (hres : ∀ t ∈ S,
      p.itemAtRole (subclass e) t .«local» ∈ localDepthResources e v ell) :
    S.card ≤ D.quota ell.val := by
  rw [← localDepthResources_card e v ell]
  exact Coverage.card_le_role_resources p (subclass e) S .«local» _ hres

def positiveLocalResources (e : D.Item ≃ I.Item) (v : D.Vertex) : Finset I.Item := by
  classical
  exact Finset.univ.image fun i : D.PositiveLocal =>
    e ⟨.«local», ⟨v, Sum.inl (Sum.inl i)⟩⟩

@[simp] theorem mem_positiveLocalResources (e : D.Item ≃ I.Item)
    (v : D.Vertex) (x : I.Item) :
    x ∈ positiveLocalResources e v ↔
      ∃ i : D.PositiveLocal, e ⟨.«local», ⟨v, Sum.inl (Sum.inl i)⟩⟩ = x := by
  classical
  simp [positiveLocalResources]

theorem positiveLocalCopy_injective (e : D.Item ≃ I.Item) (v : D.Vertex) :
    Function.Injective (fun i : D.PositiveLocal =>
      e ⟨.«local», ⟨v, Sum.inl (Sum.inl i)⟩⟩) := by
  intro i j hij
  have h := e.injective hij
  have hl := @sigma_mk_injective Role D.RoleCopies .«local» _ _ h
  have hv := @sigma_mk_injective D.Vertex D.LocalAt v _ _ hl
  exact Sum.inl.inj (Sum.inl.inj hv)

@[simp] theorem positiveLocalResources_card (e : D.Item ≃ I.Item) (v : D.Vertex) :
    (positiveLocalResources e v).card = D.P := by
  classical
  rw [positiveLocalResources,
    Finset.card_image_of_injective _ (positiveLocalCopy_injective e v),
    Finset.card_univ, D.card_positiveLocal]

theorem card_le_positiveLocal_stock (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (S : Finset (p.TableBin (subclass e)))
    (hres : ∀ t ∈ S,
      p.itemAtRole (subclass e) t .«local» ∈ positiveLocalResources e v) :
    S.card ≤ D.P := by
  rw [← positiveLocalResources_card e v]
  exact Coverage.card_le_role_resources p (subclass e) S .«local» _ hres

end PackingCounts
end BinPackingGap

end

namespace BinPackingGap
namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

private def elementAtRole (i : D.Item) (r : Role) (h : i.1 = r) : D.RoleCopies r :=
  h ▸ i.2

private theorem elementAtRole_mk (i : D.Item) (r : Role) (h : i.1 = r) :
    (⟨r, elementAtRole i r h⟩ : D.Item) = i := by
  rcases i with ⟨s, i⟩
  dsimp at h
  cases h
  rfl

theorem selected_role (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : Role) :
    (e.symm (p.itemAtRole (subclass e) t r)).1 = r := by
  change D.itemRole (e.symm (p.itemAtRole (subclass e) t r)) = r
  rw [← D.itemSubclass_role]
  exact p.itemAtRole_role (subclass e) t r

def roleCopy (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : Role) : D.RoleCopies r :=
  elementAtRole (e.symm (p.itemAtRole (subclass e) t r)) r (selected_role p e t r)

@[simp] theorem roleCopy_item (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : Role) :
    e ⟨r, roleCopy p e t r⟩ = p.itemAtRole (subclass e) t r := by
  rw [roleCopy, elementAtRole_mk, e.apply_symm_apply]

theorem roleCopy_injective (p : Packing I b) (e : D.Item ≃ I.Item) (r : Role) :
    Function.Injective (fun t => roleCopy p e t r) := by
  intro t u h
  change roleCopy p e t r = roleCopy p e u r at h
  apply p.itemAtRole_injective (subclass e) r
  change p.itemAtRole (subclass e) t r = p.itemAtRole (subclass e) u r
  rw [← roleCopy_item p e t r, ← roleCopy_item p e u r, h]

theorem roleCopy_subclass (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : Role) :
    D.itemSubclass ⟨r, roleCopy p e t r⟩ = patternSubclass (p.tablePattern (subclass e) t) r := by
  have h := p.itemAtRole_subclass (subclass e) t r
  rw [← roleCopy_item p e t r] at h
  simpa only [subclass, Function.comp_apply, e.symm_apply_apply] using h

abbrev rowCopy (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : Σ v : D.Vertex, D.RowAt v :=
  roleCopy p e t .x

abbrev anchorCopy (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : Σ v : D.Vertex, D.AnchorAt v :=
  roleCopy p e t .anchor

abbrev globalCopy (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : D.GlobalCopy :=
  roleCopy p e t .«global»

abbrev localCopy (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : Σ v : D.Vertex, D.LocalAt v :=
  roleCopy p e t .«local»

theorem selected_global_resource_iff (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (s : GlobalSpecies D.graph) :
    p.itemAtRole (subclass e) t .«global» ∈ globalResources e s ↔
      (globalCopy p e t).1 = s := by
  constructor
  · intro h
    obtain ⟨i, hi⟩ := (mem_globalResources e s _).mp h
    rw [← roleCopy_item p e t .«global»] at hi
    have he := e.injective hi
    have hg : (⟨s, i⟩ : D.GlobalCopy) = globalCopy p e t := by
      exact @sigma_mk_injective Role D.RoleCopies .«global» _ _ he
    exact (congrArg Sigma.fst hg).symm
  · intro h
    rcases hg : globalCopy p e t with ⟨s', i⟩
    have hs : s' = s := by simpa only [hg] using h
    subst s'
    apply (mem_globalResources e s _).mpr
    refine ⟨i, ?_⟩
    rw [← roleCopy_item p e t .«global»]
    exact congrArg (fun x : D.GlobalCopy => e ⟨.«global», x⟩) hg.symm

@[simp] theorem selected_row_label (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) :
    label e (p.itemAtRole (subclass e) t .x) = some (rowCopy p e t).1 := by
  change D.itemLabel (e.symm (p.itemAtRole (subclass e) t .x)) =
    some (rowCopy p e t).1
  rw [← roleCopy_item p e t .x, e.symm_apply_apply]
  rfl

@[simp] theorem selected_anchor_label (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) :
    label e (p.itemAtRole (subclass e) t .anchor) = some (anchorCopy p e t).1 := by
  change D.itemLabel (e.symm (p.itemAtRole (subclass e) t .anchor)) =
    some (anchorCopy p e t).1
  rw [← roleCopy_item p e t .anchor, e.symm_apply_apply]
  rfl

@[simp] theorem selected_local_label (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) :
    label e (p.itemAtRole (subclass e) t .«local») = some (localCopy p e t).1 := by
  change D.itemLabel (e.symm (p.itemAtRole (subclass e) t .«local»)) =
    some (localCopy p e t).1
  rw [← roleCopy_item p e t .«local», e.symm_apply_apply]
  rfl

theorem good_row_vertex (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v) :
    (rowCopy p e t).1 = v := by
  have ht' := (Coverage.mem_goodTuplesAt p (subclass e) (label e) v t).mp ht
  have h := ht'.1.1.trans ht'.2
  rw [selected_row_label] at h
  exact Option.some.inj h

theorem good_anchor_vertex (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v) :
    (anchorCopy p e t).1 = v := by
  have h := ((Coverage.mem_goodTuplesAt p (subclass e) (label e) v t).mp ht).2
  rw [selected_anchor_label] at h
  exact Option.some.inj h

theorem good_local_vertex (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v) :
    (localCopy p e t).1 = v := by
  have ht' := (Coverage.mem_goodTuplesAt p (subclass e) (label e) v t).mp ht
  have h := ht'.1.2.trans ht'.2
  rw [selected_local_label] at h
  exact Option.some.inj h

def zeroPositiveTuples (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) :
    Finset (p.TableBin (subclass e)) := by
  classical
  exact (Coverage.mainTuplesAt p (subclass e) (label e) v).filter fun t =>
    D.globalUnit (globalCopy p e t) = false ∧
      p.itemAtRole (subclass e) t .«local» ∈ positiveLocalResources e v

def tupleLocalDepth (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : ℕ :=
  ((D.localDepth (localCopy p e t).2).map Subtype.val).getD 0

@[simp] theorem mem_zeroPositiveTuples (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e)) :
    t ∈ zeroPositiveTuples p e v ↔
      t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v ∧
        D.globalUnit (globalCopy p e t) = false ∧
          p.itemAtRole (subclass e) t .«local» ∈ positiveLocalResources e v := by
  classical
  simp [zeroPositiveTuples, and_assoc]

theorem zeroPositiveTuples_card_le (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) : (zeroPositiveTuples p e v).card ≤ D.P := by
  apply card_le_positiveLocal_stock p e v
  intro t ht
  exact ((mem_zeroPositiveTuples p e v t).mp ht).2.2

theorem localCopy_eq_of_positive (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (hpos : p.itemAtRole (subclass e) t .«local» ∈ positiveLocalResources e v) :
    ∃ i : D.PositiveLocal, localCopy p e t = ⟨v, Sum.inl (Sum.inl i)⟩ := by
  obtain ⟨i, hi⟩ := (mem_positiveLocalResources e v _).mp hpos
  refine ⟨i, ?_⟩
  rw [← roleCopy_item p e t .«local»] at hi
  have h := e.injective hi
  have h' : (⟨v, Sum.inl (Sum.inl i)⟩ : Σ w : D.Vertex, D.LocalAt w) =
      localCopy p e t := by
    exact @sigma_mk_injective Role D.RoleCopies .«local» _ _ h
  exact h'.symm

theorem selected_depth_mem (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ zeroPositiveTuples p e v) :
    tupleLocalDepth p e t ∈ Finset.Icc 1 D.L := by
  obtain ⟨i, hi⟩ := localCopy_eq_of_positive p e v t
    (((mem_zeroPositiveTuples p e v t).mp ht).2.2)
  have hd : tupleLocalDepth p e t = i.1.val := by
    unfold tupleLocalDepth
    rw [hi]
    rfl
  rw [hd]
  exact i.1.property

theorem selected_localDepth_resource (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (ell : D.Depth) (t : p.TableBin (subclass e))
    (ht : t ∈ zeroPositiveTuples p e v) (hell : tupleLocalDepth p e t = ell.val) :
    p.itemAtRole (subclass e) t .«local» ∈ localDepthResources e v ell := by
  classical
  obtain ⟨⟨depth, i⟩, hi⟩ := localCopy_eq_of_positive p e v t
    (((mem_zeroPositiveTuples p e v t).mp ht).2.2)
  have hd : tupleLocalDepth p e t = depth.val := by
    unfold tupleLocalDepth
    rw [hi]
    rfl
  have hdepth : depth = ell := Subtype.ext (hd.symm.trans hell)
  subst depth
  apply Finset.mem_image.mpr
  refine ⟨i, Finset.mem_univ _, ?_⟩
  rw [← roleCopy_item p e t .«local»]
  exact congrArg (fun x : (Σ w : D.Vertex, D.LocalAt w) => e ⟨.«local», x⟩) hi.symm

theorem zeroPositiveTuples_depth_card_le (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (ell : D.Depth) :
    ((zeroPositiveTuples p e v).filter (fun t => tupleLocalDepth p e t = ell.val)).card ≤
      D.quota ell.val := by
  classical
  apply card_le_localDepth_stock p e v ell
  intro t ht
  obtain ⟨ht, he⟩ := Finset.mem_filter.mp ht
  exact selected_localDepth_resource p e v ell t ht he

end PackingCounts
end BinPackingGap

end

end OAI
end LocalizedSource14
/- END LOCALIZED SOURCE 14/44: OAI/Computability/BinPacking/Packing/PackingSelections.lean -/

/- BEGIN LOCALIZED SOURCE 15/44: OAI/Computability/BinPacking/Packing/CoordinateOrder.lean
   SHA256: 0ccba016b2fbd8b37bf20064f501186b78504d1b91f5de6dcdf312089cbdf35c -/
section LocalizedSource15
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.NormNum
-- localized import: Mathlib.Tactic.Positivity
-- localized import: Mathlib.Tactic.Ring
-- localized import: OAI.Computability.BinPacking.Trees.CompletionGeometry

namespace OAI

namespace BinPackingGap.Geometry

variable {m R : ℕ}

def posLT (r s : Position m R) : Prop :=
  r.1.val < s.1.val ∨ r.1 = s.1 ∧ r.2.val < s.2.val

def posLE (r s : Position m R) : Prop := r = s ∨ posLT r s

theorem posLT_irrefl (r : Position m R) : ¬ posLT r r := by
  simp [posLT]

theorem posLT_trans {r s t : Position m R}
    (hrs : posLT r s) (hst : posLT s t) : posLT r t := by
  simp only [posLT, Fin.ext_iff] at *
  omega

theorem posLT_asymm {r s : Position m R} (h : posLT r s) : ¬ posLT s r :=
  fun h' => posLT_irrefl r (posLT_trans h h')

theorem posLT_trichotomy (r s : Position m R) :
    posLT r s ∨ r = s ∨ posLT s r := by
  simp only [posLT, Prod.ext_iff, Fin.ext_iff]
  omega

theorem posLT_or_posLT_of_ne {r s : Position m R} (hne : r ≠ s) :
    posLT r s ∨ posLT s r := by
  rcases posLT_trichotomy r s with hrs | hrs | hsr
  · exact Or.inl hrs
  · exact (hne hrs).elim
  · exact Or.inr hsr

theorem posLE_iff_not_posLT {r s : Position m R} : posLE r s ↔ ¬ posLT s r := by
  simp only [posLE, posLT, Prod.ext_iff, Fin.ext_iff]
  omega

theorem posLE_refl (r : Position m R) : posLE r r := Or.inl rfl

theorem posLE_trans {r s t : Position m R}
    (hrs : posLE r s) (hst : posLE s t) : posLE r t := by
  rcases hrs with rfl | hrs
  · exact hst
  rcases hst with rfl | hst
  · exact Or.inr hrs
  exact Or.inr (posLT_trans hrs hst)

theorem heightCode_ge_theta (R : ℕ) (r : Position m R) :
    theta R r.1 ≤ heightCode R r := by
  have hj : (0 : ℚ) ≤ r.2.val := Nat.cast_nonneg _
  have hp : (0 : ℚ) ≤ ((R : ℚ) + 1) ^ r.1.val := pow_nonneg (by positivity) _
  unfold theta heightCode
  nlinarith

theorem heightCode_le_edgeMax (R : ℕ) (r : Position m R) :
    heightCode R r ≤ (R : ℚ) * ((R : ℚ) + 1) ^ r.1.val - 1 := by
  have hj : (r.2.val : ℚ) + 1 ≤ R := by
    exact_mod_cast Nat.succ_le_of_lt r.2.isLt
  have hp : (0 : ℚ) ≤ ((R : ℚ) + 1) ^ r.1.val := pow_nonneg (by positivity) _
  have hmul := mul_le_mul_of_nonneg_right hj hp
  unfold heightCode
  linarith

theorem heightCode_same_edge_sub (R : ℕ) (e : Fin m) (j k : Fin R) :
    heightCode R (e, k) - heightCode R (e, j) =
      ((k.val : ℚ) - j.val) * ((R : ℚ) + 1) ^ e.val := by
  unfold heightCode
  ring

theorem heightCode_next_rep_sub (R : ℕ) (e : Fin m) (j k : Fin R)
    (hnext : k.val = j.val + 1) :
    heightCode R (e, k) - heightCode R (e, j) = ((R : ℚ) + 1) ^ e.val := by
  rw [heightCode_same_edge_sub]
  have hk : (k.val : ℚ) = (j.val : ℚ) + 1 := by exact_mod_cast hnext
  rw [hk]
  ring

theorem heightCode_next_edge_sub (R : ℕ) (e f : Fin m) (j k : Fin R)
    (hnext : f.val = e.val + 1) (hlast : j.val + 1 = R) (hfirst : k.val = 0) :
    heightCode R (f, k) - heightCode R (e, j) = ((R : ℚ) + 1) ^ e.val := by
  have hj : (j.val : ℚ) + 1 = R := by exact_mod_cast hlast
  change ((k.val : ℚ) + 1) * ((R : ℚ) + 1) ^ f.val - 1 -
    (((j.val : ℚ) + 1) * ((R : ℚ) + 1) ^ e.val - 1) = _
  rw [hnext, hfirst, hj, pow_succ]
  ring

theorem theta_next_sub (R : ℕ) (e f : Fin m) (hnext : f.val = e.val + 1) :
    theta R f - theta R e = (R : ℚ) * ((R : ℚ) + 1) ^ e.val := by
  unfold theta
  rw [hnext, pow_succ]
  ring

theorem heightCode_jump {r s : Position m R} (h : posLT r s) :
    theta R r.1 + 1 ≤ heightCode R s - heightCode R r := by
  rcases h with he | ⟨he, hj⟩
  · have hp : ((R : ℚ) + 1) ^ (r.1.val + 1) ≤
        ((R : ℚ) + 1) ^ s.1.val :=
      pow_le_pow_right₀ (base_one_le R) (Nat.succ_le_of_lt he)
    rw [pow_succ] at hp
    have hlo := heightCode_ge_theta R s
    have hhi := heightCode_le_edgeMax R r
    unfold theta at hlo ⊢
    nlinarith
  · have hj' : (r.2.val : ℚ) + 1 ≤ s.2.val := by
      exact_mod_cast Nat.succ_le_of_lt hj
    have hp : (0 : ℚ) ≤ ((R : ℚ) + 1) ^ r.1.val := pow_nonneg (by positivity) _
    have hmul := mul_le_mul_of_nonneg_right hj' hp
    simp only [heightCode, theta, ← he]
    nlinarith

theorem theta_jump {e f : Fin m} (hef : e < f) :
    (R : ℚ) * ((R : ℚ) + 1) ^ e.val ≤ theta R f - theta R e := by
  have hp : ((R : ℚ) + 1) ^ (e.val + 1) ≤ ((R : ℚ) + 1) ^ f.val :=
    pow_le_pow_right₀ (base_one_le R) (Nat.succ_le_of_lt hef)
  rw [pow_succ] at hp
  unfold theta
  nlinarith

theorem theta_jump_ge_heightCode {r : Position m R} {f : Fin m} (hef : r.1 < f) :
    heightCode R r + 1 ≤ theta R f - theta R r.1 :=
  (by linarith [heightCode_le_edgeMax R r] :
    heightCode R r + 1 ≤ (R : ℚ) * ((R : ℚ) + 1) ^ r.1.val).trans (theta_jump hef)

theorem heightCode_strictMono {r s : Position m R} (h : posLT r s) :
    heightCode R r < heightCode R s := by
  have hjump := heightCode_jump h
  have hn := theta_nonneg R r.1
  linarith

theorem heightCode_lt_iff {r s : Position m R} :
    heightCode R r < heightCode R s ↔ posLT r s := by
  constructor
  · intro h
    rcases posLT_trichotomy r s with hrs | hrs | hsr
    · exact hrs
    · subst s
      exact (lt_irrefl _ h).elim
    · exact (not_lt_of_ge (heightCode_strictMono hsr).le h).elim
  · exact heightCode_strictMono

theorem baseline_gap_of_posLT {r s : Position m R} (h : posLT r s) :
    gap m R ≤ baseline m R s - baseline m R r := by
  have hjump := heightCode_jump h
  have ht := theta_nonneg R r.1
  have hheight : (1 : ℚ) ≤ heightCode R s - heightCode R r := by linarith
  have hmul := mul_le_mul_of_nonneg_left hheight (gap_pos m R).le
  unfold baseline
  nlinarith

theorem gap_le_abs_baseline_sub {r s : Position m R} (hne : r ≠ s) :
    gap m R ≤ |baseline m R s - baseline m R r| := by
  rcases posLT_or_posLT_of_ne hne with hrs | hsr
  · exact (baseline_gap_of_posLT hrs).trans (le_abs_self _)
  · rw [abs_sub_comm]
    exact (baseline_gap_of_posLT hsr).trans (le_abs_self _)

theorem baseline_lt_iff {r s : Position m R} :
    baseline m R r < baseline m R s ↔ posLT r s := by
  constructor
  · intro h
    rcases posLT_trichotomy r s with hrs | hrs | hsr
    · exact hrs
    · subst s
      exact (lt_irrefl _ h).elim
    · have hg := baseline_gap_of_posLT hsr
      have hp := gap_pos m R
      linarith
  · intro h
    have hg := baseline_gap_of_posLT h
    have hp := gap_pos m R
    linarith

theorem baseline_le_iff {r s : Position m R} :
    baseline m R r ≤ baseline m R s ↔ posLE r s := by
  rw [posLE_iff_not_posLT, ← baseline_lt_iff]
  constructor
  · intro hle hlt
    linarith
  · intro h
    by_contra h'
    apply h
    linarith

theorem baseline_eq_iff {r s : Position m R} :
    baseline m R r = baseline m R s ↔ r = s := by
  constructor
  · intro h
    rcases posLT_trichotomy r s with hrs | hrs | hsr
    · exact (ne_of_lt (baseline_lt_iff.mpr hrs) h).elim
    · exact hrs
    · exact (ne_of_lt (baseline_lt_iff.mpr hsr) h.symm).elim
  · rintro rfl
    rfl

theorem baseline_le_jobInterior_iff {Δ : ℚ} (hΔ : 0 < Δ)
    (hΔg : Δ < gap m R) {r s : Position m R} :
    baseline m R s ≤ baseline m R r - Δ / 2 ↔ posLT s r := by
  constructor
  · intro hs
    apply baseline_lt_iff.mp
    linarith
  · intro hsr
    have hgap := baseline_gap_of_posLT hsr
    linarith

theorem jobInterior_lt_baseline_iff {Δ : ℚ} (hΔ : 0 < Δ)
    (hΔg : Δ < gap m R) {r s : Position m R} :
    baseline m R r - Δ / 2 < baseline m R s ↔ posLE r s := by
  rw [posLE_iff_not_posLT, ← baseline_le_jobInterior_iff hΔ hΔg]
  exact lt_iff_not_ge

theorem jobInterior_mem_current {Δ : ℚ} (hΔ : 0 < Δ) (r : Position m R) :
    baseline m R r - Δ ≤ baseline m R r - Δ / 2 ∧
      baseline m R r - Δ / 2 < baseline m R r := by
  constructor <;> linarith

theorem jobInterior_mem_job_iff {Δ : ℚ} (hΔ : 0 < Δ)
    (hΔg : Δ < gap m R) {r s : Position m R} :
    (baseline m R s - Δ ≤ baseline m R r - Δ / 2 ∧
      baseline m R r - Δ / 2 < baseline m R s) ↔ s = r := by
  constructor
  · rintro ⟨hleft, hright⟩
    rcases posLT_trichotomy s r with hsr | hsr | hrs
    · have hp := (baseline_le_jobInterior_iff hΔ hΔg).mpr hsr
      linarith
    · exact hsr
    · have hgap := baseline_gap_of_posLT hrs
      linarith
  · intro hsr
    subst s
    exact jobInterior_mem_current hΔ r

theorem baseline_le_actualJobInterior_iff (D L : ℕ) {r s : Position m R} :
    baseline m R s ≤ baseline m R r - delta m R D L / 2 ↔ posLT s r :=
  baseline_le_jobInterior_iff (delta_pos m R D L) (delta_lt_gap m R D L)

theorem actualJobInterior_mem_job_iff (D L : ℕ) {r s : Position m R} :
    (baseline m R s - delta m R D L ≤ baseline m R r - delta m R D L / 2 ∧
      baseline m R r - delta m R D L / 2 < baseline m R s) ↔ s = r :=
  jobInterior_mem_job_iff (delta_pos m R D L) (delta_lt_gap m R D L)

end BinPackingGap.Geometry

end OAI
end LocalizedSource15
/- END LOCALIZED SOURCE 15/44: OAI/Computability/BinPacking/Packing/CoordinateOrder.lean -/

/- BEGIN LOCALIZED SOURCE 16/44: OAI/Computability/BinPacking/Trees/TestGeometry.lean
   SHA256: 87b331dafffbafdfaef24e828463714bbd5b72cdf08bd3daea8fed5857ea95b6 -/
section LocalizedSource16
-- localized import: Mathlib.Order.Interval.Set.Disjoint
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryScores
-- localized import: OAI.Computability.BinPacking.Packing.CoordinateOrder

namespace OAI

namespace BinPackingGap.Geometry

variable {m R D L : ℕ}

def jobLeft (m R D L : ℕ) (r : Position m R) : ℚ :=
  baseline m R r - delta m R D L

def closedJobCell (m R D L : ℕ) (r : Position m R) : Set ℚ :=
  Set.Icc (jobLeft m R D L r) (baseline m R r)

def jobTestInterval (m R D L : ℕ) (r : Position m R) : Set ℚ :=
  Set.Ico (jobLeft m R D L r) (baseline m R r)

def jobInterior (m R D L : ℕ) (r : Position m R) : ℚ :=
  baseline m R r - delta m R D L / 2

theorem closed_interval_gap_le_length {a b l₁ u₁ l₂ u₂ : ℚ}
    (h₁ : (Set.Icc a b ∩ Set.Icc l₁ u₁).Nonempty)
    (h₂ : (Set.Icc a b ∩ Set.Icc l₂ u₂).Nonempty) :
    l₂ - u₁ ≤ b - a := by
  rcases h₁ with ⟨x, hx⟩
  rcases h₂ with ⟨y, hy⟩
  have hax := hx.1.1
  have hxu := hx.2.2
  have hly := hy.2.1
  have hyb := hy.1.2
  linarith

theorem closed_interval_cannot_meet_of_lt_gap {a b l₁ u₁ l₂ u₂ : ℚ}
    (hlen : b - a < l₂ - u₁)
    (h₁ : (Set.Icc a b ∩ Set.Icc l₁ u₁).Nonempty)
    (h₂ : (Set.Icc a b ∩ Set.Icc l₂ u₂).Nonempty) : False :=
  (not_le_of_gt hlen) (closed_interval_gap_le_length h₁ h₂)

theorem jobLeft_lt_baseline (m R D L : ℕ) (r : Position m R) :
    jobLeft m R D L r < baseline m R r := by
  have h := delta_pos m R D L
  unfold jobLeft
  linarith

theorem one_tenth_lt_jobLeft (m R D L : ℕ) (r : Position m R) :
    1 / 10 < jobLeft m R D L r := by
  have hb := baseline_lower m R r
  have hd := delta_lt_gap m R D L
  have hg := gap_le_one_sixteen m R
  unfold jobLeft
  linarith

theorem job_baseline_lt_one (m R : ℕ) (r : Position m R) :
    baseline m R r < 1 := by
  have h := baseline_upper m R r
  linarith

theorem closedJobCell_bounds {r : Position m R} {x : ℚ}
    (hx : x ∈ closedJobCell m R D L r) : 1 / 10 < x ∧ x < 1 := by
  exact ⟨lt_of_lt_of_le (one_tenth_lt_jobLeft m R D L r) hx.1,
    lt_of_le_of_lt hx.2 (job_baseline_lt_one m R r)⟩

theorem closedJobCell_subset_plusRoot (m R D L : ℕ) (r : Position m R) :
    closedJobCell m R D L r ⊆ Set.Icc 0 1 := by
  intro x hx
  obtain ⟨hleft, hright⟩ := closedJobCell_bounds hx
  exact ⟨by linarith, hright.le⟩

theorem jobTestInterval_subset_closedJobCell (m R D L : ℕ) (r : Position m R) :
    jobTestInterval m R D L r ⊆ closedJobCell m R D L r := by
  intro x hx
  exact ⟨hx.1, hx.2.le⟩

theorem job_gap_of_posLT (D L : ℕ) {r s : Position m R} (hrs : posLT r s) :
    gap m R - delta m R D L ≤ jobLeft m R D L s - baseline m R r := by
  have h := baseline_gap_of_posLT hrs
  unfold jobLeft
  linarith

theorem baseline_lt_jobLeft_of_posLT (D L : ℕ) {r s : Position m R}
    (hrs : posLT r s) : baseline m R r < jobLeft m R D L s := by
  have hgap := job_gap_of_posLT D L hrs
  have hd := delta_lt_gap m R D L
  linarith

theorem closedJobCell_disjoint {r s : Position m R} (hrs : r ≠ s) :
    Disjoint (closedJobCell m R D L r) (closedJobCell m R D L s) := by
  apply Set.disjoint_left.mpr
  intro x hx hy
  rcases posLT_or_posLT_of_ne hrs with hlt | hlt
  · have h := baseline_lt_jobLeft_of_posLT D L hlt
    exact (not_le_of_gt h) (hy.1.trans hx.2)
  · have h := baseline_lt_jobLeft_of_posLT D L hlt
    exact (not_le_of_gt h) (hx.1.trans hy.2)

theorem jobTestInterval_disjoint {r s : Position m R} (hrs : r ≠ s) :
    Disjoint (jobTestInterval m R D L r) (jobTestInterval m R D L s) := by
  apply Set.disjoint_left.mpr
  intro x hx hy
  exact Set.disjoint_left.mp (closedJobCell_disjoint hrs)
    (jobTestInterval_subset_closedJobCell m R D L r hx)
    (jobTestInterval_subset_closedJobCell m R D L s hy)

theorem closedJobCell_unique_of_short_interval (hL : 1 ≤ L)
    {a b : ℚ} {r s : Position m R}
    (hlen : b - a ≤ lambda m R D 1 + delta m R D L)
    (hr : (Set.Icc a b ∩ closedJobCell m R D L r).Nonempty)
    (hs : (Set.Icc a b ∩ closedJobCell m R D L s).Nonempty) : r = s := by
  have hwidth := lambda_one_add_two_delta_lt_gap m R D hL
  rcases posLT_trichotomy r s with hrs | hrs | hsr
  · have hgap := job_gap_of_posLT D L hrs
    have hspan := closed_interval_gap_le_length hr hs
    linarith
  · exact hrs
  · have hgap := job_gap_of_posLT D L hsr
    have hspan := closed_interval_gap_le_length hs hr
    linarith

theorem closedJobCell_unique_of_short_halfOpen (hL : 1 ≤ L)
    {a b : ℚ} {r s : Position m R}
    (hlen : b - a ≤ lambda m R D 1 + delta m R D L)
    (hr : (Set.Ico a b ∩ closedJobCell m R D L r).Nonempty)
    (hs : (Set.Ico a b ∩ closedJobCell m R D L s).Nonempty) : r = s := by
  apply closedJobCell_unique_of_short_interval hL hlen
  · rcases hr with ⟨x, hx⟩
    exact ⟨x, ⟨hx.1.1, hx.1.2.le⟩, hx.2⟩
  · rcases hs with ⟨x, hx⟩
    exact ⟨x, ⟨hx.1.1, hx.1.2.le⟩, hx.2⟩

theorem jobInterior_mem_jobTestInterval (m R D L : ℕ) (r : Position m R) :
    jobInterior m R D L r ∈ jobTestInterval m R D L r :=
  jobInterior_mem_current (delta_pos m R D L) r

theorem jobInterior_mem_closedJobCell (m R D L : ℕ) (r : Position m R) :
    jobInterior m R D L r ∈ closedJobCell m R D L r :=
  jobTestInterval_subset_closedJobCell m R D L r
    (jobInterior_mem_jobTestInterval m R D L r)

theorem baseline_le_jobInterior (D L : ℕ) {r s : Position m R} :
    baseline m R s ≤ jobInterior m R D L r ↔ posLT s r :=
  baseline_le_actualJobInterior_iff D L

theorem jobInterior_mem_jobTestInterval_iff (D L : ℕ) {r s : Position m R} :
    jobInterior m R D L r ∈ jobTestInterval m R D L s ↔ s = r :=
  actualJobInterior_mem_job_iff D L

end BinPackingGap.Geometry

namespace BinPackingGap.InventoryData

variable (D : InventoryData)

def geometryBound : ℕ := TreeGeometry.commonBranchBound D.plus D.minus

theorem plus_branch_le_geometryBound : D.plus.branchBound ≤ D.geometryBound :=
  TreeGeometry.plus_branch_le D.plus D.minus

theorem minus_branch_le_geometryBound : D.minus.branchBound ≤ D.geometryBound :=
  TreeGeometry.minus_branch_le D.plus D.minus

def incidencePosition {v : D.Vertex} (j : D.IncidencePosition v) : D.Position :=
  (j.1.val.1, j.2)

theorem incidencePosition_injective (v : D.Vertex) :
    Function.Injective (D.incidencePosition (v := v)) := by
  rintro ⟨⟨⟨e, s⟩, hes⟩, i⟩ ⟨⟨⟨f, t⟩, hft⟩, j⟩ h
  change (e, i) = (f, j) at h
  have he : e = f := congrArg Prod.fst h
  have hij : i = j := congrArg Prod.snd h
  subst f
  subst j
  have hst : s = t := D.graph.endpoint_injective e (hes.trans hft.symm)
  subst t
  rfl

def testLeft {v : D.Vertex} : D.TestAt v → ℚ
  | .inl p => TreeGeometry.left D.graph.edges.length D.R D.geometryBound .plus p.val.val
  | .inr (.inl p) =>
      TreeGeometry.left D.graph.edges.length D.R D.geometryBound .minus p.val.val
  | .inr (.inr j) =>
      Geometry.jobLeft D.graph.edges.length D.R D.geometryBound D.L (D.incidencePosition j)

def testRight {v : D.Vertex} : D.TestAt v → ℚ
  | .inl p => TreeGeometry.right D.graph.edges.length D.R D.geometryBound .plus p.val.val
  | .inr (.inl p) =>
      TreeGeometry.right D.graph.edges.length D.R D.geometryBound .minus p.val.val
  | .inr (.inr j) => Geometry.baseline D.graph.edges.length D.R (D.incidencePosition j)

def testCell {v : D.Vertex} (t : D.TestAt v) : Set ℚ :=
  Set.Icc (D.testLeft t) (D.testRight t)

def testInterval {v : D.Vertex} (t : D.TestAt v) : Set ℚ :=
  Set.Ico (D.testLeft t) (D.testRight t)

theorem testLeft_lt_testRight {v : D.Vertex} (t : D.TestAt v) :
    D.testLeft t < D.testRight t := by
  rcases t with p | p | j
  · exact TreeGeometry.left_lt_right _ _ _ .plus p.val.val
  · exact TreeGeometry.left_lt_right _ _ _ .minus p.val.val
  · exact Geometry.jobLeft_lt_baseline _ _ _ _ (D.incidencePosition j)

private theorem tree_endpoints_in_root {T : UniformTree} (v : T.Node)
    (s : TreeGeometry.Side) (hT : T.branchBound ≤ D.geometryBound) :
    TreeGeometry.rootOffset s ≤
        TreeGeometry.left D.graph.edges.length D.R D.geometryBound s v.val ∧
      TreeGeometry.right D.graph.edges.length D.R D.geometryBound s v.val ≤
        TreeGeometry.rootOffset s + 1 := by
  simpa only [TreeGeometry.left_nil, TreeGeometry.right_nil] using
    TreeGeometry.prefix_endpoints D.graph.edges.length D.R D.geometryBound s
      (u := []) (v := v.val) List.nil_prefix (TreeGeometry.boundedAddress_node v hT)

theorem test_endpoints_bounds {v : D.Vertex} (t : D.TestAt v) :
    0 ≤ D.testLeft t ∧ D.testRight t ≤ 5 := by
  rcases t with p | p | j
  · have h := D.tree_endpoints_in_root p.val .plus D.plus_branch_le_geometryBound
    norm_num only [TreeGeometry.rootOffset] at h
    change 0 ≤ D.testLeft (.inl p : D.TestAt v) ∧
      D.testRight (.inl p : D.TestAt v) ≤ 1 at h
    exact ⟨h.1, by linarith [h.2]⟩
  · have h := D.tree_endpoints_in_root p.val .minus D.minus_branch_le_geometryBound
    norm_num only [TreeGeometry.rootOffset] at h
    change 4 ≤ D.testLeft (.inr (.inl p) : D.TestAt v) ∧
      D.testRight (.inr (.inl p) : D.TestAt v) ≤ 5 at h
    exact ⟨by linarith [h.1], h.2⟩
  · have hl := Geometry.one_tenth_lt_jobLeft D.graph.edges.length D.R
      D.geometryBound D.L (D.incidencePosition j)
    have hr := Geometry.job_baseline_lt_one D.graph.edges.length D.R (D.incidencePosition j)
    change 0 ≤ Geometry.jobLeft _ _ _ _ _ ∧ Geometry.baseline _ _ _ ≤ 5
    constructor <;> linarith

theorem testLeft_nonneg {v : D.Vertex} (t : D.TestAt v) : 0 ≤ D.testLeft t :=
  (D.test_endpoints_bounds t).1

theorem testRight_le_five {v : D.Vertex} (t : D.TestAt v) : D.testRight t ≤ 5 :=
  (D.test_endpoints_bounds t).2

theorem testCell_subset_range {v : D.Vertex} (t : D.TestAt v) :
    D.testCell t ⊆ Set.Icc (0 : ℚ) 5 := by
  intro x hx
  exact ⟨(D.testLeft_nonneg t).trans hx.1, hx.2.trans (D.testRight_le_five t)⟩

theorem testInterval_subset_testCell {v : D.Vertex} (t : D.TestAt v) :
    D.testInterval t ⊆ D.testCell t := fun _ hx => ⟨hx.1, hx.2.le⟩

private theorem disjoint_of_endpoint_lt {a b c d : ℚ} (h : b < c) :
    Disjoint (Set.Icc a b) (Set.Icc c d) := by
  apply Set.disjoint_left.mpr
  intro x hx hy
  exact (not_le_of_gt h) (hy.1.trans hx.2)

private theorem same_depth_cells_disjoint {s t : TreeGeometry.Side} {u w : List ℕ}
    (hu : u.length = D.L) (hw : w.length = D.L)
    (hbu : TreeGeometry.BoundedAddress D.geometryBound u)
    (hbw : TreeGeometry.BoundedAddress D.geometryBound w) (hne : (s, u) ≠ (t, w)) :
    Disjoint (TreeGeometry.cell D.graph.edges.length D.R D.geometryBound s u)
      (TreeGeometry.cell D.graph.edges.length D.R D.geometryBound t w) := by
  have hg := TreeGeometry.same_depth_gap D.graph.edges.length D.R D.geometryBound D.L
    hu hw hbu hbw hne
  have hp := Geometry.lambda_pos D.graph.edges.length D.R D.geometryBound D.L
  rcases hg with hg | hg
  · exact disjoint_of_endpoint_lt (by linarith)
  · exact (disjoint_of_endpoint_lt (by linarith)).symm

private theorem plusLeaf_right_lt_tenth (hplusheight : D.plus.height = D.L)
    (hL : 1 ≤ D.L) (p : D.PlusLeaf) :
    TreeGeometry.right D.graph.edges.length D.R D.geometryBound .plus p.val.val < 1 / 10 := by
  have hlength : p.val.val.length = D.L := (D.plus.length_leaf _ p.property).trans hplusheight
  have hn : p.val.val ≠ [] := by
    intro h
    rw [h] at hlength
    simp only [List.length_nil] at hlength
    omega
  have hb := TreeGeometry.nonroot_endpoints D.graph.edges.length D.R D.geometryBound .plus
    hn (TreeGeometry.boundedAddress_node p.val D.plus_branch_le_geometryBound)
  simpa only [TreeGeometry.rootOffset, zero_add] using hb.2

private theorem plusLeaf_job_disjoint (hplusheight : D.plus.height = D.L)
    (hL : 1 ≤ D.L) {v : D.Vertex} (p : D.PlusLeaf) (j : D.IncidencePosition v) :
    Disjoint (D.testCell (.inl p : D.TestAt v)) (D.testCell (.inr (.inr j))) := by
  have hp := D.plusLeaf_right_lt_tenth hplusheight hL p
  have hj := Geometry.one_tenth_lt_jobLeft D.graph.edges.length D.R D.geometryBound D.L
    (D.incidencePosition j)
  exact disjoint_of_endpoint_lt (hp.trans hj)

private theorem minusLeaf_job_disjoint {v : D.Vertex} (p : D.MinusLeaf)
    (j : D.IncidencePosition v) :
    Disjoint (D.testCell (.inr (.inl p) : D.TestAt v)) (D.testCell (.inr (.inr j))) := by
  have hp := D.tree_endpoints_in_root p.val .minus D.minus_branch_le_geometryBound
  have hj := Geometry.job_baseline_lt_one D.graph.edges.length D.R (D.incidencePosition j)
  norm_num only [TreeGeometry.rootOffset] at hp
  change 4 ≤ TreeGeometry.left D.graph.edges.length D.R D.geometryBound .minus p.val.val ∧
    _ ≤ 5 at hp
  have hgap : Geometry.baseline D.graph.edges.length D.R (D.incidencePosition j) <
      TreeGeometry.left D.graph.edges.length D.R D.geometryBound .minus p.val.val := by
    linarith [hp.1]
  exact (disjoint_of_endpoint_lt hgap).symm

theorem testCell_disjoint (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L)
    {v : D.Vertex} {s t : D.TestAt v} (hne : s ≠ t) :
    Disjoint (D.testCell s) (D.testCell t) := by
  rcases s with p | p | j <;> rcases t with q | q | k
  · apply D.same_depth_cells_disjoint
      ((D.plus.length_leaf _ p.property).trans hplusheight)
      ((D.plus.length_leaf _ q.property).trans hplusheight)
      (TreeGeometry.boundedAddress_node p.val D.plus_branch_le_geometryBound)
      (TreeGeometry.boundedAddress_node q.val D.plus_branch_le_geometryBound)
    intro h
    have hpq : p = q := Subtype.ext (Subtype.ext (congrArg Prod.snd h))
    exact hne (congrArg Sum.inl hpq)
  · apply D.same_depth_cells_disjoint
      ((D.plus.length_leaf _ p.property).trans hplusheight)
      ((D.minus.length_leaf _ q.property).trans hminusheight)
      (TreeGeometry.boundedAddress_node p.val D.plus_branch_le_geometryBound)
      (TreeGeometry.boundedAddress_node q.val D.minus_branch_le_geometryBound)
    intro h
    have hs := congrArg Prod.fst h
    cases hs
  · exact D.plusLeaf_job_disjoint hplusheight hL p k
  · apply D.same_depth_cells_disjoint
      ((D.minus.length_leaf _ p.property).trans hminusheight)
      ((D.plus.length_leaf _ q.property).trans hplusheight)
      (TreeGeometry.boundedAddress_node p.val D.minus_branch_le_geometryBound)
      (TreeGeometry.boundedAddress_node q.val D.plus_branch_le_geometryBound)
    intro h
    have hs := congrArg Prod.fst h
    cases hs
  · apply D.same_depth_cells_disjoint
      ((D.minus.length_leaf _ p.property).trans hminusheight)
      ((D.minus.length_leaf _ q.property).trans hminusheight)
      (TreeGeometry.boundedAddress_node p.val D.minus_branch_le_geometryBound)
      (TreeGeometry.boundedAddress_node q.val D.minus_branch_le_geometryBound)
    intro h
    have hpq : p = q := Subtype.ext (Subtype.ext (congrArg Prod.snd h))
    exact hne (congrArg (fun l => Sum.inr (Sum.inl l)) hpq)
  · exact D.minusLeaf_job_disjoint p k
  · exact (D.plusLeaf_job_disjoint hplusheight hL q j).symm
  · exact (D.minusLeaf_job_disjoint q j).symm
  · apply Geometry.closedJobCell_disjoint
    intro h
    have hjk := D.incidencePosition_injective v h
    exact hne (congrArg (fun r => Sum.inr (Sum.inr r)) hjk)

theorem testCell_pairwise_disjoint (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L) (v : D.Vertex) :
    Pairwise (fun s t : D.TestAt v => Disjoint (D.testCell s) (D.testCell t)) :=
  fun _ _ hne => D.testCell_disjoint hplusheight hminusheight hL hne

theorem testInterval_disjoint (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L)
    {v : D.Vertex} {s t : D.TestAt v} (hne : s ≠ t) :
    Disjoint (D.testInterval s) (D.testInterval t) :=
  (D.testCell_disjoint hplusheight hminusheight hL hne).mono
    (D.testInterval_subset_testCell s) (D.testInterval_subset_testCell t)

theorem testInterval_pairwise_disjoint (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L) (v : D.Vertex) :
    Pairwise (fun s t : D.TestAt v => Disjoint (D.testInterval s) (D.testInterval t)) :=
  fun _ _ hne => D.testInterval_disjoint hplusheight hminusheight hL hne

end BinPackingGap.InventoryData

end OAI
end LocalizedSource16
/- END LOCALIZED SOURCE 16/44: OAI/Computability/BinPacking/Trees/TestGeometry.lean -/

/- BEGIN LOCALIZED SOURCE 17/44: OAI/Computability/BinPacking/Packing/PackingCoordinates.lean
   SHA256: 81610dfe6b3ffbb3f70f665f9bbb750ca7035be50dafc271023b88d58fd54e0d -/
section LocalizedSource17
-- localized import: OAI.Computability.BinPacking.Packing.PackingSelections
-- localized import: OAI.Computability.BinPacking.Trees.TestGeometry

namespace OAI

namespace BinPackingGap.InventoryData

variable (D : InventoryData)

def treeBaseline : D.TreeRow → ℚ
  | .inl (node, _) =>
      TreeGeometry.right D.graph.edges.length D.R D.geometryBound .plus node.val
  | .inr (.inl (node, _)) =>
      TreeGeometry.right D.graph.edges.length D.R D.geometryBound .minus node.val
  | .inr (.inr _) => 1

def rowBaseline {v : D.Vertex} : D.RowAt v → ℚ
  | .inl r => D.treeBaseline r
  | .inr (_, j) => Geometry.baseline D.graph.edges.length D.R (D.jobPosition j)

def mainBaseline {v : D.Vertex} : D.MBase v → ℚ
  | .inl r => D.treeBaseline r
  | .inr j => Geometry.baseline D.graph.edges.length D.R (D.jobPosition j)

def treeDeadline : D.TreeRow → ℚ
  | .inl (node, _) =>
      if node.val ∈ D.plus.leaves then
        TreeGeometry.left D.graph.edges.length D.R D.geometryBound .plus node.val
      else TreeGeometry.right D.graph.edges.length D.R D.geometryBound .plus node.val
  | .inr (.inl (node, _)) =>
      if node.val ∈ D.minus.leaves then
        TreeGeometry.left D.graph.edges.length D.R D.geometryBound .minus node.val
      else TreeGeometry.right D.graph.edges.length D.R D.geometryBound .minus node.val
  | .inr (.inr _) => 1

def deadline {v : D.Vertex} : D.MBase v → ℚ
  | .inl r => D.treeDeadline r
  | .inr j => Geometry.jobLeft D.graph.edges.length D.R D.geometryBound D.L
      (D.jobPosition j)

def rowCoordinate {v : D.Vertex} (r : D.RowAt v) : ℚ :=
  D.rowBaseline r - if D.rowShort r then
    Geometry.delta D.graph.edges.length D.R D.geometryBound D.L else 0

def anchorCoordinate {v : D.Vertex} : D.AnchorAt v → ℚ
  | .inl z => -D.deadline z
  | .inr j => -Geometry.baseline D.graph.edges.length D.R (D.jobPosition j) -
      Geometry.beta D.graph.edges.length D.R (D.jobPosition j).1

def globalLength : D.GlobalCopy → ℚ
  | ⟨.up one, _⟩ => if one then 1 else 0
  | ⟨.um one, _⟩ => if one then 1 else 0
  | ⟨.edge _ _, _⟩ => 0

def globalCoordinate : D.GlobalCopy → ℚ
  | ⟨.up one, _⟩ => -(if one then 1 else 0)
  | ⟨.um one, _⟩ => -(if one then 1 else 0)
  | ⟨.edge e permit, _⟩ => Geometry.beta D.graph.edges.length D.R e +
      if permit then 0 else Geometry.delta D.graph.edges.length D.R D.geometryBound D.L

def localLength {v : D.Vertex} : D.LocalAt v → ℚ
  | .inl (.inl ⟨ell, _⟩) =>
      Geometry.lambda D.graph.edges.length D.R D.geometryBound ell.val
  | _ => 0

def localCoordinate {v : D.Vertex} (i : D.LocalAt v) : ℚ := -D.localLength i

def itemCoordinate : D.Item → ℚ
  | ⟨.x, ⟨_, r⟩⟩ => D.rowCoordinate r
  | ⟨.anchor, ⟨_, a⟩⟩ => D.anchorCoordinate a
  | ⟨.«global», u⟩ => D.globalCoordinate u
  | ⟨.«local», ⟨_, l⟩⟩ => D.localCoordinate l
  | ⟨.flag, _⟩ => 0

theorem mainBaseline_designated {v : D.Vertex} (q : D.TestAt v × Fin D.d) :
    D.mainBaseline (D.designated q) = D.testRight q.1 := by
  rcases q with ⟨t, j⟩
  rcases t with p | p | r <;> rfl

theorem deadline_designated {v : D.Vertex} (q : D.TestAt v × Fin D.d) :
    D.deadline (D.designated q) = D.testLeft q.1 := by
  rcases q with ⟨t, j⟩
  rcases t with p | p | r
  · simp [designated, deadline, treeDeadline, p.property, testLeft]
  · simp [designated, deadline, treeDeadline, p.property, testLeft]
  · rfl

theorem globalLength_nonneg (u : D.GlobalCopy) : 0 ≤ D.globalLength u := by
  rcases u with ⟨s, i⟩
  cases s with
  | up b => cases b <;> norm_num [globalLength]
  | um b => cases b <;> norm_num [globalLength]
  | edge e b => simp [globalLength]

theorem globalLength_le_one (u : D.GlobalCopy) : D.globalLength u ≤ 1 := by
  rcases u with ⟨s, i⟩
  cases s with
  | up b => cases b <;> norm_num [globalLength]
  | um b => cases b <;> norm_num [globalLength]
  | edge e b => simp [globalLength]

private theorem node_endpoint_bounds {T : UniformTree} (node : T.Node)
    (side : TreeGeometry.Side) (hT : T.branchBound ≤ D.geometryBound) :
    (0 ≤ TreeGeometry.left D.graph.edges.length D.R D.geometryBound side node.val ∧
      TreeGeometry.left D.graph.edges.length D.R D.geometryBound side node.val ≤ 5) ∧
    (0 ≤ TreeGeometry.right D.graph.edges.length D.R D.geometryBound side node.val ∧
      TreeGeometry.right D.graph.edges.length D.R D.geometryBound side node.val ≤ 5) := by
  have hroot := TreeGeometry.prefix_endpoints D.graph.edges.length D.R D.geometryBound side
    (u := []) (v := node.val) List.nil_prefix (TreeGeometry.boundedAddress_node node hT)
  simp only [TreeGeometry.left_nil, TreeGeometry.right_nil] at hroot
  have hwidth := TreeGeometry.left_lt_right D.graph.edges.length D.R D.geometryBound side node.val
  cases side <;> simp only [TreeGeometry.rootOffset] at hroot <;>
    constructor <;> constructor <;> linarith [hroot.1, hroot.2]

theorem treeBaseline_bounds (r : D.TreeRow) :
    0 ≤ D.treeBaseline r ∧ D.treeBaseline r ≤ 5 := by
  rcases r with p | p | padding
  · exact (D.node_endpoint_bounds p.1 .plus D.plus_branch_le_geometryBound).2
  · exact (D.node_endpoint_bounds p.1 .minus D.minus_branch_le_geometryBound).2
  · norm_num [treeBaseline]

theorem treeDeadline_bounds (r : D.TreeRow) :
    0 ≤ D.treeDeadline r ∧ D.treeDeadline r ≤ 5 := by
  rcases r with p | p | padding
  · have h := D.node_endpoint_bounds p.1 .plus D.plus_branch_le_geometryBound
    dsimp only [treeDeadline]
    split_ifs
    · exact h.1
    · exact h.2
  · have h := D.node_endpoint_bounds p.1 .minus D.minus_branch_le_geometryBound
    dsimp only [treeDeadline]
    split_ifs
    · exact h.1
    · exact h.2
  · norm_num [treeDeadline]

private theorem jobBaseline_bounds (p : D.Position) :
    0 ≤ Geometry.baseline D.graph.edges.length D.R p ∧
      Geometry.baseline D.graph.edges.length D.R p ≤ 5 := by
  have h := Geometry.baseline_range D.graph.edges.length D.R p
  constructor <;> linarith [h.1, h.2]

theorem rowBaseline_bounds {v : D.Vertex} (r : D.RowAt v) :
    0 ≤ D.rowBaseline r ∧ D.rowBaseline r ≤ 5 := by
  rcases r with tree | job
  · exact D.treeBaseline_bounds tree
  · exact D.jobBaseline_bounds (D.jobPosition job.2)

theorem mainBaseline_bounds {v : D.Vertex} (r : D.MBase v) :
    0 ≤ D.mainBaseline r ∧ D.mainBaseline r ≤ 5 := by
  rcases r with tree | job
  · exact D.treeBaseline_bounds tree
  · exact D.jobBaseline_bounds (D.jobPosition job)

theorem deadline_bounds {v : D.Vertex} (r : D.MBase v) :
    0 ≤ D.deadline r ∧ D.deadline r ≤ 5 := by
  rcases r with tree | job
  · exact D.treeDeadline_bounds tree
  · have hl := Geometry.one_tenth_lt_jobLeft D.graph.edges.length D.R D.geometryBound D.L
      (D.jobPosition job)
    have hu := Geometry.jobLeft_lt_baseline D.graph.edges.length D.R D.geometryBound D.L
      (D.jobPosition job)
    have hb := Geometry.job_baseline_lt_one D.graph.edges.length D.R (D.jobPosition job)
    change 0 ≤ Geometry.jobLeft _ _ _ _ _ ∧ Geometry.jobLeft _ _ _ _ _ ≤ 5
    constructor <;> linarith

theorem rowCoordinate_bounds {v : D.Vertex} (r : D.RowAt v) :
    0 ≤ D.rowCoordinate r ∧ D.rowCoordinate r ≤ 5 := by
  rcases r with tree | ⟨short, job⟩
  · simpa only [rowCoordinate, rowBaseline, rowShort, Bool.false_eq_true, ite_false,
      sub_zero] using D.treeBaseline_bounds tree
  · have hb := Geometry.baseline_range D.graph.edges.length D.R (D.jobPosition job)
    have hd := Geometry.delta_lt_gap D.graph.edges.length D.R D.geometryBound D.L
    have hg := Geometry.gap_le_one_sixteen D.graph.edges.length D.R
    have hd0 := Geometry.delta_nonneg D.graph.edges.length D.R D.geometryBound D.L
    cases short <;>
      simp only [rowCoordinate, rowBaseline, rowShort, Bool.false_eq_true, ite_false,
        ite_true, sub_zero] <;>
      constructor <;> linarith [hb.1, hb.2]

theorem anchorCoordinate_bounds {v : D.Vertex} (a : D.AnchorAt v) :
    -5 ≤ D.anchorCoordinate a ∧ D.anchorCoordinate a ≤ 0 := by
  rcases a with deadline | key
  · have h := D.deadline_bounds deadline
    change -5 ≤ -D.deadline deadline ∧ -D.deadline deadline ≤ 0
    constructor <;> linarith [h.1, h.2]
  · have hb := Geometry.baseline_range D.graph.edges.length D.R (D.jobPosition key)
    have hβ0 := Geometry.beta_nonneg D.graph.edges.length D.R (D.jobPosition key).1
    have hβ := Geometry.beta_lt_one_sixteen D.graph.edges.length D.R (D.jobPosition key).1
    dsimp only [anchorCoordinate]
    constructor <;> linarith [hb.1, hb.2]

theorem globalCoordinate_bounds (u : D.GlobalCopy) :
    -1 ≤ D.globalCoordinate u ∧ D.globalCoordinate u ≤ 1 := by
  rcases u with ⟨species, copy⟩
  cases species with
  | up one => cases one <;> norm_num [globalCoordinate]
  | um one => cases one <;> norm_num [globalCoordinate]
  | edge edge permit =>
      have hβ0 := Geometry.beta_nonneg D.graph.edges.length D.R edge
      have hβ := Geometry.beta_lt_one_sixteen D.graph.edges.length D.R edge
      have hd0 := Geometry.delta_nonneg D.graph.edges.length D.R D.geometryBound D.L
      have hd := Geometry.delta_lt_gap D.graph.edges.length D.R D.geometryBound D.L
      have hg := Geometry.gap_le_one_sixteen D.graph.edges.length D.R
      cases permit <;>
        simp only [globalCoordinate, Bool.false_eq_true, ite_false, ite_true, add_zero] <;>
        constructor <;> linarith

theorem localLength_nonneg {v : D.Vertex} (i : D.LocalAt v) : 0 ≤ D.localLength i := by
  rcases i with (⟨ell, copy⟩ | zero) | edge
  · exact Geometry.lambda_nonneg D.graph.edges.length D.R D.geometryBound ell.val
  · exact le_rfl
  · exact le_rfl

theorem localLength_le_lambda_one {v : D.Vertex} (i : D.LocalAt v) :
    D.localLength i ≤ Geometry.lambda D.graph.edges.length D.R D.geometryBound 1 := by
  rcases i with (⟨ell, copy⟩ | zero) | edge
  · exact Geometry.lambda_antitone D.graph.edges.length D.R D.geometryBound
      (Finset.mem_Icc.mp ell.property).1
  · exact Geometry.lambda_nonneg D.graph.edges.length D.R D.geometryBound 1
  · exact Geometry.lambda_nonneg D.graph.edges.length D.R D.geometryBound 1

theorem localLength_le_one {v : D.Vertex} (i : D.LocalAt v) : D.localLength i ≤ 1 :=
  (D.localLength_le_lambda_one i).trans
    (Geometry.lambda_le_one D.graph.edges.length D.R D.geometryBound 1)

theorem localCoordinate_bounds {v : D.Vertex} (i : D.LocalAt v) :
    -1 ≤ D.localCoordinate i ∧ D.localCoordinate i ≤ 0 := by
  have h0 := D.localLength_nonneg i
  have h1 := D.localLength_le_one i
  unfold localCoordinate
  constructor <;> linarith

theorem itemCoordinate_bounds (i : D.Item) :
    -5 ≤ D.itemCoordinate i ∧ D.itemCoordinate i ≤ 5 := by
  rcases i with ⟨role, i⟩
  cases role with
  | x =>
      rcases i with ⟨v, r⟩
      have h := D.rowCoordinate_bounds r
      change -5 ≤ D.rowCoordinate r ∧ D.rowCoordinate r ≤ 5
      exact ⟨by linarith [h.1], h.2⟩
  | anchor =>
      rcases i with ⟨v, a⟩
      have h := D.anchorCoordinate_bounds a
      change -5 ≤ D.anchorCoordinate a ∧ D.anchorCoordinate a ≤ 5
      exact ⟨h.1, by linarith [h.2]⟩
  | «global» =>
      have h := D.globalCoordinate_bounds i
      change -5 ≤ D.globalCoordinate i ∧ D.globalCoordinate i ≤ 5
      constructor <;> linarith [h.1, h.2]
  | «local» =>
      rcases i with ⟨v, l⟩
      have h := D.localCoordinate_bounds l
      change -5 ≤ D.localCoordinate l ∧ D.localCoordinate l ≤ 5
      constructor <;> linarith [h.1, h.2]
  | flag => norm_num [itemCoordinate]

theorem itemCoordinate_abs_le_six (i : D.Item) : |D.itemCoordinate i| ≤ 6 := by
  have h := D.itemCoordinate_bounds i
  apply abs_le.mpr
  constructor <;> linarith [h.1, h.2]

def stateRowEquiv (v : D.Vertex) (selected : Bool) : D.LocalBin v ≃ D.RowAt v where
  toFun
    | .inl (.inl t) => .inl t
    | .inl (.inr j) => .inr (!selected, j)
    | .inr j => .inr (selected, j)
  invFun
    | .inl t => .inl (.inl t)
    | .inr (short, j) => if short = selected then .inr j else .inl (.inr j)
  left_inv i := by
    rcases i with (t | j) | j <;> cases selected <;> simp
  right_inv r := by
    rcases r with t | ⟨b, j⟩
    · rfl
    · cases b <;> cases selected <;> simp

@[simp] theorem stateRowEquiv_tree (v : D.Vertex) (selected : Bool) (t : D.TreeRow) :
    D.stateRowEquiv v selected (.inl (.inl t)) = .inl t := rfl

@[simp] theorem stateRowEquiv_mainJob (v : D.Vertex) (selected : Bool) (j : D.JobCopy v) :
    D.stateRowEquiv v selected (.inl (.inr j)) = .inr (!selected, j) := rfl

@[simp] theorem stateRowEquiv_edgeJob (v : D.Vertex) (selected : Bool) (j : D.JobCopy v) :
    D.stateRowEquiv v selected (.inr j) = .inr (selected, j) := rfl

def stateMainRow (v : D.Vertex) (selected : Bool) (b : D.MBase v) : D.RowAt v :=
  D.stateRowEquiv v selected (.inl b)

theorem stateMainRow_injective (v : D.Vertex) (selected : Bool) :
    Function.Injective (D.stateMainRow v selected) := by
  intro b c h
  exact Sum.inl.inj ((D.stateRowEquiv v selected).injective h)

@[simp] theorem stateMainRow_baseline (v : D.Vertex) (selected : Bool) (b : D.MBase v) :
    D.rowBaseline (D.stateMainRow v selected b) = D.mainBaseline b := by
  rcases b with t | j <;> rfl

def stateFlagSpecies {v : D.Vertex} : D.LocalBin v → FlagSpecies
  | .inl (.inl _) => .tree
  | .inl (.inr _) => .main
  | .inr _ => .edge

def stateMainGlobalSpecies {v : D.Vertex} (selected : Bool) :
    D.MBase v → GlobalSpecies D.graph
  | .inl (.inl (node, _)) => .up (selected && decide (node = D.plus.root))
  | .inl (.inr (.inl (node, _))) => .um (!selected && decide (node = D.minus.root))
  | .inl (.inr (.inr _)) => .up false
  | .inr _ => .up false

def stateGlobalSpecies {v : D.Vertex} (selected : Bool) :
    D.LocalBin v → GlobalSpecies D.graph
  | .inl b => D.stateMainGlobalSpecies selected b
  | .inr j => .edge (D.jobPosition j).1 (!selected)

def globalSpeciesLength : GlobalSpecies D.graph → ℚ
  | .up one => if one then 1 else 0
  | .um one => if one then 1 else 0
  | .edge _ _ => 0

theorem globalLength_eq_species (u : D.GlobalCopy) :
    D.globalLength u = D.globalSpeciesLength u.1 := by
  rcases u with ⟨s, i⟩
  cases s <;> rfl

def stateMainLength {v : D.Vertex} (selected : Bool) (b : D.MBase v) : ℚ :=
  D.globalSpeciesLength (D.stateMainGlobalSpecies selected b)

theorem stateMainLength_nonneg {v : D.Vertex} (selected : Bool) (b : D.MBase v) :
    0 ≤ D.stateMainLength selected b := by
  rcases b with (⟨p, i⟩ | ⟨m, i⟩ | i) | j
  all_goals simp only [stateMainLength, stateMainGlobalSpecies, globalSpeciesLength]
  all_goals split_ifs <;> norm_num

theorem stateMainLength_le_one {v : D.Vertex} (selected : Bool) (b : D.MBase v) :
    D.stateMainLength selected b ≤ 1 := by
  rcases b with (⟨p, i⟩ | ⟨m, i⟩ | i) | j
  all_goals simp only [stateMainLength, stateMainGlobalSpecies, globalSpeciesLength]
  all_goals split_ifs <;> norm_num

def fundedRoot {v : D.Vertex} (selected : Bool) (j : Fin D.d) : D.MBase v :=
  if selected then .inl (.inl (D.plus.root, j))
  else .inl (.inr (.inl (D.minus.root, j)))

theorem fundedRoot_injective (v : D.Vertex) (selected : Bool) :
    Function.Injective (D.fundedRoot (v := v) selected) := by
  intro i j h
  cases selected <;> simpa [fundedRoot] using h

@[simp] theorem stateMainLength_fundedRoot {v : D.Vertex} (selected : Bool) (j : Fin D.d) :
    D.stateMainLength selected (D.fundedRoot (v := v) selected j) = 1 := by
  cases selected <;> simp [fundedRoot, stateMainLength, stateMainGlobalSpecies,
    globalSpeciesLength]

abbrev PhysicalBins := Σ v : D.Vertex, D.LocalBin v

theorem card_physicalBins : Fintype.card D.PhysicalBins = D.B := by
  simp only [PhysicalBins, Fintype.card_sigma, D.card_localBin, B]

structure LocalState (v : D.Vertex) (selected : Bool) where
  localEquiv : D.MBase v ≃ D.DMAt v
  anchorEquiv : D.MBase v ≃ D.MBase v
  completion_le_deadline : ∀ b,
    D.rowCoordinate (D.stateMainRow v selected b) - D.stateMainLength selected b -
      D.localLength (.inl (localEquiv b)) ≤ D.deadline (anchorEquiv b)

namespace LocalState

variable {D} {v : D.Vertex} {selected : Bool} (S : D.LocalState v selected)

def anchorAtEquiv : D.LocalBin v ≃ D.AnchorAt v :=
  Equiv.sumCongr S.anchorEquiv (Equiv.refl _)

def localAtEquiv : D.LocalBin v ≃ D.LocalAt v :=
  Equiv.sumCongr S.localEquiv (Equiv.refl _)

@[simp] theorem anchorAtEquiv_main (b : D.MBase v) :
    S.anchorAtEquiv (.inl b) = .inl (S.anchorEquiv b) := rfl

@[simp] theorem anchorAtEquiv_edge (j : D.JobCopy v) :
    S.anchorAtEquiv (.inr j) = .inr j := rfl

@[simp] theorem localAtEquiv_main (b : D.MBase v) :
    S.localAtEquiv (.inl b) = .inl (S.localEquiv b) := rfl

@[simp] theorem localAtEquiv_edge (j : D.JobCopy v) :
    S.localAtEquiv (.inr j) = .inr j := rfl

end LocalState

end BinPackingGap.InventoryData

noncomputable section

namespace BinPackingGap
namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

def tupleBaseline (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : ℚ := D.rowBaseline (rowCopy p e t).2

def tupleShort (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : Bool := D.rowShort (rowCopy p e t).2

def tupleGlobalLength (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : ℚ := D.globalLength (globalCopy p e t)

def tupleLocalLength (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : ℚ := D.localLength (localCopy p e t).2

def tupleFinish (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : ℚ :=
  completion (tupleBaseline p e t) (tupleShort p e t)
    (tupleGlobalLength p e t) (tupleLocalLength p e t)
    (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L)

def tupleClosedInterval (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : Set ℚ :=
  Set.Icc (tupleFinish p e t) (tupleBaseline p e t)

def tupleCoveringInterval (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : Set ℚ :=
  Set.Ico (tupleFinish p e t) (tupleBaseline p e t)

def tupleCovering (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ) :
    Finset (p.TableBin (subclass e)) := by
  classical
  exact (Coverage.mainTuplesAt p (subclass e) (label e) v).filter fun t =>
    tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t

@[simp] theorem mem_tupleCovering (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (a : ℚ) (t : p.TableBin (subclass e)) :
    t ∈ tupleCovering p e v a ↔
      t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v ∧
        tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t := by
  classical
  simp [tupleCovering, and_assoc]

theorem tupleGlobalLength_nonneg (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : 0 ≤ tupleGlobalLength p e t :=
  D.globalLength_nonneg _

theorem tupleGlobalLength_le_one (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : tupleGlobalLength p e t ≤ 1 :=
  D.globalLength_le_one _

theorem tupleGlobalLength_eq_of_unit_false (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (hu : D.globalUnit (globalCopy p e t) = false) :
    tupleGlobalLength p e t = 0 := by
  have h : D.globalLength (globalCopy p e t) =
      if D.globalUnit (globalCopy p e t) then 1 else 0 := by
    rcases globalCopy p e t with ⟨s, i⟩
    cases s <;> rfl
  simpa only [tupleGlobalLength, hu, Bool.false_eq_true, ↓reduceIte] using h

private theorem localLength_nonneg {v : D.Vertex} (l : D.LocalAt v) : 0 ≤ D.localLength l := by
  rcases l with ((⟨ell, i⟩ | z) | g)
  · exact Geometry.lambda_nonneg _ _ _ _
  · rfl
  · rfl

private theorem localLength_le_first {v : D.Vertex} (l : D.LocalAt v) :
    D.localLength l ≤ Geometry.lambda D.graph.edges.length D.R D.geometryBound 1 := by
  rcases l with ((⟨ell, i⟩ | z) | g)
  · exact Geometry.lambda_antitone _ _ _ (Finset.mem_Icc.mp ell.property).1
  · exact Geometry.lambda_nonneg _ _ _ _
  · exact Geometry.lambda_nonneg _ _ _ _

theorem tupleLocalLength_nonneg (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : 0 ≤ tupleLocalLength p e t :=
  localLength_nonneg _

theorem tupleLocalLength_le_first (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) :
    tupleLocalLength p e t ≤ Geometry.lambda D.graph.edges.length D.R D.geometryBound 1 :=
  localLength_le_first _

theorem tupleLocalLength_eq_zero_of_not_positive (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v)
    (hnot : p.itemAtRole (subclass e) t .«local» ∉ positiveLocalResources e v) :
    tupleLocalLength p e t = 0 := by
  rcases hc : localCopy p e t with ⟨w, ((i | z) | g)⟩
  · have hw : w = v := by simpa only [hc] using good_local_vertex p e v t ht
    subst w
    exfalso
    apply hnot
    apply (mem_positiveLocalResources e v _).mpr
    refine ⟨i, ?_⟩
    rw [← roleCopy_item p e t .«local»]
    exact congrArg (fun x : (Σ w : D.Vertex, D.LocalAt w) => e ⟨.«local», x⟩) hc.symm
  · unfold tupleLocalLength
    rw [hc]
    rfl
  · unfold tupleLocalLength
    rw [hc]
    rfl

theorem tupleFinish_le_baseline (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) : tupleFinish p e t ≤ tupleBaseline p e t :=
  completion_le_baseline _ _ _ _ _ (tupleGlobalLength_nonneg p e t)
    (tupleLocalLength_nonneg p e t) (Geometry.delta_nonneg _ _ _ _)

theorem selected_localLength (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e)) (ht : t ∈ zeroPositiveTuples p e v) :
    tupleLocalLength p e t =
      Geometry.lambda D.graph.edges.length D.R D.geometryBound (tupleLocalDepth p e t) := by
  obtain ⟨i, hi⟩ := localCopy_eq_of_positive p e v t
    (((mem_zeroPositiveTuples p e v t).mp ht).2.2)
  unfold tupleLocalLength tupleLocalDepth
  rw [hi]
  rfl

theorem selected_interval_length (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e)) (ht : t ∈ zeroPositiveTuples p e v) :
    tupleBaseline p e t - tupleFinish p e t ≤
      Geometry.lambda D.graph.edges.length D.R D.geometryBound (tupleLocalDepth p e t) +
        Geometry.delta D.graph.edges.length D.R D.geometryBound D.L := by
  have hu := ((mem_zeroPositiveTuples p e v t).mp ht).2.1
  unfold tupleFinish
  rw [tupleGlobalLength_eq_of_unit_false p e t hu, selected_localLength p e v t ht]
  exact completion_zero_global_length_le _ _ _ _ (Geometry.delta_nonneg _ _ _ _)

theorem selected_interval_length_first (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e)) (ht : t ∈ zeroPositiveTuples p e v) :
    tupleBaseline p e t - tupleFinish p e t ≤
      Geometry.lambda D.graph.edges.length D.R D.geometryBound 1 +
        Geometry.delta D.graph.edges.length D.R D.geometryBound D.L := by
  have hu := ((mem_zeroPositiveTuples p e v t).mp ht).2.1
  unfold tupleFinish
  rw [tupleGlobalLength_eq_of_unit_false p e t hu]
  apply le_trans (completion_zero_global_length_le
    (tupleBaseline p e t) (tupleShort p e t) (tupleLocalLength p e t)
    (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L)
    (Geometry.delta_nonneg D.graph.edges.length D.R D.geometryBound D.L))
  exact add_le_add (tupleLocalLength_le_first p e t) le_rfl

end PackingCounts
end BinPackingGap

end

end OAI
end LocalizedSource17
/- END LOCALIZED SOURCE 17/44: OAI/Computability/BinPacking/Packing/PackingCoordinates.lean -/

/- BEGIN LOCALIZED SOURCE 18/44: OAI/Computability/BinPacking/Inventory/InventoryPrefixConservation.lean
   SHA256: f9ea780c40d41a083ece247ae85eaa4660233354087d8b159ed7183bda3aea65 -/
section LocalizedSource18
-- localized import: Mathlib.Basic.Real.Basic
-- localized import: Mathlib.Logic.Embedding.Basic
-- localized import: OAI.Computability.BinPacking.Packing.GoodAnchorBound
-- localized import: OAI.Computability.BinPacking.Packing.PackingCoordinates

namespace OAI

noncomputable section

namespace BinPackingGap

section

open scoped BigOperators

namespace InventoryData

variable (D : InventoryData)

def itemSize (i : D.Item) : ℚ :=
  encodedSize (D.itemSubclass i) (D.itemLabel i) (D.itemCoordinate i)

theorem itemSize_mem_interval (i : D.Item) :
    1 / 6 < D.itemSize i ∧ D.itemSize i < 1 :=
  encodedSize_mem_interval _ _ _ (D.itemCoordinate_abs_le_six i)

theorem itemSize_pos (i : D.Item) : 0 < D.itemSize i :=
  lt_trans (by norm_num) (D.itemSize_mem_interval i).1

theorem itemSize_le_one (i : D.Item) : D.itemSize i ≤ 1 :=
  (D.itemSize_mem_interval i).2.le

def packingInstance : Instance :=
  Instance.ofFintype D.itemSize D.itemSize_pos D.itemSize_le_one

def itemEquiv : D.Item ≃ D.packingInstance.Item := Fintype.equivFin D.Item

def encodedSubclass (i : D.packingInstance.Item) : Subclass :=
  D.itemSubclass (D.itemEquiv.symm i)

def encodedLabel (i : D.packingInstance.Item) : Option D.Vertex :=
  D.itemLabel (D.itemEquiv.symm i)

def encodedCoordinate (i : D.packingInstance.Item) : ℚ :=
  D.itemCoordinate (D.itemEquiv.symm i)

theorem packingInstance_size_eq (i : D.packingInstance.Item) :
    D.packingInstance.size i =
      encodedSize (D.encodedSubclass i) (D.encodedLabel i) (D.encodedCoordinate i) := rfl

theorem encodedCoordinate_abs_le_six (i : D.packingInstance.Item) :
    |D.encodedCoordinate i| ≤ 6 := D.itemCoordinate_abs_le_six _

theorem packingInstance_size_mem_interval (i : D.packingInstance.Item) :
    1 / 6 < D.packingInstance.size i ∧ D.packingInstance.size i < 1 :=
  D.itemSize_mem_interval _

theorem packingInstance_n (hk : D.k ≤ D.graph.n) :
    D.packingInstance.n = 5 * D.B := D.card_item hk

theorem encoded_primaryScore_sum_eq_zero (hk : D.k ≤ D.graph.n) :
    (∑ i : D.packingInstance.Item, primaryScore (D.encodedSubclass i)) = 0 := by
  change (∑ i, primaryScore (D.itemSubclass (D.itemEquiv.symm i))) = 0
  rw [D.itemEquiv.symm.sum_comp (fun i : D.Item => primaryScore (D.itemSubclass i))]
  exact D.total_primaryScore_eq_zero hk

theorem encoded_secondaryScore_sum_eq_zero :
    (∑ i : D.packingInstance.Item,
      secondaryScore (D.encodedSubclass i) (D.encodedLabel i)) = 0 := by
  change (∑ i, secondaryScore (D.itemSubclass (D.itemEquiv.symm i))
    (D.itemLabel (D.itemEquiv.symm i))) = 0
  rw [D.itemEquiv.symm.sum_comp
    (fun i : D.Item => secondaryScore (D.itemSubclass i) (D.itemLabel i))]
  exact D.total_secondaryScore_eq_zero

theorem encoded_labelledRoleCount (r : Role) (v : D.Vertex) :
    labelledRoleCount D.encodedSubclass D.encodedLabel r v =
      labelledRoleCount D.itemSubclass D.itemLabel r v := by
  unfold labelledRoleCount encodedSubclass encodedLabel
  exact D.itemEquiv.symm.sum_comp
    (fun i : D.Item => if (D.itemSubclass i).role = r ∧ D.itemLabel i = some v
      then (1 : ℤ) else 0)

theorem encoded_labelledRoleCount_x (v : D.Vertex) :
    labelledRoleCount D.encodedSubclass D.encodedLabel .x v =
      ((D.t + 2 * D.J v : ℕ) : ℤ) := by
  rw [D.encoded_labelledRoleCount, D.labelledRoleCount_x]

theorem encoded_labelledRoleCount_anchor (v : D.Vertex) :
    labelledRoleCount D.encodedSubclass D.encodedLabel .anchor v =
      ((D.t + 2 * D.J v : ℕ) : ℤ) := by
  rw [D.encoded_labelledRoleCount, D.labelledRoleCount_anchor]

theorem encoded_labelledRoleCount_local (v : D.Vertex) :
    labelledRoleCount D.encodedSubclass D.encodedLabel .«local» v =
      ((D.t + 2 * D.J v : ℕ) : ℤ) := by
  rw [D.encoded_labelledRoleCount, D.labelledRoleCount_local]

theorem itemLabel_some_of_labelled (i : D.Item)
    (h : D.itemRole i = .x ∨ D.itemRole i = .anchor ∨ D.itemRole i = .«local») :
    ∃ v, D.itemLabel i = some v := by
  rcases i with ⟨r, i⟩
  cases r <;> simp only [itemRole] at h
  · exact ⟨i.1, rfl⟩
  · exact ⟨i.1, rfl⟩
  · simp at h
  · exact ⟨i.1, rfl⟩
  · simp at h

theorem itemLabel_none_of_unlabelled (i : D.Item)
    (h : D.itemRole i = .«global» ∨ D.itemRole i = .flag) :
    D.itemLabel i = none := by
  rcases i with ⟨r, i⟩
  cases r <;> simp_all [itemRole, itemLabel]

theorem encodedLabel_some_of_labelled (i : D.packingInstance.Item)
    (h : (D.encodedSubclass i).role = .x ∨ (D.encodedSubclass i).role = .anchor ∨
      (D.encodedSubclass i).role = .«local») :
    ∃ v, D.encodedLabel i = some v := by
  apply D.itemLabel_some_of_labelled (D.itemEquiv.symm i)
  simpa only [encodedSubclass, D.itemSubclass_role] using h

theorem encodedLabel_none_of_unlabelled (i : D.packingInstance.Item)
    (h : (D.encodedSubclass i).role = .«global» ∨ (D.encodedSubclass i).role = .flag) :
    D.encodedLabel i = none := by
  apply D.itemLabel_none_of_unlabelled (D.itemEquiv.symm i)
  simpa only [encodedSubclass, D.itemSubclass_role] using h

end InventoryData

end

namespace InventoryData

open scoped BigOperators

variable (D : InventoryData)

def roleLabelData : RoleLabelData D.encodedSubclass D.encodedLabel :=
  RoleLabelData.of_valid D.encodedSubclass D.encodedLabel
    D.encodedLabel_some_of_labelled D.encodedLabel_none_of_unlabelled

theorem roleLabelData_anchor_row_count (v : D.Vertex) :
    (Finset.univ.filter fun i => D.roleLabelData.anchor i = v).card =
      (Finset.univ.filter fun i => D.roleLabelData.row i = v).card := by
  classical
  have h : ((Finset.univ.filter fun i => D.roleLabelData.anchor i = v).card : ℤ) =
      ((Finset.univ.filter fun i => D.roleLabelData.row i = v).card : ℤ) := by
    rw [D.roleLabelData.anchor_count, D.roleLabelData.row_count,
      D.encoded_labelledRoleCount_anchor, D.encoded_labelledRoleCount_x]
  exact_mod_cast h

theorem roleLabelData_anchor_local_count (v : D.Vertex) :
    (Finset.univ.filter fun i => D.roleLabelData.anchor i = v).card =
      (Finset.univ.filter fun i => D.roleLabelData.localLabel i = v).card := by
  classical
  have h : ((Finset.univ.filter fun i => D.roleLabelData.anchor i = v).card : ℤ) =
      ((Finset.univ.filter fun i => D.roleLabelData.localLabel i = v).card : ℤ) := by
    rw [D.roleLabelData.anchor_count, D.roleLabelData.local_count,
      D.encoded_labelledRoleCount_anchor, D.encoded_labelledRoleCount_local]
  exact_mod_cast h

theorem outsideTableItems_card_lt_lossAllowance {b c : ℕ}
    (hk : D.k ≤ D.graph.n) (p : Packing D.packingInstance b) (hb : b ≤ D.B + c) :
    (p.outsideTableItems D.encodedSubclass).card < lossAllowance c := by
  simpa only [lossAllowance, primaryScoreBound, primaryBound] using
    p.outsideTableItems_card_lt D.encodedSubclass D.encodedLabel D.encodedCoordinate
      D.packingInstance_size_eq D.encodedCoordinate_abs_le_six D.B c
      (D.packingInstance_n hk) hb (D.encoded_primaryScore_sum_eq_zero hk)

theorem badAnchorsAt_card_le {b c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c) (v : D.Vertex) :
    (Coverage.badAnchorsAt p D.encodedSubclass D.encodedLabel v).card ≤
      3 * lossAllowance c := by
  simpa only [lossAllowance, primaryScoreBound, primaryBound] using
    Coverage.badAnchorsAt_card_le p D.encodedSubclass D.encodedLabel D.roleLabelData
      D.encodedCoordinate D.packingInstance_size_eq D.encodedCoordinate_abs_le_six D.B c
      (D.packingInstance_n hk) hb (D.encoded_primaryScore_sum_eq_zero hk)
      D.roleLabelData_anchor_row_count D.roleLabelData_anchor_local_count v

theorem anchor_subset_loss_le {b c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c) (v : D.Vertex)
    (s : Finset D.packingInstance.Item)
    (hs : s ⊆ Coverage.anchorItemsAt D.encodedSubclass D.encodedLabel v) :
    (s \ Coverage.roleItems p D.encodedSubclass
      (Coverage.goodTuplesAt p D.encodedSubclass D.encodedLabel v) .anchor).card ≤
      3 * lossAllowance c := by
  simpa only [lossAllowance, primaryScoreBound, primaryBound] using
    Coverage.anchor_subset_loss_le p D.encodedSubclass D.encodedLabel D.roleLabelData
      D.encodedCoordinate D.packingInstance_size_eq D.encodedCoordinate_abs_le_six D.B c
      (D.packingInstance_n hk) hb (D.encoded_primaryScore_sum_eq_zero hk)
      D.roleLabelData_anchor_row_count D.roleLabelData_anchor_local_count v s hs

theorem badAnchors_global_card_le {b c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c) :
    ((Finset.univ : Finset D.Vertex).biUnion
      (Coverage.badAnchorsAt p D.encodedSubclass D.encodedLabel)).card ≤
      3 * D.graph.n * lossAllowance c := by
  simpa only [lossAllowance, primaryScoreBound, primaryBound] using
    Coverage.badAnchors_global_card_le p D.encodedSubclass D.encodedLabel D.roleLabelData
      D.encodedCoordinate D.packingInstance_size_eq D.encodedCoordinate_abs_le_six D.B c
      (D.packingInstance_n hk) hb (D.encoded_primaryScore_sum_eq_zero hk)
      D.roleLabelData_anchor_row_count D.roleLabelData_anchor_local_count

end InventoryData
end BinPackingGap

namespace BinPackingGap.InventoryData

open scoped BigOperators

variable (D : InventoryData)

def taggedItem (r : Role) : D.RoleCopies r ↪ D.packingInstance.Item :=
  (Function.Embedding.sigmaMk r).trans D.itemEquiv.toEmbedding

@[simp] theorem taggedItem_apply (r : Role) (c : D.RoleCopies r) :
    D.taggedItem r c = D.itemEquiv ⟨r, c⟩ := rfl

def globalCopyEmbedding (s : GlobalSpecies D.graph) :
    Fin (D.globalStock s) ↪ D.packingInstance.Item :=
  (Function.Embedding.sigmaMk s).trans (D.taggedItem .«global»)

def flagCopyEmbedding (s : FlagSpecies) :
    Fin (D.flagStock s) ↪ D.packingInstance.Item :=
  (Function.Embedding.sigmaMk s).trans (D.taggedItem .flag)

@[simp] theorem globalCopyEmbedding_apply (s : GlobalSpecies D.graph)
    (j : Fin (D.globalStock s)) :
    D.globalCopyEmbedding s j = D.itemEquiv ⟨.«global», ⟨s, j⟩⟩ := rfl

@[simp] theorem flagCopyEmbedding_apply (s : FlagSpecies) (j : Fin (D.flagStock s)) :
    D.flagCopyEmbedding s j = D.itemEquiv ⟨.flag, ⟨s, j⟩⟩ := rfl

def physicalGlobalPool (s : GlobalSpecies D.graph) : Finset D.packingInstance.Item :=
  Finset.univ.map (D.globalCopyEmbedding s)

def physicalFlagPool (s : FlagSpecies) : Finset D.packingInstance.Item :=
  Finset.univ.map (D.flagCopyEmbedding s)

def labeledItems : Finset D.packingInstance.Item :=
  Finset.univ.filter (fun i =>
    (D.itemEquiv.symm i).1 = .x ∨ (D.itemEquiv.symm i).1 = .anchor ∨
      (D.itemEquiv.symm i).1 = .«local»)

@[simp] theorem card_physicalGlobalPool (s : GlobalSpecies D.graph) :
    (D.physicalGlobalPool s).card = D.globalStock s := by
  simp [physicalGlobalPool]

@[simp] theorem card_physicalFlagPool (s : FlagSpecies) :
    (D.physicalFlagPool s).card = D.flagStock s := by
  simp [physicalFlagPool]

theorem physicalGlobalPool_nonempty_iff (s : GlobalSpecies D.graph) :
    (D.physicalGlobalPool s).Nonempty ↔ 0 < D.globalStock s := by
  rw [← Finset.card_pos, card_physicalGlobalPool]

theorem physicalFlagPool_nonempty_iff (s : FlagSpecies) :
    (D.physicalFlagPool s).Nonempty ↔ 0 < D.flagStock s := by
  rw [← Finset.card_pos, card_physicalFlagPool]

theorem mem_physicalGlobalPool (s : GlobalSpecies D.graph) (i : D.packingInstance.Item) :
    i ∈ D.physicalGlobalPool s ↔
      ∃ j : Fin (D.globalStock s), D.itemEquiv ⟨.«global», ⟨s, j⟩⟩ = i := by
  simp only [physicalGlobalPool, Finset.mem_map, Finset.mem_univ, true_and,
    globalCopyEmbedding_apply]

theorem mem_physicalFlagPool (s : FlagSpecies) (i : D.packingInstance.Item) :
    i ∈ D.physicalFlagPool s ↔
      ∃ j : Fin (D.flagStock s), D.itemEquiv ⟨.flag, ⟨s, j⟩⟩ = i := by
  simp only [physicalFlagPool, Finset.mem_map, Finset.mem_univ, true_and,
    flagCopyEmbedding_apply]

theorem itemEquiv_mem_physicalGlobalPool_iff (a : D.Item) (s : GlobalSpecies D.graph) :
    D.itemEquiv a ∈ D.physicalGlobalPool s ↔
      ∃ j : Fin (D.globalStock s), a = ⟨.«global», ⟨s, j⟩⟩ := by
  rw [mem_physicalGlobalPool]
  constructor
  · rintro ⟨j, hj⟩
    exact ⟨j, (D.itemEquiv.injective hj).symm⟩
  · rintro ⟨j, rfl⟩
    exact ⟨j, rfl⟩

theorem itemEquiv_mem_physicalFlagPool_iff (a : D.Item) (s : FlagSpecies) :
    D.itemEquiv a ∈ D.physicalFlagPool s ↔
      ∃ j : Fin (D.flagStock s), a = ⟨.flag, ⟨s, j⟩⟩ := by
  rw [mem_physicalFlagPool]
  constructor
  · rintro ⟨j, hj⟩
    exact ⟨j, (D.itemEquiv.injective hj).symm⟩
  · rintro ⟨j, rfl⟩
    exact ⟨j, rfl⟩

@[simp] theorem mem_labeledItems (i : D.packingInstance.Item) :
    i ∈ D.labeledItems ↔
      (D.itemEquiv.symm i).1 = .x ∨ (D.itemEquiv.symm i).1 = .anchor ∨
        (D.itemEquiv.symm i).1 = .«local» := by
  simp [labeledItems]

@[simp] theorem itemEquiv_mem_labeledItems (r : Role) (c : D.RoleCopies r) :
    D.itemEquiv ⟨r, c⟩ ∈ D.labeledItems ↔
      r = .x ∨ r = .anchor ∨ r = .«local» := by
  simp only [mem_labeledItems, Equiv.symm_apply_apply]

@[simp] theorem globalItem_mem_physicalGlobalPool (s t : GlobalSpecies D.graph)
    (j : Fin (D.globalStock s)) :
    D.itemEquiv ⟨.«global», ⟨s, j⟩⟩ ∈ D.physicalGlobalPool t ↔ s = t := by
  rw [itemEquiv_mem_physicalGlobalPool_iff]
  constructor
  · rintro ⟨q, hq⟩
    have hcopy : (⟨s, j⟩ : D.GlobalCopy) = ⟨t, q⟩ :=
      sigma_mk_injective (β := D.RoleCopies) (i := Role.«global») hq
    exact congrArg Sigma.fst hcopy
  · intro h
    subst t
    exact ⟨j, rfl⟩

@[simp] theorem flagItem_mem_physicalFlagPool (s t : FlagSpecies)
    (j : Fin (D.flagStock s)) :
    D.itemEquiv ⟨.flag, ⟨s, j⟩⟩ ∈ D.physicalFlagPool t ↔ s = t := by
  rw [itemEquiv_mem_physicalFlagPool_iff]
  constructor
  · rintro ⟨q, hq⟩
    have hcopy : (⟨s, j⟩ : D.FlagCopy) = ⟨t, q⟩ :=
      sigma_mk_injective (β := D.RoleCopies) (i := Role.flag) hq
    exact congrArg Sigma.fst hcopy
  · intro h
    subst t
    exact ⟨j, rfl⟩

theorem role_eq_global_of_mem_physicalGlobalPool (s : GlobalSpecies D.graph)
    {i : D.packingInstance.Item} (hi : i ∈ D.physicalGlobalPool s) :
    (D.itemEquiv.symm i).1 = .«global» := by
  obtain ⟨j, rfl⟩ := (D.mem_physicalGlobalPool s i).mp hi
  simp only [Equiv.symm_apply_apply]

theorem role_eq_flag_of_mem_physicalFlagPool (s : FlagSpecies)
    {i : D.packingInstance.Item} (hi : i ∈ D.physicalFlagPool s) :
    (D.itemEquiv.symm i).1 = .flag := by
  obtain ⟨j, rfl⟩ := (D.mem_physicalFlagPool s i).mp hi
  simp only [Equiv.symm_apply_apply]

theorem physicalGlobalPool_disjoint {s t : GlobalSpecies D.graph} (hst : s ≠ t) :
    Disjoint (D.physicalGlobalPool s) (D.physicalGlobalPool t) := by
  apply Finset.disjoint_left.mpr
  intro i hi ht
  obtain ⟨j, rfl⟩ := (D.mem_physicalGlobalPool s i).mp hi
  exact hst ((D.globalItem_mem_physicalGlobalPool s t j).mp ht)

theorem physicalFlagPool_disjoint {s t : FlagSpecies} (hst : s ≠ t) :
    Disjoint (D.physicalFlagPool s) (D.physicalFlagPool t) := by
  apply Finset.disjoint_left.mpr
  intro i hi ht
  obtain ⟨j, rfl⟩ := (D.mem_physicalFlagPool s i).mp hi
  exact hst ((D.flagItem_mem_physicalFlagPool s t j).mp ht)

theorem physicalGlobalPool_disjoint_physicalFlagPool
    (s : GlobalSpecies D.graph) (t : FlagSpecies) :
    Disjoint (D.physicalGlobalPool s) (D.physicalFlagPool t) := by
  apply Finset.disjoint_left.mpr
  intro i hi ht
  have h := (D.role_eq_global_of_mem_physicalGlobalPool s hi).symm.trans
    (D.role_eq_flag_of_mem_physicalFlagPool t ht)
  cases h

theorem labeledItems_disjoint_physicalGlobalPool (s : GlobalSpecies D.graph) :
    Disjoint D.labeledItems (D.physicalGlobalPool s) := by
  apply Finset.disjoint_left.mpr
  intro i hi hg
  have hr := D.role_eq_global_of_mem_physicalGlobalPool s hg
  have hl := (D.mem_labeledItems i).mp hi
  simp [hr] at hl

theorem labeledItems_disjoint_physicalFlagPool (s : FlagSpecies) :
    Disjoint D.labeledItems (D.physicalFlagPool s) := by
  apply Finset.disjoint_left.mpr
  intro i hi hf
  have hr := D.role_eq_flag_of_mem_physicalFlagPool s hf
  have hl := (D.mem_labeledItems i).mp hi
  simp [hr] at hl

private theorem not_mem_physicalGlobalPool_of_role_ne (r : Role) (c : D.RoleCopies r)
    (s : GlobalSpecies D.graph) (hr : r ≠ .«global») :
    D.itemEquiv ⟨r, c⟩ ∉ D.physicalGlobalPool s := by
  intro hi
  have h := D.role_eq_global_of_mem_physicalGlobalPool s hi
  exact hr (by simpa only [Equiv.symm_apply_apply] using h)

private theorem not_mem_physicalFlagPool_of_role_ne (r : Role) (c : D.RoleCopies r)
    (s : FlagSpecies) (hr : r ≠ .flag) :
    D.itemEquiv ⟨r, c⟩ ∉ D.physicalFlagPool s := by
  intro hi
  have h := D.role_eq_flag_of_mem_physicalFlagPool s hi
  exact hr (by simpa only [Equiv.symm_apply_apply] using h)

theorem physicalInventory_indicator_partition (i : D.packingInstance.Item) :
    (if i ∈ D.labeledItems then (1 : ℝ) else 0) +
      (∑ s, if i ∈ D.physicalGlobalPool s then (1 : ℝ) else 0) +
      (∑ s, if i ∈ D.physicalFlagPool s then (1 : ℝ) else 0) = 1 := by
  classical
  obtain ⟨⟨r, c⟩, rfl⟩ := D.itemEquiv.surjective i
  cases r with
  | x =>
    simp [not_mem_physicalGlobalPool_of_role_ne, not_mem_physicalFlagPool_of_role_ne]
  | anchor =>
    simp [not_mem_physicalGlobalPool_of_role_ne, not_mem_physicalFlagPool_of_role_ne]
  | «global» =>
    rcases c with ⟨s, j⟩
    have hflag : ∀ t : FlagSpecies,
        D.itemEquiv ⟨.«global», ⟨s, j⟩⟩ ∉ D.physicalFlagPool t := fun t =>
      not_mem_physicalFlagPool_of_role_ne D .«global» ⟨s, j⟩ t (by decide)
    simp [hflag]
  | «local» =>
    simp [not_mem_physicalGlobalPool_of_role_ne, not_mem_physicalFlagPool_of_role_ne]
  | flag =>
    rcases c with ⟨s, j⟩
    have hglobal : ∀ t : GlobalSpecies D.graph,
        D.itemEquiv ⟨.flag, ⟨s, j⟩⟩ ∉ D.physicalGlobalPool t := fun t =>
      not_mem_physicalGlobalPool_of_role_ne D .flag ⟨s, j⟩ t (by decide)
    simp [hglobal]

end BinPackingGap.InventoryData

namespace BinPackingGap
namespace InventoryData

variable (D : InventoryData) {b : ℕ}

def rowPrefixExports (p : Packing D.packingInstance b) (h : ℕ) :=
  LabelConservation.exports D.roleLabelData.anchor D.roleLabelData.row
    (p.roleItemAt D.encodedSubclass .anchor) (p.roleItemAt D.encodedSubclass .x) h

def localPrefixExports (p : Packing D.packingInstance b) (h : ℕ) :=
  LabelConservation.exports D.roleLabelData.anchor D.roleLabelData.localLabel
    (p.roleItemAt D.encodedSubclass .anchor) (p.roleItemAt D.encodedSubclass .«local») h

def outsideAnchorPrefix (p : Packing D.packingInstance b) (h : ℕ) :=
  LabelConservation.prefixOutside D.roleLabelData.anchor
    (p.roleItemAt D.encodedSubclass .anchor) h

def outsideRowPrefix (p : Packing D.packingInstance b) (h : ℕ) :=
  LabelConservation.prefixOutside D.roleLabelData.row
    (p.roleItemAt D.encodedSubclass .x) h

def outsideLocalPrefix (p : Packing D.packingInstance b) (h : ℕ) :=
  LabelConservation.prefixOutside D.roleLabelData.localLabel
    (p.roleItemAt D.encodedSubclass .«local») h

theorem rowPrefixExports_add_outsideRow_eq (p : Packing D.packingInstance b) (h : ℕ) :
    (D.rowPrefixExports p h).card + (D.outsideRowPrefix p h).card =
      (D.outsideAnchorPrefix p h).card := by
  apply LabelConservation.exports_add_outsideRole_eq_outsideAnchor
    D.roleLabelData.anchor D.roleLabelData.row
    (p.roleItemAt D.encodedSubclass .anchor) (p.roleItemAt D.encodedSubclass .x)
    (p.roleItemAt_injective D.encodedSubclass .anchor)
    (p.roleItemAt_injective D.encodedSubclass .x)
  · intro t
    exact (p.roleItemAt_labels_le D.encodedSubclass D.encodedLabel D.roleLabelData
      D.encodedCoordinate D.packingInstance_size_eq D.encodedCoordinate_abs_le_six t).1
  · exact D.roleLabelData_anchor_row_count

theorem localPrefixExports_add_outsideLocal_eq (p : Packing D.packingInstance b) (h : ℕ) :
    (D.localPrefixExports p h).card + (D.outsideLocalPrefix p h).card =
      (D.outsideAnchorPrefix p h).card := by
  apply LabelConservation.exports_add_outsideRole_eq_outsideAnchor
    D.roleLabelData.anchor D.roleLabelData.localLabel
    (p.roleItemAt D.encodedSubclass .anchor) (p.roleItemAt D.encodedSubclass .«local»)
    (p.roleItemAt_injective D.encodedSubclass .anchor)
    (p.roleItemAt_injective D.encodedSubclass .«local»)
  · intro t
    exact (p.roleItemAt_labels_le D.encodedSubclass D.encodedLabel D.roleLabelData
      D.encodedCoordinate D.packingInstance_size_eq D.encodedCoordinate_abs_le_six t).2
  · exact D.roleLabelData_anchor_local_count

theorem rowPrefixExports_eq_outside_sub (p : Packing D.packingInstance b) (h : ℕ) :
    ((D.rowPrefixExports p h).card : ℤ) =
      (D.outsideAnchorPrefix p h).card - (D.outsideRowPrefix p h).card := by
  have heq := D.rowPrefixExports_add_outsideRow_eq p h
  omega

theorem localPrefixExports_eq_outside_sub (p : Packing D.packingInstance b) (h : ℕ) :
    ((D.localPrefixExports p h).card : ℤ) =
      (D.outsideAnchorPrefix p h).card - (D.outsideLocalPrefix p h).card := by
  have heq := D.localPrefixExports_add_outsideLocal_eq p h
  omega

theorem rowPrefixExports_card_lt_lossAllowance {c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c) (h : ℕ) :
    (D.rowPrefixExports p h).card < lossAllowance c := by
  have heq := D.rowPrefixExports_add_outsideRow_eq p h
  have hprefix : (D.outsideAnchorPrefix p h).card ≤
      (LabelConservation.outsideItems (p.roleItemAt D.encodedSubclass .anchor)).card :=
    Finset.card_le_card (Finset.filter_subset _ _)
  have hout := (p.outside_roleItems_card_le D.encodedSubclass .anchor).trans_lt
    (D.outsideTableItems_card_lt_lossAllowance hk p hb)
  omega

theorem localPrefixExports_card_lt_lossAllowance {c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c) (h : ℕ) :
    (D.localPrefixExports p h).card < lossAllowance c := by
  have heq := D.localPrefixExports_add_outsideLocal_eq p h
  have hprefix : (D.outsideAnchorPrefix p h).card ≤
      (LabelConservation.outsideItems (p.roleItemAt D.encodedSubclass .anchor)).card :=
    Finset.card_le_card (Finset.filter_subset _ _)
  have hout := (p.outside_roleItems_card_le D.encodedSubclass .anchor).trans_lt
    (D.outsideTableItems_card_lt_lossAllowance hk p hb)
  omega

end InventoryData
end BinPackingGap

end

end OAI
end LocalizedSource18
/- END LOCALIZED SOURCE 18/44: OAI/Computability/BinPacking/Inventory/InventoryPrefixConservation.lean -/

/- BEGIN LOCALIZED SOURCE 19/44: OAI/Computability/BinPacking/Inventory/InventoryCoverage.lean
   SHA256: addd78589e02b090ad2dcf6d4af6201716fc46508a2bdf07ccb4127b103ed893 -/
section LocalizedSource19
-- localized import: Mathlib.Algebra.BigOperators.Ring.Finset
-- localized import: OAI.Computability.BinPacking.Packing.PackingCoordinates

namespace OAI

noncomputable section
open scoped BigOperators

namespace BinPackingGap
namespace InventoryCoverage

variable {D : InventoryData} {I : Instance} {b : ℕ}

def itemRowBaseline (D : InventoryData) : D.Item → ℚ
  | ⟨.x, ⟨_, r⟩⟩ => D.rowBaseline r
  | _ => 0

def itemRowShort (D : InventoryData) : D.Item → Bool
  | ⟨.x, ⟨_, r⟩⟩ => D.rowShort r
  | _ => false

def itemKeyBaseline (D : InventoryData) : D.Item → ℚ
  | ⟨.anchor, ⟨_, .inr j⟩⟩ => Geometry.baseline D.graph.edges.length D.R (D.jobPosition j)
  | _ => 0

def itemDeadline (D : InventoryData) : D.Item → ℚ
  | ⟨.anchor, ⟨_, .inl z⟩⟩ => D.deadline z
  | _ => 0

def rowBaseline (e : D.Item ≃ I.Item) : I.Item → ℚ := itemRowBaseline D ∘ e.symm

def rowShort (e : D.Item ≃ I.Item) : I.Item → Bool := itemRowShort D ∘ e.symm

def keyBaseline (e : D.Item ≃ I.Item) : I.Item → ℚ := itemKeyBaseline D ∘ e.symm

def anchorDeadline (e : D.Item ≃ I.Item) : I.Item → ℚ := itemDeadline D ∘ e.symm

@[simp] theorem rowBaseline_selected (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (PackingCounts.subclass e)) :
    rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x) =
      D.rowBaseline (PackingCounts.rowCopy p e t).2 := by
  rw [← PackingCounts.roleCopy_item p e t .x]
  change itemRowBaseline D (e.symm (e ⟨.x, PackingCounts.rowCopy p e t⟩)) = _
  rw [e.symm_apply_apply]
  rfl

@[simp] theorem rowShort_selected (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (PackingCounts.subclass e)) :
    rowShort e (p.itemAtRole (PackingCounts.subclass e) t .x) =
      D.rowShort (PackingCounts.rowCopy p e t).2 := by
  rw [← PackingCounts.roleCopy_item p e t .x]
  change itemRowShort D (e.symm (e ⟨.x, PackingCounts.rowCopy p e t⟩)) = _
  rw [e.symm_apply_apply]
  rfl

theorem keyBaseline_selected_of_key (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (PackingCounts.subclass e)) (v : D.Vertex) (j : D.JobCopy v)
    (hcopy : PackingCounts.anchorCopy p e t = ⟨v, .inr j⟩) :
    keyBaseline e (p.itemAtRole (PackingCounts.subclass e) t .anchor) =
      Geometry.baseline D.graph.edges.length D.R (D.jobPosition j) := by
  rw [← PackingCounts.roleCopy_item p e t .anchor]
  change itemKeyBaseline D (e.symm (e ⟨.anchor, PackingCounts.anchorCopy p e t⟩)) = _
  rw [e.symm_apply_apply, hcopy]
  rfl

theorem anchorDeadline_selected_of_deadline (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (PackingCounts.subclass e)) (v : D.Vertex) (z : D.MBase v)
    (hcopy : PackingCounts.anchorCopy p e t = ⟨v, .inl z⟩) :
    anchorDeadline e (p.itemAtRole (PackingCounts.subclass e) t .anchor) = D.deadline z := by
  rw [← PackingCounts.roleCopy_item p e t .anchor]
  change itemDeadline D (e.symm (e ⟨.anchor, PackingCounts.anchorCopy p e t⟩)) = _
  rw [e.symm_apply_apply, hcopy]
  rfl

theorem rowShort_implies_job (e : D.Item ≃ I.Item) (i : I.Item)
    (h : rowShort e i = true) : PackingCounts.subclass e i = .s := by
  let x := e.symm i
  change itemRowShort D x = true at h
  change D.itemSubclass x = .s
  rcases x with ⟨role, copy⟩
  cases role with
  | x =>
      rcases copy with ⟨v, tree | ⟨short, job⟩⟩
      · cases h
      · rfl
  | anchor => cases h
  | «global» => cases h
  | «local» => cases h
  | flag => cases h

private theorem treeSubclass_ne_s (t : D.TreeRow) : D.treeSubclass t ≠ .s := by
  rcases t with p | (m | pad) <;> simp [InventoryData.treeSubclass]

private theorem treeSubclass_tree (t : D.TreeRow) :
    D.treeSubclass t = .tp ∨ D.treeSubclass t = .tm := by
  rcases t with p | (m | pad)
  · exact Or.inl rfl
  · exact Or.inr rfl
  · exact Or.inl rfl

def treePrefix (D : InventoryData) (a : ℚ) : Finset D.TreeRow :=
  Finset.univ.filter fun r => D.treeBaseline r ≤ a

def jobPrefix (D : InventoryData) (v : D.Vertex) (a : ℚ) : Finset (D.JobCopy v) :=
  Finset.univ.filter fun j => Geometry.baseline D.graph.edges.length D.R (D.jobPosition j) ≤ a

def originalBaselinePrefix (D : InventoryData) (v : D.Vertex) (a : ℚ) :
    Finset (D.MBase v) := Finset.univ.filter fun z => D.mainBaseline z ≤ a

def jobsAt (D : InventoryData) (v : D.Vertex) (current : ℚ) : Finset (D.JobCopy v) :=
  Finset.univ.filter fun j =>
    Geometry.baseline D.graph.edges.length D.R (D.jobPosition j) = current

private theorem card_filter_transport {α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β] (e : α ≃ β) (P : β → Prop) [DecidablePred P] :
    (Finset.univ.filter P).card = (Finset.univ.filter fun x => P (e x)).card := by
  exact (Finset.card_bijective (s := Finset.univ.filter fun x => P (e x))
    (t := Finset.univ.filter P) e e.bijective (fun _ => by simp)).symm

set_option backward.isDefEq.respectTransparency false in
theorem jobRowPrefix_card (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ) :
    (Coverage.jobRowPrefixAt (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) a).card = 2 * (jobPrefix D v a).card := by
  classical
  unfold Coverage.jobRowPrefixAt
  rw [card_filter_transport e]
  simp only [jobPrefix, Finset.card_eq_sum_ones, Finset.sum_filter]
  simp [ite_and, -Finset.sum_boole, PackingCounts.subclass, PackingCounts.label, rowBaseline, itemRowBaseline,
    InventoryData.itemSubclass, InventoryData.itemLabel, InventoryData.RoleCopies,
    InventoryData.rowSubclass, InventoryData.rowBaseline, treeSubclass_ne_s,
    Fintype.sum_sigma,
    Role.sum_univ, Fintype.sum_sum_type, Fintype.sum_prod_type, two_mul]

set_option backward.isDefEq.respectTransparency false in
theorem treeRowPrefix_card (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ) :
    (Coverage.treeRowPrefixAt (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) a).card = (treePrefix D a).card := by
  classical
  unfold Coverage.treeRowPrefixAt
  rw [card_filter_transport e]
  simp only [treePrefix, Finset.card_eq_sum_ones, Finset.sum_filter]
  simp [ite_and, -Finset.sum_boole, PackingCounts.subclass, PackingCounts.label, rowBaseline, itemRowBaseline,
    InventoryData.itemSubclass, InventoryData.itemLabel, InventoryData.RoleCopies,
    InventoryData.rowSubclass, InventoryData.rowBaseline, treeSubclass_tree,
    Fintype.sum_sigma,
    Role.sum_univ, Fintype.sum_sum_type, Fintype.sum_prod_type]

set_option backward.isDefEq.respectTransparency false in
theorem keyPrefix_card (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ) :
    (Coverage.keyPrefixAt (PackingCounts.subclass e) (PackingCounts.label e) v
      (keyBaseline e) a).card = (jobPrefix D v a).card := by
  classical
  unfold Coverage.keyPrefixAt
  rw [card_filter_transport e]
  simp only [jobPrefix, Finset.card_eq_sum_ones, Finset.sum_filter]
  simp [ite_and, -Finset.sum_boole, PackingCounts.subclass, PackingCounts.label, keyBaseline, itemKeyBaseline,
    InventoryData.itemSubclass, InventoryData.itemLabel, InventoryData.RoleCopies,
    InventoryData.rowSubclass, InventoryData.treeSubclass, InventoryData.TreeRow,
    Fintype.sum_sigma,
    Role.sum_univ, Fintype.sum_sum_type, Fintype.sum_prod_type]

set_option backward.isDefEq.respectTransparency false in
theorem deadlinePrefix_card (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ) :
    (Coverage.deadlinePrefixAt (PackingCounts.subclass e) (PackingCounts.label e) v
      (anchorDeadline e) a).card =
      (Finset.univ.filter fun z : D.MBase v => D.deadline z ≤ a).card := by
  classical
  unfold Coverage.deadlinePrefixAt
  rw [card_filter_transport e]
  simp only [Finset.card_eq_sum_ones, Finset.sum_filter]
  simp [ite_and, -Finset.sum_boole, PackingCounts.subclass, PackingCounts.label, anchorDeadline, itemDeadline,
    InventoryData.itemSubclass, InventoryData.itemLabel, InventoryData.RoleCopies,
    InventoryData.rowSubclass, InventoryData.treeSubclass, InventoryData.TreeRow,
    Fintype.sum_sigma,
    Role.sum_univ, Fintype.sum_sum_type, Fintype.sum_prod_type]

theorem originalBaselinePrefix_card (D : InventoryData) (v : D.Vertex) (a : ℚ) :
    (originalBaselinePrefix D v a).card = (treePrefix D a).card + (jobPrefix D v a).card := by
  classical
  have hsplit : originalBaselinePrefix D v a =
      (treePrefix D a).disjSum (jobPrefix D v a) := by
    ext z
    cases z <;>
      simp only [originalBaselinePrefix, treePrefix, jobPrefix, Finset.mem_filter,
        Finset.mem_univ, Finset.inl_mem_disjSum, Finset.inr_mem_disjSum, true_and] <;>
      rfl
  rw [hsplit, Finset.card_disjSum]

set_option backward.isDefEq.respectTransparency false in
theorem currentKeyItems_card (e : D.Item ≃ I.Item) (v : D.Vertex) (current : ℚ) :
    (Coverage.currentKeyItemsAt (PackingCounts.subclass e) (PackingCounts.label e) v
      (keyBaseline e) current).card = (jobsAt D v current).card := by
  classical
  unfold Coverage.currentKeyItemsAt
  rw [card_filter_transport e]
  simp only [jobsAt, Finset.card_eq_sum_ones, Finset.sum_filter]
  simp [ite_and, -Finset.sum_boole, PackingCounts.subclass, PackingCounts.label, keyBaseline, itemKeyBaseline,
    InventoryData.itemSubclass, InventoryData.itemLabel, InventoryData.RoleCopies,
    InventoryData.rowSubclass, InventoryData.treeSubclass, InventoryData.TreeRow,
    Fintype.sum_sigma,
    Role.sum_univ, Fintype.sum_sum_type, Fintype.sum_prod_type]

set_option backward.isDefEq.respectTransparency false in
theorem currentShortItems_card (e : D.Item ≃ I.Item) (v : D.Vertex) (current : ℚ) :
    (Coverage.currentShortItemsAt (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) (rowShort e) current).card = (jobsAt D v current).card := by
  classical
  unfold Coverage.currentShortItemsAt
  rw [card_filter_transport e]
  simp only [jobsAt, Finset.card_eq_sum_ones, Finset.sum_filter]
  simp [ite_and, -Finset.sum_boole, PackingCounts.subclass, PackingCounts.label, rowBaseline, rowShort,
    itemRowBaseline, itemRowShort, InventoryData.itemSubclass, InventoryData.itemLabel,
    InventoryData.RoleCopies, InventoryData.rowSubclass, InventoryData.rowBaseline,
    InventoryData.rowShort, treeSubclass_ne_s,
    Fintype.sum_sigma,
    Role.sum_univ, Fintype.sum_sum_type, Fintype.sum_prod_type]

def positionOf (D : InventoryData) {v : D.Vertex} (r : D.IncidencePosition v) : D.Position :=
  D.incidencePosition r

theorem positionOf_injective (D : InventoryData) (v : D.Vertex) :
    Function.Injective (positionOf D (v := v)) :=
  D.incidencePosition_injective v

theorem job_baseline_eq_iff (D : InventoryData) (v : D.Vertex)
    (j : D.JobCopy v) (r : D.IncidencePosition v) :
    Geometry.baseline D.graph.edges.length D.R (D.jobPosition j) =
      Geometry.baseline D.graph.edges.length D.R (positionOf D r) ↔ j.1 = r := by
  rw [Geometry.baseline_eq_iff]
  change positionOf D j.1 = positionOf D r ↔ j.1 = r
  exact (positionOf_injective D v).eq_iff

theorem jobsAt_position_card (D : InventoryData) (v : D.Vertex)
    (r : D.IncidencePosition v) :
    (jobsAt D v (Geometry.baseline D.graph.edges.length D.R (positionOf D r))).card = D.d := by
  classical
  have heq : jobsAt D v (Geometry.baseline D.graph.edges.length D.R (positionOf D r)) =
      ({r} : Finset (D.IncidencePosition v)).product (Finset.univ : Finset (Fin D.d)) := by
    ext ⟨s, j⟩
    simp only [jobsAt, Finset.mem_filter, Finset.mem_univ, true_and,
      Finset.product_eq_sprod, Finset.mem_product, Finset.mem_singleton, and_true]
    exact job_baseline_eq_iff D v (s, j) r
  rw [heq]
  simp

theorem actual_displaced_baseline_prefix_le
    (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ)
    (extra : Finset (p.TableBin (PackingCounts.subclass e))) (K : ℕ)
    (hbad : (Coverage.badAnchorsAt p (PackingCounts.subclass e) (PackingCounts.label e) v).card ≤ 3 * K)
    (horder : ∀ t ∈ Coverage.edgeTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v,
      rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x) ≤
        keyBaseline e (p.itemAtRole (PackingCounts.subclass e) t .anchor))
    (hextra : extra ⊆ Coverage.edgeTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v)
    (hextraRows : ∀ t ∈ extra, rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x) ≤ a)
    (hextraDis : Disjoint
      (Coverage.edgePrefixAt p (PackingCounts.subclass e) (PackingCounts.label e) v
        (keyBaseline e) a) extra) :
    (Coverage.baselinePrefixAt p (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) a).card + extra.card ≤ (originalBaselinePrefix D v a).card + 3 * K := by
  apply Coverage.displaced_baseline_prefix_le p (PackingCounts.subclass e) (PackingCounts.label e) v
    (rowBaseline e) (keyBaseline e) a extra (originalBaselinePrefix D v a).card
    (jobPrefix D v a).card K hbad horder hextra hextraRows hextraDis
  · exact jobRowPrefix_card e v a
  · exact keyPrefix_card e v a
  · rw [treeRowPrefix_card, originalBaselinePrefix_card]

private theorem exists_job_of_subclass_s (D : InventoryData) (i : D.Item)
    (h : D.itemSubclass i = .s) :
    ∃ v : D.Vertex, ∃ short : Bool, ∃ j : D.JobCopy v,
      i = ⟨.x, ⟨v, .inr (short, j)⟩⟩ := by
  have hr : i.1 = .x := by
    change D.itemRole i = .x
    rw [← D.itemSubclass_role, h]
    rfl
  rcases i with ⟨role, copy⟩
  dsimp at hr
  subst role
  rcases copy with ⟨v, tree | ⟨short, job⟩⟩
  · exact False.elim (treeSubclass_ne_s tree h)
  · exact ⟨v, short, job, rfl⟩

theorem row_before_current_le_interior (e : D.Item ≃ I.Item) (i : I.Item)
    (hcls : PackingCounts.subclass e i = .s) {v : D.Vertex}
    (r : D.IncidencePosition v)
    (hearlier : rowBaseline e i <
      Geometry.baseline D.graph.edges.length D.R (positionOf D r)) :
    rowBaseline e i ≤
      Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L (positionOf D r) := by
  obtain ⟨w, short, j, hj⟩ := exists_job_of_subclass_s D (e.symm i) hcls
  have hbase : rowBaseline e i =
      Geometry.baseline D.graph.edges.length D.R (D.jobPosition j) := by
    change itemRowBaseline D (e.symm i) = _
    rw [hj]
    rfl
  rw [hbase] at hearlier ⊢
  exact (Geometry.baseline_le_jobInterior D.geometryBound D.L).mpr
    (Geometry.baseline_lt_iff.mp hearlier)

theorem actual_displaced_job_prefix_le
    (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex)
    (r : D.IncidencePosition v) (K : ℕ)
    (hbad : (Coverage.badAnchorsAt p (PackingCounts.subclass e) (PackingCounts.label e) v).card ≤ 3 * K)
    (horder : ∀ t ∈ Coverage.edgeTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v,
      rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x) ≤
        keyBaseline e (p.itemAtRole (PackingCounts.subclass e) t .anchor)) :
    (Coverage.baselinePrefixAt p (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e)
      (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L (positionOf D r))).card +
    (Coverage.displacedTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) (keyBaseline e)
      (Geometry.baseline D.graph.edges.length D.R (positionOf D r))).card ≤
    (originalBaselinePrefix D v
      (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L (positionOf D r))).card +
      3 * K := by
  classical
  apply actual_displaced_baseline_prefix_le p e v _ _ K hbad horder
  · intro t ht
    exact (Finset.mem_filter.mp (Finset.mem_filter.mp ht).1).1
  · intro t ht
    obtain ⟨ht, hbefore⟩ := Finset.mem_filter.mp ht
    obtain ⟨ht, _⟩ := Finset.mem_filter.mp ht
    have hpat := ((Coverage.mem_edgeTuplesAt p (PackingCounts.subclass e)
      (PackingCounts.label e) v t).mp ht).2.2
    apply row_before_current_le_interior e _ _ r hbefore
    rw [p.itemAtRole_subclass (PackingCounts.subclass e) t .x, hpat]
    rfl
  · apply Finset.disjoint_left.mpr
    intro t hearly hcurrent
    have hle := (Finset.mem_filter.mp hearly).2
    have heq := (Finset.mem_filter.mp (Finset.mem_filter.mp hcurrent).1).2
    rw [heq] at hle
    have hcut := (Geometry.jobInterior_mem_jobTestInterval D.graph.edges.length D.R
      D.geometryBound D.L (positionOf D r)).2
    exact (not_lt_of_ge hle) hcut

theorem actual_deadline_deficit_bound
    (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) (a : ℚ) (K : ℕ)
    (finish : p.TableBin (PackingCounts.subclass e) → ℚ)
    (hbad : (Coverage.badAnchorsAt p (PackingCounts.subclass e) (PackingCounts.label e) v).card ≤ 3 * K)
    (horder : ∀ t ∈ Coverage.edgeTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v,
      rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x) ≤
        keyBaseline e (p.itemAtRole (PackingCounts.subclass e) t .anchor))
    (hle : ∀ t ∈ Coverage.mainTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v,
      finish t ≤ rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x))
    (hfeasible : ∀ t ∈ Coverage.mainTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v,
      finish t ≤ anchorDeadline e (p.itemAtRole (PackingCounts.subclass e) t .anchor)) :
    (Finset.univ.filter fun z : D.MBase v => D.deadline z ≤ a).card ≤
      (originalBaselinePrefix D v a).card +
      (Coverage.coveringTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v
        (rowBaseline e) finish a).card + 6 * K := by
  classical
  have hbase := actual_displaced_baseline_prefix_le p e v a ∅ K hbad horder
    (Finset.empty_subset _) (by simp) (by simp)
  simp only [Finset.card_empty, Nat.add_zero] at hbase
  have hdeadline := Coverage.deadline_prefix_le_completion_add_loss p
    (PackingCounts.subclass e) (PackingCounts.label e) v (anchorDeadline e) finish a K
    hbad hfeasible
  rw [deadlinePrefix_card] at hdeadline
  have hsplit := Coverage.completion_prefix_decomposition p (PackingCounts.subclass e)
    (PackingCounts.label e) v (rowBaseline e) finish hle a
  omega

theorem actual_current_long_matches_from_correction
    (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex)
    (r : D.IncidencePosition v) (K xplus : ℕ)
    (hbad : (Coverage.badAnchorsAt p (PackingCounts.subclass e) (PackingCounts.label e) v).card ≤ 3 * K)
    (horder : ∀ t ∈ Coverage.edgeTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v,
      rowBaseline e (p.itemAtRole (PackingCounts.subclass e) t .x) ≤
        keyBaseline e (p.itemAtRole (PackingCounts.subclass e) t .anchor))
    (hcorrection : D.d + (Coverage.displacedTuplesAt p (PackingCounts.subclass e)
        (PackingCounts.label e) v (rowBaseline e) (keyBaseline e)
        (Geometry.baseline D.graph.edges.length D.R (positionOf D r))).card ≤
      xplus + (Coverage.currentShortMainAt p (PackingCounts.subclass e)
        (PackingCounts.label e) v (rowBaseline e) (rowShort e)
        (Geometry.baseline D.graph.edges.length D.R (positionOf D r))).card + 6 * K) :
    D.d ≤ (Coverage.currentLongEdgeAt p (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) (keyBaseline e) (rowShort e)
      (Geometry.baseline D.graph.edges.length D.R (positionOf D r))).card + xplus + 9 * K := by
  apply Coverage.current_long_matches_from_correction p (PackingCounts.subclass e)
    (PackingCounts.label e) v (rowBaseline e) (keyBaseline e) (rowShort e)
    (Geometry.baseline D.graph.edges.length D.R (positionOf D r)) D.d K xplus
    hbad horder (rowShort_implies_job e) _ _ hcorrection
  · rw [currentKeyItems_card, jobsAt_position_card]
  · rw [currentShortItems_card, jobsAt_position_card]

end InventoryCoverage
end BinPackingGap

end

end OAI
end LocalizedSource19
/- END LOCALIZED SOURCE 19/44: OAI/Computability/BinPacking/Inventory/InventoryCoverage.lean -/

/- BEGIN LOCALIZED SOURCE 20/44: OAI/Computability/BinPacking/Trees/KeyGeometry.lean
   SHA256: 0b8db6ffdc7743ca987be5ab136f0b0db97870d1cd97990837dd963ed94d60b3 -/
section LocalizedSource20
-- localized import: Mathlib.Tactic.Linarith
-- localized import: Mathlib.Tactic.Ring
-- localized import: OAI.Computability.BinPacking.Packing.CoordinateOrder

namespace OAI

namespace BinPackingGap.Geometry

def keyExpression (m R D L : ℕ) (row key : Position m R) (edge : Fin m)
    (nonpermit short : Bool) : ℚ :=
  baseline m R row - baseline m R key + beta m R edge - beta m R key.1 +
    delta m R D L * ((if nonpermit then 1 else 0) - (if short then 1 else 0))

theorem keyExpression_eq_coordinates (m R D L : ℕ) (row key : Position m R)
    (edge : Fin m) (nonpermit short : Bool) :
    keyExpression m R D L row key edge nonpermit short =
      (baseline m R row - if short then delta m R D L else 0) +
      (-baseline m R key - beta m R key.1) +
      (beta m R edge + if nonpermit then delta m R D L else 0) + 0 + 0 := by
  cases nonpermit <;> cases short <;> simp [keyExpression] <;> ring

theorem key_perturbation_lower (m R D L : ℕ) (nonpermit short : Bool) :
    -delta m R D L ≤
      delta m R D L * ((if nonpermit then 1 else 0) - (if short then 1 else 0)) := by
  have hd := delta_nonneg m R D L
  cases nonpermit <;> cases short <;> simp_all

theorem keyExpression_pos_of_later_row {m R D L : ℕ}
    {row key : Position m R} (edge : Fin m) (nonpermit short : Bool)
    (hlater : posLT key row) :
    0 < keyExpression m R D L row key edge nonpermit short := by
  have hg := gap_pos m R
  have hd := delta_lt_gap m R D L
  have hjump := mul_le_mul_of_nonneg_left (heightCode_jump hlater) (le_of_lt hg)
  have hedge := mul_nonneg (le_of_lt hg) (theta_nonneg R edge)
  have hpert := key_perturbation_lower m R D L nonpermit short
  dsimp [keyExpression, baseline, beta]
  nlinarith

theorem keyExpression_pos_of_later_edge {m R D L : ℕ}
    (row key : Position m R) {edge : Fin m} (nonpermit short : Bool)
    (hlater : key.1 < edge) :
    0 < keyExpression m R D L row key edge nonpermit short := by
  have hg := gap_pos m R
  have hd := delta_lt_gap m R D L
  have hjump := mul_le_mul_of_nonneg_left
    (theta_jump_ge_heightCode (R := R) hlater) (le_of_lt hg)
  have hrow := mul_nonneg (le_of_lt hg) (heightCode_nonneg R row)
  have hpert := key_perturbation_lower m R D L nonpermit short
  dsimp [keyExpression, baseline, beta]
  nlinarith

theorem row_order_of_key_feasible {m R D L : ℕ}
    {row key : Position m R} {edge : Fin m} {nonpermit short : Bool}
    (h : keyExpression m R D L row key edge nonpermit short ≤ 0) :
    posLE row key := by
  apply posLE_iff_not_posLT.mpr
  intro hlater
  exact (not_lt_of_ge h) (keyExpression_pos_of_later_row edge nonpermit short hlater)

theorem edge_order_of_key_feasible {m R D L : ℕ}
    {row key : Position m R} {edge : Fin m} {nonpermit short : Bool}
    (h : keyExpression m R D L row key edge nonpermit short ≤ 0) :
    edge ≤ key.1 := by
  by_contra hnot
  exact (not_lt_of_ge h)
    (keyExpression_pos_of_later_edge row key nonpermit short (lt_of_not_ge hnot))

theorem keyExpression_exact_position_edge (m R D L : ℕ)
    (key : Position m R) (nonpermit short : Bool) :
    keyExpression m R D L key key key.1 nonpermit short =
      delta m R D L * ((if nonpermit then 1 else 0) - (if short then 1 else 0)) := by
  simp [keyExpression]

theorem short_exact_key_feasible (m R D L : ℕ) (key : Position m R)
    (nonpermit : Bool) :
    keyExpression m R D L key key key.1 nonpermit true ≤ 0 := by
  rw [keyExpression_exact_position_edge]
  have hd := delta_nonneg m R D L
  cases nonpermit <;> simp_all

theorem long_exact_key_feasible_iff (m R D L : ℕ) (key : Position m R)
    (nonpermit : Bool) :
    keyExpression m R D L key key key.1 nonpermit false ≤ 0 ↔ nonpermit = false := by
  rw [keyExpression_exact_position_edge]
  have hd := delta_pos m R D L
  cases nonpermit <;> simp_all

theorem exact_long_key_resource {m R D L : ℕ}
    (key : Position m R) (edge : Fin m) (nonpermit : Bool)
    (h : keyExpression m R D L key key edge nonpermit false ≤ 0) :
    edge < key.1 ∨ (edge = key.1 ∧ nonpermit = false) := by
  have he := edge_order_of_key_feasible h
  rcases lt_or_eq_of_le he with hlt | heq
  · exact Or.inl hlt
  · right
    refine ⟨heq, ?_⟩
    subst edge
    exact (long_exact_key_feasible_iff m R D L key nonpermit).mp h

end BinPackingGap.Geometry

end OAI
end LocalizedSource20
/- END LOCALIZED SOURCE 20/44: OAI/Computability/BinPacking/Trees/KeyGeometry.lean -/

/- BEGIN LOCALIZED SOURCE 21/44: OAI/Computability/BinPacking/Packing/PackingFeasibility.lean
   SHA256: 52925d488a6ade745634dc1508fd14ce5105d48e138255b5e33bd365331fbbc6 -/
section LocalizedSource21
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryCoverage
-- localized import: OAI.Computability.BinPacking.Trees.KeyGeometry

namespace OAI

noncomputable section

namespace BinPackingGap
namespace PackingCounts

open scoped BigOperators

variable {D : InventoryData} {I : Instance} {b : ℕ}

theorem good_selected_labels (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v) (r : Role) :
    label e (p.itemAtRole (subclass e) t r) = tableRoleLabel v v v r := by
  cases r with
  | x =>
      simpa only [selected_row_label, tableRoleLabel] using
        congrArg some (good_row_vertex p e v t ht)
  | anchor =>
      simpa only [selected_anchor_label, tableRoleLabel] using
        congrArg some (good_anchor_vertex p e v t ht)
  | «global» =>
      change D.itemLabel (e.symm (p.itemAtRole (subclass e) t .«global»)) = none
      rw [← roleCopy_item p e t .«global», e.symm_apply_apply]
      rfl
  | «local» =>
      simpa only [selected_local_label, tableRoleLabel] using
        congrArg some (good_local_vertex p e v t ht)
  | flag =>
      change D.itemLabel (e.symm (p.itemAtRole (subclass e) t .flag)) = none
      rw [← roleCopy_item p e t .flag, e.symm_apply_apply]
      rfl

@[simp] theorem selected_itemCoordinate (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : Role) :
    D.itemCoordinate (e.symm (p.itemAtRole (subclass e) t r)) =
      D.itemCoordinate ⟨r, roleCopy p e t r⟩ := by
  rw [← roleCopy_item p e t r]
  simp only [Equiv.symm_apply_apply]

theorem good_coordinate_nonpos (p : Packing I b) (e : D.Item ≃ I.Item)
    (hsize : ∀ i, I.size i =
      encodedSize (subclass e i) (label e i) (D.itemCoordinate (e.symm i)))
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v) :
    D.rowCoordinate (rowCopy p e t).2 + D.anchorCoordinate (anchorCopy p e t).2 +
      D.globalCoordinate (globalCopy p e t) + D.localCoordinate (localCopy p e t).2 ≤ 0 := by
  have h := p.table_coordinate_nonpos_of_same_label (subclass e) (label e)
    (fun i => D.itemCoordinate (e.symm i)) hsize t v (good_selected_labels p e v t ht)
  simp only [selected_itemCoordinate] at h
  rw [Role.sum_univ] at h
  have hx (x : Σ v : D.Vertex, D.RowAt v) :
      D.itemCoordinate ⟨.x, x⟩ = D.rowCoordinate x.2 := by
    cases x
    rfl
  have ha (a : Σ v : D.Vertex, D.AnchorAt v) :
      D.itemCoordinate ⟨.anchor, a⟩ = D.anchorCoordinate a.2 := by
    cases a
    rfl
  have hl (l : Σ v : D.Vertex, D.LocalAt v) :
      D.itemCoordinate ⟨.«local», l⟩ = D.localCoordinate l.2 := by
    cases l
    rfl
  rw [hx (rowCopy p e t), ha (anchorCopy p e t), hl (localCopy p e t)] at h
  simpa only [InventoryData.itemCoordinate, add_zero] using h

private theorem main_anchor_of_subclass (a : Σ v : D.Vertex, D.AnchorAt v)
    (h : D.itemSubclass ⟨.anchor, a⟩ = .z) :
    ∃ z : D.MBase a.1, a.2 = .inl z := by
  rcases a with ⟨v, z | j⟩
  · exact ⟨z, rfl⟩
  · simp [InventoryData.itemSubclass] at h

private theorem globalCoordinate_of_not_w (u : D.GlobalCopy)
    (h : D.itemSubclass ⟨.«global», u⟩ ≠ .w) :
    D.globalCoordinate u = -D.globalLength u := by
  rcases u with ⟨species, i⟩
  cases species with
  | up one => rfl
  | um one => rfl
  | edge edge permit => exact (h rfl).elim

theorem main_anchor_copy (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (hpat : p.tablePattern (subclass e) t ≠ .edgeJob) :
    ∃ z : D.MBase (anchorCopy p e t).1, (anchorCopy p e t).2 = .inl z := by
  apply main_anchor_of_subclass
  have h := roleCopy_subclass p e t .anchor
  cases hp : p.tablePattern (subclass e) t <;> simp_all [patternSubclass]

theorem main_globalCoordinate (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (hpat : p.tablePattern (subclass e) t ≠ .edgeJob) :
    D.globalCoordinate (globalCopy p e t) = -D.globalLength (globalCopy p e t) := by
  apply globalCoordinate_of_not_w
  have h := roleCopy_subclass p e t .«global»
  cases hp : p.tablePattern (subclass e) t <;> simp_all [patternSubclass]

theorem main_completion_le_deadline (p : Packing I b) (e : D.Item ≃ I.Item)
    (hsize : ∀ i, I.size i =
      encodedSize (subclass e i) (label e i) (D.itemCoordinate (e.symm i)))
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v) :
    ∃ z : D.MBase (anchorCopy p e t).1,
      (anchorCopy p e t).2 = .inl z ∧ tupleFinish p e t ≤ D.deadline z := by
  have hpat := ((Coverage.mem_mainTuplesAt p (subclass e) (label e) v t).mp ht).2.2
  have hgood := Coverage.mainTuplesAt_subset_good p (subclass e) (label e) v ht
  have h := good_coordinate_nonpos p e hsize v t hgood
  obtain ⟨z, hz⟩ := main_anchor_copy p e t hpat
  refine ⟨z, hz, ?_⟩
  have ha : D.anchorCoordinate (anchorCopy p e t).2 = -D.deadline z := by
    rw [hz]
    rfl
  rw [ha, main_globalCoordinate p e t hpat] at h
  change D.rowCoordinate (rowCopy p e t).2 + -D.deadline z +
    -D.globalLength (globalCopy p e t) + -D.localLength (localCopy p e t).2 ≤ 0 at h
  have rearrange (x deadline globalLen localLen : ℚ)
      (hh : x + -deadline + -globalLen + -localLen ≤ 0) :
      x - globalLen - localLen ≤ deadline := by linarith
  exact rearrange (D.rowCoordinate (rowCopy p e t).2) (D.deadline z)
    (D.globalLength (globalCopy p e t)) (D.localLength (localCopy p e t).2) h

theorem main_completion_le_selected_deadline (p : Packing I b) (e : D.Item ≃ I.Item)
    (hsize : ∀ i, I.size i =
      encodedSize (subclass e i) (label e i) (D.itemCoordinate (e.symm i)))
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v) :
    tupleFinish p e t ≤
      InventoryCoverage.anchorDeadline e (p.itemAtRole (subclass e) t .anchor) := by
  obtain ⟨z, hz, hfinish⟩ := main_completion_le_deadline p e hsize v t ht
  have hcopy : anchorCopy p e t = ⟨(anchorCopy p e t).1, .inl z⟩ := by
    conv_lhs => rw [← Sigma.eta (anchorCopy p e t)]
    rw [hz]
  rw [InventoryCoverage.anchorDeadline_selected_of_deadline p e t _ z hcopy]
  exact hfinish

private theorem job_row_of_subclass (a : Σ v : D.Vertex, D.RowAt v)
    (h : D.itemSubclass ⟨.x, a⟩ = .s) :
    ∃ short : Bool, ∃ j : D.JobCopy a.1, a.2 = .inr (short, j) := by
  rcases a with ⟨v, row | ⟨short, j⟩⟩
  · rcases row with plus | (minus | padding) <;>
      simp [InventoryData.itemSubclass, InventoryData.rowSubclass,
        InventoryData.treeSubclass] at h
  · exact ⟨short, j, rfl⟩

private theorem key_anchor_of_subclass (a : Σ v : D.Vertex, D.AnchorAt v)
    (h : D.itemSubclass ⟨.anchor, a⟩ = .y) :
    ∃ j : D.JobCopy a.1, a.2 = .inr j := by
  rcases a with ⟨v, z | j⟩
  · simp [InventoryData.itemSubclass] at h
  · exact ⟨j, rfl⟩

private theorem edge_global_of_subclass (u : D.GlobalCopy)
    (h : D.itemSubclass ⟨.«global», u⟩ = .w) :
    ∃ edge : D.Edge, ∃ permit : Bool, ∃ i : Fin (D.globalStock (.edge edge permit)),
      u = ⟨.edge edge permit, i⟩ := by
  rcases u with ⟨species, i⟩
  cases species with
  | up one => simp [InventoryData.itemSubclass] at h
  | um one => simp [InventoryData.itemSubclass] at h
  | edge edge permit => exact ⟨edge, permit, i, rfl⟩

private theorem edge_local_of_subclass (a : Σ v : D.Vertex, D.LocalAt v)
    (h : D.itemSubclass ⟨.«local», a⟩ = .dg) :
    ∃ j : D.JobCopy a.1, a.2 = .inr j := by
  rcases a with ⟨v, main | j⟩
  · simp [InventoryData.itemSubclass] at h
  · exact ⟨j, rfl⟩

structure EdgeTupleData (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) where
  short : Bool
  row : D.JobCopy (rowCopy p e t).1
  key : D.JobCopy (anchorCopy p e t).1
  localJob : D.JobCopy (localCopy p e t).1
  edge : D.Edge
  permit : Bool
  globalIndex : Fin (D.globalStock (.edge edge permit))
  row_eq : (rowCopy p e t).2 = .inr (short, row)
  anchor_eq : (anchorCopy p e t).2 = .inr key
  local_eq : (localCopy p e t).2 = .inr localJob
  global_eq : globalCopy p e t = ⟨.edge edge permit, globalIndex⟩

theorem edgeTupleData_nonempty (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (hpat : p.tablePattern (subclass e) t = .edgeJob) :
    Nonempty (EdgeTupleData p e t) := by
  have hx : D.itemSubclass ⟨.x, rowCopy p e t⟩ = .s := by
    simpa only [hpat, patternSubclass] using roleCopy_subclass p e t .x
  have ha : D.itemSubclass ⟨.anchor, anchorCopy p e t⟩ = .y := by
    simpa only [hpat, patternSubclass] using roleCopy_subclass p e t .anchor
  have hu : D.itemSubclass ⟨.«global», globalCopy p e t⟩ = .w := by
    simpa only [hpat, patternSubclass] using roleCopy_subclass p e t .«global»
  have hl : D.itemSubclass ⟨.«local», localCopy p e t⟩ = .dg := by
    simpa only [hpat, patternSubclass] using roleCopy_subclass p e t .«local»
  obtain ⟨short, row, hrow⟩ := job_row_of_subclass _ hx
  obtain ⟨key, hkey⟩ := key_anchor_of_subclass _ ha
  obtain ⟨edge, permit, i, hglobal⟩ := edge_global_of_subclass _ hu
  obtain ⟨localJob, hlocal⟩ := edge_local_of_subclass _ hl
  exact ⟨⟨short, row, key, localJob, edge, permit, i, hrow, hkey, hlocal, hglobal⟩⟩

namespace EdgeTupleData

variable {p : Packing I b} {e : D.Item ≃ I.Item} {t : p.TableBin (subclass e)}

def expression (w : EdgeTupleData p e t) : ℚ :=
  Geometry.keyExpression D.graph.edges.length D.R D.geometryBound D.L
    (D.jobPosition w.row) (D.jobPosition w.key) w.edge (!w.permit) w.short

theorem expression_eq_coordinates (w : EdgeTupleData p e t) :
    w.expression =
      D.rowCoordinate (rowCopy p e t).2 + D.anchorCoordinate (anchorCopy p e t).2 +
        D.globalCoordinate (globalCopy p e t) + D.localCoordinate (localCopy p e t).2 := by
  rw [w.row_eq, w.anchor_eq, w.global_eq, w.local_eq]
  unfold expression
  rw [Geometry.keyExpression_eq_coordinates]
  simp only [InventoryData.rowCoordinate, InventoryData.rowBaseline, InventoryData.rowShort,
    InventoryData.anchorCoordinate, InventoryData.globalCoordinate,
    InventoryData.localCoordinate, InventoryData.localLength, neg_zero, add_zero]
  cases w.permit <;> cases w.short <;> simp

theorem feasible (w : EdgeTupleData p e t)
    (hsize : ∀ i, I.size i =
      encodedSize (subclass e i) (label e i) (D.itemCoordinate (e.symm i)))
    (v : D.Vertex) (ht : t ∈ Coverage.goodTuplesAt p (subclass e) (label e) v) :
    w.expression ≤ 0 := by
  rw [w.expression_eq_coordinates]
  exact good_coordinate_nonpos p e hsize v t ht

theorem row_order (w : EdgeTupleData p e t) (h : w.expression ≤ 0) :
    Geometry.posLE (D.jobPosition w.row) (D.jobPosition w.key) :=
  Geometry.row_order_of_key_feasible h

theorem edge_order (w : EdgeTupleData p e t) (h : w.expression ≤ 0) :
    w.edge ≤ (D.jobPosition w.key).1 :=
  Geometry.edge_order_of_key_feasible h

theorem exact_long_resource (w : EdgeTupleData p e t) (h : w.expression ≤ 0)
    (hpos : D.jobPosition w.row = D.jobPosition w.key) (hlong : w.short = false) :
    w.edge < (D.jobPosition w.key).1 ∨
      (w.edge = (D.jobPosition w.key).1 ∧ w.permit = true) := by
  have h' : Geometry.keyExpression D.graph.edges.length D.R D.geometryBound D.L
      (D.jobPosition w.key) (D.jobPosition w.key) w.edge (!w.permit) false ≤ 0 := by
    simpa only [expression, hpos, hlong] using h
  have hresource := Geometry.exact_long_key_resource (D.jobPosition w.key) w.edge
    (!w.permit) h'
  cases hp : w.permit <;> simpa [hp] using hresource

end EdgeTupleData

theorem edge_tuple_feasible (p : Packing I b) (e : D.Item ≃ I.Item)
    (hsize : ∀ i, I.size i =
      encodedSize (subclass e i) (label e i) (D.itemCoordinate (e.symm i)))
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.edgeTuplesAt p (subclass e) (label e) v) :
    ∃ w : EdgeTupleData p e t, w.expression ≤ 0 ∧
      Geometry.posLE (D.jobPosition w.row) (D.jobPosition w.key) ∧
        w.edge ≤ (D.jobPosition w.key).1 := by
  have hpat := ((Coverage.mem_edgeTuplesAt p (subclass e) (label e) v t).mp ht).2.2
  obtain ⟨w⟩ := edgeTupleData_nonempty p e t hpat
  have hf := w.feasible hsize v
    (Coverage.edgeTuplesAt_subset_good p (subclass e) (label e) v ht)
  exact ⟨w, hf, w.row_order hf, w.edge_order hf⟩

theorem edge_selected_baseline_le (p : Packing I b) (e : D.Item ≃ I.Item)
    (hsize : ∀ i, I.size i =
      encodedSize (subclass e i) (label e i) (D.itemCoordinate (e.symm i)))
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.edgeTuplesAt p (subclass e) (label e) v) :
    InventoryCoverage.rowBaseline e (p.itemAtRole (subclass e) t .x) ≤
      InventoryCoverage.keyBaseline e (p.itemAtRole (subclass e) t .anchor) := by
  obtain ⟨w, _, hrow, _⟩ := edge_tuple_feasible p e hsize v t ht
  have hcopy : anchorCopy p e t = ⟨(anchorCopy p e t).1, .inr w.key⟩ := by
    conv_lhs => rw [← Sigma.eta (anchorCopy p e t)]
    rw [w.anchor_eq]
  rw [InventoryCoverage.rowBaseline_selected,
    InventoryCoverage.keyBaseline_selected_of_key p e t _ w.key hcopy, w.row_eq]
  exact Geometry.baseline_le_iff.mpr hrow

end PackingCounts
end BinPackingGap

end

end OAI
end LocalizedSource21
/- END LOCALIZED SOURCE 21/44: OAI/Computability/BinPacking/Packing/PackingFeasibility.lean -/

/- BEGIN LOCALIZED SOURCE 22/44: OAI/Computability/BinPacking/Inventory/EdgeLongConsumption.lean
   SHA256: 146a18a88dcd93382638be49110d84e670e9951d5262d8370a5d8c09ec5403ca -/
section LocalizedSource22
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Basic
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Sigma
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryPrefixConservation
-- localized import: OAI.Computability.BinPacking.Packing.PackingFeasibility

namespace OAI

noncomputable section

namespace BinPackingGap
namespace InventoryData

section

variable (D : InventoryData) {b : ℕ}

def earlierKeyItems (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    Finset D.packingInstance.Item := (D.earlierKeys h hle).image D.itemEquiv

def earlierWItems (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    Finset D.packingInstance.Item := (D.earlierW h hle).image D.itemEquiv

theorem earlierKeyItems_card (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.earlierKeyItems h hle).card = 2 * D.d * D.R * h := by
  rw [earlierKeyItems, Finset.card_image_of_injective _ D.itemEquiv.injective,
    D.earlierKeys_card]

theorem earlierWItems_card (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.earlierWItems h hle).card = 2 * D.d * D.R * h := by
  rw [earlierWItems, Finset.card_image_of_injective _ D.itemEquiv.injective,
    D.earlierW_card]

theorem mem_earlierKeyItems (h : ℕ) (hle : h ≤ D.graph.edges.length)
    (i : D.packingInstance.Item) :
    i ∈ D.earlierKeyItems h hle ↔
      ∃ j : Σ v : D.Vertex, D.JobCopy v,
        D.itemEquiv (D.keyItem j) = i ∧ (D.jobPosition j.2).1.val < h := by
  classical
  constructor
  · intro hi
    obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hi
    obtain ⟨j, rfl, hj⟩ := (D.mem_earlierKeys h hle a).mp ha
    exact ⟨j, rfl, hj⟩
  · rintro ⟨j, rfl, hj⟩
    exact Finset.mem_image.mpr ⟨D.keyItem j,
      (D.mem_earlierKeys h hle _).mpr ⟨j, rfl, hj⟩, rfl⟩

theorem mem_earlierWItems (h : ℕ) (hle : h ≤ D.graph.edges.length)
    (i : D.packingInstance.Item) :
    i ∈ D.earlierWItems h hle ↔
      ∃ w : (D.Edge × Bool) × Fin (D.d * D.R),
        D.itemEquiv (D.edgeResourceItem w) = i ∧ w.1.1.val < h := by
  classical
  constructor
  · intro hi
    obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hi
    obtain ⟨w, rfl, hw⟩ := (D.mem_earlierW h hle a).mp ha
    exact ⟨w, rfl, hw⟩
  · rintro ⟨w, rfl, hw⟩
    exact Finset.mem_image.mpr ⟨D.edgeResourceItem w,
      (D.mem_earlierW h hle _).mpr ⟨w, rfl, hw⟩, rfl⟩

@[simp] theorem keyItem_mem_earlierKeyItems (h : ℕ) (hle : h ≤ D.graph.edges.length)
    (j : Σ v : D.Vertex, D.JobCopy v) :
    D.itemEquiv (D.keyItem j) ∈ D.earlierKeyItems h hle ↔
      (D.jobPosition j.2).1.val < h := by
  rw [D.mem_earlierKeyItems]
  constructor
  · rintro ⟨z, hz, hlt⟩
    have heq := D.keyItem_injective (D.itemEquiv.injective hz)
    subst z
    exact hlt
  · intro hlt
    exact ⟨j, rfl, hlt⟩

@[simp] theorem edgeResourceItem_mem_earlierWItems
    (h : ℕ) (hle : h ≤ D.graph.edges.length)
    (w : (D.Edge × Bool) × Fin (D.d * D.R)) :
    D.itemEquiv (D.edgeResourceItem w) ∈ D.earlierWItems h hle ↔ w.1.1.val < h := by
  rw [D.mem_earlierWItems]
  constructor
  · rintro ⟨z, hz, hlt⟩
    have heq := D.edgeResourceItem_injective (D.itemEquiv.injective hz)
    simpa only [heq] using hlt
  · intro hlt
    exact ⟨w, rfl, hlt⟩

def earlierGoodKeyTuples (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) : Finset (p.TableBin D.encodedSubclass) := by
  classical
  exact Finset.univ.filter fun t => p.IsGoodTableBin D.encodedSubclass D.encodedLabel t ∧
    p.itemAtRole D.encodedSubclass t .anchor ∈ D.earlierKeyItems h hle

@[simp] theorem mem_earlierGoodKeyTuples (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) (t : p.TableBin D.encodedSubclass) :
    t ∈ D.earlierGoodKeyTuples p h hle ↔
      p.IsGoodTableBin D.encodedSubclass D.encodedLabel t ∧
        p.itemAtRole D.encodedSubclass t .anchor ∈ D.earlierKeyItems h hle := by
  classical
  simp [earlierGoodKeyTuples]

theorem earlierGoodKeyTuples_anchor_subset (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    Coverage.roleItems p D.encodedSubclass (D.earlierGoodKeyTuples p h hle) .anchor ⊆
      D.earlierKeyItems h hle := by
  intro i hi
  obtain ⟨t, ht, rfl⟩ := Finset.mem_image.mp hi
  exact ((D.mem_earlierGoodKeyTuples p h hle t).mp ht).2

theorem earlierGoodKeyTuples_edge (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) (t : p.TableBin D.encodedSubclass)
    (ht : t ∈ D.earlierGoodKeyTuples p h hle) :
    ∃ v, t ∈ Coverage.edgeTuplesAt p D.encodedSubclass D.encodedLabel v := by
  obtain ⟨hgood, hkey⟩ := (D.mem_earlierGoodKeyTuples p h hle t).mp ht
  obtain ⟨j, hj, _⟩ := (D.mem_earlierKeyItems h hle _).mp hkey
  have hlabel : D.encodedLabel (p.itemAtRole D.encodedSubclass t .anchor) = some j.1 := by
    rw [← hj]
    simp [encodedLabel]
  have hsub : D.encodedSubclass (p.itemAtRole D.encodedSubclass t .anchor) = .y := by
    rw [← hj]
    simp [encodedSubclass]
  have hpat : p.tablePattern D.encodedSubclass t = .edgeJob := by
    have hx := (p.itemAtRole_subclass D.encodedSubclass t .anchor).symm.trans hsub
    cases hp : p.tablePattern D.encodedSubclass t <;> simp_all [patternSubclass]
  exact ⟨j.1, (Coverage.mem_edgeTuplesAt p D.encodedSubclass D.encodedLabel j.1 t).mpr
    ⟨hgood, hlabel, hpat⟩⟩

theorem earlierGoodKeyTuples_global_subset (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    Coverage.roleItems p D.encodedSubclass (D.earlierGoodKeyTuples p h hle) .«global» ⊆
      D.earlierWItems h hle := by
  classical
  intro i hi
  obtain ⟨t, ht, rfl⟩ := Finset.mem_image.mp hi
  obtain ⟨v, htv⟩ := D.earlierGoodKeyTuples_edge p h hle t ht
  obtain ⟨w, _, _, he⟩ := PackingCounts.edge_tuple_feasible p D.itemEquiv
    D.packingInstance_size_eq v t htv
  obtain ⟨j, hj, hjlt⟩ := (D.mem_earlierKeyItems h hle _).mp
    (((D.mem_earlierGoodKeyTuples p h hle t).mp ht).2)
  have hkey : D.itemEquiv (D.keyItem ⟨(PackingCounts.anchorCopy p D.itemEquiv t).1, w.key⟩) =
      p.itemAtRole D.encodedSubclass t .anchor := by
    have ha := congrArg
      (fun a : D.AnchorAt (PackingCounts.anchorCopy p D.itemEquiv t).1 =>
        D.itemEquiv (⟨.anchor,
          ⟨(PackingCounts.anchorCopy p D.itemEquiv t).1, a⟩⟩ : D.Item)) w.anchor_eq
    have heta := congrArg
      (fun a : Σ v : D.Vertex, D.AnchorAt v => D.itemEquiv (⟨.anchor, a⟩ : D.Item))
      (Sigma.eta (PackingCounts.anchorCopy p D.itemEquiv t))
    exact ha.symm.trans (heta.trans (PackingCounts.roleCopy_item p D.itemEquiv t .anchor))
  have hjEq := D.keyItem_injective (D.itemEquiv.injective (hkey.trans hj.symm))
  have hpos := congrArg (fun z : Σ v : D.Vertex, D.JobCopy v =>
    (D.jobPosition z.2).1.val) hjEq
  have hwe : w.edge.val < h := lt_of_le_of_lt he (by simpa only [hpos] using hjlt)
  apply (D.mem_earlierWItems h hle _).mpr
  refine ⟨((w.edge, w.permit), w.globalIndex), ?_, hwe⟩
  exact (congrArg (fun g : D.GlobalCopy => D.itemEquiv (⟨.«global», g⟩ : D.Item))
    w.global_eq.symm).trans (PackingCounts.roleCopy_item p D.itemEquiv t .«global»)

def remainingEarlierW (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) : Finset D.packingInstance.Item :=
  D.earlierWItems h hle \
    Coverage.roleItems p D.encodedSubclass (D.earlierGoodKeyTuples p h hle) .«global»

theorem remainingEarlierW_card_eq_missingKeys (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.remainingEarlierW p h hle).card =
      (D.earlierKeyItems h hle \
        Coverage.roleItems p D.encodedSubclass (D.earlierGoodKeyTuples p h hle) .anchor).card := by
  rw [remainingEarlierW, Finset.card_sdiff_of_subset (D.earlierGoodKeyTuples_global_subset p h hle),
    Finset.card_sdiff_of_subset (D.earlierGoodKeyTuples_anchor_subset p h hle),
    Coverage.roleItems_card, Coverage.roleItems_card, D.earlierWItems_card,
    D.earlierKeyItems_card]

theorem missingEarlierKeys_subset_bad (p : Packing D.packingInstance b)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    D.earlierKeyItems h hle \
      Coverage.roleItems p D.encodedSubclass (D.earlierGoodKeyTuples p h hle) .anchor ⊆
        (Finset.univ : Finset D.Vertex).biUnion
          (Coverage.badAnchorsAt p D.encodedSubclass D.encodedLabel) := by
  classical
  intro i hi
  obtain ⟨hik, hin⟩ := Finset.mem_sdiff.mp hi
  obtain ⟨j, hj, _⟩ := (D.mem_earlierKeyItems h hle i).mp hik
  apply Finset.mem_biUnion.mpr
  refine ⟨j.1, Finset.mem_univ _, ?_⟩
  apply (Coverage.mem_badAnchorsAt p D.encodedSubclass D.encodedLabel j.1 i).mpr
  constructor
  · apply (Coverage.mem_anchorItemsAt D.encodedSubclass D.encodedLabel j.1 i).mpr
    rw [← hj]
    simp [encodedSubclass, encodedLabel, Subclass.role]
  · intro hgood
    obtain ⟨t, ht, hti⟩ := Finset.mem_image.mp hgood
    apply hin
    refine Finset.mem_image.mpr ⟨t, ?_, hti⟩
    apply (D.mem_earlierGoodKeyTuples p h hle t).mpr
    refine ⟨((Coverage.mem_goodTuplesAt p D.encodedSubclass D.encodedLabel j.1 t).mp ht).1, ?_⟩
    simpa only [hti] using hik

theorem remainingEarlierW_card_le {c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c)
    (h : ℕ) (hle : h ≤ D.graph.edges.length) :
    (D.remainingEarlierW p h hle).card ≤ 3 * D.graph.n * lossAllowance c := by
  rw [D.remainingEarlierW_card_eq_missingKeys]
  exact (Finset.card_le_card (D.missingEarlierKeys_subset_bad p h hle)).trans
    (D.badAnchors_global_card_le hk p hb)

end

open scoped BigOperators
open PackingCounts

variable (D : InventoryData) {b : ℕ}

def edgeLongTuplesAt (p : Packing D.packingInstance b) (edge : D.Edge)
    (q : Fin 2 × Fin D.R) : Finset (p.TableBin D.encodedSubclass) :=
  Coverage.currentLongEdgeAt p D.encodedSubclass D.encodedLabel
    (D.graph.endpoint edge q.1)
    (InventoryCoverage.rowBaseline D.itemEquiv)
    (InventoryCoverage.keyBaseline D.itemEquiv)
    (InventoryCoverage.rowShort D.itemEquiv)
    (Geometry.baseline D.graph.edges.length D.R (edge, q.2))

@[simp] theorem mem_edgeLongTuplesAt (p : Packing D.packingInstance b) (edge : D.Edge)
    (q : Fin 2 × Fin D.R) (t : p.TableBin D.encodedSubclass) :
    t ∈ D.edgeLongTuplesAt p edge q ↔
      t ∈ Coverage.edgeTuplesAt p D.encodedSubclass D.encodedLabel
        (D.graph.endpoint edge q.1) ∧
      InventoryCoverage.keyBaseline D.itemEquiv
        (p.itemAtRole D.encodedSubclass t .anchor) =
          Geometry.baseline D.graph.edges.length D.R (edge, q.2) ∧
      InventoryCoverage.rowBaseline D.itemEquiv
        (p.itemAtRole D.encodedSubclass t .x) =
          Geometry.baseline D.graph.edges.length D.R (edge, q.2) ∧
      InventoryCoverage.rowShort D.itemEquiv
        (p.itemAtRole D.encodedSubclass t .x) ≠ true := by
  classical
  simp [edgeLongTuplesAt, Coverage.currentLongEdgeAt, Coverage.currentEdgeTuplesAt,
    and_assoc]

theorem edgeLongTuplesAt_disjoint (p : Packing D.packingInstance b) (edge : D.Edge)
    {q r : Fin 2 × Fin D.R} (hne : q ≠ r) :
    Disjoint (D.edgeLongTuplesAt p edge q) (D.edgeLongTuplesAt p edge r) := by
  classical
  apply Finset.disjoint_left.mpr
  intro t hq hr
  obtain ⟨hGq, hkeyq, _, _⟩ := (D.mem_edgeLongTuplesAt p edge q t).mp hq
  obtain ⟨hGr, hkeyr, _, _⟩ := (D.mem_edgeLongTuplesAt p edge r t).mp hr
  have hlq := ((Coverage.mem_edgeTuplesAt p D.encodedSubclass D.encodedLabel
    (D.graph.endpoint edge q.1) t).mp hGq).2.1
  have hlr := ((Coverage.mem_edgeTuplesAt p D.encodedSubclass D.encodedLabel
    (D.graph.endpoint edge r.1) t).mp hGr).2.1
  have hside : q.1 = r.1 := D.graph.endpoint_injective edge
    (Option.some.inj (hlq.symm.trans hlr))
  have hrep : q.2 = r.2 := congrArg (fun z : D.Edge × Fin D.R => z.2)
    ((Geometry.baseline_eq_iff (r := (edge, q.2)) (s := (edge, r.2))).mp
      (hkeyq.symm.trans hkeyr))
  exact hne (Prod.ext hside hrep)

def edgeLongTuples (p : Packing D.packingInstance b) (edge : D.Edge)
    (J : Finset (Fin D.R)) : Finset (p.TableBin D.encodedSubclass) := by
  classical
  exact ((Finset.univ : Finset (Fin 2)).product J).biUnion (D.edgeLongTuplesAt p edge)

theorem edgeLongTuples_card (p : Packing D.packingInstance b) (edge : D.Edge)
    (J : Finset (Fin D.R)) :
    (D.edgeLongTuples p edge J).card =
      ∑ side : Fin 2, ∑ rep ∈ J, (D.edgeLongTuplesAt p edge (side, rep)).card := by
  classical
  have hdis : ∀ q ∈ (Finset.univ : Finset (Fin 2)).product J,
      ∀ r ∈ (Finset.univ : Finset (Fin 2)).product J,
        q ≠ r → Disjoint (D.edgeLongTuplesAt p edge q) (D.edgeLongTuplesAt p edge r) := by
    intro q _ r _ hne
    exact D.edgeLongTuplesAt_disjoint p edge hne
  rw [edgeLongTuples, Finset.card_biUnion hdis]
  exact Finset.sum_product (Finset.univ : Finset (Fin 2)) J
    (fun q : Fin 2 × Fin D.R => (D.edgeLongTuplesAt p edge q).card)

theorem edgeLongTuplesAt_witness (p : Packing D.packingInstance b) (edge : D.Edge)
    (q : Fin 2 × Fin D.R) (t : p.TableBin D.encodedSubclass)
    (ht : t ∈ D.edgeLongTuplesAt p edge q) :
    ∃ w : EdgeTupleData p D.itemEquiv t, w.expression ≤ 0 ∧
      D.jobPosition w.key = (edge, q.2) ∧
      D.jobPosition w.row = (edge, q.2) ∧ w.short = false := by
  obtain ⟨hG, hkey, hrow, hshort⟩ := (D.mem_edgeLongTuplesAt p edge q t).mp ht
  obtain ⟨w, hf, _, _⟩ := edge_tuple_feasible p D.itemEquiv
    D.packingInstance_size_eq (D.graph.endpoint edge q.1) t hG
  have hcopy : anchorCopy p D.itemEquiv t =
      ⟨(anchorCopy p D.itemEquiv t).1, .inr w.key⟩ := by
    conv_lhs => rw [← Sigma.eta (anchorCopy p D.itemEquiv t)]
    rw [w.anchor_eq]
  erw [InventoryCoverage.keyBaseline_selected_of_key p D.itemEquiv t _ w.key hcopy] at hkey
  erw [InventoryCoverage.rowBaseline_selected p D.itemEquiv t, w.row_eq] at hrow
  change Geometry.baseline D.graph.edges.length D.R (D.jobPosition w.row) = _ at hrow
  erw [InventoryCoverage.rowShort_selected p D.itemEquiv t, w.row_eq] at hshort
  change w.short ≠ true at hshort
  refine ⟨w, hf, Geometry.baseline_eq_iff.mp hkey, Geometry.baseline_eq_iff.mp hrow, ?_⟩
  exact Bool.eq_false_of_not_eq_true hshort

private theorem witness_key_item (p : Packing D.packingInstance b)
    (t : p.TableBin D.encodedSubclass) (w : EdgeTupleData p D.itemEquiv t) :
    D.itemEquiv (D.keyItem ⟨(anchorCopy p D.itemEquiv t).1, w.key⟩) =
      p.itemAtRole D.encodedSubclass t .anchor := by
  erw [← roleCopy_item p D.itemEquiv t .anchor]
  apply congrArg D.itemEquiv
  change (⟨.anchor, ⟨_, .inr w.key⟩⟩ : D.Item) =
    ⟨.anchor, anchorCopy p D.itemEquiv t⟩
  conv_rhs => rw [← Sigma.eta (anchorCopy p D.itemEquiv t), w.anchor_eq]

private theorem witness_global_item (p : Packing D.packingInstance b)
    (t : p.TableBin D.encodedSubclass) (w : EdgeTupleData p D.itemEquiv t) :
    D.itemEquiv (D.edgeResourceItem ((w.edge, w.permit), w.globalIndex)) =
      p.itemAtRole D.encodedSubclass t .«global» := by
  erw [← roleCopy_item p D.itemEquiv t .«global»]
  change D.itemEquiv ⟨.«global», ⟨.edge w.edge w.permit, w.globalIndex⟩⟩ =
    D.itemEquiv ⟨.«global», globalCopy p D.itemEquiv t⟩
  rw [w.global_eq]

theorem edgeLongTuplesAt_not_earlierGoodKeyTuples (p : Packing D.packingInstance b)
    (edge : D.Edge) (q : Fin 2 × Fin D.R) (t : p.TableBin D.encodedSubclass)
    (ht : t ∈ D.edgeLongTuplesAt p edge q) :
    t ∉ D.earlierGoodKeyTuples p edge.val edge.isLt.le := by
  obtain ⟨w, _, hkey, _, _⟩ := D.edgeLongTuplesAt_witness p edge q t ht
  intro hearlier
  have hmem := ((D.mem_earlierGoodKeyTuples p edge.val edge.isLt.le t).mp hearlier).2
  rw [← D.witness_key_item p t w, D.keyItem_mem_earlierKeyItems] at hmem
  simp only [hkey, Nat.lt_irrefl] at hmem

theorem edgeLongTuplesAt_global_not_used_earlier (p : Packing D.packingInstance b)
    (edge : D.Edge) (q : Fin 2 × Fin D.R) (t : p.TableBin D.encodedSubclass)
    (ht : t ∈ D.edgeLongTuplesAt p edge q) :
    p.itemAtRole D.encodedSubclass t .«global» ∉
      Coverage.roleItems p D.encodedSubclass
        (D.earlierGoodKeyTuples p edge.val edge.isLt.le) .«global» := by
  intro hi
  obtain ⟨u, hu, heq⟩ := Finset.mem_image.mp hi
  have hut : u = t := p.itemAtRole_injective D.encodedSubclass .«global» heq
  subst u
  exact D.edgeLongTuplesAt_not_earlierGoodKeyTuples p edge q t ht hu

theorem edgeLongTuplesAt_global_mem (p : Packing D.packingInstance b)
    (edge : D.Edge) (q : Fin 2 × Fin D.R) (t : p.TableBin D.encodedSubclass)
    (ht : t ∈ D.edgeLongTuplesAt p edge q) :
    p.itemAtRole D.encodedSubclass t .«global» ∈
      globalResources D.itemEquiv (.edge edge true) ∪
        D.remainingEarlierW p edge.val edge.isLt.le := by
  classical
  obtain ⟨w, hf, hkey, hrow, hshort⟩ := D.edgeLongTuplesAt_witness p edge q t ht
  have hresource := w.exact_long_resource hf (hrow.trans hkey.symm) hshort
  rcases hresource with hearlier | ⟨heq, hpermit⟩
  · apply Finset.mem_union_right
    apply Finset.mem_sdiff.mpr
    refine ⟨?_, D.edgeLongTuplesAt_global_not_used_earlier p edge q t ht⟩
    apply (D.mem_earlierWItems edge.val edge.isLt.le _).mpr
    refine ⟨((w.edge, w.permit), w.globalIndex), D.witness_global_item p t w, ?_⟩
    have hlt : w.edge < edge := by simpa only [hkey] using hearlier
    exact hlt
  · apply Finset.mem_union_left
    apply (selected_global_resource_iff p D.itemEquiv t (.edge edge true)).mpr
    rw [w.global_eq]
    have hedge : w.edge = edge := by simpa only [hkey] using heq
    simp only [hedge, hpermit]

theorem edgeLongTuples_global_subset (p : Packing D.packingInstance b)
    (edge : D.Edge) (J : Finset (Fin D.R)) :
    Coverage.roleItems p D.encodedSubclass (D.edgeLongTuples p edge J) .«global» ⊆
      globalResources D.itemEquiv (.edge edge true) ∪
        D.remainingEarlierW p edge.val edge.isLt.le := by
  classical
  intro i hi
  obtain ⟨t, ht, rfl⟩ := Finset.mem_image.mp hi
  obtain ⟨q, _, hq⟩ := Finset.mem_biUnion.mp ht
  exact D.edgeLongTuplesAt_global_mem p edge q t hq

theorem edge_long_matches_capacity {c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c)
    (edge : D.Edge) (J : Finset (Fin D.R)) :
    (∑ side : Fin 2, ∑ rep ∈ J, (D.edgeLongTuplesAt p edge (side, rep)).card) ≤
      D.d * D.R + 3 * D.graph.n * lossAllowance c := by
  classical
  rw [← D.edgeLongTuples_card]
  have hbound := Finset.card_le_card (D.edgeLongTuples_global_subset p edge J)
  rw [Coverage.roleItems_card] at hbound
  refine hbound.trans ((Finset.card_union_le _ _).trans ?_)
  rw [globalResources_card]
  change D.d * D.R + (D.remainingEarlierW p edge.val edge.isLt.le).card ≤ _
  exact Nat.add_le_add_left (D.remainingEarlierW_card_le hk p hb edge.val edge.isLt.le) _

theorem edge_long_matches_capacity_raw {c : ℕ} (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c)
    (edge : D.Edge) (J : Finset (Fin D.R)) :
    (∑ side : Fin 2, ∑ rep ∈ J,
      (Coverage.currentLongEdgeAt p D.encodedSubclass D.encodedLabel
        (D.graph.endpoint edge side)
        (InventoryCoverage.rowBaseline D.itemEquiv)
        (InventoryCoverage.keyBaseline D.itemEquiv)
        (InventoryCoverage.rowShort D.itemEquiv)
        (Geometry.baseline D.graph.edges.length D.R (edge, rep))).card) ≤
      D.d * D.R + 3 * D.graph.n * lossAllowance c :=
  D.edge_long_matches_capacity hk p hb edge J

end InventoryData
end BinPackingGap

end

end OAI
end LocalizedSource22
/- END LOCALIZED SOURCE 22/44: OAI/Computability/BinPacking/Inventory/EdgeLongConsumption.lean -/

/- BEGIN LOCALIZED SOURCE 23/44: OAI/Computability/BinPacking/Trees/TreeAttachment.lean
   SHA256: c7e7c2739d4406b2f05e35c6af260b1e8091cddeec1f3453bb28b154824e1198 -/
section LocalizedSource23
-- localized import: OAI.Computability.BinPacking.Trees.IntegerTreeGeometry

namespace OAI

namespace BinPackingGap
namespace UniformTree

def graftLeaves (T : UniformTree) (G : T.leaves → UniformTree) : Finset (List ℕ) :=
  Finset.univ.biUnion (fun l : T.leaves =>
    (G l).leaves.image (fun w => l.val ++ w))

theorem mem_graftLeaves (T : UniformTree) (G : T.leaves → UniformTree)
    {x : List ℕ} :
    x ∈ graftLeaves T G ↔ ∃ l : T.leaves, ∃ w ∈ (G l).leaves, x = l.val ++ w := by
  constructor
  · intro hx
    obtain ⟨l, _, hl⟩ := Finset.mem_biUnion.mp hx
    obtain ⟨w, hw, hx⟩ := Finset.mem_image.mp hl
    exact ⟨l, w, hw, hx.symm⟩
  · rintro ⟨l, w, hw, rfl⟩
    exact Finset.mem_biUnion.mpr
      ⟨l, Finset.mem_univ l, Finset.mem_image.mpr ⟨w, hw, rfl⟩⟩

def graft (T : UniformTree) (G : T.leaves → UniformTree)
    (N : ℕ) (hG : ∀ l, (G l).height = N) : UniformTree where
  height := T.height + N
  leaves := graftLeaves T G
  leaves_nonempty := by
    obtain ⟨l, hl⟩ := T.leaves_nonempty
    obtain ⟨w, hw⟩ := (G ⟨l, hl⟩).leaves_nonempty
    exact ⟨l ++ w, (mem_graftLeaves T G).mpr ⟨⟨l, hl⟩, w, hw, rfl⟩⟩
  length_leaf := by
    intro x hx
    obtain ⟨l, w, hw, rfl⟩ := (mem_graftLeaves T G).mp hx
    rw [List.length_append, T.length_leaf l.val l.property,
      (G l).length_leaf w hw, hG l]
  positive_labels := by
    intro x hx a ha
    obtain ⟨l, w, hw, rfl⟩ := (mem_graftLeaves T G).mp hx
    rcases List.mem_append.mp ha with ha | ha
    · exact T.positive_labels l.val l.property a ha
    · exact (G l).positive_labels w hw a ha

@[simp] theorem graft_height (T : UniformTree) (G : T.leaves → UniformTree)
    (N : ℕ) (hG : ∀ l, (G l).height = N) :
    (graft T G N hG).height = T.height + N := rfl

theorem mem_graft_leaves (T : UniformTree) (G : T.leaves → UniformTree)
    (N : ℕ) (hG : ∀ l, (G l).height = N) {x : List ℕ} :
    x ∈ (graft T G N hG).leaves ↔
      ∃ l : T.leaves, ∃ w ∈ (G l).leaves, x = l.val ++ w :=
  mem_graftLeaves T G

theorem append_eq_append_iff (T : UniformTree) (l₁ l₂ : T.leaves)
    (u v : List ℕ) :
    l₁.val ++ u = l₂.val ++ v ↔ l₁ = l₂ ∧ u = v := by
  constructor
  · intro h
    have hlen : l₁.val.length = l₂.val.length :=
      (T.length_leaf l₁.val l₁.property).trans (T.length_leaf l₂.val l₂.property).symm
    exact ⟨Subtype.ext (List.append_inj_left h hlen), List.append_inj_right h hlen⟩
  · rintro ⟨rfl, rfl⟩
    rfl

theorem old_prefix_iff (T : UniformTree) {u : List ℕ} (hu : u ∈ T.vertices)
    (l : T.leaves) (w : List ℕ) :
    u.IsPrefix (l.val ++ w) ↔ u.IsPrefix l.val := by
  apply List.isPrefix_append_of_length
  rw [T.length_leaf l.val l.property]
  exact T.length_le_height hu

theorem leaf_prefix_append_iff (T : UniformTree) (l₁ l₂ : T.leaves)
    (w : List ℕ) : l₁.val.IsPrefix (l₂.val ++ w) ↔ l₁ = l₂ := by
  rw [T.old_prefix_iff (T.leaf_mem_vertices l₁.property) l₂ w]
  constructor
  · intro h
    exact Subtype.ext (h.eq_of_length
      ((T.length_leaf l₁.val l₁.property).trans
        (T.length_leaf l₂.val l₂.property).symm))
  · rintro rfl
    exact List.prefix_refl l₁.val

theorem vertices_subset_graft (T : UniformTree) (G : T.leaves → UniformTree)
    (N : ℕ) (hG : ∀ l, (G l).height = N) :
    T.vertices ⊆ (graft T G N hG).vertices := by
  intro u hu
  obtain ⟨l, hl, hul⟩ := T.mem_vertices_iff.mp hu
  let oldLeaf : T.leaves := ⟨l, hl⟩
  obtain ⟨w, hw⟩ := (G oldLeaf).leaves_nonempty
  apply (graft T G N hG).mem_vertices_iff.mpr
  refine ⟨l ++ w, ?_, hul.trans (List.prefix_append l w)⟩
  exact (mem_graft_leaves T G N hG).mpr ⟨oldLeaf, w, hw, rfl⟩

theorem append_mem_graft_vertices (T : UniformTree) (G : T.leaves → UniformTree)
    (N : ℕ) (hG : ∀ l, (G l).height = N) (l : T.leaves)
    {v : List ℕ} (hv : v ∈ (G l).vertices) :
    l.val ++ v ∈ (graft T G N hG).vertices := by
  obtain ⟨w, hw, hvw⟩ := (G l).mem_vertices_iff.mp hv
  exact (graft T G N hG).mem_vertices_iff.mpr
    ⟨l.val ++ w, (mem_graft_leaves T G N hG).mpr ⟨l, w, hw, rfl⟩,
      (List.prefix_append_right_inj l.val).mpr hvw⟩

theorem mem_graft_vertices_iff (T : UniformTree) (G : T.leaves → UniformTree)
    (N : ℕ) (hG : ∀ l, (G l).height = N) {x : List ℕ} :
    x ∈ (graft T G N hG).vertices ↔
      x ∈ T.vertices ∨
        ∃ l : T.leaves, ∃ v ∈ (G l).vertices, v ≠ [] ∧ x = l.val ++ v := by
  constructor
  · intro hx
    obtain ⟨word, hword, hp⟩ := (graft T G N hG).mem_vertices_iff.mp hx
    obtain ⟨l, w, hw, rfl⟩ := (mem_graft_leaves T G N hG).mp hword
    have hx' : x ∈ prefixes (l.val ++ w) := mem_prefixes_iff.mpr hp
    rw [prefixes_append_eq] at hx'
    rcases Finset.mem_union.mp hx' with h | h
    · exact Or.inl (T.mem_vertices_iff.mpr
        ⟨l.val, l.property, mem_prefixes_iff.mp h⟩)
    · obtain ⟨v, hv, hpv, heq⟩ := mem_prefixesAfter_iff.mp h
      exact Or.inr ⟨l, v, (G l).mem_vertices_iff.mpr ⟨w, hw, hpv⟩, hv, heq.symm⟩
  · rintro (hx | ⟨l, v, hv, _, rfl⟩)
    · exact vertices_subset_graft T G N hG hx
    · exact append_mem_graft_vertices T G N hG l hv

theorem append_not_mem_old_vertices (T : UniformTree) (l : T.leaves)
    {v : List ℕ} (hv : v ≠ []) : l.val ++ v ∉ T.vertices := by
  intro h
  have hlen := T.length_le_height h
  rw [List.length_append, T.length_leaf l.val l.property] at hlen
  have hz : v.length = 0 := by omega
  exact hv (List.length_eq_zero_iff.mp hz)

theorem filter_old_prefix_append (T : UniformTree) (marks : Finset (List ℕ))
    (hmarks : marks ⊆ T.vertices) (l : T.leaves) (w : List ℕ) :
    marks.filter (fun u => u.IsPrefix (l.val ++ w)) =
      marks.filter (fun u => u.IsPrefix l.val) := by
  apply Finset.filter_congr
  intro u hu
  exact T.old_prefix_iff (hmarks hu) l w

theorem append_not_prefix_of_ne_leaves (T : UniformTree) (l₁ l₂ : T.leaves)
    (hne : l₁ ≠ l₂) (u v : List ℕ) :
    ¬ (l₁.val ++ u).IsPrefix (l₂.val ++ v) := by
  intro h
  apply hne
  exact (T.leaf_prefix_append_iff l₁ l₂ v).mp
    ((List.prefix_append l₁.val u).trans h)

theorem append_prefix_append_iff (T : UniformTree) (l₁ l₂ : T.leaves)
    (u v : List ℕ) :
    (l₁.val ++ u).IsPrefix (l₂.val ++ v) ↔ l₁ = l₂ ∧ u.IsPrefix v := by
  constructor
  · intro h
    have heq : l₁ = l₂ := (T.leaf_prefix_append_iff l₁ l₂ v).mp
      ((List.prefix_append l₁.val u).trans h)
    subst l₂
    exact ⟨rfl, (List.prefix_append_right_inj l₁.val).mp h⟩
  · rintro ⟨rfl, h⟩
    exact (List.prefix_append_right_inj l₁.val).mpr h

theorem filter_other_lift_prefix (T : UniformTree) (l₁ l₂ : T.leaves)
    (hne : l₁ ≠ l₂) (marks : Finset (List ℕ)) (w : List ℕ) :
    (marks.image (fun u => l₁.val ++ u)).filter
      (fun u => u.IsPrefix (l₂.val ++ w)) = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  obtain ⟨hm, hp⟩ := Finset.mem_filter.mp hx
  obtain ⟨u, _, rfl⟩ := Finset.mem_image.mp hm
  exact T.append_not_prefix_of_ne_leaves l₁ l₂ hne u w hp

theorem old_disjoint_lift (T : UniformTree) (old : Finset (List ℕ))
    (hold : old ⊆ T.vertices) (l : T.leaves) (marks : Finset (List ℕ))
    (hroot : [] ∉ marks) : Disjoint old (marks.image (fun u => l.val ++ u)) := by
  apply Finset.disjoint_left.mpr
  intro x hxold hxlift
  obtain ⟨u, hu, rfl⟩ := Finset.mem_image.mp hxlift
  have hne : u ≠ [] := by
    intro heq
    exact hroot (heq ▸ hu)
  exact T.append_not_mem_old_vertices l hne (hold hxold)

end UniformTree
end BinPackingGap

end OAI
end LocalizedSource23
/- END LOCALIZED SOURCE 23/44: OAI/Computability/BinPacking/Trees/TreeAttachment.lean -/

/- BEGIN LOCALIZED SOURCE 24/44: OAI/Computability/BinPacking/Trees/TreePruning.lean
   SHA256: cdf4f3b6b616717fd7d0c7189777e374d9ebb2e55d07c88a237168899d941d0c -/
section LocalizedSource24
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Basic
-- localized import: Mathlib.Data.Finset.Card
-- localized import: Mathlib.Order.Interval.Finset.Nat
-- localized import: OAI.Computability.BinPacking.Trees.IntegerTreeGeometry

namespace OAI

namespace BinPackingGap

open scoped BigOperators

namespace UniformTree

instance decidableAncestor {T : UniformTree} : DecidableRel (@ancestor T) :=
  fun u v => inferInstanceAs (Decidable (u.val.IsPrefix v.val))

def prune (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty) : UniformTree where
  height := T.height
  leaves := keep
  leaves_nonempty := hne
  length_leaf := fun l hl => T.length_leaf l (hsub hl)
  positive_labels := fun l hl => T.positive_labels l (hsub hl)

@[simp] theorem prune_height (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty) :
    (T.prune keep hsub hne).height = T.height := rfl

@[simp] theorem prune_leaves (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty) :
    (T.prune keep hsub hne).leaves = keep := rfl

theorem prune_vertices_subset (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty) :
    (T.prune keep hsub hne).vertices ⊆ T.vertices := by
  intro w hw
  obtain ⟨l, hl, hwl⟩ := (T.prune keep hsub hne).mem_vertices_iff.mp hw
  exact T.mem_vertices_iff.mpr ⟨l, hsub hl, hwl⟩

def pruneEmbedding (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty) :
    (T.prune keep hsub hne).Node ↪ T.Node where
  toFun v := ⟨v.val, T.prune_vertices_subset keep hsub hne v.property⟩
  inj' := fun _ _ h => Subtype.ext (congrArg (fun v : T.Node => v.val) h)

@[simp] theorem pruneEmbedding_val (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty)
    (v : (T.prune keep hsub hne).Node) :
    (T.pruneEmbedding keep hsub hne v).val = v.val := rfl

@[simp] theorem pruneEmbedding_depth (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty)
    (v : (T.prune keep hsub hne).Node) :
    depth (T.pruneEmbedding keep hsub hne v) = depth v := rfl

@[simp] theorem pruneEmbedding_ancestor (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty)
    (u v : (T.prune keep hsub hne).Node) :
    ancestor (T.pruneEmbedding keep hsub hne u)
      (T.pruneEmbedding keep hsub hne v) ↔ ancestor u v := Iff.rfl

@[simp] theorem pruneEmbedding_child (T : UniformTree) (keep : Finset (List ℕ))
    (hsub : keep ⊆ T.leaves) (hne : keep.Nonempty)
    (u v : (T.prune keep hsub hne).Node) :
    child (T.pruneEmbedding keep hsub hne u)
      (T.pruneEmbedding keep hsub hne v) ↔ child u v := Iff.rfl

def projectMarks {T : UniformTree} (A : Finset T.Node) : Finset (List ℕ) :=
  A.image Subtype.val

@[simp] theorem mem_projectMarks {T : UniformTree} (A : Finset T.Node)
    (w : List ℕ) : w ∈ projectMarks A ↔ ∃ v ∈ A, v.val = w := by
  simp only [projectMarks, Finset.mem_image]

theorem projectMarks_filter_card {T : UniformTree} (A : Finset T.Node)
    (p : List ℕ → Prop) [DecidablePred p] :
    ((projectMarks A).filter p).card =
      (A.filter (fun v => p v.val)).card := by
  classical
  have heq : (projectMarks A).filter p =
      (A.filter (fun v => p v.val)).image Subtype.val := by
    ext w
    constructor
    · intro hw
      obtain ⟨hwA, hp⟩ := Finset.mem_filter.mp hw
      obtain ⟨v, hv, rfl⟩ := (mem_projectMarks A w).mp hwA
      exact Finset.mem_image.mpr ⟨v, Finset.mem_filter.mpr ⟨hv, hp⟩, rfl⟩
    · intro hw
      obtain ⟨v, hv, rfl⟩ := Finset.mem_image.mp hw
      exact Finset.mem_filter.mpr
        ⟨(mem_projectMarks A v.val).mpr ⟨v, (Finset.mem_filter.mp hv).1, rfl⟩,
          (Finset.mem_filter.mp hv).2⟩
  rw [heq, Finset.card_image_of_injective _ Subtype.val_injective]

theorem levelCount_projectMarks {T : UniformTree} (A : Finset T.Node) (ℓ : ℕ) :
    levelCount (projectMarks A) ℓ = (A.filter (fun v => depth v = ℓ)).card :=
  projectMarks_filter_card A (fun w => w.length = ℓ)

theorem colorCount_projectMarks {T : UniformTree} (A : Finset T.Node) (l : T.Node) :
    colorCount (projectMarks A) l.val = (A.filter (fun v => ancestor v l)).card :=
  projectMarks_filter_card A (fun w => w.IsPrefix l.val)

theorem root_not_projectMarks {T : UniformTree} (A : Finset T.Node)
    (h : T.root ∉ A) : [] ∉ projectMarks A := by
  intro hm
  obtain ⟨v, hv, hval⟩ := (mem_projectMarks A []).mp hm
  have heq : v = T.root := Subtype.ext hval
  exact h (heq ▸ hv)

def retainMarks (T : UniformTree) (marks : Finset (List ℕ)) : Finset T.Node :=
  Finset.univ.filter (fun v => v.val ∈ marks)

@[simp] theorem mem_retainMarks (T : UniformTree) (marks : Finset (List ℕ))
    (v : T.Node) : v ∈ T.retainMarks marks ↔ v.val ∈ marks := by
  simp only [retainMarks, Finset.mem_filter, Finset.mem_univ, true_and]

theorem mem_project_retainMarks (T : UniformTree) (marks : Finset (List ℕ))
    (w : List ℕ) : w ∈ projectMarks (T.retainMarks marks) ↔
      w ∈ marks ∧ w ∈ T.vertices := by
  constructor
  · intro hw
    obtain ⟨v, hv, rfl⟩ := (mem_projectMarks _ w).mp hw
    exact ⟨(mem_retainMarks T marks v).mp hv, v.property⟩
  · rintro ⟨hw, hv⟩
    exact (mem_projectMarks _ w).mpr
      ⟨⟨w, hv⟩, (mem_retainMarks T marks ⟨w, hv⟩).mpr hw, rfl⟩

theorem retainMarks_root_not_mem (T : UniformTree) (marks : Finset (List ℕ))
    (h : [] ∉ marks) : T.root ∉ T.retainMarks marks := by
  simpa only [mem_retainMarks, root_val] using h

theorem retainMarks_level_le (T : UniformTree) (marks : Finset (List ℕ)) (ℓ : ℕ) :
    ((T.retainMarks marks).filter (fun v => depth v = ℓ)).card ≤
      levelCount marks ℓ := by
  rw [← levelCount_projectMarks]
  apply Finset.card_le_card
  intro w hw
  obtain ⟨hw, hlen⟩ := Finset.mem_filter.mp hw
  exact Finset.mem_filter.mpr ⟨((T.mem_project_retainMarks marks w).mp hw).1, hlen⟩

theorem retainMarks_leaf_count (T : UniformTree) (marks : Finset (List ℕ))
    (l : T.Node) (hl : leaf l) :
    ((T.retainMarks marks).filter (fun v => ancestor v l)).card =
      colorCount marks l.val := by
  rw [← colorCount_projectMarks]
  apply congrArg Finset.card
  ext w
  constructor
  · intro hw
    obtain ⟨hw, hp⟩ := Finset.mem_filter.mp hw
    exact Finset.mem_filter.mpr ⟨((T.mem_project_retainMarks marks w).mp hw).1, hp⟩
  · intro hw
    obtain ⟨hw, hp⟩ := Finset.mem_filter.mp hw
    exact Finset.mem_filter.mpr
      ⟨(T.mem_project_retainMarks marks w).mpr
        ⟨hw, T.mem_vertices_iff.mpr ⟨l.val, hl, hp⟩⟩, hp⟩

end UniformTree

open UniformTree

structure CompetingTrees (d : ℕ) where
  plus : UniformTree
  minus : UniformTree
  height : ℕ
  height_pos : 0 < height
  plus_height : plus.height = height
  minus_height : minus.height = height
  quota : ℕ → ℕ
  quota_pos : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ height → 0 < quota ℓ
  markingPlus : Finset plus.Node
  markingMinus : Finset minus.Node
  plus_root_not_marked : plus.root ∉ markingPlus
  minus_root_not_marked : minus.root ∉ markingMinus
  plus_quota : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ height →
    (markingPlus.filter (fun v => depth v = ℓ)).card ≤ quota ℓ
  minus_quota : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ height →
    (markingMinus.filter (fun v => depth v = ℓ)).card ≤ quota ℓ
  plus_rich : ∀ l : plus.Node, leaf l →
    d ≤ (markingPlus.filter (fun v => ancestor v l)).card
  minus_rich : ∀ l : minus.Node, leaf l →
    d ≤ (markingMinus.filter (fun v => ancestor v l)).card
  shared_obstruction : ∀ (Aplus : Finset plus.Node) (Aminus : Finset minus.Node),
    plus.root ∉ Aplus → minus.root ∉ Aminus →
    (∀ ℓ, 1 ≤ ℓ → ℓ ≤ height →
      (Aplus.filter (fun v => depth v = ℓ)).card +
      (Aminus.filter (fun v => depth v = ℓ)).card ≤ quota ℓ) →
    (∃ l : plus.Node, leaf l ∧ ∀ v ∈ Aplus, ¬ ancestor v l) ∨
    (∃ l : minus.Node, leaf l ∧ ∀ v ∈ Aminus, ¬ ancestor v l)

namespace AuxiliaryTree

def richLeaves {n : ℕ} (aux : AuxiliaryTree n)
    (marks : Finset (List ℕ)) (d : ℕ) : Finset (List ℕ) :=
  aux.tree.leaves.filter (fun l => d ≤ colorCount marks l)

theorem richLeaves_subset {n : ℕ} (aux : AuxiliaryTree n)
    (marks : Finset (List ℕ)) (d : ℕ) :
    aux.richLeaves marks d ⊆ aux.tree.leaves := Finset.filter_subset _ _

theorem richLeaves_nonempty {n d : ℕ} (aux : AuxiliaryTree n)
    (marks : Finset (List ℕ)) (h : d ≤ n)
    (hw : ∃ l ∈ aux.tree.leaves, colorCount marks l = n) :
    (aux.richLeaves marks d).Nonempty := by
  obtain ⟨l, hl, heq⟩ := hw
  exact ⟨l, Finset.mem_filter.mpr ⟨hl, heq.symm ▸ h⟩⟩

theorem richLeaves_cover {d : ℕ} (aux : AuxiliaryTree (2 * d - 1))
    (l : List ℕ) (hl : l ∈ aux.tree.leaves) :
    l ∈ aux.richLeaves aux.red d ∨ l ∈ aux.richLeaves aux.blue d := by
  have htotal := aux.total_count l hl
  have hrich : d ≤ colorCount aux.red l ∨ d ≤ colorCount aux.blue l := by omega
  exact hrich.imp (fun h => Finset.mem_filter.mpr ⟨hl, h⟩)
    (fun h => Finset.mem_filter.mpr ⟨hl, h⟩)

theorem height_pos {n : ℕ} (aux : AuxiliaryTree n) (hn : 0 < n) :
    0 < aux.tree.height := by
  obtain ⟨l, hl, hcount⟩ := aux.red_witness
  by_contra hpos
  have hheight : aux.tree.height = 0 := by omega
  have hl_nil : l = [] := List.length_eq_zero_iff.mp ((aux.tree.length_leaf l hl).trans hheight)
  have hempty : aux.red.filter (fun w => w.IsPrefix l) = ∅ := by
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro w hw
    obtain ⟨hred, hp⟩ := Finset.mem_filter.mp hw
    have hw_nil : w = [] := by
      apply List.length_eq_zero_iff.mp
      have hle := hp.length_le
      rw [hl_nil] at hle
      exact Nat.eq_zero_of_le_zero hle
    exact aux.root_not_red (hw_nil ▸ hred)
  have hz : colorCount aux.red l = 0 := by rw [colorCount, hempty, Finset.card_empty]
  omega

def richTree {n d : ℕ} (aux : AuxiliaryTree n) (marks : Finset (List ℕ))
    (hne : (aux.richLeaves marks d).Nonempty) : UniformTree :=
  aux.tree.prune (aux.richLeaves marks d) (aux.richLeaves_subset marks d) hne

end AuxiliaryTree

theorem levelCount_project_union {T U : UniformTree}
    (A : Finset T.Node) (B : Finset U.Node) (ℓ : ℕ) :
    levelCount (projectMarks A ∪ projectMarks B) ℓ ≤
      (A.filter (fun v => depth v = ℓ)).card +
      (B.filter (fun v => depth v = ℓ)).card := by
  have heq : (projectMarks A ∪ projectMarks B).filter (fun w => w.length = ℓ) =
      (projectMarks A).filter (fun w => w.length = ℓ) ∪
      (projectMarks B).filter (fun w => w.length = ℓ) := by
    ext w
    simp only [Finset.mem_filter, Finset.mem_union, or_and_right]
  unfold levelCount
  rw [heq]
  exact (Finset.card_union_le _ _).trans_eq
    (congrArg₂ (· + ·) (levelCount_projectMarks A ℓ) (levelCount_projectMarks B ℓ))

namespace CompetingTrees

def quotaTotal {d : ℕ} (T : CompetingTrees d) : ℕ :=
  ∑ ℓ ∈ Finset.Icc 1 T.height, T.quota ℓ

theorem markingPlus_depth_pos {d : ℕ} (T : CompetingTrees d)
    (v : T.plus.Node) (hv : v ∈ T.markingPlus) : 0 < depth v := by
  have hne : v ≠ T.plus.root := fun h => T.plus_root_not_marked (h ▸ hv)
  have hn := mt (eq_root_iff_depth_eq_zero v).mpr hne
  exact Nat.pos_of_ne_zero hn

theorem markingMinus_depth_pos {d : ℕ} (T : CompetingTrees d)
    (v : T.minus.Node) (hv : v ∈ T.markingMinus) : 0 < depth v := by
  have hne : v ≠ T.minus.root := fun h => T.minus_root_not_marked (h ▸ hv)
  have hn := mt (eq_root_iff_depth_eq_zero v).mpr hne
  exact Nat.pos_of_ne_zero hn

def ofAuxiliary (d : ℕ) (hd : 0 < d) (aux : AuxiliaryTree (2 * d - 1)) :
    CompetingTrees d := by
  have hdn : d ≤ 2 * d - 1 := by omega
  have hred := aux.richLeaves_nonempty aux.red hdn aux.red_witness
  have hblue := aux.richLeaves_nonempty aux.blue hdn aux.blue_witness
  let plus := aux.richTree aux.red hred
  let minus := aux.richTree aux.blue hblue
  refine
    { plus := plus
      minus := minus
      height := aux.tree.height
      height_pos := aux.height_pos (by omega)
      plus_height := rfl
      minus_height := rfl
      quota := aux.quota
      quota_pos := aux.quota_pos
      markingPlus := plus.retainMarks aux.red
      markingMinus := minus.retainMarks aux.blue
      plus_root_not_marked := plus.retainMarks_root_not_mem aux.red aux.root_not_red
      minus_root_not_marked := minus.retainMarks_root_not_mem aux.blue aux.root_not_blue
      plus_quota := ?_
      minus_quota := ?_
      plus_rich := ?_
      minus_rich := ?_
      shared_obstruction := ?_ }
  · intro ℓ hℓ hℓ'
    exact (plus.retainMarks_level_le aux.red ℓ).trans (aux.red_level ℓ hℓ hℓ')
  · intro ℓ hℓ hℓ'
    exact (minus.retainMarks_level_le aux.blue ℓ).trans (aux.blue_level ℓ hℓ hℓ')
  · intro l hl
    rw [plus.retainMarks_leaf_count aux.red l hl]
    exact (Finset.mem_filter.mp hl).2
  · intro l hl
    rw [minus.retainMarks_leaf_count aux.blue l hl]
    exact (Finset.mem_filter.mp hl).2
  · intro A B hA hB hquota
    have hproject : RespectsTreeQuota aux.tree aux.quota (projectMarks A ∪ projectMarks B) := by
      constructor
      · intro h
        rcases Finset.mem_union.mp h with h | h
        · exact root_not_projectMarks A hA h
        · exact root_not_projectMarks B hB h
      · intro ℓ hℓ hℓ'
        exact (levelCount_project_union A B ℓ).trans (hquota ℓ hℓ hℓ')
    obtain ⟨l, hl, havoid⟩ := aux.avoids _ hproject
    rcases aux.richLeaves_cover l hl with hredLeaf | hblueLeaf
    · left
      have hlplus : l ∈ plus.leaves := hredLeaf
      refine ⟨⟨l, plus.leaf_mem_vertices hlplus⟩, hlplus, ?_⟩
      intro v hv hp
      exact Finset.disjoint_left.mp havoid
        (Finset.mem_union_left _ ((mem_projectMarks A v.val).mpr ⟨v, hv, rfl⟩))
        (mem_prefixes_iff.mpr hp)
    · right
      have hlminus : l ∈ minus.leaves := hblueLeaf
      refine ⟨⟨l, minus.leaf_mem_vertices hlminus⟩, hlminus, ?_⟩
      intro v hv hp
      exact Finset.disjoint_left.mp havoid
        (Finset.mem_union_right _ ((mem_projectMarks B v.val).mpr ⟨v, hv, rfl⟩))
        (mem_prefixes_iff.mpr hp)

end CompetingTrees

end BinPackingGap

end OAI
end LocalizedSource24
/- END LOCALIZED SOURCE 24/44: OAI/Computability/BinPacking/Trees/TreePruning.lean -/

/- BEGIN LOCALIZED SOURCE 25/44: OAI/Computability/BinPacking/Trees/TreeColorCounts.lean
   SHA256: fb8a3672ff96f4869d38c226c11f7f16b9f0ad0eea0a4bc4b578b75dbb574143 -/
section LocalizedSource25
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Data.Finset.Prod
-- localized import: Mathlib.Order.Interval.Finset.Nat
-- localized import: Mathlib.Tactic.SplitIfs
-- localized import: OAI.Computability.BinPacking.Trees.TreeAttachment
-- localized import: OAI.Computability.BinPacking.Trees.TreePruning

namespace OAI

namespace BinPackingGap

section

open scoped BigOperators

def phaseQuota (j : ℕ) : ℕ := 2 ^ (j - 1)

@[simp] theorem phaseQuota_succ (j : ℕ) : phaseQuota (j + 1) = 2 ^ j := by
  simp [phaseQuota]

theorem phaseQuota_pos (j : ℕ) : 0 < phaseQuota j := by
  exact Nat.pow_pos (by decide)

def shiftedPhaseQuota (h depth : ℕ) : ℕ := phaseQuota (depth - h)

@[simp] theorem shiftedPhaseQuota_add (h j : ℕ) :
    shiftedPhaseQuota h (h + j) = phaseQuota j := by
  simp [shiftedPhaseQuota]

theorem shiftedPhaseQuota_pos (h depth : ℕ) : 0 < shiftedPhaseQuota h depth :=
  phaseQuota_pos (depth - h)

theorem sum_phaseQuota_add_one (i : ℕ) :
    (∑ j ∈ Finset.Icc 1 i, phaseQuota j) + 1 = 2 ^ i := by
  induction i with
  | zero => simp
  | succ i ih =>
      have hset : Finset.Icc 1 (i + 1) = insert (i + 1) (Finset.Icc 1 i) := by
        ext j
        simp only [Finset.mem_Icc, Finset.mem_insert]
        omega
      have hnot : i + 1 ∉ Finset.Icc 1 i := by simp
      rw [hset, Finset.sum_insert hnot, phaseQuota_succ, pow_succ]
      omega

theorem sum_phaseQuota (i : ℕ) :
    (∑ j ∈ Finset.Icc 1 i, phaseQuota j) = 2 ^ i - 1 := by
  have h := sum_phaseQuota_add_one i
  omega

theorem sum_phaseQuota_lt (i : ℕ) :
    (∑ j ∈ Finset.Icc 1 i, phaseQuota j) < 2 ^ i := by
  have h := sum_phaseQuota_add_one i
  omega

theorem sum_phaseQuota_initial_add_tail {i N : ℕ} (hiN : i ≤ N) :
    (∑ j ∈ Finset.Icc 1 i, phaseQuota j) +
      (∑ j ∈ Finset.Icc (i + 1) N, phaseQuota j) =
      ∑ j ∈ Finset.Icc 1 N, phaseQuota j := by
  have hset : Finset.Icc 1 N = Finset.Icc 1 i ∪ Finset.Icc (i + 1) N := by
    ext j
    simp only [Finset.mem_Icc, Finset.mem_union]
    omega
  have hd : Disjoint (Finset.Icc 1 i) (Finset.Icc (i + 1) N) := by
    apply Finset.disjoint_left.mpr
    intro j hj hk
    simp only [Finset.mem_Icc] at hj hk
    omega
  rw [hset, Finset.sum_union hd]

theorem sum_phaseQuota_tail {i N : ℕ} (hiN : i ≤ N) :
    (∑ j ∈ Finset.Icc (i + 1) N, phaseQuota j) = 2 ^ N - 2 ^ i := by
  have hsplit := sum_phaseQuota_initial_add_tail hiN
  have hi := sum_phaseQuota_add_one i
  have hN := sum_phaseQuota_add_one N
  omega

def continuationCount (i N : ℕ) : ℕ :=
  1 + ∑ j ∈ Finset.Icc (i + 1) N, phaseQuota j

theorem continuationCount_pos (i N : ℕ) : 0 < continuationCount i N := by
  unfold continuationCount
  omega

@[simp] theorem continuationCount_self (N : ℕ) : continuationCount N N = 1 := by
  simp [continuationCount]

theorem continuationCount_eq {i N : ℕ} (hiN : i ≤ N) :
    continuationCount i N = 1 + (2 ^ N - 2 ^ i) := by
  rw [continuationCount, sum_phaseQuota_tail hiN]

section FiniteMarkings

variable {α : Type*}

theorem card_rank_window_eq (A : Finset α) (rank : α → ℕ) (h lo hi : ℕ) :
    (A.filter (fun x => h + lo < rank x ∧ rank x ≤ h + hi)).card =
      ∑ j ∈ Finset.Icc (lo + 1) hi,
        (A.filter (fun x => rank x = h + j)).card := by
  classical
  calc
    (A.filter (fun x => h + lo < rank x ∧ rank x ≤ h + hi)).card =
        (A.filter (fun x => rank x - h ∈ Finset.Icc (lo + 1) hi)).card := by
      apply congrArg Finset.card
      ext x
      simp only [Finset.mem_filter, Finset.mem_Icc]
      constructor
      · rintro ⟨hx, hlo, hhi⟩
        exact ⟨hx, by omega, by omega⟩
      · rintro ⟨hx, hlo, hhi⟩
        exact ⟨hx, by omega, by omega⟩
    _ = ∑ j ∈ Finset.Icc (lo + 1) hi,
        (A.filter (fun x => rank x - h = j)).card :=
      (Finset.sum_card_fiberwise_eq_card_filter A
        (Finset.Icc (lo + 1) hi) (fun x => rank x - h)).symm
    _ = _ := by
      apply Finset.sum_congr rfl
      intro j hj
      have hjpos : 1 ≤ j := by
        have := (Finset.mem_Icc.mp hj).1
        omega
      apply congrArg Finset.card
      ext x
      simp only [Finset.mem_filter]
      constructor
      · rintro ⟨hx, hxrank⟩
        exact ⟨hx, by omega⟩
      · rintro ⟨hx, hxrank⟩
        exact ⟨hx, by omega⟩

theorem card_rank_window_le (A : Finset α) (rank : α → ℕ) (q : ℕ → ℕ)
    (h lo hi : ℕ)
    (hquota : ∀ j ∈ Finset.Icc (lo + 1) hi,
      (A.filter (fun x => rank x = h + j)).card ≤ q j) :
    (A.filter (fun x => h + lo < rank x ∧ rank x ≤ h + hi)).card ≤
      ∑ j ∈ Finset.Icc (lo + 1) hi, q j := by
  rw [card_rank_window_eq]
  exact Finset.sum_le_sum hquota

theorem card_rank_interval_le (A : Finset α) (rank : α → ℕ) (p : ℕ → ℕ)
    (h i : ℕ)
    (hquota : ∀ j ∈ Finset.Icc 1 i,
      (A.filter (fun x => rank x = h + j)).card ≤ p (h + j)) :
    (A.filter (fun x => h < rank x ∧ rank x ≤ h + i)).card ≤
      ∑ j ∈ Finset.Icc 1 i, p (h + j) := by
  simpa only [Nat.add_zero, Nat.zero_add] using
    card_rank_window_le A rank (fun j => p (h + j)) h 0 i hquota

theorem card_rank_initial_lt_pow (A : Finset α) (rank : α → ℕ) (h i : ℕ)
    (hquota : ∀ j ∈ Finset.Icc 1 i,
      (A.filter (fun x => rank x = h + j)).card ≤ phaseQuota j) :
    (A.filter (fun x => h < rank x ∧ rank x ≤ h + i)).card < 2 ^ i := by
  have hle := card_rank_window_le A rank phaseQuota h 0 i hquota
  simp only [Nat.add_zero, Nat.zero_add] at hle
  exact lt_of_le_of_lt hle (sum_phaseQuota_lt i)

theorem card_rank_tail_lt_continuations (A : Finset α) (rank : α → ℕ)
    (h i N : ℕ)
    (hquota : ∀ j ∈ Finset.Icc (i + 1) N,
      (A.filter (fun x => rank x = h + j)).card ≤ phaseQuota j) :
    (A.filter (fun x => h + i < rank x ∧ rank x ≤ h + N)).card <
      continuationCount i N := by
  have hle := card_rank_window_le A rank phaseQuota h i N hquota
  unfold continuationCount
  omega

end FiniteMarkings

theorem card_length_interval_le {β : Type*} (A : Finset (List β)) (p : ℕ → ℕ)
    (h i : ℕ)
    (hquota : ∀ j ∈ Finset.Icc 1 i,
      (A.filter (fun w => w.length = h + j)).card ≤ p (h + j)) :
    (A.filter (fun w => h < w.length ∧ w.length ≤ h + i)).card ≤
      ∑ j ∈ Finset.Icc 1 i, p (h + j) :=
  card_rank_interval_le A List.length p h i hquota

end

section
namespace ForkGadget

open scoped BigOperators

def spine (i a : ℕ) : List ℕ := (a + 1) :: List.replicate (i - 1) 1

def continuation (N i b : ℕ) : List ℕ :=
  if i < N then (b + 1) :: List.replicate (N - i - 1) 1 else []

def leafWord (N i a b : ℕ) : List ℕ := spine i a ++ continuation N i b

def leaves (N i : ℕ) : Finset (List ℕ) :=
  ((Finset.range (2 ^ i)).product (Finset.range (continuationCount i N))).image
    (fun ab => leafWord N i ab.1 ab.2)

@[simp] theorem spine_length {i : ℕ} (hi : 1 ≤ i) (a : ℕ) :
    (spine i a).length = i := by
  simp only [spine, List.length_cons, List.length_replicate]
  omega

@[simp] theorem continuation_length {N i : ℕ} (hiN : i ≤ N) (b : ℕ) :
    (continuation N i b).length = N - i := by
  unfold continuation
  split_ifs with h
  · simp only [List.length_cons, List.length_replicate]
    omega
  · simp only [List.length_nil]
    omega

@[simp] theorem leafWord_length {N i : ℕ} (hi : 1 ≤ i) (hiN : i ≤ N)
    (a b : ℕ) : (leafWord N i a b).length = N := by
  simp only [leafWord, List.length_append, spine_length hi, continuation_length hiN]
  omega

theorem spine_injective (i : ℕ) : Function.Injective (spine i) := by
  intro a b h
  have heq : a + 1 = b + 1 := (List.cons.inj h).1
  omega

theorem leafWord_positive (N i a b : ℕ) :
    ∀ x ∈ leafWord N i a b, 0 < x := by
  intro x hx
  simp only [leafWord, List.mem_append] at hx
  rcases hx with hx | hx
  · simp only [spine, List.mem_cons, List.mem_replicate] at hx
    rcases hx with rfl | ⟨_, rfl⟩ <;> omega
  · unfold continuation at hx
    split_ifs at hx with h
    · simp only [List.mem_cons, List.mem_replicate] at hx
      rcases hx with rfl | ⟨_, rfl⟩ <;> omega
    · simp only [List.not_mem_nil] at hx

theorem leafWord_mem {N i a b : ℕ} (ha : a < 2 ^ i)
    (hb : b < continuationCount i N) : leafWord N i a b ∈ leaves N i := by
  exact Finset.mem_image.mpr ⟨(a, b), Finset.mem_product.mpr
    ⟨Finset.mem_range.mpr ha, Finset.mem_range.mpr hb⟩, rfl⟩

theorem mem_leaves_iff {N i : ℕ} {l : List ℕ} :
    l ∈ leaves N i ↔ ∃ a < 2 ^ i, ∃ b < continuationCount i N,
      leafWord N i a b = l := by
  constructor
  · intro hl
    obtain ⟨ab, hab, heq⟩ := Finset.mem_image.mp hl
    have hab' := Finset.mem_product.mp hab
    exact ⟨ab.1, Finset.mem_range.mp hab'.1, ab.2,
      Finset.mem_range.mp hab'.2, heq⟩
  · rintro ⟨a, ha, b, hb, rfl⟩
    exact leafWord_mem ha hb

def tree (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) : UniformTree where
  height := N
  leaves := leaves N i
  leaves_nonempty := ⟨leafWord N i 0 0,
    leafWord_mem (Nat.two_pow_pos i) (continuationCount_pos i N)⟩
  length_leaf := by
    intro l hl
    obtain ⟨a, ha, b, hb, rfl⟩ := mem_leaves_iff.mp hl
    exact leafWord_length hi hiN a b
  positive_labels := by
    intro l hl
    obtain ⟨a, ha, b, hb, rfl⟩ := mem_leaves_iff.mp hl
    exact leafWord_positive N i a b

@[simp] theorem tree_height (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) :
    (tree N i hi hiN).height = N := rfl

def red (i : ℕ) : Finset (List ℕ) :=
  (Finset.range (phaseQuota i)).image (spine i)

def blue (i : ℕ) : Finset (List ℕ) :=
  (Finset.Ico (phaseQuota i) (2 ^ i)).image (spine i)

theorem two_mul_phaseQuota {i : ℕ} (hi : 1 ≤ i) : 2 * phaseQuota i = 2 ^ i := by
  obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : i ≠ 0)
  simp [phaseQuota, pow_succ, Nat.mul_comm]

theorem card_red (i : ℕ) : (red i).card = phaseQuota i := by
  rw [red, Finset.card_image_of_injective _ (spine_injective i), Finset.card_range]

theorem card_blue {i : ℕ} (hi : 1 ≤ i) : (blue i).card = phaseQuota i := by
  rw [blue, Finset.card_image_of_injective _ (spine_injective i), Nat.card_Ico]
  have h := two_mul_phaseQuota hi
  omega

theorem red_depth {i : ℕ} (hi : 1 ≤ i) {w : List ℕ} (hw : w ∈ red i) :
    w.length = i := by
  obtain ⟨a, _, rfl⟩ := Finset.mem_image.mp hw
  exact spine_length hi a

theorem blue_depth {i : ℕ} (hi : 1 ≤ i) {w : List ℕ} (hw : w ∈ blue i) :
    w.length = i := by
  obtain ⟨a, _, rfl⟩ := Finset.mem_image.mp hw
  exact spine_length hi a

theorem root_not_red {i : ℕ} (hi : 1 ≤ i) : [] ∉ red i := by
  intro h
  have := red_depth hi h
  simp only [List.length_nil] at this
  omega

theorem root_not_blue {i : ℕ} (hi : 1 ≤ i) : [] ∉ blue i := by
  intro h
  have := blue_depth hi h
  simp only [List.length_nil] at this
  omega

theorem red_blue_disjoint (i : ℕ) : Disjoint (red i) (blue i) := by
  apply Finset.disjoint_left.mpr
  intro w hr hb
  obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hr
  obtain ⟨b, hb, heq⟩ := Finset.mem_image.mp hb
  have hab := spine_injective i heq
  have hlt := Finset.mem_range.mp ha
  have hle := (Finset.mem_Ico.mp hb).1
  omega

theorem spine_mem_vertices {N i : ℕ} (hi : 1 ≤ i) (hiN : i ≤ N)
    {a : ℕ} (ha : a < 2 ^ i) : spine i a ∈ (tree N i hi hiN).vertices := by
  apply (tree N i hi hiN).mem_vertices_iff.mpr
  exact ⟨leafWord N i a 0, leafWord_mem ha (continuationCount_pos i N),
    List.prefix_append _ _⟩

theorem red_subset {N i : ℕ} (hi : 1 ≤ i) (hiN : i ≤ N) :
    red i ⊆ (tree N i hi hiN).vertices := by
  intro w hw
  obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hw
  apply spine_mem_vertices hi hiN
  have hlt := Finset.mem_range.mp ha
  have hp := phaseQuota_pos i
  have heq := two_mul_phaseQuota hi
  omega

theorem blue_subset {N i : ℕ} (hi : 1 ≤ i) (hiN : i ≤ N) :
    blue i ⊆ (tree N i hi hiN).vertices := by
  intro w hw
  obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hw
  exact spine_mem_vertices hi hiN (Finset.mem_Ico.mp ha).2

private theorem level_le_of_single_depth (marks : Finset (List ℕ)) (i : ℕ)
    (hdepth : ∀ w ∈ marks, w.length = i) (hcard : marks.card = phaseQuota i)
    (depth : ℕ) : levelCount marks depth ≤ phaseQuota depth := by
  by_cases h : depth = i
  · subst depth
    exact (Finset.card_filter_le marks _).trans_eq hcard
  · have hf : marks.filter (fun w => w.length = depth) = ∅ := by
      apply Finset.filter_eq_empty_iff.mpr
      intro w hw hd
      exact h (hd.symm.trans (hdepth w hw))
    simp only [levelCount, hf, Finset.card_empty, Nat.zero_le]

theorem red_level {i : ℕ} (hi : 1 ≤ i) (depth : ℕ) :
    levelCount (red i) depth ≤ phaseQuota depth :=
  level_le_of_single_depth (red i) i (fun _ hw => red_depth hi hw) (card_red i) depth

theorem blue_level {i : ℕ} (hi : 1 ≤ i) (depth : ℕ) :
    levelCount (blue i) depth ≤ phaseQuota depth :=
  level_le_of_single_depth (blue i) i (fun _ hw => blue_depth hi hw) (card_blue hi) depth

theorem spine_prefix_leafWord_iff {N i a b c : ℕ} (hi : 1 ≤ i) :
    (spine i c).IsPrefix (leafWord N i a b) ↔ c = a := by
  constructor
  · intro h
    have hs : (spine i a).IsPrefix (leafWord N i a b) := List.prefix_append _ _
    rcases List.prefix_or_prefix_of_prefix h hs with hca | hac
    · exact spine_injective i (hca.eq_of_length (by rw [spine_length hi, spine_length hi]))
    · exact (spine_injective i (hac.eq_of_length
        (by rw [spine_length hi, spine_length hi]))).symm
  · rintro rfl
    exact List.prefix_append _ _

private theorem colorCount_spines (I : Finset ℕ) {N i : ℕ} (hi : 1 ≤ i)
    (a b : ℕ) : colorCount (I.image (spine i)) (leafWord N i a b) =
      if a ∈ I then 1 else 0 := by
  have hf : (I.image (spine i)).filter (fun w => w.IsPrefix (leafWord N i a b)) =
      if a ∈ I then {spine i a} else ∅ := by
    ext w
    by_cases ha : a ∈ I
    · simp only [ha, ite_true, Finset.mem_filter, Finset.mem_singleton]
      constructor
      · rintro ⟨hw, hp⟩
        obtain ⟨c, hc, rfl⟩ := Finset.mem_image.mp hw
        rw [(spine_prefix_leafWord_iff hi).mp hp]
      · rintro rfl
        exact ⟨Finset.mem_image.mpr ⟨a, ha, rfl⟩, List.prefix_append _ _⟩
    · simp only [ha, ite_false, Finset.mem_filter]
      constructor
      · rintro ⟨hw, hp⟩
        obtain ⟨c, hc, rfl⟩ := Finset.mem_image.mp hw
        exact (ha ((spine_prefix_leafWord_iff hi).mp hp ▸ hc)).elim
      · simp
  unfold colorCount
  rw [hf]
  split_ifs <;> simp

theorem red_count {N i : ℕ} (hi : 1 ≤ i) (a b : ℕ) :
    colorCount (red i) (leafWord N i a b) = if a < phaseQuota i then 1 else 0 := by
  simpa only [red, Finset.mem_range] using
    colorCount_spines (Finset.range (phaseQuota i)) (N := N) hi a b

theorem blue_count {N i : ℕ} (hi : 1 ≤ i) (a b : ℕ) :
    colorCount (blue i) (leafWord N i a b) =
      if phaseQuota i ≤ a ∧ a < 2 ^ i then 1 else 0 := by
  simpa only [blue, Finset.mem_Ico] using
    colorCount_spines (Finset.Ico (phaseQuota i) (2 ^ i)) (N := N) hi a b

theorem total_count {N i : ℕ} (hi : 1 ≤ i) {l : List ℕ} (hl : l ∈ leaves N i) :
    colorCount (red i) l + colorCount (blue i) l = 1 := by
  obtain ⟨a, ha, b, hb, rfl⟩ := mem_leaves_iff.mp hl
  rw [red_count hi, blue_count hi]
  split_ifs <;> omega

theorem red_witness {N i : ℕ} (hi : 1 ≤ i) :
    ∃ l ∈ leaves N i, colorCount (red i) l = 1 := by
  refine ⟨leafWord N i 0 0,
    leafWord_mem (Nat.two_pow_pos i) (continuationCount_pos i N), ?_⟩
  rw [red_count hi, ite_eq_left (phaseQuota_pos i)]

theorem blue_witness {N i : ℕ} (hi : 1 ≤ i) :
    ∃ l ∈ leaves N i, colorCount (blue i) l = 1 := by
  have hlt : phaseQuota i < 2 ^ i := by
    have hp := phaseQuota_pos i
    have heq := two_mul_phaseQuota hi
    omega
  refine ⟨leafWord N i (phaseQuota i) 0,
    leafWord_mem hlt (continuationCount_pos i N), ?_⟩
  rw [blue_count hi, ite_eq_left ⟨le_rfl, hlt⟩]

theorem avoids {N i : ℕ} (hi : 1 ≤ i) (hiN : i ≤ N)
    (A : Finset (List ℕ)) (hroot : [] ∉ A)
    (hquota : ∀ j, 1 ≤ j → j ≤ N → levelCount A j ≤ phaseQuota j) :
    ∃ l ∈ leaves N i, Disjoint A (UniformTree.prefixes l) := by
  let early := A.filter (fun w => 0 < w.length ∧ w.length ≤ i)
  have hearly : early.card < (Finset.range (2 ^ i)).card := by
    simpa only [early, Nat.zero_add, Finset.card_range] using
      card_rank_initial_lt_pow A List.length 0 i (by
        intro j hj
        have hj' := Finset.mem_Icc.mp hj
        simpa only [levelCount, Nat.zero_add] using hquota j hj'.1 (hj'.2.trans hiN))
  have hspines : (Finset.range (2 ^ i) : Set ℕ).PairwiseDisjoint
      (fun a => (UniformTree.prefixes (spine i a)).erase []) := by
    intro a ha b hb hab
    exact disjoint_positive_spine_prefixes hab
  obtain ⟨a, ha, hclear⟩ := exists_disjoint_of_card_lt
    (Finset.range (2 ^ i)) early
    (fun a => (UniformTree.prefixes (spine i a)).erase []) hspines hearly
  have ha' : a < 2 ^ i := Finset.mem_range.mp ha
  have hspine : Disjoint A (UniformTree.prefixes (spine i a)) := by
    apply Finset.disjoint_left.mpr
    intro w hwA hwpath
    by_cases hw : w = []
    · exact hroot (hw ▸ hwA)
    · have hp := UniformTree.mem_prefixes_iff.mp hwpath
      have hlen : w.length ≤ i := by simpa only [spine_length hi] using hp.length_le
      have he : w ∈ early := Finset.mem_filter.mpr
        ⟨hwA, List.length_pos_iff_ne_nil.mpr hw, hlen⟩
      exact Finset.disjoint_left.mp hclear he (Finset.mem_erase.mpr ⟨hw, hwpath⟩)
  by_cases hiN' : i < N
  · let late := A.filter (fun w => i < w.length ∧ w.length ≤ N)
    have hlate : late.card < (Finset.range (continuationCount i N)).card := by
      simpa only [late, Nat.zero_add, Finset.card_range] using
        card_rank_tail_lt_continuations A List.length 0 i N (by
          intro j hj
          have hj' := Finset.mem_Icc.mp hj
          simpa only [levelCount, Nat.zero_add] using hquota j (by omega) hj'.2)
    have hchains : (Finset.range (continuationCount i N) : Set ℕ).PairwiseDisjoint
        (fun b => prefixesAfter (spine i a) (continuation N i b)) := by
      intro b hb c hc hbc
      simp only [continuation, ite_eq_left hiN']
      exact disjoint_spine_prefixesAfter (spine i a) hbc
    obtain ⟨b, hb, hclear'⟩ := exists_disjoint_of_card_lt
      (Finset.range (continuationCount i N)) late
      (fun b => prefixesAfter (spine i a) (continuation N i b)) hchains hlate
    have hchain : Disjoint A (prefixesAfter (spine i a) (continuation N i b)) := by
      apply Finset.disjoint_left.mpr
      intro w hwA hwpath
      obtain ⟨v, hv, hp, hvw⟩ := mem_prefixesAfter_iff.mp hwpath
      have hvpos : 0 < v.length := List.length_pos_iff_ne_nil.mpr hv
      have hvlen : v.length ≤ N - i := by
        simpa only [continuation_length hiN] using hp.length_le
      have hwlen : w.length = i + v.length := by
        rw [← hvw, List.length_append, spine_length hi]
      have hl : w ∈ late := Finset.mem_filter.mpr ⟨hwA, by omega, by omega⟩
      exact Finset.disjoint_left.mp hclear' hl hwpath
    refine ⟨leafWord N i a b, leafWord_mem ha' (Finset.mem_range.mp hb), ?_⟩
    rw [leafWord, prefixes_append_eq]
    apply Finset.disjoint_left.mpr
    intro w hwA hw
    rcases Finset.mem_union.mp hw with hw | hw
    · exact Finset.disjoint_left.mp hspine hwA hw
    · exact Finset.disjoint_left.mp hchain hwA hw
  · refine ⟨leafWord N i a 0,
      leafWord_mem ha' (continuationCount_pos i N), ?_⟩
    simpa only [leafWord, continuation, ite_eq_right hiN', List.append_nil] using hspine

def auxiliary (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) : AuxiliaryTree 1 where
  tree := tree N i hi hiN
  quota := phaseQuota
  quota_pos := fun depth _ _ => phaseQuota_pos depth
  red := red i
  blue := blue i
  red_subset := red_subset hi hiN
  blue_subset := blue_subset hi hiN
  root_not_red := root_not_red hi
  root_not_blue := root_not_blue hi
  red_blue_disjoint := red_blue_disjoint i
  red_level := fun depth _ _ => red_level hi depth
  blue_level := fun depth _ _ => blue_level hi depth
  total_count := fun _ hl => total_count hi hl
  red_witness := red_witness hi
  blue_witness := blue_witness hi
  avoids := by
    intro A hA
    exact avoids hi hiN A hA.1 hA.2

@[simp] theorem auxiliary_height (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) :
    (auxiliary N i hi hiN).tree.height = N := rfl

@[simp] theorem auxiliary_quota (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) :
    (auxiliary N i hi hiN).quota = phaseQuota := rfl

theorem auxiliary_red_depth (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N)
    {w : List ℕ} (hw : w ∈ (auxiliary N i hi hiN).red) : w.length = i :=
  red_depth hi hw

theorem auxiliary_blue_depth (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N)
    {w : List ℕ} (hw : w ∈ (auxiliary N i hi hiN).blue) : w.length = i :=
  blue_depth hi hw

@[simp] theorem auxiliary_card_red (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) :
    (auxiliary N i hi hiN).red.card = phaseQuota i := card_red i

@[simp] theorem auxiliary_card_blue (N i : ℕ) (hi : 1 ≤ i) (hiN : i ≤ N) :
    (auxiliary N i hi hiN).blue.card = phaseQuota i := card_blue hi

end ForkGadget

open scoped BigOperators

namespace UniformTree

theorem marking_card_le (T : UniformTree) (A : Finset T.Node) (q : ℕ → ℕ)
    (hroot : T.root ∉ A)
    (hquota : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ T.height →
      (A.filter (fun v => depth v = ℓ)).card ≤ q ℓ) :
    A.card ≤ ∑ ℓ ∈ Finset.Icc 1 T.height, q ℓ := by
  have hpositive (v : T.Node) (hv : v ∈ A) : 0 < depth v := by
    apply Nat.pos_of_ne_zero
    intro hz
    have heq : v = T.root := (eq_root_iff_depth_eq_zero v).mpr hz
    exact hroot (heq ▸ hv)
  have hfilter : A.filter (fun v => 0 < depth v ∧ depth v ≤ T.height) = A := by
    apply Finset.filter_eq_self.mpr
    intro v hv
    exact ⟨hpositive v hv, depth_le_height v⟩
  have hsum := card_rank_window_le A depth q 0 0 T.height (by
    intro ℓ hℓ
    have hb := Finset.mem_Icc.mp hℓ
    simpa only [Nat.zero_add] using hquota ℓ hb.1 hb.2)
  simpa only [Nat.zero_add, hfilter] using hsum

end UniformTree

namespace CompetingTrees

theorem markingPlus_card_le {d : ℕ} (T : CompetingTrees d) :
    T.markingPlus.card ≤ T.quotaTotal := by
  have h := T.plus.marking_card_le T.markingPlus T.quota T.plus_root_not_marked (by
    intro ℓ hℓ hL
    exact T.plus_quota ℓ hℓ (by simpa only [T.plus_height] using hL))
  simpa only [T.plus_height, quotaTotal] using h

theorem markingMinus_card_le {d : ℕ} (T : CompetingTrees d) :
    T.markingMinus.card ≤ T.quotaTotal := by
  have h := T.minus.marking_card_le T.markingMinus T.quota T.minus_root_not_marked (by
    intro ℓ hℓ hL
    exact T.minus_quota ℓ hℓ (by simpa only [T.minus_height] using hL))
  simpa only [T.minus_height, quotaTotal] using h

end CompetingTrees
end

namespace UniformTree

def liftMarks (T : UniformTree) (M : T.leaves → Finset (List ℕ)) : Finset (List ℕ) :=
  Finset.univ.biUnion (fun l : T.leaves => (M l).image (fun w => l.val ++ w))

@[simp] theorem mem_liftMarks (T : UniformTree) (M : T.leaves → Finset (List ℕ))
    {x : List ℕ} :
    x ∈ T.liftMarks M ↔ ∃ l : T.leaves, ∃ w ∈ M l, x = l.val ++ w := by
  constructor
  · intro hx
    obtain ⟨l, _, hl⟩ := Finset.mem_biUnion.mp hx
    obtain ⟨w, hw, hx⟩ := Finset.mem_image.mp hl
    exact ⟨l, w, hw, hx.symm⟩
  · rintro ⟨l, w, hw, rfl⟩
    exact Finset.mem_biUnion.mpr
      ⟨l, Finset.mem_univ l, Finset.mem_image.mpr ⟨w, hw, rfl⟩⟩

theorem root_not_mem_lift (T : UniformTree) (M : T.leaves → Finset (List ℕ))
    (hroot : ∀ l, [] ∉ M l) : [] ∉ T.liftMarks M := by
  intro hx
  obtain ⟨l, w, hw, heq⟩ := (T.mem_liftMarks M).mp hx
  have hlen := congrArg List.length heq
  simp only [List.length_nil, List.length_append] at hlen
  have hwzero : w = [] := List.length_eq_zero_iff.mp (by omega)
  exact hroot l (hwzero ▸ hw)

theorem height_lt_length_of_mem_lift (T : UniformTree)
    (M : T.leaves → Finset (List ℕ)) (hroot : ∀ l, [] ∉ M l)
    {x : List ℕ} (hx : x ∈ T.liftMarks M) : T.height < x.length := by
  obtain ⟨l, w, hw, rfl⟩ := (T.mem_liftMarks M).mp hx
  have hwne : w.length ≠ 0 := by
    intro hz
    exact hroot l ((List.length_eq_zero_iff.mp hz) ▸ hw)
  rw [List.length_append, T.length_leaf l.val l.property]
  omega

theorem liftMarks_subset_graft_vertices (T : UniformTree)
    (G : T.leaves → UniformTree) (N : ℕ) (hG : ∀ l, (G l).height = N)
    (M : T.leaves → Finset (List ℕ)) (hM : ∀ l, M l ⊆ (G l).vertices) :
    T.liftMarks M ⊆ (T.graft G N hG).vertices := by
  intro x hx
  obtain ⟨l, w, hw, rfl⟩ := (T.mem_liftMarks M).mp hx
  exact T.append_mem_graft_vertices G N hG l (hM l hw)

theorem old_marks_disjoint_lift (T : UniformTree) (old : Finset (List ℕ))
    (M : T.leaves → Finset (List ℕ)) (hold : old ⊆ T.vertices)
    (hroot : ∀ l, [] ∉ M l) : Disjoint old (T.liftMarks M) := by
  apply Finset.disjoint_left.mpr
  intro x hxold hxlift
  have hle := T.length_le_height (hold hxold)
  have hlt := T.height_lt_length_of_mem_lift M hroot hxlift
  omega

theorem liftMarks_disjoint (T : UniformTree)
    (Mred Mblue : T.leaves → Finset (List ℕ))
    (hdisj : ∀ l, Disjoint (Mred l) (Mblue l)) :
    Disjoint (T.liftMarks Mred) (T.liftMarks Mblue) := by
  apply Finset.disjoint_left.mpr
  intro x hxred hxblue
  obtain ⟨l, u, hu, hequ⟩ := (T.mem_liftMarks Mred).mp hxred
  obtain ⟨m, v, hv, heqv⟩ := (T.mem_liftMarks Mblue).mp hxblue
  obtain ⟨hlm, huv⟩ := (T.append_eq_append_iff l m u v).mp (hequ.symm.trans heqv)
  subst m
  subst v
  exact Finset.disjoint_left.mp (hdisj l) hu hv

theorem union_liftMarks_disjoint (T : UniformTree) (red blue : Finset (List ℕ))
    (Mred Mblue : T.leaves → Finset (List ℕ))
    (hred : red ⊆ T.vertices) (hblue : blue ⊆ T.vertices)
    (hrootred : ∀ l, [] ∉ Mred l) (hrootblue : ∀ l, [] ∉ Mblue l)
    (hold : Disjoint red blue) (hlocal : ∀ l, Disjoint (Mred l) (Mblue l)) :
    Disjoint (red ∪ T.liftMarks Mred) (blue ∪ T.liftMarks Mblue) := by
  apply Finset.disjoint_left.mpr
  intro x hxred hxblue
  rcases Finset.mem_union.mp hxred with hxred | hxred
  · rcases Finset.mem_union.mp hxblue with hxblue | hxblue
    · exact Finset.disjoint_left.mp hold hxred hxblue
    · exact Finset.disjoint_left.mp
        (T.old_marks_disjoint_lift red Mblue hred hrootblue) hxred hxblue
  · rcases Finset.mem_union.mp hxblue with hxblue | hxblue
    · exact Finset.disjoint_left.mp
        (T.old_marks_disjoint_lift blue Mred hblue hrootred) hxblue hxred
    · exact Finset.disjoint_left.mp (T.liftMarks_disjoint Mred Mblue hlocal) hxred hxblue

theorem filter_liftMarks_prefix (T : UniformTree)
    (M : T.leaves → Finset (List ℕ)) (l : T.leaves) (w : List ℕ) :
    (T.liftMarks M).filter (fun x => x.IsPrefix (l.val ++ w)) =
      ((M l).filter (fun v => v.IsPrefix w)).image (fun v => l.val ++ v) := by
  ext x
  constructor
  · intro hx
    obtain ⟨hxM, hxp⟩ := Finset.mem_filter.mp hx
    obtain ⟨m, v, hv, rfl⟩ := (T.mem_liftMarks M).mp hxM
    obtain ⟨hml, hvp⟩ := (T.append_prefix_append_iff m l v w).mp hxp
    subst m
    exact Finset.mem_image.mpr ⟨v, Finset.mem_filter.mpr ⟨hv, hvp⟩, rfl⟩
  · intro hx
    obtain ⟨v, hv, rfl⟩ := Finset.mem_image.mp hx
    obtain ⟨hvM, hvp⟩ := Finset.mem_filter.mp hv
    exact Finset.mem_filter.mpr ⟨(T.mem_liftMarks M).mpr ⟨l, v, hvM, rfl⟩,
      (T.append_prefix_append_iff l l v w).mpr ⟨rfl, hvp⟩⟩

theorem colorCount_liftMarks (T : UniformTree)
    (M : T.leaves → Finset (List ℕ)) (l : T.leaves) (w : List ℕ) :
    colorCount (T.liftMarks M) (l.val ++ w) = colorCount (M l) w := by
  unfold colorCount
  rw [T.filter_liftMarks_prefix M l w]
  exact Finset.card_image_of_injective _ (fun _ _ h => List.append_cancel_left h)

theorem colorCount_union_liftMarks (T : UniformTree) (old : Finset (List ℕ))
    (M : T.leaves → Finset (List ℕ)) (hold : old ⊆ T.vertices)
    (hroot : ∀ l, [] ∉ M l) (l : T.leaves) (w : List ℕ) :
    colorCount (old ∪ T.liftMarks M) (l.val ++ w) =
      colorCount old l.val + colorCount (M l) w := by
  have hd : Disjoint (old.filter (fun x => x.IsPrefix (l.val ++ w)))
      ((T.liftMarks M).filter (fun x => x.IsPrefix (l.val ++ w))) :=
    (T.old_marks_disjoint_lift old M hold hroot).mono
      (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hsplit : colorCount (old ∪ T.liftMarks M) (l.val ++ w) =
      colorCount old (l.val ++ w) + colorCount (T.liftMarks M) (l.val ++ w) := by
    unfold colorCount
    rw [Finset.filter_union, Finset.card_union_of_disjoint hd]
  rw [hsplit, T.colorCount_liftMarks M l w]
  have holdcount : colorCount old (l.val ++ w) = colorCount old l.val :=
    congrArg Finset.card (T.filter_old_prefix_append old hold l w)
  rw [holdcount]

theorem levelCount_liftMarks_eq_zero (T : UniformTree)
    (M : T.leaves → Finset (List ℕ)) (hroot : ∀ l, [] ∉ M l)
    {depth : ℕ} (hdepth : depth ≤ T.height) : levelCount (T.liftMarks M) depth = 0 := by
  apply Finset.card_eq_zero.mpr
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  obtain ⟨hxM, hxdepth⟩ := Finset.mem_filter.mp hx
  have hlt := T.height_lt_length_of_mem_lift M hroot hxM
  omega

theorem levelCount_liftMarks_le (T : UniformTree)
    (M : T.leaves → Finset (List ℕ)) (rank : T.leaves → ℕ)
    (hinj : Function.Injective rank)
    (hlength : ∀ l, ∀ w ∈ M l, w.length = rank l)
    (hcard : ∀ l, (M l).card ≤ phaseQuota (rank l)) (depth : ℕ) :
    levelCount (T.liftMarks M) depth ≤ phaseQuota (depth - T.height) := by
  classical
  let A := (T.liftMarks M).filter (fun x => x.length = depth)
  by_cases hA : A.Nonempty
  · obtain ⟨x, hx⟩ := hA
    obtain ⟨hxM, hxdepth⟩ := Finset.mem_filter.mp hx
    obtain ⟨l, w, hw, heqx⟩ := (T.mem_liftMarks M).mp hxM
    have hlrank : T.height + rank l = depth := by
      rw [heqx, List.length_append, T.length_leaf l.val l.property, hlength l w hw] at hxdepth
      exact hxdepth
    have hsub : A ⊆ (M l).image (fun v => l.val ++ v) := by
      intro y hy
      obtain ⟨hyM, hydepth⟩ := Finset.mem_filter.mp hy
      obtain ⟨m, v, hv, heqy⟩ := (T.mem_liftMarks M).mp hyM
      have hmrank : T.height + rank m = depth := by
        rw [heqy, List.length_append, T.length_leaf m.val m.property, hlength m v hv] at hydepth
        exact hydepth
      have hml : m = l := hinj (by omega)
      subst m
      exact Finset.mem_image.mpr ⟨v, hv, heqy.symm⟩
    have hrank : rank l = depth - T.height := by omega
    calc
      levelCount (T.liftMarks M) depth = A.card := rfl
      _ ≤ ((M l).image (fun v => l.val ++ v)).card := Finset.card_le_card hsub
      _ ≤ (M l).card := Finset.card_image_le
      _ ≤ phaseQuota (rank l) := hcard l
      _ = phaseQuota (depth - T.height) := congrArg phaseQuota hrank
  · have hempty : A = ∅ := Finset.not_nonempty_iff_eq_empty.mp hA
    change A.card ≤ _
    rw [hempty, Finset.card_empty]
    exact Nat.zero_le _

theorem levelCount_union_liftMarks (T : UniformTree) (old : Finset (List ℕ))
    (M : T.leaves → Finset (List ℕ)) (hold : old ⊆ T.vertices)
    (hroot : ∀ l, [] ∉ M l) (depth : ℕ) :
    levelCount (old ∪ T.liftMarks M) depth =
      if depth ≤ T.height then levelCount old depth else levelCount (T.liftMarks M) depth := by
  unfold levelCount
  split_ifs with hdepth
  · apply congrArg Finset.card
    ext x
    simp only [Finset.mem_filter, Finset.mem_union]
    constructor
    · rintro ⟨hxold | hxlift, hxlen⟩
      · exact ⟨hxold, hxlen⟩
      · have hlt := T.height_lt_length_of_mem_lift M hroot hxlift
        omega
    · rintro ⟨hxold, hxlen⟩
      exact ⟨Or.inl hxold, hxlen⟩
  · apply congrArg Finset.card
    ext x
    simp only [Finset.mem_filter, Finset.mem_union]
    constructor
    · rintro ⟨hxold | hxlift, hxlen⟩
      · have hle := T.length_le_height (hold hxold)
        omega
      · exact ⟨hxlift, hxlen⟩
    · rintro ⟨hxlift, hxlen⟩
      exact ⟨Or.inr hxlift, hxlen⟩

theorem levelCount_union_liftMarks_le (T : UniformTree) (old : Finset (List ℕ))
    (M : T.leaves → Finset (List ℕ))
    (hold : old ⊆ T.vertices) (hroot : ∀ l, [] ∉ M l)
    (rank : T.leaves → ℕ) (hinj : Function.Injective rank)
    (hlength : ∀ l, ∀ w ∈ M l, w.length = rank l)
    (hcard : ∀ l, (M l).card ≤ phaseQuota (rank l)) (quota : ℕ → ℕ)
    (holdquota : ∀ depth, 1 ≤ depth → depth ≤ T.height → levelCount old depth ≤ quota depth)
    (depth : ℕ) (hpos : 1 ≤ depth) :
    levelCount (old ∪ T.liftMarks M) depth ≤
      if depth ≤ T.height then quota depth else phaseQuota (depth - T.height) := by
  rw [T.levelCount_union_liftMarks old M hold hroot depth]
  split_ifs with hdepth
  · exact holdquota depth hpos hdepth
  · exact T.levelCount_liftMarks_le M rank hinj hlength hcard depth

end UniformTree
end BinPackingGap

end OAI
end LocalizedSource25
/- END LOCALIZED SOURCE 25/44: OAI/Computability/BinPacking/Trees/TreeColorCounts.lean -/

/- BEGIN LOCALIZED SOURCE 26/44: OAI/Computability/BinPacking/Trees/InventoryFromTrees.lean
   SHA256: 241dbae069c8bd2435144e268941294cd899a24ccf0e94a09bb047a2932eb8df -/
section LocalizedSource26
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryScores
-- localized import: OAI.Computability.BinPacking.Trees.TreeColorCounts

namespace OAI

namespace BinPackingGap.InventoryData

def ofCompetingTrees (G : GraphInput) {d : ℕ} (T : CompetingTrees d) (R k : ℕ) :
    InventoryData where
  graph := G
  plus := T.plus
  minus := T.minus
  d := d
  R := R
  L := T.height
  quota := T.quota
  k := k

@[simp] theorem ofCompetingTrees_P (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (R k : ℕ) :
    (ofCompetingTrees G T R k).P = T.quotaTotal := rfl

theorem ofCompetingTrees_plus_height (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (R k : ℕ) :
    (ofCompetingTrees G T R k).plus.height = (ofCompetingTrees G T R k).L :=
  T.plus_height

theorem ofCompetingTrees_minus_height (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (R k : ℕ) :
    (ofCompetingTrees G T R k).minus.height = (ofCompetingTrees G T R k).L :=
  T.minus_height

theorem ofCompetingTrees_height_pos (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (R k : ℕ) : 0 < (ofCompetingTrees G T R k).L :=
  T.height_pos

end BinPackingGap.InventoryData

end OAI
end LocalizedSource26
/- END LOCALIZED SOURCE 26/44: OAI/Computability/BinPacking/Trees/InventoryFromTrees.lean -/

/- BEGIN LOCALIZED SOURCE 27/44: OAI/Computability/BinPacking/Inventory/LocalCompletionCoverage.lean
   SHA256: 3876946a26a72f367f42dc05a8f3920d0addcbaacc747831fab6c3fa56fa5176 -/
section LocalizedSource27
-- localized import: Mathlib.Data.Fin.Embedding
-- localized import: Mathlib.Data.Fintype.EquivFin
-- localized import: Mathlib.Logic.Equiv.Set
-- localized import: OAI.Computability.BinPacking.Packing.PackingCoordinates
-- localized import: OAI.Computability.BinPacking.Trees.InventoryFromTrees

namespace OAI

noncomputable section

namespace BinPackingGap.PartialAllocation

theorem exists_equiv_extending_embeddings
    {I J S : Type*} [Fintype I] [Fintype J]
    (f : S ↪ I) (g : S ↪ J)
    (hcard : Fintype.card I = Fintype.card J) :
    ∃ e : I ≃ J, ∀ s, e (f s) = g s := by
  classical
  let assigned : Set.range f ≃ Set.range g :=
    (Equiv.ofInjective f f.injective).symm.trans (Equiv.ofInjective g g.injective)
  have hremaining : Fintype.card ↥((Set.range f)ᶜ) =
      Fintype.card ↥((Set.range g)ᶜ) := by
    rw [Fintype.card_compl_set, Fintype.card_compl_set, hcard,
      Fintype.card_congr assigned]
  let remaining : ↥((Set.range f)ᶜ) ≃ ↥((Set.range g)ᶜ) :=
    Fintype.equivOfCardEq hremaining
  let e : I ≃ J := (Equiv.Set.sumCompl (Set.range f)).symm.trans
    ((Equiv.sumCongr assigned remaining).trans (Equiv.Set.sumCompl (Set.range g)))
  refine ⟨e, ?_⟩
  intro s
  have hfs : f s ∈ Set.range f := ⟨s, rfl⟩
  change ((Equiv.Set.sumCompl (Set.range g))
    ((Equiv.sumCongr assigned remaining)
      ((Equiv.Set.sumCompl (Set.range f)).symm (f s)))) = g s
  rw [Equiv.Set.sumCompl_symm_apply_of_mem hfs]
  simp only [Equiv.sumCongr_apply, Sum.map_inl, Equiv.Set.sumCompl_apply_inl]
  change ((Equiv.ofInjective g g.injective)
    ((Equiv.ofInjective f f.injective).symm ⟨f s, hfs⟩)).val = g s
  rw [Equiv.ofInjective_symm_apply]
  rfl

theorem exists_equiv_extending_injections
    {I J S : Type*} [Fintype I] [Fintype J]
    (f : S → I) (g : S → J) (hf : Function.Injective f) (hg : Function.Injective g)
    (hcard : Fintype.card I = Fintype.card J) :
    ∃ e : I ≃ J, ∀ s, e (f s) = g s :=
  exists_equiv_extending_embeddings ⟨f, hf⟩ ⟨g, hg⟩ hcard

end BinPackingGap.PartialAllocation

namespace BinPackingGap.InventoryData

open IntervalCoverage

variable (D : InventoryData)

theorem designated_injective (v : D.Vertex) :
    Function.Injective (D.designated (v := v)) := by
  rintro ⟨(p | p | j), a⟩ ⟨(q | q | k), b⟩ h <;>
    simp_all [designated, Subtype.val_inj]

theorem deadline_undesignated {v : D.Vertex} (i : D.MBase v)
    (hi : ∀ q : D.TestAt v × Fin D.d, D.designated q ≠ i) :
    D.deadline i = D.mainBaseline i := by
  rcases i with (⟨node, j⟩ | ⟨node, j⟩ | padding) | job
  · have hn : node.val ∉ D.plus.leaves := by
      intro hn
      exact hi (.inl ⟨node, hn⟩, j) rfl
    simp only [deadline, treeDeadline, hn, ite_false, mainBaseline, treeBaseline]
  · have hn : node.val ∉ D.minus.leaves := by
      intro hn
      exact hi (.inr (.inl ⟨node, hn⟩), j) rfl
    simp only [deadline, treeDeadline, hn, ite_false, mainBaseline, treeBaseline]
  · rfl
  · exact False.elim (hi (.inr (.inr job.1), job.2) rfl)

def deadlineShiftData (v : D.Vertex) :
    ShiftData (D.MBase v) (D.TestAt v) D.d ℚ where
  baseline := D.mainBaseline
  left := D.testLeft
  right := D.testRight
  designated := ⟨D.designated, D.designated_injective v⟩
  baseline_designated := D.mainBaseline_designated
  left_le_right := fun t => (D.testLeft_lt_testRight t).le

private theorem deadline_prefix_active (v : D.Vertex) (a : ℚ) :
    prefixCount (D.deadline (v := v)) a =
      prefixCount (D.mainBaseline (v := v)) a +
        D.d * ((D.deadlineShiftData v).activeTests a).card := by
  exact (D.deadlineShiftData v).deadline_prefix_of_agrees
    (D.deadline (v := v)) D.deadline_designated D.deadline_undesignated a

private theorem deadline_active_card (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L)
    (v : D.Vertex) (a : ℚ) :
    ((D.deadlineShiftData v).activeTests a).card =
      @ite ℕ (∃ t : D.TestAt v, a ∈ D.testInterval t)
        (Classical.propDecidable _) 1 0 := by
  classical
  have hdisjoint : ∀ s t : D.TestAt v, s ≠ t →
      Disjoint (Set.Ico ((D.deadlineShiftData v).left s)
        ((D.deadlineShiftData v).right s))
        (Set.Ico ((D.deadlineShiftData v).left t)
        ((D.deadlineShiftData v).right t)) := by
    intro s t hst
    exact D.testInterval_disjoint hplusheight hminusheight hL hst
  have hc := (D.deadlineShiftData v).activeTests_card hdisjoint a
  by_cases ht : ∃ t : D.TestAt v, a ∈ D.testInterval t
  · rw [ite_eq_left ht]
    have ht' : ∃ t : D.TestAt v,
        (D.deadlineShiftData v).left t ≤ a ∧
          a < (D.deadlineShiftData v).right t := ht
    rw [ite_eq_left ht'] at hc
    exact hc
  · rw [ite_eq_right ht]
    have ht' : ¬ ∃ t : D.TestAt v,
        (D.deadlineShiftData v).left t ≤ a ∧
          a < (D.deadlineShiftData v).right t := ht
    rw [ite_eq_right ht'] at hc
    exact hc

theorem deadline_prefix (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L)
    (v : D.Vertex) (a : ℚ) :
    prefixCount (D.deadline (v := v)) a =
      prefixCount (D.mainBaseline (v := v)) a +
        D.d * (@ite ℕ (∃ t : D.TestAt v, a ∈ D.testInterval t)
          (Classical.propDecidable _) 1 0) := by
  rw [D.deadline_prefix_active, D.deadline_active_card hplusheight hminusheight hL]

theorem deadline_prefix_at_test (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L)
    (v : D.Vertex) (t : D.TestAt v) (a : ℚ) (ha : a ∈ D.testInterval t) :
    ((Finset.univ : Finset (D.MBase v)).filter (fun z => D.deadline z ≤ a)).card =
      ((Finset.univ : Finset (D.MBase v)).filter
        (fun z => D.mainBaseline z ≤ a)).card + D.d := by
  classical
  have hex : ∃ t : D.TestAt v, a ∈ D.testInterval t := ⟨t, ha⟩
  simpa only [prefixCount, prefixSet, ite_eq_left hex, Nat.mul_one] using
    D.deadline_prefix hplusheight hminusheight hL v a

theorem exists_deadline_matching (hplusheight : D.plus.height = D.L)
    (hminusheight : D.minus.height = D.L) (hL : 1 ≤ D.L)
    (v : D.Vertex) (h : D.MBase v → ℚ)
    (hle : ∀ b, h b ≤ D.mainBaseline b)
    (hcover : ∀ (t : D.TestAt v) (a : ℚ), a ∈ D.testInterval t →
      D.d ≤ coverageCount h D.mainBaseline a) :
    ∃ e : D.MBase v ≃ D.MBase v, ∀ b, h b ≤ D.deadline (e b) := by
  classical
  apply exists_equiv_of_prefix_dominance h D.deadline rfl
  intro a
  rw [D.deadline_prefix hplusheight hminusheight hL,
    completion_prefix_identity h D.mainBaseline hle]
  by_cases ht : ∃ t : D.TestAt v, a ∈ D.testInterval t
  · rw [ite_eq_left ht, Nat.mul_one]
    obtain ⟨t, ht⟩ := ht
    exact Nat.add_le_add_left (hcover t a ht) _
  · rw [ite_eq_right ht, Nat.mul_zero, Nat.add_zero]
    exact Nat.le_add_right _ _

end BinPackingGap.InventoryData

namespace BinPackingGap.LocalResourceAllocation

open UniformTree

def oppositeTree {d : ℕ} (T : CompetingTrees d) : Bool → UniformTree
  | false => T.plus
  | true => T.minus

def oppositeMarking {d : ℕ} (T : CompetingTrees d) :
    (selected : Bool) → Finset (oppositeTree T selected).Node
  | false => T.markingPlus
  | true => T.markingMinus

abbrev OppositeMarked {d : ℕ} (T : CompetingTrees d) (selected : Bool) :=
  ↥(oppositeMarking T selected)

theorem opposite_height {d : ℕ} (T : CompetingTrees d) (selected : Bool) :
    (oppositeTree T selected).height = T.height := by
  cases selected
  · exact T.plus_height
  · exact T.minus_height

theorem opposite_depth_pos {d : ℕ} (T : CompetingTrees d) (selected : Bool)
    (a : OppositeMarked T selected) : 0 < depth a.val := by
  cases selected
  · exact T.markingPlus_depth_pos a.val a.property
  · exact T.markingMinus_depth_pos a.val a.property

theorem opposite_quota {d : ℕ} (T : CompetingTrees d) (selected : Bool)
    (ell : ℕ) (hlo : 1 ≤ ell) (hhi : ell ≤ T.height) :
    ((oppositeMarking T selected).filter (fun node => depth node = ell)).card ≤
      T.quota ell := by
  cases selected
  · exact T.plus_quota ell hlo hhi
  · exact T.minus_quota ell hlo hhi

variable (G : GraphInput) {d : ℕ} (T : CompetingTrees d) (hd : 0 < d) (R k : ℕ)

local notation "D" => InventoryData.ofCompetingTrees G T R k

def markedDepth (selected : Bool) (a : OppositeMarked T selected) : (D).Depth :=
  ⟨depth a.val, Finset.mem_Icc.mpr
    ⟨opposite_depth_pos T selected a,
      (depth_le_height a.val).trans_eq (opposite_height T selected)⟩⟩

def markedByDepth (selected : Bool) : OppositeMarked T selected ↪
    Σ ell : (D).Depth,
      ↥((oppositeMarking T selected).filter (fun node => depth node = ell.val)) := by
  classical
  refine ⟨fun a => ⟨markedDepth G T R k selected a,
    ⟨a.val, Finset.mem_filter.mpr ⟨a.property, rfl⟩⟩⟩, ?_⟩
  intro a b hab
  apply Subtype.ext
  exact congrArg (fun z => z.2.val) hab

def markedResource (selected : Bool) : OppositeMarked T selected ↪ (D).PositiveLocal := by
  classical
  exact (markedByDepth G T R k selected).trans
    (Function.Embedding.sigmaMap (Function.Embedding.refl (D).Depth) (fun ell =>
      (Finset.equivFin
        ((oppositeMarking T selected).filter (fun node => depth node = ell.val))).toEmbedding.trans
        (Fin.castLEEmb (opposite_quota T selected ell.val
          (Finset.mem_Icc.mp ell.property).1 (Finset.mem_Icc.mp ell.property).2))))

@[simp] theorem markedResource_depth (selected : Bool) (a : OppositeMarked T selected) :
    (markedResource G T R k selected a).1.val = depth a.val := rfl

def markedRow (v : G.Vertex) :
    (selected : Bool) → OppositeMarked T selected → (D).MBase v
  | false, a => .inl (.inl (a.val, ⟨0, hd⟩))
  | true, a => .inl (.inr (.inl (a.val, ⟨0, hd⟩)))

theorem markedRow_injective (v : G.Vertex) (selected : Bool) :
    Function.Injective (markedRow G T hd R k v selected) := by
  cases selected
  · intro a b hab
    apply Subtype.ext
    exact congrArg Prod.fst (Sum.inl.inj (Sum.inl.inj hab))
  · intro a b hab
    apply Subtype.ext
    exact congrArg Prod.fst (Sum.inl.inj (Sum.inr.inj (Sum.inl.inj hab)))

theorem fundedRoot_ne_markedRow (v : G.Vertex) (selected : Bool) (j : Fin d)
    (a : OppositeMarked T selected) :
    (D).fundedRoot selected j ≠ markedRow G T hd R k v selected a := by
  cases selected <;> intro h <;> cases Sum.inl.inj h

def zeroResource (v : G.Vertex) : Fin d ↪ (D).DMAt v := by
  clear hd
  have hstock : d ≤ (D).t - (D).P := by
    have h := (D).two_mul_d_le_t_sub_P
    change 2 * d ≤ (D).t - (D).P at h
    omega
  refine ⟨fun j => .inr (.inl (Fin.castLE hstock j)), ?_⟩
  intro a b hab
  exact Fin.castLE_injective hstock (Sum.inl.inj (Sum.inr.inj hab))

@[simp] theorem zeroResource_local_length (v : G.Vertex) (j : Fin d) :
    (D).localLength (.inl (zeroResource G T R k v j)) = 0 := rfl

def seedRows (v : G.Vertex) (selected : Bool) :
    (Fin d ⊕ OppositeMarked T selected) ↪ (D).MBase v := by
  refine ⟨Sum.elim ((D).fundedRoot selected) (markedRow G T hd R k v selected), ?_⟩
  intro a b hab
  rcases a with a | a <;> rcases b with b | b
  · exact congrArg Sum.inl ((D).fundedRoot_injective v selected hab)
  · exact False.elim (fundedRoot_ne_markedRow G T hd R k v selected a b hab)
  · exact False.elim (fundedRoot_ne_markedRow G T hd R k v selected b a hab.symm)
  · exact congrArg Sum.inr (markedRow_injective G T hd R k v selected hab)

def seedResources (v : G.Vertex) (selected : Bool) :
    (Fin d ⊕ OppositeMarked T selected) ↪ (D).DMAt v := by
  refine ⟨Sum.elim (zeroResource G T R k v)
    (fun a => .inl (markedResource G T R k selected a)), ?_⟩
  intro a b hab
  rcases a with a | a <;> rcases b with b | b
  · exact congrArg Sum.inl ((zeroResource G T R k v).injective hab)
  · have hbad : Sum.inr _ = Sum.inl _ := hab
    cases hbad
  · have hbad : Sum.inl _ = Sum.inr _ := hab
    cases hbad
  · exact congrArg Sum.inr ((markedResource G T R k selected).injective (Sum.inl.inj hab))

theorem exists_localEquiv (v : G.Vertex) (selected : Bool) :
    ∃ e : (D).MBase v ≃ (D).DMAt v,
      ∀ s : Fin d ⊕ OppositeMarked T selected,
        e (seedRows G T hd R k v selected s) = seedResources G T R k v selected s := by
  let : Fintype ((D).MBase v) := by
    dsimp [InventoryData.MBase, InventoryData.TreeRow, InventoryData.JobCopy,
      InventoryData.ofCompetingTrees]
    infer_instance
  let : Fintype ((D).DMAt v) := by
    dsimp [InventoryData.DMAt, InventoryData.PositiveLocal, InventoryData.ZeroLocalAt,
      InventoryData.Depth, InventoryData.JobCopy, InventoryData.ofCompetingTrees]
    infer_instance
  apply PartialAllocation.exists_equiv_extending_embeddings
    (seedRows G T hd R k v selected) (seedResources G T R k v selected)
  exact ((D).card_mBase v).trans ((D).card_dmAt v).symm

def localEquiv (v : G.Vertex) (selected : Bool) : (D).MBase v ≃ (D).DMAt v :=
  Classical.choose (exists_localEquiv G T hd R k v selected)

theorem localEquiv_seed (v : G.Vertex) (selected : Bool)
    (s : Fin d ⊕ OppositeMarked T selected) :
    localEquiv G T hd R k v selected (seedRows G T hd R k v selected s) =
      seedResources G T R k v selected s :=
  Classical.choose_spec (exists_localEquiv G T hd R k v selected) s

theorem localEquiv_fundedRoot (v : G.Vertex) (selected : Bool) (j : Fin d) :
    localEquiv G T hd R k v selected ((D).fundedRoot selected j) =
      zeroResource G T R k v j :=
  localEquiv_seed G T hd R k v selected (.inl j)

theorem localEquiv_markedRow (v : G.Vertex) (selected : Bool)
    (a : OppositeMarked T selected) :
    localEquiv G T hd R k v selected (markedRow G T hd R k v selected a) =
      .inl (markedResource G T R k selected a) :=
  localEquiv_seed G T hd R k v selected (.inr a)

theorem fundedRoot_local_zero (v : G.Vertex) (selected : Bool) (j : Fin d) :
    (D).localLength (.inl (localEquiv G T hd R k v selected ((D).fundedRoot selected j))) =
      0 := by
  rw [localEquiv_fundedRoot, zeroResource_local_length]

theorem markedRow_local_length (v : G.Vertex) (selected : Bool)
    (a : OppositeMarked T selected) :
    (D).localLength (.inl (localEquiv G T hd R k v selected
      (markedRow G T hd R k v selected a))) =
      Geometry.lambda G.edges.length R (D).geometryBound (depth a.val) := by
  rw [localEquiv_markedRow]
  change Geometry.lambda G.edges.length R (D).geometryBound
    (markedResource G T R k selected a).1.val = _
  rw [markedResource_depth]

theorem plusMarked_local_length (v : G.Vertex) (node : T.plus.Node)
    (hnode : node ∈ T.markingPlus) :
    (D).localLength (.inl (localEquiv G T hd R k v false
      (.inl (.inl (node, ⟨0, hd⟩))))) =
      Geometry.lambda G.edges.length R (D).geometryBound (depth node) :=
  markedRow_local_length G T hd R k v false ⟨node, hnode⟩

theorem minusMarked_local_length (v : G.Vertex) (node : T.minus.Node)
    (hnode : node ∈ T.markingMinus) :
    (D).localLength (.inl (localEquiv G T hd R k v true
      (.inl (.inr (.inl (node, ⟨0, hd⟩)))))) =
      Geometry.lambda G.edges.length R (D).geometryBound (depth node) :=
  markedRow_local_length G T hd R k v true ⟨node, hnode⟩

end BinPackingGap.LocalResourceAllocation

namespace BinPackingGap.LocalCompletionCoverage

open InventoryData IntervalCoverage

private theorem card_le_coverage {ι κ : Type*} [Fintype ι]
    (h baseline : ι → ℚ) (a : ℚ) (s : Finset κ) (f : κ → ι)
    (hf : Function.Injective f)
    (hc : ∀ x ∈ s, h (f x) ≤ a ∧ a < baseline (f x)) :
    s.card ≤ coverageCount h baseline a := by
  classical
  exact Finset.card_le_card_of_injOn f
    (fun x hx => (mem_coverageSet h baseline a (f x)).mpr (hc x hx))
    (fun _ _ _ _ hxy => hf hxy)

private theorem nodeInterval_subset_root {U : UniformTree} (node : U.Node)
    (m R B : ℕ) (side : TreeGeometry.Side) (hB : U.branchBound ≤ B)
    {a : ℚ}
    (ha : a ∈ Set.Ico (TreeGeometry.left m R B side node.val)
      (TreeGeometry.right m R B side node.val)) :
    a ∈ Set.Ico (TreeGeometry.rootOffset side) (TreeGeometry.rootOffset side + 1) := by
  have he := TreeGeometry.prefix_endpoints m R B side
    (u := []) (v := node.val) List.nil_prefix (TreeGeometry.boundedAddress_node node hB)
  simp only [TreeGeometry.left_nil, TreeGeometry.right_nil] at he
  exact ⟨he.1.trans ha.1, ha.2.trans_le he.2⟩

variable (G : GraphInput) {d : ℕ} (T : CompetingTrees d) (hd : 0 < d) (R k : ℕ)

local notation "D" => InventoryData.ofCompetingTrees G T R k

local instance mainFintype (v : G.Vertex) : Fintype ((D).MBase v) := by
  dsimp [InventoryData.MBase, InventoryData.TreeRow, InventoryData.JobCopy,
    InventoryData.ofCompetingTrees]
  infer_instance

def localCompletion (v : G.Vertex) (selected : Bool) (b : (D).MBase v) : ℚ :=
  (D).rowCoordinate ((D).stateMainRow v selected b) - (D).stateMainLength selected b -
    (D).localLength (.inl (LocalResourceAllocation.localEquiv G T hd R k v selected b))

theorem localCompletion_le_baseline (v : G.Vertex) (selected : Bool) (b : (D).MBase v) :
    localCompletion G T hd R k v selected b ≤ (D).mainBaseline b := by
  have hg := (D).stateMainLength_nonneg selected b
  have hl := (D).localLength_nonneg
    (.inl (LocalResourceAllocation.localEquiv G T hd R k v selected b))
  have hdelta := Geometry.delta_nonneg G.edges.length R (D).geometryBound (D).L
  have hshort : (0 : ℚ) ≤
      if (D).rowShort ((D).stateMainRow v selected b) then
        Geometry.delta G.edges.length R (D).geometryBound (D).L else 0 := by
    split_ifs
    · exact hdelta
    · exact le_rfl
  have hbase := (D).stateMainRow_baseline v selected b
  unfold localCompletion rowCoordinate
  dsimp only [InventoryData.ofCompetingTrees] at *
  rw [hbase]
  linarith

private theorem fundedRoot_covers (v : G.Vertex) (selected : Bool) (j : Fin d)
    {a : ℚ} (ha : a ∈ Set.Ico (if selected then 0 else 4) (if selected then 1 else 5)) :
    localCompletion G T hd R k v selected ((D).fundedRoot selected j) ≤ a ∧
      a < (D).mainBaseline ((D).fundedRoot (v := v) selected j) := by
  have hzero := LocalResourceAllocation.fundedRoot_local_zero G T hd R k v selected j
  have hglobal := (D).stateMainLength_fundedRoot (v := v) selected j
  unfold localCompletion
  rw [hzero, hglobal]
  cases selected <;>
    norm_num [fundedRoot, stateMainRow, stateRowEquiv, rowCoordinate, rowBaseline,
      rowShort, mainBaseline, treeBaseline, UniformTree.root, TreeGeometry.right_nil,
      TreeGeometry.rootOffset] at ha ⊢ <;> exact ha

private theorem fundedRoot_coverage (v : G.Vertex) (selected : Bool) {a : ℚ}
    (ha : a ∈ Set.Ico (if selected then 0 else 4) (if selected then 1 else 5)) :
    d ≤ coverageCount (localCompletion G T hd R k v selected) (D).mainBaseline a := by
  classical
  have hc := card_le_coverage (localCompletion G T hd R k v selected)
    (D).mainBaseline a (Finset.univ : Finset (Fin d)) ((D).fundedRoot selected)
    ((D).fundedRoot_injective v selected)
    (fun j _ => fundedRoot_covers G T hd R k v selected j ha)
  simpa only [Finset.card_univ, Fintype.card_fin] using hc

private theorem plusMarked_completion_le (v : G.Vertex) (node : T.plus.Node)
    (hnode : node ∈ T.markingPlus) :
    localCompletion G T hd R k v false (.inl (.inl (node, ⟨0, hd⟩))) ≤
      TreeGeometry.left G.edges.length R (D).geometryBound .plus node.val := by
  have hlocal := LocalResourceAllocation.plusMarked_local_length G T hd R k v node hnode
  have hglobal := (D).stateMainLength_nonneg false
    (.inl (.inl (node, ⟨0, hd⟩))) (v := v)
  have hn : node.val ≠ [] := by
    intro hn
    have hp := T.markingPlus_depth_pos node hnode
    simp [UniformTree.depth, hn] at hp
  have hcoord : (D).rowCoordinate
      ((D).stateMainRow v false (.inl (.inl (node, ⟨0, hd⟩)))) =
      TreeGeometry.right G.edges.length R (D).geometryBound .plus node.val := by
    change TreeGeometry.right G.edges.length R (D).geometryBound .plus node.val - 0 = _
    exact sub_zero _
  have hwidth : TreeGeometry.right G.edges.length R (D).geometryBound .plus node.val =
      TreeGeometry.left G.edges.length R (D).geometryBound .plus node.val +
        Geometry.lambda G.edges.length R (D).geometryBound (UniformTree.depth node) := by
    rw [TreeGeometry.right, TreeGeometry.width_of_ne_nil _ _ _ hn]
    rfl
  unfold localCompletion
  dsimp only [InventoryData.ofCompetingTrees] at *
  rw [hcoord, hlocal, hwidth]
  linarith

private theorem minusMarked_completion_le (v : G.Vertex) (node : T.minus.Node)
    (hnode : node ∈ T.markingMinus) :
    localCompletion G T hd R k v true (.inl (.inr (.inl (node, ⟨0, hd⟩)))) ≤
      TreeGeometry.left G.edges.length R (D).geometryBound .minus node.val := by
  have hlocal := LocalResourceAllocation.minusMarked_local_length G T hd R k v node hnode
  have hglobal := (D).stateMainLength_nonneg true
    (.inl (.inr (.inl (node, ⟨0, hd⟩)))) (v := v)
  have hn : node.val ≠ [] := by
    intro hn
    have hp := T.markingMinus_depth_pos node hnode
    simp [UniformTree.depth, hn] at hp
  have hcoord : (D).rowCoordinate
      ((D).stateMainRow v true (.inl (.inr (.inl (node, ⟨0, hd⟩))))) =
      TreeGeometry.right G.edges.length R (D).geometryBound .minus node.val := by
    change TreeGeometry.right G.edges.length R (D).geometryBound .minus node.val - 0 = _
    exact sub_zero _
  have hwidth : TreeGeometry.right G.edges.length R (D).geometryBound .minus node.val =
      TreeGeometry.left G.edges.length R (D).geometryBound .minus node.val +
        Geometry.lambda G.edges.length R (D).geometryBound (UniformTree.depth node) := by
    rw [TreeGeometry.right, TreeGeometry.width_of_ne_nil _ _ _ hn]
    rfl
  unfold localCompletion
  dsimp only [InventoryData.ofCompetingTrees] at *
  rw [hcoord, hlocal, hwidth]
  linarith

private theorem plusMarked_coverage (v : G.Vertex) (leaf : (D).PlusLeaf) {a : ℚ}
    (ha : a ∈ (D).testInterval (.inl leaf : (D).TestAt v)) :
    d ≤ coverageCount (localCompletion G T hd R k v false) (D).mainBaseline a := by
  classical
  apply (T.plus_rich leaf.val leaf.property).trans
  apply card_le_coverage (localCompletion G T hd R k v false) (D).mainBaseline a
    (T.markingPlus.filter (fun node => UniformTree.ancestor node leaf.val))
    (fun node => .inl (.inl (node, ⟨0, hd⟩)))
  · intro x y hxy
    exact congrArg Prod.fst (Sum.inl.inj (Sum.inl.inj hxy))
  · intro node hnode
    obtain ⟨hmark, hancestor⟩ := Finset.mem_filter.mp hnode
    have he := TreeGeometry.prefix_endpoints G.edges.length R (D).geometryBound .plus
      hancestor (TreeGeometry.boundedAddress_node leaf.val (D).plus_branch_le_geometryBound)
    exact ⟨(plusMarked_completion_le G T hd R k v node hmark).trans (he.1.trans ha.1),
      ha.2.trans_le he.2⟩

private theorem minusMarked_coverage (v : G.Vertex) (leaf : (D).MinusLeaf) {a : ℚ}
    (ha : a ∈ (D).testInterval (.inr (.inl leaf) : (D).TestAt v)) :
    d ≤ coverageCount (localCompletion G T hd R k v true) (D).mainBaseline a := by
  classical
  apply (T.minus_rich leaf.val leaf.property).trans
  apply card_le_coverage (localCompletion G T hd R k v true) (D).mainBaseline a
    (T.markingMinus.filter (fun node => UniformTree.ancestor node leaf.val))
    (fun node => .inl (.inr (.inl (node, ⟨0, hd⟩))))
  · intro x y hxy
    exact congrArg Prod.fst (Sum.inl.inj (Sum.inr.inj (Sum.inl.inj hxy)))
  · intro node hnode
    obtain ⟨hmark, hancestor⟩ := Finset.mem_filter.mp hnode
    have he := TreeGeometry.prefix_endpoints G.edges.length R (D).geometryBound .minus
      hancestor (TreeGeometry.boundedAddress_node leaf.val (D).minus_branch_le_geometryBound)
    exact ⟨(minusMarked_completion_le G T hd R k v node hmark).trans (he.1.trans ha.1),
      ha.2.trans_le he.2⟩

private theorem shortJob_coverage (v : G.Vertex) (job : (D).IncidencePosition v) {a : ℚ}
    (ha : a ∈ (D).testInterval (.inr (.inr job) : (D).TestAt v)) :
    d ≤ coverageCount (localCompletion G T hd R k v false) (D).mainBaseline a := by
  classical
  have hc := card_le_coverage (localCompletion G T hd R k v false)
    (D).mainBaseline a (Finset.univ : Finset (Fin d))
    (fun j => .inr (job, j))
    (by intro i j hij; exact congrArg Prod.snd (Sum.inr.inj hij)) (by
      intro j _
      have hl := (D).localLength_nonneg
        (.inl (LocalResourceAllocation.localEquiv G T hd R k v false (.inr (job, j))))
      change Geometry.baseline G.edges.length R ((D).incidencePosition job) -
        Geometry.delta G.edges.length R (D).geometryBound (D).L - 0 -
        (D).localLength (.inl (LocalResourceAllocation.localEquiv G T hd R k v false
          (.inr (job, j)))) ≤ a ∧
        a < Geometry.baseline G.edges.length R ((D).incidencePosition job)
      change Geometry.baseline G.edges.length R ((D).incidencePosition job) -
          Geometry.delta G.edges.length R (D).geometryBound (D).L ≤ a ∧
        a < Geometry.baseline G.edges.length R ((D).incidencePosition job) at ha
      exact ⟨by linarith [ha.1], ha.2⟩)
  simpa only [Finset.card_univ, Fintype.card_fin] using hc

theorem localCompletion_coverage (v : G.Vertex) (selected : Bool)
    (test : (D).TestAt v) (a : ℚ) (ha : a ∈ (D).testInterval test) :
    d ≤ coverageCount (localCompletion G T hd R k v selected) (D).mainBaseline a := by
  cases selected
  · rcases test with leaf | leaf | job
    · exact plusMarked_coverage G T hd R k v leaf ha
    · apply fundedRoot_coverage G T hd R k v false
      have hroot := nodeInterval_subset_root leaf.val G.edges.length R (D).geometryBound .minus
        (D).minus_branch_le_geometryBound ha
      norm_num [TreeGeometry.rootOffset] at hroot ⊢
      exact hroot
    · exact shortJob_coverage G T hd R k v job ha
  · rcases test with leaf | leaf | job
    · apply fundedRoot_coverage G T hd R k v true
      have hroot := nodeInterval_subset_root leaf.val G.edges.length R (D).geometryBound .plus
        (D).plus_branch_le_geometryBound ha
      norm_num [TreeGeometry.rootOffset] at hroot ⊢
      exact hroot
    · exact minusMarked_coverage G T hd R k v leaf ha
    · apply fundedRoot_coverage G T hd R k v true
      have hj := Geometry.closedJobCell_bounds
        (Geometry.jobTestInterval_subset_closedJobCell G.edges.length R (D).geometryBound
          (D).L ((D).incidencePosition job) ha)
      exact ⟨by dsimp; linarith [hj.1], hj.2⟩

theorem exists_anchorEquiv (v : G.Vertex) (selected : Bool) :
    ∃ e : (D).MBase v ≃ (D).MBase v, ∀ b,
      (D).rowCoordinate ((D).stateMainRow v selected b) - (D).stateMainLength selected b -
        (D).localLength (.inl (LocalResourceAllocation.localEquiv G T hd R k v selected b)) ≤
          (D).deadline (e b) := by
  exact (D).exists_deadline_matching T.plus_height T.minus_height T.height_pos v
    (localCompletion G T hd R k v selected)
    (localCompletion_le_baseline G T hd R k v selected)
    (localCompletion_coverage G T hd R k v selected)

end BinPackingGap.LocalCompletionCoverage

end

end OAI
end LocalizedSource27
/- END LOCALIZED SOURCE 27/44: OAI/Computability/BinPacking/Inventory/LocalCompletionCoverage.lean -/

/- BEGIN LOCALIZED SOURCE 28/44: OAI/Computability/BinPacking/Inventory/PackingExclusions.lean
   SHA256: eca4185e692af0533b7a8b08d65a4463a2de4cfde69200fcb45a28cc860aecd1 -/
section LocalizedSource28
-- localized import: Mathlib.Data.Finset.Card
-- localized import: Mathlib.Data.Fintype.Card
-- localized import: Mathlib.Data.Fintype.Prod
-- localized import: Mathlib.Basic.Real.Basic
-- localized import: Mathlib.Tactic.NormNum
-- localized import: OAI.Computability.BinPacking.Packing.PackingCoordinates

namespace OAI

noncomputable section

namespace BinPackingGap

def excludedPositions {T Pos : Type*} [Fintype Pos]
    (selected : Finset T) (I : T → Pos → Prop) : Finset Pos := by
  classical
  exact Finset.univ.filter fun r => ∃ t ∈ selected, I t r

@[simp] theorem mem_excludedPositions {T Pos : Type*} [Fintype Pos]
    (selected : Finset T) (I : T → Pos → Prop) {r : Pos} :
    r ∈ excludedPositions selected I ↔ ∃ t ∈ selected, I t r := by
  classical
  simp [excludedPositions]

theorem excludedPositions_card_le {T Pos : Type*} [Fintype Pos]
    (selected : Finset T) (I : T → Pos → Prop)
    (hunique : ∀ t ∈ selected, ∀ r s, I t r → I t s → r = s) :
    (excludedPositions selected I).card ≤ selected.card := by
  classical
  have witness (r : ↥(excludedPositions selected I)) : ∃ t ∈ selected, I t r :=
    (mem_excludedPositions selected I).mp r.property
  let f : ↥(excludedPositions selected I) → ↥selected := fun r =>
    ⟨(witness r).choose, (witness r).choose_spec.1⟩
  have hf (r : ↥(excludedPositions selected I)) : I (f r) r :=
    (witness r).choose_spec.2
  have hinj : Function.Injective f := by
    intro r s hrs
    have ht : (f r : T) = (f s : T) := congrArg (fun t : ↥selected => (t : T)) hrs
    apply Subtype.ext
    apply hunique (f r) (f r).property r s (hf r)
    rw [ht]
    exact hf s
  simpa only [Fintype.card_coe] using Fintype.card_le_of_injective f hinj

def excludedRepetitions {E : Type*} {R : ℕ}
    (bad : Finset (E × Fin R)) (e : E) : Finset (Fin R) := by
  classical
  exact Finset.univ.filter fun j => (e, j) ∈ bad

def nonexcludedRepetitions {E : Type*} {R : ℕ}
    (bad : Finset (E × Fin R)) (e : E) : Finset (Fin R) := by
  classical
  exact Finset.univ.filter fun j => (e, j) ∉ bad

@[simp] theorem mem_excludedRepetitions {E : Type*} {R : ℕ}
    (bad : Finset (E × Fin R)) (e : E) {j : Fin R} :
    j ∈ excludedRepetitions bad e ↔ (e, j) ∈ bad := by
  classical
  simp [excludedRepetitions]

@[simp] theorem mem_nonexcludedRepetitions {E : Type*} {R : ℕ}
    (bad : Finset (E × Fin R)) (e : E) {j : Fin R} :
    j ∈ nonexcludedRepetitions bad e ↔ (e, j) ∉ bad := by
  classical
  simp [nonexcludedRepetitions]

theorem excludedRepetitions_card_le {E : Type*} {R : ℕ}
    (bad : Finset (E × Fin R)) (e : E) :
    (excludedRepetitions bad e).card ≤ bad.card := by
  classical
  let f : ↥(excludedRepetitions bad e) → ↥bad := fun j =>
    ⟨(e, j), (mem_excludedRepetitions bad e).mp j.property⟩
  have hinj : Function.Injective f := by
    intro j k hjk
    apply Subtype.ext
    exact congrArg Prod.snd (congrArg (fun x : ↥bad => (x : E × Fin R)) hjk)
  simpa only [Fintype.card_coe] using Fintype.card_le_of_injective f hinj

theorem excluded_nonexcluded_card {E : Type*} {R : ℕ}
    (bad : Finset (E × Fin R)) (e : E) :
    (excludedRepetitions bad e).card + (nonexcludedRepetitions bad e).card = R := by
  classical
  have hdis : Disjoint (excludedRepetitions bad e) (nonexcludedRepetitions bad e) := by
    apply Finset.disjoint_left.mpr
    intro j hj hk
    exact ((mem_nonexcludedRepetitions bad e).mp hk)
      ((mem_excludedRepetitions bad e).mp hj)
  have hunion : excludedRepetitions bad e ∪ nonexcludedRepetitions bad e = Finset.univ := by
    ext j
    by_cases hj : (e, j) ∈ bad <;> simp [hj]
  calc
    _ = (excludedRepetitions bad e ∪ nonexcludedRepetitions bad e).card :=
      (Finset.card_union_of_disjoint hdis).symm
    _ = R := by rw [hunion]; simp

theorem nonexcludedRepetitions_add_card_bound {E : Type*} {R P : ℕ}
    (bad : Finset (E × Fin R)) (e : E) (hbad : bad.card ≤ P) :
    R ≤ P + (nonexcludedRepetitions bad e).card := by
  calc
    R = (excludedRepetitions bad e).card + (nonexcludedRepetitions bad e).card :=
      (excluded_nonexcluded_card bad e).symm
    _ ≤ P + (nonexcludedRepetitions bad e).card :=
      Nat.add_le_add_right ((excludedRepetitions_card_le bad e).trans hbad) _

theorem nonexcludedRepetitions_card_ge {E : Type*} {R P : ℕ}
    (bad : Finset (E × Fin R)) (e : E) (hbad : bad.card ≤ P) :
    R - P ≤ (nonexcludedRepetitions bad e).card := by
  apply Nat.sub_le_iff_le_add.mpr
  simpa only [Nat.add_comm] using nonexcludedRepetitions_add_card_bound bad e hbad

theorem nonexcludedRepetitions_card_ge_real {E : Type*} {R P : ℕ}
    (bad : Finset (E × Fin R)) (e : E) (hbad : bad.card ≤ P) :
    (R : ℝ) - P ≤ ((nonexcludedRepetitions bad e).card : ℝ) := by
  have h : (R : ℝ) ≤ (P : ℝ) + ((nonexcludedRepetitions bad e).card : ℝ) := by
    exact_mod_cast nonexcludedRepetitions_add_card_bound bad e hbad
  apply sub_le_iff_le_add.mpr
  simpa only [add_comm] using h

theorem nonexcludedRepetitions_card_ge_of_unique_hits {T E : Type*} [Fintype E]
    {R P : ℕ} (selected : Finset T) (I : T → E × Fin R → Prop)
    (hunique : ∀ t ∈ selected, ∀ r s, I t r → I t s → r = s)
    (hselected : selected.card ≤ P) (e : E) :
    R - P ≤ (nonexcludedRepetitions (excludedPositions selected I) e).card :=
  nonexcludedRepetitions_card_ge _ e ((excludedPositions_card_le selected I hunique).trans hselected)

theorem nonexcludedRepetitions_card_ge_real_of_unique_hits {T E : Type*} [Fintype E]
    {R P : ℕ} (selected : Finset T) (I : T → E × Fin R → Prop)
    (hunique : ∀ t ∈ selected, ∀ r s, I t r → I t s → r = s)
    (hselected : selected.card ≤ P) (e : E) :
    (R : ℝ) - P ≤ ((nonexcludedRepetitions (excludedPositions selected I) e).card : ℝ) :=
  nonexcludedRepetitions_card_ge_real _ e
    ((excludedPositions_card_le selected I hunique).trans hselected)

namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

def tupleHitsJob (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : D.Position) : Prop :=
  (tupleClosedInterval p e t ∩
    Geometry.closedJobCell D.graph.edges.length D.R D.geometryBound D.L r).Nonempty

def excludedAt (p : Packing I b) (e : D.Item ≃ I.Item) (v : D.Vertex) :
    Finset D.Position :=
  excludedPositions (zeroPositiveTuples p e v) (tupleHitsJob p e)

theorem selected_hits_job_unique (p : Packing I b) (e : D.Item ≃ I.Item)
    (hL : 1 ≤ D.L) (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ zeroPositiveTuples p e v) {r s : D.Position}
    (hr : tupleHitsJob p e t r) (hs : tupleHitsJob p e t s) : r = s :=
  Geometry.closedJobCell_unique_of_short_interval hL
    (selected_interval_length_first p e v t ht) hr hs

theorem excludedAt_card_le (p : Packing I b) (e : D.Item ≃ I.Item)
    (hL : 1 ≤ D.L) (v : D.Vertex) : (excludedAt p e v).card ≤ D.P := by
  apply (excludedPositions_card_le (zeroPositiveTuples p e v) (tupleHitsJob p e) ?_).trans
    (zeroPositiveTuples_card_le p e v)
  intro t ht r s hr hs
  exact selected_hits_job_unique p e hL v t ht hr hs

def goodRepetitions (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (edge : D.Edge) : Finset (Fin D.R) :=
  nonexcludedRepetitions (excludedAt p e v) edge

theorem goodRepetitions_card_ge (p : Packing I b) (e : D.Item ≃ I.Item)
    (hL : 1 ≤ D.L) (v : D.Vertex) (edge : D.Edge) :
    D.R - D.P ≤ (goodRepetitions p e v edge).card :=
  nonexcludedRepetitions_card_ge _ edge (excludedAt_card_le p e hL v)

theorem goodRepetitions_card_ge_real (p : Packing I b) (e : D.Item ≃ I.Item)
    (hL : 1 ≤ D.L) (v : D.Vertex) (edge : D.Edge) :
    (D.R : ℝ) - D.P ≤ ((goodRepetitions p e v edge).card : ℝ) :=
  nonexcludedRepetitions_card_ge_real _ edge (excludedAt_card_le p e hL v)

theorem covering_not_selected_of_nonexcluded (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) (hr : r ∉ excludedAt p e v)
    (t : p.TableBin (subclass e))
    (ht : t ∈ tupleCovering p e v
      (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r)) :
    t ∉ zeroPositiveTuples p e v := by
  intro hselected
  apply hr
  apply (mem_excludedPositions _ _).mpr
  refine ⟨t, hselected, ?_⟩
  obtain ⟨_, hlo, hhi⟩ := (mem_tupleCovering p e v _ t).mp ht
  refine ⟨Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r,
    ⟨hlo, hhi.le⟩, ?_⟩
  exact Geometry.jobInterior_mem_closedJobCell _ _ _ _ _

end PackingCounts
end BinPackingGap

end

end OAI
end LocalizedSource28
/- END LOCALIZED SOURCE 28/44: OAI/Computability/BinPacking/Inventory/PackingExclusions.lean -/

/- BEGIN LOCALIZED SOURCE 29/44: OAI/Computability/BinPacking/Trees/InventoryRowGeometry.lean
   SHA256: d5026f51ce1d118205bffb72b4c3d5dafc0a93a155c5387e9862a3654553bde8 -/
section LocalizedSource29
-- localized import: OAI.Computability.BinPacking.Packing.PackingCoordinates

namespace OAI

namespace BinPackingGap.InventoryData

variable (D : InventoryData)

private theorem node_right_in_root {T : UniformTree} (v : T.Node)
    (s : TreeGeometry.Side) (hT : T.branchBound ≤ D.geometryBound) :
    TreeGeometry.rootOffset s ≤
        TreeGeometry.right D.graph.edges.length D.R D.geometryBound s v.val ∧
      TreeGeometry.right D.graph.edges.length D.R D.geometryBound s v.val ≤
        TreeGeometry.rootOffset s + 1 := by
  apply TreeGeometry.nodeCell_subset_root D.graph.edges.length D.R D.geometryBound s hT v
  exact ⟨(TreeGeometry.left_lt_right _ _ _ _ _).le, le_rfl⟩

theorem rowBaseline_le_one_of_not_tm {v : D.Vertex} (r : D.RowAt v)
    (hclass : D.rowSubclass r ≠ .tm) : D.rowBaseline r ≤ 1 := by
  rcases r with t | ⟨short, j⟩
  · rcases t with ⟨node, i⟩ | ⟨node, i⟩ | i
    · have h := D.node_right_in_root node .plus D.plus_branch_le_geometryBound
      simpa only [rowBaseline, treeBaseline, TreeGeometry.rootOffset, zero_add] using h.2
    · exact (hclass rfl).elim
    · exact le_rfl
  · exact (Geometry.job_baseline_lt_one _ _ _).le

theorem rowBaseline_ge_four_of_tm {v : D.Vertex} (r : D.RowAt v)
    (hclass : D.rowSubclass r = .tm) : 4 ≤ D.rowBaseline r := by
  rcases r with t | ⟨short, j⟩
  · rcases t with ⟨node, i⟩ | ⟨node, i⟩ | i
    · cases hclass
    · exact (D.node_right_in_root node .minus D.minus_branch_le_geometryBound).1
    · cases hclass
  · cases hclass

theorem rowShort_eq_false_of_tm {v : D.Vertex} (r : D.RowAt v)
    (hclass : D.rowSubclass r = .tm) : D.rowShort r = false := by
  rcases r with t | ⟨short, j⟩
  · rfl
  · cases hclass

theorem exists_jobCopy_of_rowShort {v : D.Vertex} (r : D.RowAt v)
    (hshort : D.rowShort r = true) : ∃ j : D.JobCopy v, r = .inr (true, j) := by
  rcases r with t | ⟨short, j⟩
  · cases hshort
  · change short = true at hshort
    subst short
    exact ⟨j, rfl⟩

theorem row_zero_resources_empty {v : D.Vertex} (r : D.RowAt v)
    (hshort : D.rowShort r = false) :
    completionInterval (D.rowBaseline r) (D.rowShort r) 0 0
      (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) = ∅ := by
  rw [hshort]
  exact completionInterval_long_zero_lengths _ _

theorem row_zero_resources_job {v : D.Vertex} (r : D.RowAt v)
    (hshort : D.rowShort r = true) :
    ∃ j : D.JobCopy v, r = .inr (true, j) ∧
      D.rowPosition r = some (D.jobPosition j) ∧
      completionInterval (D.rowBaseline r) (D.rowShort r) 0 0
        (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) =
        Geometry.jobTestInterval D.graph.edges.length D.R D.geometryBound D.L
          (D.jobPosition j) := by
  obtain ⟨j, rfl⟩ := D.exists_jobCopy_of_rowShort r hshort
  refine ⟨j, rfl, rfl, ?_⟩
  exact completion_job_interval _ _ _ _ _

theorem minus_row_completion_gt_one {v w : D.Vertex} (r : D.RowAt v)
    (u : D.GlobalCopy) (l : D.LocalAt w) (hclass : D.rowSubclass r = .tm) :
    1 < completion (D.rowBaseline r) (D.rowShort r) (D.globalLength u)
      (D.localLength l) (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) := by
  apply completion_minus_geometry_gt_one
    D.graph.edges.length D.R D.geometryBound D.L
  · exact D.rowBaseline_ge_four_of_tm r hclass
  · exact D.rowShort_eq_false_of_tm r hclass
  · exact D.globalLength_le_one u
  · exact D.localLength_le_lambda_one l

theorem minus_row_not_cover_jobInterior {v w : D.Vertex} (r : D.RowAt v)
    (u : D.GlobalCopy) (l : D.LocalAt w) (hclass : D.rowSubclass r = .tm)
    (job : D.Position) :
    Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L job ∉
      completionInterval (D.rowBaseline r) (D.rowShort r) (D.globalLength u)
        (D.localLength l) (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) := by
  intro hmem
  have hh := D.minus_row_completion_gt_one r u l hclass
  have hj := (Geometry.closedJobCell_bounds
    (Geometry.jobInterior_mem_closedJobCell D.graph.edges.length D.R
      D.geometryBound D.L job)).2
  exact (not_le_of_gt (hj.trans hh)) hmem.1

theorem plus_row_not_cover_minus_side {v w : D.Vertex} (r : D.RowAt v)
    (u : D.GlobalCopy) (l : D.LocalAt w) (hclass : D.rowSubclass r ≠ .tm)
    {a : ℚ} (ha : 4 ≤ a) :
    a ∉ completionInterval (D.rowBaseline r) (D.rowShort r) (D.globalLength u)
      (D.localLength l) (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) := by
  apply not_mem_plus_completionInterval
  · exact D.rowBaseline_le_one_of_not_tm r hclass
  · linarith

end BinPackingGap.InventoryData

end OAI
end LocalizedSource29
/- END LOCALIZED SOURCE 29/44: OAI/Computability/BinPacking/Trees/InventoryRowGeometry.lean -/

/- BEGIN LOCALIZED SOURCE 30/44: OAI/Computability/BinPacking/Machines/PackingJobCoverage.lean
   SHA256: 2f83a2ae8f0010b806893a1280c0b04d61b115f8b3cdfec89b68a873dfe8a69d -/
section LocalizedSource30
-- localized import: OAI.Computability.BinPacking.Inventory.PackingExclusions
-- localized import: OAI.Computability.BinPacking.Trees.InventoryRowGeometry

namespace OAI

noncomputable section

namespace BinPackingGap
namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

def shortMainAt (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) : Finset (p.TableBin (subclass e)) := by
  classical
  exact (Coverage.mainTuplesAt p (subclass e) (label e) v).filter fun t =>
    tupleBaseline p e t = Geometry.baseline D.graph.edges.length D.R r ∧
      tupleShort p e t = true

theorem main_unit_species (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v)
    (hu : D.globalUnit (globalCopy p e t) = true) :
    (globalCopy p e t).1 = .up true ∨ (globalCopy p e t).1 = .um true := by
  rcases hcopy : globalCopy p e t with ⟨s, i⟩
  rw [hcopy] at hu
  change s = .up true ∨ s = .um true
  cases s with
  | up one =>
      change one = true at hu
      exact Or.inl (congrArg GlobalSpecies.up hu)
  | um one =>
      change one = true at hu
      exact Or.inr (congrArg GlobalSpecies.um hu)
  | edge edge permit =>
      have hglobal := roleCopy_subclass p e t .«global»
      change D.itemSubclass ⟨.«global», globalCopy p e t⟩ = _ at hglobal
      rw [hcopy] at hglobal
      have hmain := ((Coverage.mem_mainTuplesAt p (subclass e) (label e) v t).mp ht).2.2
      exfalso
      apply hmain
      cases hpattern : p.tablePattern (subclass e) t <;>
        rw [hpattern] at hglobal <;> cases hglobal

theorem row_minus_of_global_um (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (hu : (globalCopy p e t).1 = .um true) :
    D.rowSubclass (rowCopy p e t).2 = .tm := by
  have hg := roleCopy_subclass p e t .«global»
  have hx := roleCopy_subclass p e t .x
  have hclass : D.itemSubclass ⟨.«global», globalCopy p e t⟩ = .um := by
    rcases hcopy : globalCopy p e t with ⟨s, i⟩
    have hs : s = .um true := by simpa only [hcopy] using hu
    subst s
    rfl
  have hpat : p.tablePattern (subclass e) t = .minusTree := by
    rw [hclass] at hg
    cases hp : p.tablePattern (subclass e) t <;> simp_all [patternSubclass]
  rw [hpat] at hx
  change D.itemSubclass ⟨.x, rowCopy p e t⟩ = .tm at hx
  rcases hc : rowCopy p e t with ⟨w, r⟩
  rw [hc] at hx
  exact hx

theorem job_covering_global_not_um (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) (t : p.TableBin (subclass e))
    (ht : t ∈ tupleCovering p e v
      (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r)) :
    (globalCopy p e t).1 ≠ .um true := by
  intro hu
  have hrow := row_minus_of_global_um p e t hu
  apply D.minus_row_not_cover_jobInterior (rowCopy p e t).2 (globalCopy p e t)
    (localCopy p e t).2 hrow r
  exact ((mem_tupleCovering p e v _ t).mp ht).2

theorem zero_resources_job_cover (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) (t : p.TableBin (subclass e))
    (ht : t ∈ tupleCovering p e v
      (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r))
    (hg : tupleGlobalLength p e t = 0) (hl : tupleLocalLength p e t = 0) :
    tupleBaseline p e t = Geometry.baseline D.graph.edges.length D.R r ∧
      tupleShort p e t = true := by
  have hmem := ((mem_tupleCovering p e v _ t).mp ht).2
  have hshort : tupleShort p e t = true := by
    cases hs : tupleShort p e t with
    | false =>
        have hfinish : tupleFinish p e t = tupleBaseline p e t := by
          simp [tupleFinish, hs, hg, hl]
        rw [hfinish] at hmem
        exact (not_lt_of_ge hmem.1 hmem.2).elim
    | true => rfl
  obtain ⟨j, hj, _, hinter⟩ := D.row_zero_resources_job (rowCopy p e t).2 hshort
  have hmem' : Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r ∈
      completionInterval (D.rowBaseline (rowCopy p e t).2)
        (D.rowShort (rowCopy p e t).2) 0 0
        (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) := by
    change completion _ _ 0 0 _ ≤ _ ∧ _ < _
    simpa only [tupleFinish, hg, hl, tupleBaseline, tupleShort] using hmem
  rw [hinter] at hmem'
  have hpos : D.jobPosition j = r :=
    (Geometry.jobInterior_mem_jobTestInterval_iff D.geometryBound D.L).mp hmem'
  refine ⟨?_, hshort⟩
  simp only [tupleBaseline, hj, InventoryData.rowBaseline, hpos]

theorem nonexcluded_covering_subset (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) (hr : r ∉ excludedAt p e v) :
    tupleCovering p e v (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r) ⊆
      fundedTuples p e (.up true) v ∪ shortMainAt p e v r := by
  classical
  intro t ht
  have hM := ((mem_tupleCovering p e v _ t).mp ht).1
  by_cases hu : D.globalUnit (globalCopy p e t) = true
  · have hspec := main_unit_species p e v t hM hu
    rcases hspec with hp | hm
    · exact Finset.mem_union_left _ ((mem_fundedTuples p e (.up true) v t).mpr
        ⟨hM, (selected_global_resource_iff p e t (.up true)).mpr hp⟩)
    · exact (job_covering_global_not_um p e v r t ht hm).elim
  · have hfalse : D.globalUnit (globalCopy p e t) = false := Bool.eq_false_of_not_eq_true hu
    have hnot := covering_not_selected_of_nonexcluded p e v r hr t ht
    have hnotpos : p.itemAtRole (subclass e) t .«local» ∉ positiveLocalResources e v := by
      intro hp
      exact hnot ((mem_zeroPositiveTuples p e v t).mpr ⟨hM, hfalse, hp⟩)
    have hlocal := tupleLocalLength_eq_zero_of_not_positive p e v t
      (Coverage.mainTuplesAt_subset_good p (subclass e) (label e) v hM) hnotpos
    have hz := zero_resources_job_cover p e v r t ht
      (tupleGlobalLength_eq_of_unit_false p e t hfalse) hlocal
    exact Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hM, hz⟩)

theorem nonexcluded_coverage_upper (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) (hr : r ∉ excludedAt p e v) :
    (tupleCovering p e v
      (Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L r)).card ≤
      xplus p e v + (shortMainAt p e v r).card := by
  calc
    _ ≤ (fundedTuples p e (.up true) v ∪ shortMainAt p e v r).card :=
      Finset.card_le_card (nonexcluded_covering_subset p e v r hr)
    _ ≤ _ := Finset.card_union_le _ _

end PackingCounts
end BinPackingGap

end

end OAI
end LocalizedSource30
/- END LOCALIZED SOURCE 30/44: OAI/Computability/BinPacking/Machines/PackingJobCoverage.lean -/

/- BEGIN LOCALIZED SOURCE 31/44: OAI/Computability/BinPacking/Configurations/CoverageSoundness.lean
   SHA256: 4984ec9dfa699433382c6419d8a5a33fc2f2c99d24a3a320323c3c14a58a48f6 -/
section LocalizedSource31
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryPrefixConservation
-- localized import: OAI.Computability.BinPacking.Inventory.LocalCompletionCoverage
-- localized import: OAI.Computability.BinPacking.Machines.PackingJobCoverage
-- localized import: OAI.Computability.BinPacking.Packing.PackingFeasibility

namespace OAI

noncomputable section

namespace BinPackingGap

namespace InventoryCoverage

variable {D : InventoryData} {I : Instance} {b : ℕ}

theorem coveringTuplesAt_eq (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (a : ℚ) :
    Coverage.coveringTuplesAt p (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) (PackingCounts.tupleFinish p e) a =
      PackingCounts.tupleCovering p e v a := by
  unfold Coverage.coveringTuplesAt PackingCounts.tupleCovering
  apply Finset.filter_congr
  intro t _
  rw [rowBaseline_selected p e t]
  rfl

theorem shortMainAt_eq (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (r : D.Position) :
    Coverage.currentShortMainAt p (PackingCounts.subclass e) (PackingCounts.label e) v
      (rowBaseline e) (rowShort e) (Geometry.baseline D.graph.edges.length D.R r) =
      PackingCounts.shortMainAt p e v r := by
  unfold Coverage.currentShortMainAt PackingCounts.shortMainAt
  apply Finset.filter_congr
  intro t _
  rw [rowBaseline_selected p e t, rowShort_selected p e t]
  rfl

end InventoryCoverage

namespace InventoryData

variable (D : InventoryData)

theorem test_coverage {b c : ℕ}
    (hplusheight : D.plus.height = D.L) (hminusheight : D.minus.height = D.L)
    (hL : 1 ≤ D.L) (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c)
    (v : D.Vertex) (t : D.TestAt v) (a : ℚ) (ha : a ∈ D.testInterval t) :
    D.d ≤ (PackingCounts.tupleCovering p D.itemEquiv v a).card + 6 * lossAllowance c := by
  classical
  have hbad := D.badAnchorsAt_card_le hk p hb v
  have horder := PackingCounts.edge_selected_baseline_le p D.itemEquiv
    D.packingInstance_size_eq v
  have hle : ∀ u ∈ Coverage.mainTuplesAt p (PackingCounts.subclass D.itemEquiv) (PackingCounts.label D.itemEquiv) v,
      PackingCounts.tupleFinish p D.itemEquiv u ≤
        InventoryCoverage.rowBaseline D.itemEquiv (p.itemAtRole (PackingCounts.subclass D.itemEquiv) u .x) := by
    intro u _
    simpa only [InventoryCoverage.rowBaseline_selected, PackingCounts.tupleBaseline] using
      PackingCounts.tupleFinish_le_baseline p D.itemEquiv u
  have hfeasible := PackingCounts.main_completion_le_selected_deadline p D.itemEquiv
    D.packingInstance_size_eq v
  have hdeficit := InventoryCoverage.actual_deadline_deficit_bound p D.itemEquiv v a
    (lossAllowance c) (PackingCounts.tupleFinish p D.itemEquiv) hbad horder hle hfeasible
  rw [D.deadline_prefix_at_test hplusheight hminusheight hL v t a ha,
    InventoryCoverage.coveringTuplesAt_eq] at hdeficit
  change (InventoryCoverage.originalBaselinePrefix D v a).card + D.d ≤
    (InventoryCoverage.originalBaselinePrefix D v a).card +
      (PackingCounts.tupleCovering p D.itemEquiv v a).card + 6 * lossAllowance c at hdeficit
  omega

def longMatchesAt {b : ℕ} (p : Packing D.packingInstance b)
    (v : D.Vertex) (r : D.IncidencePosition v) : ℕ :=
  (Coverage.currentLongEdgeAt p D.encodedSubclass D.encodedLabel v
    (InventoryCoverage.rowBaseline D.itemEquiv) (InventoryCoverage.keyBaseline D.itemEquiv)
    (InventoryCoverage.rowShort D.itemEquiv)
    (Geometry.baseline D.graph.edges.length D.R (D.incidencePosition r))).card

theorem long_matches_at_nonexcluded {b c : ℕ}
    (hplusheight : D.plus.height = D.L) (hminusheight : D.minus.height = D.L)
    (hL : 1 ≤ D.L) (hk : D.k ≤ D.graph.n)
    (p : Packing D.packingInstance b) (hb : b ≤ D.B + c)
    (v : D.Vertex) (r : D.IncidencePosition v)
    (hr : D.incidencePosition r ∉ PackingCounts.excludedAt p D.itemEquiv v) :
    D.d ≤ D.longMatchesAt p v r + PackingCounts.xplus p D.itemEquiv v + 9 * lossAllowance c := by
  classical
  let a := Geometry.jobInterior D.graph.edges.length D.R D.geometryBound D.L (D.incidencePosition r)
  let finish := PackingCounts.tupleFinish p D.itemEquiv
  have hbad := D.badAnchorsAt_card_le hk p hb v
  have horder := PackingCounts.edge_selected_baseline_le p D.itemEquiv
    D.packingInstance_size_eq v
  have hle : ∀ u ∈ Coverage.mainTuplesAt p (PackingCounts.subclass D.itemEquiv) (PackingCounts.label D.itemEquiv) v,
      finish u ≤ InventoryCoverage.rowBaseline D.itemEquiv
        (p.itemAtRole (PackingCounts.subclass D.itemEquiv) u .x) := by
    intro u _
    simpa only [finish, InventoryCoverage.rowBaseline_selected, PackingCounts.tupleBaseline] using
      PackingCounts.tupleFinish_le_baseline p D.itemEquiv u
  have hfeasible := PackingCounts.main_completion_le_selected_deadline p D.itemEquiv
    D.packingInstance_size_eq v
  have hpartition := Coverage.completion_prefix_decomposition p (PackingCounts.subclass D.itemEquiv)
    (PackingCounts.label D.itemEquiv) v (InventoryCoverage.rowBaseline D.itemEquiv) finish hle a
  have hdeadline := Coverage.deadline_prefix_le_completion_add_loss p (PackingCounts.subclass D.itemEquiv)
    (PackingCounts.label D.itemEquiv) v (InventoryCoverage.anchorDeadline D.itemEquiv) finish a
    (lossAllowance c) hbad hfeasible
  have ha : a ∈ D.testInterval (.inr (.inr r) : D.TestAt v) :=
    Geometry.jobInterior_mem_jobTestInterval D.graph.edges.length D.R D.geometryBound D.L
      (D.incidencePosition r)
  rw [InventoryCoverage.deadlinePrefix_card,
    D.deadline_prefix_at_test hplusheight hminusheight hL v (.inr (.inr r)) a ha] at hdeadline
  have hbase := InventoryCoverage.actual_displaced_job_prefix_le p D.itemEquiv v r
    (lossAllowance c) hbad horder
  have hupper : (Coverage.coveringTuplesAt p (PackingCounts.subclass D.itemEquiv) (PackingCounts.label D.itemEquiv) v
      (InventoryCoverage.rowBaseline D.itemEquiv) finish a).card ≤
      PackingCounts.xplus p D.itemEquiv v +
      (Coverage.currentShortMainAt p (PackingCounts.subclass D.itemEquiv) (PackingCounts.label D.itemEquiv) v
        (InventoryCoverage.rowBaseline D.itemEquiv) (InventoryCoverage.rowShort D.itemEquiv)
        (Geometry.baseline D.graph.edges.length D.R (D.incidencePosition r))).card := by
    simpa only [finish, a, InventoryCoverage.coveringTuplesAt_eq,
      InventoryCoverage.shortMainAt_eq] using
      PackingCounts.nonexcluded_coverage_upper p D.itemEquiv v (D.incidencePosition r) hr
  have hcorrection := CoverageCounts.displaced_short_correction hpartition hdeadline hbase hupper
  exact InventoryCoverage.actual_current_long_matches_from_correction p D.itemEquiv v r
    (lossAllowance c) (PackingCounts.xplus p D.itemEquiv v) hbad horder hcorrection

end InventoryData
end BinPackingGap

end

end OAI
end LocalizedSource31
/- END LOCALIZED SOURCE 31/44: OAI/Computability/BinPacking/Configurations/CoverageSoundness.lean -/

/- BEGIN LOCALIZED SOURCE 32/44: OAI/Computability/BinPacking/Trees/TreeAvoidance.lean
   SHA256: 9a84140db2e2ef2037a825c10df15cfea5f581091580996295e56ceafd957c55 -/
section LocalizedSource32
-- localized import: OAI.Computability.BinPacking.Trees.TreeColorCounts

namespace OAI

namespace BinPackingGap

def pullMarks (stem : List ℕ) (marks : Finset (List ℕ)) : Finset (List ℕ) :=
  (marks.filter (fun w => stem.IsPrefix w)).image (fun w => w.drop stem.length)

@[simp] theorem mem_pullMarks (stem word : List ℕ) (marks : Finset (List ℕ)) :
    word ∈ pullMarks stem marks ↔ stem ++ word ∈ marks := by
  constructor
  · intro hw
    obtain ⟨v, hv, hdrop⟩ := Finset.mem_image.mp hw
    obtain ⟨hvA, hpref⟩ := Finset.mem_filter.mp hv
    have heq : stem ++ word = v := by
      calc
        stem ++ word = stem ++ v.drop stem.length :=
          congrArg (fun t => stem ++ t) hdrop.symm
        _ = v.take stem.length ++ v.drop stem.length :=
          congrArg (fun t => t ++ v.drop stem.length) (List.prefix_iff_eq_take.mp hpref)
        _ = v := List.take_append_drop stem.length v
    exact heq.symm ▸ hvA
  · intro hw
    exact Finset.mem_image.mpr
      ⟨stem ++ word, Finset.mem_filter.mpr ⟨hw, List.prefix_append stem word⟩,
        by simp⟩

@[simp] theorem nil_mem_pullMarks (stem : List ℕ) (marks : Finset (List ℕ)) :
    [] ∈ pullMarks stem marks ↔ stem ∈ marks := by
  simpa only [List.append_nil] using mem_pullMarks stem [] marks

theorem levelCount_pullMarks_le (stem : List ℕ) (marks : Finset (List ℕ)) (j : ℕ) :
    levelCount (pullMarks stem marks) j ≤ levelCount marks (stem.length + j) := by
  have hsub : (pullMarks stem marks).filter (fun w => w.length = j) ⊆
      (marks.filter (fun w => w.length = stem.length + j)).image
        (fun w => w.drop stem.length) := by
    intro w hw
    obtain ⟨hw, hlen⟩ := Finset.mem_filter.mp hw
    refine Finset.mem_image.mpr ⟨stem ++ w, ?_, by simp⟩
    exact Finset.mem_filter.mpr
      ⟨(mem_pullMarks stem w marks).mp hw, by simp only [List.length_append, hlen]⟩
  exact (Finset.card_le_card hsub).trans (Finset.card_image_le)

theorem disjoint_prefixes_append_of_pull (stem word : List ℕ)
    (marks : Finset (List ℕ))
    (hold : Disjoint marks (UniformTree.prefixes stem))
    (hnew : Disjoint (pullMarks stem marks) (UniformTree.prefixes word)) :
    Disjoint marks (UniformTree.prefixes (stem ++ word)) := by
  apply Finset.disjoint_left.mpr
  intro v hv hprefix
  rw [prefixes_append_eq] at hprefix
  rcases Finset.mem_union.mp hprefix with hprefix | hprefix
  · exact Finset.disjoint_left.mp hold hv hprefix
  · obtain ⟨w, _, hw, heq⟩ := mem_prefixesAfter_iff.mp hprefix
    apply Finset.disjoint_left.mp hnew
    · exact (mem_pullMarks stem w marks).mpr (heq.symm ▸ hv)
    · exact UniformTree.mem_prefixes_iff.mpr hw

def extendPhaseQuota (height : ℕ) (old : ℕ → ℕ) (depth : ℕ) : ℕ :=
  if depth ≤ height then old depth else phaseQuota (depth - height)

theorem extendPhaseQuota_old (height : ℕ) (old : ℕ → ℕ) {depth : ℕ}
    (hdepth : depth ≤ height) : extendPhaseQuota height old depth = old depth := by
  simp only [extendPhaseQuota, ite_eq_left hdepth]

theorem extendPhaseQuota_new (height : ℕ) (old : ℕ → ℕ) {j : ℕ}
    (hj : 0 < j) : extendPhaseQuota height old (height + j) = phaseQuota j := by
  have hnot : ¬ height + j ≤ height := by omega
  simp only [extendPhaseQuota, ite_eq_right hnot, Nat.add_sub_cancel_left]

theorem graft_avoids {n : ℕ} (old : AuxiliaryTree n)
    (G : old.tree.leaves → AuxiliaryTree 1) (N : ℕ)
    (hG : ∀ l, (G l).tree.height = N)
    (hquota : ∀ l, (G l).quota = phaseQuota)
    (marks : Finset (List ℕ))
    (hmarks : RespectsTreeQuota
      (UniformTree.graft old.tree (fun l => (G l).tree) N hG)
      (extendPhaseQuota old.tree.height old.quota) marks) :
    ∃ leaf ∈ (UniformTree.graft old.tree (fun l => (G l).tree) N hG).leaves,
      Disjoint marks (UniformTree.prefixes leaf) := by
  have hold : RespectsTreeQuota old.tree old.quota marks := by
    refine ⟨hmarks.1, ?_⟩
    intro j hj hbound
    have hglobal := hmarks.2 j hj (by
      change j ≤ old.tree.height + N
      omega)
    simpa only [extendPhaseQuota_old old.tree.height old.quota hbound] using hglobal
  obtain ⟨l, hl, havoidOld⟩ := old.avoids marks hold
  let oldLeaf : old.tree.leaves := ⟨l, hl⟩
  have hlocal : RespectsTreeQuota (G oldLeaf).tree (G oldLeaf).quota
      (pullMarks l marks) := by
    constructor
    · rw [nil_mem_pullMarks]
      intro hmarked
      exact Finset.disjoint_left.mp havoidOld hmarked
        (UniformTree.mem_prefixes_iff.mpr (List.prefix_refl l))
    · intro j hj hbound
      have hjpos : 0 < j := by omega
      have hlocalBound : j ≤ N := by simpa only [hG oldLeaf] using hbound
      have hglobal := hmarks.2 (old.tree.height + j) (by omega) (by
        change old.tree.height + j ≤ old.tree.height + N
        omega)
      have hpull := levelCount_pullMarks_le l marks j
      rw [old.tree.length_leaf l hl] at hpull
      rw [hquota oldLeaf]
      exact hpull.trans (by
        simpa only [extendPhaseQuota_new old.tree.height old.quota hjpos] using hglobal)
  obtain ⟨w, hw, havoidNew⟩ := (G oldLeaf).avoids (pullMarks l marks) hlocal
  refine ⟨l ++ w, ?_, disjoint_prefixes_append_of_pull l w marks havoidOld havoidNew⟩
  exact (UniformTree.mem_graft_leaves old.tree (fun l => (G l).tree) N hG).mpr
    ⟨oldLeaf, w, hw, rfl⟩

end BinPackingGap

end OAI
end LocalizedSource32
/- END LOCALIZED SOURCE 32/44: OAI/Computability/BinPacking/Trees/TreeAvoidance.lean -/

/- BEGIN LOCALIZED SOURCE 33/44: OAI/Computability/BinPacking/Packing/PhaseIteration.lean
   SHA256: d684c685013d6eef0cc14791d5e3f2f487651bacf76fd816f634808d4ac937ff -/
section LocalizedSource33
-- localized import: Mathlib.Data.Finset.Sort
-- localized import: Mathlib.Data.List.Lex
-- localized import: OAI.Computability.BinPacking.Trees.TreeAvoidance

namespace OAI

namespace BinPackingGap

namespace UniformTree

def leafRank (T : UniformTree) (l : T.leaves) : ℕ :=
  ((T.leaves.orderIsoOfFin rfl).symm l).val + 1

theorem leafRank_pos (T : UniformTree) (l : T.leaves) : 0 < T.leafRank l := by
  unfold leafRank
  omega

theorem one_le_leafRank (T : UniformTree) (l : T.leaves) : 1 ≤ T.leafRank l :=
  T.leafRank_pos l

theorem leafRank_le (T : UniformTree) (l : T.leaves) : T.leafRank l ≤ T.leaves.card := by
  have h := ((T.leaves.orderIsoOfFin rfl).symm l).isLt
  unfold leafRank
  omega

theorem leafRank_injective (T : UniformTree) : Function.Injective T.leafRank := by
  intro l m h
  apply (T.leaves.orderIsoOfFin rfl).symm.injective
  apply Fin.ext
  exact Nat.add_right_cancel h

theorem leaf_card_pos (T : UniformTree) : 0 < T.leaves.card :=
  Finset.card_pos.mpr T.leaves_nonempty

def rankedGadget (T : UniformTree) (l : T.leaves) : AuxiliaryTree 1 :=
  ForkGadget.auxiliary T.leaves.card (T.leafRank l)
    (T.one_le_leafRank l) (T.leafRank_le l)

@[simp] theorem rankedGadget_height (T : UniformTree) (l : T.leaves) :
    (T.rankedGadget l).tree.height = T.leaves.card := rfl

@[simp] theorem rankedGadget_quota (T : UniformTree) (l : T.leaves) :
    (T.rankedGadget l).quota = phaseQuota := rfl

theorem rankedGadget_red_depth (T : UniformTree) (l : T.leaves)
    {w : List ℕ} (hw : w ∈ (T.rankedGadget l).red) : w.length = T.leafRank l :=
  ForkGadget.auxiliary_red_depth _ _ _ _ hw

theorem rankedGadget_blue_depth (T : UniformTree) (l : T.leaves)
    {w : List ℕ} (hw : w ∈ (T.rankedGadget l).blue) : w.length = T.leafRank l :=
  ForkGadget.auxiliary_blue_depth _ _ _ _ hw

@[simp] theorem rankedGadget_card_red (T : UniformTree) (l : T.leaves) :
    (T.rankedGadget l).red.card = phaseQuota (T.leafRank l) :=
  ForkGadget.auxiliary_card_red _ _ _ _

@[simp] theorem rankedGadget_card_blue (T : UniformTree) (l : T.leaves) :
    (T.rankedGadget l).blue.card = phaseQuota (T.leafRank l) :=
  ForkGadget.auxiliary_card_blue _ _ _ _

def nextPhase (T : UniformTree) : UniformTree :=
  T.graft (fun l => (T.rankedGadget l).tree) T.leaves.card
    (fun l => T.rankedGadget_height l)

@[simp] theorem nextPhase_height (T : UniformTree) :
    T.nextPhase.height = T.height + T.leaves.card := rfl

theorem height_lt_nextPhase (T : UniformTree) : T.height < T.nextPhase.height := by
  rw [nextPhase_height]
  exact Nat.lt_add_of_pos_right T.leaf_card_pos

theorem mem_nextPhase_leaves (T : UniformTree) {x : List ℕ} :
    x ∈ T.nextPhase.leaves ↔
      ∃ l : T.leaves, ∃ w ∈ (T.rankedGadget l).tree.leaves, x = l.val ++ w :=
  T.mem_graft_leaves _ _ _

def singletonRoot : UniformTree where
  height := 0
  leaves := {[]}
  leaves_nonempty := ⟨[], Finset.mem_singleton_self []⟩
  length_leaf := by
    intro l hl
    have hl' : l = [] := Finset.mem_singleton.mp hl
    simp only [hl', List.length_nil]
  positive_labels := by
    intro l hl a ha
    have hl' : l = [] := Finset.mem_singleton.mp hl
    simp only [hl', List.not_mem_nil] at ha

end UniformTree

namespace AuxiliaryTree

def initial : AuxiliaryTree 0 where
  tree := UniformTree.singletonRoot
  quota := fun _ => 0
  quota_pos := by
    intro depth hpos hle
    change depth ≤ 0 at hle
    omega
  red := ∅
  blue := ∅
  red_subset := Finset.empty_subset _
  blue_subset := Finset.empty_subset _
  root_not_red := by simp
  root_not_blue := by simp
  red_blue_disjoint := by simp
  red_level := by simp [levelCount]
  blue_level := by simp [levelCount]
  total_count := by simp [colorCount]
  red_witness := ⟨[], Finset.mem_singleton_self [], by simp [colorCount]⟩
  blue_witness := ⟨[], Finset.mem_singleton_self [], by simp [colorCount]⟩
  avoids := by
    intro marks hmarks
    refine ⟨[], Finset.mem_singleton_self [], ?_⟩
    apply Finset.disjoint_left.mpr
    intro w hw hp
    have heq : w = [] := by
      simpa only [UniformTree.mem_prefixes_iff, List.prefix_nil] using hp
    exact hmarks.1 (heq ▸ hw)

def step {n : ℕ} (old : AuxiliaryTree n) : AuxiliaryTree (n + 1) where
  tree := old.tree.nextPhase
  quota := extendPhaseQuota old.tree.height old.quota
  quota_pos := by
    intro depth hpos _
    unfold extendPhaseQuota
    split_ifs with hdepth
    · exact old.quota_pos depth hpos hdepth
    · exact phaseQuota_pos _
  red := old.red ∪ old.tree.liftMarks (fun l => (old.tree.rankedGadget l).red)
  blue := old.blue ∪ old.tree.liftMarks (fun l => (old.tree.rankedGadget l).blue)
  red_subset := by
    intro w hw
    rcases Finset.mem_union.mp hw with hw | hw
    · exact old.tree.vertices_subset_graft _ _ _ (old.red_subset hw)
    · exact old.tree.liftMarks_subset_graft_vertices _ _ _ _
        (fun l => (old.tree.rankedGadget l).red_subset) hw
  blue_subset := by
    intro w hw
    rcases Finset.mem_union.mp hw with hw | hw
    · exact old.tree.vertices_subset_graft _ _ _ (old.blue_subset hw)
    · exact old.tree.liftMarks_subset_graft_vertices _ _ _ _
        (fun l => (old.tree.rankedGadget l).blue_subset) hw
  root_not_red := by
    intro h
    rcases Finset.mem_union.mp h with h | h
    · exact old.root_not_red h
    · exact old.tree.root_not_mem_lift _
        (fun l => (old.tree.rankedGadget l).root_not_red) h
  root_not_blue := by
    intro h
    rcases Finset.mem_union.mp h with h | h
    · exact old.root_not_blue h
    · exact old.tree.root_not_mem_lift _
        (fun l => (old.tree.rankedGadget l).root_not_blue) h
  red_blue_disjoint := by
    apply Finset.disjoint_left.mpr
    intro w hr hb
    rcases Finset.mem_union.mp hr with hr | hr <;>
      rcases Finset.mem_union.mp hb with hb | hb
    · exact Finset.disjoint_left.mp old.red_blue_disjoint hr hb
    · exact Finset.disjoint_left.mp
        (old.tree.old_marks_disjoint_lift old.red _ old.red_subset
          (fun l => (old.tree.rankedGadget l).root_not_blue)) hr hb
    · exact Finset.disjoint_left.mp
        (old.tree.old_marks_disjoint_lift old.blue _ old.blue_subset
          (fun l => (old.tree.rankedGadget l).root_not_red)) hb hr
    · exact Finset.disjoint_left.mp
        (old.tree.liftMarks_disjoint _ _
          (fun l => (old.tree.rankedGadget l).red_blue_disjoint)) hr hb
  red_level := by
    intro depth hpos _
    simpa only [extendPhaseQuota] using
      old.tree.levelCount_union_liftMarks_le old.red
        (fun l => (old.tree.rankedGadget l).red)
        old.red_subset (fun l => (old.tree.rankedGadget l).root_not_red)
        old.tree.leafRank old.tree.leafRank_injective
        (fun l _ hw => old.tree.rankedGadget_red_depth l hw)
        (fun l => (old.tree.rankedGadget_card_red l).le)
        old.quota old.red_level depth hpos
  blue_level := by
    intro depth hpos _
    simpa only [extendPhaseQuota] using
      old.tree.levelCount_union_liftMarks_le old.blue
        (fun l => (old.tree.rankedGadget l).blue)
        old.blue_subset (fun l => (old.tree.rankedGadget l).root_not_blue)
        old.tree.leafRank old.tree.leafRank_injective
        (fun l _ hw => old.tree.rankedGadget_blue_depth l hw)
        (fun l => (old.tree.rankedGadget_card_blue l).le)
        old.quota old.blue_level depth hpos
  total_count := by
    intro leaf hleaf
    obtain ⟨l, w, hw, rfl⟩ := old.tree.mem_nextPhase_leaves.mp hleaf
    rw [old.tree.colorCount_union_liftMarks old.red _ old.red_subset
        (fun l => (old.tree.rankedGadget l).root_not_red),
      old.tree.colorCount_union_liftMarks old.blue _ old.blue_subset
        (fun l => (old.tree.rankedGadget l).root_not_blue)]
    have hold := old.total_count l.val l.property
    have hnew := (old.tree.rankedGadget l).total_count w hw
    omega
  red_witness := by
    obtain ⟨l, hl, hold⟩ := old.red_witness
    let leaf : old.tree.leaves := ⟨l, hl⟩
    obtain ⟨w, hw, hnew⟩ := (old.tree.rankedGadget leaf).red_witness
    refine ⟨l ++ w, old.tree.mem_nextPhase_leaves.mpr ⟨leaf, w, hw, rfl⟩, ?_⟩
    change colorCount (old.red ∪ old.tree.liftMarks
      (fun l => (old.tree.rankedGadget l).red)) (leaf.val ++ w) = n + 1
    rw [old.tree.colorCount_union_liftMarks old.red _ old.red_subset
      (fun l => (old.tree.rankedGadget l).root_not_red) leaf w]
    exact congrArg₂ (· + ·) hold hnew
  blue_witness := by
    obtain ⟨l, hl, hold⟩ := old.blue_witness
    let leaf : old.tree.leaves := ⟨l, hl⟩
    obtain ⟨w, hw, hnew⟩ := (old.tree.rankedGadget leaf).blue_witness
    refine ⟨l ++ w, old.tree.mem_nextPhase_leaves.mpr ⟨leaf, w, hw, rfl⟩, ?_⟩
    change colorCount (old.blue ∪ old.tree.liftMarks
      (fun l => (old.tree.rankedGadget l).blue)) (leaf.val ++ w) = n + 1
    rw [old.tree.colorCount_union_liftMarks old.blue _ old.blue_subset
      (fun l => (old.tree.rankedGadget l).root_not_blue) leaf w]
    exact congrArg₂ (· + ·) hold hnew
  avoids := graft_avoids old old.tree.rankedGadget old.tree.leaves.card
    old.tree.rankedGadget_height old.tree.rankedGadget_quota

@[simp] theorem step_height {n : ℕ} (old : AuxiliaryTree n) :
    old.step.tree.height = old.tree.height + old.tree.leaves.card := rfl

theorem height_lt_step {n : ℕ} (old : AuxiliaryTree n) :
    old.tree.height < old.step.tree.height := old.tree.height_lt_nextPhase

end AuxiliaryTree

def buildAuxiliary : (n : ℕ) → AuxiliaryTree n
  | 0 => AuxiliaryTree.initial
  | n + 1 => (buildAuxiliary n).step

@[simp] theorem buildAuxiliary_zero : buildAuxiliary 0 = AuxiliaryTree.initial := rfl

@[simp] theorem buildAuxiliary_succ (n : ℕ) :
    buildAuxiliary (n + 1) = (buildAuxiliary n).step := rfl

theorem phases_le_buildAuxiliary_height (n : ℕ) : n ≤ (buildAuxiliary n).tree.height := by
  induction n with
  | zero => exact Nat.zero_le _
  | succ n ih =>
      have h := (buildAuxiliary n).height_lt_step
      change n + 1 ≤ (buildAuxiliary n).step.tree.height
      omega

theorem buildAuxiliary_height_pos {n : ℕ} (hn : 0 < n) :
    0 < (buildAuxiliary n).tree.height :=
  lt_of_lt_of_le hn (phases_le_buildAuxiliary_height n)

end BinPackingGap

end OAI
end LocalizedSource33
/- END LOCALIZED SOURCE 33/44: OAI/Computability/BinPacking/Packing/PhaseIteration.lean -/

/- BEGIN LOCALIZED SOURCE 34/44: OAI/Computability/BinPacking/Trees/CompetingTrees.lean
   SHA256: db61a081c269d12a8be8ec764b88c265da0f4975d17261f540050d66911f7430 -/
section LocalizedSource34
-- localized import: OAI.Computability.BinPacking.Packing.PhaseIteration

namespace OAI

namespace BinPackingGap

def competingTrees (d : ℕ) (hd : 0 < d) : CompetingTrees d :=
  CompetingTrees.ofAuxiliary d hd (buildAuxiliary (2 * d - 1))

theorem exists_competingTrees (d : ℕ) (hd : 0 < d) : Nonempty (CompetingTrees d) :=
  ⟨competingTrees d hd⟩

end BinPackingGap

end OAI
end LocalizedSource34
/- END LOCALIZED SOURCE 34/44: OAI/Computability/BinPacking/Trees/CompetingTrees.lean -/

/- BEGIN LOCALIZED SOURCE 35/44: OAI/Computability/BinPacking/Packing/ExtractedCover.lean
   SHA256: 52a924eed35a816cdb65137d9d17596c4805fcb3ece4a7fde09d3858d7c655e7 -/
section LocalizedSource35
-- localized import: Lean.Elab.Tactic.Omega
-- localized import: Mathlib.Data.Finset.Sum
-- localized import: OAI.Computability.BinPacking.Configurations.CoverageSoundness
-- localized import: OAI.Computability.BinPacking.Trees.CompetingTrees

namespace OAI

noncomputable section

namespace BinPackingGap.SideChoice

open UniformTree

variable {α β : Type*} [DecidableEq α] [DecidableEq β]

omit [DecidableEq α] [DecidableEq β] in
theorem card_le_of_unique_hit [DecidableEq α] [DecidableEq β]
    (tuples : Finset α) (nodes : Finset β)
    (hits : α → β → Prop)
    (hcover : ∀ v ∈ nodes, ∃ t ∈ tuples, hits t v)
    (hunique : ∀ t ∈ tuples, ∀ v w, hits t v → hits t w → v = w) :
    nodes.card ≤ tuples.card := by
  classical
  let f : nodes → tuples := fun v =>
    ⟨Classical.choose (hcover v.val v.property),
      (Classical.choose_spec (hcover v.val v.property)).1⟩
  have hf : ∀ v : nodes, hits (f v).val v.val := fun v =>
    (Classical.choose_spec (hcover v.val v.property)).2
  apply Finset.card_le_card_of_injective (f := f)
  intro v w hvw
  apply Subtype.ext
  have ht : (f v).val = (f w).val := congrArg Subtype.val hvw
  apply hunique (f v).val (f v).property v.val w.val (hf v)
  rw [ht]
  exact hf w

omit [DecidableEq α] [DecidableEq β] in
theorem level_card_le_resources [DecidableEq α] [DecidableEq β]
    (selected : Finset α) (level : α → ℕ)
    (resource : α → β) (stock : Finset β) (ℓ q : ℕ)
    (hmap : ∀ t ∈ selected, level t = ℓ → resource t ∈ stock)
    (hinj : Set.InjOn resource (selected.filter fun t => level t = ℓ))
    (hstock : stock.card ≤ q) :
    (selected.filter fun t => level t = ℓ).card ≤ q := by
  apply (Finset.card_le_card_of_injOn resource ?_ hinj).trans hstock
  intro t ht
  exact hmap t (Finset.mem_filter.mp ht).1 (Finset.mem_filter.mp ht).2

variable {d : ℕ} (T : CompetingTrees d)

def taggedDepth : T.plus.Node ⊕ T.minus.Node → ℕ := Sum.elim depth depth

def marksPlus (selected : Finset α)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop) : Finset T.plus.Node := by
  classical
  exact Finset.univ.filter fun v => ∃ t ∈ selected, hits t (.inl v)

def marksMinus (selected : Finset α)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop) : Finset T.minus.Node := by
  classical
  exact Finset.univ.filter fun v => ∃ t ∈ selected, hits t (.inr v)

omit [DecidableEq α] in
@[simp] theorem mem_marksPlus [DecidableEq α] (selected : Finset α)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop) (v : T.plus.Node) :
    v ∈ marksPlus T selected hits ↔ ∃ t ∈ selected, hits t (.inl v) := by
  classical
  simp [marksPlus]

omit [DecidableEq α] in
@[simp] theorem mem_marksMinus [DecidableEq α] (selected : Finset α)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop) (v : T.minus.Node) :
    v ∈ marksMinus T selected hits ↔ ∃ t ∈ selected, hits t (.inr v) := by
  classical
  simp [marksMinus]

theorem roots_not_marked (selected : Finset α) (level : α → ℕ)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop)
    (hpositive : ∀ t ∈ selected, 0 < level t)
    (hdepth : ∀ t ∈ selected, ∀ v, hits t v → taggedDepth T v = level t) :
    T.plus.root ∉ marksPlus T selected hits ∧
      T.minus.root ∉ marksMinus T selected hits := by
  constructor
  · intro hroot
    obtain ⟨t, ht, hhit⟩ := (mem_marksPlus T selected hits _).mp hroot
    have hh : 0 = level t := hdepth t ht (.inl T.plus.root) hhit
    have hp := hpositive t ht
    omega
  · intro hroot
    obtain ⟨t, ht, hhit⟩ := (mem_marksMinus T selected hits _).mp hroot
    have hh : 0 = level t := hdepth t ht (.inr T.minus.root) hhit
    have hp := hpositive t ht
    omega

theorem marked_level_card_le (selected : Finset α) (level : α → ℕ)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop)
    (hdepth : ∀ t ∈ selected, ∀ v, hits t v → taggedDepth T v = level t)
    (hunique : ∀ t ∈ selected, ∀ v w, hits t v → hits t w → v = w)
    (ℓ : ℕ) :
    ((marksPlus T selected hits).filter fun v => depth v = ℓ).card +
      ((marksMinus T selected hits).filter fun v => depth v = ℓ).card ≤
      (selected.filter fun t => level t = ℓ).card := by
  classical
  rw [← Finset.card_disjSum]
  apply card_le_of_unique_hit _ _ hits
  · intro v hv
    cases v with
    | inl v =>
      have hv' := Finset.mem_filter.mp (Finset.inl_mem_disjSum.mp hv)
      obtain ⟨t, ht, hhit⟩ := (mem_marksPlus T selected hits v).mp hv'.1
      refine ⟨t, Finset.mem_filter.mpr ⟨ht, ?_⟩, hhit⟩
      have hh : depth v = level t := hdepth t ht (.inl v) hhit
      exact hh.symm.trans hv'.2
    | inr v =>
      have hv' := Finset.mem_filter.mp (Finset.inr_mem_disjSum.mp hv)
      obtain ⟨t, ht, hhit⟩ := (mem_marksMinus T selected hits v).mp hv'.1
      refine ⟨t, Finset.mem_filter.mpr ⟨ht, ?_⟩, hhit⟩
      have hh : depth v = level t := hdepth t ht (.inr v) hhit
      exact hh.symm.trans hv'.2
  · intro t ht v w hv hw
    exact hunique t (Finset.mem_filter.mp ht).1 v w hv hw

theorem exists_unhit_leaf (selected : Finset α) (level : α → ℕ)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop)
    (hpositive : ∀ t ∈ selected, 0 < level t)
    (hdepth : ∀ t ∈ selected, ∀ v, hits t v → taggedDepth T v = level t)
    (hunique : ∀ t ∈ selected, ∀ v w, hits t v → hits t w → v = w)
    (hstock : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ T.height →
      (selected.filter fun t => level t = ℓ).card ≤ T.quota ℓ) :
    (∃ l : T.plus.Node, leaf l ∧
      ∀ t ∈ selected, ∀ v, hits t (.inl v) → ¬ ancestor v l) ∨
    (∃ l : T.minus.Node, leaf l ∧
      ∀ t ∈ selected, ∀ v, hits t (.inr v) → ¬ ancestor v l) := by
  have hroots := roots_not_marked T selected level hits hpositive hdepth
  have hquota : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ T.height →
      ((marksPlus T selected hits).filter fun v => depth v = ℓ).card +
        ((marksMinus T selected hits).filter fun v => depth v = ℓ).card ≤ T.quota ℓ := by
    intro ℓ hlo hhi
    exact (marked_level_card_le T selected level hits hdepth hunique ℓ).trans
      (hstock ℓ hlo hhi)
  rcases T.shared_obstruction (marksPlus T selected hits) (marksMinus T selected hits)
    hroots.1 hroots.2 hquota with ⟨l, hl, havoid⟩ | ⟨l, hl, havoid⟩
  · left
    refine ⟨l, hl, ?_⟩
    intro t ht v hhit
    exact havoid v ((mem_marksPlus T selected hits v).mpr ⟨t, ht, hhit⟩)
  · right
    refine ⟨l, hl, ?_⟩
    intro t ht v hhit
    exact havoid v ((mem_marksMinus T selected hits v).mpr ⟨t, ht, hhit⟩)

theorem exists_leaf_coverage_le_funded (selected : Finset α) (level : α → ℕ)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop)
    (fundPlus fundMinus : Finset α)
    (coverPlus : T.plus.Node → Finset α) (coverMinus : T.minus.Node → Finset α)
    (hpositive : ∀ t ∈ selected, 0 < level t)
    (hdepth : ∀ t ∈ selected, ∀ v, hits t v → taggedDepth T v = level t)
    (hunique : ∀ t ∈ selected, ∀ v w, hits t v → hits t w → v = w)
    (hstock : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ T.height →
      (selected.filter fun t => level t = ℓ).card ≤ T.quota ℓ)
    (hcoverPlus : ∀ l, leaf l → ∀ t ∈ coverPlus l,
      t ∈ fundPlus ∨ t ∈ selected ∧ ∃ v, hits t (.inl v) ∧ ancestor v l)
    (hcoverMinus : ∀ l, leaf l → ∀ t ∈ coverMinus l,
      t ∈ fundMinus ∨ t ∈ selected ∧ ∃ v, hits t (.inr v) ∧ ancestor v l) :
    (∃ l : T.plus.Node, leaf l ∧ (coverPlus l).card ≤ fundPlus.card) ∨
    (∃ l : T.minus.Node, leaf l ∧ (coverMinus l).card ≤ fundMinus.card) := by
  rcases exists_unhit_leaf T selected level hits hpositive hdepth hunique hstock with
    ⟨l, hl, havoid⟩ | ⟨l, hl, havoid⟩
  · left
    refine ⟨l, hl, Finset.card_le_card ?_⟩
    intro t ht
    rcases hcoverPlus l hl t ht with hfund | ⟨hselected, v, hhit, hancestor⟩
    · exact hfund
    · exact (havoid t hselected v hhit hancestor).elim
  · right
    refine ⟨l, hl, Finset.card_le_card ?_⟩
    intro t ht
    rcases hcoverMinus l hl t ht with hfund | ⟨hselected, v, hhit, hancestor⟩
    · exact hfund
    · exact (havoid t hselected v hhit hancestor).elim

theorem side_choice (selected : Finset α) (level : α → ℕ)
    (hits : α → (T.plus.Node ⊕ T.minus.Node) → Prop)
    (fundPlus fundMinus : Finset α)
    (coverPlus : T.plus.Node → Finset α) (coverMinus : T.minus.Node → Finset α)
    (K : ℕ)
    (hpositive : ∀ t ∈ selected, 0 < level t)
    (hdepth : ∀ t ∈ selected, ∀ v, hits t v → taggedDepth T v = level t)
    (hunique : ∀ t ∈ selected, ∀ v w, hits t v → hits t w → v = w)
    (hstock : ∀ ℓ, 1 ≤ ℓ → ℓ ≤ T.height →
      (selected.filter fun t => level t = ℓ).card ≤ T.quota ℓ)
    (hcoverPlus : ∀ l, leaf l → ∀ t ∈ coverPlus l,
      t ∈ fundPlus ∨ t ∈ selected ∧ ∃ v, hits t (.inl v) ∧ ancestor v l)
    (hcoverMinus : ∀ l, leaf l → ∀ t ∈ coverMinus l,
      t ∈ fundMinus ∨ t ∈ selected ∧ ∃ v, hits t (.inr v) ∧ ancestor v l)
    (hlowerPlus : ∀ l, leaf l → d ≤ (coverPlus l).card + 6 * K)
    (hlowerMinus : ∀ l, leaf l → d ≤ (coverMinus l).card + 6 * K) :
    d ≤ fundPlus.card + 6 * K ∨ d ≤ fundMinus.card + 6 * K := by
  rcases exists_leaf_coverage_le_funded T selected level hits fundPlus fundMinus
    coverPlus coverMinus hpositive hdepth hunique hstock hcoverPlus hcoverMinus with
    ⟨l, hl, hle⟩ | ⟨l, hl, hle⟩
  · exact Or.inl ((hlowerPlus l hl).trans (Nat.add_le_add_right hle _))
  · exact Or.inr ((hlowerMinus l hl).trans (Nat.add_le_add_right hle _))

end BinPackingGap.SideChoice

namespace BinPackingGap

section

def reductionTrees (c : ℕ) (ρ : ℝ) : CompetingTrees (depthDemand c ρ) :=
  competingTrees (depthDemand c ρ) (depthDemand_pos c ρ)

def reductionInventory (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) : InventoryData :=
  InventoryData.ofCompetingTrees G (reductionTrees c ρ)
    (repetitions (reductionTrees c ρ).quotaTotal G.n (lossAllowance c)) k

def reductionInstance (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) : Instance :=
  (reductionInventory c ρ G k).packingInstance

def reductionBinBound (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) : ℕ :=
  (reductionInventory c ρ G k).B

@[simp] theorem reductionInventory_graph (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).graph = G := rfl

@[simp] theorem reductionInventory_d (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).d = depthDemand c ρ := rfl

@[simp] theorem reductionInventory_k (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).k = k := rfl

@[simp] theorem reductionInventory_P (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).P = (reductionTrees c ρ).quotaTotal := rfl

theorem reductionInventory_R (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).R =
      repetitions (reductionInventory c ρ G k).P G.n (lossAllowance c) := rfl

theorem reductionInventory_R_pos (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    0 < (reductionInventory c ρ G k).R := repetitions_pos _ _ _

theorem reductionInventory_height_pos (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    0 < (reductionInventory c ρ G k).L := (reductionTrees c ρ).height_pos

theorem reductionInventory_plus_height (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).plus.height = (reductionInventory c ρ G k).L :=
  (reductionTrees c ρ).plus_height

theorem reductionInventory_minus_height (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) :
    (reductionInventory c ρ G k).minus.height = (reductionInventory c ρ G k).L :=
  (reductionTrees c ρ).minus_height

theorem reductionInstance_count (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ)
    (hk : k ≤ G.n) :
    (reductionInstance c ρ G k).n = 5 * reductionBinBound c ρ G k :=
  (reductionInventory c ρ G k).packingInstance_n hk

theorem reductionInstance_size_bounds (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ)
    (i : (reductionInstance c ρ G k).Item) :
    (1 / 6 : ℚ) < (reductionInstance c ρ G k).size i ∧
      (reductionInstance c ρ G k).size i < 1 :=
  (reductionInventory c ρ G k).packingInstance_size_mem_interval i

namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

private theorem selected_inventory_subclass (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (r : Role) :
    D.itemSubclass ⟨r, roleCopy p e t r⟩ =
      patternSubclass (p.tablePattern (subclass e) t) r := by
  have h := p.itemAtRole_subclass (subclass e) t r
  rw [← roleCopy_item p e t r] at h
  simpa only [subclass, Function.comp_apply, Equiv.symm_apply_apply] using h

private theorem selected_row_subclass (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) :
    D.rowSubclass (rowCopy p e t).2 =
      patternSubclass (p.tablePattern (subclass e) t) .x := by
  have h := selected_inventory_subclass p e t .x
  change D.itemSubclass ⟨.x, rowCopy p e t⟩ = _ at h
  rcases hc : rowCopy p e t with ⟨v, r⟩
  simpa only [hc, InventoryData.itemSubclass] using h

private theorem unit_global_species (u : D.GlobalCopy) (hu : D.globalUnit u = true) :
    u.1 = .up true ∨ u.1 = .um true := by
  rcases u with ⟨s, i⟩
  cases s with
  | up one => cases one <;> simp_all [InventoryData.globalUnit]
  | um one => cases one <;> simp_all [InventoryData.globalUnit]
  | edge edge permit => simp [InventoryData.globalUnit] at hu

private theorem selected_row_tm_of_um (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) {one : Bool}
    (hs : (globalCopy p e t).1 = .um one) :
    D.rowSubclass (rowCopy p e t).2 = .tm := by
  have hg := selected_inventory_subclass p e t .«global»
  have hclass : D.itemSubclass ⟨.«global», globalCopy p e t⟩ = .um := by
    rcases hc : globalCopy p e t with ⟨s, i⟩
    have hs' : s = .um one := by simpa only [hc] using hs
    subst s
    rfl
  rw [hclass] at hg
  have hx := selected_row_subclass p e t
  cases hp : p.tablePattern (subclass e) t <;> simp_all [patternSubclass]

private theorem selected_row_not_tm_of_up (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) {one : Bool}
    (hs : (globalCopy p e t).1 = .up one) :
    D.rowSubclass (rowCopy p e t).2 ≠ .tm := by
  have hg := selected_inventory_subclass p e t .«global»
  have hclass : D.itemSubclass ⟨.«global», globalCopy p e t⟩ = .up := by
    rcases hc : globalCopy p e t with ⟨s, i⟩
    have hs' : s = .up one := by simpa only [hc] using hs
    subst s
    rfl
  rw [hclass] at hg
  have hx := selected_row_subclass p e t
  cases hp : p.tablePattern (subclass e) t <;> simp_all [patternSubclass]

private theorem selected_global_resource (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) :
    p.itemAtRole (subclass e) t .«global» ∈
      globalResources e (globalCopy p e t).1 := by
  apply (mem_globalResources e _ _).mpr
  refine ⟨(globalCopy p e t).2, ?_⟩
  exact roleCopy_item p e t .«global»

private theorem funded_of_species (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v)
    {s : GlobalSpecies D.graph} (hs : (globalCopy p e t).1 = s) :
    t ∈ fundedTuples p e s v := by
  apply (mem_fundedTuples p e s v t).mpr
  refine ⟨ht, ?_⟩
  have hr := selected_global_resource p e t
  rwa [hs] at hr

theorem covering_plus_unit_funded (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v)
    (leaf : D.PlusLeaf) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .plus leaf.val)
    (hu : D.globalUnit (globalCopy p e t) = true)
    (hc : tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) :
    t ∈ fundedTuples p e (.up true) v := by
  rcases unit_global_species (globalCopy p e t) hu with hup | hum
  · exact funded_of_species p e v t ht hup
  · have hrow := selected_row_tm_of_um p e t hum
    have hfinish : 1 < tupleFinish p e t :=
      D.minus_row_completion_gt_one (rowCopy p e t).2 (globalCopy p e t)
        (localCopy p e t).2 hrow
    have hroot := TreeGeometry.nodeCell_subset_root D.graph.edges.length D.R
      D.geometryBound .plus D.plus_branch_le_geometryBound leaf.val ha
    have ha1 : a ≤ 1 := by
      simpa only [TreeGeometry.rootOffset, zero_add] using hroot.2
    exact False.elim (by linarith only [hfinish, ha1, hc.1])

theorem covering_minus_unit_funded (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v)
    (leaf : D.MinusLeaf) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .minus leaf.val)
    (hu : D.globalUnit (globalCopy p e t) = true)
    (hc : tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) :
    t ∈ fundedTuples p e (.um true) v := by
  rcases unit_global_species (globalCopy p e t) hu with hup | hum
  · have hrow := selected_row_not_tm_of_up p e t hup
    have hbase : tupleBaseline p e t ≤ 1 :=
      D.rowBaseline_le_one_of_not_tm (rowCopy p e t).2 hrow
    have hroot := TreeGeometry.nodeCell_subset_root D.graph.edges.length D.R
      D.geometryBound .minus D.minus_branch_le_geometryBound leaf.val ha
    have ha4 : 4 ≤ a := hroot.1
    exact False.elim (by linarith only [hbase, ha4, hc.2])
  · exact funded_of_species p e v t ht hum

theorem zero_lengths_cover_jobCell (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) {a : ℚ}
    (hu : D.globalUnit (globalCopy p e t) = false)
    (hl : tupleLocalLength p e t = 0)
    (hc : tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) :
    ∃ j : D.JobCopy (rowCopy p e t).1,
      a ∈ D.testCell (.inr (.inr j.1) : D.TestAt (rowCopy p e t).1) := by
  have hg := tupleGlobalLength_eq_of_unit_false p e t hu
  have hmem : a ∈ completionInterval (tupleBaseline p e t) (tupleShort p e t) 0 0
      (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) := by
    change completion (tupleBaseline p e t) (tupleShort p e t) 0 0 _ ≤ a ∧
      a < tupleBaseline p e t
    simpa only [tupleFinish, hg, hl] using hc
  change a ∈ completionInterval (D.rowBaseline (rowCopy p e t).2)
    (D.rowShort (rowCopy p e t).2) 0 0
    (Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) at hmem
  by_cases hs : D.rowShort (rowCopy p e t).2 = true
  · obtain ⟨j, _, _, hj⟩ := D.row_zero_resources_job (rowCopy p e t).2 hs
    rw [hj] at hmem
    refine ⟨j, ?_⟩
    change a ∈ Geometry.closedJobCell D.graph.edges.length D.R D.geometryBound D.L
      (D.jobPosition j)
    exact ⟨hmem.1, hmem.2.le⟩
  · have hsfalse : D.rowShort (rowCopy p e t).2 = false := by
      cases hh : D.rowShort (rowCopy p e t).2 <;> simp_all
    rw [D.row_zero_resources_empty (rowCopy p e t).2 hsfalse] at hmem
    cases hmem

theorem zero_lengths_not_cover_plus_leaf (p : Packing I b) (e : D.Item ≃ I.Item)
    (hplusheight : D.plus.height = D.L) (hminusheight : D.minus.height = D.L)
    (hL : 1 ≤ D.L) (t : p.TableBin (subclass e)) (leaf : D.PlusLeaf) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .plus leaf.val)
    (hu : D.globalUnit (globalCopy p e t) = false)
    (hl : tupleLocalLength p e t = 0) :
    ¬ (tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) := by
  intro hc
  obtain ⟨j, hj⟩ := zero_lengths_cover_jobCell p e t hu hl hc
  have hleaf : a ∈ D.testCell (.inl leaf : D.TestAt (rowCopy p e t).1) := ha
  have hdis := D.testCell_disjoint hplusheight hminusheight hL
    (show (.inl leaf : D.TestAt (rowCopy p e t).1) ≠ .inr (.inr j.1) by
      intro h; cases h)
  exact Set.disjoint_left.mp hdis hleaf hj

theorem zero_lengths_not_cover_minus_leaf (p : Packing I b) (e : D.Item ≃ I.Item)
    (hplusheight : D.plus.height = D.L) (hminusheight : D.minus.height = D.L)
    (hL : 1 ≤ D.L) (t : p.TableBin (subclass e)) (leaf : D.MinusLeaf) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .minus leaf.val)
    (hu : D.globalUnit (globalCopy p e t) = false)
    (hl : tupleLocalLength p e t = 0) :
    ¬ (tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) := by
  intro hc
  obtain ⟨j, hj⟩ := zero_lengths_cover_jobCell p e t hu hl hc
  have hleaf : a ∈ D.testCell (.inr (.inl leaf) : D.TestAt (rowCopy p e t).1) := ha
  have hdis := D.testCell_disjoint hplusheight hminusheight hL
    (show (.inr (.inl leaf) : D.TestAt (rowCopy p e t).1) ≠ .inr (.inr j.1) by
      intro h; cases h)
  exact Set.disjoint_left.mp hdis hleaf hj

end PackingCounts

open UniformTree

namespace InventoryData

variable (D : InventoryData)

def plusPoint (v : D.plus.Node) : ℚ :=
  (TreeGeometry.left D.graph.edges.length D.R D.geometryBound .plus v.val +
    TreeGeometry.right D.graph.edges.length D.R D.geometryBound .plus v.val) / 2

def minusPoint (v : D.minus.Node) : ℚ :=
  (TreeGeometry.left D.graph.edges.length D.R D.geometryBound .minus v.val +
    TreeGeometry.right D.graph.edges.length D.R D.geometryBound .minus v.val) / 2

theorem plusPoint_mem_Ico (v : D.plus.Node) :
    D.plusPoint v ∈ Set.Ico
      (TreeGeometry.left D.graph.edges.length D.R D.geometryBound .plus v.val)
      (TreeGeometry.right D.graph.edges.length D.R D.geometryBound .plus v.val) := by
  have h := TreeGeometry.left_lt_right D.graph.edges.length D.R D.geometryBound .plus v.val
  dsimp only [plusPoint, Set.mem_Ico]
  constructor <;> linarith

theorem minusPoint_mem_Ico (v : D.minus.Node) :
    D.minusPoint v ∈ Set.Ico
      (TreeGeometry.left D.graph.edges.length D.R D.geometryBound .minus v.val)
      (TreeGeometry.right D.graph.edges.length D.R D.geometryBound .minus v.val) := by
  have h := TreeGeometry.left_lt_right D.graph.edges.length D.R D.geometryBound .minus v.val
  dsimp only [minusPoint, Set.mem_Ico]
  constructor <;> linarith

theorem plusPoint_mem_cell (v : D.plus.Node) :
    D.plusPoint v ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .plus v :=
  ⟨(D.plusPoint_mem_Ico v).1, (D.plusPoint_mem_Ico v).2.le⟩

theorem minusPoint_mem_cell (v : D.minus.Node) :
    D.minusPoint v ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .minus v :=
  ⟨(D.minusPoint_mem_Ico v).1, (D.minusPoint_mem_Ico v).2.le⟩

def taggedAddress : D.plus.Node ⊕ D.minus.Node → TreeGeometry.Side × List ℕ
  | .inl v => (.plus, v.val)
  | .inr v => (.minus, v.val)

theorem taggedAddress_injective : Function.Injective D.taggedAddress := by
  intro u v h
  cases u with
  | inl u =>
    cases v with
    | inl v => exact congrArg Sum.inl (Subtype.ext (congrArg Prod.snd h))
    | inr v => have hs := congrArg Prod.fst h; cases hs
  | inr u =>
    cases v with
    | inl v => have hs := congrArg Prod.fst h; cases hs
    | inr v => exact congrArg Sum.inr (Subtype.ext (congrArg Prod.snd h))

def taggedNodeDepth (v : D.plus.Node ⊕ D.minus.Node) : ℕ :=
  (D.taggedAddress v).2.length

def taggedNodeCell (v : D.plus.Node ⊕ D.minus.Node) : Set ℚ :=
  TreeGeometry.cell D.graph.edges.length D.R D.geometryBound
    (D.taggedAddress v).1 (D.taggedAddress v).2

theorem taggedAddress_bounded (v : D.plus.Node ⊕ D.minus.Node) :
    TreeGeometry.BoundedAddress D.geometryBound (D.taggedAddress v).2 := by
  cases v with
  | inl v => exact TreeGeometry.boundedAddress_node v D.plus_branch_le_geometryBound
  | inr v => exact TreeGeometry.boundedAddress_node v D.minus_branch_le_geometryBound

end InventoryData

namespace PackingCounts

variable {D : InventoryData} {I : Instance} {b : ℕ}

def tupleHits (p : Packing I b) (e : D.Item ≃ I.Item)
    (t : p.TableBin (subclass e)) (v : D.plus.Node ⊕ D.minus.Node) : Prop :=
  D.taggedNodeDepth v = tupleLocalDepth p e t ∧
    (tupleClosedInterval p e t ∩ D.taggedNodeCell v).Nonempty

theorem selected_hits_unique (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ zeroPositiveTuples p e v)
    (u w : D.plus.Node ⊕ D.minus.Node)
    (hu : tupleHits p e t u) (hw : tupleHits p e t w) : u = w := by
  apply D.taggedAddress_injective
  exact TreeGeometry.eq_of_short_intersections D.graph.edges.length D.R D.geometryBound
    (Finset.mem_Icc.mp (selected_depth_mem p e v t ht)).2
    hu.1 hw.1 (D.taggedAddress_bounded u) (D.taggedAddress_bounded w)
    (selected_interval_length p e v t ht) hu.2 hw.2

theorem main_local_nonzero_positive (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ Coverage.mainTuplesAt p (subclass e) (label e) v)
    (hlocal : tupleLocalLength p e t ≠ 0) :
    p.itemAtRole (subclass e) t .«local» ∈ positiveLocalResources e v := by
  have hlabel := good_local_vertex p e v t
    (Coverage.mainTuplesAt_subset_good p (subclass e) (label e) v ht)
  cases hcopy : localCopy p e t with
  | mk w l =>
    have hwv : w = v := by simpa only [hcopy] using hlabel
    subst w
    rcases l with ((i | z) | j)
    · apply (mem_positiveLocalResources e v _).mpr
      refine ⟨i, ?_⟩
      rw [← roleCopy_item p e t .«local»]
      exact congrArg (fun x : (Σ w : D.Vertex, D.LocalAt w) => e ⟨.«local», x⟩)
        hcopy.symm
    · exact (hlocal (congrArg
        (fun x : (Σ w : D.Vertex, D.LocalAt w) => D.localLength x.2) hcopy)).elim
    · exact (hlocal (congrArg
        (fun x : (Σ w : D.Vertex, D.LocalAt w) => D.localLength x.2) hcopy)).elim

theorem selected_hits_plus_ancestor (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ zeroPositiveTuples p e v) (hheight : D.plus.height = D.L)
    (l : D.plus.Node) (hl : leaf l) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .plus l)
    (hcover : tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) :
    ∃ u : D.plus.Node, tupleHits p e t (.inl u) ∧ ancestor u l := by
  let ell := tupleLocalDepth p e t
  have hell : ell ≤ depth l := by
    rw [(leaf_iff_depth_eq_height l).mp hl, hheight]
    exact (Finset.mem_Icc.mp (selected_depth_mem p e v t ht)).2
  refine ⟨ancestorAt l ell, ⟨depth_ancestorAt l hell, ?_⟩, ancestorAt_ancestor l ell⟩
  refine ⟨a, ⟨hcover.1, hcover.2.le⟩, ?_⟩
  exact TreeGeometry.mem_ancestor_cell D.graph.edges.length D.R D.geometryBound .plus
    D.plus_branch_le_geometryBound l ell ha

theorem selected_hits_minus_ancestor (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (ht : t ∈ zeroPositiveTuples p e v) (hheight : D.minus.height = D.L)
    (l : D.minus.Node) (hl : leaf l) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .minus l)
    (hcover : tupleFinish p e t ≤ a ∧ a < tupleBaseline p e t) :
    ∃ u : D.minus.Node, tupleHits p e t (.inr u) ∧ ancestor u l := by
  let ell := tupleLocalDepth p e t
  have hell : ell ≤ depth l := by
    rw [(leaf_iff_depth_eq_height l).mp hl, hheight]
    exact (Finset.mem_Icc.mp (selected_depth_mem p e v t ht)).2
  refine ⟨ancestorAt l ell, ⟨depth_ancestorAt l hell, ?_⟩, ancestorAt_ancestor l ell⟩
  refine ⟨a, ⟨hcover.1, hcover.2.le⟩, ?_⟩
  exact TreeGeometry.mem_ancestor_cell D.graph.edges.length D.R D.geometryBound .minus
    D.minus_branch_le_geometryBound l ell ha

theorem covering_plus_classification (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (hplusheight : D.plus.height = D.L) (hminusheight : D.minus.height = D.L)
    (hL : 1 ≤ D.L) (l : D.plus.Node) (hl : leaf l) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .plus l)
    (ht : t ∈ tupleCovering p e v a) :
    t ∈ fundedTuples p e (.up true) v ∨
      t ∈ zeroPositiveTuples p e v ∧
        ∃ u : D.plus.Node, tupleHits p e t (.inl u) ∧ ancestor u l := by
  obtain ⟨hmain, hcover⟩ := (mem_tupleCovering p e v a t).mp ht
  cases hu : D.globalUnit (globalCopy p e t) with
  | false =>
    have hlocal : tupleLocalLength p e t ≠ 0 := by
      intro hz
      exact zero_lengths_not_cover_plus_leaf p e hplusheight hminusheight hL t
        ⟨l, hl⟩ ha hu hz hcover
    have hselected : t ∈ zeroPositiveTuples p e v :=
      (mem_zeroPositiveTuples p e v t).mpr
        ⟨hmain, hu, main_local_nonzero_positive p e v t hmain hlocal⟩
    exact Or.inr ⟨hselected,
      selected_hits_plus_ancestor p e v t hselected hplusheight l hl ha hcover⟩
  | true =>
    exact Or.inl (covering_plus_unit_funded p e v t hmain ⟨l, hl⟩ ha hu hcover)

theorem covering_minus_classification (p : Packing I b) (e : D.Item ≃ I.Item)
    (v : D.Vertex) (t : p.TableBin (subclass e))
    (hplusheight : D.plus.height = D.L) (hminusheight : D.minus.height = D.L)
    (hL : 1 ≤ D.L) (l : D.minus.Node) (hl : leaf l) {a : ℚ}
    (ha : a ∈ TreeGeometry.nodeCell D.graph.edges.length D.R D.geometryBound .minus l)
    (ht : t ∈ tupleCovering p e v a) :
    t ∈ fundedTuples p e (.um true) v ∨
      t ∈ zeroPositiveTuples p e v ∧
        ∃ u : D.minus.Node, tupleHits p e t (.inr u) ∧ ancestor u l := by
  obtain ⟨hmain, hcover⟩ := (mem_tupleCovering p e v a t).mp ht
  cases hu : D.globalUnit (globalCopy p e t) with
  | false =>
    have hlocal : tupleLocalLength p e t ≠ 0 := by
      intro hz
      exact zero_lengths_not_cover_minus_leaf p e hplusheight hminusheight hL t
        ⟨l, hl⟩ ha hu hz hcover
    have hselected : t ∈ zeroPositiveTuples p e v :=
      (mem_zeroPositiveTuples p e v t).mpr
        ⟨hmain, hu, main_local_nonzero_positive p e v t hmain hlocal⟩
    exact Or.inr ⟨hselected,
      selected_hits_minus_ancestor p e v t hselected hminusheight l hl ha hcover⟩
  | true =>
    exact Or.inl (covering_minus_unit_funded p e v t hmain ⟨l, hl⟩ ha hu hcover)

theorem side_choice_of_competingTrees (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (R k : ℕ) (p : Packing I b)
    (e : (InventoryData.ofCompetingTrees G T R k).Item ≃ I.Item)
    (v : G.Vertex) (K : ℕ)
    (hlowerPlus : ∀ l : T.plus.Node, leaf l →
      d ≤ (tupleCovering p e v ((InventoryData.ofCompetingTrees G T R k).plusPoint l)).card +
        6 * K)
    (hlowerMinus : ∀ l : T.minus.Node, leaf l →
      d ≤ (tupleCovering p e v ((InventoryData.ofCompetingTrees G T R k).minusPoint l)).card +
        6 * K) :
    d ≤ xplus p e v + 6 * K ∨ d ≤ xminus p e v + 6 * K := by
  classical
  let D := InventoryData.ofCompetingTrees G T R k
  change d ≤ (fundedTuples p e (.up true) v).card + 6 * K ∨
    d ≤ (fundedTuples p e (.um true) v).card + 6 * K
  apply SideChoice.side_choice T (zeroPositiveTuples p e v) (tupleLocalDepth p e)
    (tupleHits p e) (fundedTuples p e (.up true) v) (fundedTuples p e (.um true) v)
    (fun l => tupleCovering p e v (D.plusPoint l))
    (fun l => tupleCovering p e v (D.minusPoint l)) K
  · intro t ht
    exact Nat.lt_of_lt_of_le Nat.zero_lt_one
      (Finset.mem_Icc.mp (selected_depth_mem p e v t ht)).1
  · intro t _ w hhit
    cases w <;> exact hhit.1
  · intro t ht u w hu hw
    exact selected_hits_unique p e v t ht u w hu hw
  · intro ell hlo hhi
    exact zeroPositiveTuples_depth_card_le p e v
      ⟨ell, Finset.mem_Icc.mpr ⟨hlo, hhi⟩⟩
  · intro l hl t ht
    exact covering_plus_classification p e v t T.plus_height T.minus_height
      (Nat.succ_le_of_lt T.height_pos) l hl (D.plusPoint_mem_cell l) ht
  · intro l hl t ht
    exact covering_minus_classification p e v t T.plus_height T.minus_height
      (Nat.succ_le_of_lt T.height_pos) l hl (D.minusPoint_mem_cell l) ht
  · exact hlowerPlus
  · exact hlowerMinus

theorem side_choice_of_test_coverage (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (R k : ℕ) (p : Packing I b)
    (e : (InventoryData.ofCompetingTrees G T R k).Item ≃ I.Item)
    (v : G.Vertex) (K : ℕ)
    (hcoverage : ∀ q : (InventoryData.ofCompetingTrees G T R k).TestAt v, ∀ a : ℚ,
      a ∈ (InventoryData.ofCompetingTrees G T R k).testInterval q →
        d ≤ (tupleCovering p e v a).card + 6 * K) :
    d ≤ xplus p e v + 6 * K ∨ d ≤ xminus p e v + 6 * K := by
  apply side_choice_of_competingTrees G T R k p e v K
  · intro l hl
    exact hcoverage (.inl ⟨l, hl⟩) _
      ((InventoryData.ofCompetingTrees G T R k).plusPoint_mem_Ico l)
  · intro l hl
    exact hcoverage (.inr (.inl ⟨l, hl⟩)) _
      ((InventoryData.ofCompetingTrees G T R k).minusPoint_mem_Ico l)

end PackingCounts

end

def extractedCover (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ) {b : ℕ}
    (p : Packing (reductionInstance c ρ G k) b) : Finset G.Vertex :=
  thresholdCover (depthDemand c ρ)
    (PackingCounts.xplus p (reductionInventory c ρ G k).itemEquiv)

theorem reduction_side_choice (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ)
    (hk : k ≤ G.n) {b : ℕ} (p : Packing (reductionInstance c ρ G k) b)
    (hb : b ≤ reductionBinBound c ρ G k + c) (v : G.Vertex) :
    depthDemand c ρ ≤ PackingCounts.xplus p (reductionInventory c ρ G k).itemEquiv v +
      6 * lossAllowance c ∨
    depthDemand c ρ ≤ PackingCounts.xminus p (reductionInventory c ρ G k).itemEquiv v +
      6 * lossAllowance c := by
  let D := reductionInventory c ρ G k
  apply PackingCounts.side_choice_of_test_coverage G (reductionTrees c ρ)
    D.R k p D.itemEquiv v (lossAllowance c)
  intro q a ha
  exact D.test_coverage (reductionInventory_plus_height c ρ G k)
    (reductionInventory_minus_height c ρ G k)
    (Nat.succ_le_of_lt (reductionInventory_height_pos c ρ G k)) hk p hb v q a ha

theorem extractedCover_card_le (c : ℕ) (ρ : ℝ) (hρ : 0 < ρ)
    (G : GraphInput) (k : ℕ) (hk : k ≤ G.n) {b : ℕ}
    (p : Packing (reductionInstance c ρ G k) b)
    (hb : b ≤ reductionBinBound c ρ G k + c) :
    ((extractedCover c ρ G k p).card : ℝ) ≤ (k : ℝ) + ρ * G.n := by
  let D := reductionInventory c ρ G k
  apply thresholdCover_card_le_graph G
    (PackingCounts.xplus p D.itemEquiv) (PackingCounts.xminus p D.itemEquiv)
    (depthDemand_pos c ρ) (depthDemand_ge_72 c ρ) hk hρ (depthDemand_ge_120_div c ρ)
  · exact PackingCounts.xplus_budget p D.itemEquiv
  · exact PackingCounts.total_budget p D.itemEquiv hk
  · exact reduction_side_choice c ρ G k hk p hb

end BinPackingGap

end

end OAI
end LocalizedSource35
/- END LOCALIZED SOURCE 35/44: OAI/Computability/BinPacking/Packing/ExtractedCover.lean -/

/- BEGIN LOCALIZED SOURCE 36/44: OAI/Computability/BinPacking/Configurations/K4Soundness.lean
   SHA256: 3b967c5e99bcc9902eb88424e0a9857d4826495dfdf5630ebf6f775210a8a07a -/
section LocalizedSource36
-- localized import: OAI.Computability.BinPacking.Inventory.EdgeLongConsumption
-- localized import: OAI.Computability.BinPacking.Packing.ExtractedCover

namespace OAI

noncomputable section
open scoped BigOperators

namespace BinPackingGap

private def leftIncidencePosition (G : GraphInput) (R : ℕ) (edge : G.Edge) (j : Fin R) :
    G.IncidencePosition R (G.left edge) :=
  (⟨(edge, 0), G.endpoint_zero edge⟩, j)

private def rightIncidencePosition (G : GraphInput) (R : ℕ) (edge : G.Edge) (j : Fin R) :
    G.IncidencePosition R (G.right edge) :=
  (⟨(edge, 1), G.endpoint_one edge⟩, j)

theorem extractedCover_isCover (c : ℕ) (ρ : ℝ) (G : GraphInput) (k : ℕ)
    (hk : k ≤ G.n) {b : ℕ} (p : Packing (reductionInstance c ρ G k) b)
    (hb : b ≤ reductionBinBound c ρ G k + c) :
    G.IsCover (extractedCover c ρ G k p) := by
  classical
  let D := reductionInventory c ρ G k
  let Sleft : G.Edge → Finset (Fin D.R) := fun edge =>
    PackingCounts.goodRepetitions p D.itemEquiv (G.left edge) edge
  let Sright : G.Edge → Finset (Fin D.R) := fun edge =>
    PackingCounts.goodRepetitions p D.itemEquiv (G.right edge) edge
  let Lleft : G.Edge → Fin D.R → ℕ := fun edge j =>
    (D.edgeLongTuplesAt p edge (0, j)).card
  let Lright : G.Edge → Fin D.R → ℕ := fun edge j =>
    (D.edgeLongTuplesAt p edge (1, j)).card
  have hL : 1 ≤ D.L := Nat.succ_le_of_lt (reductionInventory_height_pos c ρ G k)
  apply thresholdCover_isCover G (PackingCounts.xplus p D.itemEquiv)
    Sleft Sright Lleft Lright (depthDemand_one_le c ρ) (depthDemand_ge_72 c ρ)
    (reductionInventory_R c ρ G k)
  · intro edge
    exact PackingCounts.goodRepetitions_card_ge_real p D.itemEquiv hL (G.left edge) edge
  · intro edge
    exact PackingCounts.goodRepetitions_card_ge_real p D.itemEquiv hL (G.right edge) edge
  · intro edge j hj
    have hj' : (edge, j) ∉ PackingCounts.excludedAt p D.itemEquiv (G.left edge) :=
      (mem_nonexcludedRepetitions _ _).mp hj
    exact D.long_matches_at_nonexcluded (reductionInventory_plus_height c ρ G k)
      (reductionInventory_minus_height c ρ G k) hL hk p hb (G.left edge)
      (leftIncidencePosition G D.R edge j) hj'
  · intro edge j hj
    have hj' : (edge, j) ∉ PackingCounts.excludedAt p D.itemEquiv (G.right edge) :=
      (mem_nonexcludedRepetitions _ _).mp hj
    exact D.long_matches_at_nonexcluded (reductionInventory_plus_height c ρ G k)
      (reductionInventory_minus_height c ρ G k) hL hk p hb (G.right edge)
      (rightIncidencePosition G D.R edge j) hj'
  · intro edge
    have hcap := D.edge_long_matches_capacity hk p hb edge Finset.univ
    have htwo : (Finset.univ : Finset (Fin 2)) = {0, 1} := by decide
    change (∑ j : Fin D.R, Lleft edge j) + (∑ j : Fin D.R, Lright edge j) ≤
      D.d * D.R + 3 * D.graph.n * lossAllowance c
    simpa [htwo, Lleft, Lright] using hcap

theorem packing_extracts_cover (c : ℕ) (ρ : ℝ) (hρ : 0 < ρ)
    (G : GraphInput) (k : ℕ) (hk : k ≤ G.n) {b : ℕ}
    (p : Packing (reductionInstance c ρ G k) b)
    (hb : b ≤ reductionBinBound c ρ G k + c) :
    ∃ C : Finset G.Vertex, G.IsCover C ∧ (C.card : ℝ) ≤ (k : ℝ) + ρ * G.n :=
  ⟨extractedCover c ρ G k p, extractedCover_isCover c ρ G k hk p hb,
    extractedCover_card_le c ρ hρ G k hk p hb⟩

end BinPackingGap

end

namespace BinPackingGap

theorem completeFourGraph_reduction_no_packing (c : ℕ) :
    ¬ HasPacking (reductionInstance c (1 / 8) completeFourGraph 2)
      (reductionBinBound c (1 / 8) completeFourGraph 2 + c) := by
  rintro ⟨p⟩
  exact completeFourGraph_no_small_cover
    (packing_extracts_cover c (1 / 8) (by norm_num) completeFourGraph 2
      (by decide) p le_rfl)

theorem completeFourGraph_reduction_opt_gap (c : ℕ) :
    reductionBinBound c (1 / 8) completeFourGraph 2 + c <
      opt (reductionInstance c (1 / 8) completeFourGraph 2) :=
  (not_hasPacking_iff_lt_opt _ _).mp (completeFourGraph_reduction_no_packing c)

end BinPackingGap

end OAI
end LocalizedSource36
/- END LOCALIZED SOURCE 36/44: OAI/Computability/BinPacking/Configurations/K4Soundness.lean -/

/- BEGIN LOCALIZED SOURCE 37/44: OAI/Computability/BinPacking/Packing/LocalJobCounts.lean
   SHA256: a6142700119d89a57bdc515fb7dfeca85268b0c8e773ac39ef7f52db0e524b15 -/
section LocalizedSource37
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Basic
-- localized import: Mathlib.Data.Fintype.Prod
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryScores

namespace OAI

namespace BinPackingGap.InventoryData

open scoped BigOperators

variable (D : InventoryData)

theorem card_jobCopy_edge_of_endpoint (v : D.Vertex) (e : D.Edge) (s : Fin 2)
    (hs : D.graph.endpoint e s = v) :
    (Finset.univ.filter (fun j : D.JobCopy v => (D.jobPosition j).1 = e)).card =
      D.d * D.R := by
  classical
  let f : Fin D.R × Fin D.d → D.JobCopy v :=
    fun rc => ((⟨(e, s), hs⟩, rc.1), rc.2)
  have hf : Function.Injective f := by
    intro a b hab
    apply Prod.ext
    · exact congrArg (fun j : D.JobCopy v => j.1.2) hab
    · exact congrArg (fun j : D.JobCopy v => j.2) hab
  have hfilter :
      Finset.univ.filter (fun j : D.JobCopy v => (D.jobPosition j).1 = e) =
        Finset.univ.image f := by
    ext j
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · intro hj
      apply Finset.mem_image.mpr
      refine ⟨(j.1.2, j.2), Finset.mem_univ _, ?_⟩
      rcases j with ⟨⟨⟨⟨e', s'⟩, hv⟩, r⟩, c⟩
      change e' = e at hj
      subst e'
      have hslot : s = s' := D.graph.endpoint_injective e (hs.trans hv.symm)
      subst s'
      rfl
    · intro hj
      obtain ⟨rc, _, rfl⟩ := Finset.mem_image.mp hj
      rfl
  rw [hfilter, Finset.card_image_of_injective _ hf, Finset.card_univ]
  simp [Nat.mul_comm]

theorem card_jobCopy_edge (v : D.Vertex) (e : D.Edge) :
    (Finset.univ.filter (fun j : D.JobCopy v => (D.jobPosition j).1 = e)).card =
      if D.graph.left e = v ∨ D.graph.right e = v then D.d * D.R else 0 := by
  classical
  by_cases hv : D.graph.left e = v ∨ D.graph.right e = v
  · rw [ite_eq_left hv]
    rcases hv with hl | hr
    · exact D.card_jobCopy_edge_of_endpoint v e 0 (by simpa using hl)
    · exact D.card_jobCopy_edge_of_endpoint v e 1 (by simpa using hr)
  · rw [ite_eq_right hv]
    apply Finset.card_eq_zero.mpr
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro j hj
    apply hv
    have he : j.1.1.val.1 = e := (Finset.mem_filter.mp hj).2
    have hep : D.graph.endpoint e j.1.1.val.2 = v := by
      rw [← he]
      exact j.1.1.property
    have hslot : j.1.1.val.2 = 0 ∨ j.1.1.val.2 = 1 := by omega
    rcases hslot with hzero | hone
    · left
      simpa only [hzero, GraphInput.endpoint_zero] using hep
    · right
      simpa only [hone, GraphInput.endpoint_one] using hep

theorem sum_card_jobCopy_edge (e : D.Edge) :
    (∑ v : D.Vertex,
      (Finset.univ.filter (fun j : D.JobCopy v => (D.jobPosition j).1 = e)).card) =
      2 * D.d * D.R := by
  classical
  calc
    _ =
        (Finset.univ.filter (fun j : D.JobCopy (D.graph.left e) =>
          (D.jobPosition j).1 = e)).card +
        (Finset.univ.filter (fun j : D.JobCopy (D.graph.right e) =>
          (D.jobPosition j).1 = e)).card := by
      refine Finset.sum_eq_add_of_mem (D.graph.left e) (D.graph.right e)
        (Finset.mem_univ _) (Finset.mem_univ _) (D.graph.left_ne_right e) ?_
      intro v _ hv
      rw [D.card_jobCopy_edge]
      simp [Ne.symm hv.1, Ne.symm hv.2]
    _ = D.d * D.R + D.d * D.R := by simp [D.card_jobCopy_edge]
    _ = 2 * D.d * D.R := by simp [two_mul, Nat.add_mul]

end BinPackingGap.InventoryData

end OAI
end LocalizedSource37
/- END LOCALIZED SOURCE 37/44: OAI/Computability/BinPacking/Packing/LocalJobCounts.lean -/

/- BEGIN LOCALIZED SOURCE 38/44: OAI/Computability/BinPacking/Inventory/IntegralSpeciesCounts.lean
   SHA256: 33ac40e852025ce2d8b4047b3c6a38dac3743dd796f5b60c15e92977580eaf9f -/
section LocalizedSource38
-- localized import: Mathlib.Algebra.BigOperators.Group.Finset.Piecewise
-- localized import: OAI.Computability.BinPacking.Packing.LocalJobCounts
-- localized import: OAI.Computability.BinPacking.Packing.PackingCoordinates

namespace OAI

namespace BinPackingGap.InventoryData

open scoped BigOperators

variable (D : InventoryData)

private theorem up_indicator_add (g : GlobalSpecies D.graph) :
    (if g = .up true then 1 else 0) + (if g = .up false then 1 else 0) =
      match g with | .up _ => 1 | _ => 0 := by
  cases g with
  | up b => cases b <;> rfl
  | um b => rfl
  | edge e b => rfl

private theorem um_indicator_add (g : GlobalSpecies D.graph) :
    (if g = .um true then 1 else 0) + (if g = .um false then 1 else 0) =
      match g with | .um _ => 1 | _ => 0 := by
  cases g with
  | up b => rfl
  | um b => cases b <;> rfl
  | edge e b => rfl

private theorem root_copy_indicator_sum (T : UniformTree) (d : ℕ) :
    (∑ node : T.Node, ∑ _j : Fin d, if node = T.root then (1 : ℕ) else 0) = d := by
  classical
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul,
    mul_ite, mul_one, mul_zero, Finset.sum_ite_eq', Finset.mem_univ, ite_true, Nat.cast_id]

theorem stateGlobalSpecies_up_true_count (v : D.Vertex) (selected : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .up true)).card =
        if selected then D.d else 0 := by
  classical
  cases selected <;>
    simp [-Finset.sum_boole, Finset.card_filter, LocalBin, MBase, TreeRow,
      Fintype.sum_sum_type, Fintype.sum_prod_type, stateGlobalSpecies,
      stateMainGlobalSpecies]
  exact root_copy_indicator_sum D.plus D.d

theorem stateGlobalSpecies_um_true_count (v : D.Vertex) (selected : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .um true)).card =
        if selected then 0 else D.d := by
  classical
  cases selected <;>
    simp [-Finset.sum_boole, Finset.card_filter, LocalBin, MBase, TreeRow,
      Fintype.sum_sum_type, Fintype.sum_prod_type, stateGlobalSpecies,
      stateMainGlobalSpecies]
  exact root_copy_indicator_sum D.minus D.d

theorem stateGlobalSpecies_up_total (v : D.Vertex) (selected : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .up true)).card +
      (Finset.univ.filter (fun b : D.LocalBin v =>
        D.stateGlobalSpecies selected b = .up false)).card = D.tPlus + D.J v := by
  classical
  simp only [Finset.card_filter, ← Finset.sum_add_distrib, D.up_indicator_add]
  simp [LocalBin, MBase, TreeRow, Fintype.sum_sum_type,
    stateGlobalSpecies, stateMainGlobalSpecies, D.card_jobCopy, tPlus,
    Nat.mul_comm, Nat.add_assoc]

theorem stateGlobalSpecies_um_total (v : D.Vertex) (selected : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .um true)).card +
      (Finset.univ.filter (fun b : D.LocalBin v =>
        D.stateGlobalSpecies selected b = .um false)).card = D.tMinus := by
  classical
  simp only [Finset.card_filter, ← Finset.sum_add_distrib, D.um_indicator_add]
  simp [LocalBin, MBase, TreeRow, Fintype.sum_sum_type,
    stateGlobalSpecies, stateMainGlobalSpecies, tMinus, Nat.mul_comm]

theorem stateGlobalSpecies_up_false_count (v : D.Vertex) (selected : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .up false)).card =
        D.tPlus + D.J v - (if selected then D.d else 0) := by
  have h := D.stateGlobalSpecies_up_total v selected
  rw [D.stateGlobalSpecies_up_true_count] at h
  omega

theorem stateGlobalSpecies_um_false_count (v : D.Vertex) (selected : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .um false)).card =
        D.tMinus - (if selected then 0 else D.d) := by
  have h := D.stateGlobalSpecies_um_total v selected
  rw [D.stateGlobalSpecies_um_true_count] at h
  omega

theorem stateGlobalSpecies_edge_count (v : D.Vertex) (selected : Bool)
    (e : D.Edge) (permit : Bool) :
    (Finset.univ.filter (fun b : D.LocalBin v =>
      D.stateGlobalSpecies selected b = .edge e permit)).card =
        if permit = !selected ∧ (D.graph.left e = v ∨ D.graph.right e = v)
        then D.d * D.R else 0 := by
  classical
  simp only [Finset.card_filter, Fintype.sum_sum_type]
  by_cases hp : permit = !selected
  · subst permit
    simpa [-Finset.sum_boole, Finset.card_filter, stateGlobalSpecies, stateMainGlobalSpecies,
      Fintype.sum_prod_type] using D.card_jobCopy_edge v e
  · have hp' : (!selected) ≠ permit := Ne.symm hp
    simp [-Finset.sum_boole, stateGlobalSpecies, stateMainGlobalSpecies, hp, hp']

theorem stateGlobalSpecies_count (v : D.Vertex) (selected : Bool)
    (g : GlobalSpecies D.graph) :
    (Finset.univ.filter (fun b : D.LocalBin v => D.stateGlobalSpecies selected b = g)).card =
      match g with
      | .up true => if selected then D.d else 0
      | .up false => D.tPlus + D.J v - (if selected then D.d else 0)
      | .um true => if selected then 0 else D.d
      | .um false => D.tMinus - (if selected then 0 else D.d)
      | .edge e permit =>
          if permit = !selected ∧ (D.graph.left e = v ∨ D.graph.right e = v)
          then D.d * D.R else 0 := by
  cases g with
  | up b =>
      cases b
      · exact D.stateGlobalSpecies_up_false_count v selected
      · exact D.stateGlobalSpecies_up_true_count v selected
  | um b =>
      cases b
      · exact D.stateGlobalSpecies_um_false_count v selected
      · exact D.stateGlobalSpecies_um_true_count v selected
  | edge e permit => exact D.stateGlobalSpecies_edge_count v selected e permit

theorem stateFlagSpecies_count (v : D.Vertex) (f : FlagSpecies) :
    (Finset.univ.filter (fun b : D.LocalBin v => D.stateFlagSpecies b = f)).card =
      match f with | .tree => D.t | .main => D.J v | .edge => D.J v := by
  classical
  simp only [Finset.card_filter, Fintype.sum_sum_type]
  cases f <;> simp [stateFlagSpecies, D.card_jobCopy, t, tPlus, tMinus,
    Nat.mul_comm, Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]

private def allGlobalRequests (g : GlobalSpecies D.graph) : ℕ :=
  ∑ v : D.Vertex, ∑ selected : Bool,
    (Finset.univ.filter (fun b : D.LocalBin v => D.stateGlobalSpecies selected b = g)).card

private theorem allGlobalRequests_up_true : D.allGlobalRequests (.up true) = D.graph.n * D.d := by
  classical
  simp [allGlobalRequests, D.stateGlobalSpecies_up_true_count]

private theorem allGlobalRequests_um_true : D.allGlobalRequests (.um true) = D.graph.n * D.d := by
  classical
  simp [allGlobalRequests, D.stateGlobalSpecies_um_true_count]

private theorem allGlobalRequests_up_total :
    D.allGlobalRequests (.up true) + D.allGlobalRequests (.up false) = 2 * D.plusSlots := by
  classical
  calc
    _ = ∑ v : D.Vertex, ∑ selected : Bool,
        ((Finset.univ.filter (fun b : D.LocalBin v =>
          D.stateGlobalSpecies selected b = .up true)).card +
          (Finset.univ.filter (fun b : D.LocalBin v =>
            D.stateGlobalSpecies selected b = .up false)).card) := by
        simp only [allGlobalRequests, Finset.sum_add_distrib]
    _ = ∑ v : D.Vertex, ∑ _selected : Bool, (D.tPlus + D.J v) := by
        simp_rw [D.stateGlobalSpecies_up_total]
    _ = _ := by simp [plusSlots, Finset.sum_add_distrib, two_mul]

private theorem allGlobalRequests_um_total :
    D.allGlobalRequests (.um true) + D.allGlobalRequests (.um false) = 2 * D.minusSlots := by
  classical
  calc
    _ = ∑ v : D.Vertex, ∑ selected : Bool,
        ((Finset.univ.filter (fun b : D.LocalBin v =>
          D.stateGlobalSpecies selected b = .um true)).card +
          (Finset.univ.filter (fun b : D.LocalBin v =>
            D.stateGlobalSpecies selected b = .um false)).card) := by
        simp only [allGlobalRequests, Finset.sum_add_distrib]
    _ = ∑ v : D.Vertex, ∑ _selected : Bool, D.tMinus := by
        simp_rw [D.stateGlobalSpecies_um_total]
    _ = _ := by simp [minusSlots, two_mul, Nat.mul_add]

private theorem allGlobalRequests_edge (e : D.Edge) (permit : Bool) :
    D.allGlobalRequests (.edge e permit) = 2 * D.d * D.R := by
  classical
  have hpair (v : D.Vertex) :
      (Finset.univ.filter (fun b : D.LocalBin v =>
        D.stateGlobalSpecies true b = .edge e permit)).card +
        (Finset.univ.filter (fun b : D.LocalBin v =>
          D.stateGlobalSpecies false b = .edge e permit)).card =
        (Finset.univ.filter (fun j : D.JobCopy v => (D.jobPosition j).1 = e)).card := by
    cases permit <;> simp [D.stateGlobalSpecies_edge_count, D.card_jobCopy_edge]
  unfold allGlobalRequests
  simp only [Fintype.sum_bool, hpair]
  exact D.sum_card_jobCopy_edge e

private theorem allGlobalRequests_eq_twice_stock (hn : D.graph.n = 2 * D.k)
    (g : GlobalSpecies D.graph) : D.allGlobalRequests g = 2 * D.globalStock g := by
  have hk : D.k ≤ D.graph.n := by omega
  have hdiff : D.graph.n - D.k = D.k := by omega
  have hup : D.allGlobalRequests (.up true) = 2 * (D.d * D.k) := by
    rw [D.allGlobalRequests_up_true, hn]
    ring
  have hum : D.allGlobalRequests (.um true) = 2 * (D.d * (D.graph.n - D.k)) := by
    rw [D.allGlobalRequests_um_true, hdiff, hn]
    ring
  cases g with
  | up b =>
      cases b
      · have ht := D.allGlobalRequests_up_total
        have hs := D.unitPlus_le_stock hk
        rw [hup] at ht
        dsimp [globalStock]
        omega
      · exact hup
  | um b =>
      cases b
      · have ht := D.allGlobalRequests_um_total
        have hs := D.unitMinus_le_stock
        rw [hum] at ht
        dsimp [globalStock]
        omega
      · exact hum
  | edge e permit =>
      simpa [globalStock, Nat.mul_assoc] using D.allGlobalRequests_edge e permit

theorem doubled_stateGlobalSpecies_count (hn : D.graph.n = 2 * D.k)
    (g : GlobalSpecies D.graph) :
    (Finset.univ.filter (fun q : (Σ v : D.Vertex, Bool × D.LocalBin v) =>
      D.stateGlobalSpecies q.2.1 q.2.2 = g)).card = 2 * D.globalStock g := by
  classical
  have hsum :
      (Finset.univ.filter (fun q : (Σ v : D.Vertex, Bool × D.LocalBin v) =>
        D.stateGlobalSpecies q.2.1 q.2.2 = g)).card = D.allGlobalRequests g := by
    simp only [Finset.card_filter, Fintype.sum_sigma, Fintype.sum_prod_type,
      allGlobalRequests]
  rw [hsum]
  exact D.allGlobalRequests_eq_twice_stock hn g

theorem doubled_stateFlagSpecies_count (f : FlagSpecies) :
    (Finset.univ.filter (fun q : (Σ v : D.Vertex, Bool × D.LocalBin v) =>
      D.stateFlagSpecies q.2.2 = f)).card = 2 * D.flagStock f := by
  classical
  have hsum :
      (Finset.univ.filter (fun q : (Σ v : D.Vertex, Bool × D.LocalBin v) =>
        D.stateFlagSpecies q.2.2 = f)).card =
        ∑ v : D.Vertex, ∑ _selected : Bool,
          (Finset.univ.filter (fun b : D.LocalBin v => D.stateFlagSpecies b = f)).card := by
    simp only [Finset.card_filter, Fintype.sum_sigma, Fintype.sum_prod_type]
  rw [hsum]
  cases f <;>
    simp [D.stateFlagSpecies_count, flagStock, treeFlags,
      jobFlags, Finset.sum_add_distrib, two_mul, Nat.mul_add]

end BinPackingGap.InventoryData

namespace BinPackingGap

namespace GraphInput

theorem IsCover.mono {G : GraphInput} {C C' : Finset G.Vertex}
    (h : G.IsCover C) (hsub : C ⊆ C') : G.IsCover C' := by
  intro e he
  exact (h e he).imp (fun hx => hsub hx) (fun hx => hsub hx)

theorem CoverAtMost.exists_exact {G : GraphInput} {k : ℕ}
    (hk : k ≤ G.n) (h : G.CoverAtMost k) :
    ∃ C : Finset G.Vertex, G.IsCover C ∧ C.card = k := by
  classical
  obtain ⟨C, hC, hcard⟩ := h
  obtain ⟨C', hsub, _, heq⟩ := Finset.exists_subsuperset_card_eq
    (Finset.subset_univ C) hcard (by simpa using hk)
  exact ⟨C', hC.mono hsub, heq⟩

theorem IsCover.endpoints {G : GraphInput} {C : Finset G.Vertex}
    (h : G.IsCover C) (e : G.Edge) : G.left e ∈ C ∨ G.right e ∈ C :=
  h _ (List.getElem_mem e.isLt)

end GraphInput

namespace InventoryData

variable (D : InventoryData)

def coverSelected (C : Finset D.Vertex) (v : D.Vertex) : Bool := decide (v ∈ C)

def permitLeft (C : Finset D.Vertex) (e : D.Edge) : Bool :=
  !D.coverSelected C (D.graph.left e) || D.coverSelected C (D.graph.right e)

def integralPermit (C : Finset D.Vertex) (e : D.Edge) (slot : Fin 2) : Bool :=
  if slot = 0 then D.permitLeft C e else !D.permitLeft C e

@[simp] theorem integralPermit_zero (C : Finset D.Vertex) (e : D.Edge) :
    D.integralPermit C e 0 = D.permitLeft C e := by simp [integralPermit]

@[simp] theorem integralPermit_one (C : Finset D.Vertex) (e : D.Edge) :
    D.integralPermit C e 1 = !D.permitLeft C e := by simp [integralPermit]

theorem integralPermit_of_unselected (C : Finset D.Vertex)
    (hC : D.graph.IsCover C) (e : D.Edge) (slot : Fin 2)
    (hnot : D.coverSelected C (D.graph.endpoint e slot) = false) :
    D.integralPermit C e slot = true := by
  have hends := hC.endpoints e
  have hs : slot = 0 ∨ slot = 1 := by omega
  rcases hs with rfl | rfl <;>
    by_cases hl : D.graph.left e ∈ C <;>
    by_cases hr : D.graph.right e ∈ C <;>
    simp_all [integralPermit, permitLeft, coverSelected, GraphInput.endpoint]

def integralGlobalSpecies (C : Finset D.Vertex) : D.PhysicalBins → GlobalSpecies D.graph
  | ⟨v, .inl b⟩ => D.stateMainGlobalSpecies (D.coverSelected C v) b
  | ⟨_, .inr j⟩ => .edge j.1.1.val.1 (D.integralPermit C j.1.1.val.1 j.1.1.val.2)

def integralFlagSpecies : D.PhysicalBins → FlagSpecies :=
  fun b => D.stateFlagSpecies b.2

theorem integral_edge_permit_of_unselected (C : Finset D.Vertex)
    (hC : D.graph.IsCover C) {v : D.Vertex} (j : D.JobCopy v)
    (hv : D.coverSelected C v = false) :
    D.integralPermit C j.1.1.val.1 j.1.1.val.2 = true := by
  apply D.integralPermit_of_unselected C hC
  simpa only [j.1.1.property] using hv

end InventoryData

end BinPackingGap

namespace BinPackingGap.InventoryData

open scoped BigOperators

variable (D : InventoryData)

private theorem integral_up_count_eq_sum (C : Finset D.Vertex) (one : Bool) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = .up one)).card =
      ∑ v : D.Vertex, (Finset.univ.filter (fun b : D.LocalBin v =>
        D.stateGlobalSpecies (D.coverSelected C v) b = .up one)).card := by
  classical
  simp only [Finset.card_filter, Fintype.sum_sigma]
  apply Finset.sum_congr rfl
  intro v _
  apply Finset.sum_congr rfl
  intro b _
  rcases b with b | j
  · rfl
  · simp [integralGlobalSpecies, stateGlobalSpecies]

private theorem integral_um_count_eq_sum (C : Finset D.Vertex) (one : Bool) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = .um one)).card =
      ∑ v : D.Vertex, (Finset.univ.filter (fun b : D.LocalBin v =>
        D.stateGlobalSpecies (D.coverSelected C v) b = .um one)).card := by
  classical
  simp only [Finset.card_filter, Fintype.sum_sigma]
  apply Finset.sum_congr rfl
  intro v _
  apply Finset.sum_congr rfl
  intro b _
  rcases b with b | j
  · rfl
  · simp [integralGlobalSpecies, stateGlobalSpecies]

private theorem sum_coverSelected (C : Finset D.Vertex) :
    (∑ v : D.Vertex, if D.coverSelected C v then D.d else 0) = D.d * C.card := by
  classical
  simp [coverSelected, Nat.mul_comm]

private theorem sum_coverUnselected (C : Finset D.Vertex) :
    (∑ v : D.Vertex, if D.coverSelected C v then 0 else D.d) =
      D.d * (D.graph.n - C.card) := by
  classical
  calc
    _ = ∑ v : D.Vertex, if v ∈ Cᶜ then D.d else 0 := by
      apply Finset.sum_congr rfl
      intro v _
      by_cases hv : v ∈ C <;> simp [coverSelected, hv]
    _ = D.d * (Cᶜ).card := by
      rw [Fintype.sum_ite_mem]
      simp [Nat.mul_comm]
    _ = _ := by simp [Finset.card_compl]

private theorem integral_up_true_count (C : Finset D.Vertex) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = .up true)).card = D.d * C.card := by
  rw [D.integral_up_count_eq_sum]
  simp_rw [D.stateGlobalSpecies_up_true_count]
  exact D.sum_coverSelected C

private theorem integral_um_true_count (C : Finset D.Vertex) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = .um true)).card =
      D.d * (D.graph.n - C.card) := by
  rw [D.integral_um_count_eq_sum]
  simp_rw [D.stateGlobalSpecies_um_true_count]
  exact D.sum_coverUnselected C

private theorem integral_up_total (C : Finset D.Vertex) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = .up true)).card +
      (Finset.univ.filter (fun b : D.PhysicalBins =>
        D.integralGlobalSpecies C b = .up false)).card = D.plusSlots := by
  rw [D.integral_up_count_eq_sum, D.integral_up_count_eq_sum,
    ← Finset.sum_add_distrib]
  simp_rw [D.stateGlobalSpecies_up_total]
  rfl

private theorem integral_um_total (C : Finset D.Vertex) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = .um true)).card +
      (Finset.univ.filter (fun b : D.PhysicalBins =>
        D.integralGlobalSpecies C b = .um false)).card = D.minusSlots := by
  rw [D.integral_um_count_eq_sum, D.integral_um_count_eq_sum,
    ← Finset.sum_add_distrib]
  simp_rw [D.stateGlobalSpecies_um_total]
  simp [minusSlots]

theorem card_integralEdgeJobs (C : Finset D.Vertex) (e : D.Edge) (permit : Bool) :
    (Finset.univ.filter (fun j : Σ v : D.Vertex, D.JobCopy v =>
      GlobalSpecies.edge (G := D.graph) j.2.1.1.val.1
        (D.integralPermit C j.2.1.1.val.1 j.2.1.1.val.2) =
      GlobalSpecies.edge e permit)).card = D.d * D.R := by
  classical
  let chosen : Fin 2 := if permit = D.permitLeft C e then 0 else 1
  have hslot (slot : Fin 2) :
      D.integralPermit C e slot = permit ↔ slot = chosen := by
    have hs : slot = 0 ∨ slot = 1 := by omega
    rcases hs with rfl | rfl <;>
      cases hp : D.permitLeft C e <;> cases permit <;>
      simp [chosen, hp]
  have hedge (e' : D.Edge) (slot : Fin 2) :
      GlobalSpecies.edge (G := D.graph) e' (D.integralPermit C e' slot) =
        GlobalSpecies.edge e permit ↔ (e', slot) = (e, chosen) := by
    rw [GlobalSpecies.edge.injEq, Prod.mk.injEq]
    constructor
    · rintro ⟨he, hp⟩
      subst e'
      exact ⟨rfl, (hslot slot).mp hp⟩
    · rintro ⟨he, hs⟩
      subst e'
      exact ⟨rfl, (hslot slot).mpr hs⟩
  calc
    _ = ((({(e, chosen)} : Finset (D.Edge × Fin 2)) ×ˢ
          (Finset.univ : Finset (Fin D.R))) ×ˢ
          (Finset.univ : Finset (Fin D.d))).card := by
      apply Finset.card_equiv D.allJobEquiv
      intro j
      simp only [Finset.mem_filter, Finset.mem_univ, true_and,
        Finset.mem_product, Finset.mem_singleton, and_true]
      exact hedge j.2.1.1.val.1 j.2.1.1.val.2
    _ = D.d * D.R := by simp [Nat.mul_comm]

theorem card_integralGlobalSpecies (C : Finset D.Vertex) (hC : C.card = D.k)
    (s : GlobalSpecies D.graph) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralGlobalSpecies C b = s)).card = D.globalStock s := by
  classical
  cases s with
  | up one =>
      cases one
      · have ht := D.integral_up_total C
        have hu := D.integral_up_true_count C
        rw [hC] at hu
        dsimp [globalStock]
        omega
      · simpa [globalStock, hC] using D.integral_up_true_count C
  | um one =>
      cases one
      · have ht := D.integral_um_total C
        have hu := D.integral_um_true_count C
        rw [hC] at hu
        dsimp [globalStock]
        omega
      · simpa [globalStock, hC] using D.integral_um_true_count C
  | edge e permit =>
      rw [Finset.card_filter, Fintype.sum_sigma]
      have hj := D.card_integralEdgeJobs C e permit
      rw [Finset.card_filter, Fintype.sum_sigma] at hj
      refine Eq.trans ?_ hj
      apply Finset.sum_congr rfl
      intro vertex _
      have hmain (base : D.MBase vertex) :
          D.stateMainGlobalSpecies (D.coverSelected C vertex) base ≠ .edge e permit := by
        rcases base with (⟨node, copy⟩ | (⟨node, copy⟩ | zero)) | job <;>
          simp [stateMainGlobalSpecies]
      rw [Fintype.sum_sum_type]
      simp only [integralGlobalSpecies, hmain, ite_false, Finset.sum_const_zero, zero_add]
      rfl

theorem card_integralFlagSpecies (f : FlagSpecies) :
    (Finset.univ.filter (fun b : D.PhysicalBins =>
      D.integralFlagSpecies b = f)).card = D.flagStock f := by
  classical
  have hsum :
      (Finset.univ.filter (fun b : D.PhysicalBins =>
        D.integralFlagSpecies b = f)).card =
        ∑ v : D.Vertex, (Finset.univ.filter (fun b : D.LocalBin v =>
          D.stateFlagSpecies b = f)).card := by
    rw [Finset.card_filter]
    simp only [Finset.card_filter, Fintype.sum_sigma, integralFlagSpecies]
    apply Finset.sum_congr rfl
    intro v _
    apply Finset.sum_congr rfl
    intro b _
    rfl
  rw [hsum]
  cases f <;> simp [D.stateFlagSpecies_count, flagStock, treeFlags, jobFlags]

end BinPackingGap.InventoryData

end OAI
end LocalizedSource38
/- END LOCALIZED SOURCE 38/44: OAI/Computability/BinPacking/Inventory/IntegralSpeciesCounts.lean -/

/- BEGIN LOCALIZED SOURCE 39/44: OAI/Computability/BinPacking/Configurations/ConfigurationLP.lean
   SHA256: 32f5adad9f2e10690f8ec14b4673a7b0561889b766e758f8725479b5de0edeef -/
section LocalizedSource39
-- localized import: Mathlib.Algebra.BigOperators.Ring.Finset
-- localized import: Mathlib.Algebra.Order.Archimedean.Basic
-- localized import: Mathlib.Algebra.Order.BigOperators.Group.Finset
-- localized import: Mathlib.Data.Fintype.Pi
-- localized import: Mathlib.Basic.Real.Basic
-- localized import: Mathlib.Tactic.FieldSimp
-- localized import: Mathlib.Topology.Algebra.Ring.Real
-- localized import: Mathlib.Topology.Order.Compact
-- localized import: OAI.Computability.BinPacking.Packing.FractionWidth

namespace OAI

noncomputable section

section

open scoped BigOperators
open Set

namespace BinPackingGap.FractionalCover

variable {I C : Type*} [Fintype C]

theorem objective_nonneg {w : C → ℝ} (hw : ∀ c, 0 ≤ w c) :
    0 ≤ objective w :=
  Finset.sum_nonneg fun c _ => hw c

theorem coordinate_le_objective {w : C → ℝ} (hw : ∀ c, 0 ≤ w c) (c : C) :
    w c ≤ objective w :=
  Finset.single_le_sum (fun j _ => hw j) (Finset.mem_univ c)

theorem objectiveSet_nonempty {a : C → I → ℝ} {d : I → ℝ}
    (hfeas : ∃ w, Feasible a d w) : (objectiveSet a d).Nonempty := by
  obtain ⟨w, hw⟩ := hfeas
  exact ⟨objective w, w, hw, rfl⟩

theorem objectiveSet_bddBelow (a : C → I → ℝ) (d : I → ℝ) :
    BddBelow (objectiveSet a d) := by
  refine ⟨0, ?_⟩
  rintro v ⟨w, hw, rfl⟩
  exact objective_nonneg hw.1

theorem value_le_of_feasible {a : C → I → ℝ} {d : I → ℝ} {w : C → ℝ}
    (hw : Feasible a d w) : value a d ≤ objective w :=
  csInf_le (objectiveSet_bddBelow a d) ⟨w, hw, rfl⟩

theorem le_value_of_lower_bound {a : C → I → ℝ} {d : I → ℝ} {b : ℝ}
    (hfeas : ∃ w, Feasible a d w)
    (hb : ∀ w, Feasible a d w → b ≤ objective w) : b ≤ value a d := by
  apply le_csInf (objectiveSet_nonempty hfeas)
  rintro v ⟨w, hw, rfl⟩
  exact hb w hw

theorem value_nonneg {a : C → I → ℝ} {d : I → ℝ}
    (hfeas : ∃ w, Feasible a d w) : 0 ≤ value a d :=
  le_value_of_lower_bound hfeas fun _ hw => objective_nonneg hw.1

theorem continuous_objective : Continuous (objective (C := C)) := by
  unfold objective
  exact continuous_finsetSum _ fun c _ => continuous_apply c

theorem continuous_coverage (a : C → I → ℝ) (i : I) :
    Continuous (fun w : C → ℝ => ∑ c, a c i * w c) :=
  continuous_finsetSum _ fun c _ => continuous_const.mul (continuous_apply c)

theorem isClosed_feasible (a : C → I → ℝ) (d : I → ℝ) :
    IsClosed {w | Feasible a d w} := by
  have hn : IsClosed {w : C → ℝ | ∀ c, 0 ≤ w c} := by
    rw [Set.ofPred_forall]
    exact isClosed_iInter fun c => isClosed_le continuous_const (continuous_apply c)
  have hd : IsClosed {w : C → ℝ | ∀ i, d i ≤ ∑ c, a c i * w c} := by
    rw [Set.ofPred_forall]
    exact isClosed_iInter fun i => isClosed_le continuous_const (continuous_coverage a i)
  exact hn.inter hd

theorem isCompact_sublevel (a : C → I → ℝ) (d : I → ℝ) (b : ℝ) :
    IsCompact {w | Feasible a d w ∧ objective w ≤ b} := by
  have hc : IsClosed {w | Feasible a d w ∧ objective w ≤ b} :=
    (isClosed_feasible a d).inter (isClosed_le continuous_objective continuous_const)
  apply (isCompact_Icc (a := (0 : C → ℝ)) (b := fun _ => b)).of_isClosed_subset hc
  intro w hw
  exact ⟨hw.1.1, fun c => (coordinate_le_objective hw.1.1 c).trans hw.2⟩

theorem exists_minimum {a : C → I → ℝ} {d : I → ℝ}
    (hfeas : ∃ w, Feasible a d w) :
    ∃ w, Feasible a d w ∧ ∀ v, Feasible a d v → objective w ≤ objective v := by
  obtain ⟨w₀, hw₀⟩ := hfeas
  obtain ⟨w, hw, hmin⟩ :=
    (isCompact_sublevel a d (objective w₀)).exists_isMinOn
      ⟨w₀, hw₀, le_rfl⟩ continuous_objective.continuousOn
  refine ⟨w, hw.1, fun v hv => ?_⟩
  rcases le_total (objective v) (objective w₀) with h | h
  · exact hmin ⟨hv, h⟩
  · exact hw.2.trans h

theorem exists_minimizer {a : C → I → ℝ} {d : I → ℝ}
    (hfeas : ∃ w, Feasible a d w) :
    ∃ w, Feasible a d w ∧ objective w = value a d := by
  obtain ⟨w, hw, hmin⟩ := exists_minimum hfeas
  exact ⟨w, hw, le_antisymm (le_value_of_lower_bound ⟨w, hw⟩ hmin)
    (value_le_of_feasible hw)⟩

theorem value_eq_of_feasible_of_lower_bound {a : C → I → ℝ} {d : I → ℝ}
    {w : C → ℝ} {b : ℝ} (hw : Feasible a d w) (hwobj : objective w = b)
    (hb : ∀ v, Feasible a d v → b ≤ objective v) : value a d = b := by
  apply le_antisymm
  · exact hwobj ▸ value_le_of_feasible hw
  · exact le_value_of_lower_bound ⟨w, hw⟩ hb

theorem sum_demand_le_mul_objective [Fintype I] {a : C → I → ℝ} {d : I → ℝ}
    {w : C → ℝ} {K : ℝ} (hw : Feasible a d w)
    (hcol : ∀ c, (∑ i, a c i) ≤ K) : (∑ i, d i) ≤ K * objective w := by
  calc
    (∑ i, d i) ≤ ∑ i, ∑ c, a c i * w c :=
      Finset.sum_le_sum fun i _ => hw.2 i
    _ = ∑ c, (∑ i, a c i) * w c := by
      rw [Finset.sum_comm]
      simp only [Finset.sum_mul]
    _ ≤ ∑ c, K * w c :=
      Finset.sum_le_sum fun c _ => mul_le_mul_of_nonneg_right (hcol c) (hw.1 c)
    _ = K * objective w := (Finset.mul_sum _ _ _).symm

theorem sum_demand_le_mul_value [Fintype I] {a : C → I → ℝ} {d : I → ℝ} {K : ℝ}
    (hfeas : ∃ w, Feasible a d w) (hcol : ∀ c, (∑ i, a c i) ≤ K) :
    (∑ i, d i) ≤ K * value a d := by
  obtain ⟨w, hw, hwobj⟩ := exists_minimizer hfeas
  rw [← hwobj]
  exact sum_demand_le_mul_objective hw hcol

variable {J : Type*} [Fintype J]

def pushforward (f : J → C) (mass : J → ℝ) : C → ℝ := by
  classical
  exact fun c => ∑ j, if f j = c then mass j else 0

omit [Fintype C] in
theorem pushforward_nonneg (f : J → C) {mass : J → ℝ}
    (hmass : ∀ j, 0 ≤ mass j) : ∀ c, 0 ≤ pushforward f mass c := by
  classical
  intro c
  exact Finset.sum_nonneg fun j _ => by
    by_cases h : f j = c
    · simpa [h] using hmass j
    · simp [h]

theorem objective_pushforward (f : J → C) (mass : J → ℝ) :
    objective (pushforward f mass) = objective mass := by
  classical
  unfold objective pushforward
  rw [Finset.sum_comm]
  simp

theorem coverage_pushforward (a : C → I → ℝ) (f : J → C) (mass : J → ℝ) (i : I) :
    (∑ c, a c i * pushforward f mass c) = ∑ j, a (f j) i * mass j := by
  classical
  simp only [pushforward, Finset.mul_sum, mul_ite, mul_zero]
  rw [Finset.sum_comm]
  simp

theorem feasible_pushforward {a : C → I → ℝ} {d : I → ℝ}
    (f : J → C) {mass : J → ℝ}
    (hmass : Feasible (fun j i => a (f j) i) d mass) :
    Feasible a d (pushforward f mass) := by
  refine ⟨pushforward_nonneg f hmass.1, fun i => ?_⟩
  rw [coverage_pushforward]
  exact hmass.2 i

end BinPackingGap.FractionalCover

end

namespace BinPackingGap

open scoped BigOperators

namespace NumericalSize

variable {I : Instance}

theorem le_one (s : NumericalSize I) : s.val ≤ 1 := by
  obtain ⟨i, _, hi⟩ := Finset.mem_image.mp s.property
  rw [← hi]
  exact I.size_le_one i

def ofItem (i : I.Item) : NumericalSize I :=
  ⟨I.size i, Finset.mem_image.mpr ⟨i, Finset.mem_univ _, rfl⟩⟩

@[simp] theorem ofItem_val (i : I.Item) : (ofItem i).val = I.size i := rfl

end NumericalSize

namespace TypeConfiguration

variable {I : Instance}

def empty (I : Instance) : TypeConfiguration I := ⟨fun _ => 0, by simp⟩

instance : Nonempty (TypeConfiguration I) := ⟨empty I⟩

def ofIndividual (H : IndividualConfiguration I) : TypeConfiguration I where
  val s := (H.val.filter fun i => I.size i = s.val).card
  property := by
    classical
    have hsum : (∑ s : NumericalSize I,
        s.val * ((H.val.filter fun i => I.size i = s.val).card : ℚ)) =
        ∑ i ∈ H.val, I.size i := by
      calc
        _ = ∑ s : NumericalSize I, ∑ i ∈ H.val,
            if I.size i = s.val then I.size i else 0 := by
          apply Finset.sum_congr rfl
          intro s _
          rw [← Finset.sum_filter]
          rw [Finset.sum_congr rfl (fun i hi => (Finset.mem_filter.mp hi).2)]
          simp [mul_comm]
        _ = ∑ i ∈ H.val, ∑ s : NumericalSize I,
            if I.size i = s.val then I.size i else 0 := by rw [Finset.sum_comm]
        _ = ∑ i ∈ H.val, I.size i := by
          apply Finset.sum_congr rfl
          intro i _
          have heq : ∀ s : NumericalSize I, I.size i = s.val ↔ NumericalSize.ofItem i = s := by
            intro s
            constructor
            · intro h
              exact Subtype.ext h
            · intro h
              exact congrArg Subtype.val h
          simp [heq]
    rw [hsum]
    exact H.property

@[simp] theorem ofIndividual_count (H : IndividualConfiguration I) (s : NumericalSize I) :
    (ofIndividual H).val s = (H.val.filter fun i => I.size i = s.val).card := rfl

theorem card_le_five (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i)
    (c : TypeConfiguration I) : (∑ s, c.val s) ≤ 5 := by
  classical
  by_contra h
  have hc : 6 ≤ ∑ s, c.val s := by omega
  have hcq : (6 : ℚ) ≤ ∑ s, (c.val s : ℚ) := by exact_mod_cast hc
  have hsize : ∀ s : NumericalSize I, (1 / 6 : ℚ) < s.val := by
    intro s
    obtain ⟨i, _, hi⟩ := Finset.mem_image.mp s.property
    simpa [hi] using hlarge i
  have hnz : ∃ s : NumericalSize I, 0 < c.val s := by
    by_contra hn
    push Not at hn
    have hz : ∀ s, c.val s = 0 := fun s => Nat.eq_zero_of_le_zero (hn s)
    simp [hz] at hc
  obtain ⟨s, hs⟩ := hnz
  have hstrict : (∑ t : NumericalSize I, (1 / 6 : ℚ) * (c.val t : ℚ)) <
      ∑ t : NumericalSize I, t.val * (c.val t : ℚ) := by
    apply Finset.sum_lt_sum
    · intro t _
      exact mul_le_mul_of_nonneg_right (le_of_lt (hsize t)) (Nat.cast_nonneg _)
    · refine ⟨s, Finset.mem_univ _, ?_⟩
      exact mul_lt_mul_of_pos_right (hsize s) (by exact_mod_cast hs)
  rw [← Finset.mul_sum] at hstrict
  have hcap := c.property
  linarith

end TypeConfiguration

theorem sum_type_multiplicity (I : Instance) :
    ∑ s : NumericalSize I, s.multiplicity = I.n := by
  classical
  simp only [NumericalSize.multiplicity, Finset.card_eq_sum_ones, Finset.sum_filter]
  rw [Finset.sum_comm]
  calc
    (∑ i : I.Item, ∑ s : NumericalSize I, if I.size i = s.val then 1 else 0) =
        ∑ _i : I.Item, 1 := by
      apply Finset.sum_congr rfl
      intro i _
      have heq : ∀ s : NumericalSize I, I.size i = s.val ↔ NumericalSize.ofItem i = s := by
        intro s
        constructor
        · intro h
          exact Subtype.ext h
        · intro h
          exact congrArg Subtype.val h
      simp [heq]
    _ = I.n := by simp [Instance.Item]

def IndividualFeasible (I : Instance) (w : IndividualConfiguration I → ℝ) : Prop :=
  FractionalCover.Feasible (individualMatrix I) (fun _ => 1) w

def TypeFeasible (I : Instance) (w : TypeConfiguration I → ℝ) : Prop :=
  FractionalCover.Feasible (typeMatrix I) (fun s => (s.multiplicity : ℝ)) w

theorem individualMatrix_sum (I : Instance) (H : IndividualConfiguration I) :
    ∑ i, individualMatrix I H i = (H.val.card : ℝ) := by
  classical
  simp [individualMatrix]

theorem typeMatrix_sum (I : Instance) (c : TypeConfiguration I) :
    ∑ s, typeMatrix I c s = ((∑ s, c.val s : ℕ) : ℝ) := by
  simp [typeMatrix]

def singletonWeights (I : Instance) : IndividualConfiguration I → ℝ :=
  FractionalCover.pushforward IndividualConfiguration.singleton (fun _ : I.Item => 1)

theorem singletonWeights_feasible (I : Instance) : IndividualFeasible I (singletonWeights I) := by
  classical
  apply FractionalCover.feasible_pushforward
  constructor
  · intro i
    norm_num
  · intro i
    simp [individualMatrix, IndividualConfiguration.singleton]

theorem singletonWeights_objective (I : Instance) :
    FractionalCover.objective (singletonWeights I) = (I.n : ℝ) := by
  rw [singletonWeights, FractionalCover.objective_pushforward]
  simp [FractionalCover.objective, Instance.Item]

theorem individualLP_attained (I : Instance) :
    ∃ w, IndividualFeasible I w ∧ FractionalCover.objective w = individualLP I :=
  FractionalCover.exists_minimizer ⟨singletonWeights I, singletonWeights_feasible I⟩

theorem individualLP_nonneg (I : Instance) : 0 ≤ individualLP I :=
  FractionalCover.value_nonneg ⟨singletonWeights I, singletonWeights_feasible I⟩

theorem individualLP_le_n (I : Instance) : individualLP I ≤ I.n := by
  rw [← singletonWeights_objective I]
  exact FractionalCover.value_le_of_feasible (singletonWeights_feasible I)

theorem typeMatrix_ofIndividual (I : Instance) (H : IndividualConfiguration I)
    (s : NumericalSize I) :
    typeMatrix I (TypeConfiguration.ofIndividual H) s =
      ∑ i : I.Item, if I.size i = s.val then individualMatrix I H i else 0 := by
  classical
  change ((H.val.filter fun i => I.size i = s.val).card : ℝ) = _
  calc
    _ = ∑ i ∈ H.val, if I.size i = s.val then (1 : ℝ) else 0 := by
      simp
    _ = ∑ i ∈ H.val, if I.size i = s.val then individualMatrix I H i else 0 := by
      apply Finset.sum_congr rfl
      intro i hi
      simp [individualMatrix, hi]
    _ = ∑ i : I.Item, if I.size i = s.val then individualMatrix I H i else 0 := by
      apply Finset.sum_subset (Finset.subset_univ H.val)
      intro i _ hi
      simp [individualMatrix, hi]

def projectWeights (I : Instance) (w : IndividualConfiguration I → ℝ) :
    TypeConfiguration I → ℝ :=
  FractionalCover.pushforward TypeConfiguration.ofIndividual w

theorem projectWeights_objective (I : Instance) (w : IndividualConfiguration I → ℝ) :
    FractionalCover.objective (projectWeights I w) = FractionalCover.objective w :=
  FractionalCover.objective_pushforward _ _

theorem projectWeights_feasible (I : Instance) {w : IndividualConfiguration I → ℝ}
    (hw : IndividualFeasible I w) : TypeFeasible I (projectWeights I w) := by
  classical
  apply FractionalCover.feasible_pushforward
  refine ⟨hw.1, fun s => ?_⟩
  have hcoverage := Finset.sum_le_sum (s := Finset.univ) (fun i _ =>
    show (if I.size i = s.val then (1 : ℝ) else 0) ≤
      if I.size i = s.val then ∑ H, individualMatrix I H i * w H else 0 by
        split_ifs
        · exact hw.2 i
        · rfl)
  have hleft : (∑ i : I.Item, if I.size i = s.val then (1 : ℝ) else 0) =
      s.multiplicity := by
    simp [NumericalSize.multiplicity]
  have hright :
      (∑ i : I.Item, if I.size i = s.val then ∑ H, individualMatrix I H i * w H else 0) =
      ∑ H, typeMatrix I (TypeConfiguration.ofIndividual H) s * w H := by
    simp_rw [typeMatrix_ofIndividual, Finset.sum_mul]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    split_ifs with h
    · simp
    · simp
  simpa only [hleft, hright] using hcoverage

theorem typeLP_attained (I : Instance) :
    ∃ w, TypeFeasible I w ∧ FractionalCover.objective w = typeLP I :=
  FractionalCover.exists_minimizer
    ⟨projectWeights I (singletonWeights I), projectWeights_feasible I (singletonWeights_feasible I)⟩

theorem typeLP_nonneg (I : Instance) : 0 ≤ typeLP I :=
  FractionalCover.value_nonneg
    ⟨projectWeights I (singletonWeights I), projectWeights_feasible I (singletonWeights_feasible I)⟩

theorem typeLP_le_individualLP (I : Instance) : typeLP I ≤ individualLP I := by
  obtain ⟨w, hw, hobj⟩ := individualLP_attained I
  calc
    typeLP I ≤ FractionalCover.objective (projectWeights I w) :=
      FractionalCover.value_le_of_feasible (projectWeights_feasible I hw)
    _ = individualLP I := (projectWeights_objective I w).trans hobj

theorem individualLP_eq_zero_of_n_eq_zero (I : Instance) (h : I.n = 0) :
    individualLP I = 0 := by
  have hle := individualLP_le_n I
  rw [h, Nat.cast_zero] at hle
  exact le_antisymm hle (individualLP_nonneg I)

theorem typeLP_eq_zero_of_n_eq_zero (I : Instance) (h : I.n = 0) : typeLP I = 0 := by
  apply le_antisymm
  · simpa [individualLP_eq_zero_of_n_eq_zero I h] using typeLP_le_individualLP I
  · exact typeLP_nonneg I

namespace Packing

def fractionalWeights {I : Instance} {b : ℕ} (p : Packing I b) :
    IndividualConfiguration I → ℝ :=
  FractionalCover.pushforward p.configuration (fun _ : Fin b => 1)

theorem fractionalWeights_feasible {I : Instance} {b : ℕ} (p : Packing I b) :
    IndividualFeasible I p.fractionalWeights := by
  classical
  apply FractionalCover.feasible_pushforward
  constructor
  · intro j
    norm_num
  · intro i
    simp [individualMatrix, configuration]

theorem fractionalWeights_objective {I : Instance} {b : ℕ} (p : Packing I b) :
    FractionalCover.objective p.fractionalWeights = (b : ℝ) := by
  rw [fractionalWeights, FractionalCover.objective_pushforward]
  simp [FractionalCover.objective]

end Packing

theorem individualLP_le_opt (I : Instance) : individualLP I ≤ (opt I : ℝ) := by
  obtain ⟨p⟩ := opt_attained I
  rw [← p.fractionalWeights_objective]
  exact FractionalCover.value_le_of_feasible p.fractionalWeights_feasible

theorem typeLP_le_opt (I : Instance) : typeLP I ≤ (opt I : ℝ) :=
  (typeLP_le_individualLP I).trans (individualLP_le_opt I)

theorem n_le_five_mul_individual_objective (I : Instance)
    (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i)
    {w : IndividualConfiguration I → ℝ} (hw : IndividualFeasible I w) :
    (I.n : ℝ) ≤ 5 * FractionalCover.objective w := by
  have hcol : ∀ H : IndividualConfiguration I, (∑ i, individualMatrix I H i) ≤ 5 := by
    intro H
    rw [individualMatrix_sum]
    exact_mod_cast H.card_le_five hlarge
  simpa [Instance.Item] using FractionalCover.sum_demand_le_mul_objective hw hcol

theorem n_le_five_mul_type_objective (I : Instance)
    (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i)
    {w : TypeConfiguration I → ℝ} (hw : TypeFeasible I w) :
    (I.n : ℝ) ≤ 5 * FractionalCover.objective w := by
  have hcol : ∀ c : TypeConfiguration I, (∑ s, typeMatrix I c s) ≤ 5 := by
    intro c
    rw [typeMatrix_sum]
    exact_mod_cast c.card_le_five hlarge
  have h := FractionalCover.sum_demand_le_mul_objective hw hcol
  have hdem : (∑ s : NumericalSize I, (s.multiplicity : ℝ)) = I.n := by
    rw [← Nat.cast_sum, sum_type_multiplicity]
  simpa only [hdem] using h

theorem n_le_five_mul_individualLP (I : Instance)
    (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i) : (I.n : ℝ) ≤ 5 * individualLP I := by
  obtain ⟨w, hw, hobj⟩ := individualLP_attained I
  rw [← hobj]
  exact n_le_five_mul_individual_objective I hlarge hw

theorem n_le_five_mul_typeLP (I : Instance)
    (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i) : (I.n : ℝ) ≤ 5 * typeLP I := by
  obtain ⟨w, hw, hobj⟩ := typeLP_attained I
  rw [← hobj]
  exact n_le_five_mul_type_objective I hlarge hw

theorem bothLP_eq_of_physical_witness (I : Instance) (B : ℕ)
    (hcount : I.n = 5 * B) (hlarge : ∀ i, (1 / 6 : ℚ) < I.size i)
    (w : IndividualConfiguration I → ℝ) (hw : IndividualFeasible I w)
    (hobj : FractionalCover.objective w = (B : ℝ)) :
    individualLP I = (B : ℝ) ∧ typeLP I = (B : ℝ) := by
  have hcountR : (I.n : ℝ) = 5 * (B : ℝ) := by exact_mod_cast hcount
  have hilow := n_le_five_mul_individualLP I hlarge
  have htlow := n_le_five_mul_typeLP I hlarge
  have hiup : individualLP I ≤ (B : ℝ) := by
    rw [← hobj]
    exact FractionalCover.value_le_of_feasible hw
  have htup : typeLP I ≤ (B : ℝ) := (typeLP_le_individualLP I).trans hiup
  constructor <;> linarith

end BinPackingGap

end

end OAI
end LocalizedSource39
/- END LOCALIZED SOURCE 39/44: OAI/Computability/BinPacking/Configurations/ConfigurationLP.lean -/

/- BEGIN LOCALIZED SOURCE 40/44: OAI/Computability/BinPacking/Inventory/PhysicalPoolLift.lean
   SHA256: c707bea0305d794014ce812a40f3e5f5be88e05e70ff8239ebf2e3617b4384fe -/
section LocalizedSource40
-- localized import: Mathlib.Data.Fintype.BigOperators
-- localized import: Mathlib.Tactic.FieldSimp
-- localized import: Mathlib.Tactic.Ring
-- localized import: OAI.Computability.BinPacking.Configurations.ConfigurationLP

namespace OAI

noncomputable section

open scoped BigOperators

namespace BinPackingGap

structure PoolTemplates (I : Instance) (T U F : Type*) where
  base : T → Finset I.Item
  globalPool : U → Finset I.Item
  flagPool : F → Finset I.Item
  globalSpecies : T → U
  flagSpecies : T → F
  global_nonempty : ∀ t, (globalPool (globalSpecies t)).Nonempty
  flag_nonempty : ∀ t, (flagPool (flagSpecies t)).Nonempty
  base_global : ∀ t, Disjoint (base t) (globalPool (globalSpecies t))
  base_flag : ∀ t, Disjoint (base t) (flagPool (flagSpecies t))
  global_flag : ∀ t,
    Disjoint (globalPool (globalSpecies t)) (flagPool (flagSpecies t))
  capacity : ∀ t (u : {i // i ∈ globalPool (globalSpecies t)})
    (f : {i // i ∈ flagPool (flagSpecies t)}),
    (∑ i ∈ base t ∪ {u.val, f.val}, I.size i) ≤ 1

namespace PoolTemplates

variable {I : Instance} {T U F : Type*} [Fintype T]

variable (D : PoolTemplates I T U F)

abbrev Globals (t : T) := {i // i ∈ D.globalPool (D.globalSpecies t)}
abbrev Flags (t : T) := {i // i ∈ D.flagPool (D.flagSpecies t)}
abbrev Sample := (t : T) × (D.Globals t × D.Flags t)

def column (t : T) (u : D.Globals t) (f : D.Flags t) : IndividualConfiguration I :=
  ⟨D.base t ∪ {u.val, f.val}, D.capacity t u f⟩

def sampleColumn (s : D.Sample) : IndividualConfiguration I :=
  D.column s.1 s.2.1 s.2.2

def templateMass (t : T) : ℝ :=
  1 / (2 * ((D.globalPool (D.globalSpecies t)).card : ℝ) *
    ((D.flagPool (D.flagSpecies t)).card : ℝ))

def sampleMass (s : D.Sample) : ℝ := D.templateMass s.1

def weights : IndividualConfiguration I → ℝ :=
  FractionalCover.pushforward D.sampleColumn D.sampleMass

omit [Fintype T] in
theorem templateMass_nonneg (t : T) : 0 ≤ D.templateMass t := by
  unfold templateMass
  positivity

omit [Fintype T] in
theorem global_card_ne_zero (t : T) :
    ((D.globalPool (D.globalSpecies t)).card : ℝ) ≠ 0 := by
  exact_mod_cast (Finset.card_pos.mpr (D.global_nonempty t)).ne'

omit [Fintype T] in
theorem flag_card_ne_zero (t : T) :
    ((D.flagPool (D.flagSpecies t)).card : ℝ) ≠ 0 := by
  exact_mod_cast (Finset.card_pos.mpr (D.flag_nonempty t)).ne'

omit [Fintype T] in
theorem sum_templateMass (t : T) :
    (∑ _u : D.Globals t, ∑ _f : D.Flags t, D.templateMass t) = (1 / 2 : ℝ) := by
  have hu := D.global_card_ne_zero t
  have hf := D.flag_card_ne_zero t
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_coe, nsmul_eq_mul]
  unfold templateMass
  field_simp [hu, hf]

theorem objective_weights :
    FractionalCover.objective D.weights = (Fintype.card T : ℝ) / 2 := by
  rw [weights, FractionalCover.objective_pushforward]
  unfold FractionalCover.objective sampleMass
  rw [Fintype.sum_sigma]
  simp only [Fintype.sum_prod_type, sum_templateMass]
  simp [div_eq_mul_inv]

theorem sum_pool_eq (S : Finset I.Item) (i : I.Item) (a : ℝ) :
    (∑ u : {j // j ∈ S}, if i = u.val then a else 0) =
      if i ∈ S then a else 0 := by
  classical
  by_cases hi : i ∈ S
  · have he : ∀ u : {j // j ∈ S}, i = u.val ↔ u = ⟨i, hi⟩ := by
      intro u
      constructor
      · intro h
        exact Subtype.ext h.symm
      · intro h
        exact (congrArg Subtype.val h).symm
    simp only [he]
    simp [hi]
  · have he : ∀ u : {j // j ∈ S}, i ≠ u.val := by
      intro u h
      exact hi (h.symm ▸ u.property)
    simp [he, hi]

omit [Fintype T] in
theorem template_coverage (t : T) (i : I.Item) :
    (∑ u : D.Globals t, ∑ f : D.Flags t,
      (if i ∈ (D.column t u f).val then (1 : ℝ) else 0) * D.templateMass t) =
    (if i ∈ D.base t then (1 / 2 : ℝ) else 0) +
    (if i ∈ D.globalPool (D.globalSpecies t) then
      1 / (2 * ((D.globalPool (D.globalSpecies t)).card : ℝ)) else 0) +
    (if i ∈ D.flagPool (D.flagSpecies t) then
      1 / (2 * ((D.flagPool (D.flagSpecies t)).card : ℝ)) else 0) := by
  classical
  have hu := D.global_card_ne_zero t
  have hf := D.flag_card_ne_zero t
  by_cases hb : i ∈ D.base t
  · have hgu : i ∉ D.globalPool (D.globalSpecies t) :=
      fun h => Finset.disjoint_left.mp (D.base_global t) hb h
    have hfl : i ∉ D.flagPool (D.flagSpecies t) :=
      fun h => Finset.disjoint_left.mp (D.base_flag t) hb h
    simpa [column, hb, hgu, hfl] using D.sum_templateMass t
  · by_cases hg : i ∈ D.globalPool (D.globalSpecies t)
    · have hfl : i ∉ D.flagPool (D.flagSpecies t) :=
        fun h => Finset.disjoint_left.mp (D.global_flag t) hg h
      have hcol : ∀ u : D.Globals t, ∀ f : D.Flags t,
          i ∈ (D.column t u f).val ↔ i = u.val := by
        intro u f
        have hn : i ≠ f.val := fun h => hfl (h.symm ▸ f.property)
        simp [column, hb, hn]
      simp only [hcol, ite_mul, one_mul, zero_mul]
      rw [Finset.sum_comm]
      simp_rw [sum_pool_eq]
      simp only [hb, hg, hfl, ite_false, ite_true, zero_add, add_zero,
        Finset.sum_const, Finset.card_univ, Fintype.card_coe, nsmul_eq_mul]
      unfold templateMass
      field_simp [hu, hf]
    · by_cases hfl : i ∈ D.flagPool (D.flagSpecies t)
      · have hcol : ∀ u : D.Globals t, ∀ f : D.Flags t,
            i ∈ (D.column t u f).val ↔ i = f.val := by
          intro u f
          have hn : i ≠ u.val := fun h => hg (h.symm ▸ u.property)
          simp [column, hb, hn]
        simp only [hcol, ite_mul, one_mul, zero_mul]
        simp_rw [sum_pool_eq]
        simp only [hb, hg, hfl, ite_false, ite_true, zero_add,
          Finset.sum_const, Finset.card_univ, Fintype.card_coe, nsmul_eq_mul]
        unfold templateMass
        field_simp [hu, hf]
      · have hcol : ∀ u : D.Globals t, ∀ f : D.Flags t,
            i ∉ (D.column t u f).val := by
          intro u f
          have hnu : i ≠ u.val := fun h => hg (h.symm ▸ u.property)
          have hnf : i ≠ f.val := fun h => hfl (h.symm ▸ f.property)
          simp [column, hb, hnu, hnf]
        simp [hcol, hb, hg, hfl]

theorem sum_by_species {S : Type*} [Fintype S] [DecidableEq S]
    (species : T → S) (a : S → ℝ) :
    (∑ t, a (species t)) =
      ∑ s, ((Finset.univ.filter (fun t => species t = s)).card : ℝ) * a s := by
  classical
  calc
    (∑ t, a (species t)) = ∑ t, ∑ s, if species t = s then a s else 0 := by simp
    _ = ∑ s, ∑ t, if species t = s then a s else 0 := Finset.sum_comm
    _ = _ := by
      apply Finset.sum_congr rfl
      intro s _
      rw [← Finset.sum_filter]
      simp

theorem sum_pool_demands {S : Type*} [Fintype S] [DecidableEq S]
    (species : T → S) (pool : S → Finset I.Item)
    (hdemand : ∀ s, (Finset.univ.filter (fun t => species t = s)).card =
      2 * (pool s).card) (i : I.Item) :
    (∑ t, if i ∈ pool (species t) then
      1 / (2 * ((pool (species t)).card : ℝ)) else 0) =
    ∑ s, if i ∈ pool s then (1 : ℝ) else 0 := by
  classical
  rw [sum_by_species species (fun s =>
    if i ∈ pool s then 1 / (2 * ((pool s).card : ℝ)) else 0)]
  apply Finset.sum_congr rfl
  intro s _
  rw [hdemand s]
  by_cases hi : i ∈ pool s
  · have hs : ((pool s).card : ℝ) ≠ 0 := by
      exact_mod_cast (Finset.card_pos.mpr ⟨i, hi⟩).ne'
    simp only [hi, ite_true, Nat.cast_mul, Nat.cast_ofNat]
    field_simp [hs]
  · simp [hi]

variable [Fintype U] [Fintype F] [DecidableEq U] [DecidableEq F]

theorem weights_feasible
    (labeled : Finset I.Item)
    (hbase : ∀ i, (Finset.univ.filter (fun t => i ∈ D.base t)).card =
      if i ∈ labeled then 2 else 0)
    (hglobal : ∀ u, (Finset.univ.filter (fun t => D.globalSpecies t = u)).card =
      2 * (D.globalPool u).card)
    (hflag : ∀ f, (Finset.univ.filter (fun t => D.flagSpecies t = f)).card =
      2 * (D.flagPool f).card)
    (hpartition : ∀ i,
      (if i ∈ labeled then (1 : ℝ) else 0) +
      (∑ u, if i ∈ D.globalPool u then (1 : ℝ) else 0) +
      (∑ f, if i ∈ D.flagPool f then (1 : ℝ) else 0) = 1) :
    IndividualFeasible I D.weights := by
  classical
  refine ⟨FractionalCover.pushforward_nonneg D.sampleColumn
    (fun s => D.templateMass_nonneg s.1), ?_⟩
  intro i
  change 1 ≤ ∑ H, individualMatrix I H i * D.weights H
  rw [weights, FractionalCover.coverage_pushforward]
  change 1 ≤ ∑ s : D.Sample,
    (if i ∈ (D.column s.1 s.2.1 s.2.2).val then (1 : ℝ) else 0) * D.templateMass s.1
  rw [Fintype.sum_sigma]
  simp only [Fintype.sum_prod_type, template_coverage, Finset.sum_add_distrib]
  rw [sum_pool_demands D.globalSpecies D.globalPool hglobal,
    sum_pool_demands D.flagSpecies D.flagPool hflag]
  have hb : (∑ t, if i ∈ D.base t then (1 / 2 : ℝ) else 0) =
      if i ∈ labeled then (1 : ℝ) else 0 := by
    rw [← Finset.sum_filter]
    simp only [Finset.sum_const, nsmul_eq_mul, hbase]
    split_ifs <;> norm_num
  simpa only [hb, hpartition i] using (le_refl (1 : ℝ))

end PoolTemplates

end BinPackingGap

end

end OAI
end LocalizedSource40
/- END LOCALIZED SOURCE 40/44: OAI/Computability/BinPacking/Inventory/PhysicalPoolLift.lean -/

/- BEGIN LOCALIZED SOURCE 41/44: OAI/Computability/BinPacking/Packing/ConstructLocalState.lean
   SHA256: 5a47264ebc65c8541061d0e0ccc775f4d15d8e2c466eb4efc301741700855bde -/
section LocalizedSource41
-- localized import: OAI.Computability.BinPacking.Inventory.LocalCompletionCoverage

namespace OAI

noncomputable section

namespace BinPackingGap.InventoryData

def constructedLocalState (G : GraphInput) {d : ℕ} (T : CompetingTrees d)
    (hd : 0 < d) (R k : ℕ) (v : G.Vertex) (selected : Bool) :
    (ofCompetingTrees G T R k).LocalState v selected where
  localEquiv := LocalResourceAllocation.localEquiv G T hd R k v selected
  anchorEquiv := Classical.choose
    (LocalCompletionCoverage.exists_anchorEquiv G T hd R k v selected)
  completion_le_deadline := Classical.choose_spec
    (LocalCompletionCoverage.exists_anchorEquiv G T hd R k v selected)

end BinPackingGap.InventoryData

end

end OAI
end LocalizedSource41
/- END LOCALIZED SOURCE 41/44: OAI/Computability/BinPacking/Packing/ConstructLocalState.lean -/

/- BEGIN LOCALIZED SOURCE 42/44: OAI/Computability/BinPacking/Packing/LocalTemplateBases.lean
   SHA256: e0fae249c940735e068f8b46cc6912fa41a139d396c013324af7eeb6633c10e3 -/
section LocalizedSource42
-- localized import: OAI.Computability.BinPacking.Inventory.InventoryPrefixConservation

namespace OAI

namespace BinPackingGap

open scoped BigOperators

theorem encoded_pattern_role_sum {n : ℕ} (p : Pattern) (v : Fin n) (w : Role → ℚ) :
    (∑ r, encodedSize (patternSubclass p r) (tableRoleLabel v v v r) (w r)) =
      1 + nu n * ∑ r, w r := by
  have hp : (∑ r, primaryScore (patternSubclass p r)) = 0 :=
    sum_primaryScore_eq_zero_of_coefficients _ (pattern_primaryCoeff_sum p)
  have hq : (∑ r, secondaryScore (patternSubclass p r) (tableRoleLabel v v v r)) = 0 := by
    rw [Role.sum_univ]
    cases p <;>
      simp [secondaryScore, patternSubclass, Subclass.role, tableRoleLabel] <;> ring
  have hpQ : (∑ r, (primaryScore (patternSubclass p r) : ℚ)) = 0 := by
    exact_mod_cast hp
  have hqQ : (∑ r, (secondaryScore (patternSubclass p r)
      (tableRoleLabel v v v r) : ℚ)) = 0 := by
    exact_mod_cast hq
  calc
    _ = (∑ _r : Role, (1 / 5 : ℚ)) +
        gamma * (∑ r, (primaryScore (patternSubclass p r) : ℚ)) +
        mu n * (∑ r, (secondaryScore (patternSubclass p r)
          (tableRoleLabel v v v r) : ℚ)) + nu n * ∑ r, w r := by
      simp only [encodedSize, Finset.sum_add_distrib, Finset.mul_sum]
    _ = _ := by rw [hpQ, hqQ]; norm_num

namespace InventoryData

variable (D : InventoryData)

def localTemplateItems {v : D.Vertex} (row : D.RowAt v) (anchor : D.AnchorAt v)
    (u : D.GlobalCopy) (l : D.LocalAt v) (flag : D.FlagCopy) : Role → D.Item
  | .x => ⟨.x, ⟨v, row⟩⟩
  | .anchor => ⟨.anchor, ⟨v, anchor⟩⟩
  | .«global» => ⟨.«global», u⟩
  | .«local» => ⟨.«local», ⟨v, l⟩⟩
  | .flag => ⟨.flag, flag⟩

@[simp] theorem localTemplateItems_role {v : D.Vertex}
    (row : D.RowAt v) (anchor : D.AnchorAt v) (u : D.GlobalCopy)
    (l : D.LocalAt v) (flag : D.FlagCopy) (r : Role) :
    D.itemRole (D.localTemplateItems row anchor u l flag r) = r := by
  cases r <;> rfl

theorem localTemplateItems_injective {v : D.Vertex}
    (row : D.RowAt v) (anchor : D.AnchorAt v) (u : D.GlobalCopy)
    (l : D.LocalAt v) (flag : D.FlagCopy) :
    Function.Injective (D.localTemplateItems row anchor u l flag) := by
  intro r s h
  simpa only [localTemplateItems_role] using congrArg D.itemRole h

@[simp] theorem localTemplateItems_label {v : D.Vertex}
    (row : D.RowAt v) (anchor : D.AnchorAt v) (u : D.GlobalCopy)
    (l : D.LocalAt v) (flag : D.FlagCopy) (r : Role) :
    D.itemLabel (D.localTemplateItems row anchor u l flag r) =
      tableRoleLabel v v v r := by
  cases r <;> rfl

theorem localTemplate_coordinate_sum {v : D.Vertex}
    (row : D.RowAt v) (anchor : D.AnchorAt v) (u : D.GlobalCopy)
    (l : D.LocalAt v) (flag : D.FlagCopy) :
    (∑ r, D.itemCoordinate (D.localTemplateItems row anchor u l flag r)) =
      D.rowCoordinate row + D.anchorCoordinate anchor + D.globalCoordinate u -
        D.localLength l := by
  rw [Role.sum_univ]
  simp only [localTemplateItems, itemCoordinate, localCoordinate, add_zero]
  ring

theorem localTemplate_size_sum {v : D.Vertex}
    (row : D.RowAt v) (anchor : D.AnchorAt v) (u : D.GlobalCopy)
    (l : D.LocalAt v) (flag : D.FlagCopy) (p : Pattern)
    (hpattern : ∀ r, D.itemSubclass (D.localTemplateItems row anchor u l flag r) =
      patternSubclass p r) :
    (∑ r, D.itemSize (D.localTemplateItems row anchor u l flag r)) =
      1 + nu D.graph.n * ∑ r,
        D.itemCoordinate (D.localTemplateItems row anchor u l flag r) := by
  simp only [itemSize, hpattern, localTemplateItems_label]
  exact encoded_pattern_role_sum p v _

def stateMainPattern {v : D.Vertex} : D.MBase v → Pattern
  | .inl (.inl _) => .plusTree
  | .inl (.inr (.inl _)) => .minusTree
  | .inl (.inr (.inr _)) => .plusTree
  | .inr _ => .mainJob

theorem stateMainTemplate_pattern {v : D.Vertex} (selected : Bool)
    (b z : D.MBase v) (l : D.DMAt v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = D.stateMainGlobalSpecies selected b)
    (hf : f.1 = D.stateFlagSpecies (.inl b)) (r : Role) :
    D.itemSubclass (D.localTemplateItems (D.stateMainRow v selected b)
      (.inl z) u (.inl l) f r) = patternSubclass (D.stateMainPattern b) r := by
  rcases u with ⟨us, ui⟩
  rcases f with ⟨fs, fi⟩
  change us = D.stateMainGlobalSpecies selected b at hu
  change fs = D.stateFlagSpecies (.inl b) at hf
  subst us
  subst fs
  rcases b with (⟨node, copy⟩ | (⟨node, copy⟩ | padding)) | job
  all_goals cases r <;> rfl

theorem stateMainGlobal_coordinate {v : D.Vertex} (selected : Bool)
    (b : D.MBase v) (u : D.GlobalCopy)
    (hu : u.1 = D.stateMainGlobalSpecies selected b) :
    D.globalCoordinate u = -D.stateMainLength selected b := by
  rcases u with ⟨us, ui⟩
  change us = D.stateMainGlobalSpecies selected b at hu
  subst us
  rcases b with (⟨node, copy⟩ | (⟨node, copy⟩ | padding)) | job <;> rfl

theorem stateMainTemplate_size_eq {v : D.Vertex} (selected : Bool)
    (b z : D.MBase v) (l : D.DMAt v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = D.stateMainGlobalSpecies selected b)
    (hf : f.1 = D.stateFlagSpecies (.inl b)) :
    (∑ r, D.itemSize (D.localTemplateItems (D.stateMainRow v selected b)
      (.inl z) u (.inl l) f r)) =
      1 + nu D.graph.n * (D.rowCoordinate (D.stateMainRow v selected b) -
        D.stateMainLength selected b - D.localLength (.inl l) - D.deadline z) := by
  rw [D.localTemplate_size_sum _ _ _ _ _ (D.stateMainPattern b)
    (D.stateMainTemplate_pattern selected b z l u f hu hf)]
  rw [D.localTemplate_coordinate_sum, D.stateMainGlobal_coordinate selected b u hu]
  simp only [anchorCoordinate]
  ring

theorem stateMainTemplate_feasible_iff {v : D.Vertex} (selected : Bool)
    (b z : D.MBase v) (l : D.DMAt v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = D.stateMainGlobalSpecies selected b)
    (hf : f.1 = D.stateFlagSpecies (.inl b)) :
    ((∑ r, D.itemSize (D.localTemplateItems (D.stateMainRow v selected b)
      (.inl z) u (.inl l) f r)) ≤ 1) ↔
      D.rowCoordinate (D.stateMainRow v selected b) - D.stateMainLength selected b -
        D.localLength (.inl l) ≤ D.deadline z := by
  rw [D.stateMainTemplate_size_eq selected b z l u f hu hf]
  have hnu := nu_pos D.graph.n
  constructor
  · intro h
    have hmul : nu D.graph.n *
        (D.rowCoordinate (D.stateMainRow v selected b) - D.stateMainLength selected b -
          D.localLength (.inl l) - D.deadline z) ≤ nu D.graph.n * 0 := by linarith
    exact sub_nonpos.mp (le_of_mul_le_mul_left hmul hnu)
  · intro h
    have hmul := mul_nonpos_of_nonneg_of_nonpos hnu.le (sub_nonpos.mpr h)
    linarith

theorem edgeTemplate_size_eq {v : D.Vertex} (short permit : Bool)
    (j : D.JobCopy v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = .edge (D.jobPosition j).1 permit) (hf : f.1 = .edge) :
    (∑ r, D.itemSize (D.localTemplateItems (.inr (short, j))
      (.inr j) u (.inr j) f r)) =
      1 + nu D.graph.n *
        ((if permit then 0 else Geometry.delta D.graph.edges.length D.R D.geometryBound D.L) -
          (if short then Geometry.delta D.graph.edges.length D.R D.geometryBound D.L else 0)) := by
  rcases u with ⟨us, ui⟩
  rcases f with ⟨fs, fi⟩
  change us = .edge (D.jobPosition j).1 permit at hu
  change fs = .edge at hf
  subst us
  subst fs
  rw [D.localTemplate_size_sum _ _ _ _ _ .edgeJob (by intro r; cases r <;> rfl)]
  rw [D.localTemplate_coordinate_sum]
  simp only [rowCoordinate, rowBaseline, rowShort, anchorCoordinate,
    globalCoordinate, localLength]
  cases short <;> cases permit <;> simp <;> ring_nf <;> simp

theorem edgeTemplate_feasible_iff {v : D.Vertex} (short permit : Bool)
    (j : D.JobCopy v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = .edge (D.jobPosition j).1 permit) (hf : f.1 = .edge) :
    ((∑ r, D.itemSize (D.localTemplateItems (.inr (short, j))
      (.inr j) u (.inr j) f r)) ≤ 1) ↔ short = true ∨ permit = true := by
  rw [D.edgeTemplate_size_eq short permit j u f hu hf]
  have hnu := nu_pos D.graph.n
  have hdelta := Geometry.delta_pos D.graph.edges.length D.R D.geometryBound D.L
  have hproduct := mul_pos hnu hdelta
  cases short <;> cases permit <;> simp <;> nlinarith

theorem edgeTemplate_short_feasible {v : D.Vertex} (permit : Bool)
    (j : D.JobCopy v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = .edge (D.jobPosition j).1 permit) (hf : f.1 = .edge) :
    (∑ r, D.itemSize (D.localTemplateItems (.inr (true, j))
      (.inr j) u (.inr j) f r)) ≤ 1 :=
  (D.edgeTemplate_feasible_iff true permit j u f hu hf).mpr (Or.inl rfl)

theorem edgeTemplate_long_feasible_iff {v : D.Vertex} (permit : Bool)
    (j : D.JobCopy v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = .edge (D.jobPosition j).1 permit) (hf : f.1 = .edge) :
    ((∑ r, D.itemSize (D.localTemplateItems (.inr (false, j))
      (.inr j) u (.inr j) f r)) ≤ 1) ↔ permit = true := by
  simpa using D.edgeTemplate_feasible_iff false permit j u f hu hf

theorem stateEdgeTemplate_size_eq_one {v : D.Vertex} (selected : Bool)
    (j : D.JobCopy v) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = .edge (D.jobPosition j).1 (!selected)) (hf : f.1 = .edge) :
    (∑ r, D.itemSize (D.localTemplateItems (.inr (selected, j))
      (.inr j) u (.inr j) f r)) = 1 := by
  rw [D.edgeTemplate_size_eq selected (!selected) j u f hu hf]
  cases selected <;> simp

end InventoryData

end BinPackingGap

noncomputable section

namespace BinPackingGap.InventoryData

open scoped BigOperators

variable (D : InventoryData)

abbrev Template := Σ v : D.Vertex, Bool × D.LocalBin v

def templateGlobalSpecies (t : D.Template) : GlobalSpecies D.graph :=
  D.stateGlobalSpecies t.2.1 t.2.2

def templateFlagSpecies (t : D.Template) : FlagSpecies :=
  D.stateFlagSpecies t.2.2

def templateRowCopy (t : D.Template) : Σ v : D.Vertex, D.RowAt v :=
  ⟨t.1, D.stateRowEquiv t.1 t.2.1 t.2.2⟩

def templateAnchorCopy (S : ∀ v s, D.LocalState v s) (t : D.Template) :
    Σ v : D.Vertex, D.AnchorAt v :=
  ⟨t.1, (S t.1 t.2.1).anchorAtEquiv t.2.2⟩

def templateLocalCopy (S : ∀ v s, D.LocalState v s) (t : D.Template) :
    Σ v : D.Vertex, D.LocalAt v :=
  ⟨t.1, (S t.1 t.2.1).localAtEquiv t.2.2⟩

def templateBase (S : ∀ v s, D.LocalState v s) (t : D.Template) :
    Finset D.packingInstance.Item :=
  {D.itemEquiv ⟨.x, D.templateRowCopy t⟩,
   D.itemEquiv ⟨.anchor, D.templateAnchorCopy S t⟩,
   D.itemEquiv ⟨.«local», D.templateLocalCopy S t⟩}

theorem templateBase_subset_labeledItems (S : ∀ v s, D.LocalState v s)
    (t : D.Template) : D.templateBase S t ⊆ D.labeledItems := by
  intro i hi
  simp only [templateBase, Finset.mem_insert, Finset.mem_singleton] at hi
  rcases hi with rfl | rfl | rfl <;> simp

private theorem templateTagged_ne {r s : Role} (hrs : r ≠ s)
    (a : D.RoleCopies r) (b : D.RoleCopies s) :
    D.itemEquiv ⟨r, a⟩ ≠ D.itemEquiv ⟨s, b⟩ := by
  intro h
  exact hrs (congrArg (fun i : D.Item => i.1) (D.itemEquiv.injective h))

private theorem templateTagged_eq_iff (r : Role) (a b : D.RoleCopies r) :
    D.itemEquiv ⟨r, a⟩ = D.itemEquiv ⟨r, b⟩ ↔ a = b := by
  constructor
  · intro h
    exact sigma_mk_injective (β := D.RoleCopies) (i := r) (D.itemEquiv.injective h)
  · rintro rfl
    rfl

theorem card_templateBase (S : ∀ v s, D.LocalState v s) (t : D.Template) :
    (D.templateBase S t).card = 3 := by
  unfold templateBase
  apply Finset.card_triple_eq_three_iff.mpr
  exact ⟨D.templateTagged_ne (by decide : Role.x ≠ .anchor) _ _,
    D.templateTagged_ne (by decide : Role.x ≠ .«local») _ _,
    D.templateTagged_ne (by decide : Role.anchor ≠ .«local») _ _⟩

def templateCopyEquiv {C : D.Vertex → Type*}
    (e : ∀ v (_s : Bool), D.LocalBin v ≃ C v) : D.Template ≃ Bool × (Σ v, C v) where
  toFun t := (t.2.1, ⟨t.1, e t.1 t.2.1 t.2.2⟩)
  invFun t := ⟨t.2.1, t.1, (e t.2.1 t.1).symm t.2.2⟩
  left_inv := by
    rintro ⟨v, s, b⟩
    simp only [Equiv.symm_apply_apply]
  right_inv := by
    rintro ⟨s, v, c⟩
    simp only [Equiv.apply_symm_apply]

@[simp] theorem templateCopyEquiv_apply {C : D.Vertex → Type*}
    (e : ∀ v (_s : Bool), D.LocalBin v ≃ C v) (t : D.Template) :
    D.templateCopyEquiv e t = (t.2.1, ⟨t.1, e t.1 t.2.1 t.2.2⟩) := rfl

private def templateFiberBoolEquiv {T C : Type*} (e : T ≃ Bool × C) (c : C) :
    {t : T // (e t).2 = c} ≃ Bool where
  toFun x := (e x.1).1
  invFun b := ⟨e.symm (b, c), by simp only [Equiv.apply_symm_apply]⟩
  left_inv := by
    intro x
    apply Subtype.ext
    apply e.injective
    change e (e.symm ((e x.1).1, c)) = e x.1
    rw [e.apply_symm_apply]
    exact Prod.ext rfl x.2.symm
  right_inv := by
    intro b
    simp only [Equiv.apply_symm_apply]

theorem card_templateCopy_fiber {C : D.Vertex → Type*}
    [DecidableEq (Σ v, C v)]
    (e : ∀ v (_s : Bool), D.LocalBin v ≃ C v) (c : Σ v, C v) :
    ((Finset.univ : Finset D.Template).filter
      (fun t => (D.templateCopyEquiv e t).2 = c)).card = 2 := by
  classical
  rw [← Fintype.card_subtype (fun t : D.Template => (D.templateCopyEquiv e t).2 = c)]
  exact (Fintype.card_congr (templateFiberBoolEquiv (D.templateCopyEquiv e) c)).trans
    Fintype.card_bool

private theorem card_templatePredicate {C : Type*}
    (e : D.Template ≃ Bool × C) (c : C) (p : D.Template → Prop) [DecidablePred p]
    (hp : ∀ t, p t ↔ (e t).2 = c) :
    ((Finset.univ : Finset D.Template).filter p).card = 2 := by
  rw [← Fintype.card_subtype p]
  exact (Fintype.card_congr
    ((Equiv.subtypeEquivRight hp).trans (templateFiberBoolEquiv e c))).trans
      Fintype.card_bool

@[simp] theorem itemEquiv_x_mem_templateBase (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (c : D.RoleCopies .x) :
    D.itemEquiv ⟨.x, c⟩ ∈ D.templateBase S t ↔ D.templateRowCopy t = c := by
  have hxa := D.templateTagged_ne (by decide : Role.x ≠ .anchor) c
    (D.templateAnchorCopy S t)
  have hxl := D.templateTagged_ne (by decide : Role.x ≠ .«local») c
    (D.templateLocalCopy S t)
  simp only [templateBase, Finset.mem_insert, Finset.mem_singleton, hxa, hxl, or_false]
  exact (D.templateTagged_eq_iff .x c (D.templateRowCopy t)).trans eq_comm

@[simp] theorem itemEquiv_anchor_mem_templateBase (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (c : D.RoleCopies .anchor) :
    D.itemEquiv ⟨.anchor, c⟩ ∈ D.templateBase S t ↔ D.templateAnchorCopy S t = c := by
  have hax := D.templateTagged_ne (by decide : Role.anchor ≠ .x) c
    (D.templateRowCopy t)
  have hal := D.templateTagged_ne (by decide : Role.anchor ≠ .«local») c
    (D.templateLocalCopy S t)
  simp only [templateBase, Finset.mem_insert, Finset.mem_singleton, hax, hal,
    false_or, or_false]
  exact (D.templateTagged_eq_iff .anchor c (D.templateAnchorCopy S t)).trans eq_comm

@[simp] theorem itemEquiv_local_mem_templateBase (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (c : D.RoleCopies .«local») :
    D.itemEquiv ⟨.«local», c⟩ ∈ D.templateBase S t ↔ D.templateLocalCopy S t = c := by
  have hlx := D.templateTagged_ne (by decide : Role.«local» ≠ .x) c
    (D.templateRowCopy t)
  have hla := D.templateTagged_ne (by decide : Role.«local» ≠ .anchor) c
    (D.templateAnchorCopy S t)
  simp only [templateBase, Finset.mem_insert, Finset.mem_singleton, hlx, hla, false_or]
  exact (D.templateTagged_eq_iff .«local» c (D.templateLocalCopy S t)).trans eq_comm

@[simp] theorem itemEquiv_global_not_mem_templateBase (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (c : D.RoleCopies .«global») :
    D.itemEquiv ⟨.«global», c⟩ ∉ D.templateBase S t := by
  simp only [templateBase, Finset.mem_insert, Finset.mem_singleton, not_or]
  exact ⟨D.templateTagged_ne (by decide : Role.«global» ≠ .x) _ _,
    D.templateTagged_ne (by decide : Role.«global» ≠ .anchor) _ _,
    D.templateTagged_ne (by decide : Role.«global» ≠ .«local») _ _⟩

@[simp] theorem itemEquiv_flag_not_mem_templateBase (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (c : D.RoleCopies .flag) :
    D.itemEquiv ⟨.flag, c⟩ ∉ D.templateBase S t := by
  simp only [templateBase, Finset.mem_insert, Finset.mem_singleton, not_or]
  exact ⟨D.templateTagged_ne (by decide : Role.flag ≠ .x) _ _,
    D.templateTagged_ne (by decide : Role.flag ≠ .anchor) _ _,
    D.templateTagged_ne (by decide : Role.flag ≠ .«local») _ _⟩

theorem templateBase_appearance_count (S : ∀ v s, D.LocalState v s)
    (i : D.packingInstance.Item) :
    ((Finset.univ : Finset D.Template).filter (fun t => i ∈ D.templateBase S t)).card =
      if i ∈ D.labeledItems then 2 else 0 := by
  classical
  obtain ⟨⟨r, c⟩, rfl⟩ := D.itemEquiv.surjective i
  cases r with
  | x =>
    rw [ite_eq_left (by simp)]
    apply D.card_templatePredicate (D.templateCopyEquiv (fun v s => D.stateRowEquiv v s)) c
      (fun t => D.itemEquiv ⟨.x, c⟩ ∈ D.templateBase S t)
    intro t
    simpa only [templateCopyEquiv_apply, templateRowCopy] using
      D.itemEquiv_x_mem_templateBase S t c
  | anchor =>
    rw [ite_eq_left (by simp)]
    apply D.card_templatePredicate
      (D.templateCopyEquiv (fun v s => (S v s).anchorAtEquiv)) c
      (fun t => D.itemEquiv ⟨.anchor, c⟩ ∈ D.templateBase S t)
    intro t
    simpa only [templateCopyEquiv_apply, templateAnchorCopy] using
      D.itemEquiv_anchor_mem_templateBase S t c
  | «global» => simp
  | «local» =>
    rw [ite_eq_left (by simp)]
    apply D.card_templatePredicate
      (D.templateCopyEquiv (fun v s => (S v s).localAtEquiv)) c
      (fun t => D.itemEquiv ⟨.«local», c⟩ ∈ D.templateBase S t)
    intro t
    simpa only [templateCopyEquiv_apply, templateLocalCopy] using
      D.itemEquiv_local_mem_templateBase S t c
  | flag => simp

@[simp] theorem packingInstance_size_itemEquiv (i : D.Item) :
    D.packingInstance.size (D.itemEquiv i) = D.itemSize i := by
  change D.itemSize (D.itemEquiv.symm (D.itemEquiv i)) = D.itemSize i
  rw [Equiv.symm_apply_apply]

theorem templateBase_complete_eq_image (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (u : D.GlobalCopy) (f : D.FlagCopy) :
    D.templateBase S t ∪ {D.itemEquiv ⟨.«global», u⟩, D.itemEquiv ⟨.flag, f⟩} =
      Finset.univ.image (fun r => D.itemEquiv
        (D.localTemplateItems (D.stateRowEquiv t.1 t.2.1 t.2.2)
          ((S t.1 t.2.1).anchorAtEquiv t.2.2) u
          ((S t.1 t.2.1).localAtEquiv t.2.2) f r)) := by
  apply Finset.ext
  intro i
  constructor
  · intro hi
    simp only [Finset.mem_union, templateBase, Finset.mem_insert,
      Finset.mem_singleton] at hi
    rcases hi with (rfl | rfl | rfl) | (rfl | rfl)
    · exact Finset.mem_image.mpr ⟨.x, Finset.mem_univ _, rfl⟩
    · exact Finset.mem_image.mpr ⟨.anchor, Finset.mem_univ _, rfl⟩
    · exact Finset.mem_image.mpr ⟨.«local», Finset.mem_univ _, rfl⟩
    · exact Finset.mem_image.mpr ⟨.«global», Finset.mem_univ _, rfl⟩
    · exact Finset.mem_image.mpr ⟨.flag, Finset.mem_univ _, rfl⟩
  · intro hi
    obtain ⟨r, _, rfl⟩ := Finset.mem_image.mp hi
    cases r with
    | x =>
      apply Finset.mem_union_left
      exact Finset.mem_insert_self _ _
    | anchor =>
      apply Finset.mem_union_left
      apply Finset.mem_insert_of_mem
      exact Finset.mem_insert_self _ _
    | «global» =>
      apply Finset.mem_union_right
      exact Finset.mem_insert_self _ _
    | «local» =>
      apply Finset.mem_union_left
      apply Finset.mem_insert_of_mem
      apply Finset.mem_insert_of_mem
      exact Finset.mem_singleton_self _
    | flag =>
      apply Finset.mem_union_right
      apply Finset.mem_insert_of_mem
      exact Finset.mem_singleton_self _

theorem templateBase_size_sum (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (u : D.GlobalCopy) (f : D.FlagCopy) :
    (∑ i ∈ D.templateBase S t ∪
      {D.itemEquiv ⟨.«global», u⟩, D.itemEquiv ⟨.flag, f⟩}, D.packingInstance.size i) =
    ∑ r, D.itemSize (D.localTemplateItems (D.stateRowEquiv t.1 t.2.1 t.2.2)
      ((S t.1 t.2.1).anchorAtEquiv t.2.2) u
      ((S t.1 t.2.1).localAtEquiv t.2.2) f r) := by
  rw [D.templateBase_complete_eq_image S t u f, Finset.sum_image]
  · simp only [packingInstance_size_itemEquiv]
  · intro r _ r' _ h
    exact D.localTemplateItems_injective _ _ _ _ _ (D.itemEquiv.injective h)

theorem templateBase_capacity (S : ∀ v s, D.LocalState v s)
    (t : D.Template) (u : D.GlobalCopy) (f : D.FlagCopy)
    (hu : u.1 = D.templateGlobalSpecies t) (hf : f.1 = D.templateFlagSpecies t) :
    (∑ i ∈ D.templateBase S t ∪
      {D.itemEquiv ⟨.«global», u⟩, D.itemEquiv ⟨.flag, f⟩}, D.packingInstance.size i) ≤ 1 := by
  rw [D.templateBase_size_sum S t u f]
  rcases t with ⟨v, selected, b⟩
  rcases b with b | j
  · exact (D.stateMainTemplate_feasible_iff selected b ((S v selected).anchorEquiv b)
      ((S v selected).localEquiv b) u f hu hf).mpr
        ((S v selected).completion_le_deadline b)
  · exact (D.stateEdgeTemplate_size_eq_one selected j u f hu hf).le

end BinPackingGap.InventoryData

end

end OAI
end LocalizedSource42
/- END LOCALIZED SOURCE 42/44: OAI/Computability/BinPacking/Packing/LocalTemplateBases.lean -/

/- BEGIN LOCALIZED SOURCE 43/44: OAI/Computability/BinPacking/Configurations/ReductionFractional.lean
   SHA256: 0e11f1a94a4a10ca7a3572ae61755e58d0334d25b077207c301b41000684199e -/
section LocalizedSource43
-- localized import: OAI.Computability.BinPacking.Inventory.IntegralSpeciesCounts
-- localized import: OAI.Computability.BinPacking.Inventory.PhysicalPoolLift
-- localized import: OAI.Computability.BinPacking.Packing.ConstructLocalState
-- localized import: OAI.Computability.BinPacking.Packing.ExtractedCover
-- localized import: OAI.Computability.BinPacking.Packing.LocalTemplateBases

namespace OAI

noncomputable section

namespace BinPackingGap.InventoryData

open scoped BigOperators

variable (D : InventoryData)

theorem card_template : Fintype.card D.Template = 2 * D.B := by
  simp only [Template, Fintype.card_sigma, Fintype.card_prod, Fintype.card_bool,
    D.card_localBin]
  rw [← Finset.mul_sum]
  rfl

def statePoolTemplates (hn : D.graph.n = 2 * D.k)
    (S : ∀ v s, D.LocalState v s) :
    PoolTemplates D.packingInstance D.Template (GlobalSpecies D.graph) FlagSpecies where
  base := D.templateBase S
  globalPool := D.physicalGlobalPool
  flagPool := D.physicalFlagPool
  globalSpecies := D.templateGlobalSpecies
  flagSpecies := D.templateFlagSpecies
  global_nonempty := by
    intro t
    apply (D.physicalGlobalPool_nonempty_iff _).mpr
    have hc := D.doubled_stateGlobalSpecies_count hn (D.templateGlobalSpecies t)
    have hp : 0 < (Finset.univ.filter (fun q : D.Template =>
        D.templateGlobalSpecies q = D.templateGlobalSpecies t)).card := by
      exact Finset.card_pos.mpr ⟨t, by simp⟩
    change (Finset.univ.filter (fun q : D.Template =>
      D.templateGlobalSpecies q = D.templateGlobalSpecies t)).card = _ at hc
    omega
  flag_nonempty := by
    intro t
    apply (D.physicalFlagPool_nonempty_iff _).mpr
    have hc := D.doubled_stateFlagSpecies_count (D.templateFlagSpecies t)
    have hp : 0 < (Finset.univ.filter (fun q : D.Template =>
        D.templateFlagSpecies q = D.templateFlagSpecies t)).card := by
      exact Finset.card_pos.mpr ⟨t, by simp⟩
    change (Finset.univ.filter (fun q : D.Template =>
      D.templateFlagSpecies q = D.templateFlagSpecies t)).card = _ at hc
    omega
  base_global := fun t =>
    (D.labeledItems_disjoint_physicalGlobalPool (D.templateGlobalSpecies t)).mono_left
      (D.templateBase_subset_labeledItems S t)
  base_flag := fun t =>
    (D.labeledItems_disjoint_physicalFlagPool (D.templateFlagSpecies t)).mono_left
      (D.templateBase_subset_labeledItems S t)
  global_flag := fun t => D.physicalGlobalPool_disjoint_physicalFlagPool
    (D.templateGlobalSpecies t) (D.templateFlagSpecies t)
  capacity := by
    intro t u f
    obtain ⟨j, hj⟩ := (D.mem_physicalGlobalPool (D.templateGlobalSpecies t) u.val).mp
      u.property
    obtain ⟨l, hl⟩ := (D.mem_physicalFlagPool (D.templateFlagSpecies t) f.val).mp
      f.property
    rw [← hj, ← hl]
    exact D.templateBase_capacity S t ⟨D.templateGlobalSpecies t, j⟩
      ⟨D.templateFlagSpecies t, l⟩ rfl rfl

theorem statePoolTemplates_feasible (hn : D.graph.n = 2 * D.k)
    (S : ∀ v s, D.LocalState v s) :
    IndividualFeasible D.packingInstance (D.statePoolTemplates hn S).weights := by
  apply (D.statePoolTemplates hn S).weights_feasible D.labeledItems
  · exact D.templateBase_appearance_count S
  · intro s
    change (Finset.univ.filter (fun t : D.Template =>
      D.templateGlobalSpecies t = s)).card = 2 * (D.physicalGlobalPool s).card
    rw [D.card_physicalGlobalPool]
    exact D.doubled_stateGlobalSpecies_count hn s
  · intro f
    change (Finset.univ.filter (fun t : D.Template =>
      D.templateFlagSpecies t = f)).card = 2 * (D.physicalFlagPool f).card
    rw [D.card_physicalFlagPool]
    exact D.doubled_stateFlagSpecies_count f
  · exact D.physicalInventory_indicator_partition

theorem statePoolTemplates_objective (hn : D.graph.n = 2 * D.k)
    (S : ∀ v s, D.LocalState v s) :
    FractionalCover.objective (D.statePoolTemplates hn S).weights = (D.B : ℝ) := by
  rw [(D.statePoolTemplates hn S).objective_weights, D.card_template]
  push_cast
  ring

theorem ofCompetingTrees_physical_witness (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (hd : 0 < d) (R k : ℕ) (hn : G.n = 2 * k) :
    ∃ w : IndividualConfiguration (ofCompetingTrees G T R k).packingInstance → ℝ,
      IndividualFeasible (ofCompetingTrees G T R k).packingInstance w ∧
      FractionalCover.objective w = ((ofCompetingTrees G T R k).B : ℝ) := by
  let D := ofCompetingTrees G T R k
  let S : ∀ v s, D.LocalState v s := constructedLocalState G T hd R k
  exact ⟨(D.statePoolTemplates hn S).weights,
    D.statePoolTemplates_feasible hn S, D.statePoolTemplates_objective hn S⟩

theorem ofCompetingTrees_bothLP_eq (G : GraphInput) {d : ℕ}
    (T : CompetingTrees d) (hd : 0 < d) (R k : ℕ) (hn : G.n = 2 * k) :
    individualLP (ofCompetingTrees G T R k).packingInstance =
        ((ofCompetingTrees G T R k).B : ℝ) ∧
      typeLP (ofCompetingTrees G T R k).packingInstance =
        ((ofCompetingTrees G T R k).B : ℝ) := by
  obtain ⟨w, hw, hobj⟩ := ofCompetingTrees_physical_witness G T hd R k hn
  exact bothLP_eq_of_physical_witness _ _
    ((ofCompetingTrees G T R k).packingInstance_n (by change k ≤ G.n; omega))
    (fun i => ((ofCompetingTrees G T R k).packingInstance_size_mem_interval i).1)
    w hw hobj

end BinPackingGap.InventoryData

end

namespace BinPackingGap

theorem reduction_bothLP_eq (c : ℕ) (rho : ℝ) (G : GraphInput) (k : ℕ)
    (hn : G.n = 2 * k) :
    individualLP (reductionInstance c rho G k) =
        (reductionBinBound c rho G k : ℝ) ∧
      typeLP (reductionInstance c rho G k) =
        (reductionBinBound c rho G k : ℝ) :=
  InventoryData.ofCompetingTrees_bothLP_eq G (reductionTrees c rho)
    (depthDemand_pos c rho) _ k hn

end BinPackingGap

end OAI
end LocalizedSource43
/- END LOCALIZED SOURCE 43/44: OAI/Computability/BinPacking/Configurations/ReductionFractional.lean -/

/- BEGIN LOCALIZED SOURCE 44/44: OAI/Computability/BinPacking/Results/StructuralGap.lean
   SHA256: 7a45164aa190c06e6549c29f1f00fdb2715a7b4c038a43e02ec86dcf7742e15b -/
section LocalizedSource44
-- localized import: Mathlib.Algebra.Order.Floor.Semiring
-- localized import: OAI.Computability.BinPacking.Configurations.K4Soundness
-- localized import: OAI.Computability.BinPacking.Configurations.ReductionFractional

namespace OAI

namespace BinPackingGap

theorem completeFourGraph_reduction_bothLP_eq (c : ℕ) :
    individualLP (reductionInstance c (1 / 8) completeFourGraph 2) =
        (reductionBinBound c (1 / 8) completeFourGraph 2 : ℝ) ∧
      typeLP (reductionInstance c (1 / 8) completeFourGraph 2) =
        (reductionBinBound c (1 / 8) completeFourGraph 2 : ℝ) :=
  reduction_bothLP_eq c (1 / 8) completeFourGraph 2 (by decide)

theorem structural_additive_gap (c : ℕ) :
    ∃ I : Instance, ∃ B : ℕ,
      I.n = 5 * B ∧
      (∀ i, (1 / 6 : ℚ) < I.size i ∧ I.size i < 1) ∧
      B + c < opt I ∧ individualLP I = (B : ℝ) ∧ typeLP I = (B : ℝ) := by
  refine ⟨reductionInstance c (1 / 8) completeFourGraph 2,
    reductionBinBound c (1 / 8) completeFourGraph 2,
    reductionInstance_count c (1 / 8) completeFourGraph 2 (by decide),
    reductionInstance_size_bounds c (1 / 8) completeFourGraph 2,
    completeFourGraph_reduction_opt_gap c, ?_⟩
  exact completeFourGraph_reduction_bothLP_eq c

theorem exists_mirup_counterexample :
    ∃ I : Instance,
      Nat.ceil (individualLP I) + 1 < opt I ∧
        Nat.ceil (typeLP I) + 1 < opt I := by
  obtain ⟨I, B, _, _, hgap, hindividual, htype⟩ := structural_additive_gap 1
  refine ⟨I, ?_, ?_⟩
  · simpa only [hindividual, Nat.ceil_natCast] using hgap
  · simpa only [htype, Nat.ceil_natCast] using hgap

theorem individual_mirup_false :
    ¬ ∀ I : Instance, opt I ≤ Nat.ceil (individualLP I) + 1 := by
  intro h
  obtain ⟨I, hi, _⟩ := exists_mirup_counterexample
  exact (not_le_of_gt hi) (h I)

theorem type_mirup_false :
    ¬ ∀ I : Instance, opt I ≤ Nat.ceil (typeLP I) + 1 := by
  intro h
  obtain ⟨I, _, hi⟩ := exists_mirup_counterexample
  exact (not_le_of_gt hi) (h I)

end BinPackingGap

end OAI
end LocalizedSource44
/- END LOCALIZED SOURCE 44/44: OAI/Computability/BinPacking/Results/StructuralGap.lean -/

/- Kernel dependency audit: standard logical axioms only. -/
#check OAI.BinPackingGap.structural_additive_gap
#print axioms OAI.BinPackingGap.structural_additive_gap
#print axioms OAI.BinPackingGap.competingTrees
#print axioms OAI.BinPackingGap.ForkGadget.avoids
#print axioms OAI.BinPackingGap.AuxiliaryTree.step
#print axioms OAI.BinPackingGap.CompetingTrees.ofAuxiliary
#print axioms OAI.BinPackingGap.encodedSize_mem_interval
#print axioms OAI.BinPackingGap.InventoryData.outsideTableItems_card_lt_lossAllowance
#print axioms OAI.BinPackingGap.InventoryData.anchor_subset_loss_le
#print axioms OAI.BinPackingGap.completeFourGraph_reduction_opt_gap
#print axioms OAI.BinPackingGap.packing_extracts_cover
#print axioms OAI.BinPackingGap.extractedCover_isCover
#print axioms OAI.BinPackingGap.extractedCover_card_le
#print axioms OAI.BinPackingGap.thresholdCover_isCover
#print axioms OAI.BinPackingGap.completeFourGraph_no_small_cover
#print axioms OAI.BinPackingGap.CoverageCounts.displaced_baseline_bound
#print axioms OAI.BinPackingGap.CoverageCounts.displaced_short_correction
#print axioms OAI.BinPackingGap.CoverageCounts.short_le_displaced_add_long
#print axioms OAI.BinPackingGap.CoverageCounts.long_match_lower_bound
#print axioms OAI.BinPackingGap.InventoryData.earlierKeyItems_card
#print axioms OAI.BinPackingGap.InventoryData.earlierWItems_card
#print axioms OAI.BinPackingGap.InventoryData.remainingEarlierW_card_eq_missingKeys
#print axioms OAI.BinPackingGap.InventoryData.missingEarlierKeys_subset_bad
#print axioms OAI.BinPackingGap.InventoryData.remainingEarlierW_card_le
#print axioms OAI.BinPackingGap.InventoryData.long_matches_at_nonexcluded
#print axioms OAI.BinPackingGap.InventoryData.edge_long_matches_capacity
#print axioms OAI.BinPackingGap.InventoryCoverage.jobRowPrefix_card
#print axioms OAI.BinPackingGap.InventoryCoverage.originalBaselinePrefix_card
#print axioms OAI.BinPackingGap.InventoryCoverage.currentKeyItems_card
#print axioms OAI.BinPackingGap.InventoryCoverage.currentShortItems_card
#print axioms OAI.BinPackingGap.InventoryCoverage.actual_displaced_baseline_prefix_le
#print axioms OAI.BinPackingGap.InventoryCoverage.actual_displaced_job_prefix_le
#print axioms OAI.BinPackingGap.InventoryCoverage.actual_deadline_deficit_bound
#print axioms OAI.BinPackingGap.InventoryCoverage.actual_current_long_matches_from_correction
#print axioms OAI.BinPackingGap.InventoryData.test_coverage
#print axioms OAI.BinPackingGap.PackingCounts.xplus_budget
#print axioms OAI.BinPackingGap.PackingCounts.total_budget
#print axioms OAI.BinPackingGap.InventoryData.ofCompetingTrees_physical_witness
#print axioms OAI.BinPackingGap.InventoryData.statePoolTemplates_feasible
#print axioms OAI.BinPackingGap.InventoryData.ofCompetingTrees_bothLP_eq
#print axioms OAI.BinPackingGap.reduction_bothLP_eq
#print axioms OAI.BinPackingGap.bothLP_eq_of_physical_witness
#print axioms OAI.BinPackingGap.FractionalCover.exists_minimizer
#print axioms OAI.BinPackingGap.TypeConfiguration.card_le_five
#print axioms OAI.BinPackingGap.n_le_five_mul_type_objective
#print axioms OAI.BinPackingGap.projectWeights_feasible
#print axioms OAI.BinPackingGap.PoolTemplates.weights_feasible
#print axioms OAI.BinPackingGap.opt_attained
#print axioms OAI.BinPackingGap.not_hasPacking_iff_lt_opt
