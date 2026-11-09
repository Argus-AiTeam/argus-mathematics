import Mathlib

open scoped BigOperators

namespace ProbabilisticTournament

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

structure Comparison (a : ι → ι → ℝ) : Prop where
  nonneg : ∀ i j, 0 ≤ a i j
  le_one : ∀ i j, a i j ≤ 1
  diagonal : ∀ i, a i i = 0
  complementary : ∀ i j, i ≠ j → a i j + a j i = 1

def total (w : ι → ℝ) : ℝ := ∑ i, w i

def update (a : ι → ι → ℝ) (w : ι → ℝ) (p : ι) : ι → ℝ :=
  fun i => w i * a i p

def weights (a : ι → ι → ℝ) : List ι → ι → ℝ
  | [] => fun _ => 1
  | p :: h => update a (weights a h) p

omit [Fintype ι] [DecidableEq ι] in
theorem weight_bounds (a : ι → ι → ℝ) (ha : Comparison a) :
    ∀ h i, 0 ≤ weights a h i ∧ weights a h i ≤ 1 := by
  intro h
  induction h with
  | nil => intro i; simp [weights]
  | cons p h ih =>
      intro i
      change 0 ≤ weights a h i * a i p ∧ weights a h i * a i p ≤ 1
      exact ⟨mul_nonneg (ih i).1 (ha.nonneg i p),
        (mul_le_mul_of_nonneg_right (ih i).2 (ha.nonneg i p)).trans
          (by simpa using ha.le_one i p)⟩

omit [DecidableEq ι] in
theorem total_nonneg (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) : 0 ≤ total w :=
  Finset.sum_nonneg fun i _ => hw i

