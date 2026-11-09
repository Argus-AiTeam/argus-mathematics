# A dyadic integral degree-three Gersten kernel with finite residue field

## Result and its scope

**Theorem (D2_MAIN).** Put

    B = (Z_2[x,y]/(2-2x+x^2+xy-y^2))_(2,x,y),
    F_B = Frac(B),                 T = Spec B[1/2].

Here Z_2 denotes the 2-adic integers, not the integers modulo two.
Then B is a two-dimensional Noetherian regular local domain, with residue
field F_2, maximal ideal (x,y), and ord_(x,y)(2)=2. There exists an
**integral** class c in K_3(B) such that

    c|_(F_B) = 0,          rho(c|_T) != 0 in G_3(T; Z/2).

In particular c is nonzero and c is not in 2K_3(B). The theorem makes no
assertion about its additive order, rational image, or survival under
henselization or completion. Only the coefficient ring Z_2 is complete;
the displayed local ring B has not been completed.

This is a mathematical proof from the published inputs below, accompanied
by an exact algebra certificate. It is not a formal verification of
K-theory. Independent Host Reviewer acceptance of this new theorem and its
contribution is pending. The previously reviewed odd-prime theorem is
preserved; the September 25 degree-five theorem remains unresolved.

## 1. Definitions and the external mathematical inputs

For a scheme W write K_i(W;Z/2)=pi_i(K(W) smash M_2), and analogously for
coherent G-theory. These are Moore-spectrum coefficient groups, **not**
the quotients K_i(W)/2. The cofiber sequence gives

    K_i(W) --2--> K_i(W) --rho--> K_i(W;Z/2)
        --partial_coef--> K_(i-1)(W) --2--> K_(i-1)(W).

We use only the canonical mixed operation

    K_i(W;Z/2) x K_j(W) --> K_(i+j)(W;Z/2).

It comes from the K(W)-module structure on K(W) smash M_2. Smashing a
pairing of K-theory spectra with M_2 constructs it. No multiplication
M_2 smash M_2 -> M_2, no coefficient-by-coefficient product, and no
claim that multiplication by two is null on M_2 is used.

The following inputs were read in the archived primary texts and the
author-hosted K-book. Their hypotheses are part of the proof.

| Input | Exact proposition and version | Application |
|---|---|---|
| A1 | Friedlander--Suslin, *The spectral sequence relating algebraic K-theory to motivic cohomology*, Ann. Sci. ENS 35 (2002), DOI 10.1016/S0012-9593(02)01109-6, Theorems 15.5 and 16.2, Appendix C.2--C.3; especially the last sentence of Theorem 16.2, printed p.853. | Strong convergence and the filtered **mixed** integral/coefficient pairing for every modulus, including two. On the abutment this is the usual mixed K-product. |
| A2 | Suslin, *On the Grayson Spectral Sequence*, Trudy 241 (2003), pp.218--253, Math-Net tm398, Lemma 3.4, Theorem 6.1, Corollary 7.5 and Theorem 7.6; Voevodsky, Annals 174 (2011), DOI 10.4007/annals.2011.174.1.11, Theorem 6.16. | Product-compatible motivic complexes and H^s(E,Z/2(j)) = H^s_et(E,mu_2^(tensor j)) for every s<=j. Every field used here is characteristic zero and perfect; norm-residue applies also to its finitely generated extensions, as required by Suslin 7.6. For a field, motivic groups vanish for s>j. |
| A3 | Weibel, *The K-book*, author-hosted PDF dated August 29, 2013, VI.7, printed p.508, paragraph preceding Proposition 7.3. | A finite extension of Q_2 has etale cohomological dimension two, including at the residue-characteristic prime. This is not a statement about its valuation ring. |
| A4 | Weibel, same version, III.6.1, IV.1.7.1, IV.1.10.1 and IV.7.2. | Matsumoto symbols generate field K_2, are bilinear, obey {u,1-u}=0, and agree with integral K_1 products in Quillen K_2. For F_2 this presentation has only the trivial unit and gives K_2(F_2)=0 directly. |
| A5 | Quillen, *Higher algebraic K-theory I*, DOI 10.1007/BFb0067053, section 7.1, section 7 paragraphs 2.7--2.8 and Proposition 3.2; Weibel V.3.3, V.4.1, V.5.1 and V.6.11. | Resolution for the regular rings B and S; coherent localization, devissage and proper pushforward for the projective curve and its closed points. No smoothness of the special fiber is assumed. |
| A6 | Weibel, same version, III.1.7.1 and the following paragraph; V.3.3.2 and V.3.7.2. | Finite-field-extension K_1 transfer is the norm. The spectrum-level projection formula remains valid after smashing its base-field factor with M_2. Localization is flat; base change for the finite immersions is also an explicit tensor identity below. |
| A7 | Quillen, section 7 Proposition 2.2, equation (2.4), printed pp.124--125; Weibel IV.6.4. | Continuity of coherent G-theory for Noetherian separated schemes with affine **flat** transition maps. The coefficient version follows by exact filtered colimits, without any exponent assumption on the coefficient groups. |
| A8 | Stacks Project, Tags 00NO, 00NP and 00NQ. | A regular local ring has polynomial associated graded, is a domain, and quotienting by part of a regular system of parameters is regular of the predicted dimension. |

