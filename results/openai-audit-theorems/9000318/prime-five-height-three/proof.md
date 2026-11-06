# The prime-five, height-three filtration

The claim under investigation is C318H3P5. Write S for the derived
5-complete sphere, D=L_K(3)S, and X=L_2D. The required ordered cofibers are

    L_2S, Sigma^-1 L_2S, Sigma^-3 L_1S, Sigma^-4 L_1S,
    Sigma^-5 HQ_5, Sigma^-6 HQ_5, Sigma^-8 HQ_5, Sigma^-9 HQ_5.

The first map must be L_2 of the actual unit S -> D. A calculation of
dimensions, an independently chosen local basis, or a failure of a
sufficient construction is not a proof or a refutation of this claim.

## 1. Inputs already settled, and source scope

The fifth independent review, recorded at
`roles/reviewer/progress.json`, accepts C318CO2: at (p,n,t)=(5,3,1)
the original ordinary connected-marking cup map has the specified basis
1, xi_1, xi_2, xi_1 xi_2 in degrees 0,1,3,4, and xi_3 acts as zero.
Its proof, source applications, exact diagnostics, and compiler
certificates are unchanged and are not replayed here.

The earlier finiteness review also accepts C318FIN32 and C318FINGEO.
These give finite ordinary cohomology at finite (3,2) frame levels,
the underlying residue/transfer support comparison, and the actual
one-variable translation calculation. They do not, on their own,
identify the specified coheight-one cup action or prove a spectral
equivalence. In particular, the height-one transfer splitting is not
silently reused at test height two.

New primary sources obtained for the spectral passage are:

* Mathew, arXiv:1404.2156v2, Proposition 10.10: Morava E is descendable
  inside K(n)-local spectra.
* Mathew, arXiv:1701.01528v1, Proposition 2.12 and
  Propositions 2.20, 2.26: the Amitsur limit for an A-nilpotent object
  is universal for exact functors and its tower is quickly convergent.
* Barthel--Schlank--Stapleton--Weinstein, arXiv:2402.00960v2,
  Theorem A: the rational homotopy algebra is exterior on degrees
  -1,-3,-5 at height three. This is a rational result, not the
  integral filtration or the simultaneous local bases.
* Hovey--Strickland, arXiv:math/0301232v1, Example 0.1(d),
  Lemma 2.2, and Corollary 2.3: Landweber exactness and flat
  base-changed cooperation Hopf algebroids.
* Lurie, Classification of Formal Groups, Lecture 14 (27 April 2010),
  Theorem 1: the full isomorphism ring between exact positive-height
  formal groups is an injective union of finite etale algebras.
* Devinatz--Hopkins, doi:10.1016/S0040-9383(03)00029-6:
  the structured completed Morava cooperations and descent.
* Serre, Homologie singuliere des espaces fibres (1951), Chapter V,
  Section 5, Proposition 4, together with stabilization and the
  finiteness in Chapter V, Section 3, Proposition 3:
  the 5-local sphere has no positive homotopy below degree seven.
* Stacks, Tags 0912 and 00OC: inverse-limit flatness and finite
  global dimension of regular local rings, respectively.
* Barthel--Beaudry, arXiv:1901.09004v2, equation (2.19) and
  equations (4.2), (4.4): chromatic fracture and the height-one
  sphere unit used in assembly.

The obtained primary texts are in `research/literature/`. New source
applicability remains for independent review. The cited unversioned
Barthel--Mann--Ray--Schlank--Senger--Weinstein--Zhou coheight-one PDF
could not be obtained with verified TLS; it is not an assumed theorem.
The bounded literature lookup did not locate an independent primary
proof of this exact filtration. That negative lookup is not a novelty
certificate. Both staged OpenAI manuscripts already assert the desired
filtration, so a verification here must not be presented as a new
filtration theorem merely because it treats p=5 separately.

## 2. Exact tests of completed descent

