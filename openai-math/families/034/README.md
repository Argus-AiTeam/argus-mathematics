# 034. Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Constant (e+1)^b in nv:mixed-bound is optimal (P_{P^b}(O(1)+O^e), beta=xi+tH, t->0) | openai-math/preprints/Log-abundance-for-compact-Kahler-spaces-under-logarithmic-Iitaka-subadditivity-October-6-2026/build/sections/06-simple-nonvanishing.tex:530-552 nv:direct-image 'int_U beta^{b_0+e} <= (e+1)^{b_0} w vol(B_0)' | Rederived xi^{e+1}=H xi^e, w=1, B=(t+1/(e+1))H, int beta^{e+b}=sum_{i<=b} C(e+b,i)t^i; python exact check (e,b<=4) that ratio -> (e+1)^b and the inequality holds for t in a grid |
| A | PLAUSIBLE | Volume inequality extended from Kahler beta=f^*G+c1(Lambda) (rational Lambda) to every nef real (1,1)-class | same file :535-539 'beta=f^*G+c_1(Lambda) is a Kahler class, where ... Lambda in Pic(U)⊗Q' | Read Argus proof and the Argus second-pass review section 6: the splitting-free argument depends on a mixed Khovanskii-Teissier log-concavity I_k^2>=I_{k-1}I_{k+1} for nef classes on compact Kahler manifolds, whose cited source (Dinh-Nguyen) has a sign-convention problem; nef limit step OK |

Main files:

- [`first-pass/direct-image-volume/proof.md`](first-pass/direct-image-volume/proof.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
