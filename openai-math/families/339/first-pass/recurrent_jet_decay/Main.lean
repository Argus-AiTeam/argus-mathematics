import Mathlib

namespace RecurrentJetDecay

theorem choose_taylor_order (A beta delta : ℝ) (hdelta : 0 < delta) :
    ∃ p : ℕ, 0 < p ∧ A - delta * (p : ℝ) ≤ -beta := by
  obtain ⟨p, hp⟩ := exists_nat_gt (max 0 ((A + beta) / delta))
  have hp0 : (0 : ℝ) < p := lt_of_le_of_lt (le_max_left _ _) hp
  have hp1 : (A + beta) / delta < p :=
    lt_of_le_of_lt (le_max_right _ _) hp
  have hid : delta * ((A + beta) / delta) = A + beta := by
    field_simp
  refine ⟨p, by exact_mod_cast hp0, ?_⟩
  have := mul_lt_mul_of_pos_left hp1 hdelta
  nlinarith

theorem choose_interpolation_order (j : ℕ) (S T : ℝ) (hT : 0 < T) :
    ∃ q : ℕ, j < q ∧ (j : ℝ) * S ≤ T * (q : ℝ) := by
  obtain ⟨q, hq⟩ := exists_nat_gt (max (j : ℝ) ((j : ℝ) * S / T))
  have hjq : (j : ℝ) < q := lt_of_le_of_lt (le_max_left _ _) hq
  have hdiv : (j : ℝ) * S / T < q :=
    lt_of_le_of_lt (le_max_right _ _) hq
  have hid : T * ((j : ℝ) * S / T) = (j : ℝ) * S := by
    field_simp
  refine ⟨q, by exact_mod_cast hjq, ?_⟩
  have := mul_lt_mul_of_pos_left hdiv hT
  nlinarith

theorem choose_sampling_scale (B D eta : ℝ)
    (hB : 0 < B) (hD : 0 ≤ D) (heta : 0 < eta) :
    ∃ epsilon : ℝ, 0 < epsilon ∧ epsilon ≤ 1 ∧
      D * epsilon ≤ eta * B / 4 := by
  let epsilon := min 1 (eta * B / (4 * (D + 1)))
  have hden : 0 < 4 * (D + 1) := by positivity
  have heps : 0 < epsilon := by
    dsimp [epsilon]
    exact lt_min (by norm_num) (by positivity)
  have hupper : epsilon ≤ eta * B / (4 * (D + 1)) :=
    min_le_right _ _
  have hprod := mul_le_mul_of_nonneg_left hupper (le_of_lt hden)
  have hid : (4 * (D + 1)) * (eta * B / (4 * (D + 1))) = eta * B := by
    field_simp
  refine ⟨epsilon, heps, min_le_left _ _, ?_⟩
  nlinarith

theorem interpolation_budget (A B eta : ℝ) (j q : ℕ)
    (hq : 0 < q)
    (hbudget : (j : ℝ) * (A + (1 - eta / 2) * B) ≤
      (eta * B / 2) * (q : ℝ)) :
    (1 - eta) * B ≤
      ((1 - eta / 2) * B) * (1 - (j : ℝ) / (q : ℝ)) -
        A * ((j : ℝ) / (q : ℝ)) := by
  have hqr : (0 : ℝ) < q := by exact_mod_cast hq
  have hid :
      ((1 - eta / 2) * B) * (1 - (j : ℝ) / (q : ℝ)) -
        A * ((j : ℝ) / (q : ℝ)) =
      (((1 - eta / 2) * B) * (q : ℝ) -
        (j : ℝ) * (A + (1 - eta / 2) * B)) / (q : ℝ) := by
    field_simp
    ring
  rw [hid]
  apply (le_div_iff₀ hqr).2
  nlinarith

