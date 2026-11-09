import Mathlib

namespace CriticalEndpoint

theorem fusion_identity (u v : Real)
    (hplus : 1 + u * v ≠ 0) (hminus : 1 - u * v ≠ 0)
    (hprod : 1 - u ^ 2 * v ^ 2 ≠ 0) :
    ((u + v) ^ 2 / (1 + u * v) + (u - v) ^ 2 / (1 - u * v)) / 2 =
      u ^ 2 + v ^ 2 -
        u ^ 2 * v ^ 2 * (2 - u ^ 2 - v ^ 2) / (1 - u ^ 2 * v ^ 2) := by
  field_simp [hplus, hminus, hprod] <;> ring

theorem fusion_loss_lower (u v q : Real)
    (hq0 : 0 <= q) (hq1 : q < 1)
    (hu0 : 0 <= u) (huq : u <= q)
    (hv0 : 0 <= v) (hvq : v <= q) :
    2 * (1 - q) * u * v <= u * v * (2 - u - v) / (1 - u * v) := by
  have hu1 : u < 1 := lt_of_le_of_lt huq hq1
  have hv1 : v < 1 := lt_of_le_of_lt hvq hq1
  have huv0 : 0 <= u * v := mul_nonneg hu0 hv0
  have hden : 0 < 1 - u * v := by
    nlinarith [mul_nonneg hu0 (sub_nonneg.mpr (le_of_lt hv1))]
  apply (le_div_iff₀ hden).2
  have hbase : 0 <= 2 * (1 - q) * u * v := by positivity
  have hnum : 2 * (1 - q) * u * v <= u * v * (2 - u - v) := by
    nlinarith [mul_nonneg huv0 (show 0 <= 2 * q - u - v by linarith)]
  have hmult :
      (2 * (1 - q) * u * v) * (1 - u * v) <= 2 * (1 - q) * u * v := by
    nlinarith [mul_nonneg hbase huv0]
  exact le_trans hmult hnum

theorem cavity_inverse_bound (x y H K theta : Real)
    (ht0 : 0 <= theta) (ht1 : theta < 1)
    (hx : x <= H + theta * y) (hy : y <= K + theta * x) :
    x <= (H + theta * K) / (1 - theta ^ 2) := by
  have hden : 0 < 1 - theta ^ 2 := by
    nlinarith [mul_pos (sub_pos.mpr ht1) (show 0 < 1 + theta by linarith)]
  apply (le_div_iff₀ hden).2
  have hm : theta * y <= theta * (K + theta * x) :=
    mul_le_mul_of_nonneg_left hy ht0
  nlinarith

theorem critical_theta_lt_one (b theta : Real)
    (hb : 2 <= b) (ht0 : 0 <= theta) (hcrit : b * theta ^ 2 = 1) :
    theta < 1 := by
  have hnonneg : 0 <= (b - 2) * theta ^ 2 :=
    mul_nonneg (by linarith) (sq_nonneg theta)
  nlinarith

theorem critical_moment_gap (b theta : Real)
    (hb : 2 <= b) (ht0 : 0 <= theta) (hcrit : b * theta ^ 2 = 1)
    (n : Nat) :
    1 - theta <= 1 - b * theta ^ (n + 3) := by
  have ht1 : theta < 1 := critical_theta_lt_one b theta hb ht0 hcrit
  have hpow : forall k : Nat, theta ^ (k + 1) <= theta := by
    intro k
    induction k with
    | zero => simp
    | succ k ih =>
      calc
        theta ^ (k + 1 + 1) = theta ^ (k + 1) * theta := by rw [pow_succ]
        _ <= theta * theta := mul_le_mul_of_nonneg_right ih ht0
        _ <= theta := by nlinarith
  have heq : b * theta ^ (n + 3) = theta ^ (n + 1) := by
    rw [show n + 3 = 2 + (n + 1) by omega, pow_add]
    calc
      b * (theta ^ 2 * theta ^ (n + 1)) =
          (b * theta ^ 2) * theta ^ (n + 1) := by ring
      _ = theta ^ (n + 1) := by rw [hcrit]; ring
  rw [heq]
  linarith [hpow n]

def companion (x : Real) : Matrix (Fin 2) (Fin 2) Real :=
  !![0, -1; 1, 2 * x]

theorem companion_quadratic (x : Real) :
    companion x * companion x - (2 * x) • companion x + 1 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [companion, Matrix.mul_apply, Fin.sum_univ_two] <;> ring

theorem companion_endpoint_power (n : Nat) :
    companion 1 ^ n =
      !![(1 : Real) - (n : Real), -(n : Real);
         (n : Real), 1 + (n : Real)] := by
  induction n with
  | zero =>
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [companion]
  | succ n ih =>
    rw [pow_succ, ih]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [companion, Matrix.mul_apply, Fin.sum_univ_two, Nat.cast_succ] <;> ring

end CriticalEndpoint
