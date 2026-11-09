import Mathlib

namespace TangentBox

universe u v w

section RingLinear

variable {K : Type u} [CommRing K]
variable {V : Type v} [AddCommGroup V] [Module K V]

theorem cauchy_iff (P : V →ₗ[K] V) (hP : P.comp P = P) (du dv : V) :
    dv = P du ↔ P dv = dv ∧ P (du - dv) = 0 := by
  constructor
  · intro h
    subst dv
    have hh : P (P du) = P du := LinearMap.congr_fun hP du
    exact ⟨hh, by rw [map_sub, hh, sub_self]⟩
  · rintro ⟨hi, hc⟩
    have he : P du = P dv := sub_eq_zero.mp (by simpa only [map_sub] using hc)
    exact hi.symm.trans he.symm

theorem chart_covariance (P : V →ₗ[K] V) (hP : P.comp P = P)
    (du dv : V) (a b : K) (h : dv = P du) :
    P (a • du + (b - a) • dv) = b • dv := by
  have hi : P dv = dv := ((cauchy_iff P hP du dv).mp h).1
  calc
    P (a • du + (b - a) • dv) = a • dv + (b - a) • dv := by
      rw [map_add, map_smul, map_smul, ← h, hi]
    _ = b • dv := by
      rw [← add_smul]
      congr 1
      ring

end RingLinear

section Linear

variable {K : Type u} [Field K]
variable {V : Type v} [AddCommGroup V] [Module K V]

theorem complementary_killing (P Q : V →ₗ[K] V)
    (hsum : P + Q = LinearMap.id) (v : V) (a b : K)
    (ha : a ≠ 0) (hb : b ≠ 0)
    (h1 : a • P v = 0) (h2 : b • Q v = 0) : v = 0 := by
  have hp : P v = 0 := (smul_eq_zero.mp h1).resolve_left ha
  have hq : Q v = 0 := (smul_eq_zero.mp h2).resolve_left hb
  calc
    v = P v + Q v := by
      simpa using (LinearMap.congr_fun hsum v).symm
    _ = 0 := by rw [hp, hq, add_zero]

theorem exceptional_killing [CharZero K] (P Q : V →ₗ[K] V)
    (hsum : P + Q = LinearMap.id) (v : V)
    (alpha beta : ℕ) (ha : 0 < alpha) (hb : 0 < beta)
    (h k : K) (hh : h ≠ 0) (hk : k ≠ 0)
    (h1 : ((alpha : K) * h) • P v = 0)
    (h2 : ((beta : K) * k) • Q v = 0) : v = 0 := by
  apply complementary_killing P Q hsum v ((alpha : K) * h) ((beta : K) * k)
  · exact mul_ne_zero (Nat.cast_ne_zero.mpr (Nat.ne_of_gt ha)) hh
  · exact mul_ne_zero (Nat.cast_ne_zero.mpr (Nat.ne_of_gt hb)) hk
  · exact h1
  · exact h2

theorem causal_recurrence_unique [CharZero K]
    (rhs : ℕ → (ℕ → V) → V)
    (causal : ∀ n f g, (∀ j, j ≤ n → f j = g j) → rhs n f = rhs n g)
    (f g : ℕ → V) (h0 : f 0 = g 0)
    (hf : ∀ n, ((n + 1 : ℕ) : K) • f (n + 1) = rhs n f)
    (hg : ∀ n, ((n + 1 : ℕ) : K) • g (n + 1) = rhs n g) : f = g := by
  funext n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    cases n with
    | zero => exact h0
    | succ n =>
      have hr : rhs n f = rhs n g :=
        causal n f g (by
          intro j hj
          exact ih j (Nat.lt_succ_of_le hj))
      have hs : ((n + 1 : ℕ) : K) • f (n + 1) =
          ((n + 1 : ℕ) : K) • g (n + 1) :=
        (hf n).trans (hr.trans (hg n).symm)
      have hz : ((n + 1 : ℕ) : K) • (f (n + 1) - g (n + 1)) = 0 := by
        rw [smul_sub, hs, sub_self]
      exact sub_eq_zero.mp
        ((smul_eq_zero.mp hz).resolve_left
          (Nat.cast_ne_zero.mpr (Nat.succ_ne_zero n)))

noncomputable def cauchySeq [CharZero K] (x0 : V)
    (rhs : ℕ → (ℕ → V) → V) (n : ℕ) : V :=
  match n with
  | 0 => x0
  | k + 1 =>
    (((k + 1 : ℕ) : K)⁻¹) • rhs k
      (fun j => if _h : j < k + 1 then cauchySeq x0 rhs j else 0)
termination_by n
decreasing_by omega

theorem cauchySeq_recurrence [CharZero K] (x0 : V)
    (rhs : ℕ → (ℕ → V) → V)
    (causal : ∀ n f g, (∀ j, j ≤ n → f j = g j) → rhs n f = rhs n g)
    (n : ℕ) :
    ((n + 1 : ℕ) : K) • cauchySeq (K := K) x0 rhs (n + 1) =
      rhs n (cauchySeq (K := K) x0 rhs) := by
  have hc : ((n + 1 : ℕ) : K) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.succ_ne_zero n)
  rw [cauchySeq]
  have hr : rhs n
      (fun j => if _h : j < n + 1 then cauchySeq (K := K) x0 rhs j else 0) =
      rhs n (cauchySeq (K := K) x0 rhs) := by
    apply causal
    intro j hj
    simp only [dif_pos (Nat.lt_succ_of_le hj)]
  simpa only [smul_smul, mul_inv_cancel₀ hc, one_smul] using hr

