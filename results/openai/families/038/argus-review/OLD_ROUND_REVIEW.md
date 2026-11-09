# Family 038 old-draft review

**All 40 listed artifacts, all 17 historical claim versions, and the complete
nine-file reference tree are accounted for in seven substantive assessments.**
Each unit has `report.md` and `verdict.json`. The exact old scalar proof and
bounded computations were replayed successfully without modifying old inputs.
The [accepted native round-1 review][accepted-review] supports all seven
scope-qualified assessments, the separate Lean statement-fidelity reading,
and Gardner attribution. This final submission preserves
`research_target_level=exploratory`. Project-level certification by the native
Host-invoked independent Reviewer remains pending; the accepted bounded review
is not itself that certification. Neither acceptance certifies an unconditional
Fujita proof.

## Complete coverage and version binding

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) was written before
substantive assessment. The active ledger then recorded the claims, cited
dependencies, upstream limitations and the failure of finite checking as a
universal-proof proxy. The collection is **one composite Argus point-center
draft**, not forty separate results. Its component theorems and two embedded
strengthenings are divided as follows:

| Unit | Engineer-supported scope | Concrete remaining boundary |
|---|---|---|
| [uniform-restrictions](draft_reviews/uniform-restrictions/report.md) | Uniform restriction-image bound for every integral moving center and every sufficiently large integer degree; known-argument reproduction | No restriction surjectivity or degree-dependent uniform slope |
| [pure-initials-weighted-growth](draft_reviews/pure-initials-weighted-growth/report.md) | Pure Taylor initials, bounded cube, weighted old-slice growth, and exact \(d/2\) moment error | Geometric premises and compact-set Brunn-Minkowski are not formalized |
| [fixed-degree-first-variation](draft_reviews/fixed-degree-first-variation/report.md) | \(T_m\leq d/t\) for each attained minimizing test, conditional on fixed-degree specialization | The closed-locus specialization theorem is not established by differentiation or its fixture |
| [universal-partition-obstruction](draft_reviews/universal-partition-obstruction/report.md) | Fresh kernel-checked all-natural-\(n\), all-\(l\geq2\) scalar implication and finite algebra | Geometric extraction is a hypothesis, not a Lean conclusion |
| [conditional-geometric-bridge](draft_reviews/conditional-geometric-bridge/report.md) | Eventual every-minimizer point centers along every fixed-\(t\) positive-liminf sequence, under exposed upstream hypotheses | Ordinary gap, uniform sublevels/discrepancy, attainment and specialization remain unverified upstream |
| [quantitative-strengthening](draft_reviews/quantitative-strengthening/report.md) | Explicit sufficient \(t>n+1-a/(n+2)\), error-controlled closure and midpoint parameter | Conditional geometry; neither optimality nor novelty is established |
| [abstract-slope-strengthening](draft_reviews/abstract-slope-strengthening/report.md) | Uniform-slope implication \(\sigma(t+a/(n+2))\leq n+1\) for the stated abstract structural premises | A concrete application must prove its uniform slope/cube and comparisons; moving-center degree slopes are not supplied |

The version map covers `C9000038@1`, `FUJITA9000038@1`, `UP9000038@1`,
`UR9000038@1-3`, `SG9000038@1-2`, `FV9000038@1-2`, `PC9000038@1-4`,
and `PCBRIDGE9000038@1-3`. Exact statements, contexts, assumption records,
evidence subjects and certificate/version bindings are retained in
[`draft_reviews/input_bindings.json`](draft_reviews/input_bindings.json).
The audit-objective claim is historical data, not a current instruction.
The original Fujita target and its upstream bundle are explicitly assessed
as outlying obligations, not silently counted as established component results.
The graph's `PCREVIEW` and `ISO` nodes are obligations, not extra proved drafts.

All eleven campaign entries in the existing preserved manifest match the old
workspace hashes and sizes. The archive was not unpacked, rebuilt or edited;
this is manifest agreement, not a new archive-integrity claim. The additional
29 listed artifacts are accounted for as live old-workspace supporting inputs,
not misrepresented as members of that preserved eleven-entry subset.

