import Mathlib

open Finset

noncomputable section

namespace SignedContinuation

abbrev Dart (V : Type*) (degree : ℕ) := V × Fin degree

structure Incidences (V : Type*) (degree : ℕ) where
  reverse : Dart V degree → Dart V degree
  involutive : Function.Involutive reverse
  no_fixed : ∀ e, reverse e ≠ e

variable {V X Z : Type*} {degree : ℕ}

inductive Matched (G : Incidences V degree) (compatible : V → X → Prop)
    (near : X → X → Prop) : ℕ → Dart V degree → X → Prop
  | single (e : Dart V degree) (j k : X)
      (left : compatible e.1 j) (right : compatible (G.reverse e).1 k)
      (step : near j k) : Matched G compatible near 1 e j
  | prepend {t : ℕ} (e f : Dart V degree) (j k : X)
      (join : f.1 = (G.reverse e).1) (nonreverse : f ≠ G.reverse e)
      (left : compatible e.1 j) (step : near j k)
      (tail : Matched G compatible near t f k) :
      Matched G compatible near (t + 1) e j

namespace Matched

variable {G : Incidences V degree} {c : V → X → Prop} {q : X → X → Prop}

theorem positive {t e j} (h : Matched G c q t e j) : 0 < t := by
  cases h <;> omega

theorem start {t e j} (h : Matched G c q t e j) : c e.1 j := by
  cases h <;> assumption

theorem first {t e j} (h : Matched G c q t e j) : Matched G c q 1 e j := by
  cases h with
  | single e j k hx hy hq => exact .single e j k hx hy hq
  | prepend e f j k hj hn hx hq ht =>
      exact .single e j k hx (hj ▸ ht.start) hq

theorem take_length {t e j} (h : Matched G c q t e j) :
    ∀ m, 0 < m → m ≤ t → Matched G c q m e j := by
  induction h with
  | single e j k hx hy hq =>
      intro m hm hmt
      have heq : m = 1 := by omega
      subst m
      exact .single e j k hx hy hq
  | @prepend t e f j k hj hn hx hq ht ih =>
      intro m hm hmt
      by_cases heq : m = 1
      · subst m
        exact .single e j k hx (hj ▸ ht.start) hq
      · have hp := ih (m - 1) (by omega) (by omega)
        have h := Matched.prepend e f j k hj hn hx hq hp
        convert h using 1
        omega

end Matched

def Good (G : Incidences V degree) (c : V → X → Prop) (q : X → X → Prop)
    (n : ℕ) (x : V) : Prop :=
  ¬ ∃ (e : Dart V degree) (j : X), e.1 = x ∧ Matched G c q n e j

def record (G : Incidences V degree) (c : V → X → Prop) (q : X → X → Prop)
    (n : ℕ) (e : Dart V degree) (j : X) : ℕ := by
  classical
  exact Nat.findGreatest (fun t => Matched G c q t e j) (n - 1)

def Exceptional (G : Incidences V degree) (c : V → X → Prop)
    (q : X → X → Prop) (n : ℕ) (e : Dart V degree) (j : X) : Prop :=
  ¬ Good G c q n e.1 ∨
    ∀ d : Fin degree, d ≠ e.2 → record G c q n (e.1, d) j < record G c q n e j

section Records

variable (G : Incidences V degree) (c : V → X → Prop) (q : X → X → Prop)
    {n : ℕ}

theorem matched_lt (hn : 0 < n) {t e j} (hg : Good G c q n e.1)
    (hw : Matched G c q t e j) : t < n := by
  by_contra ht
  exact hg ⟨e, j, rfl, hw.take_length n hn (by omega)⟩

theorem record_ge (hn : 0 < n) {t e j} (hg : Good G c q n e.1)
    (hw : Matched G c q t e j) : t ≤ record G c q n e j := by
  classical
  exact Nat.le_findGreatest (by have := matched_lt G c q hn hg hw; omega) hw

