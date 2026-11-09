# Statement fidelity: C9000347_SHARP22_CORE

This document describes the declarations in `research/sharp22/Main.lean`.
The source imports Mathlib and is intended for Lean 4.31.0. There are no
additional axioms, geometric oracle hypotheses, or assumed values of the
unit torsion profiles in the formal statement.

## Objects and definitions

`shiftCount r` is the number of blowup shifts for a center of complex
dimension `2+r` in complex dimension nine: `9-(2+r)-1`.
It is used only for `r=0,1,2`; natural subtraction therefore does not
truncate a negative geometric quantity in any claimed case.
`centerProfile r j` counts pairs of indices by an actual finite double
sum: shifts `k+1`, with `k<shiftCount r`, and projective-space homology
indices `l<r+1`, contribute when `k+1+l=j`.

`primary2 j = 2*2*centerProfile 1 j` records two centers per unit of
the parameter and two 2-primary generators per surface degree.
`primary3 j = 3*centerProfile 0 j + 2*centerProfile 2 j` records the
other two center types. Each is the multiplicity in ONE parity list,
with homological degrees `1+2j` or `2+2j`, not in a single combined
parity group.

`convC` and `convM` are the zero-padded convolutions with `(1,1)` and
`(1,6,1)`. The guards at `j=0` and `j<2` are part of the definitions;
natural truncated subtraction does not silently duplicate a boundary
term. `total n` sums indices `0,...,n-1`. The support lemmas justify
using `n=7,8,9` for the base, C, and M profiles, respectively.

`cGenerators` and `mGenerators` sum degreewise maxima in one parity
list, whereas `mCyclicGenerators` takes the maximum AFTER summing the
entire list. The argument `m : Nat` scales every primary multiplicity.
`bX` reconstructs the free rank from the three center dimensions,
their multiplicities, their free ranks `8*(r+1)`, and their blowup
shift counts; its constant term is `b(CP^9)=10`.

`lambdaC`, `lambdaM` and `betaCyclic` are numerical count functionals.
They multiply the one-parity torsion generator sum by two for the
two parity lists and again by two for the two generators needed for
each torsion invariant factor in a free complex.
The free ranks multiply `bX` by two and eight, respectively.
`fixedCount = 4*lambdaC` is the numerical four-component count,
not a definition of an actual Hamiltonian fixed-point set.

## Proved general statements

`convolution_difference` states linearity under subtraction of finite
integer-kernel convolutions on integer-indexed sequences, with no
positivity hypothesis.

`max_as_excess` identifies a pointwise maximum with the right-hand
entry plus the positive part of the difference, for arbitrary integers.

`sharpness_criterion` states, for every finite type and every pair of
natural-valued functions on it, that the sum of pointwise maxima equals
the sum of the second function if and only if the first function is
pointwise at most the second. It has no empirical or sampled-parameter
qualification. `max_scale`, `total_scale`, `convC_scale` and
`convM_scale` prove the homogeneity used for arbitrary `m`.

## Proved specialized statements and quantifiers

`centerProfile_zero`, `centerProfile_support`, `primary_support`,
`convC_support`, and `convM_support` establish the zero boundary and
upper support bounds. `primary_tables`, `convolution_tables` and
`unit_totals` are evaluated by Lean's kernel-checked `decide`, directly
from the finite-sum center definitions rather than from supplied tables.
`c_dominance` holds for ALL natural indices, including those outside
the finite support.

`bX_eq m` proves `bX m = 10+496*m` for every natural `m`.
`parametric_counts m` simultaneously proves, for EVERY natural `m`,

* `lambdaC m = 20+1328*m`;
* `fixedCount m = betaCyclic m = 80+5312*m`;
* `lambdaM m = 80+5344*m = fixedCount m+32*m`.

`strict_deficit m hm` assumes `1 <= m` and proves
`fixedCount m < lambdaM m`. The arithmetic also covers `m=0`;
the geometric theorem in `theorem.md` only asserts `m>=1`.

## What this formalization does not assert or check

No Lean object here is a complex manifold, a blowup, a homology group,
a Morse function, a symplectic form, a flow, or a fixed-point set.
The theorem does not prove that `max(a,q)` is the generator rank of
an abelian group; the elementary CRT and reduction-mod-prime proof is
in `theorem.md` and the integral presentations are replayed by
`verify.py`. The geometric identification of the numerical functionals
with actual homology, stable Morse number and Hamiltonian fixed points
is a separate assertion, supported by the complete prose proof and
the cited classical Morse-attainment theorem. Minimal Chern number,
nondegeneracy, contractibility, and projective realization are not
formalized. Compiler success must not be reported as a kernel proof
of those geometric claims or of novelty/publishability.
