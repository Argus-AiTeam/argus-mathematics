# Statement fidelity: cone chains and essential self-band splitting

All declarations in `Main.lean` are in namespace `ConePicture`. This is a
formalization of the augmented **cellular chain algebra of a graph cone** and
the residual-cycle safeguard used in the topological proof. It is not a
formalization of surface transversality, covering-space lifting, Hurewicz,
Whitehead, or the complete implication `C_TOPOLOGY`.

## Chain groups, differentials, and exactness

For arbitrary additive commutative groups `A`, `B`, `C` and additive maps
`delta : A ->+ B`, `epsilon : B ->+ C`, the definitions are

`coneD2 delta a = (a, -delta a)`,

`coneD1 delta epsilon (a,b) = (delta a + b, -epsilon b)`,

`coneD0 epsilon (b,c) = epsilon b + c`.

`coneD2_injective` and `coneD2_zero_iff` prove injectivity and the zero-kernel
criterion without an assumption about either additive map.
`coneD1_coneD2`, `coneD0_coneD1`, `cone_exact_one`, and `cone_exact_zero`
assume **for every** `a`, `epsilon (delta a) = 0`. They prove the two
successive-differential identities and exactness in degrees one and zero.
`cone_augmentation_surjective` proves surjectivity of `coneD0`.

`graphIncidence source target` is the integer incidence map of every finite
oriented multigraph: at vertex `v`, it sums incoming edge coefficients minus
outgoing edge coefficients. `V` and `E` are arbitrary finite types, and
`source,target : E -> V` are arbitrary; loops, multiple edges, disconnected
graphs, and empty edge types are allowed. `graphAugmentation` sums all vertex
coefficients. `graph_augmentation_incidence` proves that augmentation composed
with incidence is zero, rather than assuming it.

`graph_cone_exact` specializes the preceding universal results to these
actual maps. With `A = E -> Int`, `B = V -> Int`, `C = Int`, the groups are
the cone's oriented 2-cells, its base edges plus radial edges, and its base
vertices plus apex. The boundary of the cone on an oriented edge is that
base edge plus its source radial edge minus its target radial edge.
Thus the formal exactness statement is the complete augmented cellular
acyclicity calculation for the abstract cone, including injectivity in top
degree. It does not assert that a graph cone embeds in the presentation
complex.

## Residual chains and a surviving essential summand

`residual_conservation` quantifies over the above `A,B`, an arbitrary
additive commutative target group `T`, an additive pushforward `push : A ->+ T`,
three target elements `z,z1,z2`, and a residual cone 2-chain `q`.
It assumes:

1. `coneD2 delta q = 0`: the residual chain is closed **in the abstract cone**.
2. `z - z1 - z2 = push q`: the cut-and-cap residual identity in the target.

It proves `z = z1 + z2` by first proving `q = 0`.
`essential_split` adds `z != 0` and concludes `z1 != 0 OR z2 != 0`.
It does not assume either summand is essential, that both survive, or that a
preselected summand survives. In the proof's cellular interpretation, `T`
may be the target cellular 2-chain group; a two-dimensional target has no
3-boundaries, and nonzero 2-cycles represent nonzero homology classes.

The geometric proof in `proof.md`, Section 4, must still establish the
residual identity and closedness in the **same lifted cone**. Closedness
only after applying `push` is deliberately not substituted for the first
hypothesis. The compiler does not construct an annulus or verify that the
chosen caps have matching lifted seams.

`strict_split_descent` quantifies over natural boundary lengths and proves
that either retained part plus the nonnegative remaining length is smaller
than the old total when exactly two letters have been removed. The geometry
and graph-path endpoints giving those lengths are proved in prose and
tested separately, not silently assumed to be a Lean theorem about surfaces.

## Evidence boundary

Claim `C_CONE_CHAIN_CORE` is exactly the collection of statements above.
No standard topological theorem or external axiom is added to this claim.
A successful official Lean 4.31.0 compiler/axiom-audit run certifies this
algebraic core only. The full universal topological theorem requires the
independent Reviewer's reading of `proof.md` and the explicitly cited
standard topology, in addition to this certificate.
