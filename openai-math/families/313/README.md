# 313. Finite generation for the $`K(n)`$-local sphere.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | d successive p-power restrictions kill the degree-d forgetting kernel: a common subgroup over any char-p field | Finite-generation-for-the-Kn-local-sphere-September-24-2026/build/sections/10-pro-transfer.tex:681 lem:pro-high-transfer (qualitative shrinking) | Read the key step: restriction H^a(U_b,k)->H^a(U_b^p,k) is zero for a>0 (H^1 kills p-th powers, plus cup-generation by H^1 for uniform/equi-p-valued groups, Lazard), then a filtration shift giving j steps. The argument is standard and reads correctly. No Lean. |

Main files:

- [`first-pass/finite_level_transfer/proof.md`](first-pass/finite_level_transfer/proof.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
