# A uniform square-root edge deficit

## Theorem and scope

Let \(G\) be a finite simple undirected graph with minimum degree at least
three. Suppose that \(G\) has no simple cycle of length four or eight and
that no proper subgraph of \(G\), **including non-induced subgraphs**, has
minimum degree at least three. Put
\[
 n=|V(G)|,\qquad m=|E(G)|,\qquad d=2n-m.
\]
Then
\[
 \boxed{n\leq 4d^2.}                                      \tag{T}
\]
More precisely, for a nonempty graph,
\[
 \boxed{d\geq2,\qquad
 n\leq\max\{8d,\,4d^2-8d\}.}                              \tag{T+}
\]
In particular, if \(d\geq4\), then \(n\leq4d(d-2)\).
All cycles here are subgraphs: a chord does not invalidate a cycle.

This is a parameter-uniform proof, not an order-bounded search. It has no
essential finite lemma and uses no external theorem. Independent Reviewer
acceptance of all seven associated mathematical claims was recorded on
2026-11-03 in `roles/reviewer/progress.json`. Originality and
publication-level significance require a separate primary-source assessment;
mathematical acceptance alone does not establish either.

## Starting evidence and literature scope

This section records the earlier mathematical handoff. The contemporary
publication assessment, including the September 2026 results and attribution
of inherited projection/doubling methods, is in
[POSITIONING.md](POSITIONING.md). It does not change the proof below.

The independently reviewed campaign claims
`C_FOUR_DEFECT_EXTREMAL_LAYER` and
`C_MINIMAL_EDGE_BOUND_FOUR_DEFECT` establish the strong \(m=2n-6\)
layer exclusion and the minimal-counterexample bound \(m\leq2n-7\).
Their incidence and component-sponsor arguments appear in
`research/four_defect_incidence_core/PROOF.md`; the identities are reproved
below for arbitrary \(d\). None of that proof's finite kernel enumeration
or thread-length bounds is used here.

A focused retrieval obtained **no verified applicable order-deficit
theorem**. This is a retrieval outcome, not proof of novelty. Two primary
sources were opened:

- Narins, Pokrovskiy, and Szabo, *Graphs without proper subgraphs of minimum
  degree 3 and short cycles*, arXiv:1408.5289v1, abstract. Its principal
  counterexamples concern **induced** criticality with \(m=2n-2\); its
  separate characterization concerns non-induced criticality at that
  same fixed density.
- Di Braccio, Katsamaktsis, Ma, Malekshahian, and Zhao, *Leaf-to-leaf paths
  and cycles in degree-critical graphs*, arXiv:2504.11656v1, Section 1,
  definition of degree 3-critical and Theorem 1. That definition explicitly
  requires \(m=2n-2\) and excludes proper **induced** subgraphs. Theorem 1
  counts distinct cycle lengths, not an order bound in terms of \(d\).

The stronger criticality in (T) cannot be replaced by these induced-only
definitions. Those results are not assumptions of (T). The earlier
reviewed \(m\leq2n-7\) result is used only in the final comparison and is
named as a dependency in the claim ledger.

## 1. Basic criticality and incidence identities

If an empty graph is admitted by the minimum-degree convention, its
conclusion is immediate. Hence assume \(G\) is nonempty. Then \(n\geq4\)
and \(G\) has an edge \(e\). Every nonempty subgraph of \(G-e\) is a proper
subgraph of \(G\), so it has a vertex of degree at most two. Thus \(G-e\)
is 2-degenerate. A deletion ordering gives
\[
 |E(G-e)|\leq0+1+2(n-2)=2n-3.
\]
Consequently \(m\leq2n-2\) and \(d\geq2\).

Write
\[
 L=\{v:\deg_G(v)=3\},\quad H=\{v:\deg_G(v)\geq4\},\quad
 \ell=|L|,\quad h=|H|,\quad F=G[L].
\]
Deleting an edge between two members of \(H\) would preserve minimum
degree three. Therefore \(H\) is independent. If \(h=0\), then \(G\) is
cubic, \(d=n/2\), and both (T) and (T+) follow immediately. Assume \(h>0\).
In particular \(L\) is nonempty.

No vertex of \(L\) is isolated in \(F\): deleting such a vertex lowers each
of its three distinct high neighbours by only one and preserves minimum
degree three. For \(i=1,2,3\), let \(a_i\) count the vertices of degree
\(i\) in \(F\). Let \(D=e_G(H,L)\). Counting degrees and incidences gives
\[
 D=\ell+4h-2d=2a_1+a_2,\qquad e(F)=\ell-2h+d,
\]
and hence
\[
 \boxed{a_1-a_3=4h-2d.}                                  \tag{1}
\]

