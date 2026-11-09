# Family013: formal algebra and bounded exact replay

## Assessment and attribution

**Technical assessment:** the eleven named declarations in the archived
`Main.lean` are supported in their exact, limited algebraic scope. An unchanged
current copy received fresh official compilation and axiom auditing with no
holes. The unchanged exact checker also reproduced its archived certificate.
Neither result formalizes the analytic tree theorem, establishes its arithmetic
applications, or constitutes native independent-Reviewer acceptance.

This unit reviews the old Argus claim `C_TREE_ALGEBRA` and its finite diagnostics,
not a new manuscript-error search. The source calculations are associated with
*The additive indecomposability of the primes*, manuscript revision
`4eaee87548250b2682affda7d05d947c05554bae`, especially `06-tree.tex`,
`eq:src36`, `eq:tree-held-square`, `eq:tree-p-square`, and the affine-coordinate
calculation. These are elementary algebraic formalizations/reproductions, not
an asserted original solution of the arithmetic problem. No novelty is claimed.
The parent review owns the analytic theorem assessment; it is not repeated here.

The sole current writable project root for the ledger commands was

`campaigns/9200013`.

All other writes in this unit were confined to
`research/draft_reviews/formal_algebra/`. No old program was executed in the old
workspace. The preserved archive was not extracted or modified.

## 1. Historical versions and exact evidence binding

The two versions are one evolving assertion, not two mathematical discoveries.

| Historical version | Content and binding |
|---|---|
| `C_TREE_ALGEBRA@1` | Natural statement only; empty formal statement; content hash `3d1f2cd1da76e0a56fe7ff68fb55b7479809b7e7e7b8ad351e9962c482539a44`. |
| `C_TREE_ALGEBRA@2` | Identical natural statement, with the complete 4,118-byte Lean source added; content hash `baedf52c1463568b87a644b21c9a75bd4e9543954b300599210df7e367b67fe6`. |

The shared natural statement is:

> Over every field with the displayed nonzero hypotheses, the reconstruction
> difference, held-ratio-square and p-square identities hold; equal squares have
> at most the two signed roots; nonidentity affine representations are injective
> at a fixed ratio; nonmatching unordered quadratic pairs have at most one
> collision argument.

The archived certificate
`research/tree_comparison/certificates/C_TREE_ALGEBRA-aecfcac1b0b37198.json`
has subject hash **v2**, not v1. Its embedded source equals v2's complete formal
statement and the actual old `Main.lean` byte-for-byte; its embedded fidelity
document equals the actual old document. Its compiler result equals archived
`lean_check.json`; `lean_verify_output.json` stripped of its `kernel` member
equals that same compiler result. The source and fidelity digests are:

* Source: `ad826281105091df53f2e657a256cb8b624282206f7fc165e6a5d17943ee4112`.
* Fidelity: `700d47efc592026127f4a29e3b74e2f35b2a50e8318f9b2cc1b8cb1181a18c83`.

The old mechanical evidence `lean-C_TREE_ALGEBRA-5ae380ac98c9`, engineer
judgment `judgement-C_TREE_ALGEBRA-e45241cc790a`, and
**`reviewer:a32ebef5489a`** judgment
`judgement-C_TREE_ALGEBRA-43c783561a58` all bind **v2's content hash**.
It would be inaccurate either to deny the historical reviewer judgment or to
describe it as an independent acceptance of this new review.

Separately, every historical graph node, including `C_TREE_ALGEBRA`, still has
`reviewer_confirmed=false`. Its algebra node explicitly leaves statement
fidelity for independent review. Historical ledger judgments and this stale
graph view coexist; neither was rewritten. `R_TREE_MAJORANTS` still references
the **v1** algebra hash, so v2's certificate must not silently be represented as
evidence attached to that exact v1 route obligation. Equality of the natural
statements explains the supersession, but does not change the stored reference.

`historical_artifact_audit.json` records these comparisons and extracted
version-matched records. All 21 inventoried old artifacts retain their original
digests after replay. The nine family013 files actually listed in the preserved
snapshot manifest match its sizes and SHA-256 digests. The other twelve are
covered as old-workspace artifacts, not mislabeled as snapshot-listed files.

