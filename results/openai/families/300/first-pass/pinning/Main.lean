import Mathlib

noncomputable section

open Matrix Finset Unitary

namespace WeightedPinning

variable {J : Type*} [Fintype J] [DecidableEq J]

def posPart {A : Matrix J J ℝ} (hA : A.IsHermitian) : Matrix J J ℝ :=
  conjStarAlgAut ℝ _ hA.eigenvectorUnitary
    (diagonal (fun j => max (hA.eigenvalues j) 0))

def negPart {A : Matrix J J ℝ} (hA : A.IsHermitian) : Matrix J J ℝ :=
  conjStarAlgAut ℝ _ hA.eigenvectorUnitary
    (diagonal (fun j => max (-hA.eigenvalues j) 0))

def posProjection {A : Matrix J J ℝ} (hA : A.IsHermitian) : Matrix J J ℝ :=
  conjStarAlgAut ℝ _ hA.eigenvectorUnitary
    (diagonal (fun j => if 0 < hA.eigenvalues j then 1 else 0))

def positiveTrace {A : Matrix J J ℝ} (hA : A.IsHermitian) : ℝ :=
  (posPart hA).trace

lemma trace_conj (u : Matrix.unitaryGroup J ℝ) (A : Matrix J J ℝ) :
    (conjStarAlgAut ℝ _ u A).trace = A.trace := by
  rw [conjStarAlgAut_apply, trace_mul_cycle]
  simp

