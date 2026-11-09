# Family 033: review of all preserved old mathematical drafts

**Coverage:** all 17 listed artifacts and the reference-input directory
are assigned in `DRAFT_REVIEW_INDEX.json`; all 13 historical claim IDs
and 23 claim/version records are grouped into six substantive units.
The empty lock is excluded with a reason; citations, extracted text,
images, saved tool answers and statement-preserving revisions are not
counted as new results. This is an engineer assessment for the native
independent Reviewer, **not current family acceptance**.

## Assessment of every unit

| Unit | Assessment | Decisive scope |
|---|---|---|
| [root-kernel](draft_reviews/root-kernel/report.md) | `supported_classical_with_external_inputs` | Universal commutators control the whole highest piece. The exact sl4 obstruction invalidates only a diagonal-only shortcut, not the manuscript lemma. |
| [local-tail-kernel](draft_reviews/local-tail-kernel/report.md) | `supported_local_statement_with_exact_algebra_replay` | On the constant-rank locus, the first two kernels equal all permitted weighted tail kernels for arbitrary ranks and tail length. No algebraicity or irreducibility is needed locally. |
| [algebraic-line-orbit](draft_reviews/algebraic-line-orbit/report.md) | `supported_classical_with_external_inputs` | Semisimple connection dimensions and algebraic fixed-line incidence give orbit filling at suitable Hodge-generic points, with the whole complementary rational Lie period fixed. |
| [boundary-numerical](draft_reviews/boundary-numerical/report.md) | `supported_classical_with_external_inputs` | The specified canonical/tautological extensions, zero-Lelong regularization and full mixed mass justify nefness and numerical dimension from maximum curvature rank. |
| [weighted-two-tail](draft_reviews/weighted-two-tail/report.md) | `supported_classical_with_external_inputs` | The strongest recorded weighted equality is assessed, including equality with the first-two-tail dimension, every allowed pullback and compatible line, and the specified extensions. |
| [downstream-frontier](draft_reviews/downstream-frontier/report.md) | `unverified_frontier_with_supported_conditional_steps` | The main theorem and section construction remain unverified; six concrete geometric/numerical interfaces and the companion lower inequality are explicitly classified. |

Each linked report has a matching `verdict.json`. "Supported" means the
displayed classical argument is supported **with its named external
inputs**, not that those inputs, global geometry or originality were
proved by a Python interpreter. No specific internal gap was identified
in the five bounded tail-argument units under their stated inputs.

## The strongest result, not a weaker substitute

For the full marked-data polarized integral rational Lie variation with
semisimple adjoint monodromy, irreducible compatible coefficients and
**whole** highest piece, let \(h:W\to S\) be any permitted dominant
connected-generic-fiber map and let \(\ell\subset h^*E\) be any algebraic
line inducing the pulled-back compact marks. On the specified resolved
unipotent tautological extensions, with
\(U_j=\bigoplus_{i\ge j}G_i,\ L_j=-\det U_j\), every \(L_j\) is nef and
\[
 \nu\left(\sum_jc_jL_j+tH\right)
   =\nu\left(\sum_jc_jL_j\right)=\nu(L_0+L_1)
\]
for all rational \(c_0,c_1>0,\ c_j\ge0\ (j\ge2),\ t\ge0\).
This is the already-recorded `C_COMMON_TAIL_DIMENSION`, not a new
strengthening from this review. All weights one recovers the original
all-tail proposition but is not the limit of the assessment.
The invariant is **numerical**, not Iitaka, dimension.

Local kernel equality gives the last equality. Algebraic orbit filling
supplies the universal commutators needed by the root theorem, so
two-tail nullity fixes the whole highest space and the compatible
marks. Boundary mixed mass converts the maximum-rank comparison to the
first numerical equality. None of those interfaces may be replaced
by the diagonal test or by the numerical rank of one matrix.

## Historical support and source identity

