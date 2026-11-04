# One-defect packing with at most six terminals

## Submitted theorem and qualification boundary

This note derives a natural packing-class consequence of the
computer-assisted h<=4 auxiliary theorem in `native_rank_four.md`.
Both the new auxiliary theorem and this consequence await independent
Host review. Neither verified novelty nor publishable significance is
claimed. The unrestricted one-defect objective remains open.

**Theorem submitted for review.** Let D be a finite directed multigraph
with nonnegative integral arc capacities. Suppose its condensation has
at most one unreachable ordered source-sink pair and

    number of source components + number of sink components <= 6.

For every integer q>=1, if every original dicut has capacity at least q,
then D has q capacity-feasible dijoins. Zero-capacity arcs remain in
the topology. In particular, in the all-unit case with finite minimum
dicut size tau, D has tau pairwise arc-disjoint dijoins.

Source and sink components are counted separately; reachability
includes a zero-length path. No restriction is placed on the number of
internal or passive vertices, internal contacts, or chordality.

The proof uses Schrijver's Theorem 4 only for source-sink-connected
topologies, including the passive completion. It does not import a
weighted one-defect two-dijoin theorem, marked-color preservation,
paired polyhedral integrality, or an arbitrary-component minor rule.

## 1. Two protected anchors save two components

Work in a support/contact normal form at fixed q>=2. Let S and K be
the original sources and sinks, T the original q-tight terminals, and

    n = |S|+|K|,  d = n-|T|.

An exactly-one-defect acyclic topology has distinct source and sink
vertices: an isolated vertex would force at least two missing pairs.
Thus this use of T counts actual distinct terminal vertices.

Let F be an ordinary color missing actual canonical B, and G any
ordinary donor. Reserve their original labeled units. Each terminal
in T has one F and one G incidence, and every reserved unit touches
T. Let H join the two units of each original ordinary reserved
two-unit cut, and let h be its number of components.

**Anchor-incidence lemma.**

    h <= n-2.

**Proof.** The two units at each terminal of T are joined in H by
its original terminal cut. Send that terminal to their component.
This map from T onto the H components is surjective, because every
reserved unit touches T.

The direct-anchor lemma in `../two_color.md` supplies actual F units
X->t and s->Y, where X!=s and Y!=t. Their four terminal endpoints
are distinct. Let r be the number of these two units whose endpoints
both belong to T. Each such unit identifies two distinct members of
T under the component map. These r identifications are independent,
since the two endpoint pairs are disjoint. Consequently

    h <= |T|-r = n-d-r.

Every positive unit has at least one endpoint in T. Each of the
remaining 2-r anchor units therefore has exactly one endpoint
outside T. Those endpoints are distinct, so d>=2-r. Substitution
gives h<=n-2. Additional ordinary two-cut edges only decrease h. QED.

This is an arbitrary-rank incidence argument, not a finite graph
experiment. It does not assume all original terminals are tight.

## 2. Closure of the bounded-terminal class

Strong-component contraction defines the terminals in the theorem.
Any subsequent vertex identification followed by strong-component
contraction cannot increase either terminal count.

Indeed, the original preimage of a quotient source component has no
entering original arc and contains an original source. Distinct
quotient source components have disjoint preimages, so their original
sources are distinct. The sink argument is dual. This also covers
the one-vertex quotient.

The same preimage argument proves one-defect closure: an unreachable
quotient source-sink pair gives an unreachable original source-sink
pair in their respective preimages. With only one original missing
pair, only one quotient missing pair is possible. This is the reviewed
identification argument of `../packing.md`, Section 4.

In particular, actual ideal-shore contractions preserve the bound
six. Transitive completion and the fixed-topology capacity operations
do not change either terminal count or source-sink reachability.
No passive arc is deleted.

## 3. Fixed-q normal form, including q=2

Contract original strong components. Dicuts and their capacities
correspond exactly, so a packing of the condensation lifts using
the same external arc labels. A one-vertex condensation has no
dicut and needs no usable arcs. For q=1, all positive-capacity arcs
form a dijoin. It remains to fix q>=2.

Suppose the submitted theorem fails at this q. Within its own
bounded-terminal, at-most-one-defect class, choose a counterexample
with the fewest vertices, then smallest total capacity. Add
transitive arcs with capacity zero, retaining all original topology.
The zero-defect case is excluded by Schrijver's Theorem 4.

The following arguments reprove the required normal form for this
fixed q. They are the capacity identities of `../packing.md`,
Sections 2-6; their validity does not require q>=3.

An original nonterminal q-tight ideal shore has two strictly smaller
quotients in the same class, by Section 2 above. Minimality supplies
their q-packings. Aligning the q distinguished boundary units and
using original cut-incidence modularity glues them, a contradiction.
Thus every q-tight cut is terminal.

A positive unit in no q-tight cut can be removed: integrality leaves
every cut at least q. Capacity minimality forbids this, so every
positive unit touches an original q-tight source or sink.

If u->v->z has two positive units, replace one of each by a unit
on the existing transitive u->z arc. For every original ideal U,

    h_uv(U)+h_vz(U)=h_uz(U).

All cut capacities are unchanged and total capacity decreases.
Expanding a used added shortcut recovers original units and cut
coverage. Hence positive input and output support are separated.

Finally suppose an internal positive tail P reaches an internal
positive head N. Positive units X->N and P->Y have q-tight
terminal endpoints X and Y. If X reaches Y, replace these two units
by one on the existing X->Y arc. On original ideals,

    h_XN+h_PY-h_XY=h_PN.

