import Mathlib

open scoped BigOperators

namespace InterpolationAudit

section Hyperplane

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

theorem tangent_in_hyperplane (ell : V →ₗ[K] K) (T : Submodule K V)
    (hproper : ell.ker ⊔ T ≠ ⊤) : T ≤ ell.ker := by
  by_contra h
  change ¬ (∀ t, t ∈ T → t ∈ ell.ker) at h
  push Not at h
  obtain ⟨t, htT, htker⟩ := h
  have ht0 : ell t ≠ 0 := by
    simpa only [LinearMap.mem_ker] using htker
  apply hproper
  apply top_unique
  intro v _
  let c := ell v / ell t
  have hvker : v - c • t ∈ ell.ker := by
    change ell (v - c • t) = 0
    simp only [map_sub, map_smul, smul_eq_mul]
    dsimp [c]
    field_simp [ht0] <;> ring
  exact Submodule.mem_sup.mpr
    ⟨v - c • t, hvker, c • t, T.smul_mem c htT, sub_add_cancel v (c • t)⟩

end Hyperplane

section LogarithmicFrame

variable {K I : Type*} [Field K]

def logShear (y : K) (v : Option I → K) : Option I → K
  | none => y * v none
  | some i => v none + v (some i)

def logUnshear (y : K) (v : Option I → K) : Option I → K
  | none => v none / y
  | some i => v (some i) - v none / y

theorem logShear_add (y : K) (u v : Option I → K) :
    logShear y (u + v) = logShear y u + logShear y v := by
  funext j
  cases j <;> simp [logShear] <;> ring

theorem logShear_smul (y a : K) (v : Option I → K) :
    logShear y (a • v) = a • logShear y v := by
  funext j
  cases j <;> simp [logShear, smul_eq_mul] <;> ring

theorem logUnshear_logShear (y : K) (hy : y ≠ 0) (v : Option I → K) :
    logUnshear y (logShear y v) = v := by
  funext j
  cases j <;> simp [logShear, logUnshear, hy]

theorem logShear_logUnshear (y : K) (hy : y ≠ 0) (v : Option I → K) :
    logShear y (logUnshear y v) = v := by
  funext j
  cases j <;> simp [logShear, logUnshear, div_eq_mul_inv] <;>
    field_simp [hy] <;> ring

def logarithmicFrameEquiv (y : K) (hy : y ≠ 0) :
    (Option I → K) ≃ₗ[K] (Option I → K) where
  toFun := logShear y
  invFun := logUnshear y
  left_inv := logUnshear_logShear y hy
  right_inv := logShear_logUnshear y hy
  map_add' := logShear_add y
  map_smul' := logShear_smul y

def logNormal (y : K) (i : I) : (Option I → K) →ₗ[K] K where
  toFun v := v (some i) - v none / y
  map_add' u v := by
    simp only [Pi.add_apply, add_div]
    ring
  map_smul' a v := by
    simp only [Pi.smul_apply, smul_eq_mul, div_eq_mul_inv, RingHom.id_apply]
    ring

theorem tangent_logarithmic_relation (y : K) (i : I)
    (T : Submodule K (Option I → K))
    (hproper : (logNormal y i).ker ⊔ T ≠ ⊤) :
    ∀ v ∈ T, v (some i) = v none / y := by
  have hT := tangent_in_hyperplane (logNormal y i) T hproper
  intro v hv
  have hz := hT hv
  change v (some i) - v none / y = 0 at hz
  exact sub_eq_zero.mp hz

end LogarithmicFrame

section SeparatedBases

def wins (A B : Finset ℕ) : Prop :=
  ∃ i, 0 < i ∧ i ∈ A ∧ i ∉ B ∧
    ∀ j ∈ (A \ B) ∪ (B \ A), j ≤ i

theorem largest_direction_forced (w v : ℕ → ℝ) (C : ℝ)
    (A B : Finset ℕ) (i : ℕ) (hi : 0 < i) (hiA : i ∈ A)
    (hmax : ∀ j ∈ A ∪ B, j ≤ i)
    (hbound : A.prod w ≤ C * B.prod v)
    (hsep : wins A B → C * B.prod v < A.prod w) : i ∈ B := by
  by_contra hiB
  have hwin : wins A B := by
    refine ⟨i, hi, hiA, hiB, ?_⟩
    intro j hj
    apply hmax j
    rcases Finset.mem_union.mp hj with hAB | hBA
    · exact Finset.mem_union.mpr (Or.inl (Finset.mem_sdiff.mp hAB).1)
    · exact Finset.mem_union.mpr (Or.inr (Finset.mem_sdiff.mp hBA).1)
  exact (not_lt_of_ge hbound) (hsep hwin)

theorem wins_total (A B : Finset ℕ) (hne : A ≠ B)
    (hA : ∀ i ∈ A, 0 < i) (hB : ∀ i ∈ B, 0 < i) :
    wins A B ∨ wins B A := by
  classical
  let S := (A \ B) ∪ (B \ A)
  have hS : S.Nonempty := by
    by_contra h
    have hz : S = ∅ := Finset.not_nonempty_iff_eq_empty.mp h
    apply hne
    ext j
    have hj : j ∉ S := by rw [hz]; simp
    simp only [S, Finset.mem_union, Finset.mem_sdiff] at hj
    tauto
  have himem := Finset.max'_mem S hS
  rcases Finset.mem_union.mp himem with hAB | hBA
  · obtain ⟨hiA, hiB⟩ := Finset.mem_sdiff.mp hAB
    left
    exact ⟨S.max' hS, hA _ hiA, hiA, hiB,
      fun j hj => Finset.le_max' S j hj⟩
  · obtain ⟨hiB, hiA⟩ := Finset.mem_sdiff.mp hBA
    right
    refine ⟨S.max' hS, hB _ hiB, hiB, hiA, ?_⟩
    intro j hj
    apply Finset.le_max' S j
    have hcomm : (B \ A) ∪ (A \ B) = S := Finset.union_comm _ _
    rwa [hcomm] at hj

theorem unique_positive_basis_family (F : Finset (Finset ℕ))
    (w v : ℕ → ℝ) (C : ℝ)
    (hpos : ∀ A ∈ F, ∀ i ∈ A, 0 < i)
    (hbound : ∀ A ∈ F, ∀ B ∈ F, A.prod w ≤ C * B.prod v)
    (hsep : ∀ A ∈ F, ∀ B ∈ F,
      wins A B → C * B.prod v < A.prod w) :
    ∀ A ∈ F, ∀ B ∈ F, A = B := by
  intro A hAF B hBF
  by_contra hne
  rcases wins_total A B hne (hpos A hAF) (hpos B hBF) with hAB | hBA
  · exact (not_lt_of_ge (hbound A hAF B hBF)) (hsep A hAF B hBF hAB)
  · exact (not_lt_of_ge (hbound B hBF A hAF)) (hsep B hBF A hAF hBA)

end SeparatedBases

end InterpolationAudit

#print axioms InterpolationAudit.tangent_in_hyperplane
#print axioms InterpolationAudit.logarithmicFrameEquiv
#print axioms InterpolationAudit.largest_direction_forced
#print axioms InterpolationAudit.unique_positive_basis_family
