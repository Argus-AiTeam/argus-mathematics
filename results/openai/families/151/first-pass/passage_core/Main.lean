import Mathlib

set_option maxHeartbeats 1600000

noncomputable section

open scoped BigOperators

namespace PassageCore

def phase (z : ℂ) : ℂ := z / (‖z‖ : ℂ)

lemma phase_norm_le (z : ℂ) : ‖phase z‖ ≤ 1 := by
  by_cases hz : z = 0
  · simp [phase, hz]
  · have hn : ‖z‖ ≠ 0 := norm_ne_zero_iff.mpr hz
    simp [phase, Complex.norm_real, hn]

lemma phase_norm (z : ℂ) (hz : z ≠ 0) : ‖phase z‖ = 1 := by
  have hn : ‖z‖ ≠ 0 := norm_ne_zero_iff.mpr hz
  simp [phase, Complex.norm_real, hn]

lemma phase_pow (z : ℂ) (n : ℕ) : phase (z ^ n) = phase z ^ n := by
  simp [phase, norm_pow, Complex.ofReal_pow, div_pow]

lemma radial_phase (r : ℝ) (u : ℂ) (hr : 0 < r) (hu : ‖u‖ = 1) :
    ‖(r : ℂ) * u‖ = r ∧ phase ((r : ℂ) * u) = u := by
  have hn : ‖(r : ℂ) * u‖ = r := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hr, hu, mul_one]
  refine ⟨hn, ?_⟩
  have hrc : (r : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hr
  rw [phase, hn]
  field_simp

lemma radial_representation (z : ℂ) : z = (‖z‖ : ℂ) * phase z := by
  by_cases hz : z = 0
  · simp [hz, phase]
  · have hn : (‖z‖ : ℂ) ≠ 0 := by exact_mod_cast (norm_ne_zero_iff.mpr hz)
    unfold phase
    field_simp

structure Data (q : ℕ) where
  L : ℝ
  gain : 2 < L
  b : ℝ → ℝ
  b_bounds : ∀ t, 0 ≤ b t ∧ b t ≤ 1
  b_fast : ∀ t, 0 ≤ t → t ≤ 100 → (t ≤ 48 ∨ 52 ≤ t) → b t = 1
  barrier : ∀ t, 0 ≤ t → t ≤ 50 → t + b t ≤ 50
  e : ℂ → ℝ
  e_bounds : ∀ z, 0 ≤ e z ∧ e z ≤ 1
  e_small : ∀ z, ‖z‖ ≤ 1 / 2 → e z = 0
  alpha : ℝ → ℝ
  alpha_bounds : ∀ t, 0 ≤ alpha t ∧ alpha t ≤ 1
  alpha_support : ∀ t, alpha t ≠ 0 → 8 < t ∧ t < 12
  alpha_plateau : ∀ t, 9 ≤ t → t ≤ 11 → alpha t = 1
  beta : Fin q → ℝ → ℝ
  beta_bounds : ∀ l t, 0 ≤ beta l t ∧ beta l t ≤ 1
  beta_support : ∀ l t, beta l t ≠ 0 → 74 < t ∧ t < 80
  beta_width : ∀ l x y, beta l x ≠ 0 → beta l y ≠ 0 → |x - y| < 1
  beta_cover : ∀ t, 76 ≤ t → t ≤ 77 → ∃ l, beta l t = 1
  chi : ℂ → ℝ
  chi_bounds : ∀ z, 0 ≤ chi z ∧ chi z ≤ 1
  chi_plateau : ∀ z, 1 / 2 ≤ ‖z‖ → ‖z‖ ≤ 1 → chi z = 1
  a : ℝ → ℝ
  a_reset : ∀ t, 2 ≤ t → t ≤ 5 → a t = 0
  a_gain : ∀ t, 7 ≤ t → t ≤ 90 → a t = L
  S : ℂ → ℂ
  S_linear : ∀ v, ‖v‖ ≤ 1 → S v = v

namespace Data

variable {q : ℕ} (D : Data q)

def h (t : ℝ) (z : ℂ) : ℝ := D.b t + (1 - D.b t) * D.e z

def predict (D : Data q) (t : ℝ) (z : ℂ) : ℕ → ℝ × ℂ
  | 0 => (t, z)
  | n + 1 =>
      let x := predict D t z n
      (x.1 + D.h x.1 x.2, x.2 ^ 2)

def term (l : Fin q) (t : ℝ) (z : ℂ) (d : ℕ) : ℂ :=
  ((D.alpha t * D.beta l (D.predict t z (d + 1)).1 * D.chi z /
      (10 * D.L ^ d) : ℝ) : ℂ) * phase z ^ (2 ^ (d + 2))

def input (l : Fin q) (t : ℝ) (z : ℂ) : ℂ := ∑' d, D.term l t z d

lemma h_bounds (t : ℝ) (z : ℂ) : 0 ≤ D.h t z ∧ D.h t z ≤ 1 := by
  obtain ⟨hb0, hb1⟩ := D.b_bounds t
  obtain ⟨he0, he1⟩ := D.e_bounds z
  dsimp [h]
  constructor
  · positivity
  · nlinarith [mul_nonneg (sub_nonneg.mpr hb1) (sub_nonneg.mpr he1)]

lemma h_fast (t : ℝ) (z : ℂ) (ht0 : 0 ≤ t) (ht100 : t ≤ 100)
    (ht : t ≤ 48 ∨ 52 ≤ t) : D.h t z = 1 := by
  simp [h, D.b_fast t ht0 ht100 ht]

lemma beta_zero (l : Fin q) (t : ℝ) (ht : t ≤ 74 ∨ 80 ≤ t) :
    D.beta l t = 0 := by
  by_contra hn
  obtain ⟨h0, h1⟩ := D.beta_support l t hn
  rcases ht with h | h <;> linarith

lemma alpha_zero (t : ℝ) (ht : t ≤ 8 ∨ 12 ≤ t) : D.alpha t = 0 := by
  by_contra hn
  obtain ⟨h0, h1⟩ := D.alpha_support t hn
  rcases ht with h | h <;> linarith

lemma input_zero (l : Fin q) (t : ℝ) (z : ℂ) (ha : D.alpha t = 0) :
    D.input l t z = 0 := by
  simp [input, term, ha]

lemma S_zero : D.S 0 = 0 := D.S_linear 0 (by simp)

lemma predict_mono (t : ℝ) (z : ℂ) :
    Monotone (fun n => (D.predict t z n).1) := by
  apply monotone_nat_of_le_succ
  intro n
  change (D.predict t z n).1 ≤
    (D.predict t z n).1 + D.h (D.predict t z n).1 (D.predict t z n).2
  linarith [(D.h_bounds (D.predict t z n).1 (D.predict t z n).2).1]

end Data

structure Orbit {q : ℕ} (D : Data q) (N : ℕ) where
  s : ℕ → ℝ
  z : ℕ → ℂ
  v : ℕ → Fin q → ℂ
  start : 0 ≤ s 0 ∧ s 0 < 1
  finish : 100 ≤ s N
  before : ∀ n, n < N → s n < 100
  clock : ∀ n, n < N → s (n + 1) = s n + D.h (s n) (z n)
  main : ∀ n, n < N →
    z (n + 1) = z n ^ 2 +
      20 * ∑ l : Fin q, (D.beta l (s n) : ℂ) * D.S (v n l)
  register : ∀ n, n < N → ∀ l,
    v (n + 1) l = (D.a (s n) : ℂ) * D.S (v n l) + D.input l (s n) (z n)

namespace Orbit

variable {q N : ℕ} {D : Data q} (O : Orbit D N)

include O

lemma clock_upper (n : ℕ) (hn : n ≤ N) : O.s n ≤ O.s 0 + n := by
  induction n with
  | zero => simp
  | succ n ih =>
      have h := ih (by omega)
      rw [O.clock n (by omega)]
      have hh := (D.h_bounds (O.s n) (O.z n)).2
      push_cast
      linarith

lemma duration : 100 ≤ N := by
  have h := O.clock_upper N le_rfl
  have h0 := O.start.2
  have hN := O.finish
  have : (99 : ℝ) < N := by linarith
  have : 99 < N := by exact_mod_cast this
  omega

lemma clock_mono (i j : ℕ) (hij : i ≤ j) (hj : j ≤ N) : O.s i ≤ O.s j := by
  induction j generalizing i with
  | zero =>
      have : i = 0 := by omega
      subst i
      exact le_rfl
  | succ j ih =>
      by_cases he : i = j + 1
      · subst i; exact le_rfl
      have h := ih i (by omega) (by omega)
      have hh := (D.h_bounds (O.s j) (O.z j)).1
      rw [O.clock j (by omega)]
      linarith

lemma clock_nonneg (n : ℕ) (hn : n ≤ N) : 0 ≤ O.s n :=
  le_trans O.start.1 (O.clock_mono 0 n (by omega) hn)

lemma early_clock (n : ℕ) (hn : n ≤ 48) : O.s n = O.s 0 + n := by
  have hN := O.duration
  induction n with
  | zero => simp
  | succ n ih =>
      have he := ih (by omega)
      have hs0 : 0 ≤ O.s n := O.clock_nonneg n (by omega)
      have hs48 : O.s n ≤ 48 := by
        rw [he]
        have : (n : ℝ) ≤ 47 := by exact_mod_cast (show n ≤ 47 by omega)
        linarith [O.start.2]
      rw [O.clock n (by omega), D.h_fast _ _ hs0 (by linarith) (Or.inl hs48), he]
      push_cast
      ring

lemma no_readout (n : ℕ) (hn : n < N) (hs : O.s n ≤ 74 ∨ 80 ≤ O.s n) :
    O.z (n + 1) = O.z n ^ 2 := by
  rw [O.main n hn]
  simp [D.beta_zero _ _ hs]

lemma preparation_support (n : ℕ) (hn : n < N) (ha : D.alpha (O.s n) ≠ 0) :
    8 ≤ n ∧ n < 12 := by
  obtain ⟨ha8, ha12⟩ := D.alpha_support _ ha
  have hN := O.duration
  constructor
  · by_contra h
    have hn7 : n ≤ 7 := by omega
    have he := O.early_clock n (by omega)
    have hc : (n : ℝ) ≤ 7 := by exact_mod_cast hn7
    linarith [O.start.2]
  · by_contra h
    have hm := O.clock_mono 12 n (by omega) (by omega)
    have he := O.early_clock 12 (by omega)
    norm_num at he
    linarith [O.start.1]

lemma preparation_plateau : D.alpha (O.s 9) = 1 := by
  have he := O.early_clock 9 (by omega)
  norm_num at he
  apply D.alpha_plateau <;> linarith [O.start.1, O.start.2]

lemma input_outside (n : ℕ) (hn : n < N) (h : n < 8 ∨ 12 ≤ n) (l : Fin q) :
    D.input l (O.s n) (O.z n) = 0 := by
  apply D.input_zero
  by_contra ha
  have := O.preparation_support n hn ha
  omega

lemma reset (l : Fin q) : O.v 3 l = 0 := by
  have hN := O.duration
  have hs := O.early_clock 2 (by omega)
  norm_num at hs
  have ha : D.a (O.s 2) = 0 :=
    D.a_reset _ (by linarith [O.start.1]) (by linarith [O.start.2])
  rw [show 3 = 2 + 1 by omega, O.register 2 (by omega) l, ha,
    O.input_outside 2 (by omega) (Or.inl (by omega)) l]
  simp

lemma reset_until_preparation (n : ℕ) (hn3 : 3 ≤ n) (hn8 : n ≤ 8) (l : Fin q) :
    O.v n l = 0 := by
  have hN := O.duration
  induction n using Nat.strong_induction_on with
  | h n ih =>
      by_cases he : n = 3
      · subst n; exact O.reset l
      obtain ⟨u, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (show n ≠ 0 by omega)
      have hp := ih u (by omega) (by omega) (by omega)
      rw [O.register u (by omega) l, hp, D.S_zero,
        O.input_outside u (by omega) (Or.inl (by omega)) l]
      simp

lemma first_crossing (c : ℝ) (hc0 : O.s 0 < c) (hc100 : c ≤ 100) :
    ∃ j, j ≤ N ∧ c ≤ O.s j ∧ O.s j < c + 1 ∧
      ∀ n, n < j → O.s n < c := by
  have hex : ∃ n : ℕ, n ≤ N ∧ c ≤ O.s n := ⟨N, le_rfl, le_trans hc100 O.finish⟩
  let j := Nat.find hex
  have hj : j ≤ N ∧ c ≤ O.s j := Nat.find_spec hex
  have hbefore : ∀ n, n < j → O.s n < c := by
    intro n hn
    by_contra hs
    exact (Nat.find_min hex hn) ⟨by omega, le_of_not_gt hs⟩
  have hj0 : j ≠ 0 := by
    intro he
    have := hj.2
    rw [he] at this
    linarith
  obtain ⟨u, hu⟩ := Nat.exists_eq_succ_of_ne_zero hj0
  refine ⟨j, hj.1, hj.2, ?_, hbefore⟩
  have hs := hbefore u (by omega)
  have hh := (D.h_bounds (O.s u) (O.z u)).2
  rw [hu, O.clock u (by omega)]
  linarith

lemma preparation_radius (i : ℕ) (hi : i < 12) : 1 / 2 < ‖O.z i‖ := by
  have hN := O.duration
  by_contra h
  have hz : ‖O.z i‖ ≤ 1 / 2 := le_of_not_gt h
  have inv : ∀ n, i ≤ n → n ≤ N → O.s n ≤ 50 ∧ ‖O.z n‖ ≤ 1 / 2 := by
    intro n hn
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro hnN
        by_cases he : n = i
        · subst n
          have hs := O.early_clock i (by omega)
          have hic : (i : ℝ) ≤ 11 := by exact_mod_cast (show i ≤ 11 by omega)
          exact ⟨by linarith [O.start.2], hz⟩
        obtain ⟨u, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (show n ≠ 0 by omega)
        obtain ⟨hs, hz⟩ := ih u (by omega) (by omega) (by omega)
        have he := D.e_small (O.z u) hz
        have hb := D.barrier (O.s u) (O.clock_nonneg u (by omega)) hs
        constructor
        · rw [O.clock u (by omega), Data.h, he]
          simpa using hb
        · rw [O.no_readout u (by omega) (Or.inl (by linarith)), norm_pow]
          nlinarith [norm_nonneg (O.z u)]
  have hs := (inv N (by omega) le_rfl).1
  linarith [O.finish]

structure Window where
  r70 : ℕ
  r82 : ℕ
  end70 : r70 ≤ N
  end82 : r82 ≤ N
  lower70 : 70 ≤ O.s r70
  upper70 : O.s r70 < 71
  lower82 : 82 ≤ O.s r82
  upper82 : O.s r82 < 83
  before70 : ∀ n, n < r70 → O.s n < 70
  before82 : ∀ n, n < r82 → O.s n < 82

lemma window_exists : Nonempty (Window O) := by
  obtain ⟨r, hrN, hr0, hr1, hr⟩ :=
    O.first_crossing 70 (by linarith [O.start.2]) (by norm_num)
  obtain ⟨R, hRN, hR0, hR1, hR⟩ :=
    O.first_crossing 82 (by linarith [O.start.2]) (by norm_num)
  exact ⟨⟨r, R, hrN, hRN, hr0, by linarith, hR0, by linarith, hr, hR⟩⟩

variable (W : Window O)

lemma Window.order : W.r70 ≤ W.r82 := by
  by_contra h
  have := W.before70 W.r82 (by omega)
  linarith [W.lower82]

lemma Window.after_preparation : 12 < W.r70 := by
  have hN := O.duration
  by_contra h
  have hm := O.clock_mono W.r70 12 (by omega) (by omega)
  have he := O.early_clock 12 (by omega)
  norm_num at he
  linarith [W.lower70, O.start.2]

lemma predict_pair_before (i d : ℕ) (_hi : i ≤ W.r70) (hd : i + d ≤ W.r70) :
    D.predict (O.s i) (O.z i) d = (O.s (i + d), O.z (i + d)) := by
  induction d with
  | zero => simp [Data.predict]
  | succ d ih =>
      have he := ih (by omega)
      have hn : i + d < N := by have := W.end70; omega
      have hs := W.before70 (i + d) (by omega)
      have hz := O.no_readout (i + d) hn (Or.inl (by linarith))
      simp only [Data.predict, he]
      have ht := O.clock (i + d) hn
      rw [show i + (d + 1) = i + d + 1 by omega]
      apply Prod.ext
      · exact ht.symm
      · exact hz.symm

lemma predict_clock (i d : ℕ) (hi : i ≤ W.r70) (hd : i + d ≤ W.r82) :
    (D.predict (O.s i) (O.z i) d).1 = O.s (i + d) := by
  induction d with
  | zero => simp [Data.predict]
  | succ d ih =>
      by_cases hpre : i + (d + 1) ≤ W.r70
      · exact congrArg Prod.fst (O.predict_pair_before W i (d + 1) hi hpre)
      have he := ih (by omega)
      have hn : i + d < N := by have := W.end82; omega
      have hs70 : 70 ≤ O.s (i + d) :=
        le_trans W.lower70 (O.clock_mono W.r70 (i + d) (by omega) (by omega))
      have hs82 := W.before82 (i + d) (by omega)
      change (D.predict (O.s i) (O.z i) d).1 +
        D.h (D.predict (O.s i) (O.z i) d).1
          (D.predict (O.s i) (O.z i) d).2 = O.s (i + (d + 1))
      rw [he, D.h_fast _ _ (by linarith) (by linarith) (Or.inr (by linarith))]
      rw [show i + (d + 1) = i + d + 1 by omega, O.clock (i + d) hn,
        D.h_fast _ _ (by linarith) (by linarith) (Or.inr (by linarith))]

lemma predict_after (i d : ℕ) (hi : i ≤ W.r70) (hd : W.r82 ≤ i + d) :
    82 ≤ (D.predict (O.s i) (O.z i) d).1 := by
  have hiR : i ≤ W.r82 := le_trans hi (Window.order O W)
  have he := O.predict_clock W i (W.r82 - i) hi (by omega)
  have hm := D.predict_mono (O.s i) (O.z i) (show W.r82 - i ≤ d by omega)
  have hidx : i + (W.r82 - i) = W.r82 := by omega
  rw [hidx] at he
  dsimp only at hm
  rw [he] at hm
  linarith [W.lower82]

lemma predicted_beta (i m : ℕ) (hi : i ≤ W.r70) (l : Fin q) :
    D.beta l (D.predict (O.s i) (O.z i) m).1 =
      if i + m ≤ W.r82 then D.beta l (O.s (i + m)) else 0 := by
  by_cases hm : i + m ≤ W.r82
  · rw [if_pos hm, O.predict_clock W i m hi hm]
  · rw [if_neg hm]
    exact D.beta_zero l _ (Or.inr (by
      have := O.predict_after W i m hi (by omega)
      linarith))

lemma readout_unique (l : Fin q) (j k : ℕ) (hj : j ≤ N) (hk : k ≤ N)
    (hbj : D.beta l (O.s j) ≠ 0) (hbk : D.beta l (O.s k) ≠ 0) : j = k := by
  have prove_order : ∀ j k, j < k → k ≤ N →
      D.beta l (O.s j) ≠ 0 → D.beta l (O.s k) ≠ 0 → False := by
    intro j k hjk hk hbj hbk
    obtain ⟨hs74, hs80⟩ := D.beta_support l _ hbj
    have hs := O.clock (j) (by omega)
    rw [D.h_fast _ _ (by linarith) (by linarith) (Or.inr (by linarith))] at hs
    have hm := O.clock_mono (j + 1) k (by omega) hk
    have hw := (abs_lt.mp (D.beta_width l (O.s j) (O.s k) hbj hbk)).1
    linarith
  rcases lt_trichotomy j k with h | h | h
  · exact False.elim (prove_order j k h hk hbj hbk)
  · exact h
  · exact False.elim (prove_order k j h hj hbk hbj)

lemma readout_after_preparation (i j : ℕ) (hi : i < 12) (_hj : j ≤ N)
    (l : Fin q) (hb : D.beta l (O.s j) ≠ 0) : i < j := by
  have hN := O.duration
  by_contra h
  have hm := O.clock_mono j i (by omega) (by omega)
  have he := O.early_clock i (by omega)
  have hc : (i : ℝ) ≤ 11 := by exact_mod_cast (show i ≤ 11 by omega)
  have hs := (D.beta_support l _ hb).1
  linarith [O.start.2]

lemma readout_before82 (j : ℕ) (hj : j ≤ N) (l : Fin q)
    (hb : D.beta l (O.s j) ≠ 0) : j < W.r82 := by
  by_contra h
  have hm := O.clock_mono W.r82 j (by omega) hj
  have hs := (D.beta_support l _ hb).2
  linarith [W.lower82]

include W in
lemma prediction_single_hit (i j m : ℕ) (hi : i < 12) (hj : j ≤ N)
    (l : Fin q) (hb : D.beta l (O.s j) ≠ 0) :
    D.beta l (D.predict (O.s i) (O.z i) m).1 =
      if i + m = j then D.beta l (O.s j) else 0 := by
  have hir : i ≤ W.r70 := by have := Window.after_preparation O W; omega
  rw [O.predicted_beta W i m hir l]
  by_cases hn : i + m ≤ W.r82
  · rw [if_pos hn]
    by_cases he : i + m = j
    · simp [he]
    · rw [if_neg he]
      by_contra hpos
      exact he (O.readout_unique l (i + m) j
        (le_trans hn W.end82) hj hpos hb)
  · rw [if_neg hn]
    have hjR := O.readout_before82 W j hj l hb
    have he : i + m ≠ j := by omega
    simp [he]

lemma exact_input (i j : ℕ) (hi : i < 12) (hj : j ≤ N)
    (l : Fin q) (hb : D.beta l (O.s j) ≠ 0) :
    D.input l (O.s i) (O.z i) =
      ((D.alpha (O.s i) * D.beta l (O.s j) * D.chi (O.z i) /
        (10 * D.L ^ (j - i - 1)) : ℝ) : ℂ) *
          phase (O.z i) ^ (2 ^ (j - i + 1)) := by
  obtain ⟨W⟩ := O.window_exists
  have hij := O.readout_after_preparation i j hi hj l hb
  let d := j - i - 1
  have hd : i + (d + 1) = j := by dsimp [d]; omega
  have hzero : ∀ k, k ≠ d → D.term l (O.s i) (O.z i) k = 0 := by
    intro k hk
    have hne : i + (k + 1) ≠ j := by dsimp [d] at hk; omega
    simp [Data.term, O.prediction_single_hit W i j (k + 1) hi hj l hb, hne]
  rw [Data.input, tsum_eq_single d hzero]
  unfold Data.term
  rw [O.prediction_single_hit W i j (d + 1) hi hj l hb, if_pos hd]
  have hex : d + 2 = j - i + 1 := by dsimp [d]; omega
  rw [hex]

def signal (l : Fin q) (j i : ℕ) : ℂ :=
  ((D.alpha (O.s i) * D.beta l (O.s j) * D.chi (O.z i) / 10 : ℝ) : ℂ) *
    phase (O.z i) ^ (2 ^ (j - i + 1))

lemma signal_bound (l : Fin q) (j i : ℕ) : ‖O.signal l j i‖ ≤ 1 / 10 := by
  obtain ⟨ha0, ha1⟩ := D.alpha_bounds (O.s i)
  obtain ⟨hb0, hb1⟩ := D.beta_bounds l (O.s j)
  obtain ⟨hc0, hc1⟩ := D.chi_bounds (O.z i)
  have hp0 : 0 ≤ D.alpha (O.s i) * D.beta l (O.s j) * D.chi (O.z i) / 10 := by
    positivity
  have hp1 : D.alpha (O.s i) * D.beta l (O.s j) * D.chi (O.z i) ≤ 1 := by
    calc
      _ ≤ (1 * 1) * 1 :=
        mul_le_mul (mul_le_mul ha1 hb1 hb0 (by norm_num)) hc1 hc0 (by norm_num)
      _ = 1 := by norm_num
  have hn : ‖phase (O.z i)‖ ^ (2 ^ (j - i + 1)) ≤ 1 :=
    pow_le_one₀ (norm_nonneg (phase (O.z i))) (phase_norm_le (O.z i))
  rw [signal, norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg hp0]
  nlinarith [pow_nonneg (norm_nonneg (phase (O.z i))) (2 ^ (j - i + 1))]

def partialSum (l : Fin q) (j u : ℕ) : ℂ :=
  ∑ i ∈ Finset.Ico 8 12, if i < u then O.signal l j i else 0

lemma partial_bound (l : Fin q) (j u : ℕ) : ‖O.partialSum l j u‖ ≤ 2 / 5 := by
  calc
    ‖O.partialSum l j u‖ ≤
        ∑ i ∈ Finset.Ico 8 12, ‖if i < u then O.signal l j i else 0‖ :=
      norm_sum_le _ _
    _ ≤ ∑ _i ∈ Finset.Ico 8 12, (1 / 10 : ℝ) := by
      apply Finset.sum_le_sum
      intro i hi
      split_ifs
      · exact O.signal_bound l j i
      · norm_num
    _ = 2 / 5 := by
      norm_num [Finset.sum_const, show (Finset.Ico 8 12).card = 4 by decide]

lemma partial_step (l : Fin q) (j u : ℕ) :
    O.partialSum l j (u + 1) = O.partialSum l j u +
      if 8 ≤ u ∧ u < 12 then O.signal l j u else 0 := by
  unfold partialSum
  have he : ∀ i, (if i < u + 1 then O.signal l j i else 0) =
      (if i < u then O.signal l j i else 0) +
        (if i = u then O.signal l j i else 0) := by
    intro i
    by_cases hlt : i < u
    · simp [hlt, show i < u + 1 by omega, show i ≠ u by omega]
    · by_cases heq : i = u
      · subst i; simp
      · simp [hlt, heq, show ¬ i < u + 1 by omega]
  simp_rw [he]
  rw [Finset.sum_add_distrib]
  simp

def candidate (l : Fin q) (j u : ℕ) : ℂ :=
  O.partialSum l j u / (D.L : ℂ) ^ (j - u)

lemma candidate_bound (l : Fin q) (j u : ℕ) : ‖O.candidate l j u‖ ≤ 1 / 2 := by
  have hL : 0 < D.L := by linarith [D.gain]
  have hp : 1 ≤ D.L ^ (j - u) := one_le_pow₀ (by linarith [D.gain])
  rw [candidate, norm_div, norm_pow, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos hL]
  apply (div_le_iff₀ (pow_pos hL _)).2
  have hs := O.partial_bound l j u
  nlinarith

lemma compensated_input (u j : ℕ) (hu : 8 ≤ u) (huj : u < j) (hj : j ≤ N)
    (l : Fin q) (hb : D.beta l (O.s j) ≠ 0) :
    D.input l (O.s u) (O.z u) =
      (if 8 ≤ u ∧ u < 12 then O.signal l j u else 0) /
        (D.L : ℂ) ^ (j - (u + 1)) := by
  by_cases h12 : u < 12
  · rw [if_pos ⟨hu, h12⟩, O.exact_input u j h12 hj l hb]
    have he : j - u - 1 = j - (u + 1) := by omega
    simp only [signal, he, Complex.ofReal_div, Complex.ofReal_mul,
      Complex.ofReal_pow, Complex.ofReal_ofNat]
    ring
  · rw [if_neg (by omega), zero_div,
      O.input_outside u (by omega) (Or.inr (by omega)) l]

lemma candidate_step (u j : ℕ) (hu : 8 ≤ u) (huj : u < j) (hj : j ≤ N)
    (l : Fin q) (hb : D.beta l (O.s j) ≠ 0) :
    O.candidate l j (u + 1) =
      (D.L : ℂ) * O.candidate l j u + D.input l (O.s u) (O.z u) := by
  have hL : (D.L : ℂ) ≠ 0 := by
    exact_mod_cast (ne_of_gt (show 0 < D.L by linarith [D.gain]))
  rw [candidate, candidate, O.partial_step, O.compensated_input u j hu huj hj l hb]
  have he : j - u = j - (u + 1) + 1 := by omega
  rw [he, pow_succ]
  field_simp

lemma register_candidate (j : ℕ) (hj : j ≤ N) (l : Fin q)
    (hb : D.beta l (O.s j) ≠ 0) (u : ℕ) (hu : 8 ≤ u) (huj : u ≤ j) :
    O.v u l = O.candidate l j u := by
  have hN := O.duration
  have hi := O.readout_after_preparation 11 j (by omega) hj l hb
  induction u using Nat.strong_induction_on with
  | h u ih =>
      by_cases he : u = 8
      · subst u
        rw [O.reset_until_preparation 8 (by omega) (by omega) l]
        have hz : O.partialSum l j 8 = 0 := by
          unfold partialSum
          apply Finset.sum_eq_zero
          intro i hi
          rw [if_neg (by have := (Finset.mem_Ico.mp hi).1; omega)]
        simp [candidate, hz]
      obtain ⟨w, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (show u ≠ 0 by omega)
      have hv := ih w (by omega) (by omega) (by omega)
      have hs8 := O.early_clock 8 (by omega)
      norm_num at hs8
      have hm0 := O.clock_mono 8 w (by omega) (by omega)
      have hm1 := O.clock_mono w j (by omega) hj
      have hs80 := (D.beta_support l _ hb).2
      have ha : D.a (O.s w) = D.L :=
        D.a_gain _ (by linarith [O.start.1]) (by linarith)
      rw [O.register w (by omega) l, hv, D.S_linear _ (by
        have := O.candidate_bound l j w
        linarith), ha]
      exact (O.candidate_step w j (by omega) (by omega) hj l hb).symm

lemma register_at_readout (j : ℕ) (hj : j ≤ N) (l : Fin q)
    (hb : D.beta l (O.s j) ≠ 0) :
    O.v j l = ∑ i ∈ Finset.Ico 8 12, O.signal l j i := by
  have hij := O.readout_after_preparation 11 j (by omega) hj l hb
  rw [O.register_candidate j hj l hb j (by omega) le_rfl]
  simp only [candidate, Nat.sub_self, pow_zero, div_one, partialSum]
  apply Finset.sum_congr rfl
  intro i hi
  have hi12 := (Finset.mem_Ico.mp hi).2
  rw [if_pos (by omega)]

lemma register_small (j : ℕ) (hj : j ≤ N) (l : Fin q)
    (hb : D.beta l (O.s j) ≠ 0) :
    ‖O.v j l‖ ≤ 1 / 2 ∧ D.S (O.v j l) = O.v j l := by
  have hij := O.readout_after_preparation 11 j (by omega) hj l hb
  have he := O.register_candidate j hj l hb j (by omega) le_rfl
  have hn : ‖O.v j l‖ ≤ 1 / 2 := by
    rw [he]
    exact O.candidate_bound l j j
  exact ⟨hn, D.S_linear _ (by linarith)⟩

lemma pure_squaring (n : ℕ) (hn8 : 8 ≤ n) (hnr : n ≤ W.r70) :
    O.z n = O.z 8 ^ (2 ^ (n - 8)) := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
      by_cases he : n = 8
      · subst n; simp
      obtain ⟨u, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (show n ≠ 0 by omega)
      have huN : u < N := by have := W.end70; omega
      have hs := W.before70 u (by omega)
      rw [O.no_readout u huN (Or.inl (by linarith)),
        ih u (by omega) (by omega) (by omega),
        show u + 1 - 8 = (u - 8) + 1 by omega,
        pow_succ (2 : ℕ) (u - 8), pow_mul]

lemma preparation_phase (i : ℕ) (hi8 : 8 ≤ i) (hi12 : i < 12) :
    phase (O.z i) = phase (O.z 8) ^ (2 ^ (i - 8)) := by
  obtain ⟨W⟩ := O.window_exists
  rw [O.pure_squaring W i hi8 (by have := Window.after_preparation O W; omega),
    phase_pow]

def weight : ℝ := ∑ i ∈ Finset.Ico 8 12, D.alpha (O.s i) * D.chi (O.z i)

lemma weight_nonneg : 0 ≤ O.weight := by
  apply Finset.sum_nonneg
  intro i hi
  exact mul_nonneg (D.alpha_bounds _).1 (D.chi_bounds _).1

def force (n : ℕ) : ℝ :=
  2 * (∑ l : Fin q, D.beta l (O.s n) ^ 2) * O.weight

lemma force_nonneg (n : ℕ) : 0 ≤ O.force n := by
  unfold force
  apply mul_nonneg
  · apply mul_nonneg (by norm_num)
    exact Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  · exact O.weight_nonneg

lemma signal_aligned (j i : ℕ) (hi : i ∈ Finset.Ico 8 12) (hj : j ≤ N)
    (l : Fin q) (hb : D.beta l (O.s j) ≠ 0) :
    O.signal l j i =
      ((D.alpha (O.s i) * D.beta l (O.s j) * D.chi (O.z i) / 10 : ℝ) : ℂ) *
        phase (O.z 8) ^ (2 ^ (j - 8 + 1)) := by
  obtain ⟨hi8, hi12⟩ := Finset.mem_Ico.mp hi
  have hij := O.readout_after_preparation i j hi12 hj l hb
  rw [signal, O.preparation_phase i hi8 hi12, ← pow_mul, ← pow_add]
  rw [show i - 8 + (j - i + 1) = j - 8 + 1 by omega]

lemma register_aligned (j : ℕ) (hj : j ≤ N) (l : Fin q)
    (hb : D.beta l (O.s j) ≠ 0) :
    O.v j l = ((D.beta l (O.s j) / 10 * O.weight : ℝ) : ℂ) *
      phase (O.z 8) ^ (2 ^ (j - 8 + 1)) := by
  rw [O.register_at_readout j hj l hb]
  calc
    (∑ i ∈ Finset.Ico 8 12, O.signal l j i) =
        ∑ i ∈ Finset.Ico 8 12,
          ((D.beta l (O.s j) / 10 : ℝ) : ℂ) *
            ((D.alpha (O.s i) * D.chi (O.z i) : ℝ) : ℂ) *
              phase (O.z 8) ^ (2 ^ (j - 8 + 1)) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [O.signal_aligned j i hi hj l hb]
      push_cast
      ring
    _ = _ := by
      simp only [weight, Complex.ofReal_mul, Complex.ofReal_sum,
        Finset.mul_sum, Finset.sum_mul]

lemma addition_aligned (n : ℕ) (hn : n < N) :
    20 * (∑ l : Fin q, (D.beta l (O.s n) : ℂ) * D.S (O.v n l)) =
      (O.force n : ℂ) * phase (O.z 8) ^ (2 ^ (n - 8 + 1)) := by
  have he : ∀ l : Fin q, (D.beta l (O.s n) : ℂ) * D.S (O.v n l) =
      ((D.beta l (O.s n) ^ 2 * O.weight / 10 : ℝ) : ℂ) *
        phase (O.z 8) ^ (2 ^ (n - 8 + 1)) := by
    intro l
    by_cases hb : D.beta l (O.s n) = 0
    · simp [hb]
    · rw [(O.register_small n (by omega) l hb).2,
        O.register_aligned n (by omega) l hb]
      push_cast
      ring
  simp_rw [he]
  rw [← Finset.sum_mul]
  simp only [force, Complex.ofReal_mul, Complex.ofReal_sum,
    Complex.ofReal_div, Complex.ofReal_pow, Complex.ofReal_ofNat]
  rw [← Finset.sum_div, ← Finset.sum_mul]
  ring

lemma step_radial (n : ℕ) (_hn8 : 8 ≤ n) (hnN : n < N)
    (_hz : O.z n ≠ 0)
    (hp : phase (O.z n) = phase (O.z 8) ^ (2 ^ (n - 8))) :
    O.z (n + 1) =
      ((‖O.z n‖ ^ 2 + O.force n : ℝ) : ℂ) *
        phase (O.z 8) ^ (2 ^ (n - 8 + 1)) := by
  have hsq : O.z n ^ 2 =
      ((‖O.z n‖ ^ 2 : ℝ) : ℂ) *
        phase (O.z 8) ^ (2 ^ (n - 8 + 1)) := by
    conv_lhs => rw [radial_representation (O.z n)]
    rw [mul_pow, hp, ← pow_mul, ← pow_succ]
    simp
  rw [O.main n hnN, hsq, O.addition_aligned n hnN]
  push_cast
  ring

lemma phase_and_nonzero (n : ℕ) (hn8 : 8 ≤ n) (hnN : n ≤ N) :
    O.z n ≠ 0 ∧ phase (O.z n) = phase (O.z 8) ^ (2 ^ (n - 8)) := by
  have hz8 : O.z 8 ≠ 0 := by
    have := O.preparation_radius 8 (by omega)
    intro hz
    norm_num [hz] at this
  have htheta := phase_norm (O.z 8) hz8
  induction n using Nat.strong_induction_on with
  | h n ih =>
      by_cases he : n = 8
      · subst n; simpa using And.intro hz8 (rfl : phase (O.z 8) = phase (O.z 8))
      obtain ⟨u, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (show n ≠ 0 by omega)
      obtain ⟨hzu, hpu⟩ := ih u (by omega) (by omega) (by omega)
      have hr : 0 < ‖O.z u‖ ^ 2 + O.force u := by
        have hzpos : 0 < ‖O.z u‖ := norm_pos_iff.mpr hzu
        nlinarith [O.force_nonneg u, sq_pos_of_pos hzpos]
      have hunit : ‖phase (O.z 8) ^ (2 ^ (u - 8 + 1))‖ = 1 := by
        rw [norm_pow, htheta, one_pow]
      have hphase := (radial_phase (‖O.z u‖ ^ 2 + O.force u)
        (phase (O.z 8) ^ (2 ^ (u - 8 + 1))) hr hunit).2
      have hnorm := (radial_phase (‖O.z u‖ ^ 2 + O.force u)
        (phase (O.z 8) ^ (2 ^ (u - 8 + 1))) hr hunit).1
      have he := O.step_radial u (by omega) (by omega) hzu hpu
      constructor
      · intro hz
        rw [← he, hz, norm_zero] at hnorm
        linarith
      · rw [he, hphase]
        congr 2
        omega

lemma radius_update (n : ℕ) (hn8 : 8 ≤ n) (hnN : n < N) :
    ‖O.z (n + 1)‖ = ‖O.z n‖ ^ 2 + O.force n := by
  obtain ⟨hz, hp⟩ := O.phase_and_nonzero n hn8 (by omega)
  have hz8 := (O.phase_and_nonzero 8 (by omega) (by omega)).1
  have htheta := phase_norm (O.z 8) hz8
  have hr : 0 < ‖O.z n‖ ^ 2 + O.force n := by
    have hzpos : 0 < ‖O.z n‖ := norm_pos_iff.mpr hz
    nlinarith [O.force_nonneg n, sq_pos_of_pos hzpos]
  rw [O.step_radial n hn8 hnN hz hp]
  exact (radial_phase _ _ hr (by rw [norm_pow, htheta, one_pow])).1

lemma square_lower_bound (n : ℕ) (hn8 : 8 ≤ n) (hnN : n < N) :
    ‖O.z n‖ ^ 2 ≤ ‖O.z (n + 1)‖ := by
  rw [O.radius_update n hn8 hnN]
  linarith [O.force_nonneg n]

lemma phase_doubling (n : ℕ) (hn8 : 8 ≤ n) (hnN : n < N) :
    phase (O.z (n + 1)) = phase (O.z n) ^ 2 := by
  rw [(O.phase_and_nonzero (n + 1) (by omega) (by omega)).2,
    (O.phase_and_nonzero n hn8 (by omega)).2,
    show n + 1 - 8 = n - 8 + 1 by omega, pow_succ, pow_mul]

lemma compulsory_escape : ∃ n, 8 ≤ n ∧ n < N ∧ 1 < ‖O.z n‖ := by
  have hN := O.duration
  by_cases hz9 : 1 < ‖O.z 9‖
  · exact ⟨9, by omega, by omega, hz9⟩
  have hc : D.chi (O.z 9) = 1 := D.chi_plateau _
    (le_of_lt (O.preparation_radius 9 (by omega))) (le_of_not_gt hz9)
  have hw : 1 ≤ O.weight := by
    have hm : 9 ∈ Finset.Ico 8 12 := by decide
    have h := Finset.single_le_sum
      (fun i (_hi : i ∈ Finset.Ico 8 12) =>
        mul_nonneg (D.alpha_bounds (O.s i)).1 (D.chi_bounds (O.z i)).1) hm
    simpa [weight, O.preparation_plateau, hc] using h
  obtain ⟨j, hjN, hj76, hj77, _⟩ :=
    O.first_crossing 76 (by linarith [O.start.2]) (by norm_num)
  obtain ⟨l, hl⟩ := D.beta_cover (O.s j) hj76 (by linarith)
  have hbj : D.beta l (O.s j) ≠ 0 := by rw [hl]; norm_num
  have hj8 := O.readout_after_preparation 8 j (by omega) hjN l hbj
  have hjlt : j < N := by
    by_contra h
    have : j = N := by omega
    subst j
    linarith [O.finish]
  have hs : O.s (j + 1) = O.s j + 1 := by
    rw [O.clock j hjlt, D.h_fast _ _ (by linarith) (by linarith)
      (Or.inr (by linarith))]
  have hjend : j + 1 < N := by
    by_contra h
    have : j + 1 = N := by omega
    rw [this] at hs
    linarith [O.finish]
  have hb : 1 ≤ ∑ k : Fin q, D.beta k (O.s j) ^ 2 := by
    have h := Finset.single_le_sum
      (fun k (_hk : k ∈ (Finset.univ : Finset (Fin q))) =>
        sq_nonneg (D.beta k (O.s j))) (Finset.mem_univ l)
    simpa [hl] using h
  have hf : 2 ≤ O.force j := by
    unfold force
    nlinarith [mul_nonneg (sub_nonneg.mpr hb) (sub_nonneg.mpr hw)]
  refine ⟨j + 1, by omega, hjend, ?_⟩
  rw [O.radius_update j (by omega) hjlt]
  nlinarith [sq_nonneg ‖O.z j‖]

structure Certified : Prop where
  reset : ∀ l, O.v 8 l = 0
  preparation_support : ∀ n, n < N → D.alpha (O.s n) ≠ 0 → 8 ≤ n ∧ n < 12
  preparation_plateau : D.alpha (O.s 9) = 1
  preparation_radius : ∀ i, i < 12 → 1 / 2 < ‖O.z i‖
  clocks : ∃ W : Window O, ∀ i m, i < 12 → i + m ≤ W.r82 →
    (D.predict (O.s i) (O.z i) m).1 = O.s (i + m)
  single_hit : ∀ l j k, j ≤ N → k ≤ N →
    D.beta l (O.s j) ≠ 0 → D.beta l (O.s k) ≠ 0 → j = k
  predicted_hit : ∀ i j m, i < 12 → j ≤ N → ∀ l,
    D.beta l (O.s j) ≠ 0 →
      D.beta l (D.predict (O.s i) (O.z i) m).1 =
        if i + m = j then D.beta l (O.s j) else 0
  linear_until_own_readout : ∀ j, j ≤ N → ∀ l, D.beta l (O.s j) ≠ 0 →
    ∀ u, 8 ≤ u → u ≤ j →
      O.v u l = O.candidate l j u ∧ ‖O.v u l‖ ≤ 1 / 2
  exact_register : ∀ j, j ≤ N → ∀ l, D.beta l (O.s j) ≠ 0 →
    O.v j l = ∑ i ∈ Finset.Ico 8 12, O.signal l j i
  radial_update : ∀ n, 8 ≤ n → n < N →
    ‖O.z (n + 1)‖ = ‖O.z n‖ ^ 2 +
      2 * (∑ l : Fin q, D.beta l (O.s n) ^ 2) * O.weight
  nonzero : ∀ n, 8 ≤ n → n ≤ N → O.z n ≠ 0
  phase_doubling : ∀ n, 8 ≤ n → n < N →
    phase (O.z (n + 1)) = phase (O.z n) ^ 2
  square_lower_bound : ∀ n, 8 ≤ n → n < N → ‖O.z n‖ ^ 2 ≤ ‖O.z (n + 1)‖
  escape : ∃ n, 8 ≤ n ∧ n < N ∧ 1 < ‖O.z n‖

theorem complete_passage : Certified O := by
  obtain ⟨W⟩ := O.window_exists
  refine {
    reset := fun l => O.reset_until_preparation 8 (by omega) (by omega) l
    preparation_support := O.preparation_support
    preparation_plateau := O.preparation_plateau
    preparation_radius := O.preparation_radius
    clocks := ?_
    single_hit := O.readout_unique
    predicted_hit := O.prediction_single_hit W
    linear_until_own_readout := ?_
    exact_register := O.register_at_readout
    radial_update := O.radius_update
    nonzero := fun n hn hN => (O.phase_and_nonzero n hn hN).1
    phase_doubling := O.phase_doubling
    square_lower_bound := O.square_lower_bound
    escape := O.compulsory_escape
  }
  · refine ⟨W, ?_⟩
    intro i m hi hm
    exact O.predict_clock W i m (by have := Window.after_preparation O W; omega) hm
  · intro j hj l hb u hu huj
    have he := O.register_candidate j hj l hb u hu huj
    exact ⟨he, by rw [he]; exact O.candidate_bound l j u⟩

#print axioms complete_passage

end Orbit

end PassageCore
