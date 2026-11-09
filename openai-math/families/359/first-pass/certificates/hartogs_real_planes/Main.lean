import Mathlib

namespace Hartogs

def mixedP (d b1 b2 r c1 c2 e1 e2 : Real) : Real :=
  d + 4 * (b1 + b2)^2 + 4 * r^2 +
    e1 * (c1 + 4 * b1 * r) + e2 * (c2 + 4 * b2 * r)

theorem corner11 (d b1 b2 r c1 c2 : Real) :
    mixedP d b1 b2 r c1 c2 1 1 =
      (d + 4 * b1 * b2) + c1 + c2 +
        2 * (b1 + b2 + r)^2 + 2 * (b1^2 + b2^2 + r^2) := by
  unfold mixedP
  ring

theorem corner12 (d b1 b2 r c1 c2 : Real) :
    mixedP d b1 b2 r c1 c2 1 2 =
      (d + 4 * b1 * b2) + c1 + 2 * c2 +
        (2 * b1 + b2 + r)^2 + 3 * (b2 + r)^2 := by
  unfold mixedP
  ring

theorem corner21 (d b1 b2 r c1 c2 : Real) :
    mixedP d b1 b2 r c1 c2 2 1 =
      (d + 4 * b1 * b2) + 2 * c1 + c2 +
        (b1 + 2 * b2 + r)^2 + 3 * (b1 + r)^2 := by
  unfold mixedP
  ring

theorem corner22 (d b1 b2 r c1 c2 : Real) :
    mixedP d b1 b2 r c1 c2 2 2 =
      d + 2 * (c1 + c2) + 4 * (b1 + b2 + r)^2 := by
  unfold mixedP
  ring

theorem four_corner_interpolation (d b1 b2 r c1 c2 e1 e2 : Real) :
    mixedP d b1 b2 r c1 c2 e1 e2 =
      (2 - e1) * (2 - e2) * mixedP d b1 b2 r c1 c2 1 1 +
      (2 - e1) * (e2 - 1) * mixedP d b1 b2 r c1 c2 1 2 +
      (e1 - 1) * (2 - e2) * mixedP d b1 b2 r c1 c2 2 1 +
      (e1 - 1) * (e2 - 1) * mixedP d b1 b2 r c1 c2 2 2 := by
  unfold mixedP
  ring

theorem mixed_coercivity (d b1 b2 r c1 c2 e1 e2 : Real)
    (hd : 0 <= d) (hc1 : 0 <= c1) (hc2 : 0 <= c2)
    (hc12 : 0 <= d + 4 * b1 * b2)
    (he1lo : 1 <= e1) (he1hi : e1 <= 2)
    (he2lo : 1 <= e2) (he2hi : e2 <= 2) :
    c1 + c2 <= mixedP d b1 b2 r c1 c2 e1 e2 := by
  have h11 : c1 + c2 <= mixedP d b1 b2 r c1 c2 1 1 := by
    rw [corner11]
    nlinarith [sq_nonneg (b1 + b2 + r), sq_nonneg b1, sq_nonneg b2, sq_nonneg r]
  have h12 : c1 + c2 <= mixedP d b1 b2 r c1 c2 1 2 := by
    rw [corner12]
    nlinarith [sq_nonneg (2 * b1 + b2 + r), sq_nonneg (b2 + r)]
  have h21 : c1 + c2 <= mixedP d b1 b2 r c1 c2 2 1 := by
    rw [corner21]
    nlinarith [sq_nonneg (b1 + 2 * b2 + r), sq_nonneg (b1 + r)]
  have h22 : c1 + c2 <= mixedP d b1 b2 r c1 c2 2 2 := by
    rw [corner22]
    nlinarith [sq_nonneg (b1 + b2 + r)]
  let w11 := (2 - e1) * (2 - e2)
  let w12 := (2 - e1) * (e2 - 1)
  let w21 := (e1 - 1) * (2 - e2)
  let w22 := (e1 - 1) * (e2 - 1)
  have hw11 : 0 <= w11 := mul_nonneg (sub_nonneg.mpr he1hi) (sub_nonneg.mpr he2hi)
  have hw12 : 0 <= w12 := mul_nonneg (sub_nonneg.mpr he1hi) (sub_nonneg.mpr he2lo)
  have hw21 : 0 <= w21 := mul_nonneg (sub_nonneg.mpr he1lo) (sub_nonneg.mpr he2hi)
  have hw22 : 0 <= w22 := mul_nonneg (sub_nonneg.mpr he1lo) (sub_nonneg.mpr he2lo)
  calc
    c1 + c2 = w11 * (c1 + c2) + w12 * (c1 + c2) +
        w21 * (c1 + c2) + w22 * (c1 + c2) := by
      dsimp [w11, w12, w21, w22]
      ring
    _ <= w11 * mixedP d b1 b2 r c1 c2 1 1 +
        w12 * mixedP d b1 b2 r c1 c2 1 2 +
        w21 * mixedP d b1 b2 r c1 c2 2 1 +
        w22 * mixedP d b1 b2 r c1 c2 2 2 :=
      add_le_add
        (add_le_add
          (add_le_add (mul_le_mul_of_nonneg_left h11 hw11)
            (mul_le_mul_of_nonneg_left h12 hw12))
          (mul_le_mul_of_nonneg_left h21 hw21))
        (mul_le_mul_of_nonneg_left h22 hw22)
    _ = mixedP d b1 b2 r c1 c2 e1 e2 := by
      dsimp [w11, w12, w21, w22]
      exact (four_corner_interpolation d b1 b2 r c1 c2 e1 e2).symm

