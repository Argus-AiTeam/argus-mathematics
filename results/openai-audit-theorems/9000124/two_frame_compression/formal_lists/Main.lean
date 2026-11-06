import Mathlib

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