The existing archive is `../degree_three_audit/literature/`. In particular,
`motivic/fs-sequence-excerpt.txt` contains the exact all-moduli assertion,
and `motivic/fs-products-excerpt.txt` distinguishes mixed products from
coefficient products. Weibel VI.4.2.1, printed p.481, states the same
distinction explicitly: its first paragraph restricts coefficient
multiplication to m not congruent to 2 modulo 4; its **second** paragraph
gives the mixed pairing for any Z/m. It identifies the E_2 product with
motivic cup product and the abutment with the actual K-module operation.

Suslin's cited edition is the Trudy pagination, not the differently
paginated English edition. Voevodsky 6.17 alone is not being substituted
for the truncated comparison: its target is etale motivic
hypercohomology. Suslin 7.5--7.6 and Voevodsky 6.16 supply the precise
mu_2-coefficient statement used here.

The previous independent review read these general source statements.
It did not certify their new dyadic application. New assumption judgments
and the new theorem are therefore left for the normal Host Reviewer.

## 2. The sign repair and the regular local model

The unmodified odd-prime polynomial, at p=2 and zeta_2=-1, gives

    (t-1)^2-1 = t(t-2)

on y=0. Its constant term and norm of t are zero; it does not supply
the Eisenstein divisor used by that argument. This is a failure of that
substitution, not a counterexample to an odd-prime theorem.

Instead put

    Q(X,Y,Z) = 2Z^2-2XZ+X^2+XY-Y^2,
    Xcal = Proj Z_2[X,Y,Z]/(Q),          C = Xcal_(Q_2),
    f(x,y) = 2-2x+x^2+xy-y^2,
    R = Z_2[x,y]/(f),                   m = (2,x,y).

The given B is R_m, the local ring of Xcal at m=[0:0:1].
This is the sign-uniform replacement

    -(Z-X)^p - X*Y^(p-1) + Y^p + zeta_p*Z^p = 0

at p=2, multiplied by -1. For odd p the replacement is exactly the
reviewed equation because -(Z-X)^p=(X-Z)^p.

In the ambient regular local ring Z_2[x,y]_(2,x,y), with parameters
2,x,y, one has f=2 modulo the square of the maximal ideal.
Thus f,x,y are another regular system of parameters. A8 gives that
B is regular of dimension two and is a domain. Since f is monic of
degree two in x, R is free of rank two over Z_2[y]; hence R and B
are Z_2-flat. The nonzero local ring B therefore has characteristic
zero and residue field F_2.

The exact identity in B is

    2(1-x) = -x^2-xy+y^2.

As 1-x is a unit, m_B=(x,y) and 2 belongs to m_B^2. In
gr_m(B)=F_2[xbar,ybar], its initial degree-two form is

    xbar^2+xbar*ybar+ybar^2,

which is nonzero. Consequently ord_m(2)=2 exactly. In particular
this is a ramified ring; neither a smooth-over-Z_2 assertion nor an
unramified Gersten theorem is applicable.

