# Fixed-three-height: historical replay and binding reconciliation

## Assessment and scope

Unit: `fixed-three-height`. Reviewed claim: **`C_RS_HEIGHT`, historical
versions 1 and 2**, in the read-only project
`campaigns/9000039`.
This is an Engineer assessment, not native independent Reviewer acceptance.
The exact arithmetic assertion is supported by its argument and matching
formal statement. Historical certificate support is for **v2**, not the v1
height obligation retained by the full route.

The strongest prior result in this review is already **`dw < 1/3` with
mixed-order maximum-rank transfer**. Rechecking this existing fixed-three
argument is replay/reconciliation, not an improvement beyond that result.
The old report compared itself with the staged manuscript's `dw < 1/16`;
that historical comparison is not a new contribution of this review.
Optimality, literature priority and publishable novelty are not established.

Source attribution is to the existing Argus reshaping audit, specifically
`research/reshaping_audit/report.md`, lines 182–211, and its
`Main.lean` in namespace `ReshapingAudit`. This bounded assessment does not
reaudit the manuscript, companion papers or other draft units.

## Exact claim and versions

The natural statement is identical in historical v1 and v2:

> For all real H,d,w>0 with d^2 H>=6 and dw<1/3, put W=dH, R=H/w,
> T=d^2H, a0=WT/(1+T). There exist integers i,p,q and real a,b,t such
> that i*q-3*p=1, a0<a<W, b=W-a>0, t=a/b>T, a=Wt/(1+t),
> b=W/(1+t), -3a<3b<i/d, and i/d+3a=R.

There are no rationality hypotheses. The inequality `dw < 1/3` is strict.
The explicit lower bound `d²H ≥ 6` is a hypothesis, not a conclusion of
the Lean height theorem. Both historical claim records list no external
mathematical assumptions.

Version 1 has empty formal text. Version 2 binds the entire 4,001-byte
four-theorem source, not merely a theorem name. Its context remains
`CTX_RESHAPE@cd4bd002951dbb28b4fb4249d6cac279c3caac6c25eab342b92c97f173cd8e80`.
Only `version`, `formal_statement` and `content_hash` differ between the
two records.

## Historical hashes, evidence and route: explicit reconciliation

The official latest `ClaimVersion.from_dict(...).content_hash` recomputation
matches both stored claim digests; `ContextVersion` also reproduces the
stored context digest. These are structured claim digests, not source-file
SHA-256 digests.

| Record | Exact content hash |
|---|---|
| `C_RS_HEIGHT` v1, no formal text | `bd56efdd4d3aa7463aa628d72c42bc6b6620f720afafff69a83ee441cbb2853b` |
| `C_RS_HEIGHT` v2, formal text bound | `a64cc0e3f8964f6a60314df66e4214b1a09ffbe02e889b601e33e3cb4d600ccc` |
| Mechanical evidence subject | `a64cc0e3f8964f6a60314df66e4214b1a09ffbe02e889b601e33e3cb4d600ccc` |
| Certificate `subject.content_hash` | `a64cc0e3f8964f6a60314df66e4214b1a09ffbe02e889b601e33e3cb4d600ccc` |
| Both historical judgement subjects | `a64cc0e3f8964f6a60314df66e4214b1a09ffbe02e889b601e33e3cb4d600ccc` |
| `R_RS_FULL` height obligation | `bd56efdd4d3aa7463aa628d72c42bc6b6620f720afafff69a83ee441cbb2853b` |

Thus there is **no v2/evidence/certificate subject mismatch**. The mismatch
is the full route's still-pinned **v1** obligation versus the formalized
**v2** claim to which the evidence applies. Identical natural text does not
make these exact-version references interchangeable. No supporting evidence
in the historical ledger has the v1 height subject. A v2 certificate therefore
does not mechanically discharge that v1 route obligation. Nothing historical
was rewritten or rebound here.

The certificate is
`research/reshaping_audit/lean/certificates/C_RS_HEIGHT-c62d2854794e7272.json`
(relative to 9000039), with file SHA-256
`2cc828bd202f8ab1d385359630746f8c498b22a36c3c5bf45f13c69221937e20`.
The filename fragment `c62d2854794e7272` is not its claim content hash or
the file's SHA-256. Its mechanical evidence ID is
`lean-C_RS_HEIGHT-50cecdd49d11`.

