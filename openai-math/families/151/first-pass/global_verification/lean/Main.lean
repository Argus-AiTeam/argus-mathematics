import Mathlib

noncomputable section

open scoped BigOperators

namespace GlobalSpectralBridge

variable {ι : Type*}

def combine (u v : ι → ℝ) : ι → ℂ :=
  fun i => (u i : ℂ) + (v i : ℂ) * Complex.I

def complexMatrix (A : Matrix ι ι ℝ) : Matrix ι ι ℂ :=
  fun i j => (A i j : ℂ)

lemma combine_injective {u v u' v' : ι → ℝ} :
    combine u v = combine u' v' ↔ u = u' ∧ v = v' := by
  constructor
  · intro h
    constructor
    · have h' := congrArg (fun w : ι → ℂ => fun i => (w i).re) h
      simpa [combine] using h'
    · have h' := congrArg (fun w : ι → ℂ => fun i => (w i).im) h
      simpa [combine] using h'
  · rintro ⟨rfl, rfl⟩
    rfl

lemma combine_ne_zero (u v : ι → ℝ) :
    combine u v ≠ 0 ↔ u ≠ 0 ∨ v ≠ 0 := by
  have hz : combine (0 : ι → ℝ) 0 = 0 := by
    ext i
    simp [combine]
  simp only [ne_eq, ← hz, combine_injective]
  tauto

lemma mulVec_combine [Fintype ι] (A : Matrix ι ι ℝ) (u v : ι → ℝ) :
    (complexMatrix A).mulVec (combine u v) =
      combine (A.mulVec u) (A.mulVec v) := by
  funext i
  apply Complex.ext <;>
    simp [Matrix.mulVec, dotProduct, complexMatrix, combine,
      Complex.mul_re, Complex.mul_im]

lemma mul_combine (a b : ℝ) (u v : ι → ℝ) :
    (fun i => ((a : ℂ) + (b : ℂ) * Complex.I) * combine u v i) =
      combine (fun i => a * u i - b * v i)
        (fun i => b * u i + a * v i) := by
  funext i
  apply Complex.ext <;> simp [combine, Complex.mul_re, Complex.mul_im] <;> ring

theorem real_pair_iff_complex_eigen [Fintype ι]
    (A : Matrix ι ι ℝ) (a b : ℝ) (u v : ι → ℝ) :
    ((u ≠ 0 ∨ v ≠ 0) ∧
      A.mulVec u = (fun i => a * u i - b * v i) ∧
      A.mulVec v = (fun i => b * u i + a * v i)) ↔
    (combine u v ≠ 0 ∧
      (complexMatrix A).mulVec (combine u v) =
        (fun i => ((a : ℂ) + (b : ℂ) * Complex.I) * combine u v i)) := by
  rw [combine_ne_zero, mulVec_combine, mul_combine, combine_injective]

theorem paired_modulus (a b : ℝ) :
    ‖((a : ℂ) + (b : ℂ) * Complex.I)‖ = Real.sqrt (a ^ 2 + b ^ 2) := by
  rw [Complex.norm_def]
  simp [Complex.normSq_apply, pow_two]

end GlobalSpectralBridge

#print axioms GlobalSpectralBridge.real_pair_iff_complex_eigen
#print axioms GlobalSpectralBridge.paired_modulus
