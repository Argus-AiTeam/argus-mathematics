import Mathlib

namespace RoughStep

open Polynomial

theorem rational_gap (N k : ℤ) (r : ℚ) (hN : N ≠ 0)
    (hclear : (N : ℚ) * r = k) (hsmall : |(N : ℚ) * r| < 1) :
    r = 0 := by
  rw [hclear] at hsmall
  have hk : |k| < 1 := by exact_mod_cast hsmall
  have hk0 : k = 0 := by
    have := le_abs_self k
    have := neg_abs_le k
    omega
  have hz : (N : ℚ) * r = 0 := by simpa [hk0] using hclear
  exact (mul_eq_zero.mp hz).resolve_left (by exact_mod_cast hN)

theorem integral_of_coprime_multiples (d t n k : ℤ) (r : ℚ)
    (hcop : IsCoprime d t) (hd : (d : ℚ) * r = n)
    (ht : (t : ℚ) * r = k) :
    ∃ j : ℤ, r = j := by
  rcases hcop with ⟨u, v, huv⟩
  refine ⟨u * n + v * k, ?_⟩
  have huvq : (u : ℚ) * d + (v : ℚ) * t = 1 := by exact_mod_cast huv
  calc
    r = ((u : ℚ) * d + (v : ℚ) * t) * r := by rw [huvq]; ring
    _ = (u : ℚ) * ((d : ℚ) * r) + (v : ℚ) * ((t : ℚ) * r) := by ring
    _ = ((u * n + v * k : ℤ) : ℚ) := by rw [hd, ht]; push_cast; ring

theorem linear_power_dvd_of_hasse_jets (R : ℚ[X]) (a : ℚ) (e : ℕ)
    (hjets : ∀ j < e, (hasseDeriv j R).eval a = 0) :
    (X - C a) ^ e ∣ R := by
  apply X_sub_C_pow_dvd_iff.mpr
  rw [← taylor_apply]
  apply X_pow_dvd_iff.mpr
  intro j hj
  rw [taylor_coeff]
  exact hjets j hj

theorem exact_linear_division (R : ℚ[X]) (t₀ m : ℚ) (e : ℕ)
    (hm : m ≠ 0)
    (hjets : ∀ j < e, (hasseDeriv j R).eval (-t₀ / m) = 0) :
    ∃ M : ℚ[X], R = (C t₀ + C m * X) ^ e * M := by
  obtain ⟨Q, hQ⟩ := linear_power_dvd_of_hasse_jets R (-t₀ / m) e hjets
  have hma : m * (-t₀ / m) = -t₀ := by field_simp
  have hlinear : C t₀ + C m * X = C m * (X - C (-t₀ / m)) := by
    rw [mul_sub, ← C_mul, hma, C_neg]
    ring
  have hunit : C m * C m⁻¹ = (1 : ℚ[X]) := by
    rw [← C_mul]
    simp [hm]
  refine ⟨C m⁻¹ ^ e * Q, ?_⟩
  calc
    R = (X - C (-t₀ / m)) ^ e * Q := hQ
    _ = (C m * C m⁻¹) ^ e * ((X - C (-t₀ / m)) ^ e * Q) := by
      rw [hunit]
      simp
    _ = (C m * (X - C (-t₀ / m))) ^ e * (C m⁻¹ ^ e * Q) := by
      simp only [mul_pow]
      ring
    _ = (C t₀ + C m * X) ^ e * (C m⁻¹ ^ e * Q) := by rw [hlinear]

theorem residue_class_exists (K t u b : ℤ) (hcop : IsCoprime K t) :
    ∃ a : ℤ, t ∣ u + K * a - b := by
  rcases hcop with ⟨p, q, hpq⟩
  refine ⟨p * (b - u), -q * (b - u), ?_⟩
  linear_combination (b - u) * hpq

theorem residue_reparametrization (K t u b a y : ℤ)
    (hcop : IsCoprime K t) (ha : t ∣ u + K * a - b) :
    t ∣ u + K * y - b ↔ t ∣ y - a := by
  rcases hcop with ⟨p, q, hpq⟩
  rcases ha with ⟨h, hh⟩
  constructor
  · rintro ⟨k, hk⟩
    refine ⟨p * (k - h) + q * (y - a), ?_⟩
    linear_combination -(y - a) * hpq + p * hk - p * hh
  · rintro ⟨k, hk⟩
    refine ⟨h + K * k, ?_⟩
    linear_combination hh + K * hk

theorem descent_exponent_invariant (n s D : ℕ) :
    2 * (s * D) * s ^ n + 2 = 2 * D * s ^ (n + 1) + 2 := by
  rw [pow_succ]
  ring

section Groups

variable {G A : Type*} [Group G] [Group A]

theorem kernel_membership (χ : G →* A) (v : A →* G)
    (hsection : ∀ u, χ (v u) = u) (a m : A) (p : G)
    (hχ : χ p = a * m) :
    χ (v a⁻¹ * p * v m⁻¹) = 1 := by
  simp [hsection, hχ, mul_assoc]

theorem kernel_factorization (v : A →* G) (a m : A) (p : G) :
    v a * (v a⁻¹ * p * v m⁻¹) * v m = p := by
  simp [mul_assoc]

theorem periodic_right_factor (Γ : Subgroup G) (g : G) (K j k : ℤ)
    (hK : g ^ K ∈ Γ) :
    ∃ γ ∈ Γ, g ^ (j + K * k) = g ^ j * γ := by
  refine ⟨(g ^ K) ^ k, Γ.zpow_mem hK k, ?_⟩
  rw [zpow_add, zpow_mul]

end Groups

end RoughStep
