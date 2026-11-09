# Statement fidelity: adaptive finite-support transfer

The declarations below are in namespace `AdaptiveSupport` in `Main.lean`.
The source is self-contained apart from kernel-proved Mathlib results.

## Objects and probability

`probability s` is the cardinality of a finite event divided by the
cardinality of its finite sample space, as a real number. All probability
spaces used in the main theorem are nonempty. `law f` is the uniform
pushforward by `f`. `law_event` proves the pushforward identity for every
finite type event; `law_sum` proves normalization.

`totalVariation p q` is exactly one half of the sum of absolute coordinate
differences. `event_le_totalVariation` proves its event domination for
arbitrary real vectors of equal total mass one. Nonnegativity is automatic
for the pushforward laws used in the main theorem; it is not needed for
that intermediate inequality.

## Actual independent-color counting

`cylinder_probability_le` quantifies over arbitrary finite coordinate
sets `I`, arbitrary finite vertex sets `B`, and an arbitrary nonempty
finite color set `C`. Its path map `f : I -> B` is required to be
injective. For each coordinate an allowed finite color set has size at
most the natural number `H`. The conclusion is the bound
`(H / card C)^(card I)` for the fraction of all functions `B -> C`
satisfying these restrictions.

This is not an assumed independence or marginal-probability premise.
`splitColors` explicitly bijects all colorings with their colors at the
injective coordinates and their colors on the complement. Counting
under that bijection proves the cylinder bound. In particular it uses
independence of distinct *vertices*, not independence of labels, states,
or different witnesses.

`statePaths next n` consists of all state words of length `n+1` whose
successive states belong to the finite successor sets `next`.
`mem_statePaths_iff` verifies this recursive prefix-and-last-state
description against `follows`; it does not omit any allowed word.
`statePaths_card_le` derives the bound `card S * Q^n` from
`card (next j) <= Q` for every state. Empty state sets, self-transitions,
repeated states, and directed nonsymmetric transitions are permitted.

`matchEvent next allowed walks` is the union, over all the supplied vertex
walks and all these state words, of their actual independent-color
cylinders. `tree_matching_bound` proves its probability is at most

```
card S * (H / card C) * (d * Q * H / card C)^n.
```

Its finite family `walks : Finset (Fin (n+1) -> B)` has cardinality at
most `d^n`, and each member is injective. These hypotheses hold for all
nonbacktracking walks from the root of the radius-`n` regular-tree ball:
such a walk has distinct vertices, and at most `d` choices at each step.
They are structural hypotheses of the formal theorem, not a formal
construction of an infinite regular tree. In fact the theorem generalizes
to every finite family of injective vertex sequences with that bound.
No independence between different walk or state witnesses is assumed.

## Universal finite-discrepancy theorem

`finite_discrepancy_transfer` quantifies over arbitrary finite state,
tree-vertex, color, source-vertex, and type sets `S,B,C,V,T`.
`C` and `V` are nonempty. The data `next`, `allowed`, the natural
parameters `d,Q,H,n`, and the finite family `walks` have the preceding
meaning. Each successor set has size at most `Q`, and each allowed color
set has size at most `H`.

`rootType : V -> T` is any actual source-root type map.
`treeType : (B -> C) -> T` is any type map of the uniformly colored
finite tree. A subset `E` of types must satisfy, for **every** tree
coloring, that its type belongs to `E` if and only if that coloring
belongs to `matchEvent`. This is the explicit type-invariance and
pushforward correspondence for the color-only event. It does not assert
the desired small probability: that is proved by the cylinder count.

`bad` is any finite subset of source vertices, and every member is
required to have its type in `E`. In the manuscript this is the
elementary implication from actual label compatibility to allowed source
color membership. The formal theorem does not encode the metric labels,
construct an operator, or assume their independence.

The conclusion is

```
probability bad <= totalVariation (law rootType) (law treeType)
                  + card S * (H / card C)
                           * (d * Q * H / card C)^n.
```

All data are universally quantified in a fixed source graph. No random
support, independence-from-the-sequence, positivity of signed operator
coefficients, simple-source-graph, or distinct-source-walk-vertex
hypothesis is present. Source loops, parallel edge instances, reversals,
and vertex revisits are retained in the actual induced type map; only
the regular-tree witness family must be injective. Incidence walks,
their type invariance, and the compatibility-to-color implication are
explained in the prose proof, not silently formalized by a different
notion of walk.

## Subsequent length and graph-index selection

`ratio_lt_half` proves `d Q H/k < 1/2` from the exact natural-number
hypotheses `k>0` and `2*d*Q*H<k`.

`successive_selection` quantifies over arbitrary real arrays
`epsilon n m` and `beta n m`. For every fixed `n`, `epsilon n m`
must tend to zero as `m` tends to infinity. For every `n,m`, the
finite-discrepancy bound just proved must hold, with `s` the number of
states and `k` the number of colors. For every positive real `delta`
and every prescribed lower graph index `m0`, the conclusion is

```
exists n >= 2, exists M >= m0, forall m >= M, beta n m < delta.
```

The proof chooses the length first by geometric decay and only then
chooses the graph-index threshold by fixed-radius convergence. It
includes zero `s,H,Q` without division by any of them. There is no
uniform-in-unbounded-state-count convergence assertion.

The deterministic local-limit sequence and its explicit permutation
exploration/second-moment proof are given in `report.md`, Sections 1--2.
They are not claimed to be formalized in this Lean file. They discharge
the actual local-limit premise by an independent, complete prose proof,
rather than assuming an unspecified suitable sequence. Its independent
review and the fidelity of the concrete graph/type instantiation remain
the human Reviewer's responsibility. The compiler checks the universal
finite counting, discrepancy transfer, and subsequent selection; it
does not check this document or certify novelty or the full manuscript.
