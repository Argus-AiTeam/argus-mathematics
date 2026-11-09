import Mathlib

open scoped BigOperators
open Filter

namespace ScalarJetRigidity

def drops {k p : ℕ} (excluded : Fin k → Fin p) (x : Fin p) : ℕ :=
  (Finset.univ.filter fun j => excluded j ≠ x).card

def omissions {k p : ℕ} (excluded : Fin k → Fin p) (x : Fin p) : ℕ :=
  (Finset.univ.filter fun j => excluded j = x).card

theorem unused_lift {k p : ℕ} (hkp : k < p) (excluded : Fin k → Fin p) :
    ∃ x, ∀ j, excluded j ≠ x := by
  classical
  by_contra h
  have hs : Function.Surjective excluded := by
    intro x
    by_contra hx
    exact h ⟨x, fun j hj => hx ⟨j, hj⟩⟩
  have hc := Fintype.card_le_of_surjective excluded hs
  simp only [Fintype.card_fin] at hc
  omega

theorem drop_partition {k p : ℕ} (excluded : Fin k → Fin p) (x : Fin p) :
    drops excluded x + omissions excluded x = k := by
  classical
  simpa [drops, omissions] using
    (Finset.card_filter_add_card_filter_not
      (s := (Finset.univ : Finset (Fin k))) (fun j => excluded j ≠ x))

theorem fiber_capacity {k p n : ℕ} (hkp : k < p) (excluded : Fin k → Fin p)
    (capacity : ∀ x, drops excluded x ≤ n) : k ≤ n := by
  obtain ⟨x, hx⟩ := unused_lift hkp excluded
  have hd : drops excluded x = k := by simp [drops, hx]
  simpa [hd] using capacity x

theorem euler_saturation {A : Type*} [Fintype A] [DecidableEq A]
    (n m : A → ℕ) (k M gamma : ℕ) (hM : 0 < M)
    (lower : ∀ a, m a ≤ n a) (total : ∑ a, m a = k)
    (euler : (∑ a, n a) + M * gamma = k) :
    gamma = 0 ∧ ∀ a, n a = m a := by
  classical
  have hsum : (∑ a, m a) ≤ ∑ a, n a :=
    Finset.sum_le_sum fun a _ => lower a
  have hprod : M * gamma = 0 := by omega
  have hg : gamma = 0 := by
    rcases Nat.mul_eq_zero.mp hprod with hm | hg
    · omega
    · exact hg
  refine ⟨hg, ?_⟩
  intro a
  have hrest :
      (∑ b ∈ Finset.univ.erase a, m b) ≤ ∑ b ∈ Finset.univ.erase a, n b :=
    Finset.sum_le_sum fun b _ => lower b
  have hn := Finset.sum_erase_add (s := Finset.univ) (f := n) (Finset.mem_univ a)
  have hm := Finset.sum_erase_add (s := Finset.univ) (f := m) (Finset.mem_univ a)
  have hlow := lower a
  omega

theorem endpoint_rank_rigidity {A : Type*} [Fintype A] [DecidableEq A]
    (n m : A → ℕ) (k p M gamma : ℕ) (hkp : k < p) (hM : 0 < M)
    (total : ∑ a, m a = k)
    (excluded : (a : A) → Fin (m a) → Fin p)
    (capacity : ∀ a x, drops (excluded a) x ≤ n a)
    (euler : (∑ a, n a) + M * gamma = k) :
    gamma = 0 ∧
      ∀ a, n a = m a ∧
        ∀ x, n a - drops (excluded a) x = omissions (excluded a) x := by
  classical
  have lower : ∀ a, m a ≤ n a := by
    intro a
    have ha : m a ≤ ∑ b, m b :=
      Finset.single_le_sum (fun b _ => Nat.zero_le (m b)) (Finset.mem_univ a)
    have hmp : m a < p := by omega
    exact fiber_capacity hmp (excluded a) (capacity a)
  obtain ⟨hg, hn⟩ := euler_saturation n m k M gamma hM lower total euler
  refine ⟨hg, fun a => ⟨hn a, ?_⟩⟩
  intro x
  have hd := drop_partition (excluded a) x
  rw [hn a]
  omega

def pairCount {A : Type*} [DecidableEq A] (a b x : A) : ℕ :=
  (if a = x then 1 else 0) + (if b = x then 1 else 0)

