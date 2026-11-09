import Mathlib

noncomputable section

open Set Submodule

namespace LSScalarDescent

variable {K L : Type*} [Field K] [Field L] [Algebra K L] {n : ℕ}

def entryMap (x : Fin n → K) : Fin n → L := algebraMap K L ∘ x

local notation "emb" => (entryMap (L := L))

theorem span_forward (S : Set (Fin n → K)) {x : Fin n → K}
    (hx : x ∈ Submodule.span K S) :
    emb x ∈ Submodule.span L (emb '' S) := by
  induction hx using Submodule.span_induction with
  | mem y hy => exact Submodule.subset_span ⟨y, hy, rfl⟩
  | zero => simp [entryMap]
  | add y z hy hz ihy ihz =>
    have he : emb (y + z) = emb y + emb z := by
      ext j
      simp [entryMap]
    rw [he]
    exact (Submodule.span L (emb '' S)).add_mem ihy ihz
  | smul a y hy ih =>
    have he : emb (a • y) = algebraMap K L a • emb y := by
      ext j
      simp [entryMap, Algebra.smul_def]
    rw [he]
    exact (Submodule.span L (emb '' S)).smul_mem (algebraMap K L a) ih

theorem independent_span_descent {ι : Type*} (v : ι → Fin n → K)
    (hv : LinearIndependent K v) (x : Fin n → K) :
    x ∈ Submodule.span K (Set.range v) ↔
      emb x ∈ Submodule.span L (Set.range (fun i => emb (v i))) := by
  have hvL : LinearIndependent L (fun i => emb (v i)) :=
    linearIndependent_algebraMap_comp_iff.mpr hv
  have hop := (linearIndependent_algebraMap_comp_iff
    (R := K) (S := L) (v := fun o : Option ι => Option.casesOn' o x v))
  have hfun :
      (fun o : Option ι => algebraMap K L ∘ Option.casesOn' o x v) =
        (fun o => Option.casesOn' o (emb x) (fun i => emb (v i))) := by
    funext o
    cases o <;> rfl
  rw [hfun, linearIndependent_option', linearIndependent_option'] at hop
  simp only [hv, hvL, true_and] at hop
  exact not_iff_not.mp hop.symm

theorem span_descent (S : Set (Fin n → K)) (x : Fin n → K) :
    x ∈ Submodule.span K S ↔ emb x ∈ Submodule.span L (emb '' S) := by
  let b := Module.Basis.ofVectorSpace K (Submodule.span K S)
  let v := (Submodule.span K S).subtype ∘ b
  have hv : LinearIndependent K v :=
    b.linearIndependent.map' _ (Submodule.ker_subtype _)
  have hvspan : Submodule.span K (Set.range v) = Submodule.span K S := by
    rw [show Set.range v = (Submodule.span K S).subtype '' Set.range b from
      Set.range_comp _ _, ← Submodule.map_span, b.span_eq,
      Submodule.map_top, Submodule.range_subtype]
  have hrange :
      (emb '' Set.range v : Set (Fin n → L)) =
        Set.range (fun i => emb (v i)) := (Set.range_comp _ _).symm
  have hmapped :
      Submodule.span L (emb '' S) =
        Submodule.span L (Set.range (fun i => emb (v i))) := by
    apply le_antisymm
    · apply Submodule.span_le.mpr
      rintro _ ⟨y, hy, rfl⟩
      rw [← hrange]
      apply span_forward
      rw [hvspan]
      exact Submodule.subset_span hy
    · apply Submodule.span_le.mpr
      rintro _ ⟨i, rfl⟩
      exact span_forward S (b i).property
  rw [hmapped, ← independent_span_descent v hv x, hvspan]

theorem earlier_span_descent {ι : Type*} [LinearOrder ι]
    (row : ι → Fin n → K) (i : ι) :
    row i ∈ Submodule.span K (row '' Set.Iio i) ↔
      emb (row i) ∈
        Submodule.span L ((fun j => emb (row j)) '' Set.Iio i) := by
  simpa only [Set.image_image, Function.comp_def] using
    span_descent (L := L) (row '' Set.Iio i) (row i)

end LSScalarDescent