Judgements `judgement-C_RS_HEIGHT-4acc13321105`
(`engineer:reshaping-audit`) and `judgement-C_RS_HEIGHT-c391cb094d51`
(`reviewer:reshaping-audit`) reference that same matching v2 certificate.
They are opinion records pointing at a compiler artifact, not two more
proofs or a separately preserved fidelity analysis. Their producer labels
do not establish native independent acceptance of this current review.
The read-only official `math_state show --claim C_RS_HEIGHT` reports v2
`closed_kernel`, no stale evidence and no standing assumptions, **with**
the explicit natural/formal-fidelity caveat. This is a local claim status,
not closure of the full route. The historical proof-graph height node is
still `open`, with `reviewer_confirmed: false`.

### Source and payload identity

* Original `Main.lean`, duplicate `lean/Main.lean`, the v2 formal text,
  certificate `lean_source.text`, the new canonical `lean/Main.lean` and
  archived replay input `source_attachments/Main.lean.txt` have source SHA-256
  `d547ec7484dd54fcbfdfcb441a2a6001008cc12155f763a987e12d7ce15d73f6`.
* Original `statement_fidelity.md`, duplicate
  `lean/statement_fidelity.md`, certificate fidelity text and new faithful
  copies have SHA-256
  `8132df0d1e434b5b0876675ae0509d7c66da09e0a5c1eb4074e0dd6ed4b83bf0`.
  The copied fidelity document intentionally retains the historical
  `C_RS_HEIGHT` identifier; the new report explains the `C_REVIEW_HEIGHT`
  rebinding rather than silently editing its meaning.
* Historical `lean_check.json` is exactly the certificate's `lean_check`
  object. `lean_verification.json` is that same verifier result plus the
  matching `kernel` recording result; it is not another proof. Its
  `statement_fidelity.verified_by` is `null`.
* `compile.log` agrees with those recorded commands, successful exit codes
  and warnings. These historical outputs report Lean 4.31.0, Lake
  5.0.0-src+68218e8, Mathlib workspace
  `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`, no proof
  holes, and an axiom-audit exit code of zero with empty audit output.
  That empty output is not an enumeration of foundational axioms.
  Historical references to `argus-live-update` are read-only provenance,
  not tools used for this replay.
* The relevant manifest-backed historical files match the preserved
  2026-11-06T10:20Z archive members and manifest digests, checked without
  extracting or modifying the archive. Detailed file digests are in
  `historical_reconciliation.json`. The historical `compile.log` and
  `lean_verification.json` are additional inventory inputs, not
  manifest-backed entries.

The duplicate source and fidelity copies are **one argument**, not separate
results.

## Four exact declarations and substantive fidelity assessment

All declarations are in `ReshapingAudit`, import `Mathlib`, and introduce
no source-level `axiom`, `sorry` or `admit`.

### 1. `primitive_three_in_interval`

```lean
theorem primitive_three_in_interval (L U : ℝ) (h : 2 < U - L) :
    ∃ i p q : ℤ, L < (i : ℝ) ∧ (i : ℝ) < U ∧ i * q - 3 * p = 1
```

For arbitrary real endpoints, let `n = floor L + 1`. Then
`L < n ≤ L+1`, and the length hypothesis gives both `n < U` and
`n+1 < U`. If `n` is divisible by three, choose `i=n+1`,
`p=n/3`, `q=1`. For residues one and two choose respectively
`(i,p,q)=(n,n/3,1)` and `(n,-(n/3)-1,-1)`.
Integer Euclidean division proves the determinant equation in every case,
including negative endpoints. This certifies primitivity of `(i,3)` by an
explicit determinant-one completion `((i,3),(p,q))`. It does not construct
an action on a polygon or a lattice family.

### 2. `fixed_three_height`

```lean
theorem fixed_three_height (H d w : ℝ)
    (hH : 0 < H) (hd : 0 < d) (hw : 0 < w)
    (hT : 6 ≤ d ^ 2 * H) (hsmall : d * w < 1 / 3) :
    let W := d * H
    let R := H / w
    let T := d * W
    let a0 := W * T / (1 + T)
    ∃ (i p q : ℤ) (a b t : ℝ),
      i * q - 3 * p = 1 ∧
      a0 < a ∧ a < W ∧ b = W - a ∧ 0 < b ∧
      t = a / b ∧ T < t ∧
      a = W * t / (1 + t) ∧ b = W / (1 + t) ∧
      -3 * a < 3 * b ∧ 3 * b < (i : ℝ) / d ∧
      (i : ℝ) / d + 3 * a = R
```

Here `T=d*W=d²H` is an algebraic identity. Positivity and `dw<1/3`
give `R>3W`. For
`L=d(R-3W)` and `U=d(R-3a0)`,

