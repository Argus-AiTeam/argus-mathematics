# Native exclusion of the rank-three Q6 obstruction

## Result, exact scope and prior boundary

The full one-defect q-color theorem is still unproved. The new result
below excludes the **native** three-component obstruction left possible
by the accepted `boolean_quotient.md`. It uses actual original ideal
shores and tight-cut contractions, not an interpretation of arbitrary
component identification as a graph minor.

**Low-rank reserved-pair theorem.** In any reviewed arbitrary-size q>=3
normal form, let F be an ordinary color missing actual B and G an
ordinary color with at least two actual B units. If their ordinary
reserved-two-cut graph H has at most three components, their original
reserved units can be repartitioned into two original dijoins.
All original capacities, q-tight terminal counts, actual B, internal
endpoints, contacts and retained passive topology are respected.
The other q-2 colors are unchanged.

Consequently, at a positive global bad-color minimum **every**
bad/multiple-B reservation has at least four ordinary two-cut
components. Previously the three-component Q6 quotient was only
classified, not excluded in the original topology. This is a genuine
arbitrary-size increase in the proved pair-repair scope; it is not
universal multicolor descent or full-q reconstruction.

There are two proof layers. Actual tight-shore gluing reduces a
smallest counterexample without increasing h. In the irreducible
rank-three case the three forced facet shores encode three short
terminal paths. Their original source ancestry and sink descent
give the analytic contradiction in Section 4. A separate complete
signature enumeration corroborates that bounded argument; no
bound on passive vertices is imposed.

No new external theorem is used. Schrijver's reviewed zero-defect
packing and one-color connector convex-hull results are the same
primary assertions independently attributed in rounds ten and eleven.
The abstract Q6 model is known prior art, not claimed novel. This
native exclusion has not received independent review or publication
qualification. Its extension beyond three components is unproved.

## 1. The auxiliary threshold-two class

We prove a threshold-two statement rather than silently using an
unproved weighted W(2) theorem. Consider a finite transitive acyclic
full topology D with exactly one unreachable original source-sink
pair (s,t), and distinguish its positive integral capacity units E.
Assume:

1. Every original proper ideal cut has at least two E units.
2. E has a partition into two colors F,G covering every ordinary
   original cut, namely every ideal cut of D+(s->t).
3. Every E unit is incident with an original terminal whose E-degree
   is two. Positive incoming and outgoing support are separated.
4. Every internal positive-outgoing P that reaches an internal
   positive-incoming N has all its active outgoing units toward t
   and all N's active incoming units from s.

Capacities on a single arc are not assumed one. Unit labels are
retained and all zero-capacity topology stays present. No assertion
about **all** threshold-two one-defect instances is assumed.

Let H have vertex set E and an edge between the two units of each
ordinary original two-unit cut. Each such pair has one old F and
one old G unit. Write h for its number of components.

**Auxiliary theorem.** Every instance of this specified class with
h<=3 has a full original two-dijoin partition.

This class contains any reservation in the stated native theorem.
Its units touch the old q-tight terminals, which have exactly one
F and one G unit and hence are two-tight in E. Conditions 1 and 4
come from canonical dominance and the original contact restriction.
The canonical B units for the reservation are exactly the original
actual B units it retains: removing unselected units can change
passive canonical vertices but not any retained positive boundary
unit, as the next argument shows.

The usual canonical ideal proof works at threshold two with no
change. With L=Anc(t), R=Desc(s), and M the remaining vertices, put

    U* = L union Anc(M-),

where M- are internal positive-incoming vertices in M. Separation
and condition 4 forbid a positive-outgoing M vertex from reaching
M-. Hence U* contains all positive M- vertices, excludes all
positive M+ vertices and R, and is an exceptional ideal. Divergence
on M proves canonical dominance for every nonnegative unit vector.
Every active boundary unit has tail in L and head in R.
All original sources except s belong to U*, and t is its only
original sink. These statements do not require q>=3.

In particular F/G ordinary coverage plus actual B coverage is
equivalent to original dijoin coverage in this auxiliary class.
Applying the edge-truncation proof of `boolean_quotient.md` to the
two one-color integral faces shows m_j<=1 for the number of actual
G-owned B units in an H component whenever F misses B. The proof
uses only original cut capacities at least two, ordinary two-cut
equalities and one-color integrality; it does not use a weighted
two-packing theorem.

