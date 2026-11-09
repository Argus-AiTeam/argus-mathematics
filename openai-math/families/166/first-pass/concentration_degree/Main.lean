import Mathlib

namespace ConcentrationDegree

theorem coefficient_nonnegative
    (c : ℕ → ℕ → ℤ)
    (hzero : ∀ p, c p 0 = 1)
    (hone : ∀ p, c p 1 = (p : ℤ) - 2)
    (hstep : ∀ p u, c (p + 2) (u + 2) =
      (Nat.choose p (u + 2) : ℤ) + c p u) :
    ∀ u p, u + 1 ≤ p → 0 ≤ c p u := by
  intro u
  induction u using Nat.strong_induction_on with
  | h u ih =>
    intro p hp
    rcases u with _ | u
    · rw [hzero]
      norm_num
    rcases u with _ | u
    · rw [hone]
      have hp' : (2 : ℤ) ≤ (p : ℤ) := by exact_mod_cast hp
      omega
    obtain ⟨q, rfl⟩ : ∃ q, p = q + 2 := ⟨p - 2, by omega⟩
    rw [hstep]
    have hprevious : 0 ≤ c q u := ih u (by omega) q (by omega)
    have hchoose : (0 : ℤ) ≤ (Nat.choose q (u + 2) : ℤ) :=
      Int.natCast_nonneg _
    omega

theorem symmetry_skew_vanish
    {K : Type*} [Field K] [CharZero K]
    {I : Type*} (T : I → I → I → K)
    (hsym : ∀ i j k, T i j k = T j i k)
    (hskew : ∀ i j k, T i j k = -T i k j) :
    ∀ i j k, T i j k = 0 := by
  intro i j k
  have hneg : T i j k = -T i j k := by
    calc
      T i j k = T j i k := hsym i j k
      _ = -T j k i := hskew j i k
      _ = -T k j i := congrArg Neg.neg (hsym j k i)
      _ = -(-T k i j) := congrArg Neg.neg (hskew k j i)
      _ = T k i j := neg_neg _
      _ = T i k j := hsym k i j
      _ = -T i j k := hskew i k j
  have htwo : (2 : K) * T i j k = 0 := by
    linear_combination hneg
  exact (mul_eq_zero.mp htwo).resolve_left (by norm_num)

end ConcentrationDegree
