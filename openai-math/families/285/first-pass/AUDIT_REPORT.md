# Audit #285: the simultaneous-overlap dependency

## Scope recorded before mathematical implementation

The active target is `geometry.tex:lem:overlap` in the irrational-trace
manuscript, together with `lem:diagram-count` and `prop:cone-geometry`.
All manuscript paths below are relative to `research/openai_manuscript/`;
the version inspected is the staged September 23, 2026 release.

The three principal manuscript claims are distinct:

| Target | Exact assertion | Principal dependencies; audit boundary |
|---|---|---|
| Irrational trace | A finitely generated group has a projection in its scalar reduced group C*-algebra with irrational canonical trace, outside degree-zero coefficient-free proper assembly. | Labelled isometric expanders; simultaneous overlap; direct sum of finite copy cycles; exact code relations and marginals; global enabled-graph deficit; faithful reduced representations and uniform spectral gap; trace computation; rational trace on assembly. Only the overlap dependency is active. |
| Kadison--Kaplansky | A finitely generated torsion-free group has a scalar reduced-algebra projection with trace strictly between zero and one half. | Tower labelling and pruning; nilpotent voltage covers and torsion control; regular-norm sampling; common-root domains and forest control; separated global matrix spectral band and small unnormalized trace; scalar free-product compression. These branches remain unaudited. |
| Reduced injectivity | A finitely generated torsion-free group contains an embedded oriented torus detected integrally by a degree-two class, but its rank-zero Bott class vanishes in reduced K-theory. | Labelling, expansion and pruning; Heisenberg cover geometry; integral orientation detector; bounded Bott families and norm-continuous cancellation; reduced-norm approximation and finite-witness transfer; assembly naturality. These branches remain unaudited. |

### Exact active hypotheses and downstream uses

The relator graphs are finite, connected, simple and regular of degree at
least three. Their reduced labellings distinguish every simple path whose
length is at least lambda times its source girth, throughout the disjoint
family. The maps of relators into the formal labelled Cayley graph are
isometric vertex embeddings. Here `0 < lambda <= 1/12` and
`lambda * girth > 3`. Copies retain their source identifications.

The diagram class permits repeated contour vertices and bridges. Its
exterior has *positions* marking prescribed side ends, not a side break
at every visit to a marked vertex. Adjustable sides retain their endpoints
and copy assignments. Minimality is lexicographic in bounded faces and
then original edges. Any refutation using a purported minimal diagram
must establish this minimality in precisely this class.

For overlap, the root can be a group vertex or a center. One root
geodesic from `c_P != R` is fixed in advance, with first group vertex
`a`. The comparison is non-strict:
`d(c_Q,R) <= d(c_P,R)`. The same `a` must work simultaneously for all
such different copies and all their shared vertices. The thinness
constant must be independent of lambda, the alphabet, and the graphs.

The overlap lemma supplies a dependency, not the conclusions, of
`data.tex:lem:cycle-sum`, `module.tex:lem:module-intersection`, and
`spectrum.tex:lem:global-deficit`. None of these downstream arguments,
the projection, or any of the three main theorems is certified here merely
by establishing overlap.

### Prior knowledge and citation limits at scope

The manuscript invokes the ordinary van Kampen diagram lemma and the
planar Euler identity, then invokes Bridson--Haefliger (1999),
III.H.2.1 and III.H.2.9, for linear coarse fillings implying
hyperbolicity. These are external inputs, not consequences of a finite
search. The latter source has DOI `10.1007/978-3-662-12494-9`.
Its actual theorem text has not yet been obtained at scope.

Two focused literature lookups were made: one for that exact coarse
filling theorem and one for prior graphical-small-cancellation cone-off
and root-overlap results. They returned secondary summaries, not a
source-checked proposition establishing the exact quantitative statement.
In particular, their broad claims about graphical small cancellation
are not adopted as evidence. No novelty conclusion follows from them.
The shared wiki index has no relevant page on this dependency; an
unrelated digit-cone overlap page is not mathematical support here.

