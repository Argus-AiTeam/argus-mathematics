# Formal-core: Engineer assessment of the existing draft

**Unit:** `formal-core`. **Assessor:** `engineer:formal-core-reader`.
**Independent acceptance:** `pending_native_Host_Reviewer`.

This is a reproduction and statement-fidelity assessment of one inherited
algebraic proof bundle, not an independent Reviewer decision, a new mathematical
result, or completion of the six-unit review.

## 1. Claim, inputs, and version binding

The current claim `R_FORMAL`, in context `REVIEW018`, says:

> The declarations of the inherited Main.lean establish their universal matrix,
> normal-subgroup, kernel-intersection, and conditional invariant-function
> assertions under the explicitly encoded hypotheses; this does not assert any
> global-field or manuscript theorem.

The read-only source is
`../9000018/research/exact_transitivity/Main.lean`, namespace
`ExactTransitivity`, interpreted with that directory's `statement_fidelity.md`.
I also read the historical certificate
`certificates/C_ET_FORMAL_CORE-2ec206e59ea6c18d.json`, `compile.log`,
`formal_claim_state.json`, `lean_check.json`, `lean_evidence.json`,
`lean_certification_literal_receipt.json`, `lean_certification_receipt.json`,
all three `lean_runner_receipt*.json`, `math_state_check.json`, and
`proof_graph_check.txt`. The relevant records in the old mathematical ledger
and the five exact old runner records/logs supply version and failure history.
These are evidence for **one** result, not independent mathematical results.

The coverage index's existing comparison of all 31 inventory byte counts and
10 snapshot-manifest entries is not repeated or rebuilt. Neither a reference
tree nor the preserved snapshot was modified. Only the two required unchanged
inputs were copied; no old ledger or artifact collection was copied.

Historical `C_ET_FORMAL_CORE` versions 1 and 2 have exactly the same natural
assertion: the universal double-commutator formula, normal extraction and
nonidentity condition, normal-subgroup intersection membership, and conditional
additive amplification to constancy on nonzero pairs. Their formal texts differ:

| Record | Content hash | Actual binding |
|---|---|---|
| Version 1 | `eeeac62b756240708639d222a8405d3c643df2f30afcb301848022bf0121beb0` | Earlier proof text; not equal to preserved `Main.lean`. |
| Version 2 | `d9215a7414da2fddd1199a2802041aa2b1aff8638affecfe764b0be04c7aa243` | Exactly the preserved source and the certificate's subject. |

Version 2 supplies explicit nonzero hypotheses to denominator clearing, changes
some proof scripts, corrects the `AddSubgroup.closure_le Q` application and final
additive rearrangement, and adds `affineUnit_commutator` as a bridge to units.
The existing principal theorem statements were not replaced by stronger
unconditional existence statements. The certificate embeds exactly the
preserved source and fidelity text. Its source digest is
`25a948fa2e2eae22a08c2c943de232cd10b6a21773208e5a2440427aab71f96b`;
its fidelity digest is
`65492ac8abf4ec1b8ebb57cb2ddc702133fe83bc3aa0acb8d398b629a3c272c7`.
These are historical certificate fields, not a new inventory hash sweep.
The scoped comparison and proof-text diff are in
`replay/historical_evidence.json` and `replay/historical_formal_version.diff`.

The current `R_FORMAL` version 2 retains its narrow natural assertion and binds
the unchanged replay source, with content hash
`ea2b913293de5ad5af07c09692d8e581cf09f28ea376444314407ba952bda1bd`.
It does not inherit the old context or old judgments as current acceptance.

## 2. Exact declarations and mathematical reading

Here `mat a b c d = [[a,b],[c,d]]`, `U(x) = [[1,x],[0,1]]`,
`L(y) = [[1,0],[y,1]]`, and `Delta = a*d-b*c`.
The matrix section assumes **`[Field K]`**, hence commutative multiplication,
with no characteristic restriction. It is not a theorem about matrices over
an arbitrary noncommutative division ring.

