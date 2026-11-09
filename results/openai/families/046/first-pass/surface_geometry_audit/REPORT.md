# From the reviewed quotient to the projective surface

## Result, scope, and dependency boundary

This is an independent universal verification of the **remaining geometric
implication** in the surface manuscript, with the same dyadic scope as the
accepted algebraic input. No counterexample to its geometric lemmas was
found. The argument below proves the surface conclusion for every
`n=2^r`, `r>=2`, using the actual family, not a surrogate family with a
similar finite monodromy.

The established input is mission `84ee177ee388`, accepted by the independent
Reviewer in
`$WORKSPACE/.argus-campaign-9000046/projects/87e68093bad5/handoffs/84ee177ee388/round-0001.json`.
Its reason explicitly accepts the actual-family infinite quotient and
based monodromy invariance, but not either manuscript's main theorem.
`research/surface_weighted_audit/REPORT.md`, `verify.py`, and
`exact_certificate.json` are reused **unchanged**. The pre-existing
Reviewer judgements on `S_DYADIC`, `S_QUOTIENT`, and their algebraic
dependencies are retained, not repeated. The proof graph now reflects that
receipt; the new geometric nodes remain unconfirmed.

Compared with that strongest prior result, this report supplies the missing
passage to a smooth projective surface and to an actual compact rational
curve of infinite fundamental-group image. It also identifies the entire
distinguished fiber's dual graph as a coset-incidence graph, with an exact
component and first-Betti-number formula. The local-detection and
rational-string mechanisms themselves are classical; no independent
novelty or publishability verdict is claimed here.

**Certification boundary.** Sections 1--8 are universal mathematical
proofs, submitted for normal Host-invoked independent review.
`Main.lean` formalizes only the universal group-theoretic descent core.
`verify.py` checks exact local lattice, meridian, ramification, and
incidence-graph certificates. Neither the finite calculations nor the
Lean declarations encode algebraic geometry, the infinitude of the
reviewed quotient, or holomorphic functions. Passing them must not be
reported as kernel verification of the whole surface theorem.
The fourfold construction is outside this mission.

## Sources fixed before the proof

The assumptions were entered in `research/MATH_STATE.json` before the
proof development. Actual passages, application hypotheses, and the
primary PDF locations are in `sources/primary-propositions.txt`.

| Input proposition | Use and checked hypotheses |
|---|---|
| SGA 1, arXiv:math/0206203v2, XII, Theorem 5.1 | Algebraizes the finite unramified cover of the nonproper complex surface `U`. Locally finite type is enough. Its earlier independent attribution is reused: `research/literature/d8c13d38de66a01768cbc28cc5f69e49.json`. |
| Stacks, Tags 035B and 03GR | `Y` is finite type over a field, hence Nagata; `U' -> Y` is finite type and `U'` is reduced. Thus relative normalization is finite. |
| Stacks, Tag 0B3I | The finite normalization morphism is projective. |
| Encinas--Hauser, DOI 10.1007/PL00012443, pp. 822--823, “The result” | Strong resolution for reduced finite-type characteristic-zero schemes, by projective ambient blowups, is an isomorphism over the regular locus. The normalization is a projective complex surface. |
| Stacks, Tags 0BI4 and 0BIC, including the latter's proof | On the resolved regular surface, every algebraic boundary component has finite normalization. Point blowups resolve the boundary. The described centers can avoid the already strict-normal-crossings open set. |
| SGA 1 XII, Propositions 2.1(iv),(vi), 3.2(vi), and 5.3 | Analytification preserves regularity, normality, and finiteness under their stated finite-type hypotheses. Finite normal analytic covers are uniquely determined by restriction off a closed analytic subset with dense complement. The coordinate polydisk is normal and every cover component dominates it. |
| Lojasiewicz, *Triangulation of semi-analytic sets* (1964), Section 3, Theorem 2, p. 464, with property (c) | The compact real analytic manifold `X` and its closed semianalytic subset `Z` admit a compatible locally finite triangulation. Compactness makes it finite; compatibility and closedness make `Z` a subcomplex. |

The new source readings are Engineer readings, not independent citation
attributions. The next Reviewer must attribute them using the preserved
passages. The earlier SGA 1 Theorem 5.1 citation is already independently
checked and is not being reopened. The inherited Wiki index contains no
pertinent surface-family result; it supplied no mathematical premise.

