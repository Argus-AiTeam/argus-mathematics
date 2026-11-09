# Statement fidelity: disjoint resampling

`Argus9000131.disjoint_core` has arbitrary natural `n`, arbitrary labeled
natural degree function `d : Fin n -> Nat`, and arbitrary real vectors
`f,g : OAI.Problem315.PairResampling.StateSpace n d`. `StateSpace` is the Euclidean function
space on **all** simple loopless undirected graphs on `Fin n` whose labeled
degrees equal `d`. No subfamily, host restriction, minimum degree,
nondegeneracy, or positive-center assumption occurs. Empty realization
spaces are harmless; for the manuscript application they are nonempty
because `d` is graphical.

The pair index `PairResampling.pairs n` consists of unordered two-element
vertex sets. `PairResampling.fluctuation a` is `I-E_a`, where the fixed
pair-fiber data are the graph away from `a`, the internal edge of `a`, and
the number of neighbors in `a` of every vertex outside it.
The pinned `OrthogonalPairResampling` proof identifies this orthogonal
projection with subtraction of the full finite fiber average.

`disjointForm f g` sums
`inner (fluctuation a f) (fluctuation b g)` over **ordered** disjoint
pair-pairs. Its symmetry and nonnegativity on the diagonal are the formal
conclusions. Since every fluctuation is self-adjoint, this form is exactly
`<f,Dg>` for `D=sum_{a disjoint b} h_a h_b`, without a factor `1/2`.
On a nonempty realization space, dividing Euclidean inner products by the
positive number of states gives exactly the manuscript uniform-probability
inner product; it changes neither symmetry nor nonnegativity.

The source includes a Lean 4.31 port of the transitive pinned project proof closure for the
actual interaction and pair-fiber budget, not the comparator challenge:
the graph-cell equivalence uses the original symmetric adjacency relation,
and the slice proof retains constant and small slices. In particular,
overlap of the two outside singleton sets does not identify their two
different incident edges. No finite enumeration is a premise of the formal theorem. Conditional-lemma
names, the older `ReflTransGen.lift` argument convention, and an explicit
definitional `Finset.mapEmbedding` reduction are compatibility changes, not
new mathematical hypotheses.

`disjoint_core_nonnegative` is the diagonal part;
`disjoint_form_symmetric` is the bilinear symmetry part. The printed
axiom lists for the assembled theorem, actual interaction, actual budget,
and slice comparison are requested compiler output, not source-scan
substitutes.

This formal statement verifies the disjoint core only. It does not assert
the three-row theorem, the final mixing-time constant, exact sampling,
independent Reviewer acceptance, or mathematical novelty of upstream proofs.
The correspondence of the imported graph/fiber definitions to the staged
manuscript is a mathematical reading to be checked independently; Lean
checks the encoded statement and proofs, not that reading.

The additional declarations `sharp_interaction_identity`,
`sharp_ratio_lt_one`, and `no_uniform_smaller_ratio` check real rational
algebra: for positive `m` the interaction expression is minus `m/(m+2)`
times the error expression, this ratio lies in `(0,1)`, and every real
`c<1` is exceeded by the ratio of some positive natural `m`.
They do **not** themselves encode the graph realization or its state count.
The graph-realizable sharpness family and its counting proof are given
separately in `report.md`; the all-graph theorem above is independent of
that additional family.
