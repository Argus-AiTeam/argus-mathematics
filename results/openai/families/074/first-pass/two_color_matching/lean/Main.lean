import Mathlib

open scoped BigOperators

namespace TwoColorMatching

noncomputable section

def ascendingJacobian (m : Nat) (g x : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  fun j p => -(g p) * x p ^ j.val / (j.val.factorial : ℝ)

def endpointJacobian (m : Nat) (g x : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  (ascendingJacobian m g x).submatrix Fin.rev id

theorem ascending_det (m : Nat) (g x : Fin m → ℝ) :
    (ascendingJacobian m g x).det =
      (∏ j : Fin m, (j.val.factorial : ℝ)⁻¹) *
      (∏ p : Fin m, -(g p)) *
      (∏ i : Fin m, ∏ j ∈ Finset.Ioi i, (x j - x i)) := by
  let B : Matrix (Fin m) (Fin m) ℝ :=
    Matrix.of fun j p => -(g p) * (Matrix.vandermonde x).transpose j p
  have h : ascendingJacobian m g x =
      Matrix.of (fun j p => (j.val.factorial : ℝ)⁻¹ * B j p) := by
    ext j p
    simp [ascendingJacobian, B, div_eq_mul_inv, mul_comm]
  have hB : B.det = (∏ p : Fin m, -(g p)) * (Matrix.vandermonde x).transpose.det :=
    Matrix.det_mul_row (fun p => -(g p)) (Matrix.vandermonde x).transpose
  rw [h, Matrix.det_mul_column, hB, Matrix.det_transpose, Matrix.det_vandermonde]
  ring

theorem endpoint_abs_det (m : Nat) (g x : Fin m → ℝ) :
    |(endpointJacobian m g x).det| =
      (∏ j : Fin m, (j.val.factorial : ℝ)⁻¹) *
      (∏ p : Fin m, |g p|) *
      (∏ i : Fin m, ∏ j ∈ Finset.Ioi i, |x j - x i|) := by
  have h :
      |(endpointJacobian m g x).det| = |(ascendingJacobian m g x).det| := by
    exact Matrix.abs_det_submatrix_equiv_equiv
      Fin.revPerm (Equiv.refl (Fin m)) (ascendingJacobian m g x)
  rw [h, ascending_det]
  simp only [abs_mul, Finset.abs_prod, abs_inv, abs_neg, Nat.abs_cast]

variable {A B : Type*} [Fintype A] [Fintype B] [DecidableEq B]

def hiddenIntegral (q : List A → A → NNReal) (project : A → B)
    (test : List B → NNReal) : Nat → List A → NNReal
  | 0, h => test (h.map project)
  | n + 1, h => ∑ a : A, q h a * hiddenIntegral q project test n (h ++ [a])

def referenceIntegral (w : B → NNReal) (test : List B → NNReal) :
    Nat → List B → NNReal
  | 0, h => test h
  | n + 1, h => ∑ b : B, w b * referenceIntegral w test n (h ++ [b])

theorem fiber_implies_test (q : A → NNReal) (project : A → B) (w : B → NNReal)
    (hdom : ∀ b, (∑ a : A, if project a = b then q a else 0) ≤ w b)
    (test : B → NNReal) :
    (∑ a : A, q a * test (project a)) ≤ ∑ b : B, w b * test b := by
  classical
  calc
    (∑ a : A, q a * test (project a)) =
        ∑ b : B, (∑ a : A, if project a = b then q a else 0) * test b := by
      simp only [Finset.sum_mul]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro a _
      simp [ite_mul]
    _ ≤ ∑ b : B, w b * test b := by
      exact Finset.sum_le_sum (fun b _ => mul_le_mul_right' (hdom b) (test b))

theorem adaptive_domination
    (q : List A → A → NNReal) (project : A → B) (w : B → NNReal)
    (hdom : ∀ h (test : B → NNReal),
      (∑ a : A, q h a * test (project a)) ≤ ∑ b : B, w b * test b)
    (test : List B → NNReal) (n : Nat) (h : List A) :
    hiddenIntegral q project test n h ≤ referenceIntegral w test n (h.map project) := by
  induction n generalizing h with
  | zero => exact le_rfl
  | succ n ih =>
      simp only [hiddenIntegral, referenceIntegral]
      calc
        (∑ a : A, q h a * hiddenIntegral q project test n (h ++ [a])) ≤
            ∑ a : A, q h a * referenceIntegral w test n ((h ++ [a]).map project) := by
          exact Finset.sum_le_sum (fun a _ => mul_le_mul_left' (ih (h ++ [a])) (q h a))
        _ = ∑ a : A, q h a * referenceIntegral w test n (h.map project ++ [project a]) := by
          simp only [List.map_append, List.map_cons, List.map_nil]
        _ ≤ ∑ b : B, w b * referenceIntegral w test n (h.map project ++ [b]) :=
          hdom h (fun b => referenceIntegral w test n (h.map project ++ [b]))

theorem adaptive_domination_from_fibers
    (q : List A → A → NNReal) (project : A → B) (w : B → NNReal)
    (hdom : ∀ h b, (∑ a : A, if project a = b then q h a else 0) ≤ w b)
    (test : List B → NNReal) (n : Nat) (h : List A) :
    hiddenIntegral q project test n h ≤ referenceIntegral w test n (h.map project) := by
  apply adaptive_domination q project w _ test n h
  intro past f
  exact fiber_implies_test (q past) project w (hdom past) f

end

end TwoColorMatching
