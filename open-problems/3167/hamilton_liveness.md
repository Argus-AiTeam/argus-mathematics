# Necessary liveness for unique Hamiltonian continuation

This is an auxiliary continuation lemma, not a treewidth-five exclusion.
No claim is made that every realizable support satisfies an exclusion
predicate. No stored positive routing entry, including a closed entry,
is removed. All graph orders and arbitrary branching remain allowed.

## Exact completion relation

For b labeled boundary vertices, let K_b(q,t)=1 precisely when the union
of the two routing types is one cycle and every boundary vertex has
selected degree two. Path interiors on the two sides are disjoint.
Virtual paths retain their distinct identities, including parallel
virtual edges. This is the ordinary routing join followed by selection
of the closed type with degree vector (2,...,2).

Let S be the full live positive support of a partial graph, and let q
have count one. Define

    U(q,S) = {t : K_b(q,t)=1 and K_b(r,t)=0 for all r in S except q}.

Exterior routings here are not restricted to boundary-only graphs or
to simple matchings of boundary edges. They represent arbitrary path
interiors, as well as an empty open subset or a single cycle.

**Lemma.** If the marked partial edge set extends to a unique Hamiltonian
cycle in a boundary-glued completion, then U(q,S) is nonempty.

**Proof.** Restrict that cycle to the exterior. Its routing t satisfies
K_b(q,t)=1. If another r in S also satisfied K_b(r,t)=1, choose a positive
partial edge set realizing r and keep the same exterior edge set.
Their union would be another spanning connected 2-regular edge set:
both sides cover their interiors, every boundary degree is two, and
the routing join has one component. The edge sets would be different,
contradicting uniqueness. Thus t belongs to U(q,S). QED.

The argument remains valid if a live projection omitted other positive
types: every alternative used in this proof is retained in S and really
exists. For a quartic completion, the routing selected by the cycle and
all its restrictions satisfy the usual live degree inequalities.

