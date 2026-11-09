# Determinant-fixed surface Quot localization

## Statement and scope

This audit concerns `C53_LOCALIZATION`, not the complete Pixton
counterexample. The source is Section 05, up to marked universality and
Proposition "Localization relation", with the moving factor in Section 06.
The previously reviewed retained-output recursion and scalar transfer are
inputs: `research/marked_coefficient_audit/REPORT.md` and the Host receipt
`df3cf1c37238/round-0001.json`. Their acceptance does not verify the
determinant-fixed geometry.

The geometric hypotheses are as follows. The ground field is C. The base S
is a smooth irreducible quasi-projective variety; C/S is a smooth projective
connected curve family of genus b with a section. Put

    q = b-1, chi = q^2, X = C x_S C, K = K_(X/S), s = K^2 = 8q^2,
    D = 3K, t = 25q^2-1, nu = t-1, N = nu+3s.

Assume b >= 5 and dim(S) < chi-1. The Quot target is K + O, with torus
weights 0 and 1. Its rank-zero quotient has determinant D in the relative
Picard scheme and ch_2 integral nu + K.D - D^2/2. Embedded points and
nonreduced divisor support are allowed. The support quotient kills a class
if it vanishes outside a closed base subset of codimension at least q.
Parameter schemes for the moduli constructions need not be reduced or
smooth.

There is a separate, unverified input: the tensor realization of Section
04, Proposition "Faithful Chow tensor test", including its Koszul rules,
preservation of the Chow operations, and interpretation of the isotropic
tests. The proposed conclusion is conditional on that realization. The
geometric Chow identity preceding the tensor test can be considered
without asserting the existence or faithfulness of that realization.

## Geometric inputs established elsewhere

The following are inputs, not conclusions of an exact-arithmetic program.
An independent source-retrieval task read the five specified primary
papers; this is source checking, not the Host's independent mathematical
review of this audit.

* Toen--Vaquie, *Moduli of objects in dg-categories*, April 2007 author
  manuscript / arXiv:math/0503269v5, Corollaries 3.17 and 3.19, Definition
  3.18, Lemma 3.27 and Corollary 3.29: perfect-object and arrow moduli,
  with object tangent RHom(E,E)[1], for the finite-type/saturated
  categories attached to a smooth proper scheme. These results do not
  assert quasi-smoothness of a particular restricted arrow problem.
* Schuerg--Toen--Vezzosi, arXiv:1102.1150v4, Definition 3.1 and Proposition
  3.2: the derived determinant exists and its differential is trace[1].
  Proposition 1.2 and Corollary 1.3 give the truncation cotangent comparison
  and a perfect obstruction theory for a quasi-smooth derived DM
  enhancement. The manuscript's galley numbering differs from this
  arXiv version. Proposition 1.5 requires the morphism, not merely both
  endpoints, to be quasi-smooth.
* Manolache, arXiv:0805.2065v2, Definition 4.5, Theorem 4.8 and Corollary
  4.9: a distinguished triangle of [-1,0] perfect obstruction theories
  mapping to the cotangent transitivity triangle gives functorial virtual
  pullbacks. Theorems 4.1 and 4.4 give proper-pushforward, flat-pullback,
  and bivariant compatibility on arbitrary test cycles. DM-type,
  quotient-stratification and global-presentation hypotheses must be
  checked; equality in K-theory is not a compatible triple.
* Graber--Pandharipande, arXiv:alg-geom/9708001v2, Section 1, Proposition 1
  and equation (8): virtual localization for an equivariant perfect
  obstruction theory with a global two-term resolution and an
  equivariant embedding in a smooth ambient space. The moving normal
  is the moving part of the virtual tangent, not of its dual.
* Behrend--Fantechi, arXiv:alg-geom/9601010v1, Proposition 7.3 (relative)
  and Proposition 5.6 (absolute): on a smooth morphism/space, the virtual
  class is the obstruction-bundle Euler class times the smooth class,
  under the stated local-freeness and global-resolution hypotheses.
  No theorem comparing arbitrary obstruction theories merely because
  their classical truncations agree is being assumed.

Sources:
https://arxiv.org/pdf/math/0503269v5 ;
https://arxiv.org/pdf/1102.1150v4 ;
https://arxiv.org/pdf/0805.2065v2 ;
https://arxiv.org/pdf/alg-geom/9708001v2 ;
https://arxiv.org/pdf/alg-geom/9601010v1 .

