import Mathlib

open scoped BigOperators

namespace EnergyBootstrap

noncomputable section

def rowDegree {I J : Type*} [Fintype J] (R : I → J → Prop) (i : I) : ℕ := by
  classical
  exact (Finset.univ.filter (R i)).card

def colDegree {I J : Type*} [Fintype I] (R : I → J → Prop) (j : J) : ℕ := by
  classical
  exact (Finset.univ.filter (fun i => R i j)).card

def edgeSum {I J : Type*} [Fintype I] [Fintype J]
    (R : I → J → Prop) (a : I → ℝ) (b : J → ℝ) : ℝ := by
  classical
  exact ∑ i, ∑ j, if R i j then a i * b j else 0

theorem graphSchur {I J : Type*} [Fintype I] [Fintype J]
    (R : I → J → Prop) (a : I → ℝ) (b : J → ℝ) (r s : ℕ)
    (hr : ∀ i, rowDegree R i ≤ r) (hs : ∀ j, colDegree R j ≤ s) :
    (edgeSum R a b) ^ 2 ≤
      ((r : ℝ) * (s : ℝ)) * (∑ i, a i ^ 2) * (∑ j, b j ^ 2) := by
  classical
  let E : Finset (I × J) := Finset.univ.filter (fun e => R e.1 e.2)
  have hE : edgeSum R a b = ∑ e ∈ E, a e.1 * b e.2 := by
    simp [edgeSum, E, Finset.sum_filter, Fintype.sum_prod_type]
  have hAeq : (∑ e ∈ E, a e.1 ^ 2) =
      ∑ i, (rowDegree R i : ℝ) * a i ^ 2 := by
    simp only [E, Finset.sum_filter, Fintype.sum_prod_type]
    apply Finset.sum_congr rfl
    intro i hi
    rw [← Finset.sum_filter]
    simp [rowDegree, nsmul_eq_mul]
  have hBeq : (∑ e ∈ E, b e.2 ^ 2) =
      ∑ j, (colDegree R j : ℝ) * b j ^ 2 := by
    simp only [E, Finset.sum_filter, Fintype.sum_prod_type]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j hj
    rw [← Finset.sum_filter]
    simp [colDegree, nsmul_eq_mul]
  have hA : (∑ e ∈ E, a e.1 ^ 2) ≤ (r : ℝ) * ∑ i, a i ^ 2 := by
    rw [hAeq, Finset.mul_sum]
    apply Finset.sum_le_sum
    intro i hi
    exact mul_le_mul_of_nonneg_right (by exact_mod_cast hr i) (sq_nonneg _)
  have hB : (∑ e ∈ E, b e.2 ^ 2) ≤ (s : ℝ) * ∑ j, b j ^ 2 := by
    rw [hBeq, Finset.mul_sum]
    apply Finset.sum_le_sum
    intro j hj
    exact mul_le_mul_of_nonneg_right (by exact_mod_cast hs j) (sq_nonneg _)
  calc
    (edgeSum R a b) ^ 2 = (∑ e ∈ E, a e.1 * b e.2) ^ 2 := by rw [hE]
    _ ≤ (∑ e ∈ E, a e.1 ^ 2) * ∑ e ∈ E, b e.2 ^ 2 :=
      Finset.sum_mul_sq_le_sq_mul_sq E (fun e => a e.1) (fun e => b e.2)
    _ ≤ ((r : ℝ) * ∑ i, a i ^ 2) * ((s : ℝ) * ∑ j, b j ^ 2) :=
      mul_le_mul hA hB (by positivity) (by positivity)
    _ = _ := by ring

abbrev BoundedTuple (n M : ℕ) := Fin n → Fin (M + 1)

def indexSum {n M : ℕ} (x : BoundedTuple n M) : ℤ :=
  ∑ i, ((x i).val : ℤ)

