import Mathlib

/-!
# Supported inverse-Lyapunov Hessian metric

`b hP K` is `(3/2) ∑ i,j ‖(Uᴴ K U)ᵢⱼ‖² / (√pᵢ + √pⱼ)`, where `U`
is the canonical orthonormal eigenbasis of the positive-semidefinite matrix `P`.
`b_spectral_positive` identifies it with exactly the sum restricted to positive
eigenvalues, for supported directions. All singular endpoints are allowed.

`Supported P K` means that both `K` and `Kᴴ` annihilate `ker P`.
For Hermitian `K`, use `supported_of_hermitian`; for sandwiched perturbations,
use `supported_gram`.

The load-bearing interfaces are `sqrt_mono`, `b_antitone`, `b_three`, and
`common_metric_three`. Square-root order is proved by testing a hypothetical
negative eigenvector of `√Q - √P`, not assumed. Inverse-Lyapunov comparison is
proved by completion of squares at an explicitly constructed spectral solution,
not by strict positivity, regularization, or an inverse-order axiom.

`b_unitary`, `b_isometry`, and `b_zero_extension` supply the basis-change and
rectangular zero-padding identifications. `embed_zeroInclusion` identifies the
last construction with `Matrix.fromBlocks X 0 0 0`.
-/

open scoped MatrixOrder ComplexConjugate ComplexOrder
open Matrix Finset

noncomputable section

namespace SharedTraceHessian

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def pairing (X Y : Matrix ι ι ℂ) : ℝ := (Xᴴ * Y).trace.re

lemma pairing_add_left (X Y Z : Matrix ι ι ℂ) :
    pairing (X + Y) Z = pairing X Z + pairing Y Z := by
  simp [pairing, add_mul]

lemma pairing_add_right (X Y Z : Matrix ι ι ℂ) :
    pairing X (Y + Z) = pairing X Y + pairing X Z := by
  simp [pairing, mul_add]

lemma pairing_sub_left (X Y Z : Matrix ι ι ℂ) :
    pairing (X - Y) Z = pairing X Z - pairing Y Z := by
  simp [pairing, sub_mul]

lemma pairing_sub_right (X Y Z : Matrix ι ι ℂ) :
    pairing X (Y - Z) = pairing X Y - pairing X Z := by
  simp [pairing, mul_sub]

lemma pairing_symm (X Y : Matrix ι ι ℂ) : pairing X Y = pairing Y X := by
  have h := Matrix.trace_conjTranspose (Xᴴ * Y)
  simpa [pairing] using congrArg Complex.re h.symm

lemma pairing_smul_left (r : ℝ) (X Y : Matrix ι ι ℂ) :
    pairing (r • X) Y = r * pairing X Y := by
  simp [pairing, Matrix.smul_mul, Complex.real_smul]

lemma pairing_smul_right (r : ℝ) (X Y : Matrix ι ι ℂ) :
    pairing X (r • Y) = r * pairing X Y := by
  rw [pairing_symm, pairing_smul_left, pairing_symm]

def lyap (R X : Matrix ι ι ℂ) : Matrix ι ι ℂ := R * X + X * R

lemma lyap_sub (R X Y : Matrix ι ι ℂ) :
    lyap R (X - Y) = lyap R X - lyap R Y := by
  unfold lyap
  noncomm_ring

lemma lyap_add (R X Y : Matrix ι ι ℂ) :
    lyap R (X + Y) = lyap R X + lyap R Y := by
  unfold lyap
  noncomm_ring

lemma lyap_smul (r : ℝ) (R X : Matrix ι ι ℂ) :
    lyap R (r • X) = r • lyap R X := by
  simp [lyap, Matrix.mul_smul, Matrix.smul_mul, smul_add]

lemma pairing_lyap_symm {R : Matrix ι ι ℂ} (hR : R.IsHermitian)
    (X Y : Matrix ι ι ℂ) :
    pairing X (lyap R Y) = pairing (lyap R X) Y := by
  simp only [pairing, lyap, Matrix.conjTranspose_add, Matrix.conjTranspose_mul,
    hR.eq, Matrix.mul_add, Matrix.add_mul, Matrix.trace_add, map_add]
  rw [Matrix.mul_assoc, Matrix.trace_mul_cycle R Xᴴ Y]
  simp only [Matrix.mul_assoc]
  rw [Matrix.trace_mul_comm Xᴴ (Y * R)]
  simp only [Matrix.mul_assoc]

lemma pairing_lyap_nonneg {R : Matrix ι ι ℂ} (hR : R.PosSemidef)
    (X : Matrix ι ι ℂ) : 0 ≤ pairing X (lyap R X) := by
  have h₁ := (hR.conjTranspose_mul_mul_same X).trace_nonneg
  have h₂ := (hR.conjTranspose_mul_mul_same Xᴴ).trace_nonneg
  have h₁' : 0 ≤ (Xᴴ * R * X).trace.re := (Complex.nonneg_iff.mp h₁).1
  have h₂' : 0 ≤ (X * R * Xᴴ).trace.re := by
    simpa using (Complex.nonneg_iff.mp h₂).1
  unfold pairing lyap
  rw [Matrix.mul_add, Matrix.trace_add, Complex.add_re]
  simp_rw [← Matrix.mul_assoc]
  rw [Matrix.trace_mul_comm (Xᴴ * X) R, ← Matrix.mul_assoc,
    Matrix.trace_mul_cycle R Xᴴ X]
  exact add_nonneg h₁' h₂'