The labelling/embedding results cited as Osajda Theorem 2.7, Lemma 3.1
and Theorem 3.2, the LPS expander inputs, and the assembly-trace inputs
are identified dependencies on the unaudited branches, not verified
citations or assumptions needed to construct a finite counterexample.
Existence of a DOI is not verification of the proposition cited.

### Alternative routes and excluded shortcuts

The two alternatives are an admissible exact counterexample to a named
step, or a universal proof of the diagram reductions, avoidance, uniform
thinness, and the fixed-root overlap conclusion. An arbitrary bad plane
diagram is not a minimal-diagram counterexample. A finite quotient need
not preserve the embeddings or uniqueness hypothesis. Finite searches
without a witness do not establish the theorem. These shortcuts are
recorded as invalid methods, not as exhausted mathematical routes.

Before custom finite-certificate code, the authorized Argus Jacobian
adapter discovered and exposed the typed contract for
`optimization.linear.rational_general_optimum.compute` (Jacobian
0.14.0, MCP protocol 2025-11-25). Its exact rational primal/dual
contract is suitable for the *numerical* Euler inequalities; it cannot
certify the preceding topology. No adapter computation has yet been
treated as mathematical evidence.

## Result submitted for independent review

The route taken is **universal verification**, not a counterexample.
The proof below justifies the diagram reductions, rather than assuming
their numerical conclusions. It also improves their constants:

* A nontrivial compressed diagram has `b <= 4m - 6`.
* An avoiding path of length `L >= 1` satisfies
  `d_P(x,a) <= (4L - 2) lambda sigma(P)`.
* Every coned edge loop of length `n > 0` has a filling with at most
  `8n` relations of perimeter at most four.
* With the manuscript's `t = D0 + 3` and `L0 = 4D0 + 8`,
  its simultaneous-overlap radius can be replaced by
  `floor((16D0 + 30) lambda sigma(P))`.

The corresponding manuscript coefficient is `48D0 + 108`. The improvement
is therefore `32D0 + 78`, for the *same* thinness constant and fixed root
geodesic. No numerical value of `D0` is claimed.

These are universal mathematical assertions with a prose proof and an
exact certificate of the numerical implications. They are **not**
kernel-checked topology, an independently accepted result, or a verified
novelty claim. Independent Reviewer replay is still required. Even
acceptance of this dependency does not finish the publishable campaign.

### A source actually read after scope

A separate read-only source researcher opened Daniel Groves and Jason
Fox Manning, *Dehn filling in relatively hyperbolic groups*,
**arXiv:math/0601311v4**, March 28, 2009:
<https://arxiv.org/pdf/math/0601311v4>.

Proposition 2.23 (Section 2.6, page 11) states the following criterion:
a simply connected 2-complex with uniformly bounded 2-cell attaching
lengths and a linear combinatorial isoperimetric inequality has
hyperbolic 1-skeleton. The constant depends only on the attaching-length
bound and the isoperimetric constant. No group action, bounded valence,
or local finiteness is required. The source reader also inspected the
diagram convention in Definition 2.19 and the accompanying discussion.
Two short passages actually read were:

> "Furthermore, delta can be calculated in terms of M and the
> isoperimetric constant of X."

Here "delta" transliterates the printed Greek symbol. The preceding
discussion expressly says:

> "our spaces are not always locally finite"

The original Bridson--Haefliger locator was not read and is not reported
as verified. Its DOI resolution only established document existence.
The alternative proposition is the external input used below. Formal
independent citation attribution in the ledger remains for the Host's
Reviewer; the source researcher's reading is not a compiler verdict.

## Universal verification theorem and proof

