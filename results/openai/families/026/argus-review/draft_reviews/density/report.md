# Compatible density reduction: supported with the stated BV input

**Assessment.** `L026_DENSITY` v2 has a substantive arithmetic proof. Its unmarked part is elementary; its marked part uses exactly ordinary endpoint Bombieri--Vinogradov (BV), not a short-interval or two-prime distribution theorem.

## Exact scope and provenance

The context is `CTX026_MOMENTS` v1. Inherited proof: `families/026/first-pass/audit026/moments/verification.md`, section 2. Compare the manifest-matched OpenAI manuscript revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/03-moments.tex`, `lem:arithmetic-1` and `lem:arithmetic-2`, equations `eq:arithmetic-BV` through `eq:arithmetic-9`. This is a reconstruction of that arithmetic step, not a new distribution result.

Fix finitely many dimensions \(j_r\ge0\), bounded functions \(F_r\) on their nonnegative orthants, nonnegative budgets \(\rho_r\), and \(D>0,B\ge1\). Each \(F_r\) vanishes outside \(\sum_\ell v_\ell\le\rho_r\); scalar factors have budget zero. All these data and the equality pattern are fixed before integer \(X\to\infty\). Write \(L=\log X\), \(M=\sum j_r\), and \(\sigma=\sum\rho_r\). Distinct shifts, including the optional distinct prime mark, are integers with absolute value at most \(DL^B\). The arithmetic proof in fact also permits fixed \(B\ge0\).

For squarefree \(\mathbf d=(d_\gamma)\), let \(q=[d_\gamma]\), with \(q=1\) for the empty tuple. Compatibility means that selected shifts agree modulo every \(p\mid q\); with a mark, their common residue must differ from the mark's. Put
\[
 \rho_\delta(\mathbf d)=
 1_{\rm compatible}\prod_{p\mid q}(p-\delta)^{-1},\qquad
 A_\delta=\sum_{\mathbf d\ {\rm squarefree}}\rho_\delta(\mathbf d)
 \prod_\gamma\mu(d_\gamma)\prod_rF_r((\log d_{r,\ell}/L)_\ell).
\]
The assertion is, for every fixed \(N>0\), uniformly in these shifts,
\[
 \mathbb E_X[\chi_\delta\prod_rD_{F_r}]
 =A_\delta+O_N(L^{-N}),
\]
provided \(\sigma<1\) unmarked, or \(\sigma<1/2\) marked. Here the prime mark is \(\vartheta(m+a_0)\), without a factor \(1/L\).

## Decisive checks

Support gives \(\prod_\gamma d_\gamma\le X^\sigma\) and hence \(q\le X^\sigma\). There is one support budget per function, not per coordinate. CRT gives one residue class modulo \(q\) for a compatible unmarked tuple, with count \(X/q+O(1)\). For \(M\ge1\),
\[
 \#\{\mathbf d:\prod d_\gamma\le Y\}
 \le Y(1+\log Y)^{M-1}.
\]
Thus the normalized error is
\(O(X^{\sigma-1}(1+L)^{M-1}\prod_r\|F_r\|_\infty)\), which beats every logarithmic power. For \(M=0\) the unmarked identity is exact.

For the marked part let \(E_X(q)\) be the maximum theta-count error over all reduced classes and all allowed shifted endpoints. Apply endpoint BV separately at \(X\) and \(2X\). Removing proper prime powers costs \(O(X^{1/2}L^2)\) per class; translating endpoints costs \(O((DL^B+1)L)\). Summing those costs over \(q\le X^\sigma\) is absorbed by arbitrary logarithmic saving because \(\sigma<1/2\) is fixed. The same deterministic bound controls the maximum over shifts: no union bound over the shifts is required.

The extra divisor weights are justified, not assumed in BV. The trivial progression bound gives
\(E_X(q)\ll Xq^{-1}(L+d(q))\). For fixed \(T\),
\[
 \sum_{q\le Q}\frac{\mu(q)^2T^{\omega(q)}}q
 \le\prod_{p\le Q}(1+T/p)\ll_T L^{c_T}.
\]
The reciprocal-prime estimate follows from comparison with \(\log\zeta(1+1/\log Q)\), so no PNT is hidden here. On squarefree \(q\), \(d(q)=2^{\omega(q)}\). Cauchy--Schwarz between an arbitrarily strong unweighted BV saving and the polynomial-log bound with weight \(K^{2\omega(q)}\) gives
\[
 \sum_{q\le X^\sigma}\mu(q)^2K^{\omega(q)}E_X(q)\ll_N XL^{-N}.
\]
There are at most \((2^M)^{\omega(q)}\) divisor tuples with a fixed squarefree lcm \(q\). This proves the claimed total marked error.

A nonreduced prime class contributes exactly zero: a prime in it would divide \(q\) and so be at most \(q\), whereas \(m+a_0\ge X-DL^B>X^\sigma\ge q\) for large \(X\). On reduced classes \(1/\varphi(q)=\prod_{p\mid q}(p-1)^{-1}\), giving the displayed density. Negative shifts do not change these inequalities. In the wholly scalar marked case, \(q=1\) in BV supplies the error; there is no missing scalar exception.

## Primary source and inherited attribution

The explicit external assumption is `BV_DENSITY_ENDPOINT`, filed by `engineer:copilot-026-moments`, identity `54c4019fc98fdf50df05342e0e76ef5672b5686ce25e07b5541cc53f08795251`. It states: for each \(A>0\), some \(b(A)>0\) makes
\[
 \sum_{q\le x^{1/2}(\log x)^{-b(A)}}\max_{(c,q)=1}
 |\psi(x;q,c)-x/\varphi(q)|\ll_A x(\log x)^{-A}.
\]
This includes \(q=1\). The source is Bombieri, Friedlander and Iwaniec, *Acta Mathematica* 156 (1986), 203-251, DOI `10.1007/BF02399204`, printed p. 206 equation (1.4); \(\psi\) notation is on p. 204. That passage attributes the ordinary theorem to Bombieri and A. I. Vinogradov. It is not BFI's stronger large-modulus result.

The current Engineer extracted and read PDF pages 2-4 (printed pp. 204-206) of the inventory's `BFI1986.pdf`; the displayed range, reduced-class maximum, endpoint nature and von Mangoldt notation agree with the assumption. The weighted and shifted forms are deductions above, not words silently added to equation (1.4).

`BV_source_excerpt.md` is the inherited Engineer transcription. `reviewer_BV_excerpt.md` and `judgement-BV_DENSITY_ENDPOINT-7018a874b433` are an inherited independent reading of the same assumption identity. The ledger tier is **judgement**, not literature-tier `citation_check attribute`. No new native attribution record was created, and no registry lookup or formal proof of BV is claimed.

The current claim has inherited reviewer support `judgement-L026_DENSITY-845a5eac204b`, matching its present identity and the preserved prose proof. Versions 1 and 2 have identical statement hashes; adding assumption bookkeeping is not a second mathematical result. Graph labels and old "attribution outstanding" strings remain unmodified; they do not erase the inherited reading or constitute new approval.

**Remaining obligations.** No gap was identified in this reduction under its strict support inequalities and recorded BV theorem. The marked result remains dependent on that known external theorem, not kernel-certified analysis. Native independent review must assess the proof and source attribution; any required native literature-tier receipt is still distinct from the existing human receipt.
