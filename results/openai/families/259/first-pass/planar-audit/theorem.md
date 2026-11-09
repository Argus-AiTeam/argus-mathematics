# A coefficient-preserving planar matching theorem

## Result and scope

**Theorem.** Let `L = H * F(U)`. Suppose each relator has at least four
exterior occurrences, all positive, with no repeated exterior generator;
two different relators share at most one exterior generator. Then
`H -> D = L / <<R>>` is injective. A cyclically `H`-reduced word with an
exterior occurrence that is trivial in `D` either has a full cyclic
coefficient-preserving relator match, or has two exterior-disjoint
coefficient-preserving relator intervals, each of length at least
`m(r) - 2`.

Here "coefficient-preserving" means literal equality of the gap elements
in `H`, not conjugacy. An interval uses no relator position twice; its
closing gap is not part of an interval match. A full cyclic match does
include its closing gap. These are precisely the manuscript's conventions.
The theorem implies `planar:main`, which assumes `m(r) >= 7` and asks for
`m(r) - 3`.

This is a proof of the complete coefficient-sensitive lemma, not a
counterexample to it and not a verification of the manuscript's cost
theorem. The stronger bound is optimal. The degree threshold four cannot
be lowered to three if lengths are allowed to vary. Section 6 gives exact
witnesses for both assertions.

The injectivity hypothesis of the manuscript's lemma is thus unnecessary
under these relator hypotheses. The proof also permits arbitrary `H` and
arbitrary exterior alphabets, since each filling uses finite support.

The proof uses the bipartition by the signs of relator copies. The familiar
`(4,4)`-map curvature principle is not claimed to be new. Novelty and
publishable significance of this coefficient-preserving verification
remain for independent review and literature comparison.

### Source findings

The staged `build/planar.tex` states the complete coefficient-sensitive
lemma and supplies its own proof, rather than invoking a coefficient
version of Greendlinger's lemma as a black box. The dependency chain in
the manuscript is `planar:main -> rank:main ->` the finite-model rank
bound `->` the Bernoulli lower bound, combined with `actions:low` for the
cost separation. The other steps remain open in the campaign ledger.

The primary source inspected for comparison is Carl Weinbaum,
*Visualizing the word problem, with an application to sixth groups*,
Pacific Journal of Mathematics 16(3), 557-578 (1966), publisher PDF
`https://msp.org/pjm/1966/16-3/pjm-v16-n3-p14-s.pdf`.
Theorem 6.4, printed pp. 566-567, is the spherical-complex converse for
free-generator edge labels. The Main Theorem on printed p. 558 is about
sixth groups and long subwords. Neither inspected statement includes
arbitrary coefficient groups or exact coefficient-gap matching.
No proposition from this source is an assumption of the proof below.
Web-search suggestions of textbook proposition numbers were not verified
against the books and are not used as citations or novelty evidence.
The inherited Wiki index contained no relevant fixed-price, Greendlinger,
or coefficient-band result.

## 1. Finite fillings without a finite presentation for H

We first justify the passage from an arbitrary group to a finite planar
band diagram. This is a proof obligation, not input to the theorem.

Represent a coefficient element by a word on generators of `H`, and give
`H` all its true relations. Wedge its presentation complex with the
exterior circles. Its fundamental group is `L`. A word equal to one in
`L` has a finite filling using only true `H` relations and free
cancellations. One can see finiteness directly from free-product normal
form: combine adjacent coefficients, and cancel successive inverse
exterior letters whenever their intervening coefficient is one. If the
word is trivial and exterior letters remain, some such cancellation is
available; otherwise its free-product normal form is nonempty. Each
cancellation draws a band pairing the two inverse occurrences. Induction
on the number of exterior occurrences gives a finite noncrossing band
filling, with the remaining regions filled by true `H` relations.
Only finitely many such relations are used.

Since `W` is trivial in `D`, express it in `L` as a product of conjugates
of `N` relators or inverse relators, with `N` minimal. Cyclic
`H`-reduction and the presence of an exterior letter imply that `W` is
nontrivial in `L` by the same normal-form argument; hence `N > 0`.
Cutting along the conjugating spokes and using the finite filling just
described produces a mapped sphere with `N+1` disk holes. In their disk
orientations the outer disk `O` reads `W^-1`, and the inner disks read
the chosen relators or their inverses. Conversely, cutting such a
surface along spokes gives a product of `N` conjugates in `L`.

