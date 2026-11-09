# Shared-source star packing: exact boundaries and parameter reduction

## Statement boundary

The goal is the following unconditional statement: every finite digraph whose full-topology condensation has
at most two missing source-sink pairs sharing a source, with nonnegative
integral capacities at least q on every original dicut, has q
capacity-feasible original dijoins, for every integer q >= 1.
Arrow reversal would give the common-sink case. The independently
accepted matching theorem would then complete the two-defect theorem.
Neither the binary star theorem nor publication qualification is assumed.

**New continuation:** Sections 12-14 give an unconditional proof using
unit-head contact erasure, followed by the reviewed all-q reduction.
These new sections await independent review. Earlier statements of the
remaining gap describe the scope of the earlier sections, not a premise
of the new proof. Originality and publishable significance remain separate
review questions.

All original arcs, including capacity-zero arcs, determine reachability
and original dicuts. A zero-length path counts. A dicut is the outgoing
boundary of a nonempty proper predecessor-closed shore. A packing member
is an original arc set; distinguished capacity units do not add resources.

The inherited inputs are the independently accepted one-defect theorem
and reconstruction (`native_trace_packing.md`, Sections 6-9; Host
`4bee83ab7629/round-0002.json`), the fixed-q normal form and reverse
reductions (`packing.md`, Sections 1-3), and the three actual star
boundaries (`compatibility.md`, Section 2). The accepted arbitrary-q
matching theorem is `donorless_full_unit.md`, Sections 2-5; Host
`b23636db2f6b/round-0001.json`. Those proofs are not reopened here.

The existing focused scope lookup found no verified primary two-defect
packing statement. This is not a novelty verdict. The retired
unrestricted-three-root-mark approach in `root_block_compatibility.md`,
Section 6, remains retired: three independently feasible marks need not
be simultaneously feasible. The unavailable Williams-Guenin source is
not used or reacquired.

## 1. Five disjoint bundles describe four actual boundaries

Work in a strict fixed-q normal form with missing pairs (s,t1),(s,t2).
Write S0 = S minus {s} and Treg = T minus {t1,t2}. Both are nonempty:
each exceptional sink has a source ancestor other than s, and s reaches
an original sink. Positive units have types source->sink, source->N,
or P->sink, with disjoint internal positive-head and positive-tail sets
N and P.

Partition P by its exceptional sink descendants:

    P1  = {P : P reaches t1 but not t2},
    P2  = {P : P reaches t2 but not t1},
    P12 = {P : P reaches both t1 and t2}.

Vertices reaching neither exceptional sink are in none of these sets.
Define the following five disjoint sets of actual original units:

    G  = {X->N : X in S0, N in Desc(s)}
         union {X->Y : X in S0, Y in Treg}
         union {P->Y : P in P12, Y in Treg};

    Li = {P->Y : P in Pi, Y in Treg},                    i=1,2;
    Mi = {X->ti : X in S0} union {P->ti : P in P12},     i=1,2.

These need not exhaust the positive units.

**Four-boundary lemma.** There are actual original ideals with positive
unit boundaries

    C0  = G union M1 union M2,
    C1  = G union L1 union M2,
    C2  = G union L2 union M1,
    C12 = G union L1 union L2.                           (1)

C0 is ordinary. Ci is the canonical boundary for the exceptional
pattern with only ti included, and C12 is the canonical boundary for
both exceptional sinks included. For every selected unit set F, the
minimum in each exceptional family is exactly |F intersect Ci| or
|F intersect C12|. In particular the three exceptional boundaries have
full capacity at least q+1 in a strict form.

**Proof.** Put

    K = S0 union Anc(N minus Desc(s)).

This is an original ideal, contains no sink, and excludes s. No active
P is in K. Otherwise P would precede an active N not in Desc(s);
some positive input X->N would have X != s, contradicting the
normal-form contact restriction.

For nonempty B subset {t1,t2}, the canonical ideal supplied by the
accepted star projection can therefore be written

    U_B = K union Anc(B).

Every active N outside Desc(s) is included and every active N inside
Desc(s) is excluded, independently of B. The positive internal tails
included are precisely those reaching a sink of B. Counting the three
positive unit types gives C1,C2,C12 in (1). A P1 tail cannot have an
arc to t2, and a P2 tail cannot have an arc to t1; this uses the full
topology, not positive support.

The ideal

    U0 = K union (Anc(t1) intersect Anc(t2))

contains no sink and excludes s. Its included active tails are exactly
P12 and its included active heads are again N minus Desc(s). Its
positive boundary is C0. It is nonempty and proper since S0 is nonempty
and s is excluded. Canonical dominance proves the minimum assertions.
Each U_B contains a source in S0 and an exceptional sink; its complement
contains s and a sink reached by s in Treg. These cuts are nonterminal,
so strictness gives capacity at least q+1. QED.

For an ordinary color F, the simultaneous exceptional demands have a
particularly short exact form:

    F meets all three families
      iff F meets G
           or (F meets L1 and M1)
           or (F meets L2 and M2).                      (2)

Indeed ordinary coverage includes C0. After removing G, the four
demands in (1) are the four possible pairs between {L1,M1} and
{L2,M2}. Meeting all four requires both members of one of these
two pairs. This is a statement about these actual original boundaries,
not an assertion about three unrestricted marks.

## 2. A donor exists whenever some failure is single-sided

Fill only (s,t1) with a zero-capacity arrow and use the accepted
one-defect theorem. In a strict q-normal form it produces an actual
unit q-partition meeting every ordinary cut and every C2-family cut.
Every q-tight original terminal is saturated, and every positive unit
touches such a terminal, so every original unit is assigned once.
The new arrow has no selectable unit.

For color a put

    d_a = |F_a intersect (G union L1)|,
    l_a = |F_a intersect L2|,
    m_a = |F_a intersect M2|,
    w_a = d_a+l_a,       z_a = d_a+m_a.

w_a and z_a are the actual C12 and C1 counts. A color is bad precisely
when min(w_a,z_a)=0, since all its other original cuts are already
covered. For every palette X, its exact minimum on the two still-needed
families is

    d(X) + min(l(X),m(X)) = min(w(X),z(X)).              (3)

Its minimum on every ordinary cut and every C2-family cut is at least
|X|. Thus a pair containing a bad color is an actual minimum-two
reservation exactly when both its w and z sums are at least two.
Full strict slack gives

    sum_a w_a >= q+1,       sum_a z_a >= q+1.            (4)

**Single-sided donor lemma.** If some bad color has exactly one of its
w,z counts zero, an actual minimum-two pair containing a bad color
exists.

**Proof.** By symmetry suppose w_F=0 and z_F>=1. Equation (4) supplies
G with w_G>=2. If z_F>=2 or z_G>=1, the pair F,G works. Otherwise
z_F=1 and z_G=0. Equation (4) supplies H with z_H>=2, and the pair
G,H works, since w_G>=2. G is bad in this last case. These sums are
actual original cut counts, not independently minimized recolorings.
QED.

## 3. Double-zero failure has a proper actual reservation

Suppose there is a bad color F but no actual minimum-two pair
containing any bad color. Section 2 implies every bad color is
double-zero. In particular

    d_F=l_F=m_F=0.

The absence of a donor for F gives

    d_a + min(l_a,m_a) <= 1                              (5)

for every color. Thus each d_a is zero or one; a count-one color
cannot have both l_a>0 and m_a>0.

The original sink t2 is q-tight. To see this, F must meet its ordinary
terminal cut, but it has no M2 unit. Its selected unit into t2 is
therefore P->t2 with P in P2, an internal positive incidence. Such a
unit touches a q-tight terminal only at t2. Consequently

    m_a <= 1                                            (6)

for every old color.

Choose any maximum pairing of distinguished L2 units with distinguished
M2 units; all pairs are allowed for this counting argument. There are
min(l(full),m(full)) pairs. Direct each pair from its L2 unit's color to
its M2 unit's color, obtaining a directed color graph J. This pairing
is not an original contact or an endpoint exchange.

By (6), every vertex has indegree at most one; outdegree is unrestricted.
F is isolated. A vertex with d_a=1 cannot lie on a directed cycle, by
(5). Every weak component is an outward directed tree or a directed
cycle with outward trees attached. For an induced palette X,

    min(w(X),z(X)) >= sum_(a in X) d_a + |E(J[X])|.      (7)

This follows because every retained pairing uses two distinct units
both in X. For the full palette (7) is an equality, so (4) gives

    sum_a d_a + |E(J)| >= q+1.                          (8)

**Proper-reservation lemma.** There is a palette X containing F with

    3 <= r=|X| < q,

whose reserved original capacity has minimum at least r on every
original dicut, without any change to the original topology.

**Proof.** Mark the vertices with d_a=1. A tree component Q has

    |E(Q)| + number of marks - |Q| = number of marks - 1;

a unicyclic component has excess equal to its number of marks.
The isolated F component has excess -1. Equation (8) implies the
sum of all component excesses is at least one, so some component
other than F has positive excess.

If it is a tree, choose a closest pair of marked vertices and let I
be their inclusive undirected path. It has exactly two marks and
|I|-1 pairing edges. For X=I union {F}, (7) is at least

    2+(|I|-1)=|X|.

If X were the full palette, J would be just this path and isolated F,
with two marks and q-2 edges. That would make (8)'s left side q,
a contradiction.

If it is unicyclic, choose a marked vertex u and the path from its
cycle to u. No marked vertex lies on the cycle. Nor can one be an
interior vertex of this outward path: such a vertex has both a paired
incoming M2 unit and a paired outgoing L2 unit, contrary to (5).
Let I consist of the cycle and this path. It has exactly one mark
and |I| pairing edges. For X=I union {F}, (7) is again at least
|X|. If X were full, J would consist of I and isolated F, with one
mark and q-1 edges, again contradicting (8).

In each case I has at least two vertices, X contains F, and X is
proper. Its original ordinary and C2-family counts are at least r
by summing the old actual color counts. Equation (7), together with
canonical dominance, gives the same lower bound in the C1 and C12
families. These exhaust all original dicuts. No arc, unit occurrence,
or zero-capacity topology has changed. QED.

In particular a donorless double-zero configuration cannot occur at
q=3: the lemma would require 3<=r<3. This is not a proof of q=2.

## 4. The full all-q star statement reduces to ambient threshold two

**Parameter-reduction theorem.** The following two statements are
equivalent:

1. Every full-topology common-source two-defect digraph with integral
   original dicut capacities at least two has two capacity-feasible
   original dijoins.
2. The same unrestricted class has q capacity-feasible original
   dijoins whenever its original integral dicut capacities are at
   least q, for every integer q>=1.

This is an unconditional implication theorem, not a proof that either
packing statement holds.

