# Finite-cover transfer and full fixed-determinant curious Lefschetz

## Result and scope

**Verification theorem (prose).** Let g >= 2, let n >= 4 be composite,
and let gcd(n,d)=1. With the objects and class e of the staged manuscript,
H*(X^B,Q) is Hodge--Tate, e has nonzero image in Gr^W_4 H^2, and

    e^i : Gr^W_{2R-2i} H^m(X^B,Q)
       -> Gr^W_{2R+2i} H^{m+2i}(X^B,Q)

is an isomorphism for every i >= 0 and every m, where
R=(n^2-1)(g-1). This is the literal assertion `betti:lefschetz`,
not its Gamma-invariant restriction. The proof below derives it using
Mellit's published geometric inputs and supplies the finite-etale transfer
argument independently, including integral local constancy and the
*natural* ordinary base-change map.

The additional structural result is the finite-cover transfer theorem
below, with a deck-equivariant description of its strata. `verify.py`
certifies its universal Koszul contraction and weight-center identities,
and independently replays one deliberately disconnected Kummer example.
It does **not** machine-check algebraic geometry, mixed Hodge theory, or
the whole theorem. No Lean formalization is asserted. Independent Reviewer
acceptance and a literature-based novelty judgement remain separate;
neither is supplied by the Engineer.

The strongest prior result used for comparison is arbitrary-rank GL_n
P=W, together with the prime-rank SL_n reduction. Those results alone
leave composite-rank variant cohomology untouched. The improvement here
is a proof on the *cover itself*, before any invariant projector, followed
by the scalar-flag and determinant-factor extractions. This does not
verify the manuscript's separate common-lowering-operator construction,
and therefore does not independently establish its full P=W theorem.

## 1. The geometric inputs actually available

Put b=n(n-1)/2. Let V be the determinant-one ordered eigenvalue torus
with all proper nonempty subproduct-one loci removed. The point
q=(zeta,...,zeta), with zeta a primitive n-th root, belongs to V.
This is a nonempty smooth open subset of an irreducible torus; it is
connected and analytically path connected. Its distinct-eigenvalue locus
is nonempty.

The following are *published inputs*, not conclusions of the executable
certificate. They are the statements read at the indicated locators in
Mellit, doi:10.1007/s10240-025-00158-0:

1. At a generic distinct-eigenvalue parameter, the ordered GL_n space
   has an auxiliary vector bundle of rank b with a finite closed
   filtration. Its final pieces are vector bundles over affine spaces
   times tori. The restrictions of one degree-two class satisfy
   compact-support curious Lefschetz on all pieces, with common middle
   **actual weight** delta+2b, where delta is the dimension of the
   original fiber. See Theorem 6.14, Sections 7.2 and 7.4, Theorem 7.5,
   and the gluing principle of Proposition 2.19.
2. The smooth *flag-enhanced* ordered family over all generic V has an
   auxiliary affine bundle of rank b. It has a finite closed filtration
   whose final pieces are vector bundles over
   A^a x (C*)^s x V, with structural map the projection to V.
   See the proof of Proposition 8.7. Its torus splitting uses the
   saturated cocharacter image ker(Z^n -> Z) from Proposition 6.10.
   The family allows nonsemisimple last monodromy at collisions.

Here is the exact match to the manuscript, not just a dimension match.
Choose two punctures, the first with monodromy zeta^-1 I and the last
with monodromy zeta nu^-1, where nu is the product of commutators.
The product relation is nu zeta^-1 I zeta nu^-1=I. The last ordered
diagonal is lambda_i=zeta t_i^-1. For a selection I of r eigenvalues,
the genericity test in Mellit Definition 4.9 is

    (zeta^-1)^r product_{i in I} lambda_i
      = product_{i in I} t_i^-1 != 1  (0 < r < n).

Thus it is exactly the defining subproduct condition of V, including
multiplicities. "Nicely ordered" means equal fixed eigenvalues occur
in consecutive blocks. It holds for the scalar first puncture and
the distinct last diagonal in input 1. Input 2 does not impose
distinctness on the moving last diagonal. Passing to its inverse
preserves a flag and replaces its ordered diagonal by the ordered
inverses, so the flagged families agree also at collisions.

