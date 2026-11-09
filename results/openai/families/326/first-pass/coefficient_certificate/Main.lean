import Mathlib

open scoped BigOperators

namespace CoefficientCertificate

abbrev BinaryMatrix (m n : ℕ) := Matrix (Fin m) (Fin n) (ZMod 2)

def rowParity {m n : ℕ} (P : BinaryMatrix m n) (i : Fin m) : ZMod 2 :=
  ∑ j, P i j

def colParity {m n : ℕ} (P : BinaryMatrix m n) (j : Fin n) : ZMod 2 :=
  ∑ i, P i j

def totalParity {m n : ℕ} (P : BinaryMatrix m n) : ZMod 2 :=
  ∑ i, ∑ j, P i j

lemma binary_ne_zero_eq_one (x : ZMod 2) (h : x ≠ 0) : x = 1 := by
  fin_cases x
  · exact (h rfl).elim
  · rfl

lemma binary_mul_eq_one (x y : ZMod 2) (h : x * y = 1) :
    x = 1 ∧ y = 1 := by
  have hx : x ≠ 0 := by
    intro hx
    rw [hx, zero_mul] at h
    exact zero_ne_one h
  have hy : y ≠ 0 := by
    intro hy
    rw [hy, mul_zero] at h
    exact zero_ne_one h
  exact ⟨binary_ne_zero_eq_one x hx, binary_ne_zero_eq_one y hy⟩

lemma exists_one {n : ℕ} (p : Fin n → ZMod 2) (hp : p ≠ 0) :
    ∃ i, p i = 1 := by
  classical
  by_contra h
  apply hp
  funext i
  by_contra hi
  exact h ⟨i, binary_ne_zero_eq_one (p i) hi⟩

theorem rectangle_row_parity {m n : ℕ}
    (p : Fin m → ZMod 2) (h : Fin n → ZMod 2) :
    rowParity (Matrix.vecMulVec p h) = fun i => p i * ∑ j, h j := by
  funext i
  simp [rowParity, Matrix.vecMulVec, Finset.mul_sum]

theorem rectangle_col_parity {m n : ℕ}
    (p : Fin m → ZMod 2) (h : Fin n → ZMod 2) :
    colParity (Matrix.vecMulVec p h) = fun j => (∑ i, p i) * h j := by
  funext j
  simp [colParity, Matrix.vecMulVec, Finset.sum_mul]

theorem rectangle_total_parity {m n : ℕ}
    (p : Fin m → ZMod 2) (h : Fin n → ZMod 2) :
    totalParity (Matrix.vecMulVec p h) = (∑ i, p i) * ∑ j, h j := by
  change (∑ i, ∑ j, p i * h j) = (∑ i, p i) * ∑ j, h j
  rw [Finset.sum_mul]
  simp only [Finset.mul_sum]

theorem odd_rectangle_parities {m n : ℕ}
    (p : Fin m → ZMod 2) (h : Fin n → ZMod 2)
    (hodd : totalParity (Matrix.vecMulVec p h) = 1) :
    (∑ i, p i) = 1 ∧ (∑ j, h j) = 1 ∧
      rowParity (Matrix.vecMulVec p h) = p ∧
      colParity (Matrix.vecMulVec p h) = h := by
  rw [rectangle_total_parity] at hodd
  obtain ⟨hp, hh⟩ := binary_mul_eq_one _ _ hodd
  refine ⟨hp, hh, ?_, ?_⟩
  · rw [rectangle_row_parity, hh]
    simp
  · rw [rectangle_col_parity, hp]
    simp

theorem rectangle_unique {m n : ℕ}
    (p q : Fin m → ZMod 2) (h k : Fin n → ZMod 2)
    (hp : p ≠ 0) (hh : h ≠ 0)
    (heq : Matrix.vecMulVec p h = Matrix.vecMulVec q k) :
    p = q ∧ h = k := by
  obtain ⟨i, hi⟩ := exists_one p hp
  obtain ⟨j, hj⟩ := exists_one h hh
  have hpivot : q i * k j = 1 := by
    have ht := congrFun (congrFun heq i) j
    simpa [Matrix.vecMulVec, hi, hj] using ht.symm
  obtain ⟨hqi, hkj⟩ := binary_mul_eq_one _ _ hpivot
  constructor
  · funext r
    have ht := congrFun (congrFun heq r) j
    simpa [Matrix.vecMulVec, hj, hkj] using ht
  · funext c
    have ht := congrFun (congrFun heq i) c
    simpa [Matrix.vecMulVec, hi, hqi] using ht

def rowSupported {m n : ℕ} (P : BinaryMatrix m n) (i : Fin m) : Prop :=
  ∀ r, r ≠ i → ∀ j, P r j = 0