The theorem holds under all the manuscript's geometry hypotheses.
In fact, its proof does not use regularity: finite connected simple
relator graphs of finite positive girth suffice, provided the same
labelling uniqueness and isometric vertex-embedding hypotheses hold.
This extension is stated as a proved structural observation, not as a
claim that the literature contains no such observation.

Write `h_P = lambda sigma(P) > 3`. All lengths are original edge
lengths unless explicitly called arc counts.

### 1. Copies, diagrams, and existence of a minimizer

A common simple path in two copies pulls back to simple source paths,
because their vertex maps are injective. Once its length reaches either
source's uniqueness threshold, label uniqueness identifies the source
path and source graph. Equality of the images of its first vertex
then identifies the translating group element. Thus the copies were
the same indexed copy. A girth cycle contains a simple path longer than
the threshold, so equality of entire subgraphs also identifies indices.
This argument needs finite girth, not regularity.

Inflate every prescribed center passage to a path in its assigned
connected copy. The resulting label word is trivial in the presented
group, hence a finite product of conjugates of the defining closed-walk
words in the free group. The usual elementary construction attaches
one polygon for each such factor along its conjugating stem, then folds
the free edge cancellations. Discarding any closed components gives
a connected plane diagram with no more relation faces than factors.
Every face lifts to a translated source walk: its initial group value
determines its translate. The exterior lifts to the specified inflated
loop by determinism of the Cayley graph.

This construction permits cut vertices and repeated contour incidences;
requiring embedded face boundaries would be a different diagram class.
There is a diagram, so the set of its pairs `(F,E)` is a nonempty
subset of nonnegative integer pairs. Lexicographic minimization is
therefore attained. Retain the prescribed side-end *positions* when
marking their vertices, including coincident positions at one vertex.

We also use the converse elementary diagram identity. Cutting along a
dual spanning tree expresses an exterior contour as a product of
conjugates of the bounded contours, each used once, up to free edge
cancellations. It applies to cut vertices and bridges: a bridge is
traversed twice with opposite orientations and contributes only a
conjugating stem. This explains both the face-omission argument and
the filling construction below without assuming simple contours.

### 2. The surgeries really preserve the admissible category

**Freely trivial face.** Omit its factor from that identity and repeat
the polygon-and-stem construction. The same exterior word now has a
diagram with at most `F-1` faces. The prescribed exterior walks are
unchanged as labelled walks, so determinism preserves their assignments
and endpoint values. This is a contradiction even if the reconstructed
plane graph has different identifications of marked vertices.
Consequently every bounded contour is nonfreely trivial. A closed
source walk shorter than its girth reduces by inverse-edge cancellations
to the empty walk; hence every bounded perimeter is at least its girth.

**Two equal-copy faces.** A common edge between distinct faces is not
a bridge. Delete that edge and splice its two opposite contour
incidences. The plane graph remains connected; `E` drops by one,
`V` is unchanged, and precisely one bounded region disappears.
Every step of the merged contour is in the same assigned copy.
Other shared edges become bridges, and other shared vertices may be
revisited, but neither is forbidden. No uniqueness of the other
contacts is needed.

**Equal-copy face and exterior side.** Delete their common edge.
Replace its particular exterior occurrence by the complementary
bounded-contour walk with the same direction and endpoints. All its
steps lie in that side's assigned copy. Keep every other prescribed
side occurrence and every side-end position. Passing an old marked
vertex during the inserted walk does not create a new break.
The deleted edge had just one exterior incidence, so no other
exterior occurrence is lost. Again exactly one bounded face disappears.

**Unmarked leaf.** Its two consecutive contour steps are inverse.
Delete them and their terminal vertex. If exterior, they lie within
one adjustable side, since generator endpoints and side breaks are
marked. If bounded, they lie in that face's assigned copy.
No prescribed endpoint disappears. `F` is unchanged and `E` decreases.

