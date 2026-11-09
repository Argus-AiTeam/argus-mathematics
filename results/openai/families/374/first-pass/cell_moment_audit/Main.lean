import Mathlib

open scoped BigOperators

namespace CellMomentAudit

variable {I J D : Type*} [Fintype I] [Fintype J] [Fintype D]

def normSq (x : D → ℝ) : ℝ := ∑ k, (x k) ^ 2

def avg (p f : J → ℝ) : ℝ := ∑ j, p j * f j

theorem normSq_nonneg (x : D → ℝ) : 0 ≤ normSq x :=
  Finset.sum_nonneg fun _ _ => sq_nonneg _

theorem avg_const (p : J → ℝ) (hp : ∑ j, p j = 1) (c : ℝ) :
    avg p (fun _ => c) = c := by
  simp [avg, ← Finset.sum_mul, hp]

theorem avg_add (p f g : J → ℝ) :
    avg p (fun j => f j + g j) = avg p f + avg p g := by
  simp [avg, mul_add, Finset.sum_add_distrib]

theorem avg_sub (p f g : J → ℝ) :
    avg p (fun j => f j - g j) = avg p f - avg p g := by
  simp [avg, mul_sub, Finset.sum_sub_distrib]

theorem avg_mul (p f : J → ℝ) (c : ℝ) :
    avg p (fun j => c * f j) = c * avg p f := by
  simp only [avg, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem avg_div (p f : J → ℝ) (c : ℝ) :
    avg p (fun j => f j / c) = avg p f / c := by
  simp [avg, Finset.sum_div, mul_div_assoc]

theorem weighted_jensen_scalar (p f : J → ℝ)
    (hp : ∀ j, 0 ≤ p j) (hs : ∑ j, p j = 1) :
    (avg p f) ^ 2 ≤ avg p (fun j => (f j) ^ 2) := by
  have H := Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul
    (Finset.univ : Finset J)
    (r := fun j => p j * f j)
    (f := p) (g := fun j => p j * (f j) ^ 2)
    (fun j _ => hp j)
    (fun j _ => mul_nonneg (hp j) (sq_nonneg (f j)))
    (fun j _ => le_of_eq (by ring))
  simpa [avg, hs] using H

theorem weighted_jensen_vector (p : J → ℝ) (x : J → D → ℝ)
    (hp : ∀ j, 0 ≤ p j) (hs : ∑ j, p j = 1) :
    normSq (fun k => avg p (fun j => x j k)) ≤
      avg p (fun j => normSq (x j)) := by
  calc
    _ ≤ ∑ k, avg p (fun j => (x j k) ^ 2) :=
      Finset.sum_le_sum fun k _ => weighted_jensen_scalar p _ hp hs
    _ = _ := by
      simp only [avg, normSq, Finset.mul_sum]
      rw [Finset.sum_comm]

theorem midpoint_norm_identity (x z : D → ℝ) :
    normSq (fun k => (x k + z k) / 2) =
      (normSq x + normSq z) / 2 -
        normSq (fun k => x k - z k) / 4 := by
  calc
    _ = ∑ k, ((x k) ^ 2 / 2 + (z k) ^ 2 / 2 -
        (x k - z k) ^ 2 / 4) := by
      apply Finset.sum_congr rfl
      intro k _
      ring
    _ = _ := by
      simp [normSq, Finset.sum_add_distrib, Finset.sum_sub_distrib,
        Finset.sum_div, add_div]

theorem quadratic_identity (a b R2 : ℝ) (hab : a + b ≠ 0)
    (x z : D → ℝ) :
    normSq (fun k => a * x k - b * z k) / ((a + b) / 2) +
        2 * a * (R2 - normSq x) + 2 * b * (R2 - normSq z) -
        4 * a * b / ((a + b) / 2) *
          (R2 - normSq (fun k => (x k + z k) / 2)) =
      ((a - b) ^ 2 / ((a + b) / 2)) * R2 := by
  have H : normSq (fun k => a * x k - b * z k) =
      (a + b) * a * normSq x + (a + b) * b * normSq z -
        4 * a * b * normSq (fun k => (x k + z k) / 2) := by
    calc
      _ = ∑ k, ((a + b) * a * (x k) ^ 2 +
          (a + b) * b * (z k) ^ 2 -
          4 * a * b * ((x k + z k) / 2) ^ 2) := by
        apply Finset.sum_congr rfl
        intro k _
        ring
      _ = _ := by
        simp [normSq, Finset.sum_add_distrib, Finset.sum_sub_distrib,
          Finset.mul_sum]
  rw [H]
  field_simp [hab]
  ring

theorem geometric_mean_coefficient (a b g : ℝ)
    (ha : 0 < a) (hb : 0 < b) (hg : 0 ≤ g) (hgs : g ^ 2 = a * b) :
    a * b / ((a + b) / 2) ≤ g := by
  have hh : 0 < (a + b) / 2 := by linarith
  have hle : g ≤ (a + b) / 2 := by
    nlinarith [sq_nonneg (a - b)]
  apply (div_le_iff₀ hh).mpr
  nlinarith [mul_le_mul_of_nonneg_left hle hg]

theorem sample_energy_bound (a b g R2 : ℝ) (x z : D → ℝ)
    (ha : 0 < a) (hb : 0 < b) (hg : 0 ≤ g) (hgs : g ^ 2 = a * b)
    (hx : normSq x ≤ R2) (hz : normSq z ≤ R2) :
    normSq (fun k => a * x k - b * z k) / ((a + b) / 2) ≤
      R2 * ((a - b) ^ 2 / ((a + b) / 2)) +
        4 * g * (R2 - normSq (fun k => (x k + z k) / 2)) -
        2 * a * (R2 - normSq x) - 2 * b * (R2 - normSq z) := by
  have hm : 0 ≤ R2 - normSq (fun k => (x k + z k) / 2) := by
    rw [midpoint_norm_identity]
    have hn := normSq_nonneg (fun k => x k - z k)
    linarith
  have hc := geometric_mean_coefficient a b g ha hb hg hgs
  have H := quadratic_identity a b R2 (by linarith : a + b ≠ 0) x z
  have Hc := mul_le_mul_of_nonneg_right hc hm
  simp only [div_eq_mul_inv] at H Hc ⊢
  nlinarith only [H, Hc]

theorem finite_midpoint_contraction
    (a b g : I → ℝ) (p : I → J → ℝ) (x z : I → J → D → ℝ) (R2 : ℝ)
    (ha : ∀ i, 0 < a i) (hb : ∀ i, 0 < b i)
    (hg : ∀ i, 0 ≤ g i) (hgs : ∀ i, (g i) ^ 2 = a i * b i)
    (hp : ∀ i j, 0 ≤ p i j) (hs : ∀ i, ∑ j, p i j = 1)
    (hx : ∀ i j, normSq (x i j) ≤ R2)
    (hz : ∀ i j, normSq (z i j) ≤ R2)
    (hmid :
      (∑ i, g i * avg (p i)
        (fun j => R2 - normSq (fun k => (x i j k + z i j k) / 2))) ≤
      (∑ i, (a i * avg (p i) (fun j => R2 - normSq (x i j)) +
        b i * avg (p i) (fun j => R2 - normSq (z i j)))) / 2) :
    (∑ i, normSq (fun k => avg (p i)
        (fun j => a i * x i j k - b i * z i j k)) / ((a i + b i) / 2)) ≤
      R2 * ∑ i, (a i - b i) ^ 2 / ((a i + b i) / 2) := by
  have Hcell (i : I) :
      normSq (fun k => avg (p i)
          (fun j => a i * x i j k - b i * z i j k)) / ((a i + b i) / 2) ≤
        R2 * ((a i - b i) ^ 2 / ((a i + b i) / 2)) +
          4 * (g i * avg (p i)
            (fun j => R2 - normSq (fun k => (x i j k + z i j k) / 2))) -
          2 * (a i * avg (p i) (fun j => R2 - normSq (x i j))) -
          2 * (b i * avg (p i) (fun j => R2 - normSq (z i j))) := by
    have hh : 0 < (a i + b i) / 2 := by linarith [ha i, hb i]
    calc
      _ ≤ avg (p i) (fun j => normSq
          (fun k => a i * x i j k - b i * z i j k)) / ((a i + b i) / 2) :=
        div_le_div_of_nonneg_right
          (weighted_jensen_vector _ _ (hp i) (hs i)) hh.le
      _ = avg (p i) (fun j => normSq
          (fun k => a i * x i j k - b i * z i j k) / ((a i + b i) / 2)) :=
        (avg_div _ _ _).symm
      _ ≤ avg (p i) (fun j =>
          R2 * ((a i - b i) ^ 2 / ((a i + b i) / 2)) +
            4 * g i * (R2 - normSq (fun k => (x i j k + z i j k) / 2)) -
            2 * a i * (R2 - normSq (x i j)) -
            2 * b i * (R2 - normSq (z i j))) := by
        exact Finset.sum_le_sum fun j _ =>
          mul_le_mul_of_nonneg_left
            (sample_energy_bound _ _ _ _ _ _ (ha i) (hb i) (hg i)
              (hgs i) (hx i j) (hz i j)) (hp i j)
      _ = _ := by
        simp only [avg_sub, avg_add, avg_mul, avg_const _ (hs i)]
        ring
  calc
    _ ≤ ∑ i, (R2 * ((a i - b i) ^ 2 / ((a i + b i) / 2)) +
        4 * (g i * avg (p i)
          (fun j => R2 - normSq (fun k => (x i j k + z i j k) / 2))) -
        2 * (a i * avg (p i) (fun j => R2 - normSq (x i j))) -
        2 * (b i * avg (p i) (fun j => R2 - normSq (z i j)))) :=
      Finset.sum_le_sum fun i _ => Hcell i
    _ = R2 * (∑ i, (a i - b i) ^ 2 / ((a i + b i) / 2)) +
        4 * (∑ i, g i * avg (p i)
          (fun j => R2 - normSq (fun k => (x i j k + z i j k) / 2))) -
        2 * (∑ i, (a i * avg (p i) (fun j => R2 - normSq (x i j)) +
          b i * avg (p i) (fun j => R2 - normSq (z i j)))) := by
      simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
        ← Finset.mul_sum]
      ring
    _ ≤ _ := by linarith