theorem record_witness {e j} (hp : 0 < record G c q n e j) :
    Matched G c q (record G c q n e j) e j := by
  classical
  exact Nat.findGreatest_of_ne_zero rfl (Nat.ne_of_gt hp)

theorem exceptional_unique {x : V} {j : X} {d f : Fin degree}
    (hg : Good G c q n x)
    (hd : Exceptional G c q n (x, d) j)
    (hf : Exceptional G c q n (x, f) j) : d = f := by
  by_contra hne
  have h1 := (hd.resolve_left (not_not_intro hg)) f (Ne.symm hne)
  have h2 := (hf.resolve_left (not_not_intro hg)) d hne
  dsimp only at h1 h2
  omega

theorem exceptional_cover (hn : 0 < n) (symmetric : ∀ ⦃j k⦄, q j k → q k j)
    {e : Dart V degree} {j k : X}
    (hx : c e.1 j) (hy : c (G.reverse e).1 k) (hjk : q j k) :
    Exceptional G c q n e j ∨ Exceptional G c q n (G.reverse e) k := by
  classical
  by_cases gx : Good G c q n e.1
  · by_cases gy : Good G c q n (G.reverse e).1
    · by_contra h
      have hex : ¬ Exceptional G c q n e j := fun he => h (Or.inl he)
      have hey : ¬ Exceptional G c q n (G.reverse e) k := fun he => h (Or.inr he)
      have rx : 1 ≤ record G c q n e j :=
        record_ge G c q hn gx (.single e j k hx hy hjk)
      have ry : 1 ≤ record G c q n (G.reverse e) k := by
        apply record_ge G c q hn gy
        simpa only [G.involutive e] using
          (Matched.single (G.reverse e) k j hy (by simpa only [G.involutive e] using hx)
            (symmetric hjk))
      have ax : ¬ ∀ d : Fin degree, d ≠ e.2 →
          record G c q n (e.1, d) j < record G c q n e j :=
        fun ha => hex (Or.inr ha)
      have ay : ¬ ∀ d : Fin degree, d ≠ (G.reverse e).2 →
          record G c q n ((G.reverse e).1, d) k <
            record G c q n (G.reverse e) k :=
        fun ha => hey (Or.inr ha)
      push Not at ax ay
      obtain ⟨dx, hdx, hrx⟩ := ax
      obtain ⟨dy, hdy, hry⟩ := ay
      have wx := record_witness G c q
        (show 0 < record G c q n (e.1, dx) j by omega)
      have wy := record_witness G c q
        (show 0 < record G c q n ((G.reverse e).1, dy) k by omega)
      have fx : (e.1, dx) ≠ e := by
        intro he
        exact hdx (congrArg Prod.snd he)
      have fy : ((G.reverse e).1, dy) ≠ G.reverse e := by
        intro he
        exact hdy (congrArg Prod.snd he)
      have lx := record_ge G c q hn gx
        (Matched.prepend e ((G.reverse e).1, dy) j k rfl fy hx hjk wy)
      have ly := record_ge G c q hn gy
        (Matched.prepend (G.reverse e) (e.1, dx) k j
          (by simp only [G.involutive e])
          (by simpa only [G.involutive e] using fx) hy (symmetric hjk) wx)
      omega
    · exact Or.inr (Or.inl gy)
  · exact Or.inl (Or.inl gx)

end Records

structure BumpData (G : Incidences V degree) (X Z : Type*)
    [MetricSpace X] [PseudoMetricSpace Z] where
  L : ℝ
  K : ℝ
  nonnegative : 0 ≤ L
  states : Finset X
  sourceLabel : V → Z
  stateLabel : X → Z
  edge_label : ∀ e, dist (sourceLabel e.1) (sourceLabel (G.reverse e).1) ≤ 1
  label_lipschitz : ∀ j k, dist (stateLabel j) (stateLabel k) ≤ dist j k
  bump : V → X → ℝ
  bump_nonnegative : ∀ x j, 0 ≤ bump x j
  bump_le : ∀ x j, bump x j ≤ L
  bump_lipschitz : ∀ x j k, |bump x j - bump x k| ≤ dist j k
  bump_support : ∀ x j, 0 < bump x j → dist (sourceLabel x) (stateLabel j) < K

