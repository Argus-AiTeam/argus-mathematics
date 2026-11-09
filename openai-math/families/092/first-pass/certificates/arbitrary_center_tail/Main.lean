import Mathlib

open scoped BigOperators
open Finset

namespace ArbitraryCenterTail

variable {I : Type*} [Fintype I] [DecidableEq I]

def incident (P : Finset (I × I)) : Finset I :=
  P.image Prod.fst ∪ P.image Prod.snd

def edges (f : I → Option I) : Finset (I × I) :=
  (univ ×ˢ univ).filter fun e => f e.1 = some e.2

def noDiagonal (f : I → Option I) : Prop :=
  ∀ i, f i ≠ some i

def rightUnique (f : I → Option I) : Prop :=
  ∀ i k j, f i = some j → f k = some j → i = k

def choiceWeight (w : I × I → ℝ) (i : I) : Option I → ℝ
  | none => 1
  | some j => if j = i then 0 else w (i, j)

noncomputable def offChoices : Finset (I → Option I) := by
  classical
  exact univ.filter fun f => noDiagonal f ∧ rightUnique f

def completedTerm (a : I → ℝ) (w : I × I → ℝ) (f : I → Option I) : ℝ :=
  (∏ e ∈ edges f, w e * (a e.1 * a e.2)) *
    ∏ i ∈ univ \ incident (edges f), a i * a i

noncomputable def matchingPolynomial (a : I → ℝ) (w : I × I → ℝ) : ℝ :=
  ∑ f ∈ (offChoices : Finset (I → Option I)),
    (∏ e ∈ edges f, w e * (a e.1 * a e.2)) *
      ∑ L ∈ (univ \ incident (edges f)).powerset,
        ∏ i ∈ L, (a i * a i - 1)

omit [Fintype I] [DecidableEq I] in
theorem diagonal_loop_sum (a : I → ℝ) (U : Finset I) :
    (∑ L ∈ U.powerset, ∏ i ∈ L, (a i * a i - 1)) =
      ∏ i ∈ U, a i * a i := by
  rw [← Finset.prod_add_one]
  simp

omit [Fintype I] in
theorem endpoint_product_le
    (P : Finset (I × I)) (a : I → ℝ) (ha : ∀ i, 1 ≤ a i)
    (hl : Set.InjOn Prod.fst (P : Set (I × I)))
    (hr : Set.InjOn Prod.snd (P : Set (I × I))) :
    (∏ e ∈ P, a e.1 * a e.2) ≤
      ∏ i ∈ incident P, a i * a i := by
  have hnon : ∀ i, 0 ≤ a i := fun i => le_trans zero_le_one (ha i)
  have hleft :
      (∏ i ∈ P.image Prod.fst, a i) ≤ ∏ i ∈ incident P, a i :=
    Finset.prod_le_prod_of_subset_of_one_le
      Finset.subset_union_left (fun i _ => hnon i) (fun i _ _ => ha i)
  have hright :
      (∏ i ∈ P.image Prod.snd, a i) ≤ ∏ i ∈ incident P, a i :=
    Finset.prod_le_prod_of_subset_of_one_le
      Finset.subset_union_right (fun i _ => hnon i) (fun i _ _ => ha i)
  calc
    (∏ e ∈ P, a e.1 * a e.2) =
        (∏ i ∈ P.image Prod.fst, a i) *
          ∏ i ∈ P.image Prod.snd, a i := by
            rw [Finset.prod_mul_distrib, Finset.prod_image hl,
              Finset.prod_image hr]
    _ ≤ (∏ i ∈ incident P, a i) * ∏ i ∈ incident P, a i :=
      mul_le_mul hleft hright (Finset.prod_nonneg fun i _ => hnon i)
        (Finset.prod_nonneg fun i _ => hnon i)
    _ = ∏ i ∈ incident P, a i * a i := by
      rw [Finset.prod_mul_distrib]

