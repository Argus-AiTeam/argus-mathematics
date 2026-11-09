# Statement fidelity: universal algebra in the tree comparison

Claim: `C_TREE_ALGEBRA`. Namespace: `TreeComparison`.

The declarations below quantify over an arbitrary field K, with all scalar
variables explicitly quantified. They therefore apply, in particular, to every
odd prime field. The `Group` in `cycle_index_unique` is an arbitrary group;
the application is the group of multiplicative characters.

* `reconstruction_difference` states y_plus-y_minus=y_parent using exactly
  the rational formulas of eq:src36. D, p, u, Hplus, Hminus are assumed
  nonzero. The reconstruction equation is a separate hypothesis in
  denominator-cleared form. The theorem does not divide by a zero p and
  does not purport to describe invalid diagram points.
* `held_ratio_square` states (y_free/y_held)/d =
  D*s_free*H_held^2/(s_held*s_pair), the identity
  eq:tree-held-square. The displayed nonzero denominator hypotheses are
  present. Swapping the two leaves gives the opposite orientation;
  its pair difference is then -d in the analytic application.
* `reconstructed_square` is eq:tree-p-square after substituting d, e,
  and y from eq:src36. All parameters that occur as denominators, including
  the three frequencies, are assumed nonzero. This is a rational identity,
  not an assertion that arbitrary p satisfies the reconstruction rule.
* `bad_held_cancellation` derives d*p^2=c*y/e from
  p^2*d*e=c*y and e nonzero. It is the cancellation that removes the
  variable reconstructed entry from a held-parameter square.
* `square_fiber` says that two elements with equal squares differ by a
  sign. It does not assert that every element is a square. Combined with
  fixed-ratio injectivity it gives at most two nonidentity affine
  representations; no cardinality assertion is silently encoded here.
* `affine_composition` computes the coordinate map underlying U_r^*U_s
  for U_r F(t)=F(r-r^2 t), with r nonzero.
* `affine_fixed_ratio_injective` says that if z is neither zero nor one,
  equality of r*(z-z^2) and r'*(z-z^2) forces r=r'.
  The excluded z=1 is exactly the identity contribution, which the
  analytic proof treats separately.
* `quadratic_pairs_of_coefficients` proves that equal sums and equal
  products force two ordered pairs to agree up to swapping.
* `off_diagonal_collision_unique` says that two unequal unordered pairs
  can satisfy (a-b1)(a-b2)=(a-b3)(a-b4) for at most one a.
  It is stronger than the version requiring the common product to be
  nonzero. Repeated b's are allowed.
* `cycle_index_unique` is right cancellation: for fixed z, x*z=1 and
  y*z=1 imply x=y. Inverses handle a negative exponent on a cycle index.
  It includes the one-quartet parallel-edge case.
* `local_constant_budget` is the natural-number inequality used to add
  the 32 same-pair and 64 cross-pair majorants.

These are universal algebraic ingredients, not a formalization of the
complete analytic tree theorem `C_TREE`. In particular Lean does not
formalize the Fourier/character expansions, probability laws, operator
norm bounds, quartet integration, or graph-cycle existence. Those parts
are proved in `report.md` and require independent mathematical review.
Compilation cannot establish the truth of this fidelity document.