**Proof.** The all-q statement contains the threshold-two statement.
For the converse, denote the claimed packing statement at parameter q
by H(q). H(1) follows from the positive original support; a no-dicut
input has q empty members. Assume H(2), and use strong induction for
q>=3.

The common-source star class is closed under the required
vertex-identification quotients followed by strong-component
contraction. Choose an original source in every quotient source
preimage and an original sink in every quotient sink preimage. A missing
quotient pair gives a missing original pair between these representatives,
since original paths project to quotient walks. Distinct quotient
sources have disjoint preimages, so two missing quotient pairs must
share the quotient source whose representative is s. There are at
most two such pairs. Every quotient dicut is its original preimage
dicut. This proves closure within the common-source class, without
assuming the common-sink or matching theorem.

If H(q) failed, choose a failure with fewest condensation vertices and
then least total integral capacity in this class. The inherited
one-defect theorem and reviewed reverse reductions give a strict
q-normal form with exactly the two stated missing pairs. The closure
just proved legitimizes tight-cut gluing and the large-capacity-arc
quotients within this class. Use Section 2's one-defect completion
partition.

If an actual minimum-two pair containing a bad color exists, keep the
full original topology, give each original arc its reserved occurrence
count as capacity, and apply H(2). Replace those two colors by the
two resulting original dijoins.

Otherwise Section 3 supplies an actual minimum-r palette X containing
a bad color, with r<q. On the unchanged original topology give each
arc its number of reserved units as capacity. This is an ambient
common-source star input, even if its positive support and tight cuts
are not a strict r-normal form. H(r) supplies r original dijoins.
Replace the palette by these r colors.

For either replacement, distinguish the reserved original unit
occurrences before assigning colors. Each original q-tight terminal
has exactly r reserved units (r=2 for a pair). Each of the r new
colors meets that terminal cut, so all these units are used, exactly
one per color. Every reserved unit touches an original q-tight
terminal, so the entire reservation is exhausted once. No arc is
duplicated within a color and no original capacity is increased.
All outside colors and units remain unchanged.

Every new reserved color meets every original dicut. The number of
bad colors therefore strictly decreases, with no new bad color.
It is initially at most q, so at most q replacements close the strict
form. Every recursive palette parameter is genuinely smaller than q;
the fixed-q quotient and capacity reductions have their own strictly
decreasing measures. No call uses H(q) on the full palette.

The reviewed reverse tight gluing, capacity-unit path expansions and
strong-component expansion restore original arc sets without adding
capacity. This contradicts the minimal failure and proves H(q).
Strong induction proves the implication. QED.

The accepted matching proof used a partial-injective color graph.
The new star reduction permits branching outdegree and uses a
tree-path or cycle-with-branch palette. It controls two actual linear
star demands at once, and proves the lower bound on every original
reserved dicut, not just an abstract mark score.

## 5. Exact remaining gap

The ambient threshold-two shared-source theorem remains unproved.
Sections 1-4 do not supply a binary coloring that simultaneously covers
ordinary cuts and all three exceptional families with assigned-color
original endpoint expansions. In particular, the arbitrary pairing
in Section 3 certifies reserved cut counts only; its edges are not
contacts and do not license an original-unit rotation.

The original six-label three-mark obstruction is still not a native
star counterexample. Even the four-boundary incidence identity
C1+C2=C0+C12, by itself, occurs in that retired abstract obstruction:
take G={a}, L1={b'}, L2={c'}, M1={b}, M2={c}. A proof must additionally
use actual endpoint types, original footprints and valid expansions.
This observation preserves the earlier retirement, rather than
reopening the unrestricted-mark route.

The first independent Host star review, recorded on 2026-11-05 at
05:53:54Z by reviewer:copilot-star-packing-certify, supports Sections 1-4
and their exact diagnostics. It accepts the implication theorem, not the
unrestricted binary or all-q packing conclusion. No all-unit
counterexample is produced, and originality and publication significance
remain unverified. The campaign and full-packing milestone remain open.
The later binary continuation in Sections 7-9 has not yet received
independent review.

## 6. Read-only exact diagnostics and their limited scope

The following two standard-library replays are self-contained. They write
no files and use no solver. Their role is to test the new reduction and
provide explicit native illustrations, not to prove the ambient binary
star theorem by a finite miss.

The first exhausts all partial incoming maps on colors 1,...,q-1, with
color zero isolated, and all zero-one core marks, through q=6. It checks
7,209 eligible proper-reservation obligations: 6 at q=4, 228 at q=5,
and 6,975 at q=6. Of these, 6,957 have branching outdegree. Its selected
tree/unicyclic counts are respectively (3,3), (104,124), (3034,3941).
There are no eligible q=2 or q=3 obligations. These are bounded abstract
checks, not native packing instances or a universal proof.

```python
from collections import Counter, deque
from itertools import product

def reserve(n, edges, marks):
    adjacency = [set() for _ in range(n)]
    for a, b in edges:
        adjacency[a].add(b)
        adjacency[b].add(a)
    seen = {0}
    for start in range(1, n):
        if start in seen:
            continue
        component = {start}
        queue = [start]
        seen.add(start)
        for a in queue:
            for b in adjacency[a]:
                if b not in seen:
                    seen.add(b)
                    component.add(b)
                    queue.append(b)
        inside = [(a, b) for a, b in edges if a in component]
        selected = component & marks
        if len(inside) + len(selected) <= len(component):
            continue
        if len(inside) == len(component) - 1:
            best = None
            for u in selected:
                paths = {u: [u]}
                work = deque([u])
                while work:
                    a = work.popleft()
                    for b in adjacency[a]:
                        if b in paths:
                            continue
                        paths[b] = paths[a] + [b]
                        work.append(b)
                        if b in selected and (
                            best is None or len(paths[b]) < len(best)
                        ):
                            best = paths[b]
            assert best is not None
            return set(best) | {0}, "tree"
        assert len(inside) == len(component)
        parent = {b: a for a, b in inside}
        a = next(iter(component))
        trail = []
        index = {}
        while a not in index:
            index[a] = len(trail)
            trail.append(a)
            a = parent[a]
        cycle = set(trail[index[a]:])
        assert not cycle & marks
        u = next(iter(selected))
        path = {u}
        a = u
        while a not in cycle:
            a = parent[a]
            path.add(a)
        return cycle | path | {0}, "unicyclic"
    raise AssertionError("missing positive-excess component")

counts = Counter()
for n in range(2, 7):
    for parents in product(range(n), repeat=n-1):
        edges = [(a, b) for b, a in enumerate(parents, 1) if a]
        incoming = {b for a, b in edges}
        outgoing = {a for a, b in edges}
        for bits in range(1 << (n-1)):
            marks = {a for a in range(1, n) if bits >> (a-1) & 1}
            if marks & incoming & outgoing or len(marks)+len(edges) < n+1:
                continue
            X, kind = reserve(n, edges, marks)
            score = len(X & marks) + sum(
                a in X and b in X for a, b in edges
            )
            assert 0 in X and 3 <= len(X) < n and score >= len(X)
            counts[n, kind] += 1
            if any(sum(a == v for a, b in edges) > 1 for v in range(n)):
                counts[n, "branching"] += 1
assert sum(v for (n, k), v in counts.items() if k != "branching") == 7209
print(dict(sorted(counts.items())))
```

The second constructs three capacity inputs with explicit packings:
a contact-free 17-vertex q=2 star and a 19-vertex active-contact star
at q=2 and q=4. All five boundary bundles are present. The latter inputs
also have positive source-to-internal core units, internal M1,M2 units,
and the retained zero-capacity contact 18->17.

The 17-vertex input has 78 topology arcs, 14 positive units, 340 original
ideals, minimum two and nonterminal minimum three. Its bundle sizes
(G,L1,L2,M1,M2) are (2,1,1,2,2), and boundary sizes
(C0,C1,C2,C12) are (6,5,5,4). The exact pairing criterion agrees on
all 1,622 ordinary subsets among all 16,384 unit subsets. Its reversed
input has the same 340 original ideals and a reversed original packing.

The 19-vertex topology has 87 arcs and 617 original ideals. The q=2
and q=4 inputs have respectively 15 and 29 distinguished positive
units, minimum 2 and 4, and nonterminal minimum 3 and 6. Their four
boundary sizes are (7,7,6,6) and (14,13,12,11). Every original color
meets every original cut and respects its original capacity. All
capacity-zero topology remains present. These are weighted native
packing illustrations, not all-arcs-unit-capacity counterexamples.

