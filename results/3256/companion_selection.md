# Tight-cut compatibility and the discrete companion-selection gap

## Status, comparison and source boundary

The accepted terminal-path theorem proves receiver safety, not universal
donor repair. This continuation addresses a positive global minimum
directly: its bad/donor pairs would need a hidden equality among all actual
B units in the **integer hull** of ordinary repartitions. No such equality
is forced by terminal or ordinary two-unit-cut parity constraints.

The distinction matters. The new native q=3 example proves that the paired
ordinary relaxation is nonintegral **without any B inequality**. The earlier
`global_extension.md` counterexample needed an actual-B row in its active
basis and left ordinary-only integrality unresolved. The old numerical
misses in `rounding_probe*.json` are not repeated or promoted to evidence.
Neither nonintegrality result is packing nonexistence. The new example has
four explicitly verified B-splitting binary patterns in its displayed face.

The only new imported result is the known one-color convex-hull statement
in Schrijver, *Min-max relations for directed graphs* (1982),
DOI 10.1016/S0304-0208(08)72456-3, Section 8, printed page 278,
equations (8.1)-(8.4). For selectable reversals of original topology arcs,
the hypotheses of Theorem 6 hold. The bounded strong-connector polytope
(8.2) is the convex hull of connector incidence vectors. This is the
Lucchesi-Younger **one-color** conclusion; it is not a packing theorem.
Explicitly, for a selectable reversal (v,w), the fixed topology has
(w,v). In Theorem 6 take v'=v and w'=w, using that original arc and
the two zero-length paths. Distinguish parallel selectable unit copies.
The primary statement and its explicit polyhedral interpretation were read
in `../../../literature/schrijver1982-ly-integrality.txt`.

A single targeted web lookup did not supply a verified theorem for
color-specific complementary arborescence variables. Its generated answer
contained unsupported examples and is not adopted. The actually obtained
primary Berczi-Frank survey, *Packing Arborescences*, RIMS Bessatsu B23,
Section 4.1, printed pages 18-20, describes a common base for the **uncolored
union** of arborescences. It does not assert integrality of a particular
red/blue decomposition polytope. The PDF and extraction are retained in
`research/literature/berczi-frank2010-arborescences.*`. No result from this
survey is an additional mathematical assumption here.

The general q-color theorem, full reconstruction, novelty and publication
significance remain unproved. The new arbitrary-size facts below are
partial lemmas or conditional reductions and require independent review.

The Host accepted this note's tight-cut, affine and exact ordinary-vertex
claims on 2026-11-04T08:12:09Z. The subsequent
`boolean_quotient.md` strengthens separation to **one actual B unit per
two-cut component**, with a receiver for every prescribed B singleton,
and identifies the known Q6 geometry as the unique possible blocked
three-component model. Those stronger claims await their own review;
neither they nor the accepted claims give universal donor repair.

## 1. All ordinary two-unit cuts can be made compatible

Fix an arbitrary-size reviewed q>=3 normal form and any ordinary partition,
with a B-missing color F and a color G having m>=2 actual B units. Write E
for their distinguished reserved units, c(U)=|E intersect delta+(U)| and T
for the original q-tight terminals. Every unit of E touches T, and every
terminal in T has exactly two E units, one of each old color.
Consequently one unit per color at T also forbids either new color
from taking two copies of the same original arc.

Form a graph H on E: join the two units of every original **ordinary** cut
with c(U)=2. The old F/G coloring makes H bipartite. The terminal equations
are included because each T terminal's original cut is ordinary and has
reserved capacity two. Every binary assignment satisfying the two-unit
cuts is exactly a choice of which components of H to flip relative to F/G.
All m reserved B units have old color G.

**Tight-cut separation lemma.** The actual reserved B units meet at least
two components of H. In particular these parity constraints cannot force
all B units to remain in one color.

