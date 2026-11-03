# Candidate 20001159: balanced-circulant classification

## Verdict

`CONFIRMED_COUNTEREXAMPLE` with a published corrected classification.

The connected graph

\[
K_{3,3}=\operatorname{Circ}(6;\{1,3\})
\]

is nonempty, balanced, and circulant, but it cannot be isomorphic to any
\(G_B(k,m)\).  Every \(G_B(k,m)\) has \(4km\) vertices, whereas the witness
has six vertices.

This is stronger than the easy disconnected objection to the literal AIM
statement: the witness is connected and contains cycles.  The absolute
smallest counterexample is already \(K_2=K_{1,1}\); \(K_{3,3}\) is used as
the primary witness to avoid a degenerate one-edge example.

## Exact claim and source audit

The candidate row is
`/home/argustest/zimo/counterexample-batch-1/inputs/priority_pool.csv:69`.
It points to §K.1, printed page 19, of the AIM perfect-graph problem list:

> Every non-empty balanced circulant is isomorphic to a G(k,m).

Source: <https://aimath.org/WWN/perfectgraph/perfectgraph.pdf>

There \(G_B(k,m)\) has vertex set \(\mathbb Z_{4km}\), with two vertices
adjacent exactly when their difference is congruent to \(+1\) or \(-1\)
modulo \(4m\).

The authors' 2005 DIMACS report explicitly restricts its discussion to
connected circulants in §1, but repeats the classification as Conjecture 3.3
in §3 and reports a computer test through 60 vertices.

Sources:

- <https://archive.dimacs.rutgers.edu/TechnicalReports/abstracts/2005/2005-06.html>
- <https://archive.dimacs.rutgers.edu/TechnicalReports/TechReports/2005/2005-06.ps.gz>

Thus the counterexample is exactly aligned with both the literal AIM claim
and the later connected convention.

## Direct verification of the witness

Label the vertices by \(\mathbb Z_6\) and join vertices whose difference has
undirected length 1 or 3.  The edge set is

```text
01 03 05 12 14 23 25 34 45
```

1. Rotation \(i\mapsto i+1\pmod 6\) preserves the edge set and acts
   transitively, so this is a circulant.
2. The even vertices \(\{0,2,4\}\) and odd vertices \(\{1,3,5\}\) form a
   bipartition, and every cross pair is an edge.  Hence the graph is
   \(K_{3,3}\).
3. Every induced cycle in a complete bipartite graph is a 4-cycle: a cycle
   of length at least six has a chord.  Therefore the graph is balanced.
   The finite checker independently enumerates all induced cycles and finds
   exactly nine induced 4-cycles and no other induced-cycle length.
4. Isomorphism preserves vertex count.  Since \(6\ne4km\) for positive
   integers \(k,m\), the graph is not in the proposed family.

Run the independent finite checker with:

```bash
python checker.py --output checker_output.json
```

## Published corrected classification

Morris, Spiga, and Webb proved that every connected balanced Cayley graph on
an abelian group is an \((\ell,t)\)-cycle, where either \(\ell=2\), or
\(\ell\ge8\) and \(4\mid\ell\).  A connected circulant is a Cayley graph on
a cyclic, hence abelian, group, so their theorem applies directly.

Source: Joy Morris, Pablo Spiga, Kerri Webb, *Balanced Cayley graphs and
balanced planar graphs*, Discrete Mathematics 310 (2010), 3228–3235,
Theorem 1.2, DOI `10.1016/j.disc.2009.11.002`.

- Preprint: <https://arxiv.org/abs/0707.0155>
- Journal record: <https://doi.org/10.1016/j.disc.2009.11.002>

In AIM notation,

\[
G_B(k,m)=C_{4m}[\overline{K_k}].
\]

For \(m\ge2\), these are exactly the corrected theorem's cases with
\(\ell=4m\ge8\).  For \(m=1\),

\[
G_B(k,1)=K_{2k,2k}.
\]

Therefore a precise corrected connected statement is:

> Every nonempty connected balanced circulant is either \(G_B(k,m)\) with
> \(m\ge2\), or \(K_{t,t}\) with \(t\ge1\).

Relative to the original AIM family, the omitted connected graphs are
exactly \(K_{t,t}\) with odd \(t\).  The primary witness is the first such
cyclic example after \(K_{1,1}\).

For the AIM statement as literally written without connectedness, the full
correction is the corresponding disjoint-union version:

> Every nonempty balanced circulant is a disjoint union of \(d\ge1\)
> isomorphic copies of one corrected connected member.

Indeed, if a circulant is presented by order \(n\) and connection lengths
\(L\), then \(d=\gcd(n,L)\) is its number of components, and each component
is the same connected circulant after dividing \(n\) and all lengths by
\(d\).

## Jacobian verification

Jacobian 0.14.0 at commit
`7df85cac75e3a249cb69c6bae685c42b75a31390` was used through four exact graph
operations:

- `graph.symmetry.generator_orbits.compute`: validates rotation by one and
  returns one vertex orbit;
- `graph.coloring.k_colorability.decide`: returns a proper 2-coloring;
- `graph.induced_vertex_subset_pattern.count`: returns zero induced copies
  of \(C_6\);
- `graph.isomorphism.decide.compute`: returns an explicit isomorphism to the
  standard \(K_{3,3}\).

Run:

```bash
python run_jacobian_verification.py --output jacobian_results.json
```

The exact requests are in `jacobian_requests/`; the complete transcript,
including the Jacobian version and commit, is in `jacobian_results.json`.

## Independent finite search

`exhaustive_search.py` enumerates every nonempty undirected circulant
connection set through order 32.  It checks balancedness by exact chordless
cycle enumeration and checks the original and corrected families by graph
isomorphism.

Results:

- 196,573 nonempty circulants checked;
- 106 balanced circulants found;
- first connected counterexample: \(K_2\) at order 2;
- first connected counterexample containing a cycle: \(K_{3,3}\) at order 6;
- zero balanced circulants outside the published corrected classification.

Run:

```bash
python exhaustive_search.py --max-n 32 --output exhaustive_search_output.json
```

The finite search is corroborating evidence, not the basis for the general
classification; the unrestricted statement follows from the published
theorem plus the elementary component reduction above.

## Disposition and limitations

- Recommended disposition: `confirmed_counterexample`.
- Claim alignment: `exact`.
- Confidence: `high`.
- The local checker establishes the particular finite witness without
  relying on the classification theorem.
- The corrected general connected classification relies on the cited
  peer-reviewed theorem; the disconnected extension is an elementary
  circulant-component corollary.
