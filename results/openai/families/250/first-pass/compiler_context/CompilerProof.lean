import Mathlib

namespace CompilerProof

universe u v

variable {C : Type u}

def Edge (next : C → Option C) (a b : C) : Prop := next a = some b
def Reach (next : C → Option C) := Relation.ReflTransGen (Edge next)
def Weak (next : C → Option C) :=
  Relation.ReflTransGen (fun a b => Edge next a b ∨ Edge next b a)

theorem edge_unique (next : C → Option C) {a b c : C}
    (hb : Edge next a b) (hc : Edge next a c) : b = c := by
  exact Option.some.inj (hb.symm.trans hc)

theorem terminal_reach (next : C → Option C) {t z : C}
    (ht : next t = none) (hr : Reach next t z) : t = z := by
  rcases hr.cases_head with h | ⟨b, hb, _⟩
  · exact h
  · simp [Edge, ht] at hb

theorem cancel_first (next : C → Option C) {a b t : C}
    (ht : next t = none) (hab : Edge next a b) (ha : Reach next a t) :
    Reach next b t := by
  rcases ha.cases_head with h | ⟨c, hc, hct⟩
  · subst a
    simp [Edge, ht] at hab
  · have hbc := edge_unique next hab hc
    subst c
    exact hct

theorem weak_reaches_terminal (next : C → Option C) {a t : C}
    (ht : next t = none) (hw : Weak next a t) : Reach next a t := by
  induction hw using Relation.ReflTransGen.head_induction_on with
  | refl => exact .refl
  | @head a b hab hbt ih =>
    rcases hab with hab | hba
    · exact .head hab ih
    · exact cancel_first next ht hba ih

theorem weak_terminal_unique (next : C → Option C) {a t : C}
    (ha : next a = none) (ht : next t = none) (hw : Weak next a t) : a = t :=
  terminal_reach next ha (weak_reaches_terminal next ht hw)

def Join (next : C → Option C) (a b : C) : Prop :=
  ∃ c, Reach next a c ∧ Reach next b c

theorem reach_diamond (next : C → Option C) {a b c : C}
    (hab : Reach next a b) (hac : Reach next a c) : Join next b c := by
  have hu : Relator.RightUnique (Edge next) := fun _ _ _ => edge_unique next
  rcases Relation.ReflTransGen.total_of_right_unique hu hab hac with h | h
  · exact ⟨c, h, .refl⟩
  · exact ⟨b, .refl, h⟩

theorem weak_join (next : C → Option C) {a b : C}
    (hw : Weak next a b) : Join next a b := by
  induction hw with
  | refl => exact ⟨_, .refl, .refl⟩
  | @tail b c hab hbc ih =>
    obtain ⟨d, had, hbd⟩ := ih
    rcases hbc with hbc | hcb
    · obtain ⟨e, hde, hce⟩ := reach_diamond next hbd (.single hbc)
      exact ⟨e, had.trans hde, hce⟩
    · exact ⟨d, had, .head hcb hbd⟩

theorem reverse_chain_unique (next : C → Option C)
    (valid : C → Prop)
    (hin : ∀ {a b c}, valid c → Edge next a c → Edge next b c → a = b)
    (hclosed : ∀ {a b}, valid b → Edge next a b → valid a)
    {a b t : C} (ha : ∀ x, ¬Edge next x a) (hb : ∀ x, ¬Edge next x b)
    (hv : valid t) (hat : Reach next a t) (hbt : Reach next b t) : a = b := by
  induction hat generalizing b with
  | refl =>
    rcases hbt.cases_tail with h | ⟨c, _, hca⟩
    · exact h
    · exact False.elim (ha c hca)
  | @tail c t hac hct ih =>
    rcases hbt.cases_tail with h | ⟨d, hbd, hdt⟩
    · subst b
      exact False.elim (hb c hct)
    · have hcd := hin hv hct hdt
      subst d
      exact ih hb (hclosed hv hct) hbd

theorem weak_symm (next : C → Option C) {a b : C}
    (hw : Weak next a b) : Weak next b a := by
  induction hw with
  | refl => exact .refl
  | tail h hs ih =>
    exact Relation.ReflTransGen.head (hs.elim Or.inr Or.inl) ih

theorem reach_weak (next : C → Option C) {a b : C}
    (h : Reach next a b) : Weak next a b :=
  h.mono (fun _ _ hs => Or.inl hs)

theorem weak_preserves (next : C → Option C) {K : Type v}
    (key : C → K) (hk : ∀ {a b}, Edge next a b → key a = key b)
    {a b : C} (h : Weak next a b) : key a = key b := by
  induction h with
  | refl => rfl
  | tail h hs ih => exact ih.trans (hs.elim (fun h => hk h) (fun h => (hk h).symm))

