# Classical transcendental blocks in genus-zero blowup reconstruction

## Result and certification boundary

This note submits a verification theorem, with a proper weakening of the
ambient hypothesis, for independent review. It does **not** certify the
manuscript's irrationality theorem.

The proposed theorem below has a geometric proof in this note. Its integer
ordering and tensor-division core has a real Lean 4.31.0 compiler certificate
with exit code zero, an empty proof-hole list, and a successful axiom audit.
Lean does not formalize the geometric proof. Independent statement-fidelity,
geometric, citation, significance, and novelty review remain outstanding.
No false manuscript assertion has been established in this investigation.

The prior campaign ledger contained no mathematical certificate. The
improvement is an unbounded checked reconstruction core and a quantified
geometric argument, not a bounded search with no witness.

## Verification theorem

Let M be a smooth connected projective complex fourfold with

    h^(2,0)(M) = h^(4,0)(M) = 0.

Let pi:Y -> M be the blowup of a smooth connected center Z of codimension
r>=2. Define T and G exactly as in manuscript Definition gw:algebra:
torsion is removed, T is the cup-orthogonal complement of rational Hodge
classes, all invariants are connected and genus zero, the two variable
markings have distinct formal labels, and all other ordinary insertions
are rational diagonal-Hodge classes. All nonnegative ordinary descendant
powers, including those on the variable markings, are allowed.

In the classical integral embeddings, if Z is a surface, then

    (T_Y,q_Y) = (T_M,q_M) orthogonal-sum (T_Z(-1),-q_Z),
    G_Y = G_M direct-product Q id_(T_Z).

The second factor is omitted when T_Z=0. For a curve or point center,
T_Y=T_M integrally and G_Y=G_M. Product means independent actions with zero
mixed blocks, not merely an isomorphism after a change of basis or Novikov
extension. This includes every blowup in manuscript Theorem gw:blowup.

The extension is genuinely broader in its hypotheses: for example,
M=C x P^3 with C a smooth curve of positive genus satisfies the two
vanishings but is not rationally connected. A smooth quartic surface in
{c} x P^3 is an allowed K3 center. This example demonstrates the difference
of scope, not a claim that the example itself is a new result.

## Geometric inputs and conventions

The following published propositions are inputs, not consequences of the
Lean arithmetic. They are registered as assumptions on
`C_EVEN_HODGE_SPLIT`.

| Input | Exact primary source | Use |
|---|---|---|
| Classical integral blowup formula | Schreieder, doi:10.1017/fms.2013.7, Section 2.1, Lemmas 9-10 | Integral maps, Hodge compatibility, and exceptional intersection sign |
| Polarizations and Hodge complements | Voisin, doi:10.1007/978-3-319-32162-2_17, author text Sections 2.1-2.2, Lemma 1 | Nondegeneracy and generation by off-diagonal types |
| Connected relative factors and degeneration | Abramovich-Fantechi, doi:10.2422/2036-2145.201408_006, Theorem 0.1, Proposition 4.14, Corollary 4.15, Definition 4.1 and Section 4.3 | Degeneration into connected tensors with actual ordinary cotangent classes |
| AF-to-Li comparison | Abramovich-Marcus-Wise, doi:10.5802/aif.2892, Theorem 1.1.2 and Section 4.1 | Virtual pushforward without contracting source components |
| Codimension-r translation and fibre integral | Hu-Li-Ruan, arxiv:math/0611592v3, equation (17), Theorem 7.1 and its proof | Translation exponent and nonzero leading local coefficient |
| Divisor correspondence | Maulik-Pandharipande, doi:10.1016/j.top.2006.06.002, Section 2.4, Lemma 4 | Comparison of the divisor leading coefficient and arbitrary original descendants |
| Original rational-connectedness hypothesis | Araujo-Kollar, arxiv:math/0203173v2, Theorem 30 and proof | Vanishing of tensor differentials, hence of holomorphic two- and four-forms, for the manuscript corollary |