Here is an equivalent precise realization of the bands, useful for
keeping track of coefficients. Choose an interior midpoint `q_u` on
each exterior circle used by the finite filling. A finite piecewise
linear subdivision makes its inverse image a finite disjoint family
of arcs and circles. Indeed, near `q_u` the target is an interval;
choose its value different from the images of all subdivision vertices.
In each triangle the level set is an interval and the intervals glue
in pairs on interior edges. Boundary words are kept fixed. Every
exterior occurrence is one endpoint of exactly one arc. Each arc maps
constantly to `q_u`; its endpoints have opposite crossing signs in the
disk orientations. The same description follows by gluing the normal-
form cancellation bands along the two copies of each spoke.

An infinite generating alphabet for `H` causes no difficulty: use only
the finite words and relations occurring in this construction.
Consequently finite generation of `H` is not essential if coefficient
elements are allowed as letters.

## 2. Minimality, connectedness and dipoles

Take the boundary disks as vertices and the arc bands as edges of a
sphere graph `G`. Retain any closed tracks in the mapped surface; do
not assert that an individual closed track is null-homotopic.

**No inner loops.** All exterior occurrences on one inner disk have
one sign. A band pairs opposite signs, so cannot return to that disk.

**No same-relator dipoles.** A joining edge between two copies of the
same relator necessarily joins the unique occurrence of its generator
in opposite orientations. Split this generator circle at its midpoint
as `u = p s`, with `p` running from the presentation basepoint to
`q_u`. If the cyclic rest of the relator is `T`, the two boundary
loops based at `q_u` are

```
s T p                 and                 p^-1 T^-1 s^-1.
```

They are inverse loops in the actual group `L`. The joining arc is
constant at their common basepoint; it supplies no conjugating
coefficient. The boundary of a small disk neighborhood of the two
disks and that arc is therefore null in `L`. Replace it with a
finite filling as in Section 1, removing two relator disks. Other
tracks may meet this neighborhood's boundary; a replacement map is
not required to preserve those tracks. Minimality is again contradicted.

For different relators there is at most one joining edge, since they
share at most one generator and use it once each. The inner graph is
therefore simple. Give a vertex the sign of its relator copy.
Every inner edge joins opposite signs, so this simple inner graph is
also **bipartite**. The degree of each inner vertex is exactly `m(r)`.

**Automatic injectivity.** Suppose instead that a nonidentity
coefficient word `h` becomes trivial in `D`, and choose a least-relator
filling of `h`. It has `N>0`, and its outside disk has no exterior
occurrences, so every arc joins inner disks. The dipole argument just
given does not use injectivity or connectedness. Consequently every
connected component of its arc graph is a finite simple bipartite
sphere graph with minimum degree four.

This is impossible. In such a component every facial walk has length
at least four: there are no loops or parallel-edge bigons; a
two-dart bridge face would require both endpoint degrees one; and
bipartiteness excludes odd closed walks. Thus `4F <= 2E`.
The degree sum gives `4V <= 2E`, whereas Euler gives `V-E+F=2`.
Adding the two inequalities contradicts Euler. This proves
`H -> D` injective, without any preexisting embedding theorem.

**Connectedness.** Return to the exterior word `W`. A component
of its band graph not containing `O` would again be a finite
simple bipartite sphere graph with all degrees at least four.
The same contradiction excludes it. Since `N>0`, the graph is
connected. In particular connectedness does not need to borrow
an unproved coefficient-embedding theorem.

## 3. Face equations give equality, not conjugacy

A regular neighborhood of a connected sphere graph has disk
complements. Boundary walks may repeat edges or vertices; all
incidences below are counted with multiplicity.

Collapse every exterior circle in the target to its basepoint and
take values in `H`. The resulting homomorphism fixes `H`. Every
constant track becomes constant at that same basepoint. Every
sector between consecutive exterior occurrences contributes exactly
its coefficient element, with the sign determined by the boundary
orientation. The mapped complementary disk says that the ordered
product of these sector values is one. Closed tracks inside the disk
do not affect this statement.

