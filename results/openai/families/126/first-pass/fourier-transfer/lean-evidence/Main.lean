import Mathlib

open scoped BigOperators

namespace FourierTransfer

variable {Y X Row OtherRow Col Frequency Label : Type*}

def frobSq [Fintype Row] [Fintype Col] (A : Matrix Row Col ℝ) : ℝ :=
  ∑ i, ∑ j, (A i j) ^ 2

theorem frobSq_nonneg [Fintype Row] [Fintype Col] (A : Matrix Row Col ℝ) :
    0 ≤ frobSq A := by
  exact Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => sq_nonneg _

theorem frobSq_sub_le [Fintype Row] [Fintype Col]
    (A B : Matrix Row Col ℝ) :
    frobSq (A - B) ≤ 2 * frobSq A + 2 * frobSq B := by
  unfold frobSq
  calc
    ∑ i, ∑ j, ((A - B) i j) ^ 2 ≤
        ∑ i, ∑ j, (2 * (A i j) ^ 2 + 2 * (B i j) ^ 2) := by
      apply Finset.sum_le_sum
      intro i _
      apply Finset.sum_le_sum
      intro j _
      change (A i j - B i j) ^ 2 ≤ _
      nlinarith [sq_nonneg (A i j + B i j)]
    _ = _ := by simp_rw [Finset.sum_add_distrib, Finset.mul_sum]

def tagCoefficient (normalization : ℝ) (chi : Frequency → Y → ℝ)
    (s : Y → X → ℝ) (U : X → Matrix Row Col ℝ)
    (z : Frequency) : Matrix (Y × X × Row) Col ℝ :=
  fun k j => normalization * chi z k.1 * s k.1 k.2.1 * U k.2.1 k.2.2 j

theorem tagged_overlap_entry [Fintype Y] [Fintype X] [Fintype Row]
    (normalization : ℝ) (chi : Frequency → Y → ℝ)
    (s : Y → X → ℝ) (U : X → Matrix Row Col ℝ)
    (z z' : Frequency) (j k : Col) :
    ((tagCoefficient normalization chi s U z).transpose *
        tagCoefficient normalization chi s U z') j k =
      normalization ^ 2 *
        ∑ y, chi z y * chi z' y *
          ∑ x, (s y x) ^ 2 * ((U x).transpose * U x) j k := by
  classical
  simp only [Matrix.mul_apply, Matrix.transpose_apply, tagCoefficient,
    Fintype.sum_prod_type, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  apply Finset.sum_congr rfl
  intro x _
  apply Finset.sum_congr rfl
  intro row _
  ring

def taggedStack [DecidableEq Y] (s : Y → X → ℝ)
    (H : X → Matrix Row Col ℝ) (y : Y) :
    Matrix (Y × X × Row) Col ℝ :=
  fun k j => if k.1 = y then s y k.2.1 * H k.2.1 k.2.2 j else 0

theorem tagged_square_entry [Fintype Y] [Fintype X] [Fintype Row]
    [DecidableEq Y] (s : Y → X → ℝ) (H : X → Matrix Row Col ℝ)
    (y : Y) (j k : Col) :
    ((taggedStack s H y).transpose * taggedStack s H y) j k =
      ∑ x, (s y x) ^ 2 * ((H x).transpose * H x) j k := by
  classical
  simp only [Matrix.mul_apply, Matrix.transpose_apply, taggedStack,
    Fintype.sum_prod_type]
  calc
    _ = ∑ tag : Y, if tag = y then
          ∑ x, (s y x) ^ 2 * ∑ row, H x row j * H x row k else 0 := by
      apply Finset.sum_congr rfl
      intro tag _
      by_cases htag : tag = y
      · simp only [htag, if_true, Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro x _
        apply Finset.sum_congr rfl
        intro row _
        ring
      · simp [htag]
    _ = _ := by simp

theorem resolution_square [Fintype Row] [Fintype Label] [DecidableEq Row]
    (P : Label → Matrix Row Row ℝ) (H : Matrix Row Col ℝ)
    (hsym : ∀ s, (P s).transpose = P s)
    (hid : ∀ s, P s * P s = P s) (hsum : ∑ s, P s = 1) :
    ∑ s, (P s * H).transpose * (P s * H) = H.transpose * H := by
  have hterm (s : Label) :
      (P s * H).transpose * (P s * H) = H.transpose * P s * H := by
    calc
      _ = H.transpose * ((P s).transpose * P s) * H := by
        simp only [Matrix.transpose_mul, Matrix.mul_assoc]
      _ = _ := by rw [hsym, hid]
  simp_rw [hterm]
  rw [← Matrix.sum_mul, ← Matrix.mul_sum, hsum]
  simp

theorem noncommutative_block_gap [Fintype Row] [Fintype OtherRow]
    (A B : Matrix Row Row ℝ) (C D : Matrix OtherRow OtherRow ℝ) (off : ℝ) :
    Matrix.trace (A * B) + Matrix.trace (C * D) + 2 * off -
        (Matrix.trace (B * B) + Matrix.trace (C * C)) =
      Matrix.trace ((A - B) * B) + Matrix.trace (C * (D - C)) + 2 * off := by
  simp only [sub_mul, mul_sub, Matrix.trace_sub]
  ring

theorem balanced_step (d a b loss : ℝ) (hd : 1 / 2 ≤ d) (ha : 0 ≤ a)
    (h : loss ≤ (1 + 2 * d) * a + 2 * d * b) :
    loss ≤ (2 * d) * (2 * a + b) := by
  nlinarith [mul_nonneg (show 0 ≤ 2 * d - 1 by linarith) ha]

noncomputable def splitConstant : ℕ → ℝ
  | 0 => 0
  | 1 => 1 / 2
  | n + 2 => 2 * splitConstant (n + 1)

theorem splitConstant_formula (a : ℕ) :
    splitConstant (a + 1) = (2 : ℝ) ^ (a + 1) / 4 := by
  induction a with
  | zero => norm_num [splitConstant]
  | succ a ih =>
      change 2 * splitConstant (a + 1) = (2 : ℝ) ^ (a + 1 + 1) / 4
      rw [ih, pow_succ]
      ring

theorem one_step_factor (L theta lam d mass : ℝ) (hL : L ≠ 0) :
    L * (L * (mass / L ^ 2) +
        lam ^ 2 * d * (L * (L - 1) * (theta * mass / L ^ 2))) =
      (1 + (L - 1) * lam ^ 2 * d * theta) * mass := by
  field_simp [hL]

theorem potential_iterate (phi : ℕ → ℝ) (g : ℝ) (hg : 0 ≤ g)
    (hstep : ∀ n, phi (n + 1) ≤ g * phi n) (n : ℕ) :
    phi n ≤ g ^ n * phi 0 := by
  induction n with
  | zero => simp
  | succ n ih =>
      calc
        phi (n + 1) ≤ g * phi n := hstep n
        _ ≤ g * (g ^ n * phi 0) := mul_le_mul_of_nonneg_left ih hg
        _ = g ^ (n + 1) * phi 0 := by rw [pow_succ]; ring

theorem mass_squared_conversion (mass r N phi initial growth : ℝ)
    (hr : 0 ≤ r) (hmass : mass ^ 2 ≤ r * N ^ 2 * phi)
    (hphi : phi ≤ initial * growth) :
    mass ^ 2 ≤ r * N ^ 2 * (initial * growth) := by
  exact hmass.trans (mul_le_mul_of_nonneg_left hphi (mul_nonneg hr (sq_nonneg N)))

end FourierTransfer
