# Universal Lean partition obstruction

**Engineer assessment: supported by a fresh, successful compiler and axiom
audit for the exact scalar theorem.** Statement fidelity was examined
separately in prose. This is not a formal proof of the geometric bridge or
Fujita's conjecture, and does not constitute native independent acceptance.

## Exact statement and versions

For every natural \(n\), positive real \(d,t,\sigma\), and nonnegative real
\(a\), define
\[
 R_n(u,l)=\frac1l\sum_{i=0}^{l-1}(i/l)^n e^{(1-i/l)u}.
\]
If \(\sigma dR_n(a/t,l)\leq d/t\) for **every natural \(l\geq2\)**, then
\[
 \sigma\left(t+\frac{a}{n+2}\right)\leq n+1.
\]
`PointCenter.partition_obstruction` proves exactly this implication. The file
also proves finite power growth, weighted growth, telescoping, normalized
power-sum bounds, the explicit exponential lower bound, Archimedean error
removal, scalar denominator clearing, strict-inequality impossibility, and a
parameter choice for \(a>0\).

The source is the historical Argus `Main.lean`, 13 theorems and three
definitions. `PC9000038@1` described the finite/scalar mechanism and did not
have the final successful partition certificate. Versions 2-4 explicitly
state the all-partition-length implication; their formal source versions
differ. The surviving attempts bind as follows, established by matching
certificate subjects to the old claim records, not by filenames:

| Old version | Certificate suffix | Actual outcome |
|---|---|---|
| 2 | `3c72259513e505f1` | `type_error`, exit 1, no successful axiom audit |
| 3 | `4ff98bbf95708043` | `type_error`, exit 1, no successful axiom audit |
| 4 | `a85c81f177e68679` | `success`, exit 0, audit exit 0, no proof holes |

The first failed attempt prints `sorryAx` after elaboration errors; its
recorded `proof_holes=[]` is not a successful proof. The second prints only
the usual axioms for the two selected declarations but has an unmatched
scope-ending error; it also is not a successful source compilation.
Neither failure refutes the mathematics. Version 4 is the strongest relevant
prior formal result, and the present replay confirms it without changing the
theorem. The old route still points to `PC9000038@1`; it must not be mistaken
for a route automatically rebound to the version-4 certificate.

## Decisive argument

Monotone integral comparison proves, for all natural \(q\) and \(l>0\),
\[
 \frac1{q+1}-\frac1l\leq S_q(l)\leq\frac1{q+1},
 \qquad S_q(l)=l^{-1}\sum_{i<l}(i/l)^q.
\]
Using \(e^z\geq1+z\) termwise gives
\[
 R_n(u,l)\geq
 \frac1{n+1}+\frac{u}{(n+1)(n+2)}-\frac{1+u}{l},\quad u\geq0.
\]
Because the premise holds for every \(l\geq2\), an Archimedean choice of
sufficiently large \(l\) removes the error. Multiplication by positive
denominators and cancellation of \(d>0\) yields the displayed obstruction.
No limit is inferred from a finite set of lengths or tested dimensions.
The finite-growth lemmas are genuine implications from their displayed
growth and endpoint-moment hypotheses, not statements that those hypotheses
hold for geometric section spaces.

## Fresh compilation and source binding

Only `Main.lean` and its unchanged fidelity document were copied to the owned
`replay/` directory for safe compilation, not an old workspace or snapshot.
Both copies were checked byte-identical. The authorized command used
`$WORKSPACE/argus-latest/.venv/bin/python -m
argus_skill.verticals.math.lean_evidence verify`, with `--claim C1`,
the exact campaign root, and an artifact directory inside this unit.

[`lean_verify.json`](lean_verify.json) records a real 18,060 ms run:
compiler exit 0, `proof_holes=[]`, audit exit 0, and no recording refusals.
The fresh claim-bound certificate is
[`replay/certificates/C1-7ae5dd88ea411ff5.json`](replay/certificates/C1-7ae5dd88ea411ff5.json).
Its source SHA-256 is
`73094041a358f865f176ddb06065c8099f61f81981ba3b4e807daa4b9f49b469`;
the fidelity SHA-256 is
`c10ff88d1a8415c89c1a0288c144b805ed1213fbc356743d7ad0d0d49b7163b3`.
Both equal the final historical certificate and the existing snapshot
manifest's source/fidelity versions.

The actual tools are Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake 5.0.0-src+68218e8, and
elan 4.2.3. Compilation ran in the already built Mathlib workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`; no new lakefile,
library fetch or build was introduced. The two printed axiom lists contain
only `propext`, `Classical.choice` and `Quot.sound`; the official audit
passed for the source. No geometric or literature assumption is attached
to the formal scalar claim.

The durable runner's first submission failed *before launching* because its
preflight treated `$P` as an executable. That receipt is preserved as an
environmental non-conclusion. A corrected absolute-executable submission
actually compiled. Its combined task exits 1 only because the separate
current proof-graph check exits 2; the Lean result itself is successful.
These statuses are not conflated.

## Separate statement-fidelity reading

The copied `statement_fidelity.md` describes these exact declarations. Its
historical heading `PC9000038` is retained; active `C1` records the same
scalar statement and exact source. This is a replay, not a retitling of the
geometric result.

The natural \(n\) and arbitrary partition length are genuinely universal.
The scalar \(d\) is a positive real, not a formal scheme dimension.
`numeric_obstruction` even permits unrestricted real \(a,\sigma\); their
signs enter the preceding exponential/partition step. Normalized sum bounds
require \(l>0\). For the geometric application \(n\geq1\), the index-zero
term vanishes and the sum exactly matches the manuscript's indices
\(1,\ldots,l-1\); the extra scalar case \(n=0\) is not an assertion about
a positive-dimensional geometric center.

`moment_telescope` assumes its endpoint moment inequality.
`partition_obstruction` assumes **all** per-partition inequalities.
Schemes, local Taylor realizations, Brunn-Minkowski, first variation,
specialization, Hilbert asymptotics, and extraction along a liminf subsequence
are not encoded. The Engineer's reading supports this translation, but the
compiler's `verified_by:null` fidelity field is honest: compilation cannot
certify that reading, and the native Reviewer must examine it independently.

## Remaining obligations and operational boundary

There is no remaining proof hole in this exact scalar formalization. Native
fidelity and full-family review remain pending. The current campaign-local
checks record root
`campaigns/9200038`,
math-state exit 0 and proof-graph exit 2. The latter says the active
`research/PROOF_GRAPH.json` is absent, and that path is not writable in this
mission. This prevents representing the supplied two-check handoff gate as
passed; it is not a refutation, missing compiler evidence, or permission to
check the shared batch root or weaken a theorem.
