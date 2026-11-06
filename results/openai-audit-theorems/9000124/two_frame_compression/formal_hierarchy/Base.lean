import Mathlib

-- BEGIN research/two_frame_compression/formal_construction/Main.lean

-- BEGIN research/two_frame_compression/formal_lists/Main.lean

set_option autoImplicit false
set_option maxHeartbeats 800000

namespace SameFrameHistory

variable {Job Boundary : Type*}

structure Data (Job Boundary : Type*) where
  rank : Job → ℕ
  D : Boundary → Set Job
  P : Boundary → Set Job
  a₀ : Boundary
  Q₀ : Set Job
  G₀ : Set Job

def IsUp (R : Job → Job → Prop) (A : Set Job) : Prop :=
  ∀ ⦃x y⦄, R x y → x ∈ A → y ∈ A

def IsDown (R : Job → Job → Prop) (A : Set Job) : Prop :=
  ∀ ⦃x y⦄, R x y → y ∈ A → x ∈ A

structure FrameLaws (C : Data Job Boundary) (R : Job → Job → Prop) : Prop where
  rank_mono : ∀ ⦃x y⦄, R x y → C.rank x ≤ C.rank y
  D_up : ∀ a, IsUp R (C.D a)
  P_down : ∀ b, IsDown R (C.P b)

def suffix (C : Data Job Boundary) (k : ℕ) : Set Job :=
  {x | k ≤ C.rank x}

def threshold (C : Data Job Boundary) (A : Set Job) : Option ℕ → Set Job
  | none => A
  | some k => A ∩ suffix C k

def tighten (r : ℕ) : Option ℕ → Option ℕ
  | none => some r
  | some k => some (max k r)

inductive Entry (Boundary : Type*)
  | first (k : ℕ)
  | root (k : Option ℕ)
  | second (k : Option ℕ)
  | injection (a b : Boundary) (k : Option ℕ)
  deriving DecidableEq

def Entry.denote (C : Data Job Boundary) : Entry Boundary → Set Job
  | .first k => C.G₀ ∩ suffix C k
  | .root k => threshold C Set.univ k
  | .second k => threshold C (C.D C.a₀) k
  | .injection a b k => threshold C (C.D a \ C.P b) k

def Entry.trim (r : ℕ) : Entry Boundary → Entry Boundary
  | .first k => .first (max k r)
  | .root k => .root (tighten r k)
  | .second k => .second (tighten r k)
  | .injection a b k => .injection a b (tighten r k)

def Entry.Simple : Entry Boundary → Prop
  | .first _ => False
  | _ => True

def Entry.Injection : Entry Boundary → Prop
  | .injection _ _ _ => True
  | _ => False

def AllSimple (L : List (Entry Boundary)) : Prop :=
  ∀ e ∈ L, e.Simple

def AllInjections (L : List (Entry Boundary)) : Prop :=
  ∀ e ∈ L, e.Injection

theorem injection_simple {e : Entry Boundary} (h : e.Injection) : e.Simple := by
  cases e <;> simp_all [Entry.Injection, Entry.Simple]

theorem injections_simple {L : List (Entry Boundary)}
    (h : AllInjections L) : AllSimple L :=
  fun e he => injection_simple (h e he)

theorem trim_simple (r : ℕ) {e : Entry Boundary} (h : e.Simple) :
    (e.trim r).Simple := by
  cases e <;> simp_all [Entry.Simple, Entry.trim]

theorem trim_trim (r s : ℕ) (e : Entry Boundary) :
    (e.trim r).trim s = e.trim (max r s) := by
  cases e with
  | first k => simp [Entry.trim, max_assoc]
  | root k => cases k <;> simp [Entry.trim, tighten, max_assoc]
  | second k => cases k <;> simp [Entry.trim, tighten, max_assoc]
  | injection a b k => cases k <;> simp [Entry.trim, tighten, max_assoc]

theorem first_many_trims (rs : List ℕ) (h : ℕ) :
    rs.foldl (fun e r => e.trim r) (Entry.first (Boundary := Boundary) h) =
      .first (rs.foldl max h) := by
  induction rs generalizing h with
  | nil => rfl
  | cons r rs ih => simpa only [List.foldl_cons, Entry.trim] using ih (max h r)

theorem trim_denote (C : Data Job Boundary) (r : ℕ) (e : Entry Boundary) :
    (e.trim r).denote C = e.denote C ∩ suffix C r := by
  cases e with
  | first k =>
      ext x
      simp [Entry.trim, Entry.denote, suffix, and_assoc]
  | root k =>
      cases k <;> ext x <;>
        simp [Entry.trim, Entry.denote, threshold, tighten, suffix]
  | second k =>
      cases k <;> ext x <;>
        simp [Entry.trim, Entry.denote, threshold, tighten, suffix,
          and_assoc]
  | injection a b k =>
      cases k <;> ext x <;>
        simp [Entry.trim, Entry.denote, threshold, tighten, suffix,
          and_assoc]

def Qual (C : Data Job Boundary) (L : List (Entry Boundary)) : Set Job :=
  {x | ∃ e ∈ L, x ∈ e.denote C}

@[simp] theorem qual_nil (C : Data Job Boundary) :
    Qual C [] = ∅ := by ext x; simp [Qual]

@[simp] theorem mem_qual_cons (C : Data Job Boundary) (x : Job)
    (e : Entry Boundary) (L : List (Entry Boundary)) :
    x ∈ Qual C (e :: L) ↔ x ∈ e.denote C ∨ x ∈ Qual C L := by
  simp [Qual]

@[simp] theorem qual_append (C : Data Job Boundary)
    (L M : List (Entry Boundary)) :
    Qual C (L ++ M) = Qual C L ∪ Qual C M := by
  ext x
  simp [Qual, or_and_right, exists_or]

-- A zero-based number of discarded entries; the manuscript's d is d + 1.
def carryAt (L : List (Entry Boundary)) (d r : ℕ) : List (Entry Boundary) :=
  match L, d with
  | [], _ => []
  | e :: L, 0 => e.trim r :: L
  | _ :: L, d + 1 => carryAt L d r

abbrev Cut := Option (ℕ × ℕ)

def carry (L : List (Entry Boundary)) : Cut → List (Entry Boundary)
  | none => []
  | some (d, r) => carryAt L d r

theorem carryAt_length (L : List (Entry Boundary)) (d r : ℕ) :
    (carryAt L d r).length ≤ L.length := by
  induction L generalizing d with
  | nil => simp [carryAt]
  | cons e L ih =>
      cases d with
      | zero => simp [carryAt]
      | succ d =>
          simp only [carryAt, List.length_cons]
          exact (ih d).trans (Nat.le_succ _)

theorem carry_length (L : List (Entry Boundary)) (c : Cut) :
    (carry L c).length ≤ L.length := by
  cases c with
  | none => simp [carry]
  | some p => exact carryAt_length L p.1 p.2

theorem carryAt_simple {L : List (Entry Boundary)} (h : AllSimple L)
    (d r : ℕ) : AllSimple (carryAt L d r) := by
  induction L generalizing d with
  | nil => simp [AllSimple, carryAt]
  | cons e L ih =>
      have he : e.Simple := h e (by simp)
      have hL : AllSimple L := fun f hf => h f (by simp [hf])
      cases d with
      | zero =>
          intro f hf
          simp only [carryAt, List.mem_cons] at hf
          rcases hf with rfl | hf
          · exact trim_simple r he
          · exact hL f hf
      | succ d => exact ih hL d

noncomputable def prune (C : Data Job Boundary) (U : Set Job)
    (L : List (Entry Boundary)) : List (Entry Boundary) :=
  L.filter (fun e => @decide (∃ x ∈ U, x ∈ e.denote C) (Classical.propDecidable _))

theorem prune_cons (C : Data Job Boundary) (U : Set Job)
    (e : Entry Boundary) (L : List (Entry Boundary)) :
    prune C U (e :: L) =
      @ite (List (Entry Boundary)) (∃ x ∈ U, x ∈ e.denote C)
        (Classical.propDecidable _) (e :: prune C U L) (prune C U L) := by
  classical
  simp [prune, List.filter_cons]

theorem prune_simple (C : Data Job Boundary) (U : Set Job)
    {L : List (Entry Boundary)} (h : AllSimple L) :
    AllSimple (prune C U L) := by
  intro e he
  exact h e (List.mem_filter.mp he).1

theorem prune_injections (C : Data Job Boundary) (U : Set Job)
    {L : List (Entry Boundary)} (h : AllInjections L) :
    AllInjections (prune C U L) := by
  intro e he
  exact h e (List.mem_filter.mp he).1

theorem prune_local (C : Data Job Boundary) (U : Set Job)
    (L : List (Entry Boundary)) :
    U ∩ Qual C (prune C U L) = U ∩ Qual C L := by
  classical
  ext x
  constructor
  · rintro ⟨hx, e, he, hxe⟩
    exact ⟨hx, e, (List.mem_filter.mp he).1, hxe⟩
  · rintro ⟨hx, e, he, hxe⟩
    refine ⟨hx, e, ?_, hxe⟩
    exact List.mem_filter.mpr ⟨he, by simpa using (show ∃ y ∈ U, y ∈ e.denote C
      from ⟨x, hx, hxe⟩)⟩

-- This invariant is proved from the trace, not supplied to the main theorem.
inductive Shape (C : Data Job Boundary) (U : Set Job) :
    List (Entry Boundary) → Prop
  | ordinary {L} (simple : AllSimple L) : Shape C U L
  | paired (k : ℕ) (T : List (Entry Boundary))
      (tail : AllInjections T) (inside : U ⊆ C.Q₀) :
      Shape C U (.first k :: .second none :: T)
  | lone (k : ℕ) (T : List (Entry Boundary))
      (tail : AllInjections T) (inside : U ⊆ C.Q₀)
      (absent : ∀ x ∈ U, x ∉ C.D C.a₀) :
      Shape C U (.first k :: T)

theorem Shape.shrink {C : Data Job Boundary} {U V : Set Job}
    {L : List (Entry Boundary)} (h : Shape C U L) (hVU : V ⊆ U) :
    Shape C V L := by
  cases h with
  | ordinary hs => exact .ordinary hs
  | paired k T ht hu => exact .paired k T ht (hVU.trans hu)
  | lone k T ht hu hd =>
      exact .lone k T ht (hVU.trans hu) (fun x hx => hd x (hVU hx))

