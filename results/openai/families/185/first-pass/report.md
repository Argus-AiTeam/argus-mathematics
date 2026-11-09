# Local interval alternatives: universal formal verification

The target is Proposition `prop:local-intervals` in the staged
`04-local-bases.tex`, with its original quantifiers. The prototype `T` and
its complement must both be positive for the doubled-block density-zero
ideal. For either basis rule, every `I subset Y` with `T \ I` or `Y \ T`
density-zero must admit a basis below `I`, between the endpoints, or above
`Y`. The endpoints need not belong to the prototype class, and the gap
need not be infinite.

## Primary sources and prior result

The implementation used is `openai/math` at commit
`4eaee87548250b2682affda7d05d947c05554bae`, under
`lean/OAI/Combinatorics/InfiniteMatroid/`. `Interpolation.lean` proves both
finite rounding cases and the opposite-infinite case.
`LocalBases.lean` instantiates these abstract results for the concrete
probes. `SparsePerturbation.lean` constructs small changes from a positive
pool. `BasisExtension.lean` proves endpoint corrections and identifies
the upper rule with the complemented lower rule.

The supporting import closure is `Basic`, `BlockDensity`, `Cesaro`, and
`ProbeLimits`. All eight modules have been compiled with Lean 4.31.0.
The original repository targets Lean 4.34.1. Seven modules compile
unchanged; `BasisExtension` requires one compatibility-only identifier
rewrite, `Set.mem_ofPred_eq` to the v4.31.0 name `Set.mem_setOf_eq`.
The original pinned source remains unchanged. The generated compiler
copy and exact replacement are retained, and no theorem statement,
hypothesis, or axiom is changed.

The comparator `lean/ComparatorChallenges/InfiniteMatroid.lean` states a
global result using `sorry`; it is not proof evidence. The strongest
relevant prior result is the actual implementation's concrete
`fProbe_interpolation`, together with the one-endpoint alternatives.
The new verification additionally establishes exact manuscript-definition
bridges and the full two-rule, one-sided-small-difference proposition.
No novelty or global matroid-construction verification follows merely
from finding these existing proofs.

The Wiki index contains no entry for this manuscript or local interval
construction. No external literature theorem is needed for the selected
analytic statement. The Bowler--Geschke criterion and the global
ultrafilter construction are outside this mission's proof dependencies.

## Matched definitions

The ground set is `E0 = D times Bool`, with
`D = (m : Nat) times ((Fin m -> Bool) -> Bool)`. Its doubled blocks have
size `2 * 2^(2^m)`. `blockPrefix n` uses precisely the blocks `m < n`;
the extrema use the closed index tail `m >= n`. Thus the manuscript's
prefix and tail indexing agree with the implementation.

The formal source separately identifies block density, density-zero
membership, symmetric-difference class membership, the signed real
prefix count, signed normalized block count, both tail extrema, the
probe formula, and the extended-real lower and upper limits. The
manuscript starts probes at `n = 1`, whereas the implementation also
defines `n = 0`. The limit bridges justify discarding this initial
term by proving that the shift `n -> n+1` preserves the `atTop` filter.

The primary manuscript ideal is also matched without an assumed
equivalence. `sliceDensity` counts actual points in each `D_m` slice,
with denominator `2^(2^m)`. `density_average` proves the doubled density
is their average, and `slice_ideal_bridge` proves the equivalence of
two-slice density-zero membership and doubled-block membership using
nonnegativity. The principal theorem uses the two-slice predicate.

The lower rule is `-1 < liminf <= 0`, not a closed interval at `-1`.
The upper rule is `0 <= limsup < 1`. The proved complement identities
exchange these exact half-open conventions. Dedicated declarations
exclude the lower boundary `-1`, include `0` for both rules, and exclude
the upper boundary `1`.

## Mathematical argument

Write `C(T)` for the symmetric-difference class and write `ell(X)` for
the extended lower limit. The compiled analytic dependencies prove the
following facts for the literal probes, not uninterpreted functions.

On a fixed interval `[I,Y]` with both endpoints in `C(T)`, the common
bound

    |d_m(X)-d_m(Z)| <= |(Y\I) intersect W_m| / |W_m|

tends to zero uniformly in `X,Z`. Agreement on a sufficiently large
finite prefix therefore controls every prescribed finite collection
of probes. Supremum and infimum are each Lipschitz for the uniform
tail norm. This supplies cylinder continuity and continuity along
decreasing intersections. It is not unrestricted pointwise continuity
on all subsets.

