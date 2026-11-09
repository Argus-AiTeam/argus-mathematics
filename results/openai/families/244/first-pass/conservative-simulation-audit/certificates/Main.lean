import Mathlib

set_option autoImplicit false

namespace SimulationAudit

universe u v w

def RDiv {A : Type u} [Monoid A] (x y : A) : Prop := ∃ z, x * z = y

def RJoin {A : Type u} [Monoid A] (x y g : A) : Prop :=
  ∀ z, (RDiv x z ∧ RDiv y z) ↔ RDiv g z

def ConditionalJoins (A : Type u) [Monoid A] : Prop :=
  ∀ x y : A, (∃ z, RDiv x z ∧ RDiv y z) → ∃ g, RJoin x y g

structure Conservative {B : Type u} {M : Type v} [Monoid B] [Monoid M]
    (f : B →* M) : Prop where
  inj : Function.Injective f
  factor : ∀ a b q, f a * q = f b → ∃ r, q = f r ∧ a * r = b
  joins : ∀ x y g, RJoin x y g → RJoin (f x) (f y) (f g)
  nonjoins : ∀ x y, (¬∃ z, RDiv x z ∧ RDiv y z) →
    ¬∃ z, RDiv (f x) z ∧ RDiv (f y) z

variable {B : Type u} {M : Type v} [Monoid B] [Monoid M]

theorem common_join (f : B →* M) (C : Conservative f)
    (J : ConditionalJoins B) (x y : B)
    (h : ∃ z, RDiv (f x) z ∧ RDiv (f y) z) :
    ∃ g, RJoin x y g := by
  classical
  by_cases hb : ∃ z, RDiv x z ∧ RDiv y z
  · exact J x y hb
  · exact False.elim (C.nonjoins x y hb h)

theorem join_factors {x y g : B} (h : RJoin x y g) :
    RDiv x g ∧ RDiv y g :=
  (h g).2 ⟨1, mul_one g⟩

namespace Overlap

variable {I : Type w}

def Point (f : B →* M) (p : I × B) : I × M := (p.1, f p.2)

def Rel (f : B →* M) (E : I → I → Option (B × B))
    (p q : I × M) : Prop :=
  p = q ∨ ∃ a b, E p.1 q.1 = some (a, b) ∧
    ∃ t, f a * t = p.2 ∧ f b * t = q.2

def Valid (f : B →* M) (E : I → I → Option (B × B)) : Prop :=
  Equivalence (Rel f E) ∧
    ∀ i x y, Rel f E (i, x) (i, y) → x = y

theorem starts (f : B →* M) (E : I → I → Option (B × B))
    {i j : I} {a b : B} (h : E i j = some (a, b)) :
    Rel f E (i, f a) (j, f b) :=
  Or.inr ⟨a, b, h, 1, mul_one _, mul_one _⟩

theorem right (f : B →* M) (E : I → I → Option (B × B))
    {p q : I × M} (h : Rel f E p q) (r : M) :
    Rel f E (p.1, p.2 * r) (q.1, q.2 * r) := by
  rcases h with h | ⟨a, b, he, t, ha, hb⟩
  · exact Or.inl (congrArg (fun z : I × M => (z.1, z.2 * r)) h)
  · exact Or.inr ⟨a, b, he, t * r,
      by rw [←mul_assoc, ha], by rw [←mul_assoc, hb]⟩

theorem map_rel (f : B →* M) (E : I → I → Option (B × B))
    {p q : I × B} (h : Rel (MonoidHom.id B) E p q) :
    Rel f E (Point f p) (Point f q) := by
  rcases h with h | ⟨a, b, he, t, ha, hb⟩
  · exact Or.inl (congrArg (Point f) h)
  · exact Or.inr ⟨a, b, he, f t,
      by simpa only [Point, map_mul, MonoidHom.id_apply] using congrArg f ha,
      by simpa only [Point, map_mul, MonoidHom.id_apply] using congrArg f hb⟩

theorem reflect_rel (f : B →* M) (C : Conservative f)
    (E : I → I → Option (B × B)) {p q : I × B}
    (h : Rel f E (Point f p) (Point f q)) :
    Rel (MonoidHom.id B) E p q := by
  rcases h with h | ⟨a, b, he, t, ha, hb⟩
  · apply Or.inl
    apply Prod.ext
    · exact congrArg (fun z : I × M => z.1) h
    · exact C.inj (congrArg (fun z : I × M => z.2) h)
  · rcases C.factor a p.2 t ha with ⟨r, hr, har⟩
    have hbr : b * r = q.2 := C.inj (by
      simpa only [Point, hr, ←map_mul] using hb)
    exact Or.inr ⟨a, b, he, r, har, hbr⟩

