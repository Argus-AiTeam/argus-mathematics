import Mathlib

open Filter
open scoped Topology

namespace NormalizedHeightBridge

theorem cutoff_identity (U V a b : Real) :
    (U - V) * (a ^ 2 * U - b ^ 2 * V) =
      (a * U - b * V) ^ 2 - U * V * (a - b) ^ 2 := by
  ring

theorem cutoff_error_bound (U V a b : Real) :
    abs (U * V) * (a - b) ^ 2 <=
      ((U ^ 2 + V ^ 2) / 2) * (a - b) ^ 2 := by
  have h : abs (U * V) <= (U ^ 2 + V ^ 2) / 2 := by
    apply abs_le.mpr
    constructor
    · nlinarith [sq_nonneg (U + V)]
    · nlinarith [sq_nonneg (U - V)]
  exact mul_le_mul_of_nonneg_right h (sq_nonneg (a - b))

theorem pairwise_variance {I : Type*} [Fintype I] (p x : I -> Real) :
    (Finset.univ.sum fun i =>
      Finset.univ.sum fun j => p i * p j * (x i - x j) ^ 2) =
    2 * ((Finset.univ.sum p) *
      (Finset.univ.sum fun i => p i * x i ^ 2) -
      (Finset.univ.sum fun i => p i * x i) ^ 2) := by
  calc
    _ = (Finset.univ.sum fun i =>
        Finset.univ.sum fun j =>
          (p i * x i ^ 2) * p j + p i * (p j * x j ^ 2) -
            (2 * (p i * x i)) * (p j * x j)) := by
      apply Finset.sum_congr rfl
      intro i hi
      apply Finset.sum_congr rfl
      intro j hj
      ring
    _ = _ := by
      simp only [Finset.sum_sub_distrib, Finset.sum_add_distrib,
        <- Finset.mul_sum, <- Finset.sum_mul]
      ring

theorem mean_correction_limit {I : Type*} {l : Filter I}
    {a b c : I -> Real} {a0 b0 : Real}
    (ha : Tendsto a l (nhds a0))
    (hb : Tendsto b l (nhds b0))
    (hc : Tendsto c l (nhds 0)) :
    Tendsto (fun j => a j - c j * b j) l (nhds a0) := by
  simpa using ha.sub (hc.mul hb)

theorem two_stage_vanishing {f a b : Nat -> Real}
    (hf : forall j, 0 <= f j)
    (ha : Tendsto a atTop (nhds 0))
    (hb : Tendsto b atTop (nhds 0))
    (hbound : forall m, Filter.Eventually (fun j => f j <= a m + b j) atTop) :
    Tendsto f atTop (nhds 0) := by
  apply tendsto_order.2
  constructor
  · intro r hr
    exact Filter.Eventually.of_forall fun j => lt_of_lt_of_le hr (hf j)
  · intro r hr
    have hhalf : (0 : Real) < r / 2 := by linarith
    obtain ⟨m, hm⟩ := ((tendsto_order.1 ha).2 (r / 2) hhalf).exists
    have hb' := (tendsto_order.1 hb).2 (r / 2) hhalf
    filter_upwards [hbound m, hb'] with j hj hjb
    linarith

end NormalizedHeightBridge
