# A relative cone-picture reduction theorem

## Statement and scope

Let \(F\) be a finite rose, let \(\Gamma=\bigsqcup\Lambda\) be a finite graph
with a combinatorial immersion \(j:\Gamma\to F\), and let \(R\) be any set of
vertices of \(\Gamma\). Each edge reads one signed rose letter. Loops,
multiple edges, disconnected graphs, and tree
components are allowed. Put
\[
 X=F\cup_j\bigsqcup_\Lambda K_\Lambda ,
\]
where \(K_\Lambda\) is the abstract cone on the component \(\Lambda\).
In particular, different graph vertices need not have different images in
\(X\).

A **reduced arrangement** has exactly the meaning of Definition
`def:arrangement` in the staged `planar.tex`, replacing its two allowed roots
by \(R\): disjoint disks on an oriented sphere, at least one ordinary
positive-length cyclically immersed graph loop, at most one exceptional
positive-length immersed graph interval with one marked break and initial
vertex in \(R\), and a complete, disjoint, inverse-letter pairing outside
the disks. Partners must be occurrences of different **underlying
unoriented graph edges**, not merely different occurrences. No connectedness
of the pairing graph is required.

**Theorem.** If there is no such reduced arrangement, then:

1. \(\pi_2(X)=0\).
2. Every graph path from \(r\in R\) to \(y\ne r\) has nonidentity label in
   \(\pi_1(X)\).
3. The universal cover of \(X\) is contractible and \(\pi_1(X)\) is
   torsion-free.

This is a deterministic implication for every finite immersed labelled graph.
It needs no degree, girth, diameter, random-matching, entropy, or
small-cancellation assumption. Specializing \(R=\{x_A,x_B\}\) gives the
selected manuscript proposition and its torsion corollary **conditional on
arrangement exclusion**. This does not prove that the manuscript's random
graphs exclude arrangements. It also does not assert injectivity on every
pair of graph vertices when \(R\) contains only prescribed roots.

The universal proof is below. `verify.py` checks exact chain and ribbon
calculations and the separately stated Lean certificate; its finite tests
are not a proof of this topological theorem. The Lean statement deliberately
does not identify a word identity with a theorem about \(\pi_2\).

## 1. Pictures exist before any reduction

Here and below graph paths include their actual vertices and oriented edges.
The map to the rose forgets vertices, but no surgery is performed on that
forgotten data.

For each connected \(\Lambda\), choose a maximal tree and the corresponding
based free basis of \(\pi_1(\Lambda)\). Attach one disk along each basis loop,
obtaining \(Y_\Lambda\). Collapsing the maximal tree is a homotopy equivalence:
it collapses a contractible CW subcomplex. The quotient is a wedge of disks,
one filling each remaining basis circle. Thus \(Y_\Lambda\) is contractible.
This also covers a tree, when there are no basis disks.

There are maps \(Y_\Lambda\leftrightarrows K_\Lambda\) restricting to the
identity on \(\Lambda\), and homotopies of their composites to the respective
identities relative to \(\Lambda\). To see the relative assertion, extend
over relative cells: every extension obstruction is a homotopy group of a
contractible target and is zero. Apply the same argument to the relative
cylinder to construct the homotopies. These maps glue with the identity
of \(F\), even when \(\Lambda\to F\) is not injective.

Consequently \(X\) has a homotopy-equivalent finite presentation-complex
model relative to \(F\). A surface map into that model has the usual
relator-disk picture. More explicitly, triangulate mapping-cylinder collars
of the attaching maps, approximate the surface map piecewise linearly, and
choose one regular interior point of each relator disk outside the images
of the finitely many degenerate simplices. Its preimage is finite. Small
disjoint neighborhoods of those preimages map homeomorphically to small
disks. A radial map, homotopic to the identity relative to \(F\), expands
each small target disk to its relator disk and sends its remaining collar
to the attaching path. The complement of the preimage disks then maps to
\(F\).

Return to \(X\) by the relative equivalence. Each inner disk factors through
its specified \(K_\Lambda\) and its boundary has an actual closed lift to
\(\Lambda\). An essential sphere remains essential. A null-homotopy with
specified boundary word remains a null-homotopy with that word; a graph
collar restores its parametrization if required. No vanishing of
\(\pi_2(X)\), graphical embedding, or root separation was used here.

## 2. Minimize a genuine failure, not a chosen word

If assertion 1 fails, take all cone pictures of all nonzero spherical
homotopy classes. If assertion 2 fails, fix a witnessing ordered pair
\((r,y)\) with \(r\in R\), \(y\ne r\), and take all disk pictures whose
outer word is the label of any graph interval from this same \(r\) to
this same \(y\). These families are nonempty by Section 1.

