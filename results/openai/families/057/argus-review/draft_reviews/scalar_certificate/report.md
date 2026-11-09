# Scalar certificate: substantive old-draft assessment

## Status and scope

- Unit: `scalar_certificate`; assessment completed at `research_target_level=exploratory`.
- This report is an assessment, not an acceptance decision. `final_acceptance=native_independent_reviewer_pending`.
- The review itself has `novelty_status=not_applicable`. None of the old scalar assertions is credited with unverified novelty.
- Old source root: `families/057/first-pass/spectral_weighted_inverse`.
- Current project root: `campaigns/9200057`.

The six declarations in the latest `Main.lean` are correct universal algebraic implications. Their statement-fidelity document accurately distinguishes them from their proposed analytic application. A fresh, hash-bound compilation and axiom audit succeeded on unchanged review-owned copies. The old version-1 source did **not** compile: its normalization proof supplied an inequality of type `1 ≤ energy * lift` where the application required `1 ^ 2 ≤ energy * lift`. This is a superseded elaboration failure, not a counterexample to the mathematical inequality.

Neither the old certificate nor the fresh replay proves the review complete, supplies differential domains, or certifies the surrounding geometry.

## 1. Source identities and historical reconciliation

The old ledger contains the same natural-language scalar assertion at `C_SWI_ALG@1` and `@2`, but different formal sources:

| Record | Claim content hash | Formal-source SHA-256 | Assessment |
|---|---|---|---|
| `C_SWI_ALG@1` | `8d702f1936392b45c05a627eb2f56776cb16f96cd163c99e0160e8444bdeea23` | `5b1b47330567d2b24976f86c7d897dc170041fbe278aa403377c07a4eaf61078` | Failed elaboration; superseded |
| `C_SWI_ALG@2` | `5c8d70ee76cf9d335caa9bf623c93321865d68154f574db3265fe6acdca18b9f` | `eac2ed81cfb7b2d004412f8cf2e24b344166c4be575c0e5c1014307c510fd934` | Latest source; archived and freshly replayed |

Both versions contain all six declarations, including the finite-sum theorem. The refusal printed in the first run lists five declaration names; that diagnostic is not evidence that the sixth declaration was absent.

The **entire** formal-source difference is retained in `version_comparison.json`:

1. In `normalized_comparison`, the argument `hcauchy` became `(by simpa using hcauchy)`.
2. The unreachable `<;> ring` after `field_simp` in `inverse_squared_bound` was removed.

For normalization, the caller specializes `H=1`. The outer `simpa using` simplifies the resulting conclusion, including `1 ^ 2` and `a * 1`. The Bochner argument already used `(by simpa using hbochner)` in version 1 to match `energy + a * 1`; that was **not** a new version-2 repair. The actual missing conversion was the Cauchy hypothesis `1 ≤ energy * lift` to `1 ^ 2 ≤ energy * lift`. No theorem statement or sign hypothesis changed. Removing the trailing `ring` only removed the two unused/unreachable-tactic warnings.

The retained old records have distinct roles:

- `lean_submission.json` is a receipt for task `swi-algebra-lean-1`, not evidence of success.
- `lean_run.json` records `status=type_error`, compiler exit 1, the normalization diagnostic, and no axiom-audit run. It also records refusal to attach evidence because the then-current fidelity document named none of the required declarations. Its fidelity SHA-256 is `a18458e7885d94e36dad441e715095a13fd9378465c3abc6c6d09a6c9e25472b`; that document is not the latest fidelity.
- `lean_run_fixed.json` records compiler exit 0, audit exit 0, no proof holes, and mechanical evidence on **version 2's content hash**.
- The old `lean_check.json`, the `lean_check` embedded in `certificates/C_SWI_ALG-c5aac35df9f2e6ee.json`, and the successful portion of `lean_run_fixed.json` agree. Contrary to any inference from its generic filename, the retained `compile.log` is also the **successful latest** log, not the failed version-1 diagnostic.
- The archive embeds exactly the latest source and fidelity text. The latest fidelity SHA-256 is `a80c261f7cbdf047938f4f8988326cf7859231b4c5e7fc570e0e0d0e6972d48d`.