theorem component_entry_unique (next : C → Option C) {K : Type v}
    (entry clean valid : C → Prop) (key : C → K)
    (hk : ∀ {a b}, Edge next a b → key a = key b)
    (hsource : ∀ {a}, entry a → ∀ x, ¬Edge next x a)
    (hin : ∀ {a b c}, valid c → Edge next a c → Edge next b c → a = b)
    (hclosed : ∀ {a b}, valid b → Edge next a b → valid a)
    (hclean : ∀ {a b}, entry a → entry b → clean a → clean b → key a = key b → a = b)
    (hclass : ∀ {a}, entry a →
      clean a ∨ ∃ t, Reach next a t ∧ next t = none ∧ valid t)
    {a b : C} (ha : entry a) (hb : entry b) (hw : Weak next a b) : a = b := by
  have failed_unique : ∀ {x y}, entry x → entry y → Weak next x y →
      (∃ t, Reach next x t ∧ next t = none ∧ valid t) → x = y := by
    intro x y hx hy hxy hf
    obtain ⟨t, hxt, ht, hv⟩ := hf
    have hyt : Weak next y t := (weak_symm next hxy).trans (reach_weak next hxt)
    exact reverse_chain_unique next valid hin hclosed
      (hsource hx) (hsource hy) hv hxt (weak_reaches_terminal next ht hyt)
  rcases hclass ha with hca | hfa
  · rcases hclass hb with hcb | hfb
    · exact hclean ha hb hca hcb (weak_preserves next key hk hw)
    · exact (failed_unique hb ha (weak_symm next hw) hfb).symm
  · exact failed_unique ha hb hw hfa

section Scans

variable {X : Type u}

structure Zipper (X : Type u) where
  left : List X
  right : List X
  deriving DecidableEq

def row (z : Zipper X) : List X := z.left.reverse ++ z.right

inductive Rewind : Zipper X → Zipper X → Prop
  | step (b : X) (l r : List X) : Rewind ⟨b :: l, r⟩ ⟨l, b :: r⟩

inductive AcrossRight : Zipper X → Zipper X → Prop
  | step (b : X) (l r : List X) : AcrossRight ⟨l, b :: r⟩ ⟨b :: l, r⟩

theorem rewind_row {a b : Zipper X} (h : Rewind a b) : row a = row b := by
  cases h
  simp [row, List.reverse_cons, List.append_assoc]

theorem right_row {a b : Zipper X} (h : AcrossRight a b) : row a = row b := by
  cases h
  simp [row, List.reverse_cons, List.append_assoc]

theorem rewind_exact (l r : List X) :
    Relation.ReflTransGen Rewind (Zipper.mk l r) ⟨[], l.reverse ++ r⟩ := by
  induction l generalizing r with
  | nil => exact .refl
  | cons b l ih =>
    have h := ih (b :: r)
    have hs : Rewind (Zipper.mk (b :: l) r) ⟨l, b :: r⟩ := .step b l r
    simpa [List.reverse_cons, List.append_assoc] using Relation.ReflTransGen.head hs h

theorem right_exact (l r : List X) :
    Relation.ReflTransGen AcrossRight (Zipper.mk l r) ⟨r.reverse ++ l, []⟩ := by
  induction r generalizing l with
  | nil => exact .refl
  | cons b r ih =>
    have h := ih (b :: l)
    have hs : AcrossRight (Zipper.mk l (b :: r)) ⟨b :: l, r⟩ := .step b l r
    simpa [List.reverse_cons, List.append_assoc] using Relation.ReflTransGen.head hs h

def seek (p : X → Bool) : List X → List X → Option (List X × X × List X)
  | _, [] => none
  | l, b :: r => if p b then some (l, b, r) else seek p (b :: l) r

theorem seek_match (p : X → Bool) (l pre suf : List X) (b : X)
    (hp : ∀ c ∈ pre, p c = false) (hb : p b = true) :
    seek p l (pre ++ b :: suf) = some (pre.reverse ++ l, b, suf) := by
  induction pre generalizing l with
  | nil => simp [seek, hb]
  | cons c cs ih =>
    have hc := hp c (by simp)
    have ht : ∀ d ∈ cs, p d = false := by
      intro d hd
      exact hp d (by simp [hd])
    simpa [seek, hc, List.reverse_cons, List.append_assoc] using ih (c :: l) ht

theorem seek_none (p : X → Bool) (l r : List X)
    (h : ∀ c ∈ r, p c = false) : seek p l r = none := by
  induction r generalizing l with
  | nil => rfl
  | cons b r ih =>
    have hb := h b (by simp)
    simp only [seek, hb, Bool.false_eq_true, ↓reduceIte]
    apply ih
    intro c hc
    exact h c (by simp [hc])

end Scans

section Tape

variable {Q : Type u} {T : Type v}

inductive Move
  | left
  | stay
  | right
  deriving DecidableEq

structure Config (Q : Type u) (T : Type v) where
  state : Q
  head : Nat
  tape : Nat → T

structure Instruction (Q : Type u) (T : Type v) where
  state : Q
  write : T
  move : Move

def moveHead (d : Move) (i : Nat) : Nat :=
  match d with
  | .left => i - 1
  | .stay => i
  | .right => i + 1

def execute (d : Instruction Q T) (c : Config Q T) : Config Q T :=
  ⟨d.state, moveHead d.move c.head, Function.update c.tape c.head d.write⟩