Additional accepted foundational inputs are relative Serre duality and
perfect proper base change for a smooth proper relative surface,
Riemann--Roch, Hodge index on each surface fiber, Kodaira vanishing in
characteristic zero, the smooth surface Hilbert theorem, and rational
Chow intersection/localization/excess calculus. Fogarty's original paper
was not opened in the bounded source lookup. The rank-one factorization,
the excess comparison, and the particular maps needed here must be
derived below rather than attributed to an uninspected statement.

The old failed shortcut remains retired: numerical surface universality
alone does not determine marked Chow coefficients after an Euler shift.
The accepted retained-output recursion, not that shortcut, is used here.

## 1. The determinant differential and its amplitude

Write A = R pi_* O_X. Evaluation at the surface section o has the
constant-function splitting O_S -> A. Consequently

    P = R pi_* I_o[1] = fib(A[1] -> O_S[1])

is perfect with geometric-fiber cohomology H^1(O_X) in degree zero and
H^2(O_X) in degree one. This is the tangent of the *based derived* Picard
scheme. Using the ordinary smooth Picard tangent instead would leave the
surface obstruction directions in the Quot theory and would give the
wrong virtual rank.

On the arrow enhancement with fixed target V, the universal sequence
gives the actual tangent triangle

    RHom(F,F) -> RHom(F,V) -> RHom(F,Q) -> RHom(F,F)[1].

The determinant of a perfect resolution P^bullet is the alternating
tensor product of det(P^j). Its first-order differential is
sum_j (-1)^j tr(P^j); the derived determinant theorem identifies this
calculation as a morphism of complexes, not just of tangent spaces.
Normalizing a line M to M tensor pi^*(o^*M)^(-1) removes the scalar
summand. Thus the determinant-fixed tangent on the classical Quot fiber is

    T_det = fib(RHom(F,Q) --boundary,trace,based--> P).             (1)

The determinant of Q would give the negative of the source-determinant
map; multiplication by -1 on P identifies the two fibers. There is no
additional localization sign from this choice.

Here and below RHom includes proper derived pushforward along X.
Universal flat kernels and quotients on a smooth relative surface are
relative perfect, even over a nonreduced parameter scheme T. Indeed,
flatness of successive syzygies and the regular two-dimensional fiber
give a finite locally free resolution on X_T. Proper perfect pushforward
and derived base change therefore apply. The selected sheaf/injective
arrow locus is open: fiberwise Tor-amplitude zero and flatness give the
usual flat quotient functor. These constructions can first be made on the
finite-type universal parameter schemes; perfect derived base change
then supplies them on arbitrary test schemes. Their classical
automorphisms are trivial.
At each fiber, Ext^2(F,Q) is dual to Hom(Q,F(K))=0, since Q is torsion
and F is torsion-free. The unrestricted arrow tangent has amplitude
[0,1].

For completeness, the obstruction surjectivity used in (1) is as follows.
Let V_0 have rank r and let F be its kernel with torsion quotient Q_0.
The Serre-dual of

    Ext^1(F,Q_0) -> Ext^2(F,F) -> H^2(O_X)

sends a canonical form omega to the boundary of omega id_F. If that
boundary is zero, omega id_F extends to a map a:V_0 -> F(K). Composing
with F(K) -> V_0(K) agrees with omega id_(V_0) away from the support
of Q_0. Both are maps of vector bundles, so they agree everywhere.
In particular omega Q_0=0.

For nonzero omega, at the generic point of a curve in its zero divisor,
the surface local ring is a DVR. If omega has valuation a_j, the local
quotient is a quotient of (O/(omega))^r, and its length is at most r a_j.
Hence c_1(Q_0) <= r(omega) as effective divisorial cycles. Ampleness
implies

    K.c_1(Q_0) <= r K^2.

This contradicts the strict inequality in the determinant-surjectivity
lemma. Zero-dimensional embedded parts and nonreduced curve support do
not affect this DVR argument. For the full Quot problem,
K.D=3s>2s; for a rank-one high factor the required inequality is
K.D_high>s. Thus the obstruction map is onto in both cases.