Modulo two, Q becomes g(X,Y)=X^2+XY+Y^2. The polynomial
s^2+s+1 has no root in F_2 and is separable. It is irreducible,
as is its homogenization g: there is no factor Y, and any remaining
homogeneous factorization would dehomogenize to a factorization of
s^2+s+1. It stays irreducible upon adjoining Z. A factorization
of Q over Q_2 would give primitive positive-degree homogeneous
factors over Z_2. Their reductions retain their positive degrees
and would factor g, a contradiction. Thus C is an integral
projective curve. This argument proves integrality, not just
regularity at the distinguished closed point.

For completeness the generic conic is smooth: its gradient matrix,
in coordinates X,Y,Z, is

    [ 2  1 -2 ]
    [ 1 -2  0 ]
    [-2  0  4 ],

whose determinant is -12, nonzero in Q_2. This additional check is
not needed for the coherent G-theory argument.

## 3. The distinguished DVR and the residue-degree separation

Let S=B/yB, and let t be the image of x. The polynomial

    h(t)=t^2-2t+2

is Eisenstein at two. The finite free Z_2-algebra S_0=Z_2[t]/(h)
is a domain and is local, since S_0/2=F_2[t]/(t^2). Its maximal
ideal is (2,t). The identity

    2=t(2-t)

makes that ideal (t). S_0 has dimension one, so it is a DVR with
uniformizer t. The localization defining B/yB changes nothing;
therefore S=S_0. Its fraction field D has [D:Q_2]=2,
ramification index two, and residue degree one.

Set eta=1-t. Then

    eta+t=1,          eta^2=-1,          N_(D/Q_2)(t)=2.

In particular eta is a unit and is a primitive fourth root of unity;
D=Q_2(eta). Both eta and 1-eta=t are nonzero. Multiplication by
t in the basis 1,t has matrix

    M = [[0,-2],[1,2]].

It satisfies M^2-2M+2I=0 and (I-M)^2=-I. More generally

    N_(D/Q_2)(a+bt) = det(aI+bM) = a^2+2ab+2b^2.

The constant term gives N(t)=2, with no odd-degree norm sign left
implicit. Also S[1/2]=D. On C the equation Y=0 gives the single
closed point q0 with field D; there is no additional point at
Y=Z=0 because Q(1,0,0)=1.

Let q be any closed point of C and E its residue field, finite
over Q_2. Its E-point extends over O_E: scale its homogeneous
coordinates so they are integral and at least one is a unit.
The reduced coordinates lie on g=0. If its specialization is
not m, then Y is nonzero, since Y=0 forces X=0. Thus the residue
of X/Y is a root of s^2+s+1, so k_E contains F_4 and

    2 divides f(E/Q_2) = [k_E:F_2].

This holds for ramified extensions and for points at infinity as
well as on the affine chart. It is a statement about **residue
degree**, not total degree. Conversely the distinguished field D
has residue degree one despite its total degree two.

## 4. The actual field product at modulus two

Fix beta in K_2(Q_2;Z/2) with partial_coef(beta)=[-1].
Such a beta exists by the coefficient exact sequence because -1
has order two in the integral group K_1(Q_2)=Q_2^*. For every
finite E/Q_2 write beta_E for its restriction.

**Field lemma (D2_FIELD).** For every finite extension E/Q_2,
the specified mixed product is an isomorphism

    theta_E: E^*/E^(*)2 --> K_3(E;Z/2),
             u mod squares |--> beta_E*[u].

The group on the right is killed by two, but this will be a
**consequence** of its filtration, not an assumption about M_2.

By A1--A3 there is a natural, strongly convergent spectral sequence

    E_2^(a,b) = H^(a-b)(E,Z/2(-b)) ==> K_(-a-b)(E;Z/2).

The smooth-field statements are applied to Spec E over E itself,
not to B or Z_2; no finite-generation assumption on E over Q is
needed.

Write s=a-b and j=-b; total K-degree is 2j-s. Its possibly
nonzero terms satisfy

    j>=0,              0<=s<=min(j,2).

