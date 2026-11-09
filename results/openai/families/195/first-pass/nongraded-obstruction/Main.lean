import Mathlib

open scoped BigOperators

namespace NongradedObstruction

theorem layer_quadratic_nonneg (N : ℝ) (n : ℕ → ℝ)
    (lo : ∀ j, 0 ≤ n j) (hi : ∀ j, n j ≤ N) (k : ℕ) :
    0 ≤ N * (∑ j ∈ Finset.range k, (2 * (j : ℝ) + 1) * n j) -
      (∑ j ∈ Finset.range k, n j) ^ 2 := by
  induction k with
  | zero => simp
  | succ k ih =>
    have hs : (∑ j ∈ Finset.range k, n j) ≤ (k : ℝ) * N := by
      calc
        (∑ j ∈ Finset.range k, n j) ≤ ∑ _j ∈ Finset.range k, N :=
          Finset.sum_le_sum (fun j _ => hi j)
        _ = (k : ℝ) * N := by simp
    have hp : 0 ≤ n k *
        ((2 * (k : ℝ) + 1) * N - 2 * (∑ j ∈ Finset.range k, n j) - n k) :=
      mul_nonneg (lo k) (by nlinarith [hi k])
    simp only [Finset.sum_range_succ]
    nlinarith

theorem layer_chern_nonneg (N : ℝ) (n : ℕ → ℝ)
    (lo : ∀ j, 0 ≤ n j) (hi : ∀ j, n j ≤ N) (k : ℕ)
    (d : ℝ) (hd : (∑ j ∈ Finset.range k, (2 * (j : ℝ) + 1) * n j) ≤ d)
    (hN : 0 ≤ N) :
    0 ≤ N * d - (∑ j ∈ Finset.range k, n j) ^ 2 := by
  have h := layer_quadratic_nonneg N n lo hi k
  have hmul := mul_le_mul_of_nonneg_left hd hN
  linarith

theorem centered_sum {ι : Type*} [Fintype ι] (w x : ι → ℝ) (a : ℝ) :
    (∑ i, w i * (x i - a) ^ 2) =
      (∑ i, w i * x i ^ 2) - 2 * a * (∑ i, w i * x i) +
        a ^ 2 * (∑ i, w i) := by
  calc
    (∑ i, w i * (x i - a) ^ 2) =
        ∑ i, (w i * x i ^ 2 - (2 * a) * (w i * x i) + a ^ 2 * w i) := by
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = _ := by
      simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
        ← Finset.mul_sum]

theorem variance_identity {ι : Type*} [Fintype ι] (w x : ι → ℝ)
    (hw : (∑ i, w i) = 1) :
    (∑ i, w i * (x i - ∑ j, w j * x j) ^ 2) =
      (∑ i, w i * x i ^ 2) - (∑ i, w i * x i) ^ 2 := by
  rw [centered_sum, hw]
  ring

theorem weighted_variance_bound {ι : Type*} [Fintype ι] (w x : ι → ℝ)
    (hw0 : ∀ i, 0 ≤ w i) (hw : (∑ i, w i) = 1) (a b : ℝ)
    (hlo : ∀ i, a ≤ x i) (hhi : ∀ i, x i ≤ b) :
    (∑ i, w i * (x i - ∑ j, w j * x j) ^ 2) ≤ (b - a) ^ 2 / 4 := by
  have hp : ∀ i, (x i - (a + b) / 2) ^ 2 ≤ (b - a) ^ 2 / 4 := by
    intro i
    have h := mul_nonneg (sub_nonneg.mpr (hlo i)) (sub_nonneg.mpr (hhi i))
    nlinarith
  have hs : (∑ i, w i * (x i - (a + b) / 2) ^ 2) ≤ (b - a) ^ 2 / 4 := by
    calc
      (∑ i, w i * (x i - (a + b) / 2) ^ 2) ≤
          ∑ i, w i * ((b - a) ^ 2 / 4) :=
        Finset.sum_le_sum (fun i _ => mul_le_mul_of_nonneg_left (hp i) (hw0 i))
      _ = (b - a) ^ 2 / 4 := by rw [← Finset.sum_mul, hw]; ring
  have hc := centered_sum w x ((a + b) / 2)
  have hv := variance_identity w x hw
  rw [hw] at hc
  nlinarith [sq_nonneg ((∑ i, w i * x i) - (a + b) / 2)]