theorem normalized_matching_term
    (P : Finset (I × I)) (a : I → ℝ) (w : I × I → ℝ)
    (ha : ∀ i, 1 ≤ a i) (hw : ∀ e, 0 ≤ w e)
    (hl : Set.InjOn Prod.fst (P : Set (I × I)))
    (hr : Set.InjOn Prod.snd (P : Set (I × I))) :
    ((∏ e ∈ P, w e * (a e.1 * a e.2)) *
      ∏ i ∈ univ \ incident P, a i * a i) ≤
        (∏ i, a i * a i) * ∏ e ∈ P, w e := by
  have hnon : ∀ i, 0 ≤ a i := fun i => le_trans zero_le_one (ha i)
  have hend := endpoint_product_le P a ha hl hr
  have hsplit :
      (∏ i ∈ incident P, a i * a i) *
          (∏ i ∈ univ \ incident P, a i * a i) =
        ∏ i, a i * a i := by
    have hu : incident P ∪ (univ \ incident P) = (univ : Finset I) := by
      ext i
      simp only [Finset.mem_union, Finset.mem_sdiff, Finset.mem_univ, true_and]
      tauto
    rw [← Finset.prod_union Finset.disjoint_sdiff, hu]
  rw [Finset.prod_mul_distrib]
  calc
    ((∏ e ∈ P, w e) * (∏ e ∈ P, a e.1 * a e.2)) *
          (∏ i ∈ univ \ incident P, a i * a i) ≤
        ((∏ e ∈ P, w e) * (∏ i ∈ incident P, a i * a i)) *
          (∏ i ∈ univ \ incident P, a i * a i) := by
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left hend (Finset.prod_nonneg fun e _ => hw e))
        (Finset.prod_nonneg fun i _ => mul_nonneg (hnon i) (hnon i))
    _ = (∏ i, a i * a i) * ∏ e ∈ P, w e := by
      rw [mul_assoc, hsplit, mul_comm]

theorem edges_left_unique (f : I → Option I) :
    Set.InjOn Prod.fst (edges f : Set (I × I)) := by
  intro e he g hg h
  have heq : f e.1 = some e.2 := (Finset.mem_filter.mp he).2
  have hgq : f g.1 = some g.2 := (Finset.mem_filter.mp hg).2
  have hs : e.2 = g.2 := Option.some.inj (heq.symm.trans (h ▸ hgq))
  exact Prod.ext h hs

theorem edges_right_unique (f : I → Option I) (hf : rightUnique f) :
    Set.InjOn Prod.snd (edges f : Set (I × I)) := by
  intro e he g hg h
  have heq : f e.1 = some e.2 := (Finset.mem_filter.mp he).2
  have hgq : f g.1 = some g.2 := (Finset.mem_filter.mp hg).2
  have hs : e.1 = g.1 := hf e.1 g.1 e.2 heq (hgq.trans (congrArg some h.symm))
  exact Prod.ext hs h

theorem edge_product_eq_choices
    (f : I → Option I) (hf : noDiagonal f) (w : I × I → ℝ) :
    (∏ e ∈ edges f, w e) = ∏ i, choiceWeight w i (f i) := by
  classical
  simp only [edges, Finset.prod_filter, Finset.prod_product]
  apply Finset.prod_congr rfl
  intro i _
  by_cases hn : f i = none
  · simp [hn, choiceWeight]
  · obtain ⟨j, h⟩ : ∃ j, f i = some j := by
      cases h : f i with
      | none => exact (hn h).elim
      | some j => exact ⟨j, rfl⟩
    have hji : j ≠ i := by
      intro he
      exact hf i (he ▸ h)
    simp [h, choiceWeight, hji]

