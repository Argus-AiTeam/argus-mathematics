# ID 2215 — Erdős Problem 619

**Audit cutoff:** 2026-08-27  
**Producer decision:** `refuted`  
**Claim alignment:** `exact`  
**Evidence level:** `formal_artifact`  
**Review status:** `pending_independent_review`

## CSV-ready fields

```yaml
resolution_status: refuted
claim_alignment: exact
evidence_level: formal_artifact
resolution_date: 2026-06-09
source_urls: "https://www.renyi.hu/~gyarfas/Cikkek/90_howtodecrease.pdf; https://doi.org/10.1017/S0963548398003496; https://www.erdosproblems.com/619; https://www.erdosproblems.com/latex/619; https://www.erdosproblems.com/forum/thread/619; https://github.com/teorth/erdosproblems/blob/9cfb265f9fa57390908d80624d61b9551d454398/data/problems.yaml#L10081-L10096; https://github.com/nick-kuhn/erdos-619/tree/7f65718b8c1019ecc24e6c9a6b04ec4c66a4e26f; https://raw.githubusercontent.com/google-deepmind/formal-conjectures/1a9fbeebaa628fec9818216802298871c95b193c/FormalConjectures/ErdosProblems/619.lean"
source_location: "EGR98, Combinatorica 18 (1998), p.493 abstract and Introduction, and p.499 §4 Problem 4.3; Er99, Combin. Probab. Comput. 8 (1999), p.4 (bibliographic cross-reference; publisher full text access-restricted); erdosproblems.com #619 main statement, additional text, and discussion comment dated 2026-06-09; source-data commit 9cfb265f9fa57390908d80624d61b9551d454398, lines 10081-10096; erdos-619 commit 7f65718b8c1019ecc24e6c9a6b04ec4c66a4e26f: Erdos/Basic.lean lines 20-49, Erdos/FC.lean lines 35-64, sketch.md, Solution.lean lines 2009-2056, 2587-2646, 2800-2863, 4334-4780, 5079-5188, 5707-5871, VERIFICATION.md"
audit_notes: "The original definition is diameter at most r, not exactly r. G is initially connected and triangle-free; extensions use the same vertex set, add arbitrary missing edges, remain triangle-free, and have extended diameter at most 4. The checked Lean theorem proves that for every 0<eta<1 and all sufficiently large n there is such a G with h_4(G)>=(1-eta)n, which directly negates every fixed-c universal saving. Local build and axiom audit passed; comparator entrypoint could not run locally because its external binary was absent. Compilation alone does not establish statement fidelity, so fidelity was checked manually against EGR98 and the pinned formal-conjectures RHS. The formal proof does not establish the maintained page's sharper n-O(n^(8/9)(log n)^(2/9)) rate; that rate is unnecessary for the audited refutation."
review_status: pending_independent_review
```

## Original problem: exact contract

The complete author-hosted copy of Erdős, Gyárfás, and Ruszinkó,
*How to decrease the diameter of triangle-free graphs*, Combinatorica
18 (1998), 493–501, was inspected directly.

| Original location | Contract fixed by the source |
|---|---|
| p. 493, abstract | \(h_d(G)\) is the minimum number of edges added to a triangle-free \(G\) to obtain a graph of diameter **at most** \(d\) that is still triangle-free. |
| p. 493, Introduction | Extensions add no new vertices. Thus the operation is addition of missing edges on the same vertex set. |
| p. 499, §4, immediately before Problem 4.3 | The paper again defines \(h_d(G)\) using a triangle-free extension of diameter **at most** \(d\). |
| p. 499, Problem 4.3 | “Is it true that for every connected triangle-free \(G\), \(h_4(G)\leq(1-\epsilon)n\) for some positive constant \(\epsilon\)?” |

Thus “diameter \(4\)” in the database prose is not an exact-diameter
condition. It means diameter at most \(4\). The original graph must be
both connected and triangle-free, and the augmented graph must remain
triangle-free. The edges may be any nonedges of \(G\), but no vertices
may be introduced.

The maintained page uses the strict form
\[
h_4(G)<(1-c)n,
\]
whereas EGR98 Problem 4.3 prints \(\leq\). This harmless normalization
does not weaken the negative result: a lower bound with parameter
\(\eta<c\) is strictly larger than \((1-c)n\), so the construction
refutes both versions.

