# The degree-five comparison and two-layer generation

Put D=L_K(3)S, X=L_2D, A_i=L_iS, Q=HQ_5 and R_i=L_K(i)S,
where S is the derived 5-complete sphere. Retain the actual map

    B_1=A_2 vee Sigma^-1 A_2 --(unit,zeta)--> X,
    Y=cofib(B_1 -> X).

**Theorem.** The actual comparison L_0Y -> L_0L_K(1)Y is zero
in degree -5. Thus the scalar c in Section 3 of `../proof.md`
is zero. For the already fixed B_2 -> Y -> V triangle there is
an equivalence under B_2

    Y = B_2 vee V,
    B_2=Sigma^-3 A_1 vee Sigma^-4 A_1,
    V=Sigma^-5 Q vee Sigma^-6 Q vee Sigma^-8 Q vee Sigma^-9 Q.

Consequently level_G(X)=2 for G=A_2 vee A_1 vee Q, with finite
sums, arbitrary shifts, extensions and arbitrary retracts.

This is a human geometric and spectral proof. `verify.py` certifies
the characteristic-zero trace algebra and degree arithmetic;
`Main.lean` certifies its explicitly delimited universal algebraic
core. Neither program computes a spectrum. The mathematical theorem,
the four source applications and the delimited formal statement have
independent support from reviewer:copilot-e526b1e801ef. That sealed
review and the unchanged certificates are reused here, not replayed.
Sections 7--9 give the new publication assessment; its independent
Reviewer judgment remains separate from the certified mathematics.

## 1. Scope, known inputs and the source line

The independently supported C318LEVELLOW2, C318LEVELDICHOTOMY,
C318LEVELCORE and C318LEVELCOMPRESS are used unchanged. In particular,
the lower bound excludes all level-one retracts, and c=0 suffices
for an actual fracture lift. The sealed C318H3BASES, C318H3P5,
C318TAU3 and C318RATNORETRACT are not re-proved or replayed.

We also reuse the actual modification torsors, projective splitting,
finite solid resolutions and arithmetic scalar-row arguments of
`research/rational-unit-obstruction/proof.md`, Sections 4.3--4.5.
Their all-degree constructions, not their degree-three conclusion,
are applied below. The underlying residue/support comparisons and
ordinary finiteness are the accepted C318ORD_SUPPORT, C318ORD_FIN
and C318CO2 inputs.

The new literature inputs are recorded in MATH_STATE.json:

* Huber--Kings, doi:10.1017/S1474748010000216, Example 0.4.4 and
  Definition 0.4.5: the characteristic-zero matrix primitives.
* Huber--Kings--Naumann, arXiv:0904.3863v3, Theorems 3.1.1 and
  3.3.3: natural Lie comparison on sufficiently deep uniform
  subgroups, with trivial finite free coefficients and the lower
  5-series filtrations.
* BSSW, arXiv:2402.00960v2, Proposition 2.5.1 and Corollary
  2.5.9: the additive equivariant Witt retraction over the
  algebraic closure, used to identify a nonzero source line.
* The known height-one telescope/localization equality and smashing
  of L_1, as explicitly stated in Barthel--Beaudry,
  arXiv:1901.09004v2, Section 2, the discussion following
  Conjecture 2.15. Miller's original odd-prime telescope computation
  is Theorem 4.11 and Corollary 4.12 of
  doi:10.1016/0022-4049(81)90064-5. The latter corollary states
  the telescope's homotopy, not by itself a general localization
  theorem; these uses are not conflated.

The primary passages actually inspected are in
`research/literature/degree-five-*`. Their independent source
attributions are recorded under reviewer:copilot-e526b1e801ef.

Let e_5^P be the degree-five reduced-trace primitive of P_3,
and e_5^J the matrix primitive of

    J_3={g in GL_3(Q_5): v_5(det g)=0}.

Our normalization is

    e_5(X_1,...,X_5)=(1/30) Alt tr(X_1 X_2 X_3 X_4 X_5).   (1.1)

The factor 1/30 is rational and has a denominator divisible by
five. No reduction of (1.1) modulo five is used. In degree five
H_b^5(P_3) is the single primitive line: there is no degree-five
product of the lower primitives of degrees one and three.

The constant image of this line spans pi_-5 L_0D. To check the
map, not only its dimension, extend the residue field k=F_(5^6)
to bar k. BSSW's additive P_3-equivariant retraction of
W(bar k)->pi_0 E_3(bar k) makes the image of e_5^P nonzero:
its further image in Witt cohomology is e_5^P tensor 1.
Finite projective resolutions justify this coefficient extension.
Conjugation by a division-algebra uniformizer preserves reduced
trace, so e_5^P is fixed by coefficient Frobenius. Exact descent
across Delta=Gal(k/F_5), of order six, retains this nonzero class.

