import Mathlib

set_option autoImplicit false

namespace PackingAudit

def Noncrossing (E : ℕ → ℕ → Prop) : Prop :=
  ∀ a b c d, E a b → E c d → a < c → c < b → b < d → False

inductive Within (E : ℕ → ℕ → Prop) (S : Set ℕ) : ℕ → ℕ → Prop
  | nil {a : ℕ} (ha : a ∈ S) : Within E S a a
  | cons {a b c : ℕ} (ha : a ∈ S) (hab : E a b)
      (tail : Within E S b c) : Within E S a c

theorem Within.start_mem {E : ℕ → ℕ → Prop} {S : Set ℕ} {a b : ℕ}
    (p : Within E S a b) : a ∈ S := by
  cases p with
  | nil h => exact h
  | cons h _ _ => exact h

theorem edge_stays_inside {E : ℕ → ℕ → Prop}
    (hs : ∀ ⦃u v⦄, E u v → E v u) (hn : Noncrossing E)
    {a b x y : ℕ} (hab : E a b) (hxy : E x y)
    (hx : a < x ∧ x < b) (hya : y ≠ a) (hyb : y ≠ b) :
    a < y ∧ y < b := by
  by_contra h
  have ho : y < a ∨ b < y := by omega
  rcases ho with h | h
  · exact hn y x a b (hs hxy) hab h hx.1 hx.2
  · exact hn a b x y hab hxy hx.1 hx.2 h

theorem Within.stays_inside {E : ℕ → ℕ → Prop} {S : Set ℕ}
    (hs : ∀ ⦃u v⦄, E u v → E v u) (hn : Noncrossing E)
    {a b x y : ℕ} (hab : E a b) (ha : a ∉ S) (hb : b ∉ S)
    (p : Within E S x y) (hx : a < x ∧ x < b) :
    a < y ∧ y < b := by
  induction p with
  | nil _ => exact hx
  | @cons u v w hu huv tail ih =>
      apply ih
      exact edge_stays_inside hs hn hab huv hx
        (fun h => ha (h ▸ tail.start_mem))
        (fun h => hb (h ▸ tail.start_mem))

theorem gap_of_connected_low_set {E : ℕ → ℕ → Prop} {S : Set ℕ}
    (hs : ∀ ⦃u v⦄, E u v → E v u) (hn : Noncrossing E)
    (hconn : ∀ x ∈ S, Within E S x 0)
    {a b : ℕ} (hab : E a b) (ha : a ∉ S) (hb : b ∉ S) :
    ∀ x ∈ S, ¬ (a < x ∧ x < b) := by
  intro x hx hi
  have h := (hconn x hx).stays_inside hs hn hab ha hb hi
  omega

inductive Trace {N : Type*} (step : N → N → Prop) : N → N → Type _
  | nil (x : N) : Trace step x x
  | cons {x y z : N} (h : step x y) (tail : Trace step y z) :
      Trace step x z

def Trace.length {N : Type*} {step : N → N → Prop} (cost : N → N → ℝ)
    {x y : N} : Trace step x y → ℝ
  | .nil _ => 0
  | @Trace.cons _ _ u v _ _ tail => cost u v + tail.length cost

def Trace.At {N : Type*} {step : N → N → Prop} (cost : N → N → ℝ)
    {x y : N} : Trace step x y → N → ℝ → Prop
  | .nil x, v, t => v = x ∧ t = 0
  | @Trace.cons _ _ u v _ _ tail, w, t =>
      (w = u ∧ t = 0) ∨ ∃ q, tail.At cost w q ∧ t = cost u v + q

theorem Trace.at_start {N : Type*} {step : N → N → Prop}
    (cost : N → N → ℝ) {x y : N} (p : Trace step x y) :
    p.At cost x 0 := by
  cases p <;> simp [Trace.At]

variable {N X : Type*} [PseudoMetricSpace X]

structure Model (N X : Type*) [PseudoMetricSpace X] where
  col : N → ℕ
  point : N → X
  link : ℕ → ℕ → Prop
  symmetric : ∀ ⦃u v⦄, link u v → link v u
  noncrossing : Noncrossing link
  switch : N → N → Prop
  switch_symmetric : ∀ ⦃u v⦄, switch u v → switch v u
  switch_spec : ∀ u v, switch u v →
    link (col u) (col v) ∧ point u = point v
  step : N → N → Prop
  step_spec : ∀ u v, step u v → col u = col v ∨ switch u v
  cost : N → N → ℝ
  dist_le_cost : ∀ u v, step u v → dist (point u) (point v) ≤ cost u v
  -- Bounded band paths may be absent between distinct band components.
  Near : N → N → ℝ → Prop
  near_refl : ∀ u, Near u u 0
  near_symm : ∀ {u v r}, Near u v r → Near v u r
  near_trans : ∀ {u v w r t}, Near u v r → Near v w t → Near u w (r + t)
  near_mono : ∀ {u v r t}, Near u v r → r ≤ t → Near u v t
  near_dist : ∀ {u v r}, Near u v r → dist (point u) (point v) ≤ r
  near_step : ∀ u v, step u v → Near u v (cost u v)
  near_switch : ∀ u v, switch u v → Near u v 0

variable (M : Model N X)

theorem length_nonneg {x y : N} (p : Trace M.step x y) :
    0 ≤ p.length M.cost := by
  induction p with
  | nil => simp [Trace.length]
  | @cons u v w h tail ih =>
      have hc := le_trans dist_nonneg (M.dist_le_cost u v h)
      simpa [Trace.length] using add_nonneg hc ih

theorem at_bounds {x y v : N} (p : Trace M.step x y) {t : ℝ}
    (h : p.At M.cost v t) :
    0 ≤ t ∧ t ≤ p.length M.cost ∧
      dist (M.point x) (M.point v) ≤ t ∧
      dist (M.point v) (M.point y) ≤ p.length M.cost - t := by
  induction p generalizing v t with
  | nil u =>
      rcases h with ⟨rfl, rfl⟩
      simp [Trace.length]
  | @cons u w z he tail ih =>
      have hc : 0 ≤ M.cost u w := le_trans dist_nonneg (M.dist_le_cost u w he)
      rcases h with hh | ⟨q, hq, ht⟩
      · rcases hh with ⟨hv, ht⟩
        subst v
        subst t
        have hb := ih (tail.at_start M.cost)
        refine ⟨le_rfl, ?_, by simp, ?_⟩
        · simpa [Trace.length] using add_nonneg hc (length_nonneg M tail)
        · have hd := dist_triangle (M.point u) (M.point w) (M.point z)
          simp only [Trace.length, sub_zero]
          linarith [M.dist_le_cost u w he, hb.2.2.2]
      · subst t
        have hb := ih hq
        refine ⟨by linarith [hb.1], ?_, ?_, ?_⟩
        · simp only [Trace.length]
          linarith [hb.2.1]
        · have hd := dist_triangle (M.point u) (M.point w) (M.point v)
          linarith [M.dist_le_cost u w he, hb.2.2.1]
        · simp only [Trace.length]
          linarith [hb.2.2.2]