def machineStep (δ : Q → T → Option (Instruction Q T)) (c : Config Q T) :
    Option (Config Q T) := (δ c.state (c.tape c.head)).map (fun d => execute d c)

def boundedStep (s : Nat) (δ : Q → T → Option (Instruction Q T))
    (c : Config Q T) : Option (Config Q T) :=
  if c.head < s then
    (machineStep δ c).bind (fun c' => if c'.head < s then some c' else none)
  else none

theorem bounded_step_sound (s : Nat) (δ : Q → T → Option (Instruction Q T))
    {c c' : Config Q T} (h : boundedStep s δ c = some c') :
    machineStep δ c = some c' ∧ c.head < s ∧ c'.head < s := by
  unfold boundedStep at h
  split at h
  next hc =>
    cases hs : machineStep δ c with
    | none => simp [hs] at h
    | some t =>
      simp only [hs, Option.bind_some] at h
      split at h
      next ht =>
        have he : t = c' := Option.some.inj h
        subst t
        exact ⟨rfl, hc, ht⟩
      next => simp at h
  next => simp at h

theorem bounded_step_complete (s : Nat) (δ : Q → T → Option (Instruction Q T))
    {c c' : Config Q T} (h : machineStep δ c = some c')
    (hc : c.head < s) (hc' : c'.head < s) :
    boundedStep s δ c = some c' := by
  simp [boundedStep, h, hc, hc']

inductive Trace (next : C → Option C) : C → C → Prop
  | refl (a : C) : Trace next a a
  | cons {a b c : C} : next a = some b → Trace next b c → Trace next a c

theorem trace_reach (next : C → Option C) {a b : C} (h : Trace next a b) :
    Reach next a b := by
  induction h with
  | refl => exact .refl
  | cons hs ht ih => exact .head hs ih

theorem bounded_trace_sound (s : Nat) (δ : Q → T → Option (Instruction Q T))
    {a b : Config Q T} (h : Trace (boundedStep s δ) a b) :
    Trace (machineStep δ) a b := by
  induction h with
  | refl => exact .refl _
  | cons hs ht ih => exact .cons (bounded_step_sound s δ hs).1 ih

theorem finite_trace_quota (δ : Q → T → Option (Instruction Q T))
    {a b : Config Q T} (h : Trace (machineStep δ) a b) :
    ∃ s, ∀ t, s ≤ t → Trace (boundedStep t δ) a b ∧ a.head < t ∧ b.head < t := by
  induction h with
  | refl a =>
    refine ⟨a.head + 1, ?_⟩
    intro t ht
    exact ⟨.refl _, by omega, by omega⟩
  | @cons a b c hs ht ih =>
    obtain ⟨s, hi⟩ := ih
    refine ⟨max s (a.head + 1), ?_⟩
    intro t hb
    have hst : s ≤ t := (le_max_left _ _).trans hb
    obtain ⟨htc, hbt, hct⟩ := hi t hst
    have hat : a.head < t := by have := (le_max_right s (a.head + 1)).trans hb; omega
    exact ⟨.cons (bounded_step_complete t δ hs hat hbt) htc, hat, hct⟩

def inputTape (blank : T) (encode : List T) (i : Nat) : T := encode[i]?.getD blank

theorem padded_input (blank : T) (w : List T) (s i : Nat)
    (hs : w.length ≤ s) (hi : i < s) :
    inputTape blank (w ++ List.replicate (s - w.length) blank) i =
      inputTape blank w i := by
  simp only [inputTape]
  by_cases hw : i < w.length
  · simp [List.getElem?_append, hw]
  · have hwi : w.length ≤ i := by omega
    have hpad : i - w.length < s - w.length := by omega
    simp [List.getElem?_append, hw, hpad]

end Tape

section Validator

variable {A : Type u} {D : Type v}

inductive VCell (A : Type u) (D : Type v)
  | anchor : A → VCell A D
  | cutC
  | cutD
  | workspace
  | dirty : D → VCell A D

inductive Phase
  | i | j | jp | n | v | start
  deriving DecidableEq

structure VConfig (A : Type u) (D : Type v) where
  alpha : Bool
  left : List (VCell A D)
  phase : Phase
  right : List (VCell A D)
  omega : Bool

def anchorsOnly : List (VCell A D) → Prop
  | [] => True
  | .anchor _ :: r => anchorsOnly r
  | _ => False

def leftLanguage : List (VCell A D) → Prop
  | .workspace :: l => leftLanguage l
  | .cutC :: l => anchorsOnly l
  | _ => False

def nLanguage : List (VCell A D) → Prop
  | .workspace :: r => nLanguage r
  | .cutD :: r => anchorsOnly r
  | _ => False

def jpLanguage : List (VCell A D) → Prop
  | .anchor _ :: r => jpLanguage r
  | .cutC :: r => nLanguage r
  | _ => False

def vGood (c : VConfig A D) : Prop :=
  c.omega = true ∧
    match c.phase with
    | .i => c.alpha = true ∧ leftLanguage c.left ∧ nLanguage c.right
    | .j => c.alpha = true ∧ anchorsOnly c.left ∧ jpLanguage c.right
    | .jp => jpLanguage c.right
    | .n => nLanguage c.right
    | .v => anchorsOnly c.right
    | .start => c.right = []

def vnext : VConfig A D → Option (VConfig A D)
  | ⟨a, .workspace :: l, .i, r, o⟩ =>
      some ⟨a, l, .i, .workspace :: r, o⟩
  | ⟨a, .cutC :: l, .i, r, o⟩ =>
      some ⟨a, l, .j, .cutC :: r, o⟩
  | ⟨a, .anchor x :: l, .j, r, o⟩ =>
      some ⟨a, l, .j, .anchor x :: r, o⟩
  | ⟨true, [], .j, r, o⟩ => some ⟨true, [], .jp, r, o⟩
  | ⟨a, l, .jp, .anchor x :: r, o⟩ =>
      some ⟨a, .anchor x :: l, .jp, r, o⟩
  | ⟨a, l, .jp, .cutC :: r, o⟩ =>
      some ⟨a, .cutC :: l, .n, r, o⟩
  | ⟨a, l, .n, .workspace :: r, o⟩ =>
      some ⟨a, .workspace :: l, .n, r, o⟩
  | ⟨a, l, .n, .cutD :: r, o⟩ =>
      some ⟨a, .cutD :: l, .v, r, o⟩
  | ⟨a, l, .v, .anchor x :: r, o⟩ =>
      some ⟨a, .anchor x :: l, .v, r, o⟩
  | ⟨a, l, .v, [], true⟩ => some ⟨a, l, .start, [], true⟩
  | _ => none

def vprev : VConfig A D → Option (VConfig A D)
  | ⟨a, l, .i, .workspace :: r, o⟩ =>
      some ⟨a, .workspace :: l, .i, r, o⟩
  | ⟨a, l, .j, .cutC :: r, o⟩ =>
      some ⟨a, .cutC :: l, .i, r, o⟩
  | ⟨a, l, .j, .anchor x :: r, o⟩ =>
      some ⟨a, .anchor x :: l, .j, r, o⟩
  | ⟨true, [], .jp, r, o⟩ => some ⟨true, [], .j, r, o⟩
  | ⟨a, .anchor x :: l, .jp, r, o⟩ =>
      some ⟨a, l, .jp, .anchor x :: r, o⟩
  | ⟨a, .cutC :: l, .n, r, o⟩ =>
      some ⟨a, l, .jp, .cutC :: r, o⟩
  | ⟨a, .workspace :: l, .n, r, o⟩ =>
      some ⟨a, l, .n, .workspace :: r, o⟩
  | ⟨a, .cutD :: l, .v, r, o⟩ =>
      some ⟨a, l, .n, .cutD :: r, o⟩
  | ⟨a, .anchor x :: l, .v, r, o⟩ =>
      some ⟨a, l, .v, .anchor x :: r, o⟩
  | ⟨a, l, .start, [], true⟩ => some ⟨a, l, .v, [], true⟩
  | _ => none

theorem validator_inverse {c d : VConfig A D} (h : vnext c = some d) :
    vprev d = some c := by
  rcases c with ⟨a, l, phase, r, o⟩
  cases phase with
  | i =>
    cases l with
    | nil => simp [vnext] at h
    | cons b l =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
  | j =>
    cases l with
    | nil =>
      cases a <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
    | cons b l =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
  | jp =>
    cases r with
    | nil => simp [vnext] at h
    | cons b r =>
      cases a <;> cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
  | n =>
    cases r with
    | nil => simp [vnext] at h
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
  | v =>
    cases r with
    | nil =>
      cases o <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> rfl
  | start => simp [vnext] at h

theorem validator_good_step {c d : VConfig A D} (h : vnext c = some d) :
    vGood c ↔ vGood d := by
  rcases c with ⟨a, l, phase, r, o⟩
  cases phase with
  | i =>
    cases l with
    | nil => simp [vnext] at h
    | cons b l =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, leftLanguage, nLanguage, anchorsOnly, jpLanguage]
  | j =>
    cases l with
    | nil =>
      cases a <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, anchorsOnly]
    | cons b l =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, anchorsOnly, jpLanguage]
  | jp =>
    cases r with
    | nil => simp [vnext] at h
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, jpLanguage]
  | n =>
    cases r with
    | nil => simp [vnext] at h
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, nLanguage]
  | v =>
    cases r with
    | nil =>
      cases o <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, anchorsOnly]
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp [vGood, anchorsOnly]
  | start => simp [vnext] at h