The old ledger's Engineer and Reviewer support judgements refer to the version-2 hash and archive. They do not retroactively certify version 1, and are not adopted as current independent acceptance.

## 2. All six declarations: exact statements and decisive arguments

In the first five declarations all numerical variables are real. Write `E` for the variable named `energy` and `L` for the variable named `lift`.

### 2.1 `WeightedInverse.squared_comparison`

For arbitrary real `δ,B,a,H,N,E,L`, assume

\[
\delta>0,\quad B\ge0,\quad E\ge0,\qquad
H^2\le EL,\quad \delta L\le BN,\quad \delta N\le E+aH.
\]

Then

\[
\delta^2H^2\le BE(E+aH).
\]

The proof is precisely

\[
\delta^2H^2\le\delta^2EL
=(\delta E)(\delta L)
\le(\delta E)BN
=(BE)(\delta N)
\le BE(E+aH).
\]

The inequality multipliers are nonnegative by the stated hypotheses. **No** sign assumption on `a,H,N,L` is part of this theorem. In particular this is a scalar implication, not a theorem asserting that these numbers arise from norms.

Attribution: elementary scalar step in the old Argus verification of the compact manuscript's weighted-inverse argument. Verdict: supported in exactly this scope; novelty not claimed; no unresolved scalar obligation identified.

### 2.2 `WeightedInverse.normalized_comparison`

For real `δ,B,a,N,E,L`, assume `δ>0`, `B,E≥0` and

\[
1\le EL,\qquad \delta L\le BN,\qquad \delta N\le E+a.
\]

Then `δ² ≤ BE(E+a)`. This is the preceding implication with `H=1`, with the explicit simplifications described above. It does not construct an analytic normalization. If a form has weighted squared norm `H>0`, normalizing the form and its primitive divides `N,E,L` by `H`; the resulting energy is the Rayleigh quotient `E/H`. This additional interpretation is correct, but external to the declaration.

Attribution: old Argus specialization of the preceding scalar step. Verdict: supported for version 2; the version-1 proof term was ill-typed; novelty not claimed.

### 2.3 `WeightedInverse.quadratic_gap_lower_bound`

For real `μ,r,a`, assume

\[
\mu\ge0,\quad r>0,\quad a\ge0,\qquad r(r+a)\le\mu(\mu+a).
\]

Then `r≤μ`. If `μ<r`, the positive product

\[
(r-\mu)(r+\mu+a)
=r(r+a)-\mu(\mu+a)
\]

contradicts the comparison. The positivity of `r` and nonnegativity of `μ,a` supply the second factor's sign.

Attribution: elementary quadratic monotonicity used to unpack the manuscript comparison. Verdict: supported; novelty not claimed. Lean does **not** define or verify the square-root expression for `r`.

### 2.4 `WeightedInverse.inverse_squared_bound`

For real `μ,s,a`, assume `μ,s>0`, `a≥0`, and `s²≤μ(μ+a)`. Then

\[
\frac1\mu\le\frac1s+\frac a{s^2}.
\]

If `μ≤s`, replace `μ²` on the right of the hypothesis by the larger `μs`. If `μ≥s`, use `s²≤sμ≤μ(s+a)`. In either case `s²≤μ(s+a)`, and division by `μs²>0` gives the conclusion. These are exactly the two source branches.

Attribution: elementary reciprocal estimate in the old quantitative verification. Verdict: supported; novelty not claimed. Exponentials, operator norms and taking square roots of norm bounds are not encoded here.

### 2.5 `WeightedInverse.completing_square`

For all real `μ,a`,

\[
(2\mu+a)^2=4\mu(\mu+a)+a^2.
\]

Expansion proves the identity without any sign assumptions. Lean uses `ring`. The matching Jacobian operation checks the same coefficient identity over `QQ`; it is not an independent proof of a spectral or analytic inequality.