Negative weights vanish. For s>j use field motivic vanishing;
for s<=j use A2, including vanishing at negative etale degrees,
and A3. This makes no assertion about all negative-degree
**integral** motivic groups.

A differential d_r, r>=2, changes (s,j) to
(s+2r-1,j+r-1). The change in s is at least three. Therefore
all differentials from or to the nonzero strip vanish. In total
degree three the only possible piece is (s,j)=(1,2). Strong
convergence gives a natural edge isomorphism

    K_3(E;Z/2) = H^1_et(E,mu_2^(tensor 2)).

There is no other filtration quotient to produce an extension.
In particular 2K_3(E;Z/2)=0. Degree two, by contrast, has
pieces (0,1) and (2,2). We make no splitting or exponent-two
assertion for K_2(E;Z/2).

Let alpha_E in H^0(E,mu_2) be beta_E's weight-one image.
Restrict to an algebraic closure Ebar. Its positive-degree etale
cohomology vanishes, so K_2(Ebar;Z/2)=H^0(Ebar,mu_2).
Matsumoto's presentation also shows K_2(Ebar)/2=0: any symbol
{u,v} is twice {r,v} after choosing r^2=u, and symbols
generate. Thus the coefficient boundary is an isomorphism

    K_2(Ebar;Z/2) --> K_1(Ebar)[2].

The restriction of beta_E has nonzero boundary [-1]. Naturality
implies alpha_E is nonzero; it is the unique nonzero element of
H^0(E,mu_2). This remains true when E contains a square root of
-1: being a square does not make -1 trivial in integral K_1(E).

Integral K_1(E)=E^* has only the weight-one piece
H^1(E,Z(1)). Indeed, on its degree-one diagonal all j>=2
have s=2j-1>j, weight zero gives H^(-1)(E,Z(0))=0,
and negative weights vanish. The standard identification
Z(1)=G_m[-1] identifies reduction of [u] with its Kummer
class in H^1(E,mu_2).

For the decreasing weight filtration F^j, the mixed pairing gives

    F^2 K_2(E;Z/2) * F^1 K_1(E)
        subset F^3 K_3(E;Z/2) = 0.

Consequently beta_E*[u] is determined by alpha_E and the
weight-one class of u. On the surviving quotient A1--A2
identify this **actual** product with

    alpha_E cup Kummer(u).

Multiplication by the unique nonzero invariant alpha_E identifies
the constant modules mu_2 and mu_2^(tensor 2). It induces an
isomorphism on H^1. Kummer theory now proves the field lemma.
The product factors through squares because its target was
independently proved to have exponent two. This is not a
dimension count, and not a coefficient-ring Bott argument.

Changing beta while retaining its boundary does not change this
map: the difference has zero weight-one image after restriction
to Ebar, hence before restriction, and its product with K_1
vanishes by the displayed filtration calculation.

## 5. Both integral lifts and integral generic vanishing

Put a_D=beta_D*[t]=theta_D(t). The coefficient sequence is a
sequence of K(D)-modules, so its connecting map respects
multiplication by an integral class, up to a suspension sign.
A4 and eta^2=-1 give

    partial_coef(a_D)
        = +/- [-1]*[t]
        = +/- {eta^2,1-eta}
        = +/- 2{eta,1-eta}
        = 0 in K_2(D).

The integral boundary of beta_D itself is still [-1], not zero.
The vanishing is the Steinberg relation, not the assertion that
a square has trivial integral K_1 class.

Exactness supplies an integral lift a_tilde in K_3(D).
Localization and devissage for the DVR S give

    K_3(S) --> K_3(D) --> K_2(F_2).

The last group is zero by A4: the field's multiplicative group
has only 1, so bilinearity makes every generating symbol zero.
Thus a_tilde has a second integral lift b in K_3(S).

Let j:Spec S -> Spec B and define c=j_*b in G_3(B)=K_3(B),
using regular resolution. Its restriction after inverting y is
zero because the support disappears. The element y is nonzero:
it is a member of the regular system of parameters of B (also
B/yB has dimension one, rather than two). Hence c|_(F_B)=0
**integrally**, without passing to coefficients or rationalizing.

