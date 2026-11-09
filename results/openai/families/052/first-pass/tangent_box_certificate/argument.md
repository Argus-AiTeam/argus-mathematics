# Canonical tangent boxes without an integrability assumption

## Result and scope

**Verification theorem.** Let X be a smooth projective complex manifold
with a specified holomorphic splitting TX=E1 direct-sum E2. For every
holomorphic map g:P1 -> X there is exactly one holomorphic map
F:P1 x P1 -> X satisfying

    F(s,s)=g(s),  dF(T(first factor)) subset E1,
                 dF(T(second factor)) subset E2.

The ranks are unrestricted. Neither distribution is assumed integrable.
The map g may be constant, ramified, or have vanishing derivative, and F
need not be immersive. The exceptional-component argument below permits
every positive pair of normal vanishing orders.

More quantitatively, fix a projective embedding X -> PN and set
d=degree(g*O(1)). In the rational reconstruction step, coordinate-pair
relations of bidegree (m,m) can always be chosen with **m=2d+1**. The box
is natural under every holomorphic self-map phi:P1 -> P1, including
ramified and constant maps:

    F_(g composed with phi) = F_g composed with (phi x phi).

On a smooth connected rationally connected projective X, the box theorem
and projected-bracket transport imply that both specified summands are
integrable. This last assertion is proved in Section 8, not assumed in
the construction.

This is an unrestricted mathematical verification, with a separately
kernel-certified algebraic core. It is not a claim that the entire
geometric theorem has been formalized in Lean. Independent review of
the geometric argument and of statement fidelity is still required.
No false literal assertion of the staged manuscript has been established,
and no `F_...` refutation claim is warranted by the examples below.

## 1. Prior results, sources, and the excluded shortcut

The primary sources actually obtained are

* Andreas Horing, *Uniruled varieties with split tangent bundle*,
  arXiv:math/0505327v3, Theorem 1.4, PDF page 2. This gives a compatible
  product on a rationally connected manifold **if one summand is already
  integrable**.
* Andreas Horing, *Fano varieties with split tangent sheaf*,
  arXiv:2602.15427v1, Theorem 1.1, PDF page 1. This gives algebraic
  integrability on normal Q-factorial projective klt varieties **of
  Fano type**. Conjecture 1.5 on page 2 states the smooth rationally
  connected automatic-integrability problem.
* The same version, Example 4.3, PDF pages 14-15, gives a rationally
  connected Q-factorial klt split-tangent variety with a nonintegrable
  summand. Thus induction using the analogous assertion on all singular
  rationally connected klt varieties is not a valid route.

The downloaded PDFs and their `pdftotext -layout` text are beside this
argument; short locator excerpts are in the three `*_excerpt.txt` files.
The ledger records the external product result separately from the box
proof and records the Fano-type and singular-limit baseline. Source
attribution by an independent Reviewer has not been impersonated by the
Engineer.

No independent prior source proving the unrestricted tangent-box
assertion was obtained in the bounded literature lookup. The broad web
lookup returned mirrors of the very manuscript under audit; those are
not independent confirmations or evidence of novelty. The project Wiki
index had no relevant tangent-bundle or rational-connectedness entry.
No claim of a literature-wide novelty search is made.

The argument below uses elementary holomorphic Taylor calculus, line
bundles and sections on P1, finite-dimensional linear algebra, point
blowups of a smooth surface, and nonsingular linear holomorphic ODEs.
The nontrivial resolution and two-point-family statements are proved
below rather than borrowed. It invokes neither a G3 theorem, a
formal-to-algebraic comparison theorem, a very-free-curve existence
theorem, nor the deferred compact-Kahler universal-cover theorem.

## 2. The global formal Cauchy solution

Put C=P1, S=C x C, and let Delta be the diagonal. Work in the analytic
I-adic completion along the entire Delta. On a diagonal disk, take
u=s and v=t-s. Its functions are series with holomorphic u-coefficients;
normal convergence is not being asserted. Holomorphic functions of the
target are substituted by their Taylor series about g(u). Each
coefficient involves only finitely many Taylor terms.