The perfect-complex fiber criterion, not constancy of the dimensions of
individual cohomology sheaves, now gives amplitude [0,1] for (1) on
every parameter scheme. Its dual is the obstruction theory induced by
the derived fiber. Transitivity with the smooth base gives the absolute
theory. These are canonical equivariant maps.

Riemann--Roch also checks the rank. If h=integral ch_2(Q), then

    chi(V,Q) = 2h-(K+L_1+L_2).D,
    chi(Q,Q) = -D^2,
    h = nu+L_1.D-D^2/2,
    rank(P) = 1-chi.

Consequently

    v = rank(T_det) = 2nu+(A_0-K).D+chi-1
      = 2t+chi-3 = 51chi-5 > 2t.                                (2)

Fixing determinant has increased the rank by chi-1. Removing only its
H^1 tangent, or fixing an unnormalized trivialization, would not give (2).

## 2. Compatible fixed-to-low pullback

A fixed kernel splits into its two torus weights in families. This is a
direct-summand decomposition of flat sheaves, so remains true over
nonreduced T. Each rank-one kernel factors uniquely as

    F_i = L_i(-C_i) I_(Z_i).

Here C_i is a relative effective Cartier divisor and Z_i/T is finite
flat. One can justify the family assertion without relying on equality
of closed-point moduli. Locally the rank-one kernel has a length-one
locally free resolution. Its maximal-minor determinant map
F_i -> det(F_i) is fiberwise the inclusion into the double dual.
Fiberwise injectivity and the local flatness criterion make its
cokernel finite flat over T. For a finite-flat sheaf on a smooth
relative surface, the two relative regular parameters give grade two;
Hom and Ext^1 into O vanish. The original inclusion into L_i therefore
extends uniquely from F_i to det(F_i). The extension is fiberwise an
injection of lines; its Cartier quotient is T-flat. Untwisting gives
the stated factorization and its compatibility with arbitrary base
change. Conversely this product construction is a flat quotient family.

Let D_i be the Picard class of C_i. Choose one high index with
K.D_high>s, which exists because their sum is 3s. The fixed enhancement
is the derived total-determinant fiber of the product of the two
rank-one arrow enhancements. The direct-sum map to the rank-two
enhancement identifies its tangent, and its cotangent comparison, with
the weight-zero part of (1). Normalization along o cancels all
character lines from the base. The moving tangent is therefore

    direct_sum_(i != j) RHom(F_i,Q_j), weight w_j-w_i.              (3)

Forgetting the high arrow gives f:F_fixed -> Q_low. Its *relative*
derived tangent is the fiber of the high rank-one arrow tangent over P.
The high-index inequality and Section 1 show that this relative tangent
has amplitude [0,1]. This verifies quasi-smoothness of the morphism,
not just of its endpoints.

Here is the obstruction-theory compatibility datum. If E_Y and E_Z
are the cotangents of the enhancements restricted to their truncations,
their transitivity triangle

    Lf^* E_Z -> E_Y -> E_(Y/Z) -> Lf^* E_Z[1]

maps to the classical cotangent transitivity triangle. The two
truncation-comparison cones lie in degrees <=-2. The triangle of
comparison cones shows the same bound for the relative comparison
cone: derived pullback preserves this upper bound, and [1] lowers it.
Together with amplitude [-1,0] for E_(Y/Z), this is exactly the
compatible triple, with actual maps, required by Manolache. In
particular,

    [F_fixed]^vir = f^! [Q_low]^vir.                              (4)

The spaces involved are finite-type quasi-projective schemes (on each
of the finitely many numerical fixed pieces), hence DM and
quotient-stratified. Quot's equivariant Grassmannian embedding gives
the smooth ambient scheme over the smooth S and a linearized ample
line. The equivariant resolution property gives a global two-term
presentation of the perfect obstruction theory. The same applies to
the quasi-projective comparison spaces. Thus neither the bivariant
pullback nor virtual localization is being invoked without its
embedding/resolution hypotheses. No change of base dimension is used
in the support or negative-virtual-dimension arguments.

## 3. Point excess as a morphism of theories

The classical low rank-one Quot is Div_P(X/S) x_S Hilb^r(X/S).
The following argument also works when Div_P is singular. Consider the
map from the divisor enhancement times the smooth relative Hilbert
scheme to the rank-one arrow enhancement, obtained by tensoring the
invertible source with the universal point ideal. Its truncation is
the factorization isomorphism above.

