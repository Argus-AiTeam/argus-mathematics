# Exact audit of the modular checksum construction

## Statement and source boundary

The object under audit is Theorem `thm:checksum` in the October 4, 2026
staged manuscript, `build/sections/checksum.tex:20-44`. For every fixed
constant d > 0, all sufficiently large n, every integer P satisfying
|log_2 P - 0.51772 n| <= 2, arbitrary residues b_1,...,b_n modulo P, and
at most n^d targets, it asserts a retained-independent-phase estimator
with simultaneous additive error at most 1/8 and no failure with
probability 1-o(1), uniformly in the input. Every history is bounded by
2^((0.48996 + 20*10^-8)n + O(sqrt(n))) poly(n + number of targets)
word operations. P need not be prime.

The definitions being audited are the exact rational coefficients and
constants in `filtering.tex`, equations `eq:filter-polynomials` and
`eq:filtering-constants`, the normalized tilted kernel in
`eq:filter-kernel`, and all-finite normalizations in
`lemma:finite-filtering`. The two required continuous moments have
exponents 8.5(Delta-u) and 8.3(a*v-u), threshold 2^0.5168; their finite
counterparts require 2^0.5169. A numerical grid alone establishes neither
continuous integrals nor the quantifier over all sufficiently large P.

The relevant probabilistic claims are coverage in
`lemma:checksum-tables`, exact multiplicity in
`eq:checksum-multiplicity`, the weighted first and second moments in
`eq:checksum-sample-weight`--`eq:checksum-conditional-variance`, and the
unconditional pointwise bound
`eq:checksum-unconditional-domination`. In particular, conditioning on
the good event does not preserve independent uniform phases; a valid
proof must remove that indicator pointwise before applying a product
moment. Inverse multiplicity without coverage estimates only the covered
part of the sum.

This audit does not establish alias extraction, isolation, the September
low-space theorem, or either manuscript's complete running-time theorem.
Those are separate dependency branches and remain open.

## A known insufficient route

