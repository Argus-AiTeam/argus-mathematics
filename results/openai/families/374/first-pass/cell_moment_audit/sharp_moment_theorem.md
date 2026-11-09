# Sharp mass-to-moment contraction for affine cells

## Scope and comparison

The source is normalized Lebesgue measure on a full-dimensional compact convex
body K in Euclidean space, with K contained in the closed ball of radius R
about the origin. Sites are distinct. All cell masses appearing in a
denominator are strictly positive. There is no lower bound on those masses
and no lower bound on site separation. Intercept directions are arbitrary.

The staged manuscript, `sections/moments.tex`, Lemma `moments:derivative`,
claims the squared derivative estimate with constant 162.
Its Lemma `moments:midpoint` is a known midpoint-density statement, not a
novelty claim: the manuscript cites McCann (1997), Theorem 2.3, and also gives
a triangular conditional-quantile proof. The latter proof, rather than an
unchecked use of the external theorem, is the analytic route examined here.
The cell differential formulas and qualitative Laplacian range statement are
in `sections/cells.tex`, Proposition `cells:calculus`. They must be justified
independently, not assumed as a quantitative inverse estimate.

A targeted literature lookup located and opened Delalande--Merigot,
arXiv:2103.05934v2 (8 March 2023), including its Introduction,
"Contributions," and Theorem 2.1:
https://arxiv.org/html/2103.05934v2 .
The stated potential estimate in that introduction has modulus
W1^(1/2); it is not the finite moment inequality below and does not
preclude W2-Lipschitz potential stability. Search-generated claims to the
contrary are not evidence and are not used. No specialized external
transport theorem is an undischarged assumption of this proof. Ordinary
Lebesgue integration, finite-dimensional linear algebra, and the C1
implicit-function theorem are used as standard analytic foundations.
Literature-wide novelty remains subject to independent review; the precise
improvement over the staged manuscript is 162 to the optimal constant 1,
together with a finite two-intercept strengthening. The resulting potential
constant is 2R instead of the manuscript's (1+sqrt(162))R.

## 1. Sharp finite comparison

For two intercept vectors c- and c+ with the same distinct sites, write
a_i and b_i for their positive cell masses, B_i- and B_i+ for their
unnormalized first moments, and h_i = (a_i+b_i)/2. The finite
contraction is

    sum_i |B_i- - B_i+|^2 / h_i
      <= R^2 sum_i (a_i-b_i)^2 / h_i.                       (1)

This is a theorem for every pair of intercepts with positive endpoint
masses, not a finite numerical experiment. Its derivative limit gives
the manuscript's assertion with the stronger constant 1. This constant
is optimal, even with two sites. The corresponding fixed-mass duality
argument gives an intercept-speed bound with constant R and a finite-target
potential bound with constant 2R.

There is a structural extension. Suppose two labelled partitions
(U_i) and (V_i) of K have positive-volume compact convex cells. Assume
there are measurable sets W_i in K with pairwise volume-null overlaps
and (U_i+V_i)/2 contained in W_i. Then (1) holds for their masses and
moments too. No affine representation is required for this extension.

### 1.1 The midpoint-density input, with its analytic hypotheses

We first prove the needed coupling, rather than invoke a displacement
interpolation theorem with unchecked hypotheses.

Let U be a positive-volume compact convex set in R^d. It has nonempty
interior and volume-null boundary. For the latter assertion, contract U
toward an interior point by factors increasing to one: every proper
contraction lies in the interior, and its volume tends to |U|. The same
argument works for relative volume in every affine subspace.

If an affine slice A meets int U, the relative interior of U intersect A
is int U intersect A. To see the nontrivial inclusion, join a relative
interior point z to a fixed ambient interior point p in A, and extend
the segment past z within the slice; z is a strict convex combination
of p and the extended point. Thus the slice's intersection with
the ambient boundary is slice-null.

