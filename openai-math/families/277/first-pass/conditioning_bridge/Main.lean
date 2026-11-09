import Mathlib

open scoped BigOperators

noncomputable section

namespace ConditioningBridge

attribute [local instance] Classical.propDecidable

local instance (α : Sort*) : DecidableEq α := Classical.typeDecidableEq α

/-- A probability law on all binary states of a finite coordinate set. -/
structure BinaryLaw (ι : Type*) [Fintype ι] where
  mass : (ι → Bool) → ℝ
  nonneg : ∀ x, 0 ≤ mass x
  total : ∑ x, mass x = 1

variable {ι : Type*} [Fintype ι]

def wins (x : ι → Bool) : ℕ :=
  (Finset.univ.filter (fun i => x i = true)).card

def tested (C : Finset ι) (x : ι → Bool) : Prop :=
  ∀ i ∈ C, x i = true

def prob (μ : BinaryLaw ι) (P : (ι → Bool) → Prop) : ℝ :=
  ∑ x, if P x then μ.mass x else 0

def testProb (μ : BinaryLaw ι) (C : Finset ι) : ℝ :=
  prob μ (tested C)

def tailProb (μ : BinaryLaw ι) (q : ℝ) : ℝ :=
  prob μ (fun x => q * (Fintype.card ι : ℝ) ≤ (wins x : ℝ))

def badProb (μ : BinaryLaw ι) (C : Finset ι) (q₀ : ℝ) : ℝ :=
  prob μ (fun x => tested C x ∧ (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ))

def remainingMass (μ : BinaryLaw ι) (C : Finset ι) : ℝ :=
  ∑ x, if tested C x then μ.mass x * ((wins x : ℝ) - (C.card : ℝ)) else 0

theorem prob_nonneg (μ : BinaryLaw ι) (P : (ι → Bool) → Prop) :
    0 ≤ prob μ P := by
  apply Finset.sum_nonneg
  intro x _
  by_cases hx : P x <;> simp [hx, μ.nonneg x]

theorem prob_le_one (μ : BinaryLaw ι) (P : (ι → Bool) → Prop) :
    prob μ P ≤ 1 := by
  calc
    prob μ P ≤ ∑ x, μ.mass x := by
      apply Finset.sum_le_sum
      intro x _
      by_cases hx : P x <;> simp [hx, μ.nonneg x]
    _ = 1 := μ.total

theorem testProb_nonneg (μ : BinaryLaw ι) (C : Finset ι) :
    0 ≤ testProb μ C :=
  prob_nonneg μ (tested C)

theorem badProb_nonneg (μ : BinaryLaw ι) (C : Finset ι) (q₀ : ℝ) :
    0 ≤ badProb μ C q₀ :=
  prob_nonneg μ _

theorem tested_card_le_wins {C : Finset ι} {x : ι → Bool} (hx : tested C x) :
    C.card ≤ wins x := by
  apply Finset.card_le_card
  intro i hi
  exact Finset.mem_filter.mpr ⟨Finset.mem_univ i, hx i hi⟩

/-- Selection from a finite weighted family; no independence assumptions are needed. -/
theorem finite_weighted_selection {D : Type*} [Fintype D] [Nonempty D]
    (a b : D → ℝ) (A ε : ℝ)
    (hA : 0 < A) (hε : 0 < ε) (hb : ∀ d, 0 ≤ b d)
    (ha_sum : (Fintype.card D : ℝ) * A ≤ ∑ d, a d)
    (hb_sum : (∑ d, b d) ≤ (Fintype.card D : ℝ) * ε * A / 4) :
    ∃ d, A / 2 ≤ a d ∧ b d ≤ ε * a d := by
  by_contra h
  have hpoint (d : D) : ε * a d ≤ ε * (A / 2) + b d := by
    by_cases hlarge : A / 2 ≤ a d
    · have hbad : ε * a d < b d :=
        lt_of_not_ge (fun hsmall => h ⟨d, hlarge, hsmall⟩)
      have hnonneg : 0 ≤ ε * (A / 2) := by positivity
      linarith
    · have hsmall : a d ≤ A / 2 := le_of_lt (lt_of_not_ge hlarge)
      have hmul := mul_le_mul_of_nonneg_left hsmall hε.le
      linarith [hb d]
  have hsum : ε * (∑ d, a d) ≤
      (Fintype.card D : ℝ) * (ε * (A / 2)) + ∑ d, b d := by
    calc
      ε * (∑ d, a d) = ∑ d, ε * a d := Finset.mul_sum _ _ _
      _ ≤ ∑ d, (ε * (A / 2) + b d) :=
        Finset.sum_le_sum (fun d _ => hpoint d)
      _ = _ := by simp [Finset.sum_add_distrib]
  have hlower := mul_le_mul_of_nonneg_left ha_sum hε.le
  have hpositive : 0 < (Fintype.card D : ℝ) * ε * A := by
    have hcard : 0 < (Fintype.card D : ℝ) := by exact_mod_cast Fintype.card_pos
    positivity
  nlinarith

def drawSet {ℓ : ℕ} (d : Fin ℓ → ι) : Finset ι :=
  Finset.univ.image d

omit [Fintype ι] in
theorem drawSet_card_le {ℓ : ℕ} (d : Fin ℓ → ι) :
    (drawSet d).card ≤ ℓ := by
  simpa [drawSet] using (Finset.card_image_le (s := Finset.univ) (f := d))

omit [Fintype ι] in
@[simp] theorem tested_drawSet {ℓ : ℕ} (d : Fin ℓ → ι) (x : ι → Bool) :
    tested (drawSet d) x ↔ ∀ j, x (d j) = true := by
  simp [tested, drawSet]

