set_option autoImplicit false
set_option maxHeartbeats 1500000
set_option linter.unusedSectionVars false

namespace LiteralProtocol

open TemporalBoundary LiteralConstruction SameFrameHistory
open scoped Classical

variable {Job : Type*} [Fintype Job] [DecidableEq Job]

theorem schedule_ext {P : Precedence Job} {T : ℕ} {σ τ : Schedule P T}
    (h : σ.time = τ.time) : σ = τ := by
  cases σ
  cases τ
  cases h
  rfl

theorem finite_schedules (P : Precedence Job) (T : ℕ) : Finite (Schedule P T) := by
  let code : Schedule P T → Job → Fin (T + 1) :=
    fun σ x => ⟨(σ.time x).toNat, by have := σ.complete.range x; omega⟩
  apply Finite.of_injective code
  intro σ τ h
  apply schedule_ext
  funext x
  have he := congrArg (fun f => (f x).val) h
  dsimp [code] at he
  have hs := σ.complete.range x
  have ht := τ.complete.range x
  omega

theorem normalized_exists {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a b : ℤ) :
    ∃ τ : Schedule P T, Reorders σ τ a b ∧ Normalized τ π a b := by
  classical
  letI : Finite (Schedule P T) := finite_schedules P T
  letI : Fintype (Schedule P T) := Fintype.ofFinite _
  let choices := Finset.univ.filter (fun τ : Schedule P T => Reorders σ τ a b)
  have hσ : σ ∈ choices := by simp [choices, reorders_refl]
  obtain ⟨τ, hτ, hm⟩ :=
    Finset.exists_min_image choices (fun τ => word τ π a b) ⟨σ, hσ⟩
  have hr : Reorders σ τ a b := (Finset.mem_filter.mp hτ).2
  refine ⟨τ, hr, ?_⟩
  intro υ hυ hlex
  have hmin := hm υ (by simp [choices, reorders_trans hr hυ])
  exact (not_lt_of_ge hmin) ((List.lt_iff_lex_lt _ _).mpr hlex)

noncomputable def keyIndex {α : Type*} [LinearOrder α]
    (k : Job → α) (x : Job) : ℕ :=
  (Finset.univ.filter (fun y => k y < k x)).card

theorem keyIndex_strict {α : Type*} [LinearOrder α]
    (k : Job → α) {x y : Job} (h : k x < k y) :
    keyIndex k x < keyIndex k y := by
  classical
  apply Finset.card_lt_card
  rw [Finset.ssubset_iff_subset_ne]
  refine ⟨?_, ?_⟩
  · intro z hz
    simpa only [Finset.mem_filter, Finset.mem_univ, true_and] using
      lt_trans ((Finset.mem_filter.mp hz).2) h
  · intro heq
    have hx : x ∈ Finset.univ.filter (fun z => k z < k y) := by simp [h]
    rw [← heq] at hx
    simp at hx

theorem keyIndex_order {α : Type*} [LinearOrder α]
    (k : Job → α) {x y : Job} :
    keyIndex k x < keyIndex k y ↔ k x < k y := by
  constructor
  · intro h
    rcases lt_trichotomy (k x) (k y) with hlt | heq | hgt
    · exact hlt
    · have he : keyIndex k x = keyIndex k y := by simp only [keyIndex, heq]
      omega
    · have := keyIndex_strict k hgt
      omega
  · exact keyIndex_strict k

noncomputable def priorityFromKey {α : Type*} [LinearOrder α]
    (P : Precedence Job) (k : Job → α) (hinj : Function.Injective k)
    (hrel : ∀ ⦃x y⦄, P.rel x y → k x < k y) : Priority P where
  index := keyIndex k
  injective := by
    intro x y heq
    apply hinj
    apply le_antisymm
    · by_contra hn
      have := keyIndex_strict k (lt_of_not_ge hn)
      omega
    · by_contra hn
      have := keyIndex_strict k (lt_of_not_ge hn)
      omega
  respects := fun h => keyIndex_strict k (hrel h)

