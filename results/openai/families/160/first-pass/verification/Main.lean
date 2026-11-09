import Mathlib

set_option maxHeartbeats 600000

namespace ReturnPatternCore

theorem anchor_range
    (left width radius a b c shift : Real)
    (ha0 : left <= a) (ha1 : a <= left + width)
    (hb : |b| <= radius) (hc : |c| <= 1) :
    left + shift - radius <= a + shift + c * b /\
      a + shift + c * b <= left + shift + width + radius := by
  have hcb : |c * b| <= radius := by
    rw [abs_mul]
    calc
      |c| * |b| <= 1 * radius :=
        mul_le_mul hc hb (abs_nonneg b) (by norm_num)
      _ = radius := one_mul radius
  have hbounds := abs_le.mp hcb
  constructor <;> linarith [hbounds.1, hbounds.2]

theorem integer_zero_of_abs_lt_one
    (z : Int) (hz : |(z : Real)| < 1) : z = 0 := by
  have hb := abs_lt.mp hz
  have hlo : (-1 : Int) < z := by exact_mod_cast hb.1
  have hhi : z < (1 : Int) := by exact_mod_cast hb.2
  omega

theorem unique_integer_lift
    (endpoint left right : Real) (m n : Int)
    (hwidth : right - left < 1)
    (hm0 : left <= endpoint + (m : Real))
    (hm1 : endpoint + (m : Real) <= right)
    (hn0 : left <= endpoint + (n : Real))
    (hn1 : endpoint + (n : Real) <= right) : m = n := by
  have hz : |((m - n : Int) : Real)| < 1 := by
    rw [abs_lt]
    push_cast
    constructor <;> linarith
  have heq := integer_zero_of_abs_lt_one (m - n) hz
  omega

theorem unwrap_integer_difference
    (a b : Real) (z : Int)
    (hcong : a - b = (z : Real)) (hsmall : |a - b| < 1) : a = b := by
  have hz : z = 0 := integer_zero_of_abs_lt_one z (by rwa [<- hcong])
  rw [hz] at hcong
  norm_num at hcong
  linarith

theorem radius_width_transfer
    (H r0 r1 w0 w1 distance : Real)
    (hH : 0 <= H)
    (hupper : w0 <= 2 * H * r0)
    (hlower : H * r1 / 4 <= w1)
    (hlip : r0 - r1 <= distance) :
    w0 / 8 - H * distance / 4 <= w1 := by
  have hscaled := mul_le_mul_of_nonneg_left hlip hH
  nlinarith

theorem neighborhood_width
    (H r0 r1 w0 w1 distance : Real)
    (hH : 0 <= H) (hHmax : H <= 1 / 8)
    (hw0 : 0 <= w0)
    (hupper : w0 <= 2 * H * r0)
    (hlower : H * r1 / 4 <= w1)
    (hlip : r0 - r1 <= distance)
    (hdistance : distance <= 2 * w0) :
    w0 / 16 <= w1 := by
  have hbase := radius_width_transfer H r0 r1 w0 w1 distance hH
    hupper hlower hlip
  have hscaled := mul_le_mul_of_nonneg_left hdistance hH
  have hproduct := mul_nonneg (show 0 <= (1 / 8 : Real) - H by linarith) hw0
  nlinarith

theorem stationary_transfer
    (H r0 r1 w0 w1 distance drift : Real)
    (hH : 0 <= H)
    (hupper : w0 <= 2 * H * r0)
    (hlower : H * r1 / 4 <= w1)
    (hlip : r0 - r1 <= distance)
    (hmotion : distance <= drift)
    (hbudget : (8 + 2 * H) * drift <= w0) :
    drift <= w1 := by
  have hbase := radius_width_transfer H r0 r1 w0 w1 distance hH
    hupper hlower hlip
  have hscaled := mul_le_mul_of_nonneg_left hmotion hH
  nlinarith

theorem stationary_relative_transfer
    (H r0 r1 w0 w1 distance drift mu : Real)
    (hH : 0 <= H) (hw0 : 0 <= w0)
    (hupper : w0 <= 2 * H * r0)
    (hlower : H * r1 / 4 <= w1)
    (hlip : r0 - r1 <= distance)
    (hmotion : distance <= drift)
    (hrelative : drift <= mu * w0)
    (hmu : mu * (8 + 2 * H) <= 1) :
    drift <= w1 := by
  have hbudget : (8 + 2 * H) * drift <= w0 := by
    calc
      (8 + 2 * H) * drift <= (8 + 2 * H) * (mu * w0) :=
        mul_le_mul_of_nonneg_left hrelative (by linarith)
      _ = (mu * (8 + 2 * H)) * w0 := by ring
      _ <= 1 * w0 := mul_le_mul_of_nonneg_right hmu hw0
      _ = w0 := one_mul w0
  exact stationary_transfer H r0 r1 w0 w1 distance drift hH
    hupper hlower hlip hmotion hbudget