Let P=P2 be the holomorphic projector onto E2. Solve

    F(u,0)=g(u),                 F_v=P(F)F_u.                 (2.1)

Writing F=sum(f_k(u)v^k), the coefficient equation is

    (k+1) f_(k+1) = [v^k](P(F)F_u).                         (2.2)

The right side depends only on f_0,...,f_k and their u-derivatives.
Taylor substitution preserves holomorphic coefficients. Division by
the nonzero complex integer k+1 therefore constructs every coefficient,
uniquely. This is a genuine all-orders induction, including f_0'=0.
There is no inverse derivative of g or F anywhere.

For the universal Lean recurrence, define rhs on an arbitrary coefficient
sequence by using the **fixed g** as its constant term, irrespective of
that sequence's zeroth entry, and its entries 1,...,k as the higher terms.
The coefficient of order k is then a finite Taylor polynomial, so rhs is
defined on every sequence and is causal. With initial entry g it is
exactly (2.2). This avoids pretending that Taylor substitution about g
is defined for an arbitrary different constant term.

Taylor substitution preserves P squared equals P. Hence (2.1) is
equivalent to

    P(F)F_v=F_v,              P(F)(F_u-F_v)=0.

Since partial_t=partial_v and partial_s=partial_u-partial_v, these
are exactly the prescribed factor tangencies, in the stated order.
The reverse implication follows by adding the two identities.

For a target coordinate change psi, the formal chain rule gives
D(psi(F))=dpsi(F)D(F); the projector changes by conjugation. Thus the
transformed solution solves the same intrinsic equation.

