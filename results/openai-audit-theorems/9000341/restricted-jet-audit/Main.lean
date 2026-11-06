import Mathlib

namespace RestrictedJet

abbrev V := Fin 4 -> Real

def J (v : V) : V := ![-v 1, v 0, -v 3, v 2]

noncomputable def anti (a b : V) : V := fun i => (a i + J b i) / 2

noncomputable def holo (a b : V) : V := fun i => (a i - J b i) / 2

def formA (u v : V) : Real :=
  u 0 * v 2 - u 2 * v 0 - u 1 * v 3 + u 3 * v 1

def formH (u v : V) : Real :=
  u 0 * v 3 - u 3 * v 0 + u 1 * v 2 - u 2 * v 1

def symbol (s t : Real) (v : V) : V :=
  fun i => s * v i + t * J v i

theorem J_squared (v : V) : J (J v) = -v := by
  ext i
  fin_cases i <;> simp [J]

theorem pullback_identity_A (u v : V) :
    formA u v = -2 * formA u (J (anti u v)) := by
  simp [formA, J, anti]
  ring

theorem pullback_identity_H (u v : V) :
    formH u v = -2 * formH u (J (anti u v)) := by
  simp [formH, J, anti]
  ring

theorem normal_A (a b : Real) (e : V) :
    -2 * formA ![a, b, 0, 0] (J e) =
      2 * b * e 2 + 2 * a * e 3 := by
  simp [formA, J]
  ring

theorem normal_C (a b x y : Real) (e : V) :
    -2 * (x * formA ![a, b, 0, 0] (J e) +
      y * formH ![a, b, 0, 0] (J e)) =
      2 * (x * b - y * a) * e 2 +
      2 * (x * a + y * b) * e 3 := by
  simp [formA, formH, J]
  ring

theorem normal_determinant (a b x y : Real) :
    (2 * b) * (2 * (x * a + y * b)) -
      (2 * a) * (2 * (x * b - y * a)) =
      4 * y * (a ^ 2 + b ^ 2) := by
  ring

theorem normal_kernel (a b x y r s : Real)
    (hy : y ≠ 0) (hn : a ^ 2 + b ^ 2 ≠ 0)
    (hA : 2 * b * r + 2 * a * s = 0)
    (hC : 2 * (x * b - y * a) * r +
      2 * (x * a + y * b) * s = 0) :
    r = 0 ∧ s = 0 := by
  have hr : (2 * y * (a ^ 2 + b ^ 2)) * r = 0 := by
    linear_combination (x * a + y * b) * hA - a * hC
  have hs : (2 * y * (a ^ 2 + b ^ 2)) * s = 0 := by
    linear_combination b * hC - (x * b - y * a) * hA
  have hc : 2 * y * (a ^ 2 + b ^ 2) ≠ 0 :=
    mul_ne_zero (mul_ne_zero (by norm_num) hy) hn
  exact ⟨(mul_eq_zero.mp hr).resolve_left hc,
    (mul_eq_zero.mp hs).resolve_left hc⟩

theorem real_symbol_norm (s t : Real) (h : s ≠ 0 ∨ t ≠ 0) :
    s ^ 2 + t ^ 2 ≠ 0 := by
  intro hz
  have hs : s ^ 2 = 0 := by
    nlinarith [sq_nonneg s, sq_nonneg t]
  have ht : t ^ 2 = 0 := by
    nlinarith [sq_nonneg s, sq_nonneg t]
  rcases h with h | h
  · exact (pow_ne_zero 2 h) hs
  · exact (pow_ne_zero 2 h) ht

theorem symbol_product (s t : Real) (v : V) :
    symbol s (-t) (symbol s t v) =
      fun i => (s ^ 2 + t ^ 2) * v i := by
  ext i
  fin_cases i <;> simp [symbol, J] <;> ring

theorem symbol_kernel (s t : Real) (v : V)
    (hn : s ^ 2 + t ^ 2 ≠ 0) (hv : symbol s t v = 0) :
    v = 0 := by
  have hc : symbol s (-t) (symbol s t v) = 0 := by
    rw [hv]
    ext i
    fin_cases i <;> simp [symbol, J]
  rw [symbol_product] at hc
  ext i
  have hi := congrFun hc i
  change (s ^ 2 + t ^ 2) * v i = 0 at hi
  exact (mul_eq_zero.mp hi).resolve_left hn

theorem symbol_injective_nonzero (s t : Real) (v : V)
    (h : s ≠ 0 ∨ t ≠ 0) (hv : symbol s t v = 0) :
    v = 0 :=
  symbol_kernel s t v (real_symbol_norm s t h) hv

abbrev P := MvPolynomial (Fin 2) Real

theorem polynomial_symbol_norm :
    (MvPolynomial.X (0 : Fin 2) : P) ^ 2 +
      (MvPolynomial.X (1 : Fin 2) : P) ^ 2 ≠ 0 := by
  intro hz
  have he := congrArg (MvPolynomial.eval ![(1 : Real), 0]) hz
  norm_num at he

theorem polynomial_symbol_kernel (p q r0 r1 r2 r3 : P)
    (hn : p ^ 2 + q ^ 2 ≠ 0)
    (h0 : p * r0 - q * r1 = 0)
    (h1 : p * r1 + q * r0 = 0)
    (h2 : p * r2 - q * r3 = 0)
    (h3 : p * r3 + q * r2 = 0) :
    r0 = 0 ∧ r1 = 0 ∧ r2 = 0 ∧ r3 = 0 := by
  have hr0 : (p ^ 2 + q ^ 2) * r0 = 0 := by
    linear_combination p * h0 + q * h1
  have hr1 : (p ^ 2 + q ^ 2) * r1 = 0 := by
    linear_combination p * h1 - q * h0
  have hr2 : (p ^ 2 + q ^ 2) * r2 = 0 := by
    linear_combination p * h2 + q * h3
  have hr3 : (p ^ 2 + q ^ 2) * r3 = 0 := by
    linear_combination p * h3 - q * h2
  exact ⟨(mul_eq_zero.mp hr0).resolve_left hn,
    (mul_eq_zero.mp hr1).resolve_left hn,
    (mul_eq_zero.mp hr2).resolve_left hn,
    (mul_eq_zero.mp hr3).resolve_left hn⟩

theorem independent_first_jets (e h : V) :
    anti (fun i => e i + h i) (J (fun i => h i - e i)) = e ∧
      holo (fun i => e i + h i) (J (fun i => h i - e i)) = h := by
  constructor
  · ext i
    fin_cases i <;> simp [anti, J]
  · ext i
    fin_cases i <;> simp [holo, J]

theorem period_recovery (b p q : Real) (hb : b ≠ 0) :
    -b * (-p / b) = p ∧ -b * (-q / b) = q := by
  constructor <;> field_simp [hb]

end RestrictedJet
