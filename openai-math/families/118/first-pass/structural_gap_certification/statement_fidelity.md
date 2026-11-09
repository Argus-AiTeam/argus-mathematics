# Statement fidelity: C118_STRUCTURAL_GAP

## Scope and provenance

This is a local Lean 4.31.0 certification of the parameter-uniform structural
statement below. It is not a novelty claim, an independent mathematical
discovery, an independent Reviewer report, or a claim of Reviewer acceptance.
The domain proofs are localized from the existing OpenAI formalization, not
replaced by an assumption of its final theorem.

The read-only source root is
`openai-math/lean`.
The original root module is
`OAI.Computability.BinPacking.Results.StructuralGap` (reported upstream
toolchain: Lean 4.34.1). `Main.lean` includes its complete 44-file OAI import
closure, originally 15,821 lines, in topological order. Its only actual
external import is `Mathlib`, resolved in the existing workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
There is no OAI import or dependence on a precompiled OAI theorem.

Each included file has a source-path/SHA256 marker and its own named section
to preserve file-local scopes. `localization_provenance.json` records the
44 source hashes, dependency order, original and localized line maps, exact
compatibility edits, preamble, suffix, and a byte-exact reconstruction recipe
and hash. The existing external-source copyright/license header in
`Packing/FiniteHall.lean` is retained. No upstream file is modified.

Manuscript references below are relative to the staged directory
`research/openai_manuscript/Additive-hardness-and-unbounded-configuration-gaps-in-bin-packing-September-24-2026/build/source`.

## Exact theorem and objects

The localized declaration is
`OAI.BinPackingGap.structural_additive_gap`:

```lean
theorem structural_additive_gap (c : ℕ) :
    ∃ I : Instance, ∃ B : ℕ,
      I.n = 5 * B ∧
      (∀ i, (1 / 6 : ℚ) < I.size i ∧ I.size i < 1) ∧
      B + c < opt I ∧
      individualLP I = (B : ℝ) ∧
      typeLP I = (B : ℝ)
```

The only input is an arbitrary natural number `c`, including zero. There
are no hypotheses on this parameter and no finite-parameter testing
restriction. Both existential witnesses depend on `c`. `Instance` contains
a finite number `n : ℕ` of indexed physical items and rational sizes
`size : Fin n → ℚ`, together with positivity and capacity-one upper bounds.
The theorem strengthens the latter to the strict interval `(1/6,1)`.
The LP equalities are equalities in the real numbers; the integral bound
and the inequality `B+c < opt I` are in the natural numbers.

### Ordinary, arbitrary integral packing

In `Model.lean`, `Packing I b` consists solely of:

* an arbitrary function `assignment : Fin I.n → Fin b`; and
* for every bin `j`, the inequality
  `∑ i, if assignment i = j then I.size i else 0 ≤ 1`.

Thus every physical item is assigned exactly once. There is no restriction
to table patterns, good tuples, local states, selected supports, or particular
item species. Empty bins are allowed. Removing empty bins does not change
the minimum possible bin count.

`HasPacking I b` means `Nonempty (Packing I b)`. `singletonPacking` proves
that a packing always exists. `opt` is `Nat.find (exists_packing I)`, the
minimum ordinary feasible bin count, not the optimum of a restricted
packing model. `opt_attained` and `not_hasPacking_iff_lt_opt` in
`Packing/FractionWidth.lean` connect this definition to actual packings
and padding to a larger number of bins.

Metadata used in the analysis is transported by an equivalence from the
finite physical inventory to `Fin I.n`. It imposes no extra constraint on
`Packing`. No recovery of that metadata from a numerical size, and no
distinctness of the numerical sizes of different species, is assumed.

### Both full configuration LPs

The definitions in `Model.lean` implement the two complete configuration
spaces of `introduction.tex`, Definition `def:configuration-lp`:

* `IndividualConfiguration I` is **all** finite subsets of `Fin I.n` whose
  rational size sum is at most one. `individualMatrix` is their incidence
  matrix. Every physical item has demand one.
* `NumericalSize I` is the image of the size function, so equal numerical
  sizes are identified even when their species differ. `multiplicity`
  counts all physical copies of that size.
* `TypeConfiguration I` is **all** functions
  `NumericalSize I → ℕ` with total size at most one. Its definition contains
  no bound by `multiplicity`. In particular a type can be repeated beyond
  its input demand, subject only to capacity. The auxiliary
  `capacityBound`/`count_lt_bound` argument proves this whole configuration
  space finite from positive sizes; it does not truncate it to demand.