theorem validator_good_reach {c d : VConfig A D} (h : Reach vnext c d) :
    vGood c ↔ vGood d := by
  induction h with
  | refl => rfl
  | tail h hs ih => exact ih.trans (validator_good_step hs)

theorem anchorsOnly_iff (l : List (VCell A D)) :
    anchorsOnly l ↔ ∃ x : List A, l = x.map VCell.anchor := by
  induction l with
  | nil => simp [anchorsOnly]
  | cons b l ih =>
    cases b with
    | anchor a =>
      constructor
      · intro h
        obtain ⟨x, hx⟩ := ih.mp h
        exact ⟨a :: x, by simp [hx]⟩
      · rintro ⟨x, hx⟩
        cases x with
        | nil => simp at hx
        | cons z zs =>
          simp only [List.map_cons, List.cons.injEq, VCell.anchor.injEq] at hx
          exact ih.mpr ⟨zs, hx.2⟩
    | cutC | cutD | workspace | dirty _ =>
      constructor
      · intro h; contradiction
      · rintro ⟨x, hx⟩
        cases x <;> simp at hx

theorem leftLanguage_iff (l : List (VCell A D)) :
    leftLanguage l ↔ ∃ (s : Nat) (x : List A),
      l = List.replicate s VCell.workspace ++ VCell.cutC :: x.map VCell.anchor := by
  induction l with
  | nil => simp [leftLanguage]
  | cons b l ih =>
    cases b with
    | workspace =>
      constructor
      · intro h
        obtain ⟨s, x, hx⟩ := ih.mp h
        exact ⟨s + 1, x, by simp [List.replicate_succ, hx]⟩
      · rintro ⟨s, x, hx⟩
        cases s with
        | zero => simp at hx
        | succ s =>
          simp only [List.replicate_succ, List.cons_append, List.cons.injEq] at hx
          exact ih.mpr ⟨s, x, hx.2⟩
    | cutC =>
      constructor
      · intro h
        obtain ⟨x, hx⟩ := (anchorsOnly_iff l).mp h
        exact ⟨0, x, by simp [hx]⟩
      · rintro ⟨s, x, hx⟩
        cases s with
        | zero =>
          simp only [List.replicate_zero, List.nil_append, List.cons.injEq] at hx
          exact (anchorsOnly_iff l).mpr ⟨x, hx.2⟩
        | succ s => simp [List.replicate_succ] at hx
    | anchor _ | cutD | dirty _ =>
      constructor
      · intro h; contradiction
      · rintro ⟨s, x, hx⟩
        cases s <;> simp [List.replicate_succ] at hx

