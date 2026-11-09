import Mathlib

set_option maxHeartbeats 4000000
set_option maxRecDepth 4096

open Finset

namespace GaussianPropellerAudit

def excess (A x : ℝ) : ℝ := 0.415 * x - (A - 0.15) * x ^ 2

lemma prefix_le {f : ℕ → ℝ} {a b : ℕ} (hab : a ≤ b)
    (hf : ∀ i < b, 0 ≤ f i) :
    (∑ i ∈ range a, f i) ≤ ∑ i ∈ range b, f i := by
  apply sum_le_sum_of_subset_of_nonneg (range_mono hab)
  intro i hi _
  exact hf i (mem_range.mp hi)

lemma concave_quadratic_chord {d p a b x y : ℝ}
    (hd : 0 ≤ d) (hab : a < b) (hax : a ≤ x) (hxb : x ≤ b)
    (ha : y ≤ p * a - d * a ^ 2)
    (hb : y ≤ p * b - d * b ^ 2) :
    y ≤ p * x - d * x ^ 2 := by
  have hprod := mul_nonneg (sub_nonneg.mpr hax) (sub_nonneg.mpr hxb)
  have hweighta := mul_nonneg (sub_nonneg.mpr hxb) (sub_nonneg.mpr ha)
  have hweightb := mul_nonneg (sub_nonneg.mpr hax) (sub_nonneg.mpr hb)
  have hcurv := mul_nonneg hd hprod
  nlinarith

lemma third_radius_floor {u L : ℝ}
    (hu : 0 < u) (hL : L ≤ 8 / 9)
    (hcharge : (1 - L) * (0.415 - 0.734 * u) ≤ 0.116 * u) :
    0.23 < u := by
  by_contra h
  have hup : u ≤ 0.23 := le_of_not_gt h
  have hprod := mul_nonneg (by linarith : 0 ≤ 8 / 9 - L)
    (by linarith : 0 ≤ 0.415 - 0.734 * u)
  nlinarith

lemma small_minimum_box {u L t a b M : ℝ}
    (ht : 0 < t) (htop : t ≤ 0.066)
    (hu : a ≤ u) (hub : u ≤ b)
    (ha : 0.066 < a) (hb : b < 0.415 / 0.734)
    (hL : L ≤ 8 / 9)
    (hcharge : (1 - L) * (0.415 - 0.734 * u) ≤ 0.116 * u)
    (hM : M = 1 - 0.116 / (0.415 / b - 0.734) - b ^ 2 - 2 * 0.066 ^ 2)
    (hMpos : 0 < M)
    (hmargin : 8 * (23 / 25) * 0.066 ^ 2 < (a ^ 2 - 0.066 ^ 2) * M)
    (hdet : (u ^ 2 - t ^ 2) * (L - u ^ 2 - 2 * t ^ 2)
      ≤ 8 * (23 / 25) * t ^ 2) : False := by
  have hbpos : 0 < b := by linarith
  have hden : 0 < 0.415 / b - 0.734 := by
    rw [sub_pos, lt_div_iff₀ hbpos]
    nlinarith
  have ht2 : t ^ 2 ≤ 0.066 ^ 2 := by nlinarith
  have hu2 : a ^ 2 ≤ u ^ 2 := by nlinarith
  have hu2top : u ^ 2 ≤ b ^ 2 := by nlinarith
  have hc : (1 - L) * (0.415 - 0.734 * b) ≤ 0.116 * b := by
    have := mul_nonneg (by linarith : 0 ≤ 1 - L) (by linarith : 0 ≤ b - u)
    nlinarith
  have hLb : 1 - 0.116 / (0.415 / b - 0.734) ≤ L := by
    have hscaled : (1 - L) * (0.415 / b - 0.734) ≤ 0.116 := by
      apply (mul_le_mul_iff_left₀ hbpos).mp
      calc
        (1 - L) * (0.415 / b - 0.734) * b
            = (1 - L) * (0.415 - 0.734 * b) := by
                field_simp
        _ ≤ 0.116 * b := hc
    have := (le_div_iff₀ hden).mpr hscaled
    linarith
  have hfactor : M ≤ L - u ^ 2 - 2 * t ^ 2 := by linarith
  have hfactor0 : 0 ≤ L - u ^ 2 - 2 * t ^ 2 := by linarith
  have hprod := mul_le_mul (by linarith : a ^ 2 - 0.066 ^ 2 ≤ u ^ 2 - t ^ 2)
    hfactor (le_of_lt hMpos) (by nlinarith : 0 ≤ u ^ 2 - t ^ 2)
  nlinarith

