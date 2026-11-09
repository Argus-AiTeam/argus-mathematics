# Statement fidelity

## What the formal source proves

`Main.lean` imports the installed Mathlib and uses Lean 4.31.0.
All declarations are in `FibreComparison`.

`transport_identity` quantifies over an arbitrary monoid `M`, three
units `P,H,D`, and four arbitrary elements `A,B,C,E`. Its three hypotheses
are exactly `P*A=C*P`, `C*H=H*E`, and `D*B=E*D`. Its conclusion is
`A*(P^-1*H*D)=(P^-1*H*D)*B`. The inverse belongs to the unit `P`;
there is no commutativity assumption and no reversal of the intertwiner.

`parameter_cancellation` applies this result to arbitrary indexed
families `A,B,C` and an arbitrary reparametrization `sigma`. Both
transport equations use the same `sigma`. The conclusion uses the
original `A(t),B(t)`, not `B(sigma(t))`. There is no assumption that
`sigma` is surjective, injective, or scalar multiplication.

`formal_polynomial_separation` concerns two polynomials in the group
parameter with coefficients in a one-variable power-series ring over
an arbitrary commutative ring. Equality of every power-series
coefficient of order less than every jet order, for every polynomial
coefficient, implies equality of the polynomials. Polynomial type
ensures finite group-parameter support; the statement is not about
equality of polynomial functions on a finite field.

`exists_nonsingular_combination` quantifies over any infinite field `k`,
any field `K`, any ring homomorphism `k -> K`, arbitrary finite matrix
index type `n`, and any finite family of `k`-matrices `S`. If a
`K`-linear combination of their mapped matrices has nonzero
determinant, some `k`-linear combination has nonzero determinant.
The determinant polynomial and its specialization are proved in the
source, rather than supplied as hypotheses.

`coordinates_intertwine` applies an arbitrary `k`-linear coordinate
map `K -> k` to a matrix intertwining scalar-extended `k`-matrices.
`finite_coordinate_expansion` proves that every finite matrix over `K`
is a finite `K`-linear combination of its `k`-valued coordinate
matrices, using an arbitrary vector-space basis of `K/k`.
No finite-degree, algebraicity, separability, or chosen basis
decomposition is assumed.

`descend_intertwiner` quantifies over an arbitrary infinite field `k`,
an arbitrary field extension `K/k`, arbitrary finite matrix index type
`n`, and an arbitrary index type `I` for simultaneous equations.
Given `A,B : I -> Matrix n n k` and a matrix `F` over `K` with nonzero
determinant intertwining *all* mapped `A(i),B(i)`, it concludes that
there is a matrix `F0` over `k`, of nonzero determinant, intertwining
all the original `A(i),B(i)`. `I` is not assumed finite. Neither a
base-change identity for a kernel nor a spanning family of
intertwiners is assumed: the coordinate expansion proves what is
needed. Over a field, nonzero determinant is equivalent to an
invertible matrix. Empty matrix index types are included.

`comparison_over_extension` combines transport and descent. It has
the same field, extension, size, and equation-index quantifiers as
`descend_intertwiner`, arbitrary `K`-matrix families `C,E`, and units
`P,H,D` over `K`. For every index its hypotheses are exactly
`P*A_K=C*P`, `C*H=H*E`, and `D*B_K=E*D`. It concludes the existence
of a nonsingular `k`-matrix intertwining every original `A,B`.
It does not assume the existence of the sought `k`-intertwiner.

## Application to the manuscript

Take `K=k((x))`. For the action polynomials `A(t)=C(1,t)` and `B(t)`,
take `I` to be all nonnegative coefficient degrees in `t` and `n` to
index a basis of the fibres. Let `C_i` be the coefficient matrices of
`C(x,x^2*t)` and `E_i` those of `B(x^2*t)`. The manuscript's two
torus transports are `P=b_h` and `D=rho_T(h)`, with
`h=diag(x,x^-1)`. The gauge `H` is the formal isomorphism constructed
by the compatible jet splittings, embedded into `K`.

`formal_polynomial_separation`, applied entrywise, makes jet
equivariance an identity in `k[[x]][t]`. Substitution `t -> x^2*t`
and coefficient comparison give the `hH` hypotheses.
The bundle and representation transports give `hP` and `hD`.
The output intertwines every original action coefficient, so it
intertwines the original rational group scheme over every
commutative `k`-algebra, not just its `k`-points. The parameter and
any fixed subgroup embedding are unchanged.

## Deliberate limits

Lean does not encode algebraic groups, the category of rational
representations, vector bundles, tilting filtrations, Ext groups,
jet splittings, or their inverse limit in this file. In particular
it does not assert that a formal gauge exists for an arbitrary
bundle or that a formal isomorphism algebraizes. Those geometric
steps are proved in `proof.md`, using the separately cited
standard--costandard Ext theorem. The literal geometric lemma has
its own ledger claim `C_FORMAL_COMPARE`; the compiler is attached
only to the universal algebraic claim `C_COMPARE_ALGEBRA`.

This is an independent formal certification of the stated core, not
a claim that the already known finite BEO theorem is new. Statement
fidelity and the geometric application still require the
Host-invoked independent Reviewer.
