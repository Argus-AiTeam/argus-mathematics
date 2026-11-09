import Mathlib

set_option maxHeartbeats 4000000

namespace AngularCertificate

noncomputable section

def alpha (a b : ℝ) : ℝ := (1 + a * b) / 4
def beta (a b : ℝ) : ℝ := (a + b) / 4
def phi (q : ℝ) : ℝ := (1 - q ^ 2) / 4
def d (q : ℝ) : ℝ := q ^ 2 * (1 + q ^ 2) / 16

theorem finite_bracket (n : ℕ) (F : ℕ → ℝ) (y : ℝ)
    (hn : 0 < n) (h0 : F 0 ≤ y) (hend : y ≤ F n) :
    ∃ j, j < n ∧ F j ≤ y ∧ y ≤ F (j + 1) := by
  induction n with
  | zero => omega
  | succ n ih =>
      by_cases hprev : y ≤ F n
      · by_cases hz : n = 0
        · subst n
          exact ⟨0, by omega, h0, hend⟩
        · obtain ⟨j, hj, hlo, hhi⟩ := ih (by omega) hprev
          exact ⟨j, by omega, hlo, hhi⟩
      · exact ⟨n, by omega, le_of_lt (lt_of_not_ge hprev), hend⟩

theorem shared_left (a b : ℝ) :
    alpha a b - a * beta a b = phi a := by
  unfold alpha beta phi
  ring

theorem shared_right (a b : ℝ) :
    alpha a b - b * beta a b = phi b := by
  unfold alpha beta phi
  ring

theorem sector_transfer (a b t e x y : ℝ) (hab : a < b)
    (hlo : a * t + e * x * phi a ≤ y)
    (hhi : y ≤ b * t + e * x * phi b) :
    0 ≤ t - e * x * beta a b ∧
      a * (t - e * x * beta a b) ≤ y - e * x * alpha a b ∧
      y - e * x * alpha a b ≤ b * (t - e * x * beta a b) := by
  have ha : a * (t - e * x * beta a b) =
      a * t + e * x * phi a - e * x * alpha a b := by
    unfold alpha beta phi
    ring
  have hb : b * (t - e * x * beta a b) =
      b * t + e * x * phi b - e * x * alpha a b := by
    unfold alpha beta phi
    ring
  have hl : a * (t - e * x * beta a b) ≤ y - e * x * alpha a b := by
    linarith
  have hu : y - e * x * alpha a b ≤ b * (t - e * x * beta a b) := by
    linarith
  have ht : 0 ≤ t - e * x * beta a b := by
    by_contra h
    have hneg : (b - a) * (t - e * x * beta a b) < 0 :=
      mul_neg_of_pos_of_neg (sub_pos.mpr hab) (lt_of_not_ge h)
    nlinarith [hl, hu]
  exact ⟨ht, hl, hu⟩

theorem radial_budget_identity (a b e x y p q al ar bl br : ℝ)
    (hsum : a + b = -e * x * bl + e * y * br)
    (hq : q * a = y - e * x * al - q / 2)
    (hp : p * b = x + e * y * ar - p / 2) :
    a * (1 - e * x * q) + b * (1 + e * y * p) =
      e ^ 2 * (x ^ 2 * al + y ^ 2 * ar) -
        e * x * (bl - q / 2) + e * y * (br - p / 2) := by
  linear_combination hsum - e * x * hq + e * y * hp

theorem d_nonnegative (q : ℝ) : 0 ≤ d q := by
  unfold d
  positivity

theorem surplus_identity (p q : ℝ) :
    d p + d q - (p ^ 2 + q ^ 2 + 2 * p ^ 2 * q ^ 2) / 16 =
      (p ^ 2 - q ^ 2) ^ 2 / 16 := by
  unfold d
  ring

theorem surplus_nonnegative (p q : ℝ) :
    (p ^ 2 + q ^ 2 + 2 * p ^ 2 * q ^ 2) / 16 ≤ d p + d q := by
  have h := surplus_identity p q
  nlinarith [sq_nonneg (p ^ 2 - q ^ 2)]

