import Mathlib

namespace TaperedHermite

open Finset

def loss : ℕ → ℕ → ℕ
  | 0, _ => 0
  | n + 1, k => 2 * loss n k + (n + 1) * min (n + 1) k

theorem loss_saturated (n k : ℕ) (hk : n ≤ k) :
    loss n k = loss n n := by
  induction n generalizing k with
  | zero => rfl
  | succ n ih =>
      simp only [loss]
      rw [ih k (by omega), ih (n + 1) (by omega)]
      simp [min_eq_left hk]

theorem loss_diagonal (n : ℕ) :
    loss n n + n ^ 2 + 4 * n + 6 = 6 * 2 ^ n := by
  induction n with
  | zero => norm_num [loss]
  | succ n ih =>
      simp only [loss, min_self, pow_succ]
      rw [loss_saturated n (n + 1) (by omega)]
      nlinarith

theorem loss_closed_add (k r : ℕ) :
    loss (k + r) k + (2 * k + 6) * 2 ^ r + k * (k + r + 2)
      = 6 * 2 ^ (k + r) := by
  induction r with
  | zero =>
      simpa only [add_zero, pow_zero, mul_one] using
        (show loss k k + (2 * k + 6) + k * (k + 2) = 6 * 2 ^ k by
          nlinarith [loss_diagonal k])
  | succ r ih =>
      rw [show k + (r + 1) = (k + r) + 1 by omega, loss,
        min_eq_right (by omega : k ≤ k + r + 1)]
      simp only [pow_succ]
      nlinarith

theorem loss_closed (n k : ℕ) (hk : k ≤ n) :
    loss n k + (2 * k + 6) * 2 ^ (n - k) + k * (n + 2)
      = 6 * 2 ^ n := by
  simpa only [Nat.add_sub_of_le hk] using loss_closed_add k (n - k)

theorem loss_le (n k : ℕ) : loss n k ≤ 6 * 2 ^ n := by
  by_cases hk : k ≤ n
  · have := loss_closed n k hk
    omega
  · rw [loss_saturated n k (by omega)]
    have := loss_diagonal n
    omega

theorem loss_sum (n k : ℕ) :
    loss n k = ∑ j ∈ range (n + 1), j * min j k * 2 ^ (n - j) := by
  induction n with
  | zero => simp [loss]
  | succ n ih =>
      rw [sum_range_succ, loss, ih]
      have hs :
          (∑ j ∈ range (n + 1), j * min j k * 2 ^ (n + 1 - j))
            = 2 * ∑ j ∈ range (n + 1), j * min j k * 2 ^ (n - j) := by
        rw [mul_sum]
        apply sum_congr rfl
        intro j hj
        have hjn : j ≤ n := by simpa using mem_range.mp hj
        rw [show n + 1 - j = (n - j) + 1 by omega, pow_succ]
        ring
      simpa only [Nat.sub_self, pow_zero, mul_one] using congrArg
        (fun z => z + (n + 1) * min (n + 1) k) hs.symm

def ceilThree (M u : ℕ) : ℕ := (3 * M + u - 1) / u

theorem multiplicity_bound (M u : ℕ) (hu : 1 ≤ u) (hM : u ≤ M) :
    ceilThree M u * u ≤ 4 * M := by
  have hd := Nat.div_mul_le_self (3 * M + u - 1) u
  dsimp [ceilThree]
  omega

local instance : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩

def bounded (b : ℤ) (x : ℚ) : Prop := padicNorm 2 x ≤ (2 : ℚ) ^ b

theorem bounded_zero (b : ℤ) : bounded b 0 := by
  simp only [bounded, padicNorm.zero]
  positivity

theorem bounded_mono {b c : ℤ} {x : ℚ}
    (hx : bounded b x) (hbc : b ≤ c) : bounded c x := by
  exact hx.trans (zpow_le_zpow_right₀ (by norm_num : (1 : ℚ) ≤ 2) hbc)

theorem bounded_mul {b c : ℤ} {x y : ℚ}
    (hx : bounded b x) (hy : bounded c y) : bounded (b + c) (x * y) := by
  unfold bounded at *
  rw [padicNorm.mul, zpow_add₀ (by norm_num : (2 : ℚ) ≠ 0)]
  exact mul_le_mul hx hy (padicNorm.nonneg y) (by positivity)

theorem bounded_pow {b : ℤ} {x : ℚ} (hx : bounded b x) (j : ℕ) :
    bounded ((j : ℤ) * b) (x ^ j) := by
  induction j with
  | zero => norm_num [bounded, padicNorm.one]
  | succ j ih =>
      have h := bounded_mul ih hx
      simpa only [pow_succ, Nat.cast_add, Nat.cast_one, add_mul, one_mul] using h

theorem bounded_sum {ι : Type*} (s : Finset ι) {b : ℤ} (f : ι → ℚ)
    (hf : ∀ j ∈ s, bounded b (f j)) : bounded b (∑ j ∈ s, f j) := by
  exact padicNorm.sum_le' hf (by positivity)