lemma minimum_floor {u L t : ℝ}
    (ht : 0 < t) (hu : 0.23 < u)
    (hL : L ≤ 8 / 9) (hLu : 2 * u ^ 2 ≤ L)
    (hcharge : (1 - L) * (0.415 - 0.734 * u) ≤ 0.116 * u)
    (hdet : (u ^ 2 - t ^ 2) * (L - u ^ 2 - 2 * t ^ 2)
      ≤ 8 * (23 / 25) * t ^ 2) : 0.066 < t := by
  by_contra h
  have htup : t ≤ 0.066 := le_of_not_gt h
  by_cases hu44 : 0.44 ≤ u
  · have ht2 : t ^ 2 ≤ 0.066 ^ 2 := by nlinarith
    have hu2 : 0.44 ^ 2 ≤ u ^ 2 := by nlinarith
    have hprod := mul_le_mul
      (by linarith : 0.44 ^ 2 - 0.066 ^ 2 ≤ u ^ 2 - t ^ 2)
      (by linarith : 0.44 ^ 2 - 2 * 0.066 ^ 2 ≤ L - u ^ 2 - 2 * t ^ 2)
      (by norm_num : (0 : ℝ) ≤ 0.44 ^ 2 - 2 * 0.066 ^ 2)
      (by nlinarith : 0 ≤ u ^ 2 - t ^ 2)
    nlinarith
  · have hu44' : u ≤ 0.44 := le_of_lt (lt_of_not_ge hu44)
    by_cases h30 : u ≤ 0.30
    · exact small_minimum_box ht htup (le_of_lt hu) h30
        (by norm_num) (by norm_num) hL hcharge rfl (by norm_num) (by norm_num) hdet
    · have h30' : 0.30 ≤ u := le_of_lt (lt_of_not_ge h30)
      by_cases h35 : u ≤ 0.35
      · exact small_minimum_box ht htup h30' h35
          (by norm_num) (by norm_num) hL hcharge rfl (by norm_num) (by norm_num) hdet
      · have h35' : 0.35 ≤ u := le_of_lt (lt_of_not_ge h35)
        by_cases h41 : u ≤ 0.41
        · exact small_minimum_box ht htup h35' h41
            (by norm_num) (by norm_num) hL hcharge rfl (by norm_num) (by norm_num) hdet
        · exact small_minimum_box ht htup (le_of_lt (lt_of_not_ge h41)) hu44'
            (by norm_num) (by norm_num) hL hcharge rfl (by norm_num) (by norm_num) hdet

lemma excess_chord {A a b x y : ℝ} (hd : 0 ≤ A - 0.15)
    (hab : a < b) (hax : a ≤ x) (hxb : x ≤ b)
    (ha : y ≤ excess A a) (hb : y ≤ excess A b) : y ≤ excess A x := by
  exact concave_quadratic_chord hd hab hax hxb ha hb

lemma excess_strict_chord {A a b x y : ℝ} (hd : 0 ≤ A - 0.15)
    (hab : a < b) (hax : a ≤ x) (hxb : x ≤ b)
    (ha : y < excess A a) (hb : y < excess A b) : y < excess A x := by
  exact lt_of_lt_of_le (lt_min ha hb)
    (excess_chord hd hab hax hxb (min_le_left _ _) (min_le_right _ _))

lemma excess_increasing {A x y : ℝ} (hd : 0 ≤ A - 0.15)
    (hxy : x ≤ y) (hder : 2 * (A - 0.15) * y ≤ 0.415) :
    excess A x ≤ excess A y := by
  have hfactor : 0 ≤ 0.415 - (A - 0.15) * (x + y) := by nlinarith
  have := mul_nonneg (sub_nonneg.mpr hxy) hfactor
  dsimp [excess]
  nlinarith

