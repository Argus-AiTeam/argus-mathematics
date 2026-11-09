# A compressed-encoding pair-energy theorem

## 1. The theorem and the exact kernel

Let G be a finite loopless colored multigraph on an even number N >= 2
of vertices, with at least one perfect matching and at most two colors
per vertex pair. Fix an order on colors at each pair and positive
edge activities. A matching weight is the product over colored edges;
pi is its normalized law. Assume a >= 1 and:

1. The two colors of any parallel pair have activity ratio at most a.
2. Every colored simple even cycle of length >= 4 has a deterministic
   quadrangulation into odd original-cycle arcs. Every side has a
   chosen endpoint chord (the actual colored edge for a short side),
   consistent on complementary arcs. A long side is good when its
   two interior leaves have a chosen repair edge. Each cell has a
   good opposite pair; when an opposite pair is long on both sides,
   the other pair is good.
3. In a cell, all four chords, all first/last arc edges, and the
   chosen good-side repairs have pairwise activity ratio at most a.

These are local combinatorial/weight hypotheses, not a spectral-gap
assumption. The graph need not have a label tree.

On (A,B), choose each of these types with probability 1/3:
choose an unordered pair of A-edges uniformly, choose one of the two
other pairings uniformly, and independently choose index 1 or 2 for
each new edge; choose an A-edge uniformly and index 1 or 2 for its
color; or choose a discrepancy component uniformly and exchange its
layers. Absent indices and inapplicable choices hold. Accept by
Metropolis for pi x pi. Common identical edges are not discrepancy
components; different parallel colors form length-two components.
Let E be half the stationary sum of squared changes.

**Theorem.** Under these hypotheses, for every two real matching
functions f1,f2,

    Var_pi(f1) <= 44040192 N^12 a^6 E(f1(A)+f2(B)).               (1)

In particular, for exactly the tree-bag graphs and common clamps in
the staged source, a = 1000D is valid and (1) implies its stated
`(10^4 N D)^100` comparison.

The independent strengthening over the source proof is the compressed
preimage bound in Section 3: T = 2^17 N^8 instead of (10N)^30.
The proof also isolates precisely which graph properties suffice.
This strengthens the pair comparison, not the entire FPRAS or entropy
theorem. Publishability/novelty require independent review.

## 2. Kernel and signed identities

Write m = N/2. For a specified legal two-edge replacement, one
proposal atom has probability

    1 / (3 * binom(m,2) * 2 * 2 * 2).

For m >= 2 this is at least 1/(30 N^2). An a-safe switch
has weight ratio at least a^-2. A specified color destination has
proposal probability at least 1/(6m) >= 1/(6N), and acceptance at
least a^-1. A specified discrepancy component has probability
1/(3c) >= 1/(3N); its product weight is unchanged. Every reverse
atom has the same edge/pairing/color probabilities. Component swaps
preserve the entire component list. Thus the proposal is symmetric
and Metropolis is reversible, with exactly the manuscript's holds.

For F = f1(A)+f2(B) and E = E_P(F), define S and K to be the
unweighted sums over safe first-coordinate destinations and
single-edge recolorings, respectively. Define W to be the sum over
all discrepancy-component squared F changes, weighted by pi(A)pi(B).
The half in the energy gives

    S <= 60 N^2 a^2 E,  K <= 12 N a E,  W <= 6 N E.             (2)

For a fixed demand pair I1,I2 and simple component C, keep I1
outside C. Denote the two cycle orientations by O0,O1, with O0=I1.
For each side J, T_J is its odd-position through matching, N_J
its even-position interior matching, and C_J=N_J+chord. Each
of T_J,C_J covers the same vertices. The canonical conversion
gain g_J is evaluated at the whole orientation containing T_J.

