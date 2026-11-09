# The compressed consistency reduction

The target is Theorem `comp:reduction` in
`../openai_manuscript/Unconditional-time-lower-bounds-for-Weisfeiler-Leman-equivalence-September-25-2026/build/sections/02-compression.tex`.
The reviewed claim EP and its source and fidelity document are unchanged.
No complexity lower bound follows merely from this reduction.

## Mathematical scope

The inputs have r >= 3, m >= 2, arbitrary finite real value dimensions,
partial coordinate injections, zero endpoint linear forms, and possibly loop
and parallel comparison schemas. Consistency means equality of the two
individual scalar images of nonempty sets, not simultaneous solvability.
The output graphs include j(N+1) private marks at each valuation vertex of
block j, a universal hub, and exactly q arbitrary additional hub leaves on
each side, for every natural q.

The inherited Wiki has no entry on this theorem. The upstream game modules
provide prior source evidence for specialized constructions, not a local
certificate for the present arbitrary-dimension, arbitrary-padding theorem.
In particular, final simple graphs do not forbid loops or parallel schemas
in the input instance; these are different notions.

## Verification theorem and improvement over EP

For every permitted instance J, add one unused dimension-one real type,
subdivide each schema with n = 4(r+1) private scalar types, and perform
the manuscript's valuation-block, private-mark, hub, and padding construction.
For every natural q, the two resulting uncolored graphs have equal order,
are simple and connected, and have diameter at most two. Duplicator wins
their announced-bijection (r+1)-pair game if and only if J is individually
scalar-image consistent.

More explicitly, let D >= 1 bound the original real dimensions and put

    S = r (|P| + 1 + n|E| + (n+1)|E|),   A = 2^(2D+2) S.

Either graph has order at most

    (A^3 + A^2 + A + 1) m^6 + q.

The strongest prior result relevant here, reviewed EP v4, extends prescribed
small lists of offsets. It does not by itself prove a preannounced total
bijection, recover consistency from an arbitrary winning strategy, or
handle owner-only marks and uncolored degree recognition. The new formal
suffix proves these interfaces and the order estimate. The statement of
the reduction is the manuscript's theorem; the contribution here is its
independent universal formal certification, not a new complexity lower bound.

## 1. Precise game semantics

A position is the relation of marked pairs. It must preserve equality and
adjacency. A winning-region invariant is a set S of positions that consists
of partial isomorphisms, is closed under discards, and satisfies

    p in S, |p| < K  ==>  exists one vertex bijection f,
                          for every x, p union {(x,f(x))} is in S.

This is the exact quantifier order in `Game.Invariant`.
It is equivalent to the usual labeled K-pair safety game:

In the invariant-to-strategy direction, erase labels from each public
position. After any discards that leave a vacant label, there are at most
K-1 distinct pairs. Announce the invariant's bijection and use the selected
vacant label. Repeated identical pairs do not change the relation, and
partial isomorphism of the relation checks every labeled pair as well.

Conversely, let S contain the relations of all winning labeled positions.
This is a winning region, not a claim that an input strategy is memoryless.
A position remains winning after discards: simulate the old position with
the erased labels private, deleting a private pair when its label is reused.
Thus S is downward closed. If a member has fewer than K distinct pairs,
some label is vacant or two labels mark the same pair; in the latter case
discard one duplicate while keeping the relation unchanged. The winning
continuation at that vacant label supplies one bijection for all selections,
whose successor relations are in S. This proves the required invariant.
Every losing play is witnessed by a finite prefix, so surviving every
finite continuation is the infinite safety-game condition.

This elementary representation bridge is a prose proof. The Lean source
defines and proves the winning-region formulation; it does not pretend
to encode a separate labeled-game datatype.

## 2. Uncolored block recognition

Number the B blocks from 1 to B. The two sides have equally many
valuations in each block: addition of any legal affine valuation is a
bijection between its homogeneous and affine fibers. Such a valuation
always exists, since a square's vertical bit can absorb its boundary.
This does not use consistency. Write N for either base order.

