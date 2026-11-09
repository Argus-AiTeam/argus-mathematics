# Statement fidelity: conjugate Bockstein algebra

`Main.lean` formalizes the algebraic core of the argument in `argument.md`,
not Galois cohomology, Poitou--Tate duality, the construction of the
manuscript's finite models, or the full BSD formula.

All declarations are in `ConjugateBockstein`. R is an arbitrary
commutative ring, M is an arbitrary R-module with additive commutative
group, and e or b is an R-valued bilinear form. No assumption that 2 is
invertible, no domain assumption, and no finite sampling occurs.
`IsAlt` means zero diagonal, not just skew-symmetry.

`alt_swap` and `induced_diagonal` establish the sign and diagonal of the
induced coefficient form. `hmul_assoc` and `hmul_inv` check the indicated
central-extension law and inverse. `kernel_conjugation` gives the exact
central drift s B(v,y); `square_zero_kernel_mul` proves the additive
kernel law under the explicitly stated hypothesis s*s = 0.
`cLift_mul` and `cLift_involution` use an arbitrary linear C with
e(Ca,Cb) = -e(a,b), and, for the latter, C(Ca) = a. They do not assume C
can be diagonalized over a dyadic ring. `inertia_graph_fixed` verifies
the graph and its zero quadratic correction for d*u = 1. In the source,
e is valued in the Tate line; the chosen trivialization and the
anti-isometry hypothesis encode the action on that line for this
algebraic calculation.

`regular_scalar_cancel` assumes precisely that multiplication by s on R
has zero kernel. If s*r = s*s*k, it concludes r = s*k. Applied to
representatives, this is injectivity of multiplication by s from R/(s)
to R/(s*s). It does not assert injectivity at further Artin quotients.

`compact_boundary_from_defects` quantifies over arbitrary R-modules G2,
G3, L1, L2, their indicated linear differential and restriction maps,
and explicit cochain elements. Its three hypotheses are exactly the
global defect identity, the localized defect identity, and the residue
primitive identity derived in the argument. Its conclusion identifies
the full compact boundary, including the local component and its signs.
The map `compactD` is (g,l) -> (dG(g), loc(g)-dL(l)).

`compact_diagonal_vanishes` adds a linear trace annihilating those
boundaries, an injective scalar map j:A0 -> A2, a scalar t, and the
compatibility equation identifying the trace of the scalar-multiplied
cup with j(t). It proves t = 0. In the arithmetic application, A0 is
R/(s), A2 is R/(s*s), j is multiplication by s, and t is the compact
diagonal pairing. The theorem does not prove that arithmetic trace
compatibility: the argument obtains it from the explicitly cited,
Tate-modified compact invariant theorem. `local_primitive_leibniz`
checks the three-term primitive sign once the cup Leibniz identities
are supplied.

`hyperbolic_residual_orthogonal`, `hyperbolic_plane_pairing`, and
`hyperbolic_independent` prove the normalized hyperbolic splitting
identities for any alternating b and x,y with b(x,y)=1, over arbitrary
R. The projection is b(z,y)x-b(z,x)y. The Artin-module proof uses these
identities after normalizing a maximal-order pairing into R/(pi^a);
this normalization, induction on module length, Smith decomposition,
and the full DVR parity theorem are proved in prose, not encoded here.

`bockstein_radical_kernel` assumes a bilinear degree-one/degree-two
pairing P separating degree-two elements, a linear beta, and the
identity b(x,y)=P(x,beta(y)). Under alternation it proves that the
radical of b is exactly the kernel of beta. This is the radical step
of the parity proof, not an assertion that every skew pairing is
alternating.

The kernel therefore certifies these universal algebraic declarations
only. Source fidelity, the application to each local condition, the
finite-precision passage and the cited arithmetic input still require
independent mathematical review.