lemma pairing_lyap_mono {R S : Matrix ι ι ℂ} (h : R ≤ S)
    (X : Matrix ι ι ℂ) : pairing X (lyap R X) ≤ pairing X (lyap S X) := by
  have hn := pairing_lyap_nonneg h X
  have he : lyap (S - R) X = lyap S X - lyap R X := by
    unfold lyap
    noncomm_ring
  rw [he, pairing_sub_right] at hn
  linarith

lemma dot_adjoint (A : Matrix ι ι ℂ) (x y : ι → ℂ) :
    star x ⬝ᵥ (A *ᵥ y) = star (Aᴴ *ᵥ x) ⬝ᵥ y := by
  rw [Matrix.star_mulVec, Matrix.conjTranspose_conjTranspose, Matrix.dotProduct_mulVec]

/-- Finite-dimensional square-order implication, with no inverse or strict-positivity
assumption. The proof tests a negative eigenvector of `B-A`. -/
theorem le_of_sq_le_sq {A B : Matrix ι ι ℂ} (hA : A.IsHermitian)
    (hB : B.PosSemidef) (h : A * A ≤ B * B) : A ≤ B := by
  have hC : (B - A).IsHermitian := hB.1.sub hA
  apply hC.posSemidef_iff_eigenvalues_nonneg.mpr
  intro i
  let x : ι → ℂ := (hC.eigenvectorBasis i).ofLp
  let t : ℝ := hC.eigenvalues i
  have he : (B - A) *ᵥ x = t • x := hC.mulVec_eigenvectorBasis i
  have hx : star x ⬝ᵥ x = 1 := by
    rw [dotProduct_comm, ← EuclideanSpace.inner_eq_star_dotProduct]
    simp [x, inner_self_eq_norm_sq_to_K, hC.eigenvectorBasis.orthonormal.1]
  have ha : A *ᵥ x = B *ᵥ x - t • x := by
    rw [Matrix.sub_mulVec] at he
    exact eq_sub_of_add_eq (by simpa [add_comm] using (sub_eq_iff_eq_add.mp he).symm)
  have hn := h.dotProduct_mulVec_nonneg x
  have hb := hB.dotProduct_mulVec_nonneg x
  have hb' : 0 ≤ (star x ⬝ᵥ (B *ᵥ x)).re := (Complex.nonneg_iff.mp hb).1
  have hreal : 0 ≤ (star x ⬝ᵥ ((B * B - A * A) *ᵥ x)).re :=
    (Complex.nonneg_iff.mp hn).1
  have hadjB : star x ⬝ᵥ (B *ᵥ (B *ᵥ x)) =
      star (B *ᵥ x) ⬝ᵥ (B *ᵥ x) := by
    rw [dot_adjoint, hB.1.eq]
  have hadjA : star x ⬝ᵥ (A *ᵥ (A *ᵥ x)) =
      star (A *ᵥ x) ⬝ᵥ (A *ᵥ x) := by
    rw [dot_adjoint, hA.eq]
  have hcross : star (B *ᵥ x) ⬝ᵥ x = star x ⬝ᵥ (B *ᵥ x) := by
    rw [dot_adjoint, hB.1.eq]
  rw [Matrix.sub_mulVec, dotProduct_sub, ← Matrix.mulVec_mulVec,
    ← Matrix.mulVec_mulVec, hadjB, hadjA, ha] at hreal
  simp only [star_sub, dotProduct_sub, sub_dotProduct, star_smul, star_trivial,
    smul_dotProduct, dotProduct_smul, hcross, hx, smul_eq_mul] at hreal
  simp only [Complex.sub_re, Complex.add_re, Complex.real_smul, Complex.mul_re,
    Complex.ofReal_re, Complex.ofReal_im, mul_zero, zero_mul, sub_zero, Complex.one_re,
    smul_eq_mul] at hreal
  change 0 ≤ t
  by_contra ht
  have ht' : t ≤ 0 := le_of_lt (lt_of_not_ge ht)
  have hm := mul_nonpos_of_nonpos_of_nonneg ht' hb'
  nlinarith [sq_nonneg t]

theorem sqrt_mono {P Q : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hQ : Q.PosSemidef) (h : P ≤ Q) : CFC.sqrt P ≤ CFC.sqrt Q := by
  apply le_of_sq_le_sq (CFC.sqrt_nonneg P).posSemidef.1
    (CFC.sqrt_nonneg Q).posSemidef
  simpa only [CFC.sqrt_mul_sqrt_self P hP.nonneg,
    CFC.sqrt_mul_sqrt_self Q hQ.nonneg] using h

def rotate (U : Matrix.unitaryGroup ι ℂ) (X : Matrix ι ι ℂ) :
    Matrix ι ι ℂ := Unitary.conjStarAlgAut ℂ _ U X

