# Statement fidelity: HostRequests universal construction components

The source is `Main.lean`, namespace `HostRequests`. The mechanical ledger
claim is `H_PATHS`: ordered substring windows admit the actual directed
hierarchical-graph paths and exact up-cost used in the host construction.
The source additionally certifies universal order, transport, clipping,
attachment, balanced-support, and rooted-connectivity components. It does not
encode the manuscript's approximation algorithm or assert its factor-two
theorem.

## Words and the graph

`word A a n` is the list of the \(n\) letters at integer positions
\(a,\ldots,a+n-1\) in arbitrary text `A : Int -> alpha`.
`window A a b` uses `n = Int.toNat (b-a)`; every application to a prescribed
window in the construction has \(a\le b\). The explicit length hypotheses in
`ordered_windows` and `WindowChain` prevent a negative interval from being
substituted silently. The integer-to-natural conversions are proved in the
source, not treated as exact without their order hypotheses.

`Language alpha` specifies membership in \(V\), the empty word, every singleton
letter, and closure under prefixes and suffixes. This follows from the
manuscript's substring language on its input alphabet and conversely suffices
for all subwindows used here. Lean permits an arbitrary alphabet/type and does
not require the original finite input for these local theorems.

`Walk L u v n` is data made only from a valid trivial walk, an append-last-letter
up step (index increase one), or a delete-first-letter down step (index
increase zero). It is not a predicate postulating a connection, and it does not
permit reverse edges or arbitrary substring jumps. `Walk.vertices_valid`
proves that every visited word is in \(V\).

`ordered_windows` quantifies over any text, four ordered integer endpoints,
and two valid words. It constructs a real intermediate word of length at most
\(\max(0,b-c)\), a cost-zero walk to it, and an actual directed walk of
cost \((d-b).toNat\) from it to the second word. It includes the disjoint-window
case, using only singleton words for the gap.

`WindowChain` stores a finite list of valid nonnegative-length windows ordered
in both coordinates. Its constructors do not contain graph paths or budget
claims. `WindowChain.realize` constructs such a path, proves membership of every
listed target, and proves cost equal to the end increase.
`WindowChain.closed` identifies translated endpoint words by text periodicity.
`close_at_short` constructs the closed walk with the prescribed target support
and an actual final-transition vertex of the asserted short length.
`attachment_loop` constructs the period-\(p\) requester loop from the two
coordinate-range inequalities, positivity, actual-word validity, and text
periodicity; it proves that the specified requester word is visited.

## Cyclic normalization and transports

`Actual z a b` means precisely `z(a-1) <= b <= z(a)`.
`normalize_record` quantifies over a positive integer \(q\), monotone integer
function \(z\) with \(z(x+q)=z(x)+q\), an actual fixed record \((a_0,b_0)\),
and any other actual record. It constructs an integer \(k\) so that the
translated record remains actual and both coordinates lie between the fixed
record and its \(q\)-translate, inclusively. The right boundary is deliberately
allowed for equal-start vertical ties. `normalized_pair_order` proves that
lexicographic order of actual records orders both coordinates.
The manuscript gives one-step monotonicity, which implies `Monotone z` by
finite iteration; it is not an added regularity assumption.

`transport_word` proves equality of finite words when coordinates and the
entire text are translated together. `transport_actual`, `transport_layer`,
and `transport_periodic` preserve the actual-window, monotonicity, nonnegative
window-length, and child-period properties of the shifted layer.
`transport_distinct` preserves inequality of shifted texts from the original
absence of any translation identifying them.
`periodic_int`, `actual_translate`, and `window_periodic` justify both positive
and negative integer multiples of the relevant period. No assertion treats a
host-period shift as necessarily a child period.

`texts_equal_of_agreement` proves equality of any positive-period \(p,q\)
texts agreeing on \(p+q\) consecutive positions.
`agreement_bound` is its contrapositive for a specified agreement interval and
distinct aligned texts. There is no external Fine--Wilf assumption.

## Clipping hypotheses and conclusions

`raw_separation` and `clipping_order` are universally quantified pairwise
ordering facts for all integers satisfying their displayed inequalities.
`clipped_contact` takes the original requester bound, minimum child-period
comparison, normalized record-order inequalities, and three strict agreement
bounds. It proves containment, nonemptiness, attachment ranges, and the strict
final short-end bounds for exactly
\[
s=\min(a+p,a_0+q),\qquad h=\max(e,b_0).
\]
The agreement/order bounds are explicit hypotheses of this component, not a
claim that every numerical tuple is a realizable word configuration.
`proof.md` derives all of them from the original actual-layer and distinct-text
hypotheses before applying the component.
`only_group_short` covers absence of other groups, and `attachment_order`
checks both transitions of a requester loop.

## Support, balance, rooting, and budget

`Walk.vertices` and `Walk.edges` are exactly the visited vertices and directed
edge support of the constructed walk. `Walk.vertices_trans` proves support
preservation under concatenation. `Walk.flux_endpoints` counts signed edge
departures/arrivals, including multiplicity; `Walk.closed_balanced` proves
zero flux at every word for a closed walk. `Walk.round_trip` constructs the
empty-word round trip with up-cost equal to word length and proves that it
visits the empty word.

`Reach E` is undirected reachability generated only by the explicit edge set
\(E\). `rooted_star` proves rootedness in the union of the host excursion,
root round trip, and requester attachment loops, provided their constructed
contact words are visited as specified. It assumes no connectivity conclusion
and does not use all edges of the unrestricted hierarchical graph.
`Walk.reaches` proves its underlying path-to-support fact from the actual
step constructors. `attach_layer` extends rootedness along retained base-layer
edges from a touched anchor, rather than assuming an entire layer is rooted.

`budget_bound` states for natural numbers
\[
q+\mathrm{others}+\mathrm{short}
\le q+\mathrm{others}+p+\mathrm{unused}
\quad\text{if }\mathrm{short}<p.
\]
Here `others` is the sum of nonminimum-group requester periods, \(p=p_j\),
and `unused` is the total of the other minimum-group budgets. The cost indices
of the walks used in this substitution were constructed and proved above.

## What this compiler run does not verify

No single top-level Lean declaration packages all host groups and all their
requesters under the original `lem:host` quantifiers. Finite minimum selection,
lexicographic sorting, derivation and substitution of the component hypotheses,
and the final identification of all original participating layers are assembled
in the complete universal mathematical proof in `proof.md`.
Those source-to-model and assembly steps require independent mathematical
review and are not represented as a kernel-closed proof of the entire host
lemma in the ledger.

The period-36 finite replay in `exact_certificate.json` is a distinct concrete
experiment, not a replacement for these universal statements.
This file is the intended reading of the declarations above; the compiler
checks those declarations, not the correctness of this reading.