theorem accepted_entry_clean (a o : Bool) (l r : List (VCell A D))
    (t : VConfig A D)
    (hs : t.phase = .start) (hr : t.right = []) (ho : t.omega = true)
    (h : Reach vnext ⟨a, l, .i, .cutD :: r, o⟩ t) :
    a = true ∧ o = true ∧
      (∃ (s : Nat) (x : List A),
        l = List.replicate s VCell.workspace ++ VCell.cutC :: x.map VCell.anchor) ∧
      (∃ y : List A, r = y.map VCell.anchor) := by
  have hg : vGood t := by simp [vGood, hs, hr, ho]
  have hi := (validator_good_reach h).mpr hg
  simp only [vGood, nLanguage] at hi
  exact ⟨hi.2.1, hi.1, (leftLanguage_iff l).mp hi.2.2.1,
    (anchorsOnly_iff r).mp hi.2.2.2⟩

def phaseRank : Phase → Nat
  | .i => 5 | .j => 4 | .jp => 3 | .n => 2 | .v => 1 | .start => 0

def vMeasure (c : VConfig A D) : Nat :=
  (c.left.length + c.right.length + 1) * phaseRank c.phase +
    match c.phase with
    | .i | .j => c.left.length
    | .jp | .n | .v => c.right.length
    | .start => 0

theorem validator_decreases {c d : VConfig A D} (h : vnext c = some d) :
    vMeasure d < vMeasure c := by
  rcases c with ⟨a, l, phase, r, o⟩
  cases phase with
  | i =>
    cases l with
    | nil => simp [vnext] at h
    | cons b l =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_cons] <;> omega
  | j =>
    cases l with
    | nil =>
      cases a <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_nil] <;> omega
    | cons b l =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_cons] <;> omega
  | jp =>
    cases r with
    | nil => simp [vnext] at h
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_cons] <;> omega
  | n =>
    cases r with
    | nil => simp [vnext] at h
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_cons] <;> omega
  | v =>
    cases r with
    | nil =>
      cases o <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_nil] <;> omega
    | cons b r =>
      cases b <;> simp only [vnext, Option.some.injEq, reduceCtorEq] at h <;>
        subst d <;> simp only [vMeasure, phaseRank, List.length_cons] <;> omega
  | start => simp [vnext] at h

theorem validator_terminates (c : VConfig A D) :
    ∃ t, Reach vnext c t ∧ vnext t = none := by
  have h : ∀ n, ∀ c : VConfig A D, vMeasure c = n →
      ∃ t, Reach vnext c t ∧ vnext t = none := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
      intro c hc
      cases hs : vnext c with
      | none => exact ⟨c, .refl, hs⟩
      | some d =>
        have hd : vMeasure d < n := by simpa [hc] using validator_decreases hs
        obtain ⟨t, hdt, ht⟩ := ih (vMeasure d) hd d rfl
        exact ⟨t, .head hs hdt, ht⟩
  exact h (vMeasure c) c rfl

