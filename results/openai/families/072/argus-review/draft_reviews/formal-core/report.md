# Exact checks, historical Lean runs, and statement fidelity

**Assessment:** all 38 existing symbolic checks replay successfully, and an
exact copy of the successful historical Lean source freshly compiles and
passes the supplied axiom audit. This supports the delimited formal
subset, not the surrounding analytic classification. Statement fidelity
and whole-family acceptance remain for the native independent Reviewer.

## What was reviewed

This unit covers `C_AT_FORMAL` v1-2 and the listed checker, exact
certificate, typed Jacobian request/result, both archived Lean certificates,
compile log, submit receipt, check record, verification wrapper, and
statement-fidelity document. Their artifact-by-artifact dispositions are
in [`DRAFT_REVIEW_INDEX.json`](../../DRAFT_REVIEW_INDEX.json).

The two archived certificates bind their own source text and fidelity
text to matching recorded digests. The successful archive text matches
the listed old Main.lean and fidelity file exactly. The source difference
between v1 and v2 is solely
`def quadratic` -> `noncomputable def quadratic`.

| Historical evidence | Actual disposition |
|---|---|
| `C_AT_FORMAL-e4f44655c6dc3dc1.json` | Compiler exit 1, status `type_error`, audit not run. The diagnostic is `lean.dependsOnNoncomputable`: the definition depends on noncomputable `Complex.instDivInvMonoid`. An empty proof-hole list in this failed run is not success. |
| `lean_submit.json` | Receipt for that failed run, with an explicit supersession note. It is not a second proof. |
| `C_AT_FORMAL-73beaf30d9a45687.json` | Compiler exit 0, audit exit 0, proof_holes=[], after the annotation. Mechanical evidence binds to v2, not v1. |
| `lean_check.json`, `lean_verification.json`, `compile.log` | The same successful historical compiler/audit result, with the verification file adding the ledger-recording wrapper. The compile log is successful, not the failed run's log. These overlapping files are not independent replications. |

Both historical runs used Lean 4.31.0, Lake 5.0.0-src+68218e8,
and the built Mathlib workspace at
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
The obsolete run failed compilation, not a mathematical statement.
The successful run still explicitly says its natural-language
interpretation has not been independently verified.

## Fresh replay and actual environment

The current-owned [`replay/Main.lean`](replay/Main.lean) is byte-identical
to the listed old successful source. No old file, snapshot member, or
manuscript source was changed. The new
[`statement_fidelity.md`](replay/statement_fidelity.md) is a deliberately
delimited reading, not a rewritten old input.

The prescribed legacy Argus interpreter initially failed **before
compilation** because an omitted timeout reached `float(None)` in
`argus_skill/tools/lean_check.py:156`. The first durable receipt is
[`lean_submit.json`](replay/lean_submit.json), task `review-072-lean`,
run `review-072-lean-1794088779692505296`; its error is retained in
the current `.argus_subagents/review-072-lean_logs/stderr.log`.
No runtime patch was made.

The materially changed invocation supplied `--timeout 300`:

```text
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/draft_reviews/formal-core/replay/Main.lean --statement-fidelity research/draft_reviews/formal-core/replay/statement_fidelity.md --claim C_REPLAY_FORMAL --project-root campaigns/9200072 --timeout 300
```

Its durable receipt is
[`lean_bounded_submit.json`](replay/lean_bounded_submit.json):
task `review-072-lean-bounded`, run
`review-072-lean-bounded-1794089272482752764`, final state `done`,
runner exit 0. The official result
[`lean_verification.json`](replay/lean_verification.json) records:

- Lean 4.31.0, commit 68218e876d2a38b1985b8590fff244a83c321783;
  Lake 5.0.0-src+68218e8; elan 4.2.3.
- The existing built Mathlib workspace above; no new Lake project or
  dependency installation.
- Compiler exit 0, axiom-audit exit 0, proof_holes=[], duration 16680 ms.
  The only compiler message is the existing unused-variable warning.
- Fresh mechanical evidence for **`C_REPLAY_FORMAL` only**, archived at
  `replay/certificates/C_REPLAY_FORMAL-69e6c5def98e90e9.json`.
  The review claim does not stand on an old Lean certificate.

Neither source nor fidelity document was edited during or after this
successful verification.

The read-only old `verify.py` was separately replayed without `--write`.
The first selected Argus-latest environment lacked SymPy; this is recorded
as an environment failure, not a failed identity. The confirmed existing
Argus-live-update interpreter ran the ordinary Python checker using
Python 3.13.5 and SymPy 1.14.0, with exit 0, 38 exact checks, no stderr,
and 0.751 s elapsed. See
[`symbolic_replay.json`](replay/symbolic_replay.json). No package was
installed in either shared runtime.

