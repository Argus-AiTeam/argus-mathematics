import Mathlib

namespace Sharp22

def convolution {s : ℕ} (e : Fin s → ℤ) (v : ℤ → ℤ) (j : ℤ) : ℤ :=
  ∑ t, e t * v (j - (t.val : ℤ))

theorem convolution_difference {s : ℕ} (e : Fin s → ℤ)
    (a q : ℤ → ℤ) (j : ℤ) :
    convolution e (fun k => a k - q k) j =
      convolution e a j - convolution e q j := by
  simp [convolution, mul_sub, Finset.sum_sub_distrib]

theorem max_as_excess (a q : ℤ) :
    max a q = q + max (a - q) 0 := by
  omega

theorem sharpness_criterion {ι : Type*} [Fintype ι]
    (a q : ι → ℕ) :
    (∑ j, max (a j) (q j)) = ∑ j, q j ↔ ∀ j, a j ≤ q j := by
  constructor
  · intro h j
    by_contra hn
    have hj : q j < max (a j) (q j) := by omega
    have hlt : (∑ k, q k) < ∑ k, max (a k) (q k) :=
      Finset.sum_lt_sum (fun k _ => le_max_right (a k) (q k))
        ⟨j, Finset.mem_univ j, hj⟩
    omega
  · intro h
    apply Finset.sum_congr rfl
    intro j _
    exact max_eq_right (h j)

def shiftCount (r : ℕ) : ℕ :=
  9 - (2 + r) - 1

def centerProfile (r j : ℕ) : ℕ :=
  ∑ k ∈ Finset.range (shiftCount r),
    ∑ l ∈ Finset.range (r + 1), if k + 1 + l = j then 1 else 0

def primary2 (j : ℕ) : ℕ :=
  2 * 2 * centerProfile 1 j

def primary3 (j : ℕ) : ℕ :=
  3 * centerProfile 0 j + 2 * centerProfile 2 j

theorem centerProfile_zero (r : ℕ) : centerProfile r 0 = 0 := by
  apply Finset.sum_eq_zero
  intro k _
  apply Finset.sum_eq_zero
  intro l _
  simp

theorem centerProfile_support (r j : ℕ) (hr : r ≤ 2) (hj : 6 < j) :
    centerProfile r j = 0 := by
  apply Finset.sum_eq_zero
  intro k hk
  apply Finset.sum_eq_zero
  intro l hl
  have hk' : k < shiftCount r := Finset.mem_range.mp hk
  have hl' : l < r + 1 := Finset.mem_range.mp hl
  have h : k + 1 + l ≠ j := by
    unfold shiftCount at hk'
    omega
  simp [h]

theorem primary_support (j : ℕ) (hj : 6 < j) :
    primary2 j = 0 ∧ primary3 j = 0 := by
  simp [primary2, primary3, centerProfile_support 0 j (by omega) hj,
    centerProfile_support 1 j (by omega) hj,
    centerProfile_support 2 j (by omega) hj]

def convC (v : ℕ → ℕ) (j : ℕ) : ℕ :=
  v j + if j = 0 then 0 else v (j - 1)

def convM (v : ℕ → ℕ) (j : ℕ) : ℕ :=
  v j + 6 * (if j = 0 then 0 else v (j - 1)) +
    if j < 2 then 0 else v (j - 2)

theorem convC_scale (m : ℕ) (v : ℕ → ℕ) (j : ℕ) :
    convC (fun k => m * v k) j = m * convC v j := by
  unfold convC
  split_ifs <;> ring

theorem convM_scale (m : ℕ) (v : ℕ → ℕ) (j : ℕ) :
    convM (fun k => m * v k) j = m * convM v j := by
  unfold convM
  split_ifs <;> ring

theorem convC_support (v : ℕ → ℕ) (hv : ∀ j, 6 < j → v j = 0)
    (j : ℕ) (hj : 7 < j) : convC v j = 0 := by
  have h0 : j ≠ 0 := by omega
  simp [convC, h0, hv j (by omega), hv (j - 1) (by omega)]

theorem convM_support (v : ℕ → ℕ) (hv : ∀ j, 6 < j → v j = 0)
    (j : ℕ) (hj : 8 < j) : convM v j = 0 := by
  have h0 : j ≠ 0 := by omega
  have h2 : ¬j < 2 := by omega
  simp [convM, h0, h2, hv j (by omega), hv (j - 1) (by omega),
    hv (j - 2) (by omega)]

def total (n : ℕ) (v : ℕ → ℕ) : ℕ :=
  ∑ j ∈ Finset.range n, v j

theorem max_scale (m a q : ℕ) :
    max (m * a) (m * q) = m * max a q := by
  rcases le_total a q with h | h
  · rw [max_eq_right h, max_eq_right (Nat.mul_le_mul_left m h)]
  · rw [max_eq_left h, max_eq_left (Nat.mul_le_mul_left m h)]

