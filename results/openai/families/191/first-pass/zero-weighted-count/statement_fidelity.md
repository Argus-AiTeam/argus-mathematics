# Statement fidelity: logarithmic weighted determinant-zero count

## Status and scope

The principal declaration is
`ZeroWeightedCount.manuscript_zero_count` in `Main.lean`.
The source is checked with Lean **4.31.0**.
All twelve printed declarations are required to have only the standard axioms
`propext`, `Classical.choice`, and `Quot.sound`; there is no `sorryAx`,
proof hole, target-specific axiom, or assumed target count.
Compiler results, source binding, and axiom lists are separate artifacts;
this document states what the declarations mean, not a compiler verdict.
`compiler/Contracts.log` records the full upstream structures and theorem
types. `compiler/FinalContract.log` records the principal contract,
product-probability identity, constant, and principal axiom list.
The temporary introspection sources were removed; `Main.lean` is the
sole retained local formal source.
No independent Reviewer approval is asserted.

This is a wrapper around a proved global zero-count theorem,
not the log-squared fixed-fiber theorem and not an aggregation theorem
whose input is the desired matrix-count estimate.

## Exact local objects

* `Vector q = Fin 3 → ZMod q`; `IntMatrix = Matrix (Fin 3) (Fin 3) ℤ`.
* `MatrixBox N M` means, for every column `j`,
  `0 ≤ M 0 j < N`, `0 ≤ M 1 j < N`, and `N ≤ M 2 j < 2N`,
  with integer inequalities and half-open upper endpoints.
* `DistinctProjections M` is pairwise distinctness of the real pairs
  `(M 0 j / M 2 j, M 1 j / M 2 j)`.
* `PrimePowerRowData.rowModule C` is the integer inverse image of the
  **row** span of `C` modulo `B^k`, not its column span.
  Upstream `RowLattice.rowImage_eq_rowSpan` proves the row-span
  identification. `zeroMatrices C N` enumerates exactly all matrices
  satisfying these box, row-lattice, determinant-zero, and projection
  conditions. The equivalence is proved by `mem_zeroMatrices`; the
  containing finite matrix enumeration is not a cardinality hypothesis.
* For `H=h²`, set `w = q / (1000*H²)`, with natural-number division.
  `allowedShiftSet q H w` is all vectors `a` whose first coordinate
  satisfies
  `n*a 0 ∉ integerWindow q (3*H*w)` for `1 ≤ n ≤ 3H`.
  Here `integerWindow q R` is the image modulo `q` of the integer interval
  `[-R,R]`; the other two shift coordinates are unrestricted.
* `restrictedWeight q S A p` is
  `(q³/|S|)³` times the fraction of affine equivalences `e` with allowed
  input shift in `A` and `e.symm(p i) ∈ S` for every `i : Fin 3`.
  `actualWeight q h S M` uses the just-defined allowed shifts and the
  columns of `M mod q`. Its membership event permits repeated columns.
  It is not a product of three single-column probabilities.
* Upstream `AffineTripleOrbit.inputShiftEquiv` sends `e` to `(G,a)`
  with `e(x)=G(a+x)`. Its proved restriction
  `restrictedInputShiftEquiv` is a bijection with `GL₃(F_q) × A`.
  Consequently uniform allowed affine maps are exactly a uniform
  independent invertible `G` and allowed shift `a`; this is the finite
  counting formulation of the manuscript's probability.
  `restrictedWeight_eq_uniform_product` proves the exact normalized
  successful-outcome-cardinality divided by total-outcome-cardinality
  identity on `GL₃(F_q) × A`, with the event
  `∀ i, p i ∈ G(a+S)`. This correspondence is a proved identity, not a
  remaining informal probabilistic identification.
* `uniform_weight_eq` proves equality of that explicit finite-cardinality
  weight and the normalized auxiliary expectation. `restrictedLaw`
  constructs the entire sampling-law record for this particular
  experiment, and `restrictedLaw_weight` proves that its weight is the
  explicit `restrictedWeight`. No unspecified law is left as a hypothesis
  of the principal declaration.

## Principal quantifiers and hypotheses

`manuscript_zero_count` quantifies over:

1. Naturals `B,k,q`, with `B.Prime`, an instance of `q.Prime`,
   `2 ≤ B^k`, and `(B^k)^100 < q`.
