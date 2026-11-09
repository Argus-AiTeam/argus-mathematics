# Statement fidelity: the normal-basis algebraic core

Claim: `C_K1_NORMAL_HYPERPLANE_CORE`.

This source formalizes universal linear algebra and finite-set assertions used
in the passage from `geom:all-bases` to `geom:log-differential`, and in the
constant-Y fiber. It is not a formalization of algebraic curves, analytic flows,
weighted Bezout, residues, ampleness, or the full interpolation theorem.

## Hyperplanes and tangent subspaces

`InterpolationAudit.tangent_in_hyperplane` quantifies over an arbitrary field
`K`, an arbitrary `K`-module `V` whose additive group is commutative, a linear
functional `ell : V -> K`, and a submodule `T`. Its only extra hypothesis is
that `ker ell + T` is a proper submodule of `V`. Its conclusion is
`T <= ker ell`. A nonzero-functional hypothesis is unnecessary: for the zero
functional, the properness hypothesis is impossible. Neither finite dimension
nor characteristic zero is assumed by this linear-algebra assertion.

## The actual logarithmic frame

The coordinate index type is `Option I`: `none` is the Y direction and
`some i` is the X_i direction. `I` is any type. For a field element `y`,
`logShear y` sends a coefficient vector `a` to the coordinate vector

    v_Y = y * a_0,       v_i = a_0 + a_i.

Thus its columns are exactly `D_0 = y e_0 + sum_i e_i` and `D_i = e_i`
when the index set is finite. `logUnshear y` has coordinate formulas

    a_0 = v_Y / y,       a_i = v_i - v_Y / y.

`logShear_add`, `logShear_smul`, `logUnshear_logShear`, and
`logShear_logUnshear` establish linearity and both inverse identities.
`logarithmicFrameEquiv` packages these into a linear equivalence, with the
explicit and essential hypothesis `y != 0`. In the manuscript this is the
open set `Y != 0`.

`logNormal y i` is the functional `v_i - v_Y/y`.
`tangent_logarithmic_relation` concludes `v_i = v_Y/y` for every vector of
`T`, assuming `ker(logNormal y i) + T` is proper. This is the pointwise
linear-algebra meaning of `dX_i = dY/Y` on the tangent space. The statement
does not assume or prove that this differential identity forces algebraic
coordinate constancy. That separate characteristic-zero residue argument
is proved in the mathematical report.

The identification of `ker(logNormal y i)` with the span of all frame
columns except `D_i`, and the extraction of a quotient basis from a spanning
family, are explained in the report. They are not encoded as additional
declarations here. In particular, this source does not silently assume that a
numerical matrix rank test establishes them in all dimensions.

## Separated normal-basis index sets

`wins A B` means that the largest element of the symmetric difference of
finite subsets `A,B` of the nonnegative integers belongs to `A` and is
positive. The symmetric difference is written `(A \\ B) union (B \\ A)`.

`largest_direction_forced` quantifies over arbitrary real-valued functions
`w,v`, an arbitrary real constant `C`, finite sets `A,B`, and an index `i>0`.
It assumes `i in A`, that every element of `A union B` is at most `i`, the
bound `prod_A w <= C prod_B v`, and the separation implication
`wins A B -> C prod_B v < prod_A w`. It concludes `i in B`.
The original positive rational weights are a special case. Positivity and
equal cardinality are needed to obtain the manuscript's separation hypotheses,
not for this contradiction once those hypotheses have been supplied.

`wins_total` says that two different finite sets of positive indices are
ordered by `wins` in one direction.
`unique_positive_basis_family` quantifies over a finite family `F` of finite
sets, all of whose indices are positive. If every ordered pair of members
satisfies the product bound and the separation implication, all members of
`F` are equal. The source does not manufacture basis existence or normal
independence: the family is supplied by the geometric argument. Empty families
give only a vacuous equality statement and are not used in that argument.

## What the compiler does not certify

The compiler checks these declarations, not their identification with analytic
or algebraic geometry. The complete manuscript hypotheses, the density
generalization, the branch and pole examples, and all external theorem
applications are separately stated in `../REPORT.md`. The independent Reviewer
must read this translation as well as replay the compiler and exact script.
