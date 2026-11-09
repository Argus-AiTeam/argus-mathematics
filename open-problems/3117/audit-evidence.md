# ID 3117 - coloring graph fractional powers

**Audit cutoff:** 2026-08-27  
**Producer decision:** `refuted`  
**Claim alignment:** `exact`  
**Evidence level:** `exact_computational_certificate`  
**Review status:** `pending_independent_review`

## CSV-ready fields

```yaml
resolution_status: refuted
claim_alignment: exact
evidence_level: exact_computational_certificate
resolution_date: 2012-12-17
source_urls: "https://arxiv.org/abs/1212.3898v1; https://arxiv.org/pdf/1212.3898v1; https://arxiv.org/html/1212.3898v1; https://doi.org/10.48550/arXiv.1212.3898; https://arxiv.org/abs/0812.1542v3; https://doi.org/10.1016/j.disc.2010.01.017"
source_location: "Hartke-Liu-Petrickova, arXiv:1212.3898v1, definition and Conjecture 1 p.1, triangular-prism announcement p.2, clique formula Lemma 2.1 p.3, Lemma 5.1 and Proposition 5.2 with Figure 6 pp.8-9; bounded exact replay and Jacobian transcript in evidence/3117/README.md"
audit_notes: "The source conjecture exactly matches the input. For H=C3 square K2, H is connected and 3-regular, while m=3 and n=5 satisfy 1<m<n. Proposition 5.2 proves omega(H^(3/5))=5 and derives a contradiction from any 5-coloring. An independent construction of the 5-subdivision gives 42 vertices and its distance-at-most-3 power gives 162 edges; complete Bron-Kerbosch and fixed-K5 DSATUR replay yields omega=5, no 5-coloring after 5185 search nodes, and a 6-coloring after 38 nodes, hence chi=6>5=omega. The inspected Jacobian k-colorability contract matched the 42-vertex graph, but its bounded run returned EXECUTION_FAILED and is explicitly a non-conclusion."
review_status: pending_independent_review
```

## Exact conjecture and primary-source counterexample

Hartke, Liu, and Petrickova define \(G^{m/n}\) as the \(m\)-th power of
the \(n\)-subdivision of \(G\): every edge is replaced by a path of length
\(n\), then distinct vertices at subdivision distance at most \(m\) are
joined.

Conjecture 1 on printed p.1 is:

> If \(G\) is a connected graph with \(\Delta(G)\ge3\) and
> \(1<m<n\), then
> \(\chi(G^{m/n})=\omega(G^{m/n})\).

The introduction on printed p.2 says this is false for the Cartesian product
\(C_3\square K_2\), the triangular prism, with \(m=3,n=5\).
Proposition 5.2 on printed p.9 states:
\[
  G=C_3\square K_2
  \quad\Longrightarrow\quad
  \chi(G^{3/5})>\omega(G^{3/5}).
\]

Its proof invokes the odd-\(m\) clique formula
\[
  \omega(G^{m/n})=\frac{m-1}{2}\Delta(G)+2
\]
and obtains
\[
  \omega((C_3\square K_2)^{3/5})=5.
\]
Lemma 5.1 forces every crust to be monochromatic in a hypothetical
five-coloring. Six crusts and five colors force two nonadjacent crusts to
share a color. Proposition 5.2 then follows the forced occurrences of that
color around the prism until no eligible vertex remains near \(v_2\), a
contradiction. Figure 6 is captioned that the graph is not 5-colorable.

The arXiv API records only v1, submitted 2012-12-17T06:36:15Z. That public
date is used for `resolution_date`.

## Quantifier and object check

Write the prism vertices as
\[
  a_0,a_1,a_2,b_0,b_1,b_2
\]
with two triangle edge sets and matching edges \(a_i b_i\).

| Required condition | Witness check |
|---|---|
| finite simple connected \(G\) | the two triangles are joined by three matching edges |
| \(\Delta(G)\ge3\) | every prism vertex has two triangle neighbors and one matching neighbor, so \(\Delta=3\) |
| \(m>1\) | \(m=3\) |
| \(n>m\) | \(n=5>3\) |
| exact fractional-power convention | every original edge is a length-5 path and the third power joins subdivision distance at most 3 |

