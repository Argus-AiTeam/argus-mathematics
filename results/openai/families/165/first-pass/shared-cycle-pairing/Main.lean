import Mathlib

open scoped BigOperators Classical

namespace CyclePairing

noncomputable section

def sign (x : ℝ) : ℝ := if 0 < x then 1 else if x < 0 then -1 else 0

def above (x : ℝ) : ℝ := if 0 < x then 1 else 0

def flux (x y : ℝ) : ℝ := (sign x - sign y) / 2

theorem sign_eq_two_above_sub_one (x : ℝ) (hx : x ≠ 0) :
    sign x = 2 * above x - 1 := by
  by_cases hp : 0 < x
  · norm_num [sign, above, hp]
  · have hn : x < 0 := lt_of_le_of_ne (le_of_not_gt hp) hx
    simp [sign, above, hp, hn]

theorem above_neg (x : ℝ) (hx : x ≠ 0) :
    above (-x) = 1 - above x := by
  by_cases hp : 0 < x
  · have hn : ¬0 < -x := by linarith
    simp [above, hp, hn]
  · have hn : 0 < -x := by
      have : x < 0 := lt_of_le_of_ne (le_of_not_gt hp) hx
      linarith
    simp [above, hp, hn]

theorem flux_eq_above_sub (x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    flux x y = above x - above y := by
  rw [flux, sign_eq_two_above_sub_one x hx, sign_eq_two_above_sub_one y hy]
  ring

theorem overlap_interleaved (x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    flux x y = above x + above (-y) - 1 := by
  rw [flux_eq_above_sub x y hx hy, above_neg y hy]
  ring

theorem overlap_contained (x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    flux x y = above x - above y := flux_eq_above_sub x y hx hy

theorem overlap_containing (x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    flux x y = above (-y) - above (-x) := by
  rw [flux_eq_above_sub x y hx hy, above_neg x hx, above_neg y hy]
  ring

theorem overlap_reverse_interleaved (x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    flux x y = 1 - above y - above (-x) := by
  rw [flux_eq_above_sub x y hx hy, above_neg x hx]
  ring

theorem common_start (x : ℝ) (hx : x ≠ 0) :
    -sign x / 2 = above (-x) - 1 / 2 := by
  rw [sign_eq_two_above_sub_one x hx, above_neg x hx]
  ring

theorem common_end (x : ℝ) (hx : x ≠ 0) :
    sign x / 2 = above x - 1 / 2 := by
  rw [sign_eq_two_above_sub_one x hx]
  ring

theorem affine_zero_iff_opposite (x y : ℝ) (hx : x ≠ 0) (_hy : y ≠ 0) :
    (∃ t : ℝ, 0 < t ∧ t < 1 ∧ (1 - t) * x + t * y = 0) ↔ x * y < 0 := by
  constructor
  · rintro ⟨t, ht, ht', h⟩
    by_cases hxp : 0 < x
    · have hyn : y < 0 := by
        by_contra hn
        have h1 : 0 < (1 - t) * x := mul_pos (by linarith) hxp
        have h2 : 0 ≤ t * y := mul_nonneg (le_of_lt ht) (by linarith)
        linarith
      exact mul_neg_of_pos_of_neg hxp hyn
    · have hxn : x < 0 := lt_of_le_of_ne (by linarith) hx
      have hyp : 0 < y := by
        by_contra hn
        have h1 : (1 - t) * x < 0 := mul_neg_of_pos_of_neg (by linarith) hxn
        have h2 : t * y ≤ 0 := mul_nonpos_of_nonneg_of_nonpos (le_of_lt ht) (by linarith)
        linarith
      exact mul_neg_of_neg_of_pos hxn hyp
  · intro h
    have hxy : x - y ≠ 0 := by
      intro heq
      have heq' : x = y := by linarith
      rw [heq'] at h
      nlinarith [sq_nonneg y]
    refine ⟨x / (x - y), ?_, ?_, ?_⟩
    · rcases (mul_neg_iff.mp h) with h | h
      · exact div_pos h.1 (by linarith [h.2])
      · exact div_pos_of_neg_of_neg h.1 (by linarith [h.2])
    · rcases (mul_neg_iff.mp h) with h | h
      · exact (div_lt_one (by linarith [h.1, h.2])).2 (by linarith [h.2])
      · exact (div_lt_one_of_neg (by linarith [h.1, h.2])).2 (by linarith [h.2])
    · field_simp
      ring

theorem affine_zero_unique (x y t u : ℝ) (hxy : x ≠ y)
    (ht : (1 - t) * x + t * y = 0)
    (hu : (1 - u) * x + u * y = 0) : t = u := by
  have h : (t - u) * (y - x) = 0 := by nlinarith [ht, hu]
  rcases mul_eq_zero.mp h with h | h
  · linarith
  · exact (hxy (by linarith)).elim

variable {V E : Type*} [Fintype V] [Fintype E]

def boundary (B : V → E → ℝ) (z : E → ℝ) (v : V) : ℝ :=
  ∑ e, z e * B v e

def pairing (J : E → E → ℝ) (z y : E → ℝ) : ℝ :=
  ∑ e, ∑ f, z e * y f * J e f

def incidenceForm (B : V → E → ℝ) (R : E → V → ℝ)
    (T : V → V → ℝ) (e f : E) : ℝ :=
  (∑ v, B v e * R f v) - (∑ v, B v f * R e v) -
    (1 / 2 : ℝ) * ∑ v, B v e * (∑ w, B w f * T v w)

theorem contraction_zero (B : V → E → ℝ) (z : E → ℝ)
    (hz : ∀ v, boundary B z v = 0) (q : V → ℝ) :
    (∑ e, z e * (∑ v, B v e * q v)) = 0 := by
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro v _
  calc
    (∑ e, z e * (B v e * q v)) = (∑ e, z e * B v e) * q v := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro e _
      ring
    _ = 0 := by rw [← boundary, hz]; ring

theorem pairing_swap (J : E → E → ℝ) (z y : E → ℝ) :
    pairing (fun e f => J f e) z y = pairing J y z := by
  unfold pairing
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro e _
  apply Finset.sum_congr rfl
  intro f _
  ring

theorem pairing_left_zero (B : V → E → ℝ) (z y : E → ℝ)
    (hz : ∀ v, boundary B z v = 0) (Q : V → E → ℝ) :
    pairing (fun e f => ∑ v, B v e * Q v f) z y = 0 := by
  unfold pairing
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro f _
  calc
    (∑ e, z e * y f * ∑ v, B v e * Q v f) =
        y f * (∑ e, z e * ∑ v, B v e * Q v f) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro e _
      ring
    _ = 0 := by rw [contraction_zero B z hz]; ring

theorem pairing_sub (J K : E → E → ℝ) (z y : E → ℝ) :
    pairing (fun e f => J e f - K e f) z y =
      pairing J z y - pairing K z y := by
  simp [pairing, mul_sub, Finset.sum_sub_distrib]

theorem pairing_scale (a : ℝ) (J : E → E → ℝ) (z y : E → ℝ) :
    pairing (fun e f => a * J e f) z y = a * pairing J z y := by
  unfold pairing
  simp_rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro e _
  apply Finset.sum_congr rfl
  intro f _
  ring

theorem incidence_pairing_zero (B : V → E → ℝ) (R : E → V → ℝ)
    (T : V → V → ℝ) (z y : E → ℝ)
    (hz : ∀ v, boundary B z v = 0) (hy : ∀ v, boundary B y v = 0) :
    pairing (incidenceForm B R T) z y = 0 := by
  have hleft := pairing_left_zero B z y hz (fun v f => R f v)
  have hright : pairing (fun e f => ∑ v, B v f * R e v) z y = 0 := by
    rw [pairing_swap]
    exact pairing_left_zero B y z hy (fun v e => R e v)
  have htop := pairing_left_zero B z y hz
    (fun v f => ∑ w, B w f * T v w)
  change pairing (fun e f =>
    ((∑ v, B v e * R f v) - (∑ v, B v f * R e v)) -
      (1 / 2 : ℝ) * (∑ v, B v e * (∑ w, B w f * T v w))) z y = 0
  rw [pairing_sub, pairing_sub, pairing_scale, hleft, hright, htop]
  ring

theorem cycle_pairing (B : V → E → ℝ) (R : E → V → ℝ)
    (T : V → V → ℝ) (I L : E → E → ℝ)
    (geometric_bridge : ∀ e f, I e f + L e f = incidenceForm B R T e f)
    (z y : E → ℝ) (hz : ∀ v, boundary B z v = 0)
    (hy : ∀ v, boundary B y v = 0) :
    pairing (fun e f => I e f + L e f) z y = 0 := by
  have h : (fun e f => I e f + L e f) = incidenceForm B R T := by
    funext e f
    exact geometric_bridge e f
  rw [h]
  exact incidence_pairing_zero B R T z y hz hy

def refinement (T : E → E → ℝ) (d : E → ℝ) (e f : E) : ℝ :=
  if e = f then d e else T e f

theorem shared_spoke_average (T : E → E → ℝ) (d a b : E → ℝ)
    (hdiag : ∀ e, T e e = 0) :
    (pairing (refinement T d) a b +
      pairing (refinement T (fun e => -d e)) a b) / 2 = pairing T a b := by
  have hpoint : ∀ e f, refinement T d e f +
      refinement T (fun e => -d e) e f = 2 * T e f := by
    intro e f
    by_cases h : e = f
    · subst f
      simp [refinement, hdiag]
    · simp [refinement, h]
      ring
  have hsum : pairing (refinement T d) a b +
      pairing (refinement T (fun e => -d e)) a b = 2 * pairing T a b := by
    unfold pairing
    rw [← Finset.sum_add_distrib, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro e _
    rw [← Finset.sum_add_distrib, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro f _
    calc
      _ = a e * b f * (refinement T d e f +
          refinement T (fun e => -d e) e f) := by ring
      _ = _ := by rw [hpoint]; ring
  rw [hsum]
  ring

theorem outer_sum (a b : E → ℝ) :
    (∑ e, ∑ f, a e * b f) = (∑ e, a e) * (∑ f, b f) := by
  rw [Finset.sum_mul]
  simp_rw [Finset.mul_sum]

theorem cut_change (a b u : E → ℝ)
    (ha : ∑ e, a e = 0) (hb : ∑ e, b e = 0) :
    (∑ e, ∑ f, a e * b f * (2 * (u f - u e))) = 0 := by
  have hpoint : ∀ e f, a e * b f * (2 * (u f - u e)) =
      2 * (a e * (b f * u f)) - 2 * ((a e * u e) * b f) := by
    intro e f
    ring
  simp_rw [hpoint, Finset.sum_sub_distrib, ← Finset.mul_sum]
  simp [← Finset.sum_mul, ha, hb]

end
end CyclePairing
