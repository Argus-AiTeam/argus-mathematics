# 017. The irrationality exponent of <i>π</i> is 2.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | REJECTED | Normal-basis multiplicity bound with coefficient k! instead of 2k! | openai-math/preprints/The-irrationality-exponent-of-pi-is-2-September-24-2026/build/sections/interpolation.tex:94 '<= 2k! eps^{-k} prod kappa_b' and :129-134 'In fact the factor 1/2 can be omitted: the simplex ... is covered by the disjoint half-open unit cubes ... Its volume is (eps N)^k/(k! prod kappa_b)' | Read manuscript lines 94-140. |
| A | PLAUSIBLE | Interpolation with center-independent weights under occupancy bounds n_T theta^{\|T\|}<1 (collisions, several Y-fibers allowed) plus matching overcrowding obstruction | openai-math/preprints/The-irrationality-exponent-of-pi-is-2-September-24-2026/build/sections/interpolation.tex:23-45 geom:interpolation 'K theta^m<1, K w0/v0 theta^m<1 ... points a_j=(1,c_j1,...,c_jm) whose coordinates ... are pairwise distinct for each i' | Checked the necessity dimension count (target packets ~ n theta^d H^d/(d! prod w_i) vs source H^d/(d! prod w_i)); sufficiency descent argument read, not independently checked. |

Main files:

- [`first-pass/interpolation-audit/REPORT.md`](first-pass/interpolation-audit/REPORT.md)
- [`first-pass/interpolation-audit/lean/Main.lean`](first-pass/interpolation-audit/lean/Main.lean)
- [`first-pass/interpolation-audit/lean/statement_fidelity.md`](first-pass/interpolation-audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
