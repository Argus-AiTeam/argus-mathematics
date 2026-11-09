# Statement fidelity: universal hub-rigidity core

Claim: `CC-FORMAL-HUB9000201`. Source: `Main.lean`.

`CyclicCompatibility.hub_entry_rigidity` quantifies over every field `K`,
nonempty leaf type `I`, nonempty finite repeat-position type `R`, label type
`H`, and `K`-module `G`. It does not bound any of their cardinalities.
The vertex type is `Sum I (Option R)`: `inl i` is an old leaf,
`inr (some r)` is an individual hub, and `inr none` is the common hub.

Each `p v` is an injective linear map from the *same* `G` into label
covectors `H -> K`. `loopAnn v x` means that `x` annihilates the loop image.
`pairAnn i q x y` means that `(x,y)` annihilates the fixed-arrow joint pair
map. The predicates are abstract, but the essential hypothesis is explicit:
for loop-annihilating `x,y`, `pairAnn` holds **if and only if** there is a
single `c : G` with `x=p_leaf(c)` and `y=p_hub(c)`. This is the exact
compatible-pair graph assertion of `prop:compatible-relations`, not a
conclusion proved about arbitrary manuscript responses by the compiler.

`X i r s h` denotes the `(r,s)` entry of the weighted repeat matrix for
leaf `i`, label `h`; it is not an input-arrow matrix entry.
`HubNull` states the componentwise leaf-loop equations, hub-loop equations,
individual-hub pair equations with hub weight zero unless `r=s`, and
common-hub equations using the row sum `sum_s X i r s`.
The trace identity `tr(T E_pr)=T_rp` is used in the report to translate the
manuscript columns into exactly this orientation. That trace translation
is not a separate theorem in this Lean file.

The conclusion is existence and uniqueness of one `c : G`, with
`X i r s = if r=s then p_leaf(c) else 0` and every hub weight equal to
`p_hub(c)`. No differential-rank assumption is used.
`canonical_hub_null` proves the converse: canonical scalar-diagonal weights
annihilate the abstract columns when the compatible images annihilate
loops and pairs.

`orthogonal_weights_unique` states that a scalar weighted sum of nonzero
pairwise orthogonal matrix idempotents can be a scalar identity only if
every weight is that scalar. No symmetry, common eigenbasis across labels,
rank-one condition, or real/complex inner product is assumed.
`hub_projector_rigidity` applies this result to any finite branch type `J`
and proves that every branch weight is the corresponding coordinate of
the same unique `c`. The manuscript uses `J=R` and complete rank-one
projectors; those are stronger conditions than this forward implication
needs. Completeness is used in the report for the converse lift.

This formal source does **not** encode the analytic/formal evaluation of
`W`, existence of scalar repeated branches, limits of spectral projectors,
the Laurent-rank upper bound, the arbitrary-column rank formula, or the
directed-cycle trace test. Those have separate universal arguments in
`report.md` and bounded exact diagnostics in `verify.py`.
It does not prove the Kurosh counterexample or algebraic lifting.
The compiler checks the abstract universal algebraic core, not the
truth of the upstream manuscript hypotheses nor this fidelity document.
