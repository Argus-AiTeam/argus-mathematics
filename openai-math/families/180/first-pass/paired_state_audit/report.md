# Integral forest extraction from paired states

## Statement and source scope

Let T be the finite simple sphere triangulation of the staged manuscript.
Every edge has one black and one white incident triangular face. Fix a black
outer face t0, let R be its three vertices, let X = V(T) \ R, and let A be
the other black faces. A state is an incidence-preserving bijection A -> X.
A pair (r,s) consists of states with r(t) != s(t) at every t. Let Q_s contain
the edge opposite s(t), once for each t in A.

The target is exactly Proposition `prop:forest-state`, paper.tex lines
413-416: existence of a pair implies existence of a pair with Q_s acyclic.
The argument below does not assume the absence of separating triangles.
It does not prove that a pair exists, recover induced trees, or establish
Barnette's conjecture; those are separate manuscript dependencies.

The stronger integral formulation proved here is as follows. There are
nonnegative integral incidence weights a(t,v) for which

    Z(z) = sum_(r,s pair) i^J(r,s) z^(sum_t a(t,s(t)))

is a nonzero polynomial in Z[i][z]. If D ranges over the distinct undirected
edge sets of pairs, c(D) is its number of cycles, and m = min_D c(D), then

    [(z-1)^m] Z(z)
      = (-i)^m sum_(D : c(D)=m) product_(C in D) Delta_C,

where Delta_C is a strictly positive integer: the number of bounded faces
inside the detoured cycle in its own spoke-graph component. Here the
coefficient notation means the coefficient of y^m in Z(1+y).
Every coefficient in lower degree is zero. If n = |A| and F is the sum of
the bounded-face counts of the separate spoke components, the weights can
be chosen in [0,2F], and deg Z <= 2nF.

This is a uniform theorem, not an inference from finite enumeration. The
standalone exact replay and any formal source must be read with their
separately stated scopes; they do not automatically formalize plane topology.

## What was already known

The following primary sources were opened during scope:

* Hine--Kalman, *Clock theorems for triangulated surfaces*,
  arXiv:1808.06091v1, Sections 1 and 2.1, gives the spherical convention
  that one triangle and its three root vertices are omitted before forming
  incident triangle--vertex matchings. Their trinity framework also has a
  proper vertex three-coloring. We do not import a clock theorem or assume
  that its extra hypotheses can be discarded.
* Kenyon, *Conformal invariance of loops in the double-dimer model*,
  arXiv:1105.4158v2, Section 3.2.1, Lemma 1, regroups two perfect matchings
  by union cycles, with two matching assignments per cycle. It allows
  doubled edges. In the present disjoint incidence matchings there are no
  doubled edges, and each alternating incidence cycle contracts to a
  cycle on X. Its regrouping is not a forest-extraction theorem.

Neither literature result supplies disk signs, a fixed-s involution, or
positive orientation differences. All of these must be proved below.
No failed mathematical route or false manuscript assertion has been established
at this point. A bounded search cannot certify this proposition.

For the elementary plane topology used below, the opened source is Reinhard
Schultz, *The Schonflies Theorem in the Euclidean plane*,
https://math.ucr.edu/~res/math138A/winter04/schoenflies.pdf, page 2,
the displayed **Jordan Curve Theorem**. This statement concerns continuous
simple closed curves and separates the plane into a bounded and an unbounded
component, with the curve their common boundary. The stronger smooth statement
on page 1 is NOT substituted for this general statement. The named note has
no canonical document identifier here; its URL, page, and retained source are
the citation. A publisher download of Cairns's 1951 paper returned HTTP 403;
no theorem attribution or DOI from the search summary is used.

A targeted literature search found the staged paper but no independently
verified earlier theorem with this precise paired-state forest conclusion.
This is not a proof of novelty. The integral reformulation and its formal
certification are the contribution proposed for review, not a claim to have
originated the manuscript's proposition.

Source:
`research/openai_manuscript/Paired-states-and-Hamiltonian-cycles-in-cubic-bipartite-planar-graphs-September-24-2026/build/paper.tex`.
The original source is not edited.

## Proof

### 1. Disk sign from the actual state bijection

Take a state r and choose in each t an edge directed from r(t) to another
corner. There is one outgoing edge at each nonroot and none at a root.
Every simple directed cycle C therefore avoids R. Each root can be joined
to infinity through the outer face without meeting C, so all roots are
outside C. Its bounded region consists of original triangular faces.