`FractionalCover.Feasible` means nonnegative real weights on every column
and covering inequalities `d i ≤ ∑ c, a c i * w c`.
`objective` is their full finite sum. `individualLP` and `typeLP` use
`FractionalCover.value`, defined as the infimum of all feasible objectives.
`Configurations/ConfigurationLP.lean` proves feasibility, a finite-dimensional
compact-sublevel minimum, and `exists_minimizer`, including
`individualLP_attained` and `typeLP_attained`. Consequently these infima
really are the minima of the stated covering LPs. They are not minima
over only the witness's support.

## Uniform witnesses and parameter selection

For every `c`, the theorem uses exactly

```text
G   = completeFourGraph
k   = 2
rho = (1/8 : ℝ)
I   = reductionInstance c rho G k
B   = reductionBinBound c rho G k.
```

`completeFourGraph` has four vertices and the six edges
`(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)`.
The definitions in `Packing/K4Graph.lean` and `Packing/ExtractedCover.lean`
make the uniform selection:

```text
P0 = primaryScoreBound = 100^11
K  = lossAllowance c = 25*(c+1)*(1+5*P0)
d  = depthDemand c rho
   = Nat.ceil (max (72*(K:ℝ)) (120*(K:ℝ)/rho))
T  = reductionTrees c rho = competingTrees d (depthDemand_pos c rho)
P  = T.quotaTotal = sum of its depth quotas at depths 1,...,T.height
R  = repetitions P 4 K = 100*(P+4*K+1).
```

For this fixed `rho`, the displayed ceiling selects exactly `d=960*K`.
The Lean proof uses the literal ceiling definition and its proved bounds
`d≥72*K`, `d≥120*K/rho`, and `d>0`, rather than requiring a separately
assumed formula for `d`. The competing trees are actually constructed:
`competingTrees` uses the iterated auxiliary-tree construction and
`CompetingTrees.ofAuxiliary`, not an assumed existence theorem.

`reductionInventory` is `InventoryData.ofCompetingTrees G T R k`;
`I` is its rational scalar-encoded `packingInstance`. If
`t=d*card(T.plus.Node)+P+d*card(T.minus.Node)`, then
`InventoryData.B_closed` gives `B=4*t+24*d*R` for this graph.
`reductionInstance_count` proves `I.n=5*B`, and
`reductionInstance_size_bounds` proves the strict size bounds.
These are symbolic definitions and proofs for arbitrary `c`; none
enumerates the enormous instance or specializes the proof to sample values.

The only auxiliary conditions used at the final specialization are
`2≤4`, `4=2*2`, and `0<(1/8:ℝ)`, all discharged in Lean.

## Manuscript-to-declaration map

Paths in this table are under `OAI/Computability/BinPacking/` and are
included, not imported, in `Main.lean`. Namespace prefixes are
`OAI.BinPackingGap` unless indicated otherwise.

