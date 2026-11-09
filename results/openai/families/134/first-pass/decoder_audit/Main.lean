import Mathlib

set_option autoImplicit false
set_option maxHeartbeats 1600000

namespace DecoderAudit

open Finset

attribute [local instance] Classical.propDecidable

def Separated (markers : Finset ℤ) (d : ℤ) : Prop :=
  ∀ x ∈ markers, ∀ y ∈ markers, x ≠ y → d ≤ |x - y|

def First (markers : Finset ℤ) (z m : ℤ) : Prop :=
  m ∈ markers ∧ z ≤ m ∧ ∀ n ∈ markers, z ≤ n → m ≤ n

theorem first_unique {markers : Finset ℤ} {z m n : ℤ}
    (hm : First markers z m) (hn : First markers z n) : m = n :=
  le_antisymm (hm.2.2 n hn.1 hn.2.1) (hn.2.2 m hm.1 hm.2.1)

noncomputable def firstAfter (markers : Finset ℤ) (z : ℤ) : Option ℤ := by
  classical
  exact if h : (markers.filter (z ≤ ·)).Nonempty
    then some ((markers.filter (z ≤ ·)).min' h) else none

theorem firstAfter_some_iff {markers : Finset ℤ} {z m : ℤ} :
    firstAfter markers z = some m ↔ First markers z m := by
  classical
  unfold firstAfter
  split_ifs with h
  · simp only [Option.some.injEq]
    constructor
    · rintro rfl
      have hm := Finset.mem_filter.mp (Finset.min'_mem _ h)
      exact ⟨hm.1, hm.2, fun n hn hzn =>
        Finset.min'_le _ n (Finset.mem_filter.mpr ⟨hn, hzn⟩)⟩
    · intro hm
      have hmin := Finset.mem_filter.mp (Finset.min'_mem _ h)
      exact le_antisymm
        (Finset.min'_le _ m (Finset.mem_filter.mpr ⟨hm.1, hm.2.1⟩))
        (hm.2.2 _ hmin.1 hmin.2)
  · simp only [false_iff]
    intro hm
    exact h ⟨m, Finset.mem_filter.mpr ⟨hm.1, hm.2.1⟩⟩

theorem firstAfter_none_iff {markers : Finset ℤ} {z : ℤ} :
    firstAfter markers z = none ↔ ∀ m ∈ markers, m < z := by
  classical
  unfold firstAfter
  split_ifs with h
  · simp only [false_iff]
    intro hall
    obtain ⟨m, hm⟩ := h
    have hp := Finset.mem_filter.mp hm
    exact (not_lt_of_ge hp.2) (hall m hp.1)
  · simp only [true_iff]
    intro m hm
    by_contra hlt
    exact h ⟨m, Finset.mem_filter.mpr ⟨hm, le_of_not_gt hlt⟩⟩

noncomputable def search (markers : Finset ℤ) (z width : ℤ) : Option ℤ :=
  match firstAfter markers z with
  | none => none
  | some m => if m ≤ z + width then some m else none

def LeftFailure (markers : Finset ℤ) (z radius : ℤ) : Prop :=
  ∃ m ∈ markers, |m - z| ≤ radius

def RightFailure (markers : Finset ℤ) (z width radius : ℤ) : Prop :=
  ∃ m, First markers z m ∧ |m - (z + width)| ≤ radius

def InnerBad (markers : Finset ℤ) (z width ext wiggle : ℤ) : Prop :=
  (∃ v : ℤ, |v| ≤ wiggle ∧ search markers (z + v) width ≠ search markers z width) ∨
  (search markers z width = none ∧
    ∃ m ∈ markers, z ≤ m ∧ m ≤ z + width + ext)

theorem firstAfter_shift {markers : Finset ℤ} {z v radius : ℤ}
    (hv : |v| ≤ radius) (hleft : ¬ LeftFailure markers z radius) :
    firstAfter markers (z + v) = firstAfter markers z := by
  classical
  have hvb := abs_le.mp hv
  have he : markers.filter (z + v ≤ ·) = markers.filter (z ≤ ·) := by
    ext m
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨hm, hzv⟩
      refine ⟨hm, ?_⟩
      by_contra hz
      apply hleft
      exact ⟨m, hm, abs_le.mpr ⟨by omega, by omega⟩⟩
    · rintro ⟨hm, hz⟩
      refine ⟨hm, ?_⟩
      by_contra hzv
      apply hleft
      exact ⟨m, hm, abs_le.mpr ⟨by omega, by omega⟩⟩
  unfold firstAfter
  simp only [he]

theorem inner_bad_cover {markers : Finset ℤ} {z width ext wiggle radius : ℤ}
    (hw : wiggle ≤ radius) (he : ext ≤ radius)
    (hbad : InnerBad markers z width ext wiggle) :
    LeftFailure markers z wiggle ∨ RightFailure markers z width radius := by
  classical
  by_cases hl : LeftFailure markers z wiggle
  · exact Or.inl hl
  right
  rcases hbad with ⟨v, hv, hchange⟩ | ⟨hnone, n, hn, hzn, hne⟩
  · have hs := firstAfter_shift hv hl
    cases hf : firstAfter markers z with
    | none => simp [search, hs, hf] at hchange
    | some m =>
      refine ⟨m, firstAfter_some_iff.mp hf, ?_⟩
      have hvb := abs_le.mp hv
      by_cases h₁ : m ≤ z + v + width <;> by_cases h₂ : m ≤ z + width
      · simp [search, hs, hf, h₁, h₂] at hchange
      · exact abs_le.mpr ⟨by omega, by omega⟩
      · exact abs_le.mpr ⟨by omega, by omega⟩
      · simp [search, hs, hf, h₁, h₂] at hchange
  · cases hf : firstAfter markers z with
    | none =>
      have hh := firstAfter_none_iff.mp hf n hn
      omega
    | some m =>
      have hfirst := firstAfter_some_iff.mp hf
      have hmn := hfirst.2.2 n hn hzn
      have hgt : z + width < m := by
        by_contra hle
        have hle' : m ≤ z + width := by omega
        simp [search, hf, hle'] at hnone
      exact ⟨m, hfirst, abs_le.mpr ⟨by omega, by omega⟩⟩

theorem card_window_le_one {markers : Finset ℤ} {d lo hi : ℤ}
    (hsep : Separated markers d) (hwidth : hi - lo < d) :
    (markers.filter (fun m => lo ≤ m ∧ m ≤ hi)).card ≤ 1 := by
  classical
  apply Finset.card_le_one.mpr
  intro m hm n hn
  have hm' := Finset.mem_filter.mp hm
  have hn' := Finset.mem_filter.mp hn
  by_contra hne
  have hh := hsep m hm'.1 n hn'.1 hne
  have hab : |m - n| < d := abs_lt.mpr ⟨by omega, by omega⟩
  omega

theorem witness_card_le {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (t : Finset ℤ) (relation : ι → ℤ → Prop)
    (hex : ∀ i ∈ s, ∃ m ∈ t, relation i m)
    (huniq : ∀ i ∈ s, ∀ j ∈ s, ∀ m ∈ t, relation i m → relation j m → i = j) :
    s.card ≤ t.card := by
  classical
  let f : s → t := fun i =>
    ⟨Classical.choose (hex i i.property), (Classical.choose_spec (hex i i.property)).1⟩
  apply Finset.card_le_card_of_injective (f := f)
  intro i j hij
  apply Subtype.ext
  apply huniq i i.property j j.property (f i) (f i).property
  · exact (Classical.choose_spec (hex i i.property)).2
  · rw [hij]
    exact (Classical.choose_spec (hex j j.property)).2

theorem first_values_le_two {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (a h d : ℤ) (hsep : Separated markers d) (hshort : 2 * h < d)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h) :
    (markers.filter (fun m => ∃ i ∈ s, First markers (a + delta i) m)).card ≤ 2 := by
  classical
  let left := markers.filter (fun m => a - h ≤ m ∧ m ≤ a + h)
  have hleft : left.card ≤ 1 := card_window_le_one hsep (by omega)
  let after := markers.filter (fun m => a + h < m)
  by_cases ha : after.Nonempty
  · let q := after.min' ha
    have hq := Finset.mem_filter.mp (Finset.min'_mem after ha)
    have hsub :
        markers.filter (fun m => ∃ i ∈ s, First markers (a + delta i) m) ⊆
          left ∪ {q} := by
      intro m hm
      obtain ⟨hmM, i, hi, hfirst⟩ := Finset.mem_filter.mp hm
      have hd := hdelta i hi
      have hz := hfirst.2.1
      by_cases hml : m ≤ a + h
      · apply Finset.mem_union.mpr
        left
        exact Finset.mem_filter.mpr ⟨hmM, by omega, hml⟩
      · have hmq : m = q := by
          apply le_antisymm
          · exact hfirst.2.2 q hq.1 (by omega)
          · exact Finset.min'_le after m (Finset.mem_filter.mpr ⟨hmM, by omega⟩)
        simp [hmq]
    calc
      _ ≤ (left ∪ {q}).card := Finset.card_le_card hsub
      _ ≤ left.card + ({q} : Finset ℤ).card := Finset.card_union_le _ _
      _ ≤ 2 := by simp only [Finset.card_singleton]; omega
  · have hsub :
        markers.filter (fun m => ∃ i ∈ s, First markers (a + delta i) m) ⊆ left := by
      intro m hm
      obtain ⟨hmM, i, hi, hfirst⟩ := Finset.mem_filter.mp hm
      have hd := hdelta i hi
      have hz := hfirst.2.1
      have hml : m ≤ a + h := by
        by_contra hh
        exact ha ⟨m, Finset.mem_filter.mpr ⟨hmM, by omega⟩⟩
      exact Finset.mem_filter.mpr ⟨hmM, by omega, hml⟩
    exact le_trans (Finset.card_le_card hsub) (le_trans hleft (by omega))

theorem left_failure_le_one {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (a h d radius : ℤ) (hsep : Separated markers d)
    (hshort : 2 * h + 2 * radius < d)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hspace : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → 2 * radius < |delta i - delta j|) :
    (s.filter (fun i => LeftFailure markers (a + delta i) radius)).card ≤ 1 := by
  classical
  apply Finset.card_le_one.mpr
  intro i hi j hj
  obtain ⟨his, m, hm, hmi⟩ := Finset.mem_filter.mp hi
  obtain ⟨hjs, n, hn, hnj⟩ := Finset.mem_filter.mp hj
  have hdi := hdelta i his
  have hdj := hdelta j hjs
  have hmb := abs_le.mp hmi
  have hnb := abs_le.mp hnj
  have hmn : m = n := by
    by_contra hh
    have hdist := hsep m hm n hn hh
    have hclose : |m - n| < d := abs_lt.mpr ⟨by omega, by omega⟩
    omega
  subst n
  by_contra hij
  have hdist := hspace i his j hjs hij
  have hclose : |delta i - delta j| ≤ 2 * radius :=
    abs_le.mpr ⟨by omega, by omega⟩
  omega

theorem right_failure_le_two {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta width : ι → ℤ)
    (a h d radius : ℤ) (hsep : Separated markers d) (hshort : 2 * h < d)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hspace : ∀ i ∈ s, ∀ j ∈ s, i ≠ j →
      2 * radius < |(a + delta i + width i) - (a + delta j + width j)|) :
    (s.filter (fun i => RightFailure markers (a + delta i) (width i) radius)).card ≤ 2 := by
  classical
  let t := markers.filter (fun m => ∃ i ∈ s, First markers (a + delta i) m)
  have ht : t.card ≤ 2 := first_values_le_two s markers delta a h d hsep hshort hdelta
  apply le_trans (witness_card_le _ t
    (fun i m => First markers (a + delta i) m ∧
      |m - (a + delta i + width i)| ≤ radius) ?_ ?_) ht
  · intro i hi
    obtain ⟨his, m, hfirst, hclose⟩ := Finset.mem_filter.mp hi
    exact ⟨m, Finset.mem_filter.mpr ⟨hfirst.1, i, his, hfirst⟩, hfirst, hclose⟩
  · intro i hi j hj m hm hmi hmj
    have his := (Finset.mem_filter.mp hi).1
    have hjs := (Finset.mem_filter.mp hj).1
    by_contra hij
    have hdist := hspace i his j hjs hij
    have hib := abs_le.mp hmi.2
    have hjb := abs_le.mp hmj.2
    have hclose : |(a + delta i + width i) - (a + delta j + width j)| ≤
        2 * radius := abs_le.mpr ⟨by omega, by omega⟩
    omega

theorem inner_failures_le_three {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta width : ι → ℤ)
    (a h d wiggle ext radius : ℤ) (hwiggle : 0 ≤ wiggle)
    (hsep : Separated markers d) (hshort : 2 * h + 2 * wiggle < d)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hdspace : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → 2 * wiggle < |delta i - delta j|)
    (hwspace : ∀ i ∈ s, ∀ j ∈ s, i ≠ j →
      2 * radius < |(a + delta i + width i) - (a + delta j + width j)|)
    (hwr : wiggle ≤ radius) (her : ext ≤ radius) :
    (s.filter (fun i => InnerBad markers (a + delta i) (width i) ext wiggle)).card ≤ 3 := by
  classical
  let l := s.filter (fun i => LeftFailure markers (a + delta i) wiggle)
  let r := s.filter (fun i => RightFailure markers (a + delta i) (width i) radius)
  have hsub :
      s.filter (fun i => InnerBad markers (a + delta i) (width i) ext wiggle) ⊆ l ∪ r := by
    intro i hi
    obtain ⟨his, hib⟩ := Finset.mem_filter.mp hi
    rcases inner_bad_cover hwr her hib with hl | hr
    · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨his, hl⟩))
    · exact Finset.mem_union.mpr (Or.inr (Finset.mem_filter.mpr ⟨his, hr⟩))
  have hl := left_failure_le_one s markers delta a h d wiggle hsep hshort hdelta hdspace
  have hr := right_failure_le_two s markers delta width a h d radius hsep
    (by omega) hdelta hwspace
  change l.card ≤ 1 at hl
  change r.card ≤ 2 at hr
  calc
    _ ≤ (l ∪ r).card := Finset.card_le_card hsub
    _ ≤ l.card + r.card := Finset.card_union_le _ _
    _ ≤ 3 := by omega

def Return (markers : Finset ℤ) (eligible : ℤ → Prop) (m : ℤ) : Prop :=
  m ∈ markers ∧ eligible m ∧ ∀ n ∈ markers, eligible n → m ≤ n

theorem anchor_returns_le_two {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (eligible : ι → ℤ → Prop)
    (lo l r hi d : ℤ) (hsep : Separated markers d)
    (hleft : l - lo < d) (hright : hi - r < d)
    (houter : ∀ i ∈ s, ∀ m ∈ markers, eligible i m → lo ≤ m ∧ m ≤ hi)
    (hcore : ∀ i ∈ s, ∀ m ∈ markers, l ≤ m → m ≤ r → eligible i m) :
    (markers.filter (fun m => ∃ i ∈ s, Return markers (eligible i) m)).card ≤ 2 := by
  classical
  let left := markers.filter (fun m => lo ≤ m ∧ m ≤ l - 1)
  let right := markers.filter (fun m => r + 1 ≤ m ∧ m ≤ hi)
  let core := markers.filter (fun m => l ≤ m ∧ m ≤ r)
  have hl : left.card ≤ 1 := card_window_le_one hsep (by omega)
  have hr : right.card ≤ 1 := card_window_le_one hsep (by omega)
  by_cases hc : core.Nonempty
  · let q := core.min' hc
    have hq := Finset.mem_filter.mp (Finset.min'_mem core hc)
    have hsub :
        markers.filter (fun m => ∃ i ∈ s, Return markers (eligible i) m) ⊆
          left ∪ {q} := by
      intro m hm
      obtain ⟨hmM, i, his, hret⟩ := Finset.mem_filter.mp hm
      have hout := houter i his m hmM hret.2.1
      have hmq : m ≤ q := hret.2.2 q hq.1 (hcore i his q hq.1 hq.2.1 hq.2.2)
      by_cases hml : m < l
      · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨hmM, by omega⟩))
      · have heq : m = q := by
          apply le_antisymm hmq
          apply Finset.min'_le core m
          exact Finset.mem_filter.mpr ⟨hmM, by omega⟩
        simp [heq]
    calc
      _ ≤ (left ∪ {q}).card := Finset.card_le_card hsub
      _ ≤ left.card + ({q} : Finset ℤ).card := Finset.card_union_le _ _
      _ ≤ 2 := by simp only [Finset.card_singleton]; omega
  · have hsub :
        markers.filter (fun m => ∃ i ∈ s, Return markers (eligible i) m) ⊆ left ∪ right := by
      intro m hm
      obtain ⟨hmM, i, his, hret⟩ := Finset.mem_filter.mp hm
      have hout := houter i his m hmM hret.2.1
      by_cases hml : m < l
      · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨hmM, by omega⟩))
      · have hmr : r < m := by
          by_contra hh
          exact hc ⟨m, Finset.mem_filter.mpr ⟨hmM, by omega⟩⟩
        exact Finset.mem_union.mpr (Or.inr (Finset.mem_filter.mpr ⟨hmM, by omega⟩))
    calc
      _ ≤ (left ∪ right).card := Finset.card_le_card hsub
      _ ≤ left.card + right.card := Finset.card_union_le _ _
      _ ≤ 2 := by omega

theorem anchor_list_le_three {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (eligible : ι → ℤ → Prop)
    (lo l r hi d q₀ : ℤ) (hsep : Separated markers d)
    (hleft : l - lo < d) (hright : hi - r < d)
    (houter : ∀ i ∈ s, ∀ m ∈ markers, eligible i m → lo ≤ m ∧ m ≤ hi)
    (hcore : ∀ i ∈ s, ∀ m ∈ markers, l ≤ m → m ≤ r → eligible i m) :
    ((markers.filter (fun m => ∃ i ∈ s, Return markers (eligible i) m)) ∪ {q₀}).card ≤ 3 := by
  classical
  have hret := anchor_returns_le_two s markers eligible lo l r hi d
    hsep hleft hright houter hcore
  calc
    _ ≤ (markers.filter (fun m => ∃ i ∈ s, Return markers (eligible i) m)).card +
        ({q₀} : Finset ℤ).card := Finset.card_union_le _ _
    _ ≤ 3 := by simp only [Finset.card_singleton]; omega

theorem residue_injective {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (delta : ι → ℤ) (B c : ℤ)
    (hinj : Set.InjOn (fun i => delta i % B) s) :
    Set.InjOn (fun i => (c - delta i) % B) s := by
  intro i hi j hj he
  apply hinj hi hj
  have he' : Int.ModEq B (c - delta i) (c - delta j) := he
  have hh := he'.neg.add_left c
  change Int.ModEq B (delta i) (delta j)
  convert hh using 1 <;> ring

theorem width_endpoint_spacing {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (delta index width : ι → ℤ)
    (a h radius : ℤ)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hinj : Set.InjOn index s)
    (hwidth : ∀ i ∈ s, ∀ j ∈ s, index i ≠ index j →
      2 * h + 2 * radius < |width i - width j|) :
    ∀ i ∈ s, ∀ j ∈ s, i ≠ j →
      2 * radius < |(a + delta i + width i) - (a + delta j + width j)| := by
  intro i hi j hj hij
  have hdi := hdelta i hi
  have hdj := hdelta j hj
  have hidx : index i ≠ index j := fun hh => hij (hinj hi hj hh)
  have hw := hwidth i hi j hj hidx
  have hdd : |delta i - delta j| ≤ 2 * h := abs_le.mpr ⟨by omega, by omega⟩
  have htriangle :
      |width i - width j| ≤
      |(a + delta i + width i) - (a + delta j + width j)| + |delta i - delta j| := by
    calc
      _ = |((a + delta i + width i) - (a + delta j + width j)) -
          (delta i - delta j)| := by congr 1; ring
      _ ≤ _ := abs_sub _ _
  omega

def EndCross (markers : Finset ℤ) (delta : ℤ) (center base step B sign wiggle : ℤ) : Prop :=
  ∃ m ∈ markers,
    |m - (center + delta + sign * (base + ((m - center - delta) % B) * step))| ≤ wiggle

theorem end_cross_le_one {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (center base step B sign h d wiggle : ℤ)
    (hsep : Separated markers d) (hB : 0 < B) (hstep : 0 ≤ step)
    (hsign : sign = 1 ∨ sign = -1)
    (hshort : 2 * h + (B - 1) * step + 2 * wiggle < d)
    (hwide : 2 * h + 2 * wiggle < step)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hinj : Set.InjOn (fun i => delta i % B) s) :
    (s.filter (fun i => EndCross markers (delta i) center base step B sign wiggle)).card ≤ 1 := by
  classical
  apply Finset.card_le_one.mpr
  intro i hi j hj
  obtain ⟨his, m, hm, hmi⟩ := Finset.mem_filter.mp hi
  obtain ⟨hjs, n, hn, hnj⟩ := Finset.mem_filter.mp hj
  have hdi := hdelta i his
  have hdj := hdelta j hjs
  let u := (m - center - delta i) % B
  let v := (n - center - delta j) % B
  have hu : 0 ≤ u ∧ u ≤ B - 1 :=
    ⟨Int.emod_nonneg _ (by omega), by have := Int.emod_lt_of_pos (m - center - delta i) hB; omega⟩
  have hv : 0 ≤ v ∧ v ≤ B - 1 :=
    ⟨Int.emod_nonneg _ (by omega), by have := Int.emod_lt_of_pos (n - center - delta j) hB; omega⟩
  have humax : u * step ≤ (B - 1) * step := mul_le_mul_of_nonneg_right hu.2 hstep
  have hvmax : v * step ≤ (B - 1) * step := mul_le_mul_of_nonneg_right hv.2 hstep
  have hupos : 0 ≤ u * step := mul_nonneg hu.1 hstep
  have hvpos : 0 ≤ v * step := mul_nonneg hv.1 hstep
  have hmb := abs_le.mp hmi
  have hnb := abs_le.mp hnj
  change -wiggle ≤ m - (center + delta i + sign * (base + u * step)) ∧
    m - (center + delta i + sign * (base + u * step)) ≤ wiggle at hmb
  change -wiggle ≤ n - (center + delta j + sign * (base + v * step)) ∧
    n - (center + delta j + sign * (base + v * step)) ≤ wiggle at hnb
  have hmn : m = n := by
    by_contra hh
    have hdist := hsep m hm n hn hh
    have hclose : |m - n| < d := by
      apply abs_lt.mpr
      rcases hsign with hs | hs <;> rw [hs] at hmb hnb <;> constructor <;> nlinarith
    omega
  have huv : u = v := by
    by_contra hh
    rcases lt_or_gt_of_ne hh with hlt | hgt
    · have hmul : step ≤ (v - u) * step :=
        le_trans (by omega : step ≤ 1 * step)
          (mul_le_mul_of_nonneg_right (by omega : 1 ≤ v - u) hstep)
      rcases hsign with hs | hs <;> rw [hs] at hmb hnb <;> nlinarith
    · have hmul : step ≤ (u - v) * step :=
        le_trans (by omega : step ≤ 1 * step)
          (mul_le_mul_of_nonneg_right (by omega : 1 ≤ u - v) hstep)
      rcases hsign with hs | hs <;> rw [hs] at hmb hnb <;> nlinarith
  have hres := residue_injective s delta B (m - center) hinj
  apply hres his hjs
  simpa only [u, v, hmn] using huv

theorem interval_boundary_crossing {m z width v wiggle : ℤ}
    (hv : |v| ≤ wiggle)
    (hdiff : (|m - z| ≤ width) ≠ (|m - (z + v)| ≤ width)) :
    |m - (z - width)| ≤ wiggle ∨ |m - (z + width)| ≤ wiggle := by
  have hvb := abs_le.mp hv
  by_contra! hh
  have hleft := hh.1
  have hright := hh.2
  apply hdiff
  apply propext
  simp only [abs_le]
  have hleft' : ¬ (-wiggle ≤ m - (z - width) ∧ m - (z - width) ≤ wiggle) := by
    intro hb
    exact (not_le_of_gt hleft) (abs_le.mpr hb)
  have hright' : ¬ (-wiggle ≤ m - (z + width) ∧ m - (z + width) ≤ wiggle) := by
    intro hb
    exact (not_le_of_gt hright) (abs_le.mpr hb)
  omega

noncomputable def least (s : Finset ℤ) : Option ℤ :=
  if h : s.Nonempty then some (s.min' h) else none

def Eligible (center base step B m : ℤ) : Prop :=
  |m - center| ≤ base + ((m - center) % B) * step

noncomputable def endSearch (markers : Finset ℤ) (center base step B : ℤ) : Option ℤ :=
  least (markers.filter (Eligible center base step B))

theorem end_change_has_crossing {markers : Finset ℤ}
    {center base step B v wiggle : ℤ} (hBv : B ∣ v) (hv : |v| ≤ wiggle)
    (hchange : endSearch markers center base step B ≠
      endSearch markers (center + v) base step B) :
    EndCross markers 0 center base step B (-1) wiggle ∨
      EndCross markers 0 center base step B 1 wiggle := by
  classical
  have hset : markers.filter (Eligible center base step B) ≠
      markers.filter (Eligible (center + v) base step B) := by
    intro he
    exact hchange (congrArg least he)
  have hex : ∃ m : ℤ, ¬ (m ∈ markers.filter (Eligible center base step B) ↔
      m ∈ markers.filter (Eligible (center + v) base step B)) := by
    by_contra! hh
    exact hset (Finset.ext hh)
  obtain ⟨m, hm⟩ := hex
  have hmM : m ∈ markers := by
    by_contra hno
    simp [hno] at hm
  have hd : Eligible center base step B m ≠ Eligible (center + v) base step B m := by
    intro he
    exact hm (by simp only [Finset.mem_filter, hmM, true_and]; exact Iff.of_eq he)
  have hmod : (m - (center + v)) % B = (m - center) % B := by
    have hh : Int.ModEq B (m - (center + v)) (m - center) :=
      Int.modEq_iff_dvd.mpr (by convert hBv using 1; ring)
    exact hh
  have hdiff : (|m - center| ≤ base + ((m - center) % B) * step) ≠
      (|m - (center + v)| ≤ base + ((m - center) % B) * step) := by
    simpa only [Eligible, hmod] using hd
  rcases interval_boundary_crossing hv hdiff with hl | hr
  · left
    refine ⟨m, hmM, ?_⟩
    simpa [sub_eq_add_neg] using hl
  · right
    exact ⟨m, hmM, by simpa only [add_zero, sub_zero, one_mul] using hr⟩

def EndBad (markers : Finset ℤ) (center small large step B wiggle : ℤ) : Prop :=
  ∃ v : ℤ, B ∣ v ∧ |v| ≤ wiggle ∧
    (endSearch markers center small step B ≠ endSearch markers (center + v) small step B ∨
     endSearch markers center large step B ≠ endSearch markers (center + v) large step B)

theorem end_failures_le_four {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (center small large step B h d wiggle : ℤ)
    (hsep : Separated markers d) (hB : 0 < B) (hstep : 0 ≤ step)
    (hshort : 2 * h + (B - 1) * step + 2 * wiggle < d)
    (hwide : 2 * h + 2 * wiggle < step)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hinj : Set.InjOn (fun i => delta i % B) s) :
    (s.filter (fun i => EndBad markers (center + delta i) small large step B wiggle)).card ≤ 4 := by
  classical
  let a := s.filter (fun i => EndCross markers (delta i) center small step B (-1) wiggle)
  let b := s.filter (fun i => EndCross markers (delta i) center small step B 1 wiggle)
  let c := s.filter (fun i => EndCross markers (delta i) center large step B (-1) wiggle)
  let e := s.filter (fun i => EndCross markers (delta i) center large step B 1 wiggle)
  have ha : a.card ≤ 1 :=
    end_cross_le_one s markers delta center small step B (-1) h d wiggle
      hsep hB hstep (Or.inr rfl) hshort hwide hdelta hinj
  have hb : b.card ≤ 1 :=
    end_cross_le_one s markers delta center small step B 1 h d wiggle
      hsep hB hstep (Or.inl rfl) hshort hwide hdelta hinj
  have hc : c.card ≤ 1 :=
    end_cross_le_one s markers delta center large step B (-1) h d wiggle
      hsep hB hstep (Or.inr rfl) hshort hwide hdelta hinj
  have he : e.card ≤ 1 :=
    end_cross_le_one s markers delta center large step B 1 h d wiggle
      hsep hB hstep (Or.inl rfl) hshort hwide hdelta hinj
  have hsub :
      s.filter (fun i => EndBad markers (center + delta i) small large step B wiggle) ⊆
        (a ∪ b) ∪ (c ∪ e) := by
    intro i hi
    obtain ⟨his, v, hBv, hv, hchange⟩ := Finset.mem_filter.mp hi
    rcases hchange with hsmall | hlarge
    · have hh := end_change_has_crossing hBv hv hsmall
      have hh' :
          EndCross markers (delta i) center small step B (-1) wiggle ∨
          EndCross markers (delta i) center small step B 1 wiggle := by
        simpa only [EndCross, add_zero, sub_zero, sub_sub] using hh
      rcases hh' with hl | hr
      · exact Finset.mem_union.mpr (Or.inl (Finset.mem_union.mpr
          (Or.inl (Finset.mem_filter.mpr ⟨his, hl⟩))))
      · exact Finset.mem_union.mpr (Or.inl (Finset.mem_union.mpr
          (Or.inr (Finset.mem_filter.mpr ⟨his, hr⟩))))
    · have hh := end_change_has_crossing hBv hv hlarge
      have hh' :
          EndCross markers (delta i) center large step B (-1) wiggle ∨
          EndCross markers (delta i) center large step B 1 wiggle := by
        simpa only [EndCross, add_zero, sub_zero, sub_sub] using hh
      rcases hh' with hl | hr
      · exact Finset.mem_union.mpr (Or.inr (Finset.mem_union.mpr
          (Or.inl (Finset.mem_filter.mpr ⟨his, hl⟩))))
      · exact Finset.mem_union.mpr (Or.inr (Finset.mem_union.mpr
          (Or.inr (Finset.mem_filter.mpr ⟨his, hr⟩))))
  calc
    _ ≤ ((a ∪ b) ∪ (c ∪ e)).card := Finset.card_le_card hsub
    _ ≤ (a ∪ b).card + (c ∪ e).card := Finset.card_union_le _ _
    _ ≤ (a.card + b.card) + (c.card + e.card) :=
      Nat.add_le_add (Finset.card_union_le _ _) (Finset.card_union_le _ _)
    _ ≤ 4 := by omega

theorem periodic_agree_interval {α : Type*} (f g : ℤ → α) (a b z : ℤ)
    (ha : 0 < a) (hb : 0 < b) (hf : Function.Periodic f a)
    (hg : Function.Periodic g b)
    (hag : ∀ x : ℤ, z ≤ x → x < z + a * b → f x = g x) : f = g := by
  have hp : 0 < a * b := mul_pos ha hb
  have hf' : Function.Periodic f (a * b) := by
    simpa [mul_comm] using hf.int_mul b
  have hg' : Function.Periodic g (a * b) := by simpa using hg.int_mul a
  funext x
  let k := (x - z) / (a * b)
  have hr0 := Int.emod_nonneg (x - z) (ne_of_gt hp)
  have hr1 := Int.emod_lt_of_pos (x - z) hp
  have hid := Int.emod_add_mul_ediv (x - z) (a * b)
  have hx : x - k * (a * b) = z + (x - z) % (a * b) := by
    dsimp [k]
    nlinarith [hid]
  calc
    f x = f (x - k * (a * b)) := (hf'.sub_int_mul_eq k).symm
    _ = g (x - k * (a * b)) := hag _ (by rw [hx]; omega) (by rw [hx]; omega)
    _ = g x := hg'.sub_int_mul_eq k

def FirstMismatch {α : Type*} (word continuation : ℤ → α) (start q : ℤ) : Prop :=
  start ≤ q ∧ word q ≠ continuation q ∧
    ∀ x : ℤ, start ≤ x → x < q → word x = continuation x

theorem first_mismatch_unique {α : Type*} {word continuation : ℤ → α}
    {a b q r : ℤ} (hq : FirstMismatch word continuation a q)
    (hr : FirstMismatch word continuation b r)
    (hag : ∀ x : ℤ, min a b ≤ x → x < max a b → word x = continuation x) :
    q = r := by
  have hqstart := hq.1
  have hrstart := hr.1
  have hqa : max a b ≤ q := by
    by_contra hh
    have hqrange : min a b ≤ q ∧ q < max a b := by
      constructor <;> omega
    exact hq.2.1 (hag q hqrange.1 hqrange.2)
  have hra : max a b ≤ r := by
    by_contra hh
    have hrrange : min a b ≤ r ∧ r < max a b := by
      constructor <;> omega
    exact hr.2.1 (hag r hrrange.1 hrrange.2)
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · exact hq.2.1 (hr.2.2 q (by omega) hlt)
  · exact hr.2.1 (hq.2.2 r (by omega) hgt)

theorem least_some_iff {s : Finset ℤ} {m : ℤ} :
    least s = some m ↔ m ∈ s ∧ ∀ n ∈ s, m ≤ n := by
  classical
  unfold least
  split_ifs with hs
  · simp only [Option.some.injEq]
    constructor
    · rintro rfl
      exact ⟨Finset.min'_mem s hs, fun n hn => Finset.min'_le s n hn⟩
    · rintro ⟨hm, hmin⟩
      exact le_antisymm (Finset.min'_le s m hm) (hmin _ (Finset.min'_mem s hs))
  · simp only [false_iff]
    rintro ⟨hm, _⟩
    exact hs ⟨m, hm⟩

theorem least_none_iff {s : Finset ℤ} : least s = none ↔ s = ∅ := by
  classical
  unfold least
  split_ifs with hs
  · simp only [false_iff]
    intro he
    simp [he] at hs
  · simp only [true_iff]
    exact Finset.not_nonempty_iff_eq_empty.mp hs

theorem endSearch_some_iff {markers : Finset ℤ} {center base step B m : ℤ} :
    endSearch markers center base step B = some m ↔
      Return markers (Eligible center base step B) m := by
  classical
  simp only [endSearch, least_some_iff, Finset.mem_filter, Return]
  aesop

noncomputable def clockAnchor (markers : Finset ℤ) (center base step B mismatch : ℤ) : ℤ :=
  (endSearch markers center base step B).getD mismatch

theorem anchor_return_or_mismatch {markers : Finset ℤ}
    {center base step B mismatch : ℤ} :
    clockAnchor markers center base step B mismatch = mismatch ∨
      Return markers (Eligible center base step B)
        (clockAnchor markers center base step B mismatch) := by
  cases he : endSearch markers center base step B with
  | none => exact Or.inl (by simp [clockAnchor, he])
  | some m =>
    exact Or.inr (by simpa [clockAnchor, he] using endSearch_some_iff.mp he)

theorem eligibility_sandwich {center base step B h delta m : ℤ}
    (hB : 0 < B) (hstep : 0 ≤ step) (hd : -h ≤ delta ∧ delta ≤ h) :
    (Eligible (center + delta) base step B m →
      center - base - h - (B - 1) * step ≤ m ∧
      m ≤ center + base + h + (B - 1) * step) ∧
    (center - base + h ≤ m → m ≤ center + base - h →
      Eligible (center + delta) base step B m) := by
  let u := (m - (center + delta)) % B
  have hu : 0 ≤ u ∧ u ≤ B - 1 :=
    ⟨Int.emod_nonneg _ (by omega), by
      have := Int.emod_lt_of_pos (m - (center + delta)) hB
      omega⟩
  have hpos : 0 ≤ u * step := mul_nonneg hu.1 hstep
  have hmax : u * step ≤ (B - 1) * step := mul_le_mul_of_nonneg_right hu.2 hstep
  constructor
  · intro he
    have hb := abs_le.mp he
    change -(base + u * step) ≤ m - (center + delta) ∧
      m - (center + delta) ≤ base + u * step at hb
    constructor <;> nlinarith
  · intro hl hr
    apply abs_le.mpr
    change -(base + u * step) ≤ m - (center + delta) ∧
      m - (center + delta) ≤ base + u * step
    constructor <;> nlinarith

theorem actual_anchor_list_le_three {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (center base step B h d mismatch : ℤ)
    (hsep : Separated markers d) (hB : 0 < B) (hstep : 0 ≤ step)
    (hshort : 2 * h + (B - 1) * step < d)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h) :
    ((markers.filter (fun m => ∃ i ∈ s,
      Return markers (Eligible (center + delta i) base step B) m)) ∪ {mismatch}).card ≤ 3 := by
  apply anchor_list_le_three s markers (fun i => Eligible (center + delta i) base step B)
    (center - base - h - (B - 1) * step) (center - base + h)
    (center + base - h) (center + base + h + (B - 1) * step) d mismatch
    hsep (by omega) (by omega)
  · intro i hi m hm he
    exact (eligibility_sandwich hB hstep (hdelta i hi)).1 he
  · intro i hi m hm hl hr
    exact (eligibility_sandwich hB hstep (hdelta i hi)).2 hl hr

theorem absent_large_forces_absent_small {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (center small large step B h : ℤ)
    (hB : 0 < B) (hstep : 0 ≤ step)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hgap : small + (B - 1) * step + 2 * h < large)
    (hab : ∃ j ∈ s, endSearch markers (center + delta j) large step B = none) :
    ∀ i ∈ s, endSearch markers (center + delta i) small step B = none := by
  classical
  obtain ⟨j, hj, hjnone⟩ := hab
  have hjempty := least_none_iff.mp hjnone
  intro i hi
  apply least_none_iff.mpr
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro m hm
  obtain ⟨hmM, hmE⟩ := Finset.mem_filter.mp hm
  have hmi := (eligibility_sandwich hB hstep (hdelta i hi)).1 hmE
  have hdj := hdelta j hj
  have hu : 0 ≤ ((m - (center + delta j)) % B) * step :=
    mul_nonneg (Int.emod_nonneg _ (by omega)) hstep
  have hmj : Eligible (center + delta j) large step B m := by
    apply abs_le.mpr
    constructor <;> nlinarith
  have hh : m ∈ markers.filter (Eligible (center + delta j) large step B) :=
    Finset.mem_filter.mpr ⟨hmM, hmj⟩
  simp [hjempty] at hh

theorem card_biUnion_le_mul {ι α : Type*} [DecidableEq ι] [DecidableEq α]
    (s : Finset ι) (f : ι → Finset α) (n : ℕ)
    (h : ∀ i ∈ s, (f i).card ≤ n) : (s.biUnion f).card ≤ s.card * n := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
    have hfa := h a (Finset.mem_insert_self a s)
    have hfs := ih (fun i hi => h i (Finset.mem_insert_of_mem hi))
    rw [Finset.biUnion_insert, Finset.card_insert_of_notMem ha]
    calc
      _ ≤ (f a).card + (s.biUnion f).card := Finset.card_union_le _ _
      _ ≤ n + s.card * n := Nat.add_le_add hfa hfs
      _ = (s.card + 1) * n := by ring

theorem whole_stencil_bound {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (labels : Finset ℕ) (endMarkers innerMarkers : Finset ℤ)
    (delta : ι → ℤ) (offset : ℕ → ℤ) (width : ℤ → ℤ)
    (clock : ℤ → ι → Prop)
    (center small large step B h dend dinner wiggle iw ext radius mismatch t : ℤ)
    (C : ℕ)
    (hendsep : Separated endMarkers dend) (hinnersep : Separated innerMarkers dinner)
    (hB : 0 < B) (hstep : 0 ≤ step) (hwiggle : 0 ≤ wiggle) (hiw : 0 ≤ iw)
    (hendshort : 2 * h + (B - 1) * step + 2 * wiggle < dend)
    (hendwide : 2 * h + 2 * wiggle < step)
    (hinnershort : 2 * h + 2 * iw < dinner)
    (hdelta : ∀ i ∈ s, -h ≤ delta i ∧ delta i ≤ h)
    (hresidue : Set.InjOn (fun i => delta i % B) s)
    (hdspace : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → 2 * iw < |delta i - delta j|)
    (hwspace : ∀ u v : ℤ, 0 ≤ u → u < B → 0 ≤ v → v < B → u ≠ v →
      2 * h + 2 * radius < |width u - width v|)
    (hir : iw ≤ radius) (her : ext ≤ radius)
    (hclock : ∀ Q : ℤ, (s.filter (clock Q)).card ≤ C) :
    (s.filter (fun i =>
      let Q := clockAnchor endMarkers (center + delta i) large step B mismatch
      EndBad endMarkers (center + delta i) small large step B wiggle ∨
      clock Q i ∨
      ∃ j ∈ labels, InnerBad innerMarkers (offset j + delta i)
        (width ((Q - t - delta i) % B)) ext iw)).card ≤
      4 + 3 * (C + 3 * labels.card) := by
  classical
  let anchors := (endMarkers.filter (fun m => ∃ i ∈ s,
    Return endMarkers (Eligible (center + delta i) large step B) m)) ∪ {mismatch}
  have hanchors : anchors.card ≤ 3 :=
    actual_anchor_list_le_three s endMarkers delta center large step B h dend mismatch
      hendsep hB hstep (by omega) hdelta
  let index := fun Q i => (Q - t - delta i) % B
  let inners := fun Q j => s.filter (fun i =>
    InnerBad innerMarkers (offset j + delta i) (width (index Q i)) ext iw)
  let atAnchor := fun Q => s.filter (clock Q) ∪ labels.biUnion (inners Q)
  let ends := s.filter (fun i =>
    EndBad endMarkers (center + delta i) small large step B wiggle)
  have hends : ends.card ≤ 4 :=
    end_failures_le_four s endMarkers delta center small large step B h dend wiggle
      hendsep hB hstep hendshort hendwide hdelta hresidue
  have hinner : ∀ Q j, (inners Q j).card ≤ 3 := by
    intro Q j
    apply inner_failures_le_three s innerMarkers delta (fun i => width (index Q i))
      (offset j) h dinner iw ext radius hiw hinnersep hinnershort hdelta hdspace
    · apply width_endpoint_spacing s delta (index Q) (fun i => width (index Q i))
        (offset j) h radius hdelta (residue_injective s delta B (Q - t) hresidue)
      intro i hi j hj hij
      apply hwspace
      · exact Int.emod_nonneg _ (by omega)
      · exact Int.emod_lt_of_pos _ hB
      · exact Int.emod_nonneg _ (by omega)
      · exact Int.emod_lt_of_pos _ hB
      · exact hij
    · exact hir
    · exact her
  have hblock : ∀ Q ∈ anchors, (atAnchor Q).card ≤ C + labels.card * 3 := by
    intro Q hQ
    calc
      _ ≤ (s.filter (clock Q)).card + (labels.biUnion (inners Q)).card :=
        Finset.card_union_le _ _
      _ ≤ C + labels.card * 3 := Nat.add_le_add (hclock Q)
        (card_biUnion_le_mul labels (inners Q) 3 (fun j hj => hinner Q j))
  have hsub : s.filter (fun i =>
      let Q := clockAnchor endMarkers (center + delta i) large step B mismatch
      EndBad endMarkers (center + delta i) small large step B wiggle ∨ clock Q i ∨
      ∃ j ∈ labels, InnerBad innerMarkers (offset j + delta i)
        (width ((Q - t - delta i) % B)) ext iw) ⊆ ends ∪ anchors.biUnion atAnchor := by
    intro i hi
    obtain ⟨his, hbad⟩ := Finset.mem_filter.mp hi
    rcases hbad with hend | hcl | ⟨j, hj, hjbad⟩
    · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨his, hend⟩))
    all_goals
      let Q := clockAnchor endMarkers (center + delta i) large step B mismatch
      have hQ : Q ∈ anchors := by
        rcases anchor_return_or_mismatch (markers := endMarkers)
          (center := center + delta i) (base := large) (step := step)
          (B := B) (mismatch := mismatch) with hq | hq
        · exact Finset.mem_union.mpr (Or.inr (by simp only [Q, hq, Finset.mem_singleton]))
        · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨hq.1, i, his, hq⟩))
      apply Finset.mem_union.mpr
      right
      apply Finset.mem_biUnion.mpr
      refine ⟨Q, hQ, ?_⟩
    · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨his, hcl⟩))
    · exact Finset.mem_union.mpr (Or.inr (Finset.mem_biUnion.mpr
        ⟨j, hj, Finset.mem_filter.mpr ⟨his, hjbad⟩⟩))
  calc
    _ ≤ (ends ∪ anchors.biUnion atAnchor).card := Finset.card_le_card hsub
    _ ≤ ends.card + (anchors.biUnion atAnchor).card := Finset.card_union_le _ _
    _ ≤ 4 + anchors.card * (C + labels.card * 3) :=
      Nat.add_le_add hends (card_biUnion_le_mul anchors atAnchor _ hblock)
    _ ≤ 4 + 3 * (C + labels.card * 3) :=
      Nat.add_le_add_left (Nat.mul_le_mul_right _ hanchors) 4
    _ = 4 + 3 * (C + 3 * labels.card) := by ring