The unrestricted uniform-frequency estimator is not the construction
claimed in the manuscript. If K is uniform modulo P and N independent
samples of J_rho(K) are averaged, then phase averaging gives

    E_phi E_K |J_rho(K)|^2 = 2^n,
    E_phi |V_rho|^2 = #{I : sum_{i in I} b_i = rho mod P},
    E_phi,samples |estimate - V_rho|^2
        = (2^n - #{I : sum b_i = rho}) / N.

The first identity uses independence of the phases; the second expands
the subset sum and uses character orthogonality in each phase. For
b_i=0, P>=2, rho=1, the last expression equals 2^n/N. Thus the usual
unrestricted second-moment argument at N approximately 2^0.48996n does
not prove the desired small additive error. This is a limitation of that
argument, not a refutation of `thm:checksum`, and not a lower bound against
every possible uniform-sampling modification.

## Verification theorem

For the displayed degree-six density pair, both continuous moments are
strictly below

    1.429584295 < 2^0.5168.

For every integer P >= 2^256, with every normalization and convolution
replaced by the normalized P-point average, both finite moments are
strictly below

    1.429584295 + 2^-32 < 2^0.5169.

The block-table, inverse-multiplicity estimator in `checksum.tex`
satisfies the full statement of `thm:checksum`, including arbitrary
input residues, composite moduli, retained phases, simultaneous targets,
uniform success, and the bound on every random execution.

The numerical assertions are checked with integer/rational outward
rounding by `verify.py` against the pre-existing data in
`exact_certificate.json`; verification never writes or regenerates that
file. The quantified argument, including the probabilistic use of those
assertions, follows below. Four finite weighted-match algebra
declarations are additionally compiled in Lean 4.31.0, with exit code 0
and no proof holes. This is not a Lean formalization of the analytic or
algorithmic proof. Independent statement-fidelity and mathematical
review are still required.

The quantitative finite-transfer lemma below is stronger than the
manuscript's existential finite-circle threshold: it applies uniformly
to a class of C^1 log densities and gives an explicit error and P0.
No improved Subset Sum algorithm, published novelty, or verification of
the other manuscript branches is asserted.

## 1. Algebra and exact finite arithmetic

All integrals in this report are normalized circle integrals; all logs
are base two unless written ln. Write

    C(x) = integral 2^(r(x+w)+s(w)) dw,
    Y(x) = integral 2^(r(x+w)+s(w)) (r(x+w)+s(w)) dw,
    T(x) = Y(x)/C(x),
    Z_fk = integral 2^(kappa*r),   Z_gk = integral 2^(kappa*s),
    h = log Z_fk + log Z_gk.

The following identities hold on either the continuous or finite
circle, with all operations taken in that same circle:

    K_x(w) = 2^(r(x+w)+s(w))/C(x),
    D(x) = T(x) - log C(x),
    A(x) = kappa * integral K_x(w) r(x+w) dw - log Z_fk,
    E(x) = kappa * integral K_x(w) s(w) dw - log Z_gk,
    u(x) = log C(x) + (kappa-1)T(x) - h,
    v(x) = (2-kappa)T(x) - 2 log C(x) + h.

They follow by substituting the normalized powers, so the normalizers
Z_f,Z_g cancel in u,v. Equivalently, the manuscript's L,B,H obey
D=B-L, u=L+(kappa-1)B-H, and v=(2-kappa)B-2L+H. This also checks the
signs and orientation of the shift x+w.

For any positive densities p,q, concavity of ln gives
integral p ln(q/p) <= ln(integral q)=0. Apply this to K_x versus 1,
the translated f_*, and g_* to get D>=0, D>=A, D>=E on both circles.
Translation preserves normalized finite averages for every integer P;
no field or prime hypothesis is involved.

`verify.py` uses intervals with endpoints in 2^-192 times the integers.
Each arithmetic operation rounds its lower endpoint downward and upper
endpoint upward. Exponentials use the degree-45 Taylor polynomial and
the tail

    |t|^46 / (46! (1-|t|/47)),

after division by powers of two to make |t|<=1, followed by repeated
squaring. Logarithms use d=(y-1)/(y+1), the first 64 terms of
2 sum d^(2j+1)/(2j+1), and the tail

    2 |d|^129 / (129(1-d^2)).

All logarithm domains and divisors are checked. Pi is enclosed by
4(atan(1/2)+atan(1/3)) with 80 alternating terms and its next-term
remainder. Cosines at the first 17 nodes use the degree-24 Taylor
polynomial with remainder |t|^26/26!, then exact reflections.
These are real Taylor and geometric-tail inequalities, not
floating-point library evaluations.

The fixed JSON contains the manuscript's six normalizer enclosures and
33 rows of four node enclosures, including their stated error radii.
The verifier independently bounds the defining finite sums and checks
containment in every stored enclosure. Symmetry supplies the remaining
31 nodes. Evenness of r,s implies evenness of both convolutions and
both final integrands, justifying the endpoint weights 1 and interior
weights 2. Including the printed column radii, each of the two hatted
means is strictly below 1.4295.

The installed Jacobian Gaussian-quadrature contract takes rational
moment prefixes of bounded order and requires rational Gaussian nodes.
It is not a contract for analytic periodic nonpolynomial convolutions,
so no such postcondition is attributed to it. Its full inspected
contract is `jacobian_quadrature_contract.json`. One applicable
primitive was run through the Argus adapter: LOG(2), rational argument
2/1, 128 bits. The exact payload and full typed result are preserved as
`jacobian_payload.json` and `jacobian_result.json`, including protocol
2025-11-25, server 0.14.0, operation id, and status ENCLOSED. The
standalone rational log series also verifies containment in that
reported dyadic enclosure. This primitive is not used as a substitute
for an integral certificate.

## 2. Rigorous continuous moments

For a 2*pi-periodic function analytic on a neighborhood of
|Im z|<=sigma and bounded there by B0, contour shifting gives
|h_hat(k)|<=B0 exp(-|k|sigma). The shifted Fourier coefficients are
absolutely summable. Averaging at N equally spaced nodes retains
precisely multiples of N, so the nonzero retained coefficients sum
in absolute value to at most

    2 B0 / (exp(N*sigma)-1).                         (1)

This proves the analytic trapezoid estimate used here; no unexamined
literature theorem is assumed. The reference in the manuscript is not
needed as a premise of this proof.

Take N=64 and sigma=0.45. Exact interval checks of the absolute cosine
coefficient sums times cosh(j*sigma) give

    |r|<6.50, |s|<8.71,
    |2 r_beta|<18.4, |2 s_beta|<22.4,   beta=0.19.

For real node x, C(x) has strip bound 2^(6.50+8.71), and Y(x) has
bound (6.50+8.71)2^(6.50+8.71). Applying (1) gives absolute inner
quadrature errors at most

    Z_f, Z_g, Z_fk, Z_gk: 4*10^-10,
    C(x):                 3*10^-8,
    Y(x):                 5*10^-7,
    integral 2^(2r_beta), integral 2^(2s_beta): 5*10^-6.

The common normalizer strip bound is 2^(kappa*8.71). The last common
strip bound is 2^22.4. Every comparison in this paragraph is replayed
by the verifier.

Propagate these errors using the smallest enclosed hatted C and
|log x-log y| <= |x-y|/(min(x,y)*ln 2). For the quotient, if hatted
values are c,y with perturbations at most e_c,e_y, then

    |Y/C-y/c| <= e_y/(c-e_c) + |y|e_c/(c(c-e_c)).

The resulting errors in L,B,H are strictly below 10^-7, 2*10^-6,
and 5*10^-9. Substitution in the score identities shows that each
true node integrand is at most 1.00001 times its hatted value.
At x=pi the factor 2+2cos x is exactly zero on both sides.

It remains to justify the outer quadrature of the nonlinear scores.
The enclosed normalizers and shifted integrals give

    integral |f(w+i*beta)|^2 < 1.761,
    integral |g(w+i*beta)|^2 < 1.38.

The same bounds hold for smaller imaginary shifts: real Fourier
coefficients occur in conjugate pairs, whose contributions to the
squared norm are nonnegative multiples of cosh(2k*y). Shifted means
remain one by contour shifting. For z=x+iy with |y|<=2*beta,
shift the convolution contour by -iy/2:

    Q(z) = integral f(x+w+iy/2) g(w-iy/2) dw.

Cauchy--Schwarz after subtracting the product of means gives

    |Q(z)-1| < sqrt(0.761*0.38) < 0.54.

Thus Q is zero free on this strip and has the logarithm branch real
on the real circle. In particular -Re log Q < -log(0.46) < 1.121.
On the half strip, coefficient sums give |r|<2.96, |s|<4.67.
The same split-contour formula applied to QB gives

    |QB| <= sqrt(1.761*1.38)
             (2.96+4.67+log Z_f+log Z_g) < 13,
    |B| < 13/0.46,        H < 0.016.

The numerator uses the analytic polynomial expression
r+s-log(Z_f Z_g); it introduces no additional logarithm branch.
Consequently the real parts of both exponents
8.5(Delta-u) and 8.3(a*v-u) are below 17.6 throughout the strip.
For the second, the identity being checked is

    a*v-u = -(1+2a)L
            + (a(2-kappa)-(kappa-1))B + (1+a)H.

The analytic extension of M^2 is 2+2cos z, not the nonholomorphic
absolute-square expression away from the real circle. It is bounded
by 2+2cosh(0.38)<4.16. Both full outer integrands are therefore
bounded by 2^20. The strict disk bound and compactness modulo the
real period give a neighborhood of the closed strip as required
in (1). Its outer error is less than

    2^21/(exp(64*0.38)-1) < 0.00007.

The certified continuous bound is finally

    1.4295*1.00001 + 0.00007
      = 1.429584295 < 2^0.5168.                     (2)

## 3. A quantitative finite-circle transfer theorem

Here is a generalization independent of analyticity. Let r,s be real,
2*pi-periodic C^1 functions with sup norms at most 3,5 and derivative
sup norms at most 8,12, respectively. Let

    1 <= kappa < 9/8,  0 <= delta <= 1/32,  0 <= a <= 1/16.

Define C,Y,T,u,v as in Section 1 with normalized integrals, and
C_P,Y_P,T_P,u_P,v_P by replacing every integral by its normalized
P-point average. Then, for P>=2, the absolute difference between each
continuous moment and its all-finite counterpart is at most

    2^224/P,                                        (3)

for the two integrands
(2+2cos x)2^(8.5(delta-u)) and
(2+2cos x)2^(8.3(a*v-u)).

Proof. A normalized periodic Riemann sum differs from its integral by
at most 2*pi times the derivative sup norm divided by P. This follows
by comparing the value at the left endpoint with each point of its
interval and integrating the fundamental-theorem bound; the slightly
looser constant 2*pi suffices.

Put H_x(w)=2^(r(x+w)+s(w)). On either circle,

    2^-8 <= C <= 2^8,   |Y/C|<=8,
    |log C|<=8,         |log Z_fk+log Z_gk|<9,
    |u|<18,             |v|<33.

Thus both real exponents have absolute value below 168. Since
1/2<ln 2<1, the w derivatives of H_x and H_x(r+s) are bounded by
20*2^8 < 2^13 and 20*9*2^8 < 2^16. The derivatives of each of the
four normalizer integrands are below 2^10; for the powered ones use
3*kappa<4 and 5*kappa<6. All normalizer, C and Y Riemann errors
are consequently bounded by e=2^20/P.

Both C and C_P are at least 2^-8, without requiring e to be small.
The quotient identity, using |Y/C|<=8, gives

    |T_P-T| <= 2^8(1+8)e.

The log error for C is at most 2^9 e, and the sum of the two
powered-normalizer log errors is at most 2*2^9 e. Hence the error
in either real exponent is at most 2^40/P. These inequalities use
the common positive lower bound of the true and finite quantities,
not an assumed small perturbation of a possibly zero denominator.

For the x derivative, |C'|<=2^11, |Y'|<=2^15. Therefore

    |T'| <= 2^8(2^15+8*2^11) < 2^24,
    |(log C)'| <= 2^20.

Using kappa-1<1/8, 2-kappa<=1 and a<=1/16, the derivative of
either real exponent is at most 2^26. The continuous outer integrand
has derivative bounded by

    (2+4*2^26)2^168 < 2^197.

Its outer Riemann error is at most 2^200/P. At each finite grid
point, the mean-value theorem for 2^t, the exponent bound 168 for
both versions, and the exponent perturbation bound give an
integrand difference at most

    4*2^168*2^40/P = 2^210/P.

Adding these errors proves (3), with room to spare. The verifier
checks the displayed arithmetic using the worst-case parameter
bounds, not just the specific numerical kappa. This proves the
transfer theorem for the entire stated C^1 class.

The displayed trigonometric polynomials satisfy these hypotheses:
their absolute coefficient sums are 2.433 and 4.010, and their
derivative sums are 6.774 and 10.201. Also Delta<1/32 and a<1/16.
At P>=2^256, (3) and (2) give the asserted finite bound and its
strict comparison with 2^0.5169. In the checksum modulus range,
P>=2^256 once eta*n-2>=256.

All score functions are uniformly bounded on both circles. For
example |log K|<=16, |log f_*|<=6*kappa<7,
|log g_*|<=10*kappa<11; the same bounds apply to their K means.
The relative-entropy inequalities give D>=0.

For completeness, fixed-accuracy evaluation is effective, not an
oracle. The formulas in Section 1 and the analogous numerators
with r and s separately have explicit bounded derivatives and
denominators at least 2^-8. Choose a constant mesh to approximate
their continuous integrals to a prescribed fixed accuracy, and a
constant threshold beyond which finite-to-continuous errors meet
the remaining allowance. Above that threshold evaluate this mesh,
the input angle and elementary functions by rational Taylor series.
Below it evaluate the finite sums directly. Mesh sizes, precision
and the threshold depend on the requested fixed accuracy, not P.
Input angles use rational residues divided by P, so arithmetic is
polynomial in log P. The logarithm arguments stay in an explicit
compact positive interval; its geometric log series is uniformly
convergent. This constructs a deterministic rational procedure,
including repeatable results at ties. Its possibly very large fixed
constants are allowed by the sufficiently-large-n theorem.

## 4. Patterns, table coverage, and unconditional sizes

Choose q=ceil(sqrt(n)) blocks with sizes floor(n/q) or ceil(n/q).
Their smallest size is at least sqrt(n)/2 for large n. A concrete
pattern rule first approximates each block mean to error eps/8,
takes the upper endpoint for D and lower endpoints for A,E, then
rounds outward on a grid of step eps/4. The resulting errors are
at most eps/2, in particular eps, and preserve D_j>=0,
A_j<=D_j, E_j<=D_j. Scores lie inside [-32,32], so a fixed grid
has at most 256/eps+3 points. Enumerating all ordered triples for
each block gives

    Q_n <= (256/eps+3)^(3q) = 2^O(sqrt(n)).

The collection, rounding rules, and each pattern's parameters are
fixed before phases are drawn. A frequency's membership, not this
collection, depends on the phases.

For a fixed pattern define U=A+E-D and W=2D-A-E. Then W>=0.
With alpha=1 if W<=Gamma, otherwise Gamma/W, and
H=tau-alpha(D-A), the following exact bounds hold:

    Delta <= H <= tau,
    eta-H+alpha(D-E)=Delta+alpha*W <= tau.           (4)

For B=2^ceil((eta-H)n), the high-digit count is ceil(P/B);
the low-digit count is B. They have sizes at most
2^(Hn+O(1)) and 2^((eta-H)n+O(1)), respectively. Each integer
k<P has exactly one such digit pair. Extra pairs with k>=P are
kept in the counts and rejected only on evaluating contributions.
Their total number is still 2^(eta*n+O(1)).

Fix phases, a frequency k, its own pattern, and a block of size d_j.
Tilt each non-star label so that w=z-theta has density K_x, retaining
star probability 1-alpha. The exact high score, low score, and
log likelihood ratio have means alpha*A(x), alpha*E(x),
alpha*D(x). They are independent across coordinates and bounded
in absolute value by 32. Chebyshev and a union bound give
probability at least 1/2 that all three block averages differ from
their means by at most eps, once

    d_j >= 6*32^2/eps^2.

Pattern error, fluctuation, and deterministic score approximation
cost at most eps each, so both tests pass on that event. The block
likelihood ratio is at most 2^((alpha*D_j+2eps)d_j).
Changing back to the original label law gives acceptance probability
at least (1/2)2^-((alpha*D_j+2eps)d_j). With
R_j=2^ceil((alpha*D_j+4eps)d_j) independent block tables, the
probability of no jointly accepting table is at most

    exp(-2^(2eps*d_j-1)).

The union bound q*P*exp(-2^(2eps*d_min-1)) tends to zero.
This is conditional on arbitrary phases, uniformly in residues.
An accepting table in each block yields a whole-table match.

For a fixed digit and whole-table tuple, its total exact score S
satisfies E_tables 2^S=1 because f_* and g_* are normalized.
Passing all high tests requires S >= (alpha*A-4eps)n;
analogously use E on the low side. There are at most
2^((alpha*D+4eps)n+q) whole-table index tuples. Markov's inequality
and (4) give conditional expected entry counts at most

    2^((tau+8eps)n+O(sqrt(n))).

For the joint score, E_phi,tables 2^(S_high+S_low)=1.
Condition first on all labels: at a non-star coordinate the
independent uniform phase makes the f_* argument uniform, giving
mean one. Averaging the remaining g_* factor over its uniform
shift also gives one. Star coordinates contribute one. Coordinate
independence multiplies these means. This calculation counts
ALL digit pairs; it does not condition phases on a pattern.
Thus the unconditional expected match count is at most

    2^((eta-alpha*U+12eps)n+O(sqrt(n))).

No independence between distinct whole-table tuples is needed.
Markov followed by a union bound over Q_n patterns proves, with
probability 1-o(1), the simultaneous bounds

    each entry count <= 2^((tau+14eps)n),
    L_pi <= 2^((eta-alpha*U_pi+18eps)n).             (5)

Indeed the bad-size probability is at most
2^(-6eps*n+O(sqrt(n))). Intersect this event with coverage and
call it G. Its probability is 1-o(1), uniformly over all inputs.

## 5. Exact multiplicities, coverage, and weighted sampling

For each digit vector store the set of passing table INDICES in
each block. Its whole-table entries are precisely their Cartesian
product. Duplicate table labels retain different indices. For the
unique digit pair representing an integer k, its multiplicity is
exactly the product, over blocks, of the cardinalities of the two
passing-index intersections. The two list generators and retesting
use identical deterministic score approximations, so this is an
integer identity, not an approximation.

Grouping both entry lists by their whole-table keys gives
L_pi=sum_nu a_nu*b_nu. Prefix sums and quotient/remainder index
each high/low pair exactly once. A uniform integer below L_pi
therefore gives a uniform match without enumerating the match set.
Rejected padded pairs and wrong-pattern matches contribute zero.

Conditional on phases and tables in G, every retained frequency
has m_k=mu_pi(k)>=1. Write s for the frequencies k<P in pattern pi,
L=L_pi and z_k=J_rho(k). If L>0, the retained probability of k is
m_k/L, with any remaining probability assigned value zero. Thus

    E X = sum_{k in s} z_k/P,
    E |X|^2 = (L/P^2) sum_{k in s} |z_k|^2/m_k
             <= (L/P^2) sum_{k in s} |z_k|^2.        (6)

The four Lean declarations in `Main.lean` prove the finite algebra
of normalization, the complex first moment, and both statements
about the second moment in (6). They permit arbitrary real
multiplicities >=1, hence include the actual positive integers.
The compiled certificate is
`certificates/C_MATCH_KERNEL-fcb69f31cb4ce864.json`, with the exact
source and fidelity text archived by the official evidence tool.

If L=0, coverage implies s is empty; returning zero is exact.
Without coverage, (6) estimates only the covered support. This
is why coverage is essential and why inverse multiplicity alone
is not a proof of the checksum theorem.

Independent draws with replacement have centered complex errors
whose cross terms have zero expectation. The mean of N draws
therefore has conditional MSE at most the right side of (6)
divided by N. If alpha*U>=Delta, enumerating all matches and
using z_k/(P*m_k) instead sums this pattern exactly on G.

## 6. Original-law error, without a conditioning shortcut

Character orthogonality for every integer P>=2 gives

    V_rho = (1/P) sum_{k=0}^{P-1} J_rho(k),
    |J_rho(k)|^2 = product_i M(x_i(k))^2,
    x_i(k)=phi_i+k*b_i mod P.

Let bar_u,bar_v be the coordinate averages for a frequency in
pattern pi. The pattern approximations imply
|U_pi-bar_u|<=3eps, |W_pi-bar_v|<=4eps.
In a sampled pattern alpha*U_pi<Delta. If W_pi<=Gamma, set
delta_0=Delta-U_pi>0. The difference between the two sides of

    -alpha*U_pi <= -Delta + 8.5(Delta-bar_u)+30eps  (7)

is at least 7.5*delta_0+(30-25.5)eps, hence nonnegative.
If W_pi>Gamma, alpha*a*W_pi=Delta and
a*W_pi-U_pi>0. Since alpha<=1<8.3,

    -alpha*U_pi
       <= -Delta + 8.3(a*bar_v-bar_u)+30eps.        (8)

The rounding allowance is valid because 8.3(4a+3)<30.
Both are pointwise implications for the actual frequency.

Put R_1=8.5(Delta-u), R_2=8.3(a*v-u).
Using (5) with (7) or (8), for EACH k, on every phase/table
outcome (including those outside G),

    1_G 1_{pattern(k)=pi} L_pi |J_rho(k)|^2
      <= 2^((eta-Delta+48eps)n)
             product_i [M(x_i(k))^2 * 2^R_r(x_i(k))].    (9)

Outside G or the selected pattern the left side is zero; the
right side is always nonnegative. Now take expectations under
the ORIGINAL phase law, not its conditional law given G.
At each fixed k the variables x_i(k) are independent uniform
residues for every choice of b_i. The finite moment bound gives
an expected product below 2^(0.5169*n).

Condition first on phases and tables to apply (6), multiply by
1_G, and then use (9) and the original law. With N=2^ceil(tau*n)
and P>=2^(eta*n-2), every sampled-pattern error E_pi,rho obeys

    E[1_G |E_pi,rho|^2]
      <= 2^((-tau-Delta+0.5169+48eps)n+2)
       = 2^(-0.00081952*n+2)
      <= 2^(-0.0007*n)                            (10)

for all sufficiently large n. Direct patterns have zero error on G.
Cauchy--Schwarz over the Q_n patterns bounds the total restricted
MSE by Q_n^2*2^(-0.0007*n). Markov at absolute error 1/16, then
the union bound over at most n^d targets, shows failure probability
at most

    Pr(G^c) + 256*n^d*Q_n^2*2^(-0.0007*n) = o(1).

All constants in these bounds are input independent. There is no
claimed independence between different targets, patterns, or
frequencies, and none is used.

## 7. Uniform bounded implementation and arithmetic

No step enumerates the P Fourier frequencies or all whole tables.
For each digit, test the R_j tables blockwise; if any passing set
is empty, emit nothing, otherwise emit its Cartesian product.
Since D_j is absolutely bounded and d_j=O(sqrt(n)),

    sum_j R_j = 2^O(sqrt(n))*poly(n).

Work before emitting entries is therefore
2^(tau*n+O(sqrt(n)))*poly(n) per pattern by (4).
Stop before either entry list exceeds
C_n=2^ceil((tau+20eps)n). Sorting and prefix sums cost polynomial
work per emitted entry. The count L_pi is at most C_n^2, so it
has O(n) bits even if the implicit match set is huge. Tuple
keys and products of R_j similarly have O(n) bits.

Direct patterns are capped at C_n enumerated matches. On G,
(5) and alpha*U>=Delta give
L_pi<=2^((tau+18eps)n), below that cap. Sampled patterns use
N draws, or immediately return zero if L_pi=0. Each evaluated
match needs only its digit index, pattern test, and blockwise
retesting for its multiplicity, at
2^O(sqrt(n))*poly(n) additional work. Rejected matches are
discarded without invalid division; every sampled match has
positive multiplicity even off G.

The weighted pattern averages, alpha and H are rational with
O(log n)-bit numerators and denominators: grid denominators are
fixed and the averages divide integer sums by n. The ceilings
in all digit and table counts are consequently computable
exactly. Enumerating Q_n patterns and accounting for all targets
gives, on every history, at most

    2^((tau+20eps)n+O(sqrt(n))) poly(n+|targets|)    (11)

word operations in the stated ordinary multiword RAM model.
Aborting on overflow is part of the estimator's allowed failure
output. On G no combinatorial cap is hit.

For an exact uniform draw below an integer q>1, propose
ceil(log_2 q) fresh fair bits and reject out-of-range values.
Acceptance is greater than 1/2 (and is one for powers of two).
Abort after n^3 rejected proposals. A call differs from its
unlimited ideal counterpart with probability at most 2^-n^3;
the bound holds conditional on every preceding adaptive history.
Use such a draw to implement rational Bernoulli table labels
as well. There are 2^O(n)*poly(|targets|) calls on every capped
history, so total coupling loss is o(1) and deterministic work
per call is polynomial. Checksum takes P as input and needs
no random prime selection or primality test.

Retain the integer phases and all reusable block labels. In
forming a complex contribution, reduce exponents modulo P,
then approximate each unit phase to absolute error
delta_num=2^-2n^2 by rational sine/cosine Taylor series.
Their bounded arguments and geometric computation of pi give
polynomial bit complexity. Telescoping the product of n+1
factors bounds its error by

    (n+1)*delta_num*(2+delta_num)^n
       = 2^(-2n^2+O(n)).

On any nonaborted execution the exact rational weights have
O(n)-bit numerators and denominators and magnitude 2^O(n).
Round each contribution to a common dyadic grid with n^2
fractional bits before summation. The number of contributions
and their absolute sum bounds are 2^O(n)*poly(|targets|);
total error is at most

    2^(-n^2+O(n))*poly(|targets|)=o(1).

Division by N only adds O(n) binary fractional bits. Exact
addition uses polynomially many bits per term. For fixed d
and sufficiently large n this numerical error is below 1/16
for every target. Combining it with the ideal 1/16 error,
the caps and the bounded-draw coupling proves the claimed
1/8 error, success 1-o(1), and (11).

## Evidence classification and remaining boundaries

`verify.py` verifies the stored analytic and arithmetic certificate;
`test_verify.py` additionally rejects false node bounds, zero
outer-quadrature error, an unjustified node multiplier, a failed
finite moment inequality, changed source coefficients and missing
coverage. It also checks 2,187 small exact complex weighted-match
configurations with repeated representations and rejected matches.
Those finite checks are experiments, not the universal kernel
proof; that proof is the separate Lean result and (6).

The complete quantified checksum argument is the mathematical
proof above, not just the numerical table or the generic kernel.
No false literal manuscript assertion was established in this
scope, so no refutes judgement is warranted. In particular the
known insufficient uniform-sampling argument is not attributed
to the manuscript.

The initial ledger had no certificate for this mechanism. Relative
to the staged source, this work supplies a replayable rational
certificate, the uniform C^1 transfer (3) with explicit P0,
and a checked complex weighted-match kernel. It does not improve
the algorithmic exponent. The local Wiki search found no
checksum-specific page to reuse. No claim of literature-verified
novelty or independent Reviewer acceptance is made.

The family dependency graph preserves the October isolation,
preliminary-deficiency, alias, and full-composition branches and
the September survival, streams/prefix, resources and separator
branches as open. A passing checksum certificate does not
discharge them. The independent Reviewer must check the source
translation, the analytic contour argument, finite-transfer
hypotheses, coverage and conditional-to-unconditional reasoning,
and the all-history implementation before accepting this result.