## 2. Exactly what Lean proves

`import Mathlib` is the only import; `autoImplicit` is disabled. The first nine
declarations below quantify over an arbitrary field `K`, including
characteristic two. They do not require a finite field, primality, or an odd
characteristic. The final two concern a group and natural numbers respectively.
The following are all the named declarations, not a selection.

For the first and third statements, abbreviate

```
Y+ = splus  / (D*p*u*Hplus)
Y- = sminus / (D*p*u*Hminus)
Y  = sn / (D*Hplus*Hminus).
```

1. **`TreeComparison.reconstruction_difference`**:
   `D,p,u,Hplus,Hminus ≠ 0` and
   `splus*Hminus - sminus*Hplus = sn*p*u` imply `Y+ - Y- = Y`.
   The three `s` variables need not be nonzero in this theorem.
   The reconstruction equation is a hypothesis, not a derived existence claim.

2. **`TreeComparison.held_ratio_square`**:
   `D,p,u,Hfree,Hheld,sheld,sn ≠ 0`, with arbitrary `sfree`, imply

   ```
   (sfree/(D*p*u*Hfree) / (sheld/(D*p*u*Hheld)))
       / (sn/(D*Hfree*Hheld))
     = (D*sfree/(sheld*sn))*Hheld^2.
   ```

3. **`TreeComparison.reconstructed_square`**:
   `D,p,u,Hplus,Hminus,splus,sminus,sn ≠ 0` imply

   ```
   p^2 = (splus*sminus/(sn*D*u^2)) * Y / (Y+*Y-).
   ```

   This is a cancellation identity after substitution. Unlike statement 1, it
   has no reconstruction-equation hypothesis and does not establish one.

4. **`TreeComparison.bad_held_cancellation`**:
   `e ≠ 0` and `p^2*d*e = c*y` imply `d*p^2 = c*y/e`;
   the other variables have no nonzero assumptions.

5. **`TreeComparison.square_fiber`**:
   `z^2=w^2` implies `z=w ∨ z=-w`. No nonzero, characteristic, or
   root-existence assumption is made. In characteristic two the two alternatives
   can coincide. There is no assertion that every value has two roots.

6. **`TreeComparison.affine_composition`**:
   `r ≠ 0`, with arbitrary `s,t`, implies

   ```
   s - s^2*((r-t)/r^2) = (s/r)^2*t + s - s^2/r.
   ```

7. **`TreeComparison.affine_fixed_ratio_injective`**:
   `z ≠ 0`, `z ≠ 1`, and
   `r*(z-z^2)=r'*(z-z^2)` imply `r=r'`.
   Neither `r` nor `r'` is assumed nonzero.

8. **`TreeComparison.quadratic_pairs_of_coefficients`**:
   `b1+b2=b3+b4` and `b1*b2=b3*b4` imply
   `(b1=b3 ∧ b2=b4) ∨ (b1=b4 ∧ b2=b3)`.
   Repeated or zero entries are allowed.

9. **`TreeComparison.off_diagonal_collision_unique`**:
   if those two unordered-pair matchings are both excluded, and both `a` and
   `a'` satisfy `(x-b1)*(x-b2)=(x-b3)*(x-b4)`, then `a=a'`.
   There is no assumption that the common product is nonzero.

10. **`TreeComparison.cycle_index_unique`**:
    for an arbitrary `Group G`, `x*z=1` and `y*z=1` imply `x=y`.
    No commutativity, character theory, graph, cycle, or field occurs here.

11. **`TreeComparison.local_constant_budget`**:
    the natural-number inequality
    `32*256 + 64*8192 ≤ (2:ℕ)^20`, namely `532480 ≤ 1048576`.

The decisive algebra is sound: statement 1 subtracts fractions and uses its
explicit cleared reconstruction equation; statements 2–4 cancel nonzero
denominators; statement 5 factors a difference of squares. Statement 7 uses
`z-z^2=z*(1-z) ≠ 0`. Equal sum and product give
`(b1-b3)*(b1-b4)=0` in statement 8. Subtracting the two collision equations in
statement 9 gives
`(a-a')*((b3+b4)-(b1+b2))=0`; distinct arguments would force equal sums,
then equal products, contradicting the excluded matchings. Statement 10 is
right cancellation, and statement 11 is exact numeral arithmetic.

