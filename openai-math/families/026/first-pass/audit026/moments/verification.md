# A zero-safe verification of the uniform moment bridge

## 1. Statement, scope, and mathematical dependencies

The objects and quantifiers here are those of `prop:mixed-moments` in
the staged `build/sections/03-moments.tex`, and of
`prop:weight-moments` in `04-weights.tex`. All functions, dimensions,
support budgets, the surjection kappa, and D>0, B>=1 are fixed before
X tends to infinity. Put L=log X, M=|Gamma|, and let t be the number of
distinct unmarked numerical shifts. Distinct shifts have absolute
value at most D L^B; the optional prime shift a_0 is distinct from
all unmarked shifts. The total support budget is sigma=sum_r rho_r.

**Verification theorem.** If sigma<1 without a mark, or sigma<1/2
with one mark, the manuscript's mixed-moment formula and its
singleton/double-fiber derivative formula hold, uniformly in the
actual shifts. This includes arbitrary nonempty repeated-shift
fibers and vanishing singular series. Consequently every assertion of
`prop:weight-moments`, including its family-independent detector
constant, follows at tau=1/8.

In fact, retaining an integrable frequency factor in the comparison
below improves the mixed-moment remainder to

    L^(-t) O(L^(-1) (log L)^A).                         (1)

Here A is finite and can be chosen as a function of M alone; all
other fixed data may affect the implied constant and starting X.
The originally claimed L^(-1/2) bound follows immediately. This
refinement is a mathematical consequence of the proof, not an
assertion that a novel publishable bound has been established.

The only substantive external number-theoretic input is ordinary
endpoint Bombieri-Vinogradov (BV), used for the marked case. Its
precise source and hypotheses are in `BV_source_excerpt.md` and the
ledger assumptions `BV_ENDPOINT`, `BV_DENSITY_ENDPOINT`, and
`BV_WEIGHT_ENDPOINT`. Independent source attribution remains for
the Host's Reviewer. Fourier inversion and the zeta facts used below
are recalled with elementary derivations in Section 9; the box mean
is proved here without invoking Gallagher's theorem or the PNT.
Neither short-interval prime distribution nor a two-prime
asymptotic is assumed.

The existing public OpenAI development was inspected as candidate
argument, at commit `4eaee87548250b2682affda7d05d947c05554bae`,
in `LaplaceTransform.lean`, `EulerProducts.lean`, `EulerFactors.lean`,
`ContourSums.lean`, `ContourIntegrals.lean`, `BoxMeans.lean`,
`Detectors.lean`, `WeightMoments.lean`, and `DetectorMoments.lean`.
Its relevant interfaces express additive uniform errors and separate
the fourth-moment condition 4*tau<1 from the detector condition
6*tau<1. That source uses Lean 4.34.1. No theorem from it is assumed,
ported, or claimed to have been compiled here. The proof below also
covers negative shifts directly and gives the explicit refinement
(1); it does not rely on the public natural-shift wrappers.

The shared Wiki index yielded a divisor-chain normalization page,
but not a result about these additive-shift mixed moments. Its
affine-normalization obstruction is not used as a theorem here.
No independent novelty search or transitive public-Lean audit was
performed; neither is silently replaced by the local algebra check.

No false literal manuscript assertion was found in the propositions
under audit. The invalid relative comparison discussed in Section 4
is a route obstruction, NOT an assertion made by the manuscript.
Thus no refutation of either proposition is claimed.

## 2. Uniform arithmetic reduction

For squarefree coordinates d_gamma let q be their least common
multiple. A nonzero product of the test functions implies

    product_gamma d_gamma <= X^sigma,   q <= X^sigma.   (2)

This uses one simplex support budget per factor, not per coordinate.
At each p|q the selected shifts must all agree modulo p. In the
marked case their common residue must differ from a_0 modulo p.
Define rho_delta(d) to be zero for an incompatible tuple, and
otherwise to be product_{p|q}(p-delta)^(-1).

Let A_delta be the sum over squarefree tuples of rho_delta(d), the
Mobius signs, and the test functions. Then, for every fixed N,

    E_X[chi_delta product_r D_Fr] = A_delta + O_N(L^(-N)),             (3)

uniformly in the allowed shifts.

