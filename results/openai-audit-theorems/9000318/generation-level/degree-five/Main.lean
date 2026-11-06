import Mathlib.LinearAlgebra.Alternating.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.Dimension.Finite

namespace DegreeFiveKernel

variable {K : Type*} [Field K]

structure UpperBlock where
  kernel : Matrix (Fin 2) (Fin 2) K
  upper : Fin 2 → K
  quotient : K

theorem matrixFiveZero
    (f : (Matrix (Fin 2) (Fin 2) K) [⋀^Fin 5]→ₗ[K] K)
    (x : Fin 5 → Matrix (Fin 2) (Fin 2) K) :
    f x = 0 := by
  apply f.map_linearDependent
  intro independent
  have dimension : Module.finrank K (Matrix (Fin 2) (Fin 2) K) = 4 := by
    simp [Module.finrank_matrix]
  have impossible : 5 ≤ 4 := by
    simpa only [Fintype.card_fin, dimension] using independent.fintype_card_le_finrank
  exact (Nat.not_succ_le_self 4) impossible

theorem scalarFiveZero
    (f : K [⋀^Fin 5]→ₗ[K] K) (x : Fin 5 → K) :
    f x = 0 := by
  apply f.map_linearDependent
  intro independent
  have impossible : 5 ≤ 1 := by
    simpa using independent.fintype_card_le_finrank
  exact (by decide : ¬ (5 ≤ 1)) impossible

theorem fullParabolicFiveZero
    (kernelForm : (Matrix (Fin 2) (Fin 2) K) [⋀^Fin 5]→ₗ[K] K)
    (quotientForm : K [⋀^Fin 5]→ₗ[K] K)
    (x : Fin 5 → UpperBlock (K := K)) :
    kernelForm (fun i => (x i).kernel) +
      quotientForm (fun i => (x i).quotient) = 0 := by
  rw [matrixFiveZero, scalarFiveZero, add_zero]

theorem reflectGeometricZero
    {A W WC D : Type*} [Zero A] [Zero W] [Zero WC] [Zero D]
    (witt : A → WC) (base : W → WC) (coefficient : W → D)
    (baseInjective : Function.Injective base)
    (wittZero : witt 0 = 0) (baseZero : base 0 = 0)
    (coefficientZero : coefficient 0 = 0)
    (e : A) (a : W) (unitSquare : witt e = base a)
    (geometricZero : e = 0) :
    coefficient a = 0 := by
  have ha : a = 0 := by
    apply baseInjective
    calc
      base a = witt e := unitSquare.symm
      _ = 0 := by rw [geometricZero, wittZero]
      _ = base 0 := baseZero.symm
  rw [ha, coefficientZero]

end DegreeFiveKernel
