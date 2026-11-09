# Realized dyadic boundary theorem

The declarations described here are `BoundaryAudit.actual_bridge`,
`BoundaryAudit.boundary_from_level`,
`BoundaryAudit.realized_signed_boundary`, and
`BoundaryAudit.realized_boundary` in `Main.lean`. Their import is the
implemented `OAI.GroupTheory.Thompson.FiniteBoundary`, not the upstream
comparator containing `sorry`.

## Objects and quantifiers

`F` is the subtype of actual increasing homeomorphisms of the closed real unit
interval having finitely many dyadic breakpoints and slopes that are integral
powers of two. `DyadicPLWitness` includes ordered knots, coverage, both
endpoints, and the affine formula on every closed piece. `StandardF` proves the
group instance; `F.mul_apply` is definitionally composition in the order
`(h * g)(x) = h(g(x))`. There is no abstract replacement group or assumed
transport action.

`E` is any real inner-product normed additive group. Completeness is not
required, so a real Hilbert space is included. `UnitBall E` is the closed ball
`{x | ||x|| <= 1}`, not the sphere or an open ball. The map `f` is defined on
this entire ball and takes values in the same ball.

The formal interval family is a particular legal choice in the manuscript:
for each integer `D >= 2`, choose depth `r = 2*D` and the cells with zero-based
indices `2*i+1`, for `i : Fin D`. Thus the manuscript's one-based interval
`I_j` is `[(2*j-1)/2^r, 2*j/2^r]`. Since `2^(2*D) > 2*D`, all parents
are internal and have positive gaps. The children are their actual affine
copies. `IntervalIndex D = Fin D + (Fin D * Fin D)` indexes parent and child
occurrences. This is not a Lean theorem quantifying over every possible choice
of parents; it certifies a permitted realized family for every `D`, as needed
for the fixed-family proposition.

`fixedTransportSet hD` is the finite image of all strictly ordered separated
pairs in this family under actual affine pair transports to the first two
parents. Its definition depends on `D` only, not on `A`, `f`, `L`, `delta`,
or a partition level. Classical choice selects genuine elements of `F` from
proved existence theorems; it does not supply an assumed covariance law.
`transportClosure S A` is exactly `A union (union_{h in S} hA)`.
`boundaryRatio A h` is `|hA symmetric_difference A|/|A|`.
Finite sets are extensional sets of actual maps, not word lists with
multiplicity.

`actual_bridge` quantifies over every nonempty finite `A`. It produces a
threshold `N`, before the arbitrary coloring map `f`, such that **every**
`n >= N` makes the whole transport closure admissible. At every such level,
all actual parent colors equal `f` of their actual child mean and all
strictly separated correlations differ from the reference average by at most
the maximum relative boundary over the same fixed transport set. Nested
pairs are not claimed to have comparable correlations. No sign hypothesis
on the reference correlation appears.

`boundary_from_level` derives the signed boundary bound from actual
admissibility at the source and all the translated points. Its inputs also
include `L > 0`, `delta > 0`, the global inequality
`||f(x)-f(y)|| <= L*||x-y||`, and the global inequality
`delta <= ||f(x)-x||` for **every** `x,y` in the ball.
Neither invariance of `f` nor preservation of all selected intervals by each
transport is a hypothesis.

`realized_signed_boundary` discharges those admissibility inputs using
`actual_bridge`. For every integer `D >= 2` and all positive `L,delta`
satisfying the map hypotheses, every nonempty finite `A` has an `h` in the
already fixed set with boundary ratio at least

    b = (delta^2/L^2 - 4/D) / (4*(1-1/D)).

It does not assume `D > 4*L^2/delta^2`; the signed bound remains valid when
`b <= 0`. `realized_boundary` adds exactly this strict parameter inequality,
proves `b > 0` and nonemptiness of the fixed set, and retains the universal
boundary conclusion. Existence of an element with ratio at least `b` is
equivalent to the manuscript's maximum formulation because the set is
finite and nonempty.

## Why the construction-specific inputs are discharged