`U-L = 3d(W-a0) = 3T/(1+T) > 2`,

since `T≥6`. Apply the preceding integer theorem and set
`a=(R-i/d)/3`, `b=W-a`, `t=a/b`.
The strict interval inequalities yield `a0<a<W`, hence `b>0`.
Multiplying `a0<a` by `1+T>0` gives `WT<a(1+T)`, equivalently
`T(W-a)<a`, so `t>T`. The two rational identities follow from
`b*t=a` and `a+b=W`. Finally,

* `3b-(-3a)=3W>0`;
* `i/d-3b=R-3W>0`;
* `i/d+3a=R`.

This checks every conjunct of the natural assertion, not only the range.
Under `det((i,3),(x,y))=iy-3x`, the three vertices
`(-b,0)`, `(a,0)`, `(0,1/d)` have heights `3b`, `-3a`, `i/d`;
their sorted heights and range are exactly the stated expressions.
That interpretation is a mathematical reading of the real identities;
Lean defines no vertices, determinant map or convex hull in this file.

For the original intercept hypotheses `A,B>0`,
`H=AB`, `d=max(3/A,2/B)`, the prose implication
`dA≥3`, `dB≥2`, hence `d²H≥6`, is valid.
Its use of positivity is essential. This substitution from intercepts is
**not** a theorem declaration in the formal source.

### 3. `tent_slice_length`

```lean
theorem tent_slice_length (q0 q1 q2 w h : ℝ) :
    (q2 + (q1 - q2) * (h / w)) - (q0 + (q1 - q0) * (h / w)) =
      (q2 - q0) * (1 - h / w)
```

This has no hypotheses, no ordering of the `q`'s and no nonzero-width
condition. Expanding and cancelling the `q1*h/w` terms proves the identity
by ring arithmetic. It remains an algebraic identity under Lean's total
division at `w=0`. Calling the two expressions actual slice endpoints
requires separate geometry and positive-width hypotheses.

### 4. `compressed_tent_inside_simplex`

```lean
theorem compressed_tent_inside_simplex (R w h z : ℝ)
    (hR : 0 < R) (hw : 0 < w) (hh : 0 ≤ h) (hhw : h ≤ w)
    (hz : 0 ≤ z) (hbound : z ≤ R * (1 - h / w)) :
    0 ≤ h ∧ 0 ≤ z ∧ h / w + z / R ≤ 1
```

Divide the assumed upper bound by positive `R`, then add `h/w`.
The first two conjuncts are the hypotheses `hh` and `hz`. Although the
declared theorem includes `w>0` and `h≤w`, its proof does not need these
two hypotheses once `hbound` is assumed. The unused-variable warnings
therefore do not indicate missing proof obligations.
This proves an implication between real inequalities, not construction of
compressed lattice rows, a simplex object or a polygon containment theorem.

The fidelity document accurately describes these four declarations and
their limits. Its assertions that surrounding material is proved in the
old report remain claims for other review units, not findings of this unit.

## Fresh execution and active ledger

Only the natural-height claim `C_REVIEW_HEIGHT` was revised. The faithful
local `Main.lean` was bound by the official latest `math_state revise-claim`,
creating v2 with content hash
`3c93ff123e1d92e6b12b97d672bd77a64f5e5f6ec419b5e84f581c8f368366c5`.
Its natural statement is unchanged from historical v2, its context is
`CTX_OLD_REVIEW`, and its external-assumption list is empty.

The first official verification submission failed before compilation because
the latest verifier passed an omitted timeout as `None` to `float`.
The exact submitted receipt is `verification_submission.json`; its
error status and traceback are in `verification_status.json`.
No tool source was patched. The retry uses the same official command plus
`--timeout 600`, under durable direct-runner timeout 900 seconds.
The exact retry receipt is `verification_retry_submission.json`.
The originals and both canonical local source/fidelity pairs remained
unchanged during verification. No lakefile was created.

