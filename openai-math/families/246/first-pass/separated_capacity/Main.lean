import Mathlib

open scoped BigOperators

namespace SeparatedCapacity

theorem weightedCover
    {A B Y : Type*} [Fintype A] [Fintype B] [Fintype Y]
    (ell : A → ℝ) (bin : B → Y → ℝ) (active : A → Y → ℝ)
    (coeff : Y → ℝ) (m : ℝ)
    (hell : ∀ a, 0 ≤ ell a) (hellsum : ∑ a, ell a = 1)
    (hactive : ∀ a y, 0 ≤ active a y)
    (hcoeff : ∀ y, 0 ≤ coeff y)
    (hcolumns : ∀ y, ∑ b, bin b y ≤ m)
    (hcover : ∀ b a, 1 ≤ ∑ y, bin b y * active a y * coeff y) :
    (Fintype.card B : ℝ) ≤
      m * ∑ y, (∑ a, ell a * active a y) * coeff y := by
  classical
  calc
    (Fintype.card B : ℝ) = ∑ _b : B, ∑ a, ell a := by simp [hellsum]
    _ ≤ ∑ b : B, ∑ a : A, ell a * ∑ y, bin b y * active a y * coeff y := by
      apply Finset.sum_le_sum
      intro b _
      apply Finset.sum_le_sum
      intro a _
      simpa using mul_le_mul_of_nonneg_left (hcover b a) (hell a)
    _ = ∑ b : B, ∑ a : A, ∑ y : Y,
        bin b y * (ell a * active a y) * coeff y := by
      apply Finset.sum_congr rfl
      intro b _
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro y _
      ring
    _ = ∑ b : B, ∑ y : Y, ∑ a : A,
        bin b y * (ell a * active a y) * coeff y := by
      apply Finset.sum_congr rfl
      intro b _
      rw [Finset.sum_comm]
    _ = ∑ y : Y, ∑ b : B, ∑ a : A,
        bin b y * (ell a * active a y) * coeff y := Finset.sum_comm
    _ = ∑ y : Y, (∑ b : B, bin b y) *
        (∑ a : A, ell a * active a y) * coeff y := by
      simp only [Finset.mul_sum, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro y _
      rw [Finset.sum_comm]
    _ ≤ ∑ y : Y, m * (∑ a : A, ell a * active a y) * coeff y := by
      apply Finset.sum_le_sum
      intro y _
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_right (hcolumns y)
          (Finset.sum_nonneg fun a _ => mul_nonneg (hell a) (hactive a y)))
        (hcoeff y)
    _ = m * ∑ y : Y, (∑ a : A, ell a * active a y) * coeff y := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro y _
      ring

