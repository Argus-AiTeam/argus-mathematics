import Lean

namespace GuardedDiagonal

universe uL uX uV uP uI

structure Data (L : Type uL) (X : Type uX) (V : Type uV)
    (PL : Type uP) (PX : Type uI) where
  observe : X → V → Prop
  evalX : PX → X → Prop
  evalL : PL → L → Prop
  diamond : V → L → Prop
  queryG : PL → Prop
  queryR : PL → Prop
  roundL : L → L
  roundX : X → X
  tag0 : X → L
  tagLeft : X → L
  tagRight : X → L
  part : V → PL
  pair : PL → L → PL
  lift : L → X
  probe : PX → V
  responseCode : V → PX
  leftCode : PL → PX
  shiftCode : PX → PX
  wf : X
  negativeCode : PX

namespace Data

variable {L : Type uL} {X : Type uX} {V : Type uV}
  {PL : Type uP} {PX : Type uI} (d : Data L X V PL PX)

def le (i : PX) (x : X) : Prop := d.observe x (d.probe i)
def Approx (i j : PX) : Prop := ∀ x, d.evalX i x ↔ d.evalX j x
def Equiv (x y : X) : Prop := ∀ i, d.le i x ↔ d.le i y
def Good (P : PL) : Prop :=
  (∀ y, d.evalL P y ↔ d.evalL P (d.roundL y)) ∧ d.queryG P
def Rel (y z : L) : Prop :=
  ∀ P : PL, d.Good P → (d.evalL P y ↔ d.evalL P z)
def Valid (x : X) : Prop :=
  ∀ i j : PX, d.Approx i j → (d.le i x ↔ d.le j x)
def Ext (i : PX) : Prop :=
  ∀ x y : X, d.Equiv x y → (d.evalX i x ↔ d.evalX i y)
def Resp (v : V) : Prop :=
  ∀ y z : L, d.Rel y z → (d.diamond v y ↔ d.diamond v z)
def PairAt (v : V) (x : X) : PL := d.pair (d.part v) (d.tag0 x)
def sb (v : V) (a : L) : Prop := d.queryR (d.pair (d.part v) a)
def delta (x : X) : X := d.lift (d.tag0 x)
def Ind (i : PX) : Prop := ∀ x : X, d.Valid x → d.le i x → d.evalX i x
def Q (x : X) : Prop :=
  ∀ i : PX, d.Ext i → d.le i x → d.evalX i (d.delta x)
def RProperty (P : PL) : Prop :=
  d.Ext (d.leftCode P) →
    ∀ x : X, d.Valid x → d.evalL P (d.tagRight x) → d.le (d.leftCode P) x

end Data

variable {L : Type uL} {X : Type uX} {V : Type uV}
  {PL : Type uP} {PX : Type uI}

structure Laws (d : Data L X V PL PX) (B : Prop) : Prop where
  round_observe : ∀ x v, d.observe (d.roundX x) v ↔ d.observe x v
  tag_congr : ∀ {x y}, d.Equiv x y → d.Rel (d.tag0 x) (d.tag0 y)
  lift_congr : ∀ {a b}, d.Rel a b → d.Equiv (d.lift a) (d.lift b)
  lift_valid : ∀ a, d.Valid (d.lift a)
  lift_cancel : ∀ a v, d.observe (d.lift a) v ↔ d.sb v a
  probe_rounded : ∀ i y,
    d.diamond (d.probe i) y ↔ d.evalX i (d.lift (d.roundL y))
  response_eval : ∀ v x,
    d.evalX (d.responseCode v) x ↔ d.diamond v (d.tag0 (d.roundX x))
  left_eval : ∀ P x,
    d.evalX (d.leftCode P) x ↔ d.evalL P (d.tagLeft (d.roundX x))
  pair_left : ∀ v, d.Resp v → ∀ x y,
    d.evalL (d.PairAt v x) (d.tagLeft y) ↔ d.diamond v (d.tag0 y)
  pair_right : ∀ v, d.Resp v → ∀ x y,
    d.evalL (d.PairAt v x) (d.tagRight y) ↔ d.Equiv x y
  query_realization : ∀ P, d.queryR P ↔ d.RProperty P
  shift_eval : ∀ i x,
    d.evalX (d.shiftCode i) x ↔ d.evalX i (d.delta (d.roundX x))
  wf_cancel : ∀ v, d.observe d.wf v ↔ d.Ind (d.responseCode v)
  negative_eval : ∀ x,
    d.evalX d.negativeCode x ↔ (d.Q (d.roundX x) → B)

variable (d : Data L X V PL PX) {B : Prop} (h : Laws d B)

