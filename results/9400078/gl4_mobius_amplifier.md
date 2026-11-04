# Finite Mobius convolution: the joint sum and the missing saving

## Outcome and scope

**No explicit theta>1/11 is proved.** A finite, denominator-free
convolution preserves the coefficient detecting 4t, including when its
length varies with X. Its transformed numerator still contributes
`tau(eta)^21 q^(-21s)`. The available absolute estimate is

    |B_D,G(X,Q)| << X^-h D^(1+h) Q^(11+21h).             (0.1)

For `D=X^kappa` and `Q=X^theta`, its leading exponent is
`11*theta+kappa`. The missing joint saving is at least
`11*theta+kappa-1` powers of X, in addition to control of the actual
residues of the restored ramified factor. Neither estimate is obtained.

The inherited bound remains `t<=5/22`. The construction and the
conditional formulas below are not claimed as a new reduction, a
publishable theorem, or a method-impossibility result. The bounded mission
stops at its specified quantitative scope gate; the campaign remains open.

## 1. Setting and already recorded inputs

Use the family in `gl4_degree20.md`: pi is unitary cuspidal on GL4(A_Q),
Pi=Lambda^2(pi) is cuspidal on GL6(A_Q), and at the fixed prime p>=5,

    pi_p = Ind(sigma |det|^t tensor sigma |det|^-t),
    0<=t<1/2,

with sigma unitary supercuspidal on GL2(Q_p). All induction is normalized.
Write omega=omega_pi. Take a fixed finite set S containing 2, 3 and all
other bad finite places, but not p. Enlarge the excluded auxiliary-prime
set by the finitely many fixed conductor primes when necessary.

For the finite L-functions put

    F_eta^S(s) = L^S(s,R20 tensor eta),
    N_eta^S(s) = L^S(s,Pi,Sym^2 tensor omega^-1 eta).

Here R20 denotes the genuine local parameter representation, not an
asserted global GL20 transfer. Initially on Re(s)>1,

    N_eta^S(s) = L^S(s,eta) F_eta^S(s).

Write a(n), b(n) for the untwisted coefficients of F and N, respectively,
with coefficients at integers divisible by S equal to zero.

The inherited dependencies are recorded before this derivation in
`MATH_STATE.json`, including the two new prerequisite routes:

* `C_GL4_R20` and `C_GL4_COMPARISON` supply the local identity, the
  coefficient radius `limsup |a(p^ell)|^(1/ell)=p^(4t)`, absolute
  convergence on Re(s)>1, and the known comparison 5/22.
  Their Blomer-Brumley input is arXiv:1003.0559v4, Theorem 2 and
  Section 1.2. The earlier exact-local-transfer source limitation remains.
* `C_GL4_CONTOUR` supplies the recorded completed Rankin-Selberg and
  local-factor package, the fixed-place Laurent expansions, good heights,
  and the finite-field estimate `Kl_d(a;q)<<_d q^((d-1)/2)`.
  Its assumption named `DELIGNE_KL20` explicitly states the result for
  every d>=1; here d=21. The needed exponent also appears in
  Blomer-Brumley, Section 4, proof of Lemma 2, independently read in
  `literature/reviewer-contour-inputs.txt`. No new exact-constant claim
  about Deligne's inaccessible original source is made.
* The rank-(1,1) instance of the same completed functional-equation
  package supplies the Dirichlet L-function equation. No symmetric-square
  automorphic transfer or square root of omega is assumed.
* `C_GL4_METAPLECTIC_PERIOD` records Takeda, arXiv:1506.04791v1,
  Theorem 7.1. The independently read statement is preserved in
  `literature/reviewer-takeda-primary-excerpts.txt`: with the bad places
  omitted the numerator is entire when eta^6!=1. It is not a theorem
  about restoring the factor at p.

These are reused, qualified inputs, not new source attributions by this
Engineer. The recorded coefficient-only, inherited-envelope and
normalization-only failed inferences remain retired. No literature
proposition furnishing the joint estimate in Section 7 is in the recorded
input set; no claim that such a proposition cannot exist is made.

