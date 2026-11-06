import Mathlib

namespace PseudoindexFiveAudit

/-- Shifted elementary symmetric Chern substitutions in `verify.py`:
given `e1 = a + b + d`, `e2 = a b + a d + b d`, `e3 = a b d`, and shift `h`,
the shifted classes `(r, s, t)` for roots `(a + h, b + h, d + h)` recover `(e1, e2, e3)`. -/
theorem shifted_chern_recovery (a b d h : ℚ) :
    let r := (a + h) + (b + h) + (d + h)
    let s := (a + h) * (b + h) + (a + h) * (d + h) + (b + h) * (d + h)
    let t := (a + h) * (b + h) * (d + h)
    r - 3 * h = a + b + d ∧
    s - 2 * h * r + 3 * h ^ 2 = a * b + a * d + b * d ∧
    t - h * s + h ^ 2 * r - h ^ 3 = a * b * d := by
  dsimp
  refine ⟨by ring, by ring, by ring⟩

/-- Exact factorization of the pseudoindex-five characteristic number quadratic relation
`3 S^2 - 20 S D + 32 D^2 = (3 S - 8 D) (S - 4 D)` in `verify.py`. -/
theorem characteristic_quadratic_factorization (S D : ℚ) :
    3 * S ^ 2 - 20 * S * D + 32 * D ^ 2 = (3 * S - 8 * D) * (S - 4 * D) := by
  ring

/-- Non-specialization obstruction (`F067_KANEMITSU_EVERY_MEMBER_SPLITTING`):
a quadratic family `p(t) = t^2` vanishes at `t = 0` (`p(0) = 0`) while being nonzero on all
`t ≠ 0`, illustrating that generic-fiber properties do not automatically hold on special fibers. -/
theorem special_fiber_jump_obstruction :
    ∃ p : ℚ → ℚ, (∀ t ≠ 0, p t ≠ 0) ∧ p 0 = 0 := by
  refine ⟨fun t => t ^ 2, ?_, by ring⟩
  intro t ht
  exact pow_ne_zero 2 ht

end PseudoindexFiveAudit
