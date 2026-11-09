# The sharp terminal-reachability threshold for capacitated dijoin packing

## Abstract

For a finite digraph, count the ordered source--sink pairs of its
strong-component condensation that are not joined by a directed path.
We prove that if this number is at most two, every nonnegative integral
arc-capacity vector of minimum dicut value at least q admits q
capacity-feasible dijoins, for every integer q >= 1. The numbers of
vertices, sources and sinks, the capacities, and q are unrestricted.
Zero-capacity arcs remain part of the topology. The threshold two is
best possible for this weighted statement: Schrijver's known example,
as described by Williams, has exactly three missing pairs, minimum
dicut value two, and no packing of two dijoins.

The structural ingredients are an exact contact-cover expression for
cut minima, a topology-weakening operation at one unit-weight head,
simultaneous colored-root extensions, and induction on actual reserved
capacity vectors. In particular, a recursive reserved input need not
retain the strict normal form of the input that produced it. We
compare the result with the stronger matroid criteria of
Abdi--Cornuejols--Zlatin, including their lifting machinery, rather
than only their numerical bound on rho. We do not claim a new
counterexample to the unit-capacity Woodall conjecture.

## 1. Definitions, theorem, and scope

A dicut is delta+(U), where U is a nonempty proper vertex set with no
entering arc. We call such a set an ideal. Empty outgoing boundaries
are allowed in this definition. A dijoin meets every dicut.
For w : A(D) -> Z_{\geq 0}, a w-packing of q dijoins is an indexed
family J_1,...,J_q of original arc sets such that

    #{i : a in J_i} <= w(a)                  for every original arc a.

Members may overlap when capacities permit. Giving every original
arc capacity one makes them pairwise arc-disjoint.

All topology in this paper includes the capacity-zero arcs. Let H be
the condensation of D, let S and T be its sources and sinks, and put

    def(D) = |{(s,t) in S x T : s does not reach t in H}|.

A path of length zero counts. In particular a one-vertex condensation
has defect zero, not one. If there is a dicut of positive minimum
capacity, the condensation is weakly connected and has no isolated
vertex. Otherwise a union of weak components supplies a zero dicut.

**Theorem 1 (two-defect packing).** Let D be a finite digraph and
let w be a nonnegative integral capacity vector. If def(D) <= 2 and
every dicut has capacity at least q, where q >= 1 is an integer,
then D has a w-packing of q dijoins.

When D has no dicuts, take q empty members. Otherwise Theorem 1
gives equality between the maximum integral dijoin-packing value and
the minimum dicut capacity: the opposite inequality follows by
counting uses of any minimum dicut.

**Corollary 2 (sharp defect threshold).** Among the classes defined
only by def(D) <= d, the capacitated packing equality holds
universally for d = 0,1,2 and fails for every d >= 3.

The positive assertion is Theorem 1. For the negative assertion use
the *known weighted* example in Section 11. No classification of
individual graphs with three or more missing pairs is asserted.

The zero-defect case is Schrijver's source--sink-connected theorem
[S, Theorem 4]. Our contribution is the structural passage beyond
that case, together with the cut-preserving and capacity-preserving
reconstruction arguments below. The binary unit-capacity case is
already known without a defect restriction [ACZ, Section 1.1, P1];
the theorem here is not advertised as solving that case for the
first time.

## 2. Original capacities and elementary reductions

Contract strong components first. An ideal cannot split a strong
component, so dicuts and the external arc capacities are unchanged.
Internal arcs need not be selected. We henceforth work in an acyclic
full topology. Parallel capacities may be combined, retaining labels
for their original integral units. Add transitive arcs with capacity
zero when convenient. This changes neither ideals nor reachability.
An auxiliary transitive arc is not a new original resource.

For an arc uv and an ideal U, write

    h_uv(U) = [u in U] - [v in U] in {0,1}.

Thus every selected cut count is the sum of its vertex divergences.
In particular ideal-cut counts are modular:

    x(delta+(U)) + x(delta+(W))
      = x(delta+(U intersection W)) + x(delta+(U union W)).       (1)

The following reconstruction rules will be used explicitly.

**Lemma 3 (quotients).** Identifying vertices, followed by
strong-component contraction, cannot increase the defect. If the
original missing pairs form a common-source star, a common-sink star,
or a matching, the quotient missing pairs have the same respective
property, possibly with fewer pairs. Every quotient dicut lifts to an
original dicut.

**Proof.** The preimage of a quotient source component contains an
original source; dually a quotient sink preimage contains an original
sink. Choose one such representative for each quotient terminal.
An original path projects to a quotient walk. Every unreachable
quotient pair therefore gives an unreachable original pair between
the chosen representatives. Different quotient sources have disjoint
preimages, as do different quotient sinks. This is an injection on
missing pairs and preserves the three stated incidence patterns.
Preimages of quotient ideals are original ideals. QED.

**Lemma 4 (tight gluing).** Suppose delta+(U) has integral capacity q.
If the quotients obtained by contracting U and by contracting its
complement both have q-packings, those packings reconstruct to an
original q-packing.

**Proof.** Distinguish the q boundary units. In either quotient, q
members must each use one boundary unit and exhaust all q units.
Relabel the members on both sides by this unit and merge equal
labels. This respects every original capacity.

For completeness consider an original ideal W and a merged member J.
If W is contained in U, or contains U, its coverage follows from the
appropriate quotient. The same applies to the disjoint and full-union
cases using the other quotient. In the remaining crossing case,
U intersection W and U union W are nonempty proper quotient shores.
Both terms on the right of (1) are positive for J, whereas
J(delta+(U)) = 1. Consequently J(delta+(W)) >= 1.
This proves coverage of every original dicut. QED.

Two capacity reductions are also exact. Replacing one unit each of
uv and vz by one unit of uz uses

    h_uv + h_vz = h_uz.                                           (2)

If x is a source, y a sink, u,v internal, u reaches v, and x reaches y,
replace units xv and uy by one unit xy. Then

    h_xv + h_uy - h_xy = h_uv in {0,1}.                           (3)

The right side is zero on terminal cuts. If every nonterminal cut
has capacity at least q+1, the reduction preserves the lower bound q.
In either reduction total capacity decreases. On reconstruction,
assign any occurrence of the added unit to its two original units
in the same color. Equations (2)--(3) preserve coverage, and the two
capacities decreased on the forward step pay for the expansion.
Previously existing shortcut units keep their original identities.
Reverse a sequence of steps one at a time; repeated membership in
one original arc set can simply be collapsed.

An arc of capacity at least q can instead have its endpoints
identified. Lift a quotient packing and add that original arc to
every member. An original ideal not crossed by it keeps both
endpoints on the same side and survives also the new
strong-component contraction. Every other ideal is covered by the
added arc. Thus no capacity is exceeded.

**Lemma 5 (strict fixed-q form).** In a quotient-closed defect class,
a counterexample chosen with the fewest condensation vertices and
then least total capacity, at a fixed q >= 2, has the following form:

* every q-tight dicut is a singleton-source or co-singleton-sink cut;
* every positive unit touches a q-tight original terminal;
* every combined positive arc capacity is less than q;
* no vertex has both positive incoming and positive outgoing capacity;
* if an internal positive tail p reaches an internal positive head n,
  every active input x->n and active output p->y satisfy
  (x,y) missing.

**Proof.** A nonterminal tight cut is disposed of by Lemmas 3--4
and vertex minimality. If a positive arc belongs to no tight cut,
decrease its capacity by one. Integrality preserves all lower bounds,
contradicting capacity minimality. The large-arc reduction gives the
third property. Equation (2) gives the fourth, and (3), together with
strict nonterminal slack, gives the last. All reverse operations
were justified above. QED.

Call the resulting form strict. Its positive units have types

    source -> sink,       source -> N,       P -> sink,

where N and P are disjoint internal positive-head and positive-tail
sets. A **contact** is full-topology reachability p->n, with p in P,
n in N, not necessarily a listed arc. Put

    a(v) = {s in S : s reaches v},
    z(v) = {t in T : v reaches t}.                                (4)

At q=2 every positive arc has capacity one after parallel combination.
Any terminal having an internal positive unit is two-tight.

## 3. Every terminal pattern has an exact contact-cover minimum

For an ideal U set A = S intersection U and B = T intersection U.
Then

    (S minus A) x B consists entirely of missing pairs.            (5)

Conversely every nonempty A subset S and proper B subset T satisfying
(5) occurs. Its ideals form the interval between the forced ideal
and forced filter

    L = A union Anc(B),
    R = (T minus B) union Desc(S minus A).                         (6)

These are disjoint. The lower endpoint L is nonempty, the complement
of R is proper, and all ancestors and descendants use the full
topology. This also proves the converse.

An ordinary ideal has B empty or A=S. With exactly two missing pairs,
the exceptional patterns are precisely these:

    common source s:  A=S\\{s},  empty != B subset {t1,t2};
    common sink t:    B={t},     empty != S\\A subset {s1,s2};
    matching pairs:  A=S\\{si},  B={ti}, for i=1,2.                (7)

This is just the classification of nonempty rectangles in a two-edge
star or matching.

For a selected unit set F let d_F denote terminal degrees,
n_F(n) its number of inputs at n, and p_F(p) its number of outputs
at p. Set N_f=N minus (L union R), and similarly P_f. On the bipartite
contact graph between P_f and N_f give p weight p_F(p) and n weight
n_F(n). Zero-weight vertices are retained. Let nu_F(A,B) be its
minimum vertex-cover weight.

**Lemma 6 (exact projection).** The minimum F-boundary count over
the *original* ideals of pattern (A,B) is

    m_F(A,B) =
        sum_(s in A) d_F(s) - sum_(t in B) d_F(t)
        + sum_(p in P intersection L) p_F(p)
        - sum_(n in N intersection L) n_F(n)
        - sum_(n in N_f) n_F(n) + nu_F(A,B).                     (8)

