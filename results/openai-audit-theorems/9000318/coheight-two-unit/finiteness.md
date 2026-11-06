# Ordinary finite-frame finiteness at (p,n,t)=(5,3,1)

This proves C318ORD_FIN, rather than assuming it in the previously reviewed
cutoff argument. The proof uses the one-variable translation algebra at
(n,t)=(3,2). All coefficients below are the algebraic coefficients of the
manuscript, not their completions. A compact cochain source has one common
finite frame/root stage and one common pole bound. Perfection occurs only
in the auxiliary height-two boundary calculation; its descent back to the
ordinary coefficient is part of the proof.

**Theorem.** Let k be as in CTX318CO2; in particular k=F_(5^6) is allowed.
For every finite joint frame level U at (n,t)=(3,1),

    sum_i dim_k H^i_cts(P_3,B_U) < infinity.

The same holds for the compact transfer lattices, and for the compact
torsion-coordinate, invariant-line, conormal, and duality extras needed
on their successive labelled boundaries. In particular it holds for
every finite B_(K,G) used to define B_conn,G.

This is a proof of finiteness, not a dimension formula, a new choice of
exterior generators, or a proof of the specified xi_i action. The full
ordinary comparison with all constant-cochain coherences remains the
separate claim C318ORD_SUPPORT. The formal source in `finiteness/` proves
the universal nilpotent-section and one-variable Koszul algebra below;
it does not formalize adic spaces or continuous group cohomology.

## 1. Known inputs and the acyclic induction order

The literature inputs, with their actual hypotheses, are recorded as
assumptions of C318ORD_FIN. The primary texts are in `research/literature/`.
They are not assumptions of the desired finiteness statement:

* Ardakov--Wadsley, Proposition 3.3: Noetherian completed group algebras
  and finite global dimension for compact analytic groups without
  5-torsion. Tang, Theorems 3.2, 3.14(i), Proposition 3.21, identifies the
  corresponding finite projective and solid cochain computations.
* BGHS, Propositions 4.16, 4.40, Theorem 4.19 and Remark 4.23: compact
  analytic duality, with the adjoint determinant orientation.
* Fargues--Fontaine, Definition 8.2.2 and Theorem 8.2.10;
  Fargues--Scholze, Proposition II.2.5(ii), Theorem II.2.19 and
  Corollary II.2.20; Scholze--Weinstein, Corollary 5.1.2 and
  Proposition 5.1.6; Anschuetz--Le Bras, Corollary 3.11: standard
  bundles, Honda covers, relative constant-slope descent, and relative
  full faithfulness. The relative assertion is supplied by the last two
  relative theorems, not inferred from a classification at field points.
* Pignon--Ywanne v1, Corollary 3.2.4, Proposition 4.3.1 and
  Corollary 5.3.2: supported localization and the compact-support
  primitive comparison on affine space as a Zariski open of projective
  space. No primitive comparison for an arbitrary nonproper space is
  assumed. Proposition 2.1.2 and Lemmas 2.1.3, 3.2.5 identify the
  integral coefficient and its quasi-pro-etale pullbacks.
  Scholze, Perfectoid spaces v1, Theorem 6.3(ii)--(iv) and
  Proposition 7.13, supplies affinoid almost acyclicity, including
  the etale version used on the Laurent charts.
* Zink, Theorem 48, Corollaries 49, 95, Propositions 40, 99; Lau v1,
  Section 5, Theorem 5.1 and equation (5.1): marked square-zero display
  deformations, their Hodge tangent action, the universal
  Kodaira--Spencer isomorphism, and rigidity. The source obtained for Lau
  is arXiv:0803.1390v1, pages 6--7, not a claim that those are the
  published page numbers.
* Hedayatzadeh, Lemmas 3.23--3.24 and Theorem 3.25: exterior powers for
  dimension-at-most-one p-divisible groups, including arbitrary base
  change and compatibility with finite truncations, at p>2.

Every group to which finite analytic cohomological dimension is applied
has no element of order five. Indeed Q_5(zeta_5) has degree four and
cannot embed in the division algebras of degrees two or three; a faithful
matrix representation of C_5 has dimension at least four. The relevant
matrix ranks are at most two. Subgroups inherit this property.
The dimension of P_a is a^2. Its orientation is trivial: conjugation on
the split matrix algebra has determinant one.

