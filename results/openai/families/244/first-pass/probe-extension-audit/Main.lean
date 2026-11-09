import Mathlib

set_option autoImplicit false

namespace ProbeAudit

universe u v w

def RDiv {M : Type u} [Monoid M] (x y : M) : Prop := ∃ z, x * z = y

def RJoin {M : Type u} [Monoid M] (x y g : M) : Prop :=
  ∀ z, (RDiv x z ∧ RDiv y z) ↔ RDiv g z

def ConditionalJoins (M : Type u) [Monoid M] : Prop :=
  ∀ x y : M, (∃ z, RDiv x z ∧ RDiv y z) → ∃ g, RJoin x y g

def Conical (M : Type u) [Monoid M] : Prop :=
  ∀ x y : M, x * y = 1 → x = 1 ∧ y = 1

theorem div_refl {M : Type u} [Monoid M] (x : M) : RDiv x x := ⟨1, mul_one x⟩

theorem div_trans {M : Type u} [Monoid M] {x y z : M}
    (hxy : RDiv x y) (hyz : RDiv y z) : RDiv x z := by
  rcases hxy with ⟨a, ha⟩
  rcases hyz with ⟨b, hb⟩
  exact ⟨a * b, by rw [←mul_assoc, ha, hb]⟩

def Conservative {M : Type u} {E : Type v} [Monoid M] [Monoid E]
    (old : M →* E) : Prop :=
  Function.Injective old ∧
  (∀ x y z, old x * z = old y → ∃ r, z = old r ∧ x * r = y) ∧
  (∀ x y g, RJoin x y g → RJoin (old x) (old y) (old g)) ∧
  (∀ x y, (¬∃ z, RDiv x z ∧ RDiv y z) →
    ¬∃ z, RDiv (old x) z ∧ RDiv (old y) z)

def GateCore {M : Type u} {E : Type v} [Monoid M] [Monoid E]
    (old : M →* E) : Prop :=
  ∀ x, (¬∃ a, x = old a) → (∃ a, RDiv x (old a)) →
    ∃ g c, x * old c = old g ∧
      (∀ a, RDiv x (old a) → RDiv g a) ∧
      (∀ d, RDiv (old g) (x * old d) → ∃ a, x * old d = old a)

def PrincipalPair {M : Type u} [Monoid M] (x y : M) : Prop :=
  (¬∃ z, RDiv x z ∧ RDiv y z) ∨ ∃ g, RJoin x y g

theorem join_of_div {M : Type u} [Monoid M] {x y : M} (hxy : RDiv x y) :
    RJoin x y y := by
  intro z
  exact ⟨And.right, fun hyz => ⟨div_trans hxy hyz, hyz⟩⟩

theorem pair_swap {M : Type u} [Monoid M] {x y : M} :
    PrincipalPair x y → PrincipalPair y x := by
  rintro (hn | ⟨g, hg⟩)
  · exact Or.inl (fun ⟨z, hx, hy⟩ => hn ⟨z, hy, hx⟩)
  · exact Or.inr ⟨g, fun z => by simpa only [and_comm] using hg z⟩

theorem pair_transfer {M : Type u} [Monoid M] {x y a b : M}
    (he : ∀ z, (RDiv x z ∧ RDiv y z) ↔ (RDiv a z ∧ RDiv b z)) :
    PrincipalPair a b → PrincipalPair x y := by
  rintro (hn | ⟨g, hg⟩)
  · exact Or.inl (fun ⟨z, hz⟩ => hn ⟨z, (he z).1 hz⟩)
  · exact Or.inr ⟨g, fun z => (he z).trans (hg z)⟩

theorem pair_left {M : Type u} [Monoid M]
    (lc : ∀ a x y : M, a * x = a * y → x = y) (a : M) {x y : M} :
    PrincipalPair x y → PrincipalPair (a * x) (a * y) := by
  have cancel : ∀ u v, (a * x) * u = (a * y) * v → x * u = y * v := by
    intro u v hh
    exact lc a _ _ (by simpa only [mul_assoc] using hh)
  rintro (hn | ⟨g, hg⟩)
  · apply Or.inl
    rintro ⟨z, ⟨u, hu⟩, ⟨v, hv⟩⟩
    exact hn ⟨x * u, ⟨u, rfl⟩, ⟨v, (cancel u v (hu.trans hv.symm)).symm⟩⟩
  · apply Or.inr
    refine ⟨a * g, ?_⟩
    intro z
    constructor
    · rintro ⟨⟨u, hu⟩, ⟨v, hv⟩⟩
      have hxy : RDiv x (x * u) ∧ RDiv y (x * u) :=
        ⟨⟨u, rfl⟩, ⟨v, (cancel u v (hu.trans hv.symm)).symm⟩⟩
      rcases (hg (x * u)).1 hxy with ⟨r, hr⟩
      exact ⟨r, by rw [mul_assoc, hr, ←mul_assoc, hu]⟩
    · intro hz
      rcases (hg g).2 (div_refl g) with ⟨⟨u, hu⟩, ⟨v, hv⟩⟩
      exact ⟨div_trans ⟨u, by rw [mul_assoc, hu]⟩ hz,
        div_trans ⟨v, by rw [mul_assoc, hv]⟩ hz⟩

structure ActData (M : Type u) (S : Type v) [Monoid M] where
  lc : ∀ a x y : M, a * x = a * y → x = y
  act : M → S → S
  act_one : ∀ s, act 1 s = s
  act_mul : ∀ a b s, act (a * b) s = act a (act b s)
  act_inj : ∀ a, Function.Injective (act a)
  h : S → M
  h_act : ∀ a s, h (act a s) = a * h s
  separation : ∀ s t, act (h s) t ≠ s

inductive Word (M : Type u) (S : Type v)
  | old : M → Word M S
  | cons : S → Word M S → Word M S
  deriving DecidableEq

namespace ActData

variable {M : Type u} {S : Type v} [Monoid M] (D : ActData M S)

def actWord (a : M) : Word M S → Word M S
  | .old x => .old (a * x)
  | .cons s t => .cons (D.act a s) t

@[simp] theorem actWord_one (x : Word M S) : D.actWord 1 x = x := by
  cases x <;> simp [actWord, D.act_one]

theorem actWord_mul (a b : M) (x : Word M S) :
    D.actWord (a * b) x = D.actWord a (D.actWord b x) := by
  cases x <;> simp [actWord, mul_assoc, D.act_mul]

theorem actWord_inj (a : M) : Function.Injective (D.actWord a) := by
  intro x y he
  cases x with
  | old x =>
    cases y with
    | old y => exact congrArg Word.old (D.lc a x y (Word.old.inj he))
    | cons s t => cases he
  | cons s t =>
    cases y with
    | old y => cases he
    | cons q r =>
      have hh := Word.cons.inj he
      exact congrArg₂ Word.cons (D.act_inj a hh.1) hh.2

def HasB (b : M) (x : Word M S) : Prop := ∃ y, D.actWord b y = x

def Normal (D : ActData M S) (b : M) : Word M S → Prop
  | .old _ => True
  | .cons _ t => D.Normal b t ∧ ¬D.HasB b t

theorem normal_actWord (b a : M) (x : Word M S) :
    D.Normal b (D.actWord a x) ↔ D.Normal b x := by
  cases x <;> rfl