Each base vertex of block j has j(N+1) private marks and one hub edge.
Its remaining degree is between 0 and N-1. Thus its degree lies in

    [j(N+1)+1, j(N+1)+N].

These intervals are disjoint and exceed two. Marks have degree two,
padding leaves degree one, and the hub has degree N + sum_v weight(v) + q.
If N >= 2, the other base vertices have enough marks to make this last
degree strictly larger than every base degree.

A winning position with two available pair labels preserves degrees:
discard all but the queried pair, ask for a spare-pair bijection, and
compare adjacency with the queried vertex for every possible selection.
The bijection therefore maps its neighborhood bijectively to the other
neighborhood. Consequently every answer to a queried base vertex is a
base vertex of the very same block, on the actual uncolored graphs.

The unused dimension-one type changes no comparison. Extend a consistency
witness by its full vector space, or restrict it to the old types.
Its site fiber contains the two distinct scalar valuations, proving N >= 2.
This handles even an originally empty type/schema collection.

## 3. Sufficiency with the announcement in the correct place

An active block contains a pebbled base vertex or the owner of a pebbled
mark. Retained marks activate their owners even when those owners are not
pebbled. At most one block is active per pair.

Maintain an EP offset family on the active blocks, with every pebbled
base vertex translated by its block offset. A pebbled mark is carried
to the mark of the translated owner with the same local mark index.
The hub and the indexed padding leaves are fixed.

After discards, at most r blocks are active. For each prospective block b
separately, use exact projection to extend the same retained list to
U union {b}, of size at most r+1. Select the b-offset from that extension.
Offsets on retained blocks agree with the retained list. The disjoint union
of all block translations is now one bijection on all base vertices.
Lift it to all marks by owner translation and unchanged local indices,
and fix the hub and padding. Announce this entire bijection before any
vertex is selected.

Only the selected block's extension is committed after selection.
Extensions for two different unselected blocks need not agree with one
another: the game does not commit both. For two occupied blocks, addition
of identical offsets on each shared readout preserves agreement and
disagreement; within a block the translation is injective. The owner
rule preserves all base-mark incidences and nonincidences, even when a
previously unpebbled owner is selected. All other structural adjacency
cases follow directly from the hub/leaf definition. This is the invariant
proved by `safe_partialIso`, `safe_discard`, and `safe_announce`.

## 4. Necessity from all winning queries

For a block set U, let a zero query pair the zero homogeneous valuation
of each block with its affine answer. A global named-readout function F
encodes the answers when their shared readouts agree. Call F a candidate
on U when these valuations are legal and the resulting query position
is winning. This uses all winning query positions, whether or not a
particular fixed strategy visits them. No memoryless input strategy and
no simultaneously satisfying vector assignment are assumed.

Candidates restrict to smaller block sets by discarding pairs. They also
extend by any one block while the pair budget permits. Announce the
winning continuation and select that block's zero vertex. Recognition
forces an answer in the same block. Whenever it shares readouts with a
retained block, the two distinct zero source vertices are adjacent, so
their answers agree on every shared readout. Patching the new answer into
F is therefore well defined. If the block was already retained, equality
forces the same answer. Starting from an empty-position win gives a
candidate on every block set of size at most r+1.

At a real type P and address a, define Q(P,a) to be all sums of the
horizontal answers on the r-site ring at (P,a), over its winning
candidates. Every Q(P,a) is nonempty. For internal scalar types use the
analogous sets of scalar ring sums.

For a fixed link, replace its r left sites by the r squares row by row.
Each new square and the old site coexist on the spare pair, so the
horizontal answer is preserved. Discard the old site only after this
comparison. The final square ring has a common value for each shared
vertical. Summing its r equations cancels each vertical twice over F2,
and the marked seam contributes its link constant exactly once:

    lambda_left(sum left horizontals)
      + lambda_right(sum right horizontals)
      = left_constant + right_constant.

Replace the squares by their right sites in the same manner.
For each starting winning left query this constructs a winning right
query with the same affine scalar value. Starting on the right and
reversing the replacements proves the opposite image inclusion.
These are equalities of sets, not a single chosen vector on the whole wire.

