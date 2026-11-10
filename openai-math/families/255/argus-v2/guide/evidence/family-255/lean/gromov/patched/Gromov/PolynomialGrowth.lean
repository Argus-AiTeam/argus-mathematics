module

public import Mathlib

/-! # Polynomial growth of Cayley balls

Cayley balls consist of products of at most a given number of generators or
inverse generators. Their cardinalities define the growth function.
-/

public section
namespace FormalConjecturesCheck
variable {G : Type*} [Group G]

/-! The growth conventions follow the `formal-conjectures` library. -/

/-- The `CayleyBall` is the ball of radius `n` in the Cayley graph of a group `G` with generating
set `S`. -/
@[expose]
def CayleyBall (S : Set G) (n : ℕ) : Set G :=
  {g : G | ∃ (l : List G), l.length ≤ n ∧ (∀ s ∈ l, s ∈ S ∨ s⁻¹ ∈ S) ∧ l.prod = g}

/-- The `GrowthFunction` of a group `G` with respect to a set `S` counts the number of group
elements that can be reached by words of length at most `n` in `S`. -/
@[expose]
noncomputable def GrowthFunction (S : Set G) (n : ℕ) : ℕ :=
  (CayleyBall S n).ncard

/-- A group has polynomial growth if there exists a finite generating set whose growth function is
bounded above by a polynomial. -/
@[expose]
def HasPolynomialGrowth (G : Type*) [Group G] : Prop :=
  ∃ (S : Set G), Set.Finite S ∧ Subgroup.closure S = ⊤ ∧
    ∃ (C : ℝ) (d : ℕ), C > 0 ∧
    ∀ n > 0, (GrowthFunction S n : ℝ) ≤ C * (n : ℝ) ^ d

end FormalConjecturesCheck
