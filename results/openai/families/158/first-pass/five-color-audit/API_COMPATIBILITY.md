# Source-level compatibility with Lean 4.31.0

The pinned publication declares Lean 4.34.1. Its first actual dependency
fails on the assigned 4.31.0 workspace at `Amenability.lean:385` because
`Filter.eventuallyEmptyOrUniv_iff` does not exist in that older Mathlib.
This is a library-version failure, not a mathematical refutation.

The publication's Mathlib revision
`d13f23b723b8a846827a245b89c10fc7d3f11612`,
`Mathlib/Order/Filter/EventuallyConst.lean:77-95`, defines

```
EventuallyEmptyOrUniv s l := EventuallyConst (fun x => x in s) l
```

and retains the old `eventuallyConst_set` theorem as a deprecated alias.
The assigned 4.31.0 source, the same file at lines 70-76, states

```
EventuallyConst s l <->
  (eventually x in l, x in s) or (eventually x in l, x not in s).
```

These are the same proposition, including null and trivial filters.
Five separate files under `ports/` replace only the new specialization
name and its equivalence theorem by the old names:

| Module | Replacements |
| --- | --- |
| CompactFactors.Amenability | `eventuallyEmptyOrUniv_iff` -> `eventuallyConst_set` |
| CompactFactors.RelativeCenters | same equivalence theorem |
| CompactFactors.Kernels | equivalence theorem and `EventuallyEmptyOrUniv` -> `EventuallyConst` |
| PlaneSpectrum.Energy | equivalence theorem and specialization name |
| PlaneSpectrum.Ergodicity | equivalence theorem |

The next dependency, `PlaneSpectrum.Basic`, also uses newer
`isAlgebraic_natCast` and `isAlgebraic_ratCast` convenience theorems. In
`Basic`, `NumberFields`, and `BorelTransfer`, their proofs are supplied by
the existing 4.31.0 `isAlgebraic_algebraMap`: every scalar is a root of
`X - C(scalar)`. The complex-coordinate algebraicity calculation is
rewritten directly using `Complex.re_eq_add_conj` and
`Complex.im_eq_sub_conj`, avoiding a version-sensitive `convert` tactic
that left the actual coordinate equality undischarged on 4.31.0. The
coordinate theorem and every coloring statement retain their exact
original hypotheses and conclusions.

The `Characters` dependency next exposed the renamed set-comprehension
helpers `Set.mem_ofPred_eq` and `Set.ofPred_true`. Six copies
(`Characters`, `Centers`, `Functions`, `FiveSupport`, `PaletteTransport`,
and `Accumulation`) use the old `Set.mem_setOf_eq` and `Set.setOf_true`.
The assigned library states the membership equality by reflexivity
(`Data/Set/Operations.lean:79`) and the true-predicate equality at
`Data/Set/Basic.lean:529`. No set, measure, or assertion is changed.

The branch-collecting build exposed further renamed APIs. The 52 current
copies consistently restore the following equivalent older interfaces:

| Published interface | Assigned 4.31.0 interface |
| --- | --- |
| `Set.domRestrict`, `Set.domRestrict_apply` | `Set.restrict`, `Set.restrict_apply` |
| `continuousOn_iff_continuous_domRestrict` | `continuousOn_iff_continuous_restrict` |
| `ite_eq_left`, `ite_eq_right` | `if_pos`, `if_neg` |
| `dite_eq_left`, `dite_eq_right` | `dif_pos`, `dif_neg` |
| `Finset.prod_le_prod₀` | `Finset.prod_le_prod` |
| `Measurable.of_eval` | `measurable_pi_iff.mpr` |
| `Isometry.antilipschitzWith` | `Isometry.antilipschitz` |
| `Isometry.lipschitzWith` | `Isometry.lipschitz` |
| `MemLp.fun_mul` | `MemLp.mul` |
| `Set.preimage_ofPred_eq` | `Set.preimage_setOf_eq` |
| `Set.ofPred_mem_eq` | `Set.setOf_mem_eq` |
| `Set.ofPred_forall` | `Set.setOf_forall` |
| `NullSingletonClass`, `IsAddHaarMeasure.nullSingletonClass` | `NoAtoms`, `IsAddHaarMeasure.noAtoms` |
| `LocallyPathConnectedSpace`, `Convex.locallyPathConnectedSpace` | `LocPathConnectedSpace`, `Convex.locPathConnectedSpace` |

The older `MemLp.mul` puts its second factor on the left, so `Fourier`
reverses the two proof arguments, not the mathematical product.
`Multipliers` uses the older `eLpNorm_congr_norm_ae`, which requires only
the norm equality. `Compactness` unfolds `WeakDual.toStrongDual` and uses
the inverse equivalence law in place of a newer convenience theorem;
its older `eLpNorm_one_eq_lintegral_enorm` needs no measurability argument.

