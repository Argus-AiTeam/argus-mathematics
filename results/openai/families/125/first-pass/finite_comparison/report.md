# A certified strengthening of the finite directed comparison inequality

## Result and scope

Let all objects and hypotheses be exactly those of
`inequality.tex`, `thm:finite-inequality`, in the staged threshold manuscript.
Write its left-hand side as Phi and put

    w = max(y-x, 0),     z = P(x) w^2.

**Theorem.** For every finite probability space in that statement,

    Phi <= (199/100) z <= (199/100) Theta.

In particular the literal manuscript inequality Phi <= 2 Theta holds.
The first inequality includes y<x, when its right side is zero. No symmetry of
q, positivity of individual weights or distances, or constraint at q=1 is
added. The endpoint x=0 and x=1 and the entire domain 0<y<=1 are included.

The manuscript already proves the stronger-than-stated bound Phi<=2z.
The mathematical improvement here is the replacement of 2 by 199/100 in that
bound, not the removal of its denominator y. It is obtained by reducing its
row penalty 1.6 to 1.59 while retaining the other thresholds. Its numerical
improvement is small; this report does not assert an improved approximation
ratio, literature-wide novelty, or publishable significance without independent
review.

This is a universal proof with exact finite algebraic certificates, not an
inference from a counterexample search. No false assertion of the staged
manuscript was established in this audit. In particular a failed certificate
for our *modified* parameter, discussed below, is not a manuscript refutation.
The exact scalar computations and a load-bearing Lean formalization support
the proof, but the complete theorem is not a single kernel-checked Lean
declaration.

The separate preparation, physical process/count bound, graph averaging,
potential derivation, derandomization, surplus removal, recovery, compatible
execution, and bounded-price strictness remain unaudited. Their main dependency
frontier is recorded as open in `../PROOF_GRAPH.json`. The broader papers cite,
among other inputs, a Li-Svensson surplus reduction and Bayer-Teichmann support
compression. Those are explicitly unaudited external inputs of other claims,
not assumptions of the theorem proved here. No external approximation theorem
is used below.

## 1. Analytic coefficients and their exact enclosures

Throughout this proof P=P(x), A=A(x), and m=A-1-2Px. Let

    I0(x) = integral_0^1 exp(-tx) dt,
    P(x)  = integral_0^1 t exp(-tx) dt,
    A(x)  = 3-2 I0(x).

Differentiation gives A'=2P and A''<0. Hence 0<P<=1/2 and m>=0,
including x=0 by the integral definitions. Also 1<=A<=2, since
1-exp(-tx)<=tx. Integration by parts gives

    x I0 = 1-exp(-x),       x P = I0-exp(-x),
    (1+x)(A-1) = 2x(1-P),  (1+x)A+2xP-1 = 3x.

These are identities at x=0 as well. In particular every denominator 1-Pq
used here is at least 1/2, and C=1-Ps is at least 1/2.

Use the printed p(X), v(X), k(X), with X=1-x, and epsilon=0.0000075.
All their coefficients are exact rationals in `exact_certificate.json`.
An independent uniform error proof, avoiding interpolation as an assumption,
is particularly short. For j=0,1 define

    T_N,j(x) = sum_{n=0}^N (-x)^n / (n! (n+j+1)).

For 0<=x<=1 the alternating exponential series, integrated against t^j,
gives T_13,j <= integral t^j exp(-tx) dt <= T_12,j. For example this
also follows from the sign of the exponential's integral Taylor remainder;
no numerical evaluation of exp is involved. Consequently it suffices to
check positivity on X in [0,1] of the four rational polynomials

    epsilon-p+T_13,1,           epsilon+p-T_12,1,
    2epsilon-v+3-2T_12,0,      2epsilon+v-3+2T_13,0.

The verifier converts each to its natural-degree Bernstein form on all
sixteen intervals [j/16,(j+1)/16]. Every coefficient exceeds 0.0000045.
This proves, uniformly and independently,

    |p-P| <= epsilon,           |v-A| <= 2epsilon.

