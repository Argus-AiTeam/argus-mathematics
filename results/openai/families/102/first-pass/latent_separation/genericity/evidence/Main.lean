import Mathlib

noncomputable section

open scoped BigOperators

namespace LatentGenericity

universe u v w

section BooleanEvaluation

variable {K : Type u} [Field K] {I : Type v} {E : Type w}

def coordinate (point : E → I → Bool) (i : I) : E → K :=
  fun e => if point e i then 1 else 0

def monomial (point : E → I → Bool) : List I → E → K
  | [] => 1
  | i :: m => coordinate point i * monomial point m

def evaluationSpan (point : E → I → Bool) (degree : ℕ) : Submodule K (E → K) :=
  Submodule.span K
    {f | ∃ m : List I, m ≠ [] ∧ m.length ≤ degree ∧ monomial point m = f}

theorem monomial_mem_evaluationSpan (point : E → I → Bool) {degree : ℕ}
    {m : List I} (hne : m ≠ []) (hdegree : m.length ≤ degree) :
    monomial (K := K) point m ∈ evaluationSpan point degree :=
  Submodule.subset_span ⟨m, hne, hdegree, rfl⟩

theorem coordinate_mem_evaluationSpan (point : E → I → Bool) (i : I)
    {degree : ℕ} (hdegree : 1 ≤ degree) :
    coordinate (K := K) point i ∈ evaluationSpan point degree := by
  simpa [monomial] using
    monomial_mem_evaluationSpan (K := K) point (m := [i]) (by simp)
      (by simpa using hdegree)

def multiplyCoordinate (point : E → I → Bool) (i : I) : (E → K) →ₗ[K] (E → K) where
  toFun f := coordinate point i * f
  map_add' f g := by
    ext e
    exact mul_add _ _ _
  map_smul' a f := by
    ext e
    change coordinate point i e * (a * f e) = a * (coordinate point i e * f e)
    ring

theorem coordinate_mul_mem_next (point : E → I → Bool) (i : I)
    {degree : ℕ} {f : E → K} (hf : f ∈ evaluationSpan point degree) :
    coordinate point i * f ∈ evaluationSpan point (degree + 1) := by
  have hmap : evaluationSpan (K := K) point degree ≤
      (evaluationSpan point (degree + 1)).comap (multiplyCoordinate point i) := by
    refine Submodule.span_le.mpr ?_
    rintro f ⟨m, hne, hdegree, rfl⟩
    change monomial point (i :: m) ∈ evaluationSpan point (degree + 1)
    exact monomial_mem_evaluationSpan point (by simp) (by simpa using hdegree)
  exact hmap hf

theorem sandwich_closed_coordinate (point : E → I → Bool) (W : Submodule K (E → K))
    (hthree : evaluationSpan point 3 ≤ W) (htwo : W ≤ evaluationSpan point 2)
    (i : I) {f : E → K} (hf : f ∈ W) :
    coordinate point i * f ∈ W :=
  hthree (coordinate_mul_mem_next point i (htwo hf))

theorem all_positive_monomials_mem (point : E → I → Bool) (W : Submodule K (E → K))
    (hthree : evaluationSpan point 3 ≤ W) (htwo : W ≤ evaluationSpan point 2)
    (m : List I) : m ≠ [] → monomial point m ∈ W := by
  induction m with
  | nil =>
      intro hne
      exact (hne rfl).elim
  | cons i m ih =>
      intro _
      cases m with
      | nil =>
          simpa [monomial] using
            hthree (coordinate_mem_evaluationSpan (K := K) point i (by omega : 1 ≤ 3))
      | cons j m =>
          exact sandwich_closed_coordinate point W hthree htwo i (ih (by simp))

def selector (point : E → I → Bool) (a : E) (i : I) : E → K :=
  if point a i then coordinate point i else 1 - coordinate point i

theorem selector_self (point : E → I → Bool) (a : E) (i : I) :
    selector (K := K) point a i a = 1 := by
  cases h : point a i <;> simp [selector, coordinate, h]

theorem selector_of_ne (point : E → I → Bool) (a b : E) (i : I)
    (h : point b i ≠ point a i) :
    selector (K := K) point a i b = 0 := by
  cases ha : point a i <;> cases hb : point b i <;>
    simp_all [selector, coordinate]

theorem selector_mul_mem (point : E → I → Bool) (W : Submodule K (E → K))
    (hclosed : ∀ i f, f ∈ W → coordinate point i * f ∈ W)
    (a : E) (i : I) {f : E → K} (hf : f ∈ W) :
    selector point a i * f ∈ W := by
  cases h : point a i with
  | false =>
      simpa [selector, h, sub_mul] using W.sub_mem hf (hclosed i f hf)
  | true =>
      simpa [selector, h] using hclosed i f hf

