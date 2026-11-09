# Finite-deletion draft review

## Scope, attribution, and assessment

**Engineer assessment only; no independent acceptance.** The finite counting
argument is supported under the explicit hypotheses below. The final Lean
source compiles afresh and proves the generic incidence and numerical
averaging lemmas, not an end-to-end formalization of the subset experiment.

The sources are the later Argus draft in
`9000020/research/adaptive_prime_audit/`: `report.md:31–100,424–501`,
both `Main.lean` and `statement_fidelity.md` copies, `verify.py`, four
compiler certificates, two compiler summaries/logs, and four run receipts.
The six ledger claim-versions below describe **one argument**, not six
independent contributions. Historical engineer/reviewer judgements and
“supports” labels are provenance, not current acceptance.

The reference manuscript is *Squarefree values of quartics and power-free
values of polynomials*, September 24, 2026, reference revision
`4eaee87548250b2682affda7d05d947c05554bae`. This review attributes the
finite-deletion formulation to the subsequent Argus analysis; it establishes
neither priority nor novelty. No review of the intervening application,
manuscript geometry, or the full paper is supplied here.

## Exact finite statement and decisive argument

Use the following explicit typing of `report.md:33–46`. Let \(P\) consist of
\(n\) distinct primes; \(B_0\) is a positive integer and \(D\) a nonnegative
integer. On the subset levels \(\ell-1,\ldots,\ell+T-1\), let
\(R(U)\in\mathbb Z\), \(0\le R(U)<B_0\), and \(m(U)\in\mathbb Z\setminus\{0\}\).
For every applicable deletion edge \(B=U\cup\{q\}\):

* \(R(B)\le R(U)\);
* \(R(B)=R(U)\) implies \(m(B)=m(U)\);
* at most \(D\) primes of \(P\) divide each \(m(U)\).

Let \(\ell,T>0\), \(\ell+T-1\le n\). Choose \(t\) uniformly from these \(T\)
sizes, then a uniform \(t\)-subset \(B\), then a uniform \(q\in B\).
Writing \(F(s)=\binom ns^{-1}\sum_{|U|=s}R(U)\), the claim is

\[
\mathbb E\,1_{\{q\mid m(B)\}}
\le {F(\ell-1)-F(\ell+T-1)\over T}
 +{D\over T}\sum_{t=\ell}^{\ell+T-1}{1\over n-t+1}
\le {B_0-1\over T}+{D\over n-\ell-T+2}.
\]

The expectation is also the expected fraction of primes in \(B\) dividing
\(m(B)\). There is no independence assumption on the adaptive \(m(B)\).

**Statement-typing qualification.** The scoped theorem header and
`CTX_ADAPTIVE@1` do not explicitly type \(B_0\). The last inequality uses an
integer cap: \(0\le R<B_0\) implies \(R\le B_0-1\) only for integral \(B_0\).
If a real cap were intended, use \(\lceil B_0\rceil-1\), or an explicit
record-span bound, instead. This is a necessary clarification of the
displayed statement, not an objection to the intended integer-record proof.
The Lean averaging theorem assumes the span directly.

Parent integration with the actual-kernels and cumulative-products units
confirms that the manuscript application uses
\(B_0=\prod_i(M_i+1)\), already a positive integer. The annotation is
therefore a clarification of the abstract statement, not an unresolved
integer-cap hypothesis in that application.

The proof in `report.md:49–88` checks as follows.

1. The bijection \((B,q)\leftrightarrow(B\setminus\{q\},q)=(U,q)\) gives
   \[
   t\binom nt=(n-t+1)\binom n{t-1}.
   \]
   All pairs have equal mass. Each \(U\) has exactly \(n-t+1\) extensions,
   so \(U\) is uniform and \(q\), conditional on \(U\), is uniform on
   \(P\setminus U\). **There is no conditioning on record stability.**
2. On each edge,
   \[
   1_{\{q\mid m(B)\}}\le
   1_{\{R(U)\ne R(B)\}}+1_{\{q\mid m(U)\}}
   \le R(U)-R(B)+1_{\{q\mid m(U)\}}.
   \]
   Equality of records supplies equality of integers on stable edges;
   otherwise the nonnegative integer increment is at least one.
