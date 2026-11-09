import Mathlib

namespace SpectralRigidity

open scoped BigOperators

theorem finite_difference_telescopes (F : ℤ → ℝ) (m : ℤ) (n : ℕ) :
    (∑ k ∈ Finset.range n, (F (m + (k : ℤ)) - F (m + (k : ℤ) + 1))) =
      F m - F (m + (n : ℤ)) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, ih]
      simp only [Nat.cast_add, Nat.cast_one, add_assoc]
      ring

theorem spectral_telescope (D C : ℤ → ℝ) (m : ℤ) (n : ℕ) :
    (∑ k ∈ Finset.range n,
      (D (m + (k : ℤ)) - D (m + (k : ℤ) + 2) -
        C (m + (k : ℤ)) + C (m + (k : ℤ) + 1))) =
      D m + D (m + 1) - D (m + (n : ℤ)) - D (m + (n : ℤ) + 1) -
        C m + C (m + (n : ℤ)) := by
  let F : ℤ → ℝ := fun j => D j + D (j + 1) - C j
  have hpoint (j : ℤ) :
      D j - D (j + 2) - C j + C (j + 1) = F j - F (j + 1) := by
    dsimp [F]
    have h : j + 1 + 1 = j + 2 := by omega
    rw [h]
    ring
  calc
    _ = ∑ k ∈ Finset.range n, (F (m + (k : ℤ)) - F (m + (k : ℤ) + 1)) := by
      apply Finset.sum_congr rfl
      intro k _
      exact hpoint _
    _ = F m - F (m + (n : ℤ)) := finite_difference_telescopes F m n
    _ = _ := by dsimp [F]; ring

def innerFirst (z w : ℂ) : ℂ := z * star w

theorem endpoint_pairing_formula (b a u v : ℂ) (l : ℝ) :
    innerFirst b (-(l : ℂ) * v - 2 * Complex.I * b) +
        innerFirst (-a) ((l : ℂ) * u + 2 * Complex.I * a) =
      2 * Complex.I * ((Complex.normSq b + Complex.normSq a : ℝ) : ℂ) -
        (l : ℂ) * (innerFirst b v + innerFirst a u) := by
  apply Complex.ext <;> simp [innerFirst, Complex.normSq] <;> ring

theorem complex_two_vector_cauchy (b a u v : ℂ) :
    Complex.normSq (innerFirst b v + innerFirst a u) ≤
      (Complex.normSq b + Complex.normSq a) *
        (Complex.normSq v + Complex.normSq u) := by
  have h :
      (Complex.normSq b + Complex.normSq a) *
          (Complex.normSq v + Complex.normSq u) -
        Complex.normSq (innerFirst b v + innerFirst a u) =
          Complex.normSq (b * u - a * v) := by
    simp [innerFirst, Complex.normSq]
    ring
  have hn := Complex.normSq_nonneg (b * u - a * v)
  linarith

theorem endpoint_scalar_bound (energy mass l re im : ℝ)
    (henergy : 0 ≤ energy) (hmass : 0 ≤ mass)
    (hcauchy : re ^ 2 + im ^ 2 ≤ energy * mass)
    (hpair : 2 * energy = l * im) :
    energy ≤ l ^ 2 * mass / 4 := by
  by_cases hz : energy = 0
  · rw [hz]
    positivity
  · have hp : 0 < energy := lt_of_le_of_ne henergy (Ne.symm hz)
    have hc := mul_le_mul_of_nonneg_left hcauchy (sq_nonneg l)
    have heq : (2 * energy) ^ 2 = (l * im) ^ 2 :=
      congrArg (fun x : ℝ => x ^ 2) hpair
    have hsq : 4 * energy ^ 2 ≤ l ^ 2 * energy * mass := by
      nlinarith [sq_nonneg (l * re)]
    have hmul : energy * (4 * energy) ≤ energy * (l ^ 2 * mass) := by
      nlinarith [hsq]
    have hbound : 4 * energy ≤ l ^ 2 * mass := by
      by_contra hn
      have hpos : 0 < energy * (4 * energy - l ^ 2 * mass) :=
        mul_pos hp (sub_pos.mpr (lt_of_not_ge hn))
      nlinarith
    linarith

theorem two_boundary_energy (b a u v : ℂ) (l : ℝ)
    (hpair :
      innerFirst b (-(l : ℂ) * v - 2 * Complex.I * b) +
        innerFirst (-a) ((l : ℂ) * u + 2 * Complex.I * a) = 0) :
    Complex.normSq b + Complex.normSq a ≤
      l ^ 2 * (Complex.normSq v + Complex.normSq u) / 4 := by
  let energy := Complex.normSq b + Complex.normSq a
  let mass := Complex.normSq v + Complex.normSq u
  let c := innerFirst b v + innerFirst a u
  have hformula := endpoint_pairing_formula b a u v l
  rw [hpair] at hformula
  have hid : 2 * Complex.I * (energy : ℂ) = (l : ℂ) * c := by
    exact sub_eq_zero.mp hformula.symm
  have him : 2 * energy = l * c.im := by
    have h := congrArg Complex.im hid
    simpa using h
  have hc : c.re ^ 2 + c.im ^ 2 ≤ energy * mass := by
    have h := complex_two_vector_cauchy b a u v
    change Complex.normSq c ≤ energy * mass at h
    simpa [Complex.normSq, pow_two] using h
  exact endpoint_scalar_bound energy mass l c.re c.im
    (add_nonneg (Complex.normSq_nonneg b) (Complex.normSq_nonneg a))
    (add_nonneg (Complex.normSq_nonneg v) (Complex.normSq_nonneg u)) hc him

theorem sharp_energy_forces_transverse_zero (xEnergy yEnergy l mass : ℝ)
    (hy : 0 ≤ yEnergy) (hx : xEnergy = l ^ 2 * mass)
    (hsharp : xEnergy + yEnergy ≤ l ^ 2 * mass) :
    yEnergy = 0 := by
  linarith

end SpectralRigidity