theorem symmetric (f : B →* M) (E : I → I → Option (B × B))
    (V : Valid (MonoidHom.id B) E) :
    ∀ ⦃p q⦄, Rel f E p q → Rel f E q p := by
  intro p q h
  rcases h with h | ⟨a, b, he, t, ha, hb⟩
  · exact Or.inl h.symm
  · have hs := V.1.symm (starts (MonoidHom.id B) E he)
    have hh := right f E (map_rel f E hs) t
    change Rel f E (q.1, f b * t) (p.1, f a * t) at hh
    rw [hb, ha] at hh
    exact hh

theorem transitive (f : B →* M) (C : Conservative f)
    (J : ConditionalJoins B)
    (lc : ∀ a x y : M, a * x = a * y → x = y)
    (E : I → I → Option (B × B))
    (V : Valid (MonoidHom.id B) E) :
    ∀ ⦃p q r⦄, Rel f E p q → Rel f E q r → Rel f E p r := by
  rintro ⟨i, x⟩ ⟨j, y⟩ ⟨k, z⟩ h1 h2
  rcases h1 with h1 | ⟨a, b, hab, t, hat, hbt⟩
  · rcases Prod.mk.inj h1 with ⟨rfl, rfl⟩
    exact h2
  rcases h2 with h2 | ⟨c, d, hcd, s, hcs, hds⟩
  · rcases Prod.mk.inj h2 with ⟨rfl, rfl⟩
    exact Or.inr ⟨a, b, hab, t, hat, hbt⟩
  rcases common_join f C J b c ⟨y, ⟨t, hbt⟩, ⟨s, hcs⟩⟩ with ⟨g, hg⟩
  rcases join_factors hg with ⟨⟨u, hu⟩, ⟨v, hv⟩⟩
  rcases ((C.joins b c g hg) y).1 ⟨⟨t, hbt⟩, ⟨s, hcs⟩⟩ with ⟨q, hq⟩
  have ht : t = f u * q := lc (f b) _ _ (by
    calc
      f b * t = y := hbt
      _ = f g * q := hq.symm
      _ = f b * (f u * q) := by rw [←hu, map_mul, mul_assoc])
  have hs : s = f v * q := lc (f c) _ _ (by
    calc
      f c * s = y := hcs
      _ = f g * q := hq.symm
      _ = f c * (f v * q) := by rw [←hv, map_mul, mul_assoc])
  have hleft : Rel (MonoidHom.id B) E (i, a * u) (j, g) :=
    Or.inr ⟨a, b, hab, u, rfl, hu⟩
  have hright : Rel (MonoidHom.id B) E (j, g) (k, d * v) :=
    Or.inr ⟨c, d, hcd, v, hv, rfl⟩
  have hh := right f E (map_rel f E (V.1.trans hleft hright)) q
  change Rel f E (i, f (a * u) * q) (k, f (d * v) * q) at hh
  have hx : f (a * u) * q = x := by rw [map_mul, mul_assoc, ←ht]; exact hat
  have hz : f (d * v) * q = z := by rw [map_mul, mul_assoc, ←hs]; exact hds
  rw [hx, hz] at hh
  exact hh

theorem no_collapse (f : B →* M) (E : I → I → Option (B × B))
    (V : Valid (MonoidHom.id B) E) :
    ∀ i x y, Rel f E (i, x) (i, y) → x = y := by
  intro i x y h
  rcases h with h | ⟨a, b, he, t, ha, hb⟩
  · exact congrArg Prod.snd h
  · have hab : a = b := V.2 i a b (starts (MonoidHom.id B) E he)
    rw [hab] at ha
    exact ha.symm.trans hb

theorem valid_forward (f : B →* M) (C : Conservative f)
    (J : ConditionalJoins B)
    (lc : ∀ a x y : M, a * x = a * y → x = y)
    (E : I → I → Option (B × B))
    (V : Valid (MonoidHom.id B) E) : Valid f E := by
  constructor
  · constructor
    · exact fun _ => Or.inl rfl
    · intro p q h
      exact symmetric f E V h
    · intro p q r h1 h2
      exact transitive f C J lc E V h1 h2
  · exact no_collapse f E V

