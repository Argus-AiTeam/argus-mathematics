# The prime-five rational unit obstruction

## Outcome and scope

**Theorem.** At p=5 the exact canonical map

    L_0 X -> L_0 L_K(2) X,  X=L_2 L_K(3) S_5-complete,

is nonzero on pi_-3. Consequently the canonical unit
`u:L_2 S_5-complete -> X` has no retraction in underlying spectra.

Section 4 supplies the previously missing completed, full
P_3 x P_2-equivariant transport and its ordinary localization
factorization. Section 2 then applies to every retraction, not just
module maps or chosen filtration projections. The accepted
`C318H3BASES` and `C318H3P5` are reused unchanged.

This is a human mathematical proof using explicitly identified
literature inputs. The exact verifier and the two Lean sources certify
the stated algebraic cores, not spectra or the geometric applications.
The sealed independent review supports the detector, its no-retraction
consequence and the scoped algebraic statement fidelity. Section 6
assesses the additional conclusion separately from publication novelty;
it does not reopen that mathematical review. No false assertion of the
staged manuscript is claimed.

## 1. Objects, maps, and accepted inputs

Work at p=5. Write

    S = S_5-complete,  A = L_2 S,  D = L_K(3) S,
    X = L_2 D,        R = L_K(2) S,
    u = L_2(S -> D): A -> X.

Let eta be the ordinary K(2)-localization unit, and put

    tau_X = L_0(eta_X): L_0 X -> L_0 L_K(2) X.

The two accepted claims `C318H3BASES` and `C318H3P5`, independently
reviewed on 2026-11-05, are reused unchanged. No coefficient proof,
certificate, or compiler run supporting them is reopened. The part
needed below is the equivalence

    b = (unit, y_1): R vee Sigma^-1 R -> L_K(2) X,

whose first component is exactly L_K(2)u after the canonical
identification L_K(2)A = R. It is not merely an unpointed equivalence
between spectra with the same ranks.

Rationalization and K(2)-localization identify the corresponding
source and target for D and X. Indeed D -> L_2 D is both a K(0)-
and a K(2)-equivalence. Naturality of eta identifies their tau maps.
Likewise S -> L_2 S is a K(0)- and K(2)-equivalence. The passage from
the ordinary sphere to S is a K(2)-equivalence; it does not identify
their rationalizations. In the present notation L_0 S = H Q_5.

The primary-source rational calculation used here is BSSW,
arXiv:2402.00960v2, Theorem A:

    pi_* L_0 R = Exterior_(Q_5)(zeta_1, zeta_2),
    |zeta_1|=-1, |zeta_2|=-3.

In particular its only degrees are 0,-1,-3,-4. This is a cited known
result, not a new computation or a formalization of spectra.

## 2. Arbitrary retractions: the implication is true

**Theorem 1.** If tau_X is nonzero on pi_-3, no map of underlying
spectra r:X -> A satisfies r u = id_A.

**Proof.** Suppose r were such a map. Apply K(2)-localization and use
b. The resulting map

    v = L_K(2)r b: R vee Sigma^-1 R -> R

is the identity on the first summand. Nothing requires its second
component to be zero, linear over R, or compatible with a filtration.
However,

    pi_-3 L_0(Sigma^-1 R) = pi_-2 L_0 R = 0.

Thus pi_-3 L_0 v is the identity from the sole first-summand Q_5
line onto pi_-3 L_0 R.

The ordinary naturality square is

    L_0 X  ----tau_X---->  L_0 L_K(2) X
      | L_0 r                    | L_0 L_K(2)r
      v                          v
    L_0 A  ----tau_A---->  L_0 R.

The bottom source has no pi_-3, since L_0 A = H Q_5. Therefore the
right vertical map kills the image of tau_X in that degree. That
vertical map is an isomorphism in this degree by the preceding
unit-first calculation. Hence tau_X is zero there, a contradiction.
This proves the assertion for every underlying-spectrum retraction.
No choice of filtration attachments is involved. QED.

This conclusion was not supplied by the accepted filtration alone.
Nor does its converse follow: vanishing of one rational obstruction
does not construct a retraction.

## 3. What completed constants descent actually does

Use the rational-obstruction manuscript's notation

    P = P_3,  N = P_3^1,  Q = P/N = Z_5,
    J = P_2,  G = P x J,
    B = the connected completed solid height-two theory.

The actual map from E_2 induces, as proved in Section 4.2,
the individual-coefficient equivalence

    M_t = pi_t E_2  ->  R Gamma(N, pi_t B),                 (HD)

with its residual J x Q action, with Q trivial on M_t. Retaining
the actual map and this action is essential. An unlabelled equality
of cohomology dimensions would not suffice.

For comparison with the retired route, first forget J. Composition of
derived invariants for the
normal subgroup N gives

    R Gamma(P,pi_0 B) = R Gamma(Q,R Gamma(N,pi_0 B))
                     = R Gamma(Q,M_0).

