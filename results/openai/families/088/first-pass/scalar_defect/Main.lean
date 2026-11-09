import Mathlib

set_option maxHeartbeats 1600000

namespace ScalarDefect

noncomputable section

def cubic (n : Nat) (x : Real) : Real :=
  1 + (n : Real) * x + (n : Real) * (n - 1) / 2 * x ^ 2
    + (n : Real) * (n - 1) * (n - 2) / 6 * x ^ 3

lemma coeff2_nonneg (n : Nat) : 0 <= (n : Real) * (n - 1) := by
  by_cases hn : n = 0
  · subst n
    norm_num
  · have hn1 : (1 : Real) <= n := by exact_mod_cast (Nat.one_le_iff_ne_zero.mpr hn)
    exact mul_nonneg (Nat.cast_nonneg n) (by linarith)

lemma coeff3_nonneg (n : Nat) : 0 <= (n : Real) * (n - 1) * (n - 2) := by
  by_cases hn : n < 2
  · interval_cases n <;> norm_num
  · have hn2 : (2 : Real) <= n := by exact_mod_cast (show 2 <= n by omega)
    exact mul_nonneg (coeff2_nonneg n) (by linarith)

theorem cubic_le_pow (n : Nat) (x : Real) (hx : 0 <= x) :
    cubic n x <= (1 + x) ^ n := by
  induction n with
  | zero => simp [cubic]
  | succ n ih =>
    have hprod := mul_nonneg (coeff3_nonneg n) (pow_nonneg hx 4)
    have hid : (1 + x) * cubic n x - cubic (n + 1) x =
        (n : Real) * (n - 1) * (n - 2) / 6 * x ^ 4 := by
      simp only [cubic, Nat.cast_add, Nat.cast_one]
      ring
    calc
      cubic (n + 1) x <= (1 + x) * cubic n x := by nlinarith
      _ <= (1 + x) * (1 + x) ^ n :=
        mul_le_mul_of_nonneg_left ih (by linarith)
      _ = (1 + x) ^ (n + 1) := by rw [pow_succ]; ring

def tail3 (n : Nat) (x : Real) : Real :=
  (1 + x) ^ n - 1 - (n : Real) * x - (n : Real) * (n - 1) / 2 * x ^ 2

lemma tail3_nonneg (n : Nat) (x : Real) (hx : 0 <= x) :
    0 <= tail3 n x := by
  have h := cubic_le_pow n x hx
  have hp := mul_nonneg (coeff3_nonneg n) (pow_nonneg hx 3)
  dsimp [tail3, cubic] at *
  nlinarith

lemma tail2_nonneg (n : Nat) (x : Real) (hx : 0 <= x) :
    0 <= (1 + x) ^ n - 1 - (n : Real) * x := by
  have h := tail3_nonneg n x hx
  have hp := mul_nonneg (coeff2_nonneg n) (sq_nonneg x)
  dsimp [tail3] at h
  nlinarith

lemma power_ge_one (n : Nat) (x : Real) (hx : 0 <= x) :
    1 <= (1 + x) ^ n := by
  have h := tail2_nonneg n x hx
  have hp := mul_nonneg (Nat.cast_nonneg n : (0 : Real) <= n) hx
  linarith

def doubleTail (n : Nat) (x : Real) : Real :=
  (1 + x) ^ (2 * n) - 8 * (1 + x) ^ n + 7
    + 6 * (n : Real) * x + (2 * (n : Real) ^ 2 - 3 * n) * x ^ 2

