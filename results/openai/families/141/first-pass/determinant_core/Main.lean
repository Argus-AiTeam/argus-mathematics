import Mathlib

/-!
# Universal characteristic-coefficient bridge

The determinant/adjugate argument proves Newton's recurrence over every commutative
ring. Coefficient induction then identifies the finite exponential over fields
where `1, ..., D` are nonzero. The final theorems discharge this condition in
characteristic zero and in characteristic `p > D`.
-/

noncomputable section

open Polynomial Finset Matrix

namespace CharacteristicBridge

variable {R : Type*} [CommRing R]
variable {n : Type*} [Fintype n] [DecidableEq n]

theorem derivative_det_columns (M : Matrix n n R[X]) :
    derivative M.det =
      ∑ j : n, (M.updateCol j (fun i => derivative (M i j))).det := by
  classical
  rw [Matrix.det_apply', derivative_sum]
  simp_rw [derivative_mul, derivative_intCast, zero_mul, zero_add,
    derivative_prod_finset, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro j _
  rw [Matrix.det_apply']
  apply Finset.sum_congr rfl
  intro σ _
  congr 1
  rw [Finset.prod_eq_mul_prod_sdiff_singleton_of_mem (Finset.mem_univ j)]
  simp only [Matrix.updateCol_self]
  rw [mul_comm]
  congr 1
  simp only [Finset.sdiff_singleton_eq_erase]
  apply Finset.prod_congr rfl
  intro i hi
  rw [Matrix.updateCol_ne (Finset.ne_of_mem_erase hi)]

theorem derivative_det_adjugate (M : Matrix n n R[X]) :
    derivative M.det = Matrix.trace (M.adjugate * M.map derivative) := by
  rw [derivative_det_columns]
  unfold Matrix.trace Matrix.diag
  apply Finset.sum_congr rfl
  intro j _
  rw [← Matrix.cramer_apply, Matrix.cramer_eq_adjugate_mulVec]
  rfl

def reverseMatrix (A : Matrix n n R) : Matrix n n R[X] :=
  1 - (X : R[X]) • A.map C

def adjugatePolynomial (A : Matrix n n R) : (Matrix n n R)[X] :=
  matPolyEquiv (reverseMatrix A).adjugate

omit [Fintype n] in
theorem reverseMatrix_derivative (A : Matrix n n R) :
    (reverseMatrix A).map derivative = -(A.map C) := by
  ext i j
  by_cases hij : i = j <;> simp [reverseMatrix, derivative_mul, hij]

theorem derivative_charpolyRev (A : Matrix n n R) :
    derivative A.charpolyRev =
      -Matrix.trace ((reverseMatrix A).adjugate * A.map C) := by
  rw [Matrix.charpolyRev, ← reverseMatrix, derivative_det_adjugate,
    reverseMatrix_derivative, Matrix.mul_neg, Matrix.trace_neg]

theorem coeff_trace (M : Matrix n n R[X]) (k : ℕ) :
    (Matrix.trace M).coeff k = Matrix.trace ((matPolyEquiv M).coeff k) := by
  simp [Matrix.trace, Matrix.diag, finsetSum_coeff]

theorem matPolyEquiv_reverseMatrix (A : Matrix n n R) :
    matPolyEquiv (reverseMatrix A) = 1 - X * C A := by
  simp [reverseMatrix, matPolyEquiv_map_smul]

theorem adjugatePolynomial_mul (A : Matrix n n R) :
    adjugatePolynomial A * (1 - X * C A) =
      A.charpolyRev.map (algebraMap R (Matrix n n R)) := by
  rw [← matPolyEquiv_smul_one, ← matPolyEquiv_reverseMatrix, adjugatePolynomial,
    ← map_mul, Matrix.adjugate_mul]
  rfl

theorem coeff_charpolyRev_zero (A : Matrix n n R) :
    A.charpolyRev.coeff 0 = 1 := by
  rw [coeff_zero_eq_eval_zero, Matrix.eval_charpolyRev]

theorem adjugatePolynomial_coeff_zero (A : Matrix n n R) :
    (adjugatePolynomial A).coeff 0 = 1 := by
  have h := congrArg (fun p : (Matrix n n R)[X] => p.coeff 0)
    (adjugatePolynomial_mul A)
  simpa only [mul_sub, mul_one, ← mul_assoc, coeff_sub, coeff_mul_C,
    coeff_mul_X_zero, zero_mul, sub_zero, coeff_map, coeff_charpolyRev_zero,
    map_one] using h

theorem adjugatePolynomial_coeff_succ (A : Matrix n n R) (k : ℕ) :
    (adjugatePolynomial A).coeff (k + 1) =
      (adjugatePolynomial A).coeff k * A + A.charpolyRev.coeff (k + 1) • 1 := by
  have h := congrArg (fun p : (Matrix n n R)[X] => p.coeff (k + 1))
    (adjugatePolynomial_mul A)
  simp only [mul_sub, mul_one, ← mul_assoc, coeff_sub, coeff_mul_C, coeff_mul_X,
    coeff_map, Algebra.algebraMap_eq_smul_one] at h
  exact (sub_eq_iff_eq_add.mp h).trans (add_comm _ _)

theorem adjugatePolynomial_coeff (A : Matrix n n R) (k : ℕ) :
    (adjugatePolynomial A).coeff k =
      ∑ i ∈ range (k + 1), A.charpolyRev.coeff i • A ^ (k - i) := by
  induction k with
  | zero => simp [adjugatePolynomial_coeff_zero, coeff_charpolyRev_zero]
  | succ k ih =>
    rw [adjugatePolynomial_coeff_succ, ih, Finset.sum_mul]
    conv_rhs => rw [sum_range_succ]
    congr 1
    · apply Finset.sum_congr rfl
      intro i hi
      rw [smul_mul_assoc, ← pow_succ]
      have : i ≤ k := Nat.le_of_lt_succ (mem_range.mp hi)
      rw [show k - i + 1 = k + 1 - i by omega]
    · simp

theorem charpolyRev_newton (A : Matrix n n R) (k : ℕ) :
    A.charpolyRev.coeff (k + 1) * (k + 1 : R) =
      - ∑ i ∈ range (k + 1),
          A.charpolyRev.coeff i * Matrix.trace (A ^ (k + 1 - i)) := by
  have h := congrArg (fun p : R[X] => p.coeff k) (derivative_charpolyRev A)
  rw [coeff_derivative, coeff_neg, coeff_trace, map_mul, matPolyEquiv_map_C,
    coeff_mul_C] at h
  change A.charpolyRev.coeff (k + 1) * (k + 1 : R) =
    -Matrix.trace ((adjugatePolynomial A).coeff k * A) at h
  rw [h, adjugatePolynomial_coeff, Finset.sum_mul, Matrix.trace_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  rw [smul_mul_assoc, Matrix.trace_smul, smul_eq_mul, ← pow_succ]
  have : i ≤ k := Nat.le_of_lt_succ (mem_range.mp hi)
  rw [show k - i + 1 = k + 1 - i by omega]

section Field

variable {K : Type*} [Field K]

def truncExp (D : ℕ) (L : K[X]) : K[X] :=
  ∑ j ∈ range (D + 1), C ((j.factorial : K)⁻¹) * L ^ j

def traceLog (D : ℕ) (A : Matrix n n K) : K[X] :=
  - ∑ k ∈ range D, monomial (k + 1) (Matrix.trace (A ^ (k + 1)) / (k + 1 : K))

def traceExp (D : ℕ) (A : Matrix n n K) : K[X] :=
  truncExp D (traceLog D A)

theorem coeff_pow_mul_eq_zero {L : K[X]} (hL : L.coeff 0 = 0)
    (B : K[X]) {j k : ℕ} (hjk : k < j) : (L ^ j * B).coeff k = 0 := by
  obtain ⟨G, rfl⟩ := (X_dvd_iff.mpr hL)
  rw [mul_pow, mul_assoc, coeff_X_pow_mul']
  simp [Nat.not_le.mpr hjk]

theorem derivative_truncExp (D : ℕ) (L : K[X])
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0) :
    derivative (truncExp D L) =
      (∑ j ∈ range D, C ((j.factorial : K)⁻¹) * L ^ j) * derivative L := by
  unfold truncExp
  simp_rw [derivative_sum, derivative_mul, derivative_C, zero_mul, zero_add,
    derivative_pow]
  rw [Finset.sum_range_succ']
  simp only [Nat.cast_zero, C_0, zero_mul, mul_zero, add_zero]
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro j hj
  have hjD : j + 1 ≤ D := mem_range.mp hj
  have hj0 : (j + 1 : K) ≠ 0 := by
    simpa only [Nat.cast_add_one] using hD (j + 1) (by omega) hjD
  rw [Nat.add_sub_cancel, ← mul_assoc, ← mul_assoc, ← C_mul]
  congr 2
  rw [Nat.factorial_succ, Nat.cast_mul, _root_.mul_inv_rev, mul_assoc,
    Nat.cast_add_one, inv_mul_cancel₀ hj0, mul_one]

theorem coeff_truncExp_newton (D : ℕ) {L : K[X]} (hL : L.coeff 0 = 0)
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0)
    {k : ℕ} (hk : k < D) :
    (truncExp D L).coeff (k + 1) * (k + 1 : K) =
      (truncExp D L * derivative L).coeff k := by
  rw [← coeff_derivative, derivative_truncExp D L hD]
  conv_rhs => rw [truncExp, sum_range_succ, add_mul, coeff_add, mul_assoc,
    coeff_C_mul, coeff_pow_mul_eq_zero hL (derivative L) hk, mul_zero, add_zero]

theorem coeff_truncExp_zero (D : ℕ) {L : K[X]} (hL : L.coeff 0 = 0) :
    (truncExp D L).coeff 0 = 1 := by
  rw [coeff_zero_eq_eval_zero]
  simp only [truncExp, eval_finsetSum, eval_mul, eval_C, eval_pow,
    ← coeff_zero_eq_eval_zero, hL]
  rw [Finset.sum_eq_single 0]
  · simp
  · intro j _ hj
    simp [zero_pow hj]
  · simp

theorem traceLog_coeff_zero (D : ℕ) (A : Matrix n n K) :
    (traceLog D A).coeff 0 = 0 := by
  simp [traceLog, finsetSum_coeff, coeff_monomial]

theorem traceLog_coeff_succ (D : ℕ) (A : Matrix n n K) {k : ℕ} (hk : k < D) :
    (traceLog D A).coeff (k + 1) =
      -(Matrix.trace (A ^ (k + 1)) / (k + 1 : K)) := by
  simp [traceLog, finsetSum_coeff, coeff_monomial, hk]

theorem derivative_traceLog_coeff (D : ℕ) (A : Matrix n n K)
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0)
    {k : ℕ} (hk : k < D) :
    (derivative (traceLog D A)).coeff k = -Matrix.trace (A ^ (k + 1)) := by
  have hk0 := hD (k + 1) (by omega) (by omega)
  rw [coeff_derivative, traceLog_coeff_succ D A hk]
  simpa only [Nat.cast_add_one] using neg_mul (Matrix.trace (A ^ (k + 1)) /
    (k + 1 : K)) (k + 1 : K) |>.trans
      (congrArg Neg.neg (div_mul_cancel₀ (Matrix.trace (A ^ (k + 1)))
        (by simpa only [Nat.cast_add_one] using hk0)))

theorem traceExp_newton (D : ℕ) (A : Matrix n n K)
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0)
    {k : ℕ} (hk : k < D) :
    (traceExp D A).coeff (k + 1) * (k + 1 : K) =
      - ∑ i ∈ range (k + 1),
          (traceExp D A).coeff i * Matrix.trace (A ^ (k + 1 - i)) := by
  rw [traceExp, coeff_truncExp_newton D (traceLog_coeff_zero D A) hD hk,
    coeff_mul, Nat.sum_antidiagonal_eq_sum_range_succ_mk]
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro i hi
  have hi' : i ≤ k := Nat.le_of_lt_succ (mem_range.mp hi)
  rw [derivative_traceLog_coeff D A hD (by omega), mul_neg]
  rw [show k - i + 1 = k + 1 - i by omega]

theorem traceExp_coeff_eq_charpolyRev (D : ℕ) (A : Matrix n n K)
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0)
    {m : ℕ} (hm : m ≤ D) :
    (traceExp D A).coeff m = A.charpolyRev.coeff m := by
  induction m using Nat.strong_induction_on with
  | h m ih =>
    cases m with
    | zero =>
      rw [traceExp, coeff_truncExp_zero D (traceLog_coeff_zero D A),
        coeff_charpolyRev_zero]
    | succ k =>
      have hk : k < D := by omega
      have hk0 := hD (k + 1) (by omega) (by omega)
      apply mul_right_cancel₀ (show (k + 1 : K) ≠ 0 by
        simpa only [Nat.cast_add_one] using hk0)
      rw [traceExp_newton D A hD hk, charpolyRev_newton]
      congr 1
      apply Finset.sum_congr rfl
      intro i hi
      have hi' : i < k + 1 := mem_range.mp hi
      rw [ih i (mem_range.mp hi) (by omega)]

theorem traceLog_eq (D : ℕ) (A : Matrix n n K) :
    traceLog D A =
      - ∑ k ∈ Icc 1 D, C (Matrix.trace (A ^ k) / (k : K)) * X ^ k := by
  unfold traceLog
  congr 1
  apply Finset.sum_bij (fun k _ => k + 1)
  · intro k hk
    simp only [mem_range] at hk
    simp only [mem_Icc]
    omega
  · intro a _ b _ hab
    omega
  · intro b hb
    simp only [mem_Icc] at hb
    refine ⟨b - 1, ?_, ?_⟩
    · simp only [mem_range]
      omega
    · omega
  · intro k _
    simp only [Nat.cast_add_one, C_mul_X_pow_eq_monomial]

/-- The finite exponential appearing in the characteristic-coefficient formula. -/
def characteristicExponential (D : ℕ) (A : Matrix n n K) : K[X] :=
  ∑ j ∈ range (D + 1),
    C ((j.factorial : K)⁻¹) *
      (- ∑ k ∈ Icc 1 D, C (Matrix.trace (A ^ k) / (k : K)) * X ^ k) ^ j

theorem traceExp_eq_characteristicExponential (D : ℕ) (A : Matrix n n K) :
    traceExp D A = characteristicExponential D A := by
  unfold traceExp truncExp characteristicExponential
  rw [traceLog_eq]

/-- No assumption on eigenvalues, splitting, or semisimplicity is made. The truncation
bound need not equal the matrix dimension. -/
theorem characteristic_coefficient_bridge (D : ℕ) (A : Matrix n n K)
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0)
    {m : ℕ} (hm : m ≤ D) :
    (characteristicExponential D A).coeff m =
      (Matrix.det (1 - (X : K[X]) • A.map C)).coeff m := by
  rw [← traceExp_eq_characteristicExponential]
  exact traceExp_coeff_eq_charpolyRev D A hD hm