3. Conditional on the *deleted set* \(U\), the old integer \(m(U)\) is
   fixed. Its bad extension labels number at most \(D\), giving
   \(D/(n-t+1)\). This does not make \(q\) independent of \(m(B)\).
   Averaging the rank increment gives exactly \(F(t-1)-F(t)\).
4. The sum over consecutive sizes telescopes. The endpoint difference is
   at most \(B_0-1\), and every denominator is at least
   \(n-\ell-T+2\ge1\). This includes \(\ell=1\), the full-pool endpoint,
   \(T=1\), and \(D=0\). A budget exceeding a complement size is harmless.

Primality and nonzero products are **not used in the edge inequality**.
Once a divisor budget is an explicit hypothesis, the counting proof also
does not need them; they are important when an application derives that
budget from heights. Distinct labels ensure that a bound on distinct pool
primes becomes a bound on incident edges. With repeated labels a separate
edge-multiplicity budget would be required. No construction or nonvanishing
of geometric minor products is established by this unit.

## Exact formal scope and fidelity

Both source copies are byte-identical (6,722 bytes), as are both fidelity
documents (3,715 bytes). Every main declaration was checked directly:

| Declaration in `Main.lean` | Actual statement and fidelity assessment |
|---|---|
| `bad`, line 7 | Rational indicator of integer divisibility, for arbitrary integer label and integer minor. Matches fidelity lines 7–18. |
| `bad_nonneg`, line 9 | \(0\le\mathrm{bad}(q,m)\), with no hypotheses. This helper is not separately named in the fidelity document; its scope is unproblematic. |
| `adaptive_edge_bound`, line 13 | Natural records `before,after`, arbitrary integers `old,new,q`; `after ≤ before` and `before = after → old = new` imply `bad q new ≤ (before:ℚ) - after + bad q old`. No primality, nonvanishing, or independence assumptions. Matches fidelity lines 8–18. |
| `regular_deletion_step`, line 27 | Arbitrary finite vertex types, decidable incidence, natural rank functions, integer minor functions/labels, natural row/column degrees `c,d`, and natural budget `D`. Edge monotonicity, equality-implies-equal-minor, and at most `D` old-divisor **edges per lower vertex** imply `sum(full edge indicators) ≤ c*sum(lowerRank) - d*sum(upperRank) + card(U)*D`. No positive-degree or nonempty-type assumption is needed for this unnormalized statement. Matches fidelity lines 20–39. |
| `telescope`, line 110 | For arbitrary rational \(F\) and natural \(T\), \(\sum_{k<T}(F(k)-F(k+1))=F(0)-F(T)\), including \(T=0\). Matches fidelity line 41. |
| `averaged_deletion_bound`, line 118 | Arbitrary rational sequences `F,A,denominator`, positive natural `T`, rational `B,D,c`, `c>0`, `D≥0`, `c≤denominator(k)` for `k<T`, span `F(0)-F(T)≤B`, and the numerical one-step inequalities imply `sum(A)/T ≤ B/T + D/c`. Positivity of each used denominator follows from these assumptions. Matches fidelity lines 42–47. |
| `finite_pool_average_bound`, line 145 | Natural `n,ell,T`, `ell,T>0`, `ell+T≤n+1`, rational `F,A,B,D`, `D≥0`, a supplied span bound and supplied steps with denominators `(n+1-ell-k:ℕ)` imply the coarse bound with `(n+2-ell-T:ℕ)`. The proof verifies that truncated subtraction is positive on the required range. `_positiveEll` remains a hypothesis, although unused. Matches fidelity lines 49–56 as a *conditional numerical specialization*. |

The prose's “integer ranks” are natural ranks in Lean; the intended
\(0\le R\) context allows that interpretation. The final theorem does not
define \(F\) to be mean ranks or \(A\) to be probabilities: they are arbitrary
rational sequences subject to the supplied inequalities.