This is an exact witness, not a counterexample to a neighboring convention.
The section introduction writes \(C_3\square P_2\) once, while the
introduction, Proposition 5.2, and Figure 6 use \(C_3\square K_2\);
\(P_2\cong K_2\) under the paper's two-vertex-path convention.

## Independent finite replay

The base edges were ordered as

```text
(a0,a1), (a1,a2), (a2,a0),
(b0,b1), (b1,b2), (b2,b0),
(a0,b0), (a1,b1), (a2,b2).
```

Indices 0 through 5 are `a0,a1,a2,b0,b1,b2`. For base edge `e`,
indices `6+4e` through `9+4e` are its four internal vertices in path
order. The 5-subdivision therefore has
\[
  6+9\cdot4=42\text{ vertices and }9\cdot5=45\text{ edges}.
\]
Breadth-first distance through the subdivision adds every pair at distance
1, 2, or 3, producing 162 edges.

Two complete finite searches were then performed on that exact adjacency
list:

1. Bron-Kerbosch maximal-clique enumeration visited 89 search nodes and
   proved \(\omega=5\), with clique indices `[0,6,17,30,7]`.
2. A DSATUR backtrack fixed those five clique vertices to five distinct
   colors. This loses no five-coloring because any coloring of a \(K_5\)
   differs only by a color permutation. The complete five-color search
   visited 5185 nodes and found none. A six-color search visited 38 nodes
   and returned the coloring

```text
[0,1,1,2,3,3,1,4,2,0,3,2,0,4,3,5,4,2,3,1,0,
 2,4,0,1,2,0,5,1,4,3,4,1,0,4,2,0,1,2,0,5,4]
```

Every edge has differently colored endpoints. Thus the independent replay
gives the exact values
\[
  \chi((C_3\square K_2)^{3/5})=6
  >5=
  \omega((C_3\square K_2)^{3/5}),
\]
agreeing with Proposition 5.2.

## Jacobian contract and bounded run

Candidate discovery used the Argus isolated adapter, not a Jacobian import.
The server reported:

```text
server: jacobian 0.14.0
protocol_version: 2025-11-25
transport: mcp-stdio
```

The initially discovered exact invariant operations
`graph.invariant.chromatic_number.compute` and
`graph.invariant.clique_number.compute` admit at most 32 vertices, so they
were not forced onto this 42-vertex graph. A second targeted discovery found
`graph.coloring.k_colorability.decide`. Its inspected typed contract admits
at most 256 vertices and 2016 edges, requires integer-indexed simple
undirected adjacency, and bounds work by an explicit
`solver_conflicts <= 1000000`. `DECIDED` is a conclusion;
`SOLVER_BUDGET_EXCEEDED` and `EXECUTION_FAILED` are not.

The exact operation and payload were:

```text
operation_id: graph.coloring.k_colorability.decide
```