There are no monogon faces: an inner loop is impossible, and an
outer monogon would give successive inverse exterior occurrences of
`W` separated by the identity coefficient. This violates cyclic
`H`-reduction.

A bigon meeting an inner vertex must join it to `O` along two
different edges. Parallel inner edges have been excluded. A
two-dart face consisting of a bridge traversed twice would require
degree one at its inner endpoint, also impossible. Such a bigon
therefore pairs consecutive inner and outer exterior occurrences.
Since `O` reads `W^-1`, reading `W` gives the same signed letters
and order as the corresponding oriented relator.

Let the two coefficient gaps, read in those matching directions,
be `a` on the relator and `b` on `W`. The face equation, or its
inverse read from the other endpoint, is `a b^-1 = 1`. Hence
`a = b` **in H**. There is no intervening basepoint path after
the collapse, and no unspecified conjugator. A chain of bigons
gives all the strict intervening gap equalities, one at a time.

## 4. The strengthened finite corner argument

Work with doubled weights. Every corner at `O` and every bigon
corner has weight zero. At any remaining inner corner give weight
two if both incident edges go to `O`, and weight one otherwise.

For a face of length `l` the weight is at most `2l-4`:

* If `l=2` it is zero.
* If the face has no occurrence of `O`, it is a closed walk in the
  bipartite inner graph. No monogon or bigon is available, so
  `l >= 4`; its weight is `l <= 2l-4`.
* If it has exactly one occurrence of `O` and `l>=3`, no inner
  corner has two outer neighbors. Its weight is `l-1 <= 2l-4`.
* If it has at least two occurrences of `O`, there are at most
  `l-2` inner corners and each has weight at most two.

These are statements about occurrences, so repeated face walks and
outer loops require no omitted special case.

Let `C(v)` be the doubled corner total at an inner vertex. Summing
the face bounds and using `sum l = 2E` and
`(N+1)-E+F=2` gives

```
sum_inner (4 - C(v)) >= 4N - 4E + 4F = 4.
```

For completeness the Euler identity follows by starting with a
spanning tree, which has one complementary face, and adding the
remaining embedded edges, each of which splits one disk face.
The corner partition counts every dart corner once at its vertex
and once in its face.

If a vertex has no outer edge, `C(v)=m(v)>=4`, so it is not
positive. Otherwise let `t>0` be its number of outer edges, indexed
cyclically. In the gap after outer edge `i` let `h_i` be the
number of inner edges. Then

```
m(v) = t + sum_i h_i.
```

A bigon gap has `h_i=0` and cost zero. A nonbigon gap with
`h_i=0` costs two. A gap with `h_i>0` has `h_i+1` corners,
each of weight one, so costs `h_i+1`.

If `C(v)<4`, either all gaps are bigons, or precisely one gap is
not a bigon. Indeed, each nonbigon costs at least two. In the
latter case its `h_i` is at most two, and every other `h_i` is
zero. Cutting just after the exceptional gap gives one ordered
chain of `t >= m(v)-2 >= 2` outer edges joined by bigons.

If all gaps are bigons, all incidences at this vertex go outside.
Successive ones are also successive at `O` in the reverse rotation.
This closes up and exhausts `O`'s rotation: an extra half-edge
would interrupt a bigon. Connectedness leaves no other vertex.
Section 3 gives the full cyclic match, including the closing gap.

Otherwise every vertex has `C(v)>=2`, hence positive charge at
most two. Since total charge is at least four, there are two
distinct positive vertices. Their cut chains give the desired
two matching intervals. No relator position is repeated. The
global endpoint map of bands is injective, so the two intervals
have no common exterior occurrence of `W`. This proves the theorem.

## 5. Formal core and limits of machine checking

`Main.lean`, declaration `PlanarAudit.coefficient_sensitive_core`,
checks the universal finite extraction with arbitrary group-valued
gaps. It proves the face-sum-to-curvature calculation, the unique
exceptional-gap classification, cyclic enumeration after the cut,
ordered matching at both boundaries, exact group equality of gaps,
and disjointness. It is not a finite search or an arithmetic-only
restatement. `statement_fidelity.md` specifies every interface
hypothesis and the precise unformalized obligations.