One rejected shortcut is important: detecting each cyclic meridian image
separately need not detect the local group at a crossing. Section 3 gives
an exact countermodel to that weakened hypothesis. It is not a
counterexample to the manuscript, whose hypothesis is the stronger one.

## 1. Verification theorem and the actual input

Let

\[
 E=\mathbb C/(\mathbb Z+\mathbb Z\omega),\quad
 \omega^2+\omega+1=0,\quad q:E\longrightarrow E/\{\pm1\}=\mathbb P^1.
\]

For `n=2^r`, `r>=2`, use the actual marked family defined by
`q[n]=f_n q` and the three targets `s,bar(omega)s,bar(omega)^2 s`.
The reviewed theorem provides a finite parameter cover `B' -> B`,
its smooth projective completion `C'`, a selected missing parameter
`c_*` of ramification index exactly two, and a compactification

\[
 g:Y\longrightarrow C',\qquad U=Y\setminus D,\qquad
 \rho:\pi_1(U)\longrightarrow Q.
\]

Here:

1. `Y` is a smooth connected projective complex surface and `D` is a
   reduced simple-normal-crossings divisor, obtained by separating the
   `3n^2` marked sections with point blowups.
2. `Q` is an infinite pro-2 group. The image of each punctured smooth
   fiber under `rho` is dense in `Q`.
3. Every component meridian of `D` has finite image in `Q`. Every
   vertical meridian of `D_*=g^{-1}(c_*)` is trivial.
4. `D_*` has one unmarked main sphere and
   `k=3n^2/2` disjoint rational tails. Each tail meets the main sphere
   once, carries exactly two horizontal markings, and has no other
   intersections. The two meridians in each pair have product one
   under the reviewed fiber homomorphism.

These are precisely the conclusions of the accepted report, including
its Section 8, not additional unverified algebraic hypotheses. For
clarity about the last geometric identification: the actual local
equation of a colliding pair is `w^2=s-s_*`; the index-two parameter
cover makes the branches `w=+u` and `w=-u` after analytic coordinate
changes. Blowing up their common point gives a tail with the two
separated sections at slopes `+1,-1`. The main component meets it at
the other chart's point. Distinct pairs are in disjoint disks. At
other missing parameters, separation terminates because each blowup
at a common section point decreases pairwise intersection
multiplicities. A section cannot pass through a vertical node
`t=xy`, since `dt=0` there whereas its composite with `g` has
derivative one. Thus subsequent centers are smooth points of
multiplicity-one vertical components, and the reduced boundary is SNC.
No new assumption about an abstract “similar” family is introduced.

**Theorem.** For every such actual family and every quotient furnished
by the reviewed theorem, there are a connected finite Galois cover
`U' -> U`, a smooth connected projective surface `X` containing `U'`,
and `p:X -> Y` extending that cover, such that:

* `rho` restricted to `pi_1(U')` descends to `pi_1(X) -> Q`;
* `Z=(g p)^{-1}(c_*)_red` is a nodal union of smooth rational curves;
* a connected component `Z_0` has infinite image in `pi_1(X)`;
* every connected lift of `Z_0` to the universal cover of `X` is a
  closed noncompact locally finite rational string, and the
  holomorphic hull of each of its points is noncompact.

In fact, for the reviewed pair-boundary factorization `Z` itself is
connected; Section 6 identifies its graph and its first Betti number.
The theorem gives the manuscript's main theorem at `n=4`, and the same
conclusion for every reviewed dyadic `n>=4`. It makes no claim that
these surfaces are pairwise nonisomorphic.

## 2. Finite local detection for arbitrary finite local images

We prove `lem:local-detection` in the more general setting of an
arbitrary profinite target `Q`; it need not be pro-2 or finitely
generated. At a boundary point choose a polydisk

\[
 V^\circ=V\setminus D\simeq
 (\Delta^*)^a\times\Delta^{2-a},\qquad a\in\{1,2\}.
\]

Its fundamental group is `Z^a`. Its image `A_V` in `Q` is generated
by `a` commuting elements of finite orders `e_1,...,e_a`. It is a
quotient of the finite product of these cyclic groups; in particular
it is finite, including when some `e_i=1` or there are mixed
relations. No independence of the two cyclic images is assumed.