At the first link the left image is the original left affine form on
Q(P,a). Each internal link equates two scalar ring-value sets. The last
link gives the original right affine image on Q(R,sigma(a)); its
coordinate matches are exactly the partial injections. Induction along
the n internal types therefore proves the required individual-image
equality. The argument applies separately to every comparison, including
loops and parallel schemas. In a self-loop it is legitimate, and sometimes
necessary, for the two endpoint occurrences to use different vectors
from the same Q.

These steps are the checked declarations `candidate_extend`,
`replace_cover`, `link_transfer`, `link_transfer_reverse`,
`normalized_images`, `first_images`, `internal_images`, `last_images`,
and `game_implies_consistency`.

## 5. Order and actual enumeration

Before the unused type is added, there are at most

    r (|P| + n|E| + (n+1)|E|) m^2

blocks. The added type replaces |P| by |P|+1. A block is indexed by a row,
a subdivided type or link, and two consecutive coordinate labels.
Enumerate these coordinate pairs and test membership in the two relevant
one-coordinate tables. No enumeration of [m]^r occurs in this construction.
The scalar forms are bounded-size data for fixed description shape.

A site fiber has at most 2^D valuations. A square has at most
2^(2D+2) raw valuations, hence at most that many legal valuations, even
when endpoint dimensions or linear forms vanish. Every fiber is nonempty.
Consequently B <= N <= A m^2. The marks number at most NB(N+1), which
is at most N^3+N^2. Adding the N bases and the hub proves the displayed
sixth-power bound. Padding adds exactly q, rather than satisfying a bound
independent of an arbitrary q.

This also gives an explicit enumeration procedure: list the pair-indexed
blocks, enumerate their constant-size legal fibers, compare their finite
shared-readout lists to build the base edges, enumerate owner marks,
and add the hub edges and the q hub leaves. The formal theorem bounds
the number of blocks and vertices, not the running time of the
noncomputable Lean enumeration. The Python replay uses the explicit
pair-indexed enumeration.

The hub gives every two distinct nonadjacent vertices a common neighbor,
so both connectedness and the diameter bound hold for every q.

## 6. Refinement conventions, proved separately

This section is an elementary finite stable-color proof, not a Lean
formalization of the refinement algorithms. For joint k-refinement,
equal stable colors give a bijection f matching each replacement-color
vector at once. Thus the same f works for all k replacement coordinates.
For separate refinement they give a possibly different f_i for each
specified replacement coordinate.

For joint refinement, maintain full (k+1)-tuples, with virtual entries
in vacant slots, such that every k-coordinate projection has equal stable
colors. A related k-tuple pair extends to such full tuples by any
replacement-vector matching. To fill a vacant slot, apply that matching
to the other k slots and announce its f; every selection preserves the
invariant. Coordinate permutations preserve stable colors by induction,
and k >= 2 ensures every pair of actual entries belongs to a projection.
For the converse, induct on the refinement round from a winning position
with k marked pairs. Request the spare pair and then discard any one
old coordinate. The single announced bijection works for all coordinates,
so the joint replacement-vector multisets agree.

For separate refinement maintain one related full k-tuple with virtual
vacant entries. Slot i uses its f_i after the slot is chosen. Conversely,
remove pair i, announce the winning bijection, and replace it. Induction
on the round gives precisely that slot's replacement multiset equality.
This needs k pairs, not k+1.

From an empty-position winning strategy, place k pairs in a fixed order.
The successive prefix-dependent bijections give a bijection of the tuple
spaces: invert the first announced bijection, then the second determined
by that recovered prefix, and so on. Every matched tuple pair has equal
colors at every round by the preceding inductions, hence equal histograms.
Conversely equal stable histograms supply a related tuple pair, whose
entries can all initially be virtual in the corresponding invariant.
This proves the empty-position equivalence in both conventions.

