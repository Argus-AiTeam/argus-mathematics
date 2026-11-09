# 035. Log-canonical threefold abundance in numerical dimension one.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Exact affine-alternating width tail (offset stabilizes; d_{E+n+1}+d_{E+n}+c=M_E p^{n+1}; alternating K) instead of only lim d_e/M_e=p/(p+1); rank saturation for k<p lists; p=k=2 sharpness | openai-math/preprints/Abundance-in-numerical-dimension-one-for-terminal-threefolds-in-positive-characteristic-September-24-2026/build/sections/jets.tex:626-631 prop:scalar-widths 'a_*=lim d_e/M_e = p/(p+1)'; proof 714-748 uses only the first congruence from eq:residue-swap | Read manuscript proof; checked that the second swapped congruence follows from eq:residue-swap, that subtraction gives M_{e+1} \| (eps_{e+1}-eps_e) hence eventual constancy, and verified K_{n+1}=-K_n algebraically; Lean Main.lean exit 0, no sorry |

Main files:

- [`first-pass/scalar_jet_rigidity/proof.md`](first-pass/scalar_jet_rigidity/proof.md)
- [`first-pass/scalar_jet_rigidity/Main.lean`](first-pass/scalar_jet_rigidity/Main.lean)
- [`first-pass/scalar_jet_rigidity/statement_fidelity.md`](first-pass/scalar_jet_rigidity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
