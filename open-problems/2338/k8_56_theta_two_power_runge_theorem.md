# The actual two-power theta tower and its direct-Runge obstruction

## 1. Proposition-level comparison, before the tower argument

Guest--Morris--Praeger--Spiga (GMPS), arXiv:1301.5166v1,
Section 3, Table 4 (pp. 15--16), records the known minimum
permutation degree

    m(P Omega^+_(2g)(2)) = 2^(g-1)(2^g-1),  g >= 4.

In particular, the value at g=4 is 120, without a rank-four exception.
The rank restriction matters: P Omega^+_6(2) is PSL_4(2), of minimum
degree 8, not 28. GMPS presents the table as a collection of earlier
results, through Kleidman--Liebeck, Table 5.2.A, and Cooperstein, with
Mazurov--Vasil'ev corrections.

The independent source reader `orthogonal-antecedents` obtained GMPS v1
and the author-hosted English text of Mazurov--Vasil'ev. The latter's
main theorem, pp. 348--350, includes the q=2 plus-type value above;
Lemma 5, p. 346, describes the nonsingular-vector stabilizer.
The concluding discussion on p. 350 identifies inaccuracies in earlier
tables, including a plus-type q=3 entry. This does not justify attributing
an unexamined original formula to Cooperstein.

Cooperstein's primary text could not be obtained by that reader:
the publisher returned a client challenge and alternative copies
returned HTTP 403. Only its bibliographic identity was verified.
Kleidman--Liebeck's original table was not read. No theorem number or
unseen proposition from either source is assumed here.

Primary references:

- GMPS, arXiv:1301.5166v1, https://arxiv.org/pdf/1301.5166v1;
  published DOI 10.1090/S0002-9947-2015-06293-X.
- Cooperstein, *Minimal degree for a permutation representation of a
  classical group*, Israel J. Math. 30 (1978), 213--235,
  DOI 10.1007/BF02761072; primary proposition unavailable.
- Mazurov--Vasil'ev, *Minimal permutation representations of finite
  simple orthogonal groups*, Algebra and Logic 33 (1994), 337--350,
  DOI 10.1007/BF00756348, English primary text
  https://math.nsc.ru/~vasand/Papers_eng/orth.pdf.

Here is the exact comparison with the unchanged reviewed project proof
`research/affine_orthogonal_runge_theorem.md`.

1. The lower bound for a nonzero proper subspace stabilizer in the full
   orthogonal group follows from the known simple-group bound and
   natural-module irreducibility. It is not a bound for every proper
   subgroup of the full group: its index-two subgroup Omega is an
   immediate counterexample to that formulation.
2. The sharp affine intransitive threshold 2^(2g)-2^g is an elementary
   consequence, using the translation kernel and projection. A
   nonsingular-vector perpendicular hyperplane attains it. Thus the
   numbers 240 and 128+128 at g=4 do not supply a new group-theoretic
   constant.
3. Identifying this campaign's 256-point infinity fiber with the full
   affine action is a separate, reviewed arithmetic input. The reviewed
   inequality over all number fields additionally uses a double-coset
   argument and the signature formula, not just the minimum index.
   GMPS and Mazurov--Vasil'ev do not compute that arithmetic image.
   Their silence about arithmetic is not a novelty certificate for the
   application.
4. The present target is strictly different: the actual action on
   [2^r]^{-1}(-D) at every r, starting at r=2. Neither the published
   minimum degree nor the reviewed r=1 argument supplies this lift.

## 2. Exact target and unchanged inputs

Let C be the smooth projective model of

    (T-1)(T-9)(T-25) = 384u(u^2-1)(u^2-4),

let P_infinity be its unique point at infinity, let J=Jac(C), and set
i(P)=[P-P_infinity] and D=[P_(25,2)-P_infinity].
The target is

    for every r >= 1 and every number field K,
    # (G_K-orbits on [2^r]^{-1}(-D)) <= r_1(K)+r_2(K).

The reviewed handoff 777ae22ce526 accepts the universal r=1 proof but
requires a genuinely new contribution and primary-source comparison.
Its proof and the earlier reviewed campaign certificates are unchanged.
No higher-level claim is certified by this note's source comparison.

**Theorem (Engineer proof; independent review pending).** Write

    Theta = {A in Sp_8(Z_2): A mod 2 lies in O_8^+(2)},
    Gamma = {A in GSp_8(Z_2): A mod 2 lies in O_8^+(2)}.

The actual torsion image is Gamma. The compatible affine Galois image
on the division tower of -D is

    T_2(J) semidirect Gamma.