omit [DecidableEq ι] in
theorem le_total (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (i : ι) :
    w i ≤ total w :=
  Finset.single_le_sum (fun j _ => hw j) (Finset.mem_univ i)

theorem numerator_le (a : ι → ι → ℝ) (ha : Comparison a)
    (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) :
    2 * (∑ p, w p * total (update a w p)) ≤ total w * total w := by
  have swap :
      (∑ p, ∑ i, w p * w i * a p i) =
        ∑ p, ∑ i, w p * w i * a i p := by
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro p _
    apply Finset.sum_congr rfl
    intro i _
    ring
  have expand :
      (∑ p, w p * total (update a w p)) =
        ∑ p, ∑ i, w p * w i * a i p := by
    apply Finset.sum_congr rfl
    intro p _
    simp only [total, update, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring
  calc
    2 * (∑ p, w p * total (update a w p)) =
        (∑ p, ∑ i, w p * w i * a i p) +
          (∑ p, ∑ i, w p * w i * a p i) := by
      rw [expand, swap]
      ring
    _ = ∑ p, ∑ i, w p * w i * (a i p + a p i) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro p _
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ ≤ ∑ p, ∑ i, w p * w i := by
      apply Finset.sum_le_sum
      intro p _
      apply Finset.sum_le_sum
      intro i _
      have hab : a i p + a p i ≤ 1 := by
        by_cases hip : i = p
        · subst i; simp [ha.diagonal]
        · exact le_of_eq (ha.complementary i p hip)
      exact mul_le_of_le_one_right (mul_nonneg (hw p) (hw i)) hab
    _ = total w * total w := by
      simp only [total, Finset.sum_mul, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro p _
      apply Finset.sum_congr rfl
      intro i _
      ring

theorem average_next_le (a : ι → ι → ℝ) (ha : Comparison a)
    (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (hW : 0 < total w) :
    (∑ p, (w p / total w) * total (update a w p)) ≤ total w / 2 := by
  have hn := numerator_le a ha w hw
  have heq :
      (∑ p, (w p / total w) * total (update a w p)) =
        (∑ p, w p * total (update a w p)) / total w := by
    simp only [div_mul_eq_mul_div, Finset.sum_div]
  rw [heq]
  apply (div_le_iff₀ hW).2
  nlinarith

omit [DecidableEq ι] in
theorem pivot_sum (a : ι → ι → ℝ) (h : List ι)
    (hW : total (weights a h) ≠ 0) :
    (∑ p, weights a h p / total (weights a h)) = 1 := by
  rw [← Finset.sum_div]
  exact div_self hW

noncomputable def miss (a : ι → ι → ℝ) (star : ι) (q : List ι → ℝ) :
    ℕ → List ι → ℝ
  | 0, h => if star ∈ h then 0 else 1
  | n + 1, h =>
      if star ∈ h then 0
      else if total (weights a h) = 0 then 1
      else q h + (1 - q h) *
        ∑ p, (weights a h p / total (weights a h)) * miss a star q n (p :: h)

theorem miss_of_mem (a : ι → ι → ℝ) (star : ι) (q : List ι → ℝ)
    (n : ℕ) (h : List ι) (hh : star ∈ h) : miss a star q n h = 0 := by
  cases n <;> simp [miss, hh]

theorem miss_nonneg (a : ι → ι → ℝ) (ha : Comparison a) (star : ι)
    (q : List ι → ℝ) (hq : ∀ h, 0 ≤ q h ∧ q h ≤ 1) :
    ∀ n h, 0 ≤ miss a star q n h := by
  intro n
  induction n with
  | zero =>
      intro h
      simp only [miss]
      split_ifs <;> norm_num
  | succ n ih =>
      intro h
      by_cases hh : star ∈ h
      · simp [miss, hh]
      by_cases hz : total (weights a h) = 0
      · simp [miss, hh, hz]
      rw [miss]
      simp only [if_neg hh, if_neg hz]
      apply add_nonneg (hq h).1
      apply mul_nonneg (sub_nonneg.mpr (hq h).2)
      apply Finset.sum_nonneg
      intro p _
      exact mul_nonneg
        (div_nonneg (weight_bounds a ha h p).1
          (total_nonneg _ fun i => (weight_bounds a ha h i).1))
        (ih (p :: h))

theorem miss_le_one (a : ι → ι → ℝ) (ha : Comparison a) (star : ι)
    (q : List ι → ℝ) (hq : ∀ h, 0 ≤ q h ∧ q h ≤ 1) :
    ∀ n h, miss a star q n h ≤ 1 := by
  intro n
  induction n with
  | zero =>
      intro h
      simp only [miss]
      split_ifs <;> norm_num
  | succ n ih =>
      intro h
      by_cases hh : star ∈ h
      · simp [miss, hh]
      by_cases hz : total (weights a h) = 0
      · simp [miss, hh, hz]
      have hs :
          (∑ p, (weights a h p / total (weights a h)) *
            miss a star q n (p :: h)) ≤ 1 := by
        calc
          _ ≤ ∑ p, weights a h p / total (weights a h) := by
            apply Finset.sum_le_sum
            intro p _
            exact mul_le_of_le_one_right
              (div_nonneg (weight_bounds a ha h p).1
                (total_nonneg _ fun i => (weight_bounds a ha h i).1))
              (ih (p :: h))
          _ = 1 := pivot_sum a h hz
      rw [miss]
      simp only [if_neg hh, if_neg hz]
      nlinarith [mul_nonneg (sub_nonneg.mpr (hq h).2) (sub_nonneg.mpr hs)]

theorem surviving_weight (a : ι → ι → ℝ) (ha : Comparison a)
    (star : ι) (epsilon : ℝ) (he : 0 ≤ epsilon)
    (dominant : ∀ p, p ≠ star → 1 - epsilon ≤ a star p) :
    ∀ h, star ∉ h → 1 - (h.length : ℝ) * epsilon ≤ weights a h star := by
  intro h
  induction h with
  | nil => simp [weights]
  | cons p h ih =>
      intro hh
      simp only [List.mem_cons, not_or] at hh
      have hp : p ≠ star := Ne.symm hh.1
      have ht : star ∉ h := hh.2
      have hprod := mul_le_mul_of_nonneg_left (dominant p hp)
        (weight_bounds a ha h star).1
      have hslack : weights a h star * epsilon ≤ epsilon := by
        simpa using mul_le_mul_of_nonneg_right (weight_bounds a ha h star).2 he
      have hi := ih ht
      simp only [weights, update, List.length_cons, Nat.cast_add, Nat.cast_one]
      nlinarith

theorem miss_bound_from_state (a : ι → ι → ℝ) (ha : Comparison a)
    (star : ι) (epsilon eta : ℝ) (he : 0 ≤ epsilon) (heta : 0 ≤ eta)
    (dominant : ∀ p, p ≠ star → 1 - epsilon ≤ a star p)
    (q : List ι → ℝ) (hq : ∀ h, 0 ≤ q h ∧ q h ≤ 1)
    (hfail : ∀ h, star ∉ h → (1 / 2 : ℝ) ≤ total (weights a h) → q h ≤ eta) :
    ∀ (n : ℕ) (h : List ι), (1 / 2 : ℝ) + (n : ℝ) * epsilon ≤ weights a h star →
      miss a star q n h ≤
        2 * total (weights a h) / (2 : ℝ) ^ n + (n : ℝ) * eta := by
  intro n
  induction n with
  | zero =>
      intro h hinv
      have ht := le_total (weights a h)
        (fun i => (weight_bounds a ha h i).1) star
      by_cases hh : star ∈ h
      · rw [miss_of_mem a star q 0 h hh]
        simp only [pow_zero, div_one, Nat.cast_zero, zero_mul, add_zero]
        exact mul_nonneg (by norm_num)
          (total_nonneg _ fun i => (weight_bounds a ha h i).1)
      · simp only [miss, if_neg hh, pow_zero, div_one, Nat.cast_zero,
          zero_mul, add_zero] at *
        linarith
  | succ n ih =>
      intro h hinv
      have hw : ∀ i, 0 ≤ weights a h i := fun i => (weight_bounds a ha h i).1
      have ht := le_total (weights a h) hw star
      have hhalf : (1 / 2 : ℝ) ≤ total (weights a h) := by
        have hn : 0 ≤ ((n + 1 : ℕ) : ℝ) * epsilon := mul_nonneg (Nat.cast_nonneg _) he
        linarith
      have hW : 0 < total (weights a h) := by linarith
      have hz := ne_of_gt hW
      by_cases hh : star ∈ h
      · rw [miss_of_mem a star q (n + 1) h hh]
        exact add_nonneg
          (div_nonneg (mul_nonneg (by norm_num) (total_nonneg _ hw)) (by positivity))
          (mul_nonneg (Nat.cast_nonneg _) heta)
      have child (p : ι) :
          miss a star q n (p :: h) ≤
            2 * total (weights a (p :: h)) / (2 : ℝ) ^ n + (n : ℝ) * eta := by
        by_cases hp : p = star
        · rw [miss_of_mem a star q n (p :: h) (by simp [hp])]
          exact add_nonneg
            (div_nonneg
              (mul_nonneg (by norm_num)
                (total_nonneg _ fun i => (weight_bounds a ha (p :: h) i).1))
              (by positivity))
            (mul_nonneg (Nat.cast_nonneg _) heta)
        · apply ih
          have hprod := mul_le_mul_of_nonneg_left (dominant p hp)
            (weight_bounds a ha h star).1
          have hslack : weights a h star * epsilon ≤ epsilon := by
            simpa using mul_le_mul_of_nonneg_right (weight_bounds a ha h star).2 he
          change (1 / 2 : ℝ) + (n : ℝ) * epsilon ≤ weights a h star * a star p
          rw [Nat.cast_succ] at hinv
          nlinarith
      have hs :
          (∑ p, (weights a h p / total (weights a h)) *
            miss a star q n (p :: h)) ≤
              2 * total (weights a h) / (2 : ℝ) ^ (n + 1) + (n : ℝ) * eta := by
        calc
          _ ≤ ∑ p, (weights a h p / total (weights a h)) *
              (2 * total (weights a (p :: h)) / (2 : ℝ) ^ n + (n : ℝ) * eta) := by
            apply Finset.sum_le_sum
            intro p _
            exact mul_le_mul_of_nonneg_left (child p) (div_nonneg (hw p) (le_of_lt hW))
          _ = (2 / (2 : ℝ) ^ n) *
                (∑ p, (weights a h p / total (weights a h)) *
                  total (weights a (p :: h))) +
                (n : ℝ) * eta * (∑ p, weights a h p / total (weights a h)) := by
            calc
              _ = ∑ p, ((2 / (2 : ℝ) ^ n) *
                  ((weights a h p / total (weights a h)) * total (weights a (p :: h))) +
                  (n : ℝ) * eta * (weights a h p / total (weights a h))) := by
                apply Finset.sum_congr rfl
                intro p _
                ring
              _ = _ := by
                rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
          _ ≤ (2 / (2 : ℝ) ^ n) * (total (weights a h) / 2) + (n : ℝ) * eta := by
            rw [pivot_sum a h hz, mul_one]
            apply add_le_add _ le_rfl
            apply mul_le_mul_of_nonneg_left _ (by positivity)
            simpa only [weights] using average_next_le a ha (weights a h) hw hW
          _ = _ := by
            rw [pow_succ]
            field_simp
      have hs0 :
          0 ≤ ∑ p, (weights a h p / total (weights a h)) *
            miss a star q n (p :: h) :=
        Finset.sum_nonneg fun p _ =>
          mul_nonneg (div_nonneg (hw p) (le_of_lt hW))
            (miss_nonneg a ha star q hq n (p :: h))
      have hf := hfail h hh hhalf
      rw [miss]
      simp only [if_neg hh, if_neg hz]
      rw [Nat.cast_succ]
      nlinarith [mul_nonneg (hq h).1 hs0]

theorem finite_horizon_miss_bound (a : ι → ι → ℝ) (ha : Comparison a)
    (star : ι) (epsilon eta : ℝ) (he : 0 ≤ epsilon) (heta : 0 ≤ eta)
    (dominant : ∀ p, p ≠ star → 1 - epsilon ≤ a star p)
    (q : List ι → ℝ) (hq : ∀ h, 0 ≤ q h ∧ q h ≤ 1)
    (hfail : ∀ h, star ∉ h → (1 / 2 : ℝ) ≤ total (weights a h) → q h ≤ eta)
    (T : ℕ) (budget : (T : ℝ) * epsilon ≤ 1 / 2) :
    miss a star q T [] ≤ 2 * (Fintype.card ι : ℝ) / (2 : ℝ) ^ T + (T : ℝ) * eta := by
  have hinv : (1 / 2 : ℝ) + (T : ℝ) * epsilon ≤ weights a [] star := by
    simp only [weights]
    linarith
  simpa [total, weights] using
    miss_bound_from_state a ha star epsilon eta he heta dominant q hq hfail T [] hinv

end ProbabilisticTournament
