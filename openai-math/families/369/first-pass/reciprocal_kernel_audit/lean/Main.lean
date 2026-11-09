import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Tactic

noncomputable section

open scoped BigOperators Topology
open Filter Matrix

namespace ReciprocalKernel

variable {ι : Type*} [Fintype ι]

theorem psd_abs_entry_lt {U : Matrix ι ι ℝ} (hU : U.PosSemidef)
    {a : ℝ} (hd : ∀ i, U i i < a) (i j : ι) : |U i j| < a := by
  classical
  have hs : U j i = U i j := by simpa using hU.isHermitian.apply i j
  have hp := hU.2 (Finsupp.single i 1 + Finsupp.single j 1)
  have hm := hU.2 (Finsupp.single i 1 + Finsupp.single j (-1))
  simp [Finsupp.sum_add_index, Finsupp.sum_neg_index, add_mul, mul_add, hs] at hp hm
  exact abs_lt.mpr ⟨by linarith [hd i, hd j], by linarith [hd i, hd j]⟩

theorem psd_entrywise_power {U : Matrix ι ι ℝ} (hU : U.PosSemidef)
    (n : ℕ) : Matrix.PosSemidef (fun i j => U i j ^ (n + 1)) := by
  induction n with
  | zero => simpa using hU
  | succ n ih =>
      convert! ih.hadamard hU using 1 <;> ext i j <;>
        simp [Matrix.hadamard_apply, pow_succ, Nat.add_assoc]

theorem psd_of_entrywise_limit {A : ℕ → Matrix ι ι ℝ} {B : Matrix ι ι ℝ}
    (hA : ∀ n, (A n).PosSemidef) (hB : B.IsHermitian)
    (hlim : ∀ i j, Tendsto (fun n => A n i j) atTop (𝓝 (B i j))) :
    B.PosSemidef := by
  classical
  apply Matrix.PosSemidef.of_dotProduct_mulVec_nonneg hB
  intro x
  have ht : Tendsto (fun n => star x ⬝ᵥ (A n *ᵥ x)) atTop
      (𝓝 (star x ⬝ᵥ (B *ᵥ x))) := by
    change Tendsto (fun n => ∑ i, star (x i) * (∑ j, A n i j * x j)) atTop
      (𝓝 (∑ i, star (x i) * (∑ j, B i j * x j)))
    apply tendsto_finsetSum
    intro i hi
    apply tendsto_const_nhds.mul
    apply tendsto_finsetSum
    intro j hj
    exact (hlim i j).mul_const (x j)
  exact le_of_tendsto_of_tendsto tendsto_const_nhds ht (Filter.Eventually.of_forall fun n =>
    (hA n).dotProduct_mulVec_nonneg x)

theorem scalar_schur_series {a c u : ℝ} (ha : 0 < a) (hc : 0 ≤ c)
    (hu : |u| < a) :
    HasSum (fun n : ℕ => c ^ n / (1 + c * a) ^ (n + 2) * u ^ (n + 1))
      (u / ((1 + c * a) * (1 + c * a - c * u))) := by
  let α := 1 + c * a
  have hα : 0 < α := by dsimp [α]; positivity
  have hcu : c * u ≤ c * a :=
    mul_le_mul_of_nonneg_left ((le_abs_self u).trans hu.le) hc
  have hden : 0 < α - c * u := by dsimp [α]; linarith
  have hr : |c / α * u| < 1 := by
    rw [abs_mul, abs_div, abs_of_nonneg hc, abs_of_pos hα, div_mul_eq_mul_div]
    apply (div_lt_iff₀ hα).2
    have := mul_le_mul_of_nonneg_left hu.le hc
    dsimp [α]
    linarith
  have hsum := HasSum.mul_left (u / α ^ 2)
    (hasSum_geometric_of_abs_lt_one hr)
  have hα0 : α ≠ 0 := ne_of_gt hα
  have hden0 : α - c * u ≠ 0 := ne_of_gt hden
  have hr0 : 1 - c / α * u ≠ 0 := by
    intro he
    apply hden0
    field_simp [hα0] at he
    linarith
  change HasSum (fun n : ℕ => c ^ n / α ^ (n + 2) * u ^ (n + 1))
    (u / (α * (α - c * u)))
  convert! hsum using 1
  · funext n
    simp only [mul_pow, div_pow, pow_succ]
    field_simp [hα0]
  · field_simp [hα0, hden0, hr0]

theorem schur_resolvent_psd {U : Matrix ι ι ℝ} (hU : U.PosSemidef)
    {a c : ℝ} (ha : 0 < a) (hc : 0 ≤ c) (hd : ∀ i, U i i < a) :
    Matrix.PosSemidef
      (fun i j => U i j / ((1 + c * a) * (1 + c * a - c * U i j))) := by
  classical
  let A : ℕ → Matrix ι ι ℝ :=
    fun n => (c ^ n / (1 + c * a) ^ (n + 2)) • (fun i j => U i j ^ (n + 1))
  have hA (n : ℕ) : (A n).PosSemidef := by
    apply (psd_entrywise_power hU n).smul
    positivity
  have hpartial (N : ℕ) : (∑ n ∈ Finset.range N, A n).PosSemidef :=
    Matrix.posSemidef_sum _ (fun n hn => hA n)
  apply psd_of_entrywise_limit hpartial
  · apply Matrix.IsHermitian.ext
    intro i j
    have hs : U j i = U i j := by simpa using hU.isHermitian.apply i j
    simp [hs]
  · intro i j
    simpa [A, Matrix.sum_apply, Matrix.smul_apply] using
      (scalar_schur_series ha hc (psd_abs_entry_lt hU hd i j)).tendsto_sum_nat

theorem update_defect_identity {a c u : ℝ} (ha : 0 < a) (hc : 0 ≤ c)
    (hu : |u| < a) :
    a / (1 + c * a) - (a - u) / (1 + c * (a - u)) =
      u / ((1 + c * a) * (1 + c * a - c * u)) := by
  have h1 : 0 < 1 + c * a := by positivity
  have h2 : 0 < 1 + c * (a - u) := by
    have : 0 < a - u := by linarith [le_abs_self u]
    positivity
  have he : 1 + c * a - c * u = 1 + c * (a - u) := by ring
  rw [he]
  field_simp [ne_of_gt h1, ne_of_gt h2]
  <;> ring

theorem normalized_column_update_psd {H : Matrix ι ι ℝ} {a c : ℝ}
    (ha : 0 < a) (hc : 0 ≤ c)
    (hU : Matrix.PosSemidef (fun i j => a - H i j)) (hd : ∀ i, 0 < H i i) :
    Matrix.PosSemidef (fun i j => a / (1 + c * a) - H i j / (1 + c * H i j)) := by
  have hdiag : ∀ i, a - H i i < a := by intro i; linarith [hd i]
  convert! schur_resolvent_psd hU ha hc hdiag using 1
  ext i j
  have hu := psd_abs_entry_lt hU hdiag i j
  simpa only [sub_sub_cancel] using update_defect_identity ha hc hu

end ReciprocalKernel
