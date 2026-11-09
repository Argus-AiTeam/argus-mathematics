import OAI.GroupTheory.Thompson.FiniteBoundary

set_option autoImplicit false

noncomputable section

open OAI.ThompsonNonamenability

namespace BoundaryAudit

universe u

variable {E : Type u} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

local instance : DecidableEq F := Classical.decEq F

theorem actual_bridge (D : ℕ) (hD : 2 ≤ D) (A : Finset F) (hA : A.Nonempty) :
    let hp : 0 < D := lt_of_lt_of_le (by decide : 0 < 2) hD
    ∃ N : ℕ, ∀ n ≥ N,
      (∀ g ∈ transportClosure (fixedTransportSet hD) A, GlobalAdmissible D n g) ∧
      ∀ f : UnitBall E → UnitBall E,
        (∀ g ∈ A, ∀ i : Fin D,
          globalColor hp f n (.inl i) g =
            f (ballMean hp (fun j => globalColor hp f n (.inr (i, j)) g))) ∧
        (∀ q r : IntervalIndex D,
          StrictlySeparated (familyInterval D q) (familyInterval D r) →
          |realAvg A (globalCorrelation hp f n q r) -
            realAvg A (globalCorrelation hp f n
              (.inl (firstIndex hD)) (.inl (secondIndex hD)))| ≤
            boundaryMax (fixedTransportSet hD) (fixedTransportSet_nonempty hD) A) := by
  dsimp only
  obtain ⟨N, hN⟩ := eventually_global_admissible D
    (transportClosure (fixedTransportSet hD) A)
  refine ⟨N, ?_⟩
  intro n hn
  have hg : ∀ g ∈ A, GlobalAdmissible D n g :=
    fun g hmem => hN n hn g (mem_transportClosure_self _ _ hmem)
  have hhg : ∀ h ∈ fixedTransportSet hD, ∀ g ∈ A,
      GlobalAdmissible D n (h * g) :=
    fun h hh g hmem => hN n hn (h * g) (mem_transportClosure_mul _ _ hh hmem)
  refine ⟨hN n hn, ?_⟩
  intro f
  constructor
  · intro g hmem i
    exact globalColor_parent _ f n g (hg g hmem) i
  · intro q r hqr
    exact separated_correlation_bound hD f n A hA hg hhg q r hqr

theorem boundary_from_level
    (D : ℕ) (hD : 2 ≤ D) (f : UnitBall E → UnitBall E) (L δ : ℝ)
    (hL : 0 < L) (hδ : 0 < δ)
    (hLip : ∀ x y, ‖(f x : E) - f y‖ ≤ L * ‖(x : E) - y‖)
    (hDisp : ∀ x, δ ≤ ‖(f x : E) - x‖)
    (A : Finset F) (hA : A.Nonempty) (n : ℕ)
    (hg : ∀ g ∈ A, GlobalAdmissible D n g)
    (hhg : ∀ h ∈ fixedTransportSet hD, ∀ g ∈ A,
      GlobalAdmissible D n (h * g)) :
    boundaryConstant L δ D ≤
      boundaryMax (fixedTransportSet hD) (fixedTransportSet_nonempty hD) A := by
  have hp : 0 < D := lt_of_lt_of_le (by decide : 0 < 2) hD
  let x : F → Fin D → UnitBall E := fun g i => globalColor hp f n (.inl i) g
  let y : F → Fin D → Fin D → UnitBall E :=
    fun g i j => globalColor hp f n (.inr (i, j)) g
  let α : ℝ := realAvg A (globalCorrelation hp f n
    (.inl (firstIndex hD)) (.inl (secondIndex hD)))
  let η : ℝ := boundaryMax (fixedTransportSet hD) (fixedTransportSet_nonempty hD) A
  apply boundaryConstant_le_of_correlations A hA hD f L δ α η hL hδ hLip hDisp x y
  · intro g hmem i
    exact globalColor_parent hp f n g (hg g hmem) i
  · intro j k hjk
    exact separated_correlation_bound hD f n A hA hg hhg (.inl j) (.inl k)
      (selectedInterval_separated hjk)
  · intro i j k hjk
    exact separated_correlation_bound hD f n A hA hg hhg (.inr (i, j)) (.inr (i, k))
      (selected_siblings_separated i hjk)
  · intro i j k hki
    exact separated_correlation_bound hD f n A hA hg hhg (.inr (i, j)) (.inl k)
      (selected_child_parent_separated i j k hki)

theorem realized_signed_boundary
    (D : ℕ) (hD : 2 ≤ D) (f : UnitBall E → UnitBall E) (L δ : ℝ)
    (hL : 0 < L) (hδ : 0 < δ)
    (hLip : ∀ x y, ‖(f x : E) - f y‖ ≤ L * ‖(x : E) - y‖)
    (hDisp : ∀ x, δ ≤ ‖(f x : E) - x‖) :
    ∀ A : Finset F, A.Nonempty →
      ∃ h ∈ fixedTransportSet hD,
        (δ ^ 2 / L ^ 2 - 4 / (D : ℝ)) / (4 * (1 - 1 / (D : ℝ))) ≤
          boundaryRatio A h := by
  intro A hA
  obtain ⟨N, hN⟩ := actual_bridge (E := E) D hD A hA
  have hc := (hN N le_rfl).1
  have hg : ∀ g ∈ A, GlobalAdmissible D N g :=
    fun g hmem => hc g (mem_transportClosure_self _ _ hmem)
  have hhg : ∀ h ∈ fixedTransportSet hD, ∀ g ∈ A,
      GlobalAdmissible D N (h * g) :=
    fun h hh g hmem => hc (h * g) (mem_transportClosure_mul _ _ hh hmem)
  have hb := boundary_from_level D hD f L δ hL hδ hLip hDisp A hA N hg hhg
  simpa only [boundaryConstant] using
    exists_boundary_ge_of_le_max (fixedTransportSet hD)
      (fixedTransportSet_nonempty hD) A hb

theorem realized_boundary
    (D : ℕ) (hD : 2 ≤ D) (f : UnitBall E → UnitBall E) (L δ : ℝ)
    (hL : 0 < L) (hδ : 0 < δ)
    (hLip : ∀ x y, ‖(f x : E) - f y‖ ≤ L * ‖(x : E) - y‖)
    (hDisp : ∀ x, δ ≤ ‖(f x : E) - x‖)
    (hlarge : 4 * L ^ 2 / δ ^ 2 < (D : ℝ)) :
    (fixedTransportSet hD).Nonempty ∧
      0 < (δ ^ 2 / L ^ 2 - 4 / (D : ℝ)) / (4 * (1 - 1 / (D : ℝ))) ∧
      ∀ A : Finset F, A.Nonempty →
        ∃ h ∈ fixedTransportSet hD,
          (δ ^ 2 / L ^ 2 - 4 / (D : ℝ)) / (4 * (1 - 1 / (D : ℝ))) ≤
            boundaryRatio A h := by
  refine ⟨fixedTransportSet_nonempty hD, ?_,
    realized_signed_boundary D hD f L δ hL hδ hLip hDisp⟩
  simpa only [boundaryConstant] using boundaryConstant_pos hL hδ hD hlarge

end BoundaryAudit

#print axioms BoundaryAudit.actual_bridge
#print axioms BoundaryAudit.realized_signed_boundary
#print axioms BoundaryAudit.realized_boundary

end