theorem at_pair_distance {x y u v : N} (p : Trace M.step x y)
    {t r : ℝ} (hu : p.At M.cost u t) (hv : p.At M.cost v r) :
    dist (M.point u) (M.point v) ≤ |t - r| := by
  induction p generalizing u v t r with
  | nil x =>
      rcases hu with ⟨rfl, rfl⟩
      rcases hv with ⟨rfl, rfl⟩
      simp
  | @cons a b c he tail ih =>
      rcases hu with hhere | ⟨q, hq, ht⟩
      · rcases hhere with ⟨hu, ht⟩
        subst u
        subst t
        rcases hv with hhere | ⟨q, hq, hr⟩
        · rcases hhere with ⟨hv, hr⟩
          subst v
          subst r
          simp
        · subst r
          have h := at_bounds M (.cons he tail) (Or.inr ⟨q, hq, rfl⟩)
          simpa only [zero_sub, abs_neg, abs_of_nonneg h.1] using h.2.2.1
      · subst t
        rcases hv with hhere | ⟨q', hq', hr⟩
        · rcases hhere with ⟨hv, hr⟩
          subst v
          subst r
          have h := at_bounds M (.cons he tail) (Or.inr ⟨q, hq, rfl⟩)
          simpa only [sub_zero, abs_of_nonneg h.1, dist_comm] using h.2.2.1
        · subst r
          have h := ih hq hq'
          simpa only [add_sub_add_left_eq_sub] using h

theorem dist_end_le_length {x y : N} (p : Trace M.step x y) :
    dist (M.point x) (M.point y) ≤ p.length M.cost := by
  simpa only [sub_zero] using
    (at_bounds M p (p.at_start M.cost)).2.2.2

theorem at_near_start {x y v : N} (p : Trace M.step x y) {t : ℝ}
    (h : p.At M.cost v t) : M.Near x v t := by
  induction p generalizing v t with
  | nil u =>
      rcases h with ⟨rfl, rfl⟩
      exact M.near_refl _
  | @cons u w z he tail ih =>
      rcases h with hh | ⟨q, hq, ht⟩
      · rcases hh with ⟨hv, ht⟩
        subst v
        subst t
        exact M.near_refl _
      · subst t
        exact M.near_trans (M.near_step u w he) (ih hq)

theorem at_near_pair {x y u v : N} (p : Trace M.step x y)
    {t r : ℝ} (hu : p.At M.cost u t) (hv : p.At M.cost v r) :
    M.Near u v |t - r| := by
  induction p generalizing u v t r with
  | nil x =>
      rcases hu with ⟨rfl, rfl⟩
      rcases hv with ⟨rfl, rfl⟩
      simpa using M.near_refl v
  | @cons a b c he tail ih =>
      rcases hu with hhere | ⟨q, hq, ht⟩
      · rcases hhere with ⟨hu, ht⟩
        subst u
        subst t
        rcases hv with hhere | ⟨q, hq, hr⟩
        · rcases hhere with ⟨hv, hr⟩
          subst v
          subst r
          simpa using M.near_refl a
        · subst r
          have hat : (Trace.cons he tail).At M.cost v (M.cost a b + q) :=
            Or.inr ⟨q, hq, rfl⟩
          have hb := at_bounds M (.cons he tail) hat
          simpa only [zero_sub, abs_neg, abs_of_nonneg hb.1] using
            at_near_start M (.cons he tail) hat
      · subst t
        rcases hv with hhere | ⟨q', hq', hr⟩
        · rcases hhere with ⟨hv, hr⟩
          subst v
          subst r
          have hat : (Trace.cons he tail).At M.cost u (M.cost a b + q) :=
            Or.inr ⟨q, hq, rfl⟩
          have hb := at_bounds M (.cons he tail) hat
          simpa only [sub_zero, abs_of_nonneg hb.1] using
            M.near_symm (at_near_start M (.cons he tail) hat)
        · subst r
          simpa only [add_sub_add_left_eq_sub] using ih hq hq'

theorem descending_prefix {x y v : N} (p : Trace M.step x y)
    (s : X → ℝ) (hlip : ∀ u v, s u - s v ≤ dist u v)
    (err : ℝ) (hend : s (M.point y) ≤ s (M.point x) - p.length M.cost + err)
    {t : ℝ} (h : p.At M.cost v t) :
    s (M.point v) ≤ s (M.point x) - t + err := by
  have hb := at_bounds M p h
  linarith [hlip (M.point v) (M.point y), hb.2.2.2]

theorem trace_hits_boundary {a b : ℕ} (hab : M.link a b)
    {x y : N} (p : Trace M.step x y)
    (hx : a < M.col x ∧ M.col x < b)
    (hy : ¬ (a < M.col y ∧ M.col y < b)) :
    ∃ v t, p.At M.cost v t ∧ (M.col v = a ∨ M.col v = b) := by
  induction p with
  | nil => exact False.elim (hy hx)
  | @cons u v w he tail ih =>
      by_cases hv : M.col v = a ∨ M.col v = b
      · exact ⟨v, M.cost u v, Or.inr ⟨0, tail.at_start M.cost, by ring⟩, hv⟩
      · have hi : a < M.col v ∧ M.col v < b := by
          rcases M.step_spec u v he with h | h
          · simpa [← h] using hx
          · exact edge_stays_inside M.symmetric M.noncrossing hab
              (M.switch_spec u v h).1 hx
              (by tauto) (by tauto)
        obtain ⟨q, t, ht, hq⟩ := ih hi hy
        exact ⟨q, M.cost u v + t, Or.inr ⟨t, ht, rfl⟩, hq⟩