As an audit of the printed derivation, it also checks all five nodal
enclosures, the displayed nodal maxima, the 512/3 Lagrange-basis budget,
the node-product bounds 1/256 and 9/2048, and the final remainder budgets.
The nodal maximal error enclosures are exactly

    9576913/4086482400000000,    122821/52390800000000.

Coefficient signs and endpoints give

    .26424112 <= p <= .5,   1 <= v <= 1.73575888,
    .0767 <= k <= .1719,   .014 <= H0 <= .394,
    H0 = .394-.42X^2+.04X^3.

The printed first table proves 4k-(p+epsilon)(1+k)^2>0. Since
4t/(1+t)^2 increases on (0,1), and

    k0 = (1-sqrt(1-P))/(1+sqrt(1-P)),   4k0/(1+k0)^2=P,

we obtain k0<=k. All these statements are uniform, not nodal-only estimates.

## 2. Strengthened scalar lemma

Set alpha=2/5 and beta=159/100. Retain the manuscript's

    b=(2-s)P(x+w), a=A+2Pw, C=1-Ps, z=Pw^2,
    d0=.52, d1=.4, H1=.25, Js=C Hs,
    ks=(1-s)k0,
    psi(q)=(1-q)/(1-Pq), kappa_s(q)=C psi(q)-(1-q),

for s=0 or 1, 0<=w<=X, 0<=q,r<=1. Change only

    K=C-ks-br+beta z,
    L=(C-m-b)r+alpha z,
    M=(1-r)a+CP r,     G=M-L.

The following are the scalar hypotheses used in the proof:

1. m+b-alpha z/r <= C(1-P)/(1-Pr) for 0<r<=1.
2. L>=0, K>0, and K>=ds G.
3. ((Js-b)r+beta z)M+(C-ks-Js r)L>=0.
4. C-ks+beta z-bq+.52(ks-kappa_s(q))>=H0.
5. C-ks+beta z-b>=.25.

Here is a full-domain derivation, including the approximation budgets.

### First scalar bound and L

Put t=1/r-P>0. Using the integral identity, right minus left in (1) is

    C(1-P)-2x(1-P)/(1+x)+sPx-(2-s)Pw+alpha P^2 w^2
        +P{C(1-P)/t+alpha w^2 t}.

AM-GM bounds the braces below by 2w sqrt(alpha C(1-P)).
For s=0 the resulting coefficient of -Pw is at most 1.12:
.2>.44^2. The corresponding quadratic decreases on 0<=w<=X.
At w=X its value is X T1(P)/(1+x), where

    T1=1-p-1.12p(1+x)+.4p^2 X(1+x).

For s=1 the coefficient is at most .38 because .4>.62^2.
Discarding the nonnegative quadratic and using w<=X gives T2(P)/(1+x),
where

    T2=((1-p)^2-.38pX+px)(1+x)-2x(1-p).

Both true-parameter polynomials are strictly positive by the certified
polynomial signs and substitution budget below. At X=0 the extra factor X
only gives equality, which is permitted. Then

    L >= Cr {1-(1-P)/(1-Pr)} >= 0.

At r=0 this follows directly from L=alpha z.

### K-ds G and the final two scalar bounds

Define the polynomial quantities

    c=1-sp, N=c-(1-s)k, ell=c+1-v+spx,
    d=ds, h=beta+alpha d, u0=d/h, u1=(2-s)(1+d)/(2h).

Replacing ks by (1-s)k decreases K-dG. Its r=0 endpoint becomes

    Q0(w)=N-dv+pw(hw-2d),

after replacing P,A by p,v. The constrained minimum is at w=X for
s=0 and X<=u0, and at w=u0 otherwise. Its r=1 endpoint is

    Q1+h p(w-u1)^2,
    Q1=N-(2-s)px-d(cp-ell)-h p u1^2.

Thus the Q0(X), Q0(u0), Q1 polynomial signs imply K>=dG on the
whole r interval by affinity. Here u0 is recomputed for the new beta:
it is 260/899 for s=0 and 8/35 for s=1. Both completed-square
centers u0,u1 lie in [0,1].

