import Mathlib

open scoped BigOperators

namespace AdaptivePrimeDeletion

noncomputable def bad (q m : ℤ) : ℚ := if q ∣ m then 1 else 0

theorem bad_nonneg (q m : ℤ) : 0 ≤ bad q m := by
  unfold bad
  split_ifs <;> norm_num

theorem adaptive_edge_bound
    (before after : ℕ) (old new q : ℤ)
    (monotone : after ≤ before)
    (stable : before = after → old = new) :
    bad q new ≤ (before : ℚ) - after + bad q old := by
  classical
  by_cases same : before = after
  · simp [same, stable same]
  · have jump : after + 1 ≤ before := by omega
    have jumpQ : (after : ℚ) + 1 ≤ before := by exact_mod_cast jump
    have nonneg := bad_nonneg q old
    unfold bad
    split_ifs <;> linarith

theorem regular_deletion_step
    {U V : Type*} [Fintype U] [Fintype V]
    (edge : U → V → Prop) [DecidableRel edge]
    (lowerRank : U → ℕ) (upperRank : V → ℕ)
    (lowerMinor : U → ℤ) (upperMinor : V → ℤ)
    (label : U → V → ℤ) (c d D : ℕ)
    (rowDegree : ∀ u, (Finset.univ.filter (edge u)).card = c)
    (columnDegree : ∀ v, (Finset.univ.filter fun u => edge u v).card = d)
    (monotone : ∀ u v, edge u v → upperRank v ≤ lowerRank u)
    (stable : ∀ u v, edge u v → lowerRank u = upperRank v →
      lowerMinor u = upperMinor v)
    (divisorBudget : ∀ u,
      (Finset.univ.filter fun v => edge u v ∧ label u v ∣ lowerMinor u).card ≤ D) :
    (∑ u, ∑ v, if edge u v then bad (label u v) (upperMinor v) else 0) ≤
      (c : ℚ) * (∑ u, (lowerRank u : ℚ)) -
      (d : ℚ) * (∑ v, (upperRank v : ℚ)) +
      (Fintype.card U : ℚ) * D := by
  classical
  have rowSum (u : U) :
      (∑ v, if edge u v then (lowerRank u : ℚ) else 0) =
        (c : ℚ) * lowerRank u := by
    simp [← Finset.sum_filter, rowDegree, nsmul_eq_mul]
  have columnSum (v : V) :
      (∑ u, if edge u v then (upperRank v : ℚ) else 0) =
        (d : ℚ) * upperRank v := by
    simp [← Finset.sum_filter, columnDegree, nsmul_eq_mul]
  have oldBound (u : U) :
      (∑ v, if edge u v then bad (label u v) (lowerMinor u) else 0) ≤ (D : ℚ) := by
    have indicator (v : V) :
        (if edge u v then bad (label u v) (lowerMinor u) else 0) =
          (if edge u v ∧ label u v ∣ lowerMinor u then (1 : ℚ) else 0) := by
      by_cases h : edge u v <;> simp [h, bad]
    simp_rw [indicator]
    simpa using (show
      ((Finset.univ.filter fun v => edge u v ∧ label u v ∣ lowerMinor u).card : ℚ)
        ≤ (D : ℚ) from by exact_mod_cast divisorBudget u)
  have recordSum :
      (∑ u, ∑ v, if edge u v then
        ((lowerRank u : ℚ) - upperRank v) else 0) =
        (c : ℚ) * (∑ u, (lowerRank u : ℚ)) -
        (d : ℚ) * (∑ v, (upperRank v : ℚ)) := by
    have separate (u : U) (v : V) :
        (if edge u v then ((lowerRank u : ℚ) - upperRank v) else 0) =
        (if edge u v then (lowerRank u : ℚ) else 0) -
        (if edge u v then (upperRank v : ℚ) else 0) := by
      split_ifs <;> ring
    simp_rw [separate, Finset.sum_sub_distrib]
    rw [Finset.sum_comm (f := fun u v =>
      if edge u v then (upperRank v : ℚ) else 0)]
    simp_rw [rowSum, columnSum]
    simp [Finset.mul_sum]
  have totalOld :
      (∑ u, ∑ v, if edge u v then bad (label u v) (lowerMinor u) else 0) ≤
        (Fintype.card U : ℚ) * D := by
    calc
      _ ≤ ∑ _u : U, (D : ℚ) := Finset.sum_le_sum fun u _ => oldBound u
      _ = _ := by simp
  calc
    _ ≤ ∑ u, ∑ v, if edge u v then
        ((lowerRank u : ℚ) - upperRank v + bad (label u v) (lowerMinor u))
        else 0 := by
      apply Finset.sum_le_sum
      intro u _
      apply Finset.sum_le_sum
      intro v _
      by_cases h : edge u v
      · simpa only [if_pos h] using adaptive_edge_bound
          (lowerRank u) (upperRank v) (lowerMinor u) (upperMinor v) (label u v)
          (monotone u v h) (stable u v h)
      · simp [h]
    _ = (∑ u, ∑ v, if edge u v then
        ((lowerRank u : ℚ) - upperRank v) else 0) +
        (∑ u, ∑ v, if edge u v then bad (label u v) (lowerMinor u) else 0) := by
      have separate (u : U) (v : V) :
          (if edge u v then
            ((lowerRank u : ℚ) - upperRank v + bad (label u v) (lowerMinor u))
            else 0) =
          (if edge u v then ((lowerRank u : ℚ) - upperRank v) else 0) +
          (if edge u v then bad (label u v) (lowerMinor u) else 0) := by
        split_ifs <;> ring
      simp_rw [separate, Finset.sum_add_distrib]
    _ ≤ _ := by rw [recordSum]; linarith [totalOld]

