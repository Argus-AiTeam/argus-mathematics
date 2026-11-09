# 259. A group without fixed price.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Planar word lemma: m(r)>=7 weakened to m(r)>=4, intervals m(r)-3 improved to m(r)-2 (optimal), injectivity H->D proved automatic; threshold 3 fails | preprints/A-group-without-fixed-price-October-5-2026/build/planar.tex:30-52 (planar:main: "m(r)>=7 exterior occurrences... Suppose that the natural map H->D is injective... at least m(r)-3 exterior occurrences") | Re-derived the (4,4)-map curvature count: face weight <=2l-4 cases, sum_inner(4-C(v))>=4, and the gap-cost classification giving t>=m(v)-2; checked Euler contradiction for automatic injectivity (4V<=2E, 4F<=2E). Python check ((check script)) of the sharpness family r0..r3, W=A0^-1A1A2^-1A3 for m=4..7: W freely reduces to 1 after substitution, relators share <=1 generator, sign-constant blocks of length exactly m-2. |

Main files:

- [`first-pass/planar-audit/theorem.md`](first-pass/planar-audit/theorem.md)
- [`first-pass/planar-audit/lean-evidence/Main.lean`](first-pass/planar-audit/lean-evidence/Main.lean)
- [`first-pass/planar-audit/Main.lean`](first-pass/planar-audit/Main.lean)
- [`first-pass/planar-audit/statement_fidelity.md`](first-pass/planar-audit/statement_fidelity.md)
- [`first-pass/planar-audit/lean-evidence/statement_fidelity.md`](first-pass/planar-audit/lean-evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
