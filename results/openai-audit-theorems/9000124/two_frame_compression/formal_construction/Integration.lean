set_option autoImplicit false
set_option maxHeartbeats 1500000
set_option linter.unusedSectionVars false

namespace LiteralConstruction

open SameFrameHistory TemporalBoundary
open scoped Classical

variable {Job BoundaryLabel : Type*}

noncomputable def lexKey (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (x : Job) : ℕ ×ₗ ℕ :=
  toLex (SameFrameHistory.key C L x)

theorem lexKey_lt_iff (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (x y : Job) :
    lexKey C L x < lexKey C L y ↔
      largestIndex C L x < largestIndex C L y ∨
        (largestIndex C L x = largestIndex C L y ∧ C.rank x < C.rank y) := by
  simp [lexKey, SameFrameHistory.key, Prod.Lex.toLex_lt_toLex]

theorem largest_index_mono (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (x y : Job)
    (h : ∀ e ∈ L, x ∈ e.denote C → y ∈ e.denote C) :
    largestIndex C L x ≤ largestIndex C L y := by
  classical
  induction L with
  | nil => simp [largestIndex]
  | cons e L ih =>
      have htail : ∀ f ∈ L, x ∈ f.denote C → y ∈ f.denote C :=
        fun f hf => h f (by simp [hf])
      have hm := ih htail
      have hqual : x ∈ Qual C L → y ∈ Qual C L := by
        rintro ⟨f, hf, hx⟩
        exact ⟨f, hf, htail f hf hx⟩
      by_cases hx : x ∈ Qual C L
      · simp only [largestIndex, if_pos hx, if_pos (hqual hx)]
        omega
      · by_cases hy : y ∈ Qual C L
        · have hp := (largest_index_pos C L y).mpr hy
          simp only [largestIndex, if_neg hx, if_pos hy]
          split_ifs <;> omega
        · have he := h e (by simp)
          simp only [largestIndex, if_neg hx, if_neg hy]
          split_ifs <;> simp_all

theorem lex_key_precedence (C : SameFrameHistory.Data Job BoundaryLabel)
    (R : Job → Job → Prop) (L : List (Entry BoundaryLabel))
    (up : ∀ e ∈ L, SameFrameHistory.IsUp R (e.denote C))
    (rank_strict : ∀ ⦃x y⦄, R x y → C.rank x < C.rank y)
    {x y : Job} (hxy : R x y) :
    lexKey C L x < lexKey C L y := by
  rw [lexKey_lt_iff]
  have hm := largest_index_mono C L x y (fun e he hx => up e he hxy hx)
  have hr := rank_strict hxy
  omega

theorem carryAt_index (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (d r : ℕ) {x : Job}
    (hx : x ∈ Qual C (carryAt L d r)) :
    largestIndex C L x = largestIndex C (carryAt L d r) x + d := by
  classical
  induction L generalizing d with
  | nil => simp [carryAt] at hx
  | cons e L ih =>
      cases d with
      | zero =>
          by_cases ht : x ∈ Qual C L
          · simp [carryAt, largestIndex, ht]
          · have htrim : x ∈ (e.trim r).denote C :=
              (mem_qual_cons C x (e.trim r) L).mp hx |>.resolve_right ht
            have he : x ∈ e.denote C := by
              rw [trim_denote] at htrim
              exact htrim.1
            simp [carryAt, largestIndex, ht, he, htrim]
      | succ d =>
          have hsel : x ∈ Qual C (carryAt L d r) := hx
          have hold : x ∈ Qual C L :=
            selected_subset_qual C L (some (d, r)) ((carryAt_key C L d r x).mp hsel)
          have heq := ih d hsel
          simp only [carryAt, largestIndex, if_pos hold]
          omega

theorem carry_key_order (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (cut : Cut)
    {x y : Job} (hx : x ∈ Qual C (carry L cut)) (hy : y ∈ Qual C (carry L cut)) :
    lexKey C (carry L cut) x < lexKey C (carry L cut) y ↔
      lexKey C L x < lexKey C L y := by
  cases cut with
  | none => simp [carry] at hx
  | some p =>
      have hxi := carryAt_index C L p.1 p.2 hx
      have hyi := carryAt_index C L p.1 p.2 hy
      simp only [carry] at *
      rw [lexKey_lt_iff, lexKey_lt_iff, hxi, hyi]
      omega

theorem prune_subset (C : SameFrameHistory.Data Job BoundaryLabel)
    (U : Set Job) (L : List (Entry BoundaryLabel)) :
    Qual C (prune C U L) ⊆ Qual C L := by
  rintro x ⟨e, he, hx⟩
  exact ⟨e, (List.mem_filter.mp he).1, hx⟩

theorem prune_comparison (C : SameFrameHistory.Data Job BoundaryLabel)
    (U : Set Job) (L : List (Entry BoundaryLabel))
    {x y : Job} (hxU : x ∈ U) (hx : x ∈ Qual C (prune C U L))
    (hy : y ∈ Qual C (prune C U L))
    (hkey : lexKey C (prune C U L) x < lexKey C (prune C U L) y) :
    lexKey C L x < lexKey C L y := by
  classical
  induction L with
  | nil => simp [prune] at hx
  | cons e L ih =>
      by_cases hs : ∃ z ∈ U, z ∈ e.denote C
      · rw [prune_cons, if_pos hs] at hx hy hkey
        by_cases hxt : x ∈ Qual C (prune C U L)
        · have hyt : y ∈ Qual C (prune C U L) := by
            by_contra hn
            have hpx := (largest_index_pos C (prune C U L) x).mpr hxt
            have hpy := (largest_index_zero C (prune C U L) y).mpr hn
            simp only [lexKey_lt_iff, largestIndex, if_pos hxt, if_neg hn] at hkey
            split_ifs at hkey
            · rcases hkey with hlt | ⟨heq, _⟩ <;> omega
            · simp at hkey
          have htkey : lexKey C (prune C U L) x < lexKey C (prune C U L) y := by
            simpa only [lexKey_lt_iff, largestIndex, if_pos hxt, if_pos hyt,
              Nat.add_lt_add_iff_right, Nat.add_right_cancel_iff] using hkey
          have hold := ih hxt hyt htkey
          have hxold := prune_subset C U L hxt
          have hyold := prune_subset C U L hyt
          simpa only [lexKey_lt_iff, largestIndex, if_pos hxold, if_pos hyold,
            Nat.add_lt_add_iff_right, Nat.add_right_cancel_iff] using hold
        · have hxnone : x ∉ Qual C L := by
            intro h
            have := (congrArg (fun A : Set Job => x ∈ A) (prune_local C U L))
            exact hxt ((Iff.of_eq this).mpr ⟨hxU, h⟩).2
          have hxe : x ∈ e.denote C := (mem_qual_cons C x e _).mp hx |>.resolve_right hxt
          by_cases hyt : y ∈ Qual C (prune C U L)
          · have hyold := prune_subset C U L hyt
            have hp := (largest_index_pos C L y).mpr hyold
            rw [lexKey_lt_iff]
            simp only [largestIndex, if_neg hxnone, if_pos hxe, if_pos hyold]
            exact Or.inl (by omega)
          · have hye : y ∈ e.denote C :=
              (mem_qual_cons C y e _).mp hy |>.resolve_right hyt
            have hr : C.rank x < C.rank y := by
              simpa [lexKey_lt_iff, largestIndex, hxt, hyt, hxe, hye] using hkey
            by_cases hyold : y ∈ Qual C L
            · have hp := (largest_index_pos C L y).mpr hyold
              rw [lexKey_lt_iff]
              simp only [largestIndex, if_neg hxnone, if_pos hxe, if_pos hyold]
              exact Or.inl (by omega)
            · simp [lexKey_lt_iff, largestIndex, hxnone, hyold, hxe, hye, hr]
      · rw [prune_cons, if_neg hs] at hx hy hkey
        have hxe : x ∉ e.denote C := fun h => hs ⟨x, hxU, h⟩
        have hold := ih hx hy hkey
        have hxold := prune_subset C U L hx
        have hyold := prune_subset C U L hy
        simpa only [lexKey_lt_iff, largestIndex, if_pos hxold, if_pos hyold,
          Nat.add_lt_add_iff_right, Nat.add_right_cancel_iff] using hold

theorem largest_index_append (C : SameFrameHistory.Data Job BoundaryLabel)
    (L M : List (Entry BoundaryLabel)) (x : Job) :
    largestIndex C (L ++ M) x =
      if x ∈ Qual C M then largestIndex C M x + L.length else largestIndex C L x := by
  classical
  induction L with
  | nil =>
      by_cases hx : x ∈ Qual C M
      · simp [hx]
      · simp [hx, (largest_index_zero C M x).mpr hx, largestIndex]
  | cons e L ih =>
      by_cases hx : x ∈ Qual C M
      · simp [largestIndex, ih, hx, Nat.add_assoc, Nat.add_comm]
      · by_cases ht : x ∈ Qual C L <;> simp [largestIndex, ih, hx, ht]

theorem append_key_without (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (e : Entry BoundaryLabel) {x : Job}
    (hx : x ∉ e.denote C) :
    lexKey C (L ++ [e]) x = lexKey C L x := by
  simp [lexKey, SameFrameHistory.key, largest_index_append, hx]

theorem append_index_inside (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (e : Entry BoundaryLabel) {x : Job}
    (hx : x ∈ e.denote C) :
    largestIndex C (L ++ [e]) x = L.length + 1 := by
  simp [largest_index_append, largestIndex, hx, Nat.add_comm]

theorem carry_subset (C : SameFrameHistory.Data Job BoundaryLabel)
    (L : List (Entry BoundaryLabel)) (cut : Cut) :
    Qual C (carry L cut) ⊆ Qual C L := by
  rw [carry_selected_by_key]
  exact selected_subset_qual C L cut

theorem same_high_union {C : SameFrameHistory.Data Job BoundaryLabel}
    {U : Set Job} {L : List (Entry BoundaryLabel)} {a b : BoundaryLabel}
    (hI1 : LocalI1 C U L a b) (cut : Cut) :
    ∀ x ∈ U, x ∈ Qual C (carry L cut) ∪ (C.D a \ C.P b) ↔
      x ∉ priorityLow C U L cut b := by
  intro x hx
  rw [priority_low_eq_historical hI1 cut]
  have hsel : x ∈ selectedByKey C L cut → x ∈ C.P b :=
    fun h => hI1.old_high ⟨hx, selected_subset_qual C L cut h⟩
  have hnotP : x ∉ C.P b → x ∈ C.D a := by
    intro hp
    apply hI1.old_low
    exact ⟨hx, fun hq => hp (hI1.old_high ⟨hx, hq⟩)⟩
  rw [carry_selected_by_key]
  simp only [historicalLow, Set.mem_inter_iff, Set.mem_sdiff, hx, true_and,
    Set.mem_union]
  tauto

theorem promoted_less_than_carry {C : SameFrameHistory.Data Job BoundaryLabel}
    {U : Set Job} {L : List (Entry BoundaryLabel)} {a b : BoundaryLabel}
    (hI1 : LocalI1 C U L a b) (cut : Cut) {x y : Job}
    (hx : x ∈ priorityLow C U L cut b) (hxD : x ∉ C.D a)
    (hy : y ∈ Qual C (carry L cut)) :
    lexKey C L x < lexKey C L y := by
  have hxU := hx.1
  have hxQ : x ∈ Qual C L := by
    by_contra hn
    exact hxD (hI1.old_low ⟨hxU, hn⟩)
  have hxnot : x ∉ selectedByKey C L cut := by
    have := hx
    rw [priority_low_eq_historical hI1 cut] at this
    exact this.2.2
  rw [carry_selected_by_key] at hy
  cases cut with
  | none => exact False.elim hy
  | some p =>
      have hlt : KeyLT p.1 p.2 (SameFrameHistory.key C L x) :=
        (key_lt_iff_not_ge _ _ _).mpr hxnot
      change KeyGE p.1 p.2 (SameFrameHistory.key C L y) at hy
      simp only [KeyLT, KeyGE, SameFrameHistory.key] at hlt hy
      rw [lexKey_lt_iff]
      rcases hlt with hlt | ⟨heq, hr⟩ <;>
        rcases hy with hgt | ⟨heqy, hry⟩ <;> omega

def injectionFlag : Entry BoundaryLabel → Bool
  | .injection _ _ _ => true
  | _ => false

@[simp] theorem injectionFlag_iff (e : Entry BoundaryLabel) :
    injectionFlag e = true ↔ e.Injection := by cases e <;> simp [injectionFlag, Entry.Injection]

@[simp] theorem trim_injection (e : Entry BoundaryLabel) (r : ℕ) :
    (e.trim r).Injection ↔ e.Injection := by
  cases e <;> simp [Entry.trim, Entry.Injection]

def baseCount : List (Entry BoundaryLabel) → ℕ
  | [] => 0
  | e :: L => (if injectionFlag e then 0 else 1) + baseCount L

def injections (L : List (Entry BoundaryLabel)) : List (Entry BoundaryLabel) :=
  L.filter injectionFlag

theorem baseCount_append (L M : List (Entry BoundaryLabel)) :
    baseCount (L ++ M) = baseCount L + baseCount M := by
  induction L with
  | nil => simp [baseCount]
  | cons e L ih => simp [baseCount, ih, Nat.add_assoc]

theorem count_decomposition (L : List (Entry BoundaryLabel)) :
    L.length = baseCount L + (injections L).length := by
  induction L with
  | nil => rfl
  | cons e L ih =>
      cases e <;> simp_all [baseCount, injections, injectionFlag] <;> omega

theorem prune_baseCount (C : SameFrameHistory.Data Job BoundaryLabel)
    (U : Set Job) (L : List (Entry BoundaryLabel)) :
    baseCount (prune C U L) ≤ baseCount L := by
  classical
  induction L with
  | nil => simp [prune, baseCount]
  | cons e L ih =>
      rw [prune_cons]
      split_ifs <;> simp only [baseCount] <;> omega

theorem carryAt_baseCount (L : List (Entry BoundaryLabel)) (d r : ℕ) :
    baseCount (carryAt L d r) ≤ baseCount L := by
  induction L generalizing d with
  | nil => simp [baseCount, carryAt]
  | cons e L ih =>
      cases d with
      | zero => cases e <;> simp [carryAt, baseCount, Entry.trim, injectionFlag]
      | succ d =>
          simp only [carryAt, baseCount]
          have := ih d
          omega

theorem carry_baseCount (L : List (Entry BoundaryLabel)) (cut : Cut) :
    baseCount (carry L cut) ≤ baseCount L := by
  cases cut with
  | none => simp [carry, baseCount]
  | some p => exact carryAt_baseCount L p.1 p.2

theorem Run.base_bound {C : SameFrameHistory.Data Job BoundaryLabel}
    {U : Set Job} {L : List (Entry BoundaryLabel)} (h : Run C U L) :
    baseCount L ≤ 2 := by
  induction h with
  | root => simp [baseCount, injectionFlag]
  | switched U h₀ hu =>
      exact (prune_baseCount C U _).trans (by simp [baseCount, injectionFlag])
  | @same U L history V hv cut a b ih =>
      have hp := prune_baseCount C V (carry L cut ++ [.injection a b none])
      have hc := carry_baseCount L cut
      simp only [baseCount_append, baseCount, injectionFlag, ↓reduceIte, Nat.add_zero] at hp
      omega

def InjectionSeparated (C : SameFrameHistory.Data Job BoundaryLabel)
    (U : Set Job) (L : List (Entry BoundaryLabel)) : Prop :=
  L.Pairwise (fun e f => e.Injection → f.Injection →
    ∀ x ∈ U, x ∈ e.denote C → x ∈ f.denote C → False)

theorem InjectionSeparated.shrink {C : SameFrameHistory.Data Job BoundaryLabel}
    {U V : Set Job} {L : List (Entry BoundaryLabel)}
    (h : InjectionSeparated C U L) (hv : V ⊆ U) :
    InjectionSeparated C V L :=
  h.imp (fun {_ _} hpair he hf x hx => hpair he hf x (hv hx))

theorem InjectionSeparated.prune {C : SameFrameHistory.Data Job BoundaryLabel}
    {U V : Set Job} {L : List (Entry BoundaryLabel)}
    (h : InjectionSeparated C U L) :
    InjectionSeparated C U (prune C V L) :=
  h.filter _

theorem InjectionSeparated.carryAt {C : SameFrameHistory.Data Job BoundaryLabel}
    {U : Set Job} {L : List (Entry BoundaryLabel)}
    (h : InjectionSeparated C U L) (d r : ℕ) :
    InjectionSeparated C U (SameFrameHistory.carryAt L d r) := by
  induction L generalizing d with
  | nil => simp [InjectionSeparated, SameFrameHistory.carryAt]
  | cons e L ih =>
      obtain ⟨hhead, htail⟩ := List.pairwise_cons.mp h
      cases d with
      | zero =>
          apply List.pairwise_cons.mpr
          refine ⟨?_, htail⟩
          intro f hf heI hfI x hx he hfmem
          apply hhead f hf ((trim_injection e r).mp heI) hfI x hx
          · rw [trim_denote] at he
            exact he.1
          · exact hfmem
      | succ d => exact ih htail d

theorem InjectionSeparated.carry {C : SameFrameHistory.Data Job BoundaryLabel}
    {U : Set Job} {L : List (Entry BoundaryLabel)}
    (h : InjectionSeparated C U L) (cut : Cut) :
    InjectionSeparated C U (SameFrameHistory.carry L cut) := by
  cases cut with
  | none => simp [SameFrameHistory.carry, InjectionSeparated]
  | some p => exact h.carryAt p.1 p.2

theorem InjectionSeparated.append_fresh
    {C : SameFrameHistory.Data Job BoundaryLabel} {U : Set Job}
    {L : List (Entry BoundaryLabel)} {a b : BoundaryLabel}
    (h : InjectionSeparated C U L) (hI1 : LocalI1 C U L a b) (cut : Cut) :
    InjectionSeparated C U (SameFrameHistory.carry L cut ++ [.injection a b none]) := by
  rw [InjectionSeparated, List.pairwise_append]
  refine ⟨h.carry cut, by simp, ?_⟩
  intro e he f hf heI hfI x hx hxe hxf
  have hf' : f = .injection a b none := List.mem_singleton.mp hf
  subst f
  have hxold : x ∈ Qual C L := carry_subset C L cut ⟨e, he, hxe⟩
  exact hxf.2 (hI1.old_high ⟨hx, hxold⟩)

theorem injection_length_le_card [DecidableEq Job]
    (C : SameFrameHistory.Data Job BoundaryLabel) (U : Set Job)
    (L : List (Entry BoundaryLabel)) (F : Finset Job)
    (hI : AllInjections L) (hsep : InjectionSeparated C U L)
    (hF : ∀ z ∈ F, z ∈ U)
    (hw : ∀ e ∈ L, ∃ z ∈ F, z ∈ e.denote C) :
    L.length ≤ F.card := by
  classical
  induction L generalizing F with
  | nil => simp
  | cons e L ih =>
      obtain ⟨z, hzF, hze⟩ := hw e (by simp)
      obtain ⟨hhead, htail⟩ := List.pairwise_cons.mp hsep
      have hItail : AllInjections L := fun f hf => hI f (by simp [hf])
      have hw' : ∀ f ∈ L, ∃ y ∈ F.erase z, y ∈ f.denote C := by
        intro f hf
        obtain ⟨y, hyF, hyf⟩ := hw f (by simp [hf])
        have hne : y ≠ z := by
          intro heq
          subst y
          exact hhead f hf (hI e (by simp)) (hItail f hf) z (hF z hzF) hze hyf
        exact ⟨y, Finset.mem_erase.mpr ⟨hne, hyF⟩, hyf⟩
      have ht := ih (F.erase z) hItail htail
        (fun y hy => hF y (Finset.mem_of_mem_erase hy)) hw'
      have hc := Finset.card_erase_add_one hzF
      simp only [List.length_cons]
      omega

variable [Fintype Job] [DecidableEq Job]

def frameData (P : Precedence Job) (a₀ : TemporalBoundary.Boundary Job)
    (Q₀ G₀ : Set Job) : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job) :=
  ⟨P.rank, D P, Pred P, a₀, Q₀, G₀⟩

theorem frame_laws (P : Precedence Job) (a₀ : TemporalBoundary.Boundary Job)
    (Q₀ G₀ : Set Job) :
    FrameLaws (frameData P a₀ Q₀ G₀) P.rel :=
  ⟨fun {_ _} h => (P.rank_strict h).le, D_up P, pred_down P⟩

theorem injection_capacity {P : Precedence Job}
    {a₀ B : TemporalBoundary.Boundary Job} {Q₀ G₀ U V : Set Job}
    {L : List (Entry (TemporalBoundary.Boundary Job))} {F : Finset Job}
    (hB : B = .actual F) (hcard : F.card = 3)
    (hsep : InjectionSeparated (frameData P a₀ Q₀ G₀) U L)
    (hF : ∀ z ∈ F, z ∈ U)
    (hup : ∀ e ∈ L, TemporalBoundary.IsUp P (e.denote (frameData P a₀ Q₀ G₀)))
    (hhigh : V ∩ Qual (frameData P a₀ Q₀ G₀) L ⊆ Pred P B) :
    (injections (prune (frameData P a₀ Q₀ G₀) V L)).length ≤ 3 := by
  classical
  let C := frameData P a₀ Q₀ G₀
  let K := injections (prune C V L)
  have hmem : ∀ e ∈ K, e ∈ L ∧ e.Injection ∧ ∃ x ∈ V, x ∈ e.denote C := by
    intro e he
    have hf := List.mem_filter.mp he
    have hp := List.mem_filter.mp hf.1
    exact ⟨hp.1, (injectionFlag_iff e).mp hf.2,
      @of_decide_eq_true _ (Classical.propDecidable _) hp.2⟩
  have hp : InjectionSeparated C U K := (hsep.prune).filter _
  have hb := injection_length_le_card C U K F
    (fun e he => (hmem e he).2.1) hp hF (by
      intro e he
      obtain ⟨heL, heI, x, hxV, hxe⟩ := hmem e he
      have hxP := hhigh ⟨hxV, e, heL, hxe⟩
      rw [hB] at hxP
      obtain ⟨z, hz, hxz⟩ := hxP
      exact ⟨z, hz, hup e heL hxz hxe⟩)
  simpa only [hcard] using hb

inductive Test (Job : Type*)
  | top | bot
  | descendants (B : TemporalBoundary.Boundary Job)
  | predecessors (B : TemporalBoundary.Boundary Job)
  | weakDescendants (B : TemporalBoundary.Boundary Job)
  | weakPredecessors (B : TemporalBoundary.Boundary Job)
  | triple (B : TemporalBoundary.Boundary Job)
  | ge (r : ℕ)
  | le (r : ℕ)

def Test.denote (P : Precedence Job) : Test Job → Set Job
  | .top => Set.univ
  | .bot => ∅
  | .descendants B => D P B
  | .predecessors B => Pred P B
  | .weakDescendants B => WeakD P B
  | .weakPredecessors B => WeakPred P B
  | .triple B => (B.jobs : Set Job)
  | .ge r => {x | r ≤ P.rank x}
  | .le r => {x | P.rank x ≤ r}

inductive Syntax (Job : Type*)
  | lit (negated opposite : Bool) (test : Test Job)
  | meet (f g : Syntax Job)
  | join (f g : Syntax Job)

def Syntax.denote (P : Precedence Job) : Syntax Job → Set Job
  | .lit false o t => t.denote (if o then P.reverse else P)
  | .lit true o t => (t.denote (if o then P.reverse else P))ᶜ
  | .meet f g => f.denote P ∩ g.denote P
  | .join f g => f.denote P ∪ g.denote P

def Syntax.leaves : Syntax Job → ℕ
  | .lit _ _ _ => 1
  | .meet f g | .join f g => f.leaves + g.leaves

def Syntax.compl : Syntax Job → Syntax Job
  | .lit n o t => .lit (!n) o t
  | .meet f g => .join f.compl g.compl
  | .join f g => .meet f.compl g.compl

def Syntax.flip : Syntax Job → Syntax Job
  | .lit n o t => .lit n (!o) t
  | .meet f g => .meet f.flip g.flip
  | .join f g => .join f.flip g.flip

@[simp] theorem syntax_compl_leaves (f : Syntax Job) : f.compl.leaves = f.leaves := by
  induction f <;> simp_all [Syntax.compl, Syntax.leaves]

@[simp] theorem syntax_flip_leaves (f : Syntax Job) : f.flip.leaves = f.leaves := by
  induction f <;> simp_all [Syntax.flip, Syntax.leaves]

@[simp] theorem syntax_compl_denote (P : Precedence Job) (f : Syntax Job) :
    f.compl.denote P = (f.denote P)ᶜ := by
  induction f with
  | lit n o t => cases n <;> simp [Syntax.compl, Syntax.denote]
  | meet f g ihf ihg =>
      ext x
      simp [Syntax.compl, Syntax.denote, ihf, ihg]
      tauto
  | join f g ihf ihg =>
      ext x
      simp [Syntax.compl, Syntax.denote, ihf, ihg]

theorem rank_reverse_reverse (P : Precedence Job) (x : Job) :
    P.reverse.reverse.rank x = P.rank x := by
  have h := reverse_ranks_sum P x
  have k := reverse_ranks_sum P.reverse x
  omega

theorem Test.double_reverse (P : Precedence Job) (t : Test Job) :
    t.denote P.reverse.reverse = t.denote P := by
  cases t with
  | top | bot | triple _ => rfl
  | descendants B | predecessors B | weakDescendants B | weakPredecessors B =>
      cases B <;> rfl
  | ge r | le r => simp [Test.denote, rank_reverse_reverse]

@[simp] theorem syntax_flip_denote (P : Precedence Job) (f : Syntax Job) :
    f.flip.denote P.reverse = f.denote P := by
  induction f with
  | lit n o t =>
      cases n <;> cases o <;>
        simp [Syntax.flip, Syntax.denote, Test.double_reverse]
  | meet f g ihf ihg => simp [Syntax.flip, Syntax.denote, ihf, ihg]
  | join f g ihf ihg => simp [Syntax.flip, Syntax.denote, ihf, ihg]

def sourceAtom : Atom (TemporalBoundary.Boundary Job) → Test Job
  | .top => .top
  | .bot => .bot
  | .D B => .descendants B
  | .P B => .predecessors B
  | .ge r => .ge r
  | .le r => .le r

def sourceFormula : Formula (TemporalBoundary.Boundary Job) → Syntax Job
  | .lit n t => .lit n false (sourceAtom t)
  | .meet f g => .meet (sourceFormula f) (sourceFormula g)
  | .join f g => .join (sourceFormula f) (sourceFormula g)

@[simp] theorem source_formula_leaves (f : Formula (TemporalBoundary.Boundary Job)) :
    (sourceFormula f).leaves = f.leaves := by
  induction f <;> simp_all [sourceFormula, Syntax.leaves, Formula.leaves]

theorem source_atom_denote (P : Precedence Job) (a₀ : TemporalBoundary.Boundary Job)
    (Q₀ G₀ : Set Job) (t : Atom (TemporalBoundary.Boundary Job)) :
    (sourceAtom t).denote P = t.denote (frameData P a₀ Q₀ G₀) := by
  cases t <;> rfl

@[simp] theorem source_formula_denote (P : Precedence Job)
    (a₀ : TemporalBoundary.Boundary Job) (Q₀ G₀ : Set Job)
    (f : Formula (TemporalBoundary.Boundary Job)) :
    (sourceFormula f).denote P = f.denote (frameData P a₀ Q₀ G₀) := by
  induction f with
  | lit n t =>
      cases n <;> simp only [sourceFormula, Syntax.denote, Bool.false_eq_true,
        ↓reduceIte, Formula.denote, source_atom_denote P a₀ Q₀ G₀ t]
  | meet f g ihf ihg => simp [sourceFormula, Syntax.denote, Formula.denote, ihf, ihg]
  | join f g ihf ihg => simp [sourceFormula, Syntax.denote, Formula.denote, ihf, ihg]

def entrySyntax (a₀ : TemporalBoundary.Boundary Job) (G : Syntax Job) :
    Entry (TemporalBoundary.Boundary Job) → Syntax Job
  | .first k => .meet G (.lit false false (.ge k))
  | e => sourceFormula (simpleFormula a₀ e)

theorem entry_syntax_denote (P : Precedence Job) (a₀ : TemporalBoundary.Boundary Job)
    (Q₀ : Set Job) (G : Syntax Job) (e : Entry (TemporalBoundary.Boundary Job)) :
    (entrySyntax a₀ G e).denote P =
      e.denote (frameData P a₀ Q₀ (G.denote P)) := by
  cases e with
  | first k => rfl
  | root k =>
      change (sourceFormula (simpleFormula a₀ (.root k))).denote P = _
      rw [source_formula_denote P a₀ Q₀ (G.denote P)]
      exact simple_formula_denote _ (.root k) (by trivial)
  | second k =>
      change (sourceFormula (simpleFormula a₀ (.second k))).denote P = _
      rw [source_formula_denote P a₀ Q₀ (G.denote P)]
      exact simple_formula_denote _ (.second k) (by trivial)
  | injection a b k =>
      change (sourceFormula (simpleFormula a₀ (.injection a b k))).denote P = _
      rw [source_formula_denote P a₀ Q₀ (G.denote P)]
      exact simple_formula_denote _ (.injection a b k) (by trivial)

theorem entry_syntax_small (a₀ : TemporalBoundary.Boundary Job) (G : Syntax Job)
    (hG : G.leaves ≤ 24) (e : Entry (TemporalBoundary.Boundary Job)) :
    (entrySyntax a₀ G e).leaves ≤ 25 := by
  cases e with
  | first k => simp only [entrySyntax, Syntax.leaves]; omega
  | root k | second k | injection a b k =>
      simp only [entrySyntax, source_formula_leaves]
      exact (simple_formula_leaves _ _ (by trivial)).trans (by omega)

def listSyntax (a₀ : TemporalBoundary.Boundary Job) (G : Syntax Job) :
    List (Entry (TemporalBoundary.Boundary Job)) → Syntax Job
  | [] => .lit false false .bot
  | e :: L => .join (entrySyntax a₀ G e) (listSyntax a₀ G L)

theorem list_syntax_denote (P : Precedence Job) (a₀ : TemporalBoundary.Boundary Job)
    (Q₀ : Set Job) (G : Syntax Job) (L : List (Entry (TemporalBoundary.Boundary Job))) :
    (listSyntax a₀ G L).denote P =
      Qual (frameData P a₀ Q₀ (G.denote P)) L := by
  induction L with
  | nil => ext x; simp [listSyntax, Syntax.denote, Test.denote]
  | cons e L ih =>
      ext x
      simp [listSyntax, Syntax.denote, entry_syntax_denote P a₀ Q₀, ih]

theorem list_syntax_small (a₀ : TemporalBoundary.Boundary Job) (G : Syntax Job)
    (hG : G.leaves ≤ 24) (L : List (Entry (TemporalBoundary.Boundary Job))) :
    (listSyntax a₀ G L).leaves ≤ 1 + 25 * L.length := by
  induction L with
  | nil => simp [listSyntax, Syntax.leaves]
  | cons e L ih =>
      have he := entry_syntax_small a₀ G hG e
      simp only [listSyntax, Syntax.leaves, List.length_cons]
      omega

def flatUnion (a₀ : BoundaryLabel) : List (Entry BoundaryLabel) → Formula BoundaryLabel
  | .first k :: .second none :: T => .join (flattenedPair a₀ k) (simpleUnion a₀ T)
  | .first k :: T => .join (flattenedPair a₀ k) (simpleUnion a₀ T)
  | L => simpleUnion a₀ L

theorem flat_ordinary (a₀ : BoundaryLabel) {L : List (Entry BoundaryLabel)}
    (h : AllSimple L) : flatUnion a₀ L = simpleUnion a₀ L := by
  cases L with
  | nil => rfl
  | cons e L =>
      have he := h e (by simp)
      cases e <;> try rfl
      exact False.elim he

theorem flat_lone (a₀ : BoundaryLabel) (k : ℕ) {T : List (Entry BoundaryLabel)}
    (h : AllInjections T) :
    flatUnion a₀ (.first k :: T) = .join (flattenedPair a₀ k) (simpleUnion a₀ T) := by
  cases T with
  | nil => rfl
  | cons e T =>
      have he := h e (by simp)
      cases e <;> try rfl
      all_goals exact False.elim he

theorem flat_union_properties {C : SameFrameHistory.Data Job BoundaryLabel}
    {R : Job → Job → Prop} (laws : FrameLaws C R)
    {U : Set Job} {L : List (Entry BoundaryLabel)}
    (shape : Shape C U L) (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀) :
    (flatUnion C.a₀ L).leaves ≤ 1 + 3 * L.length ∧
      SameFrameHistory.IsUp R ((flatUnion C.a₀ L).denote C) ∧
      ∀ x ∈ U, x ∈ (flatUnion C.a₀ L).denote C ↔ x ∈ Qual C L := by
  cases shape with
  | ordinary hs =>
      rw [flat_ordinary _ hs]
      exact ⟨simple_union_leaves _ hs, simple_union_up laws hs,
        fun _ _ => by rw [simple_union_denote C hs]⟩
  | paired k T ht hu =>
      simp only [flatUnion]
      refine ⟨?_, up_union (flattened_pair_up laws k)
        (simple_union_up laws (injections_simple ht)), ?_⟩
      · have hb := simple_union_leaves C.a₀ (injections_simple ht)
        simp only [Formula.leaves, flattenedPair, List.length_cons]
        omega
      · intro x hx
        have heq := pair_flattening C U k hu coverage x hx
        simp only [Set.mem_union] at heq
        rw [Formula.denote, simple_union_denote C (injections_simple ht)]
        simp only [mem_qual_cons, Entry.denote, threshold]
        change (x ∈ (flattenedPair C.a₀ k).denote C ∨ x ∈ Qual C T) ↔ _
        tauto
  | lone k T ht hu hd =>
      rw [flat_lone _ _ ht]
      refine ⟨?_, up_union (flattened_pair_up laws k)
        (simple_union_up laws (injections_simple ht)), ?_⟩
      · have hb := simple_union_leaves C.a₀ (injections_simple ht)
        simp only [Formula.leaves, flattenedPair, List.length_cons]
        omega
      · intro x hx
        have heq := lone_flattening C U k hu coverage hd x hx
        rw [Formula.denote, simple_union_denote C (injections_simple ht), mem_qual_cons]
        exact or_congr heq.symm Iff.rfl

def historicalSyntax (a₀ b : TemporalBoundary.Boundary Job)
    (L : List (Entry (TemporalBoundary.Boundary Job))) (cut : Cut) : Syntax Job :=
  sourceFormula (lowFormula b (flatUnion a₀ (carry L cut)))

theorem historical_syntax_properties {P : Precedence Job}
    {a₀ a b : TemporalBoundary.Boundary Job} {Q₀ G₀ U : Set Job}
    {L : List (Entry (TemporalBoundary.Boundary Job))}
    (run : Run (frameData P a₀ Q₀ G₀) U L)
    (coverage : Q₀ \ D P a₀ ⊆ G₀) (five : L.length ≤ 5)
    (hI1 : LocalI1 (frameData P a₀ Q₀ G₀) U L a b) (cut : Cut) :
    (historicalSyntax a₀ b L cut).leaves ≤ 21 ∧
      TemporalBoundary.IsDown P ((historicalSyntax a₀ b L cut).denote P) ∧
      ∀ x ∈ U, x ∈ (historicalSyntax a₀ b L cut).denote P ↔
        x ∈ priorityLow (frameData P a₀ Q₀ G₀) U L cut b := by
  let C := frameData P a₀ Q₀ G₀
  obtain ⟨hsize, hup, heq⟩ :=
    flat_union_properties (frame_laws P a₀ Q₀ G₀) (run.carry_shape cut) coverage
  change (flatUnion a₀ (carry L cut)).leaves ≤ 1 + 3 * (carry L cut).length at hsize
  have hlen := carry_length L cut
  refine ⟨?_, ?_, ?_⟩
  · simp only [historicalSyntax, source_formula_leaves, low_formula_leaves]
    omega
  · rw [historicalSyntax, source_formula_denote P a₀ Q₀ G₀, low_formula_denote]
    exact down_diff_up (pred_down P b) hup
  · intro x hx
    rw [historicalSyntax, source_formula_denote P a₀ Q₀ G₀, low_formula_denote,
      priority_low_eq_historical hI1 cut]
    have hh := heq x hx
    rw [carry_selected_by_key] at hh
    simp only [historicalLow, Set.mem_inter_iff, Set.mem_sdiff, hx, true_and]
    exact and_congr_right (fun _ => not_congr hh)

noncomputable def sameGroup (C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job))
    (L : List (Entry (TemporalBoundary.Boundary Job))) (b : TemporalBoundary.Boundary Job)
    (x : Job) : ℕ :=
  if x ∈ Qual C L then 1 else if x ∈ C.P b then 0 else 2

noncomputable def samePriority
    (C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job))
    (L : List (Entry (TemporalBoundary.Boundary Job))) (b : TemporalBoundary.Boundary Job)
    (x y : Job) : Prop :=
  sameGroup C L b x < sameGroup C L b y ∨
    (sameGroup C L b x = sameGroup C L b y ∧
      if sameGroup C L b x = 1 then lexKey C L x < lexKey C L y
      else C.rank x < C.rank y)

def switchPriority (P : Precedence Job) (A : TemporalBoundary.Boundary Job)
    (x y : Job) : Prop :=
  (x ∉ D P A ∧ y ∈ D P A) ∨
    ((x ∈ D P A ↔ y ∈ D P A) ∧ P.rank x < P.rank y)

structure Creation {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (ending : TemporalBoundary.Boundary Job) (c d : ℤ) where
  outerLeft : TemporalBoundary.Boundary Job
  outerRight : TemporalBoundary.Boundary Job
  u : ℤ
  v : ℤ
  w : ℤ
  center : Finset Job
  low : Set Job
  centerLow : Set Job
  extension : Syntax Job
  directCutoff : Syntax Job
  outerLeft_placed : Placed σ outerLeft u
  outerRight_placed : Placed σ outerRight w
  center_placed : Placed σ (.actual center) v
  right_actual : ∃ F, ending = .actual F
  center_interior : u < v ∧ v < w
  left_range : u ≤ c
  right_before_center : d ≤ v
  center_separator : Separator σ (Inside σ u w) centerLow (.actual center) v
  endpoint_separator : Separator σ (Inside σ u v) low ending d

structure Creation.Valid {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {ending : TemporalBoundary.Boundary Job} {c d : ℤ}
    (s : Creation σ ending c d) : Prop where
  extension_down : TemporalBoundary.IsDown P (s.extension.denote P)
  extension_agreement : ∀ x ∈ Inside σ s.u s.w,
    x ∈ s.extension.denote P ↔ x ∈ s.low
  extension_small : s.extension.leaves ≤ 21
  direct_agreement : ∀ x ∈ Inside σ s.u s.w,
    x ∈ s.directCutoff.denote P ↔ x ∈ s.low
  direct_small : s.directCutoff.leaves ≤ 205
  cutoff_cone : ∀ x ∈ Inside σ s.u s.w, x ∈ s.low → x ∈ Pred P s.outerRight
  cutoff_center : ∀ x ∈ Inside σ s.u s.w, x ∈ s.low → x ∈ s.centerLow

structure RawNode (Job : Type*) [Fintype Job] [DecidableEq Job] (T : ℕ) where
  frame : Precedence Job
  schedule : Schedule frame T
  left : TemporalBoundary.Boundary Job
  right : TemporalBoundary.Boundary Job
  a : ℤ
  b : ℤ
  left_placed : Placed schedule left a
  right_placed : Placed schedule right b
  ordered : a < b
  originLeft : TemporalBoundary.Boundary Job
  originParent : Set Job
  origin : Syntax Job
  list : List (Entry (TemporalBoundary.Boundary Job))
  incoming : Option (Creation schedule right a b)

def RawNode.data {T : ℕ} (N : RawNode Job T) :
    SameFrameHistory.Data Job (TemporalBoundary.Boundary Job) :=
  frameData N.frame N.originLeft N.originParent (N.origin.denote N.frame)

def RawNode.domain {T : ℕ} (N : RawNode Job T) : Set Job :=
  Inside N.schedule N.a N.b

def RawNode.qualifiers {T : ℕ} (N : RawNode Job T) : Set Job :=
  Qual N.data N.list

noncomputable def RawNode.key {T : ℕ} (N : RawNode Job T) (x : Job) : ℕ ×ₗ ℕ :=
  lexKey N.data N.list x

def rawRoot {T : ℕ} (P : Precedence Job) (σ : Schedule P T) : RawNode Job T where
  frame := P
  schedule := σ
  left := .left
  right := .right
  a := 0
  b := (T : ℤ) + 1
  left_placed := rfl
  right_placed := rfl
  ordered := by omega
  originLeft := .left
  originParent := Set.univ
  origin := .lit false false .top
  list := [.root none]
  incoming := none

noncomputable def sameLow {T : ℕ} (N : RawNode Job T) (σ : Schedule N.frame T)
    (cut : Cut) : Set Job :=
  priorityLow N.data (Inside σ N.a N.b) N.list cut N.right

def sameCenterLow {T : ℕ} (N : RawNode Job T) (σ : Schedule N.frame T) : Set Job :=
  Inside σ N.a N.b ∩ Pred N.frame N.right

def CutAttained (C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job))
    (U : Set Job) (L : List (Entry (TemporalBoundary.Boundary Job))) : Cut → Prop
  | none => True
  | some (d, r) => ∃ x ∈ U, x ∈ Qual C L ∧ SameFrameHistory.key C L x = (d + 1, r)

structure RawSameData {T : ℕ} (N : RawNode Job T) where
  prepared : Schedule N.frame T
  preparation : Reorders N.schedule prepared N.a N.b
  priority : Priority N.frame
  priority_protocol : ∀ x ∈ Inside prepared N.a N.b, ∀ y ∈ Inside prepared N.a N.b,
    priority.index x < priority.index y ↔ samePriority N.data N.list N.right x y
  center : Finset Job
  v : ℤ
  center_placed : Placed prepared (.actual center) v
  center_interior : N.a < v ∧ v < N.b
  center_separator : Separator prepared (Inside prepared N.a N.b)
    (sameCenterLow N prepared) (.actual center) v
  cut : Cut
  cut_attained : CutAttained N.data (Inside prepared N.a N.b) N.list cut
  childLeft : TemporalBoundary.Boundary Job
  childRight : Finset Job
  c : ℤ
  d : ℤ
  right_placed : Placed prepared (.actual childRight) d
  nonempty_child : (Inside prepared c d).Nonempty
  right_before_center : d ≤ v
  walk : ExceptionWalk prepared priority N.a v (sameLow N prepared cut) N.left childLeft c
  left_separator : Separator prepared (Inside prepared N.a v) (sameLow N prepared cut) childLeft c
  right_separator : Separator prepared (Inside prepared N.a v) (sameLow N prepared cut)
    (.actual childRight) d
  normalized : Normalized prepared priority N.a v

theorem placed_outside_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} {B : TemporalBoundary.Boundary Job}
    (h : Reorders σ τ a b) (hr : r ≤ a ∨ b ≤ r) (hB : Placed σ B r) :
    Placed τ B r := by
  cases B with
  | left | right => exact hB
  | actual F =>
      refine ⟨hB.1, fun x => ?_⟩
      rw [hB.2 x]
      by_cases hx : x ∈ Inside σ a b
      · have ht := (h.1 x).mp hx
        dsimp [Inside] at hx ht
        rcases hr with hr | hr <;> constructor <;> intro he <;> omega
      · rw [h.2 x hx]

noncomputable def RawSameData.creation {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) : Creation e.prepared (.actual e.childRight) e.c e.d where
  outerLeft := N.left
  outerRight := N.right
  u := N.a
  v := e.v
  w := N.b
  center := e.center
  low := sameLow N e.prepared e.cut
  centerLow := sameCenterLow N e.prepared
  extension := historicalSyntax N.originLeft N.right N.list e.cut
  directCutoff := .meet (.lit false false (.predecessors N.right))
    (listSyntax N.originLeft N.origin (carry N.list e.cut)).compl
  outerLeft_placed := walk_initial_placed e.walk
  outerRight_placed :=
    placed_outside_reorders e.preparation (Or.inr le_rfl) N.right_placed
  center_placed := e.center_placed
  right_actual := ⟨e.childRight, rfl⟩
  center_interior := e.center_interior
  left_range := by
    rcases walk_start_or_interior e.walk with h | h
    · exact h.2.ge
    · exact h.1.le
  right_before_center := e.right_before_center
  center_separator := e.center_separator
  endpoint_separator := e.right_separator

noncomputable def RawSameData.child {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) : RawNode Job T where
  frame := N.frame
  schedule := e.prepared
  left := e.childLeft
  right := .actual e.childRight
  a := e.c
  b := e.d
  left_placed := walk_placed e.walk
  right_placed := e.right_placed
  ordered := by obtain ⟨x, hx⟩ := e.nonempty_child; exact hx.1.trans hx.2
  originLeft := N.originLeft
  originParent := N.originParent
  origin := N.origin
  list := prune N.data (Inside e.prepared e.c e.d)
    (carry N.list e.cut ++ [.injection N.left N.right none])
  incoming := some e.creation

theorem separator_double_reverse {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {domain low : Set Job} {B : TemporalBoundary.Boundary Job} {r : ℤ}
    (h : Separator σ domain low B r) :
    Separator σ.reverse.reverse domain low B.reverse.reverse
      (reverseTime T (reverseTime T r)) := by
  constructor
  · intro x hx hxl hxt
    have ht : σ.time x < r := by
      dsimp [Schedule.reverse, reverseTime] at hxt
      omega
    simpa only [pred_reverse, D_reverse] using h.earlier_high x hx hxl ht
  · intro x hx hxl hxt
    have ht : r < σ.time x := by
      dsimp [Schedule.reverse, reverseTime] at hxt
      omega
    simpa only [D_reverse, pred_reverse] using h.later_low x hx hxl ht

noncomputable def Creation.incoming {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {c d : ℤ}
    (s : Creation σ B c d) (hs : s.Valid) (hB : Placed σ B d) (hcd : c < d)
    (τ : Schedule P.reverse T)
    (hprep : Reorders σ.reverse τ (reverseTime T d) (reverseTime T c)) :
    IncomingAncestor τ B.reverse (reverseTime T d) (reverseTime T c) where
  oldWitness := σ.reverse
  ancestorLeft := s.outerRight.reverse
  ancestorRight := s.outerLeft.reverse
  oldCenter := (TemporalBoundary.Boundary.actual s.center).reverse
  u := reverseTime T s.w
  v := reverseTime T s.v
  w := reverseTime T s.u
  historicalLow := s.low
  centerLow := s.centerLow
  extension := s.extension.denote P
  ancestorLeft_placed := placed_reverse s.outerRight_placed
  ancestorRight_placed := placed_reverse s.outerLeft_placed
  endpoint_placed := placed_reverse hB
  center_placed := placed_reverse s.center_placed
  endpoint_actual := by
    obtain ⟨F, hF⟩ := s.right_actual
    exact ⟨F, by simp only [hF, TemporalBoundary.Boundary.reverse]⟩
  center_actual := ⟨s.center, rfl⟩
  ancestry := by
    have hu := s.left_range
    have hd := s.right_before_center
    have hv := s.center_interior.2
    refine ⟨?_, ?_, ?_, ?_⟩ <;> dsimp [reverseTime] <;> omega
  confined_changes := hprep
  center_separator := by
    rw [inside_reverse]
    exact separator_double_reverse s.center_separator
  endpoint_separator := by
    rw [inside_reverse]
    exact separator_double_reverse s.endpoint_separator
  cutoff_old_cone := by
    rw [inside_reverse]
    intro x hx hxl
    simpa only [pred_reverse, D_reverse] using hs.cutoff_cone x hx hxl
  cutoff_center := by
    rw [inside_reverse]
    exact hs.cutoff_center
  extension_agreement := by
    rw [inside_reverse]
    exact hs.extension_agreement
  extension_up := fun {_ _} hxy hx => hs.extension_down hxy hx

def creationSwitchSyntax {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {c d : ℤ} (s : Creation σ B c d)
    (A : TemporalBoundary.Boundary Job) : Syntax Job :=
  .meet (.lit false false (.descendants s.outerRight.reverse))
    (.meet (.lit true false (.weakPredecessors A))
      (.meet (.lit true false (.weakPredecessors (.actual s.center)))
        s.extension.flip))

theorem creation_switch_denote {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {c d : ℤ} (s : Creation σ B c d)
    (hs : s.Valid) (hB : Placed σ B d) (hcd : c < d)
    (τ : Schedule P.reverse T)
    (hprep : Reorders σ.reverse τ (reverseTime T d) (reverseTime T c)) :
    (creationSwitchSyntax s B.reverse).denote P.reverse =
      (s.incoming hs hB hcd τ hprep).G := by
  ext x
  simp [creationSwitchSyntax, Syntax.denote, Test.denote,
    IncomingAncestor.G, switchG, Creation.incoming]
  tauto

def switchLow {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (A : TemporalBoundary.Boundary Job) (r : ℕ) : Set Job :=
  {x | x ∈ Inside σ a b ∧ x ∉ D P A ∧ P.rank x ≤ r}

def switchCenterLow {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) (A : TemporalBoundary.Boundary Job) : Set Job :=
  Inside σ a b \ D P A

structure RawSwitchData {T : ℕ} (N : RawNode Job T) where
  prepared : Schedule N.frame.reverse T
  preparation : Reorders N.schedule.reverse prepared (reverseTime T N.b) (reverseTime T N.a)
  creation : Creation N.schedule N.right N.a N.b
  chronology : N.incoming = some creation
  priority : Priority N.frame.reverse
  priority_protocol : ∀ x ∈ Inside prepared (reverseTime T N.b) (reverseTime T N.a),
    ∀ y ∈ Inside prepared (reverseTime T N.b) (reverseTime T N.a),
    priority.index x < priority.index y ↔
      switchPriority N.frame.reverse N.right.reverse x y
  center : Finset Job
  v : ℤ
  center_placed : Placed prepared (.actual center) v
  center_interior : reverseTime T N.b < v ∧ v < reverseTime T N.a
  center_separator : Separator prepared
    (Inside prepared (reverseTime T N.b) (reverseTime T N.a))
    (switchCenterLow prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse)
    (.actual center) v
  r : ℕ
  rank_bound : r ≤ Fintype.card Job
  rank_attained : r = 0 ∨ ∃ x ∈ Inside prepared (reverseTime T N.b) (reverseTime T N.a),
    x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x = r
  childLeft : TemporalBoundary.Boundary Job
  childRight : Finset Job
  c : ℤ
  d : ℤ
  right_placed : Placed prepared (.actual childRight) d
  nonempty_child : (Inside prepared c d).Nonempty
  right_before_center : d ≤ v
  walk : ExceptionWalk prepared priority (reverseTime T N.b) v
    (switchLow prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse r)
    N.right.reverse childLeft c
  left_separator : Separator prepared (Inside prepared (reverseTime T N.b) v)
    (switchLow prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse r) childLeft c
  right_separator : Separator prepared (Inside prepared (reverseTime T N.b) v)
    (switchLow prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse r)
    (.actual childRight) d
  normalized : Normalized prepared priority (reverseTime T N.b) v

def RawSwitchData.data {T : ℕ} {N : RawNode Job T} (e : RawSwitchData N) :
    SameFrameHistory.Data Job (TemporalBoundary.Boundary Job) :=
  frameData N.frame.reverse N.right.reverse
    (Inside e.prepared (reverseTime T N.b) (reverseTime T N.a))
    ((creationSwitchSyntax e.creation N.right.reverse).denote N.frame.reverse)

def RawSwitchData.creationRecord {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) : Creation e.prepared (.actual e.childRight) e.c e.d where
  outerLeft := N.right.reverse
  outerRight := N.left.reverse
  u := reverseTime T N.b
  v := e.v
  w := reverseTime T N.a
  center := e.center
  low := switchLow e.prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse e.r
  centerLow := switchCenterLow e.prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse
  extension := sourceFormula (switchedLowFormula N.right.reverse e.r)
  directCutoff := sourceFormula (switchedLowFormula N.right.reverse e.r)
  outerLeft_placed := walk_initial_placed e.walk
  outerRight_placed := placed_outside_reorders e.preparation (Or.inr le_rfl)
    (placed_reverse N.left_placed)
  center_placed := e.center_placed
  right_actual := ⟨e.childRight, rfl⟩
  center_interior := e.center_interior
  left_range := by
    rcases walk_start_or_interior e.walk with h | h
    · exact h.2.ge
    · exact h.1.le
  right_before_center := e.right_before_center
  center_separator := e.center_separator
  endpoint_separator := e.right_separator

noncomputable def RawSwitchData.child {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) : RawNode Job T where
  frame := N.frame.reverse
  schedule := e.prepared
  left := e.childLeft
  right := .actual e.childRight
  a := e.c
  b := e.d
  left_placed := walk_placed e.walk
  right_placed := e.right_placed
  ordered := by obtain ⟨x, hx⟩ := e.nonempty_child; exact hx.1.trans hx.2
  originLeft := N.right.reverse
  originParent := Inside e.prepared (reverseTime T N.b) (reverseTime T N.a)
  origin := creationSwitchSyntax e.creation N.right.reverse
  list := prune e.data (Inside e.prepared e.c e.d) [.first (e.r + 1), .second none]
  incoming := some e.creationRecord

inductive RawHistory {T : ℕ} : RawNode Job T → Prop
  | root (P : Precedence Job) (σ : Schedule P T) : RawHistory (rawRoot P σ)
  | same {N : RawNode Job T} (past : RawHistory N) (e : RawSameData N) : RawHistory e.child
  | switched {N : RawNode Job T} (past : RawHistory N) (e : RawSwitchData N) : RawHistory e.child

structure Derived {T : ℕ} (N : RawNode Job T) : Prop where
  run : Run N.data N.domain N.list
  origin_up : TemporalBoundary.IsUp N.frame (N.origin.denote N.frame)
  origin_coverage : N.originParent \ D N.frame N.originLeft ⊆ N.origin.denote N.frame
  origin_small : N.origin.leaves ≤ 24
  localI1 : LocalI1 N.data N.domain N.list N.left N.right
  separated : InjectionSeparated N.data N.domain N.list
  five : N.list.length ≤ 5
  I2 : TemporalBoundary.I2 N.schedule N.left N.a N.qualifiers
  I3 : TemporalBoundary.I3 N.schedule N.left N.a N.b N.qualifiers N.key
  high_identity : ∀ s, N.incoming = some s → ∀ x ∈ N.domain,
    x ∈ N.qualifiers ↔ x ∉ s.low
  incoming : ∀ s, N.incoming = some s → s.Valid

theorem same_pre_priority
    {C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job)}
    {U : Set Job} {L : List (Entry (TemporalBoundary.Boundary Job))}
    {a b : TemporalBoundary.Boundary Job} (hI1 : LocalI1 C U L a b) (cut : Cut)
    {x y : Job} (hxU : x ∈ U) (hyU : y ∈ U)
    (hx : x ∈ Qual C (carry L cut ++ [.injection a b none]))
    (hy : y ∈ Qual C (carry L cut ++ [.injection a b none]))
    (hkey : lexKey C (carry L cut ++ [.injection a b none]) x <
      lexKey C (carry L cut ++ [.injection a b none]) y) :
    samePriority C L b x y := by
  let e : Entry (TemporalBoundary.Boundary Job) := .injection a b none
  let K := carry L cut
  have hno : ∀ z ∈ U, z ∈ e.denote C → z ∉ Qual C L := by
    intro z hz hze hzQ
    exact hze.2 (hI1.old_high ⟨hz, hzQ⟩)
  have hunion : Qual C (K ++ [e]) = Qual C K ∪ e.denote C := by
    ext z
    simp
  change x ∈ Qual C (K ++ [e]) at hx
  change y ∈ Qual C (K ++ [e]) at hy
  rw [hunion] at hx hy
  by_cases hxI : x ∈ e.denote C
  · have hxold := hno x hxU hxI
    have hxgroup : sameGroup C L b x = 2 := by
      simp [sameGroup, hxold, hxI.2]
    have hxi := append_index_inside C K e hxI
    by_cases hyI : y ∈ e.denote C
    · have hyold := hno y hyU hyI
      have hygroup : sameGroup C L b y = 2 := by
        simp [sameGroup, hyold, hyI.2]
      have hyi := append_index_inside C K e hyI
      have hr : C.rank x < C.rank y := by
        rw [lexKey_lt_iff, hxi, hyi] at hkey
        simpa using hkey
      simp [samePriority, hxgroup, hygroup, hr]
    · have hyK := hy.resolve_right hyI
      have hyi : largestIndex C (K ++ [e]) y = largestIndex C K y := by
        have := congrArg (fun k : ℕ ×ₗ ℕ => (ofLex k).1) (append_key_without C K e hyI)
        exact this
      have hybound := largest_index_le_length C K y
      rw [lexKey_lt_iff, hxi, hyi] at hkey
      rcases hkey with hlt | ⟨heq, _⟩ <;> omega
  · have hxK := hx.resolve_right hxI
    have hxold := carry_subset C L cut hxK
    have hxgroup : sameGroup C L b x = 1 := by simp [sameGroup, hxold]
    by_cases hyI : y ∈ e.denote C
    · have hyold := hno y hyU hyI
      have hygroup : sameGroup C L b y = 2 := by simp [sameGroup, hyold, hyI.2]
      simp [samePriority, hxgroup, hygroup]
    · have hyK := hy.resolve_right hyI
      have hyold := carry_subset C L cut hyK
      have hygroup : sameGroup C L b y = 1 := by simp [sameGroup, hyold]
      rw [append_key_without C K e hxI, append_key_without C K e hyI] at hkey
      have hold := (carry_key_order C L cut hxK hyK).mp hkey
      simp [samePriority, hxgroup, hygroup, hold]

theorem switch_pair_union {P : Precedence Job}
    {a₀ : TemporalBoundary.Boundary Job} {U G : Set Job}
    (coverage : U \ D P a₀ ⊆ G) (r : ℕ) {x : Job} (hx : x ∈ U) :
    x ∈ Qual (frameData P a₀ U G) [.first (r + 1), .second none] ↔
      ¬ (x ∈ U ∧ x ∉ D P a₀ ∧ P.rank x ≤ r) := by
  by_cases hd : x ∈ D P a₀
  · simp [Entry.denote, threshold, frameData, hd]
  · have hg := coverage ⟨hx, hd⟩
    simp [Entry.denote, threshold, frameData, suffix, hd, hg, hx]

theorem switch_pair_index {P : Precedence Job}
    {a₀ : TemporalBoundary.Boundary Job} {U G : Set Job} (h : ℕ) {x : Job}
    (hx : x ∈ Qual (frameData P a₀ U G) [.first h, .second none]) :
    largestIndex (frameData P a₀ U G) [.first h, .second none] x =
      if x ∈ D P a₀ then 2 else 1 := by
  classical
  by_cases hd : x ∈ D P a₀
  · simp [largestIndex, Entry.denote, threshold, frameData, hd]
  · have hg : x ∈ (Entry.first h).denote (frameData P a₀ U G) := by
      simpa [Entry.denote, threshold, frameData, hd] using hx
    simp [largestIndex, Entry.denote, threshold, frameData, hd] at hg ⊢
    exact hg

theorem switch_pre_priority {P : Precedence Job}
    {a₀ : TemporalBoundary.Boundary Job} {U G : Set Job} (h : ℕ) {x y : Job}
    (hx : x ∈ Qual (frameData P a₀ U G) [.first h, .second none])
    (hy : y ∈ Qual (frameData P a₀ U G) [.first h, .second none])
    (hkey : lexKey (frameData P a₀ U G) [.first h, .second none] x <
      lexKey (frameData P a₀ U G) [.first h, .second none] y) :
    switchPriority P a₀ x y := by
  rw [lexKey_lt_iff, switch_pair_index h hx, switch_pair_index h hy] at hkey
  by_cases hxD : x ∈ D P a₀ <;> by_cases hyD : y ∈ D P a₀ <;>
    simp_all [switchPriority, frameData]

theorem qualifier_up {P : Precedence Job}
    {a₀ : TemporalBoundary.Boundary Job} {Q₀ G : Set Job}
    (hG : TemporalBoundary.IsUp P G)
    (L : List (Entry (TemporalBoundary.Boundary Job))) :
    TemporalBoundary.IsUp P (Qual (frameData P a₀ Q₀ G) L) := by
  rintro x y hxy ⟨e, he, hxe⟩
  exact ⟨e, he, entry_up (frame_laws P a₀ Q₀ G) hG e hxy hxe⟩

theorem localI1_of_exact_update {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {a v c d : ℤ}
    {B R a₀ : TemporalBoundary.Boundary Job} {Q₀ G S : Set Job}
    {M : List (Entry (TemporalBoundary.Boundary Job))}
    (hac : a ≤ c) (hdv : d ≤ v)
    (hleft : Separator σ (Inside σ a v) S B c)
    (hright : Separator σ (Inside σ a v) S R d)
    (hunion : ∀ x ∈ Inside σ a v,
      x ∈ Qual (frameData P a₀ Q₀ G) M ↔ x ∉ S) :
    LocalI1 (frameData P a₀ Q₀ G) (Inside σ c d)
      (prune (frameData P a₀ Q₀ G) (Inside σ c d) M) B R := by
  let C := frameData P a₀ Q₀ G
  have hchild : Inside σ c d ⊆ Inside σ a v :=
    fun _ hx => ⟨lt_of_le_of_lt hac hx.1, lt_of_lt_of_le hx.2 hdv⟩
  constructor
  · rintro x ⟨hx, hxQ⟩
    exact hright.earlier_high x (hchild hx)
      ((hunion x (hchild hx)).mp (prune_subset C _ M hxQ)) hx.2
  · rintro x ⟨hx, hxQ⟩
    have hxlow : x ∈ S := by
      by_contra hn
      have hpre := (hunion x (hchild hx)).mpr hn
      have heq := congrArg (fun A : Set Job => x ∈ A) (prune_local C (Inside σ c d) M)
      exact hxQ ((Iff.of_eq heq).mpr ⟨hx, hpre⟩).2
    exact hleft.later_low x (hchild hx) hxlow hx.1

theorem same_update_I3_literal {P : Precedence Job} {T : ℕ}
    {OldKey PreKey ChildKey : Type*} [LT OldKey] [LT PreKey] [LT ChildKey]
    {parent σ : Schedule P T} {π : Priority P} {a b v c d : ℤ}
    {S Q C childQ : Set Job} {A B outerRight : TemporalBoundary.Boundary Job}
    {oldKey : Job → OldKey} {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hdv : d ≤ v) (hvb : v ≤ b)
    (hprep : Reorders parent σ a b) (hI3 : I3 parent A a b Q oldKey)
    (hCQ : C ⊆ Q)
    (hlist : ListOrderInterface σ π a v c d B
      (C ∪ injection P A outerRight) childQ preKey childKey)
    -- Appending an injection need not preserve carry comparisons outside these guards.
    (comparison_at_exterior : ∀ x ∈ C, x ∉ D P A →
      ∀ y ∈ A.jobs, y ∈ C → preKey x < preKey y → oldKey x < oldKey y) :
    I3 σ B c d childQ childKey := by
  rcases walk_start_or_interior hwalk with ⟨rfl, rfl⟩ | hinside
  · intro τ hτ x hx hxD y hy hyQ hkey
    have hxσ := (hτ.1 x).mpr hx
    have hxQ := hlist.localI1 x hxσ hxD
    have hxC : x ∈ C := by
      rcases hlist.pruning_subset hxQ with h | h
      · exact h
      · exact False.elim (hxD h.1)
    have hyC : y ∈ C := by
      rcases hlist.pruning_subset hyQ with h | h
      · exact h
      · exact False.elim (at_not_D (walk_initial_placed hwalk)
          (boundary_jobs_time (walk_initial_placed hwalk) hy).le h.1)
    apply hI3 τ (reorders_trans hprep (reorders_enlarge hτ le_rfl (hdv.trans hvb)))
      x ⟨hx.1, lt_of_lt_of_le hx.2 (hdv.trans hvb)⟩ hxD y hy (hCQ hyC)
    exact comparison_at_exterior x hxC hxD y hy hyC
      (hlist.pruning_comparison x hxσ hxQ y hyQ hkey)
  · exact advanced_child_I3 hn (walk_placed hwalk) hinside.1 hdv hlist

theorem root_domain {P : Precedence Job} {T : ℕ} (σ : Schedule P T) :
    Inside σ 0 ((T : ℤ) + 1) = Set.univ := by
  ext x
  have hr := σ.complete.range x
  simp only [Inside, Set.mem_setOf_eq, Set.mem_univ, iff_true]
  constructor <;> omega

theorem root_derived {P : Precedence Job} {T : ℕ} (σ : Schedule P T) :
    Derived (rawRoot P σ) := by
  constructor
  · change Run _ (Inside σ 0 ((T : ℤ) + 1)) [.root none]
    rw [root_domain]
    exact .root
  · intro x y hxy hx
    trivial
  · intro x hx
    trivial
  · exact Nat.le_of_lt (by decide : 1 < 24)
  · constructor
    · intro x hx; trivial
    · intro x hx; trivial
  · simp [RawNode.domain, rawRoot, InjectionSeparated]
  · change (1 : ℕ) ≤ 5
    omega
  · intro x hx htime
    have hr := (σ.complete.range x).1
    change σ.time x ≤ 0 at htime
    omega
  · intro τ hτ x hx hxD y hy
    simp [rawRoot, TemporalBoundary.Boundary.jobs] at hy
  · intro s hs
    cases hs
  · intro s hs
    cases hs

theorem placed_actual_range {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {F : Finset Job} {v : ℤ} (h : Placed σ (.actual F) v) :
    1 ≤ v ∧ v ≤ (T : ℤ) := by
  have hc : F.card = 3 := h.1
  have hnonempty : F.Nonempty := Finset.card_pos.mp (by omega)
  obtain ⟨x, hx⟩ := hnonempty
  have heq := (h.2 x).mp hx
  simpa only [heq] using σ.complete.range x

theorem RawSameData.parent_domain {T : ℕ} {N : RawNode Job T} (e : RawSameData N) :
    N.domain = Inside e.prepared N.a N.b :=
  Set.ext e.preparation.1

theorem RawSameData.parent_localI1 {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    LocalI1 N.data (Inside e.prepared N.a N.b) N.list N.left N.right := by
  rw [← e.parent_domain]
  exact h.localI1

theorem RawSameData.child_inside {T : ℕ} {N : RawNode Job T} (e : RawSameData N) :
    Inside e.prepared e.c e.d ⊆ Inside e.prepared N.a N.b := by
  intro x hx
  exact ⟨lt_of_le_of_lt e.creation.left_range hx.1,
    lt_of_lt_of_le hx.2 (e.right_before_center.trans e.center_interior.2.le)⟩

theorem RawSameData.pre_union {T : ℕ} {N : RawNode Job T} (e : RawSameData N) :
    Qual N.data (carry N.list e.cut ++ [.injection N.left N.right none]) =
      Qual N.data (carry N.list e.cut) ∪ injection N.frame N.left N.right := by
  ext x
  simp [Entry.denote, threshold, RawNode.data, frameData, injection]

theorem RawSameData.high_union {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    ∀ x ∈ Inside e.prepared N.a N.b,
      x ∈ Qual N.data (carry N.list e.cut ++ [.injection N.left N.right none]) ↔
        x ∉ sameLow N e.prepared e.cut := by
  rw [e.pre_union]
  exact same_high_union (e.parent_localI1 h) e.cut

theorem RawSameData.child_localI1 {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    LocalI1 N.data (Inside e.prepared e.c e.d)
      (prune N.data (Inside e.prepared e.c e.d)
        (carry N.list e.cut ++ [.injection N.left N.right none]))
      e.childLeft (.actual e.childRight) := by
  apply localI1_of_exact_update e.creation.left_range e.right_before_center
    e.left_separator e.right_separator
  intro x hx
  exact e.high_union h x ⟨hx.1, hx.2.trans e.center_interior.2⟩

theorem RawSameData.list_order {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    ListOrderInterface e.prepared e.priority N.a e.v e.c e.d e.childLeft
      (Qual N.data (carry N.list e.cut) ∪ injection N.frame N.left N.right)
      e.child.qualifiers
      (lexKey N.data (carry N.list e.cut ++ [.injection N.left N.right none]))
      e.child.key := by
  constructor
  · rw [← e.pre_union]
    exact prune_subset N.data _ _
  · intro x hx hxD
    by_contra hn
    exact hxD ((e.child_localI1 h).old_low ⟨hx, hn⟩)
  · intro x hx hxQ y hyQ hkey
    exact prune_comparison N.data _ _ hx hxQ hyQ hkey
  · intro x hx hxQ y hy hyQ hkey
    have hxU : x ∈ Inside e.prepared N.a N.b := ⟨hx.1, hx.2.trans e.center_interior.2⟩
    have hyU : y ∈ Inside e.prepared N.a N.b := ⟨hy.1, hy.2.trans e.center_interior.2⟩
    apply (e.priority_protocol x hxU y hyU).mpr
    rw [← e.pre_union] at hxQ hyQ
    exact same_pre_priority (e.parent_localI1 h) e.cut hxU hyU hxQ hyQ hkey

theorem RawSameData.child_I2 {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    I2 e.prepared e.childLeft e.c e.child.qualifiers := by
  have hCup := qualifier_up (a₀ := N.originLeft) (Q₀ := N.originParent)
    h.origin_up (carry N.list e.cut)
  apply same_update_I2 (outerRight := N.right) e.walk e.normalized e.center_interior.1
    ((placed_actual_range e.center_placed).2.trans (by omega))
    e.center_interior.2.le e.preparation h.I2 h.I3 hCup (carry_subset N.data N.list e.cut)
  · intro y hy hyC
    apply (e.high_union h y ⟨hy.1, hy.2.trans e.center_interior.2⟩).mp
    rw [e.pre_union]
    exact Or.inl hyC
  · intro x hx hxS hxD y hy
    exact promoted_less_than_carry (e.parent_localI1 h) e.cut hxS hxD hy
  · exact e.left_separator
  · intro x hx
    change x ∈ Qual N.data (carry N.list e.cut) ∪ injection N.frame N.left N.right ↔ _
    rw [← e.pre_union]
    exact e.high_union h x ⟨hx.1, hx.2.trans e.center_interior.2⟩
  · exact (e.list_order h).pruning_subset

theorem RawSameData.child_I3 {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    I3 e.prepared e.childLeft e.c e.d e.child.qualifiers e.child.key := by
  apply same_update_I3_literal e.walk e.normalized e.right_before_center
    e.center_interior.2.le e.preparation h.I3
    (carry_subset N.data N.list e.cut) (e.list_order h)
  intro x hxC hxD y hy hyC hkey
  have hxI : x ∉ (Entry.injection N.left N.right none).denote N.data :=
    fun hi => hxD hi.1
  have hyI : y ∉ (Entry.injection N.left N.right none).denote N.data := by
    intro hi
    exact at_not_D (walk_initial_placed e.walk)
      (boundary_jobs_time (walk_initial_placed e.walk) hy).le hi.1
  rw [append_key_without N.data _ _ hxI, append_key_without N.data _ _ hyI] at hkey
  exact (carry_key_order N.data N.list e.cut hxC hyC).mp hkey

theorem RawSameData.creation_valid {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) : e.creation.Valid := by
  have hr : Run N.data (Inside e.prepared N.a N.b) N.list := by
    rw [← e.parent_domain]
    exact h.run
  obtain ⟨hsize, hdown, hagree⟩ := historical_syntax_properties hr h.origin_coverage
    h.five (e.parent_localI1 h) e.cut
  have hcone : ∀ x ∈ Inside e.prepared N.a N.b,
      x ∈ sameLow N e.prepared e.cut → x ∈ Pred N.frame N.right := by
    intro x hx hxS
    change x ∈ priorityLow N.data _ N.list e.cut N.right at hxS
    rw [priority_low_eq_historical (e.parent_localI1 h) e.cut] at hxS
    exact hxS.2.1
  refine ⟨hdown, hagree, hsize, ?_, ?_, hcone, fun x hx hxS => ⟨hx, hcone x hx hxS⟩⟩
  · intro x hx
    change x ∈ Inside e.prepared N.a N.b at hx
    change x ∈ (Syntax.meet (.lit false false (.predecessors N.right))
      (listSyntax N.originLeft N.origin (carry N.list e.cut)).compl).denote N.frame ↔ _
    rw [Syntax.denote, syntax_compl_denote]
    change (x ∈ Pred N.frame N.right ∧
      x ∈ ((listSyntax N.originLeft N.origin (carry N.list e.cut)).denote N.frame)ᶜ) ↔ _
    rw [list_syntax_denote N.frame N.originLeft N.originParent N.origin]
    change (x ∈ Pred N.frame N.right ∧ x ∉ Qual N.data (carry N.list e.cut)) ↔ _
    change _ ↔ x ∈ priorityLow N.data (Inside e.prepared N.a N.b) N.list e.cut N.right
    rw [priority_low_eq_historical (e.parent_localI1 h) e.cut]
    rw [carry_selected_by_key]
    simp [historicalLow, hx, RawNode.data, frameData]
  · change 1 + (listSyntax N.originLeft N.origin (carry N.list e.cut)).compl.leaves ≤ 205
    rw [syntax_compl_leaves]
    have hs := list_syntax_small N.originLeft N.origin h.origin_small (carry N.list e.cut)
    have hl := carry_length N.list e.cut
    have hf := h.five
    omega

theorem RawSameData.child_run {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    Run e.child.data e.child.domain e.child.list := by
  have hr : Run N.data (Inside e.prepared N.a N.b) N.list := by
    rw [← e.parent_domain]
    exact h.run
  exact .same hr _ e.child_inside e.cut N.left N.right

theorem RawSameData.pre_separated {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) :
    InjectionSeparated N.data (Inside e.prepared N.a N.b)
      (carry N.list e.cut ++ [.injection N.left N.right none]) := by
  have hs : InjectionSeparated N.data (Inside e.prepared N.a N.b) N.list := by
    rw [← e.parent_domain]
    exact h.separated
  exact hs.append_fresh (e.parent_localI1 h) e.cut

theorem RawSameData.child_injection_bound {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) : (injections e.child.list).length ≤ 3 := by
  let M := carry N.list e.cut ++ [.injection N.left N.right none]
  have hup : ∀ f ∈ M, TemporalBoundary.IsUp N.frame (f.denote N.data) :=
    fun f _ => entry_up (frame_laws _ _ _ _) h.origin_up f
  have hc : e.c < e.d := by
    obtain ⟨x, hx⟩ := e.nonempty_child
    exact hx.1.trans hx.2
  have hF : ∀ z ∈ e.childRight, z ∈ Inside e.prepared N.a N.b := by
    intro z hz
    have ht := (e.right_placed.2 z).mp hz
    have ha := e.creation.left_range
    have hb := e.right_before_center.trans_lt e.center_interior.2
    change N.a < e.prepared.time z ∧ e.prepared.time z < N.b
    rw [ht]
    exact ⟨lt_of_le_of_lt ha hc, hb⟩
  have hhigh : Inside e.prepared e.c e.d ∩ Qual N.data M ⊆
      Pred N.frame (.actual e.childRight) := by
    rintro x ⟨hx, hxQ⟩
    have hxE : x ∈ Inside e.prepared N.a e.v :=
      ⟨lt_of_le_of_lt e.creation.left_range hx.1, lt_of_lt_of_le hx.2 e.right_before_center⟩
    exact e.right_separator.earlier_high x hxE
      ((e.high_union h x (e.child_inside hx)).mp hxQ) hx.2
  have hcap := injection_capacity (P := N.frame) (B := .actual e.childRight)
    rfl e.right_placed.1 (e.pre_separated h) hF hup hhigh
  change (injections e.child.list).length ≤ 3 at hcap
  exact hcap

theorem RawSameData.child_five {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) : e.child.list.length ≤ 5 := by
  have hcap := e.child_injection_bound h
  have hbase := LiteralConstruction.Run.base_bound (e.child_run h)
  have hdecomp := count_decomposition e.child.list
  omega

theorem RawSameData.derived {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Derived N) : Derived e.child := by
  refine ⟨e.child_run h, h.origin_up, h.origin_coverage, h.origin_small,
    e.child_localI1 h, ?_, e.child_five h, e.child_I2 h, e.child_I3 h, ?_, ?_⟩
  · exact (e.pre_separated h).prune.shrink e.child_inside
  · intro s hs x hx
    have heq : e.creation = s := Option.some.inj hs
    subst s
    change x ∈ Inside e.prepared e.c e.d at hx
    have hp := congrArg (fun A : Set Job => x ∈ A)
      (prune_local N.data (Inside e.prepared e.c e.d)
        (carry N.list e.cut ++ [.injection N.left N.right none]))
    have hmem : x ∈ e.child.qualifiers ↔
        x ∈ Qual N.data (carry N.list e.cut ++ [.injection N.left N.right none]) := by
      change x ∈ Qual N.data (prune N.data (Inside e.prepared e.c e.d)
        (carry N.list e.cut ++ [.injection N.left N.right none])) ↔ _
      simpa only [Set.mem_inter_iff, hx, true_and] using Iff.of_eq hp
    exact hmem.trans (e.high_union h x (e.child_inside hx))
  · intro s hs
    have heq : e.creation = s := Option.some.inj hs
    subst s
    exact e.creation_valid h

noncomputable def RawSwitchData.incoming {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    IncomingAncestor e.prepared N.right.reverse (reverseTime T N.b) (reverseTime T N.a) :=
  e.creation.incoming (h.incoming e.creation e.chronology) N.right_placed N.ordered
    e.prepared e.preparation

theorem RawSwitchData.origin_denote {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    (creationSwitchSyntax e.creation N.right.reverse).denote N.frame.reverse =
      (e.incoming h).G :=
  creation_switch_denote e.creation (h.incoming e.creation e.chronology)
    N.right_placed N.ordered e.prepared e.preparation

theorem RawSwitchData.origin_properties {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    TemporalBoundary.IsUp N.frame.reverse
        ((creationSwitchSyntax e.creation N.right.reverse).denote N.frame.reverse) ∧
      (Inside e.prepared (reverseTime T N.b) (reverseTime T N.a) \
        D N.frame.reverse N.right.reverse ⊆
          (creationSwitchSyntax e.creation N.right.reverse).denote N.frame.reverse) ∧
      (∀ z ∈ (creationSwitchSyntax e.creation N.right.reverse).denote N.frame.reverse,
        ¬ e.prepared.time z ≤ reverseTime T N.b) := by
  rw [e.origin_denote h]
  obtain ⟨hup, hcover, hearly⟩ := (e.incoming h).G_properties
  exact ⟨hup, fun _ hx => hcover _ hx.1 hx.2, hearly⟩

theorem RawSwitchData.origin_small {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    (creationSwitchSyntax e.creation N.right.reverse).leaves ≤ 24 := by
  have hs := (h.incoming e.creation e.chronology).extension_small
  simp only [creationSwitchSyntax, Syntax.leaves, syntax_flip_leaves]
  omega

theorem RawSwitchData.parent_domain {T : ℕ} {N : RawNode Job T} (e : RawSwitchData N) :
    N.domain = Inside e.prepared (reverseTime T N.b) (reverseTime T N.a) := by
  have heq := Set.ext e.preparation.1
  rw [inside_reverse] at heq
  exact heq

theorem RawSwitchData.parent_cover {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    ∀ x ∈ Inside e.prepared (reverseTime T N.b) (reverseTime T N.a),
      x ∉ D N.frame.reverse N.right.reverse →
      x ∈ Pred N.frame.reverse N.left.reverse := by
  intro x hx hxD
  have hxU : x ∈ N.domain := by rwa [e.parent_domain]
  have hxQ : x ∉ N.qualifiers := by
    intro hxQ
    apply hxD
    rw [D_reverse]
    exact h.localI1.old_high ⟨hxU, hxQ⟩
  rw [pred_reverse]
  exact h.localI1.old_low ⟨hxU, hxQ⟩

theorem RawSwitchData.child_inside {T : ℕ} {N : RawNode Job T} (e : RawSwitchData N) :
    Inside e.prepared e.c e.d ⊆
      Inside e.prepared (reverseTime T N.b) (reverseTime T N.a) := by
  intro x hx
  exact ⟨lt_of_le_of_lt e.creationRecord.left_range hx.1,
    lt_of_lt_of_le hx.2 (e.right_before_center.trans e.center_interior.2.le)⟩

theorem RawSwitchData.pre_union {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    Qual e.data [.first (e.r + 1), .second none] =
      switchQualifiers (e.incoming h) (e.r + 1) := by
  ext x
  simp [RawSwitchData.data, Entry.denote, threshold, frameData, switchQualifiers,
    e.origin_denote h, suffix]

theorem RawSwitchData.high_union {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    ∀ x ∈ Inside e.prepared (reverseTime T N.b) (reverseTime T N.a),
      x ∈ Qual e.data [.first (e.r + 1), .second none] ↔
        x ∉ switchLow e.prepared (reverseTime T N.b) (reverseTime T N.a) N.right.reverse e.r :=
  fun _ hx => switch_pair_union (e.origin_properties h).2.1 e.r hx

theorem RawSwitchData.child_localI1 {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    LocalI1 e.child.data e.child.domain e.child.list e.child.left e.child.right := by
  apply localI1_of_exact_update e.creationRecord.left_range e.right_before_center
    e.left_separator e.right_separator
  intro x hx
  exact e.high_union h x ⟨hx.1, hx.2.trans e.center_interior.2⟩

theorem RawSwitchData.list_order {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    ListOrderInterface e.prepared e.priority (reverseTime T N.b) e.v e.c e.d e.childLeft
      (switchQualifiers (e.incoming h) (e.r + 1)) e.child.qualifiers
      (lexKey e.data [.first (e.r + 1), .second none]) e.child.key := by
  constructor
  · rw [← e.pre_union h]
    exact prune_subset e.data _ _
  · intro x hx hxD
    by_contra hn
    exact hxD ((e.child_localI1 h).old_low ⟨hx, hn⟩)
  · intro x hx hxQ y hyQ hkey
    exact prune_comparison e.data _ _ hx hxQ hyQ hkey
  · intro x hx hxQ y hy hyQ hkey
    have hxU : x ∈ Inside e.prepared (reverseTime T N.b) (reverseTime T N.a) :=
      ⟨hx.1, hx.2.trans e.center_interior.2⟩
    have hyU : y ∈ Inside e.prepared (reverseTime T N.b) (reverseTime T N.a) :=
      ⟨hy.1, hy.2.trans e.center_interior.2⟩
    apply (e.priority_protocol x hxU y hyU).mpr
    rw [← e.pre_union h] at hxQ hyQ
    exact switch_pre_priority (e.r + 1) hxQ hyQ hkey

theorem RawSwitchData.child_I2 {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    I2 e.prepared e.childLeft e.c e.child.qualifiers := by
  apply switch_update_I2 (e.incoming h) (e.r + 1) e.walk e.center_interior.1 e.left_separator
  · intro x hx
    rw [← e.pre_union h]
    exact e.high_union h x ⟨hx.1, hx.2.trans e.center_interior.2⟩
  · exact (e.list_order h).pruning_subset

theorem RawSwitchData.child_I3 {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) :
    I3 e.prepared e.childLeft e.c e.d e.child.qualifiers e.child.key :=
  switch_update_I3 (e.incoming h) (e.r + 1) e.walk e.normalized
    e.right_before_center (e.list_order h)

theorem RawSwitchData.child_run {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) :
    Run e.child.data e.child.domain e.child.list :=
  .switched _ (e.r + 1) e.child_inside

theorem RawSwitchData.creation_valid {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) : e.creationRecord.Valid := by
  let P := N.frame.reverse
  let A := N.right.reverse
  let U := Inside e.prepared (reverseTime T N.b) (reverseTime T N.a)
  have hs := switched_historical_cutoff_extension
    (frame_laws P A U ((creationSwitchSyntax e.creation A).denote P)) U A e.r
  constructor
  · change TemporalBoundary.IsDown P ((sourceFormula (switchedLowFormula A e.r)).denote P)
    rw [source_formula_denote P A U ((creationSwitchSyntax e.creation A).denote P)]
    exact hs.2.1
  · intro x hx
    change x ∈ (sourceFormula (switchedLowFormula A e.r)).denote P ↔ _
    rw [source_formula_denote P A U ((creationSwitchSyntax e.creation A).denote P)]
    change (x ∉ D P A ∧ P.rank x ≤ e.r) ↔
      (x ∈ U ∧ x ∉ D P A ∧ P.rank x ≤ e.r)
    tauto
  · change (sourceFormula (switchedLowFormula A e.r)).leaves ≤ 21
    simp [switchedLowFormula, Formula.leaves]
  · intro x hx
    change x ∈ (sourceFormula (switchedLowFormula A e.r)).denote P ↔ _
    rw [source_formula_denote P A U ((creationSwitchSyntax e.creation A).denote P)]
    change (x ∉ D P A ∧ P.rank x ≤ e.r) ↔
      (x ∈ U ∧ x ∉ D P A ∧ P.rank x ≤ e.r)
    tauto
  · change (sourceFormula (switchedLowFormula A e.r)).leaves ≤ 205
    simp [switchedLowFormula, Formula.leaves]
  · intro x hx hxS
    exact e.parent_cover h x hx hxS.2.1
  · intro x hx hxS
    exact ⟨hx, hxS.2.1⟩

theorem RawSwitchData.derived {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Derived N) : Derived e.child := by
  obtain ⟨hup, hcoverage, _⟩ := e.origin_properties h
  refine ⟨e.child_run, hup, hcoverage, e.origin_small h, e.child_localI1 h,
    ?_, ?_, e.child_I2 h, e.child_I3 h, ?_, ?_⟩
  · have hs : InjectionSeparated e.data (Inside e.prepared e.c e.d)
        [.first (e.r + 1), .second none] := by
      simp [InjectionSeparated, Entry.Injection]
    exact hs.prune
  · have hp := List.length_filter_le
      (fun f : Entry (TemporalBoundary.Boundary Job) =>
        @decide (∃ x ∈ Inside e.prepared e.c e.d, x ∈ f.denote e.data)
          (Classical.propDecidable _))
      [.first (e.r + 1), .second none]
    change e.child.list.length ≤ _ at hp
    exact hp.trans (by simp)
  · intro s hs x hx
    have heq : e.creationRecord = s := Option.some.inj hs
    subst s
    change x ∈ Inside e.prepared e.c e.d at hx
    have hp := congrArg (fun A : Set Job => x ∈ A)
      (prune_local e.data (Inside e.prepared e.c e.d) [.first (e.r + 1), .second none])
    have hmem : x ∈ e.child.qualifiers ↔
        x ∈ Qual e.data [.first (e.r + 1), .second none] := by
      change x ∈ Qual e.data (prune e.data (Inside e.prepared e.c e.d)
        [.first (e.r + 1), .second none]) ↔ _
      simpa only [Set.mem_inter_iff, hx, true_and] using Iff.of_eq hp
    exact hmem.trans (e.high_union h x (e.child_inside hx))
  · intro s hs
    have heq : e.creationRecord = s := Option.some.inj hs
    subst s
    exact e.creation_valid h

theorem RawHistory.derived {T : ℕ} {N : RawNode Job T} (history : RawHistory N) :
    Derived N := by
  induction history with
  | root P σ => exact root_derived σ
  | same past e ih => exact e.derived ih
  | switched past e ih => exact e.derived ih

theorem RawHistory.future_invariants {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (τ : Schedule N.frame T)
    (hr : Reorders N.schedule τ N.a N.b) :
    LocalI1 N.data (Inside τ N.a N.b) N.list N.left N.right ∧
      I2 τ N.left N.a N.qualifiers ∧ I3 τ N.left N.a N.b N.qualifiers N.key := by
  have h := history.derived
  have heq : N.domain = Inside τ N.a N.b := Set.ext hr.1
  exact ⟨by rw [← heq]; exact h.localI1, I2_reorders h.I2 hr, I3_reorders h.I3 hr⟩

theorem RawHistory.list_bounds {T : ℕ} {N : RawNode Job T} (history : RawHistory N) :
    N.list.length ≤ 5 ∧
      ∀ e ∈ N.list, (entrySyntax N.originLeft N.origin e).leaves < 40 := by
  have h := history.derived
  exact ⟨h.five, fun e _ => lt_of_le_of_lt
    (entry_syntax_small N.originLeft N.origin h.origin_small e) (by decide)⟩

theorem Pred_before {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {b : ℤ} (hB : Placed σ B b)
    {x : Job} (hx : x ∈ Pred P B) : σ.time x < b := by
  cases B with
  | left => exact False.elim hx
  | right =>
      change b = (T : ℤ) + 1 at hB
      have hr := (σ.complete.range x).2
      omega
  | actual F =>
      obtain ⟨z, hz, hxz⟩ := hx
      have ht := (hB.2 z).mp hz
      simpa only [ht] using σ.feasible hxz

theorem weakD_after {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : x ∈ WeakD P B) : a ≤ σ.time x := by
  rcases hx with hx | hx
  · exact (D_after hB hx).le
  · exact (boundary_jobs_time hB hx).ge

def highSyntax {T : ℕ} (N : RawNode Job T) : Syntax Job :=
  .meet (listSyntax N.originLeft N.origin N.list)
    (.meet (.lit false false (.predecessors N.right))
      (.lit true false (.weakPredecessors N.left)))

def lowSyntax {T : ℕ} (N : RawNode Job T)
    (s : Creation N.schedule N.right N.a N.b) : Syntax Job :=
  .meet (.lit false false (.descendants N.left))
    (.meet (.lit false false (.predecessors s.outerRight))
      (.meet (.lit true false (.weakDescendants N.right))
        (.meet (.lit true false (.weakDescendants (.actual s.center))) s.directCutoff)))

theorem high_syntax_semantics {T : ℕ} (N : RawNode Job T) (x : Job) :
    x ∈ (highSyntax N).denote N.frame ↔
      x ∈ N.qualifiers ∧ x ∈ Pred N.frame N.right ∧ x ∉ WeakPred N.frame N.left := by
  simp only [highSyntax, Syntax.denote,
    list_syntax_denote N.frame N.originLeft N.originParent N.origin]
  rfl

theorem global_high {T : ℕ} {N : RawNode Job T} (h : Derived N)
    (s : Creation N.schedule N.right N.a N.b) (hs : N.incoming = some s) :
    (highSyntax N).denote N.frame = N.domain \ s.low := by
  ext x
  rw [high_syntax_semantics]
  constructor
  · rintro ⟨hxQ, hxP, hxWeak⟩
    have hbefore := Pred_before N.right_placed hxP
    have hafter : N.a < N.schedule.time x := by
      by_contra hn
      exact hxWeak (h.I2 x hxQ (le_of_not_gt hn))
    have hxU : x ∈ N.domain := ⟨hafter, hbefore⟩
    exact ⟨hxU, (h.high_identity s hs x hxU).mp hxQ⟩
  · rintro ⟨hxU, hxLow⟩
    have hxQ := (h.high_identity s hs x hxU).mpr hxLow
    refine ⟨hxQ, h.localI1.old_high ⟨hxU, hxQ⟩, ?_⟩
    intro hxWeak
    exact (not_le_of_gt hxU.1) (weakPred_before N.left_placed hxWeak)

theorem global_low {T : ℕ} {N : RawNode Job T} (h : Derived N)
    (s : Creation N.schedule N.right N.a N.b) (hs : N.incoming = some s) :
    (lowSyntax N s).denote N.frame = N.domain ∩ s.low := by
  have hv := h.incoming s hs
  ext x
  change (x ∈ D N.frame N.left ∧ x ∈ Pred N.frame s.outerRight ∧
    x ∉ WeakD N.frame N.right ∧
    x ∉ WeakD N.frame (.actual s.center) ∧ x ∈ s.directCutoff.denote N.frame) ↔ _
  constructor
  · rintro ⟨hxD, hxP, hxRight, hxCenter, hxCut⟩
    have hafter := D_after N.left_placed hxD
    have hbefore := Pred_before s.outerRight_placed hxP
    have hxU : x ∈ Inside N.schedule s.u s.w :=
      ⟨lt_of_le_of_lt s.left_range hafter, hbefore⟩
    have hxLow := (hv.direct_agreement x hxU).mp hxCut
    have hcenter : N.schedule.time x < s.v := by
      by_contra hn
      have hge := le_of_not_gt hn
      by_cases heq : N.schedule.time x = s.v
      · exact hxCenter (Or.inr (time_mem_boundary s.center_placed heq))
      · apply hxCenter
        exact Or.inl (s.center_separator.later_low x hxU
          (hv.cutoff_center x hxU hxLow) (by omega))
    have hxE : x ∈ Inside N.schedule s.u s.v :=
      ⟨lt_of_le_of_lt s.left_range hafter, hcenter⟩
    have hright : N.schedule.time x < N.b := by
      by_contra hn
      have hge := le_of_not_gt hn
      by_cases heq : N.schedule.time x = N.b
      · exact hxRight (Or.inr (time_mem_boundary N.right_placed heq))
      · exact hxRight (Or.inl (s.endpoint_separator.later_low x hxE hxLow (by omega)))
    exact ⟨⟨hafter, hright⟩, hxLow⟩
  · rintro ⟨hx, hxLow⟩
    have hxU : x ∈ Inside N.schedule s.u s.w :=
      ⟨lt_of_le_of_lt s.left_range hx.1,
        lt_of_lt_of_le hx.2 (s.right_before_center.trans s.center_interior.2.le)⟩
    have hxQ : x ∉ N.qualifiers :=
      fun hq => (h.high_identity s hs x hx).mp hq hxLow
    refine ⟨h.localI1.old_low ⟨hx, hxQ⟩, hv.cutoff_cone x hxU hxLow, ?_, ?_,
      (hv.direct_agreement x hxU).mpr hxLow⟩
    · intro hw
      exact (not_le_of_gt hx.2) (weakD_after N.right_placed hw)
    · intro hw
      have htime := weakD_after s.center_placed hw
      have hlt := lt_of_lt_of_le hx.2 s.right_before_center
      exact (not_le_of_gt hlt) htime

def nodeSyntax {T : ℕ} (N : RawNode Job T) : Syntax Job :=
  match N.incoming with
  | none => .lit false false .top
  | some s => .join (highSyntax N) (lowSyntax N s)

theorem RawHistory.global_node_description {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) :
    (nodeSyntax N).denote N.frame = N.domain ∧ (nodeSyntax N).leaves < 500 := by
  have h := history.derived
  cases hi : N.incoming with
  | none =>
      have hroot : N.domain = Set.univ := by
        cases history with
        | root P σ => exact root_domain σ
        | same past e => simp [RawSameData.child] at hi
        | switched past e => simp [RawSwitchData.child] at hi
      simp [nodeSyntax, hi, Syntax.denote, Test.denote, hroot, Syntax.leaves]
  | some s =>
      have hhigh := global_high h s hi
      have hlow := global_low h s hi
      have hlist := list_syntax_small N.originLeft N.origin h.origin_small N.list
      have hfive := h.five
      have hcut := (h.incoming s hi).direct_small
      constructor
      · simp only [nodeSyntax, hi, Syntax.denote, hhigh, hlow]
        ext x
        simp only [Set.mem_union, Set.mem_sdiff, Set.mem_inter_iff]
        tauto
      · simp only [nodeSyntax, hi, highSyntax, lowSyntax, Syntax.leaves]
        omega

def separatorSyntax (B : TemporalBoundary.Boundary Job) (H : Syntax Job) : Syntax Job :=
  .join (.lit false false (.predecessors B))
    (.meet H (.lit true false (.weakDescendants B)))

@[simp] theorem separator_syntax_leaves (B : TemporalBoundary.Boundary Job) (H : Syntax Job) :
    (separatorSyntax B H).leaves = H.leaves + 2 := by
  simp [separatorSyntax, Syntax.leaves]
  omega

theorem separator_syntax_exact {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {domain low : Set Job} {B : TemporalBoundary.Boundary Job} {r : ℤ}
    (hB : Placed σ B r) (hs : Separator σ domain low B r)
    (H : Syntax Job) (hH : ∀ x ∈ domain, x ∈ H.denote P ↔ x ∈ low) :
    ∀ x ∈ domain, x ∈ (separatorSyntax B H).denote P ↔ σ.time x < r := by
  intro x hx
  change (x ∈ Pred P B ∨ (x ∈ H.denote P ∧ x ∉ WeakD P B)) ↔ _
  constructor
  · rintro (hp | ⟨hHmem, hnot⟩)
    · exact Pred_before hB hp
    · by_contra hn
      have hge := le_of_not_gt hn
      by_cases heq : σ.time x = r
      · exact hnot (Or.inr (time_mem_boundary hB heq))
      · exact hnot (Or.inl (hs.later_low x hx ((hH x hx).mp hHmem) (by omega)))
  · intro ht
    by_cases hlow : x ∈ low
    · exact Or.inr ⟨(hH x hx).mpr hlow,
        fun hw => (not_le_of_gt ht) (weakD_after hB hw)⟩
    · exact Or.inl (hs.earlier_high x hx hlow ht)

def relativeSyntax (V Z : TemporalBoundary.Boundary Job)
    (centerCutoff edgeCutoff : Syntax Job) : Syntax Job :=
  .meet (separatorSyntax V centerCutoff) (separatorSyntax Z edgeCutoff)

theorem relative_split_exact {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {a b v z : ℤ} {V Z : TemporalBoundary.Boundary Job} {centerLow low : Set Job}
    (hV : Placed σ V v) (hZ : Placed σ Z z) (hzv : z < v)
    (hcenter : Separator σ (Inside σ a b) centerLow V v)
    (hmark : Separator σ (Inside σ a v) low Z z)
    (H S : Syntax Job)
    (hH : ∀ x ∈ Inside σ a b, x ∈ H.denote P ↔ x ∈ centerLow)
    (hS : ∀ x ∈ Inside σ a b, x ∈ S.denote P ↔ x ∈ low)
    (hvb : v ≤ b) :
    ∀ x ∈ Inside σ a b,
      x ∈ (relativeSyntax V Z H S).denote P ↔ σ.time x < z := by
  intro x hx
  have hc := separator_syntax_exact hV hcenter H hH x hx
  change (x ∈ (separatorSyntax V H).denote P ∧ x ∈ (separatorSyntax Z S).denote P) ↔ _
  constructor
  · rintro ⟨hxV, hxZ⟩
    have hxE : x ∈ Inside σ a v := ⟨hx.1, hc.mp hxV⟩
    exact (separator_syntax_exact hZ hmark S
      (fun y hy => hS y ⟨hy.1, lt_of_lt_of_le hy.2 hvb⟩) x hxE).mp hxZ
  · intro hxz
    have hxv := hxz.trans hzv
    exact ⟨hc.mpr hxv, (separator_syntax_exact hZ hmark S
      (fun y hy => hS y ⟨hy.1, lt_of_lt_of_le hy.2 hvb⟩)
        x ⟨hx.1, hxv⟩).mpr hxz⟩

def reverseSplitSyntax (Z : TemporalBoundary.Boundary Job) (F : Syntax Job) : Syntax Job :=
  .meet F.compl (.lit true false (.triple Z))

theorem reverse_split_exact {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {domain : Set Job} {Z : TemporalBoundary.Boundary Job} {z : ℤ}
    (hZ : Placed σ Z z) (F : Syntax Job)
    (hF : ∀ x ∈ domain, x ∈ F.denote P ↔ σ.time x < z) :
    ∀ x ∈ domain,
      x ∈ (reverseSplitSyntax Z F).flip.denote P.reverse ↔
        σ.reverse.time x < reverseTime T z := by
  intro x hx
  rw [syntax_flip_denote]
  change (x ∈ F.compl.denote P ∧ x ∉ Z.jobs) ↔ _
  rw [syntax_compl_denote]
  change (x ∉ F.denote P ∧ x ∉ Z.jobs) ↔ _
  have htriple : x ∈ Z.jobs ↔ σ.time x = z :=
    ⟨boundary_jobs_time hZ, time_mem_boundary hZ⟩
  rw [hF x hx, htriple]
  dsimp [Schedule.reverse, reverseTime]
  omega

theorem RawHistory.injection_bound {T : ℕ} {N : RawNode Job T} (history : RawHistory N) :
    (injections N.list).length ≤ 3 := by
  cases history with
  | root P σ => simp [rawRoot, injections, injectionFlag]
  | same past e => exact e.child_injection_bound past.derived
  | switched past e =>
      have hzero : injections e.child.list = [] := by
        apply List.filter_eq_nil_iff.mpr
        intro f hf
        have hf' : f ∈ [.first (e.r + 1), .second none] := (List.mem_filter.mp hf).1
        simp only [List.mem_cons, List.mem_nil_iff, or_false] at hf'
        rcases hf' with rfl | rfl <;> simp [injectionFlag]
      simp [hzero]

def directSameSyntax {T : ℕ} (N : RawNode Job T) (cut : Cut) : Syntax Job :=
  .meet (.lit false false (.predecessors N.right))
    (listSyntax N.originLeft N.origin (carry N.list cut)).compl

theorem RawHistory.same_cutoff_certificate {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (σ : Schedule N.frame T)
    (hp : Reorders N.schedule σ N.a N.b) (cut : Cut) :
    (directSameSyntax N cut).leaves ≤ 205 ∧
      (∀ x ∈ Inside σ N.a N.b,
        x ∈ (directSameSyntax N cut).denote N.frame ↔ x ∈ sameLow N σ cut) ∧
      (historicalSyntax N.originLeft N.right N.list cut).leaves ≤ 21 ∧
      TemporalBoundary.IsDown N.frame
        ((historicalSyntax N.originLeft N.right N.list cut).denote N.frame) ∧
      (∀ x ∈ Inside σ N.a N.b,
        x ∈ (historicalSyntax N.originLeft N.right N.list cut).denote N.frame ↔
          x ∈ sameLow N σ cut) := by
  have h := history.derived
  have heq : N.domain = Inside σ N.a N.b := Set.ext hp.1
  have hI1 : LocalI1 N.data (Inside σ N.a N.b) N.list N.left N.right := by
    rw [← heq]
    exact h.localI1
  have hr : Run N.data (Inside σ N.a N.b) N.list := by rw [← heq]; exact h.run
  obtain ⟨hl, hd, he⟩ :=
    historical_syntax_properties hr h.origin_coverage h.five hI1 cut
  refine ⟨?_, ?_, hl, hd, he⟩
  · have hs := list_syntax_small N.originLeft N.origin h.origin_small (carry N.list cut)
    have hc := carry_length N.list cut
    have hf := h.five
    simp only [directSameSyntax, Syntax.leaves, syntax_compl_leaves]
    omega
  · intro x hx
    simp only [directSameSyntax, Syntax.denote, syntax_compl_denote]
    rw [list_syntax_denote N.frame N.originLeft N.originParent N.origin]
    change (x ∈ Pred N.frame N.right ∧ x ∉ Qual N.data (carry N.list cut)) ↔
      x ∈ priorityLow N.data (Inside σ N.a N.b) N.list cut N.right
    rw [priority_low_eq_historical hI1 cut, carry_selected_by_key]
    simp [historicalLow, hx, RawNode.data, frameData]

structure SplitCertificate {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (domain : Set Job) (Z : TemporalBoundary.Boundary Job) (z : ℤ)
    (F : Syntax Job) : Prop where
  leaves : F.leaves < 500
  earlier : ∀ x ∈ domain, x ∈ F.denote P ↔ σ.time x < z
  reversed_leaves : (reverseSplitSyntax Z F).flip.leaves < 500
  reversed_earlier : ∀ x ∈ domain,
    x ∈ (reverseSplitSyntax Z F).flip.denote P.reverse ↔
      σ.reverse.time x < reverseTime T z

theorem relative_split_certificate {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {a b v z : ℤ} {V Z : TemporalBoundary.Boundary Job} {centerLow low : Set Job}
    (hV : Placed σ V v) (hZ : Placed σ Z z) (hzv : z < v)
    (hcenter : Separator σ (Inside σ a b) centerLow V v)
    (hmark : Separator σ (Inside σ a v) low Z z)
    (H S : Syntax Job) (hHsize : H.leaves ≤ 1) (hSsize : S.leaves ≤ 205)
    (hH : ∀ x ∈ Inside σ a b, x ∈ H.denote P ↔ x ∈ centerLow)
    (hS : ∀ x ∈ Inside σ a b, x ∈ S.denote P ↔ x ∈ low) (hvb : v ≤ b) :
    SplitCertificate σ (Inside σ a b) Z z (relativeSyntax V Z H S) := by
  have he := relative_split_exact hV hZ hzv hcenter hmark H S hH hS hvb
  refine ⟨?_, he, ?_, reverse_split_exact hZ _ he⟩
  · simp only [relativeSyntax, Syntax.leaves, separator_syntax_leaves]
    omega
  · simp only [syntax_flip_leaves, reverseSplitSyntax, Syntax.leaves, syntax_compl_leaves,
      relativeSyntax, separator_syntax_leaves]
    omega

theorem center_split_certificate {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {domain low : Set Job} {V : TemporalBoundary.Boundary Job} {v : ℤ}
    (hV : Placed σ V v) (hs : Separator σ domain low V v)
    (H : Syntax Job) (hsize : H.leaves ≤ 1)
    (hH : ∀ x ∈ domain, x ∈ H.denote P ↔ x ∈ low) :
    SplitCertificate σ domain V v (separatorSyntax V H) := by
  have he := separator_syntax_exact hV hs H hH
  refine ⟨?_, he, ?_, reverse_split_exact hV _ he⟩
  · rw [separator_syntax_leaves]
    omega
  · simp only [syntax_flip_leaves, reverseSplitSyntax, Syntax.leaves,
      syntax_compl_leaves, separator_syntax_leaves]
    omega

theorem RawHistory.same_mark_description {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (σ : Schedule N.frame T)
    (hp : Reorders N.schedule σ N.a N.b) (cut : Cut)
    {V Z : TemporalBoundary.Boundary Job} {v z : ℤ}
    (hV : Placed σ V v) (hZ : Placed σ Z z) (hzv : z < v) (hvb : v ≤ N.b)
    (hcenter : Separator σ (Inside σ N.a N.b) (sameCenterLow N σ) V v)
    (hmark : Separator σ (Inside σ N.a v) (sameLow N σ cut) Z z) :
    SplitCertificate σ N.domain Z z
      (relativeSyntax V Z (.lit false false (.predecessors N.right))
        (directSameSyntax N cut)) := by
  have heq : N.domain = Inside σ N.a N.b := Set.ext hp.1
  rw [heq]
  apply relative_split_certificate hV hZ hzv hcenter hmark _ _ (by rfl)
    (history.same_cutoff_certificate σ hp cut).1
  · intro x hx
    change x ∈ Pred N.frame N.right ↔ x ∈ Inside σ N.a N.b ∩ Pred N.frame N.right
    simp [hx]
  · exact (history.same_cutoff_certificate σ hp cut).2.1
  · exact hvb

theorem RawHistory.switched_mark_description {T : ℕ} {N : RawNode Job T}
    (_history : RawHistory N) (σ : Schedule N.frame.reverse T)
    (hp : Reorders N.schedule.reverse σ (reverseTime T N.b) (reverseTime T N.a))
    (r : ℕ) {V Z : TemporalBoundary.Boundary Job} {v z : ℤ}
    (hV : Placed σ V v) (hZ : Placed σ Z z) (hzv : z < v) (hvb : v ≤ reverseTime T N.a)
    (hcenter : Separator σ (Inside σ (reverseTime T N.b) (reverseTime T N.a))
      (switchCenterLow σ (reverseTime T N.b) (reverseTime T N.a) N.right.reverse) V v)
    (hmark : Separator σ (Inside σ (reverseTime T N.b) v)
      (switchLow σ (reverseTime T N.b) (reverseTime T N.a) N.right.reverse r) Z z) :
    SplitCertificate σ N.domain Z z
      (relativeSyntax V Z (.lit true false (.descendants N.right.reverse))
        (sourceFormula (switchedLowFormula N.right.reverse r))) := by
  have heq : N.domain = Inside σ (reverseTime T N.b) (reverseTime T N.a) := by
    have he := Set.ext hp.1
    rw [inside_reverse] at he
    exact he
  rw [heq]
  apply relative_split_certificate hV hZ hzv hcenter hmark _ _ (by rfl) (by
    simp [switchedLowFormula, Formula.leaves])
  · intro x hx
    change (x ∉ D N.frame.reverse N.right.reverse) ↔ _
    simp [switchCenterLow, hx]
  · intro x hx
    rw [source_formula_denote N.frame.reverse N.right.reverse Set.univ Set.univ]
    change (x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x ≤ r) ↔ _
    simp [switchLow, hx]
  · exact hvb

def boundaryAllowed : TemporalBoundary.Boundary Job → Prop
  | .left | .right => True
  | .actual F => F.card = 3

theorem boundary_allowed_placed {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : TemporalBoundary.Boundary Job} {r : ℤ} (h : Placed σ B r) : boundaryAllowed B := by
  cases B with
  | left | right => trivial
  | actual F => exact h.1

@[simp] theorem boundary_allowed_reverse (B : TemporalBoundary.Boundary Job) :
    boundaryAllowed B.reverse ↔ boundaryAllowed B := by cases B <;> rfl

def testAllowed (n : ℕ) : Test Job → Prop
  | .top | .bot => True
  | .descendants B | .predecessors B | .weakDescendants B |
      .weakPredecessors B | .triple B => boundaryAllowed B
  | .ge r | .le r => r ≤ n + 1

def Syntax.Allowed (n : ℕ) : Syntax Job → Prop
  | .lit _ _ t => testAllowed n t
  | .meet f g | .join f g => f.Allowed n ∧ g.Allowed n

theorem Syntax.allowed_compl {n : ℕ} {f : Syntax Job} (h : f.Allowed n) :
    f.compl.Allowed n := by
  induction f <;> simp_all [Syntax.Allowed, Syntax.compl]

theorem Syntax.allowed_flip {n : ℕ} {f : Syntax Job} (h : f.Allowed n) :
    f.flip.Allowed n := by
  induction f <;> simp_all [Syntax.Allowed, Syntax.flip]

def optionAllowed (n : ℕ) : Option ℕ → Prop
  | none => True
  | some r => r ≤ n + 1

def entryAllowed (n : ℕ) : Entry (TemporalBoundary.Boundary Job) → Prop
  | .first k => k ≤ n + 1
  | .root k | .second k => optionAllowed n k
  | .injection A B k => boundaryAllowed A ∧ boundaryAllowed B ∧ optionAllowed n k

def entriesAllowed (n : ℕ) (L : List (Entry (TemporalBoundary.Boundary Job))) : Prop :=
  ∀ e ∈ L, entryAllowed n e

def oldAtomAllowed (n : ℕ) : Atom (TemporalBoundary.Boundary Job) → Prop
  | .top | .bot => True
  | .D B | .P B => boundaryAllowed B
  | .ge r | .le r => r ≤ n + 1

def oldFormulaAllowed (n : ℕ) : Formula (TemporalBoundary.Boundary Job) → Prop
  | .lit _ t => oldAtomAllowed n t
  | .meet f g | .join f g => oldFormulaAllowed n f ∧ oldFormulaAllowed n g

theorem old_allowed_compl {n : ℕ} {f : Formula (TemporalBoundary.Boundary Job)}
    (h : oldFormulaAllowed n f) : oldFormulaAllowed n f.compl := by
  induction f <;> simp_all [oldFormulaAllowed, Formula.compl]

theorem source_formula_allowed {n : ℕ} {f : Formula (TemporalBoundary.Boundary Job)}
    (h : oldFormulaAllowed n f) : (sourceFormula f).Allowed n := by
  induction f with
  | lit n t => cases t <;> exact h
  | meet f g ihf ihg | join f g ihf ihg => exact ⟨ihf h.1, ihg h.2⟩

theorem simple_formula_allowed {n : ℕ} {a₀ : TemporalBoundary.Boundary Job}
    (ha : boundaryAllowed a₀) {e : Entry (TemporalBoundary.Boundary Job)}
    (he : entryAllowed n e) : oldFormulaAllowed n (simpleFormula a₀ e) := by
  cases e with
  | first k => trivial
  | root k | second k | injection A B k =>
      cases k <;> simp_all [entryAllowed, optionAllowed, simpleFormula, addThreshold,
        oldFormulaAllowed, oldAtomAllowed]

theorem entry_syntax_allowed {n : ℕ} {a₀ : TemporalBoundary.Boundary Job}
    (ha : boundaryAllowed a₀) {G : Syntax Job} (hG : G.Allowed n)
    {e : Entry (TemporalBoundary.Boundary Job)} (he : entryAllowed n e) :
    (entrySyntax a₀ G e).Allowed n := by
  cases e with
  | first k => exact ⟨hG, he⟩
  | root k => exact source_formula_allowed (simple_formula_allowed ha he)
  | second k => exact source_formula_allowed (simple_formula_allowed ha he)
  | injection A B k => exact source_formula_allowed (simple_formula_allowed ha he)

theorem list_syntax_allowed {n : ℕ} {a₀ : TemporalBoundary.Boundary Job}
    (ha : boundaryAllowed a₀) {G : Syntax Job} (hG : G.Allowed n)
    {L : List (Entry (TemporalBoundary.Boundary Job))} (hL : entriesAllowed n L) :
    (listSyntax a₀ G L).Allowed n := by
  induction L with
  | nil => trivial
  | cons e L ih =>
      exact ⟨entry_syntax_allowed ha hG (hL e (by simp)),
        ih (fun f hf => hL f (by simp [hf]))⟩

theorem trim_allowed {n r : ℕ} (hr : r ≤ n + 1)
    {e : Entry (TemporalBoundary.Boundary Job)} (he : entryAllowed n e) :
    entryAllowed n (e.trim r) := by
  cases e with
  | first k => exact max_le he hr
  | root k | second k | injection A B k =>
      cases k <;> simp_all [entryAllowed, optionAllowed, Entry.trim, tighten]

def cutAllowed (n : ℕ) : Cut → Prop
  | none => True
  | some p => p.2 ≤ n + 1

theorem cut_attained_allowed {n : ℕ}
    {C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job)}
    (hb : ∀ x, C.rank x ≤ n) {U : Set Job}
    {L : List (Entry (TemporalBoundary.Boundary Job))} {cut : Cut}
    (hc : CutAttained C U L cut) : cutAllowed n cut := by
  cases cut with
  | none => trivial
  | some p =>
      obtain ⟨x, _, _, hxkey⟩ := hc
      have he := congrArg Prod.snd hxkey
      change C.rank x = p.2 at he
      have hr := hb x
      change p.2 ≤ n + 1
      omega

theorem carryAt_allowed {n r : ℕ} (hr : r ≤ n + 1)
    {L : List (Entry (TemporalBoundary.Boundary Job))}
    (hL : entriesAllowed n L) (d : ℕ) : entriesAllowed n (carryAt L d r) := by
  induction L generalizing d with
  | nil => intro e he; simp [carryAt] at he
  | cons e L ih =>
      have he := hL e (by simp)
      have ht : entriesAllowed n L := fun f hf => hL f (by simp [hf])
      cases d with
      | zero =>
          intro f hf
          rcases List.mem_cons.mp hf with rfl | hf
          · exact trim_allowed hr he
          · exact ht f hf
      | succ d => exact ih ht d

theorem carry_allowed {n : ℕ} {cut : Cut}
    {L : List (Entry (TemporalBoundary.Boundary Job))}
    (hL : entriesAllowed n L) (hc : cutAllowed n cut) :
    entriesAllowed n (carry L cut) := by
  cases cut with
  | none => intro e he; simp [carry] at he
  | some p => exact carryAt_allowed hc hL p.1

theorem prune_allowed {n : ℕ} {C : SameFrameHistory.Data Job (TemporalBoundary.Boundary Job)}
    {U : Set Job} {L : List (Entry (TemporalBoundary.Boundary Job))}
    (hL : entriesAllowed n L) : entriesAllowed n (prune C U L) :=
  fun e he => hL e (List.mem_filter.mp he).1

theorem simple_union_allowed {n : ℕ} {a₀ : TemporalBoundary.Boundary Job}
    (ha : boundaryAllowed a₀) {L : List (Entry (TemporalBoundary.Boundary Job))}
    (hL : entriesAllowed n L) : oldFormulaAllowed n (simpleUnion a₀ L) := by
  induction L with
  | nil => trivial
  | cons e L ih =>
      exact ⟨simple_formula_allowed ha (hL e (by simp)),
        ih (fun f hf => hL f (by simp [hf]))⟩

theorem flat_union_allowed {n : ℕ} {a₀ : TemporalBoundary.Boundary Job}
    (ha : boundaryAllowed a₀) {L : List (Entry (TemporalBoundary.Boundary Job))}
    (hL : entriesAllowed n L) : oldFormulaAllowed n (flatUnion a₀ L) := by
  cases L with
  | nil => trivial
  | cons e T =>
      have he := hL e (by simp)
      have ht : entriesAllowed n T := fun f hf => hL f (by simp [hf])
      cases e with
      | root k | second k | injection A B k => exact simple_union_allowed ha hL
      | first k =>
          have hk : oldFormulaAllowed n (flattenedPair a₀ k) := ⟨ha, he⟩
          cases T with
          | nil => exact ⟨hk, trivial⟩
          | cons f T =>
              have htt : entriesAllowed n T := fun g hg => ht g (by simp [hg])
              cases f with
              | first j | root j | injection A B j =>
                  exact ⟨hk, simple_union_allowed ha ht⟩
              | second j =>
                  cases j with
                  | none => exact ⟨hk, simple_union_allowed ha htt⟩
                  | some q => exact ⟨hk, simple_union_allowed ha ht⟩

theorem historical_syntax_allowed {n : ℕ} {a₀ b : TemporalBoundary.Boundary Job}
    (ha : boundaryAllowed a₀) (hb : boundaryAllowed b)
    {L : List (Entry (TemporalBoundary.Boundary Job))} (hL : entriesAllowed n L)
    {cut : Cut} (hc : cutAllowed n cut) :
    (historicalSyntax a₀ b L cut).Allowed n :=
  source_formula_allowed ⟨hb,
    old_allowed_compl (flat_union_allowed ha (carry_allowed hL hc))⟩

structure Language {T : ℕ} (N : RawNode Job T) : Prop where
  origin_left : boundaryAllowed N.originLeft
  origin : N.origin.Allowed (Fintype.card Job)
  entries : entriesAllowed (Fintype.card Job) N.list
  incoming : ∀ s, N.incoming = some s →
    s.extension.Allowed (Fintype.card Job) ∧ s.directCutoff.Allowed (Fintype.card Job)

theorem root_language {P : Precedence Job} {T : ℕ} (σ : Schedule P T) :
    Language (rawRoot P σ) := by
  refine ⟨trivial, trivial, ?_, ?_⟩
  · intro e he
    have heq : e = .root none := List.mem_singleton.mp he
    subst e
    trivial
  · intro s hs
    cases hs

theorem RawSameData.language {T : ℕ} {N : RawNode Job T}
    (e : RawSameData N) (h : Language N) : Language e.child := by
  have hc : cutAllowed (Fintype.card Job) e.cut :=
    cut_attained_allowed (fun x => N.frame.rank_bound x) e.cut_attained
  have hcarry := carry_allowed h.entries hc
  have hleft := boundary_allowed_placed N.left_placed
  have hright := boundary_allowed_placed N.right_placed
  refine ⟨h.origin_left, h.origin, prune_allowed ?_, ?_⟩
  · intro f hf
    rcases List.mem_append.mp hf with hf | hf
    · exact hcarry f hf
    · have heq : f = .injection N.left N.right none := List.mem_singleton.mp hf
      subst f
      exact ⟨hleft, hright, trivial⟩
  · intro s hs
    have heq : e.creation = s := Option.some.inj hs
    subst s
    exact ⟨historical_syntax_allowed h.origin_left hright h.entries hc,
      hright, Syntax.allowed_compl (list_syntax_allowed h.origin_left h.origin hcarry)⟩

theorem RawSwitchData.language {T : ℕ} {N : RawNode Job T}
    (e : RawSwitchData N) (h : Language N) : Language e.child := by
  have hA := boundary_allowed_placed (placed_reverse N.right_placed)
  have hancestor := boundary_allowed_placed (placed_reverse e.creation.outerRight_placed)
  have hcenter := boundary_allowed_placed e.creation.center_placed
  have hext := (h.incoming e.creation e.chronology).1
  have hr : e.r + 1 ≤ Fintype.card Job + 1 := by have := e.rank_bound; omega
  have hlow : (sourceFormula (switchedLowFormula N.right.reverse e.r)).Allowed
      (Fintype.card Job) :=
    source_formula_allowed ⟨hA, by
      change e.r ≤ Fintype.card Job + 1
      have := e.rank_bound
      omega⟩
  refine ⟨hA, ⟨hancestor, hA, hcenter, Syntax.allowed_flip hext⟩, prune_allowed ?_, ?_⟩
  · intro f hf
    simp only [List.mem_cons, List.mem_nil_iff, or_false] at hf
    rcases hf with rfl | rfl
    · exact hr
    · trivial
  · intro s hs
    have heq : e.creationRecord = s := Option.some.inj hs
    subst s
    exact ⟨hlow, hlow⟩

theorem RawHistory.language {T : ℕ} {N : RawNode Job T} (history : RawHistory N) :
    Language N := by
  induction history with
  | root P σ => exact root_language σ
  | same past e ih => exact e.language ih
  | switched past e ih => exact e.language ih

theorem RawHistory.global_node_source_language {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) : (nodeSyntax N).Allowed (Fintype.card Job) := by
  have h := history.language
  have hleft := boundary_allowed_placed N.left_placed
  have hright := boundary_allowed_placed N.right_placed
  cases hs : N.incoming with
  | none => rw [nodeSyntax, hs]; trivial
  | some s =>
      have houter := boundary_allowed_placed s.outerRight_placed
      have hcenter := boundary_allowed_placed s.center_placed
      have hcut := (h.incoming s hs).2
      rw [nodeSyntax, hs]
      exact ⟨⟨list_syntax_allowed h.origin_left h.origin h.entries, hright, hleft⟩,
        hleft, houter, hright, hcenter, hcut⟩

theorem separator_syntax_allowed {n : ℕ} {B : TemporalBoundary.Boundary Job}
    (hB : boundaryAllowed B) {H : Syntax Job} (hH : H.Allowed n) :
    (separatorSyntax B H).Allowed n :=
  ⟨hB, hH, hB⟩

theorem reverse_split_allowed {n : ℕ} {Z : TemporalBoundary.Boundary Job}
    (hZ : boundaryAllowed Z) {F : Syntax Job} (hF : F.Allowed n) :
    (reverseSplitSyntax Z F).flip.Allowed n :=
  Syntax.allowed_flip ⟨Syntax.allowed_compl hF, hZ⟩

structure SourceSplitCertificate {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (domain : Set Job) (Z : TemporalBoundary.Boundary Job) (z : ℤ)
    (F : Syntax Job) : Prop where
  allowed : F.Allowed (Fintype.card Job)
  reversed_allowed : (reverseSplitSyntax Z F).flip.Allowed (Fintype.card Job)
  split : SplitCertificate σ domain Z z F

theorem RawHistory.same_mark_certified {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (σ : Schedule N.frame T)
    (hp : Reorders N.schedule σ N.a N.b) (cut : Cut)
    (hcut : CutAttained N.data (Inside σ N.a N.b) N.list cut)
    {V Z : TemporalBoundary.Boundary Job} {v z : ℤ}
    (hV : Placed σ V v) (hZ : Placed σ Z z) (hzv : z < v) (hvb : v ≤ N.b)
    (hcenter : Separator σ (Inside σ N.a N.b) (sameCenterLow N σ) V v)
    (hmark : Separator σ (Inside σ N.a v) (sameLow N σ cut) Z z) :
    SourceSplitCertificate σ N.domain Z z
      (relativeSyntax V Z (.lit false false (.predecessors N.right))
        (directSameSyntax N cut)) := by
  have hl := history.language
  have hright := boundary_allowed_placed N.right_placed
  have hc := cut_attained_allowed (fun x => N.frame.rank_bound x) hcut
  have hcarry := carry_allowed hl.entries hc
  have hdirect : (directSameSyntax N cut).Allowed (Fintype.card Job) :=
    ⟨hright, Syntax.allowed_compl (list_syntax_allowed hl.origin_left hl.origin hcarry)⟩
  have hF : (relativeSyntax V Z (.lit false false (.predecessors N.right))
      (directSameSyntax N cut)).Allowed (Fintype.card Job) :=
    ⟨separator_syntax_allowed (boundary_allowed_placed hV) hright,
      separator_syntax_allowed (boundary_allowed_placed hZ) hdirect⟩
  exact ⟨hF, reverse_split_allowed (boundary_allowed_placed hZ) hF,
    history.same_mark_description σ hp cut hV hZ hzv hvb hcenter hmark⟩

theorem RawHistory.switched_mark_certified {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (σ : Schedule N.frame.reverse T)
    (hp : Reorders N.schedule.reverse σ (reverseTime T N.b) (reverseTime T N.a))
    (r : ℕ) (hr : r ≤ Fintype.card Job)
    {V Z : TemporalBoundary.Boundary Job} {v z : ℤ}
    (hV : Placed σ V v) (hZ : Placed σ Z z) (hzv : z < v) (hvb : v ≤ reverseTime T N.a)
    (hcenter : Separator σ (Inside σ (reverseTime T N.b) (reverseTime T N.a))
      (switchCenterLow σ (reverseTime T N.b) (reverseTime T N.a) N.right.reverse) V v)
    (hmark : Separator σ (Inside σ (reverseTime T N.b) v)
      (switchLow σ (reverseTime T N.b) (reverseTime T N.a) N.right.reverse r) Z z) :
    SourceSplitCertificate σ N.domain Z z
      (relativeSyntax V Z (.lit true false (.descendants N.right.reverse))
        (sourceFormula (switchedLowFormula N.right.reverse r))) := by
  have hA := boundary_allowed_placed (placed_reverse N.right_placed)
  have hlow : (sourceFormula (switchedLowFormula N.right.reverse r)).Allowed
      (Fintype.card Job) :=
    source_formula_allowed ⟨hA, by change r ≤ Fintype.card Job + 1; omega⟩
  have hF : (relativeSyntax V Z (.lit true false (.descendants N.right.reverse))
      (sourceFormula (switchedLowFormula N.right.reverse r))).Allowed (Fintype.card Job) :=
    ⟨separator_syntax_allowed (boundary_allowed_placed hV) hA,
      separator_syntax_allowed (boundary_allowed_placed hZ) hlow⟩
  exact ⟨hF, reverse_split_allowed (boundary_allowed_placed hZ) hF,
    history.switched_mark_description σ hp r hV hZ hzv hvb hcenter hmark⟩

theorem RawHistory.same_center_certified {T : ℕ} {N : RawNode Job T}
    (_history : RawHistory N) (σ : Schedule N.frame T)
    (hp : Reorders N.schedule σ N.a N.b)
    {V : TemporalBoundary.Boundary Job} {v : ℤ} (hV : Placed σ V v)
    (hs : Separator σ (Inside σ N.a N.b) (sameCenterLow N σ) V v) :
    SourceSplitCertificate σ N.domain V v
      (separatorSyntax V (.lit false false (.predecessors N.right))) := by
  have heq : N.domain = Inside σ N.a N.b := Set.ext hp.1
  have hright := boundary_allowed_placed N.right_placed
  have hF := separator_syntax_allowed (boundary_allowed_placed hV)
    (show (Syntax.lit false false (.predecessors N.right)).Allowed (Fintype.card Job) from hright)
  refine ⟨hF, reverse_split_allowed (boundary_allowed_placed hV) hF, ?_⟩
  rw [heq]
  apply center_split_certificate hV hs _ (by rfl)
  intro x hx
  change x ∈ Pred N.frame N.right ↔ x ∈ Inside σ N.a N.b ∩ Pred N.frame N.right
  simp [hx]

theorem RawHistory.switched_center_certified {T : ℕ} {N : RawNode Job T}
    (_history : RawHistory N) (σ : Schedule N.frame.reverse T)
    (hp : Reorders N.schedule.reverse σ (reverseTime T N.b) (reverseTime T N.a))
    {V : TemporalBoundary.Boundary Job} {v : ℤ} (hV : Placed σ V v)
    (hs : Separator σ (Inside σ (reverseTime T N.b) (reverseTime T N.a))
      (switchCenterLow σ (reverseTime T N.b) (reverseTime T N.a) N.right.reverse) V v) :
    SourceSplitCertificate σ N.domain V v
      (separatorSyntax V (.lit true false (.descendants N.right.reverse))) := by
  have heq : N.domain = Inside σ (reverseTime T N.b) (reverseTime T N.a) := by
    have he := Set.ext hp.1
    rw [inside_reverse] at he
    exact he
  have hA := boundary_allowed_placed (placed_reverse N.right_placed)
  have hF := separator_syntax_allowed (boundary_allowed_placed hV)
    (show (Syntax.lit true false (.descendants N.right.reverse)).Allowed (Fintype.card Job) from hA)
  refine ⟨hF, reverse_split_allowed (boundary_allowed_placed hV) hF, ?_⟩
  rw [heq]
  apply center_split_certificate hV hs _ (by rfl)
  intro x hx
  change x ∉ D N.frame.reverse N.right.reverse ↔ _
  simp [switchCenterLow, hx]

def FrameSame (P Q : Precedence Job) : Prop :=
  (∀ x y, P.rel x y ↔ Q.rel x y) ∧ ∀ x, P.rank x = Q.rank x

theorem frame_same_refl (P : Precedence Job) : FrameSame P P :=
  ⟨fun _ _ => Iff.rfl, fun _ => rfl⟩

theorem frame_same_reverse {P Q : Precedence Job} (h : FrameSame P Q) :
    FrameSame P.reverse Q.reverse := by
  refine ⟨fun x y => h.1 y x, ?_⟩
  intro x
  simp only [Precedence.reverse, h.2 x]

theorem frame_same_trans {P Q R : Precedence Job}
    (h : FrameSame P Q) (k : FrameSame Q R) : FrameSame P R :=
  ⟨fun x y => (h.1 x y).trans (k.1 x y), fun x => (h.2 x).trans (k.2 x)⟩

theorem frame_same_double_reverse (P : Precedence Job) : FrameSame P.reverse.reverse P :=
  ⟨fun _ _ => Iff.rfl, rank_reverse_reverse P⟩

theorem test_frame_same {P Q : Precedence Job} (h : FrameSame P Q) (t : Test Job) :
    t.denote P = t.denote Q := by
  cases t with
  | top | bot | triple _ => rfl
  | descendants B | predecessors B | weakDescendants B | weakPredecessors B =>
      cases B with
      | left | right => rfl
      | actual F =>
          ext x
          simp only [Test.denote, D, Pred, WeakD, WeakPred, Set.mem_union,
            Set.mem_setOf_eq, TemporalBoundary.Boundary.jobs]
          simp_rw [h.1]
  | ge r | le r => ext x; simp [Test.denote, h.2 x]

theorem syntax_frame_same {P Q : Precedence Job} (h : FrameSame P Q) (F : Syntax Job) :
    F.denote P = F.denote Q := by
  induction F with
  | lit n o t =>
      cases n <;> cases o <;>
        simp only [Syntax.denote, Bool.false_eq_true, ↓reduceIte,
          test_frame_same h, test_frame_same (frame_same_reverse h)]
  | meet f g ihf ihg | join f g ihf ihg => simp_all [Syntax.denote]

theorem syntax_flip_denote_other (P : Precedence Job) (F : Syntax Job) :
    F.flip.denote P = F.denote P.reverse := by
  rw [← syntax_frame_same (frame_same_double_reverse P) F.flip]
  exact syntax_flip_denote P.reverse F

inductive RootedHistory {T : ℕ} (P : Precedence Job) (σ : Schedule P T) :
    RawNode Job T → Prop
  | root : RootedHistory P σ (rawRoot P σ)
  | same {N : RawNode Job T} (past : RootedHistory P σ N) (e : RawSameData N) :
      RootedHistory P σ e.child
  | switched {N : RawNode Job T} (past : RootedHistory P σ N) (e : RawSwitchData N) :
      RootedHistory P σ e.child

theorem RootedHistory.raw {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (h : RootedHistory P σ N) : RawHistory N := by
  induction h with
  | root => exact .root P σ
  | same past e ih => exact .same ih e
  | switched past e ih => exact .switched ih e

theorem RootedHistory.two_frames {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {N : RawNode Job T} (h : RootedHistory P σ N) :
    FrameSame N.frame P ∨ FrameSame N.frame P.reverse := by
  induction h with
  | root => exact Or.inl (frame_same_refl P)
  | same past e ih => exact ih
  | switched past e ih =>
      rcases ih with hf | hf
      · exact Or.inr (frame_same_reverse hf)
      · exact Or.inl (frame_same_trans (frame_same_reverse hf) (frame_same_double_reverse P))

theorem RootedHistory.original_global_description {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {N : RawNode Job T} (h : RootedHistory P σ N) :
    ∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧ F.denote P = N.domain := by
  have he := h.raw.global_node_description
  have hl := h.raw.global_node_source_language
  rcases h.two_frames with hf | hf
  · refine ⟨nodeSyntax N, hl, he.2, ?_⟩
    rw [← syntax_frame_same hf]
    exact he.1
  · refine ⟨(nodeSyntax N).flip, Syntax.allowed_flip hl, ?_, ?_⟩
    · simpa only [syntax_flip_leaves] using he.2
    · rw [syntax_flip_denote_other, ← syntax_frame_same hf]
      exact he.1

theorem RootedHistory.construction_integration {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {N : RawNode Job T} (history : RootedHistory P σ N) :
    Derived N ∧ Language N ∧ (injections N.list).length ≤ 3 ∧
      (∀ τ : Schedule N.frame T, Reorders N.schedule τ N.a N.b →
        LocalI1 N.data (Inside τ N.a N.b) N.list N.left N.right ∧
          I2 τ N.left N.a N.qualifiers ∧ I3 τ N.left N.a N.b N.qualifiers N.key) ∧
      (∃ F : Syntax Job, F.Allowed (Fintype.card Job) ∧ F.leaves < 500 ∧
        F.denote P = N.domain) :=
  ⟨history.raw.derived, history.raw.language, history.raw.injection_bound,
    history.raw.future_invariants, history.original_global_description⟩

theorem RawHistory.entry_certificates {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) :
    ∀ e ∈ N.list,
      (entrySyntax N.originLeft N.origin e).denote N.frame = e.denote N.data ∧
      TemporalBoundary.IsUp N.frame ((entrySyntax N.originLeft N.origin e).denote N.frame) ∧
      (entrySyntax N.originLeft N.origin e).leaves ≤ 25 ∧
      (entrySyntax N.originLeft N.origin e).Allowed (Fintype.card Job) := by
  have h := history.derived
  have hl := history.language
  intro e he
  have heq := entry_syntax_denote N.frame N.originLeft N.originParent N.origin e
  refine ⟨heq, ?_, entry_syntax_small N.originLeft N.origin h.origin_small e,
    entry_syntax_allowed hl.origin_left hl.origin (hl.entries e he)⟩
  rw [heq]
  exact entry_up (frame_laws _ _ _ _) h.origin_up e

theorem RawHistory.global_parts {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (s : Creation N.schedule N.right N.a N.b)
    (hs : N.incoming = some s) :
    (highSyntax N).Allowed (Fintype.card Job) ∧
      (lowSyntax N s).Allowed (Fintype.card Job) ∧
      (highSyntax N).leaves ≤ 197 ∧ (lowSyntax N s).leaves ≤ 209 ∧
      (highSyntax N).denote N.frame = N.domain \ s.low ∧
      (lowSyntax N s).denote N.frame = N.domain ∩ s.low := by
  have h := history.derived
  have hl := history.language
  have hleft := boundary_allowed_placed N.left_placed
  have hright := boundary_allowed_placed N.right_placed
  have houter := boundary_allowed_placed s.outerRight_placed
  have hcenter := boundary_allowed_placed s.center_placed
  have hlist := list_syntax_small N.originLeft N.origin h.origin_small N.list
  have hfive := h.five
  have hcut := (h.incoming s hs).direct_small
  refine ⟨⟨list_syntax_allowed hl.origin_left hl.origin hl.entries, hright, hleft⟩,
    ⟨hleft, houter, hright, hcenter, (hl.incoming s hs).2⟩,
    ?_, ?_, global_high h s hs, global_low h s hs⟩
  · simp only [highSyntax, Syntax.leaves]
    omega
  · simp only [lowSyntax, Syntax.leaves]
    omega

theorem RawHistory.future_global_description {T : ℕ} {N : RawNode Job T}
    (history : RawHistory N) (τ : Schedule N.frame T)
    (hr : Reorders N.schedule τ N.a N.b) :
    (nodeSyntax N).denote N.frame = Inside τ N.a N.b ∧
      (nodeSyntax N).Allowed (Fintype.card Job) ∧ (nodeSyntax N).leaves < 500 := by
  have heq : N.domain = Inside τ N.a N.b := Set.ext hr.1
  exact ⟨history.global_node_description.1.trans heq,
    history.global_node_source_language, history.global_node_description.2⟩

end LiteralConstruction