### 2.1 Universal matrix algebra, not phase selection

* `M2`, `mat`, and `mat_mul` define two-by-two matrices and prove their ordinary
  multiplication formula.
* `upper`, `lower`, `diagonal`, and `inverse` are explicit matrix definitions.
  `diagonal x` means `diag(x,1)`, not `diag(x,x⁻¹)`.
  `mat_inverse` proves `mat a b c d * inverse a b c d = 1` when `Delta ≠ 0`.
  `unit_inverse_value` identifies the value of an actual unit's inverse with
  this displayed inverse when its entries and nonzero determinant are supplied.
* `phaseComm`, `phaseCommInv`, and `separator` define the words
  `D_x g D_x⁻¹ g⁻¹`, its inverse word, and their commutator for `x,y`.
  This interpretation uses `x,y,Delta ≠ 0`; the definitions themselves are
  total matrix expressions. `separator_lower_left` proves exactly

  ```text
  separator(a,b,c,d,x,y)[1,0]
    = b*c^2*d*(x-1)*(x-y)*(y-1)
        *(a*d*x*y-a*d*x-a*d*y+b*c)
      / (x^2*y^2*Delta^3).
  ```

  Its only displayed nonvanishing hypotheses are `x ≠ 0`, `y ≠ 0`,
  `Delta ≠ 0`. It does not assert that this entry is nonzero, that the word
  vanishes on another block, or that a norm-one phase avoiding roots exists.
* `triangular_phase_comm` proves
  `phaseComm a b 0 d x = U((x-1)*b/d)` for `a,d,x ≠ 0`.
  Neither `b ≠ 0` nor `x ≠ 1` is assumed, so the resulting shear may be the
  identity. No boost-word construction or group-membership assertion is here.
* `opposite_commutator` proves
  `(U(x)*L(y)*U(-x)*L(-y))[1,0] = x*y^2`, without nonzero assumptions.
  Nontriviality requires nonzero parameters separately.
* `four_shear_diagonal` proves
  `U(s)*L(t)*U(-s/u)*L(-t*u) = diag(u,u⁻¹)` when `u ≠ 0` and `u=1+s*t`.
  It does not establish that its factors belong to a manuscript's group.

These are universal identities, including in characteristic two. They are not
existence theorems for admissible global-field parameters.

### 2.2 Normal extraction: hypotheses are actual memberships

`affine l z = [[l,z],[0,l⁻¹]]` and `affineInv l z = [[l⁻¹,-z],[0,l]]`.
`affineUnit` proves the two inverse equations when `l ≠ 0`; `upperUnit`
is the actual matrix unit `U(x)`. `affine_commutator` and
`affineUnit_commutator` prove, respectively as matrices and as units,

```text
affine(l,z) * U(x) * affine(l,z)⁻¹ * U(x)⁻¹ = U((l^2-1)*x).
```

`normalizing_matrix`, under `c,u,Delta ≠ 0`, computes `h⁻¹*g⁻¹*h*g` as

```text
affine((u⁻¹)^2, (1-u^2)*(d-a*u^2)/(u^2*c)),
h = affine(u, ((1-u^2)*(a/c))/u).
```

Its diagonal is `(u⁻²,u²)`. The equivalent prose expression
`h=U((1-u²)*(a/c))*diag(u,u⁻¹)` has exactly the displayed upper-right entry.

`normal_extract` is more than an identity, but remains conditional. Its exact
inputs are subgroups `H,P ≤ (M2 K)ˣ`, and:

1. `hnormal : ∀ h ∈ H, ∀ p ∈ P, h*p*h⁻¹ ∈ P`;
2. an actual unit `p ∈ P`, with value `mat a b c d`;
3. `c ≠ 0`, `u ≠ 0`, `Delta ≠ 0`;
4. `affineUnit u (((1-u^2)*(a/c))/u) hu ∈ H`;
5. `upperUnit x ∈ H`.