A finite change has its exact signed cardinality effect on all
sufficiently late probes. A one-element addition changes each probe by
a number in `[0,1]`, by the doubled-block growth inequality. If
`ell(I)=a` is finite and `a <= -1 < 0 < ell(Y)`, adding
`floor(-a)` gap elements gives a lower limit in `(-1,0]`. There are
enough elements: a smaller finite gap would leave `ell(Y) <= -1`.
If instead `ell(I)=-infinity` and `ell(Y)=b` is positive and finite,
the gap is infinite and deleting `ceil(b)` elements gives the same
half-open interval.

For opposite infinite limits, construct decreasing sets from `Y`.
At stage `j >= 1`, keep the set if a nonpositive probe already occurs
at an index at least `j`; otherwise reserve a large finite prefix and
delete eligible gap elements one at a time until such a probe appears.
This stops finitely: deleting every eligible element leaves a finite
extension of `I`, whose lower limit is minus infinity, and cylinder
continuity transfers a fixed strictly negative probe to a finite
deletion. Just before stopping, all late probes are positive, so
the unit bound resets all indices `n >= j` above `-1`.
The reserved prefix makes the loss at each earlier probe less than
`2^(-j)`.

In the decreasing intersection, witnesses arbitrarily far out remain
nonpositive. There is a first nontrivial stage, since `ell(Y)=+infinity`.
After that stage the reset and summable earlier-probe losses give,
for sufficiently large `n`,

    f_n >= -1 - sum_{j>n} 2^(-j) = -1 - 2^(-n).

Thus the limiting lower limit lies in `[-1,0]`. If it equals `-1`,
there is an unused point in `Y` (indeed infinitely many); adding one
makes the lower limit exactly zero. This proves the required strict
lower boundary, rather than silently accepting a closed interval.

A positive available pool supplies a small modification with probes
tending to the desired infinity. The actual implementation uses
spikes of size `b_j = delta/(j+1)` in sufficiently late positive
blocks, with integer ceiling rounding. Their densities are at most
`2*b_j` and hence tend to zero. The cutoffs bound normalized prefix
error, twice the tail error, and `1/sqrt(c_n)` by `b_j`; every large
`n` sees its assigned future spike, giving `f_n >= sqrt(c_n)`.
Complementation gives deletion. This proves the endpoint corrections
used below without assuming a maximal-extension axiom.

For the complete alternative, first suppose `T\I` is small. If `I`
is in `C(T)` and the gap is small, then `Y` is also in the class,
so endpoint correction or interpolation gives the three-way
alternative. If the gap is positive, correction inside that pool
gives a basis below `I` or between the endpoints. If `I` is not in
the class, `T intersect I` is in the class and its gap to `I` is
positive; the same endpoint correction gives a basis contained in `I`.
These statements hold for either rule: the upper endpoint results
follow by the proved complement/limsup identity.

If `Y\T` is small instead, apply the preceding result to prototype
`T`'s complement, interval `[Y-complement,I-complement]`, and the
opposite rule. Complementing the basis reverses the endpoint
inclusions and gives the original three alternatives. This handles
all subsets, including equal endpoints, without an extra gap or
finite-limit hypothesis.

## Current mathematical status

`Main.lean` proves `Manuscript185.proposition_local_intervals` with the
original two-slice ideal, both basis rules, and all original quantifiers.
The official claim-bound Lean 4.31.0 verification succeeds with
`exit_code=0`, `audit_exit_code=0`, and `proof_holes=[]`; the ledger
derives `C_LOCAL_INTERVALS`'s status as `closed_kernel`, with no
undischarged assumptions. The transitive axiom
reports for the principal theorem, ideal equivalence, finite and
opposite-infinite branches, exact rule bridges, boundary lemmas, and
critical imported results contain only `propext`, `Classical.choice`,
and `Quot.sound`.

Run `$WORKSPACE/argus-live-update/.venv/bin/python verify.py`
for a full replay. It validates the original source
blobs against the pinned GitHub commit, recompiles the complete analytic
import closure with the disclosed compatibility rename, runs the
official claim-bound Lean verifier, checks every transitive axiom
report, and emits `exact_certificate.json`. The separate
`research/statement_fidelity.md` describes the exact formal statements
for independent review.

Supplementary exact computations checked 1,928 rational rounding cases
and 81,495 probe complement/monotonicity/unit-change comparisons in
genuine finite-support perturbations of permitted infinite prototypes.
Jacobian returned the exact symmetric-difference indicator
`x+y-2*x*y`. Its preceding rejected signed-table request is retained
as an adapter error, not a mathematical conclusion. These finite
computations are not the proof of infinite interpolation.

No false manuscript assertion has been established, so no refutation
claim is asserted. This is a formal verification of an existing
proposition, not a newly discovered counterexample or a claim of
mathematical novelty. Independent Reviewer replay and statement-fidelity
assessment are required. Global assembly, rank descent, and the
advertised matroid counterexamples remain unverified by this mission;
the publishable exploratory campaign is not declared complete.