For s=1, kappa_1<=0 and ks=0. Both final left sides are bounded
below by C+beta z-b. Its unrestricted quadratic minimum is

    Y=N-p{(2-s)x+(2-s)^2/(4beta)}.

For s=0 and X>=1/2 the same Y lower bound follows from q<=1 and
kappa_0<=k0. For s=0 and X<=1/2, P<=P(1/2)<=35/96<.47.
Since b>=P and .52/(1-P)<1, we have

    bq+.52 kappa_0(q) <= bq+.52 P(1-q)/(1-P) <= b.

Therefore the fourth left side is at least 1-.48k0+beta z-b.
The quadratic beta Pw^2-2P(x+w) is decreasing on [0,X], since
2beta X<=beta<2. The requisite two polynomial bounds become

    Yprime+.52k-H0>0,       Yprime-.25>0,
    Yprime=N+p(beta X^2-2).

These, together with Y-H0 and Y-.25 on their listed domains, prove (4),(5).
In particular K>=C-ks-b+beta z>=.25>0.

For the first-table substitution, valid absolute derivative bounds in p,v are

    T1: (3.64,0), T2: (8.76,0), Q0: (3.848,.52),
    Q1: (4.848,.52), Y: (3,0), Yprime: (2,0).

Here |(cp-ell)_p|=|1-2sp+sX|<=2; h<=1.808 and u1<=1.
For Q0 use s+h+2d<=3.848, and for Q1 use
s+(2-s)x+2d+h u1^2<=4.848. For Y use
2+1/beta<3; the change from the printed denominator 6.4 to 4beta is
included. The T1 and T2 bounds follow by termwise absolute bounds on their
displayed derivatives. Thus every substitution error is strictly smaller
than sigma=.0002. The additions involving k,H0 or .25 change no such budget.
The full-polynomial Bernstein lower bounds exceed sigma, on exactly the
complete domains prescribed in the first table with its new u0.

### Scalar charge bound and its error

Since L>=0, replacing ks by (1-s)k decreases the charge expression.
For either (pi,nu)=(P,A) or (p,v), put cpi=1-s*pi and write it as
F1 F2+F3 F4, where

    F1=[cpi Hs-(2-s)pi(x+w)]r+beta pi w^2,
    F2=(1-r)(nu+2pi w)+cpi*pi*r,
    F3=cpi(1-Hs r)-(1-s)k,
    F4=[2-nu-s*pi*X-(2-s)pi*w]r+alpha*pi*w^2.

For rho=r+w^2, the bounds

    |F1|<=1.1rho, |F2|<=3, |F3|<=1, |F4|<=2rho

hold at both choices. For F1 its r coefficient is a difference of two
numbers in [0,1], and beta*pi<=.8. For F2 use its convex combination.
For F3 use cpi>=.5, Hs<=.394, k<=.1719. The r coefficient of F4
is in [-1,1], since 0<=2-nu<=1 and
0<=s*pi*X+(2-s)pi*w<=1. The perturbations satisfy

    |delta F1|<=2epsilon rho, |delta F2|<=4epsilon,
    |delta F3|<=epsilon,     |delta F4|<=4epsilon rho.

For example s Hs+(2-s)(x+w)<=2 and beta<=1.6; also
|(P-p)(1-s(P+p))|<=epsilon. Telescoping the two products therefore gives

    |delta(F1 F2+F3 F4)|
       <= (6+4.4+2+4)epsilon rho
       = .000123 rho < sigma rho.

When rho=0 both expressions vanish, so no division by rho is used.

It remains to show nonnegativity of the polynomial expression minus
sigma(r+w^2). Put w=X eta. Its degree-three eta Bernstein coefficients
are B0+B1 r+B2 r^2. The verifier derives these coefficients directly
from the two products and independently checks the eight printed formula
identities, both for beta=1.6 and beta=1.59. In the formulas replace each
1.6 by beta; all remaining terms are unchanged. B0=0 for i=0,1. Otherwise

    B0=X^2{p(beta v+.4N)-sigma} i(i-1)/6
         + beta pX^2(2pX) 1_{i=3} >= 0,

