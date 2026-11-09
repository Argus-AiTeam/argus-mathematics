import Mathlib

set_option autoImplicit false

namespace CongruencePersistence

theorem lifted_triangle {G : Type*} [Group G]
    (q0 q1 q2 w01 w12 w02 g01 g12 g02 n01 n12 n02 k : G)
    (h01 : q1 = w01 * q0 * g01 * n01)
    (h12 : q2 = w12 * q1 * g12 * n12)
    (h02 : q2 = w02 * q0 * g02 * n02)
    (hw : w12 * w01 = w02)
    (hg : g01 * g12 = g02 * k)
    (hn : Commute n01 g12) :
    n02 = k * n01 * n12 := by
  have h :
      w02 * q0 * g02 * n02 =
        w02 * q0 * g02 * (k * n01 * n12) := by
    calc
      w02 * q0 * g02 * n02 = q2 := h02.symm
      _ = w12 * (w01 * q0 * g01 * n01) * g12 * n12 := by rw [h12, h01]
      _ = (w12 * w01) * q0 * (g01 * (n01 * g12)) * n12 := by
        simp only [mul_assoc]
      _ = (w12 * w01) * q0 * (g01 * (g12 * n01)) * n12 := by rw [hn.eq]
      _ = (w12 * w01) * q0 * (g01 * g12) * n01 * n12 := by
        simp only [mul_assoc]
      _ = w02 * q0 * (g02 * k) * n01 * n12 := by rw [hw, hg]
      _ = w02 * q0 * g02 * (k * n01 * n12) := by simp only [mul_assoc]
  exact mul_left_cancel h

theorem coboundary_sign {A : Type*} [AddCommGroup A]
    (u c01 c12 c02 : A) (h : c02 = u + c01 + c12) :
    c12 - c02 + c01 = -u := by
  rw [h]
  abel

theorem cup_is_closed (a01 a12 a23 b01 b12 b23 : ℤ) :
    a12 * b23 - (a01 + a12) * b23 +
      a01 * (b12 + b23) - a01 * b12 = 0 := by
  ring

theorem coboundary_squared {A : Type*} [AddCommGroup A]
    (c01 c02 c03 c12 c13 c23 : A) :
    (c23 - c13 + c12) - (c23 - c03 + c02) +
      (c13 - c03 + c01) - (c12 - c02 + c01) = 0 := by
  abel

theorem integral_lift_is_closed {I J K : Type*}
    (d1 : (I → ℤ) →+ (J → ℤ)) (d2 : (J → ℤ) →+ (K → ℤ))
    (hd : ∀ c, d2 (d1 c) = 0)
    (m : ℤ) (hm : m ≠ 0) (x : J → ℤ) (c : I → ℤ) (y : J → ℤ)
    (hx : d2 x = 0) (hy : m • y = x + d1 c) :
    d2 y = 0 := by
  have hmul : m • d2 y = 0 := by
    calc
      m • d2 y = d2 (m • y) := (map_zsmul d2 m y).symm
      _ = d2 (x + d1 c) := by rw [hy]
      _ = 0 := by rw [map_add, hx, hd, add_zero]
  ext t
  have hpoint : m * (d2 y t) = 0 := by
    simpa [zsmul_eq_mul] using congrFun hmul t
  exact (mul_eq_zero.mp hpoint).resolve_left hm

theorem integral_lift_representation {I J : Type*}
    (d1 : (I → ℤ) →+ (J → ℤ))
    (m : ℤ) (x : J → ℤ) (c : I → ℤ) (y : J → ℤ)
    (hy : m • y = x + d1 c) :
    x = m • y - d1 c := by
  rw [hy]
  abel

theorem integral_cocycle_divisible {I J K : Type*}
    (d1 : (I → ℤ) →+ (J → ℤ)) (d2 : (J → ℤ) →+ (K → ℤ))
    (hd : ∀ c, d2 (d1 c) = 0)
    (m : ℕ) (hm : 0 < m) (x : J → ℤ) (c : I → ℤ)
    (hx : d2 x = 0)
    (hmod : ∀ t, ((x t + d1 c t : ℤ) : ZMod m) = 0) :
    ∃ y : J → ℤ, d2 y = 0 ∧ x = (m : ℤ) • y - d1 c := by
  let y : J → ℤ := fun t => (x t + d1 c t) / (m : ℤ)
  have hy : (m : ℤ) • y = x + d1 c := by
    ext t
    have hdiv : (m : ℤ) ∣ x t + d1 c t :=
      (ZMod.intCast_zmod_eq_zero_iff_dvd (x t + d1 c t) m).mp (hmod t)
    simpa [y, zsmul_eq_mul] using Int.mul_ediv_cancel' hdiv
  refine ⟨y, integral_lift_is_closed d1 d2 hd (m : ℤ) ?_ x c y hx hy,
    integral_lift_representation d1 (m : ℤ) x c y hy⟩
  exact_mod_cast hm.ne'