**Proof.** On original unit coordinates consider

    Q = {0<=y_e<=1 : y(delta+(U))>=1 for every original ideal U,
                       y(delta+(U))=1 for every ordinary U with c(U)=2}.

In the covering inequalities only reserved unit coordinates are used.
The one-color connector convex-hull theorem applies to these units,
with every original passive topology arc retained. Giving zero capacity
to other selectable reversals is a coordinate face. Each equality in Q
is the face where a valid original covering lower bound is tight. Thus
Q is integral. Terminal equalities and incidence with T make it bounded
even without writing the displayed upper bounds.

Every ordinary cut has c>=2. Canonical dominance and m>=2 give the same
for every exceptional cut. Consequently the uniform vector y_e=1/2
belongs to Q.

Suppose all actual B units lie in one component of H. On any binary point
of Q, every edge of H has opposite assigned values; all its old-G
vertices therefore have the same value. The B coordinates are either all
zero or all one. The former misses the original canonical cut, so every
binary point of Q assigns one to every B coordinate. Their convex hull
cannot contain the uniform half vector, contradicting integrality. QED.

This argument uses actual original B, not an arbitrary marked subset.
It uses no kernel normalization, contact deletion or weighted-two packing
claim. It also applies when two-unit cut shores cross and when their unit
incidences have unbounded degree; they need not be two disjoint block
families.

**One-sided simultaneous selection lemma.** There is a binary union of
components of H which makes F an original dijoin, splits actual B
nontrivially between F and G, and leaves each color one unit on every
ordinary reserved two-cut and at every terminal in T.

**Proof.** Write the uniform half vector as a convex combination of binary
points of Q. Every such point meets actual B. If each point took every B
unit, their average would do so too. Choose one which omits a B unit.
It takes a nonempty proper subset of B and meets every original cut.
On the two-unit cuts its complement also has count one. The component
description gives exactly a compatible original-unit reassignment. QED.

This is deliberately **one-sided**. The complement can miss an ordinary
cut of reserved capacity at least three. In particular, a non-tight
original terminal whose reserved degree is at least three is not silently
assumed safe. All q-tight counts and capacities are preserved; preservation
of every other cut and non-tight terminal is precisely not established.
Any complement-missed cut has original capacity at least q+1: it has at
least three reserved units and each of the q-2 unchanged colors contributes
at least one. Actual B protects all exceptional cuts, so the possible
failures are ordinary. No new passive adjacency or capacity is introduced.

## 2. A necessary obstruction at a positive global minimum

Let P be the paired ordinary interval polytope on the same E:

    0<=y_e<=1,
    1<=y(delta+(U))<=c(U)-1        for every original ordinary ideal U.

The terminal equalities at T follow from these constraints. Its binary
points are exactly the ordinary two-color repartitions within E; they
preserve every original capacity and all ordinary terminal coverage.

At y=1/2, every coordinate bound is strict and every ordinary inequality
with c(U)>2 is strict. Hence

    aff(P) = {y : y_e+y_f=1 for every edge ef of H}.

There are finitely many original ideals, so sufficiently small
perturbations in this affine space remain in P. There is no assumption
of integrality in this observation.

**Positive-minimum obstruction theorem.** At a positive global minimum
of the number of B-missing colors, for every bad/multiple-B pair,

    aff(conv(P intersect {0,1}^E)) is a proper affine subspace of aff(P).

Specifically, its integer hull forces equality of every pair of actual
reserved B coordinates, but aff(P) does not.

**Proof.** A binary ordinary repartition splitting B would replace one bad
and one good color by two good colors while leaving every other color
unchanged. This contradicts global minimality. Thus every binary point of
P gives B wholly to one color, so all its B coordinates are equal.
There is a multiple-B donor whenever the global minimum is positive:
the full partition allocates all |B|>=q units among q colors.

