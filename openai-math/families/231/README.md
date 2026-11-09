# 231. The free uniform spanning forest is a factor of IID.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Every strongly Rayleigh law on {0,1}^I (countable I) is a Borel FIID equivariant under its full permutation stabilizer; NA/uniform-response criterion | openai-math/preprints/The-free-uniform-spanning-forest-is-a-factor-of-IID-September-25-2026/build/sections/introduction.tex:102-115 thm:sr-group (regular left action of a countable group only; 'no such extension is asserted', strongly-rayleigh.tex:164-168). The input pointed at thm:main :54, but the relevant baseline is thm:sr-group. | Read Theorem 1/2 and Lemma 3 (zero cross covariance plus negative association implies block independence, a Newman-type fact). The full Brownian-drift construction was not checked. |

Main files:

- [`first-pass/covariance_symmetry/theorem.md`](first-pass/covariance_symmetry/theorem.md)
- [`first-pass/covariance_symmetry/Main.lean`](first-pass/covariance_symmetry/Main.lean)
- [`first-pass/covariance_symmetry/statement_fidelity.md`](first-pass/covariance_symmetry/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
