# Shared formal core: old-draft review

## 1. Decision and boundary

**Supported as conditional rational arithmetic and determinant algebra, not as
a formal geometric or analytic theorem.** The retained source contains two
definitions and twelve theorems. Its decisive arguments are valid in their
stated domains, and a fresh actual Lean compiler run accepted the exact
immutable source. The historical failed source has a proof-API/typeclass error,
not a mathematical counterexample. There is one evolving argument
`C_TV_FORMAL_CORE`, not three independently established results.

The wording “pole,” “integrability,” “valuation,” “Cartier,” and “klt” is
interpretive: none of those structures is constructed by these declarations.
The numerical statements are faithful to the explicitly limited reading in
`statement_fidelity.md`, subject to the qualifications below. They do not prove
`C_G_VOLUME`, the structural geometric extensions, or any entire manuscript.

This is the bounded computational/formal unit, not the native independent
Reviewer and not project acceptance. The current review has
`novelty_status=not_applicable`. The old algebra is inherited classical algebra
and arithmetic, not verified new mathematics.

## 2. Sources, versions, and the failed/successful certificate

Old paths below are relative to the read-only directory
`families/068/first-pass/toroidal_volume_audit`.
Version statements and hashes were obtained from the parent's current
`research/DRAFT_REVIEW_INDEX.json`; the old ledger and graph were not separately
re-read. The mandated unmodified checker itself reads the old ledger for a
latest-claim hash comparison; that indirect read is disclosed here.

| Version | Exact change and assessment |
|---|---|
| v1, claim hash `9f9971b12185f5c1ee82ccfb73993e75aca0c549e59e8daccfb62dbd3b79e0ef` | Natural claim describes the determinant/simple-pole core, clipped-minimum inequalities, attained sharp threshold, and full-support discrepancy addition. Its formal-statement field is empty. The eventual source supports its numerical content as a subset, but no v1-specific compiler certificate is supplied. |
| v2, claim hash `f277a38df9439346bab3ac465799b305c405c1dec6c24c1822be2d6d8d28b0fc` | Adds “or a klt discrepancy plus any nonnegative Cartier contribution” to the natural claim and supplies the full source. Certificate `C_TV_FORMAL_CORE-35e31b26e468f3fb.json` records exit 1, `type_error`, in `sharp_prime_threshold`; as submitted, this source was not kernel-accepted. Its intended inequality is nevertheless correct. |
| v3, claim hash `7b23c776e6c6cc0c75e1b753b20a17475109e2293ca535953c75ee915a060fed` | Natural statement is identical to v2. One proof-lemma invocation is repaired, with no theorem statement or hypothesis changed. Certificate `C_TV_FORMAL_CORE-65971c48af507c01.json` records historical success. The retained `Main.lean` is byte-identical to this successful archive. |

The **entire source diff** between the failed and successful archives is:

```diff
-      (mul_lt_mul_left (he i)).mp hmul
+      (mul_lt_mul_iff_right₀ (he i)).mp hmul
```

The recorded error was at `Main.lean:89:7`: failure to synthesize
`MulRightStrictMono ℚ`. The repaired invocation correctly cancels the positive
factor `e i` from the strict inequality in this toolchain. This is a
proof-term/API repair, not changed mathematics or a new result.

Failed source SHA-256:
`c1d4c8d194ce6f4a1950e503474b7ebccf0dbe8ae167ae312d1b7a256483d6ba`.
Successful/retained source SHA-256:
`aa20a30000fee4bad1e0c6c4581e40f83ec394be71f506b9a9d77d852957763a`.
Both archives contain the same statement-fidelity text, SHA-256
`bc0bc8ac15319be1195167c2cfb3e7221eb11e1a737b7a63bb9ab159e91aa1de`.
`historical_comparison.json` preserves the exact indexed version statements,
their source pointers, the complete diff, and the declaration inventory.

The claim records' empty `external_assumptions` lists are not assertions that
the theorem hypotheses or geometric interpretation require no assumptions.
Those are separate matters.

## 3. Complete declaration inventory and exact quantifiers

Every source-local declaration is in namespace `ToroidalVolumeAudit`.
`import Mathlib`, the namespace, and `open Matrix` introduce no additional
source-local mathematical assertion. In the following, row addition and scalar
multiplication are pointwise.

### Matrix identities