theorem integral_inverse (e b : ℕ → ℚ)
    (he : ∀ j, bounded 0 (e j))
    (hb0 : b 0 = 1)
    (hb : ∀ n, b (n + 1) = -∑ j ∈ range (n + 1), e (n + 1 - j) * b j) :
    ∀ j, bounded 0 (b j) := by
  intro j
  induction j using Nat.strong_induction_on with
  | h j ih =>
      cases j with
      | zero => norm_num [hb0, bounded, padicNorm.one]
      | succ n =>
          rw [hb]
          simp only [bounded, padicNorm.neg]
          apply bounded_sum
          intro j hj
          simpa using bounded_mul (he (n + 1 - j)) (ih j (mem_range.mp hj))

def node (E x : ℚ) (q : ℕ) (b f : ℕ → ℚ) : ℚ :=
  E * ∑ j ∈ range q, (∑ r ∈ range (j + 1), f r * b (j - r)) * x ^ j

theorem node_linear (E x : ℚ) (q : ℕ) (b f g : ℕ → ℚ) :
    node E x q b f - node E x q b g =
      node E x q b (fun r => f r - g r) := by
  unfold node
  rw [← mul_sub, ← sum_sub_distrib]
  congr 1
  apply sum_congr rfl
  intro j _
  rw [← sub_mul, ← sum_sub_distrib]
  congr 1
  apply sum_congr rfl
  intro r _
  ring

theorem node_precision_exact
    (E x : ℚ) (q p s v : ℕ) (b f : ℕ → ℚ)
    (hE : bounded (s : ℤ) E)
    (hx : bounded (v : ℤ) x)
    (hb : ∀ j, bounded 0 (b j))
    (hf : ∀ r < q, bounded (-(p + s + (q - 1) * v : ℕ) : ℤ) (f r)) :
    bounded (-(p : ℤ)) (node E x q b f) := by
  unfold node
  rw [mul_sum]
  apply bounded_sum
  intro j hj
  have hjq : j < q := mem_range.mp hj
  have hc : bounded (-(p + s + (q - 1) * v : ℕ) : ℤ)
      (∑ r ∈ range (j + 1), f r * b (j - r)) := by
    apply bounded_sum
    intro r hr
    have hrq : r < q := by have := mem_range.mp hr; omega
    simpa using bounded_mul (hf r hrq) (hb (j - r))
  have h := bounded_mul hE (bounded_mul hc (bounded_pow hx j))
  apply bounded_mono h
  have hjle : j ≤ q - 1 := by omega
  have hv : (j : ℤ) * (v : ℤ) ≤ ((q - 1 : ℕ) : ℤ) * (v : ℤ) :=
    mul_le_mul_of_nonneg_right (by exact_mod_cast hjle) (by positivity)
  push_cast
  omega

theorem node_precision_paper
    (E x : ℚ) (q p h n k M a : ℕ) (b f : ℕ → ℚ)
    (hq : q ≤ 4 * M)
    (hE : bounded (h * loss n k : ℕ) E)
    (hx : bounded (a + 1 : ℕ) x)
    (hb : ∀ j, bounded 0 (b j))
    (hf : ∀ r < q,
      bounded (-(p + 8 * h * 2 ^ n + 8 * M * (a + 1) : ℕ) : ℤ) (f r)) :
    bounded (-(p : ℤ)) (node E x q b f) := by
  apply node_precision_exact E x q p (h * loss n k) (a + 1) b f hE hx hb
  intro r hr
  apply bounded_mono (hf r hr)
  have hl := Nat.mul_le_mul_left h (loss_le n k)
  have hj : q - 1 ≤ 4 * M := by omega
  have hjv := Nat.mul_le_mul_right (a + 1) hj
  have hp :
      p + h * loss n k + (q - 1) * (a + 1)
        ≤ p + 8 * h * 2 ^ n + 8 * M * (a + 1) := by
    nlinarith
  exact neg_le_neg (Int.ofNat_le.mpr hp)

theorem coordinatewise_precision
    {ι κ : Type*} (nodes : Finset ι) (q n k : ι → ℕ)
    (p h M a : ℕ) (E x : ι → ℚ) (b : ι → ℕ → ℚ)
    (f : ι → ℕ → κ → ℚ)
    (hq : ∀ t ∈ nodes, q t ≤ 4 * M)
    (hE : ∀ t ∈ nodes, bounded (h * loss (n t) (k t) : ℕ) (E t))
    (hx : ∀ t ∈ nodes, bounded (a + 1 : ℕ) (x t))
    (hb : ∀ t ∈ nodes, ∀ j, bounded 0 (b t j))
    (hf : ∀ t ∈ nodes, ∀ r < q t, ∀ c,
      bounded (-(p + 8 * h * 2 ^ n t + 8 * M * (a + 1) : ℕ) : ℤ) (f t r c)) :
    ∀ c, bounded (-(p : ℤ))
      (∑ t ∈ nodes, node (E t) (x t) (q t) (b t) (fun r => f t r c)) := by
  intro c
  apply bounded_sum
  intro t ht
  exact node_precision_paper (E t) (x t) (q t) p h (n t) (k t) M a
    (b t) (fun r => f t r c) (hq t ht) (hE t ht) (hx t ht) (hb t ht)
    (fun r hr => hf t ht r hr c)

end TaperedHermite
