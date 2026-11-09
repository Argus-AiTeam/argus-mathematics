import Mathlib

open Filter

namespace SelectiveBridge

theorem twoEndedIdentity {R : Type*} [Ring R] (p w d e : R)
    (hw : (1 - p) * w * (1 - p) = 0) :
    d * w * e = d * p * w * e + d * (1 - p) * w * p * e := by
  calc
    d * w * e =
        d * p * w * e + d * (1 - p) * w * p * e +
          d * ((1 - p) * w * (1 - p)) * e := by noncomm_ring
    _ = d * p * w * e + d * (1 - p) * w * p * e := by rw [hw]; simp

theorem twoEndedBound {R : Type*} [NormedRing R] (p w d e : R)
    (hp : ‖1 - p‖ ≤ 1) (hw : (1 - p) * w * (1 - p) = 0) :
    ‖d * w * e‖ ≤
      ‖d * p‖ * ‖w‖ * ‖e‖ + ‖d‖ * ‖w‖ * ‖p * e‖ := by
  have hd : ‖d * (1 - p)‖ ≤ ‖d‖ := by
    calc
      ‖d * (1 - p)‖ ≤ ‖d‖ * ‖1 - p‖ := norm_mul_le _ _
      _ ≤ ‖d‖ * 1 := mul_le_mul_of_nonneg_left hp (norm_nonneg _)
      _ = ‖d‖ := mul_one _
  have hleft : ‖d * p * w * e‖ ≤ ‖d * p‖ * ‖w‖ * ‖e‖ := by
    calc
      ‖d * p * w * e‖ ≤ ‖d * p * w‖ * ‖e‖ := norm_mul_le _ _
      _ ≤ (‖d * p‖ * ‖w‖) * ‖e‖ := by
        gcongr
        exact norm_mul_le _ _
  have hright : ‖d * (1 - p) * w * p * e‖ ≤ ‖d‖ * ‖w‖ * ‖p * e‖ := by
    calc
      ‖d * (1 - p) * w * p * e‖ =
          ‖(d * (1 - p) * w) * (p * e)‖ := by simp only [mul_assoc]
      _ ≤ ‖d * (1 - p) * w‖ * ‖p * e‖ := norm_mul_le _ _
      _ ≤ (‖d * (1 - p)‖ * ‖w‖) * ‖p * e‖ := by
        gcongr
        exact norm_mul_le _ _
      _ ≤ (‖d‖ * ‖w‖) * ‖p * e‖ := by gcongr
  rw [twoEndedIdentity p w d e hw]
  exact (norm_add_le _ _).trans (add_le_add hleft hright)

theorem productDecay {R X Y : Type*} [NormedRing R]
    (left : Filter X) (right : Filter Y) (p w : R)
    (d : X → R) (e : Y → R) (M N : ℝ)
    (hM : 0 ≤ M) (hN : 0 ≤ N)
    (hdBound : ∀ i, ‖d i‖ ≤ M) (heBound : ∀ j, ‖e j‖ ≤ N)
    (hp : ‖1 - p‖ ≤ 1) (hw : (1 - p) * w * (1 - p) = 0)
    (hd : Tendsto (fun i => ‖d i * p‖) left (nhds 0))
    (he : Tendsto (fun j => ‖p * e j‖) right (nhds 0)) :
    Tendsto (fun q : X × Y => ‖d q.1 * w * e q.2‖)
      (left ×ˢ right) (nhds 0) := by
  have hdl : Tendsto (fun q : X × Y => ‖d q.1 * p‖)
      (left ×ˢ right) (nhds 0) := hd.comp tendsto_fst
  have her : Tendsto (fun q : X × Y => ‖p * e q.2‖)
      (left ×ˢ right) (nhds 0) := he.comp tendsto_snd
  have hbound : ∀ q : X × Y, ‖d q.1 * w * e q.2‖ ≤
      ‖d q.1 * p‖ * ‖w‖ * N + M * ‖w‖ * ‖p * e q.2‖ := by
    intro q
    calc
      ‖d q.1 * w * e q.2‖ ≤
          ‖d q.1 * p‖ * ‖w‖ * ‖e q.2‖ +
            ‖d q.1‖ * ‖w‖ * ‖p * e q.2‖ :=
        twoEndedBound p w (d q.1) (e q.2) hp hw
      _ ≤ ‖d q.1 * p‖ * ‖w‖ * N + M * ‖w‖ * ‖p * e q.2‖ := by
        gcongr
        · exact heBound q.2
        · exact hdBound q.1
  have hzero : Tendsto
      (fun q : X × Y =>
        ‖d q.1 * p‖ * ‖w‖ * N + M * ‖w‖ * ‖p * e q.2‖)
      (left ×ˢ right) (nhds 0) := by
    simpa using ((hdl.mul_const ‖w‖).mul_const N).add
      (her.const_mul (M * ‖w‖))
  exact squeeze_zero (fun _ => norm_nonneg _) hbound hzero

theorem minProductTendsto :
    Tendsto (fun q : ℕ × ℕ => min q.1 q.2)
      ((atTop : Filter ℕ) ×ˢ atTop) atTop := by
  refine tendsto_atTop.2 ?_
  intro n
  have hl : ∀ᶠ q : ℕ × ℕ in (atTop : Filter ℕ) ×ˢ atTop, n ≤ q.1 :=
    tendsto_fst.eventually (eventually_ge_atTop n)
  have hr : ∀ᶠ q : ℕ × ℕ in (atTop : Filter ℕ) ×ˢ atTop, n ≤ q.2 :=
    tendsto_snd.eventually (eventually_ge_atTop n)
  filter_upwards [hl, hr] with q hq hq'
  exact le_min hq hq'

theorem rectangularMinDecay (g : ℕ → ℝ)
    (hg : Tendsto g atTop (nhds 0)) :
    Tendsto (fun q : ℕ × ℕ => g (min q.1 q.2))
      ((atTop : Filter ℕ) ×ˢ atTop) (nhds 0) :=
  hg.comp minProductTendsto

theorem transferCases (m transfers : ℕ) (hm : 1 ≤ m) (ht : transfers ≤ 2) :
    transfers < m ∨
      (m = 1 ∧ transfers = 1) ∨
      (m = 1 ∧ transfers = 2) ∨
      (m = 2 ∧ transfers = 2) := by
  omega

theorem longCoreRemains (m transfers : ℕ) (hm : 3 ≤ m) (ht : transfers ≤ 2) :
    1 ≤ m - transfers := by
  omega

end SelectiveBridge
