# Universal finite recovery and closed endpoint restriction

**Engineer unit assessment:** `supported_in_stated_scope` for the corrected
**C_RECOVERY_CORE version 2**. Version 1 genuinely failed elaboration; this was
a corrected formalization defect, not a mathematical refutation.
Research target: **exploratory**. This unit assessment is complete;
the native Host-invoked Reviewer accepted it as part of the complete
**bounded substantive review**, recorded in
[`round-0001.json`]($WORKSPACE/.argus-campaign-9200024/projects/245cf7797dc6/handoffs/22092fed6282/round-0001.json).
That acceptance is not final project delivery; the corrected review is returned
to the Host for final disposition. Novelty is **not verified**.

## Exact declarations and their hypotheses

The actual source is the read-only
`9000024/research/prefix-collisions/Main.lean`, SHA-256
`abdbbc98ef6b1b1f91a655cc552f883f6a2fa7cef5626eafa10e902cddc2aa26`.
The accompanying fidelity document has SHA-256
`20aac111f039cc94129023a3cdc3cbcc3423a078c476a9706baa385b96054bd6`.
I read the declarations and their proofs, not just the compiler summaries.
The old ledger records the following unchanged natural statement: for arbitrary
natural \(k\) and nonzero \(n\), the defined factorization set is exactly the
ordered natural-number \(k\)-tuples of total product \(n\), bounded by
\(k^{\Omega(n)}\); the product of two recovery sets has the corresponding common
slot bound; ordered unequal collision pairs are monotone under closed endpoint
restriction.

In the source, for \(k\in\mathbb N\) and an arbitrary finite list `ps` of natural
numbers, `allocations k ps` is a `Finset (Fin k → ℕ)`. Its empty-list case is the
singleton function whose coordinates are all 1. Its cons case takes the union,
over each labeled slot \(j\), of the images obtained by multiplying that
coordinate by the new list entry. The formal declarations establish:

* `prod_update_mul`: multiplying one selected coordinate by \(p\) multiplies
  the total finite product by \(p\). It requires an actual `j : Fin k` and
  otherwise permits arbitrary natural \(p\) and coordinate values.
* `card_allocations_le`: for **all natural \(k\)** and **all lists `ps`**,
  the allocation set has cardinality at most \(k^{\text{length(ps)}}\).
* `allocations_sound`: membership implies total product `ps.prod`, without
  requiring the list entries to be prime.
* `allocations_complete`: conversely, **if every list entry is prime**, every
  function with total product `ps.prod` belongs to the allocation set.
* `factorizations k n` is `allocations k n.primeFactorsList`, retaining prime
  multiplicities. `mem_factorizations_iff` states, for **\(n\ne0\)** and any
  function \(f:\mathrm{Fin}(k)\to\mathbb N\),
  \[
    f\in\operatorname{factorizations}(k,n)
       \iff \prod_a f(a)=n.
  \]
* `ordered_factorizations_bound` bounds the **defined finite set** for all
  natural \(k,n\), by \(k^{\text{length}(n.\mathrm{primeFactorsList})}\).
  For \(n>0\) the exponent is \(\Omega(n)\). At **\(n=0\)** this remains only
  a statement about that defined finite object: no equivalence with all
  zero-product tuples is proved.
