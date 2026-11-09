import Mathlib

noncomputable section

open scoped BigOperators

namespace SelectorCertificate

variable {X : Type*} [Fintype X] [DecidableEq X]

def totalCap (w : X → ℝ) (u : ℝ) : ℝ :=
  ∑ x, min (w x) u

def capturedCap (w : X → ℝ) (z : X → ℕ) (i : ℕ) (u : ℝ) : ℝ :=
  ∑ x, if z x ≤ i then min (w x) u else 0

def crossings (a z : X → ℕ) (i : ℕ) : ℝ :=
  ∑ x, if z x ≤ i ∧ i < a x then 1 else 0

def slack (w : X → ℝ) (d : ℝ) (a z : X → ℕ) (i : ℕ) (u : ℝ) : ℝ :=
  capturedCap w z i u - (1 - d) * totalCap w u - crossings a z i * u

def FeasibleWith (s : ℕ) (d : ℕ → ℝ) (w : X → ℝ)
    (a z : X → ℕ) (u : ℕ → ℝ) : Prop :=
  (∀ x, z x ≤ a x) ∧
  ∀ i, 1 ≤ i → i ≤ s →
    0 ≤ u i ∧ u i ≤ 1 ∧
    (∀ x, u i < w x → z x ≤ i) ∧
    0 ≤ slack w (d i) a z i (u i)

def moveLength (a z : X → ℕ) : ℕ :=
  ∑ x, (a x - z x)

def ChangesIn (H₀ : Set X) (a z : X → ℕ) : Prop :=
  ∀ x, z x < a x → x ∈ H₀

def HasWitness {T : Type*} (valid : T → Prop) (weight : T → X → ℝ)
    (s : ℕ) (d : ℕ → ℝ) (a z : X → ℕ) : Prop :=
  (∀ x, 1 ≤ z x) ∧ ∃ h, valid h ∧ ∃ u, FeasibleWith s d (weight h) a z u

def Minimal {T : Type*} (valid : T → Prop) (weight : T → X → ℝ)
    (s : ℕ) (d : ℕ → ℝ) (a : X → ℕ) (H₀ : Set X) (z : X → ℕ) : Prop :=
  HasWitness valid weight s d a z ∧ ChangesIn H₀ a z ∧
  ∀ z', HasWitness valid weight s d a z' → ChangesIn H₀ a z' →
    moveLength a z ≤ moveLength a z'

def delay (z : X → ℕ) (x : X) : X → ℕ :=
  Function.update z x (z x + 1)

theorem capturedCap_delay (w : X → ℝ) (z : X → ℕ)
    (x : X) (i : ℕ) (u : ℝ) :
    capturedCap w (delay z x) i u =
      capturedCap w z i u - if z x = i then min (w x) u else 0 := by
  classical
  have hp (y : X) :
      (if delay z x y ≤ i then min (w y) u else 0) =
      (if z y ≤ i then min (w y) u else 0) -
        (if y = x then (if z x = i then min (w x) u else 0) else 0) := by
    by_cases hy : y = x
    · subst y
      simp only [delay, Function.update_self]
      by_cases hi : z x = i
      · subst i
        simp
      · have hh : (z x + 1 ≤ i) ↔ (z x ≤ i) := by omega
        simp [hi, hh]
    · simp [delay, hy]
  unfold capturedCap
  simp_rw [hp]
  rw [Finset.sum_sub_distrib]
  simp

theorem crossings_delay (a z : X → ℕ) (x : X) (i : ℕ)
    (hx : z x < a x) :
    crossings a (delay z x) i =
      crossings a z i - if z x = i then 1 else 0 := by
  classical
  have hp (y : X) :
      (if delay z x y ≤ i ∧ i < a y then (1 : ℝ) else 0) =
      (if z y ≤ i ∧ i < a y then (1 : ℝ) else 0) -
        (if y = x then (if z x = i then (1 : ℝ) else 0) else 0) := by
    by_cases hy : y = x
    · subst y
      simp only [delay, Function.update_self]
      by_cases hi : z x = i
      · subst i
        simp [hx]
      · have hh : (z x + 1 ≤ i) ↔ (z x ≤ i) := by omega
        simp [hi, hh]
    · simp [delay, hy]
  unfold crossings
  simp_rw [hp]
  rw [Finset.sum_sub_distrib]
  simp

