import Mathlib

namespace DimensionWindowCertificate

theorem ceiling_increment (s t : ℝ) :
    (⌈t⌉ : ℝ) - (⌈s⌉ : ℝ) ≤ t - s + 1 := by
  have hs := Int.le_ceil s
  have ht := Int.ceil_lt_add_one t
  linarith

theorem adjusted_depth_antitone (σ : ℕ → ℝ) (hσ : Monotone σ) (L : ℝ) :
    Antitone (fun j => L - (⌈σ j⌉ : ℝ)) := by
  intro j k hjk
  have hc : ⌈σ j⌉ ≤ ⌈σ k⌉ := Int.ceil_mono (hσ hjk)
  have hc' : (⌈σ j⌉ : ℝ) ≤ (⌈σ k⌉ : ℝ) := by exact_mod_cast hc
  linarith

theorem finer_window_before_coarser (σ : ℕ → ℝ) (hσ : Monotone σ)
    (j n k : ℕ) (a B C L : ℝ)
    (hstart : a ≤ L - (⌈σ j⌉ : ℝ))
    (hincrement : σ (j + n) - σ j ≤ C)
    (hseparation : B < a - C - 1)
    (hcoarse : L - (⌈σ k⌉ : ℝ) ≤ B) :
    j + n < k := by
  have hceil := ceiling_increment (σ j) (σ (j + n))
  have hend : a - C - 1 ≤ L - (⌈σ (j + n)⌉ : ℝ) := by linarith
  by_contra hn
  have hk : k ≤ j + n := by omega
  have horder := adjusted_depth_antitone σ hσ L hk
  linarith

theorem ordered_window_gain_bound (g : ℕ → ℝ) (hg : Antitone g)
    (hzero : ∀ j, 0 ≤ g j) (ws : List (ℕ × ℕ)) (s : ℕ)
    (hstarts : ∀ w ∈ ws, s ≤ w.1)
    (horder : ws.Pairwise (fun a b => a.2 ≤ b.1)) :
    (ws.map (fun w => g w.1 - g w.2)).sum ≤ g s := by
  induction ws generalizing s with
  | nil => simpa using hzero s
  | cons w ws ih =>
      have hp := List.pairwise_cons.mp horder
      have htail := ih w.2 (fun v hv => hp.1 v hv) hp.2
      have hfirst := hg (hstarts w (by simp))
      simp only [List.map_cons, List.sum_cons]
      linarith

theorem target_recovery (U z a b ell : ℤ)
    (ha : 1 ≤ a) (hz : 0 ≤ z) (hzu : z ≤ U) (hb : b < U)
    (hell : a ≤ ell ∧ ell ≤ b) :
    ∃! L : ℤ, 1 ≤ L ∧ L ≤ 2 * U ∧ L - z = ell := by
  refine ⟨ell + z, ?_, ?_⟩
  · omega
  · intro L hL
    omega

theorem candidate_mass_bound (D n T : ℝ) (hD : 0 < D) (hn : 0 < n) :
    T / (2 * D) ≤ ((⌊T / (2 * D * n)⌋ : ℝ) + 1) * n := by
  have hf := (Int.lt_floor_add_one (T / (2 * D * n))).le
  have hd : 0 < 2 * D * n := by positivity
  have hm := (div_le_iff₀ hd).mp hf
  apply (div_le_iff₀ (by positivity : 0 < 2 * D)).mpr
  nlinarith

theorem eventually_separated (A A' B : ℝ) (hgap : A' < A) :
    ∃ N : ℕ, ∀ n : ℕ, N ≤ n →
      B < (⌈A * (n : ℝ)⌉ : ℝ) - 1 - A' * (n : ℝ) - 1 := by
  have hpos : 0 < A - A' := sub_pos.mpr hgap
  obtain ⟨N, hN⟩ := exists_nat_gt ((B + 2) / (A - A'))
  refine ⟨N, ?_⟩
  intro n hn
  have hn' : (N : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hm := (div_lt_iff₀ hpos).mp hN
  have hceil := Int.le_ceil (A * (n : ℝ))
  have hmon := mul_le_mul_of_nonneg_left hn' hpos.le
  nlinarith

theorem no_uniform_positive_band_count (δ c B : ℝ)
    (hδ : 0 < δ) (hc : 0 < c) :
    ¬ (∀ q : ℕ, δ * c * (q : ℝ) ≤ B) := by
  intro h
  obtain ⟨q, hq⟩ := exists_nat_gt (B / (δ * c))
  have hm := (div_lt_iff₀ (mul_pos hδ hc)).mp hq
  have hb := h q
  nlinarith

#print axioms ceiling_increment
#print axioms adjusted_depth_antitone
#print axioms finer_window_before_coarser
#print axioms ordered_window_gain_bound
#print axioms target_recovery
#print axioms candidate_mass_bound
#print axioms eventually_separated
#print axioms no_uniform_positive_band_count

end DimensionWindowCertificate