| Staged manuscript component | Localized definitions and proof declarations |
| --- | --- |
| `trees.tex`, `lem:competing-trees` | `UniformTree`, `AuxiliaryTree`, the fork gadget's `avoids`, grafting and color-count lemmas in `Trees/TreeAttachment.lean`, `Trees/TreeColorCounts.lean`, `Trees/TreeAvoidance.lean`; `AuxiliaryTree.step`, `buildAuxiliary` in `Packing/PhaseIteration.lean`; `CompetingTrees.ofAuxiliary` in `Trees/TreePruning.lean`; `competingTrees` in `Trees/CompetingTrees.lean`. Both separate rich markings and the shared obstruction are constructed. |
| `instance.tex`, parameters and `lem:geometry` | `lossAllowance`, `depthDemand`, `repetitions`; `Trees/IntegerTreeGeometry.lean`, `Trees/CompletionGeometry.lean`, `Trees/TestGeometry.lean`, `Packing/CoordinateOrder.lean`. These prove nested/separated cells, half-open tests, position and edge order, and interval-length uniqueness; `Geometry.jobInterior_mem_jobTestInterval` supplies the rational interior test point. |
| Physical inventory, `eq:inventory-total` | `InventoryData`, `RowAt`, `AnchorAt`, `RoleCopies`, stocks and `B` in `Inventory/InventoryScores.lean`; `card_roleCopies`, `card_item`, `B_closed`; `packingInstance`, `itemEquiv`, `packingInstance_n` in `Inventory/InventoryPrefixConservation.lean`. |
| `instance.tex`, `lem:encoding` | `primaryCoeff`, `primaryScore`, the signed radix lemma, `sum_primaryScore_eq_zero_iff_coefficients`, `pattern_primaryCoeff_sum`, label-weight order lemmas, `encodedSize`, `encodedSize_mem_interval` in `Packing/PackingScalar.lean`; actual inventory primary/secondary conservation in `Inventory/InventoryScores.lean`. |
| `instance.tex`, `lem:good-anchors` | `primary_loss_bound` in `Packing/PrimaryLoss.lean`; `Packing.outsideTableItems_card_lt`, role-prefix conservation in `Inventory/LabelConservation.lean` and `Packing/GoodAnchorBound.lean`; physical `outsideTableItems_card_lt_lossAllowance`, `anchor_subset_loss_le` in `Inventory/InventoryPrefixConservation.lean`. The loss is joint over all anchors of a label. |
| `instance.tex`, `lem:good-feasibility` | Physical tuple selection in `Packing/PackingSelections.lean`, coordinates in `Packing/PackingCoordinates.lean`, and `PackingCounts.main_completion_le_selected_deadline`, `edge_selected_baseline_le`, `edge_tuple_feasible` in `Packing/PackingFeasibility.lean`, with `Trees/KeyGeometry.lean` and coordinate-order lemmas. Earlier rows and earlier edge resources are permitted and explicitly accounted for. |
| `soundness.tex`, prefix decomposition and `lem:coverage` | `IntervalCoverage.completion_prefix_identity`, `Coverage.completion_prefix_decomposition`, finite row-injection bounds in `Inventory/CurrentMatches.lean`; `InventoryCoverage.actual_deadline_deficit_bound` in `Inventory/InventoryCoverage.lean`; deadline shifts in `Inventory/LocalCompletionCoverage.lean`; physical `InventoryData.test_coverage` in `Configurations/CoverageSoundness.lean`. |
| `soundness.tex`, `lem:side-choice` | `SideChoice.exists_unhit_leaf`, `SideChoice.side_choice`, `PackingCounts.side_choice_of_competingTrees`, `side_choice_of_test_coverage`, and `reduction_side_choice` in `Packing/ExtractedCover.lean`. Global-zero/local-positive tuples give shared-quota tree marks. |
| `soundness.tex`, `lem:job-matches`, including the displaced-row correction | `CoverageCounts.displaced_baseline_bound`, `displaced_short_correction`, `short_le_displaced_add_long`, `long_match_lower_bound`; physical `InventoryCoverage.actual_displaced_baseline_prefix_le`, `actual_displaced_job_prefix_le`, `actual_current_long_matches_from_correction`; exclusions in `Inventory/PackingExclusions.lean`, coverage classification in `Machines/PackingJobCoverage.lean`; `InventoryData.long_matches_at_nonexcluded` in `Configurations/CoverageSoundness.lean`. |
| `soundness.tex`, earlier-edge conservation and `lem:edge-cover` | `InventoryData.earlierKeyItems_card`, `earlierWItems_card`, `remainingEarlierW_card_eq_missingKeys`, `missingEarlierKeys_subset_bad`, `remainingEarlierW_card_le`, and `edge_long_matches_capacity` in `Inventory/EdgeLongConsumption.lean`; `thresholdCover_isCover` in `Packing/K4Graph.lean`; `extractedCover_isCover` in `Configurations/K4Soundness.lean`. |
| `soundness.tex`, `lem:cover-size` and `prop:soundness` | `PackingCounts.xplus_budget`, `total_budget`; `thresholdCover_card_le_fractions`, `cover_fraction_bound`, `thresholdCover_card_le_graph`; `extractedCover_card_le`, and `packing_extracts_cover`. |
| `completeness.tex`, local construction needed for the fractional witness | Hall marriage proved in `Packing/FiniteHall.lean`; deadline matching and `LocalResourceAllocation` in `Inventory/LocalCompletionCoverage.lean`; `constructedLocalState` in `Packing/ConstructLocalState.lean`; feasible physical template bases, disjoint roles, and appearances in `Packing/LocalTemplateBases.lean`. |
| `completeness.tex`, `prop:fractional` | Doubled species counts in `Inventory/IntegralSpeciesCounts.lean`; `PoolTemplates.column`, `templateMass`, `weights`, `weights_feasible`, `objective_weights` in `Inventory/PhysicalPoolLift.lean`; `statePoolTemplates_feasible`, `ofCompetingTrees_physical_witness`, `ofCompetingTrees_bothLP_eq`, `reduction_bothLP_eq` in `Configurations/ReductionFractional.lean`; full-LP projection and lower bounds in `Configurations/ConfigurationLP.lean`. |
| `consequences.tex`, structural specialization; `introduction.tex`, `thm:unbounded-gap` | `completeFourGraph_cover_card`, `completeFourGraph_no_small_cover`; `completeFourGraph_reduction_no_packing`, `completeFourGraph_reduction_opt_gap`; `completeFourGraph_reduction_bothLP_eq`, `structural_additive_gap` in `Results/StructuralGap.lean`. |

