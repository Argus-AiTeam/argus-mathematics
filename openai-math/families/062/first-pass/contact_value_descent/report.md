# Contact-value descent with the original quantifiers

## Scope and primary-source findings

Target: Proposition `des:descent` in the staged September 23, 2026 manuscript,
`build/sections/descent.tex`. This mission does not assume the moving-pair
construction, the classification theorem, or the LeBrun--Salamon conjecture.
It starts with the two regular vector lifts in the proposition.

The initial project ledger contained only the umbrella objective C9000062,
with no proof or refutation evidence. The manuscript dependency chain and
the first five source findings below were recorded before mathematical
implementation. The inherited Wiki index contains no page on contact-value
descent.

Primary sources opened on November 5, 2026:

| Source | Statement read and applicable hypotheses | Scope finding |
|---|---|---|
| [Stacks 035B](https://stacks.math.columbia.edu/tag/035B), Lemma 29.18.2(1) | Schemes locally of finite type over a field are Nagata. | Applies to the reduced finite contact-value image over C. |
| [Stacks 035S](https://stacks.math.columbia.edu/tag/035S), Lemma 29.55.11 | Normalization of a Nagata scheme is finite. | No normality of Y is needed. |
| [Stacks 00H8](https://stacks.math.columbia.edu/tag/00H8), Proposition 10.38.7 | An integral inclusion of domains with normal base has going down. | Applies on affine charts of the finite dominant map to the smooth square. |
| [Stacks 0BMB](https://stacks.math.columbia.edu/tag/0BMB), Lemma 58.21.4 | At x: normal source local ring, regular target local ring, quasi-finiteness, equal positive local dimensions, and unramifiedness at all height-one generizations imply etaleness at x. | Flatness is not a hypothesis. Equal heights and every height-one point still have to be justified. |
| [Stacks 0AB1](https://stacks.math.columbia.edu/tag/0AB1), Lemma 29.55.8 | A finite birational morphism of integral schemes to a normal target is an isomorphism. | The target Z is normal; S0 need not be normal. |
| [Stacks 01WG](https://stacks.math.columbia.edu/tag/01WG), Lemmas 29.45.7 and 29.45.4 | Affine universally closed morphisms are integral; integral morphisms locally of finite type are finite. | Gives finite contact-value image without flatness. |
| [Araujo--Kollar, arXiv:math/0203173v2](https://arxiv.org/pdf/math/0203173v2), Theorem 5(1)--(2), p. 6 | For projective source without embedded points and smooth quasi-projective target, the Hom tangent space is H0 of the pulled-back tangent bundle, and vanishing H1 implies smoothness. | The source used here is P1, not a singular stable-map family. |
| Same source, Section 3, p. 7, paragraph before Definition 8 | Vector bundles on P1 split into sums of line bundles. | Only nonnegative splitting, not the special standard contact-line splitting, is needed. |
| [Serre, GAGA (1956)](https://www.numdam.org/article/AIF_1956__6__1_0/), Section 12, Theorem 1, p. 19, q=0 | Global sections of a coherent sheaf on a projective complex variety agree with its analytic global sections. | Rules out analytic disconnection of the integral projective finite cover. |

These are Engineer source readings, not independent citation approvals.
The two retrieved PDFs and their text extractions are retained here. No
incorrect invocation was found in these cited propositions. The splitting
statement is read in Araujo--Kollar's exposition; no claim is made to have
opened its original historical proof.

The manuscript's actual chain is: contact determinant and Picard reduction;
covering contact lines and their positive tangent parts; the spanning,
possibly disconnected Legendrian direction variety; cone addition and a
suitable pair; fixed-end smoothing and a very free conic; retention of the
full Hom germ; normality of the universal square, unmarked degree-two trees,
contact vanishing and tensor pole bounds; the proper moving-pair tensors;
contact-value descent; symmetry and the full local identity; value--velocity
surjectivity and the diagonal symbol; the symmetric-jet criterion and contact
transitivity; homogeneous adjoint identification; and the twistor and metric
recovery steps. Except for this mission's eventual descent proof, these
remain unverified obligations, not assumptions smuggled into descent.

## Result and its status

**Verification theorem.** Proposition `des:descent` holds with its original
quantifiers. The proof below treats arbitrary proper integral algebraic
spaces Y, accounts for every generic sheet, detects every possible branch
divisor, and verifies the local hypotheses of purity.

This is an Engineer's complete mathematical proof, awaiting independent
Reviewer examination. It is not a machine formalization of the geometric
theorem, a new classification theorem, or a claim of publication novelty.
The arithmetic sublemma in `Main.lean` and the exact polynomial replay have
the strictly limited roles stated below. No refutation of a manuscript
assertion has been established.

## 1. Precise statement

Work over C. Let X be smooth, simply connected, projective and contact Fano,
with contact sequence

    0 -> F -> T_X --theta--> L -> 0,

and Pic(X)=Z[L]. Assume a covering family of free contact lines exists. Here
f:P1->X is a contact line if f*L=O(1), and free means f*T_X is globally
generated. Set Z=X x X and M=L boxtimes L.

Let Y be any proper integral algebraic space over C, and let p:Y->Z be any
dominant morphism. Suppose everywhere regular sections

    W12 in H0(Y,p*(T_X boxtimes L)),
    W21 in H0(Y,p*(L boxtimes T_X))

have the same contact value

    xi = (theta boxtimes 1)(W12) = (1 boxtimes theta)(W21).

Then there exists exactly one B in H0(Z,M) such that p*B=xi.

There are no assumptions on the dimension of Y, its normality, the fibers
of p, the flatness of p, or the flatness of any curve pullback.

## 2. Two elementary inputs from free contact lines

Write dim(X)=2n+1. Contact nondegeneracy gives det(F)=L^n by the top
exterior power of the L-valued symplectic form on F. Thus
-K_X=L^(n+1); since -K_X is ample, L is ample.

For a free contact line f, split E=f*T_X as a sum of O(a_i). All a_i are
nonnegative. Let P be the sum of those with positive degree. This subbundle
does not depend on the chosen splitting: every map from a positive summand
to the zero-degree quotient of another splitting is zero. Consequently
each proposed positive part is contained in the other. We have

    Q=E/P is trivial.

Also theta(P)=0. Indeed theta df=0, since Hom(O(2),O(1))=0. The nonconstant
map f has nonzero differential in characteristic zero. Pairing this
differential with the nondegenerate Levi form gives a nonzero morphism

    f*F -> Hom(T_P1,f*L)=O(-1).

Hence f*F is not globally generated: a globally generated bundle admits
no nonzero map to O(-1). If theta were nonzero on any positive summand,
that summand would have to be O(1), and its map to f*L=O(1) would be an
isomorphism. It would split E->O(1), making its kernel f*F a direct
summand of the globally generated E. That kernel would be globally
generated, a contradiction. Therefore theta factors as

    E -> Q -> O(1).

Only the elementary line-bundle calculations H0(O(a))=0 for a<0 and
H1(O(a))=0 for a>=-1 are used here and below. They follow from the
two-standard-affine-chart Cech computation on P1.

We may choose a smooth irreducible open H of the degree-one Hom scheme
consisting of free maps and with dominant evaluation

    ev:H x P1 -> X.

To see this directly, fixed degree is a finite-type Hom locus after
embedding X by a very ample power of L. The covering hypothesis gives an
irreducible component with dominant evaluation and a nonempty free locus.
At each free map H1(E)=0, so that locus of Hom is smooth, with tangent
space H0(E), by Araujo--Kollar Theorem 5. Freeness is open; shrink inside
the covering component. At every (f,t), evaluation on tangent vectors
from H0(E) already surjects onto E_t. Thus ev is smooth, by the
Jacobian criterion between smooth complex varieties. No properness or
surjectivity of ev is asserted.

## 3. The finite contact-value image

A useful fact, also for singular algebraic spaces, is

    D proper and integral over C => H0(D,O_D)=C.

A regular function gives a morphism D->A1->P1. Its image is a closed
irreducible subset of P1 because D is proper; it avoids infinity, so it
is a point. Reducedness and algebraic closedness of C give the assertion.

The section xi defines a morphism a:Y->Tot(M). This morphism is proper:
its graph is closed since Tot(M) is separated, and projection from the
product with the proper space Y is proper. Let S0 be its reduced image.
It is an integral scheme, being a reduced irreducible closed subscheme of
Tot(M), and reducedness of Y gives a factorization Y->S0.
This is a proper surjection.

The scheme S0 is proper over C. Here is a justification that does not
silently assume a scheme source. After every base change, Y->S0 is still
surjective. The inverse image of a closed subset of the base-changed S0
is closed in the base-changed Y and has the same image in the base.
Properness of Y therefore implies universal closedness for S0. Finite
type and separatedness are already known.

The projection q0:S0->Z is affine, because S0 is closed in the total
space of a line bundle, and proper, because S0 is proper and Z is
separated over C. It is finite by Stacks 01WM and 01WJ. It is dominant
and hence surjective, since p factors through it.

Let nu:S->S0 be the normalization, and q=q0 nu. The scheme S0 is of finite
type over C and hence Nagata; Stacks 035B and 035S make nu finite. Thus
q is finite dominant, S is integral and normal, and its function-field
extension is separable. There is a dense open V of S0 on which nu is an
isomorphism. The finite image of S0 minus V has smaller dimension than Z.
Likewise the image of the non-etale locus of q is a proper closed subset:
q is etale at its generic point in characteristic zero.
Deleting these two images gives a dense open U of Z with

    S x_Z U = S0 x_Z U, finite etale over U.                 (3.1)

In particular no morphism Y->S, which need not exist when Y is not normal,
has been used.

## 4. Every generic sheet is rational over either type of test line

Fix c:P1->Z of the form (f,y), with f in H, whose image meets U. Form
T=P1 x_Z Y. It is closed in P1 x Y, hence proper over C. For every reduced
irreducible component D of T dominating P1,
the space D is proper and integral over C. Pull back W12 to D and project
its vector factor E to Q=E/P. Since Q tensor L_y is trivial, that
projection is a constant vector, by H0(D,O_D)=C. Applying the factored
contact map Q->f*L therefore gives a global section

    a_D in H0(P1,c*M),    xi|D = pi_D* a_D.                 (4.1)

For c=(y,f) the same reasoning, using W21 rather than W12, proves (4.1).

It is important that D ranges over all dominating components, not just
one chosen component. Put K=C(P1) and eta=Spec K. The surjection Y->S0
remains surjective after base change, so

    T_eta -> (P1 x_Z S0)_eta

is surjective. Every point of T_eta belongs to a dominating component D:
there are only finitely many irreducible components of T, and vertical
ones have empty generic fiber.

Trivialize c*M at eta, with fiber coordinate zeta. The finite K-algebra A
of (P1 x_Z S0)_eta is a quotient of K[zeta], since S0 is a closed
subscheme of Tot(M). By (3.1), A is finite etale and in particular reduced.
On D_eta equation (4.1) sends zeta to the scalar a_D(eta) in K.
The map on coordinate rings therefore factors through

    K[zeta]/(zeta-a_D(eta)) = K.                            (4.2)

This statement does not require a K-point on D_eta. For example, the
structural map of any extension field to Spec K exists regardless of its
K-points. What matters in (4.2) is that the image algebra is generated by
the contact coordinate, not by all functions on D_eta.

Surjectivity now shows that every residue field of A is K. A finite
reduced K-algebra is the product of its residue fields: its finitely many
maximal ideals are pairwise comaximal and have zero intersection, so the
Chinese remainder theorem applies. We obtain A=K^r for some r.

Consequently, for every test line of either factor type that meets U,
each dominating irreducible component C of (P1 x_Z S)_red has function
field K. Its normalization C^nu is finite over P1, and

    deg(C^nu -> P1)=1.                                    (4.3)

Finiteness follows from finiteness of the pullback and of normalization
of an integral finite-type curve. Vertical or embedded components in
this pullback have not been excluded or assumed away.

## 5. A transverse test line detects every divisor

We prove the needed assertion for an arbitrary prime divisor Delta in Z,
an arbitrary dense smooth open Delta0 of Delta, and any dense open U of Z.

Put d=dim X. If the second projection Delta->X is dominant, it is
surjective by properness. For general y, the fiber X x {y} is not
contained in Delta, and Delta_y is a nonempty effective Cartier divisor
on X. Since Pic(X)=Z[L], write O(Delta_y)=L^a. Intersecting with
L^(d-1) shows a>0: an ample line bundle has positive degree on the
nonzero effective cycle Delta_y. Thus every contact line f not
contained in Delta_y has

    deg f*O(Delta_y)=a>0.

In this case lines (f,y) detect Delta.

If Delta does not dominate the second factor, its proper closed image D
has dimension at least d-1, since Delta has dimension 2d-1 and fibers
have dimension at most d. As D is proper in the d-dimensional X, its
dimension is d-1. The inclusion Delta inside X x D is an inclusion of
irreducible closed varieties of equal dimension, so Delta=X x D.
Again O(D)=L^a with a>0. Lines of type (y,f) not contained in Delta
therefore meet it.

We must also ensure that the intersections are in Delta0 and transverse,
even though ev is only smooth dominant, not necessarily surjective.
For either chosen type let P=H x X, m=dim P, and

    E:P x P1 -> Z

be universal evaluation. This map is smooth and dominant. Set
A=Delta minus Delta0, a closed subset of codimension at least two in Z.
Smoothness gives dim E^(-1)(A)<=m-1. Its projection to P is closed,
because P1 is proper, and has dimension at most m-1. A general parameter
therefore gives a curve avoiding A.

The inverse image W=E^(-1)(Delta0) is smooth of pure dimension m.
It has finitely many irreducible components. Remove from P the closures
of the images of the components not dominating P. Each dominating
component has the same dimension as P, so in characteristic zero it is
generically etale over P. Its non-etale locus has dimension at most m-1;
remove the closures of those images as well. On the resulting dense
open of P, all fibers of W->P are smooth and zero-dimensional. These
fibers are exactly the inverse images of Delta0 under the test line.
For a Cartier divisor this is transversality, including multiplicity one
at each intersection parameter.

Finally, meeting U and not being contained in Delta are nonempty open
conditions on P. They are the images of E^(-1)(U) and E^(-1)(Z minus
Delta) under the open projection P x P1->P. In the first case above we
also restrict y to the dense open where Delta_y is the indicated
nonzero divisor. All of these open sets intersect because P is
irreducible. Positive intersection ensures a nonempty intersection
with Delta, avoidance of A puts it in Delta0, and the preceding
argument makes every such intersection transverse.

This proves the assertion for every Delta, not merely a general divisor
or a divisor encountered by a preselected line.

## 6. Excluding all divisorial ramification

Suppose q is ramified at the generic point of a prime divisor R of S.
Its image Delta is a prime divisor of Z, since q is finite dominant.
There are finitely many reduced prime divisors R_i above Delta.
We can choose a dense smooth open Delta0 of Delta with the following
properties:

* S is smooth at every point above Delta0;
* the reduced R_i are smooth, pairwise disjoint over Delta0, and
  their maps to Delta0 are etale.

Here normality of S makes its singular locus have codimension at least
two. Each R_i is generically smooth, and each finite dominant map
R_i->Delta is generically separable in characteristic zero. Remove the
finite images of these bad loci, the pairwise intersections of distinct
R_i, and the singular locus of Delta. Each image removed has dimension
strictly smaller than dim Delta. The inverse image of Delta has no
additional set-theoretic components of higher codimension: locally it
is cut out in the domain S by a nonzero function, whose minimal primes
have height one.

At s in R_i over x in Delta0, choose analytic coordinates
x1,...,xN on Z with Delta=(x1=0), N=dim Z. A local equation z1 of the
smooth divisor R_i satisfies

    q*x1 = u z1^e

for a unit u and positive integer e. This follows by the divisor of
the pullback of x1; no other component passes through s. Absorb an
analytic e-th root of u into z1. The functions q*x2,...,q*xN, together
with z1, are coordinates on S at s, because their restrictions are
coordinates on R_i under its etale map to Delta0. Hence the map is
locally

    (z1,z2,...,zN) |-> (z1^e,z2,...,zN).                    (6.1)

At a generic divisor the residue extension is separable; index one
gives an unramified map in (6.1). Our ramified R therefore has e>1.
The finite surjection R->Delta ensures that every point of Delta0 has
a preimage on this component with that index.

Use Section 5 to choose a test line c meeting U and meeting Delta0
transversely. At an intersection parameter t0 choose s on the ramified
component. Write t for a parameter at t0. In (6.1), set

    a(t)=x1(c(t)),    a(0)=0,    a'(0) != 0.

Eliminating the other coordinates, the analytic local ring of the
finite pullback at (t0,s) is

    C{z1,t}/(z1^e-a(t)).                                   (6.2)

The derivative of its defining equation with respect to t is nonzero
at the origin. By the analytic inverse function theorem, the germ is
a smooth irreducible curve with coordinate z1; more explicitly
t=a^(-1)(z1^e). Its order in z1 is exactly e.
Thus no vertical or embedded component goes through this germ.
Its unique algebraic reduced component C dominates P1. The completed
algebraic local ring is the same regular power-series ring furnished by
(6.2), so the algebraic local ring is regular too. Normalization is
therefore an isomorphism near this point.

But (4.3) says that C^nu->P1 is finite of degree one. Since P1 is normal,
this is an isomorphism, so a base uniformizer must have order one at
that point. The order e>1 from (6.2) is impossible.

Equivalently, on a degree-one sheet the nonzero germ z1 is a meromorphic
germ on the base. Its integer order m would satisfy

    e*m = ord_t(a(t)) = 1,

which is impossible for e>=2. `Main.lean` checks this last arithmetic
obstruction for every e and every integer m, not just for small e.

We conclude that q is unramified at every height-one point of S.

## 7. Purity, connectedness, and descent

Let s be any nongeneric point of S and z=q(s). On affine charts, q
comes from a finite inclusion A subset B of domains, where A is regular
and in particular normal. Going down (Stacks 00H8) and incomparability
give

    ht(s)=ht(z)>0.

For clarity, going down lifts any prime chain ending at z to a chain
ending at s, giving ht(s)>=ht(z). Incomparability makes contractions
of a prime chain in B strictly increasing, giving the reverse inequality.
This handles nonclosed points as well.

The local ring at s is normal, the local ring at z is regular, q is
quasi-finite, the local dimensions agree and are positive, and every
height-one generization of s is unramified by Section 6. These are all
the hypotheses of Stacks 0BMB, Lemma 58.21.4. It makes q etale at s.
The generic point is etale by characteristic zero. Thus q is finite
etale everywhere. In particular its flatness is a conclusion, not an
assumption about q or about any earlier pullback.

The scheme S is projective, being finite over projective Z. It is
analytically connected. Otherwise a nontrivial analytic clopen
decomposition would give a nontrivial holomorphic idempotent on S^an.
Degree-zero GAGA, applied to O_S, would give an algebraic idempotent;
an integral scheme has only 0 and 1.

The analytification of q is a finite covering. Indeed etaleness gives
local biholomorphisms; at a base point take disjoint such neighborhoods
of its finitely many preimages. Properness lets us shrink the base
neighborhood to exclude the image of their closed complement. This
gives an evenly covered neighborhood. Now Z^an=X^an x X^an is simply
connected. A connected covering of a simply connected manifold has
one sheet, by path lifting. Thus deg q=1.

Since normalization is birational, q0:S0->Z is finite birational as
well. Stacks 0AB1 makes q0 an isomorphism: on an affine normal domain A,
the finite image algebra is an integral subalgebra of Frac(A), hence
is A. Its inclusion into Tot(M) is therefore a section of that line
bundle over Z, say B. The factorization of a gives p*B=xi.

Finally, a dominant map of integral spaces injects function fields.
After locally trivializing M this proves that pullback of its sections
is injective. Hence B is unique. This completes the proof.

## 8. Certificate boundary and comparison with prior state

The exact algebra replay checks the inspected Jacobian cubic result,
the defining smooth hypersurface derivative, and the recorded
compiler certificate for the universal integer-order obstruction.
Neither the cubic instance nor the Lean file establishes Sections 2--7
of algebraic geometry by itself. `verify.py` must state this limitation
even when every exact check passes.

The improvement over the seed is a full proof of the specific original
descent proposition, together with a decomposition that exposes rather
than hides the all-sheet, divisor-detection, and purity obligations.
No stronger sufficient criterion has been substituted for the target.
The moving-pair construction, smoothing, jet criterion, homogeneous
identification, metric recovery, and unrestricted classification remain
open in the ledger and graph. Formal compilation of the arithmetic
subclaim cannot close any of them.

Independent mathematical and citation review remains required. In
particular, no `reviewer_confirmed=true`, independent `supports`, or
publication-novelty verdict is supplied by the Engineer.

## 9. Replaying the exact evidence

From the campaign root, run:

```bash
python3 research/contact_value_descent/verify.py
```

The replay uses only the Python standard library. It independently computes
the cubic discriminant by a Sylvester determinant over Q[t], checks the
typed Jacobian request and result against the preserved payload, verifies
the smooth hypersurface derivative and parametrization, and checks that
the current formal source and fidelity text match the actual archived
compiler run. It does not rerun Lean or check the geometric proof.

The real compiler command used was:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/contact_value_descent/Main.lean --statement-fidelity research/contact_value_descent/statement_fidelity.md --artifact-dir research/contact_value_descent --project-root . --claim C_DES_INTEGER_ORDER --timeout 90
```

On November 5, 2026 this returned Lean 4.31.0, compiler exit 0,
`proof_holes=[]`, and axiom-audit exit 0. Its claim-bound archive is
`certificates/C_DES_INTEGER_ORDER-271cf98b692e2cbf.json`. Only
C_DES_INTEGER_ORDER earned `closed_kernel`. The initial failed compiler
result is retained as `initial_lean_check.json`; it is not supporting
evidence.

The standalone replay passed. Seven distinct negative controls rejected a
timeout, an UNKNOWN typed result, a changed polynomial, a failed compiler,
a proof hole, stale formal source, and stale fidelity text. Independent
geometric review and independent attribution of the nine cited assumptions
remain pending; `citation_status.json` records that fact rather than
turning the Engineer's source readings into independent approvals.
