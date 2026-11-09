# Statement fidelity: ordinary root-direction counts

This document describes `C_ROOT_COUNTS` and `L_ROOT_GROUPED`. It describes
the declarations in `Main.lean` and `RankSignatures.lean`, respectively.
The manuscript target is Proposition `prop:shift-logconcavity` and its
input Lemma `lem:rank-signatures` in the staged October 5, 2026 manuscript,
`build/sections/signatures.tex`. It does not certify the FPRAS.

## Objects, hypotheses, and the actual count

`E` is an arbitrary finite type, with no bound on its cardinality.
`f1 f2 : Finset E -> Int` are arbitrary integer-valued set functions.
The hypotheses are precisely

* `Submodular fi`: `fi (A union B) + fi (A inter B) <= fi A + fi B`;
* `fi empty = 0`.

There is no monotonicity, nonnegative-rank, nonnegative-coordinate,
equal-total-rank, feasibility, or positive-count assumption on these
functions.

`RankSignatures.InBase f x` means that `sum_e x(e) = f(E)` and
`sum_{e in A} x(e) <= f(A)` for every subset `A`. This is the integer
part of the source's real base polytope, not its nonnegative-only
polymatroid convention and not a labelled-copy base set.

`RootDirectionCounts.BasePairs f1 f2 delta` is the subtype of actual
ordered pairs of integer profiles satisfying both base predicates and
`x1(e) - x2(e) = delta(e)` for every `e`.
`basePairs_finite` proves that this type is finite for every displacement;
there is no use of `Nat.card`'s convention for infinite types.

`d : E -> Int` is arbitrary. `rootShift d j k t` is
`d(e) + t * 1_{e=j} - t * 1_{e=k}`.
`rootShift_eq_root_direction` proves equality to
`d + t * (e_j - e_k)` as a profile. `pairCount` is `Nat.card` of the
actual `BasePairs` at that displacement. It has no factorial,
binomial, orbit-size, volume, or labelled-copy multiplier.

## Exact conclusions

`RootDirectionCounts.root_direction_logconcavity` quantifies over all
the above inputs and distinct `j,k`. It proves

1. `Set.OrdConnected {t : Int | 0 < pairCount ... t}`.
2. For every integer `a < t < b` with positive endpoint counts,
   `y(a)^toNat(b-t) * y(b)^toNat(t-a) <= y(t)^toNat(b-a)`.

`OrdConnected` is exactly the no-gaps interval assertion on integers;
it permits empty and singleton sets. The coordinate bounds proved in
`base_coordinate_bounds` also bound every possible displacement on a
root line with distinct endpoints.

All three integer differences in the interpolation assertion are
strictly positive. Consequently their `toNat` conversions are their
actual integer lengths, not truncated substitute exponents.
`pairCount_interpolation` proves this inequality even without positive
endpoint hypotheses. `pairCount_positive_between` proves interval
support from it, including the boundary equalities.

`RootDirectionCounts.root_direction_real_interpolation` separately
proves the manuscript's exact real-power shape:

```
(y(a) : Real)^((b-t)/(b-a)) *
(y(b) : Real)^((t-a)/(b-a)) <= (y(t) : Real).
```

Its hypotheses are exactly submodularity, normalization, `a<t<b`,
and positive endpoint counts. Integer parameters are cast to reals
before the divisions. The proof derives the integer-power inequality,
proves positivity of the middle count, takes logarithms, divides by
the positive length, and exponentiates. Thus equivalence to the
source's fractional exponents is also inside the compiler boundary.

The interpolation lemmas in fact do not need `j != k`; the principal
interval theorem retains the source's distinctness hypothesis.

## The grouped-rank input is proved, not assumed

`RankSignatures.rankMinimum f v` is the attained finite minimum

```
min_{A subset E} [f(A) + sum_{e outside A} v(e)].
```

`penalty f v = sum v + f(E) - 2*rankMinimum f v`, and
`weight f H v = exp(-H * penalty f v)`.
The definitions match the source, with an extension to arbitrary
integer profiles and arbitrary integral submodular functions.
`penalty_nonnegative` and `penalty_zero_iff` prove that for normalized
`f` the penalty is nonnegative and vanishes exactly on `InBase f v`.
`weight_limit` proves the base-indicator limit as real `H` tends to
positive infinity.

The local finite-minimum argument proves a normalized, integral,
submodular auxiliary rank whose one-element increments are zero or
one. It proves the joint submodularity inequality before taking the
minimum; it does not assume that arbitrary minima preserve
submodularity. The parallel relation, its symmetry/transitivity, and
its Gram representation are proved from these axioms.

For removals `orientedCost` complements the minimizing subset.
`orientedCost_step`, `localRank_single`, and `localRank_pair` prove the
correct one-unit and two-unit offsets for deletion. This is a proved
orientation identity, not an assumed dual-matroid invocation.
Every count coordinate has two distinct auxiliary labels, so a
repeated step is represented by two changes even when both labels
feed the same physical element.