In the ordinary descent sequence, only internal degree zero
survives rationally. The central scalar 6 fixes the deformation
ring and acts on pi_(2m) by 6^m or its inverse; the central bar
homotopy acts as the identity on cohomology. For m!=0 the
nonzero scalar 6^m-1 becomes invertible after inverting five.
The accepted finite-amplitude descent makes rationalization of
this finite filtration legitimate. Hence the nonzero constant
image of e_5^P gives a nonzero element of pi_-5 L_0D. The known
one-dimensionality makes it a generator, not a possibly unrelated
class. This is the source line whose comparison is computed below.

## 2. Full parabolic transport, including the mixed class

Write K_2=GL_2(Z_5), P_1=Z_5^times and G_o=K_2 x P_1.
Let Y_ord be the ordinary stratum, to distinguish it from the
spectrum Y. It has its original relative classifying maps

    c_3:Y_ord -> BP_3,       c_o:Y_ord -> B(K_2 x P_1).

Over C=C_5, perform the length-one lower modification of the
universal quotient V_3 -> V_1. It gives the actual sequence

    0 -> L_2 tensor O -> V_3^- -> V_1^- -> 0.               (2.1)

Here L_2 is the original integral rank-two Tate local system;
the quotient is a rational line with its induced determinant
lattice. Relative slope-zero classification and local matrix
splittings give adapted frames with group

    D_par={ [[A,v],[0,a]] :
             A in K_2, a in Z_5^times, v in Q_5^2 }.        (2.2)

Forgetting the filtration gives iota:D_par->J_3. Projection
to A gives the ORIGINAL kernel-frame torsor; projection to a
retains the quotient-line frame. In particular no P_1-action,
quotient determinant or mixed frame contribution is discarded.
Forgetting the chosen length-one modification gives the ORIGINAL
P_3-torsor. These identifications are local frame identities,
and descend with the semilinear arithmetic action.

For an explicit staged-source locator, this is exactly the
sequence and the three torsor identifications in the height-three
manuscript's `build/sections/11-rational.tex`, lines 787--889.
We keep those maps but compute their degree-five pullback, not
the degree-three class treated there.

### 2.1 The primitive really restricts to zero

For arbitrary upper blocks M_i=[[A_i,v_i],[0,a_i]],

    tr(M_1 ... M_5)=tr(A_1 ... A_5)+a_1 ... a_5.            (2.3)

Thus Alt_5 of the left side is zero. Its first term is an
alternating five-linear form on the FOUR-dimensional space
of 2-by-2 matrices. Its second is an alternating five-linear
form on a one-dimensional space. Both vanish. All upper
coordinates v_i remain arbitrary in (2.3).

The vanishing is not a degree-counting argument on the Levi.
Indeed

    H_b^*(K_2 x P_1)=Lambda(e,d,h), |e|=|h|=1, |d|=3,

has a genuine nonzero degree-five class e d h. With
e=tr_2, d(X,Y,Z)=tr_2(X[Y,Z]), h=the quotient coordinate,
its value on E_11,E_12,E_21,E_22,E_33 is -2. This mixed
class is retained; (2.3) proves that the primitive has
coefficient zero on it.

The exact script checks all 21 five-wedges of the full
seven-dimensional parabolic, the 49 bilinear basis products
underlying (2.3), and the nonzero mixed value -2. On sl_3,
the raw alternating trace is closed, H^5 has dimension one,
and its top pairing with the closed three-form is -120.
The differential from degree seven to eight is zero, so
this nonzero pairing proves that the five-form is not exact.
These are characteristic-zero calculations. The separate
Jacobian computation over F_5 checks the full Levi complex;
it is not used to divide by 30 or to infer a rational
primitive's image from its residue.

For completeness, passage from the compact Levi to (2.2)
uses finite coefficients, not Lie cohomology of a noncompact
unipotent group. Exhaust Q_5^2 by 5^-r Z_5^2. Restriction
in positive degree q is multiplication by 5^q, hence its
inverse system is pro-zero at each fixed Z/5^ell level.
The degree-zero system is constant. Continuous cochain
restriction is surjective by extension from the clopen
subgroup. Derived limits therefore give only the constants.
The augmentation is natural for both Levi factors and all
external compact nerve parameters. Inflation from the Levi
to D_par is an equivalence with inverse block restriction.
Natural compact Lie comparison and (2.3) give

    iota^* e_5^J=0 in H_b^5(D_par).                        (2.4)