It concludes `upperUnit (((u⁻¹)^4-1)*x) ∈ P`.
There is **no** assumption `P ≤ H`, no requirement `p ∈ H`, and no
Zariski/topological substitute for either membership in items 4–5.
`hnormal` is normalization by the specified `H`, not unqualified normality in
all matrix units.

The decisive proof is exact: put `q=h⁻¹*p⁻¹*h*p`. Conjugation closure and
`p ∈ P` give `q ∈ P`; the matrix computation identifies its affine form.
Then `q*(U(x)*q⁻¹*U(x)⁻¹) ∈ P`, again by `hnormal`, and the affine
commutator identity identifies the extracted shear. There is no density-to-
membership step.

### 2.3 Nonidentity is a separate assertion

`extracted_shear_nonidentity` assumes `u^4 ≠ 1` and `x ≠ 0` and concludes
`upperUnit (((u⁻¹)^4-1)*x) ≠ 1`. It compares the upper-right matrix entry
with zero and uses that a product of nonzero field elements is nonzero.
The standalone declaration does not assume `u ≠ 0`: Lean's inverse is
totalized with `0⁻¹=0`, and its formula is still valid at zero.
An application combined with `normal_extract` also has that theorem's `u ≠ 0`.

Thus membership alone is not nontrivial extraction: `normal_extract` allows
`x=0` or `u^4=1`. No declaration chooses an admissible `u` or `x`, or proves
that a phase/congruence subgroup supplies them.

### 2.4 Normal-kernel intersection: the actual generic lemma

`commutator_in_intersection` assumes an arbitrary `[Group G]`, two subgroups
`A,B`, explicit conjugation closure of each under **every** `g : G`,
`a ∈ A`, and `b ∈ B`. It proves
`a*b*a⁻¹*b⁻¹ ∈ A ⊓ B`. For the first membership multiply `a` by the
conjugate `b*a⁻¹*b⁻¹`; for the second multiply the conjugate
`a*b*a⁻¹` by `b⁻¹`.

Kernels of genuine group homomorphisms are a possible application of this
normality hypothesis. The source does not define the other-block maps or
kernels, produce nonzero kernel words, or construct nonidentity elements
supported on one block in the intersection of all the other kernels.
The matrix entry identity and this binary membership lemma support that
separate argument; they do not formalize the whole argument.

### 2.5 Exact additive span is an assumption, not arithmetic proved here

This section assumes `[DivisionRing D]`, with no commutativity of multiplication,
and an arbitrary target type `B`. `increments f` is the additive subgroup
`N={y | ∀a, f(a+y)=f(a)}`; the universal quantifier is essential.

`exact_additive_amplification` has these exact inputs:

```text
V : Subgroup Dˣ
hspan : AddSubgroup.closure (Units.val '' (V : Set Dˣ)) = ⊤
f : D → B
hleft : ∀ v ∈ V, ∀ a, f ((v : D)*a) = f a
y : D,  hy : y ≠ 0
hstep : ∀ a, f (a+y) = f a
```

It concludes `∀ a b, f a = f b`. Here `AddSubgroup.closure` is the
**algebraically generated additive subgroup** (integer combinations), not a
topological closure or a vector-space span. There is no topology on `D`.

Conjugating the increment using left invariance gives `v*y ∈ N` for each
`v ∈ V`. The preimage of `N` under the additive map `z ↦ z*y` therefore
contains the generated subgroup; `hspan` makes that preimage all of `D`.
For any `z`, use `(z*y⁻¹)*y=z`. This preserves multiplication order and is
valid over noncommutative division rings. Finally the increment `b-a`
compares any two values. Nothing proves `hspan` for `U(k)` or for another
arithmetically defined subgroup.

### 2.6 Pair constancy, not an explicit group-action theorem

`pair_invariant_constant` uses the same `V,hspan`, a function
`f : D × D → B`, and:

```text
hfirst  : ∀ v ∈ V, ∀ a c, f(v*a,c) = f(a,c)
hsecond : ∀ v ∈ V, ∀ a c, f(a,v*c) = f(a,c)
hupper  : ∀ c ≠ 0, ∃ y ≠ 0, ∀ a, f(a+y,c) = f(a,c)
hlower  : ∀ a ≠ 0, ∃ y ≠ 0, ∀ c, f(a,c+y) = f(a,c).
```

It concludes exactly
`∀ a c, (a,c) ≠ (0,0) → f(a,c)=f(1,1)`.
An increment may depend on the fixed coordinate, but not on the variable
coordinate in its slice. Replacing `∃y, ∀a` by `∀a, ∃y` is not what was
proved. The theorem first makes every nonzero-coordinate row and column
constant by additive amplification. A pair with `c ≠ 0` connects through
`(1,c)`; a pair with `c=0` has `a ≠ 0` and connects through `(a,1)`.
No conclusion is imposed on `f(0,0)` beyond the hypotheses.

The fidelity document's “Applied to orbit classes, this is exact transitivity”
is a **mathematical application**, not a separately coded group-action
declaration. There is no action/group parameter, orbit quotient construction,
`MulAction` theorem, or conclusion `∃ g, g • p = q` in this source.
To obtain that corollary, one must supply a real action on the nonzero pairs,
show that its orbit map satisfies these hypotheses (and extend it to the
whole-pair domain if using this exact function type), and relate equal orbit
classes to an actual group element. Likewise an application to a manuscript's
`F_d` must establish well-definedness and the four invariances. Constancy of
an arbitrary already-invariant function does not construct those transformations.

## 3. Statement-fidelity assessment, separate from compilation

The fidelity document is substantially accurate **within its stated algebraic
boundary**. It correctly distinguishes abstract subgroup generation from
closure, exact membership from density, noncommutative additive arguments
from field-valued matrix calculations, and slice-wide increments from
pointwise increments. It names the decisive declarations and records the
important exclusions. The orbit-class sentence requires the unformalized
bridge just described; it must not be reported as a compiled action theorem.
The normal-kernel language must likewise be restricted to the generic
intersection lemma and its unencoded application.

The source does **not** formalize the phase ring or its congruence units;
finite-root avoidance or existence/admissibility of manuscript phase/boost
generators; weak approximation, global-field arithmetic, local Brauer or
Hermitian-form inputs; exact arithmetic additive generation; Sylvester or
three-unitaries identities; construction, invariance, and evaluation of `F_d`;
manuscript geometry or the remaining reductions; or either number-field or
function-field Margulis–Platonov theorem. No novelty conclusion follows:
this unit reproduces inherited Argus algebra using Lean/Mathlib and makes no
claim that the underlying identities or implications are new.

No imported arithmetic citation is needed as a ledger assumption on this narrow
universal implication. Its mathematical hypotheses are the quantified
antecedents listed above, not obligations silently discharged by a compiler.
This Engineer's fidelity reading is not itself a kernel verdict.

## 4. Historical failures and what the old success actually establishes

The five receipt files initially say only `state=submitted`. Read-only
inspection of their exact old runner records gives:

| Old task | Terminal outcome | Meaning |
|---|---|---|
| `et-lean-core` | error, exit 1, 106.6 s | Unsolved goals and failed ring/linear-arithmetic proof attempts. |
| `et-lean-core-2` | error, exit 1, 57.2 s | Unsolved goals and a failed `change` tactic among the diagnostics. |
| `et-lean-core-3` | error, exit 1, 57.5 s | Further unsolved goals and a failed `change` tactic. |
| `et-lean-certification` | preflight error; no compiler exit, 0.0 s | Runner rejected the literal executable token `$P`; this did not test a theorem. |
| `et-lean-certification-literal` | done, exit 0, 24.8 s | Literal-path certification command completed. |

The old source path was mutable during those attempts. Those early runner
receipts/logs are not byte-bound proof certificates for the presently preserved
version and do not establish which exact intermediate source was tested.
None of these failures is a mathematical refutation.