theorem denominators_ne_zero_charZero [CharZero K] (D : ℕ) :
    ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0 := by
  intro k hk _
  exact Nat.cast_ne_zero.mpr (Nat.ne_of_gt hk)

theorem denominators_ne_zero_largeChar (D p : ℕ) [CharP K p] (hp : D < p) :
    ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0 := by
  intro k hk hkD hzero
  have hpk : p ∣ k := (CharP.cast_eq_zero_iff K p k).mp hzero
  have : p ≤ k := Nat.le_of_dvd hk hpk
  omega

theorem factorial_ne_zero_of_denominators (D : ℕ)
    (hD : ∀ k : ℕ, 0 < k → k ≤ D → (k : K) ≠ 0)
    {j : ℕ} (hj : j ≤ D) : (j.factorial : K) ≠ 0 := by
  induction j with
  | zero => simp
  | succ j ih =>
    rw [Nat.factorial_succ, Nat.cast_mul]
    exact mul_ne_zero (hD (j + 1) (by omega) hj) (ih (by omega))

theorem universal_bridge_charZero [CharZero K] (A : Matrix n n K)
    {m : ℕ} (hm : m ≤ Fintype.card n) :
    (characteristicExponential (Fintype.card n) A).coeff m =
      (Matrix.det (1 - (X : K[X]) • A.map C)).coeff m :=
  characteristic_coefficient_bridge _ A (denominators_ne_zero_charZero _) hm