**Retired route.** A collision-only objection confuses input 1 with
input 2 and is not a refutation. Published Proposition 8.7 is numbered
Proposition 8.4.1 in arXiv:1905.10685v1. A numbering mismatch is not
a counterexample either. These facts were recorded before developing
the transfer proof. See `literature/known_inputs.md`.

## 2. A finite-etale torus-stratum transfer theorem

Let f:T -> S be a smooth separated algebraic family of relative complex
dimension delta over a smooth complex base. Suppose an auxiliary
complex affine bundle E -> T of rank b has a finite closed filtration
whose differences are vector bundles over A^a x (C*)^s x S, by
projection. Allow different a,s and vector-bundle ranks on different
pieces. Suppose, at one specified parameter, a possibly different
rank-b auxiliary bundle has such a finite filtration on which the
restrictions of one class satisfy compact-support curious Lefschetz
with a common middle actual weight delta+2b.

For **any finite etale cover** p:T' -> T:

* Every fiber of T' is Hodge--Tate.
* R^j f'_! Z and R^j f'_* Z are locally constant finitely generated
  abelian groups; the natural ordinary base-change morphism is an
  isomorphism at every point.
* At the specified parameter the pulled-back class satisfies ordinary
  curious Lefschetz with middle actual weight delta.

There is no connectedness hypothesis on the inverse images of pieces
and no passage to invariants. If the cover is Galois with group G,
on every individual piece F there is a canonical G-equivariant
identification

    H^j(p^-1 F,Q) = Q[pi_0(p^-1 F)] tensor H^j(F,Q).

The analogous statement holds with compact supports. The action on
the second factor is trivial. This formula describes the whole
representation, not just its fixed subspace.

### Proof on one piece

Let F be a vector bundle over A^a x (C*)^s. Projection and zero section
give pi_1(F)=Z^s and identify its rational cohomology ring with the
exterior algebra on Hom(Z^s,Q). Each connected component F' of a
finite etale preimage corresponds to a finite-index subgroup
L <= Z^s. Both spaces are aspherical up to the contractible affine
and vector-bundle fibers. The pullback in degree one is restriction

    Hom(Z^s,Q) -> Hom(L,Q),

an isomorphism because L tensor Q = Q^s. The same holds in every
exterior degree. These maps are algebraic pullbacks, hence
isomorphisms of rational mixed Hodge structures as well as rings.
In particular F' is Hodge--Tate.

