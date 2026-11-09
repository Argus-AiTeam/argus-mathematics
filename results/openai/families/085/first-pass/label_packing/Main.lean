import Mathlib

open Finset

namespace LabelPacking

noncomputable section

theorem unit_chord_identity
    (u v x y : Real) (hu : u ^ 2 + v ^ 2 = 1)
    (hv : x ^ 2 + y ^ 2 = 1) :
    1 - (u * x + v * y) = ((u - x) ^ 2 + (v - y) ^ 2) / 2 := by
  nlinarith

theorem switch_square_bound (a b : Real) :
    (a + b) ^ 2 <= 2 * a ^ 2 + 2 * b ^ 2 := by
  nlinarith [sq_nonneg (a - b)]

theorem particle_fill
    (M S t : Real) (hM : 0 <= M) (hMS : M <= S)
    (hS : 0 < S) (ht : 0 <= t) :
    0 <= M * t / S ∧ 0 <= t - M * t / S ∧
      M * t / S + (t - M * t / S) = t := by
  have hsent : 0 <= M * t / S := div_nonneg (mul_nonneg hM ht) hS.le
  have hcap : M * t / S <= t := (div_le_iff₀ hS).2 (by nlinarith)
  exact ⟨hsent, sub_nonneg.2 hcap, by ring⟩

theorem zero_capacity {I : Type*} [Fintype I]
    (t : I -> Real) (ht : ∀ i, 0 <= t i)
    (hzero : ∑ i, t i = 0) : ∀ i, t i = 0 := by
  intro i
  have hle : t i <= ∑ j, t j :=
    Finset.single_le_sum (fun j _ => ht j) (Finset.mem_univ i)
  linarith [ht i]

def l1 {I : Type*} [Fintype I] (v : I -> Real) : Real :=
  ∑ i, |v i|

def act {I J : Type*} [Fintype I]
    (v : I -> Real) (P : I -> J -> Real) (j : J) : Real :=
  ∑ i, v i * P i j

theorem abs_sum_bound {I : Type*} (s : Finset I) (v : I -> Real) :
    |∑ i ∈ s, v i| <= ∑ i ∈ s, |v i| := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
      simp only [Finset.sum_insert hi]
      exact (abs_add_le _ _).trans (add_le_add le_rfl ih)

theorem l1_triangle {I : Type*} [Fintype I] (v w : I -> Real) :
    l1 (fun i => v i + w i) <= l1 v + l1 w := by
  unfold l1
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_le_sum (fun i _ => abs_add_le (v i) (w i))

theorem l1_mixture {I J : Type*} [Fintype I] [Fintype J]
    (v : I -> Real) (P : I -> J -> Real) (hv : ∀ i, 0 <= v i) :
    l1 (act v P) <= ∑ i, v i * l1 (P i) := by
  classical
  calc
    l1 (act v P) <= ∑ j, ∑ i, v i * |P i j| := by
      apply Finset.sum_le_sum
      intro j _
      calc
        |act v P j| <= ∑ i, |v i * P i j| := abs_sum_bound _ _
        _ = ∑ i, v i * |P i j| := by
          simp only [abs_mul, abs_of_nonneg (hv _)]
    _ = ∑ i, v i * l1 (P i) := by
      rw [Finset.sum_comm]
      simp only [l1, Finset.mul_sum]

theorem stochastic_contraction {I J : Type*} [Fintype I] [Fintype J]
    (v : I -> Real) (P : I -> J -> Real)
    (hP : ∀ i j, 0 <= P i j) (hrow : ∀ i, ∑ j, P i j = 1) :
    l1 (act v P) <= l1 v := by
  classical
  calc
    l1 (act v P) <= ∑ j, ∑ i, |v i| * P i j := by
      apply Finset.sum_le_sum
      intro j _
      calc
        |act v P j| <= ∑ i, |v i * P i j| := abs_sum_bound _ _
        _ = ∑ i, |v i| * P i j := by
          simp only [abs_mul, abs_of_nonneg (hP _ _)]
    _ = l1 v := by
      rw [Finset.sum_comm]
      simp only [← Finset.mul_sum, hrow, mul_one, l1]

