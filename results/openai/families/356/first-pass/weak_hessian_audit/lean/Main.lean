import Mathlib

open Filter

noncomputable section

namespace WeakHessianAudit

variable {H E : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℝ H]
variable [NormedAddCommGroup E] [InnerProductSpace ℝ E]

def graphForm (A : H →L[ℝ] H) (B : H →L[ℝ] E) (C : E →L[ℝ] E)
    (x : H) (y : E) : ℝ :=
  (1 / 2 : ℝ) * inner ℝ (A x) x + inner ℝ y (B x) + inner ℝ (C y) y

theorem graphForm_continuous (A : H →L[ℝ] H) (B : H →L[ℝ] E)
    (C : E →L[ℝ] E) :
    Continuous (fun p : H × E => graphForm A B C p.1 p.2) := by
  unfold graphForm
  fun_prop

theorem graphForm_nonneg_of_tendsto (A : H →L[ℝ] H) (B : H →L[ℝ] E)
    (C : E →L[ℝ] E) {xn : ℕ → H} {yn : ℕ → E} {x : H} {y : E}
    (hx : Tendsto xn atTop (nhds x)) (hy : Tendsto yn atTop (nhds y))
    (hn : ∀ n, 0 ≤ graphForm A B C (xn n) (yn n)) :
    0 ≤ graphForm A B C x y := by
  have ht := ((graphForm_continuous A B C).tendsto (x, y)).comp
    (hx.prodMk_nhds hy)
  exact isClosed_Ici.mem_of_tendsto ht (Eventually.of_forall hn)

theorem energy_graph_tendsto {un ln : ℕ → E} {dn : ℕ → H}
    (hu : Tendsto un atTop (nhds 0)) (hl : Tendsto ln atTop (nhds 0))
    (he : ∀ n, ‖dn n‖ ^ 2 ≤ ‖un n‖ * ‖ln n‖) :
    Tendsto dn atTop (nhds 0) := by
  have hp : Tendsto (fun n => ‖un n‖ * ‖ln n‖) atTop (nhds (0 : ℝ)) := by
    simpa using hu.norm.mul hl.norm
  have hs : Tendsto (fun n => ‖dn n‖ ^ 2) atTop (nhds (0 : ℝ)) :=
    squeeze_zero (fun n => sq_nonneg ‖dn n‖) he hp
  have hr := (Real.continuous_sqrt.tendsto (0 : ℝ)).comp hs
  have hn : Tendsto (fun n => ‖dn n‖) atTop (nhds (0 : ℝ)) := by
    change Tendsto (fun n => Real.sqrt (‖dn n‖ ^ 2)) atTop
      (nhds (Real.sqrt (0 : ℝ))) at hr
    simpa only [Real.sqrt_sq_eq_abs, abs_norm, Real.sqrt_zero] using hr
  exact tendsto_zero_iff_norm_tendsto_zero.mpr hn

theorem bochner_cancellation (xi d b c r u : ℝ) :
    (-u + (xi * (d + b) + c) * (d + b)) -
      (-u - xi * r + (xi * d + c + xi * b) * d) =
      xi * r + b * (c + xi * (d + b)) := by
  ring

theorem entropy_residual_identity
    (lam At A0 A1 Et E0 E1 K C D t : ℝ) :
    lam * (At - ((1 - t) * A0 + t * A1) + D) -
        (Et - ((1 - t) * E0 + t * E1) + K * C) =
      -(Et - lam * At -
        ((1 - t) * (E0 - lam * A0) + t * (E1 - lam * A1) - K * C + lam * D)) := by
  ring

theorem resolvent_contraction_arithmetic (alpha zeta : ℝ)
    (ha : alpha ≤ 1 / 8) (hz : zeta ≤ 1 / 4) :
    2 * alpha + zeta ≤ 1 / 2 := by
  linarith

end WeakHessianAudit
