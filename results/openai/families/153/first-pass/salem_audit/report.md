# Independent verification of the quartic-Salem singularity argument

## Result and scope

The multiplier-to-singularity argument in the staged `build/salem.tex` is
valid. In particular its simultaneous quantifiers can be satisfied: one
infinite sequence has the uniform cosine floor, the stated multiplier
growth, sublinear logarithmic losses, and all the required window estimates.
No false manuscript assertion was identified in this audit.

The proof below establishes the literal conclusion of `sal:main` and the
following stronger statement.

**Theorem A (nonstationary independent signs).** Let beta in (1,2) be any
quartic Salem number. For every deterministic sequence
(p_l)_(l>=0) in [0,1], let the signs epsilon_l be independent with
P(epsilon_l=1)=p_l. Then

    Law(sum_(l>=0) epsilon_l beta^(-l))

is singular with respect to Lebesgue measure. The full-mass null set is
allowed to depend on the probability sequence.

Taking every p_l=1/2 gives exactly `sal:main`. The proof uses no stationary
entropy formula, no pure-type theorem, and no implication from Fourier decay
to measure type. The original classification theorem and degree-31 example
are not certified here.

This is a complete human-readable analytic proof with a mechanically checked
universal algebraic/recurrence core, not a fully Lean-formalized singularity
theorem. `verify.py` checks exact algebraic seeds, all rational margins, and
the current real compiler certificate. It does not pretend that checking
finitely many multiplier indices proves an infinite construction.
`statement_fidelity.md` specifies exactly what Lean proves.
Independent Reviewer acceptance and an assessment of publishability/novelty
are still required. The later equal-weight dimension-drop theorem in
arxiv:2610.12072v2 means that unbiased singularity alone is not claimed new;
see `literature_scope.md`.

## 1. Algebraic identities, without a hidden parity assumption

Write the conjugates of beta as beta^(-1), z, conjugate(z), with
z=exp(i theta). The constant coefficient of its minimal polynomial is 1,
so beta is a unit. If theta/pi were rational, z would be a root of unity.
Its irreducible polynomial, also having beta as a root, would divide a
cyclotomic polynomial, forcing beta to be a root of unity. This is impossible.

For positive integers k_h define, exactly as in the manuscript,

    A_m = product_(h=1)^m (beta^(k_h)-beta^(-k_h)),
    b_m = sum_(h=1)^m k_h,
    c_m = product_(h=1)^m (z^(k_h)-z^(-k_h)),
    delta_m = |c_m|,  L_m = log(1/delta_m),
    u_(m,j) = A_m beta^j,                    j in Z.

Then 0<A_m<=beta^(b_m) and delta_m>0. Every u_(m,j) lies in Z[beta],
because beta is a unit. Multiplication by this element preserves the free
rank-four group Z[beta], so its matrix has integer entries. Its trace is the
sum over the four embeddings, giving

    T_(m,j) = u_(m,j)+(-1)^m u_(m,-j)+2 Re(c_m z^j) in Z.       (1)

In particular, the reciprocal embedding sends A_m to (-1)^m A_m,
not to its reciprocal. This sign is essential and agrees with the manuscript.
A rational algebraic integer is an integer (apply the rational-root argument
to a monic polynomial). Thus u_(m,j) cannot be an odd half-integer and its
cosine is nonzero.

Multiplying by the next reciprocal difference gives the exact identity

    u_(m+1,j) = u_(m,j+k)-u_(m,j-k),          k=k_(m+1).         (2)

No inequality or limiting argument is used in either identity.

## 2. One simultaneous multiplier construction

Put D=10/log(beta). All logarithms are natural. We give explicit universal
thresholds for the bootstrap, so that no later choice invalidates an earlier
one.
The numerical estimates below use only pi<4 (for example from
pi=4 integral_0^1 (1+x^2)^(-1)dx) and the nonnegative terms of the
exponential power series.

### 2.1 Return times and the first two exponents

For an irrational alpha=theta/pi, pigeonholing the N+1 fractional parts of
0,alpha,...,N alpha into N equal subintervals gives 1<=q<=N with
||q alpha||<=1/N. Along increasing N the selected q cannot remain bounded:
the positive distances belonging to a fixed finite set have positive minimum.
Consequently there are unbounded q with ||q alpha||<=1/q.

