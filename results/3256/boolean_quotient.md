# Actual-B singleton selection and the Boolean two-cut quotient

## Status and comparison

The full q-color theorem and reverse reconstruction remain unproved.
The accepted `companion_selection.md` only excluded confinement of all
reserved B units to one ordinary two-cut component. Here **every two
distinct actual B units are separated** by those components. Moreover,
each prescribed B unit, alone among actual B, extends to an original
receiver dijoin preserving every ordinary two-cut and q-tight terminal.
The complement is still not asserted to cover larger ordinary cuts or
non-tight terminals.

The same argument puts the remaining paired problem into the precise
language of cube-ideal sets. With three two-cut components, the only
possible failed three-B reservation is a known Q6 configuration. This
is a classification of a possible quotient, not an original digraph
realizing it, an exclusion of it, or a proof of universal descent.

All one-color integrality used below is the primary result already
independently attributed in the accepted tight-cut proof: Schrijver,
*Min-max relations for directed graphs* (1982), Section 8, printed
p.278, (8.1)-(8.4). The explicit connector convex-hull statement
applies both before and after the passive completion. No two-color
integrality theorem is assumed.

### Focused source boundary

The terminology and the known Q6 model were checked in Abdi,
Cornuejols, Guricanova and Lee, *Cuboids, a Class of Clutters*,
October 16, 2019, Sections 1 and 1.1-1.3, printed pp.3-8.
The primary PDF and extracted text are retained in `research/literature/`
under `abdi-cornuejols-guenin-lee-cuboids` (the filename's third
surname is a typo; the actual author is Guricanova).
A cube-ideal set has its
convex hull described by coordinate bounds and generalized set
covering inequalities. Its example R_(1,1) becomes the odd-parity
tetrahedron below after twisting all three coordinates. Q6 is known,
not new, and cube-idealness does not guarantee antipodal points.
No theorem from this paper is needed to prove the statements below.

Two retrieved assertions are specifically **not** assumptions.
Kobayashi-Mahara-Schwarcz, *Reconfiguration of the Union of
Arborescences*, arXiv:2304.13217v2, Theorem 1.1, changes the uncolored
union; it does not reconfigure a prescribed colored decomposition.
The limitation is the absence of the required colored guarantee,
not a counterexample to that paper's theorem.
Abdi-Cornuejols-Pashkovich, *Ideal clutters that do not pack*,
June 24, 2018, Section 3, printed pp.9-10, explicitly warns that
identification can leave the class of dijoin clutters. Thus a quotient
here is not automatically an original graph minor. Generated claims
that Q6 exclusion supplies the desired proof were not verified and
are not used. A retrieved image-only cube-ideal PDF supplied no usable
extracted theorem. These lookups supply no publication qualification.

## 1. Two integral one-color polytopes, not an integral paired polytope

Fix a reviewed arbitrary-size q>=3 normal form and an ordinary
partition with bad receiver F and donor G. Reserve their original
labeled units E, with m>=2 actual B units, all old G. Retain all
original passive topology and internal endpoints.

Let H join the two reserved units of every original ordinary cut
of reserved capacity two. Old F/G makes H bipartite. Parameterize
its h components by x in [0,1]^h: on component j, give an old G
unit receiver weight x_j and an old F unit weight 1-x_j.
Thus x=0 is the old receiver and x=1 the old donor.

Define R0 to consist of those parameters whose receiver covers all
ordinary original cuts. Define R1 by also requiring actual B:

    R1 = R0 intersect {sum_j m_j x_j >= 1},

where m_j is the number of reserved actual B units in component j.
Canonical dominance justifies this **single** added inequality for
all exceptional cuts, also for nonnegative fractional unit weights.

Both R0 and R1 are integral. In original unit coordinates they are
faces, obtained by making ordinary two-cut covering lower bounds
tight, of the known bounded one-color connector polytopes on the
completed and original topologies respectively, with original
unit coordinates outside E fixed to zero. Passing to x is
an affine bijection preserving binary points, not a projection
dropping unit identities.

The half vector lies in R0. It is strict on its box and on every
ordinary cut other than the two-cuts. Consequently R0 has full
affine dimension h. The all-zero point is a vertex. The paired
ordinary polytope is R0 intersect (1-R0); its known nonintegrality
is entirely consistent with both one-color polytopes being integral.

