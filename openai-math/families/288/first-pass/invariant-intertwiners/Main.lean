import Mathlib

namespace InvariantIntertwiners

theorem matrix_unit_product {I : Type*} [Fintype I] [DecidableEq I]
    (i j k l : I) :
    Matrix.single i j (1 : ℂ) * Matrix.single k l 1 =
      if j = k then Matrix.single i l 1 else 0 := by
  by_cases h : j = k
  · subst k
    simp
  · simpa [h] using
      (Matrix.single_mul_single_of_ne i j k h (1 : ℂ) :
        Matrix.single i j (1 : ℂ) * Matrix.single k l 1 = 0)

theorem normalized_matrix_unit_trace {I : Type*} [Fintype I] [DecidableEq I]
    (i j : I) :
    Matrix.trace (Matrix.single i j (1 : ℂ)) / (Fintype.card I : ℂ) =
      if i = j then 1 / (Fintype.card I : ℂ) else 0 := by
  by_cases h : i = j
  · subst j
    simp
  · simp [h, Matrix.trace_single_eq_of_ne i j (1 : ℂ) h]

theorem probe_successor_unique {S I : Type*} [Fintype I] [DecidableEq I]
    (embed : S → I) (hembed : Function.Injective embed)
    (p q : Equiv.Perm S)
    (hproduct : ∀ i,
      Matrix.single (embed i) (embed (p i)) (1 : ℂ) *
        Matrix.single (embed (q i)) (embed (p (q i))) 1 ≠ 0) :
    p = q := by
  ext i
  apply hembed
  by_contra h
  apply hproduct i
  rw [matrix_unit_product, if_neg h]

theorem cycle_lengths_forced {t n r : ℕ} (lengths : Fin t → ℕ)
    (hroot : 1 ≤ r) (htails : ∀ i, 2 ≤ lengths i)
    (htotal : r + ∑ i, lengths i = n + 1)
    (hthreshold : n + 2 ≤ 2 * (t + 1)) :
    r = 1 ∧ ∀ i, lengths i = 2 := by
  have hsum : 2 * t ≤ ∑ i, lengths i := by
    calc
      2 * t = ∑ _i : Fin t, 2 := by simp [Nat.mul_comm]
      _ ≤ ∑ i, lengths i := Finset.sum_le_sum fun i _ => htails i
  have hr : r = 1 := by omega
  have hs : ∑ i, lengths i = 2 * t := by omega
  have hexpand :
      ∑ i, lengths i = (∑ i, (lengths i - 2)) + 2 * t := by
    calc
      ∑ i, lengths i = ∑ i, ((lengths i - 2) + 2) := by
        apply Finset.sum_congr rfl
        intro i _
        exact (Nat.sub_add_cancel (htails i)).symm
      _ = (∑ i, (lengths i - 2)) + 2 * t := by
        rw [Finset.sum_add_distrib]
        simp [Nat.mul_comm]
  have hzero : ∑ i, (lengths i - 2) = 0 := by omega
  refine ⟨hr, ?_⟩
  intro i
  have hsingle : lengths i - 2 ≤ ∑ j, (lengths j - 2) :=
    Finset.single_le_sum (fun j _ => Nat.zero_le (lengths j - 2))
      (Finset.mem_univ i)
  have hi := htails i
  omega

def partner {P : Type*} (x : P × Bool) : P × Bool :=
  (x.1, !x.2)

theorem partner_involutive {P : Type*} (x : P × Bool) :
    partner (partner x) = x := by
  cases x with
  | mk p b => cases b <;> rfl

theorem partner_ne {P : Type*} (x : P × Bool) : partner x ≠ x := by
  cases x with
  | mk p b => cases b <;> simp [partner]

theorem pool_label_forces_partner {P V : Type*}
    (tag : P → V) (htag : Function.Injective tag)
    (f : P × Bool → P × Bool)
    (hnofix : ∀ x, f x ≠ x)
    (hsupport : ∀ x, tag (f x).1 = tag x.1) :
    f = partner := by
  funext x
  have hp : (f x).1 = x.1 := htag (hsupport x)
  have hb : (f x).2 ≠ x.2 := by
    intro h
    exact hnofix x (Prod.ext hp h)
  change f x = (x.1, !x.2)
  apply Prod.ext
  · exact hp
  · cases hleft : (f x).2 <;> cases hright : x.2 <;> simp_all

theorem pool_assignment_injective {P A : Type*} (a : P → A) :
    Function.Injective (fun p => (p, a p)) := by
  intro p q h
  exact congrArg Prod.fst h

theorem pairing_support_product {P V : Type*}
    [Fintype P] [DecidableEq P] [DecidableEq V]
    (tag : P → V) (htag : Function.Injective tag)
    (f : P × Bool → P × Bool) (hnofix : ∀ x, f x ≠ x) :
    (∏ x : P × Bool, if tag x.1 = tag (f x).1 then (1 : ℂ) else 0) =
      if f = partner then 1 else 0 := by
  classical
  by_cases h : f = partner
  · subst f
    simp [partner]
  · have hnot : ¬ ∀ x, tag x.1 = tag (f x).1 := by
      intro hs
      exact h (pool_label_forces_partner tag htag f hnofix
        (fun x => (hs x).symm))
    push Not at hnot
    obtain ⟨x, hx⟩ := hnot
    rw [if_neg h]
    exact Finset.prod_eq_zero (Finset.mem_univ x) (by simp [hx])

