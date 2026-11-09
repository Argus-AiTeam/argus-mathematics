import Mathlib

open Finset
open scoped BigOperators

namespace HypergraphCapture

noncomputable section

def vertices {α : Type*} [DecidableEq α] (S : Finset (Finset α)) : Finset α :=
  S.biUnion id

def degree {α : Type*} [DecidableEq α] (S : Finset (Finset α)) (u : α) : ℕ :=
  (S.filter fun e => u ∈ e).card

def captured {α : Type*} [DecidableEq α] (S : Finset (Finset α))
    (B : Finset α) : Finset (Finset α) :=
  S.filter fun e => (e ∩ B).Nonempty

def blocks (n m : ℕ) : Finset (Finset (Fin n)) :=
  (univ : Finset (Fin n)).powersetCard m

def goodBlocks {n : ℕ} (m : ℕ) (k : ℝ) (S : Finset (Finset (Fin n))) :=
  (blocks n m).filter fun B =>
    1 ≤ (captured S B).card ∧ ((captured S B).card : ℝ) ≤ k

theorem edge_subset_vertices {α : Type*} [DecidableEq α]
    {S : Finset (Finset α)} {e : Finset α} (he : e ∈ S) :
    e ⊆ vertices S := by
  intro u hu
  exact mem_biUnion.mpr ⟨e, he, hu⟩

theorem degree_pos {α : Type*} [DecidableEq α]
    {S : Finset (Finset α)} {u : α} (hu : u ∈ vertices S) :
    0 < degree S u := by
  obtain ⟨e, he, hue⟩ := mem_biUnion.mp hu
  exact card_pos.mpr ⟨e, mem_filter.mpr ⟨he, hue⟩⟩

theorem support_bounds {α : Type*} [DecidableEq α]
    (S : Finset (Finset α)) (r : ℕ) (hunif : ∀ e ∈ S, e.card = r) :
    S.card ≤ (vertices S).card ^ r ∧
      (vertices S).card ≤ r * S.card := by
  constructor
  · calc
      S.card ≤ ((vertices S).powersetCard r).card := card_le_card (by
        intro e he
        exact mem_powersetCard.mpr ⟨edge_subset_vertices he, hunif e he⟩)
      _ = (vertices S).card.choose r := card_powersetCard _ _
      _ ≤ (vertices S).card ^ r := Nat.choose_le_pow _ _
  · simpa [vertices, mul_comm] using
      card_biUnion_le_card_mul S id r (fun e he => (hunif e he).le)

theorem degree_sum {α : Type*} [DecidableEq α]
    (S : Finset (Finset α)) (r : ℕ) (hunif : ∀ e ∈ S, e.card = r) :
    ∑ u ∈ vertices S, degree S u = r * S.card := by
  have h := sum_card_bipartiteAbove_eq_sum_card_bipartiteBelow
    (fun u (e : Finset α) => u ∈ e) (s := vertices S) (t := S)
  have hf : ∀ e ∈ S, (vertices S).filter (fun u => u ∈ e) = e := by
    intro e he
    ext u
    simp only [mem_filter]
    exact ⟨fun h => h.2, fun hu => ⟨edge_subset_vertices he hu, hu⟩⟩
  calc
    ∑ u ∈ vertices S, degree S u =
        ∑ e ∈ S, ((vertices S).filter fun u => u ∈ e).card := h
    _ = ∑ _e ∈ S, r := by
      apply sum_congr rfl
      intro e he
      rw [hf e he, hunif e he]
    _ = r * S.card := by simp [mul_comm]

