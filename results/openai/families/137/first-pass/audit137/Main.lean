import Mathlib

set_option autoImplicit false

namespace Audit137

open scoped BigOperators
open Polynomial

variable {K : Type*} [Field K]
variable {I : Type*} [Fintype I]

abbrev Vec (K : Type*) (n : ℕ) := Fin n → K
abbrev Pool (K : Type*) (p n : ℕ) := Fin p → Vec K n

def LineHom {n : ℕ} (L : ℕ) (f : Vec K n → K) : Prop :=
  ∀ a v, ∃ P : K[X], P.natDegree ≤ L ∧ P.coeff L = f v ∧
    ∀ s, P.eval s = f (a + s • v)

theorem lineHom_zero {n L : ℕ} : LineHom L (fun _ : Vec K n => 0) := by
  intro a v
  exact ⟨0, by simp, by simp, by simp⟩

theorem lineHom_const {n : ℕ} (c : K) :
    LineHom 0 (fun _ : Vec K n => c) := by
  intro a v
  exact ⟨C c, by simp, by simp, by simp⟩

theorem lineHom_linear {n : ℕ} (f : Vec K n → K)
    (hf : ∀ a v s, f (a + s • v) = f a + s * f v) :
    LineHom 1 f := by
  intro a v
  refine ⟨C (f a) + C (f v) * X, ?_, ?_, ?_⟩
  · exact natDegree_add_le_of_degree_le (by simp)
      (natDegree_mul_le_of_le (by simp) natDegree_X_le)
  · simp
  · intro s
    rw [hf]
    simp only [eval_add, eval_mul, eval_C, eval_X]
    ring

theorem lineHom_add {n L : ℕ} {f g : Vec K n → K}
    (hf : LineHom L f) (hg : LineHom L g) :
    LineHom L (fun x => f x + g x) := by
  intro a v
  obtain ⟨P, hP, tP, eP⟩ := hf a v
  obtain ⟨Q, hQ, tQ, eQ⟩ := hg a v
  exact ⟨P + Q, natDegree_add_le_of_degree_le hP hQ,
    by simp [tP, tQ], by simp [eP, eQ]⟩

theorem lineHom_mul {n L M : ℕ} {f g : Vec K n → K}
    (hf : LineHom L f) (hg : LineHom M g) :
    LineHom (L + M) (fun x => f x * g x) := by
  intro a v
  obtain ⟨P, hP, tP, eP⟩ := hf a v
  obtain ⟨Q, hQ, tQ, eQ⟩ := hg a v
  exact ⟨P * Q, natDegree_mul_le_of_le hP hQ,
    by rw [coeff_mul_add_eq_of_natDegree_le hP hQ, tP, tQ],
    by simp [eP, eQ]⟩

theorem lineHom_scale {n L : ℕ} (c : K) {f : Vec K n → K}
    (hf : LineHom L f) : LineHom L (fun x => c * f x) := by
  simpa using lineHom_mul (lineHom_const c) hf

theorem lineHom_sum {n L : ℕ} {J : Type*} (s : Finset J)
    (f : J → Vec K n → K) (hf : ∀ j ∈ s, LineHom L (f j)) :
    LineHom L (fun x => ∑ j ∈ s, f j x) := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using (lineHom_zero (K := K) (n := n) (L := L))
  | @insert j s hj ih =>
      simpa [Finset.sum_insert, hj] using
        lineHom_add (hf j (by simp)) (ih (fun i hi => hf i (by simp [hi])))

theorem lineHom_prod {n : ℕ} {J : Type*} (s : Finset J)
    (degrees : J → ℕ) (f : J → Vec K n → K)
    (hf : ∀ j ∈ s, LineHom (degrees j) (f j)) :
    LineHom (∑ j ∈ s, degrees j) (fun x => ∏ j ∈ s, f j x) := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using (lineHom_const (n := n) (1 : K))
  | @insert j s hj ih =>
      simpa [Finset.sum_insert, Finset.prod_insert, hj] using
        lineHom_mul (hf j (by simp)) (ih (fun i hi => hf i (by simp [hi])))

structure Stencil (K : Type*) (L : ℕ) where
  point : Fin (L + 1) → K
  injective : Function.Injective point

noncomputable def Stencil.weight {L : ℕ} (S : Stencil K L)
    (i : Fin (L + 1)) : K :=
  (∏ j ∈ Finset.univ.erase i, (S.point i - S.point j))⁻¹

noncomputable def Stencil.integral {L : ℕ} (S : Stencil K L) (f : K → K) : K :=
  ∑ i, S.weight i * f (S.point i)

theorem Stencil.extract {L : ℕ} (S : Stencil K L) (P : K[X])
    (hP : P.natDegree ≤ L) : S.integral P.eval = P.coeff L := by
  classical
  have hd : P.degree < (Finset.univ : Finset (Fin (L + 1))).card := by
    apply lt_of_le_of_lt (degree_le_natDegree)
    simpa using (show (P.natDegree : WithBot ℕ) < (L + 1 : ℕ) by
      exact_mod_cast Nat.lt_succ_of_le hP)
  have h := Lagrange.coeff_eq_sum S.injective.injOn hd
  simpa [Stencil.integral, Stencil.weight, div_eq_mul_inv, mul_comm] using h.symm

theorem Stencil.extract_line {n L : ℕ} (S : Stencil K L)
    {f : Vec K n → K} (hf : LineHom L f) (a v : Vec K n) :
    S.integral (fun s => f (a + s • v)) = f v := by
  obtain ⟨P, hP, tP, eP⟩ := hf a v
  calc
    _ = S.integral P.eval := by simp only [Stencil.integral, eP]
    _ = P.coeff L := S.extract P hP
    _ = f v := tP

abbrev BitWord (d : ℕ) := Fin d → Bool

def augment {d : ℕ} (v : BitWord d) : Vec K (d + 1) :=
  Fin.lastCases 1 (fun i => if v i then 1 else 0)

noncomputable def basis {d : ℕ} (u : BitWord d) (z : Vec K (d + 1)) : K :=
  ∏ i : Fin d, if u i then z i.castSucc else z (Fin.last d) - z i.castSucc

theorem basis_lineHom {d : ℕ} (u : BitWord d) :
    LineHom d (basis (K := K) u) := by
  have h := lineHom_prod (K := K) (n := d + 1)
    (Finset.univ : Finset (Fin d)) (fun _ => 1)
    (fun i (z : Vec K (d + 1)) =>
      if u i then z i.castSucc else z (Fin.last d) - z i.castSucc)
    (by
      intro i _
      apply lineHom_linear
      intro a v s
      cases h : u i <;> simp [h, Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> ring)
  have he : (∑ _ : Fin d, (1 : ℕ)) = d := by simp
  rw [he] at h
  exact h

noncomputable def lookup {a d : ℕ}
    (f : (Fin a → BitWord d) → K) (args : Fin a → Vec K (d + 1)) : K :=
  ∑ u : Fin a → BitWord d, f u * ∏ j, basis (u j) (args j)

theorem lookup_lineHom {a d : ℕ} (f : (Fin a → BitWord d) → K)
    (args : Fin a → Vec K (d + 1)) (j : Fin a) :
    LineHom d (fun x => lookup f (Function.update args j x)) := by
  classical
  apply lineHom_sum
  intro u _
  apply lineHom_scale
  have h := lineHom_prod (Finset.univ : Finset (Fin a))
    (fun i => if i = j then d else 0)
    (fun i x => basis (u i) (Function.update args j x i))
    (by
      intro i _
      by_cases hij : i = j
      · subst i
        simpa using basis_lineHom (K := K) (u j)
      · simpa [hij] using lineHom_const (n := d + 1) (basis (u i) (args i)))
  simpa using h

theorem basis_agrees {d : ℕ} (u v : BitWord d) :
    basis (K := K) u (augment v) = if u = v then 1 else 0 := by
  classical
  by_cases huv : u = v
  · subst v
    simp only [basis, augment, Fin.lastCases_castSucc, Fin.lastCases_last]
    have h : ∀ i : Fin d, (if u i then (if u i then (1 : K) else 0)
        else 1 - (if u i then 1 else 0)) = 1 := by
      intro i
      cases u i <;> simp
    simp [h]
  · obtain ⟨i, hi⟩ : ∃ i, u i ≠ v i := by
      exact not_forall.mp (fun h => huv (funext h))
    rw [if_neg huv]
    apply Finset.prod_eq_zero (Finset.mem_univ i)
    simp only [augment, Fin.lastCases_castSucc, Fin.lastCases_last]
    cases hu : u i <;> cases hv : v i <;> simp_all

theorem prod_delta {J A : Type*} [Fintype J] [DecidableEq A]
    (u v : J → A) :
    (∏ j, if u j = v j then (1 : K) else 0) = if u = v then 1 else 0 := by
  classical
  by_cases h : u = v
  · subst v
    simp
  · obtain ⟨j, hj⟩ : ∃ j, u j ≠ v j := by
      exact not_forall.mp (fun h' => h (funext h'))
    rw [if_neg h]
    exact Finset.prod_eq_zero (Finset.mem_univ j) (by simp [hj])

theorem lookup_agrees {a d : ℕ} (f : (Fin a → BitWord d) → K)
    (v : Fin a → BitWord d) :
    lookup f (fun j => augment (v j)) = f v := by
  classical
  simp only [lookup, basis_agrees, prod_delta]
  simp

variable {p n : ℕ}

def shift (R : Pool K p n) (t : Fin p) (v : Vec K n) : Pool K p n :=
  Function.update R t (R t + v)

@[simp] theorem shift_same (R : Pool K p n) (t : Fin p) (v : Vec K n) :
    shift R t v t = R t + v := by simp [shift]

@[simp] theorem shift_other (R : Pool K p n) {t q : Fin p} (h : q ≠ t)
    (v : Vec K n) : shift R t v q = R q := by simp [shift, h]

@[simp] theorem shift_zero (R : Pool K p n) (t : Fin p) :
    shift R t 0 = R := by
  funext q
  by_cases h : q = t <;> simp [shift, h]

theorem shift_add (R : Pool K p n) (t : Fin p) (u v : Vec K n) :
    shift (shift R t u) t v = shift R t (u + v) := by
  funext q
  by_cases h : q = t <;> simp [shift, h, add_assoc]

theorem shift_comm (R : Pool K p n) {t q : Fin p} (h : q ≠ t)
    (u v : Vec K n) :
    shift (shift R q u) t v = shift (shift R t v) q u := by
  funext j
  by_cases hjt : j = t
  · subst j
    simp [shift, h, h.symm]
  · by_cases hjq : j = q
    · subst j
      simp [shift, h, h.symm]
    · simp [shift, hjt, hjq]

structure Action (K : Type*) (p n : ℕ) (α : Type*) where
  run : Pool K p n → α × Pool K p n
  peak : Pool K p n → ℕ

namespace Action

variable {α β γ : Type*}

def pure (a : α) : Action K p n α :=
  ⟨fun R => (a, R), fun _ => 0⟩

def bind (a : Action K p n α) (f : α → Action K p n β) : Action K p n β :=
  ⟨fun R => (f (a.run R).1).run (a.run R).2,
    fun R => max (a.peak R) ((f (a.run R).1).peak (a.run R).2)⟩

instance : Monad (Action K p n) where
  pure := pure
  bind := bind

def frame (bits : ℕ) (a : Action K p n α) : Action K p n α :=
  ⟨a.run, fun R => bits + a.peak R⟩

