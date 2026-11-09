import OAI.LinearAlgebra.CirculantHadamard.BinaryContradiction
import OAI.LinearAlgebra.CirculantHadamard.LocalComparison

namespace Audit9000179

open OAI.CirculantHadamard
open OAI.CirculantHadamard.CyclicRing

theorem odd_square_obstruction (u : ℕ) (hu : 1 < u) (hodd : Odd u) :
    letI : NeZero u := ⟨(lt_trans Nat.zero_lt_one hu).ne'⟩
    ¬ ∃ h : Elem ℤ (4 * u ^ 2),
      (∀ a, h.coeff a = 1 ∨ h.coeff a = -1) ∧
      h * ringStar h = scalar (4 * u ^ 2) ((4 * u ^ 2 : ℕ) : ℤ) := by
  letI : NeZero u := ⟨(lt_trans Nat.zero_lt_one hu).ne'⟩
  rintro ⟨h, hsign, hnorm⟩
  exact binary_sign_norm_impossible hu hodd h hsign hnorm

end Audit9000179

#print axioms Audit9000179.odd_square_obstruction
#print axioms OAI.CirculantHadamard.LocalComparison.local_character_comparison
#print axioms OAI.CirculantHadamard.alternatingProduct_odd_torsion
#print axioms OAI.CirculantHadamard.binary_sign_norm_impossible
