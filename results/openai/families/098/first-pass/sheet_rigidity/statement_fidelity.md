# Statement fidelity: `C_SR_KERNEL`

`Main.lean` uses Lean 4.31.0 and Mathlib. It proves an all-parameter
analytic-interface theorem, not an unconditional formalization of the Hilbert
construction or the Banach-space corollary.

## Objects, hypotheses, and quantifiers

`compact_lexicographic_control` quantifies over one compact set
`K : Set (Real x Real)` and fixed reals `A,B`. Every first coordinate is at
most `A`; on the fiber with first coordinate exactly `A`, every second
coordinate is at most `B`. For each positive epsilon it produces one positive
delta, uniform over every point of K. Nonemptiness and attainment of (A,B)
are needed to obtain these constants from the manuscript, not to prove this
conditional lemma.

`pointwise_envelope` and `expectation_envelope` give
`t <= B+epsilon+(C/delta)(A-s)`, first pointwise, then under any probability
measure on any measurable space. The expectation theorem assumes integrability
of both coordinates, almost-everywhere K membership, `B,C,epsilon >= 0`,
and `delta > 0`. Its explicit near-fiber hypothesis comes from
`compact_lexicographic_control`; it is not an assumed expectation limit.

`horizontal_energy_bound`, `horizontal_deficit_bound`, and
`vertical_energy_bound` are scalar consequences of the variance identity.
Their variables `m,u2,v2,cross,variance,energy` denote moments, squared reference
norms, the scalar inner product of the reference vector with the mean error,
mean-square variance, and derivative-difference energy. The hypotheses are
the exact variance equality, upper moment/mean-error bounds, reference norm
deficits, nonnegative variance when used, and the factor-two squared-error
comparison. No convergence is a hypothesis.

`energy_converges` keeps K,A,B,D fixed and allows the probability measures
`mu n`, integrable fields `s n,t n`, and all energies to vary with n. Here
`H = W^2 E_H`, `V = E_V`. It assumes the following *raw*, finite-n inequalities:

1. H and V are nonnegative, and `H n <= hRaw n`.
2. `A - integral(s n) <= etaRaw n`.
3. `V n <= 2*(integral(t n)-B)+vRaw n`.
4. The three explicitly supplied raw error envelopes tend to zero.

It proves `H+V -> 0`, rather than assuming either energy convergence. The
compact-set theorem supplies delta after epsilon is fixed; delta has no rate.
The same delta is used for every n, measure, sheet, and reference derivative.
`horizontalRaw`, `deficitRaw`, `verticalRaw`, and `manuscript_raw_limits`
give and prove convergence of the manuscript's three rational envelopes.
`manuscript_raw_limits_positive` proves the shifted limits for n+1.
Instantiate `energy_to_crossing` at natural index m with the manuscript's
data at n=m+1. Thus no artificial zero-energy line system at index zero
is needed, and every formal index corresponds to a real positive level.

`mean_line_choice` assumes a nonnegative integrable real energy on a probability
space, an arbitrary full-measure predicate `good`, and mean at most b>=0.
It produces a good point with energy at most 2b. The case b=0 is proved
separately by zero integral implying zero energy almost everywhere.

`LineSystem N E sigma D o` is **upstream analytic data**, not a crossing
conclusion. It contains probability measures on the row/column coordinates,
integrable nonnegative line energies with means at most N*sigma, arbitrary
full-measure good-coordinate predicates, and squared oscillation inequalities
on good lines. For the analytic instantiation, clamp both coordinates to the
closed period block first, then use the original offset wherever its label
is permitted; only elsewhere may the extension be arbitrary. Thus the
all-real-coordinate oscillation hypotheses follow from the segment bounds.
Its `crossing` field is the
manuscript's *source-point lower Lipschitz bound at a single cross-color
intersection*, weakened from sqrt(2) to 7/5. It is not separation of the
selected reference offsets. Its `radius` field is the original offset bound.
N is one fixed natural number. The target E is any pseudometric space;
the Euclidean norm metric is a specialization.

`small_transport` and `select_crossings` prove that if
`128*N^3*sigma < 1`, then simultaneous line choices produce a *single* family
`z : Fin N -> E`, all at distance at most D from o and all distinct pairs at
distance greater than 1. Squared oscillation bounds and the energy means
produce the transport bounds; these are not assumed as a separated-offset
conclusion. No differentiability at an intersection is needed.

Finally `energy_to_crossing` combines the K-valued moments, the three raw
vanishing envelopes, and a `LineSystem` for each n into
`eventually n, exists z, all radii <= D and all distinct pairs > 1`.
It does **not** take energy convergence or existence of such z as a hypothesis.
Its eventual quantifier is outside every pair quantifier, so separation is
simultaneous, not a separately chosen subsequence for each pair.

## Analytic boundary and what was not formalized

The proof in `proof.md` derives every interface hypothesis from the manuscript:
good derivative points from Rademacher and Lebesgue differentiation; endpoint
mean estimates from the fundamental theorem for Lipschitz line restrictions;
the variance equality, mean-error Cauchy-Schwarz, and factor-two norm
comparison; selection of a common period block; and Fubini disintegration
of block energy into row/column line energies. The compiler checks the
probability-space mean selection including full-measure exceptions, but not
this geometric disintegration or the line-integral Cauchy-Schwarz
instantiation. The compiler also does not check the construction/doubling
proof, recurrence of levels, Rademacher theorem's local application,
Euclidean volume comparison, external source fidelity, mathematical novelty,
or this document's reading of the declarations. These remain explicit human
proof/review obligations, not hidden axioms or claimed compiler achievements.
