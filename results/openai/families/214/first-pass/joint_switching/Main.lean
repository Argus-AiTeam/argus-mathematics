import Mathlib

noncomputable section

namespace JointSwitching

universe u v

structure Geometry (V : Type u) (E : Type v) where
  left : E → V
  right : E → V

variable {V : Type u} {E : Type v}

abbrev Field (E : Type v) := E → Bool

def Geometry.Incident (g : Geometry V E) (A : Set V) (e : E) : Prop :=
  g.left e ∈ A ∨ g.right e ∈ A

def Geometry.OpenAdj (g : Geometry V E) (F : Field E) (a b : V) : Prop :=
  ∃ e, F e = true ∧
    ((g.left e = a ∧ g.right e = b) ∨
      (g.right e = a ∧ g.left e = b))

theorem Geometry.OpenAdj.symm {g : Geometry V E} {F : Field E} {a b : V}
    (h : g.OpenAdj F a b) : g.OpenAdj F b a := by
  rcases h with ⟨e, he, h | h⟩
  · exact ⟨e, he, Or.inr ⟨h.2, h.1⟩⟩
  · exact ⟨e, he, Or.inl ⟨h.2, h.1⟩⟩

inductive Reach (g : Geometry V E) (F : Field E) (S : Set V) (a : V) : V → Prop
  | start (ha : a ∉ S) : Reach g F S a a
  | next {b c : V} (hab : Reach g F S a b)
      (hbc : g.OpenAdj F b c) (hc : c ∉ S) : Reach g F S a c

def component (g : Geometry V E) (F : Field E) (S : Set V) (a : V) : Set V :=
  {b | Reach g F S a b}

theorem Reach.outside {g : Geometry V E} {F : Field E} {S : Set V} {a b : V}
    (h : Reach g F S a b) : b ∉ S := by
  cases h with
  | start ha => exact ha
  | next _ _ hb => exact hb

theorem Reach.mono {g : Geometry V E} {F : Field E} {S T : Set V} {a b : V}
    (h : Reach g F S a b) (hTS : T ⊆ S) : Reach g F T a b := by
  induction h with
  | start ha => exact .start (fun h => ha (hTS h))
  | next _ hbc hc ih => exact .next ih hbc (fun h => hc (hTS h))

def Geometry.Separated (g : Geometry V E) (H T : Set V) : Prop :=
  Disjoint H T ∧ ∀ e,
    ¬ ((g.left e ∈ H ∧ g.right e ∈ T) ∨
      (g.right e ∈ H ∧ g.left e ∈ T))

theorem Geometry.Separated.symm {g : Geometry V E} {H T : Set V}
    (h : g.Separated H T) : g.Separated T H := by
  refine ⟨h.1.symm, ?_⟩
  intro e he
  apply h.2 e
  rcases he with he | he
  · exact Or.inr ⟨he.2, he.1⟩
  · exact Or.inl ⟨he.2, he.1⟩

theorem Geometry.Separated.avoid {g : Geometry V E} {H T : Set V}
    (h : g.Separated H T) {e : E} (he : g.Incident H e) :
    g.left e ∉ T ∧ g.right e ∉ T := by
  rcases he with hl | hr
  · refine ⟨fun ht => Set.disjoint_left.mp h.1 hl ht, ?_⟩
    intro ht
    exact h.2 e (Or.inl ⟨hl, ht⟩)
  · refine ⟨?_, fun ht => Set.disjoint_left.mp h.1 hr ht⟩
    intro ht
    exact h.2 e (Or.inr ⟨hr, ht⟩)

theorem component_strip {g : Geometry V E} {F : Field E}
    {S T H : Set V} {a : V} (ha : a ∉ S)
    (hB : component g F S a ⊆ H) (hsep : g.Separated H T) :
    component g F (S \ T) a = component g F S a := by
  ext b
  constructor
  · intro hb
    induction hb with
    | start _ => exact Reach.start ha
    | @next b c _ hbc hc ih =>
      have hbH : b ∈ H := hB ih
      have hcT : c ∉ T := by
        rcases hbc with ⟨e, _, he | he⟩
        · have hv := hsep.avoid (Or.inl (he.1 ▸ hbH))
          exact he.2 ▸ hv.2
        · have hv := hsep.avoid (Or.inr (he.1 ▸ hbH))
          exact he.2 ▸ hv.1
      have hcS : c ∉ S := fun hs => hc ⟨hs, hcT⟩
      exact Reach.next ih hbc hcS
  · intro hb
    exact Reach.mono hb Set.sdiff_subset

def contacts (g : Geometry V E) (F : Field E) (S B : Set V) : Set E :=
  {e | F e = true ∧
    ((g.left e ∈ B ∧ g.right e ∈ S) ∨
      (g.right e ∈ B ∧ g.left e ∈ S))}

def exchangeMask (g : Geometry V E) (S B : Set V) (seam : E) : Set E :=
  {e | e = seam ∨
    (g.Incident B e ∧ g.left e ∉ S ∧ g.right e ∉ S)}

theorem contacts_strip {g : Geometry V E} {F : Field E}
    {S T H B : Set V} (hB : B ⊆ H) (hsep : g.Separated H T) :
    contacts g F (S \ T) B = contacts g F S B := by
  ext e
  constructor
  · rintro ⟨he, h | h⟩
    · exact ⟨he, Or.inl ⟨h.1, h.2.1⟩⟩
    · exact ⟨he, Or.inr ⟨h.1, h.2.1⟩⟩
  · rintro ⟨he, h | h⟩
    · have ht := hsep.avoid (Or.inl (hB h.1))
      exact ⟨he, Or.inl ⟨h.1, h.2, ht.2⟩⟩
    · have ht := hsep.avoid (Or.inr (hB h.1))
      exact ⟨he, Or.inr ⟨h.1, h.2, ht.1⟩⟩

