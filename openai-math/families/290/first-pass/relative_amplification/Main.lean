import Mathlib

open scoped BigOperators

namespace RelativeAmplification

def captureLength (e B b : ℝ) : ℝ :=
  max 0 (min B (e + b) - max (-B) (e - b))

theorem capture_length_le (e B b : ℝ) (hb : 0 ≤ b) :
    captureLength e B b ≤ 2 * b := by
  unfold captureLength
  apply max_le
  · positivity
  · have h₁ := min_le_right B (e + b)
    have h₂ := le_max_right (-B) (e - b)
    linarith

theorem capture_probability_le (e B b : ℝ) (hB : 0 < B) (hb : 0 ≤ b) :
    captureLength e B b / (2 * B) ≤ b / B := by
  have h := capture_length_le e B b hb
  apply (div_le_iff₀ (by positivity : 0 < 2 * B)).2
  calc
    captureLength e B b ≤ 2 * b := h
    _ = b / B * (2 * B) := by field_simp

theorem capture_probability_eq (e B b : ℝ) (hB : 0 < B) (hb : 0 ≤ b)
    (hinside : |e| + b ≤ B) :
    captureLength e B b / (2 * B) = b / B := by
  have hlo : -B ≤ e - b := by
    have h := neg_abs_le e
    linarith
  have hhi : e + b ≤ B := by
    have h := le_abs_self e
    linarith
  unfold captureLength
  rw [min_eq_right hhi, max_eq_right hlo]
  have hsub : e + b - (e - b) = 2 * b := by ring
  rw [hsub, max_eq_right (by positivity : 0 ≤ 2 * b)]
  field_simp

theorem norm_sub_sq_le_two {E : Type*} [SeminormedAddCommGroup E] (x y : E) :
    ‖x - y‖ ^ 2 ≤ 2 * ‖x‖ ^ 2 + 2 * ‖y‖ ^ 2 := by
  have h := norm_sub_le x y
  have hs : ‖x - y‖ ^ 2 ≤ (‖x‖ + ‖y‖) ^ 2 :=
    (sq_le_sq₀ (norm_nonneg _) (by positivity)).2 h
  nlinarith [sq_nonneg (‖x‖ - ‖y‖)]