def location {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (x : Job) : ℕ :=
  if σ.time x ≤ a then 0 else if σ.time x < b then 1 else 2

theorem location_middle {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (x : Job) : location σ a b x = 1 ↔ x ∈ Inside σ a b := by
  by_cases ha : σ.time x ≤ a
  · simp [location, ha, Inside, not_lt_of_ge ha]
  · by_cases hb : σ.time x < b
    · simp [location, ha, hb, Inside, lt_of_not_ge ha]
    · simp [location, ha, hb, Inside]

theorem location_mono {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) {x y : Job} (h : P.rel x y) :
    location σ a b x ≤ location σ a b y := by
  have := σ.feasible h
  simp only [location]
  split_ifs <;> omega

noncomputable def extensionKey {α : Type*} [LinearOrder α]
    {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (k : Job → α) (x : Job) : ℕ ×ₗ (ℕ ×ₗ α) :=
  toLex (location σ a b x,
    toLex (if location σ a b x = 1 then 0 else P.rank x, k x))

theorem extensionKey_injective {α : Type*} [LinearOrder α]
    {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (k : Job → α)
    (hinj : ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b, k x = k y → x = y) :
    Function.Injective (extensionKey σ a b k) := by
  intro x y heq
  have hl : location σ a b x = location σ a b y :=
    congrArg (fun z => (ofLex z).1) heq
  have hk : k x = k y :=
    congrArg (fun z => (ofLex (ofLex z).2).2) heq
  by_cases hx : location σ a b x = 1
  · exact hinj x ((location_middle σ a b x).mp hx)
      y ((location_middle σ a b y).mp (hl.symm.trans hx)) hk
  · have hy : location σ a b y ≠ 1 := by omega
    have hr := congrArg (fun z => (ofLex (ofLex z).2).1) heq
    simp only [extensionKey, ofLex_toLex, if_neg hx, if_neg hy] at hr
    exact P.rank_injective hr

theorem extensionKey_respects {α : Type*} [LinearOrder α]
    {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (k : Job → α)
    (hrel : ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b, P.rel x y → k x < k y)
    {x y : Job} (hxy : P.rel x y) :
    extensionKey σ a b k x < extensionKey σ a b k y := by
  have hm := location_mono σ a b hxy
  rw [extensionKey, extensionKey, Prod.Lex.toLex_lt_toLex]
  rcases hm.lt_or_eq with hlt | heq
  · exact Or.inl hlt
  · refine Or.inr ⟨heq, ?_⟩
    by_cases hx : location σ a b x = 1
    · have hy : location σ a b y = 1 := heq.symm.trans hx
      simp only [if_pos hx, if_pos hy, Prod.Lex.toLex_lt_toLex, lt_self_iff_false,
        true_and, false_or]
      exact hrel x ((location_middle σ a b x).mp hx)
        y ((location_middle σ a b y).mp hy) hxy
    · have hy : location σ a b y ≠ 1 := by omega
      simp only [if_neg hx, if_neg hy, Prod.Lex.toLex_lt_toLex]
      exact Or.inl (P.rank_strict hxy)

theorem interval_priority_extension {α : Type*} [LinearOrder α]
    {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (k : Job → α)
    (hinj : ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b, k x = k y → x = y)
    (hrel : ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b, P.rel x y → k x < k y) :
    ∃ π : Priority P, ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b,
      π.index x < π.index y ↔ k x < k y := by
  let π := priorityFromKey P (extensionKey σ a b k)
    (extensionKey_injective σ a b k hinj)
    (fun {_ _} h => extensionKey_respects σ a b k hrel h)
  refine ⟨π, ?_⟩
  intro x hx y hy
  have hxl := (location_middle σ a b x).mpr hx
  have hyl := (location_middle σ a b y).mpr hy
  change keyIndex (extensionKey σ a b k) x < keyIndex (extensionKey σ a b k) y ↔ _
  rw [keyIndex_order]
  simp [extensionKey, hxl, hyl, Prod.Lex.toLex_lt_toLex]

noncomputable def sameOrderKey
    (C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job))
    (L : List (Entry (TemporalBoundary.Boundary Job)))
    (b : TemporalBoundary.Boundary Job) (x : Job) : ℕ ×ₗ (ℕ ×ₗ ℕ) :=
  toLex (sameGroup C L b x,
    if sameGroup C L b x = 1 then lexKey C L x else toLex (0, C.rank x))

theorem sameOrderKey_order
    (C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job))
    (L : List (Entry (TemporalBoundary.Boundary Job)))
    (b : TemporalBoundary.Boundary Job) (x y : Job) :
    sameOrderKey C L b x < sameOrderKey C L b y ↔ samePriority C L b x y := by
  simp only [sameOrderKey, samePriority, Prod.Lex.toLex_lt_toLex]
  by_cases hg : sameGroup C L b x = sameGroup C L b y
  · rw [← hg]
    split_ifs <;> simp [Prod.Lex.toLex_lt_toLex]
  · simp [hg]

theorem sameOrderKey_injective {P : Precedence Job}
    (a₀ : TemporalBoundary.Boundary Job) (Q G : Set Job)
    (L : List (Entry (TemporalBoundary.Boundary Job)))
    (b : TemporalBoundary.Boundary Job) :
    Function.Injective (sameOrderKey (frameData P a₀ Q G) L b) := by
  intro x y heq
  apply P.rank_injective
  have hg := congrArg (fun z => (ofLex z).1) heq
  have hr := congrArg (fun z => (ofLex (ofLex z).2).2) heq
  dsimp only [sameOrderKey] at hg hr
  simp only [ofLex_toLex] at hg hr
  by_cases hx : sameGroup (frameData P a₀ Q G) L b x = 1
  · have hy : sameGroup (frameData P a₀ Q G) L b y = 1 := hg.symm.trans hx
    simp only [if_pos hx, if_pos hy] at hr
    exact hr
  · have hy : sameGroup (frameData P a₀ Q G) L b y ≠ 1 := fun h => hx (hg.trans h)
    simp only [if_neg hx, if_neg hy] at hr
    exact hr

theorem samePriority_respects {P : Precedence Job}
    {a₀ a b : TemporalBoundary.Boundary Job} {Q G U : Set Job}
    {L : List (Entry (TemporalBoundary.Boundary Job))}
    (hI1 : LocalI1 (frameData P a₀ Q G) U L a b)
    (hup : ∀ e ∈ L, TemporalBoundary.IsUp P (e.denote (frameData P a₀ Q G)))
    {x y : Job} (_hx : x ∈ U) (hy : y ∈ U) (hxy : P.rel x y) :
    samePriority (frameData P a₀ Q G) L b x y := by
  let C := frameData P a₀ Q G
  have hQ : x ∈ Qual C L → y ∈ Qual C L := by
    rintro ⟨e, he, hxe⟩
    exact ⟨e, he, hup e he hxy hxe⟩
  have hP : y ∈ C.P b → x ∈ C.P b := pred_down P b hxy
  have hQy : y ∈ Qual C L → y ∈ C.P b := fun h => hI1.old_high ⟨hy, h⟩
  have hr : C.rank x < C.rank y := P.rank_strict hxy
  have hk : lexKey C L x < lexKey C L y :=
    lex_key_precedence C P.rel L hup (fun {_ _} h => P.rank_strict h) hxy
  change samePriority C L b x y
  by_cases hxQ : x ∈ Qual C L
  · have hyQ := hQ hxQ
    simp [samePriority, sameGroup, hxQ, hyQ, hk]
  · by_cases hyQ : y ∈ Qual C L
    · have hxP := hP (hQy hyQ)
      simp [samePriority, sameGroup, hxQ, hyQ, hxP]
    · by_cases hxP : x ∈ C.P b
      · by_cases hyP : y ∈ C.P b <;>
          simp [samePriority, sameGroup, hxQ, hyQ, hxP, hyP, hr]
      · have hyP : y ∉ C.P b := fun h => hxP (hP h)
        simp [samePriority, sameGroup, hxQ, hyQ, hxP, hyP, hr]

theorem raw_same_priority_exists {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (σ : Schedule N.frame T)
    (hprep : Reorders N.schedule σ N.a N.b) :
    ∃ π : Priority N.frame, ∀ x ∈ Inside σ N.a N.b, ∀ y ∈ Inside σ N.a N.b,
      π.index x < π.index y ↔ samePriority N.data N.list N.right x y := by
  have h := history.derived
  have hI1 := (history.future_invariants σ hprep).1
  obtain ⟨π, hπ⟩ := interval_priority_extension σ N.a N.b
    (sameOrderKey N.data N.list N.right)
    (fun _ _ _ _ he => sameOrderKey_injective _ _ _ _ _ he)
    (fun _ hx _ hy hxy => (sameOrderKey_order _ _ _ _ _).mpr
      (samePriority_respects hI1
        (fun e _ => entry_up (frame_laws _ _ _ _) h.origin_up e) hx hy hxy))
  exact ⟨π, fun x hx y hy => (hπ x hx y hy).trans (sameOrderKey_order _ _ _ _ _)⟩

noncomputable def switchOrderKey (P : Precedence Job)
    (A : TemporalBoundary.Boundary Job) (x : Job) : ℕ ×ₗ ℕ :=
  toLex (if x ∈ D P A then 1 else 0, P.rank x)

theorem switchOrderKey_order (P : Precedence Job)
    (A : TemporalBoundary.Boundary Job) (x y : Job) :
    switchOrderKey P A x < switchOrderKey P A y ↔ switchPriority P A x y := by
  by_cases hx : x ∈ D P A <;> by_cases hy : y ∈ D P A <;>
    simp [switchOrderKey, switchPriority, hx, hy, Prod.Lex.toLex_lt_toLex]

theorem switch_priority_exists (P : Precedence Job) (A : TemporalBoundary.Boundary Job) :
    ∃ π : Priority P, ∀ x y, π.index x < π.index y ↔ switchPriority P A x y := by
  have hinj : Function.Injective (switchOrderKey P A) := by
    intro x y he
    exact P.rank_injective (congrArg (fun z => (ofLex z).2) he)
  have hrel : ∀ ⦃x y⦄, P.rel x y → switchOrderKey P A x < switchOrderKey P A y := by
    intro x y hxy
    have hD := D_up P A hxy
    have hr := P.rank_strict hxy
    by_cases hx : x ∈ D P A
    · have hy := hD hx
      simp [switchOrderKey, hx, hy, Prod.Lex.toLex_lt_toLex, hr]
    · by_cases hy : y ∈ D P A <;>
        simp [switchOrderKey, hx, hy, Prod.Lex.toLex_lt_toLex, hr]
  let π := priorityFromKey P (switchOrderKey P A) hinj hrel
  exact ⟨π, fun x y => (keyIndex_order (switchOrderKey P A)).trans
    (switchOrderKey_order P A x y)⟩

theorem slot_placed {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    {t : ℤ} (ht : 1 ≤ t) (hT : t ≤ T) :
    Placed σ (.actual (slotJobs σ t)) t := by
  classical
  refine ⟨?_, fun x => by simp [slotJobs]⟩
  have h := σ.complete.triple t ht hT
  simpa [Nat.card_eq_fintype_card, Fintype.card_subtype, slotJobs] using h

def EarlierHigh {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a v : ℤ) (L : Set Job) (B : TemporalBoundary.Boundary Job) (s : ℤ) : Prop :=
  ∀ x ∈ Inside σ a v, x ∉ L → σ.time x < s → x ∈ Pred P B

theorem advance_preserves_earlier {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v s t : ℤ}
    {L : Set Job} {B : TemporalBoundary.Boundary Job} {target : Finset Job}
    (hn : Normalized σ π a v) (hL : LowPrefix σ π a v L) (has : a ≤ s)
    (step : EarliestAdvance σ a v L B s target t)
    (before : EarlierHigh σ a v L B s) :
    EarlierHigh σ a v L (.actual target) t := by
  obtain ⟨x, hxt, hxL, hxD⟩ := step.exception
  have hst := step.increasing
  have htv := step.target_in_side.2
  have hx : x ∈ Inside σ a v := by
    simpa [Inside, hxt] using step.target_in_side
  have hready := earliest_exception_ready hL step has hxt hxL hxD
  let C : Set Job := Inside σ a v \ L
  have htrace : ∀ q ∈ C, s ≤ σ.time q → σ.time q ≤ t →
      ∃ z, z ∈ C ∧ σ.time z = t ∧ Reach P q z := by
    apply trace_strict_successors
    intro q hq hsq hqt
    have hno : ¬ ExchangeFeasible σ x q :=
      lex_prefix_no_exchange hn (reorders_refl σ a v) (fun _ _ => rfl)
        hx rfl hq.1.1 (by omega) (hL x hx hxL q hq.1 hq.2)
    obtain ⟨z, hqz, hzt⟩ := successor_forced_by_no_exchange
      (by omega : σ.time q < σ.time x)
      (fun u hux => lt_of_lt_of_le (hready u hux) hsq) hno
    rw [hxt] at hzt
    have hqzt := σ.feasible hqz
    have hz : z ∈ Inside σ a v :=
      ⟨hq.1.1.trans hqzt, hzt.trans_lt step.target_in_side.2⟩
    have hzL : z ∉ L := fun h =>
      hq.2 (lowPrefix_ideal hL hq.1 hz hqz h)
    exact ⟨z, ⟨hz, hzL⟩, hqz, hzt⟩
  intro y hy hyL hyt
  have end_of_trace : ∀ q ∈ C, s ≤ σ.time q → σ.time q < t →
      Reach P y q → y ∈ Pred P (.actual target) := by
    intro q hq hsq hqt hyq
    obtain ⟨z, hz, hzt, hqz⟩ := htrace q hq hsq hqt.le
    have hyz := reach_trans hyq hqz
    have hyz' : P.rel y z := by
      rcases hyz with rfl | h
      · omega
      · exact h
    exact ⟨z, time_mem_boundary step.target_slot hzt, hyz'⟩
  by_cases hys : σ.time y < s
  · have hyB := before y hy hyL hys
    cases B with
    | left => exact False.elim hyB
    | right =>
        have hs : s = (T : ℤ) + 1 := step.source
        have hxT := (σ.complete.range x).2
        omega
    | actual F =>
        obtain ⟨q, hq, hyq⟩ := hyB
        have hqs := boundary_jobs_time step.source hq
        have hqtime := σ.feasible hyq
        have hqE : q ∈ Inside σ a v :=
          ⟨hy.1.trans hqtime, by omega⟩
        have hqL : q ∉ L := fun h => hyL (lowPrefix_ideal hL hy hqE hyq h)
        exact end_of_trace q ⟨hqE, hqL⟩ (by omega) (by omega) (Or.inr hyq)
  · exact end_of_trace y ⟨hy, hyL⟩ (by omega) hyt (Or.inl rfl)

theorem earliest_advance_exists {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {a v s : ℤ} {L : Set Job}
    {B : TemporalBoundary.Boundary Job} (hB : Placed σ B s)
    (hex : ∃ x ∈ Inside σ a v, x ∈ L ∧ s < σ.time x ∧ x ∉ D P B) :
    ∃ target t, EarliestAdvance σ a v L B s target t := by
  classical
  let choices := Finset.univ.filter
    (fun x => x ∈ Inside σ a v ∧ x ∈ L ∧ s < σ.time x ∧ x ∉ D P B)
  obtain ⟨x₀, hx₀, hxL₀, hs₀, hxD₀⟩ := hex
  have hc : choices.Nonempty := ⟨x₀, by simp [choices, hx₀, hxL₀, hs₀, hxD₀]⟩
  obtain ⟨x, hx, hmin⟩ := Finset.exists_min_image choices σ.time hc
  have hx' := (Finset.mem_filter.mp hx).2
  refine ⟨slotJobs σ (σ.time x), σ.time x, ?_⟩
  refine ⟨hB, slot_placed σ (σ.complete.range x).1 (σ.complete.range x).2,
    hx'.2.2.1, hx'.1, ⟨x, rfl, hx'.2.1, hx'.2.2.2⟩, ?_⟩
  intro u hu huL hsu hut
  by_contra huD
  have hum : u ∈ choices := by simp [choices, hu, huL, hsu, huD]
  have := hmin u hum
  omega

theorem walk_mono {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v s : ℤ}
    {S F : Set Job} {A B : TemporalBoundary.Boundary Job}
    (h : ExceptionWalk σ π a v S A B s)
    (hSF : ∀ x ∈ Inside σ a v, x ∈ S → x ∈ F) :
    ExceptionWalk σ π a v F A B s := by
  induction h with
  | start hA => exact .start hA
  | advance past L hL hLS step ih =>
      exact .advance ih L hL (fun x hx hxl => hSF x hx (hLS x hx hxl)) step

theorem finish_separator {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v : ℤ} {L : Set Job}
    (hn : Normalized σ π a v) (hL : LowPrefix σ π a v L) :
    ∀ (B : TemporalBoundary.Boundary Job) (s : ℤ), Placed σ B s → a ≤ s → s < v →
      EarlierHigh σ a v L B s →
      ∃ (C : TemporalBoundary.Boundary Job) (t : ℤ),
        s ≤ t ∧ t < v ∧ Placed σ C t ∧
        (C = B ∨ ∃ F, C = .actual F) ∧ Separator σ (Inside σ a v) L C t ∧
        (∀ (F : Set Job) (A : TemporalBoundary.Boundary Job),
          (∀ x ∈ Inside σ a v, x ∈ L → x ∈ F) →
          ExceptionWalk σ π a v F A B s → ExceptionWalk σ π a v F A C t) := by
  have aux : ∀ n : ℕ, ∀ (B : TemporalBoundary.Boundary Job) (s : ℤ),
      (v - s).toNat = n → Placed σ B s → a ≤ s → s < v →
      EarlierHigh σ a v L B s →
      ∃ (C : TemporalBoundary.Boundary Job) (t : ℤ),
        s ≤ t ∧ t < v ∧ Placed σ C t ∧
        (C = B ∨ ∃ F, C = .actual F) ∧ Separator σ (Inside σ a v) L C t ∧
        (∀ (F : Set Job) (A : TemporalBoundary.Boundary Job),
          (∀ x ∈ Inside σ a v, x ∈ L → x ∈ F) →
          ExceptionWalk σ π a v F A B s → ExceptionWalk σ π a v F A C t) := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro B s he hB has hsv before
        classical
        by_cases hex : ∃ x ∈ Inside σ a v, x ∈ L ∧ s < σ.time x ∧ x ∉ D P B
        · obtain ⟨target, t, step⟩ := earliest_advance_exists hB hex
          have hsmall : (v - t).toNat < n := by
            have := step.increasing
            have := step.target_in_side
            omega
          obtain ⟨C, u, htu, huv, hC, hactual, hsep, hwalk⟩ :=
            ih _ hsmall (.actual target) t rfl step.target_slot
              (by have := step.increasing; omega) step.target_in_side.2
              (advance_preserves_earlier hn hL has step before)
          refine ⟨C, u, step.increasing.le.trans htu, huv, hC, ?_, hsep, ?_⟩
          · rcases hactual with h | h
            · exact Or.inr ⟨target, h⟩
            · exact Or.inr h
          · intro F A hLF past
            exact hwalk F A hLF (.advance past L hL hLF step)
        · refine ⟨B, s, le_rfl, hsv, hB, Or.inl rfl, ⟨before, ?_⟩, ?_⟩
          · intro x hx hxL hsx
            by_contra hxD
            exact hex ⟨x, hx, hxL, hsx, hxD⟩
          · intro _ _ _ past
            exact past
  intro B s hB has hsv before
  exact aux _ B s rfl hB has hsv before

theorem actual_separator_of_lowPrefix {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a b : ℤ} {L : Set Job}
    (hn : Normalized σ π a b) (hL : LowPrefix σ π a b L)
    (hne : (Inside σ a b).Nonempty) :
    ∃ (F : Finset Job) (t : ℤ), a < t ∧ t < b ∧
      Placed σ (.actual F) t ∧ Separator σ (Inside σ a b) L (.actual F) t := by
  classical
  let choices := Finset.univ.filter (fun x => x ∈ Inside σ a b)
  obtain ⟨x₀, hx₀⟩ := hne
  have hc : choices.Nonempty := ⟨x₀, by simp [choices, hx₀]⟩
  obtain ⟨x, hx, hmin⟩ := Finset.exists_min_image choices σ.time hc
  have hxE := (Finset.mem_filter.mp hx).2
  have first : EarlierHigh σ a b L (.actual (slotJobs σ (σ.time x))) (σ.time x) := by
    intro y hy _ hyt
    have hym : y ∈ choices := by simp [choices, hy]
    have := hmin y hym
    omega
  obtain ⟨C, t, hxt, htb, hC, hactual, hsep, _⟩ :=
    finish_separator hn hL (.actual (slotJobs σ (σ.time x))) (σ.time x)
      (slot_placed σ (σ.complete.range x).1 (σ.complete.range x).2)
      hxE.1.le hxE.2 first
  have hat := hxE.1.trans_le hxt
  rcases hactual with rfl | ⟨F, rfl⟩
  · exact ⟨_, t, hat, htb, hC, hsep⟩
  · exact ⟨F, t, hat, htb, hC, hsep⟩

def DomainIdeal {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) (I : Set Job) : Prop :=
  ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b, P.rel x y → y ∈ I → x ∈ I

theorem ideal_priority_exists {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) (I : Set Job)
    (hI : DomainIdeal σ a b I) :
    ∃ π : Priority P, LowPrefix σ π a b I := by
  classical
  let k : Job → ℕ ×ₗ ℕ := fun x => toLex (if x ∈ I then 0 else 1, P.rank x)
  have hinj : Function.Injective k := by
    intro x y he
    exact P.rank_injective (congrArg (fun z => (ofLex z).2) he)
  have hrel : ∀ x ∈ Inside σ a b, ∀ y ∈ Inside σ a b,
      P.rel x y → k x < k y := by
    intro x hx y hy hxy
    have hr := P.rank_strict hxy
    by_cases hxI : x ∈ I
    · by_cases hyI : y ∈ I <;> simp [k, hxI, hyI, Prod.Lex.toLex_lt_toLex, hr]
    · have hyI : y ∉ I := fun h => hxI (hI x hx y hy hxy h)
      simp [k, hxI, hyI, Prod.Lex.toLex_lt_toLex, hr]
  obtain ⟨π, hπ⟩ := interval_priority_extension σ a b k (fun _ _ _ _ he => hinj he) hrel
  refine ⟨π, ?_⟩
  intro x hx hxI y hy hyI
  exact (hπ x hx y hy).mpr (by simp [k, hxI, hyI, Prod.Lex.toLex_lt_toLex])

theorem ideal_center_exists {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) (I : Set Job)
    (hI : DomainIdeal σ a b I) (hne : (Inside σ a b).Nonempty) :
    ∃ (τ : Schedule P T) (π : Priority P) (F : Finset Job) (v : ℤ),
      Reorders σ τ a b ∧ Normalized τ π a b ∧ LowPrefix τ π a b I ∧
      a < v ∧ v < b ∧ Placed τ (.actual F) v ∧
      Separator τ (Inside τ a b) I (.actual F) v := by
  obtain ⟨π, hπ⟩ := ideal_priority_exists σ a b I hI
  obtain ⟨τ, hr, hn⟩ := normalized_exists σ π a b
  have hL : LowPrefix τ π a b I := fun x hx hxI y hy hyI =>
    hπ x ((hr.1 x).mpr hx) hxI y ((hr.1 y).mpr hy) hyI
  have hne' : (Inside τ a b).Nonempty := by
    obtain ⟨x, hx⟩ := hne
    exact ⟨x, (hr.1 x).mp hx⟩
  obtain ⟨F, v, hav, hvb, hF, hsep⟩ := actual_separator_of_lowPrefix hn hL hne'
  exact ⟨τ, π, F, v, hr, hn, hL, hav, hvb, hF, hsep⟩

theorem finish_two_prefixes {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v : ℤ} {K L : Set Job}
    (hn : Normalized σ π a v) (hL : LowPrefix σ π a v L)
    (hK : LowPrefix σ π a v K)
    (hKL : ∀ x ∈ Inside σ a v, x ∈ K → x ∈ L) :
    ∀ (B : TemporalBoundary.Boundary Job) (s : ℤ), Placed σ B s → a ≤ s → s < v →
      EarlierHigh σ a v L B s → EarlierHigh σ a v K B s →
      (∀ x ∈ Inside σ a v, x ∈ L → x ∉ K → σ.time x ≤ s) →
      ∃ (C : TemporalBoundary.Boundary Job) (t : ℤ),
        s ≤ t ∧ t < v ∧ Placed σ C t ∧
        Separator σ (Inside σ a v) K C t ∧ Separator σ (Inside σ a v) L C t ∧
        (∀ (F : Set Job) (A : TemporalBoundary.Boundary Job),
          (∀ x ∈ Inside σ a v, x ∈ L → x ∈ F) →
          ExceptionWalk σ π a v F A B s → ExceptionWalk σ π a v F A C t) := by
  have aux : ∀ n : ℕ, ∀ (B : TemporalBoundary.Boundary Job) (s : ℤ),
      (v - s).toNat = n → Placed σ B s → a ≤ s → s < v →
      EarlierHigh σ a v L B s → EarlierHigh σ a v K B s →
      (∀ x ∈ Inside σ a v, x ∈ L → x ∉ K → σ.time x ≤ s) →
      ∃ (C : TemporalBoundary.Boundary Job) (t : ℤ),
        s ≤ t ∧ t < v ∧ Placed σ C t ∧
        Separator σ (Inside σ a v) K C t ∧ Separator σ (Inside σ a v) L C t ∧
        (∀ (F : Set Job) (A : TemporalBoundary.Boundary Job),
          (∀ x ∈ Inside σ a v, x ∈ L → x ∈ F) →
          ExceptionWalk σ π a v F A B s → ExceptionWalk σ π a v F A C t) := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro B s he hB has hsv beforeL beforeK pastAdded
        classical
        by_cases hex : ∃ x ∈ Inside σ a v, x ∈ L ∧ s < σ.time x ∧ x ∉ D P B
        · obtain ⟨target, t, step⟩ := earliest_advance_exists hB hex
          obtain ⟨x, hxt, hxL, hxD⟩ := step.exception
          have hxE : x ∈ Inside σ a v := by
            simpa [Inside, hxt] using step.target_in_side
          have hxK : x ∈ K := by
            by_contra hxK
            have := pastAdded x hxE hxL hxK
            have := step.increasing
            omega
          have oldStep : EarliestAdvance σ a v K B s target t :=
            ⟨step.source, step.target_slot, step.increasing, step.target_in_side,
              ⟨x, hxt, hxK, hxD⟩,
              fun u hu huK hsu hut => step.earliest u hu (hKL u hu huK) hsu hut⟩
          have hsmall : (v - t).toNat < n := by
            have := step.increasing
            have := step.target_in_side
            omega
          obtain ⟨C, u, htu, huv, hC, hsepK, hsepL, hwalk⟩ :=
            ih _ hsmall (.actual target) t rfl step.target_slot
              (by have := step.increasing; omega) step.target_in_side.2
              (advance_preserves_earlier hn hL has step beforeL)
              (advance_preserves_earlier hn hK has oldStep beforeK)
              (fun z hz hzL hzK => (pastAdded z hz hzL hzK).trans step.increasing.le)
          refine ⟨C, u, step.increasing.le.trans htu, huv, hC, hsepK, hsepL, ?_⟩
          intro F A hLF past
          exact hwalk F A hLF (.advance past L hL hLF step)
        · have later : ∀ x ∈ Inside σ a v, x ∈ L → s < σ.time x → x ∈ D P B := by
            intro x hx hxL hsx
            by_contra hxD
            exact hex ⟨x, hx, hxL, hsx, hxD⟩
          exact ⟨B, s, le_rfl, hsv, hB,
            ⟨beforeK, fun x hx hxK hsx => later x hx (hKL x hx hxK) hsx⟩,
            ⟨beforeL, later⟩, fun _ _ _ past => past⟩
  intro B s hB has hsv beforeL beforeK pastAdded
  exact aux _ B s rfl hB has hsv beforeL beforeK pastAdded

theorem shared_cutoff_walk {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v s : ℤ} {S L : Set Job}
    {A B : TemporalBoundary.Boundary Job} (p : Job)
    (hn : Normalized σ π a v)
    (hS : LowPrefix σ π a v S) (hL : LowPrefix σ π a v L)
    (grow : ∀ x ∈ Inside σ a v, x ∈ L ↔ x ∈ S ∨ x = p)
    (has : a ≤ s) (hsv : s < v) (hB : Placed σ B s)
    (sep : Separator σ (Inside σ a v) S B s)
    (past : ExceptionWalk σ π a v S A B s) :
    ∃ (C : TemporalBoundary.Boundary Job) (t : ℤ),
      s ≤ t ∧ t < v ∧ Placed σ C t ∧
      Separator σ (Inside σ a v) S C t ∧ Separator σ (Inside σ a v) L C t ∧
      ExceptionWalk σ π a v L A C t := by
  have hSL : ∀ x ∈ Inside σ a v, x ∈ S → x ∈ L :=
    fun x hx hxS => (grow x hx).mpr (Or.inl hxS)
  have beforeL : EarlierHigh σ a v L B s := fun x hx hxL hxs =>
    sep.earlier_high x hx (fun hxS => hxL (hSL x hx hxS)) hxs
  have pastL := walk_mono past hSL
  classical
  by_cases hex : ∃ x ∈ Inside σ a v, x ∈ L ∧ s < σ.time x ∧ x ∉ D P B
  · obtain ⟨target, t, step⟩ := earliest_advance_exists hB hex
    obtain ⟨x, hxt, hxL, hxD⟩ := step.exception
    have hxE : x ∈ Inside σ a v := by
      simpa [Inside, hxt] using step.target_in_side
    have hxS : x ∉ S := fun h =>
      hxD (sep.later_low x hxE h (by have := step.increasing; omega))
    have hxp : x = p := ((grow x hxE).mp hxL).resolve_left hxS
    have hpt : σ.time p = t := by simpa [hxp] using hxt
    have targetBeforeL := advance_preserves_earlier hn hL has step beforeL
    have targetBeforeS : EarlierHigh σ a v S (.actual target) t := by
      intro y hy hyS hyt
      apply targetBeforeL y hy
      · intro hyL
        have hyp := ((grow y hy).mp hyL).resolve_left hyS
        have : σ.time y = t := by simpa [hyp] using hpt
        omega
      · exact hyt
    have addedPast : ∀ y ∈ Inside σ a v, y ∈ L → y ∉ S → σ.time y ≤ t := by
      intro y hy hyL hyS
      have hyp := ((grow y hy).mp hyL).resolve_left hyS
      simp [hyp, hpt]
    obtain ⟨C, u, htu, huv, hC, hsepS, hsepL, hwalk⟩ :=
      finish_two_prefixes hn hL hS hSL (.actual target) t step.target_slot
        (by have := step.increasing; omega) step.target_in_side.2
        targetBeforeL targetBeforeS addedPast
    exact ⟨C, u, step.increasing.le.trans htu, huv, hC, hsepS, hsepL,
      hwalk L A (fun _ _ h => h) (.advance pastL L hL (fun _ _ h => h) step)⟩
  · refine ⟨B, s, le_rfl, hsv, hB, sep, ⟨beforeL, ?_⟩, pastL⟩
    intro x hx hxL hsx
    by_contra hxD
    exact hex ⟨x, hx, hxL, hsx, hxD⟩

theorem shared_cutoff_outside {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {a v s : ℤ} {S L : Set Job}
    {B : TemporalBoundary.Boundary Job} {p : Job}
    (grow : ∀ x ∈ Inside σ a v, x ∈ L ↔ x ∈ S ∨ x = p)
    (hp : p ∉ Inside σ a v)
    (sep : Separator σ (Inside σ a v) S B s) :
    Separator σ (Inside σ a v) L B s := by
  have heq : ∀ x ∈ Inside σ a v, x ∈ L ↔ x ∈ S := by
    intro x hx
    rw [grow x hx]
    have hxp : x ≠ p := fun h => hp (h ▸ hx)
    simp [hxp]
  exact ⟨fun x hx hxL => sep.earlier_high x hx
      (fun hxS => hxL ((heq x hx).mpr hxS)),
    fun x hx hxL => sep.later_low x hx ((heq x hx).mp hxL)⟩

def Prepared {P : Precedence Job} {T : ℕ} (σ τ : Schedule P T)
    (a v b : ℤ) : Prop :=
  Reorders σ τ a b ∧
    (∀ x, x ∈ Inside σ a v ↔ x ∈ Inside τ a v) ∧
    (∀ x, x ∈ Inside σ v b ↔ x ∈ Inside τ v b)

theorem reorders_disjoint {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {c d e f : ℤ}
    (h : Reorders σ τ c d) (hd : d ≤ e ∨ f ≤ c) :
    ∀ x, x ∈ Inside σ e f ↔ x ∈ Inside τ e f := by
  intro x
  by_cases hx : x ∈ Inside σ c d
  · have ht := (h.1 x).mp hx
    dsimp [Inside] at hx ht ⊢
    rcases hd with hd | hd <;> constructor <;> intro he <;> omega
  · simp only [Inside, Set.mem_setOf_eq, h.2 x hx]

theorem prepared_refl {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a v b : ℤ) : Prepared σ σ a v b :=
  ⟨reorders_refl σ a b, fun _ => Iff.rfl, fun _ => Iff.rfl⟩

theorem prepared_left {P : Precedence Job} {T : ℕ}
    {σ τ υ : Schedule P T} {a v b : ℤ}
    (h : Prepared σ τ a v b) (k : Reorders τ υ a v) (hvb : v ≤ b) :
    Prepared σ υ a v b :=
  ⟨reorders_trans h.1 (reorders_enlarge k le_rfl hvb),
    fun x => (h.2.1 x).trans (k.1 x),
    fun x => (h.2.2 x).trans (reorders_disjoint k (Or.inl le_rfl) x)⟩

theorem prepared_right {P : Precedence Job} {T : ℕ}
    {σ τ υ : Schedule P T} {a v b : ℤ}
    (h : Prepared σ τ a v b) (k : Reorders τ υ v b) (hav : a ≤ v) :
    Prepared σ υ a v b :=
  ⟨reorders_trans h.1 (reorders_enlarge k hav le_rfl),
    fun x => (h.2.1 x).trans (reorders_disjoint k (Or.inr le_rfl) x),
    fun x => (h.2.2 x).trans (k.1 x)⟩

theorem prepared_center_compare {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a v b : ℤ} (h : Prepared σ τ a v b) (x : Job) :
    (σ.time x < v ↔ τ.time x < v) ∧
      (σ.time x = v ↔ τ.time x = v) ∧ (v < σ.time x ↔ v < τ.time x) := by
  by_cases hx : x ∈ Inside σ a b
  · have ht := (h.1.1 x).mp hx
    have hleft := h.2.1 x
    have hright := h.2.2 x
    dsimp [Inside] at hx ht hleft hright
    omega
  · rw [h.1.2 x hx]
    exact ⟨Iff.rfl, Iff.rfl, Iff.rfl⟩

theorem prepared_center_placed {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a v b : ℤ} {F : Finset Job}
    (h : Prepared σ τ a v b) (hF : Placed σ (.actual F) v) :
    Placed τ (.actual F) v :=
  ⟨hF.1, fun x => (hF.2 x).trans (prepared_center_compare h x).2.1⟩

theorem prepared_center_separator {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a v b : ℤ} {F : Finset Job} {I : Set Job}
    (h : Prepared σ τ a v b)
    (sep : Separator σ (Inside σ a b) I (.actual F) v) :
    Separator τ (Inside τ a b) I (.actual F) v :=
  ⟨fun x hx hxI hxt => sep.earlier_high x ((h.1.1 x).mpr hx) hxI
      ((prepared_center_compare h x).1.mpr hxt),
    fun x hx hxI hxt => sep.later_low x ((h.1.1 x).mpr hx) hxI
      ((prepared_center_compare h x).2.2.mpr hxt)⟩

noncomputable def unreverse {P : Precedence Job} {T : ℕ}
    (σ : Schedule P.reverse T) : Schedule P T where
  time := σ.reverse.time
  feasible := σ.reverse.feasible
  complete := σ.reverse.complete

theorem unreverse_reverse {P : Precedence Job} {T : ℕ} (σ : Schedule P.reverse T) :
    (unreverse σ).reverse = σ := by
  apply schedule_ext
  funext x
  dsimp [unreverse, Schedule.reverse, reverseTime]
  omega

theorem reorders_unreverse {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {τ : Schedule P.reverse T} {v b : ℤ}
    (h : Reorders σ.reverse τ (reverseTime T b) (reverseTime T v)) :
    Reorders σ (unreverse τ) v b := by
  refine ⟨?_, ?_⟩
  · intro x
    have ht := h.1 x
    dsimp [Inside, unreverse, Schedule.reverse, reverseTime] at ht ⊢
    omega
  · intro x hx
    have hx' : x ∉ Inside σ.reverse (reverseTime T b) (reverseTime T v) := by
      simpa only [inside_reverse] using hx
    have ht := h.2 x hx'
    dsimp [unreverse, Schedule.reverse, reverseTime] at ht ⊢
    omega

theorem word_eq_of_slots {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} (π : Priority P) {a b : ℤ}
    (h : ∀ t, a < t → t < b → slotJobs σ t = slotJobs τ t) :
    word σ π a b = word τ π a b := by
  have aux : ∀ l : List ℤ,
      (∀ t ∈ l, slotJobs σ t = slotJobs τ t) →
      l.flatMap (slotWord σ π) = l.flatMap (slotWord τ π) := by
    intro l
    induction l with
    | nil => simp
    | cons t l ih =>
        intro he
        have ht := he t (by simp)
        have hl := ih (fun u hu => he u (by simp [hu]))
        simp only [List.flatMap_cons, slotWord, slotKeys, ht, hl]
  apply aux
  intro t ht
  have ht' : a < t ∧ t < b := by simpa [sideSlots] using ht
  exact h t ht'.1 ht'.2

theorem word_left_unchanged {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} (π : Priority P) {a v b : ℤ}
    (h : Reorders σ τ v b) : word σ π a v = word τ π a v := by
  apply word_eq_of_slots π
  intro t _ htv
  exact (child_reordering_keeps_prefix h t htv.le).symm

theorem normalized_sides_exists {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (ρ : Priority P.reverse)
    (a v b : ℤ) (hav : a ≤ v) (hvb : v ≤ b) :
    ∃ τ : Schedule P T, Prepared σ τ a v b ∧
      Normalized τ π a v ∧
      Normalized τ.reverse ρ (reverseTime T b) (reverseTime T v) := by
  classical
  letI : Finite (Schedule P T) := finite_schedules P T
  letI : Fintype (Schedule P T) := Fintype.ofFinite _
  let choices := Finset.univ.filter (fun τ : Schedule P T => Prepared σ τ a v b)
  let objective := fun τ : Schedule P T =>
    toLex (word τ π a v, word τ.reverse ρ (reverseTime T b) (reverseTime T v))
  have hσ : σ ∈ choices := by simp [choices, prepared_refl]
  obtain ⟨τ, hτ, hm⟩ := Finset.exists_min_image choices objective ⟨σ, hσ⟩
  have hp : Prepared σ τ a v b := (Finset.mem_filter.mp hτ).2
  refine ⟨τ, hp, ?_, ?_⟩
  · intro υ hυ hlex
    have hc : υ ∈ choices := by simp [choices, prepared_left hp hυ hvb]
    have hmin := hm υ hc
    apply (not_lt_of_ge hmin)
    simp only [objective, Prod.Lex.toLex_lt_toLex]
    exact Or.inl ((List.lt_iff_lex_lt _ _).mpr hlex)
  · intro υ hυ hlex
    have hr := reorders_unreverse hυ
    have hc : unreverse υ ∈ choices := by simp [choices, prepared_right hp hr hav]
    have hmin := hm (unreverse υ) hc
    apply (not_lt_of_ge hmin)
    simp only [objective, unreverse_reverse, Prod.Lex.toLex_lt_toLex]
    exact Or.inr ⟨(word_left_unchanged π hr).symm,
      (List.lt_iff_lex_lt _ _).mpr hlex⟩

theorem separator_congr_low {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {U L K : Set Job} {B : TemporalBoundary.Boundary Job} {s : ℤ}
    (h : ∀ x ∈ U, x ∈ L ↔ x ∈ K) (sep : Separator σ U L B s) :
    Separator σ U K B s :=
  ⟨fun x hx hxK => sep.earlier_high x hx (fun hxL => hxK ((h x hx).mp hxL)),
    fun x hx hxK => sep.later_low x hx ((h x hx).mpr hxK)⟩

theorem separator_reverse_complement {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {U L : Set Job} {B : TemporalBoundary.Boundary Job} {s : ℤ}
    (sep : Separator σ U L B s) :
    Separator σ.reverse U (U \ L) B.reverse (reverseTime T s) := by
  constructor
  · intro x hx hxL hxt
    have hxl : x ∈ L := by
      by_contra hn
      exact hxL ⟨hx, hn⟩
    have ht : s < σ.time x := by dsimp [Schedule.reverse, reverseTime] at hxt; omega
    simpa only [pred_reverse] using sep.later_low x hx hxl ht
  · intro x hx hxL hxt
    have ht : σ.time x < s := by dsimp [Schedule.reverse, reverseTime] at hxt; omega
    simpa only [D_reverse] using sep.earlier_high x hx hxL.2 ht

theorem node_center_exists {T : ℕ} (N : RawNode Job T) (hne : N.domain.Nonempty) :
    ∃ (σ : Schedule N.frame T) (F : Finset Job) (v : ℤ),
      Reorders N.schedule σ N.a N.b ∧ N.a < v ∧ v < N.b ∧
      Placed σ (.actual F) v ∧
      Separator σ (Inside σ N.a N.b) (sameCenterLow N σ) (.actual F) v := by
  obtain ⟨σ, π, F, v, hp, hn, hL, hav, hvb, hF, hsep⟩ :=
    ideal_center_exists N.schedule N.a N.b (Pred N.frame N.right)
      (fun _ _ _ _ hxy hy => pred_down _ _ hxy hy) hne
  refine ⟨σ, F, v, hp, hav, hvb, hF, ?_⟩
  apply separator_congr_low (fun x hx => ?_) hsep
  change x ∈ Pred N.frame N.right ↔ x ∈ Inside σ N.a N.b ∩ Pred N.frame N.right
  simp [hx]

theorem root_last_center {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (hne : (rawRoot P σ).domain.Nonempty) :
    0 < (T : ℤ) ∧ (T : ℤ) < (T : ℤ) + 1 ∧
      Placed σ (.actual (slotJobs σ T)) T ∧
      Separator σ (Inside σ 0 ((T : ℤ) + 1)) (sameCenterLow (rawRoot P σ) σ)
        (.actual (slotJobs σ T)) T := by
  obtain ⟨x, _⟩ := hne
  have hr := σ.complete.range x
  have hT : (1 : ℤ) ≤ T := by omega
  refine ⟨by omega, by omega, slot_placed σ hT le_rfl, ?_⟩
  constructor
  · intro y hy hyL _
    exact False.elim (hyL ⟨hy, Set.mem_univ _⟩)
  · intro y _ _ hyt
    have := (σ.complete.range y).2
    omega

theorem rooted_center_exists {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (hne : N.domain.Nonempty) :
    ∃ (τ : Schedule N.frame T) (F : Finset Job) (v : ℤ),
      Reorders N.schedule τ N.a N.b ∧ N.a < v ∧ v < N.b ∧
      Placed τ (.actual F) v ∧
      Separator τ (Inside τ N.a N.b) (sameCenterLow N τ) (.actual F) v ∧
      (N.incoming = none → v = (T : ℤ)) := by
  cases history with
  | root =>
      have h := root_last_center σ hne
      exact ⟨σ, slotJobs σ T, T, reorders_refl _ _ _, h.1, h.2.1, h.2.2.1,
        h.2.2.2, fun _ => rfl⟩
  | same past e =>
      obtain ⟨τ, F, v, hp, hav, hvb, hF, hsep⟩ := node_center_exists e.child hne
      exact ⟨τ, F, v, hp, hav, hvb, hF, hsep, by simp [RawSameData.child]⟩
  | switched past e =>
      obtain ⟨τ, F, v, hp, hav, hvb, hF, hsep⟩ := node_center_exists e.child hne
      exact ⟨τ, F, v, hp, hav, hvb, hF, hsep, by simp [RawSwitchData.child]⟩

structure NodePreparation {T : ℕ} (N : RawNode Job T) where
  schedule : Schedule N.frame T
  preparation : Reorders N.schedule schedule N.a N.b
  sameOrder : Priority N.frame
  switchedOrder : Priority N.frame.reverse
  same_protocol : ∀ x ∈ Inside schedule N.a N.b, ∀ y ∈ Inside schedule N.a N.b,
    sameOrder.index x < sameOrder.index y ↔ samePriority N.data N.list N.right x y
  switched_protocol : ∀ x y, switchedOrder.index x < switchedOrder.index y ↔
    switchPriority N.frame.reverse N.right.reverse x y
  center : Finset Job
  v : ℤ
  center_placed : Placed schedule (.actual center) v
  center_interior : N.a < v ∧ v < N.b
  root_last : N.incoming = none → v = (T : ℤ)
  same_center : Separator schedule (Inside schedule N.a N.b)
    (sameCenterLow N schedule) (.actual center) v
  switched_center : Separator schedule.reverse
    (Inside schedule.reverse (reverseTime T N.b) (reverseTime T N.a))
    (switchCenterLow schedule.reverse (reverseTime T N.b) (reverseTime T N.a) N.right.reverse)
    (.actual center) (reverseTime T v)
  same_normalized : Normalized schedule sameOrder N.a v
  switched_normalized : Normalized schedule.reverse switchedOrder
    (reverseTime T N.b) (reverseTime T v)

theorem node_preparation_exists {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (history : RootedHistory P σ N) (hne : N.domain.Nonempty) :
    Nonempty (NodePreparation N) := by
  obtain ⟨τ, F, v, hp, hav, hvb, hF, hsep, hroot⟩ :=
    rooted_center_exists history hne
  obtain ⟨π, hπ⟩ := raw_same_priority_exists history.raw τ hp
  obtain ⟨ρ, hρ⟩ := switch_priority_exists N.frame.reverse N.right.reverse
  obtain ⟨υ, hυ, hn, hnrev⟩ := normalized_sides_exists τ π ρ N.a v N.b hav.le hvb.le
  have hprep := reorders_trans hp hυ.1
  have hplaced := prepared_center_placed hυ hF
  have hs : Separator υ (Inside υ N.a N.b) (sameCenterLow N υ) (.actual F) v := by
    apply separator_congr_low (fun x hx => ?_) (prepared_center_separator hυ hsep)
    change (x ∈ Inside τ N.a N.b ∧ x ∈ Pred N.frame N.right) ↔
      (x ∈ Inside υ N.a N.b ∧ x ∈ Pred N.frame N.right)
    rw [hυ.1.1 x]
  have hsrev := separator_reverse_complement hs
  have hs' : Separator υ.reverse
      (Inside υ.reverse (reverseTime T N.b) (reverseTime T N.a))
      (switchCenterLow υ.reverse (reverseTime T N.b) (reverseTime T N.a) N.right.reverse)
      (.actual F) (reverseTime T v) := by
    rw [inside_reverse]
    apply separator_congr_low (fun x hx => ?_) hsrev
    simp [sameCenterLow, switchCenterLow, inside_reverse, D_reverse, hx]
  exact ⟨{
    schedule := υ
    preparation := hprep
    sameOrder := π
    switchedOrder := ρ
    same_protocol := fun x hx y hy => hπ x ((hυ.1.1 x).mpr hx) y ((hυ.1.1 y).mpr hy)
    switched_protocol := hρ
    center := F
    v := v
    center_placed := hplaced
    center_interior := ⟨hav, hvb⟩
    root_last := hroot
    same_center := hs
    switched_center := hs'
    same_normalized := hn
    switched_normalized := hnrev
  }⟩

theorem root_switched_side_empty {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    (prep : NodePreparation (rawRoot P σ)) :
    Inside prep.schedule.reverse (reverseTime T ((T : ℤ) + 1))
      (reverseTime T prep.v) = ∅ := by
  have hv := prep.root_last rfl
  ext x
  have hr := prep.schedule.reverse.complete.range x
  simp only [Inside, Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
  dsimp [rawRoot, reverseTime] at hv ⊢
  omega

theorem selected_attained_key {T : ℕ} {N : RawNode Job T} {p x : Job}
    (hp : p ∈ N.qualifiers) :
    x ∈ selectedByKey N.data N.list
      (some (largestIndex N.data N.list p - 1, N.frame.rank p)) ↔ N.key p ≤ N.key x := by
  have hpos := (largest_index_pos N.data N.list p).mpr hp
  have hoff : largestIndex N.data N.list p - 1 + 1 = largestIndex N.data N.list p := by
    omega
  simp only [selectedByKey, Set.mem_setOf_eq, KeyGE, SameFrameHistory.key,
    RawNode.key, lexKey, Prod.Lex.toLex_le_toLex, hoff]
  change (largestIndex N.data N.list p < largestIndex N.data N.list x ∨
      (largestIndex N.data N.list x = largestIndex N.data N.list p ∧
        N.frame.rank p ≤ N.frame.rank x)) ↔ _
  have hrp : N.data.rank p = N.frame.rank p := rfl
  have hrx : N.data.rank x = N.frame.rank x := rfl
  rw [hrp, hrx]
  omega

theorem initial_same_cut_exists {T : ℕ} {N : RawNode Job T}
    (σ : Schedule N.frame T) :
    ∃ cut : Cut, CutAttained N.data (Inside σ N.a N.b) N.list cut ∧
      ∀ x ∈ Inside σ N.a N.b,
        x ∈ selectedByKey N.data N.list cut ↔ x ∈ N.qualifiers := by
  classical
  let choices := Finset.univ.filter (fun x => x ∈ Inside σ N.a N.b ∧ x ∈ N.qualifiers)
  by_cases hne : choices.Nonempty
  · obtain ⟨p, hp, hmin⟩ := Finset.exists_min_image choices N.key hne
    have hp' := (Finset.mem_filter.mp hp).2
    let cut : Cut := some (largestIndex N.data N.list p - 1, N.frame.rank p)
    refine ⟨cut, ?_, ?_⟩
    · refine ⟨p, hp'.1, hp'.2, ?_⟩
      have hpos := (largest_index_pos N.data N.list p).mpr hp'.2
      simp only [SameFrameHistory.key]
      change (largestIndex N.data N.list p, N.frame.rank p) =
        (largestIndex N.data N.list p - 1 + 1, N.frame.rank p)
      congr 1
      omega
    · intro x hx
      change x ∈ selectedByKey N.data N.list
        (some (largestIndex N.data N.list p - 1, N.frame.rank p)) ↔ _
      constructor
      · intro hxsel
        exact selected_subset_qual N.data N.list _ hxsel
      · intro hxQ
        rw [selected_attained_key hp'.2]
        exact hmin x (by simp [choices, hx, hxQ])
  · refine ⟨none, trivial, ?_⟩
    intro x hx
    have hxQ : x ∉ N.qualifiers := by
      intro hq
      exact hne ⟨x, by simp [choices, hx, hq]⟩
    simp [selectedByKey, hxQ]

theorem same_low_prefix {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N) (cut : Cut) :
    LowPrefix prep.schedule prep.sameOrder N.a prep.v (sameLow N prep.schedule cut) := by
  have hI1 := (history.future_invariants prep.schedule prep.preparation).1
  have hlow := priority_low_eq_historical hI1 cut
  intro x hx hxL y hy hyL
  have hxU : x ∈ Inside prep.schedule N.a N.b :=
    ⟨hx.1, hx.2.trans prep.center_interior.2⟩
  have hyU : y ∈ Inside prep.schedule N.a N.b :=
    ⟨hy.1, hy.2.trans prep.center_interior.2⟩
  apply (prep.same_protocol x hxU y hyU).mpr
  change x ∈ priorityLow N.data (Inside prep.schedule N.a N.b) N.list cut N.right at hxL
  rw [hlow] at hxL
  change x ∈ Inside prep.schedule N.a N.b ∩
    (N.data.P N.right \ selectedByKey N.data N.list cut) at hxL
  have hyhigh : y ∉ N.data.P N.right ∨ y ∈ selectedByKey N.data N.list cut := by
    by_contra hn
    push Not at hn
    have hylo : y ∈ historicalLow N.data (Inside prep.schedule N.a N.b) N.list cut N.right :=
      ⟨hyU, hn.1, hn.2⟩
    apply hyL
    change y ∈ priorityLow N.data (Inside prep.schedule N.a N.b) N.list cut N.right
    rw [hlow]
    exact hylo
  by_cases hxQ : x ∈ Qual N.data N.list
  · have hxkey : ∀ y, y ∈ selectedByKey N.data N.list cut → N.key x < N.key y := by
      intro z hz
      cases cut with
      | none => exact False.elim hz
      | some p =>
          have hxnot := hxL.2.2
          change ¬ KeyGE p.1 p.2 (SameFrameHistory.key N.data N.list x) at hxnot
          change KeyGE p.1 p.2 (SameFrameHistory.key N.data N.list z) at hz
          rw [RawNode.key, RawNode.key, lexKey_lt_iff]
          simp only [KeyGE, SameFrameHistory.key] at hxnot hz
          omega
    rcases hyhigh with hyP | hySel
    · have hyQ : y ∉ Qual N.data N.list := fun h => hyP (hI1.old_high ⟨hyU, h⟩)
      simp [samePriority, sameGroup, hxQ, hyQ, hyP]
    · have hyQ := selected_subset_qual N.data N.list cut hySel
      have hk := hxkey y hySel
      simp [samePriority, sameGroup, hxQ, hyQ, RawNode.key] at hk ⊢
      exact hk
  · have hxP := hxL.2.1
    rcases hyhigh with hyP | hySel
    · have hyQ : y ∉ Qual N.data N.list := fun h => hyP (hI1.old_high ⟨hyU, h⟩)
      simp [samePriority, sameGroup, hxQ, hyQ, hxP, hyP]
    · have hyQ := selected_subset_qual N.data N.list cut hySel
      simp [samePriority, sameGroup, hxQ, hyQ, hxP]

theorem switched_low_prefix {T : ℕ} {N : RawNode Job T}
    (prep : NodePreparation N) (r : ℕ) :
    LowPrefix prep.schedule.reverse prep.switchedOrder (reverseTime T N.b)
      (reverseTime T prep.v)
      (switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
        N.right.reverse r) := by
  intro x hx hxL y hy hyL
  apply (prep.switched_protocol x y).mpr
  have hvb : reverseTime T prep.v < reverseTime T N.a := by
    have := prep.center_interior.1
    dsimp [reverseTime]
    omega
  have hyU : y ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) :=
    ⟨hy.1, hy.2.trans hvb⟩
  change x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) ∧
    x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x ≤ r at hxL
  change ¬ (y ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) ∧
    y ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank y ≤ r) at hyL
  by_cases hyD : y ∈ D N.frame.reverse N.right.reverse
  · exact Or.inl ⟨hxL.2.1, hyD⟩
  · have hyr : r < N.frame.reverse.rank y := by
      by_contra hn
      exact hyL ⟨hyU, hyD, by omega⟩
    exact Or.inr ⟨⟨fun h => False.elim (hxL.2.1 h), fun h => False.elim (hyD h)⟩,
      lt_of_le_of_lt hxL.2.2 hyr⟩

theorem initial_same_separator {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N) :
    ∃ cut : Cut, CutAttained N.data (Inside prep.schedule N.a N.b) N.list cut ∧
      Separator prep.schedule (Inside prep.schedule N.a prep.v)
        (sameLow N prep.schedule cut) N.left N.a ∧
      ExceptionWalk prep.schedule prep.sameOrder N.a prep.v
        (sameLow N prep.schedule cut) N.left N.left N.a := by
  obtain ⟨cut, hcut, hsel⟩ := initial_same_cut_exists prep.schedule
  have hI1 := (history.future_invariants prep.schedule prep.preparation).1
  have hlow := priority_low_eq_historical hI1 cut
  have hplaced := placed_outside_reorders prep.preparation (Or.inl le_rfl) N.left_placed
  refine ⟨cut, hcut, ⟨?_, ?_⟩, .start hplaced⟩
  · intro x hx _ hxt
    have := hx.1
    omega
  · intro x hx hxL _
    have hxU : x ∈ Inside prep.schedule N.a N.b :=
      ⟨hx.1, hx.2.trans prep.center_interior.2⟩
    change x ∈ priorityLow N.data (Inside prep.schedule N.a N.b) N.list cut N.right at hxL
    rw [hlow] at hxL
    have hxnot : x ∉ N.qualifiers := fun hq => hxL.2.2 ((hsel x hxU).mpr hq)
    exact hI1.old_low ⟨hxU, hxnot⟩

theorem initial_switched_separator {T : ℕ} {N : RawNode Job T}
    (prep : NodePreparation N) :
    Separator prep.schedule.reverse
        (Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T prep.v))
        (switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
          N.right.reverse 0) N.right.reverse (reverseTime T N.b) ∧
      ExceptionWalk prep.schedule.reverse prep.switchedOrder (reverseTime T N.b)
        (reverseTime T prep.v)
        (switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
          N.right.reverse 0) N.right.reverse N.right.reverse (reverseTime T N.b) := by
  have hplaced := placed_reverse
    (placed_outside_reorders prep.preparation (Or.inr le_rfl) N.right_placed)
  refine ⟨⟨?_, ?_⟩, .start hplaced⟩
  · intro x hx _ hxt
    have := hx.1
    omega
  · intro x _ hxL _
    have hr := N.frame.reverse.rank_pos x
    have hzero : N.frame.reverse.rank x ≤ 0 := hxL.2.2
    omega

theorem raw_key_injective {T : ℕ} (N : RawNode Job T) : Function.Injective N.key := by
  intro x y heq
  exact N.frame.rank_injective (congrArg (fun z => (ofLex z).2) heq)

theorem next_same_cut_exists {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N)
    {p : Job} (hpU : p ∈ Inside prep.schedule N.a N.b) (hpQ : p ∈ N.qualifiers) :
    ∃ cut : Cut, CutAttained N.data (Inside prep.schedule N.a N.b) N.list cut ∧
      ∀ x ∈ Inside prep.schedule N.a N.b,
        x ∈ sameLow N prep.schedule cut ↔
          x ∈ sameLow N prep.schedule
            (some (largestIndex N.data N.list p - 1, N.frame.rank p)) ∨ x = p := by
  classical
  let choices := Finset.univ.filter
    (fun x => x ∈ Inside prep.schedule N.a N.b ∧ x ∈ N.qualifiers ∧ N.key p < N.key x)
  have next : ∃ cut : Cut,
      CutAttained N.data (Inside prep.schedule N.a N.b) N.list cut ∧
      ∀ x ∈ Inside prep.schedule N.a N.b,
        x ∈ selectedByKey N.data N.list cut ↔ x ∈ N.qualifiers ∧ N.key p < N.key x := by
    by_cases hne : choices.Nonempty
    · obtain ⟨q, hq, hmin⟩ := Finset.exists_min_image choices N.key hne
      have hq' := (Finset.mem_filter.mp hq).2
      let cut : Cut := some (largestIndex N.data N.list q - 1, N.frame.rank q)
      refine ⟨cut, ?_, ?_⟩
      · refine ⟨q, hq'.1, hq'.2.1, ?_⟩
        have hpos := (largest_index_pos N.data N.list q).mpr hq'.2.1
        change (largestIndex N.data N.list q, N.frame.rank q) =
          (largestIndex N.data N.list q - 1 + 1, N.frame.rank q)
        congr 1
        omega
      · intro x hx
        change x ∈ selectedByKey N.data N.list
          (some (largestIndex N.data N.list q - 1, N.frame.rank q)) ↔ _
        constructor
        · intro hs
          exact ⟨selected_subset_qual N.data N.list _ hs,
            hq'.2.2.trans_le ((selected_attained_key hq'.2.1).mp hs)⟩
        · intro hx'
          apply (selected_attained_key hq'.2.1).mpr
          exact hmin x (by simp [choices, hx, hx'.1, hx'.2])
    · refine ⟨none, trivial, ?_⟩
      intro x hx
      have hnot : ¬ (x ∈ N.qualifiers ∧ N.key p < N.key x) := by
        intro hx'
        exact hne ⟨x, by simp [choices, hx, hx'.1, hx'.2]⟩
      simp [selectedByKey, hnot]
  obtain ⟨cut, hcut, hsel⟩ := next
  refine ⟨cut, hcut, ?_⟩
  have hI1 := (history.future_invariants prep.schedule prep.preparation).1
  have hpP : p ∈ N.data.P N.right := hI1.old_high ⟨hpU, hpQ⟩
  intro x hx
  have low : ∀ c : Cut, x ∈ sameLow N prep.schedule c ↔
      x ∈ N.data.P N.right ∧ x ∉ selectedByKey N.data N.list c := by
    intro c
    change x ∈ priorityLow N.data (Inside prep.schedule N.a N.b) N.list c N.right ↔ _
    rw [priority_low_eq_historical hI1 c]
    simp [historicalLow, hx]
  rw [low cut, low _, hsel x hx, selected_attained_key hpQ]
  by_cases hxQ : x ∈ N.qualifiers
  · simp only [hxQ, true_and]
    constructor
    · rintro ⟨hxP, hkey⟩
      rcases lt_or_eq_of_le (le_of_not_gt hkey) with hlt | heq
      · exact Or.inl ⟨hxP, not_le_of_gt hlt⟩
      · exact Or.inr (raw_key_injective N heq)
    · rintro (⟨hxP, hkey⟩ | rfl)
      · exact ⟨hxP, fun h => hkey h.le⟩
      · exact ⟨hpP, lt_irrefl _⟩
  · have hxp : x ≠ p := fun h => hxQ (h ▸ hpQ)
    have hnot : ¬ N.key p ≤ N.key x := by
      intro hle
      have hs := (selected_attained_key hpQ).mpr hle
      exact hxQ (selected_subset_qual N.data N.list _ hs)
    simp [hxQ, hxp, hnot]

theorem next_switched_rank_exists {T : ℕ} {N : RawNode Job T}
    (prep : NodePreparation N) (r : ℕ)
    (hex : ∃ x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a),
      x ∉ D N.frame.reverse N.right.reverse ∧ r < N.frame.reverse.rank x) :
    ∃ p ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a),
      p ∉ D N.frame.reverse N.right.reverse ∧ r < N.frame.reverse.rank p ∧
      N.frame.reverse.rank p ≤ Fintype.card Job ∧
      ∀ x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a),
        x ∈ switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
            N.right.reverse (N.frame.reverse.rank p) ↔
          x ∈ switchLow prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a)
            N.right.reverse r ∨ x = p := by
  classical
  let choices := Finset.univ.filter (fun x =>
    x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) ∧
      x ∉ D N.frame.reverse N.right.reverse ∧ r < N.frame.reverse.rank x)
  obtain ⟨x₀, hx₀, hxD₀, hr₀⟩ := hex
  have hne : choices.Nonempty :=
    ⟨x₀, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hx₀, hxD₀, hr₀⟩⟩
  obtain ⟨p, hp, hmin⟩ := Finset.exists_min_image choices N.frame.reverse.rank hne
  have hp' := (Finset.mem_filter.mp hp).2
  refine ⟨p, hp'.1, hp'.2.1, hp'.2.2, N.frame.reverse.rank_bound p, ?_⟩
  intro x hx
  change (x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) ∧
      x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x ≤ N.frame.reverse.rank p) ↔
    (x ∈ Inside prep.schedule.reverse (reverseTime T N.b) (reverseTime T N.a) ∧
      x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x ≤ r) ∨ x = p
  constructor
  · rintro ⟨_, hxD, hxr⟩
    by_cases hr : N.frame.reverse.rank x ≤ r
    · exact Or.inl ⟨hx, hxD, hr⟩
    · have hxm : x ∈ choices :=
        Finset.mem_filter.mpr ⟨Finset.mem_univ _, hx, hxD, lt_of_not_ge hr⟩
      have hm := hmin x hxm
      exact Or.inr (N.frame.reverse.rank_injective (le_antisymm hxr hm))
  · rintro (⟨_, hxD, hxr⟩ | rfl)
    · exact ⟨hx, hxD, hxr.trans hp'.2.2.le⟩
    · exact ⟨hp'.1, hp'.2.1, le_rfl⟩

theorem prepared_centers_certified {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (prep : NodePreparation N) :
    SourceSplitCertificate prep.schedule N.domain (.actual prep.center) prep.v
        (separatorSyntax (.actual prep.center) (.lit false false (.predecessors N.right))) ∧
      SourceSplitCertificate prep.schedule.reverse N.domain (.actual prep.center)
        (reverseTime T prep.v)
        (separatorSyntax (.actual prep.center)
          (.lit true false (.descendants N.right.reverse))) :=
  ⟨history.same_center_certified prep.schedule prep.preparation prep.center_placed prep.same_center,
    history.switched_center_certified prep.schedule.reverse (reorders_reverse prep.preparation)
      (placed_reverse prep.center_placed) prep.switched_center⟩

theorem root_preparation_exists {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (hT : 0 < T) : Nonempty (NodePreparation (rawRoot P σ)) := by
  have hslot := slot_placed σ (t := 1) le_rfl (by exact_mod_cast hT)
  have hpos : 0 < (slotJobs σ 1).card := by rw [hslot.1]; norm_num
  obtain ⟨x, hx⟩ := Finset.card_pos.mp hpos
  have hxt := (hslot.2 x).mp hx
  apply node_preparation_exists (.root (P := P) (σ := σ))
  exact ⟨x, by change 0 < σ.time x ∧ σ.time x < (T : ℤ) + 1; omega⟩

end LiteralProtocol
