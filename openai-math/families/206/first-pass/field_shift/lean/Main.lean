import Mathlib

namespace FieldShift

theorem shift_divisible_of_residue_support
    (E : Set ℤ) (h r c k : ℤ)
    (hne : E.Nonempty)
    (hperiod : h ∣ r)
    (hresidue : ∀ x ∈ E, h ∣ x - c)
    (htranslate : ∀ x ∈ E, ∃ y ∈ E, r ∣ x + k - y) :
    h ∣ k := by
  obtain ⟨x, hx⟩ := hne
  obtain ⟨y, hy, hxy⟩ := htranslate x hx
  have hwrap : h ∣ x + k - y := dvd_trans hperiod hxy
  have hsum : h ∣ (x + k - y) + (y - c) - (x - c) :=
    dvd_sub (dvd_add hwrap (hresidue y hy)) (hresidue x hx)
  have heq : (x + k - y) + (y - c) - (x - c) = k := by ring
  rwa [heq] at hsum

theorem progression_residue
    (h t r t0 j q : ℤ) (ht : h ∣ t) (hr : h ∣ r) :
    h ∣ (t0 + j * t - q * r) - t0 := by
  have hmultiple : h ∣ j * t - q * r :=
    dvd_sub (dvd_mul_of_dvd_right ht j) (dvd_mul_of_dvd_right hr q)
  have heq : (t0 + j * t - q * r) - t0 = j * t - q * r := by ring
  rwa [heq]

theorem progression_no_wrap
    (b t j : ℤ) (ht : 0 < t) (hj0 : 0 ≤ j) (hjb : j < b) :
    0 ≤ j * t ∧ j * t < b * t := by
  exact ⟨mul_nonneg hj0 ht.le, mul_lt_mul_of_pos_right hjb ht⟩

theorem progression_mod_representative
    (b t j : ℤ) (ht : 0 < t) (hj0 : 0 ≤ j) (hjb : j < b) :
    (j * t) % (b * t) = j * t := by
  exact Int.emod_eq_of_lt (progression_no_wrap b t j ht hj0 hjb).1
    (progression_no_wrap b t j ht hj0 hjb).2

theorem progression_distinct_mod
    (b t i j : ℤ) (ht : t ≠ 0)
    (hi : i ∈ Set.Ico 0 b) (hj : j ∈ Set.Ico 0 b) :
    Int.ModEq (b * t) (i * t) (j * t) ↔ i = j := by
  constructor
  · intro hmod
    have hindices := Int.ModEq.mul_right_cancel' ht hmod
    change i % b = j % b at hindices
    simpa only [Int.emod_eq_of_lt hi.1 hi.2, Int.emod_eq_of_lt hj.1 hj.2] using hindices
  · rintro rfl
    exact Int.ModEq.rfl

theorem odd_doubling_modEq_iff
    (b : ℕ) (hb : Odd b) (i j : ℕ) :
    Nat.ModEq b (2 * i) (2 * j) ↔ Nat.ModEq b i j := by
  constructor
  · intro hmod
    exact hmod.cancel_left_of_coprime hb.coprime_two_right
  · intro hmod
    exact hmod.mul_left 2

theorem odd_doubling_distinct_mod
    (b : ℕ) (hb : Odd b) (i j : ℕ) (hi : i < b) (hj : j < b) :
    Nat.ModEq b (2 * i) (2 * j) ↔ i = j := by
  rw [odd_doubling_modEq_iff b hb i j]
  exact ⟨fun hmod => hmod.eq_of_lt_of_lt hi hj, fun h => h ▸ Nat.ModEq.rfl⟩

theorem synchronized_differences_add
    (h a a1 s : ℤ) (hfirst : h ∣ a1 - a) (hsecond : h ∣ s - a1) :
    h ∣ s - a := by
  have hsum : h ∣ (a1 - a) + (s - a1) := dvd_add hfirst hsecond
  have heq : (a1 - a) + (s - a1) = s - a := by ring
  rwa [heq] at hsum

