# Family 057: complete old-draft review

**Engineer assessment complete; native independent Reviewer acceptance is
pending.** This is an exploratory review of existing Argus work, not a new
manuscript-error search or a claim that the three source manuscripts are
correct. The review result is `result_class=honest_final_report`,
`research_target_level=exploratory`, `novelty_status=not_applicable`.

## Coverage and provenance

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) accounts for all **23
listed files**, the one reference directory, all **11 claim-version records**
covering eight old claim ids, **33 indexed argument/subclaim dispositions**,
all seven historical Reviewer-support entries, dependencies, duplicates and
exclusions. The seven assessment units below are parts of one shared
weighted-inverse draft, not seven independently original results.

The existing November 6, 2026 10:20Z snapshot manifest has **nine** core
records for campaign 9000057. Each current core file matches the recorded
bytes and SHA-256. The other **14** listed files are additional supporting
inputs: they exist and match their inventory sizes, but are not silently
called snapshot-covered. The two empty lock files are operational exclusions.
The existing snapshot/manifest was not rebuilt, extracted or modified.
The scalar worker's before/after comparison also found all 23 old inputs
unchanged.

The reference directory contains three source manuscripts, not three
additional Argus drafts. All **31** staged TeX source files match the existing
campaign-9100057 manifest at revision
`4eaee87548250b2682affda7d05d947c05554bae`. Only the compact manuscript's
standing hypotheses, weighted-inverse lemma and immediately relevant source
attribution are used mathematically here. The other two manuscripts are
explicitly excluded as reference-only: no inventoried Argus argument proves
or attacks them. Old `C9000057@1` is an open campaign objective, not a completed
family theorem or evidence of three completed audits.

The index was written first. The current review ledger then recorded the
conditional scope, cited duality assumption, prior review records, historical
Demailly-source limitation and known failed inferences before substantive
checking. The inherited Wiki index yielded no relevant family-057 analytic
source; it was not treated as evidence. Campaign 9000057, its ledgers, all old
inputs, reference manuscripts and the preserved snapshot remained read-only.

## Every mathematical unit

Each linked directory contains both a substantive `report.md` and a
machine-readable `verdict.json`, including each old claim's attribution,
novelty status and open status.

| Unit | Old claims / arguments | Assessment and exact limit |
|---|---|---|
| [Conditional weighted inverse](draft_reviews/conditional_weighted_inverse/report.md) ([verdict](draft_reviews/conditional_weighted_inverse/verdict.json)) | `C_SWI@1` | Supported conditional analytic lemma, including exactness, closed ranges, zero degree-zero kernel and the uniform inverse bound. The common scalar gaps are assumed, not proved. No downstream theorem follows from this assessment. |
| [Complete domains](draft_reviews/complete_domains/report.md) ([verdict](draft_reviews/complete_domains/verdict.json)) | `L_SWI_DOMAINS@1` | Supported fixed-parameter differential-domain/norm equivalence, inherited exactness and closed ranges, and complete form cores. This does not equate weighted/unweighted adjoint domains or assert an incomplete-domain theorem. |
| [Bochner estimate](draft_reviews/bochner_estimate/report.md) ([verdict](draft_reviews/bochner_estimate/verdict.json)) | `L_SWI_BOCHNER@1,@2,@3` | Supported local Chern-adjoint cancellation, curvature sign, uniform product gaps and complete-form-domain inequality. The version-2 Demailly dependency was unverified; version 3 retires it with an assessed local derivation. No checked-2012-locator claim is made. |
| [Minimal lifts](draft_reviews/minimal_lifts/report.md) ([verdict](draft_reviews/minimal_lifts/verdict.json)) | `L_SWI_LIFTS@1` | Supported for **nonzero** lower spectral bands, with the original inequality direction. Coarse exactness/closed ranges precede `A^(-1)`, so the proof is not circular and does not assume eigenvectors. |
| [Serre duality](draft_reviews/serre_duality/report.md) ([verdict](draft_reviews/serre_duality/verdict.json)) | `L_SWI_DUALITY@1` | Supported complete-domain reciprocal-metric transfer, reversed exactness and unchanged inverse norms. The primary source distinguishes maximal/minimal extensions; finite-chart orbifold specialization is the draft's argument, not the paper's theorem by attribution. |
| [Scalar certificate](draft_reviews/scalar_certificate/report.md) ([verdict](draft_reviews/scalar_certificate/verdict.json)) | `C_SWI_ALG@1,@2`; six declarations and local exterior algebra | Version 1 failed normalization elaboration; version 2 repairs it and freshly compiles. Fidelity is accurate at the universal scalar/finite-sum scope. Neither the old nor fresh compiler certificate proves analytic applicability or review completeness. |
| [Quantitative refinements](draft_reviews/quantitative_refinements/report.md) ([verdict](draft_reviews/quantitative_refinements/verdict.json)) | `L_SWI_QUADRATIC@1`; direct-form proof, root/coarse minimum, constants, abstract sharpness and six examples | Supported conditional deductions and exact abstract comparison-class sharpness. The manuscript already states the spectral quadratic and exponential exponents. The examples do not realize a common geometric scalar multiplier or prove geometric optimality. |