Let \(c\) be the number of components of \(F\), and let
\(t=e(F)-\ell+c\geq0\) be their total cycle rank. Then
\[
 c=2h-d+t.
\]
For each component \(K\) of \(F\), delete \(V(K)\). The remaining graph is
nonempty because it contains \(H\). Every remaining low vertex retains
degree three, so some \(z\in H\) has degree at most two in the remaining
graph. Thus
\[
 |N_G(z)\cap V(K)|\geq\deg_G(z)-2.
\]
Call such a \(z\) a sponsor. A degree-four vertex can sponsor at most two
components; a vertex of degree at least five can sponsor at most one.
Indeed, the relevant neighbour sets in distinct components are disjoint,
and \(2(k-2)>k\) when \(k\geq5\).

Set
\[
 P=\{z\in H:\deg_G(z)\geq5\},\qquad p=|P|.
\]
Counting possible sponsorships gives \(c\leq2h-p\), so
\[
 \boxed{p+t\leq d,\qquad 0\leq p\leq d.}                  \tag{2}
\]
This argument does not assume that \(F\) is a forest.

## 2. The leaf-incidence graph

Represent each degree-one vertex of \(F\) by an edge between its two high
neighbours. This gives a graph \(R\) on \(H\) with \(a_1\) edges. It is
simple: two represented vertices with the same high-neighbour pair would
give a simple \(C_4\) in \(G\). It is \(C_4\)-free: a four-cycle in \(R\)
lifts through its four distinct represented low vertices to a simple
\(C_8\) in \(G\).

Put \(S=\sum_{z\in P}\deg_R(z)\). If
\(b_x=|N_R(x)\cap P|\), then two distinct members of \(P\) have at most
one common neighbour in \(R\). Consequently
\[
 \sum_{x\in H}\binom{b_x}{2}\leq\binom p2.
\]
Since \(b\leq1+\binom b2\) for every integer \(b\geq0\), double counting
gives
\[
 \boxed{S=\sum_{x\in H}b_x\leq h+\binom p2.}              \tag{3}
\]
Triangles in \(R\) do not affect this common-neighbour inequality.

Partition the degree-two vertices of \(F\) into \(Q\), whose unique high
neighbour lies in \(P\), and \(W\), whose unique high neighbour lies in
\(H\setminus P\). Write \(q=|Q|\) and \(r=|W|\).
Every member of \(H\setminus P\) has degree four. Its neighbours consist
of represented degree-one vertices and members of \(W\). Exactly
\(2a_1-S\) represented incidences meet \(H\setminus P\). Therefore
\[
 \boxed{r=4(h-p)-2a_1+S.}                                \tag{4}
\]
This exact identity, rather than a separate bound on \(h\), will make the
high-vertex terms cancel.

## 3. A global count of low two-edge paths

Let \(J=F[Q]\). Every vertex of \(J\) has degree at most two. Label each
vertex of \(Q\) by its unique high neighbour in \(P\). For each vertex
\(y\) of degree two in \(J\), its two distinct neighbours \(x,z\) determine
one unoriented two-edge path \(x,y,z\).

Its endpoint labels are distinct. Otherwise, if both were \(u\), the
four distinct vertices \(u,x,y,z\) would give a \(C_4\).
Assign the path to the unordered pair of its endpoint labels.

