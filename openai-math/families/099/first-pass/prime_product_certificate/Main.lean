import Mathlib

namespace PrimeProductCertificate

theorem marker_interval_unmatched
    {I A : Type*} [LinearOrder I]
    (src tgt : I → ℕ) (hs : StrictMono src) (ht : StrictMono tgt)
    (X Y : ℕ → A) (marker : A)
    (hm : ∀ i, X (src i) = Y (tgt i))
    (lo hi qlo qhi : ℕ) (i j : I)
    (hlo : lo ≤ src i) (hhi : src j < hi)
    (hleft : tgt i < qlo) (hright : qhi ≤ tgt j)
    (hpayload : ∀ a, lo ≤ a → a < hi → X a ≠ marker)
    (hmarker : ∀ a, qlo ≤ a → a < qhi → Y a = marker) :
    ∀ k, ¬ (qlo ≤ tgt k ∧ tgt k < qhi) := by
  intro k hk
  have hik : i < k := (ht.lt_iff_lt).mp (lt_of_lt_of_le hleft hk.1)
  have hkj : k < j := (ht.lt_iff_lt).mp (lt_of_lt_of_le hk.2 hright)
  have hklo : lo ≤ src k := le_trans hlo (hs hik).le
  have hkhi : src k < hi := lt_trans (hs hkj) hhi
  exact hpayload _ hklo hkhi ((hm k).trans (hmarker _ hk.1 hk.2))

theorem ordered_spans_disjoint
    {I : Type*} [LinearOrder I]
    (src tgt : I → ℕ) (hs : StrictMono src) (ht : StrictMono tgt)
    (i j : I) (q₁ q₂ : ℕ)
    (hsource : src i < src j)
    (h₁ : q₁ < tgt i) (h₂ : tgt j < q₂) :
    q₁ < q₂ := by
  exact lt_trans h₁ (lt_trans (ht ((hs.lt_iff_lt).mp hsource)) h₂)

theorem charged_deficit
    (T d q E s : ℝ) (hd : 0 ≤ d) (hq : 0 < q)
    (hunsplit : d * (T - s) ≤ E) (hsplit : s * q ≤ E) :
    T * d * q / (d + q) ≤ E := by
  have hsum : T * d * q ≤ E * (d + q) := by
    nlinarith [mul_le_mul_of_nonneg_left hunsplit hq.le,
      mul_le_mul_of_nonneg_left hsplit hd]
  exact (div_le_iff₀ (by linarith : 0 < d + q)).mpr hsum

theorem marked_normalization
    (a μ g C m L : ℝ)
    (ha : 0 < a) (hμ : 0 < μ) (hg : 0 < g)
    (hC : 0 < C) (hm : 0 < m) (hL : 0 < L) :
    (2 * L * (m * μ * a / 2) * (g * m) /
      (m * μ * a / 2 + g * m)) / (L * (C + g) * m)
      = 2 * μ * g * a / ((2 * g + μ * a) * (C + g)) := by
  have hden : 0 < m * μ * a / 2 + g * m := by positivity
  have hden' : 0 < 2 * g + μ * a := by positivity
  field_simp
  <;> ring

theorem equal_markers_normalization
    (a μ C : ℝ) (ha : 0 < a) (hμ : 0 < μ) (hC : 0 < C) :
    2 * μ * C * a / ((2 * C + μ * a) * (C + C))
      = μ * a / (2 * C + μ * a) := by
  have hden : 0 < 2 * C + μ * a := by positivity
  field_simp
  <;> ring

theorem improved_separation_step
    (b a : ℝ) (hb : 2 ≤ b) (ha : 0 < a) (ha₁ : a ≤ 1) :
    a / 9 ≤ ((b / 2) * a) / (2 * (2 * b - 1) + (b / 2) * a) := by
  have hden : 0 < 2 * (2 * b - 1) + (b / 2) * a := by nlinarith
  apply (le_div_iff₀ hden).mpr
  nlinarith [mul_nonneg (by linarith : 0 ≤ b) (sub_nonneg.mpr ha₁),
    mul_nonneg ha.le (sub_nonneg.mpr ha₁)]

theorem coprime_no_cancellation
    (p q a k : ℕ) (hpq : Nat.Coprime p q)
    (ha : 0 < a) (hap : a < p) :
    ¬ p ∣ a * q + p * k := by
  intro h
  have hmul : p ∣ a * q :=
    (Nat.dvd_add_iff_left (dvd_mul_right p k)).mpr h
  have hpa : p ∣ a := hpq.dvd_of_dvd_mul_right hmul
  exact (not_le_of_gt hap) (Nat.le_of_dvd ha hpa)

theorem bounded_nonzero_multiple
    (n D q : ℕ) (hn : 0 < n) (hqn : q ∣ n)
    (hDq : D ≤ q) (hnD : n < D) : False := by
  exact (not_le_of_gt hnD) (le_trans hDq (Nat.le_of_dvd hn hqn))

theorem high_support_bound
    (h r energy target : ℝ) (hh : 0 < h) (hr : h ≤ r)
    (he : 0 ≤ energy) (ht : target ≤ 4 * energy) :
    target ≤ (2 / h) * (2 * r * energy) := by
  have hmul : h * target ≤ 4 * r * energy := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hr) he,
      mul_le_mul_of_nonneg_left ht hh.le]
  have hdiv : target ≤ (4 * r * energy) / h :=
    (le_div_iff₀ hh).mpr (by nlinarith [hmul])
  convert hdiv using 1 <;> ring

