# Reciprocal Green kernels: universal verification and a measure extension

## Result and scope

**Theorem A.** The assertion `thm:negative-kernel` in the staged manuscript is
true under its stated hypotheses. In particular, boundedness of the density,
nonnegativity, and the strict form bound are sufficient; one need not assume
that a boundary Poisson section belongs to the weighted L2 space.

The proof below checks the regularization, finite update, continuum
resolvent, radial boundary limit, and exhaustion by compact subpotentials.
It is a universal analytic proof, not an inference from numerical samples.
The universal Schur-series step in the finite update is additionally proved
in Lean 4.31.0 in `lean/Main.lean`. The compiler does **not** check the PDE or
the analytic limiting arguments.

**Theorem B (compact singular-measure extension).** Let nu be a finite
nonnegative Borel measure supported on a compact subset E of the open unit
disk. Assume:

1. The integral operator with the disk Dirichlet Green kernel is bounded on
   L2(nu), with norm at most d for some d < 1.
2. For every interior x, the section G(x,.) belongs to L2(nu).

Define K, R, N by the manuscript's nonnegative chain integrals, with nu
in place of q. Then all their stated boundary evaluations are finite and,
for every interior p, the kernel with off-diagonal entries
K(p,s)K(p,t)/N(s,t) and diagonal zero is conditionally negative semidefinite.
Every finite interior reciprocal resolvent matrix also has at most one
positive eigenvalue.

This extension does not assume the conclusion, or a reciprocal-inertia
property for an unknown resolvent. Its hypotheses concern the *unperturbed*
Green operator and its sections. It includes a concrete measure singular
with respect to area: length measure on the segment [-1/2,1/2], and more
generally its multiples specified in Section 8.

No false assertion was identified in the audited Sections 4-5. In
particular, the absence of a direct complete-Pick citation for this singular
PDE kernel is not a refutation: the manuscript explicitly supplies the
additional arguments. No `F_` claim is appropriate on the evidence here.
The full hot-spots theorem still requires independent verification of its
other dependencies. Neither that theorem nor publication-level novelty is
certified by this Engineer report. Independent Reviewer acceptance remains
pending.

## 1. Exact objects and hypotheses

Write D for the open unit disk and S for its unit circle, with arclength
measure ds. For x,y in D and s in S set

    G(x,y) = (1/(2*pi)) log |(1-x*conj(y))/(x-y)|,
    G(x,x) = infinity,
    P_s(x) = (1-|x|^2)/(2*pi*|s-x|^2).

The equivalent formula

    G(x,y) = (1/(4*pi)) log(1 + 1/h(x,y)),
    h(x,y) = |x-y|^2 / ((1-|x|^2)(1-|y|^2))

uses h(x,x)=0. All reciprocals below are entrywise.

For Theorem A, dq=a dx, with measurable 0 <= a in L-infinity(D), and
there is 0 < d < 1 such that

    integral |psi|^2 dq <= d integral |grad psi|^2 dx
    for every psi in H^1_0(D).

Let T be the integral operator with kernel G on L2(q). The exact boundary
kernels, for distinct s,t, are

    K(p,s) = P_s(p) + sum_{n>=1} (T^n P_s)(p),
    R(s,t) = sum_{n>=0} integral P_s T^n P_t dq,
    N(s,t) = 1/(pi*|s-t|^2) + R(s,t).

Powers here initially mean iterated nonnegative integrals. In particular,
the notation does not presume P_s in L2(q). The kernel being proved
conditionally negative has entries D_p(s,t)=K(p,s)K(p,t)/N(s,t) for s!=t
and D_p(s,s)=0. Its quantifiers are every interior p, every finite boundary
family, and every real coefficient family with sum zero.

## 2. Analytic estimates, including nonsquare-integrable Poisson sections

For f in L2(q), the functional psi -> integral f psi dq on H^1_0(D) is
bounded by sqrt(d)||f||_q ||grad psi||_2. Hilbert-space representation
therefore gives its unique weak Dirichlet solution u, represented by the
explicit Green kernel. Testing against u gives

    integral |grad u|^2 = integral u f dq,
    ||u||_q^2 <= d ||u||_q ||f||_q.

