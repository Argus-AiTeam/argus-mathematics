import Mathlib

namespace CoherentAdams

noncomputable def overlap (a b l u : ℝ) : ℝ :=
  max 0 (min b u - max a l)

theorem overlap_nonneg (a b l u : ℝ) : 0 ≤ overlap a b l u :=
  le_max_left _ _

theorem overlap_self (a l u : ℝ) : overlap a a l u = 0 := by
  unfold overlap
  exact max_eq_left (sub_nonpos.mpr ((min_le_left a u).trans (le_max_left a l)))

theorem overlap_split (a b c l u : ℝ)
    (hab : a ≤ b) (hbc : b ≤ c) (hlu : l ≤ u) :
    overlap a c l u = overlap a b l u + overlap b c l u := by
  by_cases hbl : b ≤ l
  · have hal : a ≤ l := hab.trans hbl
    have hbu : b ≤ u := hbl.trans hlu
    simp only [overlap, max_eq_right hal, max_eq_right hbl, min_eq_left hbu,
      max_eq_left (sub_nonpos.mpr hbl), zero_add]
  · by_cases hub : u ≤ b
    · have huc : u ≤ c := hub.trans hbc
      have hlb : l ≤ b := hlu.trans hub
      simp only [overlap, min_eq_right huc, min_eq_right hub, max_eq_left hlb,
        max_eq_left (sub_nonpos.mpr hub), add_zero]
    · have hlb : l ≤ b := by linarith
      have hbu : b ≤ u := by linarith
      have hleft : max a l ≤ b := max_le hab hlb
      have hright : b ≤ min c u := le_min hbc hbu
      unfold overlap
      rw [min_eq_left hbu, max_eq_left hlb,
        max_eq_right (sub_nonneg.mpr hleft),
        max_eq_right (sub_nonneg.mpr hright),
        max_eq_right (sub_nonneg.mpr (hleft.trans hright))]
      ring

theorem overlap_telescope (s : ℕ → ℝ) (hs : Monotone s)
    (l u : ℝ) (hlu : l ≤ u) (k : ℕ) :
    (∑ a ∈ Finset.range k, overlap (s a) (s (a + 1)) l u) =
      overlap (s 0) (s k) l u := by
  induction k with
  | zero => simp [overlap_self]
  | succ k ih =>
      rw [Finset.sum_range_succ, ih]
      exact (overlap_split (s 0) (s k) (s (k + 1)) l u
        (hs (Nat.zero_le k)) (hs (Nat.le_succ k)) hlu).symm

theorem overlap_unit (l u : ℝ) (hl : 0 ≤ l) (hlu : l ≤ u) (hu : u ≤ 1) :
    overlap 0 1 l u = u - l := by
  unfold overlap
  rw [min_eq_right hu, max_eq_right hl, max_eq_right (sub_nonneg.mpr hlu)]

theorem overlap_positive_endpoints (a b l u : ℝ) (h : 0 < overlap a b l u) :
    l < b ∧ a < u := by
  simp only [overlap, lt_max_iff, lt_self_iff_false, false_or, sub_pos] at h
  exact ⟨(le_max_right a l).trans_lt (h.trans_le (min_le_left b u)),
    (le_max_left a l).trans_lt (h.trans_le (min_le_right b u))⟩

theorem two_positive_intervals_give_break
    (a b c d l u : ℝ) (hbc : b ≤ c)
    (hfirst : 0 < overlap a b l u) (hsecond : 0 < overlap c d l u) :
    l < b ∧ b < u := by
  have h1 := overlap_positive_endpoints a b l u hfirst
  have h2 := overlap_positive_endpoints c d l u hsecond
  exact ⟨h1.1, hbc.trans_lt h2.2⟩

theorem slice_break_count (j ell : ℕ)
    (breaks : Fin j → ℝ) (lo hi : Fin ell → ℝ)
    (separated : ∀ r t : Fin ell, r < t → hi r ≤ lo t)
    (bad : Finset (Fin ell))
    (contains : ∀ r ∈ bad, ∃ a : Fin j, lo r < breaks a ∧ breaks a < hi r) :
    bad.card ≤ j := by
  classical
  let witness : {r // r ∈ bad} → Fin j :=
    fun r => Classical.choose (contains r.val r.property)
  have hw (r : {r // r ∈ bad}) :
      lo r.val < breaks (witness r) ∧ breaks (witness r) < hi r.val :=
    Classical.choose_spec (contains r.val r.property)
  have hinj : Function.Injective witness := by
    intro r t heq
    apply Subtype.ext
    by_contra hne
    rcases lt_or_gt_of_ne hne with hrt | htr
    · have hs := separated r.val t.val hrt
      have hr := hw r
      have ht := hw t
      rw [heq] at hr
      linarith
    · have hs := separated t.val r.val htr
      have hr := hw r
      have ht := hw t
      rw [heq] at hr
      linarith
  simpa using Fintype.card_le_of_injective witness hinj

theorem restricted_factor_hits_vertex (ell j n : ℕ)
    (restricted bad : Finset (Fin ell))
    (hrestricted : n ≤ restricted.card) (hbad : bad.card ≤ j) (hjn : j < n) :
    ∃ r ∈ restricted, r ∉ bad := by
  classical
  by_contra h
  have hsub : restricted ⊆ bad := by
    intro r hr
    by_contra hnot
    exact h ⟨r, hr, hnot⟩
  have hcard := Finset.card_le_card hsub
  omega

end CoherentAdams

#print axioms CoherentAdams.overlap_split
#print axioms CoherentAdams.overlap_telescope
#print axioms CoherentAdams.two_positive_intervals_give_break
#print axioms CoherentAdams.slice_break_count
#print axioms CoherentAdams.restricted_factor_hits_vertex