No concrete invalid step was identified in the latest conditional analytic
chain at its explicit hypotheses. This is a scoped mathematical judgement,
not a blanket assurance about its source manuscript. There is also no
fabricated unresolved problem merely because an analytic argument is not
formalized.

## Decisive mathematical checks

The uniform scalar `x` gaps on the product supply both the unweighted
`E^*`-valued `(m,*)` gap and the `(p,0)` gap. Scaling the `y` metric only
changes Hilbert multiplicities and a nonnegative energy. Bounded norm
equivalence then preserves differential domains and inherits exactness and
closed ranges. Completeness, cutoff commutators and compact local invariant
smoothing justify the weighted form cores even with globally unbounded
derivatives of the smooth bounded multiplier.

For `B=exp(b)`, `a=m*C0*t`, a nonzero closed adjoint-domain form and its
unweighted minimal primitive give, with `H=||eta||_h^2`,
`N=||eta||_0^2`, `Q=||d_h^*eta||_h^2`, `L=||u||_h^2`,

\[
 H^2\le QL,\quad \delta L\le BN,\quad \delta N\le Q+aH
 \quad\Longrightarrow\quad
 \delta^2H^2\le BQ(Q+aH).
\]

Thus `x=Q/H` satisfies `x(x+a)>=delta^2/B`. On nonzero lower bands this
implies the manuscript's `mu(mu+a)>=delta^2/B`, not its reverse. The
positive root and coarse norm bound give

\[
 r=\frac{\sqrt{a^2+4\delta^2/B}-a}{2}>0,\qquad
 \|V\|\le\min\{\sqrt{B/\delta},\,r^{-1/2}\},
\]

and hence

\[
 \|V\|^2\le e^{b/2}/\delta+
            mC_0t e^b/\delta^2.
\]

The bundle-dual star, distinct from the complex-linear form-index star used
in Bochner, transfers this bound isometrically to the reversed `E` complex.
All the operator/domain implications needed for this substitution are
assessed in the analytic unit reports, not delegated to scalar algebra.

The two-term `C --sqrt(delta)--> C` witnesses attain
`max(delta/B,r)` throughout the **abstract**, degree-dependent two-norm
comparison class, with the switch at `a=delta(1-1/B)`. The continuous
construction, not six samples, supports that abstract assertion. No common
scalar bundle-multiplier geometric realization was supplied or claimed.

## Historical version and review reconciliation

The old graph says pending review for the same nodes that have ledger
Reviewer-support judgements by `reviewer:gpt-6.1-sol:36cf1beb21ae`.
The index matches them by exact subject and artifact:

| Old subject | Reviewer evidence id | Artifact and reconciliation |
|---|---|---|
| `C_SWI@1` | `judgement-C_SWI-84f7f2f9c48e` | Shared `proof.md`, matching subject. |
| `L_SWI_DOMAINS@1` | `judgement-L_SWI_DOMAINS-d95423e19ced` | Shared `proof.md`, matching subject. |
| `L_SWI_BOCHNER@1,@2,@3` | `judgement-L_SWI_BOCHNER-639471ed0ad5` | Shared mathematical hash and `proof.md`; judgement cannot distinguish the changed assumption histories. |
| `L_SWI_LIFTS@1` | `judgement-L_SWI_LIFTS-8cd42ce70c44` | Shared `proof.md`, matching subject. |
| `L_SWI_QUADRATIC@1` | `judgement-L_SWI_QUADRATIC-a06e9bb02ac0` | Shared `proof.md`, matching subject; not an endorsement of geometric sharpness. |
| `L_SWI_DUALITY@1` | `judgement-L_SWI_DUALITY-1d7ef573e28a` | Shared `proof.md`, matching subject. |
| `C_SWI_ALG@2` | `judgement-C_SWI_ALG-d76e38fbe08b` | Exact archived source/fidelity/compiler pairing; does not support version 1 or review completeness. |

The six prose judgements name artifact paths without archiving the bytes
read at judgement time. Current files match the preserved core manifest,
but no missing historical timestamp or byte binding is invented. The
scalar certificate does bind its source/fidelity text to the version-2
subject. Therefore the old graph's labels do not establish that no review
occurred, and the ledger's support entries do not automatically settle
current acceptance or all assumption histories.

