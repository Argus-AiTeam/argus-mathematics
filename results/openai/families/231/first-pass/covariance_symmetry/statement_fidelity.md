# Statement fidelity: finite covariance locality

Claim: `C231_COVARIANCE_LOCALITY`.

The declarations described here are
`CovarianceLocality.factorization_of_zero_rank_covariance` and
`CovarianceLocality.covariance_locality` in `Main.lean`.

Both quantify over arbitrary finite coordinate types A and B, including
empty types. A Boolean configuration on A is a function `A -> Bool`, with
the coordinatewise order `false < true`; likewise for B. `bit false = 0`
and `bit true = 1`. The decidable-equality instances impose no mathematical
restriction on finite types.

`Law A B` is an actual joint probability mass function on the two finite
Boolean cubes: all masses are nonnegative and their double sum is one.
`expectation` is its weighted finite sum. `covariance p f g` is exactly
E[f(X_A)g(X_B)] - E[f(X_A)]E[g(X_B)]. `NegAssociated p` assumes this
covariance is nonpositive for EVERY pair of increasing real-valued
functions on the two respective cubes. This is cross-block negative
association, not just nonpositive pairwise covariance. Full negative
association of an ambient binary law implies this hypothesis for any
two disjoint finite blocks.

`rank` is the sum of the 0/1 coordinates. The first theorem assumes zero
covariance of the two rank sums. Its conclusion, for EVERY pair of block
configurations x and y, is

    p(x,y) = (sum_v p(x,v)) (sum_u p(u,y)).

Thus it states product factorization of the entire finite joint law, not
only independence of individual coordinates. Its proof constructs the
increasing envelopes `rank +/- f` for arbitrary [0,1]-valued functions,
uses all four negative-association inequalities, and specializes to
single-configuration indicators.

The second theorem replaces the rank-covariance hypothesis by zero
covariance for EVERY cross-block coordinate pair. `rank_covariance`
proves that the former is the finite sum of the latter. The same full
factorization follows. This explicitly rules out the invalid inference
from pairwise independence alone: negative association remains an
essential hypothesis.

There are no assumed mathematical axioms beyond Lean/Mathlib's ordinary
foundations and no external theorem declared as an axiom. The probability
normalization and positivity are structural hypotheses of `Law`; the
algebraic argument actually works without needing them separately.

## What this compilation does not verify

The compiler does NOT verify real stability implies negative association,
symmetric homogenization, the strongly Rayleigh covariance-row estimate,
countable extension by cylinder events, finiteness/exhaustion of the
threshold-graph balls, posterior locality for Brownian histories,
martingale convergence, the joint innovation law, deterministic Picard
inversion, uniform-to-Wiener coding, Borel measurability, or the final
every-input/full-permutation-equivariant sampling theorem. These steps
are proved or explicitly cited in `theorem.md` and require mathematical
review. In particular this is a formal certification of the load-bearing
FINITE block-independence core, not a formalization of the whole sampler
and not a claim that the independence principle is new.
