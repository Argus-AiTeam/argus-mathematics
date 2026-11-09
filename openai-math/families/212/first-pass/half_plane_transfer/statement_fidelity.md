# Statement fidelity: deterministic cut-transfer core

This document describes the declarations in namespace `HalfPlaneTransfer`
in `Main.lean`. They are universally quantified deterministic implications,
not a formalization of an iid probability space or of the no-bigeodesics
theorem.

## Objects and hypotheses

`PassageModel V Adj` consists of edge costs, finite passage distances, the
lower bound of every admissible finite walk by its passage distance,
attainment of each distance by a finite walk, and the triangle inequality.
`walkCost` sums edge costs with traversal multiplicity, so loops and
repeated edges are not suppressed. `IsWalk` uses the common adjacency
relation. Actual finite FPP minimizers and their distances instantiate
these fields; this instantiation is mathematical, not checked by Lean.

`height : V -> Int` is an integer-valued signed height. On an admissible
step its increase is at most one. For the upper case take height equal
to the second lattice coordinate and cut equal to `-n`; for the lower
case take its negative and cut equal to `n`. Both are valid for
nearest-neighbor lattice walks.

`SharedOnSide` requires equality of the two edge costs when both signed
heights are at least the cut and at least one is strictly greater. It
does not require equality of horizontal cut edges. This is implied by
the actual upper coupling and also by the actual complementary lower
coupling. `b` is the rooted original Busemann potential, so the increment
is `b v - b u`, with that sign. Its domination hypothesis concerns the
original distance only. `rho` is the rooted linear part, represented by
its values; algebraic barrier lemmas do not require its linearity.

## What is proved

* `strictSideOnInterval` and `lastCut` prove last-cut localization from
  the integer step bound and the endpoint side. The last index is
  selected over all visits, not the first visit. `walkCostSplit`,
  `walkPrefix`, `walkSuffix`, and `walkCostCongr` justify decomposition
  and the unchanged suffix with traversal multiplicity.
* `cutTouchLowerBound` proves the additive lower bound on every
  cut-touching walk. `oneTargetDistanceEquality` then proves exact
  equality of distances when both cut barriers dominate the original
  target's calibration defect. The barriers are hypotheses of this
  intermediate lemma, not of the final asymptotic comparison alone.
* `retainedRootMinimizing` proves preservation of all minimizing root
  prefixes of a calibrated unchanged path. `rootMinimizingSegments`
  proves that root-prefix minimality implies minimality of every finite
  segment. Simplicity and nearest-neighbor adjacency of the original
  infinite path are unchanged and are not separately encoded as a ray
  type. `eventualDistanceEquality` permits a different target-index
  threshold for every fixed basepoint.
* `movingComparability`, `fixedUpperComparability`, and
  `fixedLowerComparability` prove the radius/displacement inequalities
  used in the report. Euclidean triangle and vertical-coordinate bounds
  giving their premises, and compactness giving the strictly positive
  opposite-semicircle norm gap, are proved in prose, not in this file.
* `movingBarrier` and `fixedBarrier` derive positive barriers from
  metric approximation, the norm/functional gap, and **both** rooted
  potential errors. `movingCutBarriers` quantifies over every cut vertex.
  `movingCutDistanceEquality` composes that derivation with the finite
  walk theorem: it assumes explicit approximation and gap bounds, not
  an already proved distance barrier.
* `MetricApprox` is the uniform two-endpoint asymptotic metric estimate.
  `RootApprox` is the global epsilon-times-radius plus finite-constant
  form of rooted sublinearity. `eventualFixedBarrier` derives a
  cut-uniform positive barrier from these asymptotic hypotheses.
  `asymptoticTransfer` composes it for both metrics with last-cut
  comparison, proving exact eventual distances for **every** sufficiently
  distant sector basepoint. Its norm-gap premise is
  `g * (rad x + rad z) <= m x z - (rho z - rho x)`; the report derives
  this from the contact gap and the proved comparability constants.
  It does not assume the disputed barrier.
* `twoCoordinatesFromLimits` proves equality of two real coordinates
  from eventual equality and limits in the two independent directions.
  Its sequence arguments are the Busemann evaluations divided by the
  direction's positive integer multiplier, not raw distances.
  In the upper application the limits are the vertical coordinate and
  the sum of both coordinates. In the lower application they are their
  negatives; applying the declaration to negated coordinates gives
  exactly the same conclusion.
* `finiteWitnessThreshold` combines finitely many basepoint-dependent
  eventual assertions into one target threshold.
  `busemannWitnessEquality` takes the limits of differences of two
  eventually equal distance sequences, preserving the exact Busemann
  evaluation, not merely its sign or an approximation.

## What remains outside the compiler

The report supplies the probability-one common event; the deterministic
subsequence by identical marginal laws and Borel--Cantelli; the
compactness/contact gap; Euclidean geometric instantiations; conversion
of lattice rooted sublinearity to `RootApprox`; choice of retained upper
paths and lower anchors; existence and linearity of the new Busemann
functions; and their two directional limits. Finite intersections over
witness sets and maxima of finite ray thresholds are also in prose.
No uniform Busemann convergence over labels and no uncountable
intersection of fixed-label events is a hypothesis.

The upstream structural theorem and its minimum-moment boundary-comparison
dependency are explicit assumptions in the claim ledger. A successful
compile certifies the declarations above only; it neither checks those
external theorems nor establishes novelty or the whole FPP theorem.
