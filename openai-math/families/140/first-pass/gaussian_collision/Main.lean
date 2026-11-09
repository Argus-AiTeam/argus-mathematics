import Mathlib

noncomputable section

open MeasureTheory Matrix ProbabilityTheory
open scoped MatrixOrder NNReal ENNReal

namespace GaussianCollision

set_option linter.unusedSectionVars false

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def sqNorm (x : ι → ℝ) : ℝ := ∑ i, x i ^ 2

@[fun_prop]
lemma continuous_sqNorm : Continuous (sqNorm : (ι → ℝ) → ℝ) := by
  unfold sqNorm
  fun_prop

lemma sqNorm_eq_dot (x : ι → ℝ) : sqNorm x = x ⬝ᵥ x := by
  simp [sqNorm, dotProduct, pow_two]

lemma exp_sqNorm_eq_prod (x : ι → ℝ) :
    Real.exp (-sqNorm x / 2) = ∏ i, Real.exp (-(1 / 2 : ℝ) * x i ^ 2) := by
  rw [← Real.exp_sum]
  congr 1
  simp only [sqNorm]
  rw [← Finset.mul_sum]
  ring

lemma integrable_exp_sqNorm :
    Integrable (fun x : ι → ℝ => Real.exp (-sqNorm x / 2)) := by
  simp_rw [exp_sqNorm_eq_prod]
  exact Integrable.fintype_prod (fun _ => integrable_exp_neg_mul_sq (by norm_num))

lemma integral_exp_sqNorm :
    (∫ x : ι → ℝ, Real.exp (-sqNorm x / 2)) =
      Real.sqrt (2 * Real.pi) ^ Fintype.card ι := by
  simp_rw [exp_sqNorm_eq_prod]
  calc
    _ = (∫ u : ℝ, Real.exp (-(1 / 2 : ℝ) * u ^ 2)) ^ Fintype.card ι :=
      integral_fintype_prod_volume_eq_pow _
    _ = _ := by
      rw [integral_gaussian]
      congr 2
      ring

