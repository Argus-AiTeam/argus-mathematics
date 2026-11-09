import Mathlib

/-!
# Lorentz/contact algebra in arbitrary real inner-product spaces

The jet definitions are the explicit first-order quotient/product-rule expressions,
not hypotheses asserting the conclusion about the differential.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace LorentzContact

section InnerProduct

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

def boost (a : E) (C : ℝ) (w : E) : E :=
  w + ((C - 1) * ⟪a, w⟫_ℝ) • a

def denominator (a N : E) (C S : ℝ) : ℝ :=
  C - S * ⟪a, N⟫_ℝ

def normalNumerator (a N : E) (C S : ℝ) : E :=
  boost a C N - S • a

def transformedNormal (a N : E) (C S : ℝ) : E :=
  (denominator a N C S)⁻¹ • normalNumerator a N C S

def tangentTransport (a N : E) (C S : ℝ) (w : E) : E :=
  boost a C w + (S * ⟪a, w⟫_ℝ) • transformedNormal a N C S

theorem boost_add (a : E) (C : ℝ) (w u : E) :
    boost a C (w + u) = boost a C w + boost a C u := by
  simp only [boost, inner_add_right, mul_add, add_smul]
  abel

theorem boost_smul (a : E) (C t : ℝ) (w : E) :
    boost a C (t • w) = t • boost a C w := by
  simp only [boost, real_inner_smul_right]
  module

theorem transport_add (a N : E) (C S : ℝ) (w u : E) :
    tangentTransport a N C S (w + u) =
      tangentTransport a N C S w + tangentTransport a N C S u := by
  simp only [tangentTransport, boost_add, inner_add_right, mul_add, add_smul]
  abel

theorem transport_smul (a N : E) (C S t : ℝ) (w : E) :
    tangentTransport a N C S (t • w) = t • tangentTransport a N C S w := by
  simp only [tangentTransport, boost_smul, real_inner_smul_right]
  module

theorem axis_inner_boost {a : E} (ha : ⟪a, a⟫_ℝ = 1) (C : ℝ) (w : E) :
    ⟪a, boost a C w⟫_ℝ = C * ⟪a, w⟫_ℝ := by
  simp only [boost, inner_add_right, real_inner_smul_right, ha]
  ring

theorem boost_inner_boost {a : E} (ha : ⟪a, a⟫_ℝ = 1)
    (C : ℝ) (w u : E) :
    ⟪boost a C w, boost a C u⟫_ℝ =
      ⟪w, u⟫_ℝ + (C ^ 2 - 1) * ⟪a, w⟫_ℝ * ⟪a, u⟫_ℝ := by
  simp only [boost, inner_add_left, inner_add_right, real_inner_smul_left,
    real_inner_smul_right, ha, real_inner_comm a w]
  ring

theorem unit_inner_le_one {a N : E}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1) :
    ⟪a, N⟫_ℝ ≤ 1 := by
  have h := real_inner_self_nonneg (x := a - N)
  simp only [inner_sub_left, inner_sub_right, ha, hN, real_inner_comm a N] at h
  linarith

theorem denominator_pos {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hC : 1 ≤ C) (hS : 0 ≤ S) (hCS : C ^ 2 - S ^ 2 = 1) :
    0 < denominator a N C S := by
  have hSC : S < C := by
    by_contra hn
    have hmul := mul_nonneg (show 0 ≤ S - C by linarith)
      (show 0 ≤ S + C by linarith)
    nlinarith
  have hg := unit_inner_le_one ha hN
  have hmul := mul_le_mul_of_nonneg_left hg hS
  unfold denominator
  nlinarith

theorem boost_inner_numerator {a : E} (N : E) {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hCS : C ^ 2 - S ^ 2 = 1) (w : E) :
    ⟪boost a C w, normalNumerator a N C S⟫_ℝ =
      ⟪w, N⟫_ℝ - S * denominator a N C S * ⟪a, w⟫_ℝ := by
  have hrel : C ^ 2 - 1 = S ^ 2 := by linarith
  simp only [normalNumerator, inner_sub_right, real_inner_smul_right,
    boost_inner_boost ha, real_inner_comm a (boost a C w), axis_inner_boost ha,
    hrel, denominator]
  ring

