import Mathlib

open scoped BigOperators

namespace FourierDichotomy

noncomputable def unusedAverage (used : Finset (Fin 6)) (f : Fin 6 → ℂ) : ℂ :=
  (∑ t ∈ usedᶜ, f t) / ((6 - used.card : ℕ) : ℂ)

theorem occupied_unused_split
    (used : Finset (Fin 6)) (f : Fin 6 → ℂ) (M : ℂ)
    (orthogonal : ∑ t, f t = 0) :
    (∑ t ∈ usedᶜ, M * f t) = -(∑ t ∈ used, M * f t) := by
  have htotal :
      (∑ t ∈ used, M * f t) + (∑ t ∈ usedᶜ, M * f t) = 0 := by
    rw [Finset.sum_add_sum_compl, ← Finset.mul_sum, orthogonal, mul_zero]
  linear_combination htotal

theorem normalized_order_one_contraction
    (used : Finset (Fin 6)) (f : Fin 6 → ℂ) (M : ℂ)
    (orthogonal : ∑ t, f t = 0) (has_unused : used.card < 6) :
    ((6 - used.card : ℕ) : ℂ) *
        unusedAverage used (fun t => M * f t) =
      -(∑ t ∈ used, M * f t) := by
  have hnat : 6 - used.card ≠ 0 := Nat.sub_ne_zero_of_lt has_unused
  have hcomplex : ((6 - used.card : ℕ) : ℂ) ≠ 0 := by
    exact_mod_cast hnat
  unfold unusedAverage
  calc
    ((6 - used.card : ℕ) : ℂ) *
        ((∑ t ∈ usedᶜ, M * f t) / ((6 - used.card : ℕ) : ℂ)) =
        ∑ t ∈ usedᶜ, M * f t := by field_simp [hcomplex]
    _ = -(∑ t ∈ used, M * f t) :=
      occupied_unused_split used f M orthogonal

theorem normalized_real_contraction
    (used : Finset (Fin 6)) (f : Fin 6 → ℂ) (M : ℂ)
    (orthogonal : ∑ t, f t = 0) (has_unused : used.card < 6) :
    ((6 - used.card : ℕ) : ℝ) *
        (unusedAverage used (fun t => M * f t)).re =
      -(∑ t ∈ used, (M * f t).re) := by
  have h := congrArg Complex.re
    (normalized_order_one_contraction used f M orthogonal has_unused)
  simpa using h

theorem seven_row_boundary
    (f : Fin 6 → ℂ) (M : ℂ) (orthogonal : ∑ t, f t = 0) :
    (∑ t ∈ (Finset.univ : Finset (Fin 6)), M * f t) = 0 := by
  rw [← Finset.mul_sum, orthogonal, mul_zero]

theorem nonnegative_sums_vanish
    {ι : Type*} [Fintype ι] (u v : ι → ℝ)
    (hu : ∀ i, 0 ≤ u i) (hv : ∀ i, 0 ≤ v i)
    (identity : 3 * (∑ i, u i) + (∑ i, v i) = 0) :
    (∀ i, u i = 0) ∧ (∀ i, v i = 0) := by
  have hsu : 0 ≤ ∑ i, u i := Finset.sum_nonneg (fun i _ => hu i)
  have hsv : 0 ≤ ∑ i, v i := Finset.sum_nonneg (fun i _ => hv i)
  have hzu : (∑ i, u i) = 0 := by linarith
  have hzv : (∑ i, v i) = 0 := by linarith
  constructor
  · intro i
    have hle : u i ≤ ∑ j, u j :=
      Finset.single_le_sum (fun j _ => hu j) (Finset.mem_univ i)
    exact le_antisymm (by simpa [hzu] using hle) (hu i)
  · intro i
    have hle : v i ≤ ∑ j, v j :=
      Finset.single_le_sum (fun j _ => hv j) (Finset.mem_univ i)
    exact le_antisymm (by simpa [hzv] using hle) (hv i)

theorem pointwise_products_from_certificate
    {ι : Type*} [Fintype ι] (L A B : ι → ℂ)
    (identity :
      3 * (∑ i, Complex.normSq (L i)) +
          (∑ i, Complex.normSq (A i * B i)) = 0) :
    ∀ i, L i = 0 ∧ (A i = 0 ∨ B i = 0) := by
  have vanished := nonnegative_sums_vanish
    (fun i => Complex.normSq (L i))
    (fun i => Complex.normSq (A i * B i))
    (fun i => Complex.normSq_nonneg (L i))
    (fun i => Complex.normSq_nonneg (A i * B i))
    identity
  intro i
  constructor
  · exact Complex.normSq_eq_zero.mp (vanished.1 i)
  · exact mul_eq_zero.mp (Complex.normSq_eq_zero.mp (vanished.2 i))

end FourierDichotomy