```python
from collections import Counter

def build(contact, copies):
    S, T = set(range(5)), set(range(5, 10))
    edges = {(x, y) for x in S for y in T
             if (x, y) not in {(0, 5), (0, 6)}}
    for p, desc in ((10, {5, 8}), (11, {6, 9}), (12, {5, 6, 7})):
        edges.update((x, p) for x in S - {0})
        edges.update((p, y) for y in desc)
    for v in range(13, 17):
        desc = T - {5, 6} if contact and v == 13 else T
        edges.update((x, v) for x in S - {0})
        edges.update((v, y) for y in desc)
    units = [(x, 5+(x+j) % 5) for x in range(5) for j in (2, 3)]
    changes = (
        ((1, 8), ((1, 13), (10, 8))),
        ((2, 9), ((2, 14), (11, 9))),
        ((3, 5), ((3, 15), (12, 5))),
        ((4, 6), ((4, 16), (12, 6))),
    )
    for old, new in changes:
        units.remove(old)
        units.extend(new)
    A = {(0, 8), (2, 5), (3, 6), (4, 7), (1, 13), (11, 9)}
    labeled = [(edge, 2*k+int(edge not in A))
               for k in range(copies) for edge in units]
    if contact:
        edges.add((0, 13))
        edges.update((x, 18) for x in S - {0})
        edges.update({(0, 17), (18, 17), (18, 5),
                      (17, 7), (17, 8), (17, 9)})
        for edge in ((0, 8), (2, 5)):
            labeled.remove((edge, 0))
        labeled.extend((edge, 0) for edge in ((0, 17), (18, 5), (2, 8)))
    return (19 if contact else 17), edges, labeled

for contact, copies in ((False, 1), (True, 1), (True, 2)):
    n, edges, labeled = build(contact, copies)
    q, full = 2*copies, (1 << n)-1
    S, T = set(range(5)), set(range(5, 10))
    units = [edge for edge, color in labeled]
    assert all(edge in edges for edge in units)
    assert max(Counter(units).values()) < q
    assert all(sum(u == x for u, v in units) == q for x in S)
    assert all(sum(v == y for u, v in units) == q for y in T)
    reach, pred = [1 << v for v in range(n)], [0]*n
    for u, v in edges:
        reach[u] |= 1 << v
        pred[v] |= 1 << u
    for v in range(n):
        for u in range(n):
            if reach[u] >> v & 1:
                reach[u] |= reach[v]
    anc = [sum(1 << u for u in range(n) if reach[u] >> v & 1)
           for v in range(n)]
    assert {(x, y) for x in S for y in T
            if not reach[x] >> y & 1} == {(0, 5), (0, 6)}
    N = {v for u, v in units if v not in T}
    P = {u for u, v in units if u not in S}
    assert N.isdisjoint(P)
    contacts = [(p, v) for p in sorted(P) for v in sorted(N)
                if reach[p] >> v & 1]
    assert contacts == ([(18, 17)] if contact else [])
    G, L, M = set(), {1: set(), 2: set()}, {1: set(), 2: set()}
    for i, (u, v) in enumerate(units):
        kind = {j for j, t in ((1, 5), (2, 6))
                if u in P and reach[u] >> t & 1}
        if ((u in S-{0} and v in N and reach[0] >> v & 1)
            or (u in S-{0} and v in T-{5, 6})
            or (kind == {1, 2} and v in T-{5, 6})):
            G.add(i)
        for j, t in ((1, 5), (2, 6)):
            if kind == {j} and v in T-{5, 6}:
                L[j].add(i)
            if v == t and (u in S-{0} or kind == {1, 2}):
                M[j].add(i)
    bundles = (G, L[1], L[2], M[1], M[2])
    assert sum(map(len, bundles)) == len(set.union(*bundles))
    cores = {0: G|M[1]|M[2], 1: G|L[1]|M[2],
             2: G|L[2]|M[1], 3: G|L[1]|L[2]}
    K = sum(1 << x for x in S-{0})
    for v in N:
        if not reach[0] >> v & 1:
            K |= anc[v]
    shores = {0: K|(anc[5]&anc[6]), 1: K|anc[5],
              2: K|anc[6], 3: K|anc[5]|anc[6]}
    terminal = {1 << x for x in S} | {full^(1 << y) for y in T}
    rows, ordinary = {}, set()
    minimum, nonterminal = len(units)+1, len(units)+1
    for U in range(1, full):
        if any(U >> v & 1 and pred[v] & ~U for v in range(n)):
            continue
        row = {i for i, (u, v) in enumerate(units)
               if U >> u & 1 and not U >> v & 1}
        rows[U] = row
        minimum = min(minimum, len(row))
        if U not in terminal:
            nonterminal = min(nonterminal, len(row))
        assert {labeled[i][1] for i in row} == set(range(q))
        Aout = {x for x in S if not U >> x & 1}
        Bin = {y for y in T if U >> y & 1}
        if Aout and Bin:
            assert Aout == {0} and Bin <= {5, 6}
            key = int(5 in Bin)+2*int(6 in Bin)
            assert cores[key] <= row
        else:
            ordinary.add(sum(1 << i for i in row))
    assert all(rows[U] == cores[key] for key, U in shores.items())
    assert minimum == q and nonterminal >= q+1
    expected = ((340, 3, (6, 5, 5, 4)) if not contact else
                (617, 3, (7, 7, 6, 6)) if copies == 1 else
                (617, 6, (14, 13, 12, 11)))
    assert (len(rows), nonterminal, tuple(map(len, cores.values()))) == expected
    if not contact:
        masks = [sum(1 << i for i in B) for B in bundles]
        core_masks = {k: sum(1 << i for i in B) for k, B in cores.items()}
        admitted = 0
        for F in range(1 << len(units)):
            if not all(F & row for row in ordinary):
                continue
            admitted += 1
            exact = all(F & core_masks[k] for k in (1, 2, 3))
            paired = bool(F&masks[0] or (F&masks[1] and F&masks[3])
                          or (F&masks[2] and F&masks[4]))
            assert exact == paired
        assert admitted == 1622
        rev_pred = [0]*n
        for u, v in edges:
            rev_pred[u] |= 1 << v
        reverse_count = 0
        for U in range(1, full):
            if any(U >> v & 1 and rev_pred[v] & ~U for v in range(n)):
                continue
            reverse_count += 1
            row = {i for i, (u, v) in enumerate(units)
                   if U >> v & 1 and not U >> u & 1}
            assert row == rows[full^U]
            assert {labeled[i][1] for i in row} == set(range(q))
        assert reverse_count == 340
    print(n, q, len(edges), len(units), len(rows), minimum, nonterminal,
          tuple(map(len, cores.values())))
```

The discovery and inspection of Jacobian 0.14.0, protocol 2025-11-25,
confirmed the adapter is responsive. The inspected discrepancy evaluation
operation supplies only a finite signed-set computation, not this
universal implication. No Jacobian operation was executed: this mission's
explicit writable set provides no dedicated payload/result JSON paths,
and no ledger or public-status file was substituted for a typed payload.
No sidecar result is a dependency of Sections 1-4 or these exact replays.

## 7. Native binary anchors, not three abstract marks

This continuation uses the independently reviewed Sections 1-4 without
replaying their unchanged certificates. The ambient binary theorem is
still open. The new results below restrict its possible counterexamples
and exclude a particular native guard construction.

Write H = D + reverse(F), where F meets every original ordinary dicut.
Add both missing arrows to obtain H+. Its full topology is strongly
connected: an ideal of the completed original topology is ordinary,
and a source component of H+ would be an unmet such cut. Added arrows
have no selectable capacity.

**Star anchor lemma.** If F misses an original exceptional shore:

1. For a singleton pattern i, F has an actual direct unit X->ti with
   X an original source.
2. For a joint pattern, F has an actual direct unit s->Y and an actual
   direct unit X->ti for at least one i in {1,2}.
3. For a singleton pattern i, either F has a direct unit at s, or
   F contains a same-color original contact pair s->N and P->tj,
   where j != i and P reaches tj but not ti.

In particular, in a contact-free normal form **every** ordinary color
missing any exceptional family has a direct selected unit at s.
No assertion about an unrestricted three-mark extension is used.

**Proof.** Let U be a missed original ideal and W its complement.
H has no arrow from W to U: an original such arrow violates ideality,
and a reversed F arrow would be an outgoing F unit of U.

For a singleton pattern, a simple path in H+ from ti to an original
source X in S0 stays in U. It cannot leave and return except through
the added s->ti arrow, which would repeat its initial vertex. Consider
its first original source. Unless the preceding selected reversal is a
direct X->ti unit, it reverses X->N with N internal. Its last preceding
selected reversal enters an internal positive tail P from the only
original sink ti inside U. The intervening original forward segment
gives P reaching N with active input X != s. This is forbidden by
the star contact restriction. There must be a preceding reversal,
because an original sink has no original forward exit. This proves 1.

For the joint pattern, take a path in H+ from either included sink to
any source in S0. After its last added arrow s->ti, the remaining
segment lies in H[U]; if there was no added arrow the same conclusion
holds. Thus some included sink reaches a source in H[U]. The same
first-source argument, now allowing either included sink as the last
sink, supplies a direct selected source-to-exceptional-sink unit.

For the source-side assertion, take a simple path in H+ from an
original sink in W to s. No added arrow can occur: all have tail s,
the final vertex of the simple path. The path is in H[W]. Its first
original source is s, since W contains no other original source.
If the entering selected reversal is not direct, it reverses s->N
with N internal. Its last preceding selected reversal enters an
internal positive P from a selected P->Y unit, with Y an original
sink in W. The intervening forward segment is an actual contact
P reaching N. The contact restriction requires Y to be an excluded
exceptional sink. There is no such sink in a joint-pattern complement,
proving the direct s unit in 2. For a singleton complement Y must
be tj. Moreover P is outside U and hence cannot reach the included
ti, which would force it into U. This proves 3 and its contact-free
consequence. All units mentioned belong to the one selected F. QED.

**Protected-component consequence.** If F is ordinary but not an original
dijoin, H has exactly one source strong component and exactly one sink
strong component. Each source component is an original ideal avoiding F,
so it contains every source in S0 by the exceptional classification.
S0 is nonempty, so two disjoint source components are impossible.
The complement of a sink component is such an ideal, so every sink
component contains s; again there is only one. This is a native
strong-component statement, not a packing theorem.

## 8. Sharper threshold-two frontier

### 8.1 There is at most one bad color in the one-defect partition

Use Section 2's ordinary/C2 partition at q=2. With its notation,
both colors cover every ordinary cut and C2, and

    w_full >= 3,       z_full >= 3.

**Unique-bad-color lemma.** At most one color is bad on C1 or C12.
If that color is double-zero, at least two actual units of
G union L1 are in the other color.

**Proof.** If both colors were bad, one would have w=0 and the other
z=0, because neither full sum is zero. This gives d_full=0.
The z-zero color has no M2 unit, yet meets the original terminal cut
of t2. Its selected incoming unit is P->t2 with P in P2, an internal
incidence. Hence t2 is two-tight. Both colors are terminal-saturated,
so each has at most one M2 unit. But the full z value is now
m_full, at most two, contrary to z_full>=3.

If F is double-zero, the same tightness argument gives m_G<=1 in
the other color. Since z_full=d_G+m_G>=3, d_G>=2. These are actual
G union L1 units, not a freely chosen abstract marked palette. QED.

### 8.2 One safe source witness excludes a large contact-free branch

The ordinary colored-root extension, pair-relation lemma and binary
closed-block characterization used here are the independently accepted
`native_trace_packing.md`, Sections 6-7. In particular, virtualization
cannot lower an uncolored ordinary minimum, binary closed blocks are
original two-tight terminal pairs, and roots in distinct binary
components can be assigned either equality or opposition.

Define the source-expandable part of the joint core by

    Z = {X->N : X in S0, N in Desc(s)}
         union {X->Y : X in S0, Y in Treg}.

Thus Z omits the internal-tail part of G.

**Safe-source theorem.** A contact-free strict threshold-two star form
has a full original-unit two-packing if either s has no positive
direct unit, or |Z|>=2. Internal positive incidence at s, t1 and t2
is otherwise unrestricted.

**Proof.** If s has no positive direct unit, the ordinary partition
from passive completion has no bad color, by Section 7.

Suppose |Z|>=2 and first assume all units at s are direct. Make at
most two chosen internal Z units source-only virtual roots; all
other internal units stay ordinary internal units. Direct Z units
are already shared root labels. The modified root system has ordinary
minimum at least two. Its binary components are subchains of the
actual original terminal-pair graph.

The only root labels in this system crossing the actual joint shore
are direct Z units and the chosen virtual Z units. Indeed the other
joint boundary units have internal tails and were not virtualized.
Crossings of an actual ideal along a binary chain alternate parity.
If two of these Z root labels share a binary component with opposite
parity, they already have both colors. If there is no such pair,
there is at most one Z crossing per component, so two of the labels
are in distinct components. The pair-relation lemma can assign them
opposite colors in one valid root coloring.

