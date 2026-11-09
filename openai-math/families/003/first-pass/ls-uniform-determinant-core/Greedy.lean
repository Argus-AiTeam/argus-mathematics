import Mathlib

noncomputable section

open Set Submodule
open scoped Classical

namespace LSGenericGreedy

universe u v w

section Greedy

variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι]
variable {V : Type w} [AddCommGroup V] [Module K V]

/-- The actual greedy test uses all earlier candidates, not a preselected basis. -/
def greedySet (row : ι → V) : Set ι :=
  {i | row i ∉ Submodule.span K (row '' Set.Iio i)}

variable [Fintype ι]

theorem linearIndependent_of_not_mem_earlier_span (row : ι → V)
    (h : ∀ i, row i ∉ Submodule.span K (row '' Set.Iio i)) :
    LinearIndependent K row := by
  have aux (s : Finset ι) : LinearIndepOn K row (s : Set ι) := by
    induction s using Finset.induction_on_max with
    | empty => simp
    | insert a s hlt ih =>
      have ha : a ∉ (s : Set ι) := fun has => (lt_irrefl a) (hlt a has)
      rw [Finset.coe_insert, linearIndepOn_insert ha]
      refine ⟨ih, fun hm => h a ?_⟩
      exact (Submodule.span_mono (Set.image_mono fun j hj => hlt j hj)) hm
  apply linearIndepOn_univ_iff.mp
  simpa only [Finset.coe_univ] using aux Finset.univ

theorem greedy_linearIndependent (row : ι → V) :
    LinearIndependent K (fun i : greedySet K row => row i) := by
  apply linearIndependent_of_not_mem_earlier_span
  intro i hi
  apply i.property
  exact (Submodule.span_mono (by
    rintro _ ⟨j, hji, rfl⟩
    exact ⟨j.val, hji, rfl⟩)) hi

theorem row_mem_span_greedy_le (row : ι → V) (i : ι) :
    row i ∈ Submodule.span K (row '' {j | j ∈ greedySet K row ∧ j ≤ i}) := by
  induction i using WellFoundedLT.induction with
  | ind i ih =>
    by_cases hi : i ∈ greedySet K row
    · exact Submodule.subset_span ⟨i, ⟨hi, le_rfl⟩, rfl⟩
    · have hrow : row i ∈ Submodule.span K (row '' Set.Iio i) := by
        simpa [greedySet] using hi
      apply (Submodule.span_le.mpr ?_) hrow
      rintro _ ⟨j, hji, rfl⟩
      exact (Submodule.span_mono (Set.image_mono (by
        intro k hk
        exact ⟨hk.1, hk.2.trans hji.le⟩))) (ih j hji)

theorem greedy_prefix_span (row : ι → V) (i : ι) :
    Submodule.span K (row '' (greedySet K row ∩ Set.Iio i)) =
      Submodule.span K (row '' Set.Iio i) := by
  apply le_antisymm
  · exact Submodule.span_mono (Set.image_mono Set.inter_subset_right)
  · apply Submodule.span_le.mpr
    rintro _ ⟨j, hji, rfl⟩
    exact (Submodule.span_mono (Set.image_mono (by
      intro k hk
      exact ⟨hk.1, hk.2.trans_lt hji⟩))) (row_mem_span_greedy_le K row j)

theorem greedy_span (row : ι → V) :
    Submodule.span K (Set.range (fun i : greedySet K row => row i)) =
      Submodule.span K (Set.range row) := by
  apply le_antisymm
  · apply Submodule.span_mono
    rintro _ ⟨i, rfl⟩
    exact ⟨i.val, rfl⟩
  · apply Submodule.span_le.mpr
    rintro _ ⟨i, rfl⟩
    exact (Submodule.span_mono (by
      rintro _ ⟨j, hj, rfl⟩
      exact ⟨⟨j, hj.1⟩, rfl⟩)) (row_mem_span_greedy_le K row i)

def greedyBasis (row : ι → V)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Module.Basis (greedySet K row) K V :=
  Module.Basis.mk (greedy_linearIndependent K row) (by
    rw [greedy_span K row, hspan])

end Greedy

section SquareRows

variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι] [Fintype ι] {n : ℕ}

theorem greedy_card (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Fintype.card (greedySet K row) = n := by
  have h := Module.finrank_eq_card_basis (greedyBasis K row hspan)
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] using h.symm

/-- Increasing enumeration of precisely the indices passing the greedy test. -/
def greedyEnumeration (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) : Fin n ↪o ι :=
  (monoEquivOfFin (greedySet K row) (greedy_card K row hspan)).toOrderEmbedding.trans
    (OrderEmbedding.subtype _)