theorem probability_average_add {I : Type*} [Fintype I]
    (v f : I -> Real) (A E : Real) (hv : ∑ i, v i = 1) :
    (∑ i, v i * (A * (f i + E))) = A * ((∑ i, v i * f i) + E) := by
  calc
    (∑ i, v i * (A * (f i + E))) =
        A * (∑ i, v i * f i) + (A * E) * (∑ i, v i) := by
          simp only [Finset.mul_sum, ← Finset.sum_add_distrib]
          apply Finset.sum_congr rfl
          intro i _
          ring
    _ = A * ((∑ i, v i * f i) + E) := by rw [hv]; ring

theorem markov_one_step {I J : Type*} [Fintype I] [Fintype J]
    (x y : I -> Real) (P Q : I -> J -> Real) (rho : I -> Real)
    (D E : Real) (hy : ∀ i, 0 <= y i) (hyone : ∑ i, y i = 1)
    (hP : ∀ i j, 0 <= P i j) (hrow : ∀ i, ∑ j, P i j = 1)
    (hdiff : ∀ i, l1 (fun j => P i j - Q i j) <= D * (rho i + E)) :
    l1 (fun j => act x P j - act y Q j) <=
      l1 (fun i => x i - y i) + D * ((∑ i, y i * rho i) + E) := by
  classical
  have heq : (fun j => act x P j - act y Q j) =
      (fun j => act (fun i => x i - y i) P j +
        act y (fun i j => P i j - Q i j) j) := by
    funext j
    simp only [act, sub_mul, mul_sub, Finset.sum_sub_distrib]
    ring
  rw [heq]
  calc
    l1 (fun j => act (fun i => x i - y i) P j +
        act y (fun i j => P i j - Q i j) j) <=
        l1 (act (fun i => x i - y i) P) +
          l1 (act y (fun i j => P i j - Q i j)) := l1_triangle _ _
    _ <= l1 (fun i => x i - y i) +
        ∑ i, y i * l1 (fun j => P i j - Q i j) :=
      add_le_add (stochastic_contraction _ _ hP hrow) (l1_mixture _ _ hy)
    _ <= l1 (fun i => x i - y i) +
        ∑ i, y i * (D * (rho i + E)) := by
      exact add_le_add le_rfl
        (Finset.sum_le_sum (fun i _ => mul_le_mul_of_nonneg_left (hdiff i) (hy i)))
    _ = _ := by rw [probability_average_add y rho D E hyone]

theorem observable_perturbation {I : Type*} [Fintype I]
    (x y f rho : I -> Real) (A E F : Real)
    (hy : ∀ i, 0 <= y i) (hyone : ∑ i, y i = 1)
    (hf : ∀ i, 0 <= f i ∧ f i <= F)
    (hbound : ∀ i, f i <= A * (rho i + E)) :
    (∑ i, x i * f i) <=
      A * ((∑ i, y i * rho i) + E) + F * l1 (fun i => x i - y i) := by
  classical
  have hdiff : ∀ i, (x i - y i) * f i <= F * |x i - y i| := by
    intro i
    calc
      (x i - y i) * f i <= |x i - y i| * f i :=
        mul_le_mul_of_nonneg_right (le_abs_self _) (hf i).1
      _ <= |x i - y i| * F :=
        mul_le_mul_of_nonneg_left (hf i).2 (abs_nonneg _)
      _ = F * |x i - y i| := mul_comm _ _
  calc
    (∑ i, x i * f i) =
        (∑ i, y i * f i) + ∑ i, (x i - y i) * f i := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ <= (∑ i, y i * (A * (rho i + E))) +
        ∑ i, F * |x i - y i| := by
      exact add_le_add
        (Finset.sum_le_sum (fun i _ =>
          mul_le_mul_of_nonneg_left (hbound i) (hy i)))
        (Finset.sum_le_sum (fun i _ => hdiff i))
    _ = _ := by
      rw [probability_average_add y rho A E hyone]
      simp only [l1, Finset.mul_sum]