theorem valid_backward (f : B →* M) (C : Conservative f)
    (E : I → I → Option (B × B)) (V : Valid f E) :
    Valid (MonoidHom.id B) E := by
  constructor
  · constructor
    · exact fun _ => Or.inl rfl
    · intro p q h
      exact reflect_rel f C E (V.1.symm (map_rel f E h))
    · intro p q r hpq hqr
      exact reflect_rel f C E (V.1.trans (map_rel f E hpq) (map_rel f E hqr))
  · intro i x y h
    exact C.inj (V.2 i (f x) (f y) (map_rel f E h))

theorem validity_iff (f : B →* M) (C : Conservative f)
    (J : ConditionalJoins B)
    (lc : ∀ a x y : M, a * x = a * y → x = y)
    (E : I → I → Option (B × B)) :
    Valid (MonoidHom.id B) E ↔ Valid f E :=
  ⟨valid_forward f C J lc E, valid_backward f C E⟩

theorem merger_letter_factor (f : B →* M) (C : Conservative f)
    (E : I → I → Option (B × B)) (i j : I) (x y : B) (q : M)
    (h : Rel f E (i, f x * q) (j, f y)) :
    ∃ r, q = f r ∧ Rel (MonoidHom.id B) E (i, x * r) (j, y) := by
  have hf : ∃ r, q = f r := by
    rcases h with he | ⟨a, b, he, t, ha, hb⟩
    · rcases C.factor x y q (congrArg Prod.snd he) with ⟨r, hr, _⟩
      exact ⟨r, hr⟩
    · rcases C.factor b y t hb with ⟨v, ht, _⟩
      change f a * t = f x * q at ha
      have hx : f x * q = f (a * v) := by
        rw [←ha, ht, map_mul]
      rcases C.factor x (a * v) q hx with ⟨r, hr, _⟩
      exact ⟨r, hr⟩
  rcases hf with ⟨r, hr⟩
  refine ⟨r, hr, reflect_rel f C E ?_⟩
  simpa only [Point, map_mul, ←hr] using h

end Overlap

namespace Probe

local instance {A : Type*} : FunLike (A → A) A A where
  coe := id
  coe_injective := fun _ _ h => h

def product {A : Type*} [Monoid A] (d : ℕ → A) (i : ℕ) : ℕ → A
  | 0 => 1
  | n + 1 => product d i n * d (i + n)

theorem product_add {A : Type*} [Monoid A] (d : ℕ → A) (i n k : ℕ) :
    product d i (n + k) = product d i n * product d (i + n) k := by
  induction k with
  | zero => simp [product]
  | succ k ih => simp [product, ih, Nat.add_assoc, mul_assoc]

def transition {A : Type*} [Monoid A] (d : ℕ → A) (i j : ℕ) :=
  product d i (j - i)

@[simp] theorem transition_self {A : Type*} [Monoid A] (d : ℕ → A) (i : ℕ) :
    transition d i i = 1 := by simp [transition, product]

theorem transition_mul {A : Type*} [Monoid A] (d : ℕ → A)
    {i j k : ℕ} (hij : i ≤ j) (hjk : j ≤ k) :
    transition d i j * transition d j k = transition d i k := by
  have h1 : i + (j - i) = j := by omega
  have h2 : (j - i) + (k - j) = k - i := by omega
  simpa only [h1, h2, transition] using (product_add d i (j - i) (k - j)).symm

def trans {A : Type*} [Monoid A] (d : ℕ → A) (i j : ℕ)
    (_h : i ≤ j) (x : A) := x * transition d i j

instance system {A : Type*} [Monoid A] (d : ℕ → A) :
    DirectedSystem (fun _ : ℕ => A) (fun {i j} h => DFunLike.coe (trans d i j h)) where
  map_self {i} x := by
    change x * transition d i i = x
    simp
  map_map {k j i} hij hjk x := by
    change (x * transition d i j) * transition d j k = x * transition d i k
    rw [mul_assoc, transition_mul d hij hjk]

abbrev Letters {A : Type*} [Monoid A] (d : ℕ → A) :=
  DirectLimit (fun _ : ℕ => A) (trans d)

def rep {A : Type*} [Monoid A] (d : ℕ → A) (i : ℕ) (x : A) : Letters d :=
  ⟦⟨i, x⟩⟧

def act {A : Type*} [Monoid A] (d : ℕ → A) (a : A) : Letters d → Letters d :=
  DirectLimit.map (trans d) (trans d) (fun _ x => a * x)
    (fun _ _ _ x => mul_assoc a x _)

theorem product_map (f : B →* M) (d : ℕ → B) (i n : ℕ) :
    f (product d i n) = product (fun j => f (d j)) i n := by
  induction n with
  | zero => simp [product]
  | succ n ih => simp [product, ih]