Let h be the cycle length, I the strictly interior vertices, B and W the
interior black and white faces, and l the boundary edges whose black face
is inside. Let E be the number of edges of this closed triangulated region.
Counting sides gives 3(B+W)=2E-h. Euler's disk relation
(I+h)-E+(B+W)=1 then gives

    B+W = 2I+h-2.                                      (1)

Euler's relation is the usual elementary plane-graph formula: delete
non-tree edges one at a time, merging the two faces separated by each such
edge, until a tree remains. V-E+F stays constant and is 2 for the tree;
omitting the exterior face gives the displayed disk version. This works
with bridges by counting both edge sides. Signed side counting, using
one black and one white face across every interior edge, gives

    3(B-W) = 2l-h.                                     (2)

Every strictly interior vertex is assigned by r to an interior black
face: an incident triangle cannot cross C. A boundary vertex is assigned
to the black triangle supplying its outgoing C edge, and that triangle
is interior exactly in the l counted cases. Conversely, an interior
black face can be assigned only to an interior or boundary vertex. Thus
the bijection, not merely incidence or a face-color imbalance, proves

    B = I+l.                                          (3)

There is no overcounting: two selected edges cannot have the same black
face, and each cycle vertex has exactly one assigned face. Substitute
(3) in (1)-(2). The second expression becomes

    3(2l-h+2) = 2l-h,

so 2l-h=-3. For counterclockwise C the bounded region is on the left,
giving sum_C delta=-3; for clockwise C it is on the right, giving +3.
This argument also covers chords, separating triangles, and a black
triangle whose third corner is another vertex of C. It does not assert
the sign identity for arbitrary oriented cycles without a state.

### 2. The same polynomial cancels at every cyclic second state