The displayed equivalence is induced by constants/connected base
change, not chosen afterward. For Q=Z_5 and the trivial profinite module

    M_0 = W(F_(5^6))[[u'_1]],

continuous cohomology is computed by the two-term completed
resolution Lambda --(gamma-1)--> Lambda of Z_5. The induced
coefficient differential is zero. Its cohomology is confined to
degrees zero and one. Equivalently, one can take the inverse limit
of the same calculation on the finite quotients by (5,u'_1)^m:
their H^0 and H^1 transition maps are surjective, so no lim^1 term
survives. In particular H^3(P,pi_0 B)=0.

This only concerns the image after forgetting J. To conclude that
the product-group image vanishes, one would need a further map

    H^3(P,pi_0 B) -> H^3(P x J,pi_0 B)

compatible with the coefficient unit. Ordinary coefficient inflation
along P x J -> P requires J to act trivially on the coefficient
module. Here it does not. A nullhomotopy after forgetting J need not
be J-equivariant. Thus (HD) is not an inconsistency with c_3 nonzero.

Here is an exact model of the issue. Over Q let v_i, for 0<=i<=3,
have bidegree (i,3-i), and w_i, for 0<=i<=2, have bidegree (i,2-i).
Put

    d_vertical(w_i)=v_i,  d_horizontal(w_i)=-v_(i+1),
    d_vertical(v_i)=d_horizontal(v_i)=0.

These are commuting-to-zero differentials of a bicomplex, and its
total differential is d(w_i)=v_i-v_(i+1). The degree-three class v_0
is zero in the vertical cohomology of column zero, but is nonzero
in total cohomology. Indeed the sum of its four coordinates is one,
whereas every total boundary has coordinate sum zero. Its total
class equals that of v_3. In particular it can migrate from
bidegree (0,3) to (3,0) through the three necessary homotopies.

This refutes the proposed forget-and-inflate inference, not any
assertion in the staged manuscript. That failed audit route is
retired in the ledger with this specific reason.

## 4. The positive primitive-transport route

Here is an application proof of the required comparison. We keep
finite coefficients until after derived limits. For a v-stack Z write

    H_b^i(Z) = H^i(R lim_m R Gamma_v(Z,Z/5^m))[1/5].

The same convention applies to continuous group cochains. In
particular this is not obtained by putting an unbounded-denominator
Q_5 sheaf on a noncompact space.

### 4.1 Finite resolutions and the completed constants

Put k=F_(5^6), F=widehat L(*), P=P_3, J=P_2 and G=P x J.
Let N_0=ker(Nrd:P->Z_5^times), N=Nrd^-1(mu_4), and
Q=P/N=Z_5. Thus N is not just the norm kernel. Put H=J x Q.

The primary coheight-one paper of Barthel--Mann--Ray--Schlank--
Senger--Weinstein--Zhou will be abbreviated BMR. The archived primary
PDF is dated **October 7, 2026**. We use its actual statements, not an
assertion that we obtained the August 26 version cited by the staged
manuscript. The locators used here agree in the obtained version.

BMR Proposition 2.7.1 gives F perfect and identifies Spd F with the
space of actual surjections

    E_3^0=O(1/3) -> E_2^0=O(1/2).

It also identifies the quotient by N_0 with the punctured negative
Banach--Colmez space of slope -1/2. BMR Propositions 3.5.6 and 3.6.9,
with Theorem 3.6.10, compute its characteristic-five cohomology. The
nonconstant term is in degree three; the residual norm scalar alpha
acts on it by the reduction of alpha^-2. On mu_4 this character is
nontrivial: a generator with residue 2 acts by 4, not 1.
Taking mu_4-invariants is exact because 4 is invertible in k.
Consequently the *constant map*, not merely some isomorphism, gives

    k -> R Gamma(N,F)                                      (4.1)

as an equivalence with its residual H-action. The action on k is
trivial. The same calculation after base change to C=C_5 gives

    C-flat -> R Gamma_v((Spd F/N)_C,O-flat).                (4.2)

Here one uses the central-character calculation over C in BMR
Proposition 3.5.6, rather than incorrectly applying its discrete-field
base-change lemma to the valued field C-flat. Constants are the
augmentation in both calculations. All actions and the actual
surjection are inherited from the Gross--Torii framing torsor.

We will need finite resolutions for compact groups. For P_2 and P_3
an element of order five would generate Q_5(zeta_5), whose minimal
polynomial has degree four. But its reduced characteristic polynomial
has degree two or three and annihilates it. This is impossible.
Thus P_2, P_3, G and H have no five-torsion. The same holds for
G_3=P_3 semidirect Delta, where Delta=Gal(k/F_5), since |Delta|=6.

Venjakob, Sections 1.1--1.2, pp. 275--276, gives Noetherianity of
Lambda_A=Z_5[[A]] and

    pd_(Lambda_A) Z_5 = cd_5(A) = dim(A)

for these compact groups A. Successive finite free presentations
therefore give a bounded finite projective resolution of Z_5.
Tang, Theorems 3.2 and 3.14(i), preserves its exactness and
projectivity on passing to solid modules; Proposition 3.21 identifies
solid actions with modules over the completed group algebra.
The analytic derived embedding and standard resolution of
Anschuetz's *Solid group cohomology*, Sections 1--2, identify this
derived Hom with the actual condensed invariants.

Each Hom from a finite projective resolution term is a retract of a
finite sum of M(*). In particular, if a commuting arithmetic
operator acts by a scalar on H^j(K)(*)[1/5], it acts by the same
scalar on every term and the cohomology of the jth descent row.
This does not infer a condensed-sheaf identity from point values.
The applicable bounds are 9 for G_3, 13 for G, and 5 for H.

### 4.2 Actual completed theories and maps

Let B=E^square(F,(Gamma_2)_F), with its full G-action. For a nonempty
profinite parameter T, write R_T=C_cts(T,F). Its inverse Frobenius
is continuous, so R_T is perfect; F->R_T is flat and relatively
perfect. The connected pair has the Noetherian height-two witness
(k,Gamma_2). BMR Propositions 4.4.2 and 4.5.5 and Remark 4.5.6
therefore identify B(T) with the ordinary height-two theory on this
pair, and B(T) is ordinarily K(2)-local.

Evaluate the augmented N-bar diagram in (4.1), also with any
extremally disconnected profinite parameter T. It is an augmented
diagram of flat, relatively perfect k-algebras whose derived
totalization is C_cts(T,k). Apply BMR Proposition 4.3.13 to the
Noetherian reference pair (k,Gamma_2). This proposition asserts
descent of each even coefficient as well as of the spectrum.
The endpoint and cotensor formulas just cited identify its terms
with the actual connected map c:E_2^square->B and its bar terms.
Thus, for every t,

    pi_t E_2^square -> R Gamma(N,pi_t B)                   (4.3)

is an equivalence with the residual J x Q-action, and Q acts
trivially on the source. These are the specified maps, not an
inference from an unlabelled spectral equivalence. Odd coefficients
vanish. A direct justification of the tensor--totalization step
here uses the perfect Koszul quotient by (5,u'_1) of
W(k)[[u'_1]]; an arbitrary residue smash is not assumed to preserve
infinite limits. This proves the individual-coefficient enhancement
of BMR Theorem 5.2.6 needed below.

We next check the direction and compatibility of the map from E_3.
BMR Theorem 4.4.8 and Examples 4.6.2--4.6.3 supply the uncompleted
tensor maps

    E_3^square -> L_K(2)^square E_3^square
       -> E^square(L,Gamma_full) <- E_2^square,             (4.4)

with projection actions of G. Complete the reference pair L->F.
Over the perfect field F the connected--etale sequence of the full
group splits uniquely,

    Gamma_full,F = C_F direct-sum Q_F.

This is Lurie, *Elliptic Cohomology II*, Proposition 2.5.20 and
Remark 2.5.24. The splitting is invoked over the field F, not over
an arbitrary perfect ring. Pull it back to every R_T.

For completeness this pulled-back splitting is natural for
continuous G-families, not just for individual group elements.
A finite projective R_T-module embeds as a summand of R_T^r, and
R_T->product_(t in T) F is injective. Hence maps of finite flat
group schemes are detected on these fibers. The two candidate
sections after a family pullback agree on every fiber by uniqueness
over F, hence agree over R_T. Apply this at each 5^m-torsion level
and to T x G^a. It proves all action, multiplication and bar-face
compatibilities. The tautological connected formal isomorphism is
the one in the original tensor isomorphism torsor.

On oriented tagged deformations, forgetting to the connected part
has a section: lift the marked etale group Q_F, and send C_A to
C_A direct-sum Q_A. The space of *marked* etale lifts is
contractible by Lurie Corollary 2.5.10 for an E-infinity ring
complete at a finitely generated ideal. The formal identity
component and its orientation are unchanged. Compatible
refinements of the tag ideals give an equivalence of diagrams, so
inverting it in the functor category supplies coherence in A and T.
No choice of an etale basis or G-fixed frame is made. For a
nonconnective A, reduction of a tag uses its connective cover,
but the orientation remains over A itself.

Here the oriented mapping property is legitimate at R_T. At the
field witness F, the Noetherian and F-finite hypotheses of Lurie
Theorem 6.0.3 hold: F is perfect. For its relatively perfect
extensions, Lurie Theorem 3.4.1 and Remark 3.4.2 give the universal
spectral deformation, and BMR Theorem 4.3.8 gives balancedness.
The orientation classifier has the same pi_0, zero odd groups
and invertible even coefficient modules. Completeness of the
connective universal deformation therefore makes all these
modules, and hence the classifier, complete at its finitely
generated deformation ideal. The universal orientation
classifier and the deformation mapping property now apply in
complete adic rings. Thus the Noetherian oriented theorem is not
silently applied to the generally non-Noetherian ring R_T.

Corepresentability reverses arrows. The forgetful transformation
gives i:E(R_T,C_T)->E(R_T,Gamma_full,T); the split *section* gives
the needed reverse map r, with r i=id. It is r that is used after
completion in (4.4). The tensor-factor comparison is checked on
these deformation functors: both factor orientations identify the
connected formal group with the same Quillen formal group. On the
split deformation, its tag is the inverse of the connected
inclusion, exactly the tautological Gamma_2-tag. Its orientation
is unchanged. Therefore

    r b_T = c_T : E_2 -> E(R_T,C_T)                        (4.5)

naturally in T and in every G-family, retaining the tags as well
as the orientation. This is an equality of represented natural
transformations, not a conclusion from matching residue fields.
Pointwise construction followed by hypersheafification gives
the specified continuous unital G-equivariant map

    Psi:E_3^square -> B.

In fact, for the primitive coming from Z_5 the only needed
coefficient compatibility is unitality. Equation (4.5) additionally
identifies the specified E_2 tensor factor.

The canonical augmented Galois descent of BMR Proposition 4.6.9
identifies ((E_3^square)^hG_3)(*) with D, with its ordinary unit.
Restrict from G_3 to P, inflate along G->P (the source action
really does factor through P), and then use Psi. This defines

    g:D -> Dcal=((B)^hG)(*).

The last spectrum is Tot_a B(G^a). Every term is ordinarily
K(2)-local by the fixed height-two witness above. Local spectra
are closed under limits, so the *ordinary* localization property
gives g=gbar eta_D. No evaluation/localization interchange or
uncompleted half-sphere conjecture is being assumed.

### 4.3 The modification torsors, including arithmetic descent

Set Y=[Spd F/G], and pass temporarily to C=C_5. Let
F_0=W(k)[1/5]; all Honda endomorphisms are defined over k.
The bundles E_n^0=O(1/n) and their commuting P_n-actions descend
over F_0. The untilt divisor descends as well. Choose a lattice
Lambda_n in the rank-one rational local system corresponding to
det(E_n^0)(-infinity). Its G_(F_0)-action is continuous.
The valuation of its compact image in Q_5^times is zero; hence
Lambda_n is Galois stable. Choosing a fixed basis is unnecessary.

A lower line modification V_n of E_n^0 has rank n and degree zero.
If its maximal slope were positive, a destabilizing subbundle of
rank b<n would have integral degree d>=1, and
d/b>=1/b>1/n, contradicting semistability of E_n^0.
Thus V_n is slope zero.

Conversely an upper line modification of O^n is semistable of
slope 1/n precisely when its direction lies in Drinfeld space
Omega_C^(n-1). A direction in a proper rational subspace produces
a positive degree subbundle of that smaller rank. In the converse
direction intersect a destabilizing subbundle with O^n. Its degree
can drop by at most one, so semistability of O^n forces the
intersection to be a saturated degree-zero subbundle. Over a
geometric point it is W tensor O for a rational subspace W,
since H^0(O)=Q_5. The direction must lie in W_C.

These are not just pointwise classifications of stacks. Fargues--
Scholze II.2.19--20 identifies the resulting slope-zero families
with pro-etale rational local systems; III.2.4 and III.4.5 supply
their frame torsors and the frame torsors of the basic O(1/n)
families. The local kernel and upper modification constructions
commute with base change. They therefore give the following
actual common torsor. Let Z_n consist of injections O^n->E_n^0
with line cokernel at infinity whose determinant carries the
standard lattice onto Lambda_n. Put

    J_n={A in GL_n(Q_5): v_5(det A)=0}.

The stabilizer of Lambda_n in Aut(E_n^0)=D_n^times is P_n,
because its determinant is the reduced norm. On the other side
the determinant-compatible frames form a J_n-torsor. Consequently

    M_n=[P_C^(n-1)/P_n]
       =[Z_n/(P_n x J_n)]=[Omega_C^(n-1)/J_n].             (4.6)

The actions are postcomposition and inverse precomposition.
Every construction commutes with G_(F_0). The common scalar on
the untilt-direction line cancels in projectivization, so the
action on Omega is the usual arithmetic action, commuting with
J_n. Thus (4.6) identifies the actual P_n- and J_n-classifying
maps with their arithmetic actions. It retains only determinant
lattices, not an additional full Tate lattice.

### 4.4 The actual integral projective splitting

For a projective bundle pi:P(W)->Z over a v-stack over C the
maps given by powers of the Kummer class c_1(O(1)) give

    direct-sum_(j=0)^r (Z/5^m)(-j)[-2j]
                     -> R pi_*(Z/5^m).                   (4.7)

Here is a source-applicability proof at this generality. For the
projective space over C at m=1, use Li--Reinecke--Zavyalov,
arXiv:2410.08200v1, Variant 3.1.8, Construction 3.2.1 and
Proposition 3.2.2. Five is invertible on C, so its hypothesis on
the coefficient integer holds. These are the actual Kummer
classes. ALM, arXiv:2412.20968v2, Theorem 5.1.7 and Proposition
5.2.2 with Example 5.2.3 carry this smooth proper comparison to
the mod-five Frobenius-equivariant solid O-flat calculation.
The input coefficient F_5 is dualizable. The projective morphism
is p-bounded, so Proposition 4.2.7(ii) transports it to each
perfectoid test base after trivializing W.

Apply tensor-unit Hom in this solid formalism. BMR Theorem
3.2.1(iii)--(iv) identifies this with ordinary O-flat cohomology
on each test object, hence with the ordinary derived pushforward
map there. The Chern-class maps commute with Frobenius: they
come from the actual finite constant classes. Taking the fiber
of Frobenius minus one and using Artin--Schreier therefore
recovers exactly (4.7) for m=1. It is not a claim that arbitrary
solid and ordinary pushforwards agree.

The maps at all m use the compatible Kummer classes. The exact
coefficient sequences for Z/5^m, cup product and induction now
prove (4.7) for all m. Finally take derived global sections and
R lim_m. Finite direct sums commute with these limits. The
j=0 term is the original pullback and projection onto it is a
left inverse. Inverting 5 afterwards preserves that left inverse.
All these maps respect the linear descent data and the arithmetic
Galois action on the vector bundle.

### 4.5 Nonzero trace classes in the same arithmetic line

For n=2,3, the rational low-degree cohomology of P_n has dimensions
1,0,1 in degrees 1,2,3. A degree-three generator is represented
under Lie comparison by

    omega_n(X,Y,Z)=tr_red(X[Y,Z]).

Here is enough justification of the comparison and its maps.
Use sufficiently deep normal uniform subgroups and Huber--Kings--
Naumann, arXiv:0904.3863v3, Theorems 3.1.1 and 3.3.3. Trivial
coefficients satisfy its hypotheses, and the lower 5-series
makes the inclusions and block maps filtration-preserving.
Finite-index restriction/corestriction identities are formed at
each Z/5^m level, then passed through R lim, and only then
rationalized. Inner automorphisms act trivially on Lie cohomology:
Cartan's homotopy identity kills their derivative, and after a
splitting extension the algebraic group GL_n is connected.
Thus restriction identifies the compact-group cohomology with
the same Lie cohomology.

The exact script regenerates the characteristic-zero
Chevalley--Eilenberg complexes. For sl_2 its d_1 determinant is 4
and d_2=0. For sl_3 the three literal manuscript minors are
-1, 2916 and 1024, with ranks 8,20,35. The cocycle is closed,
and its restriction to (E_12,E_21,E_11-E_22) is 2. Every
three-coboundary on that sl_2 block is zero, so its class is
nonzero. Adding the central gl_1 proves the asserted low degrees
for gl_n and the inner forms.

For J_n use the reduced affine building. It is contractible with
a chamber as fundamental domain, and J_n preserves its vertex
types. The cellular resolution has only finitely many compact
stabilizer orbits and is bounded by n-1. At each finite
coefficient level continuous Shapiro identifies the face maps
with signed restrictions, not multiples by stabilizer indices.
After the derived coefficient limit and rationalization, all
these restrictions are identities on the same Lie cohomology.
Each row is thus the cellular cochain complex of a simplex
with constant coefficients. Its only cohomology is in cellular
degree zero. Restriction to every compact open subgroup is
therefore the Lie comparison isomorphism in every degree.
In particular there are classes e_(J_n) in degree three whose
restriction to a uniform compact open is nonzero.

Apply (4.7) to the P_n-presentation in (4.6). Finite constant
cohomology on C x S for a profinite S is just the locally
constant functions on S, with no higher groups: C is a geometric
point, and this assertion passes to the profinite limit of its
finite disjoint unions. Apply it in the compact P_n-bar degrees.
It follows, with the original classifying pullback as first
summand, that

    H_b^3(M_n)=H_b^3(P_n) direct-sum H_b^1(P_n)(-1).        (4.8)

The first summand has trivial arithmetic action; the second has
cyclotomic weight -1. The cyclotomic image of G_(F_0) is open,
so (4.8) has the unique invariant line Q_5 e_(P_n).

The J_n-class has a nonzero image in this same line. To prove
nonvanishing, pull back to [Omega_C^(n-1)/U] for a uniform compact
open U in J_n. Descent uses the bounded finite projective
resolution from Section 4.1 on the solid geometric complex.
CDN, arXiv:1905.11495v1, Theorem 1.1 and Section 5, gives

    H_int^j(Omega_C^(n-1))(j)=Sp_j(Z_5)^*

with trivial arithmetic action on the twisted right side, and
zero for j>n-1. Thus the untwisted jth row has scalar
chi_cyc(gamma)^(-j), also after applying the finite projective
Hom terms. The unit identifies the bottom-row computing
complex with the actual group-cochain complex: it is an
isomorphism on point-valued H^0, and all those Hom terms are
retracts of finite sums of point values.

Only d_2 from (1,1) and d_3 from (0,2) could hit (3,0).
Choose gamma with cyclotomic value of infinite order. Their
source weights are not 1 whereas the target weight is 1.
The differentials commute with gamma, so they vanish after
rationalization. No differential exits the bottom row.
The restricted e_(J_n) survives and hence is nonzero on M_n.
It is arithmetic invariant because the actual classifying
map in (4.6) is equivariant and arithmetic fixes J_n and
untwisted constant coefficients. We have proved

    e_(P_n)|M_n = kappa_n e_(J_n)|M_n,
    kappa_n in Q_5^times.                                (4.9)

This argument checks the actual classifying maps and scalar
rows; it is not an inference from matching cohomology dimensions.

### 4.6 Transport through the universal surjection

Over Y_C there is the universal exact surjection E_3->E_2 from
Section 4.1 with its two framing torsors. On
Tcal=P(i_infinity^*E_2), compose the tautological line quotient
with that surjection. If V_n denotes its lower modification,
taking the inverse image of V_2 gives the exact sequence

    0 -> ker(f) -> V_3 -> V_2 -> 0.                       (4.10)

All three bundles have slope zero. The relative correspondence
in Section 4.3 makes (4.10) an exact sequence of rational local
systems: on a trivializing cover the maps are matrices, and
the open loci of their full-rank minors give local splittings.
The determinant lattices on the two framed bundles give the
kernel lattice by tensor quotient. Adapted frames form a
torsor for the *actual* group

    Dpar={ [[a,v],[0,A]] : a in Z_5^times,
                         A in J_2, v in Q_5^(1 x 2) }.

Forgetting the filtration and taking the quotient give its
inclusion rho_3 into J_3 and projection rho_2 onto J_2.
The P_n-framing torsors on Tcal are the pullbacks of the
original two G-framing torsors on Y_C. This explicitly
identifies all four classifying maps.

For clarity, the parabolic cohomology can be checked without
assuming a compact-unipotent shortcut. Exhaust Q_5^2 by
5^(-r) Z_5^2. Restriction on its finite-coefficient degree-q
cohomology is multiplication by 5^q. For q>0 this inverse
system is pro-zero at each fixed coefficient level.
The degree-zero system is constant. The continuous cochain
restriction maps themselves are degreewise surjective (extend
from the clopen subgroup by zero), so their inverse limit is
their derived inverse limit. Thus Q_5^2 has no higher
cohomology with these finite trivial coefficients. The
augmentation is natural for the Levi action. After the
coefficient limit, the parabolic therefore has the same
cohomology as Z_5^times x J_2. Its degree three is just
H_b^3(J_2), since H_b^2(J_2)=0 and Z_5^times has rational
cohomology only in degrees zero and one.

The trace form on the full upper (1,2)-parabolic satisfies

    tr_3(X[Y,Z])=tr_2(X_2[Y_2,Z_2]).

The unipotent upper rows do not contribute to the trace,
and the 1-by-1 commutator is zero. This is a universal
identity, proved in the new Lean source and checked on
all trilinear basis triples by the exact script.
Together with the compact block comparison it gives

    rho_3^* e_(J_3)=b rho_2^* e_(J_2),  b in Q_5^times.

Pull this equality along the adapted-frame torsor of (4.10)
and use (4.9) on both sides. Since pi:Tcal->Y_C is the
projective bundle in Section 4.4, its pullback is injective.
The actual framing identifications then give

    e_(P_3)|Y_C = a e_(P_2)|Y_C,
    a=kappa_3 b/kappa_2 in Q_5^times.                     (4.11)

No P_2-action was forgotten. This equality alone does not
yet claim that either class is nonzero on Y_C.

### 4.7 Witt reflection and actual coefficient nonvanishing

Use the natural additive exact sequence

    0 -> O-flat --V^(m-1)--> W_m(O-flat)
                 -> W_(m-1)(O-flat) -> 0.

Apply it to the two constant augmentations (4.1)--(4.2).
Induction proves their Witt-level equivalences, retaining the
residual H-action. The Witt restriction maps have continuous
sections obtained by appending a zero coordinate, also after
any profinite parameter. Hence the coefficient towers have
their usual Witt objects as derived limits. Taking the
derived limit and then H-invariants gives the natural square

    H^i(H,W(k)) --------~------> H_W^i(Y)
         |                         |
         v                         v j^*
    H^i(H,W(C-flat)) ---~------> H_W^i(Y_C).               (4.12)

H acts trivially on the two constant rings. Global sections
on Spd F are acyclic for O-flat, also with profinite
parameters. The same induction gives

    R Gamma_v(Y,W(O-flat)) = R Gamma(G,W(F)).              (4.13)

The right vertical map of (4.12) is injective after inverting
5. Indeed choose the finite projective Z_5[[H]]-resolution
from Section 4.1. For a trivial coefficient M its point
complex is Hom_(Z_5)(Q_bullet,M), where

    Q_bullet=Z_5 tensor_(Z_5[[H]]) P_bullet

is bounded finite free over Z_5. Thus it is a fixed finite
matrix complex extended to M. For A_0=W(k) and A_1=W(C-flat),
A_1 is torsion-free and hence flat over the discrete valuation
ring A_0. Rational cohomology therefore extends by the field
extension A_0[1/5]->A_1[1/5]. That extension is faithfully
flat, proving the asserted injectivity. This argument is
valid for the valued topology too: finite-projective Hom
terms depend on the indicated point modules, not on an
assumption that these coefficients are profinite.

It remains important to identify the units in (4.13).
At finite level and bar degree d, both ways around the square

    C_cts(G^d,Z/5^m) -> R Gamma_v(Spd F x G^d,Z/5^m)
             |                         |
             v                         v
    C_cts(G^d,W_m(F)) -> R Gamma_v(Spd F x G^d,W_m(O-flat))

give the same locally constant Witt section. The bottom
map is the affine acyclicity equivalence. The square
commutes with every bar face, including the action face,
with the two projections G->P_n, with base change to C,
and with reduction in m. Totalization and R lim therefore
identify the image of e_(P_n)|Y with the class

    c_n^W in H^3(G,W(F))[1/5]

formed by constant-coefficient inflation and the actual unit
Z_5->W(F). Applying the finite Witt units to (4.11) and
using injectivity in (4.12) proves

    c_3^W=a c_2^W.

Apply the canonical equivariant map W(F)->pi_0 B. It gives

    c_3=a c_2 in H^3(G,pi_0 B)[1/5].                     (4.14)

This Witt-to-deformation map is applied after the Witt
limit; it is not an assumed map out of each truncated
Witt ring into the p-torsion-free deformation ring.

Finally c_2 is nonzero for the original maps. Under (4.3)
its preimage is the image of the P_2 primitive in
H^3(H,pi_0 E_2^square)[1/5], whose restriction to P_2 is
the original primitive with deformation coefficients.
Here inflation from P_2 to P_2 x Q is legitimate: Q
really acts trivially on these source coefficients.

Use the precise coefficient field in the BSSW splitting
theorem. Put A_k=pi_0 E_2 and base change the deformation
to an algebraic closure bar k, obtaining the natural
P_2-equivariant map A_k->A_(bar k). BSSW Proposition
2.5.1 and Corollary 2.5.9 supply the continuous additive
P_2-equivariant retraction A_(bar k)->W(bar k).
No W(k)-linear splitting is being inferred from an
additive splitting over bar k. The composite

    Z_5 -> A_k -> A_(bar k) -> W(bar k)

is exactly the constant inclusion. Since P_2 is
nonextended, it fixes W(bar k) pointwise. The bounded
finite-projective-complex calculation gives

    H^3(P_2,W(bar k))[1/5]
       = H_b^3(P_2) tensor_(Q_5) W(bar k)[1/5].

The primitive maps to e_(P_2) tensor 1, which is nonzero.
Therefore its image in H^3(P_2,A_k)[1/5] cannot be zero.
Restriction to P_2 detects the required H-class, so c_2
is nonzero under the actual map (4.3). Equation (4.14)
therefore proves **c_3=a c_2 != 0 for the full G-action**.

### 4.8 From that specific class to canonical localization

The ordinary fixed-point functors F_A(Z)=(Z^hA)(*) are
exact, limit-preserving and preserve upper homotopy bounds.
On an Eilenberg--Mac Lane layer HM, Section 4.1 gives

    pi_(-s) F_A(HM)=H^s(A,M),  0<=s<=dim(A).

For the Postnikov tower T_n=F_A(tau_<=n Z), its successive
fibers have homotopy in [n+1-d,n+1]. Thus both pi_q T_n
and pi_(q+1) T_n eventually stabilize. The Milnor sequence
has no residual lim^1 term. The lower tail is removed by
the upper-bound property. Explicitly pi_q F_A(Z) is
computed by the finite interval tau_[q,q+d] Z.
This proves strongly convergent ordinary descent, with a
finite filtration in each degree, even for these unbounded
even-periodic theories. Rationalization is performed on
this finite filtration, not on an infinite totalization.

Only coefficient degree t=0 survives rationally. For
t=2m!=0, the central scalar 6 fixes the deformation ring
and acts on the even line by 6^m (or its inverse under
the dual convention). Its induced action on group
cohomology is the identity by the bar homotopy for a
central element. Thus 6^m-1 annihilates the group, and
this nonzero scalar becomes invertible after inverting 5.
For the target use the individual-coefficient equivalence
(4.3), the trivial Q-action and the central scalar in
P_2. Odd coefficients are zero. The argument applies
to the source G_3 as well, since Delta fixes the scalar.

The source trace primitive extends to G_3. Arithmetic
Frobenius on the division algebra is conjugation by its
uniformizer Pi, where Pi^3=5; hence it preserves reduced
trace and the Lie class. Delta has order six, a 5-adic
unit, so averaging extends e_(P_3) uniquely to the
invariant constant-coefficient class tilde e_3 on G_3.
Let z_3 be its image under Z_5->pi_0 E_3^square.

The descent map of g is restriction, constant-source
inflation, and Psi in exactly that order. On bar cochains
its composite with the source unit is the target unit.
The finite Witt squares in Section 4.7 consequently
identify the image of z_3 with the very c_3 in (4.14),
not with an unspecified generator or a class obtained
after forgetting an action.

The rational spectral sequence has only t=0, so no
differential can kill this nonzero (3,0) map. In total
degree -3 the finite filtration has just this one
possible nonzero graded piece. Hence pi_-3 L_0 g is
nonzero in ordinary spectra. The factorization

    g=gbar eta_D

from Section 4.2 forces pi_-3 L_0 eta_D to be nonzero.
The K(0)- and K(2)-equivalence D->X and localization
naturality in Section 1 give the **exact tau_X**, proving
the theorem stated at the start. Applying Theorem 1
proves that u admits no underlying-spectrum retraction.

## 5. Exact and formal evidence

`Main.lean` proves the universal pointed-product argument behind
Theorem 1. It quantifies over all retractions, including arbitrary
second components. Its statement-fidelity document explicitly
excludes the topological and cohomological application hypotheses.

`transport/Main.lean` proves the full parabolic trace identity
for arbitrary upper rows and coefficient operations satisfying
the stated ring identities. It also proves the diagram-cancellation
step: projective injection, the two Witt unit squares and injective
Witt base change reflect the geometric relation to the nonzero
deformation-coefficient class. Its fidelity document lists exactly
which geometric and cohomological inputs remain human mathematics.
The native Lean 4.31.0 compiler and proof-hole audit both exit zero,
with no proof holes. The original accepted formal source is unchanged.

`verify.py` regenerates the Lie differentials and literal minors,
checks the trace cocycle and nonboundary test and all trilinear
basis identities of the full parabolic, the tame character,
weight indices and rational degree catalogue. Its finite sample
of unrestricted second retraction components is only a diagnostic;
the universal retraction result is proved in Lean. The staircase
bicomplex is retained as a counterexample to the failed audit
inference in Section 3, not to the manuscript.

Neither exact certificate claims a machine computation of Morava
homotopy or a formalization of this spectrum theorem.

## 6. Comparison with prior work and review boundary

### 6.1 Exact contribution and attribution

The strongest accepted mathematical result is now the unconditional
`C318RATNORETRACT`, not just `nonzero tau => no retraction`.
Its detector `C318TAU3`, the actual unit-first basis `C318H3BASES`,
and the implication `C318RATIONALOBSTRUCT` are reused from the
sealed independent reviews. No accepted certificate is rerun here.

The nonzero canonical rational map is already the main theorem of
OpenAI's *A rational obstruction to strong chromatic splitting at
height three* (September 25, 2026). The actual unit-first basis is
already part of OpenAI's filtration constructions. Reconstructing and
independently checking these inputs is verification of those authors'
assertions, not discovery of their rational detector, geometry or
filtration. The additional conclusion obtained by combining them is
failure of the **weak canonical-unit retraction at (n,p)=(3,5)** in
underlying spectra. It is a consequence of the staged manuscript
family, with that attribution, rather than a new independent proof of
an already-stated no-retraction theorem.

### 6.2 Primary-source comparison

The following comparisons concern the precise source statements, not
everything that might be deduced from an entire paper.

| Primary statement | What it establishes | Relation to the present conclusion |
|---|---|---|
| Beaudry--Schlank, `hexagon:2610.00138v1`, Theorem 1.1, pp. 1--2 | Noninjectivity on homotopy, hence no unit retraction, for p>=5 and p<=n<sqrt(2)(p-1), and for (3,3). | At p=5 the lower bound is n>=5; (3,5) is outside the theorem. Its already-known beta kernels are not a new contribution here. |
| BMR, October 7, 2026 version, Theorem A and Corollary B, p. 4 | When p-1 does not divide h-1, the map `R^(B Z_p) -> L_K(h-1) L_K(h) S`, with underlying source `R vee Sigma^-1 R`, admits a retraction. Its first component is the canonical local unit. | At h=3,p=5, 4 does not divide 2. This supplies a K(2)-local retraction, not a map `X -> L_2 S` retracting the global E(2)-local unit. |
| Staged rational-obstruction paper, introduction, `thm:main`, `cor:strong`, and the end of "Why the canonical map matters" | The nonzero degree-minus-three canonical rational map and failure even of the unspecified underlying strong wedge. It explicitly says: "The existence of a retraction of the canonical unit in weak chromatic splitting remains a separate question." | The detector is prior input. Ruling out an arbitrary unit retraction is an additional conclusion, not a restatement of strong-wedge failure. |
| Staged height-three paper (September 27, 2026), introduction, `thm:main` and "The explicit filtration"; generic-prime paper (September 25), `thm:main` | A canonical-first-unit filtration and actual common local product bases; the introductions explicitly decline to split the first unit or assert the strong wedge. | These supply the pointed basis, not the no-retraction conclusion. The prime-five case satisfies the generic bound 5>3+1. |
| Staged weak-splitting paper (September 27, 2026), introduction, `thm:height-p-kernel`, `thm:height-plus-one-kernel`, `thm:five` | Named sphere kernels at n=p for p>=5, and n=p+1 for p>=7; at p=5 its displayed map has height five. | Neither asserted range contains (3,5). An actual homotopy kernel is a different kind of evidence from the rational naturality obstruction here. |
| Staged finite-assembly paper (September 25, 2026), abstract | Failure of ordinary finite assembly in E(2)-local modules at p=3. | A different prime and a different assertion; it is not the unrestricted prime-five unit-retraction statement. |

The first two primary texts are archived as
`research/literature/beaudry-schlank-weak-csc.txt` and
`research/literature/bmr-coheight-one-primary.txt`. The latter is the
obtained October 7 version, not the August version cited in the staged
papers. All staged locators above are in their dated
`research/openai_manuscript/` directories. The ordinary sphere in the
rational paper and its completed version have the same K(3)-local
sphere; this does not identify their rationalizations before
K(3)-localization. The source of u here remains `L_2 S_5-complete`.

### 6.3 The reviewed technical bridge and its significance

The nontrivial verified input is transport of the **actual** primitive
through the full P_3 x P_2 action, completed coefficient maps and Witt
unit squares, followed by ordinary canonical localization
(Sections 4.1--4.8). Cohomological ranks, an unpointed wedge or
forgetting P_2 would not suffice. The second essential input is that
the K(2)-basis starts with the actual unit.

The extra implication is short but universal: BSSW's rational degree
catalogue gives

    pi_-3 L_0(Sigma^-1 R) = pi_-2 L_0 R = 0.

Consequently every putative r induces an isomorphism on the sole
degree-minus-three line after rationalized K(2)-localization, even
with an arbitrary second component. Naturality and
`pi_-3 L_0 L_2 S_5-complete=0` then contradict the detected class.
This is the reviewed argument in Section 2; no module-linearity or
filtration projection is being smuggled into it. The Lean certificates
check the universal algebraic bridge and transport algebra, not the
spectrum theorem.

If new, the corollary is qualitatively significant: it gives weak
splitting failure at height three and prime five, outside the
Beaudry--Schlank n>=p range, despite the coheight-one retraction and
inside the generic-prime filtration range. A local splitting need not
glue to the global chromatic-fracture retraction. This is stronger
than rejecting a specified sphere wedge or a particular attachment
projection. It does **not** exhibit a homotopy-group kernel for u;
in particular, the rational degree-minus-three detector is not a
nonzero class of the source of u in that degree.

The deep geometric calculations remain attributed to the staged
papers and their literature inputs. Their independent reconstruction
alone does not establish a new publishable theorem or a new method.
The candidate research contribution is the additional weak-unit
consequence of their combination.

### 6.4 Additional prior-art search and publication verdict

A bounded primary-source search through November 5, 2026 did not
verify an additional theorem covering this precise sphere map.
Its closest further candidate was Devinatz, *A counterexample to a
BP-analogue of the chromatic splitting conjecture*, Proc. AMS 126
(1998), 907--911, [doi:10.1090/S0002-9939-98-04104-5](https://doi.org/10.1090/S0002-9939-98-04104-5).
The inspected publisher-registered abstract states nonsplitting of
`L_(n-1)(BP_p) -> L_(n-1)L_K(n) BP` for n>=2, not the sphere map.
Its two-cell refinement includes (3,5), but the input is still BP.
No identification with the sphere unit smashed with BP, or theorem
transferring this nonsplitting to the finite sphere, was verified.
The full article was not obtained; no assertion about an uninspected
proposition in it is made.

Two other inspected primary candidates do not provide the required
conclusion: Morava,
[arXiv:1406.3286v2](https://arxiv.org/abs/1406.3286v2),
Proposition p. 3 and Corollary p. 4, expressly derives consequences
*assuming* splitting; Ray,
[arXiv:2507.00309v2](https://arxiv.org/abs/2507.00309v2),
Proposition 3.8, p. 24, excludes a specified geometric tower at
heights h=phi(p^k), k>=2, rather than an underlying-spectrum
retraction. BSSW,
[arXiv:2402.00960v2](https://arxiv.org/abs/2402.00960v2),
Theorems A--B and Proposition 2.5.1, gives rational homotopy and
coefficient splittings, not this global nonsplitting. These are
source exclusions, not evidence that no other theorem exists.

The search did not obtain the full text of Hovey's 1995 foundational
account ([doi:10.1090/conm/181/02036](https://doi.org/10.1090/conm/181/02036)).
It is not used here as an inspected theorem or as affirmative novelty
evidence. Neither that access limitation nor a search miss refutes
the accepted mathematics.

**Engineer assessment:** `C318CONTRIB5` is supported as the precise
additional-conclusion and attribution comparison above.
`C318PUB5` remains **inconclusive** at the configured
`verified_new` / `publishable` gate. The source-by-source distinctions
establish why the named results do not already state the new
conclusion; they do not establish field-wide priority. Missing are an
independently accepted priority assessment of this exact sphere
corollary, including the BP/local/strong-versus-weak overlap, and a
publication-significance judgement crediting a new consequence of the
staged family rather than counting its reverified detector as new.
The substantive significance case is Section 6.3, not the negative
search result.

The Host-invoked Reviewer should decide those publication questions
and check the new comparison locators. The sealed detector,
filtration, spectral review and formal certificates are not reopened.
The accepted mathematical theorem stands; publication-level campaign
completion is not asserted.