For delta=0, CRT gives one residue class modulo q when compatible,
and hence density 1/q with counting error O(1/X). If M>=1 the number
of positive tuples with product at most Y is at most
Y(1+log Y)^(M-1): fix the first M-1 entries, bound the last by Y
divided by their product, then enlarge the first sums to d<=Y.
Thus the error in (3) is
O(X^(sigma-1)(1+L)^(M-1) product_r ||F_r||_infinity).
Its decay beats every power of L because sigma<1. For M=0 the
unmarked statement is exact.

Here are the additional details for delta=1. Write E_X(q) for the
maximum error in the theta count over the interval
(X+a,2X+a], all |a|<=D L^B and all reduced classes modulo q.
For Q=floor(X^sigma), sigma<1/2, endpoint BV at X and 2X gives
sum_{q<=Q} E_X(q) <<_N X L^(-N). Indeed, removing proper prime
powers costs O(X^(1/2)L^2) per class, and shifting either endpoint
costs O((D L^B+1)L) per class. Multiplying those two costs by Q is
absorbed by every logarithmic saving. The same endpoint comparison
works for the maximum over all shifts; no union bound over shifts
is used.

For fixed K>=1, the stronger weighted statement is

    sum_{q<=Q} mu(q)^2 K^omega(q) E_X(q) <<_N X L^(-N).               (4)

To see this, the elementary progression count and q/phi(q)<=d(q)
give E_X(q) << X/q (L+d(q)). For fixed T,

    sum_{q<=Q} mu(q)^2 T^omega(q)/q
      <= product_{p<=Q}(1+T/p) <<_T L^c_T.

The bound sum_{p<=y}1/p=O(log log(3y)) follows by comparing
1/p <= e p^(-1-1/log y) for p<=y with log zeta(1+1/log y).
Since squarefree q satisfy d(q)=2^omega(q), Cauchy-Schwarz applied
to the nonnegative E_X(q) proves (4), choosing a sufficiently large
saving in the unweighted BV bound.

On a compatible reduced class, the prime-weighted density is
1/phi(q). A nonreduced class contributes exactly zero: a prime in it
would divide q, hence be <=q, whereas its value is
>=X-D L^B>X^sigma>=q for large X. For each squarefree q at most
(2^M)^omega(q) divisor tuples have that least common multiple,
because each prime is assigned to a nonempty subset of coordinates.
Using (4) proves (3). It also covers M=0 via q=1. This proves
`L026_DENSITY`, including negative shifts.

## 3. Exact Euler factors and the number of poles

For each positive-dimensional factor take a smooth compact extension
and let Phi_r be the Fourier transform, with positive phase and
normalization (2*pi)^(-j_r), of exp(sum v) times that extension.
Write Phi=product_r Phi_r, incorporating scalar factors, and set

    w_gamma=1+i*u_gamma,    z_gamma=w_gamma/L,
    z_S=sum_{gamma in S} z_gamma.

Fourier inversion on the orthant gives
F_r(v)=integral Phi_r(u) exp(-sum_gamma w_gamma v_gamma) du.
The transform Phi is Schwartz. Inserting this into A_delta is
absolutely legitimate: the unsigned divisor sum is bounded by

    product_p (1+C_M p^(-1-1/L)) <<_M (1+L)^C_M.                     (5)

This bound follows from rho_delta<=product_{p|q}2/p, the at most
2^M-1 selected subsets at each prime, and
sum_p p^(-1-epsilon)<=log zeta(1+epsilon)<=log(1+1/epsilon).
It bounds the integral on max|u_gamma|>sqrt(L) by O_N(L^(-N))
for every N. We now work on the complementary core.

Let allowed subsets be the nonempty subsets in a single occupied
residue fiber modulo p, excluding the marker's residue if marked.
The exact factor is

    P_p(z)=1+(p-delta)^(-1)
                 sum_{S allowed} (-1)^|S| p^(-z_S).

Let M_i denote the exact numerical equality fibers, which need not
be the residue fibers at collision primes. Put

    B_p(z)=product_i product_{empty != S subset M_i}
                   (1-p^(-1-z_S))^(-(-1)^|S|),
    H_p(z)=P_p(z)/B_p(z).                                           (6)

