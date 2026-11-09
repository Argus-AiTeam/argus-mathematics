# Statement fidelity

`Main.lean` formalizes universal structural and algebraic ingredients of the
coprime-period theorem in `theorem.md`. It does **not** formalize the whole word
construction, the complete marked-payload counting argument, the ANOVA
decomposition, the cyclic telescoping estimate, or the infinite-coordinate cut
decomposition. The full theorem has a prose proof requiring independent
mathematical review. A successful compiler run must not be reported as a
kernel proof of `C_PP_FAMILY`.

- `marker_interval_unmatched` quantifies over any linearly ordered matching
  index type, strictly increasing natural-number source and target positions,
  arbitrary symbol functions, and a fresh marker symbol. Equal symbols at
  every matched pair, a marker-free source interval containing two source
  partners, and a target marker interval lying strictly between their target
  partners imply that no target position in that interval is matched. It
  imposes no row-boundary alignment assumption. `ordered_spans_disjoint`
  verifies the ordering implication used to make marker charges distinct.
- `charged_deficit` quantifies over real counts and budgets. From nonnegative
  payload deficit, positive marker length, and the two independently obtained
  loss inequalities it derives the unrounded marked-payload bound. It does
  not assume that those inequalities hold for an arbitrary matching;
  that application is proved in Section 2 of `theorem.md`.
- `marked_normalization`, `equal_markers_normalization`, and
  `improved_separation_step` verify the exact geometric normalization and
  the improved factor \(1/9\) with their explicit positivity hypotheses.
- `coprime_no_cancellation` proves the noncancellation of a nonzero residue
  after multiplication by a coprime factor, even for composite periods.
  `bounded_nonzero_multiple` verifies the product-versus-horizon
  contradiction after the common divisibility is established.
- `high_support_bound` and `cyclic_low_support_bound` are uniform real
  inequalities for the orthogonal components in Section 4. The latter
  explicitly assumes the variance/short-path estimate; Lean has not derived
  it from cyclic shifts.
- `sum_displacement_bounds` and `cut_cone_transfer` verify the finite
  nonnegative summations used to pass from components and cuts to
  displacements. Existence of those decompositions is not a Lean conclusion.
- `direct_sum_normalization` verifies the exact scalar normalization for
  positive component weight and positive finite cardinalities.
  `averaged_recurrence` verifies the recurrence from the simultaneous and
  component averaged inequalities, for arbitrary finite component sets;
  it does not assert that a particular slice satisfies a budget.
- `improved_recurrence_implies_manuscript` compares the stronger and the
  original analytic recurrences for every natural exponent parameter.

The formal claim `C_PP_FORMAL` is precisely this conjunction of ingredients,
not the stronger statement of the manuscript. All quantifiers and hypotheses
remain in the Lean declarations. There are no additional mathematical axioms,
admitted declarations, or intended uses of a compiler failure as refutation.
