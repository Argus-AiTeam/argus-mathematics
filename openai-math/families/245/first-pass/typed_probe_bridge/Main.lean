import Lean

namespace TypedProbe

universe u

inductive Tag where
  | G | C0 | CL | CR | EL | ER | R | pt
  deriving DecidableEq, Repr

inductive Side where
  | left | right
  deriving DecidableEq

def classTag : Side → Tag
  | .left => .CL
  | .right => .CR

def edgeTag : Side → Tag
  | .left => .EL
  | .right => .ER

structure Carriers (A : Type u) where
  L : A → Type u
  PL : A → Type u
  BP : A → Type u
  M : A → Type u
  F : A → Type u
  Single : A → Type u
  Fun : A → Type u
  Packed : A → Type u
  User : A → Type u
  V : Type u
  X : Type u
  PX : Type u
  U : Type u

inductive Callback (Q I : Type u) where
  | user : Q → Callback Q I
  | probe : I → Callback Q I

inductive PredicateCode (Q I M L P V : Type u) where
  | callback : Callback Q I → M → PredicateCode Q I M L P V
  | class : M → L → PredicateCode Q I M L P V
  | union : M → L → L → PredicateCode Q I M L P V
  | pair : M → P → L → PredicateCode Q I M L P V
  | part : M → V → PredicateCode Q I M L P V

inductive FCode (Q I M S : Type u) where
  | inner : Callback Q I → M → FCode Q I M S
  | outer : Callback Q I → S → FCode Q I M S

inductive SingleCode (M L : Type u) where
  | bundle : M → L → SingleCode M L

inductive XCode (M L : Type u) where
  | lift : M → L → XCode M L

inductive SendCode (Q I S : Type u) where
  | access : Callback Q I → S → SendCode Q I S

structure Primitives {A : Type u} (c : Carriers A) where
  roundL : (a : A) → c.L a → c.L a
  roundX : c.X → c.X
  evalL : (a : A) → c.PL a → c.L a → Prop
  evalX : c.PX → c.X → Prop
  observe : c.X → c.V → Prop
  query : (a : A) → Tag → c.M a → c.PL a → Prop
  flag : (a : A) → c.M a → Prop
  dummy : (a : A) → c.M a
  point : (a : A) → c.L a → c.M a
  evalF : (a : A) → c.F a → c.M a → Prop
  evalSingle : (a : A) → c.Single a → c.F a → Prop
  userFormula : (a : A) → c.User a → c.M a → c.L a → Prop
  mkPL : (a : A) →
    PredicateCode (c.User a) c.PX (c.M a) (c.L a) (c.PL a) c.V → c.PL a
  mkF : (a : A) → FCode (c.User a) c.PX (c.M a) (c.Single a) → c.F a
  mkSingle : (a : A) → SingleCode (c.M a) (c.L a) → c.Single a
  mkX : (a : A) → XCode (c.M a) (c.L a) → c.X
  compileZ : c.PX → c.V
  compileW : (a : A) → c.PX → c.Fun a
  applyAt : c.V → (a : A) → c.Packed a
  pack : (a : A) → c.Fun a → c.Packed a
  applyW : (a : A) → c.Fun a → c.Single a → c.U
  use : (a : A) → c.Packed a → c.Single a → Prop
  send : (a : A) → SendCode (c.User a) c.PX (c.Single a) → c.U
  read : c.U → Prop

namespace Primitives

variable {A : Type u} {c : Carriers A} (p : Primitives c)

def gate (g h k : Prop) : Prop := (g ∧ h) ∨ (¬g ∧ k)
def bundle (a : A) (m : c.M a) (y : c.L a) : c.Single a :=
  p.mkSingle a (.bundle m y)
def inner (a : A) (q : Callback (c.User a) c.PX) (o : c.M a) : c.F a :=
  p.mkF a (.inner q o)
def outer (a : A) (q : Callback (c.User a) c.PX) (w : c.Single a) : c.F a :=
  p.mkF a (.outer q w)
def access (a : A) (w : c.Single a) (q : Callback (c.User a) c.PX) : Prop :=
  p.evalSingle a w (p.outer a q w)
def pred (a : A) (q : PredicateCode (c.User a) c.PX
    (c.M a) (c.L a) (c.PL a) c.V) : c.PL a := p.mkPL a q
def part (a : A) (m : c.M a) (v : c.V) : c.PL a :=
  p.pred a (.part m v)
def classCode (a : A) (m : c.M a) (y : c.L a) : c.PL a :=
  p.pred a (.class m y)
def unionCode (a : A) (m : c.M a) (y z : c.L a) : c.PL a :=
  p.pred a (.union m y z)
def pair (a : A) (m : c.M a) (P : c.PL a) (y : c.L a) : c.PL a :=
  p.pred a (.pair m P y)
def sb (a : A) (v : c.V) (m : c.M a) (y : c.L a) : Prop :=
  p.query a .R m (p.pair a m (p.part a m v) y)
def lift (a : A) (m : c.M a) (y : c.L a) : c.X :=
  p.mkX a (.lift m y)
def probe (i : c.PX) : c.V := p.compileZ i
def diamond (a : A) (v : c.V) (m : c.M a) (y : c.L a) : Prop :=
  p.use a (p.applyAt v a) (p.bundle a m y)
def ApproxL (a : A) (P Q : c.PL a) : Prop :=
  ∀ y, p.evalL a P y ↔ p.evalL a Q y
def ApproxX (i j : c.PX) : Prop := ∀ x, p.evalX i x ↔ p.evalX j x
def Good (a : A) (m : c.M a) (P : c.PL a) : Prop :=
  (∀ y, p.evalL a P y ↔ p.evalL a P (p.roundL a y)) ∧ p.query a .G m P