After inverting two, j becomes i:Spec D -> T. For a finite
S-module M there is a natural exact base-change identity

    B[1/2] tensor_B M = D tensor_S M

as B[1/2]-modules. Restriction, finite pushforward and coefficient
reduction commute. Therefore

    rho(c|_T) = i_*a_D in G_3(T;Z/2).

## 6. Transfer, norm, and the detector

For any finite extension E/Q_2, A6 is a spectrum-level projection
formula. Smash its base-field factor with M_2. Since beta_E
is the restriction of beta and K_1 transfer is the ordinary
field norm, it gives

    Tr_(E/Q_2)(beta_E*[u]) = beta*[N_(E/Q_2)(u)].

Equivalently Tr theta_E(u)=theta_(Q_2)(N(u)). No
coefficient-by-coefficient pairing is involved. Moving the
degree-two factor introduces no graded sign.

Define

    lambda = (v_2 mod 2) o theta_(Q_2)^(-1).

All local-field valuations here give a uniformizer value one.
For completeness the norm valuation is

    v_2(N_(E/Q_2)(u)) = f(E/Q_2)*v_E(u).

Indeed multiplication by a uniformizer on the finite free
Z_2-module O_E has cokernel k_E, of Z_2-length f(E/Q_2).
The valuation of its determinant equals that length. Units
give determinant units, and multiplicativity handles all
positive and negative valuations.

The field lemma is surjective for **every** finite E/Q_2.
It follows that lambda annihilates the transfer of **every**
class in K_3(E;Z/2) when f(E/Q_2) is even. For the
distinguished field it instead gives

    lambda(Tr_(D/Q_2)(a_D)) = v_2(N(t)) mod 2 = 1.

Using [D:Q_2]=2 in place of its residue degree one would
give the wrong answer. The replay explicitly separates them.

## 7. Coherent continuity and detection

Let Sigma=R minus m, and for h in Sigma put

    U_h = Spec R[1/2,1/h] subset C.

Products give common refinements, each refinement map is a
principal localization and hence affine and flat, and

    B[1/2] = colim_h R[1/2,1/h],       T = lim_h U_h.

The stages and limit are affine Noetherian separated schemes.
A7 yields integral G-theory continuity in degrees two and three.
Apply the natural short exact coefficient sequences

    0 -> G_3(W)/2 -> G_3(W;Z/2) -> G_2(W)[2] -> 0.

Exactness of filtered colimits identifies their outside terms
at the limit, and therefore their middle terms. Thus

    colim_h G_3(U_h;Z/2) = G_3(T;Z/2).

This uses neither splitting of these sequences nor an assertion
that these arbitrary coefficient G-groups have exponent two.
In particular, vanishing at T already occurs at some U_h.
T is not assumed to be a single open subscheme of C.

Every point of C specializing to m lies in every U_h. Its
O_E-point lies entirely in Z!=0, since the inverse image of
that chart contains the closed point of the local scheme
Spec O_E. There h has nonzero residue at m and is a unit.
In particular q0 belongs to U_h. The complement C minus U_h
is a proper closed subset of an integral projective curve, so
it is a finite collection of closed points. Each specializes
away from m, and its residue field E_q has even residue degree
by Section 3.

Consider w=(q0)_*a_D in G_3(C;Z/2). Finite-immersion base
change and continuity identify w|_T=i_*a_D=rho(c|_T).
Suppose this is zero. Then w|_(U_h)=0 for some h.
Coherent localization and devissage, followed by smashing the
fiber sequence with M_2, give an exact segment

    direct_sum_(q in C minus U_h) K_3(E_q;Z/2)
        --> G_3(C;Z/2) --> G_3(U_h;Z/2).

Thus w=sum q_*a_q for arbitrary coefficient classes a_q.
Apply proper pushforward along C -> Spec Q_2. It exists
in coherent G-theory since C is projective, and composition
identifies each point's pushforward with field transfer.
Section 6 gives

    lambda(p_*w) = sum_q lambda(Tr_(E_q/Q_2)(a_q)) = 0.

The same expression computed at q0 equals one. This
contradiction proves rho(c|_T) != 0. Together with Section 5
it proves D2_MAIN, including integral generic vanishing.
Finally if c were twice an integral class then rho(c|_T)
would vanish by the coefficient sequence. Hence c is not
in 2K_3(B).