theorem sampling_to_values (A alpha beta delta : ℝ) (hdelta : 0 < delta)
    (hbeta : beta ≤ alpha) (a : ℕ → ℝ)
    (hsample : ∀ p : ℕ, 0 < p → ∃ C : ℝ, 0 < C ∧
      ∀ n : ℕ, a n ≤ C * (Real.exp (-alpha * (n : ℝ)) +
        Real.exp ((A - delta * (p : ℝ)) * (n : ℝ)))) :
    ∃ C : ℝ, 0 < C ∧
      ∀ n : ℕ, a n ≤ C * Real.exp (-beta * (n : ℝ)) := by
  obtain ⟨p, hp, horder⟩ := choose_taylor_order A beta delta hdelta
  obtain ⟨C, hC, hbound⟩ := hsample p hp
  refine ⟨2 * C, by positivity, ?_⟩
  intro n
  have hn : (0 : ℝ) ≤ n := by positivity
  have hfirst : Real.exp (-alpha * (n : ℝ)) ≤
      Real.exp (-beta * (n : ℝ)) := by
    apply Real.exp_le_exp.mpr
    nlinarith
  have hsecond : Real.exp ((A - delta * (p : ℝ)) * (n : ℝ)) ≤
      Real.exp (-beta * (n : ℝ)) := by
    apply Real.exp_le_exp.mpr
    nlinarith
  calc
    a n ≤ C * (Real.exp (-alpha * (n : ℝ)) +
      Real.exp ((A - delta * (p : ℝ)) * (n : ℝ))) := hbound n
    _ ≤ C * (Real.exp (-beta * (n : ℝ)) +
      Real.exp (-beta * (n : ℝ))) :=
        mul_le_mul_of_nonneg_left (add_le_add hfirst hsecond) (le_of_lt hC)
    _ = (2 * C) * Real.exp (-beta * (n : ℝ)) := by ring

theorem interpolation_to_derivatives (A B eta : ℝ)
    (hB : 0 < B) (heta : 0 < eta) (a : ℕ → ℕ → ℝ)
    (hinterp : ∀ j q : ℕ, j < q → ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
      a j n ≤ C * (Real.exp
        (-(((1 - eta / 2) * B) * (1 - (j : ℝ) / (q : ℝ)) -
          A * ((j : ℝ) / (q : ℝ))) * (n : ℝ)) +
        Real.exp (-((1 - eta / 2) * B) * (n : ℝ)))) :
    ∀ j : ℕ, ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
      a j n ≤ C * Real.exp (-((1 - eta) * B) * (n : ℝ)) := by
  intro j
  obtain ⟨q, hjq, hbudget⟩ :=
    choose_interpolation_order j (A + (1 - eta / 2) * B)
      (eta * B / 2) (by positivity)
  have hq : 0 < q := lt_of_le_of_lt (Nat.zero_le j) hjq
  have hrate := interpolation_budget A B eta j q hq hbudget
  obtain ⟨C, hC, hbound⟩ := hinterp j q hjq
  refine ⟨2 * C, by positivity, ?_⟩
  intro n
  have hn : (0 : ℝ) ≤ n := by positivity
  have hfirst :
      Real.exp (-(((1 - eta / 2) * B) *
        (1 - (j : ℝ) / (q : ℝ)) - A * ((j : ℝ) / (q : ℝ))) * (n : ℝ)) ≤
      Real.exp (-((1 - eta) * B) * (n : ℝ)) := by
    apply Real.exp_le_exp.mpr
    nlinarith
  have hsecond :
      Real.exp (-((1 - eta / 2) * B) * (n : ℝ)) ≤
      Real.exp (-((1 - eta) * B) * (n : ℝ)) := by
    apply Real.exp_le_exp.mpr
    have hgap : (1 - eta) * B ≤ (1 - eta / 2) * B := by nlinarith
    nlinarith
  calc
    a j n ≤ _ := hbound n
    _ ≤ C * (Real.exp (-((1 - eta) * B) * (n : ℝ)) +
      Real.exp (-((1 - eta) * B) * (n : ℝ))) :=
        mul_le_mul_of_nonneg_left (add_le_add hfirst hsecond) (le_of_lt hC)
    _ = (2 * C) * Real.exp (-((1 - eta) * B) * (n : ℝ)) := by ring