Take k=F_(5^6), Gamma=Gal(k/F_5), and G=P_3 semidirect Gamma.
All Amitsur tensor products in this paragraph are K(3)-localized:

    A^q = L_K(3)(E_3(k) smash ... smash E_3(k)),  q+1 factors.

The unit object of this category is D. Mathew's Proposition 10.10
applies to E_3(k). If desired, first apply it over F_125 and then use
the finite unramified extension to k. The relative finite Galois
comparison has order two, a 5-adic unit.

Compose the exact inclusion of K(3)-local spectra into spectra with
the ordinary exact functor kappa_t smash -, for t=1,2. Proposition
2.12 of arXiv:1701.01528v1 applies directly to this composite and
X=D. It gives

    kappa_t smash D = Tot(kappa_t smash A^bullet).

Propositions 2.20 and 2.26 give quick convergence. No commutation of
ordinary smash with unrestricted inverse limits is used. Nor is
K(3)-localized tensor replaced by ordinary tensor inside A^q.
Ordinary residue smash is applied only after those terms are formed.

## 3. A special-range construction of the common sphere classes

Here is an alternative to redoing the manuscript's all-rank
K-theoretic sphere-lifting construction. The alternative preserves
the already specified integral classes alpha^P_(3,1), alpha^P_(3,2).
The group P_3 has 5-cohomological dimension nine and has no element
of order five: a primitive fifth root of unity would generate a
degree-four field in a degree-three division algebra. Gamma has order
six, so adjoining it does not increase the 5-cohomological dimension.

For connective, finite-type, complete coefficients, continuous
Postnikov cochains have spectral sequence

    H^s(G,pi_r E) => pi_(r-s) C^*(G;E).

The horizontal bound s<=9 and finite cohomology at finite coefficient
levels justify the Postnikov limit and its separated finite
filtration in any fixed total degree. This use of finite coefficients
is important; no finite cohomological dimension of arbitrary abstract
modules is asserted. Devinatz--Hopkins Lemma 4.21 supplies the
finite-coefficient and profinite-limit facts: each inverse system
of finite cohomology groups is Mittag--Leffler. For each fixed
total degree the horizontal bound leaves finitely many Postnikov
rows, so this coefficient limit introduces no extra sphere row.

In the sphere sequence, pi_r S=0 for 0<r<7. The term
H^3(G,Z_5) in bidegree (3,0) has no incoming differential, by
connectivity. An outgoing differential d_l has target
(3+l,l-1). For 2<=l<=7 the coefficient group is zero; for l>=8
the cohomological degree is at least eleven, beyond nine. Also no
positive sphere row contributes to total degree -3, since it would
require s=r+3>=10. Thus

    pi_-3 C^*(G;S) -> H^3(G,Z_5)

is an isomorphism. The Gamma-invariant specified class alpha^P_(3,2)
therefore has an actual sphere-cochain lift. Restriction across the
order-six extension identifies its integral class with the specified
one on P_3, not with a replacement generator.

For degree one use the actual divided reduced-norm logarithm
ell:P_3 -> Z_5, extended over Gamma. Continuous sphere cochains of
Z_5 have pi_-1=H^1(Z_5,Z_5)=Z_5, since its 5-cohomological
dimension is one. Pull back the class whose Hurewicz image is the
identity homomorphism, with the fixed determinant normalization.
This gives the specified alpha^P_(3,1). This separate construction
avoids incorrectly ruling out the possible differential from
bidegree (1,0) to (9,7) merely by a dimension bound.

The unit S -> E_3 induces the map from these continuous sphere
cochains to the structured completed descent diagram. Mapping the
two classes through its totalization gives actual classes

    y_1 in pi_-1 D,   y_2 in pi_-3 D.

Take y_12=y_1 y_2 using multiplication in D. These are one family of
maps before either residue test; the empty product is exactly the
unit S -> D.

## 4. The ordinary residue, with its actual cofaces