theorem uniform_stationary_budget
    (H mu : Real) (hH : H <= 1 / 8)
    (hmu0 : 0 <= mu) (hmu1 : mu <= 4 / 33) :
    mu * (8 + 2 * H) <= 1 := by
  have hproduct := mul_nonneg hmu0
    (show 0 <= (1 / 8 : Real) - H by linarith)
  nlinarith

theorem stationary_metric_transfer
    {X : Type*} [PseudoMetricSpace X]
    (radius width : X -> Real) (H drift : Real) (x y : X)
    (hH : 0 <= H)
    (hlip : |radius x - radius y| <= dist x y)
    (hupper : width x <= 2 * H * radius x)
    (hlower : H * radius y / 4 <= width y)
    (hmotion : dist x y <= drift)
    (hbudget : (8 + 2 * H) * drift <= width x) :
    drift <= width y := by
  exact stationary_transfer H (radius x) (radius y) (width x) (width y)
    (dist x y) drift hH hupper hlower
    (le_trans (le_abs_self _) hlip) hmotion hbudget

theorem spacing_span
    (f : Nat -> Real) (step : Real) (n : Nat) :
    (forall i, i < n -> step <= f (i + 1) - f i) ->
      (n : Real) * step <= f n - f 0 := by
  induction n with
  | zero =>
      intro hgap
      simp
  | succ n ih =>
      intro hgap
      have hprefix := ih (fun i hi =>
        hgap i (Nat.lt_trans hi (Nat.lt_succ_self n)))
      have hlast := hgap n (Nat.lt_succ_self n)
      push_cast
      nlinarith

theorem closed_grid_cardinality
    (f : Nat -> Real) (n : Nat) (left length period : Real)
    (hperiod : 0 < period)
    (hfirst : left <= f 0) (hlast : f n <= left + length)
    (hgap : forall i, i < n -> 1 / period <= f (i + 1) - f i) :
    ((n + 1 : Nat) : Real) <= length * period + 1 := by
  have hspan := spacing_span f (1 / period) n hgap
  have hscaled := mul_le_mul_of_nonneg_right hspan (le_of_lt hperiod)
  have hcancel : ((n : Real) * (1 / period)) * period = (n : Real) := by
    field_simp
  push_cast
  nlinarith

theorem regular_fraction
    (D : Nat) (hD : 3 <= D) :
    (1 / 250 : Real) + 1 / (D : Real) < 1 / 2 := by
  have hDreal : (3 : Real) <= (D : Real) := by exact_mod_cast hD
  have hinv : 1 / (D : Real) <= (1 / 3 : Real) :=
    one_div_le_one_div_of_le (by norm_num) hDreal
  linarith

theorem truncation_budget
    (D : Nat) (hD : 1 <= D) : 16000 * D + 4 <= 16004 * D := by
  omega

theorem planar_face_recurrence
    (F : Nat -> Nat) (hzero : F 0 <= 1)
    (hstep : forall s, F (s + 1) <= F s + 4 * s + 2) :
    forall s, F s <= 2 * s ^ 2 + 1 := by
  intro s
  induction s with
  | zero => simpa using hzero
  | succ s ih =>
      have hnext := hstep s
      nlinarith

theorem scalar_entropy_constant
    (D h : Nat) (hD : 1 <= D) (hh : 1 <= h) :
    2 * (16004 * D * h) ^ 2 + 1 <= 801 ^ 3 * (D * h) ^ 2 := by
  have hprod : 1 <= D * h := by nlinarith
  have hsquare : 1 <= (D * h) ^ 2 := by nlinarith
  nlinarith

theorem anchored_entropy_absorption
    (D h : Nat) (hD : 1 <= D) (hh : 1 <= h) :
    h ^ (D + 1) * (2 * (16004 * D * h) ^ 2 + 1) ^ (2 * D) <=
      (801 * D * h) ^ (6 * D) := by
  have hprod : 1 <= D * h := by nlinarith
  have hbase : h <= D * h := by nlinarith
  have hanchor : h ^ (D + 1) <= (D * h) ^ (2 * D) :=
    le_trans (pow_le_pow_left' hbase (D + 1))
      (pow_le_pow_right' hprod (by omega))
  have hscalar := scalar_entropy_constant D h hD hh
  calc
    h ^ (D + 1) * (2 * (16004 * D * h) ^ 2 + 1) ^ (2 * D) <=
        (D * h) ^ (2 * D) * (801 ^ 3 * (D * h) ^ 2) ^ (2 * D) :=
      Nat.mul_le_mul hanchor (pow_le_pow_left' hscalar (2 * D))
    _ = ((D * h) * (801 ^ 3 * (D * h) ^ 2)) ^ (2 * D) :=
      (mul_pow _ _ _).symm
    _ = ((801 * D * h) ^ 3) ^ (2 * D) := by
      congr 1
      ring
    _ = (801 * D * h) ^ (6 * D) := by
      rw [<- pow_mul]
      congr 1
      omega

end ReturnPatternCore

#print axioms ReturnPatternCore.stationary_metric_transfer
#print axioms ReturnPatternCore.closed_grid_cardinality
#print axioms ReturnPatternCore.anchored_entropy_absorption