The final old certificate, `lean_check.json`, `lean_evidence.json`, and
`compile.log` instead agree on success, compiler exit 0, local-axiom audit
exit 0, no proof holes, and 24,397 ms for version 2's preserved text. Their
warnings are lint/style warnings, not admitted proofs.
`formal_claim_state.json` reports historical `closed_kernel` but explicitly
caveats that statement fidelity is unchecked; `lean_evidence.json` records
`verified_by: null`. The old Engineer and `reviewer:copilot-independent`
judgments remain historical data, not this campaign's native acceptance.
The old structural checks (`ok: true` and a valid 20-node graph) concern the
old campaign, not the current campaign's absent graph.

## 5. Current isolated replay

Before execution I inspected the current `lean_evidence`, `lean_check`,
`math_state`, axiom-audit, and relevant direct-runner implementations and CLI
contracts. Current math entrypoints are `argus_skill.verticals.math.*`;
the old `argus_skill.tools.{lean_evidence,math_state}` aliases are absent.
The failed alias help probes are preserved as tooling diagnostics in
`replay/cli_legacy_alias_failures.json`; no compiler verdict came from them.
All module invocations use
`$WORKSPACE/argus-latest/.venv/bin/python`.

`verify` writes canonical `Main.lean`, `statement_fidelity.md`,
`lean_check.json`, `compile.log`, and `.lean-artifacts.lock` in its explicit
artifact directory. Its claim recorder archives a source/fidelity-bearing
JSON certificate under that source directory's `certificates/` and updates
the current `research/MATH_STATE.json` under its lock. Atomic publication
uses sibling staging files. None of these paths is `research/lean`.
The two already-canonical copies were left unchanged while verification ran.
`replay/source_copy_receipt.json` records byte equality with the old inputs.

The actual compiler is invoked directly with the existing built library
directories in `LEAN_PATH` and `--no-lake`; no lakefile, package update,
Mathlib build, or write in the shared workspace is needed. The installed
workspace is an acceptance project whose Mathlib dependency lives under
`.lake/packages/mathlib`, not at the workspace root. An initial overly strict
library probe rejected the optional unbuilt `Cli` package before compilation;
using the nine existing import directories removes that irrelevant precondition.
No dependency was installed and no missing compiler result was represented as
success.

The mutable host probes found Lean 4.31.0, x86_64 Linux, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Release; Lake
`5.0.0-src+68218e8`; and elan `4.2.3 (b6cec7e10 2026-06-08)`.
The workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`
pins `leanprover/lean4:v4.31.0` and declares Mathlib revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`.
The built `Mathlib.olean` is present. The revision is manifest metadata, not
an independent Git checkout attestation: no `.git` was accessed.

For a potentially long run I used the official durable runner in **direct**
mode, task `draft018-formal-core`, timeout 1200 s. This launches no LLM agent.
The submission receipt is preserved verbatim in meaning in
`replay/runner_submission.json`, including `state=submitted`, task/run IDs,
and `check_with`. The registry cwd is the owned `replay/` directory because
the runner otherwise writes a root-level `.argus_subagents`; its command
cwd and **every mathematical ledger operation** are the exact campaign root.
The runtime/inbox and cache paths are also confined under `replay/`; a
nonexistent explicit `GIT_DIR` prevents repository discovery. Context is in
`replay/runner_context.json`. Initial official status returned running, exit 0,
with live worker and command PIDs.

### Fresh result, reclaimed rather than inferred from submission

The actual run ID is
`draft018-formal-core-1794069266973300317`. The reclaimed durable result is
**`done`, exit 0, 26.5 s**, preserved in `replay/runner_reclaimed.json`.
There is **no pending durable task or compiler receipt** for this replay.

The official `lean_evidence verify` invocation exited **0** and recorded:

* compiler `status: success`, exit **0**, duration **20,178 ms** including its
  checking/audit workflow;
* local-axiom audit exit **0**, with empty audit stdout/stderr;
* `proof_holes: []`, empty compiler stderr, and only the nine inherited
  style/linter warnings;
