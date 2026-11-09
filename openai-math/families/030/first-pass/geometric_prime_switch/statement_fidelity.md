# Statement fidelity: the algebraic core of the actual slit cover

The declarations are in namespace `GeometricPrimeSwitch`. This file describes
only the statements encoded in `Main.lean`; it does not claim that Lean
constructs the analytic Kummer cover or proves its identification with a
cellular surface. That identification, the common transport of the two
geometric bases, and the Betti--etale comparison are proved or explicitly
qualified in `report.md`.

## Integral cellular exactness

`prefix_difference`, `telescope`, and `cyclic_exact` quantify over every
additive commutative group `A`, every natural number `m`, and every sequence
of coefficients. Only indices `0,...,m-1` are used. They prove that a
zero-sum sequence is exactly a sequence of successive differences of a
potential with equal endpoints. The constructed potential starts at zero.
There is no hypothesis that multiplication by `m` is injective or invertible.

The surface complex in the report has cyclic edge differential
`D q_i = q_i - q_(i-1)`, with indices modulo `m`. To identify this with the
formal statement, put `q_i = p_(i+1)` for `0 <= i < m`. At index zero,
`q_(m-1) = p_m = p_0`, so the formulas agree also across the wraparound.
Conversely, periodic `q` gives endpoint potential `p_0 = q_(m-1)` and
`p_(i+1) = q_i`; subtracting a constant normalizes `p_0` to zero.

`IsBoundary` says that the two handle coordinates vanish and that the
remaining coordinate is such a periodic-endpoint difference.
`homology_coordinates` takes two cycles, explicitly assuming zero sum of
each remaining edge coordinate. It proves that their difference is a
boundary if and only if their two handle coordinates agree at every index
below `m`. Every pair of handle coordinates is a cycle by setting the
remaining coordinate to zero. Together these statements give the claimed
coefficient-uniform first homology of this particular chain complex.
They do not infer a topological chain model merely from a rank count.

## Vanishing-cycle algebra

`difference_composition` quantifies over any index type, any permutation
`s`, and any additive commutative coefficient group. The two opposite
differences compose to
`2*x_i - x_(s i) - x_(s^-1 i)`. Taking `s` to be the cyclic shift gives the
geometric adjacent-sheet Laplacian. This identity allows arbitrary
characteristic and torsion. `integral_shear_inverse` proves that adding this
Laplacian in the upper off-diagonal coordinate has the stated subtraction
inverse. A coordinate swap gives the lower version; that swap is not a
separate Lean declaration.

`laplace_factor` is the universal commutative-ring identity
`(1-u)(1-v)=2-u-v` under the sole relation `u*v=1`.
It does not assume a primitive character or invertibility of a group order.

## Character specialization and residual consequence

`residual_evaluation` quantifies over three commutative rings, two ring maps
`phi,psi : R -> S`, a ring map `rho : S -> k`, and an arbitrary matrix
`M : I -> J -> R`. Its hypothesis is equality of the two composite ring maps;
its conclusion is equality of the entrywise reduced matrices.
The rank-two lattice and its Galois action are not hypotheses hidden in this
declaration: they are constructed separately in the report. Once a basis of
that free group-ring module is chosen, this declaration applies to every
Galois-action matrix. Thus it proves the algebraic equality needed after
tensor evaluation, not the analytic or arithmetic realization of that module.

`prime_power_root_is_one` quantifies over every field `K`, prime `p`, natural
number `r`, and `z : K`. Under characteristic `p` and `z^(p^r)=1`, it proves
`z=1`. This is the residue-field statement, not a claim that such roots equal
one in the characteristic-zero coefficient ring.

`laplace_nonzero` assumes a field and a scalar `u` different from zero and
one. It proves `2-u-u^-1` is nonzero, including in positive characteristic.
`no_common_invariant_line` assumes two nonzero shear parameters `c,d`.
Its two determinant-zero hypotheses say that a vector `(x,y)` and each of
its upper/lower shear images are collinear. It concludes `x=y=0`.
Consequently no nonzero vector spans a line invariant under both shears.
The statement holds over any extension field as well; it does not assert
irreducibility on a trivial-character specialization.

No declaration in this source asserts modularity, verifies an automorphy
lifting theorem, establishes novelty, or proves the complete manuscript.
