import Mathlib

open Filter

noncomputable section

namespace HypergraphInfluence

private theorem eventually_numerical_scales (r : ℕ) (a : ℝ) :
    ∀ᶠ n : ℕ in atTop, 2 ≤ n ∧
      ∃ m : ℕ, r + 1 ≤ m ∧ m ≤ n ∧
        Real.log (n : ℝ) / 2 ≤ Real.log (m : ℝ) ∧
        (m : ℝ) - 1 ≤ Real.sqrt (n : ℝ) ∧
        4 * (r : ℝ) * (Real.log (n : ℝ)) ^ a ≤ Real.sqrt (n : ℝ) ∧
        (Real.log (n : ℝ)) ^ a ≤ (m : ℝ) ^ (1 / 4 : ℝ) := by
  have hcap : ∀ᶠ x : ℝ in atTop,
      4 * (r : ℝ) * (Real.log x) ^ a ≤ Real.sqrt x := by
    have h := (Asymptotics.isLittleO_iff_nat_mul_le.mp
      (isLittleO_log_rpow_rpow_atTop a (by norm_num : (0 : ℝ) < 1 / 2))) (4 * r)
    filter_upwards [h, eventually_ge_atTop (1 : ℝ)] with x hx hx1
    simpa only [Real.norm_of_nonneg
        (Real.rpow_nonneg (Real.log_nonneg hx1) a),
      Real.norm_of_nonneg (Real.rpow_nonneg (by linarith : 0 ≤ x) (1 / 2 : ℝ)),
      Nat.cast_mul, Nat.cast_ofNat, Real.sqrt_eq_rpow] using hx
  have htail : ∀ᶠ x : ℝ in atTop,
      (Real.log x) ^ a ≤ x ^ (1 / 8 : ℝ) := by
    have h := (isLittleO_log_rpow_rpow_atTop a
      (by norm_num : (0 : ℝ) < 1 / 8)).eventuallyLE
    filter_upwards [h, eventually_ge_atTop (1 : ℝ)] with x hx hx1
    simpa only [Real.norm_of_nonneg
        (Real.rpow_nonneg (Real.log_nonneg hx1) a),
      Real.norm_of_nonneg (Real.rpow_nonneg (by linarith : 0 ≤ x) (1 / 8 : ℝ))]
      using hx
  have hlarge : ∀ᶠ n : ℕ in atTop, (r + 1 : ℕ) ≤ Real.sqrt (n : ℝ) :=
    (Real.tendsto_sqrt_atTop.comp tendsto_natCast_atTop_atTop).eventually_ge_atTop
      (r + 1 : ℕ)
  have hcast : Tendsto (fun n : ℕ => (n : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop
  filter_upwards [hcast.eventually hcap,
    hcast.eventually htail, hlarge,
    eventually_ge_atTop (2 : ℕ)] with n hcapn htailn hlargen hn
  refine ⟨hn, ⌈Real.sqrt (n : ℝ)⌉₊, ?_, ?_, ?_, ?_, hcapn, ?_⟩
  · exact_mod_cast hlargen.trans (Nat.le_ceil _)
  · apply Nat.ceil_le.mpr
    have hn1 : (1 : ℝ) ≤ n := by exact_mod_cast (show 1 ≤ n by omega)
    have hs := Real.sq_sqrt (show (0 : ℝ) ≤ n by positivity)
    have hs0 := Real.sqrt_nonneg (n : ℝ)
    have hs1 := Real.one_le_sqrt.mpr hn1
    nlinarith
  · rw [← Real.log_sqrt (show (0 : ℝ) ≤ n by positivity)]
    exact Real.log_le_log (by positivity) (Nat.le_ceil _)
  · have h := Nat.ceil_lt_add_one (Real.sqrt_nonneg (n : ℝ))
    linarith
  · calc
      (Real.log (n : ℝ)) ^ a ≤ (n : ℝ) ^ (1 / 8 : ℝ) := htailn
      _ = (Real.sqrt (n : ℝ)) ^ (1 / 4 : ℝ) := by
        rw [Real.sqrt_eq_rpow, ← Real.rpow_mul (by positivity)]
        norm_num
      _ ≤ (⌈Real.sqrt (n : ℝ)⌉₊ : ℝ) ^ (1 / 4 : ℝ) :=
        Real.rpow_le_rpow (Real.sqrt_nonneg _) (Nat.le_ceil _) (by norm_num)

private theorem uniform_sigma_estimates
    (r a x y σ : ℝ) (hr : 1 ≤ r) (ha : 0 ≤ a) (ha2 : a ≤ 2)
    (hx : 0 < x) (hxy : x / 2 ≤ y) (hyx : y ≤ x)
    (hσ : 0 < σ) (hσhalf : σ ≤ 1 / 2) :
    let k := σ * y / 64
    let L := (k / r) ^ a
    0 < k ∧ 0 < L ∧ L ≤ x ^ a ∧
      σ ^ 2 / L ≤ (128 * r) ^ a / x ^ a := by
  have hr0 : 0 < r := by linarith
  have hy : 0 < y := by linarith
  have hk : 0 < σ * y / 64 := by positivity
  have hL : 0 < (σ * y / 64 / r) ^ a := by positivity
  refine ⟨hk, hL, ?_, ?_⟩
  · apply Real.rpow_le_rpow (by positivity) _ ha
    apply (div_le_iff₀ hr0).mpr
    apply (div_le_iff₀ (by norm_num : (0 : ℝ) < 64)).mpr
    have hσy : σ * y ≤ y := by nlinarith
    have hxr : x ≤ x * r := by nlinarith
    nlinarith
  · have hσpow : σ ^ (2 : ℕ) ≤ σ ^ a := by
      simpa only [Real.rpow_two] using
        (Real.rpow_le_rpow_of_exponent_ge hσ (by linarith : σ ≤ 1) ha2)
    have hbase : x / (128 * r) ≤ y / (64 * r) := by
      apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
      nlinarith [mul_nonneg hr0.le (show 0 ≤ 2 * y - x by linarith)]
    have hpow : σ ^ 2 * (x / (128 * r)) ^ a ≤ (σ * y / 64 / r) ^ a := by
      calc
        σ ^ 2 * (x / (128 * r)) ^ a
            ≤ σ ^ a * (x / (128 * r)) ^ a :=
          mul_le_mul_of_nonneg_right hσpow (by positivity)
        _ = (σ * (x / (128 * r))) ^ a := by
          rw [Real.mul_rpow hσ.le (by positivity)]
        _ ≤ (σ * (y / (64 * r))) ^ a :=
          Real.rpow_le_rpow (by positivity)
            (mul_le_mul_of_nonneg_left hbase hσ.le) ha
        _ = (σ * y / 64 / r) ^ a := by
          congr 1
          field_simp
    have hd : 0 < (128 * r) ^ a := by positivity
    have hxpow : 0 < x ^ a := by positivity
    rw [Real.div_rpow hx.le (by positivity) a, ← mul_div_assoc] at hpow
    have hmul := (div_le_iff₀ hd).mp hpow
    apply (div_le_div_iff₀ hL hxpow).mpr
    simpa only [mul_comm] using hmul

/-- Numerical parameters for the Poincare/capture dichotomy, uniformly down to `σ > 0`.
The large-scale witness is the natural ceiling of `√n`; it never depends on `σ`. -/
theorem uniform_numerical_parameters (r : ℕ) (hr : 3 ≤ r) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, r ≤ n →
      (1 / 4 : ℝ) ≤ C / (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) ∨
      ∃ m : ℕ, r + 1 ≤ m ∧ m ≤ n ∧
        ∀ σ : ℝ, 0 < σ → σ ≤ 1 / 2 →
          let k := σ * Real.log (m : ℝ) / 64
          let L := (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))
          0 < k ∧ 0 < L ∧
            (r : ℝ) * L * ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2 ∧
            2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) + σ ^ 2 / L ≤
              C / (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) := by
  let a : ℝ := (r : ℝ) / ((r : ℝ) - 1)
  have hr3 : (3 : ℝ) ≤ r := by exact_mod_cast hr
  have hr0 : (0 : ℝ) < r := by linarith
  have ha : 0 < a := div_pos hr0 (by linarith)
  have ha2 : a ≤ 2 := by
    dsimp [a]
    apply (div_le_iff₀ (by linarith : (0 : ℝ) < (r : ℝ) - 1)).mpr
    linarith
  obtain ⟨N, hN⟩ := eventually_atTop.mp (eventually_numerical_scales r a)
  let D : ℝ := 2 * (r : ℝ) + (128 * (r : ℝ)) ^ a
  let B : ℝ := (Real.log ((N : ℝ) + 3)) ^ a
  let C : ℝ := D + B + 1
  have hD : 0 < D := by dsimp [D]; positivity
  have hB : 0 ≤ B := by
    dsimp [B]
    apply Real.rpow_nonneg
    apply Real.log_nonneg
    have hN0 : (0 : ℝ) ≤ N := Nat.cast_nonneg N
    linarith
  have hC : 0 < C := by dsimp [C]; linarith
  refine ⟨C, hC, ?_⟩
  intro n hrn
  have hn3 : 3 ≤ n := hr.trans hrn
  have hnx : (1 : ℝ) < n := by exact_mod_cast (show 1 < n by omega)
  have hx : 0 < Real.log (n : ℝ) := Real.log_pos hnx
  have hxpow : 0 < (Real.log (n : ℝ)) ^ a := by positivity
  change (1 / 4 : ℝ) ≤ C / (Real.log (n : ℝ)) ^ a ∨ _
  by_cases hnN : N ≤ n
  · right
    obtain ⟨hn2, m, hrm, hmn, hlog, hmceil, hcap, htail⟩ := hN n hnN
    refine ⟨m, hrm, hmn, ?_⟩
    intro σ hσ hσhalf
    have hmpos : (0 : ℝ) < m := by
      exact_mod_cast (show 0 < m by omega)
    have hm1 : (1 : ℝ) ≤ m := by
      exact_mod_cast (show 1 ≤ m by omega)
    have hn2R : (2 : ℝ) ≤ n := by exact_mod_cast hn2
    have hns : 0 < (n : ℝ) - 1 := by linarith
    have hmnR : (m : ℝ) ≤ n := by exact_mod_cast hmn
    have hlogs : Real.log (m : ℝ) ≤ Real.log (n : ℝ) :=
      Real.log_le_log hmpos hmnR
    let k : ℝ := σ * Real.log (m : ℝ) / 64
    let L : ℝ := (k / (r : ℝ)) ^ a
    obtain ⟨hk, hL, hLupper, hσtail⟩ :=
      uniform_sigma_estimates (r : ℝ) a (Real.log (n : ℝ)) (Real.log (m : ℝ)) σ
        (by linarith) ha.le ha2 hx hlog hlogs hσ hσhalf
    change 0 < k ∧ 0 < L ∧
      (r : ℝ) * L * ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2 ∧
      2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) + σ ^ 2 / L ≤
        C / (Real.log (n : ℝ)) ^ a
    refine ⟨hk, hL, ?_, ?_⟩
    · apply (div_le_iff₀ hns).mpr
      have hprod :
          (r : ℝ) * L * ((m : ℝ) - 1) ≤
            (r : ℝ) * (Real.log (n : ℝ)) ^ a * Real.sqrt (n : ℝ) := by
        gcongr
      have hcap' := mul_le_mul_of_nonneg_right hcap (Real.sqrt_nonneg (n : ℝ))
      rw [Real.mul_self_sqrt (by positivity : (0 : ℝ) ≤ n)] at hcap'
      nlinarith
    · have hneg : (m : ℝ) ^ (-1 / 4 : ℝ) * (Real.log (n : ℝ)) ^ a ≤ 1 := by
        calc
          (m : ℝ) ^ (-1 / 4 : ℝ) * (Real.log (n : ℝ)) ^ a
              ≤ (m : ℝ) ^ (-1 / 4 : ℝ) * (m : ℝ) ^ (1 / 4 : ℝ) :=
            mul_le_mul_of_nonneg_left htail (by positivity)
          _ = 1 := by
            rw [show (-1 / 4 : ℝ) = -(1 / 4 : ℝ) by norm_num,
              Real.rpow_neg hmpos.le]
            exact inv_mul_cancel₀ (ne_of_gt (Real.rpow_pos_of_pos hmpos _))
      have hfirst :
          2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) ≤
            (2 * (r : ℝ)) / (Real.log (n : ℝ)) ^ a := by
        apply (le_div_iff₀ hxpow).mpr
        have h := mul_le_mul_of_nonneg_left hneg (show (0 : ℝ) ≤ 2 * r by positivity)
        simpa only [mul_assoc, mul_one] using h
      calc
        2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) + σ ^ 2 / L
            ≤ (2 * (r : ℝ)) / (Real.log (n : ℝ)) ^ a +
                (128 * (r : ℝ)) ^ a / (Real.log (n : ℝ)) ^ a :=
          add_le_add hfirst hσtail
        _ = D / (Real.log (n : ℝ)) ^ a := by
          dsimp [D]
          rw [add_div]
        _ ≤ C / (Real.log (n : ℝ)) ^ a :=
          (div_le_div_iff_of_pos_right hxpow).mpr (by dsimp [C]; linarith)
  · left
    have hnB : (n : ℝ) ≤ (N : ℝ) + 3 := by
      have hnN' : n ≤ N := by omega
      have hcast : (n : ℝ) ≤ N := by exact_mod_cast hnN'
      linarith
    have hlogB : Real.log (n : ℝ) ≤ Real.log ((N : ℝ) + 3) :=
      Real.log_le_log (by linarith) hnB
    have hpowB : (Real.log (n : ℝ)) ^ a ≤ B :=
      Real.rpow_le_rpow hx.le hlogB ha.le
    apply (le_div_iff₀ hxpow).mpr
    dsimp [C]
    nlinarith

end HypergraphInfluence
