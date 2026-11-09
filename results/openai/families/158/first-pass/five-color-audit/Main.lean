import OAI.Geometry.PlaneColoring.Five

namespace Audit9000158

theorem no_unrestricted_five_coloring :
    ¬ ∃ c : Complex → Fin 5,
      ∀ z w : Complex, ‖z - w‖ = 1 → c z ≠ c w := by
  simpa only [OAI.EuclideanFiveColor.ProperColoring] using
    OAI.EuclideanFiveColor.no_proper_five_coloring

end Audit9000158

#print axioms Audit9000158.no_unrestricted_five_coloring