theorem universal_bridge_largeChar (A : Matrix n n K) (p : ℕ) [CharP K p]
    (hp : Fintype.card n < p) {m : ℕ} (hm : m ≤ Fintype.card n) :
    (characteristicExponential (Fintype.card n) A).coeff m =
      (Matrix.det (1 - (X : K[X]) • A.map C)).coeff m :=
  characteristic_coefficient_bridge _ A (denominators_ne_zero_largeChar _ p hp) hm

theorem charpoly_coefficient_bridge (A : Matrix n n K)
    (hD : ∀ k : ℕ, 0 < k → k ≤ Fintype.card n → (k : K) ≠ 0)
    {d : ℕ} (hd : d ≤ Fintype.card n) :
    A.charpoly.coeff d =
      (characteristicExponential (Fintype.card n) A).coeff (Fintype.card n - d) := by
  rw [characteristic_coefficient_bridge _ A hD (Nat.sub_le _ _)]
  change A.charpoly.coeff d = A.charpolyRev.coeff (Fintype.card n - d)
  rw [← Matrix.reverse_charpoly, coeff_reverse, Matrix.charpoly_natDegree_eq_dim,
    revAt_le (Nat.sub_le _ _), Nat.sub_sub_self hd]

theorem universal_charpoly_bridge_charZero [CharZero K] (A : Matrix n n K)
    {d : ℕ} (hd : d ≤ Fintype.card n) :
    A.charpoly.coeff d =
      (characteristicExponential (Fintype.card n) A).coeff (Fintype.card n - d) :=
  charpoly_coefficient_bridge A (denominators_ne_zero_charZero _) hd