Extend the colored roots to both ordinary colors. The source s is a
singleton closed block with its actual direct roots in both colors.
Each virtual X->N therefore expands in its own assigned color through
its allowed endpoint s and a real direct root of that color. Both
colors contain an actual Z unit, hence meet G and all three exceptional
families. No other unit was made virtual.

Now suppose s has an internal positive unit. It is two-tight. If it
has no direct unit the first case applies; otherwise its two original
units are one internal unit and a direct unit alpha. If an ordinary
partition is already full there is nothing to do. Otherwise its bad
color contains alpha by Section 7 and avoids all of Z, since G is in
every exceptional boundary.

Join original unit pairs at original two-tight terminals, obtaining
the actual terminal-pair graph. Its components are paths and even
cycles, with alternating colors. In a monochromatic original cut
there is at most one crossing per such component. The missed
exceptional cut is monochromatic in the other color and contains Z.
Since |Z|>=2, some e in Z is outside alpha's component.

If e is internal, make only e a source-only virtual root. Binary
closed blocks remain original tight-terminal pairs, so e and alpha
are still in distinct binary root components. If e is direct, no
virtualization is needed. The pair-relation lemma gives one valid
root coloring with e and alpha equal. Extend both ordinary colors.
When e is virtual, expand it through the actual direct alpha in its
assigned color, at the allowed original endpoint s.

That color meets actual G and hence every exceptional family. The
other color uses the original internal unit at the saturated source s,
and has no direct unit at s. It cannot be exceptionally bad, by the
contact-free conclusion of Section 7. Both are ordinary by the
extension and the proved single expansion. Every original unit remains
assigned once. This proves the theorem. QED.

Consequently a remaining contact-free strict binary failure must have
some positive direct unit at s and |Z|<=1. The result is not the
unrestricted binary star theorem: it does not handle that small-Z
branch or active contacts.

### 8.3 A minimal binary failure also has forest positive support

**Positive-cycle reduction.** If the ambient binary star theorem fails,
there is a minimal failing representative whose positive underlying
undirected graph is a forest.

**Proof.** Choose a binary failure with the fewest condensation vertices.
Suppose its positive underlying graph has a cycle. Identify all cycle
vertices, then contract strong components. Star quotient closure is
already reviewed. Every quotient dicut lifts to an original dicut
with capacity at least two. The quotient has fewer vertices, so it
has two original-capacity-feasible packing members by minimality.

Lift these members on all retained original units. Orient the chosen
undirected positive cycle cyclically. Assign one original capacity
unit on each cycle arc to the color given by agreement or disagreement
of its original direction with this cyclic orientation.

An original dicut splitting the cycle has cyclic-orientation crossings
in both directions: the cyclic orientation has zero divergence at
every vertex. Its original crossings all point outward, so the two
relative-direction colors both meet that original dicut. An original
ideal constant on the cycle survives the identification and strong
contraction and is covered by the lifted quotient packing. Extra units
lost inside the contraction need not be used. No retained unit and
cycle unit overlap, and no original capacity is duplicated.

This reconstructs a full binary packing, a contradiction. Thus a
vertex-minimal failure has forest positive support. QED.

This reduction concerns the positive underlying graph only. It does
not delete any capacity-zero topology or assert that the full topology
is a forest.

## 9. A native joint-guard exclusion and a successful single guard

The following is a genuinely native failure of one new attempted
construction, not a repeat of the abstract three-mark obstruction.

In the first input below the source r=1 has the two actual direct
units beta1=1->4 and beta2=1->5. Its ordinary terminal cut forces
their colors opposite. The only internal-tail joint unit that can
serve as a sink-side witness through both exceptional sinks is
e=13->7. Thus the two requirements

    color(e)=color(beta1),       color(e)=color(beta2)

are individually feasible even in full original packings but jointly
impossible. There is no duplication of e available. The input has
14 vertices, 42 topology arcs, 11 unit-capacity positive arcs and
31 capacity-zero arcs. It has exactly 159 proper original ideals,
minimum two and nonterminal minimum three. All eight ordinary
partitions already pack, and both individual guards have full-packing
witnesses. This refutes only the universal requirement to impose both
sink guards on the one common original unit; it does not refute star
packing. An initial diagnostic that also expected a bad ordinary
starting partition was not met: this particular input has none.

The second, 17-vertex input has 59 topology arcs, 13 positive units,
46 capacity-zero arcs and 743 original ideals. Its minimum is two
and its nonterminal minimum three. It has 32 ordinary/C2 partitions,
30 of which are full. The displayed starting color counts on
(C1,C2,C12) are respectively (5,0), (3,2), (4,1).
Exchange the actual units 2->9 and 2->11. The new counts become
(4,1), (2,3), (3,2), and both colors meet every original cut. This
is an explicit single-source guard from Section 8.2, not independent
recolorings or a finite miss. All original capacity units and terminal
cuts are preserved.

Replay only this new diagnostic, without rerunning Section 6, by
executing the following standard-library block. It exhausts 2,048 and
8,192 binary unit assignments respectively and writes no files.

```python
from collections import Counter

def instance(guard_conflict):
    S, T = set(range(4)), set(range(4, 8))
    edges = {(x, y) for x in S for y in T
             if (x, y) not in {(0, 4), (0, 5)}}
    if guard_conflict:
        n = 14
        incoming = ((8, {0, 1}, {6, 7}), (9, {0, 2}, {6, 7}),
                    (10, {0, 3}, {6, 7}))
        outgoing = ((11, {4, 6}), (12, {5, 6}), (13, {4, 5, 7}))
        units = [(0, 6), (0, 8), (1, 4), (1, 5), (2, 9), (2, 6),
                 (3, 10), (3, 7), (11, 4), (12, 5), (13, 7)]
    else:
        n = 17
        incoming = ((8, {0, 1}, {6, 7}), (9, {0, 2}, {6, 7}),
                    (10, {0, 3}, {6, 7}), (11, {1, 2}, {4, 6, 7}),
                    (12, {1, 3}, {4, 6, 7}))
        outgoing = ((13, {4, 6, 7}), (14, {5, 6, 7}),
                    (15, {4, 5, 7}), (16, {5, 7}))
        units = [(0, 6), (0, 8), (1, 4), (1, 5), (2, 9), (2, 11),
                 (3, 10), (3, 12), (13, 4), (14, 5), (13, 6),
                 (15, 7), (16, 7)]
    for v, A, D in incoming:
        edges.update((x, v) for x in A)
        edges.update((v, y) for y in D)
    for p, D in outgoing:
        edges.update((x, p) for x in S-{0})
        edges.update((p, y) for y in D)
    return n, edges, units, incoming, outgoing

for guard_conflict in (True, False):
    n, edges, units, incoming, outgoing = instance(guard_conflict)
    S, T, full = set(range(4)), set(range(4, 8)), (1 << n)-1
    assert len(set(units)) == len(units)
    assert all(edge in edges for edge in units)
    assert all(sum(u == x for u, v in units) == 2 for x in S)
    assert all(sum(v == y for u, v in units) == 2 for y in T)
    reach, pred = [1 << v for v in range(n)], [0]*n
    for u, v in edges:
        reach[u] |= 1 << v
        pred[v] |= 1 << u
    for v in range(n):
        for u in range(n):
            if reach[u] >> v & 1:
                reach[u] |= reach[v]
    assert {(x, y) for x in S for y in T
            if not reach[x] >> y & 1} == {(0, 4), (0, 5)}
    assert not any(reach[p] >> v & 1
                   for p, D in outgoing for v, A, D in incoming)
    terminal = {1 << x for x in S} | {full^(1 << y) for y in T}
    rows, ordinary = {}, set()
    families = {1: set(), 2: set(), 3: set()}
    minimum, nonterminal = len(units)+1, len(units)+1
    for U in range(1, full):
        if any(U >> v & 1 and pred[v] & ~U for v in range(n)):
            continue
        row = sum(1 << i for i, (u, v) in enumerate(units)
                  if U >> u & 1 and not U >> v & 1)
        rows[U] = row
        minimum = min(minimum, row.bit_count())
        if U not in terminal:
            nonterminal = min(nonterminal, row.bit_count())
        A = {x for x in S if not U >> x & 1}
        B = {y for y in T if U >> y & 1}
        if A and B:
            assert A == {0} and B <= {4, 5}
            families[int(4 in B)+2*int(5 in B)].add(row)
        else:
            ordinary.add(row)
    assert minimum == 2 and nonterminal == 3
    cores = {k: sum(1 << i for i in range(len(units))
                    if all(row >> i & 1 for row in family))
             for k, family in families.items()}
    assert all(core in families[k] for k, core in cores.items())
    all_units, counts, guards = (1 << len(units))-1, Counter(), {}
    for F in range(1 << len(units)):
        G = all_units ^ F
        if not all(F & row and G & row for row in ordinary):
            continue
        counts["ordinary_partitions"] += 1
        failures = []
        for selected in (F, G):
            bad = [k for k, family in families.items()
                   if not all(selected & row for row in family)]
            if bad:
                assert selected >> 0 & 1
                failures.append(bad)
            if 1 in bad:
                assert selected >> 2 & 1
            if 2 in bad:
                assert selected >> 3 & 1
            if 3 in bad:
                assert selected >> 2 & 1 or selected >> 3 & 1
        if all(F & row and G & row for row in families[2]):
            counts["C2_partitions"] += 1
            assert len(failures) <= 1
        if not failures:
            counts["full_packings"] += 1
            if guard_conflict:
                for i in (2, 3):
                    if (F >> 10 & 1) == (F >> i & 1):
                        guards.setdefault(i, F)
        if guard_conflict:
            assert (F >> 2 & 1) != (F >> 3 & 1)
            assert not ((F >> 10 & 1) == (F >> 2 & 1) == (F >> 3 & 1))
    if guard_conflict:
        assert (len(edges), len(rows), len(units)) == (42, 159, 11)
        assert counts == {"ordinary_partitions": 8,
                          "C2_partitions": 8, "full_packings": 8}
        assert len(guards) == 2
        expected = {
            2: [1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
            3: [1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0],
        }
        assert {k: [int(F >> i & 1) for i in range(len(units))]
                for k, F in guards.items()} == expected
    else:
        assert (len(edges), len(rows), len(units)) == (59, 743, 13)
        assert counts == {"ordinary_partitions": 32,
                          "C2_partitions": 32, "full_packings": 30}
        old = [1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1]
        new = old.copy()
        new[4], new[5] = new[5], new[4]
        assert all(len({old[i] for i in range(len(units)) if row >> i & 1}) == 2
                   for row in ordinary | families[2])
        assert all(len({new[i] for i in range(len(units)) if row >> i & 1}) == 2
                   for row in rows.values())
        def core_counts(colors):
            return {k: [sum(colors[i] == c and row >> i & 1
                            for i in range(len(units))) for c in (0, 1)]
                    for k, row in cores.items()}
        assert core_counts(old) == {1: [5, 0], 2: [3, 2], 3: [4, 1]}
        assert core_counts(new) == {1: [4, 1], 2: [2, 3], 3: [3, 2]}
    print(n, len(edges), len(units), len(rows), minimum, nonterminal,
          dict(counts))
```