The retry **completed successfully**: runner state `done`, exit 0,
29.9 seconds; compiler and official axiom audit each exited 0,
`proof_holes=[]`, no environment failure. The recorded compiler duration
is 29,691 ms. Its automatically discovered workspace is
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`; there was no
new project configuration or dependency installation. The actual command was:

```text
$WORKSPACE/.elan/bin/lake env lean families/039/argus-review/draft_reviews/fixed-three-height/lean/Main.lean
```

The measured toolchain is:

* Lean `4.31.0`, `x86_64-unknown-linux-gnu`, Release,
  commit `68218e876d2a38b1985b8590fff244a83c321783`;
* Lake `5.0.0-src+68218e8` (Lean `4.31.0`);
* elan `4.2.3 (b6cec7e10 2026-06-08)`.

Mathlib is identified here by the actual discovered prebuilt workspace and
successful imports; its separate source-tree commit integrity was not audited.

The only compiler warnings are the original unnecessary `simpa` at line 9
and unused `hw`, `hhw` at line 117. The complete official result is
`lean_verification.json`, with canonical `lean/lean_check.json` and
`lean/compile.log`; the completed durable receipt is
`verification_retry_status.json`.

The new official **mechanical/supports** record is
`lean-C_REVIEW_HEIGHT-9004a208c2ad`. Its certificate is:

`research/draft_reviews/fixed-three-height/lean/certificates/C_REVIEW_HEIGHT-48cc9275faca4908.json`

with file SHA-256
`8442c1c4c5e42cf8ecd282f765b18cc9eba80910565e4481d5f55e6a145367b9`.
The certificate subject is exactly current `C_REVIEW_HEIGHT` v2 hash
`3c93ff123e1d92e6b12b97d672bd77a64f5e5f6ec419b5e84f581c8f368366c5`.
Its source, fidelity and compiler payloads match the bound claim and local
artifacts. The active official height status is `closed_kernel`, with no
standing assumptions or stale evidence, but the same compiler fidelity
caveat and `verified_by: null`. This report supplies the Engineer's
mathematical fidelity analysis; no new Reviewer-labelled judgement or
independence claim was added to the ledger.

### Actual foundational axioms, not an axiom-free claim

The official audit checks for proof holes but has empty successful output.
To enumerate foundational dependencies, the separate local
`AxiomAudit.lean` (now `source_attachments/AxiomAudit.lean.txt`) contains
the exact original source followed only by four
`#print axioms` commands. It was genuinely recompiled through the same
discovered Lake/Mathlib workspace, under the durable direct runner, exiting
0 in 12.6 seconds. Each of the four declarations printed exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are Lean's standard foundational axioms, not additional imported
manuscript results. No `sorryAx` or draft-specific axiom appears.
The source is **not axiom-free**, despite declaring no new axioms.
The exact output is retained in `axiom_print.log`, with parsed
per-declaration dependencies in `axiom_dependencies.json`;
`axiom_submission.json` and `axiom_status.json` preserve submission and
completion. This probe is not a fifth mathematical theorem or a second
result. It never modified either canonical source/fidelity pair.

### Manager hold: reversible source-attachment reconciliation

The Manager hold at `1794075985.1414824` named the unit-root
`Main.lean` and `AxiomAudit.lean`, not the certified `lean/Main.lean`.
The exact `stage_completion_issues("review", project_root)` gate was
replayed before this change and returned precisely those two missing-result
issues (exit 1).

Byte comparison establishes that the unit-root `Main.lean` is identical to
the certified source. `AxiomAudit.lean` is exactly that same source, followed
by one blank line and these four commands, with no additional proof:

```text
#print axioms ReshapingAudit.primitive_three_in_interval
#print axioms ReshapingAudit.fixed_three_height
#print axioms ReshapingAudit.tent_slice_length
#print axioms ReshapingAudit.compressed_tent_inside_simplex
```

Its completed real axiom-run status has exit 0, and its recorded stdout
matches `axiom_print.log` byte-for-byte. Neither file contains substantive
unmatched mathematics. They are retained as non-active source attachments,
not removed evidence or separately certified results.

All paths in the following table are relative to
`research/draft_reviews/fixed-three-height/`:

| Original path | Exact-byte attachment | Bytes | SHA-256 |
|---|---|---:|---|
| `Main.lean` | `source_attachments/Main.lean.txt` | 4001 | `d547ec7484dd54fcbfdfcb441a2a6001008cc12155f763a987e12d7ce15d73f6` |
| `AxiomAudit.lean` | `source_attachments/AxiomAudit.lean.txt` | 4214 | `cb253b6030d9f24d3742a00917c9ef30b2abf3687a10686a327bba4c383ba1c2` |

Renaming either attachment back to its original path recovers the original
bytes; restoring it as active Lean source would again require its own
matching compiler evidence. Historical commands, receipts and logs retain
their original source paths intentionally. The canonical `lean/Main.lean`,
its fidelity document, compiler result, certificate and logs are unchanged;
the active claim still binds that exact certified source. No compiler
verdict, claim, ledger, proof graph, mathematical scope or acceptance flag
was rewritten. No new compilation is claimed for the attachments.

