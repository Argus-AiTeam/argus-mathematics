# Statement fidelity: the quantitative profile extension

## What is formalized

`Main.lean` includes, as source text, the 36 required Apache-2.0 dependency
modules from `openai/math` revision
`4eaee87548250b2682affda7d05d947c05554bae`, followed by this campaign's
`ProfileCore.lean`, `SeedTrace.lean`, and `BooleanExtension.lean`.
`assemble.py` removes only import lines from the component sources and adds
one `import Mathlib`. Thus the compiler checks the dependency proofs, rather
than assuming the source paper's claims or importing unverified OAI binaries.
The installed toolchain is Lean 4.31.0 with its prebuilt Mathlib workspace.
`Compatibility.lean` precedes those modules and proves four renamed
conditional-simplification lemmas from Lean 4.31.0's `if_pos`, `if_neg`,
`dif_pos`, and `dif_neg`. This is a proved API bridge, not an extra axiom;
the archived upstream proof sources themselves are unchanged.

The inherited `OAI.Paper320.flip` changes exactly the coordinates in a finite
block. `sensitivityAt` counts the sensitive original input coordinates.
`sensitivity` is its maximum over all Boolean inputs.
`blockSensitivityAt` is the maximum cardinality of a pairwise disjoint family
of nonempty sensitive blocks at the specified input; invalid families
contribute zero. All these are natural numbers defined on actual total
functions from finite Boolean cubes to `Bool`.

The family predicates are nested in their *predicate index*, not monotone in
their Boolean input bits. Joint profiles refer to two distinct predicates
at the same input changed by the same individual original input coordinate.
They are not independent changes of abstract child outputs.

## Universally quantified profile theorem

`QuantitativeProfile.uniform_profiles` states that for every natural
`h >= 1`, and every natural `n <= 2*h`, both ordinary components of
`profile (pDepth h) (qDepth h) n` are at most 2, where

* `qDepth h = 1/(4*3^h)` and `pDepth h = 16*(qDepth h)^2`;
* the initial four-vector is `(1,1,0,0)`;
* `step p q (a,b,c,e) = (p*a+b+3*e, a+q*b, p*a+3*e, c+q*b)`.

`raw_majorizes` compares any natural-valued ordinary/joint profile sequences
with the exact nonnegative four-state integer recurrence, assuming only their
four stated transfer inequalities and the initial bounds `(L,L*M,0,0)`.
`raw_scaled` proves the normalization identities for all positive integers
`M`, rather than treating a normalized recurrence as a substitute definition
of the Boolean profiles.

`depth_parameter_identities` proves the identities relating this normalization
to `mDepth h = 16*3^(2*h)` and `rDepth h = 4*3^h`, including
`rDepth h ^ 2 = mDepth h`.
`raw_even_bound` gives the resulting natural-valued sensitivity majorants.

`actual_uniform_profiles` applies these facts to the inherited *actual*
nested-tournament construction, for every `h >= 1`, every regular tournament
at `M=mDepth h`, every good labeling with `r=rDepth h`, and every level
`n <= 2*h`. Its two conclusions are exactly

\[
 S_{n,0}\le2(2h+2)M^n,\qquad
 S_{n,1}\le2(2h+2)M^{n+1}.
\]

There is no assumption of label existence left over:
`improved_construction_labels` proves it for every `h`.
`construction_label_count` proves that this integer `r` is precisely
`ceil(sqrt M)`. The inherited source proofs establish the label-counting
union bound, separated Hamming-ball initial predicates, every-input
raw-bit four-profile inequalities, recursive common blocks, OR balancing,
coordinate reindexing, and composition. These are compiler-checked
dependencies, not additional mathematical axioms.

## Seed and infinite family

`seedM = mDepth 10 = 16*3^20`, `seedR = rDepth 10 = 4*3^10`,
`seedA = 36*seedM^21`, and
`seedB = seedM^2*(2*seedM^2+1)^20`.

`seed_raw_exact` checks the complete 20-step natural-valued majorant trace
from `(22,22*seedM,0,0)` using ordinary Lean arithmetic proofs.
`seed_raw_bound` proves that both OR-balanced sensitivity majorants are at
most `seedA`. This is a bound, not an assertion that the majorants are
the true maximum sensitivities.
`seed_integer_exponent` proves `seedA^161 <= seedB^80`.
It uses integer arithmetic and algebraic power identities, not floating
logarithms or an untrusted native evaluation oracle.

`seed_exists` proves that there exist a positive finite dimension `n` and
an actual total Boolean function on `Fin n` such that:

* its all-zero value is false;
* its ordinary sensitivity is at most `seedA`;
* its block sensitivity at zero is at least `seedB`;
* it is nonconstant.

`infinite_family_161_80` proves the existence of a positive integer `N`,
a dimension sequence `n`, and total Boolean functions `F m` on `Fin (n m)`,
for every natural `m`, with `n m = N^m`, positive dimensions, zero value at
zero, nonconstancy, and

\[
 (s(F_m):\mathbb R)^{161/80}
 \le (\operatorname{bs}(F_m,0):\mathbb R).
\]

It also proves that the real-valued zero-input block sensitivity tends to
positive infinity as `m` tends to infinity. The formal theorem includes
`m=0` (the one-bit identity), and therefore implies the requested family
for every `m>=1`. The rational exponent is a `Real.rpow`, obtained from
the integer inequality by the positive 80th root, not natural-number
truncation of `161/80`.

## What this compilation does not establish

It does not prove a literature-wide novelty claim or a publication decision.
The exact comparison against the manuscript's *entire explicit parameter
family* is the separate integer-arithmetic argument in `verify.py` and
`REPORT.md`; the numerical location of that older family's optimum is not
used by the formal theorem.
The Jacobian calculation is an independently replayed exact scalar
recurrence calculation, not an external proof oracle.
The compiler checks none of these English fidelity explanations;
independent Reviewer assessment remains necessary.

The final source prints the axioms of the uniform theorem, actual-profile
theorem, seed-existence theorem, and infinite-family theorem. Only Lean's
standard logical foundations (`propext`, `Classical.choice`, `Quot.sound`)
are permitted; no `sorryAx`, additional axiom, or `native_decide` trust
assumption is authorized.