theorem weighted_variance_strict {ι : Type*} [Fintype ι] (w x : ι → ℝ)
    (hw0 : ∀ i, 0 ≤ w i) (hw : (∑ i, w i) = 1) (a b : ℝ)
    (hlo : ∀ i, a ≤ x i) (hhi : ∀ i, x i ≤ b)
    (hab : a ≤ b) (hwidth : b - a < 1) :
    (∑ i, w i * (x i - ∑ j, w j * x j) ^ 2) < 1 / 4 := by
  have h := weighted_variance_bound w x hw0 hw a b hlo hhi
  have hp : 0 < (1 - (b - a)) * (1 + (b - a)) :=
    mul_pos (by linarith) (by linarith)
  nlinarith

theorem mixture_identity {ι : Type*} [Fintype ι] (w m q : ι → ℝ)
    (hw : (∑ i, w i) = 1) :
    2 * (∑ i, w i * q i) - (∑ i, w i * m i) ^ 2 =
      (∑ i, w i * (2 * q i - m i ^ 2)) +
        ∑ i, w i * (m i - ∑ j, w j * m j) ^ 2 := by
  have hv := variance_identity w m hw
  have ht : (∑ i, w i * (2 * q i - m i ^ 2)) =
      2 * (∑ i, w i * q i) - (∑ i, w i * m i ^ 2) := by
    calc
      (∑ i, w i * (2 * q i - m i ^ 2)) =
          ∑ i, (2 * (w i * q i) - w i * m i ^ 2) := by
        apply Finset.sum_congr rfl
        intro i _
        ring
      _ = _ := by simp only [Finset.sum_sub_distrib, ← Finset.mul_sum]
  rw [ht, hv]
  ring

theorem potential_increment (r : ℝ) (p : ℕ → ℝ)
    (hstep : ∀ j, p j + 1 / r ≤ p (j + 1)) (k : ℕ) :
    p 0 + (k : ℝ) / r ≤ p k := by
  induction k with
  | zero => simp
  | succ k ih =>
    have hc : p 0 + ((k + 1 : ℕ) : ℝ) / r =
        (p 0 + (k : ℝ) / r) + 1 / r := by push_cast; ring
    rw [hc]
    linarith [hstep k]

theorem no_infinite_modifications (r U : ℝ) (hr : 0 < r) :
    ¬ ∃ p : ℕ → ℝ, (∀ j, p j + 1 / r ≤ p (j + 1)) ∧ (∀ j, p j ≤ U) := by
  rintro ⟨p, hstep, hbound⟩
  obtain ⟨k, hk⟩ := exists_nat_gt (r * (U - p 0))
  have h := potential_increment r p hstep k
  have hd : (k : ℝ) / r ≤ U - p 0 := by linarith [hbound k]
  have hm := (div_le_iff₀ hr).mp hd
  nlinarith

theorem rr_variance_identity (chi h u mu k ch gk : ℝ) (hh : h ≠ 0) (hu : u ≠ 0) :
    let m := mu - k / (2 * h) - 3 / 2
    let q := chi / h + ch / (u * h) - gk / (2 * u * h) - 1 - 3 * m / 2
    2 * q - m ^ 2 = 1 / 4 + 2 * chi / h +
      (2 * ch / u - gk / u) / h - (mu - k / (2 * h)) ^ 2 := by
  dsimp
  field_simp
  ring

theorem noether_identity (chi h K2 c2 : ℝ) (hh : h ≠ 0)
    (hchi : 12 * chi = K2 + c2) :
    1 / 4 + 2 * chi / h - K2 / (4 * h) =
      1 / 4 - (K2 - 2 * c2) / (12 * h) := by
  field_simp
  nlinarith [hchi]

