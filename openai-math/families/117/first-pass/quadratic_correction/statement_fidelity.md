# Statement fidelity: Q_KERNEL

`Main.lean` formalizes the algebraic and finite-probability core of
the proof in `report.md`. It does **not** encode `Q_GENERAL` or
`H_QC`, the complete correction theorem, or the manuscript's hardness
theorem. The finite induction, scalar-invariant direction law,
internal-edge estimate, root bound, and event union bounds remain in
the mathematical proof and require independent reading.

All declarations are in namespace `Argus9000117`:

* `weighted_grid_comm` quantifies over arbitrary finite index types
  `I,J`, any commutative ring `R`, coefficient functions `a,b`,
  and every array `z`. It interchanges the two weighted finite sums.
  There is no dimension bound or characteristic restriction.
* `grid_predictions_agree` additionally takes two vectors `u,v`
  satisfying the displayed row and column reconstruction equations,
  and proves equality of their weighted predictions. These hypotheses
  are local linear equations on one grid, not the existence of a
  global correction.
* `translated_relations_transfer` takes reconstructed center values
  and assumes each translated linear relation is zero. It proves
  the center relation is zero. Again the hypotheses concern only a
  fixed finite array, not the correction conclusion.
* `collision_le_modal` quantifies over every real-valued nonnegative
  probability vector on a finite type and every maximal atom. It
  proves that its collision sum is at most that atom.
* `modal_mass_from_collision` adds a nonempty index type and any real
  `eta` with collision sum at least `1-eta`. It proves existence of
  a modal atom of mass at least `1-eta`, including the maximality
  property. The finite type can be the field alphabet; it is not the
  direction set.
* `collision_budget` and `shared_direction_completion_budget` are
  polynomial identities for arbitrary real `r,gamma,rho`.
  Substituting integer `r=d+1` gives the counts of axis, grid, and
  translated-center events in the proof. They do not prove the
  probabilistic bounds on those events.
* `quadratic_specialization` substitutes `r=3`.
  `manuscript_completion_implies_improved` proves, for nonnegative
  `delta`, that the manuscript's completion inequality implies the
  improved one.
* `manuscript_cleanup_margin` proves the exact lower bound
  `187/500000` on the cleanup margin for all real
  `delta<=1/16000`, `lambda<=1/1000000`. Nonnegativity is unnecessary
  for this lower-bound implication, so is not assumed there.
* `nonvacuity_numerator_identities` proves the two displayed
  change-of-variable identities for all real `s`.
  `all_degree_margins_positive` proves positivity of both rational
  margins for every real `r>=1`, with their exact denominators.

No imported manuscript theorem, unproved spectral assertion, or
statement about a desired corrected function is used by this Lean
file. Successful compilation certifies these declarations and only
these declarations. It cannot certify the prose interpretation,
novelty, publishability, or the full parameterized correction result.
