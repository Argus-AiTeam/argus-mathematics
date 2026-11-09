import Mathlib

set_option autoImplicit false
set_option maxRecDepth 4096

namespace NestedLoss

abbrev Rel (X : Type) := X -> X -> Prop

variable {X : Type}

def comp (a b : Rel X) : Rel X := fun x y => exists z, a x z ∧ b z y
def rid : Rel X := Eq
def cl (a : Rel X) : Rel X := Relation.ReflTransGen a

infixr:75 " ;; " => comp

theorem ext {a b : Rel X} (h : ∀ x y, a x y ↔ b x y) : a = b :=
  funext fun x => funext fun y => propext (h x y)

theorem assoc (a b c : Rel X) : (a ;; b) ;; c = a ;; b ;; c := by
  apply ext
  intro x y
  simp only [comp]
  aesop

theorem sup_comp (a b c : Rel X) : (a ⊔ b) ;; c = (a ;; c) ⊔ (b ;; c) := by
  apply ext
  intro x y
  change (exists z, (a x z ∨ b x z) ∧ c z y) ↔
    (exists z, a x z ∧ c z y) ∨ (exists z, b x z ∧ c z y)
  aesop

theorem comp_sup (a b c : Rel X) : a ;; (b ⊔ c) = (a ;; b) ⊔ (a ;; c) := by
  apply ext
  intro x y
  change (exists z, a x z ∧ (b z y ∨ c z y)) ↔
    (exists z, a x z ∧ b z y) ∨ (exists z, a x z ∧ c z y)
  aesop

theorem mono {a b c d : Rel X} (h : a ≤ b) (k : c ≤ d) :
    a ;; c ≤ b ;; d := by
  rintro x y ⟨z, hx, hy⟩
  exact ⟨z, h _ _ hx, k _ _ hy⟩

theorem cl_refl (a : Rel X) (x : X) : cl a x x := .refl

theorem cl_trans {a : Rel X} {x y z : X} :
    cl a x y -> cl a y z -> cl a x z := Relation.ReflTransGen.trans

theorem cl_single {a : Rel X} {x y : X} (h : a x y) : cl a x y :=
  .single h

theorem cl_mono {a b : Rel X} (h : a ≤ b) : cl a ≤ cl b :=
  fun _ _ => Relation.ReflTransGen.mono h

theorem cl_min {a b : Rel X} (hr : ∀ x, b x x)
    (ht : ∀ x y z, b x y -> b y z -> b x z) (h : a ≤ b) : cl a ≤ b := by
  intro x y hp
  induction hp with
  | refl => exact hr _
  | tail _ he ih => exact ht _ _ _ ih (h _ _ he)

theorem cl_idem (a : Rel X) : cl a ;; cl a = cl a := by
  apply ext
  intro x y
  constructor
  · rintro ⟨z, h, k⟩
    exact cl_trans h k
  · intro h
    exact ⟨y, h, cl_refl _ _⟩

theorem cl_cl (a : Rel X) : cl (cl a) = cl a := by
  apply le_antisymm
  · exact cl_min (cl_refl a) (fun _ _ _ => cl_trans) le_rfl
  · exact fun _ _ h => cl_single h

theorem cl_union (a b : Rel X) :
    cl (a ⊔ b) = cl a ;; cl (b ;; cl a) := by
  apply ext
  intro x y
  constructor
  · intro h
    induction h using Relation.ReflTransGen.head_induction_on with
    | refl => exact ⟨_, .refl, .refl⟩
    | @head u v huv _ ih =>
      rcases ih with ⟨p, hvp, hpy⟩
      rcases huv with ha | hb
      · exact ⟨p, Relation.ReflTransGen.head ha hvp, hpy⟩
      · exact ⟨_, .refl, Relation.ReflTransGen.head ⟨v, hb, hvp⟩ hpy⟩
  · rintro ⟨p, hxp, hpy⟩
    apply cl_trans (cl_mono (show a ≤ a ⊔ b from le_sup_left) _ _ hxp)
    apply cl_min (cl_refl (a ⊔ b)) (fun _ _ _ => cl_trans) ?_ _ _ hpy
    rintro u v ⟨w, huw, hwv⟩
    exact cl_trans (cl_single (Or.inr huw))
      (cl_mono (show a ≤ a ⊔ b from le_sup_left) _ _ hwv)

theorem cl_slide (a b : Rel X) :
    a ;; cl (b ;; a) = cl (a ;; b) ;; a := by
  apply ext
  intro x y
  constructor
  · rintro ⟨p, hxp, hpy⟩
    induction hpy with
    | refl => exact ⟨x, .refl, hxp⟩
    | @tail u v _ huv ih =>
      rcases ih with ⟨q, hxq, hqu⟩
      rcases huv with ⟨w, huw, hwv⟩
      exact ⟨w, hxq.tail ⟨u, hqu, huw⟩, hwv⟩
  · rintro ⟨p, hxp, hpy⟩
    induction hxp using Relation.ReflTransGen.head_induction_on with
    | refl => exact ⟨y, hpy, .refl⟩
    | @head u v huv _ ih =>
      rcases huv with ⟨w, huw, hwv⟩
      rcases ih with ⟨q, hvq, hqy⟩
      exact ⟨w, huw, Relation.ReflTransGen.head ⟨v, hwv, hvq⟩ hqy⟩