Put R_3=W(k)[[x_1,x_2]], with its maximal ideal topology. For a
profinite set Q let N_Q=C_cts(Q,R_3). Reduction modulo any power
of the maximal ideal is onto the locally constant function module:
lift the finitely many values on a finite clopen partition. The
kernel is the indicated ideal times N_Q. To check this equality,
divide continuous power series coefficientwise among the finite
monomial generators of that ideal. The same argument applies to
(5,x_1,...,x_(t-1)).

Thus N_Q is the inverse limit of the flat modules
C_lc(Q,R_3/m^a), whose transition maps are surjective. Stacks,
Lemma 15.28.4, Tag 0912, proves that N_Q is flat and that tensoring
it with a finite R_3-module commutes with this inverse limit.
In particular quotienting by the height ideal gives

    C_cts(Q,A_t),  A_t=k[[x_t,...,x_2]].

Only this pre-localization completion is used.

Let M_Q be the completed E_3-function module at Q. Associativity of
ordinary smash and relative tensor gives

    E_t smash M_Q = (E_t smash E_3) tensor_(E_3) M_Q.

Its module Kunneth spectral sequence collapses by the flatness just
proved. The regular coefficient ring has finite graded global
dimension, so this is a convergent calculation, not an unbounded
Tor convergence assertion. Landweber exact base change computes the
ordinary factor E_t smash E_3 by the two-sided formal-group
isomorphism Hopf algebroid. In particular that factor is flat on
the test side as well: apply Hovey--Strickland Lemma 2.2 to the
source Landweber exact algebra and then base change to the test.
The test regular sequence (5,u_1,...,u_(t-1)) stays regular, even
after tensoring the source function module. Its iterated cofibers
therefore have only even homotopy.

Write kappa_t=E_t/(5,u_1,...,u_(t-1)). Its coefficient ring is
k[v^+-1], |v|=2, and its Bousfield class is K(t). Each killed
scalar acts nullhomotopically as an E_t-module map. Indeed,
pi_1(E_t/x)=0 for a displayed nonzerodivisor x; applying
[-,E_t/x] to its cofiber triangle makes restriction
[E_t/x,E_t/x] -> pi_0(E_t/x) injective, and x times the
identity restricts to zero. Tensor this nullhomotopy with the
other cofibers. Ordinary smash makes it natural throughout the
cosimplicial diagram and its finite partial totalizations.
Consequently their homotopy and tower filtration are genuinely
modules over kappa_(t,*), not merely vector spaces on an E_2-page.

The invariant height ideals on the two sides of an isomorphism
agree. Modulo the preceding height ideal their next generators
differ by a unit. The residue therefore sets
5=x_1=...=x_(t-1)=0 and inverts x_t. The remaining isomorphism
is a full Honda height-t marking of the source deformation.
Its linear coefficient c satisfies

    x_t c^(5^t-1)=1.

This follows by comparing the leading coefficients in
[5]_source alpha=alpha [5]_Honda, with alpha(X)=cX+....
Conversely this marking and the fixed test period determine the
source period v_3=cv and the corresponding graded strict
isomorphism. The source period is therefore already recorded;
there is no extra multiplicative frame variable. Goerss,
arXiv:0802.0996v1, Definition 2.40, Remark 2.41(3), and
Corollary 2.45 explicitly concern all isomorphisms of the
underlying formal groups, not just additive polynomials.
Lurie's Lecture 14, Theorem 1, gives the union of finite etale
algebras of full markings. No arbitrary finite-bud moduli are
substituted.

There are initially two copies of k. With the test copy fixed,

    k tensor_(F_5) k = product_(sigma in Gamma) k.

Consequently the mixed cooperation residue is

    product_sigma (kappa_(t,*) tensor_k B_(3,t)^[sigma]),

where B_(3,t)^[sigma] is the original connected-marking algebra
with source constants embedded by sigma. No etale Tate basis
has been chosen. For the identity embedding it is exactly the
algebra used in C318CO2 or, at t=2, in Section 5 below.

