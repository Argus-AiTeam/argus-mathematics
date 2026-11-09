import Mathlib

namespace FlowTraceAudit

variable {R : Type*} [Ring R]

def comm (y x : R) : R := y * x - x * y

def wordValue : List (Bool × R) → R
  | [] => 1
  | (_, x) :: w => x * wordValue w

def variation (selected : Bool) (y : R) : List (Bool × R) → R
  | [] => 0
  | (b, x) :: w =>
      (if b = selected then comm y x else 0) * wordValue w +
        x * variation selected y w

theorem variation_split (y : R) (w : List (Bool × R)) :
    variation true y w + variation false y w = comm y (wordValue w) := by
  induction w with
  | nil => simp [variation, wordValue, comm]
  | cons a w ih =>
      rcases a with ⟨b, x⟩
      calc
        variation true y ((b, x) :: w) + variation false y ((b, x) :: w) =
            comm y x * wordValue w +
              x * (variation true y w + variation false y w) := by
                cases b <;> simp [variation] <;> noncomm_ring
        _ = comm y x * wordValue w + x * comm y (wordValue w) := by rw [ih]
        _ = comm y (wordValue ((b, x) :: w)) := by
              simp only [comm, wordValue]
              noncomm_ring

variable {K : Type*} [AddCommGroup K]

theorem trace_comm_zero (tr : R →+ K)
    (cyclic : ∀ a b : R, tr (a * b) = tr (b * a)) (y x : R) :
    tr (comm y x) = 0 := by
  simp [comm, map_sub, cyclic y x]

theorem selected_trace_zero (tr : R →+ K)
    (cyclic : ∀ a b : R, tr (a * b) = tr (b * a))
    (y : R) (w : List (Bool × R))
    (complement : tr (variation false y w) = 0) :
    tr (variation true y w) = 0 := by
  have h := congrArg tr (variation_split y w)
  rw [map_add, trace_comm_zero tr cyclic, complement, add_zero] at h
  exact h

def iter {P : Type*} (d : P → P) : Nat → P → P
  | 0, p => p
  | r + 1, p => d (iter d r p)

theorem all_positive_iterates {P Q : Type*} [Zero Q]
    (d : P → P) (tr : P → Q) (first : ∀ p, tr (d p) = 0)
    (r : Nat) (positive : 0 < r) (p : P) :
    tr (iter d r p) = 0 := by
  cases r with
  | zero => omega
  | succ r => exact first (iter d r p)

def growth (l J : Nat) : Nat → Nat
  | 0 => 1
  | r + 1 => growth l J r * (l + r * J)

theorem length_factor_le (l J v : Nat) :
    l + v * J ≤ (l + J) * (v + 1) := by
  nlinarith [Nat.zero_le (l * v)]

theorem growth_bound (l J r : Nat) :
    growth l J r ≤ (l + J) ^ r * r.factorial := by
  induction r with
  | zero => simp [growth]
  | succ r ih =>
      calc
        growth l J (r + 1) ≤
            ((l + J) ^ r * r.factorial) * ((l + J) * (r + 1)) :=
          Nat.mul_le_mul ih (length_factor_le l J r)
        _ = (l + J) ^ (r + 1) * (r + 1).factorial := by
          rw [pow_succ, Nat.factorial_succ]
          ring

end FlowTraceAudit