For each cell let P be the through opposite pair in O0 and Q the
one in O1. A_P uses all four N patterns and the two P chords;
A_Q uses the Q chords. They differ by one safe two-edge switch.
Convert the two P sides in a fixed order (Y,X). The first gain is
canonical; the second differs from its canonical gain by

    E_YX = partial_X f1(after converting Y)
                         - partial_X f1(before converting Y).

The same applies to Q. Subtracting these two conversion equations
gives, with Delta=f1(A_P)-f1(A_Q) and D=f1(O0)-f1(O1),

    D = Delta + sum_P g_J - sum_Q g_J + E_P - E_Q.              (3)

No long conversion is claimed to be a chain transition. Opposite
arcs have disjoint vertex sets; an error vanishes if either is
short. At an interior diagonal, the two complementary conversions
produce the same colored matching. Their signed canonical gains
therefore add to D, not zero. A quadrangulation has one more cell
than interior diagonal, so summing (3) gives

    D = sum_cells (Delta + E_P - E_Q).                         (4)

These are identities for arbitrary real functions, including
non-additive edge functions.

## 3. Encodings and the compressed inverse

A switch demand consists of I1,I2,C and a cell. An error demand
also chooses a two-long opposite pair and its fixed order. Every
demand has weight rho=pi(I1)pi(I2).

Start with all four through patterns: corners have degree two,
all other cycle vertices degree one. Choose a good opposite pair G.
On a short G side delete its edge; on a long G side delete its two
boundary edges and insert the leaf repair. This produces a legal
matching of the cycle: every corner loses one incident edge, and
each uncovered internal leaf is repaired.

For a switch, the encoding's first layer is A_P and the second is
this repaired all-through matching, with I2 unchanged outside C.
The original two-layer union has one T and one N on every side.
The output adds two P chords and r repairs and drops 2+r boundary
edges, where 0 <= r <= 2 counts long selected sides.

For an error on opposite pair H={X,Y}, the first context A0 is the
orientation containing T_X and T_Y, still with I1 outside C. Start
the guide with the complementary cycle orientation, insert the
two H chords, and repair the other, good, opposite pair G. The
guide B0 contains C_X and C_Y. To obtain context one, exchange T_Y
and C_Y between the two layers. This gives A1 and B1; B1 still
contains C_X because the two side vertex sets are disjoint.
Their multiset union and product weight are unchanged.

For all three encoding types, at most four added and four dropped
edge occurrences have pairwise-comparable activities. Hence

    rho <= a^4 pi(A)pi(B).                                    (5)

Here is a shorter inverse tag. Record:

* four cyclically ordered cell corners;
* the two ordered leaves for each selected long G side (four vertex
  slots in total; use the corresponding first corner as filler for
  each absent slot of a short side);
* flags: encoding type (3), input alternating orientation (2),
  cycle direction (2), added-chord opposite pair (2),
  repaired opposite pair G (2), the two long/short bits (4),
  and error order (2);
* eight color indices: two inserted chords, up to two repairs,
  and up to four dropped boundary edges; absent slots are index 1.

There are at most

    3*2*2*2*2*4*2 * N^8 * 2^8
       = 98304 N^8 <= 2^17 N^8 = T                           (6)

tags. Flags are deliberately redundant. All slots are in a fixed
side order, not unrecorded permutations. On a long selected side
with endpoints c_i,c_(i+1) and recorded leaves u,v, the dropped
edges are (c_i,u),(v,c_(i+1)) and the added repair is (u,v). On a
short side the one dropped edge is its endpoint pair. The two
inserted chord endpoint pairs are determined by the recorded
opposite-pair flag. Colors are recovered from the ordered lists
of at most two colors at these endpoints. Thus the tag determines
both modification lists **without first knowing the cycle**.