The order of proof is:

    compact endpoints (2,2),(3,3);
    compact and ordinary (3,2);
    full/perfected boundary rows (3,2);
    compact (2,1);
    compact (3,1);
    ordinary (3,1).

The endpoints have finite coefficients. Ordinary (2,1) and the desired
ordinary (3,1) are not used in any preceding step.

## 2. A finite stable image without ordinary finiteness

Here we need only a weaker consequence of the support construction,
not the still-open assertion about all specified-class coherences.
For each of (2,1),(3,2),(3,1), and each fixed admissible coefficient,
choose P=x^(-b)L with b sufficiently large. The finite matrix of
transpose Frobenius has a bounded denominator; changing b multiplies
it by x^(b(Q-1)). Thus P can be made transfer stable with the
positive dual matrix used below. Then

    I^i = intersection_a S^a H^i(P_n,P)

is finite dimensional. This assertion has the following independent
proof that does not insert ordinary cohomology into a Fitting argument.

The finite labelled rings have coordinates C_l=k[[w_1,l,...,w_m,l]]
and their full lift rings have coordinates z_i,l with
w_i,l=z_i,l^(5^(t*l)). The full-set identity is

    x = unit * product_(0 != v in F_5^m) w_v.

Quotient by one primitive dead label is the height-(t+1) labelled disc
with finite pth roots of parameters. This follows by factoring the
full-set polynomial by the dead F_5-line; independent further labels
repeat the factorization. The conormal is the corresponding invariant
line power. These statements hold for the full rings on nilpotents,
not just their reduced spectra.

For completeness the geometric comparison used for this weak
assertion can be constructed before any cohomological finiteness.
The coordinates of the completed analytic lift tower are

    X_i = limit_l z_i,l^(5^(n*l)).

On a closed bound max |z_i,l|^(5^(n*l)) <= rho<1, put
lambda=max |x_a|. The Honda congruence gives

    lambda <= rho^(5^(t-n)),
    |X_i-X_i,l| <= rho^(5^(n*l+t-n)).

The first inequality follows by applying the increment estimate to
the level-one parameter ideal and using lambda^(5^t)<lambda.
The second tends uniformly to zero. Finite lying-over and the strict
dominance of the Honda term show that these bounded domains project
surjectively to earlier levels. Fractional polynomials consequently
have their usual Gauss norms. The transition formula in
5^(t*(l-l0))-powers makes their images dense. This identifies the
completed analytic tower with m Honda balls; the full-set identity
identifies the exact-height open with independent rational sections.
This analytic realization is used for a comparison, not substituted
for the coefficient ring.

Relative full faithfulness identifies the quotient by P_n with the
independent extension locus

    Z = (Ext^1(O(1/t),O)^m)_ind.

Here is the rank-degree check underlying this identification. For an
extension of O(1/t) by O^m, a rational relation between its m classes
is precisely a split quotient O of its middle term. A nonpositive
slope quotient must be such a zero-slope quotient. Without one, all
slopes are positive; degree one then permits only one positive stable
factor, necessarily O(1/n). In the other direction the saturation of
m independent sections in O(1/n) has degree zero: a positive degree
saturation would contradict stability. Its quotient is O(1/t) by the
same degree-one argument. Constant-polygon descent and relative full
faithfulness make these constructions inverse over varying perfectoid
bases. Fixing the integral determinant component restricts the middle
frame from D_n^times to P_n.

We check that this is the actual connected marking, including that
integral component. For beta:G^0->Gamma_t with
beta(T)=sum_j b_j T^j, set q=5^t and write a_q for the leading
coefficient of [5]_G. The identity beta([5]_G)=beta^q gives

    b_j^q-a_q^j b_j = a polynomial in b_1,...,b_(j-1),

with power-bounded coefficients. Induction makes every b_j power
bounded, and b_1^(q-1)=a_q!=0. Thus beta converges uniformly on
each strict subball, with tail bounded by rho^(N+1). On reduced
perfectoid tests it kills every Tate torsion section, hence the
rational subbundle. Relative full faithfulness gives a nonzero
map of the positive quotient bundle to O(1/t); it is an
isomorphism. This defines an equivariant map from the actual
connected-marking P_t-torsor into the quotient-frame D_t^times-torsor.

