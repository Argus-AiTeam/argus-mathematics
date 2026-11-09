import Mathlib

namespace SupportNaturality

open Finset

section FiniteTrace

variable {R I J K : Type*} [CommRing R]
  [Fintype I] [Fintype J] [Fintype K] [DecidableEq J] [DecidableEq K]

def pullback (p : I → J) (f : J → R) : I → R := fun i => f (p i)

def trace (p : I → J) (f : I → R) : J → R :=
  fun j => ∑ i, if p i = j then f i else 0

def pairing {T : Type*} [Fintype T] (f g : T → R) : R :=
  ∑ t, f t * g t

theorem pullback_one (p : I → J) :
    pullback p (fun _ => (1 : R)) = fun _ => 1 := by
  rfl

theorem trace_projection (p : I → J) (a : J → R) (b : I → R) :
    trace p (fun i => pullback p a i * b i) =
      fun j => a j * trace p b j := by
  funext j
  simp only [trace, pullback, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  split_ifs with h
  · simp [h]
  · simp

theorem pullback_trace_adjoint (p : I → J) (a : J → R) (b : I → R) :
    pairing (pullback p a) b = pairing a (trace p b) := by
  classical
  simp only [pairing, trace, pullback, Finset.mul_sum, mul_ite, mul_zero]
  rw [Finset.sum_comm]
  simp

theorem trace_pullback_adjoint (p : I → J) (b : I → R) (a : J → R) :
    pairing b (pullback p a) = pairing (trace p b) a := by
  simpa only [pairing, mul_comm] using pullback_trace_adjoint p a b

theorem trace_comp (p : I → J) (q : J → K) (f : I → R) :
    trace q (trace p f) = trace (q ∘ p) f := by
  classical
  funext k
  change (∑ j, if q j = k then ∑ i, if p i = j then f i else 0 else 0) =
    ∑ i, if q (p i) = k then f i else 0
  calc
    _ = ∑ j, ∑ i, if p i = j then (if q j = k then f i else 0) else 0 := by
      apply Finset.sum_congr rfl
      intro j _
      by_cases h : q j = k <;> simp [h]
    _ = ∑ i, ∑ j, if p i = j then (if q j = k then f i else 0) else 0 :=
      Finset.sum_comm
    _ = _ := by simp

theorem trace_ringHom {S : Type*} [CommRing S]
    (φ : R →+* S) (p : I → J) (f : I → R) :
    (fun j => φ (trace p f j)) = trace p (fun i => φ (f i)) := by
  funext j
  simp only [trace, map_sum]
  apply Finset.sum_congr rfl
  intro i _
  split_ifs <;> simp

theorem fixed_volume_character (φ : R →+* R) (χ : R)
    (fixed : φ χ = χ) (f : I → R) :
    (fun i => φ (χ * f i)) = fun i => χ * φ (f i) := by
  funext i
  simp [fixed]

theorem trace_one (p : I → J) (j : J) :
    trace p (fun _ => (1 : R)) j =
      ((Finset.univ.filter (fun i => p i = j)).card : R) := by
  simp [trace, Finset.sum_boole]

end FiniteTrace

section Signs

variable {R : Type*} [CommRing R]

def integerSign (e : ZMod 2) : ℤ := if e = 0 then 1 else -1

def sign (e : ZMod 2) : R := (integerSign e : R)

theorem sign_add (a b : ZMod 2) :
    sign (R := R) (a + b) = sign (R := R) a * sign (R := R) b := by
  have h : ∀ a b : ZMod 2, integerSign (a + b) = integerSign a * integerSign b := by
    decide
  simpa only [sign, Int.cast_mul] using congrArg (fun z : ℤ => (z : R)) (h a b)

theorem dual_differential_sign (r j : ZMod 2) :
    sign (R := R) ((r + 1) * j) + sign (R := R) (r * j + j + 1) = 0 ∧
      sign (R := R) (j + r + 1 + r * j) =
        sign (R := R) (r * j + j + 1 + r) := by
  have h : ∀ r j : ZMod 2,
      integerSign ((r + 1) * j) + integerSign (r * j + j + 1) = 0 ∧
      integerSign (j + r + 1 + r * j) = integerSign (r * j + j + 1 + r) := by
    decide
  constructor
  · simpa only [sign, Int.cast_add, Int.cast_zero] using
      congrArg (fun z : ℤ => (z : R)) (h r j).1
  · exact congrArg (fun z : ℤ => (z : R)) (h r j).2

theorem dual_action_composition_sign (r s j : ZMod 2) :
    sign (R := R) (r * (j + s)) * sign (R := R) (s * j) *
        sign (R := R) (r * s) = sign (R := R) ((r + s) * j) := by
  have h : ∀ r s j : ZMod 2,
      integerSign (r * (j + s)) * integerSign (s * j) * integerSign (r * s) =
        integerSign ((r + s) * j) := by decide
  simpa only [sign, Int.cast_mul] using congrArg (fun z : ℤ => (z : R)) (h r s j)

theorem shifted_pairing_transpose_sign (d j r : ZMod 2) :
    sign (R := R) ((d + 1) * (j + r)) * sign (R := R) (d * r) *
        sign (R := R) (r * (-j - r)) =
      sign (R := R) (r * j) * sign (R := R) ((d + 1) * j) := by
  have h : ∀ d j r : ZMod 2,
      integerSign ((d + 1) * (j + r)) * integerSign (d * r) *
          integerSign (r * (-j - r)) =
        integerSign (r * j) * integerSign ((d + 1) * j) := by decide
  simpa only [sign, Int.cast_mul] using congrArg (fun z : ℤ => (z : R)) (h d j r)

theorem odd_shift_pairing_sign (d j : ZMod 2) (odd : d = 1) :
    sign (R := R) ((d + 1) * j) = 1 := by
  have h : ∀ j : ZMod 2, integerSign (((1 : ZMod 2) + 1) * j) = 1 := by decide
  subst d
  simpa only [sign, Int.cast_one] using congrArg (fun z : ℤ => (z : R)) (h j)

end Signs

end SupportNaturality
