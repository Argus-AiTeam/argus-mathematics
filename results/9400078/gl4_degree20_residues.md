# Grouped residues for the degree-20 quotient

## Outcome and verification boundary

The requested `O(X^(1+epsilon))` residue estimate is **not proved**.
This continuation gives a contour-grouped interpretation that includes
multiple poles, proves the transformed-integral estimate from the standard
analytic inputs below, and determines exactly what the inherited bound
supplies:

    Q = X^(2/21),    R_group(X,Q) << X^(232/231+epsilon).

The excess exponent is `1/231`. In this framework the requested stronger
residue bound is equivalent to `t <= 19/84`; estimating residues by the
inherited bound does not improve that bound. This is a diagnostic and an
analytic partial argument, not a publishable improvement or an impossibility
theorem. The new analytic argument has not yet passed independent review.

The notation and the previously reviewed algebra are those of
`gl4_degree20.md`. In particular `X=p^ell`, and `a(n)` are the coefficients
of the incomplete degree-20 quotient, with the factor at p retained.
The fixed finite set S can include all other bad primes, including 2 and 3.
The function g is smooth, supported in [1/2,2], with g(1)=1.
All constants may depend on pi, p, S, g, and epsilon, but not on X or Q.

### Imported analytic inputs

The dependency ledger records these separately from the conclusions:

1. The completed Rankin-Selberg continuation, functional equation and
   finite-strip boundedness for unitary cuspidal pairs, including their
   finite-order twists. Cogdell's Fields manuscript, Lecture 9,
   Definition 9.1 and Theorems 9.1-9.2, supplies a first-hand exposition.
   The finite-part polynomial growth used below is derived, not quoted
   as a conductor-uniform theorem.
2. The standard local Rankin-Selberg factors, their multiplicativity and
   unramified-twist formulas. The exact original proposition-level source
   for this complete local package remains outstanding. The unramified
   auxiliary-prime Gauss calculation is explained below.
3. Deligne's finite-field estimate
   `|Kl_d(a;q)| <= d*q^((d-1)/2)`, for d>=1 and a nonzero.
   The source worker read the original theorem's re-typesetting,
   Section 7.1 (7.1.3), Theorem 7.4 and Section 7.5; original pagination
   and independent attribution remain unchecked. Blomer-Brumley,
   arXiv:1003.0559v4, Section 4, proof of Lemma 2, also states and uses it.

The source readings and retrieval limitations are in
`literature/gl4-contour-inputs.txt`. No citation has been self-certified.
The results below are deductions from these standard inputs and the
previous comparison calculation. No new global transfer is assumed.

## 1. The imprimitive square-character correction

For every auxiliary odd prime q outside S and distinct from p, define

    H_(q,chi)(s)
      = sum_n a(n) chi(n)^2 n^-s,
    D_(q,chi)(X)
      = (1/(2*pi*i)) integral_(c) H_(q,chi)(s) ghat(s) X^s ds,
      c>1.

Dirichlet characters are extended by zero on multiples of q.
If eta=chi^2 is nontrivial, it is primitive of conductor q, and
`H_(q,chi)=F_eta^S`.
If chi^2=1, there are exactly two such chi, and instead

    H_(q,chi)(s) = F_1^S(s) P_q(q^-s),
    P_q(q^-s) = L_q(s,R20)^-1.

Thus a principal square character is NOT the full trivial Hecke twist:
its q-Euler factor must be removed. This corrects that convention in the
preceding note without changing the amplifier or its diagonal coefficient.

Character orthogonality now gives the exact equality

    A(X,Q)
      = sum_q (1/(q-1)) sum_chi conjugate(chi(X)^2) D_(q,chi)(X).

Throughout, the sum on q is over the eligible primes in [Q,2Q].
Its cardinality is N(Q).

## 2. A left boundary with uniform local control

Take delta>0 arbitrarily small, avoiding the finitely many real pole
locations of the fixed local gamma factors in -1<Re(s)<0. The characters
eta=chi^2 are even, so the archimedean factors are independent of chi.
At each fixed finite place they are unramified twists. The real parts
of the possible local poles consequently do not depend on q or chi.
The line Re(s)=-delta can therefore be chosen once for the fixed pi.