For an invertible source coordinate change s'=h(s), t'=h(t), one has

    u'=h(u),  v'=h(u+v)-h(u),
    partial_(v')=b partial_v,
    partial_(u')=a partial_u+(b-a)partial_v,
    a=1/h'(u),  b=1/h'(u+v).

Here v' is v times a formal unit, so this is an isomorphism of
completions. Applying P to the second derivative formula and using
P(F)F_v=F_v gives P(F)F_(u')=b F_v=F_(v'). The initial condition
also agrees. The uniqueness in (2.2) therefore makes the coordinate
solutions agree on every overlap, in both source and target. Their
Taylor substitution homomorphisms agree because those are determined
by the target coordinate series. This proves global existence and
uniqueness as a formal holomorphic map.

The causal sequence theorem in `Main.lean` formalizes the all-orders
recursion, for an arbitrary causal right side over a characteristic-zero
field. The idempotent and coordinate-covariance lemmas formalize the
associated linear identities. The analytic Taylor and sheaf
translations in this paragraph remain mathematical, not Lean, proofs.

## 3. Rational reconstruction, with an explicit uniform twist

In fact, let G be any formal holomorphic map along Delta to a closed
complex submanifold Y of PN. Its Taylor pullbacks of the transition
functions of O(1) are units satisfying the cocycle identity. They
therefore define a formal line bundle L. The homogeneous coordinate
sections pull back to global formal sections S_0,...,S_N, whose
reductions have no common zero. Reorder so S_0 is not identically
zero on Delta. The zero divisor of its reduction has some degree d>=0;
it identifies L restricted to Delta with O_C(d).

For m>=0 put M=L tensor O_S(m,m) in the completion and set

    V_k=H0(Delta, I^k M),       V=V_0.

The leading coefficient of a section induces an injection

    V_k/V_(k+1) -> H0(C,O_C(d+2m-2k)).                      (3.1)

Indeed I/I^2 is O_C(-2): the diagonal has bidegree (1,1), and
O_S(1,1) restricted to it has degree 2. Only the degree-zero frame
transitions act on each associated graded piece.

The filtration is separated, because a series with every coefficient
zero is zero. For all k beyond (d+2m)/2 the target in (3.1) is zero.
Consequently all V_k there are equal; their intersection is zero, so
they equal zero. There are only finitely many remaining successive
quotients, each finite-dimensional by (3.1). Induction up this finite
filtration proves V itself finite-dimensional; it is not assumed so.

Sections of O_C(e) for e>=0 are homogeneous polynomials of degree e,
so their dimension is e+1; a negative-degree line bundle has no nonzero
section, since a section would have an effective divisor of negative
degree. It follows that

    dim V <= H_d(m) := sum_(k>=0) max(d+2m-2k+1,0),
    H_(2q)(m)   = (m+q+1)^2,
    H_(2q+1)(m) = (m+q+1)(m+q+2).                          (3.2)

The displayed sums are respectively reversed lists of odd and even
positive integers. Their formulas and the finite-filtration numeric
inequality are certified for all indices in Lean.

Choose **m=2d+1**. If d=2q, the difference between the coordinate-pair
source dimension and the upper bound is

    2(4q+2)^2-(5q+2)^2 = 7q^2+12q+4 > 0.

If d=2q+1, it is

    2(4q+4)^2-(5q+4)(5q+5) = 7q^2+19q+12 > 0.             (3.3)

Both statements hold for every q>=0, not just for tested degrees.
For each nu>0 the linear map

    H0(S,O(m,m)) direct-sum H0(S,O(m,m)) -> V,
    (A,B) |-> A S_0+B S_nu

therefore has a nonzero kernel pair (A_nu,B_nu), since the source has
dimension 2(m+1)^2. This is ordinary finite-dimensional linear algebra.

Fix a connected diagonal disk D where S_0 has nonzero reduction and
is thus a formal frame. The section B_nu cannot be zero: otherwise
A_nu would have zero formal expansion along D, and its ordinary
convergent Taylor series and the identity principle would force the
ordinary polynomial section A_nu to vanish globally. Set

    q_nu=-A_nu/B_nu in C(S).

It remains essential to prove convergence at a common diagonal patch;
formal rationality by itself would not suffice. In product affine
coordinates write A_nu,B_nu as ordinary holomorphic functions a_nu,b_nu.
Let r_nu be the smallest normal index for which the coefficient of
b_nu is not identically zero on D. It is finite, by analytic Taylor
uniqueness and B_nu nonzero. Choose one point p in D outside the zeros
of all the finitely many leading coefficient functions.

The formal relation a_nu+b_nu S_nu/S_0=0 forces the coefficients of
a_nu below r_nu also to vanish. These are convergent holomorphic
functions, so **ordinary holomorphic** divisibility holds near p:

    a_nu=v^r_nu a_tilde_nu,  b_nu=v^r_nu b_tilde_nu,
    b_tilde_nu(p) != 0.

Cancel the same power in the formal relation; multiplication by v
is injective on the series ring. After shrinking once for all nu,
-a_tilde_nu/b_tilde_nu is holomorphic, and its expansion is S_nu/S_0.
Thus R=[1:q_1:...:q_N] is an ordinary rational map holomorphic on one
nonempty diagonal neighborhood, with precisely the given formal map.

Every local defining equation of Y composed with R has zero normal
Taylor series. Since the composition is an ordinary holomorphic
function, it is zero near p. Hence R takes values in Y there.
Local submanifold coordinates also show equality on all holomorphic
functions on Y, not merely on the chosen ambient coordinates.
This proves the reconstruction claim without an external G3 result.

## 4. Surface base points: actual finite termination

A rational map S -> PN has a representing tuple of bihomogeneous
polynomials of the same bidegree after clearing denominators. Remove
their common factors. A factor can be chosen bihomogeneous by comparing
highest and lowest degrees in each of the two variable groups.

In each affine product chart the tuple has no common polynomial factor:
bihomogenization of a common affine factor would give a common global
factor. Its gcd in C(x)[y] is therefore one. A Bezout identity, with
denominators cleared, puts a nonzero polynomial in x in its ideal.
Doing the same after interchanging x,y puts a nonzero polynomial in y
there. The common zero set is finite in each of the four charts, hence
finite globally. At a base point the completed local base ideal
I in D=C[[x,y]] contains powers of x and y and has finite colength.

Let k>=1 be its minimum order. Blow up the point; in the chart
(x,z) -> (x,xz) divide each pulled-back generator f_nu by x^k.
The divided tuple is holomorphic. Its base points on the exceptional
P1 are common zeros of the degree-k initial forms; at least one such
form is nonzero, so there are finitely many children.

Center a surviving child at (0,0), after a linear change downstairs.
Set J=(x^(-k)f_nu(x,xz)) in C[[x,z]] and D'=C[[x,z]]/J.
A power x^ell in I gives x^(ell-k) in J. Thus x is nilpotent in D'
(a surviving child rules out ell=k). Modulo x, a nonzero initial
form is a polynomial in z of degree at most k. At this child it is
z^q times a unit for 1<=q<=k. Hence D'/(x) is spanned by
1,z,...,z^(k-1). Lift successively through the finitely many powers
of the nilpotent x: D' is spanned by finitely many x^a z^b with b<k.

There is a **linear**, not ring-linear, surjection

    m^k/I -> D',       h |-> x^(-k)h(x,xz).                 (4.1)

For a monomial of degree at least k the transformed x-exponent is
nonnegative. The transformed order tends to infinity with the original
order, so the operation is defined on all formal series. If h=sum q_nu
f_nu belongs to I, its transform is a sum q_nu(x,xz) times generators
of J. Thus it descends to the quotient. Each spanning x^a z^b, b<k,
has preimage x^(a+k-b)y^b in m^k. This proves surjectivity.

Since the monomials of total degree <k number k(k+1)/2,

    length(D') <= length(m^k/I)
               = length(D/I)-k(k+1)/2 < length(D/I).        (4.2)

This is strict at every surviving child, not merely at the first
blowup. A branch has length bounded by its initial colength. There
are finitely many roots and finitely many children at every vertex;
finite branching and bounded depth make the whole tree finite.
The resulting finite point-blowup sequence mu:S' -> S resolves R.

The two divided affine tuples agree projectively on chart overlaps.
Every exceptional component is a smooth strict transform of an
exceptional P1. The fibers are connected: a blowup replaces its
center by a connected P1 meeting the strict transforms of all
components through that center. This property persists inductively.

Lean certifies the unrestricted preimage exponents in (4.1) and the
strict numeric descent in (4.2). The ideal-quotient and finite-branching
arguments in this section are explicit geometric/algebraic proofs,
not encoded in the formal source.

## 5. Complementary tangency eliminates every exceptional component

Apply Section 3 to the formal Cauchy solution and the embedding of X.
On the initial diagonal patch the ordinary analytic tangency
expressions have zero Taylor expansion, hence vanish. By Section 4,
R is holomorphic as a PN-valued map off a finite set B.
The complement S minus B is connected: paths in the real
four-manifold S can be perturbed inside coordinate balls to avoid
finitely many points.

The inverse image of the closed complex submanifold X is analytic,
contains the initial open patch, and is therefore all of S minus B.
Both tangencies are then zero holomorphic bundle morphisms there by
the identity principle. This establishes the hypotheses used next;
they were not assumed to persist through indeterminacy.

Let mu:S' -> S be the resolution, and let F':S' -> X extend R.
Its image lies in X since it does on a dense open set and X is closed.
At a base point p choose source factor coordinates s,t. On S',
the vector-valued holomorphic two-forms satisfy

    (P1 dF') wedge d(s composed with mu)=0,
    (P2 dF') wedge d(t composed with mu)=0.                 (5.1)

Off the exceptional locus these follow from the prescribed factor
directions; holomorphicity extends them across that locus.

Fix any exceptional component H over p, including one created by
later blowups. Both s composed with mu-s(p) and t composed with mu-t(p)
vanish on H but are not identically zero on its neighborhood, since
mu is an isomorphism on a dense open set. Their generic orders
alpha,beta are finite positive integers. At a general point of H,
away from other components and from the leading-coefficient zeros,
choose r=0 as its local equation and write

    s composed with mu-s(p)=r^alpha h,
    t composed with mu-t(p)=r^beta k,                       (5.2)

with h,k holomorphic units.

The first equation of (5.1) becomes

    r^(alpha-1) (P1 dF') wedge (alpha h dr+r dh)=0.

The local ring of a smooth surface is a domain and the module of
bundle-valued two-forms is locally free. Cancel r^(alpha-1) **before**
restricting to r=0. Restricting the un-canceled equation would lose
all information when alpha>1. For w tangent to H and n with dr(n)=1,
the canceled equation evaluated on (w,n) gives

    alpha h P1 dF'(w)=0.

The scalar alpha h is nonzero over C. Thus P1 dF'(w)=0.
The second equation, canceled by r^(beta-1), gives P2 dF'(w)=0.
Their sum is dF'(w)=0. No inverse of dF' is used.

The derivative of F' restricted to H is zero on a dense open set,
hence everywhere, so F' is constant on H. Constants agree on
intersecting components. Connectedness of each exceptional fiber
therefore makes F' constant on every fiber of mu.

As a map from a compact space onto a Hausdorff space, mu is a quotient
map. The fiberwise constant F' descends to a continuous F:S -> X,
holomorphic off B. Continuity puts its image near any p in B in a
single target coordinate chart. Each coordinate function is continuous
and holomorphic off p. On coordinate lines through p the
one-variable removable-singularity theorem applies; on the other
lines it is already holomorphic. Separate holomorphicity and the
iterated Cauchy formula give joint holomorphicity. Hence F is
holomorphic on all S.

The removal statement itself is local and also holds for a product of
arbitrary smooth algebraic curves. On a smooth surface, cancel the fixed
divisorial part of a representing tuple locally; the remaining base
ideal has finite colength at each base point. The same completed-local
calculation (4.1)-(4.2) resolves it. The finite-type base locus is finite.
For a noncompact source the finite blowup map is proper, hence closed
and quotient, replacing the compactness argument above. The identical
local coordinate-line removal finishes descent. Thus the source P1
hypothesis is used for reconstruction and transport, not for the
complementary-tangency obstruction to indeterminacy.

The factor tangencies extend by holomorphicity. F restricted to Delta
and g agree on the initial patch and thus everywhere. This proves
existence in the verification theorem.

The domain/torsion-free cancellation and arbitrary positive
alpha,beta scalar argument have separate universal Lean theorems.
The Jacobian calculation is an exact diagnostic at alpha=4, not a
substitute for the arbitrary-order argument.

## 6. Uniqueness and reparametrization

Any holomorphic box satisfies (2.1) and has initial value g. Its
Taylor expansion is the unique formal solution of Section 2.
Two boxes thus have identical coordinate Taylor series on a common
diagonal patch and, being holomorphic, agree on a neighborhood.
Their equality locus is analytic (the inverse image of the diagonal
in X x X), so the identity principle on connected S makes them
equal everywhere. Constant maps cause no exception.

For every holomorphic phi:P1 -> P1 the map F_g composed with
(phi x phi) is holomorphic, has diagonal g composed with phi, and
has the required factor tangencies by the chain rule, even where
dphi=0. Uniqueness proves the asserted naturality.

## 7. Transport does not introduce integrability through the back door

For i!=j define a partial connection on E_i by

    nabla^i_xi e=P_i[xi,e],    xi in E_j, e in E_i.

The identities

    nabla_(f xi)e=f nabla_xi e,
    nabla_xi(f e)=xi(f)e+f nabla_xi e

follow from the bracket rules and P_i(xi)=0. They do not involve
bracketing two E_j sections. Thus no involutivity of E_j is used.

On a box, a vertical vector field V for pr_i maps to E_j. In frames
e_lambda of E_i, xi_gamma of E_j, write

    nabla_(xi_gamma)e_lambda=sum_nu Gamma_(gamma,lambda)^nu e_nu,
    dF(V)=sum_gamma h_gamma F*xi_gamma.

On a pulled-back section sum f_lambda F*e_lambda define D_V by
differentiating f_lambda along V and adding
sum f_lambda h_gamma (Gamma_(gamma,lambda)^nu composed with F)F*e_nu.
The two displayed connection rules and the chain rule prove the
frame transformation law, so this defines a holomorphic relative
connection for pr_i. At a critical point all h_gamma for a zero
dF(V) are zero; the formula is still valid. No inverse differential
or immersion assumption occurs.

On each fiber P1 its curvature is a two-form on a curve and is zero.
The local horizontal linear ODE is nonsingular. Solutions continue
along a path by a finite chain of charts; local uniqueness gives
inverse transport on the reverse path. Flatness gives homotopy
invariance, and the simple connectedness of P1 gives path
independence. Transport from the unique diagonal point of a fiber
therefore gives

    Theta_i:pr_i*(g*E_i) -> F*E_i,

an isomorphism equal to the identity on the diagonal. These are
holomorphic isomorphisms: in each finite chain of frames the
solution matrix of the linear ODE is holomorphic in the base and
the endpoints, as follows from normally convergent Picard iteration
on smaller disks. Compositions remain holomorphic and path
independence makes them agree globally. No assertion about a
connection flat in several E_j directions is made or needed.

## 8. The exact automatic-integrability consequence

Assume now X connected and two general points lie on an image of P1.
Here are the details supplying the required family, rather than an
uncited assertion about very free curves.

Every holomorphic P1 -> PN is a tuple of homogeneous polynomials of
one degree with no common zero: pull back O(1), identify it with
O(d), and use its coordinate sections. For each d these tuples form
an open subset M_d of a finite-dimensional vector space and have a
universal holomorphic evaluation.

A proper analytic subset A of a connected second-countable complex
manifold is covered by countably many lower-dimensional complex
submanifolds, not necessarily contained in A. To check this, choose
countably many coordinate neighborhoods with a non-identically-zero
defining holomorphic function f. At a zero of order r, an
(r-1)-st partial derivative of f vanishes there and has nonzero
differential. Its regular zero locus is a hypersurface through the
point. Countably many derivatives, charts, and connected components
give the claimed covering.

For each connected component M of M_d, accept it if all its maps
land in X. Otherwise choose a mark c with one evaluation outside X.
The tuples whose evaluations at c land in X form a proper closed
analytic subset of M containing all desired tuples. Cover it as
above by countably many lower-dimensional submanifolds and repeat.
Every desired tuple survives; extra points in a covering manifold
are tested anew. Dimension strictly decreases whenever a family
is not accepted, so the process has finite depth. In dimension
zero it accepts exactly the desired points. Over all d this
produces countably many manifold families of maps to X covering all
holomorphic P1 -> X maps.

Fix distinct marks a,b. Reparametrization of rational curves shows
the images of the two-point evaluations of these families cover a
nonempty Zariski open subset of X x X. At least one such evaluation
has full rank somewhere. Indeed a holomorphic map of everywhere
rank less than dim(X x X) has measure-zero image: its maximal-rank
locus has such an image by the constant-rank theorem; its complement
is proper analytic, so the covering observation and induction on
the domain dimension handle it too. Countable local charts and
families preserve measure zero and cannot cover a nonempty open
subset of X x X.

Restrict that family to its nonempty submersion locus T, obtaining
G:P1 x T -> X with two-point evaluation submersive. At any member
g, differentiating the family gives global sections of g*TX.
For every w at g(b), surjectivity gives a section with values 0,w
at a,b. Applying P_i yields sections of g*E_i vanishing at a whose
values span E_i at g(b).

The projected bracket

    B_i: exterior-square(E_i) -> E_j,    B_i(e,e')=P_j[e,e']

is a holomorphic bundle morphism because all scalar-derivative
terms lie in E_i and are killed by P_j. Its vanishing is precisely
integrability of E_i.

Take the box of g. On the factor line L_i with the complementary
coordinate fixed at b, transport identifies F*E_i with g*E_i and
F*E_j with the trivial bundle having fiber E_j at g(b). For any
two global sections u,v of g*E_i vanishing at a, the transported
value of F*B_i(u wedge v) is a holomorphic section of this trivial
bundle on P1, so it is constant. It is zero at a and therefore at b.
At (b,b), F=g and both transports are the identity. Thus

    B_i(g(b))(u(b) wedge v(b))=0.

The values u(b) span E_i at g(b); their pairwise wedges span its
exterior square, so B_i vanishes there. The image of ev_b:T -> X
is nonempty and open, since it is a submersion. Both bracket tensors
therefore vanish on an open set and, by the identity principle on
connected X, everywhere. This proves automatic integrability in
every positive pair of ranks.

Invoking the separately recorded Horing Theorem 1.4 then gives a
compatible product. That final corollary has an external dependency;
the construction and integrability argument just proved do not.
Nothing here certifies the distinct Hartogs/mixed-boundary route in
the compact-Kahler companion paper.

## 9. What the exact and formal certificates do, and do not, say

`verify.py` uses exact rational polynomial arithmetic and the recorded
typed Jacobian result. It checks the coefficient identities in (3.3),
the order-four normal wedge cancellation, and a genuinely
nonintegrable affine local model:

    E1=span(partial_x, partial_y+x partial_z),
    E2=span(partial_z),
    g(u)=(u^2,u^3,u^5),
    F(s,t)=(s^2,s^3,(3s^5+2t^5)/5).

From the campaign root, replay with
`$WORKSPACE/argus-live-update/.venv/bin/python research/tangent_box_certificate/verify.py`.
It needs only the Python standard library and the preserved compiler
and Jacobian records; it does not pretend to run a geometric proof checker.

Here [partial_x,partial_y+x partial_z]=partial_z is not in E1.
Nevertheless the displayed F is an exact tangent box and dF(0,0)=0.
This verifies the local mechanism even with nonintegrability and a
critical map. This affine model is **not** a projective counterexample:
the polynomial g has poles at infinity and is not a holomorphic
P1 -> affine-three-space map. The model establishes no global
geometric conclusion by itself.

The Jacobian operation is
`polynomial.multivariate.divide.compute`, server version 0.14.0,
MCP protocol 2025-11-25. For the one-form A=a dr+b dz and
s=r^4(1+z+r), the dr-wedge-dz coefficient of A wedge ds is

    r^4 a-5r^4 b-4r^3 z b-4r^3 b.

Exact division by r^3 gives

    r a-5r b-4z b-4b,

with zero remainder. At r=0 this is -4(1+z)b, precisely the
nonzero-leading-unit obstruction. Discovery, inspected input/output
schemas, exact payload, typed output, and adapter exit status are
preserved in separate JSON files. This is one bounded exact
calculation; the all-multiplicity conclusion is Section 5 and the
universal Lean argument, not an extrapolation from this calculation.

The Python checker also requires a fresh successful Lean 4.31.0
compiler record, no proof holes, the actual source and statement
fidelity digests, and the corresponding mechanically recorded
`C_ALG_CORE` evidence. It does not award a mechanical verdict to
`C_BOX` or `C_INTEGRABILITY`.

The substantive advance over the prior ledger is a full unrestricted
argument through the selected construction and its integrability
consequence, rather than a bounded search or an isolated projector
identity. Over the manuscript's stated box proposition, the argument
also records uniqueness, self-map naturality, and the explicit
m=2d+1 reconstruction bound. Whether this independent verification
and its formal certification meet the campaign's publishability and
novelty bar remains for the Host-invoked independent Reviewer; no
such acceptance is manufactured in the certificate.
