# Statement fidelity: the universal all-sheet collar core

Claim: `C9000019-COLLAR-CORE`.
Formal source: `research/collar_root_audit/Main.lean`, Lean 4.31.0.

The unqualified compiler declarations described here are
`rational_collar_capture`, `circuit_genus_balance`,
`circuit_stability_balance`, `unramified_stability_balance`, and
`stable_tree_side_impossible`, all in namespace `CollarRootAudit`.

## `CollarRootAudit.rational_collar_capture`

The objects are an arbitrary compact topological space `X`, an open subset
`N`, a continuous function `v : X -> Real`, and real numbers `lower < a <
upper`. The hypothesis `Irrational a` means that `a` is not the image of
any rational number in the reals. The quantified hypothesis `hbad` says
that for **every** `x` outside `N`, there exists a rational `q` with
`v x = q`. There is no assumption that the complement of `N` is finite
or has only finitely many function values.

The conclusion produces rationals `r` and `R` with
`lower < r < a < R < upper`. It asserts that **every** `x` with
`r < v x < R` belongs to `N`. This is a containment of entire inverse
images, not an assertion about selected points or a distinguished
skeleton.

For the analytic application, take `X` to be the compact inverse image
of a closed concentric annular window under the finite cover, `N` the
intersection with the finite union of source node tubes mapping to the
target node, and `v = -log_p(abs(t))`. The real window endpoints are
strictly between those of the target node annulus. The hypotheses on
`v`, `N`, and the rationality of the bad values must be established by
the analytic proof in `report.md`; they are not Lean definitions of
Berkovich objects. Once the interval lies inside the closed window,
this conclusion covers all preimages in the original proper source,
not merely points already chosen from the window.

## The algebraic and combinatorial declarations

`CollarRootAudit.circuit_genus_balance` is an identity for all integers
`n,g`. It checks the Riemann--Hurwitz identity for a degree-`n` residue
cover with two totally ramified marks, whose source genus is `n*g`.
It does not assert that a curve cover realizing those data exists.

`CollarRootAudit.circuit_stability_balance` is an identity for all integers
`n,g,val`. It checks that replacing the two circuit directions by
factor-`n` directions and each other direction by `n` factor-one
directions multiplies the stability weight by `n`.

`CollarRootAudit.unramified_stability_balance` quantifies over all integers
`d,g,gp,val,valp`. Under the unramified Riemann--Hurwitz and valence
equalities, it proves that the stability weight is multiplied by `d`.
Positivity in the geometric application follows from positive degree
and stability of the base vertex.

`CollarRootAudit.stable_tree_side_impossible` quantifies over natural
numbers `N,total`. A positive number of vertices, the tree-side equality
`total + 1 = 2*N`, and the genus-zero stability bound `3*N <= total`
are inconsistent. The degree-sum formula for a tree with one boundary
half-edge is supplied by the graph proof in `report.md`, not encoded as
a graph datatype.

## Exact certification boundary

These are universal theorems, not a bounded parameter search. There are
no custom axioms, placeholders, or assumed conclusions in the source.
Mathlib supplies the topology and arithmetic foundations.

The compiler does **not** formalize the resolution theorem, existence of
residue covers, ABBR lifting, Berkovich reduction and compactness,
analytic unit factorization or binomial convergence, finite-etale
fibre-product domination, or the complete manuscript lemma. Those
mathematical bridges are stated and proved, or identified as external
inputs with their precise hypotheses, in `report.md`. Independent
review of that bridge and of this translation is still required.