There are finitely many local subgroup types up to conjugacy.
There are finitely many irreducible components and crossings of
the projective SNC divisor. The smooth stratum of each irreducible
component is connected after deleting its finitely many crossings.
Transport along that stratum identifies its cyclic meridian
subgroup up to an access-path conjugation. Each crossing supplies
one further finite local group. Choose representatives `A_1,...,A_b`.

For each nonidentity element `a` of their finite union, the
profinite separation property gives an open normal subgroup `N_a`
of `Q` not containing `a`. Set

\[
 N=\bigcap_{a\ne1}N_a,\qquad P=Q/N .
\]

An empty intersection is `Q`, so trivial local images cause no
exception. This is a finite intersection: `N` is open and normal,
`P` is finite, and `N cap A_i={1}`. Normality gives the essential
conjugacy-uniform statement

\[
 N\cap gA_i g^{-1}=\{1\}\quad\text{for all }i,\ g\in Q.       \tag{2.1}
\]

Equivalently, `Q -> P` is injective on every local group.
Density makes `pi_1(U) -> P` onto. Its kernel defines a
**connected regular** finite topological cover `U' -> U` with
deck group `P`. Lifting local complex charts makes this a finite
etale analytic cover. SGA 1 XII 5.1 algebraizes it, with no
properness hypothesis on `U`.

### Projective normalization and prescribed-open resolution

Normalize `Y` in the function field of the connected smooth cover
`U'`. A connected smooth variety is irreducible, so this field is
well-defined. By Tags 035B and 03GR this gives a finite morphism
`n:Ybar -> Y`, restricting to `U'` above `U`. The hypotheses are
checked in the source ledger, not replaced by an assertion that
every analytic normalization is finite. Tag 0B3I makes `Ybar`
projective.

Embed `Ybar` in a projective space and apply the cited strong
resolution. Its resolved strict transform is smooth and
projective; the induced morphism is an isomorphism over the
regular locus of `Ybar`. Resolve the reduced inverse-image
boundary on this smooth surface by point blowups as in Tag 0BIC.
Each boundary component is an integral finite-type complex
curve; Tags 035B, 03GR, and 0BI4 verify the finite-normalization
hypothesis in 0BIC.

The point centers can be confined to singular component germs,
nontransverse intersections, and points with at least three
branches. They are unnecessary in the smooth SNC locus.
Consequently the resulting

\[
 X\xrightarrow{r}Ybar\xrightarrow{n}Y,\qquad p=nr,
\]

is smooth and projective, unchanged over `U'`, and its reduced
boundary `D_X=X\setminus U'` is SNC. It preserves the entire
open locus where `Ybar` and its reduced boundary were already
smooth and SNC. This is the prescribed-open property needed
below; resolution of the surface alone would not have supplied
it for the boundary. The dense open `U'` is connected, hence so
is `X`.

## 3. Every resolution meridian is killed

The inclusion `i:U' -> X` induces a surjection on fundamental
groups. A loop in the real four-manifold can be perturbed away
from the real-codimension-two boundary. Its kernel is normally
generated by all boundary-component meridians: perturb a
null-homotopy disk relative to its boundary to miss the finite
set of boundary crossings and to meet each smooth boundary
stratum transversely. Delete small disks around its finitely
many intersection points. The resulting punctured disk writes
the original loop as a product of conjugates of meridians and
their inverses. This proves both directions of the asserted
normal-generation statement.

Let `E` be **any** irreducible component of `D_X`, including one
exceptional for `r` and contracted to a crossing downstairs.
Choose a smooth point `x` of `E`, away from all other components,
and a small transverse disk `T` with `T\setminus{x} subset U'`.
Its image can be made to lie in a boundary polydisk `V` at
`p(x)`. The projected meridian consequently belongs, after its
access path, to a conjugate of `pi_1(V^\circ)`. Its `Q`-image
lies in a conjugate of `A_V`.

The same projected loop is in the kernel of `pi_1(U) -> P`,
because it is the projection of a **closed** loop in `U'`.
Its `Q`-image therefore also belongs to `N`. By (2.1) it is
one. This proof includes all exceptional meridians without
assuming that they are powers of individual original
meridians, or that a cyclic quotient singularity is the only
possible local normalization.

Normal generation now gives the unique homomorphism

\[
 \rho_X:\pi_1(X)\longrightarrow Q,\qquad
 \rho_X i_*=\rho\pi_* .                                    \tag{3.1}
\]