theorem universal_charpoly_bridge_largeChar (A : Matrix n n K)
    (p : ℕ) [CharP K p] (hp : Fintype.card n < p)
    {d : ℕ} (hd : d ≤ Fintype.card n) :
    A.charpoly.coeff d =
      (characteristicExponential (Fintype.card n) A).coeff (Fintype.card n - d) :=
  charpoly_coefficient_bridge A (denominators_ne_zero_largeChar _ p hp) hd

end Field

end CharacteristicBridge

#print axioms CharacteristicBridge.charpolyRev_newton
#print axioms CharacteristicBridge.characteristic_coefficient_bridge
#print axioms CharacteristicBridge.universal_bridge_charZero
#print axioms CharacteristicBridge.universal_bridge_largeChar
#print axioms CharacteristicBridge.universal_charpoly_bridge_charZero
#print axioms CharacteristicBridge.universal_charpoly_bridge_largeChar

namespace ResidueBridge

variable {S A ι σ : Type*} [CommRing S] [CommRing A] [Algebra S A]
variable [Fintype ι] [DecidableEq ι]

def residueOperator (b : Module.Basis ι S A) (L : A →ₗ[S] S) (w : ι → A) :
    A →ₗ[S] A where
  toFun v := ∑ i, L (w i * v) • b i
  map_add' u v := by
    simp [mul_add, map_add, add_smul, Finset.sum_add_distrib]
  map_smul' c v := by
    simp [map_smul, Finset.smul_sum, smul_smul]

