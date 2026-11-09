import Mathlib

namespace HellingerPairAudit

noncomputable def pairD (g0 gd ge g1 : ℝ) : ℝ :=
  (gd + ge - g0 - g1) / 2

noncomputable def pairK (δ z g0 gd ge g1 : ℝ) : ℝ :=
  -((((g1 - gd) / ((1 - δ) * z) - (gd - g0) / (δ * z)) / z) +
    (((g1 - ge) / (δ * z) - (ge - g0) / ((1 - δ) * z)) / z)) / 8

theorem deficit_normalization
    (δ z g0 gd ge g1 : ℝ)
    (hδ : δ ≠ 0) (h1 : 1 - δ ≠ 0) (hz : z ≠ 0) :
    pairD g0 gd ge g1 =
      (4 * δ * (1 - δ)) * z ^ 2 * pairK δ z g0 gd ge g1 := by
  unfold pairD pairK
  field_simp [hδ, h1, hz]
  ring

theorem shear_normalization
    (z L g0 g1 : ℝ) (hz : z ≠ 0) (hL : L ≠ 0) :
    z - (g1 - g0) / (4 * L) =
      z * (1 - ((g1 - g0) / z) / (4 * L)) := by
  field_simp [hz, hL]

theorem quadratic_gap_factorization
    (s2 z K S Λ μ W : ℝ) :
    (s2 * z ^ 2 * K) * (S + Λ * (s2 * z ^ 2 * K)) -
        μ * s2 * (z * W) ^ 2 =
      s2 * z ^ 2 * (K * (S + Λ * (s2 * z ^ 2 * K)) - μ * W ^ 2) := by
  ring

theorem original_pair_of_normalized_gap
    (δ z L μ Λ S g0 gd ge g1 : ℝ)
    (hδ : 0 < δ) (h1 : δ < 1) (hz : 0 < z) (hL : L ≠ 0)
    (hgap :
      0 < pairK δ z g0 gd ge g1 * (S + Λ * pairD g0 gd ge g1) -
        μ * (1 - ((g1 - g0) / z) / (4 * L)) ^ 2) :
    μ * (4 * δ * (1 - δ)) * (z - (g1 - g0) / (4 * L)) ^ 2 <
      pairD g0 gd ge g1 * (S + Λ * pairD g0 gd ge g1) := by
  have hd := deficit_normalization δ z g0 gd ge g1
    (ne_of_gt hδ) (ne_of_gt (sub_pos.mpr h1)) (ne_of_gt hz)
  have ht := shear_normalization z L g0 g1 (ne_of_gt hz) hL
  have hs : 0 < 4 * δ * (1 - δ) :=
    mul_pos (mul_pos (by norm_num) hδ) (sub_pos.mpr h1)
  have hp := mul_pos (mul_pos hs (sq_pos_of_pos hz)) hgap
  have hi :
      pairD g0 gd ge g1 * (S + Λ * pairD g0 gd ge g1) -
          μ * (4 * δ * (1 - δ)) * (z - (g1 - g0) / (4 * L)) ^ 2 =
        (4 * δ * (1 - δ)) * z ^ 2 *
          (pairK δ z g0 gd ge g1 * (S + Λ * pairD g0 gd ge g1) -
            μ * (1 - ((g1 - g0) / z) / (4 * L)) ^ 2) := by
    rw [hd, ht]
    ring
  rw [← hi] at hp
  linarith

end HellingerPairAudit