theorem seed_continuations_equal {α : Type*} (word f g : ℤ → α)
    (a b K d p q gap : ℤ) (hd : 0 < d) (hp : 0 < p) (hq : 0 < q)
    (hpd : p < d) (hqd : q < d) (hgap : |a - b| ≤ gap)
    (hsize : d * d ≤ K - gap) (hf : Function.Periodic f p)
    (hg : Function.Periodic g q)
    (hfa : ∀ x : ℤ, a ≤ x → x < a + K → word x = f x)
    (hgb : ∀ x : ℤ, b ≤ x → x < b + K → word x = g x) :
    f = g := by
  have hpq : p * q < d * d := by nlinarith
  have hgaps := abs_le.mp hgap
  apply periodic_agree_interval f g p q (max a b) hp hq hf hg
  intro x hx hxe
  have hxa : a ≤ x ∧ x < a + K := by omega
  have hxb : b ≤ x ∧ x < b + K := by omega
  exact (hfa x hxa.1 hxa.2).symm.trans (hgb x hxb.1 hxb.2)

theorem reference_mismatch_sound {α : Type*} (word f g : ℤ → α)
    (a b K d p q gap trueMismatch referenceMismatch : ℤ)
    (hd : 0 < d) (hp : 0 < p) (hq : 0 < q) (hpd : p < d) (hqd : q < d)
    (hgap : |a - b| ≤ gap) (hsize : d * d ≤ K - gap)
    (hf : Function.Periodic f p) (hg : Function.Periodic g q)
    (hfa : ∀ x : ℤ, a ≤ x → x < a + K → word x = f x)
    (hgb : ∀ x : ℤ, b ≤ x → x < b + K → word x = g x)
    (htrue : FirstMismatch word f (a + K) trueMismatch)
    (href : FirstMismatch word g (b + K) referenceMismatch) :
    referenceMismatch = trueMismatch := by
  have heq := seed_continuations_equal word f g a b K d p q gap
    hd hp hq hpd hqd hgap hsize hf hg hfa hgb
  subst g
  apply (first_mismatch_unique htrue href ?_).symm
  intro x hx hxe
  have hgaps := abs_le.mp hgap
  have hpos : 0 < d * d := mul_pos hd hd
  by_cases hab : a ≤ b
  · exact hgb x (by omega) (by omega)
  · exact hfa x (by omega) (by omega)

