# Downstream ledger obligations, not established results

**Assessment:** the old dossier contains six substantive downstream assertions without a corresponding Argus proof. Their mathematical truth remains unresolved by this work. They must not disappear from coverage, and the interpolation certificates cannot be relabelled as evidence for them.

## Exact assertions as recorded

These are A01 claim statements, with dependencies also projected in A03. Their reference is OpenAI's September 24, 2026 manuscript, revision `4eaee87548250b2682affda7d05d947c05554bae`; the original determinant/series/conclusion sources are reference material, not additional old Argus verification drafts.

| Old claim | Statement scope and unresolved obligation |
|---|---|
| `C_MAIN_017` | `For every real nu>2`, there is a threshold `Q(nu)` such that for all integers `q>=Q(nu)` and **all integers p**, `abs(pi-p/q)>=q^(-nu)`. The dossier provides no completed downstream contradiction proof of this quantified assertion. |
| `C_PARAMETERS_017` | For each `nu>2`, successive dimension, approximation and weight choices satisfy all interpolation/determinant hypotheses with a strict contradiction margin. The recorded statement is a label-scoped compatibility obligation, not a supplied numerical construction or proof. |
| `C_DET_ARITHMETIC` | An interpolation-supplied full-row minor yields the manuscript's `det:lower` after Gaussian-integer denominator clearing. The dossier has no independent denominator bookkeeping and quantitative lower-bound derivation. |
| `C_DET_TRANSLATION` | The exact row-translation identity and scalar bounds hold for **every** determinant row. No independent identity/constant-bound argument is supplied for those rows. |
| `C_DET_COLLISION` | The collision estimate gives the analytic determinant upper bound with its stated simultaneous parameter dependence. No checked collision or quantitative uniformity estimate is included in this dossier. |
| `C_DET_COMPARISON` | Arithmetic and analytic determinant bounds contradict each other under `det:contradiction-conditions`. The compatibility and strict inequality comparison are unproved here. |

The last five are stated by reference to the manuscript's conditions rather than as fully quantified numerical formulas in an old Argus proof. This assessment exposes that limitation instead of inventing missing constants or hypotheses. It does not silently replace the claim by a convenient weaker theorem.

## Why the existing support does not discharge them

The old dependency graph makes the boundary concrete. Arithmetic depends on interpolation; collision depends on translation; comparison depends on interpolation, arithmetic, translation and collision; the final claim depends on comparison and parameter selection. None of those additional obligations is a consequence of the local algebraic Lean declarations.

Surjectivity provides an appropriate nonzero minor, not by itself a quantitative Gaussian-integer denominator lower bound. The exact polynomial-curve examples supply no analytic estimate for translated determinant rows. A weighted rank identity cannot bound a colliding determinant's size. Even separately valid lower and upper estimates require parameters satisfying all their hypotheses with strict margin before they yield a contradiction for every `nu>2`.

These are identifiable missing arguments, not a claim that a source is inaccessible or that an execution failed. The original source manuscript is available through the supplied reference manifest even though the old staged reference-input directory is empty. Its own arguments might or might not settle the assertions; auditing them would be a new commissioned task, not completion of this old interpolation-dossier review.

## Evidence-linked verdict

The full old ledger leaves these as open obligations, but that status alone is not the reason for this assessment. The positive certificates were inspected: A09 encodes only hyperplane/shear/finite-set algebra; A29 checks only the listed examples, obstruction and historical formal bindings; A04 expressly excludes determinant estimates and the final irrationality theorem. Their actual mathematical contents do not supply any of the missing downstream steps above.

Current claim `C_DOWNSTREAM_BOUNDARY_017` records this support limitation, not a claim that the final theorem is false. No `refutes` judgement is filed against an original manuscript assertion. No new counterexample search, parameter repair, or formalization of the final theorem has been undertaken. All six assertions are included in this unit and in the family summary; none is counted as a verified contribution.

Native independent Reviewer acceptance of this **review classification** remains required. The final irrationality theorem and the downstream quantitative obligations remain honestly unresolved by the supplied old Argus work.
