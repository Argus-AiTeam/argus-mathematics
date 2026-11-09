import Mathlib

open Filter MeasureTheory
open scoped Topology

namespace SheetRigidity

noncomputable section

theorem compact_lexicographic_control
    (K : Set (ℝ × ℝ)) (hK : IsCompact K) (A B : ℝ)
    (hleft : ∀ p ∈ K, p.1 ≤ A)
    (hfiber : ∀ p ∈ K, p.1 = A → p.2 ≤ B)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ δ > 0, ∀ p ∈ K, A - δ < p.1 → p.2 ≤ B + ε := by
  let bad : Set (ℝ × ℝ) := K ∩ {p | B + ε ≤ p.2}
  have hbad : IsCompact bad :=
    hK.inter_right (isClosed_le continuous_const continuous_snd)
  by_cases hb : bad.Nonempty
  · obtain ⟨p, hp, hmax⟩ := hbad.exists_isMaxOn hb continuous_fst.continuousOn
    have hpA : p.1 < A := by
      by_contra hn
      have heq : p.1 = A :=
        le_antisymm (hleft p hp.1) (le_of_not_gt hn)
      have hptop := hfiber p hp.1 heq
      have hpbad : B + ε ≤ p.2 := hp.2
      linarith
    refine ⟨A - p.1, sub_pos.mpr hpA, ?_⟩
    intro q hq hnear
    by_contra hn
    have hqbad : q ∈ bad := ⟨hq, le_of_lt (lt_of_not_ge hn)⟩
    have hqp : q.1 ≤ p.1 := hmax hqbad
    linarith
  · refine ⟨1, zero_lt_one, ?_⟩
    intro p hp _
    by_contra hn
    exact hb ⟨p, hp, le_of_lt (lt_of_not_ge hn)⟩

theorem pointwise_envelope
    (A B C ε δ s t : ℝ) (hB : 0 ≤ B) (hC : 0 ≤ C)
    (hε : 0 ≤ ε) (hδ : 0 < δ) (hs : s ≤ A) (ht : t ≤ C)
    (hnear : A - s < δ → t ≤ B + ε) :
    t ≤ B + ε + C / δ * (A - s) := by
  have hc : 0 ≤ C / δ := div_nonneg hC hδ.le
  by_cases hd : A - s < δ
  · have := mul_nonneg hc (sub_nonneg.mpr hs)
    linarith [hnear hd]
  · have hm := mul_le_mul_of_nonneg_left (le_of_not_gt hd) hc
    have hr : C / δ * δ = C := div_mul_cancel₀ C hδ.ne'
    linarith

theorem expectation_envelope
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (K : Set (ℝ × ℝ)) (A B C ε δ : ℝ)
    (hB : 0 ≤ B) (hC : 0 ≤ C) (hε : 0 ≤ ε) (hδ : 0 < δ)
    (hleft : ∀ p ∈ K, p.1 ≤ A) (htop : ∀ p ∈ K, p.2 ≤ C)
    (hnear : ∀ p ∈ K, A - δ < p.1 → p.2 ≤ B + ε)
    (s t : Ω → ℝ) (hs : Integrable s μ) (ht : Integrable t μ)
    (hmem : ∀ᵐ x ∂μ, (s x, t x) ∈ K) :
    (∫ x, t x ∂μ) ≤ B + ε + C / δ * (A - ∫ x, s x ∂μ) := by
  have hu : Integrable (fun x => B + ε + C / δ * (A - s x)) μ :=
    (integrable_const _).add (((integrable_const _).sub hs).const_mul _)
  have hpoint : ∀ᵐ x ∂μ, t x ≤ B + ε + C / δ * (A - s x) := by
    filter_upwards [hmem] with x hx
    apply pointwise_envelope A B C ε δ (s x) (t x) hB hC hε hδ
      (hleft _ hx) (htop _ hx)
    intro hd
    exact hnear _ hx (by linarith)
  calc
    (∫ x, t x ∂μ) ≤ ∫ x, B + ε + C / δ * (A - s x) ∂μ :=
      integral_mono_ae ht hu hpoint
    _ = B + ε + C / δ * (A - ∫ x, s x ∂μ) := by
      have hsub : Integrable (fun x => A - s x) μ := (integrable_const A).sub hs
      have hmul : Integrable (fun x => C / δ * (A - s x)) μ := hsub.const_mul _
      rw [integral_add (integrable_const (B + ε)) hmul,
        integral_const_mul, integral_sub (integrable_const A) hs]
      simp