theorem product_abs_half {u c : ℝ} (hu : |u| ≤ 1)
    (hc : 0 ≤ c ∧ c ≤ 1 / 2) : |u * c| ≤ 1 / 2 := by
  calc
    |u * c| = |u| * c := by rw [abs_mul, abs_of_nonneg hc.1]
    _ ≤ 1 * c := mul_le_mul_of_nonneg_right hu hc.1
    _ ≤ 1 / 2 := by linarith [hc.2]

theorem rough_angle {a u q c v e : ℝ}
    (ha0 : 0 ≤ a) (ha : a ≤ e / 2) (hq : |q| ≤ 1) (hu : |u| ≤ 1)
    (hc : 0 ≤ c ∧ c ≤ 1 / 2) (he : 0 ≤ e)
    (hv : v - q / 2 = q * a + e * (u * c)) :
    |v - q / 2| ≤ e := by
  have hqa : |q * a| ≤ a := by
    rw [abs_mul, abs_of_nonneg ha0]
    nlinarith
  have huc := product_abs_half hu hc
  have heuc : |e * (u * c)| ≤ e / 2 := by
    rw [abs_mul, abs_of_nonneg he]
    nlinarith
  rw [hv]
  have htri := abs_add_le (q * a) (e * (u * c))
  linarith

theorem square_error {x p e : ℝ}
    (hx : |x| ≤ 1) (hp : |p| ≤ 1) (he : 0 ≤ e)
    (hnear : |x - p / 2| ≤ e) :
    x ^ 2 - p ^ 2 / 4 ≤ 3 / 2 * e := by
  obtain ⟨hxl, hxu⟩ := abs_le.mp hx
  obtain ⟨hpl, hpu⟩ := abs_le.mp hp
  have hadd : |x + p / 2| ≤ 3 / 2 :=
    abs_le.mpr ⟨by linarith, by linarith⟩
  calc
    x ^ 2 - p ^ 2 / 4 ≤ |x ^ 2 - p ^ 2 / 4| := le_abs_self _
    _ = |x - p / 2| * |x + p / 2| := by
      rw [← abs_mul]
      congr 1
      ring
    _ ≤ e * (3 / 2) := mul_le_mul hnear hadd (abs_nonneg _) he
    _ = 3 / 2 * e := by ring

theorem energy_bound {e delta x y p q al ar : ℝ}
    (he : 0 ≤ e) (hd : 0 ≤ delta)
    (hx : |x| ≤ 1) (hy : |y| ≤ 1) (hp : |p| ≤ 1) (hq : |q| ≤ 1)
    (hxn : |x - p / 2| ≤ e) (hyn : |y - q / 2| ≤ e)
    (hal : 0 ≤ al ∧ al ≤ 1 / 2) (har : 0 ≤ ar ∧ ar ≤ 1 / 2)
    (hale : |al - (1 + q ^ 2) / 4| ≤ delta / 2)
    (hare : |ar - (1 + p ^ 2) / 4| ≤ delta / 2) :
    x ^ 2 * al + y ^ 2 * ar ≤ d p + d q + 3 / 2 * e + delta / 4 := by
  have hsx := square_error hx hp he hxn
  have hsy := square_error hy hq he hyn
  have hp2 : p ^ 2 ≤ 1 := by
    have hh : 0 ≤ (1 - |p|) * (1 + |p|) :=
      mul_nonneg (by linarith) (by positivity)
    nlinarith [sq_abs p]
  have hq2 : q ^ 2 ≤ 1 := by
    have hh : 0 ≤ (1 - |q|) * (1 + |q|) :=
      mul_nonneg (by linarith) (by positivity)
    nlinarith [sq_abs q]
  have hxm := mul_le_mul_of_nonneg_right hsx hal.1
  have hym := mul_le_mul_of_nonneg_right hsy har.1
  have hxmax := mul_le_mul_of_nonneg_left hal.2
    (show 0 ≤ 3 / 2 * e by positivity)
  have hymax := mul_le_mul_of_nonneg_left har.2
    (show 0 ≤ 3 / 2 * e by positivity)
  have hxc : p ^ 2 / 4 * (al - (1 + q ^ 2) / 4) ≤ delta / 8 := by
    have h1 := mul_le_mul_of_nonneg_left (abs_le.mp hale).2
      (show 0 ≤ p ^ 2 / 4 by positivity)
    have h2 := mul_le_mul_of_nonneg_right hp2
      (show 0 ≤ delta / 8 by positivity)
    nlinarith
  have hyc : q ^ 2 / 4 * (ar - (1 + p ^ 2) / 4) ≤ delta / 8 := by
    have h1 := mul_le_mul_of_nonneg_left (abs_le.mp hare).2
      (show 0 ≤ q ^ 2 / 4 by positivity)
    have h2 := mul_le_mul_of_nonneg_right hq2
      (show 0 ≤ delta / 8 by positivity)
    nlinarith
  have hsur := surplus_nonnegative p q
  nlinarith