## 2. Every prescribed B singleton extends on all ordinary two-cuts

**Edge-truncation lemma.** Let R be an integral polytope in [0,1]^h
containing 0, and let w be a nonnegative integral vector. If
R intersect {w x>=1} is integral, every edge 0--v of R with w v>0
has w v=1.

**Proof.** The endpoint v is binary. If w v>=2, the new hyperplane
cuts this edge at v/(w v). This point is a vertex of the truncated
polytope: intersect the exposing edge face with the halfspace.
It has a fractional coordinate, a contradiction. QED.

**Actual-B singleton theorem.** For every e in actual reserved B,
there is a binary receiver in R1 whose only actual B unit is e.
It preserves every original ordinary two-cut, all q-tight terminal
counts, original arc uniqueness and every unit identity. In
particular,

    m_j is either 0 or 1 for every component j of H.

**Proof.** Let j contain e. The feasible half vector of R0 has
positive coordinate j. The tangent cone of R0 at 0 is generated
by the directions to its adjacent vertices. Therefore some
neighbor v has v_j>0. All coordinates of such neighbors are
nonnegative and binary. Apply the edge-truncation lemma with
w=(m_1,...,m_h). It gives w v=1. Since m_j>=1 and v_j=1,
necessarily m_j=1 and no other B component is selected.
The binary point v is the required receiver.

Terminal cuts at original q-tight terminals are among H's
two-cuts. Every reserved unit touches such a terminal, so the
receiver takes one unit there and cannot take two copies of one
original arc. Its complement also takes one at every such
terminal. No new capacity, passive adjacency, contact or endpoint
is introduced. QED.

This extends the accepted existential one-sided selection: it
handles **each specified singleton B pattern** while simultaneously
respecting every ordinary two-cut, not just terminal pairing.
It does not establish a prescribed two-color extension. In
particular its complement may lose a larger ordinary cut or a
non-tight terminal. A positive global minimum would need an
integer compatibility obstruction despite all these singleton
receiver choices.

## 3. Exact Booleanization of original ordinary inequalities

Consider an original ordinary cut. If its reserved boundary
contains both old parities of an H component, its receiver
inequality is automatic: two corresponding unit weights sum to
one. Otherwise let J be its set of incident H components, let
a_j>=1 be their boundary multiplicities, and let
l_j(x) be x_j or 1-x_j according as its units are old G or old F.
The inequality is

    sum_(j in J) a_j l_j(x) >= 1.

It is **equivalent on R0** to its Booleanized inequality

    sum_(j in J) l_j(x) >= 1.

Indeed the latter holds at every binary point of R0, since the
former does. Integrality makes it valid on all of R0. Conversely
the Booleanized bound implies the original bound by nonnegativity
and a_j>=1. Replacing all nonautomatic rows this way therefore
describes the same real one-color polytope, not just the same
binary points.

Every nonautomatic Booleanized ordinary row has at least three
components. A row on one component would be violated at the half
vector. A row on two would be tight there. Since the half vector
is a relative interior point of full-dimensional R0, such a
nonconstant inequality cannot be tight. Thus it cannot occur.

Together with Section 2, this proves that R0 and R1 are the convex
hulls of cube-ideal component-coordinate sets, and R1 adds the
squarefree inequality sum_(B components) x_j>=1. This is the
standard terminology from the actually read primary cuboid paper,
not an additional theorem being assumed.

An original two-color repair exists exactly when the binary set

    S1 = R1 intersect {0,1}^h

contains an antipodal pair x,1-x. This preserves all ordinary and
exceptional original cuts, q-tight terminal saturation, all terminal
cut coverage and the original
reserved partition. At a positive global minimum no relevant S1
has such a pair. It has no fixed coordinate because the half
vector is in conv(S1). In the source terminology it is non-polar.
Cube-idealness alone does not contradict non-polarity.

## 4. Complete classification with three components and three B units

Suppose h=m=3. If no reserved binary repair exists, necessarily

    R0 = conv{000,100,010,001,111},
    R1 = conv{100,010,001,111}.

