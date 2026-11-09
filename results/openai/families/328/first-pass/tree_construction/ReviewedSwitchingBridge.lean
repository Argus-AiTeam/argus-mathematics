import Mathlib

noncomputable section

open scoped BigOperators Topology
open Filter

namespace SwitchingBridge

structure PlaneTree where
  count : ℕ → ℕ
  count_pos : ∀ k, 0 < count k
  count_zero : count 0 = 1
  parent : ∀ k, Fin (count (k + 1)) → Fin (count k)
  alpha : ∀ k, Fin (count (k + 1)) → ℝ
  alpha_pos : ∀ k v, 0 < alpha k v
  alpha_sum : ∀ k p, ∑ v, (if parent k v = p then alpha k v else 0) = 1
  ancestor : ∀ i n, Fin (count n) → Fin (count i)
  ancestor_self : ∀ n v, ancestor n n v = v
  ancestor_bottom : ∀ i n, i ≤ n → ∀ v,
    ancestor i (n + 1) v = ancestor i n (parent n v)
  ancestor_top : ∀ i n, i < n → ∀ v,
    parent i (ancestor (i + 1) n v) = ancestor i n v
  ancestor_comp : ∀ i k n, i ≤ k → k ≤ n → ∀ v,
    ancestor i k (ancestor k n v) = ancestor i n v
  lo : ∀ k (_n : ℕ), Fin (count k) → ℕ
  hi : ∀ k (_n : ℕ), Fin (count k) → ℕ
  lo_le_hi : ∀ k n, k ≤ n → ∀ v, lo k n v ≤ hi k n v
  hi_le : ∀ k n, k ≤ n → ∀ v, hi k n v ≤ count n
  before_cut : ∀ k n, k ≤ n → ∀ v s,
    s.val < hi k n v ↔ (ancestor k n s).val ≤ v.val
  after_cut : ∀ k n, k ≤ n → ∀ v s,
    s.val < lo k n v ↔ (ancestor k n s).val < v.val

namespace PlaneTree

abbrev Node (T : PlaneTree) (k : ℕ) := Fin (T.count k)

def root (T : PlaneTree) : T.Node 0 := ⟨0, T.count_pos 0⟩

theorem eq_root (T : PlaneTree) (v : T.Node 0) : v = T.root := by
  apply Fin.ext
  have hv : v.val < 1 := by simpa only [T.count_zero] using v.isLt
  simp only [root, Fin.val_mk]
  omega

theorem sum_zero (T : PlaneTree) (a : T.Node 0 → ℝ) :
    ∑ v, a v = a T.root := by
  apply Finset.sum_eq_single T.root
  · intro v _ hv
    exact (hv (T.eq_root v)).elim
  · simp

def childWeight (T : PlaneTree) (k : ℕ) (p : T.Node k)
    (v : T.Node (k + 1)) : ℝ :=
  if T.parent k v = p then T.alpha k v else 0

theorem childWeight_nonneg (T : PlaneTree) (k : ℕ) (p : T.Node k)
    (v : T.Node (k + 1)) : 0 ≤ T.childWeight k p v := by
  unfold childWeight
  split_ifs
  · exact (T.alpha_pos k v).le
  · exact le_rfl

theorem sum_childWeight (T : PlaneTree) (k : ℕ) (p : T.Node k) :
    ∑ v, T.childWeight k p v = 1 := T.alpha_sum k p

def weight (T : PlaneTree) : (k : ℕ) → T.Node k → ℝ
  | 0, _ => 1
  | k + 1, v => T.weight k (T.parent k v) * T.alpha k v

theorem weight_pos (T : PlaneTree) (k : ℕ) (v : T.Node k) :
    0 < T.weight k v := by
  induction k with
  | zero => exact zero_lt_one
  | succ k ih => exact mul_pos (ih _) (T.alpha_pos k v)

theorem sum_weighted_children (T : PlaneTree) (k : ℕ)
    (a : T.Node (k + 1) → ℝ) :
    (∑ p, T.weight k p * ∑ v, T.childWeight k p v * a v) =
      ∑ v, T.weight (k + 1) v * a v := by
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro v _
  simp [childWeight, mul_ite, weight, mul_assoc]

theorem sum_weight (T : PlaneTree) (k : ℕ) :
    ∑ v, T.weight k v = 1 := by
  induction k with
  | zero => simp [weight, T.count_zero, Node]
  | succ k ih =>
      have h := T.sum_weighted_children k (fun _ => 1)
      simp only [mul_one, T.sum_childWeight] at h
      rw [← h, ih]

theorem weight_le_one (T : PlaneTree) (k : ℕ) (v : T.Node k) :
    T.weight k v ≤ 1 := by
  rw [← T.sum_weight k]
  exact Finset.single_le_sum (fun w _ => (T.weight_pos k w).le) (Finset.mem_univ v)

theorem weighted_parent (T : PlaneTree) (k : ℕ) (a : T.Node k → ℝ) :
    (∑ v, T.weight (k + 1) v * a (T.parent k v)) =
      ∑ p, T.weight k p * a p := by
  rw [← T.sum_weighted_children]
  apply Finset.sum_congr rfl
  intro p _
  have h : (∑ v, T.childWeight k p v * a (T.parent k v)) =
      (∑ v, T.childWeight k p v) * a p := by
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro v _
    by_cases hv : T.parent k v = p <;> simp [childWeight, hv]
  rw [h, T.sum_childWeight, one_mul]

theorem weighted_ancestor (T : PlaneTree) (k h : ℕ) (a : T.Node k → ℝ) :
    (∑ v, T.weight (k + h) v * a (T.ancestor k (k + h) v)) =
      ∑ u, T.weight k u * a u := by
  induction h with
  | zero => simp [T.ancestor_self]
  | succ h ih =>
      simp_rw [Nat.add_succ, T.ancestor_bottom k (k + h) (Nat.le_add_right k h)]
      rw [T.weighted_parent (k + h) (fun u => a (T.ancestor k (k + h) u))]
      exact ih

theorem block_mass (T : PlaneTree) {k n : ℕ} (h : k ≤ n) (v : T.Node k) :
    (∑ s, if T.ancestor k n s = v then T.weight n s else 0) =
      T.weight k v := by
  have hm := T.weighted_ancestor k (n - k) (fun u => if u = v then 1 else 0)
  rw [Nat.add_sub_of_le h] at hm
  simpa only [mul_ite, mul_one, mul_zero, Finset.sum_ite_eq',
    Finset.mem_univ, if_true] using hm

theorem in_block (T : PlaneTree) {k n : ℕ} (h : k ≤ n)
    (v : T.Node k) (s : T.Node n) :
    (T.lo k n v ≤ s.val ∧ s.val < T.hi k n v) ↔ T.ancestor k n s = v := by
  have hb := T.before_cut k n h v s
  have ha := T.after_cut k n h v s
  constructor
  · intro hs
    apply Fin.ext
    have hle := hb.mp hs.2
    have hnot : ¬(T.ancestor k n s).val < v.val := by
      intro hv
      have := ha.mpr hv
      omega
    omega
  · intro hs
    have hval := congrArg Fin.val hs
    constructor
    · by_contra hlo
      have := ha.mp (by omega : s.val < T.lo k n v)
      omega
    · exact hb.mpr (by omega)

def cumulativeMinimum (T : PlaneTree) (e : ∀ k, T.Node k → ℝ)
    (k : ℕ) (hk : 0 < k) : ℝ :=
  (Finset.univ : Finset (Σ i : Fin k, T.Node (i.val + 1))).inf'
    ⟨⟨⟨0, hk⟩, ⟨0, T.count_pos 1⟩⟩, Finset.mem_univ _⟩
    (fun v => e (v.1.val + 1) v.2)

def manuscriptTolerance (T : PlaneTree) (e : ∀ k, T.Node k → ℝ) (k : ℕ) : ℝ :=
  if hk : 0 < k then (1 / 2 : ℝ) ^ (k + 1) * T.cumulativeMinimum e k hk else 1 / 2

theorem manuscriptTolerance_le (T : PlaneTree) (e : ∀ k, T.Node k → ℝ)
    {j i : ℕ} (hi : j + 1 ≤ i) (v : T.Node (j + 1)) :
    T.manuscriptTolerance e i ≤ e (j + 1) v * (1 / 2 : ℝ) ^ (i + 1) := by
  have hi0 : 0 < i := by omega
  have hmin : T.cumulativeMinimum e i hi0 ≤ e (j + 1) v :=
    Finset.inf'_le _ (Finset.mem_univ (⟨⟨j, by omega⟩, v⟩ :
      Σ n : Fin i, T.Node (n.val + 1)))
  simp only [manuscriptTolerance, dif_pos hi0]
  calc
    (1 / 2 : ℝ) ^ (i + 1) * T.cumulativeMinimum e i hi0 ≤
        (1 / 2 : ℝ) ^ (i + 1) * e (j + 1) v :=
      mul_le_mul_of_nonneg_left hmin (pow_nonneg (by norm_num) _)
    _ = _ := mul_comm _ _