`normalized_J_sub_psd` proves nonnegativity of the quadratic form of
`J-Q` for every real vector. The actual raw box test is obtained by
positive diagonal congruence, then zeroing invalid first-step rows
and columns and subtracting the nonnegative invalid-repeat diagonal.
`cutMatrix_kernel` proves the resulting common-hyperplane bound.
It does not incorrectly demand that zeroing rows of `Q` preserve
positive semidefiniteness of `J-Q`.

`boxed_disjoint_grouped_signature` quantifies over any finite set
`K` of factors, a factor assignment `a : I -> K`, a physical map
`g : I -> E`, arbitrary integer baselines, arbitrary box capacities,
and an independent increasing/reflected orientation for each factor.
Each count coordinate belongs to just one factor, while several
coordinates may have the same physical image. Empty physical groups
are permitted. `direction = true` means addition; `false` means
removal. `boxed_disjoint_grouped_slice_signature` includes zero
extension outside the required total slice.
`boxed_disjoint_grouped_power_signature` handles every nonnegative
real power. These are universal declarations, not finite tests.

`Signature B` has exactly the accepted bilinear meaning:
if `B(u,u)>0` and `B(v,u)=0`, then `B(v,v)<=0`.
The independently accepted `BalancedSummation.signature_iff_eigenvalues`
identifies this with at most one positive eigenvalue, including
multiplicity. There is no stronger signature hypothesis.

The source introduces modular translations to make the ranks monotone.
The new proof needs neither monotonicity nor nonnegative baselines.
For literal comparison, `exists_monotone_modular_shift`,
`modularShift_base`, and `penalty_modularShift` prove that the source's
translated construction gives exactly the same penalty. This is an
extension of the verified input's domain, not a correction of a false
manuscript assertion.

## Summation, limiting counts, and multiplicity

`fullWeight_inputs` applies the proved grouped-signature theorem to
the actual full-slice product and proves strict positivity and zero
extension. `approximation_inputs` applies the imported
`BalancedSummation.balanced_pairs_removal`; it does not assume any
closure theorem as a parameter.

`CountIndex D n` uses the accepted recursive pair presentation, with
two retained Boolean coordinates and one ordinary pair per physical
element. An equivalence `Fin n equiv E` handles an arbitrary finite
ground set. A single common positive width `D>=2` is chosen large
enough to contain every integer base of `f2`; this is an allowed
choice of the source's coordinate intervals, not a restriction on
the input base polytopes.

`sumPairs_encode`, `encoded_vector_false`, and `encoded_vector_true`
identify each balanced summand. Its second physical vector is
`x2 = L + v`, and its first is `x2 + rootShift d j k t`.
`approximation_limit` proves the finite sum's pointwise limit.
`boxPairEquiv` supplies an explicit bijection from good count choices
to actual ordered integer-base pairs, and `boxCount_eq_pairCount`
transfers cardinalities. Each pair has exactly one choice
`v = x2-L`; there is no copy-count cancellation left as a hypothesis.

`binary_logconcave` derives adjacent log-concavity from the actual
retained two-coordinate removal test, with the correct order
`[[y(t-1),y(t)],[y(t),y(t+1)]]`.
`discrete_chord` and `positive_logconcave_interpolation` prove global
interpolation for positive approximations.
`boxCount_interpolation` passes their integer-power inequality to the
finite pointwise limit before deriving no gaps. This does not infer
interval support from adjacent inequalities of a zero-containing
limit.

## Imported dependency and trust boundary

The only project dependency is the already independently accepted
`C_BALANCED` v2, certificate
`research/balanced-summation/certificates/C_BALANCED-0db48a75dbe67495.json`.
Its source and fidelity text remain unchanged, and its certificate
is reused without reopening its claim or commissioning another
review. An object module was built from that immutable source solely
to link the new proof. `Main.lean` imports its actual proved
declarations, not a custom axiom or an extra closure hypothesis.

`Main.lean` also imports the proved `RankSignatures` module. The exact
replay authenticates both new source-bound native certificates, their
current claim versions, the accepted dependency certificate, and the
linked object modules. Dependency-building commands are provided by
`verify.py --build-dependencies`; they do not issue a new certificate
for `C_BALANCED`.

The final new declarations print only Lean's foundational axioms
`propext`, `Classical.choice`, and `Quot.sound`.
There are no admitted proofs, custom axioms, bounded-dimension
hypotheses, or unproved grouped-signature inputs.

The native compiler checks the encoded mathematics, not this reading
of it. Independent Reviewer acceptance of this fidelity document and
the new result is still required. No claim of publication-level
novelty, full-FPRAS correctness, or campaign termination is made.
