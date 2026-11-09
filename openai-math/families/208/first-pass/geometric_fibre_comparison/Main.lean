import Mathlib

open scoped BigOperators
open Module

set_option autoImplicit false

namespace FibreComparison

theorem transport_identity {M : Type*} [Monoid M]
    (P H D : Mˣ) (A B C E : M)
    (hP : (P : M) * A = C * P)
    (hH : C * H = (H : M) * E)
    (hD : (D : M) * B = E * D) :
    A * ((P⁻¹ * H * D : Mˣ) : M) =
      ((P⁻¹ * H * D : Mˣ) : M) * B := by
  have hPi : A * ↑(P⁻¹) = ↑(P⁻¹) * C := by
    calc
      A * ↑(P⁻¹) = ↑(P⁻¹) * (↑P * A) * ↑(P⁻¹) := by
        simp
      _ = ↑(P⁻¹) * (C * ↑P) * ↑(P⁻¹) := by rw [hP]
      _ = ↑(P⁻¹) * C := by simp [mul_assoc]
  simp only [Units.val_mul]
  calc
    A * (↑(P⁻¹) * ↑H * ↑D) = (A * ↑(P⁻¹)) * ↑H * ↑D := by
      simp only [mul_assoc]
    _ = (↑(P⁻¹) * C) * ↑H * ↑D := by rw [hPi]
    _ = ↑(P⁻¹) * (C * ↑H) * ↑D := by simp only [mul_assoc]
    _ = ↑(P⁻¹) * (↑H * E) * ↑D := by rw [hH]
    _ = ↑(P⁻¹) * ↑H * (E * ↑D) := by simp only [mul_assoc]
    _ = ↑(P⁻¹) * ↑H * (↑D * B) := by rw [hD]
    _ = (↑(P⁻¹) * ↑H * ↑D) * B := by simp only [mul_assoc]

theorem parameter_cancellation {M I : Type*} [Monoid M]
    (P H D : Mˣ) (A B C : I → M) (σ : I → I)
    (hP : ∀ t, (P : M) * A t = C (σ t) * P)
    (hH : ∀ t, C t * H = (H : M) * B t)
    (hD : ∀ t, (D : M) * B t = B (σ t) * D) :
    ∀ t, A t * ((P⁻¹ * H * D : Mˣ) : M) =
      ((P⁻¹ * H * D : Mˣ) : M) * B t := by
  intro t
  exact transport_identity P H D (A t) (B t) (C (σ t)) (B (σ t))
    (hP t) (hH (σ t)) (hD t)

theorem formal_polynomial_separation {k : Type*} [CommRing k]
    (F G : Polynomial (PowerSeries k))
    (h : ∀ j d r : ℕ, r < j →
      PowerSeries.coeff r (F.coeff d) =
        PowerSeries.coeff r (G.coeff d)) :
    F = G := by
  apply Polynomial.ext
  intro d
  apply PowerSeries.ext
  intro r
  exact h (r + 1) d r (Nat.lt_succ_self r)

section Combinations

variable {k K n ι : Type*} [Field k] [Field K]
  [Fintype n] [DecidableEq n] [Fintype ι]

noncomputable def combination (S : ι → Matrix n n k) (c : ι → k) :
    Matrix n n k :=
  fun i j => ∑ a, c a * S a i j

noncomputable def combinationPolynomial (S : ι → Matrix n n k) :
    Matrix n n (MvPolynomial ι k) :=
  fun i j => ∑ a, MvPolynomial.X a * MvPolynomial.C (S a i j)

omit [Fintype n] [DecidableEq n] in
theorem combination_eq_sum (S : ι → Matrix n n k) (c : ι → k) :
    combination S c = ∑ a, c a • S a := by
  ext i j
  simp [combination, Matrix.sum_apply, smul_eq_mul]

theorem eval_combination_det (S : ι → Matrix n n k)
    (f : k →+* K) (c : ι → K) :
    (MvPolynomial.eval₂Hom f c) (combinationPolynomial S).det =
      (combination (fun a => (S a).map f) c).det := by
  rw [RingHom.map_det]
  congr 1
  ext i j
  simp [combinationPolynomial, combination, Matrix.map_apply]

theorem exists_nonsingular_combination [Infinite k]
    (S : ι → Matrix n n k) (f : k →+* K) (c : ι → K)
    (hdet : (combination (fun a => (S a).map f) c).det ≠ 0) :
    ∃ d : ι → k, (combination S d).det ≠ 0 := by
  classical
  let q := (combinationPolynomial S).det
  have hq : q ≠ 0 := by
    intro hz
    apply hdet
    calc
      (combination (fun a => (S a).map f) c).det =
          (MvPolynomial.eval₂Hom f c) q :=
        (eval_combination_det S f c).symm
      _ = 0 := by rw [hz, map_zero]
  have hex : ∃ d : ι → k, MvPolynomial.eval d q ≠ 0 := by
    by_contra hn
    apply hq
    apply MvPolynomial.funext
    intro d
    have hd : MvPolynomial.eval d q = 0 := by
      by_contra hd
      exact hn ⟨d, hd⟩
    simpa using hd
  obtain ⟨d, hd⟩ := hex
  refine ⟨d, ?_⟩
  have he : MvPolynomial.eval d q = (combination S d).det := by
    change (MvPolynomial.eval₂Hom (RingHom.id k) d)
      (combinationPolynomial S).det = _
    rw [eval_combination_det]
    rfl
  intro hz
  exact hd (he.trans hz)