First compare the source objects. Trace splits

    RHom(I_Z,I_Z) = A direct_sum B_Z.

On a geometric fiber the trace-free Ext groups in degrees 0 and 2
vanish: an endomorphism, also after twisting by K, extends to the
determinant line. Riemann--Roch gives dim Ext^1_0(I_Z,I_Z)=2r.
The point-ideal boundary injects Hom(I_Z,O_Z) into this group:
Hom(I_Z,O_X) consists of scalar inclusions, whose composites into
O_Z are zero. The boundary has zero trace since the point ideal
has trivial determinant. The Hilbert scheme is smooth of dimension
2r, so this boundary is an isomorphism.

This is the tangent of the universal point-ideal morphism, not a
chosen dimension-count identification. It supplies the natural map

    A[1] direct_sum T_Hilb -> RHom(I_Z,I_Z)[1].

The map is a quasi-isomorphism on every geometric fiber, and hence
of the perfect family complexes. The entire A[1] summand, including
H^2(O_X), is retained; the low determinant was not fixed.

The arrow-direction comparison is

    R pi_* O_X(C) -> RHom(I_Z,O_X(C)).

Applying RHom(-,O_X(C)) to the universal ideal sequence identifies
its cone with

    RHom(O_Z,O_X(C))[1]
      = (pi_* O_Z(K-C))^vee[-1] = F_point[-1].                    (5)

Relative duality and finite flatness make F_point a genuine vector
bundle of rank r, in every family. The source-object comparison
above and the arrow tangent triangles show that (5) is precisely
the cone of the comparison of the two tangent theories.

There is a commuting morphism to the *same* classical cotangent
complex because this comparison was induced by a morphism of
enhancements with identity truncation. Thus the intrinsic normal cone
maps first into the smaller obstruction bundle stack; that stack
embeds into the larger one with quotient F_point. Zero-section excess
intersection gives

    [Q_low]^vir =
      e(F_low) cap rho^*[Div_P(X/S)]^vir,                         (6)

where rho is the smooth Hilbert projection. This is a cone
factorization plus an actual vector-bundle quotient, not a claim that
equal tangent K-classes imply equal virtual cycles. It supplies the
same-truncation excess argument not stated as a standalone theorem
in the bounded source lookup.

Near either low support 0 or K, the complement line has class 3K or
2K. Kodaira vanishing, followed by upper semicontinuity, gives an
*open neighborhood in the low space* on which its higher cohomology
vanishes. On this neighborhood the classical high map f is a
projective bundle of sections times a smooth relative point Hilbert
scheme, and is smooth even over a singular or nonreduced low base.
It is not merely its restriction to a particular support that is
smooth.

The constructed high relative theory has K-class

    R pi_* O_X(C_high) - 1 + T_Hilb - F_high.                     (7)

Indeed the unrestricted rank-one theory subtracts A, while fixing
the based determinant subtracts P with K-class 1-A; together these
subtract exactly 1. The actual tangent of the smooth high map is
(7)+F_high, by the projective Euler sequence.

For a smooth map with a relative perfect obstruction theory, its
locally split comparison onto the locally free relative cotangent
makes the obstruction sheaf a vector bundle Ob. The relative cone
is [0/T_rel]. Applying zero-section excess after *any* test cycle
alpha gives f^!(alpha)=e(Ob) cap f^*(alpha). Here (7) gives
[Ob]=[F_high], so their total Chern classes, ranks and top Chern
classes agree. This is the point at which a K-class calculation is
legitimate: the obstruction theory and its bivariant operation have
already been constructed. Therefore

    f^!(alpha) = e(F_high) cap f^*(alpha)                         (8)

for every alpha, not just for a fundamental class.

## 4. Low-divisor support, including supported multipliers

Write p=K.P. Ampleness gives p>=0 for every effective low divisor.
Its relative virtual dimension is the integer

    n = (P^2-p)/2.

For 0<p<s, p is a positive multiple of 2q, since K is the sum of
the two pullbacks of the curve canonical divisor, each of degree
2q. Hence 2q<=p<=8q^2-2q. Hodge index and the exact factorization

    (p-2q)(8q^2-2q-p)
      = 8q^2 p - p^2 - 16q^3 + 4q^2 >= 0

give

    n <= (p^2/(8q^2)-p)/2 <= -q+1/4.

