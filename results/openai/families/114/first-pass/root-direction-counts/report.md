# Root-direction log-concavity of ordinary integer-base pair counts

**Result:** a universal Lean 4.31.0 proof of the proposition, including
its grouped rank-signature input, exact unweighted-count bijection,
interval support, and the manuscript's real-power interpolation.
Independent Reviewer acceptance of the new result is pending.
The accepted balanced-summation certificate is an unchanged dependency.
This result does not certify the complete FPRAS or publication-level novelty.

## Exact statement and relation to prior work

For arbitrary integral normalized submodular functions `f1,f2` on a
finite ground set, let `y(t)` count ordered integer-base pairs with
`x1-x2 = d0+t(e_j-e_k)`, where `d0` is arbitrary integral and `j!=k`.
The positive support is an integer interval, possibly empty or a
singleton, and for `a<t<b` with positive endpoint counts,

```
y(t) >= y(a)^((b-t)/(b-a)) * y(b)^((t-a)/(b-a)).
```

This is Proposition `prop:shift-logconcavity` in the staged October 5,
2026 manuscript's `build/sections/signatures.tex`. All counts here
are ordinary integer-vector counts.

The strongest prior result in this campaign, independently accepted
`C_BALANCED`, established abstract balanced-summation closure.
The new result supplies all of its discrete counting inputs and the
actual counting conclusion. It is not an inference from passing
small examples. No false assertion in the proposition or the audited
rank-signature lemma was identified.

A targeted lookup of the inherited Wiki found no relevant result.
A bounded Mathlib lookup found no ready-made polymatroid/Lorentzian
counting theorem. The new proof therefore proves the needed finite
rank facts directly; no external literature proposition is assumed.
The manuscript itself already states the counting conclusion, so a
priority claim for that conclusion would be inappropriate.

## Direct finite-minimum verification of the grouped input

For every integer profile `v`, including negative profiles, define

```
m_f(v) = min_A [f(A) + v(E\A)],
P_f(v) = v(E) + f(E) - 2*m_f(v),
W_H(v) = exp(-H*P_f(v)).
```

The source uses this formula after modular shifts to monotone ranks.
The same formula works directly for arbitrary integral submodular
`f`. It is invariant under simultaneously translating `f` and `v`
by a modular integer vector; this identity is also formalized.

Here is the local argument that avoids an external expansion-matroid
theorem. For additions use `h(A)=f(A)+v(E\A)`; for removals use
`h(A)=f(E\A)+v(A)`. For a finite set `T` of labelled step copies,
with physical map `g`, put

```
rho(T) = min_A [h(A) + #{p in T : g(p) notin A}] - min_A h(A).
```

The joint cost is submodular in the minimizing set and the labelled
step set. Taking attained minimizers and applying union/intersection
therefore proves submodularity of `rho`. Monotonicity and the bound
of one on each marginal follow directly from the cardinal term.
Thus `rho(empty)=0`, and every singleton rank is zero or one.

Two nonloops are parallel when their pair rank is one.
Submodularity on two overlapping pairs proves transitivity: their
union has rank at most one and contains the third pair.
Two distinct labels per count coordinate make this argument valid
for repeated physical groups and repeated-coordinate diagonals.
The resulting relation on count indices is symmetric and transitive;
it may omit isolated self-relations. Its indicator matrix is a Gram
matrix of disjoint class indicators.

For either sign the normalized entry is consequently
`Q_ij=exp(-2H)` on this relation and `1` elsewhere.
Hence `J-Q` is positive semidefinite for `H>=0`.
For deletion the single-copy and two-copy offsets are exactly `1`
and `2`; they cancel in the normalized second difference.
This explicitly verifies the orientation.

Different factors use disjoint count coordinates, so their
normalized defects form separate blocks. Invalid first steps give
zero rows in the raw test, and invalid repeated steps subtract a
nonnegative diagonal. The common-hyperplane inequality survives both
operations. It is important to truncate the raw test, not to
incorrectly assert that zeroing rows of `Q` preserves `J-Q >= 0`.

These facts prove both signatures for all finite boxes, grouped
maps with empty groups, consistent reflected orientations,
nonnegative powers, and fixed box-valid coordinates. The proof
extends the rank input's domain to arbitrary integral submodular
functions and integer baselines without first translating them.
It does not change the manuscript's final counting assertion.

## From positive weights to actual ordinary counts

Normalization gives `m_f(v)<=v(E)` and `m_f(v)<=f(E)`, by choosing
the empty and full minimizing sets. Therefore `P_f(v)>=0`, and
`P_f(v)=0` exactly when `v` satisfies all integer base constraints.
The positive weights converge to base indicators.

