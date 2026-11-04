# Pointed supports and an exact antichain reduction

This note proves the lemmas behind an exact computer-assisted exclusion and
defines its separating full-signature invariant. A finite collection has now
passed a separately implemented complete closure check, followed by independent
correctness and statement-fidelity acceptance by `reviewer:e04396ae5d6f` at
2026-11-03T15:29:48Z. Novelty and publishable significance remain uncertified.
The independently reviewed signature algebra and completion-live projection
are used without changing either definition.

## What information is needed along a unique routing

Write `supp(N)` for the set of nonzero entries of a live-projected full
signature. A **pointed support** is `(g,A,q,S)`, where `S = supp(N)` and
`N(q)=1`. Only the distinguished entry q is asserted to be unique. Other
entries in S may have any positive count. Closed routing types remain in S.

An operation on full signatures has a nonnegative counting formula. For a
unary operation, each contributing choice consists of an input routing and,
for edge introduction, whether the new edge is selected. For a binary join,
it consists of an ordered pair of child routing types. Each choice contributes
the input count or the product of the two input counts.

**Pointed-support lemma.** Fix the distinguished child routing, or the two
distinguished child routings at a join. An output routing descended from this
choice has count one if and only if:

1. the distinguished choice produces that routing; and
2. no other supported choice produces the same routing.

Its output support is the union of the outputs of all supported choices,
followed by the reviewed live projection.

Indeed, the distinguished contribution is exactly one. Every other supported
choice contributes a positive integer, so its presence, not its multiplicity,
decides whether uniqueness is lost. No subtraction or cancellation occurs.
This proves the assertion for edge introduction and arbitrary binary joins,
as well as for introduction, forgetting and relabeling. A live output never
needs a discarded child entry, by the reviewed backward-liveness proof.

The lemma does **not** say that all unique entries can be recovered from one
pointed support. A different entry must have its own distinguished state.
However, a count-one output in a full construction has exactly one contributing
choice. Its child routing counts must also be one. Following these choices
backwards reaches the unique empty routing at every leaf. Conversely each
pointed transition preserves an actual unique selected edge subset. Therefore
the pointed transition system is exact for existence of a reachable count-one
routing, not just a necessary-condition relaxation.

## Support dominance

For fixed `(g,A,q)`, say that `(g,A,q,T)` covers `(g,A,q,S)` when `T` is a
subset of S. Both distinguished counts are one. This order is used between
pointed states, not between unmarked full count vectors.

**Dominance lemma.** If the larger pointed support has a legal transition
whose distinguished output is unique, replacing one or both inputs by covered
smaller supports leaves that distinguished output unique and can only shrink
the output support.

Legality depends only on g and A, which are unchanged. The distinguished
choice is still present. Deleting other supported choices cannot create a
second contribution to its output, and cannot create an output type. This
proves unary preservation and arbitrary-join preservation. Boundary
permutations transport the inclusion, so taking representatives up to every
permutation is sound. At joins every relative permutation must still be tried.

A reachable covering representative need not be a subgraph of the covered
graph. The assertion concerns continuation of the marked counting state,
not containment of graphs.

**Boundary-only join lemma.** If one operand has no interior vertices, its
join can be replaced by successive introductions of its boundary edges into
the other operand. The disjoint-edge and degree-capacity conditions make every
introduction legal. The resulting graph, with its boundary, is identical to
the join. A unique final routing restricts to unique intermediate routings:
two choices at an intermediate stage could be continued by the same remaining
selected edges, contradicting final uniqueness. Backward liveness also holds
at every intermediate stage. Therefore unary closure and dominance already
cover every pointed join with a boundary-only operand. This omits no arbitrary
join obligation; it discharges those obligations by a composition of unary
ones. The construction DAG determines whether a representative really has no
interior vertices, so this test is not guessed from an abstract support.

The join implementation may also enumerate only structurally admissible
relative permutations. At each identified vertex these require selected
degree sum at most two and rejected degree sum at most two, together with
disjoint boundary edges and a defined routing-type join. These are exactly
the underlying degree, selected-degree, live-output and connectivity tests;
the rejected degree is `g-h`, not an additional invariant. The bit-mask
enumeration in the implementation excludes no legal pointed output.

## The resulting full-signature invariant

Let R be a finite collection of pointed supports. Define the predicate on
**full** signatures

    I_R(g,A,N):
      for every live q with N(q)=1, some (g,A,q,T) in R has T subset supp(N).

Boundary permutations may be applied consistently to a representative.
Signatures with no live count one satisfy the predicate vacuously; this is
the previously reviewed absorbing case.

For an unprojected full vector, take degree compatibility
`N(q)=0 whenever h_q(v)>g(v)` as a conjunct and apply I_R to its live
projection. Every graph signature has this compatibility, and every
operation preserves it. Backward liveness then identifies the parent's
live entries with those computed from the projected children. Thus the
construction defines an operation-closed set of full signatures, not
only a predicate on the quotient.

Suppose R covers the pointed leaf and every pointed successor of its
representatives, including every legal join and every relative permutation.
The pointed-support and dominance lemmas prove that `I_R` contains the leaf
and is preserved by every legal operation. To see the only nontrivial step,
take any count-one parent entry. Its unique contributing choice picks
count-one child entries. The predicate supplies smaller representatives for
those entries, dominance preserves the distinguished unique parent entry,
and the closure condition supplies its parent representative.

Thus, if R has no representative with

    g=(2,2), A empty, q=the open u-v path,

