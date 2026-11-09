# Statement fidelity: deterministic parts of the finite Green argument

Claim: `L_GREEN_TRANSFER`. Source: `research/green_estimate/Main.lean`.
The Lean statements are universal finite deterministic lemmas, not the
probabilistic Green theorem.

`weighted_cut_transport` (namespace `FiniteGreen`) quantifies over arbitrary types `T`, `E`,
and `X`, with finite `T` and `E`; arbitrary real functions `prob`, `term`,
and `weight`; and an arbitrary real `modulus`. It assumes `prob t >= 0`
and the pointwise absolute bound
`abs(term t e x) <= weight t e * modulus` for every `t,e,x`.
It proves the absolute value of the weighted finite sum at every `x` is
at most the corresponding weighted sum of weights times the common modulus.
No normalization, positivity of the weights, or positivity of the modulus is
needed once this pointwise bound is assumed.

`simultaneous_cut_transport` (namespace `FiniteGreen`) adds an arbitrary source type `F`,
an admissibility predicate, source-dependent terms and moduli, and a single
source-independent weight array. Its conclusion quantifies over every
admissible source and every `x`, using the same weighted coefficient.
In the paper argument `T` indexes spanning trees of one fixed map, `E`
can index all possible cut edges with zero terms for absent edges, and
`X` indexes vertices. `prob` is the conditional uniform tree law. The
forest representation and source interpolation supply its pointwise
hypothesis; those facts are NOT encoded here.

`overlapping_small_sides_do_not_cover` (namespace `FiniteGreen`) separately quantifies over
a finite vertex type, a strictly positive real mass on every vertex with
total mass one, two finite subsets each of mass at most one half, and
a vertex belonging to both. It proves their union is not all vertices.
This certifies the strict inequality needed when choosing smaller tree-cut
sides, including ties. It does NOT prove that tree-cut sides containing one
vertex are nested unless their union is the full vertex set; that elementary
tree fact is proved in prose.

The source does not encode random planar maps, the encoding bijection,
the inverse-Laplacian forest identity, Dyck probabilities, concentration,
norm estimates, or a novelty claim. A successful compiler run certifies only
the declarations above. No probabilistic theorem should be assigned kernel
closure on the strength of this file.
