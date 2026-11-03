# ID 1442 — Teschner bondage-number bound

## Decision

**Suggested status: `refuted` (`review_status=unreviewed`).** As of the
2026-08-27 cutoff, the universal assertion
\[
  b(G)\leq \frac{3\Delta(G)}2
\]
has an explicit counterexample: the graph below has \(\Delta(G)=3\) and,
by the independent exhaustive computation recorded here, \(b(G)=5>9/2\).
This is an engineer-route decision and has not yet received the required
independent reviewer check.

Here a dominating set \(D\) uses **ordinary closed neighborhoods**:
\(\bigcup_{v\in D}N[v]=V(G)\). The domination number \(\gamma(G)\) is the
minimum size of such a set. The bondage number is
\[
 b(G)=\min\{|F|:F\subseteq E(G),\ \gamma(G-F)>\gamma(G)\}.
\]

## Fixed primary source and cutoff

Yousof Yavari, *A Counterexample to Teschner's Bondage-Number Conjecture*,
Figshare preprint, DOI
[`10.6084/m9.figshare.33198777.v1`](https://doi.org/10.6084/m9.figshare.33198777.v1).

The saved public and version-one API records both report:

- record `33198777`, version `1`, public status;
- `created_date`, `published_date`, and `modified_date` all
  `2026-08-10T16:24:14Z`;
- `timeline.posted = 2026-08-10T16:24:14`;
- exactly one attachment, file `67406634`,
  `Teschner_s_Conjecture.pdf`, 389,645 bytes, PDF;
- supplied/computed MD5 `1749b82909bb75a7a154d019c2b445ae`.

Thus the first public date is **2026-08-10**, before the 2026-08-27 cutoff.
The DOI resolver was also captured and resolves to the explicit `/33198777/1`
version. The API was retrieved on 2026-08-29, but all publication and
modification fields fix version 1 on 2026-08-10.

Saved source artifacts:

- `.work/remaining-audit/low-grade-graph-inequalities/1442/sources/figshare-api-33198777.json`
  — SHA-256 `97cc4069fe07dc5cb6c0c651c1891d3134e3d2ef3060dacee5bb6cd44e0eb0a5`;
- `.work/remaining-audit/low-grade-graph-inequalities/1442/sources/figshare-version-api-33198777-v1.json`
  — SHA-256 `5aeded35011f6cda47c6e38e875f21e4edbd1685de2f10450e208ef50931d57b`;
- `.work/remaining-audit/low-grade-graph-inequalities/1442/sources/Teschner_s_Conjecture.pdf`
  — SHA-256 `e8f1f1edcc16dd92a58bce86785340fd9e032758ea857322fb30d46aa848f38e`;
- the API, download, version API, and DOI HTTP headers are beside those files.

The PDF states the exact conjecture in Conjecture 1.1 (p. 1), the
counterexample result in Theorem 1.2 (p. 2), the graph in (3.1) and
bipartition in (3.2) (p. 3), \(\gamma(G)=6\) in Proposition 3.2 (pp. 4–5),
the five-edge deletion in (4.1) and resulting \(\gamma=7\) in Proposition
4.1 (pp. 5–6), and the exhaustive four-edge claim in Proposition 4.2
(pp. 6–7). Appendix A (pp. 7–8) embeds the author's Python verifier. The
Figshare API lists no separate code attachment: the PDF is the only file.
The complete layout-preserving text extraction is saved as
`sources/Teschner_s_Conjecture.txt`.

This aligns the proposition itself, not merely a title or search snippet.
In particular, this audit does not substitute a similarly titled 1993
Teschner paper; the preprint identifies its source for the conjecture as
Teschner's 1995 paper and states the same \(3\Delta/2\) formula. Nor does
this audit adopt any webpage claim of \(\gamma=4\): exact enumeration below
rules out every dominating set of size at most five.

## Candidate graph and paper claims

\[
V(G)=\{0,1,\ldots,17\},
\]
\[
\begin{aligned}
E(G)=\{&(0,6),(0,10),(0,16),(1,8),(1,11),(1,12),\\
&(2,4),(2,5),(2,13),(3,4),(3,5),(3,9),(4,16),(5,11),\\
&(6,7),(6,13),(7,8),(7,14),(8,13),(9,10),(9,14),\\
&(10,15),(11,15),(12,15),(12,17),(14,17),(16,17)\}.
\end{aligned}
\]

The paper's five-edge deletion is
\[
 F_5=\{(0,6),(0,10),(0,16),(6,7),(6,13)\}.
\]

The machine-readable transcription is
`.work/remaining-audit/low-grade-graph-inequalities/1442/verifier/candidate-graph.json`
(SHA-256
`137dd53743f9da8085556b5c37560bc6091d4bfe8feef73a8259074eadbea407`).

## Jacobian capability discovery and bounded run

This was done **before** writing the independent enumerator, using only:

```sh
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian catalog
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian inspect graph.domination.minimum.compute
```

The complete 607-operation catalog is saved as `jacobian/catalog.raw.json`;
the exact filtered record is `jacobian/catalog.filtered.json`. Filtering for
`domination|bondage|pebbling` found only
`graph.domination.minimum.compute`; no bondage or pebbling operation was
installed. The raw exact declaration is
`jacobian/inspect.graph.domination.minimum.compute.raw.json`. Its contract
accepts simple undirected graphs of order at most 32 and budgets bounded by
`max_solver_calls<=33`, `wall_seconds<=120`; its typed output uses ordinary
closed-neighborhood domination and has result status `EXACT` or `UNKNOWN`.

The CLI has no `--version` option (captured exit 2), and exposes no protocol
identifier, so the CLI protocol version is honestly recorded as
**unavailable**; installed distribution metadata reports Jacobian `0.14.0`.
The exact payload (`jacobian/payload.json`,
SHA-256
`b15dc4995f9e0df126a6753f6b52f0a8ca1bed8068c572c9ea1ab7713a63d043`)
uses `max_order=32`, `max_solver_calls=33`, `wall_seconds=120`. Command:

```sh
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian \
  run graph.domination.minimum.compute \
  --file .work/remaining-audit/low-grade-graph-inequalities/1442/jacobian/payload.json
```

It exited 0 in 3.46 seconds and returned typed status `EXACT`,
`optimum_value=6`, lower/upper bounds 6, convention
`ORDINARY_CLOSED_NEIGHBORHOOD`, and witness
`["11","17","2","6","8","9"]`. Raw output is `jacobian/run.stdout.json`
(SHA-256
`52e4f8d1fee93b88260e1c7ad50aa6387eda6c374e93466109cf8403fc3697bb`);
exit, stderr, timestamps, and timing are retained. This independently
corroborates only \(\gamma(G)=6\); it does not compute the bondage number.

## Independent exact verifier

`verifier/verify.py` (SHA-256
`2d2bc6a6c3cd356d7f785d429dd35817f9294d51f596b054ab5cdaca7cda572d`)
is a separate bitset implementation, not the program printed in Appendix A.
It uses only the Python standard library and:

1. canonicalizes undirected edges and rejects loops, duplicates, bad
   endpoints, wrong counts, disconnection, failed two-coloring, or noncubic
   degree;
2. represents each \(N[v]\) as an integer bitset and exhausts all vertex
   subsets of sizes 0 through 6;
3. rebuilds closed neighborhoods after deleting \(F_5\) and exhausts sizes
   0 through 7;
4. iterates every lexicographic member of
   \(\binom{E(G)}4\), directly removes those four edges from the closed
   neighborhoods, and tests all 297 original six-vertex dominating sets.

Reproduction:

```sh
/usr/bin/python3 \
  .work/remaining-audit/low-grade-graph-inequalities/1442/verifier/verify.py \
  .work/remaining-audit/low-grade-graph-inequalities/1442/verifier/candidate-graph.json
```

The run exited 0 in 1.82 seconds. Raw JSON is `verifier/output.json`
(SHA-256
`b6dadf9f6ebfb378e25714c55fa481839e24133e2cdafec36df150f217360a3c`);
the source, input, raw output, stderr, exit status, timestamps, timings, and
hash manifest are retained in `verifier/`.

Exact output:

- 18 vertices, 27 distinct loop-free edges; connected and bipartite;
- bipartition
  `{0,1,4,5,7,9,13,15,17}` /
  `{2,3,6,8,10,11,12,14,16}`;
- every degree is 3, hence \(\Delta=3\);
- dominating-set counts for sizes 0 through 6:
  `[0,0,0,0,0,0,297]`, so \(\gamma(G)=6\), with paper witness
  `{0,1,2,3,14,15}`;
- after deleting \(F_5\), counts for sizes 0 through 7:
  `[0,0,0,0,0,0,0,26]`, so \(\gamma(G-F_5)=7\), with witness
  `{0,1,2,4,6,10,14}`;
- all \(\binom{27}{4}=17,550\) four-edge deletions checked;
  every one retains a six-set, and the minimum survivor count is 1
  (attained for 66 deletion sets). The ordered survivor-count stream has
  SHA-256 `d25511675b6a0348228cc8e6912debff6e92dc44feca6bb9e659a5a08446cd42`
  when each count is encoded unsigned 16-bit big-endian.

Deleting edges cannot lower domination number: if \(F\subseteq F'\), then
every set dominating \(G-F'\) also dominates \(G-F\), so
\(\gamma(G-F)\leq\gamma(G-F')\). Thus the retained six-set plus
\(\gamma(G)=6\) gives \(\gamma(G-F)=6\) for every exact four-edge deletion.
Every deletion of 0–3 edges extends to one of four edges, and a six-set that
survives the extension also survives the smaller deletion. Consequently no
set of at most four edges raises \(\gamma\), while \(F_5\) does:
\[
 b(G)=5>4.5=\frac{3\cdot3}{2}.
\]

## Limitations and integration handoff

The decisive evidence is an exact finite recomputation over the explicitly
published graph, not the Figshare description or a search snippet. The
source is a public author preprint and was not shown here to be peer
reviewed. Correctness still depends on ordinary Python interpreter/integer
semantics and the faithful explicit edge transcription; the independent
Jacobian result reduces transcription/implementation risk for
\(\gamma(G)\), while hashes preserve the audited bytes. A reviewer must rerun
and inspect the route before changing `review_status`.

Suggested nine-field staging row (do not write it from this route):

```csv
1442,"refuted","exact","exact_computational_certificate","2026-08-10","https://doi.org/10.6084/m9.figshare.33198777.v1;https://api.figshare.com/v2/articles/33198777/versions/1","Conjecture 1.1 p.1; Theorem 1.2 p.2; graph (3.1) p.3; Propositions 3.2, 4.1, 4.2 pp.4-7; Appendix A pp.7-8; .work/remaining-audit/low-grade-graph-inequalities/1442/verifier/output.json; .work/remaining-audit/low-grade-graph-inequalities/1442/verifier/verify.py","Yavari's explicit connected cubic bipartite graph was independently exhaustively verified to have Delta=3, gamma=6, 297 minimum six-sets, no successful deletion of at most four edges, and a specified five-edge deletion raising gamma to 7; hence b(G)=5>9/2.","unreviewed"
```

Suggested shared claims/routes:

- `C1442-U`: universal claim \(b(G)\le3\Delta(G)/2\);
- `C1442-G`: the displayed 18-vertex graph is simple, connected, bipartite,
  cubic, and has \(\Delta=3\);
- `C1442-D6`: \(\gamma(G)=6\), with exactly 297 dominating six-sets;
- `C1442-F5`: the displayed \(F_5\) gives \(\gamma(G-F_5)=7\);
- `C1442-F4`: every one of 17,550 exact four-edge deletions retains a
  dominating six-set;
- `C1442-B5`: monotonicity plus `C1442-F4` and `C1442-F5` gives \(b(G)=5\);
- `C1442-R`: `C1442-G` and `C1442-B5` refute `C1442-U`;
- route `R1442-source`: fixed API/PDF → exact graph and paper assertions;
- route `R1442-jacobian`: inspected contract + exact bounded run →
  independent `C1442-D6` corroboration;
- route `R1442-bitset`: candidate JSON + verifier output →
  `C1442-G`, `C1442-D6`, `C1442-F5`, and `C1442-F4`;
- route `R1442-deduction`: `C1442-F4` + edge-deletion monotonicity +
  `C1442-F5` → `C1442-B5` → `C1442-R`.
