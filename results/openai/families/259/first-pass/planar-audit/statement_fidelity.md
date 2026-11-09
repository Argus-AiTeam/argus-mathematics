# Statement fidelity

`Main.lean` formalizes the finite, coefficient-sensitive extraction core of
the theorem proved in `theorem.md`. It does **not** formalize the construction
of a spherical band filling from an equality in an arbitrary free product.
That construction, connectedness via the closed-component obstruction,
dipole removal, automatic coefficient-group injectivity, and the
full-cycle-to-full-word implication require the independent prose review.

The claim attached to compilation is `C_PLANAR_KERNEL`, not the complete
manuscript lemma or the manuscript's main cost theorem.

## Objects and hypotheses

`GapData V` describes an arbitrary finite collection of inner vertices.
`degree v` counts all exterior occurrences of the corresponding oriented
relator. `outer v` counts bands from that vertex to the distinguished outside
vertex. If nonzero, those bands are indexed cyclically by `Fin (outer v)`.
`inner v i` counts the intervening inner-to-inner bands in the gap after band
`i`; `bigon v i` says that this gap is an actual complementary bigon.
A bigon has no intervening inner band. The degree equation counts every
incidence exactly once. When there are no outer bands the separate degree
field, not an empty sum, supplies the corner cost.

`gapCost` is **twice** the corner weight: a bigon costs zero; a gap with no
inner band that is not a bigon costs two; a gap with `h > 0` inner bands
costs `h + 1`. The relevant weights assign one half to an inner corner unless
both its incident edges go outside, in which case they assign one.
`face_bound` verifies the resulting doubled face bound. Its no-outside
minimum-length hypothesis comes from the signed inner graph being bipartite;
`no_inner_triangle` checks the three-color-adjacency obstruction.

`BoundaryData` has an arbitrary group `H`, arbitrary signed-letter type
`Λ`, and outer-occurrence type `Ω`. Its globally injective endpoint map
records that one outer occurrence belongs to just one band. Each vertex has
an injective position map into its full relator, so a matched interval cannot
reuse a relator position. A bigon supplies adjacency at **both** boundaries,
matching signed letters, and the exact equation
`relatorGap * wordGap⁻¹ = 1` in `H`.
The existence of these data is proved in prose; it is not silently claimed
as a compiler result.

`coefficient_sensitive_core` quantifies over all these types and all such
data, with degree at least four, a finite face type, the equality of vertex
and face corner totals, twice-edge face-length total, Euler's sphere
equation, and each doubled face-weight bound. The integer `edges` is
unrestricted; the sphere band construction supplies its nonnegative value.
It is not a parameter bounding a finite search.

## Conclusions and declaration names

`gap_classification` proves that doubled cost less than four gives either all
bigons or exactly one exceptional cyclic gap, containing at most two inner
incidences. `positive_vertex`, `two_positive`, and `gap_dichotomy` extract
two distinct long vertices unless there is a full bigon cycle.
`curvature_from_faces` derives the requisite total positive charge from the
partition and Euler equations, rather than assuming it in the final theorem.

`cutOrder` enumerates **every** outer band once, beginning just after the
exceptional gap. `cutOrder_ne_cut` and `cutOrder_next` justify the cut and
order. `Matches` and `ordered_match` assert injectivity at both boundaries,
equality of every signed letter, adjacency at both boundaries, and equality
in the arbitrary group `H` of every gap strictly inside the interval.
The closing gap is deliberately excluded from a noncyclic interval.
`endpoint_disjoint` proves that intervals from distinct vertices have no
common outer occurrence.

`coefficient_sensitive_core` concludes either a full bigon cycle or two such
ordered, coefficient-equal, exterior-disjoint intervals, each using at least
`degree v - 2` occurrences (encoded without truncated subtraction as
`degree v <= outer v + 2`), and each using at least two occurrences.
The full branch only asserts the full **bigon cycle**: exhaustiveness of the
outside word follows from the connected planar embedding in prose.

`no_closed_component` is the separate finite obstruction used to prove
coefficient-group injectivity without assuming it. It quantifies over finite
vertex and face types, integer degrees and face lengths, an integer edge
count, the two dart totals, sphere Euler equation **without** an outside
vertex, and minimum vertex degree and face length four, and proves `False`.
The existence of a closed simple bipartite band component and its face-length
bound remain prose obligations. This declaration alone is not a formal
Freiheitssatz.

`sandwich_eq_iff` and `conjugate_one_iff` prove universal group identities
used for coefficient twists and cyclic reduction. They do not assert that
mere conjugacy implies equality.

The compiler checks these declarations and their dependencies. It does not
check statement fidelity, the prose topology, optimality examples, literature
attribution, novelty, publishability, or any result about cost.
