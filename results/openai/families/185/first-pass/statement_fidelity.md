# Statement fidelity: Proposition `prop:local-intervals`

The principal declaration is
`Manuscript185.proposition_local_intervals` in `Main.lean`. It asserts the
literal proposition in staged `04-local-bases.tex`, not the complete
matroid construction or an abstract interpolation specification.

## Objects and definitions

`Manuscript185.Ground` is the countable set
`((m : Nat) times ((Fin m -> Bool) -> Bool)) times Bool`. The Boolean
factor labels the two copies called L and R in the manuscript.
`ground_bridge` identifies it definitionally with the actual
implementation's `E0`. No enumeration of arbitrary subsets is assumed.

`W m` is the set of points whose first tag is `m`. `V n` is the set whose
first tag is less than `n`, and `prefix_union` proves that this is exactly
the union of `W m` over `m < n`. `block_set_bridge` and
`prefix_set_bridge` identify these literal sets with the implementation's
finite blocks and prefixes. `blockCount`, `prefixCount`, `blockSize`, and
`prefixSize` use the finite-set cardinalities of these actual sets and
their intersections. Their four count/size bridges justify the use of
`Set.ncard`; the sets in question really are finite.
`literal_block_size` proves `|W m| = 2 * 2^(2^m)`.

`blockDensity X m = |X intersect W m| / |W m|`.
`densityZero X` means this real sequence tends to zero, exactly the
manuscript's doubled-block definition of `J_0`. `density_bridge` and
`density_zero_bridge` identify these with `density` and `Small`.

The manuscript first defines `J_0` by requiring both slices to have
density zero on `D_m`. `sliceBlock X b m` is exactly the set of `d` with
tag `m` and `(d,b)` in `X`; `sliceDensity` divides its cardinality by
`2^(2^m) = |D_m|`. `slice_count_bridge` and `block_count_slices` prove
the cardinality split, and `density_average` proves that doubled-block
density is the average of these two slice densities. `slice_ideal_bridge`
proves that both nonnegative slice densities tend to zero if and only
if doubled-block density does. Thus `sliceIdeal` is the primary
two-slice definition of `J_0`, with the manuscript's equivalence proved,
not assumed. `prototypeClass T X` means
`sliceIdeal (X symmetricDifference T)`, and `class_bridge` identifies
it with `SameClass T X`.

`prefixDifference` is the difference of real-cast prefix cardinalities,
not truncated natural subtraction. `blockDifference` is the signed
difference of block counts divided by block size.
`probe T n X` is precisely that prefix difference plus `|V n|` times
the sum of the supremum and infimum of signed block differences over
`m >= n`. The two difference bridges and `probe_bridge` prove equality
with `pProbe`, `dProbe`, and `fProbe`. The extrema range over infinite
closed index tails; they are not replaced by finite tails or limits.

`lowerLimit` and `upperLimit` are extended-real liminf and limsup of
`probe T (n+1) X`. This indexes exactly the manuscript's `n >= 1`.
`lower_limit_bridge` and `upper_limit_bridge` prove that adding or
removing the initial `n = 0` term does not change either limit, using
`map (fun n => n+1) atTop = atTop`. Infinite values remain permitted.

`basesMinus T` consists exactly of class members with
`-1 < lowerLimit T X <= 0`. `basesPlus T` consists exactly of class
members with `0 <= upperLimit T X < 1`.
`lower_rule_bridge` and `upper_rule_bridge` identify these literal
definitions with `LocalLower` and `LocalUpper`. In particular the
upper-rule bridge is a theorem, not an assumption that the upper rule
means a complemented lower rule. `probe_complement` and
`complement_limits` establish the required sign and liminf/limsup
conversion. `bases s T` selects minus for `s = false`, plus for
`s = true`, covering both values of the manuscript's sigma.

## Quantifiers, hypotheses, conclusion

`proposition_local_intervals` quantifies over every Boolean `s` and every
three subsets `T, I, Y` of this infinite ground set. Its only hypotheses
are that `T` and `T`'s complement are not in the two-slice ideal, that
`I subset Y`, and that at least one of `T \ I` and `Y \ T` belongs to
that ideal. It does not
assume either endpoint is in the prototype class, an infinite or finite
gap, finite limiting values, a maximal-extension axiom, Martin's Axiom,
or a continuum-regularity hypothesis.

The conclusion is an actual existential subset `B` in the selected
literal basis family satisfying `B subset I`, or both
`I subset B` and `B subset Y`, or `Y subset B`. All inclusions are
nonstrict, including the endpoints and zero-gap case.

`alternative_of_left_small` proves the missing one-sided reduction:
if `I` is in the class, split according to whether the gap is small and
use the matching endpoint theorem; otherwise `T intersect I` is in the
class and the positive gap to `I` gives a basis contained in `I`.
`native_interval_alternative` handles `Y \ T` small by reversing the
complement interval and the Boolean rule. The main theorem transports
this argument through the definition bridges.

## Analytic branches and boundaries

`finite_lower_branch` covers a lower endpoint whose extended lower limit
is at most `-1` but not minus infinity; the upper endpoint's lower limit
is positive. It uses exact finite-cardinality shifts and the proved
floor-rounding interpolation theorem. `finite_upper_branch` covers
minus-infinite lower limit and positive, non-plus-infinite upper limit,
using the ceiling-rounding theorem. Each conclusion is a class member
with lower limit in the strict/closed interval `(-1,0]`.

`opposite_infinite_branch` imposes exactly minus-infinite and
plus-infinite lower limits on the two same-class endpoints. Its
conclusion has the same exact half-open rule, using the concrete
`fProbe_interpolation`; this transitively invokes the cylinder-continuity,
finite-stopping deletion and decreasing-intersection argument, and the
one-point correction when the intermediate lower limit is exactly `-1`.
No finite numerical test certifies this branch.

`lower_neg_one_boundary` excludes lower limit `-1`.
`lower_zero_boundary` includes lower limit `0` exactly when the set is
in the class. `upper_zero_boundary` does the same for upper limit `0`,
and `upper_one_boundary` excludes upper limit `1`. Thus complementing
does not silently close either forbidden boundary.

## Trust and limits

The imported sources are the eight actual analytic modules from
`openai/math` commit `4eaee87548250b2682affda7d05d947c05554bae`, locally
preserved under `research/verification/OAI/Combinatorics/InfiniteMatroid`.
The original `BasisExtension.lean` uses `Set.mem_ofPred_eq`, a name absent
from the installed Mathlib v4.31.0. Its generated compiler copy replaces
that one identifier by `Set.mem_setOf_eq`, the same definitional
set-comprehension membership equivalence. No statement, hypothesis,
proof step, or mathematical axiom is added. Both the original pinned
source and the exact generated copy remain available, and the rewrite
is explicit in `verify.py` and the certificate.

`verify.py` checks their pinned source blobs, freshly compiles the seven
unchanged modules and this single-identifier compatibility copy in
dependency order with Lean 4.31.0, runs the official Lean evidence
verifier on this source and this reading, and checks the transitive
`#print axioms` output of the main result and all named critical branch
targets. Only `propext`, `Classical.choice`, and `Quot.sound` are accepted.
The comparator is not imported.

The finite rational, finite-support probe, and Jacobian XOR computations
are supplementary experiments only. The kernel proof establishes the
universal infinite assertion. The compiler does not verify this prose's
fidelity to the manuscript; that is the required independent Reviewer's
task. This certificate neither verifies global prototype assembly and
ordinal descent nor claims a new matroid counterexample or a novel
mathematical theorem.
