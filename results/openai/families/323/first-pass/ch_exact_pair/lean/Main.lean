import Mathlib.Analysis.Normed.Lp.PiLp
import Mathlib.Tactic

open scoped BigOperators ENNReal

namespace ExactPair

variable {ι H G : Type*} [Fintype ι] [Fintype H] [Fintype G]

theorem power_sum_at_most_one (f : H → ℝ) (r : ℝ) (hr : r ≠ 0)
    (hdis : ∀ h k, h ≠ k → f h = 0 ∨ f k = 0) :
    |∑ h, f h| ^ r = ∑ h, |f h| ^ r := by
  classical
  by_cases hz : ∀ h, f h = 0
  · simp [hz, Real.zero_rpow hr]
  · obtain ⟨h₀, hh₀⟩ := not_forall.mp hz
    have hother : ∀ h, h ≠ h₀ → f h = 0 := by
      intro h hh
      rcases hdis h h₀ hh with hzero | hzero
      · exact hzero
      · exact False.elim (hh₀ hzero)
    rw [Fintype.sum_eq_single h₀ (fun h hh => hother h hh),
      Fintype.sum_eq_single h₀ (fun h hh => by
        simp [hother h hh, Real.zero_rpow hr])]

abbrev Vec (p : ℝ≥0∞) (ι : Type*) := PiLp p (fun _ : ι => ℝ)

variable {p : ℝ≥0∞} [Fact (1 ≤ p)]

theorem exponent_pos (hp : p ≠ ∞) : 0 < p.toReal := by
  apply ENNReal.toReal_pos_iff.mpr
  constructor
  · exact lt_of_lt_of_le (by norm_num : (0 : ℝ≥0∞) < 1) (Fact.out : 1 ≤ p)
  · exact lt_top_iff_ne_top.mpr hp

omit [Fintype ι] [Fact (1 ≤ p)] in
theorem sum_apply (w : H → Vec p ι) (i : ι) :
    (∑ h, w h) i = ∑ h, w h i := by
  change (WithLp.ofLp (∑ h, w h)) i = _
  simp only [WithLp.ofLp_sum, Finset.sum_apply]