lemma doubleTail_nonneg (n : Nat) (x : Real) (hx : 0 <= x) :
    0 <= doubleTail n x := by
  induction n with
  | zero => norm_num [doubleTail]
  | succ n ih =>
    have hpow : (1 + x) ^ (2 * (n + 1)) =
        (1 + x) ^ (2 * n) * (1 + x) ^ 2 := by
      rw [show 2 * (n + 1) = 2 * n + 2 by omega, pow_add]
    have hid : doubleTail (n + 1) x =
        (1 + x) ^ 2 * doubleTail n x
        + 8 * x * ((1 + x) ^ (n + 1) - cubic (n + 1) x)
        + 4 * (n : Real) * x ^ 3
        + (n : Real) * (4 * (n : Real) ^ 2 - 6 * n + 5) / 3 * x ^ 4 := by
      simp only [doubleTail, cubic, Nat.cast_add, Nat.cast_one]
      rw [hpow, pow_succ]
      ring
    have hc : 0 <= (1 + x) ^ (n + 1) - cubic (n + 1) x :=
      sub_nonneg.mpr (cubic_le_pow (n + 1) x hx)
    have hq : 0 <= 4 * (n : Real) ^ 2 - 6 * n + 5 := by
      nlinarith [sq_nonneg ((n : Real) - 3 / 4)]
    rw [hid]
    positivity

theorem double_power_tail (n : Nat) (x : Real) (hx : 0 <= x) :
    8 * tail3 n x <= tail3 (2 * n) x := by
  have h := doubleTail_nonneg n x hx
  have hid : tail3 (2 * n) x - 8 * tail3 n x = doubleTail n x := by
    simp only [tail3, doubleTail, Nat.cast_mul, Nat.cast_ofNat]
    ring
  linarith

def invTaylor (n : Nat) (z : Real) : Real :=
  1 + (n : Real) * (1 - z) + (n : Real) * (n + 1) / 2 * (1 - z) ^ 2

lemma invTaylor_scaled (n : Nat) (z : Real) (hz : 0 <= z) (hz1 : z <= 1) :
    invTaylor n z * z ^ n <= 1 := by
  induction n with
  | zero => simp [invTaylor]
  | succ n ih =>
    have hx : 0 <= 1 - z := by linarith
    have hid : invTaylor n z - invTaylor (n + 1) z * z =
        ((n : Real) + 1) * (n + 2) / 2 * (1 - z) ^ 3 := by
      simp only [invTaylor, Nat.cast_add, Nat.cast_one]
      ring
    have hinc : invTaylor (n + 1) z * z <= invTaylor n z := by
      have hpos : 0 <= ((n : Real) + 1) * (n + 2) / 2 * (1 - z) ^ 3 := by positivity
      linarith
    calc
      invTaylor (n + 1) z * z ^ (n + 1) =
          (invTaylor (n + 1) z * z) * z ^ n := by rw [pow_succ]; ring
      _ <= invTaylor n z * z ^ n := mul_le_mul_of_nonneg_right hinc (pow_nonneg hz n)
      _ <= 1 := ih

lemma quadratic_nonneg (a b d u : Real) (hb : 0 < b) (hd : d ^ 2 <= 4 * a * b) :
    0 <= a + b * u ^ 2 - d * u := by
  have h : 0 <= 4 * b * (a + b * u ^ 2 - d * u) := by
    nlinarith [sq_nonneg (2 * b * u - d)]
  exact nonneg_of_mul_nonneg_right h (by positivity)

def k (n : Nat) : Real := if n = 4 then 1 else 2
def beta (n : Nat) : Real := if n = 4 then 1 / 2 else 2 / 3
def weight (n : Nat) : Real := if n = 4 then 3 / 14 else if n <= 6 then 1 / 3 else 1 / 2
def spec (n : Nat) : Real :=
  if n = 4 then 121 / 35 else ((n : Real) ^ 2 + 5 * n + 7) / ((n + 1) * (n + 3))
def phi (n : Nat) (z : Real) : Real := if n = 4 then z else z ^ 2
def e (n : Nat) (z : Real) : Real := (1 / z ^ n - 1) / n
def M (n : Nat) (z : Real) : Real := phi n z - 1 + k n * e n z
def W (n : Nat) (z : Real) : Real :=
  if n = 4 then z - 1 + e n z else z ^ 2 - z + e n z