namespace BumpData

variable [MetricSpace X] [PseudoMetricSpace Z]
    {G : Incidences V degree} (D : BumpData G X Z)

def compatible (x : V) (j : X) : Prop :=
  j ∈ D.states ∧ dist (D.sourceLabel x) (D.stateLabel j) ≤ D.K + 2 * D.L + 1

def near (j k : X) : Prop := dist j k ≤ 2 * D.L

abbrev good (n : ℕ) (x : V) := Good G D.compatible D.near n x
abbrev exceptional (n : ℕ) (e : Dart V degree) (j : X) :=
  Exceptional G D.compatible D.near n e j

theorem near_symmetric : ∀ ⦃j k⦄, D.near j k → D.near k j := by
  intro j k h
  simpa only [near, dist_comm] using h

theorem label_transfer {x y : V} {j k : X}
    (he : dist (D.sourceLabel x) (D.sourceLabel y) ≤ 1)
    (hj : dist (D.sourceLabel x) (D.stateLabel j) < D.K)
    (hk : D.near j k) :
    dist (D.sourceLabel y) (D.stateLabel k) ≤ D.K + 2 * D.L + 1 := by
  have ht := dist_triangle (D.sourceLabel y) (D.sourceLabel x) (D.stateLabel k)
  have hu := dist_triangle (D.sourceLabel x) (D.stateLabel j) (D.stateLabel k)
  have hl := D.label_lipschitz j k
  rw [dist_comm (D.sourceLabel y) (D.sourceLabel x)] at ht
  change dist j k ≤ 2 * D.L at hk
  linarith

theorem compatible_positive {x : V} {j : X} (hj : j ∈ D.states)
    (hb : 0 < D.bump x j) : D.compatible x j := by
  refine ⟨hj, ?_⟩
  have := D.bump_support x j hb
  have := D.nonnegative
  linarith

theorem opposing_cross {n : ℕ} (hn : 0 < n) {e : Dart V degree} {j k : X}
    (hj : j ∈ D.states) (hk : k ∈ D.states)
    (hjx : ¬ D.exceptional n e j)
    (hky : ¬ D.exceptional n (G.reverse e) k) :
    D.bump e.1 j + D.bump (G.reverse e).1 k ≤ dist j k := by
  by_cases hnear : D.near j k
  · have bx : D.bump e.1 j = 0 := by
      have hnon := D.bump_nonnegative e.1 j
      by_contra hz
      have hp : 0 < D.bump e.1 j := lt_of_le_of_ne hnon (Ne.symm hz)
      have cx := D.compatible_positive hj hp
      have cy : D.compatible (G.reverse e).1 k :=
        ⟨hk, D.label_transfer (D.edge_label e) (D.bump_support e.1 j hp) hnear⟩
      exact (exceptional_cover G D.compatible D.near hn D.near_symmetric cx cy hnear).elim
        hjx hky
    have byy : D.bump (G.reverse e).1 k = 0 := by
      have hnon := D.bump_nonnegative (G.reverse e).1 k
      by_contra hz
      have hp : 0 < D.bump (G.reverse e).1 k := lt_of_le_of_ne hnon (Ne.symm hz)
      have cy := D.compatible_positive hk hp
      have cx : D.compatible e.1 j := by
        refine ⟨hj, ?_⟩
        have he : dist (D.sourceLabel (G.reverse e).1) (D.sourceLabel e.1) ≤ 1 := by
          simpa only [dist_comm] using D.edge_label e
        exact D.label_transfer he (D.bump_support (G.reverse e).1 k hp)
          (D.near_symmetric hnear)
      exact (exceptional_cover G D.compatible D.near hn D.near_symmetric cx cy hnear).elim
        hjx hky
    simpa only [bx, byy, zero_add] using dist_nonneg (x := j) (y := k)
  · have hb := D.bump_le e.1 j
    have hc := D.bump_le (G.reverse e).1 k
    change ¬ dist j k ≤ 2 * D.L at hnear
    linarith

