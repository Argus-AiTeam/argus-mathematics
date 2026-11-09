# Limited Lean algebraic core

**Assessment:** the unchanged successful formal source freshly compiles with no proof holes and passes the axiom audit. Its encoded statements match the supplied document's limited algebraic scope. This does not formalize the geometric theorem, and native independent statement-fidelity approval is still pending.

## Exact declarations and fidelity

A09 is the old `lean/Main.lean`; A15 is its separate fidelity document. A01 records three versions of `C_K1_NORMAL_HYPERPLANE_CORE`. The mathematical attribution is an old Argus formalization of ingredients in OpenAI's September 24, 2026 interpolation argument, revision `4eaee87548250b2682affda7d05d947c05554bae`; it is not the original manuscript's full theorem.

| Declaration | Actual quantifiers, hypotheses and conclusion |
|---|---|
| `tangent_in_hyperplane` | Any field `K`, `K`-module `V`, linear functional `ell`, and submodule `T`; if `ker ell + T` is proper, then `T` is contained in `ker ell`. No finite dimension, nonzero-functional or characteristic-zero hypothesis is needed. |
| `logShear`, `logUnshear`, inverse lemmas and `logarithmicFrameEquiv` | For any index type `I`, vectors in `Option I -> K`, the shear sends `a` to `(y a0, a0+ai)` and its inverse sends `v` to `(vY/y, vi-vY/y)`. The linear equivalence requires `y!=0`. With finite `I`, these are exactly the displayed finite logarithmic-frame columns. |
| `logNormal`, `tangent_logarithmic_relation` | From properness of `ker(v -> vi-vY/y)+T`, every `v` in `T` satisfies `vi=vY/y`. This theorem itself does not need `y!=0`; its geometric application is on `Y!=0`. It does not turn a differential relation into algebraic constancy. |
| `largest_direction_forced` | Real-valued functions `w,v`, real `C`, finite sets `A,B`, positive index `i` in `A`, all elements of `A union B` at most `i`, and the opposing product bound/separation implication give `i in B`. Positivity and equal cardinality are not formal hypotheses because their role is to establish the supplied inequalities geometrically. |
| `wins_total`, `unique_positive_basis_family` | Distinct finite sets of positive indices are ordered by their largest differing index. In a supplied finite family of such sets, all-pairs product bounds and separations force every pair equal. This proves neither existence of a family nor that its members are actual normal bases; an empty family is vacuous. |

These statements were read against the full source, not inferred from successful compilation. A15 correctly identifies the unencoded span identification, quotient-basis extraction, analytic persistence, Bezout, complete curves, residues, ampleness and interpolation. For example, the source never proves that an algebraic variety with `dXi=dY/Y` has constant `Y`. The normal-basis report supplies that separate characteristic-zero argument.

## Historical certificates are not two results

A11, certificate `...-e5688bbe37a65274.json`, records an earlier **type-error**, exit 1, on a different source. Its unresolved elaboration generated `sorryAx` in printed provisional declarations, despite the lexical `proof_holes` list being empty. That record supplies no proof and is not evidence against the mathematical statements.

A10, certificate `...-771db3cefabd4d28.json`, and A13 `lean_check.json` record the later source's successful compiler and audit, exit 0. The old source's successful digest is `47cb294a5bba696e529b366a270ffc3516b783934ac90cd0e0558d3796a1cc98`; the fidelity digest is `47f732f71e2f215e65c97d6f4cc9150b21bfb37074f134ae4eb4e7e9e0c09d68`. A12 is its compiler log. A14 is a historical submitted runner receipt, not a compiler verdict. The full old ledger records two mechanical entries among its evidence; version and source binding matter, not certificate count.

## Fresh real run

Only the exact source and fidelity document were copied into the current unit's [replay directory](replay/). No old file or certificate was edited, no old snapshot was rebuilt, and no lakefile was created. The copied source and fidelity were left unchanged throughout verification.

The fidelity copy retains its historical `../REPORT.md` references to A04; those are references to the old dossier, not claims that this replay directory contains a new geometric proof. The current unit reports give the actual review links without rewriting the already-correct declaration descriptions or their compiler binding.

The prescribed Argus-latest `lean_evidence verify` command used `--claim C_K1_NORMAL_HYPERPLANE_CORE`, the exact campaign root, and an owned artifact directory. It was submitted through the durable direct runner with one CPU and an explicit 900-second outer limit / 600-second compiler limit. [The receipt](replay/runner-receipt.json) preserves:

    state=submitted
    task_id=family017-lean-core-replay
    run_id=family017-lean-core-replay-1794069509075281893

The subsequent status was `done`, exit **0**, elapsed 16.6 seconds, not a timeout or a lost process. [lean_check.json](replay/lean_check.json) records a real Lean **4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`, Lake `5.0.0-src+68218e8`, elan `4.2.3`, using the existing `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0` workspace. Compile and audit exit codes are both 0, `proof_holes=[]`, and there is no `sorryAx`. The ordinary foundations printed are `propext`, `Classical.choice`, and `Quot.sound`; this is not a claim of an axiom-free development. Nonfatal tactic/linter warnings remain unchanged.

The fresh [certificate](replay/certificates/C_K1_NORMAL_HYPERPLANE_CORE-c2b0f77b9154d779.json) is recorded as mechanical evidence on the **current** claim. Its source/fidelity digests match the old successful pair. No source or fidelity edit has followed the run.

## Verdict boundary

This is formal verification of the declarations above. The source-to-natural-statement reading is an Engineer assessment, not a compiler output; the current mechanical record reports `verified_by=null` for statement fidelity. Native independent approval remains required. The successful run does not certify multiplicity, curves, the density extension, the jet bridge, determinant estimates, or the final irrationality theorem.
