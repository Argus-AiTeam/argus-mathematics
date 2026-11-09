import Mathlib

namespace Rigidity

abbrev Letter (α : Type*) := α × Bool

def admissible {α : Type*} : Bool → List (Letter α) → Prop
  | p, [] => p = true
  | p, x :: xs => (p = true ∨ x.2 = true) ∧ admissible x.2 xs

def Good {α : Type*} (w : List (Letter α)) : Prop :=
  admissible false w

theorem admissible_mono {α : Type*} {w : List (Letter α)} {p : Bool}
    (h : admissible false w) : admissible p w := by
  cases w with
  | nil => simp [admissible] at h
  | cons x xs =>
    exact ⟨Or.inr (by simpa using h.1), h.2⟩

theorem admissible_delete {α : Type*} (p : Bool)
    (u v : List (Letter α)) (a : α) (b : Bool)
    (h : admissible p (u ++ (a, b) :: (a, !b) :: v)) :
    admissible p (u ++ v) := by
  induction u generalizing p with
  | nil =>
    cases b with
    | false =>
      have hp : p = true := by simpa [admissible] using h.1
      simpa [hp] using h.2.2
    | true =>
      apply admissible_mono
      simpa [admissible] using h
  | cons x xs ih =>
    exact ⟨h.1, ih x.2 h.2⟩

theorem good_of_red {α : Type*} {u v : List (Letter α)}
    (h : FreeGroup.Red u v) (hu : Good u) : Good v := by
  induction h with
  | refl => exact hu
  | tail hred hstep ih =>
    cases hstep with
    | not => exact admissible_delete false _ _ _ _ ih

theorem good_reduce {α : Type*} [DecidableEq α] {w : List (Letter α)}
    (h : Good w) : Good (FreeGroup.reduce w) :=
  good_of_red FreeGroup.reduce.red h

def block {α : Type*} (a : α) (pairs : List (α × α)) : List (Letter α) :=
  (a, true) :: pairs.flatMap (fun p => [(p.1, false), (p.2, true)])

theorem block_good {α : Type*} (a : α) (pairs : List (α × α)) :
    Good (block a pairs) := by
  have ht : admissible true
      (pairs.flatMap (fun p => [(p.1, false), (p.2, true)])) := by
    induction pairs with
    | nil => simp [admissible]
    | cons p ps ih => simpa [admissible] using ih
  simpa [Good, block, admissible] using ht

theorem admissible_append {α : Type*} {u v : List (Letter α)} {p : Bool}
    (hu : admissible p u) (hv : Good v) : admissible p (u ++ v) := by
  induction u generalizing p with
  | nil => exact admissible_mono hv
  | cons x xs ih => exact ⟨hu.1, ih hu.2⟩

def ordered {α : Type*} (bs : List (α × List (α × α))) : List (Letter α) :=
  bs.flatMap (fun b => block b.1 b.2)

theorem ordered_good {α : Type*} (bs : List (α × List (α × α)))
    (hne : bs ≠ []) : Good (ordered bs) := by
  induction bs with
  | nil => simp at hne
  | cons b bs ih =>
    cases bs with
    | nil => simpa [ordered] using block_good b.1 b.2
    | cons c cs =>
      have ht := ih (by simp)
      simpa only [Good, ordered, List.flatMap_cons] using
        admissible_append (block_good b.1 b.2) ht

theorem good_nonempty {α : Type*} {w : List (Letter α)} (h : Good w) :
    w ≠ [] := by
  intro hw
  subst w
  simp [Good, admissible] at h

theorem good_head {α : Type*} {w : List (Letter α)} (h : Good w) :
    ∃ a t, w = (a, true) :: t := by
  cases w with
  | nil => exact False.elim (good_nonempty h rfl)
  | cons x xs =>
    have hx : x.2 = true := by simpa using h.1
    rcases x with ⟨a, b⟩
    dsimp at hx
    subst b
    exact ⟨a, xs, rfl⟩

theorem admissible_last {α : Type*} {w : List (Letter α)} {p : Bool}
    (h : admissible p w) :
    w = [] ∨ ∃ t a, w = t ++ [(a, true)] := by
  induction w generalizing p with
  | nil => exact Or.inl rfl
  | cons x xs ih =>
    rcases ih h.2 with hn | ⟨t, a, ht⟩
    · subst xs
      have hx : x.2 = true := h.2
      rcases x with ⟨a, b⟩
      dsimp at hx
      subst b
      exact Or.inr ⟨[], a, rfl⟩
    · exact Or.inr ⟨x :: t, a, by simpa using congrArg (List.cons x) ht⟩

