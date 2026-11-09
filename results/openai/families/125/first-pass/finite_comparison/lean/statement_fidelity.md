# Statement fidelity: algebraic and directed charging core

The declarations are in namespace `FiniteComparison` in `Main.lean`. All
scalar variables are real. Finite sums range over an arbitrary `Fintype`;
weights are nonnegative, may vanish, and are not assumed uniform.

`comparison_excess` encodes a single directed column. Its hypotheses are
`0 <= q <= 1`, `u <= R(1-P)`, and `R(1-Pq) <= D+Z` **only if q<1**.
Its conclusion bounds `(1-q)R+qu-D-Z` by zero for q<1 and by
`max(u-D-Z,0)` for q=1. There is deliberately no comparison hypothesis at
q=1, no symmetry, and no hidden radius bound.

`row_excess` takes an arbitrary finite weighted row with total weight one,
weighted mean Z equal to one, and r the weighted mean of q. From the preceding
column hypotheses, C>=0, and a stated upper bound on F, it deduces the
weighted q=1 excess bound. It does not assert that F is the manuscript's
contribution without the algebraic identification given in the report.

`positive_radius` assumes r in [0,1], P<1, 1-Pr>0, C>0, F>0, the
row upper bound, and the denominator-cleared first scalar bound on u.
It proves `(1-Pr)R>D+1` and `u<=R(1-P)`. These hypotheses are explicit;
this is not a claim that arbitrary positive F satisfies them.

`donor_threshold` assumes C,r,G>0, L>=0, K<=DG, the scalar charge
inequality, and the exact numerator identity for u-D. It proves u-D<=H
for an arbitrary real beta. It therefore applies both to the printed
beta=1.6 and to the independently certified beta=1.59; it does not prove
the scalar inequalities by itself.

`paying_charges` is the weighted finite directed cancellation theorem.
It assumes outgoing charges vanish at nonpositive rows, incoming charges
vanish at positive rows, positive rows are bounded by outgoing charge,
and every nonpositive row plus its incoming charge is nonpositive.
It concludes that the weighted sum of F is nonpositive. Charge symmetry
and strictly positive weights are not assumed. Total weight one and
nonnegativity of the charge are unnecessary for this abstract implication.
The report derives these input inequalities from the manuscript's constants
and scalar estimates rather than assuming them for the finite theorem.

`quadratic_zero_constant`, `quadratic_discriminant`, and
`quadratic_endpoints` prove the three scalar sign implications used after
the eta Bernstein conversion. The discriminant criterion covers every real r;
the other two cover r in [0,1]. `bernstein_cubic_nonnegative` and
`bernstein_cubic_partition` encode nonnegativity and unit sum of the
degree-three Bernstein basis used for w=(1-x)eta.

Scope: this file formalizes load-bearing algebra and finite combinatorics,
not the defining exponential integrals, interpolation remainder theorem, all
printed coefficient computations, the full finite inequality as one Lean
declaration, or either complete approximation algorithm. The exact rational
computations are checked separately by `../verify.py`; the remaining analytic
and statement-identification reasoning is in `../report.md` and needs an
independent human Reviewer. A compiler success alone is not full verification
of those unformalized parts or evidence of novelty or publishability.
