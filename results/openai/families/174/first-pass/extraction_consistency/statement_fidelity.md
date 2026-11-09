# Statement fidelity: ExtractionConsistency

`Main.lean` formalizes both the universal finite matrix-interpolation and
counting core, claim `C_TC_CORE`, and the abstract compact consistency theorem,
claim `C_TC_COMPACT_CORE`. The latter has explicit Brouwer and graph-interface
hypotheses. It is not a formalization of the entire thin-tree conjecture.
This distinction is intentional and must survive review.

## Objects and definitions

`V` is an arbitrary finite coordinate type with decidable equality. Real
matrices have type `Matrix V V R` with `R` the Lean real field. Positive
definiteness is Mathlib's `Matrix.PosDef`, not entrywise positivity.
`resistance X b` is the actual inverse quadratic form
`b dot (X inverse * b)`, with no pseudoinverse convention.
`quadratic X z` is `z dot (X*z)`. Incidence columns are arbitrary real
vectors in the formal theorem; substituting oriented graph incidence columns
is a specialization, not an additional formal assumption about graphs.

`J` is an arbitrary finite response index type, `E` an edge index type,
and `B : Finset E` the finite crossing set. Parallel edges can have separate
indices. The weights `w` are nonnegative and sum to exactly one. Every
response `Y j` and the mixture `sum_j w j * Y j` are explicitly positive
definite. In the application the latter follows because the mixture belongs
to K. The explicit assumption prevents the totalized matrix inverse from
masquerading as the inverse of a singular matrix.

## Declarations and quantifiers

`quadratic_nonneg`, `resistance_nonneg`, and `inverse_mulVec` establish the
positive quadratic forms and actual inverse cancellation under positive
definiteness. `resistance_cauchy` proves the inverse-metric Cauchy--Schwarz
inequality for every column and direction; `response_quadratic_bound`
converts a resistance upper bound into the rank-one quadratic inequality.
`scaled_quadratic_resistance` proves the converse scaled implication for
every positive scaling g and nonnegative a, including zero incidence columns.

`weighted_energy` is the exact universal weighted sum of directional
rank-one inequalities, not a floating-point convexity experiment.
`badMass` sums weights with the strict predicate `a < resistance (Y j) (b e)`.
Thus good response edges use the inclusive threshold `resistance <= a`.
`mixture_resistance_bound` proves for every edge that bad mass at most
theta, theta < 1, entails mixture resistance at most `a/(1-theta)`.
This is not the generally invalid assertion that matrix inversion commutes
with taking an average.

`total_bad_mass` derives the weighted total mass bound from the actual
per-response cardinality inequalities. `finite_markov_retention` proves
that a finite subset G of B has mass at most theta on every edge and obeys
`theta*(|B|-|G|) <= delta*|B|`. It does not assume the desired retained
cardinality. Zero weights and the empty crossing set are allowed.

`retained_crossing_bound` is a universally quantified real arithmetic
theorem. Its parameters satisfy `0<q<r`, `delta>=0`, `theta>0`, `d>=0`,
`delta*r <= theta*(r-q)`, `r*d<=M`, and
`theta*(M-c)<=delta*M`. Its conclusion is `q*d<=c`.
In the graph application d denotes the number of partition parts minus one,
not the number of parts. Real q and r in this lemma generalize the
application's positive integers.

`finite_response_forces_crossings` combines the matrix, finite sum,
Markov, and packing-slack inequalities. For every finite crossing set B
and response family as above, with `0<theta<1`, `a>0`, and each response
having at most `delta*|B|` bad edges, it proves that the actual mixture
has at least `q*d` B-edges with resistance at most `a/(1-theta)`.
The original crossing lower bound is `r*d<=|B|`.
In particular this contradicts the strict maximal-packing obstruction
when the finite responses are responses to centers with a common partition.

`dyadic_sum` proves the exact sum of dyadic upper bounds for every
natural exponent. `dyadic_tail_bound` then proves the uniform factor 4
for every finite sequence satisfying those bounds. It does not assume
the tail inequality that it concludes.