def G (n : Nat) (z : Real) : Real := if z <= 1 then 0 else beta n * M n z
def D (n : Nat) (z : Real) : Real := phi n z - 1 - G n z
def zI (n : Nat) (z : Real) : Real :=
  if z <= 1 then 0 else
    if n = 4 then z ^ 2 - z - 2 * (z - z / z ^ n) / n
      + (z - 1 / (z ^ n) ^ 2) / (2 * n + 1)
    else 4 * ((z ^ 4 - z) / 3 - 2 * (z - z ^ 2 / z ^ n) / ((n : Real) - 1)
      + (z - 1 / (z ^ n) ^ 2) / (2 * n + 1))
def L (n : Nat) (z : Real) : Real :=
  spec n * ((((n : Real) - 1) * (beta n) ^ 2 * zI n z - 2 * n * (G n z) ^ 2)
    / (weight n * (2 * n + 8)) + (D n z) ^ 2 / (1 - weight n))
def defect (n : Nat) (z : Real) : Real := 2 * W n z - L n z

def V0 (m : Real) : Real := 34*m^5-95*m^4-1666*m^3-5701*m^2-8052*m-2688
def V1 (m : Real) : Real := 2*m^5+9*m^4-162*m^3-845*m^2-1220*m-448
def V2 (m : Real) : Real := 5*m^3+8*m^2-41*m-56
def R (m : Real) : Real := 7*m^4+8*m^3-187*m^2-748*m-896
def r0 (m : Real) : Real := -2 * R m / (m^2 * (m^2+5*m+7))
def q0 (m : Real) : Real := V0 m / (4*m^2*(2*m+1)*(m^2+5*m+7)) - r0 m / 8
def q1 (m : Real) : Real := 2*V1 m / (m*(2*m+1)*(m^2+5*m+7))
def q2 (m : Real) : Real := 2*(m+4)*V2 m / (m*(m^2+5*m+7))
def q3 (m : Real) : Real := 8*(m-4)/3
def q4 (m : Real) : Real := 2*(m-4)/3
def r1 (m : Real) : Real := 32+128/m
def r2 (m : Real) : Real := 16+64/m
def constantTerm (m : Real) : Real := -q0 m-r0 m
def scale (m : Real) : Real := 9*(m+4)*(m+1)*(m+3)/(m^2+5*m+7)
def margin (m : Real) : Real := m+3-8*(m^2+5*m+7)/((m+1)*(m+3))
def largePoly (m a x : Real) : Real :=
  a^2*(q0 m+q1 m*x+q2 m*x^2+q3 m*x^3+q4 m*x^4)
    +a*(r0 m+r1 m*x+r2 m*x^2)+constantTerm m

lemma large_signs (m : Real) (hm : 10 <= m) :
    0 <= q0 m + r0 m / 8 ∧ r0 m <= 0 ∧ 0 <= q1 m ∧ 0 <= q2 m ∧
      0 <= q3 m ∧ 0 <= q4 m ∧ 0 <= r1 m ∧ 0 <= r2 m := by
  have hm0 : 0 < m := by linarith
  have ht : 0 <= m - 10 := by linarith
  have hs : 0 <= m - 7 := by linarith
  have hv0 : 0 <= V0 m := by
    have hid : V0 m = 34*(m-10)^5+1605*(m-10)^4+28534*(m-10)^3
        +227319*(m-10)^2+698128*(m-10)+130692 := by unfold V0; ring
    rw [hid]
    positivity
  have hv1 : 0 <= V1 m := by
    have hid : V1 m = 2*(m-10)^5+109*(m-10)^4+2198*(m-10)^3
        +19695*(m-10)^2+69280*(m-10)+30852 := by unfold V1; ring
    rw [hid]
    positivity
  have hv2 : 0 <= V2 m := by
    have hid : V2 m = 5*(m-7)^3+113*(m-7)^2+806*(m-7)+1764 := by unfold V2; ring
    rw [hid]
    positivity
  have hr : 0 <= R m := by
    have hid : R m = 7*(m-7)^4+204*(m-7)^3+2039*(m-7)^2+7414*(m-7)+4256 := by
      unfold R
      ring
    rw [hid]
    positivity
  have h4 : 0 <= m - 4 := by linarith
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · have hid : q0 m+r0 m/8 = V0 m/(4*m^2*(2*m+1)*(m^2+5*m+7)) := by unfold q0; ring
    rw [hid]
    positivity
  · unfold r0
    exact div_nonpos_of_nonpos_of_nonneg (by nlinarith) (by positivity)
  · unfold q1
    positivity
  · unfold q2
    positivity
  · unfold q3
    positivity
  · unfold q4
    positivity
  · unfold r1
    positivity
  · unfold r2
    positivity