theorem forced_pair_swap {A : Type*} [DecidableEq A] (a b c d : A)
    (same : ∀ x, pairCount a b x = pairCount c d x) (distinct : a ≠ c) :
    a = d ∧ b = c := by
  have had : a = d := by
    by_contra h
    have hc : c ≠ a := Ne.symm distinct
    have hd : d ≠ a := Ne.symm h
    have hcount := same a
    by_cases hba : b = a <;> simp [pairCount, hc, hd, hba] at hcount
  refine ⟨had, ?_⟩
  subst d
  by_contra h
  have hc : c ≠ b := Ne.symm h
  have hcount := same b
  by_cases hab : a = b <;> simp [pairCount, hc, hab] at hcount

theorem small_multiple_zero (N x : ℤ) (hN : 0 < N)
    (lower : -N < x) (upper : x < N) (divides : N ∣ x) : x = 0 := by
  obtain ⟨j, rfl⟩ := divides
  have hjlo : -1 < j := by nlinarith
  have hjhi : j < 1 := by nlinarith
  have hj : j = 0 := by omega
  simp [hj]

theorem unique_positive_multiple (N x : ℤ) (hN : 0 < N)
    (lower : 0 < x) (upper : x < 2 * N) (divides : N ∣ x) : x = N := by
  obtain ⟨j, rfl⟩ := divides
  have hjlo : 0 < j := by nlinarith
  have hjhi : j < 2 := by nlinarith
  have hj : j = 1 := by omega
  simp [hj]

theorem negative_residues_distinct (N d dn : ℤ)
    (hd : 0 < d) (hincrease : d < dn) (hbound : dn < N) :
    ¬ Int.ModEq N (-d) (-dn) := by
  intro heq
  have hN : 0 < N := by omega
  have hz : -dn - -d = 0 :=
    small_multiple_zero N (-dn - -d) hN (by omega) (by omega)
      (Int.modEq_iff_dvd.mp heq)
  omega

theorem coefficient_divisibility (P t m b v : ℤ)
    (ht : P ∣ t) (order : b - t * m = P * v) : P ∣ b := by
  have horder : P ∣ b - t * m := ⟨v, order⟩
  have htm : P ∣ t * m := dvd_mul_of_dvd_left ht m
  simpa using dvd_add horder htm

theorem thickness_bounds (s C h m b : ℤ)
    (nonnegative : 0 ≤ h * m + b) (bounded : h * m + b ≤ C * m) :
    (s - C) * m ≤ (s - h) * m - b ∧ (s - h) * m - b ≤ s * m := by
  constructor <;> nlinarith

theorem offset_stabilizes (N C d dn dp dpn q : ℤ) (hN : 0 < N) (hC : C < N)
    (e0 : 0 ≤ dp - d) (e1 : dp - d ≤ C)
    (f0 : 0 ≤ dpn - dn) (f1 : dpn - dn ≤ C)
    (first : dn + q + dp = N) (second : N ∣ d + q + dpn) :
    dpn - dn = dp - d := by
  have hfirst : N ∣ dn + q + dp := by rw [first]
  have hdiv : N ∣ (dpn - dn) - (dp - d) := by
    have hd := dvd_sub second hfirst
    have he : (d + q + dpn) - (dn + q + dp) = (dpn - dn) - (dp - d) := by ring
    rwa [he] at hd
  have hz : (dpn - dn) - (dp - d) = 0 :=
    small_multiple_zero N _ hN (by omega) (by omega) hdiv
  omega

def centered (p M d c : ℤ) : ℤ :=
  2 * (p + 1) * d - 2 * p * M + (p + 1) * c

theorem centered_step (p M d dn c : ℤ) (recurrence : dn + d + c = p * M) :
    centered p (p * M) dn c = -centered p M d c := by
  unfold centered
  linear_combination 2 * (p + 1) * recurrence

theorem alternating_of_step (x : ℕ → ℤ) (step : ∀ n, x (n + 1) = -x n) :
    ∀ n, x n = (-1) ^ n * x 0 := by
  intro n
  induction n with
  | zero => simp
  | succ n ih => rw [step n, ih, pow_succ]; ring