theorem horizontal_energy_bound
    (D A a e ρ m u2 cross variance energy : ℝ)
    (hm : m ≤ A) (hu : A - u2 ≤ a)
    (hc : -D * (2 * D * ρ + e) ≤ cross)
    (hv : variance = m - u2 - 2 * cross)
    (he : energy ≤ 2 * variance + 2 * e ^ 2) :
    energy ≤ 2 * a + 4 * D * e + 8 * D ^ 2 * ρ + 2 * e ^ 2 := by
  nlinarith

theorem horizontal_deficit_bound
    (D A a e W m u2 cross variance : ℝ)
    (hu : A - u2 ≤ a) (hc : -D * (2 * D / W + e) ≤ cross)
    (hv : variance = m - u2 - 2 * cross) (hn : 0 ≤ variance) :
    A - m ≤ a + 2 * D * e + 4 * D ^ 2 / W := by
  simp only [div_eq_mul_inv] at hc ⊢
  nlinarith

theorem vertical_energy_bound
    (D B b e ρ ε δ η m v2 cross variance energy : ℝ)
    (hm : m ≤ B + ε + D ^ 2 / δ * η) (hv2 : B - v2 ≤ b)
    (hc : -D * (2 * D * ρ + e) ≤ cross)
    (hv : variance = m - v2 - 2 * cross)
    (he : energy ≤ 2 * variance + 2 * e ^ 2) :
    energy ≤ 2 * ε + (2 * D ^ 2 / δ) * η +
      (2 * b + 8 * D ^ 2 * ρ + 4 * D * e + 2 * e ^ 2) := by
  simp only [div_eq_mul_inv] at hm ⊢
  nlinarith

theorem energy_converges
    {Ω : Type*} [MeasurableSpace Ω]
    (K : Set (ℝ × ℝ)) (hK : IsCompact K) (A B D : ℝ) (hB : 0 ≤ B)
    (hleft : ∀ p ∈ K, p.1 ≤ A) (htop : ∀ p ∈ K, p.2 ≤ D ^ 2)
    (hfiber : ∀ p ∈ K, p.1 = A → p.2 ≤ B)
    (μ : ℕ → Measure Ω) (hprob : ∀ n, IsProbabilityMeasure (μ n))
    (s t : ℕ → Ω → ℝ)
    (hs : ∀ n, Integrable (s n) (μ n)) (ht : ∀ n, Integrable (t n) (μ n))
    (hmem : ∀ n, ∀ᵐ x ∂μ n, (s n x, t n x) ∈ K)
    (H V hRaw etaRaw vRaw : ℕ → ℝ)
    (hHnonneg : ∀ n, 0 ≤ H n) (hVnonneg : ∀ n, 0 ≤ V n)
    (hHbound : ∀ n, H n ≤ hRaw n)
    (hEtaBound : ∀ n, A - (∫ x, s n x ∂μ n) ≤ etaRaw n)
    (hVbound : ∀ n, V n ≤ 2 * ((∫ x, t n x ∂μ n) - B) + vRaw n)
    (hHlim : Tendsto hRaw atTop (𝓝 0))
    (hEtalim : Tendsto etaRaw atTop (𝓝 0))
    (hVlim : Tendsto vRaw atTop (𝓝 0)) :
    Tendsto (fun n => H n + V n) atTop (𝓝 0) := by
  rw [Metric.tendsto_nhds]
  intro ε hε
  obtain ⟨δ, hδ, hnear⟩ :=
    compact_lexicographic_control K hK A B hleft hfiber (ε / 4) (by linarith)
  let c : ℝ := 2 * D ^ 2 / δ
  have hc : 0 ≤ c := by dsimp [c]; positivity
  have hrest : Tendsto (fun n => hRaw n + c * etaRaw n + vRaw n)
      atTop (𝓝 0) := by
    simpa using (hHlim.add (hEtalim.const_mul c)).add hVlim
  have hev : ∀ᶠ n in atTop, hRaw n + c * etaRaw n + vRaw n < ε / 2 :=
    (tendsto_order.1 hrest).2 _ (by linarith)
  filter_upwards [hev] with n hn
  letI := hprob n
  have hy := expectation_envelope (μ n) K A B (D ^ 2) (ε / 4) δ
    hB (sq_nonneg D) (by linarith) hδ hleft htop hnear
    (s n) (t n) (hs n) (ht n) (hmem n)
  have hη := mul_le_mul_of_nonneg_left (hEtaBound n) hc
  have hv : V n ≤ ε / 2 + c * etaRaw n + vRaw n := by
    dsimp [c] at hη ⊢
    simp only [div_eq_mul_inv] at hy hη ⊢
    nlinarith [hVbound n]
  have htotal : H n + V n < ε := by linarith [hHbound n]
  simpa [Real.dist_eq, abs_of_nonneg (add_nonneg (hHnonneg n) (hVnonneg n))]
    using htotal