The reduced-norm valuation of its determinant descends to a
locally constant integer on the independent Tate-section space Y.
That space is connected: at any point every nonzero rational-row
Honda relation function f_v has a nonzero value. Centered Gauss
seminorms of increasing radius keep each such value nonzero,
because its constant term remains in the expansion. These paths
stay in Y and eventually reach an origin Gauss polydisc; those
origin discs are joined by increasing radius. Each f_v is tested
separately; no uniform lower bound over infinitely many rows is
required. Rank-one maximalization gives the same conclusion for
locally constant functions on the adic space. The determinant
integer is consequently constant. Normalize its single value,
and the map becomes an equivariant isomorphism of P_t-torsors.
This verifies the integral frame used above, without replacing
the connected marking by an arbitrarily selected bundle frame.

Write R=(O_E/varpi)^a, with the almost integral coefficient Acal.
Residue identifies P^vee with top local cohomology of
M=Hom_(C_1)(P,omega_(C_1)). In an integral finite trace/volume basis
e_i=f_i eta the actual transpose is

    F(e_i)=f_i^Q eta=sum_j a_ji e_j,    a_ji in x C_1.

On root stage r its transition has matrix a_ji^(1/Q^(r+1)).
Power renaming identifies this transition with F, fixing R and keeping
one, unrooted, volume line. In a buffered polydisc Cech computation
the monomial contraction preserves the Gauss norm and leaves exactly
the all-negative principal parts in degree m. Modulo a fixed positive
valuation cutoff only finitely many monomials remain. Every surviving
principal part therefore has one finite root denominator. Positivity
of a_ji makes the root coefficient limit zero on x=0; on x!=0 the
finite etale trace identification gives the actual cover coefficient.
Localization identifies this with extension by zero.

For compact parameters use a finite clopen approximation at the same
cutoff. Compact analytic group directions are replaced by their
bounded finite projective resolutions, so both the support colimit and
the root colimit pass through those directions. Their underlying
profinite F_5-vector exact sequences split continuously; derived
scalar extension therefore preserves the augmentation as well as
the finite free retracts. The common torsor
double nerve, residue, and group duality give

    (colim_(S^vee) H^i(P_n,P)^vee) tensor R
      = H^(m+n^2-i)(U, RΓ_c(Z,Acal) tensor <eta>).

This construction uses compact P, not B_U, and no finite-dimensionality
of either cohomology group. Its transpose-Frobenius identity is needed
here; the stronger compatibility with the prescribed xi_i is not
deduced in this argument.

The right side has bounded almost length. One can check this directly
in the only ranks needed here. Compact supports of a j-plane N_t^j
are its one-dimensional F_5 orientation line tensored with R in
degree (t+2)j. To see the extra tj degrees, exhaust the affine lift by
bounded discs modulo 5^(-r)O_(Q_(5^t))^j. Affine compact supports give
degree 2j. Lattice corestriction in degree a multiplies by
5^(tj-a), leaving only a=tj in the colimit. Its character on
GL_j(Z_5) is det^(-t), the inverse Q_5-determinant on
the underlying Q_(5^t)-space.

For m=1, the zero plane and ambient plane give degrees 1,t+2.
For m=2,t=1 the finite incidence resolution has support cohomology
in degrees 2,4,6: respectively the Steinberg quotient on P^1(Q_5),
the rational-line induction with its orientation, and the ambient
line. The Steinberg quotient retains its two-term flag resolution.
This is an actual supported incidence resolution. On a finite clopen
Grassmannian chart, bounded relation witnesses in Q_(5^t) lie in a
compact ball. Their incidence projection is proper, and its
generalizing closed image is the dependent locus. On each actual
rank stratum the unique smallest plane varies continuously; adding
that plane contracts the same tube and parameter complexes.
Thus the contraction is not merely a geometric-point rank test.
At each compact open U, Shapiro reduces these terms to finitely many
compact parabolic stabilizers with finite line coefficients. Their
finite projective resolutions give bounded almost length. Fixed
admissible extras have finite filtrations after their permitted
finite marking/translation ascents; the same calculation with those
finite factors has the same finiteness property.

