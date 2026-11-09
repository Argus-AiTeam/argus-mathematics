import Mathlib

namespace LensCap

def diracIndex (a : ℤ) : ℤ :=
  (a / 4) * (1 - a % 4 - 2 * (a / 4))

def b16 (a : ℤ) : ℤ :=
  1 + 4 * (a % 4) - 2 * (a % 4) ^ 2

noncomputable def fixedPointTerm (r : ℕ) : ℂ :=
  (Complex.I ^ r / (1 + Complex.I) ^ 2 +
    (-1 : ℂ) ^ r / (2 : ℂ) ^ 2 +
    (-Complex.I) ^ r / (1 - Complex.I) ^ 2) / 4

theorem fixed_point_terms :
    fixedPointTerm 0 = 1 / 16 ∧
    fixedPointTerm 1 = 3 / 16 ∧
    fixedPointTerm 2 = 1 / 16 ∧
    fixedPointTerm 3 = -5 / 16 := by
  norm_num [fixedPointTerm, Complex.ext_iff, Complex.div_re, Complex.div_im,
    Complex.normSq, Complex.mul_re, Complex.mul_im, pow_succ]

theorem b16_values :
    b16 0 = 1 ∧ b16 1 = 3 ∧ b16 2 = 1 ∧ b16 3 = -5 := by
  norm_num [b16]

theorem dirac_residue (q r : ℤ) (hr0 : 0 ≤ r) (hr4 : r < 4) :
    diracIndex (4 * q + r) = q * (1 - r - 2 * q) := by
  have hd : (4 * q + r) / 4 = q := by omega
  have hm : (4 * q + r) % 4 = r := by omega
  simp only [diracIndex, hd, hm]

theorem dirac_polynomial (a : ℤ) :
    16 * diracIndex a = 1 + 4 * a - 2 * a ^ 2 - b16 a := by
  let q := a / 4
  let r := a % 4
  have ha : a = 4 * q + r := by dsimp [q, r]; omega
  change 16 * (q * (1 - r - 2 * q)) =
    1 + 4 * a - 2 * a ^ 2 - (1 + 4 * r - 2 * r ^ 2)
  calc
    16 * (q * (1 - r - 2 * q)) =
        1 + 4 * (4 * q + r) - 2 * (4 * q + r) ^ 2 -
          (1 + 4 * r - 2 * r ^ 2) := by ring
    _ = _ := by rw [← ha]

theorem dirac_square (a : ℤ) :
    32 * diracIndex a =
      (2 * (a % 4) - 2) ^ 2 - (2 * a - 2) ^ 2 := by
  have h := dirac_polynomial a
  unfold b16 at h
  nlinarith only [h]

theorem b16_pairs (m : ℤ) :
    b16 m + b16 (-m) = 2 - 4 * (m % 2) ∧
    b16 (2 + m) + b16 (2 - m) = 2 - 4 * (m % 2) := by
  have hm : m % 4 = 0 ∨ m % 4 = 1 ∨ m % 4 = 2 ∨ m % 4 = 3 := by omega
  rcases hm with h | h | h | h
  · have hn : (-m) % 4 = 0 := by omega
    have hp : (2 + m) % 4 = 2 := by omega
    have hq : (2 - m) % 4 = 2 := by omega
    have ht : m % 2 = 0 := by omega
    norm_num [b16, h, hn, hp, hq, ht]
  · have hn : (-m) % 4 = 3 := by omega
    have hp : (2 + m) % 4 = 3 := by omega
    have hq : (2 - m) % 4 = 1 := by omega
    have ht : m % 2 = 1 := by omega
    norm_num [b16, h, hn, hp, hq, ht]
  · have hn : (-m) % 4 = 2 := by omega
    have hp : (2 + m) % 4 = 0 := by omega
    have hq : (2 - m) % 4 = 0 := by omega
    have ht : m % 2 = 0 := by omega
    norm_num [b16, h, hn, hp, hq, ht]
  · have hn : (-m) % 4 = 1 := by omega
    have hp : (2 + m) % 4 = 1 := by omega
    have hq : (2 - m) % 4 = 3 := by omega
    have ht : m % 2 = 1 := by omega
    norm_num [b16, h, hn, hp, hq, ht]

