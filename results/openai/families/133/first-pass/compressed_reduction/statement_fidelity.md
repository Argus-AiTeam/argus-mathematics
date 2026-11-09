# Statement fidelity: the compressed reduction

## What the formal certificate states

`Main.lean` includes the approved exact-projection source as an unchanged
prefix. All new declarations are in `CompressedReduction`. No claim is made
that a finite experiment establishes a universal game strategy.

The principal declaration is
`CompressedReduction.Augment.compressed_reduction`. Its quantifiers are:

- arbitrary finite types `P` and `E` of real types and comparison schemas;
- arbitrary natural `r >= 3` and `m >= 2`, and any marked row in `Fin r`;
- arbitrary `ProductImages.Instance m r P E`;
- every natural padding count `q`.

An instance assigns a natural dimension to each real type, two endpoints to
each schema, coordinate domains, injective maps on those domains, two linear
maps to `ZMod 2`, and two affine constants. Dimensions may be zero and have
no universal upper bound. Endpoints may coincide; distinct schema identifiers
may have identical data. Coordinate domains may be empty. Maps outside their
domains are irrelevant total extensions, not additional comparisons.

`Instance.Consistent` means the existence of nonempty sets of vectors at
every real-type/address pair, with equal individual affine scalar images
for every allowed schema/address. Sets are not assumed affine. The two
occurrences of a self-loop can use different vectors. No jointly satisfying
assignment or combined relation for parallel comparisons is assumed.

`Augment.withDummy` adjoins one unused dimension-one real type.
`Augment.consistent_iff` proves that this preserves and reflects consistency.
`dummyVertex_injective` and `two_base_vertices` prove the base-order
normalization, rather than assuming it. The wire subdivision has exactly
`n = 4*(r+1)` private internal scalar types per schema.

## The actual graph

`Construction.Base` is the dependent sum of the actual legal valuation
fibers of the site and square blocks. A site stores one vector. A square
stores two vectors and two bits, with boundary equal to the marked-row
seam constant on the affine side and zero on the homogeneous side.

`Construction.baseGraph` relates distinct blocks only when they have at
least one identical named readout and agree on every shared named readout.
Merely sharing a corner does not create an edge.

`Construction.number` bijectively numbers the blocks from 1 to `B`.
For `N` homogeneous base vertices, each base vertex of block `j` has
`j*(N+1)` private marks. `Marks.graph` puts in the actual owner-mark
edges, one universal hub, and exactly `q` hub-only padding leaves.
The vertex type is the disjoint sum of base vertices, indexed private
marks, one hub, and `Fin q`. There are no vertex-color predicates in the
game theorem. `SimpleGraph` supplies symmetry and irreflexivity.

The conclusion of `Augment.compressed_reduction` is precisely that
`Game.Equivalent` on these two graphs with `r+1` pairs is equivalent to
the original instance's consistency. It applies for every `q`, not only
to the unpadded graphs and not to a colored surrogate.

## Game quantifiers and representation

`Game.Position V W` is a finite set of pairs. `Game.PartialIso` preserves
equality and adjacency between every two marked pairs, including repeated
vertices. `Game.Invariant` is a set of positions satisfying:

1. every member is a partial isomorphism;
2. every subset after discards is a member;
3. at a member of cardinality less than `K`, there exists one equivalence
   of the entire vertex types such that insertion of `(x, f(x))` remains
   a member for every source vertex `x`.

`Game.Winning` existentially quantifies such an invariant containing the
position; `Game.Equivalent` starts at the empty position. The order is
`exists f, forall x`, not `forall x, exists f`.

This is the winning-region formulation of the manuscript's infinite
announced-bijection safety game. Pair labels are erased, and identical
duplicate pairs occupy one relation entry. The elementary equivalence with
labeled-pair play is proved in the report: pull an invariant back to labeled
positions; in the other direction use the winning region, discard duplicate
labels when a spare relation entry is available, and retain every distinct
pair. In particular the representation does not assume that the given
strategy is memoryless. This translation of the usual game semantics is
a mathematical reading of the definition, not an additional Lean declaration
about a separate labeled-game datatype.

`Construction.safe_announce` chooses all prospective block translations
before the selected vertex. `active` includes the owners of retained marks,
including unpebbled owners. `safe_partialIso` checks all structural vertex
cases and both directions of adjacency preservation.

For necessity, `Candidate` uses all winning zero-query positions, not one
globally compatible assignment. `candidate_extend` derives same-block
answers from the uncolored degree intervals and patches their readouts.
`replace_cover`, both link-transfer lemmas, `normalized_images`, and the
three endpoint/internal image lemmas prove both scalar-image inclusions.
`game_implies_consistency` builds the complete instance witness.

`Construction.game_iff_consistency` additionally exposes the version without
the unused type, under the explicit hypotheses `N >= 2`, `n > 0`, and
`r+1 < n+1`. The augmented principal theorem discharges all of them.

## Order, connectedness, and diameter

The following are independently quantified declarations in the same checked
source, not informal corollaries silently attached to the game theorem:

- `Augment.equal_orders`: both graph orders agree, with no consistency
  hypothesis.
- `Augment.padding_order`: the padded order is the unpadded order plus `q`,
  on either side.
- `Augment.connected`: either graph is connected.
- `Augment.diameter_two`: any two vertices coincide, are adjacent, or have
  a common adjacent vertex. This expresses diameter at most two without
  an alternative convention for the diameter of a singleton.
- `Augment.order_bound`: for every natural `D >= 1` bounding all original
  real dimensions, and every `m >= 1`, let
  `n = 4*(r+1)`,
  `S = r*(|P|+1+n*|E|+(n+1)*|E|)`, and `A = 2^(2*D+2)*S`.
  The order of either graph with padding `q` is at most
  `(A^3+A^2+A+1)*m^6 + q`.

`Construction.block_count_bound` counts a subtype of
`Fin r * (subdivided vertices + links) * Fin m * Fin m`.
Thus it counts coordinate pairs, not complete addresses.
`raw_count_bound` and `base_count_bound` are uniform fiber bounds;
`blocks_le_base` and `marked_order_bound` control the private marks.
For fixed description shape one chooses a fixed `D`, obtaining the
claimed unpadded `O(m^6)` bound. There is deliberately no bound on arbitrary
padding independent of `q`.

The Lean definitions are noncomputable finite mathematical objects. The
explicit pair-indexed enumeration and its elementary implementation argument
are given in the report and the Python graph replay; the compiler is not
claimed to verify a RAM runtime bound.

## Boundary of the certification

The stable joint/separate refinement correspondence and the optional
disjoint-union pure-tuple convention are proved in the report, not encoded
as refinement algorithms in `Main.lean`. The separate-coordinate parameter
is `k = r+1`; the joint parameter is `k = r`. The independent literature
attribution on `CR_WL` must not be inferred from the compiler verdict.

The compiler checks the encoded propositions and their proofs. It does not
check this document's interpretation, novelty, significance, or independent
Reviewer acceptance. The source's printed axiom lists and the formal tool's
axiom audit must exclude `sorryAx` and undeclared additional axioms.
No complexity lower bound, manuscript counterexample, or campaign-wide
completion is asserted here.
