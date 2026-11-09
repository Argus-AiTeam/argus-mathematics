# Scope of the Lean statements

The declarations in `Main.lean` certify four algebraic or convergence
obligations used in the normalized-height proof. They do **not** formalize
Radon measures, weak convergence of squared height measures, fractional
integrals, or Proposition `prop:height-equation` in its entirety. In
particular, the compiler verdict must attach to `NHB_FORMAL`, not to
`NHB_GOAL`. The analytic proof is `bridge.md` and needs independent
mathematical review. All declarations below belong to the
`NormalizedHeightBridge` namespace.

`cutoff_identity` quantifies over all four real
numbers `U,V,a,b`, with no sign restrictions. They stand for the two
centered unnormalized heights and the two cutoff values. Its conclusion
is exactly equation `eq:height-cutoff-identity` of Section 04, including
the negative sign on the cutoff error.

`cutoff_error_bound` has the same unrestricted
real variables and proves
`abs(U*V)*(a-b)^2 <= (U^2+V^2)*(a-b)^2/2`. This is the symmetric
second-moment bound on the signed cutoff error. The theorem does not
silently assume that the two heights have the same sign.

`pairwise_variance` quantifies over every finite
index type, including the empty type, and all real weights and values
`p,x`. It proves that the weighted double sum of squared differences
equals twice the mass times the weighted second moment minus twice
the square of the weighted first moment. Nonnegative weights and
positive total mass are not needed for this identity. The integral
cell-variance formula in `bridge.md` additionally uses Fubini, positive
cell mass, and division by twice that mass; those measure-theoretic
operations are not encoded in this declaration.

`mean_correction_limit` quantifies over an
arbitrary index type, filter, real sequences/functions `a,b,c`, and
finite real limits `a0,b0`. The hypotheses are convergence of `a` to
`a0`, `b` to `b0`, and `c` to zero, all along the same filter. The
conclusion is convergence of `a-c*b` to `a0`. In the analytic proof,
`a` and `b` are the pairings of the original test and the correction
bump under the **same fixed normalization**. No rate relating `c` to a
height parameter or to a normalized origin value occurs in this
statement. Proving that the bump pairing has a finite limit remains
the analytic obligation, not a Lean hypothesis already known to hold
for every conceivable normalization.

`two_stage_vanishing` quantifies over three
real sequences `f,a,b`. It assumes nonnegativity of `f`, convergence of
`a` and `b` to zero, and, for every fixed index `m`, an eventual bound
`f(j) <= a(m)+b(j)`. It concludes `f(j) -> 0`. The threshold in `j` may
depend arbitrarily on `m`; no joint convergence rate is assumed. The
application is the difference of the source and limiting pairing,
where `m` selects first a fixed large localization (or a small cap)
and `j` then tends to infinity. The analytic tail and diagonal
estimates are required to supply this bound.

No declaration asserts novelty, publishability, independence of
review, or the manuscript's main uniform-rectifiability theorem. Lean
proves the encoded statements, not this interpretation document; an
independent Reviewer must check this interpretation.
