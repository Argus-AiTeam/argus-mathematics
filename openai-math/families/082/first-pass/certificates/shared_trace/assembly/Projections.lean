import Blocks

open scoped ComplexConjugate Matrix MatrixOrder ComplexOrder
open Matrix

noncomputable section

namespace SharedTraceAssembly

variable {ι κ ν : Type*} [Fintype ι] [Fintype κ] [Fintype ν]
  [DecidableEq ι] [DecidableEq κ] [DecidableEq ν]

def projection0 : Matrix (Total ι κ ν) (Total ι κ ν) ℂ :=
  blockD (1 : Matrix ι ι ℂ) (0 : Matrix κ κ ℂ) (0 : Matrix ν ν ℂ)

def projection1 : Matrix (Total ι κ ν) (Total ι κ ν) ℂ :=
  blockD (0 : Matrix ι ι ℂ) (1 : Matrix κ κ ℂ) (0 : Matrix ν ν ℂ)

def projection2 : Matrix (Total ι κ ν) (Total ι κ ν) ℂ :=
  blockD (0 : Matrix ι ι ℂ) (0 : Matrix κ κ ℂ) (1 : Matrix ν ν ℂ)

lemma projection0_hermitian : (projection0 (ι := ι) (κ := κ) (ν := ν)).IsHermitian := by
  change (projection0 (ι := ι) (κ := κ) (ν := ν))ᴴ = _
  simp [projection0, blockD, Matrix.fromBlocks_conjTranspose]

lemma projection1_hermitian : (projection1 (ι := ι) (κ := κ) (ν := ν)).IsHermitian := by
  change (projection1 (ι := ι) (κ := κ) (ν := ν))ᴴ = _
  simp [projection1, blockD, Matrix.fromBlocks_conjTranspose]

lemma projection2_hermitian : (projection2 (ι := ι) (κ := κ) (ν := ν)).IsHermitian := by
  change (projection2 (ι := ι) (κ := κ) (ν := ν))ᴴ = _
  simp [projection2, blockD, Matrix.fromBlocks_conjTranspose]

lemma projection0_idempotent :
    projection0 (ι := ι) (κ := κ) (ν := ν) * projection0 (ι := ι) (κ := κ) (ν := ν) =
      projection0 (ι := ι) (κ := κ) (ν := ν) := by
  simp [projection0, blockD, Matrix.fromBlocks_multiply]

lemma projection1_idempotent :
    projection1 (ι := ι) (κ := κ) (ν := ν) * projection1 (ι := ι) (κ := κ) (ν := ν) =
      projection1 (ι := ι) (κ := κ) (ν := ν) := by
  simp [projection1, blockD, Matrix.fromBlocks_multiply]

lemma projection2_idempotent :
    projection2 (ι := ι) (κ := κ) (ν := ν) * projection2 (ι := ι) (κ := κ) (ν := ν) =
      projection2 (ι := ι) (κ := κ) (ν := ν) := by
  simp [projection2, blockD, Matrix.fromBlocks_multiply]

lemma projection_sum :
    projection0 (ι := ι) (κ := κ) (ν := ν) + projection1 (ι := ι) (κ := κ) (ν := ν) +
      projection2 (ι := ι) (κ := κ) (ν := ν) = 1 := by
  ext i j
  rcases i with i | i <;> rcases j with j | j
  · simp [projection0, projection1, projection2, blockD, Matrix.one_apply]
  · rcases j with j | j <;> simp [projection0, projection1, projection2, blockD, Matrix.one_apply]
  · rcases i with i | i <;> simp [projection0, projection1, projection2, blockD, Matrix.one_apply]
  · rcases i with i | i <;> rcases j with j | j <;>
      simp [projection0, projection1, projection2, blockD, Matrix.one_apply]