theorem greedyEnumeration_range (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Set.range (greedyEnumeration K row hspan) = greedySet K row := by
  let e := monoEquivOfFin (greedySet K row) (greedy_card K row hspan)
  change Set.range (fun k => (e k).val) = greedySet K row
  ext i
  constructor
  · rintro ⟨k, rfl⟩
    exact (e k).property
  · intro hi
    exact ⟨e.symm ⟨i, hi⟩, congrArg Subtype.val (e.apply_symm_apply ⟨i, hi⟩)⟩

theorem greedyEnumeration_linearIndependent (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    LinearIndependent K (row ∘ greedyEnumeration K row hspan) := by
  let e := monoEquivOfFin (greedySet K row) (greedy_card K row hspan)
  change LinearIndependent K ((fun i : greedySet K row => row i) ∘ e)
  exact (greedy_linearIndependent K row).comp e e.injective

theorem greedyEnumeration_span (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Submodule.span K (Set.range (row ∘ greedyEnumeration K row hspan)) = ⊤ := by
  have hrange :
      Set.range (row ∘ greedyEnumeration K row hspan) =
        Set.range (fun i : greedySet K row => row i) := by
    rw [Set.range_comp, greedyEnumeration_range K row hspan]
    exact Set.image_eq_range row (greedySet K row)
  rw [hrange, greedy_span K row, hspan]

theorem greedyEnumeration_det_ne_zero (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Matrix.det (fun i j => row (greedyEnumeration K row hspan i) j) ≠ 0 := by
  have hunit := ((Pi.basisFun K (Fin n)).is_basis_iff_det).mp
    ⟨greedyEnumeration_linearIndependent K row hspan, greedyEnumeration_span K row hspan⟩
  rw [Pi.basisFun_det_apply] at hunit
  have heq : Matrix.of (row ∘ greedyEnumeration K row hspan) =
      (fun i j => row (greedyEnumeration K row hspan i) j) := by
    ext i j
    exact Matrix.of_apply _ i j
  rw [heq] at hunit
  exact hunit.ne_zero

theorem greedyEnumeration_prefix (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    (k : Fin n) (j : ι) (hjk : j < greedyEnumeration K row hspan k) :
    row j ∈ Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio k) := by
  have hm : row j ∈ Submodule.span K
      (row '' (greedySet K row ∩ Set.Iio (greedyEnumeration K row hspan k))) := by
    rw [greedy_prefix_span K row]
    exact Submodule.subset_span ⟨j, hjk, rfl⟩
  apply (Submodule.span_mono ?_) hm
  rintro _ ⟨a, ⟨ha, hak⟩, rfl⟩
  rw [← greedyEnumeration_range K row hspan] at ha
  obtain ⟨l, rfl⟩ := ha
  exact ⟨l, (greedyEnumeration K row hspan).lt_iff_lt.mp hak, rfl⟩

theorem greedyEnumeration_prefix_span (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) (k : Fin n) :
    Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio k) =
      Submodule.span K (row '' Set.Iio (greedyEnumeration K row hspan k)) := by
  apply le_antisymm
  · apply Submodule.span_mono
    rintro _ ⟨j, hjk, rfl⟩
    exact ⟨greedyEnumeration K row hspan j,
      (greedyEnumeration K row hspan).strictMono hjk, rfl⟩
  · apply Submodule.span_le.mpr
    rintro _ ⟨j, hjk, rfl⟩
    exact greedyEnumeration_prefix K row hspan k j hjk

theorem ordered_greedy_construction (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Fintype.card (greedySet K row) = n ∧
    ∃ g : Fin n ↪o ι,
      StrictMono g ∧
      Set.range g = greedySet K row ∧
      LinearIndependent K (row ∘ g) ∧
      Submodule.span K (Set.range (row ∘ g)) = ⊤ ∧
      Matrix.det (fun i j => row (g i) j) ≠ 0 ∧
      ∀ k j, j < g k →
        row j ∈ Submodule.span K ((row ∘ g) '' Set.Iio k) := by
  exact ⟨greedy_card K row hspan, greedyEnumeration K row hspan,
    (greedyEnumeration K row hspan).strictMono,
    greedyEnumeration_range K row hspan,
    greedyEnumeration_linearIndependent K row hspan,
    greedyEnumeration_span K row hspan,
    greedyEnumeration_det_ne_zero K row hspan,
    greedyEnumeration_prefix K row hspan⟩

theorem greedyEnumeration_weight_bound (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    {W : Type*} [Preorder W] (weight : ι → W) (bound : W)
    (hweight : ∀ i, weight i ≤ bound) (k : Fin n) :
    weight (greedyEnumeration K row hspan k) ≤ bound :=
  hweight _

end SquareRows

section TriangularReplacement

variable (K : Type u) [Field K]
variable {ρ : Type v} [LinearOrder ρ] [Fintype ρ] {κ : Type w}

def earlierReplacementCoefficients (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) (i : ρ) :
    Set.Iio i → K :=
  ((Fintype.mem_span_image_iff_exists_fun K (v := A)).mp (h i)).choose

theorem earlierReplacementCoefficients_sum (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) (i : ρ) :
    (∑ j : Set.Iio i, earlierReplacementCoefficients K A B h i j • A j) =
      B i - A i :=
  ((Fintype.mem_span_image_iff_exists_fun K (v := A)).mp (h i)).choose_spec

/-- Extend the derived earlier-row coefficients by zero on and above the diagonal. -/
def replacementCoefficients (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) : Matrix ρ ρ K :=
  fun i j => if hj : j < i then earlierReplacementCoefficients K A B h i ⟨j, hj⟩ else 0

theorem replacementCoefficients_zero (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i))
    (i j : ρ) (hij : i ≤ j) :
    replacementCoefficients K A B h i j = 0 := by
  simp [replacementCoefficients, not_lt.mpr hij]

theorem replacementCoefficients_sum (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) (i : ρ) :
    (∑ j, replacementCoefficients K A B h i j • A j) = B i - A i := by
  calc
    _ = ∑ j : Set.Iio i, earlierReplacementCoefficients K A B h i j • A j := by
      apply Finset.sum_congr_set (Set.Iio i)
      · intro j hj
        change j < i at hj
        simp [replacementCoefficients, hj]
      · intro j hj
        change ¬j < i at hj
        simp [replacementCoefficients, hj]
    _ = B i - A i := earlierReplacementCoefficients_sum K A B h i

theorem replacementCoefficients_mul (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    replacementCoefficients K A B h * A = B - A := by
  ext i k
  have hs := congrFun (replacementCoefficients_sum K A B h i) k
  simpa only [Matrix.mul_apply, Matrix.sub_apply, Finset.sum_apply, Pi.smul_apply,
    smul_eq_mul, Pi.sub_apply] using hs

theorem replacement_factorization (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    B = (1 + replacementCoefficients K A B h) * A := by
  rw [Matrix.add_mul, Matrix.one_mul, replacementCoefficients_mul K A B h]
  abel

theorem exists_strictLowerTriangular_replacement (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    ∃ C : Matrix ρ ρ K, (∀ i j, i ≤ j → C i j = 0) ∧ B = (1 + C) * A := by
  exact ⟨replacementCoefficients K A B h,
    replacementCoefficients_zero K A B h, replacement_factorization K A B h⟩

theorem det_one_add_replacementCoefficients (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    Matrix.det (1 + replacementCoefficients K A B h) = 1 := by
  have htri : (1 + replacementCoefficients K A B h).BlockTriangular OrderDual.toDual := by
    intro i j hij
    have hij' : i < j := hij
    simp [Matrix.add_apply, ne_of_lt hij',
      replacementCoefficients_zero K A B h i j hij'.le]
  rw [Matrix.det_of_lowerTriangular _ htri]
  simp [replacementCoefficients_zero K A B h]

theorem replacement_det (A B : Matrix ρ ρ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    B.det = A.det := by
  rw [replacement_factorization K A B h, Matrix.det_mul,
    det_one_add_replacementCoefficients K A B h, one_mul]

end TriangularReplacement

section CombinedBridge

variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι] [Fintype ι] {n : ℕ}

theorem greedy_replacement_bridge (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    (B : Matrix (Fin n) (Fin n) K)
    (hB : ∀ i, B i - row (greedyEnumeration K row hspan i) ∈
      Submodule.span K (row '' Set.Iio (greedyEnumeration K row hspan i))) :
    ∃ C : Matrix (Fin n) (Fin n) K,
      (∀ i j, i ≤ j → C i j = 0) ∧
      B = (1 + C) * Matrix.of (row ∘ greedyEnumeration K row hspan) ∧
      B.det = Matrix.det (fun i j => row (greedyEnumeration K row hspan i) j) ∧
      B.det ≠ 0 := by
  let A : Matrix (Fin n) (Fin n) K :=
    fun i j => row (greedyEnumeration K row hspan i) j
  have h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i) := by
    intro i
    change B i - row (greedyEnumeration K row hspan i) ∈
      Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio i)
    rw [greedyEnumeration_prefix_span K row hspan]
    exact hB i
  refine ⟨replacementCoefficients K A B h,
    replacementCoefficients_zero K A B h, replacement_factorization K A B h,
    replacement_det K A B h, ?_⟩
  rw [replacement_det K A B h]
  exact greedyEnumeration_det_ne_zero K row hspan

end CombinedBridge

end LSGenericGreedy
