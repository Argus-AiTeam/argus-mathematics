# Hypergraph one-vertex capture

## Scope and source findings

The target is `lem:capture` in the staged hypergraph manuscript,
`build/restriction.tex` (October 5, 2026), with its original quantifiers:
integers `n >= r >= 3`, `1 <= m <= n`, real `k > 0`,
`alpha = r/(r-1)`, and `L = (k/r)^alpha`. A support is a nonempty
**set** of distinct `r`-element vertex sets, not a multihypergraph.
The sampling law is uniform over all `m`-element vertex subsets.
The free coordinates are all edges meeting the sampled block, not just
edges inside it or crossing its boundary. The hypothesis is
`r*L*(m-1)/(n-1) <= 1/2`; the conclusion is capture probability at least
`m/(2*n)` with the literal real cutoff `1 <= |S intersect F_B| <= k`.

The proof has two genuinely necessary components: derive a positive-degree
vertex with degree at most the real number `k`, and prove its isolation
probability under sampling **without replacement**. The chosen vertex may
depend on the support but not on the sampled block. Capturing one vertex
does not mean capturing just one edge.

Both manuscripts' load-bearing chains were read directly. The graph chain
is biased Fourier identities and low-degree mass, exact restriction
averaging, surviving block orbits, graph capture, variance/tail estimates,
and monotone log-odds integration. The hypergraph chain shares the analytic
argument, replaces the orbit calculation and capture lemma, and uses the
positive bias exponent `2-r/(r-1)` in the tail bound. These are separate
ledger obligations; this certificate does not certify the full Fourier or
influence theorem.

At upstream commit `4eaee87548250b2682affda7d05d947c05554bae`,
`lean/docs/186.md` describes the graph sharp-threshold result and links its
comparator. It does not claim a formalization of this hypergraph capture
lemma. A comparator placeholder is not a refutation of an implementation.
The same pinned revision's
`lean/OAI/Combinatorics/SharpThreshold/LowDegree.lean` implements the
arbitrary-finite-coordinate `low_degree_estimate` and its filtered form.
Its noise premise is discharged by `synthesis_fourth_bound`; it is not an
assumption of the implemented final theorem. This confirms shared
analytic prior art, not a hypergraph-capture certificate.
No imported literature theorem is needed for the planned finite
combinatorial proof: its counting and real-power steps will be proved
against Mathlib, rather than assumed from the manuscripts.

The inherited Wiki index has no page about this capture lemma or this
manuscript family. Unrelated hypergraph-container and threshold pages are
not dependencies. Bounded finite searches alone cannot close this mission.

## Mathematical route

For `s = |S|` and `V` the union of the support edges, put `v = |V|`.
Simplicity gives `s <= v^r`; incidence counting gives total degree `r*s`
and `v <= r*s`. A minimum-degree support vertex therefore has positive
degree at most `r*s^((r-1)/r)`. The real-power identity
`((k/r)^(r/(r-1)))^((r-1)/r) = k/r` must be justified with positive bases,
not replaced by an integer or rounded cutoff.

For the selected vertex `u`, subtract from blocks containing `u` the union
of blocks also containing another vertex of `V`. Singleton and pair
incidence counts give the exact without-replacement factor
`(m-1)/(n-1)`. On the remaining blocks the captured support is exactly the
set of edges incident with `u`. The cases `m=1` and `n=r` are included;
when `L<1` there is no nonempty support satisfying `|S|<=L`.

## Formal proof

`Main.lean` derives both proof obligations, including the real-power bridge,
and proves the literal capture conclusion. The stronger intermediate
`uniform_isolation` is useful independently of uniform hypergraphs:
for any finite support-vertex set `V` and `u in V`, its lower bound uses
`|V|-1`, without replacing it by `r*L`.

The proof counts blocks rather than assuming conditional marginals.
Writing `A = choose(n-1,m-1)`, `C = choose(n,m)`, and `P` for the
number of blocks containing two specified distinct vertices, it proves
`n*A=m*C`, `(n-1)*P=(m-1)*A`, and
`A <= isolated_blocks + (|V|-1)*P`. In particular `P=0` when `m=1`;
the superficially similar `choose(n-2,m-2)` would be wrong in that case.
This is a pitfall avoided by the independent proof, not an error in the
manuscript, which correctly states the conditional marginal.

The degree witness is not an input. Simplicity, uniformity, incidence
counting, and positive-base real-power monotonicity imply
`r*s <= k*v`; averaging then supplies the required positive-degree vertex.
No integer rounding or replacement sampling law is introduced.

## Exact adversarial experiments

The verifier checked 2,782 admitted instances by exact rational arithmetic
and enumerated 260,433 fixed-size blocks. This includes every nonempty
simple support on at most five vertices (1,072 supports), with near-boundary
quarter-integer cutoffs and eighth-integer perturbations, plus stars,
matchings, complete small supports, and every two-edge intersection size
at larger vertex counts. There were no counterexamples. These experiments
are not the justification for the universal conclusion.

The recorded cases include `m=1` (2,578 instances), `n=r` (6),
noninteger `k` (1,961), and eight exact empty-range checks. The universal
Lean theorem includes all these cases, and `empty_support_range` proves
the empty-range assertion for all parameters rather than just those checks.
The typed Jacobian result independently checks the degrees of one
four-edge, 3-uniform example; it is not used as a proof of the theorem.

## Certification and replay

Run from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/certificates/hypergraph_capture/verify.py
```

The default verifier performs the exact experiments, compiles the complete
universal theorem through the prescribed claim-linked verifier, checks its
axiom dependencies, and runs both campaign-local ledger checks.
`--arithmetic-only` explicitly reports only a finite experiment and does
not certify the theorem.

The full replay passed. Lean 4.31.0 returned `exit_code=0`,
`proof_holes=[]`, and a successful axiom audit; only `propext`,
`Classical.choice`, and `Quot.sound` occur. The archived certificate is
`certificates/V_HYPERGRAPH_CAPTURE-7809279e9d93ed0e.json`.
The ledger derives `V_HYPERGRAPH_CAPTURE` as `closed_kernel`, with no
external assumptions. Both official checks returned zero against
`campaigns/9000186`.

This improves the relevant prior formal scope by independently certifying
the hypergraph-specific capture step and its real-cutoff bridge; it does
not assert a new combinatorial inequality beyond the manuscript's claim.
The full influence theorem and the other analytic obligations remain
outside this bounded certificate. No false manuscript assertion has been
established, so there is no justified `F_` refutation claim.

Independent Reviewer replay and statement-fidelity approval have **not**
occurred. Proof-graph nodes remain open with `reviewer_confirmed=false`
until that review; the compiler's success is not being substituted for it.
