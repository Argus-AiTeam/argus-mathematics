# A sharp moving-wall criterion for the quaternionic determinant energy

## Result and scope

The October proposition `prop:energy-flux` follows from the actual current,
three-slot Hessian, and fiber equation. Its cofactor wall term is present in
Green's formula but vanishes because of a **common quaternionic tangential
null line**, not because the fiber is fixed or the full Hessian is positive.
The theorem below gives the omitted-in-general term, its sign, and an
if-and-only-if cancellation criterion in every dimension. It also supplies
noncharacteristic moving-fiber examples where that term is strictly positive.

This is a proof and a structural extension of one energy identity, not a
proof of local smoothing, an annular scale-uniform estimate, or the September
entropy argument. No false assertion in the staged manuscripts is established
by this work. The control examples below are NOT manuscript counterexamples.

## Conventions and elementary identities

There are `m=n+1` quaternionic indices, one parameter index and `n` spatial
indices. Each index has three real slots `(1,i,j)`. The real parameter triple
is `z=(T,Re tau,Im_k tau)`, and the spatial real coordinates may be periodic.
Use precisely

    G_a(v) = sum_alpha e_alpha partial_(a,alpha) v,
    H_ab(v) = sum_(alpha,beta) e_alpha conjugate(e_beta)
                                partial_(a,alpha) partial_(b,beta) v,
    A:B = Re tr(AB),
    A^R_(a alpha,b beta) = Re(conjugate(e_alpha) A_ab e_beta).

Thus `A:H(v)=A^R:D^2v` and `G(v)^*A G(v)` is the ordinary real quadratic
form of `A^R` on `grad v`. These statements follow coefficient by coefficient
from the cyclic real part of a quaternionic product; no extra factor of
three or four is allowed. The Hessian product rule is

    H(fg)=fH(g)+gH(f)+G(f)G(g)^*+G(g)G(f)^*.

For a Hermitian quaternionic matrix, `det` is the Moore determinant and `C`
its derivative under the displayed real trace pairing. We use:

    v^* C(K) v = det(K restricted to v^perp)             (|v|=1),
    d/dtheta det(K+theta L) = C(K+theta L):L,
    det [[ell,c^*],[c,D]] = det(D)(ell-c^*D^(-1)c)       (D>0).

These are valid for indefinite `K`. For completeness, diagonalize a Hermitian
form by successively maximizing its real quadratic form on the unit sphere
and restricting to the quaternionic orthogonal complement. Newton identities
make the product of its real eigenvalues a polynomial. On the positive cone,
the real representation has each eigenvalue four times, so differentiating
one fourth of its real log determinant gives `C(K)=det(K)K^(-1)`.
The rank-one update, restriction identity, and Schur identity follow there
by completing the square and then extend polynomially to arbitrary Hermitian
forms. Singularity of a Hermitian compression is equivalent to zero Moore
determinant. This argument uses finite-dimensional linear algebra, not a
positivity assertion about the full spacetime Hessian.

The cofactor of `H(v)` has divergence-free real columns in three slots.
Here is a dimension-independent proof, including singular Hessians. Polarize
the degree `m-1` cofactor into a symmetric multilinear expression `Q`.
On `m-1` rank-one inputs `g_j g_j^*`, its value kills each `g_j`:
for positive coefficients their sum is singular positive semidefinite,
its cofactor kills its image, and polynomiality extracts the coefficient.
For inputs `exp(xi_j dot x)`, put `(g_j)_a=sum_alpha e_alpha(xi_j)_(a alpha)`.
The row divergence of the polarized cofactor, after removing the exponential,
is `(sum_j g_j)^* Q=0`. A constant-coefficient multilinear differential
expression is determined by this polynomial symbol on arbitrary real
covectors. Hence it vanishes on all smooth inputs. Taking all inputs equal
proves cofactor divergence. The argument is unchanged with four slots.

## Theorem: exact defect and sharp cancellation criterion

Let a smooth total domain be `Omega={r<0}` over an open set of parameter
triples, with compact spatial fibers (periodic spatial directions are allowed).
Assume `grad_fib r !=0` on the lateral boundary, so fiber integration is
smooth under local identifications. All functions below are smooth on the
closed fibers and locally smoothly dependent on the parameters.