theorem b16_conjugation (a : ℤ) : b16 (2 - a) = b16 a := by
  have ha : a % 4 = 0 ∨ a % 4 = 1 ∨ a % 4 = 2 ∨ a % 4 = 3 := by omega
  rcases ha with h | h | h | h
  · have hb : (2 - a) % 4 = 2 := by omega
    norm_num [b16, h, hb]
  · have hb : (2 - a) % 4 = 1 := by omega
    norm_num [b16, h, hb]
  · have hb : (2 - a) % 4 = 0 := by omega
    norm_num [b16, h, hb]
  · have hb : (2 - a) % 4 = 3 := by omega
    norm_num [b16, h, hb]

theorem dirac_conjugation (a : ℤ) : diracIndex (2 - a) = diracIndex a := by
  have hp := dirac_polynomial a
  have hn := dirac_polynomial (2 - a)
  rw [b16_conjugation] at hn
  nlinarith only [hp, hn]

theorem asd_normal (m : ℤ) :
    -2 * (diracIndex (2 * m) + diracIndex (-2 * m)) = 2 * m ^ 2 := by
  have hp := dirac_polynomial (2 * m)
  have hn := dirac_polynomial (-2 * m)
  have hb := (b16_pairs (2 * m)).1
  have he : (2 * m) % 2 = 0 := by omega
  rw [he] at hb
  have hneg : -(2 * m) = -2 * m := by ring
  rw [hneg] at hb
  nlinarith only [hp, hn, hb]

theorem coupled_minus (m : ℤ) :
    4 * (diracIndex m + diracIndex (-m)) = -m ^ 2 + m % 2 := by
  have hp := dirac_polynomial m
  have hn := dirac_polynomial (-m)
  have hb := (b16_pairs m).1
  nlinarith only [hp, hn, hb]

theorem coupled_plus (m : ℤ) :
    4 * (diracIndex (2 + m) + diracIndex (2 - m)) = -m ^ 2 + m % 2 := by
  have hp := dirac_polynomial (2 + m)
  have hn := dirac_polynomial (2 - m)
  have hb := (b16_pairs m).2
  nlinarith only [hp, hn, hb]

theorem coupled_both_backgrounds (m lam : ℤ) (hlam : lam = 2 ∨ lam = -2) :
    4 * (diracIndex ((lam + 2) / 2 + m) +
      diracIndex ((lam + 2) / 2 - m)) = -m ^ 2 + m % 2 := by
  rcases hlam with rfl | rfl
  · simpa using coupled_plus m
  · simpa using coupled_minus m

theorem charge_congruence (m : ℤ) :
    ∃ z : ℤ, m ^ 2 - m % 2 = 4 * z := by
  refine ⟨-(diracIndex m + diracIndex (-m)), ?_⟩
  linarith [coupled_minus m]

theorem dirac_nonpositive (a : ℤ) : diracIndex a ≤ 0 := by
  let q := a / 4
  let r := a % 4
  have hr0 : 0 ≤ r := by dsimp [r]; omega
  have hr3 : r ≤ 3 := by dsimp [r]; omega
  change q * (1 - r - 2 * q) ≤ 0
  by_cases hq : 0 ≤ q
  · by_cases hz : q = 0
    · simp [hz]
    · have hq1 : 1 ≤ q := by omega
      exact mul_nonpos_of_nonneg_of_nonpos hq (by omega)
  · exact mul_nonpos_of_nonpos_of_nonneg (by omega) (by omega)

theorem dirac_zero_iff (a : ℤ) :
    diracIndex a = 0 ↔ -1 ≤ a ∧ a ≤ 3 := by
  constructor
  · intro h
    unfold diracIndex at h
    rcases mul_eq_zero.mp h with hq | hf
    · omega
    · omega
  · rintro ⟨hlo, hhi⟩
    interval_cases a <;> norm_num [diracIndex]

