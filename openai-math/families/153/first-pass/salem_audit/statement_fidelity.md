# Statement fidelity: SalemAudit universal core

This file describes `research/salem_audit/Main.lean`. It does not claim that
the whole singularity theorem has been encoded in Lean. The full analytic
proof is in `report.md` and requires independent human review.

All numerical constants in the Lean source are exact real rational numbers.
`r = 20301/10000` and `g = 21/10`; natural-number powers are ordinary powers.

## Independent, possibly biased signs

`bias_identity` identifies the squared modulus of
p(c+is)+(1-p)(c-is) with c^2+((2p-1)s)^2 for arbitrary real p,c,s.
`bias_bounds` assumes 0 <= p <= 1 and c^2+s^2=1 and proves that this
squared modulus is between c^2 and 1.
`finite_bias_product` proves the lower product inequality for every finite
length n and arbitrary real sequences p,c,s. It does not assert independence
or convergence; those hypotheses are supplied when applying the finite
product calculation to characteristic functions in the report.
`centered_sign_variance` assumes 0 <= p <= 1 and computes exactly the variance
of a sign of mean 2p-1 as 4p(1-p), including its bounds between zero and one.
Endpoints p=0 and p=1 are included.

## Uniform floor and infinite recurrence

`floor_partial_sum` is for arbitrary real sequences a,d indexed by all natural
numbers. If a(n+1) >= a(n)-d(n) for every n, it proves
a(n) >= a(0)-sum_(i<n)d(i).
`uniform_floor` adds the uniform partial-sum bound
sum_(i<n)d(i) <= a(0)/2, for every n, and concludes a(n) >= a(0)/2
for every n. Positivity of a(0) is not encoded because this is an inequality;
the application has a(0)=gamma_1>0. The report, not this theorem, establishes
the summability of the actual cosine decrements.

`affine_iteration` and `growth_iteration` prove universal induction bounds,
not bounds at a tested finite horizon.
`normalized_loss_bound` quantifies over all real sequences s,L and all
R,G,C with R>1, G>0, C>=0, s(n)>=0, and L(0)>0. Its two recurrences are
s(n+1) <= R*s(n)+C and L(n+1) >= G*L(n), for every n.
It proves, for every n,

    0 <= s(n)/L(n)
       <= (R/G)^n * (s(0)+C/(R-1))/L(0).

`normalized_loss_tends_to_zero` adds R<G and proves the real limit
s(n)/L(n) -> 0 as n tends to infinity. In particular,
`manuscript_loss_limit` instantiates R=2.0301 and G=2.1.
For the manuscript application the sequences start at m=3, so s(n)=S_(n+3)
and L(n)=L_(n+3); the finite step from m=2 does not affect the limit.
Neither theorem assumes the conclusion, a bounded search horizon, or an
unproved external mathematical axiom.

## Construction thresholds

`bootstrap_margins` quantifies over real L,X,L' with L>=100.
It verifies both initial branches and the improved branch of the return-time
construction from their explicit logarithmic lower estimates.
Here X represents log K, not K. The theorem does not prove Dirichlet's
pigeonhole assertion, which is proved directly in the report.
`linear_term_absorption` quantifies over D>=0 and x>=16(D+1), proving
Dx+1 <= 9x^2/64. Together with exp(3x/4) >= (3x/4)^2/2, this absorbs the
linear contribution to K. The exponential inequality is proved/used in the
report and is not part of this polynomial declaration.

The source contains no assertion about the arithmetic classification or the
degree-31 example. A successful compiler run certifies only these named
universal cores. Statement fidelity and the application of these cores to the
manuscript are separate, reviewable mathematical responsibilities.