Let `lambda>0` be constant and suppose

    B=H(B0)>=0, det B=0,
    A>=0, div A^R=0, mu=A_00>0, A:B=0,
    u=0 on the lateral wall, u<=0,
    D=H_fib(B0+u)>0, det D=lambda mu.

Write `H(B0+u)=[[ell,c^*],[c,D]]`, `sigma=ell-c^*D^(-1)c`, and
`Sigma=H(B0+u)-sigma e_0e_0^*`. Define

    X(z) = integral_(Omega_z) (-u)mu,
    E(z) = lambda^(-1) integral_(Omega_z)
                      u integral_0^1 det H_fib(B0+theta u) dtheta,
    F=X+E,  rho=(u/r)|wall,  R=H(r),  nu=G(r)/|grad r|.

Then `Sigma>=0`, `rho>=0`, and the following smooth identity holds:

    Delta_z F + integral_(Omega_z) A:Sigma = W_A - D_wall,              (1)

where all normals are FULL spacetime normals, and

    W_A = integral rho G(r)^* A G(r) delta(r) d zeta,

    D_wall = lambda^(-1) integral rho |grad r|^2
             integral_0^1 det( B|nu^perp + theta rho R|nu^perp )
             dtheta delta(r) d zeta.                                (2)

The fiber measure here is Euclidean, and
`delta(r)d zeta=dS_fib/|grad_fib r|`. Formula (1) does not require `R>=0`.
If additionally `R>=0` at the wall, then `D_wall>=0`. At every wall point
where `rho>0`, its pointwise density is zero **if and only if**

    ker B intersect ker R intersect nu^perp != {0}.                   (3)

Consequently, a nonnegative full defining Hessian gives
`Delta_z F+integral A:Sigma <= W_A` even without a characteristic wall.
Under (3) the inequality is equality. All formulas and the criterion are
independent of dimension; no claim about dimension-independent analytic
comparison constants is intended.

### Proof

Completing the square gives `Sigma>=0`. The fiber equation and `A:B=0` give

    A:H(u) = A:Sigma + mu sigma
           = A:Sigma + lambda^(-1)det H(B0+u).                        (4)

For any Hermitian field `M` with conserved real columns, test with a smooth
`eta(z)` of compact support in parameter space. Only `H(eta)_00=Delta_z eta`
is nonzero. Apply real Green's formula on the TOTAL domain:

    integral_Omega u M_00 Delta_z eta
      = integral_Omega eta M:H(u)
        - integral_wall eta (nu^*M nu) partial_normal u.              (5)

The term containing `u grad eta` vanishes because `u=0` on the wall.
There are no parameter end terms or real-spatial boundary terms.
Smooth division by a defining function gives `u=r rho` at the wall and
`partial_normal u=rho |grad r|`. Nonpositivity of `u` gives `rho>=0`.
Using `dS=|grad r|delta(r) dz d zeta`, (5) with `M=A`, (4), and the minus
sign in `X` gives

    Delta_z X = W_A - integral A:Sigma
                      - lambda^(-1)integral det H(B0+u).             (6)

Next apply (5) to `M_theta=C(H(B0+theta u))`, whose columns are conserved
by the polynomial argument above. Its `00` entry is
`det H_fib(B0+theta u)`. Integrating its interior contraction over theta
gives `det H(B0+u)-det B`; the latter is zero by hypothesis. Thus

    Delta_z E = lambda^(-1)integral det H(B0+u) - D_wall.             (7)

At the wall the product rule gives, exactly,

    H(B0+theta u)
      = B+theta rho R
        +theta[G(r)G(rho)^*+G(rho)G(r)^*].

The last two terms disappear on QUATERNIONIC compression to `nu^perp`.
The cofactor restriction identity therefore gives (2). Adding (6) and
(7) proves (1), first distributionally and then smoothly.

For the sharp criterion, compress to `L=nu^perp`. Both `B_L` and `R_L`
are positive semidefinite. For every `t>0`,

    ker(B_L+tR_L)=ker B_L intersect ker R_L
                =ker B intersect ker R intersect L.

Indeed a zero quadratic form of a positive semidefinite Hermitian matrix
annihilates the vector, as is immediate in an orthonormal eigenbasis.
If the intersection is nonzero, every determinant in (2) vanishes.
If it is zero, every compression for `theta>0` is positive definite
when `rho>0`, so the theta integral is strictly positive. This proves both
directions of (3) and nonnegativity. The degenerate endpoint `theta=0`
costs nothing: the integrand is a polynomial and no endpoint inverse is used.