Fix g in C_c^infinity([1/2,2]), with g(1)=1, and put X=p^ell.
Constants below may depend on fixed pi,p,S,g and positive contour/error
parameters, never on X,Q,D. A successful theta and kappa would have to be
explicit and work for every sufficiently large ell, not a subsequence.

## 2. A finite convolution that exactly preserves the coefficient

For D>=1 define the p-free polynomial and its p-adapted version by

    U_D,eta(s) = sum_(d<=D, (d,pS)=1) mu(d) eta(d) d^-s,
    M_D,eta(s) = (1-eta(p)p^-s) U_D,eta(s).               (2.1)

This is a finite Mobius convolution of length at most pD. Its coefficients
at d and pd, for p not dividing d, are mu(d) and -mu(d)=mu(pd);
both use the same cutoff d<=D. No approximation to 1/L(s,eta) is
invoked. The polynomial is entire and introduces no Dirichlet L-function
denominator.

Let c_D(n) be the coefficients of N_1^S(s)M_D,1(s). Explicitly,

    c_D(n) = sum_(d|n, d<=D, (d,pS)=1) mu(d)
                [b(n/d) - 1_(pd|n) b(n/(pd))].           (2.2)

At n=p^ell, the only p-free divisor d is 1. The local identity is

    N_1,p(s) = (1-p^-s)^-1 L_p(s,R20).

Consequently b(p^ell)=sum_(j=0)^ell a(p^j), and (2.2) gives

    c_D(p^ell) = b(p^ell)-b(p^(ell-1)) = a(p^ell)         (2.3)

for every D>=1 and ell>=1. This is a formal local-series identity,
not a finite experiment. In particular it remains exact for D depending
on ell. The case ell=0 has c_D(1)=a(1)=1.

For c>1 set B(c)=sum_n |b(n)|n^-c. The inherited convergence of F and
`N_1^S=zeta^S F_1^S` give B(c)<infinity. Convolution and absolute values
give the uniform inequality

    sum_n |c_D(n)| n^-c
       <= B(c)(1+p^-c)
          sum_(d<=D, (d,pS)=1) |mu(d)|d^-c
       <= B(c)(1+p^-c) zeta(c).                         (2.4)

Thus the right-line estimate has no D-power loss. On Re(s)=-h,
in contrast, the available absolute bound is

    |M_D,eta(-h+iu)| <= (1+p^h) D^(1+h).                (2.5)

Confusing these two lines would incorrectly erase the mollifier cost.

## 3. Diagonal extraction and exceptional characters

For auxiliary primes q in [Q,2Q], define eta=chi^2, extending Dirichlet
characters by zero on multiples of q. Let N(Q) count the eligible primes.
The exact full average is

    A_D(X,Q)
      = sum_q 1/(q-1) sum_(chi mod q) conjugate(eta(X))
            sum_n c_D(n) eta(n) g(n/X)
      = sum_q sum_(n^2=X^2 mod q) c_D(n) g(n/X).          (3.1)

For chi^2=1 the Dirichlet-series numerator is
`N_1^S(s)/N_1,q(s)`, not the undepleted Hecke twist; (3.1) implements
this correction automatically. The terms of U divisible by q also
vanish automatically.

If n!=X is in the support of g(n/X), each contributing q divides the
nonzero integer (n-X)(n+X) of size O(X^2). At Q=X^theta with fixed
theta>0, it has O_theta(1) prime divisors in [Q,2Q].
Using (2.3)-(2.4) therefore gives, uniformly in D,

    A_D(X,Q) = N(Q)a(X) + O_(epsilon,theta)(X^(1+epsilon)).
                                                               (3.2)

This does not use coefficient positivity.

Put E_q={chi:chi^12=1}, and let G_q be its complement. There are
gcd(12,q-1)<=12 exceptional characters. Their total normalized mass
`sum_q |E_q|/(q-1)` is bounded. Equation (2.4) consequently proves
directly on the right, including both imprimitive characters,

    |A_D,E(X,Q)| << X^(1+epsilon).

