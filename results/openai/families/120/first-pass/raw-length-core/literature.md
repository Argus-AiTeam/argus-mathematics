# Primary-source scope of the flat-forest literature

This is a contextual lookup, not an external premise of the proof in
`report.md`. The bounded lookup was performed by the separate
`raw-length-literature` research agent. No independent Reviewer approval
is implied, and the search does not establish novelty.

## Chen et al., arXiv:2311.18295v1

Primary source: <https://arxiv.org/html/2311.18295v1>.

Definition 2.3, source `preliminaries.tex`, lines 31--34, defines a flat
embedding by a vertex map whose edge endpoints satisfy
"either \((x',y')\) is an edge in \(G\), or \(x'=y'\)."
The definition permits collapsed edges; it does not prescribe the local
manuscript's unit null bookkeeping lengths.

Definition 3.1, source `MRC.tex`, lines 17--29, applies to a dynamic
graph `G=(V,E,ell,g)` and compares a returned cycle by

```
<g,c> / ||Lc||_1
  <= (1/alpha) min_(B^T Delta=0) <g,Delta> / ||L Delta||_1.
```

Its denominator is the weighted l1 norm of the net signed edge vector
on `G`, not the uncanceled length of its forest-path representation.
Locator: <https://arxiv.org/html/2311.18295v1#S3.Thmtheorem1>.

Theorem 3.5, source `MRC.tex`, lines 99--108, assumes a dynamic graph
with at most `m` edges. It gives congestion at most `gamma`,
initialization `m gamma`, amortized updates `gamma`, and a cycle
represented by `gamma_MRC` tree paths and `gamma_MRC` off-tree edges.
Here `gamma=exp(O(log^(167/168)(m) log log m))`.
The representation-size statement is separate from Definition 3.1's
ratio denominator.
Locator: <https://arxiv.org/html/2311.18295v1#S3.Thmtheorem5>.

## Kyng--Meierhans--Probst Gutenberg, arXiv:2311.06402v1

Primary source: <https://arxiv.org/pdf/2311.06402v1>.

Lemma 3.21, printed page 30, source `mappingHierarchicalTree.tex`,
lines 6--14, inherits Theorem 3.1's bounded-degree dynamic-graph and
positive-length hypotheses. It additionally assumes a dynamic flat
hierarchical forest over a monotonically increasing terminal set,
bounded embedding congestion and update recourse, and vertex maps
with the restriction that once a vertex enters the preimage its image
remains constant. Under those hypotheses it maintains a lifted flat
forest whose mapped terminal-path length is no greater than the
corresponding mapped path in the original forest. It also bounds
congestion and recourse; this is not itself a circulation-ratio theorem.
Locator: <https://arxiv.org/pdf/2311.06402v1#page=32>.

Algorithm 5, printed page 31, source `mappingHierarchicalTree.tex`,
lines 22--49, explicitly preallocates tree copies and assigns distinct
copies to nodes with the same physical image, `Lambda(x) != Lambda(y)`.
Thus preallocation, assignment, path domination, and recourse control
are prior art.
Locator: <https://arxiv.org/pdf/2311.06402v1#page=33>.

## Search limit

The two inspected sources did not explicitly supply the proposed
deletion-stable transfer theorem, the unit-null canonical hub completion
bound `3||Q||+||N||` and its sharpness example, the `beta/Z` constants,
or the `5ZA` sharpening. Generic path-length domination is already
explicit. Absence from these inspected statements is not a proof that
the sharpening is new or publishably significant.