noncomputable def push (b : M) (s : S) (x : Word M S) : Word M S := by
  classical
  exact if hb : D.HasB b x then D.actWord (D.h s) (Classical.choose hb)
    else .cons s x

theorem push_free (b : M) (s : S) (x : Word M S) (hx : ¬D.HasB b x) :
    D.push b s x = .cons s x := by
  simp [push, hx]

theorem push_act_b (b : M) (s : S) (x : Word M S) :
    D.push b s (D.actWord b x) = D.actWord (D.h s) x := by
  have hb : D.HasB b (D.actWord b x) := ⟨x, rfl⟩
  have he : Classical.choose hb = x := D.actWord_inj b (Classical.choose_spec hb)
  simp only [push, dif_pos hb, he]

theorem actWord_push (a b : M) (s : S) (x : Word M S) :
    D.actWord a (D.push b s x) = D.push b (D.act a s) x := by
  classical
  by_cases hb : D.HasB b x
  · simp only [push, dif_pos hb, D.h_act, D.actWord_mul]
  · simp only [push, dif_neg hb, actWord]

def Block (s : S) (x : Word M S) : Prop := ∃ t, x = .cons s t

theorem act_h_not_block (s : S) (x : Word M S) :
    ¬Block s (D.actWord (D.h s) x) := by
  rintro ⟨t, he⟩
  cases x with
  | old a => cases he
  | cons q r => exact D.separation s q (Word.cons.inj he).1

theorem push_inj (b : M) (s : S) : Function.Injective (D.push b s) := by
  classical
  intro x y he
  by_cases hx : D.HasB b x
  · by_cases hy : D.HasB b y
    · simp only [push, dif_pos hx, dif_pos hy] at he
      have hq := D.actWord_inj (D.h s) he
      exact (Classical.choose_spec hx).symm.trans
        ((congrArg (D.actWord b) hq).trans (Classical.choose_spec hy))
    · simp only [push, dif_pos hx, dif_neg hy] at he
      exact False.elim (D.act_h_not_block s _ ⟨y, he⟩)
  · by_cases hy : D.HasB b y
    · simp only [push, dif_neg hx, dif_pos hy] at he
      exact False.elim (D.act_h_not_block s _ ⟨x, he.symm⟩)
    · simp only [push, dif_neg hx, dif_neg hy] at he
      exact (Word.cons.inj he).2

theorem push_normal (b : M) (s : S) (x : Word M S) (hx : D.Normal b x) :
    D.Normal b (D.push b s x) := by
  classical
  by_cases hb : D.HasB b x
  · simp only [push, dif_pos hb]
    apply (D.normal_actWord b (D.h s) _).2
    apply (D.normal_actWord b b _).1
    rw [Classical.choose_spec hb]
    exact hx
  · rw [D.push_free b s x hb]
    exact ⟨hx, hb⟩

noncomputable def eval (D : ActData M S) (b : M) : Word M S → Word M S → Word M S
  | .old a, y => D.actWord a y
  | .cons s t, y => D.push b s (D.eval b t y)

theorem eval_actWord (b a : M) (x y : Word M S) :
    D.eval b (D.actWord a x) y = D.actWord a (D.eval b x y) := by
  cases x with
  | old c => exact D.actWord_mul a c y
  | cons s t => exact (D.actWord_push a b s (D.eval b t y)).symm

theorem eval_push (b : M) (s : S) (x y : Word M S) :
    D.eval b (D.push b s x) y = D.push b s (D.eval b x y) := by
  classical
  by_cases hb : D.HasB b x
  · have hx := Classical.choose_spec hb
    calc
      D.eval b (D.push b s x) y =
          D.actWord (D.h s) (D.eval b (Classical.choose hb) y) := by
            rw [push, dif_pos hb, D.eval_actWord]
      _ = D.push b s (D.actWord b (D.eval b (Classical.choose hb) y)) :=
        (D.push_act_b b s _).symm
      _ = D.push b s (D.eval b x y) := by rw [←D.eval_actWord, hx]
  · rw [D.push_free b s x hb]
    rfl

theorem eval_assoc (b : M) (x y z : Word M S) :
    D.eval b (D.eval b x y) z = D.eval b x (D.eval b y z) := by
  induction x with
  | old a => exact D.eval_actWord b a y z
  | cons s t ih => simpa only [eval, D.eval_push] using congrArg (D.push b s) ih

theorem eval_normal (b : M) (x y : Word M S) (hy : D.Normal b y) :
    D.Normal b (D.eval b x y) := by
  induction x with
  | old a => exact (D.normal_actWord b a y).2 hy
  | cons s t ih => exact D.push_normal b s _ ih

theorem eval_inj (b : M) (x : Word M S) : Function.Injective (D.eval b x) := by
  induction x with
  | old a => exact D.actWord_inj a
  | cons s t ih => exact (D.push_inj b s).comp ih

theorem eval_one (b : M) (x : Word M S) (hx : D.Normal b x) :
    D.eval b x (.old 1) = x := by
  induction x with
  | old a => simp [eval, actWord]
  | cons s t ih =>
    change D.push b s (D.eval b t (.old 1)) = .cons s t
    rw [ih hx.1, D.push_free b s t hx.2]