Thus the dense average satisfies

    A_D,G(X,Q) = N(Q)a(X) + O(X^(1+epsilon)).             (3.3)

No estimate for individual exceptional residues is needed or asserted.
Their subtraction inside the transformed kernel below must nevertheless
be retained. A new zero-density exceptional set, if introduced in a
different proof, would require its own weighted contribution bound;
cardinality alone would not estimate a restored local residue.

If `A_D,G(X,X^theta)<<X^(1+epsilon)` held for every epsilon>0 and
all sufficiently large ell, then N(Q) asymptotic to Q/log Q and (3.3)
would give `|a(p^ell)|<<X^(1-theta+epsilon)`. The inherited radius
formula would imply

    4t <= 1-theta.                                      (3.4)

The identity (2.3) is why a varying mollifier does not weaken this
all-ell implication.

## 4. Restoring p and shifting the contour

For eta from G_q, let T contain S,p,q and infinity. At q the nontrivial
primitive twist has local numerator factor 1. Takeda's stated theorem
gives an entire N_eta^T because eta^6!=1. Exact local restoration yields

    N_eta^S(s) M_D,eta(s)
       = N_eta^T(s) L_p(s,R20 tensor eta_p) U_D,eta(s).   (4.1)

The p-factor `L_p(s,eta_p)` is canceled by the first factor of M, but
the R20 factor is not. Its roots beta_j have maximum modulus p^(4t),
with the extreme root occurring simply for t>0. Potential poles obey

    1-beta_j eta(p)p^-s = 0.

They are local vertical lattices, not zeros of a Dirichlet L-function.
They count as actual poles only after cancellations with N_eta^T and U.
No such cancellation, nor a uniform residue estimate, follows from
entireness of N_eta^T.

Take c>1 and an arbitrarily small admissible h>0 as in the reviewed
contour argument. Define R_D,G by the good-height limit of

    sum_q 1/(q-1) sum_(chi in G_q) conjugate(eta(X))
       sum_(rho actual, -h<Re(rho)<c, |Im(rho)|<H)
         Res_(s=rho)[N_eta^S(s)M_D,eta(s) ghat(s) X^s].
                                                               (4.2)

All multiplicities and derivatives of M are included in this residue.
The earlier good-height argument applies: N=F*L^S(eta), and the finite
M is bounded on each fixed vertical strip. For each fixed finite Q,D
the horizontal integrals tend to zero along common good heights.
The height limit is taken before increasing Q or D; it is not replaced
by an unproved absolute sum of individual residues.

The contour identity is therefore

    A_D,G(X,Q) = R_D,G(X,Q) + B_D,G(X,Q),                 (4.3)

where B_D,G is the averaged integral on Re(s)=-h. Uniform bounds for
the vertical integrals do not inherit constants from the choice of
good heights. Equation (4.3) by itself supplies no bound for R_D,G.

## 5. The transformed joint sum, without replacing the numerator degree

For nontrivial eta=chi^2, the recorded functional equations give

    N_eta^S(s)
       = tau(eta)^21 q^(-21s) G_21,eta(s)
                                  N_(eta^-1)^S(1-s).   (5.1)

Indeed the degree-20 equation for F is multiplied by the degree-one
Dirichlet equation. More explicitly, if G_20,eta is the fixed factor
in the reviewed equation for F, then

    G_21,eta(s) = G_20,eta(s)
      * pi^(s-1/2) Gamma((1-s)/2)/Gamma(s/2)
      * product_(l in S)
          (1-eta(l)l^-s)/(1-eta(l)^-1 l^(s-1)).          (5.1a)

The gamma ratio uses that eta is even. The displayed Tate factors are
the correction for the omitted primes S; p is not in this product.
Their denominators are nonzero on Re(s)=-h. The numerator parameter
`1 direct_sum R20` is self-dual, so the dual untwisted coefficients
are again b(n). At q its determinant is 1. This explains both the
21st Gauss power and the q^(-21s) factor. No functional equation of
an alleged lower-degree L-function is assigned to the finite product.