theorem equiv_refl (x : X) : d.Equiv x x := fun _ => Iff.rfl

theorem round_rel (y : L) : d.Rel y (d.roundL y) :=
  fun _ g => g.1 y

include h

theorem round_equiv (x : X) : d.Equiv x (d.roundX x) :=
  fun i => (h.round_observe x (d.probe i)).symm

omit h in
theorem ext_congr {i j : PX} (a : d.Approx i j) : d.Ext i ↔ d.Ext j := by
  constructor
  · intro ex x y e
    exact (a x).symm.trans ((ex x y e).trans (a y))
  · intro ex x y e
    exact (a x).trans ((ex x y e).trans (a y).symm)

theorem probe_exact {i : PX} (ex : d.Ext i) (y : L) :
    d.diamond (d.probe i) y ↔ d.evalX i (d.lift y) :=
  (h.probe_rounded i y).trans
    (ex _ _ (h.lift_congr (round_rel d y))).symm

theorem probe_resp {i : PX} (ex : d.Ext i) : d.Resp (d.probe i) := by
  intro y z e
  exact (probe_exact d h ex y).trans
    ((ex _ _ (h.lift_congr e)).trans (probe_exact d h ex z).symm)

theorem response_exact {v : V} (hv : d.Resp v) (x : X) :
    d.evalX (d.responseCode v) x ↔ d.diamond v (d.tag0 x) :=
  (h.response_eval v x).trans
    (hv _ _ (h.tag_congr (round_equiv d h x))).symm

theorem response_ext {v : V} (hv : d.Resp v) : d.Ext (d.responseCode v) := by
  intro x y e
  exact (response_exact d h hv x).trans
    ((hv _ _ (h.tag_congr e)).trans (response_exact d h hv y).symm)

theorem left_response_approx {v : V} (hv : d.Resp v) (x : X) :
    d.Approx (d.leftCode (d.PairAt v x)) (d.responseCode v) := by
  intro y
  exact (h.left_eval (d.PairAt v x) y).trans
    ((h.pair_left v hv x (d.roundX y)).trans (h.response_eval v y).symm)

theorem sb_law {v : V} (hv : d.Resp v) (x : X) (u : d.Valid x) :
    d.sb v (d.tag0 x) ↔ d.le (d.responseCode v) x := by
  let P := d.PairAt v x
  let c := d.leftCode P
  have a : d.Approx c (d.responseCode v) := left_response_approx d h hv x
  have exc : d.Ext c := (ext_congr d a).mpr (response_ext d h hv)
  change d.queryR P ↔ d.le (d.responseCode v) x
  refine (h.query_realization P).trans ?_
  constructor
  · intro g
    have px : d.evalL P (d.tagRight x) :=
      (h.pair_right v hv x x).mpr (equiv_refl d x)
    exact (u c (d.responseCode v) a).mp (g exc x u px)
  · intro l _ y uy p
    have e : d.Equiv x y := (h.pair_right v hv x y).mp p
    exact (uy c (d.responseCode v) a).mpr ((e (d.responseCode v)).mp l)

theorem delta_valid (x : X) : d.Valid (d.delta x) :=
  h.lift_valid (d.tag0 x)

theorem delta_congr {x y : X} (e : d.Equiv x y) :
    d.Equiv (d.delta x) (d.delta y) :=
  h.lift_congr (h.tag_congr e)

theorem shift_exact {i : PX} (ex : d.Ext i) (x : X) :
    d.evalX (d.shiftCode i) x ↔ d.evalX i (d.delta x) :=
  (h.shift_eval i x).trans
    (ex _ _ (delta_congr d h (round_equiv d h x))).symm

theorem shift_ext {i : PX} (ex : d.Ext i) : d.Ext (d.shiftCode i) := by
  intro x y e
  exact (shift_exact d h ex x).trans
    ((ex _ _ (delta_congr d h e)).trans (shift_exact d h ex y).symm)

theorem shift_comparison {i : PX} (ex : d.Ext i) :
    d.Approx (d.responseCode (d.probe i)) (d.shiftCode i) := by
  intro x
  exact (response_exact d h (probe_resp d h ex) x).trans
    ((probe_exact d h ex (d.tag0 x)).trans (shift_exact d h ex x).symm)

theorem predecessor {i : PX} (ex : d.Ext i) {x : X} (u : d.Valid x) :
    d.le i (d.delta x) ↔ d.le (d.shiftCode i) x :=
  (h.lift_cancel (d.tag0 x) (d.probe i)).trans
    ((sb_law d h (probe_resp d h ex) x u).trans
      (u _ _ (shift_comparison d h ex)))