The bridge in `report.md:90–100` is sound human mathematics but absent as a
composed Lean theorem. Set lower/upper vertices to the \((t-1)\)- and
\(t\)-subsets, and label an edge by its unique added prime. Then
\(c=n-t+1\), \(d=t\), and the positive edge count is
\(E=|L|c=|V|d\). Dividing `regular_deletion_step` by \(E\) gives
\(A_t\le F(t-1)-F(t)+D/c\).
For averaging instantiate
\(F_{\rm Lean}(k)=F_{\rm report}(\ell-1+k)\),
\(A_{\rm Lean}(k)=A_{\ell+k}\), and span \(B=B_0-1\).
Subset types, regularity, label uniqueness, uniform probabilities,
normalization, and this composition are not encoded in the source.
The sharper harmonic-sum inequality is human-supported; it is not the
conclusion of a named Lean theorem here. Fidelity lines 58–66 correctly
exclude the geometric identifications and whole density theorem; their
claim that the report supplies those identifications belongs to other units.

## Claim versions and historical compiler evidence

Exact ledger statements, context references, and hashes are in `verdict.json`.

| Claim-version | Disposition |
|---|---|
| `C_ADAPTIVE_SAMPLING@1` | Supported by the incidence count; no standalone Lean sampler theorem. |
| `C_ADAPTIVE_FINITE@1` | Supported by the human proof with the integer-cap clarification; not fully formalized as a concrete probability theorem. |
| `C_ADAPTIVE_FORMAL@1` | Textual target, empty formal statement, no version-specific compiler proof. The old `R_ADAPTIVE_FINITE` route still references **this version**, not v4. |
| `C_ADAPTIVE_FORMAL@2` | Embedded formal source exists, but its historical compilation failed. |
| `C_ADAPTIVE_FORMAL@3` | Proof revision, still a historical compiler failure. |
| `C_ADAPTIVE_FORMAL@4` | Final generic core compiles; not a new acceptance or a certificate for the surrounding application. |

All four formal natural-language statements are identical. Comparing their
actual stored Lean texts, not just filenames:

* v1 has no formal text. v2 introduces the source.
* **v2 → v3:** the final incidence step replaces incorrectly oriented
  `add_le_add_left totalOld _` with `linarith [totalOld]`. In averaging,
  an explicitly typed division bound plus `linarith` replaces a difficult
  composed elaboration; `linarith [span]` replaces the last addition step.
  The theorem statements and hypotheses do not change.
* **v3 → v4:** `field_simp; ring` becomes `field_simp <;> ring`, avoiding
  a tactic invocation after all goals are already solved. The binder
  `positiveEll` is renamed `_positiveEll`, without removing its assumption.
  No mathematical statement is weakened or changed.

| Historical certificate, relative to the old audit directory | Recorded outcome |
|---|---|
| `lean/certificates/C_ADAPTIVE_FORMAL-8f1d30eeb5a66521.json` | v2; evidence `lean-C_ADAPTIVE_FORMAL-08c157b26c7d`; `type_error`, exit 1, audit not run. Line 108 addition/type mismatch; lines 129 and 118 deterministic 200,000-heartbeat timeouts; line 144 unknown `averaged_deletion_bound` as a downstream failure. Not an unavailable-tool failure. |
| `lean/certificates/C_ADAPTIVE_FORMAL-c5e7aed21155ce18.json` | v3; evidence `lean-C_ADAPTIVE_FORMAL-9d0fee85caa1`; `type_error`, exit 1, audit not run. Line 143 “No goals to be solved”; unused `positiveEll` warning. |
| `lean/certificates/C_ADAPTIVE_FORMAL-4ccb75a212da5f7d.json` | v4; evidence `lean-C_ADAPTIVE_FORMAL-4a0433ecc8ec`; success, compiler/audit exits 0, `proof_holes=[]`, 16,533 ms. |
| `certificates/C_ADAPTIVE_FORMAL-4ccb75a212da5f7d.json` | v4 canonical; evidence `lean-C_ADAPTIVE_FORMAL-bb6b85017aaf`; success, compiler/audit exits 0, `proof_holes=[]`, 16,275 ms. This is the mechanical evidence referenced in the old ledger. |

All certificates use Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, and the same fidelity bytes.
Embedded sources match their respective versioned ledger formal statements
and their recorded SHA256. Source hashes are:

* v2: `7c27603245de4761929beb9a4d1f495f8994c64ce096b9a833eb6c0c81dc91f6`;
* v3: `86a75c0153c2b7145b043ed6d3f550fc97fffc32e70d7db1c91bd5f26a545390`;
* v4/current copies: `dd269527c6a526c0872c8a28d3cc22a29735a0a5c815d53881440c1454302f39`;
* fidelity: `32c6db980c0c5da33fa694e4249a4aabf8ef6a6a27183d616100661e831c53ff`.

The same-name final certificates are **not identical**: canonical 13,692
bytes versus nested 13,732. Their nine differing JSON fields are evidence
ID; compile/audit command source paths; source/fidelity paths; warning
stdout paths; duration; and the embedded source/fidelity relative paths.
Their claim subject, source text, fidelity text, digests, compiler version,
and successful outcomes agree. Each final certificate's `lean_check`
object exactly matches its adjacent `lean_check.json`; the corresponding
`compile.log` records the same commands, two harmless line-143 warnings,
and successful audit. The older failure certificates are not the current
adjacent summary. Details and exact diagnostics are retained in
`legacy_evidence_analysis.json`.

All four preserved `lean_run_receipt*.json` files have state `submitted`.
Their tasks are `adaptive-lean-core-1`, `adaptive-lean-core-2`,
`adaptive-lean-core-3` (360-second limits), and `adaptive-lean-canonical`
(240 seconds). These receipts record submission/run IDs and retrieval
commands only. They are operational history, not proof or completed-run
evidence; no old task was restarted or polled.

## Single Python replay and cross-unit regression results

Before execution, `verify.py` was inspected completely. Its only explicit
write is `exact_certificate.json` under `--write` (`verify.py:337–346`);
default execution reads old artifacts and prints. It was run **once**,
without `--write`, with bytecode disabled:

```text
$WORKSPACE/argus-latest/.venv/bin/python -B families/020/first-pass/adaptive_prime_audit/verify.py
```

Current cwd was campaign `9200020`. Exit was **0**, stderr empty, elapsed
0.309 seconds. Exact stdout:

```json
{"certificate": "verified", "monotone_records": 194, "optimized_cases": 4224, "actual_kernel_degrees": [1, 2, 3], "lean_exit_code": 0, "proof_holes": []}
```

The comparison is **parsed Python-object equality** against the historical
`exact_certificate.json`, not a byte comparison or a cryptographic signature:
object key order/whitespace do not matter; list order and values do.
`formal_check` verifies the preserved canonical summary, its paths, version,
exit/audit codes, and source/fidelity hashes. It does **not** invoke Lean or
check the immutable compiler certificate. The fresh compiler replay below
is separate. Likewise the Jacobian branch validates preserved adapter
data, not a new remote invocation.

The exact finite regression covers 194 monotone records valued in
\(\{0,1,2\}\) on \(n=1,2,3\), all allowed intervals and budgets \(0,\ldots,n\):
4,224 optimized cases and 28,716 edge evaluations across cases, not that
many distinct graph edges. Stable-edge connected components force a common
bad-prime set. For fixed records/intervals, the full-divisor objective is
linear with nonnegative weights in each component's indicators, so selecting
the largest \(D\) weights gives its actual maximum over all allowed maps.
The bound's right side is map-independent. This justifies the finite
maximization, **not** a proof for arbitrary pool size or arbitrary records.

The same successful invocation also yielded the following results for other
units; they need not rerun it:

| Kernel degree | Prime pool | Points | `B0` | States | Edges | Singleton full/deleted bad fraction |
|---|---|---:|---:|---:|---:|---|
| 1 | 7,11,13 | 7 | 16 | 8 | 12 | `1/1`, `0/1` |
| 2 | 7,11,13,17 | 13 | 49 | 16 | 32 | `1/1`, `0/1` |
| 3 | 7,11,13,17,19 | 21 | 121 | 32 | 80 | `1/1`, `0/1` |