def colSupported {m n : ℕ} (P : BinaryMatrix m n) (j : Fin n) : Prop :=
  ∀ c, c ≠ j → ∀ i, P i c = 0

instance {m n : ℕ} (P : BinaryMatrix m n) (i : Fin m) :
    Decidable (rowSupported P i) := by
  unfold rowSupported
  infer_instance

instance {m n : ℕ} (P : BinaryMatrix m n) (j : Fin n) :
    Decidable (colSupported P j) := by
  unfold colSupported
  infer_instance

theorem row_supported_rank_le_one {m n : ℕ}
    (P : BinaryMatrix m n) (i : Fin m) (hs : rowSupported P i) :
    P.rank ≤ 1 := by
  classical
  have heq : P = Matrix.vecMulVec (Pi.single i (1 : ZMod 2)) (P i) := by
    ext r j
    by_cases hr : r = i
    · subst r
      simp [Matrix.vecMulVec]
    · simp [Matrix.vecMulVec, Pi.single_apply, hr, hs r hr j]
  rw [heq]
  exact Matrix.rank_vecMulVec_le _ _

theorem col_supported_rank_le_one {m n : ℕ}
    (P : BinaryMatrix m n) (j : Fin n) (hs : colSupported P j) :
    P.rank ≤ 1 := by
  have ht : rowSupported P.transpose j := hs
  simpa only [Matrix.rank_transpose] using row_supported_rank_le_one P.transpose j ht

noncomputable def lowRankPart {m n : ℕ}
    (c : BinaryMatrix m n → ℝ) (P : BinaryMatrix m n) : ℝ :=
  if P.rank ≤ 1 then c P else 0

theorem high_rank_row_coefficient_zero {m n : ℕ}
    (c : BinaryMatrix m n → ℝ) (a : ℝ) (g : (Fin n → ZMod 2) → ℝ)
    (i : Fin m)
    (hproj : ∀ P, (if rowParity P = Pi.single i 1 then c P else 0) =
      if rowSupported P i then a * g (P i) else 0)
    (P : BinaryMatrix m n) (hrank : 1 < P.rank)
    (hpar : rowParity P = Pi.single i 1) :
    c P = 0 := by
  classical
  have hs : ¬rowSupported P i := by
    intro hs
    exact (not_le_of_gt hrank) (row_supported_rank_le_one P i hs)
  simpa [hpar, hs] using hproj P

theorem row_projection_survives {m n : ℕ}
    (c : BinaryMatrix m n → ℝ) (a : ℝ) (g : (Fin n → ZMod 2) → ℝ)
    (i : Fin m)
    (hproj : ∀ P, (if rowParity P = Pi.single i 1 then c P else 0) =
      if rowSupported P i then a * g (P i) else 0) :
    ∀ P, (if rowParity P = Pi.single i 1 then lowRankPart c P else 0) =
      if rowSupported P i then a * g (P i) else 0 := by
  classical
  intro P
  by_cases hrank : P.rank ≤ 1
  · simpa [lowRankPart, hrank] using hproj P
  · have hs : ¬rowSupported P i := fun hs =>
      hrank (row_supported_rank_le_one P i hs)
    simp [lowRankPart, hrank, hs]

theorem col_projection_survives {m n : ℕ}
    (c : BinaryMatrix m n → ℝ) (b : ℝ) (f : (Fin m → ZMod 2) → ℝ)
    (j : Fin n)
    (hproj : ∀ P, (if colParity P = Pi.single j 1 then c P else 0) =
      if colSupported P j then b * f (fun i => P i j) else 0) :
    ∀ P, (if colParity P = Pi.single j 1 then lowRankPart c P else 0) =
      if colSupported P j then b * f (fun i => P i j) else 0 := by
  classical
  intro P
  by_cases hrank : P.rank ≤ 1
  · simpa [lowRankPart, hrank] using hproj P
  · have hs : ¬colSupported P j := fun hs =>
      hrank (col_supported_rank_le_one P j hs)
    simp [lowRankPart, hrank, hs]

def parityMass (r : ℚ) : ℕ → ℚ × ℚ
  | 0 => (1, 0)
  | n + 1 =>
      let p := parityMass r n
      (p.1 + r * p.2, p.2 + r * p.1)

theorem parity_mass_sum (r : ℚ) (n : ℕ) :
    (parityMass r n).1 + (parityMass r n).2 = (1 + r) ^ n := by
  induction n with
  | zero => simp [parityMass]
  | succ n ih =>
      simp only [parityMass, pow_succ]
      calc
        _ = ((parityMass r n).1 + (parityMass r n).2) * (1 + r) := by ring
        _ = _ := by rw [ih]