theorem real_cutoff {r s v : ℕ} {k : ℝ} (hr : 3 ≤ r) (hs : 0 < s)
    (hk : 0 < k) (hsv : s ≤ v ^ r)
    (hsl : (s : ℝ) ≤ (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))) :
    (r : ℝ) * s ≤ k * v := by
  have hrp : (0 : ℝ) < r := by exact_mod_cast (show 0 < r by omega)
  have hr1 : (0 : ℝ) < (r : ℝ) - 1 := by
    have : (3 : ℝ) ≤ r := by exact_mod_cast hr
    linarith
  have hsp : (0 : ℝ) < s := by exact_mod_cast hs
  have hv0 : (0 : ℝ) ≤ v := Nat.cast_nonneg _
  have hb : 0 ≤ ((r : ℝ) - 1) / (r : ℝ) := by positivity
  have hq : 0 ≤ 1 / (r : ℝ) := by positivity
  have hroot := Real.rpow_le_rpow hsp.le
    (show (s : ℝ) ≤ (v : ℝ) ^ r by exact_mod_cast hsv) hq
  rw [← Real.rpow_natCast, ← Real.rpow_mul hv0] at hroot
  have hcancel : (r : ℝ) * (1 / (r : ℝ)) = 1 := by field_simp
  rw [hcancel, Real.rpow_one] at hroot
  have hcut := Real.rpow_le_rpow hsp.le hsl hb
  rw [← Real.rpow_mul (by positivity : 0 ≤ k / (r : ℝ))] at hcut
  have hcancel' :
      (r : ℝ) / ((r : ℝ) - 1) * (((r : ℝ) - 1) / (r : ℝ)) = 1 := by
    field_simp
  rw [hcancel', Real.rpow_one] at hcut
  have hsplit : (s : ℝ) ^ (1 / (r : ℝ)) *
      (s : ℝ) ^ (((r : ℝ) - 1) / (r : ℝ)) = s := by
    rw [← Real.rpow_add hsp]
    have : 1 / (r : ℝ) + ((r : ℝ) - 1) / (r : ℝ) = 1 := by
      field_simp
      ring
    rw [this, Real.rpow_one]
  have hmul := mul_le_mul hroot hcut
    (Real.rpow_nonneg hsp.le _) hv0
  rw [hsplit] at hmul
  calc
    (r : ℝ) * s ≤ (r : ℝ) * ((v : ℝ) * (k / (r : ℝ))) :=
      mul_le_mul_of_nonneg_left hmul hrp.le
    _ = k * v := by field_simp

theorem low_degree_vertex {α : Type*} [DecidableEq α]
    (S : Finset (Finset α)) {r : ℕ} {k : ℝ}
    (hr : 3 ≤ r) (hne : S.Nonempty) (hunif : ∀ e ∈ S, e.card = r)
    (hk : 0 < k)
    (hsl : (S.card : ℝ) ≤ (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))) :
    ∃ u ∈ vertices S, 1 ≤ degree S u ∧ (degree S u : ℝ) ≤ k := by
  have hV : (vertices S).Nonempty := by
    obtain ⟨e, he⟩ := hne
    have hep : 0 < e.card := by rw [hunif e he]; omega
    obtain ⟨u, hu⟩ := card_pos.mp hep
    exact ⟨u, edge_subset_vertices he hu⟩
  have hbound := real_cutoff hr (card_pos.mpr hne) hk
    (support_bounds S r hunif).1 hsl
  have hsum : (∑ u ∈ vertices S, (degree S u : ℝ)) ≤
      ∑ _u ∈ vertices S, k := by
    have heq : (∑ u ∈ vertices S, (degree S u : ℝ)) =
        (r : ℝ) * S.card := by
      exact_mod_cast degree_sum S r hunif
    simpa [heq, sum_const, smul_eq_mul, mul_comm] using hbound
  obtain ⟨u, hu, hdu⟩ := exists_le_of_sum_le hV hsum
  exact ⟨u, hu, degree_pos hu, hdu⟩

theorem choose_incidence {n m : ℕ} (hn : 1 ≤ n) (hm : 1 ≤ m) :
    n * (n - 1).choose (m - 1) = m * n.choose m := by
  have h := Nat.add_one_mul_choose_eq (n - 1) (m - 1)
  simpa only [Nat.sub_add_cancel hn, Nat.sub_add_cancel hm, mul_comm] using h

