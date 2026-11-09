import Mathlib

open Set

namespace CrossingMatching

theorem product_fixedPoint_of_finite
    {I : Type*} {K : I → Type*}
    [∀ i, TopologicalSpace (K i)] [∀ i, CompactSpace (K i)]
    [∀ i, T2Space (K i)]
    (Φ : (∀ i, K i) → (∀ i, K i)) (hΦ : Continuous Φ)
    (hfinite : ∀ s : Finset I, ∃ x, ∀ i ∈ s, Φ x i = x i) :
    ∃ x, Φ x = x := by
  classical
  let C : I → Set (∀ i, K i) := fun i => {x | Φ x i = x i}
  have hclosed : ∀ i, IsClosed (C i) := by
    intro i
    exact isClosed_eq ((continuous_apply i).comp hΦ) (continuous_apply i)
  have hnonempty : ∀ s : Finset I, (⋂ i ∈ s, C i).Nonempty := by
    intro s
    obtain ⟨x, hx⟩ := hfinite s
    refine ⟨x, ?_⟩
    simp only [mem_iInter]
    exact hx
  obtain ⟨x, hx⟩ := CompactSpace.iInter_nonempty hclosed hnonempty
  refine ⟨x, ?_⟩
  funext i
  exact mem_iInter.mp hx i

def clamp (x : ℝ) : ℝ := max (-1) (min 1 x)

theorem clamp_fixed_forces_zero
    (z d : ℝ) (hz : -1 ≤ z ∧ z ≤ 1)
    (hplus : z = 1 → 0 < d) (hminus : z = -1 → d < 0)
    (hfix : z = clamp (z - d)) : d = 0 := by
  unfold clamp at hfix
  have htop : z ≠ 1 := by
    intro he
    have hd := hplus he
    have ht : max (-1 : ℝ) (min 1 (z - d)) < 1 :=
      max_lt (by norm_num)
        (lt_of_le_of_lt (min_le_right _ _) (by linarith))
    linarith
  have hbot : z ≠ -1 := by
    intro he
    have hd := hminus he
    have ht : (-1 : ℝ) < min 1 (z - d) :=
      lt_min (by norm_num) (by linarith)
    have hb := lt_of_lt_of_le ht (le_max_right (-1 : ℝ) (min 1 (z - d)))
    linarith
  rcases le_total (z - d) 1 with h | h
  · rw [min_eq_right h] at hfix
    by_cases hm : -1 ≤ z - d
    · rw [max_eq_right hm] at hfix
      linarith
    · rw [max_eq_left (le_of_not_ge hm)] at hfix
      exact (hbot hfix).elim
  · rw [min_eq_left h] at hfix
    rw [show max (-1 : ℝ) 1 = 1 by norm_num] at hfix
    exact (htop hfix).elim

theorem normalized_line_iff
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (i : Fin n)
    (v w : Fin n → ℝ) (hw : w i = 1)
    (σ : ℝ) (hσ : σ = (A.mulVec v) i) (hσ0 : σ ≠ 0) :
    A.mulVec v = σ • w ↔
      ∀ h, h ≠ i → (A.mulVec v) h / σ = w h := by
  constructor
  · intro he h _
    have hh := congrFun he h
    simp only [Pi.smul_apply, smul_eq_mul] at hh
    apply (div_eq_iff hσ0).2
    simpa [mul_comm] using hh
  · intro he
    funext h
    by_cases hi : h = i
    · subst h
      simp [Pi.smul_apply, hw, hσ]
    · have hh := (div_eq_iff hσ0).1 (he h hi)
      simpa [Pi.smul_apply, smul_eq_mul, mul_comm] using hh

#print axioms product_fixedPoint_of_finite
#print axioms clamp_fixed_forces_zero
#print axioms normalized_line_iff

end CrossingMatching
