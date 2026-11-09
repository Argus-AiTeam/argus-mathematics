import Mathlib

open scoped BigOperators

namespace TriangleAudit

theorem reversible_swap {I : Type*} [Fintype I]
    (pi : I → ℝ) (K f : I → I → ℝ)
    (balance : ∀ v y, pi v * K v y = pi y * K y v) :
    (∑ v, ∑ y, pi v * K v y * f v y) =
      ∑ v, ∑ y, pi v * K v y * f y v := by
  calc
    (∑ v, ∑ y, pi v * K v y * f v y) =
        ∑ y, ∑ v, pi v * K v y * f v y := Finset.sum_comm
    _ = ∑ y, ∑ v, pi y * K y v * f v y := by
      apply Finset.sum_congr rfl
      intro y _
      apply Finset.sum_congr rfl
      intro v _
      rw [balance v y]
    _ = ∑ v, ∑ y, pi v * K v y * f y v := rfl

theorem averaged_cutoff {I : Type*} [Fintype I]
    (prob ell : I → ℝ) (b t H : ℝ)
    (hp : ∀ i, 0 ≤ prob i) (htotal : ∑ i, prob i = 1)
    (hlower : ∀ i, -b ≤ ell i)
    (hmean : ∑ i, prob i * ell i ≤ H) :
    (t + b) * (∑ i, if t < ell i then prob i else 0) ≤ H + b := by
  classical
  calc
    (t + b) * (∑ i, if t < ell i then prob i else 0) =
        ∑ i, if t < ell i then (t + b) * prob i else 0 := by
      simp only [Finset.mul_sum, mul_ite, mul_zero]
    _ ≤ ∑ i, prob i * (ell i + b) := by
      apply Finset.sum_le_sum
      intro i _
      by_cases hi : t < ell i
      · simp only [hi, ite_true]
        have hprod := mul_le_mul_of_nonneg_left (le_of_lt hi) (hp i)
        nlinarith
      · simp only [hi, ite_false]
        apply mul_nonneg (hp i)
        linarith [hlower i]
    _ = (∑ i, prob i * ell i) + b := by
      simp_rw [mul_add]
      rw [Finset.sum_add_distrib, ← Finset.sum_mul, htotal, one_mul]
    _ ≤ H + b := by linarith

theorem averaged_cutoff_probability {I : Type*} [Fintype I]
    (prob ell : I → ℝ) (b t H : ℝ)
    (hp : ∀ i, 0 ≤ prob i) (htotal : ∑ i, prob i = 1)
    (hlower : ∀ i, -b ≤ ell i)
    (hmean : ∑ i, prob i * ell i ≤ H) (hdenom : 0 < t + b) :
    (∑ i, if t < ell i then prob i else 0) ≤ (H + b) / (t + b) := by
  classical
  apply (le_div_iff₀ hdenom).2
  simpa only [mul_comm] using averaged_cutoff prob ell b t H hp htotal hlower hmean

theorem halving_sum (e : ℕ → ℝ)
    (hnonneg : ∀ i, 0 ≤ e i)
    (hhalf : ∀ i, e (i + 1) ≤ e i / 2) (n : ℕ) :
    (∑ i ∈ Finset.range n, e i) ≤ 2 * e 0 := by
  have stronger : ∀ k, (∑ i ∈ Finset.range k, e i) + 2 * e k ≤ 2 * e 0 := by
    intro k
    induction k with
    | zero => simp
    | succ k ih =>
      rw [Finset.sum_range_succ]
      linarith [hhalf k]
  have htail : 0 ≤ 2 * e n := mul_nonneg (by norm_num) (hnonneg n)
  linarith [stronger n]

theorem telescoping_loss (T eps b : ℕ → ℝ) (M0 : ℝ)
    (hstep : ∀ i, T i ≤ T (i + 1) + eps i * T 0 + b i * M0) (n : ℕ) :
    T 0 ≤ T n + T 0 * (∑ i ∈ Finset.range n, eps i) +
      M0 * (∑ i ∈ Finset.range n, b i) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, Finset.sum_range_succ]
    nlinarith [hstep n]

theorem bounded_mass_iteration (T M eps b : ℕ → ℝ) (L : ℝ) (n : ℕ)
    (hT0 : 0 ≤ T 0) (hM0 : 0 ≤ M 0)
    (heps : ∀ i, 0 ≤ eps i) (hb : ∀ i, 0 ≤ b i)
    (hTle : ∀ i, T i ≤ T 0) (hMle : ∀ i, M i ≤ M 0)
    (hrec : ∀ i, (1 - eps i) * T i - b i * M i ≤ T (i + 1))
    (hsumeps : (∑ i ∈ Finset.range n, eps i) ≤ 1 / 2)
    (hsumb : (∑ i ∈ Finset.range n, b i) ≤ 1)
    (hterminal : 3 * T n ≤ L * M 0) :
    T 0 ≤ 2 * (1 + L / 3) * M 0 := by
  have hstep : ∀ i, T i ≤ T (i + 1) + eps i * T 0 + b i * M 0 := by
    intro i
    have he := mul_le_mul_of_nonneg_left (hTle i) (heps i)
    have hm := mul_le_mul_of_nonneg_left (hMle i) (hb i)
    nlinarith [hrec i]
  have htel := telescoping_loss T eps b (M 0) hstep n
  have he := mul_le_mul_of_nonneg_left hsumeps hT0
  have hm := mul_le_mul_of_nonneg_left hsumb hM0
  nlinarith

theorem small_endpoint_bound (n x ell : ℝ) (p : ℕ)
    (hn : 0 ≤ n) (hx : 0 ≤ x) (hell : 1 / 2 ≤ ell) :
    n ^ p ≤ (2 : ℝ) ^ p * (x + n * ell) ^ p := by
  have hprod : 0 ≤ n * (ell - 1 / 2) :=
    mul_nonneg hn (sub_nonneg.mpr hell)
  have hbase : n ≤ 2 * (x + n * ell) := by nlinarith
  have hp := pow_le_pow_left₀ hn hbase p
  simpa only [mul_pow] using hp

theorem profile_separation (n ell : ℝ) (p q : ℕ)
    (hn : 0 ≤ n) (hell : ell ≤ 1) (hpq : q ≤ p)
    (hbase_nonneg : 0 ≤ n + n * ell) :
    (n + n * ell) ^ q * n ^ (p - q) ≤ (2 : ℝ) ^ q * n ^ p := by
  have hprod : 0 ≤ n * (1 - ell) :=
    mul_nonneg hn (sub_nonneg.mpr hell)
  have hbase : n + n * ell ≤ 2 * n := by nlinarith
  have hp := pow_le_pow_left₀ hbase_nonneg hbase q
  have hsum : q + (p - q) = p := by omega
  calc
    (n + n * ell) ^ q * n ^ (p - q) ≤
        (2 * n) ^ q * n ^ (p - q) :=
      mul_le_mul_of_nonneg_right hp (pow_nonneg hn _)
    _ = (2 : ℝ) ^ q * (n ^ q * n ^ (p - q)) := by rw [mul_pow]; ring
    _ = (2 : ℝ) ^ q * n ^ p := by rw [← pow_add, hsum]

end TriangleAudit