1. **`cleared_logarithmic_determinant`**:
   arbitrary types `I,R` with `[Fintype I] [DecidableEq I] [CommRing R]`;
   arbitrary `A : Matrix I I R`, `k : I`, `m : I → R`, and `t : R`.
   Conclusion:

   ```text
   det(updateRow A k (m + t • A k))
     = det(updateRow A k m) + t * det A.
   ```

   There is no invertibility, characteristic-zero, positivity, nonzero
   determinant, or nonzero-`t` premise. Selecting `k` supplies an index; the
   statement does not require a separate nonempty-index instance.

2. **`at_most_simple_logarithmic_pole`**:
   arbitrary types `I,K` with `[Fintype I] [DecidableEq I] [Field K]`;
   arbitrary `A : Matrix I I K`, `k : I`, `m : I → K`, `t : K`,
   **with `t ≠ 0`**. Conclusion:

   ```text
   t * det(updateRow A k (A k + t⁻¹ • m))
     = t * det A + det(updateRow A k m).
   ```

   This is a denominator-clearing equality in a field, not a valuation or an
   order-of-pole assertion.

### Definitions and scalar inequalities

3. **`correction (lam : ℚ) : ℚ`** is exactly `max 0 (lam - 1)`.
4. **`room (lam : ℚ) : ℚ`** is exactly `min lam 1`.
5. **`correction_nonnegative`**: every `lam : ℚ`, without hypotheses;
   conclusion `0 ≤ correction lam`.
6. **`room_identity`**: every `lam : ℚ`, without hypotheses;
   conclusion `lam - correction lam = room lam`.
7. **`correction_bounded_by_jacobian`**:
   every `a,e,lam : ℚ` with **`0 ≤ a`, `1 ≤ e`,
   `e * lam ≤ a + 1`**; conclusion **`e * correction lam ≤ a`**.
   Equivalently `-a + e * correction lam ≤ 0`. No assumption `lam > 0`
   is used. Rational `e ≥ 1` includes the intended positive integral
   multiplicities, but arbitrary rational `0 < e < 1` is not covered.
8. **`nonexceptional_branch_forces_zero`**:
   every `e,lam : ℚ` with **`1 ≤ e`, `e * lam ≤ 1`**;
   conclusion **`correction lam = 0`**. No branch or discrepancy is
   constructed; the interpretation is the numerical case `a=0`.
9. **`minimum_positive`**:
   arbitrary type `I`, `a,e : I → ℚ`, `lam : ℚ`, with
   **`∀ i, 0 ≤ a i`**, **`∀ i, 0 < e i`**, and
   **`∃ i, e i * lam = a i + 1`**;
   conclusion **`0 < lam`**.
   There is no finiteness assumption and no minimum inequality hypothesis;
   a single attained equality with those signs suffices. The existential
   premise prevents an empty index type from making the positivity inference.
10. **`positive_room`**:
    every `lam : ℚ` with **`0 < lam`**;
    conclusion **`0 < room lam`**.
11. **`sharp_prime_threshold`**:
    arbitrary type `I`, `a,e : I → ℚ`, `lam,b : ℚ`, with
    **`∀ i, 0 < e i`**,
    **`∀ i, e i * lam ≤ a i + 1`**, and
    **`∃ i, e i * lam = a i + 1`**. Conclusion:

    ```text
    (∀ i, -1 < a i - e i * (correction lam + b))
      ↔ b < room lam.
    ```

    Neither finiteness nor `a i ≥ 0`, `e i ≥ 1`, `lam > 0`, or `b ≥ 0`
    is assumed here. The exact minimum is **assumed attained**, not computed
    or deduced from an infimum. For any index set, the stated inequalities
    and equality identify `lam` with an attained minimum of `(a i + 1)/e i`.
    Positivity of the interval comes from separate hypotheses/theorems.

### Arbitrary-index positivity and endpoint cancellation

12. **`full_support_discrepancy`**:
    arbitrary type `V`, functions `lc,cartier : V → ℚ`, with
    **`∀ v, 0 ≤ lc v`**, **`∀ v, 0 ≤ cartier v`**, and
    **`∀ v, lc v = 0 → 0 < cartier v`**;
    conclusion **`∀ v, 0 < lc v + cartier v`**.
    `V` is not typed as valuations and the functions have no discrepancy or
    Cartier structure. An empty `V` is allowed and gives a vacuous conclusion.
13. **`klt_type_monotonicity`**:
    arbitrary type `V`, `klt,effective : V → ℚ`, with
    **`∀ v, 0 < klt v`**, **`∀ v, 0 ≤ effective v`**;
    conclusion **`∀ v, 0 < klt v + effective v`**.
    No variety, boundary, or klt-type existence statement occurs.
