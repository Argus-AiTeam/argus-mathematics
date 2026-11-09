# Statement fidelity: finite-law pair bound

The declarations described here are in `PairBoundCertificate` in `Main.lean`.
This document describes a universal theorem, not an extrapolation from tests.

## Objects and quantifiers

`pair_bound_60000` quantifies over every `FairPairs.Law` `nu`, every natural
number `k` with `1 <= k`, and every real `rho` with `0 < rho`.
`Law.support` is an arbitrary finite set of real numbers, and its atom weights
are strictly positive and sum to one on that set. Values of `Law.prob` outside
the support are never used. This represents every finitely supported real
probability law by taking its actual positive-mass support. No rationality,
separation, lower atom-mass, support-size, or effective-depth restriction is
present. A singleton support is included.

`bitsEntropy nu` is `sum_x -p_x ln(p_x) / ln(2)`.
`gridBits nu rho` is the entropy of `floor(x/rho)`, also divided by `ln(2)`.
Thus the coarse cells are precisely the manuscript's half-open cells
`[j*rho,(j+1)*rho)`, including for negative real atoms and endpoint atoms.
`sumset nu k` is the image of all `Fin k -> nu.support` tuples under their
real coordinate sum: repetition is allowed and exact collisions are merged.

`FairPairs.capacity nu ell` uses one variable for each real ordered
representative `(x,y)` with `x < y` of an unordered pair. The distance band is
`2^(-ell) <= y-x < 2^(1-ell)`. A feasible variable is a nonnegative **real
weight**, not an integral matching decision, and half its weight is charged to
each endpoint. `capacity` is the supremum of feasible total weights.
The imported, compiled `capacity_attained` theorem identifies it with the
manuscript's maximum.

The conclusion of `pair_bound_60000` is exactly

    k * (H(nu) - H0_rho(nu))
      <= log_2 |k supp(nu)|
         + 60000 * k^4 * sum_{ell : 2^(-ell) <= 2*rho} c_ell(nu).

The displayed Lean sum is over `bands nu`, the finite image of all support-pair
distances under the dyadic band-index function. The proved declaration
`capacity_zero_outside_bands` shows that every omitted capacity is zero. The
possibly spurious index assigned to distance zero adds no pairs or capacity.
Consequently this is the full manuscript sum, not a truncated scale range.
Both dyadic inequalities use the manuscript's inclusive lower and exclusive
upper endpoints.

## Nontrivial refinement-to-capacity argument

`flag_bound` and `refinement_hit_bound` prove the entropy estimate after
observing the coordinate sum. Their independence hypothesis is pairwise
factorization of exceptional events under the law **before observing that
sum**. `cellwise_refinement` proves this factorization for the product law
conditioned only on the tuple of current cells. The observation of the sum
occurs inside the conditional entropy, not inside that factorization.
The second bad event is a function of the observed sum and is not charged a
binary-entropy flag.

`select_shift` and `select_variation` integrate explicitly defined closed-ball
indicators on the unit real circle. `choose_refinement` obtains a deterministic
translated fine grid with the required average cost. Appending its label to
the old label gives a nested partition. This is a different implementation of
the manuscript's randomized-cut argument; no hypothesis that a favorable
refinement already exists is assumed.

`center_jensen`, `fractional_band_witness`, `band_mass_bound`, and
`coupling_cost_bound` carry the cost to the original law's capacities.
The witness has weight `2*pi(x,y)` on the unordered pair represented by `x<y`;
its endpoint charge is exactly the corresponding marginal band mass.
`capacity_refinement` proves the complete one-step entropy-to-capacity bound.
`finite_refinements` constructs arbitrarily fine nested refinements by finite
induction. `separating_depth` obtains some terminal depth using only finiteness
of the support; its value is not a parameter of the final bound.
`finite_geometric_charge`, `band_charge`, and `total_charge` eliminate that
depth by an exact geometric bound.

`pair_bound_natural` completes the entropy chain using the actual finite
product law and the cardinality of the actual sumset.
`pair_bound_1000` divides by the proved-positive `ln(2)` and proves the stronger
constant `1000*k^4`. `pair_bound_60000` follows by monotonicity of the
nonnegative capacity sum. There are no additional mathematical hypotheses.

## Reused elementary library and limits of this certificate

The source imports only `OAI.MeasureTheory.SelfSimilar.ProductLaw`.
Its vendored closure consists of `Model`, `Basic`, `FiniteEntropy`, `FairPairs`,
and `ProductLaw`, from OpenAI/math revision
`4eaee87548250b2682affda7d05d947c05554bae`. These provide ordinary finite
entropy calculus, finite product-law identities, the capacity definition and
its elementary properties. They are compiled from the supplied source.
The closure is narrowed by replacing `FairPairs`' unused `TranslationGain`
import with `FiniteEntropy`. Identifier-only compatibility changes translate
the upstream Lean 4.34.1 names to Lean/Mathlib 4.31.0 names; theorem statements
and proof obligations are not weakened. `build_support.py` reproduces these
changes from the pinned primary sources.

Neither the upstream `SumsetBound` nor `FiniteRefinement` nor `GridCoupling`
module is imported or used. The complete refinement-to-capacity construction
is present in this `Main.lean`; the final theorem is not a re-export of an
upstream pair-bound theorem. The elementary scalar circle-volume arguments
are also proved in this source.

The two final `#print axioms` commands expose the axioms of the exact final
declarations. Only Lean's usual `propext`, `Classical.choice`, and `Quot.sound`
are acceptable; no `sorryAx` or user axiom is acceptable. The official compiler
record, not this document, determines whether compilation succeeded.

This formalizes the finite-law technical core only. It does not formalize or
certify the full self-similar dimension formula, prove novelty, or constitute
independent human Reviewer approval. The separate Python checks are exact
boundary-case replays and diagnostics, not the proof of universality.