For this use of naturality, choose a common deep 5-congruence
depth in the Levi and in GL_3. The lower 5-series filtrations
make the inclusion filtered, and the target associated graded
is generated in degree one. The trivial finite free Z_5
coefficient satisfies the small-action hypothesis. Thus the
extra hypotheses of HKN Theorem 3.1.1(3), not just an
abstract comparison of dimensions, hold. Restriction to
these finite-index compact opens is injective rationally.

### 2.2 Identifying the P_3 class before pulling it back

Use the SAME determinant-matched modification stack

    M_3=[P_C^2/P_3]=[Omega_C^2/J_3].

The integral Kummer projective splitting from the sealed detector
argument applies in every degree. Its degree-five decomposition is

    H_b^5(M_3)=H_b^5(P_3)
             + H_b^3(P_3)(-1) + H_b^1(P_3)(-2).           (2.5)

The summands have arithmetic characters 1,chi^-1,chi^-2.
Choose an arithmetic element with cyclotomic value of infinite
order. Thus the arithmetic-fixed subspace is the SINGLE first
line, and the original P_3 pullback is nonzero on that line.

The original J_3 primitive also has nonzero image in this line.
Restrict to a deep uniform U in J_3. Building restriction and
natural compact Lie comparison identify its nonzero primitive.
For [Omega_C^2/U], the geometric rows have scalar weights -j
for j=0,1,2 by the already inspected integral Drinfeld theorem.
Finite projective Hom terms preserve those scalar actions.
The only differentials which could hit (5,0) come from
(3,1) and (2,2). Their weights are not zero, so arithmetic
equivariance makes both differentials zero after rationalization.
There are no higher geometric rows and no differential out
of the bottom row. The original bottom unit identifies it
with group cochains, so this is nonvanishing of the specified
J_3 classifying pullback. Both classifying maps are arithmetic
equivariant. Consequently

    e_5^P|M_3 = kappa_5 e_5^J|M_3,  kappa_5 != 0.         (2.6)

Apply (2.6) along the modification (2.1). The actual adapted
torsor (2.2), (2.4), and finite classifying-map naturality give

    c_3^* e_5^P=0 in H_b^5(Y_ord,C).                     (2.7)

This equality retains G_o and the P_3 classifying map. It
does not follow by forgetting a frame action and inflating
a nullhomotopy afterwards.

## 3. Reflecting zero to the actual completed coefficients

This step is needed: geometric zero or residue zero alone
would not decide the scalar.

### 3.1 The full ordinary constants comparison

Let B_0=k[[x,y]][x^-1], and B_pk be its ordinary perfected
analytic endpoint. All algebraic cochains use one bounded
pole lattice on each compact source. The actual constants
map is

    R Gamma(G_o,k) -> R Gamma(P_3,B_pk).                   (3.1)

Here is the small full-action enhancement needed for this
application. In the independent-pair presentation, remove
the double origin and then the proportional pairs in N_1^2.
The accepted relative residue/translation support calculation
gives the following rows, with all compact nerve parameters:

| Removed support | Degree | Character at a stabilizer diag(a,d), quotient v |
|---|---:|---|
| Double origin | 6 | det(A)^-1 v^2 |
| Proportional pairs | 3 | d^-1 v |
| Proportional pairs | 5 | a^-1 d^-1 v^2 |

These are the inverse translation orientations: the origin
has two translation lines; on a direction chart the normal
line contributes d^-1, and its punctured tangential row
adds a^-1. This is precisely the finite support computation
used by the accepted ordinary comparison, not a new
uncompleted/complete interchange. On each finite clopen
direction chart the residue maps and both frame actions
commute; the finite-partition limits have the same uniformly
pro-zero discarded kernels.

The central Teichmuller element [2] I_2 has characters 4,3,4 in F_5,
never 1. Its order-four averaging is exact. It kills all
removed support rows in every remaining group-cohomological
degree, retaining the P_1-action. Constants compute the
ambient N_1^2. The support triangles therefore prove (3.1),
as the original structure-map/unit arrow, both over k and
over C-flat. The finite-field descent and the profinite
parameter identifications are those of the accepted support
comparison. This is also the statement proved in the staged
`05-analytic.tex`, Proposition `h3:prop:ordinary-constants`
and Theorem `h3:thm:completed-cohomology`(i).

The natural B_0->B_pk cohomology comparison, including its
maps from constants, follows without assuming an equivariant
inverse to a chosen basis. On the connected-marking cover,
the ordinary source has the accepted basis 1,xi_1,xi_2,
xi_1 xi_2. The same support calculation before P_1-invariants
identifies the analytic endpoint with the actual K_2
constants. The accepted specified-action transport identifies
the images of these four ORIGINAL classes with its basis.
Thus the natural completion/perfection map is an underlying
quasi-isomorphism there. This is an actual P_1-equivariant
map of the marking diagrams, with all their compact nerve
parameters. The forgetful functor is conservative, so it
is a quasi-isomorphism as a P_1-object. Taking the P_1
double nerve gives the unmarked B_0 comparison. Finite
etale descent and bounded-pole refinements are performed
at finite marking stages before their algebraic union.