Consequently, for every r>=1 and every number field K, the infinity
fiber of Y_r has at most r_1(K)+r_2(K) G_K-orbits. This is a prose
proof, not a Lean certificate or a finite-level extrapolation.
The exact checker below certifies its new binary linear-algebra
ingredients, not the quantified theorem.

## 3. Two linear-algebra facts in the actual residue dimension

Choose a symplectic basis e_1,f_1,...,e_4,f_4 of T=T_2(J) whose
reduction puts the reviewed plus quadratic refinement in the form

    q(sum x_i e_i+y_i f_i)=sum x_i*y_i.

Write V=T/2T and b for the reduced pairing. The reviewed residue group
O=O_8^+(2) is transitive on each of the sets q=1 and q=0 minus zero;
their sizes are 120 and 135. Its natural module is irreducible, its
nonsingular transvections generate O, and H^1(O,V)=0. These are
unchanged reviewed inputs, not new computations here.

### 3.1 Nonsingular transvection tensors span the symplectic Lie algebra

The tensors vv^t for q(v)=1 span the 36-dimensional space of symmetric
8-by-8 matrices over F_2.

Here is an elementary proof, so even this statement does not depend
on extrapolating a computer calculation. A linear functional on the
space of symmetric matrices gives a quadratic function

    F(v)=L(vv^t),

with no constant term. Suppose F vanishes whenever q(v)=1.
For any coordinate vector u=e_i or f_i, choose distinct j,k different
from i, and put

    h_1=e_j+f_j,
    h_2=e_j+e_k+f_k,
    h_3=f_j+e_k+f_k.

All three h_a and all three h_a+u are nonsingular, and
h_1+h_2+h_3=0. Polarizing F gives B_F(h_a,u)=F(u).
Adding the three identities proves F(u)=0. Thus every diagonal
coefficient of F vanishes.

If x,y are coordinate vectors in different hyperbolic pairs, choose
h=e_k+f_k in a third pair. The vectors h, h+x, h+y, h+x+y are
nonsingular. Polarization, and F(x)=F(y)=0, now give
B_F(x,y)=F(x+y)=0. If x,y are the two vectors in one hyperbolic
pair, x+y itself is nonsingular and gives the same conclusion.
Every coefficient of F therefore vanishes. Ordinary
finite-dimensional duality proves the assertion.

Let J_0 be the integral alternating pairing matrix. For a primitive
v in T, set

    N_v(x)=<v,x>v,       tau_v=1+N_v.

Then N_v^2=0, tau_v is symplectic, and

    tau_v^m=1+m N_v

for every integer m, and by continuity for m in Z_2. Multiplication
by J_0 identifies the span of the reductions of these N_v with
the preceding symmetric-matrix space. It is the entire

    sp(V)={X: X^t J_0+J_0 X=0},

of dimension 36.

### 3.2 Perpendicular nonsingular vectors span a hyperplane

For every q(v)=1, the vectors w with q(w)=1, b(v,w)=0, and w!=v
span v-perp. By the reviewed transitivity it suffices to take
v=e_1+f_1. The following seven vectors form a basis:

    v+e_2, v+e_3, v+e_2+e_3,
    e_2+f_2, e_3+f_3, v+e_4, e_4+f_4.

Their first three sum to v, after which all six coordinate
vectors in the other three pairs are in their span. Each displayed
vector is nonsingular, perpendicular to v, and distinct from v.

## 4. Integral inertia forces the actual torsion image

This is the first lifting step, not an assumption that mod-two
surjectivity lifts automatically.

Let P_n be the kernel of Sp(T)->Sp(T/2^n T), n>=1. The map

    P_n/P_(n+1) -> sp(V),
    1+2^n X |-> X mod 2

is injective and additive. Symplecticity puts its image in sp(V).
For any chosen primitive lifts v of all 120 nonsingular residues,
the elements tau_v^(2^n)=1+2^n N_v show that its image is the
whole space by Section 3.1.

In particular, the closed subgroup generated by tau_v^2 for those
120 lifts is P_1: its intersection with every P_n surjects onto
P_n/P_(n+1). Successive approximation modulo 2^n and closedness
give every element of P_1. The same argument works if each tau_v
is replaced by 1+c_v N_v with c_v an odd 2-adic unit.

For this Jacobian, the reviewed model has a geometrically irreducible
special fiber with exactly one ordinary node at p=58411, and its
total space is regular there. The reviewed nonzero value of the
equation divided by p makes the smoothing thickness one. Integral
Picard--Lefschetz gives an actual inertia element

    t=1+c N_v,     c in Z_2^*, v primitive in T.