theorem product_abs_one {x q : ℝ} (hx : |x| ≤ 1) (hq : |q| ≤ 1) :
    |x * q| ≤ 1 := by
  calc
    |x * q| = |x| * |q| := abs_mul _ _
    _ ≤ 1 * 1 := mul_le_mul hx hq (abs_nonneg _) (by norm_num)
    _ = 1 := by norm_num

theorem radial_caps (a b x y p q al ar bl br M N : ℝ)
    (hx : |x| ≤ 1) (hy : |y| ≤ 1) (hxy : |x| + |y| ≤ 1)
    (hpabs : |p| ≤ 1) (hqabs : |q| ≤ 1)
    (hal : 0 ≤ al ∧ al ≤ 1 / 2) (har : 0 ≤ ar ∧ ar ≤ 1 / 2)
    (hbl : |bl| ≤ 1 / 2) (hbr : |br| ≤ 1 / 2)
    (hble : |bl - q / 2| ≤ 1 / 16000000)
    (hbre : |br - p / 2| ≤ 1 / 16000000)
    (hale : |al - (1 + q ^ 2) / 4| ≤ 1 / 8000000)
    (hare : |ar - (1 + p ^ 2) / 4| ≤ 1 / 8000000)
    (hMlo : 1 / 1000 + d q ≤ M) (hNlo : 1 / 1000 + d p ≤ N)
    (hMhi : M ≤ 1 / 8 + 1 / 1000) (hNhi : N ≤ 1 / 8 + 1 / 1000)
    (hsum : a + b = -(1 / 2000) * x * bl + (1 / 2000) * y * br)
    (hqr : q * a = y - (1 / 2000) * x * al - q / 2)
    (hpr : p * b = x + (1 / 2000) * y * ar - p / 2) :
    a ≤ (1 / 2000 : ℝ) ^ 2 * M ∨ b ≤ (1 / 2000 : ℝ) ^ 2 * N := by
  by_contra hcover
  push Not at hcover
  obtain ⟨ha, hb⟩ := hcover
  have hdq := d_nonnegative q
  have hdp := d_nonnegative p
  have hM0 : 0 ≤ M := by linarith
  have hN0 : 0 ≤ N := by linarith
  have ha0 : 0 ≤ a := by nlinarith
  have hb0 : 0 ≤ b := by nlinarith
  have hxb : |x * bl| ≤ |x| / 2 := by
    rw [abs_mul]
    nlinarith [mul_nonneg (abs_nonneg x) (sub_nonneg.mpr hbl)]
  have hyb : |y * br| ≤ |y| / 2 := by
    rw [abs_mul]
    nlinarith [mul_nonneg (abs_nonneg y) (sub_nonneg.mpr hbr)]
  have hab : a + b ≤ 1 / 4000 := by
    nlinarith [neg_le_abs (x * bl), le_abs_self (y * br)]
  have hynear : |y - q / 2| ≤ 1 / 2000 := by
    apply rough_angle ha0 (by linarith) hqabs hx hal (by norm_num)
    nlinarith [hqr]
  have hxnear : |x - p / 2| ≤ 1 / 2000 := by
    apply rough_angle hb0 (by linarith) hpabs
      (show |-y| ≤ 1 by simpa only [abs_neg] using hy) har (by norm_num)
    nlinarith [hpr]
  have hE := energy_bound (e := (1 / 2000 : ℝ))
    (delta := (1 / 4000000 : ℝ)) (by norm_num) (by norm_num)
    hx hy hpabs hqabs hxnear hynear hal har
    (by norm_num; exact hale) (by norm_num; exact hare)
  have hid := radial_budget_identity a b (1 / 2000) x y p q al ar bl br
    hsum hqr hpr
  have hxe : |x * (bl - q / 2)| ≤ |x| / 16000000 := by
    rw [abs_mul]
    nlinarith [mul_nonneg (abs_nonneg x) (sub_nonneg.mpr hble)]
  have hye : |y * (br - p / 2)| ≤ |y| / 16000000 := by
    rw [abs_mul]
    nlinarith [mul_nonneg (abs_nonneg y) (sub_nonneg.mpr hbre)]
  have herr : -x * (bl - q / 2) + y * (br - p / 2) ≤ 1 / 16000000 := by
    nlinarith [neg_le_abs (x * (bl - q / 2)), le_abs_self (y * (br - p / 2))]
  have hbudget :
      a * (1 - (1 / 2000) * x * q) + b * (1 + (1 / 2000) * y * p) ≤
        (x ^ 2 * al + y ^ 2 * ar) / 4000000 + 1 / 32000000000 := by
    nlinarith [hid, herr]
  have hxq := product_abs_one hx hqabs
  have hyp := product_abs_one hy hpabs
  have hf1 : 1999 / 2000 ≤ 1 - (1 / 2000) * x * q := by
    nlinarith [le_abs_self (x * q)]
  have hf2 : 1999 / 2000 ≤ 1 + (1 / 2000) * y * p := by
    nlinarith [neg_le_abs (y * p)]
  have hl1 := mul_le_mul_of_nonneg_left hf1 ha0
  have hl2 := mul_le_mul_of_nonneg_left hf2 hb0
  have hfailure :
      (M + N) * (1999 / 2000) - (x ^ 2 * al + y ^ 2 * ar) - 1 / 8000 < 0 := by
    nlinarith [hbudget, hl1, hl2, ha, hb]
  have hpositive :
      15983 / 16000000 ≤
        (M + N) * (1999 / 2000) - (x ^ 2 * al + y ^ 2 * ar) - 1 / 8000 := by
    linarith [hE, hMlo, hNlo, hMhi, hNhi]
  linarith

