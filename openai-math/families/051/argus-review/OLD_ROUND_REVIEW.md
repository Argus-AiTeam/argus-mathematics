# Family 051: old-draft review

**Six mathematical units have Engineer assessments, not current independent
acceptance.** The index covers the 22 artifact entries and one manuscript
reference in `PRIOR_DRAFTS.json`; the reference is why the contract calls
this 23 listed artifacts. Copies, component claims, claim versions, and
certificate fields are not counted as separate mathematical results.

| Unit | Assessment | Decisive scope |
|---|---|---|
| [Literal bridge](draft_reviews/boundary-bridge/report.md) | Supported with A-CG, A-OKA, A-MORREY | Initial frame, one boundary-unitary frame for all strict \(2<\rho<4p/(p+2)\), centered families, differentiation, determinant and three Hessian identities. |
| [Weak boundary flux](draft_reviews/weak-boundary-flux/report.md) | Supported | Trace/log-determinant derivative means agree along suitable radii for continuous uniformly positive boundary-\(I\), \(W^{1,2}\) matrices; no commutativity. |
| [Conditional endpoint](draft_reviews/conditional-endpoint/report.md) | Supported conditionally | Identities for a **given** frame and family in \(C^0\cap W^{1,2}\); central-uniform control fixes the logarithmic \(L^1\) issue. No endpoint existence. |
| [Finite Blaschke extension](draft_reviews/finite-blaschke/report.md) | Supported | For finite degree \(m\), \(\psi(0)=0\): central multiplier \(|\psi'(0)|^2\), area \(mn-A_{R_h}\), unchanged determinant/Poisson formulas. Endpoint existence remains conditional. |
| [Curved noncommuting model](draft_reviews/curved-noncommuting-model/report.md) | Supported as a local diagnostic | Full-chart metric positivity, noncommutation, determinant and exact curvature/Hessian values. The target is not a compact hyperbolic manifold. |
| [Nonextendible square-root model](draft_reviews/nonextendible-square-root-model/report.md) | Supported as a construction | Image bound, metric interpolation, \(W^{1,p}\) exactly for \(1\le p<4\), no continuation across \(1\), and exact scalar identities on a given compact hyperbolic curve. |

Every unit has a matching `verdict.json`. The literal bridge report
individually assesses `BH-INITIAL`, `BH-FRAME`, `BH-SPRAY`, `BH-DIFF`,
`BH-DET`, and `BH-TRACE`; they are not silently hidden behind a theorem
label. The two diagnostics partition the one aggregate `BH-ALGEBRA`
claim. `BH-BRIDGE`'s versions add assumptions to the same statement,
not four theorems. All old claim IDs, contexts, graph dependencies,
routes, evidence receipts, duplicates, and exclusions are mapped in
`DRAFT_REVIEW_INDEX.json`.

## Attribution and strongest prior evidence

The reference manuscript is OpenAI's *Canonical ampleness of compact
hyperbolic Kahler manifolds*, September 23, 2026, source revision
`4eaee87548250b2682affda7d05d947c05554bae`, resolved from the
`9100051/MANUSCRIPTS.json` reference. The old manuscript-reference
directory contains a symlink to that source tree, not another Argus
draft. Its conventions and labels agree with the bridge's literal
claim. The identities, weighted Hardy construction, and weak flux
argument are already present in the manuscript. The explicit exponent
is also implicit in its inequalities. The draft's contraction and
conditional/multiplier extensions should not be advertised as
literature-verified novelty.

The strongest prior evidence is the old independent ledger support
by `reviewer:copilot-4ea18baac059` for `BH-BRIDGE`, `BH-FLUX`,
`BH-ALGEBRA`, and the three cited analytic propositions. This supersedes
the draft's blanket closing disclaimer of Engineer-only evidence, and
the diagnostic certificate's pending-review label, **only for those
targets**. It does not independently assess `BH-ENDPOINT` or
`BH-BLASCHKE`, supply Lean evidence, or accept this current review family.
This review adds complete coverage and explicit dependency/statement
analysis; it does not improve the already supported bridge to an
unconditional endpoint or a canonical-ampleness result.

The preserved snapshot manifest authenticates the old ledger, graph,
and bridge, not the other 19 listed supporting files or the root
diagnostic dependencies. Old opinions bind subject hashes and artifact
paths, not artifact-byte digests. Those limits are explicit in the
index and reports; no authenticated historical certificate-byte identity
is invented. The manuscript manifest hash-lists 10 TeX sources and has
no PDF source entries, so attribution uses those TeX sources.

The three propositions were read in the available primary texts:
Sukhov--Tumanov `arxiv:1411.3989v4`, section 4.1 p. 11 and section 2.4
(8) p. 8; Forstneric--Prezelj `doi:10.1007/s002080050361`,
Theorem 1.3, Definition 1.1 and Example (A), pp. 117--119.
Their exact statements, applicability, and old independent attribution
receipts are in the index and bridge report. They are also recorded as
assumptions in the **active** ledger; no old ledger was changed and no
historical Reviewer identity was impersonated to produce a new opinion.
The finite-tests-only route was recorded and retired with its actual
obstruction: finite diagnostics cannot establish general frame/family
existence or weak boundary flux.

## Reference claims deliberately not certified

These are reference obligations in the old graph, not additional
Argus proofs. Their actual manuscript statements were located; an
unreviewed reference is neither supported nor refuted by this review.

| Old claim | Manuscript statement and concrete missing bridge-to-global obligation |
|---|---|
| `M-MAXIMIZER` | `extremal-discs.tex`, `ex:maximizer`: for fixed center, smooth Kahler \(h\), closed real \(q\), and \(\delta>0\), \(d+P_q-\delta A_h\) has a finite attained supremum among finite-area discs. The bridge does not prove compactness/attainment for this optimization. |
| `M-REGULARITY` | `ex:regularity`: every maximizing disc is continuous on the closure and \(W^{1,p}\) for every \(2<p<4\), with a stated boundary derivative estimate. The bridge assumes regularity of its input disc; it does not prove it for maximizers. |
| `M-NEF` | `nefness.tex`, `nef:disc-bound`: \(P_{R_k}(f)\le C(k)\) for every finite-area disc. A pointwise Hessian identity for an already regular disc does not supply the maximizing/limit comparison or the subsequent positive-current and smoothing steps. |
| `M-VOLUME` | `volume-ampleness.tex`, `prop:volume-lower-bound`: \(R_h\ge-h\) implies \(h^n\ge e^{-D}(n/(2n+D))^n k^n\). The bridge alone does not supply the uniform maximizing comparison, metric-independent bound, or determinant inequality needed for that conclusion. |
| `M-GLOBAL` | The reference envelope, bounded-potential smoothing, negative-sign Monge--Ampere, positive intersection/bigness, Moishezon/projectivity and no-rational-curve ampleness steps are outside the Argus draft's proof. No hypotheses or external theorems for these steps are imported into this review's conclusions. |
| `M-MAIN` | `introduction.tex`, `thm:main`: compact connected Kahler and no nonconstant entire curve imply ample \(K_X\), hence projective. The preceding unreviewed obligations are not discharged by this draft. No main-theorem verdict is made. |

`C9000051` is the old research objective, not another proved mathematical
assertion. The local diagnostic's noncompact target is not an admissible
counterexample. The square-root diagnostic is not shown to maximize
anything. These limitations refute overreadings of the Argus evidence,
not the original manuscript.

## Computation, formal evidence, and handoff gate

The referenced root `verify.py` and `exact_certificate.json` were
resolved and inspected. The default checker reads and compares exact
SymPy results without writing; its optional payload-emission branch
does write and was not used. Applicable old independent diagnostic
evidence was reused instead of rerunning unchanged checks or generating
replacement snapshots. Analytic construction conditions were checked
in the reports, not promoted from finite sample tests.

One bounded current Jacobian operation was required by the host
capability contract. After discovery and typed inspection, the isolated
adapter computed the smaller symbolic \(2\times2\) determinant over
\(\mathbb Q(z,w)\), recovering
\(3/4+3zw/16+(zw)^2/8-(zw)^3/16\). Server `0.14.0`, protocol
`2025-11-25`, operation `matrix.symbolic.determinant.compute`, exit 0,
no timeout/error. Exact payload and raw typed response remain in the
curved-model review directory. This is local algebra only; the old
rejected \(4\times4\) symbolic request is still a non-conclusion.
There is no Lean source, compiler certificate, or kernel closure.

The final reconciliation passed: 23/23 entries, six report/verdict pairs,
18 old claim IDs with 21 versions, all 18 graph dependency sets, and
all 17 evidence records including six independent receipts. All 10
manuscript TeX hashes match their source manifest. The 36 old input
files and one reference symlink retained the measured baseline identity;
old drafts, ledgers, certificates, and snapshot inputs were not changed.
The exact coverage counts and measured identities are persisted in
`DRAFT_REVIEW_INDEX.json`.

The active campaign root is
`campaigns/9200051`.
Its official `math_state check` returned **0** with no issues.
Its official `proof_graph_check check` returned **2**:
`research/PROOF_GRAPH.json` is absent. That path is outside the mission's
authoritative writable paths, so this review does not create it or
substitute the old graph or shared batch root. This is a structural
handoff blocker, not a mathematical defect or an excuse for omitting
an assessment. The native Host-invoked independent Reviewer must
examine coverage and substantive assessments; Engineer does not
self-accept the family, and acceptance cannot be asserted while the
required campaign-local gate fails.