def Rel (a : A) (m : c.M a) (y z : c.L a) : Prop :=
  ∀ P, p.Good a m P → (p.evalL a P y ↔ p.evalL a P z)
def Adm (a : A) (m : c.M a) : Prop :=
  ¬p.flag a m ∧
    ∀ t : Tag, t ≠ .pt → ∀ P Q, p.ApproxL a P Q →
      (p.query a t m P ↔ p.query a t m Q)
def isTag (a : A) (m : c.M a) (t : Tag) (y : c.L a) : Prop :=
  p.query a t m (p.classCode a m y)
def tagged (a : A) (m : c.M a) (t : Side) (y z : c.L a) : Prop :=
  p.isTag a m .C0 y ∧ p.isTag a m (classTag t) z ∧
    p.query a (edgeTag t) m (p.unionCode a m y z)
def form (a : A) (m : c.M a) (P : c.PL a) (y z : c.L a) : Prop :=
  (∃ w, p.tagged a m .left w z ∧ p.evalL a P w) ∨ p.tagged a m .right y z
def callbackFormula (a : A) (q : Callback (c.User a) c.PX)
    (m : c.M a) (y : c.L a) : Prop :=
  match q with
  | .user t => p.userFormula a t m y
  | .probe i => p.evalX i (p.lift a m y)
def predicateFormula (a : A)
    (q : PredicateCode (c.User a) c.PX (c.M a) (c.L a) (c.PL a) c.V)
    (w : c.L a) : Prop :=
  match q with
  | .callback q m => p.callbackFormula a q m w
  | .class m y => p.Rel a m w y
  | .union m y z => p.Rel a m w y ∨ p.Rel a m w z
  | .pair m P y => p.form a m P y w
  | .part m v => p.diamond a v m w
def fFormula (a : A) (q : FCode (c.User a) c.PX (c.M a) (c.Single a))
    (o : c.M a) : Prop :=
  match q with
  | .inner cb m =>
      gate (p.flag a o) False
        (p.query a .pt o (p.pred a (.callback cb m)))
  | .outer cb w =>
      gate (p.flag a o) True (p.evalSingle a w (p.inner a cb o))
def singleFormula (a : A) (q : SingleCode (c.M a) (c.L a))
    (f : c.F a) : Prop :=
  match q with
  | .bundle m y =>
      gate (p.evalF a f (p.dummy a))
        (p.evalF a f m) (p.evalF a f (p.point a y))
def xFormula (a : A) (q : XCode (c.M a) (c.L a)) (v : c.V) : Prop :=
  match q with
  | .lift m y => p.sb a v m y
def sendFormula (a : A) (q : SendCode (c.User a) c.PX (c.Single a)) : Prop :=
  match q with
  | .access cb w => p.access a w cb
def le (i : c.PX) (x : c.X) : Prop := p.observe x (p.probe i)
def Equiv (x y : c.X) : Prop := ∀ i, p.le i x ↔ p.le i y
def Valid (x : c.X) : Prop :=
  ∀ i j, p.ApproxX i j → (p.le i x ↔ p.le j x)
def Ext (i : c.PX) : Prop :=
  ∀ x y, p.Equiv x y → (p.evalX i x ↔ p.evalX i y)

end Primitives

structure PrimitiveLaws {A : Type u} {c : Carriers A} (p : Primitives c) : Prop where
  predicate_cancel : ∀ a q y,
    p.evalL a (p.mkPL a q) y ↔ p.predicateFormula a q (p.roundL a y)
  f_cancel : ∀ a q o, p.evalF a (p.mkF a q) o ↔ p.fFormula a q o
  single_cancel : ∀ a q f,
    p.evalSingle a (p.mkSingle a q) f ↔ p.singleFormula a q f
  x_cancel : ∀ a q v, p.observe (p.mkX a q) v ↔ p.xFormula a q v
  dummy_flag : ∀ a, p.flag a (p.dummy a)
  point_flag : ∀ a y, ¬p.flag a (p.point a y)
  point_query : ∀ a y P, p.query a .pt (p.point a y) P ↔ p.evalL a P y
  beta_z : ∀ a i, p.applyAt (p.compileZ i) a = p.pack a (p.compileW a i)
  beta_w : ∀ a i w,
    p.applyW a (p.compileW a i) w = p.send a (.access (.probe i) w)
  pack_use : ∀ a f w, p.use a (p.pack a f) w ↔ p.read (p.applyW a f w)
  read_send : ∀ a q, p.read (p.send a q) ↔ p.sendFormula a q
  round_observe : ∀ x v, p.observe (p.roundX x) v ↔ p.observe x v

variable {A : Type u} {c : Carriers A} (p : Primitives c)
  (h : PrimitiveLaws p)

theorem gate_true {g a b : Prop} (hg : g) :
    Primitives.gate g a b ↔ a :=
  ⟨fun z => z.elim And.right (fun z => False.elim (z.1 hg)),
    fun ha => Or.inl ⟨hg, ha⟩⟩

theorem gate_false {g a b : Prop} (hg : ¬g) :
    Primitives.gate g a b ↔ b :=
  ⟨fun z => z.elim (fun z => False.elim (hg z.1)) And.right,
    fun hb => Or.inr ⟨hg, hb⟩⟩

include h