Integrality gives n<=-q. A representative of the absolute divisor
virtual class has dimension at most dim(S)-q. Its proper image in
S therefore has codimension at least q. Formulae (4) and (6) preserve
this support, although their relative virtual dimensions can be
positive. More explicitly, if the low cycle is i_* beta from a
closed base-supported locus, bivariant compatibility gives
f^! i_* beta = i'_* f_Z^! beta. Smooth pullback, operational cap and
the marked proper pushforward also stay over that base locus.
No inference from increasing cycle dimension to increasing base
support has been made.

On the open Picard locus H^2(P)=0, the divisor sequence

    0 -> O_X -> O_X(C) -> O_C(C) -> 0

shows that the obstruction map H^1(O_C(C))->H^2(O_X) is onto.
The divisor-to-based-derived-Picard map consequently has a relative
[-1,0] theory with the transitivity compatibility of Section 2.
The based Picard theory has absolute virtual rank

    dim(S) + h^1(O_X)-h^2(O_X) = dim(S)+1-chi < 0.

Its virtual cycle is zero, so the divisor cycle on that open is
zero by virtual pullback. This argument does not require the entire
relative Picard scheme to be smooth over S.

If p>s, duality and ampleness force H^2(P)=H^0(K-P)^vee=0.
If p=s and H^2(P)!=0, an effective divisor in K-P has zero
intersection with K and must be empty. Thus the actual Picard line
is K, not just a numerically canonical line. Chow localization
expresses the remaining low virtual cycle as the pushforward of
some cycle beta on |K|. Its formula is not needed. Nilpotent
thickenings do not change the available cycle representatives or
Chow localization. If p=0, an effective divisor is empty, the
divisor scheme is S, and its tangent complex is zero.

The only low supports are therefore 0 and K. The corresponding high
lines are 3K and 2K; all these linear systems are smooth projective
bundles over S. For K this follows from constant product-of-curves
Hodge dimensions and base change; for 2K and 3K from Kodaira
vanishing. Equations (6) and (8) hold on *every* low support cycle
beta supplied by localization. This is why no formula for the
canonical low virtual cycle, and no restriction to reduced divisor
parameters, is needed.

## 5. The ordered branch and the marked codimension

The numerical identity obtained from the two quotient Chern
characters is

    r+s = nu+(A_0-D_1).D_2.

For the four possible ordered pairs the lengths are, respectively,

    (0,3K): nu+3s = N;
    (3K,0): nu;
    (K,2K): nu;
    (2K,K): nu-s.

We must still exclude the latter three; low support alone does not
exclude them.

Before localization, the pushforward with m=3t surface output
positions and one ch_2^Gm(Q) per position has codimension 2m-v.
The torus acts trivially on the output. Thus its ordinary
codimension-4t part would have equivariant exponent 2t-v=3-chi<0.
It cannot occur in unlocalized equivariant Chow. This selected
component of the localized fixed sum is therefore zero. Setting
the equivariant parameter to 1 is done only after this homogeneous
component has been selected.

On a fixed factor, a marking is

    [Z_i] + (L_i+w_i)(D_i+x_i) - (D_i+x_i)^2/2.

After restricting to the actual surviving divisor supports, every
line decoration is a polynomial in the two curve canonical
divisors and the hyperplane/base classes. Under the assumed pure
W_b tensor test, a line-only slot needs a positive divisor degree
on each curve axis. If k slots are line-only, this uses at least
2k codimensions.

The other m-k slots lie in the two finite point schemes. If their
total length is n_points, their output image has at most n_points
distinct surface positions. The incidence support has codimension
at least 2(m-k-n_points). These are refined intersection support
statements, not assertions about set-theoretic representatives of
arbitrary operational classes: use the universal incidence cycles
and their localized Chern-character/intersection actions. On the
smooth Hilbert/linear-system ambient spaces, refined intersection
preserves the intersection of supports, also when the low multiplier
beta is singular or supported on a special locus. Bivariant proper
pushforward then gives the same assertion on the original fixed
piece.

If n_points<t, then

    2(3t-k-n_points) > 4t-2k.

There is insufficient selected codimension. This excludes every
short branch, with arbitrary low beta as above. Only the *ordered*
branch (D_1,D_2)=(0,3K) remains. On it the low divisor cycle is
[S], the fixed virtual cycle has both point Euler factors, and

    dim(|3K|/S)=chi+3s-1=t.

