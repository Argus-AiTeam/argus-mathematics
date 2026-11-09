# Statement fidelity: exact finite mixed-moment and counting core

`Main.lean` uses Lean 4.31.0 with Mathlib. The attached ledger claim is
`PC_FORMAL_CORE`, not `PC_HM`.

`PoissonCore.vacant` is the real-valued zero-one indicator that a finite
atom set is disjoint from a finite hit set. `vacant_union` proves the
indicator multiplication law for ordinary set union. No disjointness
between the two tested sets is assumed.

`mixed` recursively expands a centered product by replacing the first
factor with its union contribution minus its centering contribution.
`exact_centered_mixed_moment` quantifies over an arbitrary atom type with
decidable equality, arbitrary finite weighted sample set, arbitrary real
weights and center, arbitrary hit sets, and an arbitrary **list** of
tested finite sets. Lists may repeat sets in any positions. It equates
the recursion applied to the weighted vacancy function with the weighted
sum of the original centered products. It needs no probability or
positivity assumptions: consequently it also applies to every finite
probability law on hit patterns induced by independent Poisson counts.
The identification of that vacancy function with
`exp(-L * mass(union))` is proved from the Poisson law in the report,
not encoded in this declaration.

`restricted_pair_sum_le_product` quantifies over arbitrary two finite
choice sets, nonnegative real weights on those sets, and any binary
compatibility predicate. It bounds the restricted weighted pair sum
by the product of the unrestricted marginal sums. In the static count,
the predicate must still enforce distinct directions and compatibility
with the uniquely determined block before this enlargement. The theorem
does not manufacture that uniqueness.

`root_exponent` proves, for arbitrary integer root and vertex counts,
that `10*r <= h` implies `5*(2*r-h) <= -4*h`.
`nonsimple_margin` proves the affine attenuation inequality for every
rational component size at least two.
`final_exponent_margin` proves the final exponent comparison for
arbitrary nonnegative real total scale and overhead at most one tenth
of that scale.

These are universal, hole-free algebraic statements, not sampled tests.
They do **not** formalize the root-selection existence argument,
Poisson independence, geometric preparation, the complete static
certificate enumeration, its polynomial overhead, the analytic
high-moment theorem, novelty, or any Ramsey bound. Those parts require
independent reading of `report.md`; a compiler success on
`PC_FORMAL_CORE` must not close `PC_HM`.