14. **`blowup_endpoint`**:
    every `codim,s : ℚ`, without hypotheses; conclusion
    **`(-1 < (codim - 1) - (codim - 1 + s)) ↔ s < 1`**.
    There is no integral codimension, `codim ≥ 2`, blowup, `s ≥ 0`, metric,
    or integral in its type.

All scalar arithmetic here is over **ℚ**, not all real or irrational
perturbation parameters. The determinant identities have the more general
ring/field quantifiers listed above. The prose document states this rational
restriction correctly.

## 4. Substantive proof assessment

The determinant identities are direct uses of Mathlib determinant linearity in
one row. The second additionally distributes multiplication by `t` and uses
`t * t⁻¹ = 1`, exactly where `t ≠ 0` is needed. There is no unexplained
dimensional extrapolation from the two-by-two computation: the Lean statements
themselves quantify over every finite index type.

For the clipped correction, splitting at `lam ≤ 1` is decisive. In that case
the correction is zero. Otherwise
`e(lam-1) ≤ a+1-e ≤ a`, using the actual premise `e ≥ 1`.
The nonexceptional result follows because `lam > 1` and `e ≥ 1` would force
`e*lam > 1`. Attained equality gives `e i * lam = a i + 1 > 0`;
positivity of `e i` then gives `lam > 0`. These arguments match the code.

For the sharp threshold, put `c = correction lam`.
The identity `lam-c = room lam` makes `b < room lam` equivalent to
`c+b < lam`. Multiplying by each positive `e i` and applying
`e i * lam ≤ a i+1` proves every strict exponent inequality.
Conversely, using the branch attaining equality forces `c+b < lam`.
Thus the witness is essential to necessity and to exclusion of the endpoint:
at `b = room lam`, that branch has exponent exactly `-1`, not greater.
This proves the stated arithmetic equivalence, not the analytic criterion
identifying an exponent test with integrability.

For full support, either `lc v=0`, when `cartier v>0` is explicitly assumed,
or `lc v>0`, when nonnegative `cartier v` suffices. Klt-type monotonicity is
addition of a positive and a nonnegative rational. The endpoint expression
cancels to `-s`; its numerical equivalence is correct for every rational
`codim`. These are classical ordered-field manipulations, with no unresolved
arithmetic step found in the retained source.

## 5. Statement fidelity and concrete missing bridges

`statement_fidelity.md` is substantially candid about the separation from
geometry. Its numerical descriptions agree with the source, including the
attainment premise, the absence of `b ≥ 0` in the threshold theorem, and the
fact that `e ≥ 1` is used in the correction bound. Two interpretive cautions
are material:

* “Affine in a uniformizer” means affine in the **displayed scalar parameter
  for fixed coefficients**. The first theorem does not construct a polynomial
  variable or assert that entries of `A,m` are independent of, or regular in,
  a geometric parameter. The second theorem contains no valuation ring.
  Translating it to a simple-pole bound needs the actual one-polar-row
  logarithmic differential model, a genuine uniformizer, and regularity of
  all other coefficients. None is supplied by compilation.
* “Every valuation” in the natural description means, in Lean, “every
  element of a supplied arbitrary type.” The caller must identify the type
  with all relevant divisorial valuations and verify the function identities
  and every sign/full-support premise. The formal theorem does not itself
  verify these premises, including for non-toric valuations.

In particular, the source proves **none** of the following constructions or
bridges:

1. Complex varieties, toroidal models, modifications, canonical divisors,
   log resolutions, blowups, or their discrepancy formulae.
2. A valuation, a Cartier divisor, its evaluation, full support on all
   valuations, or existence of a klt boundary.
3. Existence/finiteness/nonemptiness of the geometric branch collection,
   rationality of its data, or attainment of its minimum.
4. Metrics, plurisubharmonic weights, semipositivity, removability, analytic
   extension, measures, integrals, or the equality of an analytic
   integrability test with the displayed discrepancy inequalities.
5. Direct images, their generic adjoint rank, curvature theorems, or any
   global anticanonical nonvanishing conclusion.

The old composite certificate's claims about a product/blowup example and
“logarithmic divergence” are not independently evaluated by its checker or
these Lean declarations. Their prose and literature assessment belongs to the
parent's other units. Their absence here is a **scope limitation**, not a
refutation of those prose arguments or an original manuscript. Similarly,
this unit does not establish a real-parameter strengthening of the rational
theorems. No new counterexample search or hypothesis construction was done.

## 6. Inspected Python checker and its non-destructive replay