theorem operator_eq_self_of_generators (T : A →ₗ[S] A) (g : σ → A)
    (hgen : Algebra.adjoin S (Set.range g) = ⊤)
    (hone : T 1 = 1)
    (hcomm : ∀ j v, T (g j * v) = g j * T v) (u : A) :
    T u = u := by
  have hu : u ∈ Algebra.adjoin S (Set.range g) := by
    rw [hgen]
    trivial
  have h : ∀ v, T (u * v) = u * T v := by
    refine Algebra.adjoin_induction ?_ ?_ ?_ ?_ hu
    · intro x hx
      obtain ⟨j, rfl⟩ := hx
      exact hcomm j
    · intro c v
      simp only [← Algebra.smul_def, map_smul]
    · intro x y _ _ hx hy v
      simp only [add_mul, map_add, hx v, hy v]
    · intro x y _ _ hx hy v
      rw [mul_assoc, hx (y * v), hy v, ← mul_assoc]
  simpa only [mul_one, hone] using h 1

omit [DecidableEq ι] in
theorem residueOperator_commutes (b : Module.Basis ι S A)
    (L : A →ₗ[S] S) (w : ι → A) (x : A)
    (hdiag : ∀ i, x * w i = ∑ j, (b.repr (x * b j)) i • w j)
    (v : A) :
    residueOperator b L w (x * v) = x * residueOperator b L w v := by
  change (∑ i, L (w i * (x * v)) • b i) =
    x * ∑ i, L (w i * v) • b i
  calc
    _ = ∑ i, L ((x * w i) * v) • b i := by
      simp only [mul_left_comm (w _) x v, mul_assoc]
    _ = ∑ i, L ((∑ j, (b.repr (x * b j)) i • w j) * v) • b i := by
      simp_rw [hdiag]
    _ = ∑ i, ∑ j, ((b.repr (x * b j)) i * L (w j * v)) • b i := by
      simp only [Finset.sum_mul, smul_mul_assoc, map_sum, map_smul,
        smul_eq_mul, Finset.sum_smul]
    _ = ∑ j, L (w j * v) • (∑ i, (b.repr (x * b j)) i • b i) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro j _
      simp only [Finset.smul_sum, smul_smul, mul_comm]
    _ = x * ∑ j, L (w j * v) • b j := by
      simp only [b.sum_repr, Finset.mul_sum, mul_smul_comm]

