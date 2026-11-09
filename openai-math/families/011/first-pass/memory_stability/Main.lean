import Mathlib

open scoped BigOperators

namespace MemoryStability

theorem choice_sum_equivariant
    {X Y I : Type*} [Fintype I]
    (g : X → X) (e : I ≃ I)
    (w phi : X → I → ℂ) (target : X → I → Y) (f : Y → ℂ)
    (hw : ∀ x c, w (g x) (e c) = w x c)
    (hp : ∀ x c, phi (g x) (e c) = phi x c)
    (hf : ∀ x c, f (target (g x) (e c)) = f (target x c)) (x : X) :
    (∑ c, w (g x) c * phi (g x) c * f (target (g x) c)) =
      ∑ c, w x c * phi x c * f (target x c) := by
  calc
    _ = ∑ c, w (g x) (e c) * phi (g x) (e c) *
        f (target (g x) (e c)) := (e.sum_comp _).symm
    _ = _ := by
      apply Finset.sum_congr rfl
      intro c _
      rw [hw, hp, hf]

def reindex {n : ℕ} {Z : Type*} (s : Equiv.Perm (Fin n)) :
    (Fin n → Z) ≃ (Fin n → Z) where
  toFun x i := x (s i)
  invFun x i := x (s.symm i)
  left_inv x := by funext i; simp
  right_inv x := by funext i; simp

def density {n : ℕ} {Z : Type*} (nu : Z → ℂ) (x : Fin n → Z) : ℂ :=
  ∏ i, nu (x i)

theorem density_reindex {n : ℕ} {Z : Type*}
    (nu : Z → ℂ) (s : Equiv.Perm (Fin n)) (x : Fin n → Z) :
    density nu (reindex s x) = density nu x := by
  exact Equiv.prod_comp s (fun i => nu (x i))

noncomputable def batchAverage {n : ℕ} {Z : Type*} (phi : (Fin n → Z) → ℂ)
    (x : Fin n → Z) : ℂ :=
  (Fintype.card (Equiv.Perm (Fin n)) : ℂ)⁻¹ *
    ∑ s : Equiv.Perm (Fin n), phi (reindex s x)

theorem batch_integral_reindex {n : ℕ} {Z : Type*} [Fintype Z]
    (nu : Z → ℂ) (phi f : (Fin n → Z) → ℂ)
    (hf : ∀ s x, f (reindex s x) = f x) (s : Equiv.Perm (Fin n)) :
    (∑ x, density nu x * phi (reindex s x) * f x) =
      ∑ x, density nu x * phi x * f x := by
  calc
    _ = ∑ x, density nu (reindex s x) * phi (reindex s x) *
        f (reindex s x) := by
      apply Finset.sum_congr rfl
      intro x _
      rw [density_reindex, hf]
    _ = _ := Equiv.sum_comp (reindex s) (fun x => density nu x * phi x * f x)