Thus ||T|| <= d. Symmetry of G and the same weak identity give
self-adjointness. The identical argument applies to every 0 <= rho <= q.
The zero measure is included, with the trivial Hilbert space.

The following elementary, uniform estimates justify pointwise Green
evaluation:

    P_s(y) <= 1/(pi*|y-s|),
    0 <= G(x,y) <= (1/(2*pi)) log(2/|x-y|).

Indeed 1-|y| <= |s-y|, and |1-x*conj(y)| <= 2. Integrating the indicated
radial majorants on a disk of radius 2 proves

    sup_s ||P_s||_{L^(3/2)(dx)} < infinity,
    sup_x ||G(x,.)||_{L^3(dx)} < infinity.

If A=||a||_infinity, Holder's inequality implies

    F_s := T P_s is bounded uniformly in s and x.

Also sup_s integral P_s dq is finite. Consequently F_s is in L2(q).
For n>=2, positivity, Fubini, and the contraction bound give

    (T^n P_s)(p)
       = <G(p,.), T^(n-2) F_s>_q
       <= ||G(p,.)||_q d^(n-2) ||F_s||_q.

The constants are uniform in p and s. The n=1 term is F_s. Adding the
bounded function P_s(p), with p fixed, proves finiteness and boundedness
of K(p,.).

For s!=t, P_s P_t is integrable against bounded area density: in a
neighborhood of either pole the other Poisson section is bounded, and
|y-s|^(-1) is locally area-integrable. The n=1 term in R is bounded by
||F_t||_infinity integral P_s dq. For n>=2 the preceding pointwise bound
and the same last integral give a convergent geometric majorant.
Reversing the nonnegative chains proves symmetry of R. Finally, Tonelli
and integral_S P_s(x) ds=1 give

    integral_S integral_S R(s,t) ds dt
       = sum_{n>=0} <1,T^n 1>_q
       <= q(D)/(1-d).

These are precisely the estimates used later. They do not assert
P_s in L2(q); this distinction is essential at the disk boundary.

## 3. Initial reciprocal inertia: the regularization is valid

For a finite real symmetric matrix, write P for "at most one positive
eigenvalue, counted with multiplicity." P is preserved by invertible
diagonal congruence, subtraction of a positive semidefinite matrix,
principal restriction, and entrywise limits at fixed dimension. For the
last assertion, a two-dimensional positive subspace of a proposed limit
has a positive minimum on its unit circle; sufficiently close matrices
would be positive on that same subspace, a contradiction.

Let

    L(h) = 1/log(1+1/h) for h>0, L(0)=0,
    f(h) = h + 1/2 - L(h).

Direct multiplication by the positive factors 1-|x|^2 and 1-|y|^2 gives

    (1-|x|^2)(1-|y|^2)(h(x,y)+1/2)
      = (1/2)(1+|x|^2)(1+|y|^2) - 2 x dot y.

This is a nonnegative rank-one kernel minus a positive semidefinite
kernel, so h+1/2 has P on every finite family.

Here is a self-contained positive-mixture proof for f. For 0<alpha<1
normalize the integrable density v^(alpha-1)/(1+v) on (0,infinity)
to a probability measure and put r=1/(1+v). Integration by parts,
whose boundary terms vanish at both ends, gives E_alpha(1-r)=alpha.
Scaling v in the normalizing integral gives, for h>0,

    h^(1-alpha)(h+1)^alpha
      = E_alpha [ h(h+1)/(h+r) ]
      = E_alpha [ h+(1-r)-r(1-r)/(h+r) ].

Integration in alpha evaluates the left side to L(h). Hence

    f(h) = integral_0^1 E_alpha [ r(1-r)/(h+r) ] d alpha.

This identity is also valid at h=0: its right side is
integral_0^1 alpha d alpha=1/2. It shows 0<=f(h)<=1/2.

The disk kernel

    k(x,y) = 1/(1+h(x,y))
           = (1-|x|^2)(1-|y|^2)/|1-x*conj(y)|^2

