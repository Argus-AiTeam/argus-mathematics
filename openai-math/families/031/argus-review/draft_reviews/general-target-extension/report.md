# Extension to a finite target field

**Assessment: supported as a conditional scope extension, not as an unconditional theorem about arbitrary targets.** The claim `EXT_TARGET` is the closing paragraph of Section 4 in old `uniform_kummer_bridge.md`; it has no separate claim version or reviewer judgement in the old ledger. The old review of `C_UNIFORM` must therefore not be represented as a separate review of this extension.

## Exact reading

Replace \(B=\mathbb Q(i)\) by a **number field \(N\subset\mathbb Q^s\)** and take a continuous surjection
\(f:G_K\to P_N=\operatorname{Gal}(\mathbb Q^s/N)\). Retain odd \(\ell\), logarithmic compatibility, the finite twist \(\epsilon\), and the same definition of missed primes at the \(N\)-level. Then the away-from-\(\ell\) stabilizer bound is unchanged:
\[
 \#\{w\text{ missed in }N:w\nmid\ell\}
 \le r_{1,\mathrm{split}}(F/K)+r_2(K)
       +g_{\ell,\mathrm{split}}(F/K)-[\epsilon=1]\le2[K:\mathbb Q].
\]
The total bound is \(2[K:\mathbb Q]+g_\ell(N)\), not necessarily \(2[K:\mathbb Q]+2\).

This interprets "the same proof" as retaining its hypotheses, not as deducing cyclotomic-logarithm compatibility for every open homomorphism. The simultaneous open-map weakening is assessed separately.

## Check of the changed steps

The only use of class number one in the original setup is dispensable. For each prime \(w\) of \(N\), finite class number gives a positive \(h_w\) with \(w^{h_w}=(a_w)\). Valuation independence is over \(\mathbb Q_\ell\), so no uniform bound or \(\ell\)-coprimality of \(h_w\) is needed.

The Kummer classes still factor through \(P_N\). A finite subfield of \(\mathbb Q^s\) has a finite solvable normal closure over \(\mathbb Q\). After adjoining the necessary roots of unity and radicals, and the finitely many conjugates over that closure, the resulting Galois group remains solvable. Compatible radical choices therefore lie in \(\mathbb Q^s\). This is precisely where \(N\subset\mathbb Q^s\) matters; the extension is not a statement with this same target group for an arbitrary number field outside it.

Uchida's local input applies to \(\mathbb Q^s/N\) and an open-image map, not only to \(\mathbb Q^s/\mathbb Q(i)\). In the ramification contradiction, a nonmissed target prime \(t\) is again distinct from the chosen missed \(w\). The source-side completion, inverse twist and stabilizer counts depend on \(F/K\), not on the target's signature. Nothing in that argument requires \(N\) to be totally imaginary or Galois over \(\mathbb Q\). Finally the number of excluded target primes above \(\ell\) is exactly bounded by \(g_\ell(N)\); retaining the numeral 2 for a general target would be unjustified.

## Sources, evidence and limits

The reference context is OpenAI, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/preliminaries.tex`, the conventions for \(P_N\), `lem:solvable-closure` and the local portion of `thm:local-correspondence`. The specialized proposition being reproduced is `matching.tex`, `prop:uniform-missed-primes`; the general-target sentence is an Argus proposed strengthening, not that proposition's literal statement.

External assumptions remain finite Kummer theory, finite class number, the S-unit theorem and Uchida's local case, with the exact source identifiers and locators in the four core assessments. The existing replay is reusable only for the unchanged algebra. Its \(\mathbb Q\)/\(\mathbb Q(i)\) arithmetic fixtures do not independently test all targets \(N\), and the one Jacobian product proves no target-field assertion. There is no Lean compilation or formal statement here.

No mathematical obstruction was identified under this explicit reading. Map existence and logarithmic compatibility are hypotheses still to be supplied in any application; the draft's one-line extension does not establish them or the manuscript's main theorem. This fills out the already proposed extension's justification rather than undertaking a new research claim or novelty search.
