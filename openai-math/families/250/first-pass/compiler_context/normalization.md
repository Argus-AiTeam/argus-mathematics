# Compiler normalization: parametric proof and three formal certificates

The target is the **specified evaluator** in `build/compiler.tex`, not the
existence of some alternative machine presentation. The budget hypotheses are
exactly `eq:budget-total` and `eq:budget-context` in `build/bootstrap.tex`.
No reversibility, clean-input restriction, or global totality is added.

The ledger initially contained no previous mathematical result. Searching the
inherited wiki index found no compiler-specific result. The argument below
uses only elementary list identities and the two stated budget hypotheses;
the historical Post and Murskii citations are not assumptions of this argument.

Let a token be either a raw payload in `Sigma*` or an arbitrary barrier.
Barriers represent preprocessed sectors that are not full raw sectors, including
sectors with missing boundaries or dirty tags. A raw token has grade
`3 + |payload|`; a barrier may have any nonnegative grade.

Put `u * v = f(uv)`. Whenever `|uvw| <= m`, the budget identity gives

    f(u f(vw)) = f(uvw) = f(f(uv) w).

Thus `*` is associative **within the original payload budget**, without
requiring individual raw payloads to be fixed by `f`. This last qualification
matters: the manuscript fixes every raw singleton literally, even if its
payload is not an `f`-normal form.

Normalize a token list from right to left, merging two adjacent raw tokens by
`*` and leaving barriers intact. On a run of at least two raw tokens this is
the manuscript's single call on the concatenated payload; on a singleton it
does not call `f`. The bounded associativity identity proves invariance under
an adjacent-raw contraction in every token context.

This algebra does not by itself certify the compiler. To apply it to arbitrary
presentation words one must additionally establish the actual scan program's
semantics, uniqueness and correctness of component entries, and the bridge
from every contextual presentation equation to identical preprocessing or an
adjacent-raw contraction. The continuation supplies that ordinary proof in
[`compiler_theorem.md`](compiler_theorem.md), retaining the source-translation
boundary explicitly rather than calling a generic theorem a formalized compiler.

## Parametric certificates

`Main.lean` proves the raw-run theorem for arbitrary alphabets, barrier sets,
payloads, and budgets, not a bounded sample. It proves call safety, derivations
to the answer, elementary and accumulated grade nonincrease, the source's
one-call rule for maximal raw runs, and two-sided contextual compatibility.
It preserves every singleton literally, even if its payload is not fixed by `f`.

`Preprocess.lean` separately proves equality of literal preprocessing outputs
for every raw-slide, quota-insertion, merge, and cleanup equation. Both outer
boundaries are optional. Dirty tags retain arbitrary decorations and output
marks, and every cell context is universally quantified. Thus the certificate
is not restricted to clean inputs, reversible machines, or a fixed cell bound.
The elementary grade equalities check that unmerge exchanges grade
`2 + 1 + 1` for `1 + 1 + 1 + 1`; clean workspace insertion has grade zero.
Cleanup emits a grade-one letter only from a grade-one anchor and deletes all
other left cells. All intermediate preprocessing steps therefore stay in grade.

For clarity, the primitive equalities have the following direct proofs.
Sliding a clean anchor across a raw head changes only the first recursive
step of its leftward normalization. Inserting a workspace cell changes only
the number of immediately preceding clean workspace cells trimmed from a
quota head. A merge creates a clean first cut immediately left of the quota
head and a clean second cut immediately right; quota preprocessing immediately
undoes it, before any possible raw slides. No outer boundary or tag condition
is needed for that argument. Cleanup is a deterministic left fold: its next
step either emits the clean output-mark letter of an anchor or emits nothing.
The two sides of each cleanup equation have the same continuation of that
fold. At the left boundary the final raw head is already at its leftmost gap.

Both sources compiled with Lean 4.31.0, compiler and axiom-audit exit code zero,
and no proof holes. Their separate fidelity documents state their exact scope.
Independent Reviewer replay and statement-fidelity review supported both
`C_COMPILER_RUN_ALGEBRA` and `C_COMPILER_PRIMITIVE_PREPROCESS` on
2026-11-05. Neither certificate alone proves `C_COMPILER_CONTEXT`.

