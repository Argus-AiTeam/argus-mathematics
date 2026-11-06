import Base
set_option autoImplicit false
set_option maxHeartbeats 2000000
set_option linter.unusedSectionVars false

namespace LiteralHierarchy

open TemporalBoundary LiteralConstruction SameFrameHistory LiteralProtocol
open scoped Classical

variable {Job : Type*} [Fintype Job] [DecidableEq Job]

theorem switch_final_sentinel {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) (A : TemporalBoundary.Boundary Job) :
    switchLow σ a b A (Fintype.card Job) = switchCenterLow σ a b A := by
  ext x
  simp only [switchLow, switchCenterLow, Set.mem_setOf_eq, Set.mem_sdiff]
  exact ⟨fun h => ⟨h.1, h.2.1⟩, fun h => ⟨h.1, h.2, P.rank_bound x⟩⟩

theorem switch_exhausted_sentinel {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) (A : TemporalBoundary.Boundary Job) (r : ℕ)
    (hex : ¬ ∃ x ∈ Inside σ a b, x ∉ D P A ∧ r < P.rank x) :
    switchLow σ a b A r = switchLow σ a b A (Fintype.card Job) := by
  rw [switch_final_sentinel]
  ext x
  change (x ∈ Inside σ a b ∧ x ∉ D P A ∧ P.rank x ≤ r) ↔
    (x ∈ Inside σ a b ∧ x ∉ D P A)
  exact ⟨fun h => ⟨h.1, h.2.1⟩,
    fun h => ⟨h.1, h.2, by by_contra hn; exact hex ⟨x, h.1, h.2, lt_of_not_ge hn⟩⟩⟩

theorem switch_exhausted_transport {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a b v s : ℤ}
    {A B : TemporalBoundary.Boundary Job} {r : ℕ}
    (hex : ¬ ∃ x ∈ Inside σ a b, x ∉ D P A ∧ r < P.rank x)
    (sep : Separator σ (Inside σ a v) (switchLow σ a b A r) B s)
    (walk : ExceptionWalk σ π a v (switchLow σ a b A r) A B s) :
    Separator σ (Inside σ a v) (switchLow σ a b A (Fintype.card Job)) B s ∧
      ExceptionWalk σ π a v (switchLow σ a b A (Fintype.card Job)) A B s := by
  have he := switch_exhausted_sentinel σ a b A r hex
  exact ⟨he ▸ sep, he ▸ walk⟩