**Bridge on a bounded contour.** Delete its open edge. The exterior
contour lies entirely in one component: a bridge whose incidences
are bounded is not traversed by the exterior. Keep that exterior
component and discard the other. On the affected bounded contour
this deletes a whole excursion `e gamma e^-1`, leaving a closed
walk in its assigned copy. It need not be freely trivial.
If the discarded component has `F1` bounded faces, Euler gives
`F_new = F-F1`; at least the bridge edge is removed. Thus either
faces decrease or faces are unchanged and edges decrease.
All prescribed exterior positions survive.

**Cancelling pair in an arc of length greater than two.** Its
midpoint is unmarked and bivalent. The two outer vertices are distinct:
the internal vertices of a maximal bivalent arc are distinct, and a
loop arc closes only at its full length. Contract that two-edge tree,
deleting the midpoint and identifying the outer vertices. These outer
vertices have the same group value. No surviving edge is incident
only to the deleted midpoint. Every affected contour loses precisely
an inverse pair in one incidence type, so all source walks and
prescribed positions survive. A tree contraction is planar, and
`E` and `V` each decrease by two, leaving `F` unchanged.
It is the final surviving vertices, not a homotopy of the deleted
midpoint in the Cayley graph, that are being assigned group values.

Each surgery contradicts the relevant minimality when its forbidden
configuration occurs. In particular there are no unmarked leaves,
bounded-face bridges, or equal-copy adjacent incidences involving a face.

### 3. Short arcs, including loops

Suppress the unmarked bivalent vertices. Since the diagram is connected
and has a marked vertex, a whole unmarked circle component cannot be
left over. Each side of an arc has a constant incidence type; changes
of exterior side happen at marked positions, hence at unsuppressed
vertices. Generator-side arcs have length one.

An arc of length at most two is shorter than every relevant `h_P`.
A longer arc is freely reduced by the last surgery. If an arc between
different assignments had length at least `h_Q`, take its first
`ceil(h_Q)` edges. Since `lambda <= 1/12` and `h_Q > 3`,
we have `sigma(Q)>36` and
`ceil(h_Q)<h_Q+1<=sigma(Q)/12+1<sigma(Q)`.
The prefix is therefore a simple
path in `Q`; vertex injectivity makes its lift in the other copy
simple too. Copy uniqueness gives a contradiction. This works even
when the entire arc is a loop: only its shorter prefix is used.

Every bounded-face incidence is opposite a generator side or a
different assigned copy, by Section 2. Thus all its arcs are shorter
than `h_P`. A bounded face has at least `1/lambda` arc incidences
(in fact strictly more); summing incidences gives `F/lambda <= 2b`.

### 4. A stronger Euler estimate

Let `M <= m` be the number of distinct marked vertices and let `v`
be the compressed vertex count. First suppose the diagram has an
edge. Every marked vertex then has degree at least one, and every
unmarked vertex has degree at least three. Loops contribute two to
degree. Connected planar Euler counting, including bridges, gives

```
v - b + F = 1,
2b >= 3(v-M) + M,
b <= 3F + 2M - 3 <= 3F + 2m - 3.
```

Euler itself follows by deleting a spanning tree and then counting the
remaining edges, each of which creates one bounded plane region.
No disk or simple-boundary assumption is concealed here.

Put `w = F/lambda`. The two nonnegative quantities
`2b-w` and `w-12F` give `b-6F >= 0`. Therefore

```
4m - b - 6
  = 2(2m + 3F - b - 3) + (b - 6F) >= 0,
4m - 6 - (1/lambda - 6)F
  = 2(2m + 3F - b - 3) + (2b - w) >= 0.
```

These prove the stronger claims and imply the manuscript's weaker
`b <= 6m` and `(1/lambda-6)F <= 6m-6`. If there are no edges,
connectedness leaves one marked vertex and `F=b=0`; `m>=1`,
so the manuscript's inequalities still hold. The stronger expression
`b<=4m-6` is deliberately *not* asserted for that isolated case.
A nontrivial diagram must have `m>=2`.

