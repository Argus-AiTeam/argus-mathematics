import Mathlib

open scoped BigOperators

namespace CubicFlatness

def phi (x : ℝ) : ℝ := 3 * x ^ 2 - 2 * x ^ 3

def energy {ι : Type*} (s : Finset ι) (w x : ι → ℝ) : ℝ :=
  ∑ i ∈ s, w i * x i ^ 2

def pairing {ι : Type*} (s : Finset ι) (w x y : ι → ℝ) : ℝ :=
  ∑ i ∈ s, w i * x i * y i

theorem phi_reflection (x : ℝ) : phi (1 - x) = 1 - phi x := by
  unfold phi
  ring

theorem scalar_zero (x y : ℝ)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) (hy0 : 0 ≤ y) (hy1 : y ≤ 1) :
    |phi y - phi x| ≤ 3 * |y ^ 2 - x ^ 2| := by
  let k := 3 * (x + y) - 2 * (x ^ 2 + x * y + y ^ 2)
  have hk : 0 ≤ k := by
    dsimp [k]
    nlinarith [mul_nonneg hx0 (sub_nonneg.mpr hx1),
      mul_nonneg hy0 (sub_nonneg.mpr hy1),
      mul_nonneg hx0 (sub_nonneg.mpr hy1),
      mul_nonneg hy0 (sub_nonneg.mpr hx1)]
  have hk3 : k ≤ 3 * (x + y) := by
    dsimp [k]
    nlinarith [sq_nonneg x, sq_nonneg y, mul_nonneg hx0 hy0]
  calc
    |phi y - phi x| = |y - x| * k := by
      rw [show phi y - phi x = (y - x) * k by dsimp [phi, k]; ring,
        abs_mul, abs_of_nonneg hk]
    _ ≤ |y - x| * (3 * (x + y)) :=
      mul_le_mul_of_nonneg_left hk3 (abs_nonneg _)
    _ = 3 * |y ^ 2 - x ^ 2| := by
      rw [show y ^ 2 - x ^ 2 = (y - x) * (x + y) by ring,
        abs_mul, abs_of_nonneg (add_nonneg hx0 hy0)]
      ring

theorem scalar_bit (x y e : ℝ)
    (hx : 0 ≤ x ∧ x ≤ 1) (hy : 0 ≤ y ∧ y ≤ 1)
    (he : e = 0 ∨ e = 1) :
    |phi y - phi x| ≤ 3 * |(y - e) ^ 2 - (x - e) ^ 2| := by
  rcases he with rfl | rfl
  · simpa only [sub_zero] using scalar_zero x y hx.1 hx.2 hy.1 hy.2
  · have h := scalar_zero (1 - x) (1 - y)
      (by linarith [hx.2]) (by linarith [hx.1])
      (by linarith [hy.2]) (by linarith [hy.1])
    rw [phi_reflection, phi_reflection] at h
    have ha : |(1 - phi y) - (1 - phi x)| = |phi y - phi x| := by
      rw [show (1 - phi y) - (1 - phi x) = -(phi y - phi x) by ring, abs_neg]
    have hb : (1 - y) ^ 2 - (1 - x) ^ 2 = (y - 1) ^ 2 - (x - 1) ^ 2 := by
      ring
    rwa [ha, hb] at h

theorem gap_sos (A B C : ℝ) :
    2 * (B ^ 2 + 3 * A ^ 2 - 4 * A * C) -
        (A + B - 2 * C) * (A + B + 2 * C) =
      (B - A) ^ 2 + 4 * (A - C) ^ 2 := by
  ring

theorem weighted_cauchy {ι : Type*} (s : Finset ι) (w a b : ι → ℝ)
    (hw : ∀ i ∈ s, 0 ≤ w i) :
    (∑ i ∈ s, w i * |b i ^ 2 - a i ^ 2|) ^ 2 ≤
      (∑ i ∈ s, w i * (b i - a i) ^ 2) *
        (∑ i ∈ s, w i * (b i + a i) ^ 2) := by
  apply Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul s
    (fun i hi => mul_nonneg (hw i hi) (sq_nonneg _))
    (fun i hi => mul_nonneg (hw i hi) (sq_nonneg _))
  intro i hi
  have h : (w i * |b i ^ 2 - a i ^ 2|) ^ 2 =
      (w i * (b i - a i) ^ 2) * (w i * (b i + a i) ^ 2) := by
    rw [mul_pow, sq_abs]
    ring
  exact h.le