For a primitive eta modulo q the Rankin-Selberg functional equations give

    F_eta^S(s)
      = tau(eta)^20 q^(-20s) G_eta(s) F_(eta^-1)^S(1-s).       (2.1)

Here tau(eta)=sum_(u in F_q^*) eta(u) exp(2*pi*i*u/q), with a consistent
global/local character convention. Changing that convention conjugates
the Gauss sums and reverses the arguments below, without changing any bound.
The self-duality of both endomorphism parameters identifies the dual
untwisted quotient with itself. No self-duality of pi or Pi is required.

Why the exponent in (2.1) is 20:
at q, both original parameters are unramified. Their endomorphism
parameters have dimensions 36 and 16 and determinant 1. Twisting any
one-dimensional unramified constituent by a conductor-q character gives
the factor `q^-s tau(eta)`, multiplied by its unramified value.
Multiplication over the constituents cancels those values by determinant 1.
Taking the quotient gives `q^-20s tau(eta)^20`.

The one-dimensional formula follows directly by Fourier transforming
`conjugate(eta(x))*1_(Z_q^*)(x)`: its transform is supported on
`q^-1 Z_q^*`, and on that shell is `q^-1` times a Gauss sum times a unitary
character. Substitution in the local Mellin functional equation gives
`q^-s tau(eta)` in the corresponding global convention.
This is the same local computation as (3.7) and the Gauss calculation
in Blomer-Brumley, but multiplicativity is applied to dimensions 36 and
16 rather than substituting a new degree into their global theorem.

On Re(s)=-delta, the remaining fixed factors have an expansion

    G_eta(s) = sum_(r in Z[S_0^-1]^*) h_r(s) eta(r),
    sum_r |h_r(-delta+iu)| << (1+|u|)^B.                     (2.2)

Here S_0 is a fixed finite set of rational primes, r is nonzero and has
prime factors only in S_0, and B and the implied constant depend on pi
and delta. A negative r is harmless since eta is even.

To justify (2.2), the fixed epsilon factors are monomials in eta(l)
times constants and fixed conductor powers. At removed finite places,
the remaining factors are rational functions of eta(l) and l^-s.
Our choice of delta puts their poles a fixed positive distance from the
unit circles in the eta(l) variables. Each therefore has an absolutely
summable Laurent expansion, uniformly in Im(s). Multiplying these finitely
many expansions gives (2.2). Stirling's formula bounds the fixed
archimedean gamma ratio polynomially in |u|. This treatment uses the
actual local Rankin-Selberg factors at 2 and 3, not an unproved
exterior-square compatibility statement there.

Absolute convergence gives, uniformly in eta,

    sum_n |a(n) eta(n)| n^(-1-delta) <= C_(pi,delta).         (2.3)

The functional equation and (2.2)-(2.3) imply that H_(q,chi) is holomorphic
on the chosen left line and grows at most polynomially there.
The integrals on this line are absolutely convergent against ghat.

## 3. The infinite-height limit and multiple poles

Define the finite-height sum using **all actual poles** of H_(q,chi)
between Re(s)=-delta and Re(s)=c, not just zeros of a chosen denominator:

    R(X,Q,T)
      = sum_q (1/(q-1)) sum_chi conjugate(chi(X)^2)
        sum_(-delta<Re(rho)<c, |Im(rho)|<T)
          Res_(s=rho) [H_(q,chi)(s) ghat(s) X^s].            (3.1)

An algebraically removable singularity contributes nothing. Numerator poles,
finite-local-factor poles, and higher-order poles are included when present.
The boundaries are chosen off all poles.

For clarity, if the principal part of H at rho is
`sum_(j=1)^m b_(-j)(s-rho)^(-j)`, then its residue in (3.1) is exactly

    X^rho sum_(j=1)^m b_(-j)
      sum_(r=0)^(j-1)
        [ghat^(r)(rho)/r!]
        [(log X)^(j-1-r)/(j-1-r)!].                         (3.2)

