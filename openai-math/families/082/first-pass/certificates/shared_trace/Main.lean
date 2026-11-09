import SpectralCubic
import Hessian
import Trace
import Phase
import Projections

/-!
# Mixed trace estimate on three independently sized complex spaces

All operator norms below are explicitly norms of `Matrix.toEuclideanCLM`.
The supported Hessian is the actual `SharedTraceHessian.b`, including its singular
positive-spectrum convention. The assembly proves the arbitrary-spectrum cubic
estimate, the concrete rectangular zero-padding identifications, and the phase
invariance used to recover the full complex modulus.
-/

open scoped ComplexConjugate Matrix MatrixOrder ComplexOrder
open Matrix Finset

noncomputable section

namespace SharedTrace

open SharedTraceAssembly

variable {n0 n1 n2 : Type*} [Fintype n0] [Fintype n1] [Fintype n2]
  [DecidableEq n0] [DecidableEq n1] [DecidableEq n2]

lemma rowCost_supported_nonneg {α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β] (R : Matrix α β ℂ) (D : Matrix α α ℂ) :
    0 ≤ rowCost R D := by
  rw [rowCost_spectral_positive]
  apply mul_nonneg (by norm_num)
  apply Finset.sum_nonneg
  intro i hi
  apply Finset.sum_nonneg
  intro j hj
  exact div_nonneg (Complex.normSq_nonneg _)
    (add_nonneg (Real.sqrt_nonneg _) (Real.sqrt_nonneg _))

lemma energy_nonneg (W0 : Matrix n0 n1 ℂ) (W1 : Matrix n1 n2 ℂ)
    (W2 : Matrix n2 n0 ℂ) (D0 : Matrix n0 n0 ℂ) (D1 : Matrix n1 n1 ℂ)
    (D2 : Matrix n2 n2 ℂ) : 0 ≤ energy W0 W1 W2 D0 D1 D2 :=
  add_nonneg (add_nonneg (rowCost_supported_nonneg _ _) (rowCost_supported_nonneg _ _))
    (rowCost_supported_nonneg _ _)

omit [DecidableEq n0] [DecidableEq n1] [DecidableEq n2] in
lemma tau_phase (W0 : Matrix n0 n1 ℂ) (W1 : Matrix n1 n2 ℂ)
    (W2 : Matrix n2 n0 ℂ) (D0 : Matrix n0 n0 ℂ) (D1 : Matrix n1 n1 ℂ)
    (D2 : Matrix n2 n2 ℂ) (z : ℂ) :
    tau (z • W0) W1 W2 D0 D1 D2 = z * tau W0 W1 W2 D0 D1 D2 := by
  simp [tau, Matrix.mul_smul, Matrix.smul_mul, smul_eq_mul]

lemma energy_phase (W0 : Matrix n0 n1 ℂ) (W1 : Matrix n1 n2 ℂ)
    (W2 : Matrix n2 n0 ℂ) (D0 : Matrix n0 n0 ℂ) (D1 : Matrix n1 n1 ℂ)
    (D2 : Matrix n2 n2 ℂ) (z : ℂ) (hz : ‖z‖ = 1) :
    energy (z • W0) W1 W2 D0 D1 D2 = energy W0 W1 W2 D0 D1 D2 := by
  have h0 : rowCost (fromCols (z • W0) W2ᴴ) D0 =
      rowCost (fromCols W0 W2ᴴ) D0 := by
    simpa using rowCost_fromCols_phase W0 W2ᴴ D0 z 1 hz norm_one
  have h1 : rowCost (fromCols W1 (z • W0)ᴴ) D1 =
      rowCost (fromCols W1 W0ᴴ) D1 := by
    simpa [Matrix.conjTranspose_smul] using
      rowCost_fromCols_phase W1 W0ᴴ D1 1 (star z) norm_one (by simpa using hz)
  simp only [energy, h0, h1]

/-- The complete mixed trace estimate. No dimension equality, nonemptiness,
invertibility, sign, diagonal-coordinate, or phase hypothesis is imposed. -/
theorem mixed_trace_estimate
    (W0 : Matrix n0 n1 ℂ) (W1 : Matrix n1 n2 ℂ) (W2 : Matrix n2 n0 ℂ)
    (D0 : Matrix n0 n0 ℂ) (D1 : Matrix n1 n1 ℂ) (D2 : Matrix n2 n2 ℂ)
    (h0 : D0.IsHermitian) (h1 : D1.IsHermitian) (h2 : D2.IsHermitian) :
    let R0 := Matrix.fromCols W0 W2ᴴ
    let R1 := Matrix.fromCols W1 W0ᴴ
    let R2 := Matrix.fromCols W2 W1ᴴ
    ‖Matrix.trace (D0 * W0 * D1 * W1 * D2 * W2)‖ ≤
      (5 / 3 : ℝ) *
        max ‖Matrix.toEuclideanCLM (n := n0) (𝕜 := ℂ) D0‖
          (max ‖Matrix.toEuclideanCLM (n := n1) (𝕜 := ℂ) D1‖
            ‖Matrix.toEuclideanCLM (n := n2) (𝕜 := ℂ) D2‖) *
        (SharedTraceHessian.b (Matrix.posSemidef_conjTranspose_mul_self R0) (R0ᴴ * D0 * R0) +
          SharedTraceHessian.b (Matrix.posSemidef_conjTranspose_mul_self R1) (R1ᴴ * D1 * R1) +
          SharedTraceHessian.b (Matrix.posSemidef_conjTranspose_mul_self R2) (R2ᴴ * D2 * R2)) := by
  change ‖tau W0 W1 W2 D0 D1 D2‖ ≤
    (5 / 3 : ℝ) * Dstar D0 D1 D2 * energy W0 W1 W2 D0 D1 D2
  by_cases ht : tau W0 W1 W2 D0 D1 D2 = 0
  · rw [ht, norm_zero]
    have hd : 0 ≤ Dstar D0 D1 D2 :=
      (norm_nonneg (Matrix.toEuclideanCLM (n := n0) (𝕜 := ℂ) D0)).trans (le_max_left _ _)
    exact mul_nonneg (mul_nonneg (by norm_num) hd) (energy_nonneg W0 W1 W2 D0 D1 D2)
  · obtain ⟨z, hz, hzt⟩ := exists_aligning_phase (tau W0 W1 W2 D0 D1 D2) ht
    have h := real_trace_bound (z • W0) W1 W2 D0 D1 D2 h0 h1 h2
    rw [energy_phase W0 W1 W2 D0 D1 D2 z hz, tau_phase, hzt, Complex.ofReal_re] at h
    exact h

end SharedTrace

#check SharedTrace.mixed_trace_estimate
#print axioms SharedTrace.mixed_trace_estimate