omit [DecidableEq ι] in
theorem residueOperator_eq_self (b : Module.Basis ι S A)
    (L : A →ₗ[S] S) (w : ι → A) (g : σ → A)
    (hgen : Algebra.adjoin S (Set.range g) = ⊤)
    (hnorm : ∑ i, L (w i) • b i = 1)
    (hdiag : ∀ j i, g j * w i = ∑ k, (b.repr (g j * b k)) i • w k)
    (v : A) :
    residueOperator b L w v = v := by
  apply operator_eq_self_of_generators (residueOperator b L w) g hgen
  · simpa only [residueOperator, LinearMap.coe_mk, AddHom.coe_mk, mul_one] using hnorm
  · intro j u
    exact residueOperator_commutes b L w (g j) (hdiag j) u

theorem residue_coordinates (b : Module.Basis ι S A)
    (L : A →ₗ[S] S) (w : ι → A) (g : σ → A)
    (hgen : Algebra.adjoin S (Set.range g) = ⊤)
    (hnorm : ∑ i, L (w i) • b i = 1)
    (hdiag : ∀ j i, g j * w i = ∑ k, (b.repr (g j * b k)) i • w k)
    (v : A) (i : ι) :
    (b.repr v) i = L (w i * v) := by
  have h := congrArg (fun u : A => (b.repr u) i)
    (residueOperator_eq_self b L w g hgen hnorm hdiag v)
  simpa [residueOperator, map_sum, b.repr_self, Finsupp.single_apply] using h.symm

def diagonalElement (b : Module.Basis ι S A) (w : ι → A) : A :=
  ∑ i, b i * w i

theorem residue_trace (b : Module.Basis ι S A)
    (L : A →ₗ[S] S) (w : ι → A) (g : σ → A)
    (hgen : Algebra.adjoin S (Set.range g) = ⊤)
    (hnorm : ∑ i, L (w i) • b i = 1)
    (hdiag : ∀ j i, g j * w i = ∑ k, (b.repr (g j * b k)) i • w k)
    (v : A) :
    Matrix.trace (Algebra.leftMulMatrix b v) =
      L (v * diagonalElement b w) := by
  rw [Algebra.leftMulMatrix_apply]
  simp only [Matrix.trace, Matrix.diag, LinearMap.toMatrix_apply]
  change (∑ i, (b.repr (v * b i)) i) = _
  simp_rw [residue_coordinates b L w g hgen hnorm hdiag]
  simp [diagonalElement, Finset.mul_sum, map_sum, mul_comm, mul_left_comm]