The vanishing cycle is primitive because the fiber is irreducible
and the node is nonseparating; this is also the consequence of the
specialization exact sequence described below. Since its nontrivial
reduction preserves q, the identity

    q(t_v x)=q(x)+b(v,x)(q(v)+1)

implies q(v mod 2)=1.

Let G be the actual closed torsion image. Conjugate t by G.
The reviewed full O residue image supplies all 120 nonsingular
centers modulo two. Every conjugate is again an integral
transvection with odd coefficient, even if the conjugating matrix
is a similitude. Their squares therefore generate P_1 by the
preceding argument. All these elements have multiplier one.
Their reductions generate O by the unchanged reviewed generation
result. It follows that

    Theta <= G intersect Sp(T).

The rational even theta characteristic already gives G<=Gamma.
The multiplier on G is the cyclotomic character, which is onto
Z_2^* over Q. Hence any A in Gamma can be matched to an element
of G with the same multiplier; their quotient lies in Theta.
Therefore G=Gamma.

**Precise integral source.** The source is Deligne, SGA 7 **II**,
Expose XV, *La formule de Picard--Lefschetz*, LNM 340 (1973),
DOI 10.1007/BFb0060511, Propositions 3.3.5--3.3.6, p. 192,
and Theoreme 3.4(ii)--(iii), pp. 195--196. The independent reader
`integral-kummer-sources` read the original scanned pages.
For a proper flat curve over a strictly henselian trait, smooth
generically with ordinary quadratic singularities on the special
fiber, the formula uses the Kummer character of the local smoothing
parameter. With Z/2^n coefficients at odd residue characteristic
and a thickness-one parameter, this character is surjective.
For one geometrically irreducible nodal fiber, the H^2
specialization map is an isomorphism; the exact sequence in 3.4(ii)
then makes pairing with the vanishing cycle surjective modulo two.
This proves its primitivity before passage to T_2(J).

Primary scan:
https://library.slmath.org/books/sga/sga/7-2/7-2t_192.html and
https://library.slmath.org/books/sga/sga/7-2/7-2t_195.html
(continued on p. 196).
The older project note's "SGA 7 I" and DOI 10.1007/BFb0061137
are not adopted: that DOI is not this Picard--Lefschetz source.
The reviewed artifact is left unchanged as required.

## 5. Continuous cohomology: no unverified lifting hypothesis

We prove H^1_cont(Theta,V)=0, not just H^1(O,V)=0.
Let c:Theta->V be a continuous 1-cocycle.

Take any primitive v in T with q(v mod 2)=1. For each
w_bar in v_bar-perp with q(w_bar)=1 and w_bar!=v_bar,
choose a lift w with <v,w>=0. Such a lift exists: the pairing of
an arbitrary lift with v is even, and primitivity permits an
even correction to make it exactly zero. The integral
transvections tau_v,tau_w lie in Theta and commute. The cocycle
identity consequently gives

    b(w_bar,c(tau_v)) w_bar = b(v_bar,c(tau_w)) v_bar.

The two residue vectors are linearly independent. Both coefficients
vanish. Section 3.2 therefore implies

    c(tau_v) in F_2 v_bar.

It follows that

    c(tau_v^2)=(1+t_v)c(tau_v)=0.

This holds for every primitive nonsingular lift v. Section 4 proved
that these squares topologically generate P_1. Since P_1 acts
trivially on V and c is continuous, c vanishes on P_1. It descends
to a cocycle on Theta/P_1=O, and the reviewed H^1(O,V)=0 says
that it is a coboundary. This proves the claimed continuous
cohomology vanishing.

Now let c be a cocycle on Gamma. After subtracting a coboundary,
its restriction to the normal subgroup Theta is zero. Comparing
c(h gamma) with c(gamma (gamma^-1 h gamma)), h in Theta, gives
h c(gamma)=c(gamma). But V^Theta=V^O=0 by irreducibility.
Thus c=0 after that subtraction, and

    H^1_cont(Gamma,V)=0.

In particular the possible characteristic-two quotient of a
congruence Lie algebra has not been dismissed by an unsupported
Hom-vanishing assertion. The commuting integral-transvection
relations kill its contribution to an actual cocycle.

## 6. The actual Kummer image, including level four

Choose a compatible sequence beta_r with
[2^r]beta_r=-D and [2]beta_(r+1)=beta_r. Galois acts on it by
the continuous affine representation

    omega:G_Q -> T semidirect Gamma,
    sigma |-> (kappa(sigma),rho(sigma)).

