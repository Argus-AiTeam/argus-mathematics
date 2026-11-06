import Mathlib

namespace CauchyModes

open Finset

variable {R : Type*} [CommRing R]

theorem power_vanishes (p n : ℕ) (h2 : (2 : R) ^ p = 0) (hn : p ≤ n) :
    (2 : R) ^ n = 0 := by
  calc
    (2 : R) ^ n = (2 : R) ^ (p + (n - p)) := by
      rw [Nat.add_sub_of_le hn]
    _ = 0 := by rw [pow_add, h2, zero_mul]

theorem two_scaled_geometric (p : ℕ) (hp : 1 ≤ p)
    (h2 : (2 : R) ^ p = 0) (a q j v : R)
    (hv : (1 - 2 * q * j) * v = 1) :
    (2 * a) * v =
      ∑ b ∈ range (p - 1), (2 * a) * (2 * q) ^ b * j ^ b := by
  let r := 2 * q * j
  have hr : r = 2 * (q * j) := by dsimp [r]; ring
  have hz : (2 * a) * r ^ (p - 1) = 0 := by
    calc
      (2 * a) * r ^ (p - 1) =
          (2 : R) ^ ((p - 1) + 1) * (a * (q * j) ^ (p - 1)) := by
        rw [hr, mul_pow, pow_succ]
        ring
      _ = 0 := by rw [show p - 1 + 1 = p by omega, h2, zero_mul]
  have hg :
      ((2 * a) * ∑ b ∈ range (p - 1), r ^ b) * (1 - r) = 2 * a := by
    calc
      _ = (2 * a) * ((∑ b ∈ range (p - 1), r ^ b) * (1 - r)) := by ring
      _ = (2 * a) * (1 - r ^ (p - 1)) := by rw [geom_sum_mul_neg]
      _ = 2 * a := by rw [mul_sub, mul_one, hz, sub_zero]
  have he := congrArg (fun z : R => z * v) hg
  have hs : (2 * a) * v = (2 * a) * ∑ b ∈ range (p - 1), r ^ b := by
    simpa only [mul_assoc, show (1 - r) * v = 1 from hv, mul_one] using he.symm
  rw [hs, mul_sum]
  apply sum_congr rfl
  intro b _
  dsimp [r]
  rw [mul_pow]
  ring

theorem cauchy_coeff_factor (m k b : ℕ) (n v : R) :
    ((2 : R) ^ m * n * v) * ((2 : R) ^ k * v) ^ b =
      (2 : R) ^ (m + b * k) * (n * v ^ (b + 1)) := by
  rw [mul_pow, pow_add, pow_mul, pow_succ, Nat.mul_comm b k, pow_mul]
  ring

theorem cauchy_weight_bound (a i δ b : ℕ) (hδ : δ ≤ i) (hi : i < a) :
    b + 1 ≤ a + 1 - δ + b * (i + 1 - δ) := by
  have hm : 1 ≤ a + 1 - δ := by omega
  have hk : 1 ≤ i + 1 - δ := by omega
  have hb := Nat.mul_le_mul_left b hk
  omega

theorem cauchy_mode_coeff_dvd (a i δ b : ℕ) (hδ : δ ≤ i) (hi : i < a)
    (n v : R) :
    (2 : R) ^ (b + 1) ∣
      ((2 : R) ^ (a + 1 - δ) * n * v) *
        ((2 : R) ^ (i + 1 - δ) * v) ^ b := by
  rw [cauchy_coeff_factor]
  have hb := cauchy_weight_bound a i δ b hδ hi
  refine ⟨(2 : R) ^ (a + 1 - δ + b * (i + 1 - δ) - (b + 1)) *
    (n * v ^ (b + 1)), ?_⟩
  rw [← mul_assoc, ← pow_add, Nat.add_sub_of_le hb]