Primary PDFs and extracted text are in `literature/`. A separate source
reader inspected the four relative-theory references and reported no
concrete convention mismatch. That reader did not successfully persist
citation attributions; no independent citation verdict is claimed here.
The host Reviewer must file the remaining source-attribution judgements.

Ordinary psi classes mean cotangent lines of the actual coarse source at
ordinary markings. No psi class at a joining relative root is used.
AF's disconnected-component product theorem requires a marking or root on
each connected component. Every vertex of a nontrivial connected
degeneration graph has a root; a one-vertex term needs no product theorem.
AF Definition 4.1 identifies ordinary marked neighborhoods before and after
the indicated stabilization. AMW Section 4.1 states that the AF-to-Li map
does not collapse source components. Thus this application needs the
particular comparison morphism, not just AMW's weaker general descendant
corollary for unexpanded stable maps.

All formulae below may be summed over homology classes of a fixed numerical
class. Fixed ample degree has only finitely many relevant effective classes:
the ample degree bounds lattice points in the closed effective cone, and
the numerical curve class is unchanged in a connected family. Relative
gluing and all normal-cone projections respect numerical equivalence.

## 1. Hodge and integral geometry

The two ambient vanishings imply that H^2(M,Q) and, by hard Lefschetz,
H^6(M,Q) are diagonal. The only off-diagonal types in even cohomology are
(3,1) and (1,3) in H^4. These facts, not rational connectedness itself, are
the ambient properties used below. They persist under the allowed blowups.

All nonprimitive Lefschetz summands in H^4 are rational Hodge classes.
On the primitive (2,2) space the cup form is definite. The primitive
Hodge-class space is therefore nondegenerate, and the nonprimitive
Lefschetz decomposition is orthogonal and nondegenerate. Its orthogonal
T_M is a polarizable rational Hodge structure with no rational Hodge
classes. A Hodge complement to the substructure generated by H^(3,1)
and H^(1,3) would be diagonal, hence zero. These two types generate T_M.
The same argument on a surface generates T_Z by H^(2,0) and H^(0,2).

For a surface inclusion i:Z -> M, it follows that i^*T_M=0 and i_*T_Z=0:
the relevant target groups H^4(Z) and H^6(M) are diagonal. Testing these
maps on generating types proves their vanishing on the whole structures.

Write D=P_Z(N_(Z/M)), p:D -> Z, j:D -> Y, xi=c_1(O_D(1)).
For a surface center the integral blowup maps give

    H^4(Y,Z)/tors = pi^*(H^4(M,Z)/tors)
                   direct-sum j_*p^*(H^2(Z,Z)/tors).

The first summand is orthogonal to the second because p_*1=0.
The identity j^*j_*=-xi and p_*xi=1 give the form -q_Z on the
second summand. The rational Hodge-class space splits under these same
maps. Intersecting its orthogonal with the integral direct sum gives the
asserted integral T decomposition. Curve and point centers contribute
only diagonal classes to H^4. This proves the integral part, including
the sign and saturation, without an integral Hodge conjecture.

## 2. The local rule and two-variable trees

Put W=T_Z,Q for a surface center and W=0 otherwise. Every class of Hodge
difference two on D or on either normal-cone projective-bundle piece is a
tautological copy of W. A positive-degree diagonal base class kills W:
test on (2,0) and (0,2), then use Hodge generation. Multiplication by a
fixed diagonal class consequently acts by scalars between compatible
copies, or is zero. Products of two W variables are q_Z(u,v)[point].

If W is nonzero then p_g(Z)>0 and Z is not uniruled. One direct justification
of the latter assertion is that a covering family of rational curves on
a surface gives a generically finite rational map from a ruled surface;
pullback is injective on holomorphic two-forms but the ruled surface has
none. For fixed genus-zero relative or absolute data of positive projected
degree, each evaluation image in Z is therefore contained in a curve or
point. There are finitely many components of the proper finite-type
moduli. Pullback of a holomorphic two-form vanishes on each evaluation
image. Hodge generation then makes the two-W tensor zero. Expanding the
target does not change this argument after projection to Z.