lemma rotate_eq (U : Matrix.unitaryGroup ι ℂ) (X : Matrix ι ι ℂ) :
    rotate U X = (U : Matrix ι ι ℂ) * X * (star U : Matrix ι ι ℂ) := rfl

lemma trace_rotate (U : Matrix.unitaryGroup ι ℂ) (X : Matrix ι ι ℂ) :
    (rotate U X).trace = X.trace := by
  rw [rotate_eq, Matrix.trace_mul_cycle]
  simp [Unitary.coe_star_mul_self]

lemma pairing_rotate (U : Matrix.unitaryGroup ι ℂ) (X Y : Matrix ι ι ℂ) :
    pairing (rotate U X) (rotate U Y) = pairing X Y := by
  change (star (rotate U X) * rotate U Y).trace.re = _
  change (star (Unitary.conjStarAlgAut ℂ _ U X) *
    Unitary.conjStarAlgAut ℂ _ U Y).trace.re = _
  rw [← map_star, ← map_mul]
  change (rotate U (star X * Y)).trace.re = _
  rw [trace_rotate]
  rfl

lemma lyap_rotate (U : Matrix.unitaryGroup ι ℂ) (R X : Matrix ι ι ℂ) :
    lyap (rotate U R) (rotate U X) = rotate U (lyap R X) := by
  simp [lyap, rotate, map_add, map_mul]

lemma rotate_star_rotate (U : Matrix.unitaryGroup ι ℂ) (X : Matrix ι ι ℂ) :
    rotate (star U) (rotate U X) = X := by
  simp [rotate_eq, ← Matrix.mul_assoc]
  rw [Matrix.mul_assoc, Unitary.coe_star_mul_self, Matrix.mul_one]

lemma rotate_rotate_star (U : Matrix.unitaryGroup ι ℂ) (X : Matrix ι ι ℂ) :
    rotate U (rotate (star U) X) = X := by
  simpa only [star_star] using rotate_star_rotate (star U) X

def coordinates {P : Matrix ι ι ℂ} (hP : P.PosSemidef) (K : Matrix ι ι ℂ) :
    Matrix ι ι ℂ := rotate (star hP.1.eigenvectorUnitary) K

def rootDiagonal {P : Matrix ι ι ℂ} (hP : P.PosSemidef) : Matrix ι ι ℂ :=
  Matrix.diagonal fun i => (Real.sqrt (hP.1.eigenvalues i) : ℂ)