### Axioms and trust boundary

There are no new `axiom`/`constant` declarations, `sorry`, or `admit` in the
source. Fresh official source scanning and environment axiom auditing returned
`proof_holes=[]` and audit exit 0. This does **not** mean axiom-free foundations:
an additional fresh `#print axioms` query reported
`[propext, Classical.choice, Quot.sound]` for statements 1–9 and 11, and
`[propext]` for `cycle_index_unique`. See `axiom_dependencies.log`.

The query supplied the unchanged source plus only printing commands on standard
input, and created no additional `.lean` file. The assumptions are Lean's
standard logical foundations and imported Mathlib, together with the displayed
field/group/nonzero hypotheses—not an assumed analytic bound. The old ledger's
empty `external_assumptions` list is not a claim that these logical axioms vanish.

## 3. Statement-fidelity assessment

The unmodified fidelity document is accurate for these algebraic ingredients.
The correspondence with the source equations was checked directly, not inferred
from compiler success. The manuscript `06-tree.tex` reference matches the
manifest hash
`290c22fc61a7787fdf8d7074e5df48c0c98a65531f7399caa0a0fe7d626b9d00`;
see `source_reference_check.json`.

In `eq:src36`, put `D=D'`, the displayed child products in `Hplus,Hminus`,
and the displayed current-node frequency in `sn`. The hypothesis in statement 1
is exactly the denominator-cleared definition of `p_n`; the other rational
formulas give the stated difference. Statement 2 gives the displayed
held-square coefficient `D'*s_free/(s_held*s_pair)`. Statement 3 gives exactly
the displayed coefficient `s_+*s_-/(s_n*D'*u_n^2)` multiplying `y/(d*e)`.
No missing nonzero denominator or algebraic sign error was found in these
formal statements.

There are important interpretation limits:

* The introduction's reference to arbitrary fields must be read with its
  explicit group exception and natural-number budget: not all eleven
  declarations are field statements.
* The held-square identity uses the node argument as its denominator. Switching
  the free and held leaf can reverse the **oriented difference** used in an
  analytic integral. That interpretation and any resulting sign choice are not
  an additional theorem of this source.
* For `U_r F(t)=F(r-r^2*t)`, substituting the inverse coordinate
  `(r-t)/r^2` into `U_s` yields statement 6. This checks the coordinate formula,
  not adjoints, unitarity, or any operator bound.
* Equal slopes give at most two choices of `z=s/r` by statement 5; for a
  nonidentity representation, statement 7 then fixes `r` from the translation.
  The elementary deduction is correct, but no finite-cardinality theorem about
  affine-map representations is itself encoded in Lean.
* The document's “one-quartet parallel-edge case” is an intended application of
  group cancellation. No parallel-edge graph, cycle existence, character
  assignment, inverse-exponent substitution, or integration argument is
  formalized by statement 10.
* The budget theorem adds constants **if** suitable majorants have already
  been established. It does not construct or bound a majorant.

Consequently this is not a formalization of density domination, probability
laws or conditional distributions, Fourier/Mellin/character expansions, affine
operator estimates, fourth-moment estimates, parameter-free majorants, quartet
integration, graph-cycle existence, cycle projection, the all-prime tree bound,
the explicit analytic `16^r` conclusion, or Ostmann's conjecture. The fidelity
document itself correctly disclaims the complete analytic theorem; its reference
to proofs in the old report does not transfer a compiler verdict to those proofs.
This technical human assessment does not change the official
`statement_fidelity.verified_by=null` or supply native Reviewer acceptance.

## 4. Safe exact-checker replay

The checker was read in full before execution. Its imports are `argparse`,
`collections`, `fractions`, `itertools`, `json`, `pathlib`, `sympy`, and
`sympy.polys.domains`. It performs no subprocess, network, or manuscript
operation. `HERE` is its resolved script directory. The sole explicit write is
`HERE/exact_certificate.json.write_text(...)`, conditional on
`--write-certificate`. Without that flag, it instead asserts exact JSON equality
with the stored certificate.