lemma clipped_charge {A x δ K v R : ℝ}
    (hδ : excess A x ≤ δ) (hδ0 : 0 ≤ δ) (hx : 0.42 ≤ x)
    (hK : 0 ≤ K) (hdK : 0 ≤ A - 0.15 - K)
    (hR : 0.42 < R) (hv : v ≤ R ^ 2)
    (ha : K * v ≤ 0.415 * 0.42 - (A - 0.15 - K) * 0.42 ^ 2)
    (hb : K * v ≤ 0.415 * R - (A - 0.15 - K) * R ^ 2) :
    K * (v - x ^ 2) ≤ δ := by
  by_cases hxR : x ≤ R
  · have := concave_quadratic_chord hdK hR hx hxR ha hb
    dsimp [excess] at hδ
    nlinarith
  · have hxR' : R ≤ x := le_of_lt (lt_of_not_ge hxR)
    have hx2 : R ^ 2 ≤ x ^ 2 := by nlinarith
    have := mul_nonpos_of_nonneg_of_nonpos hK (by linarith : v - x ^ 2 ≤ 0)
    linarith

structure RadiusData (m : ℕ) (A : ℝ) where
  r : ℕ → ℝ
  δ : ℕ → ℝ
  positive : ∀ i < m, 0 < r i
  cap : ∀ i < m, r i ≤ 2 / 3
  ordered : ∀ i j, i ≤ j → j < m → r j ≤ r i
  energy : (∑ i ∈ range m, r i ^ 2) = 1
  nonnegative : ∀ i < m, 0 ≤ δ i
  charge : ∀ i < m, excess A (r i) ≤ δ i
  budget : (∑ i ∈ range m, δ i) = 1 - A

namespace RadiusData

variable {m : ℕ} {A : ℝ} (D : RadiusData m A)

def t : ℝ := D.r (m - 1)
def u : ℝ := D.r 2
def L : ℝ := D.r 0 ^ 2 + D.r 1 ^ 2

lemma sq_order {i j : ℕ} (hij : i ≤ j) (hj : j < m) :
    D.r j ^ 2 ≤ D.r i ^ 2 := by
  exact pow_le_pow_left₀ (le_of_lt (D.positive j hj)) (D.ordered i j hij hj) 2

lemma energy_prefix {n : ℕ} (hn : n ≤ m) :
    (∑ i ∈ range n, D.r i ^ 2) ≤ 1 := by
  exact (prefix_le hn (fun i _ => sq_nonneg (D.r i))).trans_eq D.energy

lemma budget_prefix {n : ℕ} (hn : n ≤ m) :
    (∑ i ∈ range n, D.δ i) ≤ 1 - A := by
  exact (prefix_le hn D.nonnegative).trans_eq D.budget

lemma t_positive (hm : 1 ≤ m) : 0 < D.t :=
  D.positive (m - 1) (by omega)

lemma t_le {i : ℕ} (hi : i < m) : D.t ≤ D.r i :=
  D.ordered i (m - 1) (by omega) (by omega)

lemma L_nonnegative : 0 ≤ D.L := add_nonneg (sq_nonneg _) (sq_nonneg _)

lemma L_cap (hm : 2 ≤ m) : D.L ≤ 8 / 9 := by
  have h0 := D.cap 0 (by omega)
  have h1 := D.cap 1 (by omega)
  have hp0 := D.positive 0 (by omega)
  have hp1 := D.positive 1 (by omega)
  dsimp [L]
  nlinarith

lemma L_lower (hm : 3 ≤ m) : 2 * D.u ^ 2 ≤ D.L := by
  have h0 := D.sq_order (i := 0) (j := 2) (by norm_num) (by omega)
  have h1 := D.sq_order (i := 1) (j := 2) (by norm_num) (by omega)
  dsimp [L, u]
  linarith