## 2. Rank is additive under an actual ordinary tight-shore split

Let U be an original ordinary ideal with two boundary units C,
one of each old color. Form the **actual** shore contractions

    D_L = D/(V minus U),       D_R = D/U,

keeping both C unit labels in each quotient. Complete the topology
transitively with passive arcs if necessary. Let H_L,H_R be their
ordinary two-cut graphs on the restricted original unit labels.
Then

    h = h_L + h_R - 1.                                  (1)

In particular neither quotient has larger h.

First, ordinary quotient cuts expand to ordinary original cuts.
The image of s->t is either a loop or an arc from a quotient source
to a quotient sink. Adding that image gives the shore quotient of
the source-sink-complete topology D+(s->t). If the original quotient
still has a missing pair, it must be exactly these two image
endpoints: adding a source-to-sink arc can fix no other pair.
If the image is redundant or a loop the quotient has no missing
pair. Thus the original notion of ordinary cut agrees with the
quotient notion. Old F and G each cover those expanded cuts.

Every H_L/H_R edge is therefore an original H edge. Conversely take
an original ordinary two-cut shore W. If W is nested with U,
disjoint from U, or has union V with U, its boundary appears in
one shore quotient. Otherwise I=U intersect W and J=U union W
are proper nonempty ideals of the fixed completion. Cut modularity
gives, as incidence vectors on the original labeled units,

    chi_C + chi_delta(W) = chi_delta(I) + chi_delta(J).

Both right-hand cuts have at least two units, so both have exactly
two, one per old color. For each old color the two labels on the
left equal the two-label multiset on the right. Consequently the
edge of W is either itself one of those two quotient edges, or
its endpoints are joined through the other two edges and C.
The four possible old-color matchings are enumerated exactly by
the companion verifier. No contraction of an H component is used.

Thus H has precisely the connectivity of H_L union H_R. Their
unit vertex sets intersect in exactly the two C labels, which
are joined by the edge C in both. All other components are
disjoint, proving (1).

The auxiliary class is preserved in each non-zero-defect quotient.
Every quotient cut expands to an original cut. A surviving old
terminal remains a terminal; the new contracted vertex is a
two-tight source or sink. A unit that loses its old tight endpoint
is a boundary unit and gains that new tight terminal. Separation
is preserved. Remaining internal P,N are old internal P,N; their
contact units now end at the image of t and start at the image of
s, respectively. If a missing pair remains, these are its endpoints
by the preceding completion argument. Old F/G restriction gives
the required ordinary partition. Internal zero-capacity topology
is not removed by fiat; this is the reviewed actual shore operation.

The usual two-tight gluing labels the two quotient packings by
their common C unit. For a fixed color y, y(C)=1. On a crossing
original ideal W, its proper intersection I and union J with U
are cuts on the respective quotients, so

    y(delta(W)) = y(delta(I)) + y(delta(J)) - y(C) >= 1.

The other original ideals appear directly in a quotient. This is
the already reviewed all-original-cut gluing proof, with unchanged
original unit identities.

## 3. A smallest rank-at-most-three failure has three B paths

Suppose the auxiliary theorem fails, and choose a failure of
minimum vertex count in its stated class with h<=3. A two-tight
exceptional cut cannot occur: both exceptional shore contractions
are zero-defect, so Schrijver and reviewed tight gluing pack it.
An ordinary nonterminal two-tight cut cannot occur either:
Section 2 gives two strictly smaller quotients of the same
rank-bounded class, or zero-defect quotients, and their packings
glue. Thus all original two-unit cuts isolate a source or a sink.

If F and G both meet actual B, they already pack. Otherwise
rename them so F misses B. Put m=|B|, all old G. Cut lower bounds
give m>=2; m=2 is the already settled tight-exceptional case.
Section 1's singleton argument gives

    3 <= m <= h <= 3,