`verify.py` was read in full before execution. Without
`--write-certificate`, it reads and compares the existing certificate; its only
explicit write branch is disabled. Imports are standard-library only.
Its `replay_lean()` reads historical JSON, hashes the source and fidelity text,
compares the archived source/check result, checks declaration names, and
compares the old ledger's latest claim hash. **It does not invoke Lean.**
Likewise, `replay_jacobian()` replays the historical typed polynomial output;
it does not make a new Jacobian call.

Actual replay, with working directory
`campaigns/9000068`:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python families/068/first-pass/toroidal_volume_audit/verify.py
```

Interpreter: Python **3.13.5**, packaged by Anaconda, GCC 11.2.0.
Exit **0**, duration **0.162913 s**, no stderr, no timeout. The returned JSON
reports `ok=true`, **8,820** threshold cases and **12,348** intersection-weight
cases. Its **1,764** branch pairs use `a=0..6`, `e=1..6`; five perturbation
values include the endpoint, and seven fixed nonnegative weight pairs test
positive discrepancy combinations.

These are exact finite rational checks, not universal proofs and not tests of
actual intersection valuations. The emitted `lean_exit_code=0` and
`proof_holes=[]` are historical-field checks, not fresh compilation. The
printed “Report proves geometry/analysis” is a literal label, not a computation
of a proof of the report. The literal example/novelty/classification fields in
`exact_certificate.json` are also not established by running this script.

`verify_replay_execution.json` saves the actual argv, cwd, environment,
interpreter, full concise stdout, exit, duration, and timeout information;
`verify_replay.json` saves the parsed output. No write flag was passed.

## 7. Fresh actual Lean replay

The exact **4,010 bytes** of immutable `Main.lean` were supplied directly to
stdin of:

```sh
$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean --stdin
```

Working directory:
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
`LEAN_PATH` explicitly selects the existing built Mathlib/dependency library
directories; the complete literal value is saved in
`lean_stdin_execution.json`. `PYTHONDONTWRITEBYTECODE=1` was also set.
No `.lean` file was copied or created; no output-object option was supplied.
Neither `lake` nor `lean_evidence` was invoked, avoiding builds and writes
beside the old source.

* Lean: **4.31.0**, `x86_64-unknown-linux-gnu`, Release,
  commit **`68218e876d2a38b1985b8590fff244a83c321783`**.
* Installed Mathlib revision in the workspace manifest:
  **`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`**.
  Both workspace and Mathlib package pin `leanprover/lean4:v4.31.0`.
* Status: **success**, exit **0**, duration **3.965830 s**,
  stdout/stderr empty, timeout false; subprocess deadline **100 s**.
* Stdin SHA-256 equals the retained/successful-archive source hash given above.
* `lean_toolchain.json` preserves the complete installed dependency manifest,
  executable hash, root Mathlib source/object hashes, and exact library paths.
  `lean_version_execution.json` preserves actual version output.

This is fresh compiler evidence for the old source only. It is not a Lean
proof of this review, its fidelity judgement, geometry, novelty, or acceptance.
The source contains no explicit `sorry`, `admit`, or new axiom declarations.
The old successful record includes a separate successful axiom-audit command,
whereas the failed record did not run it; those remain historical records.
No new per-theorem axiom audit was performed. The fresh run trusts the
installed Lean executable and precompiled Mathlib/dependency closure; no
independent rebuild or artifact-closure attestation was done. The revision is
reported from the installed manifest, not from a Git operation.

## 8. Fresh bounded Jacobian operation

All Jacobian module invocations used **exactly**
`$WORKSPACE/argus-live-update/.venv/bin/python`, Python **3.13.5**.
The latest interpreter only captured subprocesses; it did not import/probe
Jacobian. Status/discovery/inspection/output identify server **Jacobian
0.14.0**, protocol **`2025-11-25`**, transport **MCP stdio**.

The discovery query was
`exact symbolic determinant polynomial rational matrix coefficient`,
limited to **four** candidates:

1. `matrix.symbolic.determinant.compute`;
2. `matrix.symbolic.characteristic_polynomial.compute`;
3. `matrix.determinant.compute`;
4. `matrix.polynomial.evaluate.compute`.

The first operation fits the old coefficient/exponent identity directly.
Discovery's `NEEDS_MORE_TYPED_REQUIREMENTS` is not a computed conclusion;
the exact operation contract was subsequently inspected. No inference about
unseen catalog operations was made.

The inspected input is `SymbolicDeterminantRequest`, containing a nonempty
square `SymbolicMatrix` over `QQ` with ordered algebraically independent
variables and canonical reduced `RationalFunction` entries. The contract
allows at most eight variables and eight rows. For dimension greater than one,
entries must be polynomials and the derived expansion is bounded by 256 terms,
exponent 64, and 128-digit coefficient components. Sparse terms are ordered
descending lexicographically; rational coefficients are reduced with positive
denominators; denominators are monic. Output is
`SymbolicDeterminantResult`, with canonical rational-function `determinant`
and method `SYMPY_BAREISS`. The operation is read-only.

After inspecting this contract, the historical payload was reused
**byte-for-byte in the current writable subtree**, SHA-256
`2aa40a8dfabc10ed975f80de41ead45a8dd8b89b1e8d97bba2fa6a50dbb79f2c`.
Its ordered variables are
`[t,m1,m2,a1,a2,b1,b2]`; it encodes

```text
[[t*a1 + m1, t*a2 + m2],
 [       b1,        b2]].
