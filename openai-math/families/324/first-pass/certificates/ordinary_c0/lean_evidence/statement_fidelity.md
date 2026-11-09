# Statement fidelity: ordinary c0 obstruction and compatible detectors

The target is Proposition `prop:compatible-detectors`, followed by
Proposition `prop:no-c0`, in the September 26, 2026 manuscript
*Bi-Lipschitz Absorption of c0 Without a Linear Copy of c0*. The source
locations are `build/sections/03-weights.tex`, `05-tests.tex`,
`06-molecules.tex`, and `07-no-c0.tex` under the staged manuscript directory.
This document describes `Main.lean` and its imported
`CompatibleSelection.lean`, compiled against `manuscript_build`.

## Objects and the norm

All spaces and functionals are real. `C0` is the space of real sequences
vanishing at infinity with supremum norm, and `C0Ball` is its closed unit
ball. A positive manuscript coordinate k corresponds to Lean coordinate
k-1. A finite prefix of length j is therefore `Fin j`, containing exactly
the manuscript's first j coordinates. The chosen enumeration of block and
scalar coordinates is bijective; its zero-based level `(i,n)` represents
the manuscript's positive level `(i+1,n+1)`. Consequently `levelJ` is
`i+n+2`, not `i+n`.

`ConcreteSpace` is `SourceSpace concreteBases`. Its initial molecules are
finitely supported real coefficients on `C0Ball` with total mass zero.
The pairing with a test is the corresponding finite scalar sum.
The seminorm comes from the manuscript's admissible finite lists:
repetition of tests and labels is allowed, and every unscaled signed sum
must have Lipschitz bound C. There is no additional division by C in
the list expression; the C normalization is in the squared-norm weight.
In the enumeration, even positions are
`TClass B (n/2+1)` and odd positions are `VClass B (n/2+1)`. There are no
additional zeroth classes in the norm. If `(a,b,c)` is the triple at
zero-based position n, the list bound is `C=b+1`, the exponent is
`p=1+1/(c+1)`, and the squared-norm weight is
`2^(-(n+1))/C^2`. Thus position n is manuscript position d=n+1.
`TestSpace` takes the seminormed quotient, through metric separation, and
then its completion. It is not a free vector space with only a
seminorm, nor a norm constructed from distinct-label lists.

The underlying scalar/block coordinate model, correction seed functions
f_gamma, finite coordinate sets, grid points, and nonincreasing ordered
dyadic operation scales are those of the manuscript construction.
`GridIndex` includes both endpoints. The operation grid at scale
`2^(-a)` has step `2^(-a)/8`. The representation budget is strict:
the sum of operation scales is less than **`ell j / 2`**, where j is
the representing label's band. In particular, `concreteBases.ell`
is the raw weight scale `ell`, not a renamed half-scale.
`GeneratedRepresentation.budget` contains the explicit division by 2.
The class parameter h bounds the number of operations; it is not
the band j. `TClass B h` permits every representing band, whereas
`VClass B h` also imposes j<=h and the displayed tail-count and
tail-scale-index bounds. Neither class inserts scalar coordinate
functions as extra seed tests.
The formal concrete schedule fixes `eta=1/1000`, `H=10000`, and
`rho 0=1/2`, with

```
rho (j+1) = min (exp (-H) * rho j / 2) (eta / (8 * bandL (j+1)))
ell j = exp (-H) * rho (j+1).
```

The manuscript leaves this schedule to a choice satisfying its displayed
inequalities. This is one such choice: `schedule_speed`, `rho_step`,
`rho_lip_budget`, `rho_pos`, and `ell_tendsto` prove the required
inequalities and decay. The extra `rho 0` initializes the recursion;
it is not an extra band in the source norm. Band vectors and rows use
the displayed truncated-distance grid formula and its normalized
nonnegative row. Corrections are the displayed band coefficient times
the predecessor-minus-current scalar. The tag and radius localization
properties used below are proved by `concreteTagLocalization` and
`concreteRadiusLocalization`; they are not postulated detector-selection
axioms.

## Explicit tail-index correction

The upstream implementation uses

```
coordinateTail N s = s - truncate (N+1) s
TailOperation.factor t s = tailFactor (dyadic t.scaleIndex) (t.tailIndex+1) s
```

The first formula retains Lean coordinates k>N. Under the coordinate
mapping above, the manuscript tail after positive coordinate N is
therefore `coordinateTail (N-1)`. Since the manuscript permits every
N>=1, the first permitted formal cutoff must be zero.