so m=h=3 and each H component contains one B unit. Failure of
paired repair forces exactly the accepted Q6 polytopes. That
classification uses only the one-color integral faces, their
full-dimensional half vector, and m=h=3; all hold in the auxiliary
class by Section 1. It requires no weighted threshold-two packing
theorem or native q>=3 slack. Hence
there are three **original ordinary shores** U_0,U_1,U_2 with

    delta_E(U_i) = {one G unit of component i,
                   one F unit of each other component}.   (2)

The multiplicities are exactly one, by the accepted facet argument.

Now H is just terminal pairing: every original two-tight terminal
joins its unique F/G units and there are no other two-unit cuts.
Orient G units forward and F backward, pairing only at these tight
terminals. Each H component is a path or a cycle in this paired
incidence sense. A signed cycle has zero contribution on U*,
whereas a component's contribution is its positive number of B
units. Thus all three components are paths with one B unit each.

For any vertex v write its three shore bits as

    z(v) = ( [v in U_0], [v in U_1], [v in U_2] ).

Telescoping the signed component path and using (2) forces its
endpoints to have bits

    z(a_i)=e_i,       z(b_i)=1-e_i.                       (3)

Also a_i is in U* and b_i outside. All six three-bit endpoints
are distinct. A non-two-tight original terminal has at least
three reserved units by ordinary terminal coverage. Every one
would be an unpaired path endpoint, but (3) permits at most one
unit endpoint at that original vertex. This is impossible.
Therefore **every original terminal is two-tight**.

The six path endpoints are consequently internal active vertices.
Every source and sink appears as an interior vertex of these
three paths; there are no additional original terminals with
zero E degree. Paths are vertex-simple: tight terminals have only
their two paired incidences, and the endpoints are distinct.
Before B their only possible original sink is t; after B their
only possible original source is s. Each occurs at most once.
Internal vertices are endpoints, never pairing vertices. Thus
each path has length at most seven. Arbitrarily many passive
nonterminal vertices may still exist in the full original D.

## 4. An analytic shore-signature contradiction

Write `all=111`, `zero=000` and `c_i=1-e_i`. Edges along path i
alternate G forward and F backward. In the three ordinary shore
bits, one G removes bit i once, every other G removes no bit,
and F adds each of the other bits once, possibly both at once.
In the U* bit, only B changes anything: its G traversal removes
one. The path starts at `(e_i,1)` and ends at `(c_i,0)`.
Interior vertices after G are original sinks, and those after
reversed F are original sources. Thus t precedes B on its path,
while s follows B on its path.

Every original source mask contains every original sink mask:
the three ordinary shores are ideals of D+(s->t), which has
complete source-sink reachability. Each internal endpoint also
has an original source ancestor and an original sink descendant.
These necessary conditions use all passive topology.

### 4.1 Extreme terminal masks must occur

Suppose no original source has mask `all`. A source ancestor of
endpoint b_i, whose mask is c_i, must then have mask exactly c_i.
All three such source masks occur, so every sink has mask `zero`.
At least two of these three distinct source masks belong to
sources other than s.

Consider a non-s source with mask c_i on path k. If k=i, its
positive bit i has already been removed. The source must follow
t: it cannot be the first source after endpoint e_i, since a
reversed F cannot remove i. If k!=i, its mask contains the positive
bit k and one other bit, while the remaining bit i has not yet
been added. Its next G either leaves that two-bit mask unchanged
or removes only k. Neither outcome is a sink of mask zero, and
neither is the endpoint c_k, which still needs bit i. This is
impossible. Hence each non-s c_i source would have to follow the
unique t on path i. There can be at most one, a contradiction.
Therefore some source has mask `all`. Reversing the topology and
complementing the shore masks proves that some sink has mask `zero`.

Not **all** sources can have mask `all`. Under that hypothesis
a zero-mask sink must be reached by the first, critical G of
some path j: a G from a source of mask all cannot reach zero.
If that sink were t, the next F would have to lead to a source
with mask contained in c_j, impossible. Otherwise that G is B.
The next F cannot lead to s, again because its mask would be
contained in c_j. Thus path j is the two-unit path GF, with its
only sink of mask zero, and its initial internal positive-outgoing
endpoint has mask e_j. That endpoint lies in L and reaches t, so

    z(t) subset e_j.