lemma sqrt_spectral {P : Matrix ι ι ℂ} (hP : P.PosSemidef) :
    CFC.sqrt P = rotate hP.1.eigenvectorUnitary (rootDiagonal hP) := by
  rw [CFC.sqrt_eq_cfc, cfc_nnreal_eq_real _ P, hP.1.cfc_eq]
  simp [Matrix.IsHermitian.cfc, rotate, rootDiagonal, Function.comp_def,
    Real.coe_toNNReal', max_eq_left (hP.eigenvalues_nonneg _)]

def weight {P : Matrix ι ι ℂ} (hP : P.PosSemidef) (i j : ι) : ℝ :=
  Real.sqrt (hP.1.eigenvalues i) + Real.sqrt (hP.1.eigenvalues j)

/-- The spectral formula, with real division by zero equal to zero. On supported
directions all terms touching a zero eigenvalue vanish. -/
def b {P : Matrix ι ι ℂ} (hP : P.PosSemidef) (K : Matrix ι ι ℂ) : ℝ :=
  (3 / 2 : ℝ) * ∑ i, ∑ j, Complex.normSq (coordinates hP K i j) / weight hP i j

def spectralSolution {P : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (K : Matrix ι ι ℂ) : Matrix ι ι ℂ :=
  rotate hP.1.eigenvectorUnitary
    (fun i j => coordinates hP K i j / (weight hP i j : ℂ))

/-- Two-sided support. For Hermitian `K`, ordinary annihilation of `ker P`
implies this predicate. -/
def Supported (P K : Matrix ι ι ℂ) : Prop :=
  ∀ x : ι → ℂ, P *ᵥ x = 0 → K *ᵥ x = 0 ∧ Kᴴ *ᵥ x = 0

lemma supported_of_hermitian {P K : Matrix ι ι ℂ} (hK : K.IsHermitian)
    (h : ∀ x : ι → ℂ, P *ᵥ x = 0 → K *ᵥ x = 0) : Supported P K := by
  intro x hx
  exact ⟨h x hx, by simpa [hK.eq] using h x hx⟩

lemma supported_mono {P Q K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hQ : Q.PosSemidef) (h : P ≤ Q) (hK : Supported P K) : Supported Q K := by
  intro x hx
  apply hK x
  apply (hP.dotProduct_mulVec_zero_iff x).mp
  have h₁ := hP.dotProduct_mulVec_nonneg x
  have h₂ := h.dotProduct_mulVec_nonneg x
  have he : star x ⬝ᵥ (P *ᵥ x) = 0 := by
    apply le_antisymm
    · simpa [Matrix.sub_mulVec, dotProduct_sub, hx] using h₂
    · exact h₁
  exact he

lemma pairing_entries (X Y : Matrix ι ι ℂ) :
    pairing X Y = ∑ i, ∑ j, (star (X i j) * Y i j).re := by
  simp only [pairing, Matrix.trace, Matrix.diag_apply, Matrix.mul_apply,
    Matrix.conjTranspose_apply, Complex.re_sum]
  exact Finset.sum_comm

lemma lyap_diagonal (r : ι → ℝ) (X : Matrix ι ι ℂ) (i j : ι) :
    lyap (Matrix.diagonal fun i => (r i : ℂ)) X i j =
      ((r i + r j : ℝ) : ℂ) * X i j := by
  simp [lyap, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

lemma spectralSolution_pairing {P : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (K : Matrix ι ι ℂ) :
    (3 / 2 : ℝ) * pairing K (spectralSolution hP K) = b hP K := by
  have hk : K = rotate hP.1.eigenvectorUnitary (coordinates hP K) := by
    symm
    exact rotate_rotate_star hP.1.eigenvectorUnitary K
  have hp := pairing_rotate hP.1.eigenvectorUnitary (coordinates hP K)
    (fun i j => coordinates hP K i j / (weight hP i j : ℂ))
  rw [← hk] at hp
  change pairing K (spectralSolution hP K) = _ at hp
  rw [hp, pairing_entries]
  unfold b
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  have he : star (coordinates hP K i j) * coordinates hP K i j =
      (Complex.normSq (coordinates hP K i j) : ℂ) :=
    Complex.normSq_eq_conj_mul_self.symm
  rw [← mul_div_assoc, he]
  simp

lemma variational_bound {R K Y : Matrix ι ι ℂ} (hR : R.PosSemidef)
    (hY : lyap R Y = K) (X : Matrix ι ι ℂ) :
    2 * pairing K X - pairing X (lyap R X) ≤ pairing K Y := by
  have hn := pairing_lyap_nonneg hR (X - Y)
  rw [lyap_sub, pairing_sub_left, pairing_sub_right, pairing_sub_right, hY] at hn
  have hc : pairing Y (lyap R X) = pairing K X := by
    rw [pairing_lyap_symm hR.1, hY]
  rw [hc, pairing_symm X K, pairing_symm Y K] at hn
  linarith

lemma coordinates_zero_col {P K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hK : Supported P K) {j : ι} (hj : hP.1.eigenvalues j = 0) (i : ι) :
    coordinates hP K i j = 0 := by
  let U := hP.1.eigenvectorUnitary
  let x : ι → ℂ := (hP.1.eigenvectorBasis j).ofLp
  have hx : P *ᵥ x = 0 := by
    rw [hP.1.mulVec_eigenvectorBasis, hj, zero_smul]
  have hk := (hK x hx).1
  have hc (k : ι) : (K * (U : Matrix ι ι ℂ)) k j = 0 := by
    change (K *ᵥ x) k = 0
    exact congrFun hk k
  unfold coordinates
  rw [rotate_eq]
  simp only [Unitary.coe_star, star_star]
  change (((star U : Matrix ι ι ℂ) * K * (U : Matrix ι ι ℂ)) i j) = 0
  rw [Matrix.mul_assoc, Matrix.mul_apply]
  simp only [hc, mul_zero, Finset.sum_const_zero]

lemma spectralSolution_eq {P K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hK : Supported P K) : lyap (CFC.sqrt P) (spectralSolution hP K) = K := by
  rw [sqrt_spectral hP, spectralSolution, lyap_rotate]
  have he : lyap (rootDiagonal hP)
      (fun i j => coordinates hP K i j / (weight hP i j : ℂ)) =
      coordinates hP K := by
    ext i j
    rw [rootDiagonal, lyap_diagonal]
    change (weight hP i j : ℂ) *
      (coordinates hP K i j / (weight hP i j : ℂ)) = coordinates hP K i j
    by_cases hz : weight hP i j = 0
    · have hs : Real.sqrt (hP.1.eigenvalues j) = 0 := by
        unfold weight at hz
        nlinarith [Real.sqrt_nonneg (hP.1.eigenvalues i),
          Real.sqrt_nonneg (hP.1.eigenvalues j)]
      have hj : hP.1.eigenvalues j = 0 := by
        nlinarith [Real.sq_sqrt (hP.eigenvalues_nonneg j)]
      rw [coordinates_zero_col hP hK hj i]
      simp
    · exact mul_div_cancel₀ _ (by exact_mod_cast hz)
  rw [he]
  exact rotate_rotate_star hP.1.eigenvectorUnitary K

/-- Antitonicity of the actual spectral Hessian metric on supported directions,
including singular endpoints. -/
theorem b_antitone {P Q K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hQ : Q.PosSemidef) (h : P ≤ Q) (hK : Supported P K) :
    b hQ K ≤ b hP K := by
  let X := spectralSolution hQ K
  have hX : lyap (CFC.sqrt Q) X = K :=
    spectralSolution_eq hQ (supported_mono hP hQ h hK)
  have hv := variational_bound (CFC.sqrt_nonneg P).posSemidef
    (spectralSolution_eq hP hK) X
  have hm := pairing_lyap_mono (sqrt_mono hP hQ h) X
  rw [hX, pairing_symm X K] at hm
  have hb : pairing K X ≤ pairing K (spectralSolution hP K) := by linarith
  rw [← spectralSolution_pairing hQ K, ← spectralSolution_pairing hP K]
  exact mul_le_mul_of_nonneg_left hb (by norm_num)

lemma supported_add {P K L : Matrix ι ι ℂ} (hK : Supported P K)
    (hL : Supported P L) : Supported P (K + L) := by
  intro x hx
  rcases hK x hx with ⟨hk, hk'⟩
  rcases hL x hx with ⟨hl, hl'⟩
  simp [Matrix.add_mulVec, hk, hl, hk', hl']

/-- Three-vector quadratic inequality, in a common supported metric. -/
theorem b_three {Q K₁ K₂ K₃ : Matrix ι ι ℂ} (hQ : Q.PosSemidef)
    (h₁ : Supported Q K₁) (h₂ : Supported Q K₂) (h₃ : Supported Q K₃) :
    (1 / 3 : ℝ) * b hQ (K₁ + K₂ + K₃) ≤
      b hQ K₁ + b hQ K₂ + b hQ K₃ := by
  let K := K₁ + K₂ + K₃
  let Y := spectralSolution hQ K
  let X := (1 / 3 : ℝ) • Y
  have hY : lyap (CFC.sqrt Q) Y = K :=
    spectralSolution_eq hQ (supported_add (supported_add h₁ h₂) h₃)
  have v₁ := variational_bound (CFC.sqrt_nonneg Q).posSemidef
    (spectralSolution_eq hQ h₁) X
  have v₂ := variational_bound (CFC.sqrt_nonneg Q).posSemidef
    (spectralSolution_eq hQ h₂) X
  have v₃ := variational_bound (CFC.sqrt_nonneg Q).posSemidef
    (spectralSolution_eq hQ h₃) X
  have hsum : pairing K₁ X + pairing K₂ X + pairing K₃ X = pairing K X := by
    simp [K, pairing_add_left]
  have hxy : pairing X (lyap (CFC.sqrt Q) X) =
      (1 / 9 : ℝ) * pairing K Y := by
    dsimp [X]
    rw [lyap_smul, hY, pairing_smul_left, pairing_smul_right, pairing_symm Y K]
    ring
  have hkx : pairing K X = (1 / 3 : ℝ) * pairing K Y :=
    pairing_smul_right _ _ _
  rw [← spectralSolution_pairing hQ K₁, ← spectralSolution_pairing hQ K₂,
    ← spectralSolution_pairing hQ K₃, ← spectralSolution_pairing hQ (K₁ + K₂ + K₃)]
  change (1 / 3 : ℝ) * ((3 / 2 : ℝ) * pairing K Y) ≤ _
  nlinarith

theorem b_nonneg {P : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (K : Matrix ι ι ℂ) : 0 ≤ b hP K := by
  apply mul_nonneg (by norm_num)
  apply Finset.sum_nonneg
  intro i hi
  apply Finset.sum_nonneg
  intro j hj
  exact div_nonneg (Complex.normSq_nonneg _) (add_nonneg (Real.sqrt_nonneg _)
    (Real.sqrt_nonneg _))

theorem b_antitone_of_hermitian {P Q K : Matrix ι ι ℂ}
    (hP : P.PosSemidef) (hQ : Q.PosSemidef) (h : P ≤ Q)
    (hK : K.IsHermitian) (hs : ∀ x : ι → ℂ, P *ᵥ x = 0 → K *ᵥ x = 0) :
    b hQ K ≤ b hP K :=
  b_antitone hP hQ h (supported_of_hermitian hK hs)

/-- The complete common-metric bridge. No invertibility hypotheses occur. -/
theorem common_metric_three {A₁ A₂ A₃ Q K₁ K₂ K₃ : Matrix ι ι ℂ}
    (h₁ : A₁.PosSemidef) (h₂ : A₂.PosSemidef) (h₃ : A₃.PosSemidef)
    (hQ : Q.PosSemidef) (hle₁ : A₁ ≤ Q) (hle₂ : A₂ ≤ Q) (hle₃ : A₃ ≤ Q)
    (hs₁ : Supported A₁ K₁) (hs₂ : Supported A₂ K₂) (hs₃ : Supported A₃ K₃) :
    (1 / 3 : ℝ) * b hQ (K₁ + K₂ + K₃) ≤
      b h₁ K₁ + b h₂ K₂ + b h₃ K₃ := by
  have hv := b_three hQ (supported_mono h₁ hQ hle₁ hs₁)
    (supported_mono h₂ hQ hle₂ hs₂) (supported_mono h₃ hQ hle₃ hs₃)
  have v₁ := b_antitone h₁ hQ hle₁ hs₁
  have v₂ := b_antitone h₂ hQ hle₂ hs₂
  have v₃ := b_antitone h₃ hQ hle₃ hs₃
  linarith

lemma b_eq_of_solution {P K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hK : Supported P K) {Y : Matrix ι ι ℂ} (hY : lyap (CFC.sqrt P) Y = K) :
    b hP K = (3 / 2 : ℝ) * pairing K Y := by
  have hS := spectralSolution_eq hP hK
  have v₁ := variational_bound (CFC.sqrt_nonneg P).posSemidef hS Y
  have v₂ := variational_bound (CFC.sqrt_nonneg P).posSemidef hY
    (spectralSolution hP K)
  rw [hY, pairing_symm Y K] at v₁
  rw [hS, pairing_symm (spectralSolution hP K) K] at v₂
  rw [← spectralSolution_pairing hP K]
  congr 1
  linarith

lemma rotate_posSemidef (U : Matrix.unitaryGroup ι ℂ)
    {P : Matrix ι ι ℂ} (hP : P.PosSemidef) : (rotate U P).PosSemidef := by
  have h := hP.conjTranspose_mul_mul_same (star (U : Matrix ι ι ℂ))
  simpa only [Matrix.star_eq_conjTranspose, Matrix.conjTranspose_conjTranspose,
    rotate_eq] using h

lemma sqrt_rotate (U : Matrix.unitaryGroup ι ℂ)
    {P : Matrix ι ι ℂ} (hP : P.PosSemidef) :
    CFC.sqrt (rotate U P) = rotate U (CFC.sqrt P) := by
  apply (CFC.sqrt_eq_iff _ _ (rotate_posSemidef U hP).nonneg
    (rotate_posSemidef U (CFC.sqrt_nonneg P).posSemidef).nonneg).mpr
  change Unitary.conjStarAlgAut ℂ _ U (CFC.sqrt P) *
    Unitary.conjStarAlgAut ℂ _ U (CFC.sqrt P) = _
  rw [← map_mul, CFC.sqrt_mul_sqrt_self P hP.nonneg]
  rfl

lemma mulVec_rotate (U : Matrix.unitaryGroup ι ℂ) (P : Matrix ι ι ℂ)
    (x : ι → ℂ) :
    rotate U P *ᵥ x = (U : Matrix ι ι ℂ) *ᵥ
      (P *ᵥ ((star U : Matrix ι ι ℂ) *ᵥ x)) := by
  simp only [rotate_eq, Matrix.mulVec_mulVec, Matrix.mul_assoc]

lemma rotate_supported (U : Matrix.unitaryGroup ι ℂ)
    {P K : Matrix ι ι ℂ} (hK : Supported P K) :
    Supported (rotate U P) (rotate U K) := by
  intro x hx
  have hx' := congrArg (fun y => (star U : Matrix ι ι ℂ) *ᵥ y) hx
  rw [mulVec_rotate] at hx'
  rw [Matrix.mulVec_mulVec, Unitary.coe_star_mul_self, Matrix.one_mulVec,
    Matrix.mulVec_zero] at hx'
  rcases hK _ hx' with ⟨hk, hk'⟩
  constructor
  · rw [mulVec_rotate, hk, Matrix.mulVec_zero]
  · have he : (rotate U K)ᴴ = rotate U Kᴴ := by
      exact (map_star (Unitary.conjStarAlgAut ℂ _ U) K).symm
    rw [he, mulVec_rotate, hk', Matrix.mulVec_zero]

/-- Basis-independent identification of the spectral formula, valid on supports
even when the base matrix is singular. -/
theorem b_unitary (U : Matrix.unitaryGroup ι ℂ)
    {P K : Matrix ι ι ℂ} (hP : P.PosSemidef) (hK : Supported P K) :
    b (rotate_posSemidef U hP) (rotate U K) = b hP K := by
  rw [b_eq_of_solution (rotate_posSemidef U hP) (rotate_supported U hK)
    (Y := rotate U (spectralSolution hP K)) (by
      rw [sqrt_rotate U hP, lyap_rotate, spectralSolution_eq hP hK])]
  rw [pairing_rotate, spectralSolution_pairing]

lemma coordinates_zero_row {P K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hK : Supported P K) {i : ι} (hi : hP.1.eigenvalues i = 0) (j : ι) :
    coordinates hP K i j = 0 := by
  have hs : Supported P Kᴴ := by
    intro x hx
    simpa only [Matrix.conjTranspose_conjTranspose, and_comm] using hK x hx
  have hz := coordinates_zero_col hP hs hi j
  have he : coordinates hP Kᴴ = (coordinates hP K)ᴴ :=
    map_star (Unitary.conjStarAlgAut ℂ _ (star hP.1.eigenvectorUnitary)) K
  rw [he, Matrix.conjTranspose_apply] at hz
  exact star_eq_zero.mp hz

/-- Precisely the sum over pairs of positive eigenvalues stated in the manuscript.
The entries are in the canonical orthonormal eigenbasis of `P`. -/
theorem b_spectral_positive {P K : Matrix ι ι ℂ} (hP : P.PosSemidef)
    (hK : Supported P K) :
    b hP K = (3 / 2 : ℝ) *
      ∑ i ∈ (Finset.univ.filter fun i => 0 < hP.1.eigenvalues i),
      ∑ j ∈ (Finset.univ.filter fun j => 0 < hP.1.eigenvalues j),
        Complex.normSq (coordinates hP K i j) /
          (Real.sqrt (hP.1.eigenvalues i) + Real.sqrt (hP.1.eigenvalues j)) := by
  unfold b weight
  congr 1
  simp only [Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro i hi
  by_cases hp : 0 < hP.1.eigenvalues i
  · simp only [if_pos hp]
    apply Finset.sum_congr rfl
    intro j hj
    by_cases hq : 0 < hP.1.eigenvalues j
    · simp [hq]
    · have hz : hP.1.eigenvalues j = 0 :=
        le_antisymm (le_of_not_gt hq) (hP.eigenvalues_nonneg j)
      simp [hq, coordinates_zero_col hP hK hz i]
  · have hz : hP.1.eigenvalues i = 0 :=
      le_antisymm (le_of_not_gt hp) (hP.eigenvalues_nonneg i)
    simp [hp, coordinates_zero_row hP hK hz]

section Rectangular

variable {κ : Type*} [Fintype κ] [DecidableEq κ]

/-- Isometric congruence, allowing rectangular embeddings and zero padding. -/
def embed (V : Matrix κ ι ℂ) (X : Matrix ι ι ℂ) : Matrix κ κ ℂ :=
  V * X * Vᴴ

lemma embed_posSemidef (V : Matrix κ ι ℂ) {P : Matrix ι ι ℂ}
    (hP : P.PosSemidef) : (embed V P).PosSemidef := by
  simpa only [embed, Matrix.conjTranspose_conjTranspose] using
    hP.conjTranspose_mul_mul_same Vᴴ

lemma embed_mul (V : Matrix κ ι ℂ) (hV : Vᴴ * V = 1)
    (X Y : Matrix ι ι ℂ) : embed V X * embed V Y = embed V (X * Y) := by
  have hc (T : Matrix ι κ ℂ) : Vᴴ * (V * T) = T := by
    rw [← Matrix.mul_assoc, hV, Matrix.one_mul]
  simp only [embed, Matrix.mul_assoc, hc]

lemma embed_conjTranspose (V : Matrix κ ι ℂ) (X : Matrix ι ι ℂ) :
    (embed V X)ᴴ = embed V Xᴴ := by
  simp [embed, Matrix.mul_assoc]

lemma trace_embed (V : Matrix κ ι ℂ) (hV : Vᴴ * V = 1)
    (X : Matrix ι ι ℂ) : (embed V X).trace = X.trace := by
  rw [embed, Matrix.trace_mul_cycle, hV, Matrix.one_mul]

lemma pairing_embed (V : Matrix κ ι ℂ) (hV : Vᴴ * V = 1)
    (X Y : Matrix ι ι ℂ) :
    pairing (embed V X) (embed V Y) = pairing X Y := by
  unfold pairing
  rw [embed_conjTranspose, embed_mul V hV, trace_embed V hV]

lemma lyap_embed (V : Matrix κ ι ℂ) (hV : Vᴴ * V = 1)
    (R X : Matrix ι ι ℂ) :
    lyap (embed V R) (embed V X) = embed V (lyap R X) := by
  rw [lyap, embed_mul V hV, embed_mul V hV]
  simp [lyap, embed, Matrix.mul_add, Matrix.add_mul]

lemma sqrt_embed (V : Matrix κ ι ℂ) (hV : Vᴴ * V = 1)
    {P : Matrix ι ι ℂ} (hP : P.PosSemidef) :
    CFC.sqrt (embed V P) = embed V (CFC.sqrt P) := by
  apply (CFC.sqrt_eq_iff _ _ (embed_posSemidef V hP).nonneg
    (embed_posSemidef V (CFC.sqrt_nonneg P).posSemidef).nonneg).mpr
  rw [embed_mul V hV, CFC.sqrt_mul_sqrt_self P hP.nonneg]

lemma mulVec_embed (V : Matrix κ ι ℂ) (X : Matrix ι ι ℂ) (x : κ → ℂ) :
    embed V X *ᵥ x = V *ᵥ (X *ᵥ (Vᴴ *ᵥ x)) := by
  simp only [embed, Matrix.mulVec_mulVec, Matrix.mul_assoc]

lemma embed_supported (V : Matrix κ ι ℂ) {P K : Matrix ι ι ℂ}
    (hP : P.PosSemidef) (hK : Supported P K) :
    Supported (embed V P) (embed V K) := by
  intro x hx
  have he : star (Vᴴ *ᵥ x) ⬝ᵥ (P *ᵥ (Vᴴ *ᵥ x)) =
      star x ⬝ᵥ (embed V P *ᵥ x) := by
    rw [Matrix.star_mulVec, Matrix.conjTranspose_conjTranspose,
      ← Matrix.dotProduct_mulVec, mulVec_embed]
  have hp : P *ᵥ (Vᴴ *ᵥ x) = 0 := by
    apply (hP.dotProduct_mulVec_zero_iff _).mp
    rw [he, hx, dotProduct_zero]
  rcases hK _ hp with ⟨hk, hk'⟩
  constructor
  · rw [mulVec_embed, hk, Matrix.mulVec_zero]
  · rw [embed_conjTranspose, mulVec_embed, hk', Matrix.mulVec_zero]

/-- Rectangular-isometry invariance, stronger than unitary invariance. In particular,
adding any zero rows and columns leaves the supported Hessian cost unchanged. -/
theorem b_isometry (V : Matrix κ ι ℂ) (hV : Vᴴ * V = 1)
    {P K : Matrix ι ι ℂ} (hP : P.PosSemidef) (hK : Supported P K) :
    b (embed_posSemidef V hP) (embed V K) = b hP K := by
  rw [b_eq_of_solution (embed_posSemidef V hP) (embed_supported V hP hK)
    (Y := embed V (spectralSolution hP K)) (by
      rw [sqrt_embed V hV hP, lyap_embed V hV, spectralSolution_eq hP hK])]
  rw [pairing_embed V hV, spectralSolution_pairing]

def zeroInclusion : Matrix (ι ⊕ κ) ι ℂ :=
  Matrix.fromRows (1 : Matrix ι ι ℂ) (0 : Matrix κ ι ℂ)

lemma zeroInclusion_isometry :
    (zeroInclusion (ι := ι) (κ := κ))ᴴ *
      zeroInclusion (ι := ι) (κ := κ) = 1 := by
  simp [zeroInclusion, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromCols_mul_fromRows]

lemma embed_zeroInclusion (X : Matrix ι ι ℂ) :
    embed (zeroInclusion (κ := κ)) X =
      Matrix.fromBlocks X (0 : Matrix ι κ ℂ) (0 : Matrix κ ι ℂ) 0 := by
  simp [embed, zeroInclusion, Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
    Matrix.fromRows_mul, Matrix.fromRows_mul_fromCols]
  ext i j
  cases i <;> cases j <;> rfl

theorem b_zero_extension {P K : Matrix ι ι ℂ}
    (hP : P.PosSemidef) (hK : Supported P K) :
    b (embed_posSemidef (zeroInclusion (κ := κ)) hP)
      (embed zeroInclusion K) = b hP K :=
  b_isometry zeroInclusion zeroInclusion_isometry hP hK

/-- Every sandwiched perturbation is supported on its Gram base, including
rank-deficient rectangular factors. No Hermiticity of `D` is required. -/
theorem supported_gram (B : Matrix κ ι ℂ) (D : Matrix κ κ ℂ) :
    Supported (Bᴴ * B) (Bᴴ * D * B) := by
  intro x hx
  have hd : star (B *ᵥ x) ⬝ᵥ (B *ᵥ x) = 0 := by
    rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec,
      Matrix.mulVec_mulVec, hx, dotProduct_zero]
  have hb : B *ᵥ x = 0 := by
    exact dotProduct_star_self_eq_zero.mp hd
  constructor
  · simp [← Matrix.mulVec_mulVec, hb]
  · simp [← Matrix.mulVec_mulVec, hb]

end Rectangular

lemma vertex_gram {M E : Matrix ι ι ℂ} (hM : M.IsHermitian)
    (hE : E.IsHermitian) (hEE : E * E = E) :
    (E * M)ᴴ * (E * M) = M * E * M := by
  simp only [Matrix.conjTranspose_mul, hM.eq, hE.eq]
  calc
    M * E * (E * M) = M * (E * E) * M := by noncomm_ring
    _ = _ := by rw [hEE]

lemma vertex_direction {M E D : Matrix ι ι ℂ} (hM : M.IsHermitian)
    (hE : E.IsHermitian) (hEE : E * E = E) (hED : E * D = D * E) :
    (E * M)ᴴ * D * (E * M) = M * E * D * M := by
  have he : E * D * E = E * D := by
    rw [hED, Matrix.mul_assoc, hEE]
  simp only [Matrix.conjTranspose_mul, hM.eq, hE.eq]
  calc
    M * E * D * (E * M) = M * (E * D * E) * M := by noncomm_ring
    _ = _ := by rw [he]; noncomm_ring

/-- The kernel hypothesis required by the common-metric bridge follows directly
for a Hermitian `M` and an orthogonal vertex projection commuting with `D`. -/
theorem supported_vertex {M E D : Matrix ι ι ℂ} (hM : M.IsHermitian)
    (hE : E.IsHermitian) (hEE : E * E = E) (hED : E * D = D * E) :
    Supported (M * E * M) (M * E * D * M) := by
  have h := supported_gram (E * M) D
  rwa [vertex_gram hM hE hEE, vertex_direction hM hE hEE hED] at h

theorem vertex_posSemidef {M E : Matrix ι ι ℂ} (hM : M.IsHermitian)
    (hE : E.IsHermitian) (hEE : E * E = E) : (M * E * M).PosSemidef := by
  have h := Matrix.posSemidef_conjTranspose_mul_self (E * M)
  rwa [vertex_gram hM hE hEE] at h

theorem vertex_le_square {M E : Matrix ι ι ℂ} (hM : M.IsHermitian)
    (hE : E.IsHermitian) (hEE : E * E = E) : M * E * M ≤ M * M := by
  have he : (1 - E)ᴴ * (1 - E) = 1 - E := by
    simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hE.eq]
    calc
      (1 - E) * (1 - E) = 1 - E - E + E * E := by noncomm_ring
      _ = 1 - E := by rw [hEE]; abel
  have hp : (1 - E).PosSemidef := by
    rw [← he]
    exact Matrix.posSemidef_conjTranspose_mul_self _
  have h := hp.conjTranspose_mul_mul_same M
  have hm : Mᴴ * (1 - E) * M = M * M - M * E * M := by
    rw [hM.eq]
    noncomm_ring
  rwa [hm] at h

end SharedTraceHessian