/-- The exact with-replacement draw count, including repeated coordinates and `ℓ = 0`. -/
theorem sum_draw_tested_indicator (ℓ : ℕ) (x : ι → Bool) :
    (∑ d : Fin ℓ → ι, if tested (drawSet d) x then (1 : ℝ) else 0) =
      (wins x : ℝ) ^ ℓ := by
  have hwin : (∑ i, if x i = true then (1 : ℝ) else 0) = (wins x : ℝ) := by
    simpa only [wins] using
      (Finset.sum_boole (R := ℝ) (fun i => x i = true) Finset.univ)
  calc
    _ = ∑ d : Fin ℓ → ι, ∏ j : Fin ℓ, if x (d j) = true then (1 : ℝ) else 0 := by
      apply Finset.sum_congr rfl
      intro d _
      by_cases hd : ∀ j, x (d j) = true <;> simp [Fintype.prod_boole, hd]
    _ = (∑ i, if x i = true then (1 : ℝ) else 0) ^ ℓ :=
      (Fintype.sum_pow (fun i => if x i = true then (1 : ℝ) else 0) ℓ).symm
    _ = _ := by rw [hwin]

theorem sum_draw_tested_weight (ℓ : ℕ) (x : ι → Bool) (w : ℝ) :
    (∑ d : Fin ℓ → ι, if tested (drawSet d) x then w else 0) =
      w * (wins x : ℝ) ^ ℓ := by
  calc
    _ = (∑ d : Fin ℓ → ι, if tested (drawSet d) x then (1 : ℝ) else 0) * w := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro d _
      by_cases hd : tested (drawSet d) x <;> simp [hd]
    _ = _ := by rw [sum_draw_tested_indicator]; ring

theorem sum_draw_restricted_prob (μ : BinaryLaw ι) (ℓ : ℕ)
    (P : (ι → Bool) → Prop) :
    (∑ d : Fin ℓ → ι, prob μ (fun x => tested (drawSet d) x ∧ P x)) =
      ∑ x, (if P x then μ.mass x else 0) * (wins x : ℝ) ^ ℓ := by
  unfold prob
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro x _
  by_cases hx : P x
  · simpa only [hx, and_true, if_true] using sum_draw_tested_weight ℓ x (μ.mass x)
  · simp [hx]

theorem sum_draw_testProb (μ : BinaryLaw ι) (ℓ : ℕ) :
    (∑ d : Fin ℓ → ι, testProb μ (drawSet d)) =
      ∑ x, μ.mass x * (wins x : ℝ) ^ ℓ := by
  simpa only [testProb, and_true, if_true] using
    sum_draw_restricted_prob μ ℓ (fun _ => True)

theorem sum_draw_badProb (μ : BinaryLaw ι) (ℓ : ℕ) (q₀ : ℝ) :
    (∑ d : Fin ℓ → ι, badProb μ (drawSet d) q₀) =
      ∑ x, (if (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ) then μ.mass x else 0) *
        (wins x : ℝ) ^ ℓ := by
  exact sum_draw_restricted_prob μ ℓ _

theorem sum_draw_testProb_lower (μ : BinaryLaw ι) (ℓ : ℕ) (q : ℝ) (hq : 0 ≤ q) :
    tailProb μ q * (q * (Fintype.card ι : ℝ)) ^ ℓ ≤
      ∑ d : Fin ℓ → ι, testProb μ (drawSet d) := by
  rw [sum_draw_testProb, tailProb, prob, Finset.sum_mul]
  apply Finset.sum_le_sum
  intro x _
  by_cases hx : q * (Fintype.card ι : ℝ) ≤ (wins x : ℝ)
  · simp only [if_pos hx]
    exact mul_le_mul_of_nonneg_left
      (pow_le_pow_left₀ (mul_nonneg hq (Nat.cast_nonneg _)) hx ℓ) (μ.nonneg x)
  · simp only [if_neg hx, zero_mul]
    exact mul_nonneg (μ.nonneg x) (pow_nonneg (Nat.cast_nonneg _) _)

theorem sum_draw_badProb_upper (μ : BinaryLaw ι) (ℓ : ℕ) (q₀ : ℝ) (hq₀ : 0 ≤ q₀) :
    (∑ d : Fin ℓ → ι, badProb μ (drawSet d) q₀) ≤
      (q₀ * (Fintype.card ι : ℝ)) ^ ℓ := by
  rw [sum_draw_badProb]
  calc
    _ ≤ ∑ x, μ.mass x * (q₀ * (Fintype.card ι : ℝ)) ^ ℓ := by
      apply Finset.sum_le_sum
      intro x _
      by_cases hx : (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ)
      · simp only [if_pos hx]
        exact mul_le_mul_of_nonneg_left
          (pow_le_pow_left₀ (Nat.cast_nonneg _) hx.le ℓ) (μ.nonneg x)
      · simp only [if_neg hx, zero_mul]
        exact mul_nonneg (μ.nonneg x)
          (pow_nonneg (mul_nonneg hq₀ (Nat.cast_nonneg _)) _)
    _ = _ := by rw [← Finset.sum_mul, μ.total, one_mul]

/-- A small set of tested coordinates retains upper-tail mass and suppresses bad states. -/
theorem upper_tail_selection [Nonempty ι] (μ : BinaryLaw ι)
    (q₀ q ε : ℝ) (ℓ : ℕ)
    (hq₀ : 0 < q₀) (hq₀q : q₀ < q) (_hq1 : q < 1) (hε : 0 < ε)
    (hp : 0 < tailProb μ q)
    (hsmall : q₀ ^ ℓ ≤ ε * tailProb μ q * q ^ ℓ / 4) :
    ∃ C : Finset ι, C.card ≤ ℓ ∧
      tailProb μ q * q ^ ℓ / 2 ≤ testProb μ C ∧
      badProb μ C q₀ ≤ ε * testProb μ C := by
  have hq : 0 < q := lt_trans hq₀ hq₀q
  let A : ℝ := tailProb μ q * q ^ ℓ
  have hA : 0 < A := mul_pos hp (pow_pos hq ℓ)
  have hcard : (Fintype.card (Fin ℓ → ι) : ℝ) = (Fintype.card ι : ℝ) ^ ℓ := by
    simp
  have ha_sum : (Fintype.card (Fin ℓ → ι) : ℝ) * A ≤
      ∑ d : Fin ℓ → ι, testProb μ (drawSet d) := by
    calc
      _ = tailProb μ q * (q * (Fintype.card ι : ℝ)) ^ ℓ := by
        rw [hcard, mul_pow]
        dsimp [A]
        ring
      _ ≤ _ := sum_draw_testProb_lower μ ℓ q hq.le
  have hb_sum : (∑ d : Fin ℓ → ι, badProb μ (drawSet d) q₀) ≤
      (Fintype.card (Fin ℓ → ι) : ℝ) * ε * A / 4 := by
    calc
      _ ≤ (q₀ * (Fintype.card ι : ℝ)) ^ ℓ :=
        sum_draw_badProb_upper μ ℓ q₀ hq₀.le
      _ = (Fintype.card ι : ℝ) ^ ℓ * q₀ ^ ℓ := by rw [mul_pow]; ring
      _ ≤ (Fintype.card ι : ℝ) ^ ℓ * (ε * tailProb μ q * q ^ ℓ / 4) :=
        mul_le_mul_of_nonneg_left hsmall (pow_nonneg (Nat.cast_nonneg _) _)
      _ = _ := by rw [hcard]; dsimp [A]; ring
  obtain ⟨d, hda, hdb⟩ := finite_weighted_selection
    (fun d : Fin ℓ → ι => testProb μ (drawSet d))
    (fun d : Fin ℓ → ι => badProb μ (drawSet d) q₀)
    A ε hA hε (fun d => badProb_nonneg μ (drawSet d) q₀) ha_sum hb_sum
  exact ⟨drawSet d, drawSet_card_le d, hda, hdb⟩