theorem dyadic_choose_divisible (j D h : ℕ)
    (hD : 0 < D) (hDj : D < 2 ^ j) (hh : 1 ≤ h) (hhD : h ≤ D) :
    2 ^ (j - Nat.log 2 D) ∣ Nat.choose (2 ^ j) h := by
  have hh0 : h ≠ 0 := by omega
  have hhN : h ≤ 2 ^ j := hhD.trans hDj.le
  apply (Nat.prime_two.pow_dvd_iff_le_factorization (Nat.choose_ne_zero hhN)).mpr
  rw [Nat.factorization_choose_prime_pow Nat.prime_two hhN hh0]
  have hfac : h.factorization 2 ≤ Nat.log 2 D := by
    apply Nat.le_log_of_pow_le (by decide)
    exact (Nat.ordProj_le 2 hh0).trans hhD
  omega

theorem nilpotent_binomial_divisible {R : Type*} [CommRing R]
    (N D d : ℕ) (z : R) (hnil : z ^ (D + 1) = 0)
    (hcoef : ∀ h, 1 ≤ h → h ≤ D → d ∣ Nat.choose N h) :
    ∃ w : R, (1 + z) ^ N - 1 = (d : R) * w := by
  have hexp :
      (1 + z) ^ N - 1 =
        ∑ i ∈ Finset.range N, z ^ (i + 1) * (Nat.choose N (i + 1) : R) := by
    rw [add_comm 1 z, add_pow, Finset.sum_range_succ']
    simp only [one_pow, mul_one, pow_zero, Nat.choose_zero_right,
      Nat.cast_one, add_sub_cancel_right]
  change (d : R) ∣ (1 + z) ^ N - 1
  rw [hexp]
  apply Finset.dvd_sum
  intro i hi
  by_cases hiD : i + 1 ≤ D
  · obtain ⟨k, hk⟩ := hcoef (i + 1) (by omega) hiD
    have hc : (Nat.choose N (i + 1) : R) = (d : R) * (k : R) := by
      simpa only [Nat.cast_mul] using congrArg (fun n : ℕ => (n : R)) hk
    refine ⟨z ^ (i + 1) * (k : R), ?_⟩
    rw [hc]
    ring
  · have hz : z ^ (i + 1) = 0 := pow_eq_zero_of_le (by omega) hnil
    rw [hz, zero_mul]
    exact dvd_zero _

theorem dyadic_nilpotent_divisible {R : Type*} [CommRing R]
    (j D : ℕ) (z : R) (hD : 0 < D) (hDj : D < 2 ^ j)
    (hnil : z ^ (D + 1) = 0) :
    ∃ w : R, (1 + z) ^ (2 ^ j) - 1 = (2 ^ (j - Nat.log 2 D) : ℕ) * w := by
  exact nilpotent_binomial_divisible (2 ^ j) D (2 ^ (j - Nat.log 2 D)) z hnil
    (fun h hh hhD => dyadic_choose_divisible j D h hD hDj hh hhD)

theorem dyadic_not_dvd_int (n : ℤ) (hn : n ≠ 0) (e : ℕ)
    (he : n.natAbs.factorization 2 < e) :
    ¬ (2 : ℤ) ^ e ∣ n := by
  intro hd
  have hdN : 2 ^ e ∣ n.natAbs := by
    apply Int.natCast_dvd.mp
    simpa only [Nat.cast_pow, Nat.cast_ofNat] using hd
  have hle :=
    (Nat.prime_two.pow_dvd_iff_le_factorization (Int.natAbs_ne_zero.mpr hn)).mp hdN
  omega

theorem pairing_obstruction {A : Type*} [AddCommGroup A]
    (f : A →+ ℤ) (x y : A) (d n : ℤ)
    (hx : x = d • y) (hnd : ¬ d ∣ n) :
    f x ≠ n := by
  intro hf
  apply hnd
  refine ⟨f y, ?_⟩
  calc
    n = f x := hf.symm
    _ = f (d • y) := by rw [hx]
    _ = d * f y := by simp [zsmul_eq_mul]

theorem endpoint_pairing_impossible {A : Type*} [AddCommGroup A]
    (f : A →+ ℤ) (x y : A) (n : ℤ) (j D : ℕ)
    (hn : n ≠ 0) (ht : Nat.log 2 D + n.natAbs.factorization 2 < j)
    (hx : x = (2 : ℤ) ^ (j - Nat.log 2 D) • y) :
    f x ≠ n := by
  apply pairing_obstruction f x y ((2 : ℤ) ^ (j - Nat.log 2 D)) n hx
  apply dyadic_not_dvd_int n hn
  omega

end CongruencePersistence
