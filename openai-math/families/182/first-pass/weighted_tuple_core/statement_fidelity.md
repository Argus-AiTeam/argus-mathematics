# Statement fidelity: weighted tuple marking core

The declarations are in namespace `WeightedTupleCore` in `Main.lean`.
This is a universal finite combinatorial formalization, not a finite test.
It formalizes the delicate bridge in the manuscript, not its entire tuple law
or either main power-saving theorem.

## Objects and hypotheses

`B` is an arbitrary coordinate type, `P` an arbitrary word type, and `clean`
a finite set of currently unmarked coordinates. `shift : P -> P` is the
right-position shift. For the manuscript, `P` consists of permutation words
and `shift(q)=q c`. The hypothesis
`forall q, shift (shift q) != q` holds because the fixed cycle has length
`L>2`. The formal source does not prove that a permutation is an L-cycle;
this is an explicit instantiation obligation, proved in the report.

`witnesses clean shift u v` is exactly the finite set of coordinates
certifying the *directed* relation from `u` to `v`. The order of `u,v`
never reverses. `directed_edge_preserved` quantifies over every coordinate,
every old word `q,q'`, every pair of address functions and every threshold.
Updating the forgotten coordinate cannot delete a witness outside it.
`no_loops` and `no_opposite_edges` establish the graph simplicity assertions
under the stated no-two-cycle and strict majority hypotheses. No field labels
occur in these statements.

`crossing_transposition_has_larger_gap` quantifies over arbitrary natural
positions `i<j` and `a<b`. If exchanging `a,b` reverses the order of the cut
positions `i,j`, and is not their own exchange, then `b-a>j-i`.
It is the positional inequality used in strict diagonal dominance. Counting
the number of transpositions and the matrix argument remain in the report.

`product_domination` quantifies over all finite sets of oriented factors and
all real weights in `[0,1]`. Factor inclusion has the correct inequality
direction: the product over the larger old set is smaller. Matching the
actual edge factors to these sets is justified by `directed_edge_preserved`
and the entry bijection, not by an assumption of evenness of the weights.

## Concatenation and exact normalization

`concatenate` is the genuine bijection
`((U x Q) x I) <-> (U x (Q x I))`.
Here `U` is the new address type, `Q` the old plus words in the forgotten
block, and `I` the old list-index type. Thus *all* old plus entries, not just
their distinct field values, are retained.

In the restriction section, `V` is an arbitrary finite plus-slot set and
`Q,I` arbitrary nonempty finite types. `word : V -> Q` specifies the sublist
required by each actual slot. `prescribed word index` inserts that sublist
coordinate. `prescribed_injective` and `exact_restriction_card` give the
exact cardinality of this restriction, including zero plus slots.
`average` is the sum divided by the cardinality of its finite domain.
`restriction_average` proves the precise factor
`card(Q)^(-card(V))`, not a bound with a hidden constant.

`dominated_restriction` allows the old integrand to be bounded by the new
integrand on the restricted indices. `marking_bridge` combines this fact
with a given marked-cut quadratic-form lower bound. Its conclusion is
`Qform >= c * card(Q)^(-card(V)) * average old`.
For the manuscript, `card(Q)=r_*`, `card(V)=n_*`,
`old=I_plus*J_old^2`, and `new=I_new*J_new^2`. No injectivity of emitted
labels is assumed; arbitrary label coincidences are permitted. Averaging the
pointwise conclusion over the independent lists is a finite-sum operation
proved in prose, not an additional formal declaration.

`normalized_quadratic_lower` verifies the separate conversion from an
unnormalized index-matrix lower bound to the uniform double-average lower
bound. `paired_nonnegative` verifies the defect/gain balance with a
nonnegative geometric marking coefficient.

`four_corner_cancellation` and `four_corner_error_count` check the scalar
identities in the bipartite graph argument. They do not formalize singular
values or the graph-counting analytic estimate.

## Explicit noncoverage

The Lean file does **not** formalize the transposition matrix's spectral
lower bound, entrywise exponential/Gram argument, one-edge operator
estimate, fourth Schatten moment, conditional expectation, group
transitivity, the sharpness theorem, polynomial exponential sums, or
arithmetic progression covariance. These have separate all-parameter
arguments in `report.md`; the local Fourier bound is an explicit hypothesis
of the specialization, not a compiler-certified result.
Neither novelty nor publishability is a compiler verdict.
