# Finite deterministic cut core — Engineer evidence assessment

## Verdict, source and attribution

**Supported within its exact deterministic finite-array scope, with a successful
fresh compilation and axiom audit. Statement fidelity is assessed separately
below.** This is an Engineer finding, not independent Reviewer acceptance or
family completion. No novelty is established: the old Argus source formalizes
elementary response, triangle-inequality and incident-mass arguments using
Mathlib; it does not reproduce an entire manuscript proof.

The read-only sources are campaign `9000012`:
`research/adaptive-cut-transfer/Main.lean`, `statement_fidelity.md`, all three
archived `C_CUT_FINITE_CORE` certificates, `lean_check.json`, `compile.log`,
`lean_run.json`, `lean_runner_receipt.json`, and the four corresponding old
ledger versions. All three archived certificates, including their embedded
source, fidelity text and compiler diagnostics, were inspected. The current
old `Main.lean` is exactly the formal source of ledger version four:

- Source SHA-256:
  `d1800dc6bc630202612b9382beec27c89d3c39b63f7e66b854e2774e23eb0c47`
  (8348 UTF-8 bytes).
- Fidelity SHA-256:
  `bd64a680b96f41ef996d0a0e8c79c5f4e94c2cea5caa8b661862c93a375e8039`.

The preserved snapshot/manifests and every old source/ledger remain read only.
`replay/provenance.json` records exact source/certificate/ledger bindings.

## Exact statements and hypotheses

The namespace is `AdaptiveCutTransfer`. The formal parameter is an arbitrary
type `ι` with `[Fintype ι] [DecidableEq ι]`. Arrays have type
`ι → ι → ℝ`: **square real arrays on an arbitrary finite index type**, not
only the enumerated four-by-four matrices. There is no nonempty-type
assumption. The source does not explicitly formalize rectangular matrices,
probability spaces, kernels, or a sample-size parameter.

Write

\[
 s(x)=\begin{cases}1&x\ge0\\-1&x<0,\end{cases}\qquad
 R(X)=\sum_k\left|\sum_iX_{ik}\right|,\qquad
 D_JX_{ik}=\begin{cases}0&i\in J\text{ or }k\in J\\X_{ik}&\text{otherwise}.
 \end{cases}
\]

In particular `signPlus 0=1`, and `response` is unnormalized.

1. **`adaptive_response_bound`.** For every real array `A`, every pair of
   real vectors `delta,h`, and **only** the hypothesis
   `forall k, |delta_k| <= 1`, putting `r_i=sum_k A_ik delta_k` gives

   \[
   \sum_i|r_i|\le R\bigl((A_{ik}s(h_i))_{ik}\bigr)
                         +2\sum_i|r_i-h_i|.
   \]

   There is no symmetry, diagonal-zero, degree, accuracy, randomness, or
   unbiasedness hypothesis. `h` is arbitrary, not formally a sampled
   estimator. The left side optimizes row signs **for the specified** column
   vector; the theorem is not syntactically a joint-maximization theorem.
   Uniform quantification permits applying it to a realized maximizing column
   vector without a probability-law claim about the selection.

2. **`good_configuration_lipschitz`.** For all arrays `X,Y`, finite sets `J`
   and real `d`, assume `X_ik=Y_ik` whenever both endpoints are outside `J`.
   Assume **separately for each array** that every absolute row sum and every
   absolute column sum is at most `d`. Then

   \[
                  |R(X)-R(Y)|\le4d\,|J|.
   \]

   These are endpoint-array hypotheses, not an assertion that intermediate
   arrays remain good. There is no connectedness or one-coordinate-path
   assumption. The formal theorem does not itself construct a product-space
   metric or identify which kernel configurations satisfy these hypotheses.

3. **`adaptive_deleted_response_bound`.** For all `A,delta,h,J,d`, assume
   `|delta_k|<=1` and both the absolute row and absolute column sums of `A`
   are bounded by `d`. Then

   \[
    \sum_i|r_i|\le R\!\left(D_J(A_{ik}s(h_i))\right)
                    +2\sum_i|r_i-h_i|+2|J|d.
   \]

   `J` is arbitrary, not formally a random skeleton. There is no explicit
   `d>=0` premise; the mass hypotheses imply it when the index type is
   nonempty, while the empty case has zero sums and `|J|=0`. Both row and
   column hypotheses matter: symmetry is not assumed, and multiplying by row
   signs need not preserve symmetry.