theorem moveLength_delay (a z : X → ℕ) (x : X) (hx : z x < a x) :
    moveLength a (delay z x) + 1 = moveLength a z := by
  classical
  have hp (y : X) :
      (a y - delay z x y) + (if y = x then 1 else 0) = a y - z y := by
    by_cases hy : y = x
    · subst y
      simpa [delay] using
        (show (a x - (z x + 1)) + 1 = a x - z x from by omega)
    · simp [delay, hy]
  have hsum := Finset.sum_congr (s₁ := Finset.univ) rfl (fun y _ => hp y)
  simpa [moveLength, Finset.sum_add_distrib] using hsum

omit [Fintype X] in
theorem delay_le (a z : X → ℕ) (x : X)
    (hza : ∀ y, z y ≤ a y) (hx : z x < a x) :
    ∀ y, delay z x y ≤ a y := by
  intro y
  by_cases hy : y = x
  · subst y
    simp only [delay, Function.update_self]
    omega
  · simpa [delay, Function.update_of_ne hy] using hza y

omit [Fintype X] in
theorem changesIn_delay (H₀ : Set X) (a z : X → ℕ) (x : X)
    (hc : ChangesIn H₀ a z) : ChangesIn H₀ a (delay z x) := by
  intro y hy
  apply hc y
  by_cases hxy : y = x
  · subst y
    simp only [delay, Function.update_self] at hy
    omega
  · simpa [delay, Function.update_of_ne hxy] using hy

theorem feasible_delay (s : ℕ) (d : ℕ → ℝ) (w : X → ℝ)
    (a z : X → ℕ) (u : ℕ → ℝ) (x : X)
    (hf : FeasibleWith s d w a z u) (hx : z x < a x)
    (hsmall : w x ≤ u (z x)) :
    FeasibleWith s d w a (delay z x) u := by
  classical
  refine ⟨delay_le a z x hf.1 hx, ?_⟩
  intro i hi his
  obtain ⟨hu0, hu1, hinc, hslack⟩ := hf.2 i hi his
  refine ⟨hu0, hu1, ?_, ?_⟩
  · intro y hy
    by_cases hxy : y = x
    · subst y
      have hzi := hinc x hy
      have hne : z x ≠ i := by
        intro he
        subst i
        exact (not_lt_of_ge hsmall) hy
      simp only [delay, Function.update_self]
      omega
    · simpa [delay, Function.update_of_ne hxy] using hinc y hy
  · have hs :
        slack w (d i) a (delay z x) i (u i) =
        slack w (d i) a z i (u i) +
          if z x = i then u i - min (w x) (u i) else 0 := by
      unfold slack
      rw [capturedCap_delay, crossings_delay a z x i hx]
      by_cases he : z x = i <;> simp only [he, if_true, if_false] <;> ring
    rw [hs]
    split_ifs
    · linarith [min_le_right (w x) (u i)]
    · simpa using hslack

theorem minimal_forces_high {T : Type*} (valid : T → Prop)
    (weight : T → X → ℝ) (s : ℕ) (d : ℕ → ℝ)
    (a z : X → ℕ) (H₀ : Set X)
    (hm : Minimal valid weight s d a H₀ z)
    (h : T) (hv : valid h) (u : ℕ → ℝ)
    (hf : FeasibleWith s d (weight h) a z u)
    (x : X) (_hi : 1 ≤ z x) (_his : z x ≤ s) (hx : z x < a x) :
    u (z x) < weight h x := by
  by_contra hn
  have hsmall : weight h x ≤ u (z x) := le_of_not_gt hn
  have hf' := feasible_delay s d (weight h) a z u x hf hx hsmall
  have hpos : ∀ y, 1 ≤ delay z x y := by
    intro y
    by_cases hy : y = x
    · subst y
      simp only [delay, Function.update_self]
      omega
    · simpa [delay, Function.update_of_ne hy] using hm.1.1 y
  have hmin := hm.2.2 (delay z x) ⟨hpos, h, hv, u, hf'⟩
    (changesIn_delay H₀ a z x hm.2.1)
  have hlen := moveLength_delay a z x hx
  omega