theorem young_absorption (k a m : Real) :
    k * a * m <= m^2 / 4 + (k * a)^2 := by
  nlinarith [sq_nonneg (m / 2 - k * a)]

theorem gap_absorption (a s t delta : Real)
    (ha : 0 <= a) (has : a <= s)
    (hdlo : 0 <= delta) (hdhi : delta <= 1) :
    delta * a^2 / 4 <= (s - 2 * t)^2 / 4 + delta * a * t := by
  have h1 : 0 <= delta * a * (s - a) / 2 :=
    div_nonneg
      (mul_nonneg (mul_nonneg hdlo ha) (sub_nonneg.mpr has)) (by norm_num)
  have h2 : 0 <= delta * (1 - delta) * a^2 / 4 :=
    div_nonneg
      (mul_nonneg (mul_nonneg hdlo (sub_nonneg.mpr hdhi)) (sq_nonneg a))
      (by norm_num)
  have identity :
      (s - 2 * t)^2 / 4 + delta * a * t - delta * a^2 / 4 =
        (t - (s - delta * a) / 2)^2 +
        delta * a * (s - a) / 2 + delta * (1 - delta) * a^2 / 4 := by ring
  nlinarith [sq_nonneg (t - (s - delta * a) / 2)]

theorem area_control (a s t : Real) (hs : s^2 <= 4 * a^2) :
    t^2 <= 2 * a^2 + (s - 2 * t)^2 / 2 ∧
      a * t <= 2 * a^2 + (s - 2 * t)^2 / 4 := by
  have hu : t^2 <= 2 * a^2 + (s - 2 * t)^2 / 2 := by
    nlinarith [sq_nonneg (s - t)]
  constructor
  · exact hu
  · nlinarith [sq_nonneg (a - t), sq_nonneg a]

theorem imaginary_pairing_bound (a b s : Real)
    (_ha : 0 <= a) (_hb : 0 <= b) (hs : 0 <= s)
    (heq : s^2 = a^2 + 3 * b^2) :
    (a + 3 * b) / 2 <= s := by
  by_contra hn
  have h1 : 0 < a + 3 * b - 2 * s := by linarith
  have h2 : 0 < a + 3 * b + 2 * s := by linarith
  have hp := mul_pos h1 h2
  nlinarith [sq_nonneg (a - b)]

theorem threshold (alpha B C lam x : Real)
    (ha : 0 < alpha) (hB : 1 <= B) (hC : 0 <= C) (hx : 1 <= x)
    (hlam : B^2 * (B + C) / alpha <= lam) :
    B * x <= lam + alpha * x^3 / (lam + C * x) := by
  have hBp : 0 < B := by linarith
  have hxp : 0 < x := by linarith
  have hbase : 0 < B^2 * (B + C) :=
    mul_pos (sq_pos_of_pos hBp) (by linarith)
  have hscaled : B^2 * (B + C) <= alpha * lam := by
    have h := (div_le_iff₀ ha).mp hlam
    nlinarith
  have hlamp : 0 < lam := by nlinarith
  have hden : 0 < lam + C * x := by
    nlinarith [mul_nonneg hC (le_of_lt hxp)]
  by_cases hlarge : B * x <= lam
  · have hfrac : 0 <= alpha * x^3 / (lam + C * x) :=
      div_nonneg (mul_nonneg (le_of_lt ha) (pow_nonneg (le_of_lt hxp) 3))
        (le_of_lt hden)
    linarith
  · have hsmall : lam < B * x := lt_of_not_ge hlarge
    have hnorm : B * (B * (B + C)) < B * (alpha * x) := by
      calc
        B * (B * (B + C)) = B^2 * (B + C) := by ring
        _ <= alpha * lam := hscaled
        _ < alpha * (B * x) := mul_lt_mul_of_pos_left hsmall ha
        _ = B * (alpha * x) := by ring
    have hax : B * (B + C) < alpha * x := by
      by_contra hn
      have hnot : alpha * x <= B * (B + C) := le_of_not_gt hn
      have hp := mul_nonneg (le_of_lt hBp) (sub_nonneg.mpr hnot)
      nlinarith
    have hden_upper : lam + C * x <= (B + C) * x := by nlinarith
    have hprod : B * x * (lam + C * x) <= alpha * x^3 := by
      calc
        B * x * (lam + C * x) <= B * x * ((B + C) * x) :=
          mul_le_mul_of_nonneg_left hden_upper
            (mul_nonneg (le_of_lt hBp) (le_of_lt hxp))
        _ = (B * (B + C)) * x^2 := by ring
        _ <= (alpha * x) * x^2 :=
          mul_le_mul_of_nonneg_right (le_of_lt hax) (sq_nonneg x)
        _ = alpha * x^3 := by ring
    have hfrac : B * x <= alpha * x^3 / (lam + C * x) :=
      (le_div_iff₀ hden).mpr hprod
    linarith

end Hartogs