lemma large_cancellations (m : Real) (hm : 7 <= m) :
    2*m*q0 m+q1 m+m*r0 m+r1 m = 0 ∧
    m*(2*m-1)*q0 m+2*m*q1 m+q2 m+m*(m-1)/2*r0 m+m*r1 m+r2 m =
      scale m*margin m := by
  have hm0 : m ≠ 0 := by linarith
  have hm1 : m+1 ≠ 0 := by linarith
  have hm3 : m+3 ≠ 0 := by linarith
  have hm2 : 2*m+1 ≠ 0 := by linarith
  have hnum : m^2+5*m+7 ≠ 0 := by nlinarith [sq_nonneg m]
  constructor <;>
    simp only [q0, q1, q2, r0, r1, r2, V0, V1, V2, R, scale, margin] <;>
    field_simp [hm0, hm1, hm3, hm2, hnum] <;> ring

lemma margin_lower (m : Real) (hm : 7 <= m) : 9 / 10 <= margin m := by
  have hm1 : m+1 ≠ 0 := by linarith
  have hm3 : m+3 ≠ 0 := by linarith
  have ht : 0 <= m-7 := by linarith
  have hid : (10*(m+1)*(m+3))*(margin m-9/10) =
      (m-7)*(10*(m-7)^2+191*(m-7)+918) := by
    unfold margin
    field_simp [hm1, hm3]
    ring
  have hp : 0 <= (10*(m+1)*(m+3))*(margin m-9/10) := by
    rw [hid]
    positivity
  have hc : 0 < 10*(m+1)*(m+3) := by
    have : 0 < m := by linarith
    positivity
  have : 0 <= margin m-9/10 := nonneg_of_mul_nonneg_right hp hc
  linarith

lemma scale_positive (m : Real) (hm : 7 <= m) : 0 < scale m := by
  have : 0 < m := by linarith
  unfold scale
  positivity

theorem large_power_lower (n : Nat) (hn : 10 <= n) (x : Real) (hx : 0 <= x) :
    scale n * margin n * x^2 <= largePoly n ((1+x)^n) x := by
  have hm : (10 : Real) <= n := by exact_mod_cast hn
  obtain ⟨h0,hr0,h1,h2,h3,h4,hr1,hr2⟩ := large_signs n hm
  obtain ⟨hlin,hquad⟩ := large_cancellations n (by linarith)
  have ht := tail3_nonneg (2*n) x hx
  have hd : 0 <= tail3 (2*n) x-8*tail3 n x := sub_nonneg.mpr (double_power_tail n x hx)
  have ht2 : 0 <= (1+x)^(2*n)-1-(2*(n:Real))*x := by
    simpa only [Nat.cast_mul, Nat.cast_ofNat] using tail2_nonneg (2*n) x hx
  have hn2 := tail2_nonneg n x hx
  have ht1 : 0 <= (1+x)^(2*n)-1 := sub_nonneg.mpr (power_ge_one (2*n) x hx)
  have hn1 : 0 <= (1+x)^n-1 := sub_nonneg.mpr (power_ge_one n x hx)
  have hpow : (1+x)^(2*n) = ((1+x)^n)^2 := by rw [mul_comm 2 n, pow_mul]
  have hnr0 : 0 <= -r0 n/8 := div_nonneg (neg_nonneg.mpr hr0) (by norm_num)
  let remainder :=
    (q0 n+r0 n/8)*tail3 (2*n) x
      +(-r0 n/8)*(tail3 (2*n) x-8*tail3 n x)
      +q1 n*x*((1+x)^(2*n)-1-(2*(n:Real))*x)
      +r1 n*x*((1+x)^n-1-(n:Real)*x)
      +q2 n*x^2*((1+x)^(2*n)-1)+r2 n*x^2*((1+x)^n-1)
      +q3 n*x^3*(1+x)^(2*n)+q4 n*x^4*(1+x)^(2*n)
  have hrem : 0 <= remainder := by
    dsimp [remainder]
    positivity
  have hid : largePoly n ((1+x)^n) x
      -( (n:Real)*(2*n-1)*q0 n+2*n*q1 n+q2 n
          +(n:Real)*(n-1)/2*r0 n+n*r1 n+r2 n)*x^2 =
      remainder+(2*(n:Real)*q0 n+q1 n+n*r0 n+r1 n)*x := by
    dsimp [largePoly, constantTerm, remainder, tail3]
    simp only [Nat.cast_mul, Nat.cast_ofNat]
    rw [hpow]
    ring
  rw [hlin, zero_mul, add_zero, hquad] at hid
  linarith