structure SideSystem {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a v : ℤ)
    (A : TemporalBoundary.Boundary Job) (parent centerLow : Set Job)
    (Label : Type) where
  low : Label → Set Job
  valid : Label → Prop
  finalLabel : Label
  final_valid : valid finalLabel
  final_agreement : ∀ x ∈ parent, x ∈ low finalLabel ↔ x ∈ centerLow
  low_subset : ∀ q, valid q → ∀ x ∈ parent, x ∈ low q → x ∈ centerLow
  side_subset : Inside σ a v ⊆ parent
  low_prefix : ∀ q, valid q → LowPrefix σ π a v (low q)
  less : Job → Job → Prop
  next : ∀ q, valid q →
    (∃ x ∈ parent, x ∈ centerLow ∧ x ∉ low q) →
    ∃ p q', p ∈ parent ∧ p ∈ centerLow ∧ p ∉ low q ∧ valid q' ∧
      (∀ x ∈ parent, x ∈ low q' ↔ x ∈ low q ∨ x = p) ∧
      (∀ x ∈ parent, x ∈ centerLow → x ∉ low q → x ≠ p → less p x)

namespace SideSystem

variable {P : Precedence Job} {T : ℕ} {σ : Schedule P T} {π : Priority P}
  {a v : ℤ} {A : TemporalBoundary.Boundary Job} {parent centerLow : Set Job}
  {Label : Type}

noncomputable def remaining
    (S : SideSystem σ π a v A parent centerLow Label) (q : Label) : Finset Job :=
  Finset.univ.filter (fun x => x ∈ parent ∧ x ∈ centerLow ∧ x ∉ S.low q)

@[simp] theorem mem_remaining (S : SideSystem σ π a v A parent centerLow Label)
    (q : Label) (x : Job) :
    x ∈ S.remaining q ↔ x ∈ parent ∧ x ∈ centerLow ∧ x ∉ S.low q := by
  classical
  simp [remaining]

theorem remaining_erase (S : SideSystem σ π a v A parent centerLow Label)
    {q q' : Label} {p : Job}
    (grow : ∀ x ∈ parent, x ∈ S.low q' ↔ x ∈ S.low q ∨ x = p) :
    S.remaining q' = (S.remaining q).erase p := by
  classical
  ext x
  simp only [mem_remaining, Finset.mem_erase]
  by_cases hx : x ∈ parent
  · rw [grow x hx]
    tauto
  · tauto

theorem exhausted_agreement (S : SideSystem σ π a v A parent centerLow Label)
    {q : Label} (hq : S.valid q) (he : S.remaining q = ∅) :
    ∀ x ∈ parent, x ∈ S.low q ↔ x ∈ S.low S.finalLabel := by
  intro x hx
  rw [S.final_agreement x hx]
  refine ⟨S.low_subset q hq x hx, ?_⟩
  intro hxC
  by_contra hn
  have hm := (S.mem_remaining q x).mpr ⟨hx, hxC, hn⟩
  rw [he] at hm
  exact Finset.notMem_empty x hm

structure State (S : SideSystem σ π a v A parent centerLow Label) where
  label : Label
  boundary : TemporalBoundary.Boundary Job
  pos : ℤ
  attained : S.valid label
  lower : a ≤ pos
  upper : pos < v
  separator : Separator σ (Inside σ a v) (S.low label) boundary pos
  walk : ExceptionWalk σ π a v (S.low label) A boundary pos

structure Event (S : SideSystem σ π a v A parent centerLow Label)
    (st : S.State) where
  promoted : Job
  pending : promoted ∈ S.remaining st.label
  nextState : S.State
  grow : ∀ x ∈ parent,
    x ∈ S.low nextState.label ↔ x ∈ S.low st.label ∨ x = promoted
  first : ∀ x ∈ S.remaining st.label, x ≠ promoted → S.less promoted x
  forward : st.pos ≤ nextState.pos
  shared : Separator σ (Inside σ a v) (S.low st.label)
    nextState.boundary nextState.pos

inductive Run (S : SideSystem σ π a v A parent centerLow Label) : S.State → Type _
  | finish (st : S.State) (exhausted : S.remaining st.label = ∅) : Run S st
  | advance {st : S.State} (event : S.Event st)
      (tail : Run S event.nextState) : Run S st

theorem event_exists (S : SideSystem σ π a v A parent centerLow Label)
    (hn : Normalized σ π a v) (st : S.State)
    (hne : (S.remaining st.label).Nonempty) : Nonempty (S.Event st) := by
  obtain ⟨x, hx⟩ := hne
  obtain ⟨p, q', hpU, hpC, hpL, hq', hgrow, hfirst⟩ :=
    S.next st.label st.attained ⟨x, (S.mem_remaining _ _).mp hx⟩
  obtain ⟨B, t, hst, htv, hB, hold, hnew, hwalk⟩ :=
    shared_cutoff_walk p hn (S.low_prefix _ st.attained) (S.low_prefix _ hq')
      (fun x hx => hgrow x (S.side_subset hx))
      st.lower st.upper (walk_placed st.walk) st.separator st.walk
  exact ⟨{
    promoted := p
    pending := (S.mem_remaining _ _).mpr ⟨hpU, hpC, hpL⟩
    nextState := {
      label := q', boundary := B, pos := t, attained := hq'
      lower := st.lower.trans hst, upper := htv
      separator := hnew, walk := hwalk }
    grow := hgrow
    first := fun y hy hne => by
      have hy' := (S.mem_remaining _ _).mp hy
      exact hfirst y hy'.1 hy'.2.1 hy'.2.2 hne
    forward := hst
    shared := hold
  }⟩

theorem run_exists (S : SideSystem σ π a v A parent centerLow Label)
    (hn : Normalized σ π a v) (st : S.State) : Nonempty (S.Run st) := by
  classical
  have aux : ∀ n : ℕ, ∀ st : S.State,
      (S.remaining st.label).card = n → Nonempty (S.Run st) := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro state hncard
        by_cases he : S.remaining state.label = ∅
        · exact ⟨.finish state he⟩
        · obtain ⟨ev⟩ := S.event_exists hn state (Finset.nonempty_iff_ne_empty.mpr he)
          have herase := S.remaining_erase ev.grow
          have hlt : (S.remaining ev.nextState.label).card <
              (S.remaining state.label).card := by
            rw [herase]
            exact Finset.card_erase_lt_of_mem ev.pending
          obtain ⟨tail⟩ := ih _ (by omega) ev.nextState rfl
          exact ⟨.advance ev tail⟩
  exact aux _ st rfl

def Run.jobs {S : SideSystem σ π a v A parent centerLow Label} {st : S.State} :
    S.Run st → List Job
  | .finish _ _ => []
  | .advance ev tail => ev.promoted :: tail.jobs

theorem Run.all_promotions {S : SideSystem σ π a v A parent centerLow Label}
    {st : S.State} (run : S.Run st) :
    run.jobs.Nodup ∧ ∀ x, x ∈ run.jobs ↔ x ∈ S.remaining st.label := by
  classical
  induction run with
  | finish state he =>
      simp [Run.jobs, he]
  | @advance state ev tail ih =>
      have herase := S.remaining_erase ev.grow
      constructor
      · rw [Run.jobs, List.nodup_cons]
        refine ⟨?_, ih.1⟩
        rw [ih.2, herase]
        exact Finset.notMem_erase _ _
      · intro x
        rw [Run.jobs, List.mem_cons, ih.2, herase, Finset.mem_erase]
        by_cases h : x = ev.promoted
        · subst x
          simp [ev.pending]
        · simp [h]

theorem Run.promotions_in_order {S : SideSystem σ π a v A parent centerLow Label}
    {st : S.State} (run : S.Run st) : run.jobs.Pairwise S.less := by
  classical
  induction run with
  | finish state he => simp [Run.jobs]
  | @advance state ev tail ih =>
      rw [Run.jobs, List.pairwise_cons]
      refine ⟨?_, ih⟩
      intro x hx
      have hm := (tail.all_promotions.2 x).mp hx
      rw [S.remaining_erase ev.grow, Finset.mem_erase] at hm
      exact ev.first x hm.2 hm.1

structure Segment (S : SideSystem σ π a v A parent centerLow Label) where
  label : Label
  attained : S.valid label
  left : TemporalBoundary.Boundary Job
  right : Finset Job
  c : ℤ
  d : ℤ
  ordered : c < d
  before_center : d ≤ v
  right_placed : Placed σ (.actual right) d
  walk : ExceptionWalk σ π a v (S.low label) A left c
  left_separator : Separator σ (Inside σ a v) (S.low label) left c
  right_separator : Separator σ (Inside σ a v) (S.low label) (.actual right) d
  final_label : d = v → label = S.finalLabel

theorem walk_after_actual {L : Set Job} {B : TemporalBoundary.Boundary Job} {s : ℤ}
    (walk : ExceptionWalk σ π a v L A B s) (hs : a < s) :
    ∃ F, B = .actual F := by
  cases walk with
  | start _ => omega
  | @advance B s t target past L hL hLS step => exact ⟨target, rfl⟩

def terminalSegment (S : SideSystem σ π a v A parent centerLow Label)
    (F : Finset Job) (hF : Placed σ (.actual F) v)
    (hcenter : Separator σ parent centerLow (.actual F) v)
    (st : S.State) (he : S.remaining st.label = ∅) : S.Segment where
  label := S.finalLabel
  attained := S.final_valid
  left := st.boundary
  right := F
  c := st.pos
  d := v
  ordered := st.upper
  before_center := le_rfl
  right_placed := hF
  walk := walk_mono st.walk (fun x hx hxL =>
    (S.exhausted_agreement st.attained he x (S.side_subset hx)).mp hxL)
  left_separator := separator_congr_low
    (fun x hx => S.exhausted_agreement st.attained he x (S.side_subset hx)) st.separator
  right_separator := {
    earlier_high := fun x hx hxL hxt =>
      hcenter.earlier_high x (S.side_subset hx)
        (fun hxC => hxL ((S.final_agreement x (S.side_subset hx)).mpr hxC)) hxt
    later_low := fun x hx hxL hxt =>
      hcenter.later_low x (S.side_subset hx)
        ((S.final_agreement x (S.side_subset hx)).mp hxL) hxt }
  final_label := fun _ => rfl

noncomputable def strictSegment
    {S : SideSystem σ π a v A parent centerLow Label}
    {st : S.State} (ev : S.Event st) (hs : st.pos < ev.nextState.pos) : S.Segment := by
  have hex := walk_after_actual ev.nextState.walk (st.lower.trans_lt hs)
  let F := Classical.choose hex
  have hB := Classical.choose_spec hex
  exact {
    label := st.label, attained := st.attained
    left := st.boundary, right := F, c := st.pos, d := ev.nextState.pos
    ordered := hs, before_center := ev.nextState.upper.le
    right_placed := hB ▸ walk_placed ev.nextState.walk
    walk := st.walk, left_separator := st.separator
    right_separator := hB ▸ ev.shared
    final_label := fun h => False.elim (ne_of_lt ev.nextState.upper h) }

noncomputable def Run.segments
    {S : SideSystem σ π a v A parent centerLow Label}
    (F : Finset Job) (hF : Placed σ (.actual F) v)
    (hcenter : Separator σ parent centerLow (.actual F) v) :
    {st : S.State} → S.Run st → List S.Segment
  | _, .finish st he => [S.terminalSegment F hF hcenter st he]
  | st, .advance ev tail =>
      if hs : st.pos < ev.nextState.pos then
        strictSegment ev hs :: tail.segments F hF hcenter
      else tail.segments F hF hcenter

def Run.positions {S : SideSystem σ π a v A parent centerLow Label} {st : S.State} :
    S.Run st → List ℤ
  | .finish state _ => [state.pos, v]
  | .advance _ tail => st.pos :: tail.positions

theorem Run.every_position_collected
    {S : SideSystem σ π a v A parent centerLow Label}
    (F : Finset Job) (hF : Placed σ (.actual F) v)
    (hcenter : Separator σ parent centerLow (.actual F) v)
    {st : S.State} (run : S.Run st) :
    ∀ t ∈ run.positions, t = st.pos ∨
      ∃ e ∈ run.segments F hF hcenter, e.d = t := by
  induction run with
  | finish state he =>
      intro t ht
      simp only [Run.positions, List.mem_cons, List.mem_nil_iff, or_false] at ht
      rcases ht with rfl | rfl
      · exact Or.inl rfl
      · exact Or.inr ⟨S.terminalSegment F hF hcenter state he,
          by simp only [Run.segments, List.mem_singleton], rfl⟩
  | @advance state ev tail ih =>
      intro t ht
      simp only [Run.positions, List.mem_cons] at ht
      rcases ht with rfl | ht
      · exact Or.inl rfl
      · have hit := ih t ht
        by_cases hs : state.pos < ev.nextState.pos
        · rcases hit with heq | ⟨e, he, hd⟩
          · exact Or.inr ⟨strictSegment ev hs,
              by simp only [Run.segments, dif_pos hs, List.mem_cons, true_or], heq.symm⟩
          · exact Or.inr ⟨e, by
              simp only [Run.segments, dif_pos hs, List.mem_cons]
              exact Or.inr he, hd⟩
        · have hpos : ev.nextState.pos = state.pos :=
            le_antisymm (le_of_not_gt hs) ev.forward
          rcases hit with heq | ⟨e, he, hd⟩
          · exact Or.inl (heq.trans hpos)
          · exact Or.inr ⟨e, by
              simpa only [Run.segments, dif_neg hs] using he, hd⟩

inductive Tiles (S : SideSystem σ π a v A parent centerLow Label) :
    ℤ → List S.Segment → Prop
  | nil : Tiles S v []
  | cons {s : ℤ} {e : S.Segment} {es : List S.Segment}
      (left : e.c = s) (tail : Tiles S e.d es) : Tiles S s (e :: es)

theorem Run.tiles
    {S : SideSystem σ π a v A parent centerLow Label}
    (F : Finset Job) (hF : Placed σ (.actual F) v)
    (hcenter : Separator σ parent centerLow (.actual F) v)
    {st : S.State} (run : S.Run st) :
    S.Tiles st.pos (run.segments F hF hcenter) := by
  induction run with
  | finish state he => exact .cons rfl .nil
  | @advance state ev tail ih =>
      dsimp only [Run.segments]
      split_ifs with hs
      · exact .cons rfl ih
      · have he : state.pos = ev.nextState.pos := le_antisymm ev.forward (le_of_not_gt hs)
        rw [he]
        exact ih

theorem Tiles.bounds {S : SideSystem σ π a v A parent centerLow Label}
    {s : ℤ} {es : List S.Segment} (tiles : S.Tiles s es) :
    ∀ e ∈ es, s ≤ e.c ∧ e.d ≤ v := by
  induction tiles with
  | nil => simp
  | @cons s e es he ht ih =>
      intro f hf
      rcases List.mem_cons.mp hf with rfl | hf
      · exact ⟨he.ge, f.before_center⟩
      · exact ⟨he ▸ e.ordered.le.trans (ih f hf).1, f.before_center⟩

theorem Tiles.cover {S : SideSystem σ π a v A parent centerLow Label}
    {s t : ℤ} {es : List S.Segment} (tiles : S.Tiles s es)
    (hst : s < t) (htv : t ≤ v) :
    ∃ e ∈ es, e.c < t ∧ t ≤ e.d := by
  induction tiles with
  | nil => omega
  | @cons s e es he ht ih =>
      by_cases htd : t ≤ e.d
      · exact ⟨e, by simp, he.symm ▸ hst, htd⟩
      · obtain ⟨f, hf, hcf, hdf⟩ := ih (lt_of_not_ge htd)
        exact ⟨f, by simp [hf], hcf, hdf⟩

theorem Tiles.unique {S : SideSystem σ π a v A parent centerLow Label}
    {s t : ℤ} {es : List S.Segment} (tiles : S.Tiles s es)
    {e f : S.Segment} (he : e ∈ es) (hf : f ∈ es)
    (het : e.c < t ∧ t ≤ e.d) (hft : f.c < t ∧ t ≤ f.d) : e = f := by
  induction tiles generalizing e f with
  | nil => simp at he
  | @cons s g gs hg ht ih =>
      rcases List.mem_cons.mp he with heg | heTail
      · rcases List.mem_cons.mp hf with hfg | hfTail
        · exact heg.trans hfg.symm
        · have hb := (ht.bounds f hfTail).1
          have hlt := hft.1
          rw [heg] at het
          have hle := het.2
          omega
      · rcases List.mem_cons.mp hf with hfg | hfTail
        · have hb := (ht.bounds e heTail).1
          have hlt := het.1
          rw [hfg] at hft
          have hle := hft.2
          omega
        · exact ih heTail hfTail het hft

theorem Tiles.sorted_marks {S : SideSystem σ π a v A parent centerLow Label}
    {s : ℤ} {es : List S.Segment} (tiles : S.Tiles s es) :
    (es.map (fun e => e.d)).Pairwise (· < ·) := by
  induction tiles with
  | nil => simp
  | @cons s e es he ht ih =>
      rw [List.map_cons, List.pairwise_cons]
      refine ⟨?_, ih⟩
      intro t hm
      obtain ⟨f, hf, rfl⟩ := List.mem_map.mp hm
      exact (ht.bounds f hf).1.trans_lt f.ordered

theorem Segment.lower {S : SideSystem σ π a v A parent centerLow Label}
    (e : S.Segment) : a ≤ e.c := by
  rcases walk_start_or_interior e.walk with h | h
  · exact h.2.ge
  · exact h.1.le

theorem Segment.gap_subset {S : SideSystem σ π a v A parent centerLow Label}
    (e : S.Segment) : Inside σ e.c e.d ⊆ Inside σ a v :=
  fun _ hx => ⟨e.lower.trans_lt hx.1, hx.2.trans_le e.before_center⟩

end SideSystem

theorem same_low_iff {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    (cut : Cut) {x : Job} (hx : x ∈ Inside prep.schedule N.a N.b) :
    x ∈ sameLow N prep.schedule cut ↔
      x ∈ N.data.P N.right ∧ x ∉ selectedByKey N.data N.list cut := by
  have hI1 := (history.future_invariants prep.schedule prep.preparation).1
  change x ∈ priorityLow N.data (Inside prep.schedule N.a N.b) N.list cut N.right ↔ _
  rw [priority_low_eq_historical hI1 cut]
  simp [historicalLow, hx]

theorem same_final_agreement {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    {x : Job} (hx : x ∈ Inside prep.schedule N.a N.b) :
    x ∈ sameLow N prep.schedule none ↔ x ∈ sameCenterLow N prep.schedule := by
  rw [same_low_iff history prep none hx]
  simp [selectedByKey, sameCenterLow, hx, RawNode.data, frameData]

theorem same_next_promotion {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    (cut : Cut) (hcut : CutAttained N.data (Inside prep.schedule N.a N.b) N.list cut)
    (hex : ∃ x ∈ Inside prep.schedule N.a N.b,
      x ∈ sameCenterLow N prep.schedule ∧ x ∉ sameLow N prep.schedule cut) :
    ∃ p cut', p ∈ Inside prep.schedule N.a N.b ∧
      p ∈ sameCenterLow N prep.schedule ∧ p ∉ sameLow N prep.schedule cut ∧
      CutAttained N.data (Inside prep.schedule N.a N.b) N.list cut' ∧
      (∀ x ∈ Inside prep.schedule N.a N.b,
        x ∈ sameLow N prep.schedule cut' ↔ x ∈ sameLow N prep.schedule cut ∨ x = p) ∧
      (∀ x ∈ Inside prep.schedule N.a N.b, x ∈ sameCenterLow N prep.schedule →
        x ∉ sameLow N prep.schedule cut → x ≠ p → N.key p < N.key x) := by
  cases cut with
  | none =>
      obtain ⟨x, hx, hxC, hxL⟩ := hex
      exact False.elim (hxL ((same_final_agreement history prep hx).mpr hxC))
  | some dr =>
      obtain ⟨p, hpU, hpQ, hkey⟩ := hcut
      have hfst := congrArg Prod.fst hkey
      have hsnd := congrArg Prod.snd hkey
      change largestIndex N.data N.list p = dr.1 + 1 at hfst
      change N.frame.rank p = dr.2 at hsnd
      have hcanonical : (some dr : Cut) =
          some (largestIndex N.data N.list p - 1, N.frame.rank p) := by
        congr 1
        apply Prod.ext
        · omega
        · exact hsnd.symm
      obtain ⟨cut', hcut', hgrow⟩ := next_same_cut_exists history prep hpU hpQ
      have hI1 := (history.future_invariants prep.schedule prep.preparation).1
      have hpP : p ∈ N.data.P N.right := hI1.old_high ⟨hpU, hpQ⟩
      have hpC : p ∈ sameCenterLow N prep.schedule := ⟨hpU, hpP⟩
      have hpL : p ∉ sameLow N prep.schedule (some dr) := by
        rw [same_low_iff history prep _ hpU, hcanonical]
        exact fun h => h.2 ((selected_attained_key hpQ).mpr le_rfl)
      refine ⟨p, cut', hpU, hpC, hpL, hcut', ?_, ?_⟩
      · simpa only [hcanonical] using hgrow
      · intro x hx hxC hxL hxp
        have hsel : x ∈ selectedByKey N.data N.list (some dr) := by
          by_contra hn
          exact hxL ((same_low_iff history prep _ hx).mpr ⟨hxC.2, hn⟩)
        rw [hcanonical, selected_attained_key hpQ] at hsel
        exact lt_of_le_of_ne hsel
          (fun he => hxp (raw_key_injective N he.symm))

noncomputable def sameSystem {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N) :
    SideSystem prep.schedule prep.sameOrder N.a prep.v N.left
      (Inside prep.schedule N.a N.b) (sameCenterLow N prep.schedule) Cut where
  low := sameLow N prep.schedule
  valid := CutAttained N.data (Inside prep.schedule N.a N.b) N.list
  finalLabel := none
  final_valid := trivial
  final_agreement := fun _ hx => same_final_agreement history prep hx
  low_subset := fun cut _ _ hx hxL => ⟨hx, ((same_low_iff history prep cut hx).mp hxL).1⟩
  side_subset := fun _ hx => ⟨hx.1, hx.2.trans prep.center_interior.2⟩
  low_prefix := fun cut _ => same_low_prefix history prep cut
  less := fun x y => N.key x < N.key y
  next := same_next_promotion history prep

def SwitchAttained {T : ℕ} {N : RawNode Job T} (prep : NodePreparation N)
    (r : ℕ) : Prop :=
  r ≤ Fintype.card Job ∧
    (r = 0 ∨ r = Fintype.card Job ∨
      ∃ x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a),
        x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x = r)

noncomputable def switchedSystem {T : ℕ} {N : RawNode Job T}
    (prep : NodePreparation N) :
    SideSystem prep.schedule.reverse prep.switchedOrder
      (reverseTime T N.b) (reverseTime T prep.v) N.right.reverse
      (Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a))
      (switchCenterLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
        N.right.reverse) ℕ where
  low := switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) N.right.reverse
  valid := SwitchAttained prep
  finalLabel := Fintype.card Job
  final_valid := ⟨le_rfl, Or.inr (Or.inl rfl)⟩
  final_agreement := fun _ _ => by rw [switch_final_sentinel]
  low_subset := fun _ _ _ _ hx => ⟨hx.1, hx.2.1⟩
  side_subset := fun _ hx =>
    ⟨hx.1, hx.2.trans (by
      have := prep.center_interior.1
      dsimp [reverseTime]
      omega)⟩
  low_prefix := fun r _ => switched_low_prefix prep r
  less := fun x y => N.frame.reverse.rank x < N.frame.reverse.rank y
  next := by
    intro r _ hex
    have hex' : ∃ x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a),
        x ∉ D N.frame.reverse N.right.reverse ∧ r < N.frame.reverse.rank x := by
      obtain ⟨x, hx, hxC, hxL⟩ := hex
      exact ⟨x, hx, hxC.2, by
        by_contra hn
        exact hxL ⟨hx, hxC.2, le_of_not_gt hn⟩⟩
    obtain ⟨p, hpU, hpD, hrp, hpbound, hgrow⟩ := next_switched_rank_exists prep r hex'
    refine ⟨p, N.frame.reverse.rank p, hpU, ⟨hpU, hpD⟩, ?_,
      ⟨hpbound, Or.inr (Or.inr ⟨p, hpU, hpD, rfl⟩)⟩, hgrow, ?_⟩
    · exact fun h => (not_le_of_gt hrp) h.2.2
    · intro x hx hxC hxL hxp
      by_contra hn
      have hm : x ∈ switchLow prep.schedule.reverse (reverseTime T N.b)
          (reverseTime T N.a) N.right.reverse (N.frame.reverse.rank p) :=
        ⟨hx, hxC.2, le_of_not_gt hn⟩
      exact ((hgrow x hx).mp hm).elim hxL hxp

theorem sameInitial {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N) :
    ∃ st : (sameSystem history prep).State, st.pos = N.a ∧ st.boundary = N.left ∧
      ∀ x, x ∈ (sameSystem history prep).remaining st.label ↔
        x ∈ Inside prep.schedule N.a N.b ∧ x ∈ N.qualifiers := by
  obtain ⟨cut, hcut, hsel⟩ := initial_same_cut_exists prep.schedule
  have hI1 := (history.future_invariants prep.schedule prep.preparation).1
  have hplaced := placed_outside_reorders prep.preparation (Or.inl le_rfl) N.left_placed
  have hsep : Separator prep.schedule (Inside prep.schedule N.a prep.v)
      (sameLow N prep.schedule cut) N.left N.a := by
    constructor
    · intro x hx _ hxt
      have := hx.1
      omega
    · intro x hx hxL _
      have hxU : x ∈ Inside prep.schedule N.a N.b :=
        ⟨hx.1, hx.2.trans prep.center_interior.2⟩
      have hxnot : x ∉ N.qualifiers := fun h =>
        ((same_low_iff history prep cut hxU).mp hxL).2 ((hsel x hxU).mpr h)
      exact hI1.old_low ⟨hxU, hxnot⟩
  let st : (sameSystem history prep).State := {
    label := cut, boundary := N.left, pos := N.a, attained := hcut
    lower := le_rfl, upper := prep.center_interior.1
    separator := hsep, walk := .start hplaced }
  refine ⟨st, rfl, rfl, ?_⟩
  intro x
  rw [SideSystem.mem_remaining]
  change (x ∈ Inside prep.schedule N.a N.b ∧
    x ∈ sameCenterLow N prep.schedule ∧ x ∉ sameLow N prep.schedule cut) ↔ _
  constructor
  · rintro ⟨hx, hxC, hxL⟩
    refine ⟨hx, (hsel x hx).mp ?_⟩
    by_contra hn
    exact hxL ((same_low_iff history prep cut hx).mpr ⟨hxC.2, hn⟩)
  · rintro ⟨hx, hxQ⟩
    exact ⟨hx, ⟨hx, hI1.old_high ⟨hx, hxQ⟩⟩,
      fun hxL => ((same_low_iff history prep cut hx).mp hxL).2 ((hsel x hx).mpr hxQ)⟩

def switchedInitial {T : ℕ} {N : RawNode Job T}
    (prep : NodePreparation N) : (switchedSystem prep).State where
  label := 0
  boundary := N.right.reverse
  pos := reverseTime T N.b
  attained := ⟨Nat.zero_le _, Or.inl rfl⟩
  lower := le_rfl
  upper := by
    have := prep.center_interior.2
    dsimp [reverseTime]
    omega
  separator := (initial_switched_separator prep).1
  walk := (initial_switched_separator prep).2

def sameRaw {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    (e : (sameSystem history prep).Segment)
    (hne : (Inside prep.schedule e.c e.d).Nonempty) : RawSameData N where
  prepared := prep.schedule
  preparation := prep.preparation
  priority := prep.sameOrder
  priority_protocol := prep.same_protocol
  center := prep.center
  v := prep.v
  center_placed := prep.center_placed
  center_interior := prep.center_interior
  center_separator := prep.same_center
  cut := e.label
  cut_attained := e.attained
  childLeft := e.left
  childRight := e.right
  c := e.c
  d := e.d
  right_placed := e.right_placed
  nonempty_child := hne
  right_before_center := e.before_center
  walk := e.walk
  left_separator := e.left_separator
  right_separator := e.right_separator
  normalized := prep.same_normalized

theorem switched_gap_incoming {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (prep : NodePreparation N)
    (e : (switchedSystem prep).Segment)
    (hne : (Inside prep.schedule.reverse e.c e.d).Nonempty) :
    ∃ s, N.incoming = some s := by
  cases history with
  | root =>
      obtain ⟨x, hx⟩ := hne
      have hxE := e.gap_subset hx
      change x ∈ Inside prep.schedule.reverse (reverseTime T ((T : ℤ) + 1))
        (reverseTime T prep.v) at hxE
      rw [root_switched_side_empty prep] at hxE
      exact False.elim hxE
  | same past old => exact ⟨old.creation, rfl⟩
  | switched past old => exact ⟨old.creationRecord, rfl⟩

noncomputable def switchedRaw {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (prep : NodePreparation N)
    (e : (switchedSystem prep).Segment)
    (hne : (Inside prep.schedule.reverse e.c e.d).Nonempty) : RawSwitchData N where
  prepared := prep.schedule.reverse
  preparation := reorders_reverse prep.preparation
  creation := Classical.choose (switched_gap_incoming history prep e hne)
  chronology := Classical.choose_spec (switched_gap_incoming history prep e hne)
  priority := prep.switchedOrder
  priority_protocol := fun x _ y _ => prep.switched_protocol x y
  center := prep.center
  v := reverseTime T prep.v
  center_placed := placed_reverse prep.center_placed
  center_interior := by
    have := prep.center_interior
    dsimp [reverseTime]
    omega
  center_separator := prep.switched_center
  r := e.label
  rank_bound := e.attained.1
  rank_attained := e.attained.2
  childLeft := e.left
  childRight := e.right
  c := e.c
  d := e.d
  right_placed := e.right_placed
  nonempty_child := hne
  right_before_center := e.before_center
  walk := e.walk
  left_separator := e.left_separator
  right_separator := e.right_separator
  normalized := prep.switched_normalized

theorem all_gap_histories {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (prep : NodePreparation N) :
    (∀ e : (sameSystem history.raw prep).Segment,
      ∀ hne : (Inside prep.schedule e.c e.d).Nonempty,
        RootedHistory P σ (sameRaw history.raw prep e hne).child) ∧
    (∀ e : (switchedSystem prep).Segment,
      ∀ hne : (Inside prep.schedule.reverse e.c e.d).Nonempty,
        RootedHistory P σ (switchedRaw history prep e hne).child) :=
  ⟨fun e hne => .same history (sameRaw history.raw prep e hne),
    fun e hne => .switched history (switchedRaw history prep e hne)⟩

theorem switched_final_threshold {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (prep : NodePreparation N)
    (e : (switchedSystem prep).Segment)
    (hne : (Inside prep.schedule.reverse e.c e.d).Nonempty)
    (hfinal : e.d = reverseTime T prep.v) :
    (switchedRaw history prep e hne).r = Fintype.card Job ∧
      (switchedRaw history prep e hne).child.list =
        prune (switchedRaw history prep e hne).data
          (Inside prep.schedule.reverse e.c e.d)
          [.first (Fintype.card Job + 1), .second none] := by
  have hr : e.label = Fintype.card Job := e.final_label hfinal
  constructor
  · exact hr
  · change prune _ _ [.first (e.label + 1), .second none] = _
    rw [hr]
    rfl

theorem actual_placed_unique {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {F G : Finset Job} {t : ℤ}
    (hF : Placed σ (.actual F) t) (hG : Placed σ (.actual G) t) : F = G :=
  Finset.ext (fun x => (hF.2 x).trans (hG.2 x).symm)

theorem same_segment_mark {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    (e : (sameSystem history prep).Segment) :
    ∃ F : Syntax Job, SourceSplitCertificate prep.schedule N.domain
      (.actual e.right) e.d F := by
  rcases e.before_center.lt_or_eq with hlt | heq
  · exact ⟨_, history.same_mark_certified prep.schedule prep.preparation e.label
      e.attained prep.center_placed e.right_placed hlt prep.center_interior.2.le
      prep.same_center e.right_separator⟩
  · have hF : e.right = prep.center :=
      actual_placed_unique
        (Eq.mp (congrArg (fun t => Placed prep.schedule (.actual e.right) t) heq)
          e.right_placed) prep.center_placed
    rw [heq, hF]
    exact ⟨_, (prepared_centers_certified history prep).1⟩

theorem switched_segment_left_mark {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    (e : (switchedSystem prep).Segment)
    (hc : reverseTime T N.b < e.c) :
    ∃ (Z : Finset Job) (F : Syntax Job), e.left = .actual Z ∧
      SourceSplitCertificate prep.schedule.reverse N.domain (.actual Z) e.c F := by
  obtain ⟨Z, hZ⟩ := SideSystem.walk_after_actual e.walk hc
  have hZp : Placed prep.schedule.reverse (.actual Z) e.c := by
    rw [← hZ]
    exact walk_placed e.walk
  have hZs : Separator prep.schedule.reverse
      (Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T prep.v))
      (switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
        N.right.reverse e.label) (.actual Z) e.c := by
    rw [← hZ]
    exact e.left_separator
  have hcert := history.switched_mark_certified prep.schedule.reverse
    (reorders_reverse prep.preparation) e.label e.attained.1
    (placed_reverse prep.center_placed) hZp
    (e.ordered.trans_le e.before_center)
    (by have := prep.center_interior.1; dsimp [reverseTime]; omega)
    prep.switched_center hZs
  exact ⟨Z, _, hZ, hcert⟩

@[simp] theorem reverseTime_twice (T : ℕ) (t : ℤ) :
    reverseTime T (reverseTime T t) = t := by
  dsimp [reverseTime]
  omega

theorem placed_reverse_back {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {t : ℤ}
    (h : Placed σ.reverse B t) : Placed σ B.reverse (reverseTime T t) := by
  cases B with
  | left =>
      change t = 0 at h
      change reverseTime T t = (T : ℤ) + 1
      simp [h, reverseTime]
  | right =>
      change t = (T : ℤ) + 1 at h
      change reverseTime T t = 0
      simp [h, reverseTime]
  | actual F =>
      refine ⟨h.1, fun x => ?_⟩
      rw [h.2 x]
      change reverseTime T (σ.time x) = t ↔ σ.time x = reverseTime T t
      dsimp [reverseTime]
      omega

structure TwoWaySplit {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (domain : Set Job) (z : ℤ) where
  forward : Syntax Job
  backward : Syntax Job
  forward_allowed : forward.Allowed (Fintype.card Job)
  backward_allowed : backward.Allowed (Fintype.card Job)
  forward_small : forward.leaves < 500
  backward_small : backward.leaves < 500
  earlier : ∀ x ∈ domain, x ∈ forward.denote P ↔ σ.time x < z
  reversed_earlier : ∀ x ∈ domain,
    x ∈ backward.denote P.reverse ↔ σ.reverse.time x < reverseTime T z

def TwoWaySplit.ofSource {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {domain : Set Job} {Z : TemporalBoundary.Boundary Job}
    {z : ℤ} {F : Syntax Job} (h : SourceSplitCertificate σ domain Z z F) :
    TwoWaySplit σ domain z where
  forward := F
  backward := (reverseSplitSyntax Z F).flip
  forward_allowed := h.allowed
  backward_allowed := h.reversed_allowed
  forward_small := h.split.leaves
  backward_small := h.split.reversed_leaves
  earlier := h.split.earlier
  reversed_earlier := h.split.reversed_earlier

def TwoWaySplit.reverseBack {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {domain : Set Job} {z : ℤ}
    (h : TwoWaySplit σ.reverse domain z) :
    TwoWaySplit σ domain (reverseTime T z) where
  forward := h.backward
  backward := h.forward
  forward_allowed := h.backward_allowed
  backward_allowed := h.forward_allowed
  forward_small := h.backward_small
  backward_small := h.forward_small
  earlier := by
    intro x hx
    have he := h.reversed_earlier x hx
    rw [syntax_frame_same (frame_same_double_reverse P)] at he
    simpa only [Schedule.reverse, reverseTime_twice] using he
  reversed_earlier := by
    intro x hx
    simpa only [reverseTime_twice] using h.earlier x hx

structure Geometry {P : Precedence Job} {T : ℕ} (σ : Schedule P T) where
  left : TemporalBoundary.Boundary Job
  right : TemporalBoundary.Boundary Job
  c : ℤ
  d : ℤ
  ordered : c < d
  left_placed : Placed σ left c
  right_placed : Placed σ right d

def Geometry.reverseBack {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    (g : Geometry σ.reverse) : Geometry σ where
  left := g.right.reverse
  right := g.left.reverse
  c := reverseTime T g.d
  d := reverseTime T g.c
  ordered := by have := g.ordered; dsimp [reverseTime]; omega
  left_placed := placed_reverse_back g.right_placed
  right_placed := placed_reverse_back g.left_placed

def Geometry.reverse {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    (g : Geometry σ) : Geometry σ.reverse where
  left := g.right.reverse
  right := g.left.reverse
  c := reverseTime T g.d
  d := reverseTime T g.c
  ordered := by have := g.ordered; dsimp [reverseTime]; omega
  left_placed := placed_reverse g.right_placed
  right_placed := placed_reverse g.left_placed

def SideSystem.Segment.geometry {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v : ℤ}
    {A : TemporalBoundary.Boundary Job} {parent centerLow : Set Job} {Label : Type}
    {S : SideSystem σ π a v A parent centerLow Label} (e : S.Segment) : Geometry σ where
  left := e.left
  right := .actual e.right
  c := e.c
  d := e.d
  ordered := e.ordered
  left_placed := walk_placed e.walk
  right_placed := e.right_placed

def Tiling {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    (s finish : ℤ) : List (Geometry σ) → Prop
  | [] => s = finish
  | g :: gs => g.c = s ∧ Tiling g.d finish gs

theorem Tiling.append {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s m finish : ℤ} {gs hs : List (Geometry σ)}
    (hgs : Tiling s m gs) (hhs : Tiling m finish hs) :
    Tiling s finish (gs ++ hs) := by
  induction gs generalizing s with
  | nil => simpa only [List.nil_append, Tiling] using hgs ▸ hhs
  | cons g gs ih => exact ⟨hgs.1, ih hgs.2⟩

theorem Tiling.bounds {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs) :
    ∀ g ∈ gs, s ≤ g.c ∧ g.d ≤ finish := by
  induction gs generalizing s with
  | nil => simp
  | cons g gs ih =>
      intro f hf
      have ht := ih tiles.2
      rcases List.mem_cons.mp hf with hfg | hf
      · subst f
        have hend : g.d ≤ finish := by
          cases gs with
          | nil => exact tiles.2.le
          | cons h hs =>
              have hb := ht h (by simp)
              exact hb.1.trans (h.ordered.le.trans hb.2)
        exact ⟨tiles.1.ge, hend⟩
      · exact ⟨tiles.1 ▸ g.ordered.le.trans (ht f hf).1, (ht f hf).2⟩

theorem Tiling.cover {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish t : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs)
    (hst : s < t) (htf : t ≤ finish) :
    ∃ g ∈ gs, g.c < t ∧ t ≤ g.d := by
  induction gs generalizing s with
  | nil => dsimp [Tiling] at tiles; omega
  | cons g gs ih =>
      by_cases htd : t ≤ g.d
      · exact ⟨g, by simp, tiles.1.symm ▸ hst, htd⟩
      · obtain ⟨h, hh, hct, hdt⟩ := ih tiles.2 (lt_of_not_ge htd)
        exact ⟨h, by simp [hh], hct, hdt⟩

theorem Tiling.unique {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish t : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs)
    {g h : Geometry σ} (hg : g ∈ gs) (hh : h ∈ gs)
    (hgt : g.c < t ∧ t ≤ g.d) (hht : h.c < t ∧ t ≤ h.d) : g = h := by
  induction gs generalizing s with
  | nil => simp at hg
  | cons e es ih =>
      rcases List.mem_cons.mp hg with hge | hgTail
      · rcases List.mem_cons.mp hh with hhe | hhTail
        · exact hge.trans hhe.symm
        · have hb := (Tiling.bounds tiles.2 h hhTail).1
          rw [hge] at hgt
          have := hgt.2
          have := hht.1
          omega
      · rcases List.mem_cons.mp hh with hhe | hhTail
        · have hb := (Tiling.bounds tiles.2 g hgTail).1
          rw [hhe] at hht
          have := hht.2
          have := hgt.1
          omega
        · exact ih tiles.2 hgTail hhTail

theorem Tiling.no_internal_endpoint {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {s finish : ℤ} {gs : List (Geometry σ)}
    (tiles : Tiling s finish gs) {g h : Geometry σ} (hg : g ∈ gs) (hh : h ∈ gs) :
    ¬ (g.c < h.d ∧ h.d < g.d) := by
  intro hlt
  have he := tiles.unique hg hh ⟨hlt.1, hlt.2.le⟩ ⟨h.ordered, le_rfl⟩
  have := hlt.2
  rw [he] at this
  exact lt_irrefl _ this

theorem Tiling.sorted {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs) :
    (gs.map (fun g => g.d)).Pairwise (· < ·) := by
  induction gs generalizing s with
  | nil => simp
  | cons g gs ih =>
      rw [List.map_cons, List.pairwise_cons]
      refine ⟨?_, ih tiles.2⟩
      intro d hd
      obtain ⟨h, hh, rfl⟩ := List.mem_map.mp hd
      exact (Tiling.bounds tiles.2 h hh).1.trans_lt h.ordered

theorem Tiling.reverseBack {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ.reverse)}
    (tiles : Tiling s finish gs) :
    Tiling (reverseTime T finish) (reverseTime T s)
      (gs.reverse.map Geometry.reverseBack) := by
  induction gs generalizing s with
  | nil =>
      simp only [List.reverse_nil, List.map_nil, Tiling] at *
      exact congrArg (reverseTime T) tiles.symm
  | cons g gs ih =>
      rw [List.reverse_cons, List.map_append, List.map_singleton]
      apply Tiling.append (ih tiles.2)
      exact ⟨rfl, congrArg (reverseTime T) tiles.1⟩

theorem Tiling.reverse {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)}
    (tiles : Tiling s finish gs) :
    Tiling (reverseTime T finish) (reverseTime T s)
      (gs.reverse.map Geometry.reverse) := by
  induction gs generalizing s with
  | nil =>
      simp only [List.reverse_nil, List.map_nil, Tiling] at *
      exact congrArg (reverseTime T) tiles.symm
  | cons g gs ih =>
      rw [List.reverse_cons, List.map_append, List.map_singleton]
      apply Tiling.append (ih tiles.2)
      exact ⟨rfl, congrArg (reverseTime T) tiles.1⟩

theorem SideSystem.Tiles.geometry {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v s : ℤ}
    {A : TemporalBoundary.Boundary Job} {parent centerLow : Set Job} {Label : Type}
    {S : SideSystem σ π a v A parent centerLow Label}
    {es : List S.Segment} (tiles : S.Tiles s es) :
    Tiling s v (es.map SideSystem.Segment.geometry) := by
  induction tiles with
  | nil => rfl
  | cons he ht ih => exact ⟨he, ih⟩

theorem Tiling.last_endpoint {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)}
    (tiles : Tiling s finish gs) (hne : gs ≠ []) :
    ∃ g ∈ gs, g.d = finish := by
  induction gs generalizing s with
  | nil => exact False.elim (hne rfl)
  | cons g gs ih =>
      by_cases he : gs = []
      · subst gs
        exact ⟨g, by simp, tiles.2⟩
      · obtain ⟨h, hh, hd⟩ := ih tiles.2 he
        exact ⟨h, by simp [hh], hd⟩

theorem Tiling.left_is_endpoint {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs)
    {g : Geometry σ} (hg : g ∈ gs) (hc : s < g.c) :
    ∃ h ∈ gs, h.d = g.c := by
  induction gs generalizing s with
  | nil => simp at hg
  | cons e es ih =>
      rcases List.mem_cons.mp hg with hge | hgTail
      · rw [hge, tiles.1] at hc
        exact False.elim (lt_irrefl _ hc)
      · have hb := (Tiling.bounds tiles.2 g hgTail).1
        rcases hb.lt_or_eq with hlt | heq
        · obtain ⟨h, hh, hd⟩ := ih tiles.2 hgTail hlt
          exact ⟨h, by simp [hh], hd⟩
        · exact ⟨e, by simp, heq⟩

theorem Tiling.endpoint_is_left {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs)
    {g : Geometry σ} (hg : g ∈ gs) (hd : g.d < finish) :
    ∃ h ∈ gs, h.c = g.d := by
  induction gs generalizing s with
  | nil => simp at hg
  | cons e es ih =>
      rcases List.mem_cons.mp hg with hge | hgTail
      · subst g
        cases es with
        | nil =>
            have he : e.d = finish := tiles.2
            omega
        | cons h hs =>
            exact ⟨h, by simp, tiles.2.1⟩
      · obtain ⟨h, hh, hc⟩ := ih tiles.2 hgTail
        exact ⟨h, by simp [hh], hc⟩

theorem Tiling.adjacent_boundaries {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {s finish : ℤ} {gs : List (Geometry σ)}
    (tiles : Tiling s finish gs) {g : Geometry σ} (hg : g ∈ gs) :
    (g.c = s ∨ ∃ h ∈ gs, h.d = g.c) ∧
      (g.d = finish ∨ g.d < finish) ∧
      ∀ h ∈ gs, ¬ (g.c < h.d ∧ h.d < g.d) := by
  have hb := tiles.bounds g hg
  refine ⟨?_, ?_, fun h hh => tiles.no_internal_endpoint hg hh⟩
  · rcases hb.1.lt_or_eq with hlt | heq
    · exact Or.inr (tiles.left_is_endpoint hg hlt)
    · exact Or.inl heq.symm
  · rcases hb.2.lt_or_eq with hlt | heq
    · exact Or.inr hlt
    · exact Or.inl heq

theorem Tiling.partition_jobs {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs) (x : Job) :
    x ∈ Inside σ s finish ↔
      (∃ g ∈ gs, x ∈ Inside σ g.c g.d) ∨
      (∃ g ∈ gs, g.d < finish ∧ x ∈ g.right.jobs) := by
  constructor
  · intro hx
    obtain ⟨g, hg, hct, htd⟩ := tiles.cover hx.1 hx.2.le
    rcases htd.lt_or_eq with hlt | heq
    · exact Or.inl ⟨g, hg, hct, hlt⟩
    · exact Or.inr ⟨g, hg, by have := hx.2; omega,
        time_mem_boundary g.right_placed heq⟩
  · rintro (⟨g, hg, hx⟩ | ⟨g, hg, hdf, hx⟩)
    · have hb := tiles.bounds g hg
      exact ⟨hb.1.trans_lt hx.1, hx.2.trans_le hb.2⟩
    · have hb := tiles.bounds g hg
      have ht := boundary_jobs_time g.right_placed hx
      change s < σ.time x ∧ σ.time x < finish
      rw [ht]
      exact ⟨hb.1.trans_lt g.ordered, hdf⟩

theorem Tiling.unique_part {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {s finish : ℤ} {gs : List (Geometry σ)} (tiles : Tiling s finish gs)
    {x : Job} (hx : x ∈ Inside σ s finish) :
    ∃! g : Geometry σ, g ∈ gs ∧ g.c < σ.time x ∧ σ.time x ≤ g.d := by
  obtain ⟨g, hg, hct, htd⟩ := tiles.cover hx.1 hx.2.le
  exact ⟨g, ⟨hg, hct, htd⟩, fun h hh =>
    tiles.unique hh.1 hg hh.2 ⟨hct, htd⟩⟩

theorem boundary_eq_actual {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {F : Finset Job} {t : ℤ}
    (hB : Placed σ B t) (hF : Placed σ (.actual F) t) : B = .actual F := by
  have hr := placed_actual_range hF
  cases B with
  | left => change t = 0 at hB; omega
  | right => change t = (T : ℤ) + 1 at hB; omega
  | actual G => exact congrArg TemporalBoundary.Boundary.actual (actual_placed_unique hB hF)

theorem inside_reverse_arbitrary {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (c d : ℤ) :
    Inside σ.reverse c d = Inside σ (reverseTime T d) (reverseTime T c) := by
  ext x
  dsimp [Inside, Schedule.reverse, reverseTime]
  omega

inductive RawGap {T : ℕ} (N : RawNode Job T)
  | same (edge : RawSameData N)
  | switched (edge : RawSwitchData N)

noncomputable def RawGap.child {T : ℕ} {N : RawNode Job T} :
    RawGap N → RawNode Job T
  | .same e => e.child
  | .switched e => e.child

def RawGap.Realizes {T : ℕ} {N : RawNode Job T} (prep : NodePreparation N)
    (g : Geometry prep.schedule) : RawGap N → Prop
  | .same e => e.prepared = prep.schedule ∧ e.c = g.c ∧ e.d = g.d
  | .switched e => e.prepared = prep.schedule.reverse ∧
      reverseTime T e.d = g.c ∧ reverseTime T e.c = g.d

theorem RawGap.rooted {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (edge : RawGap N) :
    RootedHistory P σ edge.child := by
  cases edge with
  | same e => exact .same history e
  | switched e => exact .switched history e

theorem RawGap.domain {T : ℕ} {N : RawNode Job T} {prep : NodePreparation N}
    {g : Geometry prep.schedule} {edge : RawGap N} (h : edge.Realizes prep g) :
    edge.child.domain = Inside prep.schedule g.c g.d := by
  cases edge with
  | same e =>
      obtain ⟨hs, hc, hd⟩ := h
      change Inside e.prepared e.c e.d = _
      rw [hs, hc, hd]
  | switched e =>
      obtain ⟨hs, hc, hd⟩ := h
      change Inside e.prepared e.c e.d = _
      rw [hs, inside_reverse_arbitrary, hc, hd]

noncomputable def jobCount (U : Set Job) : ℕ :=
  (Finset.univ.filter (fun x => x ∈ U)).card

theorem jobCount_strict {U V : Set Job} (hUV : U ⊆ V)
    (hex : ∃ x ∈ V, x ∉ U) : jobCount U < jobCount V := by
  classical
  apply Finset.card_lt_card
  rw [Finset.ssubset_iff_subset_ne]
  refine ⟨?_, ?_⟩
  · intro x hx
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hUV ((Finset.mem_filter.mp hx).2)⟩
  · obtain ⟨x, hxV, hxU⟩ := hex
    intro he
    have hm : x ∈ Finset.univ.filter (fun x => x ∈ V) := by simp [hxV]
    rw [← he] at hm
    exact hxU ((Finset.mem_filter.mp hm).2)

structure Batch {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (prep : NodePreparation N) where
  same_start : (sameSystem history.raw prep).State
  same_position : same_start.pos = N.a
  same_boundary : same_start.boundary = N.left
  same_pending : ∀ x,
    x ∈ (sameSystem history.raw prep).remaining same_start.label ↔
      x ∈ Inside prep.schedule N.a N.b ∧ x ∈ N.qualifiers
  same_run : (sameSystem history.raw prep).Run same_start
  switched_run : (switchedSystem prep).Run (switchedInitial prep)

theorem batch_exists {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (prep : NodePreparation N) :
    Nonempty (Batch history prep) := by
  obtain ⟨st, hpos, hB, hrem⟩ := sameInitial history.raw prep
  obtain ⟨rs⟩ := (sameSystem history.raw prep).run_exists prep.same_normalized st
  obtain ⟨rx⟩ :=
    (switchedSystem prep).run_exists prep.switched_normalized (switchedInitial prep)
  exact ⟨⟨st, hpos, hB, hrem, rs, rx⟩⟩

namespace Batch

variable {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
  {N : RawNode Job T} {history : RootedHistory P σ N} {prep : NodePreparation N}

noncomputable def sameEdges (batch : Batch history prep) :
    List (sameSystem history.raw prep).Segment :=
  batch.same_run.segments prep.center prep.center_placed prep.same_center

noncomputable def switchedEdges (batch : Batch history prep) :
    List (switchedSystem prep).Segment :=
  batch.switched_run.segments prep.center (placed_reverse prep.center_placed)
    prep.switched_center

theorem all_same_promotions (batch : Batch history prep) :
    batch.same_run.jobs.Nodup ∧ ∀ x, x ∈ batch.same_run.jobs ↔
      x ∈ Inside prep.schedule N.a N.b ∧ x ∈ N.qualifiers :=
  ⟨batch.same_run.all_promotions.1,
    fun x => (batch.same_run.all_promotions.2 x).trans (batch.same_pending x)⟩

theorem all_switched_promotions (batch : Batch history prep) :
    batch.switched_run.jobs.Nodup ∧ ∀ x, x ∈ batch.switched_run.jobs ↔
      x ∈ switchCenterLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
        N.right.reverse := by
  refine ⟨batch.switched_run.all_promotions.1, ?_⟩
  intro x
  rw [batch.switched_run.all_promotions.2, SideSystem.mem_remaining]
  change (x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) ∧
    x ∈ switchCenterLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
      N.right.reverse ∧
    x ∉ switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
      N.right.reverse 0) ↔ _
  have hzero : x ∉ switchLow prep.schedule.reverse (reverseTime T N.b)
      (reverseTime T N.a) N.right.reverse 0 := by
    intro hx
    have := N.frame.reverse.rank_pos x
    have := hx.2.2
    omega
  simp only [hzero, not_false_eq_true, and_true]
  exact ⟨fun h => h.2, fun h => ⟨h.1, h⟩⟩

theorem same_tiling (batch : Batch history prep) :
    Tiling N.a prep.v (batch.sameEdges.map SideSystem.Segment.geometry) := by
  have ht := (batch.same_run.tiles prep.center prep.center_placed prep.same_center).geometry
  simpa only [batch.same_position, sameEdges] using ht

theorem switched_tiling (batch : Batch history prep) :
    Tiling (reverseTime T N.b) (reverseTime T prep.v)
      (batch.switchedEdges.map SideSystem.Segment.geometry) :=
  (batch.switched_run.tiles prep.center (placed_reverse prep.center_placed)
    prep.switched_center).geometry

noncomputable def gaps (batch : Batch history prep) : List (Geometry prep.schedule) :=
  batch.sameEdges.map SideSystem.Segment.geometry ++
    (batch.switchedEdges.map SideSystem.Segment.geometry).reverse.map Geometry.reverseBack

theorem tiling (batch : Batch history prep) : Tiling N.a N.b batch.gaps := by
  apply Tiling.append batch.same_tiling
  simpa only [reverseTime_twice] using batch.switched_tiling.reverseBack

theorem center_endpoint (batch : Batch history prep) :
    ∃ g ∈ batch.gaps, g.d = prep.v := by
  have hne : batch.sameEdges.map SideSystem.Segment.geometry ≠ [] := by
    intro he
    have ht := batch.same_tiling
    rw [he] at ht
    have hv := prep.center_interior.1
    change N.a = prep.v at ht
    omega
  obtain ⟨g, hg, hd⟩ := batch.same_tiling.last_endpoint hne
  exact ⟨g, List.mem_append_left _ hg, hd⟩

theorem every_gap_realized (batch : Batch history prep)
    (g : Geometry prep.schedule) (hg : g ∈ batch.gaps)
    (hne : (Inside prep.schedule g.c g.d).Nonempty) :
    ∃ edge : RawGap N, edge.Realizes prep g := by
  rcases List.mem_append.mp hg with hs | hx
  · obtain ⟨e, _, rfl⟩ := List.mem_map.mp hs
    exact ⟨.same (sameRaw history.raw prep e hne), rfl, rfl, rfl⟩
  · obtain ⟨g', hg', rfl⟩ := List.mem_map.mp hx
    have hg'' := List.mem_reverse.mp hg'
    obtain ⟨e, _, rfl⟩ := List.mem_map.mp hg''
    have hne' : (Inside prep.schedule.reverse e.c e.d).Nonempty := by
      rw [inside_reverse_arbitrary]
      exact hne
    exact ⟨.switched (switchedRaw history prep e hne'), rfl, rfl, rfl⟩

theorem every_mark_described (batch : Batch history prep)
    (g : Geometry prep.schedule) (hg : g ∈ batch.gaps) (hinternal : g.d < N.b) :
    ∃ Z : Finset Job, g.right = .actual Z ∧
      Nonempty (TwoWaySplit prep.schedule N.domain g.d) := by
  rcases List.mem_append.mp hg with hs | hx
  · obtain ⟨e, _, rfl⟩ := List.mem_map.mp hs
    obtain ⟨F, hF⟩ := same_segment_mark history.raw prep e
    exact ⟨e.right, rfl, ⟨TwoWaySplit.ofSource hF⟩⟩
  · obtain ⟨g', hg', rfl⟩ := List.mem_map.mp hx
    have hg'' := List.mem_reverse.mp hg'
    obtain ⟨e, _, rfl⟩ := List.mem_map.mp hg''
    have hc : reverseTime T N.b < e.c := by
      change reverseTime T e.c < N.b at hinternal
      dsimp [reverseTime] at *
      omega
    obtain ⟨Z, F, hZ, hF⟩ := switched_segment_left_mark history.raw prep e hc
    refine ⟨Z, ?_, ⟨(TwoWaySplit.ofSource hF).reverseBack⟩⟩
    change e.left.reverse = .actual Z
    simp only [hZ, TemporalBoundary.Boundary.reverse]

theorem gap_subset (batch : Batch history prep)
    {g : Geometry prep.schedule} (hg : g ∈ batch.gaps) :
    Inside prep.schedule g.c g.d ⊆ N.domain := by
  have hb := batch.tiling.bounds g hg
  intro x hx
  exact (prep.preparation.1 x).mpr
    ⟨hb.1.trans_lt hx.1, hx.2.trans_le hb.2⟩

theorem center_omitted (batch : Batch history prep)
    {g : Geometry prep.schedule} (hg : g ∈ batch.gaps) :
    ∀ x ∈ prep.center, x ∉ Inside prep.schedule g.c g.d := by
  obtain ⟨centerGap, hmem, hd⟩ := batch.center_endpoint
  intro x hx hxgap
  have ht := (prep.center_placed.2 x).mp hx
  exact batch.tiling.no_internal_endpoint hg hmem
    (by simpa only [Inside, Set.mem_setOf_eq, hd, ht] using hxgap)

theorem every_child_smaller (batch : Batch history prep)
    {g : Geometry prep.schedule} (hg : g ∈ batch.gaps)
    {edge : RawGap N} (hr : edge.Realizes prep g) :
    jobCount edge.child.domain < jobCount N.domain := by
  rw [RawGap.domain hr]
  apply jobCount_strict (batch.gap_subset hg)
  have hpos : 0 < prep.center.card := by rw [prep.center_placed.1]; norm_num
  obtain ⟨x, hx⟩ := Finset.card_pos.mp hpos
  refine ⟨x, (prep.preparation.1 x).mpr ?_, batch.center_omitted hg x hx⟩
  have ht := (prep.center_placed.2 x).mp hx
  simpa only [Inside, Set.mem_setOf_eq, ht] using prep.center_interior

theorem marks_and_children_cover (batch : Batch history prep) :
    ∀ x ∈ N.domain,
      (∃ g ∈ batch.gaps, g.d < N.b ∧ x ∈ g.right.jobs) ∨
      (∃ (g : Geometry prep.schedule) (edge : RawGap N),
        g ∈ batch.gaps ∧ edge.Realizes prep g ∧
        RootedHistory P σ edge.child ∧ x ∈ edge.child.domain) := by
  intro x hx
  have hxU := (prep.preparation.1 x).mp hx
  obtain ⟨g, hg, hct, htd⟩ := batch.tiling.cover hxU.1 hxU.2.le
  rcases htd.lt_or_eq with htd | heq
  · have hxgap : x ∈ Inside prep.schedule g.c g.d := ⟨hct, htd⟩
    obtain ⟨edge, hr⟩ := batch.every_gap_realized g hg ⟨x, hxgap⟩
    exact Or.inr ⟨g, edge, hg, hr, edge.rooted history, (RawGap.domain hr).symm ▸ hxgap⟩
  · exact Or.inl ⟨g, hg, by have := hxU.2; omega,
      time_mem_boundary g.right_placed heq⟩

theorem no_mark_in_child (batch : Batch history prep)
    {g h : Geometry prep.schedule} (hg : g ∈ batch.gaps) (hh : h ∈ batch.gaps)
    {x : Job} (hx : x ∈ h.right.jobs) :
    x ∉ Inside prep.schedule g.c g.d := by
  intro hxgap
  have ht := boundary_jobs_time h.right_placed hx
  exact batch.tiling.no_internal_endpoint hg hh
    (by simpa only [Inside, Set.mem_setOf_eq, ht] using hxgap)

theorem child_gaps_disjoint (batch : Batch history prep)
    {g h : Geometry prep.schedule} (hg : g ∈ batch.gaps) (hh : h ∈ batch.gaps)
    (hne : g ≠ h) :
    Disjoint (Inside prep.schedule g.c g.d) (Inside prep.schedule h.c h.d) := by
  rw [Set.disjoint_left]
  intro x hxg hxh
  exact hne (batch.tiling.unique hg hh ⟨hxg.1, hxg.2.le⟩ ⟨hxh.1, hxh.2.le⟩)

theorem every_left_mark_described (batch : Batch history prep)
    (g : Geometry prep.schedule) (hg : g ∈ batch.gaps) (hinternal : N.a < g.c) :
    ∃ Z : Finset Job, g.left = .actual Z ∧
      Nonempty (TwoWaySplit prep.schedule N.domain g.c) := by
  obtain ⟨h, hh, hd⟩ := batch.tiling.left_is_endpoint hg hinternal
  have hcb : h.d < N.b := by
    have hb := (batch.tiling.bounds g hg).2
    rw [hd]
    exact g.ordered.trans_le hb
  obtain ⟨Z, hZ, ⟨desc⟩⟩ := batch.every_mark_described h hh hcb
  have hplaced : Placed prep.schedule (.actual Z) g.c := by
    have hp := h.right_placed
    rw [hZ] at hp
    exact Eq.mp (congrArg (fun t => Placed prep.schedule (.actual Z) t) hd) hp
  refine ⟨Z, boundary_eq_actual g.left_placed hplaced, ?_⟩
  exact ⟨Eq.mp (congrArg (fun t => TwoWaySplit prep.schedule N.domain t) hd) desc⟩

end Batch

def scheduleInFrame {Q P : Precedence Job} {T : ℕ}
    (h : FrameSame Q P) (σ : Schedule Q T) : Schedule P T where
  time := σ.time
  feasible := fun {_ _} hxy => σ.feasible ((h.1 _ _).mpr hxy)
  complete := σ.complete

def Geometry.inFrame {Q P : Precedence Job} {T : ℕ} {σ : Schedule Q T}
    (h : FrameSame Q P) (g : Geometry σ) : Geometry (scheduleInFrame h σ) where
  left := g.left
  right := g.right
  c := g.c
  d := g.d
  ordered := g.ordered
  left_placed := g.left_placed
  right_placed := g.right_placed

theorem Tiling.inFrame {Q P : Precedence Job} {T : ℕ} {σ : Schedule Q T}
    (h : FrameSame Q P) {s finish : ℤ} {gs : List (Geometry σ)}
    (tiles : Tiling s finish gs) :
    Tiling s finish (gs.map (Geometry.inFrame h)) := by
  induction gs generalizing s with
  | nil => exact tiles
  | cons g gs ih => exact ⟨tiles.1, ih tiles.2⟩

inductive Orientation (Q P : Precedence Job)
  | direct (same : FrameSame Q P)
  | opposite (same : FrameSame Q P.reverse)

namespace Orientation

variable {Q P : Precedence Job} {T : ℕ}

noncomputable def schedule (o : Orientation Q P) (σ : Schedule Q T) : Schedule P T :=
  match o with
  | .direct h => scheduleInFrame h σ
  | .opposite h => scheduleInFrame
      (frame_same_trans (frame_same_reverse h) (frame_same_double_reverse P)) σ.reverse

def left (o : Orientation Q P) (a b : ℤ) : ℤ :=
  match o with
  | .direct _ => a
  | .opposite _ => reverseTime T b

def right (o : Orientation Q P) (a b : ℤ) : ℤ :=
  match o with
  | .direct _ => b
  | .opposite _ => reverseTime T a

def time (o : Orientation Q P) (t : ℤ) : ℤ :=
  match o with
  | .direct _ => t
  | .opposite _ => reverseTime T t

noncomputable def geometry (o : Orientation Q P) {σ : Schedule Q T}
    (g : Geometry σ) : Geometry (o.schedule σ) :=
  match o with
  | .direct h => g.inFrame h
  | .opposite h => g.reverse.inFrame
      (frame_same_trans (frame_same_reverse h) (frame_same_double_reverse P))

noncomputable def gaps (o : Orientation Q P) {σ : Schedule Q T}
    (gs : List (Geometry σ)) : List (Geometry (o.schedule σ)) :=
  match o with
  | .direct h => gs.map (Geometry.inFrame h)
  | .opposite h => gs.reverse.map (fun g => g.reverse.inFrame
      (frame_same_trans (frame_same_reverse h) (frame_same_double_reverse P)))

def switched (o : Orientation Q P) : Orientation Q.reverse P :=
  match o with
  | .direct h => .opposite (frame_same_reverse h)
  | .opposite h =>
      .direct (frame_same_trans (frame_same_reverse h) (frame_same_double_reverse P))

theorem domain (o : Orientation Q P) (σ : Schedule Q T) (a b : ℤ) :
    Inside (o.schedule σ) (o.left (T := T) a b) (o.right (T := T) a b) =
      Inside σ a b := by
  cases o with
  | direct _ => rfl
  | opposite _ =>
      change Inside σ.reverse (reverseTime T b) (reverseTime T a) = Inside σ a b
      exact inside_reverse σ a b

theorem reorders (o : Orientation Q P) {σ τ : Schedule Q T} {a b : ℤ}
    (h : Reorders σ τ a b) :
    Reorders (o.schedule σ) (o.schedule τ)
      (o.left (T := T) a b) (o.right (T := T) a b) := by
  cases o with
  | direct _ => exact h
  | opposite _ => exact reorders_reverse h

theorem tiling (o : Orientation Q P) {σ : Schedule Q T} {a b : ℤ}
    {gs : List (Geometry σ)} (tiles : Tiling a b gs) :
    Tiling (o.left (T := T) a b) (o.right (T := T) a b) (o.gaps gs) := by
  cases o with
  | direct h => exact tiles.inFrame h
  | opposite h =>
      have ht := (tiles.reverse).inFrame
        (frame_same_trans (frame_same_reverse h) (frame_same_double_reverse P))
      simpa only [List.map_map, Function.comp_def, gaps, left, right, schedule] using ht

theorem gap_membership (o : Orientation Q P) {σ : Schedule Q T}
    {gs : List (Geometry σ)} {g' : Geometry (o.schedule σ)} (hg' : g' ∈ o.gaps gs) :
    ∃ g ∈ gs, g' = o.geometry g := by
  cases o with
  | direct h =>
      obtain ⟨g, hg, rfl⟩ := List.mem_map.mp hg'
      exact ⟨g, hg, rfl⟩
  | opposite h =>
      obtain ⟨g, hg, rfl⟩ := List.mem_map.mp hg'
      exact ⟨g, List.mem_reverse.mp hg, rfl⟩

theorem geometry_member (o : Orientation Q P) {σ : Schedule Q T}
    {gs : List (Geometry σ)} {g : Geometry σ} (hg : g ∈ gs) :
    o.geometry g ∈ o.gaps gs := by
  cases o with
  | direct h => exact List.mem_map.mpr ⟨g, hg, rfl⟩
  | opposite h => exact List.mem_map.mpr ⟨g, List.mem_reverse.mpr hg, rfl⟩

theorem geometry_domain (o : Orientation Q P) {σ : Schedule Q T} (g : Geometry σ) :
    Inside (o.schedule σ) (o.geometry g).c (o.geometry g).d = Inside σ g.c g.d := by
  cases o with
  | direct h => rfl
  | opposite h =>
      change Inside σ.reverse (reverseTime T g.d) (reverseTime T g.c) = Inside σ g.c g.d
      exact inside_reverse σ g.c g.d

theorem mark_description (o : Orientation Q P) {σ : Schedule Q T}
    {U : Set Job} {z : ℤ} (h : TwoWaySplit σ U z) :
    ∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧
      ∀ x ∈ U, x ∈ F.denote P ↔ (o.schedule σ).time x < o.time (T := T) z := by
  cases o with
  | direct hf =>
      refine ⟨h.forward, h.forward_allowed, h.forward_small, ?_⟩
      intro x hx
      rw [← syntax_frame_same hf]
      exact h.earlier x hx
  | opposite hf =>
      refine ⟨h.backward, h.backward_allowed, h.backward_small, ?_⟩
      intro x hx
      rw [← syntax_frame_same
        (frame_same_trans (frame_same_reverse hf) (frame_same_double_reverse P))]
      exact h.reversed_earlier x hx

def child {N : RawNode Job T} (o : Orientation N.frame P)
    (edge : RawGap N) : Orientation edge.child.frame P :=
  match edge with
  | .same _ => o
  | .switched _ => o.switched

theorem child_schedule {N : RawNode Job T} {prep : NodePreparation N}
    (o : Orientation N.frame P) {g : Geometry prep.schedule} {edge : RawGap N}
    (hr : edge.Realizes prep g) :
    (o.child edge).schedule edge.child.schedule = o.schedule prep.schedule := by
  cases edge with
  | same e =>
      obtain ⟨hs, _, _⟩ := hr
      cases o with
      | direct hf =>
          apply schedule_ext
          funext x
          change e.prepared.time x = prep.schedule.time x
          exact congrArg (fun σ => σ.time x) hs
      | opposite hf =>
          apply schedule_ext
          funext x
          change reverseTime T (e.prepared.time x) = reverseTime T (prep.schedule.time x)
          exact congrArg (fun σ => reverseTime T (σ.time x)) hs
  | switched e =>
      obtain ⟨hs, _, _⟩ := hr
      cases o with
      | direct hf =>
          apply schedule_ext
          funext x
          change reverseTime T (e.prepared.time x) = prep.schedule.time x
          rw [hs]
          exact reverseTime_twice T _
      | opposite hf =>
          apply schedule_ext
          funext x
          change e.prepared.time x = reverseTime T (prep.schedule.time x)
          rw [hs]
          rfl

theorem child_interval {N : RawNode Job T} {prep : NodePreparation N}
    (o : Orientation N.frame P) {g : Geometry prep.schedule} {edge : RawGap N}
    (hr : edge.Realizes prep g) :
    (o.child edge).left (T := T) edge.child.a edge.child.b = (o.geometry g).c ∧
      (o.child edge).right (T := T) edge.child.a edge.child.b = (o.geometry g).d := by
  cases edge with
  | same e =>
      obtain ⟨_, hc, hd⟩ := hr
      cases o with
      | direct hf => exact ⟨hc, hd⟩
      | opposite hf =>
          exact ⟨congrArg (reverseTime T) hd, congrArg (reverseTime T) hc⟩
  | switched e =>
      obtain ⟨_, hc, hd⟩ := hr
      cases o with
      | direct hf => exact ⟨hc, hd⟩
      | opposite hf =>
          constructor
          · change e.c = reverseTime T g.d
            simpa only [reverseTime_twice] using congrArg (reverseTime T) hd
          · change e.d = reverseTime T g.c
            simpa only [reverseTime_twice] using congrArg (reverseTime T) hc

end Orientation

namespace Batch

variable {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
  {N : RawNode Job T} {history : RootedHistory P σ N} {prep : NodePreparation N}

theorem original_domain (_batch : Batch history prep) (o : Orientation N.frame P) :
    N.domain = Inside (o.schedule prep.schedule)
      (o.left (T := T) N.a N.b) (o.right (T := T) N.a N.b) := by
  rw [o.domain]
  exact Set.ext prep.preparation.1

theorem original_marks (batch : Batch history prep) (o : Orientation N.frame P)
    (g' : Geometry (o.schedule prep.schedule)) (hg' : g' ∈ o.gaps batch.gaps)
    (hinternal : g'.d < o.right (T := T) N.a N.b) :
    ∃ Z : Finset Job, g'.right = .actual Z ∧
      ∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧
        ∀ x ∈ N.domain, x ∈ F.denote P ↔ (o.schedule prep.schedule).time x < g'.d := by
  obtain ⟨g, hg, rfl⟩ := o.gap_membership hg'
  cases o with
  | direct hf =>
      change g.d < N.b at hinternal
      obtain ⟨Z, hZ, ⟨desc⟩⟩ := batch.every_mark_described g hg hinternal
      obtain ⟨F, hallowed, hsmall, hearlier⟩ :=
        (Orientation.direct hf).mark_description desc
      exact ⟨Z, hZ, F, hallowed, hsmall, hearlier⟩
  | opposite hf =>
      have hc : N.a < g.c := by
        change reverseTime T g.c < reverseTime T N.a at hinternal
        dsimp [reverseTime] at hinternal
        omega
      obtain ⟨Z, hZ, ⟨desc⟩⟩ := batch.every_left_mark_described g hg hc
      obtain ⟨F, hallowed, hsmall, hearlier⟩ :=
        (Orientation.opposite hf).mark_description desc
      refine ⟨Z, ?_, F, hallowed, hsmall, hearlier⟩
      change g.left.reverse = .actual Z
      simp only [hZ, TemporalBoundary.Boundary.reverse]

theorem original_nonempty_marks (batch : Batch history prep)
    (o : Orientation N.frame P) :
    ∃ g ∈ o.gaps batch.gaps, g.d < o.right (T := T) N.a N.b := by
  obtain ⟨g, hg, hd⟩ := batch.center_endpoint
  cases o with
  | direct hf =>
      refine ⟨(Orientation.direct hf).geometry g,
        (Orientation.direct hf).geometry_member hg, ?_⟩
      change g.d < N.b
      rw [hd]
      exact prep.center_interior.2
  | opposite hf =>
      have hgb : g.d < N.b := hd ▸ prep.center_interior.2
      obtain ⟨h, hh, hc⟩ := batch.tiling.endpoint_is_left hg hgb
      refine ⟨(Orientation.opposite hf).geometry h,
        (Orientation.opposite hf).geometry_member hh, ?_⟩
      change reverseTime T h.c < reverseTime T N.a
      rw [hc, hd]
      have hv := prep.center_interior.1
      dsimp [reverseTime]
      omega

theorem original_child (batch : Batch history prep) (o : Orientation N.frame P)
    (g' : Geometry (o.schedule prep.schedule)) (hg' : g' ∈ o.gaps batch.gaps)
    (hne : (Inside (o.schedule prep.schedule) g'.c g'.d).Nonempty) :
    ∃ edge : RawGap N, RootedHistory P σ edge.child ∧
      jobCount edge.child.domain < jobCount N.domain ∧
      (o.child edge).schedule edge.child.schedule = o.schedule prep.schedule ∧
      (o.child edge).left (T := T) edge.child.a edge.child.b = g'.c ∧
      (o.child edge).right (T := T) edge.child.a edge.child.b = g'.d := by
  obtain ⟨g, hg, rfl⟩ := o.gap_membership hg'
  have hne' : (Inside prep.schedule g.c g.d).Nonempty := by
    rw [← o.geometry_domain g]
    exact hne
  obtain ⟨edge, hr⟩ := batch.every_gap_realized g hg hne'
  exact ⟨edge, edge.rooted history, batch.every_child_smaller hg hr,
    o.child_schedule hr, (o.child_interval hr).1, (o.child_interval hr).2⟩

end Batch

structure GlobalDescription (P : Precedence Job) (U : Set Job) where
  formula : Syntax Job
  allowed : formula.Allowed (Fintype.card Job)
  small : formula.leaves < 500
  exact_set : formula.denote P = U

def NonemptyGapIndex {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    (gs : List (Geometry σ)) :=
  {i : Fin gs.length // (Inside σ (gs.get i).c (gs.get i).d).Nonempty}

instance finiteNonemptyGapIndex {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    (gs : List (Geometry σ)) : Finite (NonemptyGapIndex gs) := by
  unfold NonemptyGapIndex
  infer_instance

inductive BoundedHierarchy (P : Precedence Job) (T : ℕ) :
    Schedule P T → ℤ → ℤ → Type _
  | empty {σ : Schedule P T} {a b : ℤ}
      (no_jobs : Inside σ a b = ∅)
      (description : GlobalDescription P (Inside σ a b)) :
      BoundedHierarchy P T σ a b
  | branch {σ : Schedule P T} {a b : ℤ}
      (witness : Schedule P T)
      (preparation : Reorders σ witness a b)
      (description : GlobalDescription P (Inside σ a b))
      (gaps : List (Geometry witness))
      (tiling : Tiling a b gaps)
      (has_mark : ∃ g ∈ gaps, g.d < b)
      (marks : ∀ g ∈ gaps, g.d < b →
        ∃ Z : Finset Job, g.right = .actual Z ∧
          ∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧
            ∀ x ∈ Inside σ a b,
              x ∈ F.denote P ↔ witness.time x < g.d)
      (children : (i : NonemptyGapIndex gaps) →
        BoundedHierarchy P T witness (gaps.get i.val).c (gaps.get i.val).d) :
      BoundedHierarchy P T σ a b

theorem oriented_initial_domain {P : Precedence Job} {T : ℕ} {N : RawNode Job T}
    (o : Orientation N.frame P) :
    Inside (o.schedule N.schedule) (o.left (T := T) N.a N.b)
      (o.right (T := T) N.a N.b) = N.domain :=
  o.domain N.schedule N.a N.b

theorem bounded_hierarchy_exists {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (o : Orientation N.frame P) :
    Nonempty (BoundedHierarchy P T (o.schedule N.schedule)
      (o.left (T := T) N.a N.b) (o.right (T := T) N.a N.b)) := by
  classical
  have aux : ∀ n : ℕ, ∀ N : RawNode Job T, RootedHistory P σ N →
      jobCount N.domain = n → ∀ o : Orientation N.frame P,
      Nonempty (BoundedHierarchy P T (o.schedule N.schedule)
        (o.left (T := T) N.a N.b) (o.right (T := T) N.a N.b)) := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro node past hcount orient
        obtain ⟨F, hallowed, hsmall, hexact⟩ := past.original_global_description
        let desc : GlobalDescription P
            (Inside (orient.schedule node.schedule)
              (orient.left (T := T) node.a node.b) (orient.right (T := T) node.a node.b)) :=
          ⟨F, hallowed, hsmall, hexact.trans (oriented_initial_domain orient).symm⟩
        by_cases hne : node.domain.Nonempty
        · obtain ⟨prep⟩ := node_preparation_exists past hne
          obtain ⟨batch⟩ := batch_exists past prep
          let gs := orient.gaps batch.gaps
          have children_exist : ∀ i : NonemptyGapIndex gs,
              Nonempty (BoundedHierarchy P T (orient.schedule prep.schedule)
                (gs.get i.val).c (gs.get i.val).d) := by
            intro i
            have hm : gs.get i.val ∈ orient.gaps batch.gaps := List.get_mem _ _
            obtain ⟨edge, hrooted, hlt, hs, hc, hd⟩ :=
              batch.original_child orient (gs.get i.val) hm i.property
            have hchild := ih _ (by omega) edge.child hrooted rfl (orient.child edge)
            simpa only [hs, hc, hd] using hchild
          let children := fun i : NonemptyGapIndex gs => Classical.choice (children_exist i)
          refine ⟨.branch (orient.schedule prep.schedule) (orient.reorders prep.preparation)
            desc gs (orient.tiling batch.tiling) (batch.original_nonempty_marks orient)
            ?_ children⟩
          intro g hg hgInternal
          obtain ⟨Z, hZ, H, hHallowed, hHsmall, hEarlier⟩ :=
            batch.original_marks orient g hg hgInternal
          refine ⟨Z, hZ, H, hHallowed, hHsmall, ?_⟩
          intro x hx
          exact hEarlier x ((Set.ext_iff.mp (oriented_initial_domain orient)) x |>.mp hx)
        · refine ⟨.empty ?_ desc⟩
          rw [oriented_initial_domain orient]
          exact Set.not_nonempty_iff_eq_empty.mp hne
  exact aux _ N history rfl o

theorem thm_structure (P : Precedence Job) {T : ℕ} (σ : Schedule P T) :
    Nonempty (BoundedHierarchy P T σ 0 ((T : ℤ) + 1)) := by
  have h := bounded_hierarchy_exists (RootedHistory.root (P := P) (σ := σ))
    (Orientation.direct (frame_same_refl P))
  have hs : (Orientation.direct (frame_same_refl P)).schedule σ = σ :=
    schedule_ext rfl
  simpa only [rawRoot, Orientation.left, Orientation.right, hs] using h

noncomputable def BoundedHierarchy.nodeCount {P : Precedence Job} {T : ℕ} :
    {σ : Schedule P T} → {a b : ℤ} → BoundedHierarchy P T σ a b → ℕ
  | _, _, _, .empty _ _ => 1
  | _, _, _, .branch _ _ _ gaps _ _ _ children =>
      letI : Fintype (NonemptyGapIndex gaps) := Fintype.ofFinite _
      1 + ∑ i : NonemptyGapIndex gaps, (children i).nodeCount

theorem BoundedHierarchy.nodeCount_positive {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {a b : ℤ} (tree : BoundedHierarchy P T σ a b) :
    0 < tree.nodeCount := by
  cases tree with
  | empty => exact Nat.zero_lt_one
  | branch =>
      dsimp only [BoundedHierarchy.nodeCount]
      omega

theorem literal_protocol_extraction {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (hne : N.domain.Nonempty) :
    ∃ (prep : NodePreparation N) (batch : Batch history prep),
      batch.same_run.jobs.Nodup ∧ batch.switched_run.jobs.Nodup ∧
      (∀ g ∈ batch.gaps,
        (Inside prep.schedule g.c g.d).Nonempty →
          ∃ edge : RawGap N, edge.Realizes prep g ∧
            RootedHistory P σ edge.child ∧
            jobCount edge.child.domain < jobCount N.domain) ∧
      (∀ o : Orientation N.frame P,
        Tiling (o.left (T := T) N.a N.b) (o.right (T := T) N.a N.b)
          (o.gaps batch.gaps) ∧
        Nonempty (BoundedHierarchy P T (o.schedule N.schedule)
          (o.left (T := T) N.a N.b) (o.right (T := T) N.a N.b))) := by
  obtain ⟨prep⟩ := node_preparation_exists history hne
  obtain ⟨batch⟩ := batch_exists history prep
  refine ⟨prep, batch, batch.all_same_promotions.1, batch.all_switched_promotions.1,
    ?_, fun o => ⟨o.tiling batch.tiling, bounded_hierarchy_exists history o⟩⟩
  intro g hg hgap
  obtain ⟨edge, hr⟩ := batch.every_gap_realized g hg hgap
  exact ⟨edge, hr, edge.rooted history, batch.every_child_smaller hg hr⟩

theorem literal_history_preservation {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {N : RawNode Job T} (history : RootedHistory P σ N) :
    Derived N ∧ Language N ∧ N.list.length ≤ 5 ∧
      (injections N.list).length ≤ 3 ∧
      (∀ τ : Schedule N.frame T, Reorders N.schedule τ N.a N.b →
        LocalI1 N.data (Inside τ N.a N.b) N.list N.left N.right ∧
          I2 τ N.left N.a N.qualifiers ∧ I3 τ N.left N.a N.b N.qualifiers N.key) ∧
      (∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧
        F.denote P = N.domain) ∧
      (∀ (prep : NodePreparation N) (batch : Batch history prep)
        (o : Orientation N.frame P) (g : Geometry (o.schedule prep.schedule)),
        g ∈ o.gaps batch.gaps → g.d < o.right (T := T) N.a N.b →
          ∃ Z : Finset Job, g.right = .actual Z ∧
            ∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧
              ∀ x ∈ N.domain,
                x ∈ F.denote P ↔ (o.schedule prep.schedule).time x < g.d) := by
  exact ⟨history.raw.derived, history.raw.language, history.raw.derived.five,
    history.raw.injection_bound, history.raw.future_invariants,
    history.original_global_description,
    fun _ batch o g hg hi => batch.original_marks o g hg hi⟩

end LiteralHierarchy