For k<d, let p_k(xi) be the (d-k)-dimensional volume of the fiber
of int U over the first k coordinates xi; set p_0=|U| and
p_d=1_(int U). On D_k, the projection of int U to its first k
coordinates, p_k is positive and continuous. Indeed, at a prefix in
D_k the preceding slice-null statement makes the fiber indicators
converge almost everywhere under prefix convergence. A fixed enclosing
box supplies an integrable dominating function. All these fiber
integrals are Borel on their full domains.

Starting with s in (0,1)^d, recursively choose X_k(s_1,...,s_k)
as the s_k-quantile of

    t -> p_k(X_1,...,X_(k-1),t)/p_(k-1)(X_1,...,X_(k-1)).

The conditional support is a bounded open interval. Its density is
positive and continuous there and integrates to one, so the inverse
CDF is uniquely defined and C1 in s_k, with

    dX_k/ds_k = p_(k-1)(X_1,...,X_(k-1))/p_k(X_1,...,X_k) > 0.

The CDFs are jointly Borel, and inverse-CDF comparisons at rational
points give measurable quantiles. Iterated conditioning shows that
X has the uniform law on U. The product of its diagonal derivatives
is |U|. Carry out the same construction for V on the same cube,
obtaining Z and product |V|.

The map H=(X+Z)/2 is triangular and strictly increasing C1 in its own
coordinate. Coordinatewise arithmetic-geometric mean gives

    product_k dH_k/ds_k >= sqrt(|U||V|).

Here no differentiability in earlier parameters is claimed or needed.
For any nonnegative Borel f, substitute the last coordinate first,
enlarge its image interval to the whole line, and repeat backwards.
Tonelli's theorem justifies the successive substitutions, since each
earlier derivative depends only on earlier parameters. Consequently

    integral_cube f(H) product_k dH_k/ds_k <= integral_R^d f(x) dx.

It follows that Law(H) <= dx/sqrt(|U||V|), as measures. In particular,
neither smooth boundary nor strict convexity nor a uniform bound on
the quantile derivatives is being assumed.

For the affine cells U_i=P_i(c-), V_i=P_i(c+), averaging each pair
of defining inequalities puts (U_i+V_i)/2 in
W_i=P_i((c-+c+)/2). Convexity keeps the midpoint in K.
Distinct sites make the overlaps of the W_i null: they are contained
in finitely many proper equality hyperplanes.

Choose the preceding coupling separately for each i. Write
X_i,Z_i for its endpoint variables, H_i=(X_i+Z_i)/2, and
g_i=sqrt(a_i b_i). Since |U_i|=|K|a_i and |V_i|=|K|b_i,

    g_i Law(H_i) <= rho restricted to W_i,
    sum_i g_i E Phi(H_i) <= integral_K Phi d rho,             (2)

where Phi(x)=R^2-|x|^2 is nonnegative on K. Also both endpoint
partitions give

    sum_i a_i E Phi(X_i) = sum_i b_i E Phi(Z_i)
                        = integral_K Phi d rho.              (3)

The same argument proves (2)--(3) for the stated midpoint-compatible
partition extension.

### 1.2 The exact cancellation

For positive a,b, set h=(a+b)/2 and delta=a-b. For arbitrary vectors
x,z and Phi(x)=R^2-|x|^2, direct expansion gives the identity

    |a x-b z|^2/h + 2a Phi(x) + 2b Phi(z)
      - (4ab/h) Phi((x+z)/2) = (delta^2/h) R^2.              (4)

This holds in every real inner-product space. It is not an
inequality obtained by separately bounding changes of centroids.
Because h>=g=sqrt(ab), we have ab/h=g^2/h<=g. With the midpoint
in K, (4) therefore implies

    E|a_i X_i-b_i Z_i|^2/h_i
      <= R^2 delta_i^2/h_i
         -2a_i E Phi(X_i)-2b_i E Phi(Z_i)
         +4g_i E Phi(H_i).                                  (5)

Summing (5), equations (2)--(3) cancel all the Phi terms with the
correct sign. Finally,

    |B_i- - B_i+|^2
      = |E(a_i X_i-b_i Z_i)|^2
      <= E|a_i X_i-b_i Z_i|^2

by the squared-norm Jensen inequality. This proves (1).
All random variables are bounded, so all expectations above are finite.