**Proof.** Use divergence inside U. After subtracting the first five
terms of (8), the remainder is exactly the weight of the contact cover

    (N_f minus U) union (P_f intersection U).

It is a cover because p reaching n forbids p outside and n inside.
For the reverse inequality take a minimum cover Q_P union Q_N and put

    U = L union Anc(N_f minus Q_N).

This is an original ideal of the required pattern and avoids R.
Every included free P vertex is an ancestor of a chosen free N
vertex and hence belongs to Q_P. Further included N vertices can
only lower the induced cover cost. Thus the induced cost is at most
the minimum cover cost, proving equality and attainment. QED.

The ordinary specializations are worth recording. For nonempty
A subset S, let N_A,P_A have source footprints contained in A and
let nu_F(A) be the corresponding contact-cover optimum. For nonempty
C subset T use P^C,N^C with sink footprints contained in C and
contact optimum eta_F(C). Then the no-sink and all-source minima are

    g_F(A) = sum_(s in A) d_F(s) - sum_(n in N_A) n_F(n) + nu_F(A),
    h_F(C) = sum_(t in C) d_F(t) - sum_(p in P^C) p_F(p) + eta_F(C).
                                                                    (9)

The first has source set A and no sink; the second contains every
source and excludes exactly the sinks C. These two types exhaust
the ordinary ideals. Formula (8) applies to any number of defects;
it is not a two-defect coloring assertion.

## 4. Unit-head erasure and ambient, not strict, recursion

Here is a useful strengthening of the single-star erasure argument.
It treats *all* terminal-pattern minima in one calculation.

**Lemma 7 (unit-head topology erasure).** In a strict binary form
let n in N have total positive input one and have a contact.
Assume the contact restriction of Lemma 5. There is an acyclic
topology D_n on the same vertices and original positive units with:

1. identical terminal sets and footprints (4);
2. every terminal-pattern capacity minimum decreases by at most one;
3. the singleton-source and co-singleton-sink family minima unchanged;
4. minimum dicut capacity at least two and fewer reachability relations.

Every packing in D_n transfers unchanged to D. The topology D_n is
not asserted to remain strict.

**Proof.** Keep all source-to-vertex and vertex-to-sink reachability
arrows of D, and all p->m contacts except those with m=n. Give each
original positive arc its unchanged capacity and identity, and every
other retained or added arrow capacity zero. Repeated listings are
one topology arrow, not another unit.

Every listed arrow was an old reachability relation, so no new
reachability is created. The direct terminal incidences retain all
the footprints. The only internal-to-internal arrows are from P
to N; they cannot concatenate because P and N are disjoint.
Consequently the contact relation is exactly the old one with the
edges into n removed, and at least one reachability relation is lost.

For any terminal pattern, the forced memberships and all the
non-cover terms of (8) depend only on footprints and positive units.
They are unchanged. Deleting cover edges into a weight-one vertex
lowers a cover optimum by an amount in [0,1]: add n to a new cover
to cover the old graph. For an arbitrary selected set F the sharper
loss bound is n_F(n), either zero or one.

Choose a contact p->n and an active input x->n and output p->y.
The contact restriction says x cannot reach y. A source ancestor
of p is therefore different from x, giving |a(n)| >= 2. A sink
descendant of n is different from y, giving |z(p)| >= 2 for every
contact tail at n. Thus none of the removed edges occurs in a
source cover with singleton A, or in a sink cover with singleton C.
The two stated terminal family minima in (9) are unchanged.

Every other original terminal-pattern family consists entirely of
nonterminal cuts, so its original minimum is at least three. Losing
at most one leaves at least two. The unchanged terminal families
also have minimum at least two. Formula (8) exhausts all patterns,
so D_n has the required lower bound.

Finally every old ideal remains an ideal of D_n, with the same
positive boundary. Any packing of D_n is therefore already a packing
of D on exactly those original units; there is nothing to expand. QED.

**Proposition 8 (binary contact-free reduction).** For defect at most
two, binary packing reduces to the strict contact-free forms.

**Proof.** Choose a failing condensation lexicographically by

    (number of vertices, total capacity, number of reachability pairs).

Lemmas 3--5 apply to its first two entries. With a common missing
source, each active head having a contact has inputs only from that
source; parallel combination and capacity less than two make its
input exactly one. The same is true for a matching of missing pairs.
With a common missing sink reverse all arrows first. A single
missing pair is included in these cases. For defect zero use [S].

If a contact exists, Lemma 7 gives a failing ambient input with the
same first two entries and smaller third entry, a contradiction.
Otherwise the chosen failure is contact-free. This is the claimed
reduction. Notice that newly created nonterminal two-tight cuts are
permitted in the recursive input; applying a strict contact-free
theorem directly to D_n would be unjustified. QED.

## 5. Colored roots and simultaneous binary marks

### 5.1 Ordinary extension

In a contact-free binary form represent an original unit X->n by
one auxiliary source-side choice edge from X to any member of
a(n) minus {X}. Dually p->Y has a sink-side edge from Y to any
member of z(p) minus {Y}. A direct unit X->Y is a shared root label
at X and Y, with the same prescribed color on both sides.
One-sided root labels will also be allowed.

Every internal footprint here has at least two terminals. Otherwise,
for example, Anc(n) with a(n)={X} has capacity at most 2-1:
X is two-tight and there are no contact tails preceding n.
This contradicts the minimum-two assumption. The sink argument is
dual. Thus the auxiliary choice sets are nonempty.

A nonempty terminal set is closed when all its possible choice
edges remain in it, ignoring root labels. The minimal closed sets
are the terminal strong components of the possible-edge network.
On each side they are disjoint.

**Lemma 9 (colored-root extension).** A prescribed binary root-label
coloring extends to two ordinary original colors precisely when
every minimal closed source and sink component has both root colors.
The assertion also holds for a modified system with one-sided
virtual roots.

**Proof.** Necessity is root reachability. For sufficiency reverse
the source choice edges. One original internal unit becomes a
directed hyperarc with head X and tail set a(n) minus {X}. For a
nonempty source set A let h(A) count entering hyperarcs, r(A) its
root labels and c(A) the number of root colors present.
The uncolored ordinary bound (9) is h(A)+r(A) >= 2.
If c(A)=0 it gives h(A)>=2. If c(A)=1 and h(A)=0, A is closed
and contains a minimal closed component with both colors, a
contradiction. Hence

    h(A) >= 2-c(A).                                               (10)

Here h is submodular: a hyperarc's indicator is [head in A] minus
[its head and entire tail set contained in A]. The right side
of (10) is intersecting-supermodular, being two minus the rank
of the two-color partition matroid on roots in A.

Each hyperarc can be trimmed to one of its possible ordinary arcs
while preserving (10). Indeed, if no tail z were possible, for
each z there would be a tight set A_z containing the head and z
but not the whole tail set. Tight sets through the head are closed
under union and intersection by submodularity and intersecting
supermodularity. A hyperarc entering two such tight sets must also
enter their union; otherwise its strict submodularity contribution
contradicts tightness. Inductively their union would be entered
while containing the entire tail set, which is impossible.

Keep at most one root label of each color at each vertex for this
invocation. Root placement is independent in the rank-two
partition matroid, and (10) is exactly the hypothesis of
Durand de Gevigney--Nguyen--Szigeti [DGNS, Theorem 1.6].
Their matroid-based arborescence packing gives arc-disjoint rooted
trees covering every vertex once in each root color. Group by
color and reverse back. Every source now reaches a root in each
color. Restore unused precolored labels and do the independent
sink construction with the same shared-label colors.

A root-reaching path crosses the outgoing auxiliary boundary of
every nonempty terminal set not already containing its root.
Its exact count is the corresponding zero-contact expression in
(9). Thus all original ordinary dicuts, not merely terminal cuts,
are covered. Tight-terminal saturation exhausts every original
unit, since each positive unit touches a two-tight terminal. QED.

Making an internal unit a one-sided virtual root can only increase
an uncolored ordinary minimum. Its assigned color can be expanded
back through a chosen allowed endpoint whenever that endpoint has
an already constructed path to a real root in the same color.
This changes no original unit or color. Such expansions below are
ordered explicitly; a cycle of unexpanded virtual roots is not
accepted as an expansion.

### 5.2 The two block families

The minimal closed components give two disjoint families of root
blocks; every block has at least two labels. Put a vertex on each
block and an edge on each label, joining its source and sink blocks.
A missing placement has a private unconstrained endpoint.
Valid color-zero incidence vectors satisfy

    0 <= x_e <= 1,
    1 <= sum_(e incident Q) x_e <= |Q|-1                           (11)

at constrained vertices. This is an integral bipartite
degree-interval polytope, by integral circulation. Its half-vector
is feasible. Only two-label blocks are tight there.

Consequently a pairwise equality or opposition is forced exactly
by the equations x_e+x_f=1 for binary blocks. Those equations form
paths and even cycles on labels; labels in different components
have no forced relation. This follows also directly from the
affine hull at the half-vector and integrality of (11).

Before any occurrence is suppressed, a binary closed block is a
single original two-tight terminal: a block containing two or more
terminals has an attaining nonterminal cut and at least three
labels. A singleton closed terminal has no remaining internal
unit, because every internal unit has another possible endpoint.
Thus binary chains are subchains of the original terminal-pair
graph, obtained by pairing units at each two-tight terminal.
Crossings of an actual ideal along such a chain alternate parity.

Two useful consequences will be used. Distinct sink-only labels
can be given opposite colors: if related, they are the ends of
a binary path on the same block side and hence forced opposite;
otherwise choose opposition using (11). The source version is
dual. Also a *complete* root-incidence cut with at least two
outgoing labels and no incoming label can be made bichromatic.
If all its labels were forced equal, they would lie on one binary
path or cycle in the same traversal direction. Their net crossing
number would be at least two, impossible for a path, whose net
change is at most one, or a cycle, whose net change is zero.