lemma common_charge (hm : 3 ≤ m) (hA : 0.884 ≤ A) :
    (1 - D.L) * (0.415 - 0.734 * D.u) ≤ 0.116 * D.u := by
  have hu : 0 < D.u := D.positive 2 (by omega)
  have htailδ : (∑ i ∈ Ico 2 m, D.δ i) ≤ 1 - A := by
    rw [← D.budget]
    apply sum_le_sum_of_subset_of_nonneg
    · intro i hi
      exact mem_range.mpr (mem_Ico.mp hi).2
    · intro i hi _
      exact D.nonnegative i (mem_range.mp hi)
  have htailr : (∑ i ∈ Ico 2 m, D.r i ^ 2) = 1 - D.L := by
    have h := sum_range_add_sum_Ico (fun i => D.r i ^ 2) (show 2 ≤ m by omega)
    rw [D.energy] at h
    norm_num [sum_range_succ] at h
    dsimp [L]
    linarith
  have hterms : ∀ i ∈ Ico 2 m,
      D.r i ^ 2 * (0.415 - (A - 0.15) * D.u) ≤ D.u * D.δ i := by
    intro i hi
    have hr := D.positive i (mem_Ico.mp hi).2
    have hru : D.r i ≤ D.u := D.ordered 2 i (mem_Ico.mp hi).1 (mem_Ico.mp hi).2
    have hc := mul_le_mul_of_nonneg_left (D.charge i (mem_Ico.mp hi).2) hu.le
    have hp := mul_nonneg hr.le (sub_nonneg.mpr hru)
    dsimp [excess] at hc
    nlinarith
  have hs := sum_le_sum hterms
  rw [← sum_mul, ← mul_sum, htailr] at hs
  have hb := mul_le_mul_of_nonneg_left htailδ hu.le
  have hslack := mul_nonneg (mul_nonneg (sub_nonneg.mpr hA) hu.le) D.L_nonnegative
  nlinarith

lemma fifth_cap (hm : 5 ≤ m) : D.r 4 < 0.448 := by
  have he := D.energy_prefix hm
  norm_num [sum_range_succ] at he
  have h0 := D.sq_order (i := 0) (j := 4) (by norm_num) (by omega)
  have h1 := D.sq_order (i := 1) (j := 4) (by norm_num) (by omega)
  have h2 := D.sq_order (i := 2) (j := 4) (by norm_num) (by omega)
  have h3 := D.sq_order (i := 3) (j := 4) (by norm_num) (by omega)
  have hp := D.positive 4 (by omega)
  nlinarith

lemma tail_budget {k : ℕ} {E : ℝ} (hm : 3 + k ≤ m)
    (hE : ∀ i < k, E ≤ D.δ (3 + i)) :
    D.δ 2 + (k : ℝ) * E ≤ 1 - A := by
  have hb := D.budget_prefix hm
  rw [sum_range_add] at hb
  have hs : (k : ℝ) * E ≤ ∑ i ∈ range k, D.δ (3 + i) := by
    simpa using sum_le_sum (fun i hi => hE i (mem_range.mp hi))
  norm_num [sum_range_succ] at hb
  have h0 := D.nonnegative 0 (by omega)
  have h1 := D.nonnegative 1 (by omega)
  linarith