The terminal t is on another path k. Its incoming G cannot start
at a source of mask all: it could remove at most one bit, leaving
at least two. If it starts at the initial internal endpoint e_k,
the displayed bound forces t to have mask zero and that G to
be critical. Its next F must lead to a source contained in c_k,
again impossible. This excludes the all-sources-all case.
The dual argument excludes the all-sinks-zero case.

### 4.2 Extreme sources and sinks are path ends

Take a source of mask all on path i. Its next G must be critical.
A noncritical next G would either reach a sink of mask all,
forcing all sources to have that mask, or end with the wrong
endpoint mask. If the critical G leads to an **internal** endpoint,
it is the final edge and that endpoint is b_i. We now exclude
the other possibility, an original sink of mask c_i.

Such a sink would force every source mask to contain c_i. A
zero-mask sink exists by Section 4.1. It cannot be reached from
an original source, whose mask has at least two bits, so it
follows the first, critical G on a path j. If it were t, the
following source would have mask contained in c_j and containing
c_i, forcing j=i. But bit i would already have been removed
before the source all on path i. If it is not t, that first G
is B. A following original source s similarly forces j=i and
the same contradiction. Thus it belongs to a pure GF path j,
different from i. Its internal start implies z(t) subset e_j.

Now inspect t on a path k!=j. If its incoming G starts at an
original source, the only way to remove one bit from a mask
containing c_i and obtain a subset of e_j is

    {i,j,k}={0,1,2},  source mask=c_i,  z(t)=e_j.

Bit k has then been removed, so the next source cannot contain
c_i, although every source must. If instead t's incoming G is
the first edge from internal endpoint e_k, it must be critical
and z(t)=zero. The next source must lie between c_i and c_k,
forcing k=i, again removing bit i before the source all. Both
possibilities are impossible.

Consequently **every all-mask source is immediately followed by
the final, critical G to internal b_i**. Dually, every zero-mask
sink immediately follows the first, critical G from internal a_j.
These extrema cannot lie on the same path. Since b_i is an
internal positive-incoming vertex outside U*, it belongs to R;
since a_j is internal positive-outgoing in U*, it belongs to L.
Thus, for distinct i,j,

    z(s) is either c_i or all,
    z(t) is either zero or e_j.                           (4)

If z(s)=all choose its own path for i; if z(t)=zero choose its
own path for j. This keeps i!=j by the extreme-end statements.
Let k be the remaining index.

### 4.3 The four distinguished-terminal cases

If z(s)=c_i and z(t)=e_j, the all-mask source on path i is not s.
Its final G is B. Its preceding F cannot start at t, which lacks
bit i, so path i is the pure two-unit input path FG. The zero-mask
sink on path j is not t; its preceding G is B. Its following F
cannot reach s, which contains bit j, so path j is the pure
two-unit output path GF. Both s and t must lie on path k.
But t has bit k zero and precedes B, while s has bit k one and
follows B. That bit can only be removed, never re-added. Impossible.

If z(s)=all and z(t)=e_j, path j is again pure GF. The F unit at
s comes from an original sink containing bit i, so every source
contains i. The sink t forces every source also to contain j.
A source ancestor of internal a_k, which has bit k and is in U*,
cannot be s. It must therefore be a **non-s source of mask all**.
It cannot be on path i, whose final source is already s, or on
the pure output path j. On path k its final G is B, and its
preceding F cannot come from t, which lacks k. Thus path k is
pure FG and contains no t. Path i cannot contain t either:
bit i is still one before its final G, whereas t has mask e_j.
There is no possible path for t. The case z(s)=c_i, z(t)=zero
is the dual contradiction.

It remains to consider z(s)=all and z(t)=zero, on different
paths i,j. The original F unit at s comes from a sink containing
bit i; hence **every source contains i**. The original F unit at
t goes to a source lacking bit j; hence **every sink lacks j**.

Internal a_j is in U* with mask e_j, so it needs a non-s source
ancestor containing j. None can be on path j, after its first
critical G has removed j. On path i, any source before B goes
through a noncritical G into an original sink before s; that
sink, and hence that source, lacks j. The required source must
therefore be on path k.

Internal b_i is outside U* with mask c_i, so it needs a non-t
sink descendant lacking i. None can be on path i before its
last critical G: those masks still contain i. On path j any
non-t sink follows a noncritical G from an original source,
which contains i. The required sink must also be on path k.

