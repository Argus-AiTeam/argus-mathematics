import Mathlib

open Finset
open scoped Classical

namespace AlignmentFinitePatterns

universe u v w

def AlignedFamily {ι : Type u} {M : Type v} {β : Type w}
    (A : ι → Finset M) (T : Finset ι) (C : ι → Finset β)
    (B : Finset β) : Prop :=
  ∃ a : M → β, (∀ x, a x ∈ B) ∧
    ∀ i ∈ T, ∀ x ∈ A i, a x ∈ C i

theorem aligned_image_iff {ι : Type u} {M : Type v} {K : Type*} [DecidableEq K]
    {β : Type w}
    (A : ι → Finset M) (U : Finset M) (φ : M → K)
    (hU : ∀ i, A i ⊆ U) (hinj : Set.InjOn φ U)
    (T : Finset ι) (C : ι → Finset β) {B : Finset β} (hB : B.Nonempty) :
    AlignedFamily (fun i => (A i).image φ) T C B ↔ AlignedFamily A T C B := by
  constructor
  · rintro ⟨a, haB, ha⟩
    refine ⟨a ∘ φ, fun x => haB (φ x), ?_⟩
    intro i hi x hx
    exact ha i hi (φ x) (Finset.mem_image_of_mem φ hx)
  · rintro ⟨a, haB, ha⟩
    obtain ⟨b, hb⟩ := hB
    let f : K → β := fun y =>
      if hy : ∃ x, x ∈ U ∧ φ x = y then a hy.choose else b
    refine ⟨f, ?_, ?_⟩
    · intro y
      dsimp [f]
      split_ifs with hy
      · exact haB hy.choose
      · exact hb
    · intro i hi y hy
      obtain ⟨x, hx, hxy⟩ := Finset.mem_image.mp hy
      have he : ∃ z, z ∈ U ∧ φ z = y := ⟨x, hU i hx, hxy⟩
      have hrepr : he.choose = x :=
        hinj he.choose_spec.1 (hU i hx) (he.choose_spec.2.trans hxy.symm)
      dsimp [f]
      rw [dif_pos he, hrepr]
      exact ha i hi x hx

theorem finite_relabeling {ι : Type u} [Fintype ι] {M : Type v}
    (A : ι → Finset M) (d : ℕ) (hd : ∀ i, (A i).card ≤ d) :
    ∃ φ : M → Fin (d * Fintype.card ι + 1),
      (∀ i, ((A i).image φ).card = (A i).card) ∧
      (∀ i j, Disjoint ((A i).image φ) ((A j).image φ) ↔ Disjoint (A i) (A j)) ∧
      (∀ (β : Type w) (T : Finset ι) (C : ι → Finset β)
        (B : Finset β), B.Nonempty →
        (AlignedFamily (fun i => (A i).image φ) T C B ↔ AlignedFamily A T C B)) ∧
      (∀ i j, ∀ x ∈ A i, ∀ y ∈ A j, φ x = φ y ↔ x = y) := by
  let U : Finset M := Finset.univ.biUnion A
  have hU : ∀ i, A i ⊆ U := by
    intro i x hx
    exact Finset.mem_biUnion.mpr ⟨i, Finset.mem_univ _, hx⟩
  have hcard : U.card ≤ d * Fintype.card ι := by
    calc
      U.card ≤ ∑ i, (A i).card := Finset.card_biUnion_le
      _ ≤ ∑ _i : ι, d := Finset.sum_le_sum fun i _ => hd i
      _ = d * Fintype.card ι := by simp [Nat.mul_comm]
  have hbound : Fintype.card ↥U ≤ d * Fintype.card ι + 1 := by
    simpa using hcard.trans (Nat.le_succ (d * Fintype.card ι))
  let e : ↥U → Fin (d * Fintype.card ι + 1) := fun x =>
    ⟨(Fintype.equivFin ↥U x).val, ((Fintype.equivFin ↥U x).isLt).trans_le hbound⟩
  have he : Function.Injective e := by
    intro x y hxy
    apply (Fintype.equivFin ↥U).injective
    apply Fin.ext
    have hval : (e x).val = (e y).val := congrArg Fin.val hxy
    exact hval
  let φ : M → Fin (d * Fintype.card ι + 1) := fun x =>
    if hx : x ∈ U then e ⟨x, hx⟩ else ⟨0, by omega⟩
  have hinj : Set.InjOn φ U := by
    intro x hx y hy hxy
    change x ∈ U at hx
    change y ∈ U at hy
    have heq : e ⟨x, hx⟩ = e ⟨y, hy⟩ := by
      simpa only [φ, dif_pos hx, dif_pos hy] using hxy
    exact congrArg Subtype.val (he heq)
  refine ⟨φ, ?_, ?_, ?_, ?_⟩
  · intro i
    exact Finset.card_image_of_injOn (hinj.mono (hU i))
  · intro i j
    constructor
    · intro h
      apply Finset.disjoint_left.mpr
      intro x hx hy
      exact Finset.disjoint_left.mp h
        (Finset.mem_image_of_mem φ hx) (Finset.mem_image_of_mem φ hy)
    · intro h
      apply Finset.disjoint_left.mpr
      intro z hz hz'
      obtain ⟨x, hx, hxz⟩ := Finset.mem_image.mp hz
      obtain ⟨y, hy, hyz⟩ := Finset.mem_image.mp hz'
      have hxy : x = y := hinj (hU i hx) (hU j hy) (hxz.trans hyz.symm)
      exact Finset.disjoint_left.mp h hx (hxy ▸ hy)
  · intro β T C B hB
    exact aligned_image_iff A U φ hU hinj T C hB
  · intro i j x hx y hy
    exact ⟨hinj (hU i hx) (hU j hy), fun h => congrArg φ h⟩

theorem representative_space_finite (ι : Type u) [Finite ι] (k : ℕ) :
    Finite (ι → Finset (Fin k)) := by infer_instance

end AlignmentFinitePatterns
