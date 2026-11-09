import Mathlib

/-!
Finite-dimensional cubic trace bound.  Every operator norm in this file is the norm of
`Matrix.toEuclideanCLM`, acting on complex Euclidean space.

The proof removes the least index by finite-set induction and proves the full cyclic
three-case expansion.  The repeated-index estimate uses the coordinate bound on
`D (tailVector ...)` and weighted Young's inequality; the distinct-minimum estimate
uses the Euclidean inner-product inequality.  Division by zero in the spectral cost
is handled explicitly, with no regularization or positive-definiteness hypothesis.
-/

open scoped ComplexConjugate
open scoped Matrix
open WithLp
open Finset

noncomputable section

namespace SharedTraceCubic

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def cubicEntry (m : ι → ℝ) (D : Matrix ι ι ℂ) (i j k : ι) : ℂ :=
  (m i : ℂ) * (m j : ℂ) * (m k : ℂ) * D i j * D j k * D k i

def cubicSum (m : ι → ℝ) (D : Matrix ι ι ℂ) (s : Finset ι) : ℂ :=
  ∑ i ∈ s, ∑ j ∈ s, ∑ k ∈ s, cubicEntry m D i j k

def weight (m : ι → ℝ) (D : Matrix ι ι ℂ) (i j : ι) : ℝ :=
  (|m i| ^ 2 * |m j| ^ 2 / (|m i| + |m j|)) * Complex.normSq (D i j)

def cost (m : ι → ℝ) (D : Matrix ι ι ℂ) (s : Finset ι) : ℝ :=
  ∑ i ∈ s, ∑ j ∈ s, weight m D i j

def tailVector (m : ι → ℝ) (D : Matrix ι ι ℂ) (s : Finset ι) (a : ι) :
    EuclideanSpace ℂ ι :=
  toLp 2 fun j => if j ∈ s then (m j : ℂ) * D j a else 0

omit [Fintype ι] [DecidableEq ι] in
lemma cubicEntry_cycle (m : ι → ℝ) (D : Matrix ι ι ℂ) (i j k : ι) :
    cubicEntry m D i j k = cubicEntry m D j k i := by
  unfold cubicEntry
  ring

omit [Fintype ι] in
lemma triple_sum_insert (f : ι → ι → ι → ℂ)
    (hcyc : ∀ i j k, f i j k = f j k i) (s : Finset ι) (a : ι) (ha : a ∉ s) :
    (∑ i ∈ insert a s, ∑ j ∈ insert a s, ∑ k ∈ insert a s, f i j k) =
      (∑ i ∈ s, ∑ j ∈ s, ∑ k ∈ s, f i j k) + f a a a +
        3 * (∑ j ∈ s, f a a j) + 3 * (∑ j ∈ s, ∑ k ∈ s, f a j k) := by
  have h₁ : ∀ j, f a j a = f a a j :=
    fun j => (hcyc a j a).trans (hcyc j a a)
  have h₂ : ∀ j, f j a a = f a a j := fun j => hcyc j a a
  have h₃ : (∑ i ∈ s, ∑ k ∈ s, f i a k) = ∑ j ∈ s, ∑ k ∈ s, f a j k := by
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j hj
    apply Finset.sum_congr rfl
    intro k hk
    exact (hcyc k a j)
  have h₄ : (∑ i ∈ s, ∑ j ∈ s, f i j a) = ∑ j ∈ s, ∑ k ∈ s, f a j k := by
    apply Finset.sum_congr rfl
    intro j hj
    apply Finset.sum_congr rfl
    intro k hk
    exact (hcyc j k a).trans (hcyc k a j)
  simp only [Finset.sum_insert ha, Finset.sum_add_distrib]
  simp_rw [h₁, h₂]
  rw [h₃, h₄]
  ring