More precisely, the difference between the right and left sides of (1)
is the sum of three nonnegative defects:

    sum_i [E|a_i X_i-b_i Z_i|^2
                     - |E(a_i X_i-b_i Z_i)|^2]/h_i
    + 4 sum_i [g_i-a_i*b_i/h_i] E Phi(H_i)
    + 4 [integral_K Phi d rho - sum_i g_i E Phi(H_i)],         (6)

This also exposes the cancellation lost by the manuscript's
separate triangle and Young inequalities.

## 2. Cell calculus and the derivative limit

The facts used to take the limit can be justified without any
regularity hypothesis on the boundary of K.

For every positive-mass cell choose a strictly active point in int K:
remove the null boundary and all equality hyperplanes. Strictly active
points of i and j give opposite signs of their affine difference, so
each equality hyperplane H_ij meets int K. Hence its intersection
with the boundary of K is surface-null by the slice argument above.
Moreover H_ij and H_ik cannot coincide for distinct i,j,k. Otherwise
the three affine functions would be collinear in the space of affine
functions, with one a strict convex combination of the other two;
that index could not have a strictly active point. Triple equality
sets therefore have codimension at least two.

For a continuous test function f, integrate f/|K| times the product of
the cell's halfspace indicators. Under a perturbation h(r,v),
telescope the difference of this product one indicator at a time.
The changed factor is supported in a slab of width O(|h|) about
H_ij. In coordinates x=z+h t n_ij with z in H_ij and
n_ij=(y_i-y_j)/|y_i-y_j|, the factor h in the volume cancels the
difference quotient. On a common bounded integration region,
outside the surface-null boundary and triple equality sets, the
remaining indicators converge. Integrating the changed indicator
in t gives

    [r_i-r_j+z dot (v_i-v_j)]/|y_i-y_j|.

Dominated convergence, applied also to the opposite direction,
therefore gives

    D I_i^f[r,v] =
      (1/|K|) sum_(j != i) integral_Fij
        f(z) [r_i-r_j+z dot (v_i-v_j)]/|y_i-y_j| dS.          (7)

The same argument identifies a nearby equality plane with an affine
graph over the fixed one. Its graph and surface Jacobian converge
uniformly on the bounded integration region. Almost-everywhere
convergence of the face indicators gives continuity of all coefficients
in (7), including the quadratic-coordinate integrals needed for B_i.
The distinct-site positive-mass locus is open, by continuity of the
cell integrals away from tie hyperplanes. Thus masses and moments are
jointly C1 there. Taking f=1 and the coordinate functions yields
exactly the manuscript's mass and moment formulas, with the displayed
positive sign.

At a fixed admissible configuration and arbitrary q, apply (1) at
c-sq and c+sq. For sufficiently small s both endpoint masses are
positive. The denominator h_i(s) tends to M_i>0. Divide by 4s^2
and use (7):

    sum_i |DB_i[q,0]|^2/M_i
      <= R^2 sum_i |DM_i[q,0]|^2/M_i.                        (8)

Only a limit for the fixed finite configuration and direction is
required. The allowed size of s may depend on the smallest mass,
on all site separations, and on q. None of these enter (8).
In particular (8) proves the literal assertion with 162 and improves it.

### 2.1 Sharpness, including small cells in dimension at least two

Let d>=2 and 0<epsilon<1. Take

    K_epsilon=[-1,1] times [-epsilon,epsilon]^(d-1),
    R^2=1+(d-1)epsilon^2,
    y_1=-e_1, y_2=e_1, c_1=t, c_2=-t, t=1-epsilon,
    q=(1,-1).

Every hypothesis holds, including full dimension and positive masses.
The interface is x_1=t; the masses are (1+t)/2 and (1-t)/2.
The mass derivatives are 1/2 and -1/2, and the moment derivatives
are t e_1/2 and -t e_1/2. Their normalized energy ratio is exactly

    (1-epsilon)^2/[1+(d-1)epsilon^2] -> 1.                  (9)

