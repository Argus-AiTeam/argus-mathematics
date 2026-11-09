# 056. Termination of projective and Kähler fourfold minimal model programs.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Curve bound b<=N_T and all-place bijection for compact complex (non-Kahler) terminal fourfolds with globally projective resolution | preprints/Termination-of-generalized-log-canonical-flips-on-compact-Kahler-fourfolds-October-7-2026/build/sections/06-curve-places.tex:11 prop:curve-places (compact Kahler Y) | Baseline read; hypothesis-use audit read |
| A | DOWNGRADED | Sharpness example Y=X x P^1 (ODP quadric cone) with b=N_T=1 | same, 06-curve-places.tex:11 | Read construction; integer inequality b<=N_T |

Main files:

- [`first-pass/curve_places/report.md`](first-pass/curve_places/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
