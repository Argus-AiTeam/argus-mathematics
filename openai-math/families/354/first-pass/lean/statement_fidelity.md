# Statement fidelity: exact cap minimization and semiconcave interpolation

`Main.lean` imports the host's Lean 4.31.0 Mathlib workspace. It proves the
following assertions over the real numbers; it does not encode surfaces.

## Definitions and declarations

`NestingAudit.cubicCost a C P w` is
`a * (P - w)^2 + C * w^3`.
`NestingAudit.cappedCost a C P d w` is
`a * (P - w)^2 + C * (min d (max w 0))^3`.

`cubic_tangent_factor` quantifies over all real `a,C,P,q,w`. Under the
stationarity equation `3*C*q^2 = 2*a*(P-q)` it proves the exact difference
factorization
`cubicCost w - cubicCost q = (w-q)^2 * (a+C*(w+2*q))`.
No sign hypothesis is used in this identity.

`cubic_stationary_minimum` adds `a>=0`, `C>=0`, `q>=0`, `w>=0` and proves
that the stationary value at `q` is no larger than the value at `w`.

`capped_global_minimum` assumes real `a,C,P,d` are strictly positive,
`0<=q<=P`, and the same stationarity equation. It proves BOTH:

1. For every real `w<=P`, the capped cost is at least
   `min (C*d^3) (cubicCost a C P q)`.
2. There exists a real `w<=P` at which that lower bound is attained.

Thus it proves a global minimum including the cases `P<d`, `q>d`, and
the equalities at the thresholds; it does not assume either displayed
candidate is feasible. To apply it to the manuscript, substitute
`a=ell/Q^2`, `C=C0(h)`, `P=P(h)`, `d=.21`, and `w=P-Q*y`.
For `Q>0`, the constraint `w<=P` is exactly `y>=0`, and the quadratic
term is `ell*y^2`. The positive radical expression for `q_*` satisfies
the stationarity equation and `0<q_*<P` by the separate analytic
calculation in `research/nesting_obstruction.md`. That radical
calculation is NOT claimed to be a declaration in this source.

`semiconcave_uniform_bound` quantifies over an arbitrary real function
`f`, real `a,b,x,K`, with `a<b`, `a<=x<=b`, and `K>=0`. Its explicit
hypothesis is `ConcaveOn` the closed interval `[a,b]` for
`z |-> f z - K*z^2/2`. It concludes
`min (f a) (f b) - K*(b-a)^2/8 <= f x`.
This is the actual closed-interval interpolation rule, not a sampled
derivative test and not an assertion that `B` or `S` satisfies its
concavity hypothesis.

## Limits of this formal evidence

The source contains no definition of pi, `B`, `S`, a nested slice,
perimeter, flux, Jensen integration, curvature, or a torus minimizer.
It does NOT prove geometric containment, the upper second derivative
bounds for `B` and `S`, the 24 arithmetic knot enclosures, or the main
isoperimetric classification. Those have different, expressly named
evidence or remain separate obligations in `research/PROOF_GRAPH.json`.
Its compiler certificate is mechanical evidence only for
`L_FORMAL_ALGEBRA`, the algebra/interpolation subclaim.

The mathematical reading and its application are Engineer assertions
pending independent Reviewer inspection. A zero-hole compiler run
checks the encoded statements, not this document's interpretation.