Sections 1-3 and the realization of the normalized finite data in
Section 4 are mathematical proofs requiring independent human
review. A successful compiler run must not be reported as a
kernel proof of those topological steps or of the whole manuscript.
The executable checks in `verify.py` additionally replay the exact
optimality constructions and nonabelian coefficient identities.
They are supplementary evidence, not a replacement for these proofs.

## 6. Optimality and coefficient twists

### The loss of two occurrences is sharp

For any `m>=4`, take distinct generators `x0,x1,x2,x3` and four
pairwise disjoint private positive words `A0,A1,A2,A3`, each of
length `m-2` with no repeated letter. Set

```
r0 = x3 x0 A0,       r1 = x1 x0 A1,
r2 = x1 x2 A2,       r3 = x3 x2 A3.
W  = A0^-1 A1 A2^-1 A3.
```

All relators have length `m`, and distinct relators share at most
one generator. Take `H` trivial, so the injectivity hypothesis is
satisfied. The four relations replace the four displayed blocks of
`W` by `x3 x0`, `x0^-1 x1^-1`, `x1 x2`, and `x2^-1 x3^-1`,
whose product freely reduces to one. The word is cyclically
reduced. Each sign-constant block has length exactly `m-2`.
All relators are positive, so no matching interval can cross a sign
change. There is no full cyclic relator match, and no interval of
length `m-1`. Thus the loss of two is optimal for every `m`.

### Length three cannot be permitted in general

Embed the cube on the sphere and attach one leaf `O` to a cube
vertex. Give each edge a separate exterior generator. Bipartition
the eight cube vertices. At a positive vertex take its clockwise
incidence list as the positive relator; at a negative vertex
reverse that incidence list to define the positive relator.
Thus, read in disk orientations, neighboring disks traverse their
common generator with opposite signs. The vertex attached to `O`
has relator length four; the other seven have length three.
Different relators share at most one generator.

With `H` trivial every complementary face has identity coefficient
word, and the sphere minus the outer disk fills the one-letter word
`u` on the leaf. The standalone script independently verifies
`u=1` by eliminating the seven relators along a cube spanning tree;
the remaining relator freely reduces to `u`. This also avoids
assuming the topological converse in the executable certificate.
`W=u` is cyclically reduced, is not a full relator, and cannot
contain two exterior-disjoint nonempty intervals. This is an
obstruction to extending the strengthened theorem to minimum
length three, **not a counterexample to the manuscript**.

`jacobian_payload.json` is this nine-vertex rotation system.
`jacobian_result.json` records its exact typed six-face output
from `combinatorial_map.faces.compute`, Jacobian server 0.14.0,
protocol 2025-11-25. The adapter returned zero, without timeout
or structured error. `verify.py` recomputes the successor
permutation and every face without Jacobian.

### Nonabelian coefficient transport

For any choices `p_u,q_u` in any group `H`, the substitutions
`u -> p_u u q_u`, fixing `H`, define an automorphism of `H*F(U)`.
The inverse sends `u` to `p_u^-1 u q_u^-1`. Hence the quotients
are isomorphic by a map fixing `H`; injectivity is preserved.

For a signed letter `e`, write its image as `left(e) e right(e)`.
For `u` the factors are `p_u,q_u`, and for `u^-1` they are
`q_u^-1,p_u^-1`. An intervening gap `h` becomes
`right(e) h left(f)`. Equal signed endpoints therefore preserve
and reflect equality of gaps by left and right cancellation.
When `f=e^-1` this is a conjugate of `h`, so the gap is one
exactly when `h` was one. Thus cyclic `H`-reduction is preserved,
as are full cyclic matches and interval matches.

This transports the sharpness examples to arbitrary, including
nonabelian, coefficient groups without jeopardizing injectivity.
The relevant cancellation identities are kernel-checked in
`sandwich_eq_iff` and `conjugate_one_iff`. The executable uses
the permutation group `S3` to distinguish equality from conjugacy.

Finally the same cube elimination also shows that the automatic
injectivity threshold is sharp. Reinterpret the leaf generator `u`
as a generator `h` of the coefficient group `H=Z`, and remove the
leaf band from the exterior graph. It now occurs only as a coefficient
in the root relator; all eight relators have three exterior
occurrences. The seven eliminations leave exactly the relation
`h=1`, although `h` is nontrivial in `Z`. This example does not
satisfy the manuscript's injectivity assumption and is not offered
as a counterexample to its lemma.