Choose k_1 from these returns so that

    A_1>1,  delta_1<1/16.

This is possible since beta^q-beta^(-q) tends to infinity and
|z^q-z^(-q)|<=2 pi/q.
Define gamma_1=inf_(j in Z)|cos(pi u_(1,j))|.
As j tends to minus infinity these cosines tend to 1. For positive j,
(1) and the pi-Lipschitz bound for the absolute cosine give

    |cos(pi u_(1,j))|
        >= |cos(pi u_(1,-j))|-2 pi delta_1.

Since 2 pi delta_1<pi/8<1, the positive tail also has a positive lower bound.
The remaining finitely many factors are nonzero. Therefore gamma_1>0.
Notice that gamma_1 is fixed before k_2 is chosen.

Choose k_2>k_1 from the same unbounded return sequence. Then

    delta_2<=2 pi delta_1/k_2,
    L_2>=log(k_2)-log(2 pi delta_1).                           (3)

Thus k_2 and L_2 can both exceed any fixed thresholds.
For K_m=ceil(2b_m+D L_m), we need log K_2<=1.1 L_2.
This does not require an upper bound on L_2: (3) gives
k_2<=2 pi delta_1 exp(L_2), and hence

    K_2 <= 2k_1+4 pi delta_1 exp(L_2)+D L_2+1.

Because 4 pi delta_1<1, this is at most exp(1.1 L_2) for sufficiently
large L_2. For example L_2>=max(1,20(D+2k_1+1)) suffices, using
exp(t)>=1+t and
exp(1.1L)-exp(L)>=.1 L exp(L).

### 2.2 An explicit bootstrap, with both branches

Increase the initial threshold to

    L_2 >= T := max(100,16(D+1)).

At level m>=2 suppose L=L_m>=T and log K_m<=1.1L.
Take N=floor(exp(1.9L)), choose the pigeonhole return q, and set

    k = q                         if q>=K_m,
    k = ceil(K_m/q) q              if q<K_m.                   (4)

Here N>=exp(1.9L)/2. In the first branch,

    delta_(m+1) <= 4 pi exp(-2.9L),
    L' := L_(m+1) >= 2.9L-3 >= 2.8L,
    b_(m+1) <= 2 exp(1.9L).                                   (5)

The constant 3 is valid since log(4 pi)<3. In the second branch the
integer multiplier is at most 2K_m; therefore

    K_m<=k<2K_m,
    delta_(m+1) <= 8 pi K_m exp(-2.9L),
    L' >= 2.9L-log K_m-4 >= 1.75L,
    b_(m+1) <= 3 exp(1.1L).                                   (6)

Here log(8 pi)<4. In both branches K_m<=k<=exp(1.9L).
For the second branch use 2 exp(1.1L)<=exp(1.9L), valid already for L>=100.