omit [Fintype ι] in
lemma cubicSum_insert (m : ι → ℝ) (D : Matrix ι ι ℂ)
    (s : Finset ι) (a : ι) (ha : a ∉ s) :
    cubicSum m D (insert a s) =
      cubicSum m D s + cubicEntry m D a a a +
        3 * (∑ j ∈ s, cubicEntry m D a a j) +
        3 * (∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k) :=
  triple_sum_insert _ (cubicEntry_cycle m D) s a ha

omit [Fintype ι] [DecidableEq ι] in
lemma normSq_symm (D : Matrix ι ι ℂ) (hD : D.IsHermitian) (i j : ι) :
    Complex.normSq (D i j) = Complex.normSq (D j i) := by
  rw [← hD.apply i j]
  exact Complex.normSq_conj _

omit [Fintype ι] [DecidableEq ι] in
lemma weight_symm (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian) (i j : ι) :
    weight m D i j = weight m D j i := by
  unfold weight
  rw [normSq_symm D hD i j, add_comm (|m i|) (|m j|)]
  ring

omit [Fintype ι] in
lemma cost_insert (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian)
    (s : Finset ι) (a : ι) (ha : a ∉ s) :
    cost m D (insert a s) =
      cost m D s + weight m D a a + 2 * ∑ j ∈ s, weight m D a j := by
  unfold cost
  simp only [Finset.sum_insert ha, Finset.sum_add_distrib]
  have h : (∑ j ∈ s, weight m D j a) = ∑ j ∈ s, weight m D a j :=
    Finset.sum_congr rfl fun j _ => weight_symm m D hD j a
  rw [h]
  ring

omit [Fintype ι] [DecidableEq ι] in
lemma weight_diag (m : ι → ℝ) (D : Matrix ι ι ℂ) (a : ι) :
    weight m D a a = |m a| ^ 3 * Complex.normSq (D a a) / 2 := by
  unfold weight
  by_cases h : |m a| = 0
  · simp [h]
  · field_simp
    ring

lemma weight_cross_lower (q t r : ℝ) (hq : 0 ≤ q) (ht : 0 ≤ t)
    (htq : t ≤ q) (hr : 0 ≤ r) :
    q * t ^ 2 * r ≤ 2 * (q ^ 2 * t ^ 2 / (q + t) * r) := by
  by_cases h : q + t = 0
  · have hq0 : q = 0 := by linarith
    simp [hq0]
  · have hp : 0 < q + t := lt_of_le_of_ne (by positivity) (Ne.symm h)
    have hbase : q * t ^ 2 ≤ 2 * (q ^ 2 * t ^ 2 / (q + t)) := by
      rw [← mul_div_assoc, le_div_iff₀ hp]
      have hn := mul_nonneg (mul_nonneg hq (sq_nonneg t)) (sub_nonneg.mpr htq)
      nlinarith
    nlinarith [mul_le_mul_of_nonneg_right hbase hr]

lemma entry_norm_le (D : Matrix ι ι ℂ) (c : ℝ)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖)
    (i j : ι) : ‖D i j‖ ≤ c := by
  let e : EuclideanSpace ℂ ι := EuclideanSpace.single j 1
  have he : ‖e‖ = 1 := by simp [e]
  have hv : (Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D e) i = D i j := by
    change (D *ᵥ (Pi.single j (1 : ℂ))) i = D i j
    rw [Matrix.mulVec_single_one]
    rfl
  calc
    ‖D i j‖ = ‖(Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D e) i‖ := by rw [hv]
    _ ≤ ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D e‖ := PiLp.norm_apply_le _ _
    _ ≤ c * ‖e‖ := hop e
    _ = c := by rw [he, mul_one]

