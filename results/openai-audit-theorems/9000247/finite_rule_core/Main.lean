import Mathlib

namespace FiniteRuleBoundary

inductive Structural where
  | core : Nat → Structural
  | palette : Nat → Structural
  | stop : Structural
  deriving DecidableEq

inductive Marker where
  | idle | left | boundary | full | right
  deriving DecidableEq

structure Cell where
  structural : Structural
  marker : Marker
  formatOK : Bool
  checkerIdle : Bool
  deriving DecidableEq

def cursor (p : Nat) : Cell :=
  ⟨.core p, .boundary, true, true⟩

inductive Unary : Cell → Cell → Prop where
  | create (a b : Cell) :
      a.structural = .core 1 → b.structural = .core 1 →
      a.marker = .idle → b.marker = .boundary → Unary a b
  | uncreate (a b : Cell) :
      a.structural = .core 1 → b.structural = .core 1 →
      a.marker = .boundary → b.marker = .idle → Unary a b
  | enter (a b : Cell) :
      a.structural = .stop → b.structural = .stop →
      a.marker = .boundary → b.marker = .full → Unary a b
  | unenter (a b : Cell) :
      a.structural = .stop → b.structural = .stop →
      a.marker = .full → b.marker = .boundary → Unary a b
  | control (a b : Cell) :
      a.marker = .full → b.marker = .full → Unary a b

inductive Rule : List Cell → List Cell → Prop where
  | unary {a b} : Unary a b → Rule [a] [b]
  | wider {u v} : 2 ≤ u.length → u.length = v.length → Rule u v

def Step (u v : List Cell) : Prop :=
  ∃ pre post lhs rhs,
    u = pre ++ lhs ++ post ∧
    v = pre ++ rhs ++ post ∧ Rule lhs rhs

inductive Trace : List Cell → List Cell → Prop where
  | refl (u) : Trace u u
  | tail {u v w} : Trace u v → Step v w → Trace u w

inductive UnaryZero : Cell → Prop where
  | format (a) : a.formatOK = false → UnaryZero a
  | firstRight (a) : a.marker = .right → UnaryZero a
  | lastLeft (a) : a.marker = .left → UnaryZero a
  | full (a) : a.marker = .full → UnaryZero a
  | checker (a n) :
      a.structural = .palette n → a.checkerIdle = false → UnaryZero a

inductive DeclaredZero : List Cell → Prop where
  | unary {a} : UnaryZero a → DeclaredZero [a]
  | wider {u} : 2 ≤ u.length → DeclaredZero u

def ContainsZero (u : List Cell) : Prop :=
  ∃ pre post factor, u = pre ++ factor ++ post ∧ DeclaredZero factor

def Nonzero (u : List Cell) : Prop :=
  ∀ v, Trace u v → ¬ ContainsZero v

def Released (u : List Cell) : Prop :=
  ∀ a ∈ u, a.marker = .idle

def CanRelease (u : List Cell) : Prop :=
  ∃ v, Trace u v ∧ Released v

theorem no_unary (p : Nat) (hp : p ≠ 1) (b : Cell) :
    ¬ Unary (cursor p) b := by
  intro h
  cases h <;> simp_all [cursor]

theorem no_unary_zero (p : Nat) : ¬ UnaryZero (cursor p) := by
  intro h
  cases h <;> simp_all [cursor]

theorem no_step (p : Nat) (hp : p ≠ 1) (v : List Cell) :
    ¬ Step [cursor p] v := by
  rintro ⟨pre, post, lhs, rhs, hu, _, hr⟩
  have hlen : 1 = pre.length + lhs.length + post.length := by
    simpa [Nat.add_assoc] using congrArg List.length hu
  cases hr with
  | @unary a b hab =>
      have hpre : pre = [] := by
        cases pre with
        | nil => rfl
        | cons a pre =>
            simp only [List.length_cons, List.length_singleton] at hlen
            omega
      have hpost : post = [] := by
        cases post with
        | nil => rfl
        | cons a post =>
            simp only [List.length_cons, List.length_singleton] at hlen
            omega
      subst pre
      subst post
      simp only [List.nil_append, List.append_nil, List.cons.injEq,
        and_true] at hu
      subst a
      exact no_unary p hp b hab
  | wider htwo _ =>
      omega

theorem trace_fixed (p : Nat) (hp : p ≠ 1) {v : List Cell}
    (h : Trace [cursor p] v) : v = [cursor p] := by
  induction h with
  | refl => rfl
  | @tail v w h hstep ih =>
      subst v
      exact False.elim (no_step p hp w hstep)

theorem no_contains_zero (p : Nat) : ¬ ContainsZero [cursor p] := by
  rintro ⟨pre, post, factor, hu, hz⟩
  have hlen : 1 = pre.length + factor.length + post.length := by
    simpa [Nat.add_assoc] using congrArg List.length hu
  cases hz with
  | @unary a ha =>
      have hpre : pre = [] := by
        cases pre with
        | nil => rfl
        | cons a pre =>
            simp only [List.length_cons, List.length_singleton] at hlen
            omega
      have hpost : post = [] := by
        cases post with
        | nil => rfl
        | cons a post =>
            simp only [List.length_cons, List.length_singleton] at hlen
            omega
      subst pre
      subst post
      simp only [List.nil_append, List.append_nil, List.cons.injEq,
        and_true] at hu
      subst a
      exact no_unary_zero p ha
  | wider htwo =>
      omega

theorem cursor_nonzero (p : Nat) (hp : p ≠ 1) : Nonzero [cursor p] := by
  intro v hv
  rw [trace_fixed p hp hv]
  exact no_contains_zero p

theorem cursor_not_releasable (p : Nat) (hp : p ≠ 1) :
    ¬ CanRelease [cursor p] := by
  rintro ⟨v, hv, hrelease⟩
  rw [trace_fixed p hp hv] at hrelease
  have hmark := hrelease (cursor p) (by simp)
  simp [cursor] at hmark

theorem parameter_uniform_counterexample
    (q p : Nat) (_hq : 3 ≤ q) (hp : 1 < p) (hpq : p < q) :
    1 ≤ p ∧ p ≤ q ∧
      Nonzero [cursor p] ∧ ¬ CanRelease [cursor p] := by
  have hp1 : p ≠ 1 := by omega
  exact ⟨by omega, by omega, cursor_nonzero p hp1,
    cursor_not_releasable p hp1⟩

theorem chosen_position (q : Nat) (hq : 3 ≤ q) :
    Nonzero [cursor 2] ∧ ¬ CanRelease [cursor 2] := by
  have h := parameter_uniform_counterexample q 2 hq (by omega) (by omega)
  exact h.2.2

end FiniteRuleBoundary