lemma integral_exp_linear_sqNorm (B : Matrix ι ι ℝ) (hB : B.det ≠ 0) :
    (∫ x : ι → ℝ, Real.exp (-sqNorm (B *ᵥ x) / 2)) =
      |B.det|⁻¹ * Real.sqrt (2 * Real.pi) ^ Fintype.card ι := by
  have hm := Real.map_matrix_volume_pi_eq_smul_volume_pi hB
  have hmeas : Measurable (toLin' B) := by fun_prop
  calc
    _ = ∫ x : ι → ℝ, Real.exp (-sqNorm x / 2)
        ∂(Measure.map (toLin' B) volume) := by
      rw [integral_map hmeas.aemeasurable]
      · rfl
      · exact (by fun_prop : Continuous (fun x : ι → ℝ =>
          Real.exp (-sqNorm x / 2))).aestronglyMeasurable
    _ = _ := by
      rw [hm, integral_smul_measure, ENNReal.toReal_ofReal (abs_nonneg _),
        smul_eq_mul, abs_inv, integral_exp_sqNorm]

lemma integrable_exp_linear_sqNorm (B : Matrix ι ι ℝ) (hB : B.det ≠ 0) :
    Integrable (fun x : ι → ℝ => Real.exp (-sqNorm (B *ᵥ x) / 2)) := by
  have hm := Real.map_matrix_volume_pi_eq_smul_volume_pi hB
  have hmeas : Measurable (toLin' B) := by fun_prop
  have hi : Integrable (fun x : ι → ℝ => Real.exp (-sqNorm x / 2))
      (Measure.map (toLin' B) volume) := by
    rw [hm]
    exact integrable_exp_sqNorm.smul_measure ENNReal.ofReal_ne_top
  exact (integrable_map_measure (by fun_prop) hmeas.aemeasurable).mp hi

theorem gaussian_integral (Q : Matrix ι ι ℝ) (hQ : Q.PosDef) :
    (∫ x : ι → ℝ, Real.exp (-(x ⬝ᵥ Q *ᵥ x) / 2)) =
      Real.sqrt (2 * Real.pi) ^ Fintype.card ι / Real.sqrt Q.det := by
  let B : Matrix ι ι ℝ := CFC.sqrt Q
  have hBB : B * B = Q := CFC.sqrt_mul_sqrt_self Q hQ.posSemidef.nonneg
  have hBt : Bᵀ = B := by
    have h := (CFC.sqrt_nonneg Q).isSelfAdjoint.star_eq
    simpa only [Matrix.star_eq_conjTranspose, conjTranspose_eq_transpose_of_trivial] using h
  have hdet : B.det ^ 2 = Q.det := by
    rw [pow_two, ← det_mul, hBB]
  have hB : B.det ≠ 0 := by
    intro hz
    have := hQ.det_pos
    rw [← hdet, hz] at this
    norm_num at this
  have hnorm (x : ι → ℝ) : sqNorm (B *ᵥ x) = x ⬝ᵥ Q *ᵥ x := by
    calc
      _ = (B *ᵥ x) ⬝ᵥ (B *ᵥ x) := sqNorm_eq_dot _
      _ = (x ᵥ* Bᵀ) ⬝ᵥ (B *ᵥ x) := by rw [vecMul_transpose]
      _ = x ⬝ᵥ Bᵀ *ᵥ (B *ᵥ x) := (dotProduct_mulVec _ _ _).symm
      _ = _ := by rw [mulVec_mulVec, hBt, hBB]
  have hsqrt : Real.sqrt Q.det = |B.det| := by
    rw [← hdet, Real.sqrt_sq_eq_abs]
  simp_rw [← hnorm]
  rw [integral_exp_linear_sqNorm B hB, hsqrt]
  ring

def gaussianPi (ι : Type*) [Fintype ι] : Measure (ι → ℝ) :=
  Measure.pi (fun _ : ι => gaussianReal 0 1)

instance : IsProbabilityMeasure (gaussianPi ι) := by
  unfold gaussianPi
  infer_instance

lemma gaussianPi_density :
    gaussianPi ι = volume.withDensity
      (fun x : ι → ℝ => ENNReal.ofReal (∏ i, gaussianPDFReal 0 1 (x i))) := by
  apply Measure.pi_eq
  intro s hs
  have hi : Integrable (fun x : ι → ℝ => ∏ i, gaussianPDFReal 0 1 (x i))
      (volume.restrict (Set.univ.pi s)) := by
    change Integrable _ ((Measure.pi (fun _ : ι => (volume : Measure ℝ))).restrict _)
    rw [Measure.restrict_pi_pi]
    exact Integrable.fintype_prod (fun _ => (integrable_gaussianPDFReal 0 1).restrict)
  rw [withDensity_apply _ (MeasurableSet.univ_pi hs),
    ← ofReal_integral_eq_lintegral_ofReal hi
      (ae_of_all _ (fun x => Finset.prod_nonneg (fun _ _ => gaussianPDFReal_nonneg _ _ _)))]
  change ENNReal.ofReal (∫ x, ∏ i, gaussianPDFReal 0 1 (x i)
    ∂((Measure.pi (fun _ : ι => (volume : Measure ℝ))).restrict (Set.univ.pi s))) = _
  rw [Measure.restrict_pi_pi]
  have he := integral_fintype_prod_eq_prod
    (fun (_ : ι) (u : ℝ) => gaussianPDFReal 0 1 u)
    (μ := fun i => (volume : Measure ℝ).restrict (s i))
  rw [he, ENNReal.ofReal_prod_of_nonneg (fun _ _ =>
    integral_nonneg (fun _ => gaussianPDFReal_nonneg _ _ _))]
  apply Finset.prod_congr rfl
  intro i _
  exact (gaussianReal_apply_eq_integral 0 (by norm_num) (s i)).symm

lemma gaussianPi_density_formula (x : ι → ℝ) :
    (∏ i, gaussianPDFReal 0 1 (x i)) =
      (Real.sqrt (2 * Real.pi))⁻¹ ^ Fintype.card ι *
        Real.exp (-sqNorm x / 2) := by
  simp only [gaussianPDFReal, NNReal.coe_one, mul_one, sub_zero,
    Finset.prod_mul_distrib, Finset.prod_const, Finset.card_univ]
  congr 1
  rw [← Real.exp_sum]
  congr 1
  rw [← Finset.sum_div, Finset.sum_neg_distrib]
  rfl

def phi (v x : ℝ) : ℝ :=
  (Real.sqrt (2 * Real.pi * v))⁻¹ * Real.exp (-x ^ 2 / (2 * v))

@[fun_prop]
lemma continuous_phi (v : ℝ) : Continuous (phi v) := by
  unfold phi
  fun_prop

lemma phi_nonneg (v x : ℝ) : 0 ≤ phi v x := by
  unfold phi
  positivity

def countPlusOne (ι : Type*) [Fintype ι] : ℝ := (Fintype.card ι : ℝ) + 1

lemma countPlusOne_pos : 0 < countPlusOne ι := by
  unfold countPlusOne
  positivity

lemma residual_squares (u : ι → ℝ) (y : ℝ) :
    y ^ 2 + ∑ i, (y - u i) ^ 2 =
      countPlusOne ι * (y - (∑ i, u i) / countPlusOne ι) ^ 2 +
        (∑ i, u i ^ 2) - (∑ i, u i) ^ 2 / countPlusOne ι := by
  have hk : countPlusOne ι ≠ 0 := countPlusOne_pos.ne'
  have hsum : (∑ i, (y - u i) ^ 2) =
      (Fintype.card ι : ℝ) * y ^ 2 - 2 * y * (∑ i, u i) + ∑ i, u i ^ 2 := by
    simp only [sub_sq, Finset.sum_add_distrib, Finset.sum_sub_distrib,
      Finset.sum_const, Finset.card_univ, nsmul_eq_mul, ← Finset.mul_sum]
  rw [hsum]
  field_simp
  simp only [countPlusOne]
  ring

lemma product_phi (v y : ℝ) (u : ι → ℝ) :
    phi v y * (∏ i, phi v (y - u i)) =
      (Real.sqrt (2 * Real.pi * v))⁻¹ ^ (Fintype.card ι + 1) *
        Real.exp (-(y ^ 2 + ∑ i, (y - u i) ^ 2) / (2 * v)) := by
  simp only [phi, Finset.prod_mul_distrib, Finset.prod_const, Finset.card_univ]
  rw [← Real.exp_sum]
  have he : Real.exp (-y ^ 2 / (2 * v)) *
      Real.exp (∑ i, -(y - u i) ^ 2 / (2 * v)) =
      Real.exp (-(y ^ 2 + ∑ i, (y - u i) ^ 2) / (2 * v)) := by
    rw [← Real.exp_add]
    congr 1
    rw [← Finset.sum_div, Finset.sum_neg_distrib]
    ring
  calc
    _ = ((Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ι *
          (Real.sqrt (2 * Real.pi * v))⁻¹) *
        (Real.exp (-y ^ 2 / (2 * v)) *
          Real.exp (∑ i, -(y - u i) ^ 2 / (2 * v))) := by ring
    _ = _ := by
      rw [he, pow_succ (Real.sqrt (2 * Real.pi * v))⁻¹ (Fintype.card ι)]

theorem scalar_collision (v : ℝ) (hv : 0 < v) (u : ι → ℝ) :
    (∫ y : ℝ, phi v y * ∏ i, phi v (y - u i)) =
      (Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ι /
        Real.sqrt (countPlusOne ι) *
      Real.exp (-((∑ i, u i ^ 2) - (∑ i, u i) ^ 2 / countPlusOne ι) / (2 * v)) := by
  let c := (Real.sqrt (2 * Real.pi * v))⁻¹
  let b := countPlusOne ι / (2 * v)
  let a := (∑ i, u i) / countPlusOne ι
  let r := (∑ i, u i ^ 2) - (∑ i, u i) ^ 2 / countPlusOne ι
  have h (y : ℝ) : phi v y * ∏ i, phi v (y - u i) =
      (c ^ (Fintype.card ι + 1) * Real.exp (-r / (2 * v))) *
        Real.exp (-b * (y - a) ^ 2) := by
    rw [product_phi, residual_squares]
    dsimp [c, b, a, r]
    conv_rhs => rw [mul_assoc]
    rw [← Real.exp_add]
    congr 1
    congr 1
    ring
  simp_rw [h]
  rw [integral_const_mul, integral_sub_right_eq_self
    (fun y : ℝ => Real.exp (-b * y ^ 2)) a, integral_gaussian]
  have hsqrt : Real.sqrt (Real.pi / b) =
      Real.sqrt (2 * Real.pi * v) / Real.sqrt (countPlusOne ι) := by
    rw [← Real.sqrt_div (by positivity)]
    congr 1
    dsimp [b]
    field_simp
  rw [hsqrt]
  have hc : Real.sqrt (2 * Real.pi * v) ≠ 0 := (Real.sqrt_pos.2 (by positivity)).ne'
  dsimp [c, r]
  rw [pow_succ]
  field_simp

def ones (ι : Type*) : Matrix ι ι ℝ := fun _ _ => 1

def noiseBase (ι : Type*) [DecidableEq ι] : Matrix ι ι ℝ := 1 + ones ι

def centering (ι : Type*) [Fintype ι] [DecidableEq ι] : Matrix ι ι ℝ :=
  1 - (countPlusOne ι)⁻¹ • ones ι

lemma ones_posSemidef : (ones ι).PosSemidef := by
  apply PosSemidef.of_dotProduct_mulVec_nonneg
  · change (ones ι)ᴴ = ones ι
    ext i j
    rfl
  · intro x
    have h : star x ⬝ᵥ (ones ι) *ᵥ x = (∑ i, x i) ^ 2 := by
      simp [ones, Matrix.mulVec, dotProduct, ← Finset.sum_mul, pow_two]
    rw [h]
    exact sq_nonneg _

lemma noiseBase_posDef : (noiseBase ι).PosDef :=
  PosDef.one.add_posSemidef ones_posSemidef

lemma ones_mul : ones ι * ones ι = (Fintype.card ι : ℝ) • ones ι := by
  ext i j
  simp [ones, Matrix.mul_apply]

lemma noiseBase_mul_centering : noiseBase ι * centering ι = 1 := by
  rw [noiseBase, centering, Matrix.mul_sub, Matrix.mul_one, Matrix.mul_smul,
    Matrix.add_mul, Matrix.one_mul, ones_mul]
  ext i j
  simp only [Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul, ones]
  have hk : countPlusOne ι ≠ 0 := countPlusOne_pos.ne'
  dsimp [countPlusOne]
  field_simp
  ring

lemma centering_eq_inv : centering ι = (noiseBase ι)⁻¹ :=
  (Matrix.inv_eq_right_inv noiseBase_mul_centering).symm

lemma centering_posDef : (centering ι).PosDef := by
  rw [centering_eq_inv]
  exact noiseBase_posDef.inv

lemma det_noiseBase : (noiseBase ι).det = countPlusOne ι := by
  have h : ones ι = replicateCol Unit (fun _ : ι => (1 : ℝ)) *
      replicateRow Unit (fun _ : ι => (1 : ℝ)) := by
    ext i j
    simp [ones, Matrix.mul_apply]
  rw [noiseBase, h, det_one_add_replicateCol_mul_replicateRow]
  simp [countPlusOne, dotProduct, add_comm]

variable {τ : Type*} [Fintype τ] [DecidableEq τ]

def scatter (D : Matrix τ ι ℝ) : Matrix τ τ ℝ :=
  D * centering ι * Dᵀ

def precision (v : ℝ) (D : Matrix τ ι ℝ) : Matrix τ τ ℝ :=
  1 + v⁻¹ • scatter D

def covariance (v : ℝ) (D : Matrix τ ι ℝ) : Matrix ι ι ℝ :=
  Dᵀ * D + v • noiseBase ι

lemma scatter_posSemidef (D : Matrix τ ι ℝ) : (scatter D).PosSemidef := by
  simpa only [scatter, conjTranspose_eq_transpose_of_trivial] using
    centering_posDef.posSemidef.mul_mul_conjTranspose_same D

lemma precision_posDef (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    (precision v D).PosDef :=
  PosDef.one.add_posSemidef ((scatter_posSemidef D).smul (inv_nonneg.2 hv.le))

lemma covariance_posDef (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    (covariance v D).PosDef := by
  have hg : (Dᵀ * D).PosSemidef := by
    simpa only [conjTranspose_eq_transpose_of_trivial] using posSemidef_conjTranspose_mul_self D
  exact PosDef.posSemidef_add hg (noiseBase_posDef.smul hv)

lemma determinant_relation (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    (covariance v D).det =
      v ^ Fintype.card ι * countPlusOne ι * (precision v D).det := by
  have hfactor : covariance v D =
      (v • noiseBase ι) * (1 + v⁻¹ • (centering ι * Dᵀ * D)) := by
    rw [Matrix.mul_add, Matrix.mul_one, Matrix.mul_smul, Matrix.smul_mul, smul_smul,
      inv_mul_cancel₀ hv.ne', one_smul, ← Matrix.mul_assoc,
      ← Matrix.mul_assoc, noiseBase_mul_centering, Matrix.one_mul]
    exact add_comm _ _
  have hsyl : (1 + v⁻¹ • (centering ι * Dᵀ * D)).det = (precision v D).det := by
    simpa only [precision, scatter, Matrix.smul_mul, Matrix.mul_smul, Matrix.mul_assoc] using
      det_one_add_mul_comm (v⁻¹ • (centering ι * Dᵀ)) D
  rw [hfactor, det_mul, det_smul, det_noiseBase, hsyl]

theorem gaussian_laplace (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    (∫ x : τ → ℝ, Real.exp (-(x ⬝ᵥ scatter D *ᵥ x) / (2 * v))
      ∂gaussianPi τ) = (Real.sqrt (precision v D).det)⁻¹ := by
  rw [gaussianPi_density, integral_withDensity_eq_integral_toReal_smul (by fun_prop)
    (ae_of_all _ (fun _ => ENNReal.ofReal_lt_top))]
  have hden (x : τ → ℝ) :
      (ENNReal.ofReal (∏ i, gaussianPDFReal 0 1 (x i))).toReal =
        (Real.sqrt (2 * Real.pi))⁻¹ ^ Fintype.card τ *
          Real.exp (-sqNorm x / 2) := by
    rw [ENNReal.toReal_ofReal
      (Finset.prod_nonneg (fun _ _ => gaussianPDFReal_nonneg _ _ _))]
    exact gaussianPi_density_formula x
  simp_rw [smul_eq_mul, hden]
  have hquad (x : τ → ℝ) :
      x ⬝ᵥ precision v D *ᵥ x = sqNorm x + v⁻¹ * (x ⬝ᵥ scatter D *ᵥ x) := by
    rw [precision, Matrix.add_mulVec, Matrix.one_mulVec, Matrix.smul_mulVec,
      dotProduct_add, sqNorm_eq_dot]
    congr 1
    simp only [dotProduct, Pi.smul_apply, smul_eq_mul]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring
  have hexp (x : τ → ℝ) :
      Real.exp (-sqNorm x / 2) *
        Real.exp (-(x ⬝ᵥ scatter D *ᵥ x) / (2 * v)) =
      Real.exp (-(x ⬝ᵥ precision v D *ᵥ x) / 2) := by
    rw [← Real.exp_add, hquad]
    congr 1
    ring
  simp_rw [mul_assoc, hexp]
  rw [integral_const_mul, gaussian_integral _ (precision_posDef v hv D)]
  have hc : Real.sqrt (2 * Real.pi) ≠ 0 := (Real.sqrt_pos.2 (by positivity)).ne'
  rw [inv_pow]
  field_simp

lemma centering_quadratic (u : ι → ℝ) :
    u ⬝ᵥ centering ι *ᵥ u =
      (∑ i, u i ^ 2) - (∑ i, u i) ^ 2 / countPlusOne ι := by
  rw [centering, Matrix.sub_mulVec, Matrix.one_mulVec, Matrix.smul_mulVec,
    dotProduct_sub]
  have h : u ⬝ᵥ ((countPlusOne ι)⁻¹ • (ones ι) *ᵥ u) =
      (∑ i, u i) ^ 2 / countPlusOne ι := by
    simp only [dotProduct, Pi.smul_apply, smul_eq_mul, Matrix.mulVec, ones, one_mul]
    rw [← Finset.sum_mul]
    ring
  rw [h]
  simp [dotProduct, pow_two]

lemma scatter_quadratic (D : Matrix τ ι ℝ) (x : τ → ℝ) :
    x ⬝ᵥ scatter D *ᵥ x =
      (∑ i, (Dᵀ *ᵥ x) i ^ 2) - (∑ i, (Dᵀ *ᵥ x) i) ^ 2 / countPlusOne ι := by
  have h : x ᵥ* D = Dᵀ *ᵥ x := by
    rw [← Matrix.vecMul_transpose Dᵀ x, Matrix.transpose_transpose]
  rw [scatter, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    Matrix.dotProduct_mulVec, h, centering_quadratic]

lemma sqrt_pow_nonneg (v : ℝ) (hv : 0 ≤ v) (n : ℕ) :
    Real.sqrt (v ^ n) = Real.sqrt v ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [pow_succ, Real.sqrt_mul (pow_nonneg hv n), ih, pow_succ]

lemma sqrt_determinant_relation (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    Real.sqrt (covariance v D).det =
      Real.sqrt v ^ Fintype.card ι * Real.sqrt (countPlusOne ι) *
        Real.sqrt (precision v D).det := by
  rw [determinant_relation v hv D,
    Real.sqrt_mul (mul_nonneg (pow_nonneg hv.le _) countPlusOne_pos.le),
    Real.sqrt_mul (pow_nonneg hv.le _), sqrt_pow_nonneg v hv.le]

theorem row_collision (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    (∫ x : τ → ℝ, (∫ y : ℝ, phi v y * ∏ i, phi v (y - (Dᵀ *ᵥ x) i))
      ∂gaussianPi τ) =
      1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι *
        Real.sqrt (covariance v D).det) := by
  simp_rw [scalar_collision v hv]
  simp_rw [← scatter_quadratic D]
  rw [integral_const_mul, gaussian_laplace v hv D,
    sqrt_determinant_relation v hv D,
    Real.sqrt_mul (by positivity : 0 ≤ 2 * Real.pi)]
  have hc : Real.sqrt (2 * Real.pi) ≠ 0 := (Real.sqrt_pos.2 (by positivity)).ne'
  have hv' : Real.sqrt v ≠ 0 := (Real.sqrt_pos.2 hv).ne'
  have hk : Real.sqrt (countPlusOne ι) ≠ 0 := (Real.sqrt_pos.2 countPlusOne_pos).ne'
  have hq : Real.sqrt (precision v D).det ≠ 0 :=
    (Real.sqrt_pos.2 (precision_posDef v hv D).det_pos).ne'
  rw [inv_pow, mul_pow]
  field_simp

def differences (z : τ → ℝ) (t : ι → τ → ℝ) : Matrix τ ι ℝ :=
  fun j i => t i j - z j

lemma projected_difference (z : τ → ℝ) (t : ι → τ → ℝ) (x : τ → ℝ) (i : ι) :
    ((differences z t)ᵀ *ᵥ x) i = x ⬝ᵥ t i - x ⬝ᵥ z := by
  simp only [differences, Matrix.mulVec, Matrix.transpose_apply, dotProduct]
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j _
  ring

lemma conditional_translation (v : ℝ) (z : τ → ℝ) (t : ι → τ → ℝ) (x : τ → ℝ) :
    (∫ y : ℝ, phi v (y - x ⬝ᵥ z) * ∏ i, phi v (y - x ⬝ᵥ t i)) =
      ∫ y : ℝ, phi v y * ∏ i, phi v (y - ((differences z t)ᵀ *ᵥ x) i) := by
  calc
    _ = ∫ y : ℝ, phi v (y - x ⬝ᵥ z) *
        ∏ i, phi v ((y - x ⬝ᵥ z) - ((differences z t)ᵀ *ᵥ x) i) := by
      congr 1
      ext y
      congr 1
      apply Finset.prod_congr rfl
      intro i _
      rw [projected_difference]
      congr 1
      ring
    _ = _ := integral_sub_right_eq_self
      (fun y : ℝ => phi v y * ∏ i, phi v (y - ((differences z t)ᵀ *ᵥ x) i)) (x ⬝ᵥ z)

theorem row_collision_translated (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) :
    (∫ x : τ → ℝ, (∫ y : ℝ,
        phi v (y - x ⬝ᵥ z) * ∏ i, phi v (y - x ⬝ᵥ t i)) ∂gaussianPi τ) =
      1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι *
        Real.sqrt (covariance v (differences z t)).det) := by
  simp_rw [conditional_translation]
  exact row_collision v hv _

variable {ρ : Type*} [Fintype ρ] [DecidableEq ρ]

def gaussianRows (ρ τ : Type*) [Fintype ρ] [Fintype τ] : Measure (ρ → τ → ℝ) :=
  Measure.pi (fun _ : ρ => gaussianPi τ)

instance : IsProbabilityMeasure (gaussianRows ρ τ) := by
  unfold gaussianRows
  infer_instance

def phiVec (v : ℝ) (y : ρ → ℝ) : ℝ := ∏ r, phi v (y r)

def project (A : ρ → τ → ℝ) (t : τ → ℝ) : ρ → ℝ :=
  fun r => A r ⬝ᵥ t

lemma phiVec_product_rows (v : ℝ) (z : τ → ℝ) (t : ι → τ → ℝ)
    (A : ρ → τ → ℝ) (y : ρ → ℝ) :
    phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)) =
      ∏ r, (phi v (y r - A r ⬝ᵥ z) * ∏ i, phi v (y r - A r ⬝ᵥ t i)) := by
  simp only [phiVec, project, Pi.sub_apply, Finset.prod_mul_distrib]
  congr 1
  exact Finset.prod_comm

lemma phi_eq_gaussianPDFReal (v : ℝ) (hv : 0 < v) (x : ℝ) :
    phi v x = gaussianPDFReal 0 ⟨v, hv.le⟩ x := by
  simp only [phi, gaussianPDFReal, sub_zero]
  rfl

lemma integral_phiVec (v : ℝ) (hv : 0 < v) :
    (∫ y : ρ → ℝ, phiVec v y) = 1 := by
  unfold phiVec
  calc
    _ = (∫ y : ℝ, phi v y) ^ Fintype.card ρ :=
      integral_fintype_prod_volume_eq_pow _
    _ = _ := by
      simp_rw [phi_eq_gaussianPDFReal v hv]
      rw [integral_gaussianPDFReal_eq_one _ (by
        intro h
        exact hv.ne' (congrArg (fun w : ℝ≥0 => (w : ℝ)) h))]
      simp

lemma conditional_integral_rows (v : ℝ) (z : τ → ℝ) (t : ι → τ → ℝ)
    (A : ρ → τ → ℝ) :
    (∫ y : ρ → ℝ,
        phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i))) =
      ∏ r, (∫ y : ℝ, phi v (y - A r ⬝ᵥ z) * ∏ i, phi v (y - A r ⬝ᵥ t i)) := by
  simp_rw [phiVec_product_rows]
  exact integral_fintype_prod_volume_eq_prod (fun r (y : ℝ) =>
    phi v (y - A r ⬝ᵥ z) * ∏ i, phi v (y - A r ⬝ᵥ t i))

theorem gaussian_difference_identity (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) :
    (∫ A : ρ → τ → ℝ, (∫ y : ρ → ℝ,
        phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)))
      ∂gaussianRows ρ τ) =
      (1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι *
        Real.sqrt (covariance v (differences z t)).det)) ^ Fintype.card ρ := by
  simp_rw [conditional_integral_rows]
  change (∫ A : ρ → τ → ℝ,
      ∏ r, (∫ y : ℝ, phi v (y - A r ⬝ᵥ z) * ∏ i, phi v (y - A r ⬝ᵥ t i))
      ∂Measure.pi (fun _ : ρ => gaussianPi τ)) = _
  have he := integral_fintype_prod_eq_pow (ι := ρ)
    (μ := gaussianPi τ) (fun x : τ → ℝ =>
      ∫ y : ℝ, phi v (y - x ⬝ᵥ z) * ∏ i, phi v (y - x ⬝ᵥ t i))
  rw [he, row_collision_translated v hv z t]

lemma sqrt_pow_inv_rpow (a : ℝ) (ha : 0 < a) (n : ℕ) :
    (Real.sqrt a ^ n)⁻¹ = a ^ (-(n : ℝ) / 2) := by
  calc
    _ = (a ^ ((1 / 2 : ℝ) * (n : ℝ)))⁻¹ := by
      rw [Real.rpow_mul ha.le, Real.rpow_natCast, Real.sqrt_eq_rpow]
    _ = a ^ (-((1 / 2 : ℝ) * (n : ℝ))) := (Real.rpow_neg ha.le _).symm
    _ = _ := by congr 1; ring

lemma kernel_rpow (a b : ℝ) (ha : 0 < a) (hb : 0 < b) (q m : ℕ) :
    (1 / (Real.sqrt a ^ q * Real.sqrt b)) ^ m =
      a ^ (-(m : ℝ) * (q : ℝ) / 2) * b ^ (-(m : ℝ) / 2) := by
  calc
    _ = (Real.sqrt a ^ (q * m))⁻¹ * (Real.sqrt b ^ m)⁻¹ := by
      simp only [one_div, mul_inv, mul_pow, inv_pow, pow_mul]
    _ = _ := by
      rw [sqrt_pow_inv_rpow a ha, sqrt_pow_inv_rpow b hb]
      push_cast
      congr 2
      ring

theorem gaussian_difference_identity_rpow (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) :
    (∫ A : ρ → τ → ℝ, (∫ y : ρ → ℝ,
        phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)))
      ∂gaussianRows ρ τ) =
      (2 * Real.pi) ^ (-(Fintype.card ρ : ℝ) * (Fintype.card ι : ℝ) / 2) *
        (covariance v (differences z t)).det ^ (-(Fintype.card ρ : ℝ) / 2) := by
  rw [gaussian_difference_identity v hv]
  exact kernel_rpow _ _ (by positivity) (covariance_posDef v hv _).det_pos _ _

theorem coincident_collision (v : ℝ) (hv : 0 < v) (z : τ → ℝ) :
    (∫ A : ρ → τ → ℝ,
      (∫ y : ρ → ℝ, phiVec v (y - project A z) ^ (Fintype.card ι + 1))
      ∂gaussianRows ρ τ) =
      (1 / (Real.sqrt (countPlusOne ι) *
        Real.sqrt (2 * Real.pi * v) ^ Fintype.card ι)) ^ Fintype.card ρ := by
  have h := gaussian_difference_identity (ρ := ρ) (ι := ι) v hv z (fun _ => z)
  have hD : differences z (fun _ : ι => z) = 0 := by
    ext i j
    simp [differences]
  have hc : (covariance v (0 : Matrix τ ι ℝ)).det =
      v ^ Fintype.card ι * countPlusOne ι := by
    simp [covariance, det_noiseBase]
  have hkernel :
      1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι *
        Real.sqrt (v ^ Fintype.card ι * countPlusOne ι)) =
      1 / (Real.sqrt (countPlusOne ι) *
        Real.sqrt (2 * Real.pi * v) ^ Fintype.card ι) := by
    rw [Real.sqrt_mul (pow_nonneg hv.le _), sqrt_pow_nonneg v hv.le,
      Real.sqrt_mul (by positivity : 0 ≤ 2 * Real.pi), mul_pow]
    ring
  rw [hD, hc, hkernel] at h
  simpa only [Finset.prod_const, Finset.card_univ, pow_succ, mul_comm] using h

lemma phi_le (v : ℝ) (hv : 0 < v) (x : ℝ) :
    phi v x ≤ (Real.sqrt (2 * Real.pi * v))⁻¹ := by
  have h : Real.exp (-x ^ 2 / (2 * v)) ≤ 1 := by
    apply Real.exp_le_one_iff.2
    exact div_nonpos_of_nonpos_of_nonneg (neg_nonpos.2 (sq_nonneg _)) (by positivity)
  simpa only [phi, mul_one] using mul_le_mul_of_nonneg_left h
    (by positivity : 0 ≤ (Real.sqrt (2 * Real.pi * v))⁻¹)

lemma phiVec_nonneg (v : ℝ) (y : ρ → ℝ) : 0 ≤ phiVec v y :=
  Finset.prod_nonneg (fun _ _ => phi_nonneg _ _)

@[fun_prop]
lemma continuous_phiVec (v : ℝ) : Continuous (phiVec v : (ρ → ℝ) → ℝ) := by
  unfold phiVec
  fun_prop

lemma phiVec_le (v : ℝ) (hv : 0 < v) (y : ρ → ℝ) :
    phiVec v y ≤ (Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ρ := by
  calc
    _ ≤ ∏ _ : ρ, (Real.sqrt (2 * Real.pi * v))⁻¹ :=
      Finset.prod_le_prod (fun _ _ => phi_nonneg _ _) (fun _ _ => phi_le v hv _)
    _ = _ := by simp

lemma integrable_phi (v : ℝ) (hv : 0 < v) : Integrable (phi v) := by
  rw [show phi v = gaussianPDFReal 0 ⟨v, hv.le⟩ from funext (phi_eq_gaussianPDFReal v hv)]
  exact integrable_gaussianPDFReal _ _

lemma integrable_scalar_product (v : ℝ) (hv : 0 < v) (u₀ : ℝ) (u : ι → ℝ) :
    Integrable (fun y : ℝ => phi v (y - u₀) * ∏ i, phi v (y - u i)) := by
  let c := (Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ι
  have hdom := ((integrable_phi v hv).comp_sub_right u₀).mul_const c
  apply hdom.mono' (by fun_prop)
  apply ae_of_all
  intro y
  rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg (phi_nonneg _ _)
    (Finset.prod_nonneg (fun _ _ => phi_nonneg _ _)))]
  apply mul_le_mul_of_nonneg_left _ (phi_nonneg _ _)
  calc
    _ ≤ ∏ _ : ι, (Real.sqrt (2 * Real.pi * v))⁻¹ :=
      Finset.prod_le_prod (fun _ _ => phi_nonneg _ _) (fun _ _ => phi_le v hv _)
    _ = c := by simp [c]

lemma integrable_conditional_scalar (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) :
    Integrable (fun x : τ → ℝ =>
      ∫ y : ℝ, phi v (y - x ⬝ᵥ z) * ∏ i, phi v (y - x ⬝ᵥ t i))
      (gaussianPi τ) := by
  simp_rw [conditional_translation, scalar_collision v hv, ← scatter_quadratic]
  apply Integrable.const_mul
  apply (integrable_const (1 : ℝ)).mono' (by unfold scatter; fun_prop)
  apply ae_of_all
  intro x
  rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  apply Real.exp_le_one_iff.2
  apply div_nonpos_of_nonpos_of_nonneg _ (by positivity)
  apply neg_nonpos.2
  simpa only [star_trivial] using
    (scatter_posSemidef (differences z t)).dotProduct_mulVec_nonneg x

lemma integrable_collision (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) (A : ρ → τ → ℝ) :
    Integrable (fun y : ρ → ℝ =>
      phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i))) := by
  simp_rw [phiVec_product_rows]
  exact Integrable.fintype_prod (fun r =>
    integrable_scalar_product v hv (A r ⬝ᵥ z) (fun i => A r ⬝ᵥ t i))

lemma integrable_conditional_collision (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) :
    Integrable (fun A : ρ → τ → ℝ => ∫ y : ρ → ℝ,
      phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)))
      (gaussianRows ρ τ) := by
  simp_rw [conditional_integral_rows]
  exact Integrable.fintype_prod (fun _ : ρ => integrable_conditional_scalar v hv z t)