def pairCount (n m : ℕ) : ℕ :=
  if m = 1 then 0 else (n - 2).choose (m - 2)

theorem containing_card {n m : ℕ} (hm : 1 ≤ m) (u : Fin n) :
    ((blocks n m).filter fun B => u ∈ B).card = (n - 1).choose (m - 1) := by
  simpa [blocks] using card_filter_powersetCard_subset
    ({u} : Finset (Fin n)) univ m (subset_univ _) (by simpa using hm)

theorem pair_card {n m : ℕ} (hm : 1 ≤ m) (u w : Fin n) (huw : u ≠ w) :
    ((blocks n m).filter fun B => u ∈ B ∧ w ∈ B).card = pairCount n m := by
  by_cases hm1 : m = 1
  · subst m
    have he : (blocks n 1).filter (fun B => u ∈ B ∧ w ∈ B) = ∅ := by
      apply eq_empty_iff_forall_notMem.mpr
      intro B hB
      obtain ⟨hB, huB, hwB⟩ := mem_filter.mp hB
      have hBc : B.card = 1 := (mem_powersetCard.mp hB).2
      have hle : ({u, w} : Finset (Fin n)).card ≤ B.card :=
        card_le_card (by
          simpa only [insert_subset_iff, singleton_subset_iff] using And.intro huB hwB)
      simp [huw] at hle
      omega
    simp [pairCount, he]
  · have hm2 : 2 ≤ m := by omega
    simpa [blocks, pairCount, hm1, huw, insert_subset_iff, singleton_subset_iff] using
      card_filter_powersetCard_subset
      ({u, w} : Finset (Fin n)) univ m (subset_univ _) (by simpa [huw] using hm2)

theorem pair_incidence {n m : ℕ} (hn : 2 ≤ n) (hm : 1 ≤ m) :
    (n - 1) * pairCount n m = (m - 1) * (n - 1).choose (m - 1) := by
  by_cases hm1 : m = 1
  · simp [pairCount, hm1]
  · have hm2 : 2 ≤ m := by omega
    have h := choose_incidence (n := n - 1) (m := m - 1) (by omega) (by omega)
    simpa [pairCount, hm1, Nat.sub_sub] using h

def isolatedBlocks {n : ℕ} (m : ℕ) (V : Finset (Fin n)) (u : Fin n) :=
  (blocks n m).filter fun B => B ∩ V = {u}

theorem isolation_count {n m : ℕ} (hm : 1 ≤ m)
    (V : Finset (Fin n)) (u : Fin n) (hu : u ∈ V) :
    (n - 1).choose (m - 1) ≤
      (isolatedBlocks m V u).card + (V.card - 1) * pairCount n m := by
  let A := (blocks n m).filter fun B => u ∈ B
  let D := (V.erase u).biUnion fun w =>
    (blocks n m).filter fun B => u ∈ B ∧ w ∈ B
  have hsub : A ⊆ isolatedBlocks m V u ∪ D := by
    intro B hB
    obtain ⟨hBΩ, huB⟩ := mem_filter.mp hB
    by_cases hI : B ∩ V = {u}
    · exact mem_union_left _ (mem_filter.mpr ⟨hBΩ, hI⟩)
    · have hw : ∃ w ∈ V, w ≠ u ∧ w ∈ B := by
        by_contra! h
        apply hI
        ext w
        simp only [mem_inter, mem_singleton]
        constructor
        · rintro ⟨hwB, hwV⟩
          by_contra hwu
          exact h w hwV hwu hwB
        · rintro rfl
          exact ⟨huB, hu⟩
      obtain ⟨w, hwV, hwu, hwB⟩ := hw
      exact mem_union_right _ (mem_biUnion.mpr
        ⟨w, mem_erase.mpr ⟨hwu, hwV⟩, mem_filter.mpr ⟨hBΩ, huB, hwB⟩⟩)
  have hD : D.card ≤ (V.card - 1) * pairCount n m := by
    simpa only [D, card_erase_of_mem hu] using
      card_biUnion_le_card_mul (V.erase u)
        (fun w => (blocks n m).filter fun B => u ∈ B ∧ w ∈ B)
        (pairCount n m) (fun w hw => (pair_card hm u w
          (Ne.symm (mem_erase.mp hw).1)).le)
  calc
    (n - 1).choose (m - 1) = A.card := (containing_card hm u).symm
    _ ≤ (isolatedBlocks m V u ∪ D).card := card_le_card hsub
    _ ≤ (isolatedBlocks m V u).card + D.card := card_union_le _ _
    _ ≤ _ := Nat.add_le_add_left hD _