There are no zero denominators here when Re z_gamma>=0: every
1-p^(-1-z_S) has modulus at least 1-1/p>=1/2. Both H_p and its
products can be controlled independently of P_p(0).

At z=0 the sign sum over the nonempty subsets of ANY nonempty
finite fiber is -1, by product_{gamma in fiber}(1-1)-1=-1.
There are nu_p(H)-delta allowed occupied residue classes, so

    P_p(0)=(p-nu_p(H))/(p-delta),
    B_p(0)=(1-1/p)^t,
    H_p(0)=(1-nu_p(H)/p)(1-1/p)^(-(t+delta)).                       (7)

For delta=1 the last equality uses
(p-1)=p(1-1/p). It holds when nu_p(H)=p as well. In particular, no
extra power of L is introduced for a repeated label or a prime mark.
The sum of the zeta exponents in each NONEMPTY exact fiber is -1:

    sum_{empty != S subset M_i} (-1)^|S| = -1.                     (8)

`Main.lean` formalizes the universal finite-subset identity, (8),
and the rational marked normalization in (7), not just an example
of them. Translating actual congruences to their residue fibers is
the elementary CRT/subset argument above, not a Lean conclusion.

## 4. An additive comparison valid at every collision and zero prime

All constants in this section depend at most on M unless otherwise
stated. For Re z_gamma>=0, finite-product estimates in (6) give

    |H_p(z)| <= exp(C_M/p),
    |H_p(z)-H_p(0)| <= C_M Z (log p)/p,    Z=sum_gamma |z_gamma|.     (9)

For the second bound, differentiate along the straight segment from
0 to z. Each derivative of p^(-z_S) costs at most log p, its modulus
is <=1, the finite denominators stay >=1/2, and the derivative of
each elementary factor costs O_M((log p)/p). These bounds hold
regardless of which exact fibers have collided modulo p.

If all distinct shifts in H are distinct modulo p, the allowed
subsets are precisely those in the individual exact fibers.
Expand each finite factor in the auxiliary variable 1/p. The
coefficient of 1/p in P_p is
sum_{i,S} (-1)^|S| p^(-z_S); the coefficient in B_p is the same.
The replacement (p-delta)^(-1)=p^(-1)+O(p^(-2)) is harmless.
Uniformly for |p^(-z_gamma)|<=1, this gives

    H_p(z)=1+O_M(p^(-2)).                                          (10)

Set Y=max(2,2D L^B). Every collision prime is <=Y, because it divides
a nonzero difference of distinct integer shifts of size <=2D L^B.
Apply the exact additive telescoping identity to the two finite
products of H_p(z) and H_p(0) for p<=Y. Each mixed partial product
has modulus at most exp(C_M sum_{p<=Y}1/p)<<_M (log Y)^C'_M.
Together with (9) and the elementary bound
sum_{p<=Y}(log p)/p=O((log Y)^2), this proves

    |product_{p<=Y} H_p(z)-product_{p<=Y} H_p(0)|
      <= C_M (log Y)^A Z.

For p>Y, (10) shows that both tail products are 1+O_M(1/Y).
Combining the finite and infinite parts additively yields

    |product_p H_p(z)-S(H)|
      <= C (log L)^A (Z+L^(-B)),
    0 <= S(H) <= C (log L)^A.                                     (11)

The exponent A depends only on M; log Y=B log L+O_D(1).
There is NO division by S(H), P_p(0), or H_p(0).
Thus (11) also applies when any local singular-series factor is zero.

For clarity, a relative-comparison route really would fail: for
unmarked distinct shifts 0 and 1, P_2(z)=1-(2^(-z_1)+2^(-z_2))/2.
Its value at zero is 0, while at z_1=z_2=1 it is 1/2. This
obstructs a ratio through P_2(0), but does NOT refute the manuscript,
which uses additive telescoping. This exact obstruction is recorded
separately, rather than relabelled as a false manuscript assertion.

## 5. Fourier evaluation and the improved uniform remainder

Absolute Euler products, since Re z_S>0, give

    product_p B_p(z)=product_i product_{empty != S subset M_i}
                         zeta(1+z_S)^((-1)^|S|).

The Laurent expansion zeta(1+z)=z^(-1)(1+O(|z|)), uniformly in
a fixed disk about zero, applies on the core for large X. Set

    K_i(w)=product_{empty != S subset M_i}
                      (sum_{gamma in S} w_gamma)^((-1)^(|S|+1)),
    K(w)=product_i K_i(w).