The second Host review on 2026-11-05 at 06:29:47Z supports Sections 7-9
and their limited conclusions. The next section supplies the previously
unresolved contact-free small-Z branch; its new proof still needs
independent review. Active-contact binary packing remains open, so the
ambient binary and all-q conclusions are not certified. Originality and
publication significance remain separate unverified gates.

## 10. Completing every contact-free strict binary star

**Contact-free binary theorem.** Every contact-free strict threshold-two
shared-source star normal form has one partition of its original units
into two original dijoins.

In particular this proves the requested residual contact-free forest
case with a direct s unit and |Z|<=1. The new argument does not need the
forest hypothesis. It is not the ambient binary star theorem, because
active contacts are excluded here.

The previously accepted safe-source theorem handles |Z|>=2 and the
absence of a direct unit at s. Hence assume a direct unit at s and
|Z|<=1. Define actual sink-side joint bundles

    Ei = {P->Y : P reaches ti, Y in Treg},     i=1,2.

Then G=Z union (E1 intersect E2), and the four boundaries are

    C0  = Z union (E1 intersect E2) union M1 union M2,
    C1  = Z union E1 union M2,
    C2  = Z union E2 union M1,
    C12 = Z union E1 union E2.                           (9)

An ordinary color containing a Z unit is full. So is one containing both
an Ei unit and an Mi unit: if the Ei unit reaches both exceptional
sinks it belongs to G; otherwise it belongs to Li, and (2) applies.
These sufficient conditions cover all three families simultaneously.

### 10.1 Root-coloring tools and safe source preparation

We use the accepted contact-free colored-root extension and pair-relation
interface, not an integrality claim for the full ordinary paired-color
polytope. The following elementary consequences fix exactly what the new
root constructions require.

**Two one-sided roots.** Two distinct sink-only root labels can always
be colored oppositely in one valid two-family root-block coloring.
If their colors are forced relative to each other, they are the two
ends of a binary path. Both end incidences are on the sink-block side,
so its constraint length is odd and its end colors are opposite.
Otherwise the pair-relation theorem permits opposition. This statement
also holds after a sufficient block occurrence has been suppressed,
provided the reduced system still has two disjoint block families.

**Outgoing root cut.** If the complete outgoing root-label set of a
root incidence cut is B, |B|>=2, and no root label enters it, some valid
root coloring makes B bichromatic. Otherwise every pair in B is forced
equal, putting B on one parity in one binary path or cycle. The labels
of that parity have a common traversal direction. The cut has no
other crossing labels that could cancel their at-least-two membership
changes. A path has net change at most one and a cycle zero, a
contradiction. Here B must be the complete outgoing set, not an
arbitrary subset of it.

**One sink guard.** Let A be a direct root at an internal sink t,
whose other original incoming unit remains nonvirtual, and let e be
a sink-only virtual root with regular sink placement. Any minimal
closed block containing t is non-singleton and has at least three
labels. Suppress A's sink-block occurrence, if present, and identify
e with A. The class keeps A's source placement and e's sink placement.
Every reduced block retains at least two labels and at most one
incidence of this class, so bipartite integral coloring applies.
Restore the omitted occurrence before ordinary extension. Expansion
of e is justified separately below; an equality alone does not supply
a safe endpoint.

The same suppression is valid for an already safe sink-only virtual
anchor A at t, as long as another original incoming unit of t remains
nonvirtual. The identified class is then sink-only.

First suppose s is internal and Z contains an internal source unit e.
Its other unit is an actual direct alpha, since s is two-tight.
There is no regular-source-to-regular-sink positive unit: the one
allowed Z unit is internal. In the original tight-terminal pair graph,
alpha's source neighbor is s's internal unit, and its possible sink
neighbor is an internal-tail unit. Both terminate at internal vertices.
Thus e is outside alpha's binary component. Make only e a source
virtual root, assign e=alpha by the pair-relation theorem, extend both
ordinary colors, and expand e through the real alpha at s. That color
contains Z and is full. The other has s's internal unit and no direct
unit at s, so cannot be bad by Section 7. This closes this case.

In all remaining cases make the possible internal Z unit virtual on
the source side. This is safe because s is now all-direct and its
singleton source block has real roots of both colors. If Z is direct
or empty no source virtualization is needed. After this preparation
no possible regular-source dependency enters s. Every minimal source
block is contained in S0, or is the all-direct singleton s. An
internal s with no incoming dependency is not a minimal closed
component because its internal unit has another source endpoint.
This makes the root cuts below coherent on all source blocks.

Every internal exceptional sink is two-tight. If it has a direct
unit, its incoming units are exactly

    beta_i = X_i->ti,       k_i = P_i->ti.

If it has no direct unit, both incoming units are internal. An
all-direct exceptional sink has a singleton closed root block with
real direct roots of both colors, and all its incoming units belong
to Mi. Call this sink protected.

### 10.2 Both exceptional sinks have an internal unit and a direct anchor

Here Mi consists of beta_i and also k_i exactly when P_i reaches the
other exceptional sink.

**Neither internal tail reaches the other sink.** Each
|Z|+|Ei|>=2, because Ci=Z union Ei union {beta_j} has capacity at
least three. Moreover |Z|+|E1 union E2|>=3. Thus E1 and E2 are
nonempty and admit distinct witnesses.

Choose e_i in Ei, make just these two sink units virtual, and try
to suppress both beta_i sink occurrences and identify e_i=beta_i.
Distinct witnesses can be chosen so every block retains two labels.
Here is the full finite-choice argument, rather than an assertion
that two separate guards combine.

Only a common three-label sink block Q containing t1,t2 could fail.
Assume every distinct choice fails, and minimize the number of
original sinks in its bad Q. Its root labels include beta1,beta2.
Both witness placements cannot lie in Q, or it would have at least
four distinct labels. Strong connectivity inside Q gives a
nonvirtual incoming dependency to each ti. It cannot come from tj,
since P_j does not reach ti; it is a regular-sink unit of Ei.

If exactly one chosen witness is in Q, replace the outside witness
by such a nonvirtual inside witness of its own family. The choices
are still distinct. Restoring the old outside unit does not change
closedness of Q, while both new virtual witness roots now lie in Q.
Any new bad component containing both ti is a proper subcomponent
of Q, contradicting minimality.

If both chosen witnesses are outside and there are distinct inside
witnesses, replace both, with the same contradiction. Otherwise the
two inside witness sets are both the singleton {f}. Replace e1 by f,
keeping the outside e2. This removes all within-Q dependencies into
both special sinks. Neither is a singleton closed component, because
its original nonvirtual k_i has an allowed regular sink endpoint.
No minimal closed component inside Q can contain both special sinks.
Q remains closed, so no new bad component containing both can lie
outside Q either. This is again a contradiction.

Use the resulting two sufficient suppressions and identifications
in one bipartite root system. Restore the occurrences, extend both
ordinary colors, and expand e_i in beta_i's color through the real
beta_i at ti. If beta1,beta2 are opposite, each color has an Ei
and an Mi unit and is full by (9). If they are equal, that color
is full, and the other uses the two internal k_i units with no
direct unit into either exceptional sink. Section 7 forbids its
missing either a singleton or the joint family. Both are full.

**Exactly one internal tail reaches the other sink.** Relabel so
P1 reaches t2 and P2 does not reach t1. Virtualize k1, all E1, and
the prepared internal Z if any. Guard k1=beta2 by suppressing
beta2's sink occurrence at the still-internal t2. The singleton
sink block at t1 is {beta1,k1}, so the guard forces beta1 and
beta2 opposite.

In the reduced root incidence graph include all S0 source blocks
and the t1 sink block; all other constrained sink blocks are outside.
Place private endpoints on their actual C1 sides. The guard class
has its source placement from beta2 inside and its sink placement
from k1 at t1 inside. The complete outgoing cut is exactly

    B = Z union E1,

with no incoming root label. Beta2's former outgoing occurrence has
become internal, and no other direct regular-source root can cross.
Since C1=B union {beta2} is a strict nonterminal cut, |B|>=2.
The outgoing-root-cut lemma supplies a single coloring splitting B.

Restore and extend. Expand k1 through its same-colored real beta2,
so t1 now has actual root-reaching paths of both colors. Expand E1
through those paths and any source virtual Z through s's real roots.
M1={beta1,k1} has both colors. Each color contains Z or an E1
unit, hence is full by (9). No E2-only unit was made virtual.

**Both internal tails reach the other sink.** Virtualize k1,k2 and
all E1 union E2. Identify k1=beta2 and k2=beta1. The two original
singleton sink constraints become the same binary block
{beta1,beta2}; retain one copy when choosing colors. Each class
has its original beta source placement and one sink placement.
All other blocks are unchanged, so this is one bipartite block
system with a feasible half-vector.

Put all S0 source blocks and this binary sink block inside a root
cut. Both original special sinks are on its inside. Its complete
outgoing set is Z union E1 union E2, of size at least three, with
no incoming label. Color that set bichromatically. Restore both
original sink blocks. Expand k1 through real beta2 and k2 through
real beta1, independently, then expand all joint sink roots through
the two resulting protected sinks. Both Mi have both colors and
both colors meet C12. Thus all three families are met.

### 10.3 At least one exceptional sink is all-direct

If both are all-direct, virtualize all joint sink units. Both sinks
are protected, both Mi have both colors, and the joint root cut
with all S0 source blocks and both sink blocks inside has complete
outgoing set C12 and no incoming root. Split it, extend, and
expand through the real roots. This packs.

Otherwise relabel so t2 is all-direct and t1 internal. If E2 has
at least two units, make two of them sink-only roots and color them
oppositely by the one-sided-root lemma. Each expands through a
real root at protected t2. Each color has E2 and M2 and is full.

