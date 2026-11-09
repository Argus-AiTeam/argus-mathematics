# Conditional uniform missed-prime bridge

**Assessment: supported conditional written proof of the bound and its sharper stabilizer expression, not verification of the full manuscript.** This is `C_UNIFORM@v1`, assembled from the four separately assessed lemmas. The old `reviewer:copilot` supports judgement and four supporting-lemma judgements are substantive prior evidence. The old proof graph's unchanged `open`/`reviewer_confirmed=false` labels neither erase that evidence nor upgrade it to a kernel proof.

## Exact question and source fidelity

Let \(B=\mathbb Q(i)\), \(f:G_K\twoheadrightarrow P_B\) be continuous, and \(\ell\) odd with
\(\log(\chi_\ell f)=\log\chi_{K,\ell}\). With \(\epsilon=(\chi_\ell f)/\chi_{K,\ell}\), \(F=\overline K^{\ker\epsilon}\), and missed primes defined by the absence of an \(\ell\)-active source partner,
\[
 \#\{w\text{ missed}:w\nmid\ell\}
 \le r_{1,\mathrm{split}}(F/K)+r_2(K)+g_{\ell,\mathrm{split}}(F/K)
             -[\epsilon=1]
 \le 2[K:\mathbb Q].
\]
At most two primes of \(B\) lie above \(\ell\), giving the total \(2[K:\mathbb Q]+2\).

The primary manuscript is OpenAI, *Open Homomorphisms of Global Solvably Closed Galois Groups*, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`. Its `generation.tex`, `thm:normalized-map`, constructs a surjection \(G_k\to P\) and asserts logarithmic compatibility at every odd \(\ell\equiv1\bmod[k:\mathbb Q]!\). In `matching.tex`, lines 5-10, \(G_K=\beta^{-1}(P_B)\), \(K/k\) is quadratic, and \(\beta_B\) is its surjective restriction. `prop:uniform-missed-primes`, lines 81 onward, states the two coarser inequalities above.

Thus the bridge faithfully proves the missed-prime proposition **if** the normalized-map hypotheses hold. It does not construct that map, prove that eligible primes exist, or establish the logarithm-rank and generation results used to normalize it. Logarithmic equality permits a nontrivial finite twist; full cyclotomic equality is not silently imposed.

## Assembly of the written proof

For any finite set \(J\) of missed primes away from \(\ell\), diagonal Kummer valuations give \(|J|\) independent classes. Pullback/restriction preserves that independence and places them in the \(\epsilon^{-1}\)-eigenspace over \(F\). Uchida's local odd-prime case makes them unramified away from \(\ell\), even if \(F/K\) is ramified. The completed S-unit identification and exact stabilizer multiplicity bound that eigenspace by the displayed integer. Since every finite \(J\) satisfies this bound, so does the full missed-prime set. This last finite-subset argument is what turns a finite-class independence argument into a cardinality assertion.

Writing \(d=[K:\mathbb Q]\), \(r_s=r_{1,\mathrm{split}}\), \(g_s=g_{\ell,\mathrm{split}}\), \(g=g_\ell(K)\), and \(\delta=[\epsilon=1]\), the draft's identity is
\[
 2d-(r_s+r_2+g_s-\delta)
 =(d-r_1-2r_2)+(d-g)+(r_1-r_s)+(g-g_s)+r_2+\delta.
\]
The first term is zero and the rest are nonnegative. It uses only \(d=r_1+2r_2\), \(r_s\le r_1\), and \(g_s\le g\le d\). There is no bound on \([F:K]\) in the final expression and no finite-support or Leopoldt shortcut.

The external inputs are exactly finite Kummer theory (Stacks tag 03PK/03PL), finite class number (Milne ANT v3.08, Theorem 4.4, p. 70), S-unit finite generation and the equivariant unit representation (Bass, DOI `10.1017/S0027763000026258`, Section 3), and Uchida's **local** case (DOI `10.2969/jmsj/03340595`, pp. 595-596). The separate lemma reports reconcile their archived reviewer excerpts and precise hypotheses. Global cofinite coverage from Uchida Proposition 1 is not an input.

## Fresh replay and actual toolchain

The old `verify.py` was read in full before execution. It reads the saved certificate and typed evidence, computes exact rational residuals, tests arithmetic fixtures, and deliberately corrupts 16 inputs. It does not write into the old workspace.

The mandated legacy interpreter initially failed because it lacked SymPy; the actual traceback is retained in `replay_initial_failure.json`. This was an environment failure, not a mathematical objection. A fresh run using the **same required interpreter and script**, with the already installed live-update SymPy exposed explicitly, succeeded:

```bash
PYTHONDONTWRITEBYTECODE=1 \
PYTHONPATH=$WORKSPACE/argus-live-update/.venv/lib/python3.13/site-packages \
$WORKSPACE/argus-latest/.venv/bin/python \
families/031/first-pass/verify.py
```

`replay.json` preserves the exact command, working directory, environment, stdout, stderr, exit **0**, and toolchain: **Python 3.13.5, SymPy 1.14.0, mpmath 1.3.0**. No packages were installed and no shared environment was changed. The result is **33 exact checks**, including **7 arithmetic boundary fixtures**, and **16 invalid certificates rejected**. The unchanged successful suite was not rerun.

The built-in rejections cover the forward/inverse twist, averaging sign, diagonal recovery, class transition, geometric successor, cyclic recurrence, both augmentation corruptions, quadratic norm, a negative multiplier, a wrong boundary dimension, a wrong signature weight, a wrong Bezout coefficient, an unsupported AST expression, a corrupted typed output and an adapter-timeout status. A returned count of 16 with exit zero means every built-in reject branch fired; it is not a claim that arbitrary false proofs are rejected.

The fixtures cover trivial twists over \(\mathbb Q\) and \(\mathbb Q(i)\), real versus complex places, splitting/inertia/ramification at \(\ell\), and twist ramification away from \(\ell\). They check the unit formula for those fields. They are **not** counterexamples, nor constructions of maps with those twists.

## What remains unproved here

The local replay validates algebra, not the cited arithmetic theorems, the existence of the normalized map or the manuscript's remaining character, matching and identification arguments. Its verification of saved Jacobian output is not a fresh server run; the separate fresh operation is documented in the multiplicity unit and has the same limited algebraic scope. No Lean theorem or compiler certificate exists in the supplied evidence; exact theorem fidelity was checked in prose against the manuscript statement, not inferred from compilation.

Relative to the strongest prior result, this review makes **no new mathematical improvement**: it retains the already reviewer-supported conditional stabilizer bound, supplies fresh replay and complete version/dependency reconciliation, and prevents its promotion to a full-manuscript or novelty certificate. Native independent acceptance of this review package remains outstanding.
