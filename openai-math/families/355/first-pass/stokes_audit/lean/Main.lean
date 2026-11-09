import Mathlib

open scoped BigOperators

noncomputable section

namespace TranslatorStokes

def positiveCompositions (n k : ℕ) : Finset (Fin k → Fin (n + 1)) :=
  Finset.univ.filter fun f =>
    (∀ i, 0 < (f i).val) ∧ ∑ i, (f i).val = n

def compositionCoefficient (b : ℕ → ℝ) (n k : ℕ) : ℝ :=
  ∑ f ∈ positiveCompositions n k, ∏ i, b (f i).val

def weight (m : ℝ) (n k : ℕ) : ℝ :=
  2 * (n : ℝ) - m * (k : ℝ) + 1

def HasRecurrence (m : ℝ) (b : ℕ → ℝ) : Prop :=
  b 0 = 0 ∧ b 1 = 1 ∧
    ∀ n, 1 ≤ n →
      b (n + 1) =
        ∑ k ∈ Finset.Icc 1 n, weight m n k * compositionCoefficient b n k

theorem compositionCoefficient_one (b : ℕ → ℝ) {n : ℕ} (hn : 1 ≤ n) :
    compositionCoefficient b n 1 = b n := by
  classical
  let f₀ : Fin 1 → Fin (n + 1) := fun _ => ⟨n, Nat.lt_succ_self n⟩
  have hf₀ : f₀ ∈ positiveCompositions n 1 := by
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _, ?_, ?_⟩
    · intro i
      change 0 < n
      omega
    · simp [f₀]
  have hsingle : positiveCompositions n 1 = {f₀} := by
    ext f
    simp only [Finset.mem_singleton]
    constructor
    · intro hf
      have hs := (Finset.mem_filter.mp hf).2.2
      have hv : (f 0).val = n := by
        simpa only [Fin.sum_univ_one] using hs
      funext i
      apply Fin.ext
      have hi : i = 0 := Fin.eq_zero i
      simpa [f₀, hi] using hv
    · rintro rfl
      exact hf₀
  rw [compositionCoefficient, hsingle]
  simp [f₀]

theorem weight_ge_one {m : ℝ} (hm : m ≤ 2) {n k : ℕ} (hk : k ≤ n) :
    1 ≤ weight m n k := by
  have hk' : (k : ℝ) ≤ (n : ℝ) := by exact_mod_cast hk
  have hmk : m * (k : ℝ) ≤ 2 * (k : ℝ) :=
    mul_le_mul_of_nonneg_right hm (Nat.cast_nonneg k)
  unfold weight
  linarith

theorem compositionCoefficient_nonneg (b : ℕ → ℝ) (n k : ℕ)
    (hb : ∀ j, j ≤ n → 0 ≤ b j) :
    0 ≤ compositionCoefficient b n k := by
  classical
  apply Finset.sum_nonneg
  intro f hf
  apply Finset.prod_nonneg
  intro i hi
  exact hb (f i).val (Nat.le_of_lt_succ (f i).isLt)

theorem recurrence_nonneg {m : ℝ} {b : ℕ → ℝ}
    (hm : m ≤ 2) (hb : HasRecurrence m b) (n : ℕ) :
    0 ≤ b n := by
  classical
  rcases hb with ⟨hb₀, hb₁, hr⟩
  induction n using Nat.strong_induction_on with
  | h n ih =>
    rcases n with _ | n
    · norm_num [hb₀]
    rcases n with _ | n
    · rw [hb₁]
      norm_num
    rw [hr (n + 1) (by omega)]
    apply Finset.sum_nonneg
    intro k hk
    apply mul_nonneg
    · exact le_trans (by norm_num) (weight_ge_one hm (Finset.mem_Icc.mp hk).2)
    · apply compositionCoefficient_nonneg
      intro j hj
      exact ih j (by omega)

theorem recurrence_leading_lower {m : ℝ} {b : ℕ → ℝ}
    (hm : m ≤ 2) (hb : HasRecurrence m b) {n : ℕ} (hn : 1 ≤ n) :
    (2 * (n : ℝ) - m + 1) * b n ≤ b (n + 1) := by
  classical
  have hnonneg : ∀ j, 0 ≤ b j := recurrence_nonneg hm hb
  have hterm : ∀ k ∈ Finset.Icc 1 n,
      0 ≤ weight m n k * compositionCoefficient b n k := by
    intro k hk
    apply mul_nonneg
    · exact le_trans (by norm_num) (weight_ge_one hm (Finset.mem_Icc.mp hk).2)
    · exact compositionCoefficient_nonneg b n k (fun j _ => hnonneg j)
  have hmem : 1 ∈ Finset.Icc 1 n := Finset.mem_Icc.mpr ⟨le_rfl, hn⟩
  have hs := Finset.single_le_sum hterm hmem
  rw [compositionCoefficient_one b hn] at hs
  simpa [weight, hb.2.2 n hn] using hs

theorem recurrence_lower {m : ℝ} {b : ℕ → ℝ}
    (hm : m ≤ 2) (hb : HasRecurrence m b) {n : ℕ} (hn : 1 ≤ n) :
    (2 * (n : ℝ) - 1) * b n ≤ b (n + 1) := by
  have hw : 2 * (n : ℝ) - 1 ≤ 2 * (n : ℝ) - m + 1 := by linarith
  exact le_trans
    (mul_le_mul_of_nonneg_right hw (recurrence_nonneg hm hb n))
    (recurrence_leading_lower hm hb hn)