theorem good_last {α : Type*} {w : List (Letter α)} (h : Good w) :
    ∃ t a, w = t ++ [(a, true)] := by
  exact (admissible_last h).resolve_left (good_nonempty h)

theorem ordered_reduction_endpoints {α : Type*} [DecidableEq α]
    (bs : List (α × List (α × α))) (hne : bs ≠ []) :
    FreeGroup.reduce (ordered bs) ≠ [] ∧
      (∃ a t, FreeGroup.reduce (ordered bs) = (a, true) :: t) ∧
      (∃ t a, FreeGroup.reduce (ordered bs) = t ++ [(a, true)]) := by
  have h := good_reduce (ordered_good bs hne)
  exact ⟨good_nonempty h, good_head h, good_last h⟩

def insertPair {r : ℕ} (w : List (Letter (Fin r))) (i : ℕ)
    (a : Fin r) (b : Bool) : List (Letter (Fin r)) :=
  w.take i ++ (a, b) :: (a, !b) :: w.drop i

def insertions {r : ℕ} (L : ℕ) (w : List (Letter (Fin r))) :
    Finset (List (Letter (Fin r))) :=
  (Finset.univ : Finset (Fin (L + 1) × Fin r × Bool)).image
    (fun t => insertPair w t.1.val t.2.1 t.2.2)

def expansions {r : ℕ} (L : ℕ) :
    ℕ → List (Letter (Fin r)) → Finset (List (Letter (Fin r)))
  | 0, w => {w}
  | p + 1, w => (expansions L p w).biUnion (insertions L)

theorem insertions_card {r L : ℕ} (w : List (Letter (Fin r))) :
    (insertions L w).card ≤ (L + 1) * r * 2 := by
  have h := Finset.card_image_le
    (s := (Finset.univ : Finset (Fin (L + 1) × Fin r × Bool)))
    (f := fun t => insertPair w t.1.val t.2.1 t.2.2)
  simpa [insertions, Fintype.card_prod, Nat.mul_assoc] using h

theorem expansions_card {r : ℕ} (L p : ℕ) (w : List (Letter (Fin r))) :
    (expansions L p w).card ≤ ((L + 1) * r * 2) ^ p := by
  induction p with
  | zero => simp [expansions]
  | succ p ih =>
    calc
      (expansions L (p + 1) w).card
          ≤ (expansions L p w).card * ((L + 1) * r * 2) :=
        Finset.card_biUnion_le_card_mul _ _ _ (fun v _ => insertions_card v)
      _ ≤ ((L + 1) * r * 2) ^ p * ((L + 1) * r * 2) :=
        Nat.mul_le_mul_right _ ih
      _ = ((L + 1) * r * 2) ^ (p + 1) := (pow_succ _ _).symm

theorem step_predecessor_mem {r L : ℕ} {u v : List (Letter (Fin r))}
    (h : FreeGroup.Red.Step u v) (hL : u.length ≤ L) :
    u ∈ insertions L v := by
  cases h with
  | @not u₁ u₂ a b =>
    have hi : u₁.length < L + 1 := by
      simp only [List.length_append, List.length_cons] at hL
      omega
    apply Finset.mem_image.mpr
    refine ⟨(⟨u₁.length, hi⟩, a, b), Finset.mem_univ _, ?_⟩
    simp [insertPair]

theorem red_mem_expansions {r L : ℕ} {u v : List (Letter (Fin r))}
    (h : FreeGroup.Red u v) (hL : u.length ≤ L) :
    ∃ p, u.length = v.length + 2 * p ∧ u ∈ expansions L p v := by
  induction h using Relation.ReflTransGen.head_induction_on with
  | refl => exact ⟨0, by omega, by simp [expansions]⟩
  | @head u t hstep hred ih =>
    have hs := hstep.length
    obtain ⟨p, hp, hm⟩ := ih (by omega)
    refine ⟨p + 1, by omega, ?_⟩
    apply Finset.mem_biUnion.mpr
    exact ⟨t, hm, step_predecessor_mem hstep hL⟩

theorem reduction_fiber_bound {r L p : ℕ}
    (T : Finset (List (Letter (Fin r)))) (w : List (Letter (Fin r)))
    (hp : L = w.length + 2 * p)
    (hlen : ∀ u ∈ T, u.length = L)
    (hred : ∀ u ∈ T, FreeGroup.Red u w) :
    T.card ≤ ((L + 1) * r * 2) ^ p := by
  have hsub : T ⊆ expansions L p w := by
    intro u hu
    obtain ⟨p', hp', hm⟩ := red_mem_expansions (hred u hu)
      (by rw [hlen u hu])
    have heq : p' = p := by have := hlen u hu; omega
    simpa [heq] using hm
  exact (Finset.card_le_card hsub).trans (expansions_card L p w)

