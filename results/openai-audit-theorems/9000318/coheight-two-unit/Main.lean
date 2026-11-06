import Mathlib

namespace CoheightTwo

abbrev Vec (R : Type*) := Fin 4 → R

section RingModel

variable {R : Type*} [CommRing R]

def cup1 (v : Vec R) : Vec R := ![0, v 0, 0, v 2]

def cup3 (v : Vec R) : Vec R := ![0, 0, v 0, -v 1]

def scalarUnit (a : R) : Vec R := ![a, 0, 0, 0]

def cupMap (a : R) (x : Vec R) : Vec R :=
  x 0 • scalarUnit a +
  x 1 • cup1 (scalarUnit a) +
  x 2 • cup3 (scalarUnit a) +
  x 3 • cup1 (cup3 (scalarUnit a))

theorem cup1_sq (v : Vec R) : cup1 (cup1 v) = 0 := by
  ext i
  fin_cases i <;> simp [cup1]

theorem cup3_sq (v : Vec R) : cup3 (cup3 v) = 0 := by
  ext i
  fin_cases i <;> simp [cup3]

theorem cup_anticommute (v : Vec R) :
    cup1 (cup3 v) + cup3 (cup1 v) = 0 := by
  ext i
  fin_cases i <;> simp [cup1, cup3]

theorem cupMap_eq_smul (a : R) (x : Vec R) :
    cupMap a x = a • x := by
  ext i
  fin_cases i <;>
    simp [cupMap, scalarUnit, cup1, cup3, mul_comm]

theorem unit_cupMap_bijective (u : Rˣ) :
    Function.Bijective (cupMap (u : R)) := by
  constructor
  · intro x y h
    have h' := congrArg (fun v : Vec R => ((u⁻¹ : Rˣ) : R) • v) h
    simpa [cupMap_eq_smul, smul_smul] using h'
  · intro y
    refine ⟨((u⁻¹ : Rˣ) : R) • y, ?_⟩
    simp [cupMap_eq_smul, smul_smul]

theorem isUnit_cupMap_bijective (a : R) (ha : IsUnit a) :
    Function.Bijective (cupMap a) := by
  rcases ha with ⟨u, rfl⟩
  exact unit_cupMap_bijective u

end RingModel

section FieldModel

variable {F : Type*} [Field F]

theorem nonzero_cupMap_bijective (a : F) (ha : a ≠ 0) :
    Function.Bijective (cupMap a) := by
  exact isUnit_cupMap_bijective a (isUnit_iff_ne_zero.mpr ha)

variable {W V U : Type*}
  [AddCommGroup W] [Module F W]
  [AddCommGroup V] [Module F V]
  [AddCommGroup U] [Module F U]

theorem exact_of_scalar_homotopy
    (dprev : W →ₗ[F] V) (d : V →ₗ[F] U)
    (h : V →ₗ[F] W) (hnext : U →ₗ[F] V)
    (a : F) (ha : a - 1 ≠ 0)
    (homotopy : ∀ v, dprev (h v) + hnext (d v) = (a - 1) • v) :
    ∀ v, d v = 0 → ∃ w, dprev w = v := by
  intro v hv
  have heq : dprev (h v) = (a - 1) • v := by
    simpa [hv] using homotopy v
  refine ⟨(a - 1)⁻¹ • h v, ?_⟩
  simp [map_smul, heq, smul_smul, ha]

end FieldModel

theorem proper_central_scalars (r : Fin 2) :
    (2 : ZMod 5) ^ (2 - r.val) - 1 ≠ 0 := by
  fin_cases r <;> decide

end CoheightTwo
