# Direct unital comparison route: verification and relative extension

## Result, scope, and evidence classification

**Theorem V.** Let A be a simple, separable, unital, infinite-dimensional
nuclear C*-algebra, with nonempty tracial-state space T and stabilized
strict comparison tested on all traces in T. Let D be its uniform tracial
ultrapower and Lambda its varying limit traces. For every unital
norm-separable C*-subalgebra C of D and every positive integer m, there
are orthogonal projections p_1,...,p_m in D intersect C' such that

    sum p_i = 1,      tau(b p_i) = tau(b)/m
                     (b in C, tau in Lambda, 1 <= i <= m).

In particular, taking C=A proves the exact implication in
`u:thm:uniform-gamma`. The proof below verifies all load-bearing
dependencies, not just finite-dimensional examples. It does not assert a
counterexample, and no false assertion was found in the selected route.
The Jiang--Su absorption criterion and the empty-trace and nonunital
arguments are not needed for this theorem and are not certified here.

**Theorem M (mixed-ultraproduct extension).** Replace A by any sequence
(A_l) of simple, unital, infinite-dimensional nuclear C*-algebras, each
with nonempty tracial-state space T_l and stabilized strict comparison.
Let

    D = product_l A_l / {(x_l): lim_omega ||x_l||_(2,T_l) = 0},

where only norm-bounded sequences are used in the product. Let Lambda
consist of the traces lim_omega tau_l with tau_l in T_l. Then the
conclusion of Theorem V holds for every unital norm-separable C in D.
No coordinate separability and no uniform bound on the complexity or
number of nuclear approximation pieces is required.

These are universal mathematical proofs in ordinary C*-algebra theory.
The standalone script checks the exact free-word calculations, rational
example, and numerical proof constants. Lean independently checks the
universal noncommutative fourth-moment identity and its inequality for
arbitrary sequence length. Neither checker implements all of
C*-algebra theory: **the analytic theorem is not a kernel-checked
theorem**. Independent review of that proof and of statement fidelity
is still required. Novelty and publishability are not self-certified.

Compared with the strongest relevant prior assertion in the staged
manuscript, the improvement is explicit: its final theorem takes C=A
for one separable A. The result here allows every norm-separable
coefficient algebra in a mixed ultraproduct, even of nonseparable
coordinate algebras. The exact commutator-deficit identity below also
identifies what is discarded in the manuscript's fourth-moment bound.
These are extensions of scope, not evidence that the manuscript's
original proof is false. No global literature-priority claim is made.

The relevant staged source is *Tracial projection methods and uniform
property Gamma* (23 September 2026), `build/sections/`:

| Source label | Obligation verified here |
|---|---|
| `u:lem:thin-full` in `03_rr_projections.tex` | Uniformly small full support, Section 2 |
| `u:lem:tracial-diagonal` in `07_unital_preliminaries.tex` | Fixed-radius diagonal, Section 1 |
| `u:prop:rank-approximation`, `u:lem:almost-projection`, `u:prop:projection-supply` in `08_unital_ranks.tex` | Exact support and trace supply, Section 2 |
| `u:lem:scalar-compressions`, `u:prop:centered-symmetry` in `09_unital_centering.tex` | Simultaneous centering, Section 3 |
| `u:lem:homomorphism-replacement`, `u:prop:averaged-observable`, `u:lem:clipping`, `u:prop:local-moments` in `10_unital_averaging.tex` | Dimension-independent local estimates, Sections 4-6 |
| `u:prop:relative-moments`, `u:prop:conditional-clt`, `u:thm:uniform-gamma` in `11_unital_gamma.tex` | All coefficients and projections, Sections 7-9 |

## 0. External inputs and excluded shortcuts

The two substantive external inputs are:

1. Hirshberg--Kirchberg--White, *Decomposable approximations of nuclear
   C*-algebras*, arXiv:1109.2379v2, Theorem 1.4, page 4.
   The outgoing map is a **finite convex combination of contractive
   order-zero maps**. The number of terms is not uniformly bounded.
   The primary PDF and its statement are archived in `literature/`.