theorem trace_visits_or_skips {k : ℕ} {x y : N} (p : Trace M.step x y)
    (hbetween : (M.col x ≤ k ∧ k ≤ M.col y) ∨
      (M.col y ≤ k ∧ k ≤ M.col x)) :
    (∃ v t, p.At M.cost v t ∧ M.col v = k) ∨
    (∃ u v t r, p.At M.cost u t ∧ p.At M.cost v r ∧ M.step u v ∧
      ((M.col u < k ∧ k < M.col v) ∨ (M.col v < k ∧ k < M.col u))) := by
  induction p with
  | nil u =>
      have hc : M.col u = k := by omega
      exact Or.inl ⟨u, 0, by simp [Trace.At], hc⟩
  | @cons u v w he tail ih =>
      by_cases hu : M.col u = k
      · exact Or.inl ⟨u, 0, Or.inl ⟨rfl, rfl⟩, hu⟩
      by_cases hv : M.col v = k
      · exact Or.inl ⟨v, M.cost u v, Or.inr ⟨0, tail.at_start M.cost, by ring⟩, hv⟩
      by_cases hc : (M.col u < k ∧ k < M.col v) ∨
          (M.col v < k ∧ k < M.col u)
      · exact Or.inr ⟨u, v, 0, M.cost u v, Or.inl ⟨rfl, rfl⟩,
          Or.inr ⟨0, tail.at_start M.cost, by ring⟩, he, hc⟩
      have hb : (M.col v ≤ k ∧ k ≤ M.col w) ∨
          (M.col w ≤ k ∧ k ≤ M.col v) := by omega
      rcases ih hb with ⟨q, t, ht, hq⟩ | ⟨q, r, t, t', ht, ht', hqr, hq⟩
      · exact Or.inl ⟨q, M.cost u v + t, Or.inr ⟨t, ht, rfl⟩, hq⟩
      · exact Or.inr ⟨q, r, M.cost u v + t, M.cost u v + t',
          Or.inr ⟨t, ht, rfl⟩, Or.inr ⟨t', ht', rfl⟩, hqr, hq⟩