The auxiliary `deletion_bound` has cost `2|J|d`, not `4|J|d`. No normalization
by `M`, let alone `M²`, occurs anywhere in this source. To use manuscript
normalization one must separately identify a positive `M=|ι|` and divide the
inequalities by `M`. The deterministic source does not prove that identification
or any sample-size asymptotic statement.

## Decisive argument and statement fidelity

The proof structure matches these claims:

- The scalar sign-case argument proves
  `|r|-r s(h) <= 2|r-h|`; multiplication by a test of absolute value at most
  one is bounded by the absolute value of its coefficient.
- Finite sum interchange rewrites the row-sign score as a column-test score,
  yielding the adaptive-response inequality after summing scalar losses.
- Triangle inequalities give
  `|R(X)-R(Y)| <= sum_(i,k)|X_ik-Y_ik|`.
- `incident_mass_bound` charges a nonnegative array supported on pairs
  incident to `J` to its rows in `J` and columns in `J`, each costing at most
  `|J|d`. Double charging their intersection is harmless by nonnegativity.
- For a difference of two endpoint arrays the row and column masses are at
  most `2d`, giving `4d|J|`. For deletion they are at most `d`, giving
  `2d|J|`. Row signs have absolute value one, so the final combination retains
  the original mass bounds.

Thus the natural deterministic statement in `C_CUT_FINITE_CORE` and the three
main declarations in the fidelity document agree within the explicit square-
array scope. The fidelity document correctly distinguishes arbitrary good
endpoints from a path of good configurations. This is a mathematical reading
of the declarations, not a feature inferred from compiler exit status.

There are **no domain-specific external assumptions registered on the old
claim**, and no custom axiom or admitted proof declaration in `Main.lean`.
The proof relies on the installed Lean kernel, Mathlib and their usual
foundations/imported real-number and finite-sum results. `noncomputable section`
allows classical real-order decisions; it is not a proof hole.

The successful source does **not** formalize independence, conditional
expectations, integrated moment bounds, sampling-without-replacement moments,
the capped infimum extension, martingales, concentration, a probability tail,
the finite probabilistic transfer theorem, asymptotics, or arithmetic kernels.
The fidelity document's assertion that other parts are proved in `report.md`
is an old author assertion, not a conclusion certified by Lean or accepted
in this unit.

## Four ledger versions and three archived compiler outcomes

The four natural statements are byte-for-byte identical. The versions are
one mathematical argument with evolving formal text, **not independent
mathematical results**. Certificate filenames are not chronological order:

| Old ledger version | Claim hash prefix | Archived certificate suffix | Reported status | Compile exit | Audit exit |
|---|---|---|---|---:|---:|
| 1 | `4403da4d` | none | natural statement only; no formal source | not run | not run |
| 2 | `c77e2db3` | `d03f1859834768ea` | `syntax_error` | 1 | not run |
| 3 | `d298e041` | `96d3e0892fc0cbfb` | `type_error` | 1 | not run |
| 4 | `d96839e9` | `ff9737a934d9878c` | `success` | 0 | 0 |

The exact full hashes, evidence IDs, source hashes and diagnostics are in
`replay/provenance.json` and `verdict.json`.

- **Version two / `d03f...`:** source SHA-256
  `33f1441a657d93489c61036164035eaad36a26f6e728545e98420d5f9d1acaed`.
  The diagnostics include the noncomputable `Real.decidableLE` definition
  error, unexpected `=` in nested absolute-value notation, and failed final
  `linarith` because the response expression was not reduced in the goal.
  The aggregate status says `syntax_error`, but these actual diagnostics
  include more than a parser error. Mechanical verdict: **inconclusive**.
- **Version three / `96d3...`:** source SHA-256
  `5dee7447cc840d95992d224ea29ddf68ede493f30e8ee99b40e3af4c87ebf9f2`.
  It adds the noncomputable section, parentheses, and reduction of `response`
  in both hypothesis and goal, but the spaced nested bars still produce
  `Main.lean:81:13: error: expected no space before`. The reported aggregate
  status is `type_error`; the diagnostic remains a notation/parser problem.
  Mechanical verdict: **inconclusive**.
- **Version four / `ff973...`:** replacing the ambiguous outer bars by
  explicit `abs (...)` yields the current source hash above. It compiles
  with exit **0**, audit exit **0**, and `proof_holes=[]` in 15818 ms.
  Mechanical verdict: **supports**. The only diagnostics are unused
  `[DecidableEq ι]` section-variable warnings in two theorems.

All three certificates contain the same fidelity text/hash. The two failed
checks have empty hole lists but no successful audit; that does **not**
make their unsuccessful compilations proofs. None reports an environment
failure.

