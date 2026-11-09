# Known characteristic-zero free odd-generator lower bound

**Engineer assessment: supported as an attributed known result, not an
original Argus contribution or an upper-bound proof.**

## Exact source and hypotheses

Old `C_LOWER_KNOWN` versions 1 and 2 have the same mathematical assertion;
version 2 adds `A_WILLWACHER_FREE`. The cited source is Willwacher,
*On free generators in the Grothendieck-Teichmueller Lie Algebra*,
**arXiv:2607.18793v2, Theorems 1.1 and 1.2**.

The statements concern a characteristic-zero field `K` and homogeneous
odd-weight elements of `grt_1(K)` with nonzero depth-one coefficients.
The first theorem provides a free odd-generator family; the second gives
freeness for any family satisfying the stated homogeneity and nonzero
depth-one condition. The generators have weights `3,5,7,...`.
This is not a statement about arbitrary elements without that coefficient
condition, nor about characteristic two.

## Why it gives the claimed comparison

With the standard equation-space identification of rational `grt_1` with
`W`, the free graded injection gives

    dim_Q FreeLie_Q(e_3,e_5,...)_n <= dim_Q W_n.

Here the bracket on `grt_1`/`W` is the Ihara bracket, not an assertion that
the equation space is a subalgebra for the ambient two-generator
commutator. "Ordinary free Lie" excludes a restricted-power operation; it
does not identify those two brackets.

The direction of this inequality is decisive. A free subalgebra does not
bound the rest of `W` from above. Combining this independent injection
with a faithful rational upper bound gives equality of the finite graded
dimensions; the upper-bound compiler endpoint by itself supplies neither
this injection nor its attribution. In particular it does not independently
certify the manuscript's later categorical construction.

## Existing attribution evidence and the stale citation label

The archived receipt is

    OLD/research/literature/83e0394a9fda52f7792923623be6f4b6.json

with `OLD` as defined in the first report. It contains the passages read at
the stated theorems, including the coefficient/characteristic hypotheses.
The old ledger binds the assumption
`A_WILLWACHER_FREE` to an Engineer filing and records distinct
`reviewer:gpt-6.1-sol` literature support, evidence
`citation-A_WILLWACHER_FREE-ba924f40a200`. This is independent historical
attribution, not the current Engineer checking its own new citation.

The earlier `CERT/citation_status.json` says unchecked. The later
source/excerpt-bound literature evidence supports the attribution despite
that unchanged summary. A registry resolution alone would not have done so;
the archived statement and independent reading are the relevant evidence.
This assessment reuses that evidence rather than fabricating a new lookup
or changing the old ledger. The old ledger itself matches its preserved
snapshot; the literature file is a listed read-only inventory input, not
one of that manifest's eleven family entries.

## Disposition and limits

The contextual lower-bound claim and its attribution are supported on the
stated archived evidence. The proof of Willwacher's theorem was not
reconstructed here, and no new primary-source retrieval is claimed.
The known result is a declared external input in the historical ledger,
not part of the upper-bound theorem's Lean axiom closure and not evidence
of novelty. The source-version/theorem identity and its hypotheses, not a
generic paper citation, determine the supported scope.

There is no new mathematical obligation within this bounded attribution
assessment. The native independent Reviewer must still decide whether the
complete current review meets its contract; the historical citation judgment
does not self-accept this mission.