These are mathematical proofs in the copied dependency closure, not premises
declared by the audit wrapper:

1. `eventually_image_respects` constructs actual basic image cells from the
   finitely many affine pieces, aligns all dyadic intercepts, and obtains
   sufficiently small mesh. Basic intervals with overlapping interiors are
   nested, so that mesh forces respect of every specified basic interval.
   Taking a finite maximum supplies the cofinal threshold for the entire
   finite transport closure, after `S` was fixed.
2. `exists_affine_pair_transport` partitions each of the three complementary
   positive dyadic gaps separately, equalizes cell counts by bisections, and
   applies proved increasing PL interpolation. Equalizing the three gaps
   separately puts both distinguished intervals in matching positions.
3. `BasicPartition.restrict` is inverse affine normalization of actual cells,
   with coverage and disjoint interiors proved, including closed endpoints.
   `restrict_cellCount_lt` uses internality to find a cell outside the
   restricted interval. This is the termination proof of `partitionColor`.
   `restrict_restrict` identifies successive restrictions with insertion of
   the composite interval, yielding `globalColor_parent`.
4. `image_restrict_covariance` matches the original uniform-cell indices under
   `h * g`. The identity of affine charts on the transported interval gives
   equality of the normalized restrictions. It needs admissibility at the
   two relevant group elements, not preservation of other intervals.
5. Inadmissible group elements receive zero colors exactly as in the
   manuscript, so correlations are globally bounded. Finite cancellation
   over `hA intersect A` then bounds each translated correlation by the
   actual symmetric-difference ratio. Symmetry of the real inner product
   handles the reversed orientation.

The Hilbert estimate counts `D*(D-1)` separated terms and `D` diagonal or
nested exceptions in each relevant double sum. For each parent index it gives

    E_A ||z_i-m||^2 <= 4/D + 4*(1-1/D)*eta.

The reference correlation cancels without a sign assumption. The exact
recursive identity, convexity of squared norm, and the two global map
inequalities give

    delta^2 <= L^2 * (4/D + 4*(1-1/D)*eta).

Division by `L^2 > 0` and `4*(1-1/D) > 0` gives precisely `b <= eta`.
`boundaryConstant_le_of_correlations` and `BoundaryAlgebra` prove these
steps for arbitrary real parameters, not a sampled parameter grid.

## Scope, provenance, and remaining review

The strongest prior result used here is the completed upstream
`exists_fixed_boundary`, whose source project specifies Lean 4.34.1.
The comparator alone was not a certificate. This audit reuses its 35-module
concrete dependency closure under the installed Lean 4.31.0/Mathlib
workspace. The nine compatibility diffs change only renamed Real imports
and conditional-simplifier theorem names. The replay report retains the
exact diffs and real compiler logs. `Main.lean` additionally exports a
cofinal common-level bridge uniform in the coloring map and the signed bound
without the positivity threshold. No new mathematical axiom is introduced.

`verify.py` obtains a fresh official `lean_evidence verify --claim` run,
checks the three printed theorem axiom lists, and writes the exact
certificate only after both campaign-local structural checks pass.
The compiled source and this reading are bound by the official compiler
certificate. The source closure is separately bound to its successful replay.
The only allowed theorem axioms are Lean's standard `propext`,
`Classical.choice`, and `Quot.sound`.

The rational finite regressions and Jacobian second moment are orientation
and recursion checks only. Their scalar map `f(x)=(x+1)/2` has a fixed point;
they are **not** witnesses for positive displacement and are not the proof
of a universal boundary bound.

No manuscript assertion is refuted here. This mission does not prove the
existence of a uniformly displaced Lipschitz map, certify the analytic
appendix or the Folner implication, or claim a new proof of nonamenability
independently of those inputs. The direct dyadic arguments above also explain
why arbitrary separated internal parent choices in the manuscript introduce
no additional invariance hypothesis, but the encoded family is the explicit
one specified above. Statement fidelity, mathematical significance, and
novelty still require the Host's independent Reviewer; compilation alone
settles none of those human judgements.