lemma tailVector_norm_sq (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian)
    (s : Finset ι) (a : ι) :
    ‖tailVector m D s a‖ ^ 2 = ∑ j ∈ s, |m j| ^ 2 * Complex.normSq (D a j) := by
  rw [EuclideanSpace.norm_sq_eq]
  calc
    (∑ j, ‖(tailVector m D s a) j‖ ^ 2) =
        ∑ j, if j ∈ s then |m j| ^ 2 * Complex.normSq (D a j) else 0 := by
      apply Finset.sum_congr rfl
      intro j hj
      by_cases h : j ∈ s
      · simp [tailVector, h, Complex.norm_real, Real.norm_eq_abs,
          mul_pow, Complex.sq_norm, normSq_symm D hD j a]
      · simp [tailVector, h]
    _ = ∑ j ∈ s, |m j| ^ 2 * Complex.normSq (D a j) := by simp

lemma repeated_sum_eq (m : ι → ℝ) (D : Matrix ι ι ℂ) (s : Finset ι) (a : ι) :
    (∑ j ∈ s, cubicEntry m D a a j) =
      (m a : ℂ) ^ 2 * D a a *
        (Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D (tailVector m D s a)) a := by
  simp only [tailVector, Matrix.toEuclideanCLM_toLp, PiLp.toLp_apply, Matrix.mulVec, dotProduct,
    mul_ite, mul_zero, Finset.sum_ite_mem, Finset.univ_inter, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  unfold cubicEntry
  ring

lemma unique_sum_eq (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian)
    (s : Finset ι) (a : ι) :
    (∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k) =
      (m a : ℂ) *
        inner ℂ (tailVector m D s a)
          (Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D (tailVector m D s a)) := by
  simp only [PiLp.inner_apply, RCLike.inner_apply, tailVector,
    Matrix.toEuclideanCLM_toLp, Matrix.mulVec, dotProduct,
    apply_ite, map_mul, map_zero, starRingEnd_apply, hD.apply,
    mul_zero, Finset.sum_ite_mem, Finset.sum_mul,
    Finset.univ_inter, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  apply Finset.sum_congr rfl
  intro k hk
  unfold cubicEntry
  rw [Complex.star_def, Complex.conj_ofReal]
  ring

lemma diagonal_bound (m : ι → ℝ) (D : Matrix ι ι ℂ) (c : ℝ)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖) (a : ι) :
    ‖cubicEntry m D a a a‖ ≤ c * (|m a| ^ 3 * Complex.normSq (D a a)) := by
  calc
    ‖cubicEntry m D a a a‖ =
        (|m a| ^ 3 * ‖D a a‖ ^ 2) * ‖D a a‖ := by
      simp only [cubicEntry, norm_mul, Complex.norm_real, Real.norm_eq_abs]
      ring
    _ ≤ (|m a| ^ 3 * ‖D a a‖ ^ 2) * c :=
      mul_le_mul_of_nonneg_left (entry_norm_le D c hop a a) (by positivity)
    _ = c * (|m a| ^ 3 * Complex.normSq (D a a)) := by
      rw [Complex.normSq_eq_norm_sq]
      ring

lemma repeated_bound (m : ι → ℝ) (D : Matrix ι ι ℂ) (c : ℝ) (hc : 0 ≤ c)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖)
    (s : Finset ι) (a : ι) :
    ‖∑ j ∈ s, cubicEntry m D a a j‖ ≤
      c / 2 * (|m a| ^ 3 * Complex.normSq (D a a) +
        |m a| * ‖tailVector m D s a‖ ^ 2) := by
  have hx :
      ‖(Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D (tailVector m D s a)) a‖ ≤
        c * ‖tailVector m D s a‖ :=
    (PiLp.norm_apply_le _ _).trans (hop _)
  calc
    ‖∑ j ∈ s, cubicEntry m D a a j‖ =
        |m a| ^ 2 * ‖D a a‖ *
          ‖(Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D (tailVector m D s a)) a‖ := by
      rw [repeated_sum_eq]
      simp only [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs]
    _ ≤ |m a| ^ 2 * ‖D a a‖ * (c * ‖tailVector m D s a‖) :=
      mul_le_mul_of_nonneg_left hx (by positivity)
    _ ≤ c / 2 * (|m a| ^ 3 * Complex.normSq (D a a) +
        |m a| * ‖tailVector m D s a‖ ^ 2) := by
      rw [Complex.normSq_eq_norm_sq]
      have h := mul_nonneg (mul_nonneg hc (abs_nonneg (m a)))
        (sq_nonneg (|m a| * ‖D a a‖ - ‖tailVector m D s a‖))
      nlinarith

