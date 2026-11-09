# 318. Chromatic splitting: filtrations and counterexamples.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | At p=5 the unit L_2 S -> L_2 L_K(3) S has no retraction (weak chromatic splitting fails at (n,p)=(3,5)) because tau is nonzero on pi_-3 | A-rational-obstruction-to-strong-chromatic-splitting-at-height-three-September-25-2026/build/sections/01-introduction.tex:36-42 thm:main (tau_{L_K(3)S} nonzero on pi_-3, p>=5), and :97-98 "The existence of a retraction of the canonical unit in weak chromatic splitting remains a separate question." | Re-derived by hand. OpenAI's filtration (The-height-three-chromatic-overlap...Sept-27, thm:main, p>=5) K(2)-localizes to a cofiber sequence R -> L_K(2)X -> Sigma^-1 R with the unit first. pi_-3 L_0 Sigma^-1 R = pi_-2 L_0 R = 0 (BSSW: degrees 0,-1,-3,-4), so tau_X(x) = L_0L_K(2)u(y) with y != 0. A retraction r gives y = L_0L_K(2)r(tau_X x) = tau_A(L_0 r x) in pi_-3 HQ_p = 0, a contradiction. |
| A | DOWNGRADED | Vanishing line H^s(G_5;(E_5)_q)=0 for s>25 (tail F^26 rather than 27); beta_1^m kernel range 13..16 | Weak-splitting manuscript (Counterexamples-to-weak-chromatic-splitting...Sept-27) height-five filtration input (m=16 named) | Recalled the standard fact: at p=5, n=5, p-1 does not divide n, so S_5 is torsion-free with cd = n^2 = 25 (Lazard/Morava). |
| A | DOWNGRADED | Generation level of L_2L_K(3)S relative to A_2 v A_1 v HQ_5 is exactly 2 | prime-five overlap (no explicit OpenAI statement of level) | Checked MATH_STATE: C318LEVELCZERO (c=0) is mixed/inconclusive, and Argus earlier claimed and refuted level 3. |

Main files:

- [`first-pass/rational-unit-obstruction/proof.md`](first-pass/rational-unit-obstruction/proof.md)
- [`first-pass/generation-level/degree-five/proof.md`](first-pass/generation-level/degree-five/proof.md)
- [`first-pass/prime-five-height-three/proof.md`](first-pass/prime-five-height-three/proof.md)
- [`first-pass/prime-five-kernel/proof.md`](first-pass/prime-five-kernel/proof.md)
- [`first-pass/coheight-two-unit/proof.md`](first-pass/coheight-two-unit/proof.md)
- [`first-pass/generation-level/proof.md`](first-pass/generation-level/proof.md)
- [`first-pass/coheight-two-unit/support/Main.lean`](first-pass/coheight-two-unit/support/Main.lean)
- [`first-pass/coheight-two-unit/ordinary/Main.lean`](first-pass/coheight-two-unit/ordinary/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
