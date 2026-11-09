/-!
# A Lean 4 kernel check of the logical composition in the Problem 4.8 counterexample

This file formalizes the exact implication used in the proof:

1. knot surgery on `E(2) # (S² × S²)` is diffeomorphic to
   `E(2)_K # (S² × S²)` by locality of the disjoint connected sum;
2. Baykur's one-stabilization theorem identifies the latter with
   `E(2) # (S² × S²)` for every knot `K`;
3. the two resulting identifications compose to a diffeomorphism between
   the surgeries for `T(2,3)` and `T(2,5)`.

The differential-topology statements are explicit hypotheses of the final
theorem.  Thus Lean checks the logical assembly without adding axioms, while
the statement-fidelity document identifies the published inputs that those
hypotheses encode.
-/

namespace Problem48

/-- The four knot labels needed to distinguish the two knots and their mirrors. -/
inductive Knot where
  | T23
  | T25
  | mirrorT23
  | mirrorT25
  deriving DecidableEq, Repr

/-- Mirroring on the four named knot labels. -/
def mirror : Knot → Knot
  | .T23 => .mirrorT23
  | .T25 => .mirrorT25
  | .mirrorT23 => .T23
  | .mirrorT25 => .T25

theorem T23_ne_T25 : Knot.T23 ≠ Knot.T25 := by decide
theorem T23_ne_mirror_T25 : Knot.T23 ≠ mirror Knot.T25 := by decide

/-- A syntax of the four-manifolds occurring in the argument. -/
inductive FourManifold where
  | E2
  | S2xS2
  | connectedSum (left right : FourManifold)
  | knotSurgery (ambient : FourManifold) (knot : Knot)
  deriving DecidableEq, Repr

/-- The stabilized ambient manifold used in the counterexample. -/
def X : FourManifold := .connectedSum .E2 .S2xS2

/-- The abstract equivalence-relation operations used for diffeomorphisms. -/
structure DiffeomorphismCalculus where
  rel : FourManifold → FourManifold → Prop
  symm {M N : FourManifold} : rel M N → rel N M
  trans {M N P : FourManifold} : rel M N → rel N P → rel M P

/-- The full logical witness for the negation of the general Problem 4.8 claim. -/
structure CounterexampleWitness
    (Prime : Knot → Prop)
    (AmbientAdmissible : FourManifold → Prop)
    (Diffeomorphic : FourManifold → FourManifold → Prop) where
  K1 : Knot
  K2 : Knot
  ambient : AmbientAdmissible X
  K1_prime : Prime K1
  K2_prime : Prime K2
  knots_distinct : K1 ≠ K2
  not_mirrors : K1 ≠ mirror K2
  surgeries_diffeomorphic :
    Diffeomorphic (.knotSurgery X K1) (.knotSurgery X K2)

/--
Kernel-checked logical composition of the counterexample.

The hypotheses `ambient_X`, `locality`, and `stabilization` are the precise
places where the source-backed 4-manifold mathematics enters.
-/
theorem problem48_counterexample
    (Prime : Knot → Prop)
    (AmbientAdmissible : FourManifold → Prop)
    (D : DiffeomorphismCalculus)
    (prime_T23 : Prime .T23)
    (prime_T25 : Prime .T25)
    (ambient_X : AmbientAdmissible X)
    (locality : ∀ K : Knot,
      D.rel
        (.knotSurgery X K)
        (.connectedSum (.knotSurgery .E2 K) .S2xS2))
    (stabilization : ∀ K : Knot,
      D.rel
        (.connectedSum (.knotSurgery .E2 K) .S2xS2)
        X) :
    ∃ witness : CounterexampleWitness Prime AmbientAdmissible D.rel,
      witness.K1 = .T23 ∧ witness.K2 = .T25 := by
  have surgeryToX (K : Knot) : D.rel (.knotSurgery X K) X :=
    D.trans (locality K) (stabilization K)
  have surgeriesDiffeomorphic :
      D.rel (.knotSurgery X .T23) (.knotSurgery X .T25) :=
    D.trans (surgeryToX .T23) (D.symm (surgeryToX .T25))
  let witness : CounterexampleWitness Prime AmbientAdmissible D.rel := {
    K1 := .T23
    K2 := .T25
    ambient := ambient_X
    K1_prime := prime_T23
    K2_prime := prime_T25
    knots_distinct := T23_ne_T25
    not_mirrors := T23_ne_mirror_T25
    surgeries_diffeomorphic := surgeriesDiffeomorphic
  }
  exact ⟨witness, rfl, rfl⟩

#check problem48_counterexample
#print axioms problem48_counterexample

end Problem48