theorem seed_overlap_schedule {d K h : ℤ} (hd : 2 ≤ d) (_hh : 0 ≤ h)
    (hshort : 2 * h < d) (hK : 3 * d * d < K) : d * d ≤ K - 2 * h := by
  nlinarith

theorem anchor_before_uniqueness {ζ : Option ℤ} {actualMismatch referenceMismatch : ℤ}
    (allPresentOrReference : ζ ≠ none ∨ referenceMismatch = actualMismatch) :
    ζ.getD referenceMismatch = ζ.getD actualMismatch := by
  rcases allPresentOrReference with hp | hr
  · cases ζ with
    | none => exact False.elim (hp rfl)
    | some m => rfl
  · rw [hr]

theorem true_witness_survives {ζ : Option ℤ} {actualMismatch referenceMismatch : ℤ}
    (predicate : ℤ → Prop)
    (allPresentOrReference : ζ ≠ none ∨ referenceMismatch = actualMismatch)
    (hactual : predicate (ζ.getD actualMismatch)) :
    predicate (ζ.getD referenceMismatch) := by
  rw [anchor_before_uniqueness allPresentOrReference]
  exact hactual

def EndRule {α : Type*} (word continuation : ℤ → α) (seedEnd : ℤ)
    (η : Option ℤ) (tail endpoint : ℤ) : Prop :=
  match η with
  | some m => endpoint = m + tail
  | none => ∃ q, FirstMismatch word continuation seedEnd q ∧ endpoint = q + tail