theorem reciprocal_sqrt_majorant (z : ℝ) (hz : 0 ≤ z) :
    1 / Real.sqrt (1 + z) ≤ 1 - z / 2 + 3 * z ^ 2 / 8 := by
  let R : ℝ := 1 - z / 2 + 3 * z ^ 2 / 8
  have hR : 0 ≤ R := by
    dsimp [R]
    nlinarith [sq_nonneg (z - 2 / 3)]
  have hQ : 0 ≤ 9 * z ^ 2 - 15 * z + 40 := by
    nlinarith [sq_nonneg (z - 5 / 6)]
  have hpol : 0 ≤ z ^ 3 * (9 * z ^ 2 - 15 * z + 40) / 64 := by positivity
  have hid : R ^ 2 * (1 + z) - 1 =
      z ^ 3 * (9 * z ^ 2 - 15 * z + 40) / 64 := by
    dsimp [R]
    ring
  have hs : 0 < Real.sqrt (1 + z) := Real.sqrt_pos.mpr (by linarith)
  have hsq : (Real.sqrt (1 + z)) ^ 2 = 1 + z :=
    Real.sq_sqrt (by linarith)
  have hmul0 : 0 ≤ R * Real.sqrt (1 + z) :=
    mul_nonneg hR (Real.sqrt_nonneg _)
  have hmul_sq : 1 ≤ (R * Real.sqrt (1 + z)) ^ 2 := by
    rw [mul_pow, hsq]
    nlinarith only [hid, hpol]
  have hmul : 1 ≤ R * Real.sqrt (1 + z) := by nlinarith
  exact (div_le_iff₀ hs).mpr hmul

end

end AngularCertificate