2. Dobler, *A short proof of Levy's continuity theorem without using
   tightness*, arXiv:2111.01603v1, Theorem 1.1, page 1. Pointwise
   characteristic-function convergence to the characteristic function
   of a probability measure implies weak convergence. The primary PDF
   and statement are likewise archived.

Both statements were opened at their primary sources. Independent
citation attribution is left to the Host-invoked Reviewer, not filed
under a second name by the Engineer. They are explicit assumptions
HKW14 and LEVY11 in the claim ledger. The finite-dimensional
order-zero supporting homomorphism is proved below rather than assumed
from an unchecked citation.

The background framework is the usual continuous and spectral
functional calculus for C*-algebras, polar decomposition in the bidual,
tracial Cauchy--Schwarz, polynomial approximation of continuous functions
on a compact interval, and the representing measure of a positive
functional on a commutative C*-algebra. No uniform Gamma, complemented
partitions of unity, Jiang--Su stability, uniform nuclear dimension,
faithfulness of a trace on the entire bidual, or nuclearity of C is
assumed.

The inherited Wiki index contains no matching Cuntz/uniform-Gamma topic.
A targeted public literature search retrieved the known Gamma-plus-
comparison absorption criterion but did not settle priority of the
mixed-ultraproduct statement or the deficit refinement. That search is
not evidence of novelty.

## 1. Exact tracial tests and the bounded diagonal

Write ||x||_(2,T)=sup_tau tau(x*x)^(1/2). On bounded sequences this is
stable under left and right multiplication by bounded sequences and
under adjoints. Thus the uniform tracial null sequences form a closed
two-sided ideal. For every represented x=[(x_l)],

    ||x||_(2,Lambda) = lim_omega ||x_l||_(2,T_l),
    sup_{tau in Lambda} |tau(x)|
      = lim_omega sup_{rho in T_l} |rho(x_l)|.                 (1)

For the reverse inequalities, choose a trace within 1/l of the
coordinate supremum; for the first identity apply this to x_l*x_l.
Bounded scalar ultralimits commute with absolute value and square
root. In particular zero uniform 2-norm means zero in D. These
identities involve precisely Lambda, not every abstract trace of D.

Every positive, selfadjoint, or arbitrary element of a fixed norm ball
has lifts in the same coordinate balls. Use continuous clipping in the
first two cases and a -> a f(a*a), f(t)=min(1,R/sqrt(t)), in the third,
with its continuous value at zero. Radius zero is handled by zero.

For countably many polynomial tracial tests t_k with bounds c_k,
suppose every finite list is satisfiable to arbitrary positive error
in these fixed balls. Choose a trial tuple x^(n) with errors <1/(2n)
for k<=n, and lifts of all parameters and tuples. By (1), the
coordinate good set E_n on which these errors are <1/n belongs to
omega. Put F_n={l>=n} intersect the intersection of E_j for j<=n.
These sets decrease, belong to omega, and have empty intersection.
For each coordinate in their union, take the trial with the largest
index r(l) such that l lies in F_{r(l)}; elsewhere use zero.
This is finite since r(l)<=l. On F_n every test k<=n has error at
most 1/n. The resulting bounded tuple satisfies all tests exactly
after taking ultralimits. This proves the required diagonal for both
the single-algebra and mixed settings.

Separability is used only to replace coefficient balls by countable
norm-dense sets. It never allows an unbounded sequence of diagonal
variables.

## 2. Projection supply, including the spectral boundary

Here work in one coordinate algebra A; neither separability nor
nuclearity is used in this section.

**Small full support.** An infinite-dimensional simple unital A has
arbitrarily many orthogonal nonzero positive elements c_1,...,c_k.
Indeed a finite-dimensional maximal abelian subalgebra would have
minimal projections p_i with p_i A p_i=C p_i; each p_i A p_j then
has dimension at most one, forcing A itself finite dimensional.
An infinite-dimensional abelian subalgebra has the required positive
elements by disjoint neighborhoods in its spectrum.