So assume |E2|<=1. If all original internal units into t1 have
tails reaching t2, make those units and all joint sink units virtual
in one reduced root system. The two incoming labels at t1 form
its singleton binary block, while t2 retains its real direct roots.
In this system the joint root cut, with S0 and both exceptional
sink blocks inside, has complete outgoing set C12 and no incoming
label. The virtual incoming units of t1 have both private and sink
placements inside this cut. Choose one coloring splitting C12 and
extend it once to both ordinary colors. First expand the incoming
virtual units of t1 through protected t2 in those assigned colors.
They and any direct beta1 then give real paths of both colors at
t1. Next expand the joint units through these protected paths.
All incoming units of t1 belong to M1 and are bichromatic, so both
colors meeting C12 are full. No intermediate coloring is fixed
before applying the outgoing-root-cut lemma.

If t1 has a direct beta1 and its k1 tail does not reach t2, then
M1={beta1}. Strict C2 gives |Z|+|E2|>=2. Thus Z and E2 each
have exactly one unit. Strict C12 supplies e in E1 minus E2.
Virtualize e and the one E2 unit; guard e=beta1 at t1, whose
original k1 remains nonvirtual.

In the reduced incidence graph include S0 source blocks and the
all-direct t2 block. The complete outgoing set consists of the
three distinct labels Z, the E2 unit, and the guard class beta1=e,
with no incoming label. In particular e's tail does not reach t2;
its old two private sides were outside, while the guard class
retains beta1's inside source and an outside regular sink.
Split this outgoing set. Some Z or E2 label has color opposite
beta1. Restore and extend. The beta1 color expands e through the
real beta1 and is full via L1,M1. The other contains Z, or an
E2 unit and a real M2 root, and is full too.

Finally suppose t1 has no direct unit and not both of its incoming
internal tails reach t2. Let M1 be its subset of incoming units
whose tails do reach t2. Strict C2 gives

    |Z|+|E2|+|M1|>=3.

Here |Z|<=1, |E2|<=1 and |M1|<=1, so each equals one. Write
gamma for this one M1 unit; the other original incoming unit
eta does not reach t2. Strict C12 again supplies
e in E1 minus E2.

Make gamma a sink-only virtual root at t1 and make e virtual.
Suppress gamma's occurrence at t1 and identify e=gamma. This
is legitimate: eta remains nonvirtual, so a closed block
containing t1 has at least three labels. The class is sink-only.
It and the distinct sink-only E2 label can be assigned opposite
colors in one reduced coloring. Restore, extend, and expand
gamma through protected t2. Then expand e in that same color
through gamma's already constructed path. That color has L1,M1;
the other has E2,M2. Both are full. No shared unit is duplicated.

### 10.4 One exceptional sink has no direct unit and the other is internal

Both cannot have no direct unit, since the actual original ideal K
from Section 1 has boundary

    Z union D1 union D2,

where Di is the direct incoming unit set of ti. This boundary
would have size at most one.

Relabel so t1 has no direct unit and t2 has internal k2 and the
one direct beta2. K's boundary has size |Z|+1, so Z has exactly
one unit and this ordinary cut is two-tight. It excludes s and
contains no original sink; hence strictness makes it a singleton
original source r, not a co-singleton sink. Therefore S0={r}
and r's original units are exactly beta2 and Z.
After the safe source preparation its singleton root block is
{beta2,Z}; these labels must have opposite colors.

If E2 is nonempty, choose e in E2 and use the one sink guard
e=beta2 at t2. Restore, extend, and expand e through real beta2.
That color has E2,M2 and is full; the other has Z and is full.
Any internal Z expands safely through the all-direct s.

If E2 is empty, strict C2=Z union M1 forces |M1|=2. Thus
**both** original incoming units of t1 have tails reaching t2.
Strict C12 also gives |E1|>=2. Choose e in E1, make it a
sink-only root and guard e=beta2 by suppressing beta2's occurrence
at t2. The color equality is selected in one ordinary root
extension; it does not assert that e has an endpoint at t2.

Let F be beta2's assigned color after ordinary extension. The
original two-tight sink t1 has a selected original incoming unit
gamma in F. Its tail reaches t2. Set this unit's auxiliary sink
endpoint to t2, where the actual direct beta2 is a real F root.
This makes an actual F path from t1 to a real root independent
of virtual e. Redirecting this one auxiliary endpoint preserves
root reachability: every path arriving at t1 now uses that real
path instead. It changes no original arc, occurrence, or color.

Expand e through t1 along the path just constructed. F has e
in L1 and gamma in M1, so is full. The other color contains Z
and is full. This is the necessary two-step original expansion;
the absent direct root at t1 was not silently supplied.

### 10.5 Coverage, capacity and exhaustion

These cases exhaust the sink types and their mutual internal
reachability. Every sufficient reduced coloring is restored to
the original root placement before the ordinary extension.
Every expansion uses a same-colored actual direct root or a
previously constructed path to one. The explicit orders above
have no circular dependency.

Both colors meet every original ordinary cut by the accepted
extension and these safe original expansions. The checks using
(9), or bichromatic Mi and C12, meet all three actual exceptional
families in the same two colors. At every original two-tight
terminal both colors use one of its two units. Every positive
unit touches such a terminal, so the resulting original partition
uses every distinguished unit exactly once. No original arc is
duplicated and no original capacity is increased. Capacity-zero
topology has remained unchanged. This proves the theorem.

The first reviewed safe-source result left the contact-free
small-Z branch open. This theorem removes that branch, including
no-direct exceptional sinks; it is not a support restriction or a
proof conditional on ambient binary packing. The only remaining
strict binary branch is active contacts. Until that branch is
proved, the reviewed all-q implication cannot be invoked as a
full star packing theorem.

## 11. New exact residual-star constructions

The no-direct-sink construction below has |Z|=1, forest positive
support and a bad ordinary coloring. Thus the tempting assertion
that all ordinary colorings in that residual case already pack
is false. Its full topology has 18 vertices and 63 arcs; 14
positive units leave 49 capacity-zero arcs. There are exactly
971 proper original ideals, minimum two and nonterminal minimum
three. Only the joint family fails in the displayed old coloring.
Exchange the actual incoming sink-5 units 12->5 and 13->5.
The new coloring meets all 971 original cuts, and the latter
unit has the direct beta2's color. This realizes Section 10.4's
guard followed by an actual selected t1-to-beta2 expansion,
without inventing a direct unit at t1.

Three further 15-vertex forest inputs realize separate guards,
one-way protection and reciprocal protection with Z empty.
Their topology arc counts are 49,50,51; each has 11 positive
units. Their proper ideal counts are 463,451,439. All have
minimum two and nonterminal minimum three. Exhausting their
2,048 binary unit assignments gives 16 ordinary partitions in
each case, with respectively 14,14,16 full packings.
Full models satisfying the displayed sufficient guards number
4,14,16 respectively. These are new native illustrations, not
reruns of any accepted certificate.

Replay only this new block with standard Python; no sidecar,
solver, or file output is needed. The universal theorem is the
case proof in Section 10, not extrapolation from this finite
enumeration.

```python
from collections import Counter

def residual_instance(kind):
    if kind == "no_direct":
        n, S, T = 18, {0, 1}, set(range(2, 9))
        units = [(1, 3), (1, 4), (0, 4), (0, 7), (0, 8),
                 (9, 2), (10, 2), (11, 3), (12, 5), (13, 5),
                 (14, 6), (15, 6), (16, 7), (17, 8)]
        desc = {
            9: {2, 3, 4, 5, 6, 8}, 10: {2, 3, 4, 6},
            11: {2, 3, 5, 6, 7, 8}, 12: {4, 5, 6, 8},
            13: {2, 5, 6, 7, 8}, 14: {5, 6, 7, 8},
            15: {2, 6, 8}, 16: {4, 5, 6, 7, 8},
            17: {4, 5, 6, 8},
        }
        ancestors = {p: {1} for p in desc}
        ancestors[12], ancestors[16] = {0, 1}, {0}
        edges = {(x, y) for x in S for y in T
                 if not (x == 0 and y in (2, 3))}
        order = (0, 1, *range(9, 18), *range(2, 9))
    else:
        n, S, T = 15, {0, 1}, set(range(2, 7))
        units = [(0, 4), (0, 7), (1, 2), (1, 3), (8, 2),
                 (9, 3), (10, 4), (11, 5), (12, 5), (13, 6), (14, 6)]
        P1, P2 = {2, 4, 5, 6}, {3, 4, 5, 6}
        P12 = P1 | P2
        desc = {8: P1 if kind == "separate" else P12,
                9: P12 if kind == "reciprocal" else P2,
                10: P1, 11: P2, 12: P12, 13: P1, 14: P2}
        ancestors = {p: {1} for p in desc}
        edges = {(x, y) for x in S for y in T
                 if not (x == 0 and y in (2, 3))}
        edges.update({(0, 7), (1, 7), (7, 4), (7, 5), (7, 6)})
        order = (0, 1, 7, *range(8, 15), *range(2, 7))
    for p, D in desc.items():
        edges.update((x, p) for x in ancestors[p])
        edges.update((p, y) for y in D)
    return n, S, T, units, edges, order

for kind in ("no_direct", "separate", "one_way", "reciprocal"):
    n, S, T, units, edges, order = residual_instance(kind)
    assert len(set(units)) == len(units)
    assert all(edge in edges for edge in units)
    position = {v: i for i, v in enumerate(order)}
    assert all(position[u] < position[v] for u, v in edges)
    reach, pred = [1 << v for v in range(n)], [0]*n
    for u, v in edges:
        reach[u] |= 1 << v
        pred[v] |= 1 << u
    for v in range(n):
        for u in range(n):
            if reach[u] >> v & 1:
                reach[u] |= reach[v]
    assert {(x, y) for x in S for y in T
            if not reach[x] >> y & 1} == {(0, 2), (0, 3)}
    N = {v for u, v in units if v not in T}
    P = {u for u, v in units if u not in S}
    assert N.isdisjoint(P)
    assert not any(reach[p] >> v & 1 for p in P for v in N)
    Z = [i for i, (u, v) in enumerate(units)
         if u in S-{0} and (v in T-{2, 3}
                            or (v in N and reach[0] >> v & 1))]
    assert len(Z) == (1 if kind == "no_direct" else 0)
    parent = list(range(n))
    def find(v):
        while parent[v] != v:
            v = parent[v]
        return v
    for u, v in units:
        a, b = find(u), find(v)
        assert a != b
        parent[a] = b
    shores = [0]
    for v in order:
        shores += [U | (1 << v) for U in shores if not pred[v] & ~U]
    full = (1 << n)-1
    terminal = {1 << x for x in S} | {full ^ (1 << y) for y in T}
    rows, ordinary, families = [], [], {1: [], 2: [], 3: []}
    minimum, nonterminal = len(units)+1, len(units)+1
    for U in shores:
        if U in (0, full):
            continue
        row = sum(1 << i for i, (u, v) in enumerate(units)
                  if U >> u & 1 and not U >> v & 1)
        rows.append(row)
        minimum = min(minimum, row.bit_count())
        if U not in terminal:
            nonterminal = min(nonterminal, row.bit_count())
        A = {x for x in S if not U >> x & 1}
        B = {y for y in T if U >> y & 1}
        if A and B:
            assert A == {0} and B <= {2, 3}
            families[int(2 in B)+2*int(3 in B)].append(row)
        else:
            ordinary.append(row)
    assert minimum == 2 and nonterminal == 3
    degree = Counter()
    for u, v in units:
        if u in S:
            degree[u] += 1
        if v in T:
            degree[v] += 1
    assert all(degree[u] == 2 or degree[v] == 2 for u, v in units)
    all_units = (1 << len(units))-1
    if kind == "no_direct":
        old = [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1]
        new = old.copy()
        new[8], new[9] = new[9], new[8]
        F = sum(1 << i for i, c in enumerate(old) if c)
        G = all_units ^ F
        assert all(F & row and G & row for row in ordinary)
        assert all(F & row and G & row for row in families[1]+families[2])
        assert sum(not (F & row and G & row) for row in rows) == 1
        assert new[9] == new[0] and new[1] != new[0]
        assert all({new[i] for i in range(len(units)) if row >> i & 1}
                   == {0, 1} for row in rows)
        assert (len(edges), len(rows)) == (63, 971)
        print(kind, n, len(edges), len(units), len(rows),
              minimum, nonterminal, "exact_repair", new)
    else:
        counts, model = Counter(), None
        for F in range(1 << len(units)):
            G = all_units ^ F
            if not all(F & row and G & row for row in ordinary):
                continue
            counts["ordinary"] += 1
            if not all(F & row and G & row for row in rows):
                continue
            counts["full"] += 1
            c = [int(F >> i & 1) for i in range(len(units))]
            guard = ((c[6] == c[2] and c[7] == c[3])
                     if kind == "separate" else c[4] == c[3]
                     if kind == "one_way" else
                     c[4] == c[3] and c[5] == c[2])
            if guard:
                counts["guard_full"] += 1
                if model is None:
                    model = c
        expected = {"separate": (49, 463, 14, 4),
                    "one_way": (50, 451, 14, 14),
                    "reciprocal": (51, 439, 16, 16)}[kind]
        assert (len(edges), len(rows), counts["full"],
                counts["guard_full"]) == expected
        assert counts["ordinary"] == 16 and model is not None
        print(kind, n, len(edges), len(units), len(rows),
              minimum, nonterminal, dict(counts), model)
```

