import Mathlib

namespace SpecifiedAction

section SplitInflation

variable {R A B C D E : Type*} [CommRing R]
  [AddCommGroup A] [Module R A] [AddCommGroup B] [Module R B]
  [AddCommGroup C] [Module R C] [AddCommGroup D] [Module R D]
  [AddCommGroup E] [Module R E]

theorem split_surjective_right_inverse
    (inf : A →ₗ[R] B) (res : B →ₗ[R] A)
    (left : ∀ a, res (inf a) = a) (onto : Function.Surjective inf) :
    ∀ b, inf (res b) = b := by
  intro b
  obtain ⟨a, rfl⟩ := onto b
  rw [left]

theorem split_inflation_pullback
    (inf : A →ₗ[R] B) (res : B →ₗ[R] A)
    (left : ∀ a, res (inf a) = a) (onto : Function.Surjective inf)
    (pullB : B →ₗ[R] C) (pullA : A →ₗ[R] C)
    (compatible : ∀ a, pullB (inf a) = pullA a) (b : B) :
    pullB b = pullA (res b) := by
  calc
    pullB b = pullB (inf (res b)) :=
      congrArg pullB (split_surjective_right_inverse inf res left onto b).symm
    _ = pullA (res b) := compatible _

theorem specified_pullback_transport
    (fromP : D →ₗ[R] E) (fromJ : C →ₗ[R] E)
    (pull : E →ₗ[R] B) (block : C →ₗ[R] A) (q : A →ₗ[R] B)
    (factor : ∀ c, pull (fromJ c) = q (block c))
    (cP : D) (cJ : C) (same : fromP cP = fromJ cJ) :
    pull (fromP cP) = q (block cJ) := by
  rw [same, factor]

end SplitInflation

section PrimaryFactors

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

theorem bezout_projector (u v a b : R)
    (bezout : u * a + v * b = 1) (annihilation : a * b = 0) :
    (v * b) ^ 2 = v * b := by
  linear_combination (v * b) * bezout - (u * v) * annihilation

theorem projector_annihilated (v a b : R)
    (annihilation : a * b = 0) : a * (v * b) = 0 := by
  calc
    a * (v * b) = v * (a * b) := by ring
    _ = 0 := by rw [annihilation, mul_zero]

theorem projector_on_a_primary (u v a b : R)
    (bezout : u * a + v * b = 1) (m : M) (ha : a • m = 0) :
    (v * b) • m = m := by
  have h := congrArg (fun r : R => r • m) bezout
  simpa only [add_smul, mul_smul, ha, smul_zero, zero_add, one_smul] using h

theorem projector_on_other_primary (v b : R)
    (m : M) (hb : b • m = 0) : (v * b) • m = 0 := by
  rw [mul_smul, hb, smul_zero]

theorem projector_idempotent (u v a b : R)
    (bezout : u * a + v * b = 1) (annihilation : a * b = 0) (m : M) :
    (v * b) • ((v * b) • m) = (v * b) • m := by
  have h := congrArg (fun r : R => r • m)
    (bezout_projector u v a b bezout annihilation)
  simpa only [pow_two, mul_smul] using h

end PrimaryFactors

def weightTwoParameter (x z : ℤ) : ℚ :=
  (x : ℚ) - ((z : ℚ) - (x : ℚ) / 25) / (1 - 1 / 25)

theorem weight_two_parameter (x z : ℤ) :
    weightTwoParameter x z = (25 / 24 : ℚ) * ((x : ℚ) - (z : ℚ)) := by
  unfold weightTwoParameter
  ring

theorem parameter_change_lift (x z b : ℤ) :
    weightTwoParameter (x - b) (z - b) = weightTwoParameter x z := by
  simp only [weight_two_parameter, Int.cast_sub]
  ring

theorem parameter_image (q : ℚ) :
    (∃ x z : ℤ, weightTwoParameter x z = q) ↔
      ∃ n : ℤ, q = (25 / 24 : ℚ) * (n : ℚ) := by
  constructor
  · rintro ⟨x, z, h⟩
    refine ⟨x - z, ?_⟩
    rw [← h, weight_two_parameter, Int.cast_sub]
  · rintro ⟨n, h⟩
    refine ⟨n, 0, ?_⟩
    rw [weight_two_parameter]
    simpa using h.symm

theorem primitive_parameter :
    weightTwoParameter 1 0 = (25 / 24 : ℚ) := by
  norm_num [weight_two_parameter]

theorem filtered_extension_nonsplit :
    ¬ ∃ b : ZMod 5, 1 - b = 0 ∧ -b = 0 := by
  rintro ⟨b, h1, h0⟩
  have hz : b = 0 := neg_eq_zero.mp h0
  have h : (1 : ZMod 5) = 0 := by simpa [hz] using h1
  exact (by decide : (1 : ZMod 5) ≠ 0) h

theorem rank_two_constants :
    (24 : ZMod 5) ≠ 0 ∧
    ((2 : ZMod 5) + 4 * 2 ^ 2 + 4 * 2 ^ 3 + 2 ^ 4) = 1 ∧
    ((1 : ZMod 5) - 2) ≠ 0 ∧
    ((2 : ZMod 5) * 3 = 1) ∧ ((2 : ZMod 5) ^ 2 * 4 = 1) := by
  decide

end SpecifiedAction