theorem independent_pool_count (s t M : ℕ) :
    Fintype.card ((Fin s → Fin M) × (Fin t → Fin M)) = M ^ (s + t) := by
  simp [pow_add]

theorem nat_pow_ge (N r : ℕ) (hN : 1 ≤ N) (hr : 0 < r) :
    (N : ℝ) ≤ (N : ℝ) ^ r := by
  have hNreal : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hNnonneg : (0 : ℝ) ≤ N := by positivity
  cases r with
  | zero => omega
  | succ s =>
    have hp : (1 : ℝ) ≤ (N : ℝ) ^ s := by
      clear hr
      induction s with
      | zero => simp
      | succ s ih =>
        rw [pow_succ]
        have hmul := mul_le_mul_of_nonneg_right ih hNnonneg
        nlinarith
    calc
      (N : ℝ) = 1 * N := by ring
      _ ≤ (N : ℝ) ^ s * N := mul_le_mul_of_nonneg_right hp hNnonneg
      _ = (N : ℝ) ^ (s + 1) := (pow_succ _ _).symm

theorem unbounded_power_zero (a C : ℝ) (r : ℕ)
    (sizes : ℕ → ℕ) (ha : 0 ≤ a) (hr : 0 < r)
    (hunbounded : ∀ B : ℕ, ∃ j, B ≤ sizes j)
    (hbound : ∀ j, a * (sizes j : ℝ) ^ r ≤ C) :
    a = 0 := by
  by_contra hne
  have hapos : 0 < a := lt_of_le_of_ne ha (Ne.symm hne)
  obtain ⟨N, hN⟩ := exists_nat_gt (max (1 : ℝ) (C / a))
  obtain ⟨j, hj⟩ := hunbounded N
  have hN1 : 1 ≤ N := by
    have : (1 : ℝ) < N := lt_of_le_of_lt (le_max_left _ _) hN
    exact_mod_cast this.le
  have hsize : 1 ≤ sizes j := le_trans hN1 hj
  have hratio : C / a < (sizes j : ℝ) := by
    have hsmall : C / a < (N : ℝ) :=
      lt_of_le_of_lt (le_max_right _ _) hN
    have hlarge : (N : ℝ) ≤ sizes j := by exact_mod_cast hj
    exact lt_of_lt_of_le hsmall hlarge
  have htoo : C < (sizes j : ℝ) * a := (div_lt_iff₀ hapos).mp hratio
  have hp := nat_pow_ge (sizes j) r hsize hr
  have hlow := mul_le_mul_of_nonneg_left hp ha
  have hu := hbound j
  nlinarith

theorem complex_coefficient_zero (coefficient : ℂ) (C : ℝ) (r : ℕ)
    (sizes : ℕ → ℕ) (hr : 0 < r)
    (hunbounded : ∀ B : ℕ, ∃ j, B ≤ sizes j)
    (hbound : ∀ j, ‖coefficient‖ ^ 2 * (sizes j : ℝ) ^ r ≤ C ^ 2) :
    coefficient = 0 := by
  have hz : ‖coefficient‖ ^ 2 = 0 :=
    unbounded_power_zero (‖coefficient‖ ^ 2) (C ^ 2) r sizes
      (sq_nonneg _) hr hunbounded hbound
  have hn := norm_nonneg coefficient
  have hnorm : ‖coefficient‖ = 0 := by nlinarith
  exact norm_eq_zero.mp hnorm

theorem same_side_coefficient_zero (coefficient : ℂ) (C : ℝ) (s t : ℕ)
    (hpositive : 0 < s + t)
    (hbound : ∀ M : ℕ, 1 ≤ M →
      ‖coefficient‖ ^ 2 * (M : ℝ) ^ (s + t) ≤ C ^ 2) :
    coefficient = 0 := by
  apply complex_coefficient_zero coefficient C (s + t) (fun j => j + 1)
    hpositive
  · intro B
    exact ⟨B, by omega⟩
  · intro j
    exact hbound (j + 1) (by omega)

def crossSideEquiv {I : Type*} (q : I → I)
    (hinv : ∀ i, q (q i) = i) (side : I → Bool)
    (hcross : ∀ i, side (q i) = !side i) :
    {i // side i = false} ≃ {i // side i = true} where
  toFun x := ⟨q x, by rw [hcross, x.property]; rfl⟩
  invFun x := ⟨q x, by rw [hcross, x.property]; rfl⟩
  left_inv x := Subtype.ext (hinv x)
  right_inv x := Subtype.ext (hinv x)

theorem cross_pairing_cardinality {I : Type*} [Fintype I]
    (q : I → I) (hinv : ∀ i, q (q i) = i) (side : I → Bool)
    (hcross : ∀ i, side (q i) = !side i) :
    Fintype.card {i // side i = false} =
      Fintype.card {i // side i = true} := by
  exact Fintype.card_congr (crossSideEquiv q hinv side hcross)

end InvariantIntertwiners