Let H be its closed image and N=H intersect T, the translation
image over the full torsion field. It is a closed Gamma-stable
Z_2-submodule of T. Its image in V is O-stable, so irreducibility
makes that image either zero or all of V.

Suppose it were zero. The reduced Kummer cocycle would vanish
on ker(rho), and hence descend to a continuous cocycle on Gamma.
Section 5 would make its inflation a coboundary on G_Q.
The Kummer exact sequence would then give -D in 2J(Q),
contrary to the unchanged reviewed good-reduction witness for D.
Thus N surjects onto V. Successive approximation (or Nakayama's
lemma) and closedness give N=T. Since H also projects onto Gamma,

    H=T semidirect Gamma.

There is no remaining campaign-specific divisibility or
translation-image assumption in this deduction.

For every r>=1 put M_r=T/2^r T and let Gamma_r be the reduction
of Gamma. The actual infinity-fiber image is exactly

    A_r=M_r semidirect Gamma_r.

In particular, at the formerly unresolved entrance r=2 it is

    (Z/4)^8 semidirect
    {A in GSp_8(Z/4): A mod 2 in O_8^+(2)}.

It is transitive on all 65536 points of [4]^{-1}(-D), and its
point stabilizer is Gamma_2. This is the actual arithmetic action,
not a hypothetical maximal group admitted from its mod-two image.
Unimodular symplectic Gram--Schmidt lifts symplectic matrices
modulo 2^r to Z_2; separating off the multiplier does the same
for similitudes. Thus Gamma_r is exactly the displayed
congruence-defined finite group, not just a subgroup of it.

For clarity, the compatible finite image orders are

    |Gamma_r|=348364800 * 2^(37(r-1)),
    |A_r|=348364800 * 2^(45r-37).

The symplectic congruence layer has dimension 36; each additional
multiplier layer has dimension one. These order formulas are
consequences, not premises, of the proved full image.

## 7. Exact covers, maps and poles

Define Y_r over Q by the fiber product of i-D:C->J with
[2^r]:J->J. Multiplication is finite etale of degree 2^(8r)
in characteristic zero. Therefore Y_r is smooth and projective,
and Y_r->C is finite etale of that degree.

It is geometrically connected. Over C, the Abel--Jacobi map
induces the identification H_1(C,Z)=H_1(J,Z) in the analytic
definition of the Jacobian. Its reduction modulo 2^r is onto
J[2^r], so the pulled-back multiplication cover has transitive
geometric covering monodromy. Translation by -D does not change
this homology map. Riemann--Hurwitz gives

    g(Y_r)=1+3*2^(8r).

The transition morphism is exactly

    Y_(r+1) -> Y_r,     (P,Q) |-> (P,[2]Q),

a finite etale map of degree 256. At every level
(P_(25,2),0) is rational, so these are globally soluble covers.

The reviewed rational function u on C has its only pole at
P_infinity, of order three. Etaleness implies that its pullback
has order three at every point above P_infinity and no other
poles. This reduced fiber is exactly

    X_r=[2^r]^{-1}(-D),

with its actual action A_r from Section 6. The transition on the
fiber is Q|->[2]Q, or reduction M_(r+1)->M_r in compatible
affine coordinates. Its imprimitive block structure is retained
in the next argument, not discarded.

## 8. An orbit inequality that allows the imprimitive actions

Let r>=1, M=(Z/2^r)^8, and B<=GL(M) have mod-two image O.
Put A=M semidirect B. We prove that every proper H<A satisfies

    #(H-orbits on M) <= [A:H]/2.                     (1)

First, every B-stable additive subgroup W of M is 2^k M
for some 0<=k<=r. If W!=0, choose the smallest valuation k
of its elements. Then W<=2^k M, and its image in
2^k M/2^(k+1) M is a nonzero O-stable subspace, hence the whole
space. Thus W+2(2^k M)=2^k M. Iterating this identity in the
finite 2-group proves W=2^k M. The case W=0 is k=r.

Consider the right B-action on H\\A, of degree d=[A:H].
Its orbits are in bijection with the H-orbits on A/B=M.
If it has no singleton, (1) follows immediately.
Otherwise conjugate H so that B<=H. Then

    H=W semidirect B,       W=H intersect M=2^k M.

Properness makes k>=1, and

    d=|M/W|=2^(8k)>=256.

The number of H-orbits on M is the number of B-orbits on M/W.
For a nonzero vector in M/W, divide out its exact power of two
and reduce modulo two. On its B-orbit this gives an equivariant
surjection onto one of the two nonzero O-orbits in V. Each
nonzero B-orbit therefore has size at least 120. Consequently

    #(H-orbits on M) <= 1+(d-1)/120 <= d/2,