theorem parity_mass_sub (r : ℚ) (n : ℕ) :
    (parityMass r n).1 - (parityMass r n).2 = (1 - r) ^ n := by
  induction n with
  | zero => simp [parityMass]
  | succ n ih =>
      simp only [parityMass, pow_succ]
      calc
        _ = ((parityMass r n).1 - (parityMass r n).2) * (1 - r) := by ring
        _ = _ := by rw [ih]

theorem odd_mass_closed (r : ℚ) (n : ℕ) :
    (parityMass r n).2 = ((1 + r) ^ n - (1 - r) ^ n) / 2 := by
  linarith [parity_mass_sum r n, parity_mass_sub r n]

theorem tail_log_exponent (k l t : ℝ) (ht : 0 ≤ t)
    (hk : 2 * t ≤ k) (hl : 2 * t ≤ l) :
    (k + l) * t ≤ k * l := by
  have hk0 : 0 ≤ k := by linarith
  have hl0 : 0 ≤ l := by linarith
  nlinarith [mul_nonneg hk0 (sub_nonneg.mpr hl),
    mul_nonneg hl0 (sub_nonneg.mpr hk)]

theorem tail_geometric_exponent (k l : ℝ) (hk : 4 ≤ k) (hl : 4 ≤ l) :
    k + l ≤ k * l / 2 := by
  nlinarith [mul_nonneg (sub_nonneg.mpr hk) (sub_nonneg.mpr hl)]

theorem quantitative_margin (d A B K epsilon W : ℝ)
    (hd : 4 ≤ d)
    (hA : 80 * (d * (d + 1) ^ 2) ≤ A)
    (hB : 80 * (d * (d + 1) ^ 2) ≤ B)
    (hmixed : A * B / 2 ≤ 4 * (d * (d + 1)) * (A + B) +
      5 * K * (d * (d + 1)) * (d * (d + 1) ^ 2))
    (hK : K ≤ 8 + epsilon * W) :
    640 * d + 504 ≤ epsilon * W := by
  let D := d * (d + 1)
  let L := d * (d + 1) ^ 2
  have hD : 0 < D := by dsimp [D]; positivity
  have hL : 0 < L := by dsimp [L]; positivity
  have hc : 0 ≤ 40 * L - 4 * D := by
    dsimp [L, D]
    have hd0 : 0 ≤ d := by linarith
    nlinarith [sq_nonneg d]
  have hres : 0 ≤ (40 * L - 4 * D) * ((A - 80 * L) + (B - 80 * L)) +
      (A - 80 * L) * (B - 80 * L) / 2 := by
    have hAa : 0 ≤ A - 80 * L := sub_nonneg.mpr hA
    have hBb : 0 ≤ B - 80 * L := sub_nonneg.mpr hB
    positivity
  have hid : A * B / 2 - 4 * D * (A + B) -
      (640 * d + 512) * (5 * D * L) =
      (40 * L - 4 * D) * ((A - 80 * L) + (B - 80 * L)) +
        (A - 80 * L) * (B - 80 * L) / 2 := by
    dsimp [D, L]
    ring
  have hmult : (640 * d + 512) * (5 * D * L) ≤ K * (5 * D * L) := by
    change A * B / 2 ≤ 4 * D * (A + B) + 5 * K * D * L at hmixed
    nlinarith [hid, hres]
  have hfactor : 0 < 5 * D * L := by positivity
  have hbound : 640 * d + 512 ≤ K := le_of_mul_le_mul_right hmult hfactor
  linarith

theorem coefficient_from_mass (N : ℕ) (epsilon W : ℝ)
    (he : 0 ≤ epsilon) (hW : W ≤ (3 / 2 : ℝ) ^ N)
    (hm : 1 ≤ epsilon * W) :
    (2 / 3 : ℝ) ^ N ≤ epsilon := by
  have hp : 0 < (3 / 2 : ℝ) ^ N := by positivity
  have hprod : 1 ≤ epsilon * (3 / 2 : ℝ) ^ N :=
    hm.trans (mul_le_mul_of_nonneg_left hW he)
  have hinv : (2 / 3 : ℝ) ^ N * (3 / 2 : ℝ) ^ N = 1 := by
    rw [← mul_pow]
    norm_num
  have hcompare : (2 / 3 : ℝ) ^ N * (3 / 2 : ℝ) ^ N ≤
      epsilon * (3 / 2 : ℝ) ^ N := by
    simpa [hinv] using hprod
  exact le_of_mul_le_mul_right hcompare hp

end CoefficientCertificate