Attribution: elementary completed-square identity. Verdict: supported; novelty not claimed.

### 2.6 `WeightedInverse.curvature_sum_lower_bound`

For any type with decidable equality, finite subset `J`, real-valued function `λ`, and real `c`, assume `-c≤λ(j)` for every `j∈J`. Then

\[
-|J|c\le\sum_{j\in J}\lambda(j).
\]

The sum of the constant `-c` is `-|J|c`; termwise summation proves the result. The empty set is included and **no sign condition on `c` is required**.

Attribution: elementary finite-sum component of the old curvature estimate. Verdict: supported; novelty not claimed. Identifying this sum with a curvature commutator, identifying `|J|=q`, and using `q≤m` with `c=C_0t≥0` to obtain `-qc≥-mc` remain analytic/application steps, not this formal theorem.

## 3. Fidelity and the precise analytic boundary

The intended substitution is

\[
H=\|\eta\|_h^2,\quad N=\|\eta\|_0^2,\quad
E=\|d_h^*\eta\|_h^2,\quad
L=\|T_0\eta\|_h^2,\quad B=e^b,\quad a=mC_0t.
\]

Here `η` must be a nonzero closed form in the appropriate weighted adjoint domain, and `T_0η` must be an admissible unweighted minimal primitive. The three scalar hypotheses must be supplied by:

1. the actual Hilbert-adjoint pairing and Cauchy--Schwarz;
2. the unweighted inverse bound and comparison of the primitive norms;
3. the complete-form-domain Bochner inequality.

The latest fidelity accurately states these dependencies and its exclusions. The formal theorem does not prove that `T_0` exists, that the pairing is legal, that weighted and unweighted differential domains agree, or that a Bochner identity extends to the complete form domain. It also does not identify weighted and unweighted **adjoint** domains. These are distinct analytic obligations assigned to other units.

Neither `Main.lean` nor the polynomial checker contains manifolds, orbifolds, Chern connections, differential operators, Hodge stars, spectral calculus, Serre duality, the weight function `h`, its curvature, or the scalar gaps on `U`. It cannot certify any downstream zero-spectrum or abelianity assertion. Conversely, these missing analytic formalizations do not invalidate the scalar implications: their hypotheses are explicit.

## 4. Local exterior-algebra check and exact replay of `verify.py`

The unledgered `local_exterior_commutator` check is a correctly chosen local representation, not a purported geometric counterexample. In the ordered basis

\[
(1,\ e_{\rm hol},\ e_{\rm anti},\ e_{\rm hol}\wedge e_{\rm anti}),
\]

the normalized two-form wedge operator `W` sends the empty state to the doubly occupied state and annihilates the other basis states. Its adjoint is the transpose in this orthonormal model. Therefore

\[
WW^*-W^*W=\operatorname{diag}(-1,0,0,1).
\]

The four diagonal entries equal `N_hol+N_anti-1`. On top holomorphic degree the two possible entries are 0 and 1, giving the contribution `λ_j` precisely when the antiholomorphic index is present. Summing coordinates yields the familiar algebraic sign in the prose argument. The finite coordinate calculation checks this sign; it does not prove local analytic commutation identities, diagonalization of a bundle curvature operator, or a global Bochner estimate.

Before execution I inspected the entire old `verify.py`. All file operations use `read_text`, `read_bytes`, or `is_file`; the only output-producing operation is its final `print`. `HERE` and `PROJECT` deliberately still point to campaign 9000057. The script was run **once**, with the required legacy interpreter, and only its generated stdout/stderr were redirected into this unit:

```text
$WORKSPACE/argus-latest/.venv/bin/python families/057/first-pass/spectral_weighted_inverse/verify.py
```

`verify_execution.json` records exit **0**, and `verify_stdout.json` reports the exact square, the local curvature sign and **six** rational examples passing. The output agrees with the old `verification_result.json`.