theorem residue_power_trace (b : Module.Basis ι S A)
    (L : A →ₗ[S] S) (w : ι → A) (g : σ → A)
    (hgen : Algebra.adjoin S (Set.range g) = ⊤)
    (hnorm : ∑ i, L (w i) • b i = 1)
    (hdiag : ∀ j i, g j * w i = ∑ k, (b.repr (g j * b k)) i • w k)
    (v : A) (k : ℕ) :
    Matrix.trace ((Algebra.leftMulMatrix b v) ^ k) =
      L (v ^ k * diagonalElement b w) := by
  rw [← map_pow]
  exact residue_trace b L w g hgen hnorm hdiag (v ^ k)

end ResidueBridge

namespace DeterminantCore

variable {K A ι σ : Type*} [Field K] [CommRing A] [Algebra K A]
variable [Fintype ι] [DecidableEq ι]

def residueExponential (b : Module.Basis ι K A) (L : A →ₗ[K] K)
    (w : ι → A) (v : A) : K[X] :=
  ∑ j ∈ range (Fintype.card ι + 1),
    C ((j.factorial : K)⁻¹) *
      (- ∑ k ∈ Icc 1 (Fintype.card ι),
        C (L (v ^ k * ResidueBridge.diagonalElement b w) / (k : K)) * X ^ k) ^ j

theorem residue_characteristic_coefficient (b : Module.Basis ι K A)
    (L : A →ₗ[K] K) (w : ι → A) (g : σ → A)
    (hgen : Algebra.adjoin K (Set.range g) = ⊤)
    (hnorm : ∑ i, L (w i) • b i = 1)
    (hdiag : ∀ j i, g j * w i = ∑ k, (b.repr (g j * b k)) i • w k)
    (hD : ∀ k : ℕ, 0 < k → k ≤ Fintype.card ι → (k : K) ≠ 0)
    (v : A) {d : ℕ} (hd : d ≤ Fintype.card ι) :
    (Algebra.leftMulMatrix b v).charpoly.coeff d =
      (residueExponential b L w v).coeff (Fintype.card ι - d) := by
  rw [CharacteristicBridge.charpoly_coefficient_bridge _ hD hd]
  congr 1
  unfold CharacteristicBridge.characteristicExponential residueExponential
  simp_rw [ResidueBridge.residue_power_trace b L w g hgen hnorm hdiag v]

theorem residue_characteristic_largeChar (b : Module.Basis ι K A)
    (L : A →ₗ[K] K) (w : ι → A) (g : σ → A)
    (hgen : Algebra.adjoin K (Set.range g) = ⊤)
    (hnorm : ∑ i, L (w i) • b i = 1)
    (hdiag : ∀ j i, g j * w i = ∑ k, (b.repr (g j * b k)) i • w k)
    (v : A) (p : ℕ) [CharP K p] (hp : Fintype.card ι < p)
    {d : ℕ} (hd : d ≤ Fintype.card ι) :
    (Algebra.leftMulMatrix b v).charpoly.coeff d =
      (residueExponential b L w v).coeff (Fintype.card ι - d) :=
  residue_characteristic_coefficient b L w g hgen hnorm hdiag
    (CharacteristicBridge.denominators_ne_zero_largeChar _ p hp) v hd

theorem stated_prime_exceeds_dimension (n ell Omega p : ℕ)
    (hp : n * (ell - 1) + ell * (ell ^ n * Omega + n * (ell - 1)) +
      (ell ^ n) ^ 2 + 10 < p) :
    ell ^ n < p := by
  have hsq : ell ^ n ≤ (ell ^ n) ^ 2 := by
    by_cases hz : ell ^ n = 0
    · simp [hz]
    · have hpos : 1 ≤ ell ^ n := by omega
      nlinarith
  omega

theorem flattened_level (a : ℕ) :
    max (a + 1) 4 + 1 = max (a + 2) 5 := by omega

end DeterminantCore

#print axioms ResidueBridge.residue_trace
#print axioms ResidueBridge.residue_power_trace
#print axioms DeterminantCore.residue_characteristic_coefficient
#print axioms DeterminantCore.residue_characteristic_largeChar
#print axioms DeterminantCore.stated_prime_exceeds_dimension