theorem combination_intertwines (S : ι → Matrix n n k) (c : ι → k)
    (A B : Matrix n n k) (h : ∀ a, A * S a = S a * B) :
    A * combination S c = combination S c * B := by
  calc
    A * combination S c = ∑ a, c a • (A * S a) := by
      simp [combination_eq_sum, Finset.mul_sum]
    _ = ∑ a, c a • (S a * B) := by simp_rw [h]
    _ = combination S c * B := by
      simp [combination_eq_sum, Finset.sum_mul]

end Combinations

section Descent

variable {k K n I : Type*} [Field k] [Field K] [Algebra k K]
  [Fintype n] [DecidableEq n]

omit [DecidableEq n] in
theorem coordinates_intertwine (ℓ : K →ₗ[k] k)
    (A B : Matrix n n k) (F : Matrix n n K)
    (h : A.map (algebraMap k K) * F =
      F * B.map (algebraMap k K)) :
    A * F.map ℓ = F.map ℓ * B := by
  have hl (c : k) (z : K) :
      ℓ (algebraMap k K c * z) = c * ℓ z := by
    simpa [Algebra.smul_def] using ℓ.map_smul c z
  have hr (c : k) (z : K) :
      ℓ (z * algebraMap k K c) = ℓ z * c := by
    rw [mul_comm, hl, mul_comm]
  ext i j
  have he := congrArg (fun M : Matrix n n K => ℓ (M i j)) h
  simpa only [Matrix.mul_apply, Matrix.map_apply, map_sum, hl, hr] using he

theorem finite_coordinate_expansion {ι : Type*}
    (b : Basis ι k K) (F : Matrix n n K) :
    ∃ s : Finset ι,
      F = combination
        (fun a : s => (F.map (b.coord a.val)).map (algebraMap k K))
        (fun a : s => b a.val) := by
  classical
  let s : Finset ι := Finset.univ.biUnion fun i : n =>
    Finset.univ.biUnion fun j : n => (b.repr (F i j)).support
  refine ⟨s, ?_⟩
  ext i j
  have hs : (b.repr (F i j)).support ⊆ s := by
    intro a ha
    exact Finset.mem_biUnion.mpr ⟨i, Finset.mem_univ _,
      Finset.mem_biUnion.mpr ⟨j, Finset.mem_univ _, ha⟩⟩
  have hb := b.linearCombination_repr (F i j)
  rw [Finsupp.linearCombination_apply,
    Finsupp.sum_of_support_subset _ hs _ (by intros; simp)] at hb
  change F i j =
    ∑ a : s, b a.val * algebraMap k K (b.repr (F i j) a.val)
  have hu := Finset.sum_coe_sort s
    (fun a => b a * algebraMap k K (b.repr (F i j) a))
  rw [hu]
  simpa only [Algebra.smul_def, mul_comm] using hb.symm

theorem descend_intertwiner [Infinite k]
    (A B : I → Matrix n n k) (F : Matrix n n K)
    (h : ∀ t, (A t).map (algebraMap k K) * F =
      F * (B t).map (algebraMap k K))
    (hdet : F.det ≠ 0) :
    ∃ F₀ : Matrix n n k, F₀.det ≠ 0 ∧
      ∀ t, A t * F₀ = F₀ * B t := by
  classical
  let b := Basis.ofVectorSpace k K
  obtain ⟨s, hs⟩ := finite_coordinate_expansion b F
  let S : s → Matrix n n k := fun a => F.map (b.coord a.val)
  let c : s → K := fun a => b a.val
  have hd : (combination (fun a => (S a).map (algebraMap k K)) c).det ≠ 0 := by
    rw [← hs]
    exact hdet
  obtain ⟨d, hd⟩ := exists_nonsingular_combination S (algebraMap k K) c hd
  refine ⟨combination S d, hd, ?_⟩
  intro t
  apply combination_intertwines
  intro a
  exact coordinates_intertwine (b.coord a.val) (A t) (B t) F (h t)

theorem comparison_over_extension [Infinite k]
    (A B : I → Matrix n n k) (C E : I → Matrix n n K)
    (P H D : (Matrix n n K)ˣ)
    (hP : ∀ t, (P : Matrix n n K) * (A t).map (algebraMap k K) = C t * P)
    (hH : ∀ t, C t * H = (H : Matrix n n K) * E t)
    (hD : ∀ t, (D : Matrix n n K) * (B t).map (algebraMap k K) = E t * D) :
    ∃ F₀ : Matrix n n k, F₀.det ≠ 0 ∧
      ∀ t, A t * F₀ = F₀ * B t := by
  let F : Matrix n n K := ↑(P⁻¹ * H * D)
  have h : ∀ t, (A t).map (algebraMap k K) * F =
      F * (B t).map (algebraMap k K) := by
    intro t
    exact transport_identity P H D
      ((A t).map (algebraMap k K)) ((B t).map (algebraMap k K))
      (C t) (E t) (hP t) (hH t) (hD t)
  have hd : F.det ≠ 0 := by
    have hu : IsUnit F := (P⁻¹ * H * D).isUnit
    exact isUnit_iff_ne_zero.mp ((Matrix.isUnit_iff_isUnit_det F).mp hu)
  exact descend_intertwiner A B F h hd

end Descent

#print axioms transport_identity
#print axioms formal_polynomial_separation
#print axioms descend_intertwiner
#print axioms comparison_over_extension

end FibreComparison