lemma posPart_psd {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    (posPart hA).PosSemidef := by
  unfold posPart
  rw [conjStarAlgAut_apply]
  have hd : (diagonal (fun j => max (hA.eigenvalues j) 0)).PosSemidef :=
    posSemidef_diagonal_iff.mpr fun j => le_max_right (hA.eigenvalues j) 0
  simpa only [star_eq_conjTranspose] using
    hd.mul_mul_conjTranspose_same (hA.eigenvectorUnitary : Matrix J J ℝ)

lemma negPart_psd {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    (negPart hA).PosSemidef := by
  unfold negPart
  rw [conjStarAlgAut_apply]
  have hd : (diagonal (fun j => max (-hA.eigenvalues j) 0)).PosSemidef :=
    posSemidef_diagonal_iff.mpr fun j => le_max_right (-hA.eigenvalues j) 0
  simpa only [star_eq_conjTranspose] using
    hd.mul_mul_conjTranspose_same (hA.eigenvectorUnitary : Matrix J J ℝ)

lemma parts_sub {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    posPart hA - negPart hA = A := by
  have heq : (fun j => max (hA.eigenvalues j) 0 - max (-hA.eigenvalues j) 0) =
      hA.eigenvalues := by
    ext j
    rcases le_total 0 (hA.eigenvalues j) with h | h
    · simp [max_eq_left h, max_eq_right (neg_nonpos.mpr h)]
    · simp [max_eq_right h, max_eq_left (neg_nonneg.mpr h)]
  calc
    posPart hA - negPart hA =
        conjStarAlgAut ℝ _ hA.eigenvectorUnitary (diagonal hA.eigenvalues) := by
      rw [posPart, negPart, ← map_sub, diagonal_sub]
      exact congrArg _ (congrArg diagonal heq)
    _ = A := by simpa using hA.spectral_theorem.symm

lemma positiveTrace_eq_sum {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    positiveTrace hA = ∑ j, max (hA.eigenvalues j) 0 := by
  rw [positiveTrace, posPart, trace_conj, trace_diagonal]

lemma trace_parts {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    positiveTrace hA = A.trace + (negPart hA).trace := by
  have h := congrArg Matrix.trace (parts_sub hA)
  rw [trace_sub] at h
  exact sub_eq_iff_eq_add.mp h

lemma psd_trace_mul_nonneg {A B : Matrix J J ℝ}
    (hA : A.PosSemidef) (hB : B.PosSemidef) : 0 ≤ (A * B).trace := by
  let u := hA.isHermitian.eigenvectorUnitary
  let C := star (u : Matrix J J ℝ) * B * (u : Matrix J J ℝ)
  have hC : C.PosSemidef := by
    simpa only [C, star_eq_conjTranspose] using hB.conjTranspose_mul_mul_same
      (u : Matrix J J ℝ)
  have htrace : (A * B).trace = (diagonal hA.isHermitian.eigenvalues * C).trace := by
    calc
      (A * B).trace =
          ((u : Matrix J J ℝ) *
            (diagonal hA.isHermitian.eigenvalues * (star (u : Matrix J J ℝ) * B))).trace := by
        simpa [u, conjStarAlgAut_apply, Matrix.mul_assoc] using
          congrArg (fun M => (M * B).trace) hA.isHermitian.spectral_theorem
      _ = ((diagonal hA.isHermitian.eigenvalues * (star (u : Matrix J J ℝ) * B)) *
          (u : Matrix J J ℝ)).trace := trace_mul_comm _ _
      _ = _ := by simp only [C, Matrix.mul_assoc]
  rw [htrace]
  simp only [Matrix.trace, Matrix.diag, Matrix.diagonal_mul]
  exact sum_nonneg fun j _ => mul_nonneg (hA.eigenvalues_nonneg j) (hC.diag_nonneg)

lemma posProjection_psd {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    (posProjection hA).PosSemidef := by
  unfold posProjection
  rw [conjStarAlgAut_apply]
  have hd : (diagonal (fun j => if 0 < hA.eigenvalues j then (1 : ℝ) else 0)).PosSemidef :=
    posSemidef_diagonal_iff.mpr fun j => by split_ifs <;> norm_num
  simpa only [star_eq_conjTranspose] using
    hd.mul_mul_conjTranspose_same (hA.eigenvectorUnitary : Matrix J J ℝ)

lemma one_sub_posProjection_psd {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    (1 - posProjection hA).PosSemidef := by
  have heq : 1 - posProjection hA =
      conjStarAlgAut ℝ _ hA.eigenvectorUnitary
        (diagonal (fun j => if 0 < hA.eigenvalues j then 0 else 1)) := by
    rw [posProjection, ← map_one (conjStarAlgAut ℝ _ hA.eigenvectorUnitary), ← map_sub,
      ← diagonal_one, diagonal_sub]
    apply congrArg (conjStarAlgAut ℝ _ hA.eigenvectorUnitary)
    apply congrArg diagonal
    funext j
    change 1 - (if 0 < hA.eigenvalues j then (1 : ℝ) else 0) =
      (if 0 < hA.eigenvalues j then 0 else 1)
    split_ifs <;> norm_num
  rw [heq, conjStarAlgAut_apply]
  have hd : (diagonal (fun j => if 0 < hA.eigenvalues j then (0 : ℝ) else 1)).PosSemidef :=
    posSemidef_diagonal_iff.mpr fun j => by split_ifs <;> norm_num
  simpa only [star_eq_conjTranspose] using
    hd.mul_mul_conjTranspose_same (hA.eigenvectorUnitary : Matrix J J ℝ)

lemma trace_mul_posProjection {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    (A * posProjection hA).trace = positiveTrace hA := by
  have heq : A * posProjection hA =
      conjStarAlgAut ℝ _ hA.eigenvectorUnitary
        (diagonal (RCLike.ofReal ∘ hA.eigenvalues)) * posProjection hA :=
    congrArg (fun M => M * posProjection hA) hA.spectral_theorem
  rw [heq, posProjection, ← map_mul, diagonal_mul_diagonal, trace_conj,
    trace_diagonal, positiveTrace_eq_sum]
  apply sum_congr rfl
  intro j _
  change hA.eigenvalues j * (if 0 < hA.eigenvalues j then 1 else 0) =
    max (hA.eigenvalues j) 0
  split_ifs with h
  · simp [max_eq_left h.le]
  · simp [max_eq_right (le_of_not_gt h)]

lemma positiveTrace_le_trace {A K : Matrix J J ℝ} (hA : A.IsHermitian)
    (hK : K.PosSemidef) (hKA : (K - A).PosSemidef) :
    positiveTrace hA ≤ K.trace := by
  have h1 := psd_trace_mul_nonneg hK (one_sub_posProjection_psd hA)
  have h2 := psd_trace_mul_nonneg hKA (posProjection_psd hA)
  rw [mul_sub, mul_one, trace_sub] at h1
  rw [sub_mul, trace_sub, trace_mul_posProjection] at h2
  linarith

lemma positiveTrace_subadditive {A B : Matrix J J ℝ}
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    positiveTrace (hA.add hB) ≤ positiveTrace hA + positiveTrace hB := by
  have heq : posPart hA + posPart hB - (A + B) = negPart hA + negPart hB := by
    have ha := parts_sub hA
    have hb := parts_sub hB
    apply Matrix.ext
    intro i j
    have ha' := congrFun (congrFun ha i) j
    have hb' := congrFun (congrFun hb i) j
    simp only [Matrix.sub_apply] at ha' hb'
    change posPart hA i j + posPart hB i j - (A i j + B i j) =
      negPart hA i j + negPart hB i j
    linarith
  have h := positiveTrace_le_trace (hA.add hB)
    ((posPart_psd hA).add (posPart_psd hB))
    (by rw [heq]; exact (negPart_psd hA).add (negPart_psd hB))
  simpa only [trace_add, positiveTrace] using h

lemma exists_weighted_le {I : Type*} [Fintype I] (p f : I → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1) {M : ℝ}
    (hm : ∑ i, p i * f i ≤ M) :
    ∃ i, 0 < p i ∧ f i ≤ M := by
  classical
  have hex : ∃ i, 0 < p i := by
    by_contra! h
    have hz : ∀ i, p i = 0 := fun i => le_antisymm (h i) (hp i)
    simp [hz] at hs
  by_contra! h
  obtain ⟨i, hi⟩ := hex
  have hlt : ∑ j, p j * M < ∑ j, p j * f j := by
    apply sum_lt_sum
    · intro j _
      by_cases hj : 0 < p j
      · exact mul_le_mul_of_nonneg_left (h j hj).le (hp j)
      · have hz : p j = 0 := le_antisymm (le_of_not_gt hj) (hp j)
        simp [hz]
    · exact ⟨i, mem_univ i, mul_lt_mul_of_pos_left (h i hi) hi⟩
  rw [← sum_mul, hs, one_mul] at hlt
  linarith

lemma weighted_zero {I : Type*} [Fintype I] (p f : I → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hf : ∀ i, 0 ≤ f i)
    (hs : ∑ i, p i * f i ≤ 0) {i : I} (hi : 0 < p i) : f i = 0 := by
  classical
  have hle : p i * f i ≤ ∑ j, p j * f j :=
    single_le_sum (fun j _ => mul_nonneg (hp j) (hf j)) (mem_univ i)
  nlinarith [hf i]

theorem two_tests {I : Type*} [Fintype I] (p A B : I → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1)
    (hA : ∀ i, 0 ≤ A i) (hB : ∀ i, 0 ≤ B i)
    {U V : ℝ} (hU : 0 ≤ U) (hV : 0 ≤ V)
    (hAU : ∑ i, p i * A i ≤ U) (hBV : ∑ i, p i * B i ≤ V) :
    ∃ i, 0 < p i ∧ A i ≤ 2 * U ∧ B i ≤ 2 * V := by
  classical
  by_cases hu : U = 0
  · obtain ⟨i, hi, hbi⟩ := exists_weighted_le p B hp hs hBV
    have hai := weighted_zero p A hp hA (hu ▸ hAU) hi
    exact ⟨i, hi, by simp [hai, hu], by linarith⟩
  by_cases hv : V = 0
  · obtain ⟨i, hi, hai⟩ := exists_weighted_le p A hp hs hAU
    have hbi := weighted_zero p B hp hB (hv ▸ hBV) hi
    exact ⟨i, hi, by linarith, by simp [hbi, hv]⟩
  have hu' : 0 < U := lt_of_le_of_ne hU (Ne.symm hu)
  have hv' : 0 < V := lt_of_le_of_ne hV (Ne.symm hv)
  have hm : ∑ i, p i * (A i / U + B i / V) ≤ 2 := by
    simp_rw [mul_add, ← mul_div_assoc]
    rw [sum_add_distrib, ← sum_div, ← sum_div]
    linarith [(div_le_one hu').mpr hAU, (div_le_one hv').mpr hBV]
  obtain ⟨i, hi, hab⟩ := exists_weighted_le p (fun i => A i / U + B i / V) hp hs hm
  have ha0 := div_nonneg (hA i) hU
  have hb0 := div_nonneg (hB i) hV
  refine ⟨i, hi, ?_, ?_⟩
  · apply (div_le_iff₀ hu').mp
    linarith
  · apply (div_le_iff₀ hv').mp
    linarith

lemma psd_cauchy {A : Matrix J J ℝ} (hA : A.PosSemidef) (x y : J → ℝ) :
    (x ⬝ᵥ (A *ᵥ y)) ^ 2 ≤ (x ⬝ᵥ (A *ᵥ x)) * (y ⬝ᵥ (A *ᵥ y)) := by
  letI := A.toSeminormedAddCommGroup hA
  letI := A.toInnerProductSpace hA
  have h := real_inner_mul_inner_self_le x y
  change ((A *ᵥ y) ⬝ᵥ x) * ((A *ᵥ y) ⬝ᵥ x) ≤
    ((A *ᵥ x) ⬝ᵥ x) * ((A *ᵥ y) ⬝ᵥ y) at h
  simpa only [dotProduct_comm, pow_two] using h

lemma psd_trace_bound {A : Matrix J J ℝ} (hA : A.PosSemidef) (x : J → ℝ) :
    x ⬝ᵥ (A *ᵥ x) ≤ A.trace * (x ⬝ᵥ x) := by
  let u := hA.isHermitian.eigenvectorUnitary
  have heig (j : J) : hA.isHermitian.eigenvalues j ≤ A.trace := by
    rw [hA.isHermitian.trace_eq_sum_eigenvalues]
    exact single_le_sum (fun k _ => hA.eigenvalues_nonneg k) (mem_univ j)
  have hd : (diagonal (fun j => A.trace - hA.isHermitian.eigenvalues j)).PosSemidef :=
    posSemidef_diagonal_iff.mpr fun j => sub_nonneg.mpr (heig j)
  have hM : (A.trace • (1 : Matrix J J ℝ) - A).PosSemidef := by
    have heq : A.trace • (1 : Matrix J J ℝ) - A =
        conjStarAlgAut ℝ _ u (diagonal (fun j => A.trace - hA.isHermitian.eigenvalues j)) := by
      calc
        A.trace • (1 : Matrix J J ℝ) - A =
            conjStarAlgAut ℝ _ u (A.trace • 1 - diagonal hA.isHermitian.eigenvalues) := by
          rw [map_sub, map_smul, map_one]
          congr 1
          simpa [u] using hA.isHermitian.spectral_theorem
        _ = _ := by
          congr 1
          ext i j
          by_cases h : i = j <;> simp [h, diagonal_apply]
    rw [heq, conjStarAlgAut_apply]
    simpa only [star_eq_conjTranspose] using
      hd.mul_mul_conjTranspose_same (u : Matrix J J ℝ)
  have h := hM.dotProduct_mulVec_nonneg x
  simpa only [star_trivial, sub_mulVec, smul_mulVec, one_mulVec, dotProduct_sub,
    dotProduct_smul, smul_eq_mul, sub_nonneg] using h

def arrow (c : ℝ) (g pole : J → ℝ) : Matrix (Option J) (Option J) ℝ
  | none, none => c
  | none, some j => g j
  | some i, none => g i
  | some i, some j => if i = j then pole i else 0

lemma arrow_hermitian (c : ℝ) (g pole : J → ℝ) : (arrow c g pole).IsHermitian := by
  apply Matrix.ext
  intro i j
  cases i <;> cases j <;> simp [Matrix.conjTranspose_apply, arrow, eq_comm] <;>
    split_ifs <;> simp_all

lemma arrow_mul_none (c : ℝ) (g pole : J → ℝ) (x : Option J → ℝ) :
    ((arrow c g pole) *ᵥ x) none = c * x none + ∑ j, g j * x (some j) := by
  simp [mulVec, dotProduct, Fintype.sum_option, arrow]

lemma arrow_mul_some (c : ℝ) (g pole : J → ℝ) (x : Option J → ℝ) (j : J) :
    ((arrow c g pole) *ᵥ x) (some j) = g j * x none + pole j * x (some j) := by
  simp [mulVec, dotProduct, Fintype.sum_option, arrow]

lemma arrow_quad_zero (c : ℝ) (g pole : J → ℝ) (x : Option J → ℝ)
    (hx : x none = 0) :
    x ⬝ᵥ ((arrow c g pole) *ᵥ x) = ∑ j, pole j * x (some j) ^ 2 := by
  simp only [dotProduct, Fintype.sum_option, hx, zero_mul, zero_add]
  apply sum_congr rfl
  intro j _
  rw [arrow_mul_some, hx]
  ring

def eigenvector {A : Matrix J J ℝ} (hA : A.IsHermitian) (j : J) : J → ℝ :=
  (hA.eigenvectorBasis j).ofLp

lemma eigenvector_dot {A : Matrix J J ℝ} (hA : A.IsHermitian) (i j : J) :
    eigenvector hA i ⬝ᵥ eigenvector hA j = if i = j then 1 else 0 := by
  simpa only [EuclideanSpace.inner_eq_star_dotProduct, star_trivial, eigenvector,
    dotProduct_comm] using hA.eigenvectorBasis.inner_eq_ite i j

lemma eigenvector_mul {A : Matrix J J ℝ} (hA : A.IsHermitian) (j : J) :
    A *ᵥ eigenvector hA j = hA.eigenvalues j • eigenvector hA j :=
  hA.mulVec_eigenvectorBasis j

lemma positive_eigen_root_ne_zero {A : Matrix J J ℝ} (hA : A.IsHermitian) (o i : J)
    (hdel : ∀ x : J → ℝ, x o = 0 → x ⬝ᵥ (A *ᵥ x) ≤ 0)
    (hi : 0 < hA.eigenvalues i) : eigenvector hA i o ≠ 0 := by
  intro hz
  have h := hdel (eigenvector hA i) hz
  rw [eigenvector_mul, dotProduct_smul, smul_eq_mul, eigenvector_dot] at h
  simp only [ite_true, mul_one] at h
  linarith

lemma positive_eigen_unique {A : Matrix J J ℝ} (hA : A.IsHermitian) (o : J)
    (hdel : ∀ x : J → ℝ, x o = 0 → x ⬝ᵥ (A *ᵥ x) ≤ 0)
    {i j : J} (hi : 0 < hA.eigenvalues i) (hj : 0 < hA.eigenvalues j) : i = j := by
  by_contra hij
  let u := eigenvector hA i
  let v := eigenvector hA j
  let z := v o • u - u o • v
  have hz : z o = 0 := by simp only [z, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]; ring
  have hq := hdel z hz
  have hu0 : u o ≠ 0 := positive_eigen_root_ne_zero hA o i hdel hi
  have hv0 : v o ≠ 0 := positive_eigen_root_ne_zero hA o j hdel hj
  have huv : u ⬝ᵥ v = 0 := by simp [u, v, eigenvector_dot, hij]
  have hvu : v ⬝ᵥ u = 0 := by rw [dotProduct_comm, huv]
  have huu : u ⬝ᵥ u = 1 := by simp [u, eigenvector_dot]
  have hvv : v ⬝ᵥ v = 1 := by simp [v, eigenvector_dot]
  have heq : z ⬝ᵥ (A *ᵥ z) =
      hA.eigenvalues i * (v o) ^ 2 + hA.eigenvalues j * (u o) ^ 2 := by
    simp only [z, mulVec_sub, mulVec_smul]
    rw [show A *ᵥ u = hA.eigenvalues i • u from eigenvector_mul hA i,
      show A *ᵥ v = hA.eigenvalues j • v from eigenvector_mul hA j]
    simp only [sub_dotProduct, dotProduct_sub, smul_dotProduct, dotProduct_smul,
      smul_eq_mul, huu, hvv, huv, hvu]
    ring
  rw [heq] at hq
  have h1 := mul_pos hi (sq_pos_of_ne_zero hv0)
  have h2 := mul_pos hj (sq_pos_of_ne_zero hu0)
  linarith

lemma positiveTrace_le_of_codim_one {A : Matrix J J ℝ} (hA : A.IsHermitian) (o : J)
    (hdel : ∀ x : J → ℝ, x o = 0 → x ⬝ᵥ (A *ᵥ x) ≤ 0)
    {L : ℝ} (hL : 0 ≤ L)
    (hbound : ∀ i, 0 < hA.eigenvalues i → hA.eigenvalues i ≤ L) :
    positiveTrace hA ≤ L := by
  rw [positiveTrace_eq_sum]
  by_cases hex : ∃ i, 0 < hA.eigenvalues i
  · obtain ⟨i, hi⟩ := hex
    rw [sum_eq_single i]
    · simpa only [max_eq_left hi.le] using hbound i hi
    · intro j _ hji
      apply max_eq_right
      by_contra! hj
      exact hji (positive_eigen_unique hA o hdel hj hi)
    · simp
  · push_neg at hex
    simpa only [fun j => max_eq_right (hex j), sum_const_zero] using hL

lemma positiveTrace_neg {A : Matrix J J ℝ} (hA : A.IsHermitian) :
    positiveTrace hA.neg = positiveTrace hA - A.trace := by
  have h1 : positiveTrace hA.neg ≤ (negPart hA).trace := by
    apply positiveTrace_le_trace hA.neg (negPart_psd hA)
    have heq : negPart hA - -A = posPart hA := by
      have h := parts_sub hA
      apply Matrix.ext
      intro i j
      have hh := congrFun (congrFun h i) j
      simp only [Matrix.sub_apply] at hh
      change negPart hA i j - -A i j = posPart hA i j
      linarith
    rw [heq]
    exact posPart_psd hA
  have h2 : positiveTrace hA ≤ (negPart hA.neg).trace := by
    apply positiveTrace_le_trace hA (negPart_psd hA.neg)
    have heq : negPart hA.neg - A = posPart hA.neg := by
      have h := parts_sub hA.neg
      apply Matrix.ext
      intro i j
      have hh := congrFun (congrFun h i) j
      simp only [Matrix.sub_apply, Matrix.neg_apply] at hh
      change negPart hA.neg i j - A i j = posPart hA.neg i j
      linarith
    rw [heq]
    exact posPart_psd hA.neg
  have h3 := trace_parts hA
  have h4 := trace_parts hA.neg
  rw [trace_neg] at h4
  linarith

lemma arrow_secular (c : ℝ) (g pole : J → ℝ) (i : Option J)
    (hden : ∀ j, (arrow_hermitian c g pole).eigenvalues i - pole j ≠ 0)
    (hq : eigenvector (arrow_hermitian c g pole) i none ≠ 0) :
    (arrow_hermitian c g pole).eigenvalues i - c =
      ∑ j, (g j) ^ 2 / ((arrow_hermitian c g pole).eigenvalues i - pole j) := by
  let hA := arrow_hermitian c g pole
  let x := hA.eigenvalues i
  let v := eigenvector hA i
  have hc (j : J) : v (some j) = g j * v none / (x - pole j) := by
    apply (eq_div_iff (hden j)).mpr
    have h := congrFun (eigenvector_mul hA i) (some j)
    rw [arrow_mul_some] at h
    change g j * v none + pole j * v (some j) = x * v (some j) at h
    nlinarith
  have h0 := congrFun (eigenvector_mul hA i) none
  rw [arrow_mul_none] at h0
  change c * v none + ∑ j, g j * v (some j) = x * v none at h0
  have hsum : ∑ j, g j * v (some j) =
      (∑ j, (g j) ^ 2 / (x - pole j)) * v none := by
    rw [sum_mul]
    apply sum_congr rfl
    intro j _
    rw [hc j]
    ring
  rw [hsum] at h0
  have heq : ((x - c) - ∑ j, (g j) ^ 2 / (x - pole j)) * v none = 0 := by
    nlinarith
  have hz := (mul_eq_zero.mp heq).resolve_right hq
  exact sub_eq_zero.mp hz

lemma arrow_nonpositive_bound (c : ℝ) (g pole : J → ℝ)
    (hpole : ∀ j, pole j ≤ 0) {L : ℝ} (hL : 0 ≤ L)
    (hzero : ∀ j, L - pole j = 0 → g j = 0)
    (htest : c + ∑ j, (g j) ^ 2 / (L - pole j) ≤ L) :
    positiveTrace (arrow_hermitian c g pole) ≤ L := by
  let hA := arrow_hermitian c g pole
  have hdel : ∀ v : Option J → ℝ, v none = 0 →
      v ⬝ᵥ ((arrow c g pole) *ᵥ v) ≤ 0 := by
    intro v hv
    rw [arrow_quad_zero c g pole v hv]
    exact sum_nonpos fun j _ => mul_nonpos_of_nonpos_of_nonneg (hpole j) (sq_nonneg _)
  apply positiveTrace_le_of_codim_one hA none hdel hL
  intro i hi
  by_contra! hbig
  have hden (j : J) : 0 < hA.eigenvalues i - pole j := by linarith [hpole j]
  have hs := arrow_secular c g pole i (fun j => (hden j).ne')
    (positive_eigen_root_ne_zero hA none i hdel hi)
  have hcompare : ∑ j, (g j) ^ 2 / (hA.eigenvalues i - pole j) ≤
      ∑ j, (g j) ^ 2 / (L - pole j) := by
    apply sum_le_sum
    intro j _
    by_cases hz : L - pole j = 0
    · simp [hzero j hz]
    · have hpos : 0 < L - pole j := lt_of_le_of_ne (by linarith [hpole j]) (Ne.symm hz)
      exact div_le_div_of_nonneg_left (sq_nonneg _) hpos (by linarith)
  change hA.eigenvalues i - c = _ at hs
  linarith

lemma arrow_positive_bound (D : ℝ) (g pole : J → ℝ) (hD : 0 < D)
    (hpole : ∀ j, 0 ≤ pole j) :
    positiveTrace (arrow_hermitian (-D) g pole) ≤
      (∑ j, pole j) + ∑ j, (g j) ^ 2 / (D + pole j) := by
  let S := ∑ j, (g j) ^ 2 / (D + pole j)
  have hS : 0 ≤ S := sum_nonneg fun j _ =>
    div_nonneg (sq_nonneg _) (by linarith [hpole j])
  have hneg : positiveTrace (arrow_hermitian D (-g) (-pole)) ≤ D + S := by
    apply arrow_nonpositive_bound D (-g) (-pole) (fun j => neg_nonpos.mpr (hpole j))
      (by linarith)
    · intro j hz
      change D + S - -pole j = 0 at hz
      linarith [hpole j]
    · have hcomp : ∑ j, (-g j) ^ 2 / (D + S - -pole j) ≤ S := by
        apply sum_le_sum
        intro j _
        rw [neg_sq]
        apply div_le_div_of_nonneg_left (sq_nonneg _)
        · linarith [hpole j]
        · linarith
      change D + (∑ j, (-g j) ^ 2 / (D + S - -pole j)) ≤ D + S
      simpa only [add_comm] using add_le_add_left hcomp D
  have heq : -(arrow (-D) g pole) = arrow D (-g) (-pole) := by
    apply Matrix.ext
    intro i j
    cases i <;> cases j <;> simp [arrow, Matrix.neg_apply]
    split_ifs <;> simp
  have hparts := positiveTrace_neg (arrow_hermitian (-D) g pole)
  have hneg' : positiveTrace (arrow_hermitian (-D) g pole).neg ≤ D + S := by
    simpa only [heq] using hneg
  have ht : (arrow (-D) g pole).trace = -D + ∑ j, pole j := by
    simp [Matrix.trace, Matrix.diag, Fintype.sum_option, arrow]
  rw [ht] at hparts
  change positiveTrace (arrow_hermitian (-D) g pole) ≤ (∑ j, pole j) + S
  linarith

def extend (z : J → ℝ) : Option J → ℝ := fun i => i.elim 0 z

def deletion (A : Matrix (Option J) (Option J) ℝ) : Matrix J J ℝ :=
  A.submatrix some some

lemma psd_root_cauchy {A : Matrix (Option J) (Option J) ℝ} (hA : A.PosSemidef)
    (z : J → ℝ) :
    (∑ j, A none (some j) * z j) ^ 2 ≤
      A none none * (z ⬝ᵥ ((deletion A) *ᵥ z)) := by
  have h := psd_cauchy hA (Pi.single none 1) (extend z)
  simpa [extend, deletion, Matrix.mulVec, dotProduct, Fintype.sum_option] using h

lemma coupling_cauchy {P N : Matrix (Option J) (Option J) ℝ}
    (hP : P.PosSemidef) (hN : N.PosSemidef) {c : ℝ} {g pole : J → ℝ}
    (heq : P - N = arrow c g pole) (z : J → ℝ) :
    (∑ j, g j * z j) ^ 2 ≤
      2 * P none none * (∑ j, pole j * z j ^ 2) +
      2 * (P none none + N none none) * (z ⬝ᵥ ((deletion N) *ᵥ z)) := by
  have hp := psd_root_cauchy hP z
  have hn := psd_root_cauchy hN z
  have hc : (∑ j, P none (some j) * z j) - (∑ j, N none (some j) * z j) =
      ∑ j, g j * z j := by
    rw [← sum_sub_distrib]
    apply sum_congr rfl
    intro j _
    have h := congrFun (congrFun heq none) (some j)
    change P none (some j) - N none (some j) = g j at h
    rw [← sub_mul, h]
  have hd : deletion P - deletion N = diagonal pole := by
    apply Matrix.ext
    intro i j
    have h := congrFun (congrFun heq (some i)) (some j)
    simpa [deletion, arrow, Matrix.sub_apply, diagonal_apply] using h
  have hq : z ⬝ᵥ ((deletion P) *ᵥ z) - z ⬝ᵥ ((deletion N) *ᵥ z) =
      ∑ j, pole j * z j ^ 2 := by
    rw [← dotProduct_sub, ← sub_mulVec, hd]
    simp only [dotProduct, mulVec_diagonal]
    apply sum_congr rfl
    intro j _
    ring
  have hs : (∑ j, g j * z j) ^ 2 ≤
      2 * (∑ j, P none (some j) * z j) ^ 2 +
      2 * (∑ j, N none (some j) * z j) ^ 2 := by
    rw [← hc]
    nlinarith [sq_nonneg ((∑ j, P none (some j) * z j) +
      (∑ j, N none (some j) * z j))]
  have hq' := congrArg (fun t => 2 * P none none * t) hq
  nlinarith [hq']

lemma resolvent_test {P N : Matrix (Option J) (Option J) ℝ}
    (hP : P.PosSemidef) (hN : N.PosSemidef) {c : ℝ} {g pole : J → ℝ}
    (heq : P - N = arrow c g pole) (hpole : ∀ j, 0 ≤ pole j)
    {D : ℝ} (hD : 0 < D) :
    (∑ j, (g j) ^ 2 / (D + pole j)) ≤
      2 * P none none +
        2 * (P none none + N none none) * (deletion N).trace / D := by
  let z : J → ℝ := fun j => g j / (D + pole j)
  let S := ∑ j, (g j) ^ 2 / (D + pole j)
  have hden (j : J) : 0 < D + pole j := by linarith [hpole j]
  have hS : 0 ≤ S := sum_nonneg fun j _ =>
    div_nonneg (sq_nonneg _) (hden j).le
  have hg : ∑ j, g j * z j = S := by
    apply sum_congr rfl
    intro j _
    dsimp [z]
    ring
  have henergy : ∑ j, (D + pole j) * z j ^ 2 = S := by
    apply sum_congr rfl
    intro j _
    dsimp [z]
    field_simp
  have hQ : (∑ j, pole j * z j ^ 2) ≤ S := by
    rw [← henergy]
    exact sum_le_sum fun j _ => mul_le_mul_of_nonneg_right
      (by linarith : pole j ≤ D + pole j) (sq_nonneg _)
  have hz : D * (z ⬝ᵥ z) ≤ S := by
    rw [← henergy, dotProduct, mul_sum]
    apply sum_le_sum
    intro j _
    have h := mul_le_mul_of_nonneg_right (hpole j) (sq_nonneg (z j))
    nlinarith
  have hNd := hN.submatrix (some : J → Option J)
  have he : 0 ≤ (deletion N).trace := hNd.trace_nonneg
  have hquad : z ⬝ᵥ ((deletion N) *ᵥ z) ≤ (deletion N).trace * S / D := by
    apply (le_div_iff₀ hD).mpr
    calc
      (z ⬝ᵥ ((deletion N) *ᵥ z)) * D ≤
          ((deletion N).trace * (z ⬝ᵥ z)) * D :=
        mul_le_mul_of_nonneg_right (psd_trace_bound hNd z) hD.le
      _ = (deletion N).trace * (D * (z ⬝ᵥ z)) := by ring
      _ ≤ (deletion N).trace * S := mul_le_mul_of_nonneg_left hz he
  have hcs := coupling_cauchy hP hN heq z
  rw [hg] at hcs
  have hfirst : 0 ≤ P none none := hP.diag_nonneg
  have hsecond : 0 ≤ N none none := hN.diag_nonneg
  have hbound : S ^ 2 ≤
      (2 * P none none +
        2 * (P none none + N none none) * (deletion N).trace / D) * S := by
    calc
      S ^ 2 ≤ 2 * P none none * (∑ j, pole j * z j ^ 2) +
          2 * (P none none + N none none) * (z ⬝ᵥ ((deletion N) *ᵥ z)) := hcs
      _ ≤ 2 * P none none * S +
          2 * (P none none + N none none) * ((deletion N).trace * S / D) := by
        gcongr
      _ = _ := by ring
  change S ≤ 2 * P none none +
    2 * (P none none + N none none) * (deletion N).trace / D
  by_cases hs : S = 0
  · rw [hs]
    exact add_nonneg (mul_nonneg (by norm_num) hfirst)
      (div_nonneg (mul_nonneg (mul_nonneg (by norm_num) (add_nonneg hfirst hsecond)) he) hD.le)
  · have hs' : 0 < S := lt_of_le_of_ne hS (Ne.symm hs)
    by_contra! hbad
    have hpos := mul_pos (sub_pos.mpr hbad) hs'
    nlinarith

lemma arrow_restrict {K : Type*} [Fintype K] [DecidableEq K]
    (c : ℝ) (g pole : J → ℝ) (f : K → J) (hf : Function.Injective f) :
    (arrow c g pole).submatrix (Option.map f) (Option.map f) =
      arrow c (g ∘ f) (pole ∘ f) := by
  apply Matrix.ext
  intro i j
  cases i <;> cases j <;> simp [Matrix.submatrix_apply, arrow, hf.eq_iff]

lemma restrict_difference {K : Type*} [Fintype K] [DecidableEq K]
    {P N : Matrix (Option J) (Option J) ℝ} {c : ℝ} {g pole : J → ℝ}
    (heq : P - N = arrow c g pole) (f : K → J) (hf : Function.Injective f) :
    P.submatrix (Option.map f) (Option.map f) -
        N.submatrix (Option.map f) (Option.map f) =
      arrow c (g ∘ f) (pole ∘ f) := by
  change (P - N).submatrix (Option.map f) (Option.map f) = _
  rw [heq, arrow_restrict c g pole f hf]

lemma arrow_negative (c : ℝ) (g pole : J → ℝ) :
    -(arrow c g pole) = arrow (-c) (-g) (-pole) := by
  apply Matrix.ext
  intro i j
  cases i <;> cases j <;> simp [arrow, Matrix.neg_apply]
  split_ifs <;> simp

lemma positiveTrace_diagonal_lipschitz {A B : Matrix J J ℝ}
    (hA : A.IsHermitian) (hB : B.IsHermitian) (o : J) (delta : ℝ)
    (heq : B - A = diagonal (Pi.single o delta)) :
    positiveTrace hB ≤ positiveTrace hA + max delta 0 := by
  let D : Matrix J J ℝ := diagonal (Pi.single o (max delta 0))
  have hD : D.PosSemidef := by
    apply posSemidef_diagonal_iff.mpr
    intro j
    by_cases h : j = o <;> simp [Pi.single_apply, h, le_max_right]
  have hrem : (D - (B - A)).PosSemidef := by
    rw [heq]
    change (diagonal (Pi.single o (max delta 0)) - diagonal (Pi.single o delta)).PosSemidef
    rw [diagonal_sub]
    apply posSemidef_diagonal_iff.mpr
    intro j
    by_cases h : j = o
    · simp [Pi.single_apply, h, sub_nonneg, le_max_left]
    · simp [Pi.single_apply, h]
  have hK : (posPart hA + D).PosSemidef := (posPart_psd hA).add hD
  have hKA : (posPart hA + D - B).PosSemidef := by
    have hid : posPart hA + D - B = negPart hA + (D - (B - A)) := by
      apply Matrix.ext
      intro i j
      have h := congrFun (congrFun (parts_sub hA) i) j
      simp only [Matrix.sub_apply] at h
      change posPart hA i j + D i j - B i j =
        negPart hA i j + (D i j - (B i j - A i j))
      linarith
    rw [hid]
    exact (negPart_psd hA).add hrem
  have h := positiveTrace_le_trace hB hK hKA
  have ht : D.trace = max delta 0 := by simp [D, Matrix.trace_diagonal]
  simpa only [trace_add, ht, positiveTrace] using h

lemma finite_exact {I : Type*} [Fintype I] (p f : I → ℝ) {M : ℝ}
    (happrox : ∀ epsilon : ℝ, 0 < epsilon →
      ∃ i, 0 < p i ∧ f i ≤ M + epsilon) :
    ∃ i, 0 < p i ∧ f i ≤ M := by
  classical
  let s := univ.filter (fun i => 0 < p i)
  have hs : s.Nonempty := by
    obtain ⟨i, hi, _⟩ := happrox 1 zero_lt_one
    exact ⟨i, by simp [s, hi]⟩
  obtain ⟨i, hi, hmin⟩ := s.exists_min_image f hs
  have hpi : 0 < p i := (mem_filter.mp hi).2
  refine ⟨i, hpi, ?_⟩
  by_contra! hbad
  obtain ⟨j, hj, hfj⟩ := happrox ((f i - M) / 2) (by linarith)
  have hji := hmin j (by simp [s, hj])
  linarith

lemma averaged_test {I : Type*} [Fintype I] (p : I → ℝ)
    (child : I → J → ℝ) (old denom : J → ℝ)
    (hmean : ∀ j, ∑ i, p i * (child i j) ^ 2 = (old j) ^ 2) :
    (∑ i, p i * (∑ j, (child i j) ^ 2 / denom j)) =
      ∑ j, (old j) ^ 2 / denom j := by
  simp_rw [mul_sum, ← mul_div_assoc]
  rw [sum_comm]
  apply sum_congr rfl
  intro j _
  rw [← sum_div, hmean j]

lemma split_trace {K L : Type*} [Fintype K] [Fintype L]
    (P : Matrix (Option (K ⊕ L)) (Option (K ⊕ L)) ℝ) :
    P.trace = P none none +
      (P.submatrix (fun j => some (Sum.inl j)) (fun j => some (Sum.inl j))).trace +
      (P.submatrix (fun j => some (Sum.inr j)) (fun j => some (Sum.inr j))).trace := by
  simp only [Matrix.trace, Matrix.diag, Fintype.sum_option, Fintype.sum_sum_type,
    Matrix.submatrix_apply]
  ring

lemma arrow_add (c d : ℝ) (g h pole root : J → ℝ) :
    arrow c g pole + arrow d h root = arrow (c + d) (g + h) (pole + root) := by
  apply Matrix.ext
  intro i j
  cases i <;> cases j <;> simp [arrow, Matrix.add_apply]
  split_ifs <;> simp

lemma arrow_difference_diagonal (c d : ℝ) (g pole : J → ℝ) :
    arrow c g pole - arrow d g pole = diagonal (Pi.single none (c - d)) := by
  apply Matrix.ext
  intro i j
  cases i <;> cases j <;> simp [arrow, Matrix.sub_apply, diagonal_apply]

theorem weighted_pinning_split
    {K L I : Type*} [Fintype K] [Fintype L] [Fintype I]
    [DecidableEq K] [DecidableEq L]
    (a beta : ℝ) (ha : 0 < a) (hbeta : 12 ≤ beta)
    (positive : K → ℝ) (negative : L → ℝ)
    (hpositive : ∀ j, 0 ≤ positive j) (hnegative : ∀ j, negative j ≤ 0)
    (p : I → ℝ) (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1)
    (g : K ⊕ L → ℝ) (child : I → K ⊕ L → ℝ)
    (hmean : ∀ j, ∑ i, p i * (child i j) ^ 2 = (g j) ^ 2) :
    ∃ i, 0 < p i ∧
      positiveTrace (arrow_hermitian (-beta * a) (child i) (Sum.elim positive negative)) -
        positiveTrace (arrow_hermitian (-a) g (Sum.elim positive negative)) ≤
      23 * posPart (arrow_hermitian (-a) g (Sum.elim positive negative)) none none := by
  classical
  let pole := Sum.elim positive negative
  let hH := arrow_hermitian (-a) g pole
  let P := posPart hH
  let N := negPart hH
  let m := P none none
  let ep := (N.submatrix (fun j => some (Sum.inl j)) (fun j => some (Sum.inl j))).trace
  let en := (P.submatrix (fun j => some (Sum.inr j)) (fun j => some (Sum.inr j))).trace
  let D := 8 * m + 4 * a
  let B := 12 * m + 8 * a
  have hP : P.PosSemidef := posPart_psd hH
  have hN : N.PosSemidef := negPart_psd hH
  have hm : 0 ≤ m := hP.diag_nonneg
  have hep : 0 ≤ ep := (hN.submatrix (fun j => some (Sum.inl j))).trace_nonneg
  have hen : 0 ≤ en := (hP.submatrix (fun j => some (Sum.inr j))).trace_nonneg
  have hD : 0 < D := by dsimp [D]; linarith
  have heq : P - N = arrow (-a) g pole := parts_sub hH
  have hn : N none none = m + a := by
    have h := congrFun (congrFun heq none) none
    change m - N none none = -a at h
    linarith
  have htleft :
      (P.submatrix (fun j => some (Sum.inl j)) (fun j => some (Sum.inl j))).trace -
        ep = ∑ j, positive j := by
    simp only [ep, Matrix.trace, Matrix.diag, Matrix.submatrix_apply]
    rw [← sum_sub_distrib]
    apply sum_congr rfl
    intro j _
    have h := congrFun (congrFun heq (some (Sum.inl j))) (some (Sum.inl j))
    simpa [arrow, pole, Matrix.sub_apply] using h
  have hold : positiveTrace hH = m + (∑ j, positive j) + ep + en := by
    change P.trace = m + (∑ j, positive j) + ep + en
    have hsplit := split_trace P
    change P.trace = m +
      (P.submatrix (fun j => some (Sum.inl j)) (fun j => some (Sum.inl j))).trace + en
      at hsplit
    linarith
  have htestp : ∑ j, (g (Sum.inl j)) ^ 2 / (D + positive j) ≤ 2 * m + ep / 2 := by
    have h := resolvent_test
      (hP.submatrix (Option.map (Sum.inl : K → K ⊕ L)))
      (hN.submatrix (Option.map (Sum.inl : K → K ⊕ L)))
      (restrict_difference heq (Sum.inl : K → K ⊕ L) Sum.inl_injective) hpositive hD
    change (∑ j, (g (Sum.inl j)) ^ 2 / (D + positive j)) ≤
      2 * m + 2 * (m + N none none) * ep / D at h
    rw [hn] at h
    have hr : 2 * (m + (m + a)) * ep / D = ep / 2 := by
      apply (div_eq_div_iff (ne_of_gt hD) (by norm_num : (2 : ℝ) ≠ 0)).mpr
      dsimp [D]
      ring
    rwa [hr] at h
  apply finite_exact p
    (fun i => positiveTrace (arrow_hermitian (-beta * a) (child i) pole) -
      positiveTrace hH)
  intro epsilon hepsilon
  let S := en + epsilon
  have hS : 0 < S := by dsimp [S]; linarith
  have htestn : ∑ j, (g (Sum.inr j)) ^ 2 / (S - negative j) ≤ 6 * m + 4 * a := by
    have hne : N - P = arrow a (-g) (-pole) := by
      calc
        N - P = -(P - N) := by abel
        _ = arrow a (-g) (-pole) := by rw [heq, arrow_negative]; simp
    have h := resolvent_test
      (hN.submatrix (Option.map (Sum.inr : L → K ⊕ L)))
      (hP.submatrix (Option.map (Sum.inr : L → K ⊕ L)))
      (restrict_difference hne (Sum.inr : L → K ⊕ L) Sum.inr_injective)
      (fun j => neg_nonneg.mpr (hnegative j)) hS
    simp only [Function.comp_apply, Pi.neg_apply, pole, Sum.elim_inr, neg_sq] at h
    change (∑ j, (g (Sum.inr j)) ^ 2 / (S - negative j)) ≤
      2 * N none none + 2 * (N none none + m) * en / S at h
    rw [hn] at h
    have hc : 0 ≤ 2 * ((m + a) + m) := by linarith
    have hfrac : 2 * ((m + a) + m) * en / S ≤ 2 * ((m + a) + m) := by
      apply (div_le_iff₀ hS).mpr
      exact mul_le_mul_of_nonneg_left (by dsimp [S]; linarith : en ≤ S) hc
    linarith
  let A : I → ℝ := fun i => ∑ j, (child i (Sum.inl j)) ^ 2 / (D + positive j)
  let C : I → ℝ := fun i => ∑ j, (child i (Sum.inr j)) ^ 2 / (S - negative j)
  have hA (i : I) : 0 ≤ A i := sum_nonneg fun j _ =>
    div_nonneg (sq_nonneg _) (by linarith [hpositive j])
  have hC (i : I) : 0 ≤ C i := sum_nonneg fun j _ =>
    div_nonneg (sq_nonneg _) (by linarith [hnegative j])
  have hmeanA : ∑ i, p i * A i ≤ 2 * m + ep / 2 := by
    rw [show (∑ i, p i * A i) =
        ∑ j, (g (Sum.inl j)) ^ 2 / (D + positive j) from
      averaged_test p (fun i j => child i (Sum.inl j)) (fun j => g (Sum.inl j))
        (fun j => D + positive j) (fun j => hmean (Sum.inl j))]
    exact htestp
  have hmeanC : ∑ i, p i * C i ≤ 6 * m + 4 * a := by
    rw [show (∑ i, p i * C i) =
        ∑ j, (g (Sum.inr j)) ^ 2 / (S - negative j) from
      averaged_test p (fun i j => child i (Sum.inr j)) (fun j => g (Sum.inr j))
        (fun j => S - negative j) (fun j => hmean (Sum.inr j))]
    exact htestn
  obtain ⟨i, hi, hai, hci⟩ := two_tests p A C hp hs hA hC
    (by linarith : 0 ≤ 2 * m + ep / 2) (by linarith : 0 ≤ 6 * m + 4 * a)
    hmeanA hmeanC
  have hai' : A i ≤ 4 * m + ep := by linarith
  have hci' : C i ≤ B := by dsimp [B]; linarith
  let gp : K ⊕ L → ℝ := Sum.elim (fun j => child i (Sum.inl j)) (fun _ => 0)
  let gm : K ⊕ L → ℝ := Sum.elim (fun _ => 0) (fun j => child i (Sum.inr j))
  let lp : K ⊕ L → ℝ := Sum.elim positive (fun _ => 0)
  let lm : K ⊕ L → ℝ := Sum.elim (fun _ => 0) negative
  let hplus := arrow_hermitian (-D) gp lp
  let hminus := arrow_hermitian (-B) gm lm
  have hlp (j : K ⊕ L) : 0 ≤ lp j := by
    cases j <;> simp only [lp, Sum.elim_inl, Sum.elim_inr]
    · exact hpositive _
    · rfl
  have hlm (j : K ⊕ L) : lm j ≤ 0 := by
    cases j <;> simp only [lm, Sum.elim_inl, Sum.elim_inr]
    · rfl
    · exact hnegative _
  have hcostp : positiveTrace hplus ≤ (∑ j, positive j) + (4 * m + ep) := by
    have h := arrow_positive_bound D gp lp hD hlp
    have h' : positiveTrace hplus ≤ (∑ j, positive j) + A i := by
      simpa [hplus, gp, lp, A, Fintype.sum_sum_type] using h
    linarith
  have hcostm : positiveTrace hminus ≤ S := by
    apply arrow_nonpositive_bound (-B) gm lm hlm hS.le
    · intro j hz
      have h := hlm j
      linarith
    · have htest : ∑ j, (gm j) ^ 2 / (S - lm j) = C i := by
        simp [gm, lm, C, Fintype.sum_sum_type]
      rw [htest]
      linarith
  have hsum : arrow (-D) gp lp + arrow (-B) gm lm =
      arrow (-D - B) (child i) pole := by
    rw [arrow_add]
    congr 1
    · funext j
      cases j <;> simp [gp, gm]
    · funext j
      cases j <;> simp [lp, lm, pole]
  let delta := D + B - beta * a
  have hdiff : arrow (-beta * a) (child i) pole -
      (arrow (-D) gp lp + arrow (-B) gm lm) =
      diagonal (Pi.single none delta) := by
    rw [hsum, arrow_difference_diagonal]
    congr 2
    dsimp [delta]
    ring
  have hdelta : max delta 0 ≤ 20 * m := by
    apply max_le
    · have hprod := mul_nonneg (sub_nonneg.mpr hbeta) ha.le
      dsimp [delta, D, B]
      nlinarith
    · linarith
  have hperturb := positiveTrace_diagonal_lipschitz (hplus.add hminus)
    (arrow_hermitian (-beta * a) (child i) pole) none delta hdiff
  have hadd := positiveTrace_subadditive hplus hminus
  refine ⟨i, hi, ?_⟩
  change positiveTrace (arrow_hermitian (-beta * a) (child i) pole) -
    positiveTrace hH ≤ 23 * m + epsilon
  dsimp [S] at hcostm
  linarith

lemma posPart_diag_eq {A : Matrix J J ℝ} (hA : A.IsHermitian) (o : J) :
    posPart hA o o =
      ∑ j, max (hA.eigenvalues j) 0 * (eigenvector hA j o) ^ 2 := by
  rw [posPart, conjStarAlgAut_apply]
  change ∑ j,
    ((hA.eigenvectorUnitary : Matrix J J ℝ) *
      diagonal (fun k => max (hA.eigenvalues k) 0)) o j *
        (star (hA.eigenvectorUnitary : Matrix J J ℝ)) j o = _
  simp only [mul_diagonal, star_eq_conjTranspose, conjTranspose_apply, star_trivial]
  apply sum_congr rfl
  intro j _
  rw [hA.eigenvectorUnitary_apply]
  dsimp [eigenvector]
  ring

theorem manuscript_arrow_assignment
    {K L I : Type*} [Fintype K] [Fintype L] [Fintype I] [Nonempty I]
    [DecidableEq K] [DecidableEq L]
    (a : ℝ) (ha : 0 < a) (positive : K → ℝ) (negative : L → ℝ)
    (hpositive : ∀ j, 0 ≤ positive j) (hnegative : ∀ j, negative j ≤ 0)
    (g : K ⊕ L → ℝ) (child : I → K ⊕ L → ℝ)
    (hmean : ∀ j, ∑ i, (child i j) ^ 2 / (Fintype.card I : ℝ) = (g j) ^ 2) :
    ∃ i,
      positiveTrace (arrow_hermitian (-(80 : ℝ) * a) (child i)
        (Sum.elim positive negative)) -
      positiveTrace (arrow_hermitian (-a) g (Sum.elim positive negative)) ≤
      24 * posPart (arrow_hermitian (-a) g (Sum.elim positive negative)) none none := by
  classical
  let p : I → ℝ := fun _ => 1 / (Fintype.card I : ℝ)
  have hc : 0 < (Fintype.card I : ℝ) := by exact_mod_cast Fintype.card_pos
  have hp (i : I) : 0 ≤ p i := div_nonneg zero_le_one hc.le
  have hs : ∑ i, p i = 1 := by simp [p, ne_of_gt hc]
  have hm : ∀ j, ∑ i, p i * (child i j) ^ 2 = (g j) ^ 2 := by
    intro j
    simpa [p, div_eq_mul_inv, mul_comm] using hmean j
  obtain ⟨i, _, hi⟩ := weighted_pinning_split a 80 ha (by norm_num)
    positive negative hpositive hnegative p hp hs g child hm
  refine ⟨i, ?_⟩
  have hmass := (posPart_psd (arrow_hermitian (-a) g (Sum.elim positive negative))).diag_nonneg
    (i := (none : Option (K ⊕ L)))
  linarith

end WeightedPinning
