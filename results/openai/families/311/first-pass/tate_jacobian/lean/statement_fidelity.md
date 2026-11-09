# Statement fidelity for L_TATE_RANK9000311

`Main.lean` formalizes algebraic cores of the finite-level proof in
`research/tate_jacobian/report.md`. It does not formalize p-divisible groups,
their deformation functors, a Tate-module construction, analytic convergence,
or the application of the cited literature. In particular a successful
compilation is not a kernel proof of `C_TATE9000311`.

All five declarations are in namespace `TateJacobian`.

## Frobenius and linearized p-series

`frobenius_ignores_square_zero` quantifies over every commutative ring R,
every natural prime p with characteristic-p instance, and a,b in R.
Its only nilpotence hypothesis is b^2=0, and its conclusion is
(a+b)^p=a^p. In the application b is any infinitesimal coordinate.
The statement does not require that Frobenius fix a; C is perfect but
not the prime field.

`linearized_inseparable_polynomial` quantifies over every such R and p,
an arbitrary index type and finite set S, coefficient functions a,b,
nonnegative exponent multipliers k, and elements e,t,s with e^2=0.
It proves exactly

    sum_(i in S) (a_i+e*b_i)*(t+e*s)^(p*k_i)
      = sum_(i in S) a_i*t^(p*k_i)
        + e*sum_(i in S) b_i*t^(p*k_i).

Thus varying the input coordinate has no first-order contribution to a
p-inseparable polynomial; the sign of the coefficient variation is positive.
Exponents divisible by q=p^h, h>=1, are a special case. There is no
claim here about infinite series: passage to analytic limits is justified
separately by the Tate-algebra estimates in the report.

## Descent core

`section_of_kernel_annihilation` quantifies over arbitrary additive
commutative groups E1,E2,G, homomorphisms P:E1->E2, pi:G->E2 and
W:E1->G, and the hypotheses that P is surjective, ker(P) is contained
in ker(W), and pi composed with W equals P. It concludes the existence
of exactly one homomorphism s:E2->G with s composed with P equal to W
and pi composed with s the identity. It assumes no section of pi.

This is the additive-group universal-quotient calculation underlying
Verschiebung descent. Applying that calculation to an epimorphism of
fppf sheaves is an ordinary sheaf-theoretic argument in the report, not
an encoded identification of sheaves with their A-valued points.
Surjectivity on arbitrary A-valued points of a p-divisible group is
neither assumed nor claimed in the geometric application.

## Rank cores

`etale_block_det_ne_zero` quantifies over every field K and every pair
of natural dimensions a,r, including zero dimensions. L is a linear
endomorphism of K^a times K^r and is assumed injective. For a square
r-by-r matrix M, the connected component of L(0,v) is assumed zero
and its etale component is assumed M*v, for every v. The conclusion
is det(M)!=0. There is no hypothesis on the rank or determinant of M.

`det_ne_zero_from_trivial_deformation` is the form actually used by
the report. It quantifies over every field K, K-module V, dimensions
a,r, injective comparison KS:K^a times K^r -> V, and square matrix M.
Its geometric input is the explicit hypothesis

    for every v, M*v=0 implies KS(0,v)=0.

It concludes det(M)!=0. Here a=h-1 and r=n-h. The report proves that
hypothesis using genuine finite p-torsion points, Frobenius--Verschiebung
descent, and connected height rigidity. Lean does not prove those
geometric facts or the injectivity of the actual Kodaira--Spencer map;
they are not concealed as a formalized full-rank theorem.

The kernel checks these universally quantified algebraic implications,
not any particular finite collection of numerical Jacobians. The
external mathematical assumptions of the overall theorem are listed
in the report and the exact certificate, and require independent review.