### 5.3 Two marks, but not three arbitrary marks

**Lemma 10 (two simultaneous marks).** Add at most two marked root
sets to (11). Suppose each contains an opposite-parity pair in one
binary component, or meets at least three binary components.
One valid coloring makes both marked sets bichromatic.

**Proof.** Suppress binary constrained vertices in the bipartite
incidence graph. A path is one signed variable; each variable has
at most two ordinary incidences, of opposite signs if there are two.
A path returning to one constrained vertex satisfies that vertex
automatically, so discard that constraint. The remaining ordinary
constraints are signed not-all-equal clauses of length at least
three on distinct variables. Each nonautomatic mark can be replaced
by a signed three-variable clause on three of its components.

In a clause-minimal unsatisfiable system the signed coefficient
matrix has full column rank. Otherwise a nonzero null vector gives
signs satisfying every clause touching its support; the clauses
on its zero coordinates are a proper subsystem and can be satisfied
by minimality. If there are b ordinary clauses, k<=2 marked clauses
and n variables, full rank and ordinary incidence counting give

    n <= b+k,       3b <= 2n,       b <= 4,       n <= 6.

For b<=2 there are at most four clauses. Each excludes at most
one quarter of all sign assignments. With four clauses the two
ordinary exclusion events overlap: opposite monochromatic
directions on their vertices agree on shared variables. The union
therefore has probability less than one.

For b=4, n=6 and every variable has two ordinary ends. The ordinary
rows sum to zero, giving total rank at most 3+2<6.
For b=3, n=5. If every variable has two ordinary ends, the rank is
at most 2+2<5. Otherwise the ordinary degree sum is nine, with
one one-ended variable and four two-ended ones. The unique
multigraph has edges a=01,b=02,c=12,d=12,e=0*, with clauses

    NAE(a,b,e), NAE(-a,c,d), NAE(-b,-c,-d).

With e positive its eight valid assignments (a,b,c,d,e) are

    ---++, --+-+, -+--+, -+-++, -++-+, +--++, +-+-+, +-+++.

For each triple, the following counts are its violations for
relative signs --,-+,+-,++ on its last two literals, the first
literal positive:

| Triple | Counts |
|---|---|
| abc | 2,4,1,1 |
| abd | 2,4,1,1 |
| abe | 3,3,2,0 |
| acd | 0,3,3,2 |
| ace | 2,1,3,2 |
| ade | 2,1,3,2 |
| bcd | 2,3,3,0 |
| bce | 3,2,2,1 |
| bde | 3,2,2,1 |
| cde | 3,3,1,1 |

Only NAE(a,-b,c) and NAE(a,-b,d) exclude four assignments.
Their excluded index sets in the displayed order are {2,3,6,7}
and {2,4,5,7}, not complements. Two clauses therefore exclude
at most seven of the eight assignments. This final contradiction
proves the lemma. The table is a finite identity inside the proof,
not extrapolation from a bounded graph search. QED.