By (8), the exact power of L is L^(-t). The relative error in the
finite zeta product is O_M(Z), not merely its core supremum
O_M(L^(-1/2)). Thus on the core

    product_p B_p(z)=L^(-t) K(w) (1+O_M(Z)).                         (12)

Every subset sum in a denominator has positive integer real part,
so |K(w)| has at most polynomial growth in u, for every fiber
size, not just for sizes one and two. Therefore

    C=integral_{R^M} Phi(u) K(w) du                                (13)

is absolutely convergent. It is real by conjugation under u -> -u.
For |u_gamma|<=sqrt(L),
Z<=C_M(1+max|u_gamma|)/L. Multiplying (11) and (12), then integrating,
is justified by the FINITE Schwartz seminorm
integral |Phi K|(1+max|u_gamma|) du. Since B>=1, the resulting
error is O(L^(-t-1)(log L)^A). Restoring the tails from (5), and the
tail of (13), costs O_N(L^(-N)); choose N>t+2.
Combining with (3) proves (1), and hence the proposition's stated
bound. This proves `L026_FOURIER` and `C026_UNIFORM_MOMENTS`.
The stronger bound is not obtained by replacing a supremum
without justification: the displayed Schwartz seminorm is exactly
what makes that replacement valid.

The constant contains neither delta nor the numerical shifts.
It is also independent of the chosen extensions. To check the
latter explicitly, use the proved asymptotic for two extensions
on one fixed admissible shift set: take all shifts to be distinct
multiples of the product of primes <=t+delta, assigning 0 to the
mark when present. Its local factors are all positive and its
singular series is positive. Both asymptotics concern the same
orthant divisor sum; subtracting them and letting X grow forces
the two constants to agree. These fixed shifts eventually satisfy
any of the stated bounds with D>0 and B>=1.

When Gamma is empty, t=0 and C=product_r F_r. The unmarked average
is exact and the marked error is O_N(L^(-N)) from q=1 in BV;
S(empty)=S({a_0})=1 as appropriate. These cases are separate and do
not require applying a nonempty-fiber identity to an empty fiber.

For singleton and double fibers the kernels simplify to

    K_{single}=w_gamma,
    K_{double}=w_gamma*w_eta/(w_gamma+w_eta)
              =w_gamma*w_eta integral_0^infinity
                                  exp(-(w_gamma+w_eta)y) dy.

After absolute values the new integration variables contribute
exp(-2 sum y); all remaining u factors are a fixed polynomial
times a Schwartz function. Fubini and differentiation of Fourier
inversion are therefore justified. They give exactly

    C=integral product_r [(-1)^j_r partial_1...partial_j_r F_r]
                           ((y_{kappa(r,l)})_l)
                  product_{i:|M_i|=2} dy_i,                        (14)

with y_i=0 on singleton fibers. No independence of coordinates
inside an individual F_r is assumed, including when both labels of
a double fiber belong to the same F_r.

## 6. Uniform box mean of the singular series

Here s and K are fixed; s=0,1 are exact. For s>=2 put
y=(log h)/16 and Q=product_{p<=y}p. One needs only Q<=h^(1/2),
not the prime number theorem. Indeed primes n<p<=2n divide
binomial(2n,n), so theta(2n)-theta(n)<=2n log 2.
Summing on dyadic intervals gives theta(y)<=4(log 2)y;
hence Q<=h^((log 2)/4)<=h^(1/2) for large h.

Define S_y on ALL tuples, even colliding ones, by
product_{p<=y}(1-nu_p/p)(1-1/p)^(-s), retaining exponent -s.
Its exact mean over uniform residues modulo Q is 1: modulo each
prime introduce an independent uniform x, and use

    E(1-nu_p/p)=Pr(a_i != x for all i)=(1-1/p)^s.

CRT multiplies the local means. Each length-h interval has
total-variation discrepancy O(Q/h) from uniform residues modulo Q,
so the product of s such distributions has discrepancy O_s(Q/h).
Also 0<=S_y<<_s (log y)^A_s. Removing the O_s(h^(s-1))
tuples with equal coordinates therefore leaves normalized mean

    1+O_s(h^(-1/2)(log y)^A_s).