Thus colim_(S^vee) H^i(P_n,P)^vee is finite dimensional: any r
independent vectors contribute almost length r after tensor with R.
Its compact dual is lim_S H^i(P_n,P). Projection from this limit
surjects onto I^i by the nested compact-preimage argument. This proves
I^i finite. In particular, we have not assumed that S is injective on
an infinite-dimensional stable image.

## 3. Compact finiteness, including the actual height-two obstruction

A strip between two fixed pole bounds has finite total cohomology
once compact finiteness at higher starting height is known. Factor x
by the labelled identity in Section 2, and filter the strip by
successive dead-label restrictions and their conormal powers.
Each is the earlier higher-height compact problem. Transverse
truncation gives continuous module sections. The same reasoning
applies to every fixed finite associated translation coefficient.

Put M^i=H^i(P_n,P), X^i=H^i(P_n,B_U). The map M^i->X^i has countable
kernel and cokernel, by the countably many pole strips. Its kernel is
locally S-nilpotent: a primitive has one pole bound, which transfer
eventually carries into P. No primitive with unbounded poles is used.

We use the following compact operator fact. If compact M/SM and
intersection S^a M are finite, S has finite kernel and cokernel.
Indeed, after the finite stable part is removed, S^a M shrinks
uniformly to zero. Successive division by S from lifts of a basis of
M/SM gives a continuous surjection k[[z]]^r->M, z acting by S.
Its z-power torsion is finite. For any intertwining map f:M->X
with locally S-nilpotent kernel, this proves that ker f is finite
and that

    intersection_a image(S^a M -> X) = f(intersection_a S^a M).

The last equality uses the finite closed fiber and nested compact
sets, not an unjustified interchange of image and intersection.

At t=1, constants split in the diagonalizable translation torsor.
For a stationary exponent Q fixing k, the actual maps satisfy
S^r Phi_(Q^r)=1, where Phi(f)=f^(Q^r). On one sufficiently positive
source lattice, powering places the representative in P before
arbitrarily many target transfers. It is the original compact class,
so lies in the finite stable intersection of Section 2. Its
localized complement is countable by the strip argument. Therefore
X^i is countable. Then M^i is countable and compact, hence finite
by Baire. This proves compact (2,1) from (2,2), and compact (3,1)
once compact (3,2) is known, for all the indicated extras.

It remains to prove compact (3,2); this is not multiplicative height.
Here m=d=1 and Lambda=k[[D]]. On finite nilpotent modules the
associated-bundle cochain functor is exact on terms and bounded by
degree nine. Work modulo countable-dimensional spaces, simultaneously
at a cofinal sequence of finite frame levels. Germs mean agreement
after a finite initial segment; exactness has its termwise meaning.
Denote the resulting delta functor by T^i.

The inverse regular system Lambda/(D^q), with Hopf transfer, gives
the stationary pro object (...->S X^i->S X^i), denoted Tbar^i(Lambda).
The one-variable free resolution

    0 -> Lambda --D--> Lambda -> k -> 0

is pro exact. Descending induction in i shows that Tbar^i(Lambda)
is constant and augments monomorphically to T^i(k). Here are the
details that make the frame index uniform. If constancy is known
in larger degrees, the image of augmentation is the kernel of a
map between constant objects, hence constant. It is represented
by the decreasing inclusions S^a X^i in X^i. A decreasing pro
subobject of a constant object that is itself constant stabilizes
at one finite pro index: its quotient by that constant image is
pro zero, and its transitions are monic. Thus S^h X^i/S^(h+1)X^i
is countable at every sufficiently deep frame level, for one h.
For M=S^h M^i the strip comparison makes M/SM countable. It is
compact, hence finite by Baire. Section 2 and the compact operator
fact make S invertible on this stabilized image modulo countable
spaces. This proves constancy and the monic augmentation.
D acts trivially, by Lambda-linearity of the augmentation.