This use of the lower-class basis proves that a particular
coefficient comparison is an equivalence. It does NOT infer
that a degree-five class vanishing after forgetting P_1
vanishes before forgetting it. That is exactly the gap
avoided by the independent full-parabolic calculation (2.7).

It also follows that phi_p:B_0->B_0 induces an isomorphism
on this cohomology: it commutes with the just identified
comparison and is invertible on B_pk.

### 3.2 Witt reflection with arithmetic retained

Apply the additive exact sequences

    0 -> R --V^(ell-1)--> W_ell(R) -> W_(ell-1)(R) -> 0

to the SAME constants maps. The continuous coordinate
sections give exact computing cochains; induction proves
their Witt equivalences. At the derived coefficient limit,
there is the natural square

    H^5(G_o,W(k)) ------~-----> H_W^5(Y_ord)
          |                           |
          v                           v
    H^5(G_o,W(C-flat)) --~----> H_W^5(Y_ord,C).             (3.2)

It commutes with the P_3 coefficient-unit map as well.
On a finite torsor nerve both ways simply send the same
locally constant Z/5^ell section to its Witt section.
This checks the action face, both frame factors, reductions,
arithmetic base change and the original P_3 map before
any totalization or derived coefficient limit.

The right vertical map of (3.2) is injective after inverting
five. Indeed G_o has no five-torsion and has a bounded
finite projective resolution. After tensoring its terms
with the augmentation Z_5, a trivial coefficient M gives
a fixed finite matrix complex extended to M. The extension
W(k)->W(C-flat) is torsion-free, hence flat, and is faithfully
flat after inverting five. This proves injection, including
for the valued Witt-coordinate topology; it does not
identify arbitrary condensed sheaves from their point values.

Choose an integral multiple beta of e_5^P, invariant under
Delta. Apply its Witt coefficient unit and (2.7). By (3.2)
its original Witt image w satisfies w[1/5]=0. Consequently
there is ONE integer N such that 5^N w=0 in the derived-limit
cohomology, not a different exponent at every finite length.

### 3.3 The last-ghost maps and the uniform exponent

Put D_ell=(W(k)/5^ell)[[x,y]][x^-1]. For finite Witt length,
the two original coefficient maps

    W_ell(B_0) --beta_ell--> W_ell(B_pk),
    W_ell(B_0) --gamma_ell--> D_ell

induce cohomology isomorphisms. For gamma_ell the formula is

    gamma_ell(a_0,...,a_(ell-1))
      =sum_i 5^i lift(a_i)^(5^(ell-1-i)) mod 5^ell.        (3.3)

Changing a lift by a multiple of five changes its summand
by a multiple of 5^ell. The usual ghost polynomial identities
make (3.3) a natural unital ring map. On Verschiebung and
5-adic associated gradeds it is a power of phi_p.
For beta_ell the graded map is the original B_0->B_pk.
The preceding comparison therefore proves both isomorphisms
by finite-filtration induction. Cochain quotient sections
are continuous and preserve a common enlarged pole bound.

Explicit action-stable pole lattices are

    L_(ell,d)=[x]^-d W_ell(k[[x,y]]),
    M_(ell,d)=sum_(j=0)^(ell-1) 5^j x^(-d-j) A_ell.

The identity g(x)=x u_g+5 h_g and its finite geometric-series
inverse prove stability of the second lattice; Witt
functoriality proves stability of the first. At fixed ell,
(3.3), the coordinate sections and their finitely many
reductions use one enlarged d. This applies to every
compact nerve parameter before the algebraic pole union.

There is a real transition twist, which must not be dropped:

    red gamma_ell =
      gamma_(ell-1) R_ell W_ell(phi_p).                   (3.4)

Moreover gamma_ell acts on W_ell(k) by sigma_k^(ell-1),
not generally the identity. But it fixes Z/5^ell exactly,
by unitality. The constant classes beta therefore ARE
Frobenius fixed, and their images d_ell in H^5(P_3,D_ell)
have the actual ordinary reduction transitions.

The projection of w to each W_ell(B_pk) group is killed
by the SAME 5^N. Pull back through beta_ell and apply
gamma_ell. It follows that

    5^N d_ell=0 for EVERY ell.                            (3.5)

All maps are Delta-equivariant, and exact order-six
semilinear descent identifies these with the coefficient
images over G_3(k)=P_3 semidirect Delta. The argument
does not declare the finite d_ell to be zero: they can
be torsion. It is the uniform exponent (3.5) that will
make their completed image rationally zero.