is positive semidefinite. Expand (1-x*conj(y))^(-1) into its geometric
Gram series; multiply that kernel by its complex conjugate and by the
positive diagonal factors. For each fixed 0<r<1,

    1/(h+r) = sum_{n>=0} (1-r)^n k^(n+1),

where powers are entrywise. The geometric ratio is at most 1-r, even
on the diagonal. Every Schur power is positive semidefinite: it is the
Gram kernel of the corresponding tensor powers. The convergent series,
then the positive mixture with finite entries, prove that f(h(x,y)) is
positive semidefinite.

For 0<epsilon<=1 define

    1/C_epsilon(x,y)
      = 4*pi [h+1/2-(1-epsilon)f(h)]
      = 4*pi [L(h)+epsilon f(h)].

Its reciprocal has P by the preceding two conclusions. Moreover

    L+epsilon f = epsilon(h+1/2)+(1-epsilon)L >= epsilon/2.

Thus C_epsilon is continuous, strictly positive, and bounded by
1/(2*pi*epsilon). Because f>=0, it increases to G as epsilon decreases
to zero, including the diagonal C_epsilon(x,x)=1/(2*pi*epsilon).
No positive-semidefiniteness assertion about C_epsilon itself is needed.

## 4. Exact universal update and its formalized core

Let M be any finite symmetric strictly entrywise positive matrix whose
reciprocal has P. Fix an index z and c>=0. Normalize that reciprocal by
the positive diagonal entries M_iz, obtaining

    H_ij = M_iz M_zj / M_ij.

Its z-row and column are constant a=M_zz>0. Eliminating that row and
column by congruence leaves the blocks H_0-a*11^T and a. Therefore
H_0-a*11^T is nonpositive, or the matrix would have two positive
directions. Equivalently, on the full index set

    U = a*11^T - H

is positive semidefinite; its z-row is zero. Since H_ii>0,
0<=U_ii<a. Testing U on e_i+e_j and e_i-e_j gives

    |U_ij| <= (U_ii+U_jj)/2 < a.

The same fixed diagonal normalization of the reciprocal of
M_ij+c M_iz M_zj is H_ij/(1+c H_ij). Its defect from the constant kernel is

    a/(1+ca) - H_ij/(1+c H_ij)
      = U_ij / ((1+ca)(1+ca-c U_ij))
      = sum_{n>=0} c^n U_ij^(n+1)/(1+ca)^(n+2).

Every coefficient is nonnegative, every Schur power is positive
semidefinite, and |c U_ij/(1+ca)|<1. Hence the defect is positive
semidefinite. This proves P for the updated reciprocal. Negative entries
of U are allowed throughout; they are not silently replaced by
entrywise nonnegative entries. The case c=0 is included.

`lean/Main.lean` formally proves the strict entry bound, Schur powers,
closure of positive semidefiniteness under entrywise limits, the
convergent scalar series, its positive semidefinite sum in every finite
dimension, and the normalized defect formula. See
`lean/statement_fidelity.md` for the exact quantifiers and exclusions.
In particular, this is a universal theorem, not just the rational
example returned by Jacobian.

## 5. Compact measures: quadrature, elimination, and the Green limit

We prove the interior assertion in Theorem B. Symmetry and boundedness
of T_nu imply self-adjointness: absolute integrability of the bilinear
pairing follows by applying its bound to |f| and |g|. The inverse
(I-T_nu)^(-1) is its norm-convergent Neumann series.

For x!=y define

    M^nu(x,y) = G(x,y)
       + <G(x,.), (I-T_nu)^(-1) G(y,.)>_nu.

The correction is finite, bounded in absolute value by
||G(x,.)||_nu ||G(y,.)||_nu/(1-d). It is nonnegative by the
nonnegative Neumann expansion. Set the diagonal to infinity.

First replace every G by C=C_epsilon with epsilon fixed. Pointwise
domination gives |T_C f|<=T_nu |f|, hence ||T_C||<=d, without assuming
C is positive semidefinite. Partition E into measurable cells with
diameters tending uniformly to zero; use the mass w_alpha of each
positive-mass cell and a representative z_alpha. For the associated
step map pi,

    C(pi(.),pi(.)) -> C uniformly on E x E,
    ||T_pi-T_C|| <= nu(E) sup |C(pi(.),pi(.))-C| -> 0.

