import Mathlib

open scoped BigOperators
open Finset

namespace PointCenter

noncomputable section

theorem power_growth (d : ℕ) {b h : ℝ} (hb : 0 ≤ b) (hh : 0 ≤ h) :
    b ^ (d + 1) + ((d : ℝ) + 1) * h * b ^ d ≤ (b + h) ^ (d + 1) := by
  have hp := pow_add_mul_le_add_pow hb (by linarith : 0 ≤ 2 * b + h) (d + 1)
  simpa only [Nat.add_sub_cancel, Nat.cast_add, Nat.cast_one,
    mul_assoc, mul_left_comm, mul_comm] using hp

theorem weighted_growth {α : Type*} (S : Finset α) (d : ℕ)
    (w b c : α → ℝ) {h : ℝ}
    (hw : ∀ i ∈ S, 0 ≤ w i) (hb : ∀ i ∈ S, 0 ≤ b i)
    (hh : 0 ≤ h) (hc : ∀ i ∈ S, b i + h ≤ c i) :
    (∑ i ∈ S, w i * b i ^ (d + 1)) +
        ((d : ℝ) + 1) * h * (∑ i ∈ S, w i * b i ^ d) ≤
      ∑ i ∈ S, w i * c i ^ (d + 1) := by
  have hs := Finset.sum_le_sum (s := S) (fun i hi =>
    mul_le_mul_of_nonneg_left
      ((power_growth d (hb i hi) hh).trans
        (pow_le_pow_left₀ (add_nonneg (hb i hi) hh) (hc i hi) (d + 1)))
      (hw i hi))
  simpa only [mul_add, Finset.sum_add_distrib, Finset.mul_sum,
    mul_assoc, mul_left_comm, mul_comm] using hs

theorem growth_telescope (B q : ℕ → ℝ) (c : ℝ) (l : ℕ) :
    (∀ i < l, B i + c * q i ≤ B (i + 1)) →
      B 0 + c * (∑ i ∈ Finset.range l, q i) ≤ B l := by
  induction l with
  | zero =>
      intro _
      simp
  | succ l ih =>
      intro hs
      have hp := ih (fun i hi => hs i (Nat.lt_succ_of_lt hi))
      have hn := hs l (Nat.lt_succ_self l)
      simp only [Finset.sum_range_succ]
      nlinarith

theorem moment_telescope (B q : ℕ → ℝ) (l : ℕ) {d U Q : ℝ}
    (hd : 0 < d) (hB : 0 ≤ B 0)
    (hs : ∀ i < l, B i + (d + 1) * q i ≤ B (i + 1))
    (hM : d / (d + 1) * B l ≤ U + d / 2 * Q) :
    d * (∑ i ∈ Finset.range l, q i) ≤ U + d / 2 * Q := by
  have hd1 : 0 < d + 1 := by linarith
  have hg := growth_telescope B q (d + 1) l hs
  have hg' : (d + 1) * (∑ i ∈ Finset.range l, q i) ≤ B l := by
    linarith
  have hm := mul_le_mul_of_nonneg_left hg'
    (div_nonneg hd.le hd1.le)
  have he :
      d / (d + 1) * ((d + 1) * (∑ i ∈ Finset.range l, q i)) =
        d * (∑ i ∈ Finset.range l, q i) := by
    field_simp
  rw [he] at hm
  exact hm.trans hM

def powerSum (n l : ℕ) : ℝ :=
  ∑ i ∈ Finset.range l, (i : ℝ) ^ n

def powerRiemann (n l : ℕ) : ℝ :=
  1 / (l : ℝ) * (∑ i ∈ Finset.range l, ((i : ℝ) / (l : ℝ)) ^ n)

def expRiemann (n : ℕ) (u : ℝ) (l : ℕ) : ℝ :=
  1 / (l : ℝ) *
    (∑ i ∈ Finset.range l,
      ((i : ℝ) / (l : ℝ)) ^ n *
        Real.exp ((1 - (i : ℝ) / (l : ℝ)) * u))