## 4. The spectral bridge and identification on Y

Apply ordinary L_1(-/5^ell) to the ALREADY COMPLETED
height-three Amitsur terms. Exact Amitsur descent preserves
this totalization and its uniform convergence bound.
No ordinary residue smash is moved through an arbitrary
limit and no K(3)-local tensor product is replaced.

Here is a short finite-length coefficient argument. For
ell=1 the normalized height-one Moore telescope, tensored
with an ordinary E_3-module N, acts by x times an invertible
period. The known height-one localization equality and
smashing of L_1 identify its target with (N/5)[x^-1].
For ell>1 there is no need to choose compatible higher
Moore self-maps. Invert x as an E_3-module operation on
the cofiber triangles

    N/5^(ell-1) -> N/5^ell -> N/5.

Inductively both end terms are E(1)-local, so the middle
localized term is local too. Exactness of L_1 and the
two end equivalences show that the natural x-inversion
map is exactly the L_1-localization at every length.

For a completed Amitsur term N_Q with Q=P_3^a, its
degree-zero coefficient is consequently

    C_cts(Q,(W(k)/5^ell)[[x,y]])[x^-1].

This is the bounded-pole cochain convention, with actual
cofaces. Every action sends x to x u_g+5 h_g, a unit
after x-inversion modulo 5^ell. The universal property
of module localization therefore extends the ACTUAL
cofaces, Moore reductions and coefficient-unit maps
uniquely. They are exactly the D_ell maps used in (3.3)--(3.5).
This establishes map identification, not merely equality
of cohomology ranks. The longer finite-length model in
the staged `09-integral.tex`, lines 421--590, identifies
these same coefficient and Moore maps in degree -3;
here the unique degree -5 edge is checked separately.

The mod-five coefficient has cohomological columns 0--5:
it is the full K_2 x P_1 computation, not the four-dimensional
K_2 computation with the connected action forgotten.
The finite 5-adic filtration gives the same bound and
finiteness at every length and every periodic coefficient
degree. Central tame scalars annihilate internal degrees
not divisible by 8. The first possible differential has
length 9 and cannot fit this column range. Hence in stem
-5 the UNIQUE term is (s,t)=(5,0), and naturally

    pi_-5 L_1(D/5^ell)=H^5(G_3(k),D_ell).                 (4.1)

In stem -4 the unique term is (4,0); its group is finite.
This proves the Mittag--Leffler condition needed for the
Milnor sequence. For completeness, the source column
bound is nine. In source stem -5 it too has only (5,0);
the possible length-nine incoming and outgoing arrows
are outside the column range. Thus the constant primitive
of Section 1 maps through exactly the edges (4.1), with
no hidden lower-filtration class or length-dependent
multiplier.

For an E(1)-local S-module M, derived 5-completion is
K(1)-localization. One direct proof uses

    F_S(S[1/5],M) -> M -> holim_ell M/5^ell.

The fiber is rational, the limit is E(1)-local and
orthogonal to rational modules, so the last map is the
height-one fracture localization unit. Apply this to
L_1D. With ordinary Moore transitions, (4.1) gives

    pi_-5 L_K(1)D = lim_ell H^5(G_3(k),D_ell).            (4.2)

The Milnor lim^1 term is zero by the just established
finiteness in stem -4. The maps from D in (4.1)--(4.2)
are the ACTUAL Moore quotient/localization maps.
Equation (3.5) makes their primitive image zero after
inverting five. Section 1 identifies that primitive
with a generator of pi_-5 L_0D. Therefore

    pi_-5(L_0D -> L_0 L_K(1)D)=0.                        (4.3)

Finally D->X is a K(0)- and K(1)-equivalence, so its
localization naturality identifies (4.3) with the actual
comparison for X. Rationally B_1 has degrees only 0,-1.
Rationally L_K(1)B_1 has degrees only 0,-1,-1,-2.
Neither it nor its adjacent degree contributes at -5.
The cofiber sequence and its localized sequence thus
give the two vertical isomorphisms in

    pi_-5 L_0X -------tau------> pi_-5 L_0 L_K(1)X
          | ~                              | ~
          v                                v
    pi_-5 L_0Y ------tau_1----> pi_-5 L_0 L_K(1)Y.

Its top map is (4.3). The bottom map is zero. In the
actual unit-first basis of L_K(1)Y this bottom map is
precisely tau_1(v_5)=c z. Thus **the actual scalar is c=0**.

## 5. Realizing the lift and the exact level

In the E(1)-local fracture diagram for Y, let V->L_0Y
be its rational complementary inclusion. Its composite
to L_0 L_K(1)Y is zero: degree -5 was settled above,
and -6,-8,-9 have no possible target. Maps of rational
S-modules are determined by their graded Q_5-linear
homotopy maps, so a nullhomotopy exists. Together with
the zero map into the K(1)-corner it gives a fracture
lift V->Y.