Thus K = r+1 corresponds to joint r-WL and separate (r+1)-WL.
The joint statement is also the cited proposition in
arXiv:2308.11970v2, Section 2, Lemma 2. Its registry resolution and the
passage actually read are local; independent proposition attribution is
reserved for the Host Reviewer, not self-filed by the citation's author.
The separate convention follows from the direct proof above, not from
silently extending the scope of that citation.

For pure tuples inside the disjoint union, stable colors at k >= 3 detect
whether two entries are equal, adjacent, or have a common neighbor,
by replacing a third coordinate and inspecting its two atomic adjacencies.
Here this is exactly component membership because the graphs have diameter
at most two. A stable witness bijection therefore restricts to the desired
opposite-component bijection, with another coordinate as anchor. Conversely
unite the two local winning strategies, one in each direction, swapping
components. Each may announce a bijection after the global discards; commit
only the selected component's continuation. Cross-component pairs have
neither equality nor adjacency. The successive-bijection tuple argument
then proves equality of the pure-tuple histograms. This is compatible
with both conventions and uses their respective parameter shifts.

## Evidence and replay

`Main.lean` includes the approved EP proof closure unchanged and proves the
universal reduction as `Augment.compressed_reduction`. The same source
proves equal orders, exact padding growth, connectedness, diameter at most
two, and the explicit order bound. `statement_fidelity.md` separates the
formal statements from the elementary representation, refinement, and
enumeration arguments above.

The exact finite replay is deliberately new rather than a repeat of EP's
old projection tests. It transports two opposite starting sums all the way
around an identity-address self-loop with opposite endpoint constants.
The end sum flips, so this consistent instance has no single globally
satisfying endpoint vector. It also checks one preannounced translation
on the actual block fibers and virtual owner marks, including marks whose
owners are unpebbled, and checks exact degrees, orders, padding, zero
dimensions, zero forms, empty domains, parallel comparisons, partial
injections, and non-affine witness sets. These are bounded tests, not a
decision of every finite game and not the universal proof.

The Jacobian calculation is one bounded GF(2) augmented wire matrix.
Its coefficient rank is 16 and augmented rank 17; summing all rows gives
zero coefficients and constant 1. This certifies rejection of an
inconsistent input, not a counterexample to the manuscript. The exact
payload, typed response, server/protocol versions, and adapter status are
preserved in dedicated JSON files and independently replayed.

Run the claim-bound compiler and then create or replay the exact certificate:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/compressed_reduction/Main.lean --statement-fidelity research/compressed_reduction/statement_fidelity.md --claim CR --project-root . --artifact-dir research/compressed_reduction
$WORKSPACE/argus-live-update/.venv/bin/python research/compressed_reduction/verify.py
```

`exact_certificate.json` identifies the archived native compiler result
and binds its source and fidelity hashes. It is generated from real replay
results with `verify.py --write-certificate`; normal execution recomputes
and compares them. The original EP files and certificates are not changed.
No manuscript assertion was found false in this route. Independent
Reviewer replay and statement-fidelity approval remain separate from
Engineer completion and are not asserted by the compiler certificate.

The completed claim-bound run is
`certificates/CR-9a49f8af1ce0a9ed.json`, evidence
`lean-CR-66177bd2498b`: Lean 4.31.0 exit 0, no proof holes, and axiom-audit
exit 0. The ledger derives `CR` v2 as `closed_kernel` with no undischarged
assumptions. This is a compiler verdict, not an independent fidelity approval.

The exact replay completed 204 insert/discard extensions through the two
whole-wire histories. It enumerated 420 actual blocks and 2,064 base
vertices per side, checked 420 prospective block extensions, 8,257
preannounced virtual choices and 33,028 equality/adjacency comparisons,
and checked all 4,128 base degrees across the two sides. There are exactly
1,170,161,160 private marks and 1,170,163,225 unpadded vertices per side;
these large mark sets are represented symbolically, not allocated.
Padding values 0, 1, 7, and 100,000,000 were checked arithmetically and
on their new vertex cases. The universal quantifier over every natural q
comes from the Lean theorem, not from those four samples.
