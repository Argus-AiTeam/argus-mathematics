import Mathlib

namespace PairResponse

def falling (x : ℝ) : ℕ → ℝ
  | 0 => 1
  | n + 1 => falling x n * (x - (n : ℝ))

def childSlots (a b k : ℝ) : ℕ → ℝ
  | 0 => 1
  | n + 1 => childSlots a b k n * (a - (k + (n : ℝ)) * b)

theorem real_power_factor (a b k n : ℝ) (hb : b ≠ 0) :
    b * (a / b - k - n) = a - (k + n) * b := by
  field_simp [hb]
  <;> ring

theorem real_power_slots (a b k : ℝ) (hb : b ≠ 0) (n : ℕ) :
    b ^ n * falling (a / b - k) n = childSlots a b k n := by
  induction n with
  | zero => simp [falling, childSlots]
  | succ n ih =>
      simp only [falling, childSlots, pow_succ]
      calc
        b ^ n * b * (falling (a / b - k) n * (a / b - k - (n : ℝ))) =
            (b ^ n * falling (a / b - k) n) *
              (b * (a / b - k - (n : ℝ))) := by ring
        _ = childSlots a b k n * (a - (k + (n : ℝ)) * b) := by
          rw [ih, real_power_factor a b k (n : ℝ) hb]

def prefixCurvature (p F u c cz czz jz jzz S Qpast : ℝ) : ℝ :=
  let H := p * F * u - S
  F ^ 2 * (czz + 2 * p * c ^ 2 + 4 * p * u * cz + 4 * p ^ 2 * u ^ 2 * c)
    + 2 * F * jzz + 4 * p * F * u * jz
    + 2 * F * (-F * (czz + 2 * p * c ^ 2 + 2 * p * u * cz) - jzz)
    + 2 * H * (-F * (cz + 2 * p * u * c) - jz)
    + F ^ 2 * czz + 2 * F * H * cz
    + (H ^ 2 + p * F ^ 2 * c - Qpast) * c

theorem colored_prefix_cancellation (p F u c cz czz jz jzz S Qpast : ℝ) :
    prefixCurvature p F u c cz czz jz jzz S Qpast =
      -p * F ^ 2 * c ^ 2 - Qpast * c
        + (p * F * u + S) ^ 2 * c + 2 * (p * F * u + S) * jz := by
  unfold prefixCurvature
  ring

theorem one_sheet_constant (p q r : ℝ) :
    (1 - q ^ 2) + 2 * (p - 2) * (q - q ^ 2)
        + (p - 2) * (p - 3) * (r - q ^ 2) / 2 =
      (1 - 2 * q + r) - 2 * (1 - p) * (q - r + p * (r - q ^ 2) / 4) := by
  ring

theorem one_sheet_additive (p q r : ℝ) :
    (1 - q ^ 2) + (p - 4) * (q - q ^ 2) - (p - 3) * (r - q ^ 2) =
      (1 - 2 * q + r) - (2 - p) * (q - r) := by
  ring

theorem child_mixed_difference (a a' c c' : ℝ) :
    a * c - a' * c - a * c' + a' * c' = (a - a') * (c - c') := by
  ring

theorem gram_energy_nonneg
    {ι Ω Λ : Type*} [Fintype ι]
    (E : (Ω → ℝ) → ℝ) (I : (Λ → ℝ) → ℝ)
    (hE : ∀ g : Ω → ℝ, (∀ ω, 0 ≤ g ω) → 0 ≤ E g)
    (hI : ∀ g : Λ → ℝ, (∀ s, 0 ≤ g s) → 0 ≤ I g)
    (weight : Ω → ℝ) (alpha : Λ → ℝ)
    (m : ι → Ω → ℝ) (v : ι → Λ → Ω → ℝ) (f : ι → ℝ)
    (hw : ∀ ω, 0 ≤ weight ω) (ha : ∀ s, 0 ≤ alpha s) :
    0 ≤ E (fun ω => weight ω * (∑ r, f r * m r ω) ^ 2) +
      I (fun s => alpha s * E (fun ω => (∑ r, f r * v r s ω) ^ 2)) := by
  apply add_nonneg
  · apply hE
    intro ω
    exact mul_nonneg (hw ω) (sq_nonneg _)
  · apply hI
    intro s
    apply mul_nonneg (ha s)
    apply hE
    intro ω
    exact sq_nonneg _

theorem gram_decrement_nonneg
    {ι Ω Λ : Type*} [Fintype ι]
    (E : (Ω → ℝ) → ℝ) (I : (Λ → ℝ) → ℝ)
    (hE : ∀ g : Ω → ℝ, (∀ ω, 0 ≤ g ω) → 0 ≤ E g)
    (hI : ∀ g : Λ → ℝ, (∀ s, 0 ≤ g s) → 0 ≤ I g)
    (alpha : Λ → ℝ) (v : ι → Λ → Ω → ℝ) (f : ι → ℝ)
    (ha : ∀ s, 0 ≤ alpha s) :
    0 ≤ I (fun s => alpha s * E (fun ω => (∑ r, f r * v r s ω) ^ 2)) := by
  apply hI
  intro s
  apply mul_nonneg (ha s)
  apply hE
  intro ω
  exact sq_nonneg _

end PairResponse