theorem numerator_inner_self {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hCS : C ^ 2 - S ^ 2 = 1) :
    ⟪normalNumerator a N C S, normalNumerator a N C S⟫_ℝ =
      denominator a N C S ^ 2 := by
  have hrel : C ^ 2 - 1 = S ^ 2 := by linarith
  simp only [normalNumerator, inner_sub_left, inner_sub_right, real_inner_smul_left,
    real_inner_smul_right, boost_inner_boost ha, ha, hN,
    real_inner_comm a (boost a C N), axis_inner_boost ha, hrel, denominator]
  nlinarith [hCS]

theorem transformed_normal_unit {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hCS : C ^ 2 - S ^ 2 = 1) (hD : denominator a N C S ≠ 0) :
    ⟪transformedNormal a N C S, transformedNormal a N C S⟫_ℝ = 1 := by
  simp only [transformedNormal, real_inner_smul_left, real_inner_smul_right,
    numerator_inner_self ha hN hCS]
  field_simp

theorem boost_inner_normal {a : E} (N : E) {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hCS : C ^ 2 - S ^ 2 = 1)
    (hD : denominator a N C S ≠ 0) (w : E) :
    ⟪boost a C w, transformedNormal a N C S⟫_ℝ =
      ⟪w, N⟫_ℝ / denominator a N C S - S * ⟪a, w⟫_ℝ := by
  simp only [transformedNormal, real_inner_smul_right, boost_inner_numerator N ha hCS]
  field_simp

theorem tangent_boost_inner_normal {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hCS : C ^ 2 - S ^ 2 = 1)
    (hD : denominator a N C S ≠ 0) {w : E} (hw : ⟪w, N⟫_ℝ = 0) :
    ⟪boost a C w, transformedNormal a N C S⟫_ℝ = -S * ⟪a, w⟫_ℝ := by
  rw [boost_inner_normal N ha hCS hD, hw]
  ring

theorem transport_tangent {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hCS : C ^ 2 - S ^ 2 = 1) (hD : denominator a N C S ≠ 0)
    {w : E} (hw : ⟪w, N⟫_ℝ = 0) :
    ⟪tangentTransport a N C S w, transformedNormal a N C S⟫_ℝ = 0 := by
  simp only [tangentTransport, inner_add_left, real_inner_smul_left,
    transformed_normal_unit ha hN hCS hD, tangent_boost_inner_normal ha hCS hD hw]
  ring

theorem transport_inner {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hCS : C ^ 2 - S ^ 2 = 1) (hD : denominator a N C S ≠ 0)
    {w u : E} (hw : ⟪w, N⟫_ℝ = 0) (hu : ⟪u, N⟫_ℝ = 0) :
    ⟪tangentTransport a N C S w, tangentTransport a N C S u⟫_ℝ = ⟪w, u⟫_ℝ := by
  have hrel : C ^ 2 - 1 = S ^ 2 := by linarith
  simp only [tangentTransport, inner_add_left, inner_add_right, real_inner_smul_left,
    real_inner_smul_right, boost_inner_boost ha, hrel,
    real_inner_comm (boost a C u) (transformedNormal a N C S),
    tangent_boost_inner_normal ha hCS hD hw,
    tangent_boost_inner_normal ha hCS hD hu, transformed_normal_unit ha hN hCS hD]
  ring