## Verification for the actual October construction

Use the manuscript's null auxiliary coordinates `(Y,P,S1)`, with

    W=P/Y,  Phi=S1+(P dot P)/(2Y),  D0=1+(W dot W)/2.

The dot here is BILINEAR over `C_k`. With `d=n-1`, the complex vector

    k=(1,W,-(W dot W)/2)                                            (8)

satisfies `dW(k)=0` and `dPhi(k)=0`: multiplying the first identity by
`Y` gives `W-W=0`, and the second is
`-(W dot W)/2+(W dot W)-(W dot W)/2=0`.
Its physical time component is `D0/sqrt(2)`.
Since `|W|<=w0=1/10`, `|D0-1|<=1/200` and that component is nonzero.
The inverse chart has
`Y=(sqrt(2)tau+aQ)/D0`, with `|aQ|<=a/10<s/10`, so `Y!=0`.

There is an independent all-dimensional invertibility calculation. At
fixed `sqrt(2)tau`, use `(P,Y)` as spatial coordinates, so
`Phi=Y-sqrt(2)tau+(P dot P)/(2Y)`. Multiplying the `dW` rows by `Y`
gives the spatial Jacobian

    [[I,-W],[W^t,1-(W dot W)/2]],

whose determinant is `D0`, by a block Schur calculation. This proves
invertibility for every `d`, not just the two-variable Jacobian replay.

Set `F_aux=(W/w0,10Phi/a)`, and let `J` be its full complex Jacobian.
The actual Hessian convention gives

    R=H(r)=4J^*J,  G(r)=2J^*F_aux i,
    B=H(lambda|Phi|^2)=4lambda (dPhi)^*(dPhi).

The complex rank of `J` is `n`; its quaternionic kernel is the line
generated by (8). It follows that

    Rk=Bk=0,  G(r)^*k=-2i F_aux^*Jk=0.

This is exactly (3), for the FULL gradient, at every wall point.
It also proves `H_fib(r)>0`, so it supplies the geometric hypothesis
of the periodic Dirichlet theorem. Notice that the full boundary Hessian
need not kill `k`: it can send it into the normal line. Only its
compression kills `k`; replacing this by full-Hessian singularity would
be an invalid shortcut. The Lean theorem `boundary_null_pairing`
formalizes this distinction in genuine quaternions and arbitrary dimension.

The actual wave current is not replaced by a scalar surrogate. To verify
its conservation, take the source fields
`Z_l=sum_a G_a(partial_(w_la)+i V_la)`, with
`V_la=sum_mu(C^mu w_l)_a partial_mu` and the real symmetric wave matrices
specified in `current.tex`. The chain rule gives `D_la conjugate(G)=0`,
`partial_(w_la)G=i V_la G`, and therefore
`div Z_l=2i w_l^t P G=0`.
Moreover

    nabla_(Z_l) conjugate(Z_m)
      = -i delta_lm sum_mu (G^t C^mu conjugate(G)) partial_mu

is purely imaginary. Thus the real tensor
`Re sum_l Z_l tensor conjugate(Z_l)` has conserved columns.
Pushing it forward as a density by the actual holomorphic quadratic map
`(R_source,zeta,eta)->(R_source^2,R_source zeta,eta-zeta dot zeta/2)`
preserves conservation: the only extra term is `B_source:D^2Theta`,
which is zero because the two diagonal state blocks coincide, the mixed
state block is zero, and each component of `Theta` is holomorphic.
The Jacobian is `4|R_source|^(2d+2)`. The transformed polarization is
`2R_source V^v`, with exactly
`V^v=(1,(v+W)/2,-W dot v/2)`. A common unit right rotation of the Gram
rows gives the manuscript's `iota_(Y/|Y|)(conjugate(u_mode))` and
`m_mode=(kappa/|Y|)^(d/2)exp(-kappa|Y||W-v|^2/2)`.
This verifies the actual `chi`, not just its positivity.