theorem recurrence_factorial_lower {m : ℝ} {b : ℕ → ℝ}
    (hm : m ≤ 2) (hb : HasRecurrence m b) (n : ℕ) :
    (2 : ℝ) ^ n * (n.factorial : ℝ) ≤ ((n + 1 : ℕ) : ℝ) * b (n + 1) := by
  induction n with
  | zero =>
    norm_num [hb.2.1]
  | succ n ih =>
    have hs := recurrence_lower hm hb (n := n + 1) (by omega)
    have hmul := mul_le_mul_of_nonneg_left hs
      (show 0 ≤ ((n + 2 : ℕ) : ℝ) by positivity)
    have hscale := mul_le_mul_of_nonneg_left ih
      (show 0 ≤ 2 * ((n + 1 : ℕ) : ℝ) by positivity)
    have hnb : 0 ≤ (n : ℝ) * b (n + 1) :=
      mul_nonneg (Nat.cast_nonneg n) (recurrence_nonneg hm hb (n + 1))
    calc
      (2 : ℝ) ^ (n + 1) * ((n + 1).factorial : ℝ)
          = 2 * ((n + 1 : ℕ) : ℝ) *
              ((2 : ℝ) ^ n * (n.factorial : ℝ)) := by
            rw [Nat.factorial_succ, pow_succ]
            push_cast
            ring
      _ ≤ 2 * ((n + 1 : ℕ) : ℝ) *
            (((n + 1 : ℕ) : ℝ) * b (n + 1)) := hscale
      _ ≤ ((n + 2 : ℕ) : ℝ) *
            ((2 * ((n + 1 : ℕ) : ℝ) - 1) * b (n + 1)) := by
          push_cast
          nlinarith [hnb]
      _ ≤ ((n + 2 : ℕ) : ℝ) * b (n + 2) := hmul

theorem surface_factorial_lower {b : ℕ → ℝ}
    (hb : HasRecurrence 1 b) (n : ℕ) :
    (2 : ℝ) ^ n * (n.factorial : ℝ) ≤ b (n + 1) := by
  induction n with
  | zero => norm_num [hb.2.1]
  | succ n ih =>
    have hs := recurrence_leading_lower (by norm_num : (1 : ℝ) ≤ 2) hb
      (n := n + 1) (by omega)
    have hi := mul_le_mul_of_nonneg_left ih
      (show 0 ≤ 2 * ((n + 1 : ℕ) : ℝ) by positivity)
    calc
      (2 : ℝ) ^ (n + 1) * ((n + 1).factorial : ℝ)
          = 2 * ((n + 1 : ℕ) : ℝ) *
              ((2 : ℝ) ^ n * (n.factorial : ℝ)) := by
            rw [Nat.factorial_succ, pow_succ]
            push_cast
            ring
      _ ≤ 2 * ((n + 1 : ℕ) : ℝ) * b (n + 1) := hi
      _ ≤ b (n + 2) := by simpa using hs

theorem q_defect_identity (m q x d : ℝ) :
    (1 - q) ^ 2 * (q - x) - x * (2 * d - (m - 1) * q - q ^ 2) =
      q * (1 - q) ^ 2 - x * (1 - (m + 1) * q + 2 * d) := by
  ring

def translatorRHS (m y l : ℝ) : ℝ :=
  (1 + l ^ 2) * (1 - m * l / y)

theorem translator_q_identity (m y q d : ℝ) (hm : m ≠ 0) (hy : y ≠ 0) :
    m ^ 2 / y ^ 2 *
        ((1 - q) / m - y ^ 2 / m ^ 2 * d -
          translatorRHS m y (y / m * (1 - q))) +
      (d + q - 2 * q ^ 2 + q ^ 3 -
        m / y ^ 2 * (1 - (m + 1) * q)) = 0 := by
  unfold translatorRHS
  field_simp [hm, hy]
  ring

theorem slope_difference_identity (m y u v : ℝ) :
    translatorRHS m y u - translatorRHS m y v =
      (u + v - m / y - m / y * (u ^ 2 + u * v + v ^ 2)) * (u - v) := by
  unfold translatorRHS
  ring

theorem momentum_residual_identity (m y l : ℝ) :
    (m * l / y + l ^ 2) * (1 + l ^ 2) +
        translatorRHS m y l - (1 + l ^ 2) ^ 2 = 0 := by
  unfold translatorRHS
  ring

theorem finite_scale_momentum_identity (m y l h ε : ℝ) :
    (m * l / y + l ^ 2 - 2 * ε * h * l ^ 2 - 2 * ε * y * l) *
        (1 + l ^ 2) +
      (1 + l ^ 2) * (1 + 2 * ε * (y * l - h) - m * l / y) -
        (1 - 2 * ε * h) * (1 + l ^ 2) ^ 2 = 0 := by
  ring

end TranslatorStokes

#print axioms TranslatorStokes.recurrence_factorial_lower
#print axioms TranslatorStokes.surface_factorial_lower
#print axioms TranslatorStokes.translator_q_identity