def horizontalRaw (D N : ℝ) (n : ℕ) : ℝ :=
  2 * (1 + 4 * D) * ((n : ℝ)⁻¹) ^ 2 +
    (4 * D ^ 2 / (25 * N)) * ((n : ℝ)⁻¹) ^ 7 + 8 * ((n : ℝ)⁻¹) ^ 6

def deficitRaw (D : ℝ) (n : ℕ) : ℝ :=
  (1 + 4 * D) * ((n : ℝ)⁻¹) ^ 4 + 4 * D ^ 2 * (n : ℝ)⁻¹

def verticalRaw (D N : ℝ) (n : ℕ) : ℝ :=
  2 * (1 + 4 * D) * ((n : ℝ)⁻¹) ^ 4 +
    (4 * D ^ 2 / (25 * N)) * ((n : ℝ)⁻¹) ^ 9 + 8 * ((n : ℝ)⁻¹) ^ 8

theorem manuscript_raw_limits (D N : ℝ) :
    Tendsto (horizontalRaw D N) atTop (𝓝 0) ∧
      Tendsto (deficitRaw D) atTop (𝓝 0) ∧
      Tendsto (verticalRaw D N) atTop (𝓝 0) := by
  have hi : Tendsto (fun n : ℕ => (n : ℝ)⁻¹) atTop (𝓝 0) :=
    tendsto_inv_atTop_zero.comp tendsto_natCast_atTop_atTop
  constructor
  · unfold horizontalRaw
    simpa using
      (((hi.pow 2).const_mul (2 * (1 + 4 * D))).add
        ((hi.pow 7).const_mul (4 * D ^ 2 / (25 * N)))).add
        ((hi.pow 6).const_mul 8)
  constructor
  · unfold deficitRaw
    simpa using
      ((hi.pow 4).const_mul (1 + 4 * D)).add (hi.const_mul (4 * D ^ 2))
  · unfold verticalRaw
    simpa using
      (((hi.pow 4).const_mul (2 * (1 + 4 * D))).add
        ((hi.pow 9).const_mul (4 * D ^ 2 / (25 * N)))).add
        ((hi.pow 8).const_mul 8)

theorem manuscript_raw_limits_positive (D N : ℝ) :
    Tendsto (fun n => horizontalRaw D N (n + 1)) atTop (𝓝 0) ∧
      Tendsto (fun n => deficitRaw D (n + 1)) atTop (𝓝 0) ∧
      Tendsto (fun n => verticalRaw D N (n + 1)) atTop (𝓝 0) := by
  have h := manuscript_raw_limits D N
  exact ⟨h.1.comp (tendsto_add_atTop_nat 1),
    h.2.1.comp (tendsto_add_atTop_nat 1), h.2.2.comp (tendsto_add_atTop_nat 1)⟩

theorem mean_line_choice
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (g : Ω → ℝ) (hg : Integrable g μ) (hnonneg : ∀ᵐ x ∂μ, 0 ≤ g x)
    (good : Ω → Prop) (hgood : ∀ᵐ x ∂μ, good x)
    (b : ℝ) (hb : 0 ≤ b) (hmean : (∫ x, g x ∂μ) ≤ b) :
    ∃ x, good x ∧ g x ≤ 2 * b := by
  by_cases hbzero : b = 0
  · have hz : (∫ x, g x ∂μ) = 0 :=
      le_antisymm (by simpa [hbzero] using hmean) (integral_nonneg_of_ae hnonneg)
    have hgzero : ∀ᵐ x ∂μ, g x = 0 :=
      (integral_eq_zero_iff_of_nonneg_ae hnonneg hg).1 hz
    obtain ⟨x, hxgood, hxzero⟩ := (hgood.and hgzero).exists
    exact ⟨x, hxgood, by simp [hxzero, hbzero]⟩
  · have hbpos : 0 < b := lt_of_le_of_ne hb (Ne.symm hbzero)
    by_contra hn
    push Not at hn
    have hlow : ∀ᵐ x ∂μ, 2 * b ≤ g x := by
      filter_upwards [hgood] with x hx
      exact (hn x hx).le
    have hm : 2 * b ≤ ∫ x, g x ∂μ := by
      simpa using integral_mono_ae (integrable_const (2 * b)) hg hlow
    linarith