**Monotonicity.** If q is retained and S' is contained in S, then
U(q,S) is contained in U(q,S'). Removing positive competitors cannot
invalidate a previously unique completion. This is compatible with the
existing full-support simulation preorder.

Consequently one may seek a separating carrier covering only those
marked entries with U nonempty, provided its new certificate theorem
and checker explicitly account for that condition. In a hypothetical
unique Hamiltonian graph, every construction-subtree restriction has
count one and a nonempty U, witnessed by the actual exterior. This
observation alone does not establish such a carrier or its closure.

Closed marked types with selected degree two at every boundary vertex
are not rejected: the empty exterior routing witnesses their U.
Other closed types have no spanning-cycle completion, but their positive
entries remain in every full stored support and every arithmetic check.

## Completion-profile simulation

Define N(S) as the union of the completion neighborhoods of all types in
S. Consider two realizable pointed supports with the same underlying
degrees and marker q. The proposed representative has boundary edges
A' contained in A and satisfies

    N(S') contained in N(S),   U(q,S) contained in U(q,S').

This relation is weaker than full-support inclusion. It does not assert
S' is contained in S, and it does not replace S by N(S) in any arithmetic.

Let w be any nonnegative exterior routing-count vector. The marked
Hamiltonian continuation is unique exactly when there is a t in U(q,S)
with w[t]=1, and w is zero on N(S) except at t. Every other positive
interior count has weight at least one, so this condition is independent
of its precise value. The displayed inclusions preserve this condition:
t remains in U(q,S'), and no newly active exterior type is introduced.

If U(q,S) is nonempty, these inclusions are also necessary for preservation
against all such vectors w. A missing unique neighbor is detected by
its singleton vector. A new positive neighbor is detected by putting
weight one on it and on any original unique neighbor. Thus the relation
has an exact marked-continuation interpretation, not a heuristic score.
Exterior types that can pair with a live support already satisfy the
selected-degree budget 2-h <= 4-g.

**Composition lemma.** Suppose a unary or relative-join operation has a
unit marked output with nonempty U. Replacing its pointed operands by
representatives in this profile relation gives a unit output at the
same marked routing and a profile representative of the original output.

**Proof.** Glue any exterior vector giving a unique original marked
continuation. Absorb the local operation and the other operand, if
present, into the exterior of one input. Routing counts are nonnegative
and gluing is associative. The unit total forces a unique input marked
contribution and a unit exterior contribution. The profile relation
therefore preserves that unique total when this input is replaced.
At a join repeat for the other input.

The original marked contribution survives because the selected routing
types are unchanged. Choose initially a singleton exterior type in the
original output's nonempty U. If the new output's marked count exceeded
one, that exterior would give a total exceeding one, a contradiction.
So the new marked output is genuinely unit. Apply the same argument
to every exterior vector giving an original unique marked continuation;
the exact interpretation above gives both output-profile inclusions.

Actual boundary-edge inclusion preserves legality of future edge
introductions and joins. Fixed underlying degrees preserve degree-four
forgetting and zero degrees in proper-adhesion operands. Projection
cannot remove a contribution used here: a routing that closes within
the remaining degree budget has selected and rejected degrees satisfying
the live inequalities. Relabeling transports N and U equivariantly.
This proves the claim for every elementary operation. QED.

For implementation, encode this comparison as the ordinary subset order
on the integer mask

    B(q,S) = N(S) OR ((K_b(q,.) minus U(q,S)) shifted by s_b bits).

The two disjoint bit ranges encode positive neighbors and blocked
neighbors of the fixed marker. Smaller B is exactly smaller N and larger
U. B is only a comparison key; it is not a routing support and must never
be serialized as one or passed to a routing kernel.

**Conditional certificate theorem.** Suppose a finite realizable carrier
contains the pointed leaf, covers every unary and proper-adhesion join
unit output with nonempty U in this profile preorder, is equivariant
under boundary relabelings, and contains no empty-boundary closed unit
marker. Then no finite simple quartic graph of treewidth at most five is
uniquely Hamiltonian.

Indeed, in a hypothetical counterexample every subtree restriction of the
unique cycle has count one and nonempty U, witnessed by its actual
exterior. Normalize the decomposition as in `normal_forms.md`. The
composition lemma inductively replaces every restriction by a carrier
representative, without changing the boundary degrees or discarding any
positive routing entry. All lower-terminal feedback is unrestricted.
At the root it supplies the forbidden empty-boundary closed unit marker.
This contradiction proves the conditional statement. A finite carrier
satisfying these hypotheses now has complete exact evidence in
`profile_certificate/runs/batch-feedback2-full/exact-result.json`.
All 809003 construction rows, 1879078 unary operations and 25209843635
required relative orders pass, with no uncovered output or accepting
marker. `theorem.md` states the resulting all-orders deduction and
reproduction command. Independent Host correctness and publication
review remain pending; this does not change the conditional lemma's scope.

## Exact finite certificate semantics

The routing catalog has a direct completeness count. A closed type has
only selected degrees zero or two, giving `2^b` possibilities. There is
one empty open type. Every other open type has `2k` degree-one endpoints,
a perfect matching of those endpoints, and selected degree zero or two
at each remaining boundary vertex. Thus its size is

    s_b = 1 + 2^b
          + sum_{k=1,...,floor(b/2)}
              binomial(b,2k) (2k-1)!! 2^(b-2k).

For b=0,...,6 this gives `2,3,6,15,44,143,500`. Validity, distinctness
and these cardinalities therefore certify completeness of an imported
descriptor catalog without trusting the producer's enumeration.

Counts are counts of selected **edge sets**, not orientations or rooted
traversals. At an edge introduction the selected and unselected cases
are disjoint. At a join, edge-disjoint operands with fresh interiors give
a unique restriction of every output edge set to its two operands.
Consequently their counts multiply with no symmetry factor. A connected
spanning two-regular edge set in a simple graph is exactly one undirected
Hamiltonian cycle.

The map `n -> min(2,n)` preserves addition and multiplication of
nonnegative integers when those operations are clipped at two. Replaying
every construction row in this semiring therefore determines its full
positive support and all its unit entries exactly, even though counts
above one are not recovered. Checking only a marked transition, a
support mask or a producer's saturation flag does not establish these
facts. Inactive construction ancestors require the same weighted replay
as active rows.

There is a separate point about binary symmetry. An automorphism of
`(g,A,S)` need not fix a witness's count vector. However, relabeling that
witness supplies a genuine graph with the same full support and the
transported unit marker. Thus completing marker orbits uses individually
realizable pointed witnesses, not a simultaneous-unit assumption.
With orders listing old labels at new positions, the relative-order
action is `r -> b*r*a`, for right and left unmarked automorphisms `b,a`.
The whole output family is transported by `a`; full-support arithmetic
is unchanged. An orbit representative suffices only after checking these
input actions, completion of their marker orbits, and coverage of every
relative order. The independent checker constructs those actions and
their orbit covers itself.

`profile_certificate/README.md` gives the exact invocation. Acceptance
requires weighted provenance, leaf coverage, every active-row unary
successor, all proper-adhesion relative joins, and absence of an
empty-boundary closed unit marker. The first uncovered operation is a
failure of that particular candidate carrier, not a refutation of the
existential certificate theorem or of the treewidth-five assertion.

## Six endpoints

There are fifteen perfect matchings on six endpoints. For a fixed
matching, eight other-side matchings unite with it into one cycle.
Contract its three paths: there is one undirected cyclic order of the
three labeled objects, with two endpoint orientations at each, giving
eight choices. The finite relation is also checked independently below.

If S contains at least nine of these fifteen matchings, every exterior
matching has at least 9+8-15=2 supported completions. No three-path
marker then has a unique Hamiltonian continuation. The bound is sharp
for abstract supports: take the seven nonneighbors of an exterior
matching and one of its eight neighbors. This abstract eight-element
support is not asserted to be graph-realizable.

The realizable three-star fixture has nine positive three-path types,
eight of which individually have count one. All eight have empty U.
They must still be retained as positive competitors in full supports;
their local unit counts are not evidence of a globally unique cycle.

## Prior failed route and executable evidence

The retired boundary-only safety predicate
R3167-TW4-BOUNDARY-COMPLETION is not reused. Its abstract two-terminal
input passed boundary-only quartic completions vacuously, and its
four-terminal input failed after introduction. The present lemma
quantifies over arbitrary exterior routing interiors and is only a
necessary condition for a distinguished unique continuation. It does
not assert that a boundary-completion exclusion predicate is inductive.

`hamilton_liveness.py` computes U without changing its input support.
`test_hamilton_liveness.py` compares every catalog pair for b=0,...,6
with independent concrete selected-path/cycle graphs. It also checks
all subsets of the fifteen three-path types and enumerates edge
subsets of the actual three-star graph. This is a finite certificate
of the relation and its implementation, not a certificate of the
treewidth-five mission.