theorem factor_upper_bound (h chi K2 c2 e s t z k : ℝ) (hh : 0 < h)
    (hchi : 12 * chi = K2 + c2) (hbog : e ≤ s)
    (hhodge : h * (s - t + K2 / 4) ≤ (z - k / 2) ^ 2) :
    1 / 4 + 2 * chi / h + (e - t) / h - (z / h - k / (2 * h)) ^ 2 ≤
      1 / 4 - (K2 - 2 * c2) / (12 * h) := by
  have hb : h * (e - t + K2 / 4) ≤ h * (s - t + K2 / 4) := by
    have hp := mul_nonneg (le_of_lt hh) (sub_nonneg.mpr hbog)
    nlinarith
  have hn : h * (e - t + K2 / 4) - (z - k / 2) ^ 2 ≤ 0 := by
    linarith
  have he :
      (1 / 4 + 2 * chi / h + (e - t) / h - (z / h - k / (2 * h)) ^ 2) -
        (1 / 4 + 2 * chi / h - K2 / (4 * h)) =
      (h * (e - t + K2 / 4) - (z - k / 2) ^ 2) / h ^ 2 := by
    field_simp
    ring
  have hd := div_nonpos_of_nonpos_of_nonneg hn (sq_nonneg h)
  have hc :
      1 / 4 + 2 * chi / h + (e - t) / h - (z / h - k / (2 * h)) ^ 2 ≤
        1 / 4 + 2 * chi / h - K2 / (4 * h) := by linarith
  rw [noether_identity chi h K2 c2 (ne_of_gt hh) hchi] at hc
  exact hc

theorem obstruction_assembly (h c v variance : ℝ) (hh : 0 < h)
    (hv : 0 ≤ v) (hu : v ≤ 1 / 4 - c / (12 * h) + variance) :
    c ≤ (3 + 12 * variance) * h := by
  have hd : c / (12 * h) ≤ 1 / 4 + variance := by linarith
  have hm := (div_le_iff₀ (by positivity : 0 < 12 * h)).mp hd
  nlinarith

theorem strict_obstruction_assembly (h c v variance : ℝ) (hh : 0 < h)
    (hv : 0 ≤ v) (hu : v ≤ 1 / 4 - c / (12 * h) + variance)
    (hvariance : variance < 1 / 4) :
    c < 6 * h := by
  have hd : c / (12 * h) < 1 / 2 := by linarith
  have hm := (div_lt_iff₀ (by positivity : 0 < 12 * h)).mp hd
  nlinarith

theorem full_numeric_obstruction {ι : Type*} [Fintype ι]
    (N h c d : ℝ) (n : ℕ → ℝ) (layers : ℕ) (w m q : ι → ℝ)
    (hN : 0 < N) (hh : 0 < h)
    (nlo : ∀ j, 0 ≤ n j) (nhi : ∀ j, n j ≤ N)
    (hd : (∑ j ∈ Finset.range layers, (2 * (j : ℝ) + 1) * n j) ≤ d)
    (hw0 : ∀ i, 0 ≤ w i) (hw : (∑ i, w i) = 1)
    (hc1 : (∑ i, w i * m i) = (∑ j ∈ Finset.range layers, n j) / N)
    (hc2 : 2 * (∑ i, w i * q i) = d / N)
    (a b : ℝ) (hlo : ∀ i, a ≤ m i) (hhi : ∀ i, m i ≤ b)
    (hab : a ≤ b) (hwidth : b - a < 1)
    (hfactor : ∀ i, 2 * q i - m i ^ 2 ≤ 1 / 4 - c / (12 * h)) :
    c < 6 * h := by
  have hn := layer_chern_nonneg N n nlo nhi layers d hd (le_of_lt hN)
  have he : d / N - ((∑ j ∈ Finset.range layers, n j) / N) ^ 2 =
      (N * d - (∑ j ∈ Finset.range layers, n j) ^ 2) / N ^ 2 := by
    field_simp
  have hv : 0 ≤ 2 * (∑ i, w i * q i) - (∑ i, w i * m i) ^ 2 := by
    rw [hc2, hc1, he]
    exact div_nonneg hn (sq_nonneg N)
  have hf : (∑ i, w i * (2 * q i - m i ^ 2)) ≤ 1 / 4 - c / (12 * h) := by
    calc
      (∑ i, w i * (2 * q i - m i ^ 2)) ≤
          ∑ i, w i * (1 / 4 - c / (12 * h)) :=
        Finset.sum_le_sum (fun i _ =>
          mul_le_mul_of_nonneg_left (hfactor i) (hw0 i))
      _ = 1 / 4 - c / (12 * h) := by rw [← Finset.sum_mul, hw]; ring
  have hm := mixture_identity w m q hw
  have hvar := weighted_variance_strict w m hw0 hw a b hlo hhi hab hwidth
  exact strict_obstruction_assembly h c
    (2 * (∑ i, w i * q i) - (∑ i, w i * m i) ^ 2)
    (∑ i, w i * (m i - ∑ j, w j * m j) ^ 2) hh hv (by linarith) hvar

end NongradedObstruction