theorem access_exact (a : A) (m : c.M a) (y : c.L a)
    (q : Callback (c.User a) c.PX) (dm : ¬p.flag a m) :
    p.access a (p.bundle a m y) q ↔ p.callbackFormula a q m (p.roundL a y) := by
  let w := p.bundle a m y
  have outerDummy : p.evalF a (p.outer a q w) (p.dummy a) := by
    apply (h.f_cancel a (.outer q w) (p.dummy a)).mpr
    exact (gate_true (h.dummy_flag a)).mpr True.intro
  have outerM : p.evalF a (p.outer a q w) m ↔
      p.evalSingle a w (p.inner a q m) :=
    (h.f_cancel a (.outer q w) m).trans (gate_false dm)
  have innerDummy : ¬p.evalF a (p.inner a q m) (p.dummy a) := by
    intro hf
    exact (gate_true (h.dummy_flag a)).mp
      ((h.f_cancel a (.inner q m) (p.dummy a)).mp hf)
  have innerPoint : p.evalF a (p.inner a q m) (p.point a y) ↔
      p.callbackFormula a q m (p.roundL a y) :=
    (h.f_cancel a (.inner q m) (p.point a y)).trans
      ((gate_false (h.point_flag a y)).trans
        ((h.point_query a y (p.pred a (.callback q m))).trans
          (h.predicate_cancel a (.callback q m) y)))
  have first : p.access a w q ↔ p.evalSingle a w (p.inner a q m) :=
    (h.single_cancel a (.bundle m y) (p.outer a q w)).trans
      ((gate_true outerDummy).trans outerM)
  have second : p.evalSingle a w (p.inner a q m) ↔
      p.callbackFormula a q m (p.roundL a y) :=
    (h.single_cancel a (.bundle m y) (p.inner a q m)).trans
      ((gate_false innerDummy).trans innerPoint)
  exact first.trans second

theorem raw_lift_cancel (a : A) (m : c.M a) (y : c.L a) (v : c.V) :
    p.observe (p.lift a m y) v ↔ p.sb a v m y :=
  h.x_cancel a (.lift m y) v

theorem probe_rounded_notD (a : A) (m : c.M a) (dm : ¬p.flag a m)
    (i : c.PX) (y : c.L a) :
    p.diamond a (p.probe i) m y ↔ p.evalX i (p.lift a m (p.roundL a y)) := by
  unfold Primitives.diamond Primitives.probe
  rw [h.beta_z]
  apply (h.pack_use a (p.compileW a i) (p.bundle a m y)).trans
  rw [h.beta_w]
  exact (h.read_send a (.access (.probe i) (p.bundle a m y))).trans
    (access_exact p h a m y (.probe i) dm)

theorem probe_rounded (a : A) (m : c.M a) (ad : p.Adm a m)
    (i : c.PX) (y : c.L a) :
    p.diamond a (p.probe i) m y ↔ p.evalX i (p.lift a m (p.roundL a y)) :=
  probe_rounded_notD p h a m ad.1 i y

omit h

theorem rel_refl (a : A) (m : c.M a) (y : c.L a) : p.Rel a m y y :=
  fun _ _ => Iff.rfl

theorem rel_symm (a : A) (m : c.M a) {y z : c.L a}
    (e : p.Rel a m y z) : p.Rel a m z y :=
  fun P g => (e P g).symm

theorem rel_trans (a : A) (m : c.M a) {y z w : c.L a}
    (e : p.Rel a m y z) (f : p.Rel a m z w) : p.Rel a m y w :=
  fun P g => (e P g).trans (f P g)

theorem round_rel (a : A) (m : c.M a) (y : c.L a) :
    p.Rel a m y (p.roundL a y) :=
  fun _ g => g.1 y

theorem rel_congr (a : A) (m : c.M a) {y y' z z' : c.L a}
    (e : p.Rel a m y y') (f : p.Rel a m z z') :
    p.Rel a m y z ↔ p.Rel a m y' z' := by
  constructor
  · intro r
    exact rel_trans p a m (rel_symm p a m e) (rel_trans p a m r f)
  · intro r
    exact rel_trans p a m e (rel_trans p a m r (rel_symm p a m f))

include h

theorem class_eval (a : A) (m : c.M a) (y w : c.L a) :
    p.evalL a (p.classCode a m y) w ↔ p.Rel a m w y :=
  (h.predicate_cancel a (.class m y) w).trans
    (rel_congr p a m (round_rel p a m w) (rel_refl p a m y)).symm

theorem union_eval (a : A) (m : c.M a) (y z w : c.L a) :
    p.evalL a (p.unionCode a m y z) w ↔
      (p.Rel a m w y ∨ p.Rel a m w z) := by
  apply (h.predicate_cancel a (.union m y z) w).trans
  exact or_congr
    (rel_congr p a m (round_rel p a m w) (rel_refl p a m y)).symm
    (rel_congr p a m (round_rel p a m w) (rel_refl p a m z)).symm

theorem class_congr (a : A) (m : c.M a) {y z : c.L a}
    (e : p.Rel a m y z) :
    p.ApproxL a (p.classCode a m y) (p.classCode a m z) := by
  intro w
  exact (class_eval p h a m y w).trans
    ((rel_congr p a m (rel_refl p a m w) e).trans
      (class_eval p h a m z w).symm)

theorem union_congr (a : A) (m : c.M a) {y y' z z' : c.L a}
    (e : p.Rel a m y y') (f : p.Rel a m z z') :
    p.ApproxL a (p.unionCode a m y z) (p.unionCode a m y' z') := by
  intro w
  exact (union_eval p h a m y z w).trans
    ((or_congr (rel_congr p a m (rel_refl p a m w) e)
      (rel_congr p a m (rel_refl p a m w) f)).trans
        (union_eval p h a m y' z' w).symm)

