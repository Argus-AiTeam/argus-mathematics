import Mathlib

namespace CompilerContext

universe u v

inductive Token (A : Type u) (B : Type v)
  | raw : List A → Token A B
  | barrier : B → Token A B

variable {A : Type u} {B : Type v}

def mass : List (Token A B) → Nat
  | [] => 0
  | .raw w :: ts => w.length + mass ts
  | .barrier _ :: ts => mass ts

def grade (cost : B → Nat) : List (Token A B) → Nat
  | [] => 0
  | .raw w :: ts => 3 + w.length + grade cost ts
  | .barrier b :: ts => cost b + grade cost ts

@[simp] theorem mass_append (xs ys : List (Token A B)) :
    mass (xs ++ ys) = mass xs + mass ys := by
  induction xs with
  | nil => simp [mass]
  | cons t ts ih => cases t <;> simp [mass, ih, Nat.add_assoc]

@[simp] theorem grade_append (cost : B → Nat) (xs ys : List (Token A B)) :
    grade cost (xs ++ ys) = grade cost xs + grade cost ys := by
  induction xs with
  | nil => simp [grade]
  | cons t ts ih => cases t <;> simp [grade, ih, Nat.add_assoc]

theorem mass_le_grade (cost : B → Nat) (ts : List (Token A B)) :
    mass ts ≤ grade cost ts := by
  induction ts with
  | nil => simp [mass, grade]
  | cons t ts ih => cases t <;> simp only [mass, grade] <;> omega

structure Budget (f : List A → List A) (m : Nat) : Prop where
  length_le : ∀ w, w.length ≤ m → (f w).length ≤ w.length
  contextual : ∀ x w y, (x ++ w ++ y).length ≤ m →
    f (x ++ f w ++ y) = f (x ++ w ++ y)

def push (f : List A → List A) (t : Token A B) (ts : List (Token A B)) :
    List (Token A B) :=
  match t, ts with
  | .raw u, .raw v :: rest => .raw (f (u ++ v)) :: rest
  | _, _ => t :: ts

def normal (f : List A → List A) : List (Token A B) → List (Token A B)
  | [] => []
  | t :: ts => push f t (normal f ts)

def safe (f : List A → List A) (m : Nat) : List (Token A B) → Prop
  | [] => True
  | t :: ts => safe f m ts ∧
      match t, normal f ts with
      | .raw u, .raw v :: _ => (u ++ v).length ≤ m
      | _, _ => True

theorem normal_mass {f : List A → List A} {m : Nat}
    (hb : Budget f m) (ts : List (Token A B)) (h : mass ts ≤ m) :
    mass (normal f ts) ≤ mass ts := by
  induction ts with
  | nil => simp [normal, mass]
  | cons t ts ih =>
    have ht : mass ts ≤ m := by cases t <;> simp only [mass] at h <;> omega
    have hi := ih ht
    cases t with
    | barrier b => simpa [normal, push, mass] using hi
    | raw u =>
      cases hn : normal f ts with
      | nil => simp [normal, hn, push, mass]
      | cons a rest =>
        cases a with
        | barrier b => simpa [normal, hn, push, mass] using Nat.add_le_add_left hi u.length
        | raw w =>
          have hm : w.length + mass rest ≤ mass ts := by simpa [hn, mass] using hi
          have ha : (u ++ w).length ≤ m := by simp only [mass] at h; simp; omega
          have hl := hb.length_le (u ++ w) ha
          simp only [List.length_append] at hl
          simp only [normal, hn, push, mass]
          omega

theorem normal_safe {f : List A → List A} {m : Nat}
    (hb : Budget f m) (ts : List (Token A B)) (h : mass ts ≤ m) :
    safe f m ts := by
  induction ts with
  | nil => trivial
  | cons t ts ih =>
    have ht : mass ts ≤ m := by cases t <;> simp only [mass] at h <;> omega
    refine ⟨ih ht, ?_⟩
    cases t with
    | barrier _ => trivial
    | raw u =>
      cases hn : normal f ts with
      | nil => trivial
      | cons a rest =>
        cases a with
        | barrier _ => trivial
        | raw w =>
          have hm := normal_mass hb ts ht
          simp only [hn, mass] at hm
          simp only [mass] at h
          simp only [List.length_append]
          omega

theorem bounded_associativity {f : List A → List A} {m : Nat}
    (hb : Budget f m) (u v w : List A) (h : (u ++ v ++ w).length ≤ m) :
    f (u ++ f (v ++ w)) = f (f (u ++ v) ++ w) := by
  have hr := hb.contextual u (v ++ w) [] (by simpa using h)
  have hl := hb.contextual [] (u ++ v) w (by simpa [List.append_assoc] using h)
  simp only [List.append_nil, List.nil_append, List.append_assoc] at hr hl
  exact hr.trans hl.symm