For a distinct tuple let Delta=product_{i<j}|a_i-a_j|. For
y>2s the tail T_y=product_{p>y}(1-nu_p/p)(1-1/p)^(-s)
is positive and

    |log T_y| <= C_s(1/y + sum_{p>y,p|Delta}1/p)
              <= C_s(1/y + log Delta/(y log y)).

Since log Delta<=binomial(s,2)log(Kh), this is uniformly
O_{s,K}(1/log log h). The identity S=S_y*T_y is valid even
when S_y=0; it is not a quotient by S_y. Using the nonnegative
truncated mean proves `L026_BOX_MEAN` with the manuscript's
stated rate. There is no assumption about primes in the intervals.

## 7. Summing errors and the three quadratic limits

An equality pattern with t distinct unmarked shifts has O(h^t)
assignments when h=floor(lambda L). Its total unmarked error is
O((h/L)^t L^(-1)(log L)^A)=o(1). With an additional distinct
summed prime shift and its normalization 1/L, the bound is
O((h/L)^(t+1) L^(-1)(log L)^A)=o(1). The original weaker
L^(-1/2) estimate would also suffice. For any fixed family there
are only finitely many equality patterns; rates and the starting
X may depend on that family. No limit in growing dimension is taken.

The cumulative F_j has a smooth compact extension: first extend
f_j by zero, take its cumulative integral on all of R^j, and
multiply by smooth coordinate cutoffs equal to 1 for v>=0 and 0
for v<=-1. Upper-coordinate support bounds already come from f_j.
On the orthant its simplex budget is tau and
(-1)^j partial_1...partial_j F_j=f_j. This derivative vanishes
on every coordinate face because f_j has compact interior support.

In Z^2, a shift in the symmetric difference of its two subsets is a
singleton. Formula (14) therefore makes that pattern's coefficient
zero. Equal subsets S=T of size j have coefficient ||f_j||_2^2.
Their singular-series sum is 1/j! times the ordered distinct
j-tuple sum. The box mean and h/L -> lambda give

    E_X Z^2 -> w=sum_{j=0}^k lambda^j/j! ||f_j||_2^2.

A mark a in J is external to every subset in I. The same matching
rule gives

    E_X[Z^2 V_J] -> lambda*w.

For an internal prime mark a in I, m+a>X>X^tau for large X.
The only surviving divisor in that coordinate is 1. Deleting a
from every subset containing it is a bijection, not j+1 choices:
on that prime event it replaces F_j by
F_j+F_{j+1}(. ,0). Its signed complete derivative is
f_j+T f_{j+1}, with the same simplex budget and face vanishing.
There are h*binomial(h-1,j) choices of (a,U). Equivalently their
singular-series sum is 1/j! times the ordered distinct (j+1)-tuple
sum in I. This last formulation is important: it applies the box
lemma to I, NOT to the punctured noninterval I minus {a}.
It proves

    E_X[Z^2 V_I] ->
      lambda sum_{j=0}^k lambda^j/j! ||f_j+T f_{j+1}||_2^2.

The j=0 term is lambda*|f_0+integral f_1|^2, with no missing
dimension factor.

## 8. Fourth moment and a family-independent detector

For Z^4 the fixed finite number of patterns can have fibers of
size up to four. Section 5 establishes finiteness of EVERY such
kernel coefficient; (14) is not used for larger fibers. For a
pattern with t distinct shifts, its total absolute main
contribution is bounded by a fixed constant times
L^(-t) sum S(H)=O(1), by nonnegativity and the full box mean.
Ordering/subset restrictions only decrease that nonnegative sum.
Its total error is o(1). Thus E_X Z^4=O_{lambda,k,f}(1).

For the detector fix G as in the manuscript and
c_G=integral_0^infinity |G'|^2. At a relevant prime,
D_G(m;b)=G(0)-G(log(m+b)/L)=1. Put
q_X=log(2X+2h)/L=1+o(1). Pointwise, also at composites,

    theta(m+b)/L <= q_X D_G(m;b)^2,
    (theta(m+b)/L)^2 <= q_X theta(m+b)/L.

