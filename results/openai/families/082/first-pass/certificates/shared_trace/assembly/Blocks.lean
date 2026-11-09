import General

open scoped ComplexConjugate Matrix MatrixOrder ComplexOrder Matrix.Norms.L2Operator
open Matrix Finset WithLp

noncomputable section

namespace SharedTraceAssembly

variable {ι κ ν : Type*} [Fintype ι] [Fintype κ] [Fintype ν]
  [DecidableEq ι] [DecidableEq κ] [DecidableEq ν]

def rowCost {α β : Type*} [Fintype α] [Fintype β] [DecidableEq β]
    (R : Matrix α β ℂ) (D : Matrix α α ℂ) : ℝ :=
  SharedTraceHessian.b (Matrix.posSemidef_conjTranspose_mul_self R) (Rᴴ * D * R)

theorem rowCost_nonneg {α β : Type*} [Fintype α] [Fintype β] [DecidableEq β]
    (R : Matrix α β ℂ) (D : Matrix α α ℂ) : 0 ≤ rowCost R D :=
  SharedTraceHessian.b_nonneg _ _

theorem hermitian_cubic_rowCost {δ : Type*} [Fintype δ] [DecidableEq δ]
    (M D : Matrix δ δ ℂ) (hM : M.IsHermitian) (hD : D.IsHermitian) :
    ‖Matrix.trace ((D * M) ^ 3)‖ ≤
      (10 / 3 : ℝ) * ‖Matrix.toEuclideanCLM (n := δ) (𝕜 := ℂ) D‖ * rowCost M D := by
  have h := hermitian_cubic_bound M D hM hD
  simpa only [rowCost, hM.eq] using h

theorem rowCost_spectral_positive {α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β] (R : Matrix α β ℂ) (D : Matrix α α ℂ) :
    rowCost R D = (3 / 2 : ℝ) *
      ∑ i ∈ (univ.filter fun i =>
        0 < (Matrix.posSemidef_conjTranspose_mul_self R).1.eigenvalues i),
      ∑ j ∈ (univ.filter fun j =>
        0 < (Matrix.posSemidef_conjTranspose_mul_self R).1.eigenvalues j),
        Complex.normSq
          (SharedTraceHessian.coordinates (Matrix.posSemidef_conjTranspose_mul_self R)
            (Rᴴ * D * R) i j) /
          (Real.sqrt ((Matrix.posSemidef_conjTranspose_mul_self R).1.eigenvalues i) +
            Real.sqrt ((Matrix.posSemidef_conjTranspose_mul_self R).1.eigenvalues j)) :=
  SharedTraceHessian.b_spectral_positive _ (SharedTraceHessian.supported_gram R D)