def lap (g : I → I → ℝ) (q : I → ℝ) (i : I) : ℝ :=
  ∑ j, g i j * (q i - q j)

theorem symmetric_green (g : I → I → ℝ)
    (hg : ∀ i j, g i j = g j i) (q r : I → ℝ) :
    (∑ i, q i * lap g r i) = ∑ i, r i * lap g q i := by
  have Hcross : (∑ i, ∑ j, q i * g i j * r j) =
      ∑ i, ∑ j, r i * g i j * q j := by
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    rw [hg j i]
    ring
  simp only [lap, Finset.mul_sum, mul_sub, Finset.sum_sub_distrib]
  have Hdiag : (∑ i, ∑ j, q i * (g i j * r i)) =
      ∑ i, ∑ j, r i * (g i j * q i) := by
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    ring
  have Hcross' : (∑ i, ∑ j, q i * (g i j * r j)) =
      ∑ i, ∑ j, r i * (g i j * q j) := by
    simpa only [mul_assoc] using Hcross
  linarith

theorem face_duality (g : I → I → ℝ) (b : D → I → I → ℝ)
    (hg : ∀ i j, g i j = g j i)
    (hb : ∀ k i j, b k i j = b k j i)
    (q r : I → ℝ) (v : I → D → ℝ)
    (hfixed : ∀ i, lap g r i + ∑ k, lap (b k) (fun j => v j k) i = 0) :
    (∑ i, r i * lap g q i) =
      -(∑ i, ∑ k, v i k * lap (b k) q i) := by
  have Hzero : (∑ i, q i * lap g r i) +
      (∑ i, ∑ k, q i * lap (b k) (fun j => v j k) i) = 0 := by
    calc
      _ = ∑ i, q i * (lap g r i + ∑ k, lap (b k) (fun j => v j k) i) := by
        simp [mul_add, Finset.mul_sum, Finset.sum_add_distrib]
      _ = 0 := by simp [hfixed]
  have Hsite : (∑ i, ∑ k, q i * lap (b k) (fun j => v j k) i) =
      ∑ i, ∑ k, v i k * lap (b k) q i := by
    calc
      _ = ∑ k, ∑ i, q i * lap (b k) (fun j => v j k) i :=
        Finset.sum_comm
      _ = ∑ k, ∑ i, v i k * lap (b k) q i := by
        apply Finset.sum_congr rfl
        intro k _
        exact symmetric_green (b k) (hb k) q (fun i => v i k)
      _ = _ := Finset.sum_comm
  rw [symmetric_green g hg q r, Hsite] at Hzero
  linarith

