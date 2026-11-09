# Statement fidelity: extended-rank sector transfer

The declaration `FiniteConvexity.sector_rank_bound` quantifies over an
arbitrary type of sectors, an arbitrary finite subset `s`, a decidable
active-sector predicate, arbitrary natural-number multiplicities `N`,
arbitrary extended nonnegative ranks `r`, and an arbitrary extended
nonnegative controller rank `b`. Its hypotheses require exact zero rank
in every inactive sector of `s`, and `r e <= N e * b` in every active
sector of `s`. Its conclusion bounds the unnormalized sum of sector
ranks by the sum of the active natural multiplicities times `b`.

The type `ENNReal` includes infinity and has the convention `0 * infinity
= 0`. In particular, the theorem does not assume that `b` is positive
or finite and does not divide or cancel an extended rank.
`zero_controller_rank` specializes the conclusion to controller rank
zero. `cap_rank_bound` and `cap_rank_finite` specialize to `b <= 1`,
giving respectively the finite natural-number bound and strict
finiteness. `inactive_zero_cannot_be_omitted` checks the scalar witness
`1 <= 0 * 0` is false; it is not a counterexample to the manuscript.

For Proposition `tc:finite-convexity`, fix a test index `i` and a trace
`tau`. The sectors are subsets `E` of the finite test set; a sector is
active when `i` belongs to `E`. Substitute
`r E = d_tau(H_E(s_i))` (or `d_tau(H_E(s_i^2))`),
`b = d_tau(b_i)`, and `N E = N_{E,i}`. Exact source-quotient
vanishing supplies `hzero`; the fixed hereditary support supplies
`hbound`. Thus the formal theorem checks precisely the extended-rank
summation step, including the zero-controller and infinite-controller
cases.

The compiler does not construct the completely positive maps, prove the
Cuntz comparisons, identify ranks of operators with these scalars,
construct measurable fields, establish trace continuity, or apply
Hahn--Banach. Those analytic and statement-interpretation obligations
are proved in `proof.md` and remain subject to independent review.
This source is not a formalization of the entire proposition or of the
classification theorem.