These are actual rational evaluation-kernel checks with two stages and an
empty second block, not a manuscript refutation. Preserved Jacobian
cross-check: operation `prime_field.matrix.rank.compute`, field
\(\mathbb F_7\) rank **1**, rational rank **3**, server **0.14.0**, protocol
**2025-11-25**. The result labels `completed`, `timed_out=false`, and
`structured_error=null` are the verifier's reported historical summary,
not evidence of a current adapter call. No Jacobian operation was invoked
by this unit.

| `r,N,epsilon,E1,B0` | `gamma` | `xi` | `T` | `zeta` |
|---|---|---|---:|---|
| `1,2,1/10,3/2,49` | `1/320` | `1/1924` | 754209 | `1/482694400` |
| `3,7,1/100,5/1,500` | `1/19200` | `1/384012` | 4608144001 | `1/176952729676800` |
| `5,10,2/1,1/3,1234` | `1/240` | `1/340` | 16782401 | `1/8055552960` |

These three exact constant regressions also passed. Large `T` is calculated
by rational arithmetic, not enumerated. The complete result object verified
by the single invocation is preserved as `regression_results.json`, with
its provenance; stdout, stderr, command, timestamp, and actual status are
in `verify_replay.json` and `verify.*.log`.

## Fresh real Lean replay and trust boundary

The installed `lean_evidence` implementation was inspected rather than
invoked: its official verification path prepares/copies canonical artifacts,
writes locks/results/logs, and can synchronize other state. Those side
effects are inappropriate for these read-only old sources.

The existing workspace's `lean-toolchain` is `leanprover/lean4:v4.31.0`;
its lakefile and manifest pin Mathlib revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`. No install, build, lakefile
creation, Git operation, source copy, or output-object path was used.
The actual compiler command, cwd
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`, was:

```text
$WORKSPACE/.elan/bin/lake env lean families/020/first-pass/adaptive_prime_audit/Main.lean
```

It completed at `2026-11-07T16:33:50.280856+00:00`, exit **0**, in
**5.915 seconds**, stderr empty, with the same two line-143 unused/unreachable
`ring` warnings. Actual versions: Lean **4.31.0**, commit
`68218e876d2a38b1985b8590fff244a83c321783`; Lake
**5.0.0-src+68218e8**; elan **4.2.3**.

The installed, pre-existing audit was also run synchronously:

```text
$WORKSPACE/.elan/bin/lake env lean --run $WORKSPACE/argus-latest/argus_skill/tools/lean_axiom_audit.lean families/020/first-pass/adaptive_prime_audit/Main.lean
```

It exited **0** in **9.623 seconds**, both streams empty. The audit
elaborates the source at trust level zero and checks newly introduced
environment constants for axiom declarations. Inspection of `Main.lean`
finds no local `axiom`, `sorry`, `admit`, or `unsafe` declaration. **No
nonstandard axiom is declared by this source.** The audit is not a printed
transitive dependency/axiom inventory of imported Mathlib, and does not make
the proof “axiom-free”; Lean's kernel, imported library, and ordinary
classical foundations remain part of the trust boundary.

`lean_replay.json` and the named version/compiler/audit logs contain the
real commands, times, outputs, and exits. This is a compiler replay,
**not** a new official claim-bound certificate or ledger entry.

## Remaining boundaries

* Make the integer typing of \(B_0\) explicit if the theorem is republished.
* The human subset/probability-to-incidence-to-averaging bridge is checked
  above; an end-to-end Lean probability theorem would still require it to
  be encoded. This is a formalization boundary, not an unresolved counting
  argument.
* Establishing that concrete staged kernels, deterministic patches, and
  nonzero products satisfy the hypotheses belongs to other draft units.
  This unit supplies no whole-manuscript or density-theorem certification.
* The historical finite route's formal-v1 reference has not been silently
  upgraded to v4. Old sources, ledgers, graph, and other units were not
  edited. The task-provided missing-current-`PROOF_GRAPH.json` checker
  failure (exit 2) was not rerun or “fixed” by creating a graph.
* Novelty is **not established**. The draft's limited prior-art notes are
  contextual, not a verified priority claim or an imported theorem needed
  for this elementary finite proof.
* The native Host-invoked independent Reviewer must decide acceptance and
  family coverage. This report does neither.
