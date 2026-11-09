# 066. Bounded klt complements for Fano contractions.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Common rational threshold for compact family of rational eta (uniform exact realization) | preprints/Bounded-klt-complements-for-Fano-contractions-September-25-2026 / Uniform-Cartier-sections-for-Fano-type-contractions-September-25-2026 (rational exact realization, per eta) | Read argument summary (uniform constants on fixed sublevel set) |
| A | CONFIRMED | Monomial sharpness family on smooth surface: loss m*q necessary; uniform o(e) fails (ratio->2) | same manuscripts (degree-linear logarithmic jet loss) | Rechecked by hand: v_q weights (1,1+q) in (x,y-x): A=2+q, v(xy)=2, e=q, vol=1/(1+q), excess m*q, normalized ratio (2+q)->2 |

Main files:

- [`first-pass/lc-slice-audit/statement_fidelity.md`](first-pass/lc-slice-audit/statement_fidelity.md)
- [`first-pass/lc-slice-audit/Main.lean`](first-pass/lc-slice-audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
