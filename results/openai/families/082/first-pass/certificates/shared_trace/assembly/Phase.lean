import Blocks

open scoped ComplexConjugate Matrix MatrixOrder ComplexOrder Matrix.Norms.L2Operator
open Matrix Finset WithLp

noncomputable section

namespace SharedTraceAssembly

variable {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
  [DecidableEq α] [DecidableEq β] [DecidableEq γ]

def phaseBlocks (z w : ℂ) (hz : ‖z‖ = 1) (hw : ‖w‖ = 1) :
    Matrix.unitaryGroup (β ⊕ γ) ℂ := by
  refine ⟨fromBlocks (z • (1 : Matrix β β ℂ)) 0 0 (w • (1 : Matrix γ γ ℂ)), ?_⟩
  apply Matrix.mem_unitaryGroup_iff.mpr
  have hzz : (starRingEnd ℂ) z * z = 1 := by
    simpa [hz, Complex.star_def] using Complex.conj_mul' z
  have hww : (starRingEnd ℂ) w * w = 1 := by
    simpa [hw, Complex.star_def] using Complex.conj_mul' w
  simp [Matrix.star_eq_conjTranspose, Matrix.fromBlocks_conjTranspose,
    Matrix.fromBlocks_multiply, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hzz, hww]

lemma fromCols_phase (A : Matrix α β ℂ) (B : Matrix α γ ℂ)
    (z w : ℂ) (hz : ‖z‖ = 1) (hw : ‖w‖ = 1) :
    fromCols A B * (phaseBlocks (β := β) (γ := γ) z w hz hw : Matrix (β ⊕ γ) (β ⊕ γ) ℂ) =
      fromCols (z • A) (w • B) := by
  simp [phaseBlocks, Matrix.fromCols_mul_fromBlocks, Matrix.mul_smul]

theorem rowCost_fromCols_phase (A : Matrix α β ℂ) (B : Matrix α γ ℂ)
    (D : Matrix α α ℂ) (z w : ℂ) (hz : ‖z‖ = 1) (hw : ‖w‖ = 1) :
    rowCost (fromCols (z • A) (w • B)) D = rowCost (fromCols A B) D := by
  rw [← fromCols_phase A B z w hz hw]
  exact rowCost_unitary (phaseBlocks z w hz hw) (fromCols A B) D

theorem exists_aligning_phase (t : ℂ) (ht : t ≠ 0) :
    ∃ z : ℂ, ‖z‖ = 1 ∧ z * t = (‖t‖ : ℂ) := by
  have hn : ‖t‖ ≠ 0 := norm_ne_zero_iff.mpr ht
  have hnc : (‖t‖ : ℂ) ≠ 0 := by exact_mod_cast hn
  refine ⟨star t / (‖t‖ : ℂ), ?_, ?_⟩
  · simp [norm_div, norm_star, Complex.norm_real, abs_of_nonneg (norm_nonneg t), hn]
  · rw [div_mul_eq_mul_div]
    have h : star t * t = (‖t‖ : ℂ) ^ 2 := by
      simpa [Complex.star_def, Complex.ofReal_pow] using Complex.conj_mul' t
    rw [h]
    field_simp

end SharedTraceAssembly
