# 285. Counterexamples to Baum–Connes and Kadison–Kaplansky.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Diagram constants: b<=4m-6 (vs b<=6m), fillings with 8n (vs 12n) relations, avoidance (4L-2)lambda sigma(P) (vs 12(L+1)lambda sigma(P)), overlap radius 16D0+30 (vs 48D0+108) | preprints/An-Irrational-Trace-Counterexample-to-Reduced-Baum-Connes-September-23-2026/build/geometry.tex:114 "(1/lambda-6)F<=6m-6, b<=6m", :203-206, :226 "d_P(x,a)<=12(L+1)lambda sigma(P)", :266-283 "at most 12n relation faces ... 2b<=12m<=12n"; same in A-Torsion-Free-Counterexample-to-the-Kadison-Kaplansky-Projection-Conjecture-September-23-2026/build/sections/geometry.tex:389-415 | Re-derived the Euler step by hand: v-b+F=1 and 2b>=3(v-M)+M give b<=3F+2M-3; F/lambda<=2b with lambda<=1/12 gives b>=6F; hence b<=b/2+2m-3, i.e. b<=4m-6; identity 4m-b-6 = 2(2m+3F-b-3)+(b-6F) checked algebraically. Then 2b<=8m<=8n follows exactly as in the manuscript. |

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