def prescribedSet (n : ℕ) (e : Dart V degree) : Set X :=
  {j | j ∈ D.states ∧ (¬ D.exceptional n e j ∨ ¬ D.exceptional n (G.reverse e) j)}

def prescribedValue (n : ℕ) (e : Dart V degree) (j : X) : ℝ := by
  classical
  exact if ¬ D.exceptional n e j then D.bump e.1 j else -D.bump (G.reverse e).1 j

theorem value_left {n e j} (hj : ¬ D.exceptional n e j) :
    D.prescribedValue n e j = D.bump e.1 j := by
  classical
  simp [prescribedValue, hj]

theorem value_right {n : ℕ} (hn : 0 < n) {e j}
    (hs : j ∈ D.states) (hj : ¬ D.exceptional n (G.reverse e) j) :
    D.prescribedValue n e j = -D.bump (G.reverse e).1 j := by
  classical
  by_cases hx : ¬ D.exceptional n e j
  · rw [D.value_left hx]
    have h := D.opposing_cross hn hs hs hx hj
    simp only [dist_self] at h
    linarith [D.bump_nonnegative e.1 j, D.bump_nonnegative (G.reverse e).1 j]
  · simp [prescribedValue, hx]

theorem value_bounds {n e j} :
    -D.L ≤ D.prescribedValue n e j ∧ D.prescribedValue n e j ≤ D.L := by
  classical
  by_cases hx : ¬ D.exceptional n e j
  · rw [D.value_left hx]
    constructor <;> linarith [D.bump_nonnegative e.1 j, D.bump_le e.1 j, D.nonnegative]
  · simp only [prescribedValue, if_neg hx]
    constructor <;> linarith [D.bump_nonnegative (G.reverse e).1 j,
      D.bump_le (G.reverse e).1 j, D.nonnegative]

theorem prescribed_lipschitz {n : ℕ} (hn : 0 < n) (e : Dart V degree) :
    LipschitzOnWith 1 (D.prescribedValue n e) (D.prescribedSet n e) := by
  classical
  rw [lipschitzOnWith_iff_dist_le_mul]
  intro j hj k hk
  rcases hj with ⟨hjs, hjx | hjy⟩ <;> rcases hk with ⟨hks, hkx | hky⟩
  · simpa only [Real.dist_eq, one_mul, NNReal.coe_one, D.value_left hjx,
      D.value_left hkx] using D.bump_lipschitz e.1 j k
  · rw [D.value_left hjx, D.value_right hn hks hky, Real.dist_eq,
      NNReal.coe_one, one_mul, sub_neg_eq_add, abs_of_nonneg
        (add_nonneg (D.bump_nonnegative _ _) (D.bump_nonnegative _ _))]
    exact D.opposing_cross hn hjs hks hjx hky
  · rw [D.value_right hn hjs hjy, D.value_left hkx, Real.dist_eq,
      NNReal.coe_one, one_mul]
    have h := D.opposing_cross hn hks hjs hkx hjy
    rw [dist_comm k j] at h
    rw [show -D.bump (G.reverse e).1 j - D.bump e.1 k =
      -(D.bump e.1 k + D.bump (G.reverse e).1 j) by ring, abs_neg,
      abs_of_nonneg (add_nonneg (D.bump_nonnegative _ _) (D.bump_nonnegative _ _))]
    exact h
  · rw [D.value_right hn hjs hjy, D.value_right hn hks hky, Real.dist_eq,
      NNReal.coe_one, one_mul]
    simpa only [neg_sub_neg, abs_sub_comm] using D.bump_lipschitz (G.reverse e).1 j k