theorem gaussian_collision_lintegral (v : ℝ) (hv : 0 < v)
    (z : τ → ℝ) (t : ι → τ → ℝ) :
    (∫⁻ A : ρ → τ → ℝ, (∫⁻ y : ρ → ℝ,
      ENNReal.ofReal (phiVec v (y - project A z) *
        ∏ i, phiVec v (y - project A (t i)))) ∂gaussianRows ρ τ) =
      ENNReal.ofReal ((1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι *
        Real.sqrt (covariance v (differences z t)).det)) ^ Fintype.card ρ) := by
  have hn (A : ρ → τ → ℝ) (y : ρ → ℝ) :
      0 ≤ phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)) :=
    mul_nonneg (phiVec_nonneg _ _) (Finset.prod_nonneg (fun _ _ => phiVec_nonneg _ _))
  calc
    _ = ∫⁻ A : ρ → τ → ℝ, ENNReal.ofReal (∫ y : ρ → ℝ,
        phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)))
        ∂gaussianRows ρ τ := by
      apply lintegral_congr_ae
      apply ae_of_all
      intro A
      exact (ofReal_integral_eq_lintegral_ofReal (integrable_collision v hv z t A)
        (ae_of_all _ (hn A))).symm
    _ = ENNReal.ofReal (∫ A : ρ → τ → ℝ, (∫ y : ρ → ℝ,
        phiVec v (y - project A z) * ∏ i, phiVec v (y - project A (t i)))
        ∂gaussianRows ρ τ) :=
      (ofReal_integral_eq_lintegral_ofReal (integrable_conditional_collision v hv z t)
        (ae_of_all _ (fun A => integral_nonneg (hn A)))).symm
    _ = _ := by rw [gaussian_difference_identity v hv]

