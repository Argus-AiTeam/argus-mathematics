# Statement fidelity for C_SPARSE_CORE

## What is encoded

`Main.lean` imports only Mathlib. It proves both the sharp radial minimax
statement and an actual coefficient-independent counted approximation-list
theorem for arbitrary finite partition inputs and arbitrary real coefficient
vectors. It does not merely verify a prescribed list of rational profiles,
assume the existence of greedy pivots, or assume the new sparse compression
theorem. The universal sparse compression declarations discharge the generic
profile's dilation hypothesis inside this same source.

The compiler checks these encoded mathematical statements. It does not check
this reading of them, originality, publishable significance, or the prose
finite-field/convex-body consequence.

## Exact minimax statement

The principal declaration is `SparseProfile.minimax_exact`. Its parameters
H,k are natural numbers, with k positive and
`3^(k-1) <= H` and `H < 3^k`. These hypotheses also imply H positive.
The admissible weights are functions `Fin H -> Real`; nonnegativity and
normalization are explicit hypotheses, with no rationality restriction.
Distances have type `ENat` (notation `Nat-infinity`), including infinity.

`SparseProfile.indicator d j` is the real number one when `d <= j` and
zero otherwise. `delta d j` is the inflated indicator at radius `3*j+2`
minus the indicator at radius j, in that order. `loss w d` is the
finite sum of `w j * delta d j.val`.

The conclusion constructs a nonnegative normalized H-coordinate vector w,
proves its loss at every extended-natural distance at most `1/(k:Real)`,
and proves equality at distance one. It also proves that every admissible
real vector z has some distance where its loss is at least `1/(k:Real)`.
This envelope-plus-witness formulation is the exact minimax equality; it
does not use a topological assertion about attainment or a numerical
optimizer. `minimax_lower` supplies a finite test distance of the form
`3^(l+1)-1` for the lower bound.

The attaining vector is explicit in the proof: `radius l = 3^l-1`,
`radiusEmbedding` embeds these k distinct radii into `Fin H`, and
`embeddedWeights` places weight `1/k` on that image and zero elsewhere.
Its normalization and nonnegativity are proved. In particular this is a
profile supported below H, not just an unconstrained k-coordinate vector.
`support_admissible` proves the support bound.

`sparse_dilation` checks all extended distances, not only the k dual test
distances. `value` is the new sparse ball profile.
`value_nonneg`, `value_le_one`, `value_at_zero`,
`value_zero_of_cutoff`, and `value_at_infinity` prove respectively its
range, normalization at zero, vanishing beyond the admissible cutoff H,
and vanishing at infinite distance.

## Partition inputs and their graphs

The main positive theorem is
`SparseProfileCompression.sparse_profile_partition_compression`;
the signed theorem is
`SparseProfileCompression.sparse_profile_partition_signed_compression`.

X is an arbitrary type with a finite enumeration and a nonempty instance.
The label type may depend on the partition index and may itself be
infinite. For each of the u partition maps L, the hypothesis
`Nat.card (Set.range (L i)) <= q` bounds only realized labels.
The natural numbers u,q,k,s are positive.

The family of retained sets is an arbitrary fixed finite set
`Tset : Finset (Finset (Fin u))`.
Every T in this family omits at most `theta*u` indices.
`Columns X Tset` is exactly `X x {T // T in Tset}`; it is not a
coefficient-dependent subfamily. The theorem even allows the family to be
empty, a harmless strengthening of the report's nonempty-family version.
The construction consequence uses a nonempty family (containing all indices).

`PartitionGraph.graph` joins distinct x,z precisely when there exists
i in T with `L i x = L i z`. `distance` is Mathlib's `SimpleGraph.edist`,
whose value between disconnected vertices is infinity. It is not the
ordinary natural graph distance with a zero default. The triangle and
label-representative lemmas are proved for this actual graph, including
the radius chain `j -> 2*j+1 -> 3*j+2`.

`FixedLabels.ofCardBound` is built from the realized-label bound, not
supplied as an extra existence hypothesis. It fixes a q-code and one
representative for every code before coefficients are supplied.
Representatives of codes not realized by a vertex are arbitrary fixed
vertices. `normalization_distance` proves that normalization preserves
the graph distance exactly.