theorem norm_power (hp : p ≠ ∞) (w : Vec p ι) :
    ‖w‖ ^ p.toReal = ∑ i, ‖w i‖ ^ p.toReal := by
  have hr := exponent_pos hp
  rw [PiLp.norm_eq_sum hr, ← Real.rpow_mul (by positivity)]
  simp [one_div, inv_mul_cancel₀ hr.ne']

theorem disjoint_sum_norm (hp : p ≠ ∞) (w : H → Vec p ι)
    (hdis : ∀ i h k, h ≠ k → w h i = 0 ∨ w k i = 0) :
    ‖∑ h, w h‖ = (∑ h, ‖w h‖ ^ p.toReal) ^ (1 / p.toReal) := by
  have hr := exponent_pos hp
  rw [PiLp.norm_eq_sum hr]
  congr 1
  calc
    (∑ i, ‖(∑ h, w h) i‖ ^ p.toReal) =
        ∑ i, ∑ h, ‖w h i‖ ^ p.toReal := by
      apply Finset.sum_congr rfl
      intro i _
      simp only [sum_apply, Real.norm_eq_abs]
      exact power_sum_at_most_one _ _ hr.ne' (hdis i)
    _ = ∑ h, ∑ i, ‖w h i‖ ^ p.toReal := Finset.sum_comm
    _ = ∑ h, ‖w h‖ ^ p.toReal := by
      apply Finset.sum_congr rfl
      intro h _
      exact (norm_power hp (w h)).symm

theorem disjoint_sum_bound (hp : p ≠ ∞) (w : H → Vec p ι)
    (hdis : ∀ i h k, h ≠ k → w h i = 0 ∨ w k i = 0)
    (K : ℝ) (hK : 0 ≤ K) (hw : ∀ h, ‖w h‖ ≤ K) :
    ‖∑ h, w h‖ ≤ (Fintype.card H : ℝ) ^ (1 / p.toReal) * K := by
  have hr := exponent_pos hp
  rw [disjoint_sum_norm hp w hdis]
  calc
    (∑ h, ‖w h‖ ^ p.toReal) ^ (1 / p.toReal) ≤
        (∑ _h : H, K ^ p.toReal) ^ (1 / p.toReal) := by
      apply Real.rpow_le_rpow (by positivity)
      · exact Finset.sum_le_sum (fun h _ =>
          Real.rpow_le_rpow (norm_nonneg _) (hw h) hr.le)
      · positivity
    _ = ((Fintype.card H : ℝ) * K ^ p.toReal) ^ (1 / p.toReal) := by simp
    _ = (Fintype.card H : ℝ) ^ (1 / p.toReal) * K := by
      rw [Real.mul_rpow (by positivity) (Real.rpow_nonneg hK _),
        ← Real.rpow_mul hK]
      simp [one_div, mul_inv_cancel₀ hr.ne']

theorem grouped_bound {H : G → Type*} [∀ g, Fintype (H g)]
    (hp : p ≠ ∞) (w : (g : G) → H g → Vec p ι)
    (hdis : ∀ g i h k, h ≠ k → w g h i = 0 ∨ w g k i = 0)
    (a : G → ℝ) (ha : ∀ g, 0 ≤ a g)
    (K : ℝ) (hK : 0 ≤ K) (hw : ∀ g h, ‖w g h‖ ≤ K) :
    ‖∑ g, a g • ∑ h, w g h‖ ≤
      K * ∑ g, a g * (Fintype.card (H g) : ℝ) ^ (1 / p.toReal) := by
  calc
    ‖∑ g, a g • ∑ h, w g h‖ ≤ ∑ g, ‖a g • ∑ h, w g h‖ :=
      norm_sum_le _ _
    _ = ∑ g, a g * ‖∑ h, w g h‖ := by
      apply Finset.sum_congr rfl
      intro g _
      simp [norm_smul, Real.norm_eq_abs, abs_of_nonneg (ha g)]
    _ ≤ ∑ g, a g * ((Fintype.card (H g) : ℝ) ^ (1 / p.toReal) * K) := by
      apply Finset.sum_le_sum
      intro g _
      exact mul_le_mul_of_nonneg_left
        (disjoint_sum_bound hp (w g) (hdis g) K hK (hw g)) (ha g)
    _ = K * ∑ g, a g * (Fintype.card (H g) : ℝ) ^ (1 / p.toReal) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro g _
      ring

omit [Fintype ι] [Fintype H] [Fact (1 ≤ p)] in
theorem assignments_give_disjointness (S : H → Finset ι)
    (hS : ∀ h k, h ≠ k → Disjoint (S h) (S k))
    (w : H → Vec p ι) (hw : ∀ h i, i ∉ S h → w h i = 0) :
    ∀ i h k, h ≠ k → w h i = 0 ∨ w k i = 0 := by
  intro i h k hne
  by_cases hi : i ∈ S h
  · right
    apply hw k i
    intro hik
    exact Finset.disjoint_left.mp (hS h k hne) hi hik
  · exact Or.inl (hw h i hi)

omit [Fintype ι] [Fact (1 ≤ p)] in
theorem supported_recombine {H : G → Type*} [∀ g, Fintype (H g)]
    (S : Finset ι) (T : (g : G) → H g → Finset ι)
    (hsub : ∀ g h, T g h ⊆ S)
    (w : (g : G) → H g → Vec p ι)
    (hw : ∀ g h i, i ∉ T g h → w g h i = 0) (a : G → ℝ) :
    ∀ i, i ∉ S → (∑ g, a g • ∑ h, w g h) i = 0 := by
  intro i hi
  have hz : ∀ g h, w g h i = 0 := by
    intro g h
    apply hw g h i
    exact fun hit => hi (hsub g h hit)
  simp only [sum_apply, PiLp.smul_apply, smul_eq_mul]
  simp [hz]

theorem product_crop_between {β Ω κ : Type*} [LinearOrder β]
    {D : κ → Type*} [∀ t, LinearOrder (D t)]
    (S : β → Set Ω) (coord : (t : κ) → Ω → D t) (C : (t : κ) → Set (D t))
    (hconv : ∀ t (a b c : D t), a ∈ C t → c ∈ C t → a ≤ b → b ≤ c → b ∈ C t)
    (hsucc : ∀ i j, i < j → ∀ a ∈ S i, ∀ b ∈ S j,
      ∀ t, coord t a < coord t b)
    {i j k : β} (hij : i < j) (hjk : j < k)
    (hi : ∃ a ∈ S i, ∀ t, coord t a ∈ C t)
    (hk : ∃ c ∈ S k, ∀ t, coord t c ∈ C t) :
    ∀ b ∈ S j, ∀ t, coord t b ∈ C t := by
  obtain ⟨a, ha, haC⟩ := hi
  obtain ⟨c, hc, hcC⟩ := hk
  intro b hb t
  exact hconv t _ _ _ (haC t) (hcC t)
    (hsucc i j hij a ha b hb t).le (hsucc j k hjk b hb c hc t).le

theorem at_most_two_partial {β : Type*} [LinearOrder β]
    (hits edgeHits : Finset β) (hsub : edgeHits ⊆ hits)
    (hbetween : ∀ a ∈ hits, ∀ b ∈ edgeHits, ∀ c ∈ hits, a < b → b < c → False) :
    edgeHits.card ≤ 2 := by
  classical
  rcases hits.eq_empty_or_nonempty with hempty | hne
  · have hcard := Finset.card_le_card hsub
    rw [hempty, Finset.card_empty] at hcard
    omega
  · have hends : edgeHits ⊆ {hits.min' hne, hits.max' hne} := by
      intro b hb
      by_cases hmin : b = hits.min' hne
      · simp [hmin]
      by_cases hmax : b = hits.max' hne
      · simp [hmax]
      exact False.elim (hbetween _ (hits.min'_mem hne) b hb _ (hits.max'_mem hne)
        (lt_of_le_of_ne (hits.min'_le b (hsub hb)) (Ne.symm hmin))
        (lt_of_le_of_ne (hits.le_max' b (hsub hb)) hmax))
    exact (Finset.card_le_card hends).trans Finset.card_le_two

open scoped Classical in
theorem product_crop_partial_bound {β Ω κ : Type*} [LinearOrder β]
    {D : κ → Type*} [∀ t, LinearOrder (D t)]
    (S : β → Set Ω) (coord : (t : κ) → Ω → D t) (C : (t : κ) → Set (D t))
    (hconv : ∀ t (a b c : D t), a ∈ C t → c ∈ C t → a ≤ b → b ≤ c → b ∈ C t)
    (hsucc : ∀ i j, i < j → ∀ a ∈ S i, ∀ b ∈ S j,
      ∀ t, coord t a < coord t b)
    (indices : Finset β) :
    (indices.filter (fun i =>
      (∃ a ∈ S i, ∀ t, coord t a ∈ C t) ∧
      ¬ (∀ b ∈ S i, ∀ t, coord t b ∈ C t))).card ≤ 2 := by
  classical
  let hits := indices.filter (fun i => ∃ a ∈ S i, ∀ t, coord t a ∈ C t)
  apply at_most_two_partial hits
  · intro i hi
    exact Finset.mem_filter.mpr
      ⟨(Finset.mem_filter.mp hi).1, (Finset.mem_filter.mp hi).2.1⟩
  · intro a ha b hb c hc hab hbc
    exact (Finset.mem_filter.mp hb).2.2
      (product_crop_between S coord C hconv hsucc hab hbc
        (Finset.mem_filter.mp ha).2 (Finset.mem_filter.mp hc).2)

def smallBudget (c σ K : ℝ) : ℕ → ℝ
  | 0 => K
  | d + 1 => σ + c * smallBudget c σ K d

theorem smallBudget_le (c σ K : ℝ) (hc₀ : 0 ≤ c) (hc₁ : c < 1)
    (hσ : 0 ≤ σ) (d : ℕ) :
    smallBudget c σ K d ≤ σ / (1 - c) + c ^ d * K := by
  have hden : 0 < 1 - c := by linarith
  induction d with
  | zero =>
      simp only [smallBudget, pow_zero, one_mul]
      linarith [div_nonneg hσ hden.le]
  | succ d ih =>
      calc
        smallBudget c σ K (d + 1) ≤
            σ + c * (σ / (1 - c) + c ^ d * K) := by
          change σ + c * smallBudget c σ K d ≤ _
          exact add_le_add le_rfl (mul_le_mul_of_nonneg_left ih hc₀)
        _ = σ / (1 - c) + c ^ (d + 1) * K := by
          rw [pow_succ]
          field_simp
          ring

def chargeNodes (b : ℕ) : ℕ → ℕ
  | 0 => 0
  | d + 1 => 1 + b * chargeNodes b d

theorem chargeNodes_le (b d : ℕ) : chargeNodes b d ≤ (1 + b) ^ d := by
  induction d with
  | zero => simp [chargeNodes]
  | succ d ih =>
      have hpos : 0 < (1 + b) ^ d := pow_pos (by omega) _
      have hmul := Nat.mul_le_mul_left b ih
      simp only [chargeNodes, pow_succ]
      nlinarith

theorem uniform_budget_closed (c e : ℝ) (hc : c ≤ 1 / 8) (he : e ≤ c) :
    12 + 2 * e + 32 * c + c * (130 / 7) ≤ (130 / 7 : ℝ) := by
  linarith

theorem manuscript_small_budget (c θ : ℝ) (d : ℕ)
    (hc₀ : 0 ≤ c) (hc₁ : c ≤ 1 / 8) (hθ : 0 ≤ θ) (hd : c ^ d ≤ θ) :
    smallBudget c (194 * θ) (130 / 7) d ≤ (1682 / 7 : ℝ) * θ := by
  have hc : c < 1 := by linarith
  have hden : 0 < 1 - c := by linarith
  have hdiv : 194 * θ / (1 - c) ≤ (1552 / 7 : ℝ) * θ := by
    apply (div_le_iff₀ hden).mpr
    have hmul := mul_le_mul_of_nonneg_right hc₁ hθ
    nlinarith
  have hres := mul_le_mul_of_nonneg_right hd (by norm_num : (0 : ℝ) ≤ 130 / 7)
  have hsmall := smallBudget_le c (194 * θ) (130 / 7) hc₀ hc (by positivity) d
  nlinarith

theorem final_constant (θ small other : ℝ)
    (hs : small ≤ (1682 / 7 : ℝ) * θ) (ho : other ≤ 16 * θ) :
    small + other ≤ (1794 / 7 : ℝ) * θ := by
  linarith

end ExactPair