For each fixed x, C(x,pi(.))->C(x,.) uniformly on E and in L2(nu).
Thus sufficiently fine quadratures have ||T_pi||<1; the inverse identity

    (I-A)^(-1)-(I-B)^(-1)
       = (I-A)^(-1)(A-B)(I-B)^(-1)

proves convergence of their inverses and of each evaluated resolvent.
In the orthonormal normalized-cell basis, T_pi is represented by

    T_ab = sqrt(w_a) C(z_a,z_b) sqrt(w_b),
    (xi_x)_a = sqrt(w_a) C(x,z_a).

Its evaluated correction is xi_x^T (I-T)^(-1) xi_y. The operator norm
is less than one, so all nonnegative finite-node path sums converge.

Start the path sum on the union of evaluation points and quadrature
nodes with kernel M=C. Suppose some nodes have already been admitted
as internal vertices. To admit a new node z of weight w, decompose
each path uniquely at its internal occurrences of z. Paths with
exactly k>=1 such occurrences contribute

    w^k M_iz M_zz^(k-1) M_zj.

The full nonnegative path sum is finite. Since M_iz and M_zj are
strictly positive, this forces w M_zz<1, and summation gives the update

    M_ij -> M_ij + [w/(1-w M_zz)] M_iz M_zj.

Section 4 applies at every node. The argument still works when an
endpoint is a node: only internal occurrences carry weights.
Coincident quadrature representatives can be merged by adding weights.
Thus each sufficiently fine quadrature resolvent has P for its
reciprocal. The fixed-epsilon quadrature limit preserves P.

Now decrease epsilon to zero. Each finite path integral increases to
the corresponding Green path integral. Monotone convergence on each
product measure and then on the path-length sum identifies the limit
with M^nu above. Off-diagonal finiteness follows from the L2 section
bound, not an unproved interchange at a singular diagonal. The direct
diagonal term tends to infinity, so its reciprocal tends to zero.
The finite reciprocal matrices therefore converge entrywise and retain P.

The hypotheses of Theorem B exclude atoms automatically: taking x at
an atom would contradict G(x,.) in L2(nu). There is consequently no
hidden assignment of a finite value to an atomic Green self-interaction.
No operator-norm convergence of T_C to T_nu as epsilon tends to zero
is asserted or required.

## 6. Boundary limit, with compact support fixed

For a compact E contained in D, P_s is uniformly bounded on E for every
boundary s, including uniformly over s. Therefore

    K^nu(p,s) = P_s(p)
      + <G(p,.),(I-T_nu)^(-1)P_s>_nu,
    R^nu(s,t) = <P_s,(I-T_nu)^(-1)P_t>_nu

are finite and equal their nonnegative chain definitions. In
particular N^nu(s,t)>0 for s!=t and K^nu(p,s)>0.

Take distinct s_1,...,s_m and r increasing to 1 with r>|p|. The explicit
Green formula gives

    G(rs,x)/(1-r) -> P_s(x) uniformly for x in E,
    G(rs,rt)/(1-r)^2 -> 1/(pi*|s-t|^2) for s!=t.

For the first limit, divide the logarithm by its argument and use
(1-r^2)/(1-r)=1+r. Its small argument tends to zero uniformly on E.
For the second, its argument is
(1-r^2)^2/(r^2 |s-t|^2), giving the factor 4 before division by 4*pi.
The direct p-boundary limit has the same first normalization.

Uniform convergence on E gives L2(nu) convergence of the source
vectors; the bounded inverse and the section at p then give

    M^nu(rs_i,rs_j)/(1-r)^2 -> N^nu(s_i,s_j),   i!=j,
    M^nu(p,rs_i)/(1-r) -> K^nu(p,s_i).

Apply the interior reciprocal result to these m+1 points. Congruence
with factors 1-r at the moving points and 1 at p gives in the limit

    [ B   l ]
    [ l^T 0 ],

where B_ii=0, B_ij=1/N^nu(s_i,s_j), and l_i=1/K^nu(p,s_i).
The diagonal is zero throughout because the interior Green diagonal
is infinite. This bordered matrix has P. This proof never takes an
L2(q) boundary limit of a Poisson section with support reaching S.