theorem transition_map (f : B →* M) (d : ℕ → B) (i j : ℕ) :
    f (transition d i j) = transition (fun k => f (d k)) i j :=
  product_map f d i (j - i)

def letterMap (f : B →* M) (d : ℕ → B) :
    Letters d → Letters (fun i => f (d i)) :=
  DirectLimit.map (trans d) (trans (fun i => f (d i))) (fun _ x => f x) (by
    intro i j hij x
    change f x * transition (fun k => f (d k)) i j = f (x * transition d i j)
    rw [map_mul, transition_map])

theorem letterMap_injective (f : B →* M) (hf : Function.Injective f) (d : ℕ → B) :
    Function.Injective (letterMap f d) := by
  intro s t
  refine Quotient.inductionOn₂ s t ?_
  rintro ⟨i, x⟩ ⟨j, y⟩ he
  change rep (fun k => f (d k)) i (f x) =
    rep (fun k => f (d k)) j (f y) at he
  rcases Quotient.exact he with ⟨k, hik, hjk, hk⟩
  change f x * transition (fun l => f (d l)) i k =
    f y * transition (fun l => f (d l)) j k at hk
  apply Quotient.sound
  refine ⟨k, hik, hjk, ?_⟩
  change x * transition d i k = y * transition d j k
  apply hf
  simpa only [map_mul, transition_map] using hk

theorem letterMap_act (f : B →* M) (d : ℕ → B) (a : B) (s : Letters d) :
    letterMap f d (act d a s) =
      act (fun i => f (d i)) (f a) (letterMap f d s) := by
  refine DirectLimit.induction _ (fun i x => ?_) s
  change rep (fun k => f (d k)) i (f (a * x)) =
    rep (fun k => f (d k)) i (f a * f x)
  rw [map_mul]

theorem letter_factor (f : B →* M) (C : Conservative f) (d : ℕ → B)
    (a : B) (s : Letters d) (t : Letters (fun i => f (d i)))
    (h : act (fun i => f (d i)) (f a) t = letterMap f d s) :
    ∃ r, t = letterMap f d r ∧ act d a r = s := by
  rcases DirectLimit.exists_eq_mk (trans d) s with ⟨i, x, rfl⟩
  rcases DirectLimit.exists_eq_mk (trans (fun j => f (d j))) t with ⟨j, y, rfl⟩
  change rep (fun k => f (d k)) j (f a * y) =
    rep (fun k => f (d k)) i (f x) at h
  rcases Quotient.exact h with ⟨k, hjk, hik, hk⟩
  change (f a * y) * transition (fun l => f (d l)) j k =
    f x * transition (fun l => f (d l)) i k at hk
  have hm : f a * (y * transition (fun l => f (d l)) j k) =
      f (x * transition d i k) := by
    simpa only [map_mul, transition_map, mul_assoc] using hk
  rcases C.factor a (x * transition d i k)
      (y * transition (fun l => f (d l)) j k) hm with ⟨z, hz, haz⟩
  refine ⟨rep d k z, ?_, ?_⟩
  · change rep (fun l => f (d l)) j y = rep (fun l => f (d l)) k (f z)
    apply Quotient.sound
    refine ⟨k, hjk, le_rfl, ?_⟩
    change y * transition (fun l => f (d l)) j k =
      f z * transition (fun l => f (d l)) k k
    rw [transition_self, mul_one]
    exact hz
  · change rep d k (a * z) = rep d i x
    apply Quotient.sound
    refine ⟨k, le_rfl, hik, ?_⟩
    change (a * z) * transition d k k = x * transition d i k
    rw [transition_self, mul_one]
    exact haz

theorem letter_divisibility_iff (f : B →* M) (C : Conservative f)
    (d : ℕ → B) (a : B) (s : Letters d) :
    (∃ t, act (fun i => f (d i)) (f a) t = letterMap f d s) ↔
      ∃ t, act d a t = s := by
  constructor
  · rintro ⟨t, ht⟩
    rcases letter_factor f C d a s t ht with ⟨r, _, hr⟩
    exact ⟨r, hr⟩
  · rintro ⟨t, ht⟩
    exact ⟨letterMap f d t, (letterMap_act f d a t).symm.trans (congrArg _ ht)⟩

end Probe

#print axioms Overlap.validity_iff
#print axioms Overlap.merger_letter_factor
#print axioms Probe.letter_factor
#print axioms Probe.letterMap_injective

end SimulationAudit