theorem row_choice_budget
    (A : Finset (I → Option I)) (w : I × I → ℝ) (hw : ∀ e, 0 ≤ w e) :
    (∑ f ∈ A, ∏ i, choiceWeight w i (f i)) ≤
      ∏ i, (1 + ∑ j ∈ univ.erase i, w (i, j)) := by
  have hc : ∀ i o, 0 ≤ choiceWeight w i o := by
    intro i o
    cases o with
    | none => simp [choiceWeight]
    | some j =>
        simp only [choiceWeight]
        split_ifs
        · exact le_rfl
        · exact hw (i, j)
  calc
    (∑ f ∈ A, ∏ i, choiceWeight w i (f i)) ≤
        ∑ f : I → Option I, ∏ i, choiceWeight w i (f i) :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ A)
        (fun f _ _ => Finset.prod_nonneg fun i _ => hc i (f i))
    _ = ∏ i, ∑ o : Option I, choiceWeight w i o :=
      (Fintype.prod_sum _).symm
    _ = ∏ i, (1 + ∑ j ∈ univ.erase i, w (i, j)) := by
      apply Finset.prod_congr rfl
      intro i _
      simp only [Fintype.sum_option, choiceWeight]
      congr 1
      rw [Finset.sum_ite]
      simp [Finset.filter_ne']

theorem self_diagram_product_bound
    (a : I → ℝ) (w : I × I → ℝ)
    (ha : ∀ i, 1 ≤ a i) (hw : ∀ e, 0 ≤ w e) :
    matchingPolynomial a w ≤
      (∏ i, a i * a i) *
        ∏ i, (1 + ∑ j ∈ univ.erase i, w (i, j)) := by
  have hnon : 0 ≤ ∏ i, a i * a i :=
    Finset.prod_nonneg fun i _ =>
      mul_nonneg (le_trans zero_le_one (ha i)) (le_trans zero_le_one (ha i))
  calc
    matchingPolynomial a w =
        ∑ f ∈ (offChoices : Finset (I → Option I)), completedTerm a w f := by
      simp only [matchingPolynomial, completedTerm, diagonal_loop_sum]
    _ ≤ ∑ f ∈ (offChoices : Finset (I → Option I)),
        (∏ i, a i * a i) * ∏ i, choiceWeight w i (f i) := by
      apply Finset.sum_le_sum
      intro f hf
      have hp : noDiagonal f ∧ rightUnique f := by
        simpa only [offChoices, Finset.mem_filter, Finset.mem_univ, true_and] using hf
      simpa only [completedTerm, edge_product_eq_choices f hp.1 w] using
        normalized_matching_term (edges f) a w ha hw
          (edges_left_unique f) (edges_right_unique f hp.2)
    _ = (∏ i, a i * a i) *
        ∑ f ∈ (offChoices : Finset (I → Option I)), ∏ i, choiceWeight w i (f i) := by
      rw [Finset.mul_sum]
    _ ≤ (∏ i, a i * a i) *
        ∏ i, (1 + ∑ j ∈ univ.erase i, w (i, j)) :=
      mul_le_mul_of_nonneg_left (row_choice_budget offChoices w hw) hnon

theorem cross_diagram_product_bound
    {E : Type*} [DecidableEq E] (S : Finset E) (A : Finset (Finset E))
    (h : E → ℝ) (hh : ∀ e, 0 ≤ h e)
    (hA : A ⊆ S.powerset) :
    (∑ P ∈ A, ∏ e ∈ P, h e) ≤ ∏ e ∈ S, (1 + h e) := by
  rw [Finset.prod_one_add]
  exact Finset.sum_le_sum_of_subset_of_nonneg hA
    (fun P _ _ => Finset.prod_nonneg fun e _ => hh e)

theorem nonempty_cross_diagram_bound
    {E : Type*} [DecidableEq E] (S : Finset E) (A : Finset (Finset E))
    (h : E → ℝ) (hh : ∀ e, 0 ≤ h e)
    (hA : A ⊆ S.powerset) (hEmpty : ∅ ∉ A) :
    (∑ P ∈ A, ∏ e ∈ P, h e) ≤ (∏ e ∈ S, (1 + h e)) - 1 := by
  have hsub : insert ∅ A ⊆ S.powerset := by
    intro P hP
    rcases Finset.mem_insert.mp hP with hP | hP
    · subst P; simp
    · exact hA hP
  have hb := cross_diagram_product_bound S (insert ∅ A) h hh hsub
  rw [Finset.sum_insert hEmpty, Finset.prod_empty] at hb
  linarith

theorem thinning_exponent (m d : ℝ) (hm : 0 < m) (hd : m ≤ d) :
    -(m / d) * m + (m / d) ^ 2 * (d - m) / 2 ≤ -(m * m) / (2 * d) := by
  have hdp : 0 < d := lt_of_lt_of_le hm hd
  apply (le_div_iff₀ (by positivity : 0 < 2 * d)).2
  field_simp
  nlinarith [sq_nonneg m, mul_nonneg (le_of_lt hm) (sq_nonneg m)]

end ArbitraryCenterTail