theorem mask_strip {g : Geometry V E} {S T H B : Set V} {e : E}
    (hB : B ⊆ H) (hsep : g.Separated H T) :
    exchangeMask g (S \ T) B e = exchangeMask g S B e := by
  ext f
  constructor
  · rintro (hf | ⟨hf, hl, hr⟩)
    · exact Or.inl hf
    · have ht := hsep.avoid (hf.elim (fun h => Or.inl (hB h))
        (fun h => Or.inr (hB h)))
      exact Or.inr ⟨hf, fun hs => hl ⟨hs, ht.1⟩,
        fun hs => hr ⟨hs, ht.2⟩⟩
  · rintro (hf | ⟨hf, hl, hr⟩)
    · exact Or.inl hf
    · exact Or.inr ⟨hf, fun hs => hl hs.1, fun hs => hr hs.1⟩

theorem contact_hits {g : Geometry V E} {F : Field E} {S : Set V}
    {a : V} {e : E} (he : e ∈ contacts g F S (component g F S a)) :
    ∃ b ∈ S, b ∈ component g F ∅ a := by
  rcases he with ⟨he, h | h⟩
  · refine ⟨g.right e, h.2, ?_⟩
    exact Reach.next (Reach.mono h.1 (Set.empty_subset S))
      ⟨e, he, Or.inl ⟨rfl, rfl⟩⟩ (by simp)
  · refine ⟨g.left e, h.2, ?_⟩
    exact Reach.next (Reach.mono h.1 (Set.empty_subset S))
      ⟨e, he, Or.inr ⟨rfl, rfl⟩⟩ (by simp)

@[ext]
structure Move (V : Type u) (E : Type v) (k : ℕ) where
  index : Fin k
  seam : E
  piece : Set V
  mask : Set E

variable {k : ℕ}

structure Step (g : Geometry V E) (F : Fin k → Field E)
    (tip : Fin k → V) (choose : Fin k → Set E → E) (z : V)
    (S : Set V) (lo : ℕ) (m : Move V E k) : Prop where
  not_stop : z ∉ S
  eligible : lo ≤ m.index.val
  hit : ∃ b ∈ S, b ∈ component g (F m.index) ∅ (tip m.index)
  maximal : ∀ j : Fin k, lo ≤ j.val →
    (∃ b ∈ S, b ∈ component g (F j) ∅ (tip j)) → j.val ≤ m.index.val
  tip_out : tip m.index ∉ S
  piece_eq : m.piece = component g (F m.index) S (tip m.index)
  seam_eq : m.seam = choose m.index (contacts g (F m.index) S m.piece)
  contact : m.seam ∈ contacts g (F m.index) S m.piece
  mask_eq : m.mask = exchangeMask g S m.piece m.seam

inductive ValidRun (g : Geometry V E) (F : Fin k → Field E)
    (tip : Fin k → V) (choose : Fin k → Set E → E) (z : V) :
    Set V → ℕ → List (Move V E k) → Prop
  | stop {S lo} (hz : z ∈ S) : ValidRun g F tip choose z S lo []
  | cons {S lo m ms} (st : Step g F tip choose z S lo m)
      (tail : ValidRun g F tip choose z (S ∪ m.piece) (m.index.val + 1) ms) :
      ValidRun g F tip choose z S lo (m :: ms)

def PiecesIn (H : Set V) (ms : List (Move V E k)) : Prop :=
  ∀ m ∈ ms, m.piece ⊆ H

def inserted (ms : List (Move V E k)) : Set V :=
  {a | ∃ m ∈ ms, a ∈ m.piece}

theorem piecesIn_inserted (ms : List (Move V E k)) : PiecesIn (inserted ms) ms := by
  intro m hm a ha
  exact ⟨m, hm, ha⟩

theorem Step.unique {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S : Set V} {lo : ℕ} {a b : Move V E k}
    (ha : Step g F tip choose z S lo a) (hb : Step g F tip choose z S lo b) :
    a = b := by
  have hi : a.index = b.index := Fin.ext (Nat.le_antisymm
    (hb.maximal a.index ha.eligible ha.hit)
    (ha.maximal b.index hb.eligible hb.hit))
  have hp : a.piece = b.piece := by
    rw [ha.piece_eq, hb.piece_eq, hi]
  have he : a.seam = b.seam := by
    rw [ha.seam_eq, hb.seam_eq, hi, hp]
  have hm : a.mask = b.mask := by
    rw [ha.mask_eq, hb.mask_eq, hp, he]
  exact Move.ext hi he hp hm