theorem lorentz_contact_core {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hC : 1 ≤ C) (hS : 0 ≤ S) (hCS : C ^ 2 - S ^ 2 = 1) :
    0 < denominator a N C S ∧
      ⟪transformedNormal a N C S, transformedNormal a N C S⟫_ℝ = 1 ∧
      (∀ w : E, ⟪w, N⟫_ℝ = 0 →
        ⟪tangentTransport a N C S w, transformedNormal a N C S⟫_ℝ = 0) ∧
      (∀ w u : E, ⟪w, N⟫_ℝ = 0 → ⟪u, N⟫_ℝ = 0 →
        ⟪tangentTransport a N C S w, tangentTransport a N C S u⟫_ℝ = ⟪w, u⟫_ℝ) := by
  have hD := denominator_pos ha hN hC hS hCS
  exact ⟨hD, transformed_normal_unit ha hN hCS hD.ne',
    fun _ hw => transport_tangent ha hN hCS hD.ne' hw,
    fun _ _ hw hu => transport_inner ha hN hCS hD.ne' hw hu⟩

def lorentzSpatial (a : E) (C S b : ℝ) (y : E) : E :=
  boost a C y + (b * S) • a

def lorentzHeight (a : E) (C S b : ℝ) (y : E) : ℝ :=
  C * b + S * ⟪a, y⟫_ℝ

theorem lorentz_norm_identity {a : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hCS : C ^ 2 - S ^ 2 = 1) (b : ℝ) (y : E) :
    ⟪lorentzSpatial a C S b y, lorentzSpatial a C S b y⟫_ℝ -
        lorentzHeight a C S b y ^ 2 = ⟪y, y⟫_ℝ - b ^ 2 := by
  simp only [lorentzSpatial, lorentzHeight, inner_add_left, inner_add_right,
    real_inner_smul_left, real_inner_smul_right, ha, boost_inner_boost ha,
    real_inner_comm a (boost a C y), axis_inner_boost ha]
  linear_combination (⟪a, y⟫_ℝ ^ 2 - b ^ 2) * hCS

theorem boost_twice {a : E} (ha : ⟪a, a⟫_ℝ = 1) (C : ℝ) (y : E) :
    boost a C (boost a C y) = y + ((C ^ 2 - 1) * ⟪a, y⟫_ℝ) • a := by
  simp only [boost, inner_add_right, real_inner_smul_right, ha]
  module

theorem boost_axis {a : E} (ha : ⟪a, a⟫_ℝ = 1) (C : ℝ) :
    boost a C a = C • a := by
  simp only [boost, ha]
  module

theorem lorentz_spatial_inverse {a : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hCS : C ^ 2 - S ^ 2 = 1) (b : ℝ) (y : E) :
    boost a C (lorentzSpatial a C S b y) -
        (S * lorentzHeight a C S b y) • a = y := by
  simp only [lorentzSpatial, boost_add, boost_smul, boost_twice ha, boost_axis ha,
    lorentzHeight]
  calc
    _ = y + ((C ^ 2 - S ^ 2 - 1) * ⟪a, y⟫_ℝ) • a := by module
    _ = y := by rw [hCS]; simp

theorem lorentz_height_inverse {a : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hCS : C ^ 2 - S ^ 2 = 1) (b : ℝ) (y : E) :
    C * lorentzHeight a C S b y -
        S * ⟪a, lorentzSpatial a C S b y⟫_ℝ = b := by
  simp only [lorentzHeight, lorentzSpatial, inner_add_right, real_inner_smul_right,
    axis_inner_boost ha, ha]
  linear_combination b * hCS

def targetPoint (a N : E) (C S r b : ℝ) (x : E) : E :=
  r • tangentTransport a N C S x + b • transformedNormal a N C S

theorem target_point_unit {a N x : E} {C S r b : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hx : ⟪x, x⟫_ℝ = 1) (hxN : ⟪x, N⟫_ℝ = 0)
    (hCS : C ^ 2 - S ^ 2 = 1) (hD : denominator a N C S ≠ 0)
    (hrb : r ^ 2 + b ^ 2 = 1) :
    ⟪targetPoint a N C S r b x, targetPoint a N C S r b x⟫_ℝ = 1 := by
  simp only [targetPoint, inner_add_left, inner_add_right, real_inner_smul_left,
    real_inner_smul_right, real_inner_comm (tangentTransport a N C S x)
      (transformedNormal a N C S),
    transport_tangent ha hN hCS hD hxN, transport_inner ha hN hCS hD hxN hxN,
    transformed_normal_unit ha hN hCS hD, hx]
  nlinarith [hrb]