theorem averaging_loss {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (v u d : E) (hu : ‖u‖ ≤ ‖v‖) (hd : ‖d‖ = ‖v‖) :
    ‖u - d‖ ^ 2 ≤ 4 * (‖v‖ ^ 2 - ‖(1 / 2 : ℝ) • (u + d)‖ ^ 2) := by
  have hp := parallelogram_law_with_norm ℝ u d
  have hs : ‖(1 / 2 : ℝ) • (u + d)‖ ^ 2 = (1 / 4 : ℝ) * ‖u + d‖ ^ 2 := by
    rw [norm_smul]
    norm_num
    ring
  have hu₂ : ‖u‖ ^ 2 ≤ ‖v‖ ^ 2 :=
    (sq_le_sq₀ (norm_nonneg _) (norm_nonneg _)).2 hu
  rw [hd] at hp
  nlinarith

noncomputable def captureWeight (b A l : ℝ) (j : ℕ) : ℝ :=
  b ^ 2 / (2 * A * (b + 1 + ((j : ℝ) + 1) * l))

theorem capture_weight_pos (b A l : ℝ) (hb : 0 < b) (hA : 0 < A)
    (hl : 0 ≤ l) (j : ℕ) : 0 < captureWeight b A l j := by
  unfold captureWeight
  positivity

theorem capture_weight_harmonic_lower (b A l : ℝ) (hb : 0 < b) (hA : 0 < A)
    (hl : 0 ≤ l) (j : ℕ) :
    (b ^ 2 / (2 * A * (b + 1 + l))) / ((j : ℝ) + 1) ≤
      captureWeight b A l j := by
  have hj : 0 ≤ (j : ℝ) := Nat.cast_nonneg j
  have hB : 0 < b + 1 + ((j : ℝ) + 1) * l := by positivity
  have hden : 2 * A * (b + 1 + ((j : ℝ) + 1) * l) ≤
      (2 * A * (b + 1 + l)) * ((j : ℝ) + 1) := by
    have h := mul_nonneg (by linarith : 0 ≤ b + 1) hj
    have hinner : b + 1 + ((j : ℝ) + 1) * l ≤
        (b + 1 + l) * ((j : ℝ) + 1) := by nlinarith
    nlinarith [mul_le_mul_of_nonneg_left hinner (by positivity : 0 ≤ 2 * A)]
  rw [div_div]
  exact div_le_div_of_nonneg_left (sq_nonneg b) (by positivity) hden

theorem capture_weight_not_summable (b A l : ℝ) (hb : 0 < b) (hA : 0 < A)
    (hl : 0 ≤ l) : ¬ Summable (captureWeight b A l) := by
  intro hw
  let K := b ^ 2 / (2 * A * (b + 1 + l))
  have hK : 0 < K := by dsimp [K]; positivity
  have hdom : Summable (fun j : ℕ => K / ((j : ℝ) + 1)) :=
    Summable.of_nonneg_of_le (fun j => by positivity)
      (fun j => capture_weight_harmonic_lower b A l hb hA hl j) hw
  have hharm : Summable (fun j : ℕ => 1 / ((j : ℝ) + 1)) := by
    simpa only [div_eq_mul_inv, ← mul_assoc, inv_mul_cancel₀ hK.ne', one_mul]
      using hdom.mul_left K⁻¹
  have hshift : Summable (fun j : ℕ => 1 / ((j + 1 : ℕ) : ℝ)) := by
    simpa only [Nat.cast_add, Nat.cast_one] using hharm
  exact Real.not_summable_one_div_natCast
    ((summable_nat_add_iff (f := fun j : ℕ => 1 / (j : ℝ)) 1).1 hshift)

theorem weighted_error_floor (m : ℕ) (alpha c : ℝ)
    (w prefixError ideal capturedError defect loss : ℕ → ℝ)
    (hi : ∀ j < m, alpha * c ^ 2 * w j ≤ ideal j)
    (he : ∀ j < m, capturedError j ≤ 4 * w j * prefixError j)
    (ht : ∀ j < m, ideal j ≤ 2 * defect j + 2 * capturedError j)
    (hl : ∀ j < m, defect j ≤ 4 * loss j)
    (hbudget : ∑ j ∈ Finset.range m, loss j ≤ 1) :
    alpha * c ^ 2 / 8 * (∑ j ∈ Finset.range m, w j) - 1 ≤
      ∑ j ∈ Finset.range m, w j * prefixError j := by
  have hsum :
      (∑ j ∈ Finset.range m, alpha * c ^ 2 * w j) ≤
        ∑ j ∈ Finset.range m, (8 * loss j + 8 * (w j * prefixError j)) := by
    apply Finset.sum_le_sum
    intro j hj
    have hjm := Finset.mem_range.mp hj
    have h₁ := hi j hjm
    have h₂ := he j hjm
    have h₃ := ht j hjm
    have h₄ := hl j hjm
    nlinarith
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum] at hsum
  nlinarith

theorem nonsummable_budget_obstruction (w : ℕ → ℝ) (hw : ∀ j, 0 ≤ w j)
    (hdiv : ¬ Summable w) (gamma eta : ℝ) (hgap : eta < gamma)
    (prefixError : ℕ → ℕ → ℝ)
    (herror : ∀ m j, j < m → prefixError m j ≤ eta)
    (hfloor : ∀ m, gamma * (∑ j ∈ Finset.range m, w j) - 1 ≤
      ∑ j ∈ Finset.range m, w j * prefixError m j) : False := by
  apply hdiv
  apply summable_of_sum_range_le hw (c := 1 / (gamma - eta))
  intro m
  have hupper :
      (∑ j ∈ Finset.range m, w j * prefixError m j) ≤
        eta * (∑ j ∈ Finset.range m, w j) := by
    rw [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro j hj
    nlinarith [mul_le_mul_of_nonneg_left
      (herror m j (Finset.mem_range.mp hj)) (hw j)]
  have hf := hfloor m
  apply (le_div_iff₀ (sub_pos.mpr hgap)).2
  nlinarith

theorem arbitrary_terminal_amplification
    (w : ℕ → ℝ) (hw : ∀ j, 0 ≤ w j) (hdiv : ¬ Summable w)
    (alpha c eta : ℝ) (hgap : eta < alpha * c ^ 2 / 8)
    (prefixError ideal capturedError defect loss : ℕ → ℕ → ℝ)
    (herror : ∀ m j, j < m → prefixError m j ≤ eta)
    (hi : ∀ m j, j < m → alpha * c ^ 2 * w j ≤ ideal m j)
    (he : ∀ m j, j < m → capturedError m j ≤ 4 * w j * prefixError m j)
    (ht : ∀ m j, j < m → ideal m j ≤ 2 * defect m j + 2 * capturedError m j)
    (hl : ∀ m j, j < m → defect m j ≤ 4 * loss m j)
    (hbudget : ∀ m, ∑ j ∈ Finset.range m, loss m j ≤ 1) : False := by
  apply nonsummable_budget_obstruction w hw hdiv (alpha * c ^ 2 / 8) eta hgap
    prefixError herror
  intro m
  exact weighted_error_floor m alpha c w (prefixError m) (ideal m)
    (capturedError m) (defect m) (loss m) (hi m) (he m) (ht m) (hl m) (hbudget m)

theorem affine_capture_amplification
    (b A l alpha c eta : ℝ) (hb : 0 < b) (hA : 0 < A) (hl : 0 ≤ l)
    (hgap : eta < alpha * c ^ 2 / 8)
    (prefixError ideal capturedError defect loss : ℕ → ℕ → ℝ)
    (herror : ∀ m j, j < m → prefixError m j ≤ eta)
    (hi : ∀ m j, j < m → alpha * c ^ 2 * captureWeight b A l j ≤ ideal m j)
    (he : ∀ m j, j < m →
      capturedError m j ≤ 4 * captureWeight b A l j * prefixError m j)
    (ht : ∀ m j, j < m → ideal m j ≤ 2 * defect m j + 2 * capturedError m j)
    (hdefect : ∀ m j, j < m → defect m j ≤ 4 * loss m j)
    (hbudget : ∀ m, ∑ j ∈ Finset.range m, loss m j ≤ 1) : False := by
  exact arbitrary_terminal_amplification (captureWeight b A l)
    (fun j => (capture_weight_pos b A l hb hA hl j).le)
    (capture_weight_not_summable b A l hb hA hl) alpha c eta hgap
    prefixError ideal capturedError defect loss herror hi he ht hdefect hbudget

end RelativeAmplification