def discount (c : Nat -> Real) : Nat -> Real
  | 0 => 0
  | n + 1 => discount c n / 2 + c n

theorem discount_nonneg (c : Nat -> Real) (hc : ∀ n, 0 <= c n) :
    ∀ n, 0 <= discount c n := by
  intro n
  induction n with
  | zero => simp [discount]
  | succ n ih => exact add_nonneg (div_nonneg ih (by norm_num)) (hc n)

theorem discount_uniform (c : Nat -> Real) (H : Real) (hH : 0 <= H)
    (n : Nat) (hc : ∀ k < n, c k <= H) : discount c n <= 2 * H := by
  induction n with
  | zero => simp [discount]; linarith
  | succ n ih =>
      have hprev := ih (fun k hk => hc k (by omega))
      have hnow := hc n (by omega)
      simp only [discount]
      linarith

theorem discount_sum_identity (c : Nat -> Real) (b n : Nat) :
    (∑ j ∈ Finset.range n, discount c (b + j + 1)) =
      2 * (∑ j ∈ Finset.range n, c (b + j)) +
        discount c b - discount c (b + n) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, Finset.sum_range_succ, ih]
      rw [show b + (n + 1) = b + n + 1 by omega]
      rw [show discount c (b + n + 1) =
        discount c (b + n) / 2 + c (b + n) from rfl]
      ring

theorem discount_tail_bound (c : Nat -> Real) (hc : ∀ n, 0 <= c n)
    (b n : Nat) :
    (∑ j ∈ Finset.range n, discount c (b + j + 1)) <=
      2 * (∑ j ∈ Finset.range n, c (b + j)) + discount c b := by
  rw [discount_sum_identity]
  linarith [discount_nonneg c hc (b + n)]

theorem shift_sum_identity (f : Nat -> Real) (n : Nat) :
    (∑ j ∈ Finset.range (n + 1), f j) =
      f 0 + ∑ j ∈ Finset.range n, f (j + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, ih, Finset.sum_range_succ]
      ring

theorem inherited_cost_bound (c : Nat -> Real) (_hc : ∀ k, 0 <= c k)
    (H : Real) (hH : 0 <= H) (b : Nat)
    (hpre : ∀ k < b, c k <= H) :
    discount c b <= 2 * H ∧
      discount (fun k => discount c (k + 1)) b <= 4 * H := by
  constructor
  · exact discount_uniform c H hH b hpre
  · have hh := discount_uniform (fun k => discount c (k + 1)) (2 * H)
        (by positivity) b (fun k hk =>
          discount_uniform c H hH (k + 1)
            (fun j hj => hpre j (by omega)))
    linarith

theorem birth_convolution (c : Nat -> Real) (hc : ∀ k, 0 <= c k)
    (H : Real) (hH : 0 <= H) (b n : Nat)
    (hpre : ∀ k < b, c k <= H) (hend : c (b + n) = 0) :
    (∑ j ∈ Finset.range n,
      (discount c (b + j + 1) + discount c (b + j + 2) +
        discount (fun k => discount c (k + 1)) (b + j + 1))) <=
      8 * (∑ j ∈ Finset.range n, c (b + j)) + 12 * H := by
  have hinit := inherited_cost_bound c hc H hH b hpre
  have he := discount_tail_bound c hc b n
  have hef := discount_tail_bound c hc b (n + 1)
  have hnext :
      (∑ j ∈ Finset.range n, discount c (b + j + 2)) <=
        2 * (∑ j ∈ Finset.range n, c (b + j)) + discount c b := by
    have hcend :
        (∑ j ∈ Finset.range (n + 1), c (b + j)) =
        ∑ j ∈ Finset.range n, c (b + j) := by
      rw [Finset.sum_range_succ, hend, add_zero]
    rw [hcend] at hef
    have hshift := shift_sum_identity (fun j => discount c (b + j + 1)) n
    simp only [Nat.add_zero] at hshift
    have hnon := discount_nonneg c hc (b + 1)
    have hrewrite :
        (∑ j ∈ Finset.range n, discount c (b + (j + 1) + 1)) =
        ∑ j ∈ Finset.range n, discount c (b + j + 2) := by
      apply Finset.sum_congr rfl
      intro j _
      congr 1
    rw [hrewrite] at hshift
    linarith
  have hf := discount_tail_bound (fun k => discount c (k + 1))
    (fun k => discount_nonneg c hc (k + 1)) b n
  simp only [Finset.sum_add_distrib]
  linarith

