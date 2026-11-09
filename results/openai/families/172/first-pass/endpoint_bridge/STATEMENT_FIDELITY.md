# Statement fidelity: the section-6 algebraic endpoint bridge

The principal declaration is `EndpointBridge.endpoint_bridge` in `Main.lean`.
Its supporting declarations certify `groups:fractions`,
`groups:averaging`, and the algebraic content of `groups:endpoints` in the
staged September 23, 2026 manuscript. This is not a formalization of the
classification theorem or its analytic, Euclidean-extension, ultrafilter,
compactness, or coloring arguments.

## Objects and hypotheses

* `I` is an arbitrary finite coordinate type, with `2 <= Fintype.card I`.
  Thus `s` is not fixed or bounded. No commutativity instance is imposed on
  the ambient group.
* In the principal declaration, `K = FreeGroup E`, for an arbitrary label
  type `E`. `exponent E` sends every free generator to `1` in the additive
  integer group, written multiplicatively. `letterKernel E` is its kernel,
  exactly the manuscript's `N`. `letter_difference` proves, rather than
  assumes, that any two letters have quotient in `N`.
* `A : Set (I -> K)` is the set of allowable unit-copy factors. `CopyRep A`
  is an inductively generated expression: arbitrary diagonal factors have
  degree zero, factors in `A` have degree one, and concatenation adds degrees.
  The degree is attached to a chosen expression, not to an endpoint.
  `copyGrading A` supplies the diagonal and concatenation operations from
  these constructors; neither inverses of copy factors nor an Ore condition
  are constructors.
* `pairProjection` is the actual submonoid of `K x K` consisting of pairs of
  coordinates of represented expressions. `PairProjectionHyp` says, for
  every distinct pair of indices, that this submonoid is closed under
  inversion and contains every pair of elements of `N`. For a submonoid of
  a group, closure under inversion is precisely being a subgroup.
  `pairHyp_of_projections` derives the elementwise inverse-denominator and
  `N x N` lifting statements used in the proof. Thus those statements are
  not extra surjectivity or localization assumptions.
* `H` is an arbitrary finite group acting on an arbitrary finite type `X`.
  The action need not be faithful, free, or transitive. The trivial group,
  singleton orbits, and empty `X` are included. `label : X -> E` identifies
  each point with its free-group letter; injectivity is not needed.
* `f,g : I -> X` satisfy the stated orbit hypothesis for each coordinate.
  Every tuple of letters at `h * f`, for `h : H`, is a permitted unit-copy
  factor. In the geometric application this follows because the action is
  by coordinate permutations and the `f` configuration is congruent to the
  original configuration.
* `q` and `delta` are arbitrary positive real numbers. There is no assumption
  `q < 1` or rationality assumption.

## Certified intermediate statements

`Grading` abstracts only degree-zero diagonal inclusion and additive-degree
concatenation. Its concrete instances are constructed inductively above.
`Fraction R z n` means that actual numerator and denominator expressions
represent `z = u * v^-1` and have degree sum exactly `n`.

`single_multiply` and `pair_multiply` prove the manuscript's denominator
constructions with the displayed noncommutative order. The latter uses only
the inverse in a pair projection and disjoint supports; no cost estimate
on its auxiliary denominator is asserted. `supportedSubgroup` and
`supported_normal` prove that each `L_i` is a normal subgroup.
`singleCost` is the infimum of the natural-number costs. Its minimum is
proved represented by `singleCost_spec` whenever the element belongs to
`L_i`. Its value outside `L_i` is not claimed to represent a fraction.
`singleCost_inv`, `singleCost_conj`, `singleCost_mul`, and `tuple_fraction`
prove the minimum-cost identities and tuple cost bound.

`derived N 0 = N` and
`derived N (r+1) = [derived N r, derived N r]`.
`derived_inclusion_aux` inducts on the arbitrary finite coordinate
cardinality, projecting away two different coordinates and lifting the
pair-supported commutator factors. `derived_inclusion` proves
`derived N (s-2) <= L_i`, including `s=2`. It does not take this inclusion
as an argument. `correctionCost` constructs the manuscript's maximum of
the coordinate costs on this derived subgroup, and proves all the
`InvariantCost` fields used later.

`PermRep` is the exact positive-degree permutation-expression grammar:
degree-zero common diagonals, one letter tuple for each `h : H`, and
ordered concatenation. `perm_reindex` proves reindexing preserves degree.
`average` uses a fixed list enumerating `H`; products in the ambient
group retain this order.

`average_derived` passes only the relevant orbit values to their subgroup's
abelianization before reindexing its product. `membership_depth` processes
the finite set of orbit anchors and proves membership in every required
derived depth, preserving previously achieved normal-subgroup conditions.
It does not assume the orbit membership conclusion.

`omit_one_cost`, `contract_values`, and `iter_values` prove the
`(|H|-1)^k` cost bound while `iter_rep` proves degree `|H|^k*m`.
`geometric_small` proves existence of a suitable exponent for every positive
real tolerance, including `|H|=1`. `iter_preserves_bound` proves that every
previous same-orbit cost/degree bound is preserved. `simultaneous_averaging`
then processes all anchors, so its conclusion is simultaneous on every
orbit, not just one selected orbit. Although this reusable declaration
accepts an invariant cost, the principal theorem instantiates it with
`correctionCost`, whose properties were proved from represented fractions.

`abstract_endpoint_bridge` is a structural generalization to any group and
normal subgroup when the initial seed differences are in that subgroup.
The principal `endpoint_bridge` removes that seed hypothesis using the
proved exponent-kernel calculation for free-group letters.

## Exact conclusion and path interpretation

The principal theorem constructs a permutation expression `w` of degree
`m > 0`, and genuine `CopyRep A` expressions `u,v` of natural degrees
`a,b`, such that

```
(w at f) * u = (w at g) * v
a + b <= s * delta * m.
```

In particular, the endpoint discrepancy used internally is
`(w at f)^-1 * (w at g)`, not the inverse or the opposite quotient.

`WeightedPath A T q` is an inductive positive-copy path grammar: diagonals
of weight zero, unit factors in `A` of weight one, scaled factors in `T`
of weight `q`, and concatenation with summed weight.
Here `T = scaledCopies (letters label) g` is exactly the family of
permutation-reindexed `g` tuples. `perm_path` and `copy_path` prove that the
same expression and the actual corrections produce paths of weights

```
lambda = m + a > 0,
mu = q*m + b >= 0,
mu/lambda <= q + s*delta.
```

Thus no inverse copy factor or negative weight is introduced.
For the manuscript's geometric instance, the hypotheses that every
`A` factor is a congruent unit copy and every `T` factor has squared-distance
scale `q` identify this smaller path grammar with permitted manuscript paths.
The compiler checks the universal algebra and assigned-weight bookkeeping,
not Euclidean distance preservation itself. The geometric pair-projection
lemma and the production of the initial `f,g` are separate dependencies.

The compiler does not verify this English reading or scientific novelty.
The four printed axiom reports are restricted to Lean's standard
`propext`, `Classical.choice`, and `Quot.sound`; no new axiom replaces a
manuscript step. Independent Reviewer confirmation remains required.
