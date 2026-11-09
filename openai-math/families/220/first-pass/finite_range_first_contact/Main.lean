import Mathlib

noncomputable section

namespace PosteriorContact

lemma two_pow_one_le (i : ℕ) : (1 : ℝ) ≤ 2 ^ i := by
  induction i with
  | zero => norm_num
  | succ i ih =>
      rw [pow_succ]
      nlinarith

lemma two_pow_mono {a b : ℕ} (h : a ≤ b) : (2 : ℝ) ^ a ≤ 2 ^ b := by
  obtain ⟨c, rfl⟩ := Nat.exists_eq_add_of_le h
  rw [pow_add]
  have hc := two_pow_one_le c
  have ha : 0 < (2 : ℝ) ^ a := by positivity
  nlinarith

lemma unit_pow_le (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (s : ℕ) :
    (1 - p) ^ s ≤ 1 := by
  induction s with
  | zero => simp
  | succ s ih =>
      rw [pow_succ]
      have hpow : 0 ≤ (1 - p) ^ s := pow_nonneg (by linarith) _
      nlinarith

lemma bernoulli_lower (p : ℝ) (_hp0 : 0 ≤ p) (hp1 : p ≤ 1) (s : ℕ) :
    1 - (s : ℝ) * p ≤ (1 - p) ^ s := by
  induction s with
  | zero => simp
  | succ s ih =>
      rw [pow_succ (1 - p) s]
      push_cast
      have hmul := mul_le_mul_of_nonneg_right ih (show 0 ≤ 1 - p by linarith)
      have hsq : 0 ≤ (s : ℝ) * p ^ 2 := mul_nonneg (Nat.cast_nonneg _) (sq_nonneg _)
      nlinarith

theorem bonferroni_two (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (s : ℕ) :
    (s : ℝ) * p - (s : ℝ) * ((s : ℝ) - 1) * p ^ 2 / 2 ≤
      1 - (1 - p) ^ s := by
  induction s with
  | zero => simp
  | succ s ih =>
      rw [pow_succ (1 - p) s]
      push_cast
      have hb := bernoulli_lower p hp0 hp1 s
      have hmul := mul_le_mul_of_nonneg_left hb hp0
      nlinarith

theorem hit_probability_half (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (s : ℕ) (hsp : (s : ℝ) * p ≤ 1) :
    (s : ℝ) * p / 2 ≤ 1 - (1 - p) ^ s := by
  have hb := bonferroni_two p hp0 hp1 s
  have hx0 : 0 ≤ (s : ℝ) * p := mul_nonneg (Nat.cast_nonneg _) hp0
  have hx2 : ((s : ℝ) * p) ^ 2 ≤ (s : ℝ) * p := by nlinarith
  have hsq : 0 ≤ (s : ℝ) * p ^ 2 := mul_nonneg (Nat.cast_nonneg _) (sq_nonneg _)
  nlinarith

def peakTerm (i s : ℕ) : ℝ :=
  (2 : ℝ) ^ i / 2 * (1 - (1 - 1 / (2 : ℝ) ^ (i + 1)) ^ s)

def peak (n s : ℕ) : ℝ :=
  1 + ∑ i ∈ Finset.range n, peakTerm i s

lemma peakTerm_nonneg (i s : ℕ) : 0 ≤ peakTerm i s := by
  have ha := two_pow_one_le (i + 1)
  have hp0 : 0 ≤ 1 / (2 : ℝ) ^ (i + 1) := by positivity
  have hp1 : 1 / (2 : ℝ) ^ (i + 1) ≤ 1 := by
    exact (div_le_one (by positivity)).2 ha
  have hu := unit_pow_le _ hp0 hp1 s
  unfold peakTerm
  positivity

lemma peakTerm_lower {i s L J : ℕ} (hLi : L ≤ i) (hs : s ≤ J)
    (hJ : J ≤ 2 ^ L) : (s : ℝ) / 8 ≤ peakTerm i s := by
  let a : ℝ := 2 ^ i
  let p : ℝ := 1 / (2 : ℝ) ^ (i + 1)
  have ha0 : 0 < a := by dsimp [a]; positivity
  have hp0 : 0 ≤ p := by dsimp [p]; positivity
  have hp1 : p ≤ 1 := by
    dsimp [p]
    exact (div_le_one (by positivity)).2 (two_pow_one_le _)
  have hsJ : (s : ℝ) ≤ (J : ℝ) := by exact_mod_cast hs
  have hJr : (J : ℝ) ≤ (2 : ℝ) ^ L := by exact_mod_cast hJ
  have hsa : (s : ℝ) ≤ a := le_trans hsJ (le_trans hJr (two_pow_mono hLi))
  have hap : a * p = 1 / 2 := by
    dsimp [a, p]
    rw [pow_succ]
    field_simp
  have hsp : (s : ℝ) * p ≤ 1 := by
    have h := mul_le_mul_of_nonneg_right hsa hp0
    rw [hap] at h
    linarith
  have hh := hit_probability_half p hp0 hp1 s hsp
  have hm := mul_le_mul_of_nonneg_left hh (show 0 ≤ a / 2 by positivity)
  change (s : ℝ) / 8 ≤ a / 2 * (1 - (1 - p) ^ s)
  have heq : a / 2 * ((s : ℝ) * p / 2) = (s : ℝ) / 8 := by
    calc
      a / 2 * ((s : ℝ) * p / 2) = (s : ℝ) * (a * p) / 4 := by ring
      _ = (s : ℝ) / 8 := by rw [hap]; ring
  linarith

lemma tail_sum_lower (a : ℕ → ℝ) (c : ℝ) (L n : ℕ)
    (hc : 0 ≤ c) (hpos : ∀ i, 0 ≤ a i)
    (htail : ∀ i, L ≤ i → c ≤ a i) :
    ((n : ℝ) - (L : ℝ)) * c ≤ ∑ i ∈ Finset.range n, a i := by
  induction n with
  | zero =>
      simp only [Nat.cast_zero, zero_sub, Finset.range_zero, Finset.sum_empty]
      have h := mul_nonneg (Nat.cast_nonneg L) hc
      nlinarith
  | succ n ih =>
      rw [Finset.sum_range_succ]
      push_cast
      by_cases hLn : L ≤ n
      · have ht := htail n hLn
        nlinarith
      · have hLn' : n + 1 ≤ L := by omega
        have hcast : (n : ℝ) + 1 ≤ (L : ℝ) := by exact_mod_cast hLn'
        have hleft : ((n : ℝ) + 1 - (L : ℝ)) * c ≤ 0 :=
          mul_nonpos_of_nonpos_of_nonneg (by linarith) hc
        have hsum : 0 ≤ ∑ i ∈ Finset.range n, a i :=
          Finset.sum_nonneg fun i _ => hpos i
        have hn := hpos n
        linarith

theorem reset_peak_lower (n L J s : ℕ) (hJ : J ≤ 2 ^ L)
    (hLn : 2 * L ≤ n) (hs : s ≤ J) :
    (s : ℝ) * (n : ℝ) / 16 ≤ peak n s := by
  have hsum := tail_sum_lower (fun i => peakTerm i s) ((s : ℝ) / 8) L n
    (by positivity) (fun i => peakTerm_nonneg i s)
    (fun i hi => peakTerm_lower hi hs hJ)
  have hLnr : 2 * (L : ℝ) ≤ (n : ℝ) := by exact_mod_cast hLn
  have hscaled : 0 ≤ ((n : ℝ) - 2 * (L : ℝ)) * (s : ℝ) :=
    mul_nonneg (by linarith) (Nat.cast_nonneg _)
  unfold peak
  nlinarith

lemma sum_range_real (J : ℕ) :
    (∑ s ∈ Finset.range J, (s : ℝ)) = (J : ℝ) * ((J : ℝ) - 1) / 2 := by
  induction J with
  | zero => simp
  | succ J ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      ring

def lowerMoment (n J : ℕ) (delta : ℝ) : ℝ :=
  delta / 2 * (∑ s ∈ Finset.range J, peak n s) + delta * peak n J

theorem sharp_moment_lower (n L J : ℕ) (delta : ℝ) (hd : 0 ≤ delta)
    (hJ : J ≤ 2 ^ L) (hLn : 2 * L ≤ n) :
    delta * (n : ℝ) * (J : ℝ) ^ 2 / 64 ≤ lowerMoment n J delta := by
  have hsum : (n : ℝ) / 16 * ((J : ℝ) * ((J : ℝ) - 1) / 2) ≤
      ∑ s ∈ Finset.range J, peak n s := by
    calc
      _ = ∑ s ∈ Finset.range J, (s : ℝ) * (n : ℝ) / 16 := by
        rw [← sum_range_real, Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro s _
        ring
      _ ≤ _ := Finset.sum_le_sum fun s hs => reset_peak_lower n L J s hJ hLn
        (Nat.le_of_lt (Finset.mem_range.mp hs))
  have hlast := reset_peak_lower n L J J hJ hLn le_rfl
  have hsum' := mul_le_mul_of_nonneg_left hsum (show 0 ≤ delta / 2 by positivity)
  have hlast' := mul_le_mul_of_nonneg_left hlast hd
  have hnonneg : 0 ≤ delta * (n : ℝ) * (J : ℝ) := by positivity
  unfold lowerMoment
  nlinarith

end PosteriorContact
