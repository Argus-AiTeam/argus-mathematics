# Statement fidelity: C277_TRANSFER

This document describes `Main.lean`, namespace `ConditioningBridge`. The
principal declaration is `conditioning_to_threshold_at_every_length`.
`conditioning_to_threshold` is its equivalent unnormalized version, and
`threshold_supremum` gives the supremum conclusion without an attained maximum.

## Objects and probability

`BinaryLaw` on a finite coordinate type carries an arbitrary real-valued
probability mass function on **all Boolean coordinate strings**, with
nonnegative masses and total mass exactly one. It need not have rational
masses, positive masses at every string, exchangeability, or any independence
between its coordinates. `prob` is the ordinary finite event sum.

`wins` counts true coordinates. `tested C` requires every coordinate in the
finite set C to be true. `testProb` is precisely p_C. Every C is already a
subset of the finite coordinate universe; `C.card < Fintype.card` is
equivalent to properness. The principal theorem uses a nonempty coordinate
type, hence includes exactly positive repetition lengths.

`conditionalMean` is the sum, over coordinates outside C, of the joint
probability of that coordinate and `tested C`, divided by p_C, then divided
by the number of untested coordinates. On the required hypothesis p_C > 0
this is exactly the manuscript's average conditional success probability.
`remainingMass_eq_marginal_sum` and `conditionalMean_eq` prove the finite-sum
identity connecting this to the unnormalized `remainingMass`. The denominator
is a real subtraction of cardinalities; for a proper set it is strictly
positive and equals the cast of the natural remaining cardinality.

## Quantifiers and hypotheses

`LawFamily` is any predicate on finite binary laws, across all finite
coordinate types in `Type`. This includes the types `Fin k` for every
natural length, and the product types needed in the proof. `TensorClosed`
requires this family to contain each independently repeated product of each
of its laws. This is a closure hypothesis on the model, NOT a threshold or
sampling conclusion.

The product itself is fully implemented: `tensorLaw mu N` assigns a string x
on `Fin N x coordinates` the mass

    product_j mu.mass (x restricted to block j).

Its nonnegativity and normalization are proved. `tensor_block_event` proves
that all blocks satisfying any fixed event have exactly the Nth power of
its original probability. `wins_tensor`, `tensor_tail_event`, and
`tensor_tailProb` prove the global-threshold inclusion and its probability
consequence. These statements also cover N = 0; amplification uses N = K+1.

The real parameters obey

    0 <= v,  0 < delta < 1-v,  L >= 0,  0 < T <= delta/4.

The input is quantified over EVERY nonempty finite coordinate type, EVERY
admissible law, and EVERY proper C with p_C > 0:

    (log(1/p_C) + |C| L)/(n-|C|) <= T
       implies conditionalMean <= v+delta/4.

No selection lemma, large-length tail bound, desired concentration bound,
or independent-copy probability inequality is assumed in the main theorem.
The first is proved by `upper_tail_selection`; the second by
`large_length_threshold`; the independent-copy probability inequality follows
from the explicit product law. `all_lengths_of_large` applies that product
construction to remove the large-length cutoff.

## Conclusion and exact manuscript specialization

For every admissible law on every nonempty finite coordinate type, the
principal declaration concludes

    Pr[wins >= Nat.ceil((v+delta)*n)]
        <= exp(-(delta*T/(16*(1+L)))*n).

`tailProb_eq_ceil` proves the threshold conversion, rather than assuming a
rounding heuristic. The threshold is positive under the hypotheses, so its
natural ceiling is the manuscript's nonnegative integer ceiling.

Set L = log d with integer d >= 1. This includes d = 1. Then L >= 0,
and the displayed hypothesis, constant, properness, and conclusion agree
with Proposition `conditioning-to-tail` in
`build/sections/04-threshold.tex`. Finite-dimensional repeated-game
strategies give a family of these laws. Their product-strategy closure is
justified explicitly in `proof.md`; the quantum-strategy representation
and tensor-product operator identities are not encoded in Lean.

`threshold_supremum` takes the supremum of all admissible tail
probabilities, assuming that the family at that length is nonempty, and
proves the same upper bound. It assumes neither compactness nor existence
of a maximizing law or strategy.

## Supporting declarations and boundary of certification

`sum_draw_tested_indicator` proves the exact sampling-with-replacement count,
including repeated coordinates and zero draws.
`finite_weighted_selection` and `upper_tail_selection` select an actual
finite tested set. `remainingMass_lower_of_card_le` is the lower bound on
untested wins needed in the contradiction. `sampling_length` proves both
the ceiling-length upper bound and the exponential-power inequality.
`rate_arithmetic` proves the numerical estimates at the precise constant 16;
its proof uses the elementary bound q log(1/q) <= 1-q in place of the
manuscript's stronger bound 1/e. `large_length_threshold` proves a cutoff
uniform over the entire family, not a cutoff depending on the law.

`fifth_power_rate` is only the exact algebraic substitution of
T = (delta/(4 B))^4 into the generic rate. It does NOT formalize the
external fourth-root conditioning theorem.

The certificate establishes a universal finite-probability transfer, not
an unconditional formalization of entangled-game parallel repetition.
Song's Definition 4.3 and Lemma 4.4 were checked for statement applicability
in `primary_source.md`; their smooth sampler and the imported Chapter 6
state-alignment/history-sampling machinery remain external quantum input.
An independent Reviewer must check this interpretation and the primary
source reading. Compilation alone does not establish statement fidelity,
the validity of that external machinery, or novelty/significance.