In the appropriate family minimize
\[
 L=\sum_{\text{inner disks }D}|\partial D|
       +\begin{cases}0&\text{sphere},\\ |p|&\text{disk}.\end{cases}
\]
This is a nonnegative integer. Inner paths can be cyclically tightened in
their own graph using collars and the same cone. Old and new fillings are
homotopic relative to the old boundary because the cone is contractible.
Remove constant inner disks. Tighten the outer path in the graph relative
to its actual endpoints. At a minimum, every inner path is nonempty and
cyclically immersed and the outer path is nonempty and immersed.

There is an inner disk. Otherwise a sphere maps into a graph, which has
\(\pi_2=0\). In the disk case a nonempty immersed graph path maps to a
nonempty freely reduced word because \(j\) is an immersion. It cannot
bound a disk in the rose. This argument also applies to every retained
disk below; it prevents a surgery from discarding all ordinary boundaries
while still purporting to witness the fixed-endpoint failure.

In the disk case add an exterior disk **only as surface bookkeeping**.
It is not mapped to \(X\). Give it the coherent boundary orientation
reading \(p:r\to y\); its single break records the distinct graph vertices
that map to the same rose vertex.

On the complement of the disks take transverse preimages of an interior
point of every rose edge. Straightened collars give precisely one endpoint
per edge occurrence. Discard circular preimage components. The remaining
arcs are disjoint and pair every occurrence exactly once. Their two
crossings have opposite signs in the oriented boundary of the complement.
Changing to the coherent disk orientations reverses both signs, so paired
letters are inverse. These assertions also hold at an exterior boundary;
no transverse point is the break.

## 3. Same-lifted-edge cancellation: all four incidences

Suppose a pairing arc has partners on the same underlying graph edge.
Choose an orientation \(e:u\to v\). The occurrences are \(e,e^{-1}\),
since \(j\) maps an oriented open edge homeomorphically to an oriented
rose edge. A thin rectangular band around the arc maps into that open
rose edge. It lifts to the common open graph edge, agreeing at both
attachment intervals with the already specified graph lifts.

When only ordinary disks are involved, their union with this band
therefore factors through one and the same **abstract** cone.
For exterior incidences this assertion is made only about the band and
the ordinary disks: the exterior has no map.

Here are the lifted boundary paths after contracting the two residual
edge fragments along \(e\):

| Incidence | Old paths | New paths |
|---|---|---|
| two different inner disks | \(ea,\ e^{-1}b\) | \(ab\) |
| inner and exterior | \(aec:r\to y,\ e^{-1}b\) | \(abc:r\to y\) |
| one inner disk twice | \(eae^{-1}b\) | \(a,\ b\) |
| exterior twice | \(aebe^{-1}c:r\to y\) | \(ac:r\to y\), and a discarded boundary \(b\) |

These are identities of **composable graph paths**, not just of labels.
For example, the last row has \(a:r\to u\), \(b:v\to v\), and
\(c:u\to y\). Thus the break-containing boundary is \(ac:r\to y\).
In the second row, \(b:u\to v\), so replacing \(e\) by \(b\) likewise
keeps both endpoints. Empty residual paths are permitted.

Both band-side contractions take place inside the common graph edge,
relative to the corresponding graph vertex. Neither crosses the marked
break. Their total removes two full edge occurrences and adds none.
This remains true when an occurrence abuts the break: the two copies of
the break are retained as the ordered, fixed interval endpoints.
Insert the contraction homotopies in boundary collars: a new collar first
runs the contraction backwards to the old boundary map, then joins the
old complementary collar. These homotopies take values in the graph and
hence in \(F\), so the remaining complement still maps to \(F\). On a
cone-filling side they take values in the same cone. All other boundary
parametrizations, and the marked break itself, can be held fixed.

The surface changes are as follows.

* **Different inner disks.** Two disks joined by a band have a disk as
  their regular neighborhood. Replace it by one cone filling with its
  spliced boundary. The original and replacement fillings are homotopic
  relative to that boundary, since both factor through the same
  contractible cone.
* **Inner and exterior.** The joined neighborhood is a disk. Remove it
  as the new exterior and restrict the existing map to its disk
  complement. Its outer graph lift is \(abc:r\to y\). No filling of the
  new exterior is asserted or needed.
* **One inner disk twice.** The regular neighborhood is an annulus,
  since it is an orientable subsurface of the sphere. Its two
  complementary parts are disks. Cap their new boundaries using the
  same cone. In a disk problem retain the component containing the
  exterior, with its unchanged ordered endpoints. In a sphere problem
  retain an essential capped sphere; Section 4 proves one exists.