## 8. Extension and comparison with the strongest prior result

**Dyadic family corollary (D2_ODD_RESIDUE).** Let H/Q_2 be
unramified of odd degree d, V=O_H, and set

    B_d=(V[x,y]/(2-2x+x^2+xy-y^2))_(2,x,y).

The theorem holds for B_d with residue field F_(2^d), with
the same dimension and order of two, and coefficients Z/2.

**Proof.** If alpha^2+alpha+1=0, then alpha^(2^d)
=alpha+1 for d odd. Therefore s^2+s+1 remains irreducible
over F_(2^d). A point specializing away from m has even
relative residue degree. The divisor polynomial is still
Eisenstein at the uniformizer two; S=V[t]/(t^2-2t+2)
has residue F_(2^d), relative residue degree one and norm two.
The field proof applies to H and every finite extension of
H because they are finite extensions of Q_2. For the second
integral lift use K_2(F_(2^d))=0, the finite-field assertion
in Weibel III.6.1.1 already independently read in the
previous mission. All other steps above are unchanged.
For d even the residue polynomial splits and this
residue-degree detector argument is unavailable; no
nonexistence conclusion about B_d is asserted. QED.

Combining this corollary with the already reviewed odd-prime
family in `../degree_three_audit/report.md`, Section 8, supplies
the sign-uniform all-prime construction for every prime p and
every unramified degree d prime to p. This is a logical
corollary of those two proofs, not a re-review of the
odd-prime theorem or of the degree-five manuscript.

The actual improvement over the strongest accepted campaign
result is the previously excluded prime two, at the same
dimension and with finite residue field. The independent
primary-source search by `dyadic-prior-art` inspected the
following **statements**, not their proofs.

| Primary work and exact locator | What its statement already supplies | What it does not supply for this comparison |
|---|---|---|
| OpenAI, *An integral degree-three Gersten counterexample*, September 26, 2026, Theorem 1.1; openai/math commit 4eaee87548250b2682affda7d05d947c05554bae, `preprints/An-Integral-Degree-Three-Gersten-Counterexample-September-26-2026/build/sections/introduction.tex`, lines 17--46. | Dimension two, residue F_5, integral K_3 generic kernel with mod-five detection on the inverted-prime locus. This is the closest statement template. | Prime two. Its statement leaves order and rationalization unspecified, as ours does. |
| *Rational Gersten kernels in ramified regular local rings*, October 8, 2026, Theorem 28.1; HayamaKazuma/gersten-counterexamples commit 2d9a8a4ee519c4ad42d27dd914db7d9543b03a41, `paper/sections/05-two-dimensional-families.tex`, lines 439--456 and 646--650. | For each p and degree e>=3 with p not dividing e, the ring (Z_(p)[T,x,y]/(p+x^e+y^e+Txy^(e-1)))_(p,x,y) has dimension two and residue F_p(T), with rational K_3 generic-kernel dimension at least floor(e/2). The explicit (p,e)=(2,3) case is dyadic. Its introduction, lines 3--13, says the witnesses are integral classes of infinite order with **integral** generic vanishing. | A dimension-two example with finite residue field. No specialization of T preserving the classes or our mod-two detection assertion is stated. Calling this merely a rational or merely nonintegral result would understate the overlap. |
| Same rational manuscript, Theorem 17.4, `paper/sections/04-three-dimensional-families.tex`, lines 2252--2289, same pinned commit. | The dyadic rings (Z_(2)[x,y,t]/(xy+Phi_(2^r)(t)))_(2,x,y,t-1), r>=2, have integral K_3 generic-kernel classes rationally independent, with persistence under henselization and completion. The displayed maximal ideal gives residue F_2. | Dimension two: these rings have dimension three. Thus finite-residue dyadic examples are already asserted, and are not the novelty claimed here. |
| Feld, arXiv:2608.05005v2, Theorem 1.1, Corollary 5.1 and Remark 5.2. | For A=V[[x,y]]/(3+x^2-y^3), with uniformizer 3 in V, noninjectivity in K_2(-;Z/3). Finite residue fields are allowed. Corollary 5.1 gives an integral lift with generic image divisible by three. Remark 5.2 suggests an odd-prime degree-(p-1) finite-coefficient variant without proving it. | Integral generic vanishing, degree three, or prime two. Divisibility is not integral vanishing. |
| OpenAI, *An integral counterexample to Gersten's conjecture*, September 25, 2026, Theorem 1.1, same openai/math commit, `preprints/An-Integral-Counterexample-to-Gerstens-Conjecture-September-25-2026/build/source/sections/introduction.tex`, lines 18--30. | Dimension-two integral **K_5** generic kernel, characteristic (0,5), residue F_(5^8). | The dyadic K_3 conclusion. This theorem is not a dependency and remains unaudited here. |
| Feld, *Gersten injectivity and Morel's purity conjecture*, hexagon:2611.00017v1, introduction and Corollary 7.2; source `morel_purity_counterexample_2026_11_01_13_25_UTC.tex`, lines 281--296 and 1336--1349. | Conditional consequences of assumed integral/rational examples. Its Corollary 7.2 assumes rational K_3 failure for a henselization or completion of the characteristic-three ring (Z_(3)[x,u,v]/(uv-x^2-3))_(x,u,v). | Independent confirmation: its introduction explicitly does not use the unrefereed integral/rational manuscripts as proved results. |