Six byte-identical copies were placed under `replay/`: `Main.lean`,
`statement_fidelity.md`, `verify.py`, `exact_certificate.json`,
`lean_verify_output.json`, and `jacobian_result.json`. The checker was run
**without** the write flag and with Python assertions enabled. All six copies
remained unchanged. No old executable path was used.

The Argus virtual environment initially lacked a directly importable Sympy.
Its same Python interpreter successfully used already-installed
Sympy **1.14.0** and mpmath **1.3.0** from
`$WORKSPACE/miniconda3/lib/python3.13/site-packages`, exposed only to the
checker subprocess. No dependency was installed or shared environment changed.
Python was **3.13.5**, Anaconda build, GCC 11.2.0. The execution interpreter
remained `$WORKSPACE/argus-latest/.venv/bin/python`.

The unchanged checker is deliberately archival in one respect: it reads the
copied **historical** Lean output and asserts old claim `C_TREE_ALGEBRA` and
Lean `4.31.0`; it also asserts the historical Jacobian rejection. Those checks
do not freshly compile Lean or establish a current Jacobian result.
Fresh official compilation was therefore performed separately, as section 5
records. The old exact-certificate metadata was not relabeled as fresh evidence.

### Reproduced counts and unchanged bounds

`exact_replay_result.json` and `exact_checker.stdout.log` record exit **0** and
an exact match to the unchanged archived JSON certificate:

| Diagnostic | Replayed count |
|---|---:|
| Symbolic polynomial/rational identities | 9 |
| Rational-budget assert statements / scalar inequalities | 12 / 14 |
| Prime-field fiber diagnostic cases | 6 |
| Diagram parameter cases | 20 |
| Leaf-tuple occurrences across parameter cases | 4,244 |
| Valid / zero-reconstruction-invalid occurrences | 2,104 / 2,140 |
| Function/conjugation cases | 324 |
| Quartet sign-lift checks | 19,008 |
| Paired parameter cases / matched-partition cases | 4 / 259 |

The nine symbolic identities are `affine_composition`,
`affine_injectivity_factor`, `affine_translation_factor`,
`held_ratio_square`, `off_diagonal_collision_factor`,
`principal_fourth_moment_sum_of_squares`,
`quadratic_unordered_pair_factor`, `reconstructed_square`, and
`reconstruction_difference`. The fourth-moment entry checks an exact expansion;
it is not a formalized analytic fourth-moment theorem.

The fiber primes are **3, 5, 7, 11, 17, 31**, with maximum nonidentity affine
multiplicities **1, 2, 2, 2, 2, 2** respectively. Unit-square fibers have size
two, the identity affine map has `q-1` representations, and the finite
sum/product pair diagnostic has a unique unordered pair. No other primes were
added.

| `q` | Depth | Variants | Leaf tuples per variant | Valid tuples, in variant order |
|---:|---:|---|---:|---|
| 3 | 0 | 0,1 | 2 | 2,2 |
| 3 | 1 | 0,1 | 4 | 2,2 |
| 3 | 2 | 0,1,2,3 | 16 | 8,0,8,8 |
| 3 | 3 | 0,1,2,3 | 256 | 0,0,128,128 |
| 5 | 0 | 0,1 | 4 | 4,4 |
| 5 | 1 | 0,1 | 16 | 12,12 |
| 5 | 2 | 0,1 | 256 | 112,112 |
| 7 | 2 | 0,1 | 1296 | 816,744 |

These are occurrences, not 4,244 different tuples independent of parameters.
The zero-valid cases are honestly retained. The nontrivial paired tests use
variants 2 and 3 for `q=3`, rather than the vacuous depth-three variants 0 and 1.
The three depth-two paired cases contribute 86 matched-partition cases each
over `q=3,5,7`; the chosen two-quartet `q=3`, depth-three configuration
contributes one. They use distinct parameters/conjugations and the exact
Gaussian-rational function `1/2+(-1)^x*i/100`, with positive projected norms.
They do not exhaust all depth-three partitions or functions.

At `L=3/2`, the reproduced budget entries are