/-! The next two definitions are the jets of the actual displayed formulas. -/

def normalJet (a N : E) (C S : ℝ) (k : E) : E :=
  (denominator a N C S)⁻¹ • boost a C k +
    (S * ⟪a, k⟫_ℝ / denominator a N C S ^ 2) • normalNumerator a N C S

theorem normal_jet_eq (a N : E) (C S : ℝ)
    (hD : denominator a N C S ≠ 0) (k : E) :
    normalJet a N C S k =
      (denominator a N C S)⁻¹ • tangentTransport a N C S k := by
  simp only [normalJet, tangentTransport, transformedNormal, smul_add, smul_smul]
  congr 1
  congr 1
  field_simp

def contactHeight (a N : E) (C S r b : ℝ) (x : E) : ℝ :=
  (b + r * S * ⟪a, x⟫_ℝ) / denominator a N C S

def targetJet (a N : E) (C S r b : ℝ) (x w k : E) : E :=
  r • (boost a C w + (S * ⟪a, w⟫_ℝ) • transformedNormal a N C S +
    (S * ⟪a, x⟫_ℝ) • normalJet a N C S k) + b • normalJet a N C S k

theorem target_jet_eq (a N : E) (C S r b : ℝ)
    (hD : denominator a N C S ≠ 0) (x w k : E) :
    targetJet a N C S r b x w k =
      tangentTransport a N C S (r • w + contactHeight a N C S r b x • k) := by
  simp only [targetJet, normal_jet_eq a N C S hD, transport_add, transport_smul,
    contactHeight, div_eq_mul_inv]
  change r • (tangentTransport a N C S w +
      (S * ⟪a, x⟫_ℝ) • ((denominator a N C S)⁻¹ • tangentTransport a N C S k)) +
      b • ((denominator a N C S)⁻¹ • tangentTransport a N C S k) =
    r • tangentTransport a N C S w +
      ((b + r * S * ⟪a, x⟫_ℝ) * (denominator a N C S)⁻¹) •
        tangentTransport a N C S k
  module

theorem target_jet_shape (a N : E) (C S r b : ℝ)
    (hD : denominator a N C S ≠ 0) (A : E →ₗ[ℝ] E) (x w : E) :
    targetJet a N C S r b x w (-(A w)) =
      tangentTransport a N C S (r • w - contactHeight a N C S r b x • A w) := by
  rw [target_jet_eq a N C S r b hD]
  simp only [smul_neg, sub_eq_add_neg]

theorem target_jet_inner {a N : E} {C S r b : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hCS : C ^ 2 - S ^ 2 = 1) (hD : denominator a N C S ≠ 0)
    (x : E) {w k u l : E}
    (hw : ⟪w, N⟫_ℝ = 0) (hk : ⟪k, N⟫_ℝ = 0)
    (hu : ⟪u, N⟫_ℝ = 0) (hl : ⟪l, N⟫_ℝ = 0) :
    ⟪targetJet a N C S r b x w k, targetJet a N C S r b x u l⟫_ℝ =
      ⟪r • w + contactHeight a N C S r b x • k,
        r • u + contactHeight a N C S r b x • l⟫_ℝ := by
  rw [target_jet_eq a N C S r b hD, target_jet_eq a N C S r b hD]
  apply transport_inner ha hN hCS hD
  · simp only [inner_add_left, real_inner_smul_left, hw, hk, mul_zero, add_zero]
  · simp only [inner_add_left, real_inner_smul_left, hu, hl, mul_zero, add_zero]

theorem transported_orthonormal_frame {ι : Type*} [DecidableEq ι]
    {a N : E} {C S : ℝ}
    (ha : ⟪a, a⟫_ℝ = 1) (hN : ⟪N, N⟫_ℝ = 1)
    (hCS : C ^ 2 - S ^ 2 = 1) (hD : denominator a N C S ≠ 0)
    (e : ι → E) (he : ∀ i j, ⟪e i, e j⟫_ℝ = if i = j then 1 else 0)
    (heN : ∀ i, ⟪e i, N⟫_ℝ = 0) :
    ∀ i j, ⟪tangentTransport a N C S (e i), tangentTransport a N C S (e j)⟫_ℝ =
      if i = j then 1 else 0 := by
  intro i j
  rw [transport_inner ha hN hCS hD (heN i) (heN j)]
  exact he i j