The algebraic implication used here is formalized, for arbitrary
groups, local subgroups, conjugates, and generating sets, in
`Main.lean`. Finiteness and geometry supply its hypotheses;
they are not hidden in that formal statement. The resulting
image is contained in `N`, not generally dense in all of `Q`.

The local lattice calculations also have an all-order explanation.
For commuting finite-order elements `alpha,beta`, let
`a=ord(alpha)` and let `c` be the order of the class of `beta`
in `<alpha,beta>/<alpha>`. There is a unique `0<=b<a` with
`alpha^b beta^c=1`. Any relation has its second exponent divisible
by `c`, and, after subtracting that multiple of `(b,c)`, its first
exponent is divisible by `a`. Hence

\[
 \ker((x,y)\mapsto\alpha^x\beta^y)
       =\mathbb Z(a,0)+\mathbb Z(b,c).                       \tag{3.2}
\]

Conversely the two displayed vectors are relations, proving equality
for all integer exponents, including negative orientations. The
index is `ac`, not necessarily `ord(alpha)ord(beta)`. This is the
universal identity behind the finite exhaustive kernel checks.

### An exact adversarial countermodel to a tempting weaker lemma

Take the local image `A=C2 x C2`, with original meridians
`a=(1,0)`, `b=(0,1)`. Let `A -> C2` be addition. It is
injective on `<a>` and `<b>` separately but not on `A`.
If a projective ambient realization is desired, take
`Y=P1 x P1`, its four coordinate boundary curves,
`U=(C*)^2`, and the homomorphism `Z^2 -> C2 x C2`
given by the two coordinate parities. It is surjective;
the addition quotient detects every component's cyclic
meridian subgroup. The following defect occurs at a
boundary crossing in this actual compactification.
The associated local cover has normalization

\[
 z^2=uv .
\]

 The quadric ring is the invariant ring
 `C[x,y]^{(x,y)->(-x,-y)}=C[x^2,xy,y^2]`, hence normal:
 an invariant fraction integral over it is integral over the
 normal polynomial ring and therefore is an invariant polynomial.
 This identifies a finite normal extension with precisely the
 addition monodromy, rather than only an equation with the
 desired exponent pattern.

 On a resolution chart it is parametrized by
`u=s, v=s t^2, z=s t`. At a generic point of the exceptional
curve `s=0`, its meridian projects to exponent vector `(1,1)`.
This is in the kernel of the chosen `C2` quotient but has
nontrivial `A`-image `(1,1)`. The two adjacent cones have
determinant two, the index of the parity-kernel lattice, so
this is also the regular toric resolution chart.

Thus cyclic-only detection genuinely fails to descend the
original map across resolution. The manuscript avoids this
obstruction by detecting the **entire** local group. The
certificate checks the countermodel and must reject changing
its exceptional image to one.

## 4. The actual distinguished fiber survives unchanged by resolution

All vertical meridians along `D_*` are trivial in `Q`, hence
also in `P`. Analyze every kind of boundary point on `D_*`.
The local restriction of the regular cover splits into
components classified by the kernel of `Z^a -> P`.

* At an unmarked smooth vertical point, the kernel is `Z`;
  the normal extension of each local cover is the identity
  polydisk.
* At a main--tail node, both vertical meridians are trivial.
  The kernel is all of `Z^2`, so again each local extension
  is an identity polydisk, with the two transverse branches.
* At a horizontal--vertical intersection, use vertical `u=0`
  and horizontal `v=0`. If the horizontal image has exact
  order `e`, then

\[
 \ker\bigl(\mathbb Z^2\longrightarrow P\bigr)
       =\mathbb Z\times e\mathbb Z .
\]

  Indeed `(a,b)` maps to the `b`th power of that one horizontal
  element. This proves the kernel identity for **every** finite
  `e`, not just the orders tested in the certificate. The finite
  normal extension is explicitly

\[
 (u,w)\longmapsto(u,w^e).                                  \tag{4.1}
\]

  Its domain is smooth and its reduced boundary is `uw=0`,
  including `e=1`. At a point of `D_*` there cannot be a third
  boundary branch, by the already verified SNC construction.