### 5. Designated-side pruning and avoidance

Close an `A=c_P`-avoiding path from `x` to `a` by one designated
side in `P`. There are `m<=L+1` prescribed sides, and no other
side has assignment `P`.

An arc whose two incidences are in the same exterior side would be a
bridge. Indeed a non-bridge belongs to a plane cycle and separates
distinct regions. If both incidences were in the designated side,
their two positions delimit an excursion entirely inside that
*linear side block*. Delete the excursion and the bridge and keep
the component containing the rest of the exterior. There is no
prescribed side-end position in the deleted interval. A vertex
marked by another visit does not change this fact. The designated
walk remains a walk in `P` with the same endpoints. The face count
cannot increase and the edge count decreases, a contradiction.

Thus each arc occurs on the designated side at most once. Its other
incidence has a different assignment or is a generator side; its
length is less than `h_P`. The designated side has at most `b`,
not merely `2b`, arc incidences. In a nontrivial diagram its length
is at most `(4m-6)h_P <= (4L-2)h_P`. In an isolated diagram the
adjusted side is empty. This proves the claimed avoidance bound
for `L>=1`. For `L=0`, `x=a` and the intrinsic distance is zero.

### 6. Uniform short fillings and the topology-to-hyperbolicity bridge

For a coned loop of length `n>0`, use its `m<=n` prescribed sides.
Choose one standard path per arc, compatible with reversal: keep a
fixed generator edge, otherwise use two spokes through either
incident copy. All endpoints are the same group vertices as before.

On a face assigned to `P`, replace each standard path by the two
spokes through `c_P`. Each replacement is a closed relation of
length at most four. The remaining face contour freely reduces
through its one center. The diagram identity in Section 1 expresses
the standard exterior using those filled contours. On each
adjustable exterior side do the same replacements using its own
assigned center. Consecutive spokes freely cancel to its prescribed
two-edge passage. An empty inflated side requires only a freely
inserted backtrack. Fixed generator sides need no replacement.
There is at most one relation per bounded-face or adjustable-exterior
arc incidence, hence at most `2b <= 8m <= 8n`; isolated diagrams
cost no relations.

For precision, attach a 2-cell to the coned graph along *each*
closed edge walk of positive length at most four, allowing repeated
edges and vertices. Call this complex `K`. The preceding product
of conjugates gives a van Kampen diagram in `K` with at most `8n`
noncollapsed 2-cells. To pass from a product to a disk diagram,
start with the corresponding polygons and conjugating stems and
fold the free cancellations of the boundary. All vertex
identifications have equal target values. Cut vertices and doubled
stems can either remain as a singular contractible disk diagram or
be thickened with collapsed regions; neither introduces an
additional noncollapsed relation face. This is exactly why
nonembedded contours are allowed. Conversely every finite edge
loop is filled this way, so `K` is simply connected.

Proposition 2.23 of Groves--Manning applies with attaching bound
`M=4` and linear area constant `8`. Its conclusion does not need
a group action or locally finite skeleton. The coned unit-edge
graph is geodesic and complete: a Cauchy sequence eventually stays
inside an edge, or converges to a vertex if it changes edges.
The criterion therefore gives a metric thinness constant depending
only on `(4,8)`. Moving a point on the other triangle side to an
endpoint of its unit edge and increasing to an integer gives a
vertex-thinness constant `D0`. It is independent of every graph,
the alphabet and lambda. This is a genuine external theorem use;
the LP computation does not establish it.

### 7. The fixed-root deduction, with distance ties

Fix `A=c_P != R` and **one** geodesic `alpha` from `A` to `R`,
with first group vertex `a`. Put `D=D0`, `t=D+3`,
`H=d(A,R)` and `L0=4D+8`. For any permitted different copy set
`B=c_Q` and take `x` in their intersection.

