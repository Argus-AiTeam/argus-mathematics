import Mathlib

open scoped BigOperators

namespace WeightedTupleCore

section DirectedWitnesses

variable {B P : Type*} [DecidableEq B] [DecidableEq P]

def witnesses (clean : Finset B) (shift : P -> P) (u v : B -> P) : Finset B :=
  clean.filter (fun b => v b = shift (u b))

theorem witnesses_mono (small clean : Finset B) (h : small ⊆ clean)
    (shift : P -> P) (u v : B -> P) :
    witnesses small shift u v ⊆ witnesses clean shift u v := by
  intro b hb
  exact Finset.mem_filter.mpr
    ⟨h (Finset.mem_filter.mp hb).1, (Finset.mem_filter.mp hb).2⟩

theorem witnesses_after_update (clean : Finset B) (b : B)
    (shift : P -> P) (u v : B -> P) (q q' : P) :
    witnesses (clean.erase b) shift (Function.update u b q) (Function.update v b q') =
      witnesses (clean.erase b) shift u v := by
  ext a
  by_cases hab : a = b
  · subst a
    simp [witnesses]
  · simp [witnesses, hab]

theorem directed_edge_preserved (clean : Finset B) (b : B)
    (shift : P -> P) (u v : B -> P) (q q' : P) (threshold : Nat)
    (h : threshold <= (witnesses (clean.erase b) shift u v).card) :
    threshold <=
      (witnesses clean shift (Function.update u b q) (Function.update v b q')).card := by
  calc
    threshold <= (witnesses (clean.erase b) shift u v).card := h
    _ = (witnesses (clean.erase b) shift
        (Function.update u b q) (Function.update v b q')).card := by
      rw [witnesses_after_update]
    _ <= (witnesses clean shift
        (Function.update u b q) (Function.update v b q')).card :=
      Finset.card_le_card (witnesses_mono _ _ (Finset.erase_subset _ _) _ _ _)

theorem no_fixed_point_of_no_two_cycle (shift : P -> P)
    (h : forall q, shift (shift q) ≠ q) (q : P) : shift q ≠ q := by
  intro hq
  apply h q
  rw [hq, hq]

theorem no_loops (clean : Finset B) (shift : P -> P)
    (hshift : forall q, shift (shift q) ≠ q) (u : B -> P) :
    witnesses clean shift u u = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro b hb
  exact no_fixed_point_of_no_two_cycle shift hshift (u b)
    (Finset.mem_filter.mp hb).2.symm

theorem opposite_witnesses_disjoint (clean : Finset B) (shift : P -> P)
    (hshift : forall q, shift (shift q) ≠ q) (u v : B -> P) :
    Disjoint (witnesses clean shift u v) (witnesses clean shift v u) := by
  apply Finset.disjoint_left.mpr
  intro b hb hb'
  have hv := (Finset.mem_filter.mp hb).2
  have hu := (Finset.mem_filter.mp hb').2
  apply hshift (u b)
  rw [← hv, ← hu]

theorem no_opposite_edges (clean : Finset B) (shift : P -> P)
    (hshift : forall q, shift (shift q) ≠ q)
    (u v : B -> P) (threshold : Nat)
    (hsize : clean.card < 2 * threshold)
    (huv : threshold <= (witnesses clean shift u v).card) :
    ¬ threshold <= (witnesses clean shift v u).card := by
  intro hvu
  have hd := opposite_witnesses_disjoint clean shift hshift u v
  have hsub :
      witnesses clean shift u v ∪ witnesses clean shift v u ⊆ clean := by
    intro b hb
    rcases Finset.mem_union.mp hb with hb | hb
    · exact (Finset.mem_filter.mp hb).1
    · exact (Finset.mem_filter.mp hb).1
  have hcard := Finset.card_le_card hsub
  rw [Finset.card_union_of_disjoint hd] at hcard
  omega

end DirectedWitnesses

theorem crossing_transposition_has_larger_gap
    (i j a b : Nat) (hij : i < j) (hab : a < b)
    (hcross : Equiv.swap a b j < Equiv.swap a b i)
    (hother : a ≠ i ∨ b ≠ j) :
    j - i < b - a := by
  simp only [Equiv.swap_apply_def] at hcross
  rcases hother with hai | hbj <;> split_ifs at hcross <;> omega

section Products

variable {A : Type*} [DecidableEq A]

theorem product_domination (new old : Finset A) (hsub : new ⊆ old)
    (weight : A -> ℝ)
    (hzero : forall e, e ∈ old -> 0 <= weight e)
    (hone : forall e, e ∈ old -> weight e <= 1) :
    (∏ e ∈ old, weight e) <= ∏ e ∈ new, weight e :=
  Finset.prod_le_prod_of_subset_of_le_one hsub hzero (fun e he _ => hone e he)

end Products

def concatenate {U Q I : Type*} : ((U × Q) × I) ≃ (U × (Q × I)) :=
  Equiv.prodAssoc U Q I

noncomputable def average {A : Type*} [Fintype A] (f : A -> ℝ) : ℝ :=
  (∑ a, f a) / (Fintype.card A : ℝ)

section Restriction

variable {V Q I : Type*} [Fintype V] [DecidableEq V] [Fintype Q] [Fintype I]
  [Nonempty Q] [Nonempty I]

def prescribed (word : V -> Q) (index : V -> I) : V -> Q × I :=
  fun v => (word v, index v)

theorem prescribed_injective (word : V -> Q) :
    Function.Injective (prescribed (I := I) word) := by
  intro a b hab
  funext v
  exact congrArg Prod.snd (congrFun hab v)

theorem exact_restriction_card (word : V -> Q) :
    Fintype.card (V -> I) * Fintype.card Q ^ Fintype.card V =
      Fintype.card (V -> Q × I) := by
  simp [Fintype.card_fun, Fintype.card_prod, mul_pow, Nat.mul_comm]

theorem restriction_sum (word : V -> Q) (f : (V -> Q × I) -> ℝ)
    (h : forall j, 0 <= f j) :
    (∑ i : V -> I, f (prescribed word i)) <= ∑ j : V -> Q × I, f j := by
  classical
  have hinj : Set.InjOn (prescribed (I := I) word)
      (↑(Finset.univ : Finset (V -> I)) : Set (V -> I)) :=
    (prescribed_injective (I := I) word).injOn
  rw [← Finset.sum_image hinj]
  exact Finset.sum_le_sum_of_subset_of_nonneg
    (Finset.subset_univ _) (fun j _ _ => h j)

theorem restriction_average (word : V -> Q) (f : (V -> Q × I) -> ℝ)
    (h : forall j, 0 <= f j) :
    ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ *
        average (fun i : V -> I => f (prescribed word i)) <= average f := by
  have hden : 0 < (Fintype.card (V -> Q × I) : ℝ) := by
    exact_mod_cast Fintype.card_pos
  have hrewrite :
      ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ *
        average (fun i : V -> I => f (prescribed word i)) =
      (∑ i : V -> I, f (prescribed word i)) /
        (Fintype.card (V -> Q × I) : ℝ) := by
    simp only [average, Fintype.card_fun, Fintype.card_prod,
      Nat.cast_pow, Nat.cast_mul, mul_pow]
    simp [div_eq_mul_inv, mul_comm, mul_left_comm, mul_assoc]
  rw [hrewrite]
  exact div_le_div_of_nonneg_right (restriction_sum word f h) (le_of_lt hden)

theorem average_mono {A : Type*} [Fintype A] (f g : A -> ℝ)
    (h : forall a, f a <= g a) : average f <= average g := by
  exact div_le_div_of_nonneg_right (Finset.sum_le_sum (fun a _ => h a))
    (Nat.cast_nonneg _)

theorem dominated_restriction (word : V -> Q)
    (old : (V -> I) -> ℝ) (new : (V -> Q × I) -> ℝ)
    (hnew : forall j, 0 <= new j)
    (hcompare : forall i, old i <= new (prescribed word i)) :
    ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ * average old <= average new := by
  calc
    ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ * average old <=
        ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ *
          average (fun i : V -> I => new (prescribed word i)) :=
      mul_le_mul_of_nonneg_left (average_mono _ _ hcompare) (by positivity)
    _ <= average new := restriction_average word new hnew

theorem marking_bridge (word : V -> Q)
    (old : (V -> I) -> ℝ) (new : (V -> Q × I) -> ℝ)
    (hnew : forall j, 0 <= new j)
    (hcompare : forall i, old i <= new (prescribed word i))
    (c Qform : ℝ) (hc : 0 <= c)
    (hmarked : c * average new <= Qform) :
    c * ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ * average old <= Qform := by
  calc
    c * ((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ * average old =
        c * (((Fintype.card Q : ℝ) ^ Fintype.card V)⁻¹ * average old) := by ring
    _ <= c * average new :=
      mul_le_mul_of_nonneg_left
        (dominated_restriction word old new hnew hcompare) hc
    _ <= Qform := hmarked

end Restriction

theorem normalized_quadratic_lower (N a squareSum quadratic : ℝ)
    (hN : 0 < N) (h : a * squareSum <= quadratic) :
    (a / N) * (squareSum / N) <= quadratic / N ^ 2 := by
  have h' := div_le_div_of_nonneg_right h (sq_nonneg N)
  simpa [div_eq_mul_inv, pow_two, mul_comm, mul_left_comm, mul_assoc] using h'

theorem paired_nonnegative (defect gain q oldForm newForm D : ℝ)
    (hq : 0 <= q) (hD : 0 <= D)
    (hold : -defect * D <= oldForm)
    (hnew : gain * D <= newForm)
    (hbalance : defect <= q * gain) :
    0 <= oldForm + q * newForm := by
  have h1 := mul_le_mul_of_nonneg_left hnew hq
  have h2 := mul_le_mul_of_nonneg_right hbalance hD
  nlinarith

theorem four_corner_cancellation (c : ℝ) :
    c ^ 4 - 4 * c * c ^ 3 + 6 * c ^ 2 * c ^ 2 -
      4 * c ^ 3 * c + c ^ 4 = 0 := by
  ring

theorem four_corner_error_count :
    (0 + 4 * 1 + 6 * 2 + 4 * 3 + 1 * 4 : Nat) = 32 := by
  norm_num

end WeightedTupleCore
