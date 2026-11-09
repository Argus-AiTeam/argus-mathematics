import Mathlib

namespace ExactCorrectionAudit

theorem metric_transfer_identity
    (g₁ g₂ s₁ s₂ u₁ u₂ h hs ht d e : ℝ) :
    h - (g₁ + u₁) * (g₂ + u₂) - e ^ 2 * h =
      ((h - g₁ * g₂) - d ^ 2 * hs) -
        ((s₁ + u₁) * (s₂ + u₂) - s₁ * s₂ -
          d ^ 2 * hs + e ^ 2 * ht) -
        ((g₁ - s₁) * u₂ + (g₂ - s₂) * u₁) +
        e ^ 2 * (ht - h) := by
  ring

theorem summable_increment_margin (k m : ℝ)
    (hk : 10 ≤ k) (hm : 2 * m ≤ k) :
    1 < k + (6 / 5 : ℝ) * (1 - m) := by
  linarith

theorem step_to_affine_bound (B x c y : ℝ)
    (hB : 1 ≤ B) (hx : 0 ≤ x) (hc : c ≤ 1 / 4)
    (hy : y ≤ B / 4 + c * (1 + x)) :
    y ≤ B / 2 + x / 4 := by
  have hcx : c * (1 + x) ≤ (1 / 4 : ℝ) * (1 + x) :=
    mul_le_mul_of_nonneg_right hc (by linarith)
  linarith

theorem block_bound (B : ℝ) (x : ℕ → ℝ)
    (hB : 0 ≤ B)
    (hstep : ∀ n, x (n + 1) ≤ B / 2 + x n / 4) :
    ∀ n, x n ≤ (2 / 3 : ℝ) * B + (1 / 4 : ℝ) ^ n * x 0 := by
  intro n
  induction n with
  | zero =>
      simp only [pow_zero, one_mul]
      linarith
  | succ n ih =>
      have hs := hstep n
      rw [pow_succ]
      nlinarith

theorem finite_waiting (B : ℝ) (x c : ℕ → ℝ)
    (hB : 1 ≤ B) (hx : ∀ n, 0 ≤ x n)
    (hc : ∀ n, c n ≤ 1 / 4)
    (hstep : ∀ n, x (n + 1) ≤ B / 4 + c n * (1 + x n)) :
    ∃ n, x n < B := by
  have hden : 0 < 3 * (x 0 + 1) := by
    have := hx 0
    linarith
  have hpositive : 0 < B / (3 * (x 0 + 1)) :=
    div_pos (by linarith) hden
  obtain ⟨n, hn⟩ :=
    exists_pow_lt_of_lt_one hpositive (show (1 / 4 : ℝ) < 1 by norm_num)
  have hn' : (1 / 4 : ℝ) ^ n * (3 * (x 0 + 1)) < B :=
    (lt_div_iff₀ hden).mp hn
  have hb := block_bound B x (by linarith)
    (fun n => step_to_affine_bound B (x n) (c n) (x (n + 1))
      hB (hx n) (hc n) (hstep n)) n
  have hp : 0 ≤ (1 / 4 : ℝ) ^ n := pow_nonneg (by norm_num) n
  exact ⟨n, by nlinarith⟩

theorem retained_bound_persists (B x c y : ℝ)
    (hB : 1 ≤ B) (hx : 0 ≤ x) (hxB : x ≤ B)
    (hc : c ≤ 1 / 4)
    (hy : y ≤ B / 4 + c * (1 + x)) :
    y < B := by
  have := step_to_affine_bound B x c y hB hx hc hy
  linarith

theorem finite_waiting_after (B : ℝ) (x c : ℕ → ℝ)
    (hB : 1 ≤ B) (hx : ∀ n, 0 ≤ x n)
    (hc : ∃ n₀, ∀ n, n₀ ≤ n → c n ≤ 1 / 4)
    (hstep : ∀ n, x (n + 1) ≤ B / 4 + c n * (1 + x n)) :
    ∀ start, ∃ n, start ≤ n ∧ x n < B := by
  intro start
  obtain ⟨n₀, hn₀⟩ := hc
  let base := max n₀ start
  have hshift : ∀ n, x (base + (n + 1)) ≤
      B / 4 + c (base + n) * (1 + x (base + n)) := by
    intro n
    simpa only [Nat.add_assoc] using hstep (base + n)
  obtain ⟨n, hn⟩ := finite_waiting B (fun n => x (base + n))
    (fun n => c (base + n)) hB (fun n => hx (base + n))
    (fun n => hn₀ (base + n) (by dsimp [base]; omega)) hshift
  exact ⟨base + n, by dsimp [base]; omega, hn⟩

end ExactCorrectionAudit