`SmallArcs` supplies only the sampled variable's a.e.-measurability to
`compProd_map_condDistrib`, as required by the older theorem. `Centers`
supplies the already-proved measurability witnesses to the older
`ProbabilityMeasure.map`, whose function argument is implicit, and supplies
`Measure.isProbabilityMeasure_map` explicitly for a conditional pushforward.
These are the same pushforward measures, not added hypotheses.
`ConditionalSelection` supplies the conditioning function to
`condDistrib_comp` and `condDistrib_self` in the older order, and proves
the pushforward probability instance directly from the existing
measurability hypothesis. Older `Measure.map_smul` needs no measurability
argument. Three `Centers` declarations drop `omit` directives that 4.31
rejects because their types reference centers built using measurable
group operations: those definitions' ambient measurable-group instances
are retained. This does not add a premise to the plane-coloring theorem.
`RelativeCenters` uses the same conditional-distribution and probability-map
adaptations, retaining those instances on the derived center-map lemma.
`FourierTests` explicitly proves that the difference-law pushforward is a
probability measure using the measurable division map. `PaletteDensity`
replaces a version-sensitive `convert` by the definitionally identical
product map and product volume before applying the existing theorem.
`ConditionalSpectrum` reuses the already-proved algebraicity of `imagUnit`
instead of the newer `Complex.isIntegral_I` convenience theorem.
`RelativeCenters` also supplies an older implicit measurable-space argument
where it cannot be inferred from a function argument alone.
`Approximation` explicitly derives the three required pushforward
probability instances from the existing measurability assumptions.
`ConditionalLimits` supplies the analogous seven already-implied instances.
Four `Interfaces` branches use explicit, kernel-decided `Fin 3`
disequalities to eliminate the impossible equalities `1 = 2` and `2 = 1`.
The older `norm_num` and `omega` attempts left these undischarged; the sign
inequalities themselves are unchanged. `Separability` and compact descent
in `Functions` supply the same already-implied probability-map instances.
`Functions` proves preservation of distance under complex conjugation
from `dist_eq_norm`, `star_sub` and `norm_star`, rather than the newer
`dist_star_star` name.
`Separability` installs the derived pushforward-probability instance in
the mean-norm statement as well as its proof; this is a `letI`, not a new
hypothesis. Three `Factors` product-measurability proofs make their
already-specified source sigma-algebras local instances, preventing the
older elaborator from selecting the ambient sigma-algebra instead.
Its joint-map pushforward is explicitly proved to be a probability.
The same previously checked set-comprehension renames are applied to
`CyclicCore` and `Representations` before their dependencies are retried.
`AlgebraModels` uses the older `Measure.fst_map_prodMk` contract, which
needs only measurability of the second coordinate. `GraphRealization`
replaces the unavailable forest clique-freeness convenience theorem by
the explicit argument: three positive support vertices form a triangle,
and the two-edge simple path contradicts uniqueness of paths in a forest.
The positive-support bound remains exactly two.
`ContinuumLimits` uses the older namespace `Metric.lipschitz_infDist` for
the same two-Lipschitz point/compact-set distance function. `DiskExtension`
uniformly uses the induced graph's set-subtype spelling for vertices
different from the removed leaf. This avoids an older tactic transparency
mismatch between that spelling and the definitionally equal direct
predicate subtype; no vertex, graph, topology, or hypothesis changes.
The resulting coordinate proofs explicitly expose subtype equalities
and pointwise scalar operations instead of relying on newer simplifier
behavior. `SpectralMeasure` uses the older two-obligation commutative
star-adjoin theorem, explicitly constructs the commutative closure, and
supplies commutativity to the older C-star structure. The auxiliary
commutative-ring construction is a definition, not a second global
instance, avoiding incompatible instance diamonds. Forgetful star
homomorphisms use `StarAlgHomClass.toStarAlgHom`; the older product rule
again reverses its proof arguments without changing the product.
`Energy.avg_orbit_const` raises only its typeclass-search budget from
20,000 to 100,000 heartbeats.
`RadialEnergy` explicitly derives the pushforward-probability instance at
three uses. The induced-vertex proof splits on the actual equality,
avoiding a non-definitional choice of equality decider; the edge proof
first proves linearity of zero extension and then uses the vertex lemma.
`BorelTransfer` supplies the old summability theorem's explicit
a.e.-strong-measurability premise using the existing `Lp` representatives.
The older library has no finite-set measurable-space API: the finite
label-set codomain receives its discrete sigma-algebra, and support-map
measurability is proved from finite membership fibers and countable
unions. This does not assume measurability of an arbitrary map into a
finite codomain.
`Five` obtains the same local path-connectedness of the convex closed disk
using those older names and installs that derived fact as a local instance.
Its unrestricted final theorem and proof are otherwise unchanged.

The pinned files under `published/` remain byte-for-byte unchanged. All
compiled objects now go to the single `compiled/` tree: Lean selects a
package root before resolving its modules, so placing objects beside two
different source roots incorrectly hid some successful objects. The build
records both the selected source and output object, with their digests.
Cache fingerprints include recursive dependency fingerprints, the actual
compiler version, and compiler options, so an upstream change invalidates
every affected downstream object. A 2,000,000-heartbeat limit replaces the
default 200,000 that stopped the exact `Moser` proof; this changes only the
compiler's execution budget.

No mathematical assertion is weakened, no axiom is added, and no result
from a failed compiler run is promoted to mathematical evidence.