structure LineSystem (N : ℕ) (E : Type*) [PseudoMetricSpace E]
    (σ D : ℝ) (o : E) where
  offset : Fin N → ℝ → ℝ → E
  rowMeasure : Fin N → Measure ℝ
  colMeasure : Fin N → Measure ℝ
  rowProbability : ∀ i, IsProbabilityMeasure (rowMeasure i)
  colProbability : ∀ i, IsProbabilityMeasure (colMeasure i)
  rowEnergy : Fin N → ℝ → ℝ
  colEnergy : Fin N → ℝ → ℝ
  rowIntegrable : ∀ i, Integrable (rowEnergy i) (rowMeasure i)
  colIntegrable : ∀ i, Integrable (colEnergy i) (colMeasure i)
  rowNonneg : ∀ i, ∀ᵐ y ∂rowMeasure i, 0 ≤ rowEnergy i y
  colNonneg : ∀ i, ∀ᵐ x ∂colMeasure i, 0 ≤ colEnergy i x
  rowMean : ∀ i, (∫ y, rowEnergy i y ∂rowMeasure i) ≤ (N : ℝ) * σ
  colMean : ∀ i, (∫ x, colEnergy i x ∂colMeasure i) ≤ (N : ℝ) * σ
  rowGood : Fin N → ℝ → Prop
  colGood : Fin N → ℝ → Prop
  rowGoodAE : ∀ i, ∀ᵐ y ∂rowMeasure i, rowGood i y
  colGoodAE : ∀ i, ∀ᵐ x ∂colMeasure i, colGood i x
  rowOscillation : ∀ i y, rowGood i y → ∀ x x',
    dist (offset i x y) (offset i x' y) ^ 2 ≤ (N : ℝ) ^ 2 * rowEnergy i y
  colOscillation : ∀ i x, colGood i x → ∀ y y',
    dist (offset i x y) (offset i x y') ^ 2 ≤ (N : ℝ) ^ 2 * colEnergy i x
  crossing : ∀ i j, i ≠ j → ∀ x y, rowGood i y → colGood j x →
    (7 : ℝ) / 5 ≤ dist (offset i x y) (offset j x y)
  radius : ∀ i x y, rowGood i y → colGood i x → dist (offset i x y) o ≤ D

theorem small_transport (N : ℕ) (σ d : ℝ)
    (_hd : 0 ≤ d) (hsq : d ^ 2 ≤ 2 * (N : ℝ) ^ 3 * σ)
    (hbudget : 128 * (N : ℝ) ^ 3 * σ < 1) :
    d < 1 / 8 := by
  nlinarith [sq_nonneg (d - 1 / 8)]

theorem select_crossings
    {N : ℕ} {E : Type*} [PseudoMetricSpace E] {σ D : ℝ} {o : E}
    (L : LineSystem N E σ D o) (hσ : 0 ≤ σ)
    (hbudget : 128 * (N : ℝ) ^ 3 * σ < 1) :
    ∃ z : Fin N → E, (∀ i, dist (z i) o ≤ D) ∧
      ∀ i j, i ≠ j → 1 < dist (z i) (z j) := by
  have hr : ∀ i, ∃ y, L.rowGood i y ∧
      L.rowEnergy i y ≤ 2 * ((N : ℝ) * σ) := by
    intro i
    letI := L.rowProbability i
    exact mean_line_choice (L.rowMeasure i) (L.rowEnergy i)
      (L.rowIntegrable i) (L.rowNonneg i) (L.rowGood i) (L.rowGoodAE i)
      ((N : ℝ) * σ) (mul_nonneg (Nat.cast_nonneg N) hσ) (L.rowMean i)
  have hc : ∀ i, ∃ x, L.colGood i x ∧
      L.colEnergy i x ≤ 2 * ((N : ℝ) * σ) := by
    intro i
    letI := L.colProbability i
    exact mean_line_choice (L.colMeasure i) (L.colEnergy i)
      (L.colIntegrable i) (L.colNonneg i) (L.colGood i) (L.colGoodAE i)
      ((N : ℝ) * σ) (mul_nonneg (Nat.cast_nonneg N) hσ) (L.colMean i)
  choose y hy using hr
  choose x hx using hc
  refine ⟨fun i => L.offset i (x i) (y i), ?_, ?_⟩
  · intro i
    exact L.radius i (x i) (y i) (hy i).1 (hx i).1
  · intro i j hij
    have hrsq : dist (L.offset i (x j) (y i)) (L.offset i (x i) (y i)) ^ 2
        ≤ 2 * (N : ℝ) ^ 3 * σ := by
      have h := L.rowOscillation i (y i) (hy i).1 (x j) (x i)
      have hm := mul_le_mul_of_nonneg_left (hy i).2 (sq_nonneg (N : ℝ))
      nlinarith
    have hcsq : dist (L.offset j (x j) (y j)) (L.offset j (x j) (y i)) ^ 2
        ≤ 2 * (N : ℝ) ^ 3 * σ := by
      have h := L.colOscillation j (x j) (hx j).1 (y j) (y i)
      have hm := mul_le_mul_of_nonneg_left (hx j).2 (sq_nonneg (N : ℝ))
      nlinarith
    have hrsmall := small_transport N σ _ dist_nonneg hrsq hbudget
    have hcsmall := small_transport N σ _ dist_nonneg hcsq hbudget
    have hsep := L.crossing i j hij (x j) (y i) (hy i).1 (hx j).1
    have ht1 := dist_triangle (L.offset i (x j) (y i))
      (L.offset i (x i) (y i)) (L.offset j (x j) (y i))
    have ht2 := dist_triangle (L.offset i (x i) (y i))
      (L.offset j (x j) (y j)) (L.offset j (x j) (y i))
    dsimp
    linarith

theorem energy_to_crossing
    {Ω : Type*} [MeasurableSpace Ω]
    {N : ℕ} {E : Type*} [PseudoMetricSpace E] (o : E)
    (K : Set (ℝ × ℝ)) (hK : IsCompact K) (A B D : ℝ) (hB : 0 ≤ B)
    (hleft : ∀ p ∈ K, p.1 ≤ A) (htop : ∀ p ∈ K, p.2 ≤ D ^ 2)
    (hfiber : ∀ p ∈ K, p.1 = A → p.2 ≤ B)
    (μ : ℕ → Measure Ω) (hprob : ∀ n, IsProbabilityMeasure (μ n))
    (s t : ℕ → Ω → ℝ)
    (hs : ∀ n, Integrable (s n) (μ n)) (ht : ∀ n, Integrable (t n) (μ n))
    (hmem : ∀ n, ∀ᵐ x ∂μ n, (s n x, t n x) ∈ K)
    (H V hRaw etaRaw vRaw : ℕ → ℝ)
    (hHnonneg : ∀ n, 0 ≤ H n) (hVnonneg : ∀ n, 0 ≤ V n)
    (hHbound : ∀ n, H n ≤ hRaw n)
    (hEtaBound : ∀ n, A - (∫ x, s n x ∂μ n) ≤ etaRaw n)
    (hVbound : ∀ n, V n ≤ 2 * ((∫ x, t n x ∂μ n) - B) + vRaw n)
    (hHlim : Tendsto hRaw atTop (𝓝 0))
    (hEtalim : Tendsto etaRaw atTop (𝓝 0))
    (hVlim : Tendsto vRaw atTop (𝓝 0))
    (L : ∀ n, LineSystem N E (H n + V n) D o) :
    ∀ᶠ (_n : ℕ) in atTop, ∃ z : Fin N → E, (∀ i, dist (z i) o ≤ D) ∧
      ∀ i j, i ≠ j → 1 < dist (z i) (z j) := by
  have hlim := energy_converges K hK A B D hB hleft htop hfiber μ hprob s t
    hs ht hmem H V hRaw etaRaw vRaw hHnonneg hVnonneg hHbound hEtaBound
    hVbound hHlim hEtalim hVlim
  have hbudgetlim : Tendsto (fun n => 128 * (N : ℝ) ^ 3 * (H n + V n))
      atTop (𝓝 0) := by
    simpa using hlim.const_mul (128 * (N : ℝ) ^ 3)
  have hev : ∀ᶠ n in atTop, 128 * (N : ℝ) ^ 3 * (H n + V n) < 1 :=
    (tendsto_order.1 hbudgetlim).2 1 (by norm_num)
  filter_upwards [hev] with n hn
  exact select_crossings (L n) (add_nonneg (hHnonneg n) (hVnonneg n)) hn

end

end SheetRigidity