theorem cyclic_low_support_bound
    (q energy delta target : ℝ) (hq : 0 ≤ q)
    (ht : target ≤ 4 * energy)
    (hvariance : 2 * energy ≤ (q ^ 2 / 4) * delta) :
    target ≤ (q ^ 2 / 2) * delta := by
  nlinarith

theorem sum_displacement_bounds
    {I : Type*} (S : Finset I)
    (target simultaneous components : I → ℝ)
    (A B : ℝ)
    (hbound : ∀ i ∈ S, target i ≤ A * simultaneous i + B * components i) :
    (∑ i ∈ S, target i) ≤
      A * (∑ i ∈ S, simultaneous i) + B * (∑ i ∈ S, components i) := by
  calc
    (∑ i ∈ S, target i) ≤
        ∑ i ∈ S, (A * simultaneous i + B * components i) :=
      Finset.sum_le_sum hbound
    _ = _ := by simp [Finset.sum_add_distrib, Finset.mul_sum]

theorem cut_cone_transfer
    {I : Type*} (S : Finset I)
    (weight target simultaneous components : I → ℝ)
    (A B : ℝ)
    (hw : ∀ i ∈ S, 0 ≤ weight i)
    (hbound : ∀ i ∈ S, target i ≤ A * simultaneous i + B * components i) :
    (∑ i ∈ S, weight i * target i) ≤
      A * (∑ i ∈ S, weight i * simultaneous i) +
      B * (∑ i ∈ S, weight i * components i) := by
  calc
    (∑ i ∈ S, weight i * target i) ≤
        ∑ i ∈ S, weight i * (A * simultaneous i + B * components i) :=
      Finset.sum_le_sum fun i hi => mul_le_mul_of_nonneg_left (hbound i hi) (hw i hi)
    _ = _ := by
      simp only [mul_add, Finset.sum_add_distrib, Finset.mul_sum]
      congr 1 <;> apply Finset.sum_congr rfl <;> intros <;> ring

theorem direct_sum_normalization
    (w nx ny S : ℝ) (hw : 0 < w) (hx : 0 < nx) (hy : 0 < ny) :
    (1 / nx) * ((1 / (w * ny)) * S) =
      (1 / w) * ((1 / (nx * ny)) * S) := by
  field_simp
  <;> ring

theorem averaged_recurrence
    {I : Type*} (S : Finset I)
    (v w : I → ℝ) (A tau Q h L C g target : ℝ)
    (hA : 0 ≤ A) (hQ : 0 ≤ Q) (hh : 0 < h)
    (hL : 0 < L) (hC : 0 < C) (hg : 0 < g)
    (ht : tau ≤ 2 / L)
    (hv : ∀ i ∈ S, v i ≤ w i * Q)
    (hw : (∑ i ∈ S, w i) = C / (C + g))
    (hb : target ≤ A * tau + (2 / h) * (∑ i ∈ S, v i)) :
    target ≤ 2 * A / L + (2 * C / (h * (C + g))) * Q := by
  have hvsum : (∑ i ∈ S, v i) ≤ (C / (C + g)) * Q := by
    calc
      (∑ i ∈ S, v i) ≤ ∑ i ∈ S, w i * Q := Finset.sum_le_sum hv
      _ = (C / (C + g)) * Q := by rw [← Finset.sum_mul, hw]
  have hcoef : 0 ≤ 2 / h := by positivity
  have hbound := add_le_add (mul_le_mul_of_nonneg_left ht hA)
    (mul_le_mul_of_nonneg_left hvsum hcoef)
  have heq : A * (2 / L) + (2 / h) * ((C / (C + g)) * Q) =
      2 * A / L + (2 * C / (h * (C + g))) * Q := by
    field_simp
    <;> ring
  exact hb.trans (heq ▸ hbound)

theorem improved_recurrence_implies_manuscript
    (R L h old new prevOld prevNew : ℝ) (k : ℕ)
    (hR : 1 ≤ R) (hL : 0 < L) (hh : 0 < h)
    (hp : prevNew ≤ prevOld)
    (hn : new ≤ R ^ (2 * k) / L + prevNew / h)
    (ho : old = 2 * R ^ (2 * k + 2) / L + prevOld / h) :
    new ≤ old := by
  have hpow : R ^ (2 * k) ≤ 2 * R ^ (2 * k + 2) := by
    have hR₂ : 1 ≤ R ^ 2 := by nlinarith [sq_nonneg (R - 1)]
    have hprod := mul_le_mul_of_nonneg_left hR₂
      (pow_nonneg (by linarith : 0 ≤ R) (2 * k))
    rw [pow_add]
    nlinarith [hprod, pow_nonneg (by linarith : 0 ≤ R) (2 * k)]
  have heps := div_le_div_of_nonneg_right hpow hL.le
  have hprev := div_le_div_of_nonneg_right hp hh.le
  rw [ho]
  exact hn.trans (add_le_add heps hprev)

end PrimeProductCertificate