theorem normal_prefix_congr (f : List A → List A)
    (p xs ys : List (Token A B)) (h : normal f xs = normal f ys) :
    normal f (p ++ xs) = normal f (p ++ ys) := by
  induction p with
  | nil => simpa using h
  | cons t ts ih => simpa [normal] using congrArg (push f t) ih

theorem normal_pair_right {f : List A → List A} {m : Nat}
    (hb : Budget f m) (u v : List A) (r : List (Token A B))
    (h : u.length + v.length + mass r ≤ m) :
    normal f (.raw u :: .raw v :: r) =
      normal f (.raw (f (u ++ v)) :: r) := by
  have hr : mass r ≤ m := by omega
  have hm := normal_mass hb r hr
  cases hn : normal f r with
  | nil => simp [normal, hn, push]
  | cons t ts =>
    cases t with
    | barrier b => simp [normal, hn, push]
    | raw w =>
      have hw : w.length + mass ts ≤ mass r := by simpa [hn, mass] using hm
      have ha : (u ++ v ++ w).length ≤ m := by simp; omega
      simp only [normal, hn, push]
      rw [bounded_associativity hb u v w ha]

inductive Contracts (f : List A → List A) (m : Nat) :
    List (Token A B) → List (Token A B) → Prop
  | pair (l r : List (Token A B)) (u v : List A) (h : (u ++ v).length ≤ m) :
      Contracts f m (l ++ .raw u :: .raw v :: r)
        (l ++ .raw (f (u ++ v)) :: r)

theorem contract_normal {f : List A → List A} {m : Nat}
    (hb : Budget f m) {xs ys : List (Token A B)}
    (hs : Contracts f m xs ys) (h : mass xs ≤ m) :
    normal f xs = normal f ys := by
  cases hs with
  | pair l r u v ha =>
    apply normal_prefix_congr
    apply normal_pair_right hb
    simp only [mass_append, mass] at h
    omega

theorem contract_mass {f : List A → List A} {m : Nat}
    (hb : Budget f m) {xs ys : List (Token A B)}
    (hs : Contracts f m xs ys) : mass ys ≤ mass xs := by
  cases hs with
  | pair l r u v ha =>
    have hl := hb.length_le (u ++ v) ha
    simp only [List.length_append] at hl
    simp only [mass_append, mass]
    omega

theorem contract_grade {f : List A → List A} {m : Nat}
    (hb : Budget f m) (cost : B → Nat) {xs ys : List (Token A B)}
    (hs : Contracts f m xs ys) : grade cost ys ≤ grade cost xs := by
  cases hs with
  | pair l r u v ha =>
    have hl := hb.length_le (u ++ v) ha
    simp only [List.length_append] at hl
    simp only [grade_append, grade]
    omega

inductive Derives (f : List A → List A) (m : Nat) :
    List (Token A B) → List (Token A B) → Prop
  | refl (xs) : Derives f m xs xs
  | step {xs ys zs} : Derives f m xs ys → Contracts f m ys zs → Derives f m xs zs

theorem contract_context {f : List A → List A} {m : Nat}
    {xs ys : List (Token A B)} (hs : Contracts f m xs ys)
    (l r : List (Token A B)) :
    Contracts f m (l ++ xs ++ r) (l ++ ys ++ r) := by
  cases hs with
  | pair p q u v h =>
    simpa [List.append_assoc] using
      (Contracts.pair (f := f) (m := m) (l ++ p) (q ++ r) u v h)

theorem derives_context {f : List A → List A} {m : Nat}
    {xs ys : List (Token A B)} (hs : Derives f m xs ys)
    (l r : List (Token A B)) :
    Derives f m (l ++ xs ++ r) (l ++ ys ++ r) := by
  induction hs with
  | refl => exact .refl _
  | step hd hc ih => exact .step ih (contract_context hc l r)

theorem derives_mass {f : List A → List A} {m : Nat}
    (hb : Budget f m) {xs ys : List (Token A B)}
    (hs : Derives f m xs ys) : mass ys ≤ mass xs := by
  induction hs with
  | refl => exact le_refl _
  | step hd hc ih => exact (contract_mass hb hc).trans ih

theorem derives_grade {f : List A → List A} {m : Nat}
    (hb : Budget f m) (cost : B → Nat) {xs ys : List (Token A B)}
    (hs : Derives f m xs ys) : grade cost ys ≤ grade cost xs := by
  induction hs with
  | refl => exact le_refl _
  | step hd hc ih => exact (contract_grade hb cost hc).trans ih

theorem derives_normal {f : List A → List A} {m : Nat}
    (hb : Budget f m) {xs ys : List (Token A B)}
    (hs : Derives f m xs ys) (h : mass xs ≤ m) :
    normal f xs = normal f ys := by
  induction hs with
  | refl => rfl
  | step hd hc ih =>
    exact ih.trans (contract_normal hb hc ((derives_mass hb hd).trans h))