theorem telescope (F : ℕ → ℚ) (T : ℕ) :
    (∑ k ∈ Finset.range T, (F k - F (k + 1))) = F 0 - F T := by
  induction T with
  | zero => simp
  | succ T ih =>
      rw [Finset.sum_range_succ, ih]
      ring

theorem averaged_deletion_bound
    (F A denominator : ℕ → ℚ) (T : ℕ) (B D c : ℚ)
    (positiveT : 0 < T) (positiveC : 0 < c) (nonnegativeD : 0 ≤ D)
    (denominatorBound : ∀ k < T, c ≤ denominator k)
    (span : F 0 - F T ≤ B)
    (step : ∀ k < T, A k ≤ F k - F (k + 1) + D / denominator k) :
    (∑ k ∈ Finset.range T, A k) / T ≤ B / T + D / c := by
  have positiveTQ : (0 : ℚ) < T := by exact_mod_cast positiveT
  have total :
      (∑ k ∈ Finset.range T, A k) ≤ B + (T : ℚ) * (D / c) := by
    calc
      _ ≤ ∑ k ∈ Finset.range T, (F k - F (k + 1) + D / c) := by
        apply Finset.sum_le_sum
        intro k hk
        have hkt := Finset.mem_range.mp hk
        have errorBound : D / denominator k ≤ D / c :=
          div_le_div_of_nonneg_left nonnegativeD positiveC (denominatorBound k hkt)
        linarith [step k hkt]
      _ = F 0 - F T + (T : ℚ) * (D / c) := by
        rw [Finset.sum_add_distrib, telescope]
        simp
      _ ≤ _ := by linarith [span]
  calc
    _ ≤ (B + (T : ℚ) * (D / c)) / T :=
      (div_le_div_iff_of_pos_right positiveTQ).2 total
    _ = _ := by field_simp <;> ring

theorem finite_pool_average_bound
    (n ell T : ℕ) (F A : ℕ → ℚ) (B D : ℚ)
    (_positiveEll : 0 < ell) (positiveT : 0 < T)
    (poolLargeEnough : ell + T ≤ n + 1) (nonnegativeD : 0 ≤ D)
    (span : F 0 - F T ≤ B)
    (step : ∀ k < T,
      A k ≤ F k - F (k + 1) + D / ((n + 1 - ell - k : ℕ) : ℚ)) :
    (∑ k ∈ Finset.range T, A k) / T ≤
      B / T + D / ((n + 2 - ell - T : ℕ) : ℚ) := by
  apply averaged_deletion_bound F A
    (fun k => ((n + 1 - ell - k : ℕ) : ℚ)) T B D
    ((n + 2 - ell - T : ℕ) : ℚ) positiveT
  · exact_mod_cast (show 0 < n + 2 - ell - T by omega)
  · exact nonnegativeD
  · intro k hk
    exact_mod_cast (show n + 2 - ell - T ≤ n + 1 - ell - k by omega)
  · exact span
  · exact step

end AdaptivePrimeDeletion