theorem tangential_references :
    diracIndex 0 = 0 ∧ diracIndex 2 = 0 ∧ diracIndex (-1) = 0 ∧
    diracIndex 1 = 0 ∧ diracIndex 3 = 0 ∧
    2 * diracIndex (-2) = -2 ∧ 2 * diracIndex 4 = -2 := by
  norm_num [diracIndex]

theorem all_charge_shifts (h : ℚ) :
    8 * h + 2 * (-h) = 6 * h ∧
    8 * ((1 : ℚ) / 4 + h) = 2 + 8 * h ∧
    8 * ((1 : ℚ) / 4 + h) + 2 * (-h) = 2 + 6 * h := by
  constructor
  · ring
  constructor <;> ring

theorem determinant_transport (b e m : ℤ) :
    (-2 * e + m) + b = b - 2 * e + m ∧
    (-2 * e - m) + b = b - 2 * e - m ∧
    (-2 * e + m) + (-2 * e - m) = -4 * e ∧
    (-2 * e + m) - (-2 * e - m) = 2 * m := by
  constructor
  · ring
  constructor
  · ring
  constructor <;> ring

theorem spinor_determinant_transport (b e m : ℤ) :
    (2 * b - 2) + 2 * (-2 * e + m) =
      (2 * b - 2 - 4 * e) + 2 * m ∧
    (2 * b - 2) + 2 * (-2 * e - m) =
      (2 * b - 2 - 4 * e) - 2 * m := by
  constructor <;> ring

theorem fixed_spin_c (e : ℤ) : (2 - 4 * e) - (-4 * e) = 2 := by ring

theorem trace_character_transport (m : ℤ) (hodd : m % 2 = 1) :
    ∃ u v : ℤ, (-m) - (2 + m) = 4 * u ∧ m - (2 - m) = 4 * v := by
  refine ⟨-(m / 2 + 1), m / 2, ?_, ?_⟩ <;> omega

theorem trace_index_transport (m : ℤ) :
    diracIndex (-m) = diracIndex (2 + m) ∧
    diracIndex m = diracIndex (2 - m) := by
  constructor
  · have h := dirac_conjugation (2 + m)
    have ha : 2 - (2 + m) = -m := by ring
    rw [ha] at h
    exact h
  · have h := dirac_conjugation (2 - m)
    have ha : 2 - (2 - m) = m := by ring
    rw [ha] at h
    exact h

theorem central_reference_transport (b m : ℤ) :
    b - 2 + (m + 2) = b + m ∧
    b - 2 - (m + 2) = (b - m) - 4 := by
  constructor <;> ring

theorem central_reference_charge (m : ℚ) :
    (m + 2) ^ 2 / 4 - m ^ 2 / 4 = m + 1 := by ring

theorem chern_transport (kappa e : ℚ) :
    (kappa - e ^ 2) - (-4 * e ^ 2) / 4 = kappa ∧
    (-4 * (e + 1) ^ 2) - (-4 * e ^ 2) = -4 * (2 * e + 1) ∧
    (kappa - (e + 1) ^ 2) - (kappa - e ^ 2) = -(2 * e + 1) := by
  constructor
  · ring
  constructor <;> ring

def weyl : Matrix (Fin 2) (Fin 2) ℂ := !![0, -1; 1, 0]

def traceDiag (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![z, 0; 0, -z]

theorem weyl_determinant : weyl.det = 1 := by
  norm_num [weyl, Matrix.det_fin_two]

theorem weyl_trace_transport (z : ℂ) :
    weyl * traceDiag (-z) = traceDiag z * weyl := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [weyl, traceDiag, Matrix.mul_apply, Fin.sum_univ_two]

theorem weyl_square : weyl * weyl = -1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [weyl, Matrix.mul_apply, Fin.sum_univ_two]

end LensCap