The selected manuscript model changes **only the tail parameterization**
in `TailOperation.factor` from `t.tailIndex+1` to `t.tailIndex`, for both
the basic and remainder factors. All cutoffs 0,1,... are now permitted.
The affected support witness is shifted to `N+1`, and the escaping-tail
proof no longer needs a successor-cofinality step. The affected module
closure is recompiled; the detector induction is regenerated from that
closure. This is a semantic fidelity correction, unlike the proof-only
Lean API ports. The final theorem is about this corrected model, not
merely the originally compiled upstream tail subfamily.

The indexing observation distinguishes permitted ingredients. It does
not establish inequivalence of the two completed norms, and it does
not refute a manuscript proposition. In particular, it is not being
presented as a counterexample to either Banach-space theorem.

## Full detector-selection statement

`Audit324.exact_compatible_detectors` carries these quantifiers:

* An arbitrary sequence `m : Nat -> ConcreteSpace`, weakly null against
  **every** continuous real-linear functional into the reals.
* An arbitrary fixed listed source-class index t.
* An arbitrary test sequence `psi` in that class and an arbitrary
  real `delta>0` satisfying
  `delta <= abs (sourcePairing psi_n m_n)` for every n.

The conclusion supplies a strictly increasing index map nu, a single
fixed listed output class, tests G all in that class, a real `e>0`,
and an integer `C>=1`. The output class may differ from the input
class t; the theorem does not assert preservation of that index. For every r,
`e <= abs (sourcePairing h_r m_(nu r))`. For **every finite**
`H : Finset Nat` and every real coefficient function with absolute
value 1 at indices in H, the signed test sum has Lipschitz bound C.
This includes arbitrary finite subsets, not just initial segments.
No assumption of a c0 embedding, a bounded-signed-sum sequence, or the
selection proposition itself is present in this statement.

`Audit324.full_compatible_selection` proves this statement for generic
`SourceSpace B` under `TagLocalization B` and `RadiusLocalization B`.
`PairingNull` is the scalar vanishing consequence of weak nullity, not
an axiom asserting a selected subsequence exists. `NoCompatible` is a
temporary contradiction hypothesis which is discharged.

The induction's inputs and conclusions preserve repeated labels,
chronological operator order, fixed-class membership, finite supports,
and the original strict scale budget. The last step upgrades
initial-segment signed bounds to arbitrary finite H by averaging two
full sign extensions, whose omitted coefficients cancel.

## Infinite-dimensional obstruction

`Audit324.ordinary_c0_obstruction` asserts `noLinearC0 ConcreteSpace`.
Explicitly, there is no continuous real-linear map
`T : C0 ->L[Real] ConcreteSpace` and positive real c such that
`c * norm x <= norm (T x)` for every `x : C0`. This is the assertion
that the Banach space contains no subspace linearly isomorphic to
ordinary c0, with the inherited norm. It does not prohibit unbounded
algebraic linear maps and is not merely an obstruction to c0(l2).

The proof uses `Audit324.no_bounded_signs_lower`, whose sequence
quantifier is infinite. A norm lower bound and bounded signed sums
give one fixed norming class; the new selection theorem gives
compatible detectors; exact random-sign orthogonality gives growing
quadratic detection incompatible with the completed norm bound.
Applying this to `T(atom i)` supplies the contradiction. The proof
does not call `concrete_noLinearC0` or `source_noLinearC0` as a shortcut.
`Audit324.noLinearC0_of_localization` also proves the corresponding
structural theorem for every `CylinderBases` satisfying the two
stated localization hypotheses.

## Compiler scope and remaining human obligations

The dependency closure is ported from the upstream Lean 4.34.1
declaration to Lean 4.31.0. Apart from the explicit tail-index model
correction above, the recorded changes are proof-only library API
adjustments; they do not change definitions, theorem statements, or
hypotheses. Their source hashes and compiler outcomes are in
`build/compatibility_audit.json`, `compiler_build.json`, and
`manuscript_build.json`.

The four principal declarations, in namespace `Audit324`, are
`no_bounded_signs_lower`, `noLinearC0_of_localization`,
`ordinary_c0_obstruction`, and `exact_compatible_detectors`.
Their transitive axioms are Lean's standard `propext`,
`Classical.choice`, and `Quot.sound`. No sorry, added axiom, unchecked
detector-selection assumption, finite-dimensional exhaustion, or
Jacobian result proves the infinite-dimensional conclusion.

Compilation certifies the encoded statements and dependency proofs.
The correspondence in this document, the manuscript readings, and
any claim of publishable mathematical novelty still require
independent human review. The September 24 manuscript's separate
c0(l2) construction and its external literature inputs are not
theorems certified by these declarations. The arithmetic replay and
the exact LP primal/dual certificate are auxiliary checks only.