def read (scratch : ℕ) (f : Pool K p n → K) : Action K p n K :=
  ⟨fun R => (f R, R), fun _ => scratch⟩

def single (z : Fin n) (c : K) : Vec K n :=
  fun j => if j = z then c else 0

def write (t : Fin p) (z : Fin n) (c : K) : Action K p n Unit :=
  ⟨fun R => ((), shift R t (single z c)), fun _ => 0⟩

def forList {J : Type*} : List J → (J → Action K p n Unit) → Action K p n Unit
  | [], _ => pure ()
  | j :: js, f => bind (f j) (fun _ => forList js f)

def foldList {J : Type*} : List J → α → (α → J → Action K p n α) →
    Action K p n α
  | [], a, _ => pure a
  | j :: js, a, f => bind (f a j) (fun b => foldList js b f)

def Bounded (a : Action K p n α) (B : ℕ) : Prop := ∀ R, a.peak R ≤ B

theorem bounded_pure (a : α) (B : ℕ) : Bounded (pure (K := K) (p := p) (n := n) a) B :=
  fun _ => Nat.zero_le _

theorem bounded_bind {a : Action K p n α} {f : α → Action K p n β} {B : ℕ}
    (ha : Bounded a B) (hf : ∀ x, Bounded (f x) B) :
    Bounded (bind a f) B := by
  intro R
  exact max_le (ha R) (hf _ _)

theorem bounded_frame {a : Action K p n α} {B w : ℕ} (ha : Bounded a B) :
    Bounded (frame w a) (w + B) := fun R => Nat.add_le_add_left (ha R) _

theorem bounded_mono {a : Action K p n α} {B C : ℕ} (ha : Bounded a B)
    (h : B ≤ C) : Bounded a C := fun R => (ha R).trans h

theorem bounded_forList {J : Type*} (js : List J) (f : J → Action K p n Unit)
    {B : ℕ} (hf : ∀ j ∈ js, Bounded (f j) B) : Bounded (forList js f) B := by
  induction js with
  | nil => exact bounded_pure _ _
  | cons j js ih =>
      exact bounded_bind (hf j (by simp)) (fun _ => ih (fun i hi => hf i (by simp [hi])))

theorem bounded_foldList {J : Type*} (js : List J) (a : α)
    (f : α → J → Action K p n α) {B : ℕ}
    (hf : ∀ a j, j ∈ js → Bounded (f a j) B) :
    Bounded (foldList js a f) B := by
  induction js generalizing a with
  | nil => exact bounded_pure _ _
  | cons j js ih =>
      exact bounded_bind (hf a j (by simp))
        (fun b => ih b (fun c i hi => hf c i (by simp [hi])))

end Action

def enum (m : ℕ) : List (Fin m) := List.ofFn id

theorem sum_enum {m : ℕ} {A : Type*} [AddCommMonoid A] (f : Fin m → A) :
    ((enum m).map f).sum = ∑ i, f i := by
  simp [enum, List.map_ofFn, List.sum_ofFn]

variable {t : Fin p}

def Stable (t : Fin p) (f : Pool K p n → Vec K n) : Prop :=
  ∀ R v, f (shift R t v) = f R

def Translates (t : Fin p) (f : Pool K p n → Vec K n)
    (a : Action K p n Unit) : Prop :=
  ∀ R, a.run R = ((), shift R t (f R))

theorem stable_sum {J : Type*} (js : List J)
    (fs : J → Pool K p n → Vec K n) (h : ∀ j ∈ js, Stable t (fs j)) :
    Stable t (fun R => (js.map (fun j => fs j R)).sum) := by
  intro R v
  apply congrArg List.sum
  apply List.map_congr_left
  intro j hj
  exact h j hj R v

theorem translates_seq {t : Fin p} {f g : Pool K p n → Vec K n}
    {a b : Action K p n Unit} (ha : Translates t f a)
    (hb : Translates t g b) (hg : Stable t g) :
    Translates t (fun R => f R + g R) (Action.bind a (fun _ => b)) := by
  intro R
  change b.run (a.run R).2 = _
  rw [ha R, hb, hg, shift_add]

theorem translates_forList {J : Type*} (js : List J)
    (fs : J → Pool K p n → Vec K n) (acts : J → Action K p n Unit)
    (hs : ∀ j ∈ js, Stable t (fs j))
    (ha : ∀ j ∈ js, Translates t (fs j) (acts j)) :
    Translates t (fun R => (js.map (fun j => fs j R)).sum) (Action.forList js acts) := by
  induction js with
  | nil => intro R; simp [Action.forList, Action.pure]
  | cons j js ih =>
      simpa only [List.map_cons, List.sum_cons, Action.forList] using
        translates_seq (ha j (by simp))
          (ih (fun i hi => hs i (by simp [hi])) (fun i hi => ha i (by simp [hi])))
          (stable_sum js fs (fun i hi => hs i (by simp [hi])))

theorem stable_scale (c : K) {f : Pool K p n → Vec K n} (hf : Stable t f) :
    Stable t (fun R => c • f R) := by
  intro R v
  change c • f (shift R t v) = c • f R
  rw [hf]

theorem stable_shift {q : Fin p} (hqt : q ≠ t) (u : Vec K n)
    {f : Pool K p n → Vec K n} (hf : Stable t f) :
    Stable t (fun R => f (shift R q u)) := by
  intro R v
  change f (shift (shift R t v) q u) = f (shift R q u)
  rw [← shift_comm R hqt u v, hf]

def sandwich (call : K → Fin p → Action K p n Unit)
    (q : Fin p) (s : K) (body : Action K p n Unit) : Action K p n Unit :=
  Action.bind (call s q) (fun _ =>
    Action.bind body (fun _ => call (-s) q))

theorem sandwich_correct (call : K → Fin p → Action K p n Unit)
    (v : Vec K n)
    (hc : ∀ s q R, (call s q).run R = ((), shift R q (s • v)))
    {q : Fin p} (hqt : q ≠ t) (s : K)
    {f : Pool K p n → Vec K n} {body : Action K p n Unit}
    (hb : Translates t f body) :
    Translates t (fun R => f (shift R q (s • v))) (sandwich call q s body) := by
  intro R
  change (call (-s) q).run (body.run ((call s q).run R).2).2 = _
  rw [hc, hb, hc]
  simp only [Prod.snd]
  rw [← shift_comm _ hqt, shift_add]
  simp [← add_smul]

def readSandwich (call : K → Fin p → Action K p n Unit)
    (q : Fin p) (s : K) (f : Pool K p n → K) : Action K p n K :=
  Action.bind (call s q) (fun _ =>
    Action.bind (Action.read n f) (fun c =>
      Action.bind (call (-s) q) (fun _ => Action.pure c)))

theorem readSandwich_correct (call : K → Fin p → Action K p n Unit)
    (v : Vec K n)
    (hc : ∀ s q R, (call s q).run R = ((), shift R q (s • v)))
    (q : Fin p) (s : K) (f : Pool K p n → K) (R : Pool K p n) :
    (readSandwich call q s f).run R = (f (shift R q (s • v)), R) := by
  simp only [readSandwich, Action.bind, Action.read, Action.pure, hc, Prod.fst, Prod.snd]
  rw [shift_add]
  simp [← add_smul]

def addLocal (t : Fin p) (c : K) (f : Pool K p n → Vec K n) :
    Action K p n Unit :=
  Action.forList (enum n) (fun z =>
    Action.bind (Action.read n (fun R => f R z)) (Action.write t z ∘ (c * ·)))

theorem addLocal_correct (c : K) (f : Pool K p n → Vec K n)
    (hf : Stable t f) : Translates t (fun R => c • f R) (addLocal t c f) := by
  have h := translates_forList (t := t) (enum n)
    (fun z R => Action.single z (c * f R z))
    (fun z => Action.bind (Action.read n (fun R => f R z))
      (Action.write t z ∘ (c * ·)))
    (by
      intro z _ R v
      change Action.single z (c * f (shift R t v) z) = Action.single z (c * f R z)
      rw [hf])
    (by intro z _ R; rfl)
  have he : (fun R : Pool K p n =>
      ((enum n).map (fun z => Action.single z (c * f R z))).sum) =
      (fun R => c • f R) := by
    funext R z
    rw [sum_enum]
    simp [Finset.sum_apply, Action.single, Pi.smul_apply, smul_eq_mul]
  simpa only [he, addLocal] using h

theorem addLocal_bounded (c : K) (f : Pool K p n → Vec K n) :
    Action.Bounded (addLocal t c f) n := by
  apply Action.bounded_forList
  intro z _
  exact Action.bounded_bind (fun _ => Nat.le_refl _)
    (fun _ _ => Nat.zero_le _)

variable {Id : Type*}

noncomputable def ordinaryNest {d : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit)
    (t : Fin p) (f : Pool K p n → Vec K n) :
    List (Id × Fin p) → K → Action K p n Unit
  | [], c => addLocal t c f
  | (u, q) :: ds, c =>
      Action.forList (enum (d + 1)) (fun i =>
        sandwich (call u) q (S.point i) (ordinaryNest S call t f ds (c * S.weight i)))

noncomputable def ordinaryIntegral {d : ℕ} (S : Stencil K d)
    (value : Id → Vec K n) (f : Pool K p n → Vec K n) :
    List (Id × Fin p) → Pool K p n → Vec K n
  | [], R => f R
  | (u, q) :: ds, R =>
      ∑ i, S.weight i •
        ordinaryIntegral S value f ds (shift R q (S.point i • value u))

theorem ordinaryIntegral_stable {d : ℕ} (S : Stencil K d)
    (value : Id → Vec K n) (f : Pool K p n → Vec K n)
    (ds : List (Id × Fin p)) (hf : Stable t f)
    (ht : ∀ dq ∈ ds, dq.2 ≠ t) :
    Stable t (ordinaryIntegral S value f ds) := by
  induction ds with
  | nil => exact hf
  | cons dq ds ih =>
      intro R v
      simp only [ordinaryIntegral]
      apply Finset.sum_congr rfl
      intro i _
      rw [← shift_comm R (ht dq (by simp))]
      rw [ih (fun a ha => ht a (by simp [ha]))]

