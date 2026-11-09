import OAI.AlgebraicGeometry.StableCoordinate.CoordinateToQuadric
import OAI.AlgebraicGeometry.StableCoordinate.LiftObstruction
import OAI.AlgebraicGeometry.StableCoordinate.DeterminantNonzero
import OAI.AlgebraicGeometry.StableCoordinate.DeterminantDomain
import OAI.AlgebraicGeometry.StableCoordinate.LeadingLocallyNilpotent
import OAI.AlgebraicGeometry.StableCoordinate.DeterminantFinalStep
import OAI.AlgebraicGeometry.StableCoordinate.VerticalLND
import OAI.AlgebraicGeometry.StableCoordinate.Stabilization

noncomputable section

namespace IndependentStableCore

open OAI.StableCoordinate
open OAI.StableCoordinate.Obstruction

theorem universal_principalization {R : Type*} [CommRing R]
    (a d b c t : R) (hdet : a * c - b * d = 1) :
    Ideal.span ({t - (d*c-a*b*t)^2, b*d-(d*c-a*b*t)*a*b} : Set R) =
      Ideal.span ({a^2*t-d^2} : Set R) := by
  let s := d*c-a*b*t
  let f0 := t-s^2
  let g0 := b*d-s*a*b
  let v := a^2*t-d^2
  let A := c^2-b^2*t
  let r := a^2*(a*c-3*b*d)
  let q := d^2*(3*a*c-b*d)+r*t
  change Ideal.span ({f0, g0} : Set R) = Ideal.span ({v} : Set R)
  have hf : f0 = A*v := by
    calc
      f0 = A*v+t*(1-(a*c-b*d)^2) := by dsimp [f0, A, v, s]; ring
      _ = A*v := by rw [hdet]; ring
  have hg : g0 = b^2*v := by
    calc
      g0 = b^2*v+b*d*(1-(a*c-b*d)) := by dsimp [g0, v, s]; ring
      _ = b^2*v := by rw [hdet]; ring
  have hv : r*f0+q*g0 = v := by
    rw [hf, hg]
    calc
      r*(A*v)+q*(b^2*v) = (a*c-b*d)^3*v := by dsimp [r, q, A]; ring
      _ = v := by rw [hdet]; ring
  apply le_antisymm
  · apply Ideal.span_le.mpr
    intro z hz
    have hvm : v ∈ Ideal.span ({v} : Set R) := Ideal.subset_span (by simp)
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hz
    rcases hz with rfl | rfl
    · rw [hf]
      exact Ideal.mul_mem_left _ A hvm
    · rw [hg]
      exact Ideal.mul_mem_left _ (b^2) hvm
  · apply Ideal.span_le.mpr
    intro z hz
    have hzv : z = v := Set.mem_singleton_iff.mp hz
    subst z
    rw [← hv]
    exact Ideal.add_mem _
      (Ideal.mul_mem_left _ r (Ideal.subset_span (by simp)))
      (Ideal.mul_mem_left _ q (Ideal.subset_span (by simp)))

theorem signed_quadric_identity {R : Type*} [CommRing R] (p s u F J : R) :
    let x := s^2-u^2+p*F
    let y := s+x*(x+u^2)
    let z := s*x+p*J
    let H := x^2*F-(1+2*s*x)*J-p*J^2-u
    x*y-z*(z+1) = p*(H+u) := by
  dsimp
  ring

theorem lower_perturbation_rigidity (k : Type*) [Field k] [CharZero k]
    (W : C k)
    (hW : LeadingComponent.DegreeLE (auxiliaryPiece k) 1 W)
    (D : Derivation k (C k) (C k))
    (hln : IsLocallyNilpotent D)
    (hpres : ∀ (n : ℤ) (x : C k), x ∈ fiberPiece k n → D x ∈ fiberPiece k n)
    (hkill : D (W+vHigh k) = 0) : D = 0 := by
  by_contra hD
  letI : IsDomain (C k) := by
    change IsDomain (DeterminantDomain.DeterminantRing k)
    infer_instance
  letI : CharZero (C k) := Algebra.charZero_of_charZero k (C k)
  obtain ⟨m, hm, hbound, hnil⟩ :=
    LeadingComponent.exists_nonzero_locallyNilpotent_component
      (auxiliaryPiece k) (cX k) auxiliaryWeight (adjoin_range_cX k)
      (cX_mem_auxiliaryPiece k) D hD hln
  let E := LeadingComponent.component (auxiliaryPiece k) D m
  have hprojW : LeadingComponent.proj (auxiliaryPiece k) (2+m) (D W) = 0 :=
    LeadingComponent.degreeLE_map (auxiliaryPiece k) D.toLinearMap hbound hW
      (2+m) (by omega)
  have htop : E (vHigh k) = 0 := by
    have h := congrArg (LeadingComponent.proj (auxiliaryPiece k) (2+m)) hkill
    simp only [map_add, map_zero] at h
    rw [hprojW, zero_add] at h
    exact (LeadingComponent.component_of_mem (auxiliaryPiece k) D m
      (vHigh_mem_auxiliaryPiece k)).trans h
  have hcompatible : ∀ (n : ℤ) (x : C k),
      x ∈ fiberPiece k n → E x ∈ fiberPiece k n := by
    intro n x hx
    exact LeadingComponent.component_preserves_compatible_grading
      (auxiliaryPiece k) (fiberPiece k) (auxiliary_fiber_proj_commute k)
      D m hpres hx
  have hfixed : E (cX k 0) = 0 ∧ E (cX k 1) = 0 ∧ E (cX k 4) = 0 :=
    lnd_fixed_of_difference_of_squares E hnil
      (cX_a_ne_zero k) (cX_u_ne_zero k)
      (au_sub_d_ne_zero k) (au_add_d_ne_zero k) htop
  obtain ⟨ha, hd, hu⟩ := hfixed
  exact hm (DeterminantRing.derivation_eq_zero_of_fixed_base_and_coefficient_mem k E
    ha hd hu hcompatible (VerticalLND.coefficient_mem_baseRange E hnil ha hd hu))

