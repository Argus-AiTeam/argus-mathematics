import Mathlib

open scoped BigOperators

set_option autoImplicit false
set_option maxHeartbeats 0
set_option maxRecDepth 8192

namespace UniversalTensorAudit

def shape (a : Fin 14 → ℝ) : Fin 5 → Fin 5 → ℝ :=
  ![![a 0, a 1, a 2, a 3, a 4],
    ![a 1, a 5, a 6, a 7, a 8],
    ![a 2, a 6, a 9, a 10, a 11],
    ![a 3, a 7, a 10, a 12, a 13],
    ![a 4, a 8, a 11, a 13, -(a 0 + a 5 + a 9 + a 12)]]

def matVec (a : Fin 14 → ℝ) (v : Fin 5 → ℝ) (i : Fin 5) : ℝ :=
  ∑ j : Fin 5, shape a i j * v j

def stfNumerator (a : Fin 14 → ℝ) (v : Fin 5 → ℝ)
    (i j k : Fin 5) : ℝ :=
  7 * (v i * shape a j k + v j * shape a i k + v k * shape a i j) -
    2 * ((if i = j then matVec a v k else 0) +
      (if i = k then matVec a v j else 0) +
      (if j = k then matVec a v i else 0))

def vectorNormSq (v : Fin 5 → ℝ) : ℝ :=
  ∑ i : Fin 5, (v i) ^ 2

def shapeNormSq (a : Fin 14 → ℝ) : ℝ :=
  ∑ i : Fin 5, ∑ j : Fin 5, (shape a i j) ^ 2

def cubicNormSq (a : Fin 14 → ℝ) (v : Fin 5 → ℝ) : ℝ :=
  ∑ i : Fin 5, ∑ j : Fin 5, ∑ k : Fin 5, (stfNumerator a v i j k) ^ 2

theorem shape_symmetric (a : Fin 14 → ℝ) (i j : Fin 5) :
    shape a i j = shape a j i := by
  fin_cases i <;> fin_cases j <;> rfl

theorem shape_trace_zero (a : Fin 14 → ℝ) :
    (∑ i : Fin 5, shape a i i) = 0 := by
  simp [shape, Fin.sum_univ_succ]
  <;> ring

theorem stfNumerator_trace_zero (a : Fin 14 → ℝ) (v : Fin 5 → ℝ) (k : Fin 5) :
    (∑ i : Fin 5, stfNumerator a v i i k) = 0 := by
  fin_cases k <;>
    simp [stfNumerator, matVec, shape, Fin.sum_univ_succ] <;> ring

theorem universal_stf_quartic (a : Fin 14 → ℝ) (v : Fin 5 → ℝ) :
    cubicNormSq a v =
      147 * shapeNormSq a * vectorNormSq v +
      210 * vectorNormSq (matVec a v) := by
  simp [cubicNormSq, shapeNormSq, vectorNormSq, stfNumerator, matVec, shape,
    Fin.sum_univ_succ]
  <;> ring

#print axioms universal_stf_quartic

end UniversalTensorAudit