theorem ordinaryNest_correct {d : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (value : Id → Vec K n)
    (f : Pool K p n → Vec K n) (hf : Stable t f)
    (ds : List (Id × Fin p))
    (hc : ∀ dq ∈ ds, ∀ s q R,
      (call dq.1 s q).run R = ((), shift R q (s • value dq.1)))
    (ht : ∀ dq ∈ ds, dq.2 ≠ t) (c : K) :
    Translates t (fun R => c • ordinaryIntegral S value f ds R)
      (ordinaryNest S call t f ds c) := by
  induction ds generalizing c with
  | nil => exact addLocal_correct c f hf
  | cons dq ds ih =>
      let F := ordinaryIntegral S value f ds
      have hF : Stable t F :=
        ordinaryIntegral_stable S value f ds hf (fun a ha => ht a (by simp [ha]))
      have hloop := translates_forList (t := t) (enum (d + 1))
        (fun i R => (c * S.weight i) • F (shift R dq.2 (S.point i • value dq.1)))
        (fun i => sandwich (call dq.1) dq.2 (S.point i)
          (ordinaryNest S call t f ds (c * S.weight i)))
        (by
          intro i _
          exact stable_scale _ (stable_shift (ht dq (by simp)) _ hF))
        (by
          intro i _
          exact sandwich_correct (call dq.1) (value dq.1) (hc dq (by simp))
            (ht dq (by simp)) _
            (ih (fun a ha => hc a (by simp [ha]))
              (fun a ha => ht a (by simp [ha])) _))
      have he : (fun R : Pool K p n =>
          ((enum (d + 1)).map (fun i => (c * S.weight i) •
            F (shift R dq.2 (S.point i • value dq.1)))).sum) =
          (fun R => c • ordinaryIntegral S value f (dq :: ds) R) := by
        funext R
        rw [sum_enum]
        simp only [ordinaryIntegral, Finset.smul_sum, smul_smul, F]
      simpa only [he, ordinaryNest] using hloop

theorem ordinaryNest_bounded {d : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit)
    (f : Pool K p n → Vec K n) (ds : List (Id × Fin p)) (c : K)
    (B : ℕ) (hn : n ≤ B)
    (hc : ∀ dq ∈ ds, ∀ s, Action.Bounded (call dq.1 s dq.2) B) :
    Action.Bounded (ordinaryNest S call t f ds c) B := by
  induction ds generalizing c with
  | nil => exact Action.bounded_mono (addLocal_bounded c f) hn
  | cons dq ds ih =>
      apply Action.bounded_forList
      intro i _
      exact Action.bounded_bind (hc dq (by simp) _)
        (fun _ => Action.bounded_bind
          (ih _ (fun a ha => hc a (by simp [ha])))
          (fun _ => hc dq (by simp) _))

def setReg (R : Pool K p n) (q : Fin p) (v : Vec K n) : Pool K p n :=
  Function.update R q v

def replaceAll (value : Id → Vec K n) :
    List (Id × Fin p) → Pool K p n → Pool K p n
  | [], R => R
  | (u, q) :: ds, R => replaceAll value ds (setReg R q (value u))

theorem setReg_shift_comm (R : Pool K p n) {q t : Fin p} (h : q ≠ t)
    (u v : Vec K n) :
    setReg (shift R t u) q v = shift (setReg R q v) t u := by
  funext j
  by_cases hjq : j = q
  · subst j
    simp [setReg, shift, h, h.symm]
  · by_cases hjt : j = t
    · subst j
      simp [setReg, shift, h, h.symm]
    · simp [setReg, shift, hjq, hjt]

theorem setReg_comm (R : Pool K p n) {q t : Fin p} (h : q ≠ t)
    (u v : Vec K n) :
    setReg (setReg R t u) q v = setReg (setReg R q v) t u := by
  funext j
  by_cases hjq : j = q
  · subst j
    simp [setReg, h, h.symm]
  · by_cases hjt : j = t
    · subst j
      simp [setReg, h, h.symm]
    · simp [setReg, hjq, hjt]

theorem replaceAll_shift (value : Id → Vec K n) (ds : List (Id × Fin p))
    (q : Fin p) (hq : ∀ dq ∈ ds, dq.2 ≠ q) (R : Pool K p n) (v : Vec K n) :
    replaceAll value ds (shift R q v) = shift (replaceAll value ds R) q v := by
  induction ds generalizing R with
  | nil => rfl
  | cons dq ds ih =>
      simp only [replaceAll]
      rw [setReg_shift_comm R (hq dq (by simp)),
        ih (fun a ha => hq a (by simp [ha]))]

theorem replaceAll_set (value : Id → Vec K n) (ds : List (Id × Fin p))
    (q : Fin p) (hq : ∀ dq ∈ ds, dq.2 ≠ q) (R : Pool K p n) (v : Vec K n) :
    replaceAll value ds (setReg R q v) = setReg (replaceAll value ds R) q v := by
  induction ds generalizing R with
  | nil => rfl
  | cons dq ds ih =>
      simp only [replaceAll]
      rw [setReg_comm R (hq dq (by simp)), ih (fun a ha => hq a (by simp [ha]))]

theorem extract_slot {d : ℕ} (S : Stencil K d)
    (f : Pool K p n → Vec K n) (R : Pool K p n) (q : Fin p) (v : Vec K n)
    (hf : ∀ R z, LineHom d (fun x => f (setReg R q x) z)) :
    (∑ i, S.weight i • f (shift R q (S.point i • v))) = f (setReg R q v) := by
  funext z
  have h := S.extract_line (hf R z) (R q) v
  simpa only [Stencil.integral, Finset.sum_apply, Pi.smul_apply, smul_eq_mul,
    shift, setReg] using h

theorem ordinaryIntegral_exact {d : ℕ} (S : Stencil K d)
    (value : Id → Vec K n) (f : Pool K p n → Vec K n)
    (ds : List (Id × Fin p))
    (hd : ds.Pairwise (fun a b => a.2 ≠ b.2))
    (hf : ∀ dq ∈ ds, ∀ R z, LineHom d (fun x => f (setReg R dq.2 x) z))
    (R : Pool K p n) :
    ordinaryIntegral S value f ds R = f (replaceAll value ds R) := by
  induction ds generalizing R with
  | nil => rfl
  | cons dq ds ih =>
      obtain ⟨hne, hds⟩ := List.pairwise_cons.mp hd
      have htail : ∀ a ∈ ds, a.2 ≠ dq.2 := fun a ha => (hne a ha).symm
      simp only [ordinaryIntegral]
      simp_rw [ih hds (fun a ha => hf a (by simp [ha])),
        replaceAll_shift value ds dq.2 htail]
      rw [extract_slot S f _ dq.2 (value dq.1) (hf dq (by simp))]
      rw [replaceAll, replaceAll_set value ds dq.2 htail]

def sumRead {J : Type*} (js : List J) (f : J → Action K p n K)
    (w : J → K) (b : K) : Action K p n K :=
  Action.foldList js b (fun b j =>
    Action.bind (f j) (fun c => Action.pure (b + w j * c)))

theorem sumRead_correct {J : Type*} (js : List J) (f : J → Action K p n K)
    (w : J → K) (F : J → Pool K p n → K)
    (hf : ∀ j ∈ js, ∀ R, (f j).run R = (F j R, R))
    (b : K) (R : Pool K p n) :
    (sumRead js f w b).run R = (b + (js.map (fun j => w j * F j R)).sum, R) := by
  induction js generalizing b with
  | nil => simp [sumRead, Action.foldList, Action.pure]
  | cons j js ih =>
      change (sumRead js f w (b + w j * ((f j).run R).1)).run ((f j).run R).2 = _
      rw [hf j (by simp)]
      simp only [Prod.fst, Prod.snd]
      rw [ih (fun i hi => hf i (by simp [hi]))]
      simp [List.sum_cons, add_assoc]

def productRead {J : Type*} (js : List J) (f : J → Action K p n K)
    (u : K) : Action K p n K :=
  Action.foldList js u (fun u j =>
    Action.bind (f j) (fun c => Action.pure (u * c)))

theorem productRead_correct {J : Type*} (js : List J)
    (f : J → Action K p n K) (F : J → Pool K p n → K)
    (hf : ∀ j ∈ js, ∀ R, (f j).run R = (F j R, R))
    (u : K) (R : Pool K p n) :
    (productRead js f u).run R = (u * (js.map (fun j => F j R)).prod, R) := by
  induction js generalizing u with
  | nil => simp [productRead, Action.foldList, Action.pure]
  | cons j js ih =>
      change (productRead js f (u * ((f j).run R).1)).run ((f j).run R).2 = _
      rw [hf j (by simp)]
      simp only [Prod.fst, Prod.snd]
      rw [ih (fun i hi => hf i (by simp [hi]))]
      simp [List.prod_cons, mul_assoc]

theorem sumRead_bounded {J : Type*} (js : List J) (f : J → Action K p n K)
    (w : J → K) (b : K) (B : ℕ)
    (hf : ∀ j ∈ js, Action.Bounded (f j) B) :
    Action.Bounded (sumRead js f w b) B := by
  apply Action.bounded_foldList
  intro _ j hj
  exact Action.bounded_bind (hf j hj) (fun _ => Action.bounded_pure _ _)

theorem productRead_bounded {J : Type*} (js : List J) (f : J → Action K p n K)
    (u : K) (B : ℕ) (hf : ∀ j ∈ js, Action.Bounded (f j) B) :
    Action.Bounded (productRead js f u) B := by
  apply Action.bounded_foldList
  intro _ j hj
  exact Action.bounded_bind (hf j hj) (fun _ => Action.bounded_pure _ _)

noncomputable def factorRead {d : ℕ} (S : Stencil K d)
    (call : K → Fin p → Action K p n Unit)
    (qH qA : Fin p) (P : Vec K n → Vec K n → K) : Action K p n K :=
  sumRead (enum (d + 1))
    (fun j => readSandwich call qA (S.point j) (fun R => P (R qH) (R qA)))
    S.weight 0

theorem factorRead_correct {d : ℕ} (S : Stencil K d)
    (call : K → Fin p → Action K p n Unit) (v : Vec K n)
    (hc : ∀ s q R, (call s q).run R = ((), shift R q (s • v)))
    (qH qA : Fin p) (hHA : qH ≠ qA)
    (P : Vec K n → Vec K n → K)
    (hP : ∀ h, LineHom d (P h)) (R : Pool K p n) :
    (factorRead S call qH qA P).run R = (P (R qH) v, R) := by
  have h := sumRead_correct (enum (d + 1))
    (fun j => readSandwich call qA (S.point j) (fun R => P (R qH) (R qA)))
    S.weight (fun j R => P (R qH) (R qA + S.point j • v))
    (by
      intro j _ R
      rw [readSandwich_correct call v hc]
      simp only [shift_same, shift_other R hHA])
    0 R
  have hx := S.extract_line (hP (R qH)) (R qA) v
  simp only [Stencil.integral] at hx
  simpa only [factorRead, sum_enum, zero_add, hx] using h

theorem factorRead_bounded {d : ℕ} (S : Stencil K d)
    (call : K → Fin p → Action K p n Unit) (qH qA : Fin p)
    (P : Vec K n → Vec K n → K) (B : ℕ) (hn : n ≤ B)
    (hc : ∀ s, Action.Bounded (call s qA) B) :
    Action.Bounded (factorRead S call qH qA P) B := by
  apply sumRead_bounded
  intro j _
  exact Action.bounded_bind (hc _)
    (fun _ => Action.bounded_bind (fun _ => hn)
      (fun _ => Action.bounded_bind (hc _) (fun _ => Action.bounded_pure _ _)))

noncomputable def historyCell {d N m : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (A : Fin N → Id)
    (t qH qA : Fin p) (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (z : Fin n) (Y : Fin m) (c : K) : Action K p n Unit :=
  Action.bind (Action.read n (fun R => G Y (R qH) z)) (fun u =>
    Action.bind
      (productRead (enum N) (fun i => factorRead S (call (A i)) qH qA (P Y i)) u)
      (fun u => Action.write t z (c * u)))

noncomputable def historyPolynomial {N m : ℕ}
    (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (a : Fin N → Vec K n) (h : Vec K n) : Vec K n :=
  fun z => ∑ Y, G Y h z * ∏ i, P Y i h (a i)

noncomputable def historyBody {d N m : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (A : Fin N → Id)
    (t qH qA : Fin p) (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (c : K) : Action K p n Unit :=
  Action.forList (enum n) (fun z =>
    Action.forList (enum m) (fun Y => historyCell S call A t qH qA G P z Y c))

theorem historyCell_correct {d N m : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (value : Id → Vec K n)
    (A : Fin N → Id)
    (hc : ∀ i s q R, (call (A i) s q).run R = ((), shift R q (s • value (A i))))
    (qH qA : Fin p) (hHA : qH ≠ qA)
    (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (hP : ∀ Y i h, LineHom d (P Y i h)) (z : Fin n) (Y : Fin m) (c : K) :
    Translates t (fun R => Action.single z
      (c * (G Y (R qH) z * ∏ i, P Y i (R qH) (value (A i)))))
      (historyCell S call A t qH qA G P z Y c) := by
  intro R
  change (Action.write t z (c *
    (productRead (enum N)
      (fun i => factorRead S (call (A i)) qH qA (P Y i))
      (G Y (R qH) z) |>.run R).1)).run
      ((productRead (enum N)
        (fun i => factorRead S (call (A i)) qH qA (P Y i))
        (G Y (R qH) z)).run R).2 = _
  rw [productRead_correct (enum N) _ (fun i R => P Y i (R qH) (value (A i)))
    (by intro i _ R; exact factorRead_correct S _ _ (hc i) qH qA hHA _ (hP Y i) R)]
  simp [Action.write, enum, List.map_ofFn, List.prod_ofFn]

theorem historyBody_correct {d N m : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (value : Id → Vec K n)
    (A : Fin N → Id)
    (hc : ∀ i s q R, (call (A i) s q).run R = ((), shift R q (s • value (A i))))
    (qH qA : Fin p) (hHt : qH ≠ t) (hHA : qH ≠ qA)
    (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (hP : ∀ Y i h, LineHom d (P Y i h)) (c : K) :
    Translates t (fun R => c • historyPolynomial G P (value ∘ A) (R qH))
      (historyBody S call A t qH qA G P c) := by
  let F := fun (z : Fin n) (Y : Fin m) (R : Pool K p n) =>
    Action.single z (c * (G Y (R qH) z * ∏ i, P Y i (R qH) (value (A i))))
  have hs : ∀ z Y, Stable t (F z Y) := by
    intro z Y R v
    change Action.single z (c * (G Y (shift R t v qH) z *
      ∏ i, P Y i (shift R t v qH) (value (A i)))) = _
    rw [shift_other R hHt]
  have h := translates_forList (t := t) (enum n)
    (fun z R => ((enum m).map (fun Y => F z Y R)).sum)
    (fun z => Action.forList (enum m)
      (fun Y => historyCell S call A t qH qA G P z Y c))
    (by intro z _; exact stable_sum _ _ (fun Y _ => hs z Y))
    (by
      intro z _
      exact translates_forList (enum m) (F z) _
        (fun Y _ => hs z Y)
        (fun Y _ => historyCell_correct S call value A hc qH qA hHA G P hP z Y c))
  have he : (fun R : Pool K p n =>
      ((enum n).map (fun z => ((enum m).map (fun Y => F z Y R)).sum)).sum) =
      (fun R => c • historyPolynomial G P (value ∘ A) (R qH)) := by
    funext R z
    simp only [sum_enum, Finset.sum_apply, F, Action.single,
      Pi.smul_apply, smul_eq_mul, historyPolynomial, Function.comp_apply]
    simp_rw [Finset.sum_ite_irrel, Finset.sum_const_zero]
    simp [← Finset.mul_sum]
  simpa only [he, historyBody] using h

theorem historyBody_bounded {d N m : ℕ} (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (A : Fin N → Id)
    (qH qA : Fin p) (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (c : K) (B : ℕ) (hn : n ≤ B)
    (hc : ∀ i s, Action.Bounded (call (A i) s qA) B) :
    Action.Bounded (historyBody S call A t qH qA G P c) B := by
  apply Action.bounded_forList
  intro z _
  apply Action.bounded_forList
  intro Y _
  apply Action.bounded_bind (fun _ => hn)
  intro u
  apply Action.bounded_bind
    (productRead_bounded (enum N) _ u B
      (fun i _ => factorRead_bounded S _ qH qA _ B hn (hc i)))
  exact fun _ _ => Nat.zero_le _

theorem historyPolynomial_lineHom {d N m : ℕ}
    (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (a : Fin N → Vec K n)
    (hG : ∀ Y z, LineHom d (fun h => G Y h z))
    (hP : ∀ Y i a, LineHom d (fun h => P Y i h a)) (z : Fin n) :
    LineHom ((N + 1) * d) (fun h => historyPolynomial G P a h z) := by
  apply lineHom_sum
  intro Y _
  have hp := lineHom_prod (Finset.univ : Finset (Fin N)) (fun _ => d)
    (fun i h => P Y i h (a i)) (fun i _ => hP Y i (a i))
  have h := lineHom_mul (hG Y z) hp
  convert h using 1 <;> simp [Nat.add_mul, Nat.mul_add, Nat.add_comm, Nat.mul_comm]

noncomputable def historySchedule {d N m : ℕ}
    (S : Stencil K d) (D : Stencil K ((N + 1) * d))
    (call : Id → K → Fin p → Action K p n Unit) (H : Id) (A : Fin N → Id)
    (t qH qA : Fin p) (g : ℕ)
    (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (c : K) : Action K p n Unit :=
  Action.frame 1 (Action.forList (enum ((N + 1) * d + 1)) (fun j =>
    sandwich (call H) qH (D.point j)
      (Action.frame g (historyBody S call A t qH qA G P (c * D.weight j)))))

theorem historySchedule_correct {d N m g : ℕ}
    (S : Stencil K d) (D : Stencil K ((N + 1) * d))
    (call : Id → K → Fin p → Action K p n Unit) (value : Id → Vec K n)
    (H : Id) (A : Fin N → Id)
    (hcH : ∀ s q R, (call H s q).run R = ((), shift R q (s • value H)))
    (hcA : ∀ i s q R, (call (A i) s q).run R = ((), shift R q (s • value (A i))))
    (qH qA : Fin p)
    (hHt : qH ≠ t) (hHA : qH ≠ qA)
    (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K)
    (hG : ∀ Y z, LineHom d (fun h => G Y h z))
    (hPH : ∀ Y i a, LineHom d (fun h => P Y i h a))
    (hPA : ∀ Y i h, LineHom d (P Y i h)) (c : K) :
    Translates t (fun _ => c • historyPolynomial G P (value ∘ A) (value H))
      (historySchedule S D call H A t qH qA g G P c) := by
  let F := fun R : Pool K p n => historyPolynomial G P (value ∘ A) (R qH)
  have hF : Stable t F := by
    intro R v
    change historyPolynomial G P (value ∘ A) (shift R t v qH) = _
    rw [shift_other R hHt]
  have h := translates_forList (t := t) (enum ((N + 1) * d + 1))
    (fun j R => (c * D.weight j) • F (shift R qH (D.point j • value H)))
    (fun j => sandwich (call H) qH (D.point j)
      (Action.frame g (historyBody S call A t qH qA G P (c * D.weight j))))
    (fun j _ => stable_scale _ (stable_shift hHt _ hF))
    (fun j _ => sandwich_correct (call H) (value H) hcH hHt _
      (historyBody_correct S call value A hcA qH qA hHt hHA G P hPA _))
  have he : (fun R : Pool K p n =>
      ((enum ((N + 1) * d + 1)).map (fun j => (c * D.weight j) •
        F (shift R qH (D.point j • value H)))).sum) =
      (fun _ => c • historyPolynomial G P (value ∘ A) (value H)) := by
    funext R z
    rw [sum_enum]
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, F, shift_same]
    have hx := D.extract_line (historyPolynomial_lineHom G P (value ∘ A) hG hPH z)
      (R qH) (value H)
    change ∑ j, (c * D.weight j) *
      historyPolynomial G P (value ∘ A) (R qH + D.point j • value H) z =
      c * historyPolynomial G P (value ∘ A) (value H) z
    rw [show (∑ j, (c * D.weight j) *
        historyPolynomial G P (value ∘ A) (R qH + D.point j • value H) z) =
        c * D.integral (fun s =>
          historyPolynomial G P (value ∘ A) (R qH + s • value H) z) by
      simp [Stencil.integral, Finset.mul_sum, mul_assoc]]
    rw [hx]
  rw [he] at h
  exact h

theorem historySchedule_bounded {d N m : ℕ}
    (S : Stencil K d) (D : Stencil K ((N + 1) * d))
    (call : Id → K → Fin p → Action K p n Unit) (H : Id) (A : Fin N → Id)
    (qH qA : Fin p) (g : ℕ) (G : Fin m → Vec K n → Vec K n)
    (P : Fin m → Fin N → Vec K n → Vec K n → K) (c : K) (BH BA : ℕ)
    (hcH : ∀ s, Action.Bounded (call H s qH) BH)
    (hcA : ∀ i s, Action.Bounded (call (A i) s qA) BA) :
    Action.Bounded (historySchedule S D call H A t qH qA g G P c)
      (1 + max BH (g + max n BA)) := by
  apply Action.bounded_frame
  apply Action.bounded_forList
  intro j _
  apply Action.bounded_bind (Action.bounded_mono (hcH _) (Nat.le_max_left _ _))
  intro _
  apply Action.bounded_bind
    (Action.bounded_mono
      (Action.bounded_frame
        (historyBody_bounded S call A qH qA G P _ (max n BA) (Nat.le_max_left _ _)
          (fun i s => Action.bounded_mono (hcA i s) (Nat.le_max_right _ _))))
      (Nat.le_max_right _ _))
  exact fun _ => Action.bounded_mono (hcH _) (Nat.le_max_left _ _)

theorem mem_enum {m : ℕ} (i : Fin m) : i ∈ enum m := by
  simp [enum]

theorem replaceAll_other (value : Id → Vec K n) (ds : List (Id × Fin p))
    (q : Fin p) (hq : ∀ dq ∈ ds, dq.2 ≠ q) (R : Pool K p n) :
    replaceAll value ds R q = R q := by
  induction ds generalizing R with
  | nil => rfl
  | cons dq ds ih =>
      rw [replaceAll, ih (fun a ha => hq a (by simp [ha]))]
      simp [setReg, (hq dq (by simp)).symm]

theorem replaceAll_get (value : Id → Vec K n) (ds : List (Id × Fin p))
    (hd : ds.Pairwise (fun a b => a.2 ≠ b.2)) (dq : Id × Fin p) (hq : dq ∈ ds)
    (R : Pool K p n) :
    replaceAll value ds R dq.2 = value dq.1 := by
  induction ds generalizing R with
  | nil => simp at hq
  | cons a ds ih =>
      obtain ⟨hne, hds⟩ := List.pairwise_cons.mp hd
      rcases List.mem_cons.mp hq with he | hm
      · subst dq
        rw [replaceAll, replaceAll_other value ds a.2
          (fun b hb => (hne b hb).symm)]
        simp [setReg]
      · exact ih hds hm _

structure OrdinaryData (K : Type*) [Field K] (p n d : ℕ) (Id : Type*) where
  arity : ℕ
  child : Fin arity → Id
  slots : Fin p → Fin arity → Fin p
  slots_injective : ∀ t, Function.Injective (slots t)
  slots_avoid : ∀ t j, slots t j ≠ t
  kernel : (Fin arity → Vec K n) → Vec K n
  homogeneous : ∀ args j z, LineHom d (fun x => kernel (Function.update args j x) z)

namespace OrdinaryData

variable {d : ℕ} (O : OrdinaryData K p n d Id)

def deps (t : Fin p) : List (Id × Fin p) :=
  (enum O.arity).map (fun j => (O.child j, O.slots t j))

def localKernel (t : Fin p) (R : Pool K p n) : Vec K n :=
  O.kernel (fun j => R (O.slots t j))

theorem deps_distinct (t : Fin p) : (O.deps t).Pairwise (fun a b => a.2 ≠ b.2) := by
  have he : (enum O.arity).Nodup := by
    simpa only [enum, List.ofFn_id] using List.nodup_finRange O.arity
  rw [deps, List.pairwise_map]
  exact he.imp (fun {i j} hij => (O.slots_injective t).ne hij)

theorem localKernel_stable (t : Fin p) : Stable t (O.localKernel t) := by
  intro R v
  apply congrArg O.kernel
  funext j
  exact shift_other R (O.slots_avoid t j) v

theorem localKernel_hom (t : Fin p) (j : Fin O.arity) (R : Pool K p n) (z : Fin n) :
    LineHom d (fun x => O.localKernel t (setReg R (O.slots t j) x) z) := by
  have he : ∀ x, (fun i => setReg R (O.slots t j) x (O.slots t i)) =
      Function.update (fun i => R (O.slots t i)) j x := by
    intro x
    funext i
    by_cases hij : i = j
    · subst i
      simp [setReg]
    · simp [setReg, hij, (O.slots_injective t).ne hij]
  simp only [localKernel, he]
  exact O.homogeneous _ j z

noncomputable def schedule (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (t : Fin p) (c : K) :
    Action K p n Unit :=
  Action.frame 1 (ordinaryNest S call t (O.localKernel t) (O.deps t) c)

theorem correct (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (value : Id → Vec K n)
    (hc : ∀ j s q R, (call (O.child j) s q).run R =
      ((), shift R q (s • value (O.child j)))) (t : Fin p) (c : K) :
    Translates t (fun _ => c • O.kernel (value ∘ O.child)) (O.schedule S call t c) := by
  have hc' : ∀ dq ∈ O.deps t, ∀ s q R, (call dq.1 s q).run R =
      ((), shift R q (s • value dq.1)) := by
    intro dq hdq
    obtain ⟨j, _, rfl⟩ := List.mem_map.mp hdq
    exact hc j
  have ht : ∀ dq ∈ O.deps t, dq.2 ≠ t := by
    intro dq hdq
    obtain ⟨j, _, rfl⟩ := List.mem_map.mp hdq
    exact O.slots_avoid t j
  have hh : ∀ dq ∈ O.deps t, ∀ R z,
      LineHom d (fun x => O.localKernel t (setReg R dq.2 x) z) := by
    intro dq hdq
    obtain ⟨j, _, rfl⟩ := List.mem_map.mp hdq
    exact O.localKernel_hom t j
  have h := ordinaryNest_correct S call value (O.localKernel t)
    (O.localKernel_stable t) (O.deps t) hc' ht c
  intro R
  have hr := h R
  dsimp only at hr
  rw [ordinaryIntegral_exact S value (O.localKernel t) (O.deps t)
    (O.deps_distinct t) hh] at hr
  have he : O.localKernel t (replaceAll value (O.deps t) R) = O.kernel (value ∘ O.child) := by
    apply congrArg O.kernel
    funext j
    exact replaceAll_get value (O.deps t) (O.deps_distinct t) _
      (List.mem_map.mpr ⟨j, mem_enum j, rfl⟩) R
  rw [he] at hr
  exact hr

theorem bounded (S : Stencil K d)
    (call : Id → K → Fin p → Action K p n Unit) (t : Fin p) (c : K) (B : ℕ)
    (hn : n ≤ B)
    (hc : ∀ j s q, Action.Bounded (call (O.child j) s q) B) :
    Action.Bounded (O.schedule S call t c) (1 + B) := by
  apply Action.bounded_frame
  apply ordinaryNest_bounded S call (O.localKernel t) (O.deps t) c B hn
  intro dq hdq s
  obtain ⟨j, _, rfl⟩ := List.mem_map.mp hdq
  exact hc j s _

end OrdinaryData

structure HistoryData (K : Type*) [Field K] (p n d : ℕ) (Id : Type*) where
  g : ℕ
  N : ℕ
  guess_fits : g + 1 ≤ n
  H : Id
  A : Fin N → Id
  qH : Fin p → Fin p
  qA : Fin p → Fin p
  history_avoid : ∀ t, qH t ≠ t
  array_avoid : ∀ t, qA t ≠ t
  slots_distinct : ∀ t, qH t ≠ qA t
  outer : Stencil K ((N + 1) * d)
  G : Fin (2 ^ g) → Vec K n → Vec K n
  P : Fin (2 ^ g) → Fin N → Vec K n → Vec K n → K
  output_homogeneous : ∀ Y z, LineHom d (fun h => G Y h z)
  predicate_history_homogeneous : ∀ Y i a, LineHom d (fun h => P Y i h a)
  predicate_array_homogeneous : ∀ Y i h, LineHom d (P Y i h)

inductive Rule (K : Type*) [Field K] (p n d : ℕ) (Id : Type*)
  | base : Vec K n → Rule K p n d Id
  | ordinary : OrdinaryData K p n d Id → Rule K p n d Id
  | history : HistoryData K p n d Id → Rule K p n d Id

namespace Rule

variable {d : ℕ}

noncomputable def semantic (r : Rule K p n d Id) (v : Id → Vec K n) : Vec K n :=
  match r with
  | .base b => b
  | .ordinary O => O.kernel (v ∘ O.child)
  | .history H => historyPolynomial H.G H.P (v ∘ H.A) (v H.H)

def Dominated (r : Rule K p n d Id) (w : Id → ℕ) (bound : ℕ) : Prop :=
  match r with
  | .base _ => True
  | .ordinary O => ∀ j, 1 + w (O.child j) ≤ bound
  | .history H => 1 + w H.H ≤ bound ∧ ∀ i, H.g + 1 + w (H.A i) ≤ bound

end Rule

structure Graph (K : Type*) [Field K] (p n d : ℕ) (Id : Type*) where
  rule : Id → Rule K p n d Id
  value : Id → Vec K n
  potential : Id → ℕ
  semantic_identity : ∀ u, value u = (rule u).semantic value
  weighted_edges : ∀ u, (rule u).Dominated potential (potential u)

noncomputable def evaluate {d : ℕ} (S : Stencil K d)
    (rules : Id → Rule K p n d Id) :
    ℕ → Id → K → Fin p → Action K p n Unit
  | 0, _, _, _ => Action.pure ()
  | fuel + 1, u, c, t =>
      match rules u with
      | .base b => Action.frame 1 (addLocal t c (fun _ => b))
      | .ordinary O => O.schedule S (evaluate S rules fuel) t c
      | .history H => historySchedule S H.outer (evaluate S rules fuel) H.H H.A
          t (H.qH t) (H.qA t) H.g H.G H.P c

theorem evaluate_correct {d : ℕ} (S : Stencil K d) (G : Graph K p n d Id)
    (fuel : ℕ) (u : Id) (hfu : G.potential u < fuel) (c : K) (t : Fin p) :
    Translates t (fun _ => c • G.value u) (evaluate S G.rule fuel u c t) := by
  induction fuel generalizing u c t with
  | zero => omega
  | succ fuel ih =>
      have hs := G.semantic_identity u
      have hw := G.weighted_edges u
      cases hr : G.rule u with
      | base b =>
          simp only [evaluate, hr]
          simp only [hr, Rule.semantic] at hs
          rw [hs]
          exact addLocal_correct c (fun _ => b) (by intro R v; rfl)
      | ordinary O =>
          simp only [evaluate, hr]
          simp only [hr, Rule.semantic] at hs
          simp only [hr, Rule.Dominated] at hw
          rw [hs]
          exact O.correct S (evaluate S G.rule fuel) G.value
            (fun j s q R => ih (O.child j) (by have := hw j; omega) s q R) t c
      | history H =>
          simp only [evaluate, hr]
          simp only [hr, Rule.semantic] at hs
          simp only [hr, Rule.Dominated] at hw
          rw [hs]
          exact historySchedule_correct S H.outer (evaluate S G.rule fuel) G.value H.H H.A
            (fun s q R => ih H.H (by have := hw.1; omega) s q R)
            (fun i s q R => ih (H.A i) (by have := hw.2 i; omega) s q R)
            (H.qH t) (H.qA t) (H.history_avoid t) (H.slots_distinct t)
            H.G H.P H.output_homogeneous H.predicate_history_homogeneous
            H.predicate_array_homogeneous c

theorem evaluate_bounded {d : ℕ} (S : Stencil K d) (G : Graph K p n d Id)
    (hn : 1 ≤ n) (fuel : ℕ) (u : Id) (c : K) (t : Fin p) :
    Action.Bounded (evaluate S G.rule fuel u c t) (2 * n + G.potential u) := by
  induction fuel generalizing u c t with
  | zero => exact Action.bounded_pure _ _
  | succ fuel ih =>
      have hw := G.weighted_edges u
      cases hr : G.rule u with
      | base b =>
          simp only [evaluate, hr]
          exact Action.bounded_mono (Action.bounded_frame (addLocal_bounded c (fun _ => b)))
            (by omega)
      | ordinary O =>
          simp only [evaluate, hr]
          simp only [hr, Rule.Dominated] at hw
          have h := O.bounded S (evaluate S G.rule fuel) t c
            (2 * n + G.potential u - 1) (by omega)
            (fun j s q => Action.bounded_mono (ih (O.child j) s q)
              (by have := hw j; omega))
          exact Action.bounded_mono h (by omega)
      | history H =>
          simp only [evaluate, hr]
          simp only [hr, Rule.Dominated] at hw
          have hg := H.guess_fits
          have h := historySchedule_bounded (t := t) S H.outer
            (evaluate S G.rule fuel) H.H H.A
            (H.qH t) (H.qA t) H.g H.G H.P c
            (2 * n + G.potential u - 1) (2 * n + G.potential u - (H.g + 1))
            (fun s => Action.bounded_mono (ih H.H s (H.qH t))
              (by have := hw.1; omega))
            (fun i s => Action.bounded_mono (ih (H.A i) s (H.qA t))
              (by have := hw.2 i; omega))
          exact Action.bounded_mono h (by omega)

theorem weighted_evaluator_contract_and_storage {d : ℕ}
    (S : Stencil K d) (G : Graph K p n d Id) (hn : 1 ≤ n)
    (u : Id) (c : K) (t : Fin p) (R : Pool K p n) :
    (evaluate S G.rule (G.potential u + 1) u c t).run R =
      ((), shift R t (c • G.value u)) ∧
    (evaluate S G.rule (G.potential u + 1) u c t).peak R ≤
      2 * n + G.potential u := by
  exact ⟨evaluate_correct S G _ u (by omega) c t R,
    evaluate_bounded S G hn _ u c t R⟩

theorem weighted_evaluator_bit_bound {d : ℕ} (S : Stencil K d)
    (G : Graph K p n d Id) (hn : 1 ≤ n) (u : Id) (c : K) (t : Fin p)
    (R : Pool K p n) (ell : ℕ) :
    p * n * ell +
        (evaluate S G.rule (G.potential u + 1) u c t).peak R * ell ≤
      (p * n + 2 * n + G.potential u) * ell := by
  have h := Nat.mul_le_mul_right ell
    (evaluate_bounded S G hn (G.potential u + 1) u c t R)
  simpa only [Nat.add_mul, Nat.add_assoc] using Nat.add_le_add_left h (p * n * ell)

noncomputable def oneLookup {d : ℕ} (f : BitWord d → K)
    (h : Vec K (d + 1)) : K := ∑ u, f u * basis u h

noncomputable def twoLookup {d : ℕ} (f : BitWord d → BitWord d → K)
    (h a : Vec K (d + 1)) : K := ∑ u, ∑ v, f u v * basis u h * basis v a

theorem oneLookup_hom {d : ℕ} (f : BitWord d → K) :
    LineHom d (oneLookup f) := by
  apply lineHom_sum
  intro u _
  exact lineHom_scale (f u) (basis_lineHom u)

theorem twoLookup_hom_left {d : ℕ} (f : BitWord d → BitWord d → K)
    (a : Vec K (d + 1)) : LineHom d (fun h => twoLookup f h a) := by
  apply lineHom_sum
  intro u _
  apply lineHom_sum
  intro v _
  convert lineHom_scale (f u v * basis v a) (basis_lineHom u) using 1
  funext h
  ring

theorem twoLookup_hom_right {d : ℕ} (f : BitWord d → BitWord d → K)
    (h : Vec K (d + 1)) : LineHom d (twoLookup f h) := by
  apply lineHom_sum
  intro u _
  apply lineHom_sum
  intro v _
  exact lineHom_scale (f u v * basis u h) (basis_lineHom v)

theorem oneLookup_agrees {d : ℕ} (f : BitWord d → K) (h : BitWord d) :
    oneLookup f (augment h) = f h := by
  classical
  simp [oneLookup, basis_agrees]

theorem twoLookup_agrees {d : ℕ} (f : BitWord d → BitWord d → K)
    (h a : BitWord d) : twoLookup f (augment h) (augment a) = f h a := by
  classical
  simp [twoLookup, basis_agrees]

noncomputable def booleanOrdinary {d a : ℕ}
    (child : Fin a → Id) (slots : Fin p → Fin a → Fin p)
    (hi : ∀ t, Function.Injective (slots t))
    (ha : ∀ t j, slots t j ≠ t)
    (f : (Fin a → BitWord d) → BitWord d) : OrdinaryData K p (d + 1) d Id where
  arity := a
  child := child
  slots := slots
  slots_injective := hi
  slots_avoid := ha
  kernel := fun args z => lookup (fun u => augment (f u) z) args
  homogeneous := fun args j z => lookup_lineHom (fun u => augment (f u) z) args j

theorem booleanOrdinary_agrees {d a : ℕ}
    (child : Fin a → Id) (slots : Fin p → Fin a → Fin p)
    (hi : ∀ t, Function.Injective (slots t))
    (ha : ∀ t j, slots t j ≠ t)
    (f : (Fin a → BitWord d) → BitWord d) (v : Fin a → BitWord d) :
    (booleanOrdinary (K := K) child slots hi ha f).kernel (fun j => augment (v j)) =
      augment (f v) := by
  funext z
  exact lookup_agrees (fun u => augment (f u) z) v

noncomputable def booleanHistoryOutput {d m : ℕ}
    (G : Fin m → BitWord d → BitWord d) (Y : Fin m) (h : Vec K (d + 1)) :
    Vec K (d + 1) :=
  fun z => oneLookup (fun u => augment (G Y u) z) h

noncomputable def booleanHistoryPredicate {d N m : ℕ}
    (P : Fin m → Fin N → BitWord d → BitWord d → Bool)
    (Y : Fin m) (i : Fin N) (h a : Vec K (d + 1)) : K :=
  twoLookup (fun u v => if P Y i u v then 1 else 0) h a

theorem booleanHistory_homogeneous {d N m : ℕ}
    (G : Fin m → BitWord d → BitWord d)
    (P : Fin m → Fin N → BitWord d → BitWord d → Bool) :
    (∀ Y z, LineHom d (fun h => booleanHistoryOutput (K := K) G Y h z)) ∧
    (∀ Y i a, LineHom d (fun h => booleanHistoryPredicate (K := K) P Y i h a)) ∧
    (∀ Y i h, LineHom d (booleanHistoryPredicate (K := K) P Y i h)) := by
  exact ⟨fun _ _ => oneLookup_hom _, fun _ _ _ => twoLookup_hom_left _ _,
    fun _ _ _ => twoLookup_hom_right _ _⟩

theorem booleanHistory_agrees {d N m : ℕ}
    (G : Fin m → BitWord d → BitWord d)
    (P : Fin m → Fin N → BitWord d → BitWord d → Bool)
    (h : BitWord d) (a : Fin N → BitWord d) :
    historyPolynomial (booleanHistoryOutput (K := K) G)
        (booleanHistoryPredicate (K := K) P) (fun i => augment (a i)) (augment h) =
      (fun z => ∑ Y, augment (G Y h) z * ∏ i, if P Y i h (a i) then 1 else 0) := by
  funext z
  simp [historyPolynomial, booleanHistoryOutput, booleanHistoryPredicate,
    oneLookup_agrees, twoLookup_agrees]

def skipSlot {m : ℕ} (t : Fin (m + 1)) (j : Fin m) : Fin (m + 1) :=
  ⟨if j.val < t.val then j.val else j.val + 1, by split_ifs <;> omega⟩

theorem skipSlot_avoid {m : ℕ} (t : Fin (m + 1)) (j : Fin m) :
    skipSlot t j ≠ t := by
  apply Fin.ne_of_val_ne
  dsimp only [skipSlot]
  split_ifs <;> omega

theorem skipSlot_injective {m : ℕ} (t : Fin (m + 1)) :
    Function.Injective (skipSlot t) := by
  intro i j h
  have hv := congrArg Fin.val h
  dsimp only [skipSlot] at hv
  apply Fin.ext
  split_ifs at hv <;> omega

theorem exact_pool_capacity (r : ℕ) :
    let p := max 3 (r + 1)
    (∀ a, a ≤ r → ∀ t : Fin p, ∃ slots : Fin a → Fin p,
      Function.Injective slots ∧ ∀ j, slots j ≠ t) ∧
    (∀ t : Fin p, ∃ qH qA : Fin p, qH ≠ t ∧ qA ≠ t ∧ qH ≠ qA) := by
  have hp : max 3 (r + 1) = max 2 r + 1 := by omega
  dsimp only
  rw [hp]
  constructor
  · intro a ha t
    let emb : Fin a → Fin (max 2 r) := fun j => ⟨j.val, by omega⟩
    refine ⟨skipSlot t ∘ emb, ?_, ?_⟩
    · apply (skipSlot_injective t).comp
      intro i j h
      exact Fin.ext (congrArg (fun j : Fin (max 2 r) => j.val) h)
    · intro j
      exact skipSlot_avoid t (emb j)
  · intro t
    let j0 : Fin (max 2 r) := ⟨0, by omega⟩
    let j1 : Fin (max 2 r) := ⟨1, by omega⟩
    refine ⟨skipSlot t j0, skipSlot t j1, skipSlot_avoid t j0, skipSlot_avoid t j1, ?_⟩
    intro h
    have hv := congrArg Fin.val (skipSlot_injective t h)
    simp [j0, j1] at hv

inductive EpochVertex
  | history : ℕ → ℕ → EpochVertex
  | array : ℕ → ℕ → EpochVertex
  deriving DecidableEq

inductive EpochEdge (k g : ℕ) : EpochVertex → EpochVertex → ℕ → Prop
  | previous (e j : ℕ) (hj : j < k) :
      EpochEdge k g (.history e (j + 1)) (.history e j) 1
  | array (e j i : ℕ) (hj : j < k) :
      EpochEdge k g (.history e (j + 1)) (.array e i) (g + 1)
  | extraction (e : ℕ) :
      EpochEdge k g (.history (e + 1) 0) (.history e k) 1
  | checkpointArray (e i : ℕ) :
      EpochEdge k g (.array (e + 1) i) (.array e i) 1
  | checkpointHistory (e i : ℕ) :
      EpochEdge k g (.array (e + 1) i) (.history e k) 1

def epochPotential (k g : ℕ) : EpochVertex → ℕ
  | .history e j => e * (k + g + 2) + j + g + 1
  | .array e _ => e * (k + g + 2)

theorem epoch_edge_decreases {k g w : ℕ} {u v : EpochVertex}
    (h : EpochEdge k g u v w) :
    w + epochPotential k g v ≤ epochPotential k g u := by
  cases h <;> simp only [epochPotential, Nat.add_mul, Nat.one_mul] <;> omega

theorem epoch_edge_positive {k g w : ℕ} {u v : EpochVertex}
    (h : EpochEdge k g u v w) : 1 ≤ w := by
  cases h <;> omega

inductive WeightedWalk {V : Type*} (E : V → V → ℕ → Prop) : V → V → ℕ → Prop
  | nil (u : V) : WeightedWalk E u u 0
  | step {u v z : V} {w s : ℕ} :
      E u v w → WeightedWalk E v z s → WeightedWalk E u z (w + s)

theorem walk_potential {V : Type*} {E : V → V → ℕ → Prop}
    (P : V → ℕ) (hP : ∀ u v w, E u v w → w + P v ≤ P u)
    {u v : V} {w : ℕ} (hw : WeightedWalk E u v w) : w + P v ≤ P u := by
  induction hw with
  | nil => omega
  | @step u v z w s he hp ih =>
      have h := hP u v w he
      omega

theorem epoch_weight_bound {k g E w : ℕ} (hE : 1 ≤ E) {v : EpochVertex}
    (h : WeightedWalk (EpochEdge k g) (.history (E - 1) k) v w) :
    w ≤ E * (k + g + 2) := by
  have hp := walk_potential (epochPotential k g)
    (fun _ _ _ => epoch_edge_decreases) h
  have he : E = E - 1 + 1 := by omega
  have hh : epochPotential k g (.history (E - 1) k) < E * (k + g + 2) := by
    rw [epochPotential]
    nth_rw 2 [he]
    simp only [Nat.add_mul, Nat.one_mul]
    omega
  omega

def guessCredit (epoch : ℕ) : EpochVertex → ℕ
  | .history e _ => if epoch ≤ e then 1 else 0
  | .array e _ => if epoch < e then 1 else 0

def expensiveIn (epoch : ℕ) : EpochVertex → EpochVertex → ℕ
  | .history e _, .array e' _ => if e = epoch ∧ e' = epoch then 1 else 0
  | _, _ => 0

theorem epoch_guess_credit {k g w : ℕ} {u v : EpochVertex} (e : ℕ)
    (h : EpochEdge k g u v w) :
    expensiveIn e u v + guessCredit e v ≤ guessCredit e u := by
  cases h <;> simp only [expensiveIn, guessCredit] <;> split_ifs <;> omega

inductive MarkedWalk {V : Type*} (E : V → V → ℕ → Prop)
    (mark : V → V → ℕ) : V → V → ℕ → ℕ → Prop
  | nil (u : V) : MarkedWalk E mark u u 0 0
  | step {u v z : V} {w s c : ℕ} :
      E u v w → MarkedWalk E mark v z s c →
      MarkedWalk E mark u z (w + s) (mark u v + c)

theorem marked_walk_credit {V : Type*} {E : V → V → ℕ → Prop}
    {mark : V → V → ℕ} (P : V → ℕ)
    (hP : ∀ u v w, E u v w → mark u v + P v ≤ P u)
    {u v : V} {w c : ℕ} (hw : MarkedWalk E mark u v w c) :
    c + P v ≤ P u := by
  induction hw with
  | nil => omega
  | @step u v z w s c he hp ih =>
      have h := hP u v w he
      omega

theorem at_most_one_guess_per_epoch {k g e w c : ℕ} {u v : EpochVertex}
    (h : MarkedWalk (EpochEdge k g) (expensiveIn e) u v w c) : c ≤ 1 := by
  have hc := marked_walk_credit (guessCredit e)
    (fun _ _ _ => epoch_guess_credit e) h
  have hp : guessCredit e u ≤ 1 := by
    cases u <;> simp only [guessCredit] <;> split_ifs <;> omega
  omega

theorem two_fifths_integer_mechanism {k c E d ell : ℕ}
    (hk : 1 ≤ k) (hc : 1 ≤ c) (hE : E ≤ k + 1) :
    (3 * (d + 1) + 2 * (d + 1) + E * (k + k * c + 2)) * ell ≤
      (5 * (d + 1) + 4 * k ^ 2 * (c + 1)) * ell := by
  apply Nat.mul_le_mul_right
  have h : E * (k + k * c + 2) ≤ (k + 1) * (k + k * c + 2) :=
    Nat.mul_le_mul_right _ hE
  have h2 : (k + 1) * (k + k * c + 2) ≤ 4 * k ^ 2 * (c + 1) := by
    have hkc : k ≤ k * c := by simpa using Nat.mul_le_mul_left k hc
    calc
      _ ≤ (2 * k) * (2 * k * (c + 1)) :=
        Nat.mul_le_mul (by omega) (by nlinarith)
      _ = _ := by ring
  omega

theorem guess_cardinality (g : ℕ) : Fintype.card (BitWord g) = 2 ^ g := by
  simp [BitWord]

noncomputable def guessEncoding (g : ℕ) : BitWord g ≃ Fin (2 ^ g) :=
  Fintype.equivOfCardEq (by simp [guess_cardinality])

noncomputable def Stencil.ofCard {L : ℕ} [Fintype K] (h : L < Fintype.card K) :
    Stencil K L where
  point := fun i => (Fintype.equivFin K).symm
    ⟨i.val, lt_of_lt_of_le i.isLt (Nat.succ_le_of_lt h)⟩
  injective := by
    intro i j hij
    have he := (Fintype.equivFin K).symm.injective hij
    exact Fin.ext (congrArg (fun j : Fin (Fintype.card K) => j.val) he)

def Dependency {d : ℕ} (rules : Id → Rule K p n d Id) (u v : Id) (w : ℕ) : Prop :=
  match rules u with
  | .base _ => False
  | .ordinary O => ∃ j, v = O.child j ∧ w = 1
  | .history H => (v = H.H ∧ w = 1) ∨ ∃ i, v = H.A i ∧ w = H.g + 1

def IsMaximumPathWeight {V : Type*} (E : V → V → ℕ → Prop) (W : V → ℕ) : Prop :=
  ∀ u, (∀ v w, WeightedWalk E u v w → w ≤ W u) ∧
    ∃ v, WeightedWalk E u v (W u)

theorem maximum_path_edge_bound {V : Type*} {E : V → V → ℕ → Prop}
    {W : V → ℕ} (hW : IsMaximumPathWeight E W)
    {u v : V} {w : ℕ} (he : E u v w) : w + W v ≤ W u := by
  obtain ⟨z, hz⟩ := (hW v).2
  exact (hW u).1 z _ (WeightedWalk.step he hz)

theorem maximum_path_dominates {d : ℕ} (rules : Id → Rule K p n d Id)
    (W : Id → ℕ) (hW : IsMaximumPathWeight (Dependency rules) W) (u : Id) :
    (rules u).Dominated W (W u) := by
  cases hr : rules u with
  | base _ => trivial
  | ordinary O =>
      intro j
      apply maximum_path_edge_bound hW
      simp only [Dependency, hr]
      exact ⟨j, rfl, trivial⟩
  | history H =>
      constructor
      · apply maximum_path_edge_bound hW
        simp only [Dependency, hr]
        exact Or.inl ⟨trivial, trivial⟩
      · intro i
        apply maximum_path_edge_bound hW
        simp only [Dependency, hr]
        exact Or.inr ⟨i, rfl, trivial⟩

noncomputable def maximumHeight {d : ℕ} (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w)) : Id → ℕ :=
  wf.fix (fun u rec =>
    match hr : rules u with
    | .base _ => 0
    | .ordinary O =>
        Finset.univ.sup (fun j => 1 + rec (O.child j)
          ⟨1, by simp only [Dependency, hr]; exact ⟨j, rfl, trivial⟩⟩)
    | .history H =>
        max (1 + rec H.H
          ⟨1, by simp only [Dependency, hr]; exact Or.inl ⟨trivial, trivial⟩⟩)
          (Finset.univ.sup (fun i => H.g + 1 + rec (H.A i)
            ⟨H.g + 1, by simp only [Dependency, hr]; exact Or.inr ⟨i, rfl, trivial⟩⟩)))

theorem maximumHeight_eq {d : ℕ} (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w)) (u : Id) :
    maximumHeight rules wf u =
      match rules u with
      | .base _ => 0
      | .ordinary O => Finset.univ.sup (fun j => 1 + maximumHeight rules wf (O.child j))
      | .history H => max (1 + maximumHeight rules wf H.H)
          (Finset.univ.sup (fun i => H.g + 1 + maximumHeight rules wf (H.A i))) := by
  unfold maximumHeight
  rw [WellFounded.fix_eq]
  split
  next b hr => simp only [hr]
  next O hr => simp only [hr]
  next H hr => simp only [hr]

theorem maximumHeight_dominates {d : ℕ} (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w)) (u : Id) :
    (rules u).Dominated (maximumHeight rules wf) (maximumHeight rules wf u) := by
  rw [maximumHeight_eq]
  cases hr : rules u with
  | base _ => trivial
  | ordinary O =>
      intro j
      exact Finset.le_sup (f := fun j : Fin O.arity =>
        1 + maximumHeight rules wf (O.child j)) (Finset.mem_univ j)
  | history H =>
      constructor
      · exact Nat.le_max_left _ _
      · intro i
        exact (Finset.le_sup (f := fun i : Fin H.N =>
          H.g + 1 + maximumHeight rules wf (H.A i)) (Finset.mem_univ i)).trans
          (Nat.le_max_right (1 + maximumHeight rules wf H.H) _)

theorem dominated_edge_bound {d : ℕ} (rules : Id → Rule K p n d Id)
    (W : Id → ℕ) (hw : ∀ u, (rules u).Dominated W (W u))
    (u v : Id) (w : ℕ) (he : Dependency rules u v w) : w + W v ≤ W u := by
  have hu := hw u
  cases hr : rules u with
  | base _ => simp [Dependency, hr] at he
  | ordinary O =>
      simp only [Dependency, hr] at he
      simp only [hr, Rule.Dominated] at hu
      obtain ⟨j, rfl, rfl⟩ := he
      exact hu j
  | history H =>
      simp only [Dependency, hr] at he
      simp only [hr, Rule.Dominated] at hu
      rcases he with ⟨rfl, rfl⟩ | ⟨i, rfl, rfl⟩
      · exact hu.1
      · exact hu.2 i

theorem maximumHeight_attained {d : ℕ} (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w)) (u : Id) :
    ∃ v, WeightedWalk (Dependency rules) u v (maximumHeight rules wf u) := by
  classical
  refine wf.induction (C := fun u =>
    ∃ v, WeightedWalk (Dependency rules) u v (maximumHeight rules wf u)) u ?_
  intro u ih
  cases hr : rules u with
  | base _ =>
      refine ⟨u, ?_⟩
      rw [maximumHeight_eq, hr]
      exact WeightedWalk.nil u
  | ordinary O =>
      by_cases ha : O.arity = 0
      · refine ⟨u, ?_⟩
        have hz : maximumHeight rules wf u = 0 := by
          rw [maximumHeight_eq, hr]
          simp [ha]
        rw [hz]
        exact WeightedWalk.nil u
      · have hn : Nonempty (Fin O.arity) := ⟨⟨0, Nat.pos_of_ne_zero ha⟩⟩
        obtain ⟨j, _, hj⟩ := Finset.exists_mem_eq_sup
          (Finset.univ : Finset (Fin O.arity)) Finset.univ_nonempty
          (fun j => 1 + maximumHeight rules wf (O.child j))
        have he : Dependency rules u (O.child j) 1 := by
          simp only [Dependency, hr]
          exact ⟨j, rfl, trivial⟩
        obtain ⟨v, hv⟩ := ih (O.child j) ⟨1, he⟩
        refine ⟨v, ?_⟩
        rw [maximumHeight_eq, hr]
        change WeightedWalk (Dependency rules) u v
          (Finset.univ.sup (fun j => 1 + maximumHeight rules wf (O.child j)))
        rw [hj]
        exact WeightedWalk.step he hv
  | history H =>
      let a := 1 + maximumHeight rules wf H.H
      let b := Finset.univ.sup (fun i => H.g + 1 + maximumHeight rules wf (H.A i))
      by_cases hab : b ≤ a
      · have he : Dependency rules u H.H 1 := by
          simp only [Dependency, hr]
          exact Or.inl ⟨trivial, trivial⟩
        obtain ⟨v, hv⟩ := ih H.H ⟨1, he⟩
        refine ⟨v, ?_⟩
        rw [maximumHeight_eq, hr]
        change WeightedWalk (Dependency rules) u v (max a b)
        rw [max_eq_left hab]
        exact WeightedWalk.step he hv
      · have hn : H.N ≠ 0 := by
          intro hz
          have hb : b = 0 := by simp [b, hz]
          have ha : 1 ≤ a := by dsimp [a]; omega
          omega
        have hne : Nonempty (Fin H.N) := ⟨⟨0, Nat.pos_of_ne_zero hn⟩⟩
        obtain ⟨i, _, hi⟩ := Finset.exists_mem_eq_sup
          (Finset.univ : Finset (Fin H.N)) Finset.univ_nonempty
          (fun i => H.g + 1 + maximumHeight rules wf (H.A i))
        have he : Dependency rules u (H.A i) (H.g + 1) := by
          simp only [Dependency, hr]
          exact Or.inr ⟨i, rfl, trivial⟩
        obtain ⟨v, hv⟩ := ih (H.A i) ⟨H.g + 1, he⟩
        refine ⟨v, ?_⟩
        rw [maximumHeight_eq, hr]
        change WeightedWalk (Dependency rules) u v (max a b)
        rw [max_eq_right (by omega : a ≤ b)]
        change WeightedWalk (Dependency rules) u v
          (Finset.univ.sup (fun i => H.g + 1 + maximumHeight rules wf (H.A i)))
        rw [hi]
        exact WeightedWalk.step he hv

theorem maximumHeight_is_maximum {d : ℕ} (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w)) :
    IsMaximumPathWeight (Dependency rules) (maximumHeight rules wf) := by
  intro u
  constructor
  · intro v w h
    have hp := walk_potential (maximumHeight rules wf)
      (dominated_edge_bound rules _ (maximumHeight_dominates rules wf)) h
    omega
  · exact maximumHeight_attained rules wf u

theorem walk_append {V : Type*} {E : V → V → ℕ → Prop} {u v z : V} {w s : ℕ}
    (h : WeightedWalk E u v w) (h' : WeightedWalk E v z s) :
    WeightedWalk E u z (w + s) := by
  induction h with
  | nil => simpa using h'
  | step he hp ih => simpa [Nat.add_assoc] using WeightedWalk.step he (ih h')

theorem maximumHeight_attained_at_base {d : ℕ} (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w))
    (hOrd : ∀ u O, rules u = .ordinary O → 1 ≤ O.arity) (u : Id) :
    ∃ v b, rules v = .base b ∧
      WeightedWalk (Dependency rules) u v (maximumHeight rules wf u) := by
  obtain ⟨v, hv⟩ := maximumHeight_attained rules wf u
  have hb : ¬∃ z, Dependency rules v z 1 := by
    rintro ⟨z, hz⟩
    have hh := walk_append hv (WeightedWalk.step hz (WeightedWalk.nil z))
    have hbound := ((maximumHeight_is_maximum rules wf) u).1 z _ hh
    omega
  cases hr : rules v with
  | base b => exact ⟨v, b, hr, hv⟩
  | ordinary O =>
      let j : Fin O.arity := ⟨0, hOrd v O hr⟩
      exfalso
      apply hb
      refine ⟨O.child j, ?_⟩
      simp only [Dependency, hr]
      exact ⟨j, rfl, trivial⟩
  | history H =>
      exfalso
      apply hb
      refine ⟨H.H, ?_⟩
      simp only [Dependency, hr]
      exact Or.inl ⟨trivial, trivial⟩

noncomputable def Graph.ofWellFounded {d : ℕ}
    (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w))
    (v : Id → Vec K n) (hv : ∀ u, v u = (rules u).semantic v) :
    Graph K p n d Id where
  rule := rules
  value := v
  potential := maximumHeight rules wf
  semantic_identity := hv
  weighted_edges := maximumHeight_dominates rules wf

theorem certified_acyclic_weighted_evaluator {d : ℕ}
    (S : Stencil K d) (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w))
    (value : Id → Vec K n) (hv : ∀ u, value u = (rules u).semantic value)
    (hn : 1 ≤ n) (u : Id) (c : K) (t : Fin p) (R : Pool K p n) :
    let W := maximumHeight rules wf
    let out := evaluate S rules (W u + 1) u c t
    out.run R = ((), shift R t (c • value u)) ∧ out.peak R ≤ 2 * n + W u ∧
      IsMaximumPathWeight (Dependency rules) W := by
  have h := weighted_evaluator_contract_and_storage S
    (Graph.ofWellFounded rules wf value hv) hn u c t R
  exact ⟨h.1, h.2, maximumHeight_is_maximum rules wf⟩

noncomputable def booleanHistory {d : ℕ} (g N : ℕ) (hg : g ≤ d)
    (H : Id) (A : Fin N → Id) (qH qA : Fin p → Fin p)
    (hHt : ∀ t, qH t ≠ t) (hAt : ∀ t, qA t ≠ t) (hHA : ∀ t, qH t ≠ qA t)
    (D : Stencil K ((N + 1) * d))
    (G : Fin (2 ^ g) → BitWord d → BitWord d)
    (P : Fin (2 ^ g) → Fin N → BitWord d → BitWord d → Bool) :
    HistoryData K p (d + 1) d Id where
  g := g
  N := N
  guess_fits := Nat.add_le_add_right hg 1
  H := H
  A := A
  qH := qH
  qA := qA
  history_avoid := hHt
  array_avoid := hAt
  slots_distinct := hHA
  outer := D
  G := booleanHistoryOutput G
  P := booleanHistoryPredicate P
  output_homogeneous := (booleanHistory_homogeneous G P).1
  predicate_history_homogeneous := (booleanHistory_homogeneous G P).2.1
  predicate_array_homogeneous := (booleanHistory_homogeneous G P).2.2

theorem semantic_only_history_identity {d N m : ℕ}
    (G : Fin m → BitWord d → BitWord d)
    (P : Fin m → Fin N → BitWord d → BitWord d → Bool)
    (h v : BitWord d) (a : Fin N → BitWord d)
    (hid : augment (K := K) v =
      (fun z => ∑ Y, augment (G Y h) z * ∏ i, if P Y i h (a i) then 1 else 0)) :
    historyPolynomial (booleanHistoryOutput (K := K) G)
      (booleanHistoryPredicate (K := K) P) (fun i => augment (a i)) (augment h) =
      augment v := by
  rw [booleanHistory_agrees]
  exact hid.symm

def ceilDiv (a b : ℕ) : ℕ := (a + b - 1) / b

theorem ceilDiv_le {a b q : ℕ} (hb : 1 ≤ b) (ha : a ≤ q * b) :
    ceilDiv a b ≤ q := by
  have hsub : a + b - 1 + 1 = a + b := by omega
  have hn : a + b - 1 < (q + 1) * b := by nlinarith
  exact Nat.lt_succ_iff.mp ((Nat.div_lt_iff_lt_mul (by omega)).2 hn)

def epochCount (T k : ℕ) : ℕ :=
  ceilDiv (1 + ceilDiv T (k ^ 2)) (k ^ 2)

theorem epochCount_le {T k : ℕ} (hk : 1 ≤ k) (hT : T ≤ k ^ 5) :
    epochCount T k ≤ k + 1 := by
  have hb : 1 ≤ k ^ 2 := by nlinarith
  have ht : ceilDiv T (k ^ 2) ≤ k ^ 3 := by
    apply ceilDiv_le hb
    calc
      T ≤ k ^ 5 := hT
      _ = k ^ 3 * k ^ 2 := by ring
  apply ceilDiv_le hb
  nlinarith

theorem capped_epoch_two_fifths_bound {T k c d ell : ℕ}
    (hk : 1 ≤ k) (hc : 1 ≤ c) (hT : T ≤ k ^ 5) :
    (3 * (d + 1) + 2 * (d + 1) +
        epochCount T k * (k + k * c + 2)) * ell ≤
      (5 * (d + 1) + 4 * k ^ 2 * (c + 1)) * ell :=
  two_fifths_integer_mechanism hk hc (epochCount_le hk hT)

theorem walk_map {V V' : Type*} {E : V → V → ℕ → Prop}
    {E' : V' → V' → ℕ → Prop} (f : V → V')
    (hf : ∀ u v w, E u v w → E' (f u) (f v) w)
    {u v : V} {w : ℕ} (h : WeightedWalk E u v w) :
    WeightedWalk E' (f u) (f v) w := by
  induction h with
  | nil => exact WeightedWalk.nil _
  | step he hp ih => exact WeightedWalk.step (hf _ _ _ he) ih

theorem certified_epoch_evaluator {d k g E : ℕ}
    (S : Stencil K d) (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w))
    (value : Id → Vec K n) (hv : ∀ u, value u = (rules u).semantic value)
    (hn : 1 ≤ n) (label : Id → EpochVertex)
    (hlabel : ∀ u v w, Dependency rules u v w → EpochEdge k g (label u) (label v) w)
    (u : Id) (hu : label u = .history (E - 1) k) (hE : 1 ≤ E)
    (c : K) (t : Fin p) (R : Pool K p n) (ell : ℕ) :
    let W := maximumHeight rules wf
    let out := evaluate S rules (W u + 1) u c t
    out.run R = ((), shift R t (c • value u)) ∧
      p * n * ell + out.peak R * ell ≤
        (p * n + 2 * n + E * (k + g + 2)) * ell := by
  have h := certified_acyclic_weighted_evaluator S rules wf value hv hn u c t R
  obtain ⟨v, hpath⟩ := maximumHeight_attained rules wf u
  have hepoch := walk_map label hlabel hpath
  rw [hu] at hepoch
  have hw := epoch_weight_bound hE hepoch
  refine ⟨h.1, ?_⟩
  have hp := Nat.mul_le_mul_right ell h.2.1
  have hwp := Nat.mul_le_mul_right ell hw
  nlinarith

theorem ceilDiv_pos {a b : ℕ} (ha : 1 ≤ a) (hb : 1 ≤ b) :
    1 ≤ ceilDiv a b := by
  change 0 < (a + b - 1) / b
  exact Nat.div_pos (by omega) (by omega)

theorem epochCount_pos {T k : ℕ} (hk : 1 ≤ k) : 1 ≤ epochCount T k := by
  exact ceilDiv_pos (by omega) (by nlinarith)

theorem certified_two_fifths_mechanism {d T k c : ℕ}
    (S : Stencil K d) (rules : Id → Rule K 3 (d + 1) d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w))
    (value : Id → Vec K (d + 1)) (hv : ∀ u, value u = (rules u).semantic value)
    (label : Id → EpochVertex)
    (hlabel : ∀ u v w, Dependency rules u v w →
      EpochEdge k (k * c) (label u) (label v) w)
    (u : Id) (hu : label u = .history (epochCount T k - 1) k)
    (hk : 1 ≤ k) (hc : 1 ≤ c) (hT : T ≤ k ^ 5)
    (lambda : K) (t : Fin 3) (R : Pool K 3 (d + 1)) (ell : ℕ) :
    let W := maximumHeight rules wf
    let out := evaluate S rules (W u + 1) u lambda t
    out.run R = ((), shift R t (lambda • value u)) ∧
      3 * (d + 1) * ell + out.peak R * ell ≤
        (5 * (d + 1) + 4 * k ^ 2 * (c + 1)) * ell := by
  have h := certified_epoch_evaluator S rules wf value hv (by omega) label hlabel
    u hu (epochCount_pos hk) lambda t R ell
  exact ⟨h.1, h.2.trans (capped_epoch_two_fifths_bound hk hc hT)⟩

theorem epoch_navigation_wellFounded {d k g : ℕ}
    (rules : Id → Rule K p n d Id) (label : Id → EpochVertex)
    (hlabel : ∀ u v w, Dependency rules u v w →
      EpochEdge k g (label u) (label v) w) :
    WellFounded (fun v u => ∃ w, Dependency rules u v w) := by
  apply (InvImage.wf (epochPotential k g ∘ label) Nat.lt_wfRel.wf).mono
  intro v u h
  obtain ⟨w, he⟩ := h
  have hp := epoch_edge_decreases (hlabel u v w he)
  have hw := epoch_edge_positive (hlabel u v w he)
  change epochPotential k g (label v) < epochPotential k g (label u)
  omega

theorem certified_entry_registers {d : ℕ}
    (S : Stencil K d) (rules : Id → Rule K p n d Id)
    (wf : WellFounded (fun v u => ∃ w, Dependency rules u v w))
    (value : Id → Vec K n) (hv : ∀ u, value u = (rules u).semantic value)
    (u : Id) (c : K) (t : Fin p) (R : Pool K p n) :
    let out := evaluate S rules (maximumHeight rules wf u + 1) u c t
    (out.run R).2 t = R t + c • value u ∧
      ∀ j, j ≠ t → (out.run R).2 j = R j := by
  have h := evaluate_correct S (Graph.ofWellFounded rules wf value hv)
    (maximumHeight rules wf u + 1) u (by
      change maximumHeight rules wf u < maximumHeight rules wf u + 1
      omega) c t R
  change (evaluate S rules (maximumHeight rules wf u + 1) u c t).run R =
    ((), shift R t (c • value u)) at h
  constructor
  · rw [h]
    exact shift_same R t _
  · intro j hj
    rw [h]
    exact shift_other R hj _

#print axioms certified_acyclic_weighted_evaluator
#print axioms certified_entry_registers
#print axioms certified_two_fifths_mechanism

end Audit137