theorem selector_product_mul_mem (point : E → I → Bool) (W : Submodule K (E → K))
    (hclosed : ∀ i f, f ∈ W → coordinate point i * f ∈ W)
    (a : E) (s : Finset I) {f : E → K} (hf : f ∈ W) :
    (∏ i ∈ s, selector point a i) * f ∈ W := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using hf
  | @insert i s hnot ih =>
      rw [Finset.prod_insert hnot, mul_assoc]
      exact selector_mul_mem point W hclosed a i ih

theorem point_indicator_mem [Fintype I] [DecidableEq E] (point : E → I → Bool)
    (hinjective : Function.Injective point) (hnonzero : ∀ a, ∃ i, point a i = true)
    (W : Submodule K (E → K))
    (hcoordinates : ∀ i, coordinate point i ∈ W)
    (hclosed : ∀ i f, f ∈ W → coordinate point i * f ∈ W) (a : E) :
    Pi.single a (1 : K) ∈ W := by
  classical
  obtain ⟨i, hi⟩ := hnonzero a
  have hmem := selector_product_mul_mem point W hclosed a Finset.univ (hcoordinates i)
  have heq : (∏ j : I, selector (K := K) point a j) * coordinate point i =
      (Pi.single a (1 : K) : E → K) := by
    ext b
    by_cases hba : b = a
    · subst b
      simp [Finset.prod_apply, selector_self, coordinate, hi]
    · have hpoint : point b ≠ point a := fun h => hba (hinjective h)
      obtain ⟨j, hj⟩ := Function.ne_iff.mp hpoint
      have hzero : (∏ k : I, selector (K := K) point a k b) = 0 :=
        Finset.prod_eq_zero (Finset.mem_univ j) (selector_of_ne point a b j hj)
      simp [Finset.prod_apply, hzero, hba]
  exact heq ▸ hmem

theorem boolean_evaluation_obstruction [Fintype I] [Fintype E]
    (point : E → I → Bool) (hinjective : Function.Injective point)
    (hnonzero : ∀ a, ∃ i, point a i = true) (W : Submodule K (E → K))
    (hthree : evaluationSpan point 3 ≤ W) (htwo : W ≤ evaluationSpan point 2) :
    W = ⊤ := by
  classical
  have hcoordinates : ∀ i, coordinate (K := K) point i ∈ W :=
    fun i => hthree (coordinate_mem_evaluationSpan point i (by omega : 1 ≤ 3))
  have hclosed : ∀ i f, f ∈ W → coordinate point i * f ∈ W :=
    fun i _ hf => sandwich_closed_coordinate point W hthree htwo i hf
  have hindicators : ∀ a : E, Pi.single a (1 : K) ∈ W :=
    point_indicator_mem point hinjective hnonzero W hcoordinates hclosed
  apply top_unique
  intro f _
  have hdecomposition : f = ∑ a : E, f a • Pi.single a (1 : K) := by
    ext b
    simp [Pi.single_apply]
  rw [hdecomposition]
  exact W.sum_mem fun a _ => W.smul_mem (f a) (hindicators a)

theorem generator_card_lower_bound [Fintype I] [Fintype E]
    {J : Type*} [Fintype J] (point : E → I → Bool)
    (hinjective : Function.Injective point) (hnonzero : ∀ a, ∃ i, point a i = true)
    (W : Submodule K (E → K))
    (hthree : evaluationSpan point 3 ≤ W) (htwo : W ≤ evaluationSpan point 2)
    (columns : J → E → K) (hspans : W ≤ Submodule.span K (Set.range columns)) :
    Fintype.card E ≤ Fintype.card J := by
  have htop : Submodule.span K (Set.range columns) = ⊤ := by
    apply top_unique
    simpa [boolean_evaluation_obstruction point hinjective hnonzero W hthree htwo] using
      hspans
  simpa using finrank_le_of_span_eq_top (R := K) htop

def cubicEvaluation (point : E → I → Bool) (indices : I × I × I) : E → K :=
  monomial point [indices.1, indices.2.1, indices.2.2]

theorem coordinate_mul_self (point : E → I → Bool) (i : I) :
    coordinate (K := K) point i * coordinate point i = coordinate point i := by
  ext e
  cases h : point e i <;> simp [coordinate, h]

theorem evaluationSpan_three_eq_cubic_span (point : E → I → Bool) :
    evaluationSpan (K := K) point 3 =
      Submodule.span K (Set.range (cubicEvaluation point)) := by
  apply le_antisymm
  · refine Submodule.span_le.mpr ?_
    rintro f ⟨m, hne, hdegree, rfl⟩
    cases m with
    | nil => exact (hne rfl).elim
    | cons i m =>
        cases m with
        | nil =>
            have heq : cubicEvaluation (K := K) point (i, i, i) = monomial point [i] := by
              simp only [cubicEvaluation, monomial, mul_one, coordinate_mul_self]
            rw [← heq]
            exact Submodule.subset_span (Set.mem_range_self _)
        | cons j m =>
            cases m with
            | nil =>
                have heq : cubicEvaluation (K := K) point (i, i, j) =
                    monomial point [i, j] := by
                  simp only [cubicEvaluation, monomial, mul_one]
                  rw [← mul_assoc, coordinate_mul_self]
                rw [← heq]
                exact Submodule.subset_span (Set.mem_range_self _)
            | cons k m =>
                cases m with
                | nil =>
                    exact Submodule.subset_span ⟨(i, j, k), rfl⟩
                | cons l m =>
                    simp only [List.length_cons] at hdegree
                    omega
  · refine Submodule.span_le.mpr ?_
    rintro f ⟨indices, rfl⟩
    exact monomial_mem_evaluationSpan point (by simp) (by simp)