2. Every matrix `C` over `ZMod (B^k)` and every
   `d : PrimePowerData B k C`. This record consists **only** of
   `b,e : ℕ`, `b ≤ e ≤ k`, two invertible matrices `P,Q`, and
   `C = P * diag(1,B^b,B^e) * Q`. These are supplied Smith data,
   not a counting assumption. The singular cases `e=k` and `b=e=k`
   are not excluded.
3. Every finite cap `S ⊆ F_q³`, with
   `(v 0).val < floor(q/(1000*(h²)²))` for every `v∈S`, and
   the real lower bound `q²/(2000³*h^12) ≤ |S|`, where `h=B^k`.

Only the first-coordinate cap-box condition is needed, so the theorem
also covers the manuscript's stronger three-coordinate box condition.
`cap_size_bound_iff` proves its equivalence to the integer,
denominator-cleared condition `q² ≤ 2000³*h^12*|S|` used by the
intermediate theorem. Nonemptiness of `S`, density of allowed shifts,
the relevant coprimality, and the short-null-vector exclusion are
**proved**, not further assumptions.

With `N=(B^k*q)^10` and `I=B^b*B^e`, the conclusion is exactly

```
sum M in zeroMatrices C N, actualWeight q (B^k) S M
  ≤ absoluteConstant * log(2*N) * N^6 / I^2.
```

`absoluteConstant` is a parameter-free positive real number:

```
AuxiliaryZeroCount.countConstant * (2 / Real.log 2).
```

The intermediate theorem `weighted_determinant_zero_bound` is stronger:
it allows any `N ≥ 1`, any finite family satisfying the pointwise matrix
conditions, and only `h^26 ≤ q`. No count bound on that family is assumed.
The principal declaration specializes this result to the complete finite
set and the manuscript's `N` and prime-size regime.

The explicit analytic constant `10^33` in `argument.md` belongs to its
independent four-case proof. The Lean conclusion uses `absoluteConstant`;
it does not assert a numeric comparison between that upstream constant
and `10^33`.

## Full upstream theorem contract inspected

`OAI.Problem355.ZeroGlobalCount.weighted_count_le_log` takes:

* `D : ZeroDeterminantCount.RowData`, naturals `q,N`, `q.Prime`, `N≥1`,
  invertibility of `D.E mod q`, and `D.h^26≤q`;
* an arbitrary finite matrix family `F` and real-valued weight `W`;
* three nonnegative pointwise weight constants `Ca,Cg,Cd`;
* nonnegative weights, zero determinants, rows in `D.L`, nonzero third-row
  entries, pairwise distinct projections, and entrywise absolute bound
  `2N`;
* for positive weight, containment of the residue columns in a cap;
* the bounds `W≤Ca` on affinely independent residue triples,
  `W≤Cg*q²*D.h^24` always, and `W≤Cd*q*D.h^12` whenever at least two
  residue columns differ;
* exclusion of primitive integer right null vectors of norm at most
  `D.h²` on positive-weight, affine-independent residue triples.

Its proved conclusion is

```
sum M in F, W M
  ≤ countConstant Ca Cg Cd * N^6 / D.I^2 * (log(4*N)/log 2).
```

`RowData` has exactly these data fields: naturals `B,b,e,k`, primality of
`B`, `e≤k`, an integer row submodule `L`, an integer matrix `C`, invertible
matrices `P,Q` modulo `B^k`, its diagonalization with diagonal
`(1,B^b,B^e)`, containment `B^e*ℤ³ ⊆ L`, membership of the rows of `C`
in `L`, and `index L=B^(b+e)`. It has **no matrix-count, moment-count,
or shell-count field**. The principal proof constructs it with the
proved `PrimePowerData.toZeroRowData`, not by assuming such geometric
estimates.

`AuxiliaryZeroCount.weighted_count_le_log` supplies the pointwise weight
and exclusion hypotheses with constants
`Ca=8`, `Cg=2*2000^6`, and `Cd=4*2000^3`. Its abstract sampling-law
record contains normalization, equal set sizes, the cap-size lower bound,
nonzero/cap/short-relation properties and three pointwise weight bounds.
For the principal theorem every one of these record fields is discharged
by `restrictedLaw` for the specified cap and allowed-shift experiment.
None is the desired global or shell matrix-count conclusion.

## Repeated residues, low residue rank, and proof dependence

The inspected proof path is:

```
ZeroGlobalCount → ZeroCombinedShell → ZeroDeterminantCount
  → MatrixAffineShell / RowLatticeEqualShell / MatrixSpecialRankTwo
```

The geometry is proved through upstream plane-lattice covolume and
spanning-triple packing lemmas, plus the prime-power pairing moment and
sparse-normal counts. The top-level theorem does not accept a packing,
moment, matrix-fiber, or shell estimate as an assumption.

`AuxiliaryThreeCase.three_case_cover` handles all-equal residue columns:
a nonzero reduced primitive normal has a nonexceptional coordinate
difference pair, so an all-equal triple is assigned to the additional
equal-pair case. Primitivity implies a nonzero reduction for every prime.
If the repeated pair is exceptional and the triple is not all equal,
the bound `W≤Cd*q*h^12` uses **any distinct pair of points**, which is an
affinely independent pair even when the matrix has linear rank at most
one modulo `q`. `special_weight_le_four` and
`affineInclusionWeight_le_four_of_ne` do not require rank two modulo `q`.
The lattice spanning-pair condition is over `ℝ` and is obtained from the
distinct projected columns. Thus low rank modulo `q` is not silently
discarded and no rank-two-modulo-`q` assumption is added.

The dyadic normal reduction proves existence of a bounded primitive
**right** null vector from the actual determinant/projection hypotheses.
Its shell estimates are supplied by the preceding proved chain. The
auxiliary theorem `weighted_count_le_log_of_normal_shell_bound` is not
used with an unproved shell estimate.

`logarithm_conversion` proves, for every real `N≥1`,

```
log(4*N)/log 2 ≤ (2/log 2)*log(2*N).
```

It uses `4N≤(2N)²` and monotonicity of the real logarithm. This is a
single-log bound, not a replacement by a log-squared bound.

## Build provenance and remaining boundaries

The installed, already built Lean/Mathlib workspace is
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`, whose Mathlib
oleans are under `.lake/packages/mathlib/.lake/build/lib/lean/`.
No dependency installation or lakefile creation is needed.

The read-only upstream tree advertises Lean 4.34.1. It is checked against
the requested Lean 4.31.0 by `compiler/build_upstream.py`, emitting
dependencies only under `compiler/upstream-olean/`.
Compatibility name changes were found: Mathlib 4.34's
`Finset.prod_le_prod₀` is named `Finset.prod_le_prod` in Mathlib 4.31,
and Lean 4.34's conditional names `dite_eq_left`, `dite_eq_right`,
`ite_eq_left`, and `ite_eq_right` use Lean 4.31's
`dif_pos`, `dif_neg`, `if_pos`, and `if_neg`,
with the same hypotheses. The predicate-set membership name
`Set.mem_ofPred_eq` is replaced by `Set.mem_setOf_eq`.
The diagnostic builder substitutes those names
in the compiler's stdin, leaves upstream files unchanged, and records
both source hashes and every substitution in `compiler/upstream-build.json`.
The natural product comparison in `LatticeResidues` additionally supplies
the explicit proved nonnegativity premise `fun _ _ => Nat.zero_le _`
required by the older API. These are kernel-checked compatibility
adaptations, not added axioms or changes of theorem statements.
The older Mathlib also lacks `Matrix.GeneralLinearGroup.det_surjective`.
At its `OrbitEstimate` call site, the builder substitutes the complete
proof that `diag(u,1,1)` is an invertible matrix of determinant `u`.
The replacement proof term is preserved verbatim in
`compiler/build_upstream.py` and is checked in the compiled
`OrbitEstimate` dependency; no surjectivity axiom is supplied.

Reproduction after the dependency build:

```
python research/zero-weighted-count/compiler/compile_main.py
```

That script invokes the installed Lean 4.31.0 executable with the
existing workspace's `LEAN_PATH`, prefixed by `compiler/upstream-olean`,
and captures the exact command, compiler log, source hash, and axiom lists.
The same additional import path must be preserved for a subsequent
official claim-bound check; this source is not independent of its stated
Mathlib/upstream dependencies.

The theorem certifies the zero-count conditional on the supplied cap and
Smith decomposition, exactly as exposed above. It does not formalize the
whole manuscript, construct every manuscript cap from scratch, certify a
novelty claim, or assert independent review. The claim-bound compiler record and campaign-local checks are maintained
separately. Their success does not replace independent statement-fidelity
review.