lemma unique_bound (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian) (c : ℝ)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖)
    (s : Finset ι) (a : ι) :
    ‖∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k‖ ≤
      c * (|m a| * ‖tailVector m D s a‖ ^ 2) := by
  calc
    ‖∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k‖ =
        |m a| * ‖inner ℂ (tailVector m D s a)
          (Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D (tailVector m D s a))‖ := by
      rw [unique_sum_eq m D hD]
      simp only [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    _ ≤ |m a| * (‖tailVector m D s a‖ *
        ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D (tailVector m D s a)‖) :=
      mul_le_mul_of_nonneg_left (norm_inner_le_norm _ _) (abs_nonneg _)
    _ ≤ |m a| * (‖tailVector m D s a‖ * (c * ‖tailVector m D s a‖)) := by
      gcongr
      exact hop _
    _ = c * (|m a| * ‖tailVector m D s a‖ ^ 2) := by ring

lemma tail_cost_lower (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian)
    (s : Finset ι) (a : ι) (horder : ∀ j ∈ s, |m j| ≤ |m a|) :
    |m a| * ‖tailVector m D s a‖ ^ 2 ≤ 2 * ∑ j ∈ s, weight m D a j := by
  rw [tailVector_norm_sq m D hD, Finset.mul_sum, Finset.mul_sum]
  apply Finset.sum_le_sum
  intro j hj
  simpa only [weight, mul_assoc] using
    weight_cross_lower (|m a|) (|m j|) (Complex.normSq (D a j))
      (abs_nonneg _) (abs_nonneg _) (horder j hj) (Complex.normSq_nonneg _)

lemma increment_bound (m : ι → ℝ) (D : Matrix ι ι ℂ) (hD : D.IsHermitian)
    (c : ℝ) (hc : 0 ≤ c)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖)
    (s : Finset ι) (a : ι) (horder : ∀ j ∈ s, |m j| ≤ |m a|) :
    ‖cubicEntry m D a a a‖ + 3 * ‖∑ j ∈ s, cubicEntry m D a a j‖ +
        3 * ‖∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k‖ ≤
      5 * c * (weight m D a a + 2 * ∑ j ∈ s, weight m D a j) := by
  have hd := diagonal_bound m D c hop a
  have hr := repeated_bound m D c hc hop s a
  have hu := unique_bound m D hD c hop s a
  have he := tail_cost_lower m D hD s a horder
  have hce := mul_le_mul_of_nonneg_left he hc
  have hnon : 0 ≤ c * (|m a| * ‖tailVector m D s a‖ ^ 2) := by positivity
  rw [weight_diag]
  nlinarith

