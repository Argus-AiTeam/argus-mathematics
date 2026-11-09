import Mathlib

set_option maxHeartbeats 1600000

open scoped BigOperators
open Matrix

namespace Commutator9000101

lemma scalar_polynomial_nonneg (u v : ℝ) (hu : 0 ≤ u) (hv : 0 ≤ v) :
    0 ≤ u * v * (u + v - 3 / 4) + 1 / 64 := by
  by_cases h : 0 ≤ u + v - 3 / 4
  · nlinarith [mul_nonneg (mul_nonneg hu hv) h]
  · have h₁ := mul_nonneg (sq_nonneg (u + v - 1 / 2))
      (show 0 ≤ (u + v) / 4 + 1 / 16 by linarith)
    have h₂ := mul_nonneg (sq_nonneg (u - v))
      (show 0 ≤ 3 / 4 - u - v by linarith)
    nlinarith

lemma scalar_pair_bound (σ τ β γ : ℝ) (hσ : 0 < σ) (hτ : 0 < τ)
    (hβ : (37 + 3 * β) * σ = 40) (hγ : (37 + 3 * γ) * τ = 40) :
    β / (τ + 5 / 37) + γ / (σ + 5 / 37) ≤ (40 / 3) / (σ * τ) := by
  have hσ₀ : σ ≠ 0 := ne_of_gt hσ
  have hτ₀ : τ ≠ 0 := ne_of_gt hτ
  have hdσ : σ + 5 / 37 ≠ 0 := by positivity
  have hdτ : τ + 5 / 37 ≠ 0 := by positivity
  have eβ : β = (40 - 37 * σ) / (3 * σ) := by
    apply (eq_div_iff (by positivity : 3 * σ ≠ 0)).2
    nlinarith [hβ]
  have eγ : γ = (40 - 37 * τ) / (3 * τ) := by
    apply (eq_div_iff (by positivity : 3 * τ ≠ 0)).2
    nlinarith [hγ]
  have hid :
      (40 / 3) / (σ * τ) - β / (τ + 5 / 37) - γ / (σ + 5 / 37) =
        (64000 / 4107) *
          ((37 * σ / 40) * (37 * τ / 40) *
              (37 * σ / 40 + 37 * τ / 40 - 3 / 4) + 1 / 64) /
          (σ * τ * (σ + 5 / 37) * (τ + 5 / 37)) := by
    rw [eβ, eγ]
    field_simp
    ring
  have hG := scalar_polynomial_nonneg (37 * σ / 40) (37 * τ / 40)
    (by positivity) (by positivity)
  have hK : 0 ≤ (40 / 3) / (σ * τ) - β / (τ + 5 / 37) - γ / (σ + 5 / 37) := by
    rw [hid]
    exact div_nonneg (mul_nonneg (by norm_num) hG) (by positivity)
  linarith

variable {n ι : Type*} [Fintype n] [DecidableEq n] [Fintype ι]

omit [DecidableEq n] in
lemma trace_inner (A W : Matrix n n ℝ) :
    trace (Aᵀ * W) = ∑ i, ∑ j, A i j * W i j := by
  simp only [trace, diag_apply, mul_apply, transpose_apply]
  rw [Finset.sum_comm]

lemma trace_weighted_square (A : Matrix n n ℝ) (d : n → ℝ) :
    trace (Aᵀ * A * diagonal d) = ∑ i, ∑ j, d j * (A i j) ^ 2 := by
  simp only [trace, diag_apply]
  simp_rw [mul_diagonal]
  simp only [mul_apply, transpose_apply]
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  ring