Thus no constant less than 1 can replace the coefficient in (8).
There are rational admissible examples arbitrarily close to 1.
Scaling both sites and intercepts by any positive lambda leaves
these cells unchanged and permits arbitrarily close distinct sites.
Using q=(lambda,-lambda) leaves the displayed derivatives unchanged;
using an unscaled direction scales both energies by lambda^(-2).

Sharpness also holds on each fixed unit Euclidean ball: its section
x_1=t has centroid t e_1 by symmetry and positive surface measure for
|t|<1. Formula (7) again gives DB_i=t e_1 DM_i, so the ratio is t^2
and tends to 1 as t increases to 1. This argument needs no explicit
formula for cap volumes.

## 3. Qualitative range and prescribed masses

Put g_ij=area(F_ij)/(|K||y_i-y_j|) and
b_ij=(integral_Fij x dS)/(|K||y_i-y_j|), with zeros on the diagonal.
Both are symmetric, and

    (Gq)_i = sum_j g_ij(q_i-q_j),
    (Bq)_i = sum_j b_ij(q_i-q_j).                            (10)

The positive-face graph is connected. Choose strictly active interior
points in two cells, with the first outside all equality planes and
the second outside their finitely many equality planes and the affine
spans of the first point with every triple equality set. These forbidden
sets are proper affine sets. Their connecting segment stays in int K
and encounters no triple equality. At an active-index change it crosses
a relatively open piece of exactly one common face; this supplies an
edge of positive surface measure. The successive indices give a graph path.

Consequently q dot Gq=sum_(i<j) g_ij(q_i-q_j)^2, so the kernel
consists of constants. Symmetry gives range G={z:sum_i z_i=0}.
This is only a qualitative range statement, with no bound on a solution q.
For N=1 both assertions have the expected zero-dimensional interpretation.

For completeness, prescribed positive masses m_i summing to one have
unique intercepts normalized by sum_i m_i c_i=0. Minimize

    F_y(c)=integral_K max_i(x dot y_i+c_i) d rho - sum_i m_i c_i

on this normalization space. If S=max_i|y_i|, then
F_y(c)>=max_i c_i-RS. Boundedness of max_i c_i and the weighted
zero mean bound every coordinate below as well, so F_y is coercive
on the normalization space. It attains a minimum. Distinct sites give
an almost-everywhere unique active index for every c; bounded difference
quotients show the gradient is M-m. At a constrained minimum this
gradient is parallel to m and has coordinate sum zero, hence is zero.

At a solution all cells have positive masses. By the range statement,
G maps {c:sum_i m_i c_i=0} isomorphically to the zero-sum subspace.
The C1 implicit-function theorem gives a locally unique C1 branch in
the sites. If there were two normalized solutions, convexity of F_y
would make their whole segment minimizers, contradicting local isolation.
Thus the branches agree and the normalized intercepts are globally
unique and C1 wherever the sites are distinct.

## 4. Application to finite-target potentials

Let an optimal finite coupling of mu and nu, after deleting zero weights
and merging identical pairs, be

    pi=sum_i m_i delta_(y_i^0,y_i^1), m_i>0, sum_i m_i=1.

Existence follows by minimizing a continuous linear cost on the finite
coupling polytope. Write v_i=y_i^1-y_i^0, y_i(t)=(1-t)y_i^0+t y_i^1,
and w^2=sum_i m_i|v_i|^2=W2(mu,nu)^2.
Swapping equal positive portions between two pairs proves
(y_i^0-y_j^0) dot (y_i^1-y_j^1)>=0; otherwise quadratic cost decreases.
Since the endpoint pairs are distinct, this inequality implies that
y_i(t) are distinct for 0<t<1.

Use the preceding prescribed-mass result to choose C1 intercepts c_i(t)
with cell masses m_i and sum_i m_i c_i(t)=0. Put r_i=c_i'(t).
Then sum_i m_i r_i=0. Differentiating the mass constraints, testing
with arbitrary q, and exchanging symmetric double sums gives

    sum_i r_i (Gq)_i = -sum_i v_i dot (Bq)_i.                (11)