theorem power_sum_bounds (n l : ℕ) :
    (l : ℝ) ^ (n + 1) / ((n : ℝ) + 1) - (l : ℝ) ^ n ≤ powerSum n l ∧
      powerSum n l ≤ (l : ℝ) ^ (n + 1) / ((n : ℝ) + 1) := by
  have hf : MonotoneOn (fun x : ℝ => x ^ n) (Set.Icc 0 (0 + (l : ℝ))) := by
    intro x hx y _ hxy
    exact pow_le_pow_left₀ hx.1 hxy n
  have hu : powerSum n l ≤ (l : ℝ) ^ (n + 1) / ((n : ℝ) + 1) := by
    simpa [powerSum] using hf.sum_le_integral
  have hr :
      (l : ℝ) ^ (n + 1) / ((n : ℝ) + 1) ≤
        ∑ i ∈ Finset.range l, ((i + 1 : ℕ) : ℝ) ^ n := by
    simpa using hf.integral_le_sum
  have hshift :
      (∑ i ∈ Finset.range l, ((i + 1 : ℕ) : ℝ) ^ n) =
        powerSum n l + (l : ℝ) ^ n - (0 : ℝ) ^ n := by
    have h₁ := Finset.sum_range_succ (f := fun i : ℕ => (i : ℝ) ^ n) l
    have h₂ := Finset.sum_range_succ' (f := fun i : ℕ => (i : ℝ) ^ n) l
    simp only [Nat.cast_zero] at h₂
    unfold powerSum
    linarith
  rw [hshift] at hr
  have hz : 0 ≤ (0 : ℝ) ^ n := pow_nonneg (by norm_num) n
  exact ⟨by linarith, hu⟩

theorem power_riemann_eq (n l : ℕ) (hl : 0 < (l : ℝ)) :
    powerRiemann n l = powerSum n l / (l : ℝ) ^ (n + 1) := by
  unfold powerRiemann powerSum
  simp_rw [div_pow]
  rw [← Finset.sum_div, pow_succ]
  field_simp

theorem power_riemann_bounds (n l : ℕ) (hl : 0 < (l : ℝ)) :
    1 / ((n : ℝ) + 1) - 1 / (l : ℝ) ≤ powerRiemann n l ∧
      powerRiemann n l ≤ 1 / ((n : ℝ) + 1) := by
  have hn : 0 < (n : ℝ) + 1 := by positivity
  have hp : 0 < (l : ℝ) ^ (n + 1) := pow_pos hl _
  have hb := power_sum_bounds n l
  rw [power_riemann_eq n l hl]
  constructor
  · apply (le_div_iff₀ hp).mpr
    have he :
        (1 / ((n : ℝ) + 1) - 1 / (l : ℝ)) * (l : ℝ) ^ (n + 1) =
          (l : ℝ) ^ (n + 1) / ((n : ℝ) + 1) - (l : ℝ) ^ n := by
      rw [pow_succ]
      field_simp
    rw [he]
    exact hb.1
  · apply (div_le_iff₀ hp).mpr
    simpa [div_eq_mul_inv, mul_comm] using hb.2