the invariant excludes **every** such full signature, regardless of its closed
routing entries. No terminal exclusion was assumed in this induction.
The degree data already exclude a boundary-only graph in this case.
Likewise absence of an empty-boundary closed representative excludes a
unique Hamiltonian cycle.

There are finitely many pointed supports, at most

    5^b * 2^C(b,2) * s_b * 2^(s_b-1)

at boundary size b. Keeping only inclusion-minimal supports for each
`(g,A,q)` is therefore a finite, sound exact search. A construction term is
retained for every inserted representative, including those subsequently
dominated, so a reached terminal obstruction can be reconstructed rather
than treated as an abstract vector.

## Exact separating collection

Take R to be the active rows of `marked_support.frontier.json`, together with
all their boundary relabelings. Each hexadecimal support is an exact bit set
in the routing catalog order of `full_signatures.catalog`; each marker is a
zero-based catalog index. The construction DAG includes inactive rows needed
to reconstruct representatives. Reusing a child DAG node at a join means two
copies with disjoint interiors, not identification of their interior vertices.

| Boundary size | Active representatives | Structural-marker keys | Largest representative order |
|---|---:|---:|---:|
| 0 | 1 | 1 | 0 |
| 1 | 1 | 1 | 1 |
| 2 | 3 | 3 | 2 |
| 3 | 16 | 14 | 10 |
| 4 | 289 | 216 | 11 |
| 5 | 3333 | 2421 | 12 |

`marked_support.py` generated 3917 rows, of which 3643 remain active.
`verify_marked_closure.py` does **not** import that search program. It
reconstructs every row with the reviewed full counting algebra, independently
enumerates admissible relative bijections by recursion, and checks coverage
under all boundary permutations. It checked the following exact obligations:

* one pointed leaf;
* 26062 unary operations, with 11234 unique pointed outputs, all covered;
* 4921030 pairs of non-boundary-only operands, considering every admissible
  relative bijection, not just identical boundary orderings;
* 590439 admissible relative joins, of which 9076 have a unique distinguished
  output and all are covered; the other 581363 fail uniqueness;
* 677130 operand pairs discharged by the proved boundary-only join lemma;
* no terminal open obstruction and no empty-boundary closed obstruction.

Unordered representative pairs suffice because join is commutative. Every
join of two relabeled representatives is a tested relative bijection after
a common relabeling of the output. This is coverage of arbitrary joins, not
a restriction to canonical-label joins.

The checker exited zero, with result `marked_support.closure.json`. The
provenance checks establish actual realizability and distinguished count one;
the closure checks, rather than a graph census up to order twelve, give the
all-orders conclusion. The collection's absence of either bad marker and the
proved invariant establish the exclusion as explained in
`treewidth_four_theorem.md`. This is an independently accepted computer-assisted
proof, not a Lean/kernel certificate or a verified novelty claim. The source
and separating certificate are unchanged since the accepted replay.

The native checker command is:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/verify_marked_closure.py research/marked_support.frontier.json \
  --output research/marked_support.closure.json
```

The first durable execution on CPU 0 timed out and is a non-conclusion.
An unchanged checker and unchanged input completed on scheduler-granted CPU 3
in 21.2 wall seconds. Both receipts and terminal statuses are retained; this
does not assume that CPU 3 will be available for a later replay.

Compared with the previously accepted reductions, the substantive improvement
is a **closed separating collection**, not just the pointed-support
compression. No terminal count-one exclusion is assumed by the induction.
The reachable I6 obstruction remains covered, no parity restriction is
imposed, and closed routing entries are retained throughout.

The separate membership run `marked_support.examples.json` confirms this
explicitly: the reachable I6 unique marker is covered, and the reviewed
19-, 21- and 18-path terminal graphs remain admissible with all four nonzero
closed entries retained. Their previously accepted exact path counts were
not redundantly re-enumerated.

## Technical attribution

The publication comparison in `treewidth_four_theorem.md` identifies
antichain inclusion for finite tree automata as a close predecessor:
Bouajjani et al., FIT-TR-2008-001 (17 July 2008), Section 4, report pp. 6-7,
doi:10.1007/978-3-540-70844-5_7, uses a distinguished run and a support ordered
by inclusion at fixed run. Width-based automated theorem proving also
predates this work; arxiv:2205.10995v3, Appendix H.8, p. 38, explicitly uses
Hamiltonian boundary degrees and endpoint matchings, and
arxiv:2605.11025v1, Section 5.4, tests relative-permutation joins.

These are attribution limits, not assumptions needed by the elementary
lemmas proved here. General pointed-support/antichain or exhaustive-join
method priority is not claimed. The submitted mathematical advance is
the exact separating collection and its count-one interpretation for
the quartic width-four algebra, producing the independently accepted
all-orders exclusion. Whether that precise theorem is original and
publishable remains for Host independent review.

The Jacobian adapter was also queried before implementing this quotient.
The inspected `graph.hamiltonian_path.decide` contract decides existence on
at most 18 vertices; it has neither prescribed endpoints nor multiplicities
and cannot certify this closure. One bounded run used two added pendant
leaves to force the endpoints in the previously reviewed split-K5 example.
The typed answer is `EXISTS`, and its explicit path was checked edge by edge.
Server 0.14.0, protocol 2025-11-25, the exact request and the typed answer are
preserved in `jacobian/terminal-path.*.json`; adapter exit status was zero,
with no timeout or structured error. This is only a finite existence check.