theorem hybridBound
    {Y : Type*} [Fintype Y]
    (u v sigma c : Y → ℝ) (N m E lam Lam : ℝ)
    (hN : 0 ≤ N) (hm : 0 < m) (hE : 0 < E)
    (hlam : 0 < lam) (hLam : 0 < Lam)
    (hv : ∀ y, 0 ≤ v y) (hsigma : ∀ y, 0 ≤ sigma y)
    (hcover : N ≤ m * ((∑ y, u y) + ∑ y, sigma y * v y))
    (henergy : ∑ y, sigma y ^ 2 ≤ E)
    (hlinear : ∀ y, lam * u y ≤ c y)
    (hquadratic : ∀ y, Lam * v y ^ 2 ≤ c y) :
    min (lam * N / (2 * m)) (Lam * N ^ 2 / (4 * m ^ 2 * E)) ≤ ∑ y, c y := by
  classical
  let U := ∑ y, u y
  let V := ∑ y, v y ^ 2
  let T := ∑ y, sigma y * v y
  let S := ∑ y, c y
  have hV : 0 ≤ V := Finset.sum_nonneg fun y _ => sq_nonneg (v y)
  have hT : 0 ≤ T :=
    Finset.sum_nonneg fun y _ => mul_nonneg (hsigma y) (hv y)
  have hlin : lam * U ≤ S := by
    dsimp [U, S]
    rw [Finset.mul_sum]
    exact Finset.sum_le_sum fun y _ => hlinear y
  have hquad : Lam * V ≤ S := by
    dsimp [V, S]
    rw [Finset.mul_sum]
    exact Finset.sum_le_sum fun y _ => hquadratic y
  have hcs : T ^ 2 ≤ E * V := by
    calc
      T ^ 2 ≤ (∑ y, sigma y ^ 2) * V :=
        Finset.sum_mul_sq_le_sq_mul_sq Finset.univ sigma v
      _ ≤ E * V := mul_le_mul_of_nonneg_right henergy hV
  by_contra h
  have hlt : S < min (lam * N / (2 * m))
      (Lam * N ^ 2 / (4 * m ^ 2 * E)) := lt_of_not_ge h
  have hfirst := (lt_min_iff.mp hlt).1
  have hsecond := (lt_min_iff.mp hlt).2
  have hfirst' : S * (2 * m) < lam * N :=
    (lt_div_iff₀ (by positivity)).mp hfirst
  have hU : 2 * m * U < N := by
    by_contra hn
    have hnot : 0 ≤ 2 * m * U - N := by linarith
    have hpos := mul_nonneg hlam.le hnot
    have hmul := mul_le_mul_of_nonneg_left hlin (show 0 ≤ 2 * m by positivity)
    nlinarith
  have hNT : N < 2 * m * T := by
    change N ≤ m * (U + T) at hcover
    nlinarith
  have hsq : N ^ 2 < (2 * m * T) ^ 2 :=
    (sq_lt_sq₀ hN (by positivity)).2 hNT
  have hscaled : (2 * m * T) ^ 2 ≤ 4 * m ^ 2 * E * V := by
    have hmul := mul_le_mul_of_nonneg_left hcs
      (show 0 ≤ 4 * m ^ 2 by positivity)
    nlinarith
  have hstrict : N ^ 2 < 4 * m ^ 2 * E * V := hsq.trans_le hscaled
  have hlower : Lam * N ^ 2 < (4 * m ^ 2 * E) * S := by
    calc
      Lam * N ^ 2 < (4 * m ^ 2 * E) * (Lam * V) := by
        have hmul := mul_lt_mul_of_pos_left hstrict hLam
        nlinarith
      _ ≤ (4 * m ^ 2 * E) * S :=
        mul_le_mul_of_nonneg_left hquad (by positivity)
  have hupper : (4 * m ^ 2 * E) * S < Lam * N ^ 2 := by
    simpa [mul_comm] using
      (lt_div_iff₀ (show 0 < 4 * m ^ 2 * E by positivity)).mp hsecond
  exact (lt_irrefl (Lam * N ^ 2)) (hlower.trans hupper)