lemma large_bridge_lower (n : Nat) (hn : n = 7 ∨ n = 8 ∨ n = 9)
    (x : Real) (hx : 0 <= x) :
    scale n * margin n * x^2 <= largePoly n ((1+x)^n) x := by
  rcases hn with rfl | rfl | rfl <;>
    apply sub_nonneg.mp <;>
    dsimp only [largePoly, q0, q1, q2, q3, q4, r0, r1, r2, constantTerm,
      V0, V1, V2, R, scale, margin] <;>
    ring_nf <;> positivity

lemma large_scaled (n : Nat) (hn : 7 <= n) (z : Real) (hz : 1 < z) :
    scale n * (z^n)^2 * defect n z = largePoly n (z^n) (z-1) := by
  have hn4 : n ≠ 4 := by omega
  have hn6 : ¬ n <= 6 := by omega
  have hz1 : ¬ z <= 1 := by linarith
  have hz0 : z^n ≠ 0 := pow_ne_zero _ (by linarith)
  have hm : (7 : Real) <= n := by exact_mod_cast hn
  have hm0 : (n : Real) ≠ 0 := by linarith
  have hm1 : (n : Real)+1 ≠ 0 := by linarith
  have hm3 : (n : Real)+3 ≠ 0 := by linarith
  have hmn1 : (n : Real)-1 ≠ 0 := by linarith
  have hm2 : 2*(n : Real)+1 ≠ 0 := by linarith
  have hm4 : 2*(n : Real)+8 ≠ 0 := by linarith
  have hnum : (n : Real)^2+5*n+7 ≠ 0 := by nlinarith [sq_nonneg (n : Real)]
  simp only [defect, W, L, zI, D, G, M, phi, k, beta, weight, spec,
    if_neg hn4, if_neg hn6, if_neg hz1]
  simp only [e, largePoly, constantTerm, q0, q1, q2, q3, q4, r0, r1, r2,
    V0, V1, V2, R, scale]
  field_simp [hm0, hm1, hm3, hmn1, hm2, hm4, hnum, hz0]
  ring

def P4 (z : Real) : Real :=
  462*z^10-983*z^9+93*z^8+3399*z^5-3378*z^4+407
def P5 (z : Real) : Real :=
  151525*z^14-273570*z^12-680800*z^11+938157*z^10
    +225720*z^7-462264*z^5+101232
def P6 (z : Real) : Real :=
  48399*z^16-75894*z^14-218004*z^13+285961*z^12
    +56940*z^8-127478*z^6+30076

lemma P4_lower (x : Real) (hx : 0 <= x) : 328*x^2 <= P4 (1+x) := by
  have h1 := quadratic_nonneg 400 1400 1446 x (by norm_num) (by norm_num)
  have h2 := quadratic_nonneg 1000 17052 8111 (x^2) (by norm_num) (by norm_num)
  have hp := mul_nonneg (sq_nonneg x) (add_nonneg h1 h2)
  have hr : 0 <= P4 (1+x)-328*x^2
      -x^2*((400+1400*x^2-1446*x)+(1000+17052*(x^2)^2-8111*x^2)) := by
    unfold P4
    ring_nf
    positivity
  nlinarith only [hp, hr]

