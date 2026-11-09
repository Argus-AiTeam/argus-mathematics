import Mathlib

open scoped BigOperators Kronecker

noncomputable section

namespace ConeDrop

section PartialFlip

variable {A : Type*} [Ring A] [Algebra ℂ A]

def plusProjection (f : A) : A := (1 / 2 : ℂ) • (1 + f)

def minusProjection (f : A) : A := (1 / 2 : ℂ) • (1 - f)

def partialFlip (f : A) (z : ℂ) : A :=
  plusProjection f + z • minusProjection f

theorem projection_sum (f : A) :
    plusProjection f + minusProjection f = 1 := by
  dsimp [plusProjection, minusProjection]
  module

theorem projection_relations (f : A) (hf : f * f = 1) :
    plusProjection f * plusProjection f = plusProjection f ∧
    minusProjection f * minusProjection f = minusProjection f ∧
    plusProjection f * minusProjection f = 0 ∧
    minusProjection f * plusProjection f = 0 := by
  dsimp [plusProjection, minusProjection]
  simp only [smul_mul_assoc, mul_smul_comm, add_mul, mul_add,
    sub_mul, mul_sub, one_mul, mul_one, hf]
  constructor
  · module
  constructor
  · module
  constructor <;> module

theorem partialFlip_initial (f : A) : partialFlip f 1 = 1 := by
  simpa [partialFlip] using projection_sum f

theorem partialFlip_terminal (f : A) : partialFlip f (-1) = f := by
  dsimp [partialFlip, plusProjection, minusProjection]
  module

theorem partialFlip_terminal_difference (f : A) (z : ℂ) :
    partialFlip f z - f = (z + 1) • minusProjection f := by
  dsimp [partialFlip, plusProjection, minusProjection]
  module

def phase (s : ℝ) : ℂ := Complex.exp (((s * Real.pi : ℝ) : ℂ) * Complex.I)

def actualPath (f : A) (s : ℝ) : A := partialFlip f (phase s)

theorem phase_unitary (s : ℝ) : star (phase s) * phase s = 1 := by
  change starRingEnd ℂ (Complex.exp _) * Complex.exp _ = 1
  rw [← Complex.exp_conj, ← Complex.exp_add]
  simp

theorem actualPath_initial (f : A) : actualPath f 0 = 1 := by
  simp [actualPath, phase, partialFlip_initial]

theorem actualPath_terminal (f : A) : actualPath f 1 = f := by
  simp [actualPath, phase, Complex.exp_pi_mul_I, partialFlip_terminal]

variable [StarRing A] [StarModule ℂ A]

theorem projection_star (f : A) (hf : star f = f) :
    star (plusProjection f) = plusProjection f ∧
    star (minusProjection f) = minusProjection f := by
  simp [plusProjection, minusProjection, star_smul, hf]