Here is the topology on the tensor product. A finite marking
algebra J over B_t=A_t[1/x_t] is a projective B_t-module;
choose J=eB_t^a. Then

    J tensor_(A_t) C_cts(Q,A_t)
       = e(C_cts(Q,A_t)[1/x_t])^a.

It consists of continuous functions into one finite A_t-lattice
in J after multiplying by one power of x_t. Such a lattice can
be J intersect A_t^a: it is finite, closed, and spans after
localization. Taking the algebraic union of J requires one
finite J for each element of the tensor product. This is
precisely the common-finite-stage, bounded-pole convention on
each compact parameter source. It is not the completion of the
localized function module or of the marking union.

Devinatz--Hopkins give the structured completed cooperations,
their unit and multiplication, and all cosimplicial maps. In their
coordinates evaluation uses inverses in the group action. Transport
to the standard inhomogeneous convention by

    (T_q c)(g_1,...,g_q)
      = g_1^-1 c(g_1 g_2^-1,...,g_(q-1) g_q^-1,g_q).

Its inverse evaluates at
(a_1...a_q,a_2...a_q,...,a_q) and acts on the value by
a_1...a_q. These inverse substitutions intertwine the cofaces
and codegeneracies by the action law. The first coface in the
new coordinates is the semilinear action, not an untwisted
nerve face. Inserting a unit and multiplication are preserved.
The unramified extension from F_125 to k preserves this
description by the finite Galois coefficient identity.

Under the ordinary cooperation calculation, this first face
composes the tautological marking with the actual deformation
change. Every fixed coefficient uses finitely many coefficients
of these isomorphisms. A compact group parameter has a common
finite marking stage and pole bound: the action preserves the
height ideal and carries x_t to a unit times x_t modulo it.
All remaining faces and degeneracies are parameter pullbacks.
The bar cup formula, hence the actual constant cup action, uses
these very maps and multiplication. The unit is 1.

Finally Gamma permutes the source-embedding factors transitively.
Their product is the coinduced coefficient for P_3 contained in G.
Shapiro, or the finite coset bar contraction, identifies its
G-cochains with the P_3-cochains of the identity factor. Evaluation
is performed after retaining the full product; the identity
factor alone is not Gamma-stable. The test period v stays fixed,
so no coefficient character is introduced on kappa_(t,r).
We have thus obtained, naturally for the unit and constant cup maps,

    N^* pi_r(kappa_t smash A^bullet)
       ~= kappa_(t,r) tensor_k C^*_cts(P_3;B_(3,t)).

The right side is zero for odd r. This proves C318H3RESIDUE.

## 5. The coheight-one input for the same divided norm class

This step uses the independently accepted finite-frame (3,2)
calculation, not the unproved assertion that a height-one Hopf
projection splits an additive height-two torsor.

Put G_1=GL_1(Z_5), P_2=O_(D_2)^times, and
Z=N_2 minus {0}, where N_2=Ext^1(O(2),O).
The already reviewed construction in `finiteness.md`,
Sections 2 and 4, supplies the following objects and underlying maps:

    Dcal = colim_(U,r) C^*(P_3,E_U(N_r))^*,
    Dcal tensor R ~= RΓ_c(Z,Acal) tensor <eta>[10],
    RΓ(K x V,RΓ(T_h,Dcal)) ~= C^*(P_3,B_(K,V)^(h))^*.

Here U=K x V, R is the same faithful almost scalar extension as
in the accepted comparisons, N_r are finite regular translation
representations, and T_h is a deep translation subgroup.
The last equality is trace descent. These statements, ordinary
finite-frame finiteness, and the smooth finite full-frame rows
are the accepted C318FIN32 input. They are stronger than a
dimension count but do not yet identify a specified cup action.
The dual complex still retains its derived translation action.