lemma P5_lower (x : Real) (hx : 0 <= x) : 193700*x^2 <= P5 (1+x) := by
  have h1 := quadratic_nonneg 200000 2900000 1505900 x (by norm_num) (by norm_num)
  have h2 := quadratic_nonneg 230000 86314305 8702775 (x^2) (by norm_num) (by norm_num)
  have hp := mul_nonneg (sq_nonneg x) (add_nonneg h1 h2)
  have hr : 0 <= P5 (1+x)-193700*x^2
      -x^2*((200000+2900000*x^2-1505900*x)+(230000+86314305*(x^2)^2-8702775*x^2)) := by
    unfold P5
    ring_nf
    positivity
  nlinarith only [hp, hr]

lemma P6_lower (x : Real) (hx : 0 <= x) : 451790*x^2 <= P6 (1+x) := by
  have h1 := quadratic_nonneg 1000 51269452 132249 (x^2) (by norm_num) (by norm_num)
  have hp := mul_nonneg (sq_nonneg x) h1
  have hr : 0 <= P6 (1+x)-451790*x^2
      -x^2*(1000+51269452*(x^2)^2-132249*x^2) := by
    unfold P6
    ring_nf
    positivity
  nlinarith only [hp, hr]

lemma small_scaled4 (z : Real) (hz : 1 < z) :
    2880*z^8*defect 4 z = P4 z := by
  have hz1 : ¬ z <= 1 := by linarith
  have hz0 : z ≠ 0 := by linarith
  norm_num [defect, W, L, zI, D, G, M, phi, k, beta, weight, spec, e, hz1, P4]
  field_simp [hz0]
  ring

lemma small_scaled5 (z : Real) (hz : 1 < z) :
    712800*z^10*defect 5 z = P5 z := by
  have hz1 : ¬ z <= 1 := by linarith
  have hz0 : z ≠ 0 := by linarith
  norm_num [defect, W, L, zI, D, G, M, phi, k, beta, weight, spec, e, hz1, P5]
  field_simp [hz0]
  ring

lemma small_scaled6 (z : Real) (hz : 1 < z) :
    221130*z^12*defect 6 z = P6 z := by
  have hz1 : ¬ z <= 1 := by linarith
  have hz0 : z ≠ 0 := by linarith
  norm_num [defect, W, L, zI, D, G, M, phi, k, beta, weight, spec, e, hz1, P6]
  field_simp [hz0]
  ring

lemma W1_left (n : Nat) (hn : 0 < n) (z : Real) (hz : 0 < z) (hz1 : z <= 1) :
    ((n:Real)+1)*(z-1)^2 <= 2*(z-1+e n z) := by
  have hnp : (0 : Real) < n := by exact_mod_cast hn
  have hpow : 0 < z^n := pow_pos hz n
  have hi : invTaylor n z <= 1/z^n :=
    (le_div_iff₀ hpow).mpr (invTaylor_scaled n z (le_of_lt hz) hz1)
  have he : (n:Real)*e n z = 1/z^n-1 := by
    unfold e
    field_simp
  have hp : 0 <= (n:Real)*(2*(z-1+e n z)-((n:Real)+1)*(z-1)^2) := by
    dsimp [invTaylor] at hi
    nlinarith only [hi, he]
  have hdiff : 0 <= 2*(z-1+e n z)-((n:Real)+1)*(z-1)^2 :=
    nonneg_of_mul_nonneg_right hp hnp
  linarith