theorem exact_width_tail (p M c : ℤ) (d : ℕ → ℤ)
    (recurrence : ∀ n, d (n + 1) + d n + c = M * p ^ (n + 1)) :
    ∀ n, centered p (M * p ^ n) (d n) c =
      (-1) ^ n * centered p M (d 0) c := by
  have hstep : ∀ n,
      centered p (M * p ^ (n + 1)) (d (n + 1)) c =
        -centered p (M * p ^ n) (d n) c := by
    intro n
    have hr : d (n + 1) + d n + c = p * (M * p ^ n) := by
      rw [recurrence n, pow_succ]
      ring
    have hperiod : M * p ^ (n + 1) = p * (M * p ^ n) := by
      rw [pow_succ]
      ring
    rw [hperiod]
    exact centered_step p (M * p ^ n) (d n) (d (n + 1)) c hr
  simpa using alternating_of_step
    (fun n => centered p (M * p ^ n) (d n) c) hstep

theorem monotone_tail_bound (p M d dn dnn c : ℤ)
    (hrec : dn + d + c = p * M)
    (hnext : dnn + dn + c = p * (p * M))
    (hgrowth : p * d ≤ dn) (hnextgrowth : p * dn ≤ dnn) :
    |centered p M d c| ≤ (p - 1) * c := by
  have hu : centered p M d c ≤ (p - 1) * c := by
    unfold centered
    nlinarith
  have hv : centered p (p * M) dn c ≤ (p - 1) * c := by
    unfold centered
    nlinarith
  rw [centered_step p M d dn c hrec] at hv
  exact abs_le.mpr ⟨by linarith, hu⟩

theorem real_tail_invariant (p M c : ℝ) (d : ℕ → ℝ)
    (recurrence : ∀ n, d (n + 1) + d n + c = M * p ^ (n + 1)) :
    ∀ n, 2 * (p + 1) * d n - 2 * p * (M * p ^ n) + (p + 1) * c =
      (-1) ^ n * (2 * (p + 1) * d 0 - 2 * p * M + (p + 1) * c) := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
    calc
      _ = -(2 * (p + 1) * d n - 2 * p * (M * p ^ n) + (p + 1) * c) := by
        have hr := recurrence n
        rw [pow_succ] at hr ⊢
        linear_combination 2 * (p + 1) * hr
      _ = _ := by rw [ih, pow_succ]; ring

theorem width_limit (p M c : ℝ) (hp : 1 < p) (hM : 0 < M) (d : ℕ → ℝ)
    (recurrence : ∀ n, d (n + 1) + d n + c = M * p ^ (n + 1)) :
    Tendsto (fun n => d n / (M * p ^ n)) atTop (nhds (p / (p + 1))) := by
  have hp0 : p ≠ 0 := by linarith
  have hp1 : p + 1 ≠ 0 := by linarith
  have hM0 : M ≠ 0 := ne_of_gt hM
  let K := 2 * (p + 1) * d 0 - 2 * p * M + (p + 1) * c
  have formula : ∀ n, d n / (M * p ^ n) =
      p / (p + 1) - (c / (2 * M)) * (1 / p) ^ n +
        (K / (2 * (p + 1) * M)) * ((-1) / p) ^ n := by
    intro n
    have hi := real_tail_invariant p M c d recurrence n
    change 2 * (p + 1) * d n - 2 * p * (M * p ^ n) + (p + 1) * c =
      (-1) ^ n * K at hi
    rw [div_pow, div_pow, one_pow]
    field_simp [hp0, hp1, hM0, pow_ne_zero n hp0]
    nlinarith [hi]
  have hsmall : |1 / p| < (1 : ℝ) := by
    rw [abs_of_pos (one_div_pos.mpr (by linarith))]
    exact (div_lt_one (by linarith : 0 < p)).mpr hp
  have hneg : |(-1 : ℝ) / p| < 1 := by
    simpa only [neg_div, one_div, abs_neg] using hsmall
  have ht := tendsto_pow_atTop_nhds_zero_of_abs_lt_one hsmall
  have hu := tendsto_pow_atTop_nhds_zero_of_abs_lt_one hneg
  have hlimit : Tendsto
      (fun n => p / (p + 1) - (c / (2 * M)) * (1 / p) ^ n +
        (K / (2 * (p + 1) * M)) * ((-1) / p) ^ n)
      atTop (nhds (p / (p + 1) - (c / (2 * M)) * 0 +
        (K / (2 * (p + 1) * M)) * 0)) :=
    (tendsto_const_nhds.sub (tendsto_const_nhds.mul ht)).add
      (tendsto_const_nhds.mul hu)
  simpa only [formula, mul_zero, sub_zero, add_zero] using hlimit

end ScalarJetRigidity