because N>=.5 and p>=.26424112. The bracket is strictly positive.

For i=0,1 the signs B1>=0 and B1+B2>=0 suffice. For i=2,3 the
same three alternatives as in the manuscript suffice: B1,B2>=0;
4B0B2-B1^2>0; or B0+B1+B2>0 and B0-B2>0. The associated implications
are proved in Lean. In particular the last follows from

    B0+B1 r+B2 r^2
       = r(B0+B1+B2)+(1-r){(1-r)B0+r(B0-B2)}.

The full-polynomial sign checks use the same domain cover:

| s,i | First criterion | Discriminant criterion | Final criterion |
|---|---|---|---|
| 0,2 | [0,.05] | [.05,1] | not needed |
| 0,3 | [0,.015] | [.015,1] | not needed |
| 1,2 | [0,.2] | [.2,1] | not needed |
| 1,3 | [0,.1] | [.1,.75] | [.75,1] |

Every listed interval is closed. For i=0,1 the linear-in-r criteria cover
all X in [0,1]. For each row and each prescribed interval [a,b], the
certificate uses all sixteen cells

    [a+(b-a)j/16, a+(b-a)(j+1)/16],  j=0,...,15.

The natural-degree Bernstein coefficients of the **full** polynomial are
computed exactly. Together the first and charge checks comprise 656 cells,
all strict sign margins exceeding .00007; the first-table margins also exceed
sigma. No term of high degree is discarded in this strengthened verification.
Degree never exceeds 28. Positivity of the Bernstein basis and its unit sum
make these certificates universal on the cells, hence on the entire domain.
Nonnegativity of the cubic eta basis and the perturbation budget now prove (3).
At X=0 necessarily w=0, so no eta division is required.

For audit completeness, the original printed 14 first-table rows,
21 charge-table rows (22 instantiated rows), short-minorant coefficient rule,
all Bernstein lower bounds, all 20 negative-tail blocks, and all reported
degrees replay unchanged for beta=1.6. Their smallest short-minorant
Bernstein coefficient is 193875074979/3200000000000000.

An attempted shortcut for the strengthened theorem was **not** valid:
one cannot reuse all the printed short minorants after changing beta.
For beta=1.59, s=0,i=3 the discriminant's X^2 coefficient is

    184784272311197665694588734583/9765625000000000000000000000000
        < 207/10000,

whereas the ninth printed short-minorant row would require the opposite
coefficient comparison. This excludes that coefficient-rule route, not the
parent positivity inequality and not any assertion made for the manuscript's
original beta=1.6. The full-polynomial certificates above replace this route.

## 3. Finite directed deduction

Discard indices with weight zero; their constraints can only restrict the
original instance further, and no weighted expression or normalization changes.
For fixed x,D,q,R,s the original Phi is nondecreasing in y: its explicit
y coefficient is nonnegative, and its subtracted positive part decreases.
Replace y by y'=max(x,y)=x+w. Then z=P w^2, and z<=Theta for the
original y. The resulting Phi is separately affine in every s_i, so it
suffices to prove the result when all s_i are 0 or 1.

Fix a row i, suppress its subscript, and write D=D_i, Z=D_t, q=q_ti,
r=E_t q_ti. Let U=mD+b(D+1), with the scalar quantities above at y'.
Define

    F=C(1-r)R+Ur-C(D+1)
        -E_t (1-q)(Z-aD)_+ -(alpha D+beta)z.