lemma weighted_young (A W : Matrix n n ℝ) (d : n → ℝ) (hd : ∀ j, 0 < d j) :
    2 * trace (Aᵀ * W) ≤
      trace (Wᵀ * W * diagonal d) +
        trace (Aᵀ * A * diagonal (fun j => (d j)⁻¹)) := by
  rw [trace_inner, trace_weighted_square, trace_weighted_square]
  simp_rw [Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro i hi
  apply Finset.sum_le_sum
  intro j hj
  have hsq := mul_nonneg (le_of_lt (hd j)) (sq_nonneg (W i j - A i j / d j))
  have heq : d j * (W i j - A i j / d j) ^ 2 =
      d j * W i j ^ 2 - 2 * (A i j * W i j) + (d j)⁻¹ * A i j ^ 2 := by
    field_simp [ne_of_gt (hd j)]
    ring
  rw [heq] at hsq
  linarith

lemma trace_weighted_inner (A W : Matrix n n ℝ) (d : n → ℝ) :
    trace (Aᵀ * W * diagonal d) = ∑ i, ∑ j, d j * (A i j * W i j) := by
  simp only [trace, diag_apply]
  simp_rw [mul_diagonal]
  simp only [mul_apply, transpose_apply, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  ring

lemma gram_sum (X : ι → Matrix n n ℝ) (hX : ∀ r, (X r)ᵀ = X r)
    (C : Matrix n n ℝ) (e : n → ℝ) :
    (∑ r, trace ((X r * C)ᵀ * (X r * C) * diagonal e)) =
      trace (Cᵀ * (∑ r, X r * X r) * C * diagonal e) := by
  simp [transpose_mul, hX, Matrix.mul_assoc, Matrix.mul_sum, Matrix.sum_mul, trace_sum]

lemma trace_diagonal_gram (C : Matrix n n ℝ) (β e : n → ℝ) :
    trace (Cᵀ * diagonal β * C * diagonal e) =
      ∑ i, ∑ j, β i * e j * (C i j) ^ 2 := by
  rw [Matrix.mul_assoc Cᵀ (diagonal β) C, trace_weighted_inner]
  simp_rw [diagonal_mul]
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  ring

omit [DecidableEq n] in
lemma trace_mul_entries (A W : Matrix n n ℝ) :
    trace (A * W) = ∑ i, ∑ j, A i j * W j i := rfl

lemma trace_defect_diagonal (σ β : n → ℝ) (b : Matrix n n ℝ) (hb : bᵀ = b) :
    trace ((diagonal σ - 1) * b * diagonal β * b -
      (diagonal σ - 1) * diagonal β * b * b) =
      ∑ i, ∑ j, (σ i - 1) * (β j - β i) * (b i j) ^ 2 := by
  have hT : diagonal σ - 1 = diagonal (fun i => σ i - 1) := by
    rw [← diagonal_one, diagonal_sub]
  have hb' (i j : n) : b j i = b i j := congrFun (congrFun hb i) j
  rw [hT, trace_sub]
  rw [diagonal_mul_diagonal]
  rw [trace_mul_entries, trace_mul_entries]
  simp_rw [mul_diagonal, diagonal_mul, hb']
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro i hi
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j hj
  ring

omit [DecidableEq n] in
lemma sum_symmetrize (f : n → n → ℝ) :
    (∑ i, ∑ j, f i j) = (1 / 2) * ∑ i, ∑ j, (f i j + f j i) := by
  simp_rw [Finset.sum_add_distrib]
  rw [Finset.sum_comm (f := fun i j => f j i)]
  ring

lemma commutator_entry (σ : n → ℝ) (b : Matrix n n ℝ) (i j : n) :
    (diagonal σ * b - b * diagonal σ) i j = (σ i - σ j) * b i j := by
  simp only [Matrix.sub_apply, diagonal_mul, mul_diagonal]
  ring

lemma commutator_skew (σ : n → ℝ) (b : Matrix n n ℝ) (hb : bᵀ = b) :
    (diagonal σ * b - b * diagonal σ)ᵀ = -(diagonal σ * b - b * diagonal σ) := by
  simp [transpose_sub, transpose_mul, hb, neg_sub]

lemma trace_defect_commutator (σ β : n → ℝ) (hσ : ∀ i, 0 < σ i)
    (hβ : ∀ i, (37 + 3 * β i) * σ i = 40)
    (b : Matrix n n ℝ) (hb : bᵀ = b) :
    trace ((diagonal σ - 1) * b * diagonal β * b -
      (diagonal σ - 1) * diagonal β * b * b) =
      (1 / 2) * ∑ i, ∑ j, ((40 / 3) / (σ i * σ j)) *
        ((diagonal σ * b - b * diagonal σ) i j) ^ 2 := by
  rw [trace_defect_diagonal σ β b hb, sum_symmetrize]
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  have hb' : b j i = b i j := congrFun (congrFun hb i) j
  rw [hb', commutator_entry]
  have hdiff : (β j - β i) * (σ i * σ j) = (40 / 3) * (σ i - σ j) := by
    nlinarith [congrArg (fun x : ℝ => x * σ i) (hβ j),
      congrArg (fun x : ℝ => x * σ j) (hβ i)]
  have hcoeff : (σ i - σ j) * (β j - β i) =
      ((40 / 3) / (σ i * σ j)) * (σ i - σ j) ^ 2 := by
    field_simp [ne_of_gt (hσ i), ne_of_gt (hσ j)]
    nlinarith [congrArg (fun x : ℝ => x * (σ i - σ j)) hdiff]
  calc
    _ = ((σ i - σ j) * (β j - β i)) * b i j ^ 2 := by ring
    _ = _ := by rw [hcoeff]; ring

lemma gram_le_defect (σ β : n → ℝ) (hσ : ∀ i, 0 < σ i)
    (hβ : ∀ i, (37 + 3 * β i) * σ i = 40)
    (b : Matrix n n ℝ) (hb : bᵀ = b) :
    trace ((diagonal σ * b - b * diagonal σ)ᵀ * diagonal β *
      (diagonal σ * b - b * diagonal σ) * diagonal (fun j => (σ j + 5 / 37)⁻¹)) ≤
      trace ((diagonal σ - 1) * b * diagonal β * b -
        (diagonal σ - 1) * diagonal β * b * b) := by
  let C := diagonal σ * b - b * diagonal σ
  have hC : ∀ i j, (C j i) ^ 2 = (C i j) ^ 2 := by
    intro i j
    have h := congrFun (congrFun (commutator_skew σ b hb) i) j
    change C j i = -C i j at h
    rw [h]
    ring
  rw [trace_diagonal_gram, trace_defect_commutator σ β hσ hβ b hb]
  change (∑ i, ∑ j, β i * (σ j + 5 / 37)⁻¹ * C i j ^ 2) ≤
    (1 / 2) * ∑ i, ∑ j, (40 / 3) / (σ i * σ j) * C i j ^ 2
  rw [sum_symmetrize]
  apply mul_le_mul_of_nonneg_left _ (by norm_num)
  apply Finset.sum_le_sum
  intro i hi
  apply Finset.sum_le_sum
  intro j hj
  rw [hC i j]
  have hp := mul_le_mul_of_nonneg_right
    (scalar_pair_bound (σ i) (σ j) (β i) (β j) (hσ i) (hσ j) (hβ i) (hβ j))
    (sq_nonneg (C i j))
  simpa only [div_eq_mul_inv, add_mul] using hp

omit [DecidableEq n] in
lemma skew_trace (C X W : Matrix n n ℝ) (hC : Cᵀ = -C) (hX : Xᵀ = X) :
    trace (C * (X * W)) = -trace ((X * C)ᵀ * W) := by
  simp [transpose_mul, hC, hX, Matrix.mul_assoc]

lemma diagonal_deficit_nonneg (X w : ι → Matrix n n ℝ) (b : Matrix n n ℝ)
    (hX : ∀ r, (X r)ᵀ = X r) (hb : bᵀ = b)
    (σ β : n → ℝ) (hσ : ∀ i, 0 < σ i)
    (hβ : ∀ i, (37 + 3 * β i) * σ i = 40)
    (hB : (∑ r, X r * X r) = diagonal β) :
    0 ≤ trace ((diagonal σ - 1) * b * diagonal β * b -
          (diagonal σ - 1) * diagonal β * b * b) +
        2 * trace ((diagonal σ * b - b * diagonal σ) * (∑ r, X r * w r)) +
        ∑ r, trace ((w r)ᵀ * w r * (diagonal σ + (5 / 37 : ℝ) • 1)) := by
  let C := diagonal σ * b - b * diagonal σ
  let d : n → ℝ := fun i => σ i + 5 / 37
  have hd : ∀ i, 0 < d i := by
    intro i
    have := hσ i
    dsimp [d]
    linarith
  have hD : diagonal d = diagonal σ + (5 / 37 : ℝ) • 1 := by
    ext i j
    by_cases hij : i = j <;> simp [d, diagonal, hij]
  have hy := Finset.sum_le_sum (s := (Finset.univ : Finset ι))
    (fun r _ => weighted_young (X r * C) (w r) d hd)
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum] at hy
  have hg :
      (∑ r, trace ((X r * C)ᵀ * (X r * C) * diagonal (fun j => (d j)⁻¹))) ≤
        trace ((diagonal σ - 1) * b * diagonal β * b -
          (diagonal σ - 1) * diagonal β * b * b) := by
    rw [gram_sum X hX C, hB]
    exact gram_le_defect σ β hσ hβ b hb
  have hc : trace (C * (∑ r, X r * w r)) =
      -(∑ r, trace ((X r * C)ᵀ * w r)) := by
    rw [Matrix.mul_sum, trace_sum]
    simp_rw [skew_trace C _ _ (commutator_skew σ b hb) (hX _)]
    rw [Finset.sum_neg_distrib]
  change 0 ≤ _ + 2 * trace (C * (∑ r, X r * w r)) + _
  rw [hc, ← hD]
  linarith

lemma diagonal_gram_nonneg (X : ι → Matrix n n ℝ) (hX : ∀ r, (X r)ᵀ = X r)
    (β : n → ℝ) (hB : (∑ r, X r * X r) = diagonal β) (i : n) :
    0 ≤ β i := by
  have he : (∑ r, ∑ j, X r i j * X r j i) = β i := by
    simpa only [Matrix.sum_apply, mul_apply, diagonal_apply_eq] using
      congrArg (fun M : Matrix n n ℝ => M i i) hB
  rw [← he]
  apply Finset.sum_nonneg
  intro r hr
  apply Finset.sum_nonneg
  intro j hj
  have hx : X r j i = X r i j := congrFun (congrFun (hX r) i) j
  rw [hx]
  exact mul_self_nonneg _

omit [DecidableEq n] in
lemma map_transpose (e : Matrix n n ℝ ≃⋆ₐ[ℝ] Matrix n n ℝ) (A : Matrix n n ℝ) :
    e Aᵀ = (e A)ᵀ := by
  simpa only [star_eq_conjTranspose, conjTranspose_eq_transpose_of_trivial] using
    (map_star e A)

lemma trace_conjugate (U : Matrix.unitaryGroup n ℝ) (A : Matrix n n ℝ) :
    trace (Unitary.conjStarAlgAut ℝ _ U A) = trace A := by
  rw [Unitary.conjStarAlgAut_apply, trace_mul_cycle]
  simp

lemma mapped_inverse (e : Matrix n n ℝ ≃⋆ₐ[ℝ] Matrix n n ℝ)
    (B : Matrix n n ℝ) (β : n → ℝ) (hβ : ∀ i, 0 ≤ β i)
    (hB : e B = diagonal β) :
    e ((37 : ℝ) • (1 : Matrix n n ℝ) + (3 : ℝ) • B)⁻¹ =
      diagonal (fun i => (37 + 3 * β i)⁻¹) := by
  let A := (37 : ℝ) • (1 : Matrix n n ℝ) + (3 : ℝ) • B
  have hA : e A = diagonal (fun i => 37 + 3 * β i) := by
    simp only [A, map_add, map_smul, map_one, hB]
    ext i j
    by_cases hij : i = j <;> simp [diagonal, hij]
  have hden (i : n) : 37 + 3 * β i ≠ 0 := by
    have := hβ i
    positivity
  have hl : diagonal (fun i => (37 + 3 * β i)⁻¹) * e A = 1 := by
    rw [hA, diagonal_mul_diagonal]
    rw [← diagonal_one]
    congr 1
    funext i
    exact inv_mul_cancel₀ (hden i)
  have horig : e.symm (diagonal (fun i => (37 + 3 * β i)⁻¹)) * A = 1 := by
    apply e.injective
    change e (e.symm (diagonal (fun i => (37 + 3 * β i)⁻¹)) * A) = e 1
    rw [map_mul, e.apply_symm_apply, map_one]
    exact hl
  change e A⁻¹ = _
  rw [Matrix.inv_eq_left_inv horig, e.apply_symm_apply]

lemma full_deficit_nonneg (X w : ι → Matrix n n ℝ) (b : Matrix n n ℝ)
    (hX : ∀ r, (X r)ᵀ = X r) (hb : bᵀ = b) :
    let B := ∑ r, X r * X r
    let S := (40 : ℝ) • ((37 : ℝ) • (1 : Matrix n n ℝ) + (3 : ℝ) • B)⁻¹
    0 ≤ trace ((S - 1) * b * B * b - (S - 1) * B * b * b) +
        2 * trace ((S * b - b * S) * (∑ r, X r * w r)) +
        ∑ r, trace ((w r)ᵀ * w r * (S + (5 / 37 : ℝ) • 1)) := by
  intro B S
  have hBT : Bᵀ = B := by
    simp [B, transpose_sum, transpose_mul, hX]
  have hBH : B.IsHermitian := isHermitian_iff_isSymm.mpr hBT
  let U := star hBH.eigenvectorUnitary
  let e := Unitary.conjStarAlgAut ℝ (Matrix n n ℝ) U
  let β := hBH.eigenvalues
  let σ : n → ℝ := fun i => 40 / (37 + 3 * β i)
  have heB : e B = diagonal β := by
    simpa [e, U, β, Function.comp_def] using hBH.conjStarAlgAut_star_eigenvectorUnitary
  have heX (r : ι) : (e (X r))ᵀ = e (X r) := by
    rw [← map_transpose, hX r]
  have heb : (e b)ᵀ = e b := by rw [← map_transpose, hb]
  have heGram : (∑ r, e (X r) * e (X r)) = diagonal β := by
    rw [← heB]
    simp only [B, map_sum, map_mul]
  have hβ : ∀ i, 0 ≤ β i := diagonal_gram_nonneg (fun r => e (X r)) heX β heGram
  have hσ : ∀ i, 0 < σ i := by
    intro i
    dsimp [σ]
    have := hβ i
    positivity
  have hβσ : ∀ i, (37 + 3 * β i) * σ i = 40 := by
    intro i
    dsimp [σ]
    have := hβ i
    field_simp
  have heS : e S = diagonal σ := by
    change e ((40 : ℝ) • _) = _
    rw [map_smul, mapped_inverse e B β hβ heB]
    rw [← diagonal_smul]
    congr 1
  have ht (A : Matrix n n ℝ) : trace (e A) = trace A := trace_conjugate U A
  have hn := diagonal_deficit_nonneg (fun r => e (X r)) (fun r => e (w r)) (e b)
    heX heb σ β hσ hβσ heGram
  have heT : e S - 1 = e (S - 1) := by simp only [map_sub, map_one]
  have heD : e S + (5 / 37 : ℝ) • 1 = e (S + (5 / 37 : ℝ) • 1) := by
    simp only [map_add, map_smul, map_one]
  rw [← heS, ← heB, heT, heD] at hn
  simpa only [← map_transpose, ← map_sub, ← map_mul, ← map_sum, ht] using hn

theorem real_matrix_commutator_inequality
    (X w : ι → Matrix n n ℝ) (b : Matrix n n ℝ)
    (hX : ∀ r, (X r).IsSymm) (hb : b.IsSymm) :
    let B := ∑ r, X r * X r
    let S := (40 : ℝ) • ((37 : ℝ) • (1 : Matrix n n ℝ) + (3 : ℝ) • B)⁻¹
    let T := S - 1
    let F := ∑ r, X r * w r
    let P := trace (T * b * B * b - T * B * b * b);
    -P - 2 * trace ((T * b - b * T) * F) -
        trace (T * (∑ r, (w r)ᵀ * w r)) ≤
      (42 / 37 : ℝ) * ∑ r, trace ((w r)ᵀ * w r) := by
  intro B S T F P
  have hn := full_deficit_nonneg X w b hX hb
  change 0 ≤ P + 2 * trace ((S * b - b * S) * F) +
    ∑ r, trace ((w r)ᵀ * w r * (S + (5 / 37 : ℝ) • 1)) at hn
  have hC : T * b - b * T = S * b - b * S := by
    dsimp [T]
    noncomm_ring
  have hD : S + (5 / 37 : ℝ) • 1 = T + (42 / 37 : ℝ) • 1 := by
    dsimp [T]
    module
  have hQ :
      (∑ r, trace ((w r)ᵀ * w r * (S + (5 / 37 : ℝ) • 1))) =
        trace (T * (∑ r, (w r)ᵀ * w r)) +
          (42 / 37 : ℝ) * ∑ r, trace ((w r)ᵀ * w r) := by
    rw [hD]
    calc
      _ = ∑ r, (trace (T * ((w r)ᵀ * w r)) +
          (42 / 37 : ℝ) * trace ((w r)ᵀ * w r)) := by
        apply Finset.sum_congr rfl
        intro r hr
        rw [Matrix.mul_add, trace_add, Matrix.mul_smul, Matrix.mul_one, trace_smul,
          trace_mul_comm ((w r)ᵀ * w r) T]
        rfl
      _ = _ := by
        rw [Finset.sum_add_distrib, Matrix.mul_sum, trace_sum]
        rw [Finset.mul_sum]
  rw [hQ] at hn
  rw [hC]
  linarith

end Commutator9000101

#print axioms Commutator9000101.real_matrix_commutator_inequality