Primary entry points:

- <https://github.com/openai/math/tree/4eaee87548250b2682affda7d05d947c05554bae/preprints>
- <https://github.com/HayamaKazuma/gersten-counterexamples/tree/2d9a8a4ee519c4ad42d27dd914db7d9543b03a41/paper>
- <https://arxiv.org/abs/2608.05005v2>
- <https://hexagonmath.org/2611.00017v1>

No inspected statement supplies the conjunction of dimension
two, residue F_2, an integral K_3 generic-kernel class and the
specified mod-two detection. This bounded comparison supports
that **specific** contribution; it is not an exhaustive
absence theorem or an independently accepted novelty verdict.
We do not claim the first dyadic K_3 example, the first
integral K_3 example, or the first finite-residue dyadic
example. Publication-level significance and verified novelty
remain for the Host Reviewer, including any additional
primary statement that already entails this special case.
This comparison is not an improvement in every direction: unlike
the rational families, our result does not establish infinite
order or persistence under henselization and completion.

## 9. Exact evidence and its limits

The accompanying `verify.py` uses only Python's standard
library and exact integer/rational arithmetic. It checks
the defining and boundary polynomials, cotangent and
initial-form identities, Eisenstein coefficients, the
quadratic multiplication matrices and symbolic norm,
the finite-field Frobenius relation, the residue-degree
parity obstruction, all possible relevant spectral
positions from the stated nonzero strip, and the
detector values. It compares its deterministic result
with `exact_certificate.json`, validates the retained
Jacobian request and typed answer, and rejects deliberately
corrupted certificates and adapter answers.

The bounded Jacobian operation is
`polynomial.multivariate.resultant.compute`, inspected
before execution through the authorized Argus adapter.
It computes Res_t(t^2-2t+2,a+bt). The exact payload, raw
typed output and adapter exit status are separate JSON
files in this directory. The independent replay computes
the same polynomial by a two-by-two determinant.
The typed outcome's server/protocol identifiers and any
structured failure are retained; UNKNOWN or a failure
would not be a mathematical result.

The retained execution returned a^2+2ab+2b^2 with adapter
exit status zero, server 0.14.0, protocol 2025-11-25 and no
structured error. The standalone replay passed seven exact
check groups and ten false-input rejection tests.

Run from the campaign root, without network access or packages:

    python3 research/dyadic_audit/verify.py

This replay is not a computation of Quillen K-groups or
an algorithm choosing the noncanonical integral lifts.
It does not prove a spectral sequence exists or check a
source's hypotheses. The universal residue-degree
statement is proved in Section 3; the universal field
isomorphism and exponent statement are proved in Section
4 from A1--A4, not inferred from finitely many test fields.
The theorem's K-theoretic content, source fidelity and
contribution require independent mathematical review.