where the last inequality holds for every d>=256. This proves
(1), including every singleton-double-coset case at every level.
No maximality of B in the imprimitive affine group was assumed.

## 9. Every number field and every level

Let E_r/Q be the splitting field of X_r. Section 6 identifies
its Galois group faithfully with A_r. For any number field K
in a common algebraic closure, set

    F=E_r intersect K,     H=Gal(E_r/F),     d=[F:Q].

Restriction identifies Gal(E_r K/K) with H, without requiring
K/Q to be Galois. Thus r_r(K) is the number of H-orbits on X_r.
If d=1, transitivity gives r_r(K)=1<=r_1(K)+r_2(K).
If d>1, H is proper and Section 8 gives

    r_r(K) <= d/2 <= [K:Q]/2 <= r_1(K)+r_2(K).

Every set S_K containing the archimedean places has cardinality
at least r_1(K)+r_2(K). The strict direct-Runge condition is
therefore impossible at every r and over every K. This proves
the theorem.

## 10. Improvement, antecedents and limits

The strongest reviewed result concerned only r=1, a 256-point
fiber. This proof determines the actual full 2-adic torsion and
Kummer images, settles the 65536-point r=2 entrance, identifies
all the coherent covers, and proves the inequality simultaneously
at every higher level despite their imprimitive actions.
The new contribution under review is this arithmetic tower
statement, not the already published orthogonal minimum degree.

The independent source reader identified two important further
antecedents:

- Janssen, *Skew-symmetric vanishing lattices and their monodromy
  groups*, DOI 10.1007/BF01458708, (2.4)--(2.5), p. 116,
  gives a level-two congruence conclusion under integral
  vanishing-lattice hypotheses, including spanning, a single
  transvection-generated orbit, and an integral pairing one.
  Those integral-lattice hypotheses are not silently inferred
  here from mod-two data. Section 4 supplies its own closed
  2-adic generation proof from the actual inertia element.
- Jones--Rouse, arXiv:0706.2384v4, Theorem 3.4, pp. 11--13,
  supplies a general Kummer criterion requiring nondivisibility
  over every torsion field; that requirement must not be assumed
  here. Section 5 proves the needed continuous cohomology
  vanishing, and Section 6 proves the translation assertion
  directly. Their Theorem 6.2, pp. 29--30, assumes full GSp,
  not this proper theta residue image, and at two includes the
  condition that a chosen half is not in the first torsion field.
  It does not by itself certify this campaign.

Janssen's original pp. 115--118 and Jones--Rouse's stated
passages were read by `integral-kummer-sources`; the latter
version is also retained in the two-power-prefixed PDF/text.
No primary theorem for H^1_cont(Theta,V)=0 was verified in that
bounded lookup. Pollatsek's primary text could not be obtained.
These retrieval limits are not a proof of novelty.

Independent review must judge the universal argument, source
attribution, novelty and publishable significance. No exclusion
of C's campaign points, either surviving K(a)=8 system, a full
Selmer group, K(a)>=9, or multiplicity-five nonrealizability
follows. Other twists and unrelated coverings are not covered
by a statement about this one coherent tower.

## 11. Exact replay of the new computational ingredients

The checker constructs the 120-by-36 matrix of nonsingular
transvection tensors, verifies rank 36, verifies the seven-vector
perpendicular basis (and its residue-space counterparts), and
checks the exact integral rank-one transvection identities.
It does not rerun or edit any reviewed finite certificate.

The configured adapter's inspected operation is
`prime_field.matrix.rank.compute`. Its typed contract admits
the entire 120-by-36 matrix over the explicitly supplied prime 2.
Preparation, the single bounded adapter execution, and certification:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_two_power_runge_verify.py prepare
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_two_power_runge_verify.py execute
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_two_power_runge_verify.py certify
```

Nonwriting replay:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_two_power_runge_verify.py verify
```

The dedicated JSON files retain discovery, exact typed contract,
payload, output, server/protocol identifiers and actual adapter
exit/timeout status. Timeout, invalid output or an adapter error
fails replay; none is interpreted as a mathematical conclusion.

The executed request returned rank 36 in 5 ms, Jacobian 0.14.0,
protocol 2025-11-25, transport mcp-stdio, adapter exit zero,
with no error or timeout. The local exact replay also gives
perpendicular span rank seven for all 120 nonsingular residues
and verifies the 120 integral transvection identities.