Suppose b is the highest degree with T^b(k)!=0. Finite nilpotent
coefficients have no higher such degree, by their finite k-filtrations.
Augmentation Tbar^b(Lambda)->T^b(k) is now also epic. At a single
sufficiently deep frame level the compact operator fact consequently
gives a finite space

    I_X = intersection_a image(S^a M^b -> X^b).

For every allowed s>0 the two-column resolution of N_s=Lambda/(D^s)
has zero differential on vertical Tbar-cohomology. There is no higher
two-column differential. Its left edge gives an epimorphism

    e_s : T^(b-1)(N_s) -> T^b(k).

This is the actual generator of Ext^1_Lambda(N_s,k). Coinducing the
fundamental extension 0->k->N_2->k->0 to root exponent q gives
0->N_q->N_(2q)->N_q->0. Pull back by the actual upward inclusion
N_s->N_q, 1 |-> D^(q-s), and push out by augmentation N_q->k.
Lifting between the free resolutions has degree-zero multiplier
D^(q-s) and degree-one multiplier 1, since

    D^s D^(q-s) = D^q.

The resulting Ext coefficient is exactly 1; normalized Hopf frames
can multiply it only by an element of k^times. In particular it is
not the zero operation. Replacing the inclusion by an extra D would
make that coefficient zero and is not allowed.

All q must be compared at one frame. Fix the endpoints N_s,k and a
pro-5 auxiliary subgroup U defining the two finite extensions.
The forgetful Ext^1 kernel is a subquotient of
H^1(U,Hom_Lambda(N_s,k)), hence finite; Ext^j_Lambda(N_s,k) has
dimension one for j=0,1. Every element of that kernel vanishes
on an open subgroup: a zero-comparison of the underlying finite
Yoneda extension uses finitely many torsion modules and maps,
which are fixed on a sufficiently small subgroup. Intersect
over the finite kernel. The resulting U' works for every q.
No growing N_q is required to have trivial U'-action.

Choose a positive source lattice x^a L_s. In the actual coinduced
operation there are fixed input/output losses c_in,c_out, from
the finite source basis and the fixed fundamental extension and
its module sections. At root level q=Q=5^(2*l) its output order
before the final transfer is at least

    Q(a-c_in)-c_out.

Choose a>c_in once. This tends to infinity. The final normalized
Hopf transfer is an arbitrarily high stationary iterate of S.
Uniform equivariant equality of the Ext operations therefore
places the e_s-image of every such source class in I_X.
The remaining source quotient is countable by the strip argument.
The edge image is countable, contradicting its epimorphic image
T^b(k)!=0. Thus all X^i are countable; compactness and Baire make
all M^i finite. This proves compact (3,2) without assuming ordinary
finiteness or repeating the accepted finite Fitting cutoff.

We also justify the admissible extras used in this induction.
After their permitted finite frames, trivial filtration factors
reduce to the function calculation. At height greater than one,
finite translation representations have trivial factors. At
height one, a character is a summand of the regular representation
of a finite diagonalizable quotient, hence of a finite root ring.
Powering transports that ring and all its actions to functions
at a deeper marking level; the argument does not apply an
undefined power map to an arbitrary module. Finite marking descent
and translation bar descent add only finite sums or fixed tensor
powers of torsion-coordinate factors with trivial P_n-action.
Their module sections preserve common pole bounds, and finitely
many terms occur in each total degree. Thus localized extra
cohomology is countable; its compact version is countable by the
strip comparison and finite by compactness. Its intrinsic analytic
cohomological-dimension bound makes total cohomology finite.

## 4. The completed earlier height-two stage, without coefficient completion

At (3,2) the height-support filtration has only its terminal row
H^1_(x_2)(C_1). Residue and orientable P_3-duality identify its
cohomology with the dual of compact cohomology of the canonical
dual coefficient. Section 3 applies to that compact extra.
The localization triangle now proves finite total ordinary
cohomology of C_1[1/x_2] tensor omega^e.

Finite leading connected frames are tame invariant-line twists.
Subsequent deep frame covers have finite 5-group deck groups,
whose regular representations have finite trivial-factor
filtrations. Finite torsor descent supplies every other finite
frame. Each sequence splits on underlying localized modules and
has a common cleared pole bound on a compact source. Thus every
ordinary finite-frame B_U at (3,2) has finite total cohomology.