## The exact encoded mathematical scope

| Declaration | What the compiler actually establishes |
|---|---|
| `le_of_small_error` | An inequality for reals from all positive additive errors. |
| `exhausted_comparison` | An abstract sequence comparison, assuming its finite-cutoff bounds and exhaustion property. No spatial exhaustion, law, or convergence theorem is constructed. |
| `box_factor_bound` | A real product bound with explicit small nonnegative error hypotheses. The geometric boxes and their limiting errors are outside Lean. |
| `strict_gain_forces_zero` | For any measure and three real integrable functions with nonnegativity, pointwise strict gain, transport-integral inequality, and balanced integrals assumed, the positive and negative functions vanish almost everywhere. Integrability of gain is a hypothesis; no uniform gap is assumed. |
| `inverse_square_endpoint` | From real beta>=1, real j<=0, and the displayed real moment identity, conclude beta=1. |
| `inverse_first_endpoint` | From real beta>=1/4, real j<=0, and its moment identity, conclude beta=1/4, not impossibility of equality. |
| `quadratic_denominator_ne_zero`, `quadratic_at_i` | The complex denominator is nonzero for every real vertex, and F_t(i)=0. |
| `quadratic_injective_on_upper_half_plane` | Set-restricted injectivity of the displayed complex quadratic for every real vertex. |

The old fidelity document describes these declarations substantially
accurately. Its natural claim's word **admissibility** must not be read
as a formal theorem that F_t belongs to K: holomorphy and F_t'(i)=1
are not declared conclusions in this file. They hold by the elementary
polynomial formula and are checked in prose/symbolic identities, but
they remain different evidence. Similarly, "without additional axioms"
means no introduced proof holes/nonstandard axioms passed the supplied
audit, not that Lean/Mathlib has no logical foundations.

The source contains no definition of K as an analytic class, probability
law of maps, exact affine covariance, compact superlevels, index count,
Borel rank selection, exceptional-root transfer, geometric area comparison,
moment differentiation, harmonic rigidity, or measure classification.
The three analytic unit reports identify where those premises are actually
argued. Compilation cannot fill them in by association.

## Typed Jacobian replay and symbolic limits

The current adapter discovery returned five candidate operations. The
exact input/output contract of `matrix.symbolic.determinant.compute` was
inspected before execution; both records are dedicated JSON files in
`replay/`. One bounded operation was then run on the **existing old
dedicated JSON payload**. The preserved current
[`jacobian_result.json`](replay/jacobian_result.json) binds that exact
payload and records Jacobian server 0.14.0, protocol 2025-11-25,
transport mcp-stdio, and method SYMPY_BAREISS. Adapter exit is 0,
structured error null, timeout false; its typed output matches the old
typed determinant exactly. See
[`jacobian_replay_status.json`](replay/jacobian_replay_status.json).

It computes the determinant of
[[k+a,-b],[b,k-1+a]], namely
k(k-1)+(2k-1)a+a^2+b^2. The old symbolic checker independently
reconstructs that sparse rational-function payload and recomputes it.
The 38 checks also verify the Hessian sign, affine inverse determinant,
weight exponents, moment factorization, fixed-N box limit, quadratic
identities, and Cauchy pushforward density.

The saved certificate's `new_theorem` label and the checker's phrase
"critical ... law verified" must be read with its own stated scope:
these are exact algebraic identities, not a kernel derivation of global
analytic existence, classification, or novelty. A local determinant is
neither an analytic proof nor a counterexample to the manuscripts.

## Gates and unresolved obligations

For project root
`campaigns/9200072`,
the successful durable command also ran the official `math_state check`
and `proof_graph_check check`, both exit 0 (seven review/replay nodes).
The separately requested `argus_skill.verticals.math.check` module is
absent from Argus-latest: its exact diagnostic was
`No module named argus_skill.verticals.math.check`, exit 1.
This is disclosed, not replaced with a claim that the unavailable gate
ran. There is no accepted-review/framework-close failure or associated
Host events.jsonl line yet; no framework-maintenance work was opened.

The remaining substantive formal obligation for anyone asserting a
machine-checked global theorem is to encode and prove the missing
analytic premises and measure classification. This review does not
repair that absence. The current formal subset is verified; its
statement-fidelity reading and all analytic assessments still need
the native independent Reviewer's judgement. No kernel certificate
or historical reviewer name accepts this review.