This is the coefficient of (s-rho)^-1 in the product of the Laurent
and Taylor series. It requires neither simple zeros nor a bound for
the reciprocal of any derivative of a denominator.

### Good-height lemma

For each fixed finite collection of these twists, there is a sequence
`T_j in [j,j+1]` tending to infinity on which every H_(q,chi) has
polynomial size, uniformly along both horizontal sides of the strip.
The power and constants in this lemma may depend on that finite collection.

Here are details, so this is not an implicit reciprocal-derivative assumption.
After multiplication by polynomials removing the finitely many global poles,
write each H as A/B with A and B entire and of polynomial growth in every
fixed vertical strip. Fixed local Euler polynomials can be put in A or B.
At a real part b>1 sufficiently far right, B(b+iu) is bounded away from
zero, up to the harmless pole-removing polynomial: the Euler products and
the finite local factors converge absolutely and are nonzero there.

The stated polynomial growth of the finite Rankin-Selberg parts follows
from the imported completed boundedness and Stirling, which initially give
exponential growth in a fixed strip. On a right boundary, absolute
convergence gives a uniform bound. On a left boundary, the functional
equation, Stirling and absolute convergence of the dual series give a
polynomial bound. Phragmen-Lindelof, after removal of the finite poles,
then gives polynomial growth between them. No conductor-uniform
Phragmen-Lindelof constant is needed for this good-height lemma.

Apply Jensen's formula in a disk of fixed large radius centered at
`b+i(j+1/2)`. The preceding upper bound and the lower bound at its center
show that there are O(log j) zeros of B in a slightly smaller disk,
counted with multiplicity. Choose the radii so that a further smaller disk
contains the horizontal segment of interest. Factoring these zeros by a
finite Blaschke product and applying Harnack's inequality to the zero-free
factor shows on the smaller disk that

    log(1/|B(s)|)
      <= C log j + sum_rho log^+(1/|s-rho|).                (3.3)

For completeness, on the boundary of the Blaschke disk its product has
modulus 1. The quotient is nonvanishing, has polynomial upper bound, and
its value at the center is bounded below. Harnack applied to a constant
minus its logarithmic modulus gives a polynomial lower bound on the
smaller disk. Each Blaschke factor is bounded below there by a fixed
constant times min(1,|s-rho|). This proves (3.3).

For any real gamma,

    integral_j^(j+1) log^+(1/|T-gamma|) dT <= 2.

Summing over the zeros in question, over the finite twist collection,
and over the analogous disks at negative heights, gives an integral
O(log j). There is therefore a common T_j for which this sum is O(log j).
Since |sigma+iT_j-rho| >= |T_j-Im(rho)|, (3.3) gives a polynomial bound
for every reciprocal B along the entire horizontal segments. Repeated
zeros are counted repeatedly and cause no change in this argument.

The Mellin transform of a compactly supported smooth g decreases faster
than every power, uniformly on this finite strip. For fixed X and Q,
the integrals over those horizontal segments tend to zero. The residue
theorem and absolute convergence on the two vertical lines now prove

    R_group(X,Q) := lim_j R(X,Q,T_j) = A(X,Q) - B_left(X,Q),  (3.4)

where

    B_left(X,Q)
      = sum_q (1/(q-1)) sum_chi conjugate(chi(X)^2)
        (1/(2*pi*i)) integral_(-delta)
          H_(q,chi)(s) ghat(s) X^s ds.

Every admissible sequence whose horizontal integrals vanish gives the
same value (3.4). The heights may depend on Q: the limit is taken first
for each finite character family. The bounds for (3.4) below are uniform
in X and Q and do not inherit constants from this height selection.

This is explicitly a **contour-grouped limit**. Absolute convergence of
the individual residue series, or convergence as T passes through every
real height without grouping, has not been proved. Such a stronger claim
would require further control of closely spaced zeros. No interchange of
the limits T->infinity and Q->infinity is used.