We need the full-frame rows, not just this assertion. Form Dcal from
algebraic dual finite root/regular-representation complexes, with
transpose Hopf transfer and transpose frame trace. Finite torsor
regular-module descent gives

    RΓ(K x V, RΓ(T_h,Dcal)) = C(P_3,B_(K,V)^(h))^*.

Termwise translation injectivity follows by testing finite
comodules against the exact associated-bundle functor.
Finite tests suffice because every vector in a rational
representation lies in a finite subcomodule. Finite deck
projectivity gives frame acyclicity. These statements concern
full algebraic duals; a continuous/algebraic dual identification
is made only for the already finite compact cohomology.

Apply the accepted finite stable-image theorem now, after Section 4
has proved its finiteness premises at (3,2), and the bare support
comparison of Section 2. After forgetting translations,

    Dcal tensor R = RΓ_c(N_2-{0},Acal) tensor <eta>[10].

A scalar a in 1+5 Z_5 fixes these support cohomology rows.
Its conjugation of translations is [a] or [a^-1]. The formal
identity [a-1](z)=F([a](z),[-1](z)) implies that one T_h
annihilates every cohomology row. This h depends on a, not the
row or frame. Translation cohomology then has only degrees
0,1, with degree-one factor (D)/(D^2)^vee.
V-cohomology of these rows is finite, by their support flag
calculation and Shapiro. Taking inverse limits of K-cohomology
with corestriction leaves only degree dim(P_2)=4: dual
restriction to deep groups kills every positive degree
normalized finite-coefficient cocycle. All intermediate terms
are finite over finite k, so this bounded spectral sequence
has no inverse-limit defect. Trace descent proves that
H^*(P_3,B_conn,V) is finite. The same bounded filtration gives
one open scalar subgroup acting trivially on full-frame
cohomology, uniformly in V and in root stages.

