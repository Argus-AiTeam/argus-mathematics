import Mathlib

noncomputable section

open scoped ComplexOrder MatrixOrder Kronecker
open Matrix Finset

namespace CrouzeixCore

def hsSq {I J : Type*} [Fintype I] [Fintype J] (A : Matrix I J ℂ) : ℝ :=
  (Matrix.trace (Aᴴ * A)).re

lemma hsSq_nonneg {I J : Type*} [Fintype I] [Fintype J]
    (A : Matrix I J ℂ) : 0 ≤ hsSq A := by
  exact (RCLike.nonneg_iff.mp
    (Matrix.posSemidef_conjTranspose_mul_self A).trace_nonneg).1

lemma hsSq_adjoint {I J : Type*} [Fintype I] [Fintype J]
    (A : Matrix I J ℂ) : hsSq Aᴴ = hsSq A := by
  simp only [hsSq, Matrix.conjTranspose_conjTranspose]
  rw [Matrix.trace_mul_comm]

lemma hsSq_eq_sum {I J : Type*} [Fintype I] [Fintype J]
    (A : Matrix I J ℂ) :
    hsSq A = ∑ i, ∑ j, Complex.normSq (A i j) := by
  simp only [hsSq, Matrix.trace, Matrix.diag, Matrix.mul_apply,
    Matrix.conjTranspose_apply]
  change Complex.reAddGroupHom _ = _
  simp only [map_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  simp [Complex.mul_re, Complex.normSq_apply]

def entryPair {I J : Type*} [Fintype I] [Fintype J]
    (A C : Matrix I J ℂ) : ℂ := ∑ i, ∑ j, A i j * C i j

theorem tensor_pairing {B M : Type*} [Fintype B] [Fintype M]
    (A : Matrix B B ℂ) (C : Matrix M M ℂ) (X Y : Matrix B M ℂ) :
    (∑ s : B × M, star (Y s.1 s.2) *
      ∑ t : B × M, (A ⊗ₖ C) s t * X t.1 t.2) =
      entryPair (Yᴴ * A * X) C := by
  simp only [entryPair, Fintype.sum_prod_type, Matrix.kronecker_apply,
    Matrix.mul_apply, Matrix.conjTranspose_apply]
  simp_rw [Finset.mul_sum, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_comm]
  conv_lhs =>
    enter [2, b]
    rw [Finset.sum_comm]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro b _
  apply Finset.sum_congr rfl
  intro a _
  simp only [Complex.star_def]
  ring

theorem ordered_tensor_terms {B M : Type*} [Fintype B] [Fintype M]
    [DecidableEq B] (A : Matrix B B ℂ) (C D : Matrix M M ℂ) (i j : ℕ) :
    ((A ^ i) ⊗ₖ C) * ((A ^ j) ⊗ₖ D) = (A ^ (i + j)) ⊗ₖ (C * D) := by
  rw [← Matrix.mul_kronecker_mul, ← pow_add]

theorem finite_pair_cauchy {I : Type*} [Fintype I] (p c : I → ℂ) :
    Complex.normSq (∑ i, p i * c i) ≤
      (∑ i, Complex.normSq (p i)) * ∑ i, Complex.normSq (c i) := by
  have hnorm : ‖∑ i, p i * c i‖ ≤ ∑ i, ‖p i‖ * ‖c i‖ := by
    simpa only [norm_mul] using norm_sum_le Finset.univ (fun i => p i * c i)
  have hnonneg : 0 ≤ ∑ i, ‖p i‖ * ‖c i‖ :=
    Finset.sum_nonneg fun i _ => mul_nonneg (norm_nonneg _) (norm_nonneg _)
  have hsquare := Finset.sum_mul_sq_le_sq_mul_sq Finset.univ
    (fun i => ‖p i‖) (fun i => ‖c i‖)
  simp only [Complex.normSq_eq_norm_sq] at *
  have hsq := (sq_le_sq₀ (norm_nonneg _) hnonneg).mpr hnorm
  exact hsq.trans hsquare

theorem finite_pair_of_total_energy {I : Type*} [Fintype I] (p c : I → ℂ)
    (a : ℝ) (hcap : (∑ i, Complex.normSq (p i)) ≤ a) :
    Complex.normSq (∑ i, p i * c i) ≤ a * ∑ i, Complex.normSq (c i) := by
  exact (finite_pair_cauchy p c).trans (mul_le_mul_of_nonneg_right hcap
    (Finset.sum_nonneg fun i _ => Complex.normSq_nonneg _))

theorem weighted_dual {I : Type*} [Fintype I] (p : I → ℂ)
    (w : I → ℝ) (hw : ∀ i, 0 < w i) (b : ℝ) (hb : 0 ≤ b)
    (h : ∀ c : I → ℂ,
      Complex.normSq (∑ i, p i * c i) ≤ b * ∑ i, w i * Complex.normSq (c i)) :
    ∑ i, Complex.normSq (p i) / w i ≤ b := by
  let d : ℝ := ∑ i, Complex.normSq (p i) / w i
  let c : I → ℂ := fun i => star (p i) / (w i : ℂ)
  have hd : 0 ≤ d := Finset.sum_nonneg fun i _ =>
    div_nonneg (Complex.normSq_nonneg _) (le_of_lt (hw i))
  have hp : (∑ i, p i * c i) = (d : ℂ) := by
    simp only [c, d, Complex.ofReal_sum, Complex.ofReal_div, Complex.star_def]
    apply Finset.sum_congr rfl
    intro i _
    rw [← mul_div_assoc, Complex.mul_conj]
  have hc : (∑ i, w i * Complex.normSq (c i)) = d := by
    apply Finset.sum_congr rfl
    intro i _
    simp only [c, Complex.star_def, Complex.normSq_div, Complex.normSq_conj,
      Complex.normSq_ofReal]
    field_simp [ne_of_gt (hw i)]
  have hh := h c
  rw [hp, hc, Complex.normSq_ofReal] at hh
  change d ≤ b
  nlinarith

theorem ordered_functional_bound {E : Type*}
    (off diag : E → ℂ) (energy boundary : E → ℝ) (product : E → E)
    (a gamma : ℝ) (ha : 0 ≤ a)
    (hcross : ∀ g, Complex.normSq (off g) ≤ a * energy g)
    (hlower : ∀ g, energy g ≤ boundary g)
    (hmult : ∀ g, boundary (product g) ≤ boundary g)
    (horder : ∀ g, off (product g) = (gamma : ℂ) * diag g)
    (g : E) :
    gamma ^ 2 * Complex.normSq (diag g) ≤ a * boundary g := by
  have h := (hcross (product g)).trans
    ((mul_le_mul_of_nonneg_left (hlower (product g)) ha).trans
      (mul_le_mul_of_nonneg_left (hmult g) ha))
  simpa only [horder, Complex.normSq_mul, Complex.normSq_ofReal, pow_two] using h

lemma re_trace_product_nonneg {I : Type*} [Fintype I] [DecidableEq I]
    {A B : Matrix I I ℂ} (hA : A.PosSemidef) (hB : B.PosSemidef) :
    0 ≤ (Matrix.trace (A * B)).re := by
  obtain ⟨C, rfl⟩ := CStarAlgebra.nonneg_iff_eq_star_mul_self.mp hB.nonneg
  have h := (RCLike.nonneg_iff.mp (hA.mul_mul_conjTranspose_same C).trace_nonneg).1
  change 0 ≤ (Matrix.trace (A * (Cᴴ * C))).re
  rw [← Matrix.mul_assoc, Matrix.trace_mul_cycle]
  exact h

lemma trace_blocks {I J : Type*} [Fintype I] [Fintype J]
    (A : Matrix I I ℂ) (B : Matrix I J ℂ)
    (C : Matrix J I ℂ) (D : Matrix J J ℂ) :
    Matrix.trace (Matrix.fromBlocks A B C D) = Matrix.trace A + Matrix.trace D := by
  simp [Matrix.trace, Matrix.diag, Fintype.sum_sum_type]

theorem positive_block {I J : Type*} [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J]
    (U : Matrix I I ℂ) (V : Matrix J J ℂ) (Z : Matrix J I ℂ)
    (h : (Matrix.fromBlocks U Zᴴ Z V).PosSemidef) :
    2 * hsSq Z ≤ hsSq U + hsSq V := by
  let D := Matrix.fromBlocks U Zᴴ Z V
  let Jsign : Matrix (I ⊕ J) (I ⊕ J) ℂ :=
    Matrix.fromBlocks 1 0 0 (-1)
  have hJs : Jsignᴴ = Jsign := by
    ext i j
    cases i <;> cases j <;>
      simp [Jsign, Matrix.conjTranspose_apply, Matrix.one_apply, eq_comm]
  have hflip : (Matrix.fromBlocks U (-Zᴴ) (-Z) V).PosSemidef := by
    simpa [hJs, D, Jsign, Matrix.fromBlocks_multiply] using
      h.mul_mul_conjTranspose_same Jsign
  have ht := re_trace_product_nonneg h hflip
  have hh := Matrix.isHermitian_fromBlocks_iff.mp h.isHermitian
  have hU : (Matrix.trace (U * U)).re = hsSq U := by
    rw [hsSq, hh.1.eq]
  have hV : (Matrix.trace (V * V)).re = hsSq V := by
    rw [hsSq, hh.2.2.2.eq]
  have hZ : (Matrix.trace (Z * Zᴴ)).re = hsSq Z := by
    rw [Matrix.trace_mul_comm]
    rfl
  simp only [Matrix.fromBlocks_multiply, Matrix.mul_neg,
    trace_blocks, Matrix.trace_add, Matrix.trace_neg, Complex.add_re,
    Complex.neg_re, hU, hV, hZ] at ht
  change 0 ≤ hsSq U + -hsSq Z + (-hsSq Z + hsSq V) at ht
  linarith

def coefficientWeight (k : ℕ) : ℝ := if k = 0 then 1 else 2

lemma coefficientWeight_pos (k : ℕ) : 0 < coefficientWeight k := by
  unfold coefficientWeight
  split <;> norm_num

def dualPartial {K : Type*} [Fintype K] (p : ℕ → K → ℂ) (N : ℕ) : ℝ :=
  ∑ s : Fin N × K, Complex.normSq (p s.1 s.2) / coefficientWeight s.1

theorem ordered_dual_partial {E K : Type*} [Fintype K]
    (off diag : E → ℂ) (energy boundary : E → ℝ) (product : E → E)
    (test : (N : ℕ) → ((Fin N × K) → ℂ) → E)
    (p : ℕ → K → ℂ) (a gamma : ℝ) (ha : 0 ≤ a) (hg : 0 < gamma)
    (hcross : ∀ g, Complex.normSq (off g) ≤ a * energy g)
    (hlower : ∀ g, energy g ≤ boundary g)
    (hmult : ∀ g, boundary (product g) ≤ boundary g)
    (horder : ∀ g, off (product g) = (gamma : ℂ) * diag g)
    (hpair : ∀ N c, diag (test N c) = ∑ s, p s.1 s.2 * c s)
    (hupper : ∀ N c, boundary (test N c) ≤
      ∑ s, coefficientWeight s.1 * Complex.normSq (c s))
    (N : ℕ) :
    dualPartial p N ≤ a / gamma ^ 2 := by
  apply weighted_dual (fun s : Fin N × K => p s.1 s.2)
    (fun s => coefficientWeight s.1) (fun s => coefficientWeight_pos s.1)
    (a / gamma ^ 2) (div_nonneg ha (sq_nonneg _))
  intro c
  have h := ordered_functional_bound off diag energy boundary product
    a gamma ha hcross hlower hmult horder (test N c)
  have hu := mul_le_mul_of_nonneg_left (hupper N c) ha
  rw [hpair N c] at h
  rw [div_mul_eq_mul_div]
  apply (le_div_iff₀ (sq_pos_of_pos hg)).mpr
  nlinarith

open MeasureTheory Filter

theorem integrated_positive_block {T I J : Type*} [MeasurableSpace T]
    [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
    (mu : Measure T) (U : T → Matrix I I ℂ)
    (V : T → Matrix J J ℂ) (Z : T → Matrix J I ℂ)
    (hU : Integrable (fun t => hsSq (U t)) mu)
    (hV : Integrable (fun t => hsSq (V t)) mu)
    (hZ : Integrable (fun t => hsSq (Z t)) mu)
    (hpos : ∀ t, (Matrix.fromBlocks (U t) (Z t)ᴴ (Z t) (V t)).PosSemidef) :
    2 * (∫ t, hsSq (Z t) ∂mu) ≤
      (∫ t, hsSq (U t) ∂mu) + (∫ t, hsSq (V t) ∂mu) := by
  have h := integral_mono (hZ.const_mul 2) (hU.add hV)
    (fun t => positive_block (U t) (V t) (Z t) (hpos t))
  simpa only [Pi.add_apply, integral_const_mul, integral_add hU hV] using h

theorem ordered_coefficient_positive_block
    {E K T I J : Type*} [Fintype K] [MeasurableSpace T]
    [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
    (off dp dq : E → ℂ) (energy boundary : E → ℝ) (left right : E → E)
    (test : (N : ℕ) → ((Fin N × K) → ℂ) → E)
    (p q : ℕ → K → ℂ) (gamma mzero mtail ltail P Q : ℝ)
    (hg : 0 < gamma) (hmzero : 0 ≤ mzero) (_hmtail : 0 ≤ mtail)
    (hltail : 0 ≤ ltail) (ha : 0 < mzero + mtail)
    (hcross : ∀ g, Complex.normSq (off g) ≤ (mzero + mtail) * energy g)
    (hlower : ∀ g, energy g ≤ boundary g)
    (hleft : ∀ g, boundary (left g) ≤ boundary g)
    (hright : ∀ g, boundary (right g) ≤ boundary g)
    (horderp : ∀ g, off (left g) = (gamma : ℂ) * dp g)
    (horderq : ∀ g, off (right g) = (gamma : ℂ) * dq g)
    (hpairp : ∀ N c, dp (test N c) = ∑ s, p s.1 s.2 * c s)
    (hpairq : ∀ N c, dq (test N c) = ∑ s, q s.1 s.2 * c s)
    (hupper : ∀ N c, boundary (test N c) ≤
      ∑ s, coefficientWeight s.1 * Complex.normSq (c s))
    (hp : Tendsto (dualPartial p) atTop (nhds P))
    (hq : Tendsto (dualPartial q) atTop (nhds Q))
    (mu : Measure T) (U : T → Matrix I I ℂ)
    (V : T → Matrix J J ℂ) (Z : T → Matrix J I ℂ)
    (hU : Integrable (fun t => hsSq (U t)) mu)
    (hV : Integrable (fun t => hsSq (V t)) mu)
    (hZ : Integrable (fun t => hsSq (Z t)) mu)
    (hpos : ∀ t, (Matrix.fromBlocks (U t) (Z t)ᴴ (Z t) (V t)).PosSemidef)
    (hparsep : (∫ t, hsSq (U t) ∂mu) = 4 * P)
    (hparseq : (∫ t, hsSq (V t) ∂mu) = 4 * Q)
    (hparsecross : (∫ t, hsSq (Z t) ∂mu) = 4 * mzero + mtail + ltail) :
    gamma ≤ 2 := by
  have hpBound : P ≤ (mzero + mtail) / gamma ^ 2 :=
    le_of_tendsto hp (Eventually.of_forall
      (ordered_dual_partial off dp energy boundary left test p
        (mzero + mtail) gamma (le_of_lt ha) hg hcross hlower hleft horderp hpairp hupper))
  have hqBound : Q ≤ (mzero + mtail) / gamma ^ 2 :=
    le_of_tendsto hq (Eventually.of_forall
      (ordered_dual_partial off dq energy boundary right test q
        (mzero + mtail) gamma (le_of_lt ha) hg hcross hlower hright horderq hpairq hupper))
  have hpMul := (le_div_iff₀ (sq_pos_of_pos hg)).mp hpBound
  have hqMul := (le_div_iff₀ (sq_pos_of_pos hg)).mp hqBound
  have hblock := integrated_positive_block mu U V Z hU hV hZ hpos
  rw [hparsep, hparseq, hparsecross] at hblock
  have hscaled := mul_le_mul_of_nonneg_right hblock (sq_nonneg gamma)
  have hextra := mul_nonneg (sq_nonneg gamma)
    (show 0 ≤ 3 * mzero + ltail by positivity)
  have hsq : gamma ^ 2 ≤ 4 := by
    by_contra hn
    have hpos := mul_pos ha (sub_pos.mpr (lt_of_not_ge hn))
    nlinarith
  nlinarith

theorem weighted_frame_constant (beta pzero ptail qzero qtail a gamma cross : ℝ)
    (hb : 0 < beta) (hp0 : 0 ≤ pzero) (hpt : 0 ≤ ptail)
    (hq0 : 0 ≤ qzero) (hqt : 0 ≤ qtail) (ha : 0 < a) (_hg : 0 ≤ gamma)
    (hp : gamma ^ 2 * (pzero + ptail / beta) ≤ a)
    (hq : gamma ^ 2 * (qzero + qtail / beta) ≤ a)
    (hc : a ≤ cross)
    (hblock : 2 * cross ≤ 4 * pzero + 2 * ptail + 4 * qzero + 2 * qtail) :
    gamma ^ 2 ≤ max 4 (2 * beta) := by
  let c := max 4 (2 * beta)
  have hc4 : 4 ≤ c := le_max_left _ _
  have hc2 : 2 * beta ≤ c := le_max_right _ _
  have hcp : gamma ^ 2 * (4 * pzero + 2 * ptail) ≤ c * a := by
    have h1 := mul_nonneg (show 0 ≤ c - 4 by linarith) hp0
    have h2 := mul_nonneg (show 0 ≤ c / beta - 2 by
      apply sub_nonneg.mpr
      exact (le_div_iff₀ hb).mpr (by linarith)) hpt
    have h3 := mul_le_mul_of_nonneg_left hp (show 0 ≤ c by linarith)
    have h4 := mul_nonneg (sq_nonneg gamma) (add_nonneg h1 h2)
    simp only [div_eq_mul_inv] at h3 h4
    nlinarith
  have hcq : gamma ^ 2 * (4 * qzero + 2 * qtail) ≤ c * a := by
    have h1 := mul_nonneg (show 0 ≤ c - 4 by linarith) hq0
    have h2 := mul_nonneg (show 0 ≤ c / beta - 2 by
      apply sub_nonneg.mpr
      exact (le_div_iff₀ hb).mpr (by linarith)) hqt
    have h3 := mul_le_mul_of_nonneg_left hq (show 0 ≤ c by linarith)
    have h4 := mul_nonneg (sq_nonneg gamma) (add_nonneg h1 h2)
    simp only [div_eq_mul_inv] at h3 h4
    nlinarith
  have h := mul_le_mul_of_nonneg_left hblock (sq_nonneg gamma)
  have h' := mul_le_mul_of_nonneg_left hc (sq_nonneg gamma)
  change gamma ^ 2 ≤ c
  by_contra hn
  have hpos := mul_pos (sub_pos.mpr (lt_of_not_ge hn)) ha
  nlinarith

end CrouzeixCore

#print axioms CrouzeixCore.tensor_pairing
#print axioms CrouzeixCore.weighted_dual
#print axioms CrouzeixCore.positive_block
#print axioms CrouzeixCore.ordered_coefficient_positive_block
#print axioms CrouzeixCore.weighted_frame_constant