* `two_residuals_bound` states, for arbitrary natural \(k_1,k_2,k,n,n'\) with
  **\(k_1\le k\), \(k_2\le k\)**,
  \[
  \#\bigl(\operatorname{factorizations}(k_1,n)
        \times\operatorname{factorizations}(k_2,n')\bigr)
   \le k^{\text{length}(n.\mathrm{primeFactorsList})
                   +\text{length}(n'.\mathrm{primeFactorsList})}.
  \]
  These are Cartesian pairs, not the union of the two sets. The formal finite
  set bound does not require nonzero residuals; its interpretation as **all
  multiplicative factorizations** requires **both \(n\ne0\) and \(n'\ne0\)**.

For positive total product every coordinate is positive; an assumed zero
coordinate would make the product zero. There is no upper bound on \(k\), list
length, multiplicities or residual size.

### Empty-slot boundary

For **\(k=0\)** there is exactly one function on `Fin 0`, the empty tuple, whose
product is **1**. The nonzero-\(n\) membership equivalence therefore includes it
for **\(n=1\)** and excludes it for **\(n>1\)**. More generally \(n=1\) has only
the all-ones tuple for any \(k\), with zero prime occurrences. Natural powers
use \(k^0=1\), including \(0^0=1\). Thus neither a hidden positive-slot
hypothesis nor a missing \(n=1\) exception is necessary. The Python diagnostics
in the other unit do not test \(k=0\); this conclusion is from the universal
declarations and the empty-product interpretation.

## Why the recovery proof is sufficient

The cardinal induction uses the cardinality of a union of \(k\) images, each
image having cardinality at most the previous allocation set's cardinality.
It gives \(k\cdot k^{|\mathrm{ps}|}=k^{|\mathrm{ps}|+1}\). Image/union collisions
can only decrease the count. Empty slots have product 1.

List positions represent **labeled occurrences**, including separate
occurrences of an equal prime; the slot indices are **labeled coordinates**.
After forming coordinate products, `Finset.image` and `biUnion` collapse
duplicate resulting tuples. The source never assumes squarefreeness and never
counts repeated-prime assignments as distinct output tuples. This is why an
upper bound by occurrence assignments is valid without being an exact equality.

Soundness follows from `prod_update_mul` and induction. For completeness,
the empty-list product 1 forces each coordinate to divide 1, hence to equal 1.
In the cons case, primality of \(p\) and divisibility of the total product give
a coordinate divisible by \(p\), by the prime-divides-finite-product theorem.
Write its value as \(p z\), replace it by \(z\), and use the update-product
identity. Cancelling **the positive prime \(p\)** yields the product of the
remaining list. Induction supplies the smaller allocation and then restores the
selected occurrence. This extracts one occurrence at a time and works with
arbitrary repetition. These actual proofs establish the needed converse, not
merely the easy soundness direction.

The two-residual proof multiplies the two cardinal bounds, raises their bases
from \(k_1,k_2\) to \(k\) with their explicit natural exponents, and uses
\(k^a k^b=k^{a+b}\). It does not identify two different tail reconstructions
or assume their residuals coprime.

## Collision and endpoint fidelity

`collisionPairs T F` filters \(T\times T\) by
\[
   a\ne b\quad\text{and}\quad F(a)=F(b).
\]
Here \(T\) is finite, the two types have decidable equality, and \(F\) is an
**arbitrary value function**. Pairs are **ordered**; the diagonal is excluded.
There is no quotient by reversal and no injectivity or monotonicity assumption
on \(F\).

`collisionPairs_mono` proves set inclusion when \(U\subseteq T\), retaining the
same value function. `endpoint_restriction_bound`, for a **linearly ordered**
value type, specializes this to the **closed** restriction \(F(a)\le t\) and
then applies finite-set cardinal monotonicity. Its order assumption also
provides value decidability; it applies to reals but is not specific to reals.

The fidelity document accurately separates these declarations from two
**prose application obligations**: (1) injecting source-specific pairs of
missing tuple tails into the two factorization sets, including recovering prime
entries from their shifts by adding 1; and (2) identifying
\(\mathcal G(x/c)\) with the restriction of \(\mathcal G(x)\) by
\(F\le x/c\), with **all other parameters still formed from \(x\)**.
Neither source tuple structures nor `G(t)` are defined in this Lean source.
Generic finite monotonicity does not establish membership invariance when
parameters are recomputed at a different endpoint. Those applications belong
to the parent's analytic unit, which this report does not assess.

## Version-specific historical evidence and index corrections

Historical `C_RECOVERY_CORE` version 1 has claim content hash
`60df0c479ee0b44652955e17df50813a03548762f460919f488749d975afb780`;
its embedded source SHA-256 is
`1693985429090be789fdeed961696a1371baf53bfa714e319c572044b7c0081e`.
Version 2 has claim content hash
`86f6988bb079e5ab767d414b14836fe016945b6b3d3e66ddcce7cea8b29c39eb`
and the current source hash quoted above. Both embed the same fidelity document.
The source diff changes only the two uses of `Nat.pow_le_pow_left`, supplying
`n.primeFactorsList.length` and `n'.primeFactorsList.length` explicitly.
In version 1 those expressions had function type
`∀ i : ℕ, k₁^i ≤ k^i` rather than the particular inequality required by
`LE.le.trans`. The archived compiler genuinely reported two application type
errors and **exit 1**. Its empty `proof_holes` list did not make it a successful
proof; its axiom audit was not run.

The historical records bind as follows:

| Artifact | Actual source/version binding |
|---|---|
| `C_RECOVERY_CORE-2c1aeabdc5dc640e.json` | Exact version-1 text/hash and subject; `type_error`, exit 1, mechanical `inconclusive`. |
| `C_RECOVERY_CORE-3bad1558c8a1cd6a.json` | Exact corrected version-2 text/hash and subject; compiler and audit exit 0, mechanical `supports`. |
| `lean_check.json` | Corrected version-2 source/fidelity hashes and successful result. |
| `lean_verification.json` | **Corrected version 2**, not version 1: successful source hash and kernel record pointing to the `3bad...` certificate and version-2 claim hash. |
| `compile.log` | **Successful** compiler and audit transcript consistent with corrected version 2, not the failed attempt. It has no source hash of its own and is not a standalone cryptographic source binding. |
| `compiler_receipt_1.json` | Submission-only receipt for task `prefix-core-compile-1`, run `prefix-core-compile-1-1793910576625907828`. It contains no command, source hash, compiler exit or completion result; its filename/task suffix does **not** establish formalization version 1. Version/result attribution from this receipt alone is unresolved. |

**Historical parent-index correction instructions (already applied):**
change the role of `compile.log` from
`superseded_compiler_failure_log` to a successful corrected-version transcript;
change `lean_verification.json` from `historical_version_1_verification_summary`
to a source-bound version-2 successful verification summary. Retain
`compiler_receipt_1.json` as historical execution metadata but make its
submission-only, source-version-unbound limitation explicit. I did **not**
modify the shared index or replay the failed version.

The retired route `R_RECOVERY_CORE` cites version 1; the corrected
`R_RECOVERY_CORE_CURRENT` cites version 2. Their historical retirement
explanation agrees with the source diff. Historical opinion
`judgement-C_RECOVERY_CORE-a50b7deef191`, by `reviewer:copilot-math`, is bound to
the version-2 claim hash and `3bad...` certificate. The current text, fidelity
and empty external-assumption list match, so the opinion is useful historical
corroboration, not this mission's independent acceptance. The source is an old
Argus formalization of elementary finite counting, not a novel result or a
refutation of the original manuscript.

## Fresh official replay and actual toolchain

The active ledger's `RV_FORMAL` claim already held the exact current source
text in `CTX_OLD_DRAFT_REVIEW`. I verified that text binding before launching:

```text
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify families/024/first-pass/prefix-collisions/Main.lean --statement-fidelity families/024/first-pass/prefix-collisions/statement_fidelity.md --artifact-dir families/024/argus-review/draft_reviews/finite-recovery-endpoints/lean --claim RV_FORMAL --project-root campaigns/9200024 --timeout 300
```

The current tools were re-probed first. The command was submitted using the
prescribed **direct-mode durable Argus runner**, timeout **360 seconds**, task
`family024-old-drafts-lean-core`, run
`family024-old-drafts-lean-core-1794070181261729018`. Submission, exact-task
status and terminal wait receipts are preserved. The run was reclaimed as
**done**, command **exit 0**, elapsed **15.5 seconds**; terminal status reports
`live:false`. No long run remains unreclaimed.

The official verifier, not a hand-edited proof copy, created canonical source
and fidelity copies inside `lean/`. Fresh `lean/lean_check.json` and compiler
certificate `lean/certificates/RV_FORMAL-4126d54d056488cb.json` report:

* **status `success`; compiler exit 0; axiom-audit exit 0; `proof_holes: []`;**
  empty compiler/audit stderr and no environment failure; duration **15276 ms**.
* Lean **4.31.0**, release commit
  **68218e876d2a38b1985b8590fff244a83c321783**.
* Lake **5.0.0-src+68218e8 (Lean version 4.31.0)**; elan **4.2.3**.
* Actual `lake env lean` working directory/library workspace:
  **`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`**.
* Exactly the current source and fidelity hashes above, also matching the
  embedded certificate texts.

The trusted basis is Lean's kernel and the imported Mathlib environment,
including the source's classical finite-set reasoning. This source introduces
no custom analytic axioms. The certificate records a Mathlib workspace path,
**not an independently hashed Mathlib source tree or dependency revision**;
no Git access was used to manufacture a stronger binding.

The official ledger write is mechanical evidence
`lean-RV_FORMAL-4896048cc177`, subject content hash
`1412ec7fe8e2e17304ad96e9cdaab2ce2be82dd1bd8111c37afb9e0bae127b88`,
verdict `supports`. The kernel receipt itself leaves
statement-fidelity `verified_by:null`; it does not assert independent natural-
statement acceptance. The substantive fidelity assessment is the declaration
analysis above. All manual writes are confined to the two owned units. The
prescribed runner receipt additionally reports its standard
`.argus_subagents/...` registry log paths; no registry edits, cleanup or
historical-run status queries were made.

## Post-write gates, obligations and conclusion

After the real mechanical write I ran **both** official checks using
`$WORKSPACE/argus-latest/.venv/bin/python`, with explicit project root
`campaigns/9200024`:

* `argus_skill.verticals.math.math_state check`: **exit 0**,
  `{"ok":true,"issues":[]}`.
* `argus_skill.verticals.math.proof_graph_check check`: **exit 2**, stderr
  `no proof graph at families/024/argus-review/PROOF_GRAPH.json`.

Root, exits and outputs are preserved in dedicated gate files. No graph was
created or changed, and the failing gate is not reported as passed. The
exploratory mission's bounded substantive review has native acceptance in the
record cited above; these preserved historical diagnostics are nonblocking
under `OBJECTIVE.md`, which imposes no active-graph requirement here.

There is no identified mathematical gap in the corrected universal finite
declarations under the hypotheses above. The initial incomplete formal proof
was genuinely repaired and its current source successfully replayed. The
source-specific injection, endpoint membership identity and complete analytic
transfer remain outside these declarations and outside this unit's assessment.
The missing active graph remains a failed historical diagnostic, not a delivery
blocker for the accepted bounded review. No final project delivery is claimed;
this corrected report is returned to the Host for final disposition.