end PlaneTree

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X]

omit [NormedSpace ℝ X] in
theorem norm_triangle_sub (a b c : X) :
    ‖a - c‖ ≤ ‖a - b‖ + ‖b - c‖ := by
  simpa only [dist_eq_norm] using dist_triangle a b c

theorem norm_weighted_difference {ι : Type*} [Fintype ι]
    (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (a b : ι → X) :
    ‖(∑ i, w i • a i) - ∑ i, w i • b i‖ ≤
      ∑ i, w i * ‖a i - b i‖ := by
  calc
    ‖(∑ i, w i • a i) - ∑ i, w i • b i‖ =
        ‖∑ i, w i • (a i - b i)‖ := by
          simp only [smul_sub, Finset.sum_sub_distrib]
    _ ≤ ∑ i, ‖w i • (a i - b i)‖ := norm_sum_le _ _
    _ = ∑ i, w i * ‖a i - b i‖ := by
      apply Finset.sum_congr rfl
      intro i _
      rw [norm_smul, Real.norm_of_nonneg (hw i)]

theorem distinguished_average {ι : Type*} [Fintype ι] [DecidableEq ι]
    (w a : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (hs : ∑ i, w i = 1)
    (ha : ∀ i, a i ≤ 1) (j : ι) :
    (∑ i, w i * a i) ≤ w j * a j + (1 - w j) := by
  have hrest : (∑ i ∈ Finset.univ.erase j, w i * a i) ≤
      ∑ i ∈ Finset.univ.erase j, w i := by
    apply Finset.sum_le_sum
    intro i _
    exact mul_le_of_le_one_right (hw i) (ha i)
  have hsum := Finset.sum_erase_add (s := Finset.univ) w (Finset.mem_univ j)
  have hsum' := Finset.sum_erase_add (s := Finset.univ)
    (fun i => w i * a i) (Finset.mem_univ j)
  rw [hs] at hsum
  linarith

theorem path_recurrence (k : ℕ) (w a d : ℕ → ℝ) (hw : w 0 = 1)
    (hstep : ∀ i < k,
      w i * a i ≤ w i - w (i + 1) + w (i + 1) * a (i + 1) + d i) :
    a 0 ≤ 1 - w k + w k * a k + ∑ i ∈ Finset.range k, d i := by
  have h : ∀ j, j ≤ k →
      a 0 ≤ 1 - w j + w j * a j + ∑ i ∈ Finset.range j, d i := by
    intro j
    induction j with
    | zero => intro _; simp [hw]
    | succ j ih =>
        intro hj
        have hprev := ih (by omega)
        have hnext := hstep j (by omega)
        rw [Finset.sum_range_succ]
        linarith
  exact h k le_rfl

theorem sum_fin_interval {A : Type*} [AddCommMonoid A]
    (n lo hi : ℕ) (hhi : hi ≤ n) (a : ℕ → A) :
    (∑ s : Fin n, if lo ≤ s.val ∧ s.val < hi then a s.val else 0) =
      ∑ i ∈ Finset.Ico lo hi, a i := by
  classical
  rw [← Finset.sum_filter]
  refine Finset.sum_bij (fun s _ => s.val) ?_ ?_ ?_ ?_
  · intro s hs
    exact Finset.mem_Ico.mpr (Finset.mem_filter.mp hs).2
  · intro s _ t _ h
    exact Fin.ext h
  · intro i hi'
    have hmem := Finset.mem_Ico.mp hi'
    refine ⟨⟨i, lt_of_lt_of_le hmem.2 hhi⟩, ?_, rfl⟩
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hmem⟩
  · intro s _
    rfl

structure Evaluation (T : PlaneTree) (K : Set X) where
  convex : Convex ℝ K
  x : K
  map : ∀ k, T.Node k → K → K
  nonexpansive : ∀ k v a b, ‖(map k v a : X) - map k v b‖ ≤ ‖(a : X) - b‖

namespace Evaluation

variable {T : PlaneTree} {K : Set X} (E : Evaluation T K)

def label (k : ℕ) (v : T.Node k) : K := E.map k v E.x

def average (k : ℕ) (H : T.Node (k + 1) → K) (p : T.Node k) : K :=
  ⟨∑ v, T.childWeight k p v • (H v : X),
    E.convex.sum_mem (fun v _ => T.childWeight_nonneg k p v)
      (T.sum_childWeight k p) (fun v _ => (H v).property)⟩

def collapse (k : ℕ) (H : T.Node (k + 1) → K) (p : T.Node k) : K :=
  E.map k p (E.average k H p)

def eval (E : Evaluation T K) : ℕ → (i : ℕ) → (∀ k, T.Node k → K) → T.Node i → K
  | 0, i, H => H i
  | h + 1, i, H => E.collapse i (eval E h (i + 1) H)

def rootOutput (n : ℕ) (H : ∀ k, T.Node k → K) : K :=
  E.eval n 0 H T.root

theorem eval_add (h l i : ℕ) (H : ∀ k, T.Node k → K) :
    E.eval (h + l) i H = E.eval h i (fun k => E.eval l k H) := by
  induction h generalizing i with
  | zero => simp only [Nat.zero_add, eval]
  | succ h ih =>
      simp only [Nat.succ_add, eval]
      rw [ih]

theorem average_difference (k : ℕ) (H H' : T.Node (k + 1) → K)
    (p : T.Node k) :
    ‖(E.average k H p : X) - E.average k H' p‖ ≤
      ∑ v, T.childWeight k p v * ‖(H v : X) - H' v‖ :=
  norm_weighted_difference _ (T.childWeight_nonneg k p) _ _

theorem average_constant (k : ℕ) (b : K) (p : T.Node k) :
    E.average k (fun _ => b) p = b := by
  apply Subtype.ext
  change (∑ v, T.childWeight k p v • (b : X)) = b
  rw [← Finset.sum_smul, T.sum_childWeight, one_smul]

theorem collapse_difference (k : ℕ) (H H' : T.Node (k + 1) → K)
    (p : T.Node k) :
    ‖(E.collapse k H p : X) - E.collapse k H' p‖ ≤
      ∑ v, T.childWeight k p v * ‖(H v : X) - H' v‖ :=
  (E.nonexpansive k p _ _).trans (E.average_difference k H H' p)

theorem root_sensitivity (n : ℕ) (H H' : ∀ k, T.Node k → K) :
    ‖(E.rootOutput n H : X) - E.rootOutput n H'‖ ≤
      ∑ v, T.weight n v * ‖(H n v : X) - H' n v‖ := by
  induction n generalizing H H' with
  | zero =>
      rw [T.sum_zero]
      simp [rootOutput, eval, PlaneTree.weight]
  | succ n ih =>
      have factor (F : ∀ k, T.Node k → K) :
          E.rootOutput (n + 1) F =
            E.rootOutput n (fun k => E.collapse k (F (k + 1))) := by
        unfold rootOutput
        rw [E.eval_add n 1 0 F]
        rfl
      rw [factor H, factor H']
      calc
        ‖(E.rootOutput n (fun k => E.collapse k (H (k + 1))) : X) -
            E.rootOutput n (fun k => E.collapse k (H' (k + 1)))‖ ≤
            ∑ p, T.weight n p *
              ‖(E.collapse n (H (n + 1)) p : X) -
                E.collapse n (H' (n + 1)) p‖ := ih _ _
        _ ≤ ∑ p, T.weight n p *
              ∑ v, T.childWeight n p v * ‖(H (n + 1) v : X) - H' (n + 1) v‖ := by
          apply Finset.sum_le_sum
          intro p _
          exact mul_le_mul_of_nonneg_left
            (E.collapse_difference n _ _ p) (T.weight_pos n p).le
        _ = _ := T.sum_weighted_children n _

theorem root_uniform (n : ℕ) (H H' : ∀ k, T.Node k → K)
    {a : ℝ} (h : ∀ v, ‖(H n v : X) - H' n v‖ ≤ a) :
    ‖(E.rootOutput n H : X) - E.rootOutput n H'‖ ≤ a := by
  refine (E.root_sensitivity n H H').trans ?_
  calc
    (∑ v, T.weight n v * ‖(H n v : X) - H' n v‖) ≤
        ∑ v, T.weight n v * a := by
      apply Finset.sum_le_sum
      intro v _
      exact mul_le_mul_of_nonneg_left (h v) (T.weight_pos n v).le
    _ = a := by rw [← Finset.sum_mul, T.sum_weight, one_mul]

theorem root_congr (n : ℕ) (H H' : ∀ k, T.Node k → K)
    (h : ∀ v, H n v = H' n v) :
    E.rootOutput n H = E.rootOutput n H' := by
  apply Subtype.ext
  apply sub_eq_zero.mp
  apply norm_eq_zero.mp
  apply le_antisymm _ (norm_nonneg _)
  exact E.root_uniform n H H' (by intro v; rw [h v]; simp)

theorem collapse_congr (k : ℕ) (H H' : T.Node (k + 1) → K)
    (p : T.Node k) (h : ∀ c, T.parent k c = p → H c = H' c) :
    E.collapse k H p = E.collapse k H' p := by
  apply congrArg (E.map k p)
  apply Subtype.ext
  change (∑ v, T.childWeight k p v • (H v : X)) =
    ∑ v, T.childWeight k p v • (H' v : X)
  apply Finset.sum_congr rfl
  intro v _
  by_cases hv : T.parent k v = p
  · rw [h v hv]
  · simp [PlaneTree.childWeight, hv]

theorem eval_congr_descendants (h i : ℕ) (H H' : ∀ k, T.Node k → K)
    (u : T.Node i)
    (heq : ∀ j, i ≤ j → ∀ s, T.ancestor i j s = u → H j s = H' j s) :
    E.eval h i H u = E.eval h i H' u := by
  induction h generalizing i u with
  | zero => exact heq i le_rfl u (T.ancestor_self i u)
  | succ h ih =>
      apply E.collapse_congr
      intro c hc
      apply ih (i + 1) c
      intro j hj s hs
      apply heq j (by omega) s
      rw [← T.ancestor_top i j (by omega) s, hs, hc]

def constantFamily (_E : Evaluation T K) (b : K) : ∀ k, T.Node k → K := fun _ _ => b

def leafFamily (t : ℕ) (b : K) : ∀ k, T.Node k → K :=
  fun k v => if v.val < t then E.label k v else b

def beforeFamily (k : ℕ) (v : T.Node k) (b : K) : ∀ j, T.Node j → K :=
  fun j s => if (T.ancestor k j s).val ≤ v.val then E.label j s else b

def afterFamily (k : ℕ) (v : T.Node k) (b : K) : ∀ j, T.Node j → K :=
  fun j s => if (T.ancestor k j s).val < v.val then E.label j s else b

def idealFamily (k : ℕ) (v : T.Node k) (b : K) : ∀ j, T.Node j → K :=
  fun j s => if s.val < v.val then E.label j s else b

def switchRoot (n t : ℕ) (b : K) : K := E.rootOutput n (E.leafFamily t b)

def beforeBlock (n k : ℕ) (v : T.Node k) (b : K) : K :=
  E.rootOutput n (E.beforeFamily k v b)

def afterBlock (n k : ℕ) (v : T.Node k) (b : K) : K :=
  E.rootOutput n (E.afterFamily k v b)

def prediction (k : ℕ) (v : T.Node k) (b : K) : K :=
  E.rootOutput k (E.idealFamily k v b)

theorem beforeBlock_eq_switchRoot {k n : ℕ} (h : k ≤ n)
    (v : T.Node k) (b : K) :
    E.beforeBlock n k v b = E.switchRoot n (T.hi k n v) b := by
  apply E.root_congr
  intro s
  simp only [beforeFamily, leafFamily, T.before_cut k n h v s]

theorem afterBlock_eq_switchRoot {k n : ℕ} (h : k ≤ n)
    (v : T.Node k) (b : K) :
    E.afterBlock n k v b = E.switchRoot n (T.lo k n v) b := by
  apply E.root_congr
  intro s
  simp only [afterFamily, leafFamily, T.after_cut k n h v s]

theorem beforeFamily_untouched (h k : ℕ) (v : T.Node k) (b : K) :
    E.eval h k (E.beforeFamily k v b) v = E.eval h k E.label v := by
  apply E.eval_congr_descendants
  intro j _ s hs
  simp [beforeFamily, hs]

theorem afterFamily_subtree (h k : ℕ) (u v : T.Node k) (b : K) :
    E.eval h k (E.afterFamily k v b) u =
      if u.val < v.val then E.eval h k E.label u
      else E.eval h k (E.constantFamily b) u := by
  by_cases huv : u.val < v.val
  · rw [if_pos huv]
    apply E.eval_congr_descendants
    intro j _ s hs
    simp [afterFamily, hs, huv]
  · rw [if_neg huv]
    apply E.eval_congr_descendants
    intro j _ s hs
    simp [afterFamily, constantFamily, hs, huv]

theorem label_error
    (τ : ℕ → ℝ) (e : ℝ) (he : 0 ≤ e) (k : ℕ)
    (haverage : ∀ i u, ‖(E.average i (E.label (i + 1)) u : X) - E.x‖ ≤ τ i)
    (htau : ∀ i, k ≤ i → τ i ≤ e * (1 / 2 : ℝ) ^ (i + 1))
    (h i : ℕ) (hi : k ≤ i) (u : T.Node i) :
    ‖(E.eval h i E.label u : X) - E.label i u‖ ≤ e * (1 / 2 : ℝ) ^ i := by
  induction h generalizing i u with
  | zero =>
      simpa only [eval, sub_self, norm_zero] using
        mul_nonneg he (pow_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 2) i)
  | succ h ih =>
      have hchild (c : T.Node (i + 1)) :
          ‖(E.eval h (i + 1) E.label c : X) - E.label (i + 1) c‖ ≤
            e * (1 / 2 : ℝ) ^ (i + 1) := ih (i + 1) (by omega) c
      change ‖(E.map i u (E.average i (E.eval h (i + 1) E.label) u) : X) -
        E.map i u E.x‖ ≤ _
      calc
        _ ≤ ‖(E.average i (E.eval h (i + 1) E.label) u : X) - E.x‖ :=
          E.nonexpansive i u _ _
        _ ≤ ‖(E.average i (E.eval h (i + 1) E.label) u : X) -
              E.average i (E.label (i + 1)) u‖ +
              ‖(E.average i (E.label (i + 1)) u : X) - E.x‖ :=
          norm_triangle_sub _ _ _
        _ ≤ (∑ c, T.childWeight i u c *
              ‖(E.eval h (i + 1) E.label c : X) - E.label (i + 1) c‖) + τ i :=
          add_le_add (E.average_difference i _ _ u) (haverage i u)
        _ ≤ (∑ c, T.childWeight i u c * (e * (1 / 2 : ℝ) ^ (i + 1))) +
              e * (1 / 2 : ℝ) ^ (i + 1) := by
          apply add_le_add _ (htau i hi)
          apply Finset.sum_le_sum
          intro c _
          exact mul_le_mul_of_nonneg_left (hchild c) (T.childWeight_nonneg i u c)
        _ = e * (1 / 2 : ℝ) ^ i := by
          rw [← Finset.sum_mul, T.sum_childWeight, one_mul, pow_succ]
          ring

theorem constant_error (b : K) (η : ℝ) (_hη : 0 ≤ η) (N h i : ℕ)
    (hi : i + h ≤ N)
    (hdisplacement : ∀ j, j < N → ∀ u, ‖(E.map j u b : X) - b‖ ≤ η)
    (u : T.Node i) :
    ‖(E.eval h i (E.constantFamily b) u : X) - b‖ ≤ h * η := by
  induction h generalizing i u with
  | zero => simp [eval, constantFamily]
  | succ h ih =>
      change ‖(E.map i u (E.average i (E.eval h (i + 1)
        (E.constantFamily b)) u) : X) - b‖ ≤ _
      calc
        _ ≤ ‖(E.map i u (E.average i (E.eval h (i + 1)
              (E.constantFamily b)) u) : X) - E.map i u b‖ +
              ‖(E.map i u b : X) - b‖ := norm_triangle_sub _ _ _
        _ ≤ ‖(E.average i (E.eval h (i + 1) (E.constantFamily b)) u : X) - b‖ + η :=
          add_le_add (E.nonexpansive i u _ _) (hdisplacement i (by omega) u)
        _ = ‖(E.average i (E.eval h (i + 1) (E.constantFamily b)) u : X) -
              E.average i (fun _ => b) u‖ + η := by rw [E.average_constant]
        _ ≤ (∑ c, T.childWeight i u c *
              ‖(E.eval h (i + 1) (E.constantFamily b) c : X) - b‖) + η :=
          add_le_add (E.average_difference i _ _ u) (le_refl η)
        _ ≤ (∑ c, T.childWeight i u c * (h * η)) + η := by
          apply add_le_add _ (le_refl η)
          apply Finset.sum_le_sum
          intro c _
          exact mul_le_mul_of_nonneg_left (ih (i + 1) (by omega) c)
            (T.childWeight_nonneg i u c)
        _ = (h + 1 : ℕ) * η := by
          rw [← Finset.sum_mul, T.sum_childWeight, one_mul, Nat.cast_add, Nat.cast_one]
          ring

theorem root_factor {k n : ℕ} (h : k ≤ n) (H : ∀ j, T.Node j → K) :
    E.rootOutput n H =
      E.rootOutput k (fun j => E.eval (n - k) j H) := by
  unfold rootOutput
  simpa only [Nat.add_sub_of_le h] using
    congrFun (E.eval_add k (n - k) 0 H) T.root

structure Bounds (E : Evaluation T K) where
  budget : ∀ k, T.Node k → ℝ
  budget_nonneg : ∀ k v, 0 ≤ budget k v
  budget_pos : ∀ k, 0 < k → ∀ v, 0 < budget k v
  budget_zero : ∀ v, budget 0 v = 0
  tolerance : ℕ → ℝ
  average_error : ∀ k v,
    ‖(E.average k (E.label (k + 1)) v : X) - E.x‖ ≤ tolerance k
  tolerance_bound : ∀ k, 0 < k → ∀ v i, k ≤ i →
    tolerance i ≤ budget k v * (1 / 2 : ℝ) ^ (i + 1)
  path_error : ∀ k, 0 < k → ∀ v,
    (∑ i ∈ Finset.range k,
      ‖(E.map i (T.ancestor i k v) (E.label k v) : X) - E.label k v‖) ≤ budget k v

def Bounds.fromManuscript
    (e : ∀ k, T.Node k → ℝ) (he : ∀ k v, 0 ≤ e k v)
    (hepos : ∀ k, 0 < k → ∀ v, 0 < e k v) (hezero : ∀ v, e 0 v = 0)
    (haverage : ∀ k v, ‖(E.average k (E.label (k + 1)) v : X) - E.x‖ ≤
      T.manuscriptTolerance e k)
    (hpath : ∀ k, 0 < k → ∀ v,
      (∑ i ∈ Finset.range k,
        ‖(E.map i (T.ancestor i k v) (E.label k v) : X) - E.label k v‖) ≤ e k v) :
    E.Bounds where
  budget := e
  budget_nonneg := he
  budget_pos := hepos
  budget_zero := hezero
  tolerance := T.manuscriptTolerance e
  average_error := haverage
  tolerance_bound := by
    intro k hk v i hi
    cases k with
    | zero => omega
    | succ k => exact T.manuscriptTolerance_le e hi v
  path_error := hpath

theorem after_block_error (B : E.Bounds) {k n : ℕ} (hk : 0 < k) (h : k ≤ n)
    (v : T.Node k) (b : K) (η : ℝ) (hη : 0 ≤ η)
    (hdisplacement : ∀ j, j < n → ∀ u, ‖(E.map j u b : X) - b‖ ≤ η)
    (hnη : (n : ℝ) * η ≤ B.budget k v) :
    ‖(E.afterBlock n k v b : X) - E.prediction k v b‖ ≤ B.budget k v := by
  unfold afterBlock prediction
  rw [E.root_factor h]
  apply E.root_uniform
  intro u
  rw [E.afterFamily_subtree]
  by_cases huv : u.val < v.val
  · simp only [if_pos huv, idealFamily]
    refine (E.label_error B.tolerance (B.budget k v) (B.budget_nonneg k v) k
      B.average_error (B.tolerance_bound k hk v) (n - k) k le_rfl u).trans ?_
    exact mul_le_of_le_one_right (B.budget_nonneg k v)
      (pow_le_one₀ (by norm_num) (by norm_num))
  · simp only [if_neg huv, idealFamily]
    refine (E.constant_error b η hη n (n - k) k (by omega) hdisplacement u).trans ?_
    exact (mul_le_mul_of_nonneg_right (by exact_mod_cast Nat.sub_le n k) hη).trans hnη

theorem collapse_point_bound
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (i : ℕ) (H : T.Node (i + 1) → K) (p : T.Node i)
    (c : T.Node (i + 1)) (hc : T.parent i c = p) (y : K) :
    ‖(E.collapse i H p : X) - y‖ ≤
      T.alpha i c * ‖(H c : X) - y‖ + (1 - T.alpha i c) +
        ‖(E.map i p y : X) - y‖ := by
  have ha := distinguished_average (T.childWeight i p)
    (fun s => ‖(H s : X) - y‖) (T.childWeight_nonneg i p)
    (T.sum_childWeight i p) (fun s => hdiam (H s) y) c
  simp only [PlaneTree.childWeight, hc, if_true] at ha
  calc
    _ ≤ ‖(E.map i p (E.average i H p) : X) - E.map i p y‖ +
          ‖(E.map i p y : X) - y‖ := norm_triangle_sub _ _ _
    _ ≤ ‖(E.average i H p : X) - y‖ + ‖(E.map i p y : X) - y‖ :=
      add_le_add (E.nonexpansive i p _ _) (le_refl _)
    _ = ‖(E.average i H p : X) - E.average i (fun _ => y) p‖ +
          ‖(E.map i p y : X) - y‖ := by rw [E.average_constant]
    _ ≤ (∑ s, T.childWeight i p s * ‖(H s : X) - y‖) +
          ‖(E.map i p y : X) - y‖ :=
      add_le_add (E.average_difference i H (fun _ => y) p) (le_refl _)
    _ ≤ _ := add_le_add ha (le_refl _)

theorem before_block_error (B : E.Bounds)
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    {k n : ℕ} (hk : 0 < k) (h : k ≤ n) (v : T.Node k) (b : K) :
    ‖(E.beforeBlock n k v b : X) - E.label k v‖ ≤
      1 - T.weight k v + 2 * B.budget k v := by
  let F := E.beforeFamily k v b
  let w : ℕ → ℝ := fun i => T.weight i (T.ancestor i k v)
  let a : ℕ → ℝ := fun i =>
    ‖(E.eval (n - i) i F (T.ancestor i k v) : X) - E.label k v‖
  let d : ℕ → ℝ := fun i =>
    ‖(E.map i (T.ancestor i k v) (E.label k v) : X) - E.label k v‖
  have hw0 : w 0 = 1 := rfl
  have hstep : ∀ i < k,
      w i * a i ≤ w i - w (i + 1) + w (i + 1) * a (i + 1) + d i := by
    intro i hi
    have hc := T.ancestor_top i k hi v
    have hn : n - i = (n - (i + 1)) + 1 := by omega
    have hl := E.collapse_point_bound hdiam i
      (E.eval (n - (i + 1)) (i + 1) F)
      (T.ancestor i k v) (T.ancestor (i + 1) k v) hc (E.label k v)
    have hlocal : a i ≤ T.alpha i (T.ancestor (i + 1) k v) * a (i + 1) +
        (1 - T.alpha i (T.ancestor (i + 1) k v)) + d i := by
      simpa only [a, d, hn, eval] using hl
    have hweight : w (i + 1) = w i * T.alpha i (T.ancestor (i + 1) k v) := by
      simp only [w, PlaneTree.weight, hc]
    have hwd : w i * d i ≤ d i :=
      mul_le_of_le_one_left (norm_nonneg _) (T.weight_le_one i _)
    calc
      w i * a i ≤ w i * (T.alpha i (T.ancestor (i + 1) k v) * a (i + 1) +
          (1 - T.alpha i (T.ancestor (i + 1) k v)) + d i) :=
        mul_le_mul_of_nonneg_left hlocal (T.weight_pos i _).le
      _ = w i - w (i + 1) + w (i + 1) * a (i + 1) + w i * d i := by
        rw [hweight]
        ring
      _ ≤ _ := add_le_add (le_refl _) hwd
  have hpath := path_recurrence k w a d hw0 hstep
  have hak : a k ≤ B.budget k v := by
    simp only [a, T.ancestor_self]
    rw [E.beforeFamily_untouched]
    refine (E.label_error B.tolerance (B.budget k v) (B.budget_nonneg k v) k
      B.average_error (B.tolerance_bound k hk v) (n - k) k le_rfl v).trans ?_
    exact mul_le_of_le_one_right (B.budget_nonneg k v)
      (pow_le_one₀ (by norm_num) (by norm_num))
  have hwak : w k * a k ≤ B.budget k v :=
    (mul_le_mul_of_nonneg_left hak (T.weight_pos k _).le).trans
      (mul_le_of_le_one_left (B.budget_nonneg k v) (T.weight_le_one k _))
  have hsum : (∑ i ∈ Finset.range k, d i) ≤ B.budget k v := B.path_error k hk v
  have ha0 : a 0 = ‖(E.beforeBlock n k v b : X) - E.label k v‖ := by
    simp only [a, Nat.sub_zero, T.eq_root, beforeBlock, rootOutput, F]
  have hwk : w k = T.weight k v := by simp only [w, T.ancestor_self]
  rw [ha0, hwk] at hpath
  rw [hwk] at hwak
  linarith

end Evaluation

theorem abs_apply_le (f : X →L[ℝ] ℝ) (hf : ‖f‖ ≤ 1) (x : X) :
    |f x| ≤ ‖x‖ := by
  calc
    |f x| = ‖f x‖ := (Real.norm_eq_abs _).symm
    _ ≤ ‖f‖ * ‖x‖ := f.le_opNorm x
    _ ≤ ‖x‖ := mul_le_of_le_one_left (norm_nonneg _) hf

namespace Evaluation

variable {T : PlaneTree} {K : Set X} (E : Evaluation T K)

theorem block_detection (B : E.Bounds)
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    {k n : ℕ} (hk : 0 < k) (h : k ≤ n) (v : T.Node k) (b : K)
    (η : ℝ) (hη : 0 ≤ η)
    (hdisplacement : ∀ j, j < n → ∀ u, ‖(E.map j u b : X) - b‖ ≤ η)
    (hnη : (n : ℝ) * η ≤ B.budget k v)
    (f : X →L[ℝ] ℝ) (hf : ‖f‖ ≤ 1)
    (hdetect : 1 - 2 * B.budget k v ≤ f ((E.label k v : X) - E.prediction k v b)) :
    T.weight k v - 5 * B.budget k v ≤
      f ((E.beforeBlock n k v b : X) - E.afterBlock n k v b) := by
  have hbefore := E.before_block_error B hdiam hk h v b
  have hafter := E.after_block_error B hk h v b η hη hdisplacement hnη
  have hu := abs_apply_le f hf ((E.beforeBlock n k v b : X) - E.label k v)
  have hv := abs_apply_le f hf ((E.afterBlock n k v b : X) - E.prediction k v b)
  have hlu := (abs_le.mp hu).1
  have huv := (abs_le.mp hv).2
  simp only [map_sub] at hlu huv hdetect ⊢
  linarith

theorem single_switch_norm
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (n : ℕ) (s : T.Node n) (b : K) :
    ‖(E.switchRoot n (s.val + 1) b : X) - E.switchRoot n s.val b‖ ≤ T.weight n s := by
  refine (E.root_sensitivity n (E.leafFamily (s.val + 1) b)
    (E.leafFamily s.val b)).trans ?_
  calc
    (∑ v, T.weight n v *
        ‖(E.leafFamily (s.val + 1) b n v : X) - E.leafFamily s.val b n v‖) ≤
        ∑ v, if v = s then T.weight n s else 0 := by
      apply Finset.sum_le_sum
      intro v _
      by_cases hv : v = s
      · subst v
        simp only [leafFamily, Nat.lt_succ_self, lt_self_iff_false, if_true, if_false]
        exact mul_le_of_le_one_right (T.weight_pos n s).le (hdiam _ _)
      · have hv' : v.val ≠ s.val := fun h => hv (Fin.ext h)
        have heq : (v.val < s.val + 1) ↔ (v.val < s.val) := by omega
        simp only [leafFamily, heq, sub_self, norm_zero, mul_zero, hv, if_false]
        exact le_rfl
    _ = T.weight n s := by simp

def switchVector (n : ℕ) (s : T.Node n) (b : K) : X :=
  (T.weight n s)⁻¹ •
    ((E.switchRoot n (s.val + 1) b : X) - E.switchRoot n s.val b)

theorem switchVector_norm
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (n : ℕ) (s : T.Node n) (b : K) :
    ‖E.switchVector n s b‖ ≤ 1 := by
  rw [switchVector, norm_smul, Real.norm_of_nonneg (inv_nonneg.mpr (T.weight_pos n s).le)]
  calc
    (T.weight n s)⁻¹ *
        ‖(E.switchRoot n (s.val + 1) b : X) - E.switchRoot n s.val b‖ ≤
        (T.weight n s)⁻¹ * T.weight n s :=
      mul_le_mul_of_nonneg_left (E.single_switch_norm hdiam n s b)
        (inv_nonneg.mpr (T.weight_pos n s).le)
    _ = 1 := inv_mul_cancel₀ (ne_of_gt (T.weight_pos n s))

theorem weighted_switchVector (n : ℕ) (s : T.Node n) (b : K) :
    T.weight n s • E.switchVector n s b =
      (E.switchRoot n (s.val + 1) b : X) - E.switchRoot n s.val b := by
  rw [switchVector, smul_smul, mul_inv_cancel₀ (ne_of_gt (T.weight_pos n s)), one_smul]

theorem deficit_nonneg
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (n : ℕ) (s : T.Node n) (b : K) (f : X →L[ℝ] ℝ) (hf : ‖f‖ ≤ 1) :
    0 ≤ 1 - f (E.switchVector n s b) := by
  have hupper := (le_abs_self (f (E.switchVector n s b))).trans
    ((abs_apply_le f hf _).trans (E.switchVector_norm hdiam n s b))
  linarith

theorem block_telescope {k n : ℕ} (h : k ≤ n) (v : T.Node k) (b : K) :
    (∑ s, if T.ancestor k n s = v then T.weight n s • E.switchVector n s b else 0) =
      (E.beforeBlock n k v b : X) - E.afterBlock n k v b := by
  calc
    _ = ∑ s : T.Node n, if T.lo k n v ≤ s.val ∧ s.val < T.hi k n v then
          ((E.switchRoot n (s.val + 1) b : X) - E.switchRoot n s.val b) else 0 := by
      apply Finset.sum_congr rfl
      intro s _
      simp only [← T.in_block h v s]
      split_ifs
      · exact E.weighted_switchVector n s b
      · rfl
    _ = ∑ i ∈ Finset.Ico (T.lo k n v) (T.hi k n v),
          ((E.switchRoot n (i + 1) b : X) - E.switchRoot n i b) :=
      sum_fin_interval (T.count n) (T.lo k n v) (T.hi k n v) (T.hi_le k n h v)
        (fun i => (E.switchRoot n (i + 1) b : X) - E.switchRoot n i b)
    _ = (E.switchRoot n (T.hi k n v) b : X) - E.switchRoot n (T.lo k n v) b :=
      Finset.sum_Ico_sub (fun i => (E.switchRoot n i b : X)) (T.lo_le_hi k n h v)
    _ = _ := by
      rw [E.beforeBlock_eq_switchRoot h, E.afterBlock_eq_switchRoot h]

theorem block_deficit {k n : ℕ} (h : k ≤ n) (v : T.Node k) (b : K)
    (f : X →L[ℝ] ℝ) (e : ℝ)
    (hdetect : T.weight k v - 5 * e ≤
      f ((E.beforeBlock n k v b : X) - E.afterBlock n k v b)) :
    (∑ s, if T.ancestor k n s = v then
      T.weight n s * (1 - f (E.switchVector n s b)) else 0) ≤ 5 * e := by
  have ht := congrArg f (E.block_telescope h v b)
  simp only [map_sum, apply_ite, map_smul, smul_eq_mul, map_zero] at ht
  have hid :
      (∑ s, if T.ancestor k n s = v then
        T.weight n s * (1 - f (E.switchVector n s b)) else 0) =
        T.weight k v - f ((E.beforeBlock n k v b : X) - E.afterBlock n k v b) := by
    calc
      _ = (∑ s, if T.ancestor k n s = v then T.weight n s else 0) -
          (∑ s, if T.ancestor k n s = v then
            T.weight n s * f (E.switchVector n s b) else 0) := by
        rw [← Finset.sum_sub_distrib]
        apply Finset.sum_congr rfl
        intro s _
        split_ifs <;> ring
      _ = _ := by rw [T.block_mass h v, ht]
  rw [hid]
  linarith

def pathDeficit (f : ∀ k, T.Node k → X →L[ℝ] ℝ)
    (n : ℕ) (s : T.Node n) (b : K) : ℝ :=
  ∑ i ∈ Finset.range n,
    (1 - f (i + 1) (T.ancestor (i + 1) n s) (E.switchVector n s b))

theorem total_deficit
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ)
    (e : ∀ k, T.Node k → ℝ) (n : ℕ) (b : K)
    (hbudget : (∑ i ∈ Finset.range n, ∑ v, e (i + 1) v) ≤ (1 : ℝ) / 128)
    (hblocks : ∀ i, i < n → ∀ v, T.weight (i + 1) v - 5 * e (i + 1) v ≤
      f (i + 1) v ((E.beforeBlock n (i + 1) v b : X) - E.afterBlock n (i + 1) v b)) :
    (∑ s, T.weight n s * E.pathDeficit f n s b) ≤ (5 : ℝ) / 128 := by
  have hlevel (i : ℕ) (hi : i < n) :
      (∑ s, T.weight n s *
        (1 - f (i + 1) (T.ancestor (i + 1) n s) (E.switchVector n s b))) ≤
          ∑ v, 5 * e (i + 1) v := by
    calc
      _ = ∑ v : T.Node (i + 1), ∑ s : T.Node n,
            if T.ancestor (i + 1) n s = v then
              T.weight n s * (1 - f (i + 1) v (E.switchVector n s b)) else 0 := by
        rw [Finset.sum_comm]
        apply Finset.sum_congr rfl
        intro s _
        simp
      _ ≤ _ := Finset.sum_le_sum (fun v _ =>
        E.block_deficit (by omega) v b (f (i + 1) v) (e (i + 1) v) (hblocks i hi v))
  calc
    _ = ∑ i ∈ Finset.range n, ∑ s, T.weight n s *
          (1 - f (i + 1) (T.ancestor (i + 1) n s) (E.switchVector n s b)) := by
      simp only [pathDeficit, Finset.mul_sum]
      rw [Finset.sum_comm]
    _ ≤ ∑ i ∈ Finset.range n, ∑ v, 5 * e (i + 1) v :=
      Finset.sum_le_sum (fun i hi => hlevel i (Finset.mem_range.mp hi))
    _ = 5 * (∑ i ∈ Finset.range n, ∑ v, e (i + 1) v) := by
      simp only [Finset.mul_sum]
    _ ≤ (5 : ℝ) / 128 := by linarith

theorem finite_witness
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ) (hf : ∀ k v, ‖f k v‖ ≤ 1)
    (e : ∀ k, T.Node k → ℝ) (n : ℕ) (b : K)
    (hbudget : (∑ i ∈ Finset.range n, ∑ v, e (i + 1) v) ≤ (1 : ℝ) / 128)
    (hblocks : ∀ i, i < n → ∀ v, T.weight (i + 1) v - 5 * e (i + 1) v ≤
      f (i + 1) v ((E.beforeBlock n (i + 1) v b : X) - E.afterBlock n (i + 1) v b)) :
    ∃ s : T.Node n, ‖E.switchVector n s b‖ ≤ 1 ∧
      ∀ i, i < n → (1 / 2 : ℝ) <
        f (i + 1) (T.ancestor (i + 1) n s) (E.switchVector n s b) := by
  have hnonneg (s : T.Node n) (i : ℕ) :
      0 ≤ 1 - f (i + 1) (T.ancestor (i + 1) n s) (E.switchVector n s b) := by
    exact E.deficit_nonneg hdiam n s b _ (hf _ _)
  have htotal := E.total_deficit f e n b hbudget hblocks
  by_contra hnone
  have hbad : ∀ s : T.Node n, ∃ i < n,
      f (i + 1) (T.ancestor (i + 1) n s) (E.switchVector n s b) ≤ (1 / 2 : ℝ) := by
    intro s
    by_contra hs
    push Not at hs
    exact hnone ⟨s, E.switchVector_norm hdiam n s b, hs⟩
  have hcost (s : T.Node n) : (1 / 2 : ℝ) ≤ E.pathDeficit f n s b := by
    obtain ⟨i, hi, hfi⟩ := hbad s
    have hsingle := Finset.single_le_sum (fun j _ => hnonneg s j)
      (Finset.mem_range.mpr hi)
    change (1 / 2 : ℝ) ≤ ∑ j ∈ Finset.range n,
      (1 - f (j + 1) (T.ancestor (j + 1) n s) (E.switchVector n s b))
    linarith
  have hlower : (1 / 2 : ℝ) ≤ ∑ s, T.weight n s * E.pathDeficit f n s b := by
    calc
      (1 / 2 : ℝ) = ∑ s, T.weight n s * (1 / 2 : ℝ) := by
        rw [← Finset.sum_mul, T.sum_weight, one_mul]
      _ ≤ _ := Finset.sum_le_sum (fun s _ =>
        mul_le_mul_of_nonneg_left (hcost s) (T.weight_pos n s).le)
  linarith

end Evaluation

structure TerminalData {T : PlaneTree} {K : Set X}
    (E : Evaluation T K) (B : E.Bounds)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ) where
  terminal : ℕ → K
  ultrafilter : Filter ℕ
  proper : ultrafilter.NeBot
  le_atTop : ultrafilter ≤ atTop
  displacement_tendsto : ∀ k v,
    Tendsto (fun j => ‖(E.map k v (terminal j) : X) - terminal j‖) atTop (𝓝 0)
  limit : ∀ k, T.Node k → ℝ
  prediction_tendsto : ∀ k, 0 < k → ∀ v,
    Tendsto (fun j => f k v ((E.label k v : X) - E.prediction k v (terminal j)))
      ultrafilter (𝓝 (limit k v))
  limit_detection : ∀ k, 0 < k → ∀ v, 1 - B.budget k v ≤ limit k v

namespace TerminalData

variable {T : PlaneTree} {K : Set X} {E : Evaluation T K} {B : E.Bounds}
variable {f : ∀ k, T.Node k → X →L[ℝ] ℝ}

theorem common_terminal (A : TerminalData E B f) (N : ℕ) (hN : 0 < N) :
    ∃ j η, 0 ≤ η ∧
      (∀ i, i < N → ∀ u, ‖(E.map i u (A.terminal j) : X) - A.terminal j‖ ≤ η) ∧
      (∀ i, i < N → ∀ v,
        (1 - 2 * B.budget (i + 1) v ≤
          f (i + 1) v ((E.label (i + 1) v : X) -
            E.prediction (i + 1) v (A.terminal j))) ∧
        (N : ℝ) * η ≤ B.budget (i + 1) v) := by
  letI : A.ultrafilter.NeBot := A.proper
  let I := (Σ i : Fin N, T.Node (i.val + 1))
  let J := (Σ i : Fin N, T.Node i.val)
  let es : I → ℝ := fun v => B.budget (v.1.val + 1) v.2
  let v0 : I := ⟨⟨0, hN⟩, ⟨0, T.count_pos 1⟩⟩
  have hne : (Finset.univ : Finset I).Nonempty := ⟨v0, Finset.mem_univ _⟩
  let m := (Finset.univ : Finset I).inf' hne es
  have hpos (v : I) : 0 < es v := B.budget_pos _ (Nat.succ_pos _) _
  have hm : 0 < m := (Finset.lt_inf'_iff hne).mpr (fun v _ => hpos v)
  have hmle (v : I) : m ≤ es v := Finset.inf'_le _ (Finset.mem_univ v)
  have hNR : (0 : ℝ) < N := by exact_mod_cast hN
  let η : ℝ := m / N
  have hη : 0 < η := div_pos hm hNR
  have hNη : (N : ℝ) * η = m := by
    dsimp [η]
    field_simp
  have hpred : ∀ᶠ j in A.ultrafilter, ∀ v : I,
      1 - 2 * es v ≤ f (v.1.val + 1) v.2
        ((E.label (v.1.val + 1) v.2 : X) -
          E.prediction (v.1.val + 1) v.2 (A.terminal j)) := by
    apply Filter.eventually_all.mpr
    intro v
    have ht := A.prediction_tendsto (v.1.val + 1) (Nat.succ_pos _) v.2
    have hd := A.limit_detection (v.1.val + 1) (Nat.succ_pos _) v.2
    have hstrict : 1 - 2 * es v < A.limit (v.1.val + 1) v.2 := by
      have := hpos v
      change 1 - es v ≤ _ at hd
      linarith
    exact ((tendsto_order.mp ht).1 _ hstrict).mono (fun _ hj => hj.le)
  have hdisp : ∀ᶠ j in A.ultrafilter, ∀ v : J,
      ‖(E.map v.1.val v.2 (A.terminal j) : X) - A.terminal j‖ ≤ η := by
    apply Filter.eventually_all.mpr
    intro v
    have ht := (A.displacement_tendsto v.1.val v.2).mono_left A.le_atTop
    exact ((tendsto_order.mp ht).2 η hη).mono (fun _ hj => hj.le)
  obtain ⟨j, hjpred, hjdisp⟩ := (hpred.and hdisp).exists
  refine ⟨j, η, hη.le, ?_, ?_⟩
  · intro i hi u
    exact hjdisp ⟨⟨i, hi⟩, u⟩
  · intro i hi v
    refine ⟨hjpred ⟨⟨i, hi⟩, v⟩, ?_⟩
    rw [hNη]
    exact hmle ⟨⟨i, hi⟩, v⟩

end TerminalData

namespace Evaluation

variable {T : PlaneTree} {K : Set X} (E : Evaluation T K)

theorem finite_witness_from_inputs (B : E.Bounds)
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ) (hf : ∀ k v, ‖f k v‖ ≤ 1)
    (A : TerminalData E B f)
    (hbudget : ∀ n, (∑ i ∈ Finset.range n, ∑ v, B.budget (i + 1) v) ≤ (1 : ℝ) / 128)
    (N : ℕ) (hN : 0 < N) :
    ∃ j, ∃ s : T.Node N, ‖E.switchVector N s (A.terminal j)‖ ≤ 1 ∧
      ∀ i, i < N → (1 / 2 : ℝ) <
        f (i + 1) (T.ancestor (i + 1) N s) (E.switchVector N s (A.terminal j)) := by
  obtain ⟨j, η, hη, hdisp, hpred⟩ := A.common_terminal N hN
  obtain ⟨s, hs, hd⟩ := E.finite_witness hdiam f hf B.budget N (A.terminal j)
    (hbudget N) (fun i hi v =>
      E.block_detection B hdiam (Nat.succ_pos i) (by omega) v (A.terminal j) η hη
        hdisp (hpred i hi v).2 (f (i + 1) v) (hf _ _) (hpred i hi v).1)
  exact ⟨j, s, hs, hd⟩

end Evaluation

theorem finite_witnesses_to_common_branch
    {T : PlaneTree} (f : ∀ k, T.Node k → X →L[ℝ] ℝ)
    {Q : Type*} [TopologicalSpace Q] [CompactSpace Q]
    (point : Q → X) (hpoint : ∀ q, ‖point q‖ ≤ 1)
    (honto : ∀ d : X, ‖d‖ ≤ 1 → ∃ q, point q = d)
    (hcontinuous : ∀ k v, Continuous (fun q => f k v (point q)))
    (hfinite : ∀ N, 0 < N → ∃ s : T.Node N, ∃ d : X, ‖d‖ ≤ 1 ∧
      ∀ i, i < N → (1 / 2 : ℝ) ≤ f (i + 1) (T.ancestor (i + 1) N s) d) :
    ∃ branch : (∀ k, T.Node k), ∃ d : X, ‖d‖ ≤ 1 ∧
      (∀ n, T.parent n (branch (n + 1)) = branch n) ∧
      (∀ n, (1 / 2 : ℝ) ≤ f (n + 1) (branch (n + 1)) d) := by
  let Z := Q × (∀ k, T.Node k)
  let C : ℕ → Set Z := fun n => {z | ∃ v : T.Node (n + 1),
    z.2 (n + 1) = v ∧ T.parent n v = z.2 n ∧
      (1 / 2 : ℝ) ≤ f (n + 1) v (point z.1)}
  have hC (n : ℕ) : IsClosed (C n) := by
    have heq : C n = ⋃ v : T.Node (n + 1), {z : Z |
      z.2 (n + 1) = v ∧ T.parent n v = z.2 n ∧
        (1 / 2 : ℝ) ≤ f (n + 1) v (point z.1)} := by
      ext z
      simp only [C, Set.mem_setOf_eq, Set.mem_iUnion]
    rw [heq]
    apply isClosed_iUnion_of_finite
    intro v
    exact (isClosed_eq ((continuous_apply (n + 1)).comp continuous_snd)
      continuous_const).inter
      ((isClosed_eq continuous_const ((continuous_apply n).comp continuous_snd)).inter
        (isClosed_le continuous_const ((hcontinuous (n + 1) v).comp continuous_fst)))
  have hFIP (u : Finset ℕ) : (Set.univ ∩ ⋂ n ∈ u, C n).Nonempty := by
    let N := u.sup id + 1
    have hN : 0 < N := Nat.succ_pos _
    obtain ⟨s, d, hd, hdetect⟩ := hfinite N hN
    obtain ⟨q, hq⟩ := honto d hd
    let a : ∀ k, T.Node k := fun k =>
      if k ≤ N then T.ancestor k N s else ⟨0, T.count_pos k⟩
    refine ⟨(q, a), Set.mem_univ _, ?_⟩
    apply Set.mem_iInter.mpr
    intro n
    apply Set.mem_iInter.mpr
    intro hn
    have hnN : n < N := by
      have hsup : n ≤ u.sup id := Finset.le_sup (f := id) hn
      omega
    refine ⟨T.ancestor (n + 1) N s, ?_, ?_, ?_⟩
    · simp only [a, if_pos (show n + 1 ≤ N by omega)]
    · simp only [a, if_pos (show n ≤ N by omega)]
      exact T.ancestor_top n N hnN s
    · rw [hq]
      exact hdetect n hnN
  obtain ⟨z, _, hz⟩ := isCompact_univ.inter_iInter_nonempty C hC hFIP
  refine ⟨z.2, point z.1, hpoint z.1, ?_, ?_⟩
  · intro n
    obtain ⟨v, hv, hp, _⟩ := Set.mem_iInter.mp hz n
    rw [hv]
    exact hp
  · intro n
    obtain ⟨v, hv, _, hf⟩ := Set.mem_iInter.mp hz n
    rw [hv]
    exact hf

theorem detector_pair_bound (f : X →L[ℝ] ℝ) (hf : ‖f‖ ≤ 1)
    (y a b : X) (e : ℝ) (ha : ‖y - a‖ ≤ 1) (hb : ‖y - b‖ ≤ 1)
    (hfa : 1 - e ≤ f (y - a)) (hfb : 1 - e ≤ f (y - b)) :
    |f (a - b)| ≤ e := by
  have hua := (le_abs_self (f (y - a))).trans ((abs_apply_le f hf _).trans ha)
  have hub := (le_abs_self (f (y - b))).trans ((abs_apply_le f hf _).trans hb)
  simp only [map_sub] at hfa hfb hua hub ⊢
  exact abs_le.mpr ⟨by linarith, by linarith⟩

theorem vanishing_on_closed_span
    (g : ℕ → X →L[ℝ] ℝ) (hg : ∀ n, ‖g n‖ ≤ 1) (S : Set X)
    (hS : ∀ x ∈ S, Tendsto (fun n => g n x) atTop (𝓝 0))
    (d : X) (hd : d ∈ closure (Submodule.span ℝ S : Set X)) :
    Tendsto (fun n => g n d) atTop (𝓝 0) := by
  have hspan : ∀ x ∈ Submodule.span ℝ S,
      Tendsto (fun n => g n x) atTop (𝓝 0) := by
    intro x hx
    refine Submodule.span_induction (p := fun x _ =>
      Tendsto (fun n => g n x) atTop (𝓝 0)) ?_ ?_ ?_ ?_ hx
    · exact hS
    · simpa only [map_zero] using
        (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0))
    · intro a b _ _ hta htb
      simpa only [map_add, zero_add] using hta.add htb
    · intro c a _ hta
      simpa only [map_smul, smul_eq_mul, mul_zero] using hta.const_mul c
  apply Metric.tendsto_atTop.mpr
  intro ε hε
  obtain ⟨a, ha, hda⟩ := Metric.mem_closure_iff.mp hd (ε / 2) (by linarith)
  obtain ⟨N, hN⟩ := Metric.tendsto_atTop.mp (hspan a ha) (ε / 2) (by linarith)
  refine ⟨N, ?_⟩
  intro n hn
  have hsmall : |g n a| < ε / 2 := by
    simpa only [Real.dist_eq, sub_zero] using hN n hn
  have hdiff : |g n d - g n a| ≤ ‖d - a‖ := by
    simpa only [map_sub] using abs_apply_le (g n) (hg n) (d - a)
  have htriangle : |g n d| ≤ |g n d - g n a| + |g n a| := by
    simpa only [Real.norm_eq_abs, sub_zero] using norm_triangle_sub (g n d) (g n a) 0
  rw [dist_eq_norm] at hda
  rw [Real.dist_eq, sub_zero]
  linarith

theorem pointwise_null_detectors
    {T : PlaneTree} {K : Set X} (E : Evaluation T K) (B : E.Bounds)
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ) (hf : ∀ k v, ‖f k v‖ ≤ 1)
    (z : ℕ → K)
    (hdense : closure (Submodule.span ℝ
      (Set.range (fun ij : ℕ × ℕ => (z ij.1 : X) - z ij.2)) : Set X) = Set.univ)
    (hdetector : ∀ k v i, i < k →
      1 - B.budget k v ≤ f k v ((E.label k v : X) - z i))
    (hsummable : Summable (fun v : Σ k, T.Node k => B.budget v.1 v.2))
    (branch : ∀ k, T.Node k) (d : X) :
    Tendsto (fun n => f (n + 1) (branch (n + 1)) d) atTop (𝓝 0) := by
  let index : ℕ → Σ k, T.Node k := fun n => ⟨n + 1, branch (n + 1)⟩
  have hinj : Function.Injective index := by
    intro i j hij
    have h := congrArg (fun v : Σ k, T.Node k => v.1) hij
    change i + 1 = j + 1 at h
    omega
  have hezero : Tendsto (fun n => B.budget (n + 1) (branch (n + 1))) atTop (𝓝 0) :=
    (hsummable.comp_injective hinj).tendsto_atTop_zero
  let g : ℕ → X →L[ℝ] ℝ := fun n => f (n + 1) (branch (n + 1))
  refine vanishing_on_closed_span g (fun n => hf _ _)
    (Set.range (fun ij : ℕ × ℕ => (z ij.1 : X) - z ij.2)) ?_ d ?_
  · rintro x ⟨⟨i, j⟩, rfl⟩
    apply squeeze_zero_norm' (a := fun n => B.budget (n + 1) (branch (n + 1))) _ hezero
    refine Filter.eventually_atTop.mpr ⟨max i j, ?_⟩
    intro n hn
    have hi : i < n + 1 := by omega
    have hj : j < n + 1 := by omega
    have hpair := detector_pair_bound (g n) (hf _ _)
      (E.label (n + 1) (branch (n + 1))) (z i) (z j)
      (B.budget (n + 1) (branch (n + 1))) (hdiam _ _) (hdiam _ _)
      (hdetector (n + 1) (branch (n + 1)) i hi)
      (hdetector (n + 1) (branch (n + 1)) j hj)
    simpa only [Real.norm_eq_abs] using hpair
  · rw [hdense]
    exact Set.mem_univ d

def weakBall : Set (WeakSpace ℝ X) :=
  {w | ‖(toWeakSpace ℝ X).symm w‖ ≤ 1}

theorem weak_functional_continuous (f : X →L[ℝ] ℝ) :
    Continuous (fun w : WeakSpace ℝ X => f ((toWeakSpace ℝ X).symm w)) :=
  WeakBilin.eval_continuous _ f

theorem detector_limit_from_weak
    {T : PlaneTree} {K : Set X} (E : Evaluation T K)
    (k : ℕ) (v : T.Node k) (f : X →L[ℝ] ℝ)
    (b : ℕ → K) (q : K) (U : Filter ℕ)
    (hweak : Tendsto (fun j => toWeakSpace ℝ X (E.prediction k v (b j) : X))
      U (𝓝 (toWeakSpace ℝ X (q : X)))) :
    Tendsto (fun j => f ((E.label k v : X) - E.prediction k v (b j)))
      U (𝓝 (f ((E.label k v : X) - q))) := by
  have happly : Tendsto (fun j => f (E.prediction k v (b j) : X)) U (𝓝 (f (q : X))) := by
    simpa only [Function.comp_def, LinearEquiv.symm_apply_apply] using
      ((weak_functional_continuous f).tendsto (toWeakSpace ℝ X (q : X))).comp hweak
  simpa only [map_sub] using
    (tendsto_const_nhds.sub happly :
      Tendsto (fun j => f (E.label k v : X) - f (E.prediction k v (b j) : X)) U
        (𝓝 (f (E.label k v : X) - f (q : X))))

def TerminalData.fromWeakPredictions
    {T : PlaneTree} {K : Set X} (E : Evaluation T K) (B : E.Bounds)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ)
    (b : ℕ → K) (U : Filter ℕ) (hproper : U.NeBot) (hU : U ≤ atTop)
    (hdisplacement : ∀ k v,
      Tendsto (fun j => ‖(E.map k v (b j) : X) - b j‖) atTop (𝓝 0))
    (q : ∀ k, T.Node k → K)
    (hweak : ∀ k, 0 < k → ∀ v,
      Tendsto (fun j => toWeakSpace ℝ X (E.prediction k v (b j) : X)) U
        (𝓝 (toWeakSpace ℝ X (q k v : X))))
    (hq : ∀ k, 0 < k → ∀ v, 1 - B.budget k v ≤ f k v ((E.label k v : X) - q k v)) :
    TerminalData E B f where
  terminal := b
  ultrafilter := U
  proper := hproper
  le_atTop := hU
  displacement_tendsto := hdisplacement
  limit := fun k v => f k v ((E.label k v : X) - q k v)
  prediction_tendsto := fun k hk v =>
    detector_limit_from_weak E k v (f k v) b (q k v) U (hweak k hk v)
  limit_detection := hq

theorem switching_bridge_contradiction
    {T : PlaneTree} {K : Set X} (E : Evaluation T K) (B : E.Bounds)
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ) (hf : ∀ k v, ‖f k v‖ ≤ 1)
    (A : TerminalData E B f)
    (hbudget : ∀ n, (∑ i ∈ Finset.range n, ∑ v, B.budget (i + 1) v) ≤ (1 : ℝ) / 128)
    (hsummable : Summable (fun v : Σ k, T.Node k => B.budget v.1 v.2))
    (z : ℕ → K)
    (hdense : closure (Submodule.span ℝ
      (Set.range (fun ij : ℕ × ℕ => (z ij.1 : X) - z ij.2)) : Set X) = Set.univ)
    (hdetector : ∀ k v i, i < k →
      1 - B.budget k v ≤ f k v ((E.label k v : X) - z i))
    (hcompact : IsCompact (weakBall (X := X))) :
    False := by
  let Q := weakBall (X := X)
  letI : CompactSpace Q := isCompact_iff_compactSpace.mp hcompact
  let point : Q → X := fun q => (toWeakSpace ℝ X).symm q.val
  have hpoint (q : Q) : ‖point q‖ ≤ 1 := q.property
  have honto (d : X) (hd : ‖d‖ ≤ 1) : ∃ q : Q, point q = d :=
    ⟨⟨toWeakSpace ℝ X d, hd⟩, rfl⟩
  have hcontinuous (k : ℕ) (v : T.Node k) :
      Continuous (fun q : Q => f k v (point q)) :=
    (weak_functional_continuous (f k v)).comp continuous_subtype_val
  have hfinite (N : ℕ) (hN : 0 < N) : ∃ s : T.Node N, ∃ d : X, ‖d‖ ≤ 1 ∧
      ∀ i, i < N → (1 / 2 : ℝ) ≤ f (i + 1) (T.ancestor (i + 1) N s) d := by
    obtain ⟨j, s, hs, hd⟩ := E.finite_witness_from_inputs B hdiam f hf A hbudget N hN
    exact ⟨s, E.switchVector N s (A.terminal j), hs, fun i hi => (hd i hi).le⟩
  obtain ⟨branch, d, _, _, hlarge⟩ := finite_witnesses_to_common_branch f
    point hpoint honto hcontinuous hfinite
  have hzero := pointwise_null_detectors E B hdiam f hf z hdense hdetector
    hsummable branch d
  obtain ⟨N, hN⟩ := Metric.tendsto_atTop.mp hzero (1 / 4) (by norm_num)
  have hsmall : |f (N + 1) (branch (N + 1)) d| < 1 / 4 := by
    simpa only [Real.dist_eq, sub_zero] using hN N le_rfl
  have hbig := hlarge N
  have habs := le_abs_self (f (N + 1) (branch (N + 1)) d)
  linarith

theorem switching_bridge_from_manuscript
    {T : PlaneTree} {K : Set X} (E : Evaluation T K)
    (e : ∀ k, T.Node k → ℝ) (he : ∀ k v, 0 ≤ e k v)
    (hepos : ∀ k, 0 < k → ∀ v, 0 < e k v) (hezero : ∀ v, e 0 v = 0)
    (haverage : ∀ k v, ‖(E.average k (E.label (k + 1)) v : X) - E.x‖ ≤
      T.manuscriptTolerance e k)
    (hpath : ∀ k, 0 < k → ∀ v,
      (∑ i ∈ Finset.range k,
        ‖(E.map i (T.ancestor i k v) (E.label k v) : X) - E.label k v‖) ≤ e k v)
    (hdiam : ∀ a b : K, ‖(a : X) - b‖ ≤ 1)
    (f : ∀ k, T.Node k → X →L[ℝ] ℝ) (hf : ∀ k v, ‖f k v‖ ≤ 1)
    (b : ℕ → K) (U : Filter ℕ) (hproper : U.NeBot) (hU : U ≤ atTop)
    (hdisplacement : ∀ k v,
      Tendsto (fun j => ‖(E.map k v (b j) : X) - b j‖) atTop (𝓝 0))
    (q : ∀ k, T.Node k → K)
    (hweak : ∀ k, 0 < k → ∀ v,
      Tendsto (fun j => toWeakSpace ℝ X (E.prediction k v (b j) : X)) U
        (𝓝 (toWeakSpace ℝ X (q k v : X))))
    (hq : ∀ k, 0 < k → ∀ v, 1 - e k v ≤ f k v ((E.label k v : X) - q k v))
    (hbudget : ∀ n, (∑ i ∈ Finset.range n, ∑ v, e (i + 1) v) ≤ (1 : ℝ) / 128)
    (hsummable : Summable (fun v : Σ k, T.Node k => e v.1 v.2))
    (z : ℕ → K)
    (hdense : closure (Submodule.span ℝ
      (Set.range (fun ij : ℕ × ℕ => (z ij.1 : X) - z ij.2)) : Set X) = Set.univ)
    (hdetector : ∀ k v i, i < k → 1 - e k v ≤ f k v ((E.label k v : X) - z i))
    (hcompact : IsCompact (weakBall (X := X))) :
    False := by
  let B := Evaluation.Bounds.fromManuscript E e he hepos hezero haverage hpath
  let A := TerminalData.fromWeakPredictions E B f b U hproper hU hdisplacement q hweak hq
  exact switching_bridge_contradiction E B hdiam f hf A hbudget hsummable
    z hdense hdetector hcompact

end SwitchingBridge

#print axioms SwitchingBridge.switching_bridge_from_manuscript