Two paths assigned to the same pair \(\{u,v\}\) cannot have disjoint sets
of low vertices. Orient their endpoints to have labels \(u,v\); if the
paths were \(x,y,z\) and \(x',y',z'\), then
\[
 u,x,y,z,v,z',y',x',u
\]
would be a simple eight-cycle. The two high vertices and the six low
vertices are all distinct. Additional edges or chords are immaterial.

Fix one path \(x,y,z\) assigned to a particular pair. Every other path
assigned to that pair intersects \(\{x,y,z\}\). Its middle vertex therefore
lies in the closed neighbourhood of that set in \(J\).
This neighbourhood has at most five vertices: \(y\) has exactly the
neighbours \(x,z\), and each of \(x,z\) has at most one further neighbour.
Since a degree-two middle vertex determines only one unoriented path,
there are at most **five paths per label pair**.

If \(q_2\) counts the degree-two vertices of \(J\), it follows that
\[
 q_2\leq5\binom p2.                                      \tag{5}
\]
The count is global, not per component: paths in different components are
disjoint. It also covers triangles and all other cyclic components of
\(J\). No assertion that intersecting paths already give a cycle is used.

Each of the other \(q-q_2\) vertices of \(Q\) has at least one of its two
\(F\)-neighbours outside \(Q\). The complement \(L\setminus Q\) consists
of the \(a_1\) degree-one vertices, the \(a_3\) degree-three vertices, and
the \(r\) vertices of \(W\). Thus
\[
 q-q_2\leq e_F(Q,L\setminus Q)\leq a_1+3a_3+2r,
\]
and (5) yields
\[
 \boxed{q\leq5\binom p2+a_1+3a_3+2r.}                    \tag{6}
\]
Branching vertices and path endpoints are charged to this boundary.
Isolated vertices of \(J\) have two boundary edges, so they also satisfy
the inequality.

## 4. Cancellation and the explicit constant

Using (6), (4), (1), and finally (3), in that order,
\[
\begin{aligned}
 n&=h+a_1+a_3+r+q\\
  &\leq h+2a_1+4a_3+3r+5\binom p2\\
  &=13h-4a_1+4a_3-12p+3S+5\binom p2\\
  &=-3h+8d-12p+3S+5\binom p2\\
  &\leq8d-12p+8\binom p2\\
  &=8d+4p^2-16p.                                       \tag{7}
\end{aligned}
\]
Because \(0\leq p\leq d\), one has \(p^2\leq dp\). If \(2\leq d\leq4\),
then \(4p^2-16p\leq4(d-4)p\leq0\). If \(d\geq4\), then
\[
 4p^2-16p\leq4(d-4)p\leq4(d-4)d.
\]
Equation (7) proves (T+). Finally \(8d\leq4d^2\) for \(d\geq2\), while
\(4d^2-8d\leq4d^2\), proving (T).

The argument includes the cubic case and all small deficits without
depending on an unverified enumeration. It permits arbitrary cycle rank,
branching low components, repeated labels on adjacent vertices, and
overlapping paths.

## 5. Minimal Erdos-Gyarfas counterexamples and the reviewed bound

Suppose a finite counterexample to the power-of-two-cycle conjecture
exists, and choose \(G\) first with minimum order and then minimum size.
Every proper subgraph with minimum degree at least three would itself
avoid all power-of-two cycles. If it is connected and spanning, it
contradicts minimum size. Otherwise one of its connected components is a
smaller-order counterexample. Hence \(G\) satisfies the exact non-induced
criticality of (T), as well as the absence of \(C_4,C_8\).

In particular,
\[
 \boxed{m\leq2n-\left\lceil\frac{\sqrt n}{2}\right\rceil},
 \qquad
 \sum_v(\deg_G(v)-3)
 \leq n-2\left\lceil\frac{\sqrt n}{2}\right\rceil.          \tag{8}
\]
This does not assert that a counterexample exists.

The strongest earlier reviewed campaign bound
`C_MINIMAL_EDGE_BOUND_FOUR_DEFECT` gives \(d\geq7\).
Combining it with (T+), not weakening or rechecking that result, gives
\[
 n\leq4d(d-2),\qquad
 \boxed{m\leq2n-
 \max\left\{7,\left\lceil1+\frac{\sqrt{n+4}}2\right\rceil\right\}}.
                                                               \tag{9}
\]
The total degree excess is at most \(n\) minus twice the maximum in (9).
For example, deficit seven now forces \(n\leq140\).
The integer edge bound (9) is strictly stronger than \(m\leq2n-7\) for
every \(n\geq141\). Asymptotically it gives
\[
 m\leq2n-\tfrac12\sqrt n-1+o(1),
\]
instead of a constant deficit. It does not settle the conjecture or give
a finite upper bound on the order of all possible counterexamples:
\(d\) is not bounded independently of \(n\).

## Bounded Jacobian move

The Argus sidecar's operation `graph.cycle.fixed_length.decide` was
discovered and its exact typed contract inspected before execution.
The dedicated payload in `jacobian-payload.json` displays two disjoint
low two-edge paths with the same distinct high endpoint labels; two
additional chords deliberately preserve the non-induced cycle semantics.
The operation checks only this eight-vertex instance, not the universal
argument. The complete typed discovery, contract, result, and adapter
status are retained in the adjacent dedicated JSON files.

With server version `0.14.0`, protocol `2025-11-25`, and adapter exit status
zero, the operation returned `EXISTS` and the ordered simple eight-cycle
`["A","x1","y1","z1","B","z2","y2","x2"]`. The retained payload, echoed graph,
operation identifier, eight distinct vertices, and all eight cycle edges
were checked exactly. No adapter error or timeout occurred.
The bounded move can be rerun from the campaign directory with:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  -m argus_skill.tools.jacobian run \
  --operation graph.cycle.fixed_length.decide \
  --payload-file research/uniform_edge_deficit/jacobian-payload.json
```

This result certifies only the displayed local cycle. The universal
five-path bound and the theorem are the independently reviewed prose
arguments above; their acceptance does not rely on this bounded fixture.
