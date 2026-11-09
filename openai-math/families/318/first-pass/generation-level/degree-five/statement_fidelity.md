# Statement fidelity: the degree-five algebraic core

The claim is C318DEG5FORMAL. The source is `Main.lean`, namespace
`DegreeFiveKernel`. It imports Mathlib but introduces no axioms or
topological assumptions.

`UpperBlock` has an arbitrary 2-by-2 matrix `kernel`, an arbitrary
two-coordinate `upper`, and an arbitrary scalar `quotient`, over an
arbitrary field K. These are precisely the seven coordinates of an
upper (2,1) block. The structure does not itself define multiplication.

`matrixFiveZero` quantifies over every alternating K-multilinear map
from five 2-by-2 matrices to K, and over every tuple of such matrices.
Its conclusion is that the value is zero. It uses dimension four,
not the false assertion that the five-dimensional Levi has no
degree-five cohomology. `scalarFiveZero` proves the analogous
statement for five scalar arguments.

`fullParabolicFiveZero` quantifies over both alternating forms and
every five-tuple of `UpperBlock` objects. The sum of the kernel-form
and quotient-form values is zero. No hypothesis restricts the two
upper coordinates, the quotient scalars, or their relation to the
kernel matrices. The human proof identifies the alternating trace
with exactly this sum by the diagonal-block multiplication formula;
the formal theorem does not prove that formula or construct the
trace forms. The separate exact script checks the formula on the
full parabolic matrix basis and evaluates all its alternating
five-wedges.

`reflectGeometricZero` quantifies over four arbitrary types with
zero, three maps, an injective base-change map, the three zero
preservation identities, a class and its coefficient image, and
their unit-square identity. If the geometric class is zero, its
final coefficient image is zero. The actual application is to
rational cohomology, after the human Witt and descent comparisons.

These declarations do not formalize Lie or group cohomology,
nonexactness of the source cocycle, a modification stack,
arithmetic equivariance, Witt-vector or Moore towers, spectra,
the scalar c, the fracture lift, or a generation level. Their
application hypotheses are proved in `proof.md`, not supplied
by the Lean compiler. In particular neither compilation nor the
finite certificate is a machine proof of level_G(X)=2.