* **Exterior twice.** Its joined neighborhood is an annulus. The
  marked break belongs to exactly one of its boundary components.
  Retain the complementary disk adjacent to that component, and
  restrict the old map to it. Its outer lift is \(ac:r\to y\). The
  other complementary disk and its boundary \(b\) need not be mapped
  or capped for the new disk problem.

The stated disk/annulus types follow also from Euler characteristic:
joining different disks gives a connected orientable genus-zero
neighborhood with \(\chi=1\), whereas a self-band gives one with
\(\chi=0\) and two boundary components. Their complements in the sphere
have the claimed disk components. There are no twisted bands in an
oriented sphere.

Before any further tightening, the sum of all resulting boundary
lengths is \(L-2\). Discarding an unneeded component cannot increase
that sum. In the exterior-self case the retained length is
\(L-2-|b|\) minus the lengths of any discarded inner boundaries.
After tightening it is no larger. Any retained fixed-endpoint interval
is still nonempty because \(r\ne y\).

## 4. Why a self-band cannot erase an essential sphere

Let \(f:S^2\to X\) be the original essential sphere and \(U\) the
inner-disk-and-band annulus. Lift \(f\) to \(\widetilde X\).
The map \(K_\Lambda\to X\) lifts because the cone is simply connected.
Choose its lift to agree with \(\widetilde f\) at one point of \(U\).
The two lifts of \(f|_U\) then agree on all of the **connected**
annulus by uniqueness of lifts. In particular both caps may be filled
through this one lifted cone; choosing separate unrelated deck
translates is not allowed.

Write \(f_1,f_2\) for the two capped sphere maps with their compatible
orientations. Triangulate the annulus and caps. In singular homology,
\[
 [\widetilde f]-[\widetilde f_1]-[\widetilde f_2]
   =\widetilde\iota_*[\,U-\text{cap}_1-\text{cap}_2\,]=0
       \quad\text{in }H_2(\widetilde X;\mathbb Z).                 \tag{1}
\]
The chain inside brackets is closed **already in the abstract cone**:
each seam has identical lifted parametrizations with opposite boundary
orientations. Its class vanishes because that cone is contractible.
This is stronger than knowing only that its image is a cycle in \(X\);
the latter alone would not justify (1).

Covering maps induce isomorphisms on \(\pi_2\), and the degree-two
Hurewicz map for the simply connected cover is an isomorphism. Hence
the original homology class is nonzero. Equation (1) implies that at
least one capped class is nonzero, and hence at least one capped sphere
is essential. We do not assert that a specified summand stays essential,
nor that the originally selected homotopy class is unchanged.

The universal chain calculation behind (1) is formalized separately in
`Main.lean`. If \(A=\mathbb Z^{E(\Lambda)}\) and
\(B=\mathbb Z^{V(\Lambda)}\), with incidence map \(\delta:A\to B\),
the cone has
\[
 C_2=A,\quad C_1=A\oplus B,\quad
 d_2(a)=(a,-\delta a).
\]
Projection to the base-edge coordinates makes \(d_2\) injective.
Thus any residual cellular 2-cycle in the abstract cone is zero, and
its pushforward contributes zero to the conservation identity. This
linear-algebra statement does not assume that the cone embeds in \(X\).
The proof above supplies the geometric chain and its compatible lifts;
those facts are not supplied by a word-splicing check.

## 5. Finish the implication

In every incidence case a genuine failure survives at strictly smaller
total boundary length. This contradicts the choice of \(L\). Thus the
minimal failure picture has no same-underlying-edge pairing at all.
It is precisely a reduced arrangement: positive immersed boundaries,
at least one ordinary boundary, at most one rooted interval and one
break, complete disjoint inverse-letter pairing, and distinct
underlying edges for partners. The hypothesized exclusion is a
contradiction. Assertions 1 and 2 follow simultaneously.

Notice the order of the argument: essentiality and endpoint preservation
are established **before** minimality is invoked. Assuming either of
them as a small-cancellation hypothesis would prove a weaker theorem.

## 6. From \(\pi_2=0\) to torsion-freeness

The universal cover is a simply connected two-dimensional CW complex.
Its \(H_1\) vanishes, its \(H_2\) vanishes by Hurewicz, and its homology
above dimension two vanishes by cellular homology. The homological
Whitehead theorem makes its map to a point a homotopy equivalence.
Thus \(X\) is a finite-dimensional classifying space.

