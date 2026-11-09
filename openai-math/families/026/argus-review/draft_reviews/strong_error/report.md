# Stronger error: supported frequency-integrated strengthening

**Assessment.** `C026_STRONG_ERROR` v2 supports the proposed error \(O(L^{-t-1}(\log L)^A)\), not merely the manuscript's weaker \(O(L^{-t-1/2}(\log L)^A)\). The improvement is mathematical within this proof, not a verified novelty or publishability claim.

## Statement, quantifiers and comparison

Context: `CTX026_MOMENTS` v1. Fix the real compact-smooth-extension functions, dimensions \(j_r\ge0\), simplex budgets \(\rho_r\ge0\), coordinate equality surjection \(\kappa\), \(D>0\), and \(B\ge1\). Let \(M=\sum j_r\), let \(t\) count distinct unmarked shifts, and let the distinct integer shifts, including the optional distinct mark, vary subject to \(|a_i|\le D(\log X)^B\). Assume \(\sum\rho_r<1\) unmarked or \(<1/2\) with the single theta-weighted mark. Scalars have dimension and budget zero. The average and divisor sums are those defined explicitly in the uniform-moment report.

For all these fixed data, as integer \(X\to\infty\), \(L=\log X\),
\[
 \mathbb E_X[\chi_\delta\prod_rD_{F_r}]
 =L^{-t}\mathfrak S(\mathcal H)\mathcal C
   +O(L^{-t-1}(\log L)^A),
\]
uniformly in actual shifts. A finite \(A\) can be selected as a function of \(M\) alone; implied constants and the threshold \(X\) may depend on other fixed data. Arbitrary equality fibers, negative shifts and zero singular series are allowed.

Inherited proof: `families/026/first-pass/audit026/moments/verification.md`, sections 1, 4-5 and 9. The source-version comparison is against the manifest-matched OpenAI revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/03-moments.tex`, `prop:mixed-moments` and equations `eq:zero-safe-comparison`, `eq:zeta-kernel`. That version states an inner \(L^{-1/2}\) remainder and takes a core supremum. The Argus strengthening retains the frequency dependence of the same estimates.

## Decisive quantitative argument

With \(w_\gamma=1+iu_\gamma\), \(z_\gamma=w_\gamma/L\), put \(Z=\sum|z_\gamma|\). On \(\max|u_\gamma|\le\sqrt L\), the already assessed zero-safe product comparison gives
\[
 |\prod_pH_p(z)-\mathfrak S(\mathcal H)|
 \ll(\log L)^A(Z+L^{-B}),\qquad
 \mathfrak S(\mathcal H)\ll(\log L)^A .
\]
The finite zeta-product comparison retains the sharper relative error
\[
 \prod_pB_p(z)=L^{-t}K(w)(1+O_M(Z)),
\]
because each local Laurent remainder is \(O(|z_S|)\), and there are only finitely many subsets for fixed \(M\). On this core \(Z=O_M(L^{-1/2})\), so inverse Laurent factors also remain uniformly bounded; multiplying the two comparisons introduces no uncontrolled remainder.

The crucial improvement is not a bare replacement of \(L^{-1/2}\) by \(L^{-1}\). Instead,
\[
 Z\le C_M(1+\max|u_\gamma|)/L,\qquad
 \int_{\mathbb R^M}|\Phi(u)K(w)|(1+\max|u_\gamma|)\,du<\infty.
\]
The integral is finite because the transform is Schwartz and every general-fiber kernel has polynomial growth, its denominator subset sums having positive real parts. Integrating the actual frequency-dependent error, including the cross terms bounded on the core, gives
\[
 L^{-t}(\log L)^A
 \left[L^{-1}\int|\Phi K|(1+\max|u|)
       +L^{-B}\int|\Phi K|\right]
 =O(L^{-t-1}(\log L)^A).
\]
Here \(B\ge1\) is used explicitly. The collision cutoff \(Y=\max(2,2DL^B)\) has \(\log Y=B\log L+O_D(1)\); \(B,D\) affect constants, not the exponent determined by the finite local algebra.

The tails discarded using the unsigned Euler-product bound, the tails of the limiting kernel integral, and the density-reduction error are \(O_N(L^{-N})\) for arbitrary fixed \(N\). Choosing \(N>t+2\) absorbs them. No relative error at a zero singular series is introduced. In the all-scalar case \(t=M=0\), the unmarked identity is exact and the marked \(q=1\) BV error beats every logarithmic power.

Thus the gain relative to the strongest relevant manuscript statement is a factor \(L^{-1/2}\), up to a possibly changed finite logarithmic exponent, under the same \(B\ge1\) hypotheses. It is already present in the strongest inherited Argus draft; this review verifies that argument rather than claiming a new improvement over that draft.

## Evidence, assumptions and unresolved scope

Dependencies are the density and Fourier units. `BV_REFINEMENT_ENDPOINT`, identity `86061ef2ff2f4c501fe1d68723024dc126dd1e391d181fff4208d1e0795fca56`, is ordinary endpoint BV, including \(q=1\), recorded from BFI DOI `10.1007/BF02399204`, p. 206 (1.4), notation p. 204. Its attribution is to Bombieri and A. I. Vinogradov, and its weighted/shifted use is justified in the density unit. It is not an enhanced distribution theorem.

Inherited reviewer support is `judgement-C026_STRONG_ERROR-3cb62e9eda46`; source-reading support is `judgement-BV_REFINEMENT_ENDPOINT-e4e150ab3279`. Versions 1 and 2 have identical mathematical statement hashes. The preserved prose and current assumption identities match those subjects. The graph remains pending and no native literature-tier receipt was manufactured.

Finite symbolic examples and the local Lean certificate do not prove the Schwartz seminorm estimate. That estimate, the uniform local differentiation, and the error integration above are the substantive prose assessment; merely replaying the old certificate's `quantitative_refinement` string would not suffice.

**Remaining obligations.** No concrete gap was identified in the claimed fixed-data strengthening. No \(B<1\), growing-family rate, best-possible logarithmic exponent, novelty, significance, or full prime-gap theorem is inferred. Native independent review must examine the retained frequency dependence and integrability, not approve only the weaker bound.