theorem causal_cauchy_exists_unique [CharZero K] (x0 : V)
    (rhs : ℕ → (ℕ → V) → V)
    (causal : ∀ n f g, (∀ j, j ≤ n → f j = g j) → rhs n f = rhs n g) :
    ∃! f : ℕ → V, f 0 = x0 ∧
      ∀ n, ((n + 1 : ℕ) : K) • f (n + 1) = rhs n f := by
  have hzero : cauchySeq (K := K) x0 rhs 0 = x0 := by rw [cauchySeq]
  refine ⟨cauchySeq (K := K) x0 rhs,
    ⟨hzero, cauchySeq_recurrence (K := K) x0 rhs causal⟩, ?_⟩
  intro f hf
  exact causal_recurrence_unique rhs causal f (cauchySeq (K := K) x0 rhs)
    (hf.1.trans hzero.symm) hf.2 (cauchySeq_recurrence (K := K) x0 rhs causal)

theorem nonzero_kernel_of_dimension
    {U : Type w} [AddCommGroup U] [Module K U]
    [FiniteDimensional K U] [FiniteDimensional K V]
    (L : U →ₗ[K] V) (hdim : Module.finrank K V < Module.finrank K U) :
    ∃ x, x ≠ 0 ∧ L x = 0 := by
  by_contra hn
  have hinj : Function.Injective L := by
    intro x y he
    have hz : L (x - y) = 0 := by rw [map_sub, he, sub_self]
    have hxy : x - y = 0 := by
      by_contra hne
      exact hn ⟨x - y, hne, hz⟩
    exact sub_eq_zero.mp hxy
  exact (not_le_of_gt hdim) (LinearMap.finrank_le_finrank_of_injective hinj)

end Linear

theorem cancel_normal_factor {R : Type u} {M : Type v}
    [CommRing R] [IsDomain R] [AddCommGroup M] [Module R M]
    [NoZeroSMulDivisors R M] (r : R) (hr : r ≠ 0) (n : ℕ)
    (v : M) (h : r ^ n • v = 0) : v = 0 :=
  (smul_eq_zero.mp h).resolve_left (pow_ne_zero n hr)

theorem normal_derivative_factor {K : Type u} [Field K]
    (n : ℕ) (h : Polynomial K) :
    Polynomial.derivative (Polynomial.X ^ (n + 1) * h) =
      Polynomial.X ^ n *
        (Polynomial.C (n + 1 : K) * h + Polynomial.X * Polynomial.derivative h) := by
  rw [Polynomial.derivative_mul, Polynomial.derivative_X_pow_succ]
  ring

theorem wedge_sign {K : Type u} [Field K] (a b h hr hz c : K) :
    a * (0 * hz) - b * (c * h + 0 * hr) = -(c * h * b) := by
  ring

theorem odd_sum (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (2 * k + 1) = (n + 1) ^ 2 := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    ring

theorem even_sum (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (2 * k + 2) = (n + 1) * (n + 2) := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    ring

theorem reconstruction_bound_even (q : ℕ) :
    (5 * q + 2) ^ 2 < 2 * (4 * q + 2) ^ 2 := by
  have he : 2 * (4 * q + 2) ^ 2 =
      (5 * q + 2) ^ 2 + (7 * q ^ 2 + 12 * q + 4) := by ring
  omega

theorem reconstruction_bound_odd (q : ℕ) :
    (5 * q + 4) * (5 * q + 5) < 2 * (4 * q + 4) ^ 2 := by
  have he : 2 * (4 * q + 4) ^ 2 =
      (5 * q + 4) * (5 * q + 5) + (7 * q ^ 2 + 19 * q + 12) := by ring
  omega

theorem filtration_bound (K : ℕ) (D b : ℕ → ℕ)
    (hzero : D K = 0)
    (hstep : ∀ k, k < K → D k ≤ D (k + 1) + b k) :
    D 0 ≤ ∑ k ∈ Finset.range K, b k := by
  have aux : ∀ n, n ≤ K → D 0 ≤ D n + ∑ k ∈ Finset.range n, b k := by
    intro n
    induction n with
    | zero => intro _; simp
    | succ n ih =>
      intro hn
      have hp := ih (Nat.le_of_succ_le hn)
      have hs := hstep n (Nat.lt_of_succ_le hn)
      rw [Finset.sum_range_succ]
      omega
  simpa [hzero] using aux K le_rfl

theorem blowup_preimage (k a b : ℕ) (hb : b < k) :
    (a + k - b) + b - k = a ∧ k ≤ (a + k - b) + b := by
  omega

theorem colength_drop (old child k : ℕ) (hk : 0 < k)
    (h : child + k * (k + 1) / 2 ≤ old) : child < old := by
  have hp : 2 ≤ k * (k + 1) := by nlinarith
  omega

end TangentBox