theorem near_skipping_switch
    (S : Set ℕ) (hzero : 0 ∈ S)
    (hconn : ∀ i ∈ S, Within M.link S i 0)
    (s : X → ℝ) (hlip : ∀ u v, s u - s v ≤ dist u v)
    (narrow : N → Prop) (a L T sep j err : ℝ)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (hgeometry : 2 * L + a + T < sep)
    {z w partner qend dend pend A B : N}
    (Q : Trace M.step z qend)
    (D : Trace M.step w dend) (D' : Trace M.step partner pend)
    (hQ : Q.length M.cost ≤ L)
    (hQavoid : ∀ v t, Q.At M.cost v t → M.col v ∉ S)
    (hQnarrow : ∀ v t, Q.At M.cost v t → narrow v)
    (hwz : dist (M.point z) (M.point w) ≤ L)
    (hpartner : sep ≤ dist (M.point w) (M.point partner))
    (hD' : D'.length M.cost ≤ T)
    (hDlow : M.col dend ∈ S) (hD'low : M.col pend ∈ S)
    (hdrop : s (M.point dend) ≤
      s (M.point w) - D.length M.cost + err)
    (hbar : ∀ u v, M.switch u v → narrow u → 0 < M.col u →
      M.col u < M.col w → M.col w < M.col v →
      (M.col partner < M.col u ∨ M.col v < M.col partner) →
      dist (M.point w) (M.point u) ≤ 2 * L →
      s (M.point w) - j ≤ s (M.point u))
    (hswitch : M.switch A B)
    (hinside : M.col A < M.col w ∧ M.col w < M.col B)
    {t r : ℝ} (hA : Q.At M.cost A t) (hB : Q.At M.cost B r) :
    M.Near w A (j + err + 2 * a) := by
  have hdiam : ∀ u v, M.col u = M.col v →
      dist (M.point u) (M.point v) ≤ a :=
    fun u v h => M.near_dist (hcolumn u v h)
  have hlink := (M.switch_spec A B hswitch).1
  have heq := (M.switch_spec A B hswitch).2
  have htoA : ∀ v, M.col v = M.col A ∨ M.col v = M.col B → M.Near v A a := by
    intro v h
    rcases h with h | h
    · exact hcolumn v A h
    · have hn := M.near_trans (hcolumn v B h)
        (M.near_switch B A (M.switch_symmetric hswitch))
      simpa only [add_zero] using hn
  have ha := hQavoid A t hA
  have hb := hQavoid B r hB
  have hgap := gap_of_connected_low_set M.symmetric M.noncrossing hconn hlink ha hb
  have hApos : 0 < M.col A := by
    by_contra h
    have he : M.col A = 0 := by omega
    exact ha (he ▸ hzero)
  have hnear : dist (M.point w) (M.point A) ≤ 2 * L := by
    have h := at_bounds M Q hA
    have ht := dist_triangle (M.point w) (M.point z) (M.point A)
    rw [dist_comm (M.point w) (M.point z)] at ht
    linarith [h.2.2.1, h.2.1]
  have hpartner_out : M.col partner < M.col A ∨ M.col B < M.col partner := by
    by_contra hout
    have hclosed : M.col A ≤ M.col partner ∧ M.col partner ≤ M.col B := by omega
    have hclose : dist (M.point partner) (M.point A) ≤ T + a := by
      by_cases hpa : M.col partner = M.col A
      · have ht : 0 ≤ T := le_trans (length_nonneg M D') hD'
        linarith [hdiam partner A hpa]
      by_cases hpb : M.col partner = M.col B
      · have ht : 0 ≤ T := le_trans (length_nonneg M D') hD'
        have hdist := hdiam partner B hpb
        rw [← heq] at hdist
        linarith
      have hpin : M.col A < M.col partner ∧ M.col partner < M.col B := by omega
      obtain ⟨v, p, hv, hboundary⟩ :=
        trace_hits_boundary M hlink D' hpin (hgap _ hD'low)
      have hbounds := at_bounds M D' hv
      have hve := M.near_dist (htoA v hboundary)
      have ht := dist_triangle (M.point partner) (M.point v) (M.point A)
      linarith [hbounds.2.2.1, hbounds.2.1]
    have ht := dist_triangle (M.point w) (M.point A) (M.point partner)
    rw [dist_comm (M.point A) (M.point partner)] at ht
    linarith
  have hnotlow := hbar A B hswitch (hQnarrow A t hA) hApos
    hinside.1 hinside.2 hpartner_out hnear
  obtain ⟨v, p, hv, hboundary⟩ :=
    trace_hits_boundary M hlink D hinside (hgap _ hDlow)
  have hveNear := htoA v hboundary
  have hve := M.near_dist hveNear
  have hprefix := descending_prefix M D s hlip err hdrop hv
  have hfield := hlip (M.point A) (M.point v)
  rw [dist_comm (M.point A) (M.point v)] at hfield
  have hp : p ≤ j + err + a := by linarith
  exact M.near_mono (M.near_trans (at_near_start M D hv) hveNear) (by linarith)

theorem localize_between
    (S : Set ℕ) (hzero : 0 ∈ S)
    (hconn : ∀ i ∈ S, Within M.link S i 0)
    (s : X → ℝ) (hlip : ∀ u v, s u - s v ≤ dist u v)
    (narrow : N → Prop) (a L T sep j err : ℝ)
    (hj : 0 ≤ j) (herr : 0 ≤ err)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (hgeometry : 2 * L + a + T < sep)
    {z w partner qend dend pend : N}
    (Q : Trace M.step z qend)
    (D : Trace M.step w dend) (D' : Trace M.step partner pend)
    (hQ : Q.length M.cost ≤ L)
    (hQavoid : ∀ v t, Q.At M.cost v t → M.col v ∉ S)
    (hQnarrow : ∀ v t, Q.At M.cost v t → narrow v)
    (hwz : dist (M.point z) (M.point w) ≤ L)
    (hpartner : sep ≤ dist (M.point w) (M.point partner))
    (hD' : D'.length M.cost ≤ T)
    (hDlow : M.col dend ∈ S) (hD'low : M.col pend ∈ S)
    (hdrop : s (M.point dend) ≤
      s (M.point w) - D.length M.cost + err)
    (hbar : ∀ u v, M.switch u v → narrow u → 0 < M.col u →
      M.col u < M.col w → M.col w < M.col v →
      (M.col partner < M.col u ∨ M.col v < M.col partner) →
      dist (M.point w) (M.point u) ≤ 2 * L →
      s (M.point w) - j ≤ s (M.point u))
    (hbetween : (M.col z ≤ M.col w ∧ M.col w ≤ M.col qend) ∨
      (M.col qend ≤ M.col w ∧ M.col w ≤ M.col z)) :
    ∃ v t, Q.At M.cost v t ∧
      M.Near w v (j + err + 2 * a) := by
  rcases trace_visits_or_skips M Q hbetween with
    ⟨v, t, hv, hc⟩ | ⟨u, v, t, r, hu, hv, hstep, hcross⟩
  · have ha : 0 ≤ a := by simpa using M.near_dist (hcolumn w w rfl)
    exact ⟨v, t, hv, M.near_mono (hcolumn w v hc.symm) (by linarith)⟩
  · have hswitch : M.switch u v := by
      rcases M.step_spec u v hstep with h | h
      · exfalso
        rcases hcross with hcross | hcross <;> omega
      · exact h
    rcases hcross with hcross | hcross
    · exact ⟨u, t, hu, near_skipping_switch M S hzero hconn s hlip narrow
        a L T sep j err hcolumn hgeometry Q D D' hQ hQavoid hQnarrow hwz
        hpartner hD' hDlow hD'low hdrop hbar hswitch hcross hu hv⟩
    · exact ⟨v, r, hv, near_skipping_switch M S hzero hconn s hlip narrow
        a L T sep j err hcolumn hgeometry Q D D' hQ hQavoid hQnarrow hwz
        hpartner hD' hDlow hD'low hdrop hbar (M.switch_symmetric hswitch)
        hcross hv hu⟩

structure Survivor (S : Set ℕ) (s : X → ℝ) (narrow : N → Prop)
    (L T sep j err : ℝ) (z w : N) where
  partner : N
  dend : N
  pend : N
  center : Trace M.step z w
  descent : Trace M.step w dend
  partner_descent : Trace M.step partner pend
  center_bound : center.length M.cost ≤ L
  center_avoid : ∀ v t, center.At M.cost v t → M.col v ∉ S
  center_narrow : ∀ v t, center.At M.cost v t → narrow v
  separated : sep ≤ dist (M.point w) (M.point partner)
  partner_bound : partner_descent.length M.cost ≤ T
  descent_low : M.col dend ∈ S
  partner_low : M.col pend ∈ S
  drop : s (M.point dend) ≤ s (M.point w) - descent.length M.cost + err
  barrier : ∀ u v, M.switch u v → narrow u → 0 < M.col u →
    M.col u < M.col w → M.col w < M.col v →
    (M.col partner < M.col u ∨ M.col v < M.col partner) →
    dist (M.point w) (M.point u) ≤ 2 * L →
    s (M.point w) - j ≤ s (M.point u)

theorem two_extreme_paths
    (S : Set ℕ) (hzero : 0 ∈ S)
    (hconn : ∀ i ∈ S, Within M.link S i 0)
    (s : X → ℝ) (hlip : ∀ u v, s u - s v ≤ dist u v)
    (narrow : N → Prop) (a L T sep j err : ℝ)
    (hj : 0 ≤ j) (herr : 0 ≤ err)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (hgeometry : 2 * L + a + T < sep)
    (F : Finset N) (hne : F.Nonempty) (z : N)
    (data : ∀ w ∈ F, Survivor M S s narrow L T sep j err z w) :
    ∃ (left right : N) (hl : left ∈ F) (hr : right ∈ F),
      ∀ w ∈ F,
        (∃ v t, (data left hl).center.At M.cost v t ∧
          M.Near w v (j + err + 2 * a)) ∨
        (∃ v t, (data right hr).center.At M.cost v t ∧
          M.Near w v (j + err + 2 * a)) := by
  classical
  let I := F.image M.col
  have hI : I.Nonempty := hne.image M.col
  obtain ⟨left, hl, hleft⟩ := Finset.mem_image.mp (I.min'_mem hI)
  obtain ⟨right, hr, hright⟩ := Finset.mem_image.mp (I.max'_mem hI)
  refine ⟨left, right, hl, hr, ?_⟩
  intro w hw
  have hmin : M.col left ≤ M.col w := by
    rw [hleft]
    exact I.min'_le _ (Finset.mem_image.mpr ⟨w, hw, rfl⟩)
  have hmax : M.col w ≤ M.col right := by
    rw [hright]
    exact I.le_max' _ (Finset.mem_image.mpr ⟨w, hw, rfl⟩)
  let d := data w hw
  have hwz : dist (M.point z) (M.point w) ≤ L :=
    le_trans (dist_end_le_length M d.center) d.center_bound
  by_cases hside : M.col w ≤ M.col z
  · apply Or.inl
    exact localize_between M S hzero hconn s hlip narrow a L T sep j err hj herr
      hcolumn hgeometry (data left hl).center d.descent d.partner_descent
      (data left hl).center_bound (data left hl).center_avoid
      (data left hl).center_narrow hwz d.separated d.partner_bound
      d.descent_low d.partner_low d.drop d.barrier (Or.inr ⟨hmin, hside⟩)
  · apply Or.inr
    have hside' : M.col z ≤ M.col w := by omega
    exact localize_between M S hzero hconn s hlip narrow a L T sep j err hj herr
      hcolumn hgeometry (data right hr).center d.descent d.partner_descent
      (data right hr).center_bound (data right hr).center_avoid
      (data right hr).center_narrow hwz d.separated d.partner_bound
      d.descent_low d.partner_low d.drop d.barrier (Or.inl ⟨hside', hmax⟩)

theorem two_lane_count {A : Type*} (F : Finset A)
    (lane : A → Bool) (time : A → ℝ) (L delta : ℝ)
    (hL : 0 ≤ L) (hd : 0 < delta)
    (ht : ∀ x ∈ F, 0 ≤ time x ∧ time x ≤ L)
    (hsep : ∀ x ∈ F, ∀ y ∈ F, x ≠ y → lane x = lane y →
      delta ≤ |time x - time y|) :
    (F.card : ℝ) ≤ 2 + 2 * L / delta := by
  classical
  let n := ⌊L / delta⌋₊
  let key : A → Bool × ℕ := fun x => (lane x, ⌊time x / delta⌋₊)
  have hmap : Set.MapsTo key (↑F) (↑((Finset.univ : Finset Bool) ×ˢ
      Finset.range (n + 1))) := by
    intro x hx
    have hf : ⌊time x / delta⌋₊ ≤ n :=
      Nat.floor_le_floor ((div_le_div_iff_of_pos_right hd).mpr (ht x hx).2)
    simp only [Finset.mem_coe, Finset.mem_product, Finset.mem_univ, true_and,
      Finset.mem_range, key]
    omega
  have hinj : Set.InjOn key (↑F) := by
    intro x hx y hy he
    by_contra hne
    have hlane : lane x = lane y := congrArg Prod.fst he
    have hfloor : ⌊time x / delta⌋₊ = ⌊time y / delta⌋₊ := congrArg Prod.snd he
    have hxlo := Nat.floor_le (div_nonneg (ht x hx).1 hd.le)
    have hylo := Nat.floor_le (div_nonneg (ht y hy).1 hd.le)
    have hxhi := Nat.lt_floor_add_one (time x / delta)
    have hyhi := Nat.lt_floor_add_one (time y / delta)
    rw [hfloor] at hxlo hxhi
    have h1 := (le_div_iff₀ hd).mp hxlo
    have h2 := (le_div_iff₀ hd).mp hylo
    have h3 := (div_lt_iff₀ hd).mp hxhi
    have h4 := (div_lt_iff₀ hd).mp hyhi
    have hlt : |time x - time y| < delta := by
      apply abs_lt.mpr
      constructor <;> nlinarith
    exact (not_lt_of_ge (hsep x hx y hy hne hlane)) hlt
  have hc : F.card ≤ 2 * (n + 1) := by
    simpa using Finset.card_le_card_of_injOn key hmap hinj
  have hcr : (F.card : ℝ) ≤ 2 * ((n : ℝ) + 1) := by exact_mod_cast hc
  have hn : (n : ℝ) ≤ L / delta := Nat.floor_le (div_nonneg hL hd.le)
  calc
    (F.card : ℝ) ≤ 2 + 2 * (L / delta) := by linarith
    _ = 2 + 2 * L / delta := by ring

theorem count_near_two_traces (F : Finset N) (z : N)
    (paths : Bool → Σ y, Trace M.step z y)
    (lane : N → Bool) (location : N → N) (time : N → ℝ)
    (L b rho : ℝ) (hL : 0 ≤ L) (hgap : 0 < b - 2 * rho)
    (hpath : ∀ side, (paths side).2.length M.cost ≤ L)
    (hat : ∀ w ∈ F, (paths (lane w)).2.At M.cost (location w) (time w))
    (hnear : ∀ w ∈ F, M.Near w (location w) rho)
    (hsep : ∀ u ∈ F, ∀ v ∈ F, u ≠ v → ∀ r, M.Near u v r → b ≤ r) :
    (F.card : ℝ) ≤ 2 + 2 * L / (b - 2 * rho) := by
  apply two_lane_count F lane time L (b - 2 * rho) hL hgap
  · intro w hw
    have h := at_bounds M (paths (lane w)).2 (hat w hw)
    exact ⟨h.1, le_trans h.2.1 (hpath (lane w))⟩
  · intro u hu v hv hne hlane
    have hvat := hat v hv
    rw [← hlane] at hvat
    have hmid := at_near_pair M (paths (lane u)).2 (hat u hu) hvat
    have hjoin := M.near_trans (M.near_trans (hnear u hu) hmid) (M.near_symm (hnear v hv))
    have hb := hsep u hu v hv hne _ hjoin
    linarith

theorem survivor_packing
    (S : Set ℕ) (hzero : 0 ∈ S)
    (hconn : ∀ i ∈ S, Within M.link S i 0)
    (s : X → ℝ) (hlip : ∀ u v, s u - s v ≤ dist u v)
    (narrow : N → Prop) (a L T sep j err b : ℝ)
    (hL : 0 ≤ L) (hj : 0 ≤ j) (herr : 0 ≤ err)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (hgeometry : 2 * L + a + T < sep)
    (hgap : 0 < b - 2 * (j + err + 2 * a))
    (F : Finset N) (z : N)
    (data : ∀ w ∈ F, Survivor M S s narrow L T sep j err z w)
    (hsep : ∀ u ∈ F, ∀ v ∈ F, u ≠ v → ∀ r, M.Near u v r → b ≤ r) :
    (F.card : ℝ) ≤ 2 + 2 * L / (b - 2 * (j + err + 2 * a)) := by
  classical
  by_cases hne : F.Nonempty
  · obtain ⟨left, right, hl, hr, hcover⟩ :=
      two_extreme_paths M S hzero hconn s hlip narrow a L T sep j err hj herr
        hcolumn hgeometry F hne z data
    let paths : Bool → Σ y, Trace M.step z y :=
      fun side => if side then ⟨right, (data right hr).center⟩
        else ⟨left, (data left hl).center⟩
    have hex : ∀ w, ∃ side v t,
        w ∈ F → (paths side).2.At M.cost v t ∧
          M.Near w v (j + err + 2 * a) := by
      intro w
      by_cases hw : w ∈ F
      · rcases hcover w hw with ⟨v, t, ht, hd⟩ | ⟨v, t, ht, hd⟩
        · exact ⟨false, v, t, fun _ => ⟨ht, hd⟩⟩
        · exact ⟨true, v, t, fun _ => ⟨ht, hd⟩⟩
      · exact ⟨false, z, 0, fun h => False.elim (hw h)⟩
    choose lane location time hc using hex
    apply count_near_two_traces M F z paths lane location time L b
      (j + err + 2 * a) hL hgap
    · intro side
      cases side <;> simp only [paths] <;>
        first | exact (data left hl).center_bound | exact (data right hr).center_bound
    · exact fun w hw => (hc w hw).1
    · exact fun w hw => (hc w hw).2
    · exact hsep
  · have hF : F = ∅ := Finset.not_nonempty_iff_eq_empty.mp hne
    have hdiv : 0 ≤ 2 * L / (b - 2 * (j + err + 2 * a)) :=
      div_nonneg (mul_nonneg (by norm_num) hL) hgap.le
    simp only [hF, Finset.card_empty, Nat.cast_zero]
    linarith

theorem Within.end_mem {E : ℕ → ℕ → Prop} {S : Set ℕ} {a b : ℕ}
    (p : Within E S a b) : b ∈ S := by
  induction p with
  | nil h => exact h
  | cons _ _ _ ih => exact ih

theorem Within.append {E : ℕ → ℕ → Prop} {S : Set ℕ} {a b c : ℕ}
    (p : Within E S a b) (q : Within E S b c) : Within E S a c := by
  induction p with
  | nil _ => exact q
  | cons hu he _ ih => exact .cons hu he (ih q)

theorem Within.reverse {E : ℕ → ℕ → Prop} {S : Set ℕ}
    (hs : ∀ ⦃u v⦄, E u v → E v u)
    {a b : ℕ} (p : Within E S a b) : Within E S b a := by
  induction p with
  | nil h => exact .nil h
  | cons hu he tail ih =>
      exact ih.append (.cons tail.start_mem (hs he) (.nil hu))

theorem Within.map_edges {E E' : ℕ → ℕ → Prop} {S : Set ℕ}
    (he : ∀ u v, E u v → E' u v)
    {a b : ℕ} (p : Within E S a b) : Within E' S a b := by
  induction p with
  | nil h => exact .nil h
  | cons hu h tail ih => exact .cons hu (he _ _ h) ih

theorem trace_projects_within (S : Set ℕ) {x y : N}
    (p : Trace M.step x y)
    (hmem : ∀ u t, p.At M.cost u t → M.col u ∈ S) :
    Within M.link S (M.col x) (M.col y) := by
  induction p with
  | nil u => exact .nil (hmem u 0 (by simp [Trace.At]))
  | @cons u v w he tail ih =>
      have htail : Within M.link S (M.col v) (M.col w) := by
        apply ih
        intro q t ht
        exact hmem q (M.cost u v + t) (Or.inr ⟨t, ht, rfl⟩)
      rcases M.step_spec u v he with h | h
      · simpa only [h] using htail
      · exact .cons (hmem u 0 (Or.inl ⟨rfl, rfl⟩))
          (M.switch_spec u v h).1 htail

structure Profile (a : ℝ) where
  field : X → ℝ
  low : ℝ → Set ℕ
  lipschitz : ∀ u v, field u - field v ≤ dist u v
  connected : ∀ t i, i ∈ low t → Within M.link (low t) i 0
  upper : ∀ t n, field (M.point n) + a ≤ t → M.col n ∈ low t
  lower : ∀ t n, M.col n ∈ low t → field (M.point n) ≤ t + a

variable {O Y : Type*} [PseudoMetricSpace Y]

def distanceProfile (Old : Model O Y) (source : O)
    (source_col : Old.col source = 0)
    (height : Y → ℝ) (H a : ℝ)
    (height_lip : ∀ u v, |height u - height v| ≤ dist u v)
    (vertical : ∀ u v, Old.col u = Old.col v →
      dist (Old.point u) (Old.point v) ≤ |height (Old.point u) - height (Old.point v)|)
    (ref : O → O) (ref_col : ∀ u, Old.col (ref u) = Old.col u)
    (ref_height : ∀ u, height (Old.point (ref u)) = H)
    (geodesic : ∀ v, height (Old.point v) = H →
      ∃ p : Trace Old.step source v,
        p.length Old.cost = dist (Old.point source) (Old.point v))
    (link_inclusion : ∀ i k, Old.link i k → M.link i k)
    (oldMap : X → Y) (oldMap_lip : ∀ u v, dist (oldMap u) (oldMap v) ≤ dist u v)
    (represent : N → O)
    (represent_col : ∀ n, Old.col (represent n) = M.col n)
    (represent_point : ∀ n, Old.point (represent n) = oldMap (M.point n))
    (band : ∀ n, |height (oldMap (M.point n)) - H| ≤ a) : Profile M a where
  field := fun x => dist (Old.point source) (oldMap x)
  low := fun t => {i | ∃ v, Old.col v = i ∧ height (Old.point v) = H ∧
    dist (Old.point source) (Old.point v) ≤ t}
  lipschitz := by
    intro u v
    have ht := dist_triangle (Old.point source) (oldMap v) (oldMap u)
    have hm := oldMap_lip v u
    rw [dist_comm v u] at hm
    linarith
  connected := by
    intro t i hi
    rcases hi with ⟨v, hcol, hvH, hvt⟩
    obtain ⟨p, hp⟩ := geodesic v hvH
    have hvisit : ∀ u r, p.At Old.cost u r →
        ∃ v, Old.col v = Old.col u ∧ height (Old.point v) = H ∧
          dist (Old.point source) (Old.point v) ≤ t := by
      intro u r hu
      have hb := at_bounds Old p hu
      have hh := height_lip (Old.point u) (Old.point v)
      rw [hvH] at hh
      have hvertical := vertical u (ref u) (ref_col u).symm
      rw [ref_height u] at hvertical
      have ht := dist_triangle (Old.point source) (Old.point u) (Old.point (ref u))
      refine ⟨ref u, ref_col u, ref_height u, ?_⟩
      linarith [hb.2.2.1, hb.2.2.2]
    have hwithin := trace_projects_within Old
      {i | ∃ v, Old.col v = i ∧ height (Old.point v) = H ∧
        dist (Old.point source) (Old.point v) ≤ t} p hvisit
    have hrev := hwithin.reverse Old.symmetric
    have hmap := hrev.map_edges link_inclusion
    simpa only [source_col, hcol] using hmap
  upper := by
    intro t n hn
    have hv := vertical (represent n) (ref (represent n)) (ref_col _).symm
    rw [ref_height, represent_point] at hv
    have ht := dist_triangle (Old.point source) (Old.point (represent n))
      (Old.point (ref (represent n)))
    rw [represent_point] at ht
    exact ⟨ref (represent n), by rw [ref_col, represent_col],
      ref_height _, by linarith [band n]⟩
  lower := by
    intro t n hn
    rcases hn with ⟨v, hcol, hvH, hvt⟩
    have hc : Old.col (represent n) = Old.col v := by rw [represent_col, hcol]
    have hv := vertical (represent n) v hc
    rw [represent_point, hvH] at hv
    have ht := dist_triangle (Old.point source) (Old.point v) (Old.point (represent n))
    rw [represent_point, dist_comm (Old.point v)] at ht
    linarith [band n]

structure RawSurvivor (s : X → ℝ) (narrow : N → Prop)
    (L T sep dmin E j err : ℝ) (z w : N) where
  partner : N
  dend : N
  pend : N
  center : Trace M.step z w
  descent : Trace M.step w dend
  partner_descent : Trace M.step partner pend
  center_bound : center.length M.cost ≤ L
  center_narrow : ∀ v t, center.At M.cost v t → narrow v
  separated : sep ≤ dist (M.point w) (M.point partner)
  descent_min : dmin ≤ descent.length M.cost
  partner_min : dmin ≤ partner_descent.length M.cost
  descent_max : descent.length M.cost ≤ T
  partner_max : partner_descent.length M.cost ≤ T
  field_difference : s (M.point partner) ≤ s (M.point w) + E
  drop : s (M.point dend) ≤ s (M.point w) - descent.length M.cost + err
  partner_drop : s (M.point pend) ≤
    s (M.point partner) - partner_descent.length M.cost + err
  barrier : ∀ u v, M.switch u v → narrow u → 0 < M.col u →
    M.col u < M.col w → M.col w < M.col v →
    (M.col partner < M.col u ∨ M.col v < M.col partner) →
    dist (M.point w) (M.point u) ≤ 2 * L →
    s (M.point w) - j ≤ s (M.point u)

def survivorsFromProfile (a : ℝ) (P : Profile M a)
    (narrow : N → Prop) (L T sep dmin E j err : ℝ)
    (hE : 0 ≤ E) (herr : 0 ≤ err)
    (hsmall : 2 * L + E + err + a < dmin / 2)
    (F : Finset N) (z star : N) (hstar : star ∈ F)
    (data : ∀ w ∈ F, RawSurvivor M P.field narrow L T sep dmin E j err z w)
    (w : N) (hw : w ∈ F) :
    Survivor M (P.low (P.field (M.point star) - dmin / 2))
      P.field narrow L T sep j err z w := by
  let d := data w hw
  let ds := data star hstar
  have hwz := le_trans (dist_end_le_length M d.center) d.center_bound
  have hsz := le_trans (dist_end_le_length M ds.center) ds.center_bound
  have hws : dist (M.point w) (M.point star) ≤ 2 * L := by
    have ht := dist_triangle (M.point w) (M.point z) (M.point star)
    rw [dist_comm (M.point w) (M.point z)] at ht
    linarith
  have hfield : P.field (M.point w) ≤ P.field (M.point star) + 2 * L := by
    linarith [P.lipschitz (M.point w) (M.point star)]
  refine {
    partner := d.partner
    dend := d.dend
    pend := d.pend
    center := d.center
    descent := d.descent
    partner_descent := d.partner_descent
    center_bound := d.center_bound
    center_narrow := d.center_narrow
    separated := d.separated
    partner_bound := d.partner_max
    drop := d.drop
    barrier := d.barrier
    center_avoid := ?_
    descent_low := ?_
    partner_low := ?_
  }
  · intro v t hv hlow
    have hb := at_bounds M d.center hv
    have hvs : dist (M.point star) (M.point v) ≤ 2 * L := by
      have ht := dist_triangle (M.point star) (M.point z) (M.point v)
      rw [dist_comm (M.point star) (M.point z)] at ht
      linarith [hb.2.2.1, hb.2.1, d.center_bound]
    have hfl := P.lipschitz (M.point star) (M.point v)
    have hfu := P.lower _ v hlow
    linarith
  · apply P.upper
    linarith [d.drop, d.descent_min]
  · apply P.upper
    linarith [d.partner_drop, d.partner_min, d.field_difference]

theorem profile_localization
    (a : ℝ) (P : Profile M a)
    (narrow : N → Prop) (L T sep dmin E j err : ℝ)
    (hE : 0 ≤ E) (hj : 0 ≤ j) (herr : 0 ≤ err)
    (hsmall : 2 * L + E + err + a < dmin / 2)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (hgeometry : 2 * L + a + T < sep)
    (F : Finset N) (z star : N) (hstar : star ∈ F)
    (data : ∀ w ∈ F, RawSurvivor M P.field narrow L T sep dmin E j err z w) :
    ∃ (left right : N) (hl : left ∈ F) (hr : right ∈ F),
      ∀ w ∈ F,
        (∃ v t, (data left hl).center.At M.cost v t ∧
          M.Near w v (j + err + 2 * a)) ∨
        (∃ v t, (data right hr).center.At M.cost v t ∧
          M.Near w v (j + err + 2 * a)) := by
  let S := P.low (P.field (M.point star) - dmin / 2)
  let ds := survivorsFromProfile M a P narrow L T sep dmin E j err hE herr
    hsmall F z star hstar data
  have hconn : ∀ i ∈ S, Within M.link S i 0 := P.connected _
  have hzero : 0 ∈ S := (hconn _ (ds star hstar).descent_low).end_mem
  exact two_extreme_paths M S hzero hconn P.field P.lipschitz narrow a L T sep j err
    hj herr hcolumn hgeometry F ⟨star, hstar⟩ z ds

theorem profile_localization_and_packing
    (a : ℝ) (P : Profile M a)
    (narrow : N → Prop) (L T sep dmin E j err b : ℝ)
    (hL : 0 ≤ L) (hE : 0 ≤ E) (hj : 0 ≤ j) (herr : 0 ≤ err)
    (hsmall : 2 * L + E + err + a < dmin / 2)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (hgeometry : 2 * L + a + T < sep)
    (hgap : 0 < b - 2 * (j + err + 2 * a))
    (F : Finset N) (z star : N) (hstar : star ∈ F)
    (data : ∀ w ∈ F, RawSurvivor M P.field narrow L T sep dmin E j err z w)
    (hsep : ∀ u ∈ F, ∀ v ∈ F, u ≠ v → ∀ r, M.Near u v r → b ≤ r) :
    (∃ (left right : N) (hl : left ∈ F) (hr : right ∈ F),
      ∀ w ∈ F,
        (∃ v t, (data left hl).center.At M.cost v t ∧
          M.Near w v (j + err + 2 * a)) ∨
        (∃ v t, (data right hr).center.At M.cost v t ∧
          M.Near w v (j + err + 2 * a))) ∧
    (F.card : ℝ) ≤ 2 + 2 * L / (b - 2 * (j + err + 2 * a)) := by
  let S := P.low (P.field (M.point star) - dmin / 2)
  let ds := survivorsFromProfile M a P narrow L T sep dmin E j err hE herr
    hsmall F z star hstar data
  have hconn : ∀ i ∈ S, Within M.link S i 0 := P.connected _
  have hzero : 0 ∈ S := (hconn _ (ds star hstar).descent_low).end_mem
  constructor
  · exact profile_localization M a P narrow L T sep dmin E j err
      hE hj herr hsmall hcolumn hgeometry F z star hstar data
  · exact survivor_packing M S hzero hconn P.field P.lipschitz narrow a L T sep j err b
      hL hj herr hcolumn hgeometry hgap F z ds hsep

theorem common_chart_from_eligibility {A Id : Type*} [PseudoMetricSpace A]
    (F : Finset N) (point : N → A) (chart : A → Id) (z : A) (L : ℝ)
    (hL : L ≤ 5)
    (hball : ∀ w ∈ F, dist z (point w) ≤ L)
    (heligible : ∀ w ∈ F, ∀ v, dist (point w) v ≤ 5 →
      chart v = chart (point w)) :
    ∀ w ∈ F, chart (point w) = chart z := by
  intro w hw
  symm
  apply heligible w hw
  rw [dist_comm]
  exact le_trans (hball w hw) hL

theorem skipping_is_nonneighbor {n a i b : ℕ}
    (ha : 0 < a) (hai : a < i) (hib : i < b) :
    a + 1 < b ∧ ¬ (a = 0 ∧ b + 1 = n) := by omega

theorem barrier_from_ambient_exclusion {A : Type*} [PseudoMetricSpace A]
    (ambient : N → A)
    (contract : ∀ u v, dist (ambient u) (ambient v) ≤ dist (M.point u) (M.point v))
    (s : X → ℝ) (narrow : N → Prop) (w partner : N) (L j : ℝ)
    (hL : 2 * L ≤ 1)
    (hexclude : ∀ u v, M.switch u v → narrow u → 0 < M.col u →
      M.col u < M.col w → M.col w < M.col v →
      (M.col partner < M.col u ∨ M.col v < M.col partner) →
      dist (ambient w) (ambient u) ≤ 1 →
      ¬ (s (M.point u) < s (M.point w) - j)) :
    ∀ u v, M.switch u v → narrow u → 0 < M.col u →
      M.col u < M.col w → M.col w < M.col v →
      (M.col partner < M.col u ∨ M.col v < M.col partner) →
      dist (M.point w) (M.point u) ≤ 2 * L →
      s (M.point w) - j ≤ s (M.point u) := by
  intro u v huv hu ha haw hwb hp hn
  apply le_of_not_gt
  exact hexclude u v huv hu ha haw hwb hp
    (le_trans (contract w u) (le_trans hn hL))

noncomputable def R89 : ℝ := 1 / 10 ^ 8
noncomputable def g89 : ℝ := 1 / 10 ^ 14
noncomputable def j89 : ℝ := 1 / 10 ^ 20
noncomputable def epsilon89 : ℝ := 1 / 10 ^ 24
noncomputable def E89 : ℝ := 1 / 10 ^ 27
noncomputable def amax89 : ℝ := 1 / 10 ^ 33
noncomputable def b89 : ℝ := g89 / 100

theorem manuscript_parameter_margins (a : ℝ) (_ha : 0 ≤ a) (hamax : a ≤ amax89) :
    2 * (4 * R89) + E89 + epsilon89 + a < (1 / 10 ^ 5 : ℝ) / 2 ∧
    2 * (4 * R89) + a + (2 / 100 : ℝ) < 1 ∧
    2 * (4 * R89) ≤ 1 ∧
    0 < b89 - 2 * (j89 + epsilon89 + 2 * a) ∧
    b89 / 2 ≤ b89 - 2 * (j89 + epsilon89 + 2 * a) := by
  norm_num [R89, E89, epsilon89, amax89, b89, g89, j89] at *
  and_intros <;> linarith

theorem manuscript_integer_bound {n : ℕ} (a : ℝ)
    (ha : 0 ≤ a) (hamax : a ≤ amax89)
    (hn : (n : ℝ) ≤
      2 + 8 * R89 / (b89 - 2 * (j89 + epsilon89 + 2 * a))) :
    n ≤ 2 + ⌈1600 * R89 / g89⌉₊ := by
  have hm := manuscript_parameter_margins a ha hamax
  have hdelta := hm.2.2.2.1
  have hfrac : 8 * R89 / (b89 - 2 * (j89 + epsilon89 + 2 * a)) ≤
      1600 * R89 / g89 := by
    apply (div_le_iff₀ hdelta).mpr
    norm_num [R89, b89, g89, j89, epsilon89, amax89] at *
    linarith
  have hreal : (n : ℝ) ≤ (1600000002 : ℝ) := by
    norm_num [R89, g89] at hn hfrac
    linarith
  have hnat : n ≤ 1600000002 := by exact_mod_cast hreal
  norm_num [R89, g89]
  exact hnat

theorem sharper_integer_bound {n : ℕ} (a : ℝ)
    (ha : 0 ≤ a) (hamax : a ≤ amax89)
    (hn : (n : ℝ) ≤
      2 + 8 * R89 / (b89 - 2 * (j89 + epsilon89 + 2 * a))) :
    n ≤ 800160050 := by
  have hm := manuscript_parameter_margins a ha hamax
  have hdelta := hm.2.2.2.1
  have hfrac : 8 * R89 / (b89 - 2 * (j89 + epsilon89 + 2 * a)) <
      (800160049 : ℝ) := by
    apply (div_lt_iff₀ hdelta).mpr
    norm_num [R89, b89, g89, j89, epsilon89, amax89] at *
    linarith
  have hreal : (n : ℝ) < (800160051 : ℝ) := by linarith
  have hnat : n < 800160051 := by exact_mod_cast hreal
  omega

theorem manuscript_core_certified
    (a : ℝ) (ha : 0 ≤ a) (hamax : a ≤ amax89)
    (P : Profile M a) (narrow : N → Prop)
    (hcolumn : ∀ u v, M.col u = M.col v → M.Near u v a)
    (F : Finset N) (z star : N) (hstar : star ∈ F)
    (data : ∀ w ∈ F, RawSurvivor M P.field narrow
      (4 * R89) (2 / 100) 1 (1 / 10 ^ 5) E89 j89 epsilon89 z w)
    (hsep : ∀ u ∈ F, ∀ v ∈ F, u ≠ v → ∀ r, M.Near u v r → b89 ≤ r) :
    (∃ (left right : N) (hl : left ∈ F) (hr : right ∈ F),
      ∀ w ∈ F,
        (∃ v t, (data left hl).center.At M.cost v t ∧
          M.Near w v (j89 + epsilon89 + 2 * a)) ∨
        (∃ v t, (data right hr).center.At M.cost v t ∧
          M.Near w v (j89 + epsilon89 + 2 * a))) ∧
    F.card ≤ 800160050 ∧ F.card ≤ 2 + ⌈1600 * R89 / g89⌉₊ := by
  have hm := manuscript_parameter_margins a ha hamax
  have h := profile_localization_and_packing M a P narrow
    (4 * R89) (2 / 100) 1 (1 / 10 ^ 5) E89 j89 epsilon89 b89
    (by norm_num [R89]) (by norm_num [E89]) (by norm_num [j89])
    (by norm_num [epsilon89]) hm.1 hcolumn hm.2.1 hm.2.2.2.1
    F z star hstar data hsep
  have hc : (F.card : ℝ) ≤
      2 + 8 * R89 / (b89 - 2 * (j89 + epsilon89 + 2 * a)) := by
    convert h.2 using 1 <;> ring
  exact ⟨h.1, sharper_integer_bound a ha hamax hc, manuscript_integer_bound a ha hamax hc⟩

#print axioms distanceProfile
#print axioms profile_localization_and_packing
#print axioms manuscript_integer_bound
#print axioms sharper_integer_bound
#print axioms manuscript_core_certified

end PackingAudit