theorem remainingMass_nonneg (μ : BinaryLaw ι) (C : Finset ι) :
    0 ≤ remainingMass μ C := by
  apply Finset.sum_nonneg
  intro x _
  by_cases hx : tested C x
  · simp only [if_pos hx]
    apply mul_nonneg (μ.nonneg x)
    apply sub_nonneg.mpr
    exact_mod_cast tested_card_le_wins hx
  · simp [hx]

/-- Good tested states supply the threshold surplus; bad tested states are nonnegative. -/
theorem remainingMass_ge_goodMass (μ : BinaryLaw ι) (C : Finset ι) (q₀ : ℝ) :
    (testProb μ C - badProb μ C q₀) *
        (q₀ * (Fintype.card ι : ℝ) - (C.card : ℝ)) ≤
      remainingMass μ C := by
  calc
    _ = ∑ x, ((if tested C x then μ.mass x else 0) -
        (if tested C x ∧ (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ)
          then μ.mass x else 0)) *
        (q₀ * (Fintype.card ι : ℝ) - (C.card : ℝ)) := by
      unfold testProb badProb prob
      rw [← Finset.sum_sub_distrib, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro x _
      by_cases hx : tested C x <;>
        by_cases hb : (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ) <;> simp [hx, hb]
    _ ≤ remainingMass μ C := by
      apply Finset.sum_le_sum
      intro x _
      by_cases hx : tested C x
      · by_cases hb : (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ)
        · have hyes : tested C x ∧
              (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ) := ⟨hx, hb⟩
          simp only [if_pos hx, if_pos hyes, sub_self, zero_mul]
          apply mul_nonneg (μ.nonneg x)
          apply sub_nonneg.mpr
          exact_mod_cast tested_card_le_wins hx
        · have hnot : ¬ (tested C x ∧
              (wins x : ℝ) < q₀ * (Fintype.card ι : ℝ)) := fun h => hb h.2
          simp only [if_pos hx, if_neg hnot, sub_zero]
          exact mul_le_mul_of_nonneg_left
            (sub_le_sub_right (le_of_not_gt hb) _) (μ.nonneg x)
      · simp [hx]

theorem remainingMass_lower_bound (μ : BinaryLaw ι) (C : Finset ι) (q₀ η : ℝ)
    (hbad : badProb μ C q₀ ≤ η * testProb μ C)
    (hgap : (C.card : ℝ) ≤ q₀ * (Fintype.card ι : ℝ)) :
    (1 - η) * testProb μ C *
        (q₀ * (Fintype.card ι : ℝ) - (C.card : ℝ)) ≤
      remainingMass μ C := by
  have hgood : (1 - η) * testProb μ C ≤ testProb μ C - badProb μ C q₀ := by
    nlinarith
  exact le_trans
    (mul_le_mul_of_nonneg_right hgood (sub_nonneg.mpr hgap))
    (remainingMass_ge_goodMass μ C q₀)

theorem remainingMass_lower_of_card_le (μ : BinaryLaw ι) (C : Finset ι) (q₀ η : ℝ)
    (hηq₀ : η ≤ q₀) (hcard : (C.card : ℝ) ≤ η * (Fintype.card ι : ℝ))
    (hbad : badProb μ C q₀ ≤ η * testProb μ C) :
    (1 - η) * testProb μ C *
        (q₀ * (Fintype.card ι : ℝ) - (C.card : ℝ)) ≤
      remainingMass μ C :=
  remainingMass_lower_bound μ C q₀ η hbad
    (le_trans hcard (mul_le_mul_of_nonneg_right hηq₀ (Nat.cast_nonneg _)))

end ConditioningBridge

namespace ConditioningBridge

theorem rate_arithmetic (q q₀ δ T L : ℝ)
    (hq₀ : 0 < q₀) (hqq : q₀ < q) (hq1 : q ≤ 1)
    (_hδ : 0 < δ) (hδq : δ ≤ q) (hgap : q - q₀ = δ / 2)
    (hT : 0 ≤ T) (hL : 0 ≤ L) :
    let r := Real.log (q / q₀)
    let R := L - Real.log q
    let c := δ * T / (16 * (1 + L))
    c / r ≤ T / 8 ∧ c * (1 + R / r) ≤ 3 * T / 16 := by
  dsimp only
  let r := Real.log (q / q₀)
  let R := L - Real.log q
  let a := T / (16 * (1 + L))
  have hq : 0 < q := hq₀.trans hqq
  have hr : 0 < r := Real.log_pos ((one_lt_div hq₀).2 hqq)
  have hR : 0 ≤ R := sub_nonneg.mpr ((Real.log_nonpos hq.le hq1).trans hL)
  have hlower := mul_le_mul_of_nonneg_right
    (Real.one_sub_inv_le_log_of_pos (div_pos hq hq₀)) hq.le
  simp only [inv_div, sub_mul, one_mul, div_mul_cancel₀ _ hq.ne'] at hlower
  have hdr : δ / r ≤ 2 * q := (div_le_iff₀ hr).2 (by dsimp [r]; nlinarith)
  have hlogq := mul_le_mul_of_nonneg_right
    (Real.one_sub_inv_le_log_of_pos hq) hq.le
  simp only [sub_mul, one_mul, inv_mul_cancel₀ hq.ne'] at hlogq
  have hqL := mul_le_mul_of_nonneg_right hq1 hL
  have hqR : q * R ≤ L + 1 - q := by dsimp [R]; nlinarith
  have hdelta : δ * (1 + R / r) ≤ 3 * (1 + L) := by
    have h := mul_le_mul_of_nonneg_right hdr hR
    have hid : δ * (1 + R / r) = δ + (δ / r) * R := by ring
    rw [hid]
    nlinarith
  have ha : 0 ≤ a := by dsimp [a]; positivity
  have hau : a ≤ T / 16 := by
    apply (div_le_iff₀ (by positivity : 0 < 16 * (1 + L))).2
    nlinarith [mul_nonneg hT hL]
  constructor
  · calc
      δ * T / (16 * (1 + L)) / r = a * (δ / r) := by dsimp [a]; ring
      _ ≤ a * (2 * q) := mul_le_mul_of_nonneg_left hdr ha
      _ ≤ (T / 16) * 2 :=
        mul_le_mul hau (by linarith) (by positivity) (by positivity)
      _ = T / 8 := by ring
  · calc
      δ * T / (16 * (1 + L)) * (1 + (L - Real.log q) / Real.log (q / q₀)) =
          a * (δ * (1 + R / r)) := by dsimp [a, R, r]; ring
      _ ≤ a * (3 * (1 + L)) := mul_le_mul_of_nonneg_left hdelta ha
      _ = 3 * T / 16 := by dsimp [a]; field_simp

theorem sampling_length (q₀ q ε p : ℝ)
    (hq₀ : 0 < q₀) (hqq : q₀ < q) (hε : 0 < ε) (hε1 : ε ≤ 1)
    (hp : 0 < p) (hp1 : p ≤ 1) :
    let r := Real.log (q / q₀)
    let ℓ := Nat.ceil (Real.log (4 / (ε * p)) / r)
    (ℓ : ℝ) ≤ (Real.log (1 / p) + Real.log (4 / ε)) / r + 1 ∧
      q₀ ^ ℓ ≤ ε * p * q ^ ℓ / 4 := by
  dsimp only
  let r := Real.log (q / q₀)
  let ℓ := Nat.ceil (Real.log (4 / (ε * p)) / r)
  have hq : 0 < q := hq₀.trans hqq
  have hr : 0 < r := Real.log_pos ((one_lt_div hq₀).2 hqq)
  have hep : 0 < ε * p := mul_pos hε hp
  have hep1 : ε * p ≤ 1 :=
    (mul_le_mul_of_nonneg_left hp1 hε.le).trans (by simpa using hε1)
  have harg : 1 ≤ 4 / (ε * p) := (le_div_iff₀ hep).2 (by nlinarith)
  have hnum : 0 ≤ Real.log (4 / (ε * p)) := Real.log_nonneg harg
  have hsplit : Real.log (4 / (ε * p)) =
      Real.log (1 / p) + Real.log (4 / ε) := by
    rw [Real.log_div (by norm_num) hep.ne', Real.log_mul hε.ne' hp.ne',
      Real.log_div one_ne_zero hp.ne', Real.log_div (by norm_num) hε.ne',
      Real.log_one]
    ring
  have hlow : Real.log (4 / (ε * p)) ≤ (ℓ : ℝ) * r :=
    (div_le_iff₀ hr).1 (Nat.le_ceil _)
  constructor
  · have h := (Nat.ceil_lt_add_one (div_nonneg hnum hr.le)).le
    simpa only [hsplit] using h
  · apply (Real.log_le_log_iff (pow_pos hq₀ ℓ)
      (div_pos (mul_pos hep (pow_pos hq ℓ)) (by norm_num))).mp
    rw [Real.log_pow, Real.log_div (mul_pos hep (pow_pos hq ℓ)).ne' (by norm_num),
      Real.log_mul hep.ne' (pow_pos hq ℓ).ne', Real.log_mul hε.ne' hp.ne',
      Real.log_pow]
    dsimp [r] at hlow
    rw [Real.log_div hq.ne' hq₀.ne',
      Real.log_div (by norm_num) hep.ne', Real.log_mul hε.ne' hp.ne'] at hlow
    nlinarith

end ConditioningBridge

namespace ConditioningBridge

attribute [local instance] Classical.propDecidable

local instance tensorDecidableEq (α : Sort*) : DecidableEq α :=
  Classical.typeDecidableEq α

variable {ι : Type*} [Fintype ι]

/-- The explicit law of `N` independent copies, with disjoint coordinate blocks. -/
def tensorLaw (μ : BinaryLaw ι) (N : ℕ) : BinaryLaw (Fin N × ι) := by
  classical
  letI : DecidableEq (Fin N × ι) := Classical.typeDecidableEq _
  refine
    { mass := fun x => ∏ j : Fin N, μ.mass (fun i => x (j, i))
      nonneg := ?_
      total := ?_ }
  · intro x
    exact Finset.prod_nonneg (fun j _ => μ.nonneg (fun i => x (j, i)))
  · calc
      _ = ∑ y : Fin N → ι → Bool, ∏ j : Fin N, μ.mass (y j) := by
        apply @Fintype.sum_equiv _ _ ℝ _ _ _ (Equiv.curry (Fin N) ι Bool)
        intro x
        rfl
      _ = ∏ _j : Fin N, ∑ y : ι → Bool, μ.mass y :=
        (Fintype.prod_sum (fun (_j : Fin N) (y : ι → Bool) => μ.mass y)).symm
      _ = 1 := by simp [μ.total]

@[simp] theorem tensorLaw_mass (μ : BinaryLaw ι) (N : ℕ)
    (x : Fin N × ι → Bool) :
    (tensorLaw μ N).mass x = ∏ j : Fin N, μ.mass (fun i => x (j, i)) :=
  rfl

theorem tensor_block_event (μ : BinaryLaw ι) (N : ℕ)
    (P : (ι → Bool) → Prop) :
    prob (tensorLaw μ N) (fun x => ∀ j, P (fun i => x (j, i))) =
      (prob μ P) ^ N := by
  classical
  letI : DecidableEq (Fin N × ι) := Classical.typeDecidableEq _
  calc
    _ = ∑ y : Fin N → ι → Bool,
        if ∀ j, P (y j) then ∏ j : Fin N, μ.mass (y j) else 0 := by
      unfold prob
      apply @Fintype.sum_equiv _ _ ℝ _ _ _ (Equiv.curry (Fin N) ι Bool)
      intro x
      split_ifs <;> first | rfl | contradiction
    _ = ∑ y : Fin N → ι → Bool,
        ∏ j : Fin N, if P (y j) then μ.mass (y j) else 0 := by
      apply Finset.sum_congr rfl
      intro y _
      simp only [Finset.prod_ite_zero, Finset.mem_univ, forall_const]
    _ = ∏ _j : Fin N, ∑ y : ι → Bool, if P y then μ.mass y else 0 :=
      (Fintype.prod_sum
        (fun (_j : Fin N) (y : ι → Bool) => if P y then μ.mass y else 0)).symm
    _ = (prob μ P) ^ N := by simp [prob]

theorem wins_eq_sum (x : ι → Bool) :
    wins x = ∑ i, if x i = true then (1 : ℕ) else 0 := by
  classical
  simpa only [wins, Nat.cast_id] using
    (Finset.sum_boole (R := ℕ) (fun i => x i = true) Finset.univ).symm

theorem wins_tensor (N : ℕ) (x : Fin N × ι → Bool) :
    wins x = ∑ j : Fin N, wins (fun i => x (j, i)) := by
  classical
  simpa only [wins_eq_sum] using
    Fintype.sum_prod_type (fun ji : Fin N × ι => if x ji = true then (1 : ℕ) else 0)

theorem prob_mono (μ : BinaryLaw ι) (P Q : (ι → Bool) → Prop)
    (hPQ : ∀ x, P x → Q x) :
    prob μ P ≤ prob μ Q := by
  classical
  apply Finset.sum_le_sum
  intro x _
  by_cases hP : P x
  · simp [hP, hPQ x hP]
  · by_cases hQ : Q x <;> simp [hP, hQ, μ.nonneg x]

theorem tensor_tail_event (N : ℕ) (q : ℝ) (x : Fin N × ι → Bool)
    (hx : ∀ j, q * (Fintype.card ι : ℝ) ≤ (wins (fun i => x (j, i)) : ℝ)) :
    q * (Fintype.card (Fin N × ι) : ℝ) ≤ (wins x : ℝ) := by
  calc
    q * (Fintype.card (Fin N × ι) : ℝ) =
        ∑ _j : Fin N, q * (Fintype.card ι : ℝ) := by
      simp only [Fintype.card_prod, Fintype.card_fin, Nat.cast_mul,
        Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
      ring
    _ ≤ ∑ j : Fin N, (wins (fun i => x (j, i)) : ℝ) :=
      Finset.sum_le_sum (fun j _ => hx j)
    _ = (wins x : ℝ) := by rw [wins_tensor, Nat.cast_sum]

/-- All blocks meeting the threshold forces their union to meet the same threshold. -/
theorem tensor_tailProb (μ : BinaryLaw ι) (N : ℕ) (q : ℝ) :
    (tailProb μ q) ^ N ≤ tailProb (tensorLaw μ N) q := by
  calc
    _ = prob (tensorLaw μ N)
        (fun x => ∀ j, q * (Fintype.card ι : ℝ) ≤
          (wins (fun i => x (j, i)) : ℝ)) :=
      (tensor_block_event μ N _).symm
    _ ≤ tailProb (tensorLaw μ N) q :=
      prob_mono _ _ _ (fun x hx => tensor_tail_event N q x hx)

def LawFamily :=
  ∀ (κ : Type) [Fintype κ], BinaryLaw κ → Prop

def TensorClosed (A : LawFamily) : Prop :=
  ∀ (κ : Type) [Fintype κ] (μ : BinaryLaw κ) (N : ℕ),
    A κ μ → A (Fin N × κ) (tensorLaw μ N)

/-- An eventual exponential bound propagates to all nonempty finite coordinate sets. -/
theorem all_lengths_of_large (A : LawFamily) (hA : TensorClosed A)
    (q c : ℝ) (K : ℕ)
    (hlarge : ∀ (κ : Type) [Fintype κ] [Nonempty κ] (ν : BinaryLaw κ),
      A κ ν → K ≤ Fintype.card κ →
        tailProb ν q ≤ Real.exp (-c * (Fintype.card κ : ℝ)))
    (κ : Type) [Fintype κ] [Nonempty κ] (μ : BinaryLaw κ) (hμ : A κ μ) :
    tailProb μ q ≤ Real.exp (-c * (Fintype.card κ : ℝ)) := by
  have hcard : K ≤ Fintype.card (Fin (K + 1) × κ) := by
    simp only [Fintype.card_prod, Fintype.card_fin]
    exact (Nat.le_succ K).trans (Nat.le_mul_of_pos_right (K + 1) Fintype.card_pos)
  have hpow :
      (tailProb μ q) ^ (K + 1) ≤
        (Real.exp (-c * (Fintype.card κ : ℝ))) ^ (K + 1) := by
    calc
      _ ≤ tailProb (tensorLaw μ (K + 1)) q := tensor_tailProb μ (K + 1) q
      _ ≤ Real.exp (-c * (Fintype.card (Fin (K + 1) × κ) : ℝ)) :=
        hlarge (Fin (K + 1) × κ) (tensorLaw μ (K + 1)) (hA κ μ (K + 1) hμ) hcard
      _ = _ := by
        rw [Fintype.card_prod, Fintype.card_fin, Nat.cast_mul, ← Real.exp_nat_mul]
        congr 1
        ring
  exact (pow_le_pow_iff_left₀ (prob_nonneg μ _) (Real.exp_pos _).le
    (Nat.succ_ne_zero K)).mp hpow

end ConditioningBridge

namespace ConditioningBridge

attribute [local instance] Classical.propDecidable

local instance transferDecidableEq (α : Sort*) : DecidableEq α :=
  Classical.typeDecidableEq α

def ConditioningInput (A : LawFamily) (v δ T L : ℝ) : Prop :=
  ∀ (κ : Type) [Fintype κ] [Nonempty κ] (μ : BinaryLaw κ), A κ μ →
    ∀ C : Finset κ, C.card < Fintype.card κ → 0 < testProb μ C →
      (Real.log (1 / testProb μ C) + (C.card : ℝ) * L) /
          ((Fintype.card κ : ℝ) - (C.card : ℝ)) ≤ T →
        remainingMass μ C ≤
          (v + δ / 4) * testProb μ C * ((Fintype.card κ : ℝ) - (C.card : ℝ))

set_option maxHeartbeats 2000000 in
theorem large_length_threshold (A : LawFamily) (v δ T L : ℝ)
    (hv : 0 ≤ v) (hδ : 0 < δ) (hδv : δ < 1 - v)
    (hT : 0 < T) (hTδ : T ≤ δ / 4) (hL : 0 ≤ L)
    (hcond : ConditioningInput A v δ T L) :
    ∃ K : ℕ, ∀ (κ : Type) [Fintype κ] [Nonempty κ] (μ : BinaryLaw κ),
      A κ μ → K ≤ Fintype.card κ →
        tailProb μ (v + δ) <
          Real.exp (-(δ * T / (16 * (1 + L))) * (Fintype.card κ : ℝ)) := by
  let q := v + δ
  let q₀ := v + δ / 2
  let η := δ / 16
  let r := Real.log (q / q₀)
  let R := L - Real.log q
  let c := δ * T / (16 * (1 + L))
  let t := 1 + Real.log (4 / η) / r
  let B := Real.log 2 + R * t
  have hq₀ : 0 < q₀ := by dsimp [q₀]; linarith
  have hqq : q₀ < q := by dsimp [q₀, q]; linarith
  have hq : 0 < q := hq₀.trans hqq
  have hq1 : q < 1 := by dsimp [q]; linarith
  have hη : 0 < η := by dsimp [η]; positivity
  have hη1 : η < 1 / 16 := by dsimp [η]; linarith
  have hηq₀ : η ≤ q₀ := by dsimp [η, q₀]; linarith
  have hr : 0 < r := Real.log_pos ((one_lt_div hq₀).2 hqq)
  have hR : 0 ≤ R := sub_nonneg.mpr ((Real.log_nonpos hq.le hq1.le).trans hL)
  have hc : 0 < c := by dsimp [c]; positivity
  have harith := rate_arithmetic q q₀ δ T L hq₀ hqq hq1.le hδ
    (by dsimp [q]; linarith) (by dsimp [q, q₀]; ring) hT.le hL
  change c / r ≤ T / 8 ∧ c * (1 + R / r) ≤ 3 * T / 16 at harith
  have hcr : c / r ≤ η / 2 := by dsimp [η]; linarith [harith.1]
  obtain ⟨K, hK⟩ := exists_nat_gt (max (2 * t / η) (16 * B / T))
  have hKt : 2 * t ≤ (K : ℝ) * η :=
    (div_le_iff₀ hη).1 ((le_max_left _ _).trans hK.le)
  have hKB : 16 * B ≤ (K : ℝ) * T :=
    (div_le_iff₀ hT).1 ((le_max_right _ _).trans hK.le)
  refine ⟨K, ?_⟩
  intro κ _ _ μ hμ hnK
  let n : ℝ := Fintype.card κ
  let p := tailProb μ q
  have hn : 0 < n := by dsimp [n]; exact_mod_cast Fintype.card_pos
  have hKn : (K : ℝ) ≤ n := by dsimp [n]; exact_mod_cast hnK
  have ht : t ≤ η * n / 2 := by nlinarith
  have hB : B ≤ T * n / 16 := by nlinarith
  change p < Real.exp (-c * n)
  by_contra hp
  have hexp : Real.exp (-c * n) ≤ p := le_of_not_gt hp
  have hp0 : 0 < p := (Real.exp_pos _).trans_le hexp
  have hp1 : p ≤ 1 := prob_le_one μ _
  have hlogp : Real.log (1 / p) ≤ c * n := by
    have h := Real.log_le_log (Real.exp_pos _) hexp
    rw [Real.log_exp] at h
    rw [one_div, Real.log_inv]
    linarith
  let ℓ := Nat.ceil (Real.log (4 / (η * p)) / r)
  have hlen := sampling_length q₀ q η p hq₀ hqq hη (by linarith) hp0 hp1
  change (ℓ : ℝ) ≤ (Real.log (1 / p) + Real.log (4 / η)) / r + 1 ∧
      q₀ ^ ℓ ≤ η * p * q ^ ℓ / 4 at hlen
  have hℓ : (ℓ : ℝ) ≤ c * n / r + t := by
    calc
      _ ≤ (Real.log (1 / p) + Real.log (4 / η)) / r + 1 := hlen.1
      _ = Real.log (1 / p) / r + t := by dsimp [t]; ring
      _ ≤ c * n / r + t := by
        linarith [div_le_div_of_nonneg_right hlogp hr.le]
  obtain ⟨C, hCℓ, hpC, hbad⟩ :=
    upper_tail_selection μ q₀ q η ℓ hq₀ hqq hq1 hη hp0 hlen.2
  have hCℓR : (C.card : ℝ) ≤ (ℓ : ℝ) := by exact_mod_cast hCℓ
  have hℓη : (ℓ : ℝ) ≤ η * n := by
    have h := mul_le_mul_of_nonneg_right hcr hn.le
    have hℓ' : (ℓ : ℝ) ≤ (c / r) * n + t := by convert hℓ using 1; ring
    nlinarith
  have hCη : (C.card : ℝ) ≤ η * n := hCℓR.trans hℓη
  have hproper : C.card < Fintype.card κ := by
    have hreal : (C.card : ℝ) < n := by nlinarith
    dsimp [n] at hreal
    exact_mod_cast hreal
  have hden : 0 < n - (C.card : ℝ) := by
    have hreal : (C.card : ℝ) < n := by dsimp [n]; exact_mod_cast hproper
    linarith
  have hpC0 : 0 < testProb μ C :=
    (div_pos (mul_pos hp0 (pow_pos hq ℓ)) (by norm_num)).trans_le hpC
  have hlogC : Real.log (1 / testProb μ C) ≤
      Real.log (1 / p) + Real.log 2 - (ℓ : ℝ) * Real.log q := by
    have h := Real.log_le_log
      (div_pos (mul_pos hp0 (pow_pos hq ℓ)) (by norm_num)) hpC
    rw [Real.log_div (mul_pos hp0 (pow_pos hq ℓ)).ne' (by norm_num),
      Real.log_mul hp0.ne' (pow_pos hq ℓ).ne', Real.log_pow] at h
    rw [one_div, Real.log_inv, one_div, Real.log_inv]
    linarith
  have hnum :
      Real.log (1 / testProb μ C) + (C.card : ℝ) * L ≤
        c * (1 + R / r) * n + B := by
    have hCL := mul_le_mul_of_nonneg_right hCℓR hL
    calc
      _ ≤ Real.log (1 / p) + Real.log 2 + (ℓ : ℝ) * R := by dsimp [R]; nlinarith
      _ ≤ c * n + Real.log 2 + (ℓ : ℝ) * R := by linarith
      _ ≤ c * n + Real.log 2 + (c * n / r + t) * R := by
        linarith [mul_le_mul_of_nonneg_right hℓ hR]
      _ = _ := by dsimp [B]; ring
  have hnumT :
      Real.log (1 / testProb μ C) + (C.card : ℝ) * L ≤ T * n / 4 := by
    have h := mul_le_mul_of_nonneg_right harith.2 hn.le
    linarith
  have hCquarter : (C.card : ℝ) ≤ n / 4 := by
    nlinarith [mul_le_mul_of_nonneg_right (by linarith : η ≤ 1 / 4) hn.le]
  have hcost :
      (Real.log (1 / testProb μ C) + (C.card : ℝ) * L) /
          (n - (C.card : ℝ)) ≤ T := by
    apply (div_le_iff₀ hden).2
    have h := mul_nonneg hT.le (by linarith : 0 ≤ 3 * n / 4 - (C.card : ℝ))
    nlinarith
  have hupper := hcond κ μ hμ C hproper hpC0 hcost
  have hrem := remainingMass_lower_of_card_le μ C q₀ η hηq₀ hCη hbad
  have hgeom :
      (q₀ - η) * (n - (C.card : ℝ)) ≤
        (1 - η) * (q₀ * n - (C.card : ℝ)) := by
    have h := mul_nonneg (by linarith : 0 ≤ 1 - q₀)
      (by linarith : 0 ≤ η * n - (C.card : ℝ))
    nlinarith
  have hstrong :
      (q₀ - η) * (testProb μ C * (n - (C.card : ℝ))) ≤ remainingMass μ C := by
    calc
      _ = testProb μ C * ((q₀ - η) * (n - (C.card : ℝ))) := by ring
      _ ≤ testProb μ C * ((1 - η) * (q₀ * n - (C.card : ℝ))) :=
        mul_le_mul_of_nonneg_left hgeom hpC0.le
      _ = (1 - η) * testProb μ C * (q₀ * n - (C.card : ℝ)) := by ring
      _ ≤ _ := hrem
  have hstrict : (v + δ / 4) * (testProb μ C * (n - (C.card : ℝ))) <
      (q₀ - η) * (testProb μ C * (n - (C.card : ℝ))) :=
    mul_lt_mul_of_pos_right (by dsimp [q₀, η]; linarith) (mul_pos hpC0 hden)
  have hupper' : remainingMass μ C ≤
      (v + δ / 4) * (testProb μ C * (n - (C.card : ℝ))) := by
    simpa only [mul_assoc] using hupper
  exact (not_lt_of_ge (hstrong.trans hupper')) hstrict

/-- The complete transfer; independent coordinates are not assumed within an admissible law. -/
theorem conditioning_to_threshold (A : LawFamily) (hA : TensorClosed A)
    (v δ T L : ℝ) (hv : 0 ≤ v) (hδ : 0 < δ) (hδv : δ < 1 - v)
    (hT : 0 < T) (hTδ : T ≤ δ / 4) (hL : 0 ≤ L)
    (hcond : ConditioningInput A v δ T L)
    (κ : Type) [Fintype κ] [Nonempty κ] (μ : BinaryLaw κ) (hμ : A κ μ) :
    tailProb μ (v + δ) ≤
      Real.exp (-(δ * T / (16 * (1 + L))) * (Fintype.card κ : ℝ)) := by
  obtain ⟨K, hK⟩ := large_length_threshold A v δ T L hv hδ hδv hT hTδ hL hcond
  exact all_lengths_of_large A hA (v + δ) (δ * T / (16 * (1 + L))) K
    (fun κ _ _ ν hν hn => (hK κ ν hν hn).le) κ μ hμ

end ConditioningBridge

namespace ConditioningBridge

attribute [local instance] Classical.propDecidable

local instance finalDecidableEq (α : Sort*) : DecidableEq α :=
  Classical.typeDecidableEq α

variable {ι : Type*} [Fintype ι]

theorem remainingMass_eq_marginal_sum (μ : BinaryLaw ι) (C : Finset ι) :
    remainingMass μ C =
      ∑ i ∈ Finset.univ \ C, prob μ (fun x => tested C x ∧ x i = true) := by
  have hpoint (x : ι → Bool) :
      (if tested C x then μ.mass x * ((wins x : ℝ) - (C.card : ℝ)) else 0) =
        ∑ i ∈ Finset.univ \ C,
          if tested C x ∧ x i = true then μ.mass x else 0 := by
    by_cases hx : tested C x
    · have htotal : (∑ i, if x i = true then (1 : ℝ) else 0) = (wins x : ℝ) := by
        simpa only [wins] using
          (Finset.sum_boole (R := ℝ) (fun i => x i = true) Finset.univ)
      have htested :
          (∑ i ∈ C, if x i = true then (1 : ℝ) else 0) = (C.card : ℝ) := by
        calc
          _ = ∑ _i ∈ C, (1 : ℝ) :=
            Finset.sum_congr rfl (fun i hi => by rw [if_pos (hx i hi)])
          _ = _ := by simp
      have hrest :
          (∑ i ∈ Finset.univ \ C, if x i = true then (1 : ℝ) else 0) =
            (wins x : ℝ) - (C.card : ℝ) := by
        rw [Finset.sum_sdiff_eq_sub (Finset.subset_univ C), htotal, htested]
      rw [if_pos hx, ← hrest, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      by_cases hi : x i = true <;> simp [hx, hi]
    · simp [hx]
  calc
    remainingMass μ C =
        ∑ x, ∑ i ∈ Finset.univ \ C,
          if tested C x ∧ x i = true then μ.mass x else 0 :=
      Finset.sum_congr rfl (fun x _ => hpoint x)
    _ = _ := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i _
      unfold prob
      apply Finset.sum_congr rfl
      intro x _
      by_cases hx : tested C x ∧ x i = true <;> simp [hx]

def conditionalMean (μ : BinaryLaw ι) (C : Finset ι) : ℝ :=
  (∑ i ∈ Finset.univ \ C,
      prob μ (fun x => tested C x ∧ x i = true) / testProb μ C) /
    ((Fintype.card ι : ℝ) - (C.card : ℝ))

theorem conditionalMean_eq (μ : BinaryLaw ι) (C : Finset ι) :
    conditionalMean μ C =
      remainingMass μ C /
        (testProb μ C * ((Fintype.card ι : ℝ) - (C.card : ℝ))) := by
  rw [conditionalMean, ← Finset.sum_div, ← remainingMass_eq_marginal_sum, div_div]

theorem tailProb_eq_ceil (μ : BinaryLaw ι) (q : ℝ) :
    tailProb μ q =
      prob μ (fun x => Nat.ceil (q * (Fintype.card ι : ℝ)) ≤ wins x) := by
  simp only [tailProb, prob, Nat.ceil_le]

/-- The literal conditional-mean and integer-threshold form of the generic transfer. -/
theorem conditioning_to_threshold_at_every_length
    (A : LawFamily) (hA : TensorClosed A)
    (v δ T L : ℝ) (hv : 0 ≤ v) (hδ : 0 < δ) (hδv : δ < 1 - v)
    (hT : 0 < T) (hTδ : T ≤ δ / 4) (hL : 0 ≤ L)
    (hcond : ∀ (κ : Type) [Fintype κ] [Nonempty κ] (μ : BinaryLaw κ), A κ μ →
      ∀ C : Finset κ, C.card < Fintype.card κ → 0 < testProb μ C →
        (Real.log (1 / testProb μ C) + (C.card : ℝ) * L) /
            ((Fintype.card κ : ℝ) - (C.card : ℝ)) ≤ T →
          conditionalMean μ C ≤ v + δ / 4)
    (κ : Type) [Fintype κ] [Nonempty κ] (μ : BinaryLaw κ) (hμ : A κ μ) :
    prob μ (fun x => Nat.ceil ((v + δ) * (Fintype.card κ : ℝ)) ≤ wins x) ≤
      Real.exp (-(δ * T / (16 * (1 + L))) * (Fintype.card κ : ℝ)) := by
  rw [← tailProb_eq_ceil]
  apply conditioning_to_threshold A hA v δ T L hv hδ hδv hT hTδ hL
    (κ := κ) (μ := μ) (hμ := hμ)
  intro κ _ _ μ hμ C hproper hpC hcost
  have h := hcond κ μ hμ C hproper hpC hcost
  rw [conditionalMean_eq] at h
  have hden : 0 < (Fintype.card κ : ℝ) - (C.card : ℝ) := by
    apply sub_pos.mpr
    exact_mod_cast hproper
  have hmul := (div_le_iff₀ (mul_pos hpC hden)).1 h
  simpa only [mul_assoc] using hmul

theorem threshold_supremum (A : LawFamily) (hA : TensorClosed A)
    (v δ T L : ℝ) (hv : 0 ≤ v) (hδ : 0 < δ) (hδv : δ < 1 - v)
    (hT : 0 < T) (hTδ : T ≤ δ / 4) (hL : 0 ≤ L)
    (hcond : ConditioningInput A v δ T L)
    (κ : Type) [Fintype κ] [Nonempty κ] (hμ : ∃ μ : BinaryLaw κ, A κ μ) :
    sSup {p : ℝ | ∃ μ : BinaryLaw κ, A κ μ ∧ p = tailProb μ (v + δ)} ≤
      Real.exp (-(δ * T / (16 * (1 + L))) * (Fintype.card κ : ℝ)) := by
  have hnonempty :
      Set.Nonempty {p : ℝ | ∃ μ : BinaryLaw κ, A κ μ ∧ p = tailProb μ (v + δ)} := by
    obtain ⟨μ, hμ⟩ := hμ
    exact ⟨tailProb μ (v + δ), μ, hμ, rfl⟩
  apply csSup_le hnonempty
  intro p hp
  obtain ⟨μ, hμ, rfl⟩ := hp
  exact conditioning_to_threshold A hA v δ T L hv hδ hδv hT hTδ hL hcond κ μ hμ

theorem fifth_power_rate (δ B L : ℝ) :
    δ * (δ / (4 * B)) ^ 4 / (16 * (1 + L)) =
      δ ^ 5 / (16 * (4 * B) ^ 4 * (1 + L)) := by
  simp only [div_eq_mul_inv, mul_inv]
  ring

end ConditioningBridge

#print axioms ConditioningBridge.upper_tail_selection
#print axioms ConditioningBridge.tensor_tailProb
#print axioms ConditioningBridge.conditioning_to_threshold_at_every_length
#print axioms ConditioningBridge.threshold_supremum