lemma tail_cap_from_clipping {n : ℕ} {K v R : ℝ}
    (hn : 1 ≤ n) (hm : 4 + n ≤ m) (ht : 0.066 < D.t)
    (hK : 0 ≤ K) (hd : 0 ≤ A - 0.15) (hdK : 0 ≤ A - 0.15 - K)
    (hR : 0.42 < R) (hv : v ≤ R ^ 2)
    (ha : K * v ≤ 0.415 * 0.42 - (A - 0.15 - K) * 0.42 ^ 2)
    (hb : K * v ≤ 0.415 * R - (A - 0.15 - K) * R ^ 2)
    (hend : excess A 0.066 ≤ excess A 0.448)
    (hmargin : 1 - A < K * (4 * v - 1 + (n : ℝ) * 0.066 ^ 2)
      + (n : ℝ) * excess A 0.066) : D.r 3 ≤ 0.42 := by
  by_contra h
  have hfour : 0.42 < D.r 3 := lt_of_not_ge h
  have hclip : ∀ i < 4, K * (v - D.r i ^ 2) ≤ D.δ i := by
    intro i hi
    apply clipped_charge (D.charge i (by omega)) (D.nonnegative i (by omega))
      (by have := D.ordered i 3 (by omega) (by omega); linarith) hK hdK hR hv ha hb
  have htail : ∀ i < n, excess A 0.066 ≤ D.δ (4 + i) := by
    intro i hi
    have hpos := D.positive (4 + i) (by omega)
    have hlo := D.t_le (i := 4 + i) (by omega)
    have hup := D.ordered 4 (4 + i) (by omega) (by omega)
    have h5 := D.fifth_cap (by omega)
    exact (excess_chord hd (by norm_num) (by linarith) (by linarith) le_rfl hend).trans
      (D.charge (4 + i) (by omega))
  have hδ4 := sum_le_sum (fun i hi => hclip i (mem_range.mp hi))
  have hδtail := sum_le_sum (fun i hi => htail i (mem_range.mp hi))
  have henergy := D.energy_prefix hm
  have hbudget := D.budget_prefix hm
  rw [sum_range_add] at henergy hbudget
  have htailenergy : (n : ℝ) * 0.066 ^ 2 ≤
      ∑ i ∈ range n, D.r (4 + i) ^ 2 := by
    have hterms : ∀ i ∈ range n, (0.066 : ℝ) ^ 2 ≤ D.r (4 + i) ^ 2 := by
      intro i hi
      have := D.t_le (i := 4 + i) (by have := mem_range.mp hi; omega)
      nlinarith
    simpa using sum_le_sum hterms
  norm_num [sum_range_succ] at hδ4 henergy hbudget
  have hδtail' : (n : ℝ) * excess A 0.066 ≤
      ∑ i ∈ range n, D.δ (4 + i) := by simpa using hδtail
  have henergyK := mul_le_mul_of_nonneg_left henergy hK
  have htailK := mul_le_mul_of_nonneg_left htailenergy hK
  nlinarith

lemma minimum_cap {k : ℕ} {T : ℝ} (hm : 3 + k ≤ m) (hk : 0 < k)
    (hd : 0 ≤ A - 0.15) (hT : T < 0.42) (hcap : D.r 3 ≤ 0.42)
    (hleft : 1 - A < (k : ℝ) * excess A T)
    (hright : 1 - A < (k : ℝ) * excess A 0.42) : D.t < T := by
  by_contra h
  have htT : T ≤ D.t := le_of_not_gt h
  let E := min (excess A T) (excess A 0.42)
  have hE : ∀ i < k, E ≤ D.δ (3 + i) := by
    intro i hi
    have hlo := D.t_le (i := 3 + i) (by omega)
    have hup := D.ordered 3 (3 + i) (by omega) (by omega)
    exact (excess_chord hd hT (by linarith) (by linarith)
      (min_le_left _ _) (min_le_right _ _)).trans (D.charge (3 + i) (by omega))
  have hb := D.tail_budget hm hE
  have h2 := D.nonnegative 2 (by omega)
  rcases le_total (excess A T) (excess A 0.42) with hmin | hmin
  · simp only [E, min_eq_left hmin] at hb
    linarith
  · simp only [E, min_eq_right hmin] at hb
    linarith

lemma tail_excess_budget {k : ℕ} {T : ℝ}
    (hm : 3 + k ≤ m) (hd : 0 ≤ A - 0.15)
    (ht : D.t ≤ T) (hT : T < 0.42) (hcap : D.r 3 ≤ 0.42)
    (hder : 2 * (A - 0.15) * T ≤ 0.415)
    (hend : excess A T ≤ excess A 0.42) :
    excess A D.u + (k : ℝ) * excess A D.t ≤ 1 - A := by
  have het : excess A D.t ≤ excess A 0.42 :=
    (excess_increasing hd ht hder).trans hend
  have httop : D.t < 0.42 := lt_of_le_of_lt ht hT
  have hE : ∀ i < k, excess A D.t ≤ D.δ (3 + i) := by
    intro i hi
    have hlo := D.t_le (i := 3 + i) (by omega)
    have hup := D.ordered 3 (3 + i) (by omega) (by omega)
    exact (excess_chord hd httop hlo (by linarith) le_rfl het).trans
      (D.charge (3 + i) (by omega))
  have hb := D.tail_budget hm hE
  have hc := D.charge 2 (by omega)
  dsimp [u]
  linarith

