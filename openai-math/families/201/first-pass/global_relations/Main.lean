import Mathlib

namespace GlobalRelations

section Coefficients

variable {K : Type*} [Field K] [CharZero K]
variable {ι : Type*} [DecidableEq ι]

theorem coefficient_zero_of_vertical_derivative
    (c : (ι → ℕ) → K) (vertical : Set ι)
    (hderiv : ∀ (β : ι → ℕ) (j : ι), j ∈ vertical →
      ((β j + 1 : ℕ) : K) * c (Function.update β j (β j + 1)) = 0)
    (β : ι → ℕ) (j : ι) (hj : j ∈ vertical) (hpos : β j ≠ 0) :
    c β = 0 := by
  let γ := Function.update β j (β j - 1)
  have hnat : β j - 1 + 1 = β j := by omega
  have hγ : γ j + 1 = β j := by simp [γ, hnat]
  have hu : Function.update γ j (γ j + 1) = β := by
    funext i
    by_cases hi : i = j
    · subst i
      simp [hγ]
    · simp [γ, hi]
  have hz : (β j : K) * c β = 0 := by
    have h := hderiv γ j hj
    rw [hu, hγ] at h
    exact h
  have hn : (β j : K) ≠ 0 := by exact_mod_cast hpos
  exact (mul_eq_zero.mp hz).resolve_left hn

theorem coefficients_supported_on_horizontal_coordinates
    (c : (ι → ℕ) → K) (vertical : Set ι)
    (hderiv : ∀ (β : ι → ℕ) (j : ι), j ∈ vertical →
      ((β j + 1 : ℕ) : K) * c (Function.update β j (β j + 1)) = 0)
    (β : ι → ℕ) (hnonzero : c β ≠ 0) :
    ∀ j ∈ vertical, β j = 0 := by
  intro j hj
  by_contra hp
  exact hnonzero
    (coefficient_zero_of_vertical_derivative c vertical hderiv β j hj hp)

end Coefficients

section Translation

variable {K : Type*} [CommRing K] {σ : Type*}

noncomputable def translate (a : σ → K) : MvPolynomial σ K →+* MvPolynomial σ K :=
  MvPolynomial.eval₂Hom MvPolynomial.C
    (fun i => MvPolynomial.X i + MvPolynomial.C (a i))

theorem translate_C (a : σ → K) (r : K) :
    translate a (MvPolynomial.C r) = MvPolynomial.C r := by
  simp [translate]

theorem translate_X (a : σ → K) (i : σ) :
    translate a (MvPolynomial.X i) =
      MvPolynomial.X i + MvPolynomial.C (a i) := by
  simp [translate]

theorem translate_inverse (a : σ → K) (p : MvPolynomial σ K) :
    translate (fun i => -a i) (translate a p) = p := by
  induction p using MvPolynomial.induction_on with
  | C r => simp [translate_C]
  | add p q hp hq => simp only [map_add, hp, hq]
  | mul_X p i hp =>
    simp only [map_mul, translate_X, map_add, translate_C, hp]
    simp

theorem translate_zero_iff (a : σ → K) (p : MvPolynomial σ K) :
    translate a p = 0 ↔ p = 0 := by
  constructor
  · intro h
    have hi := translate_inverse a p
    rw [h, map_zero] at hi
    exact hi.symm
  · intro h
    simp [h]

theorem polynomial_identity_at_every_array
    (a : σ → K) (p : MvPolynomial σ K)
    (h : translate a p = 0) (v : σ → K) :
    MvPolynomial.eval v p = 0 := by
  have hp := (translate_zero_iff a p).mp h
  simp [hp]

end Translation

section PairGraph

variable {K : Type*} [Field K]
variable {V P Q C : Type*}
variable [AddCommGroup V] [Module K V]
variable [AddCommGroup P] [Module K P]
variable [AddCommGroup Q] [Module K Q]
variable [AddCommGroup C] [Module K C]

theorem exact_negative_pair_graph
    (left : V →ₗ[K] P) (right : V →ₗ[K] Q)
    (βP : P ≃ₗ[K] C) (βQ : Q ≃ₗ[K] C)
    (honto : Function.Surjective left)
    (hrelation : ∀ v, βP (left v) + βQ (right v) = 0) :
    ∀ p q, (∃ v, left v = p ∧ right v = q) ↔
      q = -βQ.symm (βP p) := by
  have hright : ∀ v, right v = -βQ.symm (βP (left v)) := by
    intro v
    apply βQ.injective
    simp only [map_neg, LinearEquiv.apply_symm_apply]
    have hr : βQ (right v) + βP (left v) = 0 := by
      rw [add_comm]
      exact hrelation v
    exact eq_neg_of_add_eq_zero_left hr
  intro p q
  constructor
  · rintro ⟨v, hp, hq⟩
    rw [← hq, hright, hp]
  · intro hq
    obtain ⟨v, hv⟩ := honto p
    refine ⟨v, hv, ?_⟩
    rw [hright, hv, ← hq]

theorem other_endpoint_surjective
    (left : V →ₗ[K] P) (right : V →ₗ[K] Q)
    (βP : P ≃ₗ[K] C) (βQ : Q ≃ₗ[K] C)
    (honto : Function.Surjective left)
    (hrelation : ∀ v, βP (left v) + βQ (right v) = 0) :
    Function.Surjective right := by
  intro q
  let p := βP.symm (-βQ q)
  have heq : q = -βQ.symm (βP p) := by simp [p]
  obtain ⟨v, _, hv⟩ :=
    (exact_negative_pair_graph left right βP βQ honto hrelation p q).mpr heq
  exact ⟨v, hv⟩

end PairGraph

end GlobalRelations
