import Mathlib

open scoped BigOperators

namespace AnchorTravel

theorem finite_bin_bound {ι : Type*} (s : Finset ι) (b d : ι → ℝ)
    (D U : ℝ) (hD : 0 < D)
    (hb : ∀ i ∈ s, 0 ≤ b i)
    (hd : ∀ i ∈ s, D ≤ d i)
    (hm : ∑ i ∈ s, b i ≤ U * D) :
    ∑ i ∈ s, b i / d i ≤ U := by
  have hterm : ∑ i ∈ s, b i / d i ≤ ∑ i ∈ s, b i / D :=
    Finset.sum_le_sum fun i hi =>
      div_le_div_of_nonneg_left (hb i hi) hD (hd i hi)
  rw [← Finset.sum_div] at hterm
  exact hterm.trans ((div_le_iff₀ hD).2 hm)

theorem coefficient_packing
    (bad groups : Finset ℕ) (members : ℕ → Finset ℕ)
    (b d scale : ℕ → ℝ) (C L : ℝ)
    (hC : 0 ≤ C) (hL : 0 ≤ L)
    (hbad : ∀ i ∈ bad, b i / d i ≤ (6 / 5 : ℝ) * C)
    (hbadcount : (bad.card : ℝ) ≤ 14 * L)
    (hgroupcount : (groups.card : ℝ) ≤ 1 + 2 * L)
    (hscale : ∀ a ∈ groups, 0 < scale a)
    (hb : ∀ a ∈ groups, ∀ i ∈ members a, 0 ≤ b i)
    (hd : ∀ a ∈ groups, ∀ i ∈ members a,
      (5 / 12 : ℝ) * scale a ≤ d i)
    (hm : ∀ a ∈ groups, ∑ i ∈ members a, b i ≤ 2 * C * scale a) :
    (∑ i ∈ bad, b i / d i) +
      (∑ a ∈ groups, ∑ i ∈ members a, b i / d i)
      ≤ 27 * C * (1 + L) := by
  have hbad_sum : ∑ i ∈ bad, b i / d i ≤
      (bad.card : ℝ) * ((6 / 5 : ℝ) * C) := by
    calc
      ∑ i ∈ bad, b i / d i ≤ ∑ _i ∈ bad, (6 / 5 : ℝ) * C :=
        Finset.sum_le_sum hbad
      _ = _ := by simp
  have hbin : ∀ a ∈ groups,
      ∑ i ∈ members a, b i / d i ≤ (24 / 5 : ℝ) * C := by
    intro a ha
    have hsa : 0 < scale a := hscale a ha
    apply finite_bin_bound (members a) b d ((5 / 12 : ℝ) * scale a)
      ((24 / 5 : ℝ) * C) (by positivity) (hb a ha) (hd a ha)
    nlinarith [hm a ha]
  have hgroup_sum :
      (∑ a ∈ groups, ∑ i ∈ members a, b i / d i) ≤
      (groups.card : ℝ) * ((24 / 5 : ℝ) * C) := by
    calc
      _ ≤ ∑ _a ∈ groups, (24 / 5 : ℝ) * C := Finset.sum_le_sum hbin
      _ = _ := by simp
  calc
    _ ≤ (bad.card : ℝ) * ((6 / 5 : ℝ) * C) +
        (groups.card : ℝ) * ((24 / 5 : ℝ) * C) :=
      add_le_add hbad_sum hgroup_sum
    _ ≤ (14 * L) * ((6 / 5 : ℝ) * C) +
        (1 + 2 * L) * ((24 / 5 : ℝ) * C) := by gcongr
    _ ≤ 27 * C * (1 + L) := by nlinarith [mul_nonneg hC hL]

theorem refresh_separation (u s : ℝ) (hu : 0 < u) (hs : 0 < s)
    (hrefresh : s < (5 / 6 : ℝ) * u ∨ (6 / 5 : ℝ) * u < s) :
    max u s / 6 ≤ |s - u| := by
  rcases hrefresh with h | h
  · rw [max_eq_left (by linarith), abs_of_neg (by linarith)]
    linarith
  · rw [max_eq_right (by linarith), abs_of_pos (by linarith)]
    linarith