Combine this lift with the EXISTING B_2->Y. The map
B_2 vee V -> Y is a K(1)-equivalence and a rational
equivalence. Fracture makes it an E(1)-local equivalence,
under that original B_2 map. Consequently

    B_1 -> X -> B_2 vee V -> Sigma B_1

is an actual two-layer presentation with both blocks
in level one. The accepted C318LEVELLOW2 excludes
level one, even after arbitrary retracts. Hence

    level_G(X)=2.

This is stronger than the previously supported bounds
and five-degree reduction. It is compatible with the
accepted nonzero FIRST middle attachment and failure
of a canonical-unit retraction; it does not split that
first block or refute those results. No false assertion
in the staged manuscripts is identified.

## 6. Exact evidence and its boundary

Run `python3 research/generation-level/degree-five/verify.py --check`.
The new certificate distinguishes its exact algebra from its
human spectral application. It imports the unchanged matrix
helpers from the accepted detector script without running that
script's old certificate or rebuilding its evidence.

The native Lean 4.31.0 run exited zero, with audit exit zero
and `proof_holes=[]`. Its source and statement-fidelity document
are unchanged since that run. It proves universal alternating-form
vanishing and zero reflection, with the application exclusions
specified in `statement_fidelity.md`. It does not formalize (4.3).

The sealed review supports the actual scalar computation, not only
its finite algebra. The assessment below neither enlarges the Lean
statement nor attributes a spectrum calculation to either program.
No accepted verifier or compiler was rerun for this assessment.

## 7. Primary-source implications, not just theorem wording

The new comparison passages are archived in
`research/literature/level-two-contribution-*-excerpt.txt`.
The dated staged sources and the external sources below are credited
for their constructions as well as their stated conclusions.

### 7.1 What the staged attachment formulas actually determine

In the height-three manuscript, `02-fracture.tex`,
Proposition `prop:fracture` and Theorem
`thm:attachment-identification`, put W=B_1,
U_mid=B_2 and rho:F_4->B_2 for the pullback projection.
With the specified quotient equivalence t:V->cofib(h), there is
a map of cofiber sequences

    F_4 --a--> X --> V --> Sigma F_4
     | rho     | q  | id    | Sigma rho
     v         v    v       v
    B_2 --h--> Y --> V --> Sigma B_2.

Consequently, for the manuscript's signed last-attachment map
g=partial_a t, naturality gives

    (Sigma rho) g = partial_h : V -> Sigma B_2.           (7.1)

The source's second signed roof identifies g using the ACTUAL
positive-height comparison of X; it does not evaluate that comparison.
Our result evaluates its pushforward (7.1), not g itself. By the
accepted scalar calculation in `../proof.md`, Section 3, the only
possible component of partial_h is

    Sigma^-5 Q -> Sigma^-3 A_1 = Sigma(Sigma^-4 A_1).

Its scalar is, up to the fixed rotation convention and nonzero
normalizations, the degree-five scalar c of this report. Thus c=0
is exactly the additional assertion that the second block triangle
splits under its existing B_2 map. It does NOT assert that the last
attachments to F_4, or the first attachment d_3, all vanish.

This distinction can be checked at the level of actual spectra,
without mistaking a finite shadow for a realization of D. Let

    R=Sigma^-3 R_1 vee Sigma^-4 R_1,
    P=L_0B_2 vee V,  T=L_0R.

For lambda in Q_5 define f_lambda:P->T to be the canonical unit
on the two L_0B_2 generators, multiplication by lambda on the
degree-minus-five complementary generator, and zero on the
remaining three complementary generators. The E(1)-local spectrum

    Y_lambda = R x_T P

has K(1)-localization R, rationalization P, and a map
h_lambda:B_2->Y_lambda with those SAME prescribed local components.
Its cofiber is V. Its canonical comparison is f_lambda, so its
second block splits exactly when lambda=0. Exact localizations
preserve this finite pullback: rationalization identifies the first
map R->T with an equivalence, while K(1)-localization kills P and T.
This proves the claimed properties directly. It is also the
already supported scalar dichotomy, now used to test an implication.

These are not alternative realizations of the actual height-three
sphere or its full geometric input. They prove the narrower and
relevant point: the displayed local blocks, compatibility on B_2,
and formal cofiber/attachment identities do not determine their
remaining gluing coefficient. A deduction from the manuscripts'
full constructions must still identify and calculate that coefficient.