theorem normalized_cauchy_split (a i δ p : ℕ)
    (hδ : δ ≤ i) (hi : i < a) (hp : 1 ≤ p)
    (h2 : (2 : R) ^ p = 0) (u v : Rˣ) (n j : R)
    (hv : (v : R) = (u : R) - (2 : R) ^ (i + 1 - δ) * j) :
    (2 : R) ^ (a + 1 - δ) * n * (↑v⁻¹ : R) =
      ∑ b ∈ range (p - 1),
        ((2 : R) ^ (a + 1 - δ) * n * (↑u⁻¹ : R)) *
          ((2 : R) ^ (i + 1 - δ) * (↑u⁻¹ : R)) ^ b * j ^ b := by
  let m := a + 1 - δ
  let k := i + 1 - δ
  have hm : 1 ≤ m := by dsimp [m]; omega
  have hk : 1 ≤ k := by dsimp [k]; omega
  have hmp : (2 : R) ^ m = 2 * (2 : R) ^ (m - 1) := by
    rw [show m = (m - 1) + 1 by omega, pow_succ]
    ring
  have hkp : (2 : R) ^ k = 2 * (2 : R) ^ (k - 1) := by
    rw [show k = (k - 1) + 1 by omega, pow_succ]
    ring
  let a0 := (2 : R) ^ (m - 1) * n * (↑u⁻¹ : R)
  let q0 := (2 : R) ^ (k - 1) * (↑u⁻¹ : R)
  have hu : (↑u⁻¹ : R) * (u : R) = 1 := by simp
  have hf : (1 - 2 * q0 * j) * (u : R) = (v : R) := by
    calc
      _ = (u : R) - (2 * (2 : R) ^ (k - 1) * j) *
          ((↑u⁻¹ : R) * (u : R)) := by dsimp [q0]; ring
      _ = (u : R) - (2 : R) ^ k * j := by rw [hu, mul_one, ← hkp]
      _ = (v : R) := hv.symm
  have hgeom : (1 - 2 * q0 * j) * ((u : R) * (↑v⁻¹ : R)) = 1 := by
    rw [← mul_assoc, hf]
    simp
  have haa : 2 * a0 = (2 : R) ^ m * n * (↑u⁻¹ : R) := by
    dsimp [a0]
    rw [hmp]
    ring
  have hqq : 2 * q0 = (2 : R) ^ k * (↑u⁻¹ : R) := by
    dsimp [q0]
    rw [hkp]
    ring
  have he := two_scaled_geometric p hp h2 a0 q0 j
    ((u : R) * (↑v⁻¹ : R)) hgeom
  rw [haa, hqq] at he
  calc
    (2 : R) ^ (a + 1 - δ) * n * (↑v⁻¹ : R) =
        ((2 : R) ^ m * n * (↑u⁻¹ : R)) * ((u : R) * (↑v⁻¹ : R)) := by
      change (2 : R) ^ m * n * (↑v⁻¹ : R) = _
      calc
        _ = (2 : R) ^ m * n * ((↑u⁻¹ : R) * (u : R)) *
              (↑v⁻¹ : R) := by rw [hu, mul_one]
        _ = _ := by ring
    _ = _ := he

theorem prod_powers {σ : Type*} (s : Finset σ) (e : σ → ℕ) (x : R) :
    ∏ z ∈ s, x ^ e z = x ^ (∑ z ∈ s, e z) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert z s hz ih => rw [prod_insert hz, sum_insert hz, ih, pow_add]

def weight {σ : Type*} [Fintype σ] (w β : σ → ℕ) : ℕ :=
  ∑ z, w z * β z

theorem scaled_monomial {σ : Type*} [Fintype σ]
    (w β : σ → ℕ) (L : σ → R) :
    (∏ z, ((2 : R) ^ w z * L z) ^ β z) =
      (2 : R) ^ weight w β * ∏ z, L z ^ β z := by
  simp only [mul_pow, ← pow_mul, Finset.prod_mul_distrib, prod_powers, weight]