For zero projected degree all base evaluations agree. The projection formula
extracts uv; any additional positive-degree base factor kills it. What
remains is a rational fibre integral times q_Z(u,v). This includes
descendants and either ordinary or relative placements of the W slots.

In a connected genus-zero degeneration graph, prune branches not meeting
the path between the two formal variable markings. Each branch has only
fixed diagonal inputs, and its single output is rational and diagonal by
Hodge difference. It replaces the existing relative-root label, not an
ordinary marking. Along the remaining path only difference-two classes
can propagate. All these classes and the branch outputs are even, so no
odd permutation sign occurs.

Consequently vertex restrictions

    old,old: q_M(Au,v), A in a specified rational unital algebra;
    W,W:     a rational scalar times q_Z;
    mixed:   zero

are preserved by path contraction. Orienting every vertex slot in the
path direction, contraction of q(Au,x) and q(By,v) is q(BAu,v).
Thus no unannounced adjoint-closure assumption is needed. This is a
conditional contraction statement; its vertex hypotheses are supplied by
the following inductions, not inferred from the tree alone.

## 3. Restricted codimension-r reconstruction

Consider a connected relative invariant of (Y,D), with original ordinary
insertions pulled back from M. The variables are ordinary old classes or
boundary copies of W. A weight (k,xi^b p^*delta), 0<=b<r, translates to

    tau_(r(k-1)+b)(i_*delta)

on M. Retain every original ordinary marking and its descendant exponent.
Lift a translated insertion by the strict transform of Z x A^1 in
Bl_(Z x {0})(M x A^1). That family is isomorphic to Z x A^1 and is disjoint
from the main component of the special fibre. The lift restricts to the
zero-section Gysin class on P_Z(N+O) and to zero on Y. A zero Gysin class
on the smooth fibre is not an obstruction to this lift.

Thus a starting absolute old-old tensor is allowed in G_M, while a starting
tensor with a boundary W variable is zero because i_*W=0.

Induct first on projected integral ample degree on M, then on the number
of original ordinary markings. At fixed outer data induct lexicographically
on relative length, total contact, and total fibre exponent, with smaller
values earlier. All labels, variable placements, and descendant exponents
are quantified simultaneously.

A positive contracted curve has class a positive multiple of an exceptional
line and has negative D degree. It cannot satisfy positive relative-contact
admissibility. Hence a zero projected-degree relative vertex has zero class
and no roots; its tensor is a scalar cup pairing or zero. This supplies
the initial case.

In every nontrivial tree each main vertex has a root and therefore positive
projected degree. Multiple main vertices, or a unique main vertex of lower
projected degree, give smaller outer cases. A full-degree main vertex with
fewer original ordinary marks is also earlier. Pruning never increases that
mark count. The local rule and path contraction handle all such terms.