`endpoint_parameter` proves for all real `a>0`, `u>0`, `0<=delta<u`,
and `t>a*u/(u-delta)` that a theta exists with
`0<theta<1`, `delta<theta*u`, and `a/(1-theta)<t`.
`endpoint_identity` identifies the two rational forms of the endpoint
under their nonzero denominator hypotheses.
`endpoint_at_most_twice` proves the quantitative comparison whenever
`a>=0`, `u>0`, and `delta<=u/2`.

## Compact consistency declarations

`nearby_response_fixed_point` works for every convex matrix set K, every
arbitrary (possibly discontinuous) function `response : K -> K`, and every
positive radius. Assuming the explicit fixed-point property for continuous
K-valued self-maps, it constructs an x in the convex hull of responses to
centers in that radius about x. The continuous approximation is constructed
with Mathlib's partition-of-unity theorem; it is not assumed to exist.

`finite_pattern_stability` proves local stability of every threshold
comparison for an arbitrary finite family of continuous real scores at a
point avoiding that threshold. The common neighborhood is derived, not
supplied as an extra uniform-stability assumption.

`threshold_consistency` is universally quantified over K, finitely many
coordinate and edge indices, the actual inverse resistances, crossing sets B,
and a predicate `Packed x s`. Its scalar assumptions are `a>0`, `u>0`,
`0<=delta<u`, `0<q<r`, and `r-q=u*r`, the latter being equivalent to
`u=1-q/r` since r>0. Its conclusion is the inclusive endpoint
`exists x in K, Packed x (a*u/(u-delta))`.

The geometric hypotheses are compactness and convexity of K, positive
definiteness of every matrix in K, continuity of each actual resistance
function on K, and the explicit Brouwer fixed-point property. Nonemptiness
is implied by that fixed-point property; it is not needed as a second
independent premise. In the graph application K is explicitly nonempty.

The graph-interface hypotheses are: B depends only on the finite threshold
pattern; Packed is monotone in its threshold; the subset of K times R where
Packed holds is closed; and failure of Packed at a positive threshold
supplies d>0 with `r*d<=|B|` and fewer than `q*d` B-edges in the threshold
graph. In the manuscript d is the number of maximal partition parts minus
one, B includes all original crossing edges, and Packed means existence
of q edge-disjoint spanning trees. The scalar, graph-interface, and
fixed-point hypotheses are not hidden axioms or asserted compiler results.

The response premise has exactly the order
`forall x in K, exists y in K, forall s>0`, with bad predicate `a<R_y(e)`
and cardinality at most `delta*|B_x(s)|`. The theorem constructs a sequence
of convexified nearby responses, extracts a convergent subsequence,
derives a regular threshold and common crossing pattern, applies the
finite matrix theorem, and contradicts the strict obstruction. It then
uses the explicitly closed packing predicate to prove the inclusive
endpoint, including delta=0. None of these topological interpolation
or endpoint steps is replaced by a finite experiment.

## What this compiler run does not verify

No declaration in this source proves Brouwer's theorem, constructs the
particular graph's K, or proves continuity of matrix inversion. Brouwer is
an explicit external theorem premise, while compactness and resistance
continuity are explicit geometric hypotheses. No declaration constructs
maximal tree-packing partitions, proves their obstruction or the closedness
and monotonicity of the graph packing predicate, constructs the laminar
hierarchy, or proves Nash--Williams--Tutte. The application of these exact
interfaces and the hierarchy input has complete mathematical arguments in
`proof.md` and explicit dependencies in the ledger; those interpretations
still need independent mathematical review.

In particular the per-response count hypotheses of
`finite_response_forces_crossings` and `threshold_consistency` are discharged for the manuscript
application by the separate hierarchy-to-response proof in `proof.md`,
not by an undisclosed formal proof or by finite testing. The hierarchy
estimate is an external input. Neither its appendix nor the full
thin-tree theorem or the polynomial-time algorithm is compiler-certified
by this file. A successful compilation supports `C_TC_CORE` and the explicitly
conditional `C_TC_COMPACT_CORE`, not an unconditional machine proof of all
the claims mentioned in the prose.