theorem total_scale (n m : ℕ) (v : ℕ → ℕ) :
    total n (fun j => m * v j) = m * total n v := by
  simp [total, Finset.mul_sum]

theorem primary_tables :
    (List.ofFn fun j : Fin 7 => primary2 j.val) = [0, 4, 8, 8, 8, 8, 4] ∧
    (List.ofFn fun j : Fin 7 => primary3 j.val) = [0, 5, 7, 9, 9, 7, 5] := by
  decide

theorem convolution_tables :
    (List.ofFn fun j : Fin 8 => convC primary2 j.val) =
        [0, 4, 12, 16, 16, 16, 12, 4] ∧
    (List.ofFn fun j : Fin 8 => convC primary3 j.val) =
        [0, 5, 12, 16, 18, 16, 12, 5] ∧
    (List.ofFn fun j : Fin 9 => convM primary2 j.val) =
        [0, 4, 32, 60, 64, 64, 60, 32, 4] ∧
    (List.ofFn fun j : Fin 9 => convM primary3 j.val) =
        [0, 5, 37, 56, 70, 70, 56, 37, 5] := by
  decide

theorem c_dominance (j : ℕ) : convC primary2 j ≤ convC primary3 j := by
  by_cases hj : j < 8
  · interval_cases j <;> decide
  · rw [convC_support primary2 (fun k hk => (primary_support k hk).1) j (by omega),
      convC_support primary3 (fun k hk => (primary_support k hk).2) j (by omega)]

theorem unit_totals :
    total 7 primary2 = 40 ∧ total 7 primary3 = 42 ∧
    total 8 (fun j => max (convC primary2 j) (convC primary3 j)) = 84 ∧
    total 9 (convM primary2) = 320 ∧ total 9 (convM primary3) = 336 ∧
    total 9 (fun j => max (convM primary2 j) (convM primary3 j)) = 344 := by
  decide

def cGenerators (m : ℕ) : ℕ :=
  total 8 (fun j => max (m * convC primary2 j) (m * convC primary3 j))

def mGenerators (m : ℕ) : ℕ :=
  total 9 (fun j => max (m * convM primary2 j) (m * convM primary3 j))

def mCyclicGenerators (m : ℕ) : ℕ :=
  max (total 9 (fun j => m * convM primary2 j))
    (total 9 (fun j => m * convM primary3 j))

theorem cGenerators_eq (m : ℕ) : cGenerators m = 84 * m := by
  simp only [cGenerators, max_scale, total_scale, unit_totals.2.2.1]
  omega

theorem mGenerators_eq (m : ℕ) : mGenerators m = 344 * m := by
  simp only [mGenerators, max_scale, total_scale, unit_totals.2.2.2.2.2]
  omega

theorem mCyclicGenerators_eq (m : ℕ) : mCyclicGenerators m = 336 * m := by
  rw [mCyclicGenerators, total_scale, total_scale,
    unit_totals.2.2.2.1, unit_totals.2.2.2.2.1, max_scale]
  norm_num <;> ring

def bX (m : ℕ) : ℕ :=
  10 + m * (2 * (8 * (1 + 1)) * shiftCount 1 +
    3 * (8 * (0 + 1)) * shiftCount 0 +
    2 * (8 * (2 + 1)) * shiftCount 2)

def lambdaC (m : ℕ) : ℕ := 2 * bX m + 2 * (2 * cGenerators m)
def lambdaM (m : ℕ) : ℕ := 8 * bX m + 2 * (2 * mGenerators m)
def betaCyclic (m : ℕ) : ℕ := 8 * bX m + 2 * (2 * mCyclicGenerators m)
def fixedCount (m : ℕ) : ℕ := 4 * lambdaC m

theorem bX_eq (m : ℕ) : bX m = 10 + 496 * m := by
  norm_num [bX, shiftCount]
  ring

theorem parametric_counts (m : ℕ) :
    lambdaC m = 20 + 1328 * m ∧
    fixedCount m = betaCyclic m ∧
    betaCyclic m = 80 + 5312 * m ∧
    lambdaM m = 80 + 5344 * m ∧
    lambdaM m = fixedCount m + 32 * m := by
  simp only [lambdaC, fixedCount, lambdaM, betaCyclic, bX_eq,
    cGenerators_eq, mGenerators_eq, mCyclicGenerators_eq]
  constructor
  · ring
  constructor
  · ring
  constructor
  · ring
  constructor <;> ring

theorem strict_deficit (m : ℕ) (hm : 1 ≤ m) :
    fixedCount m < lambdaM m := by
  have h := (parametric_counts m).2.2.2.2
  omega

end Sharp22