theorem refresh_credit (u s gap : ℝ) (hu : 0 < u) (hs : 0 < s)
    (hsep : max u s / 6 ≤ |s - u|)
    (hgap : (s - u) ^ 2 / (2 * max u s) ≤ gap) :
    (u + s) / 144 ≤ gap := by
  have hm : 0 < max u s := lt_of_lt_of_le hu (le_max_left _ _)
  have hprod : 0 ≤ (|s - u| - max u s / 6) *
      (|s - u| + max u s / 6) :=
    mul_nonneg (sub_nonneg.mpr hsep) (by positivity)
  have habs : |s - u| ^ 2 = (s - u) ^ 2 := sq_abs _
  have hnum : (s - u) ^ 2 ≤ gap * (2 * max u s) :=
    (div_le_iff₀ (by positivity)).1 hgap
  have hmul : max u s * max u s ≤ (72 * gap) * max u s := by
    nlinarith
  have hbound : max u s ≤ 72 * gap := by
    by_contra hn
    have hp : 0 < max u s * (max u s - 72 * gap) :=
      mul_pos hm (sub_pos.mpr (lt_of_not_ge hn))
    nlinarith
  have hsum : u + s ≤ 2 * max u s := by
    linarith [le_max_left u s, le_max_right u s]
  linarith

theorem retained_drop_constant (z δ : ℝ) (hz : 0 ≤ z)
    (hδ : 0 ≤ δ) (hδmax : δ ≤ 1 / 4) :
    1 / (2 * (1 + z)) ≤
      (1 - δ) / ((6 / 5 : ℝ) * (z + 1 + δ)) := by
  have hleft : 0 < 2 * (1 + z) := by positivity
  have hright : 0 < (6 / 5 : ℝ) * (z + 1 + δ) := by positivity
  apply (div_le_div_iff₀ hleft hright).2
  have hprod : 0 ≤ (1 + z) * (1 / 4 - δ) :=
    mul_nonneg (by positivity) (sub_nonneg.mpr hδmax)
  nlinarith

theorem finite_signed_payment (n : ℕ)
    (phi pay cost filter : ℕ → ℝ) (c : ℝ)
    (hstep : ∀ t < n, c * pay t + phi (t + 1) - phi t ≤
      cost t + filter t)
    (hfilter : ∑ t ∈ Finset.range n, filter t = 0)
    (hend : 0 ≤ phi n) :
    c * (∑ t ∈ Finset.range n, pay t) ≤
      phi 0 + ∑ t ∈ Finset.range n, cost t := by
  have htelescope : ∀ m : ℕ,
      ∑ t ∈ Finset.range m, (phi (t + 1) - phi t) = phi m - phi 0 := by
    intro m
    induction m with
    | zero => simp
    | succ m ih =>
      rw [Finset.sum_range_succ, ih]
      ring
  have hsum := Finset.sum_le_sum
    (fun t ht => hstep t (Finset.mem_range.mp ht))
  have heq : (∑ t ∈ Finset.range n,
      (c * pay t + phi (t + 1) - phi t)) =
      c * (∑ t ∈ Finset.range n, pay t) + (phi n - phi 0) := by
    calc
      _ = ∑ t ∈ Finset.range n,
          (c * pay t + (phi (t + 1) - phi t)) := by
        apply Finset.sum_congr rfl
        intro t ht
        ring
      _ = c * (∑ t ∈ Finset.range n, pay t) +
          (∑ t ∈ Finset.range n, (phi (t + 1) - phi t)) := by
        rw [Finset.sum_add_distrib, Finset.mul_sum]
      _ = _ := by rw [htelescope n]
  rw [heq, Finset.sum_add_distrib, hfilter] at hsum
  linarith

theorem anchor_bound_constant
    (T V P Q C e endpoint : ℝ)
    (hC : 1 ≤ C) (he : 1 ≤ e)
    (hV : 0 ≤ V) (hP : 0 ≤ P) (hQ : 0 ≤ Q)
    (h : T / 4 ≤ (18 / 5 : ℝ) * V +
      (1740 / 5 : ℝ) * C * e * P + 9 * C * e * Q +
      (6 / 5 : ℝ) * endpoint) :
    T ≤ 1400 * C * (V + e * P + e * Q) +
      (24 / 5 : ℝ) * endpoint := by
  have hcv : 0 ≤ (C - 1) * V := mul_nonneg (by linarith) hV
  have hcp : 0 ≤ C * e * P := by positivity
  have hcq : 0 ≤ C * e * Q := by positivity
  nlinarith

end AnchorTravel