theorem uniform_isolation {n m : ℕ} (hn : 2 ≤ n) (hm : 1 ≤ m) (hmn : m ≤ n)
    (V : Finset (Fin n)) (u : Fin n) (hu : u ∈ V) :
    (m : ℝ) / n * (1 - ((V.card : ℝ) - 1) * ((m : ℝ) - 1) / ((n : ℝ) - 1)) ≤
      ((isolatedBlocks m V u).card : ℝ) / (blocks n m).card := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hn1 : (0 : ℝ) < (n : ℝ) - 1 := by
    have : (2 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  have hV1 : 1 ≤ V.card := card_pos.mpr ⟨u, hu⟩
  have hC0 : (0 : ℝ) < (blocks n m).card := by
    exact_mod_cast (card_pos.mpr (powersetCard_nonempty.mpr (by simpa using hmn)) :
      0 < (blocks n m).card)
  have ha : (n : ℝ) * ((n - 1).choose (m - 1) : ℝ) =
      (m : ℝ) * (blocks n m).card := by
    have h := choose_incidence (n := n) (m := m) (by omega) hm
    simpa [blocks] using (show (n : ℝ) * ((n - 1).choose (m - 1) : ℝ) =
      (m : ℝ) * n.choose m by exact_mod_cast h)
  have hp : ((n : ℝ) - 1) * (pairCount n m : ℝ) =
      ((m : ℝ) - 1) * ((n - 1).choose (m - 1) : ℝ) := by
    have h := pair_incidence hn hm
    have hreal : ((n - 1 : ℕ) : ℝ) * (pairCount n m : ℝ) =
        ((m - 1 : ℕ) : ℝ) * ((n - 1).choose (m - 1) : ℝ) := by exact_mod_cast h
    rw [Nat.cast_sub (by omega), Nat.cast_sub hm] at hreal
    simpa using hreal
  have hc : ((n - 1).choose (m - 1) : ℝ) ≤
      (isolatedBlocks m V u).card + ((V.card : ℝ) - 1) * (pairCount n m : ℝ) := by
    have h := isolation_count hm V u hu
    exact_mod_cast h
  have ha' : ((n - 1).choose (m - 1) : ℝ) =
      ((m : ℝ) * (blocks n m).card) / n :=
    (eq_div_iff hn0.ne').mpr (by nlinarith [ha])
  have hp' : (pairCount n m : ℝ) =
      (((m : ℝ) - 1) * ((n - 1).choose (m - 1) : ℝ)) / ((n : ℝ) - 1) :=
    (eq_div_iff hn1.ne').mpr (by nlinarith [hp])
  apply (le_div_iff₀ hC0).mpr
  calc
    _ = ((n - 1).choose (m - 1) : ℝ) -
        ((V.card : ℝ) - 1) * (pairCount n m : ℝ) := by
      rw [hp', ha']
      ring
    _ ≤ _ := by linarith

theorem captured_at_isolated {n : ℕ} (S : Finset (Finset (Fin n)))
    (B : Finset (Fin n)) (u : Fin n) (hI : B ∩ vertices S = {u}) :
    (captured S B).card = degree S u := by
  congr 1
  ext e
  simp only [captured, mem_filter]
  constructor
  · rintro ⟨he, w, hw⟩
    have hw' : w ∈ B ∩ vertices S :=
      mem_inter.mpr ⟨(mem_inter.mp hw).2, edge_subset_vertices he (mem_inter.mp hw).1⟩
    rw [hI, mem_singleton] at hw'
    exact ⟨he, hw' ▸ (mem_inter.mp hw).1⟩
  · rintro ⟨he, hue⟩
    have huB : u ∈ B := by
      have : u ∈ B ∩ vertices S := by rw [hI]; exact mem_singleton_self _
      exact (mem_inter.mp this).1
    exact ⟨he, u, mem_inter.mpr ⟨hue, huB⟩⟩

theorem hypergraph_capture {n r m : ℕ} {k : ℝ}
    (hr : 3 ≤ r) (hrn : r ≤ n) (hm : 1 ≤ m) (hmn : m ≤ n)
    (hk : 0 < k) (S : Finset (Finset (Fin n))) (hne : S.Nonempty)
    (hunif : ∀ e ∈ S, e.card = r)
    (hsl : (S.card : ℝ) ≤ (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)))
    (hcondition : (r : ℝ) * (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) *
      ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2) :
    (m : ℝ) / (2 * n) ≤ ((goodBlocks m k S).card : ℝ) / (blocks n m).card := by
  obtain ⟨u, hu, hd1, hdk⟩ := low_degree_vertex S hr hne hunif hk hsl
  have hsub : isolatedBlocks m (vertices S) u ⊆ goodBlocks m k S := by
    intro B hB
    obtain ⟨hBΩ, hI⟩ := mem_filter.mp hB
    apply mem_filter.mpr
    refine ⟨hBΩ, ?_⟩
    rw [captured_at_isolated S B u hI]
    exact ⟨hd1, hdk⟩
  have hn0 : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hm0 : (0 : ℝ) ≤ (m : ℝ) - 1 := by
    have : (1 : ℝ) ≤ m := by exact_mod_cast hm
    linarith
  have hn1 : (0 : ℝ) < (n : ℝ) - 1 := by
    have : (3 : ℝ) ≤ n := by exact_mod_cast (show 3 ≤ n by omega)
    linarith
  have hv : ((vertices S).card : ℝ) ≤
      (r : ℝ) * (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) := by
    have hvs : ((vertices S).card : ℝ) ≤ (r : ℝ) * S.card := by
      exact_mod_cast (support_bounds S r hunif).2
    exact hvs.trans (mul_le_mul_of_nonneg_left hsl (Nat.cast_nonneg _))
  have hhalf : (((vertices S).card : ℝ) - 1) *
      ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2 := by
    apply le_trans _ hcondition
    apply div_le_div_of_nonneg_right _ hn1.le
    exact mul_le_mul_of_nonneg_right (by linarith [hv]) hm0
  calc
    (m : ℝ) / (2 * n) = (m : ℝ) / n * (1 / 2) := by ring
    _ ≤ (m : ℝ) / n * (1 - (((vertices S).card : ℝ) - 1) *
        ((m : ℝ) - 1) / ((n : ℝ) - 1)) :=
      mul_le_mul_of_nonneg_left (by linarith [hhalf]) (div_nonneg (Nat.cast_nonneg _) hn0.le)
    _ ≤ ((isolatedBlocks m (vertices S) u).card : ℝ) / (blocks n m).card :=
      uniform_isolation (by omega) hm hmn (vertices S) u hu
    _ ≤ ((goodBlocks m k S).card : ℝ) / (blocks n m).card :=
      div_le_div_of_nonneg_right (by exact_mod_cast card_le_card hsub) (Nat.cast_nonneg _)

theorem empty_support_range {n r : ℕ} {k : ℝ}
    (hL : (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) < 1)
    (S : Finset (Finset (Fin n)))
    (hsl : (S.card : ℝ) ≤ (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))) :
    S = ∅ := by
  apply card_eq_zero.mp
  have : (S.card : ℝ) < 1 := hsl.trans_lt hL
  have : S.card < 1 := by exact_mod_cast this
  omega

#print axioms hypergraph_capture
#print axioms empty_support_range

end

end HypergraphCapture