The old `lean_check.json`, `compile.log`, and `lean_run.json` agree with the
successful version-four source, toolchain and outcome. They duplicate that
run rather than validating the two failed versions. The runner receipt
`adaptive-cut-core-lean-1` has state **submitted**, which alone is not a
completion result. The old ledger's later judgement record supporting version
four is a historical opinion, not this review's independent acceptance.

## Fresh real compilation

The requested `lean_evidence verify` invocation used the old source and
fidelity paths, active `--project-root`, owned `--artifact-dir`, and the
existing claim `RV_CUT_CORE`. The tool copies the source and fidelity text to
`replay/Main.lean` and `replay/statement_fidelity.md` before compiling; their
bytes and the claim's formal source match the read-only originals exactly.
No lakefile was added, no old source was repaired, and no tooling was installed.

The first durable task, `review012-finite-cut-core-lean-20261107`, exited **1**
before compilation: the legacy `lean_check.py` attempted `float(None)` for
the default timeout. `replay/submission.json` and `durable_status.json`
preserve that real failure. It is not a compiler rejection or evidence about
the mathematical statement.

The retry adds the documented **`--timeout 300`** option, without editing the
tool or source. Its durable task is
`review012-finite-cut-core-lean-timeout-20261107`. It exited **0**:

- Python: `$WORKSPACE/argus-latest/.venv/bin/python`, version
  `3.13.5 | packaged by Anaconda, Inc. | (main, Jun 12 2025, 16:09:02)
  [GCC 11.2.0]`.
- Durable adapter: `$WORKSPACE/argus-live-update/.venv/bin/python`,
  also Python `3.13.5`.
- Lean: `4.31.0`, `x86_64-unknown-linux-gnu`, commit
  `68218e876d2a38b1985b8590fff244a83c321783`, Release.
- Lake: `5.0.0-src+68218e8` (Lean `4.31.0`).
- Elan: `4.2.3 (b6cec7e10 2026-06-08)`.
- Actual compiler: `$WORKSPACE/.elan/bin/lake env lean
  <active-owned replay/Main.lean>`.
- Actual working Mathlib workspace:
  `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
  Its usability was established by this compiler run, not by an existence
  probe alone.
- Compile exit **0**, audit exit **0**, `proof_holes=[]`, empty stderr and
  audit diagnostics; 15786 ms. The two harmless unused-section-variable
  warnings remain.

`replay/lean_run.json` is the preserved complete tool stdout, including the
real kernel record; `lean_check.json` and `compile.log` retain the compiler
and audit details. The current certificate is
`replay/certificates/RV_CUT_CORE-e13acc53d96d1029.json`.
The allowed `--claim` path appended mechanical evidence
`lean-RV_CUT_CORE-1c1af0ff6ea5`, verdict `supports`, bound to existing claim
hash `f9efc86839d02bf6aaae0f64689736a61dd28749d808f624445d62ad2f06aee7`.
No judgement, new context, rewritten claim, or manual ledger update was made.
The tool itself explicitly leaves statement-fidelity verification unclaimed.

## Official checks after the real ledger change

Both official checks were executed once after that material mechanical
update, using the explicit **live-update** interpreter and active project
root. `replay/official_checks.json` preserves commands, stdout, stderr,
individual exit codes and the ledger digest at check time:

1. `math_state check --project-root <active root>`: exit **0**,
   `{"ok": true, "issues": []}`.
2. `proof_graph_check check --project-root <active root>`: exit **2**,
   `no proof graph at families/012/argus-review/PROOF_GRAPH.json`.

The graph file is absent and outside this task's authorized writable paths.
It was not created, replaced by the old graph, or bypassed. This is an
unresolved campaign-check blocker, not a failure of the deterministic Lean
proof. Unchanged official checks were not repeated.

## Boundary of the conclusion

Compilation supports precisely the formal source and its hypotheses, while
the statement-fidelity assessment supports the deterministic interpretation
above. Neither the Lean replay nor the finite regressions/nonvacuity checks
certify the printed universal inequality in the old report. In particular,
the lead has identified that displayed equation (3) multiplies the deletion
and exceptional terms whereas the ledger/prose and the nonvacuity check use
separate additive terms. Reconciliation of that probability claim and its
asymptotic specialization belongs to the lead's other units.

There is no remaining replay blocker for this deterministic core. The absent
campaign proof graph, the unformalized surrounding mathematics, and the
Host-invoked independent Reviewer must not be hidden by a successful local
compiler outcome.