end RadiusData

lemma final_sqrt_five {t w : ℝ} (ht : 0.066 ≤ t) (hT : t ≤ 0.108)
    (hw : 0 ≤ w) (hw2 : w ^ 2 = 2.6 * t) :
    1 - 0.929 < excess 0.929 w + 2 * excess 0.929 t := by
  let l : ℝ := (1157 / 420) * t + 16267 / 70000
  have hprod := mul_nonneg (sub_nonneg.mpr ht) (sub_nonneg.mpr hT)
  have hl : 0 ≤ l := by dsimp [l]; linarith
  have hl2 : l ^ 2 ≤ 2.6 * t := by dsimp [l]; nlinarith
  have hlw : l ≤ w := (sq_le_sq₀ hl hw).mp (by rwa [hw2])
  dsimp [excess, l] at *
  nlinarith

lemma final_sqrt_six {t w : ℝ} (ht : 0.066 ≤ t) (hT : t ≤ 0.118)
    (hw : 0 ≤ w) (hw2 : w ^ 2 = 2.6 * t) :
    1 - 0.884 < excess 0.884 w + 3 * excess 0.884 t := by
  let l : ℝ := (349 / 130) * t + 7703 / 32500
  have hprod := mul_nonneg (sub_nonneg.mpr ht) (sub_nonneg.mpr hT)
  have hl : 0 ≤ l := by dsimp [l]; linarith
  have hl2 : l ^ 2 ≤ 2.6 * t := by dsimp [l]; nlinarith
  have hlw : l ≤ w := (sq_le_sq₀ hl hw).mp (by rwa [hw2])
  dsimp [excess, l] at *
  nlinarith

lemma third_large {A t u T : ℝ} {k : ℕ}
    (hd : 0 ≤ A - 0.15) (ht : 0.066 < t) (hT : t ≤ T) (hu : 0.23 < u)
    (hder : 2 * (A - 0.15) * T ≤ 0.415)
    (hbase : 1 - A < excess A 0.23 + (k : ℝ) * excess A 0.066)
    (hfinal : ∀ x w : ℝ, 0.066 ≤ x → x ≤ T → 0 ≤ w →
      w ^ 2 = 2.6 * x → 1 - A < excess A w + (k : ℝ) * excess A x)
    (hbudget : excess A u + (k : ℝ) * excess A t ≤ 1 - A) :
    2.6 * t < u ^ 2 := by
  by_contra h
  have hsmall : u ^ 2 ≤ 2.6 * t := le_of_not_gt h
  let w := Real.sqrt (2.6 * t)
  have hw : 0 ≤ w := Real.sqrt_nonneg _
  have hw2 : w ^ 2 = 2.6 * t := Real.sq_sqrt (by linarith)
  have huw : u ≤ w := (sq_le_sq₀ (by linarith) hw).mp (by rwa [hw2])
  have hgrowth : excess A 0.066 ≤ excess A t :=
    excess_increasing hd ht.le (by nlinarith)
  have hkgrowth := mul_le_mul_of_nonneg_left hgrowth (Nat.cast_nonneg k : (0 : ℝ) ≤ k)
  have heleft : 1 - A - (k : ℝ) * excess A t < excess A 0.23 := by linarith
  have heright : 1 - A - (k : ℝ) * excess A t < excess A w := by
    have := hfinal t w ht.le hT hw hw2
    linarith
  have he := excess_strict_chord hd (by linarith : 0.23 < w) hu.le huw heleft heright
  linarith

