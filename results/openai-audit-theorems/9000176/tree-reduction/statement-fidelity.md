# Statement fidelity: common-sample reduction

## Principal declarations and claim

`TreeReduction.pathwise_reduction` in `Main.lean` proves the original
`lem:reduction` of the staged `sections/trees.tex`. The claim recorded by the
compiler run is `C_TREE_REDUCTION`.

`TreeReduction.pathwise_three_reduction` strengthens the capacity separation
from 16 to 3, with every other hypothesis and conclusion unchanged.
`TreeReduction.expected_bound` additionally proves
E[D_v] <= exp(-7 m_s) at every non-leaf node, even with factor-3 separation.
These are universal statements, not bounds inferred from the Python examples.
No literature-wide novelty assertion is part of this fidelity document.

## Objects and quantifiers

The declarations quantify over arbitrary natural numbers n and k, with k >= 1.
`Mask n = Fin n -> Bool` encodes every subset of an n-element ground set.
`Sub`, `union`, `inter`, and `diff` are ordinary subset inclusion, union,
intersection, and difference. `card` counts true coordinates;
`card_eq_sum` proves its ordinary coordinate-count interpretation. Relabelling
an arbitrary finite ground set by a finite bijection gives exactly this model;
there is no bound on n or on label sizes.

`Tree n k` is a rooted tree with exactly k arcs on every root-to-leaf path.
Each non-leaf constructor has its own arbitrary finite child type B, its own
`Law B`, labels `B -> Mask n`, and child trees of depth one less. `Law`
requires strictly positive real weights summing to one. In particular every
non-leaf child type is nonempty (`law_nonempty`), and every subtree has a full
path (`path_nonempty`). Finite height and finite branching give a finite tree.
No injectivity of labels, uniform label size, lower label size, or common child
type is assumed. Distinct indices and histories remain distinct even if their
labels agree. Every child type is finite, but its cardinality is unbounded.

`pathLabels` is the list of labels on a full path. The hypothesis in
`pathwise_reduction` is precisely pairwise disjointness of that list, for
every full path. The intermediate predicate `treeDisjoint` uses the equivalent
recursive condition: all labels below a child avoid its incoming label,
and each child subtree is recursively disjoint.
`treeDisjoint_iff_pathwise` proves this equivalence; it is not an extra
measurability or independence hypothesis. Coordinates may be shared freely
by incomparable branches.

The level functions m and alpha are indexed from zero. Only their first k
values matter. `Valid t m alpha` requires at each node the capacity bound on
every outgoing label, alpha-spread of that node's actual child law, and the
same conditions recursively at the following levels. `Spread` includes the
empty test set as well as nonempty sets. `spread_iff_nonempty` proves that
the empty-set requirement is automatic from normalization, so this is
equivalent to the manuscript definition.

The remaining hypotheses are positive integer capacities, m_(j+1) >= 16 m_j,
0 < alpha_j <= a, rho = exp(50) a, and rho < 1.
Positivity of rho and a is derived, not added. The stronger theorem replaces
only 16 by 3. There is no full-path spread hypothesis.

## The one common Bernoulli sample

`avg rho f` is exact finite product expectation: at each coordinate it takes
(1-rho) times the expectation with a false bit plus rho times the expectation
with a true bit. `avg_product_law` identifies it with enumeration of all bit
vectors weighted by the product of those coordinate probabilities.
`avg_const`, `avg_nonneg`, and `avg_mono` establish normalization, positivity,
and monotonicity in the admissible density range.

There is a single argument w throughout the entire tree. Neither the local
transition nor `potential`, `good`, `reduce`, or `procedure` replaces it by
fresh samples at descendants.

## Actual indexed posterior and essential local proofs

`score` is
nu_b rho^(-|A_b|) 1(A_b subset Y), and `partition` is their sum Z(Y).
`joint` is the fixed-w joint mass of source c and target b:
nu_c score_b(w union A_c)/Z(w union A_c).
`partition_pos` proves the denominator positive from the planted source.
`joint_source` proves that the source marginal is its prior even at fixed w.
No fixed-w prior target marginal is assumed.

`avg_plant` and `indexed_plant_density` derive the density of the planted union
jointly with each actual source index. Summing them gives `planted_density`.
These establish the displayed Bayes posterior, including repeated labels,
rather than postulating an abstract transition with desired estimates.

`passes` means Z >= exp(-10 m) and 2|A_b minus w| <= m.
Thus `mass` is exactly the manuscript t_vb, and `failure` is d_v.
`local_normalization` proves d_v + sum_b t_vb = 1.
`local_failure` proves E[d_v] <= exp(-9 m) under the original local capacity,
spread, and ratio hypotheses. Its proof includes the small-denominator
density estimate and an exponential intersection-moment bound.
`distortion` proves the exp(11 m) outside-target-label estimate for every
nonnegative real function satisfying `Avoids (A_b) f`.
`Avoids` means invariance whenever two masks agree outside A_b; it does not
assume any averaged bound. `avg_subset_factor` proves the needed coordinate
factorization directly from the product law.

`potential_avoids` derives outside-label invariance from the fixed input
subtree's labels. `expected_recurrence` applies the actual `mass_distortion`
and `local_failure` theorems to obtain E[D_v] <= exp(-8 m_s) +
exp(12 m_s) sum_b nu_b E[D_b]. The recurrence is a conclusion, never a premise.
`bad_potential` and `root_success` prove the root-good probability bound.

## Deterministic output and the original conclusion

`procedure` is an explicitly defined pure function from w to
`Option (Tree n k)`. It returns none exactly when the root is not good.
On a good sample, `reduce` retains exactly the good children with positive
local non-failure target mass. Its `retainedLaw` gives each such index
weight t_vb/gamma_v and labels it by A_b minus w. It recursively uses the
same sample w and the same original child history.

The principal conclusion existentially names this procedure and proves its
success probability is at least 3/4. Every returned tree has exactly the
original depth k; its validity has capacities `m j / 2` (natural-number
division, hence floor(m_j/2)) and spread
alpha_j/(1-exp(-m_j)). Levels consisting only of empty labels are permitted;
non-leaf nodes still have nonempty positive child laws.
`mass_spread_raw` and `retained_spread` derive this spread from the fixed-w
source law and the fragment/source inclusion, not from a fixed-w target
marginal. `reduced_disjoint` proves disjointness. `reduced_recovery` proves,
for every full output path q, existence of a full original path p whose
union is contained in w union the output path union.

The procedure is deterministic in the manuscript's mathematical sense,
with exact real-valued weights and comparisons. It is not a floating-point
implementation claim. Sources and targets are used only to define finite
transition sums; the output procedure does not sample them.

## Trust boundary and remaining obligations

The source contains no custom axioms, proof holes, unsafe code, or assumed
posterior/recurrence/pruning conclusions. The printed dependencies of the
principal and essential local theorems are only `propext`, `Classical.choice`,
and `Quot.sound`, the standard foundations used by Mathlib.

The compiler establishes the encoded theorems, not this document's reading
of them. That reading, the mathematical significance, and the scope of any
novelty claim still require the independent Reviewer.
The manuscript's iteration, tree-covering theorem, graph hierarchy, and main
graph-threshold theorem are not asserted to have been formally certified here.
