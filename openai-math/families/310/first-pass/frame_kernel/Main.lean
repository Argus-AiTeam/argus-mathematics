import Mathlib

open Finset

namespace FrameKernel

variable {Factor Label : Type*} [DecidableEq Factor]

abbrev Monomial (Factor Label : Type*) := Finset Factor × Label
abbrev Input (Factor Label : Type*) := Factor × Monomial Factor Label

def insertFactor (x : Input Factor Label) : Monomial Factor Label :=
  (insert x.1 x.2.1, x.2.2)

def mark (x : Input Factor Label) : (_ : Monomial Factor Label) × Factor :=
  ⟨insertFactor x, x.1⟩

theorem mark_injective_on_fresh :
    Set.InjOn (mark (Factor := Factor) (Label := Label))
      {x | x.1 ∉ x.2.1} := by
  intro x hx y hy h
  rcases x with ⟨p, m, r⟩
  rcases y with ⟨q, n, s⟩
  have hp : p = q := congrArg Sigma.snd h
  subst q
  have hi : insert p m = insert p n :=
    congrArg (fun z => z.1.1) h
  have hr : r = s := congrArg (fun z => z.1.2) h
  have hm : m = n := by
    have he := congrArg (fun t : Finset Factor => t.erase p) hi
    simpa [Finset.erase_insert hx, Finset.erase_insert hy] using he
  subst n
  subst s
  rfl

variable [DecidableEq Label]

theorem weighted_marking
    (inputs : Finset (Input Factor Label))
    (outputs : Finset (Monomial Factor Label))
    (weight : Factor → ℕ)
    (fresh : ∀ x ∈ inputs, x.1 ∉ x.2.1)
    (closed : ∀ x ∈ inputs, insertFactor x ∈ outputs) :
    (∑ x ∈ inputs, weight x.1) ≤
      ∑ m ∈ outputs, ∑ p ∈ m.1, weight p := by
  have hinj : Set.InjOn (mark (Factor := Factor) (Label := Label))
      (↑inputs : Set (Input Factor Label)) := by
    intro x hx y hy h
    exact mark_injective_on_fresh (fresh x hx) (fresh y hy) h
  have hsub : inputs.image mark ⊆ outputs.sigma (fun m => m.1) := by
    intro z hz
    obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hz
    exact Finset.mem_sigma.mpr
      ⟨closed x hx, Finset.mem_insert_self x.1 x.2.1⟩
  calc
    (∑ x ∈ inputs, weight x.1) =
        ∑ z ∈ inputs.image mark, weight z.2 := by
      rw [Finset.sum_image hinj]
      rfl
    _ ≤ ∑ z ∈ outputs.sigma (fun m => m.1), weight z.2 :=
      Finset.sum_le_sum_of_subset hsub
    _ = ∑ m ∈ outputs, ∑ p ∈ m.1, weight p := by
      rw [Finset.sum_sigma]

theorem weighted_capacity
    (inputs : Finset (Input Factor Label))
    (outputs : Finset (Monomial Factor Label))
    (weight : Factor → ℕ) (capacity : ℕ)
    (fresh : ∀ x ∈ inputs, x.1 ∉ x.2.1)
    (closed : ∀ x ∈ inputs, insertFactor x ∈ outputs)
    (bounded : ∀ m ∈ outputs, (∑ p ∈ m.1, weight p) ≤ capacity) :
    (∑ x ∈ inputs, weight x.1) ≤ capacity * outputs.card := by
  calc
    _ ≤ ∑ m ∈ outputs, ∑ p ∈ m.1, weight p :=
      weighted_marking inputs outputs weight fresh closed
    _ ≤ ∑ _m ∈ outputs, capacity := Finset.sum_le_sum bounded
    _ = capacity * outputs.card := by simp [Nat.mul_comm]

theorem homogeneous_relation_bound
    (inputs : Finset (Input Factor Label))
    (outputs : Finset (Monomial Factor Label))
    (weight : Factor → ℕ) (dimension relationDimension : ℕ)
    (fresh : ∀ x ∈ inputs, x.1 ∉ x.2.1)
    (closed : ∀ x ∈ inputs, insertFactor x ∈ outputs)
    (graded : ∀ m ∈ outputs,
      (∑ p ∈ m.1, weight p) + relationDimension = dimension) :
    (∑ x ∈ inputs, weight x.1) ≤
      (dimension - relationDimension) * outputs.card := by
  apply weighted_capacity inputs outputs weight
    (dimension - relationDimension) fresh closed
  intro m hm
  have h := graded m hm
  omega

theorem manuscript_bound
    (inputs : Finset (Input Factor Label))
    (outputs : Finset (Monomial Factor Label))
    (weight : Factor → ℕ) (dimension : ℕ)
    (fresh : ∀ x ∈ inputs, x.1 ∉ x.2.1)
    (closed : ∀ x ∈ inputs, insertFactor x ∈ outputs)
    (graded : ∀ m ∈ outputs, (∑ p ∈ m.1, weight p) + 2 = dimension) :
    (∑ x ∈ inputs, weight x.1) ≤ dimension * outputs.card := by
  exact (homogeneous_relation_bound inputs outputs weight dimension 2
    fresh closed graded).trans
    (Nat.mul_le_mul_right outputs.card (Nat.sub_le dimension 2))

theorem logarithmic_coefficient_step
    (dp dj convolution dc cp : ℚ)
    (identity : dp = dj + convolution + (dc - cp))
    (nonnegative_convolution : 0 ≤ convolution)
    (marked : cp ≤ dc) :
    dj ≤ dp := by
  linarith

end FrameKernel