def cell (a z : X → ℕ) (j h : ℕ) : Finset X :=
  Finset.univ.filter (fun x => z x = j ∧ a x = h)

def profile (a z : X → ℕ) (j h : ℕ) : ℕ :=
  (cell a z j h).card

def crossingPairs (B i : ℕ) : Finset (ℕ × ℕ) :=
  ((Finset.range (B + 1)).product (Finset.range (B + 1))).filter
    (fun jh => jh.1 ≤ i ∧ i < jh.2)

omit [DecidableEq X] in
theorem crossings_eq_profile (a z : X → ℕ) (B i : ℕ)
    (ha : ∀ x, a x ≤ B) (hz : ∀ x, z x ≤ B) :
    crossings a z i =
      ∑ jh ∈ crossingPairs B i, (profile a z jh.1 jh.2 : ℝ) := by
  classical
  have h := Finset.sum_fiberwise_eq_sum_filter
    (Finset.univ : Finset X) (crossingPairs B i)
    (fun x => (z x, a x)) (fun _ => (1 : ℝ))
  have hl :
      (∑ jh ∈ crossingPairs B i,
        ∑ x ∈ Finset.univ.filter (fun x => (z x, a x) = jh), (1 : ℝ)) =
      ∑ jh ∈ crossingPairs B i, (profile a z jh.1 jh.2 : ℝ) := by
    apply Finset.sum_congr rfl
    intro jh _
    rcases jh with ⟨j, h⟩
    simp [profile, cell, Prod.mk.injEq]
  have hr :
      (∑ x ∈ Finset.univ.filter
        (fun x => (z x, a x) ∈ crossingPairs B i), (1 : ℝ)) =
      crossings a z i := by
    unfold crossings
    rw [Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro x _
    have hza : z x < B + 1 := by have := hz x; omega
    have haa : a x < B + 1 := by have := ha x; omega
    simp [crossingPairs, hza, haa]
  exact hr.symm.trans (h.symm.trans hl)

omit [DecidableEq X] in
theorem same_profile_crossings (a b z : X → ℕ) (B : ℕ)
    (ha : ∀ x, a x ≤ B) (hb : ∀ x, b x ≤ B) (hz : ∀ x, z x ≤ B)
    (hp : ∀ j h, j < h → profile a z j h = profile b z j h) :
    ∀ i, crossings a z i = crossings b z i := by
  intro i
  rw [crossings_eq_profile a z B i ha hz, crossings_eq_profile b z B i hb hz]
  apply Finset.sum_congr rfl
  intro jh hjh
  have hc := (Finset.mem_filter.mp hjh).2
  have hjh' : jh.1 < jh.2 := by omega
  rw [hp jh.1 jh.2 hjh']

omit [DecidableEq X] in
theorem feasible_same_crossings (s : ℕ) (d : ℕ → ℝ) (w : X → ℝ)
    (a b z : X → ℕ) (u : ℕ → ℝ)
    (hf : FeasibleWith s d w a z u)
    (hzb : ∀ x, z x ≤ b x)
    (hc : ∀ i, crossings a z i = crossings b z i) :
    FeasibleWith s d w b z u := by
  refine ⟨hzb, ?_⟩
  intro i hi his
  obtain ⟨hu0, hu1, hinc, hs⟩ := hf.2 i hi his
  refine ⟨hu0, hu1, hinc, ?_⟩
  simpa only [slack, ← hc i] using hs

theorem common_witness_reconstruction {T : Type*} (valid : T → Prop)
    (weight : T → X → ℝ) (s B : ℕ) (d : ℕ → ℝ)
    (a b z : X → ℕ) (H₀ : Set X)
    (hm : Minimal valid weight s d b H₀ z)
    (ha : ∀ x, a x ≤ B) (hb : ∀ x, b x ≤ B) (hz : ∀ x, z x ≤ B)
    (hzb : ∀ x, z x ≤ b x)
    (hp : ∀ j h, j < h → profile a z j h = profile b z j h)
    (h : T) (hv : valid h) (u : ℕ → ℝ)
    (hf : FeasibleWith s d (weight h) a z u) :
    FeasibleWith s d (weight h) b z u ∧
    ∀ x, 1 ≤ z x → z x ≤ s → z x < b x → u (z x) < weight h x := by
  have hf' := feasible_same_crossings s d (weight h) a b z u hf hzb
    (same_profile_crossings a b z B ha hb hz hp)
  exact ⟨hf', fun x hi his hx =>
    minimal_forces_high valid weight s d b z H₀ hm h hv u hf' x hi his hx⟩

omit [DecidableEq X] in
theorem encoding_injective (a b z : X → ℕ)
    (ha : ∀ x, z x ≤ a x) (hb : ∀ x, z x ≤ b x)
    (he : ∀ i h, i < h → cell a z i h = cell b z i h) : a = b := by
  funext x
  by_cases hax : z x < a x
  · have hm : x ∈ cell a z (z x) (a x) := by simp [cell]
    rw [he (z x) (a x) hax] at hm
    exact ((Finset.mem_filter.mp hm).2.2).symm
  · by_cases hbx : z x < b x
    · have hm : x ∈ cell b z (z x) (b x) := by simp [cell]
      rw [← he (z x) (b x) hbx] at hm
      exact (Finset.mem_filter.mp hm).2.2
    · have := ha x
      have := hb x
      omega

def capScore (w : X → ℝ) (d : ℝ) (A : Finset X) (u : ℝ) : ℝ :=
  ∑ x, min (w x) u * ((if x ∈ A then 1 else 0) - (1 - d))

def cutoffSet (w : X → ℝ) (d : ℝ) (A : Finset X) (m : ℝ) : Set ℝ :=
  Set.Icc 0 1 ∩
    ({u | ∀ x, x ∉ A → w x ≤ u} ∩ {u | 0 ≤ capScore w d A u - m * u})

def highSet (w : X → ℝ) (u : ℝ) : Finset X :=
  Finset.univ.filter (fun x => u < w x)

theorem capScore_cumulative (w : X → ℝ) (d : ℝ) (z : X → ℕ)
    (i : ℕ) (u : ℝ) :
    capScore w d (Finset.univ.filter (fun x => z x ≤ i)) u =
      capturedCap w z i u - (1 - d) * totalCap w u := by
  unfold capScore capturedCap totalCap
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro x _
  simp only [Finset.mem_filter, Finset.mem_univ, true_and]
  split_ifs <;> ring

theorem untruncation_capture (w : X → ℝ) (d : ℝ) (A : Finset X) (u : ℝ)
    (hwsum : ∑ x, w x = 1) (hd : 0 ≤ d)
    (hinc : ∀ x, u < w x → x ∈ A)
    (hs : 0 ≤ capScore w d A u) :
    1 - d ≤ ∑ x ∈ A, w x := by
  have hsum :
      capScore w d A u ≤
      ∑ x, w x * ((if x ∈ A then 1 else 0) - (1 - d)) := by
    apply Finset.sum_le_sum
    intro x _
    by_cases hx : x ∈ A
    · simp only [hx, if_true, sub_sub_cancel]
      exact mul_le_mul_of_nonneg_right (min_le_left (w x) u) hd
    · have hwu : w x ≤ u := by
        by_contra hn
        exact hx (hinc x (lt_of_not_ge hn))
      rw [min_eq_left hwu]
  have heq :
      (∑ x, w x * ((if x ∈ A then 1 else 0) - (1 - d))) =
      (∑ x ∈ A, w x) - (1 - d) := by
    have hp (x : X) :
        w x * ((if x ∈ A then 1 else 0) - (1 - d)) =
        (if x ∈ A then w x else 0) - w x * (1 - d) := by
      split_ifs <;> ring
    simp_rw [hp]
    rw [Finset.sum_sub_distrib, ← Finset.sum_mul, hwsum]
    simp [← Finset.sum_filter]
  rw [heq] at hsum
  linarith

theorem unchanged_capture (s : ℕ) (d : ℕ → ℝ) (w : X → ℝ)
    (a : X → ℕ) (u : ℕ → ℝ)
    (hwsum : ∑ x, w x = 1)
    (hd : ∀ i, 1 ≤ i → i ≤ s → 0 ≤ d i)
    (hf : FeasibleWith s d w a a u) :
    ∀ i, 1 ≤ i → i ≤ s →
      1 - d i ≤ ∑ x ∈ Finset.univ.filter (fun x => a x ≤ i), w x := by
  intro i hi his
  obtain ⟨_, _, hinc, hs⟩ := hf.2 i hi his
  have hc : crossings a a i = 0 := by
    unfold crossings
    apply Finset.sum_eq_zero
    intro x _
    have hn : ¬ (a x ≤ i ∧ i < a x) := by omega
    simp [hn]
  apply untruncation_capture w (d i)
    (Finset.univ.filter (fun x => a x ≤ i)) (u i) hwsum (hd i hi his)
  · intro x hx
    simpa using hinc x hx
  · rw [capScore_cumulative]
    simpa only [slack, hc, zero_mul, sub_zero] using hs

theorem maximal_cutoff_exists (w : X → ℝ) (d : ℝ) (A : Finset X) (m : ℝ)
    (hne : (cutoffSet w d A m).Nonempty) :
    ∃ u, IsGreatest (cutoffSet w d A m) u := by
  have hc : Continuous (fun u => capScore w d A u - m * u) := by
    unfold capScore
    fun_prop
  have hi : IsClosed {u : ℝ | ∀ x, x ∉ A → w x ≤ u} := by
    have he :
        {u : ℝ | ∀ x, x ∉ A → w x ≤ u} =
        ⋂ x : X, ⋂ _h : x ∉ A, {u : ℝ | w x ≤ u} := by
      ext u
      simp
    rw [he]
    exact isClosed_iInter fun x =>
      isClosed_iInter fun _ => isClosed_le continuous_const continuous_id
  have hs : IsClosed {u : ℝ | 0 ≤ capScore w d A u - m * u} :=
    isClosed_le continuous_const hc
  exact (isCompact_Icc.inter_right (hi.inter hs)).exists_isGreatest hne

theorem maximal_cutoff_count (w : X → ℝ) (d : ℝ) (A : Finset X) (m u : ℝ)
    (hw : ∀ x, w x ≤ 1) (hm : 0 ≤ m)
    (hu : IsGreatest (cutoffSet w d A m) u) :
    d * (highSet w u).card ≤ m := by
  classical
  obtain ⟨⟨hu0, hu1⟩, hinc, hs⟩ := hu.1
  change 0 ≤ capScore w d A u - m * u at hs
  by_cases huone : u = 1
  · have hempty : highSet w u = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro x hx
      have hx' := (Finset.mem_filter.mp hx).2
      have := hw x
      rw [huone] at hx'
      linarith
    simpa [hempty] using hm
  · have hu_lt : u < 1 := lt_of_le_of_ne hu1 huone
    let C : Finset ℝ :=
      (insert 1 (Finset.univ.image w)).filter (fun v => u < v)
    have h1 : (1 : ℝ) ∈ C := by simp [C, hu_lt]
    have hC : C.Nonempty := ⟨1, h1⟩
    let v := C.min' hC
    have hv_mem : v ∈ C := Finset.min'_mem C hC
    have huv : u < v := (Finset.mem_filter.mp hv_mem).2
    have hv1 : v ≤ 1 := Finset.min'_le C 1 h1
    have hvw : ∀ x, u < w x → v ≤ w x := by
      intro x hx
      apply Finset.min'_le C (w x)
      simp [C, hx]
    have hinA : ∀ x, u < w x → x ∈ A := by
      intro x hx
      by_contra hn
      exact (not_lt_of_ge (hinc x hn)) hx
    have hdiff :
        capScore w d A v - capScore w d A u =
        (v - u) * d * (highSet w u).card := by
      unfold capScore
      rw [← Finset.sum_sub_distrib]
      have hp (x : X) :
          min (w x) v * ((if x ∈ A then 1 else 0) - (1 - d)) -
            min (w x) u * ((if x ∈ A then 1 else 0) - (1 - d)) =
          if u < w x then (v - u) * d else 0 := by
        by_cases hx : u < w x
        · rw [min_eq_right (hvw x hx), min_eq_right (le_of_lt hx)]
          simp only [hinA x hx, if_true, hx]
          ring
        · have hwxu : w x ≤ u := le_of_not_gt hx
          rw [min_eq_left (le_trans hwxu (le_of_lt huv)), min_eq_left hwxu]
          simp [hx]
      simp_rw [hp]
      rw [← Finset.sum_filter]
      simp only [Finset.sum_const, nsmul_eq_mul]
      unfold highSet
      ring
    by_contra hn
    have hbad : m < d * (highSet w u).card := lt_of_not_ge hn
    have hvmem : v ∈ cutoffSet w d A m := by
      refine ⟨⟨le_trans hu0 (le_of_lt huv), hv1⟩, ?_, ?_⟩
      · intro x hx
        exact le_trans (hinc x hx) (le_of_lt huv)
      · change 0 ≤ capScore w d A v - m * v
        have hpos := mul_pos (sub_pos.mpr huv) (sub_pos.mpr hbad)
        nlinarith
    have := hu.2 hvmem
    linarith

theorem power_ratio_le_three (n : ℕ) (hn : 1 ≤ n) :
    ((n : ℝ) + 1) ^ n ≤ 3 * (n : ℝ) ^ n := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hb0 : (0 : ℝ) ≤ 1 / (n : ℝ) + 1 := by positivity
  have hp := pow_le_pow_left₀ hb0 (Real.add_one_le_exp (1 / (n : ℝ))) n
  rw [← Real.exp_nat_mul] at hp
  have he : (n : ℝ) * (1 / (n : ℝ)) = 1 := by field_simp
  rw [he] at hp
  have hexp : Real.exp 1 ≤ 3 := le_of_lt (by linarith [Real.exp_one_lt_d9])
  have hmajor : (1 / (n : ℝ) + 1) ^ n ≤ 3 := le_trans hp hexp
  have hprod := mul_le_mul_of_nonneg_right hmajor (le_of_lt (pow_pos hn0 n))
  have hmul :
      (1 / (n : ℝ) + 1) ^ n * (n : ℝ) ^ n = ((n : ℝ) + 1) ^ n := by
    rw [← mul_pow]
    congr 1
    field_simp
    ring
  simpa only [hmul] using hprod

theorem factorial_majorant (n : ℕ) (hn : 1 ≤ n) :
    (n : ℝ) ^ n ≤ (n.factorial : ℝ) * 3 ^ (n - 1) := by
  induction n, hn using Nat.le_induction with
  | base => norm_num
  | succ n hn ih =>
    have hn0 : (0 : ℝ) ≤ (n : ℝ) + 1 := by positivity
    have hpow := power_ratio_le_three n hn
    have he : (3 : ℝ) ^ n = 3 * 3 ^ (n - 1) := by
      conv_lhs => rw [show n = (n - 1) + 1 by omega, pow_succ]
      ring
    have hstep :
        ((n : ℝ) + 1) ^ (n + 1) ≤
        ((n : ℝ) + 1) * (n.factorial : ℝ) * 3 ^ n := calc
      ((n : ℝ) + 1) ^ (n + 1) =
          ((n : ℝ) + 1) * ((n : ℝ) + 1) ^ n := by rw [pow_succ]; ring
      _ ≤ ((n : ℝ) + 1) * (3 * (n : ℝ) ^ n) :=
        mul_le_mul_of_nonneg_left hpow hn0
      _ ≤ ((n : ℝ) + 1) * (3 * ((n.factorial : ℝ) * 3 ^ (n - 1))) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left ih (by norm_num)) hn0
      _ = ((n : ℝ) + 1) * (n.factorial : ℝ) * 3 ^ n := by rw [he]; ring
    simpa only [Nat.factorial_succ, Nat.cast_mul, Nat.cast_add, Nat.cast_one,
      Nat.add_sub_cancel] using hstep

theorem factorial_profile_sum {I : Type*} [DecidableEq I]
    (C : Finset I) (r : I → ℝ) (t : ℕ) :
    (∑ n ∈ C.piAntidiag t,
      ((t : ℝ) ^ t / (t.factorial : ℝ)) *
        (Nat.multinomial C n : ℝ) * ∏ c ∈ C, r c ^ n c) =
    ((t : ℝ) ^ t / (t.factorial : ℝ)) * (∑ c ∈ C, r c) ^ t := by
  rw [Finset.sum_pow_eq_sum_piAntidiag, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro n _
  ring

theorem finite_geometric_bound (q : ℝ) (N : ℕ)
    (hq0 : 0 ≤ q) (hq1 : q < 1) :
    (∑ k ∈ Finset.range N, q ^ k) ≤ 1 / (1 - q) := by
  apply (le_div_iff₀ (by linarith : 0 < 1 - q)).2
  have hg := geom_sum_mul q N
  have hp := pow_nonneg hq0 N
  nlinarith

def profilePolynomial (N : ℕ) (R : ℝ) : ℝ :=
  ∑ k ∈ Finset.range N,
    (((k + 1 : ℕ) : ℝ) ^ (k + 1) / ((k + 1).factorial : ℝ)) * R ^ (k + 1)

theorem profile_polynomial_bound (N : ℕ) (R : ℝ)
    (hR0 : 0 ≤ R) (hR : 3 * R < 1) :
    profilePolynomial N R ≤ R / (1 - 3 * R) := by
  have hsum :
      profilePolynomial N R ≤
      R * ∑ k ∈ Finset.range N, (3 * R) ^ k := by
    unfold profilePolynomial
    rw [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro k _
    have hfpos : (0 : ℝ) < (k + 1).factorial :=
      by exact_mod_cast Nat.factorial_pos (k + 1)
    have hcoef :
        ((k + 1 : ℕ) : ℝ) ^ (k + 1) / ((k + 1).factorial : ℝ) ≤
        (3 : ℝ) ^ k := by
      apply (div_le_iff₀ hfpos).2
      simpa [mul_comm] using factorial_majorant (k + 1) (by omega)
    have hterm := mul_le_mul_of_nonneg_right hcoef (pow_nonneg hR0 (k + 1))
    calc
      _ ≤ (3 : ℝ) ^ k * R ^ (k + 1) := hterm
      _ = R * (3 * R) ^ k := by rw [mul_pow, pow_succ]; ring
  have hg := finite_geometric_bound (3 * R) N (by positivity) hR
  have hh := mul_le_mul_of_nonneg_left hg hR0
  exact le_trans hsum (by simpa only [mul_one_div] using hh)

theorem original_palette_bound (R bad : ℝ)
    (_hR0 : 0 ≤ R) (hR : R < 1 / 127)
    (hbad : bad ≤ 2 * R / (1 - 3 * R)) : bad < 1 / 62 := by
  have hden : 0 < 1 - 3 * R := by linarith
  have hb : 2 * R / (1 - 3 * R) < (1 : ℝ) / 62 := by
    apply (div_lt_iff₀ hden).2
    linarith
  exact lt_of_le_of_lt hbad hb

theorem improved_palette_bound (R bad : ℝ)
    (_hR0 : 0 ≤ R) (hR : R < 1 / 23)
    (hbad : bad ≤ 2 * R / (1 - 3 * R)) : bad < 1 / 10 := by
  have hden : 0 < 1 - 3 * R := by linarith
  have hb : 2 * R / (1 - 3 * R) < (1 : ℝ) / 10 := by
    apply (div_lt_iff₀ hden).2
    linarith
  exact lt_of_le_of_lt hbad hb

end SelectorCertificate