On the left line the remaining fixed factors have the reviewed expansion

    G_21,eta(s) = sum_r h_r(s) eta(r),
    sum_r |h_r(-h+iu)| << (1+|u|)^B,                    (5.2)

over rationals r supported on a fixed finite prime set. Auxiliary q are
coprime to this set. The Tate factors in (5.1a) have uniformly summable
Laurent expansions there; the extra gamma ratio changes only B.

Use `Kl_21(a;q)=sum_(x_1*...*x_21=a) exp(2*pi*i*(sum x_j)/q)`.
For a nonzero residue a put

    K_q,G(a) = 1/(q-1) sum_(chi in G_q)
                                tau(chi^2)^21 conjugate(chi(a)^2).

Expansion of the Gauss sums and character orthogonality give exactly

    K_q,G(a) = Kl_21(a;q)+Kl_21(-a;q)+2/(q-1)
       - 1/(q-1) sum_(chi^12=1, chi^2!=1)
                              tau(chi^2)^21 conjugate(chi(a)^2).
                                                               (5.3)

The sign before 2/(q-1) is positive: each of the two removed principal
square characters has tau(1)=-1 and odd power 21. The last, nontrivial
exceptional sum has at most ten terms. It is part of the kernel,
not an omitted error.

Substituting (2.1), (5.1)-(5.3) gives the actual joint integral

    B_D,G(X,Q) = 1/(2*pi*i) integral_(-h) ghat(s) X^s
      sum_q q^(-21s) sum_r h_r(s)
      sum_(n>=1, (n,q)=1) b(n)n^(s-1)
      sum_(d<=D, (d,pSq)=1) mu(d)d^-s
        [ K_q,G(nX/(rd))
             - p^-s K_q,G(nX/(rpd)) ] ds.               (5.4)

All rational arguments are interpreted in F_q^*. The factor p^-s,
the difference of the two kernel arguments, and the full coefficient
b(n) are indispensable. Neither an unweighted character moment nor a
sum for arbitrary substitute coefficients is (5.4).

Absolute convergence of the n sum on Re(s)=-h, (5.2), the finite d,q
sums and the rapid Mellin decay justify every interchange in (5.4).

## 6. Available bound and controlled truncations

The recorded finite-field estimate gives

    K_q,G(a) << q^10 + q^(19/2) << q^10.                 (6.1)

Here q^(19/2) is the cost of the nontrivial exceptional subtraction:
`|tau(eta)|^21/(q-1)` has that size. The harmless principal correction
is smaller. Summing absolute values in (5.4) now proves

    |B_D,G|
       << X^-h sum_q q^(10+21h)
          sum_n |b(n)|n^(-1-h) sum_(d<=D) d^h
       << X^-h D^(1+h) Q^(11+21h).                      (6.2)

The fixed p factors are absorbed in the allowed constant. This estimate
uses the actual automorphic b(n), but only its absolute convergence;
it proves no phase-sensitive automorphic saving.

The auxiliary truncations have explicit, separate bounds. Write
`E_h=X^-h D^(1+h) Q^(11+21h)`.

* Truncating the dual n sum at Z costs at most
  `O(E_h Z^(-h/2))`, since
  `sum_(n>Z)|b(n)|n^(-1-h)<=Z^(-h/2)B(1+h/2)`.
  For Q=X^theta, D<=X^kappa and any desired C>0, it suffices to take
  `Z=X^A` with
  `A>(2/h)(C-h+(1+h)kappa+(11+21h)theta)`, increased to be positive.
* Truncating the left integral at |u|<=H costs `O_A(E_h H^-A)`
  for every fixed A>0. The polynomial growth in (5.2) is absorbed
  by the smooth cutoff's Mellin decay.
* If a finite r expansion is desired, the fixed rational local factors
  are analytic in fixed annuli around their character unit circles on
  this line. Cauchy's estimate makes their Laurent tails exponentially
  small in the cutoff on their exponent vectors, uniformly up to the
  same polynomial in |u|. An O(log X) exponent cutoff therefore gives
  any prescribed inverse power of X after accounting for E_h.

