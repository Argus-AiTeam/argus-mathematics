import Mathlib.Data.Real.Basic
import Mathlib.Topology.LocallyFinite
import Mathlib.Topology.MetricSpace.Pseudo.Real
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

def RegularEta (eta : ℝ) : Prop :=
  ∀ x : ℝ, x ^ 2 - eta = 0 → 2 * x ≠ 0

theorem regularEta_iff (eta : ℝ) : RegularEta eta ↔ eta ≠ 0 := by
  constructor
  · intro h hzero
    subst eta
    exact (h 0 (by norm_num)) (by norm_num)
  · intro heta x hx hderiv
    have hxzero : x = 0 := by
      linarith
    subst x
    apply heta
    norm_num at hx
    linarith

def FuRegularSlice : Set ℝ :=
  {eta : ℝ | eta ∈ Set.Icc (-1) 1 ∧ RegularEta eta}

theorem zero_mem_closure_fuRegularSlice : 0 ∈ closure FuRegularSlice := by
  rw [Metric.mem_closure_iff]
  intro epsilon hepsilon
  let d := min (epsilon / 2) (1 / 2)
  have hdpos : 0 < d := by
    dsimp [d]
    exact lt_min (by linarith) (by norm_num)
  have hdlehalf : d ≤ 1 / 2 := by
    dsimp [d]
    exact min_le_right _ _
  have hdleepsilon : d ≤ epsilon / 2 := by
    dsimp [d]
    exact min_le_left _ _
  refine ⟨-d, ?_, ?_⟩
  · constructor
    · constructor <;> linarith
    · rw [regularEta_iff]
      linarith
  · rw [Real.dist_eq]
    norm_num [abs_of_pos hdpos]
    linarith

theorem fuRegularSlice_not_isClosed : ¬IsClosed FuRegularSlice := by
  intro hclosed
  have hzero : 0 ∈ FuRegularSlice := by
    rw [← hclosed.closure_eq]
    exact zero_mem_closure_fuRegularSlice
  have hzero' : 0 ∈ Set.Icc (-1) 1 ∧ RegularEta 0 := by
    simpa [FuRegularSlice] using hzero
  exact (regularEta_iff 0).mp hzero'.2 rfl

theorem fuRegularSlice_eq :
    FuRegularSlice = Set.Icc (-1) 1 \ ({0} : Set ℝ) := by
  ext eta
  simp [FuRegularSlice, regularEta_iff]

theorem no_locallyFinite_closed_cover
    {ι : Type*} (pieces : ι → Set ℝ)
    (hlocal : LocallyFinite pieces)
    (hpiece : ∀ i, IsClosed (pieces i))
    (hcover : ⋃ i, pieces i = FuRegularSlice) :
    False := by
  apply fuRegularSlice_not_isClosed
  rw [← hcover]
  exact hlocal.isClosed_iUnion hpiece