The action enhancement needed here is obtained on the same
finite diagrams. For a locally constant constant cochain c,
the bar cup operation is multiplication by c on its finite
clopen pieces followed by the actual group action on the
coefficient. Evaluation and residue identify its transpose
with pullback along the middle-bundle torsor. Finite trace and
pullback satisfy both adjunctions and the projection formula.
Thus transpose transfer, transpose trace, and the supported
comparison commute with this operation. This is the finite
formula proved in `support-comparison.md`, Sections 2--4,
before specializing the number of coordinates; here there
is one residue coordinate and the total shift is 10 rather
than 11. The formula there is valid for every integer shift
D, so its graded dual and shift signs also apply to D=10.
There is exactly one volume line. No new geometric
equivalence is inferred solely from cohomology dimensions.

For clarity, trace descent can also be checked without a
dimension argument. At a finite frame quotient, a finite
etale torsor is a projective regular deck module after
faithfully flat trivialization; the assertion descends.
The bounded finite projective P_3-resolution preserves its
finite sums and retracts. Its dual terms are deck-acyclic.
For translations, Hom from a finite rational comodule is
the dual of the exact associated-bundle functor, so the
dual terms are injective rational translation comodules.
Every comodule vector belongs to a finite subcomodule;
finite tests therefore suffice for this injectivity
assertion. Translation invariants recover the dual root
coefficient. Corestriction in a frame is the transpose
of coefficient pullback, not its trace in the wrong
direction. This verifies the actual maps in the display.

An open scalar subgroup acts identically on the underlying
support cohomology; this is also retained in the accepted
(3,2) calculation. A scalar a in 1+5 Z_5 conjugates
translations by [a] or [a^-1]. The formal identity

    [a-1](z)=F([a](z),[-1](z))

then makes one T_h act trivially on every cohomology row.
It does not trivialize its action on the complex. Choose h
deep and divisible enough that stationary powers fix k.
At this height its distribution algebra is Lambda=k[[D]].
The two-term Koszul resolution gives

    RHom_Lambda(k,Dcal)
       ~= (k tensor^L_Lambda Dcal) tensor E[-1],
    E=(D/D^2)^*.

The augmentation Lambda -> k yields a natural map

    Dcal tensor E[-1] -> RΓ(T_h,Dcal).

This is the canonical top-edge insertion. Tensor-Hom
duality for the perfect Lambda-module k makes it natural
for every augmented change of D, not just for linear
coordinate changes. It is also linear for the actual
constant-cochain action. On a cohomology row killed by
D, it inserts that row into translation degree one.
One must not replace the derived action by a trivial
one before constructing this map. More explicitly,
RHom_Lambda(k,Lambda) has its sole cohomology E in
degree one. Canonical truncation identifies it with
k tensor E[-1], equivariantly for augmented changes
of Lambda. Compose Lambda tensor E[-1] with its
augmentation quotient, tensor derivatively with Dcal,
and use perfect tensor-Hom duality. This constructs
the insertion without selecting a strict equivariant
Koszul generator; the resulting naturality is derived.

There are only two scalar weight tests. For the ambient
support row the orientation character is a^-2, the single
volume is a, and translation Ext degree b has character
a^b, with b=0 or 1. Their product is a^(-1+b).
Here the kernel-frame action on a translation tuple
is tau -> tau a^-1. Thus D/D^2 has character a^-1
on the tame scalar group, and its dual E has character
a, not a^-1. Any Frobenius twist agrees with this on
F_5^times. The retained volume is the dual of the
one-dimensional translation Lie line and also has
character a. The two ambient orientation factors
are those of the already reviewed N_2 support frame;
their character is a^-2. These are three separate
factors, not a second copy of the volume.
The degree-zero translation column is killed by a tame
scalar; the top column is trivial. On the removed origin
the two exponents are 1+b, namely 1 and 2, both nontrivial
on F_5^times. Take a=2, whose order is four in F_5^times.
The corresponding scalar-minus-identity maps are units
in characteristic five. The central homogeneous-bar
prism therefore contracts the unwanted columns in every
G_1-cohomological degree. Exactness of the tame projection
also proves this directly. All orientation characters
refer to the full frame action; no central reduced-norm
subgroup of insufficient index is being substituted.