Its useful additional checks are provenance checks: it independently convolves the retained polynomial coefficients; reconstructs the four-state commutator; checks each rational example; compares source/fidelity hashes and archive text; and verifies that the **old** latest ledger claim and mechanical evidence match the archive. It does not recompile Lean, read and judge the argument of `proof.md` (it only checks that the proof file exists), or establish the truth of metadata such as novelty and campaign completion. Thus a passing replay is not a global analytic certificate.

## 5. Required current Jacobian use

The adapter interpreter was exactly `$WORKSPACE/argus-live-update/.venv/bin/python`. Discovery used the small query `sum of squares decomposition check`, limit 3. The first matching operation was `polynomial.sos.decomposition.check`; discovery's `NEEDS_MORE_TYPED_REQUIREMENTS` is routing information, not a mathematical conclusion.

I then inspected that **exact current operation contract** before copying the old payload. The contract accepts a sparse rational polynomial and up to 64 rational summands, with exact coefficient identity as the output method. The copied payload is on the axis `["mu","a"]`, with canonical rational coefficients:

\[
p=4\mu^2+4\mu a+a^2,\qquad q_1=2\mu+a.
\]

Exactly **one** matching bounded operation was executed, with timeout 90 seconds. Its typed response retained the exact request and returned `is_valid=true`, `method=EXACT_COEFFICIENT_IDENTITY`, and the matching computed sum. Server version was **0.14.0**, protocol **2025-11-25**, operation runtime **17 ms**. Discovery, inspection and execution adapter exits were all **0**, with empty stderr and no timeout/error.

Dedicated records are `jacobian_discovery.json`, `jacobian_contract.json`, `jacobian_payload.json`, `jacobian_output.json`, their status JSON files, and `jacobian_execution.json`. These establish `p=q_1²` over `QQ`, not a root bound, domain theorem, geometric realization or universal operator estimate. The parent's earlier broad query and the old unexecuted matrix candidate are not used as mathematical evidence.

## 6. Fresh immutable Lean replay

The old `Main.lean` and `statement_fidelity.md` were copied byte-for-byte into `replay/`. They were never edited, including during or after verification. `pre_verify_identity.json` and `post_verify_identity.json` bind both hashes to the old files and to the compiler result.

Before compiling, official legacy math-state commands registered:

- context `CTX_R057_SCALAR_REPLAY@1`, hash `73fb7a3350177a7fe801c7a27ab7d8787fda08a83976800e272a8fda37f0138d`;
- mathematical claim `R057_REPLAY_SCALAR@1`, hash `c3afbaf1cb51de8b07c82aacf989de8c278b701430070821b4bd7269ee545da2`.

The claim's `--formal-file` was the exact old absolute `Main.lean` path. Its natural statement describes the six scalar assertions, **not** assessment quality or coverage. The copied fidelity intentionally retains the historical name `C_SWI_ALG`: it is an unchanged reading of that same mathematical source, not a claim that the old certificate covers this review.

The required durable runner used task `r057-scalar-replay-20261107`, run `r057-scalar-replay-20261107-1794081754342926275`, direct mode, runner timeout 600 seconds. Its registry, receipt and reclaimed results are all under `replay/`; no other agent was launched. The actual verification command used:

```text
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify
  CURRENT_ROOT/research/draft_reviews/scalar_certificate/replay/Main.lean
  --statement-fidelity CURRENT_ROOT/research/draft_reviews/scalar_certificate/replay/statement_fidelity.md
  --claim R057_REPLAY_SCALAR --project-root CURRENT_ROOT
  --artifact-dir CURRENT_ROOT/research/draft_reviews/scalar_certificate/replay --timeout 480
```

Here `CURRENT_ROOT` is the full current project root stated above. No fallback interpreter, installation or scaffolding was needed. Actual command execution, not assumed workspace availability, found:

- Lean **4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`, release `x86_64-unknown-linux-gnu`;
- Lake **5.0.0-src+68218e8**;
- elan **4.2.3**, commit `b6cec7e10`;
- compiler working directory `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.

