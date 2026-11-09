import Mathlib

set_option autoImplicit false

noncomputable section

namespace NormSolver

variable {k I : Type*} [Field k] [Fintype I]

def scaledEntry (c w : I -> PowerSeries k) : PowerSeries k :=
  Finset.univ.sum (fun i => c i * w i)

def truncatedEntry (r : Nat) (c w : I -> PowerSeries k) : PowerSeries k :=
  Finset.univ.sum (fun i =>
    (PowerSeries.trunc r (c i) : PowerSeries k) *
    (PowerSeries.trunc r (w i) : PowerSeries k))

theorem coefficient_from_truncations (c w : I -> PowerSeries k)
    {n r : Nat} (hn : n < r) :
    PowerSeries.coeff n (scaledEntry c w) =
      PowerSeries.coeff n (truncatedEntry r c w) := by
  simp only [scaledEntry, truncatedEntry, map_sum]
  apply Finset.sum_congr rfl
  intro i _
  exact PowerSeries.coeff_mul_eq_coeff_trunc_mul_trunc (c i) (w i) hn

theorem finite_precision_integrality (m : Nat) (c w : I -> PowerSeries k) :
    (PowerSeries.X : PowerSeries k) ^ (2 * m) ∣ scaledEntry c w
      <-> forall n, n < 2 * m ->
        PowerSeries.coeff n (truncatedEntry (2 * m + 1) c w) = 0 := by
  rw [PowerSeries.X_pow_dvd_iff]
  constructor
  · intro h n hn
    rw [<- coefficient_from_truncations c w (by omega : n < 2 * m + 1)]
    exact h n hn
  · intro h n hn
    rw [coefficient_from_truncations c w (by omega : n < 2 * m + 1)]
    exact h n hn

theorem finite_precision_fiber (m : Nat) (c w : I -> PowerSeries k) :
    PowerSeries.coeff (2 * m) (scaledEntry c w) =
      PowerSeries.coeff (2 * m) (truncatedEntry (2 * m + 1) c w) :=
  coefficient_from_truncations c w (by omega)

theorem divided_constant_term (m : Nat) (f u : PowerSeries k)
    (h : f = (PowerSeries.X : PowerSeries k) ^ (2 * m) * u) :
    PowerSeries.coeff 0 u = PowerSeries.coeff (2 * m) f := by
  rw [h]
  simpa using (PowerSeries.coeff_X_pow_mul u (2 * m) 0).symm

theorem finite_precision_section (m : Nat) (c w : I -> PowerSeries k) :
    ((PowerSeries.X : PowerSeries k) ^ (2 * m) ∣ scaledEntry c w
      <-> forall n, n < 2 * m ->
        PowerSeries.coeff n (truncatedEntry (2 * m + 1) c w) = 0) ∧
    (forall u : PowerSeries k,
      scaledEntry c w = (PowerSeries.X : PowerSeries k) ^ (2 * m) * u ->
      PowerSeries.coeff 0 u =
        PowerSeries.coeff (2 * m) (truncatedEntry (2 * m + 1) c w)) := by
  constructor
  · exact finite_precision_integrality m c w
  · intro u hu
    exact (divided_constant_term m (scaledEntry c w) u hu).trans
      (finite_precision_fiber m c w)

section Idempotents

variable {R : Type*} [Monoid R]

theorem stabilized_powers (b : R) (r : Nat) (h : b ^ (r + 1) = b ^ r)
    (s : Nat) : b ^ (r + s) = b ^ r := by
  induction s with
  | zero => simp
  | succ s ih =>
      calc
        b ^ (r + (s + 1)) = b ^ (r + s) * b := by
          rw [Nat.add_succ, pow_succ]
        _ = b ^ r * b := by rw [ih]
        _ = b ^ (r + 1) := (pow_succ b r).symm
        _ = b ^ r := h

theorem stabilized_idempotent (b : R) (r : Nat)
    (h : b ^ (r + 1) = b ^ r) :
    b ^ (r + 1) * b ^ (r + 1) = b ^ (r + 1) := by
  rw [h, <- pow_add]
  exact stabilized_powers b r h r

end Idempotents

section Fiber

variable {n : Nat}

def outer (v w : Fin n -> k) : Matrix (Fin n) (Fin n) k :=
  fun i j => v i * w j

theorem outer_idempotent (v w : Fin n -> k)
    (h : Finset.univ.sum (fun j => w j * v j) = 1) :
    outer v w * outer v w = outer v w := by
  ext i j
  change Finset.univ.sum (fun t => (v i * w t) * (v t * w j)) = v i * w j
  calc
    Finset.univ.sum (fun t => (v i * w t) * (v t * w j)) =
        v i * (Finset.univ.sum (fun t => w t * v t)) * w j := by
      simp only [Finset.mul_sum, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro t _
      ring
    _ = v i * w j := by rw [h]; simp

theorem outer_column_formula (v w x : Fin n -> k) (i : Fin n) :
    Finset.univ.sum (fun j => outer v w i j * x j) =
      v i * Finset.univ.sum (fun j => w j * x j) := by
  simp only [outer, Finset.mul_sum, mul_assoc]

theorem normalized_column_nonzero (v w : Fin n -> k)
    (h : Finset.univ.sum (fun j => w j * v j) = 1) :
    v ≠ 0 := by
  intro hv
  simp [hv] at h

theorem outer_in_block_upper (block : Fin n -> Nat) (v w : Fin n -> k)
    (hv : forall i, block i ≠ 0 -> v i = 0) :
    forall i j, block j < block i -> outer v w i j = 0 := by
  intro i j hij
  have hi : block i ≠ 0 := by omega
  simp [outer, hv i hi]

end Fiber

end NormSolver