The bounded cohomology filtration of Dcal, the two
translation degrees, and cd_5(G_1)=1 now show that the
top-edge insertion becomes an equivalence after RΓ(G_1,-).
After extension to ambient support, the remaining
geometric degree is four and its G_1 coefficient line
is trivial. Thus, for

    C_G=RΓ(G_1,RΓ(T_h,Dcal)),

its underlying cohomology, after faithful scalar extension,
is H^a(G_1,k) in degree a+4+1-10=a-5.

Take the inverse limit in K with corestriction BEFORE
extending scalars. Each group in the bounded spectral
sequence is finite. Duality for the orientable group P_2
turns this inverse limit into the restriction colimit in
degree 4-c. Positive-degree restriction dies on a small
open subgroup, and degree zero retains the coefficient.
Mittag--Leffler removes the inverse-limit defect. Hence

    Hom_k(H^i(P_3,B_conn,G_1^(h)),k)
       = H^(-i-4)(C_G).

Together with the degree computation, this gives the
reindexing a=1-i. Power transport at this ONE finite h
is an isomorphism from the root coefficient to the
original coefficient, fixes k, 1, and F_5 constant
cochains, and preserves compact parameter bounds.
This is not an assertion that root inclusion is transfer,
nor that the ordinary-to-perfect inclusion is an
isomorphism. We conclude that

    Hom_k(H^i(P_3,B_conn,G_1),k) tensor R
       ~= H^(1-i)(G_1,k) tensor R.

It remains to identify the action. Fix the connected
height-two quotient and its rational slope-zero frame.
The same rank-three modification used in the accepted
specified-action comparison has an integral rank-one
kernel and this fixed rational rank-two quotient. Its
splitting-frame group is

    { [a v; 0 I_2] : a in GL_1(Z_5), v in Q_5^2 }.

Its projection to G_1 is the original kernel-frame
torsor and has the displayed block-diagonal section.
Positive continuous F_5-cohomology of Q_5^2 is zero:
exhaust it by open compact lattices, note that
restriction in positive lattice cohomology is zero,
and use surjective cochain restrictions and the
Mittag--Leffler sequence. The same proof works with
each compact external nerve parameter. Restriction
along the block section is therefore inverse to
inflation. Pullback along the actual modified torsor
identifies alpha^P_(3,1) with the upper-left rank-one
restriction of the fixed divided determinant. This
is the original divided logarithm on Z_5^times;
it generates H^1(G_1,k). The modification is used
only on Z, not on the removed origin. Its now-identified
BG_1 class is preserved by the G_1-equivariant ambient
map and by connected corestriction.

Finally H^*(G_1,k)=Lambda_k(e), |e|=1, by its actual
two-term procyclic resolution and exact tame invariants.
Its top pairing identifies its reindexed dual with its
regular module. The displayed action comparison
therefore makes the primal coefficient cohomology a
free rank-one module over THIS exterior action. Its
degree-zero line is one-dimensional. The actual unit
is nonzero: the marking covers are nonempty, their
finite etale algebras are nonzero, and the base maps
injectively into the algebraic full-marking union.
Consequently 1 is a nonzero invariant, and there are
no negative-degree cochain boundaries. Thus 1 spans
that line. The cup
map e -> xi_1 cup 1 is an isomorphism after faithful
extension and hence before it. This proves C318H3CO1
for the same class used in Section 3.

All passages above are performed on fixed finite
diagrams before taking algebraic unions. A compact
cochain source admits a common clopen refinement,
frame/root level, and pole bound. In the rational
upper block a bound is required only on that compact
source, not on the entire noncompact Q_5^2. The
inverse limit of finite cohomology is taken before
almost scalar extension. No unrestricted-limit or
ordinary/perfected-coefficient interchange is used.

## 6. The actual simultaneous local bases

Sections 2 and 4 give the strongly convergent residue sequence

    E_2^(s,r)=kappa_(t,r) tensor H^s(P_3,B_(3,t))
       => pi_(r-s)(kappa_t smash D).

