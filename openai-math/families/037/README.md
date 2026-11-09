# 037. The ordinary-double-point volume gap.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Adjoint lifting (Taylor-initial lifting) for arbitrary M with M-K_B-tL nef, rational t>0, without -K_B=rL | openai-math/preprints/The-ordinary-double-point-gap-in-every-dimension-September-24-2026/build/sections/05-adjoint-semigroup.tex:106-112 lem adj:implication '(j,alpha) in Lambda, (j,alpha)+c_0 in Int K => (j,alpha) in Gamma' under standing hypothesis -K_B=rL (l.7), c_0=(r,1) | Compared statements; checked specialization M=jL, t=j+r recovers manuscript lemma; read the separation/weight step (same as manuscript l.122-146); vanishing input (KV for nef+big) not independently rechecked |

Main files:

- [`first-pass/adjoint_jet_lifting/report.md`](first-pass/adjoint_jet_lifting/report.md)
- [`first-pass/adjoint_jet_lifting/statement_fidelity.md`](first-pass/adjoint_jet_lifting/statement_fidelity.md)
- [`first-pass/adjoint_jet_lifting/Main.lean`](first-pass/adjoint_jet_lifting/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