Distinct centers have no direct edge, so `A,x,B` is a geodesic
of length two. Choose any geodesic `beta` from `B` to `R`.
It avoids `A`: otherwise its length would be
`d(B,A)+H=2+H>H`, contrary to `d(B,R)<=H`.
This explicitly uses the non-strict comparison, so ties cause no loss.

If `H>=t`, take the vertex `z` of `alpha` at distance `t`
from `A`. Every vertex of `A,x,B` is at distance at least
`t-2=D+1` from `z`. Vertex thinness therefore supplies a vertex
`y` on `beta` with `d(y,z)<=D`. A shortest bridge from `y`
to `z` avoids `A`, since its length is at most `D<t`.
The walk `x,B,y,z,a` avoids `A` on every segment. Because
`d(B,y)<=d(B,A)+d(A,z)+d(z,y)<=2+t+D`, its length is at most

```
1 + (2+t+D) + D + (t-1) = 4D+8 = L0.
```

If `H<t`, use `x,B,R,a`, where the last segment follows
`alpha` backwards only as far as `a`. It avoids `A` and has
length at most `1+d(B,R)+H-1 <= 2H <= L0`.
The argument includes a center root and the possibility `R=B`.

Both cases end at the same preselected `a`; neither chooses a new
geodesic depending on `Q` or `x`. Section 5 now gives

```
d_P(x,a) <= (4L0-2) lambda sigma(P)
          = (16D0+30) lambda sigma(P).
```

Intrinsic vertex distances are integers. Taking the floor yields
the improved simultaneous intrinsic induced ball, and its coefficient
is smaller than the manuscript's by `32D0+78`. This proves the
original overlap lemma as well.

## Exact certificate and its limits

Run `python3 verify.py` from the campaign root, or give the script's
absolute path. It uses only Python's standard library. The certificate
preserves the inspected Jacobian operation id, exact rational payload,
complete typed response, server version, protocol, exit status, and
timeout/error fields. The adapter returned `OPTIMAL` in 125 ms;
the exact optimum is `min(4m-b)=6`, with primal
`(m,F,b)=(2,1/3,2)` and dual multipliers `(-2,-1)`.
This rational relaxation point is **not a diagram or a counterexample**.

The verifier independently replays primal feasibility, dual signs,
stationarity, complementarity, and equality of the primal and dual
objectives. It also checks the universal affine identities from
Euler/degree/incidence assumptions, all root-path constant identities,
the isolated case, and the original-versus-improved radius comparison.
Its small integer scan is an explicitly bounded experiment on those
abstract inequalities, not a search through admissible labelled
presentations or a proof of their geometric hypotheses.

The proof of admissibility and minimality-preserving surgeries is
Section 2, the application of the external filling theorem is
Section 6, and the qualitative fixed-root/tie argument is Section 7.
Those are prose obligations for independent mathematical review,
not facts established by replaying the LP. The verifier's source
anchors check which manuscript statement is being discussed, not
the truth of that statement. No Lean source or compiler evidence
is supplied. No main theorem or downstream spectral/module branch
has been marked verified, and novelty and publishability remain
unassessed.

### Observed replay and structural results

The current verifier returned `PASS`: exact LP optimum `6`, seven
universal affine implications, the two radius coefficient vectors
`(16,30)` and `(48,108)`, and `517` admissible tuples in its declared
bounded *abstract* experiment. Four in-memory corruptions were rejected:
an infeasible primal point, a false dual balance, an incorrect affine
multiplier, and a root-walk bound shortened by one. No corrupted or
auxiliary certificate files were written.

After recording the sharpened claims and source replacement, both
official checks returned zero against the exact project root
`campaigns/9000285`:
`math_state check` exit `0`; `proof_graph_check check` exit `0`.
The graph has 48 nodes. These are structural checks, not independent
acceptance of the proof. All proof nodes remain unconfirmed, all three
main target claims remain open, and the active `GM_223` citation still
requires the independent attribution step.