At equal outer data there is exactly one main vertex and every other
vertex is a fibre tail with a single joining root. For a tail receiving
translated marks J and output contact k', its output is

    product_(j in J)(p^*delta_j) * eta,
    codim(eta) = r*(sum_(j in J) k_j-k') + sum_(j in J)b_j-|J|+1.   (1)

Indeed the relative fibre virtual dimension is r-2+rk'+|J| and the
translated fibre codimensions are rk_j+b_j; pushforward to the joining
P^(r-1) gives (1). Negative codimension means zero.

If both W variables occur on one tail, their product already gives the
allowed scalar pairing. Otherwise the two slots stay separate. Empty tails
have codimension 1-rk'<0. Thus the new length cannot increase. At equal
length every tail is a singleton. Nonnegative codimension and b<r force
k'<=k. At equal total contacts all contacts agree. The resulting fibre
exponent is at most b, so either the total exponent drops or the original
relative data reappear. These are precisely earlier indices or the desired
leading term. Lean proves the two numerical implications without a bound
on r, contacts, or descendant exponents.

The leading single-tail fibre integral is exactly

    F(r,k,j)=1/(k^(r-j)*((k-1)!)^r),   j=r-1-b.                    (2)

It is positive. In a fully labelled individual gluing contribution the
contact factor k multiplies (2), giving

    k*F(r,k,r-1-b)=1/(k^b*((k-1)!)^r).                           (3)

The complete leading coefficient is the sum over unchanged-data gluing
graphs of their positive contact/automorphism/label factors times the
products of (2). This describes the coefficient with the same graph
normalization as the degeneration formula; it does not identify different
authors' ordered-root and weighted-partition normalizations. In particular
it is a nonzero rational number independent of both variable vectors.
The graph with one leading tail per translated mark occurs.

The absolute tensor therefore equals C times the desired relative tensor
plus allowed earlier terms, with C!=0. The allowed tensors form a rational
submodule. Division by this single scalar proves their membership as
tensors, not as vector-dependent scalar evaluations. Testing generating
opposite types extends the conclusion to all rational variables.

## 4. Inclusion and exceptional projector

Degenerate Y along D. Every ordinary diagonal insertion on Y is a sum
of a pullback from M and j_*a. Lift the latter by the strict divisor
family, supported on the zero section of P_D(N_(D/Y)+O). Do the same for
an exceptional variable. The main relative vertices have exactly the
ordinary insertions treated in Section 3. Every other vertex is a bundle
piece over Z treated in Section 2. Tree contraction proves

    G_Y subset G_M direct-sum Q id_W.                            (4)

This proves zero mixed blocks and scalar exceptional blocks for **every**
allowed ordinary descendant invariant.

For a primitive exceptional line e, every map is contained in one P^1
fibre of D -> Z. Its normal bundle in Y is O(-1)+O+O, so these maps are
unobstructed. The two-point degree-one evaluation map has degree one
onto P^1 x P^1, including its stable boundary. Restriction of an exceptional
class is -xi p^*u. Therefore

    <j_*p^*u,j_*p^*v>_(0,e) = integral_Z uv.

Old classes restrict to zero. Since q_Y on this summand is -q_Z, the
operator is **minus** its projector, not plus. The projector and its
complement belong to G_Y. The exact script and Jacobian determinant check
verify the associated sign/nondegeneracy calculation; they do not
recompute the geometric moduli integral.

## 5. Divisor reconstruction and recovery

Now allow arbitrary original ordinary diagonal insertions on Y. Variables
may also be ordinary exceptional classes. Translate a boundary weight
(k,delta) to tau_(k-1)(j_*delta), using the strict divisor-family lift.
On the two boundary copies of W, Gysin sends p^*W to the ordinary
exceptional block and sends xi p^*W to zero in diagonal H^6(Y).
Restriction of an ordinary exceptional variable is -xi p^*W. By (4),
every starting absolute tensor satisfies the desired old-old, W-W, and
mixed restrictions, with old algebra pr_M G_Y.

Induct on ample degree on Y, then on original ordinary-mark count.
The collapsed classes of all components are effective and sum to beta.
A main vertex has a root and cannot have zero class, so all split-degree
terms are earlier. This uses an ample class on Y, not nefness of D.

At equal outer data the unique main vertex has class beta. Put K=D.beta.
If K<0 there is no relative datum. At K=0 the relative list is empty;
constant cases are cup pairings. Otherwise all other vertices are fibre
tails and sum of their output contacts is K. For a tail,

    c_a = sum_(j in J_a)(k_j-1)-k'_a+1,
    sum_a c_a = t-L,                                            (5)

where t is the new relative length and L is the original length. As before,
a tail containing both W variables is already an allowed scalar. In all
other terms the two slots remain distinguished.

Nonzero tail outputs have c_a>=0, so t>=L. All contacts are positive and
sum to K, so t<=K. At fixed beta use **decreasing** relative length.
This is finite, not an unbounded reversal of a natural-number order.
Lean checks (5) for arbitrary finite lists and the explicit decreasing
measure

    (K-L)*(K+1) + number_of_positive_weight_labels.

At t=L every c_a is zero. Give a label weight
k-1+codim(delta). This is nonnegative, and each variable W label has
positive weight even if its vector is zero. The output weight on a tail
is the sum of its input weights. A tail combining two positive-weight
labels strictly decreases their total number. At equality every tail
contains at most one such label. All remaining inputs are (1,1), empty
tails have contact one, and every nontrivial contact and base label is
unchanged. Thus the original weighted partition reappears. Lean checks
strict decrease and the singleton rigidity for arbitrary lists of counts.

For the source's weighted-partition normalization the coefficient is
precisely the one in MP Lemma 4:

    C_div = K^q * product_j 1/(k_j-1)!,                          (6)

where q counts the original entries (1,1). For the empty list it is one.
One can also derive its nonvanishing directly: a tail with its sole
positive-weight entry has gluing coefficient
k*F(1,k,0)=1/(k-1)!. Each additional trivial translated marking is an
interior point-divisor insertion and multiplies it by k. Summing the
assignments of q distinctly marked trivial insertions gives
(sum output contacts)^q=K^q. The usual root symmetry normalization is
exactly the one in MP's formula. Moving to ordered-root invariants only
rescales this coefficient by the explicit positive root-labeling factors
of the degeneration formula; it cannot change the tensor restrictions.

For this fibre calculation the divisor is supported away from the joining
boundary. Its descendant correction has the square of the fibre point
class and is zero. Positive-degree base corrections cannot contribute to
the degree-zero output coefficient. Thus every unchanged-data coefficient
is positive; they cannot cancel. No positivity is asserted for the
uncontrolled numerical values of earlier main invariants.

Division by C_div reconstructs the three rows with old algebra pr_M G_Y.
Original descendants have not changed at retained main markings; when an
original marking moves to a tail it belongs to a smaller ordinary-mark
case. No descendant bound has entered either induction.

Finally degenerate an arbitrary absolute generator on M along Z. An old
variable has zero restriction to the bundle component, so lies on a main
vertex. If both lie on one main vertex the reconstructed tensor is in
pr_M G_Y. If they lie on different main vertices, the first boundary edge
on their path is a W copy, making the first main path tensor mixed, hence
zero. If W=0 there is no boundary class of the required Hodge difference.
All side branches have already been incorporated as fixed diagonal root
labels. Hence G_M subset pr_M G_Y. Together with (4) and the exceptional
projector this proves equality and independence of both factors.

## Scope, unsuccessful shortcut, and outstanding review

Iritani's arxiv:2307.13555v3, Theorem 1.1 and Corollary 1.2, were opened.
They explicitly use a formal invertible variable change and a Laurent
Novikov extension. That statement alone does not identify the fixed
classical embeddings in this problem; it is not used as a proof of (4).

A broad web novelty lookup misidentified the requested middle-degree
transcendental group as H^2 of a fourfold. It is not evidence of either
novelty or prior art. No exhaustive novelty claim is made.

The whole geometric argument, especially the scalar and vector-independent
leading coefficient in each descendant reconstruction, must be read by the
host-invoked independent Reviewer. The compiler certificate supports only
`C_RECONSTRUCTION_ORDER`. The theorem is not marked reviewer-confirmed,
and `novelty_status=verified_new` and publishable campaign completion are
not claimed. The independent Reviewer also needs to close the cited
propositions in the ledger. The other manuscript branches, including the
uniform Sarkisov bound and the subfield vanishing, remain unaudited.

## Reproduction

Run `python3 research/classical_basis_blowup/verify.py` from the campaign
directory. It replays the exact coefficient/sign arithmetic and checks the
current Lean source, fidelity document, official archived compiler record,
and current claim version. Its successful result explicitly leaves the
geometric theorem awaiting independent review.

On this host, add `--replay-lean` to invoke the prescribed Argus verifier
again and record a new real compiler run, followed by both campaign-local
official checks. The already successful compilation took 15.858 seconds;
it need not be repeated merely to validate unchanged arithmetic code.