For nonzero positives c,d, simplicity implies c A d is nonzero.
Choose z=c y d nonzero. Its two positive squares have equivalent
support projections in every tracial von Neumann representation;
these supports lie under those of d and c respectively. Iterating
this construction produces a nonzero e whose support trace is at most
each support trace of c_i at every trace. Orthogonality gives

    k d_tau(e) <= sum_i d_tau(c_i) <= 1.

Choose 1/k<delta and rescale e to norm one. Simplicity makes it full.
All elements in the construction are chosen independently of tau.

**Trace-to-rank approximation.** Fullness supplies finitely many
x_i with sum x_i* e x_i=1. For completeness, choose an invertible
s=sum u_i e v_i. With U=(u_i e^(1/2)) and
V=(e^(1/2)v_i)^T, invertibility of UV implies y=V*V is invertible,
and x_i=v_i y^(-1/2) is the claimed frame. For b>=0 put

    c=sum e^(1/2) x_i b x_i* e^(1/2).

Then tau(c)=tau(b) for every tau, and d_tau(c)<=d_tau(e)<delta.
The norm of c may be arbitrarily large; this is harmless. Choose an
integer L>=max(1,||c||) and put v=direct_sum_{j=1}^L (c-j)_+.
For every real s in [0,L],

    0 <= s - sum_{j=1}^L 1_(j,infinity)(s)
       <= 1_(0,infinity)(s).

At a positive integer the difference is one, not zero. Spectral
integration with the **unnormalized** matrix trace therefore gives

    tau(b)-delta < d_tau(v) <= tau(b).                        (2)

**Almost projections in Her(b).** Suppose b>=0 and ||b||<1.
When b is nonzero, faithfulness of tracial states of simple A gives
d_tau(v)<=tau(b)<=||b|| d_tau(b)<d_tau(b). Strict comparison yields
v precsim b. There is one t>0 such that

    d_tau((v-3t)_+) > tau(b)-2delta                          (3)

for all tau. To check the uniform quantifier, these cut ranks are
lower semicontinuous, increase to d_tau(v), and the increasing open
sets where (3) holds cover compact T(A).

Choose a comparison row x with w=x*b x and ||w-v||=alpha<t.
In the matrix bidual let E=1_(3t,infinity)(v) and
F=1_(t,infinity)(w). Then

    E(w-2t)_+ E >= (t-alpha)E,      F v F >= (t-alpha)F.

Polar decomposition of a^(1/2)Q whenever QaQ>=gamma Q,
gamma>0, gives support comparison in each normal trace. Hence

    d_tau((v-3t)_+) <= d_tau((w-2t)_+),
    d_tau((w-t)_+) <= d_tau(v).