## Why extraction applies to every packing

Start with any `Packing (reductionInstance c rho G k) b` and
`b≤B+c`. All subsequent table/good-tuple objects are derived from that
packing. The scalar and inventory conservation lemmas bound items outside
five-item table tuples by `K`; label-prefix conservation gives at most
`3*K` bad anchors at any one label, and `3*n*K` globally.
Injectivity of physical role-item selection prevents reuse between tuples.

The half-open completion identity is `C=A+I`: completion prefixes equal
baseline prefixes plus coverage. Deadline displacement contributes exactly
`d` at a test point. The physical `jobRowPrefix_card`, `keyPrefix_card`,
`originalBaselinePrefix_card`, `currentKeyItems_card`, and
`currentShortItems_card` identify the abstract counts with the constructed
inventory, including two job rows and one key per copy.

At the interior of a current job cell, let `xi` count good current keys
using strictly earlier rows. Those displaced rows are disjoint from rows
already consumed by good earlier keys and from rows in main tuples. Thus
the strengthened bound is `A+xi≤B_v+3*K`, not merely `A≤B_v+3*K`.
At a nonexcluded cell the covering tuples contribute at most
`xplus+shortM`. The actual-prefix and current-row lemmas instantiate the
following additive inequalities over natural numbers:

```text
d+xi ≤ xplus+shortM+6*K
shortM ≤ xi+longG+3*K
d ≤ longG+xplus+9*K.
```

The same earlier-prefix loss is used once, not once per position. Short
rows already used in main tuples are unavailable to edge tuples. Neither
the displacement `xi` nor earlier-row matching is assumed to vanish.

For an edge of zero-based index `h`, `earlierKeyItems_card` and
`earlierWItems_card` both give exactly `2*d*R*h`. Good earlier-key tuples
use distinct earlier global resources. The number of remaining earlier
resources equals the number of missing earlier keys, and those missing
keys form a subset of the globally bad anchors. Hence the remaining stock
is at most `3*n*K`, independently of the number of earlier edges.
Exact-position long matches on the current edge use either its `d*R`
permits or that remaining earlier stock. This proves the total capacity
bound `d*R+3*n*K` over both endpoints and all repetitions.

At least `R-P` repetitions per endpoint are nonexcluded. If both endpoints
had `xplus≤d/8`, each such repetition would require at least `3*d/4`
long matches. The chosen `R` makes this total strictly larger than the
capacity bound. Therefore `thresholdCover d xplus`, defined by the
strict inequality `xplus>d/8`, covers every edge.

The competing-tree obstruction and coverage force one large side at every
vertex. Together with the actual length-one resource budgets this gives
the cover bound
`|C|≤d*k/(d-6*K)+48*K*n/d≤k+60*K*n/d≤k+rho*n`.
`packing_extracts_cover` universally quantifies over the original
arbitrary packing and the bin count; it assumes no canonical form.
For the four-clique this would yield a cover of real-valued cardinality
at most `5/2`, whereas every cover has at least three vertices.
`not_hasPacking_iff_lt_opt` then gives `B+c<opt I`.

## Why the fractional witness proves the full LP values

For every vertex both selected and unselected local states are constructed,
without requiring a globally consistent vertex cover. A template fixes
three distinct physical items in the row, anchor, and local roles.
For each physical global-pool copy `u` and flag-pool copy `f`, its column is
the union of that base with `{u,f}` and has mass
`1/(2*|globalPool|*|flagPool|)`. Required pools are proved nonempty,
different roles are disjoint, and capacity is proved for every physical
choice.