theorem end_rule_unique {α : Type*} (word continuation : ℤ → α)
    (seedEnd : ℤ) (η : Option ℤ) (tail actual proposed : ℤ)
    (ha : EndRule word continuation seedEnd η tail actual)
    (hp : EndRule word continuation seedEnd η tail proposed) : proposed = actual := by
  cases η with
  | some m => exact hp.trans ha.symm
  | none =>
    obtain ⟨q, hq, heq⟩ := ha
    obtain ⟨r, hr, her⟩ := hp
    have hqr : q = r := first_mismatch_unique hq hr (by intro x hx hxe; omega)
    omega

theorem decoder_sound {ι α : Type*} [DecidableEq ι]
    (slots : Finset ι) (trueSlot decoded : ι) (witness : ι → Prop)
    (word continuation : ℤ → α) (seedEnd : ℤ) (η : Option ℤ)
    (tail actual proposed : ℤ)
    (htrue : trueSlot ∈ slots) (hdecoded : decoded ∈ slots)
    (hactualWitness : witness trueSlot) (hdecodedWitness : witness decoded)
    (hunique : ∀ i ∈ slots, ∀ j ∈ slots, witness i → witness j → i = j)
    (ha : EndRule word continuation seedEnd η tail actual)
    (hp : EndRule word continuation seedEnd η tail proposed) :
    decoded = trueSlot ∧ proposed = actual :=
  ⟨hunique decoded hdecoded trueSlot htrue hdecodedWitness hactualWitness,
   end_rule_unique word continuation seedEnd η tail actual proposed ha hp⟩