At t=1 the accepted C318CO2 input has the specified basis in
filtrations 0,1,3,4; at t=2 Section 5 has the specified basis in
filtrations 0,1. These statements include the actual coefficient
unit and cup action.

For b=d(I), the sphere representative of y_I has filtration at
least b. The (b-1)-partial totalization of its connective
sphere-cochain source is (1-b)-connective and so has zero pi_-b.
Its leading class is its integral Hurewicz image. Transport the
lift into the fiber of this partial totalization along the
structured constant-section map, then apply ordinary residue
smash, which preserves this finite limit and fiber. Section 4
identifies the resulting leading term with precisely xi_I cup 1.
Connectivity is used only in the source tower, never in the
periodic residue tower.

These are actual source-totalization classes, so their lifts
continue coherently through every later partial totalization.
For each scalar in kappa_(t,*), a lift in pi_*E_t acts naturally
on the residue tower and on this compatible representative.
Thus every E_2 element has a full-tower representative.
All outgoing differentials vanish. Inductively every later
page is still spanned by these representatives, so there are
no incoming losses either. The sequence degenerates.

Quick convergence and the bounded columns give a finite,
separated filtration of the abutment by kappa_(t,*)-modules.
Filter the source free module by the degrees d(I). The map
defined by the ACTUAL y_I induces an isomorphism on every
associated-graded piece. Finite filtered comparison proves
that this map itself is an isomorphism; periodicity does
not invalidate it when two total degrees become equal
after multiplying by a power of v. The general algebraic
comparison, rather than an enumeration of graded ranks,
is the statement formalized separately in Main.lean.

Consequently ordinary residue smash of the following
specified maps is an equivalence:

    (1,y_1): S vee Sigma^-1 S -> D                 for t=2,
    (1,y_1,y_2,y_1 y_2):
      S vee Sigma^-1 S vee Sigma^-3 S vee Sigma^-4 S -> D
                                                     for t=1.

Kappa_t has Bousfield class K(t), so these are the
required K(2) and K(1) equivalences. The cofiber of
S_(5) -> S is rational and has zero smash with
kappa_t. Thus ordinary residue smash of S is kappa_t
and agrees with the relative S-module test on these
S-module maps. The first component is the same
canonical unit in both maps. This proves C318H3BASES.

## 7. Rational independence and the eight stages

BSSW Theorem A gives the rational degrees listed in Section 1.
It does not identify rational primitives with y_1 or y_2,
and no such identification is needed here.

Write R_1=L_K(1)S. The rationalized unit of R_1 is nonzero:
the height-one continuous descent sequence has cd_5=1,
even coefficients, and its sole total-degree-zero entry
is H^0(Z_5^times,pi_0 KU_5-complete)=Z_5; the unit
maps to 1. Hence pi_0R_1=Z_5 with that unit.
The K(1) basis from Section 6 identifies the images
of 1,y_1,y_2,y_1y_2 with the units of four DISTINCT
shifted R_1 summands. A rational relation among
these elements in D would remain one after mapping
to L_0L_K(1)D, where it is impossible. They are
therefore rationally independent. This argument
concerns the same actual maps, not the BSSW choices.

Set Q_0=X and form the cofiber

    B_1=L_2S vee Sigma^-1 L_2S -> Q_0 -> Q_1

using 1,y_1. It is a K(2)-equivalence, so Q_1 is
E(1)-local by chromatic fracture. The composites
of y_2,y_1y_2 into Q_1 extend by localization
adjunction to

    B_2=Sigma^-3 L_1S vee Sigma^-4 L_1S -> Q_1 -> Q_2.

At K(1), the first cofiber removed exactly the
first two components of the SAME four-component
basis. The last two components therefore make
B_2 -> Q_1 a K(1)-equivalence. Thus Q_2 is rational.
This is quotienting by specified direct summands;
no unsupported nullhomotopies of the attachments
have been chosen.

