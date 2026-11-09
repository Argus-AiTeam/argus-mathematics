import Mathlib

namespace AntiunitarySwappedQuartet

abbrev Vec6 := Fin 6 → ℂ
abbrev Matrix6 := Matrix (Fin 6) (Fin 6) ℂ

def antiunitary (z3 z4 : ℂ) (v : Vec6) : Vec6 :=
  ![
    star (v 1),
    -star (v 0),
    z3 * star (v 3),
    -z3 * star (v 2),
    z4 * star (v 5),
    -z4 * star (v 4)
  ]

def overlap (v w : Vec6) : ℂ :=
  star (v 0) * w 0 +
  star (v 1) * w 1 +
  star (v 2) * w 2 +
  star (v 3) * w 3 +
  star (v 4) * w 4 +
  star (v 5) * w 5

def antiunitaryImage (z3 z4 : ℂ) (B : Matrix6) : Matrix6 :=
  fun row column => antiunitary z3 z4 (fun k => B k column) row

def mutuallyUnbiased (B C : Matrix6) : Prop :=
  ∀ i j,
    Complex.normSq
      (overlap (fun k => B k i) (fun k => C k j)) = 6

theorem matched_overlap_zero (z3 z4 : ℂ) (v : Vec6) :
    overlap v (antiunitary z3 z4 v) = 0 := by
  simp [overlap, antiunitary]
  ring

theorem no_antiunitary_swapped_mub (z3 z4 : ℂ) (B : Matrix6) :
    ¬ mutuallyUnbiased B (antiunitaryImage z3 z4 B) := by
  intro h
  have diagonal := h 0 0
  have zero_overlap :
      overlap
          (fun k => B k 0)
          (fun k => antiunitaryImage z3 z4 B k 0) = 0 := by
    simpa [antiunitaryImage] using
      matched_overlap_zero z3 z4 (fun k => B k 0)
  rw [zero_overlap] at diagonal
  norm_num at diagonal

end AntiunitarySwappedQuartet
