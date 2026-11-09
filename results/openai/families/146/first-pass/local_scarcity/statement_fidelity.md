# Statement fidelity: C_FORMAL_ALGEBRA

The source `Main.lean` uses Mathlib over the real numbers and proves four
algebraic obligations of the analytic proof in `proof.md`. It does not encode
the standard map, an orbit, an analytic limiting argument, or a measure bound.
No compiler verdict on this file is a verdict on C_SCARCITY_EXT or
C_LOCAL_SCARCITY in their entirety. All declarations are in the namespace
LocalScarcity. The helper definitions `total8`, `minEdges`, and `maxEdges`
are respectively the sum of eight real arguments, the sum of their seven
adjacent minima, and the sum of their seven adjacent maxima.

`eighth_chain_exponent` quantifies over nine unrestricted real
numbers x0,...,x7,c. Each depth has the explicit hypothesis xi>=1, and c>=2/3.
There is no upper bound on the depths and no upper bound on c in this formal
statement. With A=sum of the seven adjacent minima, V=sum of adjacent maxima,
and T=sum of the eight depths, it proves

    -1+x0+x7+A-c*V-c*T <= 8-15*c-(T-8)/8.

These are exactly the exponent and bound for an expanded eighth-order Green
inverse chain whose eight derivative weights are all one. Section 2 of
`proof.md` proves the separate compression step: repeating depth d_i p_i times
increases the exponent by (1-c) sum((p_i-1)d_i) when c<1. That translation from
arbitrary positive weights summing to eight is not formalized here. Nor does
this declaration formalize Green functions, the inverse-derivative formula,
or the infinite geometric sums over sites. Its inequality is nevertheless
uniform over all real depths, not a finite-depth enumeration.

`alternating_quadratic` quantifies over arbitrary real a,b,c,d.
The four explicit homogeneous equations are the values of a quadratic
a*n^2+b*n+c plus alternating d at n=0,1,2,3. The conclusion sets all four
unknowns to zero. In Section 5 these are the values at four consecutive zeros
of the limiting cosine, after an invertible affine change of variable and a
nonzero scalar rescaling. That trigonometric and analytic translation is
proved in prose, not in this Lean declaration.

`uniform_error_margins` quantifies over real c and alpha, assuming
c>2/3 and 2*alpha<3*c-1. It proves that the three explicit error exponents
10-15*c, 2-3*c, and 1-3*c+2*alpha are negative. These are the normalized eighth
boundary remainder, normalized good-solution error in the opposite-cosine
case, and the general matched-scale success error, respectively. It does not
formalize estimates with unspecified constants or limits.

`degree_seven_cannot_be_eighth_power` quantifies over a polynomial
P over the reals. If its natural degree is at most seven, it is not the
polynomial X^8. This is the exact polynomial contradiction in the unbounded
eighth-order slow-remainder case; the passage from equality on positive measure
to polynomial equality is outside this formalization.

All definitions, hypotheses, and conclusions above are intended literally.
The compiler checks their proofs; the correspondence to the analytic argument
and this document's reading require independent human review.