Write D=dim_C F. Finite proper pushforward on compact supports is
dual, under smooth Poincare duality, to ordinary pullback. It is
therefore an isomorphism over Q. Its composite with finite pullback
on compact supports is deg(F'/F) times the identity, so that
compact-support pullback is an isomorphism too, including its mixed
Hodge structure. It commutes with the pulled-back Lefschetz class.

These are **rational**, not integral, isomorphisms. An integral
finite-index lattice inclusion need not be unimodular. No integral
cohomology isomorphism is used anywhere below.

All components are kept as a direct sum. Deck transformations commute
with the pullbacks just described. Under those identifications they
act by permutation of the components, proving the displayed
G-equivariant formula. They act trivially on cohomology of a component
they stabilize; this also follows from its torus-translation model.

Pulling back a finite closed filtration again gives a finite closed
filtration. Compact-support localization sequences are sequences of
mixed Hodge structures. Their maps are strict for weights, so weight
gradeds remain exact. Compare the two exact sequences using a fixed
power of the common class, with cohomological shift 2i and actual
weight shift 4i. All adjacent terms have the same middle weight,
so the five lemma inductively gives the Lefschetz isomorphisms on the
whole auxiliary space. Hodge--Tate structures are closed under
subobjects, quotients and extensions, proving its Hodge--Tate property.

The bundle trace gives

    H_c^j(E'_t,Q) = H_c^{j-2b}(T'_t,Q)(-b).

It shifts degree and actual weight by 2b. The compact-support middle
weight on T'_t is therefore (delta+2b)-2b=delta. Poincare duality
for the smooth delta-dimensional fiber reflects actual weights by
w -> 2delta-w. Thus the ordinary middle weight is again delta.
The all-parameter relative stratification and the same bundle trace
prove Hodge--Tate cohomology on every fiber, not just the specified one.

### Integral local constancy, without assuming properness

Take a sufficiently small contractible analytic open U in S.
A vector bundle over F_0 x U is topologically isomorphic over that
base to the pullback of its restriction over F_0 x {u_0}: this is
homotopy invariance of complex vector bundles on paracompact spaces.
A finite cover of its total space is likewise pulled back in the
U direction, by covering-space classification and
pi_1(F_0 x U)=pi_1(F_0). Thus the covered relative piece has
locally constant finitely generated integral compact-support
cohomology. The complex orientation makes the bundle Thom system
constant; no orientation local system is omitted.

Localization through the finite closed filtration gives the same
conclusion for the covered auxiliary family. Kernels and cokernels
of maps of local systems are local systems. Extensions are locally
constant here as well: locally their only algebraic extension data
are Ext^1_Z of the finitely generated stalks; the constant-sheaf
higher-cohomology terms disappear on a smaller contractible open.
The affine-bundle trace removes its degree shift. Consequently

    K = R f'_! Z

has bounded, locally constant, finitely generated cohomology.
It is a locally perfect complex: on a sufficiently small contractible
open, the truncation extensions in degrees at least two vanish
(Z has global dimension one), and each finitely generated stalk
module has a finite free resolution. This assertion is local,
not a claim that K splits globally.

Smooth oriented relative Verdier duality gives the natural
identification

    R f'_* Z = R Hom(K,Z_S)[-2delta].                 (1)

For the coefficient-sensitive reference, use Verdier, Bourbaki
expose 300, Section 3, equation (3.3) and its theorem, printed
pp. 343--344, with Section 5, equations (5.1)--(5.2), p. 348.
The coefficient ring in Section 1 is any commutative ring, so
Z is allowed. Smoothness is local submersivity in the sense used
there. On a complex coordinate ball the relative compact-support
cohomology is Z in degree 2delta; complex orientation trivializes
the resulting orientation sheaf. This identifies f'^! Z_S with
Z[2delta] and gives (1) from the sheaf-valued relative duality
isomorphism. Finite-type complex fibers have bounded cohomological
dimension, as required in that source. This is derived integral
duality: it retains Ext^1_Z terms when cohomology has torsion.

Derived stalk of the right side is the derived Z-dual of the stalk
of K, because K is locally perfect. Compact-support base change
identifies that stalk with R Gamma_c(T'_t,Z); oriented Poincare
duality then identifies its shifted dual with R Gamma(T'_t,Z).
This proves ordinary local constancy.

It also proves the **natural** base-change assertion, not merely
an abstract isomorphism of groups. Indeed (1) is adjoint to the
relative cup pairing followed by the orientation trace

    R f'_* Z tensor R f'_! Z -> Z_S[-2delta].

The trace and pairing restrict to the fiber trace and pairing under
compact-support base change. Hence, after taking the stalk of this
adjunction, the map to R Gamma(T'_t,Z) is exactly the usual restriction
base-change morphism. The perfect duality identification shows that
this very map is invertible. No smooth *nonproper* ordinary
base-change theorem has been invoked. This proves the transfer theorem.

## 3. Application to the determinant-root cover

Let D_1=(C*)^{2g}. Multiplying the SL_n matrices by chosen scalars
identifies

    Y^B x D_1 -> Y^B_GL

with the pullback of (z_1,...,z_{2g}) -> (z_1^n,...,z_{2g}^n)
along the determinant coordinates. Division by these chosen roots
is the inverse identification. It preserves commutators and flags
and commutes with conjugation, so it descends to the geometric
quotients. This is a finite etale torsor of degree n^{2g}.
Its deck action is free even when an SL_n tuple has a scalar-twist
symmetry, since the accompanying root coordinate in D_1 moves.
Its action on the D_1 cohomology factor is trivial, since scalar
translations of a complex torus are homotopic to the identity.
Thus, under Kunneth, the cover's deck-character decomposition is
the full Gamma-character decomposition on the SL_n factor,
tensored with H*(D_1), not its invariant quotient.

Irreducibility follows from the proper-subproduct condition: an
invariant proper subspace has commutator determinant one, whereas
its eigenvalues select a forbidden proper submultiset. Thus the
quotients are geometric with free PGL_n action.

The relative dimensions are

    dim Y^B_t = 2R+2b,
    delta = dim(Y^B_t x D_1) = 2R+2b+2g.

Applying Section 2 to the two actual auxiliary stratifications gives
regular-semisimple ordinary Lefschetz center delta/2=R+b+g on the
cover, all-fiber Hodge--Tate cohomology, integral local constancy,
and natural ordinary base change.

The same local-constancy and base-change assertions hold for Y^B.
For ordinary direct images, projection p and the identity section s
of D_1 give s* p*=id, a retraction compatible with restriction to
fibers. For compact supports, the closed section Gysin map has
degree 4g and integration over D_1 has degree -4g; their composite
is the identity by the complex orientation trace. Thus the
unshifted direct image for Y^B is a summand of that of the cover.
The ordinary fiber retraction is algebraic, so its Hodge--Tate
assertion descends too.

### Every deck character, including those from disconnected pieces

On a torus-affine vector-bundle piece, determinant coordinates are
invertible regular functions. They are constant along affine
fibers, and hence are constants times torus monomials. Let
M:Z^s -> Z^{2g} be their exponent matrix. With
G=(Z/n)^{2g} and H=im(M mod n), the lifted piece has |G/H|
components, each covering with degree |H|. Over C its character
summand is

    H^j(p^-1 F,C)_chi =
      H^j(F,C)  if chi|_H=1,
      0          otherwise.                         (2)

The cochain version of (2) is the Koszul complex on
a_j=chi(M_j)-1. If all a_j vanish its differential is zero.
This decomposition uses the Fourier basis of C[G]: its basis
property follows directly from the finite geometric-series
orthogonality of characters of (Z/n)^{2g}.
Otherwise choose a_j != 0 and write the exterior complex as
Lambda(V') direct-sum e_j wedge Lambda(V'). Its differential and
contracting homotopy have blocks

    D = [[d',0],[a_j,-d']],   h = [[0,a_j^-1],[0,0]].

The exact identity D h + h D = I proves acyclicity for every
nontrivial restricted character, in every dimension and for every n.
The identity is verified symbolically over Q[a,a^-1,d] by
`verify.py`; d' may be any endomorphism, and in a complex d'^2=0.
This universal identity, not a finite sweep, is the executable
algebraic core of the component/character argument.

For illustration and adversarial replay, the certificate also uses
n=4, g=2 and

    M = [[1,1],[1,-1],[0,2],[2,0]].

The cover has degree 256, monodromy image of order 8 and **32
components**. Exactly 32 characters survive, including 31 nontrivial
ones. The other 224 complexes have individually checked exact
contractions over Q(i). The component lattice has column basis
[[2,0],[2,4]], determinant 8. Its ordinary Betti numbers are
(32,64,32), not the invariant-only (1,2,1). Integral pullback is
not an isomorphism, while rational pullback is. The Jacobian adapter
returned Smith factors (1,2,4,4) for [4I_4 | M]; its full unimodular
transformations are independently multiplied out by the script.
This example tests retention of components and characters; it is
not itself a moduli-space counterexample or an all-parameter proof.

## 4. Weight-compatible transport to the scalar parameter

For a smooth algebraic morphism, mixed-Hodge-module direct image
has the usual rational constructible direct image as realization.
This is the derived-functor compatibility in Saito, *Mixed Hodge
Modules*, doi:10.2977/prims/1195171082, Theorem 0.1, p. 222.
When its ordinary cohomology is lisse, its corresponding perverse
cohomology is a smooth mixed Hodge module. On a smooth base of
dimension v, the object giving H^j is perverse degree j+v, followed
by shift -v. Saito's smooth-module/variation correspondence gives
an admissible graded-polarizable variation. See Saito,
*Extension of mixed Hodge modules*, Section 3.2, equation (3.2.1),
primary text at `literature/saito_extension.pdf`, p. 226.
Natural base change from Section 2 identifies its fiber with the
ordinary cohomology of the actual algebraic fiber, with its usual
mixed Hodge structure.

In particular weights are sub-local systems, and cup product is a
parallel morphism. Transport the regular-semisimple weight-four
class along any chosen path in V to q. It yields

    omega in Gr^W_4 H^2(Y^B_q x D_1,C)

with center R+b+g. A global absolute degree-two class is not needed.
Indeed Mellit Section 8.5 explicitly distinguishes flatness modulo
W_2 from flatness of the entire class. The argument transports the
weight-four image, so it makes no stronger flatness assertion.
The deck transformations are algebraic over V, hence commute
with this transport. The initial class is a pullback and is deck
invariant, so its transported class and the resulting Lefschetz
maps are deck equivariant.

## 5. The scalar correspondence on full cohomology

Here are the geometric checks, including the sign. Put
nu=product [A_j,B_j]. The commutator-product map to SL_n is a
submersion at an irreducible tuple. For one pair a,b', set
c=ab'a^-1 b'^-1. The right-translated differential has coefficients

    (1-Ad_{ab'a^-1})u,  (Ad_a-Ad_c)v.

Under the trace pairing, an annihilator z is fixed by ab'a^-1
and satisfies Ad_{a^-1}z=Ad_{b'}z. It is therefore also fixed by
ab', and hence by a and b'. For the product map the testing vector
is conjugated by the preceding commutators; since the current
commutator fixes it, it is unchanged at the next pair. Thus it
centralizes all matrices. Schur's lemma and trace zero force z=0.

The variety of a flag with a matrix in its Borel is smooth over
the ordered diagonal torus, with relative dimension 2b. Pulling
back by this submersion and taking the free quotient gives smooth
Y^B -> V of relative dimension 2R+2b, also at collisions.

At q, requiring nu=zeta I gives

    X^B <-pi- Z^B -iota-> Y^B_q.

Here pi is the full flag bundle of relative dimension b. The
nilradical-valued section zeta^-1 nu-I has a transverse zero locus
Z^B. The trace pairing identifies its normal bundle with T_pi^*.
Consequently, for ordinary cohomology,

    A=pi_* iota^*,  B=iota_* pi^*,
    A B = pi_*(c_b(T_pi^*) pi^*(-))
        = (-1)^b chi(Fl_n) id
        = (-1)^b n! id.                             (3)

This uses proper flag integration and the Gysin map of a closed
regular embedding; it does not use a pushforward without a
proper/support convention. A and B have degree and actual-weight
shifts -2b and +2b respectively. All constructions are rational
and deck equivariant, including after product with D_1.

The projective universal flag has descended line-ratio bundles.
Their first Chern classes are rational algebraic Leray--Hirsch
generators: differences of roots span the flag's degree-two
generators rationally, since the sum of roots is zero on the
fiber. They have weight two. The flag has no odd cohomology.
It follows in degree two and weight four that

    pi*: Gr^W_4 H^2(X^B x D_1,C)
        -> Gr^W_4 H^2(Z^B x D_1,C)

is an isomorphism. Indeed the only extra degree-two terms come
from H^0 of the base times H^2 of the flag, of actual weight two.
Thus iota* omega = pi* xi for a unique weight-four class xi.

The projection formula shows that A and B intertwine the two
cup-product operators on weight gradeds. By (3), B is split
injective and

    H*(Y^B_q x D_1,C) = im B direct-sum ker A.

This is a graded operator-stable decomposition. Every Lefschetz
map is block diagonal, so its restriction to im B is an
isomorphism. B raises half weight by b, hence the induced xi on
X^B x D_1 has center (R+b+g)-b=R+g. The same rational splitting,
with its Tate twist, proves Hodge--Tate cohomology there.
No averaging over Gamma has occurred.

## 6. Low cohomology and tensor cancellation

For completeness, the low-cohomology input has the requisite
arbitrary-rank scope. Proposition 1.4 of
arXiv:2002.03336v1 gives, with p the smallest prime divisor of n,

    H_var^k = P_{k-c} H_var^k,
    c=n(n-n/p)(g-1) >= n^2/2 >= 8.

The normalized perverse filtration starts at zero; it follows
that variant H^0,H^1,H^2 vanish. The invariant algebra is the
rational cohomology of the PGL_n quotient. Theorem 2.1(i) of
arXiv:2209.02568v2, in its explicitly projective-bundle formulation,
says it is generated by projective tautological classes with
index j>=2. Their degrees are 2j,2j-1,2j-2. Hence H^0=Q,
H^1=0 and dim H^2<=1, with its possible generator proportional
to e. Nonvanishing follows from an ample bundle: a nonempty
projective Hitchin fiber has positive dimension R, so it contains
a projective integral curve on which this bundle has positive
degree. Thus H^2=Q e with e nonzero. The proper Hitchin geometry
and dimension calculations are the usual ones for the smooth
coprime moduli spaces, as in manuscript `norm:dimensions`;
no P=W assertion about variant cohomology is used.
The nonnegative perverse range used here follows directly from
that geometry: for Rh_* Q_X[2R], stalk degrees are <= 0 and
support dimensions are <= R, giving perverse upper degree R.
Proper duality gives lower degree -R; shifting by [-R] gives
the manuscript's normalized range [0,2R].

By Kunneth, the weight-four degree-two class on X^B x D_1 is

    xi = xi_X tensor 1 + 1 tensor xi_D;

the possible H^1(X^B) tensor H^1(D_1) term vanishes.

Here is a proof of the cancellation statement `alg:tensor`
that keeps track of every grade. A finite degree-two nilpotent
operator admits a homogeneous Jordan-string decomposition
(choose homogeneous bases successively in its kernels and
images). A string supported in grades p,p+2,...,q has center
(p+q)/2. A pair of strings from the two factors gives a graded
invariant direct summand, with invariant complement, for the
tensor-sum operator. Thus each Lefschetz isomorphism restricts
to that summand. Its smallest and largest grades are p+p'
and q+q'. Lefschetz symmetry about r forces their sum to be
2r, so the two string centers add to r.

This holds for **every** pair of strings. Fixing one in each
factor shows that every string in a factor has one common
center. A single Jordan string is Lefschetz about its own
center. This proves cancellation, with no positivity assumption
and no assumption about the dimensions of primitive spaces.
It applies to the half-weight grading; the cup product has
degree two in that grading.

H*(D_1) is the exterior algebra on 2g generators of degree one
and actual weight two. Its extreme half weights are 0 and 2g,
so its center is g. Since the total center is R+g, xi_X has
center R. The Hodge--Tate property of X^B also follows from
projection and the identity section.

Finally xi_X is nonzero: otherwise its R-th power could not
identify the nonzero grade-zero H^0 with grade 2R, since R>0.
Smoothness gives H^2=W_4 H^2. As H^2(X^B,Q)=Q e, the nonzero
weight-four image of e is a nonzero scalar multiple of xi_X.
Rescaling preserves the isomorphisms, and the rational maps
are isomorphisms because they become so over C. This proves
the stated verification theorem.

## 7. Shift ledger and exact replay boundary

Every middle weight below is an **actual** weight until the last
column; delta=2R+2b+2g:

| Operation | Degree/actual-weight shift | Middle actual weight | Half-weight center |
|---|---:|---:|---:|
| Covered auxiliary compact supports | 0 | delta+2b | (delta+2b)/2 |
| Remove rank-b bundle | -2b / -2b | delta | R+b+g |
| Smooth duality in dimension delta | w -> 2delta-w | delta | R+b+g |
| Extract image of B | -2b / -2b | delta-2b | R+g |
| Cancel determinant factor | factor center g | 2R | R |

`python3 research/determinant_cover_transfer/verify.py` replays
`exact_certificate.json` using only the standard library. The certificate
is attached to `C_KOSZUL_CONTRACTION`, not mislabeled as a mechanical
proof of the geometric theorem `C_BETTI_CHL`. It
embeds the exact Jacobian request, complete typed response, server version,
protocol and adapter exit/timeout status. Replaying does not call the
adapter. UNKNOWN, timeout, incomplete transformations or a nonzero
adapter status cannot count as success. The initial operation was the
inspected `matrix.normal_form.smith.certified.compute`, bounded to 45
seconds; it returned a successful exact result.

The universal homotopy and shift identities are checked as identities
of Laurent/rational polynomials, so their scope is not bounded by the
displayed n=4 example. Conversely, neither they nor the example prove
the existence of the geometric strata, mixed Hodge functoriality,
Verdier duality or the flag normal-bundle identification. Those are
the explicitly cited inputs and the prose arguments above, which
require independent mathematical review.

No false literal manuscript assertion was identified in this route.
Accordingly there is no invented F_ claim and no `refutes` judgement.
The known-result assumptions and the abandoned objection remain visible
in `research/MATH_STATE.json`; the separate common-lowering-operator
claim remains open in `research/PROOF_GRAPH.json`. Citation attribution
and the final independent verdict belong to the Host-invoked Reviewer.
In particular, no `verified_new` novelty status is asserted.

The installed `citation_check attribute` archives passages under
`research/literature/`, outside this mission's assigned writable
paths. It has not been run with an unauthorized destination or a
substitute project root. The sources and readings are preserved
inside `research/determinant_cover_transfer/literature/`; the
Host must resolve the archive write scope for the independent
attributions before final citation-gate acceptance. This is an
operational certification limitation, not a geometric hypothesis
silently assumed to be true.