Conversely this pair of polytopes has no antipodal binary pair
in R1. The ordinary paired binary points are exactly 000 and
111, of affine dimension one, while its real ordinary paired
polytope has dimension three.

**Proof.** Each component has exactly one B unit. Every edge
from 0 in R0 therefore ends at a unit vector by Section 2.
Full dimension forces all three unit vectors to be neighbors.
The all-one vertex is also present, as it is old G.

The complement of any unit vector is a two-one vector. If one
were in R0, both it and its unit-vector complement would belong
to R1, a repair. Thus none of the three two-one vectors is in
R0. These exhaust the other binary points. Integrality gives
the first displayed convex hull. Intersecting with sum x>=1
gives the second, already known to be integral.

Explicitly R0 is the cube with the three bounds

    x_i+x_j-x_k <= 1      ({i,j,k}={1,2,3}),

and R1 adds sum x>=1. Its binary vertices are the odd-parity
code, which becomes the known R_(1,1) after twisting all three
coordinates. The ordinary paired binary points are 000,111.
At the half vector all paired inequalities
0<=x_i+x_j-x_k<=1 and all box bounds are strict, so its real
affine dimension is three. QED.

In fact each of the three noncoordinate facets of R0 must be
supplied by an **original ordinary reserved three-cut**, with one
unit from each H component: two old F units and one old G unit.
To see this, a facet of a full-dimensional finitely described
polytope is supplied by one of its original rows. Automatic rows
cannot do so. For a raw row proportional to
x_i+x_j-x_k<=1, its three multiplicities equal an integer a>=1,
and its right side is 2a-1. Equality to that facet requires
2a-1=a, hence a=1.

This is the smallest explicit possible native obstruction, not
its native realization or its exclusion. The prior abstract
non-implication example is now identified as the **only**
three-component failed model under these hypotheses; it is not
presented again as a newly discovered abstract example. Indeed the
primary cuboid paper's Proposition 1.2 already classifies Q6 as
the only ideal non-packing clutter over at most six elements.
The native reduction, not that abstract classification, is the
potentially new step; its novelty has not been verified.

At a positive minimum a donor with two B units is already
excluded by the accepted tight-exceptional-cut gluing argument:
its reserved canonical cut is two-tight, and both exceptional
shore contractions have complete source-sink reachability and
pack by Schrijver. Thus a relevant three-component failure must
indeed have m=3. No general reduction from more components to
three is asserted. Fixing colors or identifying coordinates is
not a proved original-topology minor operation.

## 5. Exact evidence and unresolved step

`boolean_quotient.py` classifies all 64 sets of possible
three-variable, mixed-corner ordinary clauses. It computes all
vertices of both one-color polytopes by exact rational active-row
elimination and checks all binary points. Among the integral
models with no B-splitting pair there is exactly the model above.
There are only six possible clauses: each involves all three
components, and both 000 and 111 satisfy it, so it excludes one
of the six mixed cube corners.
This is a finite **polyhedral classification**, not an original
counterexample. The proof in Section 4 is independent of it.

The script also checks only the new Boolean-quotient and
prescribed-singleton assertions on the existing original contact
and native ordinary-vertex inputs. It expands each singleton
receiver back to original unit labels and checks every original
ideal, q-tight terminal and original arc identity. It makes no
claim that a failed complement is feasible. It does not rerun
the old full-color finite classifications as new evidence.

One inspected `matrix.nullspace.compute` operation computes the
exact affine equations of the classified ordinary binary fiber
from its difference row (1,1,1). Its request, typed output and
execution status are retained; independent rational elimination
checks the canonical basis. Adapter timeout, error or incomplete
output is a non-conclusion.

```bash
python3 -B research/single_defect/terminal_support/marked_boundary/boolean_quotient.py
python3 -B -m unittest discover \
  -s research/single_defect/terminal_support/marked_boundary \
  -p test_boolean_quotient.py -q
```

The remaining mathematical step is topological: exclude native
non-polar quotients at a positive global minimum, or select a
compatible actual multicolor descent. Neither Q6's known
non-packing nor the new singleton theorem supplies that step.
In particular no duplicate receiver units may be invented to
simulate a third color. General larger-cut and non-tight-terminal
donor preservation, full-q reconstruction, verified novelty and
publication significance remain open.