```json
{"graph":{"vertex_count":42,"edges":[[0,6],[0,7],[0,8],[0,15],[0,16],[0,17],[0,30],[0,31],[0,32],[1,7],[1,8],[1,9],[1,10],[1,11],[1,12],[1,34],[1,35],[1,36],[2,11],[2,12],[2,13],[2,14],[2,15],[2,16],[2,38],[2,39],[2,40],[3,18],[3,19],[3,20],[3,27],[3,28],[3,29],[3,31],[3,32],[3,33],[4,19],[4,20],[4,21],[4,22],[4,23],[4,24],[4,35],[4,36],[4,37],[5,23],[5,24],[5,25],[5,26],[5,27],[5,28],[5,39],[5,40],[5,41],[6,7],[6,8],[6,9],[6,16],[6,17],[6,30],[6,31],[7,8],[7,9],[7,17],[7,30],[8,9],[8,10],[8,34],[9,10],[9,11],[9,34],[9,35],[10,11],[10,12],[10,13],[10,34],[10,35],[11,12],[11,13],[11,34],[12,13],[12,14],[12,38],[13,14],[13,15],[13,38],[13,39],[14,15],[14,16],[14,17],[14,38],[14,39],[15,16],[15,17],[15,38],[16,17],[16,30],[17,30],[17,31],[18,19],[18,20],[18,21],[18,28],[18,29],[18,32],[18,33],[19,20],[19,21],[19,29],[19,33],[20,21],[20,22],[20,37],[21,22],[21,23],[21,36],[21,37],[22,23],[22,24],[22,25],[22,36],[22,37],[23,24],[23,25],[23,37],[24,25],[24,26],[24,41],[25,26],[25,27],[25,40],[25,41],[26,27],[26,28],[26,29],[26,40],[26,41],[27,28],[27,29],[27,41],[28,29],[28,33],[29,32],[29,33],[30,31],[30,32],[30,33],[31,32],[31,33],[32,33],[34,35],[34,36],[34,37],[35,36],[35,37],[36,37],[38,39],[38,40],[38,41],[39,40],[39,41],[40,41]]},"colors":5,"solver_conflicts":1000000}
```

The exact typed output was:

```json
{"colorable":null,"coloring":null,"colors":5,"graph":{"edges":[[0,6],[0,7],[0,8],[0,15],[0,16],[0,17],[0,30],[0,31],[0,32],[1,7],[1,8],[1,9],[1,10],[1,11],[1,12],[1,34],[1,35],[1,36],[2,11],[2,12],[2,13],[2,14],[2,15],[2,16],[2,38],[2,39],[2,40],[3,18],[3,19],[3,20],[3,27],[3,28],[3,29],[3,31],[3,32],[3,33],[4,19],[4,20],[4,21],[4,22],[4,23],[4,24],[4,35],[4,36],[4,37],[5,23],[5,24],[5,25],[5,26],[5,27],[5,28],[5,39],[5,40],[5,41],[6,7],[6,8],[6,9],[6,16],[6,17],[6,30],[6,31],[7,8],[7,9],[7,17],[7,30],[8,9],[8,10],[8,34],[9,10],[9,11],[9,34],[9,35],[10,11],[10,12],[10,13],[10,34],[10,35],[11,12],[11,13],[11,34],[12,13],[12,14],[12,38],[13,14],[13,15],[13,38],[13,39],[14,15],[14,16],[14,17],[14,38],[14,39],[15,16],[15,17],[15,38],[16,17],[16,30],[17,30],[17,31],[18,19],[18,20],[18,21],[18,28],[18,29],[18,32],[18,33],[19,20],[19,21],[19,29],[19,33],[20,21],[20,22],[20,37],[21,22],[21,23],[21,36],[21,37],[22,23],[22,24],[22,25],[22,36],[22,37],[23,24],[23,25],[23,37],[24,25],[24,26],[24,41],[25,26],[25,27],[25,40],[25,41],[26,27],[26,28],[26,29],[26,40],[26,41],[27,28],[27,29],[27,41],[28,29],[28,33],[29,32],[29,33],[30,31],[30,32],[30,33],[31,32],[31,33],[32,33],[34,35],[34,36],[34,37],[35,36],[35,37],[36,37],[38,39],[38,40],[38,41],[39,40],[39,41],[40,41]],"vertex_count":42},"solver_conflicts":1000000,"status":"EXECUTION_FAILED","vertex_count":42}
```

Adapter process status was exit 0, runtime 29,733 ms, and external timeout
was false. The typed operation status is nevertheless `EXECUTION_FAILED`.
Accordingly the Jacobian run is a preserved non-conclusion and supplies no
support for either colorability answer. The mathematical decision rests on
the primary-source proof and the separate complete finite replay above.

## Decision

The triangular prism satisfies every quantified hypothesis and its exact
fractional power has chromatic number strictly larger than clique number.
The universal conjecture is therefore `refuted`, with exact claim alignment.