The compiler ran through `$WORKSPACE/.elan/bin/lake env lean`. Result: `status=success`, compiler exit **0**, empty compiler stdout/stderr, duration **15479 ms**; axiom-audit exit **0**, empty audit stdout/stderr; `proof_holes=[]`; no environment failure or kernel refusal. The durable run completed with exit **0**, elapsed **15.7 s**, and was reclaimed.

The audit command re-elaborated the unchanged source with the official `argus-latest/argus_skill/tools/lean_axiom_audit.lean`. That audit rejects newly introduced axiom declarations. Its exit 0 does **not** mean all imported foundations are axiom-free, nor is it a printed transitive axiom-dependency list. Lean's kernel, the imported Mathlib environment and its ordinary foundational axioms remain the formal trust boundary. The source introduces no custom axioms or proof holes.

Official verification attached mechanical evidence only to the dedicated mathematical replay claim:

```text
evidence: lean-R057_REPLAY_SCALAR-5f80d37027a7
artifact: research/draft_reviews/scalar_certificate/replay/certificates/R057_REPLAY_SCALAR-934d00ccff51ab22.json
```

Nothing was attached to `R057_SCALAR` or `R057_COVERAGE`. The official result itself keeps `statement_fidelity.verified_by=null`; compilation does not become an independent human fidelity or review-completeness judgement.

## 7. Obligations, limitations and ledger checks

There is no unresolved scalar calculation in the six latest declarations or retained exact local checks identified by this assessment. The specific remaining analytic obligations are to establish the three numerical hypotheses for the asserted differential domains, prove the product-gap and complete-domain Bochner estimates, and justify the spectral and duality interpretations. Those are not silently supplied by this certificate. The root substitution, exponential constants and abstract optimality are assessed separately in `../quantitative_refinements/report.md`.

No claim of geometric sharpness follows from degree-dependent abstract norms. Novelty of a proposed alternative presentation is not established by compilation, exact examples or the old bounded source search. The native independent Reviewer still must decide the fidelity, substantive assessments and family-wide coverage.

After this unit's context, claim and mechanical-evidence mutations, **both** required official checks were run against `campaigns/9200057`, not the batch root:

| Official command (interpreter `$WORKSPACE/argus-live-update/.venv/bin/python`) | Real exit | Result |
|---|---|---|
| `-m argus_skill.verticals.math.math_state check --project-root campaigns/9200057` | 0 | `ok=true`, `issues=[]` |
| `-m argus_skill.verticals.math.proof_graph_check check --project-root campaigns/9200057` | 0 | `proof graph valid: 8 node(s)` |

Raw outputs and command/root/exit records are `math_state_check*` and `proof_graph_check*` in this directory. The proof graph was not edited and no review node was marked accepted or `reviewer_confirmed`. Content-hash comparisons for all 23 listed old inputs are retained in `old_inputs_before.json` and `old_inputs_after.json`; replay/fidelity identity is separately retained under `replay/`.

## Evidence map

- Old mathematical source and interpretation: `Main.lean`, `statement_fidelity.md`, `proof.md` Sections 3--5 and 7--8.
- Old version/claim history: campaign 9000057 `research/MATH_STATE.json`, especially both `C_SWI_ALG` versions and their evidence subjects.
- Old compiler history: `lean_submission.json`, `lean_run.json`, `lean_run_fixed.json`, `lean_check.json`, `compile.log`, and `certificates/C_SWI_ALG-c5aac35df9f2e6ee.json`.
- Old exact evidence: `verify.py`, `exact_certificate.json`, `verification_result.json`, all four old `jacobian_*.json` files, and `source_status.json`.
- Current exact and formal evidence: `verify_execution.json`, `verify_stdout.json`, `version_comparison.json`, dedicated Jacobian records, `replay/lean_submission.json`, `replay/lean_reclaim.json`, `replay/lean_verify_result.json`, `replay/lean_check.json`, and the new replay certificate.
- Attribution boundary: the compact manuscript's `sp:weighted-inverse` and `sp:spectral-quadratic` are the analytic source of the comparison, not new consequences certified by this scalar module.