abbrev NF (b : M) := {x : Word M S // D.Normal b x}

noncomputable instance (b : M) : Monoid (D.NF b) where
  one := ⟨.old 1, trivial⟩
  mul x y := ⟨D.eval b x.val y.val, D.eval_normal b _ _ y.property⟩
  mul_assoc x y z := Subtype.ext (D.eval_assoc b x.val y.val z.val)
  one_mul x := Subtype.ext (D.actWord_one x.val)
  mul_one x := Subtype.ext (D.eval_one b x.val x.property)

noncomputable def old (b : M) : M →* D.NF b where
  toFun a := ⟨.old a, trivial⟩
  map_one' := rfl
  map_mul' _ _ := rfl

theorem old_inj (b : M) : Function.Injective (D.old b) := by
  intro x y h
  exact Word.old.inj (congrArg Subtype.val h)

theorem nf_lc (b : M) (a x y : D.NF b) (h : a * x = a * y) : x = y :=
  Subtype.ext (D.eval_inj b a.val (congrArg Subtype.val h))

noncomputable def letter (b : M) (s : S) : D.NF b :=
  ⟨D.push b s (.old 1), D.push_normal b s _ trivial⟩

theorem letter_mul_val (b : M) (s : S) (x : D.NF b) :
    ((D.letter b s) * x).val = D.push b s x.val := by
  change D.eval b (D.push b s (.old 1)) x.val = _
  rw [D.eval_push]
  simp only [eval, D.actWord_one]

theorem old_letter (b a : M) (s : S) :
    D.old b a * D.letter b s = D.letter b (D.act a s) :=
  Subtype.ext (D.actWord_push a b s (.old 1))

theorem letter_b (b : M) (s : S) :
    D.letter b s * D.old b b = D.old b (D.h s) := by
  apply Subtype.ext
  rw [D.letter_mul_val]
  change D.push b s (.old b) = .old (D.h s)
  simpa [actWord] using D.push_act_b b s (.old 1)

theorem nf_cons (b : M) (s : S) (t : D.NF b) (hf : ¬D.HasB b t.val) :
    (⟨Word.cons s t.val, ⟨t.property, hf⟩⟩ : D.NF b) = D.letter b s * t := by
  apply Subtype.ext
  rw [D.letter_mul_val, D.push_free b s t.val hf]

theorem h_ne_one (s : S) : D.h s ≠ 1 := by
  intro he
  apply D.separation s s
  rw [he, D.act_one]

theorem push_ne_one (hc : Conical M) (b : M) (s : S) (x : Word M S) :
    D.push b s x ≠ .old 1 := by
  classical
  by_cases hb : D.HasB b x
  · simp only [push, dif_pos hb]
    cases Classical.choose hb with
    | old a =>
      intro he
      exact D.h_ne_one s (hc _ _ (Word.old.inj he)).1
    | cons t y => intro he; cases he
  · rw [D.push_free b s x hb]
    intro he
    cases he

theorem nf_conical (hc : Conical M) (b : M) : Conical (D.NF b) := by
  intro x y h
  have he := congrArg Subtype.val h
  rcases x with ⟨x, hx⟩
  rcases y with ⟨y, hy⟩
  cases x with
  | cons s t => exact False.elim (D.push_ne_one hc b s _ he)
  | old a =>
    cases y with
    | cons s t => cases he
    | old c =>
      have hh := hc a c (Word.old.inj he)
      constructor
      · apply Subtype.ext; change Word.old a = Word.old 1; rw [hh.1]
      · apply Subtype.ext; change Word.old c = Word.old 1; rw [hh.2]

section Universal

variable {N : Type w} [Monoid N]

def targetEval (f : M →* N) (q : S → N) : Word M S → N
  | .old a => f a
  | .cons s t => q s * targetEval f q t

theorem target_actWord (f : M →* N) (q : S → N)
    (qa : ∀ a s, q (D.act a s) = f a * q s) (a : M) (x : Word M S) :
    targetEval f q (D.actWord a x) = f a * targetEval f q x := by
  cases x <;> simp [targetEval, actWord, qa, mul_assoc]

theorem target_push (f : M →* N) (q : S → N) (b : M)
    (qa : ∀ a s, q (D.act a s) = f a * q s)
    (qb : ∀ s, q s * f b = f (D.h s)) (s : S) (x : Word M S) :
    targetEval f q (D.push b s x) = q s * targetEval f q x := by
  classical
  by_cases hb : D.HasB b x
  · rw [push, dif_pos hb, D.target_actWord f q qa]
    have he : targetEval f q x = f b * targetEval f q (Classical.choose hb) := by
      calc
        targetEval f q x = targetEval f q (D.actWord b (Classical.choose hb)) :=
          congrArg (targetEval f q) (Classical.choose_spec hb).symm
        _ = _ := D.target_actWord f q qa b _
    rw [he, ←mul_assoc, qb]
  · rw [D.push_free b s x hb]
    rfl

theorem target_eval (f : M →* N) (q : S → N) (b : M)
    (qa : ∀ a s, q (D.act a s) = f a * q s)
    (qb : ∀ s, q s * f b = f (D.h s)) (x y : Word M S) :
    targetEval f q (D.eval b x y) = targetEval f q x * targetEval f q y := by
  induction x with
  | old a => exact D.target_actWord f q qa a y
  | cons s t ih =>
    change targetEval f q (D.push b s (D.eval b t y)) = _
    rw [D.target_push f q b qa qb, ih]
    exact (mul_assoc _ _ _).symm

noncomputable def lift (f : M →* N) (q : S → N) (b : M)
    (qa : ∀ a s, q (D.act a s) = f a * q s)
    (qb : ∀ s, q s * f b = f (D.h s)) : D.NF b →* N where
  toFun x := targetEval f q x.val
  map_one' := f.map_one
  map_mul' x y := D.target_eval f q b qa qb x.val y.val

theorem lift_old (f : M →* N) (q : S → N) (b : M)
    (qa : ∀ a s, q (D.act a s) = f a * q s)
    (qb : ∀ s, q s * f b = f (D.h s)) (a : M) :
    D.lift f q b qa qb (D.old b a) = f a := rfl

theorem lift_letter (f : M →* N) (q : S → N) (b : M)
    (qa : ∀ a s, q (D.act a s) = f a * q s)
    (qb : ∀ s, q s * f b = f (D.h s)) (s : S) :
    D.lift f q b qa qb (D.letter b s) = q s := by
  change targetEval f q (D.push b s (.old 1)) = q s
  rw [D.target_push f q b qa qb]
  simp [targetEval]

theorem lift_unique (f : M →* N) (q : S → N) (b : M)
    (qa : ∀ a s, q (D.act a s) = f a * q s)
    (qb : ∀ s, q s * f b = f (D.h s)) (F : D.NF b →* N)
    (fo : ∀ a, F (D.old b a) = f a)
    (fl : ∀ s, F (D.letter b s) = q s) :
    F = D.lift f q b qa qb := by
  apply MonoidHom.ext
  intro x
  rcases x with ⟨x, hx⟩
  induction x with
  | old a => exact fo a
  | cons s t ih =>
    let tail : D.NF b := ⟨t, hx.1⟩
    rw [D.nf_cons b s tail hx.2, F.map_mul, fl, ih hx.1]
    rw [(D.lift f q b qa qb).map_mul, D.lift_letter]

end Universal

def SDiv (a : M) (s : S) : Prop := ∃ t, D.act a t = s

structure ConeData : Prop where
  common : ∀ x y s, D.SDiv x s → D.SDiv y s →
    ∃ z, RDiv x z ∧ RDiv y z
  join : ∀ x y g, RJoin x y g → ∀ s,
    (D.SDiv x s ∧ D.SDiv y s) ↔ D.SDiv g s

theorem old_factor (b x y : M) (z : D.NF b)
    (he : D.old b x * z = D.old b y) :
    ∃ r, z = D.old b r ∧ x * r = y := by
  have hv := congrArg Subtype.val he
  rcases z with ⟨z, hz⟩
  cases z with
  | old r => exact ⟨r, rfl, Word.old.inj hv⟩
  | cons s t => cases hv

@[simp] theorem old_div_old (b x y : M) :
    RDiv (D.old b x) (D.old b y) ↔ RDiv x y := by
  constructor
  · rintro ⟨z, he⟩
    rcases D.old_factor b x y z he with ⟨r, _, hr⟩
    exact ⟨r, hr⟩
  · rintro ⟨r, hr⟩
    exact ⟨D.old b r, by rw [←map_mul, hr]⟩

@[simp] theorem old_div_cons (b x : M) (s : S) (t : Word M S)
    (hn : D.Normal b (.cons s t)) :
    RDiv (D.old b x) (⟨.cons s t, hn⟩ : D.NF b) ↔ D.SDiv x s := by
  constructor
  · rintro ⟨⟨z, hz⟩, he⟩
    have hv := congrArg Subtype.val he
    cases z with
    | old a => cases hv
    | cons q r => exact ⟨q, (Word.cons.inj hv).1⟩
  · rintro ⟨q, hq⟩
    refine ⟨⟨.cons q t, hn⟩, ?_⟩
    apply Subtype.ext
    exact congrArg (fun z => Word.cons z t) hq

theorem hasB_iff (b : M) (x : D.NF b) :
    D.HasB b x.val ↔ RDiv (D.old b b) x := by
  constructor
  · rintro ⟨q, hq⟩
    have hn : D.Normal b q := (D.normal_actWord b b q).1 (hq ▸ x.property)
    exact ⟨⟨q, hn⟩, Subtype.ext hq⟩
  · rintro ⟨q, hq⟩
    exact ⟨q.val, congrArg Subtype.val hq⟩

theorem old_join (C : D.ConeData) (b x y g : M) (hj : RJoin x y g) :
    RJoin (D.old b x) (D.old b y) (D.old b g) := by
  rintro ⟨z, hz⟩
  cases z with
  | old a =>
    change (RDiv (D.old b x) (D.old b a) ∧ RDiv (D.old b y) (D.old b a)) ↔
      RDiv (D.old b g) (D.old b a)
    simpa only [D.old_div_old] using hj a
  | cons s t => simpa only [D.old_div_cons] using C.join x y g hj s

theorem old_common (C : D.ConeData) (b x y : M) (z : D.NF b)
    (hx : RDiv (D.old b x) z) (hy : RDiv (D.old b y) z) :
    ∃ a, RDiv x a ∧ RDiv y a := by
  rcases z with ⟨z, hz⟩
  cases z with
  | old a => exact ⟨a, (D.old_div_old b x a).1 hx, (D.old_div_old b y a).1 hy⟩
  | cons s t =>
    exact C.common x y s ((D.old_div_cons b x s t hz).1 hx)
      ((D.old_div_cons b y s t hz).1 hy)

theorem old_intersection (C : D.ConeData) (J : ConditionalJoins M) (b x y : M) :
    (∀ z : D.NF b, ¬(RDiv (D.old b x) z ∧ RDiv (D.old b y) z)) ∨
    ∃ g u v, x * u = g ∧ y * v = g ∧
      RJoin (D.old b x) (D.old b y) (D.old b g) := by
  classical
  by_cases hh : ∃ a, RDiv x a ∧ RDiv y a
  · rcases J x y hh with ⟨g, hg⟩
    have hgg : RDiv g g := ⟨1, mul_one g⟩
    rcases (hg g).2 hgg with ⟨⟨u, hu⟩, ⟨v, hv⟩⟩
    exact Or.inr ⟨g, u, v, hu, hv, D.old_join C b x y g hg⟩
  · exact Or.inl (fun z hz => hh (D.old_common C b x y z hz.1 hz.2))

theorem old_div_block (b x : M) (s : S) (z : D.NF b) (hz : Block s z.val) :
    RDiv (D.old b x) z ↔ D.SDiv x s := by
  rcases z with ⟨z, hn⟩
  rcases hz with ⟨t, rfl⟩
  exact D.old_div_cons b x s t hn

theorem hasB_cons (b : M) (s : S) (t : Word M S) :
    D.HasB b (.cons s t) ↔ D.SDiv b s := by
  constructor
  · rintro ⟨q, hq⟩
    cases q with
    | old a => cases hq
    | cons u v => exact ⟨u, (Word.cons.inj hq).1⟩
  · rintro ⟨u, hu⟩
    exact ⟨.cons u t, congrArg (fun z => Word.cons z t) hu⟩

theorem push_block (b : M) (s : S) (x : Word M S) :
    Block s (D.push b s x) ↔ ¬D.HasB b x := by
  classical
  by_cases hb : D.HasB b x
  · rw [push, dif_pos hb]
    exact iff_of_false (D.act_h_not_block s _) (not_not_intro hb)
  · rw [D.push_free b s x hb]
    exact iff_of_true ⟨x, rfl⟩ hb

def IsOldWord (x : Word M S) : Prop := ∃ a, x = .old a

def SameHead (x y : Word M S) : Prop :=
  ∃ s t v, x = .cons s t ∧ y = .cons s v

theorem push_old_shape (b : M) (s : S) (a : M) :
    IsOldWord (D.push b s (.old a)) ∨ Block s (D.push b s (.old a)) := by
  classical
  by_cases hb : D.HasB b (.old a)
  · rcases hb with ⟨q, hq⟩
    cases q with
    | old q =>
      apply Or.inl
      refine ⟨D.h s * q, ?_⟩
      rw [←hq, D.push_act_b]
      rfl
    | cons t v => cases hq
  · exact Or.inr ((D.push_block b s (.old a)).2 hb)

theorem append_old_shape (b : M) (x : Word M S) (hn : D.Normal b x) (d : M) :
    IsOldWord (D.eval b x (.old d)) ∨ SameHead x (D.eval b x (.old d)) := by
  induction x with
  | old a => exact Or.inl ⟨a * d, rfl⟩
  | cons s t ih =>
    rcases ih hn.1 with h | h
    · rcases h with ⟨a, ha⟩
      change IsOldWord (D.push b s (D.eval b t (.old d))) ∨ _
      rw [ha]
      rcases D.push_old_shape b s a with ho | hb
      · exact Or.inl ho
      · rcases hb with ⟨v, hv⟩
        apply Or.inr
        refine ⟨s, t, v, rfl, ?_⟩
        change D.push b s (D.eval b t (.old d)) = .cons s v
        rw [ha]
        exact hv
    · rcases h with ⟨q, rt, rv, ht, hv⟩
      have hfree : ¬D.HasB b (D.eval b t (.old d)) := by
        intro hb
        apply hn.2
        rw [ht, D.hasB_cons]
        apply (D.hasB_cons b q rv).1
        exact hv ▸ hb
      exact Or.inr ⟨s, t, D.eval b t (.old d), rfl, D.push_free b s _ hfree⟩

structure ExitGate (b : M) (s : S) (x : D.NF b) (g c : M) : Prop where
  reach : x * D.old b c = D.old b g
  away : ∀ z : D.NF b, RDiv (D.old b g) z → ¬Block s z.val
  cover : ∀ v : D.NF b, ¬Block s (x * v).val → RDiv (D.old b g) (x * v)

def ExitAlternative (b : M) (s : S) (x : D.NF b) : Prop :=
  (∀ v : D.NF b, Block s (x * v).val) ∨ ∃ g c, D.ExitGate b s x g c

theorem gate_away (b : M) (s : S) (u : M) (z : D.NF b)
    (hz : RDiv (D.old b (D.h s * u)) z) : ¬Block s z.val := by
  rcases hz with ⟨v, rfl⟩
  change ¬Block s (D.actWord (D.h s * u) v.val)
  rw [D.actWord_mul]
  exact D.act_h_not_block s _

theorem exit_iff (b : M) (s : S) (t : Word M S)
    (hn : D.Normal b (.cons s t)) (v : D.NF b) :
    ¬Block s ((⟨.cons s t, hn⟩ : D.NF b) * v).val ↔
      RDiv (D.old b b) ((⟨t, hn.1⟩ : D.NF b) * v) := by
  classical
  change ¬Block s (D.push b s (D.eval b t v.val)) ↔ _
  rw [D.push_block, not_not]
  exact D.hasB_iff b ((⟨t, hn.1⟩ : D.NF b) * v)

theorem suffix_intersection (C : D.ConeData) (J : ConditionalJoins M)
    (b : M) (Y : D.NF b) (hf : ¬D.HasB b Y.val)
    (ih : ∀ s, Block s Y.val → D.ExitAlternative b s Y) :
    (∀ z : D.NF b, ¬(RDiv Y z ∧ RDiv (D.old b b) z)) ∨
      ∃ z c u, Y * D.old b c = D.old b z ∧ b * u = z ∧
        RJoin Y (D.old b b) (D.old b z) := by
  classical
  rcases Y with ⟨Y, hn⟩
  cases Y with
  | old a =>
    rcases D.old_intersection C J b a b with h | h
    · exact Or.inl h
    · rcases h with ⟨z, c, u, hc, hu, hj⟩
      exact Or.inr ⟨z, c, u, by change D.old b (a * c) = D.old b z; rw [hc], hu, hj⟩
  | cons s t =>
    let Y : D.NF b := ⟨.cons s t, hn⟩
    have hbaway : ∀ z : D.NF b, RDiv (D.old b b) z → ¬Block s z.val := by
      intro z hz hs
      apply hf
      apply (D.hasB_cons b s t).2
      exact (D.old_div_block b b s z hs).1 hz
    rcases ih s ⟨t, rfl⟩ with hall | ⟨g, c, gate⟩
    · apply Or.inl
      rintro z ⟨⟨v, rfl⟩, hz⟩
      exact hbaway _ hz (hall v)
    · rcases D.old_intersection C J b g b with hempty | hj
      · apply Or.inl
        rintro z ⟨⟨v, rfl⟩, hz⟩
        exact hempty _ ⟨gate.cover v (hbaway _ hz), hz⟩
      · rcases hj with ⟨z, q, u, hq, hu, hj⟩
        have hreach : Y * D.old b (c * q) = D.old b z := by
          rw [map_mul, ←mul_assoc, gate.reach, ←map_mul, hq]
        apply Or.inr
        refine ⟨z, c * q, u, hreach, hu, ?_⟩
        intro Z
        constructor
        · rintro ⟨⟨v, hv⟩, hz⟩
          have hg : RDiv (D.old b g) Z := by
            rw [←hv]
            exact gate.cover v (by rw [hv]; exact hbaway Z hz)
          exact (hj Z).1 ⟨hg, hz⟩
        · intro hz
          have hyz : RDiv Y (D.old b z) := ⟨D.old b (c * q), hreach⟩
          have hbz : RDiv (D.old b b) (D.old b z) :=
            (D.old_div_old b b z).2 ⟨u, hu⟩
          exact ⟨div_trans hyz hz, div_trans hbz hz⟩

theorem all_exits (C : D.ConeData) (J : ConditionalJoins M)
    (b : M) (x : Word M S) (hn : D.Normal b x) :
    ∀ s, Block s x → D.ExitAlternative b s ⟨x, hn⟩ := by
  classical
  induction x with
  | old a =>
    rintro s ⟨t, ht⟩
    cases ht
  | cons s t ih =>
    rintro q ⟨r, hr⟩
    have hsq := (Word.cons.inj hr).1
    subst q
    let Y : D.NF b := ⟨t, hn.1⟩
    let X : D.NF b := ⟨.cons s t, hn⟩
    have hXY : X = D.letter b s * Y := D.nf_cons b s Y hn.2
    rcases D.suffix_intersection C J b Y hn.2 (ih hn.1) with hempty | hj
    · apply Or.inl
      intro v
      by_contra hout
      exact hempty (Y * v) ⟨⟨v, rfl⟩, (D.exit_iff b s t hn v).1 hout⟩
    · rcases hj with ⟨z, c, u, hc, hu, hj⟩
      let g := D.h s * u
      have hsz : D.letter b s * D.old b z = D.old b g := by
        rw [←hu, map_mul, ←mul_assoc, D.letter_b, ←map_mul]
      have hreach : X * D.old b c = D.old b g := by
        rw [hXY, mul_assoc, hc, hsz]
      apply Or.inr
      refine ⟨g, c, hreach, D.gate_away b s u, ?_⟩
      intro v hout
      have hb : RDiv (D.old b b) (Y * v) := (D.exit_iff b s t hn v).1 hout
      rcases (hj (Y * v)).1 ⟨⟨v, rfl⟩, hb⟩ with ⟨r, hr⟩
      refine ⟨r, ?_⟩
      calc
        D.old b g * r = (D.letter b s * D.old b z) * r := by rw [hsz]
        _ = D.letter b s * (Y * v) := by rw [mul_assoc, hr]
        _ = X * v := by rw [hXY, mul_assoc]

theorem gate_old_factor (b : M) (x : D.NF b) (s : S) (hx : Block s x.val)
    (g c : M) (gate : D.ExitGate b s x g c) (d : M)
    (hd : RDiv (D.old b g) (x * D.old b d)) :
    ∃ a, x * D.old b d = D.old b a := by
  rcases D.append_old_shape b x.val x.property d with ho | hh
  · rcases ho with ⟨a, ha⟩
    exact ⟨a, Subtype.ext ha⟩
  · rcases hh with ⟨q, t, v, ht, hv⟩
    rcases hx with ⟨r, hr⟩
    have hqs : q = s := (Word.cons.inj (ht.symm.trans hr)).1
    apply False.elim
    apply gate.away _ hd
    refine ⟨v, ?_⟩
    change D.eval b x.val (.old d) = .cons s v
    rw [hv, hqs]

theorem gate_core (C : D.ConeData) (J : ConditionalJoins M) (b : M)
    (x : D.NF b) (hnew : ¬∃ a, x = D.old b a)
    (hm : ∃ a, RDiv x (D.old b a)) :
    ∃ g c, x * D.old b c = D.old b g ∧
      (∀ a, RDiv x (D.old b a) → RDiv g a) ∧
      (∀ d, RDiv (D.old b g) (x * D.old b d) →
        ∃ a, x * D.old b d = D.old b a) := by
  rcases x with ⟨x, hn⟩
  cases x with
  | old a => exact False.elim (hnew ⟨a, rfl⟩)
  | cons s t =>
    let X : D.NF b := ⟨.cons s t, hn⟩
    rcases D.all_exits C J b (.cons s t) hn s ⟨t, rfl⟩ with hall | ⟨g, c, gate⟩
    · rcases hm with ⟨a, v, hv⟩
      have hh := hall v
      rw [hv] at hh
      rcases hh with ⟨r, hr⟩
      cases hr
    · refine ⟨g, c, gate.reach, ?_, ?_⟩
      · rintro a ⟨v, hv⟩
        apply (D.old_div_old b g a).1
        rw [←hv]
        apply gate.cover v
        rw [hv]
        rintro ⟨r, hr⟩
        cases hr
      · exact fun d hd => D.gate_old_factor b X s ⟨t, rfl⟩ g c gate d hd

omit [Monoid M] in
theorem block_head {s t : S} {x : Word M S} (hs : Block s x) (ht : Block t x) :
    s = t := by
  rcases hs with ⟨u, hu⟩
  rcases ht with ⟨v, hv⟩
  exact (Word.cons.inj (hu.symm.trans hv)).1

theorem old_pair (C : D.ConeData) (J : ConditionalJoins M) (b x y : M) :
    PrincipalPair (D.old b x) (D.old b y) := by
  rcases D.old_intersection C J b x y with hn | ⟨g, _, _, _, _, hg⟩
  · exact Or.inl (fun ⟨z, hz⟩ => hn z hz)
  · exact Or.inr ⟨D.old b g, hg⟩

theorem old_new_pair (C : D.ConeData) (J : ConditionalJoins M)
    (b a : M) (y : D.NF b) (s : S) (hy : Block s y.val) :
    PrincipalPair (D.old b a) y := by
  classical
  by_cases hay : RDiv (D.old b a) y
  · exact Or.inr ⟨y, join_of_div hay⟩
  have away : ∀ z : D.NF b, RDiv (D.old b a) z → ¬Block s z.val := by
    intro z hz hs
    exact hay ((D.old_div_block b a s y hy).2 ((D.old_div_block b a s z hs).1 hz))
  rcases D.all_exits C J b y.val y.property s hy with hall | ⟨g, c, gate⟩
  · apply Or.inl
    rintro ⟨z, ha, ⟨v, hv⟩⟩
    exact away z ha (hv ▸ hall v)
  · apply pair_transfer (a := D.old b a) (b := D.old b g)
    · intro z
      constructor
      · rintro ⟨ha, ⟨v, hv⟩⟩
        have hg := gate.cover v (by rw [hv]; exact away z ha)
        exact ⟨ha, hv ▸ hg⟩
      · rintro ⟨ha, hg⟩
        exact ⟨ha, div_trans ⟨D.old b c, gate.reach⟩ hg⟩
    · exact D.old_pair C J b a g

theorem other_enters (C : D.ConeData) (J : ConditionalJoins M)
    (b : M) (x y : D.NF b) (s t : S) (hx : Block s x.val)
    (hy : Block t y.val) (hst : s ≠ t) (z : D.NF b)
    (hyz : RDiv y z) (hz : Block s z.val) : RDiv y x := by
  rcases hyz with ⟨v, hv⟩
  have hnot : ¬Block t (y * v).val := by
    intro ht
    have hs : Block s (y * v).val := hv ▸ hz
    exact hst (block_head hs ht)
  rcases D.all_exits C J b y.val y.property t hy with hall | ⟨g, c, gate⟩
  · exact False.elim (hnot (hall v))
  · have hg : RDiv (D.old b g) z := hv ▸ gate.cover v hnot
    have hgx : RDiv (D.old b g) x :=
      (D.old_div_block b g s x hx).2 ((D.old_div_block b g s z hz).1 hg)
    exact div_trans ⟨D.old b c, gate.reach⟩ hgx

def depth : Word M S → ℕ
  | .old _ => 0
  | .cons _ t => depth t + 1

theorem conditional_joins (C : D.ConeData) (J : ConditionalJoins M) (b : M) :
    ConditionalJoins (D.NF b) := by
  classical
  have allpairs : ∀ n, ∀ x y : D.NF b,
      depth x.val + depth y.val ≤ n → PrincipalPair x y := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
      rintro ⟨x, hx⟩ ⟨y, hy⟩ hdepth
      cases x with
      | old a =>
        cases y with
        | old c => exact D.old_pair C J b a c
        | cons t v => exact D.old_new_pair C J b a ⟨.cons t v, hy⟩ t ⟨v, rfl⟩
      | cons s t =>
        cases y with
        | old a =>
          exact pair_swap (D.old_new_pair C J b a ⟨.cons s t, hx⟩ s ⟨t, rfl⟩)
        | cons q v =>
          let X : D.NF b := ⟨.cons s t, hx⟩
          let Y : D.NF b := ⟨.cons q v, hy⟩
          by_cases hsq : s = q
          · subst q
            have hn : depth t + depth v < n := by
              change (depth t + 1) + (depth v + 1) ≤ n at hdepth
              omega
            have ht := ih (depth t + depth v) hn
              (⟨t, hx.1⟩ : D.NF b) (⟨v, hy.1⟩ : D.NF b) le_rfl
            have hp := pair_left (D.nf_lc b) (D.letter b s) ht
            rw [←D.nf_cons b s ⟨t, hx.1⟩ hx.2, ←D.nf_cons b s ⟨v, hy.1⟩ hy.2] at hp
            exact hp
          · by_cases hxy : RDiv X Y
            · exact Or.inr ⟨Y, join_of_div hxy⟩
            by_cases hyx : RDiv Y X
            · exact pair_swap (Or.inr ⟨X, join_of_div hyx⟩)
            have hout : ∀ z : D.NF b, (RDiv X z ∧ RDiv Y z) →
                ¬Block s z.val ∧ ¬Block q z.val := by
              intro z hz
              constructor
              · intro hs
                exact hyx (D.other_enters C J b X Y s q ⟨t, rfl⟩ ⟨v, rfl⟩ hsq z hz.2 hs)
              · intro hq
                exact hxy (D.other_enters C J b Y X q s ⟨v, rfl⟩ ⟨t, rfl⟩
                  (Ne.symm hsq) z hz.1 hq)
            rcases D.all_exits C J b X.val X.property s ⟨t, rfl⟩ with hall | ⟨gx, cx, ex⟩
            · apply Or.inl
              rintro ⟨z, hz⟩
              rcases hz.1 with ⟨u, hu⟩
              exact (hout z hz).1 (hu ▸ hall u)
            rcases D.all_exits C J b Y.val Y.property q ⟨v, rfl⟩ with hall | ⟨gy, cy, ey⟩
            · apply Or.inl
              rintro ⟨z, hz⟩
              rcases hz.2 with ⟨u, hu⟩
              exact (hout z hz).2 (hu ▸ hall u)
            apply pair_transfer (a := D.old b gx) (b := D.old b gy)
            · intro z
              constructor
              · intro hz
                rcases hz.1 with ⟨ux, hux⟩
                rcases hz.2 with ⟨uy, huy⟩
                exact ⟨hux ▸ ex.cover ux (by rw [hux]; exact (hout z hz).1),
                  huy ▸ ey.cover uy (by rw [huy]; exact (hout z hz).2)⟩
              · intro hz
                exact ⟨div_trans ⟨D.old b cx, ex.reach⟩ hz.1,
                  div_trans ⟨D.old b cy, ey.reach⟩ hz.2⟩
            · exact D.old_pair C J b gx gy
  intro x y hm
  rcases allpairs (depth x.val + depth y.val) x y le_rfl with hn | hj
  · exact False.elim (hn hm)
  · exact hj

end ActData

namespace Source

variable {M : Type u} [Monoid M]

local instance : FunLike (M → M) M M where
  coe := id
  coe_injective := fun _ _ h => h

def product (d : ℕ → M) (i : ℕ) : ℕ → M
  | 0 => 1
  | n + 1 => product d i n * d (i + n)

theorem product_add (d : ℕ → M) (i n k : ℕ) :
    product d i (n + k) = product d i n * product d (i + n) k := by
  induction k with
  | zero => simp [product]
  | succ k ih => simp [product, ih, Nat.add_assoc, mul_assoc]

def transition (d : ℕ → M) (i j : ℕ) := product d i (j - i)

@[simp] theorem transition_self (d : ℕ → M) (i : ℕ) :
    transition d i i = 1 := by simp [transition, product]

theorem transition_mul (d : ℕ → M) {i j k : ℕ} (hij : i ≤ j) (hjk : j ≤ k) :
    transition d i j * transition d j k = transition d i k := by
  have h1 : i + (j - i) = j := by omega
  have h2 : (j - i) + (k - j) = k - i := by omega
  simpa only [h1, h2, transition] using (product_add d i (j - i) (k - j)).symm

def trans (d : ℕ → M) (i j : ℕ) (_h : i ≤ j) (x : M) := x * transition d i j

instance system (d : ℕ → M) :
    DirectedSystem (fun _ : ℕ => M) (fun {i j} h => DFunLike.coe (trans d i j h)) where
  map_self {i} x := by
    change x * transition d i i = x
    simp
  map_map {k j i} hij hjk x := by
    change (x * transition d i j) * transition d j k = x * transition d i k
    rw [mul_assoc, transition_mul d hij hjk]

abbrev Letters (d : ℕ → M) := DirectLimit (fun _ : ℕ => M) (trans d)

def rep (d : ℕ → M) (i : ℕ) (x : M) : Letters d := ⟦⟨i, x⟩⟧

def act (d : ℕ → M) (a : M) : Letters d → Letters d :=
  DirectLimit.map (trans d) (trans d) (fun _ x => a * x)
    (fun _ _ _ x => mul_assoc a x _)

@[simp] theorem act_rep (d : ℕ → M) (a x : M) (i : ℕ) :
    act d a (rep d i x) = rep d i (a * x) := rfl

theorem act_one (d : ℕ → M) (s : Letters d) : act d 1 s = s := by
  refine DirectLimit.induction _ (fun i x => ?_) s
  change rep d i (1 * x) = rep d i x
  rw [one_mul]

theorem act_mul (d : ℕ → M) (a b : M) (s : Letters d) :
    act d (a * b) s = act d a (act d b s) := by
  refine DirectLimit.induction _ (fun i x => ?_) s
  change rep d i ((a * b) * x) = rep d i (a * (b * x))
  rw [mul_assoc]

theorem act_inj (lc : ∀ a x y : M, a * x = a * y → x = y)
    (d : ℕ → M) (a : M) : Function.Injective (act d a) := by
  intro s t
  refine Quotient.inductionOn₂ s t ?_
  rintro ⟨i, x⟩ ⟨j, y⟩ he
  change rep d i (a * x) = rep d j (a * y) at he
  rcases Quotient.exact he with ⟨k, hik, hjk, hk⟩
  apply Quotient.sound
  refine ⟨k, hik, hjk, ?_⟩
  change (a * x) * transition d i k = (a * y) * transition d j k at hk
  change x * transition d i k = y * transition d j k
  exact lc a _ _ (by simpa only [mul_assoc] using hk)

theorem product_c (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (i n : ℕ) : product d i n * c (i + n) = c i := by
  induction n with
  | zero => simp [product]
  | succ n ih =>
    rw [product, mul_assoc, Nat.add_succ, rel]
    exact ih

def k (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i) : Letters d → M :=
  DirectLimit.lift (trans d) (fun i x => x * c i) (by
    intro i j hij x
    change x * c i = (x * product d i (j - i)) * c j
    have ht := product_c d c rel i (j - i)
    have hi : i + (j - i) = j := by omega
    rw [hi] at ht
    rw [mul_assoc, ht])

@[simp] theorem k_rep (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (i : ℕ) (x : M) : k d c rel (rep d i x) = x * c i := rfl

theorem k_act (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (a : M) (s : Letters d) : k d c rel (act d a s) = a * k d c rel s := by
  refine DirectLimit.induction _ (fun i x => ?_) s
  change (a * x) * c i = a * (x * c i)
  exact mul_assoc _ _ _

def data (lc : ∀ a x y : M, a * x = a * y → x = y)
    (hc : Conical M) (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (e : M) (he : e ≠ 1) : ActData M (Letters d) where
  lc := lc
  act := act d
  act_one := act_one d
  act_mul := act_mul d
  act_inj := act_inj lc d
  h s := k d c rel s * e
  h_act a s := by rw [k_act]; exact mul_assoc _ _ _
  separation s t := by
    intro hh
    have hk := congrArg (k d c rel) hh
    rw [k_act] at hk
    have hh1 : e * k d c rel t = 1 := lc (k d c rel s) _ _ (by
      simpa only [mul_assoc, mul_one] using hk)
    exact he (hc _ _ hh1).1

theorem common_stage (d : ℕ → M) (x y : M) (s : Letters d)
    (hx : ∃ u, act d x u = s) (hy : ∃ v, act d y v = s) :
    ∃ i z, RDiv x z ∧ RDiv y z ∧ s = rep d i z := by
  rcases hx with ⟨u, hu⟩
  rcases hy with ⟨v, hv⟩
  rcases DirectLimit.exists_eq_mk (trans d) u with ⟨i, a, rfl⟩
  rcases DirectLimit.exists_eq_mk (trans d) v with ⟨j, b, rfl⟩
  have hh : rep d i (x * a) = rep d j (y * b) := hu.trans hv.symm
  rcases Quotient.exact hh with ⟨k, hik, hjk, hk⟩
  refine ⟨k, (x * a) * transition d i k, ⟨a * transition d i k, ?_⟩,
    ⟨b * transition d j k, ?_⟩, ?_⟩
  · exact (mul_assoc _ _ _).symm
  · exact (mul_assoc _ _ _).symm.trans hk.symm
  · have hm : rep d i (x * a) = rep d k ((x * a) * transition d i k) := by
      apply Quotient.sound
      refine ⟨k, hik, le_rfl, ?_⟩
      change (x * a) * transition d i k =
        ((x * a) * transition d i k) * transition d k k
      rw [transition_self, mul_one]
    exact hu.symm.trans hm

theorem cone_data (lc : ∀ a x y : M, a * x = a * y → x = y)
    (hc : Conical M) (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (e : M) (he : e ≠ 1) : (data lc hc d c rel e he).ConeData := by
  let D := data lc hc d c rel e he
  constructor
  · intro x y s hx hy
    rcases common_stage d x y s hx hy with ⟨i, z, hzx, hzy, _⟩
    exact ⟨z, hzx, hzy⟩
  · intro x y g hj s
    constructor
    · rintro ⟨hx, hy⟩
      rcases common_stage d x y s hx hy with ⟨i, z, hzx, hzy, hs⟩
      rcases (hj z).1 ⟨hzx, hzy⟩ with ⟨r, hr⟩
      refine ⟨rep d i r, ?_⟩
      change act d g (rep d i r) = s
      rw [act_rep, hr, ←hs]
    · rintro ⟨t, ht⟩
      rcases (hj g).2 ⟨1, mul_one g⟩ with ⟨⟨u, hu⟩, ⟨v, hv⟩⟩
      constructor
      · exact ⟨D.act u t, (D.act_mul x u t).symm.trans ((congrArg (fun a => D.act a t) hu).trans ht)⟩
      · exact ⟨D.act v t, (D.act_mul y v t).symm.trans ((congrArg (fun a => D.act a t) hv).trans ht)⟩

@[simp] theorem transition_succ (d : ℕ → M) (i : ℕ) :
    transition d i (i + 1) = d i := by simp [transition, product]

theorem rep_step (d : ℕ → M) (i : ℕ) :
    rep d i 1 = rep d (i + 1) (d i) := by
  apply Quotient.sound
  refine ⟨i + 1, Nat.le_succ i, le_rfl, ?_⟩
  change 1 * transition d i (i + 1) = d i * transition d (i + 1) (i + 1)
  simp

theorem coherence (lc : ∀ a x y : M, a * x = a * y → x = y)
    (a : M) (n d c : ℕ → M) (step : ∀ i, n i * d i = n (i + 1))
    (finish : ∀ i, n i * c i = a) : ∀ i, d i * c (i + 1) = c i := by
  intro i
  apply lc (n i)
  rw [←mul_assoc, step, finish, finish]

theorem algebra_core (lc : ∀ a x y : M, a * x = a * y → x = y)
    (hc : Conical M) (J : ConditionalJoins M) (d c : ℕ → M)
    (rel : ∀ i, d i * c (i + 1) = c i) (b e : M) (he : e ≠ 1) :
    let D := data lc hc d c rel e he
    (∀ a x y : D.NF b, a * x = a * y → x = y) ∧
      Conical (D.NF b) ∧ ConditionalJoins (D.NF b) ∧
      Conservative (D.old b) ∧ GateCore (D.old b) := by
  let D := data lc hc d c rel e he
  have C : D.ConeData := cone_data lc hc d c rel e he
  refine ⟨D.nf_lc b, D.nf_conical hc b, D.conditional_joins C J b, ?_, D.gate_core C J b⟩
  refine ⟨D.old_inj b, D.old_factor b, D.old_join C b, ?_⟩
  rintro x y hn ⟨z, hx, hy⟩
  exact hn (D.old_common C b x y z hx hy)

theorem probe_algebra_core (lc : ∀ a x y : M, a * x = a * y → x = y)
    (hc : Conical M) (J : ConditionalJoins M) (a b e : M)
    (_hb : b ≠ 1) (he : e ≠ 1) (n d c : ℕ → M) (_hn : n 0 = 1)
    (step : ∀ i, n i * d i = n (i + 1)) (finish : ∀ i, n i * c i = a) :
    let D := data lc hc d c (coherence lc a n d c step finish) e he
    (∀ a x y : D.NF b, a * x = a * y → x = y) ∧
      Conical (D.NF b) ∧ ConditionalJoins (D.NF b) ∧
      Conservative (D.old b) ∧ GateCore (D.old b) :=
  algebra_core lc hc J d c (coherence lc a n d c step finish) b e he

section Presentation

variable (lc : ∀ a x y : M, a * x = a * y → x = y)
variable (hc : Conical M) (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
variable (b e : M) (he : e ≠ 1)

noncomputable def p (i : ℕ) : (data lc hc d c rel e he).NF b :=
  (data lc hc d c rel e he).letter b (rep d i 1)

theorem p_step (i : ℕ) :
    p lc hc d c rel b e he i =
      (data lc hc d c rel e he).old b (d i) * p lc hc d c rel b e he (i + 1) := by
  let D := data lc hc d c rel e he
  change D.letter b (rep d i 1) = D.old b (d i) * D.letter b (rep d (i + 1) 1)
  rw [D.old_letter]
  change D.letter b (rep d i 1) = D.letter b (rep d (i + 1) (d i * 1))
  rw [mul_one, rep_step]

theorem p_close (i : ℕ) :
    p lc hc d c rel b e he i * (data lc hc d c rel e he).old b b =
      (data lc hc d c rel e he).old b (c i * e) := by
  let D := data lc hc d c rel e he
  change D.letter b (rep d i 1) * D.old b b = D.old b (c i * e)
  rw [D.letter_b]
  change D.old b ((1 * c i) * e) = _
  rw [one_mul]

end Presentation

section Target

variable {N : Type w} [Monoid N]

theorem q_stage (d : ℕ → M) (f : M →* N) (q : ℕ → N)
    (qt : ∀ i, q i = f (d i) * q (i + 1)) (i n : ℕ) :
    q i = f (product d i n) * q (i + n) := by
  induction n with
  | zero => simp [product]
  | succ n ih =>
    calc
      q i = f (product d i n) * q (i + n) := ih
      _ = f (product d i n) * (f (d (i + n)) * q ((i + n) + 1)) := by
        conv_lhs => rw [qt (i + n)]
      _ = f (product d i (n + 1)) * q (i + (n + 1)) := by
        simp only [product, map_mul, mul_assoc, Nat.add_succ, Nat.add_zero]

def qLetter (d : ℕ → M) (f : M →* N) (q : ℕ → N)
    (qt : ∀ i, q i = f (d i) * q (i + 1)) : Letters d → N :=
  DirectLimit.lift (trans d) (fun i x => f x * q i) (by
    intro i j hij x
    change f x * q i = f (x * product d i (j - i)) * q j
    have hq := q_stage d f q qt i (j - i)
    have hi : i + (j - i) = j := by omega
    rw [hi] at hq
    rw [map_mul, mul_assoc, ←hq])

theorem qLetter_act (d : ℕ → M) (f : M →* N) (q : ℕ → N)
    (qt : ∀ i, q i = f (d i) * q (i + 1)) (a : M) (s : Letters d) :
    qLetter d f q qt (act d a s) = f a * qLetter d f q qt s := by
  refine DirectLimit.induction _ (fun i x => ?_) s
  change f (a * x) * q i = f a * (f x * q i)
  rw [map_mul, mul_assoc]

theorem qLetter_close (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (b e : M) (f : M →* N) (q : ℕ → N)
    (qt : ∀ i, q i = f (d i) * q (i + 1))
    (qc : ∀ i, q i * f b = f (c i * e)) (s : Letters d) :
    qLetter d f q qt s * f b = f (k d c rel s * e) := by
  refine DirectLimit.induction _ (fun i x => ?_) s
  change (f x * q i) * f b = f ((x * c i) * e)
  rw [mul_assoc, qc, ←map_mul, mul_assoc]

theorem presentation_universal
    (lc : ∀ a x y : M, a * x = a * y → x = y)
    (hc : Conical M) (d c : ℕ → M) (rel : ∀ i, d i * c (i + 1) = c i)
    (b e : M) (he : e ≠ 1) (f : M →* N) (q : ℕ → N)
    (qt : ∀ i, q i = f (d i) * q (i + 1))
    (qc : ∀ i, q i * f b = f (c i * e)) :
    ∃! F : (data lc hc d c rel e he).NF b →* N,
      (∀ a, F ((data lc hc d c rel e he).old b a) = f a) ∧
      (∀ i, F (p lc hc d c rel b e he i) = q i) := by
  let D := data lc hc d c rel e he
  let Q := qLetter d f q qt
  have qa : ∀ a s, Q (D.act a s) = f a * Q s := qLetter_act d f q qt
  have qb : ∀ s, Q s * f b = f (D.h s) := qLetter_close d c rel b e f q qt qc
  let F := D.lift f Q b qa qb
  refine ⟨F, ⟨D.lift_old f Q b qa qb, ?_⟩, ?_⟩
  · intro i
    change D.lift f Q b qa qb (D.letter b (rep d i 1)) = q i
    rw [D.lift_letter]
    change f 1 * q i = q i
    rw [map_one, one_mul]
  · intro G hG
    apply D.lift_unique f Q b qa qb G hG.1
    intro s
    refine DirectLimit.induction _ (fun i x => ?_) s
    have hp : D.letter b (rep d i x) = D.old b x * p lc hc d c rel b e he i := by
      change D.letter b (rep d i x) = D.old b x * D.letter b (rep d i 1)
      rw [D.old_letter]
      change D.letter b (rep d i x) = D.letter b (rep d i (x * 1))
      rw [mul_one]
    change G (D.letter b (rep d i x)) = f x * q i
    rw [hp, G.map_mul, hG.1, hG.2]

end Target

end Source

#print axioms Source.probe_algebra_core
#print axioms Source.presentation_universal

end ProbeAudit