theorem normal_derivation {f : List A → List A} {m : Nat}
    (hb : Budget f m) (xs : List (Token A B)) (h : mass xs ≤ m) :
    Derives f m xs (normal f xs) := by
  induction xs with
  | nil => exact .refl _
  | cons t ts ih =>
    have ht : mass ts ≤ m := by cases t <;> simp only [mass] at h <;> omega
    have hd : Derives f m (t :: ts) (t :: normal f ts) := by
      simpa using derives_context (ih ht) [t] []
    cases t with
    | barrier b => simpa [normal, push] using hd
    | raw u =>
      cases hn : normal f ts with
      | nil => simpa [normal, push, hn] using hd
      | cons a rest =>
        cases a with
        | barrier b => simpa [normal, push, hn] using hd
        | raw w =>
          have hm := normal_mass hb ts ht
          simp only [hn, mass] at hm
          have ha : (u ++ w).length ≤ m := by
            simp only [mass] at h
            simp only [List.length_append]
            omega
          have hc : Contracts f m (.raw u :: normal f ts)
              (push f (.raw u) (normal f ts)) := by
            simpa [hn, push] using
              (Contracts.pair (f := f) (B := B) [] rest u w ha)
          exact .step hd hc

theorem bounded_context_compatibility {f : List A → List A} {m : Nat}
    (hb : Budget f m) (u v l r : List (Token A B))
    (heq : normal f u = normal f v)
    (hu : mass (l ++ u ++ r) ≤ m) (hv : mass (l ++ v ++ r) ≤ m) :
    normal f (l ++ u ++ r) = normal f (l ++ v ++ r) := by
  have hmu : mass u ≤ m := by simp only [mass_append] at hu; omega
  have hmv : mass v ≤ m := by simp only [mass_append] at hv; omega
  have du := derives_context (normal_derivation hb u hmu) l r
  have dv := derives_context (normal_derivation hb v hmv) l r
  have eu := derives_normal hb du hu
  have ev := derives_normal hb dv hv
  rw [heq] at eu
  exact eu.trans ev.symm

@[simp] theorem normal_empty (f : List A → List A) :
    normal (B := B) f [] = [] := rfl

@[simp] theorem normal_singleton (f : List A → List A) (w : List A) :
    normal (B := B) f [.raw w] = [.raw w] := rfl

def sourceRun (f : List A → List A) : List (List A) → List (Token A B)
  | [] => []
  | [w] => [.raw w]
  | u :: v :: rest => [.raw (f ((u :: v :: rest).flatten))]

theorem normal_raw_run {f : List A → List A} {m : Nat}
    (hb : Budget f m) (ws : List (List A)) (h : ws.flatten.length ≤ m) :
    normal (B := B) f (ws.map Token.raw) = sourceRun f ws := by
  induction ws with
  | nil => rfl
  | cons u ws ih =>
    cases ws with
    | nil => rfl
    | cons v rest =>
      cases rest with
      | nil => simp [normal, push, sourceRun]
      | cons w rest =>
        have ht : (v :: w :: rest).flatten.length ≤ m := by
          simp only [List.flatten_cons, List.length_append] at h ⊢
          omega
        have hi := ih ht
        change push f (.raw u) (normal f ((v :: w :: rest).map Token.raw)) = _
        rw [hi]
        have hc := hb.contextual u ((v :: w :: rest).flatten) []
          (by simpa only [List.flatten_cons, List.append_nil] using h)
        simpa [push, sourceRun] using
          congrArg (fun z => [Token.raw (B := B) z]) hc

theorem normal_grade {f : List A → List A} {m : Nat}
    (hb : Budget f m) (cost : B → Nat) (xs : List (Token A B))
    (h : grade cost xs ≤ m) :
    grade cost (normal f xs) ≤ grade cost xs :=
  derives_grade hb cost (normal_derivation hb xs ((mass_le_grade cost xs).trans h))

theorem normal_safe_grade {f : List A → List A} {m : Nat}
    (hb : Budget f m) (cost : B → Nat) (xs : List (Token A B))
    (h : grade cost xs ≤ m) : safe f m xs :=
  normal_safe hb xs ((mass_le_grade cost xs).trans h)

theorem bounded_context_grade {f : List A → List A} {m : Nat}
    (hb : Budget f m) (cost : B → Nat) (u v l r : List (Token A B))
    (heq : normal f u = normal f v)
    (hu : grade cost (l ++ u ++ r) ≤ m)
    (hv : grade cost (l ++ v ++ r) ≤ m) :
    normal f (l ++ u ++ r) = normal f (l ++ v ++ r) :=
  bounded_context_compatibility hb u v l r heq
    ((mass_le_grade cost _).trans hu) ((mass_le_grade cost _).trans hv)

end CompilerContext