## Count, error, and quantifier order

The real parameter theta is positive; `1 <= s*theta` and
`1/(k:Real) <= theta` are explicit hypotheses. The formal theorem does
not require theta less than one, and therefore implies the report's
version. No size, rank, separation, or connectivity hypothesis is imposed
on X.

The sparse radii are exactly `fun l : Fin k => 3^l.val-1` and every
profile weight is exactly the real number `1/k`.
`column` evaluates their weighted ball indicators at the graph distance.
These are different columns from the manuscript's logarithmic columns.
`sparse_profile_dilation` proves the required dilation inequality from
`1/k <= theta`, without a new assumption.

The theorem first quantifies **there exists a finite set A of real-valued
functions on X**, asserts that A is nonempty and bounds its cardinality,
and only then quantifies over **every real coefficient function mu on all
columns** with mu nonnegative and total mass at most one.
For each such mu it returns an element a of this same A satisfying,
simultaneously for all x in X,
`sum_y mu_y*g_y(x) - 3*theta <= a(x) <= sum_y mu_y*g_y(x) + theta`.
Mass at most one includes zero; no normalization-to-one shortcut is used.

The list is `compressionList`, the image of the entire finite code type
under the fixed decoder. Its code type contains:

1. One index in `Fin u`.
2. `k*s` label codes in `Fin q`.
3. `k*s*2^u` rounded-weight codes in `Fin N`.

Here `N = Nat.floor ((s:Real)*2^u/theta) + 1`; `Nat.floor` is valid for
the nonnegative real argument. `card_compressionCode` proves the exact
code count `u*q^(k*s)*N^(k*s*2^u)`. The image can be smaller, so the
list has at most that cardinality. Neither the code type nor this bound
has a factor depending on the cardinality of X.

The decoder reads only fixed representatives, labels, retained sets,
radii, and rounded weight integers, never the coefficient vector or
original column centers. `exists_profile_pivots` is a proved lemma:
its common partition index may depend on mu, as may the code selected
from the pre-existing list. `roundingStep` is
`theta/((s:Real)*2^u)`, and weights are rounded down by actual real
floor. Grouping, padding, rounding boundaries, and all real-weight
inequalities are proved, not replaced by finite grids.
`code_bound_real` proves the coercion of the exact integer code bound
is at most
`u*q^(k*s)*(1+s*2^u/theta)^(k*s*2^u)`.

The signed theorem returns a single nonempty finite set B before
quantifying over all real lambda with sum of absolute values at most
one. Its cardinality is at most the square of the positive code bound;
the error is at most `6*theta` at every x. The stronger intermediate
`differenceList_approximation` proves `4*theta` from the asymmetric
positive interval; the public signed theorem deliberately retains the
manuscript's `6*theta` constant.

## Dependencies and limitations

The self-contained greedy, representative, grouping, and rounding
development adapts the MIT-licensed upstream OpenAI implementation at
commit `4eaee87548250b2682affda7d05d947c05554bae`, with arbitrary
finite radii and profile weights in place of its dense logarithmic
profile. No OAI module or precompiled project theorem is imported.
The final axiom queries audit the actual checked declarations.
Mathlib's ordinary classical logical foundations are not extra
geometric or compression assumptions.

`SparseProfileCompression.sparse_profile_separates` proves that a
distance greater than H gives a unit profile-value difference from
distance zero. This verifies the replacement profile's part of the row
separation bridge. The existence of the finite-field partitions, the
matrix-to-convex-body theorem, logarithmic entropy conversion, and the
choice of an arbitrarily large prime are proved/explained in `report.md`
using the precisely stated manuscript results. They are **not** claimed
as fully Lean-formalized here. Their source dependencies are recorded
on C_SPARSE_ENTROPY and C_SPARSE_SIGNED in the ledger, not hidden on
C_SPARSE_CORE.

The exact finite replays in `verify.py` are additional adversarial
experiments. Neither their rational coefficients nor the Jacobian
adapter's UNKNOWN outcome support a universal assertion. The universal
minimax and counted compression statements are the kernel-checked
declarations above. Independent review of this document, the source
dependencies, and novelty/significance remains required.