theorem weighted_cauchy (m f z : J → ℝ) (hm : ∀ j, 0 < m j) :
    (∑ j, f j * z j) ^ 2 ≤
      (∑ j, m j * (f j) ^ 2) * ∑ j, (z j) ^ 2 / m j := by
  exact Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul
    (Finset.univ : Finset J)
    (fun j _ => mul_nonneg (hm j).le (sq_nonneg _))
    (fun j _ => div_nonneg (sq_nonneg _) (hm j).le)
    (fun j _ => le_of_eq (by field_simp [(hm j).ne']))

theorem intercept_energy_transfer (m r : I → ℝ) (v z : I → D → ℝ)
    (R2 : ℝ) (hR2 : 0 ≤ R2) (hm : ∀ i, 0 < m i)
    (hdual : (∑ i, m i * (r i) ^ 2) = -(∑ i, ∑ k, v i k * z i k))
    (hmoment : (∑ i, normSq (z i) / m i) ≤ R2 * ∑ i, m i * (r i) ^ 2) :
    (∑ i, m i * (r i) ^ 2) ≤ R2 * ∑ i, m i * normSq (v i) := by
  have HC := weighted_cauchy
    (fun t : I × D => m t.1) (fun t => v t.1 t.2)
    (fun t => z t.1 t.2) (fun t => hm t.1)
  have HC' :
      (∑ i, ∑ k, v i k * z i k) ^ 2 ≤
        (∑ i, m i * normSq (v i)) * (∑ i, normSq (z i) / m i) := by
    simpa [Fintype.sum_prod_type, normSq, Finset.mul_sum, Finset.sum_div] using HC
  have HV : 0 ≤ ∑ i, m i * normSq (v i) :=
    Finset.sum_nonneg fun i _ => mul_nonneg (hm i).le (normSq_nonneg _)
  have HE : 0 ≤ ∑ i, m i * (r i) ^ 2 :=
    Finset.sum_nonneg fun i _ => mul_nonneg (hm i).le (sq_nonneg _)
  have Hbound := mul_le_mul_of_nonneg_left hmoment HV
  have Hsq :
      (∑ i, m i * (r i) ^ 2) ^ 2 ≤
        (∑ i, m i * normSq (v i)) * (R2 * ∑ i, m i * (r i) ^ 2) := by
    nlinarith [HC', Hbound, hdual]
  by_cases Hzero : (∑ i, m i * (r i) ^ 2) = 0
  · rw [Hzero]
    exact mul_nonneg hR2 HV
  · have Hpos : 0 < ∑ i, m i * (r i) ^ 2 := lt_of_le_of_ne HE (Ne.symm Hzero)
    nlinarith

theorem fixed_mass_intercept_energy
    (g : I → I → ℝ) (b : D → I → I → ℝ)
    (hg : ∀ i j, g i j = g j i)
    (hb : ∀ k i j, b k i j = b k j i)
    (m q r : I → ℝ) (v : I → D → ℝ) (R2 : ℝ) (hR2 : 0 ≤ R2)
    (hm : ∀ i, 0 < m i)
    (hfixed : ∀ i, lap g r i + ∑ k, lap (b k) (fun j => v j k) i = 0)
    (hsolve : ∀ i, lap g q i = m i * r i)
    (hmoment : (∑ i, normSq (fun k => lap (b k) q i) / m i) ≤
      R2 * ∑ i, (lap g q i) ^ 2 / m i) :
    (∑ i, m i * (r i) ^ 2) ≤ R2 * ∑ i, m i * normSq (v i) := by
  have Hdual := face_duality g b hg hb q r v hfixed
  have Henergy : (∑ i, r i * lap g q i) = ∑ i, m i * (r i) ^ 2 := by
    apply Finset.sum_congr rfl
    intro i _
    rw [hsolve i]
    ring
  have Hmass : (∑ i, (lap g q i) ^ 2 / m i) = ∑ i, m i * (r i) ^ 2 := by
    apply Finset.sum_congr rfl
    intro i _
    rw [hsolve i]
    field_simp [(hm i).ne']
  apply intercept_energy_transfer m r v (fun i k => lap (b k) q i) R2 hR2 hm
  · rwa [Henergy] at Hdual
  · rwa [Hmass] at hmoment

end CellMomentAudit