end BooleanEvaluation

section CoefficientExtraction

variable {K : Type*} [Field K] {A : Type*} [Field A] [Algebra K A]
variable {R C E : Type*} [Fintype R] [Fintype C]

def scalarExtend (v : E → K) : E → A :=
  fun e => algebraMap K A (v e)

def radicalCombination (radicals : R → A) (coefficients : R → E → K) : E → A :=
  fun e => ∑ j : R, coefficients j e • radicals j

theorem coefficientwise_extraction (radicals : R → A)
    (hindependent : LinearIndependent K radicals) (coefficients : R → E → K)
    (columns : C → E → K)
    (hmember : radicalCombination radicals coefficients ∈
      Submodule.span A (Set.range (fun j => scalarExtend (A := A) (columns j)))) :
    ∀ j, coefficients j ∈ Submodule.span K (Set.range columns) := by
  classical
  intro j
  let projection : Submodule.span K (Set.range radicals) →ₗ[K] K :=
    (Module.Basis.span hindependent).coord j
  obtain ⟨extract, hextend⟩ := projection.exists_extend
  have hextract : ∀ k, extract (radicals k) = if k = j then 1 else 0 := by
    intro k
    have h := LinearMap.congr_fun hextend
      ⟨radicals k, Submodule.subset_span (Set.mem_range_self k)⟩
    simpa [projection, Module.Basis.coord_apply, Module.Basis.span_repr_eq_single,
      Finsupp.single_apply, eq_comm] using h
  have hscalar : ∀ (a : A) (b : K),
      extract (a * algebraMap K A b) = b * extract a := by
    intro a b
    rw [mul_comm, ← Algebra.smul_def]
    exact extract.map_smul b a
  obtain ⟨weights, hweights⟩ :=
    (Submodule.mem_span_range_iff_exists_fun A).mp hmember
  apply (Submodule.mem_span_range_iff_exists_fun K).mpr
  refine ⟨fun k => extract (weights k), ?_⟩
  ext e
  have hpoint := congrFun hweights e
  simp only [Finset.sum_apply, Pi.smul_apply, scalarExtend, radicalCombination,
    smul_eq_mul] at hpoint
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  calc
    _ = extract (∑ k : C, weights k * algebraMap K A (columns k e)) := by
      simp only [map_sum, hscalar]
      exact Finset.sum_congr rfl fun k _ => mul_comm _ _
    _ = extract (∑ k : R, coefficients k e • radicals k) := congrArg extract hpoint
    _ = coefficients j e := by
      simp [map_sum, map_smul, hextract, smul_eq_mul]

end CoefficientExtraction

theorem cubic_radical_not_in_small_quadratic_column_span
    {K : Type*} [Field K] {A : Type*} [Field A] [Algebra K A]
    {I E C : Type*} [Fintype I] [Fintype E] [Fintype C]
    (point : E → I → Bool) (hinjective : Function.Injective point)
    (hnonzero : ∀ a, ∃ i, point a i = true) (columns : C → E → K)
    (hquadratic : ∀ j, columns j ∈ evaluationSpan point 2)
    (hsmall : Fintype.card C < Fintype.card E) (radicals : I × I × I → A)
    (hindependent : LinearIndependent K radicals) :
    radicalCombination (K := K) radicals (cubicEvaluation point) ∉
      Submodule.span A (Set.range (fun j => scalarExtend (A := A) (columns j))) := by
  intro hmember
  let W : Submodule K (E → K) := Submodule.span K (Set.range columns)
  have hextract := coefficientwise_extraction radicals hindependent
    (cubicEvaluation point) columns hmember
  have hthree : evaluationSpan point 3 ≤ W := by
    rw [evaluationSpan_three_eq_cubic_span]
    refine Submodule.span_le.mpr ?_
    rintro f ⟨indices, rfl⟩
    exact hextract indices
  have htwo : W ≤ evaluationSpan point 2 := by
    refine Submodule.span_le.mpr ?_
    rintro f ⟨j, rfl⟩
    exact hquadratic j
  have hlower := generator_card_lower_bound point hinjective hnonzero W hthree htwo
    columns le_rfl
  omega

end LatentGenericity

#print axioms LatentGenericity.boolean_evaluation_obstruction
#print axioms LatentGenericity.generator_card_lower_bound
#print axioms LatentGenericity.coefficientwise_extraction
#print axioms LatentGenericity.cubic_radical_not_in_small_quadratic_column_span
