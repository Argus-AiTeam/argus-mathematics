# 097. The Euclidean Steinitz–Bergström bound.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Gain bound (a 2^a E)^{1/a} -> (aE)^{1/a}, all 1<a<=2, no small-budget restriction; coefficient a optimal | preprints/The-Euclidean-Steinitz-Bergstrom-theorem-September-24-2026/build/matrix.tex:411 lem:direct-gain 'c_a=a2^a, e_0=1/(16c_a), q=(c_aE)^{1/a}, V<=q(I+X)' | Random test 400 contraction/gain sequences, d<=3, a in (1,2): max trH^a/(aB_a)=0.92<=1; checked psi_a(h/(1-h))=int_0^h t^{a-1}/(1-t)dt>=h^a/a and B_a<=E (same p_1) |

Main files:

- [`first-pass/certificates/filter_increment/report.md`](first-pass/certificates/filter_increment/report.md)
- [`first-pass/certificates/filter_increment/statement_fidelity.md`](first-pass/certificates/filter_increment/statement_fidelity.md)
- [`first-pass/certificates/filter_increment/Main.lean`](first-pass/certificates/filter_increment/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