For clarity, the mass term is
sum_(i<j)g_ij(q_i-q_j)(r_i-r_j). The site term is
sum_(i<j)(q_i-q_j)b_ij dot(v_i-v_j), which equals
sum_i v_i dot(Bq)_i. Thus the sign in (11) is forced by the
fixed-mass equation; it is not an orientation convention.

The zero-sum range permits q with (Gq)_i=m_i r_i. Let
E=sum_i m_i r_i^2. By weighted Cauchy--Schwarz and (8),

    E^2 <= [sum_i m_i|v_i|^2] [sum_i |(Bq)_i|^2/m_i]
        <= R^2 w^2 E.

If E=0 the bound is immediate; otherwise divide by E. In either case,

    sum_i m_i r_i^2 <= R^2 w^2.                              (12)

Only existence of q was used; its size is irrelevant.

Define u_t(x)=max_i(x dot y_i(t)+c_i(t)). On compact interior time
intervals it is uniformly Lipschitz in t for x in K. Away from the
null tie hyperplanes its derivative is x dot v_i+r_i on cell i.
Fubini identifies this derivative for almost every (t,x). Minkowski
and the cell masses m_i yield

    ||partial_t u_t||_L2(rho) <= Rw+sqrt(E) <= 2Rw.

The fundamental theorem of calculus and Minkowski therefore give
||u_t-u_s||_L2(rho)<=2Rw|t-s| for interior times.

By (12), each |c_i'(t)|<=Rw/sqrt(m_i). Thus every intercept has finite
endpoint limits and the finite maxima converge uniformly on K.
The same L2 bound holds at the endpoints. All slopes remain in
B(0,L), so the endpoint maxima are convex and globally L-Lipschitz.

To identify endpoint maps despite colliding sites, retain only the
largest intercept for each repeated endpoint slope. Outside the finitely
many hyperplanes between distinct remaining slopes, the maximizing slope
is unique. Any subsequence of interior maximizing indices has an
endpoint maximizing slope, by uniform convergence and finiteness of
the index set. Consequently the interior slopes converge to the unique
endpoint slope at almost every x. Bounded convergence against continuous
tests identifies its law with mu or nu.

Finally optimality and uniqueness need no external transport theorem:
if u=max_y(x dot y+c_y) with distinct retained slopes, every coupling
to its slope law obeys

    integral x dot y d pi <= integral u d rho - sum_y mu_y c_y.

The active-slope map attains equality. Any optimizer must attain equality
almost everywhere, and a distinct active slope is unique outside a
source-null union of hyperplanes. This proves that the endpoint gradients
are exactly the unique quadratic optimal maps. Hence

    ||u_0-u_1||_L2(rho) <= 2R W2(mu,nu).                     (13)

This settles the use in `finite:potentials`. It does not purport to
reaudit the manuscript's separate convex-gradient interpolation theorem.

## 5. What the certificates establish

`Main.lean`, with the reading in `statement_fidelity.md`, formalizes the
full finite-dimensional vector energy argument and symmetric face
duality/weighted intercept-energy transfer. It is deliberately not an
end-to-end formalization of Lebesgue integration, the quantile construction,
or the cell-differentiation and endpoint arguments above.

`verify.py` independently checks the exact symbolic identities, rational
two-dimensional cell geometry and face derivatives (including very small
positive cells and nearly coincident sites), and the sharpness formulas.
Those finite examples are regression checks, not a proof of universal
quantifiers. The universal proof is Sections 1--4, with its algebraic core
separately compiled in Lean.

No false assertion of the staged manuscript has been established here.
In particular, improving a valid constant 162 is not a refutation, and
does not justify inventing an F_<LABEL> claim.

The deterministic certificate replay is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  research/cell_moment_audit/verify.py
```

The actual compiler invocation that recorded C374_CORE is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/cell_moment_audit/Main.lean \
  --statement-fidelity research/cell_moment_audit/statement_fidelity.md \
  --claim C374_CORE --project-root .
```

The recorded result has exit_code=0, audit_exit_code=0, proof_holes=[],
and matches the current source and fidelity text. Independent review of
the analytic proof, statement fidelity, significance, and novelty is still
required; neither the script nor the Engineer supplies that verdict.