## 7. Exhaustion and the border argument: Theorem A follows

For the original bounded density take
rho_n=1_{|x|<=r_n} q, with r_n increasing to 1. Section 2 gives the
same strict bound d and square-integrable Green sections for each.
Sections 5-6 therefore apply to each rho_n. Every term of K^rho_n and
R^rho_n is an increasing nonnegative product-measure chain integral.
Monotone convergence, first in each length and then in the countable
sum, gives

    K^rho_n(p,s) -> K(p,s),
    N^rho_n(s,t) -> N(s,t), s!=t.

Section 2 proves the limits finite. They are bounded below by the
strictly positive unperturbed kernels, so their reciprocals converge.
The full-q bordered matrix consequently has P.

For completeness, here is the required algebra; unnormalized P alone
is **not** being identified with conditional negativity. Suppose
l^T x=0 and x^T B x>0. Choose y with l^T y!=0 and replace it by

    y' = y - (x^T B y)/(x^T B x) x.

Then x^T B y'=0 and l^T y'=l^T y!=0. In the bordered form,
(x,0) and (y',c) are orthogonal. Choosing

    c = (1-y'^T B y')/(2 l^T y')

makes the second vector's quadratic value equal to 1. The first is
strictly positive, so these independent vectors span a two-dimensional
positive subspace, contradicting P. Therefore x^T B x<=0 whenever
l^T x=0.

For coefficients a_i summing to zero put x_i=K(p,s_i)a_i. Then

    l^T x = sum_i a_i = 0,
    x^T B x = sum_{i,j} a_i a_j D_p(s_i,s_j) <= 0.

This proves Theorem A and, without the exhaustion step, Theorem B.
Repeated boundary points are handled by combining their coefficients.
The zero potential is covered and gives
D_p(s,t)=|phi_p(s)-phi_p(t)|^2/(4*pi), with the manuscript's constants.

The four analytic limits have been taken in the required order:
quadrature at fixed epsilon and compact support; epsilon decreasing to
zero; radial boundary approach at fixed compact support; compact-support
exhaustion. None is substituted for a different order of limits.

## 8. A genuinely singular admissible example

Let sigma be ordinary length measure on the interior segment
I=[-1/2,1/2] on the real axis. Put nu=tau sigma, where tau>=0 and

    tau * (1+log 4)/(2*pi) < 1.

For all x in D and real y in I,

    G(x,y) <= (1/(2*pi)) log(2/|Re(x)-y|),

away from a null exceptional point. The integral of the right-hand
logarithm over I is maximized when Re(x)=0. One proof uses layer cake:
for each radius the length of the intersection of I with an interval
of that radius is largest for a centered interval. Direct integration
at the center gives

    sup_x integral_I G(x,y) dy <= b := (1+log 4)/(2*pi).

The same argument for the square of the positive logarithm gives

    sup_x integral_I G(x,y)^2 dy
      <= ((log 4)^2+2 log 4+2)/(4*pi^2) < infinity.

Thus all Green sections lie in L2(nu). Symmetry and the weighted
Cauchy-Schwarz inequality give the Schur estimate ||T_nu||<=tau*b:
square |T f(x)|, bound it by
(integral G(x,y)dnu(y))(integral G(x,y)|f(y)|^2 dnu(y)),
then integrate in x and apply the same bound to the other integral.
Theorem B applies.

In particular tau=1 is admissible: log 4<2 and pi>3 imply b<1/2.
For an entirely elementary logarithm bound, on [1,2] the chord
(3-t)/2 exceeds 1/t by (t-1)(2-t)/(2t). Integrating gives
log 2<=3/4, hence log 4<=3/2; together with the inscribed-hexagon
bound pi>3 this even gives b<5/12.
This measure has no bounded area density, indeed it is singular with
respect to area, so it is outside Theorem A's potential class. The
conclusion is about the explicitly defined Green-chain kernels; no
unproved assertion about weak PDE traces for arbitrary measures is
included in Theorem B.

## 9. Literature scope and the improvement over the source baseline

The strongest prior result relevant here is exactly the staged Theorem 5.1
(`thm:negative-kernel`): bounded nonnegative area-density potentials with a
strict Dirichlet-form bound. The present verification checks its complete
analytic dependency chain, provides an independent kernel-checked
all-dimensions Schur-resolvent implication, and extends the kernel theorem
to compact singular measures, with an explicit admissible line measure.

A bounded primary-source lookup found no independent source already
proving this exact PDE resolvent/boundary theorem or this singular-measure
extension. This is a retrieval result, **not** proof of global novelty.
The initial broad web answer made an unsupported generic assertion about
PDE reciprocal inertia; no primary proposition or exact counterexample
was supplied, and it has not been used as evidence.

The following sources were actually opened for scope, not used as
unproved replacements for Sections 3-7:

* Agler and McCarthy, *Complete Nevanlinna-Pick Kernels*,
  DOI 10.1006/jfan.2000.3599, text arXiv:1610.01997v1, Corollary 1.12,
  p. 7: irreducible positive-definite reproducing kernels are complete
  Pick exactly when all their entrywise reciprocal matrices have
  exactly one positive eigenvalue. These kernels have finite diagonal.
  Their holomorphic Dirichlet-space example on p. 8 is not the PDE
  Green function. This direct citation shortcut is retired in the ledger.
* Quiggin, *Generalisations of Pick's Theorem to Reproducing Kernel
  Hilbert Spaces*, Lancaster thesis (1994), stable record
  https://eprints.lancs.ac.uk/id/eprint/61962/, Section 2.2:
  Corollary 2.2.2 (printed p. 33) assumes a totally ordered,
  factorized kernel with positive f,g and strictly increasing f/g.
  Theorem 2.2.3 (printed pp. 34-35) concerns weighted one-dimensional
  Sobolev spaces, with positive continuous w0,w1 and continuously
  differentiable w1; its Green equation is a regular Sturm-Liouville
  problem. It is not a theorem about the planar Dirichlet Green kernel.
* Qi, Zhang and Li, text actually read arXiv:1303.3122v1,
  Theorem 4.1 and Corollary 4.1, equation (4.3), p. 10.
  Their positive integral for the arithmetic-minus-logarithmic mean
  agrees with the scalar f above. The published article is DOI
  10.1007/s00009-013-0311-z, but its publisher text was unavailable in
  the lookup. The argument in Section 3 independently derives the
  needed representation and disk positive semidefiniteness.
* Rohleder, text arXiv:2106.05224v4, Theorem 1.1 and the paragraph
  immediately following it: the tangent-vector variational formula
  on bounded simply connected Lipschitz domains with piecewise smooth
  boundary and convex corners has precisely the first-eigenfunction
  gradients as minimizers. His curvature is negative where the domain
  is convex. The staged smooth-domain statement reverses that
  convention explicitly. This source is relevant to the broader
  hot-spots graph, but is not an assumption of Theorems A or B.

No specialized external proposition is left as an assumption in the
proof of Theorems A-B. The usual foundations used explicitly are
Hilbert-space representation, Holder and Cauchy-Schwarz, Tonelli and
monotone convergence, finite-dimensional real spectral inertia, and
geometric-series convergence. The kernel-specific mixture, update,
quadrature, and boundary implications have all been derived above.

## 10. What replay establishes

Run `verify.py` with the authorized Argus Python. It checks exact universal
rational identities symbolically, reconstructs the rational Jacobian
example independently, and checks its exact LDL congruence and typed
adapter output. It then obtains a fresh official Lean compiler verdict
for `C_RK_SCHUR` and runs both official checks against this campaign root.
The output is explicit about the remaining human analytic proof and
independent-review boundary.

`exact_certificate.json` identifies the universal theorems, hypotheses,
source and formal declarations, exact example, and exclusions. The
finite example is only corroboration; it is not the proof of either
theorem. The Lean certificate verifies its precisely documented
algebraic statement, not an automatically translated assertion about
all PDE potentials. An independent Reviewer must read the analytic
argument, statement fidelity, and singular-measure extension before
accepting the mathematical result or its novelty/significance.