Also `(dPhi)V^v=0`, so `A^0=chi chi^*` annihilates the image of
`H(|Phi|^2)`. Spatial convolution preserves all these properties.
Multiplication by the actual cutoff `g(Phi/a)` preserves conservation
because its encoded gradient belongs to the same killed image.
Finally, `C(R)>=0` has image `ker R`, is conserved, and satisfies
`G(r)^*C(R)G(r)=0`. Its `TT` entry is `det H_fib(r)>0`.
Consequently the exact regularization
`A=g(Q)(J_h*A^0)+h^(50n)C(R)` is positive, conserved, has `mu>0`,
obeys `A:B=0`, and has `W_A=W_(A_w)`.

Ma--Zhu, arXiv:2611.03214v1, Theorem 1.1, Corollary 1.2 and Section 6,
provide a smooth Dirichlet solution and smooth parameter dependence.
Here `B_fib>=0` has rank one, `n>=2`, and
`lambda mu>det B_fib=0`. A large multiple of the strictly positive
defining Hessian supplies a subsolution. Section 6 also gives
`br<=u<=b'r`, with `b'>0`, so `u<=0` and `rho>=b'>0`.
This is a fixed-data analytic input, recorded as `MA_ZHU_PERIODIC`;
no uniform-in-wavelength constant is inferred from it.

All hypotheses of (1) now hold; (3) kills (2); the regularizer has zero
flux. Formula (1) is precisely the literal October `eq:energy-flux`.

## Strict noncharacteristic examples in every spatial dimension

This construction proves that the extra term in (1) is not redundant.
It is not the October fiber and hence is not a counterexample to the paper.
Take a spatial torus of volume one, `P in C^n`, `|tau|<1`, and

    r=|tau|^2+|P|^2-1,  u=r,  B0=0,
    A=diag(1,0,...,0),  mu=1,  lambda=4^n.

All hypotheses of (1) hold for every `n>=1`: `H(r)=4I`, `D=4I`,
`rho=1`, and the fibers are moving balls. Condition (3) fails because
`ker H(r)={0}`. Put `s=|tau|`, `L=1-s^2`, and `V_n=pi^n/n!`.
Direct radial integration gives

    F/V_n = n L^(n+1)/(n+1)^2,
    W_A/V_n = 4n s^2 L^(n-1),
    D_wall/V_n = 4n L^(n-1)/(n+1),
    Delta_z F/V_n = 4n L^(n-1)((n+1)s^2-1)/(n+1).

Thus (1) holds exactly and `D_wall>0` on every fiber. For `n=2,s=0`,
the normalized Laplacian is `-8/3`, the current flux is zero, and the
defect is `8/3`. At `n=2,s^2=1/4` these are respectively
`-1/2,3/2,2`. The current's SPATIAL-normal flux would be zero there:
the measured `3/2` is entirely a full moving-normal contribution.
The replay checks the symbolic formula for arbitrary integer `n`, not
just these rational examples.

## Prior result, comparison, and certification boundary

Ahag--Cegrell--Kolodziej--Pham--Zeriahi, arXiv:0804.3954v3, Theorem 3.1,
proves a complex slice-energy statement on a fixed product of bounded
hyperconvex domains, for a function in the Cegrell class `F(Omega x D)`.
The actual source and its hypotheses are archived in `literature/`.
That fixed-product theorem alone does not supply the moving quaternionic
boundary calculation above. The October manuscript explicitly recognizes
this limitation and does its own boundary calculation; its citation is
not refuted. Our proof does not invoke that complex theorem.

Relative to the strongest relevant prior statement in the staged manuscript,
the extension here is (1)--(3): the full defect on arbitrary smooth moving
fibers, a necessary-and-sufficient characteristic criterion for nonnegative
background and defining Hessians, and the resulting one-sided estimate
without a characteristic wall. The ball family makes the distinction strict
in every spatial dimension. Bibliographic novelty and publishable significance
remain matters for independent review, not consequences of the compiler.

`lean/Main.lean` establishes the ordered quaternionic null-pairing algebra,
the explicit holomorphic null vector, and the spatial-Jacobian determinant
for every finite index type. The separate fidelity document states exactly
which objects and hypotheses it encodes. The analytic integrations, Moore
cofactor calculus, and Ma--Zhu input are prose mathematics, not Lean-certified
PDE claims. `verify.py` additionally replays exact symbolic convention,
Schur/cofactor, actual-current interference, and general-dimensional ball
identities and checks the archived compiler result's freshness.

The October fixed-fiber bounds, logarithmic propagation estimate,
periodic-to-Euclidean transfer, full local-smoothing theorem, and every
September entropy obligation remain open in the campaign proof graph.