## 4. The averaged transformed boundary is within budget

First restrict to chi^2 nontrivial. Insert (2.1)-(2.3) on Re(s)=-delta
and expand the absolutely convergent dual series. For n coprime to q
and every S_0-supported r, the character sum that occurs is

    (1/(q-1)) sum_(chi^2 != 1)
      tau(chi^2)^20 chi(r/(nX))^2
      = Kl_20(nX/r;q) + Kl_20(-nX/r;q) - 2/(q-1).           (4.1)

All rational arguments are interpreted in F_q^*. Expand the twenty
Gauss sums and use character orthogonality: the product of their
twenty variables must be either nX/r or -nX/r. The two omitted
characters have chi^2=1, Gauss sum -1, and twentieth power 1.
This proves (4.1), including its normalization.

Deligne's bound gives the uniform estimate

    |the left side of (4.1)| <= 40 q^(19/2) + 2/(q-1).

There is no q-dependent weight hidden in (2.2): its absolutely summable
coefficients are bounded independently of q. We can therefore interchange
the integral, dual series and Laurent expansions, and obtain

    |B_left,primitive(X,Q)|
      << X^-delta sum_q q^(19/2+20*delta)
      << X^-delta Q^(21/2+20*delta).                        (4.2)

The integral of `|ghat(-delta+iu)|(1+|u|)^B` is finite.
This is a proof of the transformed-boundary estimate; it does not shift
through any poles without recording them.

### The two imprimitive characters

On the right line, their total contribution is

    A_0(X,Q)
      = sum_q [2/(q-1)] sum_((n,q)=1) a(n) g(n/X)
      << X^(1+epsilon),                                   (4.3)

by absolute convergence and `sum_(Q<=q<2Q) 1/q << 1`.

Their left integrals also fit the budget, so (3.4) can include them.
At a good q the degree-20 local polynomial is self-reciprocal:
R20 is self-dual with determinant 1. Its twenty roots can be paired
as beta,beta^-1. Local unitarity of Pi implies |beta|<=q, because R20
is a summand of `Sym^2(Pi_q) tensor omega_q^-1`. Each pair can be
oriented with 1<=|beta|<=q. Hence, on Re(s)=-delta,

    |(1-beta q^-s)(1-beta^-1 q^-s)| <= 4 q^(1+2*delta),
    |P_q(q^-s)| <= 4^10 q^(10+20*delta).                   (4.4)

Eigenvalues 1 and -1 can also be paired: determinant 1 and dimension 20
make their unpaired multiplicities even. The fixed function F_1^S has
polynomial growth on the chosen left line by its functional equation.
Consequently

    |B_left,0(X,Q)| << X^-delta Q^(10+20*delta).             (4.5)

Equations (4.2) and (4.5), with delta chosen sufficiently small for each
epsilon, prove

    B_left(X,Q) << Q^(21/2+epsilon).                       (4.6)

In particular, at Q=X^(2/21), this is `O(X^(1+epsilon))`.
Multiple zeros and possible numerator poles are irrelevant to this
boundary estimate: they remain in R_group rather than being discarded.

## 5. The decisive exponent diagnostic

The elementary diagonal extraction in the preceding note gives

    A(X,Q) = N(Q) a(X) + O(X^(1+epsilon)),

for Q=X^theta with fixed theta>0. Combining this with (3.4) and (4.6)
gives the new, explicit form of the remaining obligation:

    R_group(X,Q)
      = N(Q) a(p^ell)
        + O(X^(1+epsilon) + Q^(21/2+epsilon)).              (5.1)

This includes all actual crossed poles and both imprimitive corrections.
It is not a termwise assertion about N_chi(rho)/L'(rho,chi^2).

The local reciprocal polynomial has degree at most 20 and maximum root
modulus p^(4t). Expanding it therefore gives the elementary bound

    |a(p^ell)| <= binomial(ell+19,19) p^(4t*ell).           (5.2)

Using the inherited `t<=5/22`, equations (5.1)-(5.2) imply

    R_group(X,Q)
      << X^(1+epsilon) + Q X^(10/11+epsilon)
         + Q^(21/2+epsilon).

