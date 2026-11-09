# Support-five pebbling on the original Lemke square

## Theorem and verification status

**Theorem.** For the fixed original Lemke graph L specified below, the
support-at-most-five pebbling number of `L box L` is exactly 64. Equivalently,
every nonnegative integer configuration of total size 64 supported on at
most five vertices reaches every root, and a support-one configuration of
size 63 fails to reach a specified root.

A configuration assigns a nonnegative integer count to each vertex; its
support is the set of vertices with positive counts. An ordinary pebbling
move removes two pebbles from a vertex and places one on an adjacent vertex.
Here the support-at-most-five pebbling number is the least size for which
every configuration with that support restriction reaches every root.

The structural proof and complete exact covering certificate below were
accepted by an independent Reviewer in Host-reviewed mission `15598b8f8c15`.
**The Host's final independent certification of this submission remains
pending.** That final gate is separate from the completed mathematical review.

The optimizer-free replay `final_cover_replay.json` checks all 181
root/heaviest-pile orbits, including all 723 relevant integer heavy counts
at distance five or six. This extends the located support-four boundary
for this fixed original square, not for every pair of Lemke graphs.
It does not prove Graham's unrestricted conjecture.

## Fixed graph and source baseline

Wood and Yerger, *Bilevel Programming for Pebbling Numbers of Lemke Graph
Products*, arXiv:2411.19314v1, Section 4.1 and Figure 1, identify their first
minimal graph as the original Lemke graph. Their cited implementation,
`get_lemke_graph(index=0)`, fixes its vertex set as `{1,...,8}` and edge set as

```
12 23 34 45 56 67 71 36 38 47 57 58 78
```