theorem isTag_congr (a : A) (m : c.M a) (ad : p.Adm a m)
    (t : Tag) (ht : t ≠ .pt) {y z : c.L a} (e : p.Rel a m y z) :
    p.isTag a m t y ↔ p.isTag a m t z :=
  ad.2 t ht _ _ (class_congr p h a m e)

theorem tagged_congr (a : A) (m : c.M a) (ad : p.Adm a m)
    (t : Side) {y y' z z' : c.L a}
    (e : p.Rel a m y y') (f : p.Rel a m z z') :
    p.tagged a m t y z ↔ p.tagged a m t y' z' := by
  have hc : classTag t ≠ .pt := by cases t <;> decide
  have he : edgeTag t ≠ .pt := by cases t <;> decide
  exact and_congr (isTag_congr p h a m ad .C0 (by decide) e)
    (and_congr (isTag_congr p h a m ad (classTag t) hc f)
      (ad.2 (edgeTag t) he _ _ (union_congr p h a m e f)))

theorem form_congr (a : A) (m : c.M a) (ad : p.Adm a m)
    {P P' : c.PL a} {y y' z z' : c.L a}
    (ep : p.ApproxL a P P') (ey : p.Rel a m y y') (ez : p.Rel a m z z') :
    p.form a m P y z ↔ p.form a m P' y' z' := by
  have left : (∃ w, p.tagged a m .left w z ∧ p.evalL a P w) ↔
      (∃ w, p.tagged a m .left w z' ∧ p.evalL a P' w) := by
    constructor
    · rintro ⟨w, hw, hp⟩
      exact ⟨w, (tagged_congr p h a m ad .left (rel_refl p a m w) ez).mp hw,
        (ep w).mp hp⟩
    · rintro ⟨w, hw, hp⟩
      exact ⟨w, (tagged_congr p h a m ad .left (rel_refl p a m w) ez).mpr hw,
        (ep w).mpr hp⟩
  exact or_congr left (tagged_congr p h a m ad .right ey ez)

theorem pair_eval (a : A) (m : c.M a) (ad : p.Adm a m)
    (P : c.PL a) (y z : c.L a) :
    p.evalL a (p.pair a m P y) z ↔ p.form a m P y z :=
  (h.predicate_cancel a (.pair m P y) z).trans
    (form_congr p h a m ad (fun _ => Iff.rfl)
      (rel_refl p a m y) (round_rel p a m z)).symm

theorem pair_congr (a : A) (m : c.M a) (ad : p.Adm a m)
    {P P' : c.PL a} {y y' : c.L a}
    (ep : p.ApproxL a P P') (ey : p.Rel a m y y') :
    p.ApproxL a (p.pair a m P y) (p.pair a m P' y') := by
  intro z
  exact (pair_eval p h a m ad P y z).trans
    ((form_congr p h a m ad ep ey (rel_refl p a m z)).trans
      (pair_eval p h a m ad P' y' z).symm)

theorem lift_congr (a : A) (m : c.M a) (ad : p.Adm a m)
    {y z : c.L a} (e : p.Rel a m y z) :
    p.Equiv (p.lift a m y) (p.lift a m z) := by
  intro i
  exact (raw_lift_cancel p h a m y (p.probe i)).trans
    ((ad.2 .R (by decide) _ _
      (pair_congr p h a m ad (fun _ => Iff.rfl) e)).trans
        (raw_lift_cancel p h a m z (p.probe i)).symm)

theorem part_probe_congr (a : A) (m : c.M a) (ad : p.Adm a m)
    {i j : c.PX} (e : p.ApproxX i j) :
    p.ApproxL a (p.part a m (p.probe i)) (p.part a m (p.probe j)) := by
  intro y
  exact (h.predicate_cancel a (.part m (p.probe i)) y).trans
    ((probe_rounded p h a m ad i (p.roundL a y)).trans
      ((e (p.lift a m (p.roundL a (p.roundL a y)))).trans
        ((probe_rounded p h a m ad j (p.roundL a y)).symm.trans
          (h.predicate_cancel a (.part m (p.probe j)) y).symm)))

theorem lift_valid (a : A) (m : c.M a) (ad : p.Adm a m) (y : c.L a) :
    p.Valid (p.lift a m y) := by
  intro i j e
  exact (raw_lift_cancel p h a m y (p.probe i)).trans
    ((ad.2 .R (by decide) _ _
      (pair_congr p h a m ad (part_probe_congr p h a m ad e)
        (rel_refl p a m y))).trans
      (raw_lift_cancel p h a m y (p.probe j)).symm)

theorem round_equiv (x : c.X) : p.Equiv x (p.roundX x) :=
  fun i => (h.round_observe x (p.probe i)).symm

omit h

structure RealizedLaws (a : A) (m : c.M a) : Prop where
  lift_cancel : ∀ y v, p.observe (p.lift a m y) v ↔ p.sb a v m y
  probe_rounded : ∀ i y,
    p.diamond a (p.probe i) m y ↔ p.evalX i (p.lift a m (p.roundL a y))
  lift_congr : ∀ {y z}, p.Rel a m y z → p.Equiv (p.lift a m y) (p.lift a m z)
  lift_valid : ∀ y, p.Valid (p.lift a m y)

include h

theorem realize_four_laws (a : A) (m : c.M a) (ad : p.Adm a m) :
    RealizedLaws p a m where
  lift_cancel := raw_lift_cancel p h a m
  probe_rounded := probe_rounded p h a m ad
  lift_congr := lift_congr p h a m ad
  lift_valid := lift_valid p h a m ad

omit h

namespace Syntax

inductive Parameter where
  | open : Nat → Parameter
  | downZ
  deriving DecidableEq, Repr

inductive LocalRole where
  | B | Lc | L | PL | BP | M | F | Single | Fun | Packed
  deriving DecidableEq, Repr

inductive Kind where
  | local : LocalRole → Parameter → Kind
  | Z | V | Xc | X | PX | U
  deriving DecidableEq, Repr

inductive Var : List Kind → Kind → Type where
  | zero : Var (k :: Γ) k
  | succ : Var Γ k → Var (j :: Γ) k

inductive OddPath where
  | Lc : Parameter → OddPath
  | L : Parameter → OddPath
  | PL : Parameter → OddPath
  | F : Parameter → OddPath
  | Single : Parameter → OddPath
  | Xc | X | PX

def OddPath.source : OddPath → Kind
  | .Lc a | .L a => .local .B a
  | .PL a => .local .Lc a
  | .F a => .local .M a
  | .Single a => .local .F a
  | .Xc | .X => .V
  | .PX => .Xc

def OddPath.target : OddPath → Kind
  | .Lc a => .local .Lc a
  | .L a => .local .L a
  | .PL a => .local .PL a
  | .F a => .local .F a
  | .Single a => .local .Single a
  | .Xc => .Xc
  | .X => .X
  | .PX => .PX

inductive Direct : Kind → Type where
  | L : Direct (.local .L a)
  | PL : Direct (.local .PL a)
  | X : Direct .X
  | PX : Direct .PX

mutual
  inductive Term : List Kind → Kind → Type where
    | var : Var Γ k → Term Γ k
    | mk (path : OddPath) : Formula (path.source :: Γ) → Term Γ path.target
    | inst : Term Δ k → (∀ {j}, Var Δ j → Term Γ j) → Term Γ k
    | dummy (a : Parameter) : Term Γ (.local .M a)
    | point : Term Γ (.local .L a) → Term Γ (.local .M a)
    | enc : Tag → Term Γ (.local .PL a) → Term Γ (.local .BP a)
    | send : Formula Γ → Term Γ .U
    | lambdaW : Term (.local .Single a :: Γ) .U → Term Γ (.local .Fun a)
    | pack : Term Γ (.local .Fun a) → Term Γ (.local .Packed a)
    | lambdaZ : Term [.Z, .PX] (.local .Packed .downZ) → Term [.PX] .V
    | applyAt : Term Γ .V → (a : Parameter) → Term Γ (.local .Packed a)
    | applyW : Term Γ (.local .Fun a) → Term Γ (.local .Single a) → Term Γ .U
  inductive Formula : List Kind → Type where
    | top : Formula Γ
    | bot : Formula Γ
    | and : Formula Γ → Formula Γ → Formula Γ
    | or : Formula Γ → Formula Γ → Formula Γ
    | neg : Formula Γ → Formula Γ
    | imp : Formula Γ → Formula Γ → Formula Γ
    | iff : Formula Γ → Formula Γ → Formula Γ
    | all : Direct k → Formula (k :: Γ) → Formula Γ
    | ex : Direct k → Formula (k :: Γ) → Formula Γ
    | at (path : OddPath) : Term Γ path.target → Term Γ path.source → Formula Γ
    | query : Tag → Term Γ (.local .M a) → Term Γ (.local .PL a) → Formula Γ
    | flag : Term Γ (.local .M a) → Formula Γ
    | user : Nat → Term Γ (.local .M a) → Term Γ (.local .L a) → Formula Γ
    | read : Term Γ .U → Formula Γ
    | use : Term Γ (.local .Packed a) →
        Formula (.local .Fun a :: Γ) → Formula Γ
    | inst : Formula Δ → (∀ {j}, Var Δ j → Term Γ j) → Formula Γ
end

abbrev Sub (Γ Δ : List Kind) := ∀ {k}, Var Γ k → Term Δ k
def identity : Sub Γ Γ := fun v => .var v
def weaken {k : Kind} (t : Term Γ j) : Term (k :: Γ) j :=
  .inst t (fun v => .var (.succ v))
def weakenSub {k : Kind} (s : Sub Γ Δ) : Sub Γ (k :: Δ) :=
  fun v => weaken (s v)
def consSub (t : Term Δ k) (s : Sub Γ Δ) : Sub (k :: Γ) Δ :=
  fun v => match v with
  | .zero => t
  | .succ w => s w
abbrev v0 : Term (k :: Γ) k := .var .zero

def rawL (a : Parameter) (y : Term Γ (.local .L a)) : Term Γ (.local .Lc a) :=
  .mk (.Lc a) (.at (.L a) (weaken y) v0)
def logL (a : Parameter) (y : Term Γ (.local .Lc a)) : Term Γ (.local .L a) :=
  .mk (.L a) (.at (.Lc a) (weaken y) v0)
def roundL (a : Parameter) (y : Term Γ (.local .L a)) : Term Γ (.local .L a) :=
  logL a (rawL a y)
def evalL (a : Parameter) (P : Term Γ (.local .PL a))
    (y : Term Γ (.local .L a)) : Formula Γ :=
  .at (.PL a) P (rawL a y)
def predL (a : Parameter) (q : Formula (.local .L a :: Γ)) :
    Term Γ (.local .PL a) :=
  .mk (.PL a) (.inst q (consSub (logL a v0) (fun v => .var (.succ v))))
def rawX (x : Term Γ .X) : Term Γ .Xc :=
  .mk .Xc (.at .X (weaken x) v0)
def logX (x : Term Γ .Xc) : Term Γ .X :=
  .mk .X (.at .Xc (weaken x) v0)
def roundX (x : Term Γ .X) : Term Γ .X := logX (rawX x)
def evalX (i : Term Γ .PX) (x : Term Γ .X) : Formula Γ := .at .PX i (rawX x)
def gate (g f t : Formula Γ) : Formula Γ :=
  .or (.and g f) (.and (.neg g) t)
def bundle (a : Parameter) (m : Term Γ (.local .M a))
    (y : Term Γ (.local .L a)) : Term Γ (.local .Single a) :=
  .mk (.Single a)
    (gate (.at (.F a) v0 (.dummy a))
      (.at (.F a) v0 (weaken m)) (.at (.F a) v0 (.point (weaken y))))

abbrev Callback (Γ : List Kind) (a : Parameter) :=
  Formula (.local .L a :: .local .M a :: Γ)

def call (q : Callback Γ a) (s : Sub Γ Δ)
    (m : Term Δ (.local .M a)) (y : Term Δ (.local .L a)) : Formula Δ :=
  .inst q (consSub y (consSub m s))
def inner (a : Parameter) (q : Callback Γ a) (s : Sub Γ Δ)
    (m : Term Δ (.local .M a)) : Term Δ (.local .F a) :=
  .mk (.F a)
    (gate (.flag v0) .bot
      (.query .pt v0
        (predL a (call q (weakenSub (weakenSub s)) (weaken (weaken m)) v0))))
def outer (a : Parameter) (q : Callback Γ a) (s : Sub Γ Δ)
    (w : Term Δ (.local .Single a)) : Term Δ (.local .F a) :=
  .mk (.F a)
    (gate (.flag v0) .top
      (.at (.Single a) (weaken w) (inner a q (weakenSub s) v0)))
def access (a : Parameter) (q : Callback Γ a) (s : Sub Γ Δ)
    (w : Term Δ (.local .Single a)) : Formula Δ :=
  .at (.Single a) w (outer a q s w)
def diamond (a : Parameter) (v : Term Γ .V)
    (m : Term Γ (.local .M a)) (y : Term Γ (.local .L a)) : Formula Γ :=
  .use (.applyAt v a) (.read (.applyW v0 (weaken (bundle a m y))))
def good (a : Parameter) (m : Term Γ (.local .M a))
    (P : Term Γ (.local .PL a)) : Formula Γ :=
  .and (.all .L (.iff (evalL a (weaken P) v0)
    (evalL a (weaken P) (roundL a v0)))) (.query .G m P)
def rel (a : Parameter) (m : Term Γ (.local .M a))
    (y z : Term Γ (.local .L a)) : Formula Γ :=
  .all .PL (.imp (good a (weaken m) v0)
    (.iff (evalL a v0 (weaken y)) (evalL a v0 (weaken z))))
def classCode (a : Parameter) (m : Term Γ (.local .M a))
    (y : Term Γ (.local .L a)) : Term Γ (.local .PL a) :=
  predL a (rel a (weaken m) v0 (weaken y))
def unionCode (a : Parameter) (m : Term Γ (.local .M a))
    (y z : Term Γ (.local .L a)) : Term Γ (.local .PL a) :=
  predL a (.or (rel a (weaken m) v0 (weaken y))
    (rel a (weaken m) v0 (weaken z)))
def tagged (a : Parameter) (m : Term Γ (.local .M a)) (t : Side)
    (y z : Term Γ (.local .L a)) : Formula Γ :=
  .and (.query .C0 m (classCode a m y))
    (.and (.query (classTag t) m (classCode a m z))
      (.query (edgeTag t) m (unionCode a m y z)))
def form (a : Parameter) (m : Term Γ (.local .M a))
    (P : Term Γ (.local .PL a)) (y z : Term Γ (.local .L a)) : Formula Γ :=
  .or (.ex .L (.and (tagged a (weaken m) .left v0 (weaken z))
    (evalL a (weaken P) v0))) (tagged a m .right y z)
def pair (a : Parameter) (m : Term Γ (.local .M a))
    (P : Term Γ (.local .PL a)) (y : Term Γ (.local .L a)) :
    Term Γ (.local .PL a) :=
  predL a (form a (weaken m) (weaken P) (weaken y) v0)
def part (a : Parameter) (m : Term Γ (.local .M a)) (v : Term Γ .V) :
    Term Γ (.local .PL a) :=
  predL a (diamond a (weaken v) (weaken m) v0)
def sb (a : Parameter) (m : Term Γ (.local .M a))
    (v : Term Γ .V) (y : Term Γ (.local .L a)) : Formula Γ :=
  .query .R m (pair a m (part a m v) y)
def lift (a : Parameter) (m : Term Γ (.local .M a))
    (y : Term Γ (.local .L a)) : Term Γ .X :=
  .mk .X (sb a (weaken m) v0 (weaken y))

def probeCallback (a : Parameter) (i : Term Γ .PX) : Callback Γ a :=
  evalX (weaken (weaken i)) (lift a (.var (.succ .zero)) v0)

def probeTemplate : Term [.PX] .V :=
  .lambdaZ (.pack (.lambdaW
    (.send (access .downZ
      (probeCallback .downZ (.var (.succ (.succ .zero))))
      identity v0))))

def probe (i : Term Γ .PX) : Term Γ .V :=
  .inst probeTemplate (fun v => match v with | .zero => i)

inductive Vertex where
  | k | p | j | h | n | g | I | J | b
  deriving DecidableEq

def kindVertex : Kind → Vertex
  | .local .B _ | .local .BP _ | .local .F _ | .V => .k
  | .local .Lc _ | .local .M _ | .local .Single _ | .Xc => .p
  | .local .L _ | .X => .j
  | .local .PL _ | .PX => .h
  | .local .Fun _ => .g
  | .local .Packed _ => .J
  | .Z => .I
  | .U => .n

structure Specification where
  VertexType : Type
  vertex : Vertex → VertexType
  product : VertexType → VertexType → VertexType → Prop
  odd : VertexType → VertexType → Prop
  even : VertexType → VertexType → Prop
  direct : VertexType → Prop

structure Support (s : Specification) : Prop where
  alpha : s.odd (s.vertex .k) (s.vertex .p)
  beta : s.odd (s.vertex .p) (s.vertex .k)
  lambda : s.odd (s.vertex .k) (s.vertex .j)
  eta : s.odd (s.vertex .p) (s.vertex .h)
  kappa : s.even (s.vertex .g) (s.vertex .J)
  fun_product : s.product (s.vertex .p) (s.vertex .n) (s.vertex .g)
  v_product : s.product (s.vertex .I) (s.vertex .J) (s.vertex .k)
  direct_j : s.direct (s.vertex .j)
  direct_h : s.direct (s.vertex .h)

theorem odd_support (s : Specification) (h : Support s) (o : OddPath) :
    s.odd (s.vertex (kindVertex o.source)) (s.vertex (kindVertex o.target)) := by
  cases o with
  | Lc _ | Xc | Single _ => exact h.alpha
  | L _ | X => exact h.lambda
  | PL _ | PX => exact h.eta
  | F _ => exact h.beta

theorem direct_support (s : Specification) (h : Support s) (d : Direct k) :
    s.direct (s.vertex (kindVertex k)) := by
  cases d with
  | L | X => exact h.direct_j
  | PL | PX => exact h.direct_h

structure TypingInterpretation (s : Specification) where
  data : {Γ : List Kind} → {k : Kind} → Term Γ k → Prop
  formula : {Γ : List Kind} → Formula Γ → Prop
  variable_typed : ∀ (v : Var Γ k), data (.var v)
  odd_mk : ∀ (o : OddPath) (q : Formula (o.source :: Γ)),
    s.odd (s.vertex (kindVertex o.source)) (s.vertex (kindVertex o.target)) →
    formula q → data (.mk o q)
  data_substitution : ∀ (e : Term Δ k) (σ : Sub Δ Γ),
    data e → (∀ {j} (v : Var Δ j), data (σ v)) → data (.inst e σ)
  dummy : ∀ (a : Parameter), data (Term.dummy (Γ := Γ) a)
  point : ∀ (e : Term Γ (.local .L a)), data e → data (.point e)
  enc : ∀ t (e : Term Γ (.local .PL a)), data e → data (.enc t e)
  send : ∀ (q : Formula Γ), formula q → data (.send q)
  abstraction_w : ∀ (e : Term (.local .Single a :: Γ) .U),
    s.product (s.vertex .p) (s.vertex .n) (s.vertex .g) →
    data e → data (.lambdaW e)
  pack : ∀ (e : Term Γ (.local .Fun a)),
    s.even (s.vertex .g) (s.vertex .J) → data e → data (.pack e)
  abstraction_z : ∀ (e : Term [.Z, .PX] (.local .Packed .downZ)),
    s.product (s.vertex .I) (s.vertex .J) (s.vertex .k) →
    data e → data (.lambdaZ e)
  application_at : ∀ (e : Term Γ .V) (a : Parameter),
    data e → data (.applyAt e a)
  application_w : ∀ (f : Term Γ (.local .Fun a)) (w : Term Γ (.local .Single a)),
    data f → data w → data (.applyW f w)
  truth : formula (Formula.top (Γ := Γ))
  falsity : formula (Formula.bot (Γ := Γ))
  conjunction : ∀ (q r : Formula Γ), formula q → formula r → formula (.and q r)
  disjunction : ∀ (q r : Formula Γ), formula q → formula r → formula (.or q r)
  negation : ∀ (q : Formula Γ), formula q → formula (.neg q)
  implication : ∀ (q r : Formula Γ), formula q → formula r → formula (.imp q r)
  biconditional : ∀ (q r : Formula Γ), formula q → formula r → formula (.iff q r)
  universal : ∀ (d : Direct k) (q : Formula (k :: Γ)),
    s.direct (s.vertex (kindVertex k)) → formula q → formula (.all d q)
  existential : ∀ (d : Direct k) (q : Formula (k :: Γ)),
    s.direct (s.vertex (kindVertex k)) → formula q → formula (.ex d q)
  observation : ∀ (o : OddPath) (w : Term Γ o.target) (t : Term Γ o.source),
    data w → data t → formula (.at o w t)
  query : ∀ t (m : Term Γ (.local .M a)) (P : Term Γ (.local .PL a)),
    data m → data P → formula (.query t m P)
  flag : ∀ (m : Term Γ (.local .M a)), data m → formula (.flag m)
  user : ∀ id (m : Term Γ (.local .M a)) (y : Term Γ (.local .L a)),
    data m → data y → formula (.user id m y)
  read : ∀ (e : Term Γ .U), data e → formula (.read e)
  use : ∀ (e : Term Γ (.local .Packed a)) (q : Formula (.local .Fun a :: Γ)),
    data e → formula q → formula (.use e q)
  formula_substitution : ∀ (q : Formula Δ) (σ : Sub Δ Γ),
    formula q → (∀ {j} (v : Var Δ j), data (σ v)) → formula (.inst q σ)

mutual
  theorem type_preservation (s : Specification) (h : Support s)
      (r : TypingInterpretation s) (e : Term Γ k) : r.data e :=
    match e with
    | .var v => r.variable_typed v
    | .mk o q => r.odd_mk o q (odd_support s h o) (formula_preservation s h r q)
    | .inst e σ => r.data_substitution e σ (type_preservation s h r e)
        (fun v => type_preservation s h r (σ v))
    | .dummy a => r.dummy a
    | .point e => r.point e (type_preservation s h r e)
    | .enc t e => r.enc t e (type_preservation s h r e)
    | .send q => r.send q (formula_preservation s h r q)
    | .lambdaW e => r.abstraction_w e h.fun_product (type_preservation s h r e)
    | .pack e => r.pack e h.kappa (type_preservation s h r e)
    | .lambdaZ e => r.abstraction_z e h.v_product (type_preservation s h r e)
    | .applyAt e a => r.application_at e a (type_preservation s h r e)
    | .applyW f w => r.application_w f w (type_preservation s h r f)
        (type_preservation s h r w)
  theorem formula_preservation (s : Specification) (h : Support s)
      (r : TypingInterpretation s) (q : Formula Γ) : r.formula q :=
    match q with
    | .top => r.truth
    | .bot => r.falsity
    | .and q t => r.conjunction q t (formula_preservation s h r q)
        (formula_preservation s h r t)
    | .or q t => r.disjunction q t (formula_preservation s h r q)
        (formula_preservation s h r t)
    | .neg q => r.negation q (formula_preservation s h r q)
    | .imp q t => r.implication q t (formula_preservation s h r q)
        (formula_preservation s h r t)
    | .iff q t => r.biconditional q t (formula_preservation s h r q)
        (formula_preservation s h r t)
    | .all d q => r.universal d q (direct_support s h d) (formula_preservation s h r q)
    | .ex d q => r.existential d q (direct_support s h d) (formula_preservation s h r q)
    | .at o w t => r.observation o w t (type_preservation s h r w)
        (type_preservation s h r t)
    | .query t m P => r.query t m P (type_preservation s h r m)
        (type_preservation s h r P)
    | .flag m => r.flag m (type_preservation s h r m)
    | .user id m y => r.user id m y (type_preservation s h r m)
        (type_preservation s h r y)
    | .read e => r.read e (type_preservation s h r e)
    | .use e q => r.use e q (type_preservation s h r e) (formula_preservation s h r q)
    | .inst q σ => r.formula_substitution q σ (formula_preservation s h r q)
        (fun v => type_preservation s h r (σ v))
end

theorem uniform_probe_typed (s : Specification) (h : Support s)
    (r : TypingInterpretation s) (i : Term Γ .PX) : r.data (probe i) :=
  type_preservation s h r (probe i)

theorem access_typed (s : Specification) (h : Support s) (r : TypingInterpretation s)
    (a : Parameter) (q : Callback Γ a) (σ : Sub Γ Δ)
    (w : Term Δ (.local .Single a)) : r.formula (access a q σ w) :=
  formula_preservation s h r (access a q σ w)

theorem lift_typed (s : Specification) (h : Support s) (r : TypingInterpretation s)
    (a : Parameter) (m : Term Γ (.local .M a)) (y : Term Γ (.local .L a)) :
    r.data (lift a m y) :=
  type_preservation s h r (lift a m y)

def kindNoOpen : Kind → Bool
  | .local _ (.open _) => false
  | _ => true

def allVariables : (Γ : List Kind) →
    (∀ {k}, Var Γ k → Bool) → Bool
  | [], _ => true
  | _ :: Γ, f => f .zero && allVariables Γ (fun v => f (.succ v))

mutual
  def termNoOpen {Γ k} (e : Term Γ k) : Bool :=
    kindNoOpen k &&
      match e with
      | .var _ => true
      | .mk o q => kindNoOpen o.source && formulaNoOpen q
      | .inst e σ => termNoOpen e && allVariables _ (fun v => termNoOpen (σ v))
      | .dummy _ => true
      | .point e | .enc _ e => termNoOpen e
      | .send q => formulaNoOpen q
      | .lambdaW e | .pack e => termNoOpen e
      | .lambdaZ e => termNoOpen e
      | .applyAt e _ => termNoOpen e
      | .applyW f w => termNoOpen f && termNoOpen w
  def formulaNoOpen {Γ} (q : Formula Γ) : Bool :=
    match q with
    | .top | .bot => true
    | .and q r | .or q r | .imp q r | .iff q r =>
        formulaNoOpen q && formulaNoOpen r
    | .neg q => formulaNoOpen q
    | .all _ q | .ex _ q => formulaNoOpen q
    | .at _ w t => termNoOpen w && termNoOpen t
    | .query _ m P => termNoOpen m && termNoOpen P
    | .flag m => termNoOpen m
    | .user _ m y => termNoOpen m && termNoOpen y
    | .read e => termNoOpen e
    | .use e q => termNoOpen e && formulaNoOpen q
    | .inst q σ => formulaNoOpen q && allVariables _ (fun v => termNoOpen (σ v))
end

theorem uniform_probe_has_no_open_A : termNoOpen probeTemplate = true := by
  rfl

theorem global_types_have_no_parameter :
    kindNoOpen .V = true ∧ kindNoOpen .X = true ∧ kindNoOpen .PX = true :=
  ⟨rfl, rfl, rfl⟩

end Syntax

#print axioms access_exact
#print axioms realize_four_laws
#print axioms Syntax.type_preservation
#print axioms Syntax.uniform_probe_typed
#print axioms Syntax.uniform_probe_has_no_open_A

end TypedProbe