lemma final_determinant_contradiction {u t : ℝ}
    (ht : 0 < t) (hT : t < 0.12) (hu : 2.6 * t < u ^ 2)
    (hdet : 1.5 * (u ^ 2 - t ^ 2) ^ 2 ≤ 10 * (23 / 25) * t ^ 2) : False := by
  have hgap := mul_pos ht (by linarith : 0 < 0.12 - t)
  have hbase : 0 ≤ 2.48 * t := by positivity
  have hmore : 2.48 * t < u ^ 2 - t ^ 2 := by nlinarith
  have hsquare := (sq_lt_sq₀ hbase (by linarith : 0 ≤ u ^ 2 - t ^ 2)).mpr hmore
  nlinarith [sq_pos_of_pos ht]

theorem relaxed_data_obstruction {m : ℕ} {A : ℝ} (D : RadiusData m A)
    (hregime : (A = 0.929 ∧ 5 ≤ m) ∨ (A = 0.884 ∧ 6 ≤ m))
    (hdet1 : (D.u ^ 2 - D.t ^ 2) * (D.L - D.u ^ 2 - 2 * D.t ^ 2)
      ≤ 8 * (23 / 25) * D.t ^ 2)
    (hdet2 : 1.5 * (D.u ^ 2 - D.t ^ 2) ^ 2 ≤ 10 * (23 / 25) * D.t ^ 2) :
    False := by
  have hm : 5 ≤ m := by rcases hregime with h | h <;> omega
  have hA : 0.884 ≤ A := by rcases hregime with h | h <;> rcases h with ⟨rfl, _⟩ <;> norm_num
  have htpos := D.t_positive (by omega)
  have hu : 0.23 < D.u :=
    third_radius_floor (D.positive 2 (by omega)) (D.L_cap (by omega))
      (D.common_charge (by omega) hA)
  have ht : 0.066 < D.t :=
    minimum_floor htpos hu (D.L_cap (by omega)) (D.L_lower (by omega))
      (D.common_charge (by omega) hA) hdet1
  rcases hregime with ⟨rfl, hm5⟩ | ⟨rfl, hm6⟩
  · have hcap : D.r 3 ≤ 0.42 :=
      D.tail_cap_from_clipping (n := 1) (K := 0.341) (v := 0.2837) (R := 0.533)
        (by norm_num) (by omega) ht (by norm_num) (by norm_num) (by norm_num)
        (by norm_num) (by norm_num) (by norm_num) (by norm_num)
        (by norm_num [excess]) (by norm_num [excess])
    have hT : D.t < 0.108 :=
      D.minimum_cap (k := 2) (by omega) (by norm_num) (by norm_num) (by norm_num)
        hcap (by norm_num [excess]) (by norm_num [excess])
    have hb := D.tail_excess_budget (k := 2) (by omega) (by norm_num) hT.le
      (by norm_num) hcap (by norm_num) (by norm_num [excess])
    have hthird : 2.6 * D.t < D.u ^ 2 :=
      third_large (k := 2) (by norm_num) ht hT.le hu (by norm_num)
        (by norm_num [excess]) (fun _ _ => final_sqrt_five) hb
    exact final_determinant_contradiction htpos (by linarith) hthird hdet2
  · have hcap : D.r 3 ≤ 0.42 :=
      D.tail_cap_from_clipping (n := 2) (K := 0.31) (v := 0.319) (R := 0.566)
        (by norm_num) (by omega) ht (by norm_num) (by norm_num) (by norm_num)
        (by norm_num) (by norm_num) (by norm_num) (by norm_num)
        (by norm_num [excess]) (by norm_num [excess])
    have hT : D.t < 0.118 :=
      D.minimum_cap (k := 3) (by omega) (by norm_num) (by norm_num) (by norm_num)
        hcap (by norm_num [excess]) (by norm_num [excess])
    have hb := D.tail_excess_budget (k := 3) (by omega) (by norm_num) hT.le
      (by norm_num) hcap (by norm_num) (by norm_num [excess])
    have hthird : 2.6 * D.t < D.u ^ 2 :=
      third_large (k := 3) (by norm_num) ht hT.le hu (by norm_num)
        (by norm_num [excess]) (fun _ _ => final_sqrt_six) hb
    exact final_determinant_contradiction htpos (by linarith) hthird hdet2

