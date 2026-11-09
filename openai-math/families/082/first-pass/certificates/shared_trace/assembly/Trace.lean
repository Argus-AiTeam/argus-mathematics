import Blocks

open scoped ComplexConjugate Matrix MatrixOrder ComplexOrder Matrix.Norms.L2Operator
open Matrix Finset WithLp

noncomputable section
set_option maxHeartbeats 400000

namespace SharedTraceAssembly

variable {ι κ ν : Type*} [Fintype ι] [Fintype κ] [Fintype ν]
  [DecidableEq ι] [DecidableEq κ] [DecidableEq ν]

def offDiag (A01 : Matrix ι κ ℂ) (A02 : Matrix ι ν ℂ)
    (A10 : Matrix κ ι ℂ) (A12 : Matrix κ ν ℂ)
    (A20 : Matrix ν ι ℂ) (A21 : Matrix ν κ ℂ) :
    Matrix (Total ι κ ν) (Total ι κ ν) ℂ :=
  fromRows (fromCols 0 (fromCols A01 A02))
    (fromRows (fromCols A10 (fromCols 0 A12)) (fromCols A20 (fromCols A21 0)))

lemma trace_mul_three (A : Matrix ι κ ℂ) (B : Matrix κ ν ℂ) (C : Matrix ν ι ℂ) :
    Matrix.trace (A * B * C) = ∑ i, ∑ j, ∑ k, A i j * B j k * C k i := by
  simp only [Matrix.trace, Matrix.diag, Matrix.mul_apply, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.sum_comm]

lemma offDiag_trace_cube (A01 : Matrix ι κ ℂ) (A02 : Matrix ι ν ℂ)
    (A10 : Matrix κ ι ℂ) (A12 : Matrix κ ν ℂ)
    (A20 : Matrix ν ι ℂ) (A21 : Matrix ν κ ℂ) :
    Matrix.trace ((offDiag A01 A02 A10 A12 A20 A21) ^ 3) =
      Matrix.trace (A01 * A12 * A20) + Matrix.trace (A02 * A21 * A10) +
      Matrix.trace (A10 * A02 * A21) + Matrix.trace (A12 * A20 * A01) +
      Matrix.trace (A20 * A01 * A12) + Matrix.trace (A21 * A10 * A02) := by
  rw [SharedTraceCubic.trace_cube_expand]
  simp [offDiag, Fintype.sum_sum_type, trace_mul_three, Finset.sum_add_distrib, add_assoc]
  abel

lemma offDiag_trace_cube_cycles (A01 : Matrix ι κ ℂ) (A02 : Matrix ι ν ℂ)
    (A10 : Matrix κ ι ℂ) (A12 : Matrix κ ν ℂ)
    (A20 : Matrix ν ι ℂ) (A21 : Matrix ν κ ℂ) :
    Matrix.trace ((offDiag A01 A02 A10 A12 A20 A21) ^ 3) =
      3 * Matrix.trace (A01 * A12 * A20) + 3 * Matrix.trace (A02 * A21 * A10) := by
  rw [offDiag_trace_cube]
  rw [Matrix.trace_mul_cycle A10 A02 A21, Matrix.trace_mul_cycle A21 A10 A02,
    Matrix.trace_mul_cycle A12 A20 A01, Matrix.trace_mul_cycle A20 A01 A12,
    Matrix.trace_mul_cycle A12 A20 A01]
  ring

lemma blockD_triangle (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ)
    (W2 : Matrix ν ι ℂ) (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ)
    (D2 : Matrix ν ν ℂ) :
    blockD D0 D1 D2 * triangle W0 W1 W2 =
      offDiag (D0 * W0) (D0 * W2ᴴ) (D1 * W0ᴴ) (D1 * W1)
        (D2 * W2) (D2 * W1ᴴ) := by
  simp [blockD, triangle, row0, row1, row2, offDiag, Matrix.fromBlocks_mul_fromRows,
    Matrix.mul_fromCols, Matrix.fromBlocks_multiply]

def tau (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ)
    (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) : ℂ :=
  Matrix.trace (D0 * W0 * D1 * W1 * D2 * W2)