We now use the reviewed retained-output recursion, without rebuilding
it. Its decorated equality blocks satisfy the following costs after
the isotropic test: one output costs at least 2; two outputs cost
at least 4 because each undecorated curve diagonal pairs isotropic
vectors; k>=3 outputs cost at least 2(k-1). In all cases

    3 cost(k) >= 4k,

with equality exactly for an undecorated block of size 3. For any
finite collection of positive block sizes summing to 3t, total
cost 4t therefore forces all blocks to be bare triples. This is
a uniform finite-sum argument, not an extrapolation from small t.
There is no spare positive base degree or extra decoration.
Closed surface components must have top relative degree. Pushing
the projective bundle |3K| consequently extracts x^t: lower powers
push to zero and higher powers supply positive base degree, which
the output budget excludes.

A surface triple is a product of the two curve triples. Grouping
the three odd first-axis inputs and the three odd second-axis
inputs produces a fixed Koszul sign. Permuting complete surface
inputs has sign +1, since those inputs are even. Thus every labeled
triple partition evaluates to the same signed T_gamma^t; there
is no partition-dependent cancellation. The reviewed scalar
normalization makes the total coefficient (3t)! a_(N,t).
Dividing the zero relation by the common sign and the nonzero
rational number (3t)! proves

    a_(N,t) T_gamma^t = 0 modulo base support of codimension >=q.  (9)

This is the localization implication under the explicit tensor
input, not a verification of that input or of the main theorem.
All scalar divisions are by nonzero rational numbers. The same
argument therefore survives every characteristic-zero scalar
extension in the statement.

## 6. Independent derivation of the moving Euler ratio

Put A_0=K, B=-A_0-D=-4K, and write T_r(M)=M^[r] and
C_B=RHom(O_(Z_1),O_(Z_2)(B)). On (0,D) the two source ideals
are L_1 I_(Z_1) and L_2(-D-x) I_(Z_2).

The forward moving tangent is

    RHom(I_(Z_1),-A_0), at weight 1,
      minus RHom(I_(Z_1),I_(Z_2)(B)), at weight 1-x.

Bilinearity of derived Hom on the two ideal triangles gives

    RHom(I_(Z_1),-A_0) = R pi_*(-A_0)-T_r(K+A_0)^vee,
    RHom(I_(Z_1),I_(Z_2)(B))
      = R pi_*B-T_r(K-B)^vee-T_s(B)+C_B.                         (10)

The reverse moving tangent is

    RHom(I_(Z_2),O_(Z_1)(-B))
      = T_r(-B)-RHom(O_(Z_2),O_(Z_1)(-B)), at weight -1+x.

Relative surface duality identifies its cross term with
C_(K+B)^vee[-2]. Each cross term has virtual rank zero:
the product of the two point Chern characters has degree larger
than the surface dimension. Hence

    e_(-1+x)(C_(K+B)^vee)=e_(1-x)(C_(K+B)),

with no rank sign. Combining (10) with the reverse arrow gives
the inverse moving Euler class

    e_1(T_r(K+A_0)^vee) e_(1-x)(R pi_*B)
       e_(1-x)(C_B) e_(1-x)(C_(K+B))
    ----------------------------------------------------------- .
    e_1(R pi_*(-A_0)) e_(1-x)(T_r(K-B)^vee)
       e_(1-x)(T_s(B)) e_(-1+x)(T_r(-B))

All base-bundle terms of positive degree were excluded in Section
5. The scalar term of e_1(R pi_*(-A_0)) is 1. The other constant
complex contributes (1-x)^chi(B), where chi(B)=chi+10s.
The remaining ratio is exactly Section 06, equation "moving-ratio",
with both cross-Hom factors, both weight signs, and the same
ordered r,s.

There is a second rank check that retains the base complex even
though its weight-one scalar Euler class is 1. Riemann--Roch gives
chi(-A_0)=9chi and chi(B)=81chi. The moving rank in (10) is
N+9chi-81chi=N-72chi; the fixed rank is N+t. Their sum is
51chi-5, exactly (2). Omitting the weight-one base complex *before*
the homogeneous codimension selection would destroy this check.