def collisionSlice {q r : ℕ} (i j : Fin q) : Finset (Fin q → Fin r) :=
  if i = j then ∅ else Finset.univ.filter (fun f => f i = f j)

theorem collisionSlice_card {q r : ℕ} (i j : Fin q) :
    (collisionSlice (r := r) i j).card ≤ r ^ (q - 1) := by
  classical
  by_cases hij : i = j
  · simp [collisionSlice, hij]
  · let restrict : (Fin q → Fin r) → ({k : Fin q // k ≠ j} → Fin r) :=
      fun f k => f k.val
    have hinj : Set.InjOn restrict (collisionSlice (r := r) i j) := by
      intro f hf g hg he
      have hf' : f i = f j := by simpa [collisionSlice, hij] using hf
      have hg' : g i = g j := by simpa [collisionSlice, hij] using hg
      funext k
      by_cases hk : k = j
      · subst k
        calc
          f j = f i := hf'.symm
          _ = g i := congrFun he ⟨i, hij⟩
          _ = g j := hg'
      · exact congrFun he ⟨k, hk⟩
    have hc : Fintype.card {k : Fin q // k ≠ j} = q - 1 := by
      rw [Fintype.card_subtype_compl]
      simp
    have hb := Finset.card_le_card_of_injOn restrict
      (t := Finset.univ) (fun _ _ => Finset.mem_univ _) hinj
    simpa only [Finset.card_univ, Fintype.card_fun, Fintype.card_fin, hc] using hb

theorem repeated_labels_count (q r : ℕ) :
    (Finset.univ.filter (fun f : Fin q → Fin r =>
      ¬Function.Injective f)).card ≤ q * q * r ^ (q - 1) := by
  classical
  let B := Finset.univ.filter (fun f : Fin q → Fin r => ¬Function.Injective f)
  have hsub : B ⊆ Finset.univ.biUnion
      (fun i : Fin q => Finset.univ.biUnion
        (fun j : Fin q => collisionSlice (r := r) i j)) := by
    intro f hf
    have hn : ¬Function.Injective f := (Finset.mem_filter.mp hf).2
    unfold Function.Injective at hn
    push Not at hn
    obtain ⟨i, j, heq, hij⟩ := hn
    refine Finset.mem_biUnion.mpr ⟨i, Finset.mem_univ _, ?_⟩
    refine Finset.mem_biUnion.mpr ⟨j, Finset.mem_univ _, ?_⟩
    simp [collisionSlice, hij, heq]
  calc
    B.card ≤ (Finset.univ.biUnion
        (fun i : Fin q => Finset.univ.biUnion
          (fun j : Fin q => collisionSlice (r := r) i j))).card :=
      Finset.card_le_card hsub
    _ ≤ q * (q * r ^ (q - 1)) := by
      have hi (i : Fin q) :
          (Finset.univ.biUnion
            (fun j : Fin q => collisionSlice (r := r) i j)).card
            ≤ q * r ^ (q - 1) := by
        simpa using Finset.card_biUnion_le_card_mul
          (Finset.univ : Finset (Fin q))
          (fun j => collisionSlice (r := r) i j)
          (r ^ (q - 1)) (fun j _ => collisionSlice_card (r := r) i j)
      simpa using Finset.card_biUnion_le_card_mul
        (Finset.univ : Finset (Fin q))
        (fun i => Finset.univ.biUnion
          (fun j : Fin q => collisionSlice (r := r) i j))
        (q * r ^ (q - 1)) (fun i _ => hi i)
    _ = q * q * r ^ (q - 1) := (Nat.mul_assoc _ _ _).symm

theorem signed_repeated_labels_count (q r : ℕ) :
    Fintype.card ({f : Fin q → Fin r // ¬Function.Injective f} ×
      (Fin q → Bool)) ≤ 2 ^ q * (q * q * r ^ (q - 1)) := by
  classical
  have h := Nat.mul_le_mul_right (2 ^ q) (repeated_labels_count q r)
  simpa [Fintype.card_prod, Fintype.card_fun, Fintype.card_subtype,
    Nat.mul_comm] using h

end Rigidity

#print axioms Rigidity.ordered_reduction_endpoints
#print axioms Rigidity.reduction_fiber_bound
#print axioms Rigidity.signed_repeated_labels_count