theorem energy_sub {ι : Type*} (s : Finset ι) (w a b : ι → ℝ) :
    (∑ i ∈ s, w i * (b i - a i) ^ 2) =
      energy s w a + energy s w b - 2 * pairing s w a b := by
  calc
    _ = ∑ i ∈ s, (w i * a i ^ 2 + w i * b i ^ 2 - 2 * (w i * a i * b i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      ring
    _ = _ := by
      simp only [energy, pairing, Finset.sum_sub_distrib,
        Finset.sum_add_distrib, Finset.mul_sum]

theorem energy_add {ι : Type*} (s : Finset ι) (w a b : ι → ℝ) :
    (∑ i ∈ s, w i * (b i + a i) ^ 2) =
      energy s w a + energy s w b + 2 * pairing s w a b := by
  calc
    _ = ∑ i ∈ s, (w i * a i ^ 2 + w i * b i ^ 2 + 2 * (w i * a i * b i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      ring
    _ = _ := by
      simp only [energy, pairing, Finset.sum_add_distrib, Finset.mul_sum]

theorem quadratic_flatness {ι : Type*} (s : Finset ι) (w a b : ι → ℝ)
    (hw : ∀ i ∈ s, 0 ≤ w i) :
    (∑ i ∈ s, w i * |b i ^ 2 - a i ^ 2|) ^ 2 ≤
      2 * ((energy s w b) ^ 2 + 3 * (energy s w a) ^ 2 -
        4 * energy s w a * pairing s w a b) := by
  have hcs := weighted_cauchy s w a b hw
  rw [energy_sub, energy_add] at hcs
  have hgap := gap_sos (energy s w a) (energy s w b) (pairing s w a b)
  nlinarith [sq_nonneg (energy s w b - energy s w a),
    sq_nonneg (energy s w a - pairing s w a b)]

theorem flat18 {ι : Type*} (s : Finset ι) (w u v e : ι → ℝ)
    (hw : ∀ i ∈ s, 0 ≤ w i)
    (hu : ∀ i ∈ s, 0 ≤ u i ∧ u i ≤ 1)
    (hv : ∀ i ∈ s, 0 ≤ v i ∧ v i ≤ 1)
    (he : ∀ i ∈ s, e i = 0 ∨ e i = 1) :
    (∑ i ∈ s, w i * |phi (v i) - phi (u i)|) ^ 2 ≤
      18 * ((energy s w (fun i => v i - e i)) ^ 2 -
        (energy s w (fun i => u i - e i)) ^ 2 -
        4 * energy s w (fun i => u i - e i) *
          pairing s w (fun i => u i - e i) (fun i => v i - u i)) := by
  let a := fun i => u i - e i
  let b := fun i => v i - e i
  let L := ∑ i ∈ s, w i * |b i ^ 2 - a i ^ 2|
  let V := ∑ i ∈ s, w i * |phi (v i) - phi (u i)|
  have hL : 0 ≤ L := Finset.sum_nonneg fun i hi =>
    mul_nonneg (hw i hi) (abs_nonneg _)
  have hV : 0 ≤ V := Finset.sum_nonneg fun i hi =>
    mul_nonneg (hw i hi) (abs_nonneg _)
  have hinc : V ≤ 3 * L := by
    calc
      V ≤ ∑ i ∈ s, w i * (3 * |b i ^ 2 - a i ^ 2|) := by
        apply Finset.sum_le_sum
        intro i hi
        exact mul_le_mul_of_nonneg_left
          (scalar_bit (u i) (v i) (e i) (hu i hi) (hv i hi) (he i hi)) (hw i hi)
      _ = 3 * L := by
        dsimp [L]
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i hi
        ring
  have hsq : V ^ 2 ≤ 9 * L ^ 2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hinc)
      (show 0 ≤ 3 * L + V by positivity)]
  have hquad := quadratic_flatness s w a b hw
  have hpair : pairing s w a (fun i => v i - u i) =
      pairing s w a b - energy s w a := by
    calc
      _ = ∑ i ∈ s, (w i * a i * b i - w i * a i ^ 2) := by
        apply Finset.sum_congr rfl
        intro i hi
        dsimp [a, b]
        ring
      _ = _ := by simp only [pairing, energy, Finset.sum_sub_distrib]
  change V ^ 2 ≤ 18 * ((energy s w b) ^ 2 - (energy s w a) ^ 2 -
    4 * energy s w a * pairing s w a (fun i => v i - u i))
  rw [hpair]
  change L ^ 2 ≤ _ at hquad
  nlinarith

end CubicFlatness

#print axioms CubicFlatness.flat18