theorem intervalCapacity
    {A B Y : Type*} [Fintype A] [Fintype B] [Fintype Y]
    (ell : A → ℝ) (bin : B → Y → ℝ) (active : A → Y → ℝ)
    (sigma : Y → ℝ) (large : Y → Prop) [DecidablePred large]
    (m E lam Lam : ℝ)
    (hell : ∀ a, 0 ≤ ell a) (hellsum : ∑ a, ell a = 1)
    (hactive : ∀ a y, 0 ≤ active a y) (hsigma : ∀ y, 0 ≤ sigma y)
    (hm : 0 < m) (hE : 0 < E) (hlam : 0 < lam) (hLam : 0 < Lam)
    (hcolumns : ∀ y, ∑ b, bin b y ≤ m)
    (henergy : ∑ y, sigma y ^ 2 ≤ E)
    (hlarge : ∀ y, large y → lam ≤ Lam * (∑ a, ell a * active a y))
    (hsmall : ∀ y, ¬large y → Lam * (∑ a, ell a * active a y) ≤ lam)
    (hcover : ∀ b a,
      1 ≤ ∑ y, bin b y * active a y * (if large y then 1 else sigma y)) :
    min (lam * (Fintype.card B : ℝ) / (2 * m))
      (Lam * (Fintype.card B : ℝ) ^ 2 / (4 * m ^ 2 * E)) ≤
      ∑ y, min (lam * (∑ a, ell a * active a y))
        (Lam * (∑ a, ell a * active a y) ^ 2) := by
  classical
  let t := fun y => ∑ a, ell a * active a y
  let u := fun y => if large y then t y else 0
  let v := fun y => if large y then 0 else t y
  let c := fun y => min (lam * t y) (Lam * t y ^ 2)
  have ht : ∀ y, 0 ≤ t y := fun y =>
    Finset.sum_nonneg fun a _ => mul_nonneg (hell a) (hactive a y)
  have hcoeff : ∀ y, 0 ≤ (if large y then 1 else sigma y) := by
    intro y
    split_ifs
    · norm_num
    · exact hsigma y
  have hw := weightedCover ell bin active
    (fun y => if large y then 1 else sigma y) m
    hell hellsum hactive hcoeff hcolumns hcover
  have hsum : (∑ y, t y * (if large y then 1 else sigma y)) =
      (∑ y, u y) + ∑ y, sigma y * v y := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro y _
    by_cases hy : large y <;> simp [u, v, hy, mul_comm]
  have hcov : (Fintype.card B : ℝ) ≤
      m * ((∑ y, u y) + ∑ y, sigma y * v y) := by
    simpa only [← hsum] using hw
  have hv : ∀ y, 0 ≤ v y := by
    intro y
    dsimp [v]
    split_ifs
    · exact le_rfl
    · exact ht y
  have hc : ∀ y, 0 ≤ c y := fun y =>
    le_min (mul_nonneg hlam.le (ht y)) (mul_nonneg hLam.le (sq_nonneg (t y)))
  have hlin : ∀ y, lam * u y ≤ c y := by
    intro y
    by_cases hy : large y
    · have hmul := mul_le_mul_of_nonneg_right (hlarge y hy) (ht y)
      simp only [u, hy, if_true, c]
      apply le_min le_rfl
      dsimp [t] at hmul ⊢
      nlinarith
    · simpa [u, hy] using hc y
  have hquad : ∀ y, Lam * v y ^ 2 ≤ c y := by
    intro y
    by_cases hy : large y
    · simpa [v, hy] using hc y
    · have hmul := mul_le_mul_of_nonneg_right (hsmall y hy) (ht y)
      simp only [v, hy, if_false, c]
      apply le_min _ le_rfl
      dsimp [t] at hmul ⊢
      nlinarith
  exact hybridBound u v sigma c (Fintype.card B) m E lam Lam
    (Nat.cast_nonneg _) hm hE hlam hLam hv hsigma hcov henergy hlin hquad

theorem colorClass
    {Y : Type*} [Fintype Y] (chi : ℕ) (hchi : 0 < chi)
    (color : Y → Fin chi) (c : Y → ℝ) :
    ∃ k : Fin chi, (∑ y, c y) / (chi : ℝ) ≤
      ∑ y, if color y = k then c y else 0 := by
  classical
  let f := fun k : Fin chi => ∑ y, if color y = k then c y else 0
  have hchiR : (0 : ℝ) < chi := Nat.cast_pos.mpr hchi
  have hsum : ∑ k : Fin chi, f k = ∑ y, c y := by
    dsimp [f]
    rw [Finset.sum_comm]
    simp
  by_contra h
  have hall : ∀ k : Fin chi, f k < (∑ y, c y) / (chi : ℝ) := by
    intro k
    exact lt_of_not_ge fun hk => h ⟨k, hk⟩
  have hnonempty : (Finset.univ : Finset (Fin chi)).Nonempty :=
    ⟨⟨0, hchi⟩, Finset.mem_univ _⟩
  have hlt : (∑ k : Fin chi, f k) <
      ∑ _k : Fin chi, (∑ y, c y) / (chi : ℝ) :=
    Finset.sum_lt_sum_of_nonempty hnonempty fun k _ => hall k
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul] at hlt
  rw [hsum] at hlt
  have heq : (chi : ℝ) * ((∑ y, c y) / (chi : ℝ)) = ∑ y, c y := by
    field_simp
  rw [heq] at hlt
  exact (lt_irrefl _) hlt

end SeparatedCapacity