theorem birth_batch_averaging {n : ℕ} {Z : Type*} [Fintype Z]
    (nu : Z → ℂ) (phi f : (Fin n → Z) → ℂ)
    (hf : ∀ s x, f (reindex s x) = f x) :
    (∑ x, density nu x * batchAverage phi x * f x) =
      ∑ x, density nu x * phi x * f x := by
  have hc : (Fintype.card (Equiv.Perm (Fin n)) : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  calc
    _ = (Fintype.card (Equiv.Perm (Fin n)) : ℂ)⁻¹ *
        ∑ s : Equiv.Perm (Fin n),
          ∑ x, density nu x * phi (reindex s x) * f x := by
      simp only [batchAverage, Finset.mul_sum, Finset.sum_mul]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro s _
      apply Finset.sum_congr rfl
      intro x _
      ring
    _ = _ := by
      simp_rw [batch_integral_reindex nu phi f hf]
      simp [hc, nsmul_eq_mul, mul_assoc]

theorem bounded_average {I : Type*} [Fintype I] [Nonempty I]
    (phi : I → ℂ) (hp : ∀ i, ‖phi i‖ ≤ 1) :
    ‖(Fintype.card I : ℂ)⁻¹ * ∑ i, phi i‖ ≤ 1 := by
  have hc : 0 < (Fintype.card I : ℝ) := by
    exact_mod_cast Fintype.card_pos
  have hsum : ‖∑ i, phi i‖ ≤ (Fintype.card I : ℝ) := by
    calc
      _ ≤ ∑ i, ‖phi i‖ := norm_sum_le _ _
      _ ≤ ∑ _i : I, (1 : ℝ) := Finset.sum_le_sum (fun i _ => hp i)
      _ = _ := by simp
  rw [norm_mul, norm_inv, Complex.norm_natCast]
  calc
    _ ≤ (Fintype.card I : ℝ)⁻¹ * (Fintype.card I : ℝ) :=
      mul_le_mul_of_nonneg_left hsum (inv_nonneg.mpr hc.le)
    _ = 1 := inv_mul_cancel₀ hc.ne'

theorem batchAverage_bounded {n : ℕ} {Z : Type*}
    (phi : (Fin n → Z) → ℂ) (hp : ∀ x, ‖phi x‖ ≤ 1) (x : Fin n → Z) :
    ‖batchAverage phi x‖ ≤ 1 :=
  bounded_average (fun s : Equiv.Perm (Fin n) => phi (reindex s x))
    (fun s => hp (reindex s x))

theorem ghost_factorial {K : Type*} [Field K] [CharZero K] (k t : ℕ) :
    ((k + t).choose t : K) / (Nat.factorial (k + t) : K) =
      1 / ((Nat.factorial k : K) * (Nat.factorial t : K)) := by
  have hk : (Nat.factorial k : K) ≠ 0 := by exact_mod_cast Nat.factorial_ne_zero k
  have ht : (Nat.factorial t : K) ≠ 0 := by exact_mod_cast Nat.factorial_ne_zero t
  have hkt : (Nat.factorial (k + t) : K) ≠ 0 := by
    exact_mod_cast Nat.factorial_ne_zero (k + t)
  apply (div_eq_div_iff hkt (mul_ne_zero hk ht)).2
  have h : ((k + t).choose t : K) * (Nat.factorial k : K) *
      (Nat.factorial t : K) = (Nat.factorial (k + t) : K) := by
    exact_mod_cast Nat.add_choose_mul_factorial_mul_factorial k t
  simpa [mul_assoc] using h

theorem ghost_joint_swap {K : Type*} [Field K] [CharZero K]
    (k t b : ℕ) (nu : K) :
    (nu ^ (k + t) / (Nat.factorial (k + t) : K)) *
        ((k + t).choose t : K) * (nu ^ b / (Nat.factorial b : K)) =
      (nu ^ (k + b) / (Nat.factorial (k + b) : K)) *
        ((k + b).choose b : K) * (nu ^ t / (Nat.factorial t : K)) := by
  calc
    _ = nu ^ (k + t) *
        (((k + t).choose t : K) / (Nat.factorial (k + t) : K)) *
        (nu ^ b / (Nat.factorial b : K)) := by ring
    _ = nu ^ (k + t) *
        (1 / ((Nat.factorial k : K) * (Nat.factorial t : K))) *
        (nu ^ b / (Nat.factorial b : K)) := by rw [ghost_factorial]
    _ = nu ^ (k + b) *
        (1 / ((Nat.factorial k : K) * (Nat.factorial b : K))) *
        (nu ^ t / (Nat.factorial t : K)) := by
      simp only [pow_add, div_eq_mul_inv, mul_inv_rev]
      ring
    _ = _ := by rw [← ghost_factorial]; ring

theorem edge_factorial {K : Type*} [Field K] [CharZero K] (k a : ℕ) :
    ((k + a).descFactorial a : K) / (Nat.factorial (k + a) : K) =
      1 / (Nat.factorial k : K) := by
  have hk : (Nat.factorial k : K) ≠ 0 := by exact_mod_cast Nat.factorial_ne_zero k
  have hka : (Nat.factorial (k + a) : K) ≠ 0 := by
    exact_mod_cast Nat.factorial_ne_zero (k + a)
  apply (div_eq_div_iff hka hk).2
  have hnat : Nat.factorial k * (k + a).descFactorial a =
      Nat.factorial (k + a) := by
    simpa using Nat.factorial_mul_descFactorial (Nat.le_add_left a k)
  have h : (Nat.factorial k : K) * ((k + a).descFactorial a : K) =
      (Nat.factorial (k + a) : K) := by exact_mod_cast hnat
  simpa [mul_comm] using h

theorem fresh_block_atom_bound {P : Type*} [Fintype P]
    (nu : P → ℝ) (delta : ℝ)
    (hn : ∀ p, 0 ≤ nu p) (hmax : ∀ p, nu p ≤ delta) (r : ℕ) :
    (∑ p, nu p ^ (r + 1)) ≤ (∑ p, nu p) * delta ^ r := by
  calc
    _ ≤ ∑ p, nu p * delta ^ r := by
      apply Finset.sum_le_sum
      intro p _
      calc
        _ = nu p * nu p ^ r := by rw [pow_succ]; ring
        _ ≤ _ := mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (hn p) (hmax p) r) (hn p)
    _ = _ := by rw [Finset.sum_mul]

theorem touched_le_twice_rank {I : Type*} (blocks : Finset I) (size : I → ℕ)
    (hsize : ∀ b ∈ blocks, 2 ≤ size b) :
    (∑ b ∈ blocks, size b) ≤ 2 * ∑ b ∈ blocks, (size b - 1) := by
  calc
    _ ≤ ∑ b ∈ blocks, 2 * (size b - 1) := by
      apply Finset.sum_le_sum
      intro b hb
      have h := hsize b hb
      omega
    _ = _ := by rw [Finset.mul_sum]

theorem rank_loss (N r affected : ℕ) (hN : affected ≤ N) (hr : affected ≤ 2 * r)
    (S K : ℝ) (hS : 0 < S) (hSK : S ≤ K) :
    S ^ (N - affected) * K ^ affected ≤
      S ^ N * (K / S) ^ min N (2 * r) := by
  have hq : 1 ≤ K / S := (le_div_iff₀ hS).2 (by simpa using hSK)
  have hK : S * (K / S) = K := by field_simp
  calc
    _ = S ^ (N - affected) * (S * (K / S)) ^ affected := by rw [hK]
    _ = (S ^ (N - affected) * S ^ affected) * (K / S) ^ affected := by
      rw [mul_pow]
      ring
    _ = S ^ N * (K / S) ^ affected := by
      rw [← pow_add, Nat.sub_add_cancel hN]
    _ ≤ _ := mul_le_mul_of_nonneg_left
      (pow_le_pow_right₀ hq (le_min hN hr)) (le_of_lt (pow_pos hS N))

end MemoryStability