Terminal cut capacities are unchanged. Each nonterminal cut previously
had capacity at least q+1, so a decrease of at most one leaves it
at least q, also when q=2. Shortcut reconstruction is again valid.
Minimality therefore forces X=s and Y=t. All outputs of P go to t
and all inputs of N come from s.

These are precisely the separated-support and contact hypotheses
needed for canonical dominance and the auxiliary pair theorem.
The canonical-ideal proof in `../packing.md`, Section 6, uses only
these hypotheses. It therefore supplies the same actual B here:
ordinary coverage plus meeting B is equivalent to original dijoin
coverage. None of this assumes the desired weighted q=2 conclusion.

## 4. Completion packing and original reconstruction

Add the passive arc s->t. Schrijver's Theorem 4 gives q ordinary
capacity-feasible colors. Every q-tight terminal is ordinary. Its q
available units must supply exactly one unit to each color. Since
every positive unit touches such a terminal, all positive units are
used exactly once. We therefore have an original labeled-unit
partition, not extra copies of selected units.

Among these finitely many ordinary partitions, minimize the number
of colors missing B. If the minimum were positive, choose a bad
color F. The original B cut has capacity at least q. Since fewer
than q colors meet B, some donor G has at least two actual B units.

The reserved F/G topology is in the auxiliary threshold-two class:
each original cut has at least two reserved units when ordinary,
and exceptional cuts have at least the two donor B units by
canonical dominance. Every reserved unit touches an original
q-tight terminal with reserved degree two. Separation and the
contact restriction persist on the retained topology.

The anchor-incidence lemma gives

    h <= n-2 <= 4.

Apply the auxiliary theorem of `native_rank_four.md`. It partitions
the reservation into two original dijoins, keeping all other colors
unchanged. Each new color takes one unit at every reserved two-tight
original terminal. Thus no new color uses two copies of one original
arc, every reserved unit is exhausted, and every original capacity
is respected. All original ordinary cuts and all exceptional cuts
are covered, not just terminal cuts. This strictly lowers the
bad-color minimum, a contradiction.

Thus the chosen weighted counterexample does not exist. Reversing
the justified capacity operations and actual shore gluing preserves
original labels, cuts and capacities. Lifting the condensation gives
the stated theorem for D. Unit capacities make the resulting dijoins
pairwise arc-disjoint.

The same argument shows that a positive globally minimal bad-color
partition in any reviewed normal form must have both h>=5 in every
bad/multiple-B reservation and at least seven original terminals.
It does not exclude either condition at larger size.

## 5. The class is unbounded and need not be chordal

Take sources {s,a,b}, sinks {t,y,z}, and every source-sink arc except
s->t. Add any finite acyclic internal graph M, all arcs from a,b to
each vertex of M, and all arcs from each vertex of M to y,z.
There are still exactly six terminals and exactly one missing pair.
M can contain an arbitrarily long induced chordless cycle with an
acyclic orientation.

With all capacities one the minimum dicut is two. The underlying
core K_(3,3) minus s-t is connected with no bridge. Every added
terminal-to-M edge lies in a triangle through a core edge, and every
edge internal to M lies in a triangle through a. Thus the whole
underlying graph has no bridge. A nontrivial directed cut is also
an undirected cut, so has at least two arcs; the cut at s attains
two.

Replacing every arc by r parallel unit arcs gives minimum dicut
2r without changing terminals or reachability. If a simple digraph
is wanted, replace those parallel arcs by distinct two-edge paths.
Each ideal crosses exactly one edge of each such path when its
original endpoints are separated, and none otherwise. Hence its
cut sizes and the minimum 2r are preserved. No new terminal is
created. This illustrates unbounded internal topology and unbounded
minimum cut; it is not the proof of the theorem.

## 6. Primary-source comparison and unresolved originality

The primary text of Aaron Michael Williams, *Packing Directed Joins*
(Waterloo MMath thesis, 2004), was obtained at
<https://hdl.handle.net/10012/1024>. The downloaded PDF and its
text are `research/literature/six_terminal_williams2004_primary.*`.

Its Section 3.4, printed page 32, states **Conjecture 3.13**, not a
theorem: weighted packing for a graph with one source reaching every
sink and one sink reached from every source. This includes the
exactly-one-missing-pair class, which has at least two sources and
two sinks. A generated search assertion that its Chapter 5 proves
the weighted almost-source-sink-connected theorem was not adopted.
The actual Chapter 5 concerns minimally non-2-knitted graphs.

There is relevant prior work beyond that conjecture. Section 4.3,
Proposition 4.23, describes maximal s-trees of minimal weighted
counterexamples. Chapter 7 culminates in **Proposition 7.6**, printed
page 88: no minimally non-knitted weighted directed graph has four
s-paths. Its minimality uses the augmented-graph minor operations of
Section 4.1, including folding and Z-biclique substitution.

This is essential prior art for the new h<=4 argument. It is not
silently treated as a native-reservation theorem: no equivalence
between that augmented-minor minimality and our retained-topology,
prescribed-ordinary-reservation hypotheses has been proved here.
Conversely, no originality claim is justified merely by using a
different parameter or proof. Review must decide whether the
six-terminal consequence is already subsumed or immediate from
those results, and whether any remaining delta is publishable.

The focused literature reader found no verified theorem for this
exact six-terminal class. The Williams-Guenin 2005 proceedings
paper, DOI 10.1016/j.endm.2005.05.034, remains inaccessible in this
round; its publisher denial was not retried. These bounded findings
do not establish verified novelty.

The new mathematical improvement over the accepted campaign result
is precise: h<=3 repair becomes a submitted h<=4 repair theorem;
the independent anchor-incidence bound converts it into an all-q,
integral-capacity packing theorem for a natural bounded-terminal
class. The unrestricted h>=5/multicolor obligation is unchanged.