theorem opposing_tests {n : ℕ} (hn : 0 < n) (e : Dart V degree) :
    ∃ f : X → ℝ, LipschitzWith 1 f ∧
      (∀ j, -D.L ≤ f j ∧ f j ≤ D.L) ∧
      (∀ j ∈ D.states, ¬ D.exceptional n e j → f j = D.bump e.1 j) ∧
      (∀ j ∈ D.states, ¬ D.exceptional n (G.reverse e) j →
        f j = -D.bump (G.reverse e).1 j) := by
  obtain ⟨g, hg, heq⟩ := (D.prescribed_lipschitz hn e).extend_real
  let f : X → ℝ := fun j => max (-D.L) (min D.L (g j))
  have hf : LipschitzWith 1 f := (hg.const_min D.L).const_max (-D.L)
  have hbounds : ∀ j, -D.L ≤ f j ∧ f j ≤ D.L := by
    intro j
    exact ⟨le_max_left _ _, max_le (by linarith [D.nonnegative]) (min_le_left _ _)⟩
  have hagree : ∀ j ∈ D.prescribedSet n e, f j = D.prescribedValue n e j := by
    intro j hj
    have hv := D.value_bounds (n := n) (e := e) (j := j)
    have hh := heq hj
    change max (-D.L) (min D.L (g j)) = _
    rw [← hh, min_eq_right hv.2, max_eq_right hv.1]
  refine ⟨f, hf, hbounds, ?_, ?_⟩
  · intro j hs hx
    exact (hagree j ⟨hs, Or.inl hx⟩).trans (D.value_left hx)
  · intro j hs hy
    exact (hagree j ⟨hs, Or.inr hy⟩).trans (D.value_right hn hs hy)

end BumpData

theorem signed_loss [MetricSpace X] (s : Finset X) (L : ℝ)
    (b f mu : X → ℝ) (E : X → Prop) [DecidablePred E]
    (hb : ∀ j ∈ s, 0 ≤ b j ∧ b j ≤ L)
    (hf : ∀ j ∈ s, -L ≤ f j ∧ f j ≤ L)
    (heq : ∀ j ∈ s, ¬ E j → f j = b j) :
    (∑ j ∈ s, b j * mu j) - 2 * L * (∑ j ∈ s, if E j then |mu j| else 0) ≤
      ∑ j ∈ s, f j * mu j := by
  classical
  have hp : ∀ j ∈ s, b j * mu j - 2 * L * (if E j then |mu j| else 0) ≤
      f j * mu j := by
    intro j hj
    by_cases hE : E j
    · rw [if_pos hE]
      have hd : |f j - b j| ≤ 2 * L := by
        apply abs_le.mpr
        constructor <;> linarith [(hb j hj).1, (hb j hj).2, (hf j hj).1, (hf j hj).2]
      have hm := mul_le_mul_of_nonneg_right hd (abs_nonneg (mu j))
      rw [← abs_mul] at hm
      have hl := (abs_le.mp hm).1
      nlinarith
    · rw [if_neg hE, mul_zero, sub_zero, heq j hj hE]
  have h := Finset.sum_le_sum hp
  simpa only [Finset.sum_sub_distrib, Finset.mul_sum] using h