The d sum is finite from the start. There is no discarded tail of an
infinite inverse Dirichlet L-function and no zero-density approximation
error. These truncation estimates concern (5.4); they are not bounds
for finite-height residue sums or individual Laurent coefficients.
The latter remain governed only by the grouped identity (4.3).

## 7. Complete exponent budget and the precise unproved input

Take `D=max(1,floor(X^kappa))`, kappa>=0, and Q=X^theta. The effective
finite polynomial length is pD, which has the same X exponent since p
is fixed. The exponent in (6.2) is

    E(theta,kappa,h)
       = 11*theta+kappa+h*(21*theta+kappa-1).             (7.1)

For every requested epsilon one may choose an arbitrarily small
admissible h. Thus the available leading budget is 11*theta+kappa.
It reaches at most theta=1/11 with kappa=0; a positive mollifier length
does not disappear on the left line.

For this separated-bound route, the needed new automorphic input is a
bound for the actual expression (5.4) that saves at least

    Delta = 11*theta+kappa-1

powers of X relative to (6.2), up to arbitrarily small epsilon losses.
For example a sufficient, presently unproved estimate would be

    |the integral (5.4)|
       <<_(epsilon) X^epsilon D^(1-rho) Q^(11-sigma),
    (1-rho)*kappa+(11-sigma)*theta <= 1,
    theta>1/11,                                         (7.2)

with explicit exponents and the exceptional correction still present.
The contour h losses must be absorbed uniformly as just described.
This asks for cancellation among mu(d), the actual symmetric-square
coefficients b(n), the two local p terms, and the q-dependent
hyper-Kloosterman phases. No such correlation estimate is supplied by
the finite-field pointwise bound or by coefficient orthogonality.
No published automorphic theorem proving (7.2) is invoked here.

Independently, this route needs

    |R_D,G(X,X^theta)| << X^(1+epsilon),                 (7.3)

or a replacement proof of the combined bound
`|R_D,G+B_D,G|<<X^(1+epsilon)`. The two separate bounds (7.2)-(7.3)
are sufficient, not necessary: cancellation between them is not ruled
out. Incomplete-numerator holomorphy does not prove (7.3), and counting
Dirichlet zeros would not control these restored p-factor residues.

For theta=1/11+eta with eta>0, the missing leading saving is
`kappa+11*eta`, and the desired conclusion would be
`t<=5/22-eta/4`. At the earlier endpoint theta=2/21 it is
`kappa+1/21`, giving t<=19/84 if all obligations were proved.
The latter improves 5/22 by 1/924. Neither eta>0 nor that endpoint is
obtained. In particular, this is not an improvement on the strongest
inherited result; strongest-applicable literature and novelty
verification remain outstanding and cannot replace the analytic gap.

## 8. Exact arithmetic certificate and review boundary

The small Jacobian operation verifies only the limiting exponent budget.
After discovering and inspecting its typed contract, the executed
operation was `optimization.linear.rational_general_optimum.compute`,
with variables theta,kappa in [0,1], objective maximize theta, and row
`11*theta+kappa<=1`. The result is OPTIMAL at `(1/11,0)`, objective
1/11. Its row dual is 1/11 and its kappa lower-bound dual is -1/11;
all stationarity residuals vanish. Analytically the same certificate
is simply `theta<=(1-kappa)/11<=1/11`.

The exact input and complete typed response are
`jacobian/mobius-budget-input.json` and
`jacobian/mobius-budget-output.json`. The response records server
0.14.0, protocol 2025-11-25 and runtime 111 ms. The adapter exited 0,
with no timeout or structured error. Replay from the campaign root:

    /home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation optimization.linear.rational_general_optimum.compute --payload-file research/jacobian/mobius-budget-input.json

This certificate checks arithmetic of the displayed envelope, not the
best possible bound for (5.4), an obstruction to every mollifier, or an
automorphic theorem. No new coefficient-model experiment was substituted
for the requested estimate. The new prose deductions await the normal
independent Reviewer; no publication-level correctness, originality or
significance certification is claimed.