omit h in
theorem ind_congr {i j : PX} (a : d.Approx i j) : d.Ind i ↔ d.Ind j := by
  constructor
  · intro l x u t
    exact (a x).mp (l x u ((u i j a).mpr t))
  · intro l x u t
    exact (a x).mpr (l x u ((u i j a).mp t))

theorem wf_raw (i : PX) :
    d.le i d.wf ↔ d.Ind (d.responseCode (d.probe i)) :=
  h.wf_cancel (d.probe i)

theorem probe_response_congr {i j : PX} (a : d.Approx i j) :
    d.Approx (d.responseCode (d.probe i)) (d.responseCode (d.probe j)) := by
  intro x
  let t := d.tag0 (d.roundX x)
  calc
    d.evalX (d.responseCode (d.probe i)) x ↔ d.diamond (d.probe i) t :=
      h.response_eval (d.probe i) x
    _ ↔ d.evalX i (d.lift (d.roundL t)) := h.probe_rounded i t
    _ ↔ d.evalX j (d.lift (d.roundL t)) := a (d.lift (d.roundL t))
    _ ↔ d.diamond (d.probe j) t := (h.probe_rounded j t).symm
    _ ↔ d.evalX (d.responseCode (d.probe j)) x :=
      (h.response_eval (d.probe j) x).symm

theorem wf_valid : d.Valid d.wf := by
  intro i j a
  exact (wf_raw d h i).trans
    ((ind_congr d (probe_response_congr d h a)).trans (wf_raw d h j).symm)

theorem wf_evaluation {i : PX} (ex : d.Ext i) :
    d.le i d.wf ↔ d.Ind (d.shiftCode i) :=
  (wf_raw d h i).trans (ind_congr d (shift_comparison d h ex))

theorem ind_shift {i : PX} (ex : d.Ext i) (l : d.Ind i) :
    d.Ind (d.shiftCode i) := by
  intro x u t
  exact (shift_exact d h ex x).mpr
    (l (d.delta x) (delta_valid d h x) ((predecessor d h ex u).mpr t))

theorem induction_builder {i : PX} (ex : d.Ext i) (l : d.Ind i) :
    d.evalX i d.wf :=
  l d.wf (wf_valid d h) ((wf_evaluation d h ex).mpr (ind_shift d h ex l))

theorem q_congr {x y : X} (e : d.Equiv x y) : d.Q x ↔ d.Q y := by
  constructor
  · intro q i ex t
    exact (ex _ _ (delta_congr d h e)).mp (q i ex ((e i).mpr t))
  · intro q i ex t
    exact (ex _ _ (delta_congr d h e)).mpr (q i ex ((e i).mp t))

omit h in
theorem relative_neg_congr {P Q B : Prop} (e : P ↔ Q) :
    (P → B) ↔ (Q → B) :=
  ⟨fun n q => n (e.mpr q), fun n p => n (e.mp p)⟩

theorem negative_exact (x : X) :
    d.evalX d.negativeCode x ↔ (d.Q x → B) :=
  (h.negative_eval x).trans
    (relative_neg_congr (q_congr d h (round_equiv d h x))).symm

theorem negative_ext : d.Ext d.negativeCode := by
  intro x y e
  exact (negative_exact d h x).trans
    ((relative_neg_congr (q_congr d h e)).trans (negative_exact d h y).symm)

theorem negative_ind : d.Ind d.negativeCode := by
  intro x u t
  apply (negative_exact d h x).mpr
  intro q
  have nd : d.Q (d.delta x) → B :=
    (negative_exact d h (d.delta x)).mp (q d.negativeCode (negative_ext d h) t)
  apply nd
  intro i ex ti
  have qs : d.evalX (d.shiftCode i) (d.delta x) :=
    q (d.shiftCode i) (shift_ext d h ex) ((predecessor d h ex u).mp ti)
  exact (shift_exact d h ex (d.delta x)).mp qs

theorem q_wf : d.Q d.wf := by
  intro i ex t
  have ls : d.Ind (d.shiftCode i) := (wf_evaluation d h ex).mp t
  have si : d.evalX (d.shiftCode i) d.wf :=
    induction_builder d h (shift_ext d h ex) ls
  exact (shift_exact d h ex d.wf).mp si

theorem terminal : B :=
  ((negative_exact d h d.wf).mp
    (induction_builder d h (negative_ext d h) (negative_ind d h))) (q_wf d h)

omit h in
theorem no_false_model (hf : Laws d False) : False := terminal d hf

#print axioms terminal
#print axioms no_false_model

end GuardedDiagonal