theorem failed_slots_le_false_pairs {ι : Type*} [DecidableEq ι]
    (slots : Finset ι) (witness : ι → ι → Prop) :
    (slots.filter (fun p => ∃ p' ∈ slots, p ≠ p' ∧ witness p p')).card ≤
      ((slots ×ˢ slots).filter (fun pair => pair.1 ≠ pair.2 ∧ witness pair.1 pair.2)).card := by
  classical
  let pairs := (slots ×ˢ slots).filter (fun pair => pair.1 ≠ pair.2 ∧ witness pair.1 pair.2)
  have he :
      slots.filter (fun p => ∃ p' ∈ slots, p ≠ p' ∧ witness p p') = pairs.image Prod.fst := by
    ext p
    simp only [pairs, Finset.mem_filter, Finset.mem_image, Finset.mem_product, Prod.exists]
    aesop
  rw [he]
  exact Finset.card_image_le

theorem every_kind_survives {ι κ : Type*} [DecidableEq ι] [DecidableEq κ]
    (slots bad : Finset ι) (kind : ι → κ) (μ : ℕ)
    (hbad : bad.card < μ) (k : κ)
    (hcopies : (slots.filter (fun p => kind p = k)).card = μ) :
    ∃ p ∈ slots, kind p = k ∧ p ∉ bad := by
  classical
  by_contra! hh
  have hsub : slots.filter (fun p => kind p = k) ⊆ bad := by
    intro p hp
    obtain ⟨hps, hpk⟩ := Finset.mem_filter.mp hp
    exact hh p hps hpk
  have hc := Finset.card_le_card hsub
  omega

theorem manuscript_budget (C labels μ : ℕ) (A : ℝ)
    (hC : (C : ℝ) ≤ A)
    (hμ : 20 * (A + 4 * (labels : ℝ)) + 10 < (μ : ℝ)) :
    4 + 3 * (C + 3 * labels) < μ := by
  have hCr : (0 : ℝ) ≤ C := Nat.cast_nonneg C
  have hJr : (0 : ℝ) ≤ labels := Nat.cast_nonneg labels
  have hr : (4 : ℝ) + 3 * ((C : ℝ) + 3 * (labels : ℝ)) < (μ : ℝ) := by
    linarith
  exact_mod_cast hr

theorem end_schedule_constraints {B h w S d : ℤ}
    (hB : 0 < B) (hh : 0 ≤ h) (hw : 0 ≤ w)
    (hS : 4 * (h + w + 1) < S)
    (hd : 10 * B * S + 10 * (h + w + 1) < d) :
    2 * h + (B - 1) * S + 2 * w < d ∧
      2 * h + 2 * w < S ∧ d + (B - 1) * S + 2 * h < 3 * d := by
  have hSpos : 0 ≤ S := by omega
  have hBpos : 0 ≤ B - 1 := by omega
  have hprod := mul_nonneg hBpos hSpos
  constructor
  · nlinarith
  constructor
  · omega
  · nlinarith

theorem clock_pair_formula {A : Type*} [AddCommGroup A] (φ : ℤ →+ A)
    (Q t p p' : ℤ) :
    φ (Q - t - (p - p')) = φ (Q - t) + φ p' - φ p := by
  simp only [map_sub]
  abel

theorem reference_guard_forces_endpoint {ι α : Type*} [DecidableEq ι]
    (candidates : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (word : ℤ → α) (continuation : ι → ℤ → α) (period : ι → ℤ)
    (center small large step B h K d tail actual proposed : ℤ)
    (trueSlot reference : ι)
    (htrue : trueSlot ∈ candidates) (hrefslot : reference ∈ candidates)
    (hB : 0 < B) (hstep : 0 ≤ step) (hd : 0 < d)
    (hdelta : ∀ i ∈ candidates, -h ≤ delta i ∧ delta i ≤ h)
    (hgap : small + (B - 1) * step + 2 * h < large)
    (hsize : d * d ≤ K - 2 * h)
    (hseeds : ∀ i ∈ candidates,
      endSearch markers (center + delta i) small step B = none →
      0 < period i ∧ period i < d ∧
      Function.Periodic (continuation i) (period i) ∧
      ∀ x : ℤ, center + delta i ≤ x → x < center + delta i + K →
        word x = continuation i x)
    (hcomplete : EndRule word (continuation trueSlot) (center + delta trueSlot + K)
      (endSearch markers (center + delta trueSlot) small step B) tail actual)
    (hguard : EndRule word (continuation reference) (center + delta reference + K)
      (endSearch markers (center + delta reference) small step B) tail proposed)
    (habsent : ∃ i ∈ candidates,
      endSearch markers (center + delta i) large step B = none) :
    proposed = actual := by
  have hsmall := absent_large_forces_absent_small candidates markers delta
    center small large step B h hB hstep hdelta hgap habsent
  have hts := hsmall trueSlot htrue
  have hrs := hsmall reference hrefslot
  obtain ⟨q, hq, haq⟩ : ∃ q, FirstMismatch word (continuation trueSlot)
      (center + delta trueSlot + K) q ∧ actual = q + tail := by
    simpa only [EndRule, hts] using hcomplete
  obtain ⟨r, hr, hpr⟩ : ∃ r, FirstMismatch word (continuation reference)
      (center + delta reference + K) r ∧ proposed = r + tail := by
    simpa only [EndRule, hrs] using hguard
  obtain ⟨hpt, hptd, hct, hwt⟩ := hseeds trueSlot htrue hts
  obtain ⟨hprp, hprd, hcr, hwr⟩ := hseeds reference hrefslot hrs
  have hdt := hdelta trueSlot htrue
  have hdr := hdelta reference hrefslot
  have hstarts : |(center + delta trueSlot) - (center + delta reference)| ≤ 2 * h :=
    abs_le.mpr ⟨by omega, by omega⟩
  have hrq := reference_mismatch_sound word (continuation trueSlot)
    (continuation reference) (center + delta trueSlot) (center + delta reference)
    K d (period trueSlot) (period reference) (2 * h) q r
    hd hpt hprp hptd hprd hstarts hsize hct hcr hwt hwr hq hr
  omega

theorem decoder_pre_uniqueness {ι α : Type*} [DecidableEq ι]
    (candidates : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (word : ℤ → α) (continuation : ι → ℤ → α) (period : ι → ℤ)
    (center small large step B h K d tail actual proposed : ℤ)
    (trueSlot reference : ι) (predicate : ℤ → Prop)
    (htrue : trueSlot ∈ candidates) (hrefslot : reference ∈ candidates)
    (hB : 0 < B) (hstep : 0 ≤ step) (hd : 0 < d)
    (hdelta : ∀ i ∈ candidates, -h ≤ delta i ∧ delta i ≤ h)
    (hgap : small + (B - 1) * step + 2 * h < large)
    (hsize : d * d ≤ K - 2 * h)
    (hseeds : ∀ i ∈ candidates,
      endSearch markers (center + delta i) small step B = none →
      0 < period i ∧ period i < d ∧
      Function.Periodic (continuation i) (period i) ∧
      ∀ x : ℤ, center + delta i ≤ x → x < center + delta i + K →
        word x = continuation i x)
    (hcomplete : EndRule word (continuation trueSlot) (center + delta trueSlot + K)
      (endSearch markers (center + delta trueSlot) small step B) tail actual)
    (hguard : (∃ i ∈ candidates,
      endSearch markers (center + delta i) large step B = none) →
      EndRule word (continuation reference) (center + delta reference + K)
        (endSearch markers (center + delta reference) small step B) tail proposed)
    (hactual : predicate (clockAnchor markers (center + delta trueSlot)
      large step B (actual - tail))) :
    predicate (clockAnchor markers (center + delta trueSlot)
      large step B (proposed - tail)) := by
  by_cases hab : ∃ i ∈ candidates,
      endSearch markers (center + delta i) large step B = none
  · have hend := reference_guard_forces_endpoint candidates markers delta word continuation period
      center small large step B h K d tail actual proposed trueSlot reference
      htrue hrefslot hB hstep hd hdelta hgap hsize hseeds hcomplete (hguard hab) hab
    simpa only [hend] using hactual
  · have hζ : endSearch markers (center + delta trueSlot) large step B ≠ none := by
      intro hn
      exact hab ⟨trueSlot, htrue, hn⟩
    exact true_witness_survives predicate (Or.inl hζ) hactual

theorem decoder_success_and_endpoint {ι α : Type*} [DecidableEq ι]
    (candidates : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (word : ℤ → α) (continuation : ι → ℤ → α) (period : ι → ℤ)
    (center small large step B h K d tail actual proposed : ℤ)
    (trueSlot reference decoded : ι) (predicate : ι → ℤ → Prop)
    (htrue : trueSlot ∈ candidates) (hrefslot : reference ∈ candidates)
    (hdecoded : decoded ∈ candidates)
    (hB : 0 < B) (hstep : 0 ≤ step) (hd : 0 < d)
    (hdelta : ∀ i ∈ candidates, -h ≤ delta i ∧ delta i ≤ h)
    (hgap : small + (B - 1) * step + 2 * h < large)
    (hsize : d * d ≤ K - 2 * h)
    (hseeds : ∀ i ∈ candidates,
      endSearch markers (center + delta i) small step B = none →
      0 < period i ∧ period i < d ∧
      Function.Periodic (continuation i) (period i) ∧
      ∀ x : ℤ, center + delta i ≤ x → x < center + delta i + K →
        word x = continuation i x)
    (hcomplete : EndRule word (continuation trueSlot) (center + delta trueSlot + K)
      (endSearch markers (center + delta trueSlot) small step B) tail actual)
    (hguard : (∃ i ∈ candidates,
      endSearch markers (center + delta i) large step B = none) →
      EndRule word (continuation reference) (center + delta reference + K)
        (endSearch markers (center + delta reference) small step B) tail proposed)
    (hactual : predicate trueSlot (clockAnchor markers (center + delta trueSlot)
      large step B (actual - tail)))
    (hselected : predicate decoded (clockAnchor markers (center + delta decoded)
      large step B (proposed - tail)))
    (hunique : ∀ i ∈ candidates, ∀ j ∈ candidates,
      predicate i (clockAnchor markers (center + delta i) large step B (proposed - tail)) →
      predicate j (clockAnchor markers (center + delta j) large step B (proposed - tail)) →
      i = j)
    (hfinal : EndRule word (continuation decoded) (center + delta decoded + K)
      (endSearch markers (center + delta decoded) small step B) tail proposed) :
    decoded = trueSlot ∧ proposed = actual := by
  have hsurvives := decoder_pre_uniqueness candidates markers delta word continuation period
    center small large step B h K d tail actual proposed trueSlot reference (predicate trueSlot)
    htrue hrefslot hB hstep hd hdelta hgap hsize hseeds hcomplete hguard hactual
  have hdecodedTrue : decoded = trueSlot :=
    hunique decoded hdecoded trueSlot htrue hselected hsurvives
  refine ⟨hdecodedTrue, ?_⟩
  rw [hdecodedTrue] at hfinal
  exact end_rule_unique word (continuation trueSlot) (center + delta trueSlot + K)
    (endSearch markers (center + delta trueSlot) small step B) tail actual proposed hcomplete hfinal

theorem stencil_completeness {ι κ : Type*} [DecidableEq ι] [DecidableEq κ]
    (slots : Finset ι) (witness : ι → ι → Prop) (kind : ι → κ) (μ bound : ℕ)
    (hbound : ((slots ×ˢ slots).filter
      (fun pair => pair.1 ≠ pair.2 ∧ witness pair.1 pair.2)).card ≤ bound)
    (hμ : bound < μ) (k : κ)
    (hcopies : (slots.filter (fun p => kind p = k)).card = μ) :
    (slots.filter (fun p => ∃ p' ∈ slots, p ≠ p' ∧ witness p p')).card < μ ∧
    ∃ p ∈ slots, kind p = k ∧ ∀ p' ∈ slots, p ≠ p' → ¬ witness p p' := by
  classical
  let bad := slots.filter (fun p => ∃ p' ∈ slots, p ≠ p' ∧ witness p p')
  have hbad : bad.card < μ :=
    lt_of_le_of_lt (failed_slots_le_false_pairs slots witness) (lt_of_le_of_lt hbound hμ)
  refine ⟨hbad, ?_⟩
  obtain ⟨p, hp, hpk, hgood⟩ := every_kind_survives slots bad kind μ hbad k hcopies
  refine ⟨p, hp, hpk, ?_⟩
  intro p' hp' hne hw
  exact hgood (Finset.mem_filter.mpr ⟨hp, p', hp', hne, hw⟩)

theorem search_as_least (markers : Finset ℤ) (z width : ℤ) :
    search markers z width =
      least (markers.filter (fun m => z ≤ m ∧ m ≤ z + width)) := by
  classical
  cases hf : firstAfter markers z with
  | none =>
    have hn := firstAfter_none_iff.mp hf
    have he : markers.filter (fun m => z ≤ m ∧ m ≤ z + width) = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro m hm
      obtain ⟨hmM, hzm, _⟩ := Finset.mem_filter.mp hm
      have hh := hn m hmM
      omega
    simp [search, hf, he, least]
  | some m =>
    have hfirst := firstAfter_some_iff.mp hf
    by_cases hmw : m ≤ z + width
    · have hleast : least (markers.filter (fun n => z ≤ n ∧ n ≤ z + width)) = some m := by
        apply least_some_iff.mpr
        refine ⟨Finset.mem_filter.mpr ⟨hfirst.1, hfirst.2.1, hmw⟩, ?_⟩
        intro n hn
        obtain ⟨hnM, hzn, _⟩ := Finset.mem_filter.mp hn
        exact hfirst.2.2 n hnM hzn
      simp [search, hf, hmw, hleast]
    · have he : markers.filter (fun n => z ≤ n ∧ n ≤ z + width) = ∅ := by
        apply Finset.eq_empty_iff_forall_notMem.mpr
        intro n hn
        obtain ⟨hnM, hzn, hnw⟩ := Finset.mem_filter.mp hn
        have hmn := hfirst.2.2 n hnM hzn
        omega
      simp [search, hf, hmw, he, least]

theorem search_locality (a b : Finset ℤ) (z width : ℤ)
    (hag : ∀ m : ℤ, z ≤ m → m ≤ z + width → (m ∈ a ↔ m ∈ b)) :
    search a z width = search b z width := by
  rw [search_as_least, search_as_least]
  congr 1
  ext m
  simp only [Finset.mem_filter]
  by_cases hlo : z ≤ m <;> by_cases hhi : m ≤ z + width
  · simp only [hlo, hhi, and_true]
    exact hag m hlo hhi
  all_goals simp [hlo, hhi]

theorem end_search_locality (a b : Finset ℤ) (center base step B : ℤ)
    (hag : ∀ m : ℤ, Eligible center base step B m → (m ∈ a ↔ m ∈ b)) :
    endSearch a center base step B = endSearch b center base step B := by
  unfold endSearch
  congr 1
  ext m
  simp only [Finset.mem_filter]
  by_cases he : Eligible center base step B m
  · simpa only [he, and_true] using hag m he
  · simp [he]

theorem first_mismatch_transport {α : Type*} {word continuation : ℤ → α}
    {a b q : ℤ} (hq : FirstMismatch word continuation a q)
    (hag : ∀ x : ℤ, min a b ≤ x → x < max a b → word x = continuation x) :
    FirstMismatch word continuation b q := by
  have hqa := hq.1
  have hqb : b ≤ q := by
    by_contra hh
    exact hq.2.1 (hag q (by omega) (by omega))
  refine ⟨hqb, hq.2.1, ?_⟩
  intro x hbx hxq
  by_cases hax : a ≤ x
  · exact hq.2.2 x hax hxq
  · exact hag x (by omega) (by omega)

theorem actual_reference_guard_passes {ι α : Type*} [DecidableEq ι]
    (candidates : Finset ι) (markers : Finset ℤ) (delta : ι → ℤ)
    (word : ℤ → α) (continuation : ι → ℤ → α) (period : ι → ℤ)
    (center small large step B h K d tail actual : ℤ)
    (trueSlot reference : ι)
    (htrue : trueSlot ∈ candidates) (hrefslot : reference ∈ candidates)
    (hB : 0 < B) (hstep : 0 ≤ step) (hd : 0 < d)
    (hdelta : ∀ i ∈ candidates, -h ≤ delta i ∧ delta i ≤ h)
    (hgap : small + (B - 1) * step + 2 * h < large)
    (hsize : d * d ≤ K - 2 * h)
    (hseeds : ∀ i ∈ candidates,
      endSearch markers (center + delta i) small step B = none →
      0 < period i ∧ period i < d ∧
      Function.Periodic (continuation i) (period i) ∧
      ∀ x : ℤ, center + delta i ≤ x → x < center + delta i + K →
        word x = continuation i x)
    (hcomplete : EndRule word (continuation trueSlot) (center + delta trueSlot + K)
      (endSearch markers (center + delta trueSlot) small step B) tail actual)
    (habsent : ∃ i ∈ candidates,
      endSearch markers (center + delta i) large step B = none) :
    EndRule word (continuation reference) (center + delta reference + K)
      (endSearch markers (center + delta reference) small step B) tail actual := by
  have hsmall := absent_large_forces_absent_small candidates markers delta
    center small large step B h hB hstep hdelta hgap habsent
  have hts := hsmall trueSlot htrue
  have hrs := hsmall reference hrefslot
  obtain ⟨q, hq, haq⟩ : ∃ q, FirstMismatch word (continuation trueSlot)
      (center + delta trueSlot + K) q ∧ actual = q + tail := by
    simpa only [EndRule, hts] using hcomplete
  obtain ⟨hpt, hptd, hct, hwt⟩ := hseeds trueSlot htrue hts
  obtain ⟨hpr, hprd, hcr, hwr⟩ := hseeds reference hrefslot hrs
  have hdt := hdelta trueSlot htrue
  have hdr := hdelta reference hrefslot
  have hstarts : |(center + delta trueSlot) - (center + delta reference)| ≤ 2 * h :=
    abs_le.mpr ⟨by omega, by omega⟩
  have heq := seed_continuations_equal word (continuation trueSlot)
    (continuation reference) (center + delta trueSlot) (center + delta reference)
    K d (period trueSlot) (period reference) (2 * h) hd hpt hpr hptd hprd
    hstarts hsize hct hcr hwt hwr
  have hqr : FirstMismatch word (continuation reference)
      (center + delta reference + K) q := by
    rw [← heq]
    apply first_mismatch_transport hq
    intro x hx hxe
    have hpos : 0 < d * d := mul_pos hd hd
    by_cases horder : delta trueSlot ≤ delta reference
    · rw [heq]
      exact hwr x (by omega) (by omega)
    · exact hwt x (by omega) (by omega)
  simpa only [EndRule, hrs] using (show ∃ r, FirstMismatch word (continuation reference)
    (center + delta reference + K) r ∧ actual = r + tail from ⟨q, hqr, haq⟩)

theorem surviving_copy_has_unique_witness {ι κ : Type*}
    [DecidableEq ι] [DecidableEq κ]
    (slots : Finset ι) (witness : ι → ι → Prop) (kind : ι → κ) (μ bound : ℕ)
    (hbound : ((slots ×ˢ slots).filter
      (fun pair => pair.1 ≠ pair.2 ∧ witness pair.1 pair.2)).card ≤ bound)
    (hμ : bound < μ) (k : κ)
    (hcopies : (slots.filter (fun p => kind p = k)).card = μ)
    (hdiagonal : ∀ p ∈ slots, witness p p) :
    ∃ p ∈ slots, kind p = k ∧ ∃! p', p' ∈ slots ∧ witness p p' := by
  obtain ⟨_, p, hp, hpk, hgood⟩ := stencil_completeness slots witness kind μ bound
    hbound hμ k hcopies
  refine ⟨p, hp, hpk, p, ⟨hp, hdiagonal p hp⟩, ?_⟩
  intro p' hp'
  by_contra hne
  exact hgood p' hp'.1 (Ne.symm hne) hp'.2

theorem end_margin_internal {z q bound tail smaller : ℤ}
    (hq : z - smaller ≤ q) (htail : smaller + bound < tail) :
    z + bound < q + tail := by omega

theorem missing_window_rejects {ι : Type*} (windows : Finset ι)
    (available : ι → Prop) (accepts : Prop)
    (hmandatory : accepts → ∀ i ∈ windows, available i)
    (hmissing : ∃ i ∈ windows, ¬ available i) : ¬ accepts := by
  intro ha
  obtain ⟨i, hi, hno⟩ := hmissing
  exact hno (hmandatory ha i hi)

end DecoderAudit

#print axioms DecoderAudit.whole_stencil_bound
#print axioms DecoderAudit.decoder_success_and_endpoint
#print axioms DecoderAudit.surviving_copy_has_unique_witness