Given the output pair and a produced tag, subtract the added
occurrences from its multiset union and restore the dropped ones.
This restores I1 multiset-union I2. Multiplicities are retained:
an edge appearing in both lists is not silently cancelled before
decoding. Subtraction is legal even then, because every added
occurrence is present in the output matching layers by construction.
The component through the first tagged corner is the active simple
cycle. The orientation bit specifies its I1 alternating class;
alternation determines both input layers throughout that component.
Outside it the output layers were unchanged, so recover I1,I2
directly. Recompute the fixed quadrangulation. The four corners
identify the cell, and the flags identify the error/order/context.
Consequently one tag and output recover at most one demand.
No list of arbitrary added/dropped endpoints is necessary.

This proves (6) for the actual encoding fibres, for every N.
`tagged_fibre_bound` formalizes the finite-cardinality implication
of this injective decoder, not the decoder itself.

Combining (5)-(6) with (2), the switch-demand sum U satisfies

    U = sum_switch rho Delta^2 <= 60 N^2 a^6 T E.              (7)

## 4. Conditional demand mass and swap sum

An identity X is a directed colored simple odd path of length at
least three with a specified endpoint chord. Set

    p_X = sum_(B containing C_X) pi(B).

Every error-demand X has p_X>0 by its constructed guide. For either
context j and a fixed matching A containing T_X, apply (5)-(6)
only to guides containing C_X:

    sum_(d: X(d)=X,A_j(d)=A) rho(d)
                      <= a^4 T pi(A) p_X.                    (8)

The fibre bound does not discard the guide restriction. Let mu_X
be the conditional guide mean of partial_X f2. For any u, finite
weighted centering gives the exact identity

    sum_(B containing C_X) pi(B)(u-partial_X f2(B))^2
      = p_X (u-mu_X)^2
        + sum_(B containing C_X) pi(B)(partial_X f2(B)-mu_X)^2.

The last sum is nonnegative. Applying the two-context inequality
and (8), and then this identity, bounds the error-demand sum V by

    V <= 4 a^4 T Sigma,
    Sigma = sum_X sum_(A containing T_X,B containing C_X)
        pi(A)pi(B)(partial_X f1(A)-partial_X f2(B))^2.         (9)

In particular there is **no** division by an uncontrolled rare-event
probability remaining. The two patterns exhaust their vertex set,
so X plus its chord is an entire discrepancy component of A,B.
Exchanging it changes F by the expression in (9), with the shown
minus sign because the B derivative is taken from through to closed.
For a fixed ordered pair and component, mark a B edge as chord
and choose one of two directions. This determines X. At most 2N
identities can produce this component (in fact at most N suffice).
Thus Sigma <= 2N W <= 12 N^2 E, and

    V <= 48 N^2 a^4 T E.                                    (10)

Directed paths and colored parallel edges are counted, not quotiented
away. Length-two components are handled only by K in (2).

## 5. Composition and the tree-bag bridge

Toggle the demand discrepancy components in a deterministic order.
Cauchy--Schwarz and the variance identity bound Var(f1) by N times
the total weighted squared component differences. For any selected
component, exchanging all earlier components in both demand layers
is a weight-preserving involution. Hence its term is exactly the
canonical D used in (4), with no assumption that I1,I2 agree
elsewhere. A color component contributes at most K. There are fewer
than N cells per simple component, so (4) gives

    Var(f1) <= N [ K + 3N(U+V) ].

Substitute (2), (7), (10). Since N,a,T >= 1,

    Var(f1) <= [12 N^2 a + 180 N^4 a^6 T
                            + 144 N^4 a^4 T] E
             <= 336 N^4 a^6 T E.

Together with (6) this is (1). These substitutions and the
headline-constant domination are checked in `Main.lean`.

For completeness the local hypotheses follow from the actual
tree-bag definition, not an assumed identification with upstream
Lean declarations. At each cycle vertex the incident label set S_v
has one node or two adjacent nodes. A chord can use a common node
of its endpoints' **original** S sets. For an admissible odd subarc
J of length s, choose a common endpoint node P. Its label sequence
a_0,...,a_(s-1) walks on the tree with possible repetitions.
An excursion avoiding P whose endpoints neighbor P has equal endpoint
nodes, because each component after removing P has only one neighbor
of P.