theorem sum_unique_indicator {A : Type*} [Fintype A] (P : A → Prop) [DecidablePred P]
    (w : ℝ) (hw : 0 ≤ w) (hu : ∀ a b, P a → P b → a = b) :
    (∑ a : A, if P a then w else 0) ≤ w := by
  classical
  by_cases h : ∃ a, P a
  · obtain ⟨a, ha⟩ := h
    have hs : (∑ b : A, if P b then w else 0) = (if P a then w else 0) := by
      apply Finset.sum_eq_single a
      · intro b _ hba
        have hn : ¬ P b := fun hb => hba (hu b a hb ha)
        simp only [if_neg hn]
      · intro hh
        exact (hh (Finset.mem_univ a)).elim
    simpa only [if_pos ha] using hs.le
  · have hn : ∀ a, ¬ P a := by simpa only [not_exists] using h
    simpa only [if_neg (hn _), Finset.sum_const_zero] using hw

namespace BumpData

variable [MetricSpace X] [PseudoMetricSpace Z]
    {G : Incidences V degree} (D : BumpData G X Z)

def variation (mu : V → X → ℝ) (x : V) : ℝ :=
  ∑ j ∈ D.states, |mu x j|

def loss (n : ℕ) (mu : V → X → ℝ) (e : Dart V degree) : ℝ := by
  classical
  exact ∑ j ∈ D.states, if D.exceptional n e j then |mu e.1 j| else 0

theorem edge_bound {n : ℕ} (hn : 0 < n) (mu : V → X → ℝ) (a0 Lambda : ℝ)
    (bump_mass : ∀ x, a0 ≤ ∑ j ∈ D.states, D.bump x j * mu x j)
    (upper : ∀ (e : Dart V degree) (f : X → ℝ), LipschitzWith 1 f →
      (∀ j, -D.L ≤ f j ∧ f j ≤ D.L) →
      |∑ j ∈ D.states, f j * (mu e.1 j - mu (G.reverse e).1 j)| ≤ Lambda)
    (e : Dart V degree) :
    2 * a0 - 2 * D.L * (D.loss n mu e + D.loss n mu (G.reverse e)) ≤ Lambda := by
  classical
  obtain ⟨f, hfl, hfb, hfx, hfy⟩ := D.opposing_tests hn e
  have hx := signed_loss D.states D.L (D.bump e.1) f (mu e.1) (D.exceptional n e)
    (fun j _ => ⟨D.bump_nonnegative _ _, D.bump_le _ _⟩)
    (fun j _ => hfb j) hfx
  have hy := signed_loss D.states D.L (D.bump (G.reverse e).1) (fun j => -f j)
    (mu (G.reverse e).1) (D.exceptional n (G.reverse e))
    (fun j _ => ⟨D.bump_nonnegative _ _, D.bump_le _ _⟩)
    (fun j _ => ⟨by linarith [(hfb j).2], by linarith [(hfb j).1]⟩)
    (fun j hj he => by rw [hfy j hj he]; ring)
  change (∑ j ∈ D.states, D.bump e.1 j * mu e.1 j) -
    2 * D.L * D.loss n mu e ≤ _ at hx
  change (∑ j ∈ D.states, D.bump (G.reverse e).1 j * mu (G.reverse e).1 j) -
    2 * D.L * D.loss n mu (G.reverse e) ≤ _ at hy
  have hpair : (∑ j ∈ D.states, f j * (mu e.1 j - mu (G.reverse e).1 j)) =
      (∑ j ∈ D.states, f j * mu e.1 j) +
        (∑ j ∈ D.states, (-f j) * mu (G.reverse e).1 j) := by
    simp only [mul_sub, Finset.sum_sub_distrib, neg_mul, Finset.sum_neg_distrib]
    ring
  have hu := le_trans (le_abs_self _) (upper e f hfl hfb)
  rw [hpair] at hu
  linarith [bump_mass e.1, bump_mass (G.reverse e).1]

theorem good_loss_sum {n : ℕ} (mu : V → X → ℝ) {x : V} (hg : D.good n x) :
    (∑ d : Fin degree, D.loss n mu (x, d)) ≤ D.variation mu x := by
  classical
  unfold loss variation
  rw [Finset.sum_comm]
  apply Finset.sum_le_sum
  intro j hj
  exact sum_unique_indicator (fun d => D.exceptional n (x, d) j) |mu x j|
    (abs_nonneg _) (fun d f hd hf => exceptional_unique G D.compatible D.near hg hd hf)

