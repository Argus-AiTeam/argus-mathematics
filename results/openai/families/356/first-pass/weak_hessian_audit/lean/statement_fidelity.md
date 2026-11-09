# Statement fidelity: weighted Bochner graph closure

This document describes precisely the declarations in `Main.lean`,
namespace `WeakHessianAudit`. It does not claim that Lean has formalized
Proposition `weight:variable-cd` or Theorem `weight:every-geodesic`.

## Functional-analytic declarations

`graphForm` has arbitrary real inner-product spaces H and E, arbitrary
bounded linear operators A:H->H, B:H->E, C:E->E, and vectors x:H, y:E.
It is

    (1/2)<Ax,x> + <y,Bx> + <Cy,y>.

`graphForm_continuous` proves continuity on H times E. No positivity,
symmetry, finite-dimensionality or completeness hypothesis is assumed.
`graphForm_nonneg_of_tendsto` quantifies over arbitrary sequences
x_n in H and y_n in E and limits x,y. Strong convergence of each
sequence and nonnegativity of the displayed form for every n imply
nonnegativity at the limits.

For the analytic application in report section 5, H is the real L2
tangent module, E is scalar L2(m_V), x=grad g, y=Lg. A is multiplication
by Lxi-2k xi, B maps x to its pairing with grad xi, and C is
multiplication by xi. The boundedness of these multipliers, existence
of these spaces/operators, the graph core and its relation to the
manuscript are established in prose, not in this Lean file. The form
is then exactly Q(g)-integral k xi Gamma(g) dm_V.

`energy_graph_tendsto` quantifies over arbitrary sequences u_n,l_n in E
converging strongly to zero and d_n in H, with
norm(d_n)^2 <= norm(u_n) norm(l_n) for every n. It proves d_n converges
strongly to zero. In the application these are g_n-g, L(g_n-g),
and grad(g_n-g). The identification uses the weighted energy identity,
which is not formalized here.

## Scalar declarations

`bochner_cancellation` is an identity for all real xi,d,b,c,r,u.
After the common factor exp(V) is removed, u=Gamma(xi,Gamma(g)/2),
d=Delta g, b=Gamma(V,g), c=Gamma(xi,g), and
r=Gamma(V,Gamma(g)/2). It verifies the expanded difference of the
weighted and unweighted Bochner integrands. It does not establish
integrability, the weak Hessian formula, or a curvature inequality.

`entropy_residual_identity` is an identity for all real
lam,At,A0,A1,Et,E0,E1,K,C,D,t. It verifies the sign reversal between
the weighted entropy residual and the rearranged F inequality after
multiplication by lam. Positivity of lam is required in the prose
when this identity is used to divide an inequality; it is not needed
for the polynomial identity itself.

`resolvent_contraction_arithmetic` proves 2 alpha+zeta<=1/2
assuming only alpha<=1/8 and zeta<=1/4. The application uses
alpha=B/sqrt(a), zeta=B sqrt(max(-K,0))/a. The heat estimates,
parameter bounds, Banach fixed-point argument and regularity
conclusion are not Lean declarations in this file.

The formal result is a load-bearing abstract closure lemma with
supporting scalar identities, not a formalization of RCD calculus,
the AGS/BHS equivalences, nonbranching, or entropy localization.