For a pair, choose the edge r(t)->s(t) in each black t. All endpoints
are in X. Each vertex has one outgoing and one incoming edge. No edge
can occur twice because an original edge has only one black incident
face. There are no loops or parallel edges since T is simple. Hence
the resulting undirected D is a disjoint union of simple cycles
covering X. The disk result shows

    J(r,s) = (sum_t delta(r(t),s(t)))/3
           = (# clockwise cycles)-(# counterclockwise cycles)

is an integer.

Fix s and a simple undirected cycle C of Q_s, chosen using s alone.
For any partner r, let u(t) be the remaining corner, and orient the
opposite edge as r(t)->u(t). These edges have outdegree at most one
everywhere. On C the h edges require h distinct tails among its h
vertices, so every vertex is a tail, no root occurs, and C is directed.
Replace r(t) by u(t) on precisely these triangles. The set of replaced
assigned vertices is unchanged: both the tails and the heads are
exactly V(C). All other assignments stay fixed. Consequently r' is
again an incidence bijection, is disjoint from s, and reverses C.
The supplying triangles and the chosen cycle depend only on s.
Repeating the replacement restores r, and no r is fixed.

For three corners of a single black triangle, direct examination of
its two cyclic orders gives

    delta(u,s)-delta(r,s) = 2 delta(r,u).                (4)

The disk sign applied with state r to C now gives J(r',s)-J(r,s)=+2
or -2. Thus i^J(r',s)=-i^J(r,s). Any monomial weight depending
only on s is unchanged. For ALL integral incidence weights, including
the single choice made below, the contribution of this fixed s to
Z(z) is exactly zero in Z[i][z,z^-1]. There is no change of weights
between this cancellation and regrouping.

### 3. Integral spoke circulations, including disconnected components

Construct H0 by adding a center to every t in A, drawing its three
incidence spokes inside t, and deleting the original edges of T.
Include all original vertices, even isolated ones. Work with one
connected component K at a time, in its inherited plane embedding;
other components are ignored when defining its faces.

The plane dual of K is connected. For example, a curve joining
interior points of two face regions can avoid vertices and cross
finitely many edges transversely, giving a dual walk. For every
bounded K-face f choose a simple dual path from f to the unbounded
face. For each crossing along that path add an antisymmetric unit
weight to the primal edge, with +1 in the boundary direction that
has the face being left on its left. This adds +1 circulation at
the path's first face, -1 at the last, and zero at intermediate
faces. Summing these integer contributions over all bounded f
gives circulation 1 at each bounded K-face and minus their number
at the unbounded face. A bridge gives a dual loop and is never
needed in a simple path. Isolated vertices require no weights.

Let F be the sum of the bounded-face counts of the separate
components. Each path crosses any edge at most once, so every
center-to-vertex weight a0(t,v) lies in [-F,F]. Summing face
boundaries inside any counterclockwise simple K-cycle cancels all
interior edge sides, including the two sides of a bridge. Its
circulation is exactly the number of K-faces inside the cycle,
a positive integer. This uses faces of K alone: nested components
are not silently counted as extra faces of K.

Put a(t,v)=a0(t,v)+F. Then 0<=a(t,v)<=2F. On every spoke cycle,
center-to-vertex and vertex-to-center traversals occur equally
often, so this gauge shift changes no cycle circulation. For a
state it adds exactly nF to its total weight, independently of
the state. In particular it changes neither fixed-s cancellation
nor the weight difference between orientations.

### 4. Detour simplicity AND orientation

Give a D cycle its counterclockwise orientation. Replace each
selected edge v->w by v->center(t)->w. Different selected edges
belong to different black triangles. Their detour interiors lie
in disjoint open faces; their centers are distinct. A center is
not an original vertex, and original cycle vertices are distinct.
The resulting alternating spoke curve is therefore simple.

For orientation, in the closed triangular face of an edge vw,
the edge and its two-spoke replacement bound the small closed
subdisk excluding the third corner. Its interior contains no
part of the rest of the original cycle: that cycle uses only
original edges, and no second selected edge belongs to this
black triangle. The same is true after other detours because
their open triangular faces are disjoint. Sliding the arc across
this subdisk preserves simplicity and orientation. Locally it
is just the deformation of the base of a topological triangle
to its two other sides, with endpoints fixed. At a shared
endpoint the deformations stay in their respective facial
sectors and do not cross. The third corner may occur elsewhere
on C, but it is excluded from the subdisk and is never moved.
This proves the claimed orientation preservation, rather than
assuming that a visually similar detour has the right sign.

Write L+(C) for the sum of a(t,head) in the counterclockwise
orientation and L-(C) for its reverse. The spoke weight of
v->center(t)->w is a(t,w)-a(t,v). Therefore

    Delta_C := L+(C)-L-(C)
             = number of bounded K-faces inside the detoured C
             >= 1.                                    (5)

Both L+ and L- are nonnegative integers. The component K here
is the one containing this spoke cycle. This discharges the
positivity hypothesis from the ORIGINAL embedded triangles.

### 5. Exact regrouping and nonvanishing at arbitrary size

A fixed D determines which edge was selected in every t: an
edge has a unique black incident face. Its pairs are exactly
the independent orientations of its cycles. Conversely every
such orientation has one head and tail at each X vertex, so
gives two incidence bijections with distinct choices in each
t. There are exactly 2^c(D) pairs in the group. In the incidence
graph these are alternating cycles of length twice the length
of the corresponding D cycle; no bipartiteness of D is assumed.

By Section 1 the counterclockwise cycle contributes -1 to J,
and its reverse +1. The contribution of a single fixed D to
the SAME polynomial from Section 2 is consequently

    product_C (-i z^L+(C) + i z^L-(C))
      = (-i)^c(D) (z-1)^c(D) B_D(z),                    (6)

where, writing q_C=L-(C) and d_C=Delta_C,

    B_D(z) = product_C z^q_C (sum_(j=0)^(d_C-1) z^j),
    B_D(1) = product_C d_C > 0.                         (7)

These are identities over Z[i][z], using
z^(q+d)-z^q=(z-1) z^q sum_(j<d) z^j. No analyticity,
floating-point comparison, generic perturbation, or unstated
distinctness of total state weights is involved.

There is at least one group because a pair exists. Let m be
the minimum c(D). Equations (6)-(7) show that the coefficient
of y^m in Z(1+y) is precisely

    (-i)^m M,    M = sum_(D:c(D)=m) product_C Delta_C.

The indexing family for M is nonempty, and every summand is
a positive integer. Hence M>=1. All lower coefficients vanish,
so Z is nonzero and has EXACT order m at z=1. The individual
monomial degrees are at most 2nF by the weight bound.

For comparison with the manuscript's exponential sum, these same legal
integer weights give Z_exp(x)=Z_poly(exp(x)). Since exp(x)-1 has first
coefficient 1 at x=0, its first nonzero coefficient is also (-i)^m M.
Using a0 instead of the shifted a simply multiplies the sum by
exp(-nFx), which does not change that order or coefficient. Thus the
polynomial formulation has not substituted a different weighted sum
or an incompatible choice of weights for either manuscript calculation.

If every pair had cyclic Q_s, Section 2 would instead make
Z the zero polynomial after summing over s, a contradiction.
Some pair has Q_s a forest. This proves the full proposition
and the integral theorem stated above. No geometric premise
was replaced by the desired conclusion.

## What this does and does not settle

The proof verifies the complete forest-extraction passage, and
adds an integral, exact-order certificate with an explicit degree
bound. The initial prior state had only an open campaign claim
and no verified core decomposition. The improvement is a uniform
argument, not a larger finite search or the known induced-tree
equivalence.

The density/flow proof of `prop:pairs`, the white-tree recovery,
`lem:P-forest`, separating-triangle assembly, and the final dual
Hamiltonicity argument remain separate open nodes. No conclusion
about the correctness of all of them is made here. Likewise a
literature search miss does not earn `novelty_status=verified_new`.
Independent Reviewer assessment of the complete proof, the
statement translation, and publication significance remains required.

## Exact and formal evidence

Run the standalone replay from the campaign root:

    python3 research/paired_state_audit/verify.py

It uses only the Python standard library, rational coordinates, integer
polynomials, and Gaussian-integer coefficients. Each positive fixture is
checked as a simple sphere triangulation with the original face coloring,
the original root deletion, and actual disjoint incidence bijections.
The rational plane drawing, disk equations, fixed-s reversal, detour
simplicity/orientation, integral face circulations, full D-group product,
and minimum-order coefficient are checked independently at their respective
representations. The Jacobian triangle is explicitly relabeled to the
octahedral fixture's actual pair edge set; its typed contract does not
certify the geometry or the universal theorem.
The replay also checks that the current Lean source and fidelity text
equal the actual compiled archive and that its official compiler and
axiom-audit results are successful; it does not rerun Lean itself.

The six fixtures contain 38 pairs in total. The refined octahedron has
four cyclic partnered second states, producing eight nonvacuous involution
checks. The finite replay also includes detours whose third corner is
elsewhere on the original cycle, nested separating-triangle examples,
and groups with different numbers of cycles.

| Fixture | Cyclic partnered s | Minimum order m | Positive mass M |
|---|---:|---:|---:|
| 4-bipyramid (octahedron) | 0 | 1 | 1 |
| 6-bipyramid | 0 | 1 | 2 |
| 8-bipyramid | 0 | 1 | 3 |
| White-face octahedral insertion | 0 | 2 | 4 |
| Two white-face insertions | 0 | 3 | 7 |
| Edge-subdivided octahedron | 4 | 1 | 14 |

A black-face insertion has four states but ZERO disjoint pairs. It is
retained only as an antecedent control, not a counterexample. The smaller
bipyramid examples alone would leave cancellation entirely vacuous;
they were not accepted as a proxy for checking that branch. None of these
finite observations is the proof of the unbounded theorem.

The actual official Lean 4.31.0 run is
`formal_verification.json`: exit code 0, axiom-audit exit code 0,
and `proof_holes=[]`. Its source- and statement-fidelity-bound mechanical
record is
`certificates/C180_ALGEBRA-07940da35750e42c.json`.
In particular `PairedState.cycleSum_nonzero` covers EVERY nonempty finite
family of cycle products with positive integral orientation differences;
it obtains the minimum itself. The other declarations verify the exact
minimum coefficient, all lower zero coefficients, the product
factorization, disk-equation elimination, and involution summation.
`statement_fidelity.md` explicitly identifies the geometric and graph
translation that the compiler does not check.

To obtain a fresh compiler result and ledger record:

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/paired_state_audit/Main.lean --statement-fidelity research/paired_state_audit/statement_fidelity.md --claim C180_ALGEBRA --project-root .

No manuscript assertion was demonstrated false. Consequently this work
does not manufacture an `F_*` refutation claim. The Engineer's support
of the full prose theorem is not independent Reviewer approval, and the
compiler certificate is not a formalization of plane topology or Barnette
Hamiltonicity.

The independent citation queue still contains `HK_STATE_CONVENTION` and
`KENYON_REGROUPING` on the background-only claim `C180_LITERATURE`.
The Engineer opened their primary sources but cannot independently
attribute its own assumptions. `JORDAN_TOPOLOGY` is transparently
source-only (`uncited` in the canonical-ID sense), with the actual
note and statement retained. No literature attribution, novelty verdict,
or Reviewer approval has been fabricated to close these boundaries.