theorem scaled_marginal_bound
    (c d alpha : Nat -> Real) (D : Real)
    (_hc : ∀ k, 0 <= c k) (_hD : 0 <= D)
    (_ha : ∀ k, 0 <= alpha k)
    (ha_step : ∀ k, alpha (k + 1) = 2 * alpha k)
    (hd0 : d 0 = 0)
    (hd : ∀ k, d (k + 1) <= d k + D * alpha k * c k) :
    ∀ k, d k <= D * alpha k / 2 * discount c k := by
  intro k
  induction k with
  | zero => simp [discount, hd0]
  | succ k ih =>
      have hstep := hd k
      rw [ha_step, discount]
      nlinarith

theorem spatial_observable_bound
    (c d alpha : Nat -> Real) (A D F K : Real)
    (hc : ∀ k, 0 <= c k) (hD : 0 <= D) (hF : 0 <= F)
    (ha : ∀ k, 0 <= alpha k)
    (ha_step : ∀ k, alpha (k + 1) = 2 * alpha k)
    (hd0 : d 0 = 0)
    (hd : ∀ k, d (k + 1) <= d k + D * alpha k * c k)
    (hKA : A <= K) (hKF : 2 * F * D <= K)
    (k : Nat) (hnear : alpha k <= 2) (cost : Real)
    (hcost : cost <= A * c k + F * d k) :
    cost <= K * discount c (k + 1) := by
  have hm := scaled_marginal_bound c d alpha D hc hD ha ha_step hd0 hd k
  have he := discount_nonneg c hc k
  have hde : d k <= D * discount c k := by
    have hprod : 0 <= D * discount c k := mul_nonneg hD he
    nlinarith
  have hobs : cost <= A * c k + F * D * discount c k := by
    nlinarith
  have hcK := mul_le_mul_of_nonneg_right hKA (hc k)
  have heK := mul_le_mul_of_nonneg_right hKF he
  rw [discount]
  nlinarith

theorem finite_weighted_transfer {I : Type*} [Fintype I]
    (mass cost budget : I -> Real) (V K L : Real)
    (hmass : ∀ i, 0 <= mass i)
    (hcost : ∀ i, cost i <= K * budget i + L)
    (hK : 0 <= K) (hL : 0 <= L)
    (hbudget : (∑ i, mass i * budget i) <= V)
    (htotal : (∑ i, mass i) <= V) :
    (∑ i, mass i * cost i) <= (K + L) * V := by
  calc
    (∑ i, mass i * cost i) <= ∑ i, mass i * (K * budget i + L) :=
      Finset.sum_le_sum (fun i _ => mul_le_mul_of_nonneg_left (hcost i) (hmass i))
    _ = K * (∑ i, mass i * budget i) + L * (∑ i, mass i) := by
      simp only [mul_add, Finset.sum_add_distrib, Finset.mul_sum]
      congr 1 <;> apply Finset.sum_congr rfl <;> intro i _ <;> ring
    _ <= K * V + L * V :=
      add_le_add (mul_le_mul_of_nonneg_left hbudget hK)
        (mul_le_mul_of_nonneg_left htotal hL)
    _ = (K + L) * V := by ring

end

end LabelPacking
