import Mathlib.Data.Complex.BigOperators
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.Tactic.NoncommRing
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum

open scoped BigOperators ComplexConjugate
open Matrix

namespace TraceDeficitCore

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem ordered_factorization (s : ℂ) (B S : Matrix n n ℂ) :
    (s • (1 : Matrix n n ℂ) - B + Complex.I • S) *
        (s • (1 : Matrix n n ℂ) - B - Complex.I • S) =
      (s • (1 : Matrix n n ℂ) - B) ^ 2 + S ^ 2 +
        Complex.I • (B * S - S * B) := by
  have hproduct (X : Matrix n n ℂ) :
      (X + Complex.I • S) * (X - Complex.I • S) =
        X ^ 2 + S ^ 2 + Complex.I • (S * X - X * S) := by
    noncomm_ring [smul_add, smul_sub, smul_neg, smul_smul,
      Complex.I_mul_I, neg_one_smul]
  have hcomm :
      S * (s • (1 : Matrix n n ℂ) - B) -
          (s • (1 : Matrix n n ℂ) - B) * S = B * S - S * B := by
    simp only [mul_sub, sub_mul, mul_smul_comm, smul_mul_assoc, mul_one, one_mul]
    abel
  rw [hproduct, hcomm]

theorem riccati_averaging (B L Z W : Matrix n n ℂ)
    (hplus : W = (L + Z) ^ 2 + Complex.I • (B * (L + Z) - (L + Z) * B))
    (hminus : W = (L - Z) ^ 2 - Complex.I • (B * (L - Z) - (L - Z) * B)) :
    W = L ^ 2 + Z ^ 2 + Complex.I • (B * Z - Z * B) ∧
      L * Z + Z * L + Complex.I • (B * L - L * B) = 0 := by
  let P : Matrix n n ℂ := L ^ 2 + Z ^ 2 + Complex.I • (B * Z - Z * B)
  let Q : Matrix n n ℂ := L * Z + Z * L + Complex.I • (B * L - L * B)
  have hp : W = P + Q := by
    rw [hplus]
    dsimp [P, Q]
    noncomm_ring [smul_add, smul_sub, smul_neg]
  have hm : W = P - Q := by
    rw [hminus]
    dsimp [P, Q]
    noncomm_ring [smul_add, smul_sub, smul_neg]
  have hsum : Q + Q = 0 := by
    calc
      Q + Q = (P + Q) - (P - Q) := by abel
      _ = 0 := by rw [← hp, ← hm, sub_self]
  have htwo : (2 : ℂ) ≠ 0 := by norm_num
  have hQ : Q = 0 := by
    have hz : (2 : ℂ) • Q = 0 := by
      simpa only [two_smul ℂ] using hsum
    exact (smul_eq_zero.mp hz).resolve_left htwo
  exact ⟨by simpa only [hQ, add_zero] using hp, hQ⟩

theorem trace_deficit_sign (B L Z W R : Matrix n n ℂ)
    (hRL : R * L = 1) (hLR : L * R = 1)
    (hW : W = L ^ 2 + Z ^ 2 + Complex.I • (B * Z - Z * B))
    (hRic : L * Z + Z * L + Complex.I • (B * L - L * B) = 0) :
    trace (R * W) = trace L - trace (R * Z ^ 2) := by
  have hcancel (X : Matrix n n ℂ) : R * (L * X) = X := by
    rw [← mul_assoc, hRL, one_mul]
  have hsand :
      Z * R + R * Z + Complex.I • (R * B - B * R) = 0 := by
    calc
      Z * R + R * Z + Complex.I • (R * B - B * R) =
          R * (L * Z + Z * L + Complex.I • (B * L - L * B)) * R := by
        simp only [mul_add, add_mul, mul_sub, sub_mul, mul_smul_comm,
          smul_mul_assoc, mul_assoc, hcancel, hLR, mul_one, smul_sub]
      _ = 0 := by rw [hRic, mul_zero, zero_mul]
  have hcycle : trace (Z * R * Z) = trace (R * Z ^ 2) := by
    rw [← trace_mul_cycle R Z Z, pow_two, mul_assoc]
  have hpower : trace (R * Z * Z) = trace (R * Z ^ 2) := by
    rw [pow_two, mul_assoc]
  have ht := congrArg (fun M : Matrix n n ℂ => trace (M * Z)) hsand
  simp only [add_mul, sub_mul, smul_mul_assoc, trace_add, trace_sub,
    trace_smul, smul_eq_mul, zero_mul, trace_zero, hcycle, hpower] at ht
  have hL : R * L ^ 2 = L := by
    rw [pow_two, hcancel L]
  have htrace :
      trace (R * W) = trace L + trace (R * Z ^ 2) +
        Complex.I * (trace (R * B * Z) - trace (B * R * Z)) := by
    rw [hW]
    simp only [mul_add, mul_sub, mul_smul_comm, trace_add, trace_sub,
      trace_smul, smul_eq_mul, hL]
    rw [← mul_assoc R B Z, ← mul_assoc R Z B, trace_mul_cycle R Z B]
  rw [htrace]
  linear_combination ht