Here is an exhaustive recursive split, stated to fix the bridge.
The new cell has sides [0,p1],[p1,p2],[p2,s],exterior.
Indices p1 are odd and p2 even. If the exterior is good, first
ensure some a_i=P; if none is P, the excursion observation allows
replacing P by a_0=a_(s-1). If an odd-index occurrence i exists,
take (p1,p2)=(i,i+1). Otherwise all occurrences are even: if the
first is i>0 take (i-1,i); if the first is 0 and last j<s-1 take
(j+1,j+2); otherwise take (1,s-1). The excursion observation
proves endpoint admissibility of all child arcs. The middle side
is short in the first three cases, and both outer sides are short
in the last; together with the good exterior this proves both
required opposite-pair properties.

If the exterior is not good, one exterior leaf lacks P. Reverse
the subarc so that this leaf is next to its first endpoint. Then
a_0=P. If a_(s-1)=P take (1,s-1). Otherwise let t-1 be the last
P index. The avoiding suffix has a_t=a_(s-1)=Q, a neighbor of P.
For even t take (1,t); for odd t take (t,s-1). In each case both
outer arcs are good and one is short: their long member has equal
boundary labels. The middle arc is admissible by P in the even
case and Q in the odd case. The indices are strictly internal
because s is odd and t is respectively even or odd. This proves
the same properties. Recurse on the three odd child arcs, always
retaining original S sets and original exteriors. Their polygon
interiors are disjoint, so the resulting diagonals do not cross.
The recurrence gives (m-2)/2 cells for cycle length m. Any shared
endpoint label may color a diagonal consistently; it need not be
the splitting label.

For weights, consecutive side-chord labels meet in a corner S set
and are at distance at most one. Every boundary edge label is at
distance at most one from that side chord. A leaf-repair label is
at distance at most one from its adjacent boundary-edge label.
Thus each relevant label is at distance at most two from its side
chord, and any two relevant labels have distance at most six.
Tree heights change by a factor two across each tree edge.
The stated reference intervals give a weight ratio at most
3*2^6*D=192D <=1000D. Parallel colors are adjacent, giving ratio
at most 6D. A common positive clamp cannot increase any ratio:
for x>=y>0 its clamped ratio lies in [1,x/y]. These conclusions
also cover empty/repeated bags and disconnected graphs; only a
nonempty matching state space is needed.

Therefore every permitted graph and common clamp satisfies all
three hypotheses with a=1000D. No balancing, entropy theorem,
replica Poincare theorem, or unexecuted external formalization is
an assumption of this comparison.

## 6. The nonzero eight-cycle test

Take the label tree 0--1--2, heights 1,2,4, D=1. Vertices 0,3,4,7
belong to {0,1}; vertices 1,2,5,6 belong to {1,2}. Around the cycle
(0,1,2,3,4,5,6,7), use colors (1,2,1,0,1,2,1,0). The splitting
rule has a central cell (0,3,4,7), with long opposite arcs
X=(0,1,2,3), Y=(4,5,6,7). Both endpoint chords have color 0;
their leaf repairs can have color 1. The two remaining cells are
the length-four ears. All are actual legal colored matching
constructions in the graph, not in an uncolored cycle-only graph.

Let f1 indicate the all-through matching TT on X,Y, and zero
elsewhere. Its four context values (TT,CT,TC,CC) are (1,0,0,0).
Then E_YX=-1 and E_YX^2=1. This is not a counterexample to the
source, which explicitly includes this error. It rules out the
shortcut of treating the long conversions as independent gains.
The exact script checks the actual repair, guide restrictions and
swap identities both for reference activities and clamp [3/2,3].

The exact finite checks support fidelity and catch implementation
errors; only Sections 1-5 prove the all-size comparison.