theorem entry_no_predecessor (a o : Bool) (l r : List (VCell A D))
    (c : VConfig A D) :
    vnext c ≠ some ⟨a, l, .i, .cutD :: r, o⟩ := by
  intro h
  have hi := validator_inverse h
  simp [vprev] at hi

end Validator

section ArrayLoops

variable {A : Type u}

def copyInput : List A → List (Option A) → Option (List (Option A))
  | [], cells => some cells
  | a :: input, none :: cells => (copyInput input cells).map (some a :: ·)
  | _, _ => none

theorem copyInput_exact (w : List A) (s : Nat) (hs : w.length ≤ s) :
    copyInput w (List.replicate s none) =
      some (w.map some ++ List.replicate (s - w.length) none) := by
  induction w generalizing s with
  | nil => simp [copyInput]
  | cons a w ih =>
    cases s with
    | zero => simp at hs
    | succ s =>
      have hw : w.length ≤ s := by simpa using hs
      simp [copyInput, List.replicate_succ, ih s hw, Nat.succ_sub_succ_eq_sub]

def readOutput : List (Option A) → Nat → Option (List A)
  | [], _ => none
  | none :: _, _ => some []
  | some a :: cells, n + 1 => (readOutput cells n).map (a :: ·)
  | some _ :: _, 0 => none

theorem readOutput_exact (w : List A) (rest : List (Option A)) (n : Nat)
    (hn : w.length ≤ n) :
    readOutput (w.map some ++ none :: rest) n = some w := by
  induction w generalizing n with
  | nil => simp [readOutput]
  | cons a w ih =>
    cases n with
    | zero => simp at hn
    | succ n =>
      have hw : w.length ≤ n := by simpa using hn
      simp [readOutput, ih n hw]

theorem readOutput_sound (cells : List (Option A)) (n : Nat) (w : List A)
    (h : readOutput cells n = some w) :
    w.length ≤ n ∧ ∃ rest, cells = w.map some ++ none :: rest := by
  induction cells generalizing n w with
  | nil => simp [readOutput] at h
  | cons b cells ih =>
    cases b with
    | none =>
      simp only [readOutput, Option.some.injEq] at h
      subst w
      exact ⟨Nat.zero_le _, cells, rfl⟩
    | some a =>
      cases n with
      | zero => simp [readOutput] at h
      | succ n =>
        cases hr : readOutput cells n with
        | none => simp [readOutput, hr] at h
        | some z =>
          simp only [readOutput, hr, Option.map_some, Option.some.injEq] at h
          subst w
          obtain ⟨hz, rest, hc⟩ := ih n z hr
          exact ⟨by simpa using Nat.succ_le_succ hz, rest, by simp [hc]⟩

def markAnchors : List A → List (Option A) → Option (List (Option A)) := copyInput

theorem markAnchors_exact (w : List A) (n : Nat) (hn : w.length ≤ n) :
    markAnchors w (List.replicate n none) =
      some (w.map some ++ List.replicate (n - w.length) none) :=
  copyInput_exact w n hn

def cleanMarks : List (Option A) → List A
  | [] => []
  | none :: marks => cleanMarks marks
  | some a :: marks => a :: cleanMarks marks

theorem cleanMarks_exact (w : List A) (n : Nat) :
    cleanMarks (w.map some ++ List.replicate n none) = w := by
  induction w with
  | nil =>
    induction n with
    | zero => rfl
    | succ n ih => simpa [List.replicate_succ, cleanMarks] using ih
  | cons a w ih => simp [cleanMarks, ih]

end ArrayLoops

section Pipeline

variable {A : Type u} {E : Type v} {Q : Type}

inductive Symbol (A : Type u) (E : Type v)
  | blank
  | letter : A → Symbol A E
  | other : E → Symbol A E

def spells (t : Nat → Symbol A E) : Nat → List A → Prop
  | i, [] => t i = .blank
  | i, a :: w => t i = .letter a ∧ spells t (i + 1) w

def readTape (t : Nat → Symbol A E) : Nat → Nat → Nat → Option (List A)
  | _, 0, _ => none
  | i, fuel + 1, cap =>
    match t i with
    | .blank => some []
    | .other _ => none
    | .letter a =>
      match cap with
      | 0 => none
      | cap + 1 => (readTape t (i + 1) fuel cap).map (a :: ·)

theorem readTape_sound (t : Nat → Symbol A E) (i fuel cap : Nat) (out : List A)
    (h : readTape t i fuel cap = some out) :
    spells t i out ∧ out.length < fuel ∧ out.length ≤ cap := by
  induction fuel generalizing i cap out with
  | zero => simp [readTape] at h
  | succ fuel ih =>
    cases hs : t i with
    | blank =>
      simp only [readTape, hs, Option.some.injEq] at h
      subst out
      exact ⟨hs, by simp, Nat.zero_le _⟩
    | other e => simp [readTape, hs] at h
    | letter a =>
      cases cap with
      | zero => simp [readTape, hs] at h
      | succ cap =>
        cases hr : readTape t (i + 1) fuel cap with
        | none => simp [readTape, hs, hr] at h
        | some rest =>
          simp only [readTape, hs, hr, Option.map_some, Option.some.injEq] at h
          subst out
          obtain ⟨hp, hf, hc⟩ := ih (i + 1) cap rest hr
          exact ⟨⟨hs, hp⟩, by simpa using Nat.succ_lt_succ hf,
            by simpa using Nat.succ_le_succ hc⟩