At the requested scale,

    10/11 + 2/21 = 232/231 = 1 + 1/231.                   (5.3)

Thus the proved inherited envelope misses the requested budget by the
power `X^(1/231)`. A fixed positive power cannot be absorbed into an
epsilon that must be arbitrarily small.

### Exact equivalence at the requested scale

For each fixed member pi of this family, the following are equivalent,
under the analytic framework proved above:

* `|R_group(p^ell,p^(2*ell/21))| <<_(epsilon) p^(ell*(1+epsilon))`
  for every epsilon>0 and all sufficiently large ell.
* `t <= 19/84`.

For the forward implication, (3.4) and (4.6) give the target bound for A.
Divide its diagonal extraction by `N(Q) >> Q/log Q` and absorb the
logarithm into epsilon. This gives

    |a(p^ell)| << p^(ell*(19/21+epsilon)).

The exact local radius from the preceding note then gives `4t<=19/21`.
For the reverse implication, insert (5.2) with `4t<=19/21` in (5.1).
The polynomial in ell is absorbed into any positive epsilon.
The prime-counting estimate here is the same standard prime estimate
used by the original amplifier, not a new distribution assertion.

There is also a useful diagnostic if hypothetically t>19/84. The root
`p^(4t)` is simple, and all other local roots have modulus at most p^(2t).
Partial fractions then give

    a(p^ell) = c_p p^(4t*ell) + O(ell^19 p^(2t*ell)),
    c_p = product_(beta != p^(4t)) (1-beta/p^(4t))^-1 != 0.

Choosing epsilon below `4t+2/21-1` in (5.1) yields

    R_group(X,X^(2/21)) = c_p N(X^(2/21)) X^(4t) (1+o(1)).

This is an implication, not the construction of such a pi, not a proof
that any denominator zero is uncanceled, and not a counterexample.
It shows why a general residue estimate at this scale is already as
strong as the desired temperedness improvement.

### Why the inherited-envelope bootstrap closes no gap

If one bounds R_group using only the preceding inherited envelope and
substitutes it back into `A=R_group+B_left`, division by N(Q) returns
the term `X^(10/11+epsilon)` unchanged. Optimizing Q does not remove it.
This particular bootstrap is therefore not a new bound and must not be
retried as though the contour regrouping itself created a power saving.
This does not rule out a genuinely new cancellation estimate for R_group.

## 6. What remains unproved

The transformed-integral budget and a precise cofinal contour limit have
now been supplied at the proof level, subject to the explicitly recorded
standard analytic inputs and independent review. The requested saving
`X^(1/231)` relative to the inherited residue envelope has **not** been
obtained. In particular, (5.1) does not bound the primitive-character
residue contribution within `O(X^(1+epsilon))`.

A zero-free region near Re(s)=1 does not resolve this, nor does the
good-height construction: the latter makes the horizontal sides vanish
for each finite family and supplies no new bound for the right-side
diagonal. No estimates for reciprocal zero derivatives, zero separation,
or an absolute residue sum have been assumed.

The exact prescribed-local global family, strongest applicable literature
comparison, and publication-level novelty remain as open as before.
Only the current bounded analytic diagnostic has changed. This checkpoint
does not complete the mission.

## Exact arithmetic replay

The rational exponent calculation is independently reproducible with the
Python standard library; it has no analytic evidentiary force:

    from fractions import Fraction as F
    theta, old_t, target_t = F(2, 21), F(5, 22), F(19, 84)
    assert 4*old_t + theta == F(232, 231)
    assert 4*target_t + theta == 1
    assert 4*(old_t-target_t) == F(1, 231)
    assert old_t-target_t == F(1, 924)
    assert theta * F(21, 2) == 1

No rank or character-identity rerun was needed: those artifacts did not
change. A bounded Jacobian discovery for complex residues returned only
unrelated modular-residue operations among its first five matches
(`jacobian/complex-residue-discovery.json`), so none was forced onto this
analytic problem.