theorem tupleSumCount (n M : ℕ) (target : ℤ) :
    Fintype.card {x : BoundedTuple (n + 1) M // indexSum x = target} ≤
      (M + 1) ^ n := by
  classical
  let drop : {x : BoundedTuple (n + 1) M // indexSum x = target} →
      BoundedTuple n M := fun x i => x.1 i.succ
  have hinj : Function.Injective drop := by
    intro x y h
    apply Subtype.ext
    funext i
    refine Fin.cases ?_ (fun k => congrFun h k) i
    apply Fin.ext
    have hx := x.2
    have hy := y.2
    simp only [indexSum, Fin.sum_univ_succ] at hx hy
    have ht : (∑ k : Fin n, ((x.1 k.succ).val : ℤ)) =
        ∑ k : Fin n, ((y.1 k.succ).val : ℤ) := by
      apply Finset.sum_congr rfl
      intro k hk
      exact congrArg (fun z : Fin (M + 1) => (z.val : ℤ)) (congrFun h k)
    have hz : ((x.1 0).val : ℤ) = ((y.1 0).val : ℤ) := by omega
    exact_mod_cast hz
  calc
    _ ≤ Fintype.card (BoundedTuple n M) := Fintype.card_le_of_injective drop hinj
    _ = (M + 1) ^ n := by simp [BoundedTuple]

theorem modeSumSchur (p q M : ℕ) (target : ℤ)
    (a : BoundedTuple (p + 1) M → ℝ)
    (b : BoundedTuple (q + 1) M → ℝ) :
    (edgeSum (fun l r => indexSum r - indexSum l = target) a b) ^ 2 ≤
      ((M : ℝ) + 1) ^ (p + q) * (∑ l, a l ^ 2) * (∑ r, b r ^ 2) := by
  classical
  have hr : ∀ l : BoundedTuple (p + 1) M,
      rowDegree (fun (l : BoundedTuple (p + 1) M) (r : BoundedTuple (q + 1) M) =>
        indexSum r - indexSum l = target) l ≤
        (M + 1) ^ q := by
    intro l
    simpa [rowDegree, Fintype.card_subtype, sub_eq_iff_eq_add] using
      tupleSumCount q M (target + indexSum l)
  have hs : ∀ r : BoundedTuple (q + 1) M,
      colDegree (fun (l : BoundedTuple (p + 1) M) (r : BoundedTuple (q + 1) M) =>
        indexSum r - indexSum l = target) r ≤
        (M + 1) ^ p := by
    intro r
    have hp : ∀ l : BoundedTuple (p + 1) M,
        (indexSum r - indexSum l = target) ↔
          (indexSum l = indexSum r - target) := by
      intro l
      omega
    simpa [colDegree, Fintype.card_subtype, hp] using
      tupleSumCount p M (indexSum r - target)
  have h := graphSchur (fun l r => indexSum r - indexSum l = target)
    a b ((M + 1) ^ q) ((M + 1) ^ p) hr hs
  push_cast at h
  rw [← pow_add, Nat.add_comm q p] at h
  exact h

def pathSquare {J X : Type*} [Fintype J] (sqNorm : X → ℝ) :
    List (ℝ × (J → X → X)) → X → ℝ
  | [], v => sqNorm v
  | T :: ts, v => ∑ j, pathSquare sqNorm ts (T.2 j v)

theorem iteratedColumns {J X : Type*} [Fintype J] (sqNorm : X → ℝ)
    (ts : List (ℝ × (J → X → X)))
    (hcol : ∀ T ∈ ts, 0 ≤ T.1 ∧ ∀ v, (∑ j, sqNorm (T.2 j v)) ≤ T.1 * sqNorm v)
    (v : X) :
    pathSquare sqNorm ts v ≤ (ts.map Prod.fst).prod * sqNorm v := by
  induction ts generalizing v with
  | nil => simp [pathSquare]
  | cons T ts ih =>
      have hT := hcol T (by simp)
      have hts : ∀ U ∈ ts,
          0 ≤ U.1 ∧ ∀ v, (∑ j, sqNorm (U.2 j v)) ≤ U.1 * sqNorm v := by
        intro U hU
        exact hcol U (by simp [hU])
      have hprod : 0 ≤ (ts.map Prod.fst).prod := by
        apply List.prod_nonneg
        intro c hc
        obtain ⟨U, hU, rfl⟩ := List.mem_map.mp hc
        exact (hts U hU).1
      calc
        pathSquare sqNorm (T :: ts) v =
            ∑ j, pathSquare sqNorm ts (T.2 j v) := rfl
        _ ≤ ∑ j, (ts.map Prod.fst).prod * sqNorm (T.2 j v) :=
          Finset.sum_le_sum (fun j hj => ih hts (T.2 j v))
        _ = (ts.map Prod.fst).prod * ∑ j, sqNorm (T.2 j v) := by
          rw [Finset.mul_sum]
        _ ≤ (ts.map Prod.fst).prod * (T.1 * sqNorm v) :=
          mul_le_mul_of_nonneg_left (hT.2 v) hprod
        _ = ((T :: ts).map Prod.fst).prod * sqNorm v := by
          simp only [List.map_cons, List.prod_cons]
          ring

def rightDisplacement (xs : List (ℕ × ℕ)) : ℝ :=
  (xs.map (fun x => (x.1 : ℝ) - (x.2 : ℝ))).sum

def rightBudget (xs : List (ℕ × ℕ)) : ℕ :=
  (xs.map Prod.fst).sum

theorem rightPrefixBudget (xs : List (ℕ × ℕ)) (n : ℕ) :
    rightDisplacement (xs.take n) ≤ (rightBudget xs : ℝ) := by
  induction xs generalizing n with
  | nil => simp [rightDisplacement, rightBudget]
  | cons x xs ih =>
      cases n with
      | zero =>
          change (0 : ℝ) ≤ (rightBudget (x :: xs) : ℝ)
          positivity
      | succ n =>
          have h := ih n
          simp only [List.take_succ_cons, rightDisplacement, rightBudget,
            List.map_cons, List.sum_cons, Nat.cast_add] at h ⊢
          have hj : (0 : ℝ) ≤ x.2 := by positivity
          linarith

theorem rightEnergyCutoff (xs : List (ℕ × ℕ)) (n : ℕ) (h N : ℝ) (hh : h ≤ N) :
    h + rightDisplacement (xs.take n) ≤ N + (rightBudget xs : ℝ) :=
  add_le_add hh (rightPrefixBudget xs n)

theorem oneModeIndexBound (h h' M : ℝ) (c j : ℕ)
    (hin : h ≤ M) (hout : 0 ≤ h')
    (hshift : h' = h + (c : ℝ) - (j : ℝ)) :
    (j : ℝ) ≤ M + (c : ℝ) := by
  linarith

theorem mixedExponentIdentity (DL DR p q nL nR : ℤ) :
    (2 * DL - p) + (2 * DR - q) + (q - 1) + (p - 1) +
        2 * (nL + nR) =
      2 * (DL + DR + nL + nR - 1) := by
  ring

end

end EnergyBootstrap