```
same_pair_small = 243             <= 256
same_pair_sum   = 162             <= 256
cross_pair_sum  = 729/4           <= 256
cross_pair_small= 6912            <= 8192
untouched_mean = 81/2             <= 2^20
combined_small = 532480           <= K = 1048576 = 2^20
```

The other unchanged scalar checks include the two initial `L`-bounds, the
two bounds by 40, `96*256 ≤ 2^20`, and `3^4*2^21 ≤ 16^8`.
The archived `paired_constant` string remains `16^(2^l)`; its presence is
not a machine proof of the analytic estimate. Finite tests, including their
reported density ratios, cannot prove an all-prime or asymptotic statement.
No prime range, depth, parameter family, or constant budget was enlarged.

## 5. Fresh official Lean evidence and durable execution

Before compilation, the official locking ledger CLI registered
`CTX_REVIEW_ALG_013` and `C_REVIEW_ALG_013`, whose formal-file input was the
isolated `replay/Main.lean`. Only these identifiers and their mechanical replay
evidence were written by this unit. Current claim version 1 has content hash
`c84b4526a2ce41e71ace1a4654043d09c7eb90b87ad20058b395de2c91578c11`.

The official invocation was:

```
$WORKSPACE/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  families/013/argus-review/draft_reviews/formal_algebra/replay/Main.lean \
  --statement-fidelity families/013/argus-review/draft_reviews/formal_algebra/replay/statement_fidelity.md \
  --project-root campaigns/9200013 \
  --claim C_REVIEW_ALG_013 --timeout 90
```

Both source and fidelity stayed unchanged before, during, and after verification;
their hashes are the historical hashes above. The fidelity's historical claim
name was intentionally preserved, not silently edited. The new claim explicitly
identifies the same eleven declarations and excludes analytic conclusions.

The actual compiler verdict was **success**, compiler exit **0**, axiom-audit
exit **0**, `proof_holes=[]`, empty environment failure, and 15,540 ms recorded
compiler/audit duration. There were only the original harmless tactic-linter
warnings at lines 27, 39, and 63. `lean_evidence_check.json` subsequently passed
official evidence validation with exit **0**.

The installed toolchain was probed before use and recorded again by the actual
verification:

* Lean **4.31.0**, `x86_64-unknown-linux-gnu`, release commit
  `68218e876d2a38b1985b8590fff244a83c321783`.