theorem readTape_complete (t : Nat → Symbol A E) (i fuel cap : Nat) (out : List A)
    (hs : spells t i out) (hf : out.length < fuel) (hc : out.length ≤ cap) :
    readTape t i fuel cap = some out := by
  induction out generalizing i fuel cap with
  | nil =>
    cases fuel with
    | zero => simp at hf
    | succ fuel =>
      have hblank : t i = .blank := hs
      simp [readTape, hblank]
  | cons a out ih =>
    cases fuel with
    | zero => simp at hf
    | succ fuel =>
      cases cap with
      | zero => simp at hc
      | succ cap =>
        have htail := ih (i + 1) fuel cap hs.2 (by simpa using hf) (by simpa using hc)
        simp [readTape, hs.1, htail]

theorem spells_unique (t : Nat → Symbol A E) (i : Nat) (a b : List A)
    (ha : spells t i a) (hb : spells t i b) : a = b := by
  induction a generalizing i b with
  | nil =>
    cases b with
    | nil => rfl
    | cons b bs => simp only [spells] at ha hb; rw [ha] at hb; cases hb.1
  | cons a as ih =>
    cases b with
    | nil => simp only [spells] at ha hb; rw [hb] at ha; cases ha.1
    | cons b bs =>
      have hab : a = b := Symbol.letter.inj (ha.1.symm.trans hb.1)
      simp only [hab, List.cons.injEq, true_and]
      exact ih (i + 1) bs ha.2 hb.2

def initial (q : Q) (input : List A) : Config Q (Symbol A E) :=
  ⟨q, 0, inputTape .blank (input.map Symbol.letter)⟩

def ProgramResult (δ : Q → Symbol A E → Option (Instruction Q (Symbol A E)))
    (halt : Q → Prop) (q : Q) (input out : List A) : Prop :=
  ∃ c, Trace (machineStep δ) (initial q input) c ∧ halt c.state ∧ spells c.tape 0 out

def PipelineSuccess (δ : Q → Symbol A E → Option (Instruction Q (Symbol A E)))
    (halt : Q → Prop) (q : Q) (input : List A) (s : Nat) (out : List A) : Prop :=
  input.length < s ∧
    ∃ c, Trace (boundedStep s δ) (initial q input) c ∧ halt c.state ∧
      readTape c.tape 0 s input.length = some out

theorem pipeline_sound
    (δ : Q → Symbol A E → Option (Instruction Q (Symbol A E)))
    (halt : Q → Prop) (q : Q) (input out : List A) (s : Nat)
    (h : PipelineSuccess δ halt q input s out) :
    ProgramResult δ halt q input out ∧ out.length ≤ input.length := by
  obtain ⟨_, c, ht, hh, hr⟩ := h
  obtain ⟨hp, _, hl⟩ := readTape_sound c.tape 0 s input.length out hr
  exact ⟨⟨c, bounded_trace_sound s δ ht, hh, hp⟩, hl⟩

theorem pipeline_complete
    (δ : Q → Symbol A E → Option (Instruction Q (Symbol A E)))
    (halt : Q → Prop) (q : Q) (input out : List A)
    (h : ProgramResult δ halt q input out) (hl : out.length ≤ input.length) :
    ∃ s, PipelineSuccess δ halt q input s out := by
  obtain ⟨c, ht, hh, hp⟩ := h
  obtain ⟨s, hs⟩ := finite_trace_quota δ ht
  let t := max s (input.length + 1)
  obtain ⟨htrace, _, _⟩ := hs t (le_max_left _ _)
  have hit : input.length < t := by
    have := le_max_right s (input.length + 1)
    omega
  exact ⟨t, hit, c, htrace, hh,
    readTape_complete c.tape 0 t input.length out hp (by omega) hl⟩

theorem program_result_unique
    (δ : Q → Symbol A E → Option (Instruction Q (Symbol A E)))
    (halt : Q → Prop) (hh : ∀ q, halt q → ∀ t, δ q t = none)
    (q : Q) (input a b : List A)
    (ha : ProgramResult δ halt q input a) (hb : ProgramResult δ halt q input b) :
    a = b := by
  obtain ⟨c, htc, hhc, hpc⟩ := ha
  obtain ⟨d, htd, hhd, hpd⟩ := hb
  have hc : machineStep δ c = none := by simp [machineStep, hh c.state hhc]
  have hd : machineStep δ d = none := by simp [machineStep, hh d.state hhd]
  obtain ⟨e, hce, hde⟩ := reach_diamond (machineStep δ)
    (trace_reach _ htc) (trace_reach _ htd)
  have hcd : c = d := (terminal_reach _ hc hce).trans (terminal_reach _ hd hde).symm
  subst d
  exact spells_unique c.tape 0 a b hpc hpd