For the required perfected individual rows it matters that root
inclusion is not transfer. With N_q=Lambda/(D^q), its upward
map is multiplication by D^(q'-q). The Koszul lift has degree
zero multiplier D^(q'-q) and degree-one multiplier 1.
On translation-trivial rows it consequently kills degree zero
and preserves degree one. Bounded filtrations kill the unwanted
pieces after a bounded number of transitions; no derived
equivariant splitting is required.

Let Delta=F_25^times in P_2. On the fixed Honda group, a in
Delta has Lie character a and the complementary covariant
Hodge cotangent character a^5 (the two unramified
Dieudonne eigenspaces). Degree-one translation Ext is the
dual character a^-5. The single retained volume has character
a^-1. Their product is

    a^-1 a^-5 = a^-6 = Norm_(F_25/F_5)(a)^-1.

Plane orientations are defined on one-dimensional F_5 spaces,
so their P_2 characters are also norm powers. Hence
Delta^0=ker(Norm), of order six, acts trivially after the root
limit. Exact character projections show this on the connected
cohomology at every V. Taking the algebraic union in V first,
then applying the finite V resolution, proves it on the
individual rows, not merely a total spectral-sequence abutment.

To see their finiteness without that invalid inference, dualize a
bounded smooth V-complex C. Over the local Noetherian ring
Omega=k[[V]], finite derived reduction of C^vee implies that each
cohomology module of C^vee is finitely generated. Indeed lift
generators in the highest degree by compact Nakayama, cone off
a finite free module, and continue downward; kernels in finite
free modules are finitely generated. Finite-rank resolutions
then give finite Tor, and hence finite H^a(V,H^i C). Apply
this to the perfected full frame. At a fixed V every root
stage is a power transport of the same connected calculation,
so its total dimensions are uniformly bounded. The algebraic
root union therefore has finite total V-cohomology, as required.

Thus every actual row

    Q=H^a(V,H^i(P_3,B_full,2^perf))

is finite and has Delta^0 acting identically. Its P_2^1 image
is a finite normal 5-group. Filter by powers of its nilpotent
augmentation ideal; the quotients split into Delta characters
trivial on Delta^0. Refining gives one-dimensional norm-power
composition factors for the full P_2 action, not just its tame
restriction. This is exactly the height-two input needed next.

## 5. The actual height-two boundary of (3,1)

Compact (3,1) is now proved by Section 3. Its localized support has
two rows:

    s=2: H^1_(x_1)(C_1)[1/x_2][-1],
    s=3: H^2_(x_1,x_2)(C_1)[-2].

The s=3 row is finite by compact P_3 duality and the canonical
compact extra, as before. We prove finiteness of the s=2 row.

At a fixed nilpotence order, take a connected Honda height-two
marking and a basis for the surviving rank-one etale group.
The marked deformation has parameter ring R'=k[[v]].
Apply display lifting successively across square-zero ideals,
with trivial nilpotent divided powers. In dimension one its
Hodge tangent has rank one. The universal Kodaira--Spencer
isomorphism identifies the parameter-lift and Hodge-lift
torsors. For this comparison one may use the crystalline
definition kappa'=(id tensor pi) connection i, so both tangent
actions are the same lifted-Hodge-filtration action; a
comparison between two unspecified torsor conventions is not
assumed. Zink's morphism-lifting criterion and full faithfulness
apply: the reduction is reduced and the remaining nilradical
has the fixed nilpotence order. Nilpotent rigidity makes the
marked isomorphism unique and equivariant.

Orient that isomorphism by h [5]_original=[5]_universal h,
and set c=h'(0). Comparing the coefficient of X^5 gives

    x_1 = c^4 v modulo the square of the transverse ideal.

The coefficient is a unit. Before marking the transverse
parameter is regular; finite etale marking is flat. This
unit conormal change identifies every associated graded
layer with the corresponding v-layer. After adjoining the
compatible surviving lifts, put R_N=k[v]/v^N and E_N for
the resulting algebra without the extra labelled C_1.
The further finite lift steps are free, and their filtered union
preserves flatness. Thus E_N is flat over R_N and E_N/v E_N=S,
where S=B_full,2^perf is perfect.

Here the Artin splitting is proved, not replaced by a completion.
For q=5^a fixing k and killing the nilpotent kernel by qth powers,

    sigma(z) = (any lift of z^(1/q))^q

is independent of the lift. The characteristic-five power
identities make it a ring section. It is the unique section:
any other section applied to the qth root has the same qth
power by nilpotence. Thus it is functorial and k-linear.
Flatness identifies gr(E_N) with gr(R_N) tensor_k S, so

    R_N tensor_k S -> E_N,    r tensor z |-> r sigma(z)

is an isomorphism on the finite filtration and hence an
isomorphism of algebras. This is the algebraic tensor
product with the finite-dimensional Artin factor R_N, never
a completed infinite parameter product.
Flatness is essential to this last assertion.

Pulling back the remaining labelled coefficient over this split
kernel gives finitely many components of the finite free R'-algebra

    M=C_1^(2,1) tensor_(R') O(Gcal[5]/ker F).

Indeed the images of a full tuple in the constant surviving
F_5-line must span, by applying the norm identity to idempotents.
Choose a constant basis adapted to that surjection. The remaining
tuple is a full set on the connected divided kernel; the free
choice of one lift supplies the displayed O factor. This norm
identity works over R_N with nilpotents, not just at points.

Consequently the intermediate local coefficient is

    S tensor_k H^1_(v)(M),

with its fixed invariant-line twist included. P_3 acts on S
only. Deep relative translations are trivial on the resulting
P_3 rows by the uniform scalar subgroup from Section 4.
Their relative distribution algebra is R_N[[D]], and its
augmentation Koszul complex gives V0 and
V0 tensor_(R_N) (D/D^2)^vee in degrees zero and one for any
translation-trivial R_N-module V0. This computation uses no
flatness assumption on V0.

After small surviving matrix-group cohomology the individual
terms therefore have the form

    Q tensor_k H^1_(v)(M tensor F),

where Q is an actual finite norm-filtered row of Section 4
and F is a finite free torsion-coordinate/Lie/invariant-line
construction on the universal smaller deformation. The
remaining P_2 computation is dual to

    H^(4-b)(P_2, Q^vee tensor
        Hom_(R')(M tensor F, omega_(R'))).

The Hom coefficient is an admissible compact coefficient at
(2,1): finite duality rewrites it over C_1^(2,1), and finite
torsion, Lie, volume and conormal frames on each labelled
boundary give its required finite split filtrations.

Its tensor factors from Q^vee are also admissible; this
requires the actual norm line, not an arbitrary P_2
representation. The determinant p-divisible group
exterior^2 Gcal has height and dimension one, including on
finite truncations. Its Cartier dual is etale over henselian
k[[v]], hence is the unique constant lift of its marked
special fiber. The induced P_2 action on the top exterior
Dieudonne line is Nrd, by its defining determinant identity
over a splitting field. Rigidity extends that same action
over the parameter ring. The dual invariant differential
is thus the constant norm character. Its finite first
truncation supplies a permitted finite frame on every
boundary stratum. Norm powers and their duals preserve
admissibility. Compact (2,1), proved in Section 3, makes
each displayed complementary-degree group finite.

Forgetting the finite relative translation quotient uses its
augmented bar construction. In degree q it adds q torsion
factors of one fixed finite order to F; it does not replace
Q by an arbitrary representation. All bar degrees and group
degrees are nonnegative, with the single fixed local shift
-1. Only finitely many contribute to a given total degree.
This proves finite-dimensionality in every degree at the
original intermediate row. Its intrinsic P_3 bound is nine,
so its total cohomology is finite.

All maps in this descent respect the literal cochain convention.
At fixed connected torsion order 5^r, the augmentation ideal
modulo v has nilpotence order 5^(2r). On the Nth thickening its
order is at most N*5^(2r): the 5^(2r)th power belongs to (v),
whose Nth power is zero. Only finitely many Taylor coefficients
of a marking can therefore enter any fixed torsion diagram.
At fixed N a finite projective marking presentation e_N A_N^r
has additive section z |-> e_N tau(z), where tau is transverse
truncation. Extracting the finitely many parameter layers uses
the inverse unit conormal coefficient and monomial division.
These matrices, the finite torsion bases and their products
have one cleared denominator. The section sigma moves a
given input to one further finite root stage; its powers have
one finite pole bound. These bounds may depend on the fixed
N and the fixed diagram, never on a point of the compact
source. Passing to the local-cohomology union lets each
cochain choose such a single N. There is no assertion of a
single finite stage for an entire infinite marking series.

Both support rows are now finite. The finite support filtration
and localization triangle prove finite total cohomology of
C_1[1/x_1] tensor omega^e. The tame-line decomposition,
finite 5-group regular filtrations and finite torsor descent
used in Section 4 give every finite joint frame U at (3,1).
All output degrees lie in [0,9]. This proves the theorem.

## 6. What this adds, and what it does not add

The strongest preceding result was a finite-cutoff/corestriction
implication with ordinary finiteness as a premise. The present
argument discharges that premise: its key nonmultiplicative step
is the explicit one-variable Ext operation at (3,2), followed
through the full/perfected height-two norm rows and the smaller
(2,1) compact calculation. None of those steps is inferred from
the accepted conditional cutoff or a finite matrix experiment.

The new exact checks distinguish the root inclusion from transfer,
check the nonzero Ext coefficient and the tame -1-5=-6 norm
character, and test the Artin splitting and its missing-hypothesis
controls. `finiteness/Main.lean` gives universal algebraic proofs
of the nilpotent-section and Koszul identities. Independent review
of this new mathematical proof and the newly recorded primary
source hypotheses is required. The specified xi_i transport,
the stronger ordinary comparison coherences, publication novelty,
and the full campaign conclusion are not asserted here.

Replay only the new diagnostics, without redoing the accepted rounds:

    PYTHONDONTWRITEBYTECODE=1 python3 research/coheight-two-unit/verify.py --finiteness-only

The nonflat control is R=k[epsilon]/epsilon^2 mapping to E=k:
the canonical section exists but R tensor_k k->E has rank one,
not two. For a nonperfect fiber k[t], the five maps
t |-> t+c epsilon give distinct ring sections. These controls
explain exactly where flatness and perfectness enter; they do
not refute manuscript assertions that contain both hypotheses.