def badCount [Fintype V] (n : ℕ) : ℕ := by
  classical
  exact ∑ x : V, if D.good n x then 0 else 1

def badFraction [Fintype V] (n : ℕ) : ℝ :=
  (D.badCount n : ℝ) / (Fintype.card V : ℝ)

theorem total_loss [Fintype V] {n : ℕ} (mu : V → X → ℝ) (Vbound : ℝ)
    (hv0 : 0 ≤ Vbound) (hv : ∀ x, D.variation mu x ≤ Vbound) :
    (∑ e : Dart V degree, D.loss n mu e) ≤
      (Fintype.card V : ℝ) * Vbound + (degree : ℝ) * Vbound * (D.badCount n : ℝ) := by
  classical
  have hvertex : ∀ x : V, (∑ d : Fin degree, D.loss n mu (x, d)) ≤
      Vbound + (degree : ℝ) * Vbound * (if D.good n x then 0 else 1) := by
    intro x
    by_cases hg : D.good n x
    · simpa only [if_pos hg, mul_zero, add_zero] using (D.good_loss_sum mu hg).trans (hv x)
    · have heq : ∀ d : Fin degree, D.loss n mu (x, d) = D.variation mu x := by
        intro d
        unfold loss variation
        apply Finset.sum_congr rfl
        intro j hj
        exact if_pos (Or.inl hg)
      simp only [heq, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
        nsmul_eq_mul, if_neg hg, mul_one]
      have hm := mul_le_mul_of_nonneg_left (hv x) (Nat.cast_nonneg degree : (0 : ℝ) ≤ degree)
      linarith
  have hbad : (∑ x : V, if D.good n x then (0 : ℝ) else 1) = (D.badCount n : ℝ) := by
    simp [badCount]
  calc
    (∑ e : Dart V degree, D.loss n mu e) =
        ∑ x : V, ∑ d : Fin degree, D.loss n mu (x, d) := by
      exact Fintype.sum_prod_type _
    _ ≤ ∑ x : V, (Vbound + (degree : ℝ) * Vbound * (if D.good n x then 0 else 1)) :=
      Finset.sum_le_sum (fun x _ => hvertex x)
    _ = (Fintype.card V : ℝ) * Vbound +
        (degree : ℝ) * Vbound * (D.badCount n : ℝ) := by
      rw [Finset.sum_add_distrib, ← Finset.mul_sum, hbad]
      simp

theorem reverse_sum (G : Incidences V degree) [Fintype V] (f : Dart V degree → ℝ) :
    (∑ e, f (G.reverse e)) = ∑ e, f e := by
  exact Fintype.sum_bijective G.reverse G.involutive.bijective _ _ (fun _ => rfl)