theorem finite_idempotent_factor [Finite X] {a : Rel X}
    (ha : a ;; a = a) {x y : X} (hxy : a x y) :
    exists p, a x p ∧ a p p ∧ a p y := by
  classical
  have ht : ∀ u v w, a u v -> a v w -> a u w := by
    intro u v w huv hvw
    rw [← ha]
    exact ⟨v, huv, hvw⟩
  have split : ∀ u v, a u v -> exists w, a u w ∧ a w v := by
    intro u v huv
    rwa [← ha] at huv
  rcases split x y hxy with ⟨p, hxp, hpy⟩
  let S := {z : X // a x z ∧ a z y}
  let next : S -> S := fun z =>
    ⟨Classical.choose (split z.val y z.property.2),
      ht _ _ _ z.property.1 (Classical.choose_spec
        (split z.val y z.property.2)).1,
      (Classical.choose_spec (split z.val y z.property.2)).2⟩
  let f : Nat -> S := Nat.rec ⟨p, hxp, hpy⟩ (fun _ z => next z)
  have step (n : Nat) : a (f n).val (f (n + 1)).val :=
    (Classical.choose_spec (split (f n).val y (f n).property.2)).1
  have across : ∀ i j, i < j -> a (f i).val (f j).val := by
    intro i j
    induction j with
    | zero => omega
    | succ j ih =>
      intro hij
      by_cases he : i = j
      · subst i
        exact step j
      · exact ht _ _ _ (ih (by omega)) (step j)
  obtain ⟨i, j, hne, heq⟩ := Finite.exists_ne_map_eq_of_infinite f
  have loop : a (f i).val (f i).val := by
    rcases lt_or_gt_of_ne hne with hij | hji
    · simpa only [heq] using across i j hij
    · simpa only [heq] using across j i hji
  exact ⟨(f i).val, (f i).property.1, loop, (f i).property.2⟩

structure Diagram (X : Type) where
  F : Rel X
  B : Rel X
  L : Rel X
  R : Rel X

namespace Diagram

def flip (e : Diagram X) : Diagram X := ⟨e.B, e.F, e.R, e.L⟩

def mul (e d : Diagram X) : Diagram X where
  F := e.F ;; cl (d.L ;; e.R) ;; d.F
  B := d.B ;; cl (e.R ;; d.L) ;; e.B
  L := e.L ⊔ e.F ;; cl (d.L ;; e.R) ;; d.L ;; e.B
  R := d.R ⊔ d.B ;; cl (e.R ;; d.L) ;; e.R ;; d.F

def Idem (e : Diagram X) : Prop := mul e e = e
def Nested (d e : Diagram X) : Prop := mul e d = d ∧ mul d e = d
def K (e : Diagram X) : Rel X := cl (e.L ;; e.R)
def P (e : Diagram X) : Rel X := e.K ;; e.F ;; e.K
def U (e d : Diagram X) : Rel X := e.K ;; d.F ;; e.K

theorem product_R_matches (e d : Diagram X) :
    (mul e d).R = d.R ⊔ d.B ;; e.R ;; cl (d.L ;; e.R) ;; d.F := by
  have h := congrArg (fun r => d.R ⊔ d.B ;; r ;; d.F) (cl_slide e.R d.L)
  simpa only [mul, assoc] using h.symm

theorem flip_flip (e : Diagram X) : e.flip.flip = e := rfl

theorem flip_mul (e d : Diagram X) : (mul e d).flip = mul d.flip e.flip := rfl

theorem idem_flip {e : Diagram X} (h : e.Idem) : e.flip.Idem := by
  change (mul e e).flip = e.flip
  rw [h]

theorem nested_flip {d e : Diagram X} (h : d.Nested e) :
    d.flip.Nested e.flip := by
  constructor
  · change (mul d e).flip = d.flip
    rw [h.2]
  · change (mul e d).flip = d.flip
    rw [h.1]

theorem through_idem {e : Diagram X} (h : e.Idem) :
    e.F ;; e.K ;; e.F = e.F := congrArg Diagram.F h

theorem P_idem {e : Diagram X} (h : e.Idem) : e.P ;; e.P = e.P := by
  apply ext
  intro x z
  constructor
  · rintro ⟨y, ⟨a, hxa, b, hab, hby⟩, c, hyc, d, hcd, hdz⟩
    have had : (e.F ;; e.K ;; e.F) a d :=
      ⟨b, hab, c, cl_trans hby hyc, hcd⟩
    rw [through_idem h] at had
    exact ⟨a, hxa, d, had, hdz⟩
  · rintro ⟨a, hxa, d, had, hdz⟩
    rw [← through_idem h] at had
    rcases had with ⟨b, hab, c, hbc, hcd⟩
    exact ⟨b, ⟨a, hxa, b, hab, .refl⟩, c, hbc, d, hcd, hdz⟩

theorem P_trans {e : Diagram X} (h : e.Idem) {x y z : X}
    (hxy : e.P x y) (hyz : e.P y z) : e.P x z := by
  rw [← P_idem h]
  exact ⟨y, hxy, hyz⟩

theorem KP (e : Diagram X) : e.K ;; e.P = e.P := by
  dsimp [P, K]
  rw [← assoc, cl_idem]

theorem PK (e : Diagram X) : e.P ;; e.K = e.P := by
  dsimp [P, K]
  rw [assoc, assoc, cl_idem]

theorem nested_returns {d e : Diagram X} (h : d.Nested e) :
    e.L ≤ d.L ∧ e.R ≤ d.R := by
  constructor
  · have he := congrArg Diagram.L h.1
    change e.L ⊔ _ = d.L at he
    exact le_sup_left.trans_eq he
  · have he := congrArg Diagram.R h.2
    change e.R ⊔ _ = d.R at he
    exact le_sup_left.trans_eq he

theorem nested_K {d e : Diagram X} (h : d.Nested e) : e.K ≤ d.K :=
  cl_mono (mono (nested_returns h).1 (nested_returns h).2)

theorem nested_left {d e : Diagram X} (h : d.Nested e) :
    e.F ;; cl (d.L ;; e.R) ;; d.F = d.F := congrArg Diagram.F h.1

theorem nested_right {d e : Diagram X} (h : d.Nested e) :
    d.F ;; cl (e.L ;; d.R) ;; e.F = d.F := congrArg Diagram.F h.2

theorem nested_L {d e : Diagram X} (h : d.Nested e) :
    e.F ;; cl (d.L ;; e.R) ;; d.L ;; e.B ≤ d.L := by
  have he := congrArg Diagram.L h.1
  change e.L ⊔ _ = d.L at he
  exact le_sup_right.trans_eq he

theorem nested_R {d e : Diagram X} (h : d.Nested e) :
    e.B ;; d.R ;; cl (e.L ;; d.R) ;; e.F ≤ d.R := by
  have he := congrArg Diagram.R h.2
  change e.R ⊔ _ = d.R at he
  have hs := cl_slide d.R e.L
  have hs' := congrArg (fun r => e.B ;; r ;; e.F) hs
  simp only [assoc] at hs'
  rw [← hs'] at he
  exact le_sup_right.trans_eq he

theorem nested_R_eq {d e : Diagram X} (h : d.Nested e) :
    d.R = e.R ⊔ e.B ;; d.R ;; cl (e.L ;; d.R) ;; e.F := by
  have he := congrArg Diagram.R h.2
  change e.R ⊔ _ = d.R at he
  have hs := congrArg (fun r => e.B ;; r ;; e.F) (cl_slide d.R e.L)
  simp only [assoc] at hs
  rw [← hs] at he
  exact he.symm

theorem nested_L_eq {d e : Diagram X} (h : d.Nested e) :
    d.L = e.L ⊔ e.F ;; cl (d.L ;; e.R) ;; d.L ;; e.B :=
  (congrArg Diagram.L h.1).symm

theorem left_star_absorption {d e : Diagram X} (h : d.Nested e) :
    e.F ;; d.K ;; d.F ≤ d.K ;; d.F := by
  let S := cl (d.L ;; e.R)
  let T := cl (e.L ;; d.R)
  let A := d.L ;; e.B ;; d.R ;; T
  have hK : d.K = S ;; cl (A ;; (e.F ;; S)) := by
    change cl (d.L ;; d.R) = _
    conv_lhs => rw [nested_R_eq h]
    rw [comp_sup, cl_union]
    simp only [A, S, T, assoc]
  have hT : T ≤ d.K := cl_mono (mono (nested_returns h).1 le_rfl)
  have hgen : (e.F ;; S) ;; A ≤ d.K := by
    have h1 := mono (nested_L h) (le_rfl : d.R ;; T ≤ d.R ;; T)
    have h2 : (d.L ;; d.R) ;; T ≤ d.K :=
      (mono (fun _ _ hp => cl_single hp) hT).trans (cl_idem _).le
    calc
      _ ≤ d.L ;; d.R ;; T := by simpa only [A, S, assoc] using h1
      _ ≤ d.K := by simpa only [assoc] using h2
  have hstar : cl ((e.F ;; S) ;; A) ≤ d.K :=
    cl_min (cl_refl _) (fun _ _ _ => cl_trans) hgen
  have heq : e.F ;; d.K ;; d.F =
      cl ((e.F ;; S) ;; A) ;; d.F := by
    rw [hK]
    calc
      _ = ((e.F ;; S) ;; cl (A ;; (e.F ;; S))) ;; d.F := by
        simp only [assoc]
      _ = (cl ((e.F ;; S) ;; A) ;; (e.F ;; S)) ;; d.F := by
        rw [cl_slide]
      _ = cl ((e.F ;; S) ;; A) ;; (e.F ;; S ;; d.F) := by
        simp only [assoc]
      _ = _ := by rw [nested_left h]
  rw [heq]
  exact mono hstar le_rfl

theorem right_star_absorption {d e : Diagram X} (h : d.Nested e) :
    d.F ;; d.K ;; e.F ≤ d.F ;; d.K := by
  let S := cl (d.L ;; e.R)
  let T := cl (e.L ;; d.R)
  let A := S ;; d.L ;; e.B ;; d.R ;; T
  have hK : d.K = T ;; cl (e.F ;; A) := by
    change cl (d.L ;; d.R) = _
    conv_lhs => rw [nested_L_eq h]
    rw [sup_comp, cl_union]
    simp only [A, S, T, assoc]
  have hS : S ≤ d.K := cl_mono (mono le_rfl (nested_returns h).2)
  have hgen : A ;; e.F ≤ d.K := by
    have h1 := mono (le_rfl : S ;; d.L ≤ S ;; d.L) (nested_R h)
    have h2 : S ;; d.L ;; d.R ≤ d.K :=
      (mono hS (fun _ _ hp => cl_single hp)).trans (cl_idem _).le
    calc
      _ ≤ S ;; d.L ;; d.R := by simpa only [A, T, assoc] using h1
      _ ≤ d.K := h2
  have hstar : cl (A ;; e.F) ≤ d.K :=
    cl_min (cl_refl _) (fun _ _ _ => cl_trans) hgen
  have heq : d.F ;; d.K ;; e.F = d.F ;; cl (A ;; e.F) := by
    rw [hK]
    calc
      _ = (d.F ;; T) ;; (cl (e.F ;; A) ;; e.F) := by
        simp only [assoc]
      _ = (d.F ;; T) ;; (e.F ;; cl (A ;; e.F)) := by
        rw [← cl_slide]
      _ = (d.F ;; T ;; e.F) ;; cl (A ;; e.F) := by
        simp only [assoc]
      _ = _ := by rw [nested_right h]
  rw [heq]
  exact mono le_rfl hstar

theorem through_absorption {d e : Diagram X} (h : d.Nested e) :
    e.F ;; d.P ≤ d.P ∧ d.P ;; e.F ≤ d.P := by
  constructor
  · have hm := mono (left_star_absorption h) (le_rfl : d.K ≤ d.K)
    simpa only [P, assoc] using hm
  · have hm := mono (le_rfl : d.K ≤ d.K) (right_star_absorption h)
    simpa only [P, assoc] using hm

theorem absorption {d e : Diagram X} (h : d.Nested e) :
    e.P ;; d.P ≤ d.P ∧ d.P ;; e.P ≤ d.P := by
  have hk : e.K ;; d.P ≤ d.P :=
    (mono (nested_K h) le_rfl).trans (KP d).le
  have kh : d.P ;; e.K ≤ d.P :=
    (mono le_rfl (nested_K h)).trans (PK d).le
  constructor
  · have h1 := mono (le_rfl : e.K ≤ e.K)
      ((mono (le_rfl : e.F ≤ e.F) hk).trans (through_absorption h).1)
    simpa only [P, assoc] using h1.trans hk
  · have h1 := (mono kh (le_rfl : e.F ≤ e.F)).trans
      (through_absorption h).2
    have h2 := (mono h1 (le_rfl : e.K ≤ e.K)).trans kh
    simpa only [P, assoc] using h2

theorem corner_absorption_of {d e : Diagram X}
    (hleft : e.F ;; e.K ;; d.F ≤ d.F)
    (hright : d.F ;; e.K ;; e.F ≤ d.F) :
    e.P ;; e.U d ≤ e.U d ∧ e.U d ;; e.P ≤ e.U d := by
  constructor
  · rintro x z ⟨y, ⟨a, hxa, b, hab, hby⟩, c, hyc, f, hcf, hfz⟩
    exact ⟨a, hxa, f, hleft _ _ ⟨b, hab, c, cl_trans hby hyc, hcf⟩, hfz⟩
  · rintro x z ⟨y, ⟨a, hxa, b, hab, hby⟩, c, hyc, f, hcf, hfz⟩
    exact ⟨a, hxa, f, hright _ _ ⟨b, hab, c, cl_trans hby hyc, hcf⟩, hfz⟩

theorem corner_absorption {d e : Diagram X} (h : d.Nested e) :
    e.P ;; e.U d ≤ e.U d ∧ e.U d ;; e.P ≤ e.U d := by
  have hleft : e.F ;; e.K ;; d.F ≤ d.F :=
    (mono le_rfl (mono
      (cl_mono (mono (nested_returns h).1 le_rfl)) le_rfl)).trans
      (nested_left h).le
  have hright : d.F ;; e.K ;; e.F ≤ d.F :=
    (mono le_rfl (mono
      (cl_mono (mono le_rfl (nested_returns h).2)) le_rfl)).trans
      (nested_right h).le
  exact corner_absorption_of hleft hright

theorem rectangle_factor [Finite X] {e : Diagram X} (he : e.Idem)
    {x y : X} (hxy : e.F x y) :
    exists p, e.P p p ∧ (e.F ;; e.K) x p ∧ (e.K ;; e.F) p y := by
  have hq : (e.F ;; e.K) ;; (e.F ;; e.K) = e.F ;; e.K := by
    calc
      _ = (e.F ;; e.K ;; e.F) ;; e.K := by simp only [assoc]
      _ = _ := by rw [through_idem he]
  rw [← through_idem he] at hxy
  rcases hxy with ⟨a, hxa, b, hab, hby⟩
  obtain ⟨p, hxp, hpp, hpb⟩ :=
    finite_idempotent_factor hq (show (e.F ;; e.K) x b from ⟨a, hxa, hab⟩)
  have hpy : e.F p y := by
    rw [← through_idem he]
    rcases hpb with ⟨c, hpc, hcb⟩
    exact ⟨c, hpc, b, hcb, hby⟩
  exact ⟨p, ⟨p, .refl, hpp⟩, hxp, p, .refl, hpy⟩

theorem containment_witness [Finite X] {d e : Diagram X}
    (he : e.Idem) (hd : d.Idem) (h : d.Nested e)
    {x : X} (hxx : d.P x x) :
    exists p q, e.P p p ∧ e.P q q ∧
      d.P x p ∧ d.P p x ∧ d.P x q ∧ d.P q x ∧ e.U d p q := by
  let S := cl (d.L ;; e.R)
  let T := cl (e.L ;; d.R)
  have hf : d.F = e.F ;; S ;; d.F ;; T ;; e.F := by
    calc
      d.F = e.F ;; S ;; d.F := (nested_left h).symm
      _ = e.F ;; S ;; (d.F ;; T ;; e.F) := by rw [nested_right h]
      _ = _ := rfl
  have hb : (e.K ;; e.F ;; S ;; d.F ;; T ;; e.F ;; e.K) = e.U d := by
    simpa only [U, assoc] using congrArg (fun r => e.K ;; r ;; e.K) hf.symm
  have loop := hxx
  rcases hxx with ⟨a, hxa, b, hab, hbx⟩
  rw [hf] at hab
  rcases hab with ⟨a1, haa1, a2, ha1a2, a3, ha2a3, a4, ha3a4, ha4b⟩
  obtain ⟨p, hpp, ⟨r, har, hrp⟩, ⟨s, hps, hsa1⟩⟩ := rectangle_factor he haa1
  obtain ⟨q, hqq, ⟨t, ha4t, htq⟩, ⟨u, hqu, hub⟩⟩ := rectangle_factor he ha4b
  have hpq : e.U d p q := by
    rw [← hb]
    exact ⟨s, hps, a1, hsa1, a2, ha1a2, a3, ha2a3, a4, ha3a4, t, ha4t, htq⟩
  have hpqd : d.P p q := mono (nested_K h)
    (mono le_rfl (nested_K h)) _ _ hpq
  have hxp : d.P x p := by
    have h1 := (PK d).le _ _ ⟨x, loop, hxa⟩
    have h2 := (through_absorption h).2 _ _ ⟨a, h1, har⟩
    exact (PK d).le _ _ ⟨r, h2, nested_K h _ _ hrp⟩
  have hqx : d.P q x := by
    have h1 : d.P b x := (KP d).le _ _ ⟨x, hbx, loop⟩
    have h2 : d.P u x := (through_absorption h).1 _ _ ⟨b, hub, h1⟩
    exact (KP d).le _ _ ⟨u, nested_K h _ _ hqu, h2⟩
  exact ⟨p, q, hpp, hqq, hxp, P_trans hd hpqd hqx,
    P_trans hd hxp hpqd, hqx, hpq⟩

end Diagram

noncomputable def classOf [Fintype X] (p : Rel X) (x : X) : Finset X := by
  classical
  exact Finset.univ.filter fun y => p x y ∧ p y x

noncomputable def classes [Fintype X] (p : Rel X) : Finset (Finset X) := by
  classical
  exact (Finset.univ.filter fun x => p x x).image (classOf p)

noncomputable def missing [Fintype X] (p u : Rel X) : Finset (Finset X) := by
  classical
  exact (classes p).filter fun c => ¬ ∃ x ∈ c, u x x

theorem mem_class [Fintype X] {p : Rel X} {x y : X} :
    y ∈ classOf p x ↔ p x y ∧ p y x := by
  classical
  simp [classOf]

theorem mem_classes [Fintype X] {p : Rel X} {c : Finset X} :
    c ∈ classes p ↔ exists x, p x x ∧ classOf p x = c := by
  classical
  simp [classes]

theorem mem_missing [Fintype X] {p u : Rel X} {c : Finset X} :
    c ∈ missing p u ↔ c ∈ classes p ∧ ¬ ∃ x ∈ c, u x x := by
  classical
  simp [missing]

theorem not_missing [Fintype X] {p u : Rel X} {c : Finset X}
    (hc : c ∈ classes p) : c ∉ missing p u ↔ ∃ x ∈ c, u x x := by
  classical
  simp [missing, hc]

theorem class_mem [Fintype X] {p : Rel X} {x : X} (hx : p x x) :
    classOf p x ∈ classes p := mem_classes.mpr ⟨x, hx, rfl⟩

theorem class_nonempty [Fintype X] {p : Rel X} {c : Finset X}
    (hc : c ∈ classes p) : c.Nonempty := by
  obtain ⟨x, hx, rfl⟩ := mem_classes.mp hc
  exact ⟨x, mem_class.mpr ⟨hx, hx⟩⟩

theorem class_eq [Fintype X] {p : Rel X}
    (ht : ∀ x y z, p x y -> p y z -> p x z)
    {x y : X} (hxy : p x y) (hyx : p y x) : classOf p x = classOf p y := by
  apply Finset.ext
  intro z
  rw [mem_class, mem_class]
  constructor
  · rintro ⟨hxz, hzx⟩
    exact ⟨ht _ _ _ hyx hxz, ht _ _ _ hzx hxy⟩
  · rintro ⟨hyz, hzy⟩
    exact ⟨ht _ _ _ hxy hyz, ht _ _ _ hzy hyx⟩

theorem class_of_member [Fintype X] {p : Rel X}
    (ht : ∀ x y z, p x y -> p y z -> p x z)
    {c : Finset X} (hc : c ∈ classes p) {x : X} (hx : x ∈ c) :
    p x x ∧ classOf p x = c := by
  obtain ⟨y, hy, rfl⟩ := mem_classes.mp hc
  obtain ⟨hyx, hxy⟩ := mem_class.mp hx
  exact ⟨ht _ _ _ hxy hyx, class_eq ht hxy hyx⟩

theorem classes_disjoint [Fintype X] {p : Rel X}
    (ht : ∀ x y z, p x y -> p y z -> p x z)
    {c d : Finset X} (hc : c ∈ classes p) (hd : d ∈ classes p)
    (hne : c ≠ d) : Disjoint c d := by
  apply Finset.disjoint_left.mpr
  intro x hxc hxd
  exact hne ((class_of_member ht hc hxc).2.symm.trans
    (class_of_member ht hd hxd).2)

theorem uniform_loop [Fintype X] {p u : Rel X}
    (ht : ∀ x y z, p x y -> p y z -> p x z)
    (hleft : p ;; u ≤ u) (hright : u ;; p ≤ u)
    {c : Finset X} (hc : c ∈ classes p) {x y : X}
    (hx : x ∈ c) (hy : y ∈ c) (hyy : u y y) : u x x := by
  have hcx := (class_of_member ht hc hx).2
  rw [← hcx] at hy
  obtain ⟨hxy, hyx⟩ := mem_class.mp hy
  exact hright _ _ ⟨y, hleft _ _ ⟨y, hxy, hyy⟩, hyx⟩

theorem missing_iff_at [Fintype X] {p u : Rel X}
    (ht : ∀ x y z, p x y -> p y z -> p x z)
    (hleft : p ;; u ≤ u) (hright : u ;; p ≤ u)
    {c : Finset X} (hc : c ∈ classes p) {x : X} (hx : x ∈ c) :
    c ∈ missing p u ↔ ¬ u x x := by
  constructor
  · intro hm hxx
    exact (mem_missing.mp hm).2 ⟨x, hx, hxx⟩
  · intro hn
    refine mem_missing.mpr ⟨hc, ?_⟩
    rintro ⟨y, hy, hyy⟩
    exact hn (uniform_loop ht hleft hright hc hx hy hyy)

noncomputable def unprotected [Fintype X] (p : Rel X) (t : Finset X) :
    Finset (Finset X) := by
  classical
  exact (classes p).filter fun c => Disjoint c t

theorem mem_unprotected [Fintype X] {p : Rel X} {t c : Finset X} :
    c ∈ unprotected p t ↔ c ∈ classes p ∧ Disjoint c t := by
  classical
  simp [unprotected]

theorem step_budget [Fintype X] {p q u : Rel X} (t : Finset X)
    (hq : ∀ x y z, q x y -> q y z -> q x z)
    (hm : missing p u ⊆ unprotected p t)
    (hc : ∀ c ∈ classes q,
      (∃ a ∈ classes p, a ⊆ c ∧ a ∉ missing p u) ∨
      ∃ a ∈ classes p, ∃ b ∈ classes p, a ≠ b ∧ a ⊆ c ∧ b ⊆ c) :
    2 * (unprotected q t).card + (missing p u).card ≤
      2 * (unprotected p t).card := by
  classical
  let S := unprotected p t
  let V := unprotected q t
  let M := missing p u
  let w : Finset X -> Nat := fun a => if a ∈ M then 1 else 2
  let support : Finset X -> Finset (Finset X) :=
    fun c => S.filter fun a => a ⊆ c
  have enough : ∀ c ∈ V, 2 ≤ ∑ a ∈ support c, w a := by
    intro c hcv
    obtain ⟨hcq, hct⟩ := mem_unprotected.mp hcv
    have hs {a : Finset X} (ha : a ∈ classes p) (hac : a ⊆ c) :
        a ∈ support c := by
      apply Finset.mem_filter.mpr
      refine ⟨mem_unprotected.mpr ⟨ha, ?_⟩, hac⟩
      exact Finset.disjoint_left.mpr fun x hxa hxt =>
        Finset.disjoint_left.mp hct (hac hxa) hxt
    rcases hc c hcq with ⟨a, ha, hac, han⟩ | ⟨a, ha, b, hb, hab, hac, hbc⟩
    · have hwa : w a = 2 := by simp [w, M, han]
      have hsum := Finset.single_le_sum (fun a _ => Nat.zero_le (w a)) (hs ha hac)
      omega
    · have hsub : ({a, b} : Finset (Finset X)) ⊆ support c := by
        intro r hr
        simp only [Finset.mem_insert, Finset.mem_singleton] at hr
        rcases hr with rfl | rfl
        · exact hs ha hac
        · exact hs hb hbc
      have hwa : 1 ≤ w a := by dsimp [w]; split_ifs <;> omega
      have hwb : 1 ≤ w b := by dsimp [w]; split_ifs <;> omega
      calc
        2 ≤ w a + w b := by omega
        _ = ∑ r ∈ ({a, b} : Finset (Finset X)), w r := by simp [hab]
        _ ≤ _ := Finset.sum_le_sum_of_subset hsub
  have hdis : Set.PairwiseDisjoint (↑V) support := by
    intro c hc d hd hne
    apply Finset.disjoint_left.mpr
    intro a hac had
    obtain ⟨ha, hsubc⟩ := Finset.mem_filter.mp hac
    obtain ⟨_, hsubd⟩ := Finset.mem_filter.mp had
    obtain ⟨x, hxa⟩ := class_nonempty (mem_unprotected.mp ha).1
    have hcd := classes_disjoint hq (mem_unprotected.mp hc).1
      (mem_unprotected.mp hd).1 hne
    exact Finset.disjoint_left.mp hcd (hsubc hxa) (hsubd hxa)
  have hunion : V.biUnion support ⊆ S := by
    intro a ha
    obtain ⟨c, _, hac⟩ := Finset.mem_biUnion.mp ha
    exact (Finset.mem_filter.mp hac).1
  have budget : 2 * V.card ≤ ∑ a ∈ S, w a := by
    calc
      2 * V.card = ∑ c ∈ V, 2 := by simp [Nat.mul_comm]
      _ ≤ ∑ c ∈ V, ∑ a ∈ support c, w a := Finset.sum_le_sum enough
      _ = ∑ a ∈ V.biUnion support, w a := (Finset.sum_biUnion hdis).symm
      _ ≤ _ := Finset.sum_le_sum_of_subset hunion
  have hfilter : S.filter (fun a => a ∈ M) = M := by
    apply Finset.ext
    intro a
    simp only [Finset.mem_filter]
    exact ⟨And.right, fun ha => ⟨hm ha, ha⟩⟩
  have indicator : (∑ a ∈ S, if a ∈ M then 1 else 0) = M.card := by
    rw [← Finset.card_filter, hfilter]
  have mass : (∑ a ∈ S, w a) + M.card = 2 * S.card := by
    calc
      _ = ∑ a ∈ S, (w a + if a ∈ M then 1 else 0) := by
        rw [Finset.sum_add_distrib, indicator]
      _ = ∑ a ∈ S, 2 := by
        apply Finset.sum_congr rfl
        intro a _
        dsimp [w]
        split_ifs <;> rfl
      _ = _ := by simp [Nat.mul_comm]
  change 2 * V.card + M.card ≤ 2 * S.card
  omega

noncomputable def protectedLabels [Fintype X] (p : Rel X)
    (j : Finset (Finset X)) : Finset X := by
  classical
  exact ((classes p) \ j).biUnion id

theorem mem_protected [Fintype X] {p : Rel X}
    {j : Finset (Finset X)} {x : X} :
    x ∈ protectedLabels p j ↔ ∃ c ∈ classes p, c ∉ j ∧ x ∈ c := by
  classical
  simp [protectedLabels, and_assoc]

theorem initial_unprotected [Fintype X] {p : Rel X}
    (hp : ∀ x y z, p x y -> p y z -> p x z)
    {j : Finset (Finset X)} (hj : j ⊆ classes p) :
    unprotected p (protectedLabels p j) = j := by
  classical
  apply Finset.ext
  intro c
  constructor
  · intro hc
    obtain ⟨hcc, hct⟩ := mem_unprotected.mp hc
    by_contra hcn
    obtain ⟨x, hx⟩ := class_nonempty hcc
    exact Finset.disjoint_left.mp hct hx
      (mem_protected.mpr ⟨c, hcc, hcn, hx⟩)
  · intro hc
    refine mem_unprotected.mpr ⟨hj hc, Finset.disjoint_left.mpr ?_⟩
    intro x hxc hxt
    obtain ⟨d, hd, hdn, hxd⟩ := mem_protected.mp hxt
    have heq : c = d := (class_of_member hp (hj hc) hxc).2.symm.trans
      (class_of_member hp hd hxd).2
    exact hdn (heq ▸ hc)

theorem containment_from_witness [Fintype X] {p q u : Rel X}
    (_hp : ∀ x y z, p x y -> p y z -> p x z)
    (hpq : p ;; q ≤ q) (hqp : q ;; p ≤ q) (hup : u ;; p ≤ u)
    (hw : ∀ x, q x x -> exists a b, p a a ∧ p b b ∧
      q x a ∧ q a x ∧ q x b ∧ q b x ∧ u a b) :
    ∀ c ∈ classes q,
      (∃ a ∈ classes p, a ⊆ c ∧ a ∉ missing p u) ∨
      ∃ a ∈ classes p, ∃ b ∈ classes p,
        a ≠ b ∧ a ⊆ c ∧ b ⊆ c := by
  classical
  intro c hc
  obtain ⟨x, hx, rfl⟩ := mem_classes.mp hc
  obtain ⟨a, b, haa, hbb, hxa, hax, hxb, hbx, hab⟩ := hw x hx
  have hs {z : X} (hxz : q x z) (hzx : q z x) :
      classOf p z ⊆ classOf q x := by
    intro r hr
    obtain ⟨hzr, hrz⟩ := mem_class.mp hr
    exact mem_class.mpr ⟨hqp _ _ ⟨z, hxz, hzr⟩, hpq _ _ ⟨z, hrz, hzx⟩⟩
  by_cases heq : classOf p a = classOf p b
  · apply Or.inl
    refine ⟨classOf p a, class_mem haa, hs hxa hax, ?_⟩
    apply (not_missing (class_mem haa)).mpr
    have hba : p b a := by
      have hb : b ∈ classOf p a := by
        rw [heq]
        exact mem_class.mpr ⟨hbb, hbb⟩
      exact (mem_class.mp hb).2
    exact ⟨a, mem_class.mpr ⟨haa, haa⟩, hup _ _ ⟨b, hab, hba⟩⟩
  · exact Or.inr ⟨classOf p a, class_mem haa, classOf p b,
      class_mem hbb, heq, hs hxa hax, hs hxb hbx⟩

def signed (p : Bool -> Rel X) : Rel (Bool × X) :=
  fun x y => x.1 = y.1 ∧ p x.1 x.2 y.2

theorem signed_mono {p q : Bool -> Rel X} (h : ∀ s, p s ≤ q s) :
    signed p ≤ signed q := by
  rintro ⟨s, x⟩ ⟨t, y⟩ ⟨hst, hxy⟩
  exact ⟨hst, h s _ _ hxy⟩

theorem signed_comp (p q : Bool -> Rel X) :
    signed p ;; signed q = signed (fun s => p s ;; q s) := by
  apply ext
  rintro ⟨s, x⟩ ⟨t, y⟩
  constructor
  · rintro ⟨⟨v, z⟩, ⟨hsv, hxz⟩, ⟨hvt, hzy⟩⟩
    change s = v at hsv
    change v = t at hvt
    subst v
    subst t
    exact ⟨rfl, z, hxz, hzy⟩
  · rintro ⟨hst, z, hxz, hzy⟩
    change s = t at hst
    subst t
    exact ⟨(s, z), ⟨rfl, hxz⟩, ⟨rfl, hzy⟩⟩

namespace Diagram

def forSign (e : Diagram X) (s : Bool) : Diagram X := if s then e else e.flip
def signedP (e : Diagram X) : Rel (Bool × X) := signed fun s => (e.forSign s).P
def signedU (e d : Diagram X) : Rel (Bool × X) :=
  signed fun s => (e.forSign s).U (d.forSign s)

theorem idem_sign {e : Diagram X} (h : e.Idem) (s : Bool) : (e.forSign s).Idem := by
  cases s
  · exact idem_flip h
  · exact h

theorem nested_sign {d e : Diagram X} (h : d.Nested e) (s : Bool) :
    (d.forSign s).Nested (e.forSign s) := by
  cases s
  · exact nested_flip h
  · exact h

theorem signedP_trans {e : Diagram X} (he : e.Idem) :
    ∀ x y z, e.signedP x y -> e.signedP y z -> e.signedP x z := by
  rintro ⟨s, x⟩ ⟨t, y⟩ ⟨v, z⟩ ⟨hst, hxy⟩ ⟨htv, hyz⟩
  change s = t at hst
  change t = v at htv
  subst t
  subst v
  exact ⟨rfl, P_trans (idem_sign he s) hxy hyz⟩

theorem signed_absorption {d e : Diagram X} (h : d.Nested e) :
    e.signedP ;; d.signedP ≤ d.signedP ∧
      d.signedP ;; e.signedP ≤ d.signedP := by
  constructor
  · rw [signedP, signedP, signed_comp]
    exact signed_mono fun s => (absorption (nested_sign h s)).1
  · rw [signedP, signedP, signed_comp]
    exact signed_mono fun s => (absorption (nested_sign h s)).2

theorem signed_corner_absorption {d e : Diagram X} (h : d.Nested e) :
    e.signedP ;; e.signedU d ≤ e.signedU d ∧
      e.signedU d ;; e.signedP ≤ e.signedU d := by
  constructor
  · rw [signedP, signedU, signed_comp]
    exact signed_mono fun s => (corner_absorption (nested_sign h s)).1
  · rw [signedP, signedU, signed_comp]
    exact signed_mono fun s => (corner_absorption (nested_sign h s)).2

theorem signed_containment [Fintype X] {d e : Diagram X}
    (he : e.Idem) (hd : d.Idem) (h : d.Nested e) :
    ∀ c ∈ classes d.signedP,
      (∃ a ∈ classes e.signedP,
        a ⊆ c ∧ a ∉ missing e.signedP (e.signedU d)) ∨
      ∃ a ∈ classes e.signedP, ∃ b ∈ classes e.signedP,
        a ≠ b ∧ a ⊆ c ∧ b ⊆ c := by
  apply containment_from_witness (signedP_trans he)
    (signed_absorption h).1 (signed_absorption h).2 (signed_corner_absorption h).2
  rintro ⟨s, x⟩ ⟨_, hxx⟩
  obtain ⟨p, q, hpp, hqq, hxp, hpx, hxq, hqx, hpq⟩ :=
    containment_witness (idem_sign he s) (idem_sign hd s) (nested_sign h s) hxx
  exact ⟨(s, p), (s, q), ⟨rfl, hpp⟩, ⟨rfl, hqq⟩,
    ⟨rfl, hxp⟩, ⟨rfl, hpx⟩, ⟨rfl, hxq⟩, ⟨rfl, hqx⟩, ⟨rfl, hpq⟩⟩

theorem chain_K (b : Nat -> Diagram X) (k : Nat)
    (hnest : ∀ n, n < k -> (b (n + 1)).Nested (b n)) :
    ∀ n, n ≤ k -> (b 0).K ≤ (b n).K := by
  intro n
  induction n with
  | zero => intro _; exact le_rfl
  | succ n ih =>
    intro hn
    exact (ih (by omega)).trans (nested_K (hnest n (by omega)))

theorem chain_through (b : Nat -> Diagram X) (k : Nat) (he : (b 0).Idem)
    (hnest : ∀ n, n < k -> (b (n + 1)).Nested (b n)) :
    ∀ n, n ≤ k ->
      (b 0).F ;; (b 0).K ;; (b n).F ≤ (b n).F ∧
      (b n).F ;; (b 0).K ;; (b 0).F ≤ (b n).F := by
  intro n
  induction n with
  | zero =>
    intro _
    exact ⟨(through_idem he).le, (through_idem he).le⟩
  | succ n ih =>
    intro hn
    obtain ⟨hl, hr⟩ := ih (by omega)
    have h := hnest n (by omega)
    let S := cl ((b (n + 1)).L ;; (b n).R)
    let T := cl ((b n).L ;; (b (n + 1)).R)
    constructor
    · calc
        _ = (b 0).F ;; (b 0).K ;; ((b n).F ;; S ;; (b (n + 1)).F) := by
          rw [nested_left h]
        _ = ((b 0).F ;; (b 0).K ;; (b n).F) ;; S ;; (b (n + 1)).F := by
          simp only [assoc]
        _ ≤ (b n).F ;; S ;; (b (n + 1)).F := mono hl le_rfl
        _ = _ := nested_left h
    · calc
        _ = ((b (n + 1)).F ;; T ;; (b n).F) ;; (b 0).K ;; (b 0).F := by
          rw [nested_right h]
        _ = (b (n + 1)).F ;; T ;; ((b n).F ;; (b 0).K ;; (b 0).F) := by
          simp only [assoc]
        _ ≤ (b (n + 1)).F ;; T ;; (b n).F := mono le_rfl (mono le_rfl hr)
        _ = _ := nested_right h

theorem signed_initial_corner (b : Nat -> Diagram X) (k : Nat)
    (he : (b 0).Idem) (hnest : ∀ n, n < k -> (b (n + 1)).Nested (b n))
    (n : Nat) (hn : n ≤ k) :
    (b 0).signedP ;; (b 0).signedU (b n) ≤ (b 0).signedU (b n) ∧
      (b 0).signedU (b n) ;; (b 0).signedP ≤ (b 0).signedU (b n) := by
  have h (s : Bool) := corner_absorption_of
    (chain_through (fun j => (b j).forSign s) k (idem_sign he s)
      (fun j hj => nested_sign (hnest j hj) s) n hn).1
    (chain_through (fun j => (b j).forSign s) k (idem_sign he s)
      (fun j hj => nested_sign (hnest j hj) s) n hn).2
  constructor
  · rw [signedP, signedU, signed_comp]
    exact signed_mono fun s => (h s).1
  · rw [signedP, signedU, signed_comp]
    exact signed_mono fun s => (h s).2

theorem initial_U_step (b : Nat -> Diagram X) (k : Nat)
    (hnest : ∀ n, n < k -> (b (n + 1)).Nested (b n)) (n : Nat) (hn : n < k) :
    (b 0).signedU (b (n + 1)) ≤ (b n).signedU (b (n + 1)) := by
  apply signed_mono
  intro s
  have hK := chain_K (fun j => (b j).forSign s) k
    (fun j hj => nested_sign (hnest j hj) s) n (by omega)
  exact mono hK (mono le_rfl hK)

theorem nested_chain_bound [Fintype X] (b : Nat -> Diagram X) (k : Nat)
    (hidem : ∀ n, n ≤ k -> (b n).Idem)
    (hnest : ∀ n, n < k -> (b (n + 1)).Nested (b n))
    (j0 : Finset (Finset (Bool × X))) (hj0 : j0 ⊆ classes (b 0).signedP)
    (hbudget : ∀ n, n ≤ k ->
      missing (b 0).signedP ((b 0).signedU (b n)) ⊆ j0) :
    (∑ n ∈ Finset.range k,
      (missing (b n).signedP ((b n).signedU (b (n + 1)))).card) ≤
      2 * j0.card := by
  classical
  let t := protectedLabels (b 0).signedP j0
  let s := fun n => (unprotected (b n).signedP t).card
  let delta := fun n =>
    (missing (b n).signedP ((b n).signedU (b (n + 1)))).card
  have ht : ∀ n, n ≤ k -> ∀ x ∈ t, (b 0).signedU (b n) x x := by
    intro n hn x hx
    obtain ⟨c, hc, hcn, hxc⟩ := mem_protected.mp hx
    have hcm : c ∉ missing (b 0).signedP ((b 0).signedU (b n)) :=
      fun hcm => hcn (hbudget n hn hcm)
    obtain ⟨y, hyc, hyy⟩ := (not_missing hc).mp hcm
    exact uniform_loop (signedP_trans (hidem 0 (by omega)))
      (signed_initial_corner b k (hidem 0 (by omega)) hnest n hn).1
      (signed_initial_corner b k (hidem 0 (by omega)) hnest n hn).2
      hc hxc hyc hyy
  have step : ∀ n, n < k -> 2 * s (n + 1) + delta n ≤ 2 * s n := by
    intro n hn
    apply step_budget t (signedP_trans (hidem (n + 1) (by omega))) ?_
      (signed_containment (hidem n (by omega)) (hidem (n + 1) (by omega))
        (hnest n hn))
    intro c hc
    obtain ⟨hcc, hcm⟩ := mem_missing.mp hc
    refine mem_unprotected.mpr ⟨hcc, Finset.disjoint_left.mpr ?_⟩
    intro x hxc hxt
    exact hcm ⟨x, hxc, initial_U_step b k hnest n hn _ _
      (ht (n + 1) (by omega) x hxt)⟩
  have total : ∀ n, n ≤ k ->
      (∑ i ∈ Finset.range n, delta i) + 2 * s n ≤ 2 * s 0 := by
    intro n
    induction n with
    | zero => intro _; simp
    | succ n ih =>
      intro hn
      have h1 := ih (by omega)
      have h2 := step n (by omega)
      rw [Finset.sum_range_succ]
      omega
  have hs0 : s 0 = j0.card :=
    congrArg Finset.card (initial_unprotected
      (signedP_trans (hidem 0 (by omega))) hj0)
  have result := total k le_rfl
  rw [hs0] at result
  change (∑ n ∈ Finset.range k, delta n) ≤ 2 * j0.card
  omega

end Diagram
end NestedLoss

#print axioms NestedLoss.Diagram.absorption
#print axioms NestedLoss.Diagram.through_absorption
#print axioms NestedLoss.Diagram.rectangle_factor
#print axioms NestedLoss.Diagram.signed_containment
#print axioms NestedLoss.Diagram.nested_chain_bound