Now K_(m+1)<=2b_(m+1)+D L'+1. The first contribution is at most
exp(.75L')/2. Indeed the surplus exponent is at least .2L in (5),
and at least .2125L in (6). For L>=100, exp(.2L)>=21>8 and
exp(.2125L)>=22.25>12, which absorb respectively 2*2 and 2*3.
For the second contribution, x=L'>=16(D+1) gives

    D x+1 <= 9x^2/64 <= exp(.75x)/2.                          (7)

The last inequality follows from exp(t)>=t^2/2 for t>=0; the first is
a polynomial inequality, independently proved in Lean. Thus

    log K_(m+1)<=.75 L_(m+1).

The induction now applies at every later index. From m=3, substituting this
improved bound into (6) gives

    L_(m+1)>=2.15L_m-4>=2.1L_m.                               (8)

The other branch gives 2.8L_m. The constants 100 and T are fixed before
iteration. In particular this is a single sequence, not separately chosen
finite prefixes. Also k>=K_m>=2b_m+D L_m, so

    beta^(b_m-k_(m+1)) <= exp(-10L_m).                         (9)

### 2.3 The floor does not impose a circular additional choice

Let gamma_m=inf_j |cos(pi u_(m,j))|. For j<=0, (2) and the Lipschitz
bound give gamma_(m+1)>=gamma_m-pi beta^(b_m-k) on that half-line.
For j>0, apply (1) at level m+1 to reflect to -j. Therefore

    gamma_(m+1)>=gamma_m-pi beta^(b_m-k)-2 pi delta_(m+1).      (10)

For m>=2, (9) applies, and L_m>=1.75^(m-2)L_2.
For a>0, Bernoulli's elementary inequality gives

    sum_(r>=0) exp(-a (1.75)^r L)
       <= exp(-aL)/(1-exp(-.75aL)).                          (11)

For L>=100 and a>=1 the denominator is at least 1/2.
Thus the total decrement starting from gamma_1 is at most

    pi beta^(k_1-k_2) + 2 pi exp(-L_2)
      + 2 pi exp(-10L_2) + 4 pi exp(-1.75L_2).                (12)

All four terms tend to zero along the permitted choices of k_2.
Choose k_2 once so that (12)<gamma_1/10, while maintaining the
previous lower thresholds and also

    2 exp(-L_2)<=gamma_1/(4 pi),
      exp(-10L_2)<=gamma_1/(4 pi).

These are finitely many compatible requirements on k_2.
After making this choice, perform (4) at all later levels and fix
gamma=gamma_1/2. Telescoping (10), or applying the Lean theorem
`uniform_floor`, proves

    |cos(pi u_(m,j))|>=gamma                    for all m>=1,j in Z,
    2delta_m<=gamma/(2 pi),                    for all m>=2,
    beta^(b_m-k_(m+1))<=exp(-10L_m)<=gamma/(2 pi).

The sequence k_m is increasing. Every reciprocal difference factor is at
least beta^(k_1)-beta^(-k_1)>1, so A_m>=1.
This proves every assertion in `sal:construction`, including the index
exceptions m=2 and m=3 exactly as stated.

## 3. Entire cosine loss, not a finite-index proxy

Let f(u)=-log|cos(pi u)|, defined off the odd half-integers, and
S_m=sum_(j<=0) f(u_(m,j)).
For a fixed m the negative tail tends geometrically to zero and f(u)=O(u^2)
near zero, so S_m is finite.

Fix eta=1/100. If |cos(pi u)|>=gamma and |v|<=gamma/(2 pi), the
whole segment has absolute cosine at least gamma/2. On this segment
f''<=4 pi^2/gamma^2 and

    |f'(u)|<= (pi/gamma) sqrt(2f(u)).

Taylor's formula and Young's inequality yield the uniform bound

    f(u+v)<=(1+eta)f(u)+C_0 v^2,
    C_0=(2+1/(2eta)) pi^2/gamma^2.                            (13)

Evenness and integer periodicity of f, followed by (1), give, for m>=2,

    f(u_(m,i))<=(1+eta)f(u_(m,-i))+C delta_m^2,   i>=1.

Consequently, for every n>=0,

    sum_(j<=n) f(u_(m,j)) <= (2+eta) S_m+C n delta_m^2.        (14)

For S_(m+1), use (2), (13), and the geometric sum of the squares of
u_(m,j-k), j<=0. The perturbations obey (9), so (13) is applicable at
every base point, positive indices included. This gives

    S_(m+1)
      <=(1+eta)(2+eta)S_m+C k_(m+1)delta_m^2
                          +C beta^(2(b_m-k_(m+1)))
      <= r S_m+C,              r=2.0301.                    (15)

The last step uses k_(m+1)delta_m^2<=exp(-.1L_m)<=1.
All constants are independent of m and of the phase index.

Starting at m=3, (8) and (15) imply the explicit infinite-sequence bound

    0 <= S_(n+3)/L_(n+3)
      <= (6767/7000)^n
           * (S_3+C/(r-1))/L_3,              n>=0.           (16)

This tends to zero because 6767/7000<1.
The Lean theorem `normalized_loss_tends_to_zero` proves this recurrence
argument for arbitrary real sequences and arbitrary 1<r<g, not a finite
sample. The concrete instance is `manuscript_loss_limit`.
This verifies `sal:loss` and explains exactly why 2.0301<2.1 matters.

## 4. Window count and expectation lower bound

Set J_m=floor(exp(1.5L_m)), H_m=ceil(b_m+D L_m), and

    N_m={H_m+s(2H_m+1):s>=0 integer} intersect [0,J_m],
    M_m=|N_m|.

For m>=3, H_m<=K_m<=exp(.75L_m).
For L_m>=100, J_m>=exp(1.5L_m)/2>=2H_m, and the exact progression count
implies

    M_m >= exp(.75L_m)/12 >= exp(.7L_m),
    M_m <= J_m+1.                                             (17)

For the second lower bound, exp(.05L_m)>=exp(5)>12.
In particular the count is for integer, nonnegative, disjoint windows,
not for a continuum of phase indices.

Initially take equal probabilities. Independence and convergence of the
absolutely convergent sign series give

    E exp(i pi A_m beta^n Y)
        = product_(j=-infinity)^n cos(pi u_(m,j)).

The product is nonzero by the finite loss sum. By (14), (16), and
J_m delta_m^2<=exp(-.5L_m), uniformly for 0<=n<=J_m and sufficiently
large m,

    |E exp(i pi A_m beta^n Y)|>=exp(-L_m/20).                  (18)

The sufficiently large starting index is a single index independent of n.

For arbitrary probabilities, the factor for epsilon_l is

    cos(pi u_(m,n-l)) + i(2p_l-1) sin(pi u_(m,n-l)).

Its squared modulus is

    cos^2(pi u) + (2p_l-1)^2 sin^2(pi u) >= cos^2(pi u).

This identity and its finite product inequality are proved in Lean.
Passing to the limit is valid by bounded convergence of the exponentials.
Thus (18) also holds for every probability sequence, with the same lower
bound and starting index. Its expectations need not be real.

## 5. Centered windows: the additional step for arbitrary biases

Write W_(m,n)=exp(i pi A_m beta^n Y), n in N_m.
For the unbiased law, the manuscript's approximation is correct as written:
replace u_(m,j) by T_(m,j) for H_m<j<=n and discard j<-H_m.
Integer parity makes the first replacement deterministic, since
exp(i pi T epsilon)=(-1)^T for either sign.

For general probabilities one must not pretend that the discarded signs
are mean zero. Put mu_l=2p_l-1. With m,n fixed define real coefficients
d_l as follows, writing j=n-l:

    d_l=u_(m,j)-T_(m,j)     if j>H_m,
    d_l=0                  if -H_m<=j<=H_m,
    d_l=u_(m,j)            if j<-H_m.

The sum D_(m,n)=sum_l d_l mu_l converges absolutely: its left part is finite
and its right part is geometric. Define

    B_(m,n)
      = (-1)^(sum_(j=H_m+1)^n T_(m,j))
          exp(i pi D_(m,n))
          exp(i pi sum_(l=n-H_m)^(n+H_m) u_(m,n-l)epsilon_l).  (19)

This has modulus one and depends randomly only on its displayed window.
The ratio W_(m,n)/B_(m,n) is exactly
exp(i pi sum_l d_l(epsilon_l-mu_l)).
Independence and centering cancel cross terms; the individual variances
are 4p_l(1-p_l)<=1, also verified in Lean. Therefore

    ||W_(m,n)-B_(m,n)||_2^2 <= pi^2 sum_l d_l^2
       <= C_beta (beta^(2(b_m-H_m))+n delta_m^2)
       <= C_beta exp(-L_m/2).                                (20)

For completeness, (1) gives
|u_(m,j)-T_(m,j)|<=beta^(b_m-j)+2delta_m. Squaring with
(a+b)^2<=2a^2+2b^2 and summing the geometric tails bounds the middle
expression by

    pi^2 (3 beta^(2(b_m-H_m))/(beta^2-1)+8n delta_m^2).

Since H_m>=b_m+D L_m, its first term decays as exp(-20L_m).
The other term is at most 8pi^2 exp(-L_m/2).
The estimate holds uniformly over all (p_l), including deterministic signs.
For p_l=1/2, D_(m,n)=0 and B_(m,n) is exactly the manuscript's
window-phase variable. Hence this also verifies `sal:window-error`
without changing the original assertion.

The intervals [n-H_m,n+H_m] for consecutive selected n are disjoint.
Their B variables are independent, even when the probabilities vary with l.
No independence between different levels m is needed.

## 6. Both measure-separation limits and a null set

For any fixed probability sequence choose unit complex rotations

    rho_(m,n)=conjugate(E W_(m,n))/|E W_(m,n)|.

These are well-defined by (18); in the unbiased case they are precisely
the real signs sigma_(m,n) in the manuscript. Set

    F_m(y)=(1/M_m) sum_(n in N_m) rho_(m,n) exp(i pi A_m beta^n y),
    a_m=E F_m(Y)>=exp(-L_m/20).

Independent modulus-one windows have centered mean-square norm at most
M_m^(-1/2). Replacing them by W and subtracting the means costs at most
twice the L2 approximation error in (20). Thus

    ||F_m(Y)-a_m||_2 <= M_m^(-1/2)+C exp(-L_m/4).             (21)

Let I=[-beta/(beta-1),beta/(beta-1)], the support interval.
The ordered frequencies xi_r=pi A_m beta^(n_r) have adjacent gaps at
least pi(beta-1), since A_m>=1 and the n_r are distinct nonnegative
integers. Therefore

    |integral_I exp(i(xi_r-xi_s)y)dy|
        <=2/(pi(beta-1)|r-s|),       r!=s.

The unit-modulus rotations do not affect this bound.
Summing the off-diagonal terms by d=|r-s| and using
sum_(d=1)^(M-1)1/d<=1+log M gives

    integral_I |F_m|^2 <= C_beta (1+log M_m)/M_m.              (22)

Define the compact threshold sets

    E_m={y in I : Re F_m(y)>=exp(-L_m/20)/2}.

Chebyshev's inequality, with (17) and (21), gives

    1-P(Y in E_m)
      <= C (exp(-.6L_m)+exp(-.4L_m)) ->0.                   (23)

The Lebesgue estimate, from (17) and (22), is

    |E_m|<=C (1+L_m) exp(-.6L_m) ->0.                       (24)

These are the actual two required limits, not a proxy such as the decay
of individual Fourier coefficients. In fact (8) makes the right sides
summable in m. For c>0, L_(n+3)>=L_3(2.1)^n
>=L_3(1+1.1n), so exp(-cL_(n+3)) is bounded by a geometric sequence.
Also (1+L)exp(-.6L)<=C exp(-.3L) for L>=0.

Thus E=limsup_m E_m is a Borel null set: the measures of the tail unions
are bounded by the tails of the convergent sum of |E_m|. The sum of the
probabilities of E_m^c is finite, so the probability of infinitely many
such complements is zero by the same tail-union bound. Almost surely Y
lies in all sufficiently late E_m, and hence lies in E.
This proves Theorem A and, by specialization, the exact `sal:main`.
The manuscript's subsequence extraction is also valid; the stronger
summability observation is not necessary to repair anything.

## 7. Exact evidence and limitations

`jacobian_payload.json` and `jacobian_result.json` preserve one bounded
typed `polynomial.roots.isolate` call, including server version and
protocol. It isolates the two real roots of P_1; it is not used as a proof
of the universal singularity statement. The adapter returned normally,
with no timeout or structured error.

`exact_certificate.json` records exact first-return seeds for each of the
two displayed example polynomials, with delta_1^2 in a quadratic number
field, and the rational margins used above. `verify.py` recomputes these
with integer/Fraction arithmetic. A fixed seed is checked against its
actual postconditions, not against an enlarged search range.

The main theorem does not depend on enumerating these two examples.
Sections 1--6 work directly for an arbitrary quartic Salem number in the
stated interval. The executable evidence additionally checks the genuine
Lean compiler output for the universal core and its binding to the
current source and statement-fidelity file.

No literature theorem is an unproved mathematical dependency of Sections
1--6: the pigeonhole step, algebraic trace, analytic perturbation,
probabilistic window estimate, and null-set construction are supplied
explicitly. The sources in `literature_scope.md` only delimit prior work.
The independently searched nonstationary extension has no located prior
statement, but this bounded fact does not establish verified novelty.
No independent Reviewer verdict, full formalization of measure theory,
dimension-drop result, or family-wide classification is asserted.