theorem commuting_pair_integer_normal_form
    {G : Type*} [Group G] (g d : G) (hcommute : Commute g d)
    {x : G} (hx : x ∈ Subgroup.closure ({g, d} : Set G)) :
    ∃ m n : ℤ, g ^ m * d ^ n = x := by
  induction hx using Subgroup.closure_induction with
  | mem x hx =>
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
    rcases hx with rfl | rfl
    · exact ⟨1, 0, by simp⟩
    · exact ⟨0, 1, by simp⟩
  | one => exact ⟨0, 0, by simp⟩
  | mul x y hx hy ihx ihy =>
    obtain ⟨m, n, rfl⟩ := ihx
    obtain ⟨p, q, rfl⟩ := ihy
    refine ⟨m + p, n + q, ?_⟩
    rw [zpow_add, zpow_add]
    exact (hcommute.zpow_zpow p n).mul_mul_mul_comm (g ^ m) (d ^ q)
  | inv x hx ih =>
    obtain ⟨m, n, rfl⟩ := ih
    refine ⟨-m, -n, ?_⟩
    simpa only [zpow_neg, mul_inv_rev] using (hcommute.zpow_zpow m n).inv_inv.eq

theorem commuting_pair_card_le
    {G : Type*} [Group G] [Finite G] (g d : G) (hcommute : Commute g d) :
    Nat.card (Subgroup.closure ({g, d} : Set G)) ≤ orderOf g * orderOf d := by
  let H := Subgroup.closure ({g, d} : Set G)
  have hg : g ∈ H := Subgroup.subset_closure (by simp)
  have hd : d ∈ H := Subgroup.subset_closure (by simp)
  have hgz : Subgroup.zpowers g ≤ H := by
    rw [Subgroup.zpowers_eq_closure]
    exact (Subgroup.closure_le H).mpr (Set.singleton_subset_iff.mpr hg)
  have hdz : Subgroup.zpowers d ≤ H := by
    rw [Subgroup.zpowers_eq_closure]
    exact (Subgroup.closure_le H).mpr (Set.singleton_subset_iff.mpr hd)
  let f : Subgroup.zpowers g × Subgroup.zpowers d → H :=
    fun p => ⟨p.1.1 * p.2.1, H.mul_mem (hgz p.1.2) (hdz p.2.2)⟩
  have hsurjective : Function.Surjective f := by
    intro x
    obtain ⟨m, n, heq⟩ := commuting_pair_integer_normal_form g d hcommute x.property
    refine ⟨(⟨g ^ m, Subgroup.zpow_mem_zpowers g m⟩,
      ⟨d ^ n, Subgroup.zpow_mem_zpowers d n⟩), ?_⟩
    exact Subtype.ext heq
  calc
    Nat.card H ≤ Nat.card (Subgroup.zpowers g × Subgroup.zpowers d) :=
      Nat.card_le_card_of_surjective f hsurjective
    _ = orderOf g * orderOf d := by
      rw [Nat.card_prod, Nat.card_zpowers, Nat.card_zpowers]

theorem closure_pair_eq_zpowers_of_power
    {G : Type*} [Group G] (g d : G) (v : ℕ) (hpower : g ^ v = d) :
    Subgroup.closure ({g, d} : Set G) = Subgroup.zpowers g := by
  apply le_antisymm
  · refine (Subgroup.closure_le _).mpr ?_
    intro x hx
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
    rcases hx with hx | hx
    · rw [hx]
      exact Subgroup.mem_zpowers g
    · rw [hx, ← hpower]
      exact Subgroup.npow_mem_zpowers g v
  · rw [Subgroup.zpowers_eq_closure]
    apply Subgroup.closure_mono
    exact Set.singleton_subset_iff.mpr (by simp)

theorem field_diagram_group_card_bound
    {G : Type*} [Group G] [Finite G] (g d : G) (v : ℕ)
    (hcommute : Commute g d) (hd : d ^ 2 = 1) (hv : 0 < v)
    (hpower : g ^ v = 1 ∨ g ^ v = d) :
    Nat.card (Subgroup.closure ({g, d} : Set G)) ≤ 2 * v := by
  rcases hpower with hpower | hpower
  · calc
      Nat.card (Subgroup.closure ({g, d} : Set G)) ≤ orderOf g * orderOf d :=
        commuting_pair_card_le g d hcommute
      _ ≤ v * 2 :=
        Nat.mul_le_mul (orderOf_le_of_pow_eq_one hv hpower)
          (orderOf_le_of_pow_eq_one (by decide : 0 < 2) hd)
      _ = 2 * v := Nat.mul_comm v 2
  · have hdouble : g ^ (2 * v) = 1 := by
      calc
        g ^ (2 * v) = (g ^ v) ^ 2 := by rw [← pow_mul, Nat.mul_comm]
        _ = 1 := by rw [hpower, hd]
    rw [closure_pair_eq_zpowers_of_power g d v hpower]
    rw [Nat.card_zpowers]
    exact orderOf_le_of_pow_eq_one (by omega : 0 < 2 * v) hdouble

end FieldShift