Here is the algebraic torsion obstruction, including why the two
resolutions give the same answer. The augmented cellular chains of
the contractible cover form a free \(\mathbb ZG\)-resolution of
\(\mathbb Z\) of length two. If \(G\) has torsion, it has a subgroup
\(H=\langle g\rangle\) of prime order \(\ell\). Restriction gives a
free \(\mathbb ZH\)-resolution of length two: choose representatives
of the **right cosets** \(Ht\), so
\(\mathbb ZG=\bigoplus_t\mathbb ZH\,t\) as left modules.
No finiteness of the restricted ranks is needed.

On \(\mathbb ZH\), multiplication by \(g-1\) and
\(N=1+g+\cdots+g^{\ell-1}\) alternates in an infinite exact
resolution ending in the augmentation. In coordinates, the kernel
of \(g-1\) consists of constant coefficient vectors, hence is the
image of \(N\); the kernel of \(N\) consists of coefficient vectors
with sum zero, hence is the image of \(g-1\). For the second
assertion solve cyclic consecutive differences by partial sums.
The kernel of augmentation is the same sum-zero subgroup.

Apply \(\operatorname{Hom}_{\mathbb ZH}(-,\mathbb F_\ell)\) with the
trivial action. Both kinds of differentials become zero:
\(g-1\) acts by zero, and \(N\) acts by \(\ell=0\).
Thus the periodic resolution gives cohomology \(\mathbb F_\ell\)
in every nonnegative degree, whereas the length-two resolution
gives zero above degree two.

For clarity, independence of resolutions is not an extra assumption
about \(H\). Given two projective resolutions, lift the identity of
the augmented module to a chain map inductively: at each degree
exactness makes the required image land in the next cycle module,
and projectivity lifts it along the surjection onto that module.
Two such lifts are chain homotopic, by the same inductive lifting
argument applied to their difference. Doing this in both directions
makes the composites homotopic to the identities. Applying
\(\operatorname{Hom}(-,\mathbb F_\ell)\) preserves the homotopies,
so both cohomology groups must agree. Their disagreement is the
contradiction. Therefore \(G\) is torsion-free.

## 7. Audit conclusion and evidence boundary

No false assertion of the selected `topology.tex` argument has been
identified. In particular its self-band argument uses a common lifted
cone and a sum of homology classes, not an unjustified assertion that
each split sphere remains essential. There is consequently no
`F_<LABEL>` finding from this proof. A failed search for a sufficient
small-cancellation condition would not refute this theorem and was
not used as a route.

Relative to the accepted occurrence-to-stage theorem, the mathematical
advance here is a proof of the separate deterministic topology
implication, with its actual graph endpoints, self-band essentiality,
and finite-dimensional torsion obstruction. The random-model inputs,
planar exclusion, nonzero-factor argument, and full zero-divisor
construction are not discharged. Novelty and publishability are for
independent review, not asserted by the executable checks.

## Standard inputs and primary sources

The three standard topological propositions used above are recorded as
assumptions in the claim ledger, rather than silently attributed to the
Lean core:

| Input | Primary proposition | Passage retained here |
|---|---|---|
| Degree-two Hurewicz | Hatcher, *Algebraic Topology* (2002), ISBN 9780521795401, Theorem 4.32, p. 366, with \(n=2\) | `literature/hatcher-hurewicz.txt` |
| Homological Whitehead | Same book, Corollary 4.33, p. 367 | `literature/hatcher-whitehead.txt` |
| Higher homotopy of a covering | Same book, Proposition 4.1, p. 342 | `literature/hatcher-hurewicz.txt` |

An independent source-reader opened the author's updated electronic PDF
(generated 26 October 2022) and reported that these passages support the
uses. The manuscript's Theorem 4.37 citation is also valid: take the pair
\((\widetilde X,\{x_0\})\), \(n=2\); the fundamental-group-action quotient
in that relative statement disappears. The excerpts identify which text
was independently read and which transcription was made by the Engineer.
They still require the normal Reviewer's source-attribution decision.

`literature/graphical-reduction-scope.md` records the bounded comparison with
Gruber and Bereznyuk. Their graphical asphericity results are prior art,
not assumptions used to bypass the present geometric argument. In
particular, importing a \(C(2)\) or \(C(6)\) theorem without its hypotheses
would not prove the stated implication.

The exact replay checks 909 ordered multigraphs, 22,365 integral cycle
primitives, and 5,460 graph splices covering all four incidences, including
858 cases adjacent to the break. Its weakened-hypothesis controls are not
counterexamples to the manuscript: the nonimmersed tree deliberately
violates immersion, and the cyclic torsion examples have explicit
reduced arrangements, so violate exclusion. The universal conclusion is
proved in Sections 1-6, not extrapolated from these experiments.