Fix a finite parameter interval `[A,B]`, and choose finite coordinate
intervals containing every integer base of `f2`. Use ordinary pairs
`(a_e,b_e)` at balance and a retained pair `(p,q)`, exactly as in the
manuscript. The formal proof chooses a common sufficiently large
width; arbitrary inputs are still covered.

The first factor has increasing arguments
`L+a+d0+A*e_j-B*e_k+p*e_j+q*e_k`; the second has decreasing
arguments `U-b`. The grouped input just proved supplies the
signatures. The imported accepted closure then sums all ordinary
pairs, leaving a strictly positive two-coordinate sequence.
Its removal test is
`[[y_H(t-1),y_H(t)],[y_H(t),y_H(t+1)]]`, giving adjacent
log-concavity. A proved discrete chord inequality for `log y_H`
gives global interpolation.

At balance `a+b=U-L` the second vector is `x2=L+a`, while
`p=t-A`, `q=B-t` make the first vector exactly
`x1=x2+d0+t(e_j-e_k)`.
Every admissible pair has the unique encoding
`a=x2-L`, `b=U-x2`; no labelled-copy multiplicity appears.
`boxPairEquiv` proves this bijection, not just equality on examples.

All sums are finite. Passing the global integer-power inequality to
the pointwise limit proves

```
y(a)^(b-t) * y(b)^(t-a) <= y(t)^(b-a).
```

Positive endpoints force every intervening count to be positive.
Taking logarithms and exponentiating proves the displayed real-power
inequality inside Lean as well.

This proof imposes no monotonicity, coordinate-sign, equal-total,
or nonempty-support hypothesis. Incompatible total differences
simply yield zero counts. Singleton and empty support require no
special limiting argument.

## Formal and computational evidence

The principal declarations in `Main.lean` are
`RootDirectionCounts.root_direction_logconcavity` and
`RootDirectionCounts.root_direction_real_interpolation`.
`RankSignatures.lean` contains the complete proved grouped input.
`statement_fidelity.md` identifies all objects, quantifiers,
declarations, and dependency boundaries.

The native source-bound certificates are archived in this directory's
`certificates/` and `rank-evidence/certificates/` directories.
The actual compiler and axiom-audit outcomes are zero, with
`proof_holes=[]`, for both `C_ROOT_COUNTS` v3 and `L_ROOT_GROUPED` v2.
The principal count declarations' transitive axiom profiles contain
only `propext`, `Classical.choice`, and `Quot.sound`.
Their archived certificates are
`certificates/C_ROOT_COUNTS-693e2df43c634742.json` and
`rank-evidence/certificates/L_ROOT_GROUPED-81cc13438e0496d8.json`.

`verify.py` authenticates their real compiler outcomes and the
accepted `C_BALANCED` certificate, then replays exact finite
adversarial tests. The finite tests are supplementary, not the
universal proof. They test submodularity and normalization of every
rank table, signed coordinates, unequal total ranks, explicit empty
and singleton supports, grouped addition/removal matrices, invalid
diagonals, modular translations, and zero-penalty multiplicities.
The exact finite measurements are 77 rank tables, 4,069 rank pairs,
31,101 root lines, 13,868 global interpolation inequalities, and
1,080 grouped signature tests. Both the exact empty-support total
obstruction and the unique-pair singleton case are included separately.
Certificate generation reads the serialized result back and checks
equality with the computed data.

The retained Jacobian request concerns the normalized defect
`(3/4)J_3` for three grouped coordinates feeding a rank-one element.
Its exact spectrum is `9/4,0,0`; the typed result records the
operation, payload, protocol, server version, and successful adapter
status. This is one finite matrix calculation, not a proof strategy
or evidence of the universal theorem by itself.

From the campaign root, replay the exact certificate with

```
$WORKSPACE/argus-live-update/.venv/bin/python research/root-direction-counts/verify.py
```

For independent compilation, first run `verify.py --build-dependencies`.
This builds import objects from the unchanged accepted source and
the new grouped-signature source; it does not replace the accepted
certificate. Then use the native `lean_evidence verify` commands
documented by `verify.py --help`, with the dependency directory in
`LEAN_PATH`. The source and fidelity files must not be edited during
those runs.

Only the new result is submitted to the Host-invoked independent
Reviewer. The prior closure result is not reopened. The broader
algorithm, publication-level novelty assessment, and campaign
completion remain separate obligations.