Since E_i D_i=1, E_i F_i = Phi(y')-(alpha+beta)z.

The exact identities

    kappa_0(q)=Pq(1-q)/(1-Pq)<=k0,
    kappa_1(q)=-P(1-q)^2/(1-Pq)<=0,
    psi(q)=1-q+Pq psi(q)<=1-q+Pq

hold on the closed interval. The first maximum occurs at
q=1/(1+sqrt(1-P)); endpoints pose no difficulty. Multiplying the comparison
by 1-q yields (1-q)R<=psi(q)(D+Z). At q=1 this is 0<=0,
so no omitted comparison hypothesis is supplied there.

Using (Z-aD)_+>=Z-aD and centering with E_t Z=1 gives

    F <= E_t I_s(D;q,Z),
    I_s=[mD+b(D+1)]q+D{C psi(q)+a(1-q)-C}
          -(alpha D+beta)z-C+ks-(ks-kappa_s(q))Z.

Centering is performed under expectation only; ks*Z is not replaced by
ks pointwise. Since ks-kappa_s(q)>=0 and Z>=0, the psi bound yields

    I_s(D;q,Z) <= D G(q)-K(q),    F <= D G(r)-K(r).

The latter averaging uses the affinity of G,K and does not use symmetric q.
The verifier checks the exact algebraic coefficient identity behind this bound.

If F>0, then r>0: otherwise q=0 on the positive-weight support,
R<=D+1, and F<=0. Also D>=0, K>0, and K>=ds G imply

    G(r)>0,      D>K(r)/G(r)>=ds.

Put

    u=[Ur-(alpha D+beta)z]/(Cr).

Its exact rearrangement is

    u=(D+1){m+b-alpha z/r}/C - m/C -(beta-alpha)z/(Cr).

Since beta-alpha>0, the first scalar bound gives
u<=(D+1)(1-P)/(1-Pr). On the other hand

    F <= C{(1-r)R+ru-(D+1)}.

If R<=(D+1)/(1-Pr), its right side is nonpositive. Thus a positive row
has R>(D+1)/(1-Pr) and u<=R(1-P). It cannot have r=1, since then
u<=D+1. These implications are encoded in `positive_radius`.

For q<1 we now have

    (1-q)R+qu <= R(1-Pq)<=D+Z.

For q=1, the excess over D+Z is exactly u-D-Z. Averaging the previous
row bound and using E_t Z=1 proves

    F <= C E_t [1_{q=1}(u-D-Z)_+].

This is the step formalized in `comparison_excess` and `row_excess`.
It is the explicit treatment of unconstrained q=1 columns, not a continuity
argument that imposes an extra radius constraint.

Next set T=(Js-b)r+beta z. The scalar charge inequality has the exact form

    T M+(C-ks-Js r)L = T G+K L >=0,
    Cr(u-D)=br-beta z-LD.

Since L>=0 and D>K/G, these imply u-D<=Hs. This algebraic implication
is `donor_threshold`. Using C<=1 and dropping the indicator therefore gives

    F_i <= E_t (H_{s_i}-D_t)_+             whenever F_i>0.

In particular all charged indices have D_t<.394, whereas positive rows
have D_i>ds_i>=.4. Define

    Gamma_it = 1_{F_i>0}(H_{s_i}-D_t)_+.

It remains to prove payment; nonnegative charges cannot simply be canceled
without this step.

Let i satisfy D_i<=c*=.394. For each column t hold q=q_ti,
Z=D_t, s_i,s_t, and chi=1_{F_t>0} fixed. The function

    D -> I_{s_i}(D;q,Z)+chi(H_{s_t}-D)_+

is convex on [0,c*]. At D=c* its charge is zero. Its remaining term
is at most c*G(q)-K(q)<=0, using K>0 if G<0 and K>=ds_i G
otherwise. At D=0 the first term is

    bq-beta z-C+ks-(ks-kappa_s(q))Z.

If chi=1 and s_t=0, the positive donor satisfies Z>d0=.52, so
scalar bound (4) makes this at most -H0. Otherwise the charge is either
zero or H1=.25, and scalar bound (5) makes the same expression at most
-.25. Both endpoints are nonpositive, hence the convex function is
nonpositive throughout the interval. Averaging gives

    F_i+E_t Gamma_ti<=0.

Rows outside this receiving interval have no incoming charge. Positive
rows have no incoming charge either. Every nonpositive row has zero
outgoing charge by definition. Thus the abstract directed cancellation
theorem `paying_charges` applies, giving

    E_i F_i <= E_{i,t} Gamma_it-E_{i,t} Gamma_ti = 0.

The equality is just exchanging two finite sums with weights pi_i*pi_t.
It makes no assertion about q_it=q_ti. Since alpha+beta=199/100, we obtain
Phi(y')<=(199/100)z. Monotonicity returns the asserted bound for the
original y, and z<=Theta finishes the proof.

## 4. Normalization and fidelity boundary

Conditionally on the geometric quantities in `rounding.tex`,
`eq:rnd-normalization` sets mu=V/y, D_i=d_i/mu,
r_i=w_i/y, R_i=(1-2zeta)N_i/mu, and gives each active index weight g/y.
For V>0,y>0 this indeed gives weighted mean D equal to one and the
same directed r_i as in the theorem.

Since P<=1/2, q in [0,1], and |P-hatP|<=zeta,

    (1-2zeta)(1-Pq) <= 1-hatP*q.

Indeed the difference is at least
2zeta(1-Pq)-zeta q>=2zeta(1-q)>=0. The taper comparison and triangle
inequality therefore imply the literal normalized comparison only where
q<1. Summing its distance version with factors (g/y)(1-q) yields
(1-r_i)N_i/mu<=2(D_i+1). The coefficient replacement costs at most
6zeta(D_i+1), whose expectation is 12zeta. These observations do not
re-prove that the geometric hypotheses, graph kernel bound, or drift
expression hold.

For clarity, the normalized non-hinge per-row drift expression and the
finite-theorem integrand are **not pointwise equal**: their difference is
2(D_i-1). The verifier checks this exact identity, and its expectation
vanishes by E_i D_i=1, as used in the manuscript. This is not a flaw in the
printed expected identity. Cases V=0 or y=0 require the separate
unnormalized geometric reasoning and are not an application of this theorem.

## 5. Reproduction, experiment, and limits

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/finite_comparison/verify.py

The script requires SymPy and performs exact rational arithmetic. It checks
the printed certificates, the independent uniform Taylor enclosures,
the strengthened full-polynomial signs and their complete interval cover,
both sets of eta identities, numerator/charge identities, and the rounding
centering identity. This is an executable finite certificate of the explicit
algebraic obligations; the analytic and weighted deduction above are part of
the proof, not silently delegated to numerical testing.

The retained Jacobian invocation is `polynomial.box.enclosure.compute`
through the authorized Argus adapter, version 0.14.0, protocol 2025-11-25.
Its exact payload, inspected contract, typed output, and adapter status are
the dedicated `jacobian_*.json` files. It encloses the printed T1 short
minorant on [0,1/2] in [87/1600,121/800]. This is a genuine bounded
positivity calculation on that interval only; the remainder is established
by the independent exact verifier. There was no timeout or adapter error.

`search.py` is a separate, bounded directed stress experiment. Across 2,160
instances it uses nonuniform rational weights, including zero weights and
distances, fractional s, asymmetric q, q=1 columns with unrestricted radii,
x=0,1/2,1, and four positive y values. Integral enclosures come from
orders 18/19, not floating exponentials. It found 2,097 certified nonviolations,
63 inconclusive interval enclosures, and no certified counterexample. The
inconclusive cases are **not** counted as verified examples. The largest
excess upper endpoint, 1/1277273554292736000, is an enclosure artifact,
not a witnessed positive excess. None of these bounded results establishes
the theorem or literature novelty.

The accompanying Lean 4.31.0 source establishes the explicitly identified
conditional algebra, directed row-excess and cancellation lemmas, and
quadratic/Bernstein implications. Its actual compiler result is archived
beside the source and recorded against `C_CHARGE_CORE`. It does not import
the rational certificate or prove all exponential analysis in Lean.
`lean/statement_fidelity.md` states these limits without changing the claim's
interpretation after compilation.

The Engineer's proof and exact computations await independent Reviewer
replay, fidelity review, and significance/novelty assessment. No Reviewer
approval or campaign-final acceptance is asserted here.