* Lake **5.0.0-src+68218e8**, Lean 4.31.0.
* Elan **4.2.3**, `b6cec7e10`, 2026-06-08.
* Mathlib workspace:
  `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
  Compilation actually used `$WORKSPACE/.elan/bin/lake env lean` there;
  this is not an inference from the old version string.

The **officially generated**, not fabricated, current certificate is:

`research/draft_reviews/formal_algebra/replay/certificates/C_REVIEW_ALG_013-e94723e45360c6b2.json`

Its evidence ID is `lean-C_REVIEW_ALG_013-d0a98d5f2b0c`, tier `mechanical`,
verdict `supports`, subject `C_REVIEW_ALG_013` at the current hash above.
`final_binding_audit.json` verifies the live claim's formal text, certificate's
source/fidelity text, actual compiler record, recorded evidence, and file hashes
all agree. The only retained `.lean` in this unit is this officially verified
unchanged copy.

Both potentially long tasks used the official Argus durable runner in direct
mode, never a session-background shell or another agent:

| Task | Run ID | Bound | Final state / exit |
|---|---|---:|---|
| `9200013-formal-replay` | `9200013-formal-replay-1794068409450862745` | 360 s | `done` / 0, 21.5 s |
| `9200013-exact-checker` | `9200013-exact-checker-1794068409432354909` | 420 s | `done` / 0, 2.9 s |

Submission states, `task_id`, `run_id`, and `check_with` are preserved in
`formal_runner_receipt.json` and `exact_runner_receipt.json`; terminal states
are in the corresponding `*_runner_status.json`. Execute their `check_with`
commands from the owned directory, where the registry resides. The runner's
runtime/inbox root was also confined to this directory. Neither run entered
`discussing`; no outstanding reply or running computation remains.

### Current structural checks: exact roots and exit statuses

After registration, after mechanical evidence changed the shared current
ledger, and once more at handoff, **both** official checks ran with

`--project-root campaigns/9200013`.

| Check | After registration | After Lean evidence | Final |
|---|---:|---:|---:|
| `argus_skill.verticals.math.math_state check` | 0 | 0 | 0 |
| `argus_skill.verticals.math.proof_graph_check check` | 2 | 2 | 2 |

Each math-state result is `{"ok":true,"issues":[]}`. Each graph command reports
**no proof graph at the exact current root**. This is a real nonzero result,
not a graph-validation pass and not a failed algebra proof. No
`PROOF_GRAPH.json` was created: the authorized review is exploratory and has no
develop-route requirement. The stage-specific JSON measurements and stdout/
stderr files preserve the exact commands and return codes.

## 6. Historical auxiliary evidence and coverage

Every requested historical formal artifact was inspected:

| Old artifact(s), relative to `research/tree_comparison/` unless stated | Disposition |
|---|---|
| `Main.lean`, `statement_fidelity.md` | All declarations, hypotheses, scope and source correspondences checked; unchanged copies freshly verified. |
| `verify.py`, `exact_certificate.json` | Imports/write behavior inspected; unchanged isolated replay matched exactly. |
| `certificates/C_TREE_ALGEBRA-aecfcac1b0b37198.json` | Embedded source/fidelity/compiler result and v2 subject reconciled. |
| `lean_check.json`, `compile.log`, `lean_verify_output.json` | Historical Lean 4.31.0 success, zero holes, audit 0 and linter warnings agree; not substituted for fresh evidence. |
| `lean_runner_receipt.json`, `lean_runner_status.json` | Old direct run `9000013-tree-algebra`, run ID `9000013-tree-algebra-1793901480029392967`, ended `done`, exit 0; its command records old Lean/state/graph exits all 0. It was read, never executed. |
| `jacobian_contract.json`, `jacobian_discovery.json`, `jacobian_payload.json`, `jacobian_result.json` | Typed discovery/contract and rejected request reviewed; see below. |
| `math_state_check.txt`, `proof_graph_check.txt` | Historical state has no structural issues and historical graph says valid, 19 nodes; neither is a theorem proof or current check. |
| `research/MATH_STATE.json`, `research/PROOF_GRAPH.json` | Targeted algebra-version, judgment, stale-route and graph-flag reconciliation only; broader analytic review left to the parent. |
| `report.md` | Shared source/attribution and algebraic equation context inspected; whole analytic theorem not reassessed in this unit. |
| `research/MATH_STATE.json.lock`, `.lean-artifacts.lock` | Inventoried empty synchronization files, no mathematical content; never acquired or modified. |

The historical Jacobian discovery reported server **0.14.0**, protocol
**2025-11-25**. The contract was
`finite_field.polynomial_map.table.compute`. Its payload attempted `x^2`
using characteristic 7 and modulus coefficients `[0,1]`. The response is
`ok=false`, JSON-RPC `-32602`, internal code **`INVALID_REQUEST`**, at
`operation_validation`: the finite-extension modulus-length bound was violated
in the domain, codomain, polynomial presentation, and three coefficient
presentations. It returned **no map table or mathematical conclusion**.
The old exact certificate records adapter exit 2 and no timeout; the raw
rejection itself establishes only validation failure, not a mathematical
counterexample. No Jacobian operation was invoked by this unit. The parent
handles the separate current typed bounded operation.

## 7. Concrete limitations and handoff

There is no unresolved Lean proof obligation among these eleven exact
declarations under the recorded toolchain and hypotheses. Their application
still requires the surrounding argument to instantiate the correct nonzero
data, reconstruct valid points, handle oriented differences and zero conventions,
prove probability and Fourier identities, supply analytic estimates and
majorants, and connect actual graph cycles to the elementary cancellation
statement. Those obligations are not discharged by this certificate or finite
replay. The finite domains and test-function families are small and explicitly
bounded; they cannot settle universal analytic or arithmetic claims.

Historical review metadata, successful compilation, and this scoped technical
assessment do not constitute native acceptance. Family coverage and final
acceptance remain for the **Host-invoked independent Reviewer**.