theorem partialFlip_unitary (f : A) (z : ℂ)
    (hf : f * f = 1) (hs : star f = f) (hz : star z * z = 1) :
    star (partialFlip f z) * partialFlip f z = 1 ∧
    partialFlip f z * star (partialFlip f z) = 1 := by
  obtain ⟨hpp, hqq, hpq, hqp⟩ := projection_relations f hf
  obtain ⟨hp, hq⟩ := projection_star f hs
  have hz' : z * star z = 1 := by simpa [mul_comm] using hz
  constructor
  · simp only [partialFlip, star_add, star_smul, hp, hq, add_mul, mul_add,
      smul_mul_assoc, mul_smul_comm, smul_smul, hpp, hqq, hpq, hqp,
      smul_zero, zero_add, add_zero, hz', one_smul]
    exact projection_sum f
  · simp only [partialFlip, star_add, star_smul, hp, hq, add_mul, mul_add,
      smul_mul_assoc, mul_smul_comm, smul_smul, hpp, hqq, hpq, hqp,
      smul_zero, zero_add, add_zero, hz, one_smul]
    exact projection_sum f

theorem actualPath_unitary (f : A) (s : ℝ)
    (hf : f * f = 1) (hs : star f = f) :
    star (actualPath f s) * actualPath f s = 1 ∧
    actualPath f s * star (actualPath f s) = 1 :=
  partialFlip_unitary f (phase s) hf hs (phase_unitary s)

omit [Algebra ℂ A] [StarModule ℂ A] in
theorem conjugation_mul (u a b : A) (hu : star u * u = 1) :
    (u * a * star u) * (u * b * star u) = u * (a * b) * star u := by
  calc
    _ = u * a * (star u * u) * b * star u := by noncomm_ring
    _ = _ := by rw [hu]; simp [mul_assoc]

omit [Algebra ℂ A] [StarModule ℂ A] in
theorem conjugation_star (u a : A) :
    star (u * a * star u) = u * star a * star u := by
  simp [star_mul, mul_assoc]

end PartialFlip

section ActualFlip

variable (ι : Type*) [Fintype ι] [DecidableEq ι]

def flipMatrix : Matrix (ι × ι) (ι × ι) ℂ :=
  Equiv.Perm.permMatrix ℂ (Equiv.prodComm ι ι)

theorem flip_involution : flipMatrix ι * flipMatrix ι = 1 := by
  have h : (Equiv.prodComm ι ι : Equiv.Perm (ι × ι)) *
      Equiv.prodComm ι ι = 1 := by
    ext p <;> rfl
  rw [flipMatrix, ← Matrix.permMatrix_mul, h, Matrix.permMatrix_one]

omit [Fintype ι] in
theorem flip_selfadjoint : star (flipMatrix ι) = flipMatrix ι := by
  change (Equiv.Perm.permMatrix ℂ (Equiv.prodComm ι ι)).conjTranspose = _
  rw [Matrix.conjTranspose_permMatrix]
  rfl

theorem flip_swap (a : Matrix ι ι ℂ) :
    flipMatrix ι * (a ⊗ₖ (1 : Matrix ι ι ℂ)) * flipMatrix ι =
      (1 : Matrix ι ι ℂ) ⊗ₖ a := by
  change (Equiv.prodComm ι ι).toPEquiv.toMatrix *
    (a ⊗ₖ (1 : Matrix ι ι ℂ)) *
    (Equiv.prodComm ι ι).toPEquiv.toMatrix = _
  rw [PEquiv.toMatrix_toPEquiv_mul, PEquiv.mul_toMatrix_toPEquiv]
  ext i j
  rcases i with ⟨i₁, i₂⟩
  rcases j with ⟨j₁, j₂⟩
  simp [Matrix.submatrix_apply, mul_comm]

theorem matrix_partialFlip_unitary (z : ℂ) (hz : star z * z = 1) :
    star (partialFlip (flipMatrix ι) z) * partialFlip (flipMatrix ι) z = 1 ∧
    partialFlip (flipMatrix ι) z * star (partialFlip (flipMatrix ι) z) = 1 :=
  partialFlip_unitary _ _ (flip_involution ι) (flip_selfadjoint ι) hz

end ActualFlip

section UniformEndpoint

theorem actualPath_continuous {A : Type*} [NormedRing A] [NormedAlgebra ℂ A]
    (f : A) : Continuous (actualPath f) := by
  unfold actualPath phase partialFlip
  fun_prop

variable {A : Type*} [NormedRing A] [StarRing A] [NormedStarGroup A]

theorem uniform_conjugation_bound (u f a : A)
    (hu : ‖u‖ ≤ 1) (hf : ‖f‖ ≤ 1) :
    ‖u * a * star u - f * a * star f‖ ≤ 2 * ‖a‖ * ‖u - f‖ := by
  have hid : u * a * star u - f * a * star f =
      (u - f) * a * star u + f * a * (star u - star f) := by
    noncomm_ring
  rw [hid]
  calc
    _ ≤ ‖(u - f) * a * star u‖ + ‖f * a * (star u - star f)‖ :=
      norm_add_le _ _
    _ ≤ ‖u - f‖ * ‖a‖ * ‖u‖ + ‖f‖ * ‖a‖ * ‖u - f‖ := by
      apply add_le_add
      · calc
          _ ≤ ‖(u - f) * a‖ * ‖star u‖ := norm_mul_le _ _
          _ ≤ ‖u - f‖ * ‖a‖ * ‖u‖ := by
            rw [norm_star]
            exact mul_le_mul_of_nonneg_right (norm_mul_le _ _) (norm_nonneg _)
      · calc
          _ ≤ ‖f * a‖ * ‖star u - star f‖ := norm_mul_le _ _
          _ = ‖f * a‖ * ‖u - f‖ := by rw [← star_sub, norm_star]
          _ ≤ ‖f‖ * ‖a‖ * ‖u - f‖ :=
            mul_le_mul_of_nonneg_right (norm_mul_le _ _) (norm_nonneg _)
    _ ≤ ‖u - f‖ * ‖a‖ * 1 + 1 * ‖a‖ * ‖u - f‖ := by gcongr
    _ = 2 * ‖a‖ * ‖u - f‖ := by ring

end UniformEndpoint

section ScalarGeometry

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def gap (δ t : ℝ) : ℝ := max (1 - 2 * t / δ) 0

def cut (δ t : ℝ) : ℝ := max (t - δ) 0

def weight (t : ι → ℝ) (d : ℝ) (i : ι) : ℝ :=
  max (t i / d - 1 / 2) 0

def normalizedWeight (t : ι → ℝ) (d : ℝ) (i : ι) : ℝ :=
  weight t d i / ∑ j, weight t d j

theorem gap_bounds (δ t : ℝ) (hδ : 0 < δ) (ht : 0 ≤ t) :
    0 ≤ gap δ t ∧ gap δ t ≤ 1 ∧ 1 - gap δ t ≤ 2 * t / δ := by
  have h : 0 ≤ 2 * t / δ := div_nonneg (by positivity) hδ.le
  dsimp [gap]
  constructor
  · exact le_max_right _ _
  constructor
  · exact max_le (by linarith) (by norm_num)
  · have := le_max_left (1 - 2 * t / δ) 0
    linarith

theorem cut_gap_zero (δ t : ℝ) (hδ : 0 < δ) :
    cut δ t * gap δ t = 0 := by
  by_cases ht : t ≤ δ
  · simp [cut, max_eq_right (sub_nonpos.mpr ht)]
  · have ht' : δ < t := lt_of_not_ge ht
    have h : 1 - 2 * t / δ ≤ 0 := by
      have : δ ≤ 2 * t := by linarith
      have hdiv : (1 : ℝ) ≤ 2 * t / δ := (le_div_iff₀ hδ).2 (by simpa using this)
      linarith
    simp [gap, max_eq_right h]

theorem cut_positive (δ t : ℝ) : 0 < cut δ t ↔ δ < t := by
  simp [cut]

theorem gap_positive (δ t : ℝ) (hδ : 0 < δ) :
    0 < gap δ t ↔ t < δ / 2 := by
  rw [gap, lt_max_iff]
  have he : 0 < 1 - 2 * t / δ ↔ t < δ / 2 := by
    constructor
    · intro h
      have : 2 * t / δ < 1 := by linarith
      have := (div_lt_iff₀ hδ).1 this
      linarith
    · intro h
      have : 2 * t < δ := by linarith
      have hdiv : 2 * t / δ < 1 := (div_lt_iff₀ hδ).2 (by simpa using this)
      linarith
  simpa using he

omit [Fintype ι] [DecidableEq ι] in
theorem weight_at_max (t : ι → ℝ) (d : ℝ) (j : ι)
    (hd : 0 < d) (hj : t j = d) : weight t d j = 1 / 2 := by
  simp [weight, hj, ne_of_gt hd]
  norm_num

omit [DecidableEq ι] in
theorem denominator_bound (t : ι → ℝ) (d : ℝ) (j : ι)
    (hd : 0 < d) (hj : t j = d) :
    (1 / 2 : ℝ) ≤ ∑ i, weight t d i := by
  rw [← weight_at_max t d j hd hj]
  have hn (i : ι) : 0 ≤ weight t d i := le_max_right _ _
  exact Finset.single_le_sum (fun i _ => hn i) (Finset.mem_univ j)

theorem weights_sum (t : ι → ℝ) (d : ℝ) (j : ι)
    (hd : 0 < d) (hj : t j = d) :
    (∑ i, normalizedWeight t d i) = 1 := by
  have hpos : 0 < ∑ i, weight t d i := by
    have := denominator_bound t d j hd hj
    linarith
  simp [normalizedWeight, ← Finset.sum_div, ne_of_gt hpos]

omit [DecidableEq ι] in
theorem zero_face (t : ι → ℝ) (d : ℝ) (i : ι) (hi : t i = 0) :
    normalizedWeight t d i = 0 := by
  norm_num [normalizedWeight, weight, hi]

omit [DecidableEq ι] in
theorem finite_maximum [Nonempty ι] (t : ι → ℝ)
    (ht : ∃ i, 0 < t i) :
    ∃ j, 0 < t j ∧ ∀ i, t i ≤ t j := by
  obtain ⟨j, _, hj⟩ := Finset.exists_max_image Finset.univ t Finset.univ_nonempty
  obtain ⟨i, hi⟩ := ht
  exact ⟨j, lt_of_lt_of_le hi (hj i (Finset.mem_univ i)),
    fun i => hj i (Finset.mem_univ i)⟩

theorem axis_weights (δ : ℝ) (hδ : 0 < δ) (t : ι → ℝ) (j : ι)
    (hj : δ < t j) (hi : ∀ i, i ≠ j → t i < δ / 2) :
    ∀ i, normalizedWeight t (t j) i = if i = j then 1 else 0 := by
  have htj : 0 < t j := lt_trans hδ hj
  have hw : ∀ i, weight t (t j) i = if i = j then 1 / 2 else 0 := by
    intro i
    by_cases hij : i = j
    · subst i
      simp [weight_at_max t (t j) j htj rfl]
    · have hsmall := hi i hij
      have hratio : t i / t j ≤ 1 / 2 := by
        apply (div_le_iff₀ htj).2
        linarith
      rw [if_neg hij]
      exact max_eq_right (by linarith)
  intro i
  simp [normalizedWeight, hw]

omit [Fintype ι] in
theorem product_defect_bound (s : Finset ι) (x : ι → ℝ)
    (hx : ∀ i ∈ s, 0 ≤ x i ∧ x i ≤ 1) :
    0 ≤ 1 - ∏ i ∈ s, x i ∧
    1 - ∏ i ∈ s, x i ≤ ∑ i ∈ s, (1 - x i) := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
      have ha' := hx a (Finset.mem_insert_self a s)
      have hs : ∀ i ∈ s, 0 ≤ x i ∧ x i ≤ 1 :=
        fun i hi => hx i (Finset.mem_insert_of_mem hi)
      obtain ⟨hp, hb⟩ := ih hs
      have hprod : 0 ≤ ∏ i ∈ s, x i :=
        Finset.prod_nonneg (fun i hi => (hs i hi).1)
      rw [Finset.prod_insert ha, Finset.sum_insert ha]
      constructor
      · nlinarith
      · have hh : 0 ≤ (1 - x a) * (1 - ∏ i ∈ s, x i) :=
          mul_nonneg (by linarith) hp
        nlinarith

omit [Fintype ι] in
theorem cube_origin_bound (s : Finset ι) (δ : ℝ) (hδ : 0 < δ)
    (t : ι → ℝ) (ht : ∀ i ∈ s, 0 ≤ t i) :
    0 ≤ 1 - ∏ i ∈ s, gap δ (t i) ∧
    1 - ∏ i ∈ s, gap δ (t i) ≤ (2 / δ) * ∑ i ∈ s, t i := by
  obtain ⟨hpos, hbound⟩ := product_defect_bound s (fun i => gap δ (t i))
    (fun i hi => ⟨(gap_bounds δ (t i) hδ (ht i hi)).1,
      (gap_bounds δ (t i) hδ (ht i hi)).2.1⟩)
  refine ⟨hpos, hbound.trans ?_⟩
  calc
    _ ≤ ∑ i ∈ s, 2 * t i / δ :=
      Finset.sum_le_sum (fun i hi => (gap_bounds δ (t i) hδ (ht i hi)).2.2)
    _ = _ := by simp only [Finset.mul_sum]; apply Finset.sum_congr rfl; intros; ring

end ScalarGeometry

section Multiplicities

theorem exponential_dominates (N : ℕ) : N ≤ 2 ^ N := by
  induction N with
  | zero => norm_num
  | succ N ih =>
      have hp : 1 ≤ 2 ^ N := Nat.one_le_pow N 2 (by omega)
      rw [pow_succ]
      omega

theorem amplification_parameters (d N : ℕ) (hd : 2 ≤ d) (hN : 1 ≤ N) :
    ∃ L : ℕ, 1 ≤ L ∧ N ≤ d ^ L ∧ 1 ≤ N ^ L ∧ 1 ≤ N ^ L + L := by
  refine ⟨N, hN, ?_, ?_, ?_⟩
  · exact (exponential_dominates N).trans (Nat.pow_le_pow_left hd N)
  · exact Nat.one_le_pow _ _ hN
  · have := Nat.one_le_pow N N hN
    omega

theorem tensor_word_count (d L : ℕ) :
    Fintype.card (Fin L → Fin d) = d ^ L := by
  simp

variable {A B D : Type*}
  [AddCommMonoid A] [Preorder A]
  [AddCommMonoid B] [Preorder B]
  [AddCommMonoid D] [Preorder D]

theorem tensor_absorption (T : A →+ B →+ D)
    (hleft : ∀ b, Monotone (fun a => T a b))
    (hright : ∀ a, Monotone (T a))
    (x y : A) (e u : B) (N k : ℕ)
    (hupper : u ≤ k • e) (hdefect : k • x ≤ N • y)
    (hlower : N • e ≤ u) : T x u ≤ T y u := by
  calc
    T x u ≤ T x (k • e) := hright x hupper
    _ = T (k • x) e := by simp
    _ ≤ T (N • y) e := hleft e hdefect
    _ = T y (N • e) := by simp
    _ ≤ T y u := hright y hlower

end Multiplicities

end ConeDrop