These explicit finite normal covers are not merely formal
models. The analytification of the algebraic normalization
is finite and normal by SGA 1 XII 3.2(vi), 2.1(vi).
On each polydisk its restriction to the boundary complement
is the same classified cover. SGA 1 XII 5.3 extends the two
inverse isomorphisms uniquely, identifying the actual
normalization with these models. All components dominate
the polydisk, as required by XII 5.0. Proposition 2.1(iv)
also identifies the algebraic regular locus. Thus the
entire inverse image of `D_*` is already in the good SNC
open locus, and the resolution of Section 2 is the identity
there. There are no additional exceptional components over
this fiber.

Every component above the main sphere is unramified,
including at the attaching nodes. There are no horizontal
markings on the main sphere. A connected unramified cover
of the simply connected sphere is degree one, so each such
component is a smooth sphere.

A component above a tail can branch only over its two
markings, and is unramified at its attaching node.
Deleting those two points and their preimages leaves
a connected finite cover of `C*`. Using its exponential
universal cover, a connected degree-`d` cover is the
subgroup `d Z` of `Z`, and is isomorphic to `z -> z^d`.
Its extension at both missing points is the corresponding
disk map, so its smooth compactification is `P1`.
Equivalently Riemann--Hurwitz reads

\[
 2-2g=2d-2(d-1)=2 .
\]

The local identity models at nodes show that these smooth
rational components meet only in ordinary transverse nodes.
This proves `lem:rational-special-fiber` for the actual
normalization and the chosen actual resolution.

## 5. Infinite image transfers to a compact component

Write `h=gp:X -> C'`, and let `F_s subset U` be a punctured
smooth fiber. Its image `H_s=rho(pi_1(F_s))` is dense in `Q`.
The finite quotient image is all of `P`, so the inverse
image `F'_s subset U'` is connected. Covering-space
classification identifies its group with the preimage
of `N` in `pi_1(F_s)`. Its `Q`-image is exactly

\[
 H_s\cap N .                                                \tag{5.1}
\]

Since `N` is open, every nonempty open subset of it meets
`H_s`; thus (5.1) is dense in `N`. The open subgroup `N`
is infinite: otherwise its finitely many cosets would make
`Q` finite. A finite subset is closed in the Hausdorff
group `N`, so a dense subset of infinite `N` is infinite.
By (3.1), `pi_1(F'_s)` consequently has infinite image in
`pi_1(X)`. No false assertion that a dense subgroup
intersects every closed subgroup densely is used: openness
of `N` is essential.

Here is the complete specialization argument. Regard `X`
as a compact countable real analytic manifold and the
closed analytic curve `Z=h^{-1}(c_*)_red` as semianalytic.
The cited compatible triangulation gives a finite
simplicial pair `(K,A)` representing `(X,Z)`.
Barycentrically subdivide. A simplex of the subdivision
is a chain of original simplices; if all its vertices are
in the subdivided `A`, its largest original simplex is
in `A`. Hence `A` is now **full**.

For a point with barycentric coordinates `(lambda_v)`, put
`s_A=sum_{v in A} lambda_v`. On the open set `V={s_A>0}`
define `R` by discarding coordinates outside `A` and
dividing the others by `s_A`. Fullness places the result
in `A`. The formula agrees on faces, so is continuous.
The straight-line homotopy from the original point to
`R` stays in the same simplex and in `V`, and fixes `A`.
It is a strong deformation retraction `V -> Z`.
Without the fullness step this particular formula need
not map into `Z`.

The compact set `X\setminus V` has closed image under the
proper map `h`, and that image excludes `c_*`. Thus every
whole fiber over a sufficiently small neighborhood of
`c_*` is contained in `V`. Choose a punctured smooth
parameter `s` there. The connected `F'_s` lies in one
component of `V`, whose retraction lands in a component
`Z_0` of `Z`. The inclusion `F'_s -> X` is homotopic to
a map through `Z_0`; on fundamental groups this is a
factorization up to the harmless access-path conjugation.
Its infinite image therefore lies in the image of
`pi_1(Z_0) -> pi_1(X)`. This proves
`lem:infinite-special-image`.

This does not identify a nearby punctured fiber group
with the special fiber group, nor assume a fibration
across the singular parameter.

## 6. Structural verification: the fiber's exact incidence graph