The source's `11-rational.tex`, Theorem
`h3:thm:rational-compatibility`, calculates the degree-THREE image
alpha_3 -> a_3 delta with a_3 nonzero, and its product with zeta.
It chooses an arbitrary remaining degree-five exterior generator.
The letter c used there for a_3 is NOT the degree-five scalar c
used here. No zero-versus-nonzero contradiction or manuscript
symbol error is being asserted.

### 7.2 The generic filtration source already has stable transport

The generic-prime manuscript supplies more than a mod-five dimension
calculation. In `06-constants.tex`, Proposition
`prop:modification-transport` transports finite Postnikov constant
cochains and their sphere limits. Its block-restriction identity is
explicitly AFTER FIXING the connected quotient frame, with group
diag(g,1_t). In `07-generators.tex`, Theorem
`thm:stable-generators` gives compatible integral primitive classes.
In `10-constant-module.tex`, Proposition
`full:surviving-module` identifies the transposed action on the
underlying cohomology after forgetting P_t, and Proposition
`prop:constant-module` proves that xi_i for i>n-t acts as zero.
The simultaneous height bases in `11-spectral.tex` use the ordinary
residue coefficient module and the surviving products.

At n=3,t=1, fixed-frame restriction lands in K_2, whose rational
cohomology has no degree five. That is already a useful consequence.
It is not the vanishing needed here before forgetting P_1:

    H_b^5(K_2 x P_1) = Q_5 { e d h } != 0.

Restriction to the fixed-frame cover kills h and therefore this
possible mixed term. Nullity after that restriction cannot reflect
nullity of the original class. Section 2 instead computes the primitive on
the FULL parabolic with arbitrary upper coordinates and both diagonal
blocks; it proves that the coefficient of e d h is zero.

Nor does zero action of xi_3 after mod-five residue testing by itself
give rational vanishing through all Moore lengths. Sections 3--4
retain the original equivariant coefficient maps, their Witt
Frobenius transition twist, and ONE torsion exponent valid at every
length, then identify their inverse limit with the actual spectral
localization. These steps are a degree-five application and extension
of the attributed manuscript machinery, not a discovery of that
machinery. Simply inflating a fixed-frame nullhomotopy would omit
exactly the contribution that survives in the full group.

### 7.3 The strongest external comparisons and their consequences

**BMR, October 7, 2026.** Theorem H (= Theorem 2.0.1) applies to
EVERY 0<t<h, in particular (h,t,p)=(3,1,5). It identifies the
equivariant frame torsor with determinant-matched extensions

    0 -> O^2 -> O(1/3) -> O(1) -> 0.

This is genuine direct three-to-one geometry and is credited as such.
It would be incorrect to dismiss this paper as providing only
adjacent-height geometry. Proposition 4.3.13 also supplies spectral
and individual even-coefficient descent for a Noetherian Luriean
pair and a derived-totalization diagram of flat relatively perfect
algebras. Theorem 4.4.8 realizes the indicated formal-isomorphism
torsor as a K(h)-localized tensor product of its Lubin--Tate theories.
Those are substantial ingredients for a coefficient-to-spectrum
argument, not a computation of the present coefficient map.

Their use to deduce this theorem still requires the actual
ordinary/perfected coefficient comparison, primitive transport with
both residual frame factors, uniform torsion and the specific Moore
and localization maps of Sections 2--4. BMR's Theorem A and
Corollary B do apply at (3,5), but their retraction is in the
K(2)-local category. They do not determine the E(1)-local quotient
of the specified global B_1 map. Proposition 5.3.8 is conditional
on a bigraded cohomology comparison; the verified strong consequence
in Corollary 6.6.3 is at height two. Applying those conditional or
height-two conclusions here without their missing input would not
be an implication analysis.

**Torii, doi:10.2140/pjm.2011.250.439.** Theorems 4.7 and 6.2
construct the adjacent-height overlap spectral sequence and a
morphism converging to the canonical map

    L_K(n) S -> L_K(n) L_K(n+1) S.

Formula (7-1) and Theorem 7.6 identify its E_2 map through an
actual inflation comparison; Theorem 8.1 detects the image of zeta_n.
These are important map-level precedents. They are not merely
calculations of ranks. Taking n=2 concerns the height-three
K(2)-overlap, while n=1 substitutes height two, not the direct
K(1)-localization of D. Their iteration does not evaluate the
rank-three degree-five primitive on the fixed Y. Even an applicable
overlap spectral sequence would still require the coefficient-map
calculation and its convergence/edge identification. The present
argument supplies that evaluation, not a new general construction
of transchromatic Adams spectral sequences.