theorem exp_partition_lower (n l : ℕ) {u : ℝ}
    (hl : 0 < (l : ℝ)) (hu : 0 ≤ u) :
    1 / ((n : ℝ) + 1) + u / (((n : ℝ) + 1) * ((n : ℝ) + 2)) -
        (1 + u) / (l : ℝ) ≤ expRiemann n u l := by
  let P : ℝ := 1 / (l : ℝ) *
    (∑ i ∈ Finset.range l,
      ((i : ℝ) / (l : ℝ)) ^ n * (1 + (1 - (i : ℝ) / (l : ℝ)) * u))
  have hP : P ≤ expRiemann n u l := by
    apply mul_le_mul_of_nonneg_left _ (one_div_pos.mpr hl).le
    apply Finset.sum_le_sum
    intro i _
    have hx : 0 ≤ (i : ℝ) / (l : ℝ) :=
      div_nonneg (Nat.cast_nonneg i) hl.le
    apply mul_le_mul_of_nonneg_left _ (pow_nonneg hx n)
    simpa [add_comm] using Real.add_one_le_exp ((1 - (i : ℝ) / (l : ℝ)) * u)
  have hPeq : P = (1 + u) * powerRiemann n l - u * powerRiemann (n + 1) l := by
    dsimp [P, powerRiemann]
    simp only [Finset.mul_sum, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [pow_succ]
    ring
  have hn := (power_riemann_bounds n l hl).1
  have hn' : powerRiemann (n + 1) l ≤ 1 / ((n : ℝ) + 2) := by
    have htwo : (1 : ℝ) + 1 = 2 := by norm_num
    simpa only [Nat.cast_add, Nat.cast_one, add_assoc, htwo] using
      (power_riemann_bounds (n + 1) l hl).2
  have hleft := mul_le_mul_of_nonneg_left hn (by linarith : 0 ≤ 1 + u)
  have hright := mul_le_mul_of_nonneg_left hn' hu
  have hn1 : 0 < (n : ℝ) + 1 := by positivity
  have hn2 : 0 < (n : ℝ) + 2 := by positivity
  calc
    1 / ((n : ℝ) + 1) + u / (((n : ℝ) + 1) * ((n : ℝ) + 2)) -
        (1 + u) / (l : ℝ) =
      (1 + u) * (1 / ((n : ℝ) + 1) - 1 / (l : ℝ)) -
        u * (1 / ((n : ℝ) + 2)) := by
          field_simp
          ring
    _ ≤ (1 + u) * powerRiemann n l - u * powerRiemann (n + 1) l :=
      sub_le_sub hleft hright
    _ = P := hPeq.symm
    _ ≤ expRiemann n u l := hP

theorem remove_vanishing_error (A B C : ℝ)
    (h : ∀ l : ℕ, 2 ≤ l → A - C / (l : ℝ) ≤ B) : A ≤ B := by
  by_contra hn
  have hg : 0 < A - B := sub_pos.mpr (lt_of_not_ge hn)
  obtain ⟨l, hl⟩ := exists_nat_gt (max (2 : ℝ) (C / (A - B)))
  have hl2 : (2 : ℝ) < (l : ℝ) := lt_of_le_of_lt (le_max_left _ _) hl
  have hl0 : 0 < (l : ℝ) := by linarith
  have hln : 2 ≤ l := by exact_mod_cast hl2.le
  have hc : C < (l : ℝ) * (A - B) :=
    (div_lt_iff₀ hg).mp (lt_of_le_of_lt (le_max_right _ _) hl)
  have hc' : C / (l : ℝ) < A - B := (div_lt_iff₀ hl0).mpr (by nlinarith)
  have hb := h l hln
  linarith

theorem numeric_obstruction {N d t a sigma : ℝ}
    (hN : 0 ≤ N) (hd : 0 < d) (ht : 0 < t)
    (h :
      sigma * d * (1 / (N + 1) + (a / t) / ((N + 1) * (N + 2))) ≤ d / t) :
    sigma * (t + a / (N + 2)) ≤ N + 1 := by
  have hn1 : 0 < N + 1 := by linarith
  have hn2 : 0 < N + 2 := by linarith
  have hden : 0 < t * (N + 1) * (N + 2) := by positivity
  have hm := mul_nonpos_of_nonpos_of_nonneg (sub_nonpos.mpr h) hden.le
  have he :
      (sigma * d * (1 / (N + 1) + (a / t) / ((N + 1) * (N + 2))) - d / t) *
          (t * (N + 1) * (N + 2)) =
        d * (sigma * (t * (N + 2) + a) - (N + 1) * (N + 2)) := by
    field_simp
  rw [he] at hm
  have hb : sigma * (t * (N + 2) + a) ≤ (N + 1) * (N + 2) := by
    by_contra hn
    have hh := mul_pos hd (sub_pos.mpr (lt_of_not_ge hn))
    linarith
  have hh : sigma * (t * (N + 2) + a) / (N + 2) ≤ N + 1 :=
    (div_le_iff₀ hn2).mpr hb
  convert hh using 1 <;> field_simp

theorem partition_obstruction (n : ℕ) {d t a sigma : ℝ}
    (hd : 0 < d) (ht : 0 < t) (ha : 0 ≤ a) (hsigma : 0 < sigma)
    (hpartition : ∀ l : ℕ, 2 ≤ l →
      sigma * d * expRiemann n (a / t) l ≤ d / t) :
    sigma * (t + a / ((n : ℝ) + 2)) ≤ (n : ℝ) + 1 := by
  apply numeric_obstruction (Nat.cast_nonneg n) hd ht
  apply remove_vanishing_error _ _ (sigma * d * (1 + a / t))
  intro l hl
  have hl0 : 0 < (l : ℝ) := by
    have hh : (2 : ℝ) ≤ (l : ℝ) := by exact_mod_cast hl
    linarith
  have hp := mul_le_mul_of_nonneg_left
    (exp_partition_lower n l hl0 (div_nonneg ha ht.le))
    (by positivity : 0 ≤ sigma * d)
  have hh := hp.trans (hpartition l hl)
  change sigma * d *
      (1 / ((n : ℝ) + 1) + (a / t) / (((n : ℝ) + 1) * ((n : ℝ) + 2))) -
      (sigma * d * (1 + a / t)) / (l : ℝ) ≤ d / t
  calc
    sigma * d *
        (1 / ((n : ℝ) + 1) + (a / t) / (((n : ℝ) + 1) * ((n : ℝ) + 2))) -
        (sigma * d * (1 + a / t)) / (l : ℝ) =
      sigma * d *
        (1 / ((n : ℝ) + 1) + (a / t) / (((n : ℝ) + 1) * ((n : ℝ) + 2)) -
          (1 + a / t) / (l : ℝ)) := by ring
    _ ≤ d / t := hh

theorem partition_impossibility (n : ℕ) {d t a sigma : ℝ}
    (hd : 0 < d) (ht : 0 < t) (ha : 0 ≤ a) (hsigma : 0 < sigma)
    (hstrict : (n : ℝ) + 1 < sigma * (t + a / ((n : ℝ) + 2)))
    (hpartition : ∀ l : ℕ, 2 ≤ l →
      sigma * d * expRiemann n (a / t) l ≤ d / t) : False := by
  exact (not_le_of_gt hstrict) (partition_obstruction n hd ht ha hsigma hpartition)

theorem exists_parameter (n : ℕ) {t0 a : ℝ}
    (ht0 : 0 < t0) (htop : t0 < (n : ℝ) + 1) (ha : 0 < a) :
    ∃ t : ℝ, 0 < t ∧ t0 ≤ t ∧ t < (n : ℝ) + 1 ∧
      (n : ℝ) + 1 - a / ((n : ℝ) + 2) < t := by
  have hn2 : 0 < (n : ℝ) + 2 := by positivity
  have hgap := div_pos ha hn2
  let b := max t0 ((n : ℝ) + 1 - a / ((n : ℝ) + 2))
  have hb : b < (n : ℝ) + 1 := max_lt_iff.mpr ⟨htop, by linarith⟩
  have hb0 : t0 ≤ b := le_max_left _ _
  have hb1 : (n : ℝ) + 1 - a / ((n : ℝ) + 2) ≤ b := le_max_right _ _
  refine ⟨(b + ((n : ℝ) + 1)) / 2, ?_, ?_, ?_, ?_⟩ <;> linarith

end

end PointCenter

#print axioms PointCenter.partition_obstruction
#print axioms PointCenter.moment_telescope