theorem october_rigidity (k : Type*) [Field k] [CharZero k]
    (D : Derivation k (C k) (C k)) (hln : IsLocallyNilpotent D)
    (hpres : ∀ (n : ℤ) (x : C k), x ∈ fiberPiece k n → D x ∈ fiberPiece k n)
    (hv : D (v k) = 0) : D = 0 := by
  refine lower_perturbation_rigidity k (vLow k) ?_ D hln hpres ?_
  · intro j hj
    exact LeadingComponent.proj_of_mem_ne (auxiliaryPiece k)
      (vLow_mem_auxiliaryPiece k) (by omega)
  · simpa only [v_eq_low_add_high] using hv

theorem unrestricted_invariant_exclusion (k : Type*) [Field k] [CharZero k]
    (E : Derivation k (B k) (B k)) (hln : IsLocallyNilpotent E) (hE : E ≠ 0)
    (h : B k) (hmem : h ∈ I k) (hfix : E h = 0) : h = 0 := by
  by_contra hn
  obtain ⟨D, hDln, hD, _, hweights, hv⟩ :=
    lift_invariant E hln hE ⟨h, hmem, hn, hfix⟩
  exact hD (october_rigidity k D hDln hweights hv)

def literalQ : R 4 :=
  MvPolynomial.X 1 ^ 2 - MvPolynomial.X 3 ^ 2 +
    MvPolynomial.X 0 * MvPolynomial.X 2

def literalF : R 4 :=
  MvPolynomial.X 0 - 2*literalQ*
    (literalQ*(MvPolynomial.X 1+MvPolynomial.X 3)+
      MvPolynomial.X 0*MvPolynomial.X 3)

theorem literal_matches : literalF = OAI.StableCoordinate.f := rfl

theorem literal_coordinate_to_invariant
    (hf : IsCoordinate (by decide : 0 < 4) literalF) :
    ∃ E : Derivation ℂ (B ℂ) (B ℂ),
      IsLocallyNilpotent E ∧ E ≠ 0 ∧
      ∃ h : B ℂ, h ∈ I ℂ ∧ h ≠ 0 ∧ E h = 0 := by
  apply CoordinateToQuadric.f_coordinate_produces_quadric_lnd
  simpa only [literal_matches] using hf

theorem literal_noncoordinate :
    ¬ IsCoordinate (by decide : 0 < 4) literalF := by
  intro hf
  obtain ⟨E, hln, hE, h, hmem, hn, hfix⟩ := literal_coordinate_to_invariant hf
  exact hn (unrestricted_invariant_exclusion ℂ E hln hE h hmem hfix)

theorem literal_one_stable : IsOneStableCoordinate literalF := by
  simpa only [literal_matches] using OAI.StableCoordinate.f_isOneStableCoordinate

theorem stable_core_verify :
    (∀ E : Derivation ℂ (B ℂ) (B ℂ), IsLocallyNilpotent E → E ≠ 0 →
      ∀ h : B ℂ, h ∈ I ℂ → E h = 0 → h = 0) ∧
    (IsCoordinate (by decide : 0 < 4) literalF →
      ∃ E : Derivation ℂ (B ℂ) (B ℂ), IsLocallyNilpotent E ∧ E ≠ 0 ∧
        ∃ h : B ℂ, h ∈ I ℂ ∧ h ≠ 0 ∧ E h = 0) ∧
    ¬ IsCoordinate (by decide : 0 < 4) literalF ∧
    IsOneStableCoordinate literalF :=
  ⟨unrestricted_invariant_exclusion ℂ, literal_coordinate_to_invariant,
    literal_noncoordinate, literal_one_stable⟩

#print axioms universal_principalization
#print axioms signed_quadric_identity
#print axioms lower_perturbation_rigidity
#print axioms unrestricted_invariant_exclusion
#print axioms literal_coordinate_to_invariant
#print axioms literal_noncoordinate
#print axioms literal_one_stable
#print axioms stable_core_verify

end IndependentStableCore