```

All denominators are one, and its four-term determinant meets the inspected
bounds. This is the old symbolic subproblem, not a new geometric or analytic
request. Exactly **one** mathematical operation was executed:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.symbolic.determinant.compute --payload-file families/068/argus-review/draft_reviews/shared-formal-core/jacobian_payload.json --timeout 60
```

The actual cwd was this unit's writable directory, with
`PYTHONDONTWRITEBYTECODE=1`. Adapter exit **0**, status **success**,
timeout **false**, adapter error **null**, wall duration **3.250874 s**,
server runtime **26 ms**, and no stderr. The returned request is bound to the
exact payload and operation ID. The typed result, compared with direct
two-by-two expansion including all signs and exponent tuples, is:

```text
t*a1*b2 - t*a2*b1 + m1*b2 - m2*b1.
```

It is a polynomial with denominator one and degree one in the independent
variable `t`. This independently reproduces precisely the two-by-two
coefficient identity. It is neither the all-dimension proof nor a proof that
a geometric parameter is a uniformizer or an analytic pole has bounded order.

Dedicated JSON files preserve the raw structured status, discovery, full
typed contract, exact payload, payload binding, typed output, execution
metadata, and substantive scope assessment:
`jacobian_{status,discovery,contract,payload,payload_binding,output,assessment}.json`
and the associated `*_execution.json` files. No UNKNOWN, unavailable-operation,
or timeout conclusion was converted to mathematical support; this particular
bounded operation returned a conclusive exact symbolic result.

## 9. Attribution, remaining limitations, and evidence handling

The old authoring campaign supplied these formalizations and checker wiring.
The determinant content is classical row multilinearity, explicitly inherited
from Mathlib's `Matrix.det_updateRow_add`, `Matrix.det_updateRow_smul`, and
`Matrix.updateRow_eq_self`. The remaining content is elementary rational
max/min, positivity, and ordered-field arithmetic. Reproducing those facts
does not verify a new mathematical contribution. No priority/literature
search for a new theorem was undertaken in this bounded unit, and no novelty
or publication significance is certified. The v2 numerical monotonicity
addition and v3 proof repair do not make three independent results.

Historical `lean_check.json`, `lean_verification.json`, and `compile.log`
repeat the successful recorded run; `lean_submission.json` is only an old
submission receipt. The two old compiler certificates, old four Jacobian
files, and `exact_certificate.json` were all read, but are **review inputs,
not inherited current mechanical evidence**. Fresh observations are the
separately named replay JSON files, with subjects limited as described above.

The concrete mathematical handoffs remain the regularity/one-polar-row model,
the geometric discrepancy identifications and sign/full-support premises on
all relevant valuations, minimum attainment for the geometric data, and the
analytic/integrability/direct-image constructions. This unit leaves those to
their assigned prose-review units; it neither silently assumes they were
proved by a compiler nor declares the surrounding geometry false.

`old_inputs_before.json`, `old_inputs_after.json`, and
`immutability_check.json` confirm identical SHA-256, byte size, and mtime for
all **14** scoped old files, including both certificates. This is not a
whole-filesystem write audit. All authored/captured artifacts are in this
unit's allowed subtree. No old inputs, compiler records, ledgers, parent index,
parent unit reports, or Argus code were edited; no Git, new agents, project
acceptance, or `lean_evidence` registration was used.

All executions were synchronous and individually bounded at no more than
100 seconds. No command exceeding two minutes was attempted, so there is no
new long-command submission/run receipt to report. No unchanged validation
was retried. The bounded unit is complete; family coverage and native
independent Reviewer acceptance remain outside this unit.