theorem riccati_trace_deficit (B L Z W R : Matrix n n ℂ)
    (hRL : R * L = 1) (hLR : L * R = 1)
    (hplus : W = (L + Z) ^ 2 + Complex.I • (B * (L + Z) - (L + Z) * B))
    (hminus : W = (L - Z) ^ 2 - Complex.I • (B * (L - Z) - (L - Z) * B)) :
    trace (R * W) = trace L - trace (R * Z ^ 2) := by
  obtain ⟨hW, hRic⟩ := riccati_averaging B L Z W hplus hminus
  exact trace_deficit_sign B L Z W R hRL hLR hW hRic

theorem ordered_adjoint_square (U A H R L : Matrix n n ℂ)
    (hU : U.IsHermitian) (hA : A.IsHermitian) (hH : H.IsHermitian)
    (hUA : U * A = 1) (hAU : A * U = 1)
    (hAR : A ^ 2 = R) (hUL : U ^ 2 = L) :
    (U - A * H)ᴴ * (U - A * H) =
      L + H * R * H - (2 : ℂ) • H := by
  rw [conjTranspose_sub, conjTranspose_mul, hU.eq, hA.eq, hH.eq]
  have hleft : U * (A * H) = H := by
    rw [← mul_assoc, hUA, one_mul]
  have hright : H * A * U = H := by
    rw [mul_assoc, hAU, mul_one]
  have hmiddle : (H * A) * (A * H) = H * R * H := by
    calc
      (H * A) * (A * H) = H * (A * A) * H := by simp only [mul_assoc]
      _ = H * R * H := by rw [← pow_two, hAR]
  calc
    (U - H * A) * (U - A * H) =
        U ^ 2 - U * (A * H) - (H * A) * U + (H * A) * (A * H) := by
      noncomm_ring
    _ = L - H - H + H * R * H := by rw [hUL, hleft, hright, hmiddle]
    _ = L + H * R * H - (2 : ℂ) • H := by rw [two_smul ℂ]; abel

theorem ordered_adjoint_square_trace (U A H R L : Matrix n n ℂ)
    (hU : U.IsHermitian) (hA : A.IsHermitian) (hH : H.IsHermitian)
    (hUA : U * A = 1) (hAU : A * U = 1)
    (hAR : A ^ 2 = R) (hUL : U ^ 2 = L) :
    trace ((U - A * H)ᴴ * (U - A * H)) =
      trace (L + R * H ^ 2 - (2 : ℂ) • H) := by
  have hcycle : trace (H * R * H) = trace (R * H ^ 2) := by
    rw [← trace_mul_cycle R H H, pow_two, mul_assoc]
  rw [ordered_adjoint_square U A H R L hU hA hH hUA hAU hAR hUL]
  simp only [trace_sub, trace_add, hcycle]

theorem gram_trace_identity (A Z R : Matrix n n ℂ)
    (hA : A.IsHermitian) (hZ : Z.IsHermitian) (hAR : A ^ 2 = R) :
    trace (R * Z ^ 2) = trace ((A * Z)ᴴ * (A * Z)) := by
  have hgram : (A * Z)ᴴ * (A * Z) = Z * R * Z := by
    rw [conjTranspose_mul, hZ.eq, hA.eq]
    calc
      (Z * A) * (A * Z) = Z * (A * A) * Z := by simp only [mul_assoc]
      _ = Z * R * Z := by rw [← pow_two, hAR]
  rw [hgram, ← trace_mul_cycle R Z Z, pow_two, mul_assoc]

omit [DecidableEq n] in
theorem gram_trace_re_nonneg {m : Type*} [Fintype m] (X : Matrix m n ℂ) :
    0 ≤ (trace (Xᴴ * X)).re := by
  classical
  simp only [Matrix.trace, Matrix.diag, Matrix.mul_apply, Matrix.conjTranspose_apply,
    Complex.star_def, Complex.re_sum, ← Complex.normSq_eq_conj_mul_self, Complex.ofReal_re]
  exact Finset.sum_nonneg fun j _ =>
    Finset.sum_nonneg fun k _ => Complex.normSq_nonneg (X k j)

theorem ordered_adjoint_square_trace_re_nonneg (U A H R L : Matrix n n ℂ)
    (hU : U.IsHermitian) (hA : A.IsHermitian) (hH : H.IsHermitian)
    (hUA : U * A = 1) (hAU : A * U = 1)
    (hAR : A ^ 2 = R) (hUL : U ^ 2 = L) :
    0 ≤ (trace (L + R * H ^ 2 - (2 : ℂ) • H)).re := by
  rw [← ordered_adjoint_square_trace U A H R L hU hA hH hUA hAU hAR hUL]
  exact gram_trace_re_nonneg (U - A * H)

end TraceDeficitCore