Rationalizing B_1 -> X is injective on homotopy,
by the independence just proved. Rationalizing
B_2 -> Q_1 is also injective: a relation in the
quotient would be a relation among the four
original vectors. There are no suspended kernel
terms in either cofiber. Subtraction from the
BSSW dimensions leaves exactly the degrees
-5,-6,-8,-9. Rational S-modules are HQ_5-modules,
since L_0S=HQ_5, so a choice of basis gives

    B_3=Sigma^-5 HQ_5 vee Sigma^-6 HQ_5
          vee Sigma^-8 HQ_5 vee Sigma^-9 HQ_5 ~= Q_2.

Put Q_3=0 and G_j=fib(X -> Q_j). The stable
pullback squares give cofiber sequences

    G_(j-1) -> G_j -> B_j,   j=1,2,3,

with G_0=0 and G_3=X. Refine each block by the
partial sums of its displayed ordered wedge
summands and pull those sums back. Exactness of
pullback gives the eight ordered individual
cofibers. Since Q_0=X, the first pullback is
the first summand L_2S of B_1 and its map to X
is exactly L_2 of the canonical unit. This
proves the asserted filtration and C318H3ASSEMBLY.

## 8. Certification scope and comparison

The mathematical argument is a verification of the stated
p=5 instance, conditional on the explicitly cited primary
theorems and the unchanged independently certified
coefficient inputs. Its new ordinary coheight-one action
enhancement and spectrum-level applications require
independent review. Engineer support is not that review.

The deterministic script checks finite algebra underlying
the coface coordinate change, the one-variable translation
and weight calculation, the sphere-lifting degree window,
finite filtered comparison diagnostics, and the exact ordered
cofiber degrees. Such finite calculations do NOT construct
Morava spectra, compute their infinite cohomology, or prove
the cited geometric equivalences. The compiler checks the
separately stated algebraic theorem only. Neither machine
calculation is called a formal verification of spectra.

The retained Lean 4.31.0 compiler run exited zero and
its separate proof-hole audit exited zero with
`proof_holes=[]`. Its source and statement-fidelity
record are current. The inspected Jacobian operation
`prime_field.matrix.rank.compute` returned rank four
for multiplication by D on F_5[D]/D^5, with adapter
exit zero and no timeout or structured error.

The exact script checks 7,464 individual cofaces, 985
codegeneracies and 985 cup transports in a nonabelian
S_3 model. It includes a genuine semilinear action on
F_25^3. It tests all 500 augmented automorphisms of
F_5[D]/D^5: 2,500 Koszul chain identities and 2,500
top-insertion chain homotopies. Strict insertion
naturality fails in 1,872 basis cases and the displayed
homotopy repairs each one. This is a negative control
for an invalid shortcut, not a claim that the
manuscript's derived insertion is false.

From the campaign root, replay the new finite evidence
without changing its certificate using

    python3 research/prime-five-height-three/verify.py --check

`exact_certificate.json` labels the finite and formal
scopes separately and enumerates the geometric and
spectral applications not checked by those machines.
The completed fifth-round coefficient checks are not
repeated. The new primary-source applicability and
formal statement fidelity remain independent Reviewer
obligations, not self-filed supporting attributions.

The improvement over round five is the use of its specified
cup theorem to obtain actual compatible local maps and the
filtration, rather than another coefficient dimension
calculation. The special degree-three lifting argument uses
only the first 5-primary stable-stem gap and cd_5(P_3)=9.
It avoids redoing the all-rank stable K-theory construction.
It is a different proof of the required lift, not a proof
that the manuscript's construction is false.

Both staged manuscripts already assert this eight-stage
filtration. The companion also asserts more detailed
attachment identifications, which are not claimed here.
BSSW is used only for the established rational calculation.
No independent primary theorem giving the whole requested
filtration was located in the bounded literature lookup,
and the unversioned external coheight-one paper was
unavailable with verified TLS. These facts do not certify
publication-level novelty. No false literal manuscript
assertion or counterexample is claimed by this report.