theorem weighted_truncation {σ ι : Type*} [Fintype σ]
    (s : Finset ι) (c : ι → R) (e : ι → σ → ℕ)
    (w : σ → ℕ) (L : σ → R) (p : ℕ) (h2 : (2 : R) ^ p = 0) :
    (∑ k ∈ s, c k * ∏ z, ((2 : R) ^ w z * L z) ^ e k z) =
      ∑ k ∈ s.filter (fun k => weight w (e k) < p),
        c k * (2 : R) ^ weight w (e k) * ∏ z, L z ^ e k z := by
  classical
  rw [sum_filter]
  apply sum_congr rfl
  intro k _
  by_cases hk : weight w (e k) < p
  · simp [hk, scaled_monomial, mul_assoc]
  · have hz := power_vanishes p (weight w (e k)) h2 (by omega)
    simp [hk, scaled_monomial, hz]

theorem polynomial_weighted_truncation {σ : Type*} [Fintype σ]
    (P : MvPolynomial σ R) (w : σ → ℕ) (L : σ → R)
    (p : ℕ) (h2 : (2 : R) ^ p = 0) :
    MvPolynomial.eval (fun z => (2 : R) ^ w z * L z) P =
      ∑ β ∈ P.support.filter (fun β => weight w (fun z => β z) < p),
        P.coeff β * (2 : R) ^ weight w (fun z => β z) *
          ∏ z, L z ^ β z := by
  rw [MvPolynomial.eval_eq']
  exact weighted_truncation P.support P.coeff (fun β z => β z) w L p h2

def affinePolynomial {σ ρ : Type*} [Fintype σ]
    (rows : Finset ρ) (localValue : ρ → R) (c : ρ → σ → R) :
    MvPolynomial σ R :=
  ∏ x ∈ rows, (MvPolynomial.C (localValue x) +
    ∑ z, MvPolynomial.C (c x z) * MvPolynomial.X z)

theorem affine_weighted_truncation {σ ρ : Type*} [Fintype σ]
    (rows : Finset ρ) (localValue : ρ → R) (c : ρ → σ → R)
    (w : σ → ℕ) (L : σ → R) (p : ℕ) (h2 : (2 : R) ^ p = 0) :
    (∏ x ∈ rows, (localValue x + ∑ z, (2 : R) ^ w z * c x z * L z)) =
      ∑ β ∈ (affinePolynomial rows localValue c).support.filter
          (fun β => weight w (fun z => β z) < p),
        (affinePolynomial rows localValue c).coeff β *
          (2 : R) ^ weight w (fun z => β z) * ∏ z, L z ^ β z := by
  simpa [affinePolynomial, mul_assoc, mul_comm, mul_left_comm] using
    polynomial_weighted_truncation (affinePolynomial rows localValue c) w L p h2

theorem group_bit_sum {G : Type*} [Fintype G]
    {B : G → Type*} [∀ g, Fintype (B g)] (f : ∀ g, B g → R) :
    (∑ bits : (g : G) → B g, ∏ g, f g (bits g)) =
      ∏ g, ∑ bits, f g bits := by
  classical
  exact (Fintype.prod_sum f).symm

theorem child_size64 (rows cols M : ℕ)
    (hr : 64 * rows ≤ 3 * M) (hc : 64 * cols ≤ 3 * M) (hM : 0 < M) :
    32 * (rows + cols) ≤ 3 * M ∧ 8 * (rows + cols) < M := by
  omega

theorem packet_degree (rows cols L Δ : ℕ)
    (hr : rows ≤ L) (hc : cols ≤ L) (hL : 2 * L ≤ Δ) :
    rows + cols ≤ Δ := by
  omega

theorem mode_multiplicity (K L M D i : ℕ)
    (hK : K * L ≤ 3 * M) (hL : L = D * 2 ^ i) :
    D * (K * 2 ^ (i + 1)) ≤ 6 * M := by
  rw [hL] at hK
  rw [pow_succ]
  nlinarith

end CauchyModes