Section 1 puts B in at least two components of H. Flip one such component
from the uniform half vector by adding epsilon to its old-G coordinates
and subtracting epsilon from its old-F coordinates, with
epsilon=1/(4|E|). The two-cut equalities are unchanged. Every other
ordinary inequality has half-vector slack at least 1/2 and changes
by at most |E|epsilon=1/4; the coordinate box remains satisfied.
This explicit rational point of P gives distinct values to B coordinates
in different components. Therefore the equality is not in aff(P), and
the integer hull has smaller affine dimension. QED.

It would consequently suffice to prove that these particular fibers have
no hidden B-coordinate equality, even though their polytopes need not be
integral. Full affine spanning of their binary points is a stronger
sufficient condition. Neither condition is proved in arbitrary size.
Existence of ordinary partitions and one-color integrality alone do not
give either condition, and allowing third-color changes is still permitted
by the mission.
To contradict a given positive minimum it is enough to find one
bad/multiple-B pair whose binary integer hull does not equate its B
coordinates. A multicolor descent is another possibility. Repairing
every prescribed reservation is not an added acceptance requirement.

The theorem is a necessary obstruction, not the desired contradiction.
It identifies what a positive minimum must do beyond local parity and
the accepted receiver lemma. Section 1 is explicitly a consequence of
known one-color integrality; no publishable originality claim is attached
to it.

Even ordinary **integer decomposition** plus integrality after the marked
cut would not justify an abstract affine-spanning inference. For example
take R=conv{000,100,010,001,111}. It has a unimodular triangulation
along the segment 000--111, with tetrahedra
conv{000,111,e_i,e_j} for the three unordered pairs i,j. Thus R has the
integer decomposition property. The truncation R intersect
{x1+x2+x3>=1} is the integral tetrahedron conv{100,010,001,111}.
But R intersect (111-R) has the half vector in its ordinary interior,
while its only binary points are 000 and 111. They have a one-dimensional
affine hull. This elementary abstract model is **not** a digraph or a
counterexample to the mission. It prevents replacing a new topological
argument by a false general polyhedral implication.

## 3. Native ordinary-only nonintegrality

Use the sources s,r,d,a0,a1,a2,a3 and sinks t,y,z. Retain all source-sink
arcs except s->t. The internal heads have the following original source
footprints and sink descendants:

    N00: {a0,a3} -> t,       N01: {a1,a2} -> t,
    N03: {a3,a2} -> t,       N10: {a0,a1} -> t,
    N12: {a2,a0} -> t,
    R1: {s,a1} -> y,z,       R3: {s,a3} -> y,z,
    R0: {s,r,d} -> y,z.

Also retain s->P->y,z and r,d->W->y,z. The vertex W is entirely passive.
Take the full transitive closure, never deleting zero-capacity arcs.
The old colors are

    F: s->y, r->t, d->t, a0->N00, a1->N01, a2->t, a3->N03, P->z;
    G: s->z, r->t, d->t, a0->N10, a1->R1,  a2->N12, a3->R3,  P->y;
    H: s->R0, r->y, d->z, a0->t, a1->t, a2->t, a3->t.

Capacities are multiplicities. This is an original q=3 strict-slack
normal form, not a surrogate endpoint network: 20 vertices, 23 units,
all sources and y,z tight, t of degree nine, no contacts, capacities
one or two, original minimum three and nonterminal minimum four.
Actual B has four units with old counts (0,2,2).

Fix H and every F/G unit except the two outgoing units at each a_i.
Let x_i indicate swapping that pair. This defines a coordinate face of
the original assignment relaxation: fixed colors are coordinate faces,
and original tight-terminal equations leave exactly these four variables.
No extra equality is imposed artificially.

The point

    (x0,x1,x2,x3) = (1/2,1,1/2,0)

satisfies every original ordinary inequality. In fact it fractionally
covers every original cut and gives B weights (1,1,2). These latter facts
are checked but are **not used as active defining constraints**.