theorem pipeline_computes_program
    (δ : Q → Symbol A E → Option (Instruction Q (Symbol A E)))
    (halt : Q → Prop) (hh : ∀ q, halt q → ∀ t, δ q t = none)
    (q : Q) (input expected actual : List A) (s : Nat)
    (hprogram : ProgramResult δ halt q input expected)
    (hpipeline : PipelineSuccess δ halt q input s actual) : actual = expected :=
  program_result_unique δ halt hh q input actual expected
    (pipeline_sound δ halt q input actual s hpipeline).1 hprogram

end Pipeline

section WordTransport

variable {G : Type u}

def wordGrade (cost : G → Nat) : List G → Nat
  | [] => 0
  | a :: w => cost a + wordGrade cost w

@[simp] theorem wordGrade_append (cost : G → Nat) (x y : List G) :
    wordGrade cost (x ++ y) = wordGrade cost x + wordGrade cost y := by
  induction x with
  | nil => simp [wordGrade]
  | cons a x ih => simp [wordGrade, ih, Nat.add_assoc]

inductive WordStep (equation : List G → List G → Prop) : List G → List G → Prop
  | context (x y u v : List G) : equation u v →
      WordStep equation (x ++ u ++ y) (x ++ v ++ y)

theorem wordStep_context (equation : List G → List G → Prop)
    {u v : List G} (h : WordStep equation u v) (x y : List G) :
    WordStep equation (x ++ u ++ y) (x ++ v ++ y) := by
  cases h with
  | context a b p q he =>
    simpa [List.append_assoc] using WordStep.context (x ++ a) (b ++ y) p q he

inductive BoundedPath (equation : List G → List G → Prop)
    (cost : G → Nat) (m : Nat) : List G → List G → Prop
  | refl (a : List G) : wordGrade cost a ≤ m → BoundedPath equation cost m a a
  | tail {a b c : List G} : BoundedPath equation cost m a b →
      WordStep equation b c → wordGrade cost c ≤ m → BoundedPath equation cost m a c

theorem boundedPath_end (equation : List G → List G → Prop) (cost : G → Nat)
    (m : Nat) {a b : List G} (h : BoundedPath equation cost m a b) :
    wordGrade cost b ≤ m := by
  cases h with
  | refl hg => exact hg
  | tail _ _ hg => exact hg

theorem boundedPath_context (equation : List G → List G → Prop) (cost : G → Nat)
    {n m : Nat} {a b : List G} (h : BoundedPath equation cost n a b)
    (x y : List G) (hm : wordGrade cost x + n + wordGrade cost y ≤ m) :
    BoundedPath equation cost m (x ++ a ++ y) (x ++ b ++ y) := by
  induction h with
  | refl hg =>
    apply BoundedPath.refl
    simp only [wordGrade_append]
    omega
  | tail hab hbc hc ih =>
    apply BoundedPath.tail ih (wordStep_context equation hbc x y)
    simp only [wordGrade_append]
    omega

theorem boundedPath_invariant (equation : List G → List G → Prop) (cost : G → Nat)
    (N : List G → List G) (m : Nat)
    (hstep : ∀ {a b}, WordStep equation a b →
      wordGrade cost a ≤ m → wordGrade cost b ≤ m → N a = N b)
    {a b : List G} (h : BoundedPath equation cost m a b) : N a = N b := by
  induction h with
  | refl => rfl
  | tail hab hbc hc ih =>
    exact ih.trans (hstep hbc (boundedPath_end equation cost m hab) hc)

theorem arbitrary_word_context (equation : List G → List G → Prop) (cost : G → Nat)
    (N : List G → List G) (m : Nat)
    (hstep : ∀ {a b}, WordStep equation a b →
      wordGrade cost a ≤ m → wordGrade cost b ≤ m → N a = N b)
    (hderive : ∀ a, wordGrade cost a ≤ m →
      BoundedPath equation cost (wordGrade cost a) a (N a))
    (u v x y : List G) (heq : N u = N v)
    (hu : wordGrade cost (x ++ u ++ y) ≤ m)
    (hv : wordGrade cost (x ++ v ++ y) ≤ m) :
    N (x ++ u ++ y) = N (x ++ v ++ y) := by
  have hum : wordGrade cost u ≤ m := by simp only [wordGrade_append] at hu; omega
  have hvm : wordGrade cost v ≤ m := by simp only [wordGrade_append] at hv; omega
  have du := boundedPath_context equation cost (hderive u hum) x y
    (by simpa only [wordGrade_append] using hu)
  have dv := boundedPath_context equation cost (hderive v hvm) x y
    (by simpa only [wordGrade_append] using hv)
  have eu := boundedPath_invariant equation cost N m hstep du
  have ev := boundedPath_invariant equation cost N m hstep dv
  rw [heq] at eu
  exact eu.trans ev.symm

end WordTransport

end CompilerProof