theorem uniform_jet_decay (bs bu A D eta : ℝ) (k : ℕ)
    (hbs : 0 < bs) (hbu : 0 < bu) (hD : 0 ≤ D) (hk : 0 < k)
    (heta : 0 < eta) (_heta1 : eta < 1) (a : ℕ → ℕ → ℝ)
    (hsample : ∀ epsilon : ℝ, 0 < epsilon → epsilon ≤ 1 →
      ∀ p : ℕ, 0 < p → ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
        a 0 n ≤ C * (Real.exp (-(bu * (k : ℝ) - D * epsilon) * (n : ℝ)) +
          Real.exp ((A - (bs * epsilon / 8) * (p : ℝ)) * (n : ℝ))))
    (hinterp : ∀ beta : ℝ,
      (∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
        a 0 n ≤ C * Real.exp (-beta * (n : ℝ))) →
      ∀ j q : ℕ, j < q → ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
        a j n ≤ C * (Real.exp
          (-(beta * (1 - (j : ℝ) / (q : ℝ)) -
            A * ((j : ℝ) / (q : ℝ))) * (n : ℝ)) +
          Real.exp (-beta * (n : ℝ)))) :
    ∀ j : ℕ, ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
      a j n ≤ C * Real.exp (-((1 - eta) * bu * (k : ℝ)) * (n : ℝ)) := by
  have hkr : (0 : ℝ) < k := by exact_mod_cast hk
  have hB : 0 < bu * (k : ℝ) := mul_pos hbu hkr
  obtain ⟨epsilon, heps, heps1, htransport⟩ :=
    choose_sampling_scale (bu * (k : ℝ)) D eta hB hD heta
  have hdelta : 0 < bs * epsilon / 8 := by positivity
  have hrate : (1 - eta / 2) * (bu * (k : ℝ)) ≤
      bu * (k : ℝ) - D * epsilon := by nlinarith
  have hvalues := sampling_to_values A
    (bu * (k : ℝ) - D * epsilon)
    ((1 - eta / 2) * (bu * (k : ℝ))) (bs * epsilon / 8)
    hdelta hrate (a 0) (hsample epsilon heps heps1)
  have hresult := interpolation_to_derivatives A (bu * (k : ℝ)) eta hB heta a
    (hinterp ((1 - eta / 2) * (bu * (k : ℝ))) hvalues)
  simpa only [mul_assoc] using hresult

theorem degree_weight_product (c t : ℝ) (degrees : List ℕ) :
    (degrees.map (fun d : ℕ => Real.exp (-(c * (d : ℝ) * t)))).prod =
      Real.exp (-(c * ((degrees.sum : ℕ) : ℝ) * t)) := by
  induction degrees with
  | nil => simp
  | cons d ds ih =>
      simp only [List.map_cons, List.prod_cons, List.sum_cons, Nat.cast_add, ih]
      rw [← Real.exp_add]
      congr 1
      ring

theorem choose_actualization_cutoff (c A B L : ℝ) (hc : 0 < c) :
    ∃ R : ℕ, L < (c * ((R : ℝ) + 1) - A - B) / 2 := by
  obtain ⟨R, hR⟩ := exists_nat_gt ((2 * L + A + B) / c)
  have hid : c * ((2 * L + A + B) / c) = 2 * L + A + B := by
    field_simp
  have := mul_lt_mul_of_pos_left hR hc
  refine ⟨R, ?_⟩
  nlinarith

#print axioms uniform_jet_decay
#print axioms degree_weight_product
#print axioms choose_actualization_cutoff

end RecurrentJetDecay
