# Statement fidelity: weighted recursive Add and epoch storage

## Claim and declarations

This document describes claim `C137_WEIGHTED` and the declarations in
`Main.lean`, namespace `Audit137`. The principal declarations are
`certified_acyclic_weighted_evaluator`, `certified_entry_registers`,
`weighted_evaluator_bit_bound`, `maximumHeight_attained_at_base`,
`at_most_one_guess_per_epoch`, `certified_epoch_evaluator`, and
`certified_two_fifths_mechanism`. This is a verification of the recursive
arithmetic evaluator and its epoch dependency specialization, not a Lean
formalization of the entire Turing-machine simulation theorem.

## Objects and hypotheses

`K` is any field. Characteristic two is not required by the evaluator
proof; it is the field characteristic used by the manuscript's Boolean
history identity. A vector is `Fin n -> K`, and the entire mutable
register pool is `Fin p -> Fin n -> K`. The quantified pool `R` is
arbitrary, including every augmentation coordinate. No nonzero
augmentation or initially clean register is assumed.

An identifier type `Id` has a fixed rule for each identifier. Its
dependency relation is `Dependency`, with edges directed from caller to
dependency. `WellFounded` is assumed for that relation in the universal
acyclic theorem. For a finite graph this is the usual acyclicity
condition. The generic theorem also permits well-founded, finitely
branching infinite identifier systems; the bit-space interpretation still
requires the manuscript's uniform short identifiers and navigation.

`OrdinaryData` supplies a finite list of dependencies, a local kernel,
and distinct input slots avoiding the chosen target. Its local kernel is
homogeneous of degree `d` separately in every vector argument.
`HistoryData` supplies a distinguished history child, `N` array roles,
`2^g` candidate labels, three distinct physical roles, and the bound
`g + 1 <= n`. The output kernel is homogeneous of degree `d` in history.
Each predicate kernel is homogeneous of degree `d` in history and
separately of degree `d` in its array argument. No distinctness condition
is imposed on dependency identifiers, and no independence condition is
imposed on their semantic values.

`value : Id -> Vec K n` is fixed and is not part of mutable state.
The hypothesis `hv` equates this value to the local ordinary or factored
history rule **only at these fixed child values**. It does not assert
the history identity at arbitrary Boolean inputs. Base rules contain a
local coordinate-generating vector. Neither `evaluate` nor any nonbase
schedule reads `value`; it occurs only in specifications and proofs.

For the manuscript, `n = d + 1`, `d >= 1`, `g <= d`, ordinary fan-in is
between one and `r`, and `p = max 3 (r + 1)`. `exact_pool_capacity`
constructs all required slot choices for exactly this `p`. The generic
arithmetic theorem allows other vector widths and permits ordinary
arity zero; `maximumHeight_attained_at_base` explicitly requires positive
ordinary arity when identifying the manuscript's base-ending path maximum.

## The homogeneous lookup interface is proved, not postulated

`LineHom L f` states that on every affine line `a + s*v`, the function has
a univariate polynomial of degree at most `L`, with coefficient at `L`
equal to `f v`. The definition is discharged for the actual Boolean
lookup formula, not assumed for an arbitrary Boolean oracle:

- `basis`, `augment`, and `lookup` encode the manuscript's homogeneous
  basis and augmented Boolean lookup exactly.
- `basis_lineHom`, `lookup_lineHom`, and `lookup_agrees` prove separate
  homogeneity and Boolean agreement.
- `oneLookup` and `twoLookup` are the one-input and two-input versions
  of the same formula. Their homogeneity and agreement are proved.
- `booleanOrdinary` and `booleanHistory` instantiate the rule data with
  these kernels, including the output augmentation coordinate.
- `semantic_only_history_identity` converts the supplied identity at
  fixed semantic Boolean arguments into the generic rule identity.
- `guessEncoding` is a bijection between `g` Boolean bits and
  `Fin (2^g)`, so the candidate labels do not restrict or enlarge the
  manuscript's candidate set.

A constant-one Boolean coordinate is still extended by these sum/product
formulas; no declaration substitutes a literal one off the Boolean locus.
No proof divides by an augmentation coordinate. `Stencil.extract` uses
Mathlib's proved `Lagrange.coeff_eq_sum`, with inverse product weights
and distinct nodes; there is no factorial or characteristic restriction.
`Stencil.ofCard` constructs the required distinct nodes whenever the
finite field has cardinality greater than the degree.

## Actual recursive schedule and contract

`Action` is an explicit single-pool state-and-space semantics. `read`
returns one scalar without changing the pool, and `write` updates one
coordinate of one register. `addLocal` performs these scalar
read/write operations coordinate by coordinate; it does not allocate an
output vector.

`ordinaryNest` nests the interpolation loops in dependency order, calls
the child to shift its input slot, executes the next level, and calls the
same child with the negative scalar. The innermost action is `addLocal`.
`ordinaryNest_correct` and `ordinaryIntegral_exact` prove this schedule
from arbitrary baselines before it is used in the recursive theorem.

`historySchedule` follows the source order: outer history sample,
forward call to history, coordinate loop, candidate loop, initial output
scalar, sequential array factors, target-coordinate addition, and reverse
history call. `factorRead` shifts the array, obtains the predicate scalar,
retains that scalar across the reverse array call, and only then adds its
weighted contribution. `productRead` multiplies each completed factor into
one scalar; no list of factor values is retained.