def smooth (v : ℝ) (μ : Measure (τ → ℝ)) (A : ρ → τ → ℝ) (y : ρ → ℝ) : ℝ :=
  ∫ s : τ → ℝ, phiVec v (y - project A s) ∂μ

lemma smooth_nonneg (v : ℝ) (μ : Measure (τ → ℝ))
    (A : ρ → τ → ℝ) (y : ρ → ℝ) : 0 ≤ smooth v μ A y :=
  integral_nonneg (fun _ => phiVec_nonneg _ _)

lemma integrable_smoothing_integrand (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] (A : ρ → τ → ℝ) (y : ρ → ℝ) :
    Integrable (fun s : τ → ℝ => phiVec v (y - project A s)) μ := by
  have hdom : Integrable (fun _ : τ → ℝ =>
      (Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ρ) μ := integrable_const _
  apply hdom.mono' (by
    apply Continuous.aestronglyMeasurable
    unfold project
    fun_prop)
  apply ae_of_all
  intro s
  rw [Real.norm_eq_abs, abs_of_nonneg (phiVec_nonneg _ _)]
  exact phiVec_le v hv _

lemma measurable_smooth (v : ℝ) (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    Measurable (fun w : (ρ → τ → ℝ) × (ρ → ℝ) => smooth v μ w.1 w.2) := by
  have hm : StronglyMeasurable (fun w :
      ((ρ → τ → ℝ) × (ρ → ℝ)) × (τ → ℝ) =>
        phiVec v (w.1.2 - project w.1.1 w.2)) := by
    apply Continuous.stronglyMeasurable
    unfold project
    fun_prop
  exact hm.integral_prod_right'.measurable

lemma smoothing_power_expansion (p : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] (A : ρ → τ → ℝ) (y : ρ → ℝ) :
    ENNReal.ofReal (smooth v μ A y ^ p) =
      ∫⁻ t : Fin p → τ → ℝ, ENNReal.ofReal
        (∏ i, phiVec v (y - project A (t i))) ∂Measure.pi (fun _ : Fin p => μ) := by
  have hi : Integrable (fun t : Fin p → τ → ℝ =>
      ∏ i, phiVec v (y - project A (t i))) (Measure.pi (fun _ : Fin p => μ)) :=
    Integrable.fintype_prod (fun _ => integrable_smoothing_integrand v hv μ A y)
  rw [← ofReal_integral_eq_lintegral_ofReal hi (ae_of_all _ (fun _ =>
    Finset.prod_nonneg (fun _ _ => phiVec_nonneg _ _)))]
  have he := integral_fintype_prod_eq_pow (ι := Fin p) (μ := μ)
    (fun s : τ → ℝ => phiVec v (y - project A s))
  rw [he]
  simp only [smooth, Fintype.card_fin]

theorem smoothing_moment (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    (∫⁻ A : ρ → τ → ℝ, (∫⁻ y : ρ → ℝ,
        ENNReal.ofReal (smooth v μ A y ^ (q + 1))) ∂gaussianRows ρ τ) =
      ∫⁻ t : Fin (q + 1) → τ → ℝ,
        ENNReal.ofReal ((1 / (Real.sqrt (2 * Real.pi) ^ q *
          Real.sqrt (covariance v (differences (t 0) (fun i : Fin q => t i.succ))).det)) ^
            Fintype.card ρ)
        ∂Measure.pi (fun _ : Fin (q + 1) => μ) := by
  simp_rw [smoothing_power_expansion (q + 1) v hv μ]
  let G (A : ρ → τ → ℝ) (y : ρ → ℝ) (t : Fin (q + 1) → τ → ℝ) : ℝ≥0∞ :=
    ENNReal.ofReal (∏ i, phiVec v (y - project A (t i)))
  change (∫⁻ A : ρ → τ → ℝ, (∫⁻ y : ρ → ℝ,
    (∫⁻ t : Fin (q + 1) → τ → ℝ, G A y t ∂Measure.pi (fun _ => μ)))
    ∂gaussianRows ρ τ) = _
  calc
    _ = ∫⁻ A : ρ → τ → ℝ, (∫⁻ t : Fin (q + 1) → τ → ℝ,
        (∫⁻ y : ρ → ℝ, G A y t) ∂Measure.pi (fun _ => μ)) ∂gaussianRows ρ τ := by
      apply lintegral_congr_ae
      apply ae_of_all
      intro A
      apply lintegral_lintegral_swap
      dsimp [G]
      unfold project
      fun_prop
    _ = ∫⁻ t : Fin (q + 1) → τ → ℝ, (∫⁻ A : ρ → τ → ℝ,
        (∫⁻ y : ρ → ℝ, G A y t) ∂gaussianRows ρ τ)
        ∂Measure.pi (fun _ => μ) := by
      apply lintegral_lintegral_swap
      apply Measurable.aemeasurable
      exact (show Measurable (fun w :
        ((ρ → τ → ℝ) × (Fin (q + 1) → τ → ℝ)) × (ρ → ℝ) =>
          G w.1.1 w.2 w.1.2) from by
            dsimp [G]
            unfold project
            fun_prop).lintegral_prod_right'
    _ = _ := by
      apply lintegral_congr_ae
      apply ae_of_all
      intro t
      simpa only [G, Fin.prod_univ_succ, Fintype.card_fin] using
        gaussian_collision_lintegral (ρ := ρ) v hv (t 0) (fun i : Fin q => t i.succ)

lemma scatter_exponential_le_one (v : ℝ) (hv : 0 < v)
    (D : Matrix τ ι ℝ) (x : τ → ℝ) :
    Real.exp (-(x ⬝ᵥ scatter D *ᵥ x) / (2 * v)) ≤ 1 := by
  apply Real.exp_le_one_iff.2
  apply div_nonpos_of_nonpos_of_nonneg _ (by positivity)
  apply neg_nonpos.2
  simpa only [star_trivial] using (scatter_posSemidef D).dotProduct_mulVec_nonneg x

lemma integrable_scatter_exponential (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    Integrable (fun x : τ → ℝ => Real.exp (-(x ⬝ᵥ scatter D *ᵥ x) / (2 * v)))
      (gaussianPi τ) := by
  apply (integrable_const (1 : ℝ)).mono' (by unfold scatter; fun_prop)
  apply ae_of_all
  intro x
  rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  exact scatter_exponential_le_one v hv D x

lemma kernel_factorization (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι * Real.sqrt (covariance v D).det) =
      ((Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ι /
        Real.sqrt (countPlusOne ι)) * (Real.sqrt (precision v D).det)⁻¹ := by
  have h := row_collision v hv D
  simp_rw [scalar_collision v hv, ← scatter_quadratic D] at h
  rw [integral_const_mul, gaussian_laplace v hv D] at h
  exact h.symm

lemma kernel_le_coincident (v : ℝ) (hv : 0 < v) (D : Matrix τ ι ℝ) :
    1 / (Real.sqrt (2 * Real.pi) ^ Fintype.card ι * Real.sqrt (covariance v D).det) ≤
      (Real.sqrt (2 * Real.pi * v))⁻¹ ^ Fintype.card ι /
        Real.sqrt (countPlusOne ι) := by
  rw [kernel_factorization v hv D]
  apply mul_le_of_le_one_right (by positivity)
  rw [← gaussian_laplace v hv D]
  calc
    _ ≤ ∫ _ : τ → ℝ, (1 : ℝ) ∂gaussianPi τ :=
      integral_mono (integrable_scatter_exponential v hv D) (integrable_const _)
        (scatter_exponential_le_one v hv D)
    _ = 1 := by simp

theorem smoothing_mass_bound (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    (∫⁻ A : ρ → τ → ℝ, (∫⁻ y : ρ → ℝ,
        ENNReal.ofReal (smooth v μ A y ^ (q + 1))) ∂gaussianRows ρ τ) ≤
      ENNReal.ofReal (((Real.sqrt (2 * Real.pi * v))⁻¹ ^ q /
        Real.sqrt (countPlusOne (Fin q))) ^ Fintype.card ρ) *
        μ Set.univ ^ (q + 1) := by
  rw [smoothing_moment q v hv μ]
  calc
    _ ≤ ∫⁻ _ : Fin (q + 1) → τ → ℝ,
        ENNReal.ofReal (((Real.sqrt (2 * Real.pi * v))⁻¹ ^ q /
          Real.sqrt (countPlusOne (Fin q))) ^ Fintype.card ρ)
        ∂Measure.pi (fun _ : Fin (q + 1) => μ) := by
      apply lintegral_mono
      intro t
      apply ENNReal.ofReal_le_ofReal
      exact pow_le_pow_left₀ (by positivity)
        (by simpa only [Fintype.card_fin] using
          kernel_le_coincident v hv (differences (t 0) (fun i : Fin q => t i.succ))) _
    _ = _ := by
      simp [Measure.pi_univ, mul_comm]

theorem smoothing_moment_finite (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    (∫⁻ A : ρ → τ → ℝ, (∫⁻ y : ρ → ℝ,
        ENNReal.ofReal (smooth v μ A y ^ (q + 1))) ∂gaussianRows ρ τ) < ∞ := by
  apply lt_of_le_of_lt (smoothing_mass_bound q v hv μ)
  finiteness

lemma integrable_smoothing_power (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    Integrable (fun w : (ρ → τ → ℝ) × (ρ → ℝ) =>
      smooth v μ w.1 w.2 ^ (q + 1)) ((gaussianRows ρ τ).prod volume) := by
  have hm : Measurable (fun w : (ρ → τ → ℝ) × (ρ → ℝ) =>
      smooth v μ w.1 w.2 ^ (q + 1)) :=
    (measurable_smooth v μ).pow_const (q + 1)
  have hn (w : (ρ → τ → ℝ) × (ρ → ℝ)) :
      0 ≤ smooth v μ w.1 w.2 ^ (q + 1) :=
    pow_nonneg (smooth_nonneg v μ w.1 w.2) _
  have hfi : (∫⁻ w : (ρ → τ → ℝ) × (ρ → ℝ),
      ENNReal.ofReal (smooth v μ w.1 w.2 ^ (q + 1))
      ∂((gaussianRows ρ τ).prod volume)) < ∞ := by
    rw [lintegral_prod _ hm.ennreal_ofReal.aemeasurable]
    exact smoothing_moment_finite q v hv μ
  exact ⟨hm.aestronglyMeasurable,
    (hasFiniteIntegral_iff_ofReal (ae_of_all _ hn)).2 hfi⟩

lemma integrable_moment_kernel (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    Integrable (fun t : Fin (q + 1) → τ → ℝ =>
      (1 / (Real.sqrt (2 * Real.pi) ^ q *
        Real.sqrt (covariance v (differences (t 0) (fun i : Fin q => t i.succ))).det)) ^
          Fintype.card ρ) (Measure.pi (fun _ : Fin (q + 1) => μ)) := by
  have hdom : Integrable (fun _ : Fin (q + 1) → τ → ℝ =>
      ((Real.sqrt (2 * Real.pi * v))⁻¹ ^ q /
        Real.sqrt (countPlusOne (Fin q))) ^ Fintype.card ρ)
      (Measure.pi (fun _ : Fin (q + 1) => μ)) := integrable_const _
  apply hdom.mono'
  · apply Measurable.aestronglyMeasurable
    have hc : Continuous (fun t : Fin (q + 1) → τ → ℝ =>
        covariance v (differences (t 0) (fun i : Fin q => t i.succ))) := by
      unfold covariance differences
      fun_prop
    exact (measurable_const.div (measurable_const.mul hc.matrix_det.measurable.sqrt)).pow_const _
  · apply ae_of_all
    intro t
    rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
    exact pow_le_pow_left₀ (by positivity)
      (by simpa only [Fintype.card_fin] using
        kernel_le_coincident v hv (differences (t 0) (fun i : Fin q => t i.succ))) _

theorem smoothing_moment_real (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    (∫ w : (ρ → τ → ℝ) × (ρ → ℝ), smooth v μ w.1 w.2 ^ (q + 1)
      ∂((gaussianRows ρ τ).prod volume)) =
      ∫ t : Fin (q + 1) → τ → ℝ,
        (1 / (Real.sqrt (2 * Real.pi) ^ q *
          Real.sqrt (covariance v (differences (t 0) (fun i : Fin q => t i.succ))).det)) ^
            Fintype.card ρ
        ∂Measure.pi (fun _ : Fin (q + 1) => μ) := by
  have hnL (w : (ρ → τ → ℝ) × (ρ → ℝ)) :
      0 ≤ smooth v μ w.1 w.2 ^ (q + 1) :=
    pow_nonneg (smooth_nonneg _ _ _ _) _
  have hnR (t : Fin (q + 1) → τ → ℝ) :
      0 ≤ (1 / (Real.sqrt (2 * Real.pi) ^ q *
        Real.sqrt (covariance v (differences (t 0) (fun i : Fin q => t i.succ))).det)) ^
          Fintype.card ρ := by positivity
  apply (ENNReal.ofReal_eq_ofReal_iff (integral_nonneg hnL) (integral_nonneg hnR)).mp
  rw [ofReal_integral_eq_lintegral_ofReal (integrable_smoothing_power q v hv μ)
    (ae_of_all _ hnL),
    lintegral_prod _ ((measurable_smooth v μ).pow_const (q + 1)).ennreal_ofReal.aemeasurable,
    ofReal_integral_eq_lintegral_ofReal (integrable_moment_kernel q v hv μ)
      (ae_of_all _ hnR)]
  exact smoothing_moment q v hv μ

theorem smoothing_moment_rpow (q : ℕ) (v : ℝ) (hv : 0 < v)
    (μ : Measure (τ → ℝ)) [IsFiniteMeasure μ] :
    (∫ w : (ρ → τ → ℝ) × (ρ → ℝ), smooth v μ w.1 w.2 ^ (q + 1)
      ∂((gaussianRows ρ τ).prod volume)) =
      (2 * Real.pi) ^ (-(Fintype.card ρ : ℝ) * (q : ℝ) / 2) *
        ∫ t : Fin (q + 1) → τ → ℝ,
          (covariance v (differences (t 0) (fun i : Fin q => t i.succ))).det ^
            (-(Fintype.card ρ : ℝ) / 2)
          ∂Measure.pi (fun _ : Fin (q + 1) => μ) := by
  rw [smoothing_moment_real q v hv μ, ← integral_const_mul]
  apply integral_congr_ae
  apply ae_of_all
  intro t
  exact kernel_rpow _ _ (by positivity) (covariance_posDef v hv _).det_pos _ _

theorem manuscript_gaussian_identity (d m q : ℕ) (δ : ℝ) (hδ : 0 < δ)
    (t : Fin (q + 1) → Fin d → ℝ) :
    (∫ A : Fin m → Fin d → ℝ, (∫ y : Fin m → ℝ,
        ∏ i : Fin (q + 1), phiVec (δ ^ 2) (y - project A (t i)))
      ∂gaussianRows (Fin m) (Fin d)) =
      (2 * Real.pi) ^ (-(m : ℝ) * (q : ℝ) / 2) *
        (covariance (δ ^ 2) (differences (t 0) (fun i : Fin q => t i.succ))).det ^
          (-(m : ℝ) / 2) := by
  simpa only [Fin.prod_univ_succ, Fintype.card_fin] using
    gaussian_difference_identity_rpow (ρ := Fin m) (δ ^ 2) (by positivity)
      (t 0) (fun i : Fin q => t i.succ)

theorem coincident_collision_rpow (v : ℝ) (hv : 0 < v) (z : τ → ℝ) :
    (∫ A : ρ → τ → ℝ,
      (∫ y : ρ → ℝ, phiVec v (y - project A z) ^ (Fintype.card ι + 1))
      ∂gaussianRows ρ τ) =
      countPlusOne ι ^ (-(Fintype.card ρ : ℝ) / 2) *
        (2 * Real.pi * v) ^
          (-(Fintype.card ρ : ℝ) * (Fintype.card ι : ℝ) / 2) := by
  rw [coincident_collision (ι := ι) v hv z]
  simpa only [mul_comm] using kernel_rpow (2 * Real.pi * v) (countPlusOne ι)
    (by positivity) countPlusOne_pos (Fintype.card ι) (Fintype.card ρ)

end GaussianCollision

#print axioms GaussianCollision.manuscript_gaussian_identity
#print axioms GaussianCollision.smoothing_moment_rpow
#print axioms GaussianCollision.coincident_collision_rpow