The reference container is a directory whose manuscript child is a symlink
to the explicitly assigned source tree. Following that link yields exactly
seven TeX sources, the OpenAI README and a bibliography companion. All seven
source hashes match the existing manuscript manifest at revision
`4eaee87548250b2682affda7d05d947c05554bae`. README/main attribution is
OpenAI, September 23, 2026. The original `main.tex` claims Fujita generation;
its claim is not a mathematical conclusion of this review.

Lock markers, empty stderr files, pipeline/submit receipts, bibliography
companions and the proof-route illustration contain no separate result.
The four mathematical-state check outputs are byte-identical, as are the
four proof-graph receipts and the two failed pipeline receipts; see
[`draft_reviews/supporting_artifacts.json`](draft_reviews/supporting_artifacts.json).
Compiler attempts and repeated copies of the same argument are counted as
versions/support, not independent theorems.

## Mathematical findings and actual execution

No gap was found in the seven **scope-qualified** implications reviewed here.
That is not a blanket certification of the manuscript. The decisive checks
include restriction-image interpolation with center-independent constants,
pure-initial elimination without extending sections on \(W\), the correct
Brunn-Minkowski lower orientation, fixed exponential weights, and the
first-variation **upper** sign. The geometric bridge takes the degree limit
at fixed partition length and uses scaled tests at \(x\); only the fixed
reference-degree derivative uses specialization at \(y\).

The old report's every-liminf-sequence eventual theorem is stronger in wording
than the ledger's existential-subsequence phrase, and its proof supports that
stronger scope. Neither states point centers in every sufficiently large
degree without a liminf hypothesis.

The strongest relevant prior formal result is `PC9000038@4`, certificate
`PC9000038-a85c81f177e68679.json`. The other two certificates bind versions 2
and 3 and report actual type errors, exit 1, not mathematical refutations or
proofs. Empty `proof_holes` on those unsuccessful runs does not certify them.
The old route's scalar obligation still points to version 1; its record is
not silently rebound to the successful version 4.

Only the unchanged final Lean source and fidelity document were copied for
safe replay. A real fresh official run with
`$WORKSPACE/argus-latest/.venv/bin/python` completed in 18,060 ms:
compiler exit 0, axiom-audit exit 0, no proof holes and no recording refusals.
It generated the claim-bound
[`C1-7ae5dd88ea411ff5.json`](draft_reviews/universal-partition-obstruction/replay/certificates/C1-7ae5dd88ea411ff5.json).
The source and fidelity hashes equal the final historical versions. Actual
tools were Lean 4.31.0 (commit
`68218e876d2a38b1985b8590fff244a83c321783`), Lake 5.0.0-src+68218e8,
elan 4.2.3, and the existing Mathlib workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
No new toolchain or lakefile was installed. Only `propext`,
`Classical.choice` and `Quot.sound` appear in the printed axiom lists.
The active ledger derives `closed_kernel` for the **scalar** `C1`, not for
geometry or Fujita generation.

Statement fidelity was separately examined: \(d\) is a positive real in the
scalar theorem, \(n\) ranges over all naturals, and every \(l\geq2\) is a
premise. The geometric application has \(n\geq1\), making its omitted
zero-index term vanish. `moment_telescope` assumes the endpoint moment
comparison, and `partition_obstruction` assumes all extracted per-partition
inequalities. The compiler does not verify those interpretations; native
independent fidelity review separately accepted this exact scalar scope.

The original checker was freshly executed once with no writing flags. It
reconstructed the existing certificate and passed 773 simplex moments,
282 discrete cube-sum fixtures, 160 rational polynomial partition fixtures
and 39 weighted-growth instances. None was enlarged. They are finite
regressions, not universal proofs. Its \(\mathbb P^2\) example has
\(T_{12}=91477/196610\) and normalized derivative
\(-77821/589830<0\): this particular positive-center test is **not minimizing**,
not a counterexample to a manuscript proposition.

One bounded typed Jacobian factorization was discovered, inspected and executed
through the isolated adapter with the mandated live-update interpreter.
The unchanged six-term QQ payload produced `FACTORIZED`, exact reconstruction,
adapter exit 0, no structured error and runtime 286 ms; server 0.14.0,
protocol 2025-11-25. The fresh factors were independently multiplied with exact
rationals. Operation ID, exact payload, typed output, contract and diagnostics
are retained under `draft_reviews/`. This is a polynomial identity, not a
proof of a geometric hypothesis or universal sign. The initial durable Lean
submission's preflight failure is separately preserved as a no-run
environment fact; the corrected submission actually compiled.