The second cited original source is Paul Erdős, *A selection of problems
and results in combinatorics*, Combinatorics, Probability and Computing
8 (1999), 1–6, DOI
[10.1017/S0963548398003496](https://doi.org/10.1017/S0963548398003496);
the maintained bibliography locates the restatement at p. 4. The
publisher's original record, DOI, volume, issue, and page range were
checked, but its page-4 full text was access-restricted during this
audit. No semantic inference is therefore based on an uninspected
transcription of Er99: the identical originating question and all
definition-sensitive details above come from the complete EGR98
primary text.

## Current maintained status

The author-maintained
[#619 page](https://www.erdosproblems.com/619), last edited 2026-06-15,
marks the problem `SOLVED (LEAN)` and says it was resolved negatively by
Claude Fable 5, prompted by Nick Kuhn. Its additional text states that
there are infinitely many \(n\) with a connected graph \(G\) satisfying
\[
h_4(G)\geq n-O\!\left(n^{8/9}(\log n)^{2/9}\right).
\]
The [discussion](https://www.erdosproblems.com/forum/thread/619) dates
the disproof to 2026-06-09 and gives the pendant-core argument.

This was also checked against the database source as it stood before
the cutoff. Commit
[`9cfb265f9fa57390908d80624d61b9551d454398`](https://github.com/teorth/erdosproblems/blob/9cfb265f9fa57390908d80624d61b9551d454398/data/problems.yaml#L10081-L10096)
(2026-08-26) records for problem 619:

- `informal_status.state: solved`, last update 2026-06-22;
- `formal_status.state: Lean`, last update 2026-06-22;
- aggregate `status.state: solved (Lean)`.

These labels are corroboration only, not the basis of the verdict.

## Pinned proof artifact and statement fidelity

The audited repository state is the full commit
[`7f65718b8c1019ecc24e6c9a6b04ec4c66a4e26f`](https://github.com/nick-kuhn/erdos-619/tree/7f65718b8c1019ecc24e6c9a6b04ec4c66a4e26f)
(2026-06-14), not a moving branch.

### `Erdos/Basic.lean`

`IsHR r G m` requires an attained minimum over graphs \(H\) on the
same `Fin n` vertex set with

1. `G ≤ H`,
2. `H.CliqueFree 3`,
3. `H.ediam ≤ r`, and
4. exactly \(m\) new edges, with \(m\) minimal among all such \(H\).

The conjecture quantifies over every \(n\), graph \(G\), and attained
\(m\), assumes `G.Connected` and `G.CliqueFree 3`, and asks for one
\(c>0\) with \(m<(1-c)n\). The proved target is its negation. This
matches the maintained strict formulation and preserves every
definition-sensitive condition.

### Vendored formal-conjectures statement

`Erdos/FC.lean` pins the upstream file
`FormalConjectures/ErdosProblems/619.lean` at formal-conjectures merge
commit
[`1a9fbeebaa628fec9818216802298871c95b193c`](https://github.com/google-deepmind/formal-conjectures/commit/1a9fbeebaa628fec9818216802298871c95b193c).
The upstream right-hand side uses arbitrary finite vertex types,
`G.Connected`, `G.CliqueFree 3`, a same-vertex-set supergraph,
`H.CliqueFree 3`, and `H.ediam ≤ 4`.

The upstream merged theorem is still the open form
`answer(sorry) ↔ RHS`. The audited repository transparently defines the
solved proposition as `False ↔ RHS`; it does not pretend that the
upstream `sorry` is a proof. `Solution.lean` proves this solved
proposition by bridging its explicit minimum predicate to
`Nat.sInf`. For the constructed graphs it separately constructs a
feasible triangle-free diameter-\(\leq4\) extension, so the empty-set
`Nat.sInf = 0` convention cannot create a spurious counterexample.

Compilation cannot establish that a chosen formal statement faithfully
represents the historical problem. Fidelity was checked manually
against EGR98 p. 493 and p. 499 and against the pinned upstream
right-hand side. The only textual discrepancy is the already noted
\(\leq\)/\(<\) normalization, which the proved lower bound defeats in
either form.

## What `Solution.lean` proves

The proof builds a connected triangle-free core \(H\) with bounded
degree and small independence number, then attaches \(s\) pendant
vertices to each core vertex (and distributes a bounded remainder so
that arbitrary sufficiently large orders \(n\) are covered).

Important checked interfaces are:

- lines 2009–2056: finite counting proves the triangle-free seed exists;
- lines 2587–2646: deterministic gluing makes connected host graphs for
  every sufficiently large \(m\);
- lines 2800–2863: the base graph has core edges and leaf-to-root edges,
  but no pendant–pendant edges;
- lines 4334–4780: an explicit same-vertex-set supergraph is
  triangle-free and has diameter at most \(4\);
- lines 5079–5188: transport to `Fin n` preserves order, connectivity,
  triangle-freeness, and feasibility;
- lines 5707–5769: for every \(0<\eta<1\), for **all sufficiently large
  \(n\)** there is a connected triangle-free \(G\) with
  \[
  h_4(G)\geq(1-\eta)n;
  \]
- lines 5772–5807: this family negates the original universal
  conjecture;
- lines 5832–5871: edge-count equality and minimum-value lemmas bridge
  to the vendored formal-conjectures right-hand side.

The Lean result is stronger in its order quantifier than the maintained
page's “infinitely many \(n\)”: it gives every sufficiently large
\(n\). It is weaker in a different, irrelevant direction: it does not
formalize the page's explicit
\(O(n^{8/9}(\log n)^{2/9})\) error rate. The formal
\(\eta\)-family is already enough to decide the yes/no problem.

For any proposed \(c>0\), take \(\eta=c/2\) when \(c<2\). For a
sufficiently large witness,
\[
h_4(G)\geq(1-c/2)n>(1-c)n,
\]
contradicting the claimed universal bound. If \(c\geq2\), the proposed
right-hand side is nonpositive while \(h_4(G)\geq0\). This is exactly
the case split implemented at lines 5772–5807. The lower bound
therefore genuinely excludes every fixed \(c>0\), rather than merely
showing a large finite example.

## Local verification

Pinned toolchain:

- Lean: `leanprover/lean4:v4.28.0`;
- mathlib input tag: `v4.28.0`;
- exact mathlib commit:
  `8f9d9cff6bd728b17a24e163c9402775d9e6a365`.

Commands run from the pinned repository:

| Command | Exit | Result |
|---|---:|---|
| `lake exe cache get` | 0 | Pinned cache fetched/decompressed successfully. |
| `lake build Erdos Challenge Solution` | 0 | `Build completed successfully (8033 jobs)`; only style/linter warnings. |
| `lake env lean scripts/AxiomCheck.lean` | 0 | Both root theorems passed guarded axiom expectations. |
| `./scripts/check-erdos-619-solution.sh` | 2 | External comparator binary was not present at `.tools/comparator/.lake/build/bin/comparator`; no comparator result is claimed from this machine. |

`scripts/AxiomCheck.lean` requires both `erdos_619_solution` and
`erdos_619_fc_solution` to depend only on
`propext`, `Classical.choice`, and `Quot.sound`. The guard passed.
Direct source scanning found no `sorry`, `sorryAx`, unsafe declaration,
or native-decision escape in `Solution.lean`. The two `sorry`s in
`Challenge.lean` are explicitly trusted comparator challenge
statements and are not imported by `Solution.lean`; the pinned upstream
formal-conjectures theorem is likewise an open statement, not the
submitted proof.

`VERIFICATION.md` records an earlier successful comparator/kernel run
with real landrun, but because that run predates the audited head and
was not reproduced locally, it is historical corroboration only. The
local positive evidence is the clean build plus the successful guarded
axiom audit.

## Decision

All semantic conditions of the audited claim align: same vertex set,
arbitrary added nonedges, diameter at most \(4\), triangle-free before
and after augmentation, connected initial graph, and an asymptotic
family whose quantifiers defeat every fixed positive saving. The exact
yes/no claim is therefore **refuted** as of 2026-06-09, pending
independent review. No finite Jacobian witness was used: the decisive
object is an asymptotic family, not a graph on at most 64 vertices.