**BSSW and the height-two splitting chain.** Theorem A of
arXiv:2402.00960v2 gives the single-height rational exterior algebras;
its equivariant additive Witt retraction supplies the nonzero source
line used in Section 1. Its Section 2.4 explicitly distinguishes
rational homotopy from the further factorization assertions of
Conjecture 2.4.2. The known odd-prime height-two splitting, in
Barthel--Beaudry arXiv:1901.09004v2, Theorem 6.7 and its cited
height-two proofs, supplies the lower-height pieces. It does not
identify Y with another local sphere. The family Y_lambda above
shows concretely why these corner calculations do not supply c.
All unchanged source judgments for these known inputs are reused.

**Trace primitives and naturality.** Huber--Kings and
Huber--Kings--Naumann supply the primitive formula and the filtered
compact Lie comparison used in Section 2. The characteristic-zero
alternating-trace vanishing is a known consequence of that formula.
It does not alone identify the original geometric torsor, its
completed coefficient image, or the spectral comparison. These
constructions and hypotheses, not a supposedly new trace identity,
carry the mathematical contribution.

### 7.4 Scope of the originality assessment

The comparison tests implications of applicable primary statements
and their closest geometric and spectral tools. It is not an inference
from the absence of the words "level two". The positive distinction
is the full-equivariant evaluation of the actual gluing map that those
inputs leave to be calculated, together with the relative spectral
splitting and a sharp invariant covering all retract presentations.
It is an attributed new structural consequence of the staged source
line, not a claim to have originated its filtration, modification
geometry, rational exterior algebra or descent framework.

The literature delegation examined four targeted discovery queries
and five primary chains. This remains a bounded priority assessment,
not a theorem excluding every possible unpublished or differently
formulated consequence. The spurious chromatic-level citation to
arXiv:1005.1920 is excluded: the identified primary abstract concerns
the cosmological constant. It supplies neither a competing mathematical
theorem nor evidence of originality. No mathematical claim here
depends on that rejected search assertion.

## 8. Technical contribution and mathematical significance

There are three different levels of content.

1. The matrix primitive, its characteristic-zero block vanishing,
   rational exterior algebras, lower-height splittings and categorical
   level convention are known. The finite certificate and Lean proof
   independently check delimited algebra; they are not priority claims.
2. The technical core specific to this theorem is the full-equivariant
   degree-five bridge: identify the actual primitive source line, kill
   its possible mixed ordinary-frame component, reflect zero through
   the original completed coefficients with uniform finite torsion,
   and identify the resulting map on spectra. The presence of e d h
   makes the fixed-frame shortcut genuinely insufficient. This core
   is proved in Sections 1--4 and was independently accepted.
3. Given that bridge, the fracture lift is short. Sharpness nevertheless
   needs more than a nonsplit displayed attachment: the supported
   idempotent argument in `../proof.md`, Section 2 excludes arbitrary
   retracts of every finite shifted-generator presentation. After
   rational K(2)-localization, cancellation forces the retained A_2
   shifts to be 0,-1. Naturality then forbids the known nonzero
   degree-minus-three comparison. The use of idempotents and Hilbert
   polynomials is standard; this unrestricted application is part of
   the exact-level result, not a new general categorical technique.

The improvement is from three ordered chromatic blocks and the bounds
2<=level_G(X)<=3 to an ACTUAL two-layer presentation and the exact
minimum two. It computes an invariant of the object, not just the
length of one displayed filtration. Meanwhile d_3 remains nonzero and
the accepted strong wedge obstruction remains valid. Thus the failure
of strong splitting does not require the third ordinary extension
layer: one can compress the second gluing problem while the first
is still genuinely nontrivial. This locates where the remaining
extension complexity sits. That structural separation, rather than a
new name for the eight cofibers, is the significance of the theorem.

The assertion is only at p=5 and height three, for the specified
B_1 and B_2 maps and the stated ordinary finite-sum/retract level.
It does not split X as the classical strong wedge, retract its
canonical unit, identify an E_infinity-ring decomposition, prove a
canonical or unique choice of splitting, generalize to other primes,
or formally verify the spectral theorem in Lean. No claim about
field-wide generation dimension follows from one object's level.

## 9. Publication assessment and attribution

**Engineer assessment:** recommend the exact-two theorem as a
publishable, attributed structural contribution, with its degree-five
spectral bridge and retract-unrestricted sharpness stated together.
The inspected stronger source tools have been credited and tested for
their consequences; the recommendation is not based on a search miss
or an isolated comparison of theorem wording. The short trace identity
and the final fracture step should not be advertised as the original
technical achievement.

The mathematical proof is independently supported by the sealed
e526b1e801ef review. This recommendation is a new HUMAN originality
and significance judgment, not a machine certificate or a Reviewer
decision. Five new comparative source readings, the implication
argument of Section 7, and this publication recommendation require
the normal Host-invoked independent Reviewer. The old weak-unit
publication judgment is neither reopened nor promoted. Until that
independent decision establishes the required novelty and significance,
the publishable campaign is not declared complete.