As Z^2 is nonnegative, the diagonal of V_J^2 is bounded by
q_X E_X[Z^2 V_J]. Its ordered off-diagonal is bounded by

    q_X^2 sum_{b,c in J, b!=c}
                   E_X[Z^2 D_G(m;b)^2 D_G(m;c)^2].                 (15)

This is an UNMARKED six-factor estimate. Every b,c is external
to the weight subsets. Each forms a double fiber, contributing
integral |G'|^2=c_G by (14). Weight subsets must again match;
their common size j contributes ||f_j||_2^2. The singular-series
mean applies to j coordinates in I and two ordered coordinates
in J, with the normalization 1/j!. Since
h(h-1)binomial(h,j)/L^(j+2) -> lambda^(j+2)/j!, (15)
tends to lambda^2*c_G^2*w. Hence

    limsup E_X[Z^2 V_J^2] <= (lambda+lambda^2*c_G^2)*w.

This constant does not depend on k or f. Convergence rates need
not be uniform across those choices. If w=0 all the continuous
f_j, including f_0, are identically zero, so Z=0 and the same
bound holds without a positive-mass assumption.

For clarity the exact worst-case support ledger is below. A scalar
factor has budget zero; each positive-dimensional weight factor
uses at most tau, not its dimension times tau.

| Use | Mark count | Upper budget | Required threshold |
|---|---:|---:|---:|
| Z^2 | 0 | 2*tau=1/4 | <1 |
| Z^2 times one prime mark | 1 | 2*tau=1/4 | <1/2 |
| Z^4 | 0 | 4*tau=1/2 | <1 |
| Detector off-diagonal | 0 | 6*tau=3/4 | <1 |

No budget is multiplied by the dimension of F_j. No use is made
of an unavailable two-prime-mark estimate. This completes the
mathematical proof of `C026_WEIGHT_MOMENTS`.

## 9. Basic analytic facts and the certification boundary

The Fourier facts used here follow directly for a compact smooth
function f on R^M. Repeated integration by parts shows that its
Fourier transform and every derivative decay faster than any
polynomial. For inversion, multiply the transform by
exp(-epsilon |u|^2), interchange the absolutely convergent
integrals, and evaluate the Gaussian integral. The result is
convolution with an approximate identity, which tends to f.
Dominated convergence on the transform side proves inversion;
the same argument after differentiating proves the derivative
formula used above.

For Re s>1, unique prime factorization and absolute convergence
give the Euler product for zeta(s). For Re z>0,

    zeta(1+z) - 1/z
      = sum_{n>=1} [n^(-1-z)-integral_n^(n+1) x^(-1-z) dx].

The summands, and their derivatives on compact subsets, are
O(n^(-2-Re z) (1+log n)^m); this follows by differentiating
x^(-1-z) once in x. The series is holomorphic near z=0, for
example |z|<1/4, by uniform convergence on compact subsets.
It is bounded on a smaller closed disk. This proves the
Laurent expansion and uniform error used in (12), without a
zero-free region or the PNT. The bound
zeta(1+epsilon)<=1+1/epsilon for real epsilon>0 is the integral
test. The elementary reciprocal-prime estimate in Section 2
then supplies every needed logarithmic product bound.

`verify.py` replays rational collision and zero-factor checks,
generic first-order cancellation, small-fiber kernel identities,
the exact support thresholds, and the retained typed Jacobian
profile. Its finite enumeration is explicitly bounded, not a
proof for all dimensions. The universal finite-subset and
marked-normalization statements are the separate Lean claim
`L026_EULER_CORE`, with the exact reading in
`statement_fidelity.md`. The official compiler record is required
to report exit_code=0 and proof_holes=[].

The analytic estimates in Sections 2-9 remain a PROSE proof
using the cited BV theorem, not machine-checked analysis.
Independent mathematical review, independent citation
attribution, novelty, significance, and campaign acceptance
are not supplied by an Engineer's executable or a Lean
certificate for the local algebra. No project-final
publishability or independent-review verdict is asserted here.

Reproduction from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/audit026/moments/verify.py

The compiler invocation is retained in `lean_verification.json`;
its archived certificate is named in `exact_certificate.json`.
Independent citation attribution is still open. The citation tool
archives under `research/literature/`, outside this bounded mission's
writable paths, so the Engineer has not invoked a writing citation
operation or manufactured an attribution record.