`FractionalCover.pushforward` sums masses when different samples generate
the same individual configuration. Every labeled item appears in exactly
two templates, one per local state. With `n=2*k`, the combined unweighted
requests for each global or flag species are twice its physical stock.
`PoolTemplates.weights_feasible` consequently proves coverage at least
one for every physical copy, with each template contributing total mass
one half. There are `2*B` templates, so the objective is `B`.

`projectWeights_feasible` aggregates these individual columns by their
**numerical** size multiplicities, preserving objective and covering the
actual multiplicity of each size. It remains valid when different species
have the same size.

For the opposite inequality, every capacity-feasible individual subset
has at most five items because all sizes exceed `1/6`.
`TypeConfiguration.card_le_five` proves the same fact for every
capacity-feasible numerical multiset, counting repetitions and without a
demand cap. Summing the covering inequalities gives
`I.n≤5*objective` for **every** feasible solution of either full LP.
Attainment transfers this to the LP values. With `I.n=5*B`, the lower
bound is `B`; the physical witness and its projection give the upper
bound. This is `bothLP_eq_of_physical_witness`, and ultimately
`completeFourGraph_reduction_bothLP_eq`.

## Semantic scope and compatibility differences

There is no deviation from the displayed C118_STRUCTURAL_GAP conclusion:
the instance is rational, packing is unrestricted, both LPs have their
full column spaces, and `c` is arbitrary. Vertex/edge/repetition indices
are zero-based finite types rather than one-based paper indices.

One intermediate formalization has a narrower ambient coordinate domain:
coverage and prefix theorems use `a : ℚ`, whereas the manuscript sometimes
states them for real points. All coordinates and all leaf/job interior
points used in extraction are rational, so the localized proof supplies
every needed instance. This document does not claim that it separately
formalizes the stronger all-real-points intermediate statement. The final
packing/LP theorem is unchanged.

The existential construction uses classical finite enumeration and matching.
It does not certify the paper's polynomial-time/binary-output bounds, the
general integral vertex-cover completeness theorem, or the PCP-based
additive-hardness theorem. Only their local matching/state ingredients
needed for the structural fractional witness occur in this closure.
Incidental complexity data types in `Model.lean` are not an appeal to
hardness or to any literature theorem.

Necessary Lean 4.31.0 accommodations are recorded exactly in provenance:
four proved conditional-name aliases using `if_pos/if_neg/dif_pos/dif_neg`
(with the actual `Decidable` instance inferred from the expression);
`Set.ofPred_forall` proved from `Set.setOf_forall`; a proved sigma-fiber
cardinality simp lemma; a larger elaboration heartbeat budget; and
declaration-local transparency settings on three label-count and six
physical-prefix proofs. Four source files have proof-only edits:
the empty Hall branch, two closed scalar arithmetic proofs, the explicit
sigma cardinal calculation, and the local option prefixes. All original
domain definitions and theorem statements are retained. The final
structural theorem's proof body is unchanged.

## Mechanical evidence and replay

`Main.lean` ends with `#check` of the full structural statement and 48
`#print axioms` commands covering that theorem, tree construction, scalar
encoding, good-anchor loss, displacement, earlier-edge conservation,
physical prefix counts, unrestricted packing extraction, the physical
fractional witness, and the full LP argument.
The successful preliminary compiler output is `compile_compat4.log`;
its durable-runner receipt and reclaimed exit result are retained.
The full theorem's printed axiom set is exactly
`[propext, Classical.choice, Quot.sound]`.
The four arithmetic displacement/correction lemmas use only
`[propext, Quot.sound]`. All printed dependencies are subsets of the
standard three-axiom set; no unproved domain axiom is supplied.

The official verifier is run with this directory's `Main.lean` as its
positional source, and with this separate fidelity document:

```text
ARGUS_SKILL_MATHLIB_WORKSPACE=$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify --project-root . --claim C118_STRUCTURAL_GAP research/structural_gap_certification/Main.lean --statement-fidelity research/structural_gap_certification/STATEMENT_FIDELITY.md
```

The environment assignment is exported for the verifier. Long compilation
commands are submitted through the required durable direct runner.
The official artifacts `lean_check.json` and `compile.log` bind the compiler
and environment-axiom-audit results to source/fidelity hashes and the actual
Lean version. The verifier also materializes its canonical lowercase
`statement_fidelity.md` copy here. Neither source nor fidelity is edited
during official verification. The subsequent official campaign
`math_state check` and `proof_graph_check check` results are recorded as
operational consistency checks, not as independent mathematical review.