theorem ValidRun.unique {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S : Set V} {lo : ℕ} {as bs : List (Move V E k)}
    (ha : ValidRun g F tip choose z S lo as)
    (hb : ValidRun g F tip choose z S lo bs) : as = bs := by
  induction ha generalizing bs with
  | stop hz =>
    cases hb with
    | stop _ => rfl
    | cons st _ => exact False.elim (st.not_stop hz)
  | cons st tail ih =>
    cases hb with
    | stop hz => exact False.elim (st.not_stop hz)
    | cons st' tail' =>
      have hm := st.unique st'
      cases hm
      exact congrArg (List.cons _) (ih tail')

theorem Step.strip {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S T H : Set V} {lo : ℕ} {m : Move V E k}
    (st : Step g F tip choose z S lo m) (hB : m.piece ⊆ H)
    (hsep : g.Separated H T) :
    Step g F tip choose z (S \ T) lo m := by
  have hcomp := component_strip st.tip_out (st.piece_eq ▸ hB) hsep
  have hc := contacts_strip (F := F m.index) (S := S) hB hsep
  have hcontact : m.seam ∈ contacts g (F m.index) (S \ T) m.piece := by
    rw [hc]
    exact st.contact
  refine {
    not_stop := fun hz => st.not_stop hz.1
    eligible := st.eligible
    hit := ?_
    maximal := ?_
    tip_out := fun ht => st.tip_out ht.1
    piece_eq := st.piece_eq.trans hcomp.symm
    seam_eq := ?_
    contact := hcontact
    mask_eq := st.mask_eq.trans (mask_strip hB hsep).symm
  }
  · apply contact_hits (e := m.seam)
    rw [hcomp, ← st.piece_eq]
    exact hcontact
  · intro j hj ⟨b, hb, hbj⟩
    exact st.maximal j hj ⟨b, hb.1, hbj⟩
  · rw [hc]
    exact st.seam_eq

theorem ValidRun.strip {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S T H : Set V} {lo : ℕ} {ms : List (Move V E k)}
    (run : ValidRun g F tip choose z S lo ms)
    (hin : PiecesIn H ms) (hsep : g.Separated H T) (hz : z ∉ T) :
    ValidRun g F tip choose z (S \ T) lo ms := by
  induction run with
  | stop hs => exact .stop ⟨hs, hz⟩
  | @cons S lo m ms st tail ih =>
    have hm : m.piece ⊆ H := hin m (by simp)
    have ht : PiecesIn H ms := fun n hn => hin n (by simp [hn])
    have hset : (S ∪ m.piece) \ T = (S \ T) ∪ m.piece := by
      ext a
      have havoid : a ∈ m.piece → a ∉ T := fun ha =>
        fun haT => Set.disjoint_left.mp hsep.1 (hm ha) haT
      simp only [Set.mem_sdiff, Set.mem_union]
      aesop
    have htail := ih ht
    rw [hset] at htail
    exact .cons (st.strip hm hsep) htail

theorem stripped_history_unique {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S₁ S₂ T₁ T₂ H₁ H₂ : Set V} {lo : ℕ}
    {ms₁ ms₂ : List (Move V E k)}
    (r₁ : ValidRun g F tip choose z S₁ lo ms₁)
    (r₂ : ValidRun g F tip choose z S₂ lo ms₂)
    (hin₁ : PiecesIn H₁ ms₁) (hin₂ : PiecesIn H₂ ms₂)
    (sep₁ : g.Separated H₁ T₁) (sep₂ : g.Separated H₂ T₂)
    (hz₁ : z ∉ T₁) (hz₂ : z ∉ T₂)
    (hroot : S₁ \ T₁ = S₂ \ T₂) : ms₁ = ms₂ := by
  have a := r₁.strip hin₁ sep₁ hz₁
  have b := r₂.strip hin₂ sep₂ hz₂
  rw [hroot] at a
  exact a.unique b

theorem Step.mask_incident {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S : Set V} {lo : ℕ} {m : Move V E k}
    (st : Step g F tip choose z S lo m) {e : E} (he : e ∈ m.mask) :
    g.Incident m.piece e := by
  rw [st.mask_eq] at he
  rcases he with he | he
  · subst e
    exact st.contact.2.elim (fun h => Or.inl h.1) (fun h => Or.inr h.1)
  · exact he.1

def MaskSupport (g : Geometry V E) (H : Set V) (ms : List (Move V E k)) : Prop :=
  ∀ m ∈ ms, ∀ e ∈ m.mask, g.Incident H e

theorem ValidRun.maskSupport {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S H : Set V} {lo : ℕ} {ms : List (Move V E k)}
    (run : ValidRun g F tip choose z S lo ms) (hin : PiecesIn H ms) :
    MaskSupport g H ms := by
  induction run with
  | stop _ => simp [MaskSupport]
  | @cons S lo m ms st tail ih =>
    intro n hn e he
    rcases List.mem_cons.mp hn with hnm | hn
    · subst n
      have hp := hin m (by simp)
      exact (st.mask_incident he).elim (fun h => Or.inl (hp h))
        (fun h => Or.inr (hp h))
    · exact ih (fun n hn => hin n (by simp [hn])) n hn e he

theorem Reach.erase_hanging {g : Geometry V E} {F : Field E}
    {S T : Set V} {x y a : V} (h : Reach g F S x y)
    (hx : x ∉ T) (hy : y ∉ T)
    (cut : ∀ b ∈ T, ∀ c ∉ T, g.OpenAdj F b c → c = a) :
    Reach g F (S ∪ T) x y := by
  classical
  have hp : Reach g F (S ∪ T) x (if y ∈ T then a else y) := by
    clear hy
    induction h with
    | start hxS =>
      simpa [hx] using
        (Reach.start (g := g) (F := F) (a := x)
          (S := S ∪ T) (by simp [hxS, hx]))
    | @next b c hab hbc hcS ih =>
      by_cases hbT : b ∈ T
      · by_cases hcT : c ∈ T
        · simpa [hbT, hcT] using ih
        · have hca := cut b hbT c hcT hbc
          simpa [hbT, hcT, hca] using ih
      · by_cases hcT : c ∈ T
        · have hba := cut c hcT b hbT hbc.symm
          simpa [hbT, hcT, hba] using ih
        · have hib : Reach g F (S ∪ T) x b := by simpa [hbT] using ih
          have hic := Reach.next hib hbc (by simp [hcS, hcT])
          simpa [hcT] using hic
  simpa [hy] using hp

abbrev FieldId (k : ℕ) := Option (Bool × Fin k)
abbrev Coord (E : Type v) (k : ℕ) := FieldId k × E
abbrev Bits (E : Type v) (k : ℕ) := Coord E k → Bool

def flip (family : Bool) (i : Fin k) (M : Set E) (c : Coord E k) : Coord E k := by
  classical
  exact if c.2 ∈ M then ((Equiv.swap none (some (family, i))) c.1, c.2) else c

theorem flip_involutive (family : Bool) (i : Fin k) (M : Set E) :
    Function.Involutive (flip family i M) := by
  classical
  rintro ⟨f, e⟩
  by_cases he : e ∈ M
  · simp [flip, he, Equiv.swap_apply_self]
  · simp [flip, he]

def flipEquiv (family : Bool) (i : Fin k) (M : Set E) : Equiv.Perm (Coord E k) where
  toFun := flip family i M
  invFun := flip family i M
  left_inv := flip_involutive family i M
  right_inv := flip_involutive family i M

def swapBits (q : Bits E k) (family : Bool) (m : Move V E k) : Bits E k :=
  fun c => q (flip family m.index m.mask c)

theorem swapBits_involutive (q : Bits E k) (family : Bool) (m : Move V E k) :
    swapBits (swapBits q family m) family m = q := by
  funext c
  exact congrArg q (flip_involutive family m.index m.mask c)

def forward (q : Bits E k) (family : Bool) : List (Move V E k) → Bits E k
  | [] => q
  | m :: ms => forward (swapBits q family m) family ms

def undo (q : Bits E k) (family : Bool) (ms : List (Move V E k)) : Bits E k :=
  forward q family ms.reverse

theorem forward_append (q : Bits E k) (family : Bool)
    (as bs : List (Move V E k)) :
    forward q family (as ++ bs) = forward (forward q family as) family bs := by
  induction as generalizing q with
  | nil => rfl
  | cons m ms ih => exact ih (swapBits q family m)

theorem forward_reverse (q : Bits E k) (family : Bool)
    (ms : List (Move V E k)) :
    forward (forward q family ms) family ms.reverse = q := by
  induction ms generalizing q with
  | nil => rfl
  | cons m ms ih =>
    rw [forward, List.reverse_cons, forward_append, ih]
    exact swapBits_involutive q family m

theorem undo_forward (q : Bits E k) (family : Bool) (ms : List (Move V E k)) :
    undo (forward q family ms) family ms = q :=
  forward_reverse q family ms

theorem forward_undo (q : Bits E k) (family : Bool) (ms : List (Move V E k)) :
    forward (undo q family ms) family ms = q := by
  simpa [undo] using forward_reverse q family ms.reverse

theorem forward_fiber_congr {q r : Bits E k} (family : Bool)
    (ms : List (Move V E k)) {e : E}
    (h : ∀ f, q (f, e) = r (f, e)) :
    ∀ f, forward q family ms (f, e) = forward r family ms (f, e) := by
  classical
  induction ms generalizing q r with
  | nil => exact h
  | cons m ms ih =>
    apply ih
    intro f
    unfold swapBits flip
    split
    · exact h _
    · exact h _

theorem forward_outside {q : Bits E k} (family : Bool)
    (ms : List (Move V E k)) {e : E}
    (h : ∀ m ∈ ms, e ∉ m.mask) :
    ∀ f, forward q family ms (f, e) = q (f, e) := by
  classical
  induction ms generalizing q with
  | nil => intro _; rfl
  | cons m ms ih =>
    intro f
    rw [forward, ih (fun n hn => h n (by simp [hn]))]
    simp [swapBits, flip, h m (by simp)]

theorem forward_other {q : Bits E k} {a b : Bool} (hab : b ≠ a)
    (ms : List (Move V E k)) (i : Fin k) (e : E) :
    forward q a ms (some (b, i), e) = q (some (b, i), e) := by
  classical
  induction ms generalizing q with
  | nil => rfl
  | cons m ms ih =>
    rw [forward, ih]
    simp [swapBits, flip, Equiv.swap_apply_def, hab]

def aux (q : Bits E k) (family : Bool) : Fin k → Field E :=
  fun i e => q (some (family, i), e)

def distinguished (q : Bits E k) : Field E := fun e => q (none, e)

def root (g : Geometry V E) (q : Bits E k) (x : V) : Set V :=
  component g (distinguished q) ∅ x

def jointUndo (q : Bits E k) (as bs : List (Move V E k)) : Bits E k :=
  undo (undo q false as) true bs

theorem jointUndo_recover (q : Bits E k) (as bs : List (Move V E k)) :
    forward (forward (jointUndo q as bs) true bs) false as = q := by
  simp only [jointUndo, forward_undo]

theorem undo_outside {g : Geometry V E} {H : Set V}
    {ms : List (Move V E k)} (hs : MaskSupport g H ms)
    (q : Bits E k) (a : Bool) {e : E} (he : ¬ g.Incident H e) :
    ∀ f, undo q a ms (f, e) = q (f, e) := by
  apply forward_outside
  intro m hm heM
  exact he (hs m (List.mem_reverse.mp hm) e heM)

theorem separated_not_incident {g : Geometry V E} {H T : Set V}
    (hsep : g.Separated H T) {e : E} (he : g.Incident H e) :
    ¬ g.Incident T e := by
  have ht := hsep.avoid he
  exact fun h => h.elim ht.1 ht.2

theorem jointUndo_aux {g : Geometry V E} {H T : Set V}
    {as bs : List (Move V E k)} (hs : MaskSupport g H as)
    (ht : MaskSupport g T bs) (hsep : g.Separated H T) (q : Bits E k) :
    aux (jointUndo q as bs) false = aux (undo q false as) false ∧
      aux (jointUndo q as bs) true = aux (undo q true bs) true := by
  classical
  constructor
  · funext i e
    exact forward_other (by decide) bs.reverse i e
  · funext i e
    by_cases he : g.Incident H e
    · have heT := separated_not_incident hsep he
      change undo (undo q false as) true bs (some (true, i), e) =
        undo q true bs (some (true, i), e)
      rw [undo_outside ht _ _ heT, undo_outside ht _ _ heT]
      exact forward_other (by decide) as.reverse i e
    · exact forward_fiber_congr true bs.reverse (undo_outside hs q false he) _

theorem jointUndo_eq_first {g : Geometry V E} {T : Set V}
    {as bs : List (Move V E k)} (ht : MaskSupport g T bs)
    (q : Bits E k) {e : E} (he : ¬ g.Incident T e) :
    distinguished (jointUndo q as bs) e = distinguished (undo q false as) e :=
  undo_outside ht (undo q false as) true he none

theorem jointUndo_eq_second {g : Geometry V E} {H : Set V}
    {as bs : List (Move V E k)} (hs : MaskSupport g H as)
    (q : Bits E k) {e : E} (he : ¬ g.Incident H e) :
    distinguished (jointUndo q as bs) e = distinguished (undo q true bs) e :=
  forward_fiber_congr true bs.reverse (undo_outside hs q false he) none

theorem jointUndo_eq_output {g : Geometry V E} {H T : Set V}
    {as bs : List (Move V E k)} (hs : MaskSupport g H as)
    (ht : MaskSupport g T bs) (q : Bits E k) {e : E}
    (heH : ¬ g.Incident H e) (heT : ¬ g.Incident T e) :
    distinguished (jointUndo q as bs) e = distinguished q e := by
  rw [jointUndo_eq_first ht q heT]
  exact undo_outside hs q false heH none

theorem root_self (g : Geometry V E) (q : Bits E k) (x : V) :
    x ∈ root g q x :=
  Reach.start (by simp)

theorem root_closed {g : Geometry V E} {q : Bits E k} {x a b : V}
    (ha : a ∈ root g q x) (hab : g.OpenAdj (distinguished q) a b) :
    b ∈ root g q x :=
  Reach.next ha hab (by simp)

theorem incident_ends {g : Geometry V E} {A : Set V} {e : E} {a b : V}
    (h : (g.left e = a ∧ g.right e = b) ∨
      (g.right e = a ∧ g.left e = b)) :
    g.Incident A e ↔ a ∈ A ∨ b ∈ A := by
  rcases h with h | h
  · simp [Geometry.Incident, h.1, h.2]
  · simp [Geometry.Incident, h.1, h.2, or_comm]

theorem Reach.transfer {g : Geometry V E} {F G : Field E} {S : Set V} {a b : V}
    (h : Reach g F S a b)
    (agree : ∀ e, g.left e ∉ S → g.right e ∉ S → G e = F e) :
    Reach g G S a b := by
  induction h with
  | start ha => exact .start ha
  | @next b c hab hbc hc ih =>
    rcases hbc with ⟨e, he, hend⟩
    have heS : ¬ g.Incident S e := by
      rw [incident_ends hend]
      simp [hab.outside, hc]
    have hends : g.left e ∉ S ∧ g.right e ∉ S := by
      simpa [Geometry.Incident, not_or] using heS
    have heG : G e = true := (agree e hends.1 hends.2).trans he
    exact .next ih ⟨e, heG, hend⟩ hc

def Hanging (g : Geometry V E) (q : Bits E k) (H : Set V) : Prop :=
  ∃ a : V, ∀ b ∈ H, ∀ c ∉ H, g.OpenAdj (distinguished q) b c → c = a

theorem joint_root {g : Geometry V E} {H T : Set V}
    {as bs : List (Move V E k)} (hs : MaskSupport g H as)
    (ht : MaskSupport g T bs) (hsep : g.Separated H T)
    (q : Bits E k) (x : V)
    (hA : root g (undo q false as) x = root g q x \ H)
    (hB : root g (undo q true bs) x = root g q x \ T)
    (hangH : Hanging g q H) (hangT : Hanging g q T) :
    root g (jointUndo q as bs) x = root g q x \ (H ∪ T) := by
  classical
  have hxA := root_self g (undo q false as) x
  have hxB := root_self g (undo q true bs) x
  rw [hA] at hxA
  rw [hB] at hxB
  have hclosed : ∀ a ∈ root g q x \ (H ∪ T), ∀ b,
      g.OpenAdj (distinguished (jointUndo q as bs)) a b →
      b ∈ root g q x \ (H ∪ T) := by
    intro a ha b hab
    rcases hab with ⟨e, he, hend⟩
    have haH : a ∉ H := fun h => ha.2 (Or.inl h)
    have haT : a ∉ T := fun h => ha.2 (Or.inr h)
    have hbH : b ∉ H := by
      intro hbH
      have hiH : g.Incident H e := (incident_ends hend).mpr (Or.inr hbH)
      have hiT := separated_not_incident hsep hiH
      have heA : distinguished (undo q false as) e = true :=
        (jointUndo_eq_first ht q hiT).symm.trans he
      have haA : a ∈ root g (undo q false as) x := by rw [hA]; exact ⟨ha.1, haH⟩
      have hbA := root_closed haA ⟨e, heA, hend⟩
      rw [hA] at hbA
      exact hbA.2 hbH
    have hbT : b ∉ T := by
      intro hbT
      have hiT : g.Incident T e := (incident_ends hend).mpr (Or.inr hbT)
      have hiH := separated_not_incident hsep.symm hiT
      have heB : distinguished (undo q true bs) e = true :=
        (jointUndo_eq_second hs q hiH).symm.trans he
      have haB : a ∈ root g (undo q true bs) x := by rw [hB]; exact ⟨ha.1, haT⟩
      have hbB := root_closed haB ⟨e, heB, hend⟩
      rw [hB] at hbB
      exact hbB.2 hbT
    have hiH : ¬ g.Incident H e := by rw [incident_ends hend]; simp [haH, hbH]
    have hiT : ¬ g.Incident T e := by rw [incident_ends hend]; simp [haT, hbT]
    have heQ : distinguished q e = true :=
      (jointUndo_eq_output hs ht q hiH hiT).symm.trans he
    exact ⟨root_closed ha.1 ⟨e, heQ, hend⟩, by simpa [not_or] using And.intro hbH hbT⟩
  ext y
  constructor
  · intro hy
    induction hy with
    | start _ => exact ⟨hxA.1, by simpa [not_or] using And.intro hxA.2 hxB.2⟩
    | next _ hab _ ih => exact hclosed _ ih _ hab
  · intro hy
    rcases hangH with ⟨aH, cutH⟩
    rcases hangT with ⟨aT, cutT⟩
    have hyH : y ∉ H := fun h => hy.2 (Or.inl h)
    have hyT : y ∉ T := fun h => hy.2 (Or.inr h)
    have pathH := Reach.erase_hanging hy.1 hxA.2 hyH cutH
    have pathT := Reach.erase_hanging pathH hxB.2 hyT cutT
    have path : Reach g (distinguished q) (H ∪ T) x y := by simpa using pathT
    have lifted : Reach g (distinguished (jointUndo q as bs)) (H ∪ T) x y := by
      apply path.transfer
      intro e hl hr
      have hiH : ¬ g.Incident H e :=
        fun h => h.elim (fun h => hl (Or.inl h)) (fun h => hr (Or.inl h))
      have hiT : ¬ g.Incident T e :=
        fun h => h.elim (fun h => hl (Or.inr h)) (fun h => hr (Or.inr h))
      exact jointUndo_eq_output hs ht q hiH hiT
    exact lifted.mono (Set.empty_subset _)

structure Rules (V : Type u) (E : Type v) (k : ℕ) where
  endpoint : Bool → V
  chain : Bool → (Fin k → Field E) → Fin k → V
  success : Bool → (Fin k → Field E) → Prop
  choose : Bool → Fin k → Set E → E

structure SingleValid (g : Geometry V E) (rules : Rules V E k) (x : V)
    (q : Bits E k) (family : Bool) (ms : List (Move V E k)) : Prop where
  success : rules.success family (aux (undo q family ms) family)
  run : ValidRun g (aux (undo q family ms) family)
    (rules.chain family (aux (undo q family ms) family)) (rules.choose family)
    (rules.endpoint family) (root g (undo q family ms) x) 0 ms
  root_eq : root g (undo q family ms) x = root g q x \ inserted ms
  hanging : Hanging g q (inserted ms)
  endpoint : rules.endpoint family ∈ inserted ms

@[ext]
structure PairData (V : Type u) (E : Type v) (k : ℕ) where
  output : Bits E k
  first : List (Move V E k)
  second : List (Move V E k)

structure ValidPair (g : Geometry V E) (rules : Rules V E k) (x : V)
    (d : PairData V E k) : Prop where
  first : SingleValid g rules x d.output false d.first
  second : SingleValid g rules x d.output true d.second
  separated : g.Separated (inserted d.first) (inserted d.second)

theorem ValidPair.root_identities {g : Geometry V E} {rules : Rules V E k} {x : V}
    {d : PairData V E k} (valid : ValidPair g rules x d) :
    root g (jointUndo d.output d.first d.second) x =
        root g (undo d.output false d.first) x \ inserted d.second ∧
      root g (jointUndo d.output d.first d.second) x =
        root g (undo d.output true d.second) x \ inserted d.first := by
  have hs := valid.first.run.maskSupport (piecesIn_inserted d.first)
  have ht := valid.second.run.maskSupport (piecesIn_inserted d.second)
  have hroot := joint_root hs ht valid.separated d.output x valid.first.root_eq
    valid.second.root_eq valid.first.hanging valid.second.hanging
  constructor
  · rw [hroot, valid.first.root_eq]
    ext a
    simp [not_or, and_assoc]
  · rw [hroot, valid.second.root_eq]
    ext a
    simp [not_or, and_assoc, and_comm]

theorem ValidPair.virtualRuns {g : Geometry V E} {rules : Rules V E k} {x : V}
    {d : PairData V E k} (valid : ValidPair g rules x d) :
    let restored := jointUndo d.output d.first d.second
    ValidRun g (aux restored false) (rules.chain false (aux restored false))
      (rules.choose false) (rules.endpoint false) (root g restored x) 0 d.first ∧
    ValidRun g (aux restored true) (rules.chain true (aux restored true))
      (rules.choose true) (rules.endpoint true) (root g restored x) 0 d.second := by
  dsimp only
  have hs := valid.first.run.maskSupport (piecesIn_inserted d.first)
  have ht := valid.second.run.maskSupport (piecesIn_inserted d.second)
  have haux := jointUndo_aux hs ht valid.separated d.output
  have hroots := valid.root_identities
  constructor
  · have hz : rules.endpoint false ∉ inserted d.second :=
      fun h => Set.disjoint_left.mp valid.separated.1 valid.first.endpoint h
    have replay := valid.first.run.strip (piecesIn_inserted d.first) valid.separated hz
    rw [← hroots.1, ← haux.1] at replay
    exact replay
  · have hz : rules.endpoint true ∉ inserted d.first :=
      fun h => Set.disjoint_left.mp valid.separated.1.symm valid.second.endpoint h
    have replay := valid.second.run.strip (piecesIn_inserted d.second) valid.separated.symm hz
    rw [← hroots.2, ← haux.2] at replay
    exact replay

theorem joint_undo_injective (g : Geometry V E) (rules : Rules V E k) (x : V) :
    Function.Injective (fun d : {d : PairData V E k // ValidPair g rules x d} =>
      jointUndo d.val.output d.val.first d.val.second) := by
  intro a b hab
  change jointUndo a.val.output a.val.first a.val.second =
    jointUndo b.val.output b.val.first b.val.second at hab
  have ha := a.property.virtualRuns
  have hb := b.property.virtualRuns
  have hfirst : a.val.first = b.val.first := by
    have replay := ha.1
    rw [hab] at replay
    exact replay.unique hb.1
  have hsecond : a.val.second = b.val.second := by
    have replay := ha.2
    rw [hab] at replay
    exact replay.unique hb.2
  have hout : a.val.output = b.val.output := by
    calc
      a.val.output =
          forward (forward (jointUndo a.val.output a.val.first a.val.second) true a.val.second)
            false a.val.first := (jointUndo_recover _ _ _).symm
      _ = forward (forward (jointUndo b.val.output b.val.first b.val.second) true b.val.second)
            false b.val.first := by rw [hab, hfirst, hsecond]
      _ = b.val.output := jointUndo_recover _ _ _
  exact Subtype.ext (PairData.ext hout hfirst hsecond)

universe w

@[ext]
structure EncodedData (V : Type u) (E : Type v) (k : ℕ) (Code : Type w) where
  pair : PairData V E k
  firstCode : Code
  secondCode : Code

structure ValidEncoded (g : Geometry V E) (rules : Rules V E k) (x : V)
    (encode : Bool → Bits E k → List (Move V E k) → Code)
    (d : EncodedData V E k Code) : Prop where
  pair_valid : ValidPair g rules x d.pair
  first_eq : d.firstCode = encode false d.pair.output d.pair.first
  second_eq : d.secondCode = encode true d.pair.output d.pair.second

theorem code_free_joint_undo (g : Geometry V E) (rules : Rules V E k) (x : V)
    (encode : Bool → Bits E k → List (Move V E k) → Code) :
    Function.Injective
      (fun d : {d : EncodedData V E k Code // ValidEncoded g rules x encode d} =>
        jointUndo d.val.pair.output d.val.pair.first d.val.pair.second) := by
  intro a b hab
  change jointUndo a.val.pair.output a.val.pair.first a.val.pair.second =
    jointUndo b.val.pair.output b.val.pair.first b.val.pair.second at hab
  have hp : a.val.pair = b.val.pair := by
    have h := joint_undo_injective g rules x
      (a₁ := ⟨a.val.pair, a.property.pair_valid⟩)
      (a₂ := ⟨b.val.pair, b.property.pair_valid⟩) hab
    exact congrArg Subtype.val h
  apply Subtype.ext
  apply EncodedData.ext hp
  · rw [a.property.first_eq, b.property.first_eq, hp]
  · rw [a.property.second_eq, b.property.second_eq, hp]

def openCount [Fintype E] (q : Bits E k) : ℕ :=
  ∑ c : Coord E k, if q c then 1 else 0

theorem openCount_swap [Fintype E] (q : Bits E k) (family : Bool)
    (m : Move V E k) :
    openCount (swapBits q family m) = openCount q := by
  exact Equiv.sum_comp (flipEquiv family m.index m.mask) (fun c => if q c then 1 else 0)

theorem openCount_forward [Fintype E] (q : Bits E k) (family : Bool)
    (ms : List (Move V E k)) : openCount (forward q family ms) = openCount q := by
  induction ms generalizing q with
  | nil => rfl
  | cons m ms ih => rw [forward, ih, openCount_swap]

theorem openCount_jointUndo [Fintype E] (q : Bits E k)
    (as bs : List (Move V E k)) : openCount (jointUndo q as bs) = openCount q := by
  simp only [jointUndo, undo, openCount_forward]

def bernoulliWeight [Fintype E] (p : ℝ) (q : Bits E k) : ℝ :=
  p ^ openCount q * (1 - p) ^ (Fintype.card (Coord E k) - openCount q)

theorem bernoulliWeight_eq_product [Fintype E] (p : ℝ) (q : Bits E k) :
    bernoulliWeight p q = ∏ c : Coord E k, if q c then p else 1 - p := by
  classical
  let A : Finset (Coord E k) := Finset.univ.filter (fun c => q c = true)
  let B : Finset (Coord E k) := Finset.univ.filter (fun c => ¬ q c = true)
  have hcount : openCount q = A.card := by
    simp [openCount, A, Finset.sum_boole]
  have hB : B = Finset.univ \ A := by
    ext c
    simp [A, B]
  have hadd : B.card + A.card = Fintype.card (Coord E k) := by
    simpa [hB] using Finset.card_sdiff_add_card_inter Finset.univ A
  have hsub : Fintype.card (Coord E k) - A.card = B.card := by omega
  unfold bernoulliWeight
  rw [hcount, hsub, Finset.prod_ite, Finset.prod_const, Finset.prod_const]

theorem bernoulliWeight_jointUndo [Fintype E] (p : ℝ) (q : Bits E k)
    (as bs : List (Move V E k)) :
    bernoulliWeight p (jointUndo q as bs) = bernoulliWeight p q := by
  simp only [bernoulliWeight, openCount_jointUndo]

theorem bernoulliWeight_nonneg [Fintype E] {p : ℝ} (hp : 0 ≤ p) (hp' : p ≤ 1)
    (q : Bits E k) : 0 ≤ bernoulliWeight p q :=
  mul_nonneg (pow_nonneg hp _) (pow_nonneg (sub_nonneg.mpr hp') _)

theorem bernoulli_product_comparison [Fintype E]
    (g : Geometry V E) (rules : Rules V E k) (x : V)
    (encode : Bool → Bits E k → List (Move V E k) → Code)
    (s : Finset {d : EncodedData V E k Code // ValidEncoded g rules x encode d})
    (target : Finset (Bits E k)) {p : ℝ} (hp : 0 ≤ p) (hp' : p ≤ 1)
    (himage : ∀ d ∈ s,
      jointUndo d.val.pair.output d.val.pair.first d.val.pair.second ∈ target) :
    ∑ d ∈ s, bernoulliWeight p d.val.pair.output ≤
      ∑ q ∈ target, bernoulliWeight p q := by
  classical
  let f := fun d : {d : EncodedData V E k Code // ValidEncoded g rules x encode d} =>
    jointUndo d.val.pair.output d.val.pair.first d.val.pair.second
  have hinj : Function.Injective f := code_free_joint_undo g rules x encode
  calc
    ∑ d ∈ s, bernoulliWeight p d.val.pair.output =
        ∑ d ∈ s, bernoulliWeight p (f d) := by
      apply Finset.sum_congr rfl
      intro d _
      exact (bernoulliWeight_jointUndo p _ _ _).symm
    _ = ∑ q ∈ s.image f, bernoulliWeight p q :=
      (Finset.sum_image (fun a _ b _ hab => hinj hab)).symm
    _ ≤ ∑ q ∈ target, bernoulliWeight p q := by
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro q hq
        rcases Finset.mem_image.mp hq with ⟨d, hd, rfl⟩
        exact himage d hd
      · intro q _ _
        exact bernoulliWeight_nonneg hp hp' q

def trajectory (g : Geometry V E) (F : Fin k → Field E) (tip : Fin k → V) : Set V :=
  {a | ∃ i, a ∈ component g (F i) ∅ (tip i)}

theorem ValidRun.trajectory_hits {g : Geometry V E} {F : Fin k → Field E}
    {tip : Fin k → V} {choose : Fin k → Set E → E} {z : V}
    {S : Set V} {lo : ℕ} {ms : List (Move V E k)}
    (run : ValidRun g F tip choose z S lo ms) (hne : ms ≠ []) :
    ∃ a ∈ S, a ∈ trajectory g F tip := by
  cases run with
  | stop _ => exact False.elim (hne rfl)
  | @cons _ _ m _ st _ =>
    rcases st.hit with ⟨a, ha, hac⟩
    exact ⟨a, ha, m.index, hac⟩

theorem SingleValid.nonempty {g : Geometry V E} {rules : Rules V E k} {x : V}
    {q : Bits E k} {family : Bool} {ms : List (Move V E k)}
    (valid : SingleValid g rules x q family ms) : ms ≠ [] := by
  intro he
  have hz := valid.endpoint
  simp [he, inserted] at hz

def Reference (g : Geometry V E) (rules : Rules V E k) (x : V) (q : Bits E k) : Prop :=
  rules.success false (aux q false) ∧ rules.success true (aux q true) ∧
    (∃ a ∈ root g q x,
      a ∈ trajectory g (aux q false) (rules.chain false (aux q false))) ∧
    (∃ a ∈ root g q x,
      a ∈ trajectory g (aux q true) (rules.chain true (aux q true)))

theorem ValidPair.reference {g : Geometry V E} {rules : Rules V E k} {x : V}
    {d : PairData V E k} (valid : ValidPair g rules x d) :
    Reference g rules x (jointUndo d.output d.first d.second) := by
  have hs := valid.first.run.maskSupport (piecesIn_inserted d.first)
  have ht := valid.second.run.maskSupport (piecesIn_inserted d.second)
  have haux := jointUndo_aux hs ht valid.separated d.output
  refine ⟨?_, ?_, valid.virtualRuns.1.trajectory_hits valid.first.nonempty,
    valid.virtualRuns.2.trajectory_hits valid.second.nonempty⟩
  · rw [haux.1]
    exact valid.first.success
  · rw [haux.2]
    exact valid.second.success

def vertexCount [Fintype V] (S : Set V) : ℕ := by
  classical
  exact S.toFinset.card

theorem diff_size_window [Fintype V] {A B : Set V} {n v : ℕ}
    (hlo : n ≤ vertexCount A) (hhi : vertexCount A < 2 * n)
    (hB : vertexCount B ≤ v) :
    n - v ≤ vertexCount (A \ B) ∧ vertexCount (A \ B) < 2 * n := by
  classical
  simp only [vertexCount, Set.toFinset_sdiff] at hlo hhi hB ⊢
  have hid := Finset.card_sdiff_add_card_inter A.toFinset B.toFinset
  have hint := Finset.card_le_card
    (Finset.inter_subset_right (s₁ := A.toFinset) (s₂ := B.toFinset))
  have hdiff : (A.toFinset \ B.toFinset).card ≤ A.toFinset.card :=
    Finset.card_le_card (by intro a ha; exact (Finset.mem_sdiff.mp ha).1)
  omega

theorem ValidPair.root_window [Fintype V] {g : Geometry V E}
    {rules : Rules V E k} {x : V} {d : PairData V E k} (valid : ValidPair g rules x d)
    {n v : ℕ} (hlo : n ≤ vertexCount (root g (undo d.output false d.first) x))
    (hhi : vertexCount (root g (undo d.output false d.first) x) < 2 * n)
    (hB : vertexCount (inserted d.second) ≤ v) :
    n - v ≤ vertexCount (root g (jointUndo d.output d.first d.second) x) ∧
      vertexCount (root g (jointUndo d.output d.first d.second) x) < 2 * n := by
  rw [valid.root_identities.1]
  exact diff_size_window hlo hhi hB

def ReferenceWindow [Fintype V] (g : Geometry V E) (rules : Rules V E k)
    (x : V) (n v : ℕ) (q : Bits E k) : Prop :=
  n - v ≤ vertexCount (root g q x) ∧ vertexCount (root g q x) < 2 * n ∧
    Reference g rules x q

def referenceTuples [Fintype V] [Fintype E] (g : Geometry V E)
    (rules : Rules V E k) (x : V) (n v : ℕ) : Finset (Bits E k) := by
  classical
  exact Finset.univ.filter (ReferenceWindow g rules x n v)

theorem bernoulli_reference_comparison [Fintype V] [Fintype E]
    (g : Geometry V E) (rules : Rules V E k) (x : V)
    (encode : Bool → Bits E k → List (Move V E k) → Code)
    (s : Finset {d : EncodedData V E k Code // ValidEncoded g rules x encode d})
    (n v : ℕ) {p : ℝ} (hp : 0 ≤ p) (hp' : p ≤ 1)
    (hbins : ∀ d ∈ s,
      n ≤ vertexCount (root g (undo d.val.pair.output false d.val.pair.first) x) ∧
      vertexCount (root g (undo d.val.pair.output false d.val.pair.first) x) < 2 * n)
    (hcaps : ∀ d ∈ s, vertexCount (inserted d.val.pair.second) ≤ v) :
    ∑ d ∈ s, bernoulliWeight p d.val.pair.output ≤
      ∑ q ∈ referenceTuples g rules x n v, bernoulliWeight p q := by
  classical
  apply bernoulli_product_comparison g rules x encode s _ hp hp'
  intro d hd
  unfold referenceTuples
  apply Finset.mem_filter.mpr
  refine ⟨Finset.mem_univ _, ?_⟩
  have hw := d.property.pair_valid.root_window (hbins d hd).1 (hbins d hd).2 (hcaps d hd)
  exact ⟨hw.1, hw.2, d.property.pair_valid.reference⟩

#print axioms code_free_joint_undo
#print axioms bernoulli_reference_comparison

end JointSwitching