theorem scalar_determinant_obstruction
    (m : ℕ) (hm : 5 ≤ m) (r P : ℕ → ℝ)
    (hpositive : ∀ i < m, 0 < r i)
    (hcap : ∀ i < m, r i ≤ 2 / 3)
    (hordered : ∀ i j, i ≤ j → j < m → r j ≤ r i)
    (henergy : (∑ i ∈ range m, r i ^ 2) = 1)
    (hprobability : (∑ i ∈ range m, P i) = 1)
    (hquadratic : ∀ i < m, (if m = 5 then (0.929 : ℝ) else 0.884) * r i ^ 2 ≤ P i)
    (hlinear : ∀ i < m, 0.415 * r i + 0.15 * r i ^ 2 ≤ P i)
    (hdet1 : (r 2 ^ 2 - r (m - 1) ^ 2) *
      (r 0 ^ 2 + r 1 ^ 2 - r 2 ^ 2 - 2 * r (m - 1) ^ 2)
        ≤ 8 * (23 / 25) * r (m - 1) ^ 2)
    (hdet2 : 1.5 * (r 2 ^ 2 - r (m - 1) ^ 2) ^ 2
        ≤ 10 * (23 / 25) * r (m - 1) ^ 2) : False := by
  let A : ℝ := if m = 5 then 0.929 else 0.884
  let D : RadiusData m A := {
    r := r
    δ := fun i => P i - A * r i ^ 2
    positive := hpositive
    cap := hcap
    ordered := hordered
    energy := henergy
    nonnegative := by intro i hi; exact sub_nonneg.mpr (hquadratic i hi)
    charge := by
      intro i hi
      have h := hlinear i hi
      dsimp [excess]
      nlinarith
    budget := by
      rw [sum_sub_distrib, ← mul_sum, hprobability, henergy]
      ring
  }
  have hregime : (A = 0.929 ∧ 5 ≤ m) ∨ (A = 0.884 ∧ 6 ≤ m) := by
    by_cases h : m = 5
    · exact Or.inl ⟨by simp [A, h], hm⟩
    · exact Or.inr ⟨by simp [A, h], by omega⟩
  exact relaxed_data_obstruction D hregime hdet1 hdet2

lemma manuscript_constant_bound : (3 / Real.pi) ^ 2 ≤ (23 / 25 : ℝ) := by
  have hpi := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 3.14) Real.pi_gt_d2.le 2
  rw [div_pow]
  apply (div_le_iff₀ (sq_pos_of_pos Real.pi_pos)).mpr
  norm_num at hpi ⊢
  nlinarith

theorem manuscript_obstruction
    (m : ℕ) (hm : 5 ≤ m) (r P : ℕ → ℝ)
    (hpositive : ∀ i < m, 0 < r i)
    (hcap : ∀ i < m, r i ≤ 2 / 3)
    (hordered : ∀ i j, i ≤ j → j < m → r j ≤ r i)
    (henergy : (∑ i ∈ range m, r i ^ 2) = 1)
    (hprobability : (∑ i ∈ range m, P i) = 1)
    (hquadratic : ∀ i < m, (if m = 5 then (0.929 : ℝ) else 0.884) * r i ^ 2 ≤ P i)
    (hlinear : ∀ i < m, 0.415 * r i + 0.15 * r i ^ 2 ≤ P i)
    (hdet1 : (r 2 ^ 2 - r (m - 1) ^ 2) *
      (r 0 ^ 2 + r 1 ^ 2 - r 2 ^ 2 - 2 * r (m - 1) ^ 2)
        ≤ 8 * (3 / Real.pi) ^ 2 * r (m - 1) ^ 2)
    (hdet2 : 1.5 * (r 2 ^ 2 - r (m - 1) ^ 2) ^ 2
        ≤ 10 * (3 / Real.pi) ^ 2 * r (m - 1) ^ 2) : False := by
  have hq := mul_le_mul_of_nonneg_right manuscript_constant_bound (sq_nonneg (r (m - 1)))
  apply scalar_determinant_obstruction m hm r P hpositive hcap hordered henergy
    hprobability hquadratic hlinear
  · nlinarith
  · nlinarith

#print axioms scalar_determinant_obstruction
#print axioms manuscript_obstruction

end GaussianPropellerAudit