The historical scalar failure is specific, not a mathematical counterexample:
`normalized_comparison` passed `1<=energy*lift` where the specialization
required `1^2<=energy*lift`. Version 2 adds the explicit `simpa` conversion;
it also removes an unreachable `ring` tactic. The successful latest
`compile.log`, `lean_check.json`, fixed-run result and archived certificate
are consistent with version 2. The first run additionally refused evidence
for an earlier fidelity document that did not name the declarations.
None of these old failures was concealed or counted as a second theorem.

The strongest prior result already claimed the conditional lemma, its scalar
formalization and abstract bounds, with Reviewer-support entries. The
improvement here is **complete assessment, provenance reconciliation and
replay**, not a stronger theorem or newly verified novelty.

## Actual toolchains, sources and exclusions

Both assigned Argus interpreters report **Python 3.13.5**. Legacy math-state,
citation and Lean commands ran through
`$WORKSPACE/argus-latest/.venv/bin/python`.
The legacy environment has no `argus_skill.verticals.math.check` module;
the prescribed live-update environment supplies that delivery command.
This was a tooling difference, not a mathematical failure or a reason to
modify the framework.

The inspected read-only old `verify.py` ran once and passed the exact
polynomial, exterior-commutator and all six rational-example/provenance
checks. Its stdout is in the scalar unit. It neither recompiles Lean nor
judges the contents of `proof.md`.

A byte-identical source/fidelity copy received a fresh real Lean
**4.31.0** compilation and official axiom audit, exits **0/0**,
`proof_holes=[]`, with Lake **5.0.0-src+68218e8**, elan **4.2.3**, actual
workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
The durable direct run was reclaimed successfully. Its certificate is
attached only to the separate mathematical claim `R057_REPLAY_SCALAR`,
not `R057_COVERAGE` or any claim asserting assessment quality.
The official audit checks introduced axioms, not absence of all imported
foundational axioms. Compilation and human statement-fidelity assessment
are distinguished.

Exactly one current bounded matching Jacobian operation was executed after
discovery and inspection through the required live-update adapter:
`polynomial.sos.decomposition.check`, server **0.14.0**, protocol
**2025-11-25**. It returned `is_valid=true`,
`method=EXACT_COEFFICIENT_IDENTITY`, adapter exit **0**, no timeout/error.
Dedicated JSON retains the exact payload, contract and typed output. It
checks `4*mu^2+4*mu*a+a^2=(2*mu+a)^2`, not an analytic inverse theorem.
The old unexecuted matrix candidate and the initial broad discovery query
are not mathematical evidence.

The independent source reader confirmed the cited **manifold**
maximal/minimal domain propositions in `arxiv:1006.3117v2`; the actual
passages with hypotheses and degrees are archived. The cited assumption
has status `confirmed`, and there is no blocking citation queue. Historical
source-access failure is not used as a substantive verdict. No verified
passage from the particular Demailly-2012 edition was supplied; the old
dependency was retired with a reason and the replacement derivation was
assessed. The local-input scope/history assumptions are deliberately prose
provenance records, not fabricated canonical literature citations.

The following remain outside the supported scope: existence or consistency
of the simultaneous gaps, the zero-spectrum proof, negative-potential and
localization arguments, Hilbert-coefficient positivity, descent, abelianity,
the other two manuscripts, geometric sharpness and a new novelty claim.
Neither compiler success, abstract examples, unavailable sources nor a
failed Argus attack decides any of those questions.

The current review graph keeps every review node `open` and
`reviewer_confirmed=false`: Engineer assessment completion is not
independent acceptance. The Host-invoked native Reviewer must examine the
coverage index and every unit before accepting the family review.

## Final campaign-local verification

Exact project root:
`campaigns/9200057`.
After the final graph update and all eight Engineer-assessment ledger
judgements, the following checks completed:

| Check | Exit status | Measured result |
|---|---:|---|
| Exact index/inventory/version/verdict/evidence coverage check | 0 | 23 artifacts, 9 core + 14 supporting, 11 old versions, 7 units, 33 argument dispositions and all 7 old Reviewer entries accounted for. |
| `argus_skill.verticals.math.math_state check --project-root` the root above | 0 | `ok=true`, `issues=[]`. |
| `argus_skill.verticals.math.proof_graph_check check --project-root` the root above | 0 | `proof graph valid: 8 node(s)`. |
| `argus_skill.verticals.math.check --project-root` the root above `--stage review` | 0 | `ok=true`, `stage=review`, `issues=[]`. |

The three official gates used
`$WORKSPACE/argus-live-update/.venv/bin/python`, against this campaign,
not the shared batch directory. No unchanged compiler or exact-checker run was
repeated for the final gate: it checked the fresh retained evidence.
Passing these checks verifies structural/readiness requirements, not
mathematical or family acceptance by the native independent Reviewer.