`sandwich_correct` and `readSandwich_correct` use a child's contract for
arbitrary pools, not for private or clean registers. They permit a child
to borrow the caller's partial target or an ancestor's input slots. The
final `evaluate_correct` is an induction on the implemented recursive
evaluator, and supplies those child contracts from smaller calls. Thus a
correctness contract for all recursive children is **not** an unproved
global assumption.

The evaluator uses a natural-number fuel only to make its total recursive
definition explicit. `evaluate_correct` holds for every fuel strictly
larger than the weighted potential. The displayed corollaries select
`W(u)+1`; computing `W` is not an instruction in the recursive Add
schedule. A polynomial upper bound on the number of vertices times the
maximum edge weight provides a sufficient fuel with a short counter in
the manuscript setting. Fuel zero is unreachable in a certified call and
does not compute a nonbase value from a semantic oracle.

The conclusion of `certified_entry_registers`, for every scalar, target,
and initial pool, is exactly
`R_out[t] = R_in[t] + scalar * value(u)` and
`R_out[j] = R_in[j]` for every `j != t`.

## Storage semantics and its bit interpretation

The formal resource is **not the heap or stack used by the Lean compiler
to execute pure functions or construct lists**. It is the manuscript's
in-place machine schedule, with finite lists denoting loop enumerations.
Those enumerations are implemented by short counters, not materialized
work tapes. Boolean lookup kernels are local nonrecursive computations
with the space promises explicitly made in the manuscript.

`Action.bind` takes the maximum of sequential peaks. `Action.frame b`
adds `b` live storage units for the entire scoped action. An invocation's
short saved data are one unit. `historySchedule` puts a `g`-unit frame
around the coordinate/candidate/factor loops. This frame contains neither
call to the distinguished history child. The history calls have one suspended
unit; array calls have `g+1`. The retained predicate scalar across the
reverse call is in that same frame. The only mutable vector state in every
call is the same pool.

Each scalar local read has `n` scratch units. An active history frame
uses at most another `g+1 <= n` units. `evaluate_bounded` proves that the
peak for the actual instrumented recursive schedule is at most
`2*n + W(u)`, not merely a bound attached to a desired return value.
`maximumHeight_is_maximum` proves that `W` is the maximum weighted
dependency-walk length. With the source's positive ordinary arity,
`maximumHeight_attained_at_base` proves that this is precisely a
base-ending maximum, as in the manuscript.

One storage unit represents a sufficiently large
`ell = polylog(T)` bit budget for all short scalars, parameters, indices,
and bookkeeping in one frame. A `g`-bit guess is conservatively charged
`g*ell` bits. The common local `n*ell` scratch budget includes the total
Boolean kernels and field operations. The global field description and
stack pointer can be included by increasing the fixed constant in this
unit budget. The pool uses at most `p*n*ell` bits.
`weighted_evaluator_bit_bound` proves the exact integer upper bound
`(p*n + 2*n + W(u))*ell` under this interpretation.
The uniform local-algorithm and encoding promises are not themselves a
verified implementation of a Turing machine in Lean; the ledger retains
`A137_UNIFORM_BITS` to expose this boundary.

## Epoch specialization and two-fifths mechanism

`EpochEdge` contains the preceding-history, history-to-array, extraction,
checkpoint-to-array, and checkpoint-to-history edges from `simulation.tex`.
It does not omit the alternative checkpoint dependency. The potential is

`P(A[e,i]) = e*(k+g+2)`,

`P(H[e,j]) = e*(k+g+2) + j + g + 1`.

`epoch_edge_decreases` proves its edge inequality.
`epoch_navigation_wellFounded` derives well-foundedness from these
dependencies. `at_most_one_guess_per_epoch` uses a separate zero/one
credit for each fixed epoch and proves that a single dependency walk
cannot cross two expensive edges in that epoch.
`epoch_weight_bound` proves the final history bound
`W <= E*(k+g+2)`.

`certified_epoch_evaluator` maps the actual recursive evaluator's
dependency relation into these epoch edges and combines its contract and
resource bound with that path bound. The candidate length is specialized
to `g=k*c` in `certified_two_fifths_mechanism`.

`epochCount T k` is the exact nested ceiling count
`ceil((1 + ceil(T/k^2))/k^2)`. For positive `k` and `T <= k^5`,
`epochCount_le` proves `E <= k+1`. With three registers and `c >= 1`,
the final corollary proves, for the same arbitrary-entry recursive
execution, a total upper bound of

`(5*(d+1) + 4*k^2*(c+1))*ell` bits in this model.

Taking the source's `k = ceil(T^(1/5))`,
`d = O(k^2 log(T+2))`, and `c = O(log(T+2))` explains the
two-fifths exponent. The real-power rounding estimate, concrete replay
semantics, public-symbol access implementation, field construction,
and full Turing-machine correctness are not asserted as Lean theorems
by this corollary.

## What remains a human reading

The compiler checks all declarations and their dependencies, including the
nontrivial schedule, recursion, restoration, and scoped resource
inequalities. It does not check this document's identification of the
abstract storage units and local kernel promises with the staged source.
That statement-fidelity judgement, novelty, significance, and independent
replay remain the Host Reviewer's responsibility. No independent review
or full-machine certification is implied by successful compilation.