theorem signed_continuation [Fintype V] [Nonempty V] {n : ℕ}
    (hn : 0 < n) (hd : 0 < degree) (mu : V → X → ℝ) (a0 Vbound Lambda : ℝ)
    (hv0 : 0 ≤ Vbound) (hv : ∀ x, D.variation mu x ≤ Vbound)
    (bump_mass : ∀ x, a0 ≤ ∑ j ∈ D.states, D.bump x j * mu x j)
    (upper : ∀ (e : Dart V degree) (f : X → ℝ), LipschitzWith 1 f →
      (∀ j, -D.L ≤ f j ∧ f j ≤ D.L) →
      |∑ j ∈ D.states, f j * (mu e.1 j - mu (G.reverse e).1 j)| ≤ Lambda) :
    2 * a0 - 4 * D.L * Vbound * (1 / (degree : ℝ) + D.badFraction n) ≤ Lambda := by
  classical
  have hcard : (Fintype.card (Dart V degree) : ℝ) =
      (Fintype.card V : ℝ) * (degree : ℝ) := by
    simp [Dart, Fintype.card_prod]
  have hs : ((Fintype.card V : ℝ) * (degree : ℝ)) * (2 * a0) -
      4 * D.L * (∑ e : Dart V degree, D.loss n mu e) ≤
        ((Fintype.card V : ℝ) * (degree : ℝ)) * Lambda := by
    calc
      _ = ∑ e : Dart V degree,
          (2 * a0 - 2 * D.L * (D.loss n mu e + D.loss n mu (G.reverse e))) := by
        simp only [Finset.sum_sub_distrib, ← Finset.mul_sum, Finset.sum_add_distrib,
          reverse_sum G, Finset.sum_const, Finset.card_univ, nsmul_eq_mul, hcard]
        ring
      _ ≤ ∑ _e : Dart V degree, Lambda :=
        Finset.sum_le_sum (fun e _ => D.edge_bound hn mu a0 Lambda bump_mass upper e)
      _ = _ := by simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul, hcard]
  have he := D.total_loss (n := n) mu Vbound hv0 hv
  have he' := mul_le_mul_of_nonneg_left he (show 0 ≤ 4 * D.L by nlinarith [D.nonnegative])
  have hscaled :
      ((Fintype.card V : ℝ) * (degree : ℝ)) * (2 * a0) -
        4 * D.L * ((Fintype.card V : ℝ) * Vbound +
          (degree : ℝ) * Vbound * (D.badCount n : ℝ)) ≤
      ((Fintype.card V : ℝ) * (degree : ℝ)) * Lambda := by linarith
  have hN : (0 : ℝ) < Fintype.card V := Nat.cast_pos.mpr Fintype.card_pos
  have hdeg : (0 : ℝ) < degree := Nat.cast_pos.mpr hd
  have halgebra :
      ((Fintype.card V : ℝ) * (degree : ℝ)) *
        (2 * a0 - 4 * D.L * Vbound * (1 / (degree : ℝ) + D.badFraction n)) =
      ((Fintype.card V : ℝ) * (degree : ℝ)) * (2 * a0) -
        4 * D.L * ((Fintype.card V : ℝ) * Vbound +
          (degree : ℝ) * Vbound * (D.badCount n : ℝ)) := by
    unfold badFraction
    field_simp [ne_of_gt hN, ne_of_gt hdeg]
    <;> ring
  have hbound :
      ((Fintype.card V : ℝ) * (degree : ℝ)) *
        (2 * a0 - 4 * D.L * Vbound * (1 / (degree : ℝ) + D.badFraction n)) ≤
      ((Fintype.card V : ℝ) * (degree : ℝ)) * Lambda := by
    rw [halgebra]
    exact hscaled
  apply le_of_not_gt
  intro hbad
  exact (not_lt_of_ge hbound) (mul_lt_mul_of_pos_left hbad (mul_pos hN hdeg))

end BumpData

theorem manuscript_margin (p L Vbound Lambda a0 beta delta : ℝ)
    (hp : 1 ≤ p) (hL : L = 10 * p) (ha : a0 = 3 * L / 4) (hLambda : Lambda = 2 * p)
    (h1 : Vbound / delta < 1 / 20) (h2 : Vbound * beta < 1 / 20)
    (hcore : 2 * a0 - 4 * L * Vbound * (1 / delta + beta) ≤ Lambda) : False := by
  have hpos : 0 < 4 * L := by nlinarith
  have herr : Vbound * (1 / delta + beta) < 1 / 10 := by
    have heq : Vbound * (1 / delta + beta) = Vbound / delta + Vbound * beta := by ring
    rw [heq]
    linarith
  have hmul := mul_lt_mul_of_pos_left herr hpos
  nlinarith

#print axioms BumpData.signed_continuation
#print axioms BumpData.opposing_tests
#print axioms exceptional_cover
#print axioms manuscript_margin

end SignedContinuation