lemma defect_left (n : Nat) (hn : 4 <= n) (z : Real) (hz : 0 < z) (hz1 : z <= 1) :
    (41/360:Real)*(z-1)^2 <= defect n z := by
  have hw := W1_left n (by omega) z hz hz1
  have hs : 0 <= (z-1)^2 := sq_nonneg _
  have hd : (z^2-1)^2 <= 4*(z-1)^2 := by
    have hpos : 0 <= 4-(z+1)^2 := by nlinarith
    nlinarith only [mul_nonneg hs hpos]
  by_cases hn4 : n = 4
  · subst n
    norm_num [defect, W, L, zI, D, G, phi, spec, weight, hz1]
    norm_num at hw
    nlinarith only [hw, hs]
  by_cases hn5 : n = 5
  · subst n
    norm_num [defect, W, L, zI, D, G, phi, spec, weight, hz1]
    norm_num at hw
    nlinarith only [hw, hd, hs]
  by_cases hn6 : n = 6
  · subst n
    norm_num [defect, W, L, zI, D, G, phi, spec, weight, hz1]
    norm_num at hw
    nlinarith only [hw, hd, hs]
  have hn7 : 7 <= n := by omega
  have hm7 : (7 : Real) <= n := by exact_mod_cast hn7
  have hm0 : (0 : Real) < n := by linarith
  have hnle6 : ¬ n <= 6 := by omega
  have hmarg := margin_lower n hm7
  have hc : 0 <= 2*((n:Real)^2+5*n+7)/((n+1)*(n+3)) := by positivity
  have hdscaled := mul_le_mul_of_nonneg_left hd hc
  have hmargin := mul_le_mul_of_nonneg_right (show (41/360:Real) <= margin n by linarith) hs
  simp only [defect, W, L, zI, D, G, phi, spec, weight,
    if_neg hn4, if_neg hnle6, if_pos hz1]
  dsimp [margin] at hmargin
  norm_num
  ring_nf at hw hdscaled hmargin ⊢
  linarith only [hw, hdscaled, hmargin]

lemma defect_right (n : Nat) (hn : 4 <= n) (z : Real) (hz : 1 < z) :
    (41/360:Real)*(z-1)^2/z^(2*n) <= defect n z := by
  have hz0 : 0 < z := by linarith
  have hx : 0 <= z-1 := by linarith
  have hzx : 1+(z-1) = z := by ring
  by_cases hn4 : n = 4
  · subst n
    have hp := P4_lower (z-1) hx
    rw [hzx] at hp
    have hid := small_scaled4 z hz
    norm_num
    apply (div_le_iff₀ (pow_pos hz0 8)).mpr
    nlinarith only [hp, hid]
  by_cases hn5 : n = 5
  · subst n
    have hp := P5_lower (z-1) hx
    rw [hzx] at hp
    have hid := small_scaled5 z hz
    norm_num
    apply (div_le_iff₀ (pow_pos hz0 10)).mpr
    nlinarith only [hp, hid, sq_nonneg (z-1)]
  by_cases hn6 : n = 6
  · subst n
    have hp := P6_lower (z-1) hx
    rw [hzx] at hp
    have hid := small_scaled6 z hz
    norm_num
    apply (div_le_iff₀ (pow_pos hz0 12)).mpr
    nlinarith only [hp, hid, sq_nonneg (z-1)]
  have hn7 : 7 <= n := by omega
  have hm7 : (7 : Real) <= n := by exact_mod_cast hn7
  have hlarge : scale n*margin n*(z-1)^2 <= largePoly n (z^n) (z-1) := by
    by_cases hn10 : 10 <= n
    · simpa only [hzx] using large_power_lower n hn10 (z-1) hx
    · have hcases : n = 7 ∨ n = 8 ∨ n = 9 := by omega
      simpa only [hzx] using large_bridge_lower n hcases (z-1) hx
  have hid := large_scaled n hn7 z hz
  have hscale := scale_positive n hm7
  have hmargin := margin_lower n hm7
  have hsmall : scale n*((41/360:Real)*(z-1)^2) <= scale n*(margin n*(z-1)^2) :=
    mul_le_mul_of_nonneg_left
      (mul_le_mul_of_nonneg_right (by linarith) (sq_nonneg (z-1))) (le_of_lt hscale)
  have hbound : (41/360:Real)*(z-1)^2 <= (z^n)^2*defect n z :=
    le_of_mul_le_mul_left (by nlinarith only [hlarge, hid, hsmall]) hscale
  have hpow : z^(2*n) = (z^n)^2 := by rw [mul_comm 2 n, pow_mul]
  apply (div_le_iff₀ (pow_pos hz0 (2*n))).mpr
  rw [hpow]
  calc
    (41/360:Real)*(z-1)^2 <= (z^n)^2*defect n z := hbound
    _ = defect n z*(z^n)^2 := mul_comm _ _