Three arbitrary marks do not satisfy the analogous theorem:
blocks {a,b,c} and {a,a'},{b,b'},{c,c'}, with marks
{a,b',c'}, {a,b',c}, {a,b,c'}, give the four incompatible
relative not-all-equal constraints on three variables. The star
proof below uses its actual cut geometry instead.

## 6. The one-defect base, including all capacities and all q

Write the missing pair as (s,t), L=Anc(t), R=Desc(s).
In a strict form the ideal

    U* = L union Anc(N minus (L union R))

minimizes every selected-unit exceptional count simultaneously.
No free active tail can precede a free active head, by the contact
restriction. Including all free negative-divergence heads and no
free positive-divergence tails therefore minimizes divergence.
Its positive boundary B has tails in L and heads in R. Every
exceptional positive boundary contains B. Moreover |B|>=q+1.

Adding the missing arrow with capacity zero and applying [S]
partitions the units into q ordinary colors. An ordinary color
is a dijoin exactly when it meets B.

We need a direct-anchor observation. If an ordinary color F misses
B, it has a direct selected s->sink unit alpha and a direct
source->t unit beta. Indeed, D+reverse(F)+(s->t) is strongly
connected. A simple path from t to an original source other than
s cannot use the added arrow. If its first source were entered
by reversing X->n with n internal, the last preceding reversal
would enter an active p followed by a contact p->n with X!=s,
contrary to the contact restriction. Without a preceding reversal
the path could not leave t. Hence a direct unit into t exists;
reverse the argument to obtain alpha.

First prove binary packing. By Proposition 8 restricted to
defect at most one, a minimal failure is contact-free. In an
ordinary completion partition with a bad color, B is monochromatic
in the other color. Every terminal-pair component contains at most
one B unit, since actual ideal crossings alternate color.

Call s internal if it has an internal positive unit, and similarly
t. If s is internal, its only other unit is its real direct alpha.
Every B unit that is direct or source-internal must be in alpha's
terminal-pair component. Otherwise virtualize just that unit when
necessary, color it like alpha using Section 5.2, extend, and
expand through alpha. That color meets B, while the other uses
the internal unit at s and cannot be bad by the anchor observation.
Thus internal s implies |B_direct|+|B_source|<=1.
Dually internal t implies |B_direct|+|B_sink|<=1.

If both are internal these inequalities give |B|<=2, contradicting
|B|>=3. If only s is internal, at least two B units are sink-internal.
Virtualize those two, give them opposite colors using the one-sided
label rule, and expand through the all-direct t, which has a real
root of each color. The dual case is identical. If neither is
internal, virtualize all internal B units, color two B labels from
different binary components oppositely, and expand through the
real roots at s,t. Both colors meet B in each case.
This proves ambient binary one-defect packing.

For q>=3 use the strict fixed-q form and its q ordinary completion
colors. A bad color misses B, whereas |B|>=q+1 supplies another
color with at least two B units. Their *actual reserved vector*
has minimum at least two on ordinary cuts by addition, and on
exceptional cuts by canonical dominance. Apply the just-proved
ambient binary theorem on the unchanged full topology. Each
original q-tight terminal has exactly two reserved units, so the
two new colors exhaust them, one each. Every reserved unit touches
such a terminal and is exhausted once. Replace the pair.

The number of bad colors strictly decreases; after at most q
replacements it is zero. Lemmas 3--5 reconstruct the original
capacities. For q=1 use the positive support. We have proved the
one-defect all-q theorem, not assumed it as a manuscript lemma.

## 7. Contact-free binary common-source stars

Suppose the missing pairs are (s,t1),(s,t2). Put S0=S\\{s} and
T0=T\\{t1,t2}; both are nonempty. Partition active tails into P1,
P2,P12 by reaching just t1, just t2, or both. Define disjoint unit
bundles

    Z  = {X->n : X in S0, n in Desc(s)}
           union {X->Y : X in S0, Y in T0};
    G  = Z union {p->Y : p in P12, Y in T0};
    Li = {p->Y : p in Pi, Y in T0};
    Mi = {X->ti : X in S0} union {p->ti : p in P12}.               (12)

The ordinary boundary C0 and the three canonical exceptional
boundaries are

    C0  = G union M1 union M2,
    C1  = G union L1 union M2,
    C2  = G union L2 union M1,
    C12 = G union L1 union L2.                                   (13)

Here and in this section subscripts on Mi are indices, not matroid
notation. To verify (13), put K=S0 union Anc(N minus Desc(s)).
No active tail is in K, by the contact restriction. The ideals
K union Anc(B), empty!=B subset {t1,t2}, attain the three
exceptional minima by (8), and their boundaries are the last
three sets in (13). The ideal K union (Anc(t1) intersection Anc(t2))
gives C0. This proof works also before contacts are erased.
All three exceptional boundaries have capacity at least three.
For an ordinary color, meeting all four sets is equivalent to

    meeting G, or meeting L1 and M1, or meeting L2 and M2.         (14)

Put E_i={p->Y : p reaches ti, Y in T0}. In contact-free forms
(13) is equivalently

    C0=Z union (E1 intersection E2) union M1 union M2,
    C1=Z union E1 union M2,   C2=Z union E2 union M1,
    C12=Z union E1 union E2.                                  (15)

### 7.1 Anchors and safe source preparation

For any ordinary F, add the two missing zero arrows to
D+reverse(F), obtaining a strongly connected digraph. If F misses
a singleton exceptional pattern i, the first-source path argument
from ti inside that missed ideal gives a direct selected source->ti
unit. If it misses the joint pattern it gives such a unit into at
least one of t1,t2. On the complementary shore a simple path to s
gives a direct selected s->sink unit, unless it contains an active
contact. In a contact-free form every bad ordinary color therefore
has a direct unit at s.

For detail on the latter alternative, if the last reversal into s
is s->n internal, the preceding reversal enters p from a selected
sink outside the missed ideal. Its forward segment reaches n.
The contact restriction forces that sink to be an excluded
exceptional sink. There is none for the joint pattern; for a
singleton it must be the other ti. Either way a contact is required.

If s has no direct unit, ordinary completion colors already pack.
If |Z|>=2 and s is all-direct, virtualize two chosen internal Z
units if necessary. The actual joint ideal and binary-chain parity
allow two of these Z labels to be colored oppositely: two crossings
in one component already have opposite parity, and otherwise
choose labels in different components. Expand through s's real
roots. Both colors meet G.

If |Z|>=2 and s is internal, a bad ordinary completion color
contains its unique direct alpha. A missed exceptional boundary
contains Z and is monochromatic in the other color. At least one
e in Z is outside alpha's terminal-pair component. Virtualize just
e if necessary, set e=alpha, extend and expand through alpha.
That color meets G; the other has no direct at s and is full.

We may henceforth assume a direct at s and |Z|<=1. If s is internal
and Z is an internal source unit e, no direct regular-source to
regular-sink unit exists. Alpha's possible terminal-pair neighbors
then end at internal vertices, so e is outside its component.
The same single-witness argument finishes this case.
In all remaining cases s is all-direct, or Z has no internal source
unit. Virtualize the possible internal Z through the all-direct s.
No remaining regular-source dependency enters s.

A special sink with an internal positive unit is two-tight.
If it has a direct unit, write its two units as beta_i and
k_i=p_i->ti. An all-direct special sink is **protected**: it has
real direct roots of both colors. These definitions allow
non-tight all-direct sinks.

We use a single-sink guard repeatedly. Suppose t is internal with
real direct beta and another nonvirtual incoming unit. Virtualize
a sink-only witness e at a regular sink, suppress beta's sink
occurrence, and identify e=beta. A closed block containing t is
non-singleton and originally has at least three labels, so after
suppression it still has two. The class has at most one source
and one sink placement. Color by (11), restore the occurrence,
extend once, and expand e through the real same-colored beta.
A previously safe virtual anchor at t can replace beta, provided
the other original incoming unit stays nonvirtual.

### 7.2 Both special sinks have an internal unit and a direct anchor

If neither p_i reaches the other special sink, M_i={beta_i}.
Strict C1,C2,C12 imply that E1,E2 are nonempty and admit distinct
witnesses e_i. We can choose them so that suppressing both beta_i
sink occurrences leaves two labels in every block.

Here is the simultaneous-choice justification. Only a common
three-label closed block Q containing t1,t2 could fail. Among
failing choices minimize its number of sinks. Both witnesses
cannot be placed in Q, since beta1,beta2 would then make at least
four labels. Strong connectivity of Q supplies a nonvirtual
regular-sink E_i dependency into each ti, since p_j does not reach
ti. If just one chosen witness is in Q, replace the outside one
by such an inside witness. Q stays closed and now has four labels;
any new bad block containing both ti is a proper subcomponent.
If both witnesses are outside, do this for both when distinct
inside witnesses exist. Otherwise both inside witness sets are
the singleton {f}. Replace e1 by f and retain outside e2.
There is then no internal dependency into either ti from Q.
Neither ti is singleton closed, because its nonvirtual k_i has
another endpoint. Thus no bad subcomponent contains both.
All alternatives contradict the chosen minimality.

Use the two guards e_i=beta_i in one coloring and expand them.
If beta1,beta2 differ, each color has E_i and M_i for one i and
is full by (14). If they agree, their color is full; the other
uses both internal k_i and has no direct into either special
sink. The anchor observation excludes every possible failure.

If exactly one tail reaches the other sink, say p1 reaches t2,
virtualize k1 and all E1. Guard k1=beta2 while k2 remains
nonvirtual. The singleton block {beta1,k1} forces beta1,beta2
opposite. In the reduced root graph put S0 source blocks and
the t1 block inside. With private endpoints on their actual
canonical sides, its complete outgoing set is Z union E1 and
there is no incoming label. Its size is at least two by strict
C1=(Z union E1) union {beta2}. Split it using Section 5.2.
Expand k1 first through real beta2. Both colors now have real
paths at t1; expand E1 through those paths. M1 has both colors,
so both colors are full.

If both tails reach the other sink, virtualize k1,k2 and E1 union
E2, identifying k1=beta2 and k2=beta1. The two special singleton
blocks become the same binary block; retain it once. Put S0
blocks and that binary sink block inside a root cut. Its complete
outgoing set is C12, of size at least three, with no incoming
label. Split it. Expand k1 through real beta2 and k2 through real
beta1, then expand the remaining joint units. Both M_i have both
colors and both colors meet C12.

### 7.3 At least one special sink is all-direct

If both are all-direct, virtualize all internal E1 union E2.
The root cut containing S0 and both special sink blocks has
outgoing set C12 and no incoming label. Split it and expand through
the protected sinks. Both M_i are bichromatic.

Otherwise t2 is all-direct and t1 internal. If |E2|>=2, virtualize
two E2 units, give them opposite colors by the one-sided rule,
and expand through protected t2. Both colors have E2 and M2.
Assume |E2|<=1.

If every internal incoming tail at t1 reaches t2, virtualize those
incoming units and all internal E1 union E2. The two labels at t1
form its singleton binary block. The joint root cut still has
complete outgoing set C12 and no incoming label. Split it, expand
t1's incoming virtual units through t2 first, and then the joint
units through t1 or t2. All incoming units of t1 belong to M1
and have both colors.

If t1 has direct beta1 and k1's tail does not reach t2, then
M1={beta1}. Strict C2 and the bounds on Z,E2 force |Z|=|E2|=1.
Strict C12 supplies e in E1 minus E2. Guard e=beta1 and virtualize
the E2 unit. The root cut containing S0 and t2 has complete
outgoing set consisting of Z, the E2 label and the guard class,
with no incoming label. Split it. Beta1's color is full via e;
the other contains Z, or E2 together with a real M2 root.

If t1 has no direct unit and not both its tails reach t2, strict
C2 gives |Z|+|E2|+|M1|>=3. Each term is at most one, so all are
one. Write gamma for the one M1 unit and eta for the other
incoming unit. Choose e in E1 minus E2 by strict C12.
Virtualize gamma,e, suppress gamma's occurrence at t1 and set
e=gamma. Eta remains nonvirtual, so suppression leaves sufficient
blocks. The class is sink-only; color it opposite to the
sink-only E2 label. Expand gamma through t2, then e through
gamma's already constructed path. One color has L1,M1 and the
other E2,M2.

### 7.4 A special sink without a direct unit, the other internal

Both cannot lack direct units: K from (13) has boundary

    Z union D1 union D2,

where D_i is the direct incoming set of ti, which would have size
at most one. Suppose t1 has no direct and t2 has beta2,k2.
The same boundary forces |Z|=1 and is two-tight. Since K excludes
s and contains no sink, strictness makes K a singleton source r.
Thus S0={r}, its two units are beta2,Z, and they have opposite
colors in the prepared root system.

If E2 is nonempty guard e=beta2 for some e in E2. That color is
full via E2,M2 and the other via Z.
If E2 is empty, strict C2 forces both incoming units of t1 into
M1; their tails reach t2. Strict C12 gives |E1|>=2.
Guard some e in E1 to beta2. After ordinary extension beta2's
color has an actual incoming unit gamma at the saturated t1.
Redirect gamma's auxiliary endpoint to t2, where the real beta2
has that same color. This first constructs an actual path from
t1 to a real root, independently of e. Expand e through that
path. Its color has L1,M1 and the other has Z.

The sink cases are exhaustive. Each construction restores omitted
root occurrences before extension and expands virtual units only
through real roots or previously constructed same-colored paths.
Equation (15) then covers all three exceptional families
simultaneously. Lemma 9 covers all ordinary cuts. Saturation
partitions every original unit once. This proves contact-free
binary star packing; reversal gives the common-sink case.

## 8. Contact-free binary matching defects

Let the missing pairs be (s1,t1),(s2,t2).
The same first-source argument as in Section 6 gives:

    an ordinary color missing family i has a direct selected unit
    at both si and ti.                                          (16)

One can check confinement of the path as follows. In the missed
ideal only ti is a sink and only si is an excluded source.
A simple path from ti to an included source cannot leave and
return through the added si->ti arrow, which would repeat ti.
A last contact before its first source would have output to ti
and input from a source different from si, forbidden by Lemma 5.
Reverse this argument for si.
This proof of (16) uses only the contact restriction, not
contact-freeness or q=2. We also use that general formulation
in Section 9.2.

If one endpoint of pair i has no positive direct unit, family i
is automatic for every ordinary color. Add only its missing
zero arrow and use the binary one-defect theorem of Section 6.
This packs the full input. Hence assume every special endpoint
is direct-enabled. An internal endpoint has just one internal
unit h and one real direct anchor A.

With no contacts, (8) has canonical positive boundaries B_i,
contained in every boundary of family i, of size at least three.
Their internal parts are exactly

    B_i,S = {X->n : X!=si, si reaches n},
    B_i,T = {p->Y : Y!=ti, p reaches ti}.                        (17)

Their direct part consists of the existing positive X->Y units
with X!=si,Y!=ti. These assertions follow by including all free
heads and no free tails in (8).

### 8.1 A guard and one native marked cut

Virtualize all internal B_i units. No possible source dependency
enters si from another source, and no possible sink dependency
enters ti from another sink. Each is therefore a singleton
minimal closed block or lies in no minimal closed block.
Put all source blocks except {si} inside a root cut and only
the sink block {ti} inside; put private endpoints on their
original canonical sides. This is coherent on every block.
Its outgoing labels are precisely B_i, with no incoming label.

For the other pair j choose an internal endpoint v_j, a
same-side internal witness e in B_j and its real anchor A_j.
Keep v_j's own internal unit nonvirtual. Suppress A_j's
occurrence on that side and identify e=A_j. Its closed block,
if any, had at least three labels, so (11) remains feasible.

In the preceding native root cut the identification loses at
most one outgoing B_i label. If it creates an incoming label,
it loses none. Thus the image of B_i has either at least two
outgoing labels and no incoming label, or at least three
outgoing labels and at most one incoming label.
It can be made bichromatic: otherwise all its labels would be
forced equal on one binary component. The possible incoming
edge cancels at most one of the common-direction outgoing
crossings, leaving net change at least two on a path or cycle.
This is impossible by Section 5.2.

Restore the suppressed occurrence and extend once. If all the
virtual units have the safe expansions specified below, B_i
has both colors; A_j's color meets B_j through e, and the other
uses v_j's internal unit and cannot fail by (16).
This is the guard-and-mark construction, not a combination of
independently chosen colorings.

### 8.2 Safe protection and two guards

Initially protect every all-direct special endpoint. Repeatedly
protect an internal endpoint if its own internal unit belongs
to the opposite core on that side and that opposite endpoint
is already protected. Record this order. Let W be the internal
core units that can expand through some protected endpoint.
An unprotected endpoint's own unit is not in W.

Virtualize W. Each protected internal endpoint now has the
singleton block consisting of its real anchor and its own
virtual unit, so has both colors. Expand those own units in
the recorded order, then the remaining W units. Every
protected endpoint now has actual paths to real roots in both
colors. This schedule has no circular dependency.

Let U_i be the set of sides on which pair i's endpoint is
unprotected and B_i has an internal unit. If U_i is empty,
all internal B_i units lie in W.

For two guards choose one side in each U_i, with endpoint v_i,
anchor A_i and witness e_i. Keep the own internal units at v_i
nonvirtual, suppress the two chosen anchor occurrences and
identify e_i=A_i. If all blocks retain two labels, this is one
bipartite system of type (11). Opposite-side choices always
retain two labels: each affected block loses at most one from
at least three. A shared cross-arc anchor has both occurrences
suppressed and takes one placement from each witness; it still
has at most one placement in each family. Expand W first,
then each witness through its assigned-color real anchor.
Both families are full by (16).

For same-side choices with distinct regular witnesses, provided
neither special endpoint's own unit belongs to the opposite
core, the required block sizes can be secured. Only a common three-label
block Q containing both selected endpoints could fail.
Choose witnesses minimizing such a bad Q. Strong connectivity
supplies a nonvirtual incoming regular witness for each endpoint
inside Q: the excluded opposite-special units cannot supply that
dependency. Replace outside
witnesses by distinct inside ones; Q remains closed and acquires
four labels, so any new bad component is smaller. If the two
inside witness sets are the same singleton, virtualize that
unit and keep the other chosen witness outside. No dependency
inside Q then enters either special endpoint, and neither is
singleton closed because its own nonvirtual unit has another
endpoint. No bad subcomponent remains. This proves sufficient
distinct witness choices exist.

### 8.3 Exhaustion of the matching cases

If both U_i are empty, virtualize W and apply Lemma 10 to the two
actual cores B_i. The parity condition holds: a native boundary
of size at least three either has an opposite pair on a binary
chain, or has at most one crossing per component and meets at
least three components. Expand W.

If just U_i is empty, mark B_i and use Section 8.1 to guard the
other family, virtualizing W and its chosen witness. Expand W
before any remaining witness.

If both are nonempty and allow opposite sides, use the two
guards of Section 8.2. Otherwise they are the same single side;
reverse arrows if necessary so it is the source side. Both
s1,s2 are internal and unprotected, with own units h1,h2.
W has no source unit and contains all internal sink core units.

If h1 in B2 and h2 in B1, virtualize h1,h2 and set h2=A1,
h1=A2. Their original singleton blocks become the same
binary block {A1,A2}. Color that single bipartite system and
expand each unit through the other real anchor. Equation (16)
and the witnesses cover both families.

If just h_i in B_j, guard family j using h_i=A_j and mark B_i.
Virtualize W,h_i and all internal B_i units; h_j stays
nonvirtual. Section 8.1 applies. Expand W, then h_i through
A_j. At s_i the real A_i has the opposite color, so s_i now
has actual paths in both colors. Expand the remaining source
B_i units through these paths.

If neither own unit lies in the opposite core, both nonempty
B_i,S sets consist of regular witnesses. If distinct choices
exist, the sufficient witness-choice argument in Section 8.2
gives two guards. If they do not, B1,S=B2,S={e} for one
regular unit. Guard e=A1 and mark B2 using Section 8.1;
W,e already include all its internal units. Expand W, then e
through real A1.

These alternatives are exhaustive. All suppressed occurrences
are restored before Lemma 9, all expansions are same-colored
and ordered, and both actual cores or (16) cover the exceptional
families. Tight-terminal saturation partitions every original
unit. This proves contact-free binary matching packing.

Proposition 8, Section 6, Section 7 and this section now prove
ambient binary packing for the entire class def(D)<=2.

## 9. From binary packing to every q

The remaining induction never supposes that a reserved vector
remains strict. Its full original topology is retained.

### 9.1 Common-source palettes

Use the bundles (12)--(13), now at arbitrary q. Add only s->t1
with capacity zero and apply the one-defect all-q theorem.
Obtain q ordinary colors covering family 2. Every q-tight
terminal is saturated, so every positive unit is assigned once.
For color a put

    d_a = |F_a intersection (G union L1)|,
    l_a = |F_a intersection L2|,   m_a=|F_a intersection M2|,
    w_a=d_a+l_a,                    z_a=d_a+m_a.

These are its actual C12,C1 counts. Full strict slack gives
sum w_a >= q+1 and sum z_a >= q+1. For a palette X the two
needed family minima are bounded exactly by

    min(w(X),z(X)) = d(X)+min(l(X),m(X)).                        (18)

If some bad F has just one of w_F,z_F zero, say w_F=0,z_F>=1,
choose G with w_G>=2. Unless z_F=1,z_G=0 this pair has both
sums at least two. In the exception choose H with z_H>=2;
the pair G,H works and G is bad. Thus there is an actual
minimum-two pair containing a bad color.

Otherwise, if there is no such pair, every bad F is double-zero.
For every a,

    d_a+min(l_a,m_a)<=1.                                        (19)

The bad color meets the terminal cut at t2 without an M2 unit,
so uses an internal P2->t2 unit. Consequently t2 is q-tight
and m_a<=1 for every old color. Pair as many distinguished
L2 units with M2 units as possible, directing each pair from
its L2 color to its M2 color. The color graph has indegree at
most one and the double-zero F is isolated. Mark vertices
with d_a=1. For every induced palette X,

    min(w(X),z(X)) >= number of marks in X + |E(X)|,             (20)

with equality on the full palette. The full value is at least
q+1. Components are outward trees or cycles with outward
trees. A tree's excess (marks+edges-vertices) is marks-1;
a unicyclic component's is marks. F contributes -1, so another
component has positive excess.

In a tree choose the inclusive path I between a closest pair
of marks. Set X=I union {F}. It has two marks and |I|-1 edges,
giving (20)>=|X|. If X were full, the full score would be q,
contradicting q+1. In a unicyclic component choose a marked
vertex and its path from the cycle. No cycle or interior path
vertex is marked, by (19). Let I be that cycle and path and
again add F. There is one mark and |I| edges, with the same
properness argument. In either case

    3 <= r=|X| < q,

and the *actual* reserved capacities have minimum at least r
on every original dicut: (20) handles families 1 and 12, and
adding the old counts handles ordinary cuts and family 2.

Use strong induction on q in the ambient common-source class,
whose quotient closure is Lemma 3. For q=1 use positive support;
for q=2 use the binary theorem. A strict q-failure has the
preceding completion partition. Repack an actual minimum-two
pair by the binary theorem, or the proper minimum-r palette
by the smaller-parameter induction hypothesis. Give each arc
exactly its reserved occurrence count as capacity and keep
all other topology arcs with capacity zero.

Each original q-tight terminal has r reserved units and each
new member meets its terminal cut. Saturation therefore assigns
every reserved unit exactly once. Outside colors stay unchanged.
The number of bad colors strictly decreases, so finitely many
replacements pack the strict form. Reconstruction in Section 2
contradicts the assumed failure. Reversal proves the common-sink
all-q result.

### 9.2 Matching palettes and contact cycles

For matching defects fix exceptional family i. Put L_i,R_i as
in (6), W_i=L_i union N_f,i, and let C_i be the units leaving
W_i. No positive unit enters W_i: an excluded-source input
has its head in Desc(si); an included-sink output has its
tail in Anc(ti); a direct exception would be the absent
si->ti. Thus the baseline in (8) is the nonnegative count
x(C_i), even though W_i need not be an ideal.

All free contacts of pattern i have the opposite type j.
Expanding cover weights into distinguished unit vertices and
using bipartite matching--cover equality gives

    m_i(x) = x(C_i) + nu_i(x),                                  (21)

where nu_i is the maximum free unit-contact matching size.
For reference, the equality follows from a maximum matching:
alternating vertices reachable from unmatched left vertices
give a vertex cover of that size. No colorwise additivity is
being asserted.

Obtain an ordinary q-partition covering family j by adding only
the missing arrow of family i and using Section 6. Let F be bad
on i. An actual donor G means m_i(F+G)>=2; ordinary and
family-j minima of that union are already at least two.
If no donor exists, each d_a=|F_a intersection C_i| is zero or
one. Full strict slack gives

    sum_a d_a + nu_i(full) >= q+1.                              (22)

If free contacts exist, sj,tj are q-tight. Each color has at
most one input and output unit of this type. A maximum
contact matching, directed from output color to input color,
therefore has indegree and outdegree at most one. Its components
are paths, cycles and isolated vertices. If no cycle contains
a count-one vertex and no path contains two, component counting
gives |M| <= number of zero-core colors, contradicting (22).
If there are no free contacts, (22) already contradicts d_a<=1.

We justify the cycle alternative on original units. Replace a
selected output p0->t in a color containing s->n by an available
p->t with p reaching n. Ordinary coverage is preserved.
Otherwise a lost ordinary ideal U contains p0, excludes p,t,
and also excludes n,s. Hence it has no sink. In the completion
D+reverse(F)+all missing arrows its only entering arrow is
t->p0. A simple path from p0 to an original source inside U
cannot leave and return, since it would repeat p0. Its first
reversal would follow a contact p0->m with active input
source s, but s is outside U, impossible. A path with no
reversal cannot reach an original source from p0.

The new color contains the same-color original contact pair.
For a different matching exceptional family, s is inside and
t outside, and

    h_(s,n)+h_(p,t)=1+h_(p,n)>=1.

For its own family (16) forbids failure because the selected
unit at the saturated s is internal. Thus the new color is
a full original dijoin. Aligning the output units around a
directed color cycle does these replacements simultaneously
as one permutation. If F is on it, F is repaired. Otherwise
a count-one cycle color becomes a full color of family-i
minimum at least two, hence an actual donor for unchanged F.
Its core count is unchanged because free-contact output units
are outside C_i.

It remains to handle a path Q with two count-one vertices.
For any palette X, restricting the fixed unit matching gives

    m_i(c_X) >= sum_(a in X) d_a + |M[X]|.                      (23)

If F belongs to Q, take the interval from F to a nearest
count-one vertex. Its score is its number r of vertices and
another count-one vertex remains outside. If F is not in Q,
take the interval I between consecutive count-one vertices
and add F. Its score is |I|+1=|X|. Were X full, F would be
an isolated non-loop vertex, the full core sum two and the
full matching size q-2, contradicting (22). Thus in either case

    2 <= r=|X| < q.

The reserved vector has minimum at least r on family i by
(23), and on all other cuts by adding the old color counts.

Strong induction on q now applies within the quotient-closed
matching class. Repack a donor pair by ambient binary packing;
perform a cycle alignment when available; or repack the proper
actual palette by the smaller-parameter theorem. Saturation
exhausts the reserved units exactly as in Section 9.1.
Each step strictly reduces the bad-color count with no new
bad color. Reconstruct the strict form by Section 2.
This proves the all-q matching theorem.

### 9.3 Conclusion and termination

Zero missing pairs are covered by [S], one by Section 6, and
the three configurations of two by Sections 9.1--9.2.
This proves Theorem 1.

All recursive calls are well founded. Normal-form reductions
decrease vertices or total capacity; binary topology erasure
decreases reachability as a third tie-breaker; reserved-palette
calls decrease q; and repeated color repair decreases an
integer bad-color count. None calls the same theorem on a
full palette at the same parameter. All gluing and expansion
steps preserve original capacities. This is an exact
constructive existence proof, not a claimed polynomial-time
algorithm or a finite-exhaustion proof.

## 10. Comparison with stronger prior machinery

### 10.1 What ACZ actually requires

All references here are to **arXiv:2202.00392v5**, not the
different theorem numbering of earlier versions.
In Sections 5--6, the standing input is a sink-regular weighted
(q,q+1)-bipartite digraph with 0/1 capacities and minimum
dicut weight at least q. All its vertices are sources or
sinks; sinks have degree q and sources degree q or q+1.
Let E be the active sources of degree q+1 and put

    r = rho(q,D,w) = |T|-|S|,       |E|=qr,
    rho(q,D,w) = (1/q) sum_v
                   ((w(delta+(v))-w(delta-(v))) mod q),          (24)

using residues 0,...,q-1 [ACZ, Definition 1.2, Definition 1.5,
Lemma 3.7].

Their M0 is the rank-r matroid of dyad-center sets realizable
by rounded 1-factors in the positive support [Definitions 5.4,
5.6; Lemma 5.7]. It is strongly base orderable [Theorem 5.5].
Their full-topology cut matroid M1 has bases Q subset E with

    |Q|=r,  |Q intersection U| >= 1+|T intersection U|-|S intersection U|
                     for every dicut shore U.                  (25)

Theorem 4.8 partitions E into q M1 bases.
An admissible set is a common M0,M1 basis [Definition 5.8].
A k-admissible set is a union of k bases in each matroid;
the two decompositions need not coincide [Definition 6.1,
Lemma 6.2].

Theorem 5.14 packs q dijoins if M1 is strongly base orderable.
Theorem 6.5 instead assumes E=Q disjoint-union Q', with Q
admissible, Q' (q-1)-admissible, and M1 restricted to Q'
strongly base orderable. Theorem 6.4 realizes the split by
capacities on the same full topology. Neither theorem is a
rho<=2 statement. Theorem 5.18 is the rank-at-most-two
specialization, not the strongest criterion.

### 10.2 Already-normalized two-defect inputs are covered

**Proposition 11.** On an ACZ sink-regular normalized input
with at most two missing terminal pairs, M1 is uniform.
Consequently both Theorem 5.14 and the sufficient hypothesis
of Theorem 6.5 apply, regardless of rho.

**Proof.** Write p=|S| and U=X union Y, X subset S,Y subset T.
When Y is empty, the lower bound in (25) is nonpositive.
When X=S it follows from |Q|=r and U proper.
Otherwise a=|S minus X| and b=|Y| are positive, and
ideality makes their a*b pairs missing. Hence ab<=2 and
a+b<=3. The lower bound in (25) is

    1+a+b-p <= 4-p.

If r>=2, p>=|E|=qr>=4, so it too is nonpositive.
Thus every r-subset is a basis. For r=0 the assertion is
trivial; for r=1 Theorem 4.8 makes M1 loopless and hence
uniform. A uniform matroid is strongly base orderable:
any exchange bijection works for all subsets.

A partition into M0 bases exists by Theorem 5.5. Every such
basis is now an M1 basis. Take one as Q and the rest as Q';
the restriction of a uniform M1 is uniform. This supplies
the split in Theorem 6.5. QED.

Thus a comparison based only on native examples with rho>2
would miss a genuine prior implication. Proposition 11 is a
translation lemma, not a claim that the normalized subclass
escapes ACZ.

### 10.3 Literal lifting: a stronger obstruction, not a positive bridge

ACZ Theorem 2.2 decomposes arbitrary integral-capacity inputs
into sink-regular binary normalized inputs, with dijoin-clutter
contraction and product operations that transfer packings
[Definition 2.1; Remarks 2.4,2.6; Theorem 2.7].
The irreducible-piece decomposition is Appendix A, Lemma A.3
and Theorem A.5; its pieces are vertex-identification
quotients. Lemma 3 therefore preserves the defect bound at
this decomposition step.

The subsequent lifting [Lemma A.7; Theorem A.10] does not
preserve that bound automatically. Its permitted rectangle
gadgets can have arbitrarily many sinks while a designated
source a0 has only the two sink neighbors b0,b0'. In the
bipartite output every other sink is unreachable from a0.
Here is an explicit symbolic instance of that construction.
Start with two vertices u,v and q+1 parallel unit arcs u->v,
an irreducible zero-defect input. The sink-regular least-residue
choice in Appendix A.4, Stage 2(ii), has

    ell+(u)=1, ell+(v)=q-1, ell-=0.

At u the rectangle parameter is k'=q^2-1. For any positive
integer N choose

    k=q^2-1+Nq,
    n-list: N entries, all q,
    m-list: q+N entries, one q-1 and all the others q.

These are the permitted parameters of Lemma A.7(i)--(iii).
The rectangle retains 2k+2 sinks. Its Step 1 gives a0 only
the neighbors b0,b0'; Steps 2--4 do not attach to a0.
The port map sends outgoing ports to newly introduced s_i
and incoming ports to b_f(i), so Theorem A.10's attachment
of original arcs adds no neighbor to a0. The final graph
is bipartite, and a0 therefore misses at least 2k sinks.
Parallel unit expansion changes no endpoints. Thus even
this fixed zero-defect input has permitted lifts of
arbitrarily large defect. This proves failure of defect
preservation, *not* failure of strong base orderability
for those lifts.

There is a stronger obstruction to a universal *literal*
sink-regular bridge. The previously independently supported
19-vertex family D_h has one missing pair, q=4h for h>=3,
minimum dicut q and a 2-vertex-connected positive underlying
graph. Its six internal e_ij vertices have residue 2h, while
every other vertex has residue zero. Every minimum-residue
literal lift has cut matroid the 2h-fold parallel extension
of M(K4), and removing any basis leaves a non-base-orderable
restriction. This is an all-lifts statement, not a bad
port-order example.

The arbitrary-rho extension is proved in
[`acz_lifting.md`](acz_lifting.md), Theorem A.

**Proposition 12 (arbitrary-residue literal obstruction).**
For every h>=3 there are irreducible inputs D_h^(d), of
defect exactly d for each d=0,1,2 and minimum dicut q=4h,
such that every literal sink-regular normalized ACZ lift
H has M1(H) not base orderable. If Q is a basis and E-Q
partitions into q-1 M1 bases, M1|(E-Q) is also not base
orderable. There is no upper bound on rho(H). Thus neither
Theorem 5.14 nor the sufficient hypothesis of Theorem 6.5
can hold on any such lift.

Here literal means the actual Appendix A vertex-block
construction retaining original arc labels and weights,
followed by parallel unit expansion. The exact-two variant
deletes one specified zero arc of D_h; the zero-defect
variant adds one. Positive topology and capacities are
unchanged. All their original dicuts have value at least q.

**Proof outline.** Let G_v be an original vertex block,
c(v) its active-source count and b(v)=floor(d_w(v)/q).
Without any residue-minimality assumption,

    c(v)=(d_w(v) mod q)+q m(v),
    disc(G_v)=m(v)-b(v),                 m(v)>=0.

Whole-block original ideals impose
|B intersect E_U|>=1+m(U)-b(U). Seven original q-tight
shores are saturated by every basis in ACZ's known q-base
partition. Take the minimum-weight face defined by zero
total slack on these shores; they need not be equalities
for every basis of the original matroid.

In that face, the active blocks over s,z,w and the four
sinks have fixed basis counts m(v). The six combined
e_ij,p_ij blocks have counts m_ij or m_ij+1, and the
three excess labels form a K4 tree, by sixteen further
original ideals. Contracting the mandatory rank m_ij
in each block gives a rank-three six-label minor.
The q-base partition forces half-density, which identifies
this minor as M(K4).

For a complementary basis partition, Q also belongs to
the tight-cut face. If epsilon_ij indicates its three
excess labels, the residual blocks have size
(q-1)m_ij+2h-epsilon_ij. Their q-1-base partition gives

    rank(A)> (|A|-1)/2,

because 4h+|A|-1-2epsilon(A)>=6 for nonempty A.
Integer ranks again give half-density and the same K4
minor in a face of the residual restriction. Base
orderability passes to minimum-weight faces and minors,
whereas M(K4) fails even singleton exchange. This proves
both assertions; gadget-local cuts cannot avoid the
argument while preserving the ACZ q-base partition. QED.

The inputs themselves have explicit original q-packings.
This proof does not use Theorem 1 to choose a lift or a
basis. Original-capacity projection remains valid: the
lifted boundary of a whole-block ideal consists exactly
of its original labelled units, so restriction to those
units preserves every original dicut and its occurrence
bound. Irreducibility prevents the actual pseudo-cut-vertex
decomposition from bypassing the obstruction.

Thus Proposition 12 rules out a class-wide positive bridge
through these two criteria and literal sink-regular
Appendix A lifts. Larger rectangles or more residues do
not evade this obstruction. Arbitrary nonliteral
clutter representations, balanced machinery and preliminary
packing-preserving reductions remain outside this
obstruction. In particular it is not independence from all
ACZ results: even the zero-defect inputs pack by a known
theorem. Sections 2--9 supply the direct packing argument;
priority and significance of that argument remain separate.

### 10.4 Other primary comparisons

Schrijver [S, Theorem 4, p.271] assumes that every source
reaches every sink in the acyclic topology. His Theorem 5
and Corollary 5a, p.274, allow a more general selectable
digraph but retain a source--sink-connected acyclic backbone.
Under the standard equivalence

    J is a dijoin of H  <=>  H union reverse(J) is strongly connected,

the original condensation is that backbone. One or two
missing pairs violate its hypothesis. Adding missing arrows
can delete original dicut constraints and requires the
extra reconstruction proved here. This is nonautomatic
applicability, not impossibility of every other backbone.

Williams [W, Theorem 3.1, p.25] gives the weighted
source--sink-connected theorem; Theorems 3.11--3.12,
pp.30--31, concern side joins and bi-side joins.
Cross cuts are not side cuts. For example, with sources
a,b, sinks x,y,z and arcs ay,az,bx,bz of capacity q,
the missing pairs are (a,x),(b,y). The cross ideal
{b,x} has boundary {bz}, while {bx,ay,az} is a side join
missing that boundary. Side-join packing alone does not
enforce our exceptional families.

His super-source/super-sink extension is Conjecture 3.13,
not a theorem. Two defects need not leave a super-source
when there are just two sources, as the same example shows.
When there are at least three sources and three sinks,
there is an unaffected row and column, so Theorem 1 proves
a restricted case of that conjectural weighted class.

Williams Proposition 7.6, printed p.87 (PDF p.94), excludes
four s-paths in a minimally non-knitted weighted digraph.
Definitions 4.1,4.17--4.18 and Propositions 4.23,5.2 impose
augmented-minor and weight minimality; the s-path framework
is the threshold-two specialization. A deduction of the
present all-q statement would require controlling the
defect under those operations, connecting it to path count,
and justifying all parameters. The general reduction of a
weighted failure to minimum two in [W, Section 2.7] is
conditional on the Cornuejols--Guenin--Margot conjecture.
No such conditional result is used here.

The all-capacity chordal theorem [CLR, Theorem 1.1] requires
chordality of the full underlying topology. The two-dijoin
theorem [ADN25, Theorem 2, p.4] instead assumes that the
positive support is weakly bridge-connected, meaning all
its bridges lie in one support component. The planar
application [ADN26, Theorem 1.4] assumes a planar full
digraph and a single connected positive-support component,
not necessarily spanning. None of these structural
hypotheses follows from a bound on terminal reachability
defect, and the last two are two-packing, not all-q,
statements. We make no assertion about every possible
reduction to their inputs.

### 10.5 Direct packing and conditional reductions

The direct contribution to assess is Theorem 1 and its
capacity-respecting proof, not Proposition 12 as a replacement
packing result. Two distinctions matter in comparing it with
other primary results.

First, a minimum bound on dicuts is not a bound on every
directed cut. In [ACF24, Theorem 18], the binary-capacity input
and integers q-1>=k>=1 must satisfy

    w(delta+(U))+(q/k-1)w(delta-(U)) >= q

for every nonempty proper U. The output is a decomposition
into a k-arc-connected flip and a (q-k)-dijoin, not q original
dijoins under a terminal-reachability hypothesis alone.
For example, after parallel unit expansion in Section 11.2,
U={p_i,n_i} has zero positive incoming and outgoing boundary.
It violates that all-cut inequality although the original
minimum dicut is q and the defect is exactly two. This
separates the displayed hypotheses, not every possible
preprocessing or use of the paper.

Likewise [IL26, Theorem 1.3] gives an integral *signed*
combination of dijoins representing the all-ones vector,
with coefficient sum q, for an unweighted input. Negative
coefficients do not encode a packing. Theorem 1.4 gives
nonnegative p-adic rational coefficients, not integer
multiplicities. Section 6.7 explicitly distinguishes the
capacitated setting. Neither conclusion can be substituted
for the original integral occurrence bounds of Theorem 1.

Second, obtaining weighted binary packing is not a general
license to assert all-q weighted packing. [ACZ, Section 8.5]
poses the general threshold-two, replication and capacity-split
statements as conjectures. [AS26, Theorem 2] proves a
conditional size-dependent implication: for integer n>=2,
validity of the threshold-two conjecture on all clutters with
fewer than (n-1)^2/4 elements implies replication on clutters
with at most n elements. It does not supply the unconditional
arbitrary-size implication needed here.

Section 9 instead proves the required implication inside the
two-defect geometry. A completion gives a prescribed ordinary
partition; an actual donor pair, simultaneous contact-cycle
alignment, or a *proper* palette X containing a bad color
has reserved minimum at least |X| on every original dicut.
In the last alternative |X|<q, not merely |X|<=q. Repacking
with the smaller parameter in the unchanged full topology,
and saturation at the original tight terminals, preserves
every reserved capacity and strictly decreases bad colors.
This identifies the precise structural reduction for a
priority comparison. It is not the conjectural unrestricted
clutter reduction or a claim that arbitrary old palettes work.

The primary reachability comparison is also dated explicitly.
[ACZ, Section 1.3] records the weighted super-source/super-sink
extension as conjectural and the zero-defect case as proved.
When each terminal set has at least three members, at most
two missing pairs leave an unaffected source row and sink
column, so Theorem 1 proves a subcase of that recorded
conjectural class. This observation establishes the relation
between the statements; it does not prove that the subcase
was unpublished.

The comparison with [GW05] now uses an obtained primary
author manuscript, rather than its abstract or the 2004
thesis. Its actual statements and their limits follow.

### 10.6 The obtained 2005 structural statements

The seven-page author copy of *Advances in Packing Directed
Joins* was retrieved from the archived author file
`AdvDijoins.pdf`, snapshot `20170922232511`. The local PDF
and text are `../literature/gw2005_primary_author_archive.pdf`
and `.txt`. This is an author version, not a newly obtained
publisher-typeset copy: its PDF creation date is September
24, 2008. The publication identity is the 2005 article
[GW05]; no priority date is inferred from PDF metadata.

There are three different structural statements to compare.

* **Source-sink and side-cut packing.** Theorems 1.2 and 1.4
  (PDF pp.2--3) give exact integral packing for source-sink
  connected digraphs and, on arbitrary digraphs, for covers
  of the family Y of side cuts. A side-cut shore contains
  all sources or contains no sink. These are known inputs,
  not contributions claimed here. Theorem 1 is about all
  original dicuts when one or two terminal pairs are
  missing. On the condensation used here, for a missing
  pair (s,t), the full ancestor shore Anc(t) contains sink
  t and omits source s.
  It is an original non-side dicut shore. Thus Theorem 1.4
  does not itself require its Y-covers to cover every
  original dicut in the present class. The super-source
  and super-sink assertion is Conjecture 1.5, not a proved
  extension in [GW05].

* **The precise binary trace criterion.** Section 2 assumes
  tau=2 and a unique partition of the positive arcs into
  k s-paths. An s-path is alternating, its arcs have weight
  one, and each internal vertex is a full-digraph source
  or sink with a weight-two terminal dicut. Crossing sets
  independently choose the forward or backward arcs on
  each path. The trace T is balanced when it contains at
  least one vector from every complementary binary pair.
  Lemmas 2.1--2.2 give Corollary 2.3 (PDF p.5):
  nu=1 if T is balanced, and nu=2 otherwise. This is a
  genuine proved criterion, not merely an abstract claim.
  Forced alternation and complementary-choice arguments
  are therefore prior art. The parameter k counts positive
  s-paths: it is neither the number q of packed colors nor
  the number of missing condensation source-sink pairs.

* **What the small-counterexample classification states.**
  Section 5 (PDF p.7) announces that, under a strengthened
  minimality notion, a tau=2 minimal counterexample has at
  least three maximal s-paths; the three-path cases are
  D1, (D2)+ and (D3)+; and no four-path minimal counterexample
  exists. The section expressly defers the strengthened
  minimality definition and structural derivations to a
  full paper. The obtained seven-page version does not
  give a defect-preserving minimality reduction, identify
  path count with terminal defect, or exclude every case
  with five or more s-paths. In particular, its use of
  "smallest" is not a classification by at most two missing
  terminal pairs. No unstated full-paper result is assumed.

The proper-reservation step in Section 9 has a different,
explicit postcondition. For an actual color palette X let

    c_X(a) = sum_(b in X) |F_b intersection units(a)|.

An actual donor, simultaneous contact-cycle alignment, or
proper palette gives a repair. In the palette case,
c_X(delta+(U))>=r=|X| on **every original dicut**, with
r<q. The induction repacks this particular integral vector
on the unchanged full topology. Arcs with no reserved unit
remain present with capacity zero. Tight-terminal saturation
exhausts the reserved units, so the outside colors and
original capacity bounds are preserved. Neither the binary
trace criterion nor the announced three/four-path
classification states this smaller-parameter reservation
or supplies an all-q implication on the two-defect class.

The zero-arc operations in [GW05] do not state that
postcondition either. Section 1 completes a selected closed
cut family Y, retaining that family rather than guaranteeing
coverage of every original cut. Section 3, Modifications
One and Two (PDF pp.5--6), deletes or adds specified zero
arcs, or inserts a zero-weight intermediate vertex between
sets with every R-to-S reachability already present.
These are topological counterexample constructions, not
repacking c_X on the same D with a strictly smaller r.

Consequently, the displayed [GW05] results are not
statements of Theorem 1 or of its proper-reservation
reduction. This is a comparison with an obtained primary
version, not a claim that different wording establishes
originality or that every deduction from earlier work has
been excluded. The candidate improvement is the universal
two-defect conclusion and its class-preserving all-q
argument, not the known side-cut theorem, trace criterion,
or zero-capacity constructions.

## 11. Sharpness, breadth, and the publication question

### 11.1 The actual known three-defect obstruction

Williams's actual Schrijver example D1, Figure 1.5, p.5,
has 0/1 capacities with thin arcs retained at capacity zero.
Section 3.4, p.32, states that each of its three sources
reaches two of its three sinks, and each sink is reached
from two sources. Its missing relation therefore consists
of exactly three pairs, a matching. This statement concerns
the example itself, not a maximal transitive or mask
completion.

Section 1.2.1, pp.6--7, gives minimum dicut value two and
the no-two-packing argument: the positive arcs form three
alternating paths, terminal two-cuts force the colors along
them, and each of the four partitions up to color exchange
has a cross cut missed by a color. These cited facts give
Corollary 2. We need no planar, chordal, or further graph
property of D1 and assert none.

This is sharpness of the *weighted* theorem. Deleting its
zero arcs or changing them to capacity one changes the
problem. D1 is not an all-unit counterexample produced here.

### 11.2 Unrestricted parameters are substantive

The theorem is not a bounded-terminal classification.
Both terminal sets and the arbitrary internal topology can
grow, and every integral capacity vector is quantified over.
For a particularly transparent exact-two-defect family,
take sources s,x, sinks t1,t2,u, base arcs

    s->u, x->t1, x->t2, x->u

of capacity q. For each of r internal pairs p_i,n_i add

    x->p_i, p_i->n_i, n_i->u,

with only p_i->n_i of capacity one and the other two zero.
All base terminal divergences are multiples of q.
The only missing pairs are (s,t1),(s,t2). Every nontrivial
ideal contains a source and excludes a sink; the positive
base graph connects all original terminals, so a base arc
crosses it. Thus the minimum is q, attained at {s}.
For q>=2, the internal divergences +1,-1 contribute q
per pair to the residue sum (24), giving

    rho(q,D,w)=r.

Hence neither q nor rho is bounded by the structural
hypothesis. This does not separate the class from ACZ's
stronger criteria, as Proposition 11 emphasizes.

This same family has an induced undirected four-cycle
x,p_i,n_i,u,x, so full chordality is not automatic.
For r>=2, replacing capacity-q base arcs by parallel unit
arcs leaves the internal unit edges as bridges in distinct
positive-support components, so weak bridge connectivity
is not automatic either. An arbitrary zero-capacity
internal digraph can also be attached between x and u,
with zero arcs from x to all its vertices and from them
to u. It changes neither the missing pairs nor the lower
bound. Taking an acyclic orientation of K5 inside gives
nonplanar full topology. These are analytical constructions
illustrating quantifiers and hypothesis distinctions, not
new finite certificates or difficult packing witnesses.

### 11.3 What is and is not qualified

The mathematical improvement over the zero-defect theorem
is an exact, unrestricted-capacity extension through the
largest universally valid defect threshold. Its candidate
field-level significance is the sharp structural min--max
theorem and a defect-respecting constructive proof, rather
than any bounded successful experiment. The essential
structural steps are Lemmas 6--7, native simultaneous
guards in Sections 7--8, and the proper actual reservations
in Section 9. Generic normalization, Schrijver's theorem,
the matroid arborescence theorem, and the known D1
obstruction are not claimed as new.

The primary comparisons above identify exact existing
implications. Proposition 12 supplies an all-literal-lifts
obstruction rather than filling the proposed positive ACZ
bridge. Its improvement over the earlier minimum-residue
result is the tight-cut face compression and the residual
density argument without a rho bound. ACZ Section 7 already
contains a K4 obstruction for a specified representation
and split; that known example is not claimed as new.

For the direct theorem, the candidate original content is the
passage from complete terminal reachability to the sharp
two-defect threshold with all capacities and all q, supported
by the all-pattern erasure, native guards and proper actual
reservations. The exact weighted sharpness is known input,
not a newly discovered counterexample. Section 10.5 separates
this claim from all-cut decompositions, signed or fractional
packings and conditional binary-to-all-q reductions.

Neither the lifting obstruction nor a negative source search
establishes priority for this direct contribution. Section
10.6 now compares the obtained [GW05] primary statements,
including the proved binary trace criterion and the exact
limits of its announced minimal-counterexample classification.
The distinction between that criterion and the actual
proper-reservation induction is part of the contribution
assessment, not a self-certified originality verdict.
Independent review has supported field-level significance;
originality remains for independent assessment of the
mathematics and this new comparison. The false positive
literal bridge is not a remaining proof obligation, and
another port or residue search is not the next step. The
proof is in prose; no Lean-kernel verification or campaign
completion is claimed.

## References and primary locators

**[S]** A. Schrijver, *Min-max relations for directed graphs*,
Annals of Discrete Mathematics 16 (1982), 261--280.
DOI: [10.1016/S0304-0208(08)72456-3](https://doi.org/10.1016/S0304-0208(08)72456-3).
Theorem 4, p.271; Theorem 5 and Corollary 5a, p.274;
reversed-arc strong-connector correspondence, p.262.

**[DGNS]** O. Durand de Gevigney, V. H. Nguyen and Z. Szigeti,
*Matroid-Based Packing of Arborescences*, SIAM Journal on
Discrete Mathematics 27(1) (2013), 567--574.
DOI: [10.1137/120883761](https://doi.org/10.1137/120883761).
Theorem 1.6 in the author text dated December 11, 2012,
pp.3--4.

**[ACZ]** A. Abdi, G. Cornuejols and G. Zlatin,
[arXiv:2202.00392v5](https://arxiv.org/abs/2202.00392v5).
Definitions 1.2,1.5,2.1,4.7,5.4,5.6,5.8,6.1;
Theorems 2.2,2.7,4.8,5.5,5.14,5.18,6.3--6.5;
Question 8.13; Appendix A, Lemmas A.3,A.7 and
Theorems A.5,A.10. Numbering is specific to v5.

**[W]** A. M. Williams, *Packing Directed Joins*,
MMath thesis, University of Waterloo (2004),
[handle 10012/1024](https://hdl.handle.net/10012/1024).
Figure 1.5 and Section 1.2.1, pp.5--7; Section 2.7,
p.24; Theorem 3.1, p.25; Theorems 3.11--3.12,
pp.30--31; Section 3.4 and Conjecture 3.13, p.32;
Definitions 4.1,4.17--4.18; Propositions 4.23,5.2,7.6.
Proposition 7.6 is printed p.87, PDF p.94.

**[CLR]** G. Cornuejols, S. Liu and R. Ravi,
[arXiv:2501.10918v2](https://arxiv.org/abs/2501.10918v2),
Theorem 1.1 and the capacity conventions in Section 2.

**[ADN25]** A. Abdi, M. Dalirrooyfard and M. Neuwohner,
[author manuscript dated April 3, 2025](https://ahmadabdi.com/papers/tree-orientation.pdf),
Theorem 2 and the definition of weak bridge connectivity,
pp.3--4. No unverified arXiv-version identification is used.

**[ADN26]** A. Abdi, M. Dalirrooyfard and M. Neuwohner,
[arXiv:2602.24124v1](https://arxiv.org/html/2602.24124v1),
Theorem 1.4 and its planar two-dijoin application.
The retrieved HTML identifies v1 with header date February 27,
2026; its separate manuscript title block is dated August 24,
2026. These dates are not treated as two arXiv versions.

**[GW05]** *Advances in packing directed joins*,
Electronic Notes in Discrete Mathematics 19 (2005), 249--255.
DOI: [10.1016/j.endm.2005.05.034](https://doi.org/10.1016/j.endm.2005.05.034).
Obtained [seven-page primary author copy](https://web.archive.org/web/20170922232511id_/http://webhome.csc.uvic.ca/%7Eharon/AdvDijoins.pdf),
snapshot September 22, 2017, PDF created September 24, 2008.
Theorems 1.2 and 1.4 and Conjecture 1.5: PDF pp.2--3;
Lemmas 2.1--2.2 and Corollary 2.3: pp.4--5;
Section 3: pp.5--6; Section 5: p.7.
The author copy lists Guenin before Williams; the saved
publication metadata lists Williams before Guenin.
This copy announces, but does not contain, a longer
full-paper treatment of strengthened minimality.

**[ACF24]** Abdi, Cornuejols and Zambelli,
*Arc connectivity and submodular flows in digraphs*,
[author PDF dated May 1, 2024](https://ahmadabdi.com/papers/connectedflip.pdf),
Theorem 18, printed p.19.

**[IL26]** Abdi, Cornuejols, Liu and Silina,
*Strongly connected orientations and integer lattices*,
[author PDF dated June 4, 2026](https://ahmadabdi.com/papers/SCR-integral-basis.pdf),
Theorems 1.3--1.4 and Section 6.7.

**[AS26]** Abdi and Schwarcz,
*Testing the max-flow min-cut property and the replication conjecture*,
[author PDF dated July 8, 2026](https://ahmadabdi.com/papers/testing-MFMC.pdf),
Conjectures 1--2 and Theorem 2, printed pp.2--3.