The strongest statement hash exactly matches
`judgement-C_COMMON_TAIL_DIMENSION-adb16092602d`, filed by
`reviewer:copilot-872fb7da27af`. Matching component/assumption support
and all versions are catalogued in the index. The receipts bind subject
hashes and artifact **paths**, not artifact digests or graph closure.
All historical graph nodes remain open and `reviewer_confirmed:false`;
positive receipts are relevant support, not current unit/family acceptance.

Five core files match the November 6, 2026 preserved snapshot: the old
ledger, graph, report, exact certificate and checker. The other 12
listed files are not entries in that manifest's Family-033 slice;
their presence does not justify invented snapshot matches.
The later independent source packet substantively addresses the
engineer's missing Deligne and zero-Lelong source readings via a
source-linked translation and the primary coauthored
Demailly--Peternell--Schneider lemma. It also checks the root-theoretic
steps directly. The original source-access and uncited metadata are
preserved, and judgement receipts are not relabelled as
`citation_check attribute` certificates.

The five manuscript packages are reference inputs, not additional Argus
drafts. Their 58 TeX files match the assigned manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`. No complete-manuscript
correctness or verified novelty finding is made.

## Exact replay and unresolved mathematics

The unchanged checker replay succeeds with Python 3.13.5, standard
library only, all eight universal identities, arbitrary-word induction,
the block-rank identity, the sl4 obstruction and 10 rejected negative
controls. Its current output is
`draft_reviews/local-tail-kernel/replay.json`.
A fresh inspected Jacobian 0.14.0 sidecar operation
`matrix.symbolic.rank.compute`, protocol `2025-11-25`, reproduces rank 3
and pivots `[0,1,2]` for the identical rational matrix; typed request,
output and successful non-timeout status are in `draft_reviews/root-kernel/`.
No actual Lean theorem is present in the inventoried drafts or reference
packages. These computations certify local algebra, not external Hodge
theory or global geometry.

The downstream report identifies the concrete obligations: original
geometric-vector lattices and zero tests; actual marked descent and
adjoint bigness; fixed-source relative-Iitaka section comparison and
moduli/rank conditions; a uniform pseudoeffective threshold; relative
pseudoeffectivity; and verification of every twist-removal hypothesis
in the geometric application. The point-quotient assembly and the
conditional nef-subtraction/twist implication have supported arguments,
but do not establish those premises. Full logarithmic additivity also
requires the companion lower inequality. These are review findings,
not permission to restart the old search or declare the source false.

## Campaign-local validation and disposition

The validation record is `draft_reviews/review-validation.json`.
`draft_reviews/check_review.py` verifies the exact inventory,
claim/version/assumption/receipt mapping and report/verdict/summary
consistency: its **coverage check exits 0**. Its overall exit remains 2
to preserve the official gate failure below, rather than present that
coverage result as full campaign acceptance.
The exact checked root is
`campaigns/9200033`.
The current-review `math_state check` exits **0**, with no structural
issues. The official `proof_graph_check check` exits **2**:
`no proof graph at .../9200033/research/PROOF_GRAPH.json`.
The five historical snapshot-bound graph/ledger/proof artifacts are not
a substitute for a current campaign graph, and no check was redirected
to the shared batch root or old workspace.

**Handoff gate blocked:** creating `research/PROOF_GRAPH.json` is outside
this mission's explicit writable paths. It was not fabricated, copied
from the old graph, or written by weakening the task. This missing
authorized project artifact prevents the requested pair of zero exits;
it is an operational gate blocker, not a mathematical gap in one of
the assessed arguments. The substantive assessments and their exact
inventory/version coverage can still be examined by the native
Reviewer, but the campaign-local gate does not currently permit
acceptance.

The current ledger contains only four new review findings and the ten
explicit classical inputs to the weighted assessment. It does not import
old reviewer opinions as fresh independent approval. The current
zero-Lelong assumption cites the exact rational-line consequence in
the coauthored source; the current regular-singular assumption identifies
the retained translation. The historical ledger and its original
citation metadata remain unchanged in the index.

The exploratory target is unchanged. Current acceptance of the complete
coverage and substantive assessments belongs only to the Host-invoked
native independent Reviewer; the engineer does not self-accept.