The original ordinary ideals

    U = {a0,a1,a2,N01,N10,N12},
    V = {a0,a2,a3,N00,N03,N12}

give active color lower bounds

    G(U)>=1:  x0-x1+x2 >= 0,
    F(V)>=1:  x0-x2+x3 >= 0.

Their old full color counts are respectively (2,1,3) and (1,2,3).
Together with x1=1 and x3=0 these are four independent active
inequalities. Their original active matrix is

    0  1  0  0
    0  0  0  1
    1 -1  1  0
    1  0 -1  1

with determinant of absolute value two. The point is a fractional vertex
of this face and therefore of the **ordinary-only** native paired and
full-q relaxations. The source and sink side labels have not been made
independent. The proof does not infer nonintegrality from numerical output.

### Exact companion implication, not packing nonexistence

Every binary point in this face satisfies the integer-hull inequality

    x0+x3 >= x1.

Add the two displayed ordinary inequalities, x3>=0 and -x1>=-1, and
divide by two. This yields x0-x1+x3>=-1/2. Its left side is integral
at a binary point, so round the right side up to zero. The fractional
vertex has left side -1/2 and is excluded.

Thus acquiring the B unit at a1 while retaining the donor's B unit at a3
requires the non-B companion at a0. The assignment (1,1,0,0) supplies it:
four original units are recolored, all original cuts are covered and
B counts are (1,1,2). This is an example of a discrete compatibility
implication, not an obstruction to compatible selection in general.

Exactly eight of the sixteen binary points in the face are ordinary:

    0000, 0001, 0011, 0111, 1000, 1100, 1110, 1111.

Four split B. The four directions 1000,0001,0011,0111 from 0000 are
independent. Hence this **nonintegral** face still has a full-dimensional
integer hull. It does not display the dimension loss required by a
positive global minimum in Section 2, nor is its bad starting state
globally minimizing.

The complete reserved fiber, not just this face, has seven two-cut
components. All 128 compatible unit-labeled component assignments are checked:
64 are ordinary and 32 split B. Its integer hull has affine dimension
seven, equal to its real ordinary affine dimension. Thus neither the
displayed face nor the complete reserved fiber exhibits the hidden
equality required by a positive minimum.

## 4. Exact replay and remaining obligation

`companion_selection.py` reconstructs the full original topology and
enumerates every original ideal, not just projected or active shores.
The native input has 3,585 proper ideals, of which 3,583 are ordinary.
It checks the capacity threshold, strict nonterminal threshold, exact
fractional coverage, all sixteen face patterns, the complete 128-assignment
reserved fiber, all terminal counts
of the explicit repair, the passive W and the rank-one hull inequality.
The dedicated inspected Jacobian determinant payload is reconstructed
from the active original rows and checked by independent rational
elimination. Adapter error, timeout or incomplete output is a
non-conclusion. The new operation completed with exit zero, no timeout
and no structured error; its exact typed determinant is 2. Discovery,
contract, payload, output and execution receipt are retained under
`research/single_defect/jacobian/companion_ordinary*`.

```bash
python3 -B research/single_defect/terminal_support/marked_boundary/companion_selection.py \
  --adapter-payload research/single_defect/jacobian/companion_ordinary_determinant_payload.json \
  --adapter-output research/single_defect/jacobian/companion_ordinary_determinant_output.json \
  --adapter-status research/single_defect/jacobian/companion_ordinary_determinant_status.json
python3 -B -m unittest discover \
  -s research/single_defect/terminal_support/marked_boundary \
  -p test_companion_selection.py -q
```

The failed route is ordinary-polytope integrality followed by tight-cut
parity separation. Its integrality premise is now exactly refuted on a
native normal form; this does not refute the weaker affine-spanning
criterion or unrestricted simultaneous exchange. Universal selection
preserving every original cut, every non-tight terminal and all good B
colors remains unproved. The accepted conditional reverse reconstruction
must not be applied until that gap is closed.