Path k contains neither s nor t. It is consequently one of:

    FG: one source all and no sink;
    GF: one sink zero and no source;
    FGF: one source e_k union J and one sink J,
         where J is a subset of {i,j}.

The first two cannot supply both required terminals. In the
third, a source containing j and a sink lacking i require
J={j}; its source then lacks i, contradicting the fact that
every source contains i. This settles the last case in (4).

The native Q6 shores are impossible. This contradicts the
smallest auxiliary failure and proves the low-rank theorem.

### 4.4 Independent exact finite corroboration

`q6_shore_paths.py` independently enumerates the masks underlying
this argument. For every length 2,...,7 and first color it chooses
the B G position, critical G position and F position of each
other bit: **564 raw placements per component**. Length one would
leave its unit incident with no tight terminal.

The unique s/t and completed source-sink mask conditions leave
90 locally admissible profiles per component, 510 compatible
first-two pairs and 978 triples. The full source/sink four-bit
profiles and both internal endpoint types are retained; there
are no duplicated admissible profiles. Of these triples, 468
lack a source ancestor at an endpoint only, 468 lack a sink
descendant only, and 42 lack both kinds. None has the necessary
ancestry and descent at every endpoint. A rejection witness is
retained for each of the 978 triples.

This exactly corroborates the analytic proof, not a claim that
every relaxed profile constructs a digraph. No passive path can
evade an ideal's mask inclusions or create an unrecorded original
terminal. Unbounded passive vertices therefore do not invalidate
either argument.

## 5. Original reconstruction and the remaining gap

Each final two-color packing uses only original reserved units.
At each original q-tight terminal the reserved degree is two;
both colors must cover that terminal cut, hence take one unit
each and use all its reserved units. Every reserved unit touches
such a terminal, so the resulting pair partitions the entire
original reservation, without repeated original arcs in a color.
The other q-2 colors are unchanged. Actual B coverage plus reviewed
canonical dominance covers every exceptional original cut.

The proof never discards contacts or internal endpoints. Actual
tight-shore contractions are reversed with their fixed unit
labels by the reviewed all-cut gluing identity. Passive topology
was used throughout the ancestor/descendant argument, not replaced
by the positive support. This completes reconstruction **for this
rank-at-most-three pair theorem**, not for the universal mission.

At a positive global minimum the low-rank theorem would give a
strict descent whenever a bad/multiple-B pair had h<=3. Therefore
every such pair has h>=4. No theorem here rules out those larger
native non-polar quotients or supplies a compatible multicolor
descent through them. The original full-q reconstruction in
`full_color.md` remains conditional on eliminating the positive
minimum. Novelty and publishable significance remain unverified.

## Exact replay

The finite reconstruction input has 14 original vertices, ten
units and 37 retained topology arcs, including the zero-unit W.
Both original colors cover every ordinary ideal, while F initially
misses B. Six of eight component assignments give full two-dijoin
repairs, checked on all 203 original proper ideals and by strong
connectivity after arc reversal. The actual shore {X0,W} has two
boundary labels and quotient component counts 1 and 3, verifying
3=1+3-1 without deleting W. This is an auxiliary threshold-two
positive example, not a native q>=3 counterexample or a proof of
the universal theorem.

The sidecar rank operation corroborates the local crossing-cut
identity only. Its exact source-bound 4-by-4 incidence matrix has
rank three, independently recomputed with rational arithmetic.
The request, typed output and timeout/error receipt are retained
under `../../jacobian/q6_native_rank_*`.

```bash
python3 -B research/single_defect/terminal_support/marked_boundary/q6_shore_paths.py
python3 -B research/single_defect/terminal_support/marked_boundary/native_rank_three.py \
  --adapter-payload research/single_defect/jacobian/q6_native_rank_payload.json \
  --adapter-output research/single_defect/jacobian/q6_native_rank_output.json \
  --adapter-status research/single_defect/jacobian/q6_native_rank_status.json
python3 -B -m unittest discover \
  -s research/single_defect/terminal_support/marked_boundary \
  -p test_native_rank_three.py -q
```