theorem Shape.afterCarryAt {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (h : Shape C U L) (d r : ℕ) :
    Shape C U (carryAt L d r) := by
  cases h with
  | ordinary hs => exact .ordinary (carryAt_simple hs d r)
  | paired k T ht hu =>
      cases d with
      | zero => exact .paired (max k r) T ht hu
      | succ d =>
          have hs : AllSimple (.second none :: T) := by
            intro e he
            rcases List.mem_cons.mp he with rfl | he
            · trivial
            · exact injections_simple ht e he
          exact .ordinary (carryAt_simple hs d r)
  | lone k T ht hu hd =>
      cases d with
      | zero => exact .lone (max k r) T ht hu hd
      | succ d => exact .ordinary (carryAt_simple (injections_simple ht) d r)

theorem Shape.afterCarry {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (h : Shape C U L) (c : Cut) :
    Shape C U (carry L c) := by
  cases c with
  | none => exact .ordinary (by simp [AllSimple, carry])
  | some p => exact h.afterCarryAt p.1 p.2

theorem Shape.append_injection {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (h : Shape C U L) (a b : Boundary) :
    Shape C U (L ++ [.injection a b none]) := by
  have hi {T : List (Entry Boundary)} (ht : AllInjections T) :
      AllInjections (T ++ [.injection a b none]) := by
    intro e he
    rcases List.mem_append.mp he with he | he
    · exact ht e he
    · simp only [List.mem_singleton] at he
      subst e
      trivial
  cases h with
  | ordinary hs =>
      apply Shape.ordinary
      intro e he
      rcases List.mem_append.mp he with he | he
      · exact hs e he
      · simp only [List.mem_singleton] at he
        subst e
        trivial
  | paired k T ht hu => exact .paired k _ (hi ht) hu
  | lone k T ht hu hd => exact .lone k _ (hi ht) hu hd

theorem Shape.afterPrune {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (h : Shape C U L) :
    Shape C U (prune C U L) := by
  classical
  cases h with
  | ordinary hs => exact .ordinary (prune_simple C U hs)
  | paired k T ht hu =>
      by_cases hf : ∃ x ∈ U, x ∈ (Entry.first k).denote C
      · by_cases hd : ∃ x ∈ U, x ∈ (Entry.second none).denote C
        · simpa only [prune_cons, if_pos hf, if_pos hd]
            using (Shape.paired (C := C) k (prune C U T)
              (prune_injections C U ht) hu)
        · have hempty : ∀ x ∈ U, x ∉ C.D C.a₀ :=
            fun x hx hdx => hd ⟨x, hx, hdx⟩
          simpa only [prune_cons, if_pos hf, if_neg hd]
            using (Shape.lone (C := C) k (prune C U T)
              (prune_injections C U ht) hu hempty)
      · have hs : AllSimple (prune C U (.second none :: T)) :=
          prune_simple C U (by
            intro e he
            rcases List.mem_cons.mp he with rfl | he
            · trivial
            · exact injections_simple ht e he)
        simpa only [prune_cons, if_neg hf] using (Shape.ordinary (C := C) (U := U) hs)
  | lone k T ht hu hd =>
      by_cases hf : ∃ x ∈ U, x ∈ (Entry.first k).denote C
      · simpa only [prune_cons, if_pos hf] using
          (Shape.lone (C := C) k (prune C U T) (prune_injections C U ht) hu hd)
      · simpa only [prune_cons, if_neg hf] using
          (Shape.ordinary (C := C) (U := U)
            (prune_simple C U (injections_simple ht)))

-- Constructors describe actual updates; none asserts flattening or an extension.
inductive Run (C : Data Job Boundary) :
    Set Job → List (Entry Boundary) → Prop
  | root : Run C Set.univ [.root none]
  | switched (U : Set Job) (h₀ : ℕ) (inside : U ⊆ C.Q₀) :
      Run C U (prune C U [.first h₀, .second none])
  | same {U L} (history : Run C U L) (V : Set Job) (inside : V ⊆ U)
      (cutoff : Cut) (a b : Boundary) :
      Run C V (prune C V (carry L cutoff ++ [.injection a b none]))

theorem Run.shape {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (h : Run C U L) : Shape C U L := by
  induction h with
  | root =>
      exact .ordinary (by simp [AllSimple, Entry.Simple])
  | switched U h₀ hu =>
      exact (Shape.paired (C := C) h₀ [] (by simp [AllInjections]) hu).afterPrune
  | same history V hv c a b ih =>
      exact (((ih.afterCarry c).append_injection a b).shrink hv).afterPrune

theorem Run.carry_shape {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (h : Run C U L) (c : Cut) :
    Shape C U (carry L c) :=
  h.shape.afterCarry c

inductive Atom (Boundary : Type*)
  | top | bot
  | D (a : Boundary)
  | P (b : Boundary)
  | ge (k : ℕ)
  | le (k : ℕ)

inductive Formula (Boundary : Type*)
  | lit (negated : Bool) (test : Atom Boundary)
  | meet (f g : Formula Boundary)
  | join (f g : Formula Boundary)

def Atom.denote (C : Data Job Boundary) : Atom Boundary → Set Job
  | .top => Set.univ
  | .bot => ∅
  | .D a => C.D a
  | .P b => C.P b
  | .ge k => suffix C k
  | .le k => {x | C.rank x ≤ k}

def Formula.denote (C : Data Job Boundary) : Formula Boundary → Set Job
  | .lit false a => a.denote C
  | .lit true a => (a.denote C)ᶜ
  | .meet f g => f.denote C ∩ g.denote C
  | .join f g => f.denote C ∪ g.denote C

def Formula.leaves : Formula Boundary → ℕ
  | .lit _ _ => 1
  | .meet f g => f.leaves + g.leaves
  | .join f g => f.leaves + g.leaves

def Formula.compl : Formula Boundary → Formula Boundary
  | .lit n a => .lit (!n) a
  | .meet f g => .join f.compl g.compl
  | .join f g => .meet f.compl g.compl

@[simp] theorem compl_leaves (f : Formula Boundary) :
    f.compl.leaves = f.leaves := by
  induction f with
  | lit n a => rfl
  | meet f g ihf ihg => simp [Formula.compl, Formula.leaves, ihf, ihg]
  | join f g ihf ihg => simp [Formula.compl, Formula.leaves, ihf, ihg]

@[simp] theorem compl_denote (C : Data Job Boundary) (f : Formula Boundary) :
    f.compl.denote C = (f.denote C)ᶜ := by
  classical
  induction f with
  | lit n a => cases n <;> simp [Formula.compl, Formula.denote]
  | meet f g ihf ihg =>
      ext x
      simp [Formula.compl, Formula.denote, ihf, ihg]
      tauto
  | join f g ihf ihg =>
      ext x
      simp [Formula.compl, Formula.denote, ihf, ihg]

def addThreshold (f : Formula Boundary) : Option ℕ → Formula Boundary
  | none => f
  | some k => .meet f (.lit false (.ge k))

def simpleFormula (a₀ : Boundary) : Entry Boundary → Formula Boundary
  | .first _ => .lit false .bot
  | .root k => addThreshold (.lit false .top) k
  | .second k => addThreshold (.lit false (.D a₀)) k
  | .injection a b k =>
      addThreshold (.meet (.lit false (.D a)) (.lit true (.P b))) k

theorem simple_formula_denote (C : Data Job Boundary) (e : Entry Boundary)
    (he : e.Simple) : (simpleFormula C.a₀ e).denote C = e.denote C := by
  cases e with
  | first k => exact False.elim he
  | root k => cases k <;> rfl
  | second k => cases k <;> rfl
  | injection a b k => cases k <;> rfl

theorem simple_formula_leaves (a₀ : Boundary) (e : Entry Boundary)
    (he : e.Simple) : (simpleFormula a₀ e).leaves ≤ 3 := by
  cases e with
  | first k => exact False.elim he
  | root k => cases k <;> simp [simpleFormula, addThreshold, Formula.leaves]
  | second k => cases k <;> simp [simpleFormula, addThreshold, Formula.leaves]
  | injection a b k => cases k <;> simp [simpleFormula, addThreshold, Formula.leaves]

theorem injection_untrimmed_leaves (a₀ a b : Boundary) :
    (simpleFormula a₀ (.injection a b none)).leaves = 2 := rfl

theorem injection_trimmed_leaves (a₀ a b : Boundary) (k : ℕ) :
    (simpleFormula a₀ (.injection a b (some k))).leaves = 3 := rfl

theorem up_inter {R : Job → Job → Prop} {A B : Set Job}
    (ha : IsUp R A) (hb : IsUp R B) : IsUp R (A ∩ B) := by
  intro x y hxy hx
  exact ⟨ha hxy hx.1, hb hxy hx.2⟩

theorem up_union {R : Job → Job → Prop} {A B : Set Job}
    (ha : IsUp R A) (hb : IsUp R B) : IsUp R (A ∪ B) := by
  intro x y hxy hx
  exact hx.elim (fun h => Or.inl (ha hxy h)) (fun h => Or.inr (hb hxy h))

theorem up_diff_down {R : Job → Job → Prop} {A B : Set Job}
    (ha : IsUp R A) (hb : IsDown R B) : IsUp R (A \ B) := by
  intro x y hxy hx
  exact ⟨ha hxy hx.1, fun hy => hx.2 (hb hxy hy)⟩

theorem down_diff_up {R : Job → Job → Prop} {A B : Set Job}
    (ha : IsDown R A) (hb : IsUp R B) : IsDown R (A \ B) := by
  intro x y hxy hy
  exact ⟨ha hxy hy.1, fun hx => hy.2 (hb hxy hx)⟩

theorem suffix_up {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) (k : ℕ) : IsUp R (suffix C k) := by
  intro x y hxy hx
  exact hx.trans (laws.rank_mono hxy)

theorem threshold_up {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) {A : Set Job} (ha : IsUp R A) (k : Option ℕ) :
    IsUp R (threshold C A k) := by
  cases k with
  | none => exact ha
  | some k => exact up_inter ha (suffix_up laws k)

theorem simple_entry_up {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) (e : Entry Boundary) (he : e.Simple) :
    IsUp R (e.denote C) := by
  cases e with
  | first k => exact False.elim he
  | root k =>
      apply threshold_up laws (k := k)
      intro x y hxy hx
      trivial
  | second k => exact threshold_up laws (laws.D_up C.a₀) k
  | injection a b k =>
      exact threshold_up laws (up_diff_down (laws.D_up a) (laws.P_down b)) k

theorem entry_up {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) (global_switch_up : IsUp R C.G₀) (e : Entry Boundary) :
    IsUp R (e.denote C) := by
  cases e with
  | first k => exact up_inter global_switch_up (suffix_up laws k)
  | root k => exact simple_entry_up laws (.root k) (by trivial)
  | second k => exact simple_entry_up laws (.second k) (by trivial)
  | injection a b k => exact simple_entry_up laws (.injection a b k) (by trivial)

def simpleUnion (a₀ : Boundary) : List (Entry Boundary) → Formula Boundary
  | [] => .lit false .bot
  | e :: L => .join (simpleFormula a₀ e) (simpleUnion a₀ L)

theorem simple_union_denote (C : Data Job Boundary) {L : List (Entry Boundary)}
    (hs : AllSimple L) : (simpleUnion C.a₀ L).denote C = Qual C L := by
  induction L with
  | nil => simp [simpleUnion, Formula.denote, Atom.denote]
  | cons e L ih =>
      have he := hs e (by simp)
      have hL : AllSimple L := fun f hf => hs f (by simp [hf])
      ext x
      simp [simpleUnion, Formula.denote, simple_formula_denote C e he, ih hL]

theorem simple_union_leaves (a₀ : Boundary) {L : List (Entry Boundary)}
    (hs : AllSimple L) : (simpleUnion a₀ L).leaves ≤ 1 + 3 * L.length := by
  induction L with
  | nil => simp [simpleUnion, Formula.leaves]
  | cons e L ih =>
      have he := simple_formula_leaves a₀ e (hs e (by simp))
      have ht := ih (fun f hf => hs f (by simp [hf]))
      simp only [simpleUnion, Formula.leaves, List.length_cons]
      omega

theorem simple_union_up {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) {L : List (Entry Boundary)} (hs : AllSimple L) :
    IsUp R ((simpleUnion C.a₀ L).denote C) := by
  induction L with
  | nil =>
      intro x y hxy hx
      exact False.elim hx
  | cons e L ih =>
      have he := hs e (by simp)
      have ht : AllSimple L := fun f hf => hs f (by simp [hf])
      change IsUp R ((simpleFormula C.a₀ e).denote C ∪ (simpleUnion C.a₀ L).denote C)
      rw [simple_formula_denote C e he]
      exact up_union (simple_entry_up laws e he) (ih ht)

def flattenedPair (a₀ : Boundary) (k : ℕ) : Formula Boundary :=
  .join (.lit false (.D a₀)) (.lit false (.ge k))

theorem flattened_pair_up {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) (k : ℕ) :
    IsUp R ((flattenedPair C.a₀ k).denote C) :=
  up_union (laws.D_up C.a₀) (suffix_up laws k)

theorem no_first_of_simple {L : List (Entry Boundary)} (hs : AllSimple L) (k : ℕ) :
    Entry.first k ∉ L :=
  fun hk => hs (.first k) hk

theorem Shape.first_survives {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (hshape : Shape C U L) (k : ℕ)
    (survives : Entry.first k ∈ L) :
    ∃ T, AllInjections T ∧ U ⊆ C.Q₀ ∧
      (L = .first k :: .second none :: T ∨
        (L = .first k :: T ∧ ∀ x ∈ U, x ∉ C.D C.a₀)) := by
  cases hshape with
  | ordinary hs => exact False.elim (no_first_of_simple hs k survives)
  | paired j T ht hu =>
      have hn := no_first_of_simple (injections_simple ht) k
      simp only [List.mem_cons] at survives
      rcases survives with he | he | he
      · cases he
        exact ⟨T, ht, hu, Or.inl rfl⟩
      · cases he
      · exact False.elim (hn he)
  | lone j T ht hu hd =>
      have hn := no_first_of_simple (injections_simple ht) k
      simp only [List.mem_cons] at survives
      rcases survives with he | he
      · cases he
        exact ⟨T, ht, hu, Or.inr ⟨rfl, hd⟩⟩
      · exact False.elim (hn he)

theorem Run.first_survives {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (history : Run C U L) (c : Cut) (k : ℕ)
    (survives : Entry.first k ∈ carry L c) :
    ∃ T, AllInjections T ∧ U ⊆ C.Q₀ ∧
      (carry L c = .first k :: .second none :: T ∨
        (carry L c = .first k :: T ∧ ∀ x ∈ U, x ∉ C.D C.a₀)) :=
  (history.carry_shape c).first_survives k survives

theorem Shape.first_absent {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (hshape : Shape C U L)
    (absent : ∀ k, Entry.first k ∉ L) : AllSimple L := by
  cases hshape with
  | ordinary hs => exact hs
  | paired k T ht hu => exact False.elim (absent k (by simp))
  | lone k T ht hu hd => exact False.elim (absent k (by simp))

theorem Run.first_absent {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} (history : Run C U L) (c : Cut)
    (absent : ∀ k, Entry.first k ∉ carry L c) : AllSimple (carry L c) :=
  (history.carry_shape c).first_absent absent

theorem pair_flattening (C : Data Job Boundary) (U : Set Job) (k : ℕ)
    (inside : U ⊆ C.Q₀) (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀) :
    ∀ x ∈ U,
      x ∈ (C.G₀ ∩ suffix C k) ∪ C.D C.a₀ ↔
        x ∈ (flattenedPair C.a₀ k).denote C := by
  intro x hx
  by_cases hd : x ∈ C.D C.a₀
  · simp [flattenedPair, Formula.denote, Atom.denote, hd]
  · have hg : x ∈ C.G₀ := coverage ⟨inside hx, hd⟩
    simp [flattenedPair, Formula.denote, Atom.denote, hd, hg]

theorem lone_flattening (C : Data Job Boundary) (U : Set Job) (k : ℕ)
    (inside : U ⊆ C.Q₀) (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀)
    (absent : ∀ x ∈ U, x ∉ C.D C.a₀) :
    ∀ x ∈ U,
      x ∈ C.G₀ ∩ suffix C k ↔ x ∈ (flattenedPair C.a₀ k).denote C := by
  intro x hx
  have hd := absent x hx
  have hg : x ∈ C.G₀ := coverage ⟨inside hx, hd⟩
  simp [flattenedPair, Formula.denote, Atom.denote, hd, hg]

theorem Shape.small_upset {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) {U : Set Job} {L : List (Entry Boundary)}
    (shape : Shape C U L) (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀) :
    ∃ f : Formula Boundary,
      f.leaves ≤ 1 + 3 * L.length ∧ IsUp R (f.denote C) ∧
        ∀ x ∈ U, x ∈ f.denote C ↔ x ∈ Qual C L := by
  cases shape with
  | ordinary hs =>
      refine ⟨simpleUnion C.a₀ _, simple_union_leaves C.a₀ hs,
        simple_union_up laws hs, ?_⟩
      intro x hx
      rw [simple_union_denote C hs]
  | paired k T ht hu =>
      have hs := injections_simple ht
      refine ⟨.join (flattenedPair C.a₀ k) (simpleUnion C.a₀ T), ?_,
        up_union (flattened_pair_up laws k) (simple_union_up laws hs), ?_⟩
      · have hb := simple_union_leaves C.a₀ hs
        simp only [Formula.leaves, flattenedPair, List.length_cons]
        omega
      · intro x hx
        have hf := pair_flattening C U k hu coverage x hx
        simp only [Set.mem_union] at hf
        simp only [Formula.denote, simple_union_denote C hs, mem_qual_cons,
          Entry.denote, threshold]
        change (x ∈ (flattenedPair C.a₀ k).denote C ∨ x ∈ Qual C T) ↔
          ((x ∈ C.G₀ ∩ suffix C k) ∨ x ∈ C.D C.a₀ ∨ x ∈ Qual C T)
        tauto
  | lone k T ht hu hd =>
      have hs := injections_simple ht
      refine ⟨.join (flattenedPair C.a₀ k) (simpleUnion C.a₀ T), ?_,
        up_union (flattened_pair_up laws k) (simple_union_up laws hs), ?_⟩
      · have hb := simple_union_leaves C.a₀ hs
        simp only [Formula.leaves, flattenedPair, List.length_cons]
        omega
      · intro x hx
        have hf := lone_flattening C U k hu coverage hd x hx
        simp only [Formula.denote, simple_union_denote C hs, mem_qual_cons,
          Entry.denote]
        exact or_congr hf.symm Iff.rfl

-- Index zero is a sentinel for nonqualifiers; real membership indices start at one.
noncomputable def largestIndex (C : Data Job Boundary) :
    List (Entry Boundary) → Job → ℕ
  | [], _ => 0
  | e :: L, x => by
      classical
      exact if x ∈ Qual C L then largestIndex C L x + 1
        else if x ∈ e.denote C then 1 else 0

noncomputable def key (C : Data Job Boundary)
    (L : List (Entry Boundary)) (x : Job) : ℕ × ℕ :=
  (largestIndex C L x, C.rank x)

theorem largest_index_pos (C : Data Job Boundary) (L : List (Entry Boundary))
    (x : Job) : 0 < largestIndex C L x ↔ x ∈ Qual C L := by
  classical
  cases L with
  | nil => simp [largestIndex]
  | cons e L =>
      by_cases ht : x ∈ Qual C L
      · simp [largestIndex, ht]
      · by_cases he : x ∈ e.denote C <;> simp [largestIndex, ht, he]

theorem largest_index_zero (C : Data Job Boundary) (L : List (Entry Boundary))
    (x : Job) : largestIndex C L x = 0 ↔ x ∉ Qual C L := by
  have hp := largest_index_pos C L x
  constructor
  · intro hz hq
    have hpos := hp.mpr hq
    omega
  · intro hn
    exact Nat.eq_zero_of_not_pos (fun hpos => hn (hp.mp hpos))

theorem largest_index_le_length (C : Data Job Boundary)
    (L : List (Entry Boundary)) (x : Job) :
    largestIndex C L x ≤ L.length := by
  classical
  induction L with
  | nil => simp [largestIndex]
  | cons e L ih =>
      simp only [largestIndex, List.length_cons]
      split_ifs <;> omega

theorem largest_index_rightmost (C : Data Job Boundary)
    (L : List (Entry Boundary)) (x : Job) (qualifies : x ∈ Qual C L) :
    ∃ A e B, L = A ++ e :: B ∧ x ∈ e.denote C ∧ x ∉ Qual C B ∧
      largestIndex C L x = A.length + 1 := by
  classical
  induction L with
  | nil => simp at qualifies
  | cons f L ih =>
      by_cases ht : x ∈ Qual C L
      · obtain ⟨A, e, B, hL, he, hB, hindex⟩ := ih ht
        refine ⟨f :: A, e, B, by simp [hL], he, hB, ?_⟩
        simp only [largestIndex, if_pos ht, List.length_cons, hindex]
      · have hf : x ∈ f.denote C := (mem_qual_cons C x f L).mp qualifies |>.resolve_right ht
        exact ⟨[], f, L, rfl, hf, ht, by simp [largestIndex, ht, hf]⟩

def KeyGE (d r : ℕ) (k : ℕ × ℕ) : Prop :=
  d + 1 < k.1 ∨ (k.1 = d + 1 ∧ r ≤ k.2)

def KeyLT (d r : ℕ) (k : ℕ × ℕ) : Prop :=
  k.1 < d + 1 ∨ (k.1 = d + 1 ∧ k.2 < r)

theorem key_lt_iff_not_ge (d r : ℕ) (k : ℕ × ℕ) :
    KeyLT d r k ↔ ¬ KeyGE d r k := by
  unfold KeyLT KeyGE
  omega

noncomputable def selectedByKey (C : Data Job Boundary)
    (L : List (Entry Boundary)) : Cut → Set Job
  | none => ∅
  | some (d, r) => {x | KeyGE d r (key C L x)}

theorem carryAt_key (C : Data Job Boundary) (L : List (Entry Boundary))
    (d r : ℕ) (x : Job) :
    x ∈ Qual C (carryAt L d r) ↔ KeyGE d r (key C L x) := by
  classical
  induction L generalizing d with
  | nil => simp [carryAt, KeyGE, key, largestIndex]
  | cons e L ih =>
      cases d with
      | zero =>
          by_cases ht : x ∈ Qual C L
          · have hp := (largest_index_pos C L x).mpr ht
            simp [carryAt, KeyGE, key, largestIndex, ht]
            omega
          · by_cases he : x ∈ e.denote C <;>
              simp [carryAt, KeyGE, key, largestIndex, ht, he, trim_denote, suffix]
      | succ d =>
          simp only [carryAt, ih, KeyGE, key]
          by_cases ht : x ∈ Qual C L
          · simp only [largestIndex, if_pos ht]
            omega
          · have hz := (largest_index_zero C L x).mpr ht
            have hfull : largestIndex C (e :: L) x ≤ 1 := by
              simp only [largestIndex, if_neg ht]
              split_ifs <;> omega
            simp only [hz]
            omega

theorem carry_selected_by_key (C : Data Job Boundary)
    (L : List (Entry Boundary)) (c : Cut) :
    Qual C (carry L c) = selectedByKey C L c := by
  cases c with
  | none => simp [carry, selectedByKey]
  | some p =>
      ext x
      exact carryAt_key C L p.1 p.2 x

theorem selected_subset_qual (C : Data Job Boundary)
    (L : List (Entry Boundary)) (c : Cut) : selectedByKey C L c ⊆ Qual C L := by
  intro x hx
  cases c with
  | none => exact False.elim hx
  | some p =>
      apply (largest_index_pos C L x).mp
      change KeyGE p.1 p.2 (key C L x) at hx
      simp only [KeyGE, key] at hx
      omega

def historicalLow (C : Data Job Boundary) (U : Set Job)
    (L : List (Entry Boundary)) (c : Cut) (b : Boundary) : Set Job :=
  U ∩ (C.P b \ selectedByKey C L c)

structure LocalI1 (C : Data Job Boundary) (U : Set Job)
    (L : List (Entry Boundary)) (a b : Boundary) : Prop where
  old_high : U ∩ Qual C L ⊆ C.P b
  old_low : U \ Qual C L ⊆ C.D a

noncomputable def promotedByKey (C : Data Job Boundary)
    (L : List (Entry Boundary)) : Cut → Set Job
  | none => Qual C L
  | some (d, r) => {x | x ∈ Qual C L ∧ KeyLT d r (key C L x)}

def priorityLow (C : Data Job Boundary) (U : Set Job)
    (L : List (Entry Boundary)) (c : Cut) (b : Boundary) : Set Job :=
  U ∩ ((C.P b \ Qual C L) ∪ promotedByKey C L c)

theorem promoted_by_key_eq (C : Data Job Boundary)
    (L : List (Entry Boundary)) (c : Cut) :
    promotedByKey C L c = Qual C L \ selectedByKey C L c := by
  cases c with
  | none => simp [promotedByKey, selectedByKey]
  | some p =>
      ext x
      simp [promotedByKey, selectedByKey, key_lt_iff_not_ge]

theorem priority_low_eq_historical {C : Data Job Boundary} {U : Set Job}
    {L : List (Entry Boundary)} {a b : Boundary} (localI1 : LocalI1 C U L a b)
    (c : Cut) : priorityLow C U L c b = historicalLow C U L c b := by
  classical
  ext x
  by_cases hx : x ∈ U
  · by_cases hq : x ∈ Qual C L
    · have hp : x ∈ C.P b := localI1.old_high ⟨hx, hq⟩
      simp [priorityLow, historicalLow, promoted_by_key_eq, hx, hq, hp]
    · have hn : x ∉ selectedByKey C L c := fun hs => hq (selected_subset_qual C L c hs)
      simp [priorityLow, historicalLow, promoted_by_key_eq, hx, hq, hn]
  · simp [priorityLow, historicalLow, hx]

theorem Run.carry_small_upset {C : Data Job Boundary} {R : Job → Job → Prop}
    (laws : FrameLaws C R) {U : Set Job} {L : List (Entry Boundary)}
    (history : Run C U L) (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀)
    (five : L.length ≤ 5) (c : Cut) :
    ∃ f : Formula Boundary,
      IsUp R (f.denote C) ∧ f.leaves ≤ 20 ∧
        ∀ x ∈ U, x ∈ f.denote C ↔ x ∈ Qual C (carry L c) := by
  obtain ⟨f, hf, hup, hagree⟩ :=
    (history.carry_shape c).small_upset laws coverage
  have hlen := carry_length L c
  exact ⟨f, hup, by omega, hagree⟩

def lowFormula (b : Boundary) (high : Formula Boundary) : Formula Boundary :=
  .meet (.lit false (.P b)) high.compl

@[simp] theorem low_formula_denote (C : Data Job Boundary) (b : Boundary)
    (high : Formula Boundary) :
    (lowFormula b high).denote C = C.P b \ high.denote C := by
  simp [lowFormula, Formula.denote, Atom.denote, Set.sdiff_eq]

@[simp] theorem low_formula_leaves (b : Boundary) (high : Formula Boundary) :
    (lowFormula b high).leaves = 1 + high.leaves := by
  simp [lowFormula, Formula.leaves]

theorem Run.historical_cutoff_extension {C : Data Job Boundary}
    {R : Job → Job → Prop} (laws : FrameLaws C R)
    {U : Set Job} {L : List (Entry Boundary)} (history : Run C U L)
    (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀) (five : L.length ≤ 5)
    (c : Cut) (b : Boundary) :
    ∃ high low : Formula Boundary,
      IsUp R (high.denote C) ∧ high.leaves ≤ 20 ∧
      IsDown R (low.denote C) ∧ low.leaves ≤ 21 ∧
      low = lowFormula b high ∧
      (∀ x ∈ U, x ∈ high.denote C ↔ x ∈ Qual C (carry L c)) ∧
      U ∩ low.denote C = historicalLow C U L c b := by
  obtain ⟨high, hup, hsize, hagree⟩ :=
    history.carry_small_upset laws coverage five c
  refine ⟨high, lowFormula b high, hup, hsize, ?_, ?_, rfl, hagree, ?_⟩
  · rw [low_formula_denote]
    exact down_diff_up (laws.P_down b) hup
  · rw [low_formula_leaves]
    omega
  · ext x
    by_cases hx : x ∈ U
    · have heq := hagree x hx
      rw [carry_selected_by_key] at heq
      simp only [low_formula_denote, historicalLow, Set.mem_inter_iff,
        Set.mem_sdiff, hx, true_and]
      exact and_congr_right (fun _ => not_congr heq)
    · simp [historicalLow, hx]

theorem Run.priority_historical_cutoff_extension {C : Data Job Boundary}
    {R : Job → Job → Prop} (laws : FrameLaws C R)
    {U : Set Job} {L : List (Entry Boundary)} (history : Run C U L)
    (coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀) (five : L.length ≤ 5)
    (c : Cut) (a b : Boundary) (localI1 : LocalI1 C U L a b) :
    ∃ high low : Formula Boundary,
      IsUp R (high.denote C) ∧ high.leaves ≤ 20 ∧
      IsDown R (low.denote C) ∧ low.leaves ≤ 21 ∧
      low = lowFormula b high ∧
      (∀ x ∈ U, x ∈ high.denote C ↔ x ∈ Qual C (carry L c)) ∧
      U ∩ low.denote C = priorityLow C U L c b := by
  obtain ⟨high, low, hup, hhigh, hdown, hlow, hformula, hagree, hlocal⟩ :=
    history.historical_cutoff_extension laws coverage five c b
  refine ⟨high, low, hup, hhigh, hdown, hlow, hformula, hagree, ?_⟩
  exact hlocal.trans (priority_low_eq_historical localI1 c).symm

def switchedLowFormula (a : Boundary) (r : ℕ) : Formula Boundary :=
  .meet (.lit true (.D a)) (.lit false (.le r))

theorem switched_historical_cutoff_extension {C : Data Job Boundary}
    {R : Job → Job → Prop} (laws : FrameLaws C R)
    (U : Set Job) (a : Boundary) (r : ℕ) :
    (switchedLowFormula a r).leaves = 2 ∧
    IsDown R ((switchedLowFormula a r).denote C) ∧
    U ∩ (switchedLowFormula a r).denote C =
      {x | x ∈ U ∧ x ∉ C.D a ∧ C.rank x ≤ r} := by
  refine ⟨rfl, ?_, ?_⟩
  · intro x y hxy hy
    exact ⟨(fun hx => hy.1 (laws.D_up a hxy hx)),
      (laws.rank_mono hxy).trans hy.2⟩
  · ext x
    simp [switchedLowFormula, Formula.denote, Atom.denote, and_assoc]
    tauto

end SameFrameHistory

-- END research/two_frame_compression/formal_lists/Main.lean

-- BEGIN research/two_frame_compression/formal_boundary/Main.lean

set_option autoImplicit false
set_option maxHeartbeats 1500000
set_option linter.unusedSectionVars false

namespace TemporalBoundary

variable {Job : Type*} [Fintype Job] [DecidableEq Job]

structure Precedence (Job : Type*) [Fintype Job] where
  rel : Job → Job → Prop
  irrefl : ∀ x, ¬ rel x x
  trans : ∀ {x y z}, rel x y → rel y z → rel x z
  rank : Job → ℕ
  rank_injective : Function.Injective rank
  rank_pos : ∀ x, 1 ≤ rank x
  rank_bound : ∀ x, rank x ≤ Fintype.card Job
  rank_strict : ∀ {x y}, rel x y → rank x < rank y

structure Complete (T : ℕ) (f : Job → ℤ) : Prop where
  range : ∀ x, 1 ≤ f x ∧ f x ≤ T
  triple : ∀ t : ℤ, 1 ≤ t → t ≤ T → Nat.card {x // f x = t} = 3

def Feasible (P : Precedence Job) (f : Job → ℤ) : Prop :=
  ∀ ⦃x y⦄, P.rel x y → f x < f y

structure Schedule (P : Precedence Job) (T : ℕ) where
  time : Job → ℤ
  feasible : Feasible P time
  complete : Complete T time

def Inside {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) : Set Job :=
  {x | a < σ.time x ∧ σ.time x < b}

def Reorders {P : Precedence Job} {T : ℕ} (σ τ : Schedule P T)
    (a b : ℤ) : Prop :=
  (∀ x, x ∈ Inside σ a b ↔ x ∈ Inside τ a b) ∧
  ∀ x, x ∉ Inside σ a b → τ.time x = σ.time x

theorem reorders_refl {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) : Reorders σ σ a b :=
  ⟨fun _ => Iff.rfl, fun _ _ => rfl⟩

theorem reorders_trans {P : Precedence Job} {T : ℕ}
    {σ τ υ : Schedule P T} {a b : ℤ}
    (h : Reorders σ τ a b) (k : Reorders τ υ a b) :
    Reorders σ υ a b := by
  refine ⟨fun x => (h.1 x).trans (k.1 x), ?_⟩
  intro x hx
  exact (k.2 x (fun ht => hx ((h.1 x).mpr ht))).trans (h.2 x hx)

theorem reorders_enlarge {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b c d : ℤ}
    (h : Reorders σ τ c d) (hac : a ≤ c) (hdb : d ≤ b) :
    Reorders σ τ a b := by
  have forward : ∀ x, x ∈ Inside σ a b → x ∈ Inside τ a b := by
    intro x hx
    by_cases hc : x ∈ Inside σ c d
    · have ht := (h.1 x).mp hc
      exact ⟨lt_of_le_of_lt hac ht.1, lt_of_lt_of_le ht.2 hdb⟩
    · simpa only [Inside, Set.mem_setOf_eq, h.2 x hc] using hx
  refine ⟨fun x => ⟨forward x, ?_⟩, ?_⟩
  · intro hx
    by_cases hc : x ∈ Inside σ c d
    · exact ⟨lt_of_le_of_lt hac hc.1, lt_of_lt_of_le hc.2 hdb⟩
    · simpa only [Inside, Set.mem_setOf_eq, h.2 x hc] using hx
  · intro x hx
    apply h.2 x
    intro hc
    exact hx ⟨lt_of_le_of_lt hac hc.1, lt_of_lt_of_le hc.2 hdb⟩

inductive Boundary (Job : Type*)
  | left
  | actual (jobs : Finset Job)
  | right

def Boundary.jobs : Boundary Job → Finset Job
  | .left | .right => ∅
  | .actual jobs => jobs

def Boundary.reverse : Boundary Job → Boundary Job
  | .left => .right
  | .right => .left
  | .actual jobs => .actual jobs

def D (P : Precedence Job) : Boundary Job → Set Job
  | .left => Set.univ
  | .right => ∅
  | .actual jobs => {x | ∃ y ∈ jobs, P.rel y x}

def Pred (P : Precedence Job) : Boundary Job → Set Job
  | .left => ∅
  | .right => Set.univ
  | .actual jobs => {x | ∃ y ∈ jobs, P.rel x y}

def WeakD (P : Precedence Job) (B : Boundary Job) : Set Job :=
  D P B ∪ (B.jobs : Set Job)

def WeakPred (P : Precedence Job) (B : Boundary Job) : Set Job :=
  Pred P B ∪ (B.jobs : Set Job)

def Placed {P : Precedence Job} {T : ℕ} (σ : Schedule P T) :
    Boundary Job → ℤ → Prop
  | .left, a => a = 0
  | .right, a => a = (T : ℤ) + 1
  | .actual jobs, a => jobs.card = 3 ∧ ∀ x, x ∈ jobs ↔ σ.time x = a

def IsUp (P : Precedence Job) (A : Set Job) : Prop :=
  ∀ ⦃x y⦄, P.rel x y → x ∈ A → y ∈ A

def IsDown (P : Precedence Job) (A : Set Job) : Prop :=
  ∀ ⦃x y⦄, P.rel x y → y ∈ A → x ∈ A

theorem D_up (P : Precedence Job) (B : Boundary Job) : IsUp P (D P B) := by
  cases B with
  | left => exact fun _ _ _ _ => Set.mem_univ _
  | right => exact fun _ _ _ hx => False.elim hx
  | actual jobs =>
      rintro x y hxy ⟨z, hz, hzx⟩
      exact ⟨z, hz, P.trans hzx hxy⟩

theorem pred_down (P : Precedence Job) (B : Boundary Job) :
    IsDown P (Pred P B) := by
  cases B with
  | left => exact fun _ _ _ hy => False.elim hy
  | right => exact fun _ _ _ _ => Set.mem_univ _
  | actual jobs =>
      rintro x y hxy ⟨z, hz, hyz⟩
      exact ⟨z, hz, P.trans hxy hyz⟩

theorem weakPred_down (P : Precedence Job) (B : Boundary Job) :
    IsDown P (WeakPred P B) := by
  intro x y hxy hy
  rcases hy with hy | hy
  · exact Or.inl (pred_down P B hxy hy)
  · cases B with
    | left => simp [Boundary.jobs] at hy
    | right => exact Or.inl (Set.mem_univ _)
    | actual jobs => exact Or.inl ⟨y, hy, hxy⟩

theorem D_after {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : x ∈ D P B) : a < σ.time x := by
  cases B with
  | left =>
      dsimp [Placed] at hB
      have := (σ.complete.range x).1
      omega
  | right => exact False.elim hx
  | actual jobs =>
      obtain ⟨y, hy, hyx⟩ := hx
      have ht := (hB.2 y).mp hy
      simpa only [ht] using σ.feasible hyx

theorem weakPred_before {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : x ∈ WeakPred P B) : σ.time x ≤ a := by
  cases B with
  | left => simp [WeakPred, Pred, Boundary.jobs] at hx
  | right =>
      dsimp [Placed] at hB
      have := (σ.complete.range x).2
      omega
  | actual jobs =>
      rcases hx with ⟨y, hy, hxy⟩ | hx
      · have ht := (hB.2 y).mp hy
        exact (σ.feasible hxy).le.trans_eq ht
      · exact ((hB.2 x).mp hx).le

theorem at_not_D {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : σ.time x ≤ a) : x ∉ D P B :=
  fun hd => (not_lt_of_ge hx) (D_after hB hd)

def swapTime {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (x y : Job) : Job → ℤ :=
  σ.time ∘ Equiv.swap x y

def ExchangeFeasible {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (x y : Job) : Prop :=
  Feasible P (swapTime σ x y)

theorem complete_reindex {T : ℕ} {f : Job → ℤ}
    (h : Complete T f) (e : Job ≃ Job) : Complete T (f ∘ e) := by
  refine ⟨fun x => h.range (e x), ?_⟩
  intro t ht hT
  let k : {x // (f ∘ e) x = t} ≃ {x // f x = t} :=
    { toFun := fun x => ⟨e x, x.property⟩
      invFun := fun x => ⟨e.symm x, by simpa using x.property⟩
      left_inv := fun x => by ext; simp
      right_inv := fun x => by ext; simp }
  exact (Nat.card_congr k).trans (h.triple t ht hT)

noncomputable def exchanged {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (x y : Job) (h : ExchangeFeasible σ x y) :
    Schedule P T :=
  ⟨swapTime σ x y, h, complete_reindex σ.complete (Equiv.swap x y)⟩

structure Priority (P : Precedence Job) where
  index : Job → ℕ
  injective : Function.Injective index
  respects : ∀ {x y}, P.rel x y → index x < index y

noncomputable def slotJobs {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (t : ℤ) : Finset Job := by
  classical
  exact Finset.univ.filter (fun x => σ.time x = t)

noncomputable def slotKeys {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (t : ℤ) : Finset ℕ :=
  (slotJobs σ t).image π.index

noncomputable def slotWord {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (t : ℤ) : List ℕ :=
  (slotKeys σ π t).sort (· ≤ ·)

noncomputable def sideSlots (a b : ℤ) : List ℤ :=
  (Finset.Ioo a b).sort (· ≤ ·)

noncomputable def word {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a b : ℤ) : List ℕ :=
  (sideSlots a b).flatMap (slotWord σ π)

def Normalized {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a b : ℤ) : Prop :=
  ∀ τ : Schedule P T, Reorders σ τ a b →
    ¬ List.Lex (· < ·) (word τ π a b) (word σ π a b)

theorem orderedInsert_improves (l : List ℕ) {x y : ℕ}
    (hxy : x < y) (hx : x ∉ l) :
    List.Lex (· < ·) (l.orderedInsert (· ≤ ·) x)
      (l.orderedInsert (· ≤ ·) y) := by
  induction l with
  | nil => exact List.Lex.rel hxy
  | cons a l ih =>
      have hxa : x ≠ a := fun h => hx (by simp [h])
      have hxl : x ∉ l := fun h => hx (by simp [h])
      simp only [List.orderedInsert_cons]
      by_cases hxa' : x ≤ a
      · rw [if_pos hxa']
        by_cases hya : y ≤ a
        · rw [if_pos hya]
          exact List.Lex.rel hxy
        · rw [if_neg hya]
          exact List.Lex.rel (lt_of_le_of_ne hxa' hxa)
      · have hya : ¬ y ≤ a := by omega
        rw [if_neg hxa', if_neg hya]
        exact List.Lex.cons (ih hxl)

theorem sort_insert_ordered (s : Finset ℕ) (x : ℕ) (hx : x ∉ s) :
    (insert x s).sort (· ≤ ·) =
      (s.sort (· ≤ ·)).orderedInsert (· ≤ ·) x := by
  apply List.Perm.eq_of_pairwise' (r := (· ≤ ·))
      (Finset.pairwise_sort _ _)
      ((Finset.pairwise_sort s (· ≤ ·)).orderedInsert x _)
  rw [← Multiset.coe_eq_coe]
  rw [Finset.sort_eq,
    Multiset.coe_eq_coe.mpr (List.perm_orderedInsert (· ≤ ·) x (s.sort (· ≤ ·)))]
  change (insert x s).val = x ::ₘ (↑(s.sort (· ≤ ·)) : Multiset ℕ)
  rw [Finset.sort_eq]
  exact Finset.insert_val_of_notMem hx

theorem lex_append_arbitrary {α : Type*} {r : α → α → Prop}
    {l m : List α} (h : List.Lex r l m) (hlen : l.length = m.length)
    (u v : List α) : List.Lex r (l ++ u) (m ++ v) := by
  induction h with
  | nil => simp_all
  | rel h => exact List.Lex.rel h
  | cons h ih =>
      exact List.Lex.cons (ih (by simpa using hlen))

theorem flatMap_lex_at {α : Type*} {f g : ℤ → List α}
    {R : α → α → Prop} (ts : List ℤ) (hs : ts.Pairwise (· < ·))
    {r : ℤ} (hr : r ∈ ts)
    (hb : ∀ t ∈ ts, t < r → f t = g t)
    (ha : List.Lex R (f r) (g r)) (hlen : (f r).length = (g r).length) :
    List.Lex R (ts.flatMap f) (ts.flatMap g) := by
  induction ts with
  | nil => simp at hr
  | cons t ts ih =>
      simp only [List.pairwise_cons] at hs
      rcases List.mem_cons.mp hr with h | h
      · subst t
        simpa only [List.flatMap_cons] using
          lex_append_arbitrary ha hlen (ts.flatMap f) (ts.flatMap g)
      · have ht := hs.1 r h
        have he := hb t (by simp) ht
        simp only [List.flatMap_cons, he]
        apply List.Lex.append_left
        exact ih hs.2 h (fun u hu => hb u (by simp [hu]))

theorem reorders_exchange_inside {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} {a b : ℤ}
    (hx : x ∈ Inside σ a b) (hy : y ∈ Inside σ a b)
    (hf : ExchangeFeasible σ x y) :
    Reorders σ (exchanged σ x y hf) a b := by
  classical
  have he : ∀ z, z ≠ x → z ≠ y →
      (exchanged σ x y hf).time z = σ.time z := by
    intro z hzx hzy
    simp [exchanged, swapTime, Equiv.swap_apply_of_ne_of_ne hzx hzy]
  refine ⟨?_, ?_⟩
  · intro z
    by_cases hzx : z = x
    · subst z
      simpa only [Inside, Set.mem_setOf_eq, exchanged, swapTime,
        Function.comp_apply, Equiv.swap_apply_left] using (iff_of_true hx hy)
    by_cases hzy : z = y
    · subst z
      simpa only [Inside, Set.mem_setOf_eq, exchanged, swapTime,
        Function.comp_apply, Equiv.swap_apply_right] using (iff_of_true hy hx)
    · simp only [Inside, Set.mem_setOf_eq, he z hzx hzy]
  · intro z hz
    exact he z (fun h => hz (h ▸ hx)) (fun h => hz (h ▸ hy))

theorem slotJobs_exchange_before {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} {t : ℤ}
    (hxy : σ.time y < σ.time x) (ht : t < σ.time y)
    (hf : ExchangeFeasible σ x y) :
    slotJobs (exchanged σ x y hf) t = slotJobs σ t := by
  classical
  ext z
  have hxt : σ.time x ≠ t := by omega
  have hyt : σ.time y ≠ t := by omega
  by_cases hzx : z = x
  · subst z
    simp [slotJobs, exchanged, swapTime, hxt, hyt]
  by_cases hzy : z = y
  · subst z
    simp [slotJobs, exchanged, swapTime, hxt, hyt]
  · simp [slotJobs, exchanged, swapTime,
      Equiv.swap_apply_of_ne_of_ne hzx hzy]

theorem slotJobs_exchange_at {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job}
    (hxy : σ.time y < σ.time x) (hf : ExchangeFeasible σ x y) :
    slotJobs (exchanged σ x y hf) (σ.time y) =
      insert x ((slotJobs σ (σ.time y)).erase y) := by
  classical
  have hne : x ≠ y := by intro h; subst y; omega
  have htne : σ.time x ≠ σ.time y := ne_of_gt hxy
  ext z
  by_cases hzx : z = x
  · subst z
    simp [slotJobs, exchanged, swapTime]
  by_cases hzy : z = y
  · subst z
    simp [slotJobs, exchanged, swapTime, hne.symm, htne]
  · simp [slotJobs, exchanged, swapTime, hzx, hzy,
      Equiv.swap_apply_of_ne_of_ne hzx hzy]

theorem slotWord_exchange_improves {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} (π : Priority P) {x y : Job}
    (hxy : σ.time y < σ.time x) (hπ : π.index x < π.index y)
    (hf : ExchangeFeasible σ x y) :
    List.Lex (· < ·) (slotWord (exchanged σ x y hf) π (σ.time y))
      (slotWord σ π (σ.time y)) ∧
    (slotWord (exchanged σ x y hf) π (σ.time y)).length =
      (slotWord σ π (σ.time y)).length := by
  classical
  let s := ((slotJobs σ (σ.time y)).erase y).image π.index
  have hx : π.index x ∉ s := by
    intro h
    obtain ⟨z, hz, he⟩ := Finset.mem_image.mp h
    have hez : z = x := π.injective he
    subst z
    have ht : σ.time x = σ.time y := by
      simpa [slotJobs] using (Finset.mem_erase.mp hz).2
    omega
  have hy : π.index y ∉ s := by
    intro h
    obtain ⟨z, hz, he⟩ := Finset.mem_image.mp h
    exact (Finset.mem_erase.mp hz).1 (π.injective he)
  have hsnew : slotKeys (exchanged σ x y hf) π (σ.time y) = insert (π.index x) s := by
    simp only [slotKeys, slotJobs_exchange_at hxy hf, Finset.image_insert, s]
  have hsold : slotKeys σ π (σ.time y) = insert (π.index y) s := by
    have hyj : y ∈ slotJobs σ (σ.time y) := by simp [slotJobs]
    dsimp [slotKeys, s]
    rw [← Finset.image_insert, Finset.insert_erase hyj]
  simp only [slotWord, hsnew, hsold, sort_insert_ordered s _ hx,
    sort_insert_ordered s _ hy]
  exact ⟨orderedInsert_improves _ hπ (by simpa only [Finset.mem_sort] using hx),
    by simp only [List.orderedInsert_length]⟩

theorem lex_prefix_no_exchange {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {π : Priority P} {a b r : ℤ}
    (hn : Normalized σ π a b) (hτ : Reorders σ τ a b)
    (hp : ∀ t ≤ r, slotJobs τ t = slotJobs σ t)
    {x y : Job} (hx : x ∈ Inside τ a b)
    (hyr : τ.time y = r) (har : a < r) (hry : r < τ.time x)
    (hπ : π.index x < π.index y) : ¬ ExchangeFeasible τ x y := by
  intro hf
  have hrb : r < b := hry.trans hx.2
  have hy : y ∈ Inside τ a b := ⟨by simpa [hyr] using har, by simpa [hyr] using hrb⟩
  let υ := exchanged τ x y hf
  have hυ : Reorders σ υ a b :=
    reorders_trans hτ (reorders_exchange_inside hx hy hf)
  apply hn υ hυ
  apply flatMap_lex_at (sideSlots a b) (Finset.sortedLT_sort _).pairwise
      (r := r)
  · simpa only [sideSlots, Finset.mem_sort, Finset.mem_Ioo] using And.intro har hrb
  · intro t _ htr
    dsimp [slotWord, slotKeys, υ]
    rw [slotJobs_exchange_before (by simpa [hyr] using hry) (by simpa [hyr] using htr) hf,
      hp t htr.le]
  · have h := (slotWord_exchange_improves π (by simpa [hyr] using hry) hπ hf).1
    rw [hyr] at h
    simpa only [slotWord, slotKeys, hp r le_rfl] using h
  · have h := (slotWord_exchange_improves π (by simpa [hyr] using hry) hπ hf).2
    rw [hyr] at h
    simpa only [slotWord, slotKeys, hp r le_rfl] using h

theorem child_reordering_keeps_prefix {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {c d : ℤ} (h : Reorders σ τ c d) :
    ∀ t ≤ c, slotJobs τ t = slotJobs σ t := by
  intro t htc
  classical
  ext x
  simp only [slotJobs, Finset.mem_filter, Finset.mem_univ, true_and]
  by_cases hx : x ∈ Inside σ c d
  · have hx' := (h.1 x).mp hx
    have hσ : σ.time x ≠ t := by intro he; have := hx.1; omega
    have hτ : τ.time x ≠ t := by intro he; have := hx'.1; omega
    simp [hσ, hτ]
  · rw [h.2 x hx]

theorem normalized_child_future_no_exchange {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {π : Priority P} {a b c d : ℤ}
    (hn : Normalized σ π a b) (hτ : Reorders σ τ c d)
    (hac : a < c) (hdb : d ≤ b)
    {x y : Job} (hx : x ∈ Inside τ c d)
    (hy : τ.time y = c) (hπ : π.index x < π.index y) :
    ¬ ExchangeFeasible τ x y :=
  lex_prefix_no_exchange hn (reorders_enlarge hτ hac.le hdb)
    (child_reordering_keeps_prefix hτ)
    ⟨hac.trans hx.1, lt_of_lt_of_le hx.2 hdb⟩ hy hac
    (by simpa [hy] using hx.1) hπ

theorem boundary_jobs_time {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a : ℤ}
    (hB : Placed σ B a) {x : Job} (hx : x ∈ B.jobs) :
    σ.time x = a := by
  cases B with
  | left => simp [Boundary.jobs] at hx
  | right => simp [Boundary.jobs] at hx
  | actual jobs => exact (hB.2 x).mp hx

theorem time_mem_boundary {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a : ℤ}
    (hB : Placed σ B a) {x : Job} (hx : σ.time x = a) :
    x ∈ B.jobs := by
  cases B with
  | left =>
      have hr := (σ.complete.range x).1
      dsimp [Placed] at hB
      omega
  | right =>
      have hr := (σ.complete.range x).2
      dsimp [Placed] at hB
      omega
  | actual jobs => exact (hB.2 x).mpr hx

theorem relation_at_boundary_descends {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a : ℤ}
    (hB : Placed σ B a) {u x : Job} (hu : σ.time u = a)
    (hux : P.rel u x) : x ∈ D P B := by
  have hum := time_mem_boundary hB hu
  cases B with
  | left => exact Set.mem_univ _
  | right => simp [Boundary.jobs] at hum
  | actual jobs => exact ⟨u, hum, hux⟩

theorem exchange_feasible_of_ready {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} (hxy : σ.time y < σ.time x)
    (hpred : ∀ u, P.rel u x → σ.time u < σ.time y)
    (hsucc : ∀ z, P.rel y z → σ.time x < σ.time z) :
    ExchangeFeasible σ x y := by
  have hne : x ≠ y := by intro h; subst y; omega
  intro u z huz
  have old := σ.feasible huz
  by_cases hux : u = x
  · subst u
    by_cases hzx : z = x
    · subst z; exact False.elim (P.irrefl x huz)
    by_cases hzy : z = y
    · subst z; omega
    · simpa only [swapTime, Function.comp_apply, Equiv.swap_apply_left,
        Equiv.swap_apply_of_ne_of_ne hzx hzy] using hxy.trans old
  by_cases huy : u = y
  · subst u
    by_cases hzx : z = x
    · subst z; have := hpred y huz; omega
    by_cases hzy : z = y
    · subst z; exact False.elim (P.irrefl y huz)
    · simpa only [swapTime, Function.comp_apply, Equiv.swap_apply_right,
        Equiv.swap_apply_of_ne_of_ne hzx hzy] using hsucc z huz
  by_cases hzx : z = x
  · subst z
    simpa only [swapTime, Function.comp_apply,
      Equiv.swap_apply_of_ne_of_ne hux huy, Equiv.swap_apply_left] using hpred u huz
  by_cases hzy : z = y
  · subst z
    simpa only [swapTime, Function.comp_apply,
      Equiv.swap_apply_of_ne_of_ne hux huy, Equiv.swap_apply_right] using old.trans hxy
  · simpa only [swapTime, Function.comp_apply,
      Equiv.swap_apply_of_ne_of_ne hux huy,
      Equiv.swap_apply_of_ne_of_ne hzx hzy] using old

theorem successor_forced_by_no_exchange {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} (hxy : σ.time y < σ.time x)
    (hpred : ∀ u, P.rel u x → σ.time u < σ.time y)
    (hno : ¬ ExchangeFeasible σ x y) :
    ∃ z, P.rel y z ∧ σ.time z ≤ σ.time x := by
  classical
  by_contra h
  push Not at h
  exact hno (exchange_feasible_of_ready hxy hpred h)

def Reach (P : Precedence Job) (x y : Job) : Prop :=
  x = y ∨ P.rel x y

theorem reach_trans {P : Precedence Job} {x y z : Job}
    (h : Reach P x y) (k : Reach P y z) : Reach P x z := by
  rcases h with rfl | h
  · exact k
  rcases k with rfl | k
  · exact Or.inr h
  · exact Or.inr (P.trans h k)

theorem trace_strict_successors {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {C : Set Job} {s t : ℤ}
    (hstep : ∀ y ∈ C, s ≤ σ.time y → σ.time y < t →
      ∃ z, z ∈ C ∧ P.rel y z ∧ σ.time z ≤ t)
    {y : Job} (hy : y ∈ C) (hsy : s ≤ σ.time y) (hyt : σ.time y ≤ t) :
    ∃ z, z ∈ C ∧ σ.time z = t ∧ Reach P y z := by
  have aux : ∀ n : ℕ, ∀ y ∈ C, s ≤ σ.time y → σ.time y ≤ t →
      (t - σ.time y).toNat = n →
      ∃ z, z ∈ C ∧ σ.time z = t ∧ Reach P y z := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro y hy hsy hyt he
        by_cases htime : σ.time y = t
        · exact ⟨y, hy, htime, Or.inl rfl⟩
        have hlt : σ.time y < t := lt_of_le_of_ne hyt htime
        obtain ⟨u, hu, hyu, hut⟩ := hstep y hy hsy hlt
        have htimeu := σ.feasible hyu
        have hm : (t - σ.time u).toNat < n := by omega
        obtain ⟨z, hz, hzt, huz⟩ :=
          ih _ hm u hu (by omega) hut rfl
        exact ⟨z, hz, hzt, reach_trans (Or.inr hyu) huz⟩
  exact aux _ y hy hsy hyt rfl

def LowPrefix {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (π : Priority P) (a v : ℤ) (L : Set Job) : Prop :=
  ∀ x ∈ Inside σ a v, x ∈ L →
    ∀ y ∈ Inside σ a v, y ∉ L → π.index x < π.index y

theorem lowPrefix_ideal {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v : ℤ} {L : Set Job}
    (hL : LowPrefix σ π a v L) {u x : Job}
    (hu : u ∈ Inside σ a v) (hx : x ∈ Inside σ a v)
    (hux : P.rel u x) (hxl : x ∈ L) : u ∈ L := by
  by_contra hul
  have h₁ := hL x hx hxl u hu hul
  have h₂ := π.respects hux
  omega

structure EarliestAdvance {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a v : ℤ) (L : Set Job)
    (B : Boundary Job) (s : ℤ) (target : Finset Job) (t : ℤ) : Prop where
  source : Placed σ B s
  target_slot : Placed σ (.actual target) t
  increasing : s < t
  target_in_side : a < t ∧ t < v
  exception : ∃ x, σ.time x = t ∧ x ∈ L ∧ x ∉ D P B
  earliest : ∀ u ∈ Inside σ a v, u ∈ L →
    s < σ.time u → σ.time u < t → u ∈ D P B

theorem earliest_exception_ready {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v s t : ℤ}
    {L : Set Job} {B : Boundary Job} {target : Finset Job}
    (hL : LowPrefix σ π a v L)
    (h : EarliestAdvance σ a v L B s target t) (has : a ≤ s)
    {x : Job} (hxt : σ.time x = t) (hxl : x ∈ L) (hxD : x ∉ D P B) :
    ∀ u, P.rel u x → σ.time u < s := by
  intro u hux
  have hut : σ.time u < t := by simpa [hxt] using σ.feasible hux
  by_contra hus
  have hsu : s ≤ σ.time u := le_of_not_gt hus
  have hx : x ∈ Inside σ a v := by simpa [Inside, hxt] using h.target_in_side
  by_cases hueq : σ.time u = s
  · exact hxD (relation_at_boundary_descends h.source hueq hux)
  · have hsu' : s < σ.time u := lt_of_le_of_ne hsu (Ne.symm hueq)
    have hu : u ∈ Inside σ a v :=
      ⟨lt_of_le_of_lt has hsu', hut.trans h.target_in_side.2⟩
    have hul := lowPrefix_ideal hL hu hx hux hxl
    exact hxD (D_up P B hux (h.earliest u hu hul hsu' hut))

def I2 {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (A : Boundary Job) (a : ℤ) (Q : Set Job) : Prop :=
  ∀ z ∈ Q, σ.time z ≤ a → z ∈ WeakPred P A

def I3 {P : Precedence Job} {T : ℕ} {Key : Type*} [LT Key]
    (σ : Schedule P T) (A : Boundary Job) (a b : ℤ)
    (Q : Set Job) (key : Job → Key) : Prop :=
  ∀ τ : Schedule P T, Reorders σ τ a b →
    ∀ x ∈ Inside τ a b, x ∉ D P A →
      ∀ y ∈ A.jobs, y ∈ Q → key x < key y → ¬ ExchangeFeasible τ x y

inductive ExceptionWalk {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a v : ℤ) (S : Set Job)
    (A : Boundary Job) : Boundary Job → ℤ → Prop
  | start (hA : Placed σ A a) : ExceptionWalk σ π a v S A A a
  | advance {B : Boundary Job} {s t : ℤ} {target : Finset Job}
      (past : ExceptionWalk σ π a v S A B s)
      (L : Set Job) (cut_prefix : LowPrefix σ π a v L)
      (within : ∀ x ∈ Inside σ a v, x ∈ L → x ∈ S)
      (step : EarliestAdvance σ a v L B s target t) :
      ExceptionWalk σ π a v S A (.actual target) t

theorem walk_start_or_interior {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v c : ℤ}
    {S : Set Job} {A B : Boundary Job}
    (h : ExceptionWalk σ π a v S A B c) :
    (B = A ∧ c = a) ∨ (a < c ∧ c < v) := by
  cases h with
  | start _ => exact Or.inl ⟨rfl, rfl⟩
  | advance _ _ _ _ step => exact Or.inr step.target_in_side

theorem walk_placed {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v c : ℤ}
    {S : Set Job} {A B : Boundary Job}
    (h : ExceptionWalk σ π a v S A B c) : Placed σ B c := by
  cases h with
  | start hA => exact hA
  | advance _ _ _ _ step => exact step.target_slot

theorem walk_carry_transport {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {parent σ : Schedule P T}
    {π : Priority P} {a b v c : ℤ} {S Q C : Set Job}
    {oldKey : Job → Key} {A B : Boundary Job}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hvb : v ≤ b)
    (hprep : Reorders parent σ a b) (hI3 : I3 parent A a b Q oldKey)
    (hCup : IsUp P C) (hCQ : C ⊆ Q)
    (hhigh : ∀ y ∈ Inside σ a v, y ∈ C → y ∉ S)
    (hkeys : ∀ x ∈ Inside σ a v, x ∈ S → x ∉ D P A →
      ∀ y ∈ C, oldKey x < oldKey y) :
    ∀ y ∈ A.jobs, y ∈ C →
      ∃ z ∈ B.jobs, z ∈ C ∧ Reach P y z := by
  induction hwalk with
  | start hA =>
      intro y hy hyC
      exact ⟨y, hy, hyC, Or.inl rfl⟩
  | @advance B s t target past L hL hLS step ih =>
      intro y hy hyC
      obtain ⟨u, hu, huC, hyu⟩ := ih y hy hyC
      obtain ⟨x, hxt, hxL, hxD⟩ := step.exception
      have hxE : x ∈ Inside σ a v := by
        simpa [Inside, hxt] using step.target_in_side
      have hsCase := walk_start_or_interior past
      have has : a ≤ s := by rcases hsCase with ⟨_, rfl⟩ | h; exact le_rfl; exact h.1.le
      have hready := earliest_exception_ready hL step has hxt hxL hxD
      have hlocalStep : ∀ q ∈ C, s ≤ σ.time q → σ.time q < t →
          ∃ z, z ∈ C ∧ P.rel q z ∧ σ.time z ≤ t := by
        intro q hq hsq hqt
        have hno : ¬ ExchangeFeasible σ x q := by
          by_cases hqa : σ.time q = a
          · have hsa : s = a := by omega
            have hBA : B = A := by
              rcases hsCase with h | h
              · exact h.1
              · omega
            have hqA : q ∈ A.jobs :=
              time_mem_boundary (by simpa [hBA, hsa] using step.source) hqa
            have hxDA : x ∉ D P A := by simpa [hBA] using hxD
            apply hI3 σ hprep x ⟨hxE.1, lt_of_lt_of_le hxE.2 hvb⟩ hxDA q hqA (hCQ hq)
            exact hkeys x hxE (hLS x hxE hxL) hxDA q hq
          · have haq : a < σ.time q := by omega
            have hqE : q ∈ Inside σ a v := ⟨haq, hqt.trans step.target_in_side.2⟩
            have hqL : q ∉ L := fun hl => hhigh q hqE hq (hLS q hqE hl)
            exact lex_prefix_no_exchange hn (reorders_refl σ a v)
              (fun _ _ => rfl) hxE rfl haq (by simpa [hxt] using hqt)
              (hL x hxE hxL q hqE hqL)
        obtain ⟨z, hqz, hzt⟩ :=
          successor_forced_by_no_exchange (by simpa [hxt] using hqt)
            (fun p hp => lt_of_lt_of_le (hready p hp) hsq) hno
        exact ⟨z, hCup hqz hq, hqz, by simpa [hxt] using hzt⟩
      have hut : σ.time u = s := boundary_jobs_time step.source hu
      obtain ⟨z, hzC, hzt, huz⟩ :=
        trace_strict_successors hlocalStep huC (by omega)
          (by simpa only [hut] using step.increasing.le)
      exact ⟨z, time_mem_boundary step.target_slot hzt, hzC, reach_trans hyu huz⟩

def Precedence.reverse (P : Precedence Job) : Precedence Job where
  rel x y := P.rel y x
  irrefl := P.irrefl
  trans hxy hyz := P.trans hyz hxy
  rank x := Fintype.card Job + 1 - P.rank x
  rank_injective := by
    intro x y he
    change Fintype.card Job + 1 - P.rank x = Fintype.card Job + 1 - P.rank y at he
    apply P.rank_injective
    have hx := P.rank_bound x
    have hy := P.rank_bound y
    omega
  rank_pos := by intro x; have := P.rank_bound x; omega
  rank_bound := by intro x; have := P.rank_pos x; omega
  rank_strict := by
    intro x y h
    have hlt := P.rank_strict h
    have hx := P.rank_bound x
    have hy := P.rank_bound y
    omega

theorem reverse_ranks_sum (P : Precedence Job) (x : Job) :
    P.rank x + P.reverse.rank x = Fintype.card Job + 1 := by
  have := P.rank_bound x
  dsimp [Precedence.reverse]
  omega

def reverseTime (T : ℕ) (t : ℤ) : ℤ := (T : ℤ) + 1 - t

noncomputable def Schedule.reverse {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) : Schedule P.reverse T where
  time x := reverseTime T (σ.time x)
  feasible := by
    intro x y h
    have := σ.feasible h
    dsimp [reverseTime]
    omega
  complete := by
    constructor
    · intro x
      have := σ.complete.range x
      dsimp [reverseTime]
      omega
    · intro t ht hT
      let e : {x // reverseTime T (σ.time x) = t} ≃
          {x // σ.time x = reverseTime T t} :=
        { toFun := fun x => ⟨x, by have := x.property; dsimp [reverseTime] at *; omega⟩
          invFun := fun x => ⟨x, by have := x.property; dsimp [reverseTime] at *; omega⟩
          left_inv := fun _ => rfl
          right_inv := fun _ => rfl }
      exact (Nat.card_congr e).trans
        (σ.complete.triple (reverseTime T t) (by dsimp [reverseTime]; omega)
          (by dsimp [reverseTime]; omega))

@[simp] theorem D_reverse (P : Precedence Job) (B : Boundary Job) :
    D P.reverse B.reverse = Pred P B := by cases B <;> rfl

@[simp] theorem pred_reverse (P : Precedence Job) (B : Boundary Job) :
    Pred P.reverse B.reverse = D P B := by cases B <;> rfl

@[simp] theorem boundary_reverse_jobs (B : Boundary Job) :
    B.reverse.jobs = B.jobs := by cases B <;> rfl

@[simp] theorem weakD_reverse (P : Precedence Job) (B : Boundary Job) :
    WeakD P.reverse B.reverse = WeakPred P B := by simp [WeakD, WeakPred]

@[simp] theorem weakPred_reverse (P : Precedence Job) (B : Boundary Job) :
    WeakPred P.reverse B.reverse = WeakD P B := by simp [WeakD, WeakPred]

theorem placed_reverse {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a) :
    Placed σ.reverse B.reverse (reverseTime T a) := by
  cases B with
  | left => simpa [Placed, Boundary.reverse, reverseTime] using hB
  | right =>
      dsimp [Placed] at hB
      dsimp [Placed, Boundary.reverse, reverseTime]
      omega
  | actual jobs =>
      refine ⟨hB.1, ?_⟩
      intro x
      dsimp [Schedule.reverse, reverseTime]
      rw [hB.2 x]
      omega

@[simp] theorem inside_reverse {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) :
    Inside σ.reverse (reverseTime T b) (reverseTime T a) = Inside σ a b := by
  ext x
  dsimp [Inside, Schedule.reverse, reverseTime]
  omega

theorem reorders_reverse {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b : ℤ} (h : Reorders σ τ a b) :
    Reorders σ.reverse τ.reverse (reverseTime T b) (reverseTime T a) := by
  constructor
  · intro x
    simpa only [inside_reverse] using h.1 x
  · intro x hx
    have ht := h.2 x (by simpa only [inside_reverse] using hx)
    dsimp [Schedule.reverse]
    rw [ht]

structure Separator {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (domain low : Set Job) (B : Boundary Job) (s : ℤ) : Prop where
  earlier_high : ∀ x ∈ domain, x ∉ low → σ.time x < s → x ∈ Pred P B
  later_low : ∀ x ∈ domain, x ∈ low → s < σ.time x → x ∈ D P B

theorem reversed_separator_low_before {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {domain low : Set Job} {B : Boundary Job} {s : ℤ}
    (hB : Placed σ B s)
    (hsep : Separator σ.reverse domain low B.reverse (reverseTime T s))
    {z : Job} (hz : z ∈ domain) (hzL : z ∈ low) (hzt : σ.time z ≤ s) :
    z ∈ WeakPred P B := by
  by_cases he : σ.time z = s
  · exact Or.inr (time_mem_boundary hB he)
  · apply Or.inl
    have ht : reverseTime T s < σ.reverse.time z := by
      dsimp [Schedule.reverse, reverseTime]
      omega
    simpa only [D_reverse] using hsep.later_low z hz hzL ht

def switchG (P : Precedence Job) (ancestorLeft A V : Boundary Job)
    (historicalExtension : Set Job) : Set Job :=
  {x | x ∈ D P ancestorLeft ∧ x ∉ WeakPred P A ∧
    x ∉ WeakPred P V ∧ x ∈ historicalExtension}

theorem switchG_up {P : Precedence Job} {ancestorLeft A V : Boundary Job}
    {Hstar : Set Job} (hHstar : IsUp P Hstar) :
    IsUp P (switchG P ancestorLeft A V Hstar) := by
  rintro x y hxy ⟨hxD, hxA, hxV, hxH⟩
  exact ⟨D_up P ancestorLeft hxy hxD,
    fun hy => hxA (weakPred_down P A hxy hy),
    fun hy => hxV (weakPred_down P V hxy hy), hHstar hxy hxH⟩

theorem switchG_from_incoming_separators {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {ancestorLeft A V : Boundary Job}
    {u v a b w : ℤ} {H centerLow Hstar : Set Job}
    (hU : Placed σ ancestorLeft u) (hA : Placed σ A a) (hV : Placed σ V v)
    (ancestry : u < v ∧ v ≤ a ∧ a < b ∧ b ≤ w)
    (oldCenter : Separator σ.reverse (Inside σ u w) centerLow
      V.reverse (reverseTime T v))
    (oldEndpoint : Separator σ.reverse (Inside σ v w) H
      A.reverse (reverseTime T a))
    (cutoffInOldCone : ∀ x ∈ Inside σ u w, x ∈ H →
      x ∈ Pred P.reverse ancestorLeft.reverse)
    (cutoffInCenter : ∀ x ∈ Inside σ u w, x ∈ H → x ∈ centerLow)
    (extensionOnAllU : ∀ x ∈ Inside σ u w, x ∈ Hstar ↔ x ∈ H)
    (extensionUpset : IsUp P Hstar) :
    IsUp P (switchG P ancestorLeft A V Hstar) ∧
    (∀ x ∈ Inside σ a b, x ∉ D P A →
      x ∈ switchG P ancestorLeft A V Hstar) ∧
    (∀ z ∈ switchG P ancestorLeft A V Hstar, ¬ σ.time z ≤ a) := by
  refine ⟨switchG_up extensionUpset, ?_, ?_⟩
  · intro x hx hxD
    have hxU : x ∈ Inside σ u w := by
      constructor <;> dsimp [Inside, Set.mem_setOf_eq] at hx ⊢ <;> omega
    have hxE : x ∈ Inside σ v w := by
      constructor <;> dsimp [Inside, Set.mem_setOf_eq] at hx ⊢ <;> omega
    have hxH : x ∈ H := by
      by_contra hn
      have ht : σ.reverse.time x < reverseTime T a := by
        dsimp [Schedule.reverse, reverseTime]
        exact sub_lt_sub_left hx.1 _
      exact hxD (by simpa only [pred_reverse] using oldEndpoint.earlier_high x hxE hn ht)
    refine ⟨?_, ?_, ?_, (extensionOnAllU x hxU).mpr hxH⟩
    · simpa only [pred_reverse] using cutoffInOldCone x hxU hxH
    · intro hm
      have := weakPred_before hA hm
      exact (not_le_of_gt hx.1) this
    · intro hm
      have := weakPred_before hV hm
      have hvx : v < σ.time x := lt_of_le_of_lt ancestry.2.1 hx.1
      exact (not_le_of_gt hvx) this
  · rintro z ⟨hzD, hzA, hzV, hzHstar⟩ hza
    have huz : u < σ.time z := D_after hU hzD
    have hzU : z ∈ Inside σ u w := ⟨huz, by omega⟩
    have hzH : z ∈ H := (extensionOnAllU z hzU).mp hzHstar
    by_cases hzv : σ.time z ≤ v
    · exact hzV (reversed_separator_low_before hV oldCenter hzU
        (cutoffInCenter z hzU hzH) hzv)
    · have hzE : z ∈ Inside σ v w := ⟨lt_of_not_ge hzv, hzU.2⟩
      exact hzA (reversed_separator_low_before hA oldEndpoint hzE hzH hza)

theorem walk_initial_placed {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v c : ℤ}
    {S : Set Job} {A B : Boundary Job}
    (h : ExceptionWalk σ π a v S A B c) : Placed σ A a := by
  induction h with
  | start hA => exact hA
  | advance _ _ _ _ _ ih => exact ih

theorem reorders_past_time {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b : ℤ} (h : Reorders σ τ a b)
    {z : Job} (hz : τ.time z ≤ a) : τ.time z = σ.time z := by
  apply h.2 z
  intro hm
  have ht := ((h.1 z).mp hm).1
  omega

theorem I2_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {A : Boundary Job} {a b : ℤ} {Q : Set Job}
    (h : I2 σ A a Q) (hr : Reorders σ τ a b) : I2 τ A a Q := by
  intro z hz hzt
  apply h z hz
  rwa [← reorders_past_time hr hzt]

theorem I3_reorders {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {σ τ : Schedule P T}
    {A : Boundary Job} {a b : ℤ} {Q : Set Job} {key : Job → Key}
    (h : I3 σ A a b Q key) (hr : Reorders σ τ a b) :
    I3 τ A a b Q key :=
  fun υ hυ => h υ (reorders_trans hr hυ)

theorem weakPred_boundary_witness {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a v : ℤ}
    (hA : Placed σ A a) (hav : a < v) (hv : v ≤ (T : ℤ) + 1)
    {z : Job} (hz : z ∈ WeakPred P A) :
    ∃ y ∈ A.jobs, Reach P z y := by
  cases A with
  | left => simp [WeakPred, Pred, Boundary.jobs] at hz
  | right =>
      dsimp [Placed] at hA
      omega
  | actual jobs =>
      rcases hz with ⟨y, hy, hzy⟩ | hz
      · exact ⟨y, hy, Or.inr hzy⟩
      · exact ⟨z, hz, Or.inl rfl⟩

theorem reach_boundary_weakPred {P : Precedence Job} {B : Boundary Job}
    {z y : Job} (hy : y ∈ B.jobs) (hzy : Reach P z y) :
    z ∈ WeakPred P B := by
  rcases hzy with rfl | hzy
  · exact Or.inr hy
  · cases B with
    | left => simp [Boundary.jobs] at hy
    | right => exact Or.inl (Set.mem_univ _)
    | actual jobs => exact Or.inl ⟨y, hy, hzy⟩

theorem carry_past_at_walk_end {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {parent σ : Schedule P T}
    {π : Priority P} {a b v c : ℤ} {S Q C : Set Job}
    {oldKey : Job → Key} {A B : Boundary Job}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hav : a < v) (hv : v ≤ (T : ℤ) + 1)
    (hvb : v ≤ b) (hprep : Reorders parent σ a b)
    (hI2 : I2 parent A a Q) (hI3 : I3 parent A a b Q oldKey)
    (hCup : IsUp P C) (hCQ : C ⊆ Q)
    (hhigh : ∀ y ∈ Inside σ a v, y ∈ C → y ∉ S)
    (hkeys : ∀ x ∈ Inside σ a v, x ∈ S → x ∉ D P A →
      ∀ y ∈ C, oldKey x < oldKey y) :
    ∀ z ∈ C, σ.time z ≤ a → z ∈ WeakPred P B := by
  intro z hz hzt
  have hzold : z ∈ WeakPred P A := I2_reorders hI2 hprep z (hCQ hz) hzt
  obtain ⟨y, hyA, hzy⟩ :=
    weakPred_boundary_witness (walk_initial_placed hwalk) hav hv hzold
  have hyC : y ∈ C := by
    rcases hzy with rfl | hzy
    · exact hz
    · exact hCup hzy hz
  obtain ⟨u, huB, _, hyu⟩ :=
    walk_carry_transport hwalk hn hvb hprep hI3 hCup hCQ hhigh hkeys y hyA hyC
  exact reach_boundary_weakPred huB (reach_trans hzy hyu)

def injection (P : Precedence Job) (A outerRight : Boundary Job) : Set Job :=
  D P A \ Pred P outerRight

theorem I2_from_local_separator {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a v c : ℤ}
    {S preQ childQ : Set Job} (hB : Placed σ B c) (hcv : c < v)
    (hsep : Separator σ (Inside σ a v) S B c)
    (hunion : ∀ x ∈ Inside σ a v, x ∈ preQ ↔ x ∉ S)
    (hprune : childQ ⊆ preQ)
    (hpast : ∀ z ∈ preQ, σ.time z ≤ a → z ∈ WeakPred P B) :
    I2 σ B c childQ := by
  intro z hz hzc
  have hzpre := hprune hz
  by_cases hza : σ.time z ≤ a
  · exact hpast z hzpre hza
  · have hzE : z ∈ Inside σ a v := ⟨lt_of_not_ge hza, lt_of_le_of_lt hzc hcv⟩
    by_cases hze : σ.time z = c
    · exact Or.inr (time_mem_boundary hB hze)
    · exact Or.inl (hsep.earlier_high z hzE ((hunion z hzE).mp hzpre)
        (lt_of_le_of_ne hzc hze))

theorem same_update_I2 {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {parent σ : Schedule P T}
    {π : Priority P} {a b v c : ℤ} {S Q C childQ : Set Job}
    {oldKey : Job → Key} {A B outerRight : Boundary Job}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hav : a < v) (hv : v ≤ (T : ℤ) + 1)
    (hvb : v ≤ b) (hprep : Reorders parent σ a b)
    (hI2 : I2 parent A a Q) (hI3 : I3 parent A a b Q oldKey)
    (hCup : IsUp P C) (hCQ : C ⊆ Q)
    (hhigh : ∀ y ∈ Inside σ a v, y ∈ C → y ∉ S)
    (hkeys : ∀ x ∈ Inside σ a v, x ∈ S → x ∉ D P A →
      ∀ y ∈ C, oldKey x < oldKey y)
    (hsep : Separator σ (Inside σ a v) S B c)
    (hunion : ∀ x ∈ Inside σ a v,
      x ∈ C ∪ injection P A outerRight ↔ x ∉ S)
    (hprune : childQ ⊆ C ∪ injection P A outerRight) :
    I2 σ B c childQ := by
  have hcv : c < v := by
    rcases walk_start_or_interior hwalk with ⟨_, rfl⟩ | h
    · exact hav
    · exact h.2
  apply I2_from_local_separator (walk_placed hwalk) hcv hsep hunion hprune
  intro z hz hza
  rcases hz with hz | hz
  · exact carry_past_at_walk_end hwalk hn hav hv hvb hprep hI2 hI3
      hCup hCQ hhigh hkeys z hz hza
  · exact False.elim (at_not_D (walk_initial_placed hwalk) hza hz.1)

structure ListOrderInterface {P : Precedence Job} {T : ℕ}
    {PreKey ChildKey : Type*} [LT PreKey] [LT ChildKey]
    (σ : Schedule P T) (π : Priority P) (a v c d : ℤ)
    (B : Boundary Job) (preQ childQ : Set Job)
    (preKey : Job → PreKey) (childKey : Job → ChildKey) : Prop where
  pruning_subset : childQ ⊆ preQ
  localI1 : ∀ x ∈ Inside σ c d, x ∉ D P B → x ∈ childQ
  pruning_comparison : ∀ x ∈ Inside σ c d, x ∈ childQ →
    ∀ y ∈ childQ, childKey x < childKey y → preKey x < preKey y
  priority_comparison : ∀ x ∈ Inside σ a v, x ∈ preQ →
    ∀ y ∈ Inside σ a v, y ∈ preQ →
      preKey x < preKey y → π.index x < π.index y

theorem advanced_child_I3 {P : Precedence Job} {T : ℕ}
    {PreKey ChildKey : Type*} [LT PreKey] [LT ChildKey]
    {σ : Schedule P T} {π : Priority P} {a v c d : ℤ}
    {B : Boundary Job} {preQ childQ : Set Job}
    {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (hn : Normalized σ π a v) (hB : Placed σ B c)
    (hac : a < c) (hdv : d ≤ v)
    (hlist : ListOrderInterface σ π a v c d B preQ childQ preKey childKey) :
    I3 σ B c d childQ childKey := by
  intro τ hτ x hx hxD y hy hyQ hkey
  have hxσ : x ∈ Inside σ c d := (hτ.1 x).mpr hx
  have hxQ := hlist.localI1 x hxσ hxD
  have hytime : σ.time y = c := boundary_jobs_time hB hy
  have hyτ : τ.time y = c := by
    rw [hτ.2 y (by simp [Inside, hytime])]
    exact hytime
  have hxE : x ∈ Inside σ a v := ⟨hac.trans hxσ.1, lt_of_lt_of_le hxσ.2 hdv⟩
  have hyE : y ∈ Inside σ a v := by
    have hcd : c < d := hxσ.1.trans hxσ.2
    exact ⟨by simpa [hytime] using hac, by simpa [hytime] using lt_of_lt_of_le hcd hdv⟩
  have hπ := hlist.priority_comparison x hxE (hlist.pruning_subset hxQ)
    y hyE (hlist.pruning_subset hyQ)
    (hlist.pruning_comparison x hxσ hxQ y hyQ hkey)
  exact normalized_child_future_no_exchange hn hτ hac hdv hx hyτ hπ

theorem same_update_I3 {P : Precedence Job} {T : ℕ}
    {OldKey PreKey ChildKey : Type*} [LT OldKey] [LT PreKey] [LT ChildKey]
    {parent σ : Schedule P T} {π : Priority P} {a b v c d : ℤ}
    {S Q C childQ : Set Job} {A B outerRight : Boundary Job}
    {oldKey : Job → OldKey} {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hdv : d ≤ v) (hvb : v ≤ b)
    (hprep : Reorders parent σ a b) (hI3 : I3 parent A a b Q oldKey)
    (hCQ : C ⊆ Q)
    (hlist : ListOrderInterface σ π a v c d B
      (C ∪ injection P A outerRight) childQ preKey childKey)
    (carry_comparison : ∀ x ∈ C, ∀ y ∈ C,
      preKey x < preKey y → oldKey x < oldKey y) :
    I3 σ B c d childQ childKey := by
  rcases walk_start_or_interior hwalk with ⟨rfl, rfl⟩ | hinside
  · intro τ hτ x hx hxD y hy hyQ hkey
    have hxσ := (hτ.1 x).mpr hx
    have hxQ := hlist.localI1 x hxσ hxD
    have hxpre := hlist.pruning_subset hxQ
    have hypre := hlist.pruning_subset hyQ
    have hxC : x ∈ C := by
      rcases hxpre with h | h
      · exact h
      · exact False.elim (hxD h.1)
    have hyC : y ∈ C := by
      rcases hypre with h | h
      · exact h
      · exact False.elim (at_not_D (walk_initial_placed hwalk)
          (boundary_jobs_time (walk_initial_placed hwalk) hy).le h.1)
    apply hI3 τ (reorders_trans hprep (reorders_enlarge hτ le_rfl (hdv.trans hvb)))
      x ⟨hx.1, lt_of_lt_of_le hx.2 (hdv.trans hvb)⟩ hxD y hy (hCQ hyC)
    exact carry_comparison x hxC y hyC
      (hlist.pruning_comparison x hxσ hxQ y hyQ hkey)
  · exact advanced_child_I3 hn (walk_placed hwalk) hinside.1 hdv hlist

theorem reorders_before_threshold {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} (h : Reorders σ τ a b) (hra : r ≤ a)
    (x : Job) :
    (σ.time x < r ↔ τ.time x < r) ∧
    (σ.time x = r ↔ τ.time x = r) ∧
    (r < σ.time x ↔ r < τ.time x) := by
  by_cases hx : x ∈ Inside σ a b
  · have hx' := (h.1 x).mp hx
    have hσ := hx.1
    have hτ := hx'.1
    constructor <;> try constructor <;> omega
  · rw [h.2 x hx]
    exact ⟨Iff.rfl, Iff.rfl, Iff.rfl⟩

theorem placed_before_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} {B : Boundary Job}
    (h : Reorders σ τ a b) (hra : r ≤ a) (hB : Placed σ B r) :
    Placed τ B r := by
  cases B with
  | left => exact hB
  | right => exact hB
  | actual jobs =>
      exact ⟨hB.1, fun x => (hB.2 x).trans (reorders_before_threshold h hra x).2.1⟩

theorem reversed_separator_before_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} {B : Boundary Job} {domain low : Set Job}
    (h : Reorders σ τ a b) (hra : r ≤ a)
    (hs : Separator σ.reverse domain low B.reverse (reverseTime T r)) :
    Separator τ.reverse domain low B.reverse (reverseTime T r) := by
  constructor
  · intro x hx hxl hxt
    have he := (reorders_before_threshold h hra x).2.2
    apply hs.earlier_high x hx hxl
    have hrt : r < τ.time x := by
      dsimp [Schedule.reverse, reverseTime] at hxt
      omega
    have hσ := he.mpr hrt
    dsimp [Schedule.reverse, reverseTime]
    omega
  · intro x hx hxl hxt
    have he := (reorders_before_threshold h hra x).1
    apply hs.later_low x hx hxl
    have htr : τ.time x < r := by
      dsimp [Schedule.reverse, reverseTime] at hxt
      omega
    have hσ := he.mpr htr
    dsimp [Schedule.reverse, reverseTime]
    omega

structure IncomingAncestor {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (A : Boundary Job) (a b : ℤ) where
  oldWitness : Schedule P T
  ancestorLeft : Boundary Job
  ancestorRight : Boundary Job
  oldCenter : Boundary Job
  u : ℤ
  v : ℤ
  w : ℤ
  historicalLow : Set Job
  centerLow : Set Job
  extension : Set Job
  ancestorLeft_placed : Placed oldWitness ancestorLeft u
  ancestorRight_placed : Placed oldWitness ancestorRight w
  endpoint_placed : Placed oldWitness A a
  center_placed : Placed oldWitness oldCenter v
  endpoint_actual : ∃ jobs, A = .actual jobs
  center_actual : ∃ jobs, oldCenter = .actual jobs
  ancestry : u < v ∧ v ≤ a ∧ a < b ∧ b ≤ w
  confined_changes : Reorders oldWitness σ a b
  center_separator : Separator oldWitness.reverse (Inside oldWitness u w) centerLow
    oldCenter.reverse (reverseTime T v)
  endpoint_separator : Separator oldWitness.reverse (Inside oldWitness v w) historicalLow
    A.reverse (reverseTime T a)
  cutoff_old_cone : ∀ x ∈ Inside oldWitness u w, x ∈ historicalLow →
    x ∈ Pred P.reverse ancestorLeft.reverse
  cutoff_center : ∀ x ∈ Inside oldWitness u w, x ∈ historicalLow → x ∈ centerLow
  extension_agreement : ∀ x ∈ Inside oldWitness u w,
    x ∈ extension ↔ x ∈ historicalLow
  extension_up : IsUp P extension

def IncomingAncestor.G {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) : Set Job :=
  switchG P h.ancestorLeft A h.oldCenter h.extension

theorem IncomingAncestor.current_left_placed {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) : Placed σ A a :=
  placed_before_reorders h.confined_changes le_rfl h.endpoint_placed

theorem IncomingAncestor.G_properties {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) :
    IsUp P h.G ∧
    (∀ x ∈ Inside σ a b, x ∉ D P A → x ∈ h.G) ∧
    (∀ z ∈ h.G, ¬ σ.time z ≤ a) := by
  have hua : h.u ≤ a := (h.ancestry.1.trans_le h.ancestry.2.1).le
  have hUchange := reorders_enlarge h.confined_changes hua h.ancestry.2.2.2
  have hEchange := reorders_enlarge h.confined_changes h.ancestry.2.1 h.ancestry.2.2.2
  have hUeq : Inside h.oldWitness h.u h.w = Inside σ h.u h.w :=
    Set.ext hUchange.1
  have hEeq : Inside h.oldWitness h.v h.w = Inside σ h.v h.w :=
    Set.ext hEchange.1
  apply switchG_from_incoming_separators
    (placed_before_reorders h.confined_changes hua h.ancestorLeft_placed)
    h.current_left_placed
    (placed_before_reorders h.confined_changes h.ancestry.2.1 h.center_placed)
    h.ancestry
  · rw [← hUeq]
    exact reversed_separator_before_reorders h.confined_changes h.ancestry.2.1 h.center_separator
  · rw [← hEeq]
    exact reversed_separator_before_reorders h.confined_changes le_rfl h.endpoint_separator
  · rw [← hUeq]
    exact h.cutoff_old_cone
  · rw [← hUeq]
    exact h.cutoff_center
  · rw [← hUeq]
    exact h.extension_agreement
  · exact h.extension_up

def IncomingAncestor.after_reordering {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) (hr : Reorders σ τ a b) :
    IncomingAncestor τ A a b :=
  { h with confined_changes := reorders_trans h.confined_changes hr }

theorem IncomingAncestor.frozen_G_after_every_reordering
    {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {A : Boundary Job} {a b : ℤ} (h : IncomingAncestor σ A a b)
    (τ : Schedule P T) (hr : Reorders σ τ a b) :
    IsUp P h.G ∧
    (∀ x ∈ Inside τ a b, x ∉ D P A → x ∈ h.G) ∧
    (∀ z ∈ h.G, ¬ τ.time z ≤ a) :=
  (h.after_reordering hr).G_properties

def switchQualifiers {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (incoming : IncomingAncestor σ A a b) (h : ℕ) : Set Job :=
  (incoming.G ∩ {x | h ≤ P.rank x}) ∪ D P A

theorem switchQualifiers_no_early {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (incoming : IncomingAncestor σ A a b) (h : ℕ) :
    ∀ z ∈ switchQualifiers incoming h, ¬ σ.time z ≤ a := by
  intro z hz hzt
  rcases hz with hz | hz
  · exact incoming.G_properties.2.2 z hz.1 hzt
  · exact at_not_D incoming.current_left_placed hzt hz

theorem switch_update_I2 {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a b v c : ℤ}
    {A B : Boundary Job} {S childQ : Set Job}
    (incoming : IncomingAncestor σ A a b) (h : ℕ)
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hav : a < v) (hsep : Separator σ (Inside σ a v) S B c)
    (hunion : ∀ x ∈ Inside σ a v,
      x ∈ switchQualifiers incoming h ↔ x ∉ S)
    (hprune : childQ ⊆ switchQualifiers incoming h) :
    I2 σ B c childQ := by
  have hcv : c < v := by
    rcases walk_start_or_interior hwalk with ⟨_, rfl⟩ | h
    · exact hav
    · exact h.2
  apply I2_from_local_separator (walk_placed hwalk) hcv hsep hunion hprune
  intro z hz hzt
  exact False.elim (switchQualifiers_no_early incoming h z hz hzt)

theorem switch_update_I3 {P : Precedence Job} {T : ℕ}
    {PreKey ChildKey : Type*} [LT PreKey] [LT ChildKey]
    {σ : Schedule P T} {π : Priority P} {a b v c d : ℤ}
    {A B : Boundary Job} {S childQ : Set Job}
    {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (incoming : IncomingAncestor σ A a b) (h : ℕ)
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hdv : d ≤ v)
    (hlist : ListOrderInterface σ π a v c d B
      (switchQualifiers incoming h) childQ preKey childKey) :
    I3 σ B c d childQ childKey := by
  rcases walk_start_or_interior hwalk with ⟨rfl, rfl⟩ | hinside
  · intro τ hτ x hx hxD y hy hyQ hkey
    have hytime := boundary_jobs_time (walk_initial_placed hwalk) hy
    exact False.elim (switchQualifiers_no_early incoming h y
      (hlist.pruning_subset hyQ) hytime.le)
  · exact advanced_child_I3 hn (walk_placed hwalk) hinside.1 hdv hlist

abbrev ListKey := ℕ ×ₗ ℕ

structure TemporalState (Job : Type*) [Fintype Job] [DecidableEq Job] (T : ℕ) where
  frame : Precedence Job
  schedule : Schedule frame T
  left : Boundary Job
  right : Boundary Job
  a : ℤ
  b : ℤ
  left_placed : Placed schedule left a
  right_placed : Placed schedule right b
  ordered : a < b
  qualifiers : Set Job
  key : Job → ListKey

def TemporalState.Valid {T : ℕ} (N : TemporalState Job T) : Prop :=
  I2 N.schedule N.left N.a N.qualifiers ∧
    I3 N.schedule N.left N.a N.b N.qualifiers N.key

def rootState {T : ℕ} (P : Precedence Job) (σ : Schedule P T) :
    TemporalState Job T where
  frame := P
  schedule := σ
  left := .left
  right := .right
  a := 0
  b := (T : ℤ) + 1
  left_placed := rfl
  right_placed := rfl
  ordered := by omega
  qualifiers := Set.univ
  key x := toLex (1, P.rank x)

theorem root_valid {T : ℕ} (P : Precedence Job) (σ : Schedule P T) :
    (rootState P σ).Valid := by
  constructor
  · intro z _ hzt
    have hr := (σ.complete.range z).1
    change σ.time z ≤ 0 at hzt
    omega
  · intro τ hτ x hx hxD y hy
    simp [rootState, Boundary.jobs] at hy

structure SameTemporalData {T : ℕ} (N : TemporalState Job T) where
  prepared : Schedule N.frame T
  preparation : Reorders N.schedule prepared N.a N.b
  priority : Priority N.frame
  center : Finset Job
  v : ℤ
  center_placed : Placed prepared (.actual center) v
  center_interior : N.a < v ∧ v < N.b
  center_range : v ≤ (T : ℤ) + 1
  childLeft : Boundary Job
  childRight : Finset Job
  c : ℤ
  d : ℤ
  cutoff : Set Job
  carry : Set Job
  childQ : Set Job
  preKey : Job → ListKey
  childKey : Job → ListKey
  walk : ExceptionWalk prepared priority N.a v cutoff N.left childLeft c
  right_placed : Placed prepared (.actual childRight) d
  nonempty_child : (Inside prepared c d).Nonempty
  right_before_center : d ≤ v
  left_separator : Separator prepared (Inside prepared N.a v) cutoff childLeft c
  right_separator : Separator prepared (Inside prepared N.a v) cutoff (.actual childRight) d
  normalized : Normalized prepared priority N.a v
  carry_up : IsUp N.frame carry
  carry_old : carry ⊆ N.qualifiers
  local_union : ∀ x ∈ Inside prepared N.a v,
    x ∈ carry ∪ injection N.frame N.left N.right ↔ x ∉ cutoff
  promoted_old_key : ∀ x ∈ Inside prepared N.a v,
    x ∈ cutoff → x ∉ D N.frame N.left →
      ∀ y ∈ carry, N.key x < N.key y
  list_order : ListOrderInterface prepared priority N.a v c d childLeft
    (carry ∪ injection N.frame N.left N.right) childQ preKey childKey
  carry_comparison : ∀ x ∈ carry, ∀ y ∈ carry,
    preKey x < preKey y → N.key x < N.key y

def SameTemporalData.child {T : ℕ} {N : TemporalState Job T}
    (e : SameTemporalData N) : TemporalState Job T where
  frame := N.frame
  schedule := e.prepared
  left := e.childLeft
  right := .actual e.childRight
  a := e.c
  b := e.d
  left_placed := walk_placed e.walk
  right_placed := e.right_placed
  ordered := by obtain ⟨x, hx⟩ := e.nonempty_child; exact hx.1.trans hx.2
  qualifiers := e.childQ
  key := e.childKey

theorem SameTemporalData.preserves {T : ℕ} {N : TemporalState Job T}
    (e : SameTemporalData N) (hN : N.Valid) : e.child.Valid := by
  constructor
  · exact same_update_I2 e.walk e.normalized e.center_interior.1 e.center_range
      e.center_interior.2.le e.preparation hN.1 hN.2 e.carry_up e.carry_old
      (fun y hy hyC => (e.local_union y hy).mp (Or.inl hyC))
      e.promoted_old_key e.left_separator e.local_union e.list_order.pruning_subset
  · exact same_update_I3 e.walk e.normalized e.right_before_center
      e.center_interior.2.le e.preparation hN.2 e.carry_old e.list_order e.carry_comparison

structure SwitchTemporalData {T : ℕ} (N : TemporalState Job T) where
  prepared : Schedule N.frame.reverse T
  preparation : Reorders N.schedule.reverse prepared (reverseTime T N.b) (reverseTime T N.a)
  priority : Priority N.frame.reverse
  center : Finset Job
  v : ℤ
  center_placed : Placed prepared (.actual center) v
  center_interior : reverseTime T N.b < v ∧ v < reverseTime T N.a
  incoming : IncomingAncestor prepared N.right.reverse
    (reverseTime T N.b) (reverseTime T N.a)
  childLeft : Boundary Job
  childRight : Finset Job
  c : ℤ
  d : ℤ
  cutoff : Set Job
  rankCut : ℕ
  childQ : Set Job
  preKey : Job → ListKey
  childKey : Job → ListKey
  walk : ExceptionWalk prepared priority (reverseTime T N.b) v cutoff N.right.reverse childLeft c
  right_placed : Placed prepared (.actual childRight) d
  nonempty_child : (Inside prepared c d).Nonempty
  right_before_center : d ≤ v
  left_separator : Separator prepared (Inside prepared (reverseTime T N.b) v) cutoff childLeft c
  right_separator : Separator prepared (Inside prepared (reverseTime T N.b) v)
    cutoff (.actual childRight) d
  normalized : Normalized prepared priority (reverseTime T N.b) v
  local_union : ∀ x ∈ Inside prepared (reverseTime T N.b) v,
    x ∈ switchQualifiers incoming rankCut ↔ x ∉ cutoff
  list_order : ListOrderInterface prepared priority (reverseTime T N.b) v c d childLeft
    (switchQualifiers incoming rankCut) childQ preKey childKey

def SwitchTemporalData.child {T : ℕ} {N : TemporalState Job T}
    (e : SwitchTemporalData N) : TemporalState Job T where
  frame := N.frame.reverse
  schedule := e.prepared
  left := e.childLeft
  right := .actual e.childRight
  a := e.c
  b := e.d
  left_placed := walk_placed e.walk
  right_placed := e.right_placed
  ordered := by obtain ⟨x, hx⟩ := e.nonempty_child; exact hx.1.trans hx.2
  qualifiers := e.childQ
  key := e.childKey

theorem SwitchTemporalData.preserves {T : ℕ} {N : TemporalState Job T}
    (e : SwitchTemporalData N) : e.child.Valid := by
  constructor
  · exact switch_update_I2 e.incoming e.rankCut e.walk e.center_interior.1
      e.left_separator e.local_union e.list_order.pruning_subset
  · exact switch_update_I3 e.incoming e.rankCut e.walk e.normalized
      e.right_before_center e.list_order

-- Constructors carry local construction data, never a temporal invariant.
inductive TemporalHistory {T : ℕ} : TemporalState Job T → Prop
  | root (P : Precedence Job) (σ : Schedule P T) : TemporalHistory (rootState P σ)
  | same {N : TemporalState Job T} (past : TemporalHistory N)
      (e : SameTemporalData N) : TemporalHistory e.child
  | switched {N : TemporalState Job T} (past : TemporalHistory N)
      (e : SwitchTemporalData N) : TemporalHistory e.child

theorem TemporalHistory.boundary_invariants {T : ℕ} {N : TemporalState Job T}
    (h : TemporalHistory N) : N.Valid := by
  induction h with
  | root P σ => exact root_valid P σ
  | same _ e ih => exact e.preserves ih
  | switched _ e _ => exact e.preserves

theorem TemporalHistory.future_boundary_invariants {T : ℕ}
    {N : TemporalState Job T} (h : TemporalHistory N)
    (τ : Schedule N.frame T) (hr : Reorders N.schedule τ N.a N.b) :
    I2 τ N.left N.a N.qualifiers ∧
    I3 τ N.left N.a N.b N.qualifiers N.key :=
  ⟨I2_reorders h.boundary_invariants.1 hr,
    I3_reorders h.boundary_invariants.2 hr⟩

end TemporalBoundary

-- END research/two_frame_compression/formal_boundary/Main.lean

-- BEGIN research/two_frame_compression/formal_construction/Integration.lean
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
  -- Exhaustion uses the source's final threshold h = |J| + 1.
  rank_attained : r = 0 ∨ r = Fintype.card Job ∨
    ∃ x ∈ Inside prepared (reverseTime T N.b) (reverseTime T N.a),
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

-- END research/two_frame_compression/formal_construction/Integration.lean

-- END research/two_frame_compression/formal_construction/Main.lean

-- BEGIN research/two_frame_compression/formal_protocol/Protocol.lean
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

-- END research/two_frame_compression/formal_protocol/Protocol.lean
