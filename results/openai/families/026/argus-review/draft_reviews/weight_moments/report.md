# Weight moments: supported fixed-family transfer and detector bound

**Assessment.** `C026_WEIGHT_MOMENTS` v4 supports all the stated quadratic limits, the bounded fourth moment, and the family-independent limiting detector constant. It does not assert convergence uniform over changing families.

## Exact hypotheses, quantities and provenance

Context: `CTX026_MOMENTS` v1. Fix \(\lambda>0\), a positive integer \(k\), and \(\tau=1/8\). For \(1\le j\le k\), take real symmetric
\[
 f_j\in C_c^\infty(\{t_i>0:\ \sum_i t_i<\tau\});
\]
take a real scalar \(f_0\), and set \(f_{k+1}=F_{k+1}=0\). Define the cumulative \(F_j(v)=\int_{s_i\ge v_i}f_j(s)\,ds\), \(F_0=f_0\), and \(Tf_{j+1}(t)=\int_0^\infty f_{j+1}(t,u)\,du\). Norms are orthant \(L^2\) norms, with the scalar convention in dimension zero.

As integer \(X\to\infty\), put \(L=\log X\), \(h=\lfloor\lambda L\rfloor\), \(J=\{1,\ldots,h\}\), \(I=\{h+1,\ldots,2h\}\),
\[
 V_B=L^{-1}\sum_{b\in B}\vartheta(m+b),\qquad
 Z=\sum_{j=0}^k\sum_{\substack{S\subset I\\|S|=j}}D_{F_j}(m;S),
 \quad \alpha_j=\lambda^j/j!.
\]
The average is over \(X<m\le2X\), and the claim is
\[
 \mathbb E_XZ^2\longrightarrow w=\sum_{j=0}^k\alpha_j\|f_j\|_2^2,
 \quad \mathbb E_XZ^4=O_{\lambda,k,\mathbf f}(1),
\]
\[
 \mathbb E_X(Z^2V_J)\longrightarrow\lambda w,\qquad
 \mathbb E_X(Z^2V_I)\longrightarrow
 v=\lambda\sum_{j=0}^k\alpha_j\|f_j+Tf_{j+1}\|_2^2.
\]
Fix once and for all real \(G\in C_c^\infty(\mathbb R)\), \(G(0)=1\), \(G(u)=0\) for \(u\ge\tau\), and \(c_G=\int_0^\infty|G'|^2\). Then
\[
 \limsup_{X\to\infty}\mathbb E_X(Z^2V_J^2)
 \le(\lambda+\lambda^2c_G^2)w.
\]
This constant does not depend on \(k\) or \(\mathbf f\). Starting \(X\), rates and the fourth-moment constant may depend on the fixed family.

The statement is exactly OpenAI's `prop:weight-moments` in manifest-matched revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/04-weights.tex`; its proof is in `03-moments.tex`, `sec:weight-moment-proof`. The inherited Argus proof is `families/026/first-pass/audit026/moments/verification.md`, sections 7-8. This is a reconstruction, not an original prime-gap construction.

## Smoothness, summability and quadratic limits

Zero-extension of each interior-supported \(f_j\), cumulative integration, and smooth cutoffs below the orthant give compact smooth extensions of \(F_j\). On the orthant their simplex budget is \(\tau\); their signed complete mixed derivative is \(f_j\), which vanishes on every coordinate face. A budget is per function, not dimension times \(\tau\).

An equality pattern with \(t\) distinct unmarked shifts has \(O(h^t)\) assignments. Multiplying the mixed-moment error \(L^{-t-1/2}(\log L)^A\) by this count gives \(o(1)\). A distinct summed mark has \(O(h^{t+1})\) assignments and its \(1/L\) normalization gives the same conclusion. The stronger error also works but is not needed. The fixed family has only finitely many patterns, so no increasing-dimension limit is interchanged with \(X\to\infty\).

In \(Z^2\), a shift in the symmetric difference of its two subsets is a singleton. The derivative formula evaluates a complete derivative on a coordinate face, giving zero. Matching subsets of size \(j\) give coefficient \(\|f_j\|_2^2\). Their singular-series sum is \(1/j!\) times the ordered distinct \(j\)-tuple sum, so the box mean gives the limit \(w\). A prime mark in \(J\) is external to all weight subsets; the same argument gives \(\lambda w\).

For an internal prime mark \(a\in I\), the only nonzero divisor in that coordinate is 1, since \(m+a>X>X^\tau\). Deleting \(a\) from a containing subset is a bijection, not \(j+1\) choices. It replaces \(F_j\) by \(F_j+F_{j+1}(\cdot,0)\), whose signed derivative is \(f_j+Tf_{j+1}\). The singular-series sum over the mark and a surviving \(j\)-subset is \(1/j!\) times the ordered distinct \((j+1)\)-tuple sum **in \(I\)**. This avoids applying an interval-box theorem to the punctured noninterval \(I\setminus\{a\}\). The count \(h\binom{h-1}{j}/L^{j+1}\to\lambda\alpha_j\) gives \(v\), including the scalar term \(\lambda|f_0+\int f_1|^2\).

## Fourth moment and detector

Four factors permit equality fibers of size up to four. Their coefficients are finite by the general Fourier kernel, not by misusing the double-fiber derivative formula. For each fixed pattern, the sum of absolute main terms is bounded by a fixed coefficient times the nonnegative full box mean. Restrictions on the pattern only decrease that dominating sum; the total error is \(o(1)\). This proves the bounded fourth moment.

At a relevant prime, \(D_G(m;b)=G(0)-G(\log(m+b)/L)=1\). Write \(q_X=\log(2X+2h)/L\to1\). Pointwise, also at composites,
\[
 \vartheta(m+b)/L\le q_XD_G(m;b)^2,\qquad
 (\vartheta(m+b)/L)^2\le q_X\vartheta(m+b)/L .
\]
Since \(Z^2\ge0\), the diagonal of \(V_J^2\) is bounded by \(q_X\mathbb E_X(Z^2V_J)\). Its ordered off-diagonal is bounded by
\[
 q_X^2\sum_{\substack{b,c\in J\\b\ne c}}
 \mathbb E_X[Z^2D_G(m;b)^2D_G(m;c)^2].
\]
These are **unmarked six-factor** correlations. The two outside shifts are double fibers with coefficient \(c_G^2\); the weight subsets must match. The mixed box mean and
\(h(h-1)\binom hj/L^{j+2}\to\lambda^2\alpha_j\)
give off-diagonal limit \(\lambda^2c_G^2w\). Combining with the diagonal proves the exact limiting constant.

| Use | Mark count | Budget | Required strict bound |
|---|---:|---:|---:|
| Square | 0 | \(2\tau=1/4\) | \(<1\) |
| One marked square | 1 | \(2\tau=1/4\) | \(<1/2\) |
| Fourth moment | 0 | \(4\tau=1/2\) | \(<1\) |
| Detector off-diagonal | 0 | \(6\tau=3/4\) | \(<1\) |

No two-prime-mark asymptotic is needed; imposing its unavailable \(<1/2\) condition on the last row would be the wrong proof. If \(w=0\), all the continuous \(f_j\) and \(f_0\) vanish, hence \(Z=0\); no positive-mass assumption is missing.

## Evidence and remaining scope

Dependencies are the uniform-moment and box-mean units. The live external assumption `BV_WEIGHT_ENDPOINT`, identity `adfc3b52ba66ca6c8b6a4a146634efc9cd5a8d406da7abfa5c83eae15f0cea11`, is the same ordinary endpoint theorem as in the density report: BFI DOI `10.1007/BF02399204`, p. 206 (1.4), notation p. 204, originally Bombieri and A. I. Vinogradov. It is not a second independent distribution theorem.

Inherited reviewer receipts are `judgement-C026_WEIGHT_MOMENTS-7172d3d60840` and `judgement-BV_WEIGHT_ENDPOINT-15a26e6a622e`. Versions 1-4 have the same mathematical statement identity; bookkeeping included replacing a duplicate assumption ID, not removing reliance on BV. Version 1 recorded no assumption; v2 used the duplicated `BV_ENDPOINT`; v3 retired that ID with the explicit reason that the theorem remains a dependency under the new name; v4 records `BV_WEIGHT_ENDPOINT`. The intermediate empty lists are not unconditional proofs. The old graph remains pending; these human receipts are preserved but do not grant current native acceptance.

Fresh `../euler_core/finite_replay.json` reproduces the four rational budgets and 168 finite deletion cases. The unrestricted deletion claim follows from the displayed general bijection, and the asymptotic summation and analytic detector bound follow from the prose, not those finite cases.

**Remaining obligations.** No specific gap was identified for the fixed-family proposition. Selecting a family with small \(v/w\), the downstream conversion to ordinary prime-index density, and the manuscript's full main theorem are not proved by this unit. Increasing-family uniform rates, novelty and current independent acceptance are likewise not inferred.