end InnerProduct

section Determinants

variable {ι : Type*} [Fintype ι]

theorem nonnegative_product_bound (values : ι → ℝ) (r : ℝ)
    (hvalues : ∀ i, 0 ≤ values i)
    (hsum : ∑ i, values i = (Fintype.card ι : ℝ) * r) :
    0 ≤ ∏ i, values i ∧ ∏ i, values i ≤ r ^ Fintype.card ι := by
  classical
  have hp : 0 ≤ ∏ i, values i := Finset.prod_nonneg fun i _ => hvalues i
  refine ⟨hp, ?_⟩
  by_cases hn : Fintype.card ι = 0
  · haveI : IsEmpty ι := Fintype.card_eq_zero_iff.mp hn
    simp
  have hnr : 0 < (Fintype.card ι : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hn
  have hr : 0 ≤ r := by
    have hs : 0 ≤ (Fintype.card ι : ℝ) * r := by
      rw [← hsum]
      exact Finset.sum_nonneg fun i _ => hvalues i
    exact nonneg_of_mul_nonneg_right hs hnr
  have hg := Real.geom_mean_le_arith_mean (Finset.univ : Finset ι)
    (fun _ => (1 : ℝ)) values (by intro i hi; norm_num)
    (by simpa using hnr) (by intro i hi; exact hvalues i)
  have hg' : (∏ i, values i) ^ (Fintype.card ι : ℝ)⁻¹ ≤ r := by
    simpa [hsum, ne_of_gt hnr] using hg
  calc
    ∏ i, values i = ((∏ i, values i) ^ (Fintype.card ι : ℝ)⁻¹) ^
        (Fintype.card ι : ℝ) := by
      rw [← Real.rpow_mul hp, inv_mul_cancel₀ hnr.ne', Real.rpow_one]
    _ ≤ r ^ (Fintype.card ι : ℝ) :=
      Real.rpow_le_rpow (Real.rpow_nonneg hp _) hg' hnr.le
    _ = r ^ Fintype.card ι := by rw [Real.rpow_natCast]

theorem contact_eigenvalue_bounds (κ : ι → ℝ) (r h : ℝ)
    (hκ : ∑ i, κ i = 0) (hcontact : ∀ i, 0 ≤ r - h * κ i) :
    0 ≤ ∏ i, (r - h * κ i) ∧
      ∏ i, (r - h * κ i) ≤ r ^ Fintype.card ι := by
  apply nonnegative_product_bound _ r hcontact
  simp [Finset.sum_sub_distrib, ← Finset.mul_sum, hκ]

theorem psd_determinant_bounds [DecidableEq ι] (H : Matrix ι ι ℝ) (r : ℝ)
    (hH : H.PosSemidef) (htrace : H.trace = (Fintype.card ι : ℝ) * r) :
    0 ≤ H.det ∧ H.det ≤ r ^ Fintype.card ι := by
  have hs : ∑ i, hH.isHermitian.eigenvalues i = (Fintype.card ι : ℝ) * r := by
    calc
      ∑ i, hH.isHermitian.eigenvalues i = H.trace := by
        simpa using hH.isHermitian.trace_eq_sum_eigenvalues.symm
      _ = (Fintype.card ι : ℝ) * r := htrace
  have hb := nonnegative_product_bound hH.isHermitian.eigenvalues r
    hH.eigenvalues_nonneg hs
  have hd : H.det = ∏ i, hH.isHermitian.eigenvalues i := by
    simpa using hH.isHermitian.det_eq_prod_eigenvalues
  rwa [hd]

def contactMatrix [DecidableEq ι] (A : Matrix ι ι ℝ) (r h : ℝ) : Matrix ι ι ℝ :=
  r • 1 - h • A

theorem contact_matrix_determinant_bounds [DecidableEq ι]
    (A : Matrix ι ι ℝ) (r h : ℝ) (htrace : A.trace = 0)
    (hcontact : (contactMatrix A r h).PosSemidef) :
    0 ≤ (contactMatrix A r h).det ∧
      (contactMatrix A r h).det ≤ r ^ Fintype.card ι := by
  apply psd_determinant_bounds _ r hcontact
  simp [contactMatrix, Matrix.trace_sub, Matrix.trace_smul, htrace, Matrix.trace_one,
    smul_eq_mul, mul_comm]

variable {ο : Type*} [Fintype ο]

theorem rectangular_gram_factor [DecidableEq ι]
    (Q : Matrix ο ι ℝ) (H : Matrix ι ι ℝ) (hQ : Q.transpose * Q = 1) :
    (Q * H).transpose * (Q * H) = H.transpose * H := by
  rw [Matrix.transpose_mul]
  calc
    H.transpose * Q.transpose * (Q * H) =
        H.transpose * (Q.transpose * Q) * H := by simp only [Matrix.mul_assoc]
    _ = H.transpose * H := by rw [hQ, Matrix.mul_one]

theorem rectangular_gram_determinant [DecidableEq ι]
    (Q : Matrix ο ι ℝ) (H : Matrix ι ι ℝ) (hQ : Q.transpose * Q = 1) :
    ((Q * H).transpose * (Q * H)).det = H.det ^ 2 := by
  rw [rectangular_gram_factor Q H hQ, Matrix.det_mul, Matrix.det_transpose, pow_two]

theorem rectangular_gram_jacobian [DecidableEq ι]
    (Q : Matrix ο ι ℝ) (H : Matrix ι ι ℝ) (hQ : Q.transpose * Q = 1) :
    Real.sqrt (((Q * H).transpose * (Q * H)).det) = |H.det| := by
  rw [rectangular_gram_determinant Q H hQ, Real.sqrt_sq_eq_abs]

theorem contact_metric_jacobian_bounds [DecidableEq ι]
    (Q : Matrix ο ι ℝ) (H : Matrix ι ι ℝ) (r : ℝ)
    (hQ : Q.transpose * Q = 1) (hH : H.PosSemidef)
    (htrace : H.trace = (Fintype.card ι : ℝ) * r) :
    Real.sqrt (((Q * H).transpose * (Q * H)).det) = H.det ∧
      0 ≤ Real.sqrt (((Q * H).transpose * (Q * H)).det) ∧
      Real.sqrt (((Q * H).transpose * (Q * H)).det) ≤ r ^ Fintype.card ι := by
  have hb := psd_determinant_bounds H r hH htrace
  rw [rectangular_gram_jacobian Q H hQ, abs_of_nonneg hb.1]
  exact ⟨rfl, hb⟩

theorem contact_matrix_metric_jacobian_bounds [DecidableEq ι]
    (Q : Matrix ο ι ℝ) (A : Matrix ι ι ℝ) (r h : ℝ)
    (hQ : Q.transpose * Q = 1) (htrace : A.trace = 0)
    (hcontact : (contactMatrix A r h).PosSemidef) :
    Real.sqrt (((Q * contactMatrix A r h).transpose * (Q * contactMatrix A r h)).det) =
        (contactMatrix A r h).det ∧
      0 ≤ Real.sqrt
        (((Q * contactMatrix A r h).transpose * (Q * contactMatrix A r h)).det) ∧
      Real.sqrt
        (((Q * contactMatrix A r h).transpose * (Q * contactMatrix A r h)).det) ≤
          r ^ Fintype.card ι := by
  apply contact_metric_jacobian_bounds Q _ r hQ hcontact
  simp [contactMatrix, Matrix.trace_sub, Matrix.trace_smul, htrace, Matrix.trace_one,
    smul_eq_mul, mul_comm]

end Determinants

end LorentzContact