theorem cubicSum_bound [LinearOrder ι] (m : ι → ℝ)
    (hsorted : Antitone fun i => |m i|) (D : Matrix ι ι ℂ) (hD : D.IsHermitian)
    (c : ℝ) (hc : 0 ≤ c)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖)
    (s : Finset ι) : ‖cubicSum m D s‖ ≤ 5 * c * cost m D s := by
  induction s using Finset.induction_on_min with
  | empty => simp [cubicSum, cost]
  | insert a s hmin ih =>
    have ha : a ∉ s := fun h => (lt_irrefl a) (hmin a h)
    have horder : ∀ j ∈ s, |m j| ≤ |m a| :=
      fun j hj => hsorted (le_of_lt (hmin j hj))
    have hi := increment_bound m D hD c hc hop s a horder
    rw [cubicSum_insert m D s a ha]
    calc
      ‖cubicSum m D s + cubicEntry m D a a a +
          3 * (∑ j ∈ s, cubicEntry m D a a j) +
          3 * (∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k)‖ ≤
          ‖cubicSum m D s‖ + ‖cubicEntry m D a a a‖ +
            ‖3 * (∑ j ∈ s, cubicEntry m D a a j)‖ +
            ‖3 * (∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k)‖ :=
        (norm_add_le _ _).trans (add_le_add
          ((norm_add_le _ _).trans (add_le_add (norm_add_le _ _) le_rfl)) le_rfl)
      _ = ‖cubicSum m D s‖ +
          (‖cubicEntry m D a a a‖ + 3 * ‖∑ j ∈ s, cubicEntry m D a a j‖ +
            3 * ‖∑ j ∈ s, ∑ k ∈ s, cubicEntry m D a j k‖) := by
        norm_num [norm_mul]
        ring
      _ ≤ 5 * c * cost m D s +
          5 * c * (weight m D a a + 2 * ∑ j ∈ s, weight m D a j) :=
        add_le_add ih hi
      _ = 5 * c * cost m D (insert a s) := by
        rw [cost_insert m D hD s a ha]
        ring

lemma trace_cube_expand (A : Matrix ι ι ℂ) :
    Matrix.trace (A ^ 3) = ∑ i, ∑ j, ∑ k, A i j * A j k * A k i := by
  simp only [pow_succ, pow_zero, Matrix.one_mul, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.sum_comm]

lemma trace_cube_diagonal (m : ι → ℝ) (D : Matrix ι ι ℂ) :
    Matrix.trace ((D * Matrix.diagonal (fun i => (m i : ℂ))) ^ 3) =
      cubicSum m D univ := by
  rw [trace_cube_expand]
  unfold cubicSum
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  apply Finset.sum_congr rfl
  intro k hk
  simp only [Matrix.mul_diagonal, cubicEntry]
  ring

/-- The complete spectral cubic estimate under an actual, fully quantified Euclidean
operator bound.  No invertibility or strict ordering is assumed. -/
theorem spectral_cubic_bound_of_euclidean_bound [LinearOrder ι]
    (m : ι → ℝ) (hsorted : Antitone fun i => |m i|)
    (D : Matrix ι ι ℂ) (hD : D.IsHermitian) (c : ℝ) (hc : 0 ≤ c)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖) :
    ‖Matrix.trace ((D * Matrix.diagonal (fun i => (m i : ℂ))) ^ 3)‖ ≤
      5 * c * ∑ i, ∑ j,
        (|m i| ^ 2 * |m j| ^ 2 / (|m i| + |m j|)) * Complex.normSq (D i j) := by
  rw [trace_cube_diagonal]
  exact cubicSum_bound m hsorted D hD c hc hop univ

/-- Here the operator norm is explicitly the induced Euclidean norm, not the
entrywise matrix norm.  This includes `N = 0`, tied moduli, and zero eigenvalues. -/
theorem spectral_cubic_bound {N : ℕ} (m : Fin N → ℝ)
    (hsorted : Antitone fun i => |m i|)
    (D : Matrix (Fin N) (Fin N) ℂ) (hD : D.IsHermitian) :
    ‖Matrix.trace ((D * Matrix.diagonal (fun i => (m i : ℂ))) ^ 3)‖ ≤
      5 * ‖Matrix.toEuclideanCLM (n := Fin N) (𝕜 := ℂ) D‖ *
        ∑ i, ∑ j,
          (|m i| ^ 2 * |m j| ^ 2 / (|m i| + |m j|)) * Complex.normSq (D i j) :=
  spectral_cubic_bound_of_euclidean_bound m hsorted D hD _ (norm_nonneg _)
    (ContinuousLinearMap.le_opNorm _)

end SharedTraceCubic

#check SharedTraceCubic.spectral_cubic_bound
#print axioms SharedTraceCubic.spectral_cubic_bound