The implementation was read at the fixed revision
[`af7e35c4829a3b1cd78892152c9ba803b3003bd1`](https://github.com/KenanWood/Bilevel-Programming-for-Pebbling-Numbers/blob/af7e35c4829a3b1cd78892152c9ba803b3003bd1/pebbling_number_bilevel.py),
function `get_lemke_graph(index=0)`.
The unmodified source is `author_implementation.py`. The versioned primary
paper is archived as `wood-yerger-2411.19314v1.html`.

The paper's Theorem 1 reports the support-at-most-four bound 64 for all pairs
of eight-vertex Lemke graphs. Its definition of support-k explicitly includes
zero coordinates in a chosen k-element containing set. Section 1.2 and the
proof of Theorem 1 identify these graphs as Class 0, with pebbling number 8.
These are the prior baseline, not a proof of the support-five claim.

Section 5 explicitly warns that its CPLEX-based bilevel computations may be
prone to floating-point error and discusses exact verification as future
work. It also reports support-20 instances not terminating within 24 hours.
The present work neither imports those numerical outcomes as exact
certificates nor interprets a failed search as a nonexistence theorem.

## Elementary exact inequalities

For a root r and a vertex v at distance d, an r-unsolvable configuration
satisfies

```
C(v) <= 2^d - 1.
```

Indeed, 2^d pebbles at v alone can send one pebble along a shortest v-r path.
This inequality is necessary, not sufficient, for unsolvability.

More generally, for any gathering vertex u, unsolvability implies

```
sum_v floor(C(v) / 2^dist(v,u)) <= 2^dist(u,r) - 1.
```

To prove the contrapositive, partition each initial pile into disjoint
packets of size `2^dist(v,u)`, send each packet along a shortest path to u,
and then send the collected pebbles from u to r. Packets can be labelled
for this argument: using only the pebbles of the packet being transported
keeps every move legal even when paths overlap. Unused pebbles can only help.

These integer-sensitive inequalities will be tested as a necessary
relaxation; satisfying them does not certify unsolvability.

## A failed route, with an exact countermodel to the relaxation

Take root `(2,2)`, put 60 pebbles at `(5,5)`, and one at each of
`(4,5), (6,5), (5,4), (5,6)`. All 64 gathering inequalities above hold,
including their floors. Nevertheless this configuration is solvable:
send one pebble from `(5,5)` to each of `(4,5)` and `(6,5)`. Each now
holds two pebbles and sends one to `(3,5)`. Send the remaining 56 pebbles
at `(5,5)` in fourteen packets of four along
`(5,5)-(4,5)-(3,5)`. There are now sixteen pebbles at `(3,5)`;
the path `(3,5)-(2,5)-(2,4)-(2,3)-(2,2)` has length four and reaches
the root. The unused two initial pebbles are harmless.

This is a countermodel to a proposed necessary relaxation being sufficient,
not a counterexample to Graham's conjecture. `test_pebbling.py` checks all
64 inequalities and replays a legal solving sequence using integer counts.

## Fan discharge lemma

Let distinct vertices a and b have a nonempty common-neighbor set W.
Use only moves `a -> w -> b`, with w in W. Initially put x pebbles at a
and p(w) at each w. Put

```
k = floor(x/2),  o = #{w in W : p(w) is odd},  q = min(k,o).
```

The maximum number of *additional* pebbles deliverable to b by these moves is

```
F(x,p) = sum_w floor(p(w)/2) + q + floor((k-q)/2).
```

Proof. A move out of a supplies one of at most k arrivals to a child.
The first arrival to an initially odd child increases its contribution to b
by one. There are o such opportunities. Every other increase costs two
arrivals. Using these opportunities first and placing the remaining
arrivals at any one child attains the displayed value. For the upper bound,
if t of the odd-child opportunities are used, the gain is at most
`t + floor((k-t)/2)`, where `t <= min(k,o)`. This expression is
nondecreasing in t, giving the same bound. Initial pebbles elsewhere,
including b, are not used in this optimization.

If `k >= o`, an equivalent expression is

```
F(x,p) = floor((x + 2 sum_w p(w))/4).
```

In a configuration of size 64 with support at most five, a heaviest pile a
has `C(a) >= 13`. At most four other vertices are occupied, so `o <= 4`
for every fan centered at a, whereas `floor(C(a)/2) >= 6`. Thus **every**
such fan is in this saturated, parity-correcting regime, independent of
the placement and multiplicities of the other occupied vertices.

This is a structural, integer-sensitive simplification, not a proof of
the support-five theorem. The small exhaustive test of the formula is a
code check; the argument above supplies its unrestricted mathematical proof.

## Exact linear consequences and orbit coverage

Let `z(v)` be the actual support indicator. Its relaxation is allowed to be
any real number in `[0,1]`. An unsolvable size-64 configuration yields
nonnegative variables C,z satisfying

```
C(v) <= (2^dist(v,r)-1) z(v),       sum z(v) <= 5,
C(v) <= C(a),                      C(a) >= 13, z(a) = 1.
```

The gathering inequality has the following rational linear consequence:

```
sum_v C(v)/2^dist(v,u)
 - sum_v (1-1/2^dist(v,u)) z(v) <= 2^dist(u,r)-1.
```

Indeed, for positive integer n,
`floor(n/2^d) >= n/2^d - (1-1/2^d)`, and for n=0 the support
indicator removes the error term.

For any vertex b at distance two from a, let
`W=N(a) intersect N(b)` and `U=V minus ({a,b} union W)`. The fan lemma,
followed by gathering all other piles independently at b, gives

```
C(a)/4 + sum_{w in W} C(w)/2 + C(b)
 + sum_{v in U} C(v)/2^dist(v,b)
 - sum_{v in U} (1-1/2^dist(v,b)) z(v)
 <= 2^dist(b,r) - 1/4.
```

Here the sole error `3/4` for the fan follows from its saturated formula
and integer numerator; no per-child rounding errors remain. The packet
argument already given proves that transporting the other piles does not
invalidate the fan sequence. All initial pebbles belong to disjoint groups.

Every true unsolvable configuration satisfies this system. A feasible
point in the system need not be unsolvable.

Vertices 4,6,8 in L have identical open neighborhoods `{3,5,7}`.
Independently permuting these triples in the two coordinates and possibly
exchanging coordinates gives 72 explicit automorphisms. The code checks
every adjacency image, and checks that every root maps to a representative
`(i,j)` with `i,j in {1,2,3,4,5,7}` and i preceding j in this list.
This gives 21 representatives; claiming the *entire* automorphism group
is unnecessary.

For each representative root, the code takes representatives of possible
heaviest vertices under its stabilizer in these 72 maps. Only distance
at least four matters: a pile of at least 13 at distance at most three
already reaches the root. This gives 181 root/heaviest-pile orbits.
Zero coordinates are not excluded anywhere, so configurations of smaller
support are included.

`fan_bound.py generate fan_duals.json` uses floating point only to propose
nonnegative dual multipliers. The program converts them to rational
numbers and repairs any deficient coefficient with its explicit finite
upper-bound row. `fan_bound.py check fan_duals.json` uses only Python's
standard library and rational arithmetic: it reconstructs every row,
checks the graph and orbit coverage, verifies nonnegative multipliers and
coefficient domination, and recomputes every bound. A strict bound below
64 rules out that entire root/heaviest orbit, not just sampled
configurations. Any orbit whose bound is 64 or larger remains open.

The attempted full dual-generation run reached its configured 300-second
timeout without producing a final certificate. It establishes no coverage
of these 181 orbits. The timeout is not the reason for rejecting the
uniform route: the following exact countermodel is.

### Obstruction to the continuous cardinality relaxation

`relaxation_point.json` gives an exact nonnegative rational point for root
`(2,2)` and heaviest vertex `(5,5)`. It satisfies every displayed linear
constraint, **and also** the valid strengthening `z(v) <= C(v)`. Its total is

```
sum C(v) = 271589/4096 > 64,
sum z(v) = 4305/1024 < 5.
```

There are 31 positive C coordinates. In particular this is not a
support-five configuration and not a pebbling counterexample. It is an
exact obstruction to obtaining the requested strict bound from this
continuous relaxation, even with consistent indicators. Indicator
integrality or a genuinely stronger family of inequalities is necessary.
`relaxation_countermodel.py check relaxation_point.json` checks the point
without calling an optimizer.

### Obstruction even to the exact one-fan sufficient criterion

At root `(2,2)`, consider

```
C(1,5)=1, C(4,8)=1, C(5,5)=59, C(5,7)=2, C(8,6)=1.
```

This has total 64 and support five. It satisfies all 64 exact gathering
inequalities. Moreover, for every initially occupied center a with at
least two pebbles and every vertex b at distance two from a, even the
*optimal* single fan from a to b, combined with independent direct packets
from all other piles, delivers fewer than `2^dist(b,r)` pebbles at b.
An initially smaller center contributes no arrivals and is already
covered by gathering. Including all common neighbors in the fan is at
least as strong as using any subset: an omitted child's direct
contribution is just `floor(C(w)/2)`, which the full fan includes.

Nevertheless the configuration is solvable. The exact positive
certificate `multi_stage_solution.json` has 29 batches, totalling 54 legal
pebbling moves, and ends with a pebble at `(2,2)`. The discovery solver's
status is not used to certify this: direct replay checks adjacency,
available pebbles before every move, and the final root.

Consequently, neither relaxing support indicators nor replacing linear
floor bounds with exact floors makes **one** fan a universal criterion.
Nested discharging, intermediate redistribution, or another substantive
argument is needed. This is a limitation of a precisely specified
sufficient method, not a limitation of all weight certificates and not a
refutation of the support-five statement.

Run the combined independent replay from this campaign directory:

```
python3 research/support-five/check_obstructions.py
```

It uses only standard-library exact arithmetic and no optimizer. These
are certified method obstructions and positive examples, **not** a
publishable solution to the campaign. No novelty or significance verdict
is asserted for those earlier partial results. Independent Reviewer replay
confirmed the local lemma, both method obstructions, the orbit coverage, and
the three source readings. That checkpoint did not extend the support-four
boundary. The complete multistage certificate developed below supersedes
that limitation and has since passed independent mathematical review.

## Multistage prefix-resource templates

For a fixed ordered sequence of move batches, let `B_t(v)` be arrivals minus
twice departures at v after prefix t, with `B_0(v)=0`. Define

```
D(v) = max(0, max_t -B_t(v), 1_{v=r} - B_final(v)).
```

Then the sequence is legal and ends with a root pebble from an integer
configuration C **if and only if** `C(v) >= D(v)` for every v. Indeed, the
resource balance after each prefix is exactly `C(v)+B_t(v)`. In a batch
`v -> w` of n moves, nonnegativity after the batch at v is equivalent to
having at least 2n pebbles before it. This also guarantees legality of each
individual move in the batch. The last term is precisely the final root
requirement. Every coordinate of D is necessary, so the template is
coordinatewise minimal for this particular ordered sequence.

This accounts for **all** departures from shared sources, not separately
funded paths. Earlier arrivals are usable only at later prefixes. It is
therefore valid for arbitrary splitting and merging, including non-greedy
moves and shared intermediate vertices.

`multistage.py` extracts this demand from the reviewed move sequence.
`multistage_template.json` has the demand

```
D(1,5)=1, D(4,8)=1, D(5,5)=50, D(5,7)=2, D(8,6)=1.
```

Its total is 55. Consequently **every** integer configuration dominating
these five demands reaches `(2,2)`, with no restriction on extra pebbles or
extra support. In particular it covers the recorded 64-pebble witness.
This is a general resource-accounting criterion, not merely a replay
restricted to that one configuration. This first template alone is not a
universal family; the complete family and integral branch cover appear below.

An ordered positive trace can be pruned to the causal resources of one root
pebble. Work backwards from a demand of one at r. At a batch `v -> w` of
n moves retain `k=min(n, demand(w))`, reduce `demand(w)` by k, and increase
`demand(v)` by 2k. Reverse the retained batches at the end. This cannot
increase any initial resource demand. To see this, compare with the actual
states of the original legal trace: before a batch the tail has 2n more
pebbles than after it, and the head has n fewer. If the after-state covers
the current demand, the before-state covers the updated demand, because
`k<=n` and `demand(w)-k=max(0,demand(w)-n)`. Backward induction proves the
claim. `trim_to_root` verifies the resulting prefix demands exactly.

## Exact split-arm fiber discharge

For either diameter-three base root, the entire distance-decreasing
orientation of L is a split-arm graph. For root 2 its arms are
`5-7-1-2` and `5-{4,6,8}-3-2`; for root 5 these orientations are reversed.
The extra edges from 7 to `{4,6,8}` stay within a distance layer and are
not used in this lemma.

Write `p_i` for eight nonnegative integer initial counts and
`P=(p_4,p_6,p_8)`. Let `F(x,P)` be the exact fan value proved above,
including the initial contributions of the three children. The maximum
**total** number of root pebbles attainable using only distance-decreasing
base moves is

```
M_2(p) = p_2 + max_{0 <= k <= K} [
  floor((2*p_1+p_7+k)/4)
  + floor((p_3+F(2*(K-k),P))/2) ],  K=floor(p_5/2);

M_5(p) = p_5 + max_{0 <= k <= K} [
  floor((2*p_7+p_1+k)/4)
  + F(p_3+K-k,P) ],                K=floor(p_2/2).
```

For root 2, k of the K arrivals from vertex 5 go to 7, while the rest
are divided among the three twins. The left chain gives the first term;
the optimal twin fan followed by `3 -> 2` gives the second. For root 5,
k arrivals from vertex 2 go to 1 and the rest to 3, after which the right
arm is exactly the fan centered at 3. Every distance-decreasing move
belongs to these arms, and all K arrivals may be allocated because extra
arrivals never reduce delivery. The fan optimum is attained by correcting
odd children first. This proves both optimality and an explicit legal
construction, without an optimizer.

In the square, perform this extraction separately in all eight rows
toward the second root coordinate, then in the resulting root column
toward the first coordinate. This uses disjoint row resources in the
first stage and only the resulting column counts in the second. The
opposite coordinate order is also valid. A further variant first moves
whole packets from the heaviest pile to a vertex at distance one or two,
updates the actual configuration, and only then applies the two fiber
stages. This is a genuine multistage sufficient rule; it does not assert
that these fiber orders describe every solution.

`fiber_discharge.py` constructs and checks all batches. It corrects the
later bounded discovery miss at root `(2,2)` with 59 pebbles at `(5,5)`,
two at `(5,7)`, and one at each of `(7,4),(7,6),(7,8)`. In fact it yields
the stronger verified demand

```
D(5,5)=56, D(7,6)=D(7,8)=1.
```

Move 28 pebbles from `(5,5)` to `(7,5)`. The fan to `(7,3)` has 14
arrivals to allocate and two initially odd children, so it delivers
`2+floor((14-2)/2)=8`. These eight pebbles traverse the three-edge path
`(7,3)-(7,2)-(1,2)-(2,2)`. The exact pruned certificate is
`nested_fiber_solution.json`. The failed 10-second MILP discovery supplied
no conclusion; this explicit construction supplies the positive evidence.

## A structural reduction to heavy-pile distance five or six

**Lemma.** Every total-64 configuration supported on at most five vertices
whose heaviest pile is at distance at most four from the root is solvable.

**Proof.** Write a for a heaviest vertex. Its pile has at least 13 pebbles,
so distances at most three are immediate. At distance four a pile of at
least 16 also solves immediately; otherwise every pile is at most 15.

There must be at least three piles of size at least 12: if there were at
most two, padding smaller supports with zero counts would give the bound
`2*15 + 3*11 = 63`. The exact rational Farkas check of this counting step
is `jacobian/three-large-piles-output.json`, whose pairing is -1.

For every root/heaviest orbit at distance four, the fixed graph has the
following geometry: with at most one exception v distinct from a, the
two-pile configuration `13 e_a + 12 e_v` solves by gathering at a vertex u.
Equivalently, the supplied u satisfies

```
floor(13/2^dist(a,u)) + floor(12/2^dist(v,u)) >= 2^dist(u,r).
```

`distance_four_cover.json` supplies these u witnesses for all 148 relevant
orbits. `distance_four.py check` checks every displayed inequality and
verifies that the uncovered set has size at most one in each orbit. There
are 21 exceptions in total, never two for the same rooted pair.

There are at least two other occupied vertices with at least 12 pebbles,
so one is not exceptional. The actual configuration dominates the
corresponding solving pair. This proves the lemma. The argument includes
zero coordinates and smaller supports. Any heaviest pile may be chosen
when the maximum is tied; the orbit reduction does not assume uniqueness.

This is a counting-and-geometry reduction over whole configuration
families, not an enumeration of all pile assignments. By itself it leaves
33 of the 181 rooted-pair cases at distance five or six. The complete
cover below handles those cases. Independent review of the new lemma
and complete theorem was completed in mission `15598b8f8c15`.

## Integral sparse-cap discharge

The remaining route keeps the support decisions and pile sizes integral.
It never uses the relaxed z variables. The following cap lemma justifies
the exact branch bounds in `discharge_cover.py`.

Fix a root r, a heaviest vertex a, and its integer pile h, where
`13 <= h < 2^dist(a,r)`. Let S be a partial list of *entire initial piles*,
including `(a,h)`, and let `s=sum_{(v,n) in S} n`. These are not moves or
intermediate states. Write `T(u)=2^dist(u,r)` and

```
g(u) = sum_{(v,n) in S} floor(n/2^dist(v,u)).
```

In an unsolvable completion every unselected vertex v has the cap

```
C(v) <= (T(u)-g(u))*2^dist(v,u) - 1
```

for each u. This is just the exact gathering inequality with all other
unselected nonnegative contributions dropped. If `g(u)>=T(u)`, no
unsolvable completion exists.

The saturated fans centered at a give additional exact caps. For each
fan target b, put `W=N(a) intersect N(b)`, `U=V minus ({a,b} union W)`,
and

```
N = h + 2 sum_{w in W intersect S} C(w),
Q = C(b) 1_{b in S} + sum_{v in U intersect S} floor(C(v)/2^dist(v,b)).
```

The partial fan score is `floor(N/4)+Q`. It is attainable: h is at least
13 and at most four other initial piles are occupied, so every completion
is saturated. Fan transport and the independent outside packets use
disjoint initial resources, as in the fan lemma. Nonnegative extra piles
cannot invalidate this solution.

For an unselected v, the necessary caps from this fan are

```
v in W: C(v) <= floor((4*(T(b)-Q)-1-N)/2),
v = b:  C(v) <= T(b)-1-floor(N/4)-Q,
v in U: C(v) <= (T(b)-floor(N/4)-Q)*2^dist(v,b)-1.
```

They follow by adding only the pile at v to the partial score and
requiring the result to be at most `T(b)-1`. If the partial score already
reaches `T(b)`, every completion is solved.

Take the minimum of these caps, the single-stack cap `T(v)-1`, and the
current upper bound on the next largest pile. Call the resulting integer
cap `b(v)`. There are at most `m=5-|S|` unselected occupied vertices.
Consequently every unsolvable completion satisfies

```
total <= s + sum of the m largest nonnegative b(v).
```

A right-hand side below 64 is an exact bound of at most 63 over that
entire branch, regardless of which remaining vertices are occupied.
Zeros simply occupy none of the remaining slots.

A multistage template also gives a conditional cap. If all its positive
demands except the one at an unselected v are covered by S, unsolvability
forces `C(v)<=D(v)-1`. A template is ignored for this purpose if an already
selected pile is below its required demand: those selected counts are
fixed entire piles, not lower bounds that a future branch may increase.
This converts resource-accounted multistage solutions into exact discharge
inequalities as well as upward-closed solving families.

For the other branches, order the auxiliary piles by decreasing size,
breaking ties by increasing vertex index. No index restriction is put
between a and the first auxiliary pile, so a tied choice of the heaviest
pile is allowed. After selecting `(v_last,n_last)`, later indices below
`v_last` must have count at most `n_last-1`; other later counts are at
most `n_last`. These restrictions hold for every remaining pile in that
canonical order and therefore may also be used in the cap bound.

If a branch has not yet reached total 64, its next nonzero pile has
size at least `ceil((64-s)/m)`. The program branches over every vertex
and integer count between that lower bound and its cap, with the
additional safe lower bound obtained by putting the other `m-1` piles
at their largest caps. Every admissible unsolvable completion has exactly
one such next pile and hence survives into one child. When the prefix
already totals 64, there are no omitted positive piles.

At any prefix, a verified multistage demand D dominated by its selected
piles solves every completion. The program can use these upward-closed
families without inspecting any future piles. It also transports templates
by the explicitly checked automorphisms fixing r. All template demands
are recomputed from their **ordered** move sequences; no optimizer is
used by the checking mode.

Thus a completed replay for every integer h in all remaining rooted-pair
orbits proves universal coverage: each branch is either a valid
solving family, or an exact integer total bound at most 63, or is split
exhaustively. Positive-template discovery may use floating-point MILP,
but its output is accepted only after integer balance checks, cycle
removal, scheduling, and direct move replay. A solver miss, timeout, or
configured node limit leaves a branch open. No negative conclusion from a
numerical optimizer is used in the proof.

## Complete universal cover

The final certificate is `discharge_cover.json`. It contains 701 ordered
positive move templates: 228 have support three, 160 support four, and
313 support five. They are at the three diameter-six rooted pairs;
the other cases are resolved by the structural inequalities and rules.
The checker recomputes every prefix demand and legally replays every
template. The generation checkpoint's list of completed cases is **not**
trusted in checking mode: all expected cases are reconstructed and visited.

Here is the complete argument for an arbitrary configuration C in the
theorem. An occupied root is immediate. Otherwise choose any heaviest
pile a, so `C(a)>=13`. If it already has `2^dist(a,r)` pebbles, a shortest
path solves. Distances at most three are therefore immediate; distance
four is the three-large-piles lemma. Automorphisms move any remaining
root/heaviest pair into one of the 33 distance-five/six representatives,
without requiring a unique heaviest pile.

Suppose the remaining configuration were unsolvable. Its integer heavy
count is one of the 723 checked values. Its auxiliary occupied piles
have a unique decreasing-size/index order. At every prefix, all the
computed caps are necessary for unsolvability. If their total bound is
at most 63, they contradict the assumed total 64. If a positive template
or explicitly replayed structural rule applies, it contradicts
unsolvability directly. Otherwise the next-pile branching includes the
configuration's next occupied pile, as proved above. Exhaustive descent
therefore cannot discard an unsolvable configuration without a
contradiction.

The fresh exact replay visits 11,058 nodes: 9,848 are strict total-bound
leaves, 76 are explicitly solved structural families, and 1,134 are
exhaustive branch nodes. There are no uncovered leaves and no node-limit
outcome. Combined with all 148 distance-four orbits, it reports

```
checked_this_run = 723
root_heavy_orbits_covered = 181
uncovered = null
universal_support_five_coverage = true
```

This proves the upper bound. The proof includes smaller supports by
allowing unused support slots and includes tied maxima by choosing any
heaviest pile before ordering only the auxiliaries. All negative branch
bounds use integers; the positive evidence is legal move replay, not an
optimizer's success code.

The independently rerunnable command, using only Python's standard
library in checking mode, is

```
python3 research/support-five/discharge_cover.py check \
  research/support-five/discharge_cover.json --max-nodes 100000
```

`final_cover_replay.json` records its completed zero-exit replay. A
configured limit or any uncovered branch makes the checker exit nonzero.
The replay is an exact computational proof component, not independent
Reviewer acceptance or a Lean/kernel formalization.
The historical `independent_review_completed=false` field in that replay
records its production-time status. The subsequent independent review,
including its own fresh replay, is recorded in `roles/reviewer/progress.json`;
the original replay artifact has not been relabelled.

**Sharpness.** Put 63 pebbles at `(5,5)` and choose root `(2,2)`, at
distance six. The potential
`sum_v C(v)*2^(-dist(v,r))` starts at `63/64`. Every pebbling move has
nonpositive potential change, since adjacent vertices have root distances
differing by at most one. A root pebble would have potential at least one.
Thus this support-one configuration is unsolvable. Together with the
upper bound, the support-at-most-five pebbling number is exactly 64.
This is a 63-pebble lower-bound example, **not** a 64-pebble counterexample.

## Originality comparison and review provenance

A bounded independent primary-source comparison on 2026-11-03 found no
overlapping support-five-at-64 theorem. The inspected current arXiv
history for Wood--Yerger still lists only
[arXiv:2411.19314v1](https://arxiv.org/abs/2411.19314).
Its Theorem 1 and Section 1.3 concern support **at most four** for all
pairs of eight-vertex Lemke graphs. The present theorem increases that
support bound to five for the **fixed original square** only.

The strongest unrestricted numerical bound located was 85 in Kenter
and Skipper, [arXiv:1905.08683v1](https://arxiv.org/html/1905.08683v1),
Section 5.4 and Table 3. Footnote 1 explicitly warns that the bounds were
not verified with an exact rational IP solver. The table's bounds of
84 concern other minimal-Lemke products, not this original square.
Flocco--Pulaj--Yerger,
[arXiv:2312.12618v1](https://arxiv.org/html/2312.12618v1),
Theorem 4.2, gives the unrestricted bound 96 with verifiable
tree-strategy certificates. Neither result proves the support-five
threshold 64.

The comparison searched the Wood--Yerger title and publication status,
support-five terminology, and Lemke-square-at-64 results including
2025--2026. No later matching publication was located. The final
Kenter--Skipper--Wilson journal text at
[doi:10.1016/j.tcs.2019.09.050](https://doi.org/10.1016/j.tcs.2019.09.050)
was inaccessible (HTTP 403), so no claim is made about its final theorem
numbering or exact wording. Unindexed or inaccessible work remains
possible: this comparison is not an absolute originality guarantee.

The Host-reviewed handoff for mission `15598b8f8c15` records independent
acceptance of the sharp support-five theorem. Its Reviewer checked resource
legality, the structural reduction, branch completeness, statement fidelity,
and the bounded primary-source originality and publishable-significance
comparison. The fresh independent replay checked all 723 far heavy counts
and found no uncovered branch. These findings are retained in
`roles/reviewer/progress.json`, not inferred from an Engineer status flag.

The six independent supporting judgements in `research/MATH_STATE.json`
bind that review to `C3102-S5`, `C3102-ITERATED`, `C3102-DEMAND`, `C3102-D4`,
`C3102-CAPS`, and `C3102-FIBER`. The final submission reuses
`discharge_cover.json` and `final_cover_replay.json` without regeneration.
The edits for this submission clarify the statement, versioned references,
and review provenance; they do not change the mathematical claims, move
code, certificates, or inspected literature.

The final delivery obligation is a Host-invoked independent Reviewer verdict
on this submission and the Host's recognition of that verdict. The earlier
accepted review does not itself assert that this final gate has completed.
Support six and unrestricted Graham's conjecture remain unresolved.

### Versioned primary sources

| Source | Proposition used in the comparison |
|---|---|
| Wood--Yerger, [arXiv:2411.19314v1](https://arxiv.org/html/2411.19314v1) | Section 1.3 and Theorem 1: support at most four at 64; Section 4.1 and Figure 1: identification of the original graph; Section 4.2: pebbling number 8; Section 5: numerical limitations. |
| Kenter--Skipper, [arXiv:1905.08683v1](https://arxiv.org/html/1905.08683v1) | Section 5.4, Table 3, and footnote 1: unrestricted numerical bound 85 for the original square, without exact rational verification. |
| Flocco--Pulaj--Yerger, [arXiv:2312.12618v1](https://arxiv.org/html/2312.12618v1) | Theorem 4.2: unrestricted bound 96 with verifiable tree-strategy certificates. |

`reviewer_source_excerpts.txt` preserves the independently read passages for
the three Wood--Yerger assumptions. Their independent assumption judgements
are already in the ledger. The separate `citation_check` literature-tier
attributions remain outstanding: that command archives under
`research/literature/`, outside this mission's writable paths. The final
Reviewer/Host must resolve that archive requirement without replacing the
existing readings or weakening the cited propositions.

## Jacobian evidence and limitations

The authorized Argus adapter was used throughout. Discovery and inspected
contracts, exact payloads, outputs, process exit statuses, and stderr are
preserved under `jacobian/`. The responding server identifies itself as
Jacobian 0.14.0, using MCP protocol 2025-11-25.

The native general LP requests were rejected by their normalization and
simplex-basis admission limits; the compact standard-form request was
also rejected by the simplex-basis admission limit. These are structured
`INVALID_REQUEST` outcomes, not LP solutions, timeouts, or mathematical
obstructions. No certificate or conclusion is inferred from them.
The native distance-matrix operation completed on the fixed eight-vertex
graph. Its output is graph data only, not a pebbling proof.

For the new integral-discharge route, a fresh bounded discovery identified
`matrix.farkas_certificate.check`; its exact typed contract was inspected
before use. The six-row, five-variable counting certificate above returned
`valid=true`, `y^T A=0`, and `y^T b=-1`. The discovery, contract, exact JSON
payload, typed response, and stderr are preserved in `jacobian/`. All three
adapter commands exited zero; this certifies only the stated counting
obstruction, not the remaining support-five theorem.