The continuation adds `CompilerProof.lean` and its own fidelity document.
Its exact validator, scan lemmas, copy/output array lemmas, arbitrary-table
bounded pipeline theorems, component-entry criterion, and original-word
context transport compiled with Lean 4.31.0, compiler and axiom-audit exit code
zero and no proof holes. The claim is `C_COMPILER_EXECUTION_THEOREMS`.
`compiler_theorem.md` gives the full source-specific composition argument,
including the actual scan invariants, failed-entry chains, successful exit,
zero/nonpaths, and all equation families.

## Independent budget checks for the diagnostic programs

The finite experiments use two chosen letters of the manuscript's alphabet;
they do not replace that alphabet with a smaller one in the claimed theorem.
Each diagnostic function extends to the full alphabet and satisfies the
budget at every integer, for reasons independent of the experiments:

- The identity and constant-empty functions satisfy both identities directly.
- Deleting one chosen letter is an idempotent monoid endomorphism. Consequently
  `f(x f(w) y) = f(x) f(f(w)) f(y) = f(x) f(w) f(y) = f(xwy)`.
- Length parity sends an even-length word to the empty word and an odd-length
  word to one fixed letter. Its output length is at most its input length and
  is congruent to it modulo two, so replacement in any context preserves the
  output.

Reversal is a deliberate inadmissible control: on a two-letter word `ab`,
`f(f(ab)) = ab` differs from `f(ab) = ba`. Its failure is not a manuscript
counterexample.

## Bounded adversarial measurements

The standalone command is `python3 research/compiler_context/verify.py`.
It checks freshness of the archived Lean certificates and replays the
deterministic experiments recorded in `exact_certificate.json`.

The validator experiment checks 545,688 configurations and 90,948 transitions
with at most four cells, all head gaps and all four boundary choices. Its
clean/nonclean tag quotient is exact for validator predicates, and it finds
9,028 entries, of which ten pass. Every tested passing entry is exactly in the
stated clean language. The experiment excludes all transitions after handoff
to `q_start`; it says nothing about complete internal weak components.

The primitive experiment checks 398,892 graded preprocessing inputs and
263,978 contextual equation instances using at most three original cells.
Its exact per-rule counts are in the certificate. These are diagnostics in
addition to, not replacements for, the universal primitive Lean theorem.
The raw experiment checks 6,220 token lists, 12,100 adjacent-raw contractions,
and 67,522 equal-output contextual comparisons for the four admissible maps.
No witness was found in these declared finite spaces.

The Jacobian adapter's `smt.solve` query was rejected before solving:
`declare-sort` was not admitted by its SMT-LIB validator. The exact payload,
typed contract, structured error, protocol, server version, and exit status
are preserved in dedicated JSON files. This is a tooling non-conclusion;
the successful Lean proof, not that error, establishes bounded associativity.

## Continuation and remaining review boundary

No false manuscript assertion has been established, so no `F_` refutation
claim has been invented. In particular the bounded validator experiment is
not a proof of `lem:compiler-components`.

The prior checkpoint lacked a scan/component and successful-exit proof.
The new source-specific argument is sections 1--8 of `compiler_theorem.md`,
not an extrapolation from the finite measurements. Its correspondence between
physical interleaved scans and the formal rank-level pipeline remains a
human-checked source-fidelity step. Likewise the literal word evaluator itself
is not a definition in Lean; the formal original-word transport theorem states
its input obligations explicitly. The certificate records those boundaries.

The new complete ordinary parametric proof is submitted for independent review,
not asserted to be a fully kernel-closed literal compiler or a verified novelty.
The two earlier subclaims retain their independent support. No acceptance
verdict is inherited from them for the new composition argument.

`scan_runtime.py` implements the actual finite local table with all five tag
fields, arbitrary supplied deterministic source tables, missing boundaries,
and correctly signalled resource limits. Its 19 deterministic tests cover
successful and failed pipelines, reverse local edges, full dirty-tag variants,
and comparison to an independent ordinary-tape interpreter. They are additional
diagnostics, not universal proofs.

The Boone--Higman and simple higher-finiteness papers use this compiler.
No conclusion about either main theorem or the independent universal-group
construction is asserted here. Publication-level significance and novelty
remain for independent review.