theorem triangle_trace_cube (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ)
    (W2 : Matrix ν ι ℂ) (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ)
    (D2 : Matrix ν ν ℂ) (h0 : D0.IsHermitian) (h1 : D1.IsHermitian)
    (h2 : D2.IsHermitian) :
    Matrix.trace ((blockD D0 D1 D2 * triangle W0 W1 W2) ^ 3) =
      (6 : ℂ) * (tau W0 W1 W2 D0 D1 D2).re := by
  rw [blockD_triangle, offDiag_trace_cube_cycles]
  have hf : Matrix.trace (D0 * W0 * (D1 * W1) * (D2 * W2)) =
      tau W0 W1 W2 D0 D1 D2 := by simp only [tau, Matrix.mul_assoc]
  have hr : Matrix.trace (D0 * W2ᴴ * (D2 * W1ᴴ) * (D1 * W0ᴴ)) =
      star (tau W0 W1 W2 D0 D1 D2) := by
    rw [tau, ← Matrix.trace_conjTranspose]
    simp only [Matrix.conjTranspose_mul, h0.eq, h1.eq, h2.eq, Matrix.mul_assoc]
    rw [Matrix.trace_mul_comm D0]
    simp only [Matrix.mul_assoc]
  rw [hf, hr]
  have ht : tau W0 W1 W2 D0 D1 D2 + star (tau W0 W1 W2 D0 D1 D2) =
      (2 : ℂ) * (tau W0 W1 W2 D0 D1 D2).re := by
    apply Complex.ext <;> simp [Complex.star_def] <;> ring
  linear_combination 3 * ht

def energy (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ)
    (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) : ℝ :=
  rowCost (fromCols W0 W2ᴴ) D0 + rowCost (fromCols W1 W0ᴴ) D1 +
    rowCost (fromCols W2 W1ᴴ) D2

theorem real_trace_bound (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ)
    (W2 : Matrix ν ι ℂ) (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ)
    (D2 : Matrix ν ν ℂ) (h0 : D0.IsHermitian) (h1 : D1.IsHermitian)
    (h2 : D2.IsHermitian) :
    (tau W0 W1 W2 D0 D1 D2).re ≤
      (5 / 3 : ℝ) * Dstar D0 D1 D2 * energy W0 W1 W2 D0 D1 D2 := by
  let M := triangle W0 W1 W2
  let D := blockD D0 D1 D2
  have hM := triangle_hermitian W0 W1 W2
  have hD := blockD_hermitian D0 D1 D2 h0 h1 h2
  have hc := hermitian_cubic_rowCost M D hM hD
  have hcm := triangle_common_metric W0 W1 W2 D0 D1 D2
  have hnorm := blockD_norm_le D0 D1 D2
  have hb : 0 ≤ rowCost M D := rowCost_nonneg M D
  have hds : 0 ≤ Dstar D0 D1 D2 := le_trans (norm_nonneg _) (le_max_left _ _)
  have hle : (10 / 3 : ℝ) * ‖Matrix.toEuclideanCLM (n := Total ι κ ν) (𝕜 := ℂ) D‖ *
      rowCost M D ≤
      (10 / 3 : ℝ) * Dstar D0 D1 D2 * rowCost M D :=
    mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hnorm (by norm_num)) hb
  have hreal : (6 : ℝ) * (tau W0 W1 W2 D0 D1 D2).re ≤
      ‖Matrix.trace ((D * M) ^ 3)‖ := by
    rw [show Matrix.trace ((D * M) ^ 3) =
      (6 : ℂ) * (tau W0 W1 W2 D0 D1 D2).re from
      triangle_trace_cube W0 W1 W2 D0 D1 D2 h0 h1 h2]
    simpa using Complex.re_le_norm ((6 : ℂ) * (tau W0 W1 W2 D0 D1 D2).re)
  have hm := mul_le_mul_of_nonneg_left hcm hds
  change Dstar D0 D1 D2 * ((1 / 3 : ℝ) * rowCost M D) ≤
    Dstar D0 D1 D2 * energy W0 W1 W2 D0 D1 D2 at hm
  nlinarith

end SharedTraceAssembly
