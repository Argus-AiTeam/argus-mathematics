import Mathlib

/-!
The dependency proofs below are from OpenAI's openai/math, revision
4eaee87548250b2682affda7d05d947c05554bae, under Apache-2.0; see upstream/LICENSE.
This combined file changes the upstream packaging by removing local imports.
The new quantitative extension follows the inherited dependencies.
All dependency proofs are compiled here, not imported as unchecked oleans.
-/

universe u

theorem ite_eq_left {α : Sort u} {c : Prop} [Decidable c] {a b : α} (h : c) :
    (if c then a else b) = a := if_pos h

theorem ite_eq_right {α : Sort u} {c : Prop} [Decidable c] {a b : α} (h : ¬c) :
    (if c then a else b) = b := if_neg h

theorem dite_eq_left {α : Sort u} {c : Prop} [Decidable c]
    {a : c → α} {b : ¬c → α} (h : c) :
    (if h' : c then a h' else b h') = a h := dif_pos h

theorem dite_eq_right {α : Sort u} {c : Prop} [Decidable c]
    {a : c → α} {b : ¬c → α} (h : ¬c) :
    (if h' : c then a h' else b h') = b h := dif_neg h


/- Upstream module: OAI.Combinatorics.Sensitivity.Model. -/

namespace OAI

/-! Literal Boolean flips and ordinary sensitivity measures.
All maxima range over the actual finite input or block-family space. -/

noncomputable section
open scoped Classical

namespace Paper320

/-- Flip exactly the coordinates belonging to the specified block. -/
def flip {I : Type} (x : I → Bool) (B : Finset I) : I → Bool :=
  fun i => if i ∈ B then !(x i) else x i

/-- The ordinary number of sensitive individual input coordinates. -/
def sensitivityAt {I : Type} [Fintype I]
    (f : (I → Bool) → Bool) (x : I → Bool) : ℕ :=
  (Finset.univ.filter fun i => f (flip x {i}) ≠ f x).card

/-- Maximum ordinary sensitivity over all Boolean inputs. -/
def sensitivity {I : Type} [Fintype I] (f : (I → Bool) → Bool) : ℕ :=
  Finset.univ.sup (sensitivityAt f)

/-- Maximum size of a family of disjoint nonempty sensitive blocks at an input.
The empty family is allowed and contributes zero. Invalid families contribute zero. -/
def blockSensitivityAt {I : Type} [Fintype I]
    (f : (I → Bool) → Bool) (x : I → Bool) : ℕ :=
  Finset.univ.sup fun blocks : Finset (Finset I) =>
    if (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) ∧
        (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x)
    then blocks.card else 0

/-- Maximum block sensitivity over all Boolean inputs. -/
def blockSensitivity {I : Type} [Fintype I] (f : (I → Bool) → Bool) : ℕ :=
  Finset.univ.sup (blockSensitivityAt f)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Basic. -/

namespace OAI

/-! Finite Boolean flips and the exact maximum/witness interfaces for sensitivity. -/

noncomputable section
open scoped Classical

namespace Paper320

variable {I J K : Type}

@[simp] theorem flip_empty (x : I → Bool) : flip x ∅ = x := by
  funext i
  simp [flip]

@[simp] theorem flip_singleton_self (x : I → Bool) (i : I) :
    flip x {i} i = !(x i) := by
  simp [flip]

theorem flip_singleton_other (x : I → Bool) {i j : I} (h : j ≠ i) :
    flip x {i} j = x j := by
  simp [flip, h]

@[simp] theorem flip_flip (x : I → Bool) (B : Finset I) : flip (flip x B) B = x := by
  funext i
  by_cases h : i ∈ B <;> simp [flip, h]

theorem flip_insert (x : I → Bool) (i : I) (B : Finset I) (hi : i ∉ B) :
    flip x (insert i B) = flip (flip x B) {i} := by
  funext j
  by_cases hji : j = i
  · subst j
    simp [flip, hi]
  · simp [flip, hji]

theorem flip_prod_same (x : J × I → Bool) (j : J) (i : I) :
    (fun a => flip x {(j, i)} (j, a)) = flip (fun a => x (j, a)) {i} := by
  funext a
  simp [flip]

theorem flip_prod_other (x : J × I → Bool) {j k : J} (i : I) (hk : k ≠ j) :
    (fun a => flip x {(j, i)} (k, a)) = fun a => x (k, a) := by
  funext a
  simp [flip, hk]

@[simp] theorem flip_false (B : Finset I) (i : I) :
    flip (fun _ => false) B i = decide (i ∈ B) := by
  by_cases h : i ∈ B <;> simp [flip, h]

section Finite

variable [Fintype I]

theorem flip_differences (x y : I → Bool) :
    flip x (Finset.univ.filter fun i => x i ≠ y i) = y := by
  funext i
  cases hx : x i <;> cases hy : y i <;> simp [flip, hx, hy]

theorem sensitivityAt_le_card (f : (I → Bool) → Bool) (x : I → Bool) :
    sensitivityAt f x ≤ Fintype.card I :=
  Finset.card_le_card (Finset.filter_subset _ _)

theorem sensitivityAt_le_sensitivity (f : (I → Bool) → Bool) (x : I → Bool) :
    sensitivityAt f x ≤ sensitivity f :=
  Finset.le_sup (Finset.mem_univ x)

theorem sensitivity_le (f : (I → Bool) → Bool) {n : ℕ}
    (h : ∀ x, sensitivityAt f x ≤ n) : sensitivity f ≤ n :=
  Finset.sup_le fun x _ => h x

theorem sensitivityAt_eq_zero_iff (f : (I → Bool) → Bool) (x : I → Bool) :
    sensitivityAt f x = 0 ↔ ∀ i, f (flip x {i}) = f x := by
  simp [sensitivityAt, Finset.card_eq_zero, Finset.filter_eq_empty_iff]

theorem sensitivityAt_pos (f : (I → Bool) → Bool) (x : I → Bool) (i : I)
    (hi : f (flip x {i}) ≠ f x) : 0 < sensitivityAt f x :=
  Finset.card_pos.mpr ⟨i, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hi⟩⟩

theorem exists_sensitivityAt_eq (f : (I → Bool) → Bool) :
    ∃ x, sensitivityAt f x = sensitivity f := by
  obtain ⟨x, _, hx⟩ := Finset.exists_mem_eq_sup
    (Finset.univ : Finset (I → Bool)) (by simp) (sensitivityAt f)
  exact ⟨x, hx.symm⟩

theorem blockSensitivityAt_le_blockSensitivity (f : (I → Bool) → Bool) (x : I → Bool) :
    blockSensitivityAt f x ≤ blockSensitivity f :=
  Finset.le_sup (Finset.mem_univ x)

theorem blockSensitivity_le (f : (I → Bool) → Bool) {n : ℕ}
    (h : ∀ x, blockSensitivityAt f x ≤ n) : blockSensitivity f ≤ n :=
  Finset.sup_le fun x _ => h x

theorem le_blockSensitivityAt (f : (I → Bool) → Bool) (x : I → Bool)
    (blocks : Finset (Finset I))
    (hd : ∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B)
    (hb : ∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x) :
    blocks.card ≤ blockSensitivityAt f x := by
  have h := Finset.le_sup (s := (Finset.univ : Finset (Finset (Finset I))))
    (f := fun blocks =>
      if (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) ∧
          (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x)
      then blocks.card else 0) (Finset.mem_univ blocks)
  have hv : (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) ∧
      (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x) := ⟨hd, hb⟩
  simpa only [blockSensitivityAt, ite_eq_left hv] using h

theorem blockSensitivityAt_le (f : (I → Bool) → Bool) (x : I → Bool) {n : ℕ}
    (h : ∀ blocks : Finset (Finset I),
      (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) →
      (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x) → blocks.card ≤ n) :
    blockSensitivityAt f x ≤ n := by
  apply Finset.sup_le
  intro blocks _
  split_ifs with hb
  · exact h blocks hb.1 hb.2
  · exact Nat.zero_le _

theorem exists_blockSensitivityAt_family (f : (I → Bool) → Bool) (x : I → Bool) :
    ∃ blocks : Finset (Finset I), blocks.card = blockSensitivityAt f x ∧
      (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) ∧
      (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x) := by
  obtain ⟨blocks, _, hb⟩ := Finset.exists_mem_eq_sup
    (Finset.univ : Finset (Finset (Finset I))) (by simp)
    (fun blocks =>
      if (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) ∧
          (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x)
      then blocks.card else 0)
  by_cases hv : (∀ A ∈ blocks, ∀ B ∈ blocks, A ≠ B → Disjoint A B) ∧
      (∀ B ∈ blocks, B.Nonempty ∧ f (flip x B) ≠ f x)
  · exact ⟨blocks, by simpa only [blockSensitivityAt, ite_eq_left hv] using hb.symm, hv⟩
  · have hz : blockSensitivityAt f x = 0 := by
      simpa only [blockSensitivityAt, ite_eq_right hv] using hb
    exact ⟨∅, by simp [hz], by simp, by simp⟩

theorem le_blockSensitivityAt_of_family [Fintype K]
    (f : (I → Bool) → Bool) (x : I → Bool) (blocks : K → Finset I)
    (hne : ∀ k, (blocks k).Nonempty)
    (hd : Pairwise fun k l => Disjoint (blocks k) (blocks l))
    (hb : ∀ k, f (flip x (blocks k)) ≠ f x) :
    Fintype.card K ≤ blockSensitivityAt f x := by
  have hinj : Function.Injective blocks := by
    intro k l hkl
    by_contra hnekl
    obtain ⟨i, hi⟩ := hne k
    exact Finset.disjoint_left.mp (hd hnekl) hi (by simpa [← hkl] using hi)
  have hcard := le_blockSensitivityAt f x (Finset.univ.image blocks)
    (by
      intro A hA B hB hAB
      obtain ⟨k, _, rfl⟩ := Finset.mem_image.mp hA
      obtain ⟨l, _, rfl⟩ := Finset.mem_image.mp hB
      exact hd (fun h => hAB (congrArg blocks h)))
    (by
      intro B hB
      obtain ⟨k, _, rfl⟩ := Finset.mem_image.mp hB
      exact ⟨hne k, hb k⟩)
  simpa only [Finset.card_image_of_injective _ hinj, Finset.card_univ] using hcard

theorem eq_of_singleton_invariant (f : (I → Bool) → Bool)
    (h : ∀ x i, f (flip x {i}) = f x) (x y : I → Bool) : f x = f y := by
  have hflip (B : Finset I) : f (flip x B) = f x := by
    induction B using Finset.induction with
    | empty => simp
    | @insert i B hi ih => rw [flip_insert x i B hi, h, ih]
  rw [← flip_differences x y, hflip]

theorem sensitivity_pos_of_nonconstant (f : (I → Bool) → Bool)
    (h : ∃ x y, f x ≠ f y) : 0 < sensitivity f := by
  by_contra hn
  have hz : sensitivity f = 0 := Nat.eq_zero_of_not_pos hn
  have hi (x : I → Bool) (i : I) : f (flip x {i}) = f x := by
    apply (sensitivityAt_eq_zero_iff f x).mp _ i
    exact Nat.eq_zero_of_le_zero ((sensitivityAt_le_sensitivity f x).trans_eq hz)
  obtain ⟨x, y, hxy⟩ := h
  exact hxy (eq_of_singleton_invariant f hi x y)

end Finite
end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Composition. -/

namespace OAI

/-! Disjoint Boolean composition, with each child retaining its own raw coordinates. -/

noncomputable section
open scoped Classical BigOperators

namespace Paper320

variable {I J : Type}

def compose (f : (I → Bool) → Bool) (g : (J → Bool) → Bool) :
    (I × J → Bool) → Bool :=
  fun x => f (fun i => g (fun j => x (i, j)))

theorem compose_flip_sensitive_iff (f : (I → Bool) → Bool) (g : (J → Bool) → Bool)
    (x : I × J → Bool) (i : I) (j : J) :
    compose f g (flip x {(i, j)}) ≠ compose f g x ↔
      g (flip (fun a => x (i, a)) {j}) ≠ g (fun a => x (i, a)) ∧
      f (flip (fun k => g (fun a => x (k, a))) {i}) ≠
        f (fun k => g (fun a => x (k, a))) := by
  by_cases hg : g (flip (fun a => x (i, a)) {j}) = g (fun a => x (i, a))
  · have he : (fun k => g (fun a => flip x {(i, j)} (k, a))) =
        fun k => g (fun a => x (k, a)) := by
      funext k
      by_cases hk : k = i
      · subst k
        rw [flip_prod_same, hg]
      · rw [flip_prod_other x j hk]
    simp only [compose, he, ne_eq, not_true_eq_false, hg, false_and]
  · have hn : g (flip (fun a => x (i, a)) {j}) = !(g (fun a => x (i, a))) := by
      cases h₁ : g (flip (fun a => x (i, a)) {j}) <;>
        cases h₂ : g (fun a => x (i, a)) <;> simp_all
    have he : (fun k => g (fun a => flip x {(i, j)} (k, a))) =
        flip (fun k => g (fun a => x (k, a))) {i} := by
      funext k
      by_cases hk : k = i
      · subst k
        rw [flip_prod_same, flip_singleton_self, hn]
      · rw [flip_prod_other x j hk, flip_singleton_other _ hk]
    simp only [compose, he, ne_eq, hg, not_false_eq_true, true_and]

theorem compose_zero (f : (I → Bool) → Bool) (g : (J → Bool) → Bool)
    (hg : g (fun _ => false) = false) :
    compose f g (fun _ => false) = f (fun _ => false) := by
  simp [compose, hg]

theorem compose_flip_product_zero (f : (I → Bool) → Bool) (g : (J → Bool) → Bool)
    (C : Finset I) (D : Finset J) (hg : g (fun _ => false) = false)
    (hD : g (flip (fun _ => false) D) ≠ g (fun _ => false)) :
    compose f g (flip (fun _ => false) (C ×ˢ D)) = f (flip (fun _ => false) C) := by
  have hD' : g (flip (fun _ => false) D) = true := by
    cases he : g (flip (fun _ => false) D) <;> simp_all
  apply congrArg f
  funext i
  by_cases hi : i ∈ C
  · have he : (fun j => flip (fun _ => false) (C ×ˢ D) (i, j)) =
        flip (fun _ => false) D := by
      funext j
      simp [flip, hi]
    rw [he, hD']
    simp [flip, hi]
  · have he : (fun j => flip (fun _ => false) (C ×ˢ D) (i, j)) =
        fun _ => false := by
      funext j
      simp [flip, hi]
    rw [he, hg]
    simp [flip, hi]

section Finite
variable [Fintype I] [Fintype J]

theorem sensitivityAt_compose (f : (I → Bool) → Bool) (g : (J → Bool) → Bool)
    (x : I × J → Bool) :
    sensitivityAt (compose f g) x =
      ∑ i ∈ Finset.univ.filter (fun i =>
        f (flip (fun k => g (fun a => x (k, a))) {i}) ≠
          f (fun k => g (fun a => x (k, a)))),
        sensitivityAt g (fun a => x (i, a)) := by
  simp only [sensitivityAt, Finset.card_eq_sum_ones, Finset.sum_filter,
    compose_flip_sensitive_iff, Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : f (flip (fun k => g (fun a => x (k, a))) {i}) ≠
      f (fun k => g (fun a => x (k, a)))
  · simp [hi]
  · simp [hi]

theorem sensitivity_compose_le (f : (I → Bool) → Bool) (g : (J → Bool) → Bool) :
    sensitivity (compose f g) ≤ sensitivity f * sensitivity g := by
  apply sensitivity_le
  intro x
  rw [sensitivityAt_compose]
  calc
    _ ≤ ∑ i ∈ Finset.univ.filter (fun i =>
        f (flip (fun k => g (fun a => x (k, a))) {i}) ≠
          f (fun k => g (fun a => x (k, a)))), sensitivity g :=
      Finset.sum_le_sum fun i _ => sensitivityAt_le_sensitivity g _
    _ = sensitivityAt f (fun k => g (fun a => x (k, a))) * sensitivity g := by
      simp [sensitivityAt]
    _ ≤ sensitivity f * sensitivity g :=
      Nat.mul_le_mul_right _ (sensitivityAt_le_sensitivity f _)

theorem blockSensitivityAt_compose_zero_le (f : (I → Bool) → Bool)
    (g : (J → Bool) → Bool) (hg : g (fun _ => false) = false) :
    blockSensitivityAt f (fun _ => false) * blockSensitivityAt g (fun _ => false) ≤
      blockSensitivityAt (compose f g) (fun _ => false) := by
  obtain ⟨S, hS, hdS, hbS⟩ := exists_blockSensitivityAt_family f (fun _ => false)
  obtain ⟨T, hT, hdT, hbT⟩ := exists_blockSensitivityAt_family g (fun _ => false)
  have h := le_blockSensitivityAt_of_family (compose f g) (fun _ => false)
    (fun p : S × T => p.1.val ×ˢ p.2.val)
    (by
      intro p
      obtain ⟨i, hi⟩ := (hbS p.1.val p.1.property).1
      obtain ⟨j, hj⟩ := (hbT p.2.val p.2.property).1
      exact ⟨(i, j), Finset.mem_product.mpr ⟨hi, hj⟩⟩)
    (by
      intro p q hpq
      apply Finset.disjoint_left.mpr
      intro a ha hq
      obtain ⟨ha₁, ha₂⟩ := Finset.mem_product.mp ha
      obtain ⟨hq₁, hq₂⟩ := Finset.mem_product.mp hq
      by_cases hs : p.1 = q.1
      · have ht : p.2.val ≠ q.2.val := by
          intro h
          exact hpq (Prod.ext hs (Subtype.ext h))
        exact Finset.disjoint_left.mp (hdT _ p.2.property _ q.2.property ht) ha₂ hq₂
      · have hs' : p.1.val ≠ q.1.val := fun h => hs (Subtype.ext h)
        exact Finset.disjoint_left.mp (hdS _ p.1.property _ q.1.property hs') ha₁ hq₁)
    (by
      intro p
      rw [compose_flip_product_zero f g _ _ hg (hbT p.2.val p.2.property).2,
        compose_zero f g hg]
      exact (hbS p.1.val p.1.property).2)
  simpa only [Fintype.card_prod, Fintype.card_coe, hS, hT] using h

end Finite
end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.HammingBase. -/

namespace OAI

/-! Hamming balls used by the initial nested predicates. -/

noncomputable section
open scoped Classical

namespace Paper320

variable {I C : Type} [Fintype I]

theorem hammingDist_flip_self (x : I → Bool) (i : I) :
    hammingDist x (flip x {i}) = 1 := by
  have h : (Finset.univ.filter fun j => x j ≠ flip x {i} j) = {i} := by
    ext j
    by_cases hj : j = i
    · subst j
      cases x i <;> simp [flip]
    · simp [flip, hj]
  rw [hammingDist, h]
  simp

theorem hammingDist_le_flip_add_one (x z : I → Bool) (i : I) :
    hammingDist x z ≤ hammingDist (flip x {i}) z + 1 := by
  have h := hammingDist_triangle x (flip x {i}) z
  rw [hammingDist_flip_self] at h
  omega

theorem hammingDist_flip_le_add_one (x z : I → Bool) (i : I) :
    hammingDist (flip x {i}) z ≤ hammingDist x z + 1 := by
  have h := hammingDist_triangle (flip x {i}) x z
  rw [hammingDist_comm (flip x {i}) x, hammingDist_flip_self] at h
  omega

theorem hammingDist_flip_eq_add_one (x z : I → Bool) (i : I) (hi : x i = z i) :
    hammingDist (flip x {i}) z = hammingDist x z + 1 := by
  have h : (Finset.univ.filter fun j => flip x {i} j ≠ z j) =
      insert i (Finset.univ.filter fun j => x j ≠ z j) := by
    ext j
    by_cases hj : j = i
    · subst j
      cases hx : x i <;> simp_all [flip]
    · simp [flip, hj]
  rw [hammingDist, h, Finset.card_insert_of_notMem]
  · rfl
  · simp [hi]

/-- The union of equal-radius Hamming balls. -/
def ballPredicate [Fintype C] (centers : C → I → Bool) (R : ℕ)
    (x : I → Bool) : Bool :=
  decide (∃ c, hammingDist x (centers c) ≤ R)

theorem ballPredicate_eq_true [Fintype C] (centers : C → I → Bool) (R : ℕ)
    (x : I → Bool) :
    ballPredicate centers R x = true ↔ ∃ c, hammingDist x (centers c) ≤ R := by
  simp [ballPredicate]

theorem ballPredicate_nested [Fintype C] (centers : C → I → Bool)
    {R S : ℕ} (hRS : R ≤ S) (x : I → Bool)
    (h : ballPredicate centers R x = true) : ballPredicate centers S x = true := by
  rcases (ballPredicate_eq_true centers R x).1 h with ⟨c, hc⟩
  exact (ballPredicate_eq_true centers S x).2 ⟨c, hc.trans hRS⟩

theorem ballPredicate_zero_flip [Fintype C] (centers : C → I → Bool) (R : ℕ)
    (x : I → Bool) (i : I) (hx : ballPredicate centers R x = false)
    (hi : ballPredicate centers R (flip x {i}) = true) :
    ∃ c, hammingDist x (centers c) = R + 1 ∧ x i ≠ centers c i := by
  rcases (ballPredicate_eq_true centers R (flip x {i})).1 hi with ⟨c, hc⟩
  have hn : ¬ hammingDist x (centers c) ≤ R := by
    intro h
    have := (ballPredicate_eq_true centers R x).2 ⟨c, h⟩
    simp_all
  have hd := hammingDist_le_flip_add_one x (centers c) i
  refine ⟨c, by omega, ?_⟩
  intro heq
  rw [hammingDist_flip_eq_add_one x (centers c) i heq] at hc
  omega

theorem near_center_unique (centers : C → I → Bool) (R : ℕ)
    (hsep : ∀ a b, a ≠ b → 2 * (R + 1) < hammingDist (centers a) (centers b))
    (x : I → Bool) {a b : C} (ha : hammingDist x (centers a) ≤ R + 1)
    (hb : hammingDist x (centers b) ≤ R + 1) : a = b := by
  by_contra h
  have hs := hsep a b h
  have ht := hammingDist_triangle (centers a) x (centers b)
  rw [hammingDist_comm (centers a) x] at ht
  omega

theorem ballPredicate_sensitivityAt_zero_le [Fintype C]
    (centers : C → I → Bool) (R : ℕ)
    (hsep : ∀ a b, a ≠ b → 2 * (R + 1) < hammingDist (centers a) (centers b))
    (x : I → Bool) (hx : ballPredicate centers R x = false) :
    sensitivityAt (ballPredicate centers R) x ≤ R + 1 := by
  let A := Finset.univ.filter fun i =>
    ballPredicate centers R (flip x {i}) ≠ ballPredicate centers R x
  change A.card ≤ R + 1
  by_cases hA : A.Nonempty
  · obtain ⟨i, hi⟩ := hA
    have hi' : ballPredicate centers R (flip x {i}) = true := by
      simpa [A, hx] using hi
    obtain ⟨c, hc, _⟩ := ballPredicate_zero_flip centers R x i hx hi'
    have hsub : A ⊆ Finset.univ.filter fun j => x j ≠ centers c j := by
      intro j hj
      have hj' : ballPredicate centers R (flip x {j}) = true := by
        simpa [A, hx] using hj
      obtain ⟨c', hc', hjc⟩ := ballPredicate_zero_flip centers R x j hx hj'
      have heq : c' = c := near_center_unique centers R hsep x (by omega) (by omega)
      simpa [heq] using hjc
    exact (Finset.card_le_card hsub).trans_eq hc
  · rw [Finset.not_nonempty_iff_eq_empty.mp hA]
    simp

theorem ballPredicate_no_joint_zero [Fintype C] (centers : C → I → Bool)
    {R S : ℕ} (hRS : R < S) (x : I → Bool) (i : I)
    (hS : ballPredicate centers S x = false)
    (hR : ballPredicate centers R (flip x {i}) = true) : False := by
  obtain ⟨c, hc⟩ := (ballPredicate_eq_true centers R (flip x {i})).1 hR
  have hd := hammingDist_le_flip_add_one x (centers c) i
  have ht := (ballPredicate_eq_true centers S x).2 ⟨c, by omega⟩
  simp_all

theorem ballPredicate_no_joint_one [Fintype C] (centers : C → I → Bool)
    {R S : ℕ} (hRS : R < S) (x : I → Bool) (i : I)
    (hR : ballPredicate centers R x = true)
    (hS : ballPredicate centers S (flip x {i}) = false) : False := by
  obtain ⟨c, hc⟩ := (ballPredicate_eq_true centers R x).1 hR
  have hd := hammingDist_flip_le_add_one x (centers c) i
  have ht := (ballPredicate_eq_true centers S (flip x {i})).2 ⟨c, by omega⟩
  simp_all

/-- Minimum distance to the finite nonempty family of centers. -/
def nearestDistance [Fintype C] [Nonempty C] (centers : C → I → Bool)
    (x : I → Bool) : ℕ :=
  Finset.univ.inf' Finset.univ_nonempty (fun c => hammingDist x (centers c))

theorem ballPredicate_eq_nearestDistance [Fintype C] [Nonempty C]
    (centers : C → I → Bool) (R : ℕ) (x : I → Bool) :
    ballPredicate centers R x = decide (nearestDistance centers x ≤ R) := by
  simp [ballPredicate, nearestDistance, Finset.inf'_le_iff]

theorem nearestDistance_le_flip_add_one [Fintype C] [Nonempty C]
    (centers : C → I → Bool) (x : I → Bool) (i : I) :
    nearestDistance centers x ≤ nearestDistance centers (flip x {i}) + 1 := by
  obtain ⟨c, _, hc⟩ := Finset.exists_mem_eq_inf' Finset.univ_nonempty
    (fun c => hammingDist (flip x {i}) (centers c))
  apply (Finset.inf'_le _ (Finset.mem_univ c)).trans
  change hammingDist x (centers c) ≤
    (Finset.univ.inf' Finset.univ_nonempty fun c => hammingDist (flip x {i}) (centers c)) + 1
  rw [hc]
  exact hammingDist_le_flip_add_one x (centers c) i

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveProfiles. -/

namespace OAI

/-! The side and joint profiles count literal flips of the same raw input. -/

noncomputable section
open scoped Classical

namespace Paper320

/-- Acceptance at a stronger index implies acceptance at every weaker index. -/
structure NestedFamily {h : ℕ} {I : Type}
    (F : Fin h → (I → Bool) → Bool) : Prop where
  accepts_of_le : ∀ {q q' : Fin h} {x}, q ≤ q' → F q' x = true → F q x = true

theorem NestedFamily.rejects_of_le {h : ℕ} {I : Type}
    {F : Fin h → (I → Bool) → Bool} (hF : NestedFamily F)
    {q q' : Fin h} {x} (hqq : q ≤ q') (hx : F q x = false) :
    F q' x = false := by
  cases h' : F q' x
  · rfl
  · have := hF.accepts_of_le hqq h'
    simp [hx] at this

/-- The number of coordinates whose one-bit flip changes both predicates. -/
def jointSensitivityAt {I : Type} [Fintype I]
    (f g : (I → Bool) → Bool) (x : I → Bool) : ℕ :=
  (Finset.univ.filter fun i =>
    f (flip x {i}) ≠ f x ∧ g (flip x {i}) ≠ g x).card

/-- Maximum sensitivity over all indices and inputs with the indicated output. -/
def sideSensitivity {h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (b : Bool) : ℕ :=
  Finset.univ.sup fun q => Finset.univ.sup fun x =>
    if F q x = b then sensitivityAt (F q) x else 0

/-- Maximum same-input, same-bit joint sensitivity over two distinct ordered indices. -/
def jointSensitivity {h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (b : Bool) : ℕ :=
  Finset.univ.sup fun q => Finset.univ.sup fun q' => Finset.univ.sup fun x =>
    if q < q' ∧ F q x = b ∧ F q' x = b then
      jointSensitivityAt (F q) (F q') x else 0

theorem sensitivityAt_le_sideSensitivity {h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (b : Bool) (q : Fin h) (x : I → Bool)
    (hx : F q x = b) : sensitivityAt (F q) x ≤ sideSensitivity F b := by
  apply Finset.le_sup_of_le (Finset.mem_univ q)
  apply Finset.le_sup_of_le (Finset.mem_univ x)
  simp [hx]

theorem sideSensitivity_le {h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (b : Bool) (B : ℕ)
    (hB : ∀ q x, F q x = b → sensitivityAt (F q) x ≤ B) :
    sideSensitivity F b ≤ B := by
  apply Finset.sup_le
  intro q _
  apply Finset.sup_le
  intro x _
  split_ifs with hx
  · exact hB q x hx
  · exact Nat.zero_le _

theorem jointSensitivityAt_le_jointSensitivity {h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (b : Bool) (q q' : Fin h) (x : I → Bool)
    (hqq : q < q') (hx : F q x = b) (hx' : F q' x = b) :
    jointSensitivityAt (F q) (F q') x ≤ jointSensitivity F b := by
  apply Finset.le_sup_of_le (Finset.mem_univ q)
  apply Finset.le_sup_of_le (Finset.mem_univ q')
  apply Finset.le_sup_of_le (Finset.mem_univ x)
  simp [hqq, hx, hx']

theorem jointSensitivity_le {h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (b : Bool) (B : ℕ)
    (hB : ∀ q q' x, q < q' → F q x = b → F q' x = b →
      jointSensitivityAt (F q) (F q') x ≤ B) : jointSensitivity F b ≤ B := by
  apply Finset.sup_le
  intro q _
  apply Finset.sup_le
  intro q' _
  apply Finset.sup_le
  intro x _
  split_ifs with hx
  · exact hB q q' x hx.1 hx.2.1 hx.2.2
  · exact Nat.zero_le _

theorem jointSensitivityAt_le_left {I : Type} [Fintype I]
    (f g : (I → Bool) → Bool) (x : I → Bool) :
    jointSensitivityAt f g x ≤ sensitivityAt f x := by
  apply Finset.card_le_card
  intro i hi
  exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, (Finset.mem_filter.mp hi).2.1⟩

theorem jointSensitivityAt_comm {I : Type} [Fintype I]
    (f g : (I → Bool) → Bool) (x : I → Bool) :
    jointSensitivityAt f g x = jointSensitivityAt g f x := by
  simp only [jointSensitivityAt, and_comm]

theorem jointSensitivity_one {I : Type} [Fintype I]
    (F : Fin 1 → (I → Bool) → Bool) (b : Bool) : jointSensitivity F b = 0 := by
  apply Nat.eq_zero_of_le_zero
  apply jointSensitivity_le
  intro q q' x hqq _ _
  exact False.elim (by omega)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.InitialPredicates. -/

namespace OAI

/-! The separated Hamming-ball predicates and their explicit sensitive blocks. -/

noncomputable section
open scoped Classical

namespace Paper320

def blockCenter {M L : ℕ} (j : Fin M) : Fin M × Fin L → Bool :=
  fun p => decide (p.1 = j)

def baseBlock {M L : ℕ} (j : Fin M) : Finset (Fin M × Fin L) :=
  Finset.univ.filter fun p => p.1 = j

@[simp] theorem mem_baseBlock {M L : ℕ} (j : Fin M) (p : Fin M × Fin L) :
    p ∈ baseBlock j ↔ p.1 = j := by
  simp [baseBlock]

theorem baseBlock_card {M L : ℕ} (j : Fin M) : (baseBlock (L := L) j).card = L := by
  have h : (baseBlock (L := L) j).card = (Finset.univ : Finset (Fin L)).card := by
    apply Finset.card_bij (fun p _ => p.2)
    · intro p _
      exact Finset.mem_univ _
    · intro p hp q hq hpq
      exact Prod.ext (((mem_baseBlock j p).mp hp).trans ((mem_baseBlock j q).mp hq).symm) hpq
    · intro b _
      exact ⟨(j, b), (mem_baseBlock j (j, b)).mpr rfl, rfl⟩
  simpa using h

theorem baseBlock_nonempty {M L : ℕ} (hL : 0 < L) (j : Fin M) :
    (baseBlock (L := L) j).Nonempty := by
  rw [← Finset.card_pos, baseBlock_card]
  exact hL

theorem baseBlock_disjoint {M L : ℕ} :
    Pairwise fun i j : Fin M => Disjoint (baseBlock (L := L) i) (baseBlock j) := by
  intro i j hij
  apply Finset.disjoint_left.mpr
  rintro ⟨a, b⟩ hi hj
  simp only [mem_baseBlock] at hi hj
  exact hij (hi.symm.trans hj)

theorem flip_zero_baseBlock {M L : ℕ} (j : Fin M) :
    flip (fun _ : Fin M × Fin L => false) (baseBlock j) = blockCenter j := by
  ext p
  simp [flip, blockCenter]

theorem hammingDist_zero_blockCenter {M L : ℕ} (j : Fin M) :
    hammingDist (fun _ : Fin M × Fin L => false) (blockCenter j) = L := by
  have hs : (Finset.univ.filter fun p : Fin M × Fin L => false ≠ blockCenter j p) =
      baseBlock j := by
    ext p
    simp [blockCenter]
  rw [hammingDist, hs, baseBlock_card]

theorem hammingDist_blockCenter {M L : ℕ} (i j : Fin M) (hij : i ≠ j) :
    hammingDist (blockCenter (L := L) i) (blockCenter j) = 2 * L := by
  have hs : (Finset.univ.filter fun p : Fin M × Fin L =>
      blockCenter i p ≠ blockCenter j p) =
      baseBlock i ∪ baseBlock j := by
    ext ⟨a, b⟩
    by_cases ha : a = i <;> by_cases hb : a = j <;> simp_all [blockCenter]
  rw [hammingDist, hs]
  rw [Finset.card_union_of_disjoint (baseBlock_disjoint hij), baseBlock_card, baseBlock_card]
  omega

def initialFamily (d M : ℕ) : Fin (d + 1) → (Fin M × Fin (d + 2) → Bool) → Bool :=
  fun q => ballPredicate blockCenter (d - q.val)

theorem initialFamily_nested (d M : ℕ) : NestedFamily (initialFamily d M) := by
  constructor
  intro q q' x hqq hx
  exact ballPredicate_nested blockCenter (by omega) x hx

theorem initialFamily_zero (d M : ℕ) (q : Fin (d + 1)) :
    initialFamily d M q (fun _ => false) = false := by
  have hn : ¬ ∃ c : Fin M,
      hammingDist (fun _ : Fin M × Fin (d + 2) => false) (blockCenter c) ≤ d - q.val := by
    rintro ⟨c, hc⟩
    rw [hammingDist_zero_blockCenter] at hc
    omega
  simp [initialFamily, ballPredicate, hn]

theorem initialFamily_baseBlock (d M : ℕ) (q : Fin (d + 1)) (j : Fin M) :
    initialFamily d M q (flip (fun _ => false) (baseBlock j)) = true := by
  rw [flip_zero_baseBlock]
  apply (ballPredicate_eq_true blockCenter (d - q.val) (blockCenter j)).2
  exact ⟨j, by simp⟩

theorem initialFamily_side_zero (d M : ℕ) :
    sideSensitivity (initialFamily d M) false ≤ d + 2 := by
  apply sideSensitivity_le
  intro q x hx
  have hs : ∀ a b : Fin M, a ≠ b →
      2 * ((d - q.val) + 1) < hammingDist (blockCenter (L := d + 2) a) (blockCenter b) := by
    intro a b hab
    rw [hammingDist_blockCenter a b hab]
    omega
  exact (ballPredicate_sensitivityAt_zero_le blockCenter (d - q.val) hs x hx).trans
    (by omega)

theorem initialFamily_side_one (d M : ℕ) :
    sideSensitivity (initialFamily d M) true ≤ (d + 2) * M := by
  apply sideSensitivity_le
  intro q x _
  simpa [Nat.mul_comm] using sensitivityAt_le_card (initialFamily d M q) x

theorem initialFamily_joint (d M : ℕ) (b : Bool) :
    jointSensitivity (initialFamily d M) b = 0 := by
  apply Nat.eq_zero_of_le_zero
  apply jointSensitivity_le
  intro q q' x hqq hx hx'
  have hrad : d - q'.val < d - q.val := by omega
  unfold jointSensitivityAt
  have he : (Finset.univ.filter fun i =>
      initialFamily d M q (flip x {i}) ≠ initialFamily d M q x ∧
      initialFamily d M q' (flip x {i}) ≠ initialFamily d M q' x) = ∅ := by
    apply Finset.filter_eq_empty_iff.mpr
    intro i _ hi
    obtain ⟨hi, hi'⟩ := hi
    cases b with
    | false =>
        have hflip : initialFamily d M q' (flip x {i}) = true := by
          simpa [hx'] using hi'
        exact ballPredicate_no_joint_zero blockCenter hrad x i hx hflip
    | true =>
        have hflip : initialFamily d M q (flip x {i}) = false := by
          simpa [hx] using hi
        exact ballPredicate_no_joint_one blockCenter hrad x i hx' hflip
  rw [he]
  simp

theorem nearestDistance_blockCenter_zero (M L : ℕ) [NeZero M] :
    nearestDistance (blockCenter (M := M) (L := L)) (fun _ => false) = L := by
  simp [nearestDistance, hammingDist_zero_blockCenter]

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Tournament. -/

namespace OAI

/-! Finite tournaments and the target-constant labeling condition. -/

noncomputable section
open scoped Classical

namespace Paper320

structure Tournament (k : ℕ) extends Digraph (Fin k) where
  loopless : ∀ i, ¬ Adj i i
  edge_compl : ∀ {i j}, i ≠ j → (Adj i j ↔ ¬ Adj j i)

structure RegularTournament (M : ℕ) extends Tournament (2 * M^2 + 1) where
  outdegree : ∀ i, (Finset.univ.filter (Adj i)).card = M^2

structure GoodLabeling {k : ℕ} (T : Tournament k) (r : ℕ) where
  label : Fin k → Fin k → Fin r
  good : ∀ I : Finset (Fin k), I.card = 16 → ∀ m : Fin k → Fin r,
    ∃ i ∈ I, ∃ j ∈ I, T.Adj i j ∧ label i j ≠ m j

namespace Tournament
variable {k : ℕ} (T : Tournament k)

theorem ne_of_adj {i j : Fin k} (h : T.Adj i j) : i ≠ j := by
  rintro rfl
  exact T.loopless i h

theorem not_adj_reverse {i j : Fin k} (h : T.Adj i j) : ¬ T.Adj j i :=
  (T.edge_compl (T.ne_of_adj h)).mp h

theorem adj_or_reverse {i j : Fin k} (h : i ≠ j) : T.Adj i j ∨ T.Adj j i := by
  by_cases hh : T.Adj j i
  · exact Or.inr hh
  · exact Or.inl ((T.edge_compl h).mpr hh)

theorem internal_sink_unique {I : Finset (Fin k)} {i j : Fin k}
    (hi : i ∈ I) (hj : j ∈ I)
    (hsi : ∀ v ∈ I, ¬ T.Adj i v) (hsj : ∀ v ∈ I, ¬ T.Adj j v) : i = j := by
  by_contra h
  rcases T.adj_or_reverse h with hh | hh
  · exact hsi j hj hh
  · exact hsj i hi hh

end Tournament

namespace GoodLabeling
variable {k r : ℕ} {T : Tournament k} (A : GoodLabeling T r)

theorem good_implies_card_lt_sixteen (I : Finset (Fin k)) (m : Fin k → Fin r)
    (h : ∀ i ∈ I, ∀ j ∈ I, T.Adj i j → A.label i j = m j) : I.card < 16 := by
  by_contra hn
  obtain ⟨J, hJI, hJ⟩ := Finset.exists_subset_card_eq (show 16 ≤ I.card by omega)
  obtain ⟨i, hi, j, hj, hij, hne⟩ := A.good J hJ m
  exact hne (h i (hJI hi) j (hJI hj) hij)

end GoodLabeling
end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveDefinitions. -/

namespace OAI

/-! The literal target-row and labeled-gate construction. -/

noncomputable section
open scoped Classical

namespace Paper320

def recursiveChild {k r : ℕ} {I : Type}
    (x : ((Fin k × Fin r) × I) → Bool) (j : Fin k) (c : Fin r) : I → Bool :=
  fun a => x ((j, c), a)

def gateIndex {h : ℕ} (q : Fin h) : Fin (h + 1) := (Fin.rev q).castSucc

theorem gateIndex_lt_last {h : ℕ} (q : Fin h) : gateIndex q < Fin.last h :=
  Fin.castSucc_lt_last _

theorem gateIndex_antitone {h : ℕ} {q q' : Fin h} (hqq : q ≤ q') :
    gateIndex q' ≤ gateIndex q := by
  exact Fin.rev_le_rev.mpr hqq

theorem gateIndex_strictAnti {h : ℕ} {q q' : Fin h} (hqq : q < q') :
    gateIndex q' < gateIndex q := by
  exact Fin.rev_lt_rev.mpr hqq

/-- A clause uses every target in its own row and one labeled gate per outgoing edge. -/
def rowClause {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) : Bool :=
  decide ((∀ c, F (Fin.last h) (recursiveChild x i c) = true) ∧
    ∀ j, T.Adj i j → F (gateIndex q) (recursiveChild x j (label i j)) = false)

/-- The next-level predicate is the disjunction of the literal row clauses. -/
def recursiveFamily {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) : Bool :=
  decide (∃ i, rowClause T label F q x i = true)

theorem rowClause_eq_true_iff {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) :
    rowClause T label F q x i = true ↔
      (∀ c, F (Fin.last h) (recursiveChild x i c) = true) ∧
      ∀ j, T.Adj i j → F (gateIndex q) (recursiveChild x j (label i j)) = false := by
  simp only [rowClause, decide_eq_true_eq]

theorem recursiveFamily_eq_true_iff {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) :
    recursiveFamily T label F q x = true ↔ ∃ i, rowClause T label F q x i = true := by
  simp only [recursiveFamily, decide_eq_true_eq]

theorem recursiveFamily_eq_false_iff {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) :
    recursiveFamily T label F q x = false ↔ ∀ i, rowClause T label F q x i = false := by
  simp [recursiveFamily]

theorem rowClause_nested {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hF : NestedFamily F) {q q' : Fin h} (hqq : q ≤ q')
    (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k)
    (hi : rowClause T label F q' x i = true) : rowClause T label F q x i = true := by
  rw [rowClause_eq_true_iff] at hi ⊢
  refine ⟨hi.1, fun j hij => ?_⟩
  exact hF.rejects_of_le (gateIndex_antitone hqq) (hi.2 j hij)

theorem recursiveFamily_nested {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hF : NestedFamily F) : NestedFamily (recursiveFamily T label F) := by
  constructor
  intro q q' x hqq hx
  obtain ⟨i, hi⟩ := (recursiveFamily_eq_true_iff T label F q' x).mp hx
  exact (recursiveFamily_eq_true_iff T label F q x).mpr
    ⟨i, rowClause_nested T label F hF hqq x i hi⟩

theorem recursiveFamily_zero {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hr : 0 < r) (hzero : ∀ q, F q (fun _ => false) = false) (q : Fin h) :
    recursiveFamily T label F q (fun _ => false) = false := by
  rw [recursiveFamily_eq_false_iff]
  intro i
  cases hi : rowClause T label F q (fun _ => false) i
  · rfl
  · have ht := ((rowClause_eq_true_iff T label F q (fun _ => false) i).mp hi).1
      (⟨0, hr⟩ : Fin r)
    have hz := hzero (Fin.last h)
    change F (Fin.last h) (fun _ => false) = true at ht
    simp [hz] at ht

theorem recursive_coordinates_card {k r : ℕ} {I : Type} [Fintype I] :
    Fintype.card ((Fin k × Fin r) × I) = k * r * Fintype.card I := by
  simp

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveBlocks. -/

namespace OAI

/-! Disjoint zero-input blocks lift to every column of a chosen row. -/

noncomputable section
open scoped Classical

namespace Paper320

def rowLift {k r : ℕ} {I : Type} (i : Fin k) (B : Finset I) :
    Finset ((Fin k × Fin r) × I) :=
  (Finset.univ.product B).map
    ⟨fun p : Fin r × I => ((i, p.1), p.2), by
      intro p q hpq
      exact Prod.ext (congrArg (fun z => z.1.2) hpq) (congrArg (fun z : (Fin k × Fin r) × I => z.2) hpq)⟩

@[simp] theorem mem_rowLift {k r : ℕ} {I : Type} (i : Fin k) (B : Finset I)
    (p : (Fin k × Fin r) × I) : p ∈ rowLift (r := r) i B ↔ p.1.1 = i ∧ p.2 ∈ B := by
  rcases p with ⟨⟨j, c⟩, a⟩
  unfold rowLift
  rw [Finset.mem_map]
  constructor
  · rintro ⟨⟨c', b⟩, hb, hp⟩
    change ((i, c'), b) = ((j, c), a) at hp
    cases hp
    exact ⟨rfl, (Finset.mem_product.mp hb).2⟩
  · rintro ⟨rfl, ha⟩
    exact ⟨(c, a), Finset.mem_product.mpr ⟨Finset.mem_univ _, ha⟩, rfl⟩

theorem rowLift_card {k r : ℕ} {I : Type} (i : Fin k) (B : Finset I) :
    (rowLift (r := r) i B).card = r * B.card := by
  simp [rowLift]

theorem rowLift_nonempty {k r : ℕ} {I : Type} (i : Fin k) (B : Finset I)
    (hr : 0 < r) (hB : B.Nonempty) : (rowLift (r := r) i B).Nonempty := by
  obtain ⟨a, ha⟩ := hB
  exact ⟨((i, ⟨0, hr⟩), a), (mem_rowLift i B _).mpr ⟨rfl, ha⟩⟩

theorem rowLift_disjoint_of_ne {k r : ℕ} {I : Type} (i j : Fin k)
    (B C : Finset I) (hij : i ≠ j) : Disjoint (rowLift (r := r) i B) (rowLift j C) := by
  apply Finset.disjoint_left.mpr
  intro p hp hq
  exact hij (((mem_rowLift i B p).mp hp).1.symm.trans ((mem_rowLift j C p).mp hq).1)

theorem rowLift_disjoint {k r : ℕ} {I : Type} (i j : Fin k) (B C : Finset I)
    (hBC : Disjoint B C) : Disjoint (rowLift (r := r) i B) (rowLift j C) := by
  apply Finset.disjoint_left.mpr
  intro p hp hq
  exact Finset.disjoint_left.mp hBC ((mem_rowLift i B p).mp hp).2
    ((mem_rowLift j C p).mp hq).2

theorem rowLift_family_disjoint {k r : ℕ} {I K : Type} (blocks : K → Finset I)
    (hB : Pairwise fun a b => Disjoint (blocks a) (blocks b)) :
    Pairwise fun a b : Fin k × K =>
      Disjoint (rowLift (r := r) a.1 (blocks a.2)) (rowLift b.1 (blocks b.2)) := by
  intro a b hab
  by_cases hrow : a.1 = b.1
  · apply rowLift_disjoint
    apply hB
    intro hcol
    exact hab (Prod.ext hrow hcol)
  · exact rowLift_disjoint_of_ne _ _ _ _ hrow

theorem recursiveChild_rowLift_same {k r : ℕ} {I : Type}
    (i : Fin k) (B : Finset I) (c : Fin r) :
    recursiveChild (flip (fun _ => false) (rowLift (r := r) i B)) i c =
      flip (fun _ => false) B := by
  funext a
  simp [recursiveChild, flip]

theorem recursiveChild_rowLift_other {k r : ℕ} {I : Type}
    (i j : Fin k) (B : Finset I) (c : Fin r) (hji : j ≠ i) :
    recursiveChild (flip (fun _ => false) (rowLift (r := r) i B)) j c =
      fun _ => false := by
  funext a
  simp [recursiveChild, flip, hji]

theorem recursiveFamily_rowLift {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hzero : ∀ q, F q (fun _ => false) = false) (B : Finset I)
    (hB : ∀ q, F q (flip (fun _ => false) B) = true) (i : Fin k) (q : Fin h) :
    recursiveFamily T label F q (flip (fun _ => false) (rowLift i B)) = true := by
  apply (recursiveFamily_eq_true_iff _ _ _ _ _).mpr
  refine ⟨i, (rowClause_eq_true_iff _ _ _ _ _ _).mpr ⟨?_, ?_⟩⟩
  · intro c
    rw [recursiveChild_rowLift_same]
    exact hB _
  · intro j hij
    rw [recursiveChild_rowLift_other _ _ _ _ (T.ne_of_adj hij).symm]
    exact hzero _

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveFlips. -/

namespace OAI

/-! A raw bit belongs to one child and changes at most one condition of a clause. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem recursiveChild_flip_same {k r : ℕ} {I : Type}
    (x : ((Fin k × Fin r) × I) → Bool) (j : Fin k) (c : Fin r) (a : I) :
    recursiveChild (flip x {((j, c), a)}) j c = flip (recursiveChild x j c) {a} :=
  flip_prod_same x (j, c) a

theorem recursiveChild_flip_other {k r : ℕ} {I : Type}
    (x : ((Fin k × Fin r) × I) → Bool) (j j' : Fin k) (c c' : Fin r) (a : I)
    (h : (j', c') ≠ (j, c)) :
    recursiveChild (flip x {((j, c), a)}) j' c' = recursiveChild x j' c' :=
  flip_prod_other x a h

theorem rowClause_eq_of_conditions {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x y : ((Fin k × Fin r) × I) → Bool) (i : Fin k)
    (ht : ∀ c, F (Fin.last h) (recursiveChild x i c) =
      F (Fin.last h) (recursiveChild y i c))
    (hg : ∀ j, T.Adj i j → F (gateIndex q) (recursiveChild x j (label i j)) =
      F (gateIndex q) (recursiveChild y j (label i j))) :
    rowClause T label F q x i = rowClause T label F q y i := by
  apply Bool.eq_iff_iff.mpr
  rw [rowClause_eq_true_iff, rowClause_eq_true_iff]
  constructor
  · rintro ⟨hxt, hxg⟩
    exact ⟨fun c => (ht c).symm.trans (hxt c),
      fun j hij => (hg j hij).symm.trans (hxg j hij)⟩
  · rintro ⟨hyt, hyg⟩
    exact ⟨fun c => (ht c).trans (hyt c),
      fun j hij => (hg j hij).trans (hyg j hij)⟩

theorem rowClause_flip_eq {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i j : Fin k) (c : Fin r) (a : I)
    (ht : j = i → F (Fin.last h) (flip (recursiveChild x j c) {a}) =
      F (Fin.last h) (recursiveChild x j c))
    (hg : T.Adj i j → c = label i j →
      F (gateIndex q) (flip (recursiveChild x j c) {a}) =
        F (gateIndex q) (recursiveChild x j c)) :
    rowClause T label F q (flip x {((j, c), a)}) i = rowClause T label F q x i := by
  apply rowClause_eq_of_conditions
  · intro c'
    by_cases heq : (i, c') = (j, c)
    · obtain ⟨rfl, rfl⟩ := Prod.mk.inj heq
      rw [recursiveChild_flip_same]
      exact ht rfl
    · rw [recursiveChild_flip_other x j i c c' a heq]
  · intro j' hij'
    by_cases heq : (j', label i j') = (j, c)
    · obtain ⟨rfl, rfl⟩ := Prod.mk.inj heq
      rw [recursiveChild_flip_same]
      exact hg hij' rfl
    · rw [recursiveChild_flip_other x j j' c (label i j') a heq]

theorem rowClause_flip_change {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i j : Fin k) (c : Fin r) (a : I)
    (hc : rowClause T label F q (flip x {((j, c), a)}) i ≠ rowClause T label F q x i) :
    (j = i ∧ F (Fin.last h) (flip (recursiveChild x j c) {a}) ≠
      F (Fin.last h) (recursiveChild x j c)) ∨
    (T.Adj i j ∧ c = label i j ∧
      F (gateIndex q) (flip (recursiveChild x j c) {a}) ≠
        F (gateIndex q) (recursiveChild x j c)) := by
  by_contra hn
  apply hc
  apply rowClause_flip_eq
  · intro hji
    by_contra hne
    exact hn (Or.inl ⟨hji, hne⟩)
  · intro hij hcl
    by_contra hne
    exact hn (Or.inr ⟨hij, hcl, hne⟩)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveSets. -/

namespace OAI

/-! Finite sets of changing raw coordinates inside an individual child. -/

noncomputable section
open scoped Classical

namespace Paper320

def childLift {J I : Type} (j : J) (A : Finset I) : Finset (J × I) :=
  A.map ⟨fun a => (j, a), fun _ _ h => congrArg (fun p : J × I => p.2) h⟩

@[simp] theorem mem_childLift {J I : Type} (j : J) (A : Finset I) (p : J × I) :
    p ∈ childLift j A ↔ p.1 = j ∧ p.2 ∈ A := by
  rcases p with ⟨k, a⟩
  unfold childLift
  rw [Finset.mem_map]
  constructor
  · rintro ⟨b, hb, hp⟩
    change (j, b) = (k, a) at hp
    cases hp
    exact ⟨rfl, hb⟩
  · rintro ⟨rfl, ha⟩
    exact ⟨a, ha, rfl⟩

@[simp] theorem childLift_card {J I : Type} (j : J) (A : Finset I) :
    (childLift j A).card = A.card := Finset.card_map _

def childChanges {k r h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (q : Fin h)
    (x : ((Fin k × Fin r) × I) → Bool) (j : Fin k) (c : Fin r) :
    Finset ((Fin k × Fin r) × I) :=
  childLift (j, c) (Finset.univ.filter fun a =>
    F q (flip (recursiveChild x j c) {a}) ≠ F q (recursiveChild x j c))

def childJointChanges {k r h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (q q' : Fin h)
    (x : ((Fin k × Fin r) × I) → Bool) (j : Fin k) (c : Fin r) :
    Finset ((Fin k × Fin r) × I) :=
  childLift (j, c) (Finset.univ.filter fun a =>
    F q (flip (recursiveChild x j c) {a}) ≠ F q (recursiveChild x j c) ∧
    F q' (flip (recursiveChild x j c) {a}) ≠ F q' (recursiveChild x j c))

@[simp] theorem childChanges_card {k r h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (q : Fin h)
    (x : ((Fin k × Fin r) × I) → Bool) (j : Fin k) (c : Fin r) :
    (childChanges F q x j c).card = sensitivityAt (F q) (recursiveChild x j c) := by
  simp [childChanges, sensitivityAt]

@[simp] theorem childJointChanges_card {k r h : ℕ} {I : Type} [Fintype I]
    (F : Fin h → (I → Bool) → Bool) (q q' : Fin h)
    (x : ((Fin k × Fin r) × I) → Bool) (j : Fin k) (c : Fin r) :
    (childJointChanges F q q' x j c).card =
      jointSensitivityAt (F q) (F q') (recursiveChild x j c) := by
  simp [childJointChanges, jointSensitivityAt]

theorem card_biUnion_le_mul {J I : Type} [DecidableEq I] (A : Finset J) (B : J → Finset I) (n : ℕ)
    (hn : ∀ j ∈ A, (B j).card ≤ n) : (A.biUnion B).card ≤ A.card * n := by
  calc
    (A.biUnion B).card ≤ ∑ j ∈ A, (B j).card := Finset.card_biUnion_le
    _ ≤ ∑ _j ∈ A, n := Finset.sum_le_sum hn
    _ = A.card * n := by simp

theorem rowClause_joint_flip_change {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q q' : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (i j : Fin k) (c : Fin r) (a : I)
    (hc : rowClause T label F q (flip x {((j, c), a)}) i ≠ rowClause T label F q x i)
    (hc' : rowClause T label F q' (flip x {((j, c), a)}) i ≠ rowClause T label F q' x i) :
    (j = i ∧ F (Fin.last h) (flip (recursiveChild x j c) {a}) ≠
      F (Fin.last h) (recursiveChild x j c)) ∨
    (T.Adj i j ∧ c = label i j ∧
      F (gateIndex q) (flip (recursiveChild x j c) {a}) ≠
        F (gateIndex q) (recursiveChild x j c) ∧
      F (gateIndex q') (flip (recursiveChild x j c) {a}) ≠
        F (gateIndex q') (recursiveChild x j c)) := by
  rcases rowClause_flip_change T label F q x i j c a hc with ht | ⟨hij, hcl, hq⟩
  · exact Or.inl ht
  · rcases rowClause_flip_change T label F q' x i j c a hc' with ht | hg
    · exact False.elim ((T.ne_of_adj hij) ht.1.symm)
    · exact Or.inr ⟨hij, hcl, hq, hg.2.2⟩

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveOne. -/

namespace OAI

/-! The two recurrences for inputs at which the parent predicates accept. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem recursive_sensitivity_one_at {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (label : Fin k → Fin k → Fin r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (o : ℕ)
    (ho : ∀ i, (Finset.univ.filter (T.Adj i)).card = o)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (hx : recursiveFamily T label F q x = true) :
    sensitivityAt (recursiveFamily T label F q) x ≤
      o * sideSensitivity F false + r * sideSensitivity F true := by
  obtain ⟨i, hi⟩ := (recursiveFamily_eq_true_iff T label F q x).mp hx
  have hcond := (rowClause_eq_true_iff T label F q x i).mp hi
  let U := Finset.univ.biUnion fun c => childChanges F (Fin.last h) x i c
  let V := (Finset.univ.filter (T.Adj i)).biUnion fun j =>
    childChanges F (gateIndex q) x j (label i j)
  have hsub : (Finset.univ.filter fun p =>
      recursiveFamily T label F q (flip x {p}) ≠ recursiveFamily T label F q x) ⊆ U ∪ V := by
    rintro ⟨⟨j, c⟩, a⟩ hp
    have hchange := (Finset.mem_filter.mp hp).2
    have hf : recursiveFamily T label F q (flip x {((j, c), a)}) = false := by
      cases hy : recursiveFamily T label F q (flip x {((j, c), a)})
      · rfl
      · exact False.elim (hchange (hy.trans hx.symm))
    have hif := (recursiveFamily_eq_false_iff T label F q _).mp hf i
    have hic : rowClause T label F q (flip x {((j, c), a)}) i ≠ rowClause T label F q x i := by
      simp [hi, hif]
    rcases rowClause_flip_change T label F q x i j c a hic with ⟨rfl, ht⟩ | ⟨hij, rfl, hg⟩
    · apply Finset.mem_union_left
      apply Finset.mem_biUnion.mpr
      exact ⟨c, Finset.mem_univ _, by simpa [childChanges] using ht⟩
    · apply Finset.mem_union_right
      apply Finset.mem_biUnion.mpr
      exact ⟨j, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hij⟩,
        by simpa [childChanges] using hg⟩
  have hU : U.card ≤ r * sideSensitivity F true := by
    simpa [U] using card_biUnion_le_mul Finset.univ
      (fun c => childChanges F (Fin.last h) x i c) (sideSensitivity F true)
      (fun c _ => by
        rw [childChanges_card]
        exact sensitivityAt_le_sideSensitivity F true _ _ (hcond.1 c))
  have hV : V.card ≤ o * sideSensitivity F false := by
    simpa only [V, ho i] using card_biUnion_le_mul (Finset.univ.filter (T.Adj i))
      (fun j => childChanges F (gateIndex q) x j (label i j)) (sideSensitivity F false)
      (fun j hj => by
        rw [childChanges_card]
        exact sensitivityAt_le_sideSensitivity F false _ _
          (hcond.2 j (Finset.mem_filter.mp hj).2))
  calc
    sensitivityAt (recursiveFamily T label F q) x ≤ (U ∪ V).card := Finset.card_le_card hsub
    _ ≤ U.card + V.card := Finset.card_union_le _ _
    _ ≤ r * sideSensitivity F true + o * sideSensitivity F false := Nat.add_le_add hU hV
    _ = _ := Nat.add_comm _ _

theorem recursive_side_one {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (label : Fin k → Fin k → Fin r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (o : ℕ)
    (ho : ∀ i, (Finset.univ.filter (T.Adj i)).card = o) :
    sideSensitivity (recursiveFamily T label F) true ≤
      o * sideSensitivity F false + r * sideSensitivity F true := by
  apply sideSensitivity_le
  exact fun q x hx => recursive_sensitivity_one_at T label F o ho q x hx

theorem recursive_joint_one_at {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (label : Fin k → Fin k → Fin r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (o : ℕ)
    (ho : ∀ i, (Finset.univ.filter (T.Adj i)).card = o)
    (q q' : Fin h) (hqq : q < q') (x : ((Fin k × Fin r) × I) → Bool)
    (hx : recursiveFamily T label F q x = true)
    (hx' : recursiveFamily T label F q' x = true) :
    jointSensitivityAt (recursiveFamily T label F q) (recursiveFamily T label F q') x ≤
      o * jointSensitivity F false + r * sideSensitivity F true := by
  obtain ⟨i, hi'⟩ := (recursiveFamily_eq_true_iff T label F q' x).mp hx'
  have hi := rowClause_nested T label F hF hqq.le x i hi'
  have hcond := (rowClause_eq_true_iff T label F q x i).mp hi
  have hcond' := (rowClause_eq_true_iff T label F q' x i).mp hi'
  let U := Finset.univ.biUnion fun c => childChanges F (Fin.last h) x i c
  let V := (Finset.univ.filter (T.Adj i)).biUnion fun j =>
    childJointChanges F (gateIndex q') (gateIndex q) x j (label i j)
  have hsub : (Finset.univ.filter fun p =>
      recursiveFamily T label F q (flip x {p}) ≠ recursiveFamily T label F q x ∧
      recursiveFamily T label F q' (flip x {p}) ≠ recursiveFamily T label F q' x) ⊆ U ∪ V := by
    rintro ⟨⟨j, c⟩, a⟩ hp
    have hchange := (Finset.mem_filter.mp hp).2
    have hf : recursiveFamily T label F q (flip x {((j, c), a)}) = false := by
      cases hy : recursiveFamily T label F q (flip x {((j, c), a)})
      · rfl
      · exact False.elim (hchange.1 (hy.trans hx.symm))
    have hf' : recursiveFamily T label F q' (flip x {((j, c), a)}) = false := by
      cases hy : recursiveFamily T label F q' (flip x {((j, c), a)})
      · rfl
      · exact False.elim (hchange.2 (hy.trans hx'.symm))
    have hif := (recursiveFamily_eq_false_iff T label F q _).mp hf i
    have hif' := (recursiveFamily_eq_false_iff T label F q' _).mp hf' i
    have hic : rowClause T label F q (flip x {((j, c), a)}) i ≠ rowClause T label F q x i := by
      simp [hi, hif]
    have hic' : rowClause T label F q' (flip x {((j, c), a)}) i ≠ rowClause T label F q' x i := by
      simp [hi', hif']
    rcases rowClause_joint_flip_change T label F q q' x i j c a hic hic' with
      ⟨rfl, ht⟩ | ⟨hij, rfl, hg, hg'⟩
    · apply Finset.mem_union_left
      apply Finset.mem_biUnion.mpr
      exact ⟨c, Finset.mem_univ _, by simpa [childChanges] using ht⟩
    · apply Finset.mem_union_right
      apply Finset.mem_biUnion.mpr
      exact ⟨j, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hij⟩,
        by simpa [childJointChanges] using And.intro hg' hg⟩
  have hU : U.card ≤ r * sideSensitivity F true := by
    simpa [U] using card_biUnion_le_mul Finset.univ
      (fun c => childChanges F (Fin.last h) x i c) (sideSensitivity F true)
      (fun c _ => by
        rw [childChanges_card]
        exact sensitivityAt_le_sideSensitivity F true _ _ (hcond.1 c))
  have hV : V.card ≤ o * jointSensitivity F false := by
    simpa only [V, ho i] using card_biUnion_le_mul (Finset.univ.filter (T.Adj i))
      (fun j => childJointChanges F (gateIndex q') (gateIndex q) x j (label i j))
      (jointSensitivity F false) (fun j hj => by
        have hij := (Finset.mem_filter.mp hj).2
        rw [childJointChanges_card]
        exact jointSensitivityAt_le_jointSensitivity F false _ _ _
          (gateIndex_strictAnti hqq) (hcond'.2 j hij) (hcond.2 j hij))
  calc
    jointSensitivityAt (recursiveFamily T label F q) (recursiveFamily T label F q') x ≤
        (U ∪ V).card := Finset.card_le_card hsub
    _ ≤ U.card + V.card := Finset.card_union_le _ _
    _ ≤ r * sideSensitivity F true + o * jointSensitivity F false := Nat.add_le_add hU hV
    _ = _ := Nat.add_comm _ _

theorem recursive_joint_one {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (label : Fin k → Fin k → Fin r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (o : ℕ)
    (ho : ∀ i, (Finset.univ.filter (T.Adj i)).card = o) :
    jointSensitivity (recursiveFamily T label F) true ≤
      o * jointSensitivity F false + r * sideSensitivity F true := by
  apply jointSensitivity_le
  exact fun q q' x hqq hx hx' => recursive_joint_one_at T label F hF o ho q q' hqq x hx hx'

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.TournamentCounts. -/

namespace OAI

/-! The exact internal edge count and the small gate-candidate bound. -/

noncomputable section
open scoped Classical BigOperators

namespace Paper320.Tournament
variable {k : ℕ} (T : Tournament k)

def internalEdges (I : Finset (Fin k)) : Finset (Fin k × Fin k) :=
  (I ×ˢ I).filter fun p => T.Adj p.1 p.2

theorem card_internalEdges (I : Finset (Fin k)) :
    (T.internalEdges I).card = I.card.choose 2 := by
  let U := T.internalEdges I
  let V := (I ×ˢ I).filter fun p => T.Adj p.2 p.1
  have hd : Disjoint U V := by
    apply Finset.disjoint_left.mpr
    intro p hp hq
    exact T.not_adj_reverse (Finset.mem_filter.mp hp).2 (Finset.mem_filter.mp hq).2
  have hu : U.disjUnion V hd = I.offDiag := by
    ext ⟨i,j⟩
    simp only [Finset.mem_disjUnion, U, V, internalEdges, Finset.mem_filter,
      Finset.mem_product, Finset.mem_offDiag]
    constructor
    · rintro (⟨⟨hi,hj⟩,h⟩ | ⟨⟨hi,hj⟩,h⟩)
      · exact ⟨hi,hj,T.ne_of_adj h⟩
      · exact ⟨hi,hj,(T.ne_of_adj h).symm⟩
    · rintro ⟨hi,hj,hne⟩
      exact (T.adj_or_reverse hne).imp (fun h => ⟨⟨hi,hj⟩,h⟩) (fun h => ⟨⟨hi,hj⟩,h⟩)
  have hs : U.card = V.card := Finset.card_equiv (Equiv.prodComm (Fin k) (Fin k)) (by
    intro p
    simp only [U,V,internalEdges,Finset.mem_filter,Finset.mem_product,Equiv.prodComm_apply]
    tauto)
  have hc := congrArg Finset.card hu
  rw [Finset.card_disjUnion, ← hs, Finset.offDiag_card] at hc
  rw [Nat.choose_two_right, Nat.mul_sub_one]
  change U.card = _
  omega

theorem sum_outdegree_eq (I : Finset (Fin k)) :
    ∑ i ∈ I, (I.filter (T.Adj i)).card = (T.internalEdges I).card := by
  simp only [internalEdges, Finset.card_eq_sum_ones, Finset.sum_filter, Finset.sum_product]

theorem card_le_three_of_outdegree_le_one (I : Finset (Fin k))
    (h : ∀ i ∈ I, (I.filter (T.Adj i)).card ≤ 1) : I.card ≤ 3 := by
  have hsum := Finset.sum_le_sum h
  have hc : I.card.choose 2 ≤ I.card := by
    rw [← T.card_internalEdges, ← T.sum_outdegree_eq]
    simpa only [Finset.sum_const_nat, mul_one] using hsum
  have hdouble : I.card * (I.card - 1) ≤ 2 * I.card + 1 := by
    rw [Nat.choose_two_right] at hc
    omega
  by_contra hn
  have h4 : 4 ≤ I.card := by omega
  have ht : I.card - 1 + 1 = I.card := by omega
  nlinarith

end Paper320.Tournament

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveFailures. -/

namespace OAI

/-! Fixed initial-input lists of clauses with exactly one failed condition. -/

noncomputable section
open scoped Classical

namespace Paper320

def targetFailures {k r h : ℕ} {I : Type}
    (F : Fin (h + 1) → (I → Bool) → Bool)
    (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) : Finset (Fin r) :=
  Finset.univ.filter fun c => F (Fin.last h) (recursiveChild x i c) = false

def gateFailures {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) : Finset (Fin k) :=
  Finset.univ.filter fun j => T.Adj i j ∧
    F (gateIndex q) (recursiveChild x j (label i j)) = true

def targetCandidates {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) : Finset (Fin k) :=
  Finset.univ.filter fun i => (targetFailures F x i).card = 1 ∧ gateFailures T label F q x i = ∅

def gateCandidates {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) : Finset (Fin k) :=
  Finset.univ.filter fun i => targetFailures F x i = ∅ ∧ (gateFailures T label F q x i).card = 1

def targetWitness {k r h : ℕ} {I : Type}
    (F : Fin (h + 1) → (I → Bool) → Bool)
    (x : ((Fin k × Fin r) × I) → Bool) (hr : 0 < r) (i : Fin k) : Fin r :=
  if hi : (targetFailures F x i).Nonempty then hi.choose else ⟨0, hr⟩

def gateWitness {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) : Fin k :=
  if hi : (gateFailures T label F q x i).Nonempty then hi.choose else i

theorem targetFailures_empty_iff {k r h : ℕ} {I : Type}
    (F : Fin (h + 1) → (I → Bool) → Bool)
    (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) :
    targetFailures F x i = ∅ ↔ ∀ c, F (Fin.last h) (recursiveChild x i c) = true := by
  simp [targetFailures, Finset.filter_eq_empty_iff]

theorem gateFailures_empty_iff {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k) :
    gateFailures T label F q x i = ∅ ↔
      ∀ j, T.Adj i j → F (gateIndex q) (recursiveChild x j (label i j)) = false := by
  simp [gateFailures, Finset.filter_eq_empty_iff]

theorem targetFailures_singleton {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (hr : 0 < r) (i : Fin k)
    (hi : i ∈ targetCandidates T label F q x) :
    targetFailures F x i = {targetWitness F x hr i} := by
  have hc := (Finset.mem_filter.mp hi).2.1
  obtain ⟨c, hc'⟩ := Finset.card_eq_one.mp hc
  have hne : (targetFailures F x i).Nonempty := hc' ▸ Finset.singleton_nonempty c
  have hm : targetWitness F x hr i ∈ targetFailures F x i := by
    simp only [targetWitness, dite_eq_left hne]
    exact hne.choose_spec
  rw [hc', Finset.mem_singleton] at hm
  simpa [hm] using hc'

theorem gateFailures_singleton {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k)
    (hi : i ∈ gateCandidates T label F q x) :
    gateFailures T label F q x i = {gateWitness T label F q x i} := by
  have hc := (Finset.mem_filter.mp hi).2.2
  obtain ⟨j, hc'⟩ := Finset.card_eq_one.mp hc
  have hne : (gateFailures T label F q x i).Nonempty := hc' ▸ Finset.singleton_nonempty j
  have hm : gateWitness T label F q x i ∈ gateFailures T label F q x i := by
    simp only [gateWitness, dite_eq_left hne]
    exact hne.choose_spec
  rw [hc', Finset.mem_singleton] at hm
  simpa [hm] using hc'

theorem targetCandidates_card {k r h : ℕ} {I : Type} (T : Tournament k)
    (A : GoodLabeling T r) (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (hr : 0 < r) :
    (targetCandidates T A.label F q x).card < 16 := by
  apply A.good_implies_card_lt_sixteen _ (targetWitness F x hr)
  intro i hi j hj hij
  have hgate := (gateFailures_empty_iff T A.label F q x i).mp (Finset.mem_filter.mp hi).2.2
  have hz := hF.rejects_of_le (gateIndex_lt_last q).le (hgate j hij)
  have hm : A.label i j ∈ targetFailures F x j := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hz⟩
  rw [targetFailures_singleton T A.label F q x hr j hj, Finset.mem_singleton] at hm
  exact hm

theorem gateCandidates_neighbor {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hF : NestedFamily F) (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (i j : Fin k) (hi : i ∈ gateCandidates T label F q x)
    (hj : j ∈ gateCandidates T label F q x) (hij : T.Adj i j) :
    j = gateWitness T label F q x i := by
  have ht := (targetFailures_empty_iff F x j).mp (Finset.mem_filter.mp hj).2.1
  have hon := hF.accepts_of_le (gateIndex_lt_last q).le (ht (label i j))
  have hm : j ∈ gateFailures T label F q x i := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hij, hon⟩
  rwa [gateFailures_singleton T label F q x i hi, Finset.mem_singleton] at hm

theorem gateCandidates_card {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hF : NestedFamily F) (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) :
    (gateCandidates T label F q x).card ≤ 3 := by
  apply T.card_le_three_of_outdegree_le_one
  intro i hi
  apply le_trans (Finset.card_le_card (t := {gateWitness T label F q x i}) ?_)
    (by simp)
  intro j hj
  have h := Finset.mem_filter.mp hj
  exact Finset.mem_singleton.mpr (gateCandidates_neighbor T label F hF q x i j hi h.1 h.2)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveRepair. -/

namespace OAI

/-! A successful raw-bit flip repairs the unique initial failed condition. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem repaired_target_location {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (i j : Fin k) (c c' : Fin r) (a : I)
    (hf : rowClause T label F q (flip x {((j, c), a)}) i = true)
    (hz : F (Fin.last h) (recursiveChild x i c') = false) : (i, c') = (j, c) := by
  by_contra hne
  have ht := ((rowClause_eq_true_iff T label F q _ i).mp hf).1 c'
  rw [recursiveChild_flip_other x j i c c' a hne, hz] at ht
  exact Bool.false_ne_true ht

theorem repaired_gate_location {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (i j j' : Fin k) (c : Fin r) (a : I)
    (hf : rowClause T label F q (flip x {((j, c), a)}) i = true)
    (hij' : T.Adj i j') (hon : F (gateIndex q) (recursiveChild x j' (label i j')) = true) :
    (j', label i j') = (j, c) := by
  by_contra hne
  have hg := ((rowClause_eq_true_iff T label F q _ i).mp hf).2 j' hij'
  rw [recursiveChild_flip_other x j j' c (label i j') a hne, hon] at hg
  exact Bool.false_ne_true hg.symm

theorem rowClause_repair_cases {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (i j : Fin k) (c : Fin r) (a : I)
    (hi : rowClause T label F q x i = false)
    (hf : rowClause T label F q (flip x {((j, c), a)}) i = true) :
    (i ∈ targetCandidates T label F q x ∧ j = i ∧
      F (Fin.last h) (recursiveChild x j c) = false ∧
      F (Fin.last h) (flip (recursiveChild x j c) {a}) = true) ∨
    (i ∈ gateCandidates T label F q x ∧ T.Adj i j ∧ c = label i j ∧
      F (gateIndex q) (recursiveChild x j c) = true ∧
      F (gateIndex q) (flip (recursiveChild x j c) {a}) = false) := by
  have hchange : rowClause T label F q (flip x {((j, c), a)}) i ≠ rowClause T label F q x i := by
    simp [hi, hf]
  rcases rowClause_flip_change T label F q x i j c a hchange with
    ⟨hji, ht⟩ | ⟨hij, rfl, hg⟩
  · subst j
    have hton := ((rowClause_eq_true_iff T label F q _ i).mp hf).1 c
    rw [recursiveChild_flip_same] at hton
    have htoff : F (Fin.last h) (recursiveChild x i c) = false := by
      cases hc : F (Fin.last h) (recursiveChild x i c)
      · rfl
      · exact False.elim (ht (hton.trans hc.symm))
    have htargets : targetFailures F x i = {c} := by
      ext c'
      simp only [targetFailures, Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_singleton]
      constructor
      · intro hfalse
        exact congrArg Prod.snd (repaired_target_location T label F q x i i c c' a hf hfalse)
      · rintro rfl
        exact htoff
    have hgates : gateFailures T label F q x i = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro j' hj'
      have h := (Finset.mem_filter.mp hj').2
      have heq := repaired_gate_location T label F q x i i j' c a hf h.1 h.2
      exact T.ne_of_adj h.1 (congrArg Prod.fst heq).symm
    have hmem : i ∈ targetCandidates T label F q x := by
      simp [targetCandidates, htargets, hgates]
    exact Or.inl ⟨hmem, rfl, htoff, hton⟩
  · have hgoff := ((rowClause_eq_true_iff T label F q _ i).mp hf).2 j hij
    rw [recursiveChild_flip_same] at hgoff
    have hgon : F (gateIndex q) (recursiveChild x j (label i j)) = true := by
      cases hc : F (gateIndex q) (recursiveChild x j (label i j))
      · exact False.elim (hg (hgoff.trans hc.symm))
      · rfl
    have htargets : targetFailures F x i = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro c' hc'
      have heq := repaired_target_location T label F q x i j (label i j) c' a hf
        (Finset.mem_filter.mp hc').2
      exact T.ne_of_adj hij (congrArg Prod.fst heq)
    have hgates : gateFailures T label F q x i = {j} := by
      ext j'
      simp only [gateFailures, Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_singleton]
      constructor
      · rintro ⟨hij', hon⟩
        exact congrArg Prod.fst (repaired_gate_location T label F q x i j j' (label i j) a hf hij' hon)
      · rintro rfl
        exact ⟨hij, hgon⟩
    have hmem : i ∈ gateCandidates T label F q x := by
      simp [gateCandidates, htargets, hgates]
    exact Or.inr ⟨hmem, hij, rfl, hgon, hgoff⟩

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveCandidates. -/

namespace OAI

/-! Unique failed children and the unique possible sink of the gate-clause list. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem targetWitness_false {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (hr : 0 < r) (i : Fin k)
    (hi : i ∈ targetCandidates T label F q x) :
    F (Fin.last h) (recursiveChild x i (targetWitness F x hr i)) = false := by
  have hm : targetWitness F x hr i ∈ targetFailures F x i := by
    rw [targetFailures_singleton T label F q x hr i hi]
    exact Finset.mem_singleton_self _
  exact (Finset.mem_filter.mp hm).2

theorem targetWitness_unique {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (hr : 0 < r) (i : Fin k)
    (hi : i ∈ targetCandidates T label F q x) (c : Fin r)
    (hc : F (Fin.last h) (recursiveChild x i c) = false) : c = targetWitness F x hr i := by
  have hm : c ∈ targetFailures F x i := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hc⟩
  rwa [targetFailures_singleton T label F q x hr i hi, Finset.mem_singleton] at hm

theorem gateWitness_spec {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k)
    (hi : i ∈ gateCandidates T label F q x) :
    T.Adj i (gateWitness T label F q x i) ∧
      F (gateIndex q) (recursiveChild x (gateWitness T label F q x i)
        (label i (gateWitness T label F q x i))) = true := by
  have hm : gateWitness T label F q x i ∈ gateFailures T label F q x i := by
    rw [gateFailures_singleton T label F q x i hi]
    exact Finset.mem_singleton_self _
  exact (Finset.mem_filter.mp hm).2

theorem gateWitness_unique {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) (i : Fin k)
    (hi : i ∈ gateCandidates T label F q x) (j : Fin k) (hij : T.Adj i j)
    (hj : F (gateIndex q) (recursiveChild x j (label i j)) = true) :
    j = gateWitness T label F q x i := by
  have hm : j ∈ gateFailures T label F q x i := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hij, hj⟩
  rwa [gateFailures_singleton T label F q x i hi, Finset.mem_singleton] at hm

def gateSinks {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) : Finset (Fin k) :=
  (gateCandidates T label F q x).filter fun i =>
    ∀ j ∈ gateCandidates T label F q x, ¬ T.Adj i j

theorem gateSinks_card {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool) :
    (gateSinks T label F q x).card ≤ 1 := by
  apply Finset.card_le_one.mpr
  intro i hi j hj
  exact T.internal_sink_unique (Finset.mem_filter.mp hi).1 (Finset.mem_filter.mp hj).1
    (Finset.mem_filter.mp hi).2 (Finset.mem_filter.mp hj).2

theorem nonsink_gateWitness_mem {k r h : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (F : Fin (h + 1) → (I → Bool) → Bool)
    (hF : NestedFamily F) (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (i : Fin k) (hi : i ∈ gateCandidates T label F q x)
    (hs : i ∉ gateSinks T label F q x) :
    gateWitness T label F q x i ∈ gateCandidates T label F q x := by
  have he : ∃ j ∈ gateCandidates T label F q x, T.Adj i j := by
    by_contra hn
    apply hs
    apply Finset.mem_filter.mpr
    refine ⟨hi, ?_⟩
    intro j hj hij
    exact hn ⟨j, hj, hij⟩
  obtain ⟨j, hj, hij⟩ := he
  rwa [← gateCandidates_neighbor T label F hF q x i j hi hj hij]

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveZero. -/

namespace OAI

/-! The zero-side recurrence separates the unique possible gate-list sink. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem recursive_sensitivity_zero_at {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (A : GoodLabeling T r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (hr : 0 < r)
    (q : Fin h) (x : ((Fin k × Fin r) × I) → Bool)
    (hx : recursiveFamily T A.label F q x = false) :
    sensitivityAt (recursiveFamily T A.label F q) x ≤
      16 * sideSensitivity F false + sideSensitivity F true + 3 * jointSensitivity F true := by
  let TC := targetCandidates T A.label F q x
  let GC := gateCandidates T A.label F q x
  let SC := gateSinks T A.label F q x
  let NC := GC \ SC
  let w := gateWitness T A.label F q x
  let U := TC.biUnion fun i => childChanges F (Fin.last h) x i (targetWitness F x hr i)
  let V := NC.biUnion fun i => childJointChanges F (gateIndex q) (Fin.last h) x (w i) (A.label i (w i))
  let W := SC.biUnion fun i => childChanges F (gateIndex q) x (w i) (A.label i (w i))
  have hsub : (Finset.univ.filter fun p =>
      recursiveFamily T A.label F q (flip x {p}) ≠ recursiveFamily T A.label F q x) ⊆ U ∪ (V ∪ W) := by
    rintro ⟨⟨j, c⟩, a⟩ hp
    have hchange := (Finset.mem_filter.mp hp).2
    have hon : recursiveFamily T A.label F q (flip x {((j, c), a)}) = true := by
      cases hy : recursiveFamily T A.label F q (flip x {((j, c), a)})
      · exact False.elim (hchange (hy.trans hx.symm))
      · rfl
    obtain ⟨i, hi⟩ := (recursiveFamily_eq_true_iff T A.label F q _).mp hon
    have hioff := (recursiveFamily_eq_false_iff T A.label F q x).mp hx i
    rcases rowClause_repair_cases T A.label F q x i j c a hioff hi with
      ⟨hit, hji, htoff, hton⟩ | ⟨hig, hij, rfl, hgon, hgoff⟩
    · subst j
      have hc := targetWitness_unique T A.label F q x hr i hit c htoff
      apply Finset.mem_union_left
      apply Finset.mem_biUnion.mpr
      refine ⟨i, hit, ?_⟩
      have hn : F (Fin.last h) (flip (recursiveChild x i c) {a}) ≠
          F (Fin.last h) (recursiveChild x i c) := by simp [hton, htoff]
      simpa [childChanges, hc] using hn
    · have hj := gateWitness_unique T A.label F q x i hig j hij hgon
      apply Finset.mem_union_right
      by_cases hs : i ∈ SC
      · apply Finset.mem_union_right
        apply Finset.mem_biUnion.mpr
        refine ⟨i, hs, ?_⟩
        have hn : F (gateIndex q) (flip (recursiveChild x j (A.label i j)) {a}) ≠
            F (gateIndex q) (recursiveChild x j (A.label i j)) := by simp [hgon, hgoff]
        simpa [childChanges, w, hj] using hn
      · have hwg := nonsink_gateWitness_mem T A.label F hF q x i hig hs
        have hjg : j ∈ gateCandidates T A.label F q x := by simpa [hj] using hwg
        have hton := (targetFailures_empty_iff F x j).mp (Finset.mem_filter.mp hjg).2.1 (A.label i j)
        have htoff := hF.rejects_of_le (gateIndex_lt_last q).le hgoff
        apply Finset.mem_union_left
        apply Finset.mem_biUnion.mpr
        refine ⟨i, Finset.mem_sdiff.mpr ⟨hig, hs⟩, ?_⟩
        have hn :
            F (gateIndex q) (flip (recursiveChild x j (A.label i j)) {a}) ≠
              F (gateIndex q) (recursiveChild x j (A.label i j)) ∧
            F (Fin.last h) (flip (recursiveChild x j (A.label i j)) {a}) ≠
              F (Fin.last h) (recursiveChild x j (A.label i j)) := by
          simp [hgon, hgoff, hton, htoff]
        simpa [childJointChanges, w, hj] using hn
  have hU : U.card ≤ 16 * sideSensitivity F false := by
    calc
      U.card ≤ TC.card * sideSensitivity F false :=
        card_biUnion_le_mul TC _ _ (fun i hi => by
          rw [childChanges_card]
          exact sensitivityAt_le_sideSensitivity F false _ _
            (targetWitness_false T A.label F q x hr i hi))
      _ ≤ 16 * sideSensitivity F false := Nat.mul_le_mul_right _
        (Nat.le_of_lt (targetCandidates_card T A F hF q x hr))
  have hV : V.card ≤ 3 * jointSensitivity F true := by
    calc
      V.card ≤ NC.card * jointSensitivity F true :=
        card_biUnion_le_mul NC _ _ (fun i hi => by
          have hg := Finset.mem_sdiff.mp hi
          have hw := nonsink_gateWitness_mem T A.label F hF q x i hg.1 hg.2
          have hgate := (gateWitness_spec T A.label F q x i hg.1).2
          have htarget := (targetFailures_empty_iff F x _).mp (Finset.mem_filter.mp hw).2.1
            (A.label i (w i))
          rw [childJointChanges_card]
          exact jointSensitivityAt_le_jointSensitivity F true _ _ _ (gateIndex_lt_last q) hgate htarget)
      _ ≤ GC.card * jointSensitivity F true := Nat.mul_le_mul_right _ (Finset.card_le_card Finset.sdiff_subset)
      _ ≤ 3 * jointSensitivity F true := Nat.mul_le_mul_right _ (gateCandidates_card T A.label F hF q x)
  have hW : W.card ≤ sideSensitivity F true := by
    calc
      W.card ≤ SC.card * sideSensitivity F true :=
        card_biUnion_le_mul SC _ _ (fun i hi => by
          rw [childChanges_card]
          exact sensitivityAt_le_sideSensitivity F true _ _
            (gateWitness_spec T A.label F q x i (Finset.mem_filter.mp hi).1).2)
      _ ≤ 1 * sideSensitivity F true := Nat.mul_le_mul_right _ (gateSinks_card T A.label F q x)
      _ = _ := Nat.one_mul _
  calc
    sensitivityAt (recursiveFamily T A.label F q) x ≤ (U ∪ (V ∪ W)).card := Finset.card_le_card hsub
    _ ≤ U.card + (V ∪ W).card := Finset.card_union_le _ _
    _ ≤ U.card + (V.card + W.card) := Nat.add_le_add_left (Finset.card_union_le _ _) _
    _ ≤ 16 * sideSensitivity F false + (3 * jointSensitivity F true + sideSensitivity F true) :=
      Nat.add_le_add hU (Nat.add_le_add hV hW)
    _ = _ := by omega

theorem recursive_side_zero {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (A : GoodLabeling T r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (hr : 0 < r) :
    sideSensitivity (recursiveFamily T A.label F) false ≤
      16 * sideSensitivity F false + sideSensitivity F true + 3 * jointSensitivity F true := by
  apply sideSensitivity_le
  exact fun q x hx => recursive_sensitivity_zero_at T A F hF hr q x hx

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveJointZero. -/

namespace OAI

/-! The joint zero recurrence uses the fixed weaker-threshold failure lists. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem recursive_joint_zero_at {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (A : GoodLabeling T r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (hr : 0 < r)
    (q q' : Fin h) (hqq : q < q') (x : ((Fin k × Fin r) × I) → Bool)
    (hx : recursiveFamily T A.label F q x = false)
    (hx' : recursiveFamily T A.label F q' x = false) :
    jointSensitivityAt (recursiveFamily T A.label F q) (recursiveFamily T A.label F q') x ≤
      16 * sideSensitivity F false + 3 * jointSensitivity F true := by
  let TC := targetCandidates T A.label F q x
  let GC := gateCandidates T A.label F q x
  let w := gateWitness T A.label F q x
  let U := TC.biUnion fun i => childChanges F (Fin.last h) x i (targetWitness F x hr i)
  let V := GC.biUnion fun i => childJointChanges F (gateIndex q') (gateIndex q) x (w i) (A.label i (w i))
  have hsub : (Finset.univ.filter fun p =>
      recursiveFamily T A.label F q (flip x {p}) ≠ recursiveFamily T A.label F q x ∧
      recursiveFamily T A.label F q' (flip x {p}) ≠ recursiveFamily T A.label F q' x) ⊆ U ∪ V := by
    rintro ⟨⟨j, c⟩, a⟩ hp
    have hchange := (Finset.mem_filter.mp hp).2
    have hon' : recursiveFamily T A.label F q' (flip x {((j, c), a)}) = true := by
      cases hy : recursiveFamily T A.label F q' (flip x {((j, c), a)})
      · exact False.elim (hchange.2 (hy.trans hx'.symm))
      · rfl
    obtain ⟨i, hi'⟩ := (recursiveFamily_eq_true_iff T A.label F q' _).mp hon'
    have hi := rowClause_nested T A.label F hF hqq.le _ i hi'
    have hioff := (recursiveFamily_eq_false_iff T A.label F q x).mp hx i
    rcases rowClause_repair_cases T A.label F q x i j c a hioff hi with
      ⟨hit, hji, htoff, hton⟩ | ⟨hig, hij, rfl, hgon, hgoff⟩
    · subst j
      have hc := targetWitness_unique T A.label F q x hr i hit c htoff
      apply Finset.mem_union_left
      apply Finset.mem_biUnion.mpr
      refine ⟨i, hit, ?_⟩
      have hn : F (Fin.last h) (flip (recursiveChild x i c) {a}) ≠
          F (Fin.last h) (recursiveChild x i c) := by simp [hton, htoff]
      simpa [childChanges, hc] using hn
    · have hj := gateWitness_unique T A.label F q x i hig j hij hgon
      have hgon' := hF.accepts_of_le (gateIndex_strictAnti hqq).le hgon
      have hgoff' := ((rowClause_eq_true_iff T A.label F q' _ i).mp hi').2 j hij
      rw [recursiveChild_flip_same] at hgoff'
      apply Finset.mem_union_right
      apply Finset.mem_biUnion.mpr
      refine ⟨i, hig, ?_⟩
      have hn :
          F (gateIndex q') (flip (recursiveChild x j (A.label i j)) {a}) ≠
            F (gateIndex q') (recursiveChild x j (A.label i j)) ∧
          F (gateIndex q) (flip (recursiveChild x j (A.label i j)) {a}) ≠
            F (gateIndex q) (recursiveChild x j (A.label i j)) := by
        simp [hgon, hgoff, hgon', hgoff']
      simpa [childJointChanges, w, hj] using hn
  have hU : U.card ≤ 16 * sideSensitivity F false := by
    calc
      U.card ≤ TC.card * sideSensitivity F false :=
        card_biUnion_le_mul TC _ _ (fun i hi => by
          rw [childChanges_card]
          exact sensitivityAt_le_sideSensitivity F false _ _
            (targetWitness_false T A.label F q x hr i hi))
      _ ≤ 16 * sideSensitivity F false := Nat.mul_le_mul_right _
        (Nat.le_of_lt (targetCandidates_card T A F hF q x hr))
  have hV : V.card ≤ 3 * jointSensitivity F true := by
    calc
      V.card ≤ GC.card * jointSensitivity F true :=
        card_biUnion_le_mul GC _ _ (fun i hi => by
          rw [childJointChanges_card]
          have hg := (gateWitness_spec T A.label F q x i hi).2
          exact jointSensitivityAt_le_jointSensitivity F true _ _ _
            (gateIndex_strictAnti hqq) (hF.accepts_of_le (gateIndex_strictAnti hqq).le hg) hg)
      _ ≤ 3 * jointSensitivity F true := Nat.mul_le_mul_right _ (gateCandidates_card T A.label F hF q x)
  calc
    jointSensitivityAt (recursiveFamily T A.label F q) (recursiveFamily T A.label F q') x ≤
        (U ∪ V).card := Finset.card_le_card hsub
    _ ≤ U.card + V.card := Finset.card_union_le _ _
    _ ≤ _ := Nat.add_le_add hU hV

theorem recursive_joint_zero {k r h : ℕ} {I : Type} [Fintype I]
    (T : Tournament k) (A : GoodLabeling T r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (hr : 0 < r) :
    jointSensitivity (recursiveFamily T A.label F) false ≤
      16 * sideSensitivity F false + 3 * jointSensitivity F true := by
  apply jointSensitivity_le
  exact fun q q' x hqq hx hx' => recursive_joint_zero_at T A F hF hr q q' hqq x hx hx'

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Recursive. -/

namespace OAI

/-! Four sensitivity recurrences for a regular tournament and a good labeling. -/

noncomputable section
open scoped Classical

namespace Paper320

theorem recursive_four_recurrences {M r h : ℕ} {I : Type} [Fintype I]
    (T : RegularTournament M) (A : GoodLabeling T.toTournament r)
    (F : Fin (h + 1) → (I → Bool) → Bool) (hF : NestedFamily F) (hr : 0 < r) :
    let P := recursiveFamily T.toTournament A.label F
    (sideSensitivity P true ≤ M ^ 2 * sideSensitivity F false + r * sideSensitivity F true) ∧
    (jointSensitivity P true ≤ M ^ 2 * jointSensitivity F false + r * sideSensitivity F true) ∧
    (sideSensitivity P false ≤ 16 * sideSensitivity F false + sideSensitivity F true +
      3 * jointSensitivity F true) ∧
    (jointSensitivity P false ≤ 16 * sideSensitivity F false + 3 * jointSensitivity F true) := by
  exact ⟨recursive_side_one T.toTournament A.label F (M ^ 2) T.outdegree,
    recursive_joint_one T.toTournament A.label F hF (M ^ 2) T.outdegree,
    recursive_side_zero T.toTournament A F hF hr,
    recursive_joint_zero T.toTournament A F hF hr⟩

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Tower. -/

namespace OAI

/-! An indexed tower of the literal recursive construction and its common blocks. -/

noncomputable section
open scoped Classical

namespace Paper320

def TowerCoordinates (k r : ℕ) (I : Type) : ℕ → Type
  | 0 => I
  | n + 1 => (Fin k × Fin r) × TowerCoordinates k r I n

instance towerCoordinatesFintype (k r : ℕ) (I : Type) [Fintype I] :
    (n : ℕ) → Fintype (TowerCoordinates k r I n)
  | 0 => inferInstanceAs (Fintype I)
  | n + 1 => by
    letI := towerCoordinatesFintype k r I n
    exact inferInstanceAs (Fintype ((Fin k × Fin r) × TowerCoordinates k r I n))

def TowerBlockIndex (k : ℕ) (K : Type) : ℕ → Type
  | 0 => K
  | n + 1 => Fin k × TowerBlockIndex k K n

instance towerBlockIndexFintype (k : ℕ) (K : Type) [Fintype K] :
    (n : ℕ) → Fintype (TowerBlockIndex k K n)
  | 0 => inferInstanceAs (Fintype K)
  | n + 1 => by
    letI := towerBlockIndexFintype k K n
    exact inferInstanceAs (Fintype (Fin k × TowerBlockIndex k K n))

def towerFamily {k r : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool) :
    (n h : ℕ) → Fin h → (TowerCoordinates k r I n → Bool) → Bool
  | 0, h => base h
  | n + 1, h => recursiveFamily T label (towerFamily T label base n (h + 1))

def towerBlocks {k r : ℕ} {I K : Type} (blocks : K → Finset I) :
    (n : ℕ) → TowerBlockIndex k K n → Finset (TowerCoordinates k r I n)
  | 0, b => blocks b
  | n + 1, b => rowLift b.1 (towerBlocks blocks n b.2)

/-- Extend a prescribed initial family to unused index counts without adding assumptions. -/
def baseExtension {I : Type} (D : ℕ) (F : Fin D → (I → Bool) → Bool)
    (h : ℕ) (q : Fin h) (x : I → Bool) : Bool :=
  if he : h = D then F (Fin.cast he q) x else false

@[simp] theorem baseExtension_same {I : Type} (D : ℕ) (F : Fin D → (I → Bool) → Bool) :
    baseExtension D F D = F := by
  funext q x
  simp [baseExtension]

theorem tower_coordinates_card {k r : ℕ} {I : Type} [Fintype I] (n : ℕ) :
    Fintype.card (TowerCoordinates k r I n) = (k * r) ^ n * Fintype.card I := by
  induction n with
  | zero =>
    change Fintype.card I = (k * r) ^ 0 * Fintype.card I
    simp
  | succ n ih =>
    change Fintype.card ((Fin k × Fin r) × TowerCoordinates k r I n) = _
    simp only [Fintype.card_prod, Fintype.card_fin, ih, pow_succ]
    ring

theorem tower_block_index_card {k : ℕ} {K : Type} [Fintype K] (n : ℕ) :
    Fintype.card (TowerBlockIndex k K n) = k ^ n * Fintype.card K := by
  induction n with
  | zero =>
    change Fintype.card K = k ^ 0 * Fintype.card K
    simp
  | succ n ih =>
    change Fintype.card (Fin k × TowerBlockIndex k K n) = _
    simp only [Fintype.card_prod, Fintype.card_fin, ih, pow_succ]
    ring

theorem towerBlocks_card {k r : ℕ} {I K : Type} (blocks : K → Finset I)
    (L : ℕ) (hL : ∀ b, (blocks b).card = L) (n : ℕ) (b : TowerBlockIndex k K n) :
    (towerBlocks (r := r) blocks n b).card = r ^ n * L := by
  induction n with
  | zero =>
    change (blocks b).card = r ^ 0 * L
    simpa only [pow_zero, one_mul] using hL b
  | succ n ih =>
    change (rowLift b.1 (towerBlocks blocks n b.2)).card = _
    rw [rowLift_card, ih]
    ring

theorem towerBlocks_nonempty {k r : ℕ} {I K : Type} (blocks : K → Finset I)
    (hr : 0 < r) (hne : ∀ b, (blocks b).Nonempty) (n : ℕ) (b : TowerBlockIndex k K n) :
    (towerBlocks (r := r) blocks n b).Nonempty := by
  induction n with
  | zero => exact hne b
  | succ n ih => exact rowLift_nonempty b.1 _ hr (ih b.2)

theorem towerBlocks_pairwise {k r : ℕ} {I K : Type} (blocks : K → Finset I)
    (hd : Pairwise fun a b => Disjoint (blocks a) (blocks b)) (n : ℕ) :
    Pairwise fun a b => Disjoint (towerBlocks (k := k) (r := r) blocks n a) (towerBlocks blocks n b) := by
  induction n with
  | zero => exact hd
  | succ n ih => exact rowLift_family_disjoint (towerBlocks blocks n) ih

theorem towerFamily_nested {k r : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (n h : ℕ) (hbase : NestedFamily (base (h + n))) :
    NestedFamily (towerFamily T label base n h) := by
  induction n generalizing h with
  | zero =>
    change NestedFamily (base h)
    simpa only [Nat.add_zero] using hbase
  | succ n ih =>
    apply recursiveFamily_nested
    apply ih
    have he : (h + 1) + n = h + (n + 1) := by omega
    rw [he]
    exact hbase

theorem towerFamily_zero {k r : ℕ} {I : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (hr : 0 < r) (n h : ℕ) (hbase : ∀ q, base (h + n) q (fun _ => false) = false) :
    ∀ q, towerFamily T label base n h q (fun _ => false) = false := by
  induction n generalizing h with
  | zero =>
    change ∀ q, base h q (fun _ => false) = false
    simpa only [Nat.add_zero] using hbase
  | succ n ih =>
    apply recursiveFamily_zero T label _ hr
    apply ih
    have he : (h + 1) + n = h + (n + 1) := by omega
    rw [he]
    exact hbase

theorem towerFamily_blocks {k r : ℕ} {I K : Type} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (blocks : K → Finset I) (hr : 0 < r) (n h : ℕ)
    (hzero : ∀ q, base (h + n) q (fun _ => false) = false)
    (hblocks : ∀ b q, base (h + n) q (flip (fun _ => false) (blocks b)) = true) :
    ∀ b q, towerFamily T label base n h q
      (flip (fun _ => false) (towerBlocks blocks n b)) = true := by
  induction n generalizing h with
  | zero =>
    change ∀ b q, base h q (flip (fun _ => false) (blocks b)) = true
    simpa only [Nat.add_zero] using hblocks
  | succ n ih =>
    intro b q
    have he : (h + 1) + n = h + (n + 1) := by omega
    have hz : ∀ q, base ((h + 1) + n) q (fun _ => false) = false := by
      rw [he]
      exact hzero
    have hb : ∀ b q, base ((h + 1) + n) q (flip (fun _ => false) (blocks b)) = true := by
      rw [he]
      exact hblocks
    exact recursiveFamily_rowLift T label _
      (towerFamily_zero T label base hr n (h + 1) hz)
      (towerBlocks blocks n b.2) (ih (h + 1) hz hb b.2) b.1 q

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.RecursiveChildren. -/

namespace OAI

/-! Each row clause uses exactly the stated number of distinct child blocks. -/

noncomputable section
open scoped Classical

namespace Paper320

def rowChildren {k r : ℕ} (T : Tournament k) (label : Fin k → Fin k → Fin r)
    (i : Fin k) : Finset (Fin k × Fin r) :=
  Finset.univ.image (fun c => (i, c)) ∪
    (Finset.univ.filter (T.Adj i)).image (fun j => (j, label i j))

theorem rowChildren_disjoint {k r : ℕ} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (i : Fin k) :
    Disjoint (Finset.univ.image fun c => (i, c))
      ((Finset.univ.filter (T.Adj i)).image fun j => (j, label i j)) := by
  apply Finset.disjoint_left.mpr
  intro p hp hq
  obtain ⟨c, _, rfl⟩ := Finset.mem_image.mp hp
  obtain ⟨j, hj, he⟩ := Finset.mem_image.mp hq
  have hji : j = i := congrArg Prod.fst he
  exact T.loopless i (hji ▸ (Finset.mem_filter.mp hj).2)

theorem rowChildren_card {k r : ℕ} (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (i : Fin k) :
    (rowChildren T label i).card = r + (Finset.univ.filter (T.Adj i)).card := by
  rw [rowChildren, Finset.card_union_of_disjoint (rowChildren_disjoint T label i)]
  rw [Finset.card_image_of_injective _ (fun _ _ h => congrArg Prod.snd h)]
  rw [Finset.card_image_of_injective _ (fun _ _ h => congrArg Prod.fst h)]
  simp

theorem regular_rowChildren_card {M r : ℕ} (T : RegularTournament M)
    (label : Fin (2 * M ^ 2 + 1) → Fin (2 * M ^ 2 + 1) → Fin r)
    (i : Fin (2 * M ^ 2 + 1)) :
    (rowChildren T.toTournament label i).card = r + M ^ 2 := by
  rw [rowChildren_card, T.outdegree]

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.TowerProfiles. -/

namespace OAI

/-! The fixed-initial-height profiles and their exact four recurrences. -/

noncomputable section
open scoped Classical

namespace Paper320

def towerSide {k r : ℕ} {I : Type} [Fintype I] (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (D n : ℕ) (b : Bool) : ℕ :=
  sideSensitivity (towerFamily T label base n (D - n)) b

def towerJoint {k r : ℕ} {I : Type} [Fintype I] (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (D n : ℕ) (b : Bool) : ℕ :=
  jointSensitivity (towerFamily T label base n (D - n)) b

@[simp] theorem towerSide_zero {k r : ℕ} {I : Type} [Fintype I] (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (D : ℕ) (b : Bool) : towerSide T label base D 0 b = sideSensitivity (base D) b := by
  rfl

@[simp] theorem towerJoint_zero {k r : ℕ} {I : Type} [Fintype I] (T : Tournament k)
    (label : Fin k → Fin k → Fin r) (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (D : ℕ) (b : Bool) : towerJoint T label base D 0 b = jointSensitivity (base D) b := by
  rfl

theorem tower_four_recurrences {M r : ℕ} {I : Type} [Fintype I]
    (T : RegularTournament M) (A : GoodLabeling T.toTournament r)
    (base : (h : ℕ) → Fin h → (I → Bool) → Bool)
    (D n : ℕ) (hn : n < D) (hr : 0 < r) (hbase : NestedFamily (base D)) :
    (towerSide T.toTournament A.label base D (n + 1) true ≤
      M ^ 2 * towerSide T.toTournament A.label base D n false +
      r * towerSide T.toTournament A.label base D n true) ∧
    (towerJoint T.toTournament A.label base D (n + 1) true ≤
      M ^ 2 * towerJoint T.toTournament A.label base D n false +
      r * towerSide T.toTournament A.label base D n true) ∧
    (towerSide T.toTournament A.label base D (n + 1) false ≤
      16 * towerSide T.toTournament A.label base D n false +
      towerSide T.toTournament A.label base D n true +
      3 * towerJoint T.toTournament A.label base D n true) ∧
    (towerJoint T.toTournament A.label base D (n + 1) false ≤
      16 * towerSide T.toTournament A.label base D n false +
      3 * towerJoint T.toTournament A.label base D n true) := by
  have he : (D - (n + 1) + 1) + n = D := by omega
  have hf : NestedFamily (towerFamily T.toTournament A.label base n (D - (n + 1) + 1)) := by
    apply towerFamily_nested
    rwa [he]
  have H := recursive_four_recurrences T A
    (towerFamily T.toTournament A.label base n (D - (n + 1) + 1)) hf hr
  dsimp only at H
  change (sideSensitivity (towerFamily T.toTournament A.label base (n + 1) (D - (n + 1))) true ≤ _) ∧
    (jointSensitivity (towerFamily T.toTournament A.label base (n + 1) (D - (n + 1))) true ≤ _) ∧
    (sideSensitivity (towerFamily T.toTournament A.label base (n + 1) (D - (n + 1))) false ≤ _) ∧
    (jointSensitivity (towerFamily T.toTournament A.label base (n + 1) (D - (n + 1))) false ≤ _) at H
  have hcount : D - (n + 1) + 1 = D - n := by omega
  rw [hcount] at H
  exact H

theorem towerBlocks_family_card {k r : ℕ} {I K : Type} [Fintype K]
    (blocks : K → Finset I) (hr : 0 < r) (hne : ∀ b, (blocks b).Nonempty)
    (hd : Pairwise fun a b => Disjoint (blocks a) (blocks b)) (n : ℕ) :
    (Finset.univ.image (towerBlocks (k := k) (r := r) blocks n)).card = k ^ n * Fintype.card K := by
  have hinj : Function.Injective (towerBlocks (k := k) (r := r) blocks n) := by
    intro a b hab
    by_contra hneab
    obtain ⟨i, hi⟩ := towerBlocks_nonempty blocks hr hne n a
    exact Finset.disjoint_left.mp (towerBlocks_pairwise blocks hd n hneab) hi (by simpa [← hab] using hi)
  rw [Finset.card_image_of_injective _ hinj, Finset.card_univ, tower_block_index_card]

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.ProfileArithmetic. -/

namespace OAI

/-! The four raw recurrences imply the two normalized scalar recurrences. -/

noncomputable section

namespace Paper320

def normalizedMax (M : ℝ) (n : ℕ) (s₀ s₁ : ℝ) : ℝ :=
  max (s₀ / M ^ n) (s₁ / M ^ (n + 1))

theorem normalizedMax_nonneg {M s₀ s₁ : ℝ} {n : ℕ}
    (hM : 0 < M) (hs₀ : 0 ≤ s₀) : 0 ≤ normalizedMax M n s₀ s₁ :=
  (div_nonneg hs₀ (pow_pos hM n).le).trans (le_max_left _ _)

theorem le_normalizedMax_zero {M s₀ s₁ : ℝ} {n : ℕ} (hM : 0 < M) :
    s₀ ≤ normalizedMax M n s₀ s₁ * M ^ n :=
  (div_le_iff₀ (pow_pos hM n)).mp (le_max_left _ _)

theorem le_normalizedMax_one {M s₀ s₁ : ℝ} {n : ℕ} (hM : 0 < M) :
    s₁ ≤ normalizedMax M n s₀ s₁ * M ^ (n + 1) :=
  (div_le_iff₀ (pow_pos hM (n + 1))).mp (le_max_right _ _)

theorem normalizedMax_le {M s₀ s₁ u : ℝ} {n : ℕ} (hM : 0 < M)
    (h₀ : s₀ ≤ u * M ^ n) (h₁ : s₁ ≤ u * M ^ (n + 1)) :
    normalizedMax M n s₀ s₁ ≤ u :=
  max_le ((div_le_iff₀ (pow_pos hM n)).mpr h₀)
    ((div_le_iff₀ (pow_pos hM (n + 1))).mpr h₁)

theorem raw_profiles_step {M r ε u v p : ℝ}
    (hM : 0 < M) (hp : 0 ≤ p) (hu : 0 ≤ u) (hv : 0 ≤ v)
    (hr : 0 ≤ r) (hεr : r ≤ ε * M) (hεt : 16 ≤ ε * M)
    {s₀ s₁ j₀ j₁ s₀' s₁' j₀' j₁' : ℝ}
    (hs₀ : s₀ ≤ u * p) (hs₁ : s₁ ≤ u * (p * M))
    (hj₀ : j₀ ≤ v * p) (hj₁ : j₁ ≤ v * (p * M))
    (hS₀ : s₀' ≤ 16 * s₀ + s₁ + 3 * j₁)
    (hS₁ : s₁' ≤ M ^ 2 * s₀ + r * s₁)
    (hJ₀ : j₀' ≤ 16 * s₀ + 3 * j₁)
    (hJ₁ : j₁' ≤ M ^ 2 * j₀ + r * s₁) :
    s₀' ≤ ((1 + ε) * u + 3 * v) * (p * M) ∧
    s₁' ≤ ((1 + ε) * u + 3 * v) * (p * M * M) ∧
    j₀' ≤ (ε * u + 3 * v) * (p * M) ∧
    j₁' ≤ (ε * u + 3 * v) * (p * M * M) := by
  have hup : 0 ≤ u * p := mul_nonneg hu hp
  have hupM : 0 ≤ u * (p * M) := mul_nonneg hu (mul_nonneg hp hM.le)
  have hvpMM : 0 ≤ v * (p * M * M) := by positivity
  have ht := mul_le_mul_of_nonneg_right hεt hup
  have hr' := mul_le_mul_of_nonneg_right hεr hupM
  have a₀ := mul_le_mul_of_nonneg_left hs₀ (show (0 : ℝ) ≤ 16 by norm_num)
  have a₁ := mul_le_mul_of_nonneg_left hs₀ (sq_nonneg M)
  have b₀ := mul_le_mul_of_nonneg_left hj₀ (sq_nonneg M)
  have b₁ := mul_le_mul_of_nonneg_left hj₁ (show (0 : ℝ) ≤ 3 by norm_num)
  have c₁ := mul_le_mul_of_nonneg_left hs₁ hr
  constructor
  · nlinarith
  constructor
  · nlinarith
  constructor <;> nlinarith

theorem normalized_profiles_step {M r ε : ℝ} {n : ℕ}
    (hM : 0 < M) (hr : 0 ≤ r) (hεr : r / M ≤ ε) (hεt : 16 / M ≤ ε)
    {s₀ s₁ j₀ j₁ s₀' s₁' j₀' j₁' : ℝ} (hs₀ : 0 ≤ s₀) (hj₀ : 0 ≤ j₀)
    (hS₀ : s₀' ≤ 16 * s₀ + s₁ + 3 * j₁)
    (hS₁ : s₁' ≤ M ^ 2 * s₀ + r * s₁)
    (hJ₀ : j₀' ≤ 16 * s₀ + 3 * j₁)
    (hJ₁ : j₁' ≤ M ^ 2 * j₀ + r * s₁) :
    normalizedMax M (n + 1) s₀' s₁' ≤
      (1 + ε) * normalizedMax M n s₀ s₁ + 3 * normalizedMax M n j₀ j₁ ∧
    normalizedMax M (n + 1) j₀' j₁' ≤
      ε * normalizedMax M n s₀ s₁ + 3 * normalizedMax M n j₀ j₁ := by
  have hs₁b := le_normalizedMax_one (s₀ := s₀) (s₁ := s₁) (n := n) hM
  have hj₁b := le_normalizedMax_one (s₀ := j₀) (s₁ := j₁) (n := n) hM
  rw [pow_succ] at hs₁b hj₁b
  obtain ⟨a, b, c, d⟩ := raw_profiles_step hM (pow_pos hM n).le
    (normalizedMax_nonneg hM hs₀) (normalizedMax_nonneg hM hj₀) hr
    ((div_le_iff₀ hM).mp hεr) ((div_le_iff₀ hM).mp hεt)
    (le_normalizedMax_zero hM) hs₁b (le_normalizedMax_zero hM) hj₁b
    hS₀ hS₁ hJ₀ hJ₁
  constructor
  · apply normalizedMax_le hM <;> simpa only [pow_succ] using (by assumption)
  · apply normalizedMax_le hM <;> simpa only [pow_succ] using (by assumption)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.ScalarBounds. -/

namespace OAI

/-! Scalar bounds for the two coupled sensitivity profiles. -/

namespace Paper320

theorem geometric_error_le {d n : ℕ} (hn : n ≤ d) {ε L : ℝ}
    (hε : 0 ≤ ε) (hL : 0 ≤ L) (hbudget : ε * 3 ^ (d + 1) ≤ 2) :
    (3 / 2 : ℝ) * ε * L * (3 ^ n - 1) ≤ L := by
  have hp : (3 : ℝ) ^ (n + 1) ≤ 3 ^ (d + 1) :=
    pow_le_pow_right₀ (by norm_num) (Nat.succ_le_succ hn)
  have hb := (mul_le_mul_of_nonneg_left hp hε).trans hbudget
  have hm := mul_le_mul_of_nonneg_right hb hL
  rw [pow_succ] at hm
  nlinarith [mul_nonneg hε hL]

theorem coupled_profiles_bound (d : ℕ) (u v : ℕ → ℝ) (ε L : ℝ)
    (hε : 0 ≤ ε) (hL : 0 ≤ L) (hbudget : ε * 3 ^ (d + 1) ≤ 2)
    (hu0 : u 0 ≤ L) (hv0 : v 0 ≤ 0)
    (hu : ∀ n < d, u (n + 1) ≤ (1 + ε) * u n + 3 * v n)
    (hv : ∀ n < d, v (n + 1) ≤ ε * u n + 3 * v n) :
    ∀ n ≤ d, u n ≤ 2 * L ∧ v n ≤ ε * L * (3 ^ n - 1) := by
  have strong : ∀ n ≤ d,
      u n ≤ L + (3 / 2 : ℝ) * ε * L * (3 ^ n - 1) ∧
        v n ≤ ε * L * (3 ^ n - 1) := by
    intro n
    induction n with
    | zero =>
        intro _
        simpa using And.intro hu0 hv0
    | succ n ih =>
        intro hn
        have hnd : n ≤ d := by omega
        obtain ⟨hun, hvn⟩ := ih hnd
        have he := geometric_error_le hnd hε hL hbudget
        have hun' : u n ≤ 2 * L := by linarith
        have heu := mul_le_mul_of_nonneg_left hun' hε
        have hnu := hu n (by omega)
        have hnv := hv n (by omega)
        constructor
        · rw [pow_succ]
          nlinarith [mul_nonneg hε hL]
        · rw [pow_succ]
          nlinarith
  intro n hn
  obtain ⟨hun, hvn⟩ := strong n hn
  have he := geometric_error_le hn hε hL hbudget
  exact ⟨by linarith, hvn⟩

end Paper320

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.QuantitativeProfiles. -/

namespace OAI

/-! Quantitative bounds for any literal profiles satisfying the four recurrences. -/

noncomputable section

namespace Paper320

theorem quantitative_profile_bounds (d L M r : ℕ) (hM : 0 < M)
    (hbudget : ((max r 16 : ℕ) : ℝ) / M * 3 ^ (d + 1) ≤ 2)
    (S J : ℕ → Bool → ℕ)
    (hS₀ : S 0 false ≤ L) (hS₁ : S 0 true ≤ L * M)
    (hJ₀ : J 0 false = 0) (hJ₁ : J 0 true = 0)
    (hstepS₀ : ∀ n < d, S (n + 1) false ≤ 16 * S n false + S n true + 3 * J n true)
    (hstepS₁ : ∀ n < d, S (n + 1) true ≤ M ^ 2 * S n false + r * S n true)
    (hstepJ₀ : ∀ n < d, J (n + 1) false ≤ 16 * S n false + 3 * J n true)
    (hstepJ₁ : ∀ n < d, J (n + 1) true ≤ M ^ 2 * J n false + r * S n true) :
    ∀ n ≤ d, S n false ≤ 2 * L * M ^ n ∧ S n true ≤ 2 * L * M ^ (n + 1) := by
  let ε : ℝ := ((max r 16 : ℕ) : ℝ) / M
  let u : ℕ → ℝ := fun n => normalizedMax M n (S n false) (S n true)
  let v : ℕ → ℝ := fun n => normalizedMax M n (J n false) (J n true)
  have hMr : (0 : ℝ) < M := by exact_mod_cast hM
  have hε : 0 ≤ ε := by positivity
  have hεr : (r : ℝ) / M ≤ ε := by
    apply div_le_div_of_nonneg_right _ hMr.le
    exact_mod_cast le_max_left r 16
  have hεt : (16 : ℝ) / M ≤ ε := by
    apply div_le_div_of_nonneg_right _ hMr.le
    exact_mod_cast le_max_right r 16
  have hu0 : u 0 ≤ L := by
    apply normalizedMax_le hMr
    · simpa using (show (S 0 false : ℝ) ≤ L by exact_mod_cast hS₀)
    · simpa using (show (S 0 true : ℝ) ≤ (L : ℝ) * M by exact_mod_cast hS₁)
  have hv0 : v 0 ≤ 0 := by simp [v, normalizedMax, hJ₀, hJ₁]
  have hstep (n : ℕ) (hn : n < d) :
      u (n + 1) ≤ (1 + ε) * u n + 3 * v n ∧
      v (n + 1) ≤ ε * u n + 3 * v n := by
    apply normalized_profiles_step hMr (by positivity) hεr hεt (by positivity) (by positivity)
    · exact_mod_cast hstepS₀ n hn
    · exact_mod_cast hstepS₁ n hn
    · exact_mod_cast hstepJ₀ n hn
    · exact_mod_cast hstepJ₁ n hn
  have hb := coupled_profiles_bound d u v ε L hε (by positivity) hbudget hu0 hv0
    (fun n hn => (hstep n hn).1) (fun n hn => (hstep n hn).2)
  intro n hn
  have hu := (hb n hn).1
  have hzero : (S n false : ℝ) ≤ 2 * (L : ℝ) * (M : ℝ) ^ n := by
    exact (le_normalizedMax_zero hMr).trans
      (mul_le_mul_of_nonneg_right hu (by positivity))
  have hone : (S n true : ℝ) ≤ 2 * (L : ℝ) * (M : ℝ) ^ (n + 1) := by
    exact (le_normalizedMax_one hMr).trans
      (mul_le_mul_of_nonneg_right hu (by positivity))
  exact ⟨by exact_mod_cast hzero, by exact_mod_cast hone⟩

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Or. -/

namespace OAI

/-! Balancing the zero and one sensitivities by an OR of disjoint copies. -/

noncomputable section
open scoped Classical BigOperators

namespace Paper320

variable {I K : Type} [Fintype K]

def orBits (x : K → Bool) : Bool := decide (∃ k, x k = true)

@[simp] theorem orBits_eq_true (x : K → Bool) : orBits x = true ↔ ∃ k, x k = true := by
  simp [orBits]

@[simp] theorem orBits_eq_false (x : K → Bool) : orBits x = false ↔ ∀ k, x k = false := by
  simp [orBits]

@[simp] theorem orBits_zero : orBits (fun _ : K => false) = false := by
  simp [orBits]

theorem orBits_flip_of_witness (x : K → Bool) {i j : K}
    (hji : j ≠ i) (hj : x j = true) : orBits (flip x {i}) = orBits x := by
  have h₁ : orBits x = true := (orBits_eq_true x).mpr ⟨j, hj⟩
  have h₂ : orBits (flip x {i}) = true :=
    (orBits_eq_true _).mpr ⟨j, by rw [flip_singleton_other x hji, hj]⟩
  exact h₂.trans h₁.symm

def orCopies (f : (I → Bool) → Bool) : (K × I → Bool) → Bool := compose orBits f

theorem orCopies_zero (f : (I → Bool) → Bool) (hf : f (fun _ => false) = false) :
    orCopies (K := K) f (fun _ => false) = false := by
  rw [orCopies, compose_zero _ _ hf, orBits_zero]

variable [Fintype I]

theorem sensitivity_orCopies_le (f : (I → Bool) → Bool) (S₀ S₁ : ℕ)
    (h₀ : ∀ x, f x = false → sensitivityAt f x ≤ S₀)
    (h₁ : ∀ x, f x = true → sensitivityAt f x ≤ S₁) :
    sensitivity (orCopies (K := K) f) ≤ max (Fintype.card K * S₀) S₁ := by
  apply sensitivity_le
  intro x
  change sensitivityAt (compose orBits f) x ≤ _
  rw [sensitivityAt_compose]
  let y : K → Bool := fun k => f (fun a => x (k, a))
  let s : Finset K := Finset.univ.filter fun i => orBits (flip y {i}) ≠ orBits y
  change (∑ i ∈ s, sensitivityAt f (fun a => x (i, a))) ≤ _
  by_cases hy : orBits y = false
  · have hall := (orBits_eq_false y).mp hy
    calc
      _ ≤ ∑ _i ∈ s, S₀ := Finset.sum_le_sum fun i _ => h₀ _ (hall i)
      _ = s.card * S₀ := by simp
      _ ≤ Fintype.card K * S₀ := Nat.mul_le_mul_right _ (Finset.card_le_univ _)
      _ ≤ max (Fintype.card K * S₀) S₁ := le_max_left _ _
  · have htrue : orBits y = true := by cases h : orBits y <;> simp_all
    obtain ⟨i, hi⟩ := (orBits_eq_true y).mp htrue
    have hs : s ⊆ {i} := by
      intro j hj
      have hc := (Finset.mem_filter.mp hj).2
      by_contra hji
      have hij : i ≠ j := Ne.symm (by simpa only [Finset.mem_singleton] using hji)
      exact hc (orBits_flip_of_witness y hij hi)
    calc
      _ ≤ ∑ j ∈ ({i} : Finset K), sensitivityAt f (fun a => x (j, a)) :=
        Finset.sum_le_sum_of_subset_of_nonneg hs (by intros; exact Nat.zero_le _)
      _ = sensitivityAt f (fun a => x (i, a)) := by simp
      _ ≤ S₁ := h₁ _ hi
      _ ≤ max (Fintype.card K * S₀) S₁ := le_max_right _ _

theorem card_le_blockSensitivityAt_orBits_zero :
    Fintype.card K ≤ blockSensitivityAt (orBits (K := K)) (fun _ => false) := by
  apply le_blockSensitivityAt_of_family orBits (fun _ => false) (fun k : K => {k})
  · intro k
    simp
  · intro k l hkl
    simpa using hkl
  · intro k
    have h : orBits (flip (fun _ : K => false) {k}) = true :=
      (orBits_eq_true _).mpr ⟨k, by simp⟩
    simp [h]

theorem blockSensitivityAt_orCopies_zero (f : (I → Bool) → Bool)
    (hf : f (fun _ => false) = false) :
    Fintype.card K * blockSensitivityAt f (fun _ => false) ≤
      blockSensitivityAt (orCopies (K := K) f) (fun _ => false) := by
  exact (Nat.mul_le_mul_right _ card_le_blockSensitivityAt_orBits_zero).trans
    (blockSensitivityAt_compose_zero_le orBits f hf)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Reindex. -/

namespace OAI

/-! Coordinate equivalences preserve the two literal Boolean complexity measures. -/

noncomputable section
open scoped Classical

namespace Paper320

variable {I J : Type}

def reindex (e : I ≃ J) (f : (I → Bool) → Bool) : (J → Bool) → Bool :=
  fun x => f (fun i => x (e i))

theorem flip_reindex (e : I ≃ J) (x : J → Bool) (B : Finset I) :
    (fun i => flip x (B.map e.toEmbedding) (e i)) =
      flip (fun i => x (e i)) B := by
  funext i
  simp [flip]

theorem flip_reindex_singleton (e : I ≃ J) (x : J → Bool) (i : I) :
    (fun a => flip x {e i} (e a)) = flip (fun a => x (e a)) {i} := by
  simpa using flip_reindex e x {i}

@[simp] theorem reindex_symm (e : I ≃ J) (f : (I → Bool) → Bool) :
    reindex e.symm (reindex e f) = f := by
  funext x
  simp [reindex]

section Finite
variable [Fintype I] [Fintype J]

theorem sensitivityAt_reindex (e : I ≃ J) (f : (I → Bool) → Bool) (x : J → Bool) :
    sensitivityAt (reindex e f) x = sensitivityAt f (fun i => x (e i)) := by
  have hs : (Finset.univ.filter fun j =>
      reindex e f (flip x {j}) ≠ reindex e f x).map e.symm.toEmbedding =
      Finset.univ.filter (fun i =>
        f (flip (fun a => x (e a)) {i}) ≠ f (fun a => x (e a))) := by
    ext i
    simp only [Finset.mem_map_equiv, Equiv.symm_symm, Finset.mem_filter,
      Finset.mem_univ, true_and]
    change f (fun a => flip x {e i} (e a)) ≠ f (fun a => x (e a)) ↔ _
    rw [flip_reindex_singleton]
  simpa only [sensitivityAt, Finset.card_map] using congrArg Finset.card hs

theorem sensitivity_reindex (e : I ≃ J) (f : (I → Bool) → Bool) :
    sensitivity (reindex e f) = sensitivity f := by
  apply Nat.le_antisymm
  · apply sensitivity_le
    intro x
    rw [sensitivityAt_reindex]
    exact sensitivityAt_le_sensitivity f _
  · apply sensitivity_le
    intro x
    have h := sensitivityAt_le_sensitivity (reindex e f) (fun j => x (e.symm j))
    rw [sensitivityAt_reindex] at h
    simpa only [Equiv.symm_apply_apply] using h

theorem blockSensitivityAt_le_reindex (e : I ≃ J) (f : (I → Bool) → Bool)
    (x : J → Bool) :
    blockSensitivityAt f (fun i => x (e i)) ≤ blockSensitivityAt (reindex e f) x := by
  apply blockSensitivityAt_le
  intro blocks hd hb
  have h := le_blockSensitivityAt_of_family (reindex e f) x
    (fun B : blocks => B.val.map e.toEmbedding)
    (fun B => (hb B.val B.property).1.map (f := e.toEmbedding))
    (by
      intro A B hAB
      apply (Finset.disjoint_map e.toEmbedding).mpr
      exact hd A.val A.property B.val B.property (fun h => hAB (Subtype.ext h)))
    (by
      intro B
      change f (fun i => flip x (B.val.map e.toEmbedding) (e i)) ≠ _
      rw [flip_reindex]
      exact (hb B.val B.property).2)
  simpa only [Fintype.card_coe] using h

theorem blockSensitivityAt_reindex (e : I ≃ J) (f : (I → Bool) → Bool)
    (x : J → Bool) :
    blockSensitivityAt (reindex e f) x = blockSensitivityAt f (fun i => x (e i)) := by
  apply Nat.le_antisymm
  · have h := blockSensitivityAt_le_reindex e.symm (reindex e f) (fun i => x (e i))
    simpa only [Equiv.apply_symm_apply, reindex_symm] using h
  · exact blockSensitivityAt_le_reindex e f x

theorem blockSensitivity_reindex (e : I ≃ J) (f : (I → Bool) → Bool) :
    blockSensitivity (reindex e f) = blockSensitivity f := by
  apply Nat.le_antisymm
  · apply blockSensitivity_le
    intro x
    rw [blockSensitivityAt_reindex]
    exact blockSensitivityAt_le_blockSensitivity f _
  · apply blockSensitivity_le
    intro x
    have h := blockSensitivityAt_le_blockSensitivity (reindex e f) (fun j => x (e.symm j))
    rw [blockSensitivityAt_reindex] at h
    simpa only [Equiv.symm_apply_apply] using h

end Finite
end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Construction. -/

namespace OAI

/-! The initial family, recursively constructed predicates, and final OR. -/

noncomputable section
open scoped Classical

namespace Paper320

def constructionBase (d M : ℕ) := baseExtension (d + 1) (initialFamily d M)

abbrev ConstructionCoordinates (d M r n : ℕ) :=
  TowerCoordinates (2 * M ^ 2 + 1) r (Fin M × Fin (d + 2)) n

def terminalPredicate {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) : (ConstructionCoordinates d M r d → Bool) → Bool :=
  towerFamily T.toTournament A.label (constructionBase d M) d 1 0

theorem construction_base_nested (d M : ℕ) :
    NestedFamily (constructionBase d M (d + 1)) := by
  simpa only [constructionBase, baseExtension_same] using initialFamily_nested d M

theorem construction_base_zero (d M : ℕ) :
    ∀ q, constructionBase d M (1 + d) q (fun _ => false) = false := by
  rw [Nat.add_comm 1 d]
  simpa only [constructionBase, baseExtension_same] using initialFamily_zero d M

theorem construction_base_blocks (d M : ℕ) :
    ∀ b q, constructionBase d M (1 + d) q
      (flip (fun _ => false) (baseBlock b)) = true := by
  rw [Nat.add_comm 1 d]
  intro b q
  simpa only [constructionBase, baseExtension_same] using initialFamily_baseBlock d M q b

theorem terminalPredicate_zero {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    terminalPredicate d T A (fun _ => false) = false :=
  towerFamily_zero T.toTournament A.label (constructionBase d M) hr d 1
    (construction_base_zero d M) 0

theorem terminalPredicate_blocks {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r)
    (b : TowerBlockIndex (2 * M ^ 2 + 1) (Fin M) d) :
    terminalPredicate d T A (flip (fun _ => false)
      (towerBlocks (r := r) (baseBlock (L := d + 2)) d b)) = true :=
  towerFamily_blocks T.toTournament A.label (constructionBase d M)
    (baseBlock (L := d + 2)) hr d 1 (construction_base_zero d M)
    (construction_base_blocks d M) b 0

theorem terminalPredicate_blockSensitivity {M r : ℕ} (d : ℕ)
    (T : RegularTournament M) (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    M * (2 * M ^ 2 + 1) ^ d ≤ blockSensitivityAt (terminalPredicate d T A) (fun _ => false) := by
  have h := le_blockSensitivityAt_of_family (terminalPredicate d T A) (fun _ => false)
    (towerBlocks (r := r) (baseBlock (L := d + 2)) d)
    (towerBlocks_nonempty (baseBlock (L := d + 2)) hr
      (baseBlock_nonempty (by omega)) d)
    (towerBlocks_pairwise (baseBlock (L := d + 2)) baseBlock_disjoint d)
    (fun b => by rw [terminalPredicate_blocks d T A hr, terminalPredicate_zero d T A hr]; decide)
  simpa only [tower_block_index_card, Fintype.card_fin, Nat.mul_comm] using h

theorem construction_profiles {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hM : 0 < M) (hr : 0 < r)
    (hbudget : ((max r 16 : ℕ) : ℝ) / M * 3 ^ (d + 1) ≤ 2) :
    ∀ n ≤ d,
      towerSide T.toTournament A.label (constructionBase d M) (d + 1) n false ≤
        2 * (d + 2) * M ^ n ∧
      towerSide T.toTournament A.label (constructionBase d M) (d + 1) n true ≤
        2 * (d + 2) * M ^ (n + 1) := by
  have hstep (n : ℕ) (hn : n < d) := tower_four_recurrences T A (constructionBase d M)
    (d + 1) n (by omega) hr (construction_base_nested d M)
  apply quantitative_profile_bounds d (d + 2) M r hM hbudget
    (towerSide T.toTournament A.label (constructionBase d M) (d + 1))
    (towerJoint T.toTournament A.label (constructionBase d M) (d + 1))
  · simpa only [towerSide_zero, constructionBase, baseExtension_same] using initialFamily_side_zero d M
  · simpa only [towerSide_zero, constructionBase, baseExtension_same] using initialFamily_side_one d M
  · simpa only [towerJoint_zero, constructionBase, baseExtension_same] using initialFamily_joint d M false
  · simpa only [towerJoint_zero, constructionBase, baseExtension_same] using initialFamily_joint d M true
  · exact fun n hn => (hstep n hn).2.2.1
  · exact fun n hn => (hstep n hn).1
  · exact fun n hn => (hstep n hn).2.2.2
  · exact fun n hn => (hstep n hn).2.1

theorem terminalPredicate_sensitivityAt {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hM : 0 < M) (hr : 0 < r)
    (hbudget : ((max r 16 : ℕ) : ℝ) / M * 3 ^ (d + 1) ≤ 2) :
    (∀ x, terminalPredicate d T A x = false →
      sensitivityAt (terminalPredicate d T A) x ≤ 2 * (d + 2) * M ^ d) ∧
    (∀ x, terminalPredicate d T A x = true →
      sensitivityAt (terminalPredicate d T A) x ≤ 2 * (d + 2) * M ^ (d + 1)) := by
  have hs := construction_profiles d T A hM hr hbudget d (le_refl d)
  have he : d + 1 - d = 1 := by omega
  simp only [towerSide] at hs
  rw [he] at hs
  exact ⟨fun x hx => (sensitivityAt_le_sideSensitivity _ false 0 x hx).trans hs.1,
    fun x hx => (sensitivityAt_le_sideSensitivity _ true 0 x hx).trans hs.2⟩

def finalBoolean {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) : (Fin M × ConstructionCoordinates d M r d → Bool) → Bool :=
  orCopies (K := Fin M) (terminalPredicate d T A)

theorem finalBoolean_zero {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    finalBoolean d T A (fun _ => false) = false :=
  orCopies_zero _ (terminalPredicate_zero d T A hr)

theorem finalBoolean_sensitivity {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hM : 0 < M) (hr : 0 < r)
    (hbudget : ((max r 16 : ℕ) : ℝ) / M * 3 ^ (d + 1) ≤ 2) :
    sensitivity (finalBoolean d T A) ≤ 2 * (d + 2) * M ^ (d + 1) := by
  obtain ⟨h₀, h₁⟩ := terminalPredicate_sensitivityAt d T A hM hr hbudget
  have h := sensitivity_orCopies_le (K := Fin M) (terminalPredicate d T A) _ _ h₀ h₁
  have he : M * (2 * (d + 2) * M ^ d) = 2 * (d + 2) * M ^ (d + 1) := by ring
  simpa only [finalBoolean, Fintype.card_fin, he, max_self] using h

theorem finalBoolean_blockSensitivity {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    M ^ 2 * (2 * M ^ 2 + 1) ^ d ≤ blockSensitivityAt (finalBoolean d T A) (fun _ => false) := by
  have h := (Nat.mul_le_mul_left M (terminalPredicate_blockSensitivity d T A hr)).trans
    (by simpa only [Fintype.card_fin] using
      blockSensitivityAt_orCopies_zero (K := Fin M) _ (terminalPredicate_zero d T A hr))
  change M ^ 2 * (2 * M ^ 2 + 1) ^ d ≤ blockSensitivityAt
    (orCopies (K := Fin M) (terminalPredicate d T A)) (fun _ => false)
  calc
    _ = M * (M * (2 * M ^ 2 + 1) ^ d) := by ring
    _ ≤ _ := h

def constructionDimension (d M r : ℕ) : ℕ :=
  (d + 2) * M ^ 2 * ((2 * M ^ 2 + 1) * r) ^ d

theorem final_coordinates_card (d M r : ℕ) :
    Fintype.card (Fin M × ConstructionCoordinates d M r d) = constructionDimension d M r := by
  rw [Fintype.card_prod, tower_coordinates_card]
  simp only [Fintype.card_prod, Fintype.card_fin, constructionDimension]
  ring

def finalWitness {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) : (Fin (constructionDimension d M r) → Bool) → Bool :=
  reindex (Fintype.equivFinOfCardEq (final_coordinates_card d M r)) (finalBoolean d T A)

theorem finalWitness_zero {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    finalWitness d T A (fun _ => false) = false := finalBoolean_zero d T A hr

theorem finalWitness_sensitivity {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hM : 0 < M) (hr : 0 < r)
    (hbudget : ((max r 16 : ℕ) : ℝ) / M * 3 ^ (d + 1) ≤ 2) :
    sensitivity (finalWitness d T A) ≤ 2 * (d + 2) * M ^ (d + 1) := by
  rw [finalWitness, sensitivity_reindex]
  exact finalBoolean_sensitivity d T A hM hr hbudget

theorem finalWitness_blockSensitivity {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    M ^ 2 * (2 * M ^ 2 + 1) ^ d ≤ blockSensitivityAt (finalWitness d T A) (fun _ => false) := by
  rw [finalWitness, blockSensitivityAt_reindex]
  exact finalBoolean_blockSensitivity d T A hr

theorem constructionDimension_pos {d M r : ℕ} (hM : 0 < M) (hr : 0 < r) :
    0 < constructionDimension d M r := by
  unfold constructionDimension
  positivity

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.FixedCoordinates. -/

namespace OAI

/-! Exact finite counting when a specified set of coordinates is fixed. -/

noncomputable section
open scoped Classical

namespace Paper320

variable {α β : Type} [Fintype α] [Fintype β] [DecidableEq α]

def fixedCoordinatesEquiv (s : Finset α) (v : α → β) :
    {f : α → β // ∀ i ∈ s, f i = v i} ≃ ({i : α // i ∉ s} → β) where
  toFun f i := f.val i.val
  invFun f := ⟨fun i => if h : i ∈ s then v i else f ⟨i,h⟩, by
    intro i hi
    simp only [dite_eq_left hi]⟩
  left_inv f := by
    apply Subtype.ext
    funext i
    by_cases hi : i ∈ s
    · simp only [dite_eq_left hi]
      exact (f.property i hi).symm
    · simp only [dite_eq_right hi]
  right_inv f := by
    funext i
    simp only [dite_eq_right i.property]

theorem card_fixedCoordinates (s : Finset α) (v : α → β)
    [DecidablePred (fun f : α → β => ∀ i ∈ s, f i = v i)] :
    (Finset.univ.filter fun f : α → β => ∀ i ∈ s, f i = v i).card =
      Fintype.card β ^ (Fintype.card α - s.card) := by
  rw [← Fintype.card_subtype]
  rw [Fintype.card_congr (fixedCoordinatesEquiv s v), Fintype.card_fun,
    Fintype.card_subtype_compl, Fintype.card_coe]

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Iterates. -/

namespace OAI

/-! Repeated disjoint composition with explicit finite raw-coordinate types. -/

noncomputable section
open scoped Classical

namespace Paper320

abbrev IterateCoord (I : Type) : ℕ → Type
  | 0 => Unit
  | m + 1 => I × IterateCoord I m

instance iterateCoordFintype {I : Type} [Fintype I] :
    (m : ℕ) → Fintype (IterateCoord I m)
  | 0 => inferInstanceAs (Fintype Unit)
  | m + 1 =>
    letI : Fintype (IterateCoord I m) := iterateCoordFintype (I := I) m
    inferInstanceAs (Fintype (I × IterateCoord I m))

def iterateCompose {I : Type} (f : (I → Bool) → Bool) :
    (m : ℕ) → (IterateCoord I m → Bool) → Bool
  | 0 => fun x => x ()
  | m + 1 => compose f (iterateCompose f m)

theorem iterateCompose_one {I : Type} (f : (I → Bool) → Bool)
    (x : IterateCoord I 1 → Bool) :
    iterateCompose f 1 x = f (fun i => x (i, ())) := rfl

theorem iterateCompose_zero {I : Type} (f : (I → Bool) → Bool)
    (hf : f (fun _ => false) = false) (m : ℕ) :
    iterateCompose f m (fun _ => false) = false := by
  induction m with
  | zero => rfl
  | succ m ih => exact (compose_zero f (iterateCompose f m) ih).trans hf

variable {I : Type} [Fintype I]

theorem iterateCoord_card (m : ℕ) :
    Fintype.card (IterateCoord I m) = Fintype.card I ^ m := by
  induction m with
  | zero => exact Fintype.card_unique
  | succ m ih =>
    change Fintype.card (I × IterateCoord I m) = _
    rw [Fintype.card_prod, ih, pow_succ, Nat.mul_comm]

theorem sensitivity_iterateCompose_le (f : (I → Bool) → Bool) (m : ℕ) :
    sensitivity (iterateCompose f m) ≤ sensitivity f ^ m := by
  induction m with
  | zero =>
    apply sensitivity_le
    intro x
    exact (sensitivityAt_le_card (iterateCompose f 0) x).trans_eq (iterateCoord_card 0)
  | succ m ih =>
    change sensitivity (compose f (iterateCompose f m)) ≤ _
    calc
      _ ≤ sensitivity f * sensitivity (iterateCompose f m) := sensitivity_compose_le _ _
      _ ≤ sensitivity f * sensitivity f ^ m := Nat.mul_le_mul_left _ ih
      _ = sensitivity f ^ (m + 1) := by rw [pow_succ, Nat.mul_comm]

theorem blockSensitivityAt_iterateCompose_zero (f : (I → Bool) → Bool)
    (hf : f (fun _ => false) = false) (m : ℕ) :
    blockSensitivityAt f (fun _ => false) ^ m ≤
      blockSensitivityAt (iterateCompose f m) (fun _ => false) := by
  induction m with
  | zero =>
    have h := le_blockSensitivityAt (iterateCompose f 0) (fun _ => false)
      ({{()}} : Finset (Finset Unit))
      (by
        intro A hA B hB hne
        exact (hne ((Finset.mem_singleton.mp hA).trans (Finset.mem_singleton.mp hB).symm)).elim)
      (by
        intro B hB
        have hB' : B = {()} := Finset.mem_singleton.mp hB
        subst B
        exact ⟨Finset.singleton_nonempty _, by simp [iterateCompose, flip]⟩)
    simpa only [Finset.card_singleton, pow_zero] using h
  | succ m ih =>
    change _ ≤ blockSensitivityAt (compose f (iterateCompose f m)) (fun _ => false)
    calc
      _ = blockSensitivityAt f (fun _ => false) *
          blockSensitivityAt f (fun _ => false) ^ m := by rw [pow_succ, Nat.mul_comm]
      _ ≤ blockSensitivityAt f (fun _ => false) *
          blockSensitivityAt (iterateCompose f m) (fun _ => false) := Nat.mul_le_mul_left _ ih
      _ ≤ _ := blockSensitivityAt_compose_zero_le f (iterateCompose f m)
        (iterateCompose_zero f hf m)

def iterateFin (f : (I → Bool) → Bool) (m : ℕ) :
    (Fin (Fintype.card I ^ m) → Bool) → Bool :=
  reindex (Fintype.equivFinOfCardEq (iterateCoord_card (I := I) m)) (iterateCompose f m)

theorem iterateFin_zero (f : (I → Bool) → Bool)
    (hf : f (fun _ => false) = false) (m : ℕ) :
    iterateFin f m (fun _ => false) = false :=
  iterateCompose_zero f hf m

theorem sensitivity_iterateFin_le (f : (I → Bool) → Bool) (m : ℕ) :
    sensitivity (iterateFin f m) ≤ sensitivity f ^ m := by
  rw [iterateFin, sensitivity_reindex]
  exact sensitivity_iterateCompose_le f m

theorem blockSensitivityAt_iterateFin_zero (f : (I → Bool) → Bool)
    (hf : f (fun _ => false) = false) (m : ℕ) :
    blockSensitivityAt f (fun _ => false) ^ m ≤
      blockSensitivityAt (iterateFin f m) (fun _ => false) := by
  rw [iterateFin, blockSensitivityAt_reindex]
  exact blockSensitivityAt_iterateCompose_zero f hf m

theorem nonconstant_of_blockSensitivityAt_pos (f : (I → Bool) → Bool) (x : I → Bool)
    (h : 0 < blockSensitivityAt f x) : ∃ y z, f y ≠ f z := by
  obtain ⟨blocks, hc, _, hb⟩ := exists_blockSensitivityAt_family f x
  have hn : blocks.Nonempty := Finset.card_pos.mp (hc.symm ▸ h)
  obtain ⟨B, hB⟩ := hn
  exact ⟨flip x B, x, (hb B hB).2⟩

theorem iterateFin_nonconstant (f : (I → Bool) → Bool)
    (hf : f (fun _ => false) = false)
    (h : 0 < blockSensitivityAt f (fun _ => false)) (m : ℕ) :
    ∃ x y, iterateFin f m x ≠ iterateFin f m y := by
  exact nonconstant_of_blockSensitivityAt_pos _ _
    ((pow_pos h m).trans_le (blockSensitivityAt_iterateFin_zero f hf m))

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.LabelingConstraints. -/

namespace OAI

/-! The labeling constraints are exactly fixed values on the internal edges. -/

noncomputable section
open scoped Classical

namespace Paper320.Tournament
variable {k : ℕ} (T : Tournament k)

theorem mem_internalEdges {I : Finset (Fin k)} {p : Fin k × Fin k} :
    p ∈ T.internalEdges I ↔ (p.1 ∈ I ∧ p.2 ∈ I) ∧ T.Adj p.1 p.2 := by
  simp only [internalEdges, Finset.mem_filter, Finset.mem_product]

theorem labelingConstraint_iff {α β : Type} [Nonempty α]
    (s : Finset α) (v : α → Fin k) (m : α → β) (hv : Function.Injective v)
    (A : (Fin k × Fin k) → β) :
    (∀ i ∈ s, ∀ j ∈ s, T.Adj (v i) (v j) → A (v i,v j) = m j) ↔
      ∀ p ∈ T.internalEdges (s.image v), A p = m (Function.invFun v p.2) := by
  constructor
  · intro h p hp
    obtain ⟨⟨hp₁,hp₂⟩,ha⟩ := T.mem_internalEdges.mp hp
    obtain ⟨i,hi,hvi⟩ := Finset.mem_image.mp hp₁
    obtain ⟨j,hj,hvj⟩ := Finset.mem_image.mp hp₂
    have he : p = (v i,v j) := Prod.ext hvi.symm hvj.symm
    subst p
    rw [Function.leftInverse_invFun hv j]
    exact h i hi j hj ha
  · intro h i hi j hj ha
    have hp : (v i,v j) ∈ T.internalEdges (s.image v) :=
      T.mem_internalEdges.mpr ⟨⟨Finset.mem_image.mpr ⟨i,hi,rfl⟩,
        Finset.mem_image.mpr ⟨j,hj,rfl⟩⟩,ha⟩
    simpa only [Function.leftInverse_invFun hv j] using h (v i,v j) hp

end Paper320.Tournament

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.LabelingEvents. -/

namespace OAI

/-! Exact counts of target-constant label constraints on sixteen vertices. -/

noncomputable section
open scoped Classical BigOperators

namespace Paper320.Tournament
variable {k r n : ℕ} (T : Tournament k)

def labelingEvent (v : Fin n → Fin k) (m : Fin n → Fin r) :
    Finset ((Fin k × Fin k) → Fin r) :=
  if Function.Injective v then
    Finset.univ.filter fun A => ∀ i j, T.Adj (v i) (v j) → A (v i, v j) = m j
  else ∅

theorem mem_labelingEvent_iff {v : Fin n → Fin k} {m : Fin n → Fin r}
    {A : (Fin k × Fin k) → Fin r} (hv : Function.Injective v) :
    A ∈ T.labelingEvent v m ↔ ∀ i j, T.Adj (v i) (v j) → A (v i,v j) = m j := by
  simp only [labelingEvent, ite_eq_left hv, Finset.mem_filter, Finset.mem_univ, true_and]

theorem labelingEvent_eq [NeZero n] (v : Fin n → Fin k) (m : Fin n → Fin r)
    (hv : Function.Injective v) :
    T.labelingEvent v m = Finset.univ.filter fun A =>
      ∀ p ∈ T.internalEdges (Finset.univ.image v), A p = m (Function.invFun v p.2) := by
  rw [labelingEvent, ite_eq_left hv]
  apply Finset.filter_congr
  intro A _
  simpa only [Finset.mem_univ, forall_const] using
    T.labelingConstraint_iff Finset.univ v m hv A

theorem card_labelingEvent [NeZero n] (v : Fin n → Fin k) (m : Fin n → Fin r)
    (hv : Function.Injective v) :
    (T.labelingEvent v m).card = r ^ (k*k-n.choose 2) := by
  rw [T.labelingEvent_eq v m hv]
  have hc := card_fixedCoordinates (T.internalEdges (Finset.univ.image v))
    (fun p => m (Function.invFun v p.2))
  rw [T.card_internalEdges] at hc
  have hi : (Finset.univ.image v).card = n := by
    rw [Finset.card_image_of_injective _ hv]
    exact Fintype.card_fin n
  rw [hi] at hc
  simpa only [Fintype.card_fin, Fintype.card_prod] using hc

theorem card_labelingEvent_le [NeZero n] (v : Fin n → Fin k) (m : Fin n → Fin r) :
    (T.labelingEvent v m).card ≤ r ^ (k*k-n.choose 2) := by
  by_cases hv : Function.Injective v
  · exact (T.card_labelingEvent v m hv).le
  · simp only [labelingEvent, ite_eq_right hv, Finset.card_empty, Nat.zero_le]

def badLabelings (n r : ℕ) : Finset ((Fin k × Fin k) → Fin r) :=
  Finset.univ.biUnion fun v : Fin n → Fin k =>
    Finset.univ.biUnion fun m : Fin n → Fin r => T.labelingEvent v m

theorem labelingEvent_subset_bad {v : Fin n → Fin k} {m : Fin n → Fin r} :
    T.labelingEvent v m ⊆ T.badLabelings n r := by
  intro A hA
  exact Finset.mem_biUnion.mpr ⟨v,Finset.mem_univ _,
    Finset.mem_biUnion.mpr ⟨m,Finset.mem_univ _,hA⟩⟩

theorem card_badLabelings_le [NeZero n] :
    (T.badLabelings n r).card ≤ k^n * r^n * r^(k*k-n.choose 2) := by
  calc
    (T.badLabelings n r).card ≤ ∑ v : Fin n → Fin k,
        (Finset.univ.biUnion fun m : Fin n → Fin r => T.labelingEvent v m).card :=
      Finset.card_biUnion_le
    _ ≤ ∑ _v : Fin n → Fin k, ∑ _m : Fin n → Fin r, r^(k*k-n.choose 2) := by
      apply Finset.sum_le_sum
      intro v _
      exact Finset.card_biUnion_le.trans (Finset.sum_le_sum fun m _ =>
        T.card_labelingEvent_le v m)
    _ = k^n * r^n * r^(k*k-n.choose 2) := by
      simp [Nat.mul_assoc]

end Paper320.Tournament

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.LabelingBounds. -/

namespace OAI

/-! Symbolic estimates for the sixteen-vertex labeling union bound. -/

namespace Paper320

theorem le_ceil_sqrt_sq (M : ℕ) : M ≤ (Nat.ceil (Real.sqrt M))^2 := by
  have hs := Nat.le_ceil (Real.sqrt (M : ℝ))
  have hr := Real.sqrt_nonneg (M : ℝ)
  have he := Real.sq_sqrt (Nat.cast_nonneg M : (0 : ℝ) ≤ M)
  have hh : (M : ℝ) ≤ (Nat.ceil (Real.sqrt M) : ℝ)^2 := by nlinarith
  exact_mod_cast hh

theorem labeling_space_large {M : ℕ} (hM : 3 ≤ M) :
    120 ≤ (2*M^2+1)*(2*M^2+1) := by
  have : 19 ≤ 2*M^2+1 := by nlinarith
  nlinarith

end Paper320

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.LabelingEstimate. -/

namespace OAI

/-! An explicit numerical union-bound estimate. -/

namespace Paper320

theorem labeling_union_bound_numerator {M r : ℕ} (hM : 3 ≤ M) (hMr : M ≤ r^2) :
    (2*M^2+1)^16 * M^20 ≤ 3^16 * r^104 := by
  have hk : 2*M^2+1 ≤ 3*M^2 := by nlinarith
  have hp : M^52 ≤ r^104 := by
    calc
      M^52 ≤ (r^2)^52 := Nat.pow_le_pow_left hMr 52
      _ = r^104 := by rw [← pow_mul]
  calc
    (2*M^2+1)^16 * M^20 ≤ (3*M^2)^16 * M^20 :=
      Nat.mul_le_mul_right _ (Nat.pow_le_pow_left hk 16)
    _ = 3^16 * M^52 := by rw [mul_pow, ← pow_mul, mul_assoc, ← pow_add]
    _ ≤ 3^16 * r^104 := Nat.mul_le_mul_left _ hp

theorem labeling_union_bound_constant {M : ℕ} (hM : 3 ≤ M) :
    3^16 < M^20 := by
  calc
    3^16 ≤ M^16 := Nat.pow_le_pow_left hM 16
    _ < M^20 := Nat.pow_lt_pow_right (by omega) (by omega)

theorem labeling_power_bound {M r : ℕ} (hM : 3 ≤ M) (hMr : M ≤ r^2) :
    (2*M^2+1)^16 < r^104 := by
  have hr : 0 < r := (Nat.pow_pos_iff.mp
    (lt_of_lt_of_le (show 0 < M by omega) hMr)).resolve_right (by omega)
  apply Nat.lt_of_mul_lt_mul_right (a := M^20)
  calc
    (2*M^2+1)^16 * M^20 ≤ 3^16*r^104 := labeling_union_bound_numerator hM hMr
    _ < M^20*r^104 := Nat.mul_lt_mul_of_pos_right (labeling_union_bound_constant hM)
      (pow_pos hr 104)
    _ = r^104*M^20 := Nat.mul_comm _ _

theorem labeling_union_bound_real {M r : ℕ} (hM : 3 ≤ M) (hMr : M ≤ r^2) :
    (((2*M^2+1)^16 : ℕ) : ℝ) / (r : ℝ)^104 ≤ 3^16 / (M : ℝ)^20 ∧
      3^16 / (M : ℝ)^20 < 1 := by
  have hMp : (0 : ℝ) < M := by exact_mod_cast (show 0 < M by omega)
  have hrp : (0 : ℝ) < r := by
    have hr : 0 < r := (Nat.pow_pos_iff.mp
      (lt_of_lt_of_le (show 0 < M by omega) hMr)).resolve_right (by omega)
    exact_mod_cast hr
  constructor
  · apply (div_le_div_iff₀ (pow_pos hrp 104) (pow_pos hMp 20)).mpr
    exact_mod_cast labeling_union_bound_numerator hM hMr
  · apply (div_lt_one (pow_pos hMp 20)).mpr
    exact_mod_cast labeling_union_bound_constant hM

theorem labeling_sqrt_expression {M : ℕ} (hM : 0 < M) :
    (3*(M : ℝ)^2)^16 / (Real.sqrt M)^104 = 3^16 / (M : ℝ)^20 := by
  have hp : (0 : ℝ) < M := by exact_mod_cast hM
  have hd : (Real.sqrt M)^104 = (M : ℝ)^52 := by
    rw [show 104 = 2*52 from rfl, pow_mul, Real.sq_sqrt hp.le]
  rw [hd, div_eq_div_iff (pow_ne_zero _ hp.ne') (pow_ne_zero _ hp.ne'),
    mul_pow, ← pow_mul, mul_assoc, ← pow_add]

theorem labeling_source_estimate {M : ℕ} (hM : 3 ≤ M) :
    (((2*M^2+1)^16 : ℕ) : ℝ) / (Nat.ceil (Real.sqrt M) : ℝ)^104 ≤
        (3*(M : ℝ)^2)^16 / (Real.sqrt M)^104 ∧
      (3*(M : ℝ)^2)^16 / (Real.sqrt M)^104 = 3^16 / (M : ℝ)^20 ∧
      3^16 / (M : ℝ)^20 < 1 := by
  have h := labeling_union_bound_real hM (le_ceil_sqrt_sq M)
  have he := labeling_sqrt_expression (show 0 < M by omega)
  exact ⟨he.symm ▸ h.1, he, h.2⟩

end Paper320

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.TournamentCyclic. -/

namespace OAI

/-! The literal regular tournament on an odd cyclic set. -/

noncomputable section
open scoped Classical

namespace Paper320

def cyclicTournament (a : ℕ) : Tournament (2*a+1) where
  Adj i j := 0 < (j-i).val ∧ (j-i).val ≤ a
  loopless i := by simp
  edge_compl := by
    intro i j hij
    have hδ : j-i ≠ 0 := sub_ne_zero.mpr hij.symm
    have hp : 0 < (j-i).val := Nat.pos_of_ne_zero (Fin.val_ne_zero_iff.mpr hδ)
    have hb := (j-i).isLt
    have hn : (i-j).val = 2*a+1-(j-i).val := by
      rw [← neg_sub j i, Fin.val_neg, ite_eq_right hδ]
    change (0 < (j-i).val ∧ (j-i).val ≤ a) ↔ ¬ (0 < (i-j).val ∧ (i-j).val ≤ a)
    rw [hn]
    omega

theorem cyclicTournament_outdegree (a : ℕ) (i : Fin (2*a+1)) :
    (Finset.univ.filter ((cyclicTournament a).Adj i)).card = a := by
  let z : Fin (2*a+1) := 0
  let b : Fin (2*a+1) := ⟨a, by omega⟩
  have he : (Finset.Ioc z b).card =
      (Finset.univ.filter ((cyclicTournament a).Adj i)).card :=
    Finset.card_equiv (Equiv.addLeft i) (by
      intro x
      simp only [Finset.mem_Ioc, Finset.mem_filter, Finset.mem_univ, true_and]
      change (0 < x.val ∧ x.val ≤ a) ↔
        (0 < ((i+x)-i).val ∧ ((i+x)-i).val ≤ a)
      rw [add_sub_cancel_left])
  rw [← he, Fin.card_Ioc]
  change a - 0 = a
  exact Nat.sub_zero a

def regularCyclicTournament (M : ℕ) : RegularTournament M where
  toTournament := cyclicTournament (M^2)
  outdegree := cyclicTournament_outdegree (M^2)

end Paper320

end

end OAI


/- Upstream module: OAI.Combinatorics.Sensitivity.Labeling. -/

namespace OAI

/-! A finite union bound supplies a good edge labeling. -/

noncomputable section
open scoped Classical

namespace Paper320

namespace Tournament
variable {k r : ℕ} (T : Tournament k)

theorem goodLabeling_exists_of_power_bound (hr : 0 < r) (hN : 120 ≤ k*k)
    (hkr : k^16 < r^104) : Nonempty (GoodLabeling T r) := by
  have htotal : k^16*r^16*r^(k*k-120) < r^(k*k) := by
    calc
      k^16*r^16*r^(k*k-120) < r^104*r^16*r^(k*k-120) :=
        Nat.mul_lt_mul_of_pos_right
          (Nat.mul_lt_mul_of_pos_right hkr (pow_pos hr 16)) (pow_pos hr _)
      _ = r^(104+16+(k*k-120)) := by rw [pow_add, pow_add]
      _ = r^(k*k) := congrArg (fun e : ℕ => r^e) (by omega)
  have hc : (T.badLabelings 16 r).card <
      (Finset.univ : Finset ((Fin k × Fin k) → Fin r)).card := by
    simpa only [Finset.card_univ, Fintype.card_fun, Fintype.card_prod, Fintype.card_fin]
      using (T.card_badLabelings_le (r := r) (n := 16)).trans_lt htotal
  obtain ⟨A,_,hA⟩ := Finset.exists_mem_notMem_of_card_lt_card hc
  refine ⟨⟨fun i j => A (i,j), ?_⟩⟩
  intro I hI m
  by_contra hn
  let e : Fin 16 ≃ I := (Finset.equivFinOfCardEq hI).symm
  let v : Fin 16 → Fin k := fun i => (e i).val
  have hv : Function.Injective v := Subtype.val_injective.comp e.injective
  have hevent : A ∈ T.labelingEvent v (fun i => m (v i)) := by
    apply T.mem_labelingEvent_iff hv |>.mpr
    intro i j ha
    by_contra h
    exact hn ⟨v i,(e i).property,v j,(e j).property,ha,h⟩
  apply hA
  exact T.labelingEvent_subset_bad hevent

end Tournament

theorem goodLabeling_exists {M r : ℕ} (hM : 3 ≤ M) (hMr : M ≤ r^2)
    (T : Tournament (2*M^2+1)) : Nonempty (GoodLabeling T r) := by
  have hr : 0 < r := (Nat.pow_pos_iff.mp
    (lt_of_lt_of_le (show 0 < M by omega) hMr)).resolve_right (by omega)
  exact T.goodLabeling_exists_of_power_bound hr (labeling_space_large hM)
    (labeling_power_bound hM hMr)

theorem regular_goodLabeling_exists {M : ℕ} (hM : 3 ≤ M) :
    Nonempty (GoodLabeling (regularCyclicTournament M).toTournament
      (Nat.ceil (Real.sqrt M))) :=
  goodLabeling_exists hM (le_ceil_sqrt_sq M) _

namespace GoodLabeling

theorem good_on_subset {k r : ℕ} {T : Tournament k} (A : GoodLabeling T r)
    (I : Finset (Fin k)) (hI : I.card = 16) (m : I → Fin r) :
    ∃ i ∈ I, ∃ j, ∃ hj : j ∈ I,
      T.Adj i j ∧ A.label i j ≠ m ⟨j,hj⟩ := by
  obtain ⟨j,hj⟩ := Finset.card_pos.mp (show 0 < I.card by omega)
  let m' : Fin k → Fin r := fun i => if hi : i ∈ I then m ⟨i,hi⟩ else m ⟨j,hj⟩
  obtain ⟨a,ha,b,hb,hab,hne⟩ := A.good I hI m'
  refine ⟨a,ha,b,hb,hab,?_⟩
  simpa only [m', dite_eq_left hb] using hne

end GoodLabeling
end Paper320

end

end OAI


/- Campaign extension: ProfileCore.lean. -/

namespace QuantitativeProfile

noncomputable section

structure Profile where
  s0 : ℝ
  s1 : ℝ
  j0 : ℝ
  j1 : ℝ

def step (p q : ℝ) (x : Profile) : Profile :=
  ⟨p * x.s0 + x.s1 + 3 * x.j1, x.s0 + q * x.s1,
    p * x.s0 + 3 * x.j1, x.j0 + q * x.s1⟩

def profile (p q : ℝ) : ℕ → Profile
  | 0 => ⟨1, 1, 0, 0⟩
  | n + 1 => step p q (profile p q n)

def Below (x y : Profile) : Prop :=
  x.s0 ≤ y.s0 ∧ x.s1 ≤ y.s1 ∧ x.j0 ≤ y.j0 ∧ x.j1 ≤ y.j1

theorem step_mono {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    {x y : Profile} (h : Below x y) : Below (step p q x) (step p q y) := by
  rcases h with ⟨h0, h1, h2, h3⟩
  dsimp [Below, step]
  constructor
  · gcongr
  constructor
  · gcongr
  constructor <;> gcongr

theorem profile_increases {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) (n : ℕ) :
    Below (profile p q n) (profile p q (n + 1)) := by
  induction n with
  | zero => simp [Below, profile, step, hp, hq]
  | succ n ih => exact step_mono hp hq ih

theorem profile_s0_mono {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) :
    Monotone (fun n => (profile p q n).s0) :=
  monotone_nat_of_le_succ (fun n => (profile_increases hp hq n).1)

theorem profile_s1_mono {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) :
    Monotone (fun n => (profile p q n).s1) :=
  monotone_nat_of_le_succ (fun n => (profile_increases hp hq n).2.1)

def alpha (p q : ℝ) := p + p ^ 2 + 4 * q
def beta (p : ℝ) := 9 + 3 * p
def gamma (p q : ℝ) := p + q + q ^ 2
def delta (p : ℝ) := 3 + p

def envelope (p q : ℝ) : ℕ → ℝ × ℝ
  | 0 => (1, 0)
  | n + 1 =>
      let x := envelope p q n
      ((1 + alpha p q) * x.1 + beta p * x.2,
        gamma p q * x.1 + delta p * x.2)

def Covers (x : Profile) (u v : ℝ) : Prop :=
  x.s0 ≤ u ∧ x.s1 ≤ u ∧ x.j0 ≤ 3 * v ∧ x.j1 ≤ v

theorem envelope_nonneg {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) (n : ℕ) :
    0 ≤ (envelope p q n).1 ∧ 0 ≤ (envelope p q n).2 := by
  induction n with
  | zero => norm_num [envelope]
  | succ n ih =>
      rcases ih with ⟨hu, hv⟩
      dsimp [envelope]
      constructor <;> dsimp [alpha, beta, gamma, delta] <;> positivity

theorem two_step_covers {p q : ℝ} (hp : 0 ≤ p) (hp1 : p ≤ 1)
    (hq : 0 ≤ q) (hq1 : q ≤ 1) {x : Profile} {u v : ℝ}
    (hu : 0 ≤ u) (hv : 0 ≤ v) (h : Covers x u v) :
    Covers (step p q (step p q x))
      ((1 + alpha p q) * u + beta p * v)
      (gamma p q * u + delta p * v) := by
  rcases h with ⟨h0, h1, h2, h3⟩
  have hp2 : p ^ 2 ≤ p := by nlinarith
  have hq2 : q ^ 2 ≤ q := by nlinarith
  dsimp only [Covers]
  constructor
  · calc
      (step p q (step p q x)).s0 =
          (1 + p ^ 2) * x.s0 + (p + 4 * q) * x.s1 +
            3 * x.j0 + 3 * p * x.j1 := by simp [step]; ring
      _ ≤ (1 + p ^ 2) * u + (p + 4 * q) * u +
            3 * (3 * v) + 3 * p * v := by gcongr
      _ = _ := by dsimp [alpha, beta]; ring
  constructor
  · have hc : (p + q) + (1 + q ^ 2) ≤ 1 + alpha p q := by
      dsimp [alpha]
      nlinarith [sq_nonneg p]
    have hb : 3 ≤ beta p := by dsimp [beta]; linarith
    calc
      (step p q (step p q x)).s1 =
          (p + q) * x.s0 + (1 + q ^ 2) * x.s1 + 3 * x.j1 := by
            simp [step]; ring
      _ ≤ (p + q) * u + (1 + q ^ 2) * u + 3 * v := by gcongr
      _ ≤ _ := by
        nlinarith [mul_le_mul_of_nonneg_right hc hu,
          mul_le_mul_of_nonneg_right hb hv]
  constructor
  · have hc : p ^ 2 + p + 3 * q ≤ 3 * gamma p q := by
      dsimp [gamma]
      nlinarith [sq_nonneg q]
    calc
      (step p q (step p q x)).j0 =
          p ^ 2 * x.s0 + (p + 3 * q) * x.s1 + 3 * x.j0 + 3 * p * x.j1 := by
            simp [step]; ring
      _ ≤ p ^ 2 * u + (p + 3 * q) * u + 3 * (3 * v) + 3 * p * v := by
            gcongr
      _ ≤ _ := by
        dsimp [delta]
        nlinarith [mul_le_mul_of_nonneg_right hc hu]
  · calc
      (step p q (step p q x)).j1 =
          (p + q) * x.s0 + q ^ 2 * x.s1 + 3 * x.j1 := by simp [step]; ring
      _ ≤ (p + q) * u + q ^ 2 * u + 3 * v := by gcongr
      _ ≤ _ := by
        dsimp [gamma, delta]
        nlinarith [mul_nonneg hp hv]

theorem envelope_covers {p q : ℝ} (hp : 0 ≤ p) (hp1 : p ≤ 1)
    (hq : 0 ≤ q) (hq1 : q ≤ 1) (n : ℕ) :
    Covers (profile p q (2 * n)) (envelope p q n).1 (envelope p q n).2 := by
  induction n with
  | zero => norm_num [Covers, profile, envelope]
  | succ n ih =>
      have he : 2 * (n + 1) = (2 * n + 1) + 1 := by omega
      rw [he]
      exact two_step_covers hp hp1 hq hq1
        (envelope_nonneg hp hq n).1 (envelope_nonneg hp hq n).2 ih

theorem weighted_envelope {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    (ha : alpha p q ≤ 17 / 4 * q) (hb : beta p ≤ 10)
    (hg : gamma p q ≤ 6 / 5 * q) (hd : delta p ≤ 3 + q / 6) (n : ℕ) :
    (envelope p q n).2 + gamma p q / 2 * (envelope p q n).1 ≤
      gamma p q / 2 * (3 + 7 * q) ^ n := by
  have hg0 : 0 ≤ gamma p q := by dsimp [gamma]; positivity
  have hb0 : 0 ≤ beta p := by dsimp [beta]; positivity
  have hlambda : 0 ≤ 3 + 7 * q := by positivity
  have hc0 : 3 + alpha p q ≤ 3 + 7 * q := by nlinarith
  have hc1 : delta p + gamma p q / 2 * beta p ≤ 3 + 7 * q := by
    nlinarith [mul_le_mul_of_nonneg_right hb hg0]
  induction n with
  | zero => simp [envelope]
  | succ n ih =>
      have hu := (envelope_nonneg hp hq n).1
      have hv := (envelope_nonneg hp hq n).2
      calc
        _ = (gamma p q / 2 * (3 + alpha p q)) * (envelope p q n).1 +
            (delta p + gamma p q / 2 * beta p) * (envelope p q n).2 := by
              dsimp [envelope]; ring
        _ ≤ (gamma p q / 2 * (3 + 7 * q)) * (envelope p q n).1 +
            (3 + 7 * q) * (envelope p q n).2 := by gcongr
        _ = (3 + 7 * q) *
            ((envelope p q n).2 + gamma p q / 2 * (envelope p q n).1) := by ring
        _ ≤ (3 + 7 * q) * (gamma p q / 2 * (3 + 7 * q) ^ n) := by gcongr
        _ = _ := by rw [pow_succ]; ring

theorem envelope_bound {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    (ha : alpha p q ≤ 17 / 4 * q) (hb : beta p ≤ 10)
    (hg : gamma p q ≤ 6 / 5 * q) (hd : delta p ≤ 3 + q / 6) (n : ℕ) :
    (envelope p q n).1 ≤
      (1 + 17 / 4 * q) ^ n + 3 * q * (3 + 7 * q) ^ n := by
  have ha0 : 0 ≤ alpha p q := by dsimp [alpha]; positivity
  have hb0 : 0 ≤ beta p := by dsimp [beta]; positivity
  have hg0 : 0 ≤ gamma p q := by dsimp [gamma]; positivity
  have hlambda : 1 + alpha p q + 2 ≤ 3 + 7 * q := by nlinarith
  have haux (n : ℕ) : (envelope p q n).1 ≤
      (1 + alpha p q) ^ n + (beta p * gamma p q / 4) * (3 + 7 * q) ^ n := by
    induction n with
    | zero =>
        simp only [envelope, pow_zero, mul_one]
        nlinarith [mul_nonneg hb0 hg0]
    | succ n ih =>
        have hv : (envelope p q n).2 ≤ gamma p q / 2 * (3 + 7 * q) ^ n := by
          have hw := weighted_envelope hp hq ha hb hg hd n
          have hu := (envelope_nonneg hp hq n).1
          nlinarith [mul_nonneg hg0 hu]
        calc
          _ = (1 + alpha p q) * (envelope p q n).1 +
              beta p * (envelope p q n).2 := rfl
          _ ≤ (1 + alpha p q) *
              ((1 + alpha p q) ^ n + beta p * gamma p q / 4 * (3 + 7 * q) ^ n) +
              beta p * (gamma p q / 2 * (3 + 7 * q) ^ n) := by gcongr
          _ = (1 + alpha p q) ^ (n + 1) +
              (beta p * gamma p q / 4) * (1 + alpha p q + 2) *
                (3 + 7 * q) ^ n := by rw [pow_succ]; ring
          _ ≤ (1 + alpha p q) ^ (n + 1) +
              (beta p * gamma p q / 4) * (3 + 7 * q) ^ (n + 1) := by
                rw [show (3 + 7 * q) ^ (n + 1) =
                  (3 + 7 * q) ^ n * (3 + 7 * q) from pow_succ _ _]
                have hc0 : 0 ≤ beta p * gamma p q / 4 := by positivity
                have hm := mul_le_mul_of_nonneg_left hlambda hc0
                nlinarith [mul_le_mul_of_nonneg_right hm
                  (show 0 ≤ (3 + 7 * q) ^ n by positivity)]
  have hc : beta p * gamma p q / 4 ≤ 3 * q := by
    nlinarith [mul_le_mul_of_nonneg_right hb hg0]
  calc
    _ ≤ (1 + alpha p q) ^ n + beta p * gamma p q / 4 * (3 + 7 * q) ^ n := haux n
    _ ≤ _ := by gcongr

theorem power_gap (x : ℝ) (hx : 0 ≤ x) (n : ℕ) :
    (1 + x) ^ n * (1 - (n : ℝ) * x) ≤ 1 := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      have ht : 0 ≤ (1 + x) ^ n * ((n : ℝ) + 1) * x ^ 2 := by positivity
      rw [pow_succ]
      push_cast
      nlinarith

theorem nine_mul_le_pow (n : ℕ) : 9 * (n + 3) ≤ 3 ^ (n + 3) := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      rw [show n + 1 + 3 = (n + 3) + 1 by omega, pow_succ]
      omega

def qDepth (h : ℕ) : ℝ := 1 / (4 * 3 ^ h)
def pDepth (h : ℕ) : ℝ := 16 * qDepth h ^ 2

theorem depth_budget {h : ℕ} (hh : 3 ≤ h) :
    0 ≤ qDepth h ∧ qDepth h ≤ 1 / 108 ∧
      (h : ℝ) * qDepth h ≤ 1 / 36 ∧ qDepth h * 3 ^ h = 1 / 4 := by
  have hq : 0 ≤ qDepth h := by unfold qDepth; positivity
  have he : h = (h - 3) + 3 := by omega
  have hn : 9 * h ≤ 3 ^ h := by
    conv_lhs => rw [he]
    conv_rhs => rw [he]
    exact nine_mul_le_pow (h - 3)
  have hr : (9 : ℝ) * (h : ℝ) ≤ (3 : ℝ) ^ h := by exact_mod_cast hn
  have hhR : (3 : ℝ) ≤ h := by exact_mod_cast hh
  have hpow : (27 : ℝ) ≤ 3 ^ h := by linarith
  have hs : qDepth h * 3 ^ h = 1 / 4 := by
    unfold qDepth
    field_simp
  refine ⟨hq, ?_, ?_, hs⟩
  · nlinarith [mul_le_mul_of_nonneg_left hpow hq]
  · nlinarith [mul_le_mul_of_nonneg_right hr hq]

theorem terminal_bound (h : ℕ) (hh : 1 ≤ h) :
    (profile (pDepth h) (qDepth h) (2 * h)).s0 ≤ 2 ∧
      (profile (pDepth h) (qDepth h) (2 * h)).s1 ≤ 2 := by
  by_cases hsmall : h < 3
  · interval_cases h <;> norm_num [pDepth, qDepth, profile, step] at *
  have hlarge : 3 ≤ h := by omega
  obtain ⟨hq, hqmax, hbudget, hscale⟩ := depth_budget hlarge
  let p := pDepth h
  let q := qDepth h
  have hp : 0 ≤ p := by dsimp [p, pDepth]; positivity
  have hpq : p ≤ q / 6 := by dsimp [p, q, pDepth]; nlinarith
  have hp1 : p ≤ 1 / 3 := by dsimp [q] at hpq; linarith
  have hq1 : q ≤ 1 := by dsimp [q]; linarith
  have ha : alpha p q ≤ 17 / 4 * q := by
    dsimp [alpha]
    nlinarith [mul_nonneg hp (show 0 ≤ 1 / 2 - p by linarith)]
  have hb : beta p ≤ 10 := by dsimp [beta]; linarith
  have hg : gamma p q ≤ 6 / 5 * q := by
    have hq30 : q ≤ 1 / 30 := by dsimp [q]; linarith
    dsimp [gamma]
    nlinarith [mul_nonneg hq (show 0 ≤ 1 / 30 - q by linarith)]
  have hd : delta p ≤ 3 + q / 6 := by dsimp [delta]; linarith
  have hbnd := envelope_bound hp hq ha hb hg hd h
  have hslow : (1 + 17 / 4 * q) ^ h ≤ 144 / 127 := by
    have hx : 0 ≤ 17 / 4 * q := by positivity
    have ht := power_gap (17 / 4 * q) hx h
    have hn : (h : ℝ) * (17 / 4 * q) ≤ 17 / 144 := by nlinarith
    have hz : 0 ≤ (1 + 17 / 4 * q) ^ h := by positivity
    nlinarith [mul_le_mul_of_nonneg_left hn hz]
  have hfast : (1 + 7 / 3 * q) ^ h ≤ 108 / 101 := by
    have hx : 0 ≤ 7 / 3 * q := by positivity
    have ht := power_gap (7 / 3 * q) hx h
    have hn : (h : ℝ) * (7 / 3 * q) ≤ 7 / 108 := by nlinarith
    have hz : 0 ≤ (1 + 7 / 3 * q) ^ h := by positivity
    nlinarith [mul_le_mul_of_nonneg_left hn hz]
  have hfactor : (3 + 7 * q) ^ h = 3 ^ h * (1 + 7 / 3 * q) ^ h := by
    rw [← mul_pow]
    congr 1
    ring
  have hfastTerm : 3 * q * (3 + 7 * q) ^ h ≤ 81 / 101 := by
    rw [hfactor]
    have he : 3 * q * (3 ^ h * (1 + 7 / 3 * q) ^ h) =
        3 / 4 * (1 + 7 / 3 * q) ^ h := by
      calc
        _ = 3 * (q * 3 ^ h) * (1 + 7 / 3 * q) ^ h := by ring
        _ = _ := by rw [hscale]; ring
    rw [he]
    nlinarith
  have hu : (envelope p q h).1 ≤ 2 := by
    linarith [hbnd]
  have hc := envelope_covers hp (by linarith) hq hq1 h
  exact ⟨hc.1.trans hu, hc.2.1.trans hu⟩

theorem uniform_profiles (h n : ℕ) (hh : 1 ≤ h) (hn : n ≤ 2 * h) :
    (profile (pDepth h) (qDepth h) n).s0 ≤ 2 ∧
      (profile (pDepth h) (qDepth h) n).s1 ≤ 2 := by
  have hp : 0 ≤ pDepth h := by unfold pDepth; positivity
  have hq : 0 ≤ qDepth h := by unfold qDepth; positivity
  obtain ⟨h0, h1⟩ := terminal_bound h hh
  exact ⟨(profile_s0_mono hp hq hn).trans h0,
    (profile_s1_mono hp hq hn).trans h1⟩

structure NatProfile where
  s0 : ℕ
  s1 : ℕ
  j0 : ℕ
  j1 : ℕ

def raw (L M r : ℕ) : ℕ → NatProfile
  | 0 => ⟨L, L * M, 0, 0⟩
  | n + 1 =>
      let x := raw L M r n
      ⟨16 * x.s0 + x.s1 + 3 * x.j1, M ^ 2 * x.s0 + r * x.s1,
        16 * x.s0 + 3 * x.j1, M ^ 2 * x.j0 + r * x.s1⟩

theorem raw_majorizes (d L M r : ℕ) (S J : ℕ → Bool → ℕ)
    (hS0 : S 0 false ≤ L) (hS1 : S 0 true ≤ L * M)
    (hJ0 : J 0 false = 0) (hJ1 : J 0 true = 0)
    (hs0 : ∀ n < d, S (n + 1) false ≤ 16 * S n false + S n true + 3 * J n true)
    (hs1 : ∀ n < d, S (n + 1) true ≤ M ^ 2 * S n false + r * S n true)
    (hj0 : ∀ n < d, J (n + 1) false ≤ 16 * S n false + 3 * J n true)
    (hj1 : ∀ n < d, J (n + 1) true ≤ M ^ 2 * J n false + r * S n true) :
    ∀ n ≤ d, S n false ≤ (raw L M r n).s0 ∧ S n true ≤ (raw L M r n).s1 ∧
      J n false ≤ (raw L M r n).j0 ∧ J n true ≤ (raw L M r n).j1 := by
  intro n
  induction n with
  | zero => intro _; simpa [raw, hJ0, hJ1] using And.intro hS0 hS1
  | succ n ih =>
      intro hn
      rcases ih (by omega) with ⟨a, b, c, e⟩
      have hnd : n < d := by omega
      refine ⟨(hs0 n hnd).trans ?_, (hs1 n hnd).trans ?_,
        (hj0 n hnd).trans ?_, (hj1 n hnd).trans ?_⟩
      all_goals dsimp [raw]; gcongr

theorem raw_scaled (L M r n : ℕ) (hM : 0 < M) :
    ((raw L M r n).s0 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ n * (profile (16 / M) (r / M) n).s0 ∧
    ((raw L M r n).s1 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ (n + 1) * (profile (16 / M) (r / M) n).s1 ∧
    ((raw L M r n).j0 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ n * (profile (16 / M) (r / M) n).j0 ∧
    ((raw L M r n).j1 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ (n + 1) * (profile (16 / M) (r / M) n).j1 := by
  have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast hM.ne'
  induction n with
  | zero => norm_num [raw, profile]
  | succ n ih =>
      rcases ih with ⟨h0, h1, h2, h3⟩
      refine ⟨?_, ?_, ?_, ?_⟩
      all_goals
        simp only [raw, profile, step]
        push_cast
        simp only [h0, h1, h2, h3, pow_succ]
        field_simp
        <;> ring

def mDepth (h : ℕ) : ℕ := 16 * 3 ^ (2 * h)
def rDepth (h : ℕ) : ℕ := 4 * 3 ^ h

theorem depth_parameter_identities (h : ℕ) :
    (16 : ℝ) / mDepth h = pDepth h ∧
      (rDepth h : ℝ) / mDepth h = qDepth h ∧
      rDepth h ^ 2 = mDepth h := by
  have hn : (3 : ℝ) ^ h ≠ 0 := by positivity
  have he : 2 * h = h * 2 := by omega
  refine ⟨?_, ?_, ?_⟩
  · simp only [mDepth, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow, pDepth, qDepth]
    rw [he, pow_mul]
    field_simp
    <;> ring
  · simp only [rDepth, mDepth, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow, qDepth]
    rw [he, pow_mul]
    field_simp
    <;> ring
  · dsimp [rDepth, mDepth]
    rw [he, pow_mul]
    ring

theorem raw_even_bound (h L n : ℕ) (hh : 1 ≤ h) (hn : n ≤ 2 * h) :
    (raw L (mDepth h) (rDepth h) n).s0 ≤ 2 * L * mDepth h ^ n ∧
      (raw L (mDepth h) (rDepth h) n).s1 ≤ 2 * L * mDepth h ^ (n + 1) := by
  have hM : 0 < mDepth h := by dsimp [mDepth]; positivity
  obtain ⟨h0, h1, _, _⟩ := raw_scaled L (mDepth h) (rDepth h) n hM
  obtain ⟨hp, hq, _⟩ := depth_parameter_identities h
  rw [hp, hq] at h0 h1
  obtain ⟨ha, hb⟩ := uniform_profiles h n hh hn
  constructor
  · have hc : ((raw L (mDepth h) (rDepth h) n).s0 : ℝ) ≤
        2 * (L : ℝ) * (mDepth h : ℝ) ^ n := by
      rw [h0]
      nlinarith [mul_le_mul_of_nonneg_left ha
        (show 0 ≤ (L : ℝ) * (mDepth h : ℝ) ^ n by positivity)]
    exact_mod_cast hc
  · have hc : ((raw L (mDepth h) (rDepth h) n).s1 : ℝ) ≤
        2 * (L : ℝ) * (mDepth h : ℝ) ^ (n + 1) := by
      rw [h1]
      nlinarith [mul_le_mul_of_nonneg_left hb
        (show 0 ≤ (L : ℝ) * (mDepth h : ℝ) ^ (n + 1) by positivity)]
    exact_mod_cast hc

def seedM : ℕ := mDepth 10
def seedR : ℕ := rDepth 10
def seedA : ℕ := 36 * seedM ^ 21
def seedB : ℕ := seedM ^ 2 * (2 * seedM ^ 2 + 1) ^ 20

set_option exponentiation.threshold 2048 in
theorem seed_integer_exponent : seedA ^ 161 ≤ seedB ^ 80 := by
  have hc : (36 : ℕ) ^ 161 * seedM ^ 21 ≤ 2 ^ 1600 := by
    norm_num [seedM, mDepth]
  have hb : 2 ^ 20 * seedM ^ 42 ≤ seedB := by
    calc
      _ = seedM ^ 2 * (2 * seedM ^ 2) ^ 20 := by ring
      _ ≤ _ := by dsimp [seedB]; gcongr; omega
  calc
    seedA ^ 161 = (36 ^ 161 * seedM ^ 21) * seedM ^ 3360 := by
      dsimp [seedA]
      ring
    _ ≤ 2 ^ 1600 * seedM ^ 3360 := Nat.mul_le_mul_right _ hc
    _ = (2 ^ 20 * seedM ^ 42) ^ 80 := by ring
    _ ≤ seedB ^ 80 := by gcongr

end

end QuantitativeProfile


/- Campaign extension: SeedTrace.lean. -/
namespace QuantitativeProfile

theorem seed_raw_exact : raw 22 seedM seedR 20 =
    ⟨2931850622122931323097112363436495041277884853668360922123438800695600508826005309915132166990314480538583281507914042881159584634756559894197547560406178544526377357642515793627312455095877672347365255476493500284928, 124308939256201422553165614617211687482563646598256545241903956597046561612947668485459744368226802899112493253955981628239989627467367268463135392338564519097387593696898619332752147117721119125450131506822889830200915120881664, 703663942194259606337773034131773825275698519034587381730172968022087447428993451657694183225630321991406486788379151610745611137048142834556372608739015607969038726271238361732770889193867260850814810228688632676352, 13086581019048565985117547358773080202066407381855221426440291448246908975518001347124399995703898619368955207827827561927339000321403008647329492692564315444492108062384760712877034274176582227157694752332757163996661176860672⟩ := by
  have h0 : raw 22 seedM seedR 0 = ⟨22, 1227348109152, 0, 0⟩ := by
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h1 : raw 22 seedM seedR 1 = ⟨1227348109504, 68472261760122612273024, 352, 289894713989265792⟩ := by
    rw [raw, h0]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h2 : raw 22 seedM seedR 2 = ⟨68473131463902149822464, 3819968228466172774847166371900928, 869703779537549440, 16173969890243767066407292416⟩ := by
    rw [raw, h1]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h3 : raw 22 seedM seedR 3 = ⟨3820016751471413609570799990937600, 213114099130885416371151160887181334538319872, 48523005240834723633619036672, 3609094521315097460206082008306451478528⟩ := by
    rw [raw, h2]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h4 : raw 22 seedM seedR 4 = ⟨213124926475569629687074396886339053747757056, 11889326679067770898565113213830802108670534452057792512, 10827344684213315923235999157719209437184, 201357872743569082808730293611028876411720069996544⟩ := by
    rw [raw, h3]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h5 : raw 22 seedM seedR 5 = ⟨11889930756096000429422653479704825545481194472231895040, 663324806822880881916413930886671210991178155305955584069526847488, 604077028229530857540265874023436810660020174102528, 36506831431313444837856234963892369707294671703376231463878656⟩ := by
    rw [raw, h4]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h6 : raw 22 seedM seedR 6 = ⟨663434327507413714348463506462325343775577248048764824319628804096, 37005929593441618605526968877829883857890791303377038891315128598241041317888, 109520684532832432049575575654132784399092742809240250101956608, 2036781269775613873308826063297391960355386636584305634210807926817161216⟩ := by
    rw [raw, h5]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h7 : raw 22 seedM seedR 7 = ⟨37012039947865894687265514785595192137169062963696027776997998211135553667072, 2064856768272269977890646287011550831863930473383083410026245987977275101474434907111424, 6110354424276081738545907765308279278271660318988885682869612894512349184, 349608708455906883253877242432149582401418304299518726606423756257147923893671428096⟩ := by
    rw [raw, h6]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h8 : raw 22 seedM seedR 8 = ⟨2065905594989830337706262233735095517180657802490686973625201703678014516624284780068864, 115195367619620765150115387885080231985807908711317490913963953331286643839525773643732423997915136, 1048826717560359815615946723544685316727329107603563598955715700739415149849872957440, 19505348010452790406709528684120070687343260247131126320029845080913082165786540548853132689408⟩ := by
    rw [raw, h7]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h9 : raw 22 seedM seedR 9 = ⟨115253883696706613041172801874432787937631466766949409132775034444532610344871365531367539877085184, 6429874016718410484011190624275634773069967282804086346349014701903892672506450242604583131133812563551191040, 58516077085847891057413989352555951823558055631918218811081113245966505345591887635115879170048, 3291537480344912739951145446439794558736929847773205615808562080677993271105876906912490361200533670199296⟩ := by
    rw [raw, h8]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h10 : raw 22 seedM seedR 10 = ⟨6439748631003507361378349869273718986737102679349509431467630934270327203432289638843262450719294802595151872, 358713367885976561451952754679211895854790460918836836431588123339471206271701738317509737479829786319555550879514886144, 9874614285096877367159244998084213667135396545423085118616232366434530925839396238679319585482239043960832, 183641946154900958116457619493328968003559582679715170404467384288620452512556470532073024167546313536386926303510528⟩ := by
    rw [raw, h9]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h11 : raw 22 seedM seedR 11 = ⟨359264293827477242422358245319745480667180643454669624812393676395819162577564642984022590773824624471673428499947847680, 20042915957679725387757979985295679899310210769912286145277705620798914768895041933268238028656220687533060097775116448614429229056, 550925941500680970405490640533584812390182535832788380805553056347956305862904666512853293994838152117877620432961536, 30818104458591899322995771356193555969539280490947121001176634272640819023520628616874596833562499852591258064398248798968610816⟩ := by
    rw [raw, h10]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h12 : raw 22 seedM seedR 12 = ⟨20135370276803729786966603178121992492334756302060017803555949520615136048298710420359896106901269639472027863515086051010500624384, 1118165398565710202084343269914524570156585844529079356805963533333062708925563071932654509354782872231921394454949512085283876364370162221056, 92454319124004399208623192826312593024545532147731658278243899816221279403668487091658078245048951938967765739969602396071395328, 1719415218684739406732404245169669418480004080674339260363921671852021897828389093584667320423604648647735938762964292978781189757827284992⟩ := by
    rw [raw, h11]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h13 : raw 22 seedM seedR 13 = ⟨1123323644543930344733400159241499229261977736648458475420015583205513966948890415986187878041812023888284916502790850780461596749811654066176, 62668832610416753428963121732887202621167321741252795091130655630470006613740303140896145353240026229278947485183002524990401227017250262125090680340480, 5158245978220142649056889326974659105391892119379118614052049872451258023327344053533368687029151656363522047841338695177720385441491845120, 288015448826040518789669386729906674284959350079693330015670436440774059883468123079511165748270903671032232389569243390484479715073508457631495225344⟩ := by
    rw [raw, h12]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h14 : raw 22 seedM seedR 14 = ⟨63532878974868053298035015408811325191886187459683518867553002546512578124678930981316925506263844988961036564564268919206508278649856335494971631075328, 3496205028716690668487923710826598793426938190565947255094517849703279275388350497542515033983625296199350832339310052685163309284295808073775298141207466329767936, 864046364451299869071893675924122570718865718430723776422346916042571510938627840420780153023818759682089079381266394216107051632606073369880950734848, 16069132741021194914864388239191788696519195452068974981260297873829974245908524950256369920076143906575908281824409528497153732736168943864236084215667281100800⟩ := by
    rw [raw, h13]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h15 : raw 22 seedM seedR 15 = ⟨3544412427956280316830405728312734406057476979992333179393235045205617238870277322388147039444924536019300077008159866303683073189808447363765707761774014270275584, 197738166775805525657250557998447859453191371159637101599448092395634843162630690896762708812119856353582796902883069307699483782746829579275952270182035275309228525380173824, 48207399239589648342482017486135612630538789426385924298717195502337963481926824845632005461299239819949244668849813618519763905512639289990409620566547940507648, 2690051169511963222996354821549689381134917909938297090326893527916232909124490618940095755987409059006067181302088656983574943428681179311809738250392093247563809050066944⟩ := by
    rw [raw, h14]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h16 : raw 22 seedM seedR 16 = ⟨205808320341052014173540107532383419249599875386371624550306103849675302613294038575507433238292436161719791023098136510780766473891802288248316642753462879240304180854784000, 11031542525256180404036792540700451287937105862592935376904970677183394304691667639956605774318042198851222052562413838861566946810040724859039945063359733085999853984484264839330398208, 8070153565246488516289549533935559796408504226734522950858011454040459450663347678744724426172579808136994120215067203081282691144972708972364372571427603931075655474610176, 150085599711208116702837564396182367838650395638844144349832032637273629292959531188834378262034195622894722181504041668527813747274559190232676091391460390467922146193273938920865792⟩ := by
    rw [raw, h15]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h17 : raw 22 seedM seedR 17 = ⟨11481799327682737879602137460665640111971191757503065816136412767900112854165351075335813526312263717532585197694442620236720572224356666012006809949507180541459026490908953549769539584, 640552674699832783307120663706094338970808280481809503661692213040344742088274372704719591063862361296012774784530131249576305096573170368011273822246262932533137556640943358182302728590635040768, 450256802426557475565344919965188824034085894910130439231442090716718549473683435379207751994221518681363145132028781375153625414315941152966864886147447455459172506424688710439141376, 25119847782085779676790288980706120677052387499011304500310364420563095430477718741468561794630024924254341890246516550048957047544300787776145850656047170658896402870676880705019763861827354624⟩ := by
    rw [raw, h16]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h18 : raw 22 seedM seedR 18 = ⟨715912218229798911580415336721846900372615684770382485282672359360216632666109334595770893653125452489772019935791044062834258162993601886929418030406513403701941653916318424151905276972429737984, 35735671320041374815704058269533124655566629625636150262979233790641795998061745547531123710054009264522578692878305130794278944822597163052699538941442146730641823966278150509440981978914956502968913887232, 75359543529966128273294673015752561401807404288572981620980146319871890577834961891051302589263091193759245151260912813257953066420431518918144208160250471168804097275375065969602548381794697216, 1401513619068648514629082677734279612803663685910404135776879898935408691023174537922215013800661378381262964641468057071910548186253210088808600771723815462883016951244839753691317010521578023651412803584⟩ := by
    rw [raw, h17]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h19 : raw 22 seedM seedR 19 = ⟨39940212188701915851268088888022608881527171089329213626635993251970779820894735283955518104988327698116374826639061620982667294386704923927022971447484281605795089279243736233176027796910175005482028105728, 2228186679928671716759339329304721216002186334633773540393265832673513061397011858257437983764684158547176794719534891270413973497708417059641174951667162936557338631371277431894541565902010411496550445247804867608576, 4204540868660541035564030618489484225960541463693063363656759461328983822832989736424394394934318433593796133760756490188388349564107760874323432506042134875153265312965585723735045817995218502513114218496, 234554647185072070439514126837161467689112258976717548100301849998637185132486991507792806227447344103864414539505718128173541733775155374789697941968882688269763406859505644421623703154350272033417336713658727661568⟩ := by
    rw [raw, h18]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  have h20 : raw 22 seedM seedR 20 = ⟨2931850622122931323097112363436495041277884853668360922123438800695600508826005309915132166990314480538583281507914042881159584634756559894197547560406178544526377357642515793627312455095877672347365255476493500284928, 124308939256201422553165614617211687482563646598256545241903956597046561612947668485459744368226802899112493253955981628239989627467367268463135392338564519097387593696898619332752147117721119125450131506822889830200915120881664, 703663942194259606337773034131773825275698519034587381730172968022087447428993451657694183225630321991406486788379151610745611137048142834556372608739015607969038726271238361732770889193867260850814810228688632676352, 13086581019048565985117547358773080202066407381855221426440291448246908975518001347124399995703898619368955207827827561927339000321403008647329492692564315444492108062384760712877034274176582227157694752332757163996661176860672⟩ := by
    rw [raw, h19]
    norm_num [raw, seedM, seedR, mDepth, rDepth]
  exact h20

theorem seed_raw_bound :
    seedM * (raw 22 seedM seedR 20).s0 ≤ seedA ∧
      (raw 22 seedM seedR 20).s1 ≤ seedA := by
  rw [seed_raw_exact]
  norm_num [seedA, seedM, mDepth]

end QuantitativeProfile


/- Campaign extension: BooleanExtension.lean. -/
namespace QuantitativeProfile

noncomputable section
open scoped Classical
open OAI.Paper320

theorem constructed_majorants {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    ∀ n ≤ d,
      towerSide T.toTournament A.label (constructionBase d M) (d + 1) n false ≤
        (raw (d + 2) M r n).s0 ∧
      towerSide T.toTournament A.label (constructionBase d M) (d + 1) n true ≤
        (raw (d + 2) M r n).s1 ∧
      towerJoint T.toTournament A.label (constructionBase d M) (d + 1) n false ≤
        (raw (d + 2) M r n).j0 ∧
      towerJoint T.toTournament A.label (constructionBase d M) (d + 1) n true ≤
        (raw (d + 2) M r n).j1 := by
  have hstep (n : ℕ) (hn : n < d) := tower_four_recurrences T A (constructionBase d M)
    (d + 1) n (by omega) hr (construction_base_nested d M)
  apply raw_majorizes d (d + 2) M r
    (towerSide T.toTournament A.label (constructionBase d M) (d + 1))
    (towerJoint T.toTournament A.label (constructionBase d M) (d + 1))
  · simpa only [towerSide_zero, constructionBase, baseExtension_same] using initialFamily_side_zero d M
  · simpa only [towerSide_zero, constructionBase, baseExtension_same] using initialFamily_side_one d M
  · simpa only [towerJoint_zero, constructionBase, baseExtension_same] using initialFamily_joint d M false
  · simpa only [towerJoint_zero, constructionBase, baseExtension_same] using initialFamily_joint d M true
  · exact fun n hn => (hstep n hn).2.2.1
  · exact fun n hn => (hstep n hn).1
  · exact fun n hn => (hstep n hn).2.2.2
  · exact fun n hn => (hstep n hn).2.1

theorem actual_uniform_profiles (h : ℕ) (hh : 1 ≤ h)
    (T : RegularTournament (mDepth h)) (A : GoodLabeling T.toTournament (rDepth h))
    (n : ℕ) (hn : n ≤ 2 * h) :
    towerSide T.toTournament A.label (constructionBase (2 * h) (mDepth h))
        (2 * h + 1) n false ≤ 2 * (2 * h + 2) * mDepth h ^ n ∧
    towerSide T.toTournament A.label (constructionBase (2 * h) (mDepth h))
        (2 * h + 1) n true ≤ 2 * (2 * h + 2) * mDepth h ^ (n + 1) := by
  have hr : 0 < rDepth h := by dsimp [rDepth]; positivity
  have hc := constructed_majorants (2 * h) T A hr n hn
  have hb := raw_even_bound h (2 * h + 2) n hh hn
  exact ⟨hc.1.trans hb.1, hc.2.1.trans hb.2⟩

theorem improved_construction_labels (h : ℕ) :
    Nonempty (GoodLabeling (regularCyclicTournament (mDepth h)).toTournament (rDepth h)) := by
  have hp : 0 < 3 ^ (2 * h) := by positivity
  have hM : 3 ≤ mDepth h := by dsimp [mDepth]; omega
  exact goodLabeling_exists hM
    (le_of_eq (depth_parameter_identities h).2.2.symm) _

theorem construction_label_count (h : ℕ) :
    Nat.ceil (Real.sqrt (mDepth h : ℝ)) = rDepth h := by
  have he : (mDepth h : ℝ) = (rDepth h : ℝ) ^ 2 := by
    exact_mod_cast (depth_parameter_identities h).2.2.symm
  rw [he, Real.sqrt_sq (by positivity), Nat.ceil_natCast]

theorem seed_exists :
    ∃ (n : ℕ) (f : (Fin n → Bool) → Bool),
      0 < n ∧ f (fun _ => false) = false ∧ sensitivity f ≤ seedA ∧
        seedB ≤ blockSensitivityAt f (fun _ => false) ∧
        (∃ x y, f x ≠ f y) := by
  obtain ⟨A⟩ := improved_construction_labels 10
  let T := regularCyclicTournament seedM
  have hr : 0 < seedR := by norm_num [seedR, rDepth]
  have hm : 0 < seedM := by norm_num [seedM, mDepth]
  let f := finalWitness 20 T A
  have hc := constructed_majorants 20 T A hr 20 (le_refl _)
  have h0 : ∀ x, terminalPredicate 20 T A x = false →
      sensitivityAt (terminalPredicate 20 T A) x ≤ (raw 22 seedM seedR 20).s0 := by
    intro x hx
    exact (sensitivityAt_le_sideSensitivity _ false 0 x hx).trans hc.1
  have h1 : ∀ x, terminalPredicate 20 T A x = true →
      sensitivityAt (terminalPredicate 20 T A) x ≤ (raw 22 seedM seedR 20).s1 := by
    intro x hx
    exact (sensitivityAt_le_sideSensitivity _ true 0 x hx).trans hc.2.1
  have hs : sensitivity f ≤ seedA := by
    dsimp only [f]
    rw [finalWitness, sensitivity_reindex]
    have ho := sensitivity_orCopies_le (K := Fin seedM) (terminalPredicate 20 T A) _ _ h0 h1
    have hmax : max (seedM * (raw 22 seedM seedR 20).s0)
        (raw 22 seedM seedR 20).s1 ≤ seedA := max_le seed_raw_bound.1 seed_raw_bound.2
    have ho' : sensitivity (finalBoolean 20 T A) ≤
        max (seedM * (raw 22 seedM seedR 20).s0) (raw 22 seedM seedR 20).s1 := by
      simpa only [Fintype.card_fin, finalBoolean] using ho
    exact ho'.trans hmax
  have hb : seedB ≤ blockSensitivityAt f (fun _ => false) :=
    finalWitness_blockSensitivity 20 T A hr
  have hbpos : 0 < seedB := by dsimp [seedB]; positivity
  exact ⟨_, f, constructionDimension_pos hm hr, finalWitness_zero 20 T A hr,
    hs, hb, nonconstant_of_blockSensitivityAt_pos f _ (hbpos.trans_le hb)⟩

set_option maxRecDepth 8192 in
theorem rational_exponent_of_integer {a b : ℕ} (h : a ^ 161 ≤ b ^ 80) :
    (a : ℝ) ^ ((161 : ℝ) / 80) ≤ (b : ℝ) := by
  have hr : (a : ℝ) ^ 161 ≤ (b : ℝ) ^ 80 := by exact_mod_cast h
  have ht := Real.rpow_le_rpow (by positivity : 0 ≤ (a : ℝ) ^ 161) hr
    (by norm_num : 0 ≤ (1 : ℝ) / 80)
  rw [← Real.rpow_natCast_mul (by positivity : 0 ≤ (a : ℝ)),
    ← Real.rpow_natCast_mul (by positivity : 0 ≤ (b : ℝ))] at ht
  norm_num at ht
  exact ht

theorem infinite_family_161_80 :
    ∃ N : ℕ, 0 < N ∧
      ∃ (n : ℕ → ℕ) (F : ∀ m : ℕ, (Fin (n m) → Bool) → Bool),
        (∀ m : ℕ, n m = N ^ m ∧ 0 < n m ∧
          F m (fun _ => false) = false ∧
          (∃ x y, F m x ≠ F m y) ∧
          (sensitivity (F m) : ℝ) ^ ((161 : ℝ) / 80) ≤
            (blockSensitivityAt (F m) (fun _ => false) : ℝ)) ∧
        Filter.Tendsto
          (fun m : ℕ => (blockSensitivityAt (F m) (fun _ => false) : ℝ))
          Filter.atTop Filter.atTop := by
  obtain ⟨N, f, hN, hf, hs, hb, _⟩ := seed_exists
  have hB : 1 < seedB := by norm_num [seedB, seedM, mDepth]
  have hpos : 0 < blockSensitivityAt f (fun _ => false) :=
    (by omega : 0 < seedB).trans_le hb
  have hs' (m : ℕ) : sensitivity (iterateFin f m) ≤ seedA ^ m := by
    exact (sensitivity_iterateFin_le f m).trans (by gcongr)
  have hb' (m : ℕ) : seedB ^ m ≤ blockSensitivityAt (iterateFin f m) (fun _ => false) := by
    exact (show seedB ^ m ≤ blockSensitivityAt f (fun _ => false) ^ m by gcongr).trans
      (blockSensitivityAt_iterateFin_zero f hf m)
  have hpower (m : ℕ) :
      sensitivity (iterateFin f m) ^ 161 ≤
        blockSensitivityAt (iterateFin f m) (fun _ => false) ^ 80 := by
    calc
      _ ≤ (seedA ^ m) ^ 161 := by gcongr; exact hs' m
      _ = (seedA ^ 161) ^ m := by rw [← pow_mul, ← pow_mul, Nat.mul_comm m 161]
      _ ≤ (seedB ^ 80) ^ m := Nat.pow_le_pow_left seed_integer_exponent m
      _ = (seedB ^ m) ^ 80 := by rw [← pow_mul, ← pow_mul, Nat.mul_comm 80 m]
      _ ≤ _ := by gcongr; exact hb' m
  have hlimit : Filter.Tendsto
      (fun m : ℕ => (blockSensitivityAt (iterateFin f m) (fun _ => false) : ℝ))
      Filter.atTop Filter.atTop := by
    apply Filter.tendsto_atTop_mono
      (fun m => (show (seedB : ℝ) ^ m ≤
        (blockSensitivityAt (iterateFin f m) (fun _ => false) : ℝ) by exact_mod_cast hb' m))
    exact tendsto_pow_atTop_atTop_of_one_lt (by exact_mod_cast hB)
  refine ⟨N, hN, (fun m => Fintype.card (Fin N) ^ m), (fun m => iterateFin f m),
    ?_, hlimit⟩
  intro m
  refine ⟨by simp, by simpa using pow_pos hN m, iterateFin_zero f hf m,
    iterateFin_nonconstant f hf hpos m, rational_exponent_of_integer (hpower m)⟩

end

end QuantitativeProfile

#print axioms QuantitativeProfile.uniform_profiles
#print axioms QuantitativeProfile.actual_uniform_profiles
#print axioms QuantitativeProfile.seed_exists
#print axioms QuantitativeProfile.infinite_family_161_80