The quantitative draft replaces a qualitative integral-based choice with an
explicit sufficient inequality and a universal error bound; the structural
draft exposes a uniform \(\sigma\) transfer. This review adds coverage,
version binding and scope/provenance assessment, **not a new mathematical
theorem**. The draft's unsuccessful novelty lookup is not verified novelty,
and its historical publication-target labels do not raise the current
exploratory review bar.

## Historical reviewer provenance and open mathematical boundaries

The old schema stores assumptions inside claim versions and judgements as
evidence rows. There are 19 evidence rows: three mechanical, four
Engineer-labelled judgements and twelve `reviewer:copilot` judgements.
The latter comprise nine `supports` and three `inconclusive` entries.
Supporting component/citation opinions can be reused as attributable
historical opinions and source passages at their unchanged scope.
The contradictory provenance is not resolved by choosing the more favorable
label: the old progress receipt is `pending`, `acceptance_recorded:false`,
and explicitly says independent review was not performed by the Engineer;
the `PCREVIEW` node is also open. No separate native acceptance receipt
establishes the independence or family authority of those labels.

The reviewer-labelled upstream/minimizer/specialization entries are themselves
`inconclusive`, consistent with a **conditional** bridge opinion. The current
Engineer read Gardner's primary retained theorem and its hypotheses, but did
not manufacture an independent citation verdict under another name. The native
Reviewer subsequently recorded supporting `BM-compact` attribution in
[`research/literature/48b52023a60fa7bd81b7fa15a2c801ff.json`](literature/48b52023a60fa7bd81b7fa15a2c801ff.json).
Stacks and manuscript inputs retain their explicit prose citations/uncited
status rather than invented versioned identifiers. Their exact propositions,
application and limitations are exposed in the unchanged unit reports and
active ledger.

For an unconditional point-center result, concrete unresolved obligations are
the strict ordinary-order gap, uniform positive sublevel/discrepancy bounds,
attainment using one fixed adapted flag/SNC model, and closed-locus
specialization of normalized rational order lists. For full Fujita generation,
the isolated equality/rational-support construction, nef-and-big boundary,
Kawamata-Viehweg restriction surjection, lifting and nonvanishing descent
are additionally required. These are named boundaries of existing work,
not new attacks or assertions that the original source is correct or false.

## Native review and final exploratory submission

The initial Engineer coverage result is
[`draft_reviews/coverage_validation.json`](draft_reviews/coverage_validation.json).
It and the seven unit reports retain their original pre-review status wording.
The [accepted native receipt][accepted-review] and the current claim-bound
`reviewer:native-9200038` judgments supersede those pending notices; neither
historical labels nor an Engineer-authored status replace independent review.
The seven report/verdict pairs, claim versions, Lean source, fidelity document,
and certificates are unchanged.

The installed final-stage contract,
`argus_skill.verticals.math.stages.stage_completion_issues("review", project_root)`,
was run with `$WORKSPACE/argus-latest/.venv/bin/python` against exactly
`campaigns/9200038`.
It returned no issues, exit **0**, with the persisted exploratory objective and
target. The `final_submission` verification profile resolves to `certify`.
An exploratory project does not require the optional proof graph. The original
standalone graph-check exit **2** and ledger-check exit **0** remain honestly
recorded in
[`draft_reviews/final_validation.json`](draft_reviews/final_validation.json);
the missing graph is not a current completion-contract blocker.

The submitted outcome is the complete exploratory draft review, with no new
theorem or novelty claim. The native Host-invoked Reviewer must now decide
project-level completion under the full-pipeline final-submission contract and
provide its structured research result. The Host, not Engineer, persists
`final_submission_certified` against the current project state after that
verdict. The earlier bounded acceptance receipt alone cannot close this gate.

[accepted-review]: $WORKSPACE/.argus-campaign-9200038/projects/30e555c7ee8f/handoffs/664ced6c8791/round-0001.json