The rationality argument identifies more than the component
genera. Label the `P` lifts of a point on the unmarked main
sphere by `p in P`, using left deck transformations.
For tail `j`, choose an access path in the main sphere and
let `a_j in P` be the monodromy of its first marking.
The second marking has monodromy `a_j^{-1}`, because
the attaching-node meridian is trivial. Set

\[
 C_j=\langle a_j\rangle,\qquad e_j=|C_j|,\qquad
 H=\langle a_1,\ldots,a_k\rangle .
\]

The main sphere's covers have degree one, giving vertices
`P`. Components above tail `j` are exactly the local
monodromy orbits `p C_j`, giving vertices `P/C_j`;
each maps with degree `e_j`. The attaching node has
trivial local group, giving one edge `(p,j)` for every
`p in P`, between the main vertex `p` and tail vertex
`p C_j`. Distinct edges above that node meet distinct
degree-one main components. This proves the graph
description for the **actual normalized fiber**, not
just an abstract graph with the same counts.

A path among main vertices changes a label by products
of the `a_j` and their inverses. Its components are
therefore the cosets `p H`. The exact counts are

\[
 \begin{split}
 c&=[P:H],\\
 V_{\rm graph}&=|P|+\sum_j|P|/e_j,\qquad
 E_{\rm graph}=k|P|,\\
 b_1&=|P|(k-1)-\sum_j|P|/e_j+[P:H].                         \tag{6.1}
 \end{split}
\]

This includes trivial `a_j`, repeated subgroups, arbitrary
finite `P`, and disconnected inverse-image fibers. Van
Kampen applies because the curve components are simply
connected and the only identifications are nodes; the
curve group is its graph group. A star of spheres
downstairs need not remain a tree upstairs.

For the actual reviewed quotient, each pair boundary is
already killed. The sphere presentation on the two
meridians per pair, after imposing those products equal
one, is the free group on one meridian from each of the
`k` pairs: the total sphere relation becomes redundant.
The reviewed dense fiber map factors through this
presentation. Hence the images of these `k` meridians
topologically generate `Q` and generate its finite
quotient `P`. To check their identification with the
`a_j` above, push the chosen main-sphere access paths
slightly into a nearby fiber. In the actual blowup
chart `w=u v`, with fixed `u` nonzero, a small positive
circle about either marked tail slope is exactly a
positive circle about the corresponding nearby marking:
multiplication by `u` preserves complex orientation.
Moving the exterior access paths around attaching points
only introduces node meridians, already trivial in `P`.
The sheet labeling can therefore be chosen so that these
are exactly the `a_j`. Thus `H=P`,
the actual `Z` is connected, and (6.1) specializes to

\[
 b_1(Z)=1+|P|(k-1)-\sum_j |P|/e_j .                         \tag{6.2}
\]

This observation is not used to replace the infinite-image
proof: a positive finite graph rank alone cannot show
that its image in the surface group is infinite. Section 5
is still indispensable.

## 7. Closed rational strings and the hull obstruction

Let `Z_0` be the compact connected rational nodal curve
from Section 5, and let `Xtilde -> X` be the simply
connected universal cover. The pullback to `Z_0` is a
topological covering, including at the nodes. Every
connected component `W` corresponds to

\[
 \ker\bigl(\pi_1(Z_0)\longrightarrow\pi_1(X)\bigr).
\]

Its sheet number is the cardinality of that homomorphism's
image, hence infinite. A fiber is a closed discrete
infinite subset of `W`, precluding compactness. The
inverse image of the compact closed curve is closed
in `Xtilde`, and a connected component of a closed set
is closed. Thus `W` is closed and noncompact.

Each smooth rational component is simply connected,
so each connected lift of it maps isomorphically to
that component and is a compact rational curve.
At a point above the curve, an evenly covered
neighborhood can be chosen to meet the curve in just
one smooth branch or the two branches of a node.
One lifted neighborhood meets at most one or two of
the lifted components. Outside the closed inverse
image, a neighborhood meets none. This proves local
finiteness in the ambient manifold, not just in `W`.

The pullback nodal curve is locally path connected.
Its connected component `W` is therefore path
connected. Each path is compact and meets only
finitely many of the locally finite components.
An ambient holomorphic function restricts to a
constant on each compact rational curve by the
maximum principle; at each node the constants agree.
They consequently agree along every such path and
throughout `W`.

For any `w in W`, all ambient holomorphic functions
have the same values at every point of `W` as at
`w`. Thus