Only the bounded automatic-coloring shortcut is refuted by the first
input. The new contact-free theorem does not rely on that shortcut,
the numerical search that suggested it, or a generic double sink guard
on a common unit. The guard witnesses in Section 10 are distinct where
two are needed, and a missing direct root is replaced only by the
explicit previously constructed same-colored original path.

## 12. Erasing contacts at one original unit head

The new operation is deletion of passive topology, not a contact fold.
It retains every positive original arc and does not introduce a
selectable surrogate. Its output need not be a strict normal form.
This last distinction is essential to the proof.

### 12.1 A footprint-preserving weakening of the topology

Let D be a strict binary common-source star form. Retain its vertex set,
all original positive units and their capacities, the original source
and sink sets S,T, and the original source and sink footprints

    a(v) = {X in S : X reaches v},
    z(v) = {Y in T : v reaches Y}.

As before, N and P are the disjoint sets of internal positive heads
and tails. Suppose an active head n in N has at least one contact.
Every positive input at n is from s, by the strict star contact
restriction. Use the reviewed parallel-capacity combination, so each
ordered pair has total positive capacity less than two. The one
possible positive arc s->n therefore has capacity one.
Consequently n has exactly one positive input unit.

Define D_n on the same vertices as follows. Its topology consists of:

1. X->v for every distinct pair with X in S and X reaching v in D;
2. v->Y for every distinct pair with Y in T and v reaching Y in D;
3. p->m for all original contacts p in P, m in N, except those with m=n.

Every positive original arc occurs in the first two lists; give it its
unchanged capacity and retain its original unit identity. All other
listed arcs have capacity zero. Repeated listings mean one topology arc,
not another capacity unit.

All listed arrows were original reachability relations. Thus D_n is
acyclic and its reachability is contained in D's. Every internal vertex
still has all its original source ancestors and sink descendants,
because lists 1 and 2 supply them directly. Its source and sink sets,
every footprint a(v),z(v), and every missing source-sink pair are
therefore unchanged.

The only arrows between internal vertices are those in list 3.
Since P and N are disjoint, no two of these arrows concatenate.
The new active contact relation is exactly the old one with the edges
incident with n removed. In particular at least one original
reachability relation p->n is lost. No different path silently restores
it. This construction also covers passive internal vertices outside
P union N: their source and sink incidences are retained.

### 12.2 Exact ordinary minima before and after erasure

Here is the required aggregate calculation; no independently feasible
folds or color-dependent guesses are combined.

For any unit subset F put d_F(X) for its degree at a source or sink,
n_F(m) for its number of inputs at m in N, and p_F(p) for its number
of outputs at p in P. For nonempty A subset S let N_A,P_A consist of
the vertices whose source footprints are contained in A. Let
nu_F(A) be the minimum weighted vertex-cover value of the contact
graph on P_A,N_A, with weights p_F(p),n_F(m).
For nonempty C subset T define P^C,N^C by sink-footprint containment
in C and let eta_F(C) be the analogous cover value.

Exactly as an identity on the original ideals, the two ordinary
family minima are

    g_F(A) = sum_(X in A) d_F(X)
               - sum_(m in N_A) n_F(m) + nu_F(A),       (10)

    h_F(C) = sum_(Y in C) d_F(Y)
               - sum_(p in P^C) p_F(p) + eta_F(C).     (11)

The first family has no original sink and source set A. The second
contains every original source and excludes exactly the sink set C.
Together these families contain every ordinary ideal.

For clarity, these formulas do not rely on the number of missing pairs.
For a no-sink ideal U with source set A, its divergence count is

    F(delta+(U)) = sum_(X in A) d_F(X)
                    - sum_(m in N_A intersect U) n_F(m)
                    + sum_(p in P_A intersect U) p_F(p).

The set (N_A minus U) union (P_A intersect U) is a contact cover,
giving the lower bound (10). Conversely, for a minimum cover
Q_N union Q_P, the original ideal

    U = A union Anc(N_A minus Q_N)

has exactly source set A and no sink. Its induced contact cover costs
at most that minimum: every included positive tail precedes a chosen
head and is in Q_P; extra included heads only decrease the cost.
It therefore attains (10). Reversing the argument, with the filter

    C union Desc(P^C minus Q_P),

proves (11). Zero-weight vertices remain in the cover constraints.
This proves the formulas for D and D_n, with their respective contact
relations and their identical footprints and degree terms.

Write g,h for the full, uncolored capacity minima in D and g',h'
for those in D_n. Deleting edges incident with the one weight-one
vertex n changes the minimum cover value by an amount in [0,1].
Indeed, an old cover covers the new graph; adjoining n to any new
cover covers the old graph at additional cost at most one.
All the other terms in (10)-(11) are unchanged. Hence, simultaneously
for every nonempty A,C,

    g(A)-1 <= g'(A) <= g(A),
    h(C)-1 <= h'(C) <= h(C).                           (12)

There is no loss on a singleton A or C. To see the source assertion,
choose an original contact p->n. The source s reaches n, and some
source X reaches p. Since p has a positive output to an exceptional
sink, s cannot reach p; therefore X != s. Thus |a(n)|>=2 and n
does not occur in any source contact graph for singleton A.

For the sink assertion, every contact tail p preceding n has a
positive output to some ti and reaches a sink in z(n). The latter
set is nonempty and contained in Treg, since s reaches n but neither
exceptional sink. Thus |z(p)|>=2. No edge deleted at n occurs in a
sink contact graph with singleton C. Its cover value is unchanged.

If |A|>=2, every original ideal attaining g(A) is nonterminal:
it contains at least two sources and no sink, whereas |T|>=3.
Thus g(A)>=3. If |C|>=2, every ideal attaining h(C) is likewise
nonterminal: it contains all |S|>=2 sources and excludes at least
two sinks. Thus h(C)>=3. Equation (12) proves g'(A),h'(C)>=2
for all A,C, including the unchanged singleton cases.

### 12.3 The three exceptional minima do not change

The five actual unit bundles G,L1,L2,M1,M2 in Section 1 depend only
on the positive unit identities and on original source/sink
footprints. They are identical in D and D_n.

The four-boundary proof applies to D_n without assuming that its
nonterminal cuts are strictly slack. Its construction of the
canonical ideals uses the star contact restriction, which is
preserved when contacts are deleted. Strict slack is used there
only to bound the capacities of the resulting boundaries, not to
establish their existence or dominance.

More explicitly, with ancestors now taken in D_n, put

    K_n = S0 union Anc(N minus Desc(s)),
    U_B = K_n union Anc(B),   empty != B subset {t1,t2}.

No active positive tail belongs to K_n: such a tail would contact
a head outside Desc(s), whose positive input cannot then be from s,
contrary to the star contact restriction. All heads in Desc(s) stay
outside every U_B, and all other active heads stay inside. The
included active tails are exactly those reaching B. The positive
boundaries are therefore the identical C1,C2,C12 of (1). The same
canonical dominance argument applies to every selected unit set.

In particular every exceptional cut of D_n has capacity at least
the corresponding unchanged boundary, which had capacity at least
three in D. Together with Section 12.2, this proves:

**Unit-head erasure lemma.** D_n has minimum original dicut capacity
at least two, has exactly the same two missing source-sink pairs,
uses exactly the same positive original capacity units, and has
strictly fewer reachability relations than D.

Every packing of D_n is already a packing of D on those same original
units. An ideal of D is an ideal of D_n, and its positive boundary
is unchanged. No path, same-color contact pair, or shared input
needs expansion in this transfer.

The lemma does not claim that every ordinary coloring of D remains
ordinary in D_n. Nor does it claim that D_n remains strict. Newly
created nonterminal cuts of capacity two are allowed and will be
handled by the existing ambient reductions.

## 13. Unconditional binary packing, including active contacts

**Ambient binary star theorem.** Every finite common-source
two-defect full-topology digraph with nonnegative integral capacities
at least two on every original dicut has two capacity-feasible
original dijoins.

**Proof.** Suppose not. Choose a failing condensation lexicographically
by:

    (number of vertices, total integral capacity,
     number of ordered distinct-vertex reachability relations).