lemma projection0_row (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    projection0 * triangle W0 W1 W2 = fromRows (row0 W0 W2) 0 := by
  simp [projection0, blockD, triangle, Matrix.fromBlocks_mul_fromRows]

lemma projection1_row (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    projection1 * triangle W0 W1 W2 = fromRows 0 (fromRows (row1 W0 W1) 0) := by
  simp [projection1, blockD, triangle, Matrix.fromBlocks_mul_fromRows]

lemma projection2_row (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    projection2 * triangle W0 W1 W2 = fromRows 0 (fromRows 0 (row2 W1 W2)) := by
  simp [projection2, blockD, triangle, Matrix.fromBlocks_mul_fromRows]

lemma projection0_commutes (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    projection0 * blockD D0 D1 D2 = blockD D0 D1 D2 * projection0 := by
  simp [projection0, blockD, Matrix.fromBlocks_multiply]

lemma projection1_commutes (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    projection1 * blockD D0 D1 D2 = blockD D0 D1 D2 * projection1 := by
  simp [projection1, blockD, Matrix.fromBlocks_multiply]

lemma projection2_commutes (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    projection2 * blockD D0 D1 D2 = blockD D0 D1 D2 * projection2 := by
  simp [projection2, blockD, Matrix.fromBlocks_multiply]

lemma projection0_gram (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    triangle W0 W1 W2 * projection0 * triangle W0 W1 W2 =
      (row0 W0 W2)ᴴ * row0 W0 W2 := by
  have h := SharedTraceHessian.vertex_gram (triangle_hermitian W0 W1 W2)
    (projection0_hermitian (ι := ι) (κ := κ) (ν := ν)) projection0_idempotent
  rw [projection0_row] at h
  simpa [Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromRows] using h.symm

lemma projection1_gram (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    triangle W0 W1 W2 * projection1 * triangle W0 W1 W2 =
      (row1 W0 W1)ᴴ * row1 W0 W1 := by
  have h := SharedTraceHessian.vertex_gram (triangle_hermitian W0 W1 W2)
    (projection1_hermitian (ι := ι) (κ := κ) (ν := ν)) projection1_idempotent
  rw [projection1_row] at h
  simpa [Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromRows] using h.symm

lemma projection2_gram (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    triangle W0 W1 W2 * projection2 * triangle W0 W1 W2 =
      (row2 W1 W2)ᴴ * row2 W1 W2 := by
  have h := SharedTraceHessian.vertex_gram (triangle_hermitian W0 W1 W2)
    (projection2_hermitian (ι := ι) (κ := κ) (ν := ν)) projection2_idempotent
  rw [projection2_row] at h
  simpa [Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromRows] using h.symm

lemma projection0_direction (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ)
    (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    triangle W0 W1 W2 * projection0 * blockD D0 D1 D2 * triangle W0 W1 W2 =
      (row0 W0 W2)ᴴ * D0 * row0 W0 W2 := by
  have h := SharedTraceHessian.vertex_direction (triangle_hermitian W0 W1 W2)
    (projection0_hermitian (ι := ι) (κ := κ) (ν := ν)) projection0_idempotent
    (projection0_commutes D0 D1 D2)
  rw [projection0_row] at h
  simpa [blockD, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromBlocks, Matrix.fromCols_mul_fromRows] using h.symm

lemma projection1_direction (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ)
    (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    triangle W0 W1 W2 * projection1 * blockD D0 D1 D2 * triangle W0 W1 W2 =
      (row1 W0 W1)ᴴ * D1 * row1 W0 W1 := by
  have h := SharedTraceHessian.vertex_direction (triangle_hermitian W0 W1 W2)
    (projection1_hermitian (ι := ι) (κ := κ) (ν := ν)) projection1_idempotent
    (projection1_commutes D0 D1 D2)
  rw [projection1_row] at h
  simpa [blockD, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromBlocks, Matrix.fromCols_mul_fromRows] using h.symm

lemma projection2_direction (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ)
    (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    triangle W0 W1 W2 * projection2 * blockD D0 D1 D2 * triangle W0 W1 W2 =
      (row2 W1 W2)ᴴ * D2 * row2 W1 W2 := by
  have h := SharedTraceHessian.vertex_direction (triangle_hermitian W0 W1 W2)
    (projection2_hermitian (ι := ι) (κ := κ) (ν := ν)) projection2_idempotent
    (projection2_commutes D0 D1 D2)
  rw [projection2_row] at h
  simpa [blockD, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromBlocks, Matrix.fromCols_mul_fromRows] using h.symm

end SharedTraceAssembly