\[
 W\subset\widehat{\{w\}}_{Xtilde}.
\]

A compact hull would contain the closed subset `W`
as a compact subset, contradicting noncompactness.
This proves exactly `lem:rational-hull` and the
surface main theorem, not merely failure of Steinness.

## 8. Dyadic scope and adversarial boundary cases

The geometric proof uses no numerical value of `n`,
no order bound on a finite local group, and no
restriction on the separating quotient's size.
For all reviewed dyadic `n>=4`, the only changed
geometric count is `k=3n^2/2`. The same actual local
equation, index-two parameter change, killed vertical
meridians, two-marked tails, and dense fiber image
are accepted inputs for each `n`. Sections 2--7
therefore complete the chain for all of them.
There is no extension here to `n=2`, whose reviewed
weight estimate did not establish the needed input.

The potentially dangerous cases have explicit answers:

* Dependent commuting meridians: use their full finite
  subgroup, not the product of their separate orders.
* Exceptional divisors over crossings: their whole
  projected loop is local; it need not be a pure power.
* A horizontal image of order one: (4.1) is the identity
  and the tail remains rational.
* A high horizontal order: two branch points still
  give genus zero; a third branch point would invalidate
  that argument, but none exists in the actual fiber.
* A disconnected inverse-image fiber in the general
  local theorem: Section 5 only needs the component
  reached by the connected nearby lifted fiber.
* Finite local or graph computations: these do not
  establish infinitude of a global surface image.
* A nonclosed rational string: it would not give the
  compact-hull contradiction used here. Closedness is
  proved separately above.

## 9. Exact evidence and replay

Run from the campaign root:

```
python3 research/surface_geometry_audit/verify.py
```

The default recomputes the mathematical certificate and compares it
with `exact_certificate.json`, without changing either accepted
quotient evidence or the new certificate. `--certificate PATH`
checks a proposed replacement; `--write` generates only this
mission's new certificate. Altered local kernels, exceptional
images, ramification data, graph witnesses, Smith transformations,
and type changes must be rejected.

The finite scope, model inputs, and complete checked witnesses are
declared in the certificate and the verifier. These checks support
the delicate local assertions; Sections 2--7, not finite
extrapolation, establish the universally quantified geometry.

The Engineer replay passed for all 8,281 ordered pairs of meridians
in `C_m x C_n`, `1<=m,n<=6`, checking 679,620 points in their
period rectangles. It also checked the incidence formula for
85 generator lists in `C2 x C2` and 585 in the nonabelian group
`D8`, the cyclic-order models `1..32`, and 4,856 exact rational
instances of the neighborhood homotopy formula. Twelve internal
altered certificates were rejected. A separate command-line run
changing the exceptional image `(1,1)` to `(0,0)` exited one at
that exact witness field; the temporary altered file was removed.
These are finite verification results, not additional geometric
hypotheses or a refutation of the original local-detection lemma.

The single Jacobian operation was inspected before execution:
`matrix.normal_form.smith.certified.compute`, server `0.14.0`,
protocol `2025-11-25`. Its exact payload is the lattice basis
matrix with columns `(4,0),(-2,2)`, the kernel of
`(x,y) -> (x+y mod 4,y mod 2)`. Dedicated contract, payload,
typed-result, and adapter-status JSON files preserve the call.
The exact result gives Smith factors `2,4`, transformations
`D=U A V`, exit zero, and no timeout. The verifier independently
checks those integer identities. This operation certifies
only that finite lattice subclaim.

The Lean source and the once-written `statement_fidelity.md`
state the separate universal algebraic claim
`S_MERIDIAN_KERNEL`. The official Lean 4.31.0 compiler and
axiom audit both exited zero, with `proof_holes=[]`; mechanical
evidence was recorded against that claim. Its archived certificate
is
`certificates/S_MERIDIAN_KERNEL-cedde02e87bbd573.json`,
beside the source, with the original official result in
`lean_verification_output.json`. The durable task receipt is
`lean_submission.json`; that task completed successfully.
The compiler verdict must be judged on the encoded statement,
not relabeled as proof of `S_SURFACE_DYADIC`. Neither the
Lean source nor its fidelity document was edited after that run.
New geometric claims, citation attribution,
statement-fidelity review, and any final novelty/significance
decision remain for the independent Host Reviewer.
