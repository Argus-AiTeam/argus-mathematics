# 065. Virasoro constraints for complete intersections and projective-bundle towers.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Common-R localization for arbitrary rank>=2 E (no E^vee globally generated normalization) | preprints/Virasoro-Constraints-under-Projectivization-October-5-2026/build/sections/01-introduction.tex:128 'Twisting E by a sufficiently negative line bundle leaves X unchanged and makes E^* globally generated' | Checked manuscript normalization is WLOG for X=P(E) |
| A | DOWNGRADED | Uniqueness of normalized R, u_B, u_X in positive Novikov filtration | Virasoro-Constraints-under-Projectivization-October-5-2026 (simultaneous factorization, no uniqueness stated) | Read the filtered-induction argument |

Main files:

- [`first-pass/family_orbit_localization/report.md`](first-pass/family_orbit_localization/report.md)
- [`first-pass/family_orbit_localization/lean_evidence/Main.lean`](first-pass/family_orbit_localization/lean_evidence/Main.lean)
- [`first-pass/family_orbit_localization/Main.lean`](first-pass/family_orbit_localization/Main.lean)
- [`first-pass/family_orbit_localization/statement_fidelity.md`](first-pass/family_orbit_localization/statement_fidelity.md)
- [`first-pass/family_orbit_localization/lean_evidence/statement_fidelity.md`](first-pass/family_orbit_localization/lean_evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