theorem rowCost_isometry {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    (V : Matrix γ β ℂ) (hV : Vᴴ * V = 1)
    (R : Matrix α β ℂ) (D : Matrix α α ℂ) :
    rowCost (R * Vᴴ) D = rowCost R D := by
  have h := SharedTraceHessian.b_isometry V hV
    (Matrix.posSemidef_conjTranspose_mul_self R) (SharedTraceHessian.supported_gram R D)
  simpa only [rowCost, SharedTraceHessian.embed, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose, Matrix.mul_assoc] using h

theorem rowCost_unitary {α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β]
    (U : Matrix.unitaryGroup β ℂ) (R : Matrix α β ℂ) (D : Matrix α α ℂ) :
    rowCost (R * (U : Matrix β β ℂ)) D = rowCost R D := by
  have h := SharedTraceHessian.b_unitary (star U)
    (Matrix.posSemidef_conjTranspose_mul_self R) (SharedTraceHessian.supported_gram R D)
  simpa only [rowCost, SharedTraceHessian.rotate_eq, Unitary.coe_star,
    Matrix.star_eq_conjTranspose, Matrix.conjTranspose_conjTranspose,
    Matrix.conjTranspose_mul, Matrix.mul_assoc] using h

abbrev Total (ι κ ν : Type*) := ι ⊕ (κ ⊕ ν)

def row0 (W0 : Matrix ι κ ℂ) (W2 : Matrix ν ι ℂ) : Matrix ι (Total ι κ ν) ℂ :=
  fromCols 0 (fromCols W0 W2ᴴ)

def row1 (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) : Matrix κ (Total ι κ ν) ℂ :=
  fromCols W0ᴴ (fromCols 0 W1)

def row2 (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) : Matrix ν (Total ι κ ν) ℂ :=
  fromCols W2 (fromCols W1ᴴ 0)

def triangle (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    Matrix (Total ι κ ν) (Total ι κ ν) ℂ :=
  fromRows (row0 W0 W2) (fromRows (row1 W0 W1) (row2 W1 W2))

def blockD (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    Matrix (Total ι κ ν) (Total ι κ ν) ℂ :=
  fromBlocks D0 0 0 (fromBlocks D1 0 0 D2)

def inclusion0 : Matrix (Total ι κ ν) (κ ⊕ ν) ℂ := fromRows 0 1

def inclusion1 : Matrix (Total ι κ ν) (ν ⊕ ι) ℂ :=
  fromRows (fromCols 0 1) (fromRows 0 (fromCols 1 0))

def inclusion2 : Matrix (Total ι κ ν) (ι ⊕ κ) ℂ :=
  fromRows (fromCols 1 0) (fromRows (fromCols 0 1) 0)

lemma inclusion0_isometry : (inclusion0 (ι := ι) (κ := κ) (ν := ν))ᴴ *
    inclusion0 (ι := ι) (κ := κ) (ν := ν) = 1 := by
  simp [inclusion0, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromRows]

lemma inclusion1_isometry : (inclusion1 (ι := ι) (κ := κ) (ν := ν))ᴴ *
    inclusion1 (ι := ι) (κ := κ) (ν := ν) = 1 := by
  simp [inclusion1, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.conjTranspose_fromCols_eq_fromRows_conjTranspose, Matrix.fromCols_mul_fromRows,
    Matrix.fromRows_mul_fromCols]
  ext i j
  cases i <;> cases j <;> simp [Matrix.one_apply]

lemma inclusion2_isometry : (inclusion2 (ι := ι) (κ := κ) (ν := ν))ᴴ *
    inclusion2 (ι := ι) (κ := κ) (ν := ν) = 1 := by
  simp [inclusion2, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.conjTranspose_fromCols_eq_fromRows_conjTranspose, Matrix.fromCols_mul_fromRows,
    Matrix.fromRows_mul_fromCols]
  ext i j
  cases i <;> cases j <;> simp [Matrix.one_apply]

lemma row0_extension (W0 : Matrix ι κ ℂ) (W2 : Matrix ν ι ℂ) :
    fromCols W0 W2ᴴ * (inclusion0 (ι := ι) (κ := κ) (ν := ν))ᴴ = row0 W0 W2 := by
  simp [inclusion0, row0, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.mul_fromCols]

lemma row1_extension (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) :
    fromCols W1 W0ᴴ * (inclusion1 (ι := ι) (κ := κ) (ν := ν))ᴴ = row1 W0 W1 := by
  simp [inclusion1, row1, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.conjTranspose_fromCols_eq_fromRows_conjTranspose, Matrix.mul_fromCols,
    Matrix.fromCols_mul_fromRows]

lemma row2_extension (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    fromCols W2 W1ᴴ * (inclusion2 (ι := ι) (κ := κ) (ν := ν))ᴴ = row2 W1 W2 := by
  simp [inclusion2, row2, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.conjTranspose_fromCols_eq_fromRows_conjTranspose, Matrix.mul_fromCols,
    Matrix.fromCols_mul_fromRows]

lemma triangle_hermitian (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ)
    (W2 : Matrix ν ι ℂ) : (triangle W0 W1 W2).IsHermitian := by
  change (triangle W0 W1 W2)ᴴ = _
  ext i j
  rcases i with i | i <;> rcases j with j | j
  · simp [triangle, row0, Matrix.conjTranspose_apply]
  · rcases j with j | j <;> simp [triangle, row0, row1, row2, Matrix.conjTranspose_apply]
  · rcases i with i | i <;> simp [triangle, row0, row1, row2, Matrix.conjTranspose_apply]
  · rcases i with i | i <;> rcases j with j | j <;>
      simp [triangle, row0, row1, row2, Matrix.conjTranspose_apply]

lemma blockD_hermitian (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ)
    (D2 : Matrix ν ν ℂ) (h0 : D0.IsHermitian) (h1 : D1.IsHermitian)
    (h2 : D2.IsHermitian) : (blockD D0 D1 D2).IsHermitian := by
  change (blockD D0 D1 D2)ᴴ = _
  simp [blockD, Matrix.fromBlocks_conjTranspose, h0.eq, h1.eq, h2.eq]

lemma triangle_gram (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ) :
    (triangle W0 W1 W2)ᴴ * triangle W0 W1 W2 =
      (row0 W0 W2)ᴴ * row0 W0 W2 + (row1 W0 W1)ᴴ * row1 W0 W1 +
        (row2 W1 W2)ᴴ * row2 W1 W2 := by
  simp [triangle, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromRows, add_assoc]

lemma triangle_direction (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ) (W2 : Matrix ν ι ℂ)
    (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) :
    (triangle W0 W1 W2)ᴴ * blockD D0 D1 D2 * triangle W0 W1 W2 =
      (row0 W0 W2)ᴴ * D0 * row0 W0 W2 + (row1 W0 W1)ᴴ * D1 * row1 W0 W1 +
        (row2 W1 W2)ᴴ * D2 * row2 W1 W2 := by
  simp [triangle, blockD, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromBlocks, Matrix.fromCols_mul_fromRows, Matrix.fromRows_mul,
    Matrix.mul_assoc, add_assoc]

theorem triangle_common_metric (W0 : Matrix ι κ ℂ) (W1 : Matrix κ ν ℂ)
    (W2 : Matrix ν ι ℂ) (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ)
    (D2 : Matrix ν ν ℂ) :
    (1 / 3 : ℝ) * rowCost (triangle W0 W1 W2) (blockD D0 D1 D2) ≤
      rowCost (fromCols W0 W2ᴴ) D0 + rowCost (fromCols W1 W0ᴴ) D1 +
        rowCost (fromCols W2 W1ᴴ) D2 := by
  let B0 := row0 W0 W2
  let B1 := row1 W0 W1
  let B2 := row2 W1 W2
  let Q := (triangle W0 W1 W2)ᴴ * triangle W0 W1 W2
  have h0 := Matrix.posSemidef_conjTranspose_mul_self B0
  have h1 := Matrix.posSemidef_conjTranspose_mul_self B1
  have h2 := Matrix.posSemidef_conjTranspose_mul_self B2
  have hQ := Matrix.posSemidef_conjTranspose_mul_self (triangle W0 W1 W2)
  have hsum : Q = B0ᴴ * B0 + B1ᴴ * B1 + B2ᴴ * B2 := triangle_gram W0 W1 W2
  have hl0 : B0ᴴ * B0 ≤ Q := by
    change (Q - B0ᴴ * B0).PosSemidef
    rw [hsum]
    convert h1.add h2 using 1 <;> abel
  have hl1 : B1ᴴ * B1 ≤ Q := by
    change (Q - B1ᴴ * B1).PosSemidef
    rw [hsum]
    convert h0.add h2 using 1 <;> abel
  have hl2 : B2ᴴ * B2 ≤ Q := by
    change (Q - B2ᴴ * B2).PosSemidef
    rw [hsum]
    convert h0.add h1 using 1 <;> abel
  have hc := SharedTraceHessian.common_metric_three h0 h1 h2 hQ hl0 hl1 hl2
    (SharedTraceHessian.supported_gram B0 D0) (SharedTraceHessian.supported_gram B1 D1)
    (SharedTraceHessian.supported_gram B2 D2)
  have hz0 := rowCost_isometry (inclusion0 (ι := ι) (κ := κ) (ν := ν))
    inclusion0_isometry (fromCols W0 W2ᴴ) D0
  have hz1 := rowCost_isometry (inclusion1 (ι := ι) (κ := κ) (ν := ν))
    inclusion1_isometry (fromCols W1 W0ᴴ) D1
  have hz2 := rowCost_isometry (inclusion2 (ι := ι) (κ := κ) (ν := ν))
    inclusion2_isometry (fromCols W2 W1ᴴ) D2
  rw [row0_extension] at hz0
  rw [row1_extension] at hz1
  rw [row2_extension] at hz2
  rw [← hz0, ← hz1, ← hz2]
  unfold rowCost
  rw [triangle_direction]
  exact hc

def Dstar (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ) (D2 : Matrix ν ν ℂ) : ℝ :=
  max ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D0‖
    (max ‖Matrix.toEuclideanCLM (n := κ) (𝕜 := ℂ) D1‖
      ‖Matrix.toEuclideanCLM (n := ν) (𝕜 := ℂ) D2‖)

lemma blockD_norm_le (D0 : Matrix ι ι ℂ) (D1 : Matrix κ κ ℂ)
    (D2 : Matrix ν ν ℂ) :
    ‖Matrix.toEuclideanCLM (n := Total ι κ ν) (𝕜 := ℂ) (blockD D0 D1 D2)‖ ≤
      Dstar D0 D1 D2 := by
  let c := Dstar D0 D1 D2
  have hc : 0 ≤ c := le_trans (norm_nonneg _) (le_max_left _ _)
  have h0 : ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D0‖ ≤ c := le_max_left _ _
  have h1 : ‖Matrix.toEuclideanCLM (n := κ) (𝕜 := ℂ) D1‖ ≤ c :=
    (le_max_left _ _).trans (le_max_right _ _)
  have h2 : ‖Matrix.toEuclideanCLM (n := ν) (𝕜 := ℂ) D2‖ ≤ c :=
    (le_max_right _ _).trans (le_max_right _ _)
  apply ContinuousLinearMap.opNorm_le_bound _ hc
  intro x
  let x0 : EuclideanSpace ℂ ι := toLp 2 fun i => x (Sum.inl i)
  let x1 : EuclideanSpace ℂ κ := toLp 2 fun i => x (Sum.inr (Sum.inl i))
  let x2 : EuclideanSpace ℂ ν := toLp 2 fun i => x (Sum.inr (Sum.inr i))
  have hv0 := (ContinuousLinearMap.le_opNorm
    (Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D0) x0).trans
      (mul_le_mul_of_nonneg_right h0 (norm_nonneg _))
  have hv1 := (ContinuousLinearMap.le_opNorm
    (Matrix.toEuclideanCLM (n := κ) (𝕜 := ℂ) D1) x1).trans
      (mul_le_mul_of_nonneg_right h1 (norm_nonneg _))
  have hv2 := (ContinuousLinearMap.le_opNorm
    (Matrix.toEuclideanCLM (n := ν) (𝕜 := ℂ) D2) x2).trans
      (mul_le_mul_of_nonneg_right h2 (norm_nonneg _))
  have hx : ‖x‖ ^ 2 = ‖x0‖ ^ 2 + ‖x1‖ ^ 2 + ‖x2‖ ^ 2 := by
    simp [EuclideanSpace.norm_sq_eq, x0, x1, x2, Fintype.sum_sum_type, add_assoc]
  have hy : ‖Matrix.toEuclideanCLM (n := Total ι κ ν) (𝕜 := ℂ)
      (blockD D0 D1 D2) x‖ ^ 2 =
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D0 x0‖ ^ 2 +
      ‖Matrix.toEuclideanCLM (n := κ) (𝕜 := ℂ) D1 x1‖ ^ 2 +
      ‖Matrix.toEuclideanCLM (n := ν) (𝕜 := ℂ) D2 x2‖ ^ 2 := by
    simp [EuclideanSpace.norm_sq_eq, blockD, Matrix.ofLp_toEuclideanCLM,
      Matrix.fromBlocks_mulVec, x0, x1, x2, Fintype.sum_sum_type, add_assoc, Function.comp_def]
  apply (sq_le_sq₀ (norm_nonneg _) (mul_nonneg hc (norm_nonneg _))).mp
  rw [hy, mul_pow, hx, mul_add, mul_add]
  simpa only [mul_pow] using add_le_add
    (add_le_add (sq_le_sq₀ (norm_nonneg _) (by positivity) |>.mpr hv0)
    (sq_le_sq₀ (norm_nonneg _) (by positivity) |>.mpr hv1))
    (sq_le_sq₀ (norm_nonneg _) (by positivity) |>.mpr hv2)

end SharedTraceAssembly
