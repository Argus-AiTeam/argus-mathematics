import Mathlib

namespace PairEnergyAudit

abbrev CompactTag (n : ℕ) :=
  Fin 384 × (Fin 8 → Fin n) × (Fin 8 → Fin 2)

theorem compact_tag_card (n : ℕ) :
    Fintype.card (CompactTag n) ≤ 2 ^ 17 * n ^ 8 := by
  simp only [CompactTag, Fintype.card_prod, Fintype.card_fin, Fintype.card_fun]
  omega

theorem tagged_fibre_bound {Demand Output : Type*} [Fintype Demand] [DecidableEq Output]
    (n : ℕ) (encode : Demand → Output) (tag : Demand → CompactTag n)
    (hinj : Function.Injective fun d => (encode d, tag d)) (out : Output) :
    Fintype.card {d : Demand // encode d = out} ≤ 2 ^ 17 * n ^ 8 := by
  classical
  let toTag : {d : Demand // encode d = out} → CompactTag n := fun d => tag d.val
  have hi : Function.Injective toTag := by
    intro x y h
    apply Subtype.ext
    apply hinj
    exact Prod.ext (x.property.trans y.property.symm) h
  exact (Fintype.card_le_of_injective toTag hi).trans (compact_tag_card n)

theorem weighted_center_identity {ι : Type*} (s : Finset ι)
    (w v : ι → ℝ) (u μ p : ℝ)
    (hmass : ∑ i ∈ s, w i = p)
    (hcenter : ∑ i ∈ s, w i * (v i - μ) = 0) :
    (∑ i ∈ s, w i * (u - v i) ^ 2) =
      p * (u - μ) ^ 2 + ∑ i ∈ s, w i * (v i - μ) ^ 2 := by
  calc
    (∑ i ∈ s, w i * (u - v i) ^ 2) =
        ∑ i ∈ s, (w i * (u - μ) ^ 2 + w i * (v i - μ) ^ 2 -
          (2 * (u - μ)) * (w i * (v i - μ))) := by
      apply Finset.sum_congr rfl
      intro i hi
      ring
    _ = p * (u - μ) ^ 2 + ∑ i ∈ s, w i * (v i - μ) ^ 2 := by
      rw [Finset.sum_sub_distrib, Finset.sum_add_distrib,
        ← Finset.sum_mul, ← Finset.mul_sum, hmass, hcenter]
      ring

theorem conditional_center_bound {ι : Type*} (s : Finset ι)
    (w v : ι → ℝ) (u μ p : ℝ)
    (hw : ∀ i ∈ s, 0 ≤ w i)
    (hmass : ∑ i ∈ s, w i = p)
    (hcenter : ∑ i ∈ s, w i * (v i - μ) = 0) :
    p * (u - μ) ^ 2 ≤ ∑ i ∈ s, w i * (u - v i) ^ 2 := by
  have hnonneg : 0 ≤ ∑ i ∈ s, w i * (v i - μ) ^ 2 :=
    Finset.sum_nonneg fun i hi => mul_nonneg (hw i hi) (sq_nonneg _)
  rw [weighted_center_identity s w v u μ p hmass hcenter]
  linarith

theorem two_context_bound (u₀ u₁ μ : ℝ) :
    (u₁ - u₀) ^ 2 ≤ 2 * ((u₀ - μ) ^ 2 + (u₁ - μ) ^ 2) := by
  nlinarith [sq_nonneg ((u₀ - μ) + (u₁ - μ))]

theorem swap_difference (a a' b b' : ℝ) :
    (a + b) - (a' + b') = (a - a') - (b' - b) := by
  ring

theorem nonzero_opposite_long_context :
    ((0 : ℝ) - 0 - (1 - 0)) ^ 2 = 1 := by
  norm_num

theorem demand_energy_composition (n a t e variance color switches errors : ℝ)
    (hn : 1 ≤ n) (ha : 1 ≤ a) (ht : 1 ≤ t) (he : 0 ≤ e)
    (hc : color ≤ 12 * n * a * e)
    (hs : switches ≤ 60 * n ^ 2 * a ^ 6 * t * e)
    (hh : errors ≤ 48 * n ^ 2 * a ^ 4 * t * e)
    (hv : variance ≤ n * (color + 3 * n * (switches + errors))) :
    variance ≤ 336 * n ^ 4 * a ^ 6 * t * e := by
  have hn0 : 0 ≤ n := by linarith
  have ha0 : 0 ≤ a := by linarith
  have ht0 : 0 ≤ t := by linarith
  have hn2 : 0 ≤ n ^ 2 - 1 := by nlinarith [sq_nonneg (n - 1)]
  have ha2 : 0 ≤ a ^ 2 - 1 := by nlinarith [sq_nonneg (a - 1)]
  have hn24 : n ^ 2 ≤ n ^ 4 := by
    nlinarith [mul_nonneg (sq_nonneg n) hn2]
  have ha46 : a ^ 4 ≤ a ^ 6 := by
    nlinarith [mul_nonneg (by positivity : 0 ≤ a ^ 4) ha2]
  have ham : 0 ≤ a - 1 := by linarith
  have ha16 : a ≤ a ^ 6 := by
    have hp : 0 ≤ a * (a - 1) * (a ^ 4 + a ^ 3 + a ^ 2 + a + 1) := by
      positivity
    nlinarith
  have hsmall : n ^ 2 * a ≤ n ^ 4 * a ^ 6 * t := by
    calc
      n ^ 2 * a ≤ n ^ 4 * a ^ 6 := by gcongr
      _ ≤ n ^ 4 * a ^ 6 * t := by
        nlinarith [mul_nonneg (by positivity : 0 ≤ n ^ 4 * a ^ 6)
          (sub_nonneg.mpr ht)]
  have hsmallE := mul_le_mul_of_nonneg_right hsmall he
  have hlast : n ^ 4 * a ^ 4 * t * e ≤ n ^ 4 * a ^ 6 * t * e := by
    gcongr
  have hsh := add_le_add hs hh
  have hinside := add_le_add hc
    (mul_le_mul_of_nonneg_left hsh (by positivity : 0 ≤ 3 * n))
  have hmain := hv.trans (mul_le_mul_of_nonneg_left hinside hn0)
  nlinarith [hsmallE, hlast]

theorem compact_energy_coefficient (n a e : ℝ) :
    336 * n ^ 4 * a ^ 6 * ((2 : ℝ) ^ 17 * n ^ 8) * e =
      (336 * 2 ^ 17) * n ^ 12 * a ^ 6 * e := by
  ring

theorem one_le_power (x : ℝ) (hx : 1 ≤ x) (k : ℕ) : 1 ≤ x ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [pow_succ]
      nlinarith [mul_nonneg (sub_nonneg.mpr ih) (sub_nonneg.mpr hx)]

theorem headline_constant (n d : ℝ) (hn : 1 ≤ n) (hd : 1 ≤ d) :
    (336 * 2 ^ 17) * n ^ 12 * (1000 * d) ^ 6 ≤
      (10000 * n * d) ^ 100 := by
  have hn0 : 0 ≤ n := by linarith
  have hd0 : 0 ≤ d := by linarith
  have hnp : n ^ 12 ≤ n ^ 100 := by
    calc
      n ^ 12 = n ^ 12 * 1 := by ring
      _ ≤ n ^ 12 * n ^ 88 :=
        mul_le_mul_of_nonneg_left (one_le_power n hn 88) (by positivity)
      _ = n ^ 100 := by ring
  have hdp : d ^ 6 ≤ d ^ 100 := by
    calc
      d ^ 6 = d ^ 6 * 1 := by ring
      _ ≤ d ^ 6 * d ^ 94 :=
        mul_le_mul_of_nonneg_left (one_le_power d hd 94) (by positivity)
      _ = d ^ 100 := by ring
  have hcoef : (336 : ℝ) * 2 ^ 17 * 1000 ^ 6 ≤ 10000 ^ 100 := by
    norm_num
  calc
    (336 * 2 ^ 17) * n ^ 12 * (1000 * d) ^ 6 =
        (336 * 2 ^ 17 * 1000 ^ 6) * n ^ 12 * d ^ 6 := by ring
    _ ≤ (10000 : ℝ) ^ 100 * n ^ 100 * d ^ 100 := by gcongr
    _ = (10000 * n * d) ^ 100 := by ring

end PairEnergyAudit