The fixed factors from Sections 3--5 are

    e((K^[r])^vee),  e_x(((K-D)^[s])^vee).

In the high obstruction line K-D-x the hyperplane is negative
*before* dualizing, so the dual Euler shift is +x. In particular
the shift in the reviewed coefficient integrand is not -x.
Thus, writing Q for the Hilbert-series variable to avoid confusing
it with q=b-1, the coefficient in (9) is precisely

    [Q^N p^(3t) x^t] (1-x)^chi(B) E(Theta(Q,p,x,x))
      evaluated at L=K and H=K-D.

The accepted transfer computes this same fixed marked representative.
Nothing in this audit replaces it by ordinary numerical universality.

## 7. Exact and formal evidence: limits

`verify.py` is an offline standard-library checker for the universal
support-polynomial identity, the Riemann--Roch and parameter
identities, the formal ideal-Hom expansion in (10), and the Euler
weight/duality bookkeeping. It also checks the exact typed Jacobian
factorization against its original payload. These are exact algebra
checks; they do not execute virtual intersection theory or establish
the existence of the Section 04 tensor functor.

The one bounded Jacobian operation is
`polynomial.multivariate.factor.compute`. Discovery, its inspected
contract, exact payload, raw typed result, and adapter status are
preserved in the `jacobian_*.json` files. The server reports version
0.14.0, protocol 2025-11-25, status FACTORIZED, and exact product
reconstruction. The offline checker reconstructs that product
without calling Jacobian or importing SymPy.

`lean/Main.lean` formalizes only `C53_LOC_NUMERICS`: all parameter
inequalities, the integral support estimate under its explicit
Hodge-index hypothesis, the short-length inequality, and the
arbitrary-finite-list equality case of the block budget. Its separate
statement-fidelity document names the declarations and exclusions.
The geometry in Sections 1--6 remains a prose proof against the
listed geometric inputs, not a Lean theorem.

The independent Host Reviewer must judge the family constructions,
the excess-cone factorization, use of arbitrary cycles, and statement
fidelity. No independent acceptance, novelty, publishable-significance
verdict, unconditional tensor-model verification, or full-campaign
completion is asserted by the Engineer.

Relative to the strongest prior result, this adds the determinant-fixed
and fixed-to-low obstruction-theory constructions, point excess on
arbitrary supported multipliers, and the geometric branch exclusion.
The previously accepted marked recursion and coefficient transfer are
unchanged. The remaining Section 04 tensor dependency is not silently
promoted by the new geometric argument or by its arithmetic certificate.

## 8. Recorded validation and review boundary

The offline certificate is generated and replayed with

    python3 -I research/localization_audit/verify.py --write-certificate
    python3 -I research/localization_audit/verify.py

Generation is not an independent review; the default invocation
reconstructs the exact data and compares it to the persisted
certificate without rewriting it. Adapter failure, output-budget
non-conclusions, a changed request, and an incorrect factor sign
were also rejected by four explicit negative tests.

The real Lean 4.31.0 compiler returned exit_code=0 and proof_holes=[]
for the current source and fidelity text. The official command recorded
`C53_LOC_NUMERICS` v3 as `closed_kernel`, with certificate
`lean/certificates/C53_LOC_NUMERICS-d10356f9e5bee83a.json`.
This status belongs only to the explicitly conditional arithmetic
statement. It does not belong to `C53_LOCALIZATION`; the compiler
does not check the truth of the fidelity document or Sections 1--6.
The first arithmetic statement was tightened to name its Hodge and
cost hypotheses explicitly, and a fresh official compile was run
against that claim version.

Both official checks were run with project root
`campaigns/9000053`,
not the shared batch directory. Their zero exit codes are recorded
in `lean_run_validation.json`. The final ledger/graph update is
validated against the same root before handoff; its zero statuses
are also recorded in the public Engineer progress and activity files.

The official citation status currently exits 1. The five geometric
sources were read by the separate source-reading task, but the
official attribution archives have not been filed. The citation
tool unconditionally archives under `research/literature/`, outside
this mission's owned paths; it was not invoked to write there.
The inherited EGL attribution archive is also still open. These
are explicitly outstanding delivery obligations, not a claim that
registry resolution or an Engineer's opinion checked a citation.
Foundational background and the unverified tensor realization
remain explicitly uncited assumptions. Normal Host review is
required before accepting this milestone.