* the same source and fidelity digests as the old final certificate;
* fresh mechanical evidence `lean-R_FORMAL-73ffba586fad`, producer
  `lean_evidence/lean 4.31.0`, bound to the current `R_FORMAL` version 2 hash;
* archived certificate
  `replay/certificates/R_FORMAL-610adbfb116d6430.json`.

The full command and exit receipt are in `replay/verify_invocation.json`.
The payload with claim recording is `replay/verify_result.json`; canonical
compiler evidence is `replay/lean_check.json` and `replay/compile.log`.
`replay/replay_outcome.json` collects the actual outcomes.
The CLI/driver cwd is the campaign root; the underlying bare compiler's cwd,
chosen by the official checker, is the source's owned replay directory.
`lake_workspace: ""` is correct for this direct-compiler mode; the external
import workspace and complete `LEAN_PATH` are separately recorded in
`replay/toolchain_context.json`.

After verification, a different diagnostic elaboration passed the unchanged
source to the same Lean binary's `--stdin`, followed only by `#print axioms`
for all **29** named declarations (15 theorems, 13 definitions, one abbreviation).
It exited **0**, and all 29 dependency responses were parsed. Across these
declarations the only reported axioms are **`propext`, `Classical.choice`,
`Quot.sound`**. The principal matrix, extraction, amplification, and pair
theorems use that three-axiom set; `commutator_in_intersection` reports only
`propext`. Per-declaration results are in
`replay/kernel_axiom_dependencies.json`, with the raw response in
`replay/kernel_axioms.stdout`. No second `.lean` file was created or left
unverified. This query adds dependency information, not a new mathematical
result or a repeated unchanged verification claim.

The official local-axiom audit alone reports no **newly declared** axioms; it
does not mean all imported foundations are axiom-free. The dependency query
identifies that trust boundary. Existing Lean/Mathlib compiled libraries and
the compiler/kernel are relied upon; this is not a rebuild or independent
foundational verification of all imported Mathlib artifacts.

## 6. Ledger checks, attribution, and disposition

After binding `R_FORMAL` the actual official check exits were:

| Material change | `math_state check` | `proof_graph_check check` |
|---|---:|---:|
| Bind unchanged source as `R_FORMAL` v2 | 0 | 2 |
| Record fresh mechanical compiler evidence | 0 | 2 |
| Register Engineer's scoped supporting judgment | 0 | 2 |

Both use `--project-root` equal to the exact campaign root. The graph failure
is `no proof graph at .../9200018/research/PROOF_GRAPH.json`. That file does
not exist and is outside this unit's writable scope. I did not create it or
claim a graph pass. This structural limitation is not a failed Lean proof and
does not validate other units. The initial caller-reported baseline was likewise
math-state exit 0 and graph-check exit 2.

The Engineer assessment is **supports `R_FORMAL` under its exact encoded
hypotheses**, with the human statement-fidelity qualifications in Section 3.
Historical `C_ET_FORMAL_CORE` v2's local scope is reproduced; v1's different
proof text is superseded and is not certified by v2's certificate. No local
mathematical contradiction was found. The unformalized arithmetic/action/
manuscript bridges are explicit boundaries, not claims discharged here.

The actual `math_state judge` call exited **0**, recording
`judgement-R_FORMAL-9d77223c8bda`, verdict `supports`, producer
`engineer:formal-core-reader`, artifact
`research/draft_reviews/formal-core/report.md`. Its receipt is
`replay/judge_result.json`; final post-change check receipts are
`replay/after_judgment_checks.json`. Current `math_state show` reports
`R_FORMAL` v2 as `closed_kernel` because of the fresh mechanical certificate,
while retaining the explicit caveat that the schema does not establish
statement fidelity. That derived formal status is not native acceptance of
this review; the Engineer's separate reading is the argument in this report.

Attribution remains to the inherited Argus source and its Lean/Mathlib
dependencies. This is a reproduction/technical assessment, not an original-
contribution or novelty certification. No citation attribution was filed under
another identity. The independent acceptance decision remains
`pending_native_Host_Reviewer`.