theorem scalar_defect (n : Nat) (hn : 4 <= n) (z : Real) (hz : 0 < z) :
    (41/360:Real)*(z-1)^2/(max 1 z)^(2*n) <= 2*W n z-L n z := by
  change (41/360:Real)*(z-1)^2/(max 1 z)^(2*n) <= defect n z
  by_cases hz1 : z <= 1
  · simpa only [max_eq_left hz1, one_pow, div_one] using defect_left n hn z hz hz1
  · have hzgt : 1 < z := by linarith
    simpa only [max_eq_right (le_of_lt hzgt)] using defect_right n hn z hzgt

lemma defect_at_one (n : Nat) : defect n 1 = 0 := by
  simp [defect, W, L, zI, D, G, phi, e]

theorem scalar_equality (n : Nat) (hn : 4 <= n) (z : Real) (hz : 0 < z) :
    2*W n z = L n z ↔ z = 1 := by
  constructor
  · intro heq
    have h := scalar_defect n hn z hz
    rw [heq, sub_self] at h
    have hp : 0 < (max 1 z)^(2*n) :=
      pow_pos (lt_of_lt_of_le (by norm_num : (0:Real) < 1) (le_max_left 1 z)) _
    have hnum := (div_le_iff₀ hp).mp h
    have hs : (z-1)^2 = 0 := by nlinarith [sq_nonneg (z-1)]
    have hzero : z-1 = 0 := (sq_eq_zero_iff).mp hs
    linarith
  · rintro rfl
    have h := defect_at_one n
    dsimp [defect] at h
    linarith

def meanCoefficient (n : Nat) : Real :=
  spec n*(2*n*(beta n)^2/(weight n*(2*n+8))-(1-beta n)^2/(1-weight n))

theorem scalar_mean (n : Nat) (hn : 4 <= n) :
    meanCoefficient n <= (2*k n-1)/(k n)^2 := by
  by_cases hn4 : n = 4
  · subst n
    norm_num [meanCoefficient, spec, beta, weight, k]
  by_cases hn5 : n = 5
  · subst n
    norm_num [meanCoefficient, spec, beta, weight, k]
  by_cases hn6 : n = 6
  · subst n
    norm_num [meanCoefficient, spec, beta, weight, k]
  have hn7 : 7 <= n := by omega
  have hm7 : (7 : Real) <= n := by exact_mod_cast hn7
  have hm0 : (0 : Real) < n := by linarith
  have hnle6 : ¬ n <= 6 := by omega
  have hm1 : (n : Real)+1 ≠ 0 := by linarith
  have hm3 : (n : Real)+3 ≠ 0 := by linarith
  have hm4 : (n : Real)+4 ≠ 0 := by linarith
  have hm8 : 2*(n : Real)+8 ≠ 0 := by linarith
  have hid : (3/4:Real)-meanCoefficient n =
      (3*(n:Real)^3+128*n^2+505*n+548)/(36*(n+1)*(n+3)*(n+4)) := by
    simp only [meanCoefficient, spec, beta, weight, if_neg hn4, if_neg hnle6]
    field_simp [hm1, hm3, hm4, hm8]
    ring
  have hpos : 0 <= (3*(n:Real)^3+128*n^2+505*n+548)/(36*(n+1)*(n+3)*(n+4)) := by
    positivity
  simp only [k, if_neg hn4]
  norm_num
  linarith

end
end ScalarDefect