All three entries are nonnegative integers. Parallel capacities may
be combined while retaining their distinguished original units.
Adding capacity-zero transitive arrows does not change any entry,
ideal, or packing, so use a transitive topology.

The reviewed quotient closure and fixed-q reverse reductions apply
to the common-source class, as in Section 4. Minimality in the first
two entries gives a strict binary form with exactly two missing
pairs, every positive capacity one, separated support, every
positive unit incident with a two-tight original terminal, every
nonterminal original dicut of capacity at least three, and the
star contact restriction.

These are properties of the chosen minimum failure itself, not an
assumption that arbitrary modified inputs remain normal. Each
reviewed contradiction establishing a property decreases the first
or second entry; it is unaffected by the new third tie-breaker.

If there is no active contact, the independently accepted complete
contact-free theorem, Section 10, packs this form. If there is a
contact, choose its head n and construct D_n by Section 12.
It has the same number of vertices, the same total capacity, the
same missing pairs and minimum dicut capacity at least two.
Its third entry is strictly smaller. A packing of D_n would be a
packing of D, so D_n is itself a failure, contradicting the chosen
lexicographic minimum.

Both alternatives are impossible. This proves the theorem. QED.

**Active-contact consequence.** Every strict binary star form with
at least one active contact has an original-unit two-packing, with
arbitrary outside footprints and without a forest hypothesis.
This is now an unconditional consequence, not the assertion that
the contact-free theorem can be applied directly to D_n.

There is also a well-founded reconstruction reading of the proof.
A recursive ambient call either uses the reviewed reductions with
strict decrease in vertices or total capacity, reaches the accepted
contact-free strict case, or uses erasure with strict decrease in
the third entry. Erasure keeps the unit labels unchanged. On return
it requires no expansion at all; the packing already covers every
original ideal. Only the previously reviewed quotient, gluing and
capacity-unit shortcut steps have actual expansion obligations.
Their assigned-color reconstruction is reused unchanged.

Thus both ordinary cuts and C1,C2,C12 are met by one partition of
the original units, not by separately reconstructed colorings.
Each original two-tight terminal is saturated by the two colors.
Every positive unit of a strict form touches such a terminal, so
the partition uses each distinguished original unit exactly once.
No shared-source input is duplicated, even if it contacts several
outputs at both exceptional sinks. Capacity-zero arcs discarded in
the auxiliary weakening still belong to D and are all restored
when the unchanged original packing is read in D.

The previous strongest accepted star result was the whole contact-free
strict binary theorem, with active contacts still open. The improvement
is the unrestricted ambient binary theorem. It avoids any uniform
matching that purports to preserve two independently minimized folds:
one edge-deletion bound for the original weighted contact-cover
problems controls every ordinary family simultaneously.

## 14. Integral-capacity two-defect theorem

**Theorem.** For every integer q>=1, a finite digraph whose full-topology
condensation has at most two missing ordered source-sink pairs and
whose nonnegative integral capacities give every original dicut
capacity at least q has q capacity-feasible original dijoins.
Zero-length paths count, all original capacity-zero topology is retained,
and each member is an original arc set.

**Proof.** With no dicuts take q empty members. With at most one
missing pair use the independently accepted one-defect theorem.
For exactly two missing pairs there are precisely the three
configurations of `packing.md`, Section 1.

For a common source, Section 13 supplies the ambient binary premise
of the independently accepted parameter-reduction theorem in Section 4.
That theorem gives all q, using actual reserved original capacities,
strictly smaller palette parameters, and the reviewed original-capacity
reverse reductions. It does not need a strict form for a recursive
reserved ambient input.

For a common sink, reverse all original arrows, apply the common-source
statement with the same capacities, and reverse back. Complementation
of shores identifies the original dicuts exactly and preserves every
arc's number of uses.

For two distinct sources and two distinct sinks use the independently
accepted arbitrary-q matching theorem,
`donorless_full_unit.md`, Sections 2-5. Its original-capacity
reconstruction and the one-defect reconstruction are unchanged.
These cases exhaust the two missing pairs and prove the theorem. QED.

This is a proof submission, not an independent acceptance or a novelty
verdict. It is not a counterexample to Woodall's conjecture. The weighted
statement implies the unit-capacity packing theorem for this structural
class, but does not assert the conjecture for unrestricted digraphs.

## 15. Exact new native erasure examples

`star_active_contact.py` is a standard-library, independently rerunnable
replay for four new strict native inputs. Every input has 16 vertices,
12 distinct positive units, both positive inputs at s internal, and
four internal positive outputs into the exceptional sinks. The cases
use separated contacts, contacts shared by both inputs, an output tail
reaching both exceptional sinks, and unequal regular-sink footprints.
Every other topology arc has capacity zero.

The replay enumerates every proper ideal before and after erasing
contacts into head 7. It checks all source/sink footprints, exactly the
two original missing pairs, strict original nonterminal slack, all
34 projected minima per case against the literal original ideals,
every unchanged exceptional canonical core, and one simultaneous
original-unit coloring covering both topologies.

| Case | Topology arcs, before/after | Proper ideals, before/after | Projected rows decreased |
|---|---:|---:|---:|
| separated | 45 / 43 | 530 / 731 | 9 |
| shared | 58 / 54 | 365 / 533 | 4 |
| common tail | 53 / 50 | 387 / 543 | 5 |
| unequal outside footprints | 50 / 48 | 454 / 626 | 8 |

All 136 projected comparisons lose at most one; every singleton
comparison loses zero. All 12 exceptional cores are unchanged.
The source/sink subsets and their attained minima, original unit
identities, both full topologies and explicit colorings are in
`star_active_contact.certificate.json`. In the first input the
sink-side row C={2,4} has minimum three before erasure and two
afterward. This is a deliberate new nonterminal two-tight cut,
demonstrating why applying Section 10 directly to the erased input
would be unjustified.

Replay the new construction, without any accepted earlier checks, with

```bash
PYTHONDONTWRITEBYTECODE=1 python3 research/two_defect/star_active_contact.py
```

The finite replay is not the universal theorem. The latter is the
exact cover inequality and lexicographic argument in Sections 12-14,
which retain arbitrary footprints rather than enumerating them.

Before the new finite replay the live Argus adapter discovered and
inspected `discrepancy.theory.eval.compute`. Its exact input is
`star_active_contact.jacobian_payload.json`: the seven inclusion-minimal
positive boundaries of the first erased topology, on its 12 original
unit labels, together with the displayed signed coloring.
The typed result in `star_active_contact.jacobian_result.json` reports
signed sums (0,0,0,0,0,0,1) and maximum absolute imbalance one.
Each boundary therefore has both colors. The complete-ideal replay
establishes that these seven boundaries suffice for that particular
input.

The archived discovery and inspection JSON, exact payload and exact
typed result retain server version 0.14.0, protocol 2025-11-25 and
operation id. The adapter exited zero; its structured result reports
runtime zero milliseconds, with no error or timeout. This is one
bounded evaluation, not a sidecar proof of the universal theorem or
a claim inferred from UNKNOWN.

## 16. Focused primary-source contribution comparison

This comparison was separately read by the source-research worker
`star-primary-comparison`. It is not the required independent
mathematical or publication review. No new external theorem beyond
the already accepted proof inputs is used in Sections 12-14.

**Schrijver's source-sink-connected theorem.** A. Schrijver,
*Min-max relations for directed graphs* (1982),
DOI [10.1016/S0304-0208(08)72456-3](https://doi.org/10.1016/S0304-0208(08)72456-3),
Theorem 4, printed page 271, applies to an acyclic topology in which
every source reaches every sink. If a selectable arc subset meets
every dicut at least k times, it partitions into k dijoins.
The strong-component and parallel-arc interpretations in Section 0,
page 263, give the weighted formulation. Thus the zero-missing-pair
subclass here is prior work, not a contribution of this note.
Theorem 5, page 274, is the more general strong-connector min-max
theorem with a source-sink-connected acyclic backbone; it does not
state a two-missing-pairs hypothesis.

**ACZ's numerical and stronger structural criteria.** A. Abdi,
G. Cornuejols and G. Zlatin,
[arXiv:2202.00392v3](https://arxiv.org/pdf/2202.00392v3),
version of 30 March 2022, Theorems 3.14 and 5.15, pages 37 and 47,
give integral-capacity q-packings under respectively rho<=1 and
rho<=2, where

    rho(q,D,w) = (1/q) sum_v
        ((w(delta+(v))-w(delta-(v))) mod q).

Their stronger applicable conditions are not merely numerical.
For a sink-regular weighted (q,q+1)-bipartite digraph with 0-1
weights and every dicut of weight at least q, Theorem 5.11, page 46,
uses strong base orderability of M1. Theorem 6.5, page 50, instead
requires the active vertices to partition as an admissible set Q
and a (q-1)-admissible set Q', with M1 restricted to Q' strongly
base orderable. Admissibility uses common bases of M0,M1;
k-admissibility allows their k-basis decompositions to differ.
Theorem 2.12, page 29, supplies the relevant decomposition/lifting
and reconstruction mechanism.

Consequently, a separation from rho<=2 alone would not establish
novelty against ACZ. Neither the primary statements obtained nor
this note prove that their stronger conditions hold on suitable
lifts for the entire two-defect class, or prove that no such
subsumption is possible. Their unweighted dijoin plus
(q-1)-dijoin statement, Theorem 4.13, page 43, is not a general
q-packing conclusion and is not substituted for one here.

**Williams's earlier minimal obstructions.** A. M. Williams,
*Packing Directed Joins*, Waterloo MMath thesis (2004),
[handle 10012/1024](https://hdl.handle.net/10012/1024),
Proposition 7.6, printed page 87 (PDF page 94), excludes four
s-paths in a minimally non-knitted weighted digraph. The
augmented-minor and lexicographic minimality hypotheses in
Definitions 4.9 and 4.18 and the positive-support s-path
definition are not the two-missing-pairs hypothesis here.
The primary description of D1 in Section 3.4, printed page 32,
says that each of its three sources reaches exactly two of its
three sinks; its defect is therefore exactly three. Its weighted
minimum-two, maximum-one packing obstruction lies outside this
theorem. The stronger detailed comparison with Williams-Guenin
2005 remains unavailable and was not retried.

One focused current primary-source lookup obtained no direct
at-most-two-missing-pairs packing statement. This is a retrieval
result, not proof of absence. Relative to the strongest accepted
project result, the new mathematical step is unit-head erasure
and the resulting unrestricted ambient binary star theorem;
the all-q reduction and matching theorem are inherited. Priority,
class-wide subsumption by earlier methods, and publishable
significance must still be independently decided. No
`novelty_status=verified_new` or campaign completion is asserted.