The positive element w'=b^(1/2) x x* b^(1/2) in Her(b) has the same
positive cut ranks as w, again with the unnormalized corner trace.
Choose continuous g that is zero on [0,t] and one on [2t,infinity).
Then p_0=g(w') is a positive contraction in Her(b), and (2)-(3)
give

    tau(b)-2delta < tau(p_0) <= tau(b),
    0 <= tau(p_0-p_0^2) < 2delta.                            (4)

There is no subtraction of infinite ranks. If b=0 choose zero.
If v=0, (2) gives tau(b)<delta and the zero witness also satisfies
the estimates; this boundary case is not excluded.

**Exact supply in D.** For a positive contraction h=[(h_l)] and
0<eta<1, apply (4) to b_l=(h_l-eta)_+ with delta=1/l.
The resulting p_l are positive contractions. Since
(p_l-p_l^2)^2<=p_l-p_l^2, their class p is a projection, and

    tau(p)=tau((h-eta)_+)       (tau in Lambda).              (5)

For k_eta(s)=min(s/eta,1), hereditary membership gives
k_eta(h_l)p_l=p_l at every coordinate. Therefore
k_eta(h)p=p=pk_eta(h) **as identities in D**. In D** the kernel
projection of 1-k_eta(h) is 1_[eta,1](h), so

    p <= 1_[eta,1](h).                                      (6)

The closed endpoint eta is essential: the argument does not assert
p<=1_(eta,1](h). No faithfulness on D** is used. Setting h=q,
eta=1/2, for any projection q gives a half-trace subprojection
p<=q and the corner symmetry r=2p-q, with r^2=q and tau(r)=0.

## 3. Uniform coefficient centering

The first task is a finite partition of most of a projection q into
blocks with nearly scalar compressions of finitely many coefficients.
It is not a claim that these blocks commute with the coefficients.

For one selfadjoint contraction x choose a finite continuous partition
of unity f_1,...,f_m on [-1,1], each supported within epsilon of a
scalar lambda_j. Functional calculus is taken in the current corner:
for v a projection, the constant term of P^v(vxv) is a_0 v, not a_0.
If v<=u and t=tau(u-v), telescoping powers gives

    |tau(P^u(uxu))-tau(P^v(vxv))| <= C_P sqrt(t),
    C_P=|a_0|+2 sum_{k>=1} k|a_k|.

If ||f-P||_infinity<=a, add 2a to this bound. This estimate is
uniform in x,u,v,tau. For 0<delta<1, choose approximating
polynomials with error <=delta/(16m), let

    C=max(1,C_{P_1},...,C_{P_m}),   alpha=delta/(4m),
    kappa=min(delta/(4m),(delta/(8m C))^2).

Shrinking a corner by trace <kappa changes each f_j trace by at most
delta/(4m). In a pass through all m functions, apply (5)-(6) to
y_j=f_j^{v_{j-1}}(v_{j-1}xv_{j-1}) at cutoff alpha, remove the
resulting projection a_j, and continue in v_j=v_{j-1}-a_j.
The projection a_j has compression within epsilon of lambda_j a_j
and tau(a_j)>=tau(y_j)-alpha.

If the pass starts at u with tau(u)>delta but removes <kappa at a
particular trace, some initial f_j has trace >delta/m. At its turn,
the preceding continuity estimate implies

    tau(a_j)>delta/m-delta/(4m)-delta/(4m)
             =delta/(2m)>kappa,

a contradiction. Each pass thus removes at least kappa whenever
that trace's residual exceeds delta. After floor(1/kappa)+1 passes,
no trace has residual >delta. The number of passes is fixed before
looking at tau. No compactness of Lambda is needed.

For finitely many selfadjoint coefficients refine these blocks one
coefficient at a time, allocating trace loss
delta/(n max(1,number_of_current_blocks)) per block. Every earlier
compression estimate survives subcompression. The total loss is at
most delta at every trace.

For a finite set H of general coefficients, scale real and imaginary
parts by M=max(1,max_{b in H}||b||). Use both tolerances theta with
theta<=min(1/4,zeta/(8M)). On each resulting block choose the
trace-zero corner symmetry provided after (6); on the residual
projection use its unit. Their sum r is a corner symmetry. The block
trace weights, rather than the number of blocks, give

    |tau(b r)| <= 2M theta sum_s tau(p_s)+M theta
                <=3M theta<zeta.                           (7)

For a finite-dimensional E in D, first adjoin the complementary
scalar block if E is nonunital. Choose matrix units e_ij^(l).
Apply (7) in each e_11^(l) corner to all coefficients
e_1i^(l) b e_i1^(l), with tolerance divided by sum_l n_l.
Transport the chosen corner symmetries by matrix units. The resulting
unitary R commutes **exactly with E** and has all the prescribed
finite coefficient traces <zeta. Apply Section 1 to its square,
matrix-unit commutators, and a dense sequence in a norm-separable S.
This yields

    r=r*, r^2=1, r in E', tau(s r)=0 (s in S,tau in Lambda). (8)

Commutation with S is neither obtained nor used.

## 4. Nuclear averaging without a dimension bound

Let phi:F->D be cpc order zero with F finite dimensional, and h=phi(1).
Put q=supp(h) in D**. The cpc maps
(h+t)^(-1)phi have strong pointwise limit pi; on projections their
limits are the corresponding support projections. Since projections
span F, the limit is a unital completely positive projection-preserving
map into qD**q. The Schwarz equality at a projection gives its
multiplicative-domain identities; linear span then makes pi a
*-homomorphism. Consequently phi(x)=h pi(x)=pi(x)h.

In one matrix block, set a=phi(e_11). Supply p<=1_[eta,1](a) as in
(5). With k(s)=min(s/eta,1) and continuous g(s)=k(s)/s,
g(0)=1/eta,

    v_s=pi(e_s1)k(a)=phi(e_s1)g(a) belongs to D,
    rho(e_st)=v_s p v_t*=pi(e_s1)p pi(e_1t).

These are matrix units, orthogonal across different blocks. They
define a possibly nonunital homomorphism rho:F->D. Its unit P lies
under q, commutes with pi(F), and P pi(x)=rho(x).
Neither p commuting with a nor P commuting with h is required.
Summing the trace losses **with their support weights** gives

    0<=tau(h)-tau(P)<=eta tau(q)<=eta.

For every contraction c in F, the two squared distances to pi(c)
are at most 1-tau(h) and 1-tau(h)+eta. Thus

    ||phi(c)-rho(c)||_(2,tau)^2 <=4(1-tau(h))+2eta.           (9)

This estimate has no matrix-size factor.

Apply HKW14 to {1} union E union {a^2:a in E}, with error eta,
and write T_i=phi_i psi_i, T_0=sum beta_i T_i. Fix one tau.
The positive unit defects satisfy

    sum beta_i(1-tau(h_i)) < eta.

Schwarz for the cpc T_i and expansion of squared distances yield

    sum beta_i ||a-T_i(a)||_(2,tau)^2 <=3eta.

Using (9), first the replacement errors sum to <=6eta, then the
combined distances to rho_i psi_i(a) sum to <=18eta. Choose r_i
successively by (8), commuting with rho_i(F_i) and centered over
S_i=C*(A,r_1,...,r_{i-1}) in the separable case. Then

    sum beta_i ||[r_i,a]||_(2,tau)^2 <=72eta.                (10)

For finite local tests without separability of A, replace the A in
S_i by the algebra generated by 1, E, and the finitely many tested
coefficients H. That algebra is separable, is not required to be
nuclear, and contains every letter used in the cancellations below.
HKW14 is still applied to the ambient nuclear A.

Put z=sum sqrt(beta_i)r_i. In the trace of any mixed commutator
product with indices i<j, r_j occurs once and every other letter
belongs to S_j. Cyclicity puts that letter last, so (8) makes its
trace zero. The same cancellation proves, for all b in the chosen
coefficient algebra,

    ||[z,a]||_(2,tau)^2 <=72eta,
    tau(bz)=0,              tau(bz^2)=tau(b).               (11)

All estimates hold at the same arbitrary tau, hence uniformly over
Lambda. They do not use a cancellation involving a maximal index
occurring twice, which would be invalid.

## 5. Exact fourth-moment deficit and formal certification

Let X be a selfadjoint prefix, r the next selfadjoint involution,
and c its real weight. The complete cyclic-trace expansion is

    tau((X+c r)^4)
      =tau(X^4)+4c tau(X^3 r)
       +c^2(4tau(X^2)+2tau(X r X r))
       +4c^3 tau(X r)+c^4.

There are four one-r words, four three-r words, and six two-r
words. Of the latter, four reduce cyclically to X^2 and two remain
alternating. Successive centering eliminates exactly the two odd
traces. For a selfadjoint X,r with r^2=1,

    ||[X,r]||_(2,tau)^2 =2tau(X^2)-2tau(X r X r).

Therefore the one-step formula is the **identity**

    tau((X+c r)^4)
      =tau(X^4)+6c^2 tau(X^2)+c^4
       -c^2 ||[X,r]||_(2,tau)^2.                           (12)

Writing Z_i=sum_{j<i} c_j r_j and using
tau(Z_i^2)=sum_{j<i}c_j^2, induction gives, for every finite n,

    tau(Z_n^4)
      =3(sum_{i<n}c_i^2)^2-2 sum_{i<n}c_i^4
       -sum_{i<n}c_i^2 ||[Z_i,r_i]||_(2,tau)^2.             (13)

This universal identity is stronger than the source's inequality.
With c_i=sqrt(beta_i), positivity gives
tau(z^4)<=3-2 sum beta_i^2<=3. Equality in the sharper bound occurs
exactly when each positive-weight commutator has zero tracial
2-seminorm. Zero weights cause no division or exceptional case.

`Main.lean` proves (12)-(13) and the upper bound for every ring,
trace, sequence, and natural length satisfying the precise
hypotheses in `statement_fidelity.md`. It does not replace (8) by an
independence or commutation hypothesis. The compiler certificate is
mechanical evidence only for claim C_GAMMA_FOURTH.

An ancillary exact example distinguishes (13) from a spurious
commutative calculation. Take

    r_1=diag(1,-1), r_2=[[0,1],[1,0]], c_1=3/5,c_2=4/5.

These involutions anticommute, and r_2 is trace-centered over
C*(1,r_1). Then z^2=1, tau(z^4)=1, the baseline
3-2 sum c_i^4 is 1201/625, and the commutator deficit is 576/625.
The Jacobian adapter independently returned the exact spectrum
{-1,1} for z. Its typed payload, complete typed output, server and
protocol versions, and zero adapter exit are preserved. This
example is **not** a counterexample to any manuscript assertion:
M_2 does not satisfy the infinite-dimensional hypotheses and is
used only to exercise the algebraic identity.

## 6. Clipping and extraction of local elements in A

Set d=g_R(z), g_R(s)=max(-R,min(s,R)). In tracial L^2, left and right
multiplication by z are commuting selfadjoint operators. Their joint
spectral measure and the scalar 1-Lipschitz inequality for g_R give

    ||[d,a]||_(2,tau)<=||[z,a]||_(2,tau).

This is an L^2 statement, not an operator-norm Lipschitz assertion.
The scalar inequalities

    |s-g_R(s)|<=|s|^4/R^3,
    |s^2-g_R(s)^2|<=|s|^4/R^2,
    |g_R(s)|^4<=|s|^4

are valid for every real s and R>0. For a contraction b and any x,
polar decomposition and tracial Cauchy--Schwarz give
|tau(bx)|<=tau(|x|); no b-x commutation is required. Thus (11)-(13)
imply

    ||d||<=R,   ||[d,a]||_(2,tau)<=sqrt(72eta),
    |tau(bd)|<=3/R^3,   |tau(b(d^2-1))|<=3/R^2,
    tau(d^4)<=3.                                           (14)

Fix R>=1 and arbitrary finite E,H in A and sigma>0. Choose eta
so sqrt(72eta)<sigma/2. Lift this d from the auxiliary ultrapower
to selfadjoint coordinate elements of norm <=R. Equation (1) puts
each desired finite inequality, with extra error sigma, on an
omega-large coordinate set. Their finite intersection is nonempty;
one coordinate gives the local d in A.

The same fixed R works for every finite test set and every nuclear
approximation complexity. It is not legitimate to remove the
retained errors 3/R^3 and 3/R^2 while keeping R fixed. The proof
does not do so.

## 7. Transfer: every coefficient, without nuclearity of C

Fix R>=1 and a unital norm-separable C in the target D. Choose
dense sequences (b_k) in its contractive ball and (x_k) in its
selfadjoint contractive ball, with coordinate lifts in the same
balls. At coordinate l apply the local result to the first l lifts,
with tolerance 1/l and the common R. Call the result d_l.
For each fixed k the required bounds hold for every l>=k.
The sequence (d_l) is norm bounded by R, so d=[(d_l)] exists in D.
Equation (1) gives [d,x_k]=0, and the moment errors in (14) hold
for every b_k and every tau in Lambda.

For general coefficients use, uniformly in tau,

    ||[d,x-y]||_(2,Lambda)<=2R||x-y||,
    |tau((b-b_k)d)|<=R||b-b_k||,
    |tau((b-b_k)(d^2-1))|<=(R^2+1)||b-b_k||.

Consequently d commutes exactly with C and the two estimates hold
for **every contraction b in C**, not merely the chosen sequence.
This is the quantifier used in the next section. Coordinate lifts
are chosen separately, not multiplicatively; C need not be nuclear.
For mixed ultraproducts apply the local result of Section 6 inside
A_l at coordinate l. Its constants do not depend on l or on A_l.

## 8. Uniform conditional Gaussian convergence

For every N>=1 construct N elements d_{N,j} by Section 7 with R=N,
successively using C_{N,j}=C*(C,d_{N,1},...,d_{N,j-1}). These are
separable unital algebras. The elements commute with C and with
their predecessors, have norm <=N, and for **every** contractive
b in C_{N,j} and every tau in Lambda satisfy

    |tau(bd_{N,j})|<=3/N^3,
    |tau(b(d_{N,j}^2-1))|<=3/N^2,  tau(d_{N,j}^4)<=3.         (15)

Put s_N=N^(-1/2)sum_j d_{N,j}. Fix real t, tau, and a contraction
a in C. Let P_j=product_{k<=j} exp(it d_{N,k}/sqrt(N)),
u_j=tau(aP_j), and q_N=1-t^2/(2N).
The coefficient b=aP_{j-1} belongs to C_{N,j} and is contractive;
using only a fixed finite set of original coefficients would not
justify this step.

Taylor's integral remainder
|exp(ix)-1-ix+x^2/2|<=|x|^3/6 and Holder's inequality
tau(|d|^3)<=tau(d^4)^(3/4) give

    |u_j-q_N u_{j-1}| <= epsilon_N(t),
    epsilon_N(t)
      =3^(3/4)|t|^3/(6N^(3/2))
       +3|t|/N^(7/2)+3t^2/(2N^3).

For N>=t^2/4, |q_N|<=1. Telescoping and commutation of the row
give

    sup_{tau in Lambda, a in C, ||a||<=1}
      |tau(a exp(it s_N))-exp(-t^2/2)tau(a)|
    <=3^(3/4)|t|^3/(6sqrt(N))+3|t|/N^(5/2)
      +3t^2/(2N^2)
      +|(1-t^2/(2N))^N-exp(-t^2/2)| -> 0.                  (16)

This is uniform in both the trace and the entire coefficient ball.
Neither stochastic independence nor identical distributions was
assumed. The bound ||s_N||<=N^(3/2) is enough: s_N is never used as
a norm-bounded sequence defining an ultrapower element.

For any bounded continuous f, (16) also implies

    sup_{tau in Lambda, 0<=a<=1, a in C}
      |tau(a f(s_N))-tau(a) integral f d gamma| -> 0,        (17)

where gamma is standard Gaussian measure. To prove the precise
uniformity, suppose otherwise, and choose N_k, tau_k, and positive
contractive a_k making the difference at least delta>0. Then
tau_k(a_k)>=delta/(2||f||_infinity)>0. Normalize the positive
functional h -> tau_k(a_k h(s_{N_k})) by this mass. Its spectral
measure is a probability measure on R; positivity follows by
tracially moving a_k^(1/2) to either side. Equation (16) implies
pointwise convergence of its characteristic functions to the
Gaussian one, even though a_k, tau_k, and the spectra vary.
LEVY11 implies weak convergence. Multiply the resulting convergence
of f integrals by tau_k(a_k)<=1 for a contradiction.
This proves (17), slightly stronger than the fixed-coefficient
weak-convergence lemma used in the source.

## 9. Exact relative projection partitions

For m=1 use the unit. For m>=2 take Gaussian quantile intervals
I_1,...,I_m of measure 1/m. Choose disjoint open neighborhoods of
the finitely many finite endpoints, with union U of Gaussian
measure <theta. Linear interpolation across them supplies
continuous f_i:R->[0,1], sum f_i=1, coinciding with 1_{I_i}
off U. Hence

    |integral f_i d gamma-1/m|<theta,
    integral (f_i-f_i^2)^2 d gamma<theta/16.

Choose theta with 2theta<epsilon and 17theta/16<epsilon^2,
and then choose N large by (17), including its use with a=1
and (f_i-f_i^2)^2. The elements v_i=f_i(s_N) are positive
contractions, commute with C, sum exactly to one, and satisfy

    |tau(a v_i)-tau(a)/m|<epsilon,
    ||v_i-v_i^2||_(2,Lambda)<epsilon

for every prescribed finite positive coefficient set (in fact
uniformly over that whole ball by (17)).

Apply the fixed-radius diagonal of Section 1 to m positive
contractions, using tests for their projection defects, their sum,
their commutators with a countable dense positive coefficient
family in C, and their coefficient trace splittings. All finite
tests are satisfiable by the v_i. The resulting p_i are
projections, central over C, and sum to one. They are orthogonal,
since

    0=p_i(1-p_i)p_i=sum_{j!=i}(p_j p_i)*(p_j p_i)

forces each positive summand to be zero. Trace splitting extends
by norm continuity to all positive contractions, and then by
scaling and real/imaginary linear decomposition to every b in C.
Every identity holds at every tau in Lambda.

This proves Theorem V. Applying the same argument to the
mixed-coordinate local transfer in Section 7 proves Theorem M.
All diagonal variables at this last step have norm at most one;
the unbounded family s_N is not among them.

## 10. Review boundary

The full comparison-to-Gamma argument above is a universal proof
candidate with its analytic assumptions exposed. `verify.py`
certifies exact algebra and constants, not operator-algebra
existence by finite sampling. The real Lean run certifies only
the declarations specified in `statement_fidelity.md`; its
certificate must be fresh and hole-free.

The Host-invoked independent Reviewer must assess the analytic
proof, the faithful translation of its algebraic core, the two
primary-source attributions, and the significance/novelty of the
relative mixed-ultraproduct extension. No Reviewer verdict or
`verified_new` classification is supplied by the Engineer.
There is no F_<LABEL> claim because no literal false assertion
has been identified; creating one without a refutation would
misrepresent this outcome.

## Reproduction

From the campaign root, run:

```bash
python3 research/gamma_core/verify.py
```

The script uses only the Python standard library. It checks universal
free-word identities, nonnegative polynomial certificates for clipping
and partition errors, the proof constants and CLT decay powers, and the
ancillary rational example against the retained Jacobian typed result.
It also verifies that the successful real Lean certificate matches the
current source, fidelity document, and latest version of the formal
claim. It refuses to call the analytic C*-algebra theorem kernel-verified.

The real compiler run used Lean 4.31.0, returned exit code 0 with
`proof_holes=[]` and axiom-audit exit code 0, and took 15.828 seconds.
The first development compile failed on the reserved identifier
`prefix` and an associativity rewrite; that failed run is retained as
inconclusive evidence, not treated as a mathematical refutation.
The final source uses `partialSum` and has a fresh successful run.

Independent recompilation uses the official adapter, not an asserted
compiler outcome:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/gamma_core/Main.lean \
  --statement-fidelity research/gamma_core/statement_fidelity.md \
  --claim C_GAMMA_FOURTH --project-root . \
  --artifact-dir research/gamma_core/lean --timeout 110
```

Seven deliberately incorrect in-memory certificate mutations were
rejected: illicit commutative fourth-moment coefficient, wrong
commutator-deficit sign, wrong clipping polynomial, omitted
noncommuting deficit, failed adapter treated as evidence, wrong claim
binding, and a false claim of full analytic kernel verification.