After archival, the same
`argus_skill.verticals.math.stages.stage_completion_issues("review", root)`
returned `issues=[]` (exit 0), rather than either missing-result issue.
The interpreter was `$WORKSPACE/argus-latest/.venv/bin/python`
and the exact root for this gate and both official checks was
`campaigns/9200039`:

| Check after source archival | Exit status | Result |
|---|---:|---|
| Exact review-stage completion gate | 0 | No issues |
| `-m argus_skill.verticals.math.math_state check --project-root <root>` | 0 | `ok:true, issues:[]` |
| `-m argus_skill.verticals.math.proof_graph_check check --project-root <root>` | 0 | `proof graph valid: 12 node(s)` |
| Exact-byte attachment and evidence integrity comparison | 0 | Both attachments recoverable; canonical evidence, active ledger and graph unchanged |

The integrity comparison also checked the current formal claim against the
certificate's subject and source text, the original compiler payload, and
the updated index references. The only remaining active Lean source in this
unit is `lean/Main.lean`. These results resolve the source-path hold;
they do not manufacture independent Reviewer acceptance.

There is **no durable work remaining**. Both the successful official replay
and supplementary axiom probe are complete. Durable task registries and logs
are under this unit's `.argus_subagents/`; run each exact receipt's
`check_with` from this unit directory. The first failed task's own
completed registry/log/run-lock files were relocated here from the runner's default
project-root registry without altering their contents.

The initial full-review route `R_REVIEW_UNITS` referenced height
v1 hash
`8028194f3fad07f5bc5036412bf4efe543cc0b19bf5209d430624375dea51128`,
not the newly source-bound v2. The parent supersedes that route with
`R_REVIEW_UNITS_CURRENT`, retaining the exact natural theorem and binding
the source-bound v2. This is provenance reconciliation, not a failed
mathematical argument. Passing structural checks alone would not have
made the initial route reference current.

After binding, both official checks ran against
`campaigns/9200039`:
`math_state check` exited 0 with `ok:true, issues:[]`;
`proof_graph_check check` exited 0 with `proof graph valid: 12 node(s)`.
Both checks were repeated after the failed replay with the same results.
These measured results validate ledger/graph structure, not the truth
or independence of the mathematics.

After the official verifier wrote mechanical evidence, **both checks again
passed against the same 9200039 root**:
`math_state check` exited 0, `ok:true, issues:[]`;
`proof_graph_check check` exited 0, `proof graph valid: 12 node(s)`.
The active graph height node remains `open`,
`reviewer_confirmed:false`; it was not promoted to proved. No graph file
was written by this worker.

### Files written and permitted ledger changes

All unit deliverables and task-specific new execution artifacts are under
`research/draft_reviews/fixed-three-height/`: this `report.md`, `verdict.json`,
faithful `statement_fidelity.md`, official `lean/` source, artifacts
and certificate, the two non-active `source_attachments/*.lean.txt`
attachments and axiom outputs,
exact durable receipts/logs, and reconciliation/check/integrity records.
No copy is counted as another result. The only mathematical ledger changes
by this worker are the source-bound `C_REVIEW_HEIGHT` v2 and its official
mechanical evidence. Historical artifacts/snapshots, other active claims and
assumptions and proof graph were not edited; no git was used. The subsequent
attachment reconciliation updates only this assessment and directly affected
index/summary references; it changes no mathematical ledger entry.

## Unresolved obligations and bounded stopping point

There is no identified mathematical gap in the exact fixed-three-height
assertion under its stated hypotheses. There are, however, explicit limits:

1. Historical v2 mechanical support does not discharge the historical
   full route's v1 hash binding. No historical route or ledger was changed.
2. The intercept-to-`d²H≥6` implication and the vertex interpretation are
   prose checks, not formal geometry in these four declarations.
3. This source formalizes **no nodal formal-series bound, full reshaping,
   geometry, all-degree gradedness, lattice-row compression, specialization
   or mixed-order rank transfer, label restoration, maximality or priority**.
   Those claims require their own substantive reviews; the local certificate
   is not evidence that an entire paper is formalized.
4. The parent records the active exact-version rebinding in
   `R_REVIEW_UNITS_CURRENT`; no historical reference is changed.
   No other active claim or assumption, graph status or
   `reviewer_confirmed` flag was changed by this worker.
5. Native Host-invoked independent Reviewer acceptance is still required.

`reviewer_acceptance = "pending_native_independent_review"`.
